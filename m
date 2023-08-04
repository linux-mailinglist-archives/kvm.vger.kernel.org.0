Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D219976F696
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 02:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbjHDAlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 20:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbjHDAla (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 20:41:30 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1994A469F
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 17:41:17 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bbb34b091dso11055175ad.0
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 17:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691109676; x=1691714476;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T8aNKw/UNLB3LBKBzpaH6yDKHK0q+kXasr0Syu6S3ng=;
        b=IGVVR7zM3y9+tESfP6t1H4ZALLY2Wtbifu0cxbQ9+0uvIo75P26BdxrmD4eav6le4X
         q/ZltMU4nAe3ANaieqIZw1YtB7mE2gpW7pvEMK08+cnXLEAPUyF2a1MXZ4YfvYaSL7FE
         UnFMcBOt2Zm1kDNOjOcVF8K8kokwquIhOeF11je+DTr9Z4gg9Rvc82+k60GE4tVgYqq/
         vsqHfUmWoBY2UoQy7/JcVfLgywNJQSnBKbFSMhr6Smi/M22QiiXXqk0eJAQb2i1tVWCU
         ktjqBHAQwRft7gejjJyWVvUkMxRUtsrPw+eGKhtxRtXoc/RdW5JrSvnbAJwvw2YtjtQi
         6qwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691109676; x=1691714476;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T8aNKw/UNLB3LBKBzpaH6yDKHK0q+kXasr0Syu6S3ng=;
        b=f776PYVCi+OmqlCT1N00Aj9wrN99F8o0D20sPRv770wwKO2TdmrXAhnlSh0QDq/U0e
         /8GNRkxF3Fp6vZSGpkxiRLz4+Or08kmfovZBjgyXBtJ1y0ItLkoZ8r6YnRtCa+HN8Att
         3+bx4IdRvQaB3Ouu4Izyv9YjE/sy6nCEIGvtMlVAwsAdOudRw66GSma5jT1KV7o4LWyC
         /oRsEPPDa3DLFQz5e6/EL0kA4ywc8XQ8i0yIOarj/N4wMmiW/46AQiy4fMzRZOt5c/n/
         DdIbVXLyiniqkHQonNx6A4PLSOy3E7dcYrZ5lSCO8/NwXKjaVlyYXiJfYOE8sfe6Zpwq
         +tNw==
X-Gm-Message-State: AOJu0YyEEJCWu9oukPPn0svV7RMpIl8s2FFE++PS7IL5ZQwq3E/jQhKC
        ODVtKy7g6ddZMLN8Gdx0T4u7GLlZPoE=
X-Google-Smtp-Source: AGHT+IEqBfe04122ag2NobvUCc8mVVf0xkxkZ0jhisXAShKpfS6UuhPC3LJ34C0F2pC6c5uEFDRu2XsSKxg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c40b:b0:1bc:2547:b184 with SMTP id
 k11-20020a170902c40b00b001bc2547b184mr1208plk.1.1691109676363; Thu, 03 Aug
 2023 17:41:16 -0700 (PDT)
Date:   Thu,  3 Aug 2023 17:41:06 -0700
In-Reply-To: <20230729013535.1070024-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729013535.1070024-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <169110211029.1965858.14581735700060429373.b4-ty@google.com>
Subject: Re: [PATCH v4 00/29] drm/i915/gvt: KVM: KVMGT fixes and page-track cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 28 Jul 2023 18:35:06 -0700, Sean Christopherson wrote:
> Fix a handful of minor bugs in KVMGT, and overhaul KVM's page-track APIs
> to provide a leaner and cleaner interface.  The motivation for this
> series is to (significantly) reduce the number of KVM APIs that KVMGT
> uses, with a long-term goal of making all kvm_host.h headers KVM-internal.
> 
> If there are no objections or issues, my plan is to take this through the
> KVM tree for 6.6 (I had it ready early last week, and then forgot to actually
> post v4, /facepalm).
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[01/29] drm/i915/gvt: Verify pfn is "valid" before dereferencing "struct page"
        https://github.com/kvm-x86/linux/commit/865327865164
[02/29] drm/i915/gvt: remove interface intel_gvt_is_valid_gfn
        https://github.com/kvm-x86/linux/commit/823ab2ea8429
[03/29] drm/i915/gvt: Verify hugepages are contiguous in physical address space
        https://github.com/kvm-x86/linux/commit/e27395fb1b87
[04/29] drm/i915/gvt: Don't try to unpin an empty page range
        https://github.com/kvm-x86/linux/commit/6a718c54c2ee
[05/29] drm/i915/gvt: Put the page reference obtained by KVM's gfn_to_pfn()
        https://github.com/kvm-x86/linux/commit/f969ecabe30b
[06/29] drm/i915/gvt: Explicitly check that vGPU is attached before shadowing
        https://github.com/kvm-x86/linux/commit/537eef32e720
[07/29] drm/i915/gvt: Error out on an attempt to shadowing an unknown GTT entry type
        https://github.com/kvm-x86/linux/commit/c94811471997
[08/29] drm/i915/gvt: Don't rely on KVM's gfn_to_pfn() to query possible 2M GTT
        https://github.com/kvm-x86/linux/commit/f018c319cc2f
[09/29] drm/i915/gvt: Use an "unsigned long" to iterate over memslot gfns
        https://github.com/kvm-x86/linux/commit/4879a4370304
[10/29] drm/i915/gvt: Drop unused helper intel_vgpu_reset_gtt()
        https://github.com/kvm-x86/linux/commit/ac5e77621712
[11/29] drm/i915/gvt: Protect gfn hash table with vgpu_lock
        https://github.com/kvm-x86/linux/commit/49a83e190b5b
[12/29] KVM: x86/mmu: Move kvm_arch_flush_shadow_{all,memslot}() to mmu.c
        https://github.com/kvm-x86/linux/commit/2f502998b046
[13/29] KVM: x86/mmu: Don't rely on page-track mechanism to flush on memslot change
        https://github.com/kvm-x86/linux/commit/e2fe84fb5eae
[14/29] KVM: x86/mmu: Don't bounce through page-track mechanism for guest PTEs
        https://github.com/kvm-x86/linux/commit/f1c58cdb8e04
[15/29] KVM: drm/i915/gvt: Drop @vcpu from KVM's ->track_write() hook
        https://github.com/kvm-x86/linux/commit/3f8eb1d7d3ee
[16/29] KVM: x86: Reject memslot MOVE operations if KVMGT is attached
        https://github.com/kvm-x86/linux/commit/aa611a99adb4
[17/29] drm/i915/gvt: Don't bother removing write-protection on to-be-deleted slot
        https://github.com/kvm-x86/linux/commit/a41e34b05da7
[18/29] KVM: x86: Add a new page-track hook to handle memslot deletion
        https://github.com/kvm-x86/linux/commit/cc49e12d8d3b
[19/29] drm/i915/gvt: switch from ->track_flush_slot() to ->track_remove_region()
        https://github.com/kvm-x86/linux/commit/b9ae8a09f357
[20/29] KVM: x86: Remove the unused page-track hook track_flush_slot()
        https://github.com/kvm-x86/linux/commit/1265fb534fa1
[21/29] KVM: x86/mmu: Move KVM-only page-track declarations to internal header
        https://github.com/kvm-x86/linux/commit/c87966b313cc
[22/29] KVM: x86/mmu: Use page-track notifiers iff there are external users
        https://github.com/kvm-x86/linux/commit/b5e33f265acd
[23/29] KVM: x86/mmu: Drop infrastructure for multiple page-track modes
        https://github.com/kvm-x86/linux/commit/2431c9ab231a
[24/29] KVM: x86/mmu: Rename page-track APIs to reflect the new reality
        https://github.com/kvm-x86/linux/commit/4b42f39917c1
[25/29] KVM: x86/mmu: Assert that correct locks are held for page write-tracking
        https://github.com/kvm-x86/linux/commit/21e0e1efd880
[26/29] KVM: x86/mmu: Bug the VM if write-tracking is used but not enabled
        https://github.com/kvm-x86/linux/commit/6d6ff9e6db15
[27/29] KVM: x86/mmu: Drop @slot param from exported/external page-track APIs
        https://github.com/kvm-x86/linux/commit/ca181aa50724
[28/29] KVM: x86/mmu: Handle KVM bookkeeping in page-track APIs, not callers
        https://github.com/kvm-x86/linux/commit/eae2d71635a1
[29/29] drm/i915/gvt: Drop final dependencies on KVM internal details
        https://github.com/kvm-x86/linux/commit/2d28b1230c1c

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
