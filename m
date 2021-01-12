Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3F52F318A
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 14:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387419AbhALNWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 08:22:05 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24258 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728013AbhALNWE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 08:22:04 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CD38gL070725;
        Tue, 12 Jan 2021 08:21:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=nkSnNUEgUKkUATIS5FonmBlW7o2f0z9EiGoXERQttr0=;
 b=fBogf7mttiMothTH7CWd/5CXugI14q9XSvq5/DOlUG2sCJLgKy9ni3aSOMJysGCCmBpB
 QNdmfEomji9bsLQ1Nktv/IDw3DST1Lv5/54U2bLF/+SlX3wM26ytjnS8wpGDhBZCGJ5A
 wGQFQj1Bg9IAZfkHmv+2F9bM8MBKXINF8VpJ/E1Cqv6+T3cVKCaRWHkNzex9WZg9qiIl
 f4YB3Uij2bYyC+haRA2EAVQiHhj5NexY9BYl4pfggnHJiSoVNpxaPdB0UfKJkldcIIjG
 cZ3kZ+ObhrW+VIqwGfYiTOviSzkbrtCrBbPDI9BdP8eTPOqzMS+fQ0EYPdsjKFk23ZEW 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361c7b0k42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 08:21:22 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10CD3IHS074197;
        Tue, 12 Jan 2021 08:21:22 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361c7b0k35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 08:21:21 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CDGuYZ007461;
        Tue, 12 Jan 2021 13:21:19 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 35y4481vqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 13:21:19 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CDLGPf19661126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 13:21:16 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B77264C040;
        Tue, 12 Jan 2021 13:21:16 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F08174C046;
        Tue, 12 Jan 2021 13:21:15 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 13:21:15 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 8/9] s390x: Fix sclp.h style issues
Date:   Tue, 12 Jan 2021 08:20:53 -0500
Message-Id: <20210112132054.49756-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210112132054.49756-1-frankja@linux.ibm.com>
References: <20210112132054.49756-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_07:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 clxscore=1015 priorityscore=1501 spamscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix indentation

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/sclp.h | 172 +++++++++++++++++++++++------------------------
 1 file changed, 86 insertions(+), 86 deletions(-)

diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 58f8e54..dccbaa8 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -79,10 +79,10 @@
 #define SCCB_SIZE 4096
 
 typedef struct SCCBHeader {
-    uint16_t length;
-    uint8_t function_code;
-    uint8_t control_mask[3];
-    uint16_t response_code;
+	uint16_t length;
+	uint8_t function_code;
+	uint8_t control_mask[3];
+	uint16_t response_code;
 } __attribute__((packed)) SCCBHeader;
 
 #define SCCB_DATA_LEN (SCCB_SIZE - sizeof(SCCBHeader))
@@ -90,15 +90,15 @@ typedef struct SCCBHeader {
 
 /* CPU information */
 typedef struct CPUEntry {
-    uint8_t address;
-    uint8_t reserved0;
-    uint8_t : 4;
-    uint8_t feat_sief2 : 1;
-    uint8_t : 3;
-    uint8_t features_res2 [SCCB_CPU_FEATURE_LEN - 1];
-    uint8_t reserved2[6];
-    uint8_t type;
-    uint8_t reserved1;
+	uint8_t address;
+	uint8_t reserved0;
+	uint8_t : 4;
+	uint8_t feat_sief2 : 1;
+	uint8_t : 3;
+	uint8_t features_res2 [SCCB_CPU_FEATURE_LEN - 1];
+	uint8_t reserved2[6];
+	uint8_t type;
+	uint8_t reserved1;
 } __attribute__((packed)) CPUEntry;
 
 extern struct sclp_facilities sclp_facilities;
@@ -110,77 +110,77 @@ struct sclp_facilities {
 };
 
 typedef struct ReadInfo {
-    SCCBHeader h;
-    uint16_t rnmax;
-    uint8_t rnsize;
-    uint8_t  _reserved1[16 - 11];       /* 11-15 */
-    uint16_t entries_cpu;               /* 16-17 */
-    uint16_t offset_cpu;                /* 18-19 */
-    uint8_t  _reserved2[24 - 20];       /* 20-23 */
-    uint8_t  loadparm[8];               /* 24-31 */
-    uint8_t  _reserved3[48 - 32];       /* 32-47 */
-    uint64_t facilities;                /* 48-55 */
-    uint8_t  _reserved0[76 - 56];       /* 56-75 */
-    uint32_t ibc_val;
-    uint8_t  conf_char[99 - 80];        /* 80-98 */
-    uint8_t mha_pow;
-    uint32_t rnsize2;
-    uint64_t rnmax2;
-    uint8_t  _reserved6[116 - 112];     /* 112-115 */
-    uint8_t  conf_char_ext[120 - 116];   /* 116-119 */
-    uint16_t highest_cpu;
-    uint8_t  _reserved5[124 - 122];     /* 122-123 */
-    uint32_t hmfai;
-    uint8_t reserved7[134 - 128];
-    uint8_t byte_134_diag318 : 1;
-    uint8_t : 7;
-    struct CPUEntry entries[0];
+	SCCBHeader h;
+	uint16_t rnmax;
+	uint8_t rnsize;
+	uint8_t  _reserved1[16 - 11];       /* 11-15 */
+	uint16_t entries_cpu;               /* 16-17 */
+	uint16_t offset_cpu;                /* 18-19 */
+	uint8_t  _reserved2[24 - 20];       /* 20-23 */
+	uint8_t  loadparm[8];               /* 24-31 */
+	uint8_t  _reserved3[48 - 32];       /* 32-47 */
+	uint64_t facilities;                /* 48-55 */
+	uint8_t  _reserved0[76 - 56];       /* 56-75 */
+	uint32_t ibc_val;
+	uint8_t  conf_char[99 - 80];        /* 80-98 */
+	uint8_t mha_pow;
+	uint32_t rnsize2;
+	uint64_t rnmax2;
+	uint8_t  _reserved6[116 - 112];     /* 112-115 */
+	uint8_t  conf_char_ext[120 - 116];   /* 116-119 */
+	uint16_t highest_cpu;
+	uint8_t  _reserved5[124 - 122];     /* 122-123 */
+	uint32_t hmfai;
+	uint8_t reserved7[134 - 128];
+	uint8_t byte_134_diag318 : 1;
+	uint8_t : 7;
+	struct CPUEntry entries[0];
 } __attribute__((packed)) ReadInfo;
 
 typedef struct ReadCpuInfo {
-    SCCBHeader h;
-    uint16_t nr_configured;         /* 8-9 */
-    uint16_t offset_configured;     /* 10-11 */
-    uint16_t nr_standby;            /* 12-13 */
-    uint16_t offset_standby;        /* 14-15 */
-    uint8_t reserved0[24-16];       /* 16-23 */
-    struct CPUEntry entries[0];
+	SCCBHeader h;
+	uint16_t nr_configured;         /* 8-9 */
+	uint16_t offset_configured;     /* 10-11 */
+	uint16_t nr_standby;            /* 12-13 */
+	uint16_t offset_standby;        /* 14-15 */
+	uint8_t reserved0[24-16];       /* 16-23 */
+	struct CPUEntry entries[0];
 } __attribute__((packed)) ReadCpuInfo;
 
 typedef struct ReadStorageElementInfo {
-    SCCBHeader h;
-    uint16_t max_id;
-    uint16_t assigned;
-    uint16_t standby;
-    uint8_t _reserved0[16 - 14]; /* 14-15 */
-    uint32_t entries[0];
+	SCCBHeader h;
+	uint16_t max_id;
+	uint16_t assigned;
+	uint16_t standby;
+	uint8_t _reserved0[16 - 14]; /* 14-15 */
+	uint32_t entries[0];
 } __attribute__((packed)) ReadStorageElementInfo;
 
 typedef struct AttachStorageElement {
-    SCCBHeader h;
-    uint8_t _reserved0[10 - 8];  /* 8-9 */
-    uint16_t assigned;
-    uint8_t _reserved1[16 - 12]; /* 12-15 */
-    uint32_t entries[0];
+	SCCBHeader h;
+	uint8_t _reserved0[10 - 8];  /* 8-9 */
+	uint16_t assigned;
+	uint8_t _reserved1[16 - 12]; /* 12-15 */
+	uint32_t entries[0];
 } __attribute__((packed)) AttachStorageElement;
 
 typedef struct AssignStorage {
-    SCCBHeader h;
-    uint16_t rn;
+	SCCBHeader h;
+	uint16_t rn;
 } __attribute__((packed)) AssignStorage;
 
 typedef struct IoaCfgSccb {
-    SCCBHeader header;
-    uint8_t atype;
-    uint8_t reserved1;
-    uint16_t reserved2;
-    uint32_t aid;
+	SCCBHeader header;
+	uint8_t atype;
+	uint8_t reserved1;
+	uint16_t reserved2;
+	uint32_t aid;
 } __attribute__((packed)) IoaCfgSccb;
 
 typedef struct SCCB {
-    SCCBHeader h;
-    char data[SCCB_DATA_LEN];
- } __attribute__((packed)) SCCB;
+	SCCBHeader h;
+	char data[SCCB_DATA_LEN];
+} __attribute__((packed)) SCCB;
 
 /* SCLP event types */
 #define SCLP_EVENT_ASCII_CONSOLE_DATA           0x1a
@@ -195,13 +195,13 @@ typedef struct SCCB {
 #define SCLP_SELECTIVE_READ                     0x01
 
 typedef struct WriteEventMask {
-    SCCBHeader h;
-    uint16_t _reserved;
-    uint16_t mask_length;
-    uint32_t cp_receive_mask;
-    uint32_t cp_send_mask;
-    uint32_t send_mask;
-    uint32_t receive_mask;
+	SCCBHeader h;
+	uint16_t _reserved;
+	uint16_t mask_length;
+	uint32_t cp_receive_mask;
+	uint32_t cp_send_mask;
+	uint32_t send_mask;
+	uint32_t receive_mask;
 } __attribute__((packed)) WriteEventMask;
 
 #define MDBTYP_GO               0x0001
@@ -254,25 +254,25 @@ struct mdb {
 } __attribute__((packed));
 
 typedef struct EventBufferHeader {
-    uint16_t length;
-    uint8_t  type;
-    uint8_t  flags;
-    uint16_t _reserved;
+	uint16_t length;
+	uint8_t  type;
+	uint8_t  flags;
+	uint16_t _reserved;
 } __attribute__((packed)) EventBufferHeader;
 
 typedef struct WriteEventData {
-    SCCBHeader h;
-    EventBufferHeader ebh;
-    union {
-	char data[0];
-	struct mdb mdb;
-    } msg;
+	SCCBHeader h;
+	EventBufferHeader ebh;
+	union {
+		char data[0];
+		struct mdb mdb;
+	} msg;
 } __attribute__((packed)) WriteEventData;
 
 typedef struct ReadEventData {
-    SCCBHeader h;
-    EventBufferHeader ebh;
-    uint32_t mask;
+	SCCBHeader h;
+	EventBufferHeader ebh;
+	uint32_t mask;
 } __attribute__((packed)) ReadEventData;
 
 extern char _sccb[];
-- 
2.25.1

