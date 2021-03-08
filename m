Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658453310E0
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhCHOdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:33:55 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54630 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229757AbhCHOdq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:33:46 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128EWq7A188349;
        Mon, 8 Mar 2021 09:33:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=l/FUewPxs33UMNJWyi6a8LJo+xrQ0u9EM/ukGfh0A+k=;
 b=sllyALQeoErvhG7z9yVfi7CUt2NTPE/rR7Nu3GgqTUBFug/FD20pkWGON5GVkP2Nva26
 gRQLwIRwBQUPZnPaEtQ5OkUBL3xYhwRUPG/nk1JMhV1xAXg7U7EXX8xbdk50pt9Jaxep
 IkAt9BFPEkfRg9k4uGuB/C2HHdeCLsOyDc9576zZxoeWScqXiRVf/UO2yzl8AeV4BtbJ
 keEUFWfWF1y9yO/qfU1hBSeT1+dG6Es5scVP3X/c9uy4PH2nEHOy4tOyhN8AlyO5Rshr
 xDwsSRPCfi41P+Tpj8eQpLNigZDH4v/+mioQ0/YnMMH7xFKAKGf+AXS6Iys3HHVOcWLJ YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375njbrg7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:45 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128EXjP0194917;
        Mon, 8 Mar 2021 09:33:45 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375njbrg6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:45 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128EXhxk017743;
        Mon, 8 Mar 2021 14:33:43 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3741c81027-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 14:33:43 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128EXerw42336542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 14:33:40 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27CA7A4040;
        Mon,  8 Mar 2021 14:33:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A74C6A4053;
        Mon,  8 Mar 2021 14:33:39 +0000 (GMT)
Received: from fedora.fritz.box (unknown [9.145.7.187])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:33:39 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 06/16] s390x: Remove sthyi partition number check
Date:   Mon,  8 Mar 2021 15:31:37 +0100
Message-Id: <20210308143147.64755-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308143147.64755-1-frankja@linux.ibm.com>
References: <20210308143147.64755-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 clxscore=1015 impostorscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Turns out that partition numbers start from 0 and not from 1 so a 0
check doesn't make sense here.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/sthyi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/s390x/sthyi.c b/s390x/sthyi.c
index d8dfc854..db90b56f 100644
--- a/s390x/sthyi.c
+++ b/s390x/sthyi.c
@@ -128,7 +128,6 @@ static void test_fcode0_par(struct sthyi_par_sctn *par)
 		report(sum, "core counts");
 
 	if (par->INFPVAL1 & PART_STSI_SUC) {
-		report(par->INFPPNUM, "number");
 		report(memcmp(par->INFPPNAM, null_buf, sizeof(par->INFPPNAM)),
 		       "name");
 	}
-- 
2.29.2

