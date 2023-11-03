Return-Path: <kvm+bounces-531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D03B87E09D5
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 21:05:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79B14B21502
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 20:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C72ED2375C;
	Fri,  3 Nov 2023 20:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="usjeYjnN"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98F5171CD
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 20:05:10 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62713D53
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 13:05:09 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5b0e9c78309so33211317b3.1
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 13:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699041908; x=1699646708; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jqcMVObXfls0ky1XyE/2RgALPyYZ3suExFhfxoDOdHI=;
        b=usjeYjnNTeTAT8isMUNeJzX0mWOOp6C/SzVXnyskgw9liANoaHXZyKa0I+c32sMXvY
         yp1CA2X5nghCo3CCcuZu3HoXIuYOYU4h6xiCFG0/oRE6lIiJ7ZrhfYiPt1kJOh8B3pNK
         bGUg13xbZGxF/cdlsj5RD+7QQjhggPIlIFlkF+vfeUq86A6ZA7H3vOvibY7dTEo4rLYY
         qLJ73p90uzgfKRp1zJg5c0U70gejwiG44umjnL2Xq7p5E696au2fpff0j9j6zCTB28uT
         hjQWNSgX9W+4A0KLXW91S9wtLxADxDhMq4Kh/LnX6JZRXtkjd9uzVobKNvtIWGz1gnaO
         WA2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699041908; x=1699646708;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jqcMVObXfls0ky1XyE/2RgALPyYZ3suExFhfxoDOdHI=;
        b=PxcrOTONsPKR/oUbwftzChPRYzsT5yMslr7FWQBdwC8EcbTEfcTzOMq6iWhdbQK84g
         LdVQqO6dT370c1VTlu3XGhgYLvWT8yKkBSDqNDbo+b5ZmoA2lPEz5F8BtXf7Tw8lrROE
         REEuePs4iLcu6kZh+ePm2TqvWqKhV8WY7eD08WXCJy5VL6i2zjtKhpgo+pUWOL9WcMgk
         ptAFVqBBPAzVuRgAfUFiBOpqRo/o0ODXHvVCNRUI3mPeG1XvYUeLR/ImfP47lbdT3ND9
         bKHkCPltb6kwpcm93oyjd1aqr3aHdxY1rTTaHrBZla/oHepxiwUAs9k75crWWL66OxnR
         nOmQ==
X-Gm-Message-State: AOJu0YxDEspEZJMKr2eb9WTslu6tXwYwqKENttzijQ/xWdzJswEJ+TcD
	yzLyFBdZ2BOCoy4SQLLA2UsU4SQFRyw=
X-Google-Smtp-Source: AGHT+IGH4Rtieqwe95qBNeWUXhNQ+Ebl8RlTr4T8qnuOOz8KnxiiMEnAz51IwzHps12wkHgG32ggh8NaFYw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d9d5:0:b0:59b:f493:813d with SMTP id
 b204-20020a0dd9d5000000b0059bf493813dmr73742ywe.1.1699041908564; Fri, 03 Nov
 2023 13:05:08 -0700 (PDT)
Date: Fri, 3 Nov 2023 13:05:07 -0700
In-Reply-To: <CAF7b7mpzkjvBTybbaEUSp7iL3dVURVi+rDtkkojOcXAY=Bk9=g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com> <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
 <CAF7b7mpzkjvBTybbaEUSp7iL3dVURVi+rDtkkojOcXAY=Bk9=g@mail.gmail.com>
Message-ID: <ZUVSc-Cu3LaeAcWd@google.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: David Matlack <dmatlack@google.com>, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 02, 2023, Anish Moorthy wrote:
> I'm going to squash this into patch 9: the fact that it's separated is
> a holdover from when the memslot flag check lived in arch-specific
> code.
> 
> Proposed commit message for the squashed commit
> 
> > KVM: Add KVM_CAP_EXIT_ON_MISSING which forbids page faults in stage-2 fault handlers

Please don't use "forbids page faults".  As I said earlier:

 : "Forbid fault" is rather nonsensical because a fault has already happened.  The
 : confusion between "page fault VM-Exit" and "faulting in memory in the host" is
 : the main reason we wandered away from anything with "fault" in the name.

The part that is being "forbidden" is not a "page fault", it's the act of faulting
in a page.  And "forbids" doesn't add any clarity to KVM_CAP_EXIT_ON_MISSING; if
anything, it muddies the waters by making it sound like page faults somehow become
fatal.

Regarding the capability, stating the capability name is both unnecessary and
uninteresting.  The fact that there's a new capability is an implementation detail,
it's in no way needed to understand the basic gist of the patch, which is basically
*the* role of the shortlog.

The key things to cover in the shortlog:

 * What does the feature do?   Exits when an hva isn't fully mapped
 * Who controls the behavior?  Userspace
 * How is the feature enabled? Memslot flag

I would go with something like:

  KVM: Add memslot flag to let userspace force an exit on missing hva mappings

> > Faulting in pages via the stage-2 fault handlers can be undesirable in
> > the context of userfaultfd-based postcopy: contention for userfaultfd's
> > internal wait queues can cause significant slowness when delivering
> > faults to userspace. A performant alternative is to allow the stage-2
> > fault handlers to, where they would currently page-fault on the
> > userspace mappings, exit from KVM_RUN and deliver relevant information
> > to userspace via KVM_CAP_MEMORY_FAULT_INFO. This approach avoids
> > contention-related issues.
> 
> > Add, and mostly implement, a capability through which userspace can
> > indicate to KVM (through the new KVM_MEM_EXIT_ON_MISSING memslot flag)
> > that it should not fault in pages from the stage-2 fault handlers.
> 
> > The basic implementation strategy is to check the memslot flag from
> > within __gfn_to_pfn_memslot() and override the "atomic" parameter
> > accordingly. Some callers (such as kvm_vcpu_map()) must be able to opt
> > out of this behavior, and do so by passing the new can_exit_on_missing
> > parameter as false.
> 
> > No functional change intended: nothing sets KVM_MEM_EXIT_ON_MISSING.
> 
> One comment/question though- as I have the (sqaushed) patches/new
> commit message written, I think it could mislead readers into thinking
> that callers that pass can_exit_on_missing=false to
> __gfn_to_pfn_memslot() *must* do so. But at least some of these cases,
> such as the ones in the powerpc mmu, I think we're just punting on.
> 
> I see a few options here
> 
> 1. Make all callers pass can_exit_on_missing=false, and leave the
> =true update to the x86/arm64 specific "enable/annotate
> KVM_EXIT_ON_MISSING" commits [my preference]

This one.  Nothing should pass %true until the caller fully supports
KVM_MEM_EXIT_ON_MISSING.

> 2. Make the powerpc callers pass can_exit_on_missing=true as well,
> even though we're not adding KVM_CAP_EXIT_ON_MISSING for them
> 
> 3. Add a disclaimer in the commit message that some cases where
> can_exit_on_missing=false could become =true in the future
> 
> 4. Things are fine as-is and I'm making a mountain out of a molehill
> 
> Any thoughts?

