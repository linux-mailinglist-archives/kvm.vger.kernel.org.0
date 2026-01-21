Return-Path: <kvm+bounces-68756-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iNZvMW0VcWmodQAAu9opvQ
	(envelope-from <kvm+bounces-68756-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 19:05:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E0395B01D
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 19:05:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3B367B47990
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 17:06:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B334A13AD;
	Wed, 21 Jan 2026 16:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IV2kkqDR";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IV2kkqDR"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011015.outbound.protection.outlook.com [52.101.70.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53C139E17E;
	Wed, 21 Jan 2026 16:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.15
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769014377; cv=fail; b=HU2RFkaCbLNdsnmq6x7lJ+XewbuueIK9MJncJnOX5YVTrNzj2UndFRybbEZRCGGKuZxcEUU+evnelEaGr1TxO7P4wJKtnpW8+44ku339H9i5yFomj0YiYrS5oKzb1o3xA8nxEuswq4YsyW1E1IUaKeUQdNEMJ9bPFm33SpoHktw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769014377; c=relaxed/simple;
	bh=ypKRXlYhf1DRGQBMd4JJ11f32Avwm2KByUh3r+s7+Ic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bmchosqULceBDK0tLDg9evC9cM2/+E/ObL25RC2vH9qBj1ddrYR5NOIo3TQD9bjYeKjnLFTFyGgqYiHDCyt5nCHmALZsHZfXrixKi1ryQpgQIe9ICdTQ+kNnZ6P0AnE3AaugKGK8lUYwp2/aZ+tXuqa6aSC70oxcdNJ+EwCYyJY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IV2kkqDR; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IV2kkqDR; arc=fail smtp.client-ip=52.101.70.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=gUQ0oLzCkBt9FVF6THLeqmLAYfqSwBy8EkNFe29ljQzdjIT8N+6WhPl0jJMqoSB6WrjktnA4Quka4SY+rMzT0jDN2d5Tgh+2If+AveE9A/Zd37mnALYKo/vCpgsZfyr7HlgqRCqpHupiNbb8op9WZXxMnYgshe1zKQHSgrk0PB0k9VhqXikOFY8amW8FS0QiSEAF96s3PYLAkRqUl5cnx+cGbCYRoQBf4HGPl+JJerYVylWOS9E72AcSoN22xnfCxaHaaMldiUpWOCov323v+y76UPbCb8xfovq480NVq/d4/IBvEmeqQAhYbpOlRQEXkAqZpmoizGXzXFfo1DPvaQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jbe6gtRwzKPXVX72MJrEIQjqexf+pnix3wiB0qfEzpM=;
 b=btv4cksjYI4uxAlOiPaQG1jn92GOP5SMELzL4s1CYVYgVyVoozeK2ZEJhobGUWqy8wTsH4PitO0SVBK+hRJ74LWq2dQ03U7urMpqEa5jtVs/Utab1o9Q8sALIGeU8jwZWHyt/GU3WVCoEow16AFbTgWLie02mX7acwyTksAcQIj8Ytd/SFTyS7PCREXlTOFKAGpffXbwkr3zHwjKod9HjtSkEYQ0aMOn8jdyoKqY44RZocFZI/qw1Ttwnvx7I7C3I4O4rInuHxWUGSKmpy1kakJpMmtku3nms70hhSuJlT+tjaWhPHBFOxbxbkoItwTySaY67eSb/wv7lUpAqSElVA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbe6gtRwzKPXVX72MJrEIQjqexf+pnix3wiB0qfEzpM=;
 b=IV2kkqDRzMEMRrWLnwbWm4ZO3ZwUHWHFjVzbNfO2T8+SgWzY8hTeLnanCG/DBBtxItVK3IlUS8HAQhPBnckSx1cUYLb8YV93aUb3wHpjYG0Yl8IoaxqjOyzBn3tk9A4Ys2zjmScsibOlOasQ2jtc3iRcx8ZQ61BKKuHAIr6vH38=
Received: from DUZPR01CA0331.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b8::24) by PAWPR08MB10947.eurprd08.prod.outlook.com
 (2603:10a6:102:468::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.10; Wed, 21 Jan
 2026 16:52:49 +0000
Received: from DB1PEPF000509ED.eurprd03.prod.outlook.com
 (2603:10a6:10:4b8:cafe::9f) by DUZPR01CA0331.outlook.office365.com
 (2603:10a6:10:4b8::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.10 via Frontend Transport; Wed,
 21 Jan 2026 16:53:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509ED.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Wed, 21 Jan 2026 16:52:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pLEjZhTJpKDHQzWFF5WUAW6J0GOYozNlNcmHxHFDrQN0cdQ3yEIhzEBGLTwaXk8G+wfXREUkZxzmDmxz383LEH6JD7K7bMtP2FyEyX9SDY5LOf9hGk+3N8HVij0lFcN7fvaNoWn7WLxbDhyiwAgL1SYAtjMig9QrDsfYSl/nzgoqCQJnP06fXUA1706OtULhvL708r5/DAjV1B+4GmHKZ5JDhn/Ij6pazBg+/APcadP4gQKfuGhztNmQA7tPakmB9l+aLLz+Vo6BeyohHRKkga8kXxY6sH9G6js7bKUESZL0Wlqr2VNVi6lZgWIzDO2Q4D6K/dFZ3tqOXPjixcvI4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jbe6gtRwzKPXVX72MJrEIQjqexf+pnix3wiB0qfEzpM=;
 b=Ngn2sgo/voAfCi1KWZC+meOpIVC+P2zhKsOuOAC2Zs71K+Z3O5Xh4QUKorR1BuBVobM4U/4BV2uMnKEj6tb+IysbMfiEKy6077ubJeBapqCMXftgN0Yi/wH4XUngLfBY8Opuh/6GOq1vXTtERJrU8HkpKrT2MVkaG/nWzS/0qM5cm6Ogw3uwt89/6I2SpWbIKT2ULUJIUqKW/4oRkEo+AnMjNdc+NJy5ZGoBamY1ZYNAZv4mHalnIgKxT6tzl3A2IvRRbRHiBlW3+lp3NA1ZBlNHhffRKfv/5movBfYiqkn6t/3t9g0uvznnmt0y9Fl+y4vcCDBwkbPsXuG8VSoE8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbe6gtRwzKPXVX72MJrEIQjqexf+pnix3wiB0qfEzpM=;
 b=IV2kkqDRzMEMRrWLnwbWm4ZO3ZwUHWHFjVzbNfO2T8+SgWzY8hTeLnanCG/DBBtxItVK3IlUS8HAQhPBnckSx1cUYLb8YV93aUb3wHpjYG0Yl8IoaxqjOyzBn3tk9A4Ys2zjmScsibOlOasQ2jtc3iRcx8ZQ61BKKuHAIr6vH38=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB9PR08MB6459.eurprd08.prod.outlook.com
 (2603:10a6:10:256::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Wed, 21 Jan
 2026 16:51:46 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:51:45 +0000
Date: Wed, 21 Jan 2026 16:51:42 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	catalin.marinas@arm.com, broonie@kernel.org, oliver.upton@linux.dev,
	miko.lenczewski@arm.com, kevin.brodsky@arm.com, ardb@kernel.org,
	suzuki.poulose@arm.com, lpieralisi@kernel.org,
	yangyicong@hisilicon.com, scott@os.amperecomputing.com,
	joey.gouly@arm.com, yuzenghui@huawei.com, pbonzini@redhat.com,
	shuah@kernel.org, arnd@arndb.de,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v11 RESEND 9/9] arm64: armv8_deprecated: apply FEAT_LSUI
 for swpX emulation.
Message-ID: <aXEEHm9KRmfqW2Kh@e129823.arm.com>
References: <aW6w6+B21NbUuszA@e129823.arm.com>
 <aW9O6R7v-ybhrm66@J2N7QTR9R3>
 <aW9T5b+Y2b2JOZHk@e129823.arm.com>
 <aW9sBkUVnpAkPkxN@willie-the-truck>
 <aW/Ck3M3Xg02DpQX@e129823.arm.com>
 <aXDbBKhE1SdCW6q4@willie-the-truck>
 <aXDn3iRXEtgaUtnp@e129823.arm.com>
 <aXD81LT6TX32vlTS@willie-the-truck>
 <aXD/YFNirTfoATvN@e129823.arm.com>
 <aXEAitvWkRWX_eiL@willie-the-truck>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXEAitvWkRWX_eiL@willie-the-truck>
X-ClientProxiedBy: LO4P123CA0604.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::13) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB9PR08MB6459:EE_|DB1PEPF000509ED:EE_|PAWPR08MB10947:EE_
X-MS-Office365-Filtering-Correlation-Id: ae826301-c187-467c-97a3-08de590d829f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?VjdVYkFGS0lnVFV1R2NZOVlXV3dwTFM2a1B0Nkl1UzhrNjFkWlVLRUN4TVRH?=
 =?utf-8?B?UDFvQXowMzQ5Q0ZMV3BwUFU4b2dXRVVpRmErV0Y3TDFmNFN4aVkrRUVQWUVL?=
 =?utf-8?B?eHZpcFZhaDRqTC9MaFkwY2c1YzJHcFJIcXY1WTVWa2VDVHhsMXZ0ZVV1eWpF?=
 =?utf-8?B?QXJUdjhOcm5EenRrSUF2S1NTR09HYlFQcC9MZTA5enlwbWVGZVQ4UHZmMWUr?=
 =?utf-8?B?NXNDZ1FKYXM1Q2NpdU9hYkxPWG5wbHRNQ2tkSWZDd3RObDFENXQvY2d2Q0lu?=
 =?utf-8?B?Zm5OQ3VyS0Q4MkNqUnRZVlRvaTg1MzB1UVpvanF6WUEzdW5uNmJmaGlWRG5K?=
 =?utf-8?B?VWVCN1RuNjlOWmlnNUVOUnVOdmttd2RuMWVkdE15MUtQUXZCM2JvbjVUbU5x?=
 =?utf-8?B?VDRWUlFmSEpaSVZ3VnB2RXZYVkRqWTY1VmxOa0xjakR0QjVxVHc3d212aVdM?=
 =?utf-8?B?VnFCbkdGYVd5N3V2QUpBRVVGUnRZMGg0cGRSektQRUdoaThJNkoyYytSV2d3?=
 =?utf-8?B?TXRtTCtzVStFSnU3VUxUWCtOc3V0ZDJZWlUycEdUTGF2R3ZnT1d3aGZSVVUr?=
 =?utf-8?B?UkZhTW1ndWozQ1Z0cDJpKzZya212eHkxQUFnc2M3akdmeTk2cTVlcVYva3hT?=
 =?utf-8?B?UldocHZ3Tlo0eFFnUFlxczJtazJQYTNFdHRPSzc5WkRFTWFMYWZNZWJnZDFB?=
 =?utf-8?B?RE96NlZnOXFNNDlENDZiaHBSelczQjFEWjRmWHVDSWIzSkdUQ3h6d1dmVGNP?=
 =?utf-8?B?enJoME9qVmxwVk9rT241ZlMrMisxNHE5SXM3UWswR1dzUGxBQVprSVdFd21r?=
 =?utf-8?B?Sk5KUFl6anVvYnJEWTRRQldNYWlyMlIvdTRXUHVtbGc1b1dOajE1UjRKdXZK?=
 =?utf-8?B?aStjRUxzaG9TUWpNMTBlSm5MbW4wQkZOOVZyQjU1UW8zalZtL3N5WStOaFl5?=
 =?utf-8?B?WG02NmRkTitMcmtPYWJIT2crdDlFSnVZVTBBeFFkVkhPaklReG9QdC9pNzFU?=
 =?utf-8?B?UmJWZUNxYkFXc01CSmFZalQ3R3ErZ1ZGTHRtclJDa043K0Y5NGhFT2gwVCtX?=
 =?utf-8?B?SWwwNllwdklEQmRibjdFZnpLenBLOFl1cXh1Q2tWV2hsMmhLSU1udTZhcUph?=
 =?utf-8?B?SzVHN2dFUDlocEt5VDNXbGJvbkV6dXp1cWZiMXkvUW55SVcrUTBKTGtpVUpa?=
 =?utf-8?B?RXZoSDVUbVJmNlN4UytqYmIvNkFtYWtISnNrbXQydjVjMml1R3htQzhGMXda?=
 =?utf-8?B?WjJMTXozNXE5eG5WMTRnMkJDZnFndWthOVdXY0xwdDZTVXNRVys5bTRSenBy?=
 =?utf-8?B?S1Noc2s0elEyVXJSYi9DT2RxNTRrRDUxUXh0SEZkVnpmaE93RmgrTEVXcC82?=
 =?utf-8?B?U042akF0VU9mOFZ4ZEtxYnNaSnZoRnlFRkpaMysrZWpRVXNHajZVKy8reFE5?=
 =?utf-8?B?RS9aaDRVdGh1YmxhOXFJK05YN0dHTGVGWGhEd3BIL3NsRXQ4dXVtYkRyemlL?=
 =?utf-8?B?bzlxWmJvV3M4a2VWRk1ZMGFxVmp4Zjk1RnVLNkRoZzIrZmRKbWk3aW45RUdq?=
 =?utf-8?B?Z3dHQnI0cmxXbWFDQ0ZRUzN5QTRlR0YyUGE3eEFva0JFVFJ5Ujd6MS9GVnh2?=
 =?utf-8?B?d1lwcWdGdnRRRUZlWTlxWTkvd3d4bnJ3OVphZEFHZjRteFlsSTJuOEpyRk40?=
 =?utf-8?B?dGw0Q3VHV1hPV2FYdTJYbmRoZ1MvRlBrMW45di9lbjAvQStzYk5XUTJBYkwz?=
 =?utf-8?B?cVVwdERoaFpUU0t4T0dRbkNDd0VpUGVJOCs5c29PemR1VUR5aXlZVUU4ZEd4?=
 =?utf-8?B?bzVycTcyZnV5R3hpbTNTa3pCSGpjN1pjNU4rKzI1ZWU0Z3FtMERFVldxeldE?=
 =?utf-8?B?QWhxOXVNWmFJSXNXWkR3ZGxseFU3QXk0b2NJVnM1THZLd29Ob3cwbTlyQzNs?=
 =?utf-8?B?c1RRTm00NTd4VWFMcGZrVjVCajQrdzBuZ0xkUnIyVC9wV0NpbDVnM1hkSzFF?=
 =?utf-8?B?anVIVThZR3BETEQwcExDVCtMcmN5ZmFObzJlT0sxU3dQc2xVd3N1eXlrbDNQ?=
 =?utf-8?B?M2ppdWFleWhCQ0FaTjVBckRGemRWWUZwVWNIVXRtSUlEcHNXU2NRZkRsSTc0?=
 =?utf-8?Q?cCd0=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6459
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b31abc8f-7f63-4a0a-1f8b-08de590d5ca0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|7416014|376014|82310400026|14060799003|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OGwvK1MreEM3YzFEWFRiRHZ2cG9Ra1R4aTlYVkkvVEM4YXJYSW9iek1MNm5H?=
 =?utf-8?B?QTZmOERGc2xGS3B6WHU3WDN0VUpHZklFckdvblBhM2VERHFQaGdwVnd4Y3Ru?=
 =?utf-8?B?eitZSFdXbVpSdmgyVTRNOGZiOU1hSGJFZGN3cjlXS1JKYnhGZU90bjVySzZa?=
 =?utf-8?B?Y3pGcGUzVlh4dm91NU0zVVI0bFZKcUtuZ2lsSWRZaGxFMGFXVmplMkFHOW5N?=
 =?utf-8?B?ZHpsL1pjck9uczk0ZXJmcUw2Rzd3Mk5aNFlqYzJIYmlJOHl6ZWMzRUFyQVFv?=
 =?utf-8?B?K1NYcEQ0MFk0Sm0wSUdQbmluRVZNZjJ3MHhTeW1nQjFHRFltb3loREt5TDZQ?=
 =?utf-8?B?K2lLQUlpQ3NYeHZqMi9VY0tJTnBQYkVaL2V1NzBZNUw2L01WVXpmazMrVVJt?=
 =?utf-8?B?SmMzb29ZMzNEc29UelV0Z0pzUWt0RGVmZnJscjluR1IwZGYrd1dtZFRrS0Jl?=
 =?utf-8?B?b3R6em1vZkY3R1NGZUlVNkpua3VYdlFuN3NaTTdmbkIrVlROdC9qdnBySE13?=
 =?utf-8?B?TE95a29URUlaM0pTSmVBWjE4U2xWUUtsc0tTdmRmc29KN1FDVmh1ZEhlU3V1?=
 =?utf-8?B?b0NNOHYvbG1jQUFMUkg5byswdzBhVjdMSDZQL1RTUzVaNXJ4c1hYbEFZZHVF?=
 =?utf-8?B?a3ArQy9MUlEwOUxNcjMwMXBUOE00T1F0TEVXd3hjbnVxa0k5NkR3ZHJwWjFS?=
 =?utf-8?B?TXBRTDBRSDBWTVo3cGZWb1o0RkZQR05YSnUzbVdwNUtobHNzeWdERzBpTW02?=
 =?utf-8?B?NGpKbkw3UndTemh2dzhxZWVWWXNkaVZVWmtVVmxYYTRNUXlieEdlRGhrSTJM?=
 =?utf-8?B?SVRrc3NUanVJeVpBYlJMV3MrbVFkMWRuVmNWOHdTZ0FUY1N1T05oZVd1V0pD?=
 =?utf-8?B?cm1iL2M2dUJoSmdzWlFNRVdmV1lyOUE2RUcvYVdhREJaR05NODZpam54Mmhy?=
 =?utf-8?B?SDZhM0dNUmVVRWt0SG43UURmNDdFemlsVHVPVkRIUHJuYjJTRmxKWHRZcHJs?=
 =?utf-8?B?bzBLNUtwM3FYdktsMG5lSUsvL1pvTUlsWEd4UVR0Q0lhczlWeEhpSWwzdlMw?=
 =?utf-8?B?dkZGYjlZNnFieGtKT05aNGd2Rlh6ZHJjWE5oU3hDeUYxWm41WVAvRWg3elZX?=
 =?utf-8?B?anNBaUt4VHBpVzhtZkdxcVBNRG1leGxVYXJvMTRpT3JMUkY5SGx4TGx4RUE3?=
 =?utf-8?B?RVRDZjVmSFVEMXpuZFJkb0d0Y2YwQ1NuL2JjNzlPL2l5NmNKbFRZTndJc29w?=
 =?utf-8?B?MkJmamNpWEc5NTVyUW1TQ1VKR3M4TFg3TFR1a0hObElNdWp2V1A2UmF4VUJU?=
 =?utf-8?B?SDJwYW1ZbnR5RnVlQXVDOUZvNitRYUQ0di9IZGF1N1VMVXRFUnU4QloyWVJF?=
 =?utf-8?B?NitvZjUzT2pSOEMwdXVDWFBTeDJGRGFxTFBKblZDMUNlNkFUL0xsOXdxbkQ3?=
 =?utf-8?B?VGVUZFJ5Nm54Q3YyY3IxdW9zVlBQOFQwMmVOT2I4cFFBZit2dEhBVmg3bzN4?=
 =?utf-8?B?WmwwUHlPSXo1VjY3b3VtdUdrK3B6YjVCVzVPM1lCWFhJaWpPZVZXMGxiWlps?=
 =?utf-8?B?djZDc2RLNncxbGtaeThNVFRBSFFmNldWL2tOb2lmVzUyOVozWm8rcjI1WGNJ?=
 =?utf-8?B?enZIckNKNmFxU3V0MXVsVUk4aXVTdkRLSXVLSFN3c3UrZllSV0YyR0RkbEU1?=
 =?utf-8?B?SzAyMFFwTVNQZFpLbzBMemxMSEQrMGhKejUrNUd6OWttdmJXK3c2Mm1GeTVm?=
 =?utf-8?B?TWxtd2lPUmNyeTU3V1RFdVRyU09EMDJHalBldHhyakR3YmpxSkQ0VnRmdHVi?=
 =?utf-8?B?bEhVLzZZaUtSbVdiNlI3c01BK1czUFVjOFdVMUg3RGFmbEJGbWR1dkpwUU5h?=
 =?utf-8?B?RmU1dS82NXBnczk4alQ4OEFnR0dwcWR3UFBSOG1tRklaSjc4V09lTFBxa0lt?=
 =?utf-8?B?UmQ4emtsSlVBc1hNNXVVTWFaVXAvZG9wYmErNXdBZTJVZjl3SzM0ZFUvWi8y?=
 =?utf-8?B?S0JObG1xMG4yV3NHRE96aGZDbkc5bmlwbnRUS1JaK2lKMEdmMVdwYlYzYVFP?=
 =?utf-8?B?MlU4cWFJZElUK1FZZnNEbmNLQkt2a0YrYmovcUR2NStPWFp6SHo2d2hpMmRR?=
 =?utf-8?B?dzhnOUZYeklibXp4VnhTOWhSRWhBejlzL1FKbDBYWjZjZEtXMWVheUg2TitB?=
 =?utf-8?B?QmNpM2FqM2dYVWFnL3RKZVFveHdoTmtwaGVwSGM0bDJHQ3ZpSnlSbGZmaGhw?=
 =?utf-8?B?TXlZQno2bVNUZEU4UWRJTVlFMHFBPT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(7416014)(376014)(82310400026)(14060799003)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:52:49.3065
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae826301-c187-467c-97a3-08de590d829f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10947
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	DMARC_POLICY_ALLOW(0.00)[arm.com,none];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68756-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,e129823.arm.com:mid];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 3E0395B01D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 04:36:26PM +0000, Will Deacon wrote:
> On Wed, Jan 21, 2026 at 04:31:28PM +0000, Yeoreum Yun wrote:
> > On Wed, Jan 21, 2026 at 04:20:36PM +0000, Will Deacon wrote:
> > > On Wed, Jan 21, 2026 at 02:51:10PM +0000, Yeoreum Yun wrote:
> > > > > On Tue, Jan 20, 2026 at 05:59:47PM +0000, Yeoreum Yun wrote:
> > > > > > On second thought, while a CPU that implements LSUI is unlikely to
> > > > > > support AArch32 compatibility,
> > > > > > I don't think LSUI requires the absence of AArch32.
> > > > > > These two are independent features (and in fact our FVP reports/supports both).
> > > > >
> > > > > Did you have to configure the FVP specially for this or that a "default"
> > > > > configuration?
> > > > >
> > > > > > Given that, I'm not sure a WARN is really necessary.
> > > > > > Would it be sufficient to just drop the patch for swpX instead?
> > > > >
> > > > > Given that the whole point of LSUI is to remove the PAN toggling, I think
> > > > > we should make an effort to make sure that we don't retain PAN toggling
> > > > > paths at runtime that could potentially be targetted by attackers. If we
> > > > > drop the SWP emulation patch and then see that we have AArch32 at runtime,
> > > > > we should forcefully disable the SWP emulation but, since we don't actually
> > > > > think we're going to see this in practice, the WARN seemed simpler.
> > > >
> > > > TBH, I missed the FVP configuration option clusterX.max_32bit_el, which
> > > > can disable AArch32 support by setting it to -1 (default: 3).
> > > > Given this, I think it’s reasonable to emit a WARN when LSUI is enabled and
> > > > drop the SWP emulation path under that condition.
> > >
> > > I'm asking about the default value.
> > >
> > > If Arm are going to provide models that default to having both LSUI and
> > > AArch32 EL0 supported, then the WARN is just going to annoy people.
> > >
> > > Please can you find out whether or not that's the case?
> >
> > Yes. I said the deafult == 3 which means that allow to execute
> > 32-bit in EL0 to EL3 (IOW, ID_AA64PFR0_EL1.EL0 == 0b0010)
> > -- but sorry for lack of explanation.
> >
> > When I check the latest model's default option value related for this
> > based on FVP version 11.30
> > (https://developer.arm.com/Tools%20and%20Software/Fixed%20Virtual%20Platforms/Arm%20Architecture%20FVPs),
> >
> >   - cluster0.has_lsui=1 default = '0x1'    : Implement additional load and store unprivileged instructions (FEAT_LSUI).
> >   - cluster0.max_32bit_el=3 default = '0x3'    : Maximum exception level supporting AArch32 modes. -1: No Support for A32 at any EL, x:[0:3] - All the levels below supplied ELx supports A32 : [0xffffffffffffffff:0x3]
> >
> > So it would be a annoying to people.
>
> Right, so you can probably do something like setting the 'status'
> field of 'insn_swp' to INSN_UNAVAILABLE if we detect LSUI.

Thanks for your suggestion. That would be good.

--
Sincerely,
Yeoreum Yun

