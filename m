Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCE76F61F4
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 01:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjECXQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 19:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjECXQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 19:16:35 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A62493C4
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 16:16:13 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1aaff728c24so34350695ad.2
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 16:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683155772; x=1685747772;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VcB+Y5fDyixakWTeoinQOVeecLhRUTl+pbViwwNrtuQ=;
        b=sTeZoxVDxdqS3PD2YH+hzY3HPDUPF4CDBpil3ScaC5e3sXkVGT/uJEkeaOrwNg3Zgb
         37BoXrNRmGg/+0SCX9mPdqUq6njuBQHxQ6D9QGXpWlyL6WdcOB8AK+eY8A422ogU7Fup
         Lx9HYoY9kT10KPUZIF0eOJ7o+kZcARHSXpg+uwE+qWc976HUetby61zeLGqtVWlgNCfZ
         W/66w8bglbdx9ioh6DT4mqwxC0A+u1kW5jlQMMLE8PzDfQ5Dsq7GnyOAJPIjYbgNCQTt
         HztMBYNsGySpCSBrDm76lEVZgHCRRphG93ufQqUcEFTAg6jKycPQpkvucn1e8E1JDP7d
         uV8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683155772; x=1685747772;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VcB+Y5fDyixakWTeoinQOVeecLhRUTl+pbViwwNrtuQ=;
        b=lzCY5vpE7r7Qu4czyb6sZfpMsPIrUTRoIXIGKVn/rGZeGQovmbjXr7fShDAANAShDz
         l+Vu6eXAby28W90mHngLYgQ+LuM1LL2AgDVBDEI8MO6aBkayPsNvkKLr4GoHU6SG+qRP
         Za0uC+A6dMk1vI8ZGZ+XOdWjD1G6xWtZn/LRasHrKEb0RxlLZw6O3XtlYxTQsUwdZjJD
         0vY9XP4ZzKfRPCsxyi1oO0WqltmgY/onjJmMVdeB3arEUF6+K+GHapggwyLF1wDdZ+Tc
         9IaixMT3JKxtyJBjYJyD6+BKvl415ZJ/BAPxDeYQM3tT8DmZQV8tZqAXc5THsUE+IhKp
         D68Q==
X-Gm-Message-State: AC+VfDyVc/+ljnq6YJBGr+xhq0P63mZ/JyAcHxYua0ZP1W4TorLgfj6/
        kqmnuMGjZjBu3UqbtQqw/Hx28pTEq/8=
X-Google-Smtp-Source: ACHHUZ6g5+RkH9RYY37NzyTJLkYzceQaVVLYFcfwNF/8stvntiOGUw0qCRLeunRzkavyvs4pLnENPx5NNl4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:234c:b0:1a2:87a2:c932 with SMTP id
 c12-20020a170903234c00b001a287a2c932mr513261plh.10.1683155772723; Wed, 03 May
 2023 16:16:12 -0700 (PDT)
Date:   Wed, 3 May 2023 16:16:10 -0700
In-Reply-To: <ZBwS0DNOwMf7OVmV@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com> <20230311002258.852397-26-seanjc@google.com>
 <ZBQkyB3KJP34D9/h@yzhao56-desk.sh.intel.com> <ZBwS0DNOwMf7OVmV@yzhao56-desk.sh.intel.com>
Message-ID: <ZFLrOgUL4T/lrVLo@google.com>
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

Finally getting back to this series...

On Thu, Mar 23, 2023, Yan Zhao wrote:
> On Fri, Mar 17, 2023 at 04:28:56PM +0800, Yan Zhao wrote:
> > On Fri, Mar 10, 2023 at 04:22:56PM -0800, Sean Christopherson wrote:
> > ...
> > > +int kvm_write_track_add_gfn(struct kvm *kvm, gfn_t gfn)
> > > +{
> > > +	struct kvm_memory_slot *slot;
> > > +	int idx;
> > > +
> > > +	idx = srcu_read_lock(&kvm->srcu);
> > > +
> > > +	slot = gfn_to_memslot(kvm, gfn);
> > > +	if (!slot) {
> > > +		srcu_read_unlock(&kvm->srcu, idx);
> > > +		return -EINVAL;
> > > +	}
> > > +
> > Also fail if slot->flags & KVM_MEMSLOT_INVALID is true?
> > There should exist a window for external users to see an invalid slot
> > when a slot is about to get deleted/moved.
> > (It happens before MOVE is rejected in kvm_arch_prepare_memory_region()).
> 
> Or using
>         if (!kvm_is_visible_memslot(slot)) {
> 		srcu_read_unlock(&kvm->srcu, idx);
> 		return -EINVAL;
> 	}

Hrm.  If the DELETE/MOVE succeeds, then the funky accounting is ok (by the end
of the series) as the tracking disappears on DELETE, KVMGT will reject MOVE, and
KVM proper zaps SPTEs and resets accounting on MOVE (account_shadowed() runs under
mmu_lock and thus ensures all previous SPTEs are zapped before the "flush" from
kvm_arch_flush_shadow_memslot() can run).

If kvm_prepare_memory_region() fails though...

Ah, KVM itself is safe because of the aforementioned kvm_arch_flush_shadow_memslot().
Any accounting done on a temporarily invalid memslot will be unwound when the SPTEs
are zapped.  So for KVM, ignoring invalid memslots is correct _and necessary_.
We could clean that up by having accounted_shadowed() use the @slot from the fault,
which would close the window where the fault starts with a valid memslot but then
sees an invalid memslot when accounting a new shadow page.  But I don't think there
is a bug there.

Right, and DELETE can't actually fail in the current code base, and we've established
that MOVE can't possibly work.  So even if this is problematic in theory, there are
no _unknown_ bugs, and the known bugs are fixed by the end of the series.

And at the end of the series, KVMGT drops its tracking only when the DELETE is
committed.  So I _think_ allowing external trackers to add and remove gfns for
write-tracking in an invalid slot is actually desirable/correct.  I'm pretty sure
removal should be allowed as that can lead to dangling write-protection in a
rollback scenario.   And I can't think of anything that will break (in the kernel)
if write-tracking a gfn in an invalid slot is allowed, so I don't see any harm in
allowing the extremely theoretical case of KVMGT shadowing a gfn in a to-be-deleted
memslot _and_ the deletion being rolled back.
