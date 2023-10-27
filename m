Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB297DA03A
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 20:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbjJ0SZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 14:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235229AbjJ0SX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 14:23:59 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7090C1FD3
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 11:23:13 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c9da175faaso20620385ad.1
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 11:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698430993; x=1699035793; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+S4AiipPfUUKpJ2ruaZ4ElxK7cYS7w8+XYANZ6GAwNM=;
        b=JPBSHdpXM2j676/0toy6g/49D7ujzaj/cc3K00wiLgiGOZfsFSI4RBIoKZTncF6O5T
         8SeBl0l0j5PgFbu84nWwCFaqp4pHsBEnf2JyTm0Z6yIidw1yzjx5WXISlPo2tDE/fYoj
         Rw1AzB3Nav2mc6DT5guttLvOcR1gSnKRIwB2W9JtY80vGehc6hhVgWXTnhT/BCxcKb3M
         zKuu2WgPeowQYtzdpvDcCqb6x5GwjXdBchRIPlsaDNdTyMN/3EtuE8eHCTZ1bi0Xtwsv
         xVoxNzHKSJF8B5AxEQpzAiGSmyawryouPerv6S4N6SfwSX1QsoCkJrGEy3u+fmbpmgbQ
         cwgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698430993; x=1699035793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+S4AiipPfUUKpJ2ruaZ4ElxK7cYS7w8+XYANZ6GAwNM=;
        b=t6Y/6UuNZ/WjnRd++Fu49g5jDtvf4JmODDFlh5kCqP/UrBqoPFZEUvKui3gFHZMEmp
         0/Wl8dpiZ3kmctcOwwZpsHOcAhI9a2WvI7rALG6f46QhNDbGIRTD5fOcs5iHkVJ6mM42
         eRvTjR/FE6TfbdEtP++wsPiQ0JywA7lqvVup1wANjmjzFC+QvHgegGqMVlyHIJBqfFhl
         2JlcH0tLr8zfTZSOicSPb0iPwAcb92hLeNteJrQLi7/TVvUxiFqqeMajIxvXVUHXHm5y
         a3pNsDNhDEGGULQaEUAFTnrbvD34JM5je0DJ3r8BHcDoyAPBoOxPueDUUCnXBmzSRG7/
         QvWQ==
X-Gm-Message-State: AOJu0Yx+1XmxP17PwtSqMI+Pf01/aKG8TIwxeLNMpDNx88bsV5icDB05
        HM915RXhZyGH4+Q/BcRodUwis4CgRng=
X-Google-Smtp-Source: AGHT+IEqIkKuv5DX25uHuP2fYVc0fUSbsifhQGdV1yLQ889bX1DKci/qdjsCIFlDcD5dVWlFtax8M8nrsME=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:4296:b0:1c9:e3ea:750d with SMTP id
 ju22-20020a170903429600b001c9e3ea750dmr58852plb.11.1698430993223; Fri, 27 Oct
 2023 11:23:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Oct 2023 11:22:06 -0700
In-Reply-To: <20231027182217.3615211-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027182217.3615211-25-seanjc@google.com>
Subject: [PATCH v13 24/35] KVM: selftests: Drop unused kvm_userspace_memory_region_find()
 helper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Anish Moorthy <amoorthy@google.com>,
        David Matlack <dmatlack@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop kvm_userspace_memory_region_find(), it's unused and a terrible API
(probably why it's unused).  If anything outside of kvm_util.c needs to
get at the memslot, userspace_mem_region_find() can be exposed to give
others full access to all memory region/slot information.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  4 ---
 tools/testing/selftests/kvm/lib/kvm_util.c    | 29 -------------------
 2 files changed, 33 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index a18db6a7b3cf..967eaaeacd75 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -776,10 +776,6 @@ vm_adjust_num_guest_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
 	return n;
 }
 
-struct kvm_userspace_memory_region *
-kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
-				 uint64_t end);
-
 #define sync_global_to_guest(vm, g) ({				\
 	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
 	memcpy(_p, &(g), sizeof(g));				\
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 7a8af1821f5d..f09295d56c23 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -590,35 +590,6 @@ userspace_mem_region_find(struct kvm_vm *vm, uint64_t start, uint64_t end)
 	return NULL;
 }
 
-/*
- * KVM Userspace Memory Region Find
- *
- * Input Args:
- *   vm - Virtual Machine
- *   start - Starting VM physical address
- *   end - Ending VM physical address, inclusive.
- *
- * Output Args: None
- *
- * Return:
- *   Pointer to overlapping region, NULL if no such region.
- *
- * Public interface to userspace_mem_region_find. Allows tests to look up
- * the memslot datastructure for a given range of guest physical memory.
- */
-struct kvm_userspace_memory_region *
-kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
-				 uint64_t end)
-{
-	struct userspace_mem_region *region;
-
-	region = userspace_mem_region_find(vm, start, end);
-	if (!region)
-		return NULL;
-
-	return &region->region;
-}
-
 __weak void vcpu_arch_free(struct kvm_vcpu *vcpu)
 {
 
-- 
2.42.0.820.g83a721a137-goog

