Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E565B7B8D60
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 21:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244220AbjJDT2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 15:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233878AbjJDT2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 15:28:33 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B32E4
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 12:28:30 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-2775a7f3803so120868a91.1
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 12:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696447709; x=1697052509; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xxSoyXSvQVFxo0yBpA42WtLsckD9IYXTzkM+s4NdFLg=;
        b=J4ARSByz8SZNb1g5TisIR/uRRSd536grGwuuUf4HB0+ZPL+Llp3IT3vWjj6bfOCq2k
         x5hHcKjbrXBbIdLqsuZT1sbFk5ARIf2+kZZoU/MgDm+aKtm84IiWT++76fi88L8epw9n
         /eLdcQwhTO374lHZzKQY2Y7b5aunZgFCMiJC9ro+YxxqRCO5Ms6p3OnFYlghhZ/ZInOE
         DVyIS65+XZyiRm0zM1hiRjnIvcSuw1KVaH4IvMKf8p8xLU8mFsrJXRnki019iXxHV/45
         0QDonqdWoLlLjRZdnITqvZOYx+ODI+vj5iL+QVq6nxbMCiHIdB+OMLvEdeO0hR/zGpDE
         X4rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696447709; x=1697052509;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xxSoyXSvQVFxo0yBpA42WtLsckD9IYXTzkM+s4NdFLg=;
        b=AzAMLAFYlPU8jLEAO0+lzKC4QVHXVBAaceVOw7TWEgyL/ZUnjIdkEiWQz7846Cagq2
         gU9SJnehOVi0+XwCtjoXVLfFn1W0oLjq/WRuEza+AY9sm66Sfl1uJENRJlbaiE9d1EPT
         Ba+a04O+KBxX4f/1HizYUAUr1XlenUu/7KJ7L3BQ5l7+LQ9X5Tc4jbaS71sJYlLz9zGl
         oQ3XISy2RsnB8lQ5oXC/ke0acJ6R1c+TDsj9RPTDObsNYayrmBHKSygfRXbMLSPMSLlj
         sgOltMjtP2NO3QbRq21wUR7cwA+RYh03/g88WYGJ6OHWDDx2RKuXvZAVwGCHAGyEqsEl
         reWg==
X-Gm-Message-State: AOJu0Yy7d1iDaJyRcDym0GqiYIVixq654hu79/2CIAZA43BV1TjSVzp2
        X85gvkF4/TaPSAAzD5cC3lrr0sLK7xY=
X-Google-Smtp-Source: AGHT+IHGAprULVNsSMDBVG60XyQUOGoBMWDKQKvodunVgyK5JsoH87cSPgPFTgldXtBYelcr+QQgTGCa55U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4584:b0:269:6494:cbc8 with SMTP id
 v4-20020a17090a458400b002696494cbc8mr51185pjg.4.1696447709563; Wed, 04 Oct
 2023 12:28:29 -0700 (PDT)
Date:   Wed, 4 Oct 2023 12:28:28 -0700
In-Reply-To: <169592099261.2962597.3938666115023271118.b4-ty@google.com>
Mime-Version: 1.0
References: <CAPm50aKwbZGeXPK5uig18Br8CF1hOS71CE2j_dLX+ub7oJdpGg@mail.gmail.com>
 <169592099261.2962597.3938666115023271118.b4-ty@google.com>
Message-ID: <ZR283JqDK3vLEt5A@google.com>
Subject: Re: [PATCH RESEND] KVM: X86: Reduce size of kvm_vcpu_arch structure
 when CONFIG_KVM_XEN=n
From:   Sean Christopherson <seanjc@google.com>
To:     pbonzini@redhat.com, Hao Peng <flyingpenghao@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 28, 2023, Sean Christopherson wrote:
> On Tue, 05 Sep 2023 09:07:09 +0800, Hao Peng wrote:
> > When CONFIG_KVM_XEN=n, the size of kvm_vcpu_arch can be reduced
> > from 5100+ to 4400+ by adding macro control.
> 
> Applied to kvm-x86 misc.  Please fix whatever mail client you're using to send
> patches, the patch was heavily whitespace damaged.  I fixed up this one because
> it was easy to fix and a straightforward patch.
> 
> [1/1] KVM: X86: Reduce size of kvm_vcpu_arch structure when CONFIG_KVM_XEN=n
>       https://github.com/kvm-x86/linux/commit/fd00e095a031

FYI, I've moved this to "kvm-x86 xen".  There are enough Xen patches coming in
that I didn't want to dump them all in "misc", and I also didn't want to have
one lone Xen patch in a different pull request.

[1/1] KVM: X86: Reduce size of kvm_vcpu_arch structure when CONFIG_KVM_XEN=n
      https://github.com/kvm-x86/linux/commit/ee11ab6bb04e
