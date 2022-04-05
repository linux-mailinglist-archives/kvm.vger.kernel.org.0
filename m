Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2324F2702
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 10:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbiDEIEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 04:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235575AbiDEH7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 03:59:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D66F40A3B;
        Tue,  5 Apr 2022 00:55:44 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2357eV0G013730;
        Tue, 5 Apr 2022 07:55:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=lZL+0SMW83hov1roUlfMVDKkR2XFcz/vmIGw8JlJEf4=;
 b=PxXHYAnZ24pNET1Klx+gOan4HfasiRKhF9rt8g5snEvDmUztxFeYi9kZJGDMJHX88iLA
 yUjSFdFZb+fLP5XKqyuTwKpdnSbRPm6xZ9M4Hf8aGDDrdThQwKRZPiJ8hOTM6OqVuo1S
 2TFfk7uBWDKtCcm5Ghl2+DYajtRXkrKqlfPKVnXz6DK9JMwiqk+leqHGtXubhnsJnKOX
 MsmzFo2JB74WUNPtHeX8yNPN5Q8zSZqsc91ZzJU4bOqeRnADR7r3EMcg+MHit0bdLaoz
 VSjg2oV4QJ7U3MfcsuVvB1+eESNXRgvc3fQA/dVBFUJrp3N4ohfUcAaoruS4NWPEljwe Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f8cuhn673-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 07:55:43 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2357jf8b027402;
        Tue, 5 Apr 2022 07:55:43 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f8cuhn66g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 07:55:43 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2357hVmL016391;
        Tue, 5 Apr 2022 07:55:41 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3f6e48v9tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 07:55:40 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2357tiGE34406886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Apr 2022 07:55:44 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57FD942041;
        Tue,  5 Apr 2022 07:55:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C07D4203F;
        Tue,  5 Apr 2022 07:55:36 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Apr 2022 07:55:36 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/8] s390x: Cleanup and maintenance 4
Date:   Tue,  5 Apr 2022 07:52:17 +0000
Message-Id: <20220405075225.15903-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: q20rhmzKGgEYfNT8_OV19pzibEj9wCrd
X-Proofpoint-ORIG-GUID: 0cYySTInDxGIa4dUVQ03wL-3YOPxxuTI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=959 bulkscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204050044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A few small cleanups and two patches that I forgot to upstream which
have now been rebased onto the machine.h library functions.

Janosch Frank (8):
  s390x: css: Skip if we're not run by qemu
  s390x: diag308: Only test subcode 2 under QEMU
  s390x: pfmf: Initialize pfmf_r1 union on declaration
  s390x: snippets: asm: Add license and copyright headers
  s390x: pv-diags: Cleanup includes
  s390x: css: Cleanup includes
  s390x: iep: Cleanup includes
  s390x: mvpg: Cleanup includes

 s390x/css.c                                | 17 ++++++----
 s390x/diag308.c                            | 15 ++++++++-
 s390x/iep.c                                |  3 +-
 s390x/mvpg.c                               |  3 --
 s390x/pfmf.c                               | 39 +++++++++++-----------
 s390x/pv-diags.c                           | 17 ++--------
 s390x/snippets/asm/snippet-pv-diag-288.S   |  9 +++++
 s390x/snippets/asm/snippet-pv-diag-500.S   |  9 +++++
 s390x/snippets/asm/snippet-pv-diag-yield.S |  9 +++++
 9 files changed, 74 insertions(+), 47 deletions(-)

-- 
2.32.0

