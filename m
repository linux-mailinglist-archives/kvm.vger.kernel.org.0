Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16BE4570131
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 13:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiGKLvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 07:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiGKLvQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 07:51:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859092252E;
        Mon, 11 Jul 2022 04:51:15 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26BBH2RJ020674;
        Mon, 11 Jul 2022 11:51:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=WlPpKcdgtfNxngGvwa0LGpucJ0Ap+TpL5CpZHCxpgNw=;
 b=OHhHoNNbQ1ofMmfLs8mwMPQ+/FhmskpfLFKwFCTaQ9P4ZvhmCXhvqbaowykgM34z3/ED
 b0Y/6JxiMhQ9RMdWAkta0I3oX6rJv6eccQ5+b6fQUHghYxq03fOGqwT+BCYDko2q/1SO
 m4ZfgSCTtdF9zJ+mo3mUpX3//ohSZEEVY6SDjTMsJVp9D4qEs7TpLwUAlrGguHpTme44
 6BhpLY3NST9UHi8wsrMEPaiJvBlHeJTrTNdGvyZmOBDIK8LS9GT+uDVlNpSNM0LsJlQT
 CnSUQoUthwQsCxQ2Hkf0ME7UF02oiFMi+M0jjPoSE4DTcMxAltkVAPf+pagqDTDFGdgR fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h8jus0myp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 11:51:14 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26BBgwYF010288;
        Mon, 11 Jul 2022 11:51:14 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h8jus0my6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 11:51:14 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26BBolL4024387;
        Mon, 11 Jul 2022 11:51:12 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3h71a8j0wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 11:51:12 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26BBp95t24183154
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jul 2022 11:51:09 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F987AE053;
        Mon, 11 Jul 2022 11:51:09 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F10FBAE04D;
        Mon, 11 Jul 2022 11:51:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 11 Jul 2022 11:51:08 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id B421FE030B; Mon, 11 Jul 2022 13:51:08 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     KVM <kvm@vger.kernel.org>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [PATCH 1/1] KVM: s390: Add facility 197 to the white list
Date:   Mon, 11 Jul 2022 13:51:08 +0200
Message-Id: <20220711115108.6494-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: S86Zsn4_CMVeJaUyqUBaSA4OoABZDbcO
X-Proofpoint-ORIG-GUID: lYygZPl4gVAQbplV89oCJllD_S9091Bg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-11_17,2022-07-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 mlxlogscore=923
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207110049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

z16 also provides facility 197 (The processor-activity-instrumentation
extension 1). Lets add it to KVM.

Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/tools/gen_facilities.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/tools/gen_facilities.c b/arch/s390/tools/gen_facilities.c
index 530dd941d140..cb0aff5c0187 100644
--- a/arch/s390/tools/gen_facilities.c
+++ b/arch/s390/tools/gen_facilities.c
@@ -111,6 +111,7 @@ static struct facility_def facility_defs[] = {
 			193, /* bear enhancement facility */
 			194, /* rdp enhancement facility */
 			196, /* processor activity instrumentation facility */
+			197, /* processor activity instrumentation extension 1 */
 			-1  /* END */
 		}
 	},
-- 
2.36.1

