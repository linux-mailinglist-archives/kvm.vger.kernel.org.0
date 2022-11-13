Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1941762711F
	for <lists+kvm@lfdr.de>; Sun, 13 Nov 2022 18:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235391AbiKMRGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 12:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235376AbiKMRGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 12:06:39 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EBB12A98
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 09:06:38 -0800 (PST)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AD5kjr5007869;
        Sun, 13 Nov 2022 09:06:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=mLjmbP86RyBhgt4U1M0zUaOa9t+0w/5410/u/tA2QUY=;
 b=0OpLMBWuWsKyfvLRNUZEGvGlEjDL9IYEqoDptYgkC/9ylfUByogCMM8lQELzHsN5/qcu
 Alm99EVUDjkPUqedNU1pVARFpB6A28iMTzgzgMkwbgLiirGd4dB6TAxEpR5Xpa3wG82/
 ygh5Kgu7J2TvB/3ynt3AhSCpBiLXCby6joPDpSLjjnCa7uSzHVbgu/XnlJrLiKmmUR7d
 pn5q2cpcPts3qPMpCwqpU1DxSHvsPCCIfVXegU2gk9WCc4iyx0CBb7SfJEVB61Rs1B0F
 8xFYjhFGCrE7i+tnPospCz9bc57WB7y0GgS+RwpLv8G3HPy14tljhytn0wnYTZ1kSZ7E gg== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3kthd0sk31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Nov 2022 09:06:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=edjTyhkUcIZdkWQWlSG/84kTmwPUaEMPGXHiNUUkw+d8BaiK1LiKyZaGeaR+Py/aKn7Ly7yADwPoXURRCwab2IEeQIMl1SXb15/gogloRXAB6Q7/IshfTesATVTtd75TcNh9CPm3755r8sukU3pqMrajwB1nxMJamdLIXRjHaHHaXU6tQp2Nu18jTU9wcZDC+2Zc7C2YlLXkgMj51iBwtXVKBZenG+iOtyNh8dNNvsFaQlQ0iV08WpmIplST8HKBn8gN7IXsccdrOpdq/9/dyP/xq4bL0BjtZb/s+Wx1ewVZQsctEpwdcR9wz5AzJuIHbuXsyqN+qc/Br2QGdz+ofg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mLjmbP86RyBhgt4U1M0zUaOa9t+0w/5410/u/tA2QUY=;
 b=QQ8qyws3pxxCqiNAbwwk43ZYa1VswIswFlX2OiK26y2XC5e+2DugUipv+W1b4NvX9aO/aLtz0gUrdObo8zY3bXd4KgQsYF9a9i7CVPqjG3I7D5gW4CtyeC6j/UbUk9LN30+FzxQCJ/9hT4RNgt2oA4yYo8fXogI3sUfP1vYXSGGRX/YL8xsb3QUy86/fYyZ21ugaNykCIXHst4xCeRWNEf9nT+OikLgNT7IkBerpMOFN540FfoVyiTCHtL3zBfjkTSbR7HB3+udt2e+S3FynJRAIeXa+O02qqsYIkBf8/V5K7fRA53LqUcLN5y38lsUabBmG3BZD5+zgfBnj6uXWVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLjmbP86RyBhgt4U1M0zUaOa9t+0w/5410/u/tA2QUY=;
 b=gZKvF4apAX0wSsxoqsUEsb+XtHUuLNCTg+tMJ8Ah20kwUx62ZZ1y3MYLkj5P1MUQBJsyRN67nTwcpmLSSvMkwI8aQHS5m3fPdxMohajBta3c+u2MgAarmR2x/hi155SpSONFmu5Wj/LQh+CTBQjq1QvE8WkIkHLy7nIEybywaNGooXgQjSfDupIdsHB5VGFaS1KP5WaercqVUgmAT/81U6BSp3A4MzpHAmKt145U3gAC+FqZFzUcdoy7BcZzH+OlzXRZeZRKvJERw0u4KFtpr6tKqim6bQTSfAVy8sMTjZO/3brDQwkovzMISGUGXO7M3FZfbY5392xyHzOSWyaItA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY5PR02MB6723.namprd02.prod.outlook.com (2603:10b6:a03:213::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Sun, 13 Nov
 2022 17:06:26 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::74fe:5557:d2d:1f5c]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::74fe:5557:d2d:1f5c%9]) with mapi id 15.20.5813.017; Sun, 13 Nov 2022
 17:06:25 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v7 2/4] KVM: x86: Dirty quota-based throttling of vcpus
Date:   Sun, 13 Nov 2022 17:05:08 +0000
Message-Id: <20221113170507.208810-3-shivam.kumar1@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|BY5PR02MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: 64d7df9c-03e5-4c7c-4e65-08dac59965d6
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +fWtjAXEUHleLgve61d6egFo+YfDrEApsFWz/q94zCMEcdgMemE85Tw92FH6mJNVGxbirQqg/d7LIKyhiWRvF7hHhEBIRv1WjITjfNe7nO/5lyN67lwbftqWj0sV9r6UqJh7w1VjNgXTA1OGVsyVwRkzcitWqXyA3hf4ixFYSF+Y/HH8+CZz6iWnKM6z0DNXPOBt7erEs42m46nXBLOn6pYiUr+JFSKylrzEGaxEUMtPZ3V9R7M4MLlbvfF5Z5/kd5akZaL1X4EVxMoDBSB0SHbsummgxklETlMVcFDT7kPSXE+F7SvvjYlcGg1P9mPXJ9FyCls4QYYEonw5UQqgWftLAwSRSz2xM/7o6Iw0N3Lmj45VMB+pBVdwyUOfEy2QiuUsKrqgsnHaj121msfC2q7vXRB88tic1RKSdPONkanrwonZ9Kco9JRzdgZInAkKTq+cPGaP9DiydQ69VdUbRoP5y2FAxuk2DosV6GyEJao0XLSedQfJDlFG9JajTPt5aoe6CqmLVNFHP9CxDFNu/0uNOeif+J7bANkFUqozx9csG0OHu8n9joMrAW7WTfPOtnL502Icy0KH+cSlwnJkgSrgNBDwQ4y0xvvkIHjYh5rHCChXII1q+NWr9wizrN5TNrDWsdauNXNIVbrEs57kYbfBbIX5fbn5oQ7eidYbR4Dee2BmcxU4cx0P3PKKXqqEJXFd9sV7cFMJXWqKT9PndiPVR3JC8tZhTRBsqXM/YUFzYI7etx+56aeU8Ec4SBia4K5cyReiAUAVJ8rTJBc+QQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(39840400004)(136003)(346002)(366004)(451199015)(186003)(2906002)(15650500001)(38100700002)(38350700002)(86362001)(83380400001)(6486002)(26005)(2616005)(6666004)(6512007)(107886003)(478600001)(6506007)(52116002)(41300700001)(4326008)(5660300002)(8676002)(66476007)(66556008)(66946007)(1076003)(8936002)(54906003)(316002)(36756003)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fOXrNP0ux2URx6dNOv98+VSZ9RbYEtFvGhzUKxlgA2H5IVsIp0epqwYydrtB?=
 =?us-ascii?Q?KLQUxio7RUWKXZb3ZMgE2P/98acXyqOMFBMdDBd9M/O2cU8gbHkXIPL+sjTL?=
 =?us-ascii?Q?Rc5tHBo5x3zqgUfwAuLLRwPvZC0JFDWYC/JOPTGqH/lEsmiW+VWtnUNFXpr1?=
 =?us-ascii?Q?tPrxdDGMG8Wa9xT3bJMetLKsLSPkGoEUwhpXMucbkfJanchO+6SjElT+enAJ?=
 =?us-ascii?Q?yeTmznuS4qslHPR69hA+ZQ0HSDJA0sd/m1r4Y0KZc9VzUa/pxQv7s109QVm9?=
 =?us-ascii?Q?6/j8g0VpMKXlqHyh0zBhC44DzhA85umDvnZdRl310xRDINTLivnrpezsiI1N?=
 =?us-ascii?Q?O8+GzmqyNfkVIkTD2EBofEDwx3tFWQJ2949T25oai60Mc0t+0qn9SgB5APDg?=
 =?us-ascii?Q?/LVpmCfHHsNUiKjwDEdodb5j7xyz+iqvRsvTTxY1+jbb+K+xUNcpKSKdvlS3?=
 =?us-ascii?Q?XJgGwGCiIlDEHIkMkDMukBJiGAkS44YRM+YFgZkm4ZUDTsFlspnvO+axE6CJ?=
 =?us-ascii?Q?7n0YUhDYuWxef//uwqkqetKebvBwcMd8Djq76t7RzKO/j3KwXFYZDsdtLbNk?=
 =?us-ascii?Q?CqZWR07T3tJLX/zI3hEzAL0aAN4/0asmCxA7RcEbWeh8a8/dJ/VmYm/Xauhz?=
 =?us-ascii?Q?8eJ9ZgBXHnGdaYTX+3GvuVwfXe48hRq462RQD6Co9MmVcDYiN4JsoVpa+SDT?=
 =?us-ascii?Q?bDcMr3lxeZ8WTEG1epBV9UM+0d39J8SWPQiW0v0sYYHxKRFmH78IIzTc4z1P?=
 =?us-ascii?Q?D1mBz83HZctkMq9C6iMfPcXyKz1sV9zOw02ZgMHn0auabbQxdpWwLTMCrfvN?=
 =?us-ascii?Q?jwD46Irq57OcWV/K4iGpoOaZ621IZLHublSeEkgpjNl0HxTfzJ8koSC3j9ec?=
 =?us-ascii?Q?lFqAG+8mlcH9mI1Wu1T/ylN89kiGyzwKYvNeSRp7ZOAi6O73TrKKIp6JAmqq?=
 =?us-ascii?Q?7pwOMoelc0d9wEqZDL6uZE8keExZ2dJip4NrfAvDFdb5O33vF/3Z3T5360mo?=
 =?us-ascii?Q?6EBXwSqRFtVi5ScsutYX1Z7I0cHqxBqdWKG43KneBCRv/VoSA461owIk/+ap?=
 =?us-ascii?Q?b9imPDPcWAkTbmUhi8k4BR8MWZt3mkHdOIpNrjkJMlJJpkEMIjSIFo/PcA5+?=
 =?us-ascii?Q?DLscNB/zpNz6upx87UrpbSMz3RlsOFlcQ3KvrwhgBc+uw0/05Rrp7eWXwHkf?=
 =?us-ascii?Q?67AukbuxR/Ns9Jt56eDlCnaIPMK2+/90eRw8sL0eswJFRrVmzDUNVF9/jC0/?=
 =?us-ascii?Q?v9CoU2McbSZ0NFYLL+dSRgIyhOLL3VYM0UUYNzeFWpzI2QyS3qTSBkOaqn+9?=
 =?us-ascii?Q?VNucsP1MVdJyhbHZrb4ZfaSBv4LVkWJVYLgU+TIR6Hgrecf4SGfL6ePsLrH6?=
 =?us-ascii?Q?BWKbQaOfBjT7efi3izIRL7eWZYKcIYz7ck7dYa2ZNlSNngpVXCqVTRLkgeSh?=
 =?us-ascii?Q?Ps5R36gIiUqPFSNZVlnR0H2Mp6G79sscDyX79bENIPihXXt+Dsuxvp4sdbBq?=
 =?us-ascii?Q?rm9TZDFKwMMJKA5NHOfkHR/+/mVQAcA15kO8DsG9vhy0QK2RPAX2a3figKgh?=
 =?us-ascii?Q?5TSSmXkJyU4fxlD/djkj49qtBn4Hg+KhdUY6TRylAiqGDOTjyguka2KPFa0b?=
 =?us-ascii?Q?pg=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64d7df9c-03e5-4c7c-4e65-08dac59965d6
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2022 17:06:25.6651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RXj+Pa7UBN/kI1qJB3iawanGJqj/zB3crVxYwAMeqaM1GQ3y4GdPN5eMxzY2mBChnzhLH91M9ArDo+m6jVtIfJYWVQ2VS8Obi82un1AtkUc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6723
X-Proofpoint-GUID: XmLMMn8lGLt-cYWvuFybXKsU-LU0IjJ5
X-Proofpoint-ORIG-GUID: XmLMMn8lGLt-cYWvuFybXKsU-LU0IjJ5
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

Exit to userspace whenever the dirty quota is exhausted (i.e. dirty count
equals/exceeds dirty quota) to request more dirty quota.

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 arch/x86/kvm/mmu/spte.c |  4 ++--
 arch/x86/kvm/vmx/vmx.c  |  3 +++
 arch/x86/kvm/x86.c      | 28 ++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 2e08b2a45361..c0ed35abbf2d 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -228,9 +228,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
 		  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
 
-	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
+	if (spte & PT_WRITABLE_MASK) {
 		/* Enforced by kvm_mmu_hugepage_adjust. */
-		WARN_ON(level > PG_LEVEL_4K);
+		WARN_ON(level > PG_LEVEL_4K && kvm_slot_dirty_track_enabled(slot));
 		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
 	}
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 63247c57c72c..cc130999eddf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5745,6 +5745,9 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		 */
 		if (__xfer_to_guest_mode_work_pending())
 			return 1;
+
+		if (kvm_test_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu))
+			return 1;
 	}
 
 	return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ecea83f0da49..1a960fbb51f4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10494,6 +10494,30 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
 
+static inline bool kvm_check_dirty_quota_request(struct kvm_vcpu *vcpu)
+{
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+	struct kvm_run *run;
+
+	if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
+		run = vcpu->run;
+		run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
+		run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
+		run->dirty_quota_exit.quota = READ_ONCE(run->dirty_quota);
+
+		/*
+		 * Re-check the quota and exit if and only if the vCPU still
+		 * exceeds its quota.  If userspace increases (or disables
+		 * entirely) the quota, then no exit is required as KVM is
+		 * still honoring its ABI, e.g. userspace won't even be aware
+		 * that KVM temporarily detected an exhausted quota.
+		 */
+		return run->dirty_quota_exit.count >= run->dirty_quota_exit.quota;
+	}
+#endif
+	return false;
+}
+
 /*
  * Called within kvm->srcu read side.
  * Returns 1 to let vcpu_run() continue the guest execution loop without
@@ -10625,6 +10649,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			r = 0;
 			goto out;
 		}
+		if (kvm_check_dirty_quota_request(vcpu)) {
+			r = 0;
+			goto out;
+		}
 
 		/*
 		 * KVM_REQ_HV_STIMER has to be processed after
-- 
2.22.3

