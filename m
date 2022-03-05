Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8964B4CE488
	for <lists+kvm@lfdr.de>; Sat,  5 Mar 2022 12:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbiCEL0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 06:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiCEL0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 06:26:10 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92133FBD7
        for <kvm@vger.kernel.org>; Sat,  5 Mar 2022 03:25:20 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id cx5so9407001pjb.1
        for <kvm@vger.kernel.org>; Sat, 05 Mar 2022 03:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AJ75C0Tn6euvXAljkSJPwcS/hlE2vhaVqNrdp4DgqTU=;
        b=ADQTSSLQBFn5O4XMkaNgtigswftqP/LXC492XN2SWDB79YniwO5zys2pyXQVFtkbHZ
         6f48H8YNlpxkOEErfJkvh2CV2NYOZ2J5JRzoirVOV3M7nsI3WDJd3fmIVymZLk9s51gE
         IeD+epSzZb2hO0RGXUP0dxcKWQHWm5GFs+OZZdaaFb0ly3QXRml0F2m1W4kcU2/AKSe3
         p1qvu3AS3/nmHSgzU/wjfuX6uLJ7rhfrVVyqxhZB5jrO3R+j+wO0uLHhHETNbnNi4WNn
         HA/Lnwz0QCEMpK4yfDaN20N3ZngB274pmSqot+HuxdiGasSGaQJxD5tl955PumtrgDaz
         KUrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AJ75C0Tn6euvXAljkSJPwcS/hlE2vhaVqNrdp4DgqTU=;
        b=SW4eBsNMQ6ZOSmEvkraj4tb7G8Uel0lg/YDGKIs803eORCsunUwPe76V6m07u9/Ges
         8PcBPC28E82b3/MB00bH6EnAwRj4PeMiilG5TIBopzF5CiZ/ymdMQCxOPQPuDeJFjLev
         yYmx8Rv+fVkQrZrG94ucPvUwcqc33GvEG2RJuDFAU0vhDPUzeVugJQZpDHbYN2rsA98+
         4DNjYIqcl+4r/m6IeCg5RPkHMcMHvP6DA3lajwRlTWjRYVAo42fZcZfl2509SXij8pCL
         BggIip6PTpp/Y2upUDXh6O/vEV5KZVuHrwq95ceUiwPZMwd7dk8sEWy/ORP3Bf+ZN1Sl
         ZGCw==
X-Gm-Message-State: AOAM530aPEagRm3k0rNSNvoEUarCSLuabkG5gSY4BaClYUtBaAndg2sK
        BlukHqjXY6FdD7E358eA2/NoB4NXTW4=
X-Google-Smtp-Source: ABdhPJxb8Bo3m6T6ACt28w7XYbfA1q6E5yA6CjggbR6jJyhmMRnDvYz/s7gZ6hkLeN0ZB/0BuA7OCA==
X-Received: by 2002:a17:90b:4c8f:b0:1bc:a64b:805 with SMTP id my15-20020a17090b4c8f00b001bca64b0805mr3334972pjb.156.1646479520391;
        Sat, 05 Mar 2022 03:25:20 -0800 (PST)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id nl12-20020a17090b384c00b001bc1bb5449bsm7868030pjb.2.2022.03.05.03.25.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Mar 2022 03:25:20 -0800 (PST)
Message-ID: <8624c864-b459-f178-a8be-20ee6bac780b@gmail.com>
Date:   Sat, 5 Mar 2022 12:25:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v3] i386/sev: Ensure attestation report length is valid
 before retrieving
Content-Language: en-US
To:     Tyler Fanelli <tfanelli@redhat.com>, qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, berrange@redhat.com,
        kvm@vger.kernel.org
References: <20220304201141.509492-1-tfanelli@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= 
        <philippe.mathieu.daude@gmail.com>
In-Reply-To: <20220304201141.509492-1-tfanelli@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/3/22 21:11, Tyler Fanelli wrote:
> The length of the attestation report buffer is never checked to be
> valid before allocation is made. If the length of the report is returned
> to be 0, the buffer to retrieve the attestation buffer is allocated with
> length 0 and passed to the kernel to fill with contents of the attestation
> report. Leaving this unchecked is dangerous and could lead to undefined
> behavior.
> 
> Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
> ---
>   target/i386/sev.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 025ff7a6f8..e82be3e350 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -616,6 +616,8 @@ static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
>           return NULL;
>       }
>   
> +    input.len = 0;

I agree with Daniel's review of your v1:

   "The declaration of 'input' already zero initializes."

https://lore.kernel.org/qemu-devel/YiJi9IYqtZvNQIRc@redhat.com/

>       /* Query the report length */
>       ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
>               &input, &err);
> @@ -626,6 +628,11 @@ static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
>                          ret, err, fw_error_to_str(err));
>               return NULL;
>           }
> +    } else if (input.len == 0) {
> +        error_setg(errp, "SEV: Failed to query attestation report:"
> +                         " length returned=%u",
> +                   input.len);
> +        return NULL;
>       }
>   
>       data = g_malloc(input.len);

