Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532B73B1E61
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 18:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhFWQMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 12:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbhFWQMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 12:12:53 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA7FC061756
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 09:10:35 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id pf4-20020a17090b1d84b029016f6699c3f2so4157940pjb.0
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 09:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wZgM83tgKsDvA+EzpxBvpaFXJwLabTWXJfE+ZcCN5s8=;
        b=cVL0lCZo16K9PnRVPjyprlZBeN8p0FkwdyajEMZEEzSNDsRicM6p1HRZHIq81JxYWy
         komdU3Z4oM7iSxLg1a5YuHpHLwxQRrreL/ixsc6nP2kaPUEO3+ttgAkQTIjYQqRenh8K
         eLnCpHHzmMcoyNRmZrHq9YMb5VnRh/08lDnsuIKwvU3QX1HtvuC7G7XIDLl/rNrk5FcN
         Qot68s2SeqfHFRfXZyUAZSBZgLGLfUlG031HIpzZIZ9LyCJ2Rh+j2dbkb91l4sgCaKfF
         f1rihXDarkAjjKnx4lHhHHTChdpboQPIDWA6hRx9TgCiSAHsdvvhY7J47S3fztEFki4j
         eFug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wZgM83tgKsDvA+EzpxBvpaFXJwLabTWXJfE+ZcCN5s8=;
        b=jUCQc9NkwfE1cfu5kG2Kr7SkXtWkmMRyyYk94lGQcii1L6tf1U5rM4dAgYT4U0fuQB
         MHYERjsp2YgHatdfwx6UYwYZRvgFES3rPP4MxkFKfJ5Xnlndn9L1oM8B9Jq01YchEqRS
         AUEXv7LxgU5LPFx9tV9BlwQWGiekROsHexiTIudKNEpSlSyhmxn170n48nYEp+1XNvA8
         Ai3BE6CcQX7DNDbp8dKl/gVgVsvxH8HbzfTSj9uGhvMK34tYUgIRg7+ziSOCjwDeEBT1
         21IPIL3Si66dTULbBMUkOASvQepeWszsb7F5taYZCebm17MyAJiKRRp2CF9lbrpwp3lC
         tRkA==
X-Gm-Message-State: AOAM533IlE6f1oqjWL5/JEdHuwmOsGDS1bEkbSSttX3jbrmoCBUThqsA
        FugWnoG+lyCUzcZI9pFbdK2oK6NBXW2aBQ==
X-Google-Smtp-Source: ABdhPJwIzQLT6aquG/5grqE/GwkFx/qE1lCjbXq1cEg0J1NEJgXFdyWQulprHhDEcrNZ+6tZucpirw==
X-Received: by 2002:a17:90a:2a41:: with SMTP id d1mr10107191pjg.77.1624464634777;
        Wed, 23 Jun 2021 09:10:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g16sm323008pgl.22.2021.06.23.09.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 09:10:34 -0700 (PDT)
Date:   Wed, 23 Jun 2021 16:10:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFC] KVM: nSVM: Fix L1 state corruption upon return from
 SMM
Message-ID: <YNNc9lKIzM6wlDNf@google.com>
References: <20210623074427.152266-1-vkuznets@redhat.com>
 <a3918bfa-7b4f-c31a-448a-aa22a44d4dfd@redhat.com>
 <53a9f893cb895f4b52e16c374cbe988607925cdf.camel@redhat.com>
 <ac98150acd77f4c09167bc1bb1c552db68925cf2.camel@redhat.com>
 <87pmwc4sh4.fsf@vitty.brq.redhat.com>
 <5fc502b70a89e18034716166abc65caec192c19b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fc502b70a89e18034716166abc65caec192c19b.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021, Maxim Levitsky wrote:
> On Wed, 2021-06-23 at 15:32 +0200, Vitaly Kuznetsov wrote:
> > Maxim Levitsky <mlevitsk@redhat.com> writes:
> > 
> > > On Wed, 2021-06-23 at 16:01 +0300, Maxim Levitsky wrote:
> > > > On Wed, 2021-06-23 at 11:39 +0200, Paolo Bonzini wrote:
> > > > > On 23/06/21 09:44, Vitaly Kuznetsov wrote:
> > > > > > - RFC: I'm not 100% sure my 'smart' idea to use currently- unused
> > > > > > HSAVE area is that smart. Also, we don't even seem to check that L1
> > > > > > set it up upon nested VMRUN so hypervisors which don't do that may
> > > > > > remain broken.

Ya, per the APM, nested_svm_vmrun() needs to verify the MSR is non-zero, and
svm_set_msr() needs to verify the incoming value is a legal, page-aligned address.
Both conditions are #GP.

> > > > > >A very much needed selftest is also missing.
> > > > > 
> > > > > It's certainly a bit weird, but I guess it counts as smart too.  It
> > > > > needs a few more comments, but I think it's a good solution.
> > > > > 
> > > > > One could delay the backwards memcpy until vmexit time, but that
> > > > > would require a new flag so it's not worth it for what is a pretty
> > > > > rare and already expensive case.

And it's _almost_ architecturally legal, but the APM does clearly state that the
HSAVE area is used on VRMUN and #VMEXIT.  We'd definitely be taking a few
liberties by accessing the area at SMI/RSM.

> > We can resurrect 'hsave' and keep it internally indeed but to make this
> > migratable, we'd have to add it to the nested state acquired through
> > svm_get_nested_state(). Using L1's HSAVE area (ponted to by
> > MSR_VM_HSAVE_PA) avoids that as we have everything in L1's memory.

> I think I would prefer to avoid touching guest memory as much
> as possible to avoid the shenanigans of accessing it:
> 
> For example on nested state read we are not allowed to write guest
> memory since at the point it is already migrated, and for setting
> nested state we are not allowed to even read the guest memory since
> the memory map might not be up to date.

But that shouldn't conflict with using hsave, because hsave won't be accessed in
this case until KVM_RUN, correct?

> Then a malicious guest can always change its memory which also can cause
> issues.

The APM very clearly states that touching hsave is not allowed:

  Software must not attempt to read or write the host save-state area directly.

> Since it didn't work before and both sides of migration need a fix,
> adding a new flag and adding hsave area to nested state seems like a
> very good thing.

...

> This way we still avoid overhead of copying the hsave area
> on each nested entry.
> 
> What do you think?

Hmm, I don't like allocating an extra page for every vCPU.

And I believe this hackery is necessary only because nested_svm_vmexit() isn't
following the architcture in the first place.  I.e. using vmcb01 to restore
host state is flat out wrong.  If this the restore code (below) is instead
converted to use the hsave area, then this bug is fixed _and_ we become (more)
compliant with the spec.  And the save/restore to HSAVE could be selective, i.e.
only save/restore state that is actually consumed by nested_svm_vmexit().

It would require saving/restoring select segment _selectors_, but that is also a
bug fix since the APM pseudocode clearly states that segments are reloading from
the descriptor table (APM says "GDT", though I assume LDT is also legal).  E.g.
while software can't touch HSAVE, L2 can _legally_ change L1's GDT, so it's
technically legal to have host segment registers magically change across VMRUN.
There might also be side effects we're missing by not reloading segment registers,
e.g. accessed bit updates?

	/*
	 * Restore processor state that had been saved in vmcb01 <-- bad KVM
	 */
	kvm_set_rflags(vcpu, svm->vmcb->save.rflags);
	svm_set_efer(vcpu, svm->vmcb->save.efer);
	svm_set_cr0(vcpu, svm->vmcb->save.cr0 | X86_CR0_PE);
	svm_set_cr4(vcpu, svm->vmcb->save.cr4);
	kvm_rax_write(vcpu, svm->vmcb->save.rax);
	kvm_rsp_write(vcpu, svm->vmcb->save.rsp);
	kvm_rip_write(vcpu, svm->vmcb->save.rip);

	svm->vcpu.arch.dr7 = DR7_FIXED_1;
	kvm_update_dr7(&svm->vcpu);

	...

	kvm_vcpu_unmap(vcpu, &map, true);

	nested_svm_transition_tlb_flush(vcpu);

	nested_svm_uninit_mmu_context(vcpu);

	rc = nested_svm_load_cr3(vcpu, svm->vmcb->save.cr3, false, true);


