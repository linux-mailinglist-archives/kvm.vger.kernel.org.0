Return-Path: <kvm+bounces-66773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F92CE6802
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 12:20:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0B2173020CEC
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 11:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8F983016F2;
	Mon, 29 Dec 2025 11:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="TIiq9XJv";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="FkT5gIbW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD6A2749CF;
	Mon, 29 Dec 2025 11:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767007133; cv=fail; b=AaJ5D0ggZuC0+VA5IZik3yW0NOi52gc0bkP4W6fZkX4NCtZKvbAO54ueypLqNAw2/Tqj6dJ15+BLbD3ho2bsCr0ajxmbRt+S/et++p5F0t0AjOtdUyQ0mE9I9+7BMZdD8pI/26MFZVRcAsFUOkteLB+6zHdlYv/OCTvCxPuv5wA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767007133; c=relaxed/simple;
	bh=0ckZh+U2ZL8M9I3VjroGyIKzW3oWA9Q0cT5aBYbWyqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NmYKkOJWY7CrV4uw9qJfFhC1U4POvp2u6bccO0oWtU4FfE0Iv/xrT0LZeywRNtO6zBKMzpTkVRpGDyG4h+w40YZ8q51VVLoxOie9jJxXYkz1FSuVzOLOP0dpoChktiCow3FLEqsko9+7x5uEd+427c82RZGvW9KY/Vs7stlwtrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=TIiq9XJv; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=FkT5gIbW; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BSJAfQX391541;
	Mon, 29 Dec 2025 03:17:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=0k8jVzDofFiCi3C8z7kcsl4kgBU8KbWUee//pe3Et
	jg=; b=TIiq9XJvlYsMbZ87uw24P6tez41icOc0+Mu0CoI7wLNZ3fn/ZD0iILNkB
	yOeLD0G2cKjooZLH6pOm4k8eWGiFrd20oGXYzXaj1k+yCOUT1tZdcrWBr7hOr3sS
	ba/ZO7qVF1c1TpokMvfrx0loqzAwsC07VFG/HcZG5U2xbWL8EznM3A7SDsRRyR1L
	5xsBUJxBV2ulSXHTryou7ZxTFmxqtzYYeH6VnIydHCPz77PHBe89itci396vULpS
	A2Cr0IN6zX8gzHK1jef5xN6JPe1Y2/xCMe+bYjhjW1O7JtQauEB/KWWOwJXEM2Ii
	JM4W1FBgavTbPV5xtW+ToANnV1VSg==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021084.outbound.protection.outlook.com [40.93.194.84])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4bac87aqsy-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 29 Dec 2025 03:17:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xhV4udKeizRDFD1ovi35Zr+zjZ/99l3mbFDTmFqFKMW0ZPgteLBZ3ylQLhHy5l3Tpley/7fAttbWrjykY2xLophQKMxz2HPONpET7N+fspYN2gW+oKi/fn+VM+l1JD8TQ7sqSaXUIbEnGqBa6ovHVXy5iKGyx6aMCQp92FC0K6qnWaWwa+HTvgSe7SH4BChfSJ7aTflATVcYZW9wm4KSKKqXDC8trtqc3ezxBmPNx1mnA2wVoE4T+6xOeFtclfLOzf0O4emxsxsEKk/EiHCC/+PedRqe0m6K/HVkOi/MLGrn5/6tF6H+stLKiF4QH8SFQblxbhRVIHPO7cX06w2RBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0k8jVzDofFiCi3C8z7kcsl4kgBU8KbWUee//pe3Etjg=;
 b=NsxwtGuL9VBHNgvdUw4Nc1mvMHWDEZXO45u5FRMrlXPeN1egKIxwvR8Bw3bQg6h8BcXpKePP1D6x2CXUlx7vIWkxUjGBuJSHCmtoPAFt66dKPz2tJdR6bxzzuugtSkTX7zmx45OEeCSB+mVMmyX+7bOZzQK/EQiDP0t7WTBeK3v8Flypit0QU8iL3hcTNeniSKBOVo2la3Yd+c5XmQSQndidnXO7rQXNEcfQNRQtrQGkKlWJHdURW8auOmvQJjjwgAEpK81rWitRpMz/3c6I9/uy3GaM8wr/HsIao7f8bpiGb35BkJhFpsG/65WyiKhTKUyWj8B9+KhPrk4cYQ45mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0k8jVzDofFiCi3C8z7kcsl4kgBU8KbWUee//pe3Etjg=;
 b=FkT5gIbWvjX3HHHBzU7y86C8hrMKOLP6yr3HIG5S0Rtf+wPbB5lJ00RwsrW8jIg43SeauECoHaamy+G1cpYdblDHDe0rxda0xnNNBh16d7RvWY8F7n94MDJDJP05JkhCnm/Olk8fjqh2Ov5GZ1JRBwjeQIDt6WdCkCNjofXew1pqYDigv9s+EaLrKsjvi7cbR56Gqx7euRRu4/UYbS0yAakSi39+uFnhvk4BleFsbzzIfUj6XOG7fBWhRaP7cSH9/yLI1koOpjGr1h1jkeY9gG0vi8wFXRL7Jhd7NAecOdwmRBAOZTU3y1okAeGMagF+tR2/IGoqeZ9OXQ+QCt7r8A==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by PH7PR02MB9965.namprd02.prod.outlook.com (2603:10b6:510:2f9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Mon, 29 Dec
 2025 11:17:50 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.20.9456.013; Mon, 29 Dec 2025
 11:17:50 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kai.huang@intel.com,
        dwmw2@infradead.org
Cc: mingo@redhat.com, x86@kernel.org, bp@alien8.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, jon@nutanix.com,
        shaju.abraham@nutanix.com, Khushit Shah <khushit.shah@nutanix.com>,
        stable@vger.kernel.org
Subject: [PATCH v5 3/3] KVM: x86: Add x2APIC "features" to control EOI broadcast suppression
Date: Mon, 29 Dec 2025 11:17:08 +0000
Message-ID: <20251229111708.59402-4-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20251229111708.59402-1-khushit.shah@nutanix.com>
References: <20251229111708.59402-1-khushit.shah@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH5P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:34a::11) To PH0PR02MB7557.namprd02.prod.outlook.com
 (2603:10b6:510:54::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR02MB7557:EE_|PH7PR02MB9965:EE_
X-MS-Office365-Filtering-Correlation-Id: 2366ab6c-3731-4d82-123b-08de46cbe72c
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OgvEkQI7vnNLHmANo0a6GjA8CgL4je+c4L+Tr9m/IcCji2eJqBK54z0gV9wu?=
 =?us-ascii?Q?D2OufXbPz/7bcmPgwlcbDpHtTJWTALwyq8Kbz+pl6jgECpbgjKKHW7PuLsXD?=
 =?us-ascii?Q?dNhtvKOJhsREYR9ZqDtHG3byeOKhlvjb5C99gO0qYg13GgfosJ8iay4d+Sph?=
 =?us-ascii?Q?oVERnCMXrRSlfogsfMy2fPhthRmjJ0phDbyZQkL+9vfRajFQRljUuPmcPEWE?=
 =?us-ascii?Q?+7kOLbIbSyYbRvBFfXlw4aP8TxF0aCPwDaH79Hw73OuRg8j2WQajNaWrwm/0?=
 =?us-ascii?Q?kX+pBN4hI0myiuYRRADfoAr6gOVADGWuk5AYZxB0P1vuy7dwhyk9nY8hFcgJ?=
 =?us-ascii?Q?trrWxQDihhz50hgioQ6f+47vJWEKlW/JRfF1D1yQI/ocY08b3WmZLzMCgmRV?=
 =?us-ascii?Q?AcPlJ3EehHxIxlPTPxvYZJHngTW7OZSrTiIJIjumyFQgIyYtH33W/bTSsW6Q?=
 =?us-ascii?Q?MfyxhHkWapHgq0FeDMZ0ziPlyTVu5qEHmwhowEkxbhMDjglvxQZDMAvHB0iD?=
 =?us-ascii?Q?TIqbt5ecAiDRkzYR6L+xcSB4eEJxIEqlOkFuQ6pofB9xQQMKmMpV6so3eO6l?=
 =?us-ascii?Q?rFneYmkronJiO7CfIDy0XuaXH5L71aR4tax3G83u3H4ExqZPd15ZY4/8GoiB?=
 =?us-ascii?Q?NmSq57YhBs3hDm17KRnCiw2dZ8lOHV5eVHb90p/AFaC4XNI5bqhMXCy9lPex?=
 =?us-ascii?Q?YTXbbUb/TEy1hDVlrApm247YuFhJRa7a7AmQtB4bfSgb8JlXnn/E5hHETgyh?=
 =?us-ascii?Q?B419EdQHHoWfrtSabiZju/810PF3Iff8R7q79essrPGdrQytxl+sHyd5kR5q?=
 =?us-ascii?Q?rRpcpaQf3DeUtByd5uZDE5YlAIsOOKCySsMrQdstYFuGzkCGIncVjVjhoiF/?=
 =?us-ascii?Q?qYrqSO1ViHZlzMsVqE7NhPJidU3nwgQR6KofISJB2PELrBiIM6yUZBUsXdr/?=
 =?us-ascii?Q?D/kL0pw3TzJzLJkFq5zkhOMdtVvHcco/hguXEVMvSZIeEg5plEz6p80eMdnG?=
 =?us-ascii?Q?a1ItjZMj4urRvmxwtzd0kCxi74E4MQtK9PHZgTyplpOdNNJNIfdmoyKGYqjw?=
 =?us-ascii?Q?DvDwjR5ZJQaHZLtvioGe2yedqPxGmiSo1YmVwRXKVYpBZVDZ3PJBuvsWa+9f?=
 =?us-ascii?Q?+elKHMlZZ+baoYeIBgj4oD5uhJLPa5shC2DaQo2DEd2I84ujV9AR3Pu2hsE1?=
 =?us-ascii?Q?ynhKMrh+GtpRGA15G3ZrC/g/zvfQj8rpseEng0iPx+M9oPDoVeTNaF8ZEjUx?=
 =?us-ascii?Q?/hNi1cIgm1Kb56KbttDiRWrPZk7CbRGqdnYPZMfe2DpMIuSyjLe3SEwerJmK?=
 =?us-ascii?Q?tZRwNQZrjxxUH6wLulfez21IqZ+tnmOoQVm36++2UWuJE4dogNoN+LP7gkmn?=
 =?us-ascii?Q?lAl0FBq9EXLEFMyD0zX8UUcQq1J3nsemY2pkH1lKzvFhFuM6RGjAKumL6gIy?=
 =?us-ascii?Q?GJpUmaxqu4xbsqLQ3OvTZ9qiwLxWSrclXt+fp4e7JP/2yui4aYSywQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SLxV7TJk8ALk+bb0YqwvKmr3n/mUx39tlvqKAVbCvhq3yIVu23ToAcddUT06?=
 =?us-ascii?Q?iEwgGf2an/DF6VG+Xm19TVUDtJEfqF+v3IEuHe6d5SX7Sj2jmtIE0PFYlmzx?=
 =?us-ascii?Q?Xh1vS8dWsu37KUnEfyt9l3i9UuyapufEDZGB+XWS0ORwo1hGRrx8knVcwJdl?=
 =?us-ascii?Q?sv3LUdRw2BMjD+m7S/NdJUV4BTmkbP2L8pnKxtpD34FrU7qazHARNgry7dn4?=
 =?us-ascii?Q?ToAKDO/In3x498Jh+tdyHF3+YHmNy//xDzcFTNmbpHn7wh5cm1vxa9pIRBO9?=
 =?us-ascii?Q?9yqGRwG0077z4JGgbsuN8psHDVOuxU7qXEaztfJM9KXdG7WZpt9h2qweLz+F?=
 =?us-ascii?Q?L164n69ZNZFEvFZnYcu9xE2zNlr2tJMd7E06AF5HJYF1NW8PFJBt/dLtiYlD?=
 =?us-ascii?Q?fh8i2T8isOBkWzLXJ8bbqHs8VfOADbfAJlJAG4QdlEfYbVF34B1rzFLJQL3T?=
 =?us-ascii?Q?6vxqKPXphaRXd3ja2YQIMJqVpXFwvBgULXUFE5/61cceblVL4EZ6h/UxKLfx?=
 =?us-ascii?Q?EqM5CU0noWqkC9qGWwGZQomVjCUMRqmDxq8OgwB0eTUQX+Aiz2GmOLUkELxy?=
 =?us-ascii?Q?0MuC0Ox7CDw5gKKy+hrYqFjN5TA9ZUfp76rcIHMOyTZyqG9yyOrbIY8BDGYG?=
 =?us-ascii?Q?0HIq1byFt3FxP0i68+yKh05RciK5BiQCkpLaF728Z1Yg4B9cv4/wGE80cV8d?=
 =?us-ascii?Q?L4h5dOrFFSSg71xz+X9GD7aE9LUoxtD3qk3fEU52oFb5HhZ/wK4HhSk6hrob?=
 =?us-ascii?Q?MFZ1jXvsIFeCzsoDrR2gdCVy/iPVOdxQ3P/Jk2NLghkb7i+fXw4v2MqjGFEq?=
 =?us-ascii?Q?0Le3PHujkGCaUvX6w4pNHD5mgR9mg2XzyKIPDKDt8EvPIHQgQxaQNpa5akDC?=
 =?us-ascii?Q?d1b5VrslN9Jl8pPccQzltU5BAsoInvzmtl1T5dLBQcRuiVo/GI7Fn2hKDeZt?=
 =?us-ascii?Q?pvmeKLZww+hvEabH72WP3Jlc2zKsX6n5nNaYW0FIM0W1dNl9oBvimI+rpuqR?=
 =?us-ascii?Q?WVytzVxQBQ6341RNUPPXF8VsAcDgtmlXmh70+E4e4iJm7KcbB2A4N0VOCmce?=
 =?us-ascii?Q?oAVIYr8rZFnPPwgTtssefMRCEqsw646otL1hRPY+18mxfX/zuZugHZ3j6kRq?=
 =?us-ascii?Q?9rvUiN+M5rtKzRewUQ/O2GSak0J+a02dRmIw+/ZrXmjYj5lQFUqAdW1cgSwv?=
 =?us-ascii?Q?7EmywI5MfZgKrdtz7LBJS5/h1GfM06M+wjSYLjIdZo7KcmMda4axbGc0/8ff?=
 =?us-ascii?Q?RHwdavu8REE3vncYT5u/vwEs6KBrTJWUWIN2Voo7dwr9pBCK8RDrnn42fABG?=
 =?us-ascii?Q?VRhdHP5jvWeT3mUZbDnHree4UN31rlU6mqtd6FA76N7M/z09JAyof51q+z4E?=
 =?us-ascii?Q?IzdDUBfy/FaBb9V1t3TEsuyapugfRupn2J4Es3n9kFPIU1YwX+O7heTZ3kVc?=
 =?us-ascii?Q?Cuc/6ZwHE3SDE3UQmfr/9tnouEnwoYVhmWL44LFqbNU7dre4QinLArhSCeWX?=
 =?us-ascii?Q?ibguN/v+C3MJW3P52WToUgvkCmGoTulctUstGdqnekZjaaFvfiVCMv28cOTx?=
 =?us-ascii?Q?NBUXZot3lSyjrd5SPfepRpr5i4spKwxDoJfLgiONKyN9Ipuzudym57kDKq1Q?=
 =?us-ascii?Q?hGTTzE7It13u1CesGB0/mHWHod+IKU4feIZpqkwmEJTDT8+ydTe/+4Q/+PN7?=
 =?us-ascii?Q?V5tiS1vbunS52mn4Tq7KEzkplwdUEDCp15aW/51X+kTCmeN3dcn4xmV3V6AV?=
 =?us-ascii?Q?UQhLaAZxlTUzJvhplgK6ynT3nxbG+w0=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2366ab6c-3731-4d82-123b-08de46cbe72c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2025 11:17:50.5026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ys8BoknMnGIOZE3cMzm/uj4qlSwEd57ntJyKAWyPnMsVi/blc7VKSLzG0dWavYIbwZkiKCx+enjvh2aRyLHDgxBsBULyjmzyMgkqo4smys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR02MB9965
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI5MDEwNSBTYWx0ZWRfXwflnDv2vzq3x
 +5lU0rrRW8LGsYPqdHIC+doqclJvM+zueJ+11a8fRSHXLsxDdLPQb6Vtc4xBzOb3lpburtMm6+h
 pI1d8iGFq6cIE5lP5rt3/vGXoV6NNyF0gzjD11jML7ja5fZhtUdUZwDSngWc/Jy4VfS43n7ZQpl
 KmwXrSsYQsBijK9O79dKWDmCBwuds242wxDfcq+JuLlCbZCZ0GK7Xen6pihvrreAOfbra9btD8i
 nJTYIXiLIogSVJyB1TNuo/lTIX4hL6/+AO9t1DZRZdxuixSzRvqOtl8VjoN8oTMw8AZqim5dUtB
 rNu+gDjeqH+6vxe+jruBdF9du9p4sICiht0DnmmWYIkJ9CRHfK74bs/kU715ev5tE8NDdeNVUjR
 i1iZnAilf+fZSEpCoeEMbzjnVm3zJtGQPMlJQFBMbn/TxzmcW0ugM3W1eIGesDnFdr4VrjdI65b
 XkcQGti9f3c0UO4x4yw==
X-Proofpoint-ORIG-GUID: BieFc68Y4BgF0dM2mXSpexq2AqOFA_Il
X-Proofpoint-GUID: BieFc68Y4BgF0dM2mXSpexq2AqOFA_Il
X-Authority-Analysis: v=2.4 cv=L+YQguT8 c=1 sm=1 tr=0 ts=69526360 cx=c_pps
 a=FdfMFdOEn1VR10XCui1xPA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=64Cc0HZtAAAA:8 a=JfrnYn6hAAAA:8
 a=1XWaLZrsAAAA:8 a=3v8KogwRkgpbH0kN_DoA:9 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_03,2025-12-29_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add two flags for KVM_CAP_X2APIC_API to allow userspace to control support
for Suppress EOI Broadcasts, which KVM completely mishandles. When x2APIC
support was first added, KVM incorrectly advertised and "enabled" Suppress
EOI Broadcast, without fully supporting the I/O APIC side of the equation,
i.e. without adding directed EOI to KVM's in-kernel I/O APIC.

That flaw was carried over to split IRQCHIP support, i.e. KVM advertised
support for Suppress EOI Broadcasts irrespective of whether or not the
userspace I/O APIC implementation supported directed EOIs. Even worse,
KVM didn't actually suppress EOI broadcasts, i.e. userspace VMMs without
support for directed EOI came to rely on the "spurious" broadcasts.

KVM "fixed" the in-kernel I/O APIC implementation by completely disabling
support for Suppress EOI Broadcasts in commit 0bcc3fb95b97 ("KVM: lapic:
stop advertising DIRECTED_EOI when in-kernel IOAPIC is in use"), but
didn't do anything to remedy userspace I/O APIC implementations.

KVM's bogus handling of Suppress EOI Broadcast is problematic when the
guest relies on interrupts being masked in the I/O APIC until well after
the initial local APIC EOI. E.g. Windows with Credential Guard enabled
handles interrupts in the following order:
  1. Interrupt for L2 arrives.
  2. L1 APIC EOIs the interrupt.
  3. L1 resumes L2 and injects the interrupt.
  4. L2 EOIs after servicing.
  5. L1 performs the I/O APIC EOI.

Because KVM EOIs the I/O APIC at step #2, the guest can get an interrupt
storm, e.g. if the IRQ line is still asserted and userspace reacts to the
EOI by re-injecting the IRQ, because the guest doesn't de-assert the line
until step #4, and doesn't expect the interrupt to be re-enabled until
step #5.

Unfortunately, simply "fixing" the bug isn't an option, as KVM has no way
of knowing if the userspace I/O APIC supports directed EOIs, i.e.
suppressing EOI broadcasts would result in interrupts being stuck masked
in the userspace I/O APIC due to step #5 being ignored by userspace. And
fully disabling support for Suppress EOI Broadcast is also undesirable, as
picking up the fix would require a guest reboot, *and* more importantly
would change the virtual CPU model exposed to the guest without any buy-in
from userspace.

Add KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST and
KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST flags to allow userspace to
explicitly enable or disable support for Suppress EOI Broadcasts. This
gives userspace control over the virtual CPU model exposed to the guest,
as KVM should never have enabled support for Suppress EOI Broadcast without
userspace opt-in. Not setting either flag will result in legacy quirky
behavior for backward compatibility.

When KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST is set and using in-kernel
IRQCHIP mode, KVM will use I/O APIC version 0x20, which includes support
for the EOI Register.

Note, Suppress EOI Broadcasts is defined only in Intel's SDM, not in AMD's
APM. But the bit is writable on some AMD CPUs, e.g. Turin, and KVM's ABI
is to support Directed EOI (KVM's name) irrespective of guest CPU vendor.

Fixes: 7543a635aa09 ("KVM: x86: Add KVM exit for IOAPIC EOIs")
Closes: https://lore.kernel.org/kvm/7D497EF1-607D-4D37-98E7-DAF95F099342@nutanix.com
Cc: stable@vger.kernel.org
Suggested-by: David Woodhouse <dwmw2@infradead.org>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 Documentation/virt/kvm/api.rst  | 28 +++++++++++++--
 arch/x86/include/asm/kvm_host.h |  7 ++++
 arch/x86/include/uapi/asm/kvm.h |  6 ++--
 arch/x86/kvm/lapic.c            | 64 ++++++++++++++++++++++-----------
 arch/x86/kvm/x86.c              | 15 ++++++--
 5 files changed, 93 insertions(+), 27 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 57061fa29e6a..ad15ca519afc 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7800,8 +7800,10 @@ Will return -EBUSY if a VCPU has already been created.
 
 Valid feature flags in args[0] are::
 
-  #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
-  #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
+  #define KVM_X2APIC_API_USE_32BIT_IDS                          (1ULL << 0)
+  #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK                (1ULL << 1)
+  #define KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST              (1ULL << 2)
+  #define KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST             (1ULL << 3)
 
 Enabling KVM_X2APIC_API_USE_32BIT_IDS changes the behavior of
 KVM_SET_GSI_ROUTING, KVM_SIGNAL_MSI, KVM_SET_LAPIC, and KVM_GET_LAPIC,
@@ -7814,6 +7816,28 @@ as a broadcast even in x2APIC mode in order to support physical x2APIC
 without interrupt remapping.  This is undesirable in logical mode,
 where 0xff represents CPUs 0-7 in cluster 0.
 
+Setting KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST instructs KVM to enable
+Suppress EOI Broadcasts.  KVM will advertise support for Suppress EOI
+Broadcast to the guest and suppress LAPIC EOI broadcasts when the guest
+sets the Suppress EOI Broadcast bit in the SPIV register.  When using
+in-kernel IRQCHIP mode, enabling this capability will cause KVM to use
+I/O APIC version 0x20, which includes support for the EOI Register for
+directed EOI.
+
+Setting KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST disables support for
+Suppress EOI Broadcasts entirely, i.e. instructs KVM to NOT advertise
+support to the guest.
+
+Modern VMMs should either enable KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST
+or KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST.  If not, legacy quirky
+behavior will be used by KVM: in split IRQCHIP mode, KVM will advertise
+support for Suppress EOI Broadcasts but not actually suppress EOI
+broadcasts; for in-kernel IRQCHIP mode, KVM will not advertise support for
+Suppress EOI Broadcasts.
+
+Setting both KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST and
+KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST will fail with an EINVAL error.
+
 7.8 KVM_CAP_S390_USER_INSTR0
 ----------------------------
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f..4a6d94dc7a2a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1229,6 +1229,12 @@ enum kvm_irqchip_mode {
 	KVM_IRQCHIP_SPLIT,        /* created with KVM_CAP_SPLIT_IRQCHIP */
 };
 
+enum kvm_suppress_eoi_broadcast_mode {
+	KVM_SUPPRESS_EOI_BROADCAST_QUIRKED, /* Legacy behavior */
+	KVM_SUPPRESS_EOI_BROADCAST_ENABLED, /* Enable Suppress EOI broadcast */
+	KVM_SUPPRESS_EOI_BROADCAST_DISABLED /* Disable Suppress EOI broadcast */
+};
+
 struct kvm_x86_msr_filter {
 	u8 count;
 	bool default_allow:1;
@@ -1480,6 +1486,7 @@ struct kvm_arch {
 
 	bool x2apic_format;
 	bool x2apic_broadcast_quirk_disabled;
+	enum kvm_suppress_eoi_broadcast_mode suppress_eoi_broadcast_mode;
 
 	bool has_mapped_host_mmio;
 	bool guest_can_read_msr_platform_info;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index d420c9c066d4..d30241429fa8 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -913,8 +913,10 @@ struct kvm_sev_snp_launch_finish {
 	__u64 pad1[4];
 };
 
-#define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
-#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
+#define KVM_X2APIC_API_USE_32BIT_IDS (_BITULL(0))
+#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK (_BITULL(1))
+#define KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST (_BITULL(2))
+#define KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST (_BITULL(3))
 
 struct kvm_hyperv_eventfd {
 	__u32 conn_id;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2c24fd8d815f..36a5af218802 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -107,21 +107,31 @@ bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector)
 
 bool kvm_lapic_advertise_suppress_eoi_broadcast(struct kvm *kvm)
 {
-	/*
-	 * The default in-kernel I/O APIC emulates the 82093AA and does not
-	 * implement an EOI register. Some guests (e.g. Windows with the
-	 * Hyper-V role enabled) disable LAPIC EOI broadcast without checking
-	 * the I/O APIC version, which can cause level-triggered interrupts to
-	 * never be EOI'd.
-	 *
-	 * To avoid this, KVM must not advertise Suppress EOI Broadcast support
-	 * when using the default in-kernel I/O APIC.
-	 *
-	 * Historically, in split IRQCHIP mode, KVM always advertised Suppress
-	 * EOI Broadcast support but did not actually suppress EOIs, resulting
-	 * in quirky behavior.
-	 */
-	return !ioapic_in_kernel(kvm);
+	switch (kvm->arch.suppress_eoi_broadcast_mode) {
+	case KVM_SUPPRESS_EOI_BROADCAST_ENABLED:
+		return true;
+	case KVM_SUPPRESS_EOI_BROADCAST_DISABLED:
+		return false;
+	case KVM_SUPPRESS_EOI_BROADCAST_QUIRKED:
+		/*
+		 * The default in-kernel I/O APIC emulates the 82093AA and does not
+		 * implement an EOI register. Some guests (e.g. Windows with the
+		 * Hyper-V role enabled) disable LAPIC EOI broadcast without
+		 * checking the I/O APIC version, which can cause level-triggered
+		 * interrupts to never be EOI'd.
+		 *
+		 * To avoid this, KVM must not advertise Suppress EOI Broadcast
+		 * support when using the default in-kernel I/O APIC.
+		 *
+		 * Historically, in split IRQCHIP mode, KVM always advertised
+		 * Suppress EOI Broadcast support but did not actually suppress
+		 * EOIs, resulting in quirky behavior.
+		 */
+		return !ioapic_in_kernel(kvm);
+	default:
+		WARN_ON_ONCE(1);
+		return false;
+	}
 }
 
 bool kvm_lapic_respect_suppress_eoi_broadcast(struct kvm *kvm)
@@ -129,13 +139,25 @@ bool kvm_lapic_respect_suppress_eoi_broadcast(struct kvm *kvm)
 	/*
 	 * Returns true if KVM should honor the guest's request to suppress EOI
 	 * broadcasts, i.e. actually implement Suppress EOI Broadcast.
-	 *
-	 * Historically, in split IRQCHIP mode, KVM ignored the suppress EOI
-	 * broadcast bit set by the guest and broadcasts EOIs to the userspace
-	 * I/O APIC. For In-kernel I/O APIC, the support itself is not
-	 * advertised, but if bit was set by the guest, it was respected.
 	 */
-	return ioapic_in_kernel(kvm);
+	switch (kvm->arch.suppress_eoi_broadcast_mode) {
+	case KVM_SUPPRESS_EOI_BROADCAST_ENABLED:
+		return true;
+	case KVM_SUPPRESS_EOI_BROADCAST_DISABLED:
+		return false;
+	case KVM_SUPPRESS_EOI_BROADCAST_QUIRKED:
+		/*
+		 * Historically, in split IRQCHIP mode, KVM ignored the suppress
+		 * EOI broadcast bit set by the guest and broadcasts EOIs to the
+		 * userspace I/O APIC. For In-kernel I/O APIC, the support itself
+		 * is not advertised, but if bit was set by the guest, it was
+		 * respected.
+		 */
+		return ioapic_in_kernel(kvm);
+	default:
+		WARN_ON_ONCE(1);
+		return false;
+	}
 }
 
 __read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c9c2aa6f4705..5d56b0384dcc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -121,8 +121,10 @@ static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 
 #define KVM_CAP_PMU_VALID_MASK KVM_PMU_CAP_DISABLE
 
-#define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
-                                    KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
+#define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS |				\
+									 KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK |	\
+									 KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST | \
+									 KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST)
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
@@ -6778,11 +6780,20 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (cap->args[0] & ~KVM_X2APIC_API_VALID_FLAGS)
 			break;
 
+		if ((cap->args[0] & KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST) &&
+		    (cap->args[0] & KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST))
+			break;
+
 		if (cap->args[0] & KVM_X2APIC_API_USE_32BIT_IDS)
 			kvm->arch.x2apic_format = true;
 		if (cap->args[0] & KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
 			kvm->arch.x2apic_broadcast_quirk_disabled = true;
 
+		if (cap->args[0] & KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST)
+			kvm->arch.suppress_eoi_broadcast_mode = KVM_SUPPRESS_EOI_BROADCAST_ENABLED;
+		if (cap->args[0] & KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST)
+			kvm->arch.suppress_eoi_broadcast_mode = KVM_SUPPRESS_EOI_BROADCAST_DISABLED;
+
 		r = 0;
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
-- 
2.39.3


