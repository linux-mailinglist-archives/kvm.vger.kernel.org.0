Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9990A7267CD
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 19:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbjFGRyB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 13:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbjFGRyA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 13:54:00 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1337D10CA
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 10:53:59 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-65297b2ccc6so6496294b3a.1
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 10:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686160438; x=1688752438;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9umhDDx5RLSqs4PUU15GxLF/naDFQMNpdyZWZONRojE=;
        b=jjQl0Qb2QEnMWQpUxbfjqGMep3WxQM8t9AzfNRcnhkyFp2Yjau4KyZEbUX2bhIi3h7
         c/mCL4niMQ4hQ7AloWu+grt8efyESK6tt4tBGwIpApfSwhkZrpSf+LLmiAltPzXQykpC
         OfK/ax2q05MKz4Mv0uT6J8algv1uNwakVijZuk6dFOEpLvv/X6OJEKh+e7GeTCdk0uCO
         kIt/EygSxf00YgehgrGq6VXJYAFkvU73GIjQYGLptkmX8b6CyzvpTemfkypm0t4TTAtM
         kq6zBdzMakjwa45BW5I+4w4ZsDvmgiugqm4s5iNphrpynjD/DgRkHyruVeJeZHcNnnFk
         2gSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686160438; x=1688752438;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9umhDDx5RLSqs4PUU15GxLF/naDFQMNpdyZWZONRojE=;
        b=a+/p5DyLqlT/hcu/AunwbEYyJdAPu9zUNnB/wd+Bvno+EeZNTPjagOLTv7tTtvHa86
         4SVcB/uUU+eF5lsEEFDouqGLy48MZVNltH+idhqnuRYeA9eAPF4z0G9ar0YKAaZzUWUc
         /CzKvIxRowEFzDh4Cs9NO2k1qIQwgsrZf/HNT3sIZB5JQwR0IinGkhQ1LmtRospSTj14
         U47/rjqwmbbllzJUXvfzvvO0ONahDkSn1bQ9dV0ZNygfM70R2EI+eiRZJzmq4w6XAGSK
         C/4aJq2ZOOclYk+NBGEl+JW5QBK8R5w6NkMoXOLFiD0wnvUYf1ODMbD5v5CfKF05V//m
         8OcQ==
X-Gm-Message-State: AC+VfDxo1y9sVYnmvp1qBuL6ugSx86+yjJn98SWZ+0t+sdiw8BHOmQvl
        KDgGwFBCbBbSSDN4pPjOmCQAp8fMyDM=
X-Google-Smtp-Source: ACHHUZ7YOa7+mVCZD6c2nz3Vyu2saSP5wXOFiLWnIOWov/85/VLhCA96Vv5uYPEvB9wWxdJ6WetsyS3vpwY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d88:b0:651:cea6:f785 with SMTP id
 fb8-20020a056a002d8800b00651cea6f785mr2762560pfb.0.1686160438575; Wed, 07 Jun
 2023 10:53:58 -0700 (PDT)
Date:   Wed, 7 Jun 2023 10:53:57 -0700
In-Reply-To: <20230607172243.c2bkw43hcet4sfnb@linux.intel.com>
Mime-Version: 1.0
References: <20230602011518.787006-1-seanjc@google.com> <20230602011518.787006-2-seanjc@google.com>
 <20230607073728.vggwcoylibj3cp6s@linux.intel.com> <ZICUbIF2+Cvbb9GM@google.com>
 <20230607172243.c2bkw43hcet4sfnb@linux.intel.com>
Message-ID: <ZIDENf2vzwUjzcl2@google.com>
Subject: Re: [PATCH 1/3] KVM: VMX: Retry APIC-access page reload if
 invalidation is in-progress
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
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

On Thu, Jun 08, 2023, Yu Zhang wrote:
> Thanks again! One more thing that bothers me when reading the mmu notifier,
> is about the TLB flush request. After the APIC access page is reloaded, the
> TLB will be flushed (a single-context EPT invalidation on not-so-outdated
> CPUs) in vmx_set_apic_access_page_addr(). But the mmu notifier will send the
> KVM_REQ_TLB_FLUSH as well, by kvm_mmu_notifier_invalidate_range_start() ->
> __kvm_handle_hva_range(), therefore causing the vCPU to trigger another TLB
> flush - normally a global EPT invalidation I guess.

Yes.

> But, is this necessary?

Flushing when KVM zaps SPTEs is definitely necessary.  But the flush in
vmx_set_apic_access_page_addr() *should* be redundant.

> Could we try to return false in kvm_unmap_gfn_range() to indicate no more
> flush is needed, if the range to be unmapped falls within guest APIC base,
> and leaving the TLB invalidation work to vmx_set_apic_access_page_addr()?

No, because vmx_flush_tlb_current(), a.k.a. KVM_REQ_TLB_FLUSH_CURRENT, flushes
only the current root, i.e. on the current EP4TA.  kvm_unmap_gfn_range() isn't
tied to a single vCPU and so needs to flush all roots.  We could in theory more
precisely track which roots needs to be flushed, but in practice it's highly
unlikely to matter as there is typically only one "main" root when TDP (EPT) is
in use.  In other words, KVM could avoid unnecessarily flushing entries for other
roots, but it would incur non-trivial complexity, and the probability of the
precise flushing having a measurable impact on guest performance is quite low, at
least outside of nested scenarios.

But as above, flushing in vmx_set_apic_access_page_addr() shouldn't be necessary.
If there were SPTEs, then KVM would already have zapped and flushed.  If there
weren't SPTEs, then it should have been impossible for the guest to have valid
TLB entries.  KVM needs to flush when VIRTUALIZE_APIC_ACCESSES is toggled on, as
the CPU could have non-vAPIC TLB entries, but that's handled by vmx_set_virtual_apic_mode().

I'll send a follow-up patch to drop the flush from vmx_set_apic_access_page_addr(),
I don't *think* I'm missing an edge case...
