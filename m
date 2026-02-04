Return-Path: <kvm+bounces-70226-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EOnwHwhig2nAmAMAu9opvQ
	(envelope-from <kvm+bounces-70226-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:13:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CEDDE8236
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:13:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D3C3830054F5
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:06:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81C85426EBB;
	Wed,  4 Feb 2026 15:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="T+CZwiW7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276DA426691;
	Wed,  4 Feb 2026 15:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217396; cv=none; b=Ac8B6Fji6Mt1ev2AnkAmQGp78Y2pOzTdZncw9Fx3Ad3mvJNd3Qx/xoxMPFpJUmID4+WS15Sap7vyJKUt/Bbe0hTOk2n28MEn+H4L5Wv4JLl2x/hdYEi0m7qKQesbvfDP8UHlqpQkkNxSuUm5uule7EaDxi2TasTzDiQqTFBdEPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217396; c=relaxed/simple;
	bh=uXe7iU9TcPHImEr6aYR53RiEIzjjtUhgCuuMxMoetcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4MJKJhP5mSa37DW2PaaE0O1odwvw/tCBI11OYXdokx9vLDDfIAnGsMtvHYHY26HNgRusJTpoC4BUwW4PFS+QG7Bn7G0Er+36VFp2ySykg4V3sbP4epYLZDJGiuWeOBuVh00It+dhgLhBlhBMKhvCNQMOU0vg73rdW2aQhxf3bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=T+CZwiW7; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 614EsmVb006454;
	Wed, 4 Feb 2026 15:03:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=E9PAUnJlbkhgz5yld
	Ei9g1o3xVsFa/94NQjHWyaoxaI=; b=T+CZwiW7WKzUYkAVVKbNA2+dCyiC3FFPc
	jMUfFodV2Y5LthRgCkmI7kM+4CT7tVVgJxDTRz2mjqFZEn8DRaOP+LjmayK65vPV
	3oOrl5zTJh0N2iuWsETgOAYTzwHORQfl95eeIIF769BBeNU9KHFW6BUk2Bw8QJKn
	+jQkIzKbhPzV+a68tHiFKmgXOBjYyVx8eRR5P40R06yv2mMOqmX3vDaJSXjwNn2v
	m0UdEgeXgB/RSDWwqRYu+QKtl5bjQpM2UhXws335PQtoU4CdgIoEca8q08FRdZvs
	P5F9HtFntjT6Vz07ZCVWGXdi3Im9++Ul/BE0k8d9qpYZBO4Kocs8Q==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19cw7rnv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:10 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614CTXp3004466;
	Wed, 4 Feb 2026 15:03:09 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1wjjwk8y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:09 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614F35WY60162392
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:03:05 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4146020040;
	Wed,  4 Feb 2026 15:03:05 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC31E2004B;
	Wed,  4 Feb 2026 15:03:04 +0000 (GMT)
Received: from p-imbrenda.aag-de.ibm.com (unknown [9.52.223.175])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Feb 2026 15:03:04 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@kernel.org,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v7 18/29] KVM: s390: KVM page table management functions: CMMA
Date: Wed,  4 Feb 2026 16:02:47 +0100
Message-ID: <20260204150259.60425-19-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260204150259.60425-1-imbrenda@linux.ibm.com>
References: <20260204150259.60425-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExMyBTYWx0ZWRfX4qGKgHPkaZdA
 uQZ9/H7VAAwNCOumn6ryzPyEeROaTRqX28ezuC+XcMHP7S1e1HuLXZ3dso9rkZEOLCSk9WXpXul
 rhJZxShVJeb6VOlM8KQA2vVFYotfLcMQEqGxxnnI6zjWOGdnqJu46TYxa0falJ3YMeMRQWykn1T
 PsDpxkzCU92FyOpvDLHJubY23RRmqQZ4bW6FIyo5rOHctX+uTxXhRGwEcbe27QkvgyPhNxqDvxm
 jpwW79hRFO3dgNzF+jcJASCXM48lcW8X70pyHif+xmrTvzLxr6EQSXGfiDpZaKULxMtiBBn4YQ9
 P8XezqgQia3jNVacS9+gD6+a94D4ZxinIo6i4tHw6lcPj/5FYrM6YXbRkbqDEnJ7tSQ3k7DUpSC
 AyvQgMZ7W0iW3HmPmB+ZJ+lrRp+GjR4dFhiO2yOCUoEruZyjV7aNsSotEcxY15gl/UEGqBLERKZ
 JUgNIITey4FtDXkVCyw==
X-Authority-Analysis: v=2.4 cv=UuRu9uwB c=1 sm=1 tr=0 ts=69835fae cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=DcBydVYxWztYwQPU1OIA:9
X-Proofpoint-ORIG-GUID: fvBVGFdXxm2LmSjifbYgLKZfx67Ix7JS
X-Proofpoint-GUID: fvBVGFdXxm2LmSjifbYgLKZfx67Ix7JS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_04,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602040113
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70226-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 1CEDDE8236
X-Rspamd-Action: no action

Add page table management functions to be used for KVM guest (gmap)
page tables.

This patch adds functions to handle CMMA and the ESSA instruction.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/dat.c | 275 ++++++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/dat.h |  27 +++++
 2 files changed, 302 insertions(+)

diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
index bc27405cdea1..129dc55a4a0d 100644
--- a/arch/s390/kvm/dat.c
+++ b/arch/s390/kvm/dat.c
@@ -1114,3 +1114,278 @@ int dat_set_prefix_notif_bit(union asce asce, gfn_t gfn)
 		return -EAGAIN;
 	return 0;
 }
+
+/**
+ * dat_perform_essa() - Perform ESSA actions on the PGSTE.
+ * @asce: The asce to operate on.
+ * @gfn: The guest page frame to operate on.
+ * @orc: The specific action to perform, see the ESSA_SET_* macros.
+ * @state: The storage attributes to be returned to the guest.
+ * @dirty: Returns whether the function dirtied a previously clean entry.
+ *
+ * Context: Called with kvm->mmu_lock held.
+ *
+ * Return:
+ * * %1 if the page state has been altered and the page is to be added to the CBRL
+ * * %0 if the page state has been altered, but the page is not to be added to the CBRL
+ * * %-1 if the page state has not been altered and the page is not to be added to the CBRL
+ */
+int dat_perform_essa(union asce asce, gfn_t gfn, int orc, union essa_state *state, bool *dirty)
+{
+	union crste *crstep;
+	union pgste pgste;
+	union pte *ptep;
+	int res = 0;
+
+	if (dat_entry_walk(NULL, gfn, asce, 0, TABLE_TYPE_PAGE_TABLE, &crstep, &ptep)) {
+		*state = (union essa_state) { .exception = 1 };
+		return -1;
+	}
+
+	pgste = pgste_get_lock(ptep);
+
+	*state = (union essa_state) {
+		.content = (ptep->h.i << 1) + (ptep->h.i && pgste.zero),
+		.nodat = pgste.nodat,
+		.usage = pgste.usage,
+		};
+
+	switch (orc) {
+	case ESSA_GET_STATE:
+		res = -1;
+		break;
+	case ESSA_SET_STABLE:
+		pgste.usage = PGSTE_GPS_USAGE_STABLE;
+		pgste.nodat = 0;
+		break;
+	case ESSA_SET_UNUSED:
+		pgste.usage = PGSTE_GPS_USAGE_UNUSED;
+		if (ptep->h.i)
+			res = 1;
+		break;
+	case ESSA_SET_VOLATILE:
+		pgste.usage = PGSTE_GPS_USAGE_VOLATILE;
+		if (ptep->h.i)
+			res = 1;
+		break;
+	case ESSA_SET_POT_VOLATILE:
+		if (!ptep->h.i) {
+			pgste.usage = PGSTE_GPS_USAGE_POT_VOLATILE;
+		} else if (pgste.zero) {
+			pgste.usage = PGSTE_GPS_USAGE_VOLATILE;
+		} else if (!pgste.gc) {
+			pgste.usage = PGSTE_GPS_USAGE_VOLATILE;
+			res = 1;
+		}
+		break;
+	case ESSA_SET_STABLE_RESIDENT:
+		pgste.usage = PGSTE_GPS_USAGE_STABLE;
+		/*
+		 * Since the resident state can go away any time after this
+		 * call, we will not make this page resident. We can revisit
+		 * this decision if a guest will ever start using this.
+		 */
+		break;
+	case ESSA_SET_STABLE_IF_RESIDENT:
+		if (!ptep->h.i)
+			pgste.usage = PGSTE_GPS_USAGE_STABLE;
+		break;
+	case ESSA_SET_STABLE_NODAT:
+		pgste.usage = PGSTE_GPS_USAGE_STABLE;
+		pgste.nodat = 1;
+		break;
+	default:
+		WARN_ONCE(1, "Invalid ORC!");
+		res = -1;
+		break;
+	}
+	/* If we are discarding a page, set it to logical zero. */
+	pgste.zero = res == 1;
+	if (orc > 0) {
+		*dirty = !pgste.cmma_d;
+		pgste.cmma_d = 1;
+	}
+
+	pgste_set_unlock(ptep, pgste);
+
+	return res;
+}
+
+static long dat_reset_cmma_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	union pgste pgste;
+
+	pgste = pgste_get_lock(ptep);
+	pgste.usage = 0;
+	pgste.nodat = 0;
+	pgste.cmma_d = 0;
+	pgste_set_unlock(ptep, pgste);
+	if (need_resched())
+		return next;
+	return 0;
+}
+
+long dat_reset_cmma(union asce asce, gfn_t start)
+{
+	const struct dat_walk_ops dat_reset_cmma_ops = {
+		.pte_entry = dat_reset_cmma_pte,
+	};
+
+	return _dat_walk_gfn_range(start, asce_end(asce), asce, &dat_reset_cmma_ops,
+				   DAT_WALK_IGN_HOLES, NULL);
+}
+
+struct dat_get_cmma_state {
+	gfn_t start;
+	gfn_t end;
+	unsigned int count;
+	u8 *values;
+	atomic64_t *remaining;
+};
+
+static long __dat_peek_cmma_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	struct dat_get_cmma_state *state = walk->priv;
+	union pgste pgste;
+
+	pgste = pgste_get_lock(ptep);
+	state->values[gfn - walk->start] = pgste.usage | (pgste.nodat << 6);
+	pgste_set_unlock(ptep, pgste);
+	state->end = next;
+
+	return 0;
+}
+
+static long __dat_peek_cmma_crste(union crste *crstep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	struct dat_get_cmma_state *state = walk->priv;
+
+	if (crstep->h.i)
+		state->end = min(walk->end, next);
+	return 0;
+}
+
+int dat_peek_cmma(gfn_t start, union asce asce, unsigned int *count, u8 *values)
+{
+	const struct dat_walk_ops ops = {
+		.pte_entry = __dat_peek_cmma_pte,
+		.pmd_entry = __dat_peek_cmma_crste,
+		.pud_entry = __dat_peek_cmma_crste,
+		.p4d_entry = __dat_peek_cmma_crste,
+		.pgd_entry = __dat_peek_cmma_crste,
+	};
+	struct dat_get_cmma_state state = { .values = values, };
+	int rc;
+
+	rc = _dat_walk_gfn_range(start, start + *count, asce, &ops, DAT_WALK_DEFAULT, &state);
+	*count = state.end - start;
+	/* Return success if at least one value was saved, otherwise an error. */
+	return (rc == -EFAULT && *count > 0) ? 0 : rc;
+}
+
+static long __dat_get_cmma_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	struct dat_get_cmma_state *state = walk->priv;
+	union pgste pgste;
+
+	if (state->start != -1) {
+		if ((gfn - state->end) > KVM_S390_MAX_BIT_DISTANCE)
+			return 1;
+		if (gfn - state->start >= state->count)
+			return 1;
+	}
+
+	if (!READ_ONCE(*pgste_of(ptep)).cmma_d)
+		return 0;
+
+	pgste = pgste_get_lock(ptep);
+	if (pgste.cmma_d) {
+		if (state->start == -1)
+			state->start = gfn;
+		pgste.cmma_d = 0;
+		atomic64_dec(state->remaining);
+		state->values[gfn - state->start] = pgste.usage | pgste.nodat << 6;
+		state->end = next;
+	}
+	pgste_set_unlock(ptep, pgste);
+	return 0;
+}
+
+int dat_get_cmma(union asce asce, gfn_t *start, unsigned int *count, u8 *values, atomic64_t *rem)
+{
+	const struct dat_walk_ops ops = { .pte_entry = __dat_get_cmma_pte, };
+	struct dat_get_cmma_state state = {
+		.remaining = rem,
+		.values = values,
+		.count = *count,
+		.start = -1,
+	};
+
+	_dat_walk_gfn_range(*start, asce_end(asce), asce, &ops, DAT_WALK_IGN_HOLES, &state);
+
+	if (state.start == -1) {
+		*count = 0;
+	} else {
+		*count = state.end - state.start;
+		*start = state.start;
+	}
+
+	return 0;
+}
+
+struct dat_set_cmma_state {
+	unsigned long mask;
+	const u8 *bits;
+};
+
+static long __dat_set_cmma_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	struct dat_set_cmma_state *state = walk->priv;
+	union pgste pgste, tmp;
+
+	tmp.val = (state->bits[gfn - walk->start] << 24) & state->mask;
+
+	pgste = pgste_get_lock(ptep);
+	pgste.usage = tmp.usage;
+	pgste.nodat = tmp.nodat;
+	pgste_set_unlock(ptep, pgste);
+
+	return 0;
+}
+
+/**
+ * dat_set_cmma_bits() - Set CMMA bits for a range of guest pages.
+ * @mc: Cache used for allocations.
+ * @asce: The ASCE of the guest.
+ * @gfn: The guest frame of the fist page whose CMMA bits are to set.
+ * @count: How many pages need to be processed.
+ * @mask: Which PGSTE bits should be set.
+ * @bits: Points to an array with the CMMA attributes.
+ *
+ * This function sets the CMMA attributes for the given pages. If the input
+ * buffer has zero length, no action is taken, otherwise the attributes are
+ * set and the mm->context.uses_cmm flag is set.
+ *
+ * Each byte in @bits contains new values for bits 32-39 of the PGSTE.
+ * Currently, only the fields NT and US are applied.
+ *
+ * Return: %0 in case of success, a negative error value otherwise.
+ */
+int dat_set_cmma_bits(struct kvm_s390_mmu_cache *mc, union asce asce, gfn_t gfn,
+		      unsigned long count, unsigned long mask, const uint8_t *bits)
+{
+	const struct dat_walk_ops ops = { .pte_entry = __dat_set_cmma_pte, };
+	struct dat_set_cmma_state state = { .mask = mask, .bits = bits, };
+	union crste *crstep;
+	union pte *ptep;
+	gfn_t cur;
+	int rc;
+
+	for (cur = ALIGN_DOWN(gfn, _PAGE_ENTRIES); cur < gfn + count; cur += _PAGE_ENTRIES) {
+		rc = dat_entry_walk(mc, cur, asce, DAT_WALK_ALLOC, TABLE_TYPE_PAGE_TABLE,
+				    &crstep, &ptep);
+		if (rc)
+			return rc;
+	}
+	return _dat_walk_gfn_range(gfn, gfn + count, asce, &ops, DAT_WALK_IGN_HOLES, &state);
+}
diff --git a/arch/s390/kvm/dat.h b/arch/s390/kvm/dat.h
index fe8d790a297d..358b756ca8c9 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -17,6 +17,15 @@
 #include <asm/tlbflush.h>
 #include <asm/dat-bits.h>
 
+/*
+ * Base address and length must be sent at the start of each block, therefore
+ * it's cheaper to send some clean data, as long as it's less than the size of
+ * two longs.
+ */
+#define KVM_S390_MAX_BIT_DISTANCE (2 * sizeof(void *))
+/* For consistency */
+#define KVM_S390_CMMA_SIZE_MAX ((u32)KVM_S390_SKEYS_MAX)
+
 #define _ASCE(x) ((union asce) { .val = (x), })
 #define NULL_ASCE _ASCE(0)
 
@@ -433,6 +442,17 @@ static inline union crste _crste_fc1(kvm_pfn_t pfn, int tt, bool writable, bool
 	return res;
 }
 
+union essa_state {
+	unsigned char val;
+	struct {
+		unsigned char		: 2;
+		unsigned char nodat	: 1;
+		unsigned char exception	: 1;
+		unsigned char usage	: 2;
+		unsigned char content	: 2;
+	};
+};
+
 /**
  * struct vsie_rmap - reverse mapping for shadow page table entries
  * @next: pointer to next rmap in the list
@@ -522,6 +542,13 @@ bool dat_test_age_gfn(union asce asce, gfn_t start, gfn_t end);
 int dat_link(struct kvm_s390_mmu_cache *mc, union asce asce, int level,
 	     bool uses_skeys, struct guest_fault *f);
 
+int dat_perform_essa(union asce asce, gfn_t gfn, int orc, union essa_state *state, bool *dirty);
+long dat_reset_cmma(union asce asce, gfn_t start_gfn);
+int dat_peek_cmma(gfn_t start, union asce asce, unsigned int *count, u8 *values);
+int dat_get_cmma(union asce asce, gfn_t *start, unsigned int *count, u8 *values, atomic64_t *rem);
+int dat_set_cmma_bits(struct kvm_s390_mmu_cache *mc, union asce asce, gfn_t gfn,
+		      unsigned long count, unsigned long mask, const uint8_t *bits);
+
 int kvm_s390_mmu_cache_topup(struct kvm_s390_mmu_cache *mc);
 
 #define GFP_KVM_S390_MMU_CACHE (GFP_ATOMIC | __GFP_ACCOUNT | __GFP_NOWARN)
-- 
2.52.0


