Return-Path: <kvm+bounces-69602-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kD17OTTCe2k9IQIAu9opvQ
	(envelope-from <kvm+bounces-69602-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 21:25:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 56D0EB43A4
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 21:25:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CD3A33029E72
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 20:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82D3D352C40;
	Thu, 29 Jan 2026 20:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="E8Pv08Ca";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DsdqLgsQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF63C350A12
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 20:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769718315; cv=none; b=j4yrx9TX7glkbjHvz3lfqrXEajkAyV3vbalR45Wxx3c1p39oeTASJB8I+0+ydh438YZPJ4jafzLwK7gOD9rg9zNjXyXSKbBcyDJl+EvU6MvaxN6rdhwPiRgYhPAJwuG/KQf7U2sKRQgLfOH1Mr0MaXTLsF9/H+PiUbWEfVPp4F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769718315; c=relaxed/simple;
	bh=v/AZkG/28KlNhb9unjxf+fqtqEO0ZP93Qeegkhk42mQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Subject:Cc:To:
	 References:In-Reply-To; b=LP5cQ/NX+0bBsBM/jnADizf8M1UH7RCfYvTAI3mAUyidtU99qytJNDcXbIogBzAVCvq+VvCIJsRtQ1mPfrRQ4N1NEDccmeLKM4pirEd30rIAcD1XVHkKdW3O2Li3GGGfqHuTjYkZYC4N4unDVMluw9PjpifQCtTNbbdikT72asY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=E8Pv08Ca; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DsdqLgsQ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60TI6Cnn1430065
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 20:25:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TIyWfuFKG9M3pO5hQmbVZSaW8RBimd7V3pBdTPjwJ6A=; b=E8Pv08Ca/oUQS9hB
	ZCNVdyUPaPmHAb0tMd7umdEzkgtxTGSdyG1uqAi43M6r2rSBv/lE44S0NvIsO7mG
	ht4+V1T+H/jRPH5MqvDVwwFkGaOQVpNkNHxuLukDN6ZsJ8bys/HeO0Jd8pkefF7I
	XwCMLPB8VHsjr5MQg1QSYDdb8IGe08ZHn2kMq402lNbe+MiVsjM244MMOqCY6uZc
	S0cpcWEsw0L3xJq7fGO2PoCFkExVUb5oP2J4cMkd5Xa0GOQuhvEEaUy3t/7n3b6C
	dsKPWTBc8HOSEm4By3h5FB25ZvI8zcoTLiZufLbAStS6YiK/ohLGtUgqicyQZ/L+
	/T4x1g==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4byydh390v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 20:25:11 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8bb9f029f31so418043785a.2
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 12:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769718311; x=1770323111; darn=vger.kernel.org;
        h=in-reply-to:references:to:cc:subject:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TIyWfuFKG9M3pO5hQmbVZSaW8RBimd7V3pBdTPjwJ6A=;
        b=DsdqLgsQ1P/J/X7q+4yjQQX7wT5NRr84qYnnrB78gfkCqyXgVv8wDydWYLDtovvpo7
         XleXsM5PS/YGgDfDIQo9RCuzFXuTndB86wDg7+xxV4izn4ZX417JckugsiGSDCrDG4E+
         mtCG98P9EEFWzGHNJivanWzKc6tqjpI3926q7XYT/IAFphFs2RZjpdalrkeL0/78sXSr
         zgFksIJNcAKfzUxU9DRO8g8z6KoyjZEY3yfvPR1fs1QPYW6tLel2BO+q32LUw5TH3T3Y
         NYpkYyvaggdsWIJvJEtLzUrzeHOjDUNzIwYFPlgp51gGmkO45p0r4IegkbCSxObjc4js
         +nkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769718311; x=1770323111;
        h=in-reply-to:references:to:cc:subject:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TIyWfuFKG9M3pO5hQmbVZSaW8RBimd7V3pBdTPjwJ6A=;
        b=e2yEwxng0ZtUpGNzTYiUuh+BuURPT3hcHhB3iw4Xqijj/XACFnrM1GYU+NFiZfXatp
         6Op6tV5g75gPkfFHxpSTstRd6Y2WYpqchWpxXgM+3fndtbKxVUtTh1itEcFG5+7MmS2s
         gVVS3S8iDaYxj8h+FP4wXPBgVRkAIvOnYmG8n2RZee6l0F7UdP8Kxz5HxFJZO1myxvHc
         UnSjId5+8ZDAN24lMFLW+YqkdAlLxu7nmwcDWahAwXnvAyAxaiEGYE6ess9QRRLP/Ot8
         HuJ1ZKWjbmhOTX7lO0oHn/8crfoYfcoSLIlZcqidTbK75Ztudyp8njAM61GfOpI1Kvpg
         vwzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcY06IiJOp1p1D65/HIypT/8de4f34kRALB1JaBIdNpsSkLQ8RBPSYgzpI9UkETxY6iaM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywiqc0hkd5xIDPDOLGxopfX3RaW5uS74wC5qrhY2dh2dmvm5L1d
	2nIzfz4nbrfwwtHc4kpC6Z8h/f39mTTJpjHDzDczGOhwHMgCLE9f5x3s2+QNFjSpGHRvCbIUHlf
	Vsh7fgKAr0B7TdHxxhneORo2rZRk4Gx9gcotKzPhUgmcb6EpK0iyKQgU=
X-Gm-Gg: AZuq6aLLPUrSmM/5wjplHKeadIjVlavQ/vDVjkoYZ6uO1RZvTTDKPxpe2eduTgdX78k
	CMudJLey6WVFYziQ0avXqnDa4n+YYIsmibSChp3ONHOTwsEpNmF9e9AsB153gWT7/JJTmvHHM6C
	xpVeWpAsFy+1z5oG7RrkZUazC8vHeL/v2mJkuohg1MKwpkBS34wKP6t8CYw+6Pnx0KIx+0oLXwr
	MPSMV5fTuuYc9EH99mcPZLE0P9F3sbutLAcbIck4tI4m0DyMId52SgK1YRq/zVI55//IJpkvSCx
	n81eqecjL3nje3q9HOyyCv6fw1nAi4iQXfd/me2cCbfBLfkYoUlvq9m3GmoqfVwzvydYH7Pa28u
	6gN+LH6PQ3VL1pN/OoIqV7HD/4tBe7i0k9CGYiy1m8vjvip0+
X-Received: by 2002:a05:620a:29d2:b0:8c5:36be:41fe with SMTP id af79cd13be357-8c9eb32be89mr118653685a.60.1769718311177;
        Thu, 29 Jan 2026 12:25:11 -0800 (PST)
X-Received: by 2002:a05:620a:29d2:b0:8c5:36be:41fe with SMTP id af79cd13be357-8c9eb32be89mr118650785a.60.1769718310701;
        Thu, 29 Jan 2026 12:25:10 -0800 (PST)
Received: from localhost (ip-86-49-253-11.bb.vodafone.cz. [86.49.253.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4806ce4c3c6sm150902865e9.10.2026.01.29.12.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 12:25:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 29 Jan 2026 20:25:08 +0000
Message-Id: <DG1CS7KB3C6N.10FWH79J7UZHB@oss.qualcomm.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?=
 <radim.krcmar@oss.qualcomm.com>
Subject: [SUGGESTION] KVM: RISC-V: detect gstage mode hierarchy
Cc: <guoren@kernel.org>, <ajones@ventanamicro.com>,
        <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <corbet@lwn.net>, <anup@brainfault.org>, <atish.patra@linux.dev>,
        <pjw@kernel.org>, <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>,
        <alex@ghiti.fr>, <andrew.jones@oss.qualcomm.com>
To: <fangyu.yu@linux.alibaba.com>
References: <20260125150450.27068-1-fangyu.yu@linux.alibaba.com>
 <20260125150450.27068-2-fangyu.yu@linux.alibaba.com>
 <DG16GDMKZOBM.2QH3ZYM2WH7RO@oss.qualcomm.com>
In-Reply-To: <DG16GDMKZOBM.2QH3ZYM2WH7RO@oss.qualcomm.com>
X-Proofpoint-GUID: 3iISHHfNx0a3LxRJbIIcKa019OI8_S7e
X-Proofpoint-ORIG-GUID: 3iISHHfNx0a3LxRJbIIcKa019OI8_S7e
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDE0NyBTYWx0ZWRfX0208or2h/oJv
 Y9ogxH/pG6BCBCqM33H7lCXhg8WVcr8pI2sNnRAjXx1xwenAvNEuhA00d7CtDNAw6B5YSUdb0z6
 VjcFaZZlr47PZLMgTB+Xm3GlkpovBcFLUjeFLbYVUHS/UwyodcMUM/5lxEwMl6K9VzW8o5S2oOM
 isg0GjaNWlhpDE0yKlUU7dcSFXEPoYnaZCFb3wCkqXJ0GmcuZCAAJWmsMkuSe9k/rEbTxRW9Mlk
 HoiEOg86fPLuPrQ0+J00LiM4i+ArEdPQSYriLnB4HgKpokBlfKoPfIxibwaPa860907Cp8M2KfE
 V9PMbZ31KyHSkl8Br0zKU+wBxhTXq1v/V17nXXmASjfcORx05AFGWl9FJMC2I8LCyrcUGXNqX4c
 u8khx4TQw0LJfeIBrYu70Dqj+rVOg39f3DZEFHYL3sZ2tBGJOx76SLZOSbbjrc8vZyZL/NFfuLK
 9/DAoC31ZxGNe8TTRZQ==
X-Authority-Analysis: v=2.4 cv=Cs6ys34D c=1 sm=1 tr=0 ts=697bc227 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=HFCiZzTCIv7qJCpyeE1rag==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=M51BFTxLslgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=B30jFbksMaAZlFPmlSQA:9
 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_03,2026-01-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601290147
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.41 / 15.00];
	R_MIXED_CHARSET(1.25)[subject];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	TAGGED_FROM(0.00)[bounces-69602-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qualcomm.com:email,qualcomm.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	TO_DN_NONE(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[radim.krcmar@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 56D0EB43A4
X-Rspamd-Action: no action

2026-01-29T15:27:35+00:00, Radim Kr=C4=8Dm=C3=A1=C5=99 <radim.krcmar@oss.qu=
alcomm.com>:
> (I'll reply with a patch later.)

Something like this would avoid a bit of technical debt.
The solution could be even more generic by returning a bitmap of
supported modes, but that would be larger refactoring...

Feel free to use it in the series, but beware: only compile-tested.
It's late and hope it at least boots. :)

Thanks.
---8<---
RISC-V ISA does not require a hierarchy of standard hgatp mode (i.e.
57x4 does not depend on 48x4 onr 39x4), yet future patches want to
assume that the hierarchy exists, for simplicity.

Only accept a hgatp mode if all narrower modes are supported as well.

All sensible RISC-V implementations should have the hierarchy, since
it's very cheap to add the narrower modes.

Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@oss.qualcomm.com>
---
The hunk that removes the default values at the beginning of gstage.c
should have been a separate patch, sorry.
---
 arch/riscv/include/asm/kvm_gstage.h |  2 +-
 arch/riscv/kvm/gstage.c             | 66 ++++++++++++-----------------
 arch/riscv/kvm/main.c               |  6 ++-
 3 files changed, 32 insertions(+), 42 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_gstage.h b/arch/riscv/include/asm/k=
vm_gstage.h
index 595e2183173e..18db474ce583 100644
--- a/arch/riscv/include/asm/kvm_gstage.h
+++ b/arch/riscv/include/asm/kvm_gstage.h
@@ -67,6 +67,6 @@ void kvm_riscv_gstage_unmap_range(struct kvm_gstage *gsta=
ge,
=20
 void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa=
_t end);
=20
-void kvm_riscv_gstage_mode_detect(void);
+unsigned long kvm_riscv_gstage_mode_detect(void);
=20
 #endif
diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
index b67d60d722c2..678b304553bc 100644
--- a/arch/riscv/kvm/gstage.c
+++ b/arch/riscv/kvm/gstage.c
@@ -11,13 +11,8 @@
 #include <linux/pgtable.h>
 #include <asm/kvm_gstage.h>
=20
-#ifdef CONFIG_64BIT
-unsigned long kvm_riscv_gstage_mode __ro_after_init =3D HGATP_MODE_SV39X4;
-unsigned long kvm_riscv_gstage_pgd_levels __ro_after_init =3D 3;
-#else
-unsigned long kvm_riscv_gstage_mode __ro_after_init =3D HGATP_MODE_SV32X4;
-unsigned long kvm_riscv_gstage_pgd_levels __ro_after_init =3D 2;
-#endif
+unsigned long kvm_riscv_gstage_mode __ro_after_init;
+unsigned long kvm_riscv_gstage_pgd_levels __ro_after_init;
=20
 #define gstage_pte_leaf(__ptep)	\
 	(pte_val(*(__ptep)) & (_PAGE_READ | _PAGE_WRITE | _PAGE_EXEC))
@@ -313,47 +308,38 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gst=
age, gpa_t start, gpa_t end
 	}
 }
=20
-void __init kvm_riscv_gstage_mode_detect(void)
+static inline unsigned long __init __kvm_riscv_gstage_mode_detect(void)
 {
 #ifdef CONFIG_64BIT
-	/* Try Sv57x4 G-stage mode */
-	csr_write(CSR_HGATP, HGATP_MODE_SV57X4 << HGATP_MODE_SHIFT);
-	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) =3D=3D HGATP_MODE_SV57X4) {
-		kvm_riscv_gstage_mode =3D HGATP_MODE_SV57X4;
-		kvm_riscv_gstage_pgd_levels =3D 5;
-		goto done;
-	}
-
-	/* Try Sv48x4 G-stage mode */
-	csr_write(CSR_HGATP, HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
-	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) =3D=3D HGATP_MODE_SV48X4) {
-		kvm_riscv_gstage_mode =3D HGATP_MODE_SV48X4;
-		kvm_riscv_gstage_pgd_levels =3D 4;
-		goto done;
-	}
-
-	/* Try Sv39x4 G-stage mode */
 	csr_write(CSR_HGATP, HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
-	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) =3D=3D HGATP_MODE_SV39X4) {
-		kvm_riscv_gstage_mode =3D HGATP_MODE_SV39X4;
-		kvm_riscv_gstage_pgd_levels =3D 3;
-		goto done;
-	}
+	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) !=3D HGATP_MODE_SV39X4)
+		return HGATP_MODE_OFF;
+
+	csr_write(CSR_HGATP, HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
+	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) !=3D HGATP_MODE_SV48X4)
+		return HGATP_MODE_SV39X4;
+
+	csr_write(CSR_HGATP, HGATP_MODE_SV57X4 << HGATP_MODE_SHIFT);
+	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) !=3D HGATP_MODE_SV57X4)
+		return HGATP_MODE_SV48X4;
+
+	return HGATP_MODE_SV57X4;
 #else /* CONFIG_32BIT */
-	/* Try Sv32x4 G-stage mode */
 	csr_write(CSR_HGATP, HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
-	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) =3D=3D HGATP_MODE_SV32X4) {
-		kvm_riscv_gstage_mode =3D HGATP_MODE_SV32X4;
-		kvm_riscv_gstage_pgd_levels =3D 2;
-		goto done;
-	}
+	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) !=3D HGATP_MODE_SV32X4)
+		return HGATP_MODE_OFF;
+
+	return HGATP_MODE_SV32X4;
 #endif
+}
=20
-	/* KVM depends on !HGATP_MODE_OFF */
-	kvm_riscv_gstage_mode =3D HGATP_MODE_OFF;
-	kvm_riscv_gstage_pgd_levels =3D 0;
+/* We could probably omit the HGATP write and fence. */
+unsigned long __init kvm_riscv_gstage_mode_detect(void)
+{
+	unsigned long gstage_mode =3D __kvm_riscv_gstage_mode_detect();
=20
-done:
 	csr_write(CSR_HGATP, 0);
 	kvm_riscv_local_hfence_gvma_all();
+
+	return gstage_mode;
 }
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 45536af521f0..58fd6ae8e04a 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -104,19 +104,23 @@ static int __init riscv_kvm_init(void)
 	if (rc && rc !=3D -ENODEV)
 		return rc;
=20
-	kvm_riscv_gstage_mode_detect();
+	kvm_riscv_gstage_mode =3D kvm_riscv_gstage_mode_detect();
 	switch (kvm_riscv_gstage_mode) {
 	case HGATP_MODE_SV32X4:
 		str =3D "Sv32x4";
+		kvm_riscv_gstage_pgd_levels =3D 2;
 		break;
 	case HGATP_MODE_SV39X4:
 		str =3D "Sv39x4";
+		kvm_riscv_gstage_pgd_levels =3D 3;
 		break;
 	case HGATP_MODE_SV48X4:
 		str =3D "Sv48x4";
+		kvm_riscv_gstage_pgd_levels =3D 4;
 		break;
 	case HGATP_MODE_SV57X4:
 		str =3D "Sv57x4";
+		kvm_riscv_gstage_pgd_levels =3D 5;
 		break;
 	default:
 		kvm_riscv_nacl_exit();
--=20
2.51.0


