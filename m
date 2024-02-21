Return-Path: <kvm+bounces-9339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79BEA85E8D6
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 21:12:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9AD851C216B9
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 20:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3621A86637;
	Wed, 21 Feb 2024 20:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="UiUYK64C";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="PuM0B4vn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3CB83CB2
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 20:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708546335; cv=fail; b=p3aowXRYMS+BVpuhcIAob3fdnGvhxvv3xJYB+kpQ6mE7I2B6jmn089b0Rp2ZUsQkoeAgiohbdKVlS0Y9EMwolyPoUHoHcHK+ijadBTuCldaKgSDOzLQ3FiP9TL1WUycGRfZyYR9QgVSz/7/svPy7fRSTDFFIxk2QGOtSDTFuj94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708546335; c=relaxed/simple;
	bh=ovKy9DHo0Yx2y8FJ+BXVlEE4JYVGIjUJFF3k2KWZiTs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DukpogP2JQ4zC0vDc5iBqJCDcdBAfqD6mac78Nua3582qVMbdhA14ieFehfy7xuFfKpvWORmIehADQylmWw0ei+5P7w5x9lISEtVLS5R1IqSk82PAIUhQiYWALWMI6FVy7pvHkjePURnqSXDICrOm5U4eAzFgckHGcyrysvRnpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=UiUYK64C; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=PuM0B4vn; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41LJdcfI003503;
	Wed, 21 Feb 2024 11:53:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	proofpoint20171006; bh=ljnWk6llReTs/Hvun7QWlEoRv4h7EPOFlu/ENa1FL
	ao=; b=UiUYK64Cy6M96CRoB1fC+kz8OJAai5vK2KnCl8XjIYTqrKcnJJVSNmps+
	1NPuR+EiLR+wrWSR0W9utoOBiLYYxFi6Wu523nMYlwsZSiJV4BbJF4Hkhd+PBEJv
	3Kja0Dqkd7MU6jiG7a8cj4Le3mqSzAFglWVDC8HjqpI6oUoxTwebclG7z6GzsmvT
	ygdWJtEayIhb3PvXwUOyEHKrj0P+lS4EhPebxo+1GSVn8jyCs2hLeguuEe1PFo8y
	pwykR4OVa+x7FAS4UakQ2N0rvFRWjDm03C75dcsB54FaRdULZOUmi/2028pL1DpE
	j3h2/xKK4VjINiyPbnlVZV/8DupRg==
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3wd21839v2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Feb 2024 11:53:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=egd0h2d42lYvfdGqRGb4ZVA1dXYHpecyCVjnVtBpejVSYfyM+QtXnDe2s+qRVqqhVlw2TtiCzzgX3IBXA/g9cQZf/xj/veLsOd42R5WI1qt52wijkZbpChRk3DvyQZdnvbmDWfBRJ+P/0xJW5NkyGNeGiyeI/34aMH4mSSRgR0O04ZIuYECC+2L1G4CdJywYmoPLhZOFlY2ccYfVFyHbZ6/aKYqmj4kxXPt8s/QieTdvi3XANA9Pp5HkROJVnaagPr7smwA/C92JFfpHwUHRP+8yhkDqCbdHo/89ly8G8dI218E+0D/0W36X/gZVHv7ny8vMMQAN4zY5m9YZXuxRHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ljnWk6llReTs/Hvun7QWlEoRv4h7EPOFlu/ENa1FLao=;
 b=IFCRpJ5EZvOTcHC1WTz0bwdxFMJ47J8GQU46J33Udfpx0Say+SPX0dboHK79PMuN93PCnnNLhFRg/znlSuQnP8oXaRAdKXeQT5vIMNR1Wy00ZIuLF25P4/K4vHmzSsjGq+UI9yvMDy+v2Xc4otVStQC8rMsdQM+1TICL9bvOjITkGqmjDOhhE16w36bSoshtLK58zFVgez9gJrFePXdPniV23soc8lON3gZ4S9gh7aAWInV/R2iDyfZm2J7Zh/wk0H3Gf1t5Up1NEEVF/cFD6hQfxvpuW2g+hKrkXqLobcQ4/I8SPcSsqfIaW7Vg9ZilXxszGL2FoxOXq9XMPTsy7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljnWk6llReTs/Hvun7QWlEoRv4h7EPOFlu/ENa1FLao=;
 b=PuM0B4vnDsgFB3rOow3gzhqivLtb4RfxYvtE+PGvVcvg4mkMxcYgHxTR7dcFCixM6yrKOwR7ag8va9PkgBI9xQbulPwa4rjcHjL2iXrXb3HOCwZ9WgcbIWaVWo+2syocRrBCO0PlU2qOuHVz3AM9+bmHpoGHWP6veD1AbV6DDbw53GjS8JlcsvLtdg6TzuDC7Y8ys3k52evtPqBEx4hEvFHJxt5QsNb0JBvZ35V1WxOhP6LZdShabpC1EbRDBSi7y8nl3ApNWE+0djVcSqKwSz+DjYWDf8u4wk2k1rTmbenIMtzsI8OkKU4Ad0mLPO1Io0y3VwFKXBqXoM3dlabjQQ==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by LV8PR02MB10213.namprd02.prod.outlook.com (2603:10b6:408:207::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.21; Wed, 21 Feb
 2024 19:53:17 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::4a9b:daa2:2dff:4a60]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::4a9b:daa2:2dff:4a60%3]) with mapi id 15.20.7292.036; Wed, 21 Feb 2024
 19:53:17 +0000
From: Shivam Kumar <shivam.kumar1@nutanix.com>
To: maz@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev,
        yuzenghui@huawei.com, catalin.marinas@arm.com,
        aravind.retnakaran@nutanix.com, carl.waldspurger@nutanix.com,
        david.vrabel@nutanix.com, david@redhat.com, will@kernel.org
Cc: kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v10 2/3] KVM: x86: Dirty quota-based throttling of vcpus
Date: Wed, 21 Feb 2024 19:51:26 +0000
Message-Id: <20240221195125.102479-3-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20240221195125.102479-1-shivam.kumar1@nutanix.com>
References: <20240221195125.102479-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR20CA0013.namprd20.prod.outlook.com
 (2603:10b6:510:23c::27) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|LV8PR02MB10213:EE_
X-MS-Office365-Filtering-Correlation-Id: 83062884-eeb0-4b52-9ea3-08dc3316bf79
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	lffNAEGl2MumGm+BkubKeZFVCnbG3CHq7fM3Zdk99gBVtIV86fHVG71315o82HT0HnwkhI6u3RF+xgO66s8FeuyfOx8jlGJ84PVJQWqWQnLqOSSXeGA+kpm93/Kc2B9IB6KAVlGJiHru6NyMUhb4sZ9SFTJH7h97oNfmJkmcVGEVK+ZbRRVpi9Xj62YOhcjbIYt92suRcCpb6ZDszmlehpW8ijA9a8EclwKDNLQwnIvnOc4KlXlUqyXSxgsndw6r/WMesUhei/fXwdPa1aEDu2bXw1gHv84CiIMmjG9lL2CVvnVYWmrN3cLII7S6uePug37Xw9Ed7mCKkEVQ/55b8K4W50VtJyaSMdPTbJRIfftjnGXPAUi3y+4HxYudzKnOcI/OH1mQO3DTBeuFJJJ83FeohEZ/0pbAINlcVndLKLK6dvrpr4YbGnzdg8dhvI4+E8qquTi8GjdWACccIB08Ui5+pCqFGJxolC2Co2W1eLiXRMHF5ePJXYZb8ewzk+HcsRqb/XB6qD7S+9oYYvJM0n0Zjd20GN4yJqygo1FvJ/mesYozLwCn/JRar8iu45HFDYy8l7Ltp7VcfhH7Nr6L2ffTn7d93M/KcjS6JJw9wCnyX4bg9lZ9oQOD8EBIsbX0TCamfVZCgS9+0rsB1o0s+Q==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38350700005)(921011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?UJGd1iC2lsIuGSFfldx6CkDa8ldzfFnUOBJ3Xl/ZhVAHoVG9C2aGxRJaD7CT?=
 =?us-ascii?Q?aS7pbuSpzREE4e9aNcqap3Qu30vrTD5+WBLXPcy+M/07Ynfzy6v4q3uR1Aqf?=
 =?us-ascii?Q?wHbXxfgHiaewUOR0JzBs/DomgP6LqRNdO24aCJxDi/rzFVrcde9ZVi36yj+F?=
 =?us-ascii?Q?ya88cT0i146Dsvb9tCAePWUik6uj6ogpyqO+cF/LEDmemgNY3rGiwdCxiAEY?=
 =?us-ascii?Q?1Uh92axZDHyQ1YEOxrJLrwTTaV6mtxUBCBjqgoRCWsmI+Vk7CN40jkELU/x7?=
 =?us-ascii?Q?BaUk8MHcPQ/IYVBw2PSGzKZGztORJcRkM2k+1H9sdjlA45NjBBAfBVSs9jfq?=
 =?us-ascii?Q?hjsdsIMWhvf21ZekCp6JCmpfcay2UwC8isqGiIdzTH2IAS/CYJ+gOtt+DtZ7?=
 =?us-ascii?Q?6LI4k+zNjqrj+SKF2lC+DhgNeLUGSV4ISVsV8GoCCR40OLyE4MT8kLZreyr/?=
 =?us-ascii?Q?zyEIt0unEDJasXvWTVHKZ4pEGwPKC9E2dr0EfLSo21X8/rKYK5yPIOcR2tiE?=
 =?us-ascii?Q?Gw7gR0hFbLCIV7fEsTw1qq8uPSl0XQRmRh2W+Qku7+rU3RvKU7liPxeMXX9a?=
 =?us-ascii?Q?y1Ew+colHav/J3Rwmvm8+g78WEajavPeITjfsBZkxQiBoMWzn9KZXG1qHjcG?=
 =?us-ascii?Q?py1zj5kMQp1Fzlk0zM9/IYxPG16Ta3RY3cFvt0/M4JrIASQI4sMGmLCBvewe?=
 =?us-ascii?Q?xUiUIJTD4irp6YFYV5xaA7g2NovCacNKYXQ9O75ogXPnTdLkTDK158o/gv36?=
 =?us-ascii?Q?HvMJyMwllXpc+EmlA8i++7RyaxrP06sv9OS6dsWqXrCAeKZLrgw1vvMJ/l1L?=
 =?us-ascii?Q?l2PyIUz5l7lazyK3d/FwT5PCdjMgz/6Dj6KFrkd3+5AQuga9QU7VmGmTpaXU?=
 =?us-ascii?Q?Qom6dCFRQJzoPhc3HimiX1eSvEnu/nFSE07vRDW8ke4PZ6uDTjAn/yAMfDEV?=
 =?us-ascii?Q?qAjkPuFy5NO7m2aAz5F8R09NnvHVEYhIVlWDaMpSq+dv7FtmE5iNi08Z48Ce?=
 =?us-ascii?Q?uKuV7MwCEmu4Z5tOWE74Xq7xMlYq2QURLXWnB8hrogUSrbFfpcFJwmnfnW1g?=
 =?us-ascii?Q?gx1PLu+ILY/ZVuvhQz5tPEb6ehMh4lBakM4iMPn01tQpSAhHMGx/JEdkBiSG?=
 =?us-ascii?Q?+ZJRPig9nDZvaqy+vYKAHTLLD+Nlu2Sg69aDcotJnewdAW/vnMvJcpeHB4Pl?=
 =?us-ascii?Q?AlNYTxXSqVRTdNbCxm7vwV3a7hgMBNUt9Qmmu8V6ue7RM++bQ7vHV0imHFAL?=
 =?us-ascii?Q?gaYDUwE/pgq7gdaIhV4hwVi0VkXe2Y90SVnyKktk59acVvwLimN14/RztbOT?=
 =?us-ascii?Q?Q2iBZ6S3haLGiuzZv7moUINLd0Se+GtrIeiOP78hnCZhrCxt4XQfLvYqW7LW?=
 =?us-ascii?Q?o5Q35xbyOCKmb4V/+BvatG4JuVkKq6GARTMrSGPXq8JCt3SYNjmToY8r7orb?=
 =?us-ascii?Q?CgtZeYMbN3/64XCpwPG+1vIrifzi4gXwo9xUuXCjoEPcQ5A21/lwKWJFCvS1?=
 =?us-ascii?Q?Hf5gF8VxMxXhzpbn7CsNsvI0b2spUn0rPe6roN35yzUNEsYnUXNgYq+xNGhJ?=
 =?us-ascii?Q?hrrZPaHtstRtm+UXaYRHNHZynEXS84DqA+ilKx3SZ5EUa/K+I55sqTa6kH0Q?=
 =?us-ascii?Q?Wg=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83062884-eeb0-4b52-9ea3-08dc3316bf79
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2024 19:53:17.5375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F00JR3Lfem191N/Uvyv/PvZOpXxzZDYZdIdDnjvGBL002M4fZ5jClOi4OJIUbR08BmLgGYwiYQXbib5cvEqLEkZUSLj4FtxI00JDE8Br7zg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR02MB10213
X-Proofpoint-ORIG-GUID: Hn8zRy3jxy-kTHRU28Ga0AdjY2RNnc_O
X-Proofpoint-GUID: Hn8zRy3jxy-kTHRU28Ga0AdjY2RNnc_O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-21_07,2024-02-21_02,2023-05-22_02
X-Proofpoint-Spam-Reason: safe

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
 arch/x86/kvm/Kconfig    | 1 +
 arch/x86/kvm/mmu/mmu.c  | 6 +++++-
 arch/x86/kvm/mmu/spte.c | 1 +
 arch/x86/kvm/vmx/vmx.c  | 3 +++
 arch/x86/kvm/x86.c      | 6 +++++-
 5 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 87e3da7b0439..791456233f28 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -44,6 +44,7 @@ config KVM
 	select KVM_XFER_TO_GUEST_WORK
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_VFIO
+	select HAVE_KVM_DIRTY_QUOTA
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	help
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2d6cdeab1f8a..fa0b3853ee31 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3397,8 +3397,12 @@ static bool fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu,
 	if (!try_cmpxchg64(sptep, &old_spte, new_spte))
 		return false;
 
-	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte))
+	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte)) {
+		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
+
+		update_dirty_quota(vcpu->kvm, (1L << SPTE_LEVEL_SHIFT(sp->role.level)));
 		mark_page_dirty_in_slot(vcpu->kvm, fault->slot, fault->gfn);
+	}
 
 	return true;
 }
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4a599130e9c9..550f9c1d03af 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -241,6 +241,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
 		/* Enforced by kvm_mmu_hugepage_adjust. */
 		WARN_ON_ONCE(level > PG_LEVEL_4K);
+		update_dirty_quota(vcpu->kvm, (1L << SPTE_LEVEL_SHIFT(level)));
 		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
 	}
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1111d9d08903..e2f8764c16ff 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5864,6 +5864,9 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		 */
 		if (__xfer_to_guest_mode_work_pending())
 			return 1;
+
+		if (kvm_test_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu))
+			return 1;
 	}
 
 	return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 48a61d283406..4f36c0efb542 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10829,7 +10829,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			r = 0;
 			goto out;
 		}
-
+		if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
+			vcpu->run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
+			r = 0;
+			goto out;
+		}
 		/*
 		 * KVM_REQ_HV_STIMER has to be processed after
 		 * KVM_REQ_CLOCK_UPDATE, because Hyper-V SynIC timers
-- 
2.22.3


