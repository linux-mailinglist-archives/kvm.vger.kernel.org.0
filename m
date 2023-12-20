Return-Path: <kvm+bounces-4896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B5B481973C
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 04:40:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58B8B2876C8
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 03:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC10EBE4E;
	Wed, 20 Dec 2023 03:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="FE/TZjwL"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDD58C02;
	Wed, 20 Dec 2023 03:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1703043626;
	bh=LxXYxW2bs3l7KuPRCYllTwAzb73+N1q9RxfmHtoBHi8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FE/TZjwLf/1r2JSv1gEW2d/POdIGdxzhk1uGywp5bjkqTpv30NZ+K00N6gdJdG0En
	 q8DsuG5vdXNAL9djC4dxY9AnufCRZA1JQWjT6Xf8uL3mI/jeutaUG8W36uwwoLQCeB
	 VKBgNwePzvh/R5FyCNTQr/kAfA2SBOybG3IkmMsmGlaCAoL9AZa8kNY4sJKgdw6ZrX
	 hpDpIWDsjypITPRvR4T+PSDsEyDLwsAblGWGrwl8sXkgZPNYDMWd4DrTqminTUnzpf
	 fVvNNICtZSYhmXQwX7GlvhclRWC1av5pHnyZN1iMNornDDHaYMTE4tw15A0o7LjS8u
	 tTBLRsM+JM5fg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Svzpx3Bt1z4wd4;
	Wed, 20 Dec 2023 14:40:25 +1100 (AEDT)
Date: Wed, 20 Dec 2023 14:40:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Huacai Chen
 <chenhuacai@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>, Jiaxun Yang
 <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH] LoongArch: KVM: Fix build due to API changes
Message-ID: <20231220144024.7d9fd46b@canb.auug.org.au>
In-Reply-To: <15ba5868-42de-4563-9903-ccd0297e2075@infradead.org>
References: <20231115090735.2404866-1-chenhuacai@loongson.cn>
	<15ba5868-42de-4563-9903-ccd0297e2075@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_//S5PCuZDLoPcwX41DFKdeRu";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_//S5PCuZDLoPcwX41DFKdeRu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 15 Dec 2023 21:08:06 -0800 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> Someone please merge this patch...

I have applied it to my merge of the kvm tree today and will keep
applying it until it is applied to the kvm tree ...

It looks like this:

From: Huacai Chen <chenhuacai@loongson.cn>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Xuerui Wang <kernel@xen0n.name>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH] LoongArch: KVM: Fix build due to API changes
Date: Wed, 15 Nov 2023 17:07:35 +0800

Commit 8569992d64b8f750e34b7858eac ("KVM: Use gfn instead of hva for
mmu_notifier_retry") replaces mmu_invalidate_retry_hva() usage with
mmu_invalidate_retry_gfn() for X86, LoongArch also need similar changes
to fix build.

Fixes: 8569992d64b8 ("KVM: Use gfn instead of hva for mmu_notifier_retry")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/loongarch/kvm/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 80480df5f550..9463ebecd39b 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -627,7 +627,7 @@ static bool fault_supports_huge_mapping(struct kvm_memo=
ry_slot *memslot,
  *
  * There are several ways to safely use this helper:
  *
- * - Check mmu_invalidate_retry_hva() after grabbing the mapping level, be=
fore
+ * - Check mmu_invalidate_retry_gfn() after grabbing the mapping level, be=
fore
  *   consuming it.  In this case, mmu_lock doesn't need to be held during =
the
  *   lookup, but it does need to be held while checking the MMU notifier.
  *
@@ -807,7 +807,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned=
 long gpa, bool write)
=20
 	/* Check if an invalidation has taken place since we got pfn */
 	spin_lock(&kvm->mmu_lock);
-	if (mmu_invalidate_retry_hva(kvm, mmu_seq, hva)) {
+	if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn)) {
 		/*
 		 * This can happen when mappings are changed asynchronously, but
 		 * also synchronously if a COW is triggered by
--=20
2.39.3

Though my Signed-off-by is not necessary if it applied to the kvm tree.

--=20
Cheers,
Stephen Rothwell

--Sig_//S5PCuZDLoPcwX41DFKdeRu
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmWCYigACgkQAVBC80lX
0Gw0hgf/dBEXxvqYb+gUvVeOe+ITNt6ui/uaSnXarJOtRq0NUOfL/gW/TGK5NoVO
r0MrXU6jAkr1K3+P0NvF/vJ52tlYaRjxNGNiB/cmLocgTLF8nCsjNSL6yTEraGqy
L9Lx2osHr8w1VoTL7k2b7Uoa46xk/YCE9ssMNcSJe4w5ONwzqfM/MVplCyV4pDdE
1fppL1Dt7uu5rozcoFPklB5e3kpt0/29/36QnI+fak1nXpSbhKwyxFpSzB8gDJBF
aZxgUh5me1CEsLsPP9rRKTaMFg2+KbSjQrmVIfY4cMiqzDBILIntW1sTMfxMP0+W
6prGmrL8hvSA3Z5m0RMSM6m6Jstnow==
=eOfT
-----END PGP SIGNATURE-----

--Sig_//S5PCuZDLoPcwX41DFKdeRu--

