Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B9155510F
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 18:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376657AbiFVQOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 12:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376691AbiFVQOi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 12:14:38 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAFE3FBC7;
        Wed, 22 Jun 2022 09:14:33 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z11so18446366edp.9;
        Wed, 22 Jun 2022 09:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9WjOZvdCTB7Ps/WBVZNvXm3V+edRGPvyOZ6QWomOwFM=;
        b=WfgOYbVJi99Uf4aae+TXkvpjNJKzqWVk0BQ1VERy+oH7Pfj9aCh1r4AWEJV7vAk9sF
         PrYGIBVOKz8sMGGphv4QbTK/ANi7pVovHNEd4YcI5/AVWSwI0baJR0HWqg1kZzSxVZec
         0vxz0jmTXMPInL1/zUGD3zx4hmsXyJY7E+rOQDGUs9omkZU95aiiVdzj6X5ZkysLbnHR
         il5bgk6NWjDE1RparFoBw/vNNc0CaKzEx4lTrMmHwuDH69KOXWVm/Q9pKTWztHlSRQsg
         53MqsWzDsyqFXL99zpjSGKLx1TNY9swWSyXNdHZ3N7oKZKE4pFxLNS68Z0XW2F7geALv
         y0rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9WjOZvdCTB7Ps/WBVZNvXm3V+edRGPvyOZ6QWomOwFM=;
        b=39ra8fyOPudk3iWOTiRKNh/91fu/2IBN1NAnDVyHgx2Jvu4VTlW1TewEvzjzrYQyQD
         OHRUpvYCF3oZXkDTN0s/3VOT6UUsqC/PufT8pKU9oIHqtCza4Jgu1UY/YCcUxHR0qH/P
         8lO8SNwb5RhentbNNl/1OwipaOn6Xq/DNt1G2YERwGMyXZz/4agI/Hsf+XyWm88HMSji
         EfqWef9LyITx+JXQT7YvEhS5BJgk6LA3kHUKTp+bLRMYvfBi0jly2s76sX0D5W50ZHPr
         reyphGZulDZAFpt0XYiVoUoYaksyHhnCI5xxfR53GIZxF9LT2TV1tFlf3KiDSyNbHeQc
         lUfQ==
X-Gm-Message-State: AJIora9w7zyaV9LgFwAaJeA/0NE5y6Mhoi1iOiCzkOIut+badhd8LJzy
        vG4lOAOtgQILU4S7mw1juh4=
X-Google-Smtp-Source: AGRyM1sSylH7Bm+JBs0J+E6rc85AJHG7sjGCqKKXg6ib01R2aWpzXEOJ/VscmDq2T5u7SQzG9Q/ALQ==
X-Received: by 2002:a05:6402:430f:b0:42e:2a86:abaf with SMTP id m15-20020a056402430f00b0042e2a86abafmr5027442edc.194.1655914471604;
        Wed, 22 Jun 2022 09:14:31 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id kx8-20020a170907774800b006ff802baf5dsm9520007ejc.54.2022.06.22.09.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 09:14:31 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <4665c87b-4983-7e15-9262-290d2969b10f@redhat.com>
Date:   Wed, 22 Jun 2022 18:13:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 20/22] KVM: x86/mmu: Refactor drop_large_spte()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-21-dmatlack@google.com> <Yqy1v59ZDJ7EkCix@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yqy1v59ZDJ7EkCix@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/17/22 19:11, Sean Christopherson wrote:
> since the shortlog is already
> a somewhat vague "do a refactor", I vote to opportunistically:
> 
>    - rename drop_large_spte() to drop_spte_if_huge()
>    - rename __drop_large_spte() to drop_huge_spte()
>    - move "if (!is_large_pte(*sptep))" to drop_spte_if_huge() since the split path
>      should never pass in a non-huge SPTE.
> 
> That last point will also clean up an oddity with with "flush" parameter; given
> the command-like name of "flush", it's a bit weird that __drop_large_spte() doesn't
> flush when the SPTE is large.

Even better, drop_large_spte() is always called right before 
kvm_mmu_get_child_sp(), so:

 From 86a9490972a1e959a4df114678719494b5475720 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 22 Jun 2022 12:11:44 -0400
Subject: [PATCH] KVM: MMU: pull drop_large_spte into kvm_mmu_get_child_sp

Before allocating a child shadow page table, all callers need to
check whether the parent already points to a huge page and, if so,
drop it.  This is done by drop_large_spte(), but it can be moved
to kvm_mmu_get_child_sp().

To ensure that the shadow page is not linked twice if it was
present, do _not_ opportunistically make kvm_mmu_get_child_sp()
idempotent: instead, return an error value if the shadow page
already existed.  This is a bit more verbose, but clearer than
NULL.

Now that the drop_large_spte() name is not taken anymore,
remove the two underscores in front of __drop_large_spte().

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 36bc49f08d60..7f52870ee062 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1135,26 +1135,16 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
  		rmap_remove(kvm, sptep);
  }

-
-static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
+static void drop_large_spte(struct kvm *kvm, u64 *sptep)
  {
-	if (is_large_pte(*sptep)) {
-		WARN_ON(sptep_to_sp(sptep)->role.level == PG_LEVEL_4K);
-		drop_spte(kvm, sptep);
-		return true;
-	}
-
-	return false;
-}
+	struct kvm_mmu_page *sp;

-static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
-{
-	if (__drop_large_spte(vcpu->kvm, sptep)) {
-		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
+	sp = sptep_to_sp(sptep);
+	WARN_ON(sp->role.level == PG_LEVEL_4K);

-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
+	drop_spte(kvm, sptep);
+	kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
  			KVM_PAGES_PER_HPAGE(sp->role.level));
-	}
  }

  /*
@@ -2221,6 +2211,13 @@ static struct kvm_mmu_page 
*kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
  {
  	union kvm_mmu_page_role role;

+	if (is_shadow_present_pte(*sptep)) {
+		if (!is_large_pte(*sptep))
+			return ERR_PTR(-EEXIST);
+
+		drop_large_spte(vcpu->kvm, sptep, true);
+	}
+
  	role = kvm_mmu_child_role(sptep, direct, access);
  	return kvm_mmu_get_shadow_page(vcpu, gfn, role);
  }
@@ -3080,11 +3077,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, 
struct kvm_page_fault *fault)
  		if (it.level == fault->goal_level)
  			break;

-		drop_large_spte(vcpu, it.sptep);
-		if (is_shadow_present_pte(*it.sptep))
-			continue;
-
  		sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn, true, ACC_ALL);
+		if (sp == ERR_PTR(-EEXIST))
+			continue;

  		link_shadow_page(vcpu, it.sptep, sp);
  		if (fault->is_tdp && fault->huge_page_disallowed &&
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 24f292f3f93f..2448fa8d8438 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -648,15 +648,13 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, 
struct kvm_page_fault *fault,
  		gfn_t table_gfn;

  		clear_sp_write_flooding_count(it.sptep);
-		drop_large_spte(vcpu, it.sptep);

-		sp = NULL;
-		if (!is_shadow_present_pte(*it.sptep)) {
-			table_gfn = gw->table_gfn[it.level - 2];
-			access = gw->pt_access[it.level - 2];
-			sp = kvm_mmu_get_child_sp(vcpu, it.sptep, table_gfn,
-						  false, access);
+		table_gfn = gw->table_gfn[it.level - 2];
+		access = gw->pt_access[it.level - 2];
+		sp = kvm_mmu_get_child_sp(vcpu, it.sptep, table_gfn,
+					  false, access);

+		if (sp != ERR_PTR(-EEXIST)) {
  			/*
  			 * We must synchronize the pagetable before linking it
  			 * because the guest doesn't need to flush tlb when
@@ -685,7 +683,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, 
struct kvm_page_fault *fault,
  		if (FNAME(gpte_changed)(vcpu, gw, it.level - 1))
  			goto out_gpte_changed;

-		if (sp)
+		if (sp != ERR_PTR(-EEXIST))
  			link_shadow_page(vcpu, it.sptep, sp);
  	}

@@ -709,16 +707,15 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, 
struct kvm_page_fault *fault,

  		validate_direct_spte(vcpu, it.sptep, direct_access);

-		drop_large_spte(vcpu, it.sptep);
+		sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn,
+					  true, direct_access);
+		if (sp == ERR_PTR(-EEXIST))
+			continue;

-		if (!is_shadow_present_pte(*it.sptep)) {
-			sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn,
-						  true, direct_access);
-			link_shadow_page(vcpu, it.sptep, sp);
-			if (fault->huge_page_disallowed &&
-			    fault->req_level >= it.level)
-				account_huge_nx_page(vcpu->kvm, sp);
-		}
+		link_shadow_page(vcpu, it.sptep, sp);
+		if (fault->huge_page_disallowed &&
+		    fault->req_level >= it.level)
+			account_huge_nx_page(vcpu->kvm, sp);
  	}

  	if (WARN_ON_ONCE(it.level != fault->goal_level))

with the obvious patch on top to add the flush argument.

The ERR_PTR(-EEXIST) is a bit heavy, but at least conveys what's going 
on.  Thoughts?

Paolo
