Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 644A6105147
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 12:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKULRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 06:17:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53488 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbfKULRs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Nov 2019 06:17:48 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALBHSBE009806
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 06:17:47 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wcf734mv0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 06:17:47 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 21 Nov 2019 11:17:44 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 21 Nov 2019 11:17:41 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xALBHejQ21823532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 11:17:40 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3937DA4051;
        Thu, 21 Nov 2019 11:17:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2764DA4040;
        Thu, 21 Nov 2019 11:17:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 21 Nov 2019 11:17:40 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id C9B9EE0193; Thu, 21 Nov 2019 12:17:39 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     guro@fb.com
Cc:     akpm@linux-foundation.org, hannes@cmpxchg.org, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        longman@redhat.com, shakeelb@google.com, vdavydov.dev@gmail.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: WARNING bisected (was Re: [PATCH v7 08/10] mm: rework non-root kmem_cache lifecycle management)
Date:   Thu, 21 Nov 2019 12:17:39 +0100
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611231813.3148843-9-guro@fb.com>
References: <20190611231813.3148843-9-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19112111-0016-0000-0000-000002CA4DD7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112111-0017-0000-0000-0000332C1314
Message-Id: <20191121111739.3054-1-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_02:2019-11-21,2019-11-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxlogscore=346 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=1
 impostorscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911210102
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Folks,

I do get errors like the following when running a new testcase in our KVM CI.
The test basically unloads kvm, reloads with with hpage=1 (enable huge page
support for guests on s390) start a guest with libvirt and hugepages, shut the
guest down and unload the kvm module. 

WARNING: CPU: 8 PID: 208 at lib/percpu-refcount.c:108 percpu_ref_exit+0x50/0x58
Modules linked in: kvm(-) xt_CHECKSUM xt_MASQUERADE bonding xt_tcpudp ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ip6table_na>
CPU: 8 PID: 208 Comm: kworker/8:1 Not tainted 5.2.0+ #66
Hardware name: IBM 2964 NC9 712 (LPAR)
Workqueue: events sysfs_slab_remove_workfn
Krnl PSW : 0704e00180000000 0000001529746850 (percpu_ref_exit+0x50/0x58)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
Krnl GPRS: 00000000ffff8808 0000001529746740 000003f4e30e8e18 0036008100000000
           0000001f00000000 0035008100000000 0000001fb3573ab8 0000000000000000
           0000001fbdb6de00 0000000000000000 0000001529f01328 0000001fb3573b00
           0000001fbb27e000 0000001fbdb69300 000003e009263d00 000003e009263cd0
Krnl Code: 0000001529746842: f0a0000407fe        srp        4(11,%r0),2046,0
           0000001529746848: 47000700            bc         0,1792
          #000000152974684c: a7f40001            brc        15,152974684e
          >0000001529746850: a7f4fff2            brc        15,1529746834
           0000001529746854: 0707                bcr        0,%r7
           0000001529746856: 0707                bcr        0,%r7
           0000001529746858: eb8ff0580024        stmg       %r8,%r15,88(%r15)
           000000152974685e: a738ffff            lhi        %r3,-1
Call Trace:
([<000003e009263d00>] 0x3e009263d00)
 [<00000015293252ea>] slab_kmem_cache_release+0x3a/0x70 
 [<0000001529b04882>] kobject_put+0xaa/0xe8 
 [<000000152918cf28>] process_one_work+0x1e8/0x428 
 [<000000152918d1b0>] worker_thread+0x48/0x460 
 [<00000015291942c6>] kthread+0x126/0x160 
 [<0000001529b22344>] ret_from_fork+0x28/0x30 
 [<0000001529b2234c>] kernel_thread_starter+0x0/0x10 
Last Breaking-Event-Address:
 [<000000152974684c>] percpu_ref_exit+0x4c/0x58
---[ end trace b035e7da5788eb09 ]---

I have bisected this to
# first bad commit: [f0a3a24b532d9a7e56a33c5112b2a212ed6ec580] mm: memcg/slab: rework non-root kmem_cache lifecycle management

unmounting /sys/fs/cgroup/memory/ before the test makes the problem go away so
it really seems to be related to the new percpu-refs from this patch.
 
Any ideas?

Christian

