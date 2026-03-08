Return-Path: <kvm+bounces-73233-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KJ6fK2fnrGlSvwEAu9opvQ
	(envelope-from <kvm+bounces-73233-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 04:05:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 099FA22E60E
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 04:05:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 42F6E303C02E
	for <lists+kvm@lfdr.de>; Sun,  8 Mar 2026 03:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44B2831691A;
	Sun,  8 Mar 2026 03:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Eyy75mf/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AB328150F;
	Sun,  8 Mar 2026 03:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772939090; cv=none; b=eQnLiziEHhYgAxbO4B2gzbDL2r9/sWSBr0+GCdF+23n7tIjnHTot5ddVzqkSL1VuLZoMRix/GnLkdLi2k3608cd8w4e0XqpJOjFs2IFLhl/phiXv0OtkxGEH8FS05Z4cW9cR8OD+y4yGtYm0QbfjV18uXBeKFc3sl2DS9Pzn7cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772939090; c=relaxed/simple;
	bh=X2Hx5h5OhgYSaF8Pj5faad2dNA/MMYHUK3JDDbRxai8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Blefjdiht3aYWKlb5FNpUgGC2QoxyqFz2KCS7/OEyFKgi1bQW7KI0ta2+mNvZstdkHOyweeZyQlwBtoGqNVyRu8kdaECgrPP99nOi+Y1wYyhab1NBtTDzmHrltWfxcCGN8nXn/qGCWl1+JGl3CJ2ngL00uHTlc4yZXBgwIjxtfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Eyy75mf/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6280U6SD3358408;
	Sun, 8 Mar 2026 03:04:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=/ZfZ+9e70WuiTmypy
	LwkrkJ1arXuxkss6L0U2LrOEXE=; b=Eyy75mf/qsAj7SDxYspIizMRl7Py4pfGa
	r8UCdHMI5y8s041NjSio4Fx01GJdrhaiomIA8a5ubTeXuT0dqE5vzVO7oQcrjrpX
	J7LkT/g2zLVC6vvGd7s/81izJc+Ht8iGNnooiXkpnl3X83rgB+nPRPOxjp+cZMfp
	8o+Uu/pXfAJA+LLjBRlpMj/O+6u27Hqy9gDLoCwJIJusSBbCweJzW7/jmoV8lHF6
	3EShlkBydwPbczvyyckb7u/WbfOc9M2q8tIOftPD8oj7e4tiWHq35PMzLSk2sDKJ
	DkS0hsjvgkQ/BI8re35qEg8YgS8gbOQhZHDeaRNQV5iBmNS/7E75Q==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcvr2ftb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 03:04:45 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6282gNw8024657;
	Sun, 8 Mar 2026 03:04:45 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cs0jjr1u1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 03:04:45 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62834iHV18678316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 8 Mar 2026 03:04:44 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 36ED758058;
	Sun,  8 Mar 2026 03:04:44 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F4CB58057;
	Sun,  8 Mar 2026 03:04:43 +0000 (GMT)
Received: from 9.60.13.83 (unknown [9.60.13.83])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sun,  8 Mar 2026 03:04:43 +0000 (GMT)
From: Douglas Freimuth <freimuth@linux.ibm.com>
To: borntraeger@linux.ibm.com, imbrenda@linux.ibm.com, frankja@linux.ibm.com,
        david@kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mjrosato@linux.ibm.com, freimuth@linux.ibm.com
Subject: [PATCH v1 2/3] Enable adapter_indicators_set to use mapped pages
Date: Sun,  8 Mar 2026 04:04:37 +0100
Message-ID: <20260308030438.88580-3-freimuth@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260308030438.88580-1-freimuth@linux.ibm.com>
References: <20260308030438.88580-1-freimuth@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA4MDAyNiBTYWx0ZWRfXwUZu/2rsmROF
 6YApjIzQqdDPS9yV1KOjYXC34H321IGDc0kGIELlt4rmKWtey8Ltt4hkETLKP7kW1Ln39mnySBc
 nmQOanGcSkpI+0WvBGln74W+VlrpjAX4NHc08zfHET+DXozUGLR7nsog7j4rwGl65lSA7Z3WXvm
 0VmZck6DOoLZS7l3wv8OauctFo2hGKKtaIswHi9uQeFb3t0fFJbnz4HFn3Q396XbSiSZkozi5of
 RsEFnt/vowgLaz1BKt3MwQkkE4Slwdx2WP9TTsfwYanNPs/q//DiJ4FfgQPIVmk3Dvw61TaEiVd
 62wu+F64hBt6xP2MnKyVxAtp9kvzt1faki+7EE5KUQK6d9chcfJgOlE0jNhdtf8lWjaTyi6CBQZ
 sa6gThHfzSkaKOFHP/+H88cvzkvLQ+VTRPtKkdUUSnwvnuX9KvXdrSzWaGFpFo44fAsoKeARvhy
 Dz8d2o/MOd00Z6KUltQ==
X-Proofpoint-GUID: jbkGIAihYMSJUWtpPi6VOo4dys9QTMkQ
X-Proofpoint-ORIG-GUID: jbkGIAihYMSJUWtpPi6VOo4dys9QTMkQ
X-Authority-Analysis: v=2.4 cv=QoFTHFyd c=1 sm=1 tr=0 ts=69ace74d cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=D0cRkWJsx0RdNmUHjycA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-08_01,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1011 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603080026
X-Rspamd-Queue-Id: 099FA22E60E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73233-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[freimuth@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.986];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

Patch 2: This patch enables adapter_indicators_set to use mapped pages.
If adapter indicator pages are not mapped then local mapping is done as
it is prior to this patch. For example, Secure Execution environments
will take the local mapping path as it does prior to this patch.

Signed-off-by: Douglas Freimuth <freimuth@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 89 +++++++++++++++++++++++++++------------
 1 file changed, 62 insertions(+), 27 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index cafc03e20f8f..350106f84763 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2836,41 +2836,74 @@ static unsigned long get_ind_bit(__u64 addr, unsigned long bit_nr, bool swap)
 	return swap ? (bit ^ (BITS_PER_LONG - 1)) : bit;
 }
 
+static struct s390_map_info *get_map_info(struct s390_io_adapter *adapter,
+					  u64 addr)
+{
+	struct s390_map_info *map;
+
+	if (!adapter)
+		return NULL;
+
+	list_for_each_entry(map, &adapter->maps, list) {
+		if (map->guest_addr == addr)
+			return map;
+	}
+	return NULL;
+}
+
 static int adapter_indicators_set(struct kvm *kvm,
-				  struct s390_io_adapter *adapter,
-				  struct kvm_s390_adapter_int *adapter_int)
+				struct s390_io_adapter *adapter,
+				struct kvm_s390_adapter_int *adapter_int)
 {
 	unsigned long bit;
 	int summary_set, idx;
-	struct page *ind_page, *summary_page;
+	struct s390_map_info *ind_info, *summary_info;
 	void *map;
+	struct page *ind_page, *summary_page;
 
-	ind_page = get_map_page(kvm, adapter_int->ind_addr);
-	if (!ind_page)
-		return -1;
-	summary_page = get_map_page(kvm, adapter_int->summary_addr);
-	if (!summary_page) {
-		put_page(ind_page);
-		return -1;
+	ind_info = get_map_info(adapter, adapter_int->ind_addr);
+	if (!ind_info) {
+		ind_page = get_map_page(kvm, adapter_int->ind_addr);
+		if (!ind_page)
+			return -1;
+		idx = srcu_read_lock(&kvm->srcu);
+		map = page_address(ind_page);
+		bit = get_ind_bit(adapter_int->ind_addr,
+				  adapter_int->ind_offset, adapter->swap);
+		set_bit(bit, map);
+		mark_page_dirty(kvm, adapter_int->ind_gaddr >> PAGE_SHIFT);
+		set_page_dirty_lock(ind_page);
+		srcu_read_unlock(&kvm->srcu, idx);
+	} else {
+		map = page_address(ind_info->page);
+		bit = get_ind_bit(ind_info->addr, adapter_int->ind_offset, adapter->swap);
+		set_bit(bit, map);
 	}
 
-	idx = srcu_read_lock(&kvm->srcu);
-	map = page_address(ind_page);
-	bit = get_ind_bit(adapter_int->ind_addr,
-			  adapter_int->ind_offset, adapter->swap);
-	set_bit(bit, map);
-	mark_page_dirty(kvm, adapter_int->ind_gaddr >> PAGE_SHIFT);
-	set_page_dirty_lock(ind_page);
-	map = page_address(summary_page);
-	bit = get_ind_bit(adapter_int->summary_addr,
-			  adapter_int->summary_offset, adapter->swap);
-	summary_set = test_and_set_bit(bit, map);
-	mark_page_dirty(kvm, adapter_int->summary_gaddr >> PAGE_SHIFT);
-	set_page_dirty_lock(summary_page);
-	srcu_read_unlock(&kvm->srcu, idx);
-
-	put_page(ind_page);
-	put_page(summary_page);
+		summary_page = get_map_page(kvm, adapter_int->summary_addr);
+		if (!summary_page) {
+			put_page(ind_page);
+			return -1;
+		}
+		idx = srcu_read_lock(&kvm->srcu);
+		map = page_address(summary_page);
+		bit = get_ind_bit(adapter_int->summary_addr,
+				  adapter_int->summary_offset, adapter->swap);
+		summary_set = test_and_set_bit(bit, map);
+		mark_page_dirty(kvm, adapter_int->summary_gaddr >> PAGE_SHIFT);
+		set_page_dirty_lock(summary_page);
+		srcu_read_unlock(&kvm->srcu, idx);
+	} else {
+		map = page_address(summary_info->page);
+		bit = get_ind_bit(summary_info->addr, adapter_int->summary_offset,
+				  adapter->swap);
+		summary_set = test_and_set_bit(bit, map);
+}
+
+	if (!ind_info)
+		put_page(ind_page);
+	if (!summary_info)
+		put_page(summary_page);
 	return summary_set ? 0 : 1;
 }
 
@@ -2892,7 +2925,9 @@ static int set_adapter_int(struct kvm_kernel_irq_routing_entry *e,
 	adapter = get_io_adapter(kvm, e->adapter.adapter_id);
 	if (!adapter)
 		return -1;
+	down_read(&adapter->maps_lock);
 	ret = adapter_indicators_set(kvm, adapter, &e->adapter);
+	up_read(&adapter->maps_lock);
 	if ((ret > 0) && !adapter->masked) {
 		ret = kvm_s390_inject_airq(kvm, adapter);
 		if (ret == 0)
-- 
2.52.0


