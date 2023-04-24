Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A17B6ED67B
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 23:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjDXVCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 17:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjDXVCw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 17:02:52 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FCC6184
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 14:02:51 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1a6a6727792so34080515ad.3
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 14:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682370171; x=1684962171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1uQH+wYaaizJExDZ1lotMDM9eIvQ+68rMtzBLQSleuw=;
        b=JneI2OA1E1OdqMOTyHcP8Y4VRO/M9RnrlgeSCeKHVB/FO2c1RrSNkRY+pwhBQSagr9
         CG0AaAJpky4z/4V7+t/RIIm80pjtl/IqdteWNQmgaoC+MOd/d6rZ1b24CKGJyTvHyaGo
         AV0Xw1Acxxm7AJCajRLwNYES6xPwR9kmnhi1aUhi69yfSewYM0mA4TFl8z+Y1eFNLszv
         IXMuxLbTgs8s+MX6S41BCw/c9/u/4V5a5U2OpYp6Ry6mBQqI3TlvBeqaG5KYh12Sa3UT
         XvTaYOE3cLoAOU9mf8evSTQ4tohh44X8ZEk537Gpl1aQym7ARKB6YEc8RnyBPGvwLQhu
         2krg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682370171; x=1684962171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1uQH+wYaaizJExDZ1lotMDM9eIvQ+68rMtzBLQSleuw=;
        b=HeFLY4Un54FeYEiDScOVehOL/DMuK5QJzTxTQhiy84RaK9s8jLturfPwt4cUkDALTl
         XKozmTA+tMKzBO4FBG9T+CLUOlWWpQi3rVApDStvvXEu8KKd0LIHMgXWjq9TfkERJILI
         +oWGwNwVzlcdiX1//NgHK3y5211zbl1LS/ni/SH9XgzKKjN0RO/7uECWiW+0G1yrdizX
         dlT20AjKJ9p1vvxjrVhbzW8VSgMHyaYQo7sZ89nE/r90ZCq6/zkCflyXiC+ZRsCWzeBb
         2xvD+sqegF2Y7EFIvP5SnwSJN6I7vD8jgNIHK3WM1klrzVzVBC+Dl4HIuVYYFOWQ18bf
         skvw==
X-Gm-Message-State: AAQBX9ecr6yunmWfFb+lfk4Boma5GPMzTc3YJh79mNkROaUVvmlfL4j+
        vi6qZYeCBF1Sx1izAN6k6lX12yf1maw=
X-Google-Smtp-Source: AKy350ZVpddszBRkUO90RIV24p1F+ndg4m9IYyTcWuFgHIzNl/wA4ph7nNO9wTPMyU14d/M6m8Ee39OmARo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:214d:b0:1a9:62fb:7b06 with SMTP id
 s13-20020a170903214d00b001a962fb7b06mr2252373ple.7.1682370170756; Mon, 24 Apr
 2023 14:02:50 -0700 (PDT)
Date:   Mon, 24 Apr 2023 14:02:49 -0700
In-Reply-To: <20230412213510.1220557-18-amoorthy@google.com>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-18-amoorthy@google.com>
Message-ID: <ZEbueTfeJugSl31X@google.com>
Subject: Re: [PATCH v3 17/22] KVM: Introduce KVM_CAP_ABSENT_MAPPING_FAULT
 without implementation
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        jthoughton@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
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

On Wed, Apr 12, 2023, Anish Moorthy wrote:
> Add documentation, memslot flags, useful helper functions, and the
> actual new capability itself.
> 
> Memory fault exits on absent mappings are particularly useful for
> userfaultfd-based postcopy live migration. When many vCPUs fault on a
> single userfaultfd the faults can take a while to surface to userspace
> due to having to contend for uffd wait queue locks. Bypassing the uffd
> entirely by returning information directly to the vCPU exit avoids this
> contention and improves the fault rate.
> 
> Suggested-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 31 ++++++++++++++++++++++++++++---
>  include/linux/kvm_host.h       |  7 +++++++
>  include/uapi/linux/kvm.h       |  2 ++
>  tools/include/uapi/linux/kvm.h |  1 +
>  virt/kvm/kvm_main.c            |  3 +++
>  5 files changed, 41 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index f174f43c38d45..7967b9909e28b 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1312,6 +1312,7 @@ yet and must be cleared on entry.
>    /* for kvm_userspace_memory_region::flags */
>    #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
>    #define KVM_MEM_READONLY	(1UL << 1)
> +  #define KVM_MEM_ABSENT_MAPPING_FAULT (1UL << 2)

This name is both too specific and too vague.  It's too specific because it affects
more than just "absent" mappings, it will affect any page fault that can't be
resolved by fast GUP, i.e. I'm objecting for all the same reasons I objected to
the exit reason being name KVM_MEMFAULT_REASON_ABSENT_MAPPING.  It's too vague
because it doesn't describe what behavior the flag actually enables in any way.

I liked the "nowait" verbiage from the RFC.  "fast_only" is an ok alternative,
but that's much more of a kernel-internal name.

Oliver, you had concerns with using "fault" in the name, is something like
KVM_MEM_NOWAIT_ON_PAGE_FAULT or KVM_MEM_NOWAIT_ON_FAULT palatable?  IMO, "fault"
is perfectly ok, we just need to ensure it's unlikely to be ambiguous for userspace.
