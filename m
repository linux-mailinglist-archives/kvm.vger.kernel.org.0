Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63AB44A9C74
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 16:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376423AbiBDPyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 10:54:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17936 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376275AbiBDPyD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 10:54:03 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214FrDeS017304;
        Fri, 4 Feb 2022 15:54:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2zLdKaE85V+2qiG6JE8eqhAObTmnsmKJ0bLt2qUlZn8=;
 b=KDR0I9w7wsLzt9+lLJw4KzARO1eYZ/5T5HOZrtWdstw7to6ZQCt7UqSUFnBYOL7rWhLd
 ZF7cdboUQ16j7uIgqR3XtaY+55Bgsu5KzbmN0QBFEDn74P1ZKJbv/GObfwWpdFnb4Vkc
 MQNtwD9YUFNI48AyzFS3790vuJf9JBYXKRinOGw6bj/SISjZnA59OuRGRfA3bqvW2HeS
 0iNxejqew/dB/LUq4MiL7v33YSfrGM78zNl1sgtS9mAS9Y7YIOoW2AGk42+x4FzOf7Sr
 FSqxiUQkNUFb42bl69NwyDsVDdh/UMHrWAg9xuKqYkXHF4HpDIFJLs/xbY2jT8VoSoae Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx98ps8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:02 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214FX1Fg012322;
        Fri, 4 Feb 2022 15:54:02 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx98prh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:02 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214FlRan025629;
        Fri, 4 Feb 2022 15:54:00 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3e0r0x60hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:00 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214FrvtY32178522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 15:53:57 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75F7EAE056;
        Fri,  4 Feb 2022 15:53:57 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E76C0AE045;
        Fri,  4 Feb 2022 15:53:56 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.8.50])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 15:53:56 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
Subject: [PATCH v7 11/17] s390/mm: KVM: pv: when tearing down, try to destroy protected pages
Date:   Fri,  4 Feb 2022 16:53:43 +0100
Message-Id: <20220204155349.63238-12-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204155349.63238-1-imbrenda@linux.ibm.com>
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bNxDf81qEvBPTl4nxpvNTf95sEmgmOK7
X-Proofpoint-ORIG-GUID: xfvtg7qDo2rXX54jYKQV1Q4KPxfBbJdl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 impostorscore=0 spamscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=980
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202040088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When ptep_get_and_clear_full is called for a mm teardown, we will now
attempt to destroy the secure pages. This will be faster than export.

In case it was not a teardown, or if for some reason the destroy page
UVC failed, we try with an export page, like before.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 23ca0d8e058a..72544a1b4a68 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1118,9 +1118,21 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 	} else {
 		res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
 	}
-	/* At this point the reference through the mapping is still present */
-	if (mm_is_protected(mm) && pte_present(res))
-		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
+	/* Nothing to do */
+	if (!mm_is_protected(mm) || !pte_present(res))
+		return res;
+	/*
+	 * At this point the reference through the mapping is still present.
+	 * The notifier should have destroyed all protected vCPUs at this
+	 * point, so the destroy should be successful.
+	 */
+	if (full && !uv_destroy_owned_page(pte_val(res) & PAGE_MASK))
+		return res;
+	/*
+	 * But if something went wrong and the pages could not be destroyed,
+	 * the slower export is used as fallback instead.
+	 */
+	uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
 	return res;
 }
 
-- 
2.34.1

