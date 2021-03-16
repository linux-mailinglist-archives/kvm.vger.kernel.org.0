Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C2133D07C
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 10:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236009AbhCPJUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 05:20:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4746 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235959AbhCPJUM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 05:20:12 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G95Bxe097874;
        Tue, 16 Mar 2021 05:20:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wsP2ILw6mQ9QxIkV5PY3vW/1ExFI16X2vTFM7Z2Skj8=;
 b=qyi9jUVz5bJHErI86FLh7r16Nrmf8tSqW0kwVK+Mc8Y6ogQfaAA30YgMQHwmY9o+MW+4
 jCwMHfwyXQ91Zta+SIEckkXVvVXKiPr/77NtUbdTQ1uEJO7FYzjZjtG/NQCytqqPnxTO
 aFGE8bk+YFJjCVTdsU4tLrDhEY/81R+D2e747z//bWIrk3c6zCGI4JzSYipId8DXqRpB
 25GfctAIe8yZUQBTRhkA1sTlyzgZ00tCOo5L2XWRdZE/S9eqpiTvRAszCce3Gj9z5xa0
 GW57EShv5rL18J8Z5qiUw9Ldak9S5YqfHg12Ax3Tp7IosFgg71yKABgHu9u89Q4MCi1z FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37ap24x74p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 05:20:11 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12G95Vbl099469;
        Tue, 16 Mar 2021 05:20:11 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37ap24x73s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 05:20:11 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12G9CBVd020014;
        Tue, 16 Mar 2021 09:20:09 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 378n18jnrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 09:20:09 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12G9K7eV62914820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 09:20:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9EA34C040;
        Tue, 16 Mar 2021 09:20:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47A824C044;
        Tue, 16 Mar 2021 09:20:05 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.146.129])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Mar 2021 09:20:05 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 5/6] s390x: uv-guest: Test invalid commands
Date:   Tue, 16 Mar 2021 09:16:53 +0000
Message-Id: <20210316091654.1646-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210316091654.1646-1-frankja@linux.ibm.com>
References: <20210316091654.1646-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_03:2021-03-15,2021-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's check if the commands that are not indicated as available
produce a invalid command error.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-guest.c | 44 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index 8915b2f1..517e3c66 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -120,16 +120,46 @@ static void test_sharing(void)
 	report_prefix_pop();
 }
 
+static struct {
+	const char *name;
+	uint16_t cmd;
+	uint16_t len;
+} invalid_cmds[] = {
+	{ "bogus", 0x4242, sizeof(struct uv_cb_header) },
+	{ "init", UVC_CMD_INIT_UV, sizeof(struct uv_cb_init) },
+	{ "create conf", UVC_CMD_CREATE_SEC_CONF, sizeof(struct uv_cb_cgc) },
+	{ "destroy conf", UVC_CMD_DESTROY_SEC_CONF, sizeof(struct uv_cb_nodata) },
+	{ "create cpu", UVC_CMD_CREATE_SEC_CPU, sizeof(struct uv_cb_csc) },
+	{ "destroy cpu", UVC_CMD_DESTROY_SEC_CPU, sizeof(struct uv_cb_nodata) },
+	{ "conv to", UVC_CMD_CONV_TO_SEC_STOR, sizeof(struct uv_cb_cts) },
+	{ "conv from", UVC_CMD_CONV_FROM_SEC_STOR, sizeof(struct uv_cb_cfs) },
+	{ "set sec conf", UVC_CMD_SET_SEC_CONF_PARAMS, sizeof(struct uv_cb_ssc) },
+	{ "unpack", UVC_CMD_UNPACK_IMG, sizeof(struct uv_cb_unp) },
+	{ "verify", UVC_CMD_VERIFY_IMG, sizeof(struct uv_cb_nodata) },
+	{ "cpu reset", UVC_CMD_CPU_RESET, sizeof(struct uv_cb_nodata) },
+	{ "cpu initial reset", UVC_CMD_CPU_RESET_INITIAL, sizeof(struct uv_cb_nodata) },
+	{ "conf clear reset", UVC_CMD_PERF_CONF_CLEAR_RESET, sizeof(struct uv_cb_nodata) },
+	{ "cpu clear reset", UVC_CMD_CPU_RESET_CLEAR, sizeof(struct uv_cb_nodata) },
+	{ "cpu set state", UVC_CMD_CPU_SET_STATE, sizeof(struct uv_cb_cpu_set_state) },
+	{ "pin shared", UVC_CMD_PIN_PAGE_SHARED, sizeof(struct uv_cb_cfs) },
+	{ "unpin shared", UVC_CMD_UNPIN_PAGE_SHARED, sizeof(struct uv_cb_cts) },
+	{ NULL, 0, 0 },
+};
+
 static void test_invalid(void)
 {
-	struct uv_cb_header uvcb = {
-		.len = 16,
-		.cmd = 0x4242,
-	};
-	int cc;
+	struct uv_cb_header *hdr = (void *)page;
+	int cc, i;
 
-	cc = uv_call(0, (u64)&uvcb);
-	report(cc == 1 && uvcb.rc == UVC_RC_INV_CMD, "invalid command");
+	report_prefix_push("invalid");
+	for (i = 0; invalid_cmds[i].name; i++) {
+		hdr->cmd = invalid_cmds[i].cmd;
+		hdr->len = invalid_cmds[i].len;
+		cc = uv_call(0, (u64)hdr);
+		report(cc == 1 && hdr->rc == UVC_RC_INV_CMD, "%s",
+		       invalid_cmds[i].name);
+	}
+	report_prefix_pop();
 }
 
 int main(void)
-- 
2.27.0

