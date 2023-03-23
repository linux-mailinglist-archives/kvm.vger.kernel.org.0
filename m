Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038506C5BC0
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 02:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjCWBOt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 21:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjCWBOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 21:14:46 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F2A6E90
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 18:14:45 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id n18-20020a17090ac69200b002401201f1f9so214509pjt.2
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 18:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679534085;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BJykVyWZaPOMoDqRHQXOF5YkglH1GiNEZ9yGuzePcG8=;
        b=JedfSPutGU8QbZzEeo+YZQWnnPEiXoSM2cIiw1mDHU8Ck0gSujsuyVXvnLyntB1ezq
         bb4Oj08UfITgj0Cl3bKxUxlndRN+9o2r3maeSZb7V95LfG9mivfliQL4zeAs289rl+F5
         Ajt3SqVzBzewwzm2sZ4nPT++G4J9ZkQb1ABnfkWtWX8M/+Z2T5EiwC6TwCbwq4oTYZBq
         WkptjEjELnIYskJs4IvncS8Lg1huMLfIfpIywLCpSdoRWWdeZoWLWWwQ5A/ujoQfXhth
         Ql+Txx++A2/MWhtLDSzb41j1QnaH4kLlD57n02s/ZgewdK5OVVSktvylGRBlQbEOxt74
         T8oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679534085;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BJykVyWZaPOMoDqRHQXOF5YkglH1GiNEZ9yGuzePcG8=;
        b=SpEZ6u6h1n0YsX8KuJPwPZmD5++atULBkFR28jTZfjeyf/oGodW7FBB8WpLWVXlTNY
         DLiLPmhTD81J/h1fK5nd22hSbiQNLwR4O9k/KSUbacFY1652hG1dBF4Kzv9/JoA/nHIn
         bYWGeG+b2bpAwcaZDWlOgJT/9rY590a2T5HmdS5xThAMAx5HajGl+TNe2g7sRa67A8iM
         KcWZtHjYhveIKQHhvddfkhhi5j6JACE889Bnhp8MbdF0yM3cOJX9/Sljow9t3OgquuOl
         MZwIy82WR6hCcE0LRVeQAiRaya8E3TEmaxQBK6EdHEz5H4SjwXc/Evmexn1m0XG114Ds
         2mgQ==
X-Gm-Message-State: AO0yUKXYeGBW2SfiI0A0DlaVlWh13DSiJYVMOB9aXOjKzlvcUCaMDSl5
        6sgugmCFda0Yy2dy0uRMFyUmjecbyGo=
X-Google-Smtp-Source: AK7set8fYsaQCbM2zCy5U4feulBO7zueWAAnuFpg0J2NWj52gUksGeJoaYooLflcdstLioF1BAP5PU4cM5I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:864b:b0:1a0:527b:9189 with SMTP id
 y11-20020a170902864b00b001a0527b9189mr1783844plt.11.1679534085586; Wed, 22
 Mar 2023 18:14:45 -0700 (PDT)
Date:   Wed, 22 Mar 2023 18:14:44 -0700
In-Reply-To: <ZBuj5U29Pv2ak47u@google.com>
Mime-Version: 1.0
References: <20230227084016.3368-1-santosh.shukla@amd.com> <ZBuj5U29Pv2ak47u@google.com>
Message-ID: <ZBuoBOIcQhQ9ehTF@google.com>
Subject: Re: [PATCHv4 00/11] SVM: virtual NMI
From:   Sean Christopherson <seanjc@google.com>
To:     Santosh Shukla <santosh.shukla@amd.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        joro@8bytes.org, linux-kernel@vger.kernel.org,
        mail@maciej.szmigiero.name, mlevitsk@redhat.com,
        thomas.lendacky@amd.com, vkuznets@redhat.com
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

On Wed, Mar 22, 2023, Sean Christopherson wrote:
> On Mon, Feb 27, 2023, Santosh Shukla wrote:
> > Maxim Levitsky (2):
> >   KVM: nSVM: Raise event on nested VM exit if L1 doesn't intercept IRQs
> >   KVM: SVM: add wrappers to enable/disable IRET interception
> > 
> > Santosh Shukla (6):
> >   KVM: nSVM: Don't sync vmcb02 V_IRQ back to vmcb12 if KVM (L0) is
> >     intercepting VINTR
> >   KVM: nSVM: Disable intercept of VINTR if saved RFLAG.IF is 0
> >   x86/cpu: Add CPUID feature bit for VNMI
> >   KVM: SVM: Add VNMI bit definition
> >   KVM: x86: add support for delayed virtual NMI injection interface
> >   KVM: nSVM: implement support for nested VNMI
> > 
> > Sean Christopherson (3):
> >   KVM: x86: Raise an event request when processing NMIs if an NMI is
> >     pending
> >   KVM: x86: Tweak the code and comment related to handling concurrent
> >     NMIs
> >   KVM: x86: Save/restore all NMIs when multiple NMIs are pending
> > 
> >  arch/x86/include/asm/cpufeatures.h |   1 +
> >  arch/x86/include/asm/kvm-x86-ops.h |   2 +
> >  arch/x86/include/asm/kvm_host.h    |  11 ++-
> >  arch/x86/include/asm/svm.h         |   9 ++
> >  arch/x86/kvm/svm/nested.c          |  94 +++++++++++++++---
> >  arch/x86/kvm/svm/svm.c             | 152 +++++++++++++++++++++++------
> >  arch/x86/kvm/svm/svm.h             |  28 ++++++
> >  arch/x86/kvm/x86.c                 |  46 +++++++--
> >  8 files changed, 289 insertions(+), 54 deletions(-)
> 
> Code looks good overall, I'll fixup the changelogs and comments myself.  I just
> need to run it through my usual test flow, which I should get done tomorrow.

Gah, saw something shiny and forgot to finish my thought.

My plan is to get this somewhat speculatively applied and soaking in linux-next asap,
even though the cpufeatures.h change needs more eyeballs.  I'll fixup and force push
if necessary; unless I'm missing something, this is the only SVM specific series
that's destined for 6.4.
