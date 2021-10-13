Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2FC42BC91
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 12:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239290AbhJMKRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 06:17:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238640AbhJMKRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 06:17:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91A3760EDF;
        Wed, 13 Oct 2021 10:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634120107;
        bh=Ruv5EW+NTge2yEnN27DKPqZq+pUFBaxgaE+3qXCReOE=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=Dl4jDaY6XtL74KsKzij7VxVaYeTzTWa0xaaYBJLJ4dTzA4xdHTMszpkQoampRxqlH
         6j/+bsKWmJ0zcIu4OxuONETCVHfE7hLpAIBY79FKGEcWHCOtT+1ovkNsaIspucJLU1
         vz5IClrfqVEMb+3+/efiBNCYFOQN8IJazKtLFTjX6b1DBEmrWwZ6cjcDm7N/FhMHRX
         5B/G6MBYNgZfPprqdFD7rdxYDbo1SgTbT7sm1rt7EKzBPuGbDXOLoI5mrmdb5hfVw2
         rFgG26yVK67U6NLW9kPZ/lrznuu9r3AZQrk97aE0miXT70vD2rnixV5IEN4Xc6JMGV
         hnt8jfqPhJmeA==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id A3A0227C005B;
        Wed, 13 Oct 2021 06:15:05 -0400 (EDT)
Received: from imap48 ([10.202.2.98])
  by compute6.internal (MEProxy); Wed, 13 Oct 2021 06:15:05 -0400
X-ME-Sender: <xms:qbFmYfhamHOOSqnWIa9NT4OT9ngOnGZqBSTdUyQp7JS1dh9sUIsMCg>
    <xme:qbFmYcCnL07lS2N-aASPX4-9Y_A1bHp-Eoj-JtsPhNkCQT3NE_BDAKtCQWWI-OTAz
    G9M2SpIdhqTgXIwsZ8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddutddgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdetnhgu
    hicunfhuthhomhhirhhskhhifdcuoehluhhtoheskhgvrhhnvghlrdhorhhgqeenucggtf
    frrghtthgvrhhnpedthfehtedtvdetvdetudfgueeuhfdtudegvdelveelfedvteelfffg
    fedvkeegfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrnhguhidomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudduiedukeeh
    ieefvddqvdeifeduieeitdekqdhluhhtoheppehkvghrnhgvlhdrohhrgheslhhinhhugi
    drlhhuthhordhush
X-ME-Proxy: <xmx:qbFmYfFEYTczkjJNZYMPziW1uRxaamlrKhoi2NnF9qXAPwW_AJbdVQ>
    <xmx:qbFmYcRMasl17cOSS0jaELBTViJ0UTsIALfJv0zRQturZpVBc_2M2w>
    <xmx:qbFmYcyLLjwcNrofGUIapE67DUkRF_cEoo55hWWR3754_AOguBRgVA>
    <xmx:qbFmYYcmfF4PuVedAiZmHXsdm0cT3iJn5zpYkZoNyyyBwf1ifu2LX9-pnhc>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 40B8521E006C; Wed, 13 Oct 2021 06:15:05 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-1345-g8441cd7852-fm-20211006.001-g8441cd78
Mime-Version: 1.0
Message-Id: <d673e736-0a72-4549-816d-b755227ea797@www.fastmail.com>
In-Reply-To: <da47ba42-b61e-d236-2c1c-9c5504e48091@redhat.com>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.069324121@linutronix.de>
 <8a5762ab-18d5-56f8-78a6-c722a2f387c5@redhat.com>
 <BYAPR11MB3256B39E2A34A09FF64ECC5BA9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
 <0962c143-2ff9-f157-d258-d16659818e80@redhat.com>
 <BYAPR11MB325676AAA8A0785AF992A2B9A9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
 <da47ba42-b61e-d236-2c1c-9c5504e48091@redhat.com>
Date:   Wed, 13 Oct 2021 03:14:44 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "Paolo Bonzini" <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "kvm list" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Jing Liu" <jing2.liu@linux.intel.com>,
        "Sean Christopherson" <seanjc@google.com>
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On Wed, Oct 13, 2021, at 1:42 AM, Paolo Bonzini wrote:
> On 13/10/21 09:46, Liu, Jing2 wrote:
>> 
>>> On 13/10/21 08:15, Liu, Jing2 wrote:
>>>> After KVM passthrough XFD to guest, when vmexit opening irq window and
>>>> KVM is interrupted, kernel softirq path can call
>>>> kernel_fpu_begin() to touch xsave state. This function does XSAVES. If
>>>> guest XFD[18] is 1, and with guest AMX state in register, then guest
>>>> AMX state is lost by XSAVES.
>>>
>>> Yes, the host value of XFD (which is zero) has to be restored after vmexit.
>>> See how KVM already handles SPEC_CTRL.
>> 
>> I'm trying to understand why qemu's XFD is zero after kernel supports AMX.
>
> There are three copies of XFD:
>
> - the guest value stored in vcpu->arch.
>
> - the "QEMU" value attached to host_fpu.  This one only becomes zero if 
> QEMU requires AMX (which shouldn't happen).
>
> - the internal KVM value attached to guest_fpu.  When #NM happens, this 
> one becomes zero.
>
>
> The CPU value is:
>
> - the host_fpu value before kvm_load_guest_fpu and after 
> kvm_put_guest_fpu.  This ensures that QEMU context switch is as cheap as 
> possible.
>
> - the guest_fpu value between kvm_load_guest_fpu and kvm_put_guest_fpu. 
>   This ensures that no state is lost in the case you are describing.
>
> - the OR of the guest value and the guest_fpu value while the guest runs 
> (using either MSR load/save lists, or manual wrmsr like 
> pt_guest_enter/pt_guest_exit).  This ensures that the host has the 
> opportunity to get a #NM exception, and allocate AMX state in the 
> guest_fpu and in current->thread.fpu.
>
>> Yes, passthrough is done by two cases: one is guest #NM trapped;
>> another is guest clearing XFD before it generates #NM (this is possible for
>> guest), then passthrough.
>> For the two cases, we passthrough and allocate buffer for guest_fpu, and
>> current->thread.fpu.
>
> I think it's simpler to always wait for #NM, it will only happen once 
> per vCPU.  In other words, even if the guest clears XFD before it 
> generates #NM, the guest_fpu's XFD remains nonzero and an #NM vmexit is 
> possible.  After #NM the guest_fpu's XFD is zero; then passthrough can 
> happen and the #NM vmexit trap can be disabled.

This will stop being at all optimal when Intel inevitably adds another feature that uses XFD.  In the potentially infinite window in which the guest manages XFD and #NM on behalf of its userspace and when the guest allocates the other hypothetical feature, all the #NMs will have to be trapped by KVM.

Is it really worthwhile for KVM to use XFD at all instead of preallocating the state and being done with it?  KVM would still have to avoid data loss if the guest sets XFD with non-init state, but #NM could always pass through.
