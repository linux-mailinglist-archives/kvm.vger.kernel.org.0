Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A4F3159FC
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 00:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbhBIXVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 18:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233968AbhBIW0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 17:26:50 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F052EC06178A;
        Tue,  9 Feb 2021 14:25:21 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id q4so9374568otm.9;
        Tue, 09 Feb 2021 14:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=1gLVS9nK6WhHrZCvdncqK42qXIN9H4CM0nYuiaxrwA8=;
        b=W8N0og07ri1K4ftGlRDFehYZYS9dfZeHVIT2dk54OWafHg9jQtP1Js2mHw6F8NG7y9
         /OcM9jtnzCo4N7ABF5Qc/Xac3qUGBN7zBmwpiobxZiZBnEdXYaOuaAMDsVwz8xcTUukl
         zXqYMv09N5ymAOW2FTADn70jIjxRKZUyeeX1qM1v96lNT2XIJCxyGshVnlsZzcYJpf8w
         VNdrE9cif/D9U89D9G4t38i3RNu+JBC+cZY4mOyoem1ySU1B0tTWRG7WUeuUaFQNs14V
         Xu6G43y43BBPceRyxvgsoi5GVGtPobWQl4UwEWIW0hkqSSvUEqBYZq33lRJNxvgTvhM3
         OX4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=1gLVS9nK6WhHrZCvdncqK42qXIN9H4CM0nYuiaxrwA8=;
        b=jtt7yUbpGcCCbPBWy2/2mZYzrrvb6HyRsuT1Jub+3DyAqTEf2tAuZd+rbnQEXOIyeV
         CACTdlSlSE+YFmm2A+4JONc9ypl+2cJvLp4Lsw8jsr6mV1b2pBgMiqEE3i3TVInW6WK3
         e8N4TscMWcoBHv2sjxTUr1M6lnxpzknfMde4MC65+sUt0FXnQBOYBc+JNTE9NXV1EKGJ
         +SOGU3tUF6RxuK8qBfOtuS2RCjYTioQGD/Cx/0zJGetEVT6P/ZqCUlRj+0bpprg5zubO
         9VTWdR4ka9tafvBgoNJngQokx2e1boZb5RbE+F2HXfg6dewEGl2LjmRCqspzlo1eifS+
         /g0w==
X-Gm-Message-State: AOAM530VL6ddRyOcbHP39k4GHWNWmAjrgdY70dLZn31SLf4BY8MiE4c5
        50b1IEZzzYpG/EFoDoJxosc=
X-Google-Smtp-Source: ABdhPJx8DTNMEqsEpH9g5L7zRz4lHBPFybjAK99MllhY+H+TYKRmZp7gyYE7s7/Qw3YxyLzmSiQm8w==
X-Received: by 2002:a9d:74d7:: with SMTP id a23mr9351267otl.331.1612909521283;
        Tue, 09 Feb 2021 14:25:21 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n27sm15083oij.36.2021.02.09.14.25.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Feb 2021 14:25:20 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 9 Feb 2021 14:25:19 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Waiman Long <longman@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH v2 06/28] locking/rwlocks: Add contention detection for
 rwlocks
Message-ID: <20210209222519.GA178687@roeck-us.net>
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-7-bgardon@google.com>
 <20210209203908.GA255655@roeck-us.net>
 <3ee109cd-e406-4a70-17e8-dfeae7664f5f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3ee109cd-e406-4a70-17e8-dfeae7664f5f@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 09, 2021 at 04:46:02PM -0500, Waiman Long wrote:
> On 2/9/21 3:39 PM, Guenter Roeck wrote:
> > On Tue, Feb 02, 2021 at 10:57:12AM -0800, Ben Gardon wrote:
> > > rwlocks do not currently have any facility to detect contention
> > > like spinlocks do. In order to allow users of rwlocks to better manage
> > > latency, add contention detection for queued rwlocks.
> > > 
> > > CC: Ingo Molnar <mingo@redhat.com>
> > > CC: Will Deacon <will@kernel.org>
> > > Acked-by: Peter Zijlstra <peterz@infradead.org>
> > > Acked-by: Davidlohr Bueso <dbueso@suse.de>
> > > Acked-by: Waiman Long <longman@redhat.com>
> > > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > > Signed-off-by: Ben Gardon <bgardon@google.com>
> > When building mips:defconfig, this patch results in:
> > 
> > Error log:
> > In file included from include/linux/spinlock.h:90,
> >                   from include/linux/ipc.h:5,
> >                   from include/uapi/linux/sem.h:5,
> >                   from include/linux/sem.h:5,
> >                   from include/linux/compat.h:14,
> >                   from arch/mips/kernel/asm-offsets.c:12:
> > arch/mips/include/asm/spinlock.h:17:28: error: redefinition of 'queued_spin_unlock'
> >     17 | #define queued_spin_unlock queued_spin_unlock
> >        |                            ^~~~~~~~~~~~~~~~~~
> > arch/mips/include/asm/spinlock.h:22:20: note: in expansion of macro 'queued_spin_unlock'
> >     22 | static inline void queued_spin_unlock(struct qspinlock *lock)
> >        |                    ^~~~~~~~~~~~~~~~~~
> > In file included from include/asm-generic/qrwlock.h:17,
> >                   from ./arch/mips/include/generated/asm/qrwlock.h:1,
> >                   from arch/mips/include/asm/spinlock.h:13,
> >                   from include/linux/spinlock.h:90,
> >                   from include/linux/ipc.h:5,
> >                   from include/uapi/linux/sem.h:5,
> >                   from include/linux/sem.h:5,
> >                   from include/linux/compat.h:14,
> >                   from arch/mips/kernel/asm-offsets.c:12:
> > include/asm-generic/qspinlock.h:94:29: note: previous definition of 'queued_spin_unlock' was here
> >     94 | static __always_inline void queued_spin_unlock(struct qspinlock *lock)
> >        |                             ^~~~~~~~~~~~~~~~~~
> 
> I think the compile error is caused by the improper header file inclusion
> ordering. Can you try the following change to see if it can fix the compile
> error?
> 

That results in:

In file included from ./arch/mips/include/generated/asm/qrwlock.h:1,
                 from ./arch/mips/include/asm/spinlock.h:13,
                 from ./include/linux/spinlock.h:90,
                 from ./include/linux/ipc.h:5,
                 from ./include/uapi/linux/sem.h:5,
                 from ./include/linux/sem.h:5,
                 from ./include/linux/compat.h:14,
                 from arch/mips/kernel/asm-offsets.c:12:
./include/asm-generic/qrwlock.h: In function 'queued_rwlock_is_contended':
./include/asm-generic/qrwlock.h:127:9: error: implicit declaration of function 'arch_spin_is_locked'

Guenter

> Cheers,
> Longman
> 
> diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
> index 0020d3b820a7..d7178a9439b5 100644
> --- a/include/asm-generic/qrwlock.h
> +++ b/include/asm-generic/qrwlock.h
> @@ -10,11 +10,11 @@
>  #define __ASM_GENERIC_QRWLOCK_H
> 
>  #include <linux/atomic.h>
> +#include <linux/spinlock.h>
>  #include <asm/barrier.h>
>  #include <asm/processor.h>
> 
>  #include <asm-generic/qrwlock_types.h>
> -#include <asm-generic/qspinlock.h>
> 
>  /*
>   * Writer states & reader shift and bias.
> 
> 
> 
