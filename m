Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9F06C3C5E
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 22:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjCUVBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 17:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjCUVBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 17:01:14 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC03E4782F
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 14:01:12 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id x3-20020a62fb03000000b00622df3f5d0cso8161258pfm.10
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 14:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679432472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0N6t6sqV0oL0lRyqNWKd+/lniHULQdxKIneVfna8+og=;
        b=ZqJHtTjsiIeKKxjCz9NhJNHM2mMf8frOgktsHErDp5xRAW4yXGhD9QFxDKkYYuisBM
         Sckwo17qkGzfyvP57JuOq0a53QoTWhUyZsaAqabGq7xD37MTJckFW/g6MRQUK+lDew7X
         se6f8dfb3XLiLYSq1KYetFMVqKd59CRX3sIGRMle1xag/YC4sTln0YrOfvMzfukJ+O7F
         SS+gV+f6Qk9jROMXFGohx2K1DQWTLGMk3jXzUDZjWlprCwH7yPR7kS2zzmyoY+TNDkZI
         e9fl88w5SeB/LViUNC8xlFXEcfTo5bzZ5hJdCTJCcswsBPdNb42+7fKI5G1D+UpWHEgZ
         0R0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679432472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0N6t6sqV0oL0lRyqNWKd+/lniHULQdxKIneVfna8+og=;
        b=SXqnCjt2VwBzzfHbZ6xBayc1uBOELwkhQIr+pu/fA5r6BLC3WIj63L+pR9JYy7LXQJ
         cL2Z5y5IOhps8bjwbDIvhPhKhuiVY4lILBMG4t0yBNVuwdnr7NmIqzQzcsJQnGKcd3vF
         FhOYIh7iSyXhGeU2xXIJXcsmETy6vBckDoCMn+Nl0je5K1zLt9ml/oZWq++2U0iDDdfd
         6vuAqC2brrCnhb844c+o/dUgOfgbJvV8O6krTcdXk+TIkNvCeeqJfYoajZoIdojPPw2g
         TmX+p5pW6ZKKoFePuwhGp0WQ+F83w3mgiuJjRIxRm2aPd9RPTlJWTzEujZRKkgcUV8Gj
         Zh7Q==
X-Gm-Message-State: AO0yUKVOUf9akFVtyqEPOGte2MC8Mdbqb8yP9P0W5BVjgrgqdb+OU1L6
        ASc8QyPGj+ceYzbTfY3Ji2hilmTv/LA=
X-Google-Smtp-Source: AK7set9VRl2/QeHD3n8uLrf81WKmAudtbnGPGdryJ4VOIZem8IKUq69HaEEYveWcpeGuYTM81B79anBiYak=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:dac5:b0:23d:50c2:939a with SMTP id
 g5-20020a17090adac500b0023d50c2939amr440031pjx.1.1679432472396; Tue, 21 Mar
 2023 14:01:12 -0700 (PDT)
Date:   Tue, 21 Mar 2023 14:01:11 -0700
In-Reply-To: <ZBoSKm3CUoBC0l5X@linux.dev>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-10-amoorthy@google.com>
 <ZBS4o75PVHL4FQqw@linux.dev> <ZBTK0vzAoWqY1hDh@google.com>
 <ZBjckKb6eWx2vSin@linux.dev> <ZBnEO5l7hZMlhi/1@google.com> <ZBoSKm3CUoBC0l5X@linux.dev>
Message-ID: <ZBobF0cGBOHd4VGw@google.com>
Subject: Re: [WIP Patch v2 09/14] KVM: Introduce KVM_CAP_MEMORY_FAULT_NOWAIT
 without implementation
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Anish Moorthy <amoorthy@google.com>, jthoughton@google.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023, Oliver Upton wrote:
> On Tue, Mar 21, 2023 at 07:50:35AM -0700, Sean Christopherson wrote:
> > On Mon, Mar 20, 2023, Oliver Upton wrote:
> > > On Fri, Mar 17, 2023 at 01:17:22PM -0700, Sean Christopherson wrote:
> > > > On Fri, Mar 17, 2023, Oliver Upton wrote:
> > > > > I'm not a fan of this architecture-specific dependency. Userspace is already
> > > > > explicitly opting in to this behavior by way of the memslot flag. These sort
> > > > > of exits are entirely orthogonal to the -EFAULT conversion earlier in the
> > > > > series.
> > > > 
> > > > Ya, yet another reason not to speculate on why KVM wasn't able to resolve a fault.
> > > 
> > > Regardless of what we name this memslot flag, we're already getting explicit
> > > opt-in from userspace for new behavior. There seems to be zero value in
> > > supporting memslot_flag && !MEMORY_FAULT_EXIT (i.e. returning EFAULT),
> > > so why even bother?
> > 
> > Because there are use cases for MEMORY_FAULT_EXIT beyond fast-only gup.
> 
> To be abundantly clear -- I have no issue with (nor care about) the other
> MEMORY_FAULT_EXIT changes. If we go the route of explicit user opt-in then
> that deserves its own distinct bit of UAPI. None of my objection pertains
> to the conversion of existing -EFAULT exits.
> 
> > We could have the memslot feature depend on the MEMORY_FAULT_EXIT capability,
> > but I don't see how that adds value for either KVM or userspace.
> 
> That is exactly what I want to avoid! My issue was the language here:
> 
>   +(*) NOTE: On x86, KVM_CAP_X86_MEMORY_FAULT_EXIT must be enabled for the
>   +KVM_MEMFAULT_REASON_ABSENT_MAPPING_reason: otherwise userspace will only receive
>   +a -EFAULT from KVM_RUN without any useful information.
> 
> Which sounds to me as though there are *two* UAPI bits for the whole fast-gup
> failed interaction (flip a bit in the CAP and set a bit on the memslot, but
> only for x86).

It won't be x86 only.  Anish's proposed patch has it as x86 specific, but I think
we're all in agreement that that is undesirable.  There will inevitably be per-arch
enabling and enumeration, e.g. to actually fill information and kick out to
userspace, but I don't see a sane way to avoid that since the common paths don't
have the vCPU (largely by design).

> What I'm asking for is this:
> 
>  1) A capability advertising MEMORY_FAULT_EXIT to userspace. Either usurp
>    EFAULT or require userspace to enable this capability to convert
>    _existing_ EFAULT exits to the new way of the world.
> 
>  2) A capability and a single memslot flag to enable the fast-gup-only
>    behavior (naming TBD). This does not depend on (1) in any way, i.e.
>    only setting (2) should still result in MEMORY_FAULT_EXITs when fast
>    gup fails. IOW, enabling (2) should always yield precise fault
>    information to userspace.

Ah, so 2.2, providing precise fault information on fast-gup-only failures, is the
biggest (only?) point of contention.

My objection to that behavior is that it's either going to annoyingly difficult to
get right in KVM, and even more annoying to maintain, or we'll end up with "fuzzy"
behavior that userspace will inevitably come to rely on, and then we'll be in a real
pickle.  E.g. if KVM sets the information without checking if gup() itself actually
failed, then KVM _might_ fill the info, depending on when KVM detects a problem.

Conversly, if KVM's contract is that it provides precise information if and only
if gup() fails, then KVM needs to precisely propagate back up the stack that gup()
failed.

To avoid spending more time going in circles, I propose we try to usurp -EFAULT
and convert all userspace-exits-from-KVM_RUN -EFAULT paths on x86 (as a guinea pig)
without requiring userspace to opt-in.  If that approach pans out, then this point
of contention goes away because 2.2 Just Works.
