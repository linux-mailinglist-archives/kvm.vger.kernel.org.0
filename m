Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B843431955
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhJRMkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:40:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48054 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231718AbhJRMkT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 08:40:19 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19IBEL4r013559;
        Mon, 18 Oct 2021 08:38:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=VqLHdyHlzclKoutF781izDj2tns4crN+xS+y7Y6/SuU=;
 b=pNvMgkjWcps1ETGEqpnnK62enMtPI1tYCl0Y+xBvR7qJOJHnVyP0+8AcN1LfH2ZWVwW/
 lYLcy6+Stg7vh91odOqQuR74qv2ZmXNMdO4J1Kx8OECd1LaBgPfgwlTmAvh+pXhs9DOt
 OIMHRjpxygU1QCVLEsBK3BMmI9wHyJlGpM9Upwh1hgrlat0QhdoD90WYjgVfm0eTO5oH
 BjRa3kiWQarBopnJhun8UQOUblOYk2BxL9DedbxN1Jy10U/mIpt0TS/4gSFG3Veykjql
 YkWDtZIpj88Uq0cRWVj3f4CCtnJYhdzi8YyjRptFdDc2hcu/0nHSezCLBaCTz+ht/nJW Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bs4f1xey4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:07 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19IBjhRu000759;
        Mon, 18 Oct 2021 08:38:07 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bs4f1xexh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:07 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ICbKms031339;
        Mon, 18 Oct 2021 12:38:05 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3bqpc9505x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 12:38:05 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ICc2Br52494660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 12:38:02 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22F4252054;
        Mon, 18 Oct 2021 12:38:02 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.80.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9CEAD5205F;
        Mon, 18 Oct 2021 12:38:01 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 08/17] lib: s390x: uv: Fix share return value and print
Date:   Mon, 18 Oct 2021 14:26:26 +0200
Message-Id: <20211018122635.53614-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018122635.53614-1-frankja@linux.ibm.com>
References: <20211018122635.53614-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: H6MwgCzXR_DHD2M3_4kCiyrVuLGofF44
X-Proofpoint-ORIG-GUID: jSygACKE3xPGfBcyj_BgyZkWcldgN6zZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_05,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0 impostorscore=0
 clxscore=1015 spamscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=982
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110180075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's only return 0/1 for success/failure respectively.
If needed we can later add rc/rrc pointers so we can check for the
reasons of cc==1 cases like we do in the kernel.

As share() might also be used in snippets it's best not to use prints
to avoid linking problems so lets remove the report_info().

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/uv.h | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index ec10d1c4..2f099553 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -219,15 +219,8 @@ static inline int share(unsigned long addr, u16 cmd)
 		.header.len = sizeof(uvcb),
 		.paddr = addr
 	};
-	int cc;
 
-	cc = uv_call(0, (u64)&uvcb);
-	if (!cc && uvcb.header.rc == UVC_RC_EXECUTED)
-		return 0;
-
-	report_info("uv_call: cmd %04x cc %d response code: %04x", cc, cmd,
-		    uvcb.header.rc);
-	return -1;
+	return uv_call(0, (u64)&uvcb);
 }
 
 /*
-- 
2.31.1

