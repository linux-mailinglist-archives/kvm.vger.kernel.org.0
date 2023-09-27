Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5C27B06AF
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 16:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbjI0OZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 10:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbjI0OZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 10:25:24 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467B8139
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 07:25:23 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d858d1bdf0aso17117461276.1
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 07:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695824722; x=1696429522; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DqAxbQV9ra/o+abZK/vXaA4SUDewuk6D2ce8STXbtvU=;
        b=gEOaL0Vs4YogqAoEZ5IXf+8QmxNbryq9ea4Ux4iBu3Gj2ixWmPmSY/n6SWQJLdRzIw
         GUoRFFf1rxcmF9hAoFeRCrYEvDrbqvDwanpaKNBWdNHLixGrtx9Zt3Hj5eDu+SFsFCBc
         QQGBsJUDY4x1bFvyLj0WTI4duZAIurru7nKdo/ak/0F36ko9sZMwYUPR7pXhvr/86WPF
         hrFd9+HCnzs+FCwG1VITSS3jgTPe8ke2MPQMm1EK9Mnuyoy7dGlvzEcXlftGYVKB89m8
         Be3Nzc9CGV+REbti1AzvFHQn3+GM9z3v9eNcyC0XwCkv7wjRYDvm5bt1csb2LoLZjPRs
         DnBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695824722; x=1696429522;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DqAxbQV9ra/o+abZK/vXaA4SUDewuk6D2ce8STXbtvU=;
        b=B4P9a3K5Bqrnmgx0sfvgpzQ8KJVwyZlE3qYZjBxS4szK6x2xOoI3aKPENOfM4WELFu
         RsRIo9RaRlIxd2FTk1g3iZoRZEMZXt2yB2LU8eEljlyZapbZP8AdTaO6wfLdYffnw81T
         +dRPypoRs56CvSicUJYgyP0ZgIwHn9BdN/MFs/36dSjB25ybFWs5vxZpmOOymGwwEW72
         usxByiEdu5jgO0Y9JEwMiQi1rKwOlWr+RZ20tGfx5QDwBT3u87guY+8Nx+BAHNPRZDBe
         2ucjGn5G+bFNpNdfvkKQeaNKtS4NUGO//lOKdk7wvKFH7/67yJ3H5+9eCifQrwqX7QBE
         BzNA==
X-Gm-Message-State: AOJu0Yy/NQ+xseMdxPR5TqrorhG2nXb6YsIRXUPUls8eMXs/OeuE9rC6
        EEZPSOkmARqPRdo+b9chk5y0j0G5Mxg=
X-Google-Smtp-Source: AGHT+IECviyK2mWw7YEH/ELrmynpu1LCdY1pd2TucuzEdK/OXrDiGIiGPSa1RKhlW0+0ZPBNklQubZOh/Lc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1821:b0:d81:43c7:61ed with SMTP id
 cf33-20020a056902182100b00d8143c761edmr28872ybb.5.1695824722347; Wed, 27 Sep
 2023 07:25:22 -0700 (PDT)
Date:   Wed, 27 Sep 2023 07:25:21 -0700
In-Reply-To: <303a3382-32e7-6afd-bdfa-1cefdbdfb41e@linux.intel.com>
Mime-Version: 1.0
References: <20230921203331.3746712-1-seanjc@google.com> <20230921203331.3746712-8-seanjc@google.com>
 <303a3382-32e7-6afd-bdfa-1cefdbdfb41e@linux.intel.com>
Message-ID: <ZRQ7USnIybRXx-GR@google.com>
Subject: Re: [PATCH 07/13] KVM: x86/mmu: Track PRIVATE impact on hugepage
 mappings for all memslots
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 27, 2023, Binbin Wu wrote:
> 
> On 9/22/2023 4:33 AM, Sean Christopherson wrote:
> > Track the effects of private attributes on potential hugepage mappings if
> > the VM supports private memory, i.e. even if the target memslot can only
> > ever be mapped shared.  If userspace configures a chunk of memory as
> > private, KVM must not allow that memory to be mapped shared regardless of
> > whether or not the *current* memslot can be mapped private.  E.g. if the
> > guest accesses a private range using a shared memslot, then KVM must exit
> > to userspace.
> How does usersapce handle this case?
> IIRC, in gmem v12 patch set, it says a memslot can not be convert to private
> from shared.
> So, userspace should delete the old memslot and and a new one?

That depends on the contract between userspace and the VM, e.g. if the access is
to a range that the VMM and the guest have agreed is shared-only, then the VMM
could also "resolve" the access by injecting an error or killing the VM.

But yes, deleting the memslot and creating a new one is the only approach that
will work if userspace wants to map the gfn as private.  I don't actually expect
any real world VMMs to actually do anything like this, the purpose of this change
is mainly to ensure KVM has robust, consistent behavior.
