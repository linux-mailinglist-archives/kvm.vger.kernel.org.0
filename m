Return-Path: <kvm+bounces-71152-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cAXTB9Y7lGntAgIAu9opvQ
	(envelope-from <kvm+bounces-71152-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 10:58:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F24B14A9C6
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 10:58:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B95E5302D0A0
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 09:57:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3B3F2F5A0D;
	Tue, 17 Feb 2026 09:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rbPrqKYX";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rbPrqKYX"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010050.outbound.protection.outlook.com [52.101.84.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB873101CD;
	Tue, 17 Feb 2026 09:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.50
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771322262; cv=fail; b=XMJLTq0mtZmRZj/Ynru61tp5+IhysbEllbPvcMiYB5Qlr6iy2LGumBG1bD55jri5uQo17V6SspJWZbO21p8TeQzwT1RHaDWoIB2x+tHFZ0ZuS1oj4uot6EsnWTOYQYlxIkPGiGzciFGUJB0dPVtaNUwY3yqRdAMbsfzO6HJGw2E=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771322262; c=relaxed/simple;
	bh=XGJ46iO0gRpfND70pLJFgTORH5BJ56oJaMcAxo9dZVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dp5x2uEtbMIMMG7LpCG2w3IBKlC6juI6Aqn9nPqfItdZBZUF+XFPdO7YICPjuRvIs/VsM79FWcWQYMPdk/CZztIHbVYK753MlvdjrcQkBdQsU9VF7PIkvU/zkVMwTAPV/+6+zsZvyEUvBq4I+11DrSphksyMHhv7Tzp89MXtSQA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rbPrqKYX; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rbPrqKYX; arc=fail smtp.client-ip=52.101.84.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xCUElaGHU6vqOEIYg0nimrhM612xQM8EaLnkq4FiYSvjdYQ85rQOv0LjWAzyHD5TWfNrOh49l86VgHwIqd2IQjihJiOsW2n/R0Is1N1SIETLhN9Bdg6AovtmDh5SjeFNR90sjqU+2FxGa4y6f9NQL7CkJhMsFRttMckIcgMN4u26kXonFgODRh3MiYDwNAGM0htV3G5pCGgaXPuMLYPlmaV+bFUdFeMhye9TbjqO7D61gm6WxBclatCN/bBLjKQMoQFRD8Bgfxqm8K+W6LWe43fHvEUnjaakTLPOw0x4DJRJNfbztb9veKMhnLuSM3KvTAiI+G0a5WemQRSrd0WXAw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AVb9thky2/iCr5uYVROxNsOAbK/wfUfY/1enGGjk/GI=;
 b=aO0poktjPydn7BhN0t8cDZ0YRQxgCQpFJOHIXl+ANvkpy0uxy5uFaJn7wmfTglcx/x6a4osgj8leM2SLdbZQKozrM2cHtoqob7M3i89DrTca5RtlizXHLgZvVSw0v/svWvnpQL2lvtSQ7hm3CPxpFuShs8CKozbzB535g3RRuFiilK0i3YBh+JjlV1XvwcwljEoufa6JsEzdF1eVk4fYF9m3o2LZodF4I/MTK2ynyQStcATldHxbzi+n2qSzBwTLdXrbrILII1eDcuyREXi2rXNibGh1EwMWZvWPGkb9fxoippgBt/XvntfFU/RQtR0rp/g3HEtwCnWbutrw85MRLg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AVb9thky2/iCr5uYVROxNsOAbK/wfUfY/1enGGjk/GI=;
 b=rbPrqKYXEFwEaUpueIHt7kAQHfFo0uiaUIVgH8cLYAmHGeUW/O5AP7q8Of9sIveLuR5XTsDvW0bf4+EkekddIXrcELU0Q0c9djLu4AzLfrP21zBQqFFsS/SB7sIQUQTO7pbzyeZrVzO8ftvKtfvkgD1L2g3p2BCuvjxgDTGVc74=
Received: from CWLP123CA0075.GBRP123.PROD.OUTLOOK.COM (2603:10a6:401:5b::15)
 by DU0PR08MB8712.eurprd08.prod.outlook.com (2603:10a6:10:400::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 17 Feb
 2026 09:57:33 +0000
Received: from AMS1EPF00000090.eurprd05.prod.outlook.com
 (2603:10a6:401:5b:cafe::3d) by CWLP123CA0075.outlook.office365.com
 (2603:10a6:401:5b::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.13 via Frontend Transport; Tue,
 17 Feb 2026 09:57:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000090.mail.protection.outlook.com (10.167.242.87) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Tue, 17 Feb 2026 09:57:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BzMCaRNa6CmIFF1NMH9V6tjjCxsE12HTugI8TNgudQlcOejifsCyAp0LKWvl1QBdWmQMQko4r0eHqkHEzy5cSHPRSuhI+EJpfB0lwqQZ2/jDhk/gSXL356XmEAhXY7O4MBJa+iiV/Jnu7xkaoQSScMU8lkUWofebBXOJXoiaMvayjKcTr05663DIsXj5I/9LV2BD1FrtZiuyfpZC37UuI48OLEHpC/CmI28JPPbCWs/ZylSpqKX6PO6tCVDupXj08DgM0j6alHhWSX+T91fNx/rL4B8r3lc6GjYqb+kq7GZkWfO+hBC8wVwtJ0t7OfaQKKXlenX6SV5KYOWRSzss0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AVb9thky2/iCr5uYVROxNsOAbK/wfUfY/1enGGjk/GI=;
 b=gq3cVUTXmeRi1H383JJYjSoh+f5RaADyBZb0nVLxpRF5dDced8hSoka2Wo+PRbfXVUH9bsJ+FnPN1mY8y6KJBa9zodSP3KPDAAt2f92Ozes452E/0AyXs8qXBz0ozmwadk6WdGeBtVeO0ZEUuOvcH2N1auj1FfrVgle3LVx0lBkQiRH2k2paDE5DSXb4NAsVjLr1j21xNRp8M69uUbwqaEYp8/tdqKixD8cDLw0LxjsklIJ0K8jwcaR+sKMyBDBiSXNsHB+51DtbberTbOl3w2lniMQurWTQKe07Ba7CpVxrdciwp3MA3t4j34GXX0RMib7SFvhoUSAwH0FYulmznw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AVb9thky2/iCr5uYVROxNsOAbK/wfUfY/1enGGjk/GI=;
 b=rbPrqKYXEFwEaUpueIHt7kAQHfFo0uiaUIVgH8cLYAmHGeUW/O5AP7q8Of9sIveLuR5XTsDvW0bf4+EkekddIXrcELU0Q0c9djLu4AzLfrP21zBQqFFsS/SB7sIQUQTO7pbzyeZrVzO8ftvKtfvkgD1L2g3p2BCuvjxgDTGVc74=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DU0PR08MB9909.eurprd08.prod.outlook.com
 (2603:10a6:10:403::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Tue, 17 Feb
 2026 09:56:25 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9632.010; Tue, 17 Feb 2026
 09:56:25 +0000
Date: Tue, 17 Feb 2026 09:56:21 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	broonie@kernel.org, oliver.upton@linux.dev, miko.lenczewski@arm.com,
	kevin.brodsky@arm.com, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, scott@os.amperecomputing.com,
	joey.gouly@arm.com, yuzenghui@huawei.com, pbonzini@redhat.com,
	shuah@kernel.org, mark.rutland@arm.com, arnd@arndb.de
Subject: Re: [PATCH v12 6/7] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aZQ7RR5N7nXvfQyA@e129823.arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
 <20260121190622.2218669-7-yeoreum.yun@arm.com>
 <aYtgmZZhAKAvtfaK@arm.com>
 <aYtoOktjE18YNtB+@e129823.arm.com>
 <aZNbXlvCHxDmsmOA@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZNbXlvCHxDmsmOA@arm.com>
X-ClientProxiedBy: LO4P265CA0324.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::8) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DU0PR08MB9909:EE_|AMS1EPF00000090:EE_|DU0PR08MB8712:EE_
X-MS-Office365-Filtering-Correlation-Id: 62fe5432-398a-486c-5e11-08de6e0af81e
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?O3XFrjIitexk1NHrvarHo5MdkEvIP1qyafLUqWgabCDwVnaVeekhEIZR6BDD?=
 =?us-ascii?Q?DEo951z78fk4J9ISLq3soUC+BcdntCz9AHDELT0ST77t8yKH0JodD+4VlGF5?=
 =?us-ascii?Q?zmZ59HtIKD6nNw4GIh1rCkUZfCF1OZXS344Qgp0cY4uPcqulY68mNnUfiGzO?=
 =?us-ascii?Q?bv4jEYN6vL8NlqMsL7iuQd5qwkZm1VXv6hCl3k4RM2i8A6Tt0VyPYyDpGnyh?=
 =?us-ascii?Q?GrUxQhMxHCtAF7lVUOp0P8q0MGxm8wc5MKpLRDdDIK+9HjYBk+Pwv2GSE/5x?=
 =?us-ascii?Q?trOheXN868rmCn4k3Wv9fhYFeEo5R71XwwF7aFDrbZFPgKcvbiKIpN1tAVg3?=
 =?us-ascii?Q?geBaVYB708fUDSWVniRvXA3LmjHrSvJk/trFIPVjKlRejpUBnAqlfeeOtVn3?=
 =?us-ascii?Q?WG367VzCMzuwtXNwFkVQZ8Lhl/ERR1c1WKJjOBu+XHuc/p/sgid/Gk2kNMhC?=
 =?us-ascii?Q?RHHOdYLcMu3h5vF0Qpy3IRKNma3y1l0yppn++5T6BOkh1JwEYU8Zpe2s9xn6?=
 =?us-ascii?Q?spSlEarHVpsLnGzL51O1QvAKw9VPw2Ex61RGCHGPwEuZhtaa6SzoryS6TrrR?=
 =?us-ascii?Q?MughbQeYqq0ebpqrED7NE8VgbaE7m1pY+vyFZWgqRTonv5NokVue0rlXvs8O?=
 =?us-ascii?Q?fsFOxAHX+BevSsyM8g78o/MIpEcqJ3e0EISQMjOqZwlgNw2K3bZ+hGOQOs+4?=
 =?us-ascii?Q?2d7rr9b/ojgKv8uHj49SreGX/W96bOF+zqlfnee45Go8BCl0UXyq/Vvzu+xL?=
 =?us-ascii?Q?9rjqpQ+otKLItG1VfGYd+zeRFys/Kld6SEvZaGO27ItbYig+2h9UXNknu4lU?=
 =?us-ascii?Q?pfRsAdKSPRcXBIVKGX7pHvOhbzL1//KfWHO4/IyP10xtHQV8rgXnFBHXjCrq?=
 =?us-ascii?Q?kFAO6SzpymwwXHOusC28oJtSes3pFPDSLo0D4HCVc+focf4RdT0LyQWaM1KD?=
 =?us-ascii?Q?TZVsl5ZCELwr3Zp/kRR8OSYlR8nIOz6RanqXHl2cOR2/hXgJOU6ky9UOljlI?=
 =?us-ascii?Q?kntlO4VquP4MAQqbcMTI8TA0p0PVYd9Xxhk+aetm77ORj3bhSiFu03uQzxg4?=
 =?us-ascii?Q?M051HN19cPbzFziswFWp6uvkPUMPBgYcfTB3k5eqC2be3zS4S3x9fCcl/z1g?=
 =?us-ascii?Q?j9etkgG8+me84R/lax9x+8Wrp+DM/e5pSs9bLhWsE9foqAednBm5xrmx4Lzs?=
 =?us-ascii?Q?zgFs72uiAfhUuiL+Cr/PVxD5vioWT6rX/1AHO4j9BxShB8SWM2vVDcurh61Z?=
 =?us-ascii?Q?BkX1g+W7Wp0RYkZy7Hi4fL+O+lTh3QDcVl24GupGYX+c6tFQq8HHDyUuvxP6?=
 =?us-ascii?Q?NFGGzvp9GawYXkIf8P59tCs4Cwhmwp/5Z0WlL4Z0kvHRnKfvBfS3IVI5ap7g?=
 =?us-ascii?Q?dID5FNniwjmq2TszM4hItMOS7wgtuJXY9EoD3mvP8smw3E9wwfyp1PecsEZ/?=
 =?us-ascii?Q?XQelQ4sq0cWXjoMHtFxc7//tBlNo7wLr6nHkVUurmvtAXe/5IeDErjK8TBcJ?=
 =?us-ascii?Q?uhvlAJKaH510vyxYQOlBJ7nj1hxyLd1IdQVkjC3+34a71Gr4hbx3+zDk5XNc?=
 =?us-ascii?Q?gR/pxNB06iOyszZ6uwA=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9909
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000090.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	25bd6f0b-94a8-4159-c084-08de6e0ad015
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|14060799003|7416014|35042699022|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/L4u1XffFUP6PaPuBETDn+EU1cgfAs9Dz6+qicPLQgQC69lI4TrvhkaH+Vkv?=
 =?us-ascii?Q?zwZVBGKMJt4JVs1UpO4FTuUzYyo7fbr2W9Y/Bg+2BewpSef8HGlMkds7vbTC?=
 =?us-ascii?Q?iJwQUMBUgZ1o4BZcyLyG8isoNm7SSEe3gmLLhMkpR40XvhhhV5Q9TeebwxCo?=
 =?us-ascii?Q?Z/KRVw9nr1hUp8/LIkXotaBaakzFGJ0eNVstk+MVioTSYm53UZTgV/AIUqt2?=
 =?us-ascii?Q?o0IXusf5C5y4V0q9yQylyf4wiAVsREFaxwChGwW/OqR6pAvX0oantSp9pe2/?=
 =?us-ascii?Q?JJUCim6MGMwSjv2ZPEE1fDhvu98rImkxHNlHpRkfFNWdCkqBzFZKAUEyj+c8?=
 =?us-ascii?Q?Zs/8RB56yvK2AYv3sIU6Nw2iPwvwprRLmwTxBqCzkWU/Z5Cu0Ta3b7jleKZy?=
 =?us-ascii?Q?u9E50j3dOzI8WQ4std0jEAaNuTQBh1TamSq9bObYskDaNiMB8itOWvV1L9Y0?=
 =?us-ascii?Q?kDYM4wYHhxykoaX5aClqhOIiQ2dV0UAKhRcZrKx2Oe22MV0PVgKXAceXzDCM?=
 =?us-ascii?Q?Xu0LB4UFD64d1OJ35iE3AkRpFP5jnwT7HyeGj6LD29boF1ijRpBh5SxTlqvR?=
 =?us-ascii?Q?YGvAABTkXaWB5lAvYjUGQuWLADFyn5TMULhRvcENOt0aSz6iDvCbWKd4QZq8?=
 =?us-ascii?Q?0Ozbv434YDM70VlGQPwt01cbj6uIVwCDijLI5iT5JID8ft78xs9bbfz0Hq+C?=
 =?us-ascii?Q?raFIJjfbqYCOXlVKgpWbFX754xy/b+m9aKb8ZIRA0nXvrytR6er0siTVEP4l?=
 =?us-ascii?Q?npeVxNa/USmKnKFiDHaVPiAo+qYwDCplGfQanamdmRfHHNhIHRXlEQDOJFDi?=
 =?us-ascii?Q?SZz/2GwyIz/gWS3ssIIK9XlzovJQ9R4gID59+QosKCx2Mq7a98kC8R8WuXiC?=
 =?us-ascii?Q?zlDC3uWDQHMklfISrhJaYV6xlGS0pz5Z4vukClq8lXs3ACkNi3wuLaIPrxXm?=
 =?us-ascii?Q?p+4GMY0Cm4yQsHuze/7+FfKvMZJuBMju7dbobt+3gTqF1K+JAv1IMUNvUaQe?=
 =?us-ascii?Q?d88E5RlJ8gVrRzgcvooDxMl8oeH86dC/vp/dWgu9PxIq4msS6DLDz8Tph7Ya?=
 =?us-ascii?Q?3xe1iW+tRNbwm/wL98L+Oj0Q+qxnUeX1CqudT7a4mNGGPs3gbCzABFWyj94W?=
 =?us-ascii?Q?0ZWB2RMotDY/PQIE4/u/8cFV2vy8w82pUvdmggopllOgxh/LMwzGp9P4DZfs?=
 =?us-ascii?Q?6JgkZUHDTj/kjCCyIYwRueXnYuzW2tKjvxh3unkzCxqerU0+cV4V1cVeCH03?=
 =?us-ascii?Q?CUhMlWL8Yex4z9sRloayNH1LBjYJGqM6KOfvIBPbZsbix115rD7ftkQs6LSE?=
 =?us-ascii?Q?rNc+PVmbiwEjsNgI5sP0CMKcAS98nE2D5/B/oW4AIuJeMO/om4kZTc8ohcx8?=
 =?us-ascii?Q?126plSWN3JyUO15KA/ib2bs+1ZxSprsOd4DQXofek74JXDFgkEs4Cvh4tdA2?=
 =?us-ascii?Q?PoI+P/f/1uuksNJ5tY8LY4+GNcpCSlBlIahzExArh58leLQKkSGckutJrY89?=
 =?us-ascii?Q?WBW+8LjUUdtFNEXDlLGAUIwHo6P297aMxYgz+Mo9itS+7+sMloBcC/Fzf75K?=
 =?us-ascii?Q?V+mgyM+USN/AtzUUBNrst3NDohwVaajI62OnwsJDBOjOC+0F0/0PLhgm0I4w?=
 =?us-ascii?Q?FMsSg02gsPfVkK6n9sOTluVPkWCPRJqreJ9TgDkJWYpUKd4OMv+MPZnSgX+S?=
 =?us-ascii?Q?WKm9rA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(14060799003)(7416014)(35042699022)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	G6rnMKbNko/6Ls2iWDdstZjNeq1KSr+SKy4m1sl2I6uK/UU2ApTuqk+LmHZB/h/QvaEz8LtqhrJPcS+09U5Eo82xyyQOUc98WwhgrINNICYrdv57iESeAKW9GFeBNRfVLPMsZSMp/PkRNt/fHyJyAloAQ9nxCnhEUkrx7HHaELpgyrZTlCKGIcJ6K4CkWmcBYcl2meBQE1+yH28RCDElwB6NcZFFyyzEtkW08V6ql1DWmA7L0Ded4YHPcmoV+1EjCf28mzNH2GgO98gI1uMpseAk6AC2HhdHmwsf/7VlYclukMUTYVSU9zvfbAoGcZmtp7vZ4WwxrtaSOOGo5vYpC08rSPeF5QIe/8bxpYU9Pm6TRCka4y6ZVgOlP6InjLSwmF7srtmpXbL47MhWXpWxmLPZc2not4sPGTCgl4A2njC+8KP+80nPigvFXBgGTdXt
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 09:57:32.3656
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62fe5432-398a-486c-5e11-08de6e0af81e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000090.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8712
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71152-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[arm.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 6F24B14A9C6
X-Rspamd-Action: no action

Hi Catalin,
> On Tue, Feb 10, 2026 at 05:17:46PM +0000, Yeoreum Yun wrote:
> > > On Wed, Jan 21, 2026 at 07:06:21PM +0000, Yeoreum Yun wrote:
> > > > +
> > > > +	if (futex_on_lo) {
> > > > +		oval64.lo_futex.val = oldval;
> > > > +		ret = get_user(oval64.lo_futex.other, uaddr + 1);
> > > > +	} else {
> > > > +		oval64.hi_futex.val = oldval;
> > > > +		ret = get_user(oval64.hi_futex.other, uaddr - 1);
> > > > +	}
> > >
> > > and here use
> > >
> > > 	get_user(oval64.raw, uaddr64);
> > > 	futex[futex_pos] = oldval;
> >
> > But there is another feedback about this
> > (though I did first similarly with your suggestion -- use oval64.raw):
> >   https://lore.kernel.org/all/aXDZGhFQDvoSwdc_@willie-the-truck/
>
> Do you mean the 64-bit read? You can do a 32-bit uaccess, something
> like:
>
> 	int other_pos = futex_pos ^ 1;
> 	get_user(futex[other_pos], (u32 __user *)uaddr64 + other_pos);

Oh, my asking was whether we use 64 bits get_user() or
use 32 bits get_user() and what is better among them.
TBH, I don't think there wouldn't be a much difference but
want to check again whether there's overlooked except Will pointed out.


--
Sincerely,
Yeoreum Yun

