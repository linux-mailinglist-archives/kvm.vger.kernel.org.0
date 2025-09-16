Return-Path: <kvm+bounces-57742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E0F0B59E04
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:45:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8873328452
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07B932D0298;
	Tue, 16 Sep 2025 16:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="yKJ6zrvh";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="B301lgbb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C107031E8B7
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041096; cv=fail; b=DyTyj9FY79p/4HvroTPIHPXzQLkp3n7Sgi6eXkRov4HwUFJ7anoGR0kmcGUAi3f7bCMbRVpz/+2wZrCfmgcg2TKAbDn4zH1mzsGc1K0eg+31w9RZiEcnXNg/dEilO4DVXyclVjUP6jrz8HcO/rH47nfOZ7e1nZfJkbbZkIi0iw8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041096; c=relaxed/simple;
	bh=3xW9+pEy6ekaEifzTqlpl+1hnlMYqRqib2Ktag2gPcA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OrXZf3QVYVHeFUQyxrHtYO5wGyRj7Va6suBSy3tyPmuniV0bxzcaV7o/BDo/uUq6pVR+rSnsecZws8v5S8XuYtuApgSGSRJWebk8VSAhaS4thY1BxOvGNjTzG7Sy5zdP6FyLMrstQERb5vhaMf2+ZzloCQKMHL7eV5UV4H9xrFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=yKJ6zrvh; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=B301lgbb; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58G8mwEI3768189;
	Tue, 16 Sep 2025 09:44:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=fBCsSYkc2ae0svuNsZsxIWgL50MmyKldukAfvxAP4
	+g=; b=yKJ6zrvhfKpOgM4dtMUrZeF1oE6ed0q8cn995U4db5V4+5UOrceJNa3v/
	dJfnuFUviB4SbvhpWq/krRzC+3O7iuRhhJAx+904gsuUTu7MFCr4FfbMFMlgg6oN
	39wtAGIGR41WDCN1iFBXSupOmSHblOaT6gug5EHDoI3iqICIskq2gV4N3TCz24ix
	iHPGH73F7f1ZWFqr3g+ZW3enL/hKnmbTnp6DOnYTi9XJQQprI3PFijeOgaN8HCbH
	NOA1BesnnnI+QKPy34FsuNRLOGx/MPaaSYvRNOl+2n8++G5mJrKcq1G+UyuRort7
	8tC/2YRZ0xM8aNiZZBcaHOP/1R+1A==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023143.outbound.protection.outlook.com [40.93.201.143])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 496uaq287s-4
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:44:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mus0BJMJPSxHHXYA5NpUmmhnuevMsAynjsQ0Jz+3IcGxEUYjiTRjiIfwF9UY9i30c5Nu8QlGTLM4Hcshmc+dXYbtG3UVN7guqAdRXiah1igG+04jZIaUvhGXuW4UqylA3tXPQHzl3Pl4YWZ92PCteVuq9Lrh6IrJUV5ff5bG4F7klrockJ8nijp+zRQkwUu3r4kmqOwcwaO9zp7eizxxZcii4TNqwAcmjwjL+Ungn+vj7vp2TnhBpXheqR8bw8+ub668ChDxxhzx53TqQg5jQC8te15bIxLN+KgXk5GsCrhzlJ5DtscbYemI32tM1039kUJsNOntbYaxjAZ6BfAbug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fBCsSYkc2ae0svuNsZsxIWgL50MmyKldukAfvxAP4+g=;
 b=ZwWeypfQgAT2EZq0Dq6nUgp40voAm5lfAsLnLuilKh+vj3/CHHQRSB6NndovghEQogQeFYG6YECBDgLYZLh3Sn6GO62V3W5l2104e5bxPkLb9C81NPD3qCtGVLFZa5jKOpftm93tY9EqGZBj2gODPURRx3+54xfnuajKoIXwYwYqvX3KtzDU1WCuUEHdkzdiztD5u6cvUZTMlqlq3ObeV2PCQvDCg9+ApKwe/3hq/fhL+jKPXJq/AUAxT1IuI62a4p2bu7uUaA06ZxD9W3Bu78eCPFwRYzz/cMcjykDJilBwqHk390hMOUvVUwfvPaghSSoHR7CdVDdAtr7xk23bGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBCsSYkc2ae0svuNsZsxIWgL50MmyKldukAfvxAP4+g=;
 b=B301lgbbd+F/O6mcViz/3MQ5h6tQomVBZ8IcwCH9JlbnzXkoPwccBqH3guSZw/iD7uQAlH0uFw/JCgA0vbqGhY+JKubLp3GVDiSCAAx8KxRVymn+LV2sEti+TIsVLiPEYb0HC1N+qyveq0lwFZKnfql9A4xju2qb0nk6ln1DFT/2R25U+p0D/9VBz66DfY1QWc/ArmWraqbqVfUQAa0wHrwfaJopDLGY2FtqsSRm3KfB7BKwPVkw652C/D5Cd6KcMCxwEtxqSQSV9eAbOJhNyQwjp3/tAx2gWvjP61C3fEbV2moNgPA76tMaRkPTZIfCmh/C568234bhcg49YvJswg==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DS0PR02MB9620.namprd02.prod.outlook.com
 (2603:10b6:8:f7::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 16:44:42 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:44:42 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 03/17] lib: add vmxfeatures.h clone from 6.16
Date: Tue, 16 Sep 2025 10:22:32 -0700
Message-ID: <20250916172247.610021-4-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916172247.610021-1-jon@nutanix.com>
References: <20250916172247.610021-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF00013309.namprd07.prod.outlook.com
 (2603:10b6:518:1::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|DS0PR02MB9620:EE_
X-MS-Office365-Filtering-Correlation-Id: fe44faac-a2fb-4c53-0b46-08ddf54055f1
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZSp55fSAA/WVpbZ+lTEYWtwA371egPMKt9T2pvTIvNvJ0fuH8voGhwJCHGzk?=
 =?us-ascii?Q?TZ0RNsXNXFz5gD3kkyjRNeSYB2+rs3swaPOyK6xH9p1uqvs9G1uecZbEh3Bd?=
 =?us-ascii?Q?VGhPXpiZix60hv7KeBUsrd5DTKiwpuCgTnJoRNp7NtQyHIJKfDTNcEswgHjx?=
 =?us-ascii?Q?7yKSg0WSS3penkXgXVc3UDyxlwdnwyto6D6gxUEwnwJvIEHHYRnIIZpaE2WL?=
 =?us-ascii?Q?O/gu405pc8nD2zVSu1adjPYHQrzZXd771Y74GL6sanihBMgDHl2yUyJOEzPM?=
 =?us-ascii?Q?r2yhh9F+nqcKuSgzdagMIARRk4R6xkxW/8NbJ83tswzgaFNOJL7TnIECCYe3?=
 =?us-ascii?Q?RDRqf6uymRJ8dZ8BiIJmgWmxqQLNP6aIzNEfuzLNMrMZRz+6YmOlxhmR7P9q?=
 =?us-ascii?Q?N1/OzgURDa/vy6s7YMOHybtaiKFvz6DhO+lLI6oUGYK48ePAc2lq2xX+8yaG?=
 =?us-ascii?Q?UYlyX9ohkOqmvJm1NTcVh4oTy9z/em1P9/WkOOtg9qisbxFihfqojbZG6THX?=
 =?us-ascii?Q?KK6Gd6XxABPrgYz4UgpgoIYzq2oC0P1MCeUNMBJq2tyWzYwNg9JPqwzn/LdQ?=
 =?us-ascii?Q?o6VwBjkO4aLSicFVvNHn64tUVKV8I4pla1SnSAR2zeNvl52KnyCa/xihXS/h?=
 =?us-ascii?Q?VsgFtXUk3mozDAyVklHBDTUitIrA2xqllmhXGfDR2oLlxLW/mlW5W2fcHdP5?=
 =?us-ascii?Q?AGYucxnmqBG9Q8z9x/bPYeye+pGH4ohplYyCWsAQq+ZRajvgue/BdwyM0tYD?=
 =?us-ascii?Q?AgSMwtYC0Ey7h2ZWGZmqvvKXHKsJkvq2hvvTkbsnA7KF0qm7Y52ab7xwD47O?=
 =?us-ascii?Q?Q48E4k544FUBeOsSkE+tD8H2llAWLIg/G6FOv34ytg9W8WaEtRioQ3V7pIaC?=
 =?us-ascii?Q?VVCHFzKHsSM3CFxlZMIFiLYxNO2oQgVysgsj/2E0TUiQl6GHEKwnejx3AgMs?=
 =?us-ascii?Q?VTV708yJCrPfeBZPIoYC9PfWjhaBW8wRbDisGBcJR+R9YsDnCK5/Ub/ho6TH?=
 =?us-ascii?Q?6d8KrBGRqr5jubrUqlWr2cmO1jHJ3I8XtuC5U9Ivv+IiHNpq5D/wsExYYMfA?=
 =?us-ascii?Q?orLgcBU+JOlh23GHx3v33vn7940QD8+slDkjIqid7bMAXH7WNpAyjyeAcJAN?=
 =?us-ascii?Q?kI9EeUDt1o1VuF3ABK81ASUlMwbeUtZ7hlzbQFT52k9uQMPC4/pgpYjl2IPt?=
 =?us-ascii?Q?cSQllKCwReFucPSH+gDnkO1PViZr+N8E4x9Vy7GH634vd+vLFJraxM69QAKn?=
 =?us-ascii?Q?ZidTbkkXejcTPQ9ZZ6ROvoQCOYLZ8d5evfnScxU6419rsvJitLpNJupPnjrp?=
 =?us-ascii?Q?wze32Lq8BSpW+rYGncCOTOWhXl8RgEuQnWarf/SKx0o2s8dD+F6xQNORZDJP?=
 =?us-ascii?Q?UOJ9itc8fo6snN5A9nnszP4fmR7PlWJaqWV7MTmSvN37gAcAOz9oJCILXqtk?=
 =?us-ascii?Q?fpTPDuJ0z+Nx/yN87k2DMxNj9a2aVBa+5G9tWyQHctT9LYvLqlZkZg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b4epOYQDyw9/DaLEwlqUubqgu079fAkssweL5dZqrwWKonDPTCXbsI5pJ9B+?=
 =?us-ascii?Q?QTVA9yzmjkHsGQmVvVbylfaO9FnHNHPHK9TWqxMG8iyFhQxeyfbXMSn7DeSf?=
 =?us-ascii?Q?1R/9tP/DcW0lgcld+b809jgOFW1T54shx8LVT+G+PmDrKSMieEK7kk/ly8nv?=
 =?us-ascii?Q?tT2kFq8eKO4/5QTp/W0zFrivRj1SX2e47EtXWx+xq/Ox+N8ISP3ShVQJ4n+b?=
 =?us-ascii?Q?NzJm/Jq7GL4LMdyItrvXEx03XYEBptOgQMbmlyYJteBF6d9yw1lp2Y05lcjv?=
 =?us-ascii?Q?hwDPua5WzF2zdEyXexI6OQzji8duJp1zHpbbGdPjEvwUB2mSbQimzWtu2Lzz?=
 =?us-ascii?Q?vYMgQDxy6fWVAHmpa9972LN1fQdi6PHnaCGDV5znBPvycmzsy/3421lDg55k?=
 =?us-ascii?Q?PSgRhoJvXHr/ES968+riYR/vp8yNcTEUx0QD2z9F2RMSmlVnd+DmF6KjsUiU?=
 =?us-ascii?Q?WFKWXpxlDjVxGzFSd0CqkJ0WJHfBRbmy6bM05zQuL5oIxcZFoWTHN0buYspn?=
 =?us-ascii?Q?PprOZv3yszwLr/A8bKapRirfkLma4cTapXhspb5wmDQBlsnb9dN4lVhrGpui?=
 =?us-ascii?Q?NDM0VqJQ9FY6M3tA89s3mpkDxGUL1ZO2n/bMxwsCyBZdQ7u9eGQPjCkMYfWJ?=
 =?us-ascii?Q?5xjUD+0WEqPvC5IdR34Uy069OEmlWyqxYECFmBkOPJjtxG99iVbFUTkWeksA?=
 =?us-ascii?Q?jbCmO6/IcrbTtCIhkliGcypcw6dwVT0eKJAajNYswYJruixzD4bgg1Iavz2m?=
 =?us-ascii?Q?jh27qOVhzoXXJRJL1JCyJmfan+rZye2QHDsjQUPoJi5AStoHVEWaOuJvfW+5?=
 =?us-ascii?Q?ZZht9ncMv6+Jq8Vx4NsVcobMDWnqp1Z54OccogEn5vLE/m4IeqZjbEGriiNq?=
 =?us-ascii?Q?9Abr1gb9Wev8f0XG3x40FF39ANF/7AFenHq/jTb+Rth26ij6AX+daTSH7Gga?=
 =?us-ascii?Q?Wji1Z5L7450uhhWYfoviTtwiv4B4WKYxtCFCubZPJ5LLsKANhkesOubhPy7I?=
 =?us-ascii?Q?RjuEd9AYV73ZSzan0W7RNBsvisROmeaJ12YbptXVJsfV8qBUxczWM/qLc45v?=
 =?us-ascii?Q?ctKa9k0Wn9q1RABZ7Xb14CVjAFSxHkQzuemq83Ukw5TuOC2Yic+kBADCEjb/?=
 =?us-ascii?Q?1RO4KnP8rDeBohbckcQ0KkaGs7jyDBc6I1EIyMDrUTRtIQGCerFcIC8ZS1iX?=
 =?us-ascii?Q?G7AswNmOTX5xe8iTzJcZIxFlp/6SzxCe7cv3XRemFPdyIclkV9ZREnsmhiiE?=
 =?us-ascii?Q?8MpCbgz5ts2H+iMYvyPkCUzs5um6vdJy1tLf/WPjY1dEP9u/htvyU5HD8ux8?=
 =?us-ascii?Q?y/4d+b2KWV0rZmlmyMGGMGKnDolWYhyXL9Yu+qMYGafxoCX/NZ9NEogqLPdp?=
 =?us-ascii?Q?WzPMQICtLKA0vD9GEHUHdzKCGSl4RXXo1TOF6yMgMsvIDr1K28iHr9WnP1kF?=
 =?us-ascii?Q?zC4kpWSvpwLLIdKj1qZQNWdzT3n7QhHbWZUigTxiZXDDja6OzOy1JU1Itgls?=
 =?us-ascii?Q?DyIAF/lSgykYosJmRVkAAcrL60bpzvENTuO29+ufR+KsjzAdwfyFpTFf+kes?=
 =?us-ascii?Q?ufAE/kRCvbYe+VN8gGtqEgVaxFt8JlrkeMyuEcfF2J++n0NQLmlf5Ta14nz/?=
 =?us-ascii?Q?0w=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe44faac-a2fb-4c53-0b46-08ddf54055f1
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:44:42.6953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +iwwmqN/iMrg4kqUU7HSMh+DoUTJXeMcKnlIOZFrj3b7ls+7icPRtmMUVk08nuwEkJF+PsB6DOenJ22VqzB4TK60RYOLbxglkUG93HBLc8g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9620
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDE1NSBTYWx0ZWRfX/Z10YDsfty/G
 UIFcET9nmVZ/BycnN+ueZK3WKDlvhhjWalcUZAG0ogJdC3BHCfnrQPin57p1l/5Ps7/reG+sGam
 WyYpLUwUofRwIDaAxRQjB6WyX93QWrmeH0l0bsmKq7wRpo067Fri5vn8u03Wel4hZ15qkJjyRfZ
 0mA50oUtjtGkvWlZjXn5CL3xOWslPWfAi+XCysOLh8bSGpoLE3QLXe0Zxz9l6h7fsY4r6KLEgRh
 np9MdrekbH8+Pcj5VNSbB35Azj6xdpBWkRvRK1PNk31bMPh2nEyA6GbWII9bgmBKJLcwL3I5XYe
 MrdvhTwfFiV8YCVAfs4bcvg6sd+3u/4qFLgfp7iv7NG5dR9Y07VUpivtktTUQA=
X-Authority-Analysis: v=2.4 cv=Qppe3Uyd c=1 sm=1 tr=0 ts=68c993fc cx=c_pps
 a=ZOsnctmsBCw54sLOPzIoIA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8
 a=tiTYJ00W6ExQxQOklrkA:9
X-Proofpoint-GUID: v9-SKD9SmM-JXDdqiF_29a0kbEUBxslm
X-Proofpoint-ORIG-GUID: v9-SKD9SmM-JXDdqiF_29a0kbEUBxslm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

Include Linux's arch/x86/include/asm/vmxfeatures.h from [1] into
lib/linux/vmxfeatures.h, to allow definitions in vmx.h to resolve.

[1] 78ce84b ("x86/cpufeatures: Flip the /proc/cpuinfo appearance logic")

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 lib/linux/vmxfeatures.h | 93 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)
 create mode 100644 lib/linux/vmxfeatures.h

diff --git a/lib/linux/vmxfeatures.h b/lib/linux/vmxfeatures.h
new file mode 100644
index 00000000..09b1d7e6
--- /dev/null
+++ b/lib/linux/vmxfeatures.h
@@ -0,0 +1,93 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_VMXFEATURES_H
+#define _ASM_X86_VMXFEATURES_H
+
+/*
+ * Defines VMX CPU feature bits
+ */
+#define NVMXINTS			5 /* N 32-bit words worth of info */
+
+/*
+ * Note: If the comment begins with a quoted string, that string is used
+ * in /proc/cpuinfo instead of the macro name.  Otherwise, this feature bit
+ * is not displayed in /proc/cpuinfo at all.
+ */
+
+/* Pin-Based VM-Execution Controls, EPT/VPID, APIC and VM-Functions, word 0 */
+#define VMX_FEATURE_INTR_EXITING	( 0*32+  0) /* VM-Exit on vectored interrupts */
+#define VMX_FEATURE_NMI_EXITING		( 0*32+  3) /* VM-Exit on NMIs */
+#define VMX_FEATURE_VIRTUAL_NMIS	( 0*32+  5) /* "vnmi" NMI virtualization */
+#define VMX_FEATURE_PREEMPTION_TIMER	( 0*32+  6) /* "preemption_timer" VMX Preemption Timer */
+#define VMX_FEATURE_POSTED_INTR		( 0*32+  7) /* "posted_intr" Posted Interrupts */
+
+/* EPT/VPID features, scattered to bits 16-23 */
+#define VMX_FEATURE_INVVPID		( 0*32+ 16) /* "invvpid" INVVPID is supported */
+#define VMX_FEATURE_EPT_EXECUTE_ONLY	( 0*32+ 17) /* "ept_x_only" EPT entries can be execute only */
+#define VMX_FEATURE_EPT_AD		( 0*32+ 18) /* "ept_ad" EPT Accessed/Dirty bits */
+#define VMX_FEATURE_EPT_1GB		( 0*32+ 19) /* "ept_1gb" 1GB EPT pages */
+#define VMX_FEATURE_EPT_5LEVEL		( 0*32+ 20) /* "ept_5level" 5-level EPT paging */
+
+/* Aggregated APIC features 24-27 */
+#define VMX_FEATURE_FLEXPRIORITY	( 0*32+ 24) /* "flexpriority" TPR shadow + virt APIC */
+#define VMX_FEATURE_APICV	        ( 0*32+ 25) /* "apicv" TPR shadow + APIC reg virt + virt intr delivery + posted interrupts */
+
+/* VM-Functions, shifted to bits 28-31 */
+#define VMX_FEATURE_EPTP_SWITCHING	( 0*32+ 28) /* "eptp_switching" EPTP switching (in guest) */
+
+/* Primary Processor-Based VM-Execution Controls, word 1 */
+#define VMX_FEATURE_INTR_WINDOW_EXITING ( 1*32+  2) /* VM-Exit if INTRs are unblocked in guest */
+#define VMX_FEATURE_USE_TSC_OFFSETTING	( 1*32+  3) /* "tsc_offset" Offset hardware TSC when read in guest */
+#define VMX_FEATURE_HLT_EXITING		( 1*32+  7) /* VM-Exit on HLT */
+#define VMX_FEATURE_INVLPG_EXITING	( 1*32+  9) /* VM-Exit on INVLPG */
+#define VMX_FEATURE_MWAIT_EXITING	( 1*32+ 10) /* VM-Exit on MWAIT */
+#define VMX_FEATURE_RDPMC_EXITING	( 1*32+ 11) /* VM-Exit on RDPMC */
+#define VMX_FEATURE_RDTSC_EXITING	( 1*32+ 12) /* VM-Exit on RDTSC */
+#define VMX_FEATURE_CR3_LOAD_EXITING	( 1*32+ 15) /* VM-Exit on writes to CR3 */
+#define VMX_FEATURE_CR3_STORE_EXITING	( 1*32+ 16) /* VM-Exit on reads from CR3 */
+#define VMX_FEATURE_TERTIARY_CONTROLS	( 1*32+ 17) /* Enable Tertiary VM-Execution Controls */
+#define VMX_FEATURE_CR8_LOAD_EXITING	( 1*32+ 19) /* VM-Exit on writes to CR8 */
+#define VMX_FEATURE_CR8_STORE_EXITING	( 1*32+ 20) /* VM-Exit on reads from CR8 */
+#define VMX_FEATURE_VIRTUAL_TPR		( 1*32+ 21) /* "vtpr" TPR virtualization, a.k.a. TPR shadow */
+#define VMX_FEATURE_NMI_WINDOW_EXITING	( 1*32+ 22) /* VM-Exit if NMIs are unblocked in guest */
+#define VMX_FEATURE_MOV_DR_EXITING	( 1*32+ 23) /* VM-Exit on accesses to debug registers */
+#define VMX_FEATURE_UNCOND_IO_EXITING	( 1*32+ 24) /* VM-Exit on *all* IN{S} and OUT{S}*/
+#define VMX_FEATURE_USE_IO_BITMAPS	( 1*32+ 25) /* VM-Exit based on I/O port */
+#define VMX_FEATURE_MONITOR_TRAP_FLAG	( 1*32+ 27) /* "mtf" VMX single-step VM-Exits */
+#define VMX_FEATURE_USE_MSR_BITMAPS	( 1*32+ 28) /* VM-Exit based on MSR index */
+#define VMX_FEATURE_MONITOR_EXITING	( 1*32+ 29) /* VM-Exit on MONITOR (MWAIT's accomplice) */
+#define VMX_FEATURE_PAUSE_EXITING	( 1*32+ 30) /* VM-Exit on PAUSE (unconditionally) */
+#define VMX_FEATURE_SEC_CONTROLS	( 1*32+ 31) /* Enable Secondary VM-Execution Controls */
+
+/* Secondary Processor-Based VM-Execution Controls, word 2 */
+#define VMX_FEATURE_VIRT_APIC_ACCESSES	( 2*32+  0) /* "vapic" Virtualize memory mapped APIC accesses */
+#define VMX_FEATURE_EPT			( 2*32+  1) /* "ept" Extended Page Tables, a.k.a. Two-Dimensional Paging */
+#define VMX_FEATURE_DESC_EXITING	( 2*32+  2) /* VM-Exit on {S,L}*DT instructions */
+#define VMX_FEATURE_RDTSCP		( 2*32+  3) /* Enable RDTSCP in guest */
+#define VMX_FEATURE_VIRTUAL_X2APIC	( 2*32+  4) /* Virtualize X2APIC for the guest */
+#define VMX_FEATURE_VPID		( 2*32+  5) /* "vpid" Virtual Processor ID (TLB ASID modifier) */
+#define VMX_FEATURE_WBINVD_EXITING	( 2*32+  6) /* VM-Exit on WBINVD */
+#define VMX_FEATURE_UNRESTRICTED_GUEST	( 2*32+  7) /* "unrestricted_guest" Allow Big Real Mode and other "invalid" states */
+#define VMX_FEATURE_APIC_REGISTER_VIRT	( 2*32+  8) /* "vapic_reg" Hardware emulation of reads to the virtual-APIC */
+#define VMX_FEATURE_VIRT_INTR_DELIVERY	( 2*32+  9) /* "vid" Evaluation and delivery of pending virtual interrupts */
+#define VMX_FEATURE_PAUSE_LOOP_EXITING	( 2*32+ 10) /* "ple" Conditionally VM-Exit on PAUSE at CPL0 */
+#define VMX_FEATURE_RDRAND_EXITING	( 2*32+ 11) /* VM-Exit on RDRAND*/
+#define VMX_FEATURE_INVPCID		( 2*32+ 12) /* Enable INVPCID in guest */
+#define VMX_FEATURE_VMFUNC		( 2*32+ 13) /* Enable VM-Functions (leaf dependent) */
+#define VMX_FEATURE_SHADOW_VMCS		( 2*32+ 14) /* "shadow_vmcs" VMREAD/VMWRITE in guest can access shadow VMCS */
+#define VMX_FEATURE_ENCLS_EXITING	( 2*32+ 15) /* VM-Exit on ENCLS (leaf dependent) */
+#define VMX_FEATURE_RDSEED_EXITING	( 2*32+ 16) /* VM-Exit on RDSEED */
+#define VMX_FEATURE_PAGE_MOD_LOGGING	( 2*32+ 17) /* "pml" Log dirty pages into buffer */
+#define VMX_FEATURE_EPT_VIOLATION_VE	( 2*32+ 18) /* "ept_violation_ve" Conditionally reflect EPT violations as #VE exceptions */
+#define VMX_FEATURE_PT_CONCEAL_VMX	( 2*32+ 19) /* Suppress VMX indicators in Processor Trace */
+#define VMX_FEATURE_XSAVES		( 2*32+ 20) /* Enable XSAVES and XRSTORS in guest */
+#define VMX_FEATURE_MODE_BASED_EPT_EXEC	( 2*32+ 22) /* "ept_mode_based_exec" Enable separate EPT EXEC bits for supervisor vs. user */
+#define VMX_FEATURE_PT_USE_GPA		( 2*32+ 24) /* Processor Trace logs GPAs */
+#define VMX_FEATURE_TSC_SCALING		( 2*32+ 25) /* "tsc_scaling" Scale hardware TSC when read in guest */
+#define VMX_FEATURE_USR_WAIT_PAUSE	( 2*32+ 26) /* "usr_wait_pause" Enable TPAUSE, UMONITOR, UMWAIT in guest */
+#define VMX_FEATURE_ENCLV_EXITING	( 2*32+ 28) /* VM-Exit on ENCLV (leaf dependent) */
+#define VMX_FEATURE_BUS_LOCK_DETECTION	( 2*32+ 30) /* VM-Exit when bus lock caused */
+#define VMX_FEATURE_NOTIFY_VM_EXITING	( 2*32+ 31) /* "notify_vm_exiting" VM-Exit when no event windows after notify window */
+
+/* Tertiary Processor-Based VM-Execution Controls, word 3 */
+#define VMX_FEATURE_IPI_VIRT		( 3*32+  4) /* "ipi_virt" Enable IPI virtualization */
+#endif /* _ASM_X86_VMXFEATURES_H */
-- 
2.43.0


