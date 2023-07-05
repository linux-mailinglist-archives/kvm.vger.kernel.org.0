Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5777482CF
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 13:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbjGELTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 07:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjGELTw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 07:19:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97775F2;
        Wed,  5 Jul 2023 04:19:51 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 365BGmXq000681;
        Wed, 5 Jul 2023 11:19:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=5iB3XX+PHP4NFnfsxzUoEdBSwjJaaEbKXMTVMTtUMLI=;
 b=KA3NMkrtUWuZOCgH/FUu6uTyQxPKGRd51ROh5mtVJtDXbTIGaBA5j+krq2QFx0l9133U
 uhq8ZqcTlvRsfo88gVTTE0bFJcgpXSxvSwOlFF1bLCtr1CIDMSG2vKOVkCnxE+r60Arl
 YO+l3Ky/x4jWjaQBTPaOhnlz8E/6YdGTsqCiC8Zr/XA45+m84fTBBxYf2ORLZDxaSPjz
 9QNlGdPKY3iHVXha1hCqN4K4UH0Upy8ogzIngjk5xt8lrI6vvp1gNqnFsBg2N7nSH7yz
 zRYhfREfTBJsa63TeOFHvIenxOgAxbb2vKhP5TXe38+RuGn7ooWjXRuO2g+KwLgdq7I0 AA== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rn7gq01xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jul 2023 11:19:51 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3652dpG5015007;
        Wed, 5 Jul 2023 11:19:48 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3rjbs4svdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jul 2023 11:19:48 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 365BJhUu42140344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Jul 2023 11:19:43 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFC042004E;
        Wed,  5 Jul 2023 11:19:42 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 519C520043;
        Wed,  5 Jul 2023 11:19:42 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.171.77.114])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  5 Jul 2023 11:19:42 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        frankja@linux.ibm.com, mhartmay@linux.ibm.com, nsg@linux.ibm.com,
        borntraeger@de.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v2 0/2] KVM: s390: pv: fix two small bugs
Date:   Wed,  5 Jul 2023 13:19:35 +0200
Message-ID: <20230705111937.33472-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tgFn-rpdOXbJGb7pMLFc7rl0cfh2OLl6
X-Proofpoint-GUID: tgFn-rpdOXbJGb7pMLFc7rl0cfh2OLl6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-05_02,2023-07-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 mlxlogscore=624 mlxscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2307050097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series fixes 2 small bugs introduced with asynchronous teardown.

The first patch (unmodified since v1, but did not get any reviews)
fixes a potential race that can cause crashes during shutdown on
machines that don't support protected virtualization.

The second patch adds a missing initialization when replacing the ASCE
for a protected guest. This could potentially cause issues and crashes
if lowcore is affected.


v1->v2:

* added the second patch

Claudio Imbrenda (2):
  KVM: s390: pv: simplify shutdown and fix race
  KVM: s390: pv: fix index value of replaced ASCE

 arch/s390/kvm/pv.c  | 8 ++++++--
 arch/s390/mm/gmap.c | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

-- 
2.41.0

