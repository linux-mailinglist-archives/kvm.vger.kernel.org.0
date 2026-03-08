Return-Path: <kvm+bounces-73235-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GPn8Cp/nrGlSvwEAu9opvQ
	(envelope-from <kvm+bounces-73235-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 04:06:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 89A1522E62B
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 04:06:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3BD49304C979
	for <lists+kvm@lfdr.de>; Sun,  8 Mar 2026 03:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7D3933C18B;
	Sun,  8 Mar 2026 03:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iIZCtYRt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D409A34CFA8;
	Sun,  8 Mar 2026 03:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772939095; cv=none; b=mUDx/duGl9ToMBTeAByUpsjAszzldeoIYtHIbL9xWL4bxNUUkn1E1fVq0PQrsXubVJ3cJJQXYcuiQyYbV3fI36BkPtq18Ejrvuks1FAk4fo5N/Ve1rlmm+zGHxiQfX+vOmS/QjzItcPDGHJkvqi8nChLbm7lM5B/CyUXLKVzjfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772939095; c=relaxed/simple;
	bh=7GjgvqVmSACa2QowM59qB6+NnCtrR+bGLR+xYbbygzc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OXVxpLJ2VRabeRSOAb149rsFaM42uqFbz3dgMdGKt82zw5OGSTzoOWxBFdSbhGu+kAhM3yJM6NC5XHM3kVvuWfJL7d14znj0/uMroAY0jKyIgefGQ2bhpzu7/BE1eixvWP9LKmmbb/J9v2TAJoREj+w2v1VoVvkm56YnYJNup6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iIZCtYRt; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6282h3Tk3538549;
	Sun, 8 Mar 2026 03:04:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=29A7ERB6mj0LdZcejFrOTdbEPOrSYGSSa1q6uO6uO
	GQ=; b=iIZCtYRtKOLxLgq9tJ4+j3EyrDaN6jTJ18NsRpoJKpQ0X60fHwmhcILaY
	RQJtY0KVTB9sCnlgVkP8vavcxWrpK+D7Lj+xzaXpzSlnV2MNSoPiq1zvvN2w7uAT
	T0MHdvPs6yG8WnHpWWmiA4177fN//HXinP5BDwBpRY7cyLBA0sqMxzqpCtNOayLf
	NTciKmQLKV3C1okGo4gk+YORqgZRazlAluqn+BFk1fRUGxjNHBcJ9wpef9yE/kkE
	e/HrTGONzah/fL8JtgkM/DlMU4J/41ilLczwu74p/2IrWUAB3v9g2hF2uG1akJAU
	1HjskIPP7amzUHcDvO/sViw9ZZyng==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcyw2jte-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 03:04:44 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6281JNik015608;
	Sun, 8 Mar 2026 03:04:43 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4crybn07fd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 03:04:43 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62834gco1901130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 8 Mar 2026 03:04:42 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6C5CF58058;
	Sun,  8 Mar 2026 03:04:42 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A322658057;
	Sun,  8 Mar 2026 03:04:41 +0000 (GMT)
Received: from 9.60.13.83 (unknown [9.60.13.83])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sun,  8 Mar 2026 03:04:41 +0000 (GMT)
From: Douglas Freimuth <freimuth@linux.ibm.com>
To: borntraeger@linux.ibm.com, imbrenda@linux.ibm.com, frankja@linux.ibm.com,
        david@kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mjrosato@linux.ibm.com, freimuth@linux.ibm.com
Subject: [PATCH v1 0/3] KVM: s390: Introducing kvm_arch_set_irq_inatomic Fast Inject 
Date: Sun,  8 Mar 2026 04:04:35 +0100
Message-ID: <20260308030438.88580-1-freimuth@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA4MDAyNiBTYWx0ZWRfX4ehCHuUWWbb7
 NeWiys51AWs7OqQyDyJhiQxClZD+5V4eqe76xcszCMBpQw652LqA5+Le3o/mExdbrNSOOTdRRKC
 ZqwIvjRz8U6nkCe+oPpxPiDNYvApHatne063UASaZC3N88eF84TD8l8y6PkwyE97Az9uksPr8Tc
 kz0sQQGhTy5TsMPgzaLTdITAtPRnzjdB2mUOsRc5/a23MN9jGJJJuuiTF/RuzBi3Np0w0EV/yww
 hw9b/NBFE/jtxFSVxpfV39TP2lj0M64VoVMlvPdK4if/5HBYSZEpSamgmYjDOU21K7JPrFIOO63
 sm8hAMagqp3Yh9VIyMGNdegy10o9u+X3Jzu0psrYwH4pWOpMCEL/3i9HuUtE8WN8h6VP30cXpJ2
 Vwgo2vJiGfgaRpZRfdAGJOZcbphntT+k4YCtRHOgM+BVxm2IcS8cPCKoDGAg78slPLmbHYIckE3
 GQloDQ9hRhWo21lGLfA==
X-Authority-Analysis: v=2.4 cv=QaVrf8bv c=1 sm=1 tr=0 ts=69ace74c cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=wD_hlsRMxFZvc_XlLqQA:9
X-Proofpoint-GUID: 9cei63pLjFDzkHpODIUkXDN0rofQZA7c
X-Proofpoint-ORIG-GUID: 9cei63pLjFDzkHpODIUkXDN0rofQZA7c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-08_01,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 impostorscore=0 clxscore=1011 adultscore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603080026
X-Rspamd-Queue-Id: 89A1522E62B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	SUBJECT_ENDS_SPACES(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	TAGGED_FROM(0.00)[bounces-73235-lists,kvm=lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[freimuth@linux.ibm.com,kvm@vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.989];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

This series of three patches enables a non-blocking path for irqfd injection on s390
via kvm_arch_set_irq_inatomic(). Before these changes, kvm_arch_set_irq_inatomic()
would just return -EWOULDBLOCK and place all interrupts on the global
work queue, which must subsequently be processed by a different
thread. This series of patches implements an s390 version of inatomic
and is relevant to virtio-blk and virtio-net and was tested against
virtio-pci and virtio-ccw. To properly test this kernel series with virtio-pci,
a QEMU that includes the 's390x/pci: set kvm_msi_via_irqfd_allowed' fix is needed.
Statistical counters have been added to enable analysis of irq injection on
the fast path and slow path including io_390_inatomic,
io_flic_inject_airq, io_set_adapter_int and io_390_inatomic_adapter_masked. And
counters have been added to analyze map/unmap of the adapter_indicator
pages in non-Secure Execution environments and to track fencing of Fast
Inject in Secure Execution environments.

The inatomic fast path cannot lose control since it is running with
interrupts disabled. This meant making the following changes that exist on the slow
path today. First, the adapter_indicators page needs to be mapped since it
is accessed with interrupts disabled, so we added map/unmap
functions. Second, access to shared resources between the fast and slow paths
needed to be changed from mutex and semaphores to a spin_lock. Finally, the memory
allocation on the slow path utilizes GFP_KERNEL_ACCOUNT but we had to
implement the fast path with GFP_ATOMIC allocation. Each of these
enhancements were required to prevent blocking on the fast inject path.

Patch 1 enables fencing of Fast Injection in Secure Execution
environments by not mapping adapter indicator pages and relying on the
path of execution available prior to this patch.


Douglas Freimuth (3):
  Add map/unmap ioctl and clean mappings post-guest
  Enable adapter_indicators_set to use mapped pages
  Introducing kvm_arch_set_irq_inatomic fast inject

 arch/s390/include/asm/kvm_host.h |  11 +-
 arch/s390/kvm/interrupt.c        | 365 +++++++++++++++++++++++++------
 arch/s390/kvm/kvm-s390.c         |  26 ++-
 arch/s390/kvm/kvm-s390.h         |   3 +-
 4 files changed, 337 insertions(+), 68 deletions(-)

-- 
2.52.0


