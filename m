Return-Path: <kvm+bounces-40989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B7DEA60211
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:11:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA2E619C32E0
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34CA21F582A;
	Thu, 13 Mar 2025 20:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="wUJsdM40";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Xvk9PFqH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBA01F461A;
	Thu, 13 Mar 2025 20:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896639; cv=fail; b=FtOQqRbd2IqrvEC2Tinsb7yxFskoV/kgHTYzXfW0r5fS8X14b6ioEG3XWjMZaTIZ6Uz0z+MhFqArMyxpx40UDtflir/DRhK6hjwVp+CUNr+Z/O0rZkBYKrLEfacTIskZ0iykiXCKXiIbSZJqzr5xqaR2hGOHHYDn2zZxXq7tWIY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896639; c=relaxed/simple;
	bh=EqGC0XyMKe+4qwe2v8z2VCLzfFzDi+/BUAlMhzLbAJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Uiy5RhHR283OhLehqi5NOR51xZEeNW2BGO6ViXVrVczETE/RyTrHfl/l7JW7CQuShz5UbRy952AXuBJv4iRnoGj4OgipmN6sKJUvwQ6UVZjtGM239DsP98bgww1HkNoIT+2zhLWsIShh7NS96Qod2mgiVIM3/khlYkTfeL1wYbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=wUJsdM40; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Xvk9PFqH; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DEHlEQ011333;
	Thu, 13 Mar 2025 13:10:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=2DmUMIV4J8hEjE5cHRymeGyE2BjOoY2xnCA0PVk1k
	xs=; b=wUJsdM40CEpb7d63dumEgyRZMzYV0IfV99by0synT7/46Phg5pKy7nUDN
	+zy3YnkaldgR972KnoXzdT3RViOCX/zLqZG8JuY3oDPvsNUY1osfL2cgMAjQ+shd
	KKTFJQLlfSRGgEWTqNltF6D+SJ8dWD2cFs+O8w6kTxSPxvtMvqc6hO2pdhBNlPSw
	B2OeN8vOl3JIl6WnDEcdTd3qbo2qA/3MaFBiQmMgZtvblSGr5X2eWh1yKVCWPxO3
	OTUvvudvHN/YMmp08J93c+Adiq1AbF0x/LsiQppBLP/RxuG0L4S3S36mmxSIXNHx
	9zwmO7A495A/LQSTBqGBEkM9ROeLg==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazlp17011030.outbound.protection.outlook.com [40.93.14.30])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45au9ge75p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 13:10:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XeD+G+ZAxzdkbX58cWlleRQ4oH4KcbLK3U61dp0PfcPLs5YXk8Twg1jySsfd1YvpYJl/K/pdIve8iHtxHe/TigSGe0KpcHOzzBI+Opdbyd0c1y3F7DbBlm7VeXvJLz++UtdmSDrJldHaYF/Gtoa9STPDg8A0exoSrRaV3OfB3nqU5XjkbJUds1iiPWDbN+ya2sdVOQjr/FDLDeq//D8E3K32O1Twg9VphpZBRx53szdmZ5hzah5aA7p3twbH49XMdXZRi18gnsk3viU0AmiGehAn4Qr4L9rlwdf9IJ68ccv8eSoiWbpbbvRgHLbzaGl9nlOX2zq2pdW2VTmOgJqszg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2DmUMIV4J8hEjE5cHRymeGyE2BjOoY2xnCA0PVk1kxs=;
 b=ZRRT1a7TeO8gOrUW20C0+v7rdXkTfjL1O3iV3JeFItU4SuOYD/m68YmLB+RvQB7sVDX0Ygnm3568VaytqwzLknqJhRqY5Wv6QRUOnvNNdbrbQltecPq44Jr9Yc931F08wRmwOOs1vvmvZ9Ij3+tK+JN5l6K2/cU67V98pKhZZxcDN9PtoAdTXBLD6I5mGEYODPPnmmpeR3OWnckHFUgf9KqP+e2Y8EZhdkiOUT7TqZMgMyay8HoxMIF6uVz++cHn2WpO4S1nCcv+F/loL3++gcHI5ZiiEv8Nfddh/g/kJfGrdcftF5FaTthuhXFdhHEGBvhoTc0veMeo293EqAdLPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2DmUMIV4J8hEjE5cHRymeGyE2BjOoY2xnCA0PVk1kxs=;
 b=Xvk9PFqHY2L9vZ0Y26d2IUpOHoZZ7Pw/7+EoNbXCV09fnfOAVADiSPHgQhycs1+RN2n2LzhN5kqd/hOSebkHdFPFSdRG4WgF3AcbiKSK2Ywi44tk1gyfX62HfvjLouYpximVNeTCuSjlPfwJiEzDII1Y5GaOeDlFjtx145Uki0GxkbAaPDgDCFOgkviILcMiuG6D6I7v9/9O1mLPl0bvWirn4R9qvPex3SJmMDy+2I5YTxb4Ec3Im/Q9CgXV+HRwLVd5Irjcfpb1qVbD87s/WFlCNyROmP26JyWZuEIU74OIFBoeoaDy+1lCvOR8/lZKLqWkTJHKNM8pblJ8ywXgeQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by PH0PR02MB9384.namprd02.prod.outlook.com
 (2603:10b6:510:280::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 20:10:04 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.028; Thu, 13 Mar 2025
 20:10:04 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [RFC PATCH 03/18] KVM: x86: Add module parameter for Intel MBEC
Date: Thu, 13 Mar 2025 13:36:42 -0700
Message-ID: <20250313203702.575156-4-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313203702.575156-1-jon@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|PH0PR02MB9384:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b23c938-4c7d-44e7-c27e-08dd626b0b0c
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|7416014|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ystjVftkTglv2+CFio428WOxHKNuo//KUZBUpCNZ9X+S+fERyRFNI984SyaE?=
 =?us-ascii?Q?ZSe5pFsUxsWyrIyXGwkGC9pg+4HrXOUHmdH/B2WmKjbxsObmhRol2/6QWb69?=
 =?us-ascii?Q?0g9HluXHo5z0YBnY2W6LkR15nrpTeL/gaQlryBFm/3hwtEvHpvej45aoEP8n?=
 =?us-ascii?Q?gshX4d83+1CYnJly/sFJ1+wDFC6XxRE4RyxItV+bR+wad2wh58DAjsva9KXS?=
 =?us-ascii?Q?AvTQc/Cl1S7JHejUGPDPJESwxlD2PJ0A3migmCwm/rh3suenIJgPZ+AeniTB?=
 =?us-ascii?Q?+/Dc1Bmstb0yZfS7SweMxhTLKuHoxP6HxTWqxbdY3e5ghlLYagurqHjVyNej?=
 =?us-ascii?Q?JbMrsFMZ5gxSbTTa5Hj0Sr5QMdqIlKHX+CNviKDGNbhO40sId2TA4FjSk1rM?=
 =?us-ascii?Q?ykOvyjNVu678OdKrMmJetFqzSXGDiKR6cOhff+ajBIBWr0zHzaNpBDgxSKEK?=
 =?us-ascii?Q?hzQR2LWutBGGV7us/oRAaPg8HYwj4gqOEaKTbSWlZpzKRxHHGmOyZroSDRCL?=
 =?us-ascii?Q?2YCozwBp/ZDkLBvYCGJBNlZc4XkyV52gPTmx1l+m7xJq9xSacBJRwnxfmmoA?=
 =?us-ascii?Q?iN0e4cqRALMR66UW8CaeRB9wmc5P8qcvbPh9G0fLypkPz1sEsL6CEiwuyp7I?=
 =?us-ascii?Q?PMPyOb00hfEoNlpw0m6Lwq1zkIuFAUqzr5GoYLLbTBcV+ocwYPsrNiWoCKV8?=
 =?us-ascii?Q?/4xsSttB04kNs3Kv2HaNSUA+u+iBiLuwtQRqusOfEzb/MlCY+qW2UiZ7WNFz?=
 =?us-ascii?Q?3x29Lb657WTfY4ghcDvuXE74cFx2z8ktbNBjy2vjHYLQpszAjHgVdTATIQiz?=
 =?us-ascii?Q?Mvq6E/yL/aQXOZovdUjZyiZXR6JNW+IkIVfnGUdZ/7xzSZ0n4UqtPiC68PbN?=
 =?us-ascii?Q?TVkaVi7X2weiUDwj59Iw+XBgU5zjNGq/Y9oAoI2zH+kq7fzEIcEUTqt9HvR8?=
 =?us-ascii?Q?FhnqphDQW36lHYBD0CDiYRtcy+6mVQXghEAPLZ0YCUhgQTwqwwNLp+tllQF7?=
 =?us-ascii?Q?F0eHWBh7XcVFg/hUF1zbuSzvwygogcaqgbU4dDhA96GoBw7QvBsXw6CTJzJs?=
 =?us-ascii?Q?B0wjf5fTHidTRf4q5jj1nqE63IffmTzMu3xnBSKjRa8rWjt93OyJb5g4Tu7O?=
 =?us-ascii?Q?1/MgipOgGOH2cV+z4M4oqk7HCjCtYY74lao8/1rphGPBsiEelan6d2YJpbzo?=
 =?us-ascii?Q?NT6P/tr7v2y6Xk9jOYdE85n3mUniY1c6IJej9tvsHHLug3H/6xx/ui37PXcS?=
 =?us-ascii?Q?J+MDreAJYQz3szYzsXsiHgXcgmTHFqJXam+VvmKuFe6f7oWR1zAIX6OAc8Zp?=
 =?us-ascii?Q?wSllMJK/A8oZC/NLxIPpJgwGU5LUdjONN1SfdD/yfbgZf4MYhcVE3l/qyU7f?=
 =?us-ascii?Q?PidudmrokHonMjq+3n4ET9YWkGlElNnCOU4sKFxKFJWcBgeBFpxP4HhaV1p3?=
 =?us-ascii?Q?HvhWUOnrsOPasTC/4XEzK2c1a/slb4YjG+10c+Xs1mdHZZU5Prmh6g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(7416014)(366016)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KccG8f5nNSiM19OvOLHptjr0ICk3gVidTq3/Y7CX3AVOIwfRam3Bknz3xvYl?=
 =?us-ascii?Q?F7uxk7VjVE3C9sPumCT1/MWgmDwj7OjziKCTdFBZHW0pNpSUDF5XAYPLy9yx?=
 =?us-ascii?Q?URh0bikohi5J9yGuB/RbKcC95RAAE1zZtkjSq33qWhZFpoI6EBwecfv9tOzT?=
 =?us-ascii?Q?WQBC3DsAoVkK5NyQsFqqj8g1c8tFm4VPa2eScCExFfLTF4IqRQyQm5eYiQ5h?=
 =?us-ascii?Q?7BfRq043JU1pA1KIdYxTlvPbBa4Ta0dDL+2V9MKOnvDWmIs+noGmMaudL8zQ?=
 =?us-ascii?Q?xF+b3VPwt7pVbqQoAqwhzBpTZoeFAL2n3BHjeFYK2Jo+CP307Bi2CxX/Neuw?=
 =?us-ascii?Q?X4Xt5DQGT1FZjz2nD5/+/k78YkYk0HW5fhAr4E6Ttrek0RCq+B7LrY1ERbbt?=
 =?us-ascii?Q?afnCPoLinAa0OipyJPX+RdYpxeq/DuHHZTTplz646Oj5AM/F7c3GLA7N9Iw4?=
 =?us-ascii?Q?JpFZBwQ/sBVK4gd4hzU8NwolbfeFJye2fsVDsWaIo6UveEBemz/CF9xJdVis?=
 =?us-ascii?Q?PzRmD59AkxzDt9olm1bKAaxKQzhOXes3ALCw3aWhkg+HY8h0ojWqBcguXMqV?=
 =?us-ascii?Q?UQ0J0yJQtJd5ATzeEZTuzQljw5hZFcTdbREmoKmt8aatN4DLAXatAcFxcpy/?=
 =?us-ascii?Q?q7d72MjJpBqqZI/fTyiSmlhpidrsguWVGjscmCPUGCfNBm0EXvLXKEsoLyBP?=
 =?us-ascii?Q?eI7LZfWc8modGXKoCexld177n6nlSalXKImDXhWp00aTEinsqmJXyUBQh56H?=
 =?us-ascii?Q?PkMdy7QMUUDITunztD4c3GFpwqT6VQPIMkqdhirvqdVTQpNDvDl3W2AD73NL?=
 =?us-ascii?Q?pKxCmJHAj2QI+Wv4FTVG6Ch4dyqXKQ/+MPrHldhRn1CJfRxfapvx0zDnReg7?=
 =?us-ascii?Q?qqE/He5SP5Xnw8+izEKBujmPZLqkU4xw7s1AMKuIF83o+hG3Alme0zIFglQJ?=
 =?us-ascii?Q?/Hkj/Y3mIOqFi/wDgLVoUUiE8Eyt44yaO+HMU1m0F5BudIqH86JjyJp+M0jt?=
 =?us-ascii?Q?c9htN9U7ATpwyutYi+ZTYLz/WxvWaBgXKi/BWzTzsrI+ffU4k+plgg1ClCuH?=
 =?us-ascii?Q?bgafnJl2ZKhv27maoeRdbDooOB2eLqJYADWRrUXjZr8W+M8zhIbYkGN/YUgr?=
 =?us-ascii?Q?iMCZlxdYWC1tuK6QZ9gpUfRPjZzMCirBNqrOSR9d8FfrDJymXcL2iKXMSMsp?=
 =?us-ascii?Q?WnzgzBuUi8tVd+TRHKm3fgopOm+KovIm3z8l8GJTj95DLgYlM9E0yFqqMQUR?=
 =?us-ascii?Q?eaD75I014QKZyx9EQK7m0iQJ1F3hUSfLkZhx8LExrZFnbdbLnzcVjuLm63Zz?=
 =?us-ascii?Q?z9jYohpOS+y9iKjAToQ1lXJtuwP6gvIId68BsODw8RIiXElE+gUqf/hsYnw8?=
 =?us-ascii?Q?Xi1ChfarhHcN6EuYGOg8sgbl4Zsw6xbu3qG4lexhDt02/4bnbA9pn568XGwE?=
 =?us-ascii?Q?j+sWv1DGzkZKi92QaFVX/OpDCFkhnbaoffjSAlD6z6QXG2QjXa2bSIC1VALT?=
 =?us-ascii?Q?zJypgYFZSN5Xlf33O/iKJbe5+gydv9G7r3Pc6LLMNIiwO2EbkGKP299FWtba?=
 =?us-ascii?Q?bMU15AD9JOCgS/xtXppTwR24hv8E2ACtHLoEjOh4CH1duk2hEWbE3ymJmEVM?=
 =?us-ascii?Q?3Q=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b23c938-4c7d-44e7-c27e-08dd626b0b0c
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 20:10:04.4300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SamjOmiLcpJLOTerjn/azDslRuA4BhX8j3evAhIEW+owSfNs2DMjabJCTqPfSNP4cfmKNAh6oWp2tHN0nDnvtVc1NCVpY5FjdIwRk2jk4PU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB9384
X-Proofpoint-GUID: oOYjARsPLUnahVdQ0vpl3EbJFDUzg5mD
X-Proofpoint-ORIG-GUID: oOYjARsPLUnahVdQ0vpl3EbJFDUzg5mD
X-Authority-Analysis: v=2.4 cv=P8U6hjAu c=1 sm=1 tr=0 ts=67d33b9e cx=c_pps a=uiDhKFZJcG2N7b6OoV3sKg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Vs1iUdzkB0EA:10
 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=jDXRym9R1P1Z0Gk8e-cA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_09,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

Add 'enable_pt_guest_exec_control' module parameter to x86 code, with
default value false. This parameter will control enablement for
exposing Intel Mode Based Execution Control (aka MBEC).

Place parameter in x86 common code as, notionally, AMD has a similar
feature called Guest Mode Execute Trap (GMET), which may want to build
off of this parameter in the future, similar to how 'enable_apicv' is
shared across both Intel APICv and AMD AVIC.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/x86.c              | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7cf2025a64a0..fd37dad38670 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1883,6 +1883,7 @@ struct kvm_arch_async_pf {
 extern u32 __read_mostly kvm_nr_uret_msrs;
 extern bool __read_mostly allow_smaller_maxphyaddr;
 extern bool __read_mostly enable_apicv;
+extern bool __read_mostly enable_pt_guest_exec_control;
 extern struct kvm_x86_ops kvm_x86_ops;
 
 #define kvm_x86_call(func) static_call(kvm_x86_##func)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7bae9e9cc14e..4b2fbb9088ea 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -197,6 +197,10 @@ module_param(eager_page_split, bool, 0644);
 static bool __read_mostly mitigate_smt_rsb;
 module_param(mitigate_smt_rsb, bool, 0444);
 
+bool __read_mostly enable_pt_guest_exec_control;
+EXPORT_SYMBOL_GPL(enable_pt_guest_exec_control);
+module_param(enable_pt_guest_exec_control, bool, 0444);
+
 /*
  * Restoring the host value for MSRs that are only consumed when running in
  * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
-- 
2.43.0


