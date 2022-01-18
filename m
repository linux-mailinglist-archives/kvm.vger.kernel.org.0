Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA341492651
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 14:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241399AbiARNBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 08:01:52 -0500
Received: from foss.arm.com ([217.140.110.172]:56050 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241134AbiARNBv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 08:01:51 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD4B21FB;
        Tue, 18 Jan 2022 05:01:50 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.37.52])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A0B43F73D;
        Tue, 18 Jan 2022 05:01:45 -0800 (PST)
Date:   Tue, 18 Jan 2022 13:01:42 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, aleksandar.qemu.devel@gmail.com,
        alexandru.elisei@arm.com, anup.patel@wdc.com,
        aou@eecs.berkeley.edu, atish.patra@wdc.com,
        benh@kernel.crashing.org, borntraeger@linux.ibm.com, bp@alien8.de,
        catalin.marinas@arm.com, chenhuacai@kernel.org,
        dave.hansen@linux.intel.com, david@redhat.com,
        frankja@linux.ibm.com, frederic@kernel.org, gor@linux.ibm.com,
        hca@linux.ibm.com, imbrenda@linux.ibm.com, james.morse@arm.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        maz@kernel.org, mingo@redhat.com, mpe@ellerman.id.au,
        nsaenzju@redhat.com, palmer@dabbelt.com, paulmck@kernel.org,
        paulus@samba.org, paul.walmsley@sifive.com, pbonzini@redhat.com,
        suzuki.poulose@arm.com, tglx@linutronix.de,
        tsbogend@alpha.franken.de, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org
Subject: Re: [PATCH 1/5] kvm: add exit_to_guest_mode() and
 enter_from_guest_mode()
Message-ID: <20220118130142.GB17938@C02TD0UTHF1T.local>
References: <20220111153539.2532246-1-mark.rutland@arm.com>
 <20220111153539.2532246-2-mark.rutland@arm.com>
 <YeCMVGqiVfTKESzy@google.com>
 <YeFi9FTPSyLbQytu@FVFF77S0Q05N>
 <YeGgmgyz9q8AvpKN@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeGgmgyz9q8AvpKN@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022 at 04:11:06PM +0000, Sean Christopherson wrote:
> On Fri, Jan 14, 2022, Mark Rutland wrote:
> > I'd like to keep this somewhat orthogonal to the x86 changes (e.g. as other
> > architectures will need backports to stable at least for the RCU bug fix), so
> > I'd rather use a name that isn't immediately coupled with x86 changes.
> 
> Ah, gotcha.
>  
> > Does the guest_context_{enter,exit}_irqoff() naming above work for you?
> 
> Yep, thanks!

I just realised that I already have guest_context_{enter,exit}_irqoff()
for the context-tracking bits alone, and so I'll need to use a different
name. For bisectability I can't use guest_{enter,exit}_irqoff()
immediately, so for now I'll go with guest_state_{enter,exit}_irqoff().

Once the conversion is complete and the deprecated bits are removed we
can rename those to guest_{enter,exit}_irqoff().

Thanks,
Mark.
