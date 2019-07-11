Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E35665ECD
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 19:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbfGKRki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 13:40:38 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39417 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728366AbfGKRki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 13:40:38 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so2292829wma.4
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 10:40:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+qKePFgzBQx2x0+EEDPQl5k+tNxWs2tCceDLCZgK12g=;
        b=W5RVtvQgJm2/BWbiB1OYkoCvBy5fYmSf4S3xeoLY0sW6tkmEY1+og8vZDBKimF6vJM
         aVZAlatUJG+VbZBJUjka6kyglx8r2PXakQOZOzks1czSZzIrnbE1d8hjggW1Q7MI3JLL
         xLca0OaS2iZoEeHjppBCQQKH6kul9l1AlgIEOzx3UmVc2ULBfCxDb2/mpheoNqNFFocZ
         mPxiVzSwEwbH8Xqld6xuE+g5V9cuR2E6HaHF/F8OXAidoXlxGp1FnpGfPhmbcMC58vGO
         dfUfcgqdi8UCafV1pgIjFfc1fpnole2DAExXN+BgGpL5X3tKny5QuPaTN1/fByblr0BX
         YmHg==
X-Gm-Message-State: APjAAAWbRbDTsUJkK7vY3LVO1HnP5HKePLotz1O+8tmXIGpx6RqhNFjy
        1ou9euEmZiMPOcJus81sMhg+BI83sD4=
X-Google-Smtp-Source: APXvYqyU+nwcTpsDznkonbEo3ackIU0/ra7BjykLsUt+T5ma4I21JVpKcf5S3pnGM/mdc47gSrbQsw==
X-Received: by 2002:a05:600c:2245:: with SMTP id a5mr5155113wmm.121.1562866836452;
        Thu, 11 Jul 2019 10:40:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id h1sm3761414wrt.20.2019.07.11.10.40.35
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 10:40:35 -0700 (PDT)
Subject: Re: [PATCH RESEND v2] target-i386: adds PV_SCHED_YIELD CPUID feature
 bit
To:     Wanpeng Li <kernellwp@gmail.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <1562745771-8414-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7a787356-2086-574b-fe24-7395d84410c0@redhat.com>
Date:   Thu, 11 Jul 2019 19:40:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562745771-8414-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/19 10:02, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Adds PV_SCHED_YIELD CPUID feature bit.
> 
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> Note: kvm part is merged
> v1 -> v2:
>  * use bit 13 instead of bit 12 since bit 12 has user now
> 
>  target/i386/cpu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 5f07d68..f4c4b6b 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -902,7 +902,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>              "kvmclock", "kvm-nopiodelay", "kvm-mmu", "kvmclock",
>              "kvm-asyncpf", "kvm-steal-time", "kvm-pv-eoi", "kvm-pv-unhalt",
>              NULL, "kvm-pv-tlb-flush", NULL, "kvm-pv-ipi",
> -            NULL, NULL, NULL, NULL,
> +            NULL, "kvm-pv-sched-yield", NULL, NULL,
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,
>              "kvmclock-stable-bit", NULL, NULL, NULL,
> 

Queued for 4.2, thanks.

Paolo
