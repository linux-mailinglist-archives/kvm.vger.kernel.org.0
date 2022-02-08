Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37AD54ADEAD
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 17:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383568AbiBHQxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 11:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352392AbiBHQxi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 11:53:38 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F39C061576;
        Tue,  8 Feb 2022 08:53:37 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218FM1ho017798;
        Tue, 8 Feb 2022 16:53:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=NF8RX9s8eGTpgxki+UFXPWbyeNzXKo7cQEW8+foLp5w=;
 b=anbn7L9ew9qS+rJNskvukFBt99+eUjmgd6ehGByPRRn1ohCsM85CK6LslaVgp7AoolAd
 gdiwiDpau9h8aNNAjjUyRD4mUAn8vUbtt0ETWb4w6XR2Exp378RJlQZ6//cdEOnj5tid
 kEr869RKdLYTltalbus0lMmupX1aTb+aqTid4KpZJg+GGeRyFfEGcwcGEuuQsTHniOeZ
 9MODUvhyA3UQ6C6a5v8nkEq2vRCHDPy12XQ2RkwMyLZip/orAdE6sEZrNRcnSed5AhtM
 +NWgZtJYDN7zhTw5WhFd+v5IZh/U+TECvMKcqf6q0IKLBaRuqaugNWmglNWs5ZwnzGeZ qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e3u3nu97b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 16:53:36 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 218Gk3nl007729;
        Tue, 8 Feb 2022 16:53:36 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e3u3nu970-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 16:53:36 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 218GX1b0021627;
        Tue, 8 Feb 2022 16:53:34 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3e1ggj6thc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 16:53:34 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 218GhPN745351300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 16:43:25 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C36274C052;
        Tue,  8 Feb 2022 16:53:30 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C6A84C040;
        Tue,  8 Feb 2022 16:53:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 16:53:30 +0000 (GMT)
From:   Michael Mueller <mimu@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Mueller <mimu@linux.ibm.com>
Subject: [PATCH v2 0/1] KVM: s390: pv: make use of ultravisor AIV support
Date:   Tue,  8 Feb 2022 17:53:09 +0100
Message-Id: <20220208165310.3905815-1-mimu@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: w3WW58ySeN-21v47st4tZUEOqwhfO7w1
X-Proofpoint-GUID: zxvwYcrK2aHxNVm2ht0DvRBl6xeE3xLQ
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_05,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=282 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch enables the ultravisor adapter interruption vitualization
support.

Changes in v2:
- moved GISA disable into "put CPUs in PV mode" routine
- moved GISA enable into "pull CPUs out of PV mode" routine 

[1] https://lore.kernel.org/lkml/ae7c65d8-f632-a7f4-926a-50b9660673a1@linux.ibm.com/T/#mcb67699bf458ba7482f6b7529afe589d1dbb5930

Michael Mueller (1):
  KVM: s390: pv: make use of ultravisor AIV support

 arch/s390/include/asm/uv.h |  1 +
 arch/s390/kvm/interrupt.c  | 53 +++++++++++++++++++++++++++++++++-----
 arch/s390/kvm/kvm-s390.c   | 12 ++++++---
 arch/s390/kvm/kvm-s390.h   | 11 ++++++++
 4 files changed, 68 insertions(+), 9 deletions(-)

-- 
2.32.0

