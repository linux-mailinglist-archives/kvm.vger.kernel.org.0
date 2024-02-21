Return-Path: <kvm+bounces-9338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF4D85E8A2
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 21:01:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6229D2820E4
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 20:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D18E86AC6;
	Wed, 21 Feb 2024 19:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="lLRH70qj";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Ta7gf/1Q"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D544126F35
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 19:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708545247; cv=fail; b=Gfe6DwProY7JxqlIF9d7UMmea3lVPOh7i7yfT9H+GoquVJ22PEBLT90BSoYeh+NOuxTwjsJnYEZ4JiiF5bUXvZgJMRTxzvmJx4V1uO5S9uQvLUHzg+lE0b0Dmljx8FhjeyymivcgmTtFakIeezvrv4sPPbHu6sNSA6KIGwQunlY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708545247; c=relaxed/simple;
	bh=Tzscmp/jiuDKJ433jbtzU0UCznp84mbfnBUExJDZY7M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XMgGEHW6cDIjWSjt0MjbaHbk7HC2p8f+NRk517oT7aUxntybxnZ/tF7PV3KNW7MN/eAahw4OTbOJFHqqp6nKv1XuqcM3+4MmOZaUaXyx75JW6AbNQavISeTQMv3YSjoK09B/y9DgTIA9xl4eWAeiJjD7zTF/xQbI4vrYXB2a9Cc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=lLRH70qj; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Ta7gf/1Q; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41LJdqpl003996;
	Wed, 21 Feb 2024 11:53:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	proofpoint20171006; bh=MqUNWpX5nuJ3db/znXJ1ZzQQ2f8fN1kr4Gk8v/1Ty
	kM=; b=lLRH70qjk9rQlYYehFyNDAQAae0bkzFw8s/gCuZkf2QTK8tFDVI1fW/RV
	/OUjzgxcG4qZwekA7ss0u9/jg2rf1x7wlvA0NdJa7v+l1DvzVnYW3soLv4vJw74K
	VQOOgQDfZTSSBKXwUrH6m9dKFdui5LWLzPZSBhsRj8er5nHtRRQ36Dyky1n2+riW
	hns1s1YEvRsAOnOR8tI7/FFQMFecEdYj5RViKcnCOPDDVPxd53xXWepTU1mo7Hb8
	UZnQSZDBwSWCTva/bOMtfoP4RiNcRS2XZlYHDfMsgprveV40UMECNnxA4cl1/oh/
	yuVyylEK1byPDU1TanAoW8o0lLD5g==
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3wd21839vv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Feb 2024 11:53:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kksOemrWd6UXhreR0d8lmiHfxAGDcCTVDMHDT9KZn2rYeFCJvMZi56lv48neJF7PL4ax+6fWPjGMxRAWc73FPD2mL6hLNx7MQNycUGu8vZsHIh/+KYBexrLboDHwirDgL8ou3Y2KfteNyU0agZO8y7EEcQH2vyhs6MWbmCXMwXvDcRSU51H4NrhYkjvTpvfPH6gaWgeaRfWwq6wHRHBlTMloYfNgvyMQBZn/8CS8DeW1d6oagM+pUGSvacOKH/sNOIxRs6z1UbscCzCJWSWXLBBDuFCB6wDDOva06UzJRugUIYAzF+TXDf4ByQZcFcfVieVUASQjpFlf3Dri4YYZig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MqUNWpX5nuJ3db/znXJ1ZzQQ2f8fN1kr4Gk8v/1TykM=;
 b=Gt5005TGeluvr2WpInQyHbkLvYrT2+zgo5r913jmguFJTc9pgorHfOQM2Cah7i10I5Vxz6PPZ0qKOHQaiUSirZjWbr8MnplwZ69F0wtE8YT5m8ig1TM0pmgusEPlR/uuUg7NHppbVgbteAHNPQgtKoLz9MBOJkjddKdlnorvmtLVWlWuud5bM+ZRfpE3HKj5bmYZuYUIA12QDtAHb2NRCWjAgvE0hl2Lw55Ume9XtZa18mFlY5Zr7ivcReuQnZ3lZc4wiLcpCT04d8c7gVbc2jHGJQ/jP3yCse05mfE0U8sc/ooxd8yrZCfOKRZAoxioYx5V/stt4bgsTe7x+L28zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MqUNWpX5nuJ3db/znXJ1ZzQQ2f8fN1kr4Gk8v/1TykM=;
 b=Ta7gf/1QlAA1D2Q3mnsKoidB1S5nAQRZluS7wgfxQ+NURq7hNNGlQHHBL9zNajMSZIyV9fbuX1qF8PI0Zfl0Wmd5du6FACakZJQv9ZiK4itrKRVGIzFRMdSL8Qx4fV8ixezSwnkUhYyNFytH/atTVLpHPotn/RVX9evvR+4xyI+k9ZZHir2bOkPUPVrTXiWlsdJINnY/v8X5r/F3v/SStyo2GbCO4X6Xf8ovureoOyPT2Gb+lB0DWuBta0MSvcjO1WAINFzzLDKNsBumQuqvDWJEDPpGz3ekC6EwVCzl4DnSbxT5eKdX3REdz4pa8PMHQx8qg93EZrzl7XBL9fbrxw==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by LV8PR02MB10213.namprd02.prod.outlook.com (2603:10b6:408:207::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.21; Wed, 21 Feb
 2024 19:53:43 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::4a9b:daa2:2dff:4a60]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::4a9b:daa2:2dff:4a60%3]) with mapi id 15.20.7292.036; Wed, 21 Feb 2024
 19:53:43 +0000
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
Subject: [PATCH v10 3/3] KVM: arm64: Dirty quota-based throttling of vcpus
Date: Wed, 21 Feb 2024 19:51:28 +0000
Message-Id: <20240221195125.102479-4-shivam.kumar1@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 31870762-76f0-496f-766f-08dc3316cf0f
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	pp20zQLWlyAlTQnrbUylEM/niWGZWSuCt4TqG0ArwYNvNcIoFQs+rbGGTU+7LeCXvyVjJIf9l7oQFu0QKa7AEyR22KhiEcd70DerLsMsWiRbLz7WhNV6ZfwVygziSBfczLPjj+OsHSHp1ff1cEE2kA+Sw/1HeypUXCUp5QbemitVZlJOTWNVmwBhCvZ+KI2CjvxQajC+ZG3rWOt8G3P3leXJ48Q4iJdpoxkdv8STxVkXasUs/x6pQ1VhcJx+Zuwm/ifA+PbUE6HA7wOGIguGez/1Zmyc5sw9orP2z9Lb2dXnrUMaV3jvirwMU7ooGEg5jWbShMPPzonij7aRF0PoYcHHTfPL2sah9smACia6SkDAWhRABrOXhviHvIR55XgSzL73MXiH5qkgOdWOjV3pXg2uHoLnAp+1mOsd8P6SktxKkL2JG8FF1ebxAXzkSbv642kWSq1T33Wxn7cWnts1o5h5oYM8LoxCOc8d8ZfEjOIzZTWP+fCYLslkkvqJtFUJAiC+Gm4PrCiKOyndcyEviOLiB4j5mpPyBa+SJFnoX4+vwkELoqFZw8NkRmHoEWcrs+JzFW0jW57v18CZ30ouMvdkpPWFpylLlOgYJlDO+LIaqOOZ8M+n5AAQEWqdh768UihXjE/6rZqJufGDWZxFIQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38350700005)(921011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?9TIPJVaNLihv2JaSCfQeCGBvDuxcIXpR8fpcVt43187POE7V8pwKy+VCxTPM?=
 =?us-ascii?Q?TES+CAPaGRA3ikJIqonGpMOxw8a1/0N0Sa+zPVuVWUo+NP4PSVVYF+GJaK0R?=
 =?us-ascii?Q?nU7Ma+UJH7bBPELqcy89pAvOcL67GIFBeMwBM4vQXqIJOdxPo1zvC1RQR3Us?=
 =?us-ascii?Q?8GPkuuD6uydrHw/qhefri50RK9y0Psk79rjVVYk59Qaw7q3URjNkHOzOIjl+?=
 =?us-ascii?Q?Os5sdhKB5BAepNDI1tXi8ttwJ2QKico/6dzEt+hIpuJhcsStNoiFdBqjAoB0?=
 =?us-ascii?Q?h1T51VLJAZrJmeviRhcKoLqSuXXrJl3/y+WOpMsL/oqYGCUGS8f1g5fXG+u8?=
 =?us-ascii?Q?x5I3M9WzCG/yW9xwqQH/KK7UI1FPCIoccSHS4e060CeDShfaKoZsb7CmfYfk?=
 =?us-ascii?Q?+COZ+G2vIsclYO8WMdpSvY3J3XrIwxfrljqlJGhfjFNB1COXQOBh5mudKEmL?=
 =?us-ascii?Q?qu7aai4wlmxLbE2DaTybSBDQD0ADV6geAgPvkjTXRH075KwnQcU+tC7bC3F6?=
 =?us-ascii?Q?wQZdahEpPWqZbPgNTIW/lAvm97rNktXjXqlHxwK6Opv97cezxxd0MdI7/Ody?=
 =?us-ascii?Q?LRgZQO1VqFod4VAAJfqy0XzmpVJrB4bnU8vJyZ/MN+VAvYkf9P80iMQbKNFj?=
 =?us-ascii?Q?Z5rk94fTbHStWmsN8yK3rG8xibOsOej5rK5zgv+QBAuEvCLXs3Io8BFFQiop?=
 =?us-ascii?Q?Nd+bTgT7PAwyDZgboP5/d6lPBiKwRST7Hha0EdFJkroVrn/mqWQGKgFG91dB?=
 =?us-ascii?Q?+OtrOgsofb2h1Ip0eDV01NQ8s1iW6ajZSeSbnYAB+FmqV/fjLslNJlMCXyv1?=
 =?us-ascii?Q?KTMMwHMOt7PegzesU0PHPJbSTPgynS5SYmXJioSu2r+/JCEv01yiyMaugFQk?=
 =?us-ascii?Q?B/lx6vBciTCc7QlkRkKDlFNvHpSeLaVZ94TLYZksANNYx/kx01yHEVDFXqGM?=
 =?us-ascii?Q?WhVTKsdlbcuqOANoKYClpoV+g8856uEIXk8CWaQ0RVFPF/P9vMMSYyZ2v8fT?=
 =?us-ascii?Q?/A/V9QOSBUuoV3Ut+Ggtzt3NYcVqDh3TFo64re4babIN6fRhb1wD0lvDJNpx?=
 =?us-ascii?Q?mPUteWkoSPEY/bDlVukhvFedXcT6ijfuaWzWoWvTMR6oPrsksHPHdhiMQlF+?=
 =?us-ascii?Q?jeatSfkfgV1nFCnW/j0WHyXvvNCbsqngP6dRWjd/ndu2WuMJGbMJD8mzw9VI?=
 =?us-ascii?Q?9NLiY/dCBbbQd5x39M12z0+ugAGHKIrXsJy3RhC1+qczfQLmSz5C0gZh/QcN?=
 =?us-ascii?Q?N6xw86jB8PaWiKbeUb9xRjKL7KQzXSC6ekOO8Evwr41/6he6gjYP//As8i6B?=
 =?us-ascii?Q?mWyzHtwRUgra8erydD08ZeOgffcRw/H+5afLOG+B+6cRh8GAfpYrf3SEolsx?=
 =?us-ascii?Q?1L17tXnaYQtvEj1fObHSq1K6nRSihSlLFR9EYdW76vxcEpDtSBICDfvwBOhL?=
 =?us-ascii?Q?o9ON0pD/5cZfxqua9LTU/3OHJ0NVA+vTnC35NJdgYD1707xzqu0Pitu3rDnj?=
 =?us-ascii?Q?l0bE9l3tLR1hZJ2II3tTXqV+ed0PauVWv9z4Y8qyQpHY2DwetPPQDZHHP5C4?=
 =?us-ascii?Q?raaedvtWJaLEidWUy7exgy2vykUZIbUdNlvHd5GhI0vZamkTKN+4aq0zO+/T?=
 =?us-ascii?Q?NQ=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31870762-76f0-496f-766f-08dc3316cf0f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2024 19:53:43.7277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f31+9wR+AVQIg/CfM2vKIcNTsZ35Bx49E4xDgxOmFgaE2CgFwi9PNnVYzjYZZT/b7VB/T9hGMa7KoOwCeq121/0KHMJNeIWV2yOZCr1/eDY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR02MB10213
X-Proofpoint-ORIG-GUID: e3dFhFhhqFj_hGoROAiaTq44dLiU4du2
X-Proofpoint-GUID: e3dFhFhhqFj_hGoROAiaTq44dLiU4du2
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
 arch/arm64/kvm/Kconfig | 1 +
 arch/arm64/kvm/arm.c   | 5 +++++
 arch/arm64/kvm/mmu.c   | 1 +
 3 files changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 27ca89b628a0..f66d872d0830 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -39,6 +39,7 @@ menuconfig KVM
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select XARRAY_MULTI
+	select HAVE_KVM_DIRTY_QUOTA
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a25265aca432..dde02c372551 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -872,6 +872,11 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		if (kvm_dirty_ring_check_request(vcpu))
 			return 0;
+
+		if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
+			vcpu->run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
+			return 0;
+		}
 	}
 
 	return 1;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d14504821b79..77088bf9a502 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1579,6 +1579,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret) {
 		kvm_set_pfn_dirty(pfn);
+		update_dirty_quota(kvm, vma_pagesize);
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
 	}
 
-- 
2.22.3


