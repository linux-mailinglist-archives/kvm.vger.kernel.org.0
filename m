Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF22033110B
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhCHOjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:39:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50608 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229814AbhCHOiu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:38:50 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128EXjCh192893;
        Mon, 8 Mar 2021 09:38:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8w2W5/HQuySkiuvpjC7dP1EXIi3asctXDH8eVPsvfmY=;
 b=mqGkuvgtLORYahkPyLSxOBNMD2pMoITwJlMdKduHTGany125XPIruaYd7j4kRU3HPuLp
 XqL6/12x6IQU2ZsC2sMkPgjPVD758c25hB5TYGvTaAAg2qtTVkS6ZrpWjSDSbXn62NXP
 Zsj13NDlsMNnVnjxY+DDzOVboXjRbowFAFWuYyClgDJCfRH2G5fYxjeNmTb69gNffOZn
 aL09tR+TYGn8v+dHAn9yG7b2gWvgB7OeQgSPBngt4akaeNCaPHjsaYxCIt7hKuPQ/W95
 TkHNOSg+VoJy8gSy93jXH/L8afhQecqqtOAsUEA+pyNjUuz5ZktFzf2Gt7B72NXK/ltU Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375muahwwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:38:49 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128EXkD3192935;
        Mon, 8 Mar 2021 09:38:48 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375muahwv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:38:48 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128EVwvn011275;
        Mon, 8 Mar 2021 14:33:45 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3741c8hw9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 14:33:45 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128EXgH346662130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 14:33:42 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4C30A4040;
        Mon,  8 Mar 2021 14:33:42 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AE75A4051;
        Mon,  8 Mar 2021 14:33:42 +0000 (GMT)
Received: from fedora.fritz.box (unknown [9.145.7.187])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:33:42 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 11/16] s390x: Print more information on program exceptions
Date:   Mon,  8 Mar 2021 15:31:42 +0100
Message-Id: <20210308143147.64755-12-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308143147.64755-1-frankja@linux.ibm.com>
References: <20210308143147.64755-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 mlxscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently we only get a single line of output if a test runs in a
unexpected program exception. Let's also print the general registers
to give some more context.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Acked-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/interrupt.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 46ae0bd7..d9832bc0 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -121,11 +121,40 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
 	/* suppressed/terminated/completed point already at the next address */
 }
 
+static void print_int_regs(struct stack_frame_int *stack)
+{
+	printf("\n");
+	printf("GPRS:\n");
+	printf("%016lx %016lx %016lx %016lx\n",
+	       stack->grs1[0], stack->grs1[1], stack->grs0[0], stack->grs0[1]);
+	printf("%016lx %016lx %016lx %016lx\n",
+	       stack->grs0[2], stack->grs0[3], stack->grs0[4], stack->grs0[5]);
+	printf("%016lx %016lx %016lx %016lx\n",
+	       stack->grs0[6], stack->grs0[7], stack->grs0[8], stack->grs0[9]);
+	printf("%016lx %016lx %016lx %016lx\n",
+	       stack->grs0[10], stack->grs0[11], stack->grs0[12], stack->grs0[13]);
+	printf("\n");
+}
+
+static void print_pgm_info(struct stack_frame_int *stack)
+
+{
+	printf("\n");
+	printf("Unexpected program interrupt: %d on cpu %d at %#lx, ilen %d\n",
+	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
+	       lc->pgm_int_id);
+	print_int_regs(stack);
+	dump_stack();
+	report_summary();
+	abort();
+}
+
 void handle_pgm_int(struct stack_frame_int *stack)
 {
 	if (!pgm_int_expected) {
 		/* Force sclp_busy to false, otherwise we will loop forever */
 		sclp_handle_ext();
+		print_pgm_info(stack);
 		report_abort("Unexpected program interrupt: %d on cpu %d at %#lx, ilen %d\n",
 			     lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
 			     lc->pgm_int_id);
-- 
2.29.2

