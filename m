Return-Path: <kvm+bounces-61589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 41DB6C22582
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 21:51:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 854DC34EBCA
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B688335076;
	Thu, 30 Oct 2025 20:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="p4kS23KL"
X-Original-To: kvm@vger.kernel.org
Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C35329E7E;
	Thu, 30 Oct 2025 20:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761857469; cv=none; b=rScoKYeejiCctuob/NxMQWI2oVXK78me1n93fQJKRkHDxn8q1XZtmsH+aytnz1AnOVS9uY2Qcemqcpz5S+TsbfhRdZTPaLH/ps/f99feQjJSHz0TePEGjY0V5JxXhSDkOVooMnZmF0mDDd/y6Av1N344wRuh9SlbuIURxa6em9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761857469; c=relaxed/simple;
	bh=4TnDzFARb/hHkBWc55xRoXAP0oqfEr2SQqlingyQbz0=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Hz3FzT74zdm+LpvRnwoPa67fgSHhDmOZr05yvtDeIpNH9l8WBx0FMpg8W7uy43bqEXiQ0FyEsznZfMWB6NeHbs/Uc0VuMxVQlMZcmgO0rx+iXVFmkKMQEA7d9mMWgBJg/5qKy1ksUb6nuVwmCWKIU543HGf0VuRaMN+Zj27Bifc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=p4kS23KL; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1761857463; x=1762462263; i=markus.elfring@web.de;
	bh=UX+za681ZLF+H9xjQXJpwgYS36XQPi3DvT8rFDYYswI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=p4kS23KL3NHnIT3dQkJrWgZjv7az7eFapfcM2629V+KaGNRGKil4dORsQ3ngU54s
	 hAjzr3xe6NXX9C9JGrENt3m23vXa2adnjFyfu59oMmXFbLA39C7S9iqm5sLa80JBc
	 Y2W4jfhflofzM8QizoST3mRVJSValm419+7s5H0P1kfMAtnzjx7tDr70VI37XNQFW
	 k2458k/ddv5FfYGuoF4xQQHra+ByvTz2KgtpYqu+kMrHi44/rr1B8U/LMGSzQNMkk
	 PVu3h7c6HyPPonD6SDXERqiQWGMUzt0EUPKhRXCBGuWYQP19b0D2xOk+7Nx9CYYgt
	 Rk184HtCMr26zo+PPg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.248]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N8n4G-1wIxQP1FRu-00zGZd; Thu, 30
 Oct 2025 21:51:03 +0100
Message-ID: <ad42871b-22a6-4819-b5db-835e7044b3f1@web.de>
Date: Thu, 30 Oct 2025 21:51:00 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 Alexander Graf <agraf@suse.de>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 Miaoqian Lin <linmq006@gmail.com>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] KVM: PPC: Use pointer from memcpy() call for assignment in
 kvmppc_kvm_pv()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6XSDec5DYQ+59fbNP5IzsgzWfTdFXyH3eZ1ElapDgQ1U38Km2Fb
 lMfJ4kuLtgIN6aFggUBKLyFCYAzuJQZci0K75dhp3kAV19AWcDXgS2OMc9oLGBgSI7SwJde
 srQxqcV1IGyWylwgYLAOd19hXIraxJsyV9LrvvmRvhYyStvPakJGltqUYsTaPo3J5eWDbXL
 DnM5dTpiPGDj+36DuZTgg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:wc1zTz28d0g=;JqI+53ybK2zx2j4VKpxKpNGsLHp
 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
 gg2uznPjKj0EvhViw+kjLCXNek=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 30 Oct 2025 21:43:20 +0100
Subject: [PATCH] KVM: PPC: Use pointer from memcpy() call for assignment i=
n kvmppc_kvm_pv()

A pointer was assigned to a variable. The same pointer was used for
the destination parameter of a memcpy() call.
This function is documented in the way that the same value is returned.
Thus convert two separate statements into a direct variable assignment for
the return value from a memory copy action.

The source code was transformed by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 arch/powerpc/kvm/powerpc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 2ba057171ebe..ae28447b3e04 100644
=2D-- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -216,8 +216,7 @@ int kvmppc_kvm_pv(struct kvm_vcpu *vcpu)
=20
 			shared &=3D PAGE_MASK;
 			shared |=3D vcpu->arch.magic_page_pa & 0xf000;
-			new_shared =3D (void*)shared;
-			memcpy(new_shared, old_shared, 0x1000);
+			new_shared =3D memcpy(shared, old_shared, 0x1000);
 			vcpu->arch.shared =3D new_shared;
 		}
 #endif
=2D-=20
2.51.1


