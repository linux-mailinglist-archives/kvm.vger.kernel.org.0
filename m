Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27BC0DEBB
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 11:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbfD2JKR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 05:10:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39648 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727581AbfD2JKQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Apr 2019 05:10:16 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3T99veu042037
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 05:10:14 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2s5w7uaw1j-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 05:10:14 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 29 Apr 2019 10:10:12 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 29 Apr 2019 10:10:08 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3T9A6mX51314930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 09:10:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 441534C04E;
        Mon, 29 Apr 2019 09:10:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A0D64C06F;
        Mon, 29 Apr 2019 09:10:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 29 Apr 2019 09:10:06 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id E3E0320F5D4; Mon, 29 Apr 2019 11:10:05 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [GIT PULL 10/12] KVM: s390: provide kvm_arch_no_poll function
Date:   Mon, 29 Apr 2019 11:10:00 +0200
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190429091002.71164-1-borntraeger@de.ibm.com>
References: <20190429091002.71164-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19042909-0028-0000-0000-000003686923
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19042909-0029-0000-0000-00002427C95C
Message-Id: <20190429091002.71164-11-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-29_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904290067
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We do track the current steal time of the host CPUs. Let us use
this value to disable halt polling if the steal time goes beyond
a configured value.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/Kconfig            |  1 +
 arch/s390/kvm/kvm-s390.c         | 17 +++++++++++++++++
 3 files changed, 19 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index e224246ff93c..bdbc81b5bc91 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -313,6 +313,7 @@ struct kvm_vcpu_stat {
 	u64 halt_successful_poll;
 	u64 halt_attempted_poll;
 	u64 halt_poll_invalid;
+	u64 halt_no_poll_steal;
 	u64 halt_wakeup;
 	u64 instruction_lctl;
 	u64 instruction_lctlg;
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 767453faacfc..e987e73738b5 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -31,6 +31,7 @@ config KVM
 	select HAVE_KVM_IRQFD
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_INVALID_WAKEUPS
+	select HAVE_KVM_NO_POLL
 	select SRCU
 	select KVM_VFIO
 	---help---
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index eb68ada1334b..ed280a4fea07 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -75,6 +75,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "halt_successful_poll", VCPU_STAT(halt_successful_poll) },
 	{ "halt_attempted_poll", VCPU_STAT(halt_attempted_poll) },
 	{ "halt_poll_invalid", VCPU_STAT(halt_poll_invalid) },
+	{ "halt_no_poll_steal", VCPU_STAT(halt_no_poll_steal) },
 	{ "halt_wakeup", VCPU_STAT(halt_wakeup) },
 	{ "instruction_lctlg", VCPU_STAT(instruction_lctlg) },
 	{ "instruction_lctl", VCPU_STAT(instruction_lctl) },
@@ -177,6 +178,11 @@ static int hpage;
 module_param(hpage, int, 0444);
 MODULE_PARM_DESC(hpage, "1m huge page backing support");
 
+/* maximum percentage of steal time for polling.  >100 is treated like 100 */
+static u8 halt_poll_max_steal = 10;
+module_param(halt_poll_max_steal, byte, 0644);
+MODULE_PARM_DESC(hpage, "Maximum percentage of steal time to allow polling");
+
 /*
  * For now we handle at most 16 double words as this is what the s390 base
  * kernel handles and stores in the prefix page. If we ever need to go beyond
@@ -3166,6 +3172,17 @@ static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
 	}
 }
 
+bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
+{
+	/* do not poll with more than halt_poll_max_steal percent of steal time */
+	if (S390_lowcore.avg_steal_timer * 100 / (TICK_USEC << 12) >=
+	    halt_poll_max_steal) {
+		vcpu->stat.halt_no_poll_steal++;
+		return true;
+	}
+	return false;
+}
+
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	/* kvm common code refers to this, but never calls it */
-- 
2.19.1

