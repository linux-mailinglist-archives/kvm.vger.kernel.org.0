Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0659346645B
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 14:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358200AbhLBNPl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 08:15:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45020 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358285AbhLBNPQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 08:15:16 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2ArSkQ012723;
        Thu, 2 Dec 2021 13:11:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=CXiRJqvA8YBaqB/qDp3UuyUAyVQ8eyUzpKhj4I1PyuE=;
 b=gLS102+OiNl4fBk8ZMRyhrw4QfPXhl6pZhauAhExWhZd7RGhxWcdspcVL1yRkWAbUjvr
 qGU03uJyjl2hSRYj0Pb1N8L9oi08tgxPy6Ar8vbdtj3nJ4U5FSvAgWMPcobi0aek/2//
 vOgLw18cje12lnG32+v3ZRRWeYayIao29pWS9z+wOgGPPZ0OxnaJNsMKYAILxlnctvp8
 Cx6eM90xfT1CG2+YekcDMNArcw0OYcJHQbGOrxrbx6RTBFEn+9LPtCl5SSvd12SK85S5
 MBjCZ7q6K7Yr1F6RNgU7ddvNMxza2Qx4j96I7Ujxj0m3+TrcnPo7Z/4o3sKq4RljrasW Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cpvssarur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 13:11:52 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B2CijIq025078;
        Thu, 2 Dec 2021 13:11:52 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cpvssaru5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 13:11:52 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B2D3Rix023034;
        Thu, 2 Dec 2021 13:11:49 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3cncgms0d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 13:11:49 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B2DBkW912648838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Dec 2021 13:11:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B928642049;
        Thu,  2 Dec 2021 13:11:46 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCE1C4204B;
        Thu,  2 Dec 2021 13:11:45 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Dec 2021 13:11:45 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH] s390x: uv: Fix UVC cmd prepare reset name
Date:   Thu,  2 Dec 2021 13:11:22 +0000
Message-Id: <20211202131122.2948-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gIvIpsGV_0wlNJWd5L_Imu07K24KbRvp
X-Proofpoint-ORIG-GUID: SPg4Wvpk_uRRdF30T5d2nhQ6ZrIM469k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-12-02_07,2021-12-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=887 mlxscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112020084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The specification and the kernel use UVC_CMD_PREPARE_RESET so let's
fix our naming up.

The call bit is named correctly but is not the same as the name we use
on KVM. So let's clear that up too.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/uv.h | 4 ++--
 s390x/uv-guest.c   | 2 +-
 s390x/uv-host.c    | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 97c90e81..70bf65c4 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -39,7 +39,7 @@
 #define UVC_CMD_VERIFY_IMG		0x0302
 #define UVC_CMD_CPU_RESET		0x0310
 #define UVC_CMD_CPU_RESET_INITIAL	0x0311
-#define UVC_CMD_PERF_CONF_CLEAR_RESET	0x0320
+#define UVC_CMD_PREPARE_RESET		0x0320
 #define UVC_CMD_CPU_RESET_CLEAR		0x0321
 #define UVC_CMD_CPU_SET_STATE		0x0330
 #define UVC_CMD_SET_UNSHARED_ALL	0x0340
@@ -66,7 +66,7 @@ enum uv_cmds_inst {
 	BIT_UVC_CMD_CPU_RESET = 15,
 	BIT_UVC_CMD_CPU_RESET_INITIAL = 16,
 	BIT_UVC_CMD_CPU_SET_STATE = 17,
-	BIT_UVC_CMD_PREPARE_CLEAR_RESET = 18,
+	BIT_UVC_CMD_PREPARE_RESET = 18,
 	BIT_UVC_CMD_CPU_PERFORM_CLEAR_RESET = 19,
 	BIT_UVC_CMD_UNSHARE_ALL = 20,
 	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index 44ad2154..99120cae 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -142,7 +142,7 @@ static struct {
 	{ "verify", UVC_CMD_VERIFY_IMG, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_VERIFY_IMG },
 	{ "cpu reset", UVC_CMD_CPU_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_RESET },
 	{ "cpu initial reset", UVC_CMD_CPU_RESET_INITIAL, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_RESET_INITIAL },
-	{ "conf clear reset", UVC_CMD_PERF_CONF_CLEAR_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_PREPARE_CLEAR_RESET },
+	{ "prepare clear reset", UVC_CMD_PREPARE_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_PREPARE_RESET },
 	{ "cpu clear reset", UVC_CMD_CPU_RESET_CLEAR, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_PERFORM_CLEAR_RESET },
 	{ "cpu set state", UVC_CMD_CPU_SET_STATE, sizeof(struct uv_cb_cpu_set_state), BIT_UVC_CMD_CPU_SET_STATE },
 	{ "pin shared", UVC_CMD_PIN_PAGE_SHARED, sizeof(struct uv_cb_cfs), BIT_UVC_CMD_PIN_PAGE_SHARED },
diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 92a41069..de2e4850 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -55,7 +55,7 @@ static struct cmd_list cmds[] = {
 	{ "verify", UVC_CMD_VERIFY_IMG, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_VERIFY_IMG },
 	{ "cpu reset", UVC_CMD_CPU_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_RESET },
 	{ "cpu initial reset", UVC_CMD_CPU_RESET_INITIAL, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_RESET_INITIAL },
-	{ "conf clear reset", UVC_CMD_PERF_CONF_CLEAR_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_PREPARE_CLEAR_RESET },
+	{ "conf clear reset", UVC_CMD_PREPARE_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_PREPARE_RESET },
 	{ "cpu clear reset", UVC_CMD_CPU_RESET_CLEAR, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_PERFORM_CLEAR_RESET },
 	{ "cpu set state", UVC_CMD_CPU_SET_STATE, sizeof(struct uv_cb_cpu_set_state), BIT_UVC_CMD_CPU_SET_STATE },
 	{ "pin shared", UVC_CMD_PIN_PAGE_SHARED, sizeof(struct uv_cb_cfs), BIT_UVC_CMD_PIN_PAGE_SHARED },
-- 
2.32.0

