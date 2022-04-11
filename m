Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB164FB916
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 12:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345132AbiDKKKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 06:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345115AbiDKKKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 06:10:11 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DBB42A18;
        Mon, 11 Apr 2022 03:07:57 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23B7Mpbr025358;
        Mon, 11 Apr 2022 10:07:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=M08022hG2C21jVJFdhaTefI/CSe3Zi1CLEfbbLYDBw8=;
 b=cfGhFrF7fQdo8Zr35edOlNvvZTuFzBztK+ifXLl5rbFdmV73SilRRNzdQ6Z3mGaIeI7o
 5BsdCTV+F8pME6s14Zm67s0Qu99sYs1kNiZXG63eJdeVcduCk3CpJ47srCFXjV6gZBB8
 EIfdjOTPcwHRDwjZxBz2N9egwygmR0m92p3c3eAt8HBvX93UZAn/6Cpu5LY5Rad4kQ7x
 XN1zJlCpXlPWnniJ6dXXU+s81/Jl+e5O/WT3ze2F8Lkf5KH89CmJIGBQcBQe40qK+Ir/
 BGJSU6pdHHjaWKQffK72wLpLjlVPoRKtEG0mLiVHgOwozldVnmldtmIjSWVw4mH5R3yD rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fcfvwu36w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 10:07:56 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23B9kOTn038508;
        Mon, 11 Apr 2022 10:07:56 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fcfvwu35x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 10:07:55 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23BA7bos025597;
        Mon, 11 Apr 2022 10:07:54 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3fb1s8tv9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 10:07:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23BA7oog49676716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 10:07:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5AADA405C;
        Mon, 11 Apr 2022 10:07:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D626A4060;
        Mon, 11 Apr 2022 10:07:50 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Apr 2022 10:07:50 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 1/4] lib: s390x: add support for SCLP console read
Date:   Mon, 11 Apr 2022 12:07:47 +0200
Message-Id: <20220411100750.2868587-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220411100750.2868587-1-nrb@linux.ibm.com>
References: <20220411100750.2868587-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9S4w-B4dS0sEJQMv9AH_YMpauk6jtBKb
X-Proofpoint-GUID: pjotiQxkINWU5Whsg7v4vT3ZOpGLgFlH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_03,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 bulkscore=0 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204110057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a basic implementation for reading from the SCLP ACII console. The goal of
this is to support migration tests on s390x. To know when the migration has been
finished, we need to listen for a newline on our console.

Hence, this implementation is focused on the SCLP ASCII console of QEMU and
currently won't work under e.g. LPAR.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/sclp-console.c | 81 +++++++++++++++++++++++++++++++++++++---
 lib/s390x/sclp.h         |  7 ++++
 s390x/Makefile           |  1 +
 3 files changed, 83 insertions(+), 6 deletions(-)

diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
index fa36a6a42381..8e22660bf25d 100644
--- a/lib/s390x/sclp-console.c
+++ b/lib/s390x/sclp-console.c
@@ -89,6 +89,10 @@ static char lm_buff[120];
 static unsigned char lm_buff_off;
 static struct spinlock lm_buff_lock;
 
+static char read_buf[4096];
+static int read_index = sizeof(read_buf) - 1;
+static int read_buf_end = 0;
+
 static void sclp_print_ascii(const char *str)
 {
 	int len = strlen(str);
@@ -185,7 +189,7 @@ static void sclp_print_lm(const char *str)
  * indicating which messages the control program (we) want(s) to
  * send/receive.
  */
-static void sclp_set_write_mask(void)
+static void sclp_write_event_mask(int receive_mask, int send_mask)
 {
 	WriteEventMask *sccb = (void *)_sccb;
 
@@ -195,18 +199,27 @@ static void sclp_set_write_mask(void)
 	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
 	sccb->mask_length = sizeof(sccb_mask_t);
 
-	/* For now we don't process sclp input. */
-	sccb->cp_receive_mask = 0;
-	/* We send ASCII and line mode. */
-	sccb->cp_send_mask = SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG;
+	sccb->cp_receive_mask = receive_mask;
+	sccb->cp_send_mask = send_mask;
 
 	sclp_service_call(SCLP_CMD_WRITE_EVENT_MASK, sccb);
 	assert(sccb->h.response_code == SCLP_RC_NORMAL_COMPLETION);
 }
 
+static void sclp_console_enable_read(void)
+{
+	sclp_write_event_mask(SCLP_EVENT_MASK_MSG_ASCII, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
+}
+
+static void sclp_console_disable_read(void)
+{
+	sclp_write_event_mask(0, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
+}
+
 void sclp_console_setup(void)
 {
-	sclp_set_write_mask();
+	/* We send ASCII and line mode. */
+	sclp_write_event_mask(0, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
 }
 
 void sclp_print(const char *str)
@@ -227,3 +240,59 @@ void sclp_print(const char *str)
 	sclp_print_ascii(str);
 	sclp_print_lm(str);
 }
+
+#define SCLP_EVENT_ASCII_DATA_STREAM_FOLLOWS 0
+
+static int console_refill_read_buffer(void)
+{
+	const int MAX_EVENT_BUFFER_LEN = SCCB_SIZE - offsetof(ReadEventDataAsciiConsole, ebh);
+	ReadEventDataAsciiConsole *sccb = (void *)_sccb;
+	const int EVENT_BUFFER_ASCII_RECV_HEADER_LEN = sizeof(sccb->ebh) + sizeof(sccb->type);
+	int ret = -1;
+
+	sclp_console_enable_read();
+
+	sclp_mark_busy();
+	memset(sccb, 0, 4096);
+	sccb->h.length = PAGE_SIZE;
+	sccb->h.function_code = SCLP_UNCONDITIONAL_READ;
+	sccb->h.control_mask[2] = 0x80;
+
+	sclp_service_call(SCLP_CMD_READ_EVENT_DATA, sccb);
+
+	if ((sccb->h.response_code == SCLP_RC_NO_EVENT_BUFFERS_STORED) ||
+	    (sccb->ebh.type != SCLP_EVENT_ASCII_CONSOLE_DATA) ||
+	    (sccb->type != SCLP_EVENT_ASCII_DATA_STREAM_FOLLOWS)) {
+		ret = -1;
+		goto out;
+	}
+
+	assert(sccb->ebh.length <= MAX_EVENT_BUFFER_LEN);
+	assert(sccb->ebh.length > EVENT_BUFFER_ASCII_RECV_HEADER_LEN);
+
+	read_buf_end = sccb->ebh.length - EVENT_BUFFER_ASCII_RECV_HEADER_LEN;
+
+	assert(read_buf_end <= sizeof(read_buf));
+	memcpy(read_buf, sccb->data, read_buf_end);
+
+	read_index = 0;
+
+out:
+	sclp_console_disable_read();
+
+	return ret;
+}
+
+int __getchar(void)
+{
+	int ret;
+
+	if (read_index >= read_buf_end) {
+		ret = console_refill_read_buffer();
+		if (ret < 0) {
+			return ret;
+		}
+	}
+
+	return read_buf[read_index++];
+}
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index fead007a6037..5bd1741d721d 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -313,6 +313,13 @@ typedef struct ReadEventData {
 	uint32_t mask;
 } __attribute__((packed)) ReadEventData;
 
+typedef struct ReadEventDataAsciiConsole {
+	SCCBHeader h;
+	EventBufferHeader ebh;
+	uint8_t type;
+	char data[];
+} __attribute__((packed)) ReadEventDataAsciiConsole;
+
 extern char _sccb[];
 void sclp_setup_int(void);
 void sclp_handle_ext(void);
diff --git a/s390x/Makefile b/s390x/Makefile
index 53b0fe044fe7..62e197cb93d7 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -71,6 +71,7 @@ cflatobjs += lib/alloc_phys.o
 cflatobjs += lib/alloc_page.o
 cflatobjs += lib/vmalloc.o
 cflatobjs += lib/alloc_phys.o
+cflatobjs += lib/getchar.o
 cflatobjs += lib/s390x/io.o
 cflatobjs += lib/s390x/stack.o
 cflatobjs += lib/s390x/sclp.o
-- 
2.31.1

