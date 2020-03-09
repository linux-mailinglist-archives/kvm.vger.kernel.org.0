Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE61617E2F4
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 16:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgCIPAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 11:00:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24888 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726617AbgCIPAl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 11:00:41 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 029F09I9118259;
        Mon, 9 Mar 2020 11:00:40 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym8k7ss6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Mar 2020 11:00:39 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 029F0dUG122814;
        Mon, 9 Mar 2020 11:00:39 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym8k7ss2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Mar 2020 11:00:38 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 029F0Zvw004783;
        Mon, 9 Mar 2020 15:00:35 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 2ym386b3tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Mar 2020 15:00:35 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 029F0YB319661106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Mar 2020 15:00:34 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FF1A2805E;
        Mon,  9 Mar 2020 15:00:34 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84CA928060;
        Mon,  9 Mar 2020 15:00:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  9 Mar 2020 15:00:34 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: [PATCH 0/4] KVM: s390: reset selftest and fixes
Date:   Mon,  9 Mar 2020 11:00:22 -0400
Message-Id: <20200309150026.4329-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_06:2020-03-09,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 bulkscore=0 priorityscore=1501 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=946 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By adding more testcases to the reset test, I even found a bug.

Christian Borntraeger (4):
  selftests: KVM: s390: fix early guest crash
  selftests: KVM: s390: test more register variants for the reset ioctl
  KVM: s390: Also reset registers in sync regs for initial cpu reset
  selftests: KVM: s390: check for registers to NOT change on reset

 arch/s390/kvm/kvm-s390.c                   |  18 ++-
 tools/testing/selftests/kvm/s390x/resets.c | 130 +++++++++++++++++----
 2 files changed, 123 insertions(+), 25 deletions(-)

-- 
2.25.0

