Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A621DB0D1
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 17:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390441AbfJQPM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 11:12:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56066 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732650AbfJQPM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 11:12:27 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D572588311
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2019 15:12:26 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id n3so1308637wmf.3
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2019 08:12:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6URh6sfF5SY+GjIiIeygv7Pue70RSRcvYor9Y98FLzs=;
        b=JEKLEF5HOf3LKtPoqBiMK32DMyRghR5G0rTDh2onkr2kCDw23tHtFYtFMM8rL9mh1Y
         1jZsqe3F9SEYVPO134cKEmof3QIHVWzq1kaBo3zjBgHdL3VJ2GP6eCKRB9l3xDHiOwXu
         WVoBzMAs+TtpdwlW7pEJMgsUUv2HocNPnHTyJj9LLCEuvFBwaoYL4Du8Lqsc2J/FYs0c
         RbMTftlvBspTypSwslBBWJMJjBQwxuGYNmuNvxQTquMCwXjow21MhvKs2N1+qWjafwSB
         Hzkk/EOS4xcLRHMmbZwzQhnpLBImf40mun3eiwKDdwysRC6lx0JPx390KieaIDVvsDdP
         vMaA==
X-Gm-Message-State: APjAAAWRhxn5zWjdErqKyLTMnwQ0Gzi8N+sdXC0gs9KerPpTihVMh3R6
        yyu1O805RlihCj+1sY3PC+hOdmz1dodqctgXIJ6hf/ptMhNmMIATETXvDwA+eIw197Ic13KAFK5
        zKiJOB4BsZHNt
X-Received: by 2002:a5d:6506:: with SMTP id x6mr3498648wru.366.1571325145506;
        Thu, 17 Oct 2019 08:12:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqySU6DS/RqeRVbBcOi9QO31rcYMYaBXaBuv0ezlv/Z4bgIg5NWR+I6f0LoIGcDuKW0FQqw/eg==
X-Received: by 2002:a5d:6506:: with SMTP id x6mr3498623wru.366.1571325145314;
        Thu, 17 Oct 2019 08:12:25 -0700 (PDT)
Received: from [192.168.50.32] (243.red-88-26-246.staticip.rima-tde.net. [88.26.246.243])
        by smtp.gmail.com with ESMTPSA id a3sm2711161wmj.35.2019.10.17.08.12.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2019 08:12:24 -0700 (PDT)
Subject: Re: [PATCH 04/32] mc146818rtc: Move RTC_ISA_IRQ definition
To:     Aleksandar Markovic <aleksandar.m.mail@gmail.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paul Durrant <paul@xen.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Markovic <amarkovic@wavecomp.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Richard Henderson <rth@twiddle.net>
References: <20191015162705.28087-1-philmd@redhat.com>
 <20191015162705.28087-5-philmd@redhat.com>
 <CAL1e-=jOiMe2--=ht0Wgwh0a_At=sDhUzX7EkNU86nPt230a-g@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <ff0603bb-ffef-ca67-6d0f-9e7a36abaa7f@redhat.com>
Date:   Thu, 17 Oct 2019 17:12:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAL1e-=jOiMe2--=ht0Wgwh0a_At=sDhUzX7EkNU86nPt230a-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/17/19 5:02 PM, Aleksandar Markovic wrote:
> 
> 
> On Tuesday, October 15, 2019, Philippe Mathieu-Daudé <philmd@redhat.com 
> <mailto:philmd@redhat.com>> wrote:
> 
>     From: Philippe Mathieu-Daudé <f4bug@amsat.org <mailto:f4bug@amsat.org>>
> 
>     The ISA default number for the RTC devices is not related to its
>     registers neither. Move this definition to "hw/timer/mc146818rtc.h".
> 
>     Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com
>     <mailto:philmd@redhat.com>>
>     ---
>       include/hw/timer/mc146818rtc.h      | 2 ++
>       include/hw/timer/mc146818rtc_regs.h | 2 --
>       tests/rtc-test.c                    | 1 +
>       3 files changed, 3 insertions(+), 2 deletions(-)
> 
> 
> Philippe, do this and related patches clash with your recent 
> reorganization of timers/rtcs?

Indeed, but since big boring series take time to get merged, I prefer to 
have it reviewed already, then I'll rebase and fix conflicts on the one 
that isn't merged.

Thanks for reviewing the other patches!

> A.
> 
>     diff --git a/include/hw/timer/mc146818rtc.h
>     b/include/hw/timer/mc146818rtc.h
>     index 0f1c886e5b..17761cf6d9 100644
>     --- a/include/hw/timer/mc146818rtc.h
>     +++ b/include/hw/timer/mc146818rtc.h
>     @@ -39,6 +39,8 @@ typedef struct RTCState {
>           QLIST_ENTRY(RTCState) link;
>       } RTCState;
> 
>     +#define RTC_ISA_IRQ 8
>     +
>       ISADevice *mc146818_rtc_init(ISABus *bus, int base_year,
>                                    qemu_irq intercept_irq);
>       void rtc_set_memory(ISADevice *dev, int addr, int val);
>     diff --git a/include/hw/timer/mc146818rtc_regs.h
>     b/include/hw/timer/mc146818rtc_regs.h
>     index bfbb57e570..631f71cfd9 100644
>     --- a/include/hw/timer/mc146818rtc_regs.h
>     +++ b/include/hw/timer/mc146818rtc_regs.h
>     @@ -27,8 +27,6 @@
> 
>       #include "qemu/timer.h"
> 
>     -#define RTC_ISA_IRQ 8
>     -
>       #define RTC_SECONDS             0
>       #define RTC_SECONDS_ALARM       1
>       #define RTC_MINUTES             2
>     diff --git a/tests/rtc-test.c b/tests/rtc-test.c
>     index 6309b0ef6c..18f895690f 100644
>     --- a/tests/rtc-test.c
>     +++ b/tests/rtc-test.c
>     @@ -15,6 +15,7 @@
> 
>       #include "libqtest-single.h"
>       #include "qemu/timer.h"
>     +#include "hw/timer/mc146818rtc.h"
>       #include "hw/timer/mc146818rtc_regs.h"
> 
>       #define UIP_HOLD_LENGTH           (8 * NANOSECONDS_PER_SECOND / 32768)
>     -- 
>     2.21.0
> 
> 
