Return-Path: <kvm+bounces-27774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D8CF98BF9F
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 16:19:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D84D0B277F9
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 14:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 688801CCEDE;
	Tue,  1 Oct 2024 14:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="QfqRlEnW"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0A61CC142;
	Tue,  1 Oct 2024 14:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727792055; cv=none; b=CLMNpkBCQl/nn/JtXYlmuE/uBDbMsiorYux37SdFmDghQDpleesowR69JcQo+aodOk0fqB3d3lnZHI/pO8AxtcHpZ8fcGHAEm7RhML764WredcGCxj026gyR1qcO8nhblIfV7alfEuEgavi0WqIjdz5jObpPPvxytIa3gKk9u0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727792055; c=relaxed/simple;
	bh=YbjfKVV+PSurqasVb8gEbrno0Fp8oYuYfix+ReWUNpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RI/QzPaZmRxxo6xPvSM4eQ/hKGJg0YRheQPHvd+cN1jWfNI9nS5SXBHNeFd61ZCPYS2txqcsRlugNCTKUdi0zZ83Ch2otJk9m7sm0NPdqDVLvCtTjKRKxPl/K3LQq0j1vY5yph9oXnCFshTsJJul/NNL22sJ41HX4axfiM3ogDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=QfqRlEnW; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=vJPSzWcP9fffvDrMtX3+mga6V5a7bKdym5iTXqJycDc=; b=QfqRlEnWpPZ4ToZR
	qGHzzZ4sjH1mfgR3K2ALFdNYxk1ZNWkjvYdmVccVaoeEUb8S+e49mCU9eMixCLJ6ictH6BLNhRsem
	y2Tsdq4tzEMwlslsR3WeiaUE7gME8p5v9UPPsmEUQktKv6nZneeugnzXqxkOeWWs1WY2TITlRytbI
	oS4iETlz3w37ebHhwwes0xj+BmQNNG6U3wvJCGNdO56w0giEfFvalMkMKakrMKhyrgtszyOD8qIKV
	cP3+M0X3MZXTPO8Z0CB1a+Ad9dWIbuTHuKghJZEzIYAHqoDQ/Vz1AenvS5crK0VwXTcQnGGlrCXsG
	FP7oong87reb3Aqw9w==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1svdda-008FA4-16;
	Tue, 01 Oct 2024 14:14:02 +0000
From: linux@treblig.org
To: pbonzini@redhat.com
Cc: seanjc@google.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 1/2] KVM: Remove unused kvm_vcpu_gfn_to_pfn
Date: Tue,  1 Oct 2024 15:13:53 +0100
Message-ID: <20241001141354.18009-2-linux@treblig.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001141354.18009-1-linux@treblig.org>
References: <20241001141354.18009-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

The last use of kvm_vcpu_gfn_to_pfn was removed by commit
b1624f99aa8f ("KVM: Remove kvm_vcpu_gfn_to_page() and kvm_vcpu_gpa_to_page()")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 include/linux/kvm_host.h | 1 -
 virt/kvm/kvm_main.c      | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index db567d26f7b9..b9b2e42e3fa7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1314,7 +1314,6 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn);
-kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map);
 void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty);
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 05cbb2548d99..f82131e7978b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3047,12 +3047,6 @@ kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn);
 
-kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn)
-{
-	return gfn_to_pfn_memslot(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn);
-}
-EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn);
-
 int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
 			    struct page **pages, int nr_pages)
 {
-- 
2.46.2


