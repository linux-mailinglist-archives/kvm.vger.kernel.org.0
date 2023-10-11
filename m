Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E387C47ED
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 04:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344874AbjJKCol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 22:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344853AbjJKCok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 22:44:40 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9B4B0
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 19:44:38 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9b64b98656bso1073768266b.0
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 19:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696992277; x=1697597077; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0r+nZWjXBLko/PJ79KzGJfGzh06JS4c3rSs5rvlxLDw=;
        b=Sy0A5zUK5WWDElGDD326JlLdFpXnwYyo6o91ncEDpgL3/u54DoS0bHhRynsRgs7o/O
         cgurQkWET/+5SF4X2QcoH0PKuK0PmNluA+qIXbVpCH/+VDbMbzFdt2PCyzmJT2ZXYd05
         +4IAD48B+LGn4uU40sKJngrB/8lkx9D6hsT8FRDV55AdqbYJMwtlrUZM7m+OQvoHs22o
         DLOhBBtcGBdyfCJzcKUMxXWTZUkVUmcmIEbEkQ1keRro2cxPg6IIeQXrD4ING1HbbBdk
         PTUawHmnfwiDaLFUXWAZ+0/dI7H87gDo3juSdfwJVm8Ico1aTaJhxq5yKJlMh1Bl2/n8
         0C3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696992277; x=1697597077;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0r+nZWjXBLko/PJ79KzGJfGzh06JS4c3rSs5rvlxLDw=;
        b=C+ruScf9W63qBQTOZw6VlSTHlf4a+/lSgTLte4NAZNZPyIQxaVnd10cOGX2BWPqHsg
         C6OmyQWWIRdNxgu7B7Brpq9lHH0xCAjIrxQHWAYP0wGgHqepSyQ5ApSAZZr64mbbGF1G
         5VbfZirdKQ8S1vhFI05HH+0GZeEyZT4UAG19vCVQdTKowWbkZtMnqJnhSUBA31JAA3a5
         +8uywA4SXUkbDhcuOy1G+RXqaa8TuLIwpBmhldZyB0HL0kxZX8WFgzOVZ0Cs1I+Hss9x
         LY+VQKG5GxTCO9I1gYK0iSI+UKop4V2Bj75BV4djIjmNlxJ9pPPr6eFHpaEP5uN7TREl
         F01g==
X-Gm-Message-State: AOJu0YzHB9RBShJsk7rhWeUzhyKiolyeI37TS6EwoOMoM0T9FF40XUxs
        gCoZq44aQT3ClCbItgu69wRxaA==
X-Google-Smtp-Source: AGHT+IHn5OjHsqC+pVhmsNeJfFsxD6RA15qMrzm8K/7dPbCAKIz/7HIjI++t9SZcxMCe+yc7oUTVag==
X-Received: by 2002:a17:906:3012:b0:9a2:225a:8d01 with SMTP id 18-20020a170906301200b009a2225a8d01mr17885725ejz.7.1696992277404;
        Tue, 10 Oct 2023 19:44:37 -0700 (PDT)
Received: from [192.168.69.115] (mdq11-h01-176-173-161-48.dsl.sta.abo.bbox.fr. [176.173.161.48])
        by smtp.gmail.com with ESMTPSA id gq7-20020a170906e24700b009adc5802d08sm9208149ejb.190.2023.10.10.19.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Oct 2023 19:44:37 -0700 (PDT)
Message-ID: <e3e0a6c6-8125-f010-de73-7fb3ce2d8a88@linaro.org>
Date:   Wed, 11 Oct 2023 04:44:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v2 2/3] arm/kvm: convert to kvm_get_one_reg
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Gavin Shan <gshan@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20231010142453.224369-1-cohuck@redhat.com>
 <20231010142453.224369-3-cohuck@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20231010142453.224369-3-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/10/23 16:24, Cornelia Huck wrote:
> We can neaten the code by switching the callers that work on a
> CPUstate to the kvm_get_one_reg function.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   target/arm/kvm.c   | 15 +++---------
>   target/arm/kvm64.c | 57 ++++++++++++----------------------------------
>   2 files changed, 18 insertions(+), 54 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

