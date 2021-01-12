Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400F52F3E1E
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 01:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394191AbhALWFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 17:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733053AbhALWFu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 17:05:50 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B048C0617A4
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 14:04:46 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id b5so2595540pjk.2
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 14:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=nbLyjtvFxvmKNYxhP/lJoJ/nf5a/TGw22r5rcB+fC2s=;
        b=E83JIL5C/0yD67sQZUe0iGFv7Iec6mv83jCj5+dMw6Bt6fY3v3oVETyOnrp+QzzZ6D
         DcvZ9zkA0Q1ErcVwG5bTMFgNz7SysicC7VwZwRtsitaS84lymSSMQAD4rZQlQ87aFcam
         1Z9jiK59DXA8W09RMu0HwZxhxht89EkwzmJYMMEHv7y7/MI6zFfljfwIivRExzDe7et3
         rRMB3AW9rUNXS5ijczsrIw1TqbTmUZMJu8GEO265Xe4eyL048WjLeEVGpXmqwwZuvq7R
         kYHbyumnbKiaQvAUDCpcCglH8exVlnz/+cJQcwbCtGaioaFmF/iGZJ0JFrtYtvatE8/X
         SjVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=nbLyjtvFxvmKNYxhP/lJoJ/nf5a/TGw22r5rcB+fC2s=;
        b=ItGnJ2xcBIk9zev53W+j9BIV35H/K5K7njGkuI0ZxIQfkbZurDaNhsUC5DzPyFDSHw
         u1t1+xLQDI9PCosMYGP37jKbcK9GWTzuHTzfXEgIM2M5BINNNrxHuOv9+ISWHx9uoUmc
         grlemd6JLu9O8rvtvDzgQuWDKSLGW93/ZDXb8gU3HSHRKehsHHEgmO94bfTd4lJgnzYj
         jIstOyvWtz54uMKpAtJ+iAiN+PD+3tF50oYRhWbWZ3UMBRxcNFhAVvXcSiGfQ+1zr28C
         EM/a+B0qbdXesWs7REXvPwMVcYVgsi+MAVODWQ+LCnwBm7xgSP67rc+R4Ts6hZcgnG81
         8fDw==
X-Gm-Message-State: AOAM53172ZWQIW2nnh0sam6o/mnHawzuHLYmIP3lYKN2/fq/ZobHZ+MH
        j9XoTHK2n9DJ+ZUNSndh/I9x+g==
X-Google-Smtp-Source: ABdhPJxz+zHsERxCU1S2VPIVGi2krTI1n4BT+XMSGjNvpSG2uuAkezG8mxx+oBIjoXfrSP2CTsRZZA==
X-Received: by 2002:a17:902:d48c:b029:de:2fb:98a with SMTP id c12-20020a170902d48cb02900de02fb098amr1018607plg.59.1610489085769;
        Tue, 12 Jan 2021 14:04:45 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id u126sm75536pfu.113.2021.01.12.14.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 14:04:45 -0800 (PST)
Date:   Tue, 12 Jan 2021 14:04:38 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        w90p710@gmail.com, pbonzini@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Revert "KVM: x86: Unconditionally enable irqs in guest
 context"
Message-ID: <X/4c9skP3rOqsWHW@google.com>
References: <20210105192844.296277-1-nitesh@redhat.com>
 <874kjuidgp.fsf@vitty.brq.redhat.com>
 <X/XvWG18aBWocvvf@google.com>
 <87ble1gkgx.fsf@vitty.brq.redhat.com>
 <fb41e24f-a5e3-8319-d25b-e0fe6b902a2b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb41e24f-a5e3-8319-d25b-e0fe6b902a2b@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Nitesh Narayan Lal wrote:
> 
> On 1/7/21 4:33 AM, Vitaly Kuznetsov wrote:
> > Sean Christopherson <seanjc@google.com> writes:
> >
> >> On Wed, Jan 06, 2021, Vitaly Kuznetsov wrote:
> >>> Looking back, I don't quite understand why we wanted to account ticks
> >>> between vmexit and exiting guest context as 'guest' in the first place;
> >>> to my understanging 'guest time' is time spent within VMX non-root
> >>> operation, the rest is KVM overhead (system).
> >> With tick-based accounting, if the tick IRQ is received after PF_VCPU is cleared
> >> then that tick will be accounted to the host/system.  The motivation for opening
> >> an IRQ window after VM-Exit is to handle the case where the guest is constantly
> >> exiting for a different reason _just_ before the tick arrives, e.g. if the guest
> >> has its tick configured such that the guest and host ticks get synchronized
> >> in a bad way.
> >>
> >> This is a non-issue when using CONFIG_VIRT_CPU_ACCOUNTING_GEN=y, at least with a
> >> stable TSC, as the accounting happens during guest_exit_irqoff() itself.
> >> Accounting might be less-than-stellar if TSC is unstable, but I don't think it
> >> would be as binary of a failure as tick-based accounting.
> >>
> > Oh, yea, I vaguely remember we had to deal with a very similar problem
> > but for userspace/kernel accounting. It was possible to observe e.g. a
> > userspace task going 100% kernel while in reality it was just perfectly
> > synchronized with the tick and doing a syscall just before it arrives
> > (or something like that, I may be misremembering the details).
> >
> > So depending on the frequency, it is probably possible to e.g observe
> > '100% host' with tick based accounting, the guest just has to
> > synchronize exiting to KVM in a way that the tick will always arrive
> > past guest_exit_irqoff().
> >
> > It seems to me this is a fundamental problem in case the frequency of
> > guest exits can match the frequency of the time accounting tick.
> >
> 
> Just to make sure that I am understanding things correctly.
> There are two issues:
> 1. The first issue is with the tick IRQs that arrive after PF_VCPU is
>    cleared as they are then accounted into the system context atleast on
>    the setup where CONFIG_VIRT_CPU_ACCOUNTING_GEN is not enabled. With the
>    patch "KVM: x86: Unconditionally enable irqs in guest context", we are
>    atleast taking care of the scenario where the guest context is exiting
>    constantly just before the arrival of the tick.

Yep.

> 2. The second issue that Sean mentioned was introduced because of moving
>    guest_exit_irqoff() closer to VM-exit. Due to this change, any ticks that
>    happen after IRQs are disabled are incorrectly accounted into the system
>    context. This is because we exit the guest context early without
>    ensuring if the required guest states to handle IRQs are restored.

Yep.

> So, the increase in the system time (reported by cpuacct.stats) that I was
> observing is not entirely correct after all.

It's correct, but iff CONFIG_VIRT_CPU_ACCOUNTING_GEN=y, as that doesn't rely on
ticks and so closer to VM-Enter is better.  The problem is that it completely
breaks CONFIG_VIRT_CPU_ACCOUNTING_GEN=n (#2 above) because KVM will never
service an IRQ, ticks included, with PF_VCPU set.

> Am I missing anything here?
