Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 148529996F
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 18:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390146AbfHVQkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 12:40:41 -0400
Received: from mout.web.de ([212.227.15.4]:40865 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733046AbfHVQkj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 12:40:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1566492032;
        bh=m5Jw6rwKzXsB4kkDsNZcCpmkYQpZwvyqQ7u2l1d2Tgg=;
        h=X-UI-Sender-Class:Resent-From:Resent-Date:Resent-To:From:Date:To:
         Cc:Subject;
        b=TtICLJEjHZedCbNjN8EEfhxehgB2llsmkeYMNZK4QuTrsKlZjGehxc33xDEkfkVVZ
         K/94SF2rr2vkF/s076TwjuR6X9TOHkk1UdkCCg2Tgw9kvcyrQ03ED5P/pOp3HVuCGy
         ch8HI5NnH1gwRp/SAeBVXqy0XYJqh1IDmesoHus4=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from debian ([85.71.157.74]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0M3Bv5-1iGr1L2SYh-00svlh; Thu, 22
 Aug 2019 18:40:32 +0200
Message-Id: <87lfvl5f28.fsf@debian>
From:   =?iso8859-2?q?Ji=F8=ED=20Pale=E8ek?= <jpalecek@web.de>
Date:   Sat, 22 Jun 2019 19:42:04 +0200
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-type: text/plain; charset=iso-8859-2
Subject: [PATCH] kvm: Nested KVM MMUs need PAE root too
X-RMAIL-ATTRIBUTES: --E-----
X-Provags-ID: V03:K1:PkHIcnd2bnprl9kM/lwr5agQlKeVGdSnrszNOPC0RylERjRxlnI
 +Ab21HCatTXxNWC0d+DEjWAvFyNElKsb9byXrzu2bR1tIQ1NQjOJs2rTpFOzw9Vu7n4yQIV
 0YAUOhDVl3yLla1iRh9bC8mm0CwEETmCSZGcNAKBsT0KFEb+xTjheJ3UUFSRbazaQ0QoJ8/
 Uc+v7+qxE7Yr4MX2nFcFA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:cM0ZNgKhMj4=:FjYgCwhlJPxpGCKf256gVT
 qhp2YWJ760ddPetAQhx+e05cIDAVSxJwiGtw05Shy5DTAJ0inkLRLEC/6mNVeuVeDg0Jmj0aU
 YfFZnqRgPdCsfxck9qnyuqEOP3+4OchuxwVZ0iXBuy6gClXbn0QRMGhrz5HXp3ckbPXP4ujSl
 /BmS+Fx53wUiQEgTuyLvGsaA5/AHuAZHtja9VnDtopDolfDWI31m3OlsDu0Qjs48ytNT/Sbf3
 BECC4mU3c8YaueWFQl/lf5zkN1cexOPbdMxiV+v0EUi5pEKfejMWadgeYKqvb/zKVMZuTpB7S
 CMd383ZIai8dL3F9V5QzzE863vTB/RJTlg4NaYJQeNdUuqD1VopziHvcpCwe/p5/x4csrmj78
 7X0J0NZqC8rWiJFc1W+X7kCRWm0GSLt0mVvz/tf3F/CJUjGTXAW/66ofDUMLzY93uZmvMjPXn
 Yq9/glhnxYpPgGtKa1gGteQPl47UQuZQMn6ccyVSIbj29SzxVtSexD4vg1JAhPQMoLh9sMJ5y
 5Nkn4JtpDpN4Z5AaMiCTY5h0HjBw7LCTVz3e28A2qPuMXPiYYG558OLK7h6GufVOCSZIJH2vI
 i7FwtnNUtjcLQn1KMHBdeunGKU83iO4FA/bXl/ZhEwDUw1+byvzP6F8iSMtYFwnF+Oz4jjufb
 15PI9eV2yuHNEzBDMSqdkr5L0vP81laVKTP7hsHBLNgP0Oswwga2E3/0fNjlKky2dVcUwa2h8
 Kw9WUBXzXWIO8GH8Y+G6PrSMUdoF1L2T+b0Ai578lLgGa5btXkmnbTuDSiOOlHealEefBbBqV
 9CPMPusRzZV3fdiKBDgOVIph8V2ftvxX8IiyQM6nMRu33BQGQIwK2cC5iKt8hmnFVWi23gwQF
 bqtOgwT4V8rqG9EJ4UuEs2kRt0JPlA68+/Lpo6i5gYXK3AwKgxZ+zvBPFRZ8TiJlR9j3yezHf
 CsYss7StsAqra/7x5ZoGl2Ful6uwbT3cWPIcEQGeYW+jO56YFtmxVrn2R0MZZ+fKw3d45AHYO
 sO5SdiMhk4+/uZ3Guvw83Ue7eCY8uitrZa5ZCyoUKU1M4zkgqVB1BJ2Lnb15/l69H0VJ5SKbN
 3JWmeDy0advrZaWPZtFTbJa21ZwQU3fVIj8ijhhS/Hp+Sr5yINmgP54GPyakxdaHSDehCBvGZ
 u8Shg=
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On AMD processors, in PAE 32bit mode, nested KVM instances don't
work. The L0 host get a kernel OOPS, which is related to
arch.mmu->pae_root being NULL.

The reason for this is that when setting up nested KVM instance,
arch.mmu is set to &arch.guest_mmu (while normally, it would be
&arch.root_mmu). However, the initialization and allocation of
pae_root only creates it in root_mmu. KVM code (ie. in
mmu_alloc_shadow_roots) then accesses arch.mmu->pae_root, which is the
unallocated arch.guest_mmu->pae_root.

This fix just allocates (and frees) pae_root in both guest_mmu and
root_mmu (and also lm_root if it was allocated). The allocation is
subject to previous restrictions ie. it won't allocate anything on
64-bit and AFAIK not on Intel.

See bug 203923 for details.

Signed-off-by: Jiri Palecek <jpalecek@web.de>
Tested-by: Jiri Palecek <jpalecek@web.de>

=2D--
 arch/x86/kvm/mmu.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 24843cf49579..efa8285bb56d 100644
=2D-- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5592,13 +5592,13 @@ slot_handle_leaf(struct kvm *kvm, struct kvm_memor=
y_slot *memslot,
 				 PT_PAGE_TABLE_LEVEL, lock_flush_tlb);
 }

-static void free_mmu_pages(struct kvm_vcpu *vcpu)
+static void free_mmu_pages(struct kvm_mmu *mmu)
 {
-	free_page((unsigned long)vcpu->arch.mmu->pae_root);
-	free_page((unsigned long)vcpu->arch.mmu->lm_root);
+	free_page((unsigned long)mmu->pae_root);
+	free_page((unsigned long)mmu->lm_root);
 }

-static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
+static int alloc_mmu_pages(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 {
 	struct page *page;
 	int i;
@@ -5619,9 +5619,9 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
 	if (!page)
 		return -ENOMEM;

-	vcpu->arch.mmu->pae_root =3D page_address(page);
+	mmu->pae_root =3D page_address(page);
 	for (i =3D 0; i < 4; ++i)
-		vcpu->arch.mmu->pae_root[i] =3D INVALID_PAGE;
+		mmu->pae_root[i] =3D INVALID_PAGE;

 	return 0;
 }
@@ -5629,6 +5629,7 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
 int kvm_mmu_create(struct kvm_vcpu *vcpu)
 {
 	uint i;
+	int ret;

 	vcpu->arch.mmu =3D &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu =3D &vcpu->arch.root_mmu;
@@ -5646,7 +5647,19 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 		vcpu->arch.guest_mmu.prev_roots[i] =3D KVM_MMU_ROOT_INFO_INVALID;

 	vcpu->arch.nested_mmu.translate_gpa =3D translate_nested_gpa;
-	return alloc_mmu_pages(vcpu);
+
+	ret =3D alloc_mmu_pages(vcpu, &vcpu->arch.guest_mmu);
+	if (ret)
+		return ret;
+
+	ret =3D alloc_mmu_pages(vcpu, &vcpu->arch.root_mmu);
+	if (ret)
+		goto fail_allocate_root;
+
+	return ret;
+ fail_allocate_root:
+	free_mmu_pages(&vcpu->arch.guest_mmu);
+	return ret;
 }

 static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
@@ -6102,7 +6115,8 @@ unsigned long kvm_mmu_calculate_default_mmu_pages(st=
ruct kvm *kvm)
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
-	free_mmu_pages(vcpu);
+	free_mmu_pages(&vcpu->arch.root_mmu);
+	free_mmu_pages(&vcpu->arch.guest_mmu);
 	mmu_free_memory_caches(vcpu);
 }

=2D-
2.23.0.rc1

