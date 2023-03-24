Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611986C8595
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 20:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjCXTGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 15:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjCXTGK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 15:06:10 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0A3206AD
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:05:29 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id i192-20020a6287c9000000b0062a43acb7faso1389603pfe.8
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679684729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qleB3P7WVutzXYmny5oxbrMkbVwMp0llVxw26iKplOs=;
        b=I0e9LJkal32naclnVkHmlzzVRGLOLeesIKTka6k+hooxm19EVE18/ESezBGjV1zL/l
         y7I7Cc7q6vnN19K9uxfZL0TyPY6NidWBdwEAWMU6Db3m9izacQdBuDTqAn5+0QjrVz1q
         pQBiyyPAwxkfUQd4QOwRYJNP8NJJ5Rhzu/qNVzRdCLAOe6ZpqKWGJVRviQrv3CNyGgtm
         3P8sWO+xB11Pie1uXUgivRo+GFuUGcgVPut508BVWjKbCCYNmBM3t2QQKqZiq+OeOF3d
         SmC1mX8GdY0Gl//cM5G4VmfyPn3BrQLkDKNAAoD0xl1DeGtm/GPj3bW0V+uSBdzjyboh
         +eeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679684729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qleB3P7WVutzXYmny5oxbrMkbVwMp0llVxw26iKplOs=;
        b=vqUGkTemczLZIlRPA7rLpl2/EYnsaaa1XVJMpPfmlG56YvKTBbp7gwbu6WqarL5w9w
         qMpRoSYglaKromSv3WMe5xK4H1xq7va93ncSDUEIWZdtvU0HPBf+cRseEDEHXxYewYrV
         MtrnFm6rq9ahANMBhCMiOPPPlRi27eqG6JwuVOzRElLLkJyMTi83znjs1LLhbzF8TqeL
         wKGuuYkGeqT+Y8Brc38gB85L7Lxw0fKj2QiltNfh3vkK7d5b4IdSU4AFZh851coBG/j7
         UhVMU0uHAhMzfZR7onjhUWv+j6pIVJU4PQxdnMM3MR76HXbGMK6k5PjSoFYcZUtqqz9y
         c7dg==
X-Gm-Message-State: AAQBX9e6ZRiRZFI8V5mQSRarGGLAC789j6jXy/FEY7zgGEa3k10b80RZ
        70ZrnIlyWl22MIfquemQVL6XTiseTcI=
X-Google-Smtp-Source: AKy350aLHsdwV60R7nRoP9dofFEYpJ7lTPhY7EyWYApLxWkg2BRIRMKeSJXDVW7mV5gBYgm01Z+5EKUwX48=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:da02:0:b0:513:290b:7516 with SMTP id
 c2-20020a63da02000000b00513290b7516mr617980pgh.3.1679684729474; Fri, 24 Mar
 2023 12:05:29 -0700 (PDT)
Date:   Fri, 24 Mar 2023 12:05:28 -0700
In-Reply-To: <20230110175057.715453-1-pgonda@google.com>
Mime-Version: 1.0
References: <20230110175057.715453-1-pgonda@google.com>
Message-ID: <ZB30eAFfZznEEjZ3@google.com>
Subject: Re: [PATCH V6 0/7] KVM: selftests: Add simple SEV test
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, pbonzini@redhat.com, andrew.jones@linux.dev,
        vannapurve@google.com, Ackerley Tng <ackerleytng@google.com>
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

On Tue, Jan 10, 2023, Peter Gonda wrote:
> This patch series continues the work Michael Roth has done in supporting
> SEV guests in selftests. It continues on top of the work Sean
> Christopherson has sent to support ucalls from SEV guests. Along with a
> very simple version of the SEV selftests Michael originally proposed.

...

> Michael Roth (2):
>   KVM: selftests: sparsebit: add const where appropriate
>   KVM: selftests: add support for protected vm_vaddr_* allocations
> 
> Peter Gonda (5):
>   KVM: selftests: add hooks for managing protected guest memory
>   KVM: selftests: handle protected bits in page tables
>   KVM: selftests: add library for creating/interacting with SEV guests
>   KVM: selftests: Update ucall pool to allocate from shared memory
>   KVM: selftests: Add simple sev vm testing

Lot's of non-trivial feedback.  To help move things along, I pushed a completely
untested (probably doesn't compile) branch to

  https://github.com/sean-jc/linux/tree/x86/sev_selftests_for_peter

that has most of the feedback incorporated.  Feel free to massage/rework things
as needed (and again, it needs testing+polishing), my goal is purely to avoid you
having to duplicate what I've already done as part of working through the review.
