Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEE442BCC4
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 12:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239297AbhJMKaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 06:30:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25282 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239036AbhJMK37 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 06:29:59 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19D9elKE022152;
        Wed, 13 Oct 2021 06:27:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=5QnPfhbGbCDnHCtsm3UdBO1rDXCoT0uri7Rq3mA2KzE=;
 b=CQqZlIkiwlVZ6sZfnrofWdbwkdco3uqQ6/JjUEtfbw0ngverZDyLWXy0KQtMRQvLKDFe
 pIqsV7EOQ87oNf4DQ/xEuRkUZN5FyrEttU5L2UyL1UDj8q2jPYMR6B44xcYjvbXBzOSu
 iLrpANoyjkU1aQMRUI6sZajE/94X2nmuiUhXMKD1Er08DxXbQtaTJyvhbGYCobxqRRrE
 amD6OvJtk+MjrsrePYR3FzBqak4HAea4Q0xAovsenJgSbPBDmg/Qnct93vvgEpXJNMb5
 mra4luxP5JIrFf+B5+NF10jU2UQzGc1FRP0T7sq66j80m+Loh1RV+lnAvGbVm7s6SZ5N nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bns3f5wat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 06:27:56 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19D9r520014996;
        Wed, 13 Oct 2021 06:27:55 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bns3f5wac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 06:27:55 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19DAHT4u015979;
        Wed, 13 Oct 2021 10:27:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3bk2qa9n13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 10:27:53 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19DARgJ963897996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 10:27:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC5FAA405B;
        Wed, 13 Oct 2021 10:27:42 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD638A405E;
        Wed, 13 Oct 2021 10:27:38 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Oct 2021 10:27:38 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/2] s390x: Cleanup and maintenance 3
Date:   Wed, 13 Oct 2021 10:27:20 +0000
Message-Id: <20211013102722.17160-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0tNoZRABzZG69yKKZEJQ0D3cMJVx5dEs
X-Proofpoint-ORIG-GUID: 1D1wn_IegddRSPRvMz_xuJOsQnJjcIS4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_03,2021-10-13_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=819 spamscore=0 bulkscore=0 phishscore=0 adultscore=0
 clxscore=1015 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110130068
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two small cleanup patches improving snippet usage.

Janosch Frank (2):
  lib: s390x: Fix PSW constant
  lib: s390x: snippet.h: Add a few constants that will make our life
    easier

 lib/s390x/asm/arch_def.h |  2 +-
 lib/s390x/snippet.h      | 40 ++++++++++++++++++++++++++++++++++++++++
 s390x/mvpg-sie.c         | 13 ++++++-------
 3 files changed, 47 insertions(+), 8 deletions(-)
 create mode 100644 lib/s390x/snippet.h

-- 
2.30.2

