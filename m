Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA1071F280
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 20:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbjFAS7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 14:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjFAS7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 14:59:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1A818C
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 11:59:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba8337a578dso1643301276.1
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 11:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685645971; x=1688237971;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qJOx7I0xCkV35wIsNvYW7Jhj+8WWm8gR/LQFgLlS698=;
        b=QNVtC9QVasf0ux3t9XaObgkbyYr54/RquLz9RESlY62kUgN17r/zEeoISMwmkL5BQy
         KyhWRkyqjLGq8Fiu4/V344VDsBwi20d9IW/jEF1gn+rQU/4ah2ioMKZfX7n+2uZY+jrM
         oA47tCSBhwtFZvmNEsdotujwXca+GrOZyiOuHRDsCMtdOdvBhJKYmWnONzvZXmPeh5jw
         u0kJEee8nV6QdQkZjXvhbgFpSLIugppVNFioOdmbNbK1KUBCO0rJBGycymHj16WaW0cS
         NHpCIwA8BWpC5TAFJaFAVktPh78P9D93VLd2iQPgq23+PUrRGv6tX9A023CzQ8jFfGiP
         sO0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685645971; x=1688237971;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qJOx7I0xCkV35wIsNvYW7Jhj+8WWm8gR/LQFgLlS698=;
        b=iFM77L9U+pCTR2FqUeEfrq6H014fXzpO3NmyHgiAiEwGI5vpDgp5njqy11mxDGTl7/
         8jloHoHo0QiAyieT5DLwuQ5vYYF81plCBGQq75p2hJ8KV953f02BKbShO2CzpQG00IW8
         FiTTayRxqcg/755o2Gy9kgZ4xhQSGi4d3FIauZRt7YfrOvG0hW413mLgoR2ass/7FiR8
         h0v63xX3VZnN2D6MRdUKNPsmrSRqByHsSErFPmTKajv9x51UI5afxKzyuMFtDR9nngv+
         wZwqItOWJJNoUJaGQcFya+F6vAkc3NHgsAilPnil2ZWnknMgjVavviBpHVTZG7+KGza4
         L6aA==
X-Gm-Message-State: AC+VfDzd1ldVIX9PWSoOaxkDme0yTkrReTV6cLngVl2GeC0uiQtz95P7
        F9nXtLNJrfStJ2pRBj1FZEU7NVM0DHE=
X-Google-Smtp-Source: ACHHUZ776RIsLAJHtRxsT3JEXHMBTJHnaFb6fdlNSrbCtcvbGCZnuNmw5RA+Io6V5+yiGghbvGuUfeoRLTg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1546:b0:ba8:93c3:393b with SMTP id
 r6-20020a056902154600b00ba893c3393bmr549272ybu.2.1685645971014; Thu, 01 Jun
 2023 11:59:31 -0700 (PDT)
Date:   Thu, 1 Jun 2023 11:59:29 -0700
In-Reply-To: <ZHjhSZFwEc+VfjGk@linux.dev>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-18-amoorthy@google.com>
 <ZHjhSZFwEc+VfjGk@linux.dev>
Message-ID: <ZHjqkdEOVUiazj5d@google.com>
Subject: Re: [PATCH v3 17/22] KVM: Introduce KVM_CAP_ABSENT_MAPPING_FAULT
 without implementation
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Anish Moorthy <amoorthy@google.com>, pbonzini@redhat.com,
        maz@kernel.org, jthoughton@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
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

On Thu, Jun 01, 2023, Oliver Upton wrote:
> Anish,
> 
> On Wed, Apr 12, 2023 at 09:35:05PM +0000, Anish Moorthy wrote:
> > +7.35 KVM_CAP_ABSENT_MAPPING_FAULT
> > +---------------------------------
> > +
> > +:Architectures: None
> > +:Returns: -EINVAL.
> > +
> > +The presence of this capability indicates that userspace may pass the
> > +KVM_MEM_ABSENT_MAPPING_FAULT flag to KVM_SET_USER_MEMORY_REGION to cause KVM_RUN
> > +to fail (-EFAULT) in response to page faults for which the userspace page tables
> > +do not contain present mappings. Attempting to enable the capability directly
> > +will fail.
> > +
> > +The range of guest physical memory causing the fault is advertised to userspace
> > +through KVM_CAP_MEMORY_FAULT_INFO (if it is enabled).
> 
> Maybe third time is the charm. I *really* do not like the
> interdependence between NOWAIT exits and the completely orthogonal
> annotation of existing EFAULT exits.

They're not completely orthogonal, because the touchpoints for NOWAIT are themselves
existing EFAULT exits.

> How do we support a userspace that only cares about NOWAIT exits but
> doesn't want other EFAULT exits to be annotated?

We don't.  The proposed approach is to not change the return value, and the
vcpu->run union currently holds random garbage on -EFAULT, so I don't see any reason
to require userspace to opt-in, or to let userspace opt-out.  I.e. fill
vcpu->run->memory_fault unconditionally (for the paths that are converted) and
advertise to userspace that vcpu->run->memory_fault *may* contain useful info on
-EFAULT when KVM_CAP_MEMORY_FAULT_INFO is supported.  And then we define KVM's
ABI such that vcpu->run->memory_fault is guarateed to be valid if an -EFAULT occurs
when faulting in guest memory (on supported architectures).

> It is very likely that userspace will only know how to resolve NOWAIT exits
> anyway. Since we do not provide a precise description of the conditions that
> caused an exit, there's no way for userspace to differentiate between NOWAIT
> exits and other exits it couldn't care less about.
> 
> NOWAIT exits w/o annotation (i.e. a 'bare' EFAULT) make even less sense
> since userspace cannot even tell what address needs fixing at that
> point.
> 
> This is why I had been suggesting we separate the two capabilities and
> make annotated exits an unconditional property of NOWAIT exits.

No, because as I've been stating ad nauseum, KVM cannot differentiate between a
NOWAIT -EFAULT and an -EFAULT that would have occurred regardless of the NOWAIT
behavior.  Defining the ABI to be that KVM fills memory_fault if and only if the
slot has NOWAIT will create a mess, e.g. if an -EFAULT occurs while userspace
is doing a KVM_SET_USER_MEMORY_REGION to set NOWAIT, userspace may or may not see
valid memory_fault information depending on when the vCPU grabbed its memslot
snapshot.
