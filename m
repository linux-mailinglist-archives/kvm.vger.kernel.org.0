Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5D957CBD9
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 15:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiGUN05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 09:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiGUN04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 09:26:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A8272EFA
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 06:26:55 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LDIiMj002445
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 13:26:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=hnT3uRCXPDtMd1eEYhQEHFxUeyTlCflOpK3qA52inp0=;
 b=dhEipR+1vkAGTk1qa6SNTHtg/EoUWGe7CdX1jm9gqrL/7jgrFwmWLSqMd8PumI+y9iPV
 qHFp/hJxEgXXq3Cw66DTFmOMGVLGYun+6u+Ipi+cX0JTyEhRKD5aV4mZ7CUX/w71o+aZ
 zaGTRmajZL5nZ5Niyyg2wWTntmFZm08P8BlE5NbeWYw/R5gM6eQ5H5tG+aB7wjYSFsXd
 dT0Oqe62S85Rg7P+CwBTZMs0EccInT+atnKw8qjVzl/Y6K8hjKm4n0MbL5DAZ/iLp6hH
 Vig9tMNe+/fKUFot2CHbixdDpnedhYDaDHtJog62KXDMqEbfY5K/OlVVQ0If+ere0o5n SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf7jkr8d1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 13:26:54 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LDIl1k002547
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 13:26:53 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf7jkr8c6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:26:53 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LDOs9e014356;
        Thu, 21 Jul 2022 13:26:52 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3hbmy8y3qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:26:51 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LDQmrK10420522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 13:26:48 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AE6011C04C;
        Thu, 21 Jul 2022 13:26:48 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F145911C04A;
        Thu, 21 Jul 2022 13:26:47 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 13:26:47 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 0/2] s390x: dump support for PV tests
Date:   Thu, 21 Jul 2022 15:26:45 +0200
Message-Id: <20220721132647.552298-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bAyOl9FhR_-XkL_-n0k8KrRUbyer8amT
X-Proofpoint-GUID: N7oBvWQDWGj-5GF3NSr1_5xhDGuvj6kX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_17,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 impostorscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=506 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207210053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the upcoming possibility to dump PV guests under s390x, we should
be able to dump kvm-unit-tests for debugging, too.

Add the necessary flags to genprotimg to allow dumping.

Nico Boehr (2):
  s390x: factor out common args for genprotimg
  s390x: create persistent comm-key

 s390x/Makefile | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

-- 
2.36.1

