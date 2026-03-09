Return-Path: <kvm+bounces-73343-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cJh8B+4Ir2lzMQIAu9opvQ
	(envelope-from <kvm+bounces-73343-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:52:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F39423DFD2
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:52:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 207AA3015EFA
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 17:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD7083033CF;
	Mon,  9 Mar 2026 17:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b="D1XZMIpw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [67.231.157.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885B327467F;
	Mon,  9 Mar 2026 17:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.157.127
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773078715; cv=none; b=cQxjRaEyfwQaR1o1vMAP++Fex7tMZqnaLJdP5CAQcTgbGISanRffKKtNusRiydKwGYS2z7ZR2f62qhKFwGRAjb0fz0v42gjlE++WyrZIJHuGKM0OyR0DzPaEbVfbyizVAlLdcu3HT22uyX1O6V3aPxLQ9hcDh/VriEyB9fBoI7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773078715; c=relaxed/simple;
	bh=/oVcgpjDCbeZgFSpONH2HMRzmff3VmOq0t9gHb3lOGA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YGbOkqtv5lrkiWHju7P3cU7EDFhuiuyNCQ4Br0q3qEZC/6p+bSHVM7+uqUvwKQvdGiWuyCjMmlUgx2mWPMKdrCRnV+NP0awJM2suuWU5eZ1OpqsyvhoBhG6ABbH9CLKVbikR2CBH3BXpZpuA2OKkMfkeymEUVG3sl4qZ1ihQ4QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com; spf=pass smtp.mailfrom=akamai.com; dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b=D1XZMIpw; arc=none smtp.client-ip=67.231.157.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=akamai.com
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
	by mx0b-00190b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629HU2Kt798477;
	Mon, 9 Mar 2026 17:51:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=jan2016.eng; bh=3Fzs8McvxZarCfglw/7QEh51lw3Bd2bcG
	Arr5kH+tRY=; b=D1XZMIpwzaOmYREaSH3Dlessz7Ul1IH3WcSYPXRP4OnkDqq/V
	LBadjtzMuDz4zfS5Rjy4RiyMz4QQlJvhZaq6IIT8E4XSEH+YoBaut2beVJ+5KZaN
	0v88L1JV+YwF+zOVtEJOgrBdlAGDDCdi0HZFZMRPYUVeWa1+MYI408gkqDwREWg8
	RxSj0N0bW6mhmw4drsN3hmmF+eFcxRFYaLpX3N7pMJB/sSKFR6/ku0WM++dbI71L
	FqeapcM+Z5tno9GBps3Q3tNSSbBbi10tLxBCiEvNnRz1tgY+Kgj8QINxLwEBH2h6
	WZCpIWPFyopihI6Kd2pfztNv4lV/nztdULYlg==
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61])
	by mx0b-00190b01.pphosted.com (PPS) with ESMTPS id 4cr9rusqd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 17:51:30 +0000 (GMT)
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
	by prod-mail-ppoint6.akamai.com (8.18.1.7/8.18.1.7) with ESMTP id 629Hmvqu012722;
	Mon, 9 Mar 2026 13:51:29 -0400
Received: from prod-mail-relay01.akamai.com ([172.27.118.31])
	by prod-mail-ppoint6.akamai.com (PPS) with ESMTP id 4crg7yh65d-1;
	Mon, 09 Mar 2026 13:51:29 -0400 (EDT)
Received: from muc-lhv4ep.munich.corp.akamai.com (muc-lhv4ep.munich.corp.akamai.com [172.29.0.215])
	by prod-mail-relay01.akamai.com (Postfix) with ESMTP id 4DB0884;
	Mon,  9 Mar 2026 17:51:27 +0000 (UTC)
From: Max Boone <mboone@akamai.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alex Williamson <alex@shazbot.org>, linux-mm@kvack.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Tottenham <mtottenh@akamai.com>, Josh Hunt <johunt@akamai.com>,
        Matt Pelland <mpelland@akamai.com>, Max Boone <mboone@akamai.com>
Subject: [RFC 0/1] Avoid pagewalk hugepage-split race with VFIO DMA set
Date: Mon,  9 Mar 2026 18:49:48 +0100
Message-ID: <20260309174949.2514565-1-mboone@akamai.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 bulkscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2602130000 definitions=main-2603090160
X-Proofpoint-GUID: IhDo1xtWvIeZ4ATgEP8gNVTxpFnVSGBT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDE2MSBTYWx0ZWRfX/lr2FHIN3A+v
 vJliNDnFOhJWINlIYOMTsCNJ7gEreHOQbFgd6kjziVC3Agmmao1XbS5GfADbRtB4uc6SrY9kbBn
 I1/+HwezjCBTftihehhRx1jzjzmxTrU7HvQRrTlfXfzepZwy+WGIyTufk971bfd13v9jdTMccpc
 3Zzm1qMG/fujlFmHsCe1+EkWXaA0k02mmOoXJkEUoT08izxe2drrYjX84El2/gAleR3nFKprFym
 EnTAwcPo1DYkWD3U6KQ0xS50fdrUKa9jVnuY7cd77RA0lB7fH5PelvvgPKfPzUkQemDUp3FNLUX
 l57OY0NLoFWKHJDeacDj14p7xvSrfBGNvUCFjVZadBUvqDpdJizqvzOn9qabeIMaC7cpj2sC1Uz
 wbnVrfPr4N+Rd2wITAXhO/JGfxzvUvQv+X0atPNMmWQ8RdEEp/RMCxYSPDGdzDSGD4vaPA2Bdzh
 eoYAkZcN9rXe7vDfHdQ==
X-Proofpoint-ORIG-GUID: IhDo1xtWvIeZ4ATgEP8gNVTxpFnVSGBT
X-Authority-Analysis: v=2.4 cv=Wuwm8Nfv c=1 sm=1 tr=0 ts=69af08a2 cx=c_pps
 a=WPLAOKU3JHlOa4eSsQmUFQ==:117 a=WPLAOKU3JHlOa4eSsQmUFQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Ifg-1AOnLHOf1gn6spyb:22
 a=VcQvXEo1OZcA_IiPcy3B:22 a=NEAV23lmAAAA:8 a=X7Ea-ya5AAAA:8
 a=J3MF52ijxDzPJOGfDI8A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 clxscore=1011 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603090161
X-Rspamd-Queue-Id: 3F39423DFD2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[akamai.com,quarantine];
	R_DKIM_ALLOW(-0.20)[akamai.com:s=jan2016.eng];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[16];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73343-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[akamai.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mboone@akamai.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[akamai.com:dkim,akamai.com:email,akamai.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Action: no action

A kernel BUG can be triggered when /proc/$PID/numa_maps reads are
hammered by one process, while said $PID is setting up DMA for large
1G-aligned memory mapped BARs.

The 1G-aligned memory mapped BARs get set up as PUD-order PFNMAPs. When
the generic page walker (mm/pagewalk.c) gets to the PUD table entry of
the memory mapped BAR in the walk_pmd_range function, it tries to
split it by:

1. deleting the PUD entry by calling split_huge_pud
2. checking whether `pud_none` is true to go to `again`

		if (walk->vma)
			split_huge_pud(walk->vma, pud, addr);
		...
		if (pud_none(*pud))
			goto again;

3. if has_install is set, it calls __pmd_alloc and further descends
into walk_pmd_range

again:
		next = pud_addr_end(addr, end);
		if (pud_none(*pud)) {
			if (has_install)
				err = __pmd_alloc(walk->mm, pud, addr);

When VFIO is setting up DMA, the PUD entry can get reinstalled between the
split_huge_pud call and the pud_none check to goto again. In such
case the walk continues to the PMD-level and an illegal read happens.

As a mitigation, I propose to skip splitting the PMD and PUD entries
that are marked as special in the walker, which are mappings that do not
wish to be associated with a "struct page". The only occurences of these
entries I found were the vfio pci and nvgrace pfnmap mappings, which do
not behave like regular memory.

For a reproduction, the `vfio-mmap-bar.py` script repeatedly DMA-maps a
1G-aligned BAR and can be used to reproduce this bug:
- https://github.com/akamaxb/repro-vfio-page-walk-race.git

Run the `vfio-mmap-bar.py` script with the device you want to passthrough,
and in the mean time, cat the `/proc/$PID/numa_maps` of that process repeatedly
in a while loop. This caused the `numa_maps` read to crash on an illegal read,
when testing it against a 128GB-sized 2nd BAR of a NVIDIA Blackwell 6000 GPU.

Signed-off-by: Max Boone <mboone@akamai.com>
Signed-off-by: Max Tottenham <mtottenh@akamai.com>

Max Boone (1):
  mm/pagewalk: don't split device-backed huge pfnmaps

 mm/pagewalk.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

-- 
2.34.1


