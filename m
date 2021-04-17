Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65953362E4F
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 09:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbhDQH2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 03:28:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9694 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229631AbhDQH2j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 03:28:39 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13H743hU127080;
        Sat, 17 Apr 2021 03:28:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=4PNJeZoXemYnzdNnalW58Bbz+DUKiBoUdguT13NzmQw=;
 b=sMtg71gsDEbc8v8MBGdn/wAUw/gnB3xiMsGQ60Uxvhh272APFronNbgB8w1mTimJGHoH
 DDEzEa7fvZ7nyhCiz1Tq5WbUwjX3MyliIOBBF7y8jcPvoY29bwdgZCIRFb63gTUu3Urv
 yteTjckBlEIbU2NJVm7U/EN0X8JwNpo0dKnGOavHaRM+0z5EmYay4a4oU6LWBicljlxY
 1sPgGyFshWizSojQlkRYnfLWGgGH/iV1TYofu4uxsT8H2VCgN5XDw7XjUC3ZZ7SW2dPi
 AoWkDsaB1Hc9l6HM4sLe0osBeSda4Q3lK/6fu8rtzn0PEb2ze9WV7QokBxgu2WevKRQt kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37ym8p6skg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 17 Apr 2021 03:28:13 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13H76atN138159;
        Sat, 17 Apr 2021 03:28:12 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37ym8p6sjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 17 Apr 2021 03:28:12 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13H7PSsB003609;
        Sat, 17 Apr 2021 07:28:10 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 37yqa881gy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 17 Apr 2021 07:28:10 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13H7Ri9O28049734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Apr 2021 07:27:44 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F11042045;
        Sat, 17 Apr 2021 07:28:07 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE7494203F;
        Sat, 17 Apr 2021 07:28:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sat, 17 Apr 2021 07:28:06 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 6CFF1E07A2; Sat, 17 Apr 2021 09:28:06 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [GIT PULL 0/1] KVM: s390: Fix potential crash in preemptible kernels
Date:   Sat, 17 Apr 2021 09:28:04 +0200
Message-Id: <20210417072806.82517-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.30.2
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0oiyHw-AB9SHBb5izvuW39A8UYnJ0kK2
X-Proofpoint-GUID: 2RB5qFpC0dI8IAWc10KjiKgjSBRkTplp
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-17_03:2021-04-16,2021-04-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=949 bulkscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 spamscore=0 clxscore=1015 mlxscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104170046
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

a 2nd batch for kvm/next (no need to hurry this into 5.12) with a fix
for preemptible kernels.

The following changes since commit c3171e94cc1cdcc3229565244112e869f052b8d9:

  KVM: s390: VSIE: fix MVPG handling for prefixing and MSO (2021-03-24 10:31:55 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.13-2

for you to fetch changes up to 44bada28219031f9e8e86b84460606efa57b871e:

  KVM: s390: fix guarded storage control register handling (2021-04-15 15:35:38 +0200)

----------------------------------------------------------------
KVM: s390: Fix potential crash in preemptible kernels

There is a potential race for preemptible kernels, where
the host kernel would get a fault when it is preempted as
the wrong point in time.

----------------------------------------------------------------
Heiko Carstens (1):
      KVM: s390: fix guarded storage control register handling

 arch/s390/kvm/kvm-s390.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
