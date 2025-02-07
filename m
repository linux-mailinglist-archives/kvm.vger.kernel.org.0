Return-Path: <kvm+bounces-37629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B197A2CBC6
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 19:45:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC4A57A767B
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 18:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 267811D8DE1;
	Fri,  7 Feb 2025 18:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SypMYZDU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEAB1A3161;
	Fri,  7 Feb 2025 18:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738953786; cv=none; b=aYnMXb0PYkKKQIlYEZZvh82FPk25tWhZUnfMCC7G8/SzFaj2QpUDspj3Or1g9y3az3BtJFXjjDllsOtJ9k2FDAetXukpjz8y5+0pNLU+ieuG/Us+XPictKg5uYQP+XepbKWgVldDg1dxv8HUFZTGE4KTGfN5dfb0dAo5061KP7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738953786; c=relaxed/simple;
	bh=9KcNunuYxOHLcipbsIYeWGmwHZWT2GJbR8DrZq+P0yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFvauGDgzf8dCNMWWJtP4ckOdAyCFQi8zfnk144pzMhRWvyr4o5vHUnSDkVjnffbYbbGY0DtxI5+WJKhPvGOJx2+PNXQlukwV6Ritnj4KVFSm9C2doXyp1cvaYtMhDXJoAIT5+pA7nHc71TKs153CvM7+/+BCp2IsQJyxZMSs7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SypMYZDU; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 517HfrVc009269;
	Fri, 7 Feb 2025 18:42:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=c5XwY
	UKc7W9La6YjGqr4UmbZPDEugwITEt8f/5aGINU=; b=SypMYZDU1G4qWTcGtsxFn
	Oom9xbEoDQVbaGATU5AV4YtiFasrnC0n0QTKurJymPnO6SuJy20FJjuV2ErxoW2O
	YKAL9dV+z4UYz2KP36QnoRLJjgE+6BGvjweVosgOkyKjRroSFB18KtHbVG5/ow6Y
	Xb4zNXhINhE2nbDpB+fmHwVtO04OFUN/qcIpX2gRRMuk2m3vyn+LJwEr/kWfCuV3
	fBn5Qg3gdoD6sp9VeoMPja24ssYRPxVySzbtiIAiSUojD2CL0iY2KmXh1Ekp5t1f
	smjV7t/9tFoEZlaFfc/gTqvDnIL0prBvYWffjvPl8hu1VG3tLwS/RsfsDcTtENKf
	A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44mwwpjqs5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 18:42:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 517HZEAs022663;
	Fri, 7 Feb 2025 18:42:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ec8686-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 18:42:57 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 517Idx9P037660;
	Fri, 7 Feb 2025 18:42:56 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44j8ec8665-4;
	Fri, 07 Feb 2025 18:42:56 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
        michael.christie@oracle.com, pbonzini@redhat.com, stefanha@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] vhost-scsi: cache log buffer in I/O queue vhost_scsi_cmd
Date: Fri,  7 Feb 2025 10:41:47 -0800
Message-ID: <20250207184212.20831-4-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250207184212.20831-1-dongli.zhang@oracle.com>
References: <20250207184212.20831-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-07_08,2025-02-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502070139
X-Proofpoint-ORIG-GUID: aRvRNdqrJq3lX0xQB3iyIbtwkC5CP6Bt
X-Proofpoint-GUID: aRvRNdqrJq3lX0xQB3iyIbtwkC5CP6Bt

The vhost-scsi I/O queue uses vhost_scsi_cmd. Pre-allocate the log buffer
during vhost_scsi_cmd allocation, and free it when vhost_scsi_cmd is
reclaimed.

The cached log buffer will be uses in upcoming patches to log write
descriptors for the I/O queue. The core idea is to cache the log in the
per-command log buffer in the submission path, and use them to log write
descriptors in the completion path.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/vhost/scsi.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index ee2310555740..5e6221cbbe9e 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -98,6 +98,11 @@ struct vhost_scsi_cmd {
 	unsigned char tvc_cdb[VHOST_SCSI_MAX_CDB_SIZE];
 	/* Sense buffer that will be mapped into outgoing status */
 	unsigned char tvc_sense_buf[TRANSPORT_SENSE_BUFFER];
+	/*
+	 * Dirty write descriptors of this command.
+	 */
+	struct vhost_log *tvc_log;
+	unsigned int tvc_log_num;
 	/* Completed commands list, serviced from vhost worker thread */
 	struct llist_node tvc_completion_list;
 	/* Used to track inflight cmd */
@@ -619,6 +624,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	struct vhost_scsi_nexus *tv_nexus;
 	struct scatterlist *sg, *prot_sg;
 	struct iovec *tvc_resp_iov;
+	struct vhost_log *log;
 	struct page **pages;
 	int tag;
 
@@ -639,6 +645,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	prot_sg = cmd->tvc_prot_sgl;
 	pages = cmd->tvc_upages;
 	tvc_resp_iov = cmd->tvc_resp_iov;
+	log = cmd->tvc_log;
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->tvc_sgl = sg;
 	cmd->tvc_prot_sgl = prot_sg;
@@ -652,6 +659,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 	cmd->tvc_nexus = tv_nexus;
 	cmd->inflight = vhost_scsi_get_inflight(vq);
 	cmd->tvc_resp_iov = tvc_resp_iov;
+	cmd->tvc_log = log;
 
 	memcpy(cmd->tvc_cdb, cdb, VHOST_SCSI_MAX_CDB_SIZE);
 
@@ -1604,6 +1612,7 @@ static void vhost_scsi_destroy_vq_cmds(struct vhost_virtqueue *vq)
 		kfree(tv_cmd->tvc_prot_sgl);
 		kfree(tv_cmd->tvc_upages);
 		kfree(tv_cmd->tvc_resp_iov);
+		kfree(tv_cmd->tvc_log);
 	}
 
 	sbitmap_free(&svq->scsi_tags);
@@ -1666,6 +1675,18 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 			pr_err("Unable to allocate tv_cmd->tvc_prot_sgl\n");
 			goto out;
 		}
+
+		/*
+		 * tv_cmd->tvc_log and vq->log need to have the same max
+		 * length.
+		 */
+		tv_cmd->tvc_log = kcalloc(vq->dev->iov_limit,
+					  sizeof(struct vhost_log),
+					  GFP_KERNEL);
+		if (!tv_cmd->tvc_log) {
+			pr_err("Unable to allocate tv_cmd->tvc_log\n");
+			goto out;
+		}
 	}
 	return 0;
 out:
-- 
2.39.3


