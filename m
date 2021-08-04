Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCD73E047A
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 17:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239362AbhHDPl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 11:41:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53020 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239258AbhHDPlU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 11:41:20 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 174FYvWv143083;
        Wed, 4 Aug 2021 11:41:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4lBlU5qzGjqPllO/bY4GvioqI/3052plU8GfFftHpFQ=;
 b=mRYK+PgVSCcmuQRmJHdtXWSxgrYE+S/XXxA+Xw2zKIszhUNyXgmoSeyOxuBst3CqfLbQ
 loDHaS/+IIIcrBahm0TXTWKW7amCROXdE8eeqJtU+poh4dwncuZQkXPLo9fYWKXCVdjA
 Jx0MrCuQIYRukOncil/dKusIT5GW03TdgUXzG3WUK8cF/B15o57n6A2SaTNqQY7bgK/j
 iRmf80JrSYKvXasV9Hn3pNr465v4vJgsg78cAouazFFRgr1oJSv86FW2tNDtCNqWkV2I
 p1YM4gO4WHVEdKNgOIJXi8WVdNqG6HcBB9E4Nsy3hTnoSt4FKHzZgf2tEV5mRZlyS5hZ ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a7brqk07r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 11:41:07 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 174FZcMQ000617;
        Wed, 4 Aug 2021 11:41:07 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a7brqk066-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 11:41:06 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 174FY1UF005130;
        Wed, 4 Aug 2021 15:41:04 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3a4wsj0hva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 15:41:04 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 174Ff0Fd56033610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Aug 2021 15:41:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B3DB4C04A;
        Wed,  4 Aug 2021 15:41:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95FDA4C04E;
        Wed,  4 Aug 2021 15:40:59 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.2.150])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 Aug 2021 15:40:59 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v3 13/14] KVM: s390: pv: add OOM notifier for lazy destroy
Date:   Wed,  4 Aug 2021 17:40:45 +0200
Message-Id: <20210804154046.88552-14-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210804154046.88552-1-imbrenda@linux.ibm.com>
References: <20210804154046.88552-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hGE8af4R-dbF7TDxDmFOSNCPZybz593e
X-Proofpoint-GUID: 1-zZmXroXbjs0tVta41VLpg68uj9JZ1X
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-04_03:2021-08-04,2021-08-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 mlxlogscore=836 malwarescore=0 priorityscore=1501 clxscore=1015
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108040089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a per-VM OOM notifier for lazy destroy.

When a protected VM is undergoing deferred teardown, register an OOM
notifier. This allows an OOM situation to be handled by just waiting a
little.

The background cleanup deferred destroy process will now keep a running
tally of the amount of pages freed. The asynchronous OOM notifier will
check the number of pages freed before and after waiting. The OOM
notifier will wait 10ms, and then report the number of pages freed by
the deferred destroy mechanism during that time.

If at least 1024 pages have already been freed in the current OOM
situation, no action is taken by the OOM notifier and no wait is
performed. This avoids excessive waiting times in case many VMs are
being destroyed at the same time, once enough memory has been freed.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index c570d4ce29c3..e3dfd5c73d3f 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -15,8 +15,12 @@
 #include <linux/pagewalk.h>
 #include <linux/sched/mm.h>
 #include <linux/kthread.h>
+#include <linux/delay.h>
+#include <linux/oom.h>
 #include "kvm-s390.h"
 
+#define KVM_S390_PV_LAZY_DESTROY_OOM_NOTIFY_PRIORITY	70
+
 struct deferred_priv {
 	struct mm_struct *mm;
 	bool has_mm;
@@ -24,6 +28,8 @@ struct deferred_priv {
 	u64 handle;
 	void *stor_var;
 	unsigned long stor_base;
+	unsigned long n_pages_freed;
+	struct notifier_block oom_nb;
 };
 
 static int lazy_destroy = 1;
@@ -200,6 +206,24 @@ static int kvm_s390_pv_deinit_vm_now(struct kvm *kvm, u16 *rc, u16 *rrc)
 	return cc ? -EIO : 0;
 }
 
+static int kvm_s390_pv_oom_notify(struct notifier_block *nb,
+				  unsigned long dummy, void *parm)
+{
+	unsigned long *freed = parm;
+	unsigned long free_before;
+	struct deferred_priv *p;
+
+	if (*freed > 1024)
+		return NOTIFY_OK;
+
+	p = container_of(nb, struct deferred_priv, oom_nb);
+	free_before = READ_ONCE(p->n_pages_freed);
+	msleep(20);
+	*freed += READ_ONCE(p->n_pages_freed) - free_before;
+
+	return NOTIFY_OK;
+}
+
 static int kvm_s390_pv_destroy_vm_thread(void *priv)
 {
 	struct destroy_page_lazy *lazy, *next;
@@ -207,12 +231,20 @@ static int kvm_s390_pv_destroy_vm_thread(void *priv)
 	u16 rc, rrc;
 	int r;
 
+	p->oom_nb.priority = KVM_S390_PV_LAZY_DESTROY_OOM_NOTIFY_PRIORITY;
+	p->oom_nb.notifier_call = kvm_s390_pv_oom_notify;
+	r = register_oom_notifier(&p->oom_nb);
+
 	list_for_each_entry_safe(lazy, next, &p->mm->context.deferred_list, list) {
 		list_del(&lazy->list);
 		s390_uv_destroy_pfns(lazy->count, lazy->pfns);
+		WRITE_ONCE(p->n_pages_freed, p->n_pages_freed + lazy->count + 1);
 		free_page(__pa(lazy));
 	}
 
+	if (!r)
+		unregister_oom_notifier(&p->oom_nb);
+
 	if (p->has_mm) {
 		/* Clear all the pages as long as we are not the only users of the mm */
 		s390_uv_destroy_range(p->mm, 1, 0, TASK_SIZE_MAX);
-- 
2.31.1

