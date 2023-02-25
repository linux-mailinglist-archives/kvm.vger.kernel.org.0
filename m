Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429086A2BBB
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 21:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjBYUte (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Feb 2023 15:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjBYUtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Feb 2023 15:49:33 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3650E5272
        for <kvm@vger.kernel.org>; Sat, 25 Feb 2023 12:49:31 -0800 (PST)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31PJf6BU020594;
        Sat, 25 Feb 2023 12:49:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=A+Sq24P5ZmnRWMrLZdXXUCh5HPjTk17p1yskimpbq+I=;
 b=vqc+wvcnBX7ucibIrUSRyeUkb9+C8n5t8WpaS7qv5ybyMjdNKBJVKsKPbwU1Lq+8BIOz
 zTAy9N9PmqRRA44JdyTJ5ciY3bqvTcb5Vz7AqnReNV4+TOnRsLF4jQgfq5bzVR3Y5g0d
 hC50KokPG7i8o8Bu6/ozm+FIHbnliU8f++VfMZNyUggmvXNUWlMNZzvyCtUC2+zYLTav
 20MdNMNp9rPX01O8Sy/iM1YCTKyLFnREwf7OB5Cg/GgozCNl5gex9FRFzUcfyXlxuEbk
 P+sb17BmWlvVO9aR27cXjXYK4UB3t246Q/OKlsyVU+G23rurA3RUeG/ElgSrNs4t1rFl cg== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3nyf4eguhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 25 Feb 2023 12:49:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBFeDokiCoq6hJbcqVrJCvP+wZHJsAs8mVFvRhOcqyR8ofRZR5UTMBbtmCl3r9TDVIG0UvtVOSqBV18zyFsT9PzjhfwKG01qvuRFSP8BZIN4z2sAZh4C9xwkZbl9YILwBRkzVbspyPUp69S6TvEVgUs+oGb8QeUkDjZJJy5Wj5kCX0LvrbWjyLi25MuVprGwT/sPbmSbSf/5ov+ZtEFEviyyOLpfKbA2cvCgWmy4VIhOqzagfQeTrk56djNmDWaoSdso5kMJszLubxZZOltMmFSsU2Y75FSr4VdZC8iJNHHu1VPM5bqvMWMHrScy3KjMpGZA1ufmsDp/pSe/YeZOVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A+Sq24P5ZmnRWMrLZdXXUCh5HPjTk17p1yskimpbq+I=;
 b=QZjbA5ECOsMZhIUEQldYooGYHuDHzx56M48zlpxBbj9qDFQzMlBA7lYyIRQs6cajaPRCX+A/xejz1FnDlgTY4tDVLu4gNysRxJaKawzuktH+AxIf0m1TN7pGVGXKjZeNOQoY6/EnpXplf2/Uh41fzOhGUyImfgZTd38CKC3YF4vCw4bNafqxEAmZeuMb1t8+TpMvoT/uo1mOaJfmHLFgppdP/4fUpicGCQQ/ObqnPFsZXQMCZz1fOWQNxkPrcBxBKzb7zV7naywbuuh3MRioEuo7gZJJVyT6fodRmWwHD8oWrBMcSD4JvEzcoSWYi9Ml6HdNNKJ2M+EJmCg4LEl1ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A+Sq24P5ZmnRWMrLZdXXUCh5HPjTk17p1yskimpbq+I=;
 b=nSu/1RY6bCQZ8cdR/UUrgo392JAbKMJq5eN8RmRBkBxRdgLwtfah4XJoc4sTU1vHZtv94e1AqjUxcxOn7UEJetVP9IdcdqQ3YMw9cnvDsqvdkn/GeMafB7g++KqULQ8QPl62RzDzvyKbmMRAtuw64UiyYRa1Ab1Amw802N1rmOAGmpzI8E26Jr4UEzDFPp8hqJwADqCG7VowBHJIS58ESBb8CK/pfo2tqV10W5BBPADL8uP+AGa0W0TGXMOpfnx8DC9pH3cPPwAlQzaycpk0sHe4nIbi4Gqv1SLnyNfQLOVJhrkv7XyO2lcGupkkXlfmY4bC0jdZo3ffvTrW/2IVXA==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BN0PR02MB8175.namprd02.prod.outlook.com (2603:10b6:408:163::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Sat, 25 Feb
 2023 20:49:15 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 20:49:15 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        aravind.retnakaran@nutanix.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v8 3/3] KVM: arm64: Dirty quota-based throttling of vcpus
Date:   Sat, 25 Feb 2023 20:48:01 +0000
Message-Id: <20230225204758.17726-4-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20230225204758.17726-1-shivam.kumar1@nutanix.com>
References: <20230225204758.17726-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|BN0PR02MB8175:EE_
X-MS-Office365-Filtering-Correlation-Id: 76348903-cfe6-45ae-fde6-08db1771c1c9
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TaA8fbdl0gdBy/hDA/gc8see5Qbkf9P63B+2yYPtPBJG7sfGXokW6BKmsjQKd5xIrJigzD7nfw1wDTIZfRCE5OqRuKw+I/m6kbKzXOuSsEVdYBVSru3/q7Unl1taMByx2Y9zO6gKTI58QbgbPDbs0OpbvC+XY1d3YNwxTrsMy7QAJ03r0rgXzQqxQ+Lj7pa9ZpHPfKwvSZHq897pc4OGtJLcGovMZbGuJwBZO4rJ6L55Hk27eer5FuIY7TI36A0mKYmGKAgurqYOIiZPjyjtYrtYzHDkUWTvJ+4LDzMrgyh2na6qqpPyFh76YbvChHg5OTdZCOM3AVkUrN96CZE1eb+gmtI8TAkDKBwv9qtZ/ZcgvxZCc/vLH1EduRuijvFISKHO9CbFOpfvEuMazzG3okm5ZySj8V/RVZoHBC4KliLrEKtT0jwOGOrYrKcL8lKuCguBL7fekx9nayDFDMEDjFKo376Omscmgq3AyGRQ3OtDjsunLMEdY9f9PwhH2kTa8rHRrfMvuLxbr7eCCjrEEe+rCqhUeZKRdiJ3NPmQdGCgWqqWNc2GscVWTLNPg5R3dvOp/spM/yjk1VnGiR8Ahr8NEl3Ff49B/spconydLX4bnWm7aUck6wodhJLq86nwiBUPwaFMcIHaAEyotVUkGy10QpG2JWX3PGBbt92GRPO00O3wOpPy/uJG1oK4mfsAhhOYABVj3rjaIdWQDNBG9Sf+KMV+rwBiKdNhlnsNUqg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199018)(36756003)(86362001)(41300700001)(66556008)(66476007)(8676002)(66946007)(4326008)(8936002)(478600001)(6636002)(54906003)(5660300002)(316002)(15650500001)(2906002)(52116002)(83380400001)(38100700002)(38350700002)(6506007)(107886003)(6666004)(6512007)(186003)(26005)(1076003)(6486002)(2616005)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tAv7WG7tsNfFYVdzfp8/wx1df9qBbPGVkaxr7SiW+x1g+hISUtA+f+UOinOA?=
 =?us-ascii?Q?Bx9RRrGkjjk0GsuENt7G/GgrsLSLT+Xd82GiEmU6jsGn8fMNlMOuiawczYHl?=
 =?us-ascii?Q?PYdE1FfTe55PZbudzXP3gfxYrIr5LXmCUxNPPDQ900kdZnfGprYkfMyn2xa5?=
 =?us-ascii?Q?f4HeKq3mZhPgKJwafTd8lazdUwZw9c4arxIQPgtHPVsFbmM5bDRgebT8NCrn?=
 =?us-ascii?Q?CwtAlR02vPEY0m/uN3k4DqNKO9bFLdhXH19nF/4bLyiRlA+8qtipuc9haLL4?=
 =?us-ascii?Q?M/F88wlippEGgbNAZbIxDUBPtquMw8wDtgp94CA/zHbzhslJKIJPge0fyw+c?=
 =?us-ascii?Q?SQpFgYuCMwpLsyCe5P+VdZgeqcem/jBsFpOIXGKX/Xp2Z82cfxjOiAiYa3hh?=
 =?us-ascii?Q?B0jxkfUq9l1IWDLjDm4XLa3TBmc/yA+qdBHEB0sCdE0qufqrzC40zG4/zkrL?=
 =?us-ascii?Q?Aj6UJEWXmQahZm38Xu3cSiST+Fl7iPdW80u50f3nrE+K5N3zmdnnN2cGU/F9?=
 =?us-ascii?Q?2fyaDlCRpRsKhgMxMep6amMaEmyg6SInj6U1FTNEoK8uLfqa0DSZfaqtgKUg?=
 =?us-ascii?Q?Pk/0pU+5FkHogF99F/qoaycg5cJXviSBKWh9Lo35DDepaf0Yiig0KomrYtop?=
 =?us-ascii?Q?dGqeq5a5x1UvhhU2mofOQgn6a0JyfXl+n7vEWiF3C6jBgRAJBUUIlL6bILbD?=
 =?us-ascii?Q?/NpCKJyO3s5pQT83UMEPatd7QR04t/bW2Zkq/FVwLAORev25A9nVqKj5qYk9?=
 =?us-ascii?Q?5yEwyzVqk/cLCs6gA7KEQjbpPQADNCXFzpW4QEXVqSDUVga4CCIy0gJ85HBr?=
 =?us-ascii?Q?LNB08lyg7WKm7GWABPArZ0hdvIntc01GK7PlVj6C/LpL1aQ4lnA7l/Zg7Gbw?=
 =?us-ascii?Q?QO8mjHhlFnwawaOmM34P0Tqx2zCSfIrC23VhUsw7eJ6qz3VsUravzgEvMn7T?=
 =?us-ascii?Q?mAqGY8xqa9pvTlvNXw7v7nk0VIYpnK4sNVLjzo58LU/mJVpK616pqDXgsnqD?=
 =?us-ascii?Q?e1Jg4/khihnr8AsxRAZY4Fh7pDKDd7jGoRs3W1UdgabHhebWM1/GedeGBnJG?=
 =?us-ascii?Q?KLPy6cTW9KbiPy5TTl426uLfNJ7FDkWCLNLRvaZyFNiFs3NozI0be7iDSv9K?=
 =?us-ascii?Q?VJpNi1bRErBf6Wb2nzVfrFL0WJakzwmrnS9zMdqWZU2GB0BKqDk9ApQaWvXr?=
 =?us-ascii?Q?N78QbT4TgK+liHS7vHDG9WB0akfQkIH43K6EWI59xcYISNv1pnwBKj9cZuwB?=
 =?us-ascii?Q?Hp1/zdwN5mxslkVoH/mkwz/CGaVlsAgfGR34gKfJ/Gs3F5BsXyZIewl17KfE?=
 =?us-ascii?Q?sC3ddBVVfOnQwOIhFJThz1CYGE1K3edooTzEb2qaLE6bB09xj5kAZaTzDPpv?=
 =?us-ascii?Q?6jpmkGrHlzgWVXJz5khbPCdyigWrWWX7DbyNDcNAY8+DRWi6qrFosi/TJtwK?=
 =?us-ascii?Q?z0tTAnf2OrgYKKJhwR+FmIS79oNxiW3zY+9BtDikTt+3OzqcI3a+ZmX/ppRG?=
 =?us-ascii?Q?Mk+3lnbmJpNBckPo+MmDIB9ELoc0AoZvKGHephBaPlKVkRVjh/lV4v9oj0OI?=
 =?us-ascii?Q?3OKh7I2/HiFKJKz8gEXMQqYETZbiBoRaDdlK+Ga4K4nmWUftNHVEtu+649sS?=
 =?us-ascii?Q?hg=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76348903-cfe6-45ae-fde6-08db1771c1c9
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 20:49:15.4759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qOmdjCG0LJgvfnA22B09f+KAmWTwMTuqa928vJzF5YtfWPJndB6u/DgzyZtaWwQmZfv+A2s4+7aGmB3D9x9NCSPyrms3IPNSkDmWd0NBn5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB8175
X-Proofpoint-ORIG-GUID: cz9SOLH2F0-VyeYyfnaYC5svpUPdo5I7
X-Proofpoint-GUID: cz9SOLH2F0-VyeYyfnaYC5svpUPdo5I7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-25_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Call update_dirty_quota whenever a page is marked dirty with
appropriate arch-specific page size. Process the KVM request
KVM_REQ_DIRTY_QUOTA_EXIT (raised by update_dirty_quota) to exit to
userspace with exit reason KVM_EXIT_DIRTY_QUOTA_EXHAUSTED.

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 arch/arm64/kvm/Kconfig | 1 +
 arch/arm64/kvm/arm.c   | 7 +++++++
 arch/arm64/kvm/mmu.c   | 3 +++
 3 files changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index ca6eadeb7d1a..8e7dea2c3a9f 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -44,6 +44,7 @@ menuconfig KVM
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select INTERVAL_TREE
+	select HAVE_KVM_DIRTY_QUOTA
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf087..5162b2fc46a1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -757,6 +757,13 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		if (kvm_dirty_ring_check_request(vcpu))
 			return 0;
+
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+		if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
+			vcpu->run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
+			return 0;
+		}
+#endif
 	}
 
 	return 1;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7113587222ff..baf416046f46 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1390,6 +1390,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret) {
 		kvm_set_pfn_dirty(pfn);
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+		update_dirty_quota(kvm, fault_granule);
+#endif
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
 	}
 
-- 
2.22.3

