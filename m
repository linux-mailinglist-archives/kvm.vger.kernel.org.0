Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 982A06D5EE7
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 13:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbjDDLYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 07:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234681AbjDDLYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 07:24:51 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB951FEE
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 04:24:50 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id j24so32464614wrd.0
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 04:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680607489;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N87mk8mRdOayl+ChZVFIelbjG/oXWu2x7UlDEIktud4=;
        b=Lhmagjj7NuCmNr9lXMkd6xtkZPotwRC9N8Xcabq7EJPqwjbhmhm42DMK2OqXQXSiLd
         D9HxaYrlYDcExj7pm9OJoXeTk8vxbBS35lQwpkhHkwCaRzOw9iPlZDRxDbGlUhzUA9Zx
         ikMNvPvd7RUfatGO99YYgixg6Lx62C002tpik4X0BM5jUGReTVlljPhIfhS7zitiz9j8
         XiMBbo+gTyScKATMNWpw20CGJ4IOjcEfNS51A1CfXI/QdbggIGFQEMfCvb0RoW/6QsFL
         5n5i1Xs5yQYFp+Un1+H0YUz3c02649NiWpjDXcdNl9K+44rE/bBnrQydsL9eVbmDlctU
         /YVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680607489;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N87mk8mRdOayl+ChZVFIelbjG/oXWu2x7UlDEIktud4=;
        b=Y9wVqUFxdNv09bfrsth1gKr2pZhB2dQQ9DgP0utAVHZDiuKO37tICtzG7CUz7JEpF4
         pmIpz8qYIC1kuOLl8KIQvi8Q/yrNm2BlDodl4YWlgR6TdHrfj5f9Acwr8XooXXzkfiqo
         36bojbPujG3c5gREO18pzv+IQeXS7Oqao4qWrel1ka+0eTcwlb+dWYDzWG0M6H3Zy6ip
         nyYP48D0bfPXoebXLUhuasLqS4okqgqtPxQupWvqshRXcD79ByCeA4f/mLXkI0FFsle1
         vAPJ1Lm5ug9LINKyJuESz+HHGVNBkJy1Fd/UQ07yD+hucFVNahA6ZoG1BqjL4BAJVwqJ
         mebQ==
X-Gm-Message-State: AAQBX9cSmDGzFSOqO4J+2QfVciyzOocIsmyGzDPM6DezHU6gOzykNz98
        cVC9vb3RidgPSSxLvyI8EQ7LTg==
X-Google-Smtp-Source: AKy350bmUJLylVHqUnD5hN8Q9rm7xsIhoB5PavXlWhfUWYsXikCRIOibm3MeKksjOnaxzIPlkGXpBg==
X-Received: by 2002:adf:ed81:0:b0:2e6:ba1a:8d8 with SMTP id c1-20020adfed81000000b002e6ba1a08d8mr1431350wro.41.1680607489516;
        Tue, 04 Apr 2023 04:24:49 -0700 (PDT)
Received: from [192.168.69.115] (gra94-h02-176-184-53-13.dsl.sta.abo.bbox.fr. [176.184.53.13])
        by smtp.gmail.com with ESMTPSA id d9-20020adff849000000b002c56af32e8csm12074373wrq.35.2023.04.04.04.24.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 04:24:49 -0700 (PDT)
Message-ID: <72fdb847-46ec-93e3-dc55-2e87ac96367c@linaro.org>
Date:   Tue, 4 Apr 2023 13:24:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH v2 09/11] tests/vm: use the default system python for
 NetBSD
Content-Language: en-US
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Ryo ONODERA <ryoon@netbsd.org>, qemu-block@nongnu.org,
        Hanna Reitz <hreitz@redhat.com>, Warner Losh <imp@bsdimp.com>,
        Beraldo Leal <bleal@redhat.com>,
        Kyle Evans <kevans@freebsd.org>, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Cleber Rosa <crosa@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
References: <20230403134920.2132362-1-alex.bennee@linaro.org>
 <20230403134920.2132362-10-alex.bennee@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230403134920.2132362-10-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/23 15:49, Alex Bennée wrote:
> From: Daniel P. Berrangé <berrange@redhat.com>
> 
> Currently our NetBSD VM recipe requests instal of the python37 package
> and explicitly tells QEMU to use that version of python. Since the
> NetBSD base ISO was updated to version 9.3 though, the default system
> python version is 3.9 which is sufficiently new for QEMU to rely on.
> Rather than requesting an older python, just test against the default
> system python which is what most users will have.
> 
> Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Message-Id: <20230329124601.822209-1-berrange@redhat.com>
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Message-Id: <20230330101141.30199-9-alex.bennee@linaro.org>
> ---
>   tests/vm/netbsd | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)

Tested-by: Philippe Mathieu-Daudé <philmd@linaro.org>

