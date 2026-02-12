Return-Path: <kvm+bounces-70957-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0IT/FKLdjWna8AAAu9opvQ
	(envelope-from <kvm+bounces-70957-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:03:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A2A8712E133
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:03:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CFC45302B312
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:02:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54FBD35CBA5;
	Thu, 12 Feb 2026 14:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CCUQ5n2l"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0BA3EBF1F;
	Thu, 12 Feb 2026 14:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770904963; cv=none; b=JIwojIOcu71OikXjbH7w2UEb5s6NWHICTmtp2olCGgnX8VEH1Vv80O+/DhRLixbTgkqA/uTzBKV/nErqSk1m0VQCCUY5nOvrvInQWybOjuvmu8qXIzMYsXa7Ca36tVNCTXM0Wg4cCgabjNpP8D6xlhv0Qg/0cnPWeb0IjM0TYHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770904963; c=relaxed/simple;
	bh=WnXhNfLpqjSOq+iWjqkyu0u0NnRxDWcyWCEJv5L6yV4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=h6lKqhSQPjc5w+TNrDmfaEyXM4clXBzcAD4ybbLIOnxgrCZ3eEvRY7KaH4SZNGHB2GSHN7WWfovf5ZaKHWYGJkp8vlaCsta83cAndofI+hiYYx/SZwwKA9Z+qNWNwSddEfhxtvif9GYYnpRmIfbepLbsOZta0bWF8tM405YXvA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CCUQ5n2l; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61C99BEw528536;
	Thu, 12 Feb 2026 14:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=z9KnT6kiiqTL9pUGcsbZCQDdcvpr
	tBVFKD35eynel1Y=; b=CCUQ5n2lSuPid4QHdwiNNQX7Nx5SblJhqPJxnqjUefTN
	lewfuQEhY1pxpGnvqzUBXhFGZfehZ4xWzV+xjt1Boq6BMSM9QU76tQkdU9/dANQ7
	hSqe/FHTcNcOYt9hy5onwUYGgHKrPuPPdNaFBMzJTQNvXKkRlZUSFaHs6xySaRCl
	QXx6bMdKFmsBtJCibtU7r7SmvM2Ns4BlhZrdPe5+Rdjn2t93dy43JkaxzBt6vWNb
	1rqe2Evaq5TeOlmH7XULF40ID5uPkKDzQNDTaCw1yZzJKJtJc3S9QpD/r9iIKnkd
	0tJeLeyLddCFHfUS/zB+MjaPKrRThI5VvP1vzpXXVQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696upg2d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 14:02:36 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61C9XZPt012616;
	Thu, 12 Feb 2026 14:02:35 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6h7kjjcu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 14:02:35 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61CE2UKi52035890
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Feb 2026 14:02:30 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AFCC72004B;
	Thu, 12 Feb 2026 14:02:30 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 69E5F20065;
	Thu, 12 Feb 2026 14:02:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Feb 2026 14:02:30 +0000 (GMT)
From: Julian Ruess <julianr@linux.ibm.com>
Subject: [PATCH 0/3] vfio/pci: Introduce vfio_pci driver for ISM devices
Date: Thu, 12 Feb 2026 15:02:14 +0100
Message-Id: <20260212-vfio_pci_ism-v1-0-333262ade074@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAGbdjWkC/33QTWrDMBAF4KsEreugGUkjKaveo5Sg30ZQ28FuT
 Urw3StnU9c1Xb4H8/GYOxvTUNLIToc7G9JUxtJ3NcDTgYWL695SU2LNDDkqjqibKZf+fA3lXMa
 24SEETFIjSs3qyXVIudwe3MtrzZcyfvTD10OfcGkXiDiA+g1N2PAmkBOZFKkI4vm9dJ+3Y/HtM
 fQtW7BJrAG7AUQFIESA6BLXPO4BcgWg2AByWeBNFtqhRW/2ALUGtgtUBXQmq52QXjrYA+gHQE4
 bgCoQo9VCcktJ2z1A/wfoCkjyRsbsyELaA8wKANgApgJKSe6C9Wj+PnGe529gKQI7MgIAAA==
X-Change-ID: 20250227-vfio_pci_ism-0ccc2e472247
To: schnelle@linux.ibm.com, wintera@linux.ibm.com, ts@linux.ibm.com,
        oberpar@linux.ibm.com, gbayer@linux.ibm.com,
        Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <skolothumtho@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Cc: mjrosato@linux.ibm.com, alifm@linux.ibm.com, raspl@linux.ibm.com,
        hca@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        julianr@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-pci@vger.kernel.org
X-Mailer: b4 0.14.2
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=KZnfcAYD c=1 sm=1 tr=0 ts=698ddd7c cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=buv0j8F9Xdj7ltUxVnMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEyMDEwNCBTYWx0ZWRfXzPCKsCWULGJ3
 EKlB9jnIEOFwXVSQFRRSR0ycYcB8HBsXIxba515f6hzOsJ3H27dZpVyCp3FT36NcdKe3Wy1NNH/
 hL96aqAVEKtSfoAxFg+Lt+YeWJqYNIY7PBNMI1KP7TGT943oPtPlYXljgwTpCPimVnXTxUcydN5
 FbAeGwDU44+RzQmxt4/TwD0uLfXLVQDn9D67o6cAGJoZFJCxUFpi1qIaUxqpKIiewKdvvVoZWfG
 uv+5FTt8ewY3Qq7ONQ1bNYR62Ov1/3WHFnLRmub5Vcam7EuDDLnUjcOwD+eXcUZKCEGGskOpKyt
 LAlbgBUleN2cOsxiFR//ibcjQxd8DUymXpGP7I/VkhaeJBbC3r+K1JSnGHpxkPLuHHigZbCeEfC
 N22fxoLRthluRsoADETKXODSG015Rp89q10ZWDDVUDymsR8RaveakpgmRTwdv7ua1kw6+0qpAuN
 xjzSDeJE0+KVHB8w4gA==
X-Proofpoint-ORIG-GUID: E6uP3_QtvQIhaO-aBG1j4w1DthdtX17k
X-Proofpoint-GUID: E6uP3_QtvQIhaO-aBG1j4w1DthdtX17k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-12_04,2026-02-12_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602120104
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,linux.ibm.com:mid];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[julianr@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70957-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[ibm.com:+]
X-Rspamd-Queue-Id: A2A8712E133
X-Rspamd-Action: no action

Hi all,

This series adds a vfio_pci variant driver for the s390-specific
Internal Shared Memory (ISM) devices used for inter-VM communication
including SMC-D.

This is a prerequisite for an in-development open-source user space
driver stack that will allow to use ISM devices to provide remote
console and block device functionality. This stack will be part of
s390-tools.

This driver would also allow QEMU to mediate access to an ISM device,
enabling a form of PCI pass‑through even for guests whose hardware
cannot directly execute PCI accesses, such as nested guests.

On s390, kernel primitives such as ioread() and iowrite() are switched
over from function handle based PCI load/stores instructions to PCI
memory-I/O (MIO) loads/stores when these are available and not
explicitly disabled. Since these instructions cannot be used with ISM
devices, ensure that classic function handle-based PCI instructions are
used instead.

The driver is still required even when MIO instructions are disabled, as
the ISM device relies on the PCI store‑block (PCISTB) instruction to
perform write operations.

Thank you,
Julian

Signed-off-by: Julian Ruess <julianr@linux.ibm.com>
---
Julian Ruess (3):
      vfio/pci: Set VFIO_PCI_OFFSET_SHIFT to 48
      vfio/ism: Implement vfio_pci driver for ISM devices
      MAINTAINERS: add VFIO ISM PCI DRIVER section

 MAINTAINERS                        |   6 +
 drivers/vfio/pci/Kconfig           |   2 +
 drivers/vfio/pci/Makefile          |   2 +
 drivers/vfio/pci/ism/Kconfig       |  11 ++
 drivers/vfio/pci/ism/Makefile      |   3 +
 drivers/vfio/pci/ism/main.c        | 227 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_config.c |   1 +
 drivers/vfio/pci/vfio_pci_core.c   |   4 +-
 include/linux/vfio_pci_core.h      |   2 +-
 9 files changed, 255 insertions(+), 3 deletions(-)
---
base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
change-id: 20250227-vfio_pci_ism-0ccc2e472247

Best regards,
-- 
Julian Ruess <julianr@linux.ibm.com>


