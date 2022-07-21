Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0957157CBEF
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 15:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiGUNaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 09:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiGUNaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 09:30:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D887B6327;
        Thu, 21 Jul 2022 06:30:11 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LDCXdd021561;
        Thu, 21 Jul 2022 13:30:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=tC6/KY+KXSgZUHntciCP7nczPROK7ZeEt90dmAxEBMU=;
 b=PPoPXZBpTiM2PxEiAdrhEmdxhcEqwek/qzEQJMNZctona1j4due1jSEqGJvLpMfqllCq
 xDzCu32lQ7RJIeA/L97VfllHPdFosYjU98AUmMcZCOpcyfkQza/v4gU/xCQcuukQfAog
 3BtXm4sdil5UcYtJAqVsqfnNeOs7myEXQXbe2Kc8RNVtiQ+z3Zz+7HE6gnvse4ytynL3
 Nh7EdBrX8+P8kdQ+BzLoC4p+mQP06lsaIrVyAR+7Y9WlnKsGMgXS8vpvdTEdaiM8t/33
 X6KsIWR4vmKO3GzApESM2IhXG75lFGmE9AIGly+NrFiuyIncpCcoxzvS+7CGfXD+n8fw cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf6t4t19d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:30:08 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LDCbcp022076;
        Thu, 21 Jul 2022 13:30:08 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf6t4t188-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:30:08 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LDPd0S024531;
        Thu, 21 Jul 2022 13:30:06 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3hbmy8naux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:30:06 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LDU3eT22479326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 13:30:03 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AB1042047;
        Thu, 21 Jul 2022 13:30:03 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD09C4203F;
        Thu, 21 Jul 2022 13:30:02 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 13:30:02 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        qemu-s390x@nongnu.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com
Subject: [PATCH v2 0/2] s390x: Pipeline and other minor fixes
Date:   Thu, 21 Jul 2022 15:30:00 +0200
Message-Id: <20220721133002.142897-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sLrndSzx268GU9QnHuOICu375yZW6ktf
X-Proofpoint-GUID: cwwdeJWPQZ5Uw7bX2IQKrxSid2QVyxRW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_17,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=879 malwarescore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first patch fences a test when using TCG. When using Qemu < 7.1,
TCG would crash. This causes the CI pipeline to fail. Fence the
testcase when using TCG to get the CI pipeline to work.

The second patch adds some report_prefix_push/report_prefix_pop around
some of the new testcases to make each output line unique.

Claudio Imbrenda (2):
  s390x: intercept: fence one test when using TCG
  s390x: intercept: make sure all output lines are unique

 s390x/intercept.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

-- 
2.36.1

