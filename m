Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B661D7327
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 10:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgERImy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 04:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbgERImy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 04:42:54 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F7CC061A0C;
        Mon, 18 May 2020 01:42:54 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jabM0-0005IY-I1; Mon, 18 May 2020 10:42:32 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 026F6100606; Mon, 18 May 2020 10:42:31 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Anastassios Nanos <ananos@nubificus.co.uk>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/2] Expose KVM API to Linux Kernel
In-Reply-To: <cover.1589784221.git.ananos@nubificus.co.uk>
References: <cover.1589784221.git.ananos@nubificus.co.uk>
Date:   Mon, 18 May 2020 10:42:31 +0200
Message-ID: <87y2ppy6q0.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Anastassios Nanos <ananos@nubificus.co.uk> writes:
> To spawn KVM-enabled Virtual Machines on Linux systems, one has to use
> QEMU, or some other kind of VM monitor in user-space to host the vCPU
> threads, I/O threads and various other book-keeping/management mechanisms.
> This is perfectly fine for a large number of reasons and use cases: for
> instance, running generic VMs, running general purpose Operating systems
> that need some kind of emulation for legacy boot/hardware etc.
>
> What if we wanted to execute a small piece of code as a guest instance,
> without the involvement of user-space? The KVM functions are already doing
> what they should: VM and vCPU setup is already part of the kernel, the only
> missing piece is memory handling.
>
> With these series, (a) we expose to the Linux Kernel the bare minimum KVM
> API functions in order to spawn a guest instance without the intervention
> of user-space; and (b) we tweak the memory handling code of KVM-related
> functions to account for another kind of guest, spawned in kernel-space.
>
> PATCH #1 exposes the needed stub functions, whereas PATCH #2 introduces the
> changes in the KVM memory handling code for x86_64 and aarch64.
>
> An example of use is provided based on kvmtest.c
> [https://lwn.net/Articles/658512/] at

And this shows clearly how simple the user space is which is required to
do that. So why on earth would we want to have all of that in the
kernel?

Thanks,

        tglx
