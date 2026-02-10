Return-Path: <kvm+bounces-70745-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CGM6I61Qi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70745-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:37:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 035F611C932
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:37:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8525C307279C
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:35:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F226389E01;
	Tue, 10 Feb 2026 15:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DMOJNDqU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB4938884B;
	Tue, 10 Feb 2026 15:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737679; cv=none; b=q7UZg/l8vZKGs3tLhbAVbeg6uCnpY4tiQsrMfkxbnPWggfNVUVtnT85a51PBxJ6tnN2DUz3lGRWgV/1Fa9HnwzVI5Ltyb8xENyTCehigB9K9YtlNppeEfmWfq8oAXRVqj+j67zWAHsQ6OPe7v/3rrM/pSObGpZdtU92KvXvL3ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737679; c=relaxed/simple;
	bh=+DN8UtmU7dZ5zLFMq7F5WXLmBlj9gl75ZYmafsC6xu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSphjfhmdfjIKfo7sMus/JL+oBl0zgECv6sgLQNSUTPVVy+PoAaPS5jLpdllqajU5BgwMzoDM+S3wN8Y3q1GyQOTTiCEJU0pwwzNKdwxEcMQabvHbvcsPU3gGYa8eymtr8DgilV1c/STilms/fj+YmsB5MIfXg2c7qedX2g3hNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DMOJNDqU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61ABeqjn362336;
	Tue, 10 Feb 2026 15:34:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=YsM3s06o3K1Kq/orV
	cgFv/bK/E2BuXss4+3du/sqyWo=; b=DMOJNDqU7+yCsB426x1qNN0MYPaVdvtut
	JSp79jjQDjfgeT3MXcm3F3RgepQaz63L04ijxr5/xOY7iYuL26cngg61HT+YkrYT
	DTLyr0rsqNM16x9YHhELg4+Hda+piGRf1nacIjlqpnGanvyLc+PpodmZYAWyNaHG
	UFqTQ91gDimFKWNFChYxsZ62qhoyZUw89qja/noQsuyDQ1SWRpeUPJtvyzENAOCX
	Y/5IHmErFhFiHi6cvVaOA+U+aNZEChnnEdHzj7+RWk9SZJkSmOjqVnF9kIj8G/VQ
	LpXsQA92zOAsCXnIXCpAF26P2Y1PImNLQMdRyt9xv/Xq+PYuDTgSA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696w4x9j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:34 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AE0ULi008383;
	Tue, 10 Feb 2026 15:34:33 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6g3y9y3f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:32 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYTRA15860142
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:29 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E7D9120040;
	Tue, 10 Feb 2026 15:34:28 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 756ED20043;
	Tue, 10 Feb 2026 15:34:28 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:28 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 19/36] KVM: s390: KVM page table management functions: CMMA
Date: Tue, 10 Feb 2026 16:34:00 +0100
Message-ID: <20260210153417.77403-20-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260210153417.77403-1-imbrenda@linux.ibm.com>
References: <20260210153417.77403-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=YeCwJgRf c=1 sm=1 tr=0 ts=698b500a cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=DcBydVYxWztYwQPU1OIA:9
X-Proofpoint-GUID: nM8nUrMMWrbpx_CbUZhmk6mErb6H30pZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfX15cShGrco74B
 La2ywIaKX8RbeuwTTCAIcYv4tLgVuZwSdanGb6KG04iYXy2CO4RfItN51Gaw4mT1L7ABFHU7m35
 jVRbBjZMAEq26i9XwRWhm9yC/yNpRlcgVjuWp/BYDvpCxhFaYAdiPx2QfbEcJNDNNJsbZ3yMmx/
 MSZUHwX7XZBWYokf1lKWwPdvEecwr/xq/5AXzkiRPorWZJbcGM2p+CC6OAmtTbTQBCKtKymXDF0
 d/lj7kr0fOBkUimIAIbloPijcfJfIxI12l/50aogTAh14DEED2V+1u2l78oQHyIJdgxQfvenxrF
 WraeQdIJBzBh3Mr3J64+UdceovEFgRn+JLHfxiWXWxBADVevACwunyOTV9Dujb6Pq9UaQLfW05S
 q+n7gd9iKhSI6BP7ottO/G+O43wJn1HQHa0xIiBj7X9EW724InZ3JWbt4x40WlduiYwTPXrNE9O
 QyxyiHRotL13LANf4gw==
X-Proofpoint-ORIG-GUID: nM8nUrMMWrbpx_CbUZhmk6mErb6H30pZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602100128
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70745-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.ibm.com:mid,pgste.zero:url];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 035F611C932
X-Rspamd-Action: no action

Add page table management functions to be used for KVM guest (gmap)
page tables.

This patch adds functions to handle CMMA and the ESSA instruction.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
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
2.53.0


