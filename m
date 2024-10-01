Return-Path: <kvm+bounces-27775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2D3A98BFA0
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 16:19:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EA461C23F47
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 14:19:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A8DC1CCEE5;
	Tue,  1 Oct 2024 14:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="DnLsGguM"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099161CC15B;
	Tue,  1 Oct 2024 14:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727792055; cv=none; b=VAeIBmkU5ytLBoZrorlWxe7LP75J9M2+iC7xANQw5XXnQdOXtg8Bv1whFDQZhrJktfNTRaK0XRjNKsNfe7S2vCkW9I/SaX5qInKloAjEZTKXXfrYl2YCCA8AYtscTfhavZDGLxDK0YPw0wKh0id4AZKVLlqMvAsUs5EX8Seqz3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727792055; c=relaxed/simple;
	bh=r1+h9F+0nljOqtAM17gvDCWiuo0mM2xCuiBLzFztBfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyOjzerXJTHa3/BisksKq9/cLtuvB0md7OblJtE4dDPvoRNng+1e/9aDtmlzMKoNDtf2EuBJkxxF/3vM/qtUn0VhAA3dMYSsCQsTuwAhdAFkcuBkn6689tF1p5ccupRpxd4+p3U1NGnAybxIkrbU3kGyTKsgkI1UG7VjxPWutWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=DnLsGguM; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=lQUontFP3CUZ8cF4WWET7oGIXBLufTRmifkMvmYnvv4=; b=DnLsGguMemVQ06FR
	6ArdnvTGlELGdvnbQ/vw+RT2BCZw7s+8Aq2Zpxwv/+Ky99yyvsRKQqlX76eIjPF0PfDsT11TzObiQ
	RgjMwKEHf1xiVwrtZlbDhWJe/qhj57i8vZvrVMjAxZcGEeVEGq6wY81HPKusTGp4cuYXfLRUIMk0y
	mEsE9NQpL50odUZ4LkRdQJ9dRxb//y8dhrI5PYUksqnCpc0/SZL7B2V1JllECQN6mJXAAKGo0NCPu
	OIjVfldpX/zgnl58VooDzYJTNgmiVVCwglu/brepiFub0BtD4KyMK2GenNVRdAkooxilZQT++JrGa
	qkSh/2jAsCgwv1mxKQ==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1svdda-008FA4-3D;
	Tue, 01 Oct 2024 14:14:03 +0000
From: linux@treblig.org
To: pbonzini@redhat.com
Cc: seanjc@google.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 2/2] KVM: Remove unused kvm_vcpu_gfn_to_pfn_atomic
Date: Tue,  1 Oct 2024 15:13:54 +0100
Message-ID: <20241001141354.18009-3-linux@treblig.org>
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

The last use of kvm_vcpu_gfn_to_pfn_atomic was removed by commit
1bbc60d0c7e5 ("KVM: x86/mmu: Remove MMU auditing")

Remove it.

Note, I've not removed the example in,
  Documentation/virt/kvm/locking.rst
which I guess needs reworking; or maybe it's a reason to hold onto
this.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 include/linux/kvm_host.h | 1 -
 virt/kvm/kvm_main.c      | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b9b2e42e3fa7..45be36e5285f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1313,7 +1313,6 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn);
-kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn);
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map);
 void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty);
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f82131e7978b..141db5b79cd4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3035,12 +3035,6 @@ kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gf
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
 
-kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn)
-{
-	return gfn_to_pfn_memslot_atomic(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn);
-}
-EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn_atomic);
-
 kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 {
 	return gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn);
-- 
2.46.2


