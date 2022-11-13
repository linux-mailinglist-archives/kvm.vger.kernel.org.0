Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9F062711E
	for <lists+kvm@lfdr.de>; Sun, 13 Nov 2022 18:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbiKMRG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 12:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235376AbiKMRGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 12:06:24 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F10DF07
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 09:06:23 -0800 (PST)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AD3QGFQ004849;
        Sun, 13 Nov 2022 09:06:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=A56c02VdrH3MfGj5sJZpfMXsfALRWcPUo0k2Bj8Asu8=;
 b=yDHSjRMuXfUiF09YwSV0Hh3sExNASjJzLVYf4C2TSfd2I/hEJnuz/OQ9FjABpVD82Nlr
 mHHN85r8zHDRgRyJiLUpFKxRhMxLbLU5kIKwbxyl1Dsx9RqMJQDiMluk/IQcH34vCYvC
 kVe7yZ2wYZmFKGCXvPa0FkP6dWCdehsBuDEuk3MzrD1CfKVu3ed1bbR3UKYsh3L32jTW
 pj1y2SCjeyV4Lv7vtVrjv5Omgj2eNGpMdsD2rgZdc72SrGYg/EbvJQ2H+gRk3b1dZlCT
 tJ/TPq5BA1r35PHBJ98SyQ7K7iDbmOpkll+4v+tqmzjq++dfi6TqcraIVijPj1MHFgJc 0A== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3kthd0sk2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Nov 2022 09:06:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jtD86kLGxYPetao/jyGbFhswA7fqPBZgBpw+q9FTuEjIgsLEDhNhhQr4AZcHvuPENsVem4E08659gvHkKc/VvHq8f2iNAdzRD3x52zIGPRtuz7mE15lak+z9Ir1KK64oN40OSaMMLfqak0zMjCfiUeyFyfwsN0kAwZ3Ou6hkhAe/plXI8+ijkeSLdypQIlcgIjAPJaHBXcHh4sm4yPbwirHc1VIgVJZBhpDV44XXPsYjLi6p3bXlMHBSfW2H/w/6a1/QJVURN3+jJOVUzPbbv7Lv7LEYU3TWpZsdJ30c2xH21Vq+z7ef2UeqkG9Xxv8+xuP9VTl4SUximGSdLMMnSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A56c02VdrH3MfGj5sJZpfMXsfALRWcPUo0k2Bj8Asu8=;
 b=dc0WmhXv+gE87X0Mhcf5O0k2VrbHiREDIP+iH2YW74RVXi+JDeYRe04+FDSUL6EksgKbquBX9HBX0TaixkrwGSrVl1PUe8DrwHGi/VFTzcVlPlj9vVJ1quXFfvBMbhEmBL2rmMomnFa5GICuZTN57elXrTHQVGm+Lsy8wIVG3eLiSc35pdvC23Dw6ndXJWSBlmSvKEHH2KkXqvTCLnTTprrue+obItKFkCUT411Jx3vY2nwiRPMcZ4ra5hJ5E5SW8ZPY+j4O/rT3NDeU8TQik1MBbizB8+IRf7zFqEymC3Gsf2CCIA1rK1vrrHAgSMKdJ/lcYceZHQFpR93tPzqVww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A56c02VdrH3MfGj5sJZpfMXsfALRWcPUo0k2Bj8Asu8=;
 b=MtCuDrYvyV59bQwavae/tmPNF8XPLrP8h6pi4RmFHd+f7t1HK7yWzt0nxYHU+PGrLxI5Nw4DPydzf+7pk4jGd/y2yldPYka0stR5eKKfbWrjki3BaD06IBd49Cb9vreWwRR7El+46ywUR/LRpBzUueNxn8IYWP1+cdjIN76sxz2XOXRRUU4e/dwl0TDwkAhKjuFMQ7g8ZBkFx2G5KU1hr81zyj7nYxTh41v630Nz7H1l5UV0hs8v9ZJMK8z1APepRUioLp9NGRxjvJhZmkytHmQ7CvF8bpJBp6TVhtlUr1u2SAlszdIDHV8/co0ZsAwqrXY4F00dAy0/V5++PKrscw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DM6PR02MB7004.namprd02.prod.outlook.com (2603:10b6:5:22e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Sun, 13 Nov
 2022 17:06:03 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::74fe:5557:d2d:1f5c]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::74fe:5557:d2d:1f5c%9]) with mapi id 15.20.5813.017; Sun, 13 Nov 2022
 17:06:03 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v7 1/4] KVM: Implement dirty quota-based throttling of vcpus
Date:   Sun, 13 Nov 2022 17:05:06 +0000
Message-Id: <20221113170507.208810-2-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::20) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|DM6PR02MB7004:EE_
X-MS-Office365-Filtering-Correlation-Id: ad88ede5-0588-4916-ea84-08dac5995875
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Myd/zgYOBk1Mb9dhLNAO4PRYFSaQMZAu34+aSKXjL8IQF2e6kgMAnZqAXFEbXmmLEUYYoZTHqwVDn/UCJxDzATCtIrIE3wvjI+NE9EgigesfLZ3BNiGlsOfcqe2O7m4BfKFpz/xeFqeTaQmBnMtPGdM8dsGcvpdkPKp7PbnTma/PcMUGTNlifeY3zi5sIhR/DIeDi1LIZu+tq2JqukgoJmMoocL42uI7/hM8K5mXkwy9rYkIsO50mX3xXfNHPUJzqZTxE9jKUdQa107AInTYrF3AnNYKkn6XaPxVFbUEGYJ6Ncw0kl9h3EnHbyR1iEkwn5eYByzBl1eViARGgtmYNacxG2rGhS8TKoUsSY6MvGJlgA1WlKqyKpKStU2XZUpsZdF7ORVFTWqkLpSxKgVlZzgttseFX3Oj84isQ/zsGAwSZeXyY5AmBfHXUjTNulZ8XEOfhYuU4FLXcHQ3umvJZKmVuKqgpt5zGuzvxl369u3vjKoeb8G84tu/5sLriP4O1+GaXzty38RNwpV431Yzuh9lqv5f8MK5/AO9iK0n3HP9B9w9hsLKUD9TZxsDBOJl1hP13/auEFdSYAsmiY6K018EXeq4zzbeFVjdJDOqY2WdpinB/kExZ/XMQYEAs7ILof2pJML9PXCjTXRc86Q9EAAtsvd3qzAr+tkjB3OgfghjvnRrfPHP1WdgbTt3PTzhli46I+P5a/9zmegT+UwMQoYzYMcfeZ+m6x1Xm4aB4ani096I4kt18d+21DXdpeG39oyrtIChs0ZKr7oHgi2EJj+f3dmqzuSp13cvvk/hybeKtYeQBZz+EkKdkqC6ZaFH93jdJgaMDCdj9Pox8FHw0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(366004)(346002)(376002)(396003)(136003)(451199015)(186003)(83380400001)(2616005)(1076003)(86362001)(6486002)(478600001)(966005)(52116002)(6512007)(6506007)(107886003)(38100700002)(38350700002)(26005)(41300700001)(4326008)(316002)(66946007)(66556008)(66476007)(8676002)(5660300002)(15650500001)(54906003)(2906002)(8936002)(36756003)(14143004)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xO49JTcaS7YdSkAK9BgSwOHirpRsyZRBEIIA40kUsaMiBGbkgusILTdlzuMI?=
 =?us-ascii?Q?+kR/U9MWcoNAuR+xl1aP/qGQ2zFaTGsrQ+NKe2HIOai7aU+JJDMu31t4Wi6+?=
 =?us-ascii?Q?bGYkbhMhS7Sd83Z3/TSaKwOuhXbqAa6NFKhJpdGOYnPpivBcw9rKEDmjkUeU?=
 =?us-ascii?Q?lNKoR0ZlYYv+N9lBJ4+uoTyyTgQ046TggrcIzke7pZDpUvX9EI4j6Y1zesQY?=
 =?us-ascii?Q?RLlEDOECs8edCuamkzUignedJxT3YR97uv0tv6rI5hNtC2hNrIpwu8T4gVbm?=
 =?us-ascii?Q?fMSLcTete/dKvt09Krwg0yxT6F0AhvJ2gTFmYtvSXI9yoZRuBMaHi0E0NVcb?=
 =?us-ascii?Q?Q/ZIVcJIVfXaHkl8lLcTxSdIgEy3s+kFrsu/DF7IKaFEN1P5Nc7KOtN0Ueko?=
 =?us-ascii?Q?h2Xx0yQPm/Tm76y1ttsaNGmwIQAkGJN7RSmoDq3SLJnF9J0NH5YAG5VluEEj?=
 =?us-ascii?Q?nAWxjpZRxIJ7o3kF3NHc9hhGiwT6Hv43BcOBJ+uvA8VTWvxZ7504FBjpQo8o?=
 =?us-ascii?Q?MoP53vynSKQSSlb4lKlS8eheuQ2gDYcHPZPEwA/8nqEMhdDe5F/3kXgQurmk?=
 =?us-ascii?Q?uJ4ZaIbknuBZCcsSHqpEDfaYS+WDlNfKv7rqzKQSaipg4n/QEjEfcasyJU/6?=
 =?us-ascii?Q?9aUd5J5DTd5g7Sg0DqVIsKqZg+OVKSwLbNTkVi8Hixye8CWMlunOIb2NuRgb?=
 =?us-ascii?Q?g12BmwCcdIof6HEy+uXwyq+VakwHIsxVOya9D1QaE9Iqg9Eeuf06HvrRpiAV?=
 =?us-ascii?Q?psW63ogl9L54PNW1WQXqctZq7JyeNIvwe8Cuqms+cmnVrOt3Qd1mJ0p0dNY4?=
 =?us-ascii?Q?PtPlkRI8n7d4A6bttFI32WoUcVD1rFpSdBGPvpA6QPC8jDxGn260F1SgeveC?=
 =?us-ascii?Q?xjcPo12Qtl9yVXKE/hEi3C/dtX9B58QxqLvXRprwUlsywIzfOyU5qDwz7BnA?=
 =?us-ascii?Q?7t5Pyu27UR726HIbMKaH161tx8+SvXD9lCnnQSI+0Vfst95IpJSOz9VI5w0p?=
 =?us-ascii?Q?g81h29fCwuaTtSvctCBSgdMZjQBcbPp5B4ILQBNuej8E5Z2EaVK9rDpc0on/?=
 =?us-ascii?Q?xe8TMi2ms3+wnGsAXng9cIZercxbEWbhOg0AJHFxOKrhe4ULfts5nhkH1Q4v?=
 =?us-ascii?Q?nSIHwiqT9hQOGTS+kWcmrDqYgmEjhrYtS2pwsKEvhDzF9WaVnL7trDVPLTyf?=
 =?us-ascii?Q?U7Z4Ep1m3KXngcgaJ3ueY8Pog1h5kTfIcCRlKTwQjRS8IT6dNGDUpzxNZweI?=
 =?us-ascii?Q?MSrSi8DE7Lo96Uh90cT9a53qXWiW4wjp/xlTukMI0Boh3mLzdkHOa78jKd2c?=
 =?us-ascii?Q?Cv5KICeARBX65TcHBBNuthlV/U7xqY6v5y6YZH7sH4o9PaosKwQNB6G/o+pt?=
 =?us-ascii?Q?Cfnl127oYwPSusFndTvng69dlIwSZOOl0Z1RhRZbtg/1FrOuoAiSw/u5dXYH?=
 =?us-ascii?Q?RwJ6PvHhVeq75lH3ZY9gEhFQT6gaQbgWzrKdOcUxZ+XTg9ssOmD8UkRhoWpH?=
 =?us-ascii?Q?CVBAxZs81/FyHGAfNixBWuXUBtDjFtd16GYq04lK7DBGqLBzlY9ML4J6qg89?=
 =?us-ascii?Q?XqDxZAwog4VRbWYpyL0ZBkLO3Sjkl/b9gXoVtd333ceKN3VISR8h37BoZHP2?=
 =?us-ascii?Q?SA=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad88ede5-0588-4916-ea84-08dac5995875
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2022 17:06:03.2543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2QguPRb8H6l1FqAHpzZTw7mqCJJKeei1FZe6jfGi1aJzw3WOsfwdnGkV/B0BVFuILZzBj52QPzTQloKZZ3yqwzmAecTBCLYKX2/+8i3rrCc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB7004
X-Proofpoint-GUID: u6W_RVc2OgynMn7JaceURAK1V-NrlBH_
X-Proofpoint-ORIG-GUID: u6W_RVc2OgynMn7JaceURAK1V-NrlBH_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-13_11,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define variables to track and throttle memory dirtying for every vcpu.

dirty_count:    Number of pages the vcpu has dirtied since its creation,
                while dirty logging is enabled.
dirty_quota:    Number of pages the vcpu is allowed to dirty. To dirty
                more, it needs to request more quota by exiting to
                userspace.

Implement the flow for throttling based on dirty quota.

i) Increment dirty_count for the vcpu whenever it dirties a page.
ii) Exit to userspace whenever the dirty quota is exhausted (i.e. dirty
count equals/exceeds dirty quota) to request more dirty quota.

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 Documentation/virt/kvm/api.rst | 35 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/Kconfig           |  1 +
 include/linux/kvm_host.h       |  5 ++++-
 include/linux/kvm_types.h      |  1 +
 include/uapi/linux/kvm.h       | 13 +++++++++++++
 tools/include/uapi/linux/kvm.h |  1 +
 virt/kvm/Kconfig               |  4 ++++
 virt/kvm/kvm_main.c            | 25 +++++++++++++++++++++---
 8 files changed, 81 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index eee9f857a986..4568faa33c6d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6513,6 +6513,26 @@ array field represents return values. The userspace should update the return
 values of SBI call before resuming the VCPU. For more details on RISC-V SBI
 spec refer, https://github.com/riscv/riscv-sbi-doc.
 
+::
+
+		/* KVM_EXIT_DIRTY_QUOTA_EXHAUSTED */
+		struct {
+			__u64 count;
+			__u64 quota;
+		} dirty_quota_exit;
+
+If exit reason is KVM_EXIT_DIRTY_QUOTA_EXHAUSTED, it indicates that the VCPU has
+exhausted its dirty quota. The 'dirty_quota_exit' member of kvm_run structure
+makes the following information available to the userspace:
+    count: the current count of pages dirtied by the VCPU, can be
+    skewed based on the size of the pages accessed by each vCPU.
+    quota: the observed dirty quota just before the exit to userspace.
+
+The userspace can design a strategy to allocate the overall scope of dirtying
+for the VM among the vcpus. Based on the strategy and the current state of dirty
+quota throttling, the userspace can make a decision to either update (increase)
+the quota or to put the VCPU to sleep for some time.
+
 ::
 
     /* KVM_EXIT_NOTIFY */
@@ -6567,6 +6587,21 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
 ::
 
+	/*
+	 * Number of pages the vCPU is allowed to have dirtied over its entire
+	 * lifetime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if the quota
+	 * is reached/exceeded.
+	 */
+	__u64 dirty_quota;
+
+Please note that enforcing the quota is best effort, as the guest may dirty
+multiple pages before KVM can recheck the quota.  However, unless KVM is using
+a hardware-based dirty ring buffer, e.g. Intel's Page Modification Logging,
+KVM will detect quota exhaustion within a handful of dirtied pages.  If a
+hardware ring buffer is used, the overrun is bounded by the size of the buffer
+(512 entries for PML).
+
+::
   };
 
 
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 67be7f217e37..bdbd36321d52 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -48,6 +48,7 @@ config KVM
 	select KVM_VFIO
 	select SRCU
 	select INTERVAL_TREE
+	select HAVE_KVM_DIRTY_QUOTA
 	select HAVE_KVM_PM_NOTIFIER if PM
 	help
 	  Support hosting fully virtualized guest machines using hardware
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 18592bdf4c1b..0b9b5c251a04 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -151,11 +151,12 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQUEST_NO_ACTION      BIT(10)
 /*
  * Architecture-independent vcpu->requests bit members
- * Bits 3-7 are reserved for more arch-independent bits.
+ * Bits 5-7 are reserved for more arch-independent bits.
  */
 #define KVM_REQ_TLB_FLUSH         (0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_VM_DEAD           (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UNBLOCK           2
+#define KVM_REQ_DIRTY_QUOTA_EXIT  4
 #define KVM_REQUEST_ARCH_BASE     8
 
 /*
@@ -379,6 +380,8 @@ struct kvm_vcpu {
 	 */
 	struct kvm_memory_slot *last_used_slot;
 	u64 last_used_slot_gen;
+
+	u64 dirty_quota;
 };
 
 /*
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 3ca3db020e0e..263a588f3cd3 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -118,6 +118,7 @@ struct kvm_vcpu_stat_generic {
 	u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
 	u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
 	u64 blocking;
+	u64 pages_dirtied;
 };
 
 #define KVM_STATS_NAME_SIZE	48
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0d5d4419139a..5acb8991f872 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -272,6 +272,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_SBI        35
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
+#define KVM_EXIT_DIRTY_QUOTA_EXHAUSTED 38
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -510,6 +511,11 @@ struct kvm_run {
 #define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
 			__u32 flags;
 		} notify;
+		/* KVM_EXIT_DIRTY_QUOTA_EXHAUSTED */
+		struct {
+			__u64 count;
+			__u64 quota;
+		} dirty_quota_exit;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -531,6 +537,12 @@ struct kvm_run {
 		struct kvm_sync_regs regs;
 		char padding[SYNC_REGS_SIZE_BYTES];
 	} s;
+	/*
+	 * Number of pages the vCPU is allowed to have dirtied over its entire
+	 * lifetime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if the
+	 * quota is reached/exceeded.
+	 */
+	__u64 dirty_quota;
 };
 
 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
@@ -1178,6 +1190,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
 #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
+#define KVM_CAP_DIRTY_QUOTA 224
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 0d5d4419139a..c8f811572670 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1178,6 +1178,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
 #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
+#define KVM_CAP_DIRTY_QUOTA 224
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 800f9470e36b..b6418a578c0a 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -19,6 +19,9 @@ config HAVE_KVM_IRQ_ROUTING
 config HAVE_KVM_DIRTY_RING
        bool
 
+config HAVE_KVM_DIRTY_QUOTA
+       bool
+
 # Only strongly ordered architectures can select this, as it doesn't
 # put any explicit constraint on userspace ordering. They can also
 # select the _ACQ_REL version.
@@ -86,3 +89,4 @@ config KVM_XFER_TO_GUEST_WORK
 
 config HAVE_KVM_PM_NOTIFIER
        bool
+
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 25d7872b29c1..7a54438b4d49 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3298,18 +3298,32 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
+static bool kvm_vcpu_is_dirty_quota_exhausted(struct kvm_vcpu *vcpu)
+{
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
+
+	return dirty_quota && (vcpu->stat.generic.pages_dirtied >= dirty_quota);
+#else
+	return false;
+#endif
+}
+
 void mark_page_dirty_in_slot(struct kvm *kvm,
 			     const struct kvm_memory_slot *memslot,
 		 	     gfn_t gfn)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
-#ifdef CONFIG_HAVE_KVM_DIRTY_RING
 	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
 		return;
-#endif
 
-	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
+	if (!memslot)
+		return;
+
+	WARN_ON_ONCE(!vcpu->stat.generic.pages_dirtied++);
+
+	if (kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
@@ -3318,6 +3332,9 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 					    slot, rel_gfn);
 		else
 			set_bit_le(rel_gfn, memslot->dirty_bitmap);
+
+		if (kvm_vcpu_is_dirty_quota_exhausted(vcpu))
+			kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
 	}
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
@@ -4487,6 +4504,8 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_BINARY_STATS_FD:
 	case KVM_CAP_SYSTEM_EVENT_DATA:
 		return 1;
+	case KVM_CAP_DIRTY_QUOTA:
+		return !!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_QUOTA);
 	default:
 		break;
 	}
-- 
2.22.3

