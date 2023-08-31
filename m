Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A96778E8A6
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 10:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239580AbjHaIqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 04:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242719AbjHaIqB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 04:46:01 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE83CF4
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 01:45:54 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-401187f8071so3089135e9.0
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 01:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693471553; x=1694076353; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZZ+yS+F58ugHAlTKRPgu0kDyKeO8Xi8M/RaN8CDHdU4=;
        b=NFQER+MVp3uKvqO9M+QMHbWlPKTnLBLjOqAeuYswCtHUNw0btHne34/4OX4TmWZiY/
         F3qSQ5Msb2ZzyQpdtFx82XvnKjLJwtqTBN9HczMG6yBtayqkpj6wrqZ0H6Xo8YIQzpqu
         sXYSGBOMVOEtv5hcFU21P8G6MsXKIi0ear745lXUEEq3I1/FfpTwns9SZ0vreIU8pgX/
         kd4EbYXeikRWNjJhsg8teMOpnDTchDMWTjmwqUlJFk//8rSz15f/nDB0GICIy4+51FkW
         nPJr6+wytXFom/n1NxHe8eps+pUp6TkRbaRYu/H1VhJ9vFrFCLXt+FoDtJVnJDyXkVwm
         2CVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693471553; x=1694076353;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZZ+yS+F58ugHAlTKRPgu0kDyKeO8Xi8M/RaN8CDHdU4=;
        b=V4SF4EXwMxjjBHUPF3EHqDn4jMnWYtZQXyEJzZ796Pw36VXN3Gwe0GLnz5y+PllwTy
         JS1BtPx0bL0xvpaJf5Y9BF8XtzGDoUda+4iV6hMjpypswtGNC4BDHtvr0mkiaKmHnWPa
         7XEUsJtx3V/HGFUr/6GH9J53gF12b1AW9HSrUi8fr+5cayyykjd/WoCBBirKD7CMeYGB
         ukQgJARwX9gLWQeqz/+o3OF1w0hKWnQEW0Ki1B3n0ITCT3UKfkrQQTNmlz+NX9NboINz
         T+QEUf9NfUzKi4+wpcZlmB0UYRUDW2ZIPyj2bn+7x4f4X/n9tXa4fih6LhwqPld5md+Z
         rp7w==
X-Gm-Message-State: AOJu0Yz2yWD+DA2vPJpU9RWAA9qMoOjb15bvnE3z4aDT9lO3U2WWgTkT
        Gql5QFqZllSnU9bDEVgpzs4Zd9rjk6/QGgs0NoRaXA==
X-Google-Smtp-Source: AGHT+IGFxJLXuR+da13QNbYWUX8dvbC9JAb+ODYlVceGovcYhI03utBPdqMMrKxTGZuEjaSZwqcNGg==
X-Received: by 2002:a7b:c84f:0:b0:401:b504:b6a8 with SMTP id c15-20020a7bc84f000000b00401b504b6a8mr1476717wml.2.1693471553037;
        Thu, 31 Aug 2023 01:45:53 -0700 (PDT)
Received: from [192.168.69.115] ([176.187.199.245])
        by smtp.gmail.com with ESMTPSA id c20-20020a7bc854000000b003feef5b0bb7sm1241764wml.40.2023.08.31.01.45.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Aug 2023 01:45:52 -0700 (PDT)
Message-ID: <205cfbcb-a989-dc72-8f5d-46d2a00b01d9@linaro.org>
Date:   Thu, 31 Aug 2023 10:45:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v2 1/3] vfio: trivially use __aligned_u64 for ioctl
 structs
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org
Cc:     David Laight <David.Laight@ACULAB.COM>,
        linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <20230829182720.331083-1-stefanha@redhat.com>
 <20230829182720.331083-2-stefanha@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230829182720.331083-2-stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/8/23 20:27, Stefan Hajnoczi wrote:
> u64 alignment behaves differently depending on the architecture and so
> <uapi/linux/types.h> offers __aligned_u64 to achieve consistent behavior
> in kernel<->userspace ABIs.
> 
> There are structs in <uapi/linux/vfio.h> that can trivially be updated
> to __aligned_u64 because the struct sizes are multiples of 8 bytes.
> There is no change in memory layout on any CPU architecture and
> therefore this change is safe.
> 
> The commits that follow this one handle the trickier cases where
> explanation about ABI breakage is necessary.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>   include/uapi/linux/vfio.h | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

