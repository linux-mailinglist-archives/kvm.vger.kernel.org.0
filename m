Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5337317DB9E
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 09:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgCIIvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 04:51:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3296 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726846AbgCIIvs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 04:51:48 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0298pGLY004970
        for <kvm@vger.kernel.org>; Mon, 9 Mar 2020 04:51:47 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym7t6dsg1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 04:51:47 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 9 Mar 2020 08:51:45 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 9 Mar 2020 08:51:42 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0298pef915925288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Mar 2020 08:51:40 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5930D5205F;
        Mon,  9 Mar 2020 08:51:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 4CA1D52059;
        Mon,  9 Mar 2020 08:51:40 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 120A4E0251; Mon,  9 Mar 2020 09:51:40 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Ulrich Weigand <uweigand@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL 36/36] KVM: s390: introduce module parameter kvm.use_gisa
Date:   Mon,  9 Mar 2020 09:51:26 +0100
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309085126.3334302-1-borntraeger@de.ibm.com>
References: <20200309085126.3334302-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20030908-0012-0000-0000-0000038E7E9D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030908-0013-0000-0000-000021CB45B1
Message-Id: <20200309085126.3334302-37-borntraeger@de.ibm.com>
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_02:2020-03-06,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 bulkscore=0 mlxscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Mueller <mimu@linux.ibm.com>

The boolean module parameter "kvm.use_gisa" controls if newly
created guests will use the GISA facility if provided by the
host system. The default is yes.

  # cat /sys/module/kvm/parameters/use_gisa
  Y

The parameter can be changed on the fly.

  # echo N > /sys/module/kvm/parameters/use_gisa

Already running guests are not affected by this change.

The kvm s390 debug feature shows if a guest is running with GISA.

  # grep gisa /sys/kernel/debug/s390dbf/kvm-$pid/sprintf
  00 01582725059:843303 3 - 08 00000000e119bc01  gisa 0x00000000c9ac2642 initialized
  00 01582725059:903840 3 - 11 000000004391ee22  00[0000000000000000-0000000000000000]: AIV gisa format-1 enabled for cpu 000
  ...
  00 01582725059:916847 3 - 08 0000000094fff572  gisa 0x00000000c9ac2642 cleared

In general, that value should not be changed as the GISA facility
enhances interruption delivery performance.

A reason to switch the GISA facility off might be a performance
comparison run or debugging.

Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
Link: https://lore.kernel.org/r/20200227091031.102993-1-mimu@linux.ibm.com
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index f4cd436ba979..6b1842a9feed 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -185,6 +185,11 @@ static u8 halt_poll_max_steal = 10;
 module_param(halt_poll_max_steal, byte, 0644);
 MODULE_PARM_DESC(halt_poll_max_steal, "Maximum percentage of steal time to allow polling");
 
+/* if set to true, the GISA will be initialized and used if available */
+static bool use_gisa  = true;
+module_param(use_gisa, bool, 0644);
+MODULE_PARM_DESC(use_gisa, "Use the GISA if the host supports it.");
+
 /*
  * For now we handle at most 16 double words as this is what the s390 base
  * kernel handles and stores in the prefix page. If we ever need to go beyond
@@ -2732,7 +2737,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.use_skf = sclp.has_skey;
 	spin_lock_init(&kvm->arch.start_stop_lock);
 	kvm_s390_vsie_init(kvm);
-	kvm_s390_gisa_init(kvm);
+	if (use_gisa)
+		kvm_s390_gisa_init(kvm);
 	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
 
 	return 0;
-- 
2.24.1

