Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40686FFCC9
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 00:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239615AbjEKWkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 18:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239499AbjEKWj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 18:39:58 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1216C72BE
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:39:46 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-517bad1b8c5so8623567a12.0
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683844785; x=1686436785;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HS+C3IjXfWystCONYjb3EXxD2SDxWUthJbvvwGWs1+8=;
        b=r5MQQ+mBJ+84kKxnm/gw1YuGM5HuEzQgj+EEC07xuOUA0uFCYdG/pd32A2RoxkoXn4
         BeIqAPoxRiiWxltudkcaPV7km11ERjQU23thTbY8+fGjgFfxkkPz2XXc2QsgVFs6NUoo
         0opXUXOdMgF6+kGyY1CAWlLmiFUP1Ps1kQixkzRs80PdBlF8ik/mYwHAT7uQSMlOUU1L
         dG4lR9Q1eObvB/pIXpZHfHHwfz75xhjlaAfclkgFrBCHQ5WzuZU28VOTZU/K4YZYwRRI
         P8yD7liQYau4VMImM/FN5HiRol8YYr91eMYlOtBxEI6W7VFEiqWeq1tJ56to5a2jbxvg
         Xcnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683844785; x=1686436785;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HS+C3IjXfWystCONYjb3EXxD2SDxWUthJbvvwGWs1+8=;
        b=kbfCcZ2THh4CFYlC1JS3fvi8L9AzokbvghYDuowQc7P1O2JJeg61FZghkynWy6Yxmt
         gm6kkjbacZbaeG7IszZ/0J9m1xI5GmCu9x7mZNiYm88v+9JTsdClrpD6lLz3Xvp+hJxP
         3SdC1jfgnqRwmGg0XtXFc+AKKLUo7p6qcDFlQk1xGO4uGThb5kmd1cai3OoQ+xjPn3l6
         0C9Wyko1nLdzYt1usAk0XSQNfMlMvFpnimNDICxKiYFWfnUeXwHs7w6iYrt5ORCqtVbD
         3z/F13Zo0aZ6/rmtgrJ4x3l1UKmrPONgQv6JYNSsJr+TWVycxkxSdFlz985T27LkKyRd
         IkWQ==
X-Gm-Message-State: AC+VfDwId1gDo1rcFH6iS+HskJNvXhe2rVA7c2jA8GqEBN0sTyax6lFM
        9YKAWdeXGRDPtSMbvV2f+IHGgdiixGw=
X-Google-Smtp-Source: ACHHUZ4kD8uOuPFFFBJbC927/oOErjQm18umPI4Cv6zwlKft757rQyDRAMtH49/S06GSKQrVUMS3BzfedJg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:da53:0:b0:530:6f9f:9b36 with SMTP id
 l19-20020a63da53000000b005306f9f9b36mr1231330pgj.9.1683844785592; Thu, 11 May
 2023 15:39:45 -0700 (PDT)
Date:   Thu, 11 May 2023 15:39:44 -0700
In-Reply-To: <ZFhNHB4VWp8+5wWp@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com> <20230311002258.852397-26-seanjc@google.com>
 <ZBQkyB3KJP34D9/h@yzhao56-desk.sh.intel.com> <ZBwS0DNOwMf7OVmV@yzhao56-desk.sh.intel.com>
 <ZFLrOgUL4T/lrVLo@google.com> <ZFMVsFzpN16hiPUH@yzhao56-desk.sh.intel.com> <ZFhNHB4VWp8+5wWp@yzhao56-desk.sh.intel.com>
Message-ID: <ZF1usP8CGPxZWIj3@google.com>
Subject: Re: [PATCH v2 25/27] KVM: x86/mmu: Drop @slot param from
 exported/external page-track APIs
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Zhi Wang <zhi.a.wang@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 08, 2023, Yan Zhao wrote:
> On Thu, May 04, 2023 at 10:17:20AM +0800, Yan Zhao wrote:
> > On Wed, May 03, 2023 at 04:16:10PM -0700, Sean Christopherson wrote:
> > > Finally getting back to this series...
> > > 
> > > On Thu, Mar 23, 2023, Yan Zhao wrote:
> > > > On Fri, Mar 17, 2023 at 04:28:56PM +0800, Yan Zhao wrote:
> > > > > On Fri, Mar 10, 2023 at 04:22:56PM -0800, Sean Christopherson wrote:
> > > > > ...
> > > > > > +int kvm_write_track_add_gfn(struct kvm *kvm, gfn_t gfn)
> > > > > > +{
> > > > > > +	struct kvm_memory_slot *slot;
> > > > > > +	int idx;
> > > > > > +
> > > > > > +	idx = srcu_read_lock(&kvm->srcu);
> > > > > > +
> > > > > > +	slot = gfn_to_memslot(kvm, gfn);
> > > > > > +	if (!slot) {
> > > > > > +		srcu_read_unlock(&kvm->srcu, idx);
> > > > > > +		return -EINVAL;
> > > > > > +	}
> > > > > > +
> > > > > Also fail if slot->flags & KVM_MEMSLOT_INVALID is true?
> > > > > There should exist a window for external users to see an invalid slot
> > > > > when a slot is about to get deleted/moved.
> > > > > (It happens before MOVE is rejected in kvm_arch_prepare_memory_region()).
> > > > 
> > > > Or using
> > > >         if (!kvm_is_visible_memslot(slot)) {
> > > > 		srcu_read_unlock(&kvm->srcu, idx);
> > > > 		return -EINVAL;
> > > > 	}
> > > 
> Hi Sean,
> After more thoughts, do you think checking KVM internal memslot is necessary?

I don't think it's necessary per se, but I also can't think of any reason to allow
it.

> slot = gfn_to_memslot(kvm, gfn);
> if (!slot || slot->id >= KVM_USER_MEM_SLOTS) {
> 		srcu_read_unlock(&kvm->srcu, idx);
> 		return -EINVAL;
> }
> 
> Do we allow write tracking to APIC access page when APIC-write VM exit
> is not desired?

Allow?  Yes.
 
But KVM doesn't use write-tracking for anything APICv related, e.g. to disable
APICv, KVM instead zaps the SPTEs for the APIC access page and on page fault goes
straight to MMIO emulation.

Theoretically, the guest could create an intermediate PTE in the APIC access page
and AFAICT KVM would shadow the access and write-protect the APIC access page.
But that's benign as the resulting emulation would be handled just like emulated
APIC MMIO.

FWIW, the other internal memslots, TSS and idenity mapped page tables, are used
if and only if paging is disabled in the guest, i.e. there are no guest PTEs for
KVM to shadow (and paging must be enabled to enable VMX, so nested EPT is also
ruled out).  So this is theoretically possible only for the APIC access page.
That changes with KVMGT, but that again should not be problematic.  KVM will
emulate in response to the write-protected page and things go on.  E.g. it's
arguably much weirder that the guest can read/write the identity mapped page
tables that are used for EPT without unrestricted guest.

There's no sane reason to allow creating PTEs in the APIC page, but I'm also not
all that motivated to "fix" things.   account_shadowed() isn't expected to fail,
so KVM would need to check further up the stack, e.g. in walk_addr_generic() by
open coding a form of kvm_vcpu_gfn_to_hva_prot().

I _think_ that's the only place KVM would need to add a check, as KVM already
checks that the root, i.e. CR3, is in a "visible" memslot.  I suppose KVM could
just synthesize triple fault, like it does for the root/CR3 case, but I don't
like making up behavior.

In other words, I'm not opposed to disallowing write-tracking internal memslots,
but I can't think of anything that will break, and so for me personally at least,
the ROI isn't sufficient to justify writing tests and dealing with any fallout.
