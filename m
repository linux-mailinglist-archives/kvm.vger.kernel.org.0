Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873A543194A
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbhJRMkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:40:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61068 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231495AbhJRMkR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 08:40:17 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19IBKcTL029815;
        Mon, 18 Oct 2021 08:38:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vU9ShpWENoat/SX8LgXcexyNq6wy0kVeOlyru1Gj+kA=;
 b=rgcHzw+n2nI+Bzz6gudAdWfEGkuW8rWkkWhrmKZK0Znpp6HLnjq/9UAQ3rAWrdejm1jo
 bEmxGTLc5JLhXjG3YYOWGjx4nv2UrQtFC2JU/nl7lwspZtt17qtbKteokMMSCvIyAoWB
 FEKdoRDrhAaShv5dvC1UCZg5dtL785GePt3/imF9nkzsCIDGFTHUCZpYjvcsUpS0Jp1g
 DgyBrVkfi1ARzLHsqKQi6Lo51yZsH3vrUwH54aTK6UQwy0gDWcn9CeHnVfHX21fpeRjK
 2uRHFiYo7JJe8UKErzG9XMJjHMYlXaKjuEYpYUbJTNpc891y0uRnLw/+a1L5XxtGc+CM PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs7yg1m84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:06 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19ICRVqD007885;
        Mon, 18 Oct 2021 08:38:05 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs7yg1m71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:05 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ICc3vP000896;
        Mon, 18 Oct 2021 12:38:03 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3bqpca66y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 12:38:03 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ICbwF951773816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 12:37:58 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AAEA5205A;
        Mon, 18 Oct 2021 12:37:58 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.80.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 121DB5204F;
        Mon, 18 Oct 2021 12:37:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 01/17] s390x: uv-host: Explain why we set up the home space and remove the space change
Date:   Mon, 18 Oct 2021 14:26:19 +0200
Message-Id: <20211018122635.53614-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018122635.53614-1-frankja@linux.ibm.com>
References: <20211018122635.53614-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ezty2MZLfFZsHBOyfhRYB168n9Oryh-k
X-Proofpoint-GUID: fvri6bwa1DiLBRmETFgTtz0YsJULD0AG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_05,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110180077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UV home addresses don't require us to be in home space but we need to
have it set up so hw/fw can use the home asce to translate home
virtual addresses.

Hence we add a comment why we're setting up the home asce and remove
the address space since it's unneeded.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 s390x/uv-host.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 426a67f6..28035707 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -444,13 +444,18 @@ static void test_clear(void)
 
 static void setup_vmem(void)
 {
-	uint64_t asce, mask;
+	uint64_t asce;
 
 	setup_mmu(get_max_ram_size(), NULL);
+	/*
+	 * setup_mmu() will enable DAT and set the primary address
+	 * space but we need to have a valid home space since UV calls
+	 * take home space virtual addresses.
+	 *
+	 * Hence we just copy the primary asce into the home space.
+	 */
 	asce = stctg(1);
 	lctlg(13, asce);
-	mask = extract_psw_mask() | 0x0000C00000000000UL;
-	load_psw_mask(mask);
 }
 
 int main(void)
-- 
2.31.1

