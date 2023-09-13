Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6236979E353
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 11:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239426AbjIMJP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 05:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239344AbjIMJPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 05:15:35 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86A119AB
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 02:14:57 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 46e09a7af769-6c21b2c6868so663045a34.1
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 02:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694596497; x=1695201297; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G3w5yIpwhY+I6554KNWUDhdjV7BQ5x1Kg/Kbnew7tEk=;
        b=apvLGFze8yeYuXJISdCBRLZ14ZUdeAFZYoXCpWq1CXLmEjcb/3aQ1NLuEBGYE0B5O4
         VJMukpHAPqXiK7lHcWjGbLL9uGQKc8Grk7HQJUc1oMlDyZ36v8w2h7eeAmT/4mOfZXJj
         5DuuZllV6oAu/zDjuVx5NQ4DkvxjfocaeoSp8d2CCWtzoLcHNcqDQfL8VgcDyqSyqGUV
         SE0H9wrzMa27AKBqyPiKEkFwb2MLjNKbHnRo3Ad8ie4BHdXFHcXtABYF+nmhDAUYTMXO
         UkBAL6ghzMRbQZNZdLAOS8aJ7q5pNnrrR8tTseHuw1GpHYIkaogxSpAgzo7gOh3lAj3u
         I+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694596497; x=1695201297;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G3w5yIpwhY+I6554KNWUDhdjV7BQ5x1Kg/Kbnew7tEk=;
        b=oD8mSSnjZ+i1j6Nih94+VJQL0LWAhTZImVgi8IvWXZflcT+SQbGFzknMHJ9MntRFhT
         zukBuQzdOwN9G0XYgNolIoFtkj0sEKqLVpmApF7Eo7Kx0HrBnv0OBGHK8eHcmZYB+XvJ
         GzHL8tOn+wSjSKLVohqWRy7+6xcEOhoCzp3BA/DZvRwxxqh72jwbxBTBFRoYjGJSmmJ6
         S7NBeFrcuazNTY6/8I3PgFo6VmPJkWJoZsCJ3xBSSKI1QK6jidy+A9/DasUb6k05b/7+
         ZOJfqDPwvzAz1pecrD3Bv13WbAA0CJpMOZYB5Jt4/FBJ73kUDt9j2gEsLvp0AWujTdPT
         7pyg==
X-Gm-Message-State: AOJu0YyBpmzD905xT/m7e+v7Kq3RZDvEgsmZIRAoj5paXYF7dTB1VXVU
        w1vPA9MhFNEMPyFZonhlgGs=
X-Google-Smtp-Source: AGHT+IFGkyvWdDB3ZCQ/uHBly/7wo13+AsvoNYqSa8U34IEVGJ4FgTHUxXJZZEk2mGUPceo5gjUA6Q==
X-Received: by 2002:a9d:65d7:0:b0:6b8:9932:b8ad with SMTP id z23-20020a9d65d7000000b006b89932b8admr2124323oth.1.1694596497177;
        Wed, 13 Sep 2023 02:14:57 -0700 (PDT)
Received: from [192.168.68.107] ([177.9.182.82])
        by smtp.gmail.com with ESMTPSA id x6-20020a05683000c600b006b9ad7d0046sm4733699oto.57.2023.09.13.02.14.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Sep 2023 02:14:56 -0700 (PDT)
Message-ID: <014ba528-db84-3a81-f2c1-0306965d40b9@gmail.com>
Date:   Wed, 13 Sep 2023 06:14:48 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 4/4] target/ppc: Prohibit target specific KVM prototypes
 on user emulation
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        qemu-ppc@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Michael Tokarev <mjt@tls.msk.ru>, Greg Kurz <groug@kaod.org>
References: <20230912113027.63941-1-philmd@linaro.org>
 <20230912113027.63941-5-philmd@linaro.org>
Content-Language: en-US
From:   Daniel Henrique Barboza <danielhb413@gmail.com>
In-Reply-To: <20230912113027.63941-5-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/12/23 08:30, Philippe Mathieu-Daudé wrote:
> None of these target-specific prototypes should be used
> by user emulation. Remove their declaration there, so we
> get a compile failure if ever used (instead of having to
> deal with linker and its possible optimizations, such
> dead code removal).
> 
> Suggested-by: Kevin Wolf <kwolf@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---

Reviewed-by: Daniel Henrique Barboza <danielhb413@gmail.com>

>   target/ppc/kvm_ppc.h | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
> index 440e93f923..ffda8054b2 100644
> --- a/target/ppc/kvm_ppc.h
> +++ b/target/ppc/kvm_ppc.h
> @@ -13,6 +13,10 @@
>   #include "exec/hwaddr.h"
>   #include "cpu.h"
>   
> +#ifdef CONFIG_USER_ONLY
> +#error Cannot include kvm_ppc.h from user emulation
> +#endif
> +
>   #ifdef CONFIG_KVM
>   
>   uint32_t kvmppc_get_tbfreq(void);
