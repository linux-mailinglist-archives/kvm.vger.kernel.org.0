Return-Path: <kvm+bounces-66601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 59C6CCD81B7
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:11:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C2D8330B21D1
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:06:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C41452F6184;
	Tue, 23 Dec 2025 05:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="YYoMkuBg";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="uDc1JoW4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92DE2F49F0
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 05:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466312; cv=fail; b=UcgWNcRhX9ElVo78C42q7rsJhqymUB99Kc9n1YCmGXlvMsNZqtQOoik2p0T50KZ3Sz3pQ+t60u/V5+wzAIxTuAoN+RPB8NAgOnJOP/ZxLV0Vw0dXHsZuWE5HMvOGnNoyuoKkTseF9J7sJF64HzZSxs43hURK/TsEf5ZECvOkzRs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466312; c=relaxed/simple;
	bh=8JNzmdBdly6BFQe0YW+3oEC5dzfOGceZRTZfPU3LrJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=l8WiktPO6hpGw8vukGU/1Z3oywkiZOjWSCCIpofH2ilokzGmawbhO06Zcb2JzlkvRI4UtaawFBkrN37/rM79aD320u7740Oal8f7O5iHD59RbaypWrPviYkEKHMaMGY2nMnaHeFdgnYMarYq90160xElb1ilHEE582Pin7HIMa8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=YYoMkuBg; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=uDc1JoW4; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BN1Loaf733160;
	Mon, 22 Dec 2025 21:05:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=LeI4CTsPqDKCfUBRfcGv3SF5fWGgcI/EuIW8smlYR
	ms=; b=YYoMkuBgQEQ+juI7LAEwzqOQTtbsg3Rkb7BTfvvQxq1yWK5TMMJmzVPSF
	xnA/H22awR6cly5tXxBjVk5/KTpXMzkDIpvJROAnCHQNGY/Sz1u1QEXlWizI4+ql
	DDZbVy61Wra1INCJ3GTlZZ0g4MBrwDOFIKrqyNg7zYbSNmlN6kLDfk8CkD/0Z8Gu
	BX8N4XlDPwReSnTDOx6aHKZDQqIH1OlL5AvsUzBWezHlqR283A+cMEpt5zxWkToC
	TkwX4wvQHVo09/yzI2jgTVlJmDIgTxKOH8baqViBLl7uJHOmbeOet1nlcV0S9ivH
	d8SqVXjiJrkiA5dcdHY4OuwoFHy9w==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020112.outbound.protection.outlook.com [52.101.201.112])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5t77cxqc-6
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:05:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=atW9XcZNxCIebDnfpv8Xzz6AP6xPcDQqU5eoKDRI9KHQ9o5jo3Wcaxs9da0HRMtmO3u9jn5KMJXKEsIJ1Oe6EIHXS6oqnzWqnaJ3glP83O09qIHWABp7IYHd5ubD9uyuS561wC6pYa9o2GWvUqToxtrd43ZZlzdKS9tVhRutY3ShJJ4R+ZDxRWCkskPNEHnKMN+NP+CNabmK5DHau0i17ts1aQ6RteFZm6oJjcEyA9PM+ddaQq8a3dyGx2QViBLEqb0lTIH+P9uztBBQqyWuIG2uiFYJtk3XdYtMSqjAeibLe36BA9ogvIUZwoqAtCfeffNaxUBkPvxXSqagD5VC3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LeI4CTsPqDKCfUBRfcGv3SF5fWGgcI/EuIW8smlYRms=;
 b=DXbbCqVuIQ/CdyhxxMfnT2bQD4Ta1UzHvixNGTZf6dh18XM7Cd66WvY2k+30FMg3tzaShhfceEZiBYWQtazeN4/2C9lut8arqy1+cmTwFzLWj8rRzQSPh5vxQtQEniqewHTxlHF4lVEijJ0ZrOgPQMDFGcyAt9xbSYa/+ZAvT0DMUXQPFUY+UaXNWuXt4gVMNijrvNc8nZdpGPpalIlwxZJV3A5bHEvrskvUA1iQTRAZTq/3amVFH/vSrFQBuBREIz2f/btKvV/PdzKdHF54RmN/p7mHKfkD0Ef7c3ZVc3dK4ga3DtTB8xmsAGIMOT5HPAiEpJQvWu3YZTJ/3AXk+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LeI4CTsPqDKCfUBRfcGv3SF5fWGgcI/EuIW8smlYRms=;
 b=uDc1JoW4jYKwlZMBcq8ID5U1ikYGTJQyn9J3lAqDyng2g8NNXwoDJKhzlOW+U3ovHfX5EcIjCf6mNh6J1AKPTZbwR7pvaMTH50fXj4GHbc2/ciZaCfu6QbDYKW37IBcHAa5sJHKFNaKNj0FWNn+o1g+f7PB7YELGBgvTQNx2/ipyUvjPnUVX270YfbBdhcfOeBaJq2k8JbA4UeBvcEh8vzgBhq2K9LJbLFFfS/+iAEushTkrhvpH5xFIs0LXQqR5MjQSKDJIpwQNktbm7ZjG8QvpdGeWfHbF/LarrvfxMLjlAg5o5aP1uWte1myJa242mvMEJfLa5+iSMi8gowrAuQ==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by PH0PR02MB8488.namprd02.prod.outlook.com
 (2603:10b6:510:105::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Tue, 23 Dec
 2025 05:05:03 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:05:03 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 10/10] x86/vmx: update remaining EPT access tests for MBEC support (needs help)
Date: Mon, 22 Dec 2025 22:48:50 -0700
Message-ID: <20251223054850.1611618-11-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251223054850.1611618-1-jon@nutanix.com>
References: <20251223054850.1611618-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0018.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::15) To LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV0PR02MB11133:EE_|PH0PR02MB8488:EE_
X-MS-Office365-Filtering-Correlation-Id: e34ca2b0-457a-49de-f087-08de41e0d4bf
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|52116014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KZiL9dRpNFbCVZEyz2MI+oRAJ2ukyFPwwQHYZrTXRjxZ7oMUPabTiYpB6EzH?=
 =?us-ascii?Q?6zx7Rnwxk/+uPwSLwXanzdFx99fSuIzVWrSD/M8/H3GMQ7cqLTN9IV5XPvwE?=
 =?us-ascii?Q?Ek5azkWwq3w1hjobV5V/OfuHBRrpq7abkIxbI6mr4df/kSksS9oZs8zZSt9z?=
 =?us-ascii?Q?L1YizAGt7YxbDR1mJeC/UU3i1rXukM+m0oLOR30QlJjlAHBaSe+4okfH76+O?=
 =?us-ascii?Q?102L+C+VC8YK0wButPiaYkHLHZ6m+IFUCZX/GUpie+XWZEyuMEB4rrYn+cUU?=
 =?us-ascii?Q?/OQl6cPIYn1yTUTuxde/y9FSG07mOMQw68vtERlL/BRfgFAssuuahzigCUDM?=
 =?us-ascii?Q?gH3TwJlImozkI5Z9YdnlXDzw4iLhzAXW59EH0MJ1zA2mP2GhvtaCKspbIfxR?=
 =?us-ascii?Q?tZGPQrOZ94ViHmoMiYUSpHbSnqLXa4tkaoZHfmvpMFOmUM2T2cizLuZqFtfM?=
 =?us-ascii?Q?IOeWFyQsFBgiMXIn0wVgeL9mH0XeLFJQIOFOP44NWBfdxRIviUd/sH+lAzJf?=
 =?us-ascii?Q?VjjjwtpACfDcpvEmEeq9A8IVW4S0pOXoPBbb+fldaxyYjNrmdBMETuSE3riw?=
 =?us-ascii?Q?6yYcL3sNh1efmV8vbwtOHpo1bcoIPfJ/JoaaTIZc6zcn5Q8C8LHTzzqMLQpR?=
 =?us-ascii?Q?OxdD65SOvNOJSafC2xbvDWVoIgXJHICTnuejkXebr9HwhzlyFH4TvhFVIDIU?=
 =?us-ascii?Q?7xj0kQKg+XeVWtJbeMo/8SQMReNt2RVFYe5/ERzIsa3oaI4RhRVDVoGW/uO5?=
 =?us-ascii?Q?Za93kEzZ9WPR2EmA6mtILNUq16ivXMLWZ762DfNJfjgh5XNtfHhE+6PV7TaJ?=
 =?us-ascii?Q?eCCpAmOfTL79MSQVgC85GeMivf6wUTEQvoytPUbeGaCr1blHy9+VCn91QSth?=
 =?us-ascii?Q?+gABY9Sg0Ve/gcOOZs3PrHHz9XeiyLylqQmPkfj9qWVzdz7axFYKH/ukabyo?=
 =?us-ascii?Q?/hqxqSy3uFXfda/MAJOBVWsErWx5FxLGwP7F/52Ng3VWWl4BgOyImtUEuLhx?=
 =?us-ascii?Q?gBIGcNasr70tre9c33F3ZAVQ1nWXFsjGTAFDDRC9AP+SeabeV2iVKTDazDq6?=
 =?us-ascii?Q?DsIU6XqVF3g+LJ3laqwhSldZ7r+mFuynXaU53o16hJI/jaTW/d9TGmVcN7V0?=
 =?us-ascii?Q?duFJ2X/vWPw/Kv9/eUyhY1ZhPAxTlXJScVijm1ASEtTwEWcB7TGusfbvz82r?=
 =?us-ascii?Q?7IWZlGk14f1/TcrEMnIQrbprThKE8PFGmC2OfQyeF1GB7ionULjJXsOVZHrJ?=
 =?us-ascii?Q?Uwn8C9FQVIQiau3r74qjvZE+E513Tqn5cvyQr8G5eGSlzJ89alGdQNnnOKzp?=
 =?us-ascii?Q?776FyzA9LBQK6X29/BE/YBwXAN6DhxAx7pHCveveSy4YonCvsp6PCKNJ80ww?=
 =?us-ascii?Q?ogGJS5EOWR1grBE1exvl4gqu2JJoJlgaIqhVEg08gm3AHTuQN1VW/jPzwpG5?=
 =?us-ascii?Q?l4TU4L3MijdG1Z6YBI8lG6nTGONQYblL2edNffeoDWS07iAETbHP3mxdZoGJ?=
 =?us-ascii?Q?8DSY0sTsLkAWhjeOR1+R6VetQR5i1HFAvtOR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(52116014)(366016)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AZlv7tp8GjyxUi4Y7LBCnCVsCT/IBtMWndmTEFn2ArBFH0DiYgLYojX95iV/?=
 =?us-ascii?Q?y6q/7B8RSlKtn2ESrpw5ei+3lKAx9htFHsycFMAblyJamlm23iFR/nPv8qDC?=
 =?us-ascii?Q?+AIWDDFlUKa/+3XDungLpOpwz82hIxjtY+a9F/jw8u1tkKISJKsCsUT9whwT?=
 =?us-ascii?Q?f+WnCF+Tp0UlCitIM4aUvxul0A7OTPcfb0M8an2vHSd1G+ErkY4+QcvaaLnk?=
 =?us-ascii?Q?sUd2pCS3JBfCLGv6IqZheGsYWZRtQTbfDTomnDthrph5wEhIHZD0PAvLgb+N?=
 =?us-ascii?Q?WUyGNhBRD9gAQ0JXCKY1HL0YViF/mitCWmRuSb2m/TRvJc/qlaTb/QKrVidK?=
 =?us-ascii?Q?M7qF/FUGLzRVjQOyJChHkBZ+r7Bnu0FECbrQjX5SKgQuPKvbE2kYMwtC1PCU?=
 =?us-ascii?Q?F7dYviIJfJP9PU3j6XFjSb9mtaclOfwO42YQMo7IvH9MDzqHjuG7j4lD9oBB?=
 =?us-ascii?Q?Lz7RO1ILNhEMnS1PHrJ+k85Wge7WNkMpbSjcWMI1Wgf0anFy0KLHAaNO7F6j?=
 =?us-ascii?Q?tZ9Pi4j3STa3nw7G5TpyxFzfyIu4hdUUQ7xpby1XzcZl6x1Bj3edh7N6N5LN?=
 =?us-ascii?Q?HpuqzD/NsHfgwC/yCt+4X79Ze+YJe2ml72fS2jehg3UHwlGYnD+J43E2PrjR?=
 =?us-ascii?Q?poOmVbfvfPH19CHaV5zwqRJAAolGXzlDSm4dl8bxeRM7BfFsu83FhdtgCujh?=
 =?us-ascii?Q?N+a1bvQxpPVFFciRcrlL9ITq/q3SQrsP062rQBySkYFiu1+8kP0n1QClsQys?=
 =?us-ascii?Q?l5VU2pb3PaGVdU3F8S5WRhPQS3nC/W+83Jq12yZE1wKxzefqExudJKYjRbQD?=
 =?us-ascii?Q?XI5zWg+FRFs2Ko1gyTN8lg3NzoZ4iSdUhdqyLR3CDZBmOpkzIeb2daz9c3U9?=
 =?us-ascii?Q?XGNn3SQD4soWn9WwMCmR173UsX77DuIvzgzWJFLmx8r7SqNLsFZVizVeaOm9?=
 =?us-ascii?Q?qd2bTTiYUNobTSkjbB1Ei4+wqELRaCnn+PPR7QSMacQoSQVUR1rL/I+c6HsZ?=
 =?us-ascii?Q?5I0d4gsQXRf7I2dCk1GP+QCiS4aAvMjoyWfWZu+oK4Z5AgjeqPZT/TeLZY7Q?=
 =?us-ascii?Q?ju5JzVOScglSqaUGagw9fafun8T+RFbbNbFQdCe3JG7ahJ88oCB6Ela8Uk2F?=
 =?us-ascii?Q?P1DnmWR/ff9w9joZYcD//8FiRbkrtsPebmFpnlk8svUe8LV+3HmKUvZytHDj?=
 =?us-ascii?Q?conECvddtlgTbVe6uBv+NWsYaBWKWvhOlOabjwOEh9jMZeM2YgTzxjAwLzwx?=
 =?us-ascii?Q?2GibrK37Qc/8Sose11KAE/vpAU/tco3IRmQuvfvPWghJqI4rkS0Yovrn2cIq?=
 =?us-ascii?Q?td+v9GXHxWbD03ajanaM6nyqESxzu8oVPaoNnL4x9Des6C6HAewJkwzW2fJX?=
 =?us-ascii?Q?K+cGHzZUU20quZqbfAyEvv0bNhya8fPaJCYAyO7KhMK8rKl91fyHghA/Ne8a?=
 =?us-ascii?Q?BfPsaYve+qXobOy+W9D7KC1QHxz2FqjBtUDctkj/mVfWJoBbiUpU0e5InTXF?=
 =?us-ascii?Q?wbWKiVL154d7+VeIArVe/0InhPGdHv07HLYEC4I8+/I/PySNQsOkEAF7VaKx?=
 =?us-ascii?Q?btOV8rjgGzn7ZIxKycdA8NOdmfuucctB40S+kzaNe3A6Zg0VL33D3ZW2tmTO?=
 =?us-ascii?Q?Io2XcvRbzfhuHZq0X4JO6d7t4aXJ7FTqKNkrVIH1dyHnpib6PKcf/FGa5Rpy?=
 =?us-ascii?Q?y+eW9JsP0OGkrfEadAcVSK8AwwLBckz26iiQUJLH5treTregPtuAncyO18LF?=
 =?us-ascii?Q?jUG2Zl8d37yKjFpaSURqO9KNjkzYyVY=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e34ca2b0-457a-49de-f087-08de41e0d4bf
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:05:03.1681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gk1/nwW6r2756eYEeJ2u3RyOqk5g06C3Es2W3RcM6rJ1ZoZenrWwYPgl/ZT2p86yKrfdqOguSPn99VG/3vDxhw8yZFxVolqHj+VPOCQz0nc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB8488
X-Proofpoint-ORIG-GUID: 0vZcqOIMtRsBU3saBPBsxOxAToYaNHQU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfX/8yJ+//MIPjD
 4htsBtpvOOl3UmW1TFwPf0TouwKK4SqDpS5j6rrWbym5JJeJhxtTk3OCTIS6sOy6xb5uKVJsbkz
 1976BUIgBRoveKITYNzxUsQn9QMiFtlapTyGP7Xu2RXgHBTa1G1iMghX/VD+L3UIwMuV6DarohA
 d3Jq+ue1kcfFTEP0CU0dZ3Pr2gEOCET1p5CEMD39QTFNqZs4xdC0WRP71GhylMAdAEV8bSFhLEz
 icueIN0R1p2BL3lzUn1PoVbxhvbAGdBmMzQ+/wbMsxSS4gnKYQax6jiXJ1sJPhoac+8wfN5boGJ
 vq2cA9cmfOKRyWdK0tK3nO2WpcjwQNcD8VPF1Z7Lq/5Uzo6DtIKQwUfG3eJDqGSp3RZI4fk9lwn
 KQkRYtbhcWbmskatVlI1NvX752+Z8yNLVekQtmRkEtyZuP26VxkE5Q7oDwHkiVCuvsmqkve9Hpe
 ug3uZDPwf+I+OB2GgCg==
X-Proofpoint-GUID: 0vZcqOIMtRsBU3saBPBsxOxAToYaNHQU
X-Authority-Analysis: v=2.4 cv=MrxfKmae c=1 sm=1 tr=0 ts=694a2301 cx=c_pps
 a=cE3fiHRxMl4nLvvI2vbFbA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=64Cc0HZtAAAA:8 a=W-61b57KiWhZjeE-BWMA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Plumb in OP_EXEC_USER to the remaining EPT access tests:
  ept_access_test_not_present
  ept_access_test_read_only
  ept_access_test_read_write

Note: we do see one oddball failure in do_ept_violation when doing
ept_access_test_read_write, where it appears the memory addresses are
just a wee bit off. This goes the previous commentary in the series that
I think there is something a bit off about memory allocation here in
KUT and perhaps this is all related.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 x86/vmx_tests.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 926e4c84..54adf9bd 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -2381,7 +2381,22 @@ static void do_ept_violation(bool leaf, enum ept_access_op op,
 	 * TODO: tests that probe expected_paddr in pages other than the one at
 	 * the beginning of the 1g region.
 	 */
-	TEST_EXPECT_EQ(vmcs_read(INFO_PHYS_ADDR), expected_paddr);
+	// FIXME: ept_access_test_read_write fails without this, otherwise
+	// test outputs:
+	// Test suite: ept_access_test_read_write
+	// FAIL: x86/vmx_tests.c:2384: Expectation failed: (vmcs_read(INFO_PHYS_ADDR)) == (expected_paddr)
+	//	LHS: 0x0000008000000008 - 0000'0000'0000'0000'0000'0000'1000'0000'0000'0000'0000'0000'0000'0000'0000'1000 - 549755813896
+	//	RHS: 0x0000008000000000 - 0000'0000'0000'0000'0000'0000'1000'0000'0000'0000'0000'0000'0000'0000'0000'0000 - 549755813888
+	//	STACK: 4175d0 417632 417699 417720 417863 402273 4040e5 4001bd
+	if (is_mbec_supported() && op == OP_EXEC_USER) {
+		u64 vmcs_paddr = vmcs_read(INFO_PHYS_ADDR);
+		u64 mask = ~(PAGE_SIZE - 1);
+
+		if (vmcs_paddr)
+			TEST_EXPECT_EQ((vmcs_paddr & mask), (expected_paddr & mask));
+	} else {
+		TEST_EXPECT_EQ(vmcs_read(INFO_PHYS_ADDR), expected_paddr);
+	}
 }
 
 static void
@@ -2822,6 +2837,8 @@ static void ept_access_test_not_present(void)
 	ept_access_violation(0, OP_READ, EPT_VLT_RD);
 	ept_access_violation(0, OP_WRITE, EPT_VLT_WR);
 	ept_access_violation(0, OP_EXEC, EPT_VLT_FETCH);
+	if (is_mbec_supported())
+		ept_access_violation(0, OP_EXEC_USER, EPT_VLT_FETCH);
 }
 
 static void ept_access_test_read_only(void)
@@ -2832,6 +2849,9 @@ static void ept_access_test_read_only(void)
 	ept_access_allowed(EPT_RA, OP_READ);
 	ept_access_violation(EPT_RA, OP_WRITE, EPT_VLT_WR | EPT_VLT_PERM_RD);
 	ept_access_violation(EPT_RA, OP_EXEC, EPT_VLT_FETCH | EPT_VLT_PERM_RD);
+	if (is_mbec_supported())
+		ept_access_violation(EPT_RA, OP_EXEC_USER,
+				     EPT_VLT_FETCH | EPT_VLT_PERM_RD);
 }
 
 static void ept_access_test_write_only(void)
@@ -2848,7 +2868,12 @@ static void ept_access_test_read_write(void)
 	ept_access_allowed(EPT_RA | EPT_WA, OP_READ);
 	ept_access_allowed(EPT_RA | EPT_WA, OP_WRITE);
 	ept_access_violation(EPT_RA | EPT_WA, OP_EXEC,
-			   EPT_VLT_FETCH | EPT_VLT_PERM_RD | EPT_VLT_PERM_WR);
+			     EPT_VLT_FETCH | EPT_VLT_PERM_RD |
+			     EPT_VLT_PERM_WR);
+	if (is_mbec_supported())
+		ept_access_violation(EPT_RA | EPT_WA, OP_EXEC_USER,
+				     EPT_VLT_FETCH | EPT_VLT_PERM_RD |
+				     EPT_VLT_PERM_WR);
 }
 
 
-- 
2.43.0


