Return-Path: <kvm+bounces-73255-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AKRbDwJermnrCgIAu9opvQ
	(envelope-from <kvm+bounces-73255-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 06:43:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 72F3C233F7A
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 06:43:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 865BC3008080
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 05:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96DAD326928;
	Mon,  9 Mar 2026 05:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ugKKPvFe";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="FMVunTd0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B3E3233E8
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 05:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773034992; cv=fail; b=mya26zhP2ZYvmKAsGqPHw3w2XBR1YBRG+2nXITsH7269pXu4qiOc60Kq21uqN/TglUHpdXOVI7ylJv4xwFEMtXXIjOaRVnnn1FVvZ3FiY11YOjBJWg6Oyg0CerCVqmjcCx/DRheG6E9wz9QgVQLPEzUmUQJNjck+aRM1M+Rzyzs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773034992; c=relaxed/simple;
	bh=kdExb7mOC80xI4EiKX3c//JhnMZjjuzFtUsZE396SiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n3muWP7hUmQGOc24f3Vxu9+5meGzuMmjSnaSSxPQiSFV0ovgBjBPguxM7FOcxAFG5R1Te6/Y/neFGjPnABMUFpL8Zr3PMuQ2LzMop/7xjPeZ0ufQ6BOJE3k40c7WKIyK7l6zotopIT75utFXe6vtv4lrpWbQ5EvQE5Ct4/r6l5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ugKKPvFe; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=FMVunTd0; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 628AnrVj3669525;
	Sun, 8 Mar 2026 22:42:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=gBsLBJYwgKMscQatBszP5HK/JgtX2ntEUZFa0AZFO
	WQ=; b=ugKKPvFeiKDJNUgqa+5Vu57XQFuehe7QLyvln69s+GM8gMEZGn7AlIT81
	+Gv0+rIa64wXXw2rE0YwIkuEW56omeNoFJQioahEzEEhjktBHjhf6yRfjCkKnEss
	yGskmEUv06h/IxaNQr/3OVucf6D47m8xy6VjgW26ACAH8DsOvxyuXYtxfBr4e8/O
	Qa7VtDN1vO1dlBgTte+7UlNp0lIrR5gls9aOSJyYf71a1gI1IkVMPWzIUM9Q0qgK
	Ul26a6tBWyutYIMKNuXNZRRYjOGZ2i3t5UF/ziI4Ls+HxV4qdKEoUfXiODGznaFt
	7VsFIixo9XURfJcpra98T7SrW8nNA==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11022116.outbound.protection.outlook.com [52.101.53.116])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4crh7ttspt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 22:42:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fatJwqSYItukKDApRDO3H5QZMfXqWsAUUjdY7f0cx+mlGARJX2ISodg7OjGDj7MkPnN5CazPKB13h34Sqn6OF5g6ZPc5BZHOJvsO/US0vdAXFtCcHN9p/V5SsMm48KwYi2OtsExb0gKpQiJXFGUau+CjfggCh2DX7KrTk+Ix4BbGU7pct6bBWP2ZYjHAmp2CFxVMsA+b/SRm67GG9Cqb/Xl9fNt7Z5CYouwEI5B+Zy9RXVymPwLpkqF7L1poh65Zl9tfoPJQSNBStd/U78h4FupsTDqCzUYXM6Na9mWSI70ZCfLYiPstRR++skvtnfkrpQvfhWrmlGNfwkHB+ArrAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBsLBJYwgKMscQatBszP5HK/JgtX2ntEUZFa0AZFOWQ=;
 b=NhLi5HB6gfH2tGD8lPKl1HdEK9LLGdhIprUPuFFs0n6AK5B17YBjsLI7s5lMM0JdOIg7xV1wJ6qr8pB7r6fEFYew1yD8xIbJGm+buvxwiCHOx6P0lQLo05mEfBTRAbZSNXSqzsBLtYm5Vl2800O1Z6UL1hUu5nXahuvQeQIsaVSZI6yPtSvrs+gWoliwdfeQnWFKP4M/GKxeejsq9If7h90tyTwQtIrzOlfdxsZ1eyd9wWC4YW/2y1RrXUOBryAhxD6Vq+4GO32blt/arbJrIHOyfP4RTcDIITfr/88KLPW/dkdU0sXemCMLUaGL7NbcUSjCKhDvS4KcE5dpz+aQJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBsLBJYwgKMscQatBszP5HK/JgtX2ntEUZFa0AZFOWQ=;
 b=FMVunTd0PyhssOJf0ubw2KOD17F7OlGQZ7ceyHqJe9J1dhyXE+/efbB08+q/kpjwe56KIfVk9APQxMLytpHiF8At9f2dE9etfnJDVB1Zvul+gi1d/AjOXD5ruimkBkRHEVW7UytPnIizEZWCYs9tJH8ABaffllEbUiB1ukznQSkHJoQfjijqBFJWs6DxSJtyjV1aRpCLk20B62KHvd4sE5O8XH5G/2iJgXv3hEyCd821xUOBNRcxrHC8IaLp2w/h8VFshVno4QdAs97rDleeohOY3EV+amwUh1OikmgfzBJHYoYKNrGVliNcmsKjQjDL1ObO2tqsfqrAtjB379cshw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DM8PR02MB7943.namprd02.prod.outlook.com (2603:10b6:8:14::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Mon, 9 Mar
 2026 05:42:52 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.20.9678.023; Mon, 9 Mar 2026
 05:42:52 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: qemu-devel@nongnu.org
Cc: shaju.abraham@nutanix.com, jon@nutanix.com, mark.caveayland@nutanix.com,
        Khushit Shah <khushit.shah@nutanix.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [RFC PATCH v2 1/1] target/i386/kvm: Configure proper KVM SEOIB behavior
Date: Mon,  9 Mar 2026 05:42:43 +0000
Message-ID: <20260309054243.440453-2-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260309054243.440453-1-khushit.shah@nutanix.com>
References: <20260309054243.440453-1-khushit.shah@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0300.namprd03.prod.outlook.com
 (2603:10b6:610:e6::35) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|DM8PR02MB7943:EE_
X-MS-Office365-Filtering-Correlation-Id: af7badbf-4674-489c-d0f8-08de7d9eb46d
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	9cP6e6cU4PbiPRi1th6RIPsj2+vElPHH+B3/ye359QuIiExBwX3PqaaYbzIJr/wTuZ0Z+tNTfx+MxoGEonOvUDDCT/e38h1fzLsyJBvSQmccPSu9g6hkmW8k58tiRuJO8FR4BbcYjSTVQnCRNqgEyKggtfvNGGjAE7PW6CsFdMzYYL7dHdjsXU9qvCUwdWYsupLYtNcAC8Au2ZKa3f7RK6ZTWJYxRciHZ9d2UDflOWYPBi/T+FBTJMEtHSJbC/Egi6bnjZWZyeFoyczMsPwyuu53hLaLJ9zF4gWDIDaetb441B9MpuwlaPIzJypN5Z7dKEJtgnSEitHH0dD499/MVRcAA8kx4pJDMq8MGRW6IA0ULUDcjVaPkEuaa1Se/jqp12HPCtPXw4vKg/Co0B5eWMyNAu7CdAxVvNyC7d7EGDQ0P4ifEk2lBmVOEey7ENYKCTk9aYcjT7XDAi1Y5Y7A6ptLMWgHf1tkqXWjOf3OFxxEpNOAhy9nS49wfRyq+VPpTv1RcRKayZbAIZhTbOCb5sgsg6A4gKP1IXYC0HZqxhjG6QrxKPt7DoyUerKmgkZbMnI+62ZKZg3RIH3GikLkZuOZtcwd5WVaMkAGxalsdLifkKTGJBglQnnxwnRBw+pzgEZI7nZMImViAUdugR93Uj5XKAKv182oWJStZ6gRq4MghZGy98vGvVXdm6b/ah/lQuDCk6Ac9ScWDvHYdSWd5Rn1m4C0sWmqpictkBprnFg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MLEf4l8wpjZukPgqZCy3i8uMsfabtoyNYC4vsKl2LP2YL4bIptid/t/lLFrE?=
 =?us-ascii?Q?r3H19w9QDfh4O2srYrk9r4M2rU+cLhQAyRHU0MpSXxUB6jCV2cHUbe5Mt/y2?=
 =?us-ascii?Q?xceKRL2jtOjDOPI0Js/sss7byilKEIk8km88A9XjZFRFgfWy1uPeXKe+uWHq?=
 =?us-ascii?Q?i+qj2+OgNryOR0/oL27hHeY/NdGOsE7UnEunhr2+M0NakBAMQJbzOelcHCIM?=
 =?us-ascii?Q?VIWg6Aa5joZncO+e12BYisbQG9Pl2iX/8CsWrc5uUBodMjBrOfY7EgMPMeE8?=
 =?us-ascii?Q?dpSk3UgNuGEiwj59BkSHesf9A9DN9RBagAe4fmeP7aVMJ12ShdRsBUqB8PJU?=
 =?us-ascii?Q?H1v9oekzySLftn9IY5De8hmZ+pM4uY/wOnizGFcIN/YBVZqulPT9r/VdMVia?=
 =?us-ascii?Q?jFlCnNAQga7I+11fiqDJQ20JRi4IW0rcTORoIQi1ebJT7mjOyasxACl9w1Xz?=
 =?us-ascii?Q?4xxPu/QgggcjXNgBgJMSxFNprJVPomI8bwC0hsQTkBFBUriYwj0G3hTPRA+h?=
 =?us-ascii?Q?dBgqQT6eN+O+0RLNuZoY1dNdq0htDfmXbRSV+8uzty+MLie3ujdEKhbMaune?=
 =?us-ascii?Q?OCw/N0i7xVibkUt0vMKyNjiCkYIJFFpbCM8dF0a3SHDrzyM1we75+1HNeWbo?=
 =?us-ascii?Q?loNS5StEBOyVb0BT5CmL3wkStR+5tsGxwZSZCfEgzA9z5MuEpaJIbyckKV5z?=
 =?us-ascii?Q?nNwykwITQB290ptEGkKTMtPqQ54n+vl6eGmLOxjJdqjIdHH6Ias1l8hOVEyU?=
 =?us-ascii?Q?r9X5DPEO1t5vBIlFOovNKsfMo1pvOPtLKIfgIq+4kFwgPPHzQBwSZhRp3mIo?=
 =?us-ascii?Q?7LWNODRqKMynopr4AhEV6jG3jTFmyoDpXuB8rR4hoNuKzXb9zwYyIxOMRyUy?=
 =?us-ascii?Q?kSLxabtxoeAfUrAusTAC1IRV+D9bRmTFSmvhs7ohfWWsq0zsVtOHLMGPgN0i?=
 =?us-ascii?Q?Hpc7AVE24VAyoteiH4cxbSn/+8g/19/cbnhInqF11zxMgiW8XqDjQU64sia7?=
 =?us-ascii?Q?r5SZQi4SJ76K0vyuTGef8Qib4+b7hRK3nVlVOWfPfYRhJUFN634gxQysTjpT?=
 =?us-ascii?Q?1ezU7WF10dzhaUF+5v9Hvel8cRUfFO9yoBKT67r8Aeg8WNTfiBArHuE1An7y?=
 =?us-ascii?Q?UjwKi8qPZ+UJpx3LInB3sgvszeOxblm/eOMxoUzcUHmS/wMMmdEFzszG6BJq?=
 =?us-ascii?Q?qPcHmyMfMWogw0PCxCzfIH6dot4lnDhW5t9Fe2Oj6XeeZlbQavS0bGxjfwqV?=
 =?us-ascii?Q?RQ8GYgGAn24KF2V0wZTbfevRNIhjp+eBFxqB/k5/4MluOp9rzqLZdIg5KE7H?=
 =?us-ascii?Q?8W/RyVP3RRNbH0eKZ52ukVDmQSPp55J/1JpfQf3rU2MBxBt66L2gCvDR+tgu?=
 =?us-ascii?Q?kCVP/NbWDYmNBaLjjHqyk32Rxxgn+ROFQYaJI8nWEa2+H25xPltX2uaUVhVm?=
 =?us-ascii?Q?MOTmS6uqqOS95RocQPQsQkdacjO884/fi+arwP/2mbu2Z5O5VpUDSRhZrTDT?=
 =?us-ascii?Q?tVdw/XM5w5teTOym0l+YXMbXv4kArBWqhA4SqF2hYyKxAfKSlUWQSoo5Sr6T?=
 =?us-ascii?Q?VbMwYazK0n9aZHbPsWOkImu51EtSSgmXIXTlBPaHqZ73VuFVOIVikiits53C?=
 =?us-ascii?Q?Uqqam5AX5mpjaAjRDN8dAhN4+YAP85/LU7oLmHGMev2TC57wZe8IGL/EmBJi?=
 =?us-ascii?Q?dJfpoaqWdKMYW0wL8VkLqQ0XWSR2Sg6IYYMNdlaTK14WXok5GdRtNahYqwGG?=
 =?us-ascii?Q?8F5eWctkoJuyQ2C+/YkazXTRYRKGNgs=3D?=
X-Exchange-RoutingPolicyChecked:
	Rzjp1C6bwBCDYaIQzmGFN+JLZD+XykXIcnUw/D1dP7+2lMOYwiSTruboJZSaEkL1uOZ4VgDl1Z4i0iGDKtQEkLjjsFvHdwszubke/iGRLEooYZQ0zKWzbOAOmgWvORajloxhqfA54fDXTq69rBiZZUxu2Ko0yDFwzXhsP3EG6OnX+bCg9EjN+16L1CqxDX2aU4bREd3nSzFfQzFyGsFL33MwrUSG8dG9ULs3x3Y6Nzeb5urM8fau3UG7ikbFVBtrarlAzErJx08IU+uHGLzTehWghp8F15YsJI3EQrA6CfrqWuWrxuBPxiOf36eouBys6Zo6IjGuD4MoV0VtdhAEpg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af7badbf-4674-489c-d0f8-08de7d9eb46d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 05:42:52.0466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: au83qTospZV+C1Db/I6J8r7yhxcizcyV3F0m8y016INZ95zZI++wIdZ2mdalFlq0AmBUxM2Hy/G4lCm+7zPoTbU2f08JjQGhri2qPzzRpjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR02MB7943
X-Proofpoint-ORIG-GUID: ILjKCK3pfnFQ9iuq2v6gN5QRoyE-X828
X-Authority-Analysis: v=2.4 cv=MdJhep/f c=1 sm=1 tr=0 ts=69ae5ddd cx=c_pps
 a=h/8ALIBrt28BaDiQtk0qcA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22
 a=64Cc0HZtAAAA:8 a=SPKR8aX6tQ3WdjJAWn4A:9
X-Proofpoint-GUID: ILjKCK3pfnFQ9iuq2v6gN5QRoyE-X828
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDA1MCBTYWx0ZWRfXwMlaKcydg/8P
 xdQIOL3EQQT+WxSlrNbSNkV7MgYCUZL4WA5dvN7TKXMir0e+Lj5ZMutj96e8tMWvEThDb0+ZZEm
 oRjNN2lWLd0lJKDn01uV+UIfcpKD2NGrBqBhFaLEIXrsHdSJzuCv+bSxNcdVh1AWwVAuw7OrjDo
 Vl1kXgoiDh2e+ft7k0dupWU1AsWuOH8S/JHd7/VSrsQxp7xA8z5wocBtRzxjH4A96m552AALftk
 9thdRBjXRv7zJml7mRD7Knirtztbg94cV/neXL6LfP75hNLScTWwN26MR1IjacIbar8QkTzG+OC
 KpGsoCxY5pQ/zK23LdUwfVdDQCmhqgvlpZEMBNsCm2qHE6uD8d70EiGeHLXvnec9wDfXeMS+upQ
 fcYlQZaaI9PEFrkFtqa5n6jKznt/pwngXc27QW6Ot3tbKKdqiod5qUJtPmdhcjEpMUImaigaX3U
 36lwwcY3o5W6ICPsZFg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_02,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe
X-Rspamd-Queue-Id: 72F3C233F7A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[nutanix.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[nutanix.com:s=proofpoint20171006,nutanix.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[nutanix.com,redhat.com,gmail.com,linaro.org,habkost.net,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-73255-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[nutanix.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[khushit.shah@nutanix.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nutanix.com:dkim,nutanix.com:email,nutanix.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.998];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

Historically, KVM always advertised x2APIC Suppress EOI Broadcast
(SEOIB) support in split-irqchip mode, This is incorrect for userspace
IOAPIC implementations without an EOI register (e.g. version 0x11).
Furthermore, KVM did not actually honor guest suppression requests and
continued to broadcast LAPIC EOIs to userspace IOAPIC. This can cause
interrupt storms in guests that rely on Directed EOI semantics
(notably Windows with Credential Guard, which experiences boot hangs).

KVM has added two new x2APIC API flags to control this behavior:
  - KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST
  - KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST
commit 6517dfb ("KVM: x86: Add x2APIC "features" to control EOI broadcast suppression")

Wire those flags into QEMU via a new machine-level state variable
(kvm_lapic_seoib_state), which models three possible policies:

  - SEOIB_STATE_QUIRKED:
        Legacy behavior. SEOIB advertised but LAPIC EOIs are
        broadcasted even when guest turns on SEOIB. This is the default
        for backward compatibility.

  - SEOIB_STATE_RESPECTED:
        SEOIB advertised and suppression honored.

  - SEOIB_STATE_NOT_ADVERTISED:
        SEOIB not advertised (required for IOAPIC v0x11).

For new VMs using split-irqchip, QEMU selects a policy based on the
userspace IOAPIC version and programs KVM accordingly during
x86_cpus_init(). If KVM does not support the new API, QEMU falls back
to the quirked behavior with a warning.

SEOIB state is migrated only when non-quirked. Legacy VMs remain in QUIRKED
mode and behave exactly as before. Older VMs that migrate into a newer
QEMU version will also be able to migrate back to an older QEMU version,
as they always stay in the QUIRKED state. VMs powered on with new QEMU and
a new kernel that use a non-quirked SEOIB state will not be able to migrate
to older QEMU versions or older kernels. The state is applied on the
destination in x86_seoib_post_load() to ensure correct KVM configuration
before VM execution resumes.

Additional changes:
  - Add qemu_will_load_snapshot() to detect loadvm scenarios
  - Move IOAPIC_VER_DEF to header for use in x86-common.c
  - Add get_ioapic_version_from_globals() helper
  - Add trace events (kvm_lapic_seoib_*) for debugging

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 hw/i386/x86-common.c         | 99 ++++++++++++++++++++++++++++++++++++
 hw/i386/x86.c                |  1 +
 hw/intc/ioapic.c             |  2 -
 include/hw/i386/x86.h        | 12 +++++
 include/hw/intc/ioapic.h     |  2 +
 include/system/system.h      |  1 +
 system/vl.c                  |  5 ++
 target/i386/kvm/kvm.c        | 43 ++++++++++++++++
 target/i386/kvm/kvm_i386.h   | 12 +++++
 target/i386/kvm/trace-events |  4 ++
 10 files changed, 179 insertions(+), 2 deletions(-)

diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
index a4201126..c93ad6fb 100644
--- a/hw/i386/x86-common.c
+++ b/hw/i386/x86-common.c
@@ -35,9 +35,14 @@
 #include "target/i386/cpu.h"
 #include "hw/rtc/mc146818rtc.h"
 #include "target/i386/sev.h"
+#include "hw/qdev-properties.h"
+#include "hw/intc/ioapic.h"
 
+#include "hw/acpi/cpu_hotplug.h"
 #include "hw/core/irq.h"
 #include "hw/core/loader.h"
+#include "migration/migration.h"
+#include "migration/vmstate.h"
 #include "multiboot.h"
 #include "elf.h"
 #include "standard-headers/asm-x86/bootparam.h"
@@ -66,6 +71,65 @@ out:
     object_unref(cpu);
 }
 
+static uint32_t get_ioapic_version_from_globals(void)
+{
+    Object *tmp = object_new(TYPE_IOAPIC);
+    const GlobalProperty *gp = qdev_find_global_prop(tmp, "version");
+    uint32_t version = 0;
+    if (gp) {
+        qemu_strtoui(gp->value, NULL, 0, &version);
+    } else {
+        version = IOAPIC_VER_DEF;
+    }
+    object_unref(tmp);
+    return version;
+}
+
+static int x86_seoib_post_load(void *opaque, int version_id)
+{
+    X86MachineState *x86ms = opaque;
+
+    if (kvm_enabled() && kvm_irqchip_is_split()) {
+        /* Set KVM LAPIC SEOIB flags based on x86ms->kvm_lapic_seoib_state */
+        if (!kvm_try_set_lapic_seoib_state(x86ms->kvm_lapic_seoib_state)) {
+            /* Migration from newer to older kernel. */
+            error_report("Failed to set KVM LAPIC SEOIB flags");
+            abort();
+        }
+    } else {
+        /*
+         * SEOIB state is only valid for split irqchip mode.
+         * This should never happen.
+         */
+        error_report("SEOIB state is only valid for split irqchip mode.");
+        abort();
+    }
+    return 0;
+}
+
+static bool x86_seoib_needed(void *opaque)
+{
+    /*
+     * Only migrate the SEOIB state if the state is not QUIRKED. This enables
+     * migration from new qemu version to older qemu version.
+     */
+    return kvm_irqchip_is_split() &&
+           ((X86MachineState *)opaque)->kvm_lapic_seoib_state !=
+               SEOIB_STATE_QUIRKED;
+}
+
+static const VMStateDescription vmstate_x86_seoib = {
+    .name = "x86-seoib-state",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .post_load = x86_seoib_post_load,
+    .needed = x86_seoib_needed,
+    .fields = (const VMStateField[]) {
+        VMSTATE_UINT32(kvm_lapic_seoib_state, X86MachineState),
+        VMSTATE_END_OF_LIST()
+    },
+};
+
 void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
 {
     int i;
@@ -75,6 +139,8 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
 
     x86_cpu_set_default_version(default_cpu_version);
 
+    vmstate_register(NULL, 0, &vmstate_x86_seoib, x86ms);
+
     /*
      * Calculates the limit to CPU APIC ID values
      *
@@ -109,6 +175,39 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
         apic_set_max_apic_id(x86ms->apic_id_limit);
     }
 
+    if (kvm_enabled() && kvm_irqchip_is_split()) {
+        /*
+         * If -incoming or -loadvm, then defer the flag setting to later after
+         * the migration/loadvm is complete, but this must be done before apic
+         * state is migrated/loaded. This is done in x86_seoib_post_load. This
+         * is because x2apic api does not have support to unset flags. And, at
+         * this point we cannot determine the incoming SEOIB state.
+         * e.g. for ioapic version 0x20, incoming state can be either RESPECTED
+         * or QUIRKED.
+         *
+         * But for new power-ons, this is right place to set the flags.
+         */
+        if (!runstate_check(RUN_STATE_INMIGRATE) &&
+            !qemu_will_load_snapshot()) {
+            uint32_t ioapic_version = get_ioapic_version_from_globals();
+            if (ioapic_version >= 0x20) {
+                x86ms->kvm_lapic_seoib_state = SEOIB_STATE_RESPECTED;
+            } else {
+                x86ms->kvm_lapic_seoib_state = SEOIB_STATE_NOT_ADVERTISED;
+            }
+
+            /*
+             * Try setting the KVM SEOIB flags if these flags are present
+             * in the kernel.
+             */
+            if (!kvm_try_set_lapic_seoib_state(x86ms->kvm_lapic_seoib_state)) {
+                warn_report("Kernel does not support SEOIB flags; "
+                            "Falling back to QUIRKED lapic SEOIB behavior.");
+                x86ms->kvm_lapic_seoib_state = SEOIB_STATE_QUIRKED;
+            }
+        }
+    }
+
     possible_cpus = mc->possible_cpu_arch_ids(ms);
     for (i = 0; i < ms->smp.cpus; i++) {
         x86_cpu_new(x86ms, possible_cpus->cpus[i].arch_id, &error_fatal);
diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 01872cba..120a7e8a 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -370,6 +370,7 @@ static void x86_machine_initfn(Object *obj)
     x86ms->oem_table_id = g_strndup(ACPI_BUILD_APPNAME8, 8);
     x86ms->bus_lock_ratelimit = 0;
     x86ms->above_4g_mem_start = 4 * GiB;
+    x86ms->kvm_lapic_seoib_state = SEOIB_STATE_QUIRKED;
 }
 
 static void x86_machine_class_init(ObjectClass *oc, const void *data)
diff --git a/hw/intc/ioapic.c b/hw/intc/ioapic.c
index 1b3f1e82..002809e2 100644
--- a/hw/intc/ioapic.c
+++ b/hw/intc/ioapic.c
@@ -451,8 +451,6 @@ static void ioapic_machine_done_notify(Notifier *notifier, void *data)
 #endif
 }
 
-#define IOAPIC_VER_DEF 0x20
-
 static void ioapic_realize(DeviceState *dev, Error **errp)
 {
     IOAPICCommonState *s = IOAPIC_COMMON(dev);
diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index a85a5600..6538bf9e 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -34,6 +34,15 @@ struct X86MachineClass {
     bool apic_xrupt_override;
 };
 
+typedef enum KvmLapicSEOIBState {
+    /* Legacy behavior. SEOIB advertised but LAPIC still broadcasts EOIs. */
+    SEOIB_STATE_QUIRKED = 0,
+    /* SEOIB advertised and suppression honored. */
+    SEOIB_STATE_RESPECTED = 1,
+    /* SEOIB not advertised (required for IOAPIC v0x11). */
+    SEOIB_STATE_NOT_ADVERTISED = 2,
+} KvmLapicSEOIBState;
+
 struct X86MachineState {
     /*< private >*/
     MachineState parent;
@@ -93,6 +102,9 @@ struct X86MachineState {
     uint64_t bus_lock_ratelimit;
 
     IgvmCfg *igvm;
+
+    /* KVM LAPIC SEOIB policy for the VM. */
+    uint32_t kvm_lapic_seoib_state;
 };
 
 #define X86_MACHINE_SMM              "smm"
diff --git a/include/hw/intc/ioapic.h b/include/hw/intc/ioapic.h
index aa122e25..1e1317cb 100644
--- a/include/hw/intc/ioapic.h
+++ b/include/hw/intc/ioapic.h
@@ -28,6 +28,8 @@
 #define TYPE_KVM_IOAPIC "kvm-ioapic"
 #define TYPE_IOAPIC "ioapic"
 
+#define IOAPIC_VER_DEF 0x20
+
 void ioapic_eoi_broadcast(int vector);
 
 #endif /* HW_INTC_IOAPIC_H */
diff --git a/include/system/system.h b/include/system/system.h
index 03a2d0e9..7a8e7abe 100644
--- a/include/system/system.h
+++ b/include/system/system.h
@@ -14,6 +14,7 @@ extern QemuUUID qemu_uuid;
 extern bool qemu_uuid_set;
 
 const char *qemu_get_vm_name(void);
+bool qemu_will_load_snapshot(void);
 
 /* Exit notifiers will run with BQL held. */
 void qemu_add_exit_notifier(Notifier *notify);
diff --git a/system/vl.c b/system/vl.c
index 3e341142..33dcc7fd 100644
--- a/system/vl.c
+++ b/system/vl.c
@@ -517,6 +517,11 @@ const char *qemu_get_vm_name(void)
     return qemu_name;
 }
 
+bool qemu_will_load_snapshot(void)
+{
+    return loadvm != NULL;
+}
+
 static void default_driver_disable(const char *driver)
 {
     int i;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 27b1b848..b36173c0 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -306,6 +306,49 @@ bool kvm_enable_x2apic(void)
              has_x2apic_api);
 }
 
+bool kvm_try_set_lapic_seoib_state(KvmLapicSEOIBState state)
+{
+    KVMState *s = KVM_STATE(current_accel());
+
+    trace_kvm_lapic_seoib_set_state(state);
+
+    if (state == SEOIB_STATE_QUIRKED) {
+        /*
+         * In case of SEOIB_STATE_QUIRKED, do nothing.
+         * The support will be advertised yet EOI broadcasts will still
+         * happen in case the guest decides to suppress EOI broadcasts.
+         */
+        return true;
+    }
+
+    uint64_t required =
+        KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST |
+        KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST;
+
+    int supported = kvm_check_extension(s, KVM_CAP_X2APIC_API);
+    if ((supported & required) != required) {
+        trace_kvm_lapic_seoib_set_state_failed(state, supported, required);
+        return false;
+    }
+
+    if (state == SEOIB_STATE_RESPECTED) {
+        /*
+         * The support will be advertised and the guest decision will be
+         * respected.
+         */
+        return kvm_x2apic_api_set_flags(KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST);
+    } else if (state == SEOIB_STATE_NOT_ADVERTISED) {
+        /*
+         * The support will not be advertised and the guest decision will
+         * be ignored (does not matter as the support is not advertised).
+         */
+        return kvm_x2apic_api_set_flags(KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST);
+    } else {
+        /* Invalid state.*/
+        return false;
+    }
+}
+
 bool kvm_hv_vpindex_settable(void)
 {
     return hv_vpindex_settable;
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 2b653442..6e6cf253 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -15,6 +15,14 @@
 
 #define KVM_MAX_CPUID_ENTRIES  100
 
+#ifndef KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST
+#define KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST (1ULL << 2)
+#endif
+
+#ifndef KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST
+#define KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST (1ULL << 3)
+#endif
+
 /* always false if !CONFIG_KVM */
 #define kvm_pit_in_kernel() \
     (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
@@ -23,8 +31,12 @@
 #define kvm_ioapic_in_kernel() \
     (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
 
+/* Forward declaration to avoid including x86.h here */
+typedef enum KvmLapicSEOIBState KvmLapicSEOIBState;
+
 bool kvm_has_smm(void);
 bool kvm_enable_x2apic(void);
+bool kvm_try_set_lapic_seoib_state(KvmLapicSEOIBState state);
 bool kvm_hv_vpindex_settable(void);
 bool kvm_enable_hypercall(uint64_t enable_mask);
 
diff --git a/target/i386/kvm/trace-events b/target/i386/kvm/trace-events
index a3862345..9ae9e226 100644
--- a/target/i386/kvm/trace-events
+++ b/target/i386/kvm/trace-events
@@ -17,3 +17,7 @@ kvm_xen_set_vcpu_callback(int cpu, int vector) "callback vcpu %d vector %d"
 
 # tdx.c
 tdx_handle_reset(void) ""
+
+# kvm.c - x2APIC SEOIB
+kvm_lapic_seoib_set_state(uint32_t state) "state=%" PRIu32
+kvm_lapic_seoib_set_state_failed(uint32_t state, int supported, uint64_t required) "state=%" PRIu32 " supported=0x%x required=0x%" PRIx64
-- 
2.39.3


