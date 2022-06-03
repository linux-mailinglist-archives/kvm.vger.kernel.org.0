Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADED53CC6B
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 17:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245594AbiFCPkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 11:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239078AbiFCPkp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 11:40:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D860F4ECEA;
        Fri,  3 Jun 2022 08:40:44 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 253ElnwT030016;
        Fri, 3 Jun 2022 15:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=dF4JvbyJsIBMM6nYZkO9zOKypQG2ZXVkCKpOqanQFcI=;
 b=JVf3vWGCR+uLaK8MY+L4VDoqdoZCdb0G5AQ0qn/82BoYdOxNco3W6efewfLwov7aKtuH
 nv3jPar+qq1hShH4yFRYUa6JF7rtGRAXBoCh+dLVst9XAU7CD8BomQt90VUxhO9MtTNy
 c+5ULSuwlquAT03nYiprNCFvpFs1Uwiy0jD5/5EIrnwImdTnXQkE4a+p0ocF2t4fpSZY
 w9M1rvJGvhlf42VN7e7l3CZvHJQg8TD7lJk2FuuIg+s+9aQcJRSufyPXf58/EyTHV0Qn
 bvQvvsY0zrX3cb6P5geU+9QkI+scIu0t8R2jjYkh4yrgg23dtOMy2ZOLtZ9Z2GoGn1QQ Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfmcmryub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 15:40:44 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 253Ev91G004618;
        Fri, 3 Jun 2022 15:40:44 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfmcmryt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 15:40:43 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 253FZE55024154;
        Fri, 3 Jun 2022 15:40:41 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3gbc7h8mve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 15:40:41 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 253Fecpp21496252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jun 2022 15:40:38 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32E19A404D;
        Fri,  3 Jun 2022 15:40:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBA7DA4051;
        Fri,  3 Jun 2022 15:40:37 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.40])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jun 2022 15:40:37 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        scgl@linux.ibm.com, pmorel@linux.ibm.com, nrb@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 0/2] better smp interrupt checks
Date:   Fri,  3 Jun 2022 17:40:35 +0200
Message-Id: <20220603154037.103733-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sosReMF8K-SrprPjieCI8bmRrIoF5bdq
X-Proofpoint-ORIG-GUID: I2DANnw5ho_SZIDG85_sZB1vQQ-n4VyR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_05,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 spamscore=0 mlxlogscore=515 phishscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206030068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use per-CPU flags and callbacks for Program, Extern, and I/O interrupts
instead of global variables.
    
This allows for more accurate error handling; a CPU waiting for an
interrupt will not have it "stolen" by a different CPU that was not
supposed to wait for one, and now two CPUs can wait for interrupts at
the same time.

Also fix skey.c to be compatible with the new interrupt handling.

Claudio Imbrenda (2):
  s390x: skey.c: rework the interrupt handler
  lib: s390x: better smp interrupt checks

 lib/s390x/asm/arch_def.h |  7 ++++++-
 lib/s390x/interrupt.c    | 38 ++++++++++++++++----------------------
 s390x/skey.c             | 24 +++++++++---------------
 3 files changed, 31 insertions(+), 38 deletions(-)

-- 
2.36.1

