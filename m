Return-Path: <kvm+bounces-61651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D0C6CC23895
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 08:23:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B6B994EEA68
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 07:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BF75329383;
	Fri, 31 Oct 2025 07:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="A1KEi3eO"
X-Original-To: kvm@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D864329373;
	Fri, 31 Oct 2025 07:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761895357; cv=none; b=kfnMrRwFXMLKygZqRXZ7vMaQcsUhKFBr/grbV8lEIJiccbtQJhNSzWetA/c1Nq3KMqAlOqSDtSVub2lll8a8/njy81dbTaX6DqNNzT13Dhcv3tptML+WefRw7d7s0RcB0oImBvbOIDDqIii8dqmGuDhLbjF9a2ooeW+FADzP/HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761895357; c=relaxed/simple;
	bh=7xMfs+3hffzEcbpjwmj2Nulfq855xLk3lBCy4a5eWHg=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=XxvpXoC0fBPwU3IcPNd8Rw9uncd0F0dQt4DtHdtMoHv3V8mS/SclGKXqvuOwtz+eDbILEqujKuooQHi1BHlSfcKiE5eLhCfy5cVOdxaP1gu9h+vQQ3VaMBJMdngTj9Dvk8IcOpRqFMnOwELRmNawhl236mlvjwnvAPOiHrMIX4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=A1KEi3eO; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1761895352; x=1762500152; i=markus.elfring@web.de;
	bh=JdjowvmlsVMwRJy+bhbsEzccqdlDNjZZR6ZpeoRwOCs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=A1KEi3eOULAc8TBb8lqm4dNxDtsuFqyhv6Iv0jWoAaGes5RUunTJoScRvwXGsvlI
	 clqX1/WAlsfLmtX9Pa//1eq2pYi0G/6hWd5HsgqnPNUsuvyOoYR4JRlOtXXrZ6ybD
	 rqNDt4KxcJXbYYzcq9gCFt6wCopEeNPtY1299zxWaEispq9mH7bpZ5Wwg/Q3ZIIJJ
	 pf6tl0kYsZfcV1PylPJhLmUSPh/tPlGiLQenUcxbyKcL8DvQN+RQ8CcX2kX2LPrso
	 XxHhzvYx888VXkvOaqcZ2KBpP5jOhXC08B7Jvvtnx1/m/x8fGhdIH26c1UXNd5Zvt
	 2RIJuG30slUUuAPFMw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.206]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N79N8-1wJtMi0b1g-00xViS; Fri, 31
 Oct 2025 08:22:32 +0100
Message-ID: <f488454a-0a0c-4726-b387-451f3c608165@web.de>
Date: Fri, 31 Oct 2025 08:22:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 =?UTF-8?Q?Christian_Borntr=C3=A4ger?= <borntraeger@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 =?UTF-8?Q?Gerald_Sch=C3=A4fer?= <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 Miaoqian Lin <linmq006@gmail.com>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] s390/mm: Use pointer from memcpy() call for assignment in
 s390_replace_asce()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:JsnSBv9RhLo96QLucX+7fgRG3PkhCoTticdUJpJojnOHP8Xk/Zl
 azVJ6AZCgMZaZD211rQXosGQL5Bw7u3kcuZ69FgKhSddKpPi5+Ze/hU3xbKlB1lyZc3q/3N
 mHRdlHHMtM6M7r26Em/iqaeSGzdZaCtQxRnLTKOmfNVtQCMYxKzZ/BoxyWZKB2A/q6zdOyX
 rDCCd4HLXh7cKp3Z5Kriw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:zL1ewK+nPRw=;1W7MyPgGNexodue6ZIbkqraVeqi
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 31 Oct 2025 07:56:06 +0100

A pointer was assigned to a variable. The same pointer was used for
the destination parameter of a memcpy() call.
This function is documented in the way that the same value is returned.
Thus convert two separate statements into a direct variable assignment for
the return value from a memory copy action.

The source code was transformed by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 arch/s390/mm/gmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 22c448b32340..e49e839933f1 100644
=2D-- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2440,8 +2440,8 @@ int s390_replace_asce(struct gmap *gmap)
 	page =3D gmap_alloc_crst();
 	if (!page)
 		return -ENOMEM;
-	table =3D page_to_virt(page);
-	memcpy(table, gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));
+
+	table =3D memcpy(page_to_virt(page), gmap->table, 1UL << (CRST_ALLOC_ORD=
ER + PAGE_SHIFT));
=20
 	/* Set new table origin while preserving existing ASCE control bits */
 	asce =3D (gmap->asce & ~_ASCE_ORIGIN) | __pa(table);
=2D-=20
2.51.1


