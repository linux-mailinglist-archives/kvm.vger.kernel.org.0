Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C96D490D0C
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241710AbiAQRAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:00:34 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34554 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241413AbiAQRAB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 12:00:01 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20HFwNnt016933
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 17:00:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=DuqlgOjS0gZfrbaoK+mNPGKl+6kkIyJpTmBc0wrMlmw=;
 b=NXo4F3ZrltFdoystL1L36D8oxVcyjC8J4O8wkxyJCmq9Ifj0TqOFfny7rq2G8HVqLlue
 CcXSylD6ATNCk4mKug44YWuHtx/bWd3d0upUTAos0GU8blm7T7dWWbyWxF9C48FGZVA4
 B2xwEKWwICwnzUfh2hj6VZDmGBRW0bnNf4JmOQrr/BzfpnWPoCQDJeBDh+T9g54BiBiH
 gmpqHrxShbyf/R4dZtdx7PTQESuWiPXw3ofZ/Wn5Wnz6xYVxVjo8f58xEkiE5uYCqAy6
 C7oDkaRhxKYapv3nrR6eZxkeF46KXRiR+6bzDe+SH7NfDoH/ifBi2FFQEkUQy9qEbZiC PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dnbjghjrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 17:00:00 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20HGYa8Z021926
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:59 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dnbjghjr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:59 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20HGl7Cx023316;
        Mon, 17 Jan 2022 16:59:58 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3dknw8n5wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:57 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20HGxqV238076836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 16:59:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A026A4054;
        Mon, 17 Jan 2022 16:59:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4416A405C;
        Mon, 17 Jan 2022 16:59:51 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.3.16])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 16:59:51 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 04/13] s390x: sie: Add UV information into VM struct
Date:   Mon, 17 Jan 2022 17:59:40 +0100
Message-Id: <20220117165949.75964-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220117165949.75964-1-imbrenda@linux.ibm.com>
References: <20220117165949.75964-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: utUL-GPc5_G7CUZAUlahono2HptSCWS7
X-Proofpoint-ORIG-GUID: rig1cHH9Ihx-Rs5S6J8qz0YcdP0DxvFR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=956
 malwarescore=0 adultscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201170104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

We need to save the handles for the VM and the VCPU so we can retrieve
them easily after their creation. Since the SIE lib is single guest
cpu only we only save one vcpu handle.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/sie.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index c6eb6441..1a12faa7 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -200,6 +200,11 @@ union {
 	uint64_t	gvrd;			/* 0x01f8 */
 } __attribute__((packed));
 
+struct vm_uv {
+	uint64_t vm_handle;
+	uint64_t vcpu_handle;
+};
+
 struct vm_save_regs {
 	uint64_t grs[16];
 	uint64_t fprs[16];
@@ -220,6 +225,7 @@ struct vm {
 	struct vm_save_area save_area;
 	void *sca;				/* System Control Area */
 	uint8_t *crycb;				/* Crypto Control Block */
+	struct vm_uv uv;			/* PV UV information */
 	/* Ptr to first guest page */
 	uint8_t *guest_mem;
 };
-- 
2.31.1

