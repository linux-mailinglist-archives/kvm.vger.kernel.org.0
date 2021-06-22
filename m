Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6513D3B0BFE
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 19:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbhFVSAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbhFVSAc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:00:32 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A753FC0617AF
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:14 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id ez18-20020ad459120000b029020e62abfcbdso10062060qvb.16
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1cuJlej5QtQVUgXaKXLCLupE2h8bZDvIvc+XU0Qy11c=;
        b=FO/N2ZK8XxpG8TPbM5BAoGiA8fcp0UzdbCojc3o0jFF0opgx7osqSDUuL8TqSRyToR
         8Ii6cA+AWkjOR2SaGHv6qtWsiMp+4ypf0+uLoCdajMO7S+hnWs73H9+Kq7VLUOLue2OW
         cfDYenHu2qGY/Y5HsqFET/TTfrZHvTdsdBR5+ImhvxxEbzPEuXfeVY+agKdsxXyhrjCz
         1Rb8dfXUM6auBfI/s/0BDyVaxlcgZr2AurtTVN3YehlxkF4rKBp5GjIhRseu9PMQf5DS
         0NSVDRYKCYYwXqhh6DiA4kwHhxa13AvIp3xd/atAfqBRNMcWUhwuoVnLFEfoygkhJ3p5
         FZ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1cuJlej5QtQVUgXaKXLCLupE2h8bZDvIvc+XU0Qy11c=;
        b=t0X/Xu/NOBoIVmIrnQLVVokyd3DKiikPj4nnyI3shU/LAiKaCkxtlW/7qDiGaJ4S+f
         FHeuG/tjDsGzvUZIA74fx6sNkqgbNNPLSCvJa1MVfEsrhtEvp3WXWw4RvKA+ERcS4QU4
         y9+Yh3CT0wgmLV1ta8+7qdOqvkIPCbi4XuCDvSVePAmzPSxkB+XM+I8lloJ1YFz4La9y
         gwzd491THJ68gS6mNVNSZoI/11sAxEjhF+lNgcagUaBXk9IZYg6v4mD93I6ilhESnECd
         BPnyVptcju2XOFfCbtoX7JiZV1Yw0jrnnzdvYUQwejXSmbiRTh1sVzjCS8N8NzR/ST1w
         w9eA==
X-Gm-Message-State: AOAM530RjN5d7tnIooBulp0bt1uK+VxgWw0KYXkWq8lerS/MjRkVMSdj
        byjI4nP6lphwgvZVE2R2afphOtWf0MA=
X-Google-Smtp-Source: ABdhPJyRTYcjOOe7Hpuegj9TYeKT7xA8Phn/GsRgC9q+yKHQzi56T+2XNNurVkrdjS8MimO54PakvpGyePc=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a05:6214:10e9:: with SMTP id
 q9mr27020191qvt.45.1624384693773; Tue, 22 Jun 2021 10:58:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:56:53 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 08/54] Revert "KVM: MMU: record maximum physical address width
 in kvm_mmu_extended_role"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop MAXPHYADDR from mmu_role now that all MMUs have their role
invalidated after a CPUID update.  Invalidating the role forces all MMUs
to re-evaluate the guest's MAXPHYADDR, and the guest's MAXPHYADDR can
only be changed only through a CPUID update.

This reverts commit de3ccd26fafc707b09792d9b633c8b5b48865315.

Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/mmu/mmu.c          | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 19c88b445ee0..cdaff399ed94 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -321,7 +321,6 @@ union kvm_mmu_extended_role {
 		unsigned int cr4_smap:1;
 		unsigned int cr4_smep:1;
 		unsigned int cr4_la57:1;
-		unsigned int maxphyaddr:6;
 	};
 };
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8d97d21d5241..04cab330c445 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4538,7 +4538,6 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu)
 	ext.cr4_pse = !!is_pse(vcpu);
 	ext.cr4_pke = !!kvm_read_cr4_bits(vcpu, X86_CR4_PKE);
 	ext.cr4_la57 = !!kvm_read_cr4_bits(vcpu, X86_CR4_LA57);
-	ext.maxphyaddr = cpuid_maxphyaddr(vcpu);
 
 	ext.valid = 1;
 
-- 
2.32.0.288.g62a8d224e6-goog

