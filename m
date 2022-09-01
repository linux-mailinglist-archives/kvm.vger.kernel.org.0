Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52CC25A9485
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 12:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbiIAK0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 06:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbiIAKZq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 06:25:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A518A7EF
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 03:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662027936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qDrOsD6Wwv4PgT16+SBFbOvFu2rnqTQe673mAyHGej0=;
        b=JtuYJsyyw5z9p+RS9nUWqWpeMg5S0IOb3NuLsOVGlXM1DgAR3dYrOF6E/Tts63deCU+gmB
        AvFjQVPjPJVMUzFbEDhDw4GG1gfTL+aq0mZb6WKp27mDJIN6vmdXb/pVtp3Il0iivyIa5Y
        nFddjPY46gIOj0uvC2ylCIWXJ926l8M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-les2uJSyMnOhEu_aUQMJoA-1; Thu, 01 Sep 2022 06:25:33 -0400
X-MC-Unique: les2uJSyMnOhEu_aUQMJoA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3800A1C0CE65;
        Thu,  1 Sep 2022 10:25:33 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 885EB492C3B;
        Thu,  1 Sep 2022 10:25:31 +0000 (UTC)
Message-ID: <c6e9a565d60fb602a9f4fc48f2ce635bf658f1ea.camel@redhat.com>
Subject: Re: [PATCH 03/19] Revert "KVM: SVM: Introduce hybrid-AVIC mode"
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 01 Sep 2022 13:25:30 +0300
In-Reply-To: <Yw+yjo4TMDYnyAt+@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-4-seanjc@google.com>
         <17e776dccf01e03bce1356beb8db0741e2a13d9a.camel@redhat.com>
         <84c2e836d6ba4eae9fa20329bcbc1d19f8134b0f.camel@redhat.com>
         <Yw+MYLyVXvxmbIRY@google.com>
         <59206c01da236c836c58ff96c5b4123d18a28b2b.camel@redhat.com>
         <Yw+yjo4TMDYnyAt+@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 19:12 +0000, Sean Christopherson wrote:
> On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> > On Wed, 2022-08-31 at 16:29 +0000, Sean Christopherson wrote:
> > > On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> > > > Leaving AVIC on, when vCPU is in x2apic mode cannot trigger extra MMIO emulation,
> > > > in fact the opposite - because AVIC is on, writes to 0xFEE00xxx might *not* trigger
> > > > MMIO emulation and instead be emulated by AVIC.
> > > 
> > > That's even worse, because KVM is allowing the guest to exercise hardware logic
> > > that I highly doubt AMD has thoroughly tested.
> > 
> > Harware logic is exactly the same regarless of if KVM uses x2apic mode or not,
> > and it is better to be prepared for all kind of garbage coming from the guest.
> 
> Right, I got twisted around and was thinking x2APIC enabling of the guest was
> reflected in hardware, but it's purely emulated in this mode.

BTW, I don't know why I didn't thought about it before - it is trivial to plug the possible
emulation bugs in hybrid AVIC mode, assuming that AVIC mmio is still exposed to the guest - 
all we need to do is to refuse to do anything on each of the two AVIC vmexits if the 
AVIC is in this mode, because in this mode, the guest should never touch the MMIO.

So basically just stick teh below code in start of  

'avic_unaccelerated_access_interception()' and in 'avic_incomplete_ipi_interception()'


if (apic_x2apic_mode(vcpu->arch.apic) && avic_mode != AVIC_MODE_X2)
	return 1;

> 
> > Software logic, I can understand you, there could be registers that trap differently
> > in avic and x2avic mode, but it should be *very* easy to deal with it, the list
> > of registers that trap is very short.
> > 
> > > > Yes, some of these writes can trigger AVIC specific emulation vm exits, but they
> > > > are literaly the same as those used by x2avic, and it is really hard to see
> > > > why this would be dangerous (assuming that x2avic code works, and avic code
> > > > is aware of this 'hybrid' mode).
> > > 
> > > The APIC_RRR thing triggered the KVM_BUG_ON() in kvm_apic_write_nodecode()
> > > precisely because of the AVIC trap.  At best, this gives a way for the guest to
> > > trigger a WARN_ON_ONCE() and thus panic the host if panic_on_warn=1.  I fixed
> > > the APIC_RRR case because that will be problematic for x2AVIC, but there are
> > > other APIC registers that are unsupported in x2APIC that can trigger the KVM_BUG_ON().
> > > > From the guest point of view, unless the guest pokes at random MMIO area,
> > > > the only case when this matters is if the guest maps RAM over the 0xFEE00xxx
> > > > (which it of course can, the spec explictly state as you say that when x2apic
> > > > is enabled, the mmio is disabled), and then instead of functioning as RAM,
> > > > the range will still function as APIC.
> > > 
> > > There is no wiggle room here though, KVM is blatantly breaking the architectural
> > > specification.  When x2APIC is enabled, the xAPIC MMIO does not exist.
> > 
> > In this case I say that there is no wiggle room for KVM to not allow
> > different APIC bases on each CPU - the spec 100% allows it, but in KVM it is
> > broken.
> 
> The difference is that KVM is consistent with respect to itself in that case.
> KVM doesn't support APIC base relocation, and never has supported APIC base
> relocation.
> 
> This hybrid AVIC mode means that the resulting KVM behavior will vary depending
> on whether or not AVIC is supported and enabled, whether or not x2AVIC is supported,
> and also on internal KVM state.  And we even have tests for this!  E.g. run the APIC
> unit test with AVIC disabled and it passes, run it with AVIC enabled and it fails.
> 
> > If you are really hell bent on not having that MMIO exposed, then I say we
> > can just disable the AVIC memslot, and keep AVIC enabled in this case - this
> > should make us both happy.
> 
> I don't think that will work though, as I don't think it's possible to tell hardware
> not to accelerate AVIC accesses.  I.e. KVM can squash the unaccelerated traps, but
> anything that is handled by hardware will still go through.

Nope! Remember why do we have that APIC private memslot? It is because APIC's mmio
is accelerated by AVIC/APICv only when both conditions are true 
	1. AVIC/APICv is enabled and is in xapic mode
	2. the MMIO is mapped as read/write in the NPT/EPT (and yes, AVIC/APICv requires NPT/EPT).

For the (2) we have a private memslot that we map there and we enable it when
AVIC/APICv is enabled.



To refresh our memory, we did a hack (I have nothing against it), that we
no longer remove that memslot when AVIC/APICv is inhibited, but instead we zap
its SPTE, and next time the guest tries to access it, despite having a memslot there
we don't re-install the SPTE and instead jump to emulation.

So technically the memslot is always enabled, but the guest can't use it when AVIC/APICv is
inhibited.

However when APIC mode changes to x2apic, I don't think that we zap that SPTE.

This means that when the hardware APIC acceleration is in x2apic mode (e.g x2avic is active),
the hardware doesn't intercept the MMIO anymore, and thus if guest accesses it,
it will access read/write our private APIC memslot, since its SPTE is there, which is wrong
because the userspace didn't map memory there, not to mention that this 'extra' memory won't survive migration.


Thus regardless of avic hybrid mode we need to ensure that if one of vCPUs is in x2apic mode,
that our private memslot SPTE is zapped, and that also the page fault handler won't re-install it.


A side efect of this will be that AVIC in hybrid mode will just work and be 100% to the spec.

> 
> > This discussion really makes me feel that you want just to force your opinion
> > on others, and its not the first time this happens. It is really frustrating
> > to work like that.  It might sound harsh but this is how I feel. Hopefully I
> > am wrong.
> 
> Yes and no.  I am most definitely trying to steer KVM in a direction that I feel
> will allow KVM to scale in terms of developers, users, and workloads.  Part of
> that direction is to change people's mindset from "good enough" to "implement to
> the spec".

Sean, don't understand me wrong - I agree with you mostly.

In fact I implemented support for PDPTR migration to be 100% to the spec,
although I kind of regret it, since PDPTRs looks like not preserved over SMM entries
in hardware thus, it is really not possible to rely on them to be unsync.
Also NPT doesn't support them either.

I also was actually first to notice the exception merging issue, and I actually
worked on fixing it and posted patches upstream. 

It is also a very corner case, and yet I wanted to fix it, just to be 100% up the spec.

I also reviewed the EVENTINJ injection of software interrupts (INTn) when there
is not INTn instruction in the guest, also something that nobody in reality uses,
but I warmely welcomed it and helped with review.

I also fixed many bugs in !NPT, and !EPT cases, also just to make KVM work to the spec.

Etc, etc, etc.

I just know that nothing is absolute, in some rare cases (like different APIC base per cpu),
it is just not feasable to support the spec.

In fact remember that patch series about maximum VMCS field number?
https://lore.kernel.org/kvm/YPmI8x2Qu3ZSS5Bc@google.com/

There was actually a patch series that was fixing it, but you said, just like me,
that it is not worth it, better to have an errata in KVM, since guest should not use
this info anyway. I didn't object to it, and neither I do now, but as you see,
you also sometimes agree that going 100% to the spec is not worth it.


I hope you understand me.

TL;DR - in this case actually the most correct solution is to disable the private apic
memslot that we install over the APIC mmio, when one of the APICs is in x2apic mode.


That will not only make AVIC hybrid mode just work, but also make sure that if the
guest accesses the APIC MMIO anyway it will see no memory there.


Best regards,
	Maxim Levitsky


> 
> KVM's historic "good enough" approach largely worked when KVM had a relatively
> small and stable development community, and when KVM was being used to run a
> relatively limited set of workloads.  But KVM is being used to run an ever increasing
> variety of workloads, and the development community is larger (and I hope that we
> can grow it even further).  And there is inevitably attrition, which means that
> unless we are extremely diligent in documenting KVM's quirks/errata, knowledge of
> KVM's "good enough" shortcuts will eventually be lost.
> 
> E.g. it took me literally days to understand KVM's hack for forcing #PF=>#PF=>VM-Exit
> instead of #PF=>#PF=>#DF.  That mess would have been avoided if KVM had implemented
> to the spec and actually done the right thing back when the bug was first encountered.
> Ditto for the x2APIC ID hotplug hack; I stared at that code on at least three
> different occassions before I finally understood the full impact of the hack.
> 
> And getting KVM to implement to the spec means not deviating from that path when
> it's inconvenient to follow, thus the hard line I am drawing.  I am sure we'll
> encounter scenarios/features where it's simply impossible for KVM to do the right
> thing, e.g. I believe virtualizing VMX's posted interrupts falls into this category.
> But IMO those should be very, very rare exceptions.


> 
> So, "yes" in the sense that I am openly trying to drag people into alignment with
> my "implement to the spec" vision.  But "no" in the sense that I don't think it's
> fair to say I am forcing my opinion on others.  I am not saying "NAK" and ending
> the discussion.
> 


