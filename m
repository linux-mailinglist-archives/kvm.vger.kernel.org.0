Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2CE696379
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 13:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbjBNM2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 07:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBNM2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 07:28:50 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D56AD07;
        Tue, 14 Feb 2023 04:28:49 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31EASFqO027959;
        Tue, 14 Feb 2023 12:28:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=1zCdlqIqrEq1sOtvTww32co0pG7t8mzyAniZSVTPtlo=;
 b=QPexIrvVTYz7YYFNkbsXS479zosWgMLeXC6MvyhSibZ1jgeHAeip1eLCtn4rvHMNHh55
 CiHbOfOSj3QgX2HzPurX799WHgy4ZtOxmwgXCw3WOSLXDAJcqhcndW/bMpEqVJ7jmk3J
 +LtMjdTSqDK5/+Tiwn8Tlrx31pAmchNddPAApCTSq+i9rEnFsy0pg3Hu3+XHTFs3DaVk
 MQRqwG3EnQFVMbGglvQ/YWsRo7fSkbsXfHYSPHzz6QZzTqw50mtSX2W67RVuc06LyoEt
 Lh0wHLrSRWAET9Vh1fucU4B8alfgsk7S2btofB85xHqGogjDg9Opi2k6hYbZx+e/ziJi mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nr8jqu896-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Feb 2023 12:28:48 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31EBuZwO015386;
        Tue, 14 Feb 2023 12:28:48 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nr8jqu88q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Feb 2023 12:28:48 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31E5YPFx030092;
        Tue, 14 Feb 2023 12:28:46 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3np29fm0cd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Feb 2023 12:28:46 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31ECSgZR52166928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 12:28:42 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FDA820043;
        Tue, 14 Feb 2023 12:28:42 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10E3820040;
        Tue, 14 Feb 2023 12:28:42 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.242])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 14 Feb 2023 12:28:42 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        svens@linux.ibm.com
Subject: [PATCH v3 0/1] KVM: s390: vsie: clarifications on setting the APCB
Date:   Tue, 14 Feb 2023 13:28:40 +0100
Message-Id: <20230214122841.13066-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wDJvO-uGK-y8ByJmWbvCARtbs6mhMs6N
X-Proofpoint-ORIG-GUID: Kbb8AbTRKh_99VbtBrlL71r9IKMi8lNN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-14_07,2023-02-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=597 phishscore=0 priorityscore=1501 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302140104
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This is a v3 of the previously called:
[PATCH] KVM: s390: vsie: fix crycb virtual vs physical usage
and 
[PATCH v2 0/1] KVM: s390: vsie: clarifications on setting the APCB

Changes:

1->2 After David's comment that the patch has not to do with
     virtual vs physical, I reworked the commit message.

2->3 rename crycb_o crycb_gpa and apcb_o apcb_gpa
     gpa = Guest Physical Address 

I resent the patch because I think that even the previous
version is not really buggy, this new version brings clarity.

Regards,
Pierre

Pierre Morel (1):
  KVM: s390: vsie: clarifications on setting the APCB

 arch/s390/kvm/vsie.c | 50 +++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

-- 
2.31.1

