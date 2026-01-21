Return-Path: <kvm+bounces-68731-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UGoQJgPqcGk+awAAu9opvQ
	(envelope-from <kvm+bounces-68731-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 16:00:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C53D58DD3
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 16:00:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 26BF048B790
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 14:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACB9648AE39;
	Wed, 21 Jan 2026 14:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qZz8yWL6";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qZz8yWL6"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013017.outbound.protection.outlook.com [40.107.162.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A077D48A2A6;
	Wed, 21 Jan 2026 14:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.17
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769005057; cv=fail; b=IUnzqQsLdKRR86r0I5sa5E5kj3dznKYb/3ibplN8wHIwikGUwEr6rx6tEe9bGqsMiZUR3pj6/r7Awb+9c536sJJ+4J3Vw2X7QtlG5CfPtbS9koXG081dilgkdwS3OY4J6NwVshoO4JUSk/RQCGp8TTYv98EeMgPRyUmloNiHI7U=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769005057; c=relaxed/simple;
	bh=xAY9WEIESM87ZsBtHVxc3b9zPQ+JrvNH8reRBXGx634=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kBEEgFYL7Jyuu1sPtgHugrUDNCkgIwp47vM2QCgQYaKhSIcKo92gAh32g9lXyqa2FkhL9yf2hk/U5W4HpeeZ0jV9n0c/zfvdBCqLsk8AwcYKzZJuqCq2lIGn/cfFF7g3K+xFLsiFj0tyzVKuGvxDgHnT03pghPcvTSeL40zdrqA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qZz8yWL6; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qZz8yWL6; arc=fail smtp.client-ip=40.107.162.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=arMMV/sGReSlnCC+hQDMS3PDYGSo8AyvDMmLkagv2H4sWHyw1Jv6eAeK7L6Sr3ZlGXpRxMtjEaFyW5eL1D7/lzCn89xqBXsgDCadZfmKPU26t0p0eb9SJl6YfIjpFDPypt+Y7jNO1h5eDT2CcKtnzcE1MrV3WCpHWfxKltpzvz+Crf0UifxovZTnLpe85XzRFcV/Qe0aUDLLSQB4nFMUhulrKqwCOwrWGQksEOh7Z7yf6Sz1yFvCSNkEREIt0Fog4yCba1zOXUsfgG9di24JvXc/tucb3/3Dx4ktWf3lTjvRauRygrGtKbXwoaCt0JAeSFpvmNnq7PsGpw4dOdGXkQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dNSrZWjDAj12UPdmBU3YoRb6bvbUs+SDhcSa1+N4fFk=;
 b=CNDa1dUA9MB4qYNGr3rg8K/LVdHRlElFiP65ILjgOWIiglmcMFg/3KXPr5h63CR2gfMCR/SFIUM2ajWptM5ormlLtkDnMhz0fu9V09XNGJsmzSAf6HiQVaSnnmOSjGxy06MvJvypaziKkdKQZNJd4PlBj7N9sm/sfUlFgVTQ43u342yJE8voMPMaJ/d9SiFh2CSY5nwBJXPxjRhVoPqAf9gsa7JurJE0l0DVzmC7imEoqSdW+Nb80Maqp+MZpWIVfxc8L3/BLrUkuG5U+SExpwlyBe9wxzJfCeTsPM+CmrzEQ07lG4A0S39ObbsuIB65B8Jiv6i6CuhGEGl5E5P6bQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dNSrZWjDAj12UPdmBU3YoRb6bvbUs+SDhcSa1+N4fFk=;
 b=qZz8yWL6sLULFfMJXpJTDizBIp+hwr/P3QT2HI1Asw6wTsxhfBRN3VcsozDOVTxF/sjd5t3FjRO3/PSYG7faVY7/+kPRGryyXSUkDt7ViSXR7jMtjdFaQlOnX0s37uRDgOfbvaJplksXQPCskmccRIlL+4oIlvrJq5JyiIOxnW4=
Received: from AM6P191CA0047.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:7f::24)
 by DU0PR08MB8906.eurprd08.prod.outlook.com (2603:10a6:10:47e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 14:17:29 +0000
Received: from AMS0EPF000001B6.eurprd05.prod.outlook.com
 (2603:10a6:209:7f:cafe::d2) by AM6P191CA0047.outlook.office365.com
 (2603:10a6:209:7f::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.9 via Frontend Transport; Wed,
 21 Jan 2026 14:17:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B6.mail.protection.outlook.com (10.167.16.170) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Wed, 21 Jan 2026 14:17:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ooaiQXY0BZqgdzDdCGqJSBpZNU3NwAN+sk6VTBvu90oe5cVbVQpPpa1E2o9W/js8KbFQ6YTKR2Iyj3dY7eEAaLSz/5wybZydhB8wjCN2PUZlRHCyO1VYrTC9pfSeOnplKOVxAd5xq+vYAdMTTt4A55P1/Y3vTYMAldOYaxZlpTgXvubTKSl1qka6H6Zubg0JU8VtZ0hgc6xckiTv/UEOdjRgrv9Xe7+AwdDK0gyLi+5QaXhKm9Vxp1xmR8/0t4DbrFoYxAnaTQipMX8KK0FBbFxmR1xRaFbFhwwMQuDnNiSazpjWFLFjjJ48slW24Kuaudz9kgK/W575GGXGp23gGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dNSrZWjDAj12UPdmBU3YoRb6bvbUs+SDhcSa1+N4fFk=;
 b=X0ZaCy/FSVQWL913xZ8ucajVPcc2KFIJTT11AVmUEqAigIPz6AdWjNeIqHzKL+vQiwVkuA3o9rgpf64Ay1usYUTATSKDsjilw7+j+gjvfMbd4ETBL2qNsx+GEo+uyqTURfXdTCw5NSj7uKOOhclQLOhzX3ChvvKgt4KUKjWfyBTHpRcdzcHR6mka+jiQh0ysqusrtB9QXvAePzfpefvCm9NMOV+m+pwah7r756g6Ryav5btMcSECWx+MyDB7GCOjT41AlI+fPRokmK+DemWWthzEMgHdVQXHykpjkD+NtGWHXV95tkUStJ5Pq5A3Yd5cINWi5/J1qg6V22db4lIkxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dNSrZWjDAj12UPdmBU3YoRb6bvbUs+SDhcSa1+N4fFk=;
 b=qZz8yWL6sLULFfMJXpJTDizBIp+hwr/P3QT2HI1Asw6wTsxhfBRN3VcsozDOVTxF/sjd5t3FjRO3/PSYG7faVY7/+kPRGryyXSUkDt7ViSXR7jMtjdFaQlOnX0s37uRDgOfbvaJplksXQPCskmccRIlL+4oIlvrJq5JyiIOxnW4=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AM0PR08MB5380.eurprd08.prod.outlook.com
 (2603:10a6:208:183::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 14:16:26 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 14:16:26 +0000
Date: Wed, 21 Jan 2026 14:16:23 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Will Deacon <will@kernel.org>
Cc: catalin.marinas@arm.com, maz@kernel.org, broonie@kernel.org,
	oliver.upton@linux.dev, miko.lenczewski@arm.com,
	kevin.brodsky@arm.com, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, yangyicong@hisilicon.com,
	scott@os.amperecomputing.com, joey.gouly@arm.com,
	yuzenghui@huawei.com, pbonzini@redhat.com, shuah@kernel.org,
	mark.rutland@arm.com, arnd@arndb.de,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v11 RESEND 6/9] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aXDfty/c9c9YD8u5@e129823.arm.com>
References: <20251214112248.901769-1-yeoreum.yun@arm.com>
 <20251214112248.901769-7-yeoreum.yun@arm.com>
 <aW5dzb0ldp8u8Rdm@willie-the-truck>
 <aW6tix/GeqgXpTUN@e129823.arm.com>
 <aXDZGhFQDvoSwdc_@willie-the-truck>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXDZGhFQDvoSwdc_@willie-the-truck>
X-ClientProxiedBy: LO4P265CA0251.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:350::19) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AM0PR08MB5380:EE_|AMS0EPF000001B6:EE_|DU0PR08MB8906:EE_
X-MS-Office365-Filtering-Correlation-Id: 465ab324-736a-4c92-d636-08de58f7cf8c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?WlV4bElCRjdQSG95YStLbkg2VDltNFVNd3JMaUVya1hNVGhFSzBiK3RlK1Rs?=
 =?utf-8?B?SFNGQjcvOWc2eEl6V1JZbnNCeG8wRU0wYVdrSE1DZldsdzd1OGt6b0EveFEw?=
 =?utf-8?B?RUlua0Znbi9tQTAvTUxmR0ZYb2wzbW5mSnVKSzNBbmdvQWY3WkhOcWVxb3Q2?=
 =?utf-8?B?ZVdzZGtxLzhWWkhjL3QxNWtuRTh6L2xnZ2pBSGhSdXlYUU4xVXJLNXNFbEQ4?=
 =?utf-8?B?RmY3QzB1MkUyZ2ZpeE5hNHI3b3A0THlhc1krYmZqeUhhZFdwNkkxd0dQdmxi?=
 =?utf-8?B?d1IrcE9HQjY3SUZEakVuM2JUSm1VU0d6aW5JbjZOU2pRL0V2RkRJN3VGZ3Uv?=
 =?utf-8?B?RHQ5ejZBV2dXTXYxUjZqQkJwY2VhNU1WOVpCRmZFeC9DY3pWbHVKMVpBMFYz?=
 =?utf-8?B?b1FvekhlM0FIY1dBenFXcGVQeEdEOEFFY1N2dkQ2MS9xRWVjZGlIN2UwWi9j?=
 =?utf-8?B?emlSMVoxbUsrM2lDVkt2Z2lpUld6eFZhZmpOWkZyOVZYL1FxN1ZmTlZiNHp5?=
 =?utf-8?B?UHJJMHQrbktIQnpES0VTWEpvR0o3OUI4cWk4UDI5c044YWtjdXR3bHNGYytR?=
 =?utf-8?B?QkxCMVNUWnNrUjNzZlBFTDhXVGhKZlVxMUJjOXEyMlAxVXlDcHJzVFBQV2JN?=
 =?utf-8?B?UzUwem1iNm9CVlIvRTVvalEvSXZ4Qk0xMzZDQlhMOXNtL0pQOWJ5dTArYmxU?=
 =?utf-8?B?NUFKMzYwWnVyR0pSQWhHNDIxaGRSMkZTVFZtTXhxZXlVTWJBUzBWbFVvSi94?=
 =?utf-8?B?cXV6aXc4RitCbUhkN0F2Uno1NCt2UytLSHZ1VzI2RTdxN1FzSDNuUWw3OVAr?=
 =?utf-8?B?bFA4MDFyWEdFRTcyRUNhc2JzbXJmSkFYTS9xQ2pDTmFZZzdwR3VLNzBvZGZI?=
 =?utf-8?B?eE9VU2ZmVHpMT3VKb3J2L045QU9RdjkxU0I1NFFUY1MwOURaVVNDb2U4c2tH?=
 =?utf-8?B?a1ZkSzJNamhhZHRVUXBaT1M1RnNEaEQ5cXhGdlNhbW9rSXdvMVgxdk9FbkdU?=
 =?utf-8?B?K0JWaGtIbDZDWlNqUzRMWkZxQ2s4bzIwM2QyMFBZbG9vSGtqMkRuVHZoekEw?=
 =?utf-8?B?RGF3MHlxeVAvQlpYbFVwSmxYRUpJQ3NqVmlKbXJ3VzYxYUpKb3R1K2xMOVdo?=
 =?utf-8?B?K1VlS2NPb3NBQVp6UmErRnZEbVd6UVRkRnhWdlJPUWczNm5tU0VoZDhxZlVF?=
 =?utf-8?B?MlVUamNCTW5TMlpyOURSZGNaSDljeHZEM1hBYTJJM0xrWTVnOC9SLzZ0NEQz?=
 =?utf-8?B?TS8xUWt5YS9rTmI4RlVRZ2FicjM1d2pDUDhVeStlODVaMlBReFl5M1lEYXhV?=
 =?utf-8?B?Vm5YajRqVi9xcnlDSHB1T3dyU2djM0pqRGFCTnhVMElFOWkyeDYvSFQ2NVEv?=
 =?utf-8?B?UG9iYzlmY2tMblJMc0ZVZGo2bEtmcE50MEN0cVl4UXdSajU5VGZoQ0w1cFhz?=
 =?utf-8?B?b1JUSnFtSHFDUW1BODU3eTBqclEyNFZnUVZtNUNiSWtPK0JPRk82bWlpMUw1?=
 =?utf-8?B?WHV6RjVOOG5HWkZMclIwanRFZEM5OExzb040WGdha0EyeEpiU1hNRkpLOGg3?=
 =?utf-8?B?T3J2UkhETGZLcHRBVGtQNFRIdXpYTTNBWm9RQ3UxRVZTR2x2YldEeEsxTWFr?=
 =?utf-8?B?L1VGNkhtZFVacXgyOG5uaWhSSWlDcmZMblp4dmZDejNPQ3BhMzlNYThkVWFl?=
 =?utf-8?B?M3h2S0RvcVhpOE5tMUJ2NVF0RFovOEhYbjcxb2FFZ3hxSTBTMStyQkpjTXQ0?=
 =?utf-8?B?R2hoWGVML0NtdW1kRmRxYkUrajBuVEY5cTBVcEZ5WVRsUzU0b1p3akZxUEl4?=
 =?utf-8?B?dnAzTlowdFNVd0o1WGo3QWR3ZjBjbkJOSCtVVUFYZ2Q3NDgvdWVwMlc5cC9S?=
 =?utf-8?B?SXYwa3dSeExjREV6ZGNyZVJKdGk5M0dvOVBWd2NMMG42SnM1dy94U2UzeCtX?=
 =?utf-8?B?RXF1ak0xelhSVFBhNEcxOHdiYno1dWxHOTlxVWdqZlRUeGcvMTJtU0MvR1lD?=
 =?utf-8?B?ZzFoa3VOSllqeU91UUxjSG1zV2dtSVdhelBrTmU2dkVOT0NKdU1pNlAySmlp?=
 =?utf-8?B?Y1E1V3NpVFdXY3o1ZkNzekVsRmhPZ21OWnpEZUk4cEFhS0dzL1JVOUlTRWdv?=
 =?utf-8?Q?I2eY=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5380
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B6.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	884a8efc-8067-48e5-c21b-08de58f7a9cc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|14060799003|35042699022|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QjBhanIwaUQ2RG1FUTlpZm5IYW1FS0ExQlA1ajRwWnNRUW4zc3NLNExvRnhD?=
 =?utf-8?B?VXRVN1ppcC9YdnN5WXlrQ1dGUkpjTlVUbWt0Ny9FcFJGMDAwSlVUV2JGcmRT?=
 =?utf-8?B?azdnOW1KNnA1UitITWR3TEZLMkFhYUFEc0pRQ2U5Znp6WE05NlhlU1dEdkJX?=
 =?utf-8?B?WEYzTi9NYTRCbGcvOVhVelVXMHJDSThTK1BJN1FtS1g2L2VnanBaaWU2V3pk?=
 =?utf-8?B?L01UZGJtbHg3RlRKTC82b25id1VmQVY1dzFFczI3M3diaVBpZTZGMXhrWVdo?=
 =?utf-8?B?SjJFR2xnNWNYNUdvUXU5T1dWaDVmZE1tWEZmYkcycXlkdStUQVVTOElLQmkx?=
 =?utf-8?B?akNJaG9idTdJUGVuV0hKYXQrVmlpNUlwdUdXNlVGeTlzUWIrUlFSd2NGOFlr?=
 =?utf-8?B?MkFkREhrRm1hWWdHMEQyVW94LzhZaWdlWWV3ajF0d3VsNHZPUXJmQXBaSXZU?=
 =?utf-8?B?eVNQNGt1R0N2SVYwcm02bVRZR0dnb1k0UUFqdGl0eVB0QXdUWXdhb2dXY3lT?=
 =?utf-8?B?akhlSzIvOTlQaTJ4RnVSR1N0S3gwcXJUQzZjaE1ad0ZhazhPN0Q3d2RnQ2xx?=
 =?utf-8?B?amlIaGNRb0lLc0JtUWY2anh0aWtrZWZ2anZGUjI2NGpGbEp4QU5XSUloVU1v?=
 =?utf-8?B?K2NsazdzWmVCUmFibU1YamNUU0dqU0dKdmhHMVpZTUZJVVBPU1FHR2Q4V1FN?=
 =?utf-8?B?aUFxNEE4M2FQLzF5aG9uSFNaTW9ja0lEUzdhVkxVMStYYlM5SURoREVqcFQz?=
 =?utf-8?B?djBXS1BVMzgwa3EwcGVpQWVxRXYvSnIxTEFjWDVxdmRSdHNISUFBQkxQams4?=
 =?utf-8?B?Y2lUQkVucXB5RnZubUpJUCtONnRBL0Nyd2I3ZnNGTW9jTHUraXVPN0dTa25m?=
 =?utf-8?B?MlRQQWJPM3lUNlVJQ0ZxZVRMNkdqbStDY2xKUVdtL2FhM3dQRDJBSVVoc00y?=
 =?utf-8?B?SFhNaGhrcGxIVy9jMlFHcjBVcmtmWDZ0dFdqZmdJL29NMnVGZjduVGxLcjZC?=
 =?utf-8?B?bXJrcS9adURPSUxRRk9xU0tIWWJSODNKalQvN3lqNk4xeGVTSndEWmdmVmpr?=
 =?utf-8?B?UG4wZi9PamtOS0pvU0dUKzVPTE9KeHNBSWYrcnBPMmoxOXp1SjlJa1FaV3Zy?=
 =?utf-8?B?MEZMallqeDNvai9Udm9ZMWpoclRsa0l4cU9RYkNSYVVoY2t0SWtaR1hPY3N6?=
 =?utf-8?B?dmVvS3FqWTROWFlXTFFOMUlJSUVGd1RSZHdhQlJScHNYNFlnT2hFT1RNV2Nm?=
 =?utf-8?B?aDBSNDdLN0xSeG1KOHdWTlU4VTYrOGJiZTVFYmVpQm5MNWF5MEdBUGRKOEJq?=
 =?utf-8?B?amhPNExPN09ZenVaK3lxc1UvV281L2NiZUxrdm5JdFNXa05PbEE4UzNRcXJk?=
 =?utf-8?B?S0pTcjc0dnYyczlKcm9ZV1c4RnlkVFpMYWh1enRHWXBRUnZhVXhqRFhrTzFx?=
 =?utf-8?B?eit3SUlDTm43UldZVS9YNmZvamtoZmRKNGlha3NoU2s5VGhIL2tQNjNmV21V?=
 =?utf-8?B?UGZ4ZFF0MG5QYUo5TkZyT3YyQ0RTeDNqQTQ0bGozWHlaQ1ZJWjJkMk5FcGsx?=
 =?utf-8?B?V0RnMFMveDdWRVl3TGFKNzc5QjJFQTJ3SmJ5UDk0UEVEdDkrdDYvMDNQbWVp?=
 =?utf-8?B?Y1Nmb05WM1BxczNEYWpnTkhJM1ZqOHMxMWJFdmpTRnp2QU96SC9GVmxDaW1K?=
 =?utf-8?B?ZHZWdEtSSGpDM21STkUyczBITS8xeXF1cTJDeXVrK2FVRjNFSUFuOGZncG1u?=
 =?utf-8?B?QWhTMlA2V3A2MDljN0pGTkZqd0dpdzRFN3Y1NmswekpFSm9CTGxrajRDU1pi?=
 =?utf-8?B?OWRJN2xuOWhYU0F1WVpNb1hVWlpSSEs3dHlHNHZndU55ZDEvNThQdXFpUXp0?=
 =?utf-8?B?T09DVTBwTnQ2OUtnWkNsQWlVZE9raDNZMHlpQk15WmR1N2dhVEtxME55R2xU?=
 =?utf-8?B?WVM4QXBUQjBZQzA3QzRIV2dtdkFpNUFWUGxLV1dJS09jeHl0YlJjR2xBcnZo?=
 =?utf-8?B?TW1MVWJnY1p3ZnZZWlhHY3lFM3QwZmpKc0ozOENmWHhRQlJrNHBITHE1Vm1m?=
 =?utf-8?B?dXBwTFRTVG5TTTVieEVkeTBzUTRTeTEzamJlTjFMS0dEY1M1MTNsR1BMYVkw?=
 =?utf-8?B?bmVUYzVZc0hROVkra0h6MnlRMGc1dXloMjdLK3c5WkdVNXJNRzdGTU1qN0pL?=
 =?utf-8?B?Q3cyV3BWS1BBUVVabTR1ZFVjT3VaQ08wRDFiaXZuekdMMmFqY2drbllNd2ZZ?=
 =?utf-8?B?QTJ1WmpLUGYrUDNIQzlJck1xQmp3PT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(14060799003)(35042699022)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 14:17:29.4563
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 465ab324-736a-4c92-d636-08de58f7cf8c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B6.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8906
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
	TAGGED_FROM(0.00)[bounces-68731-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:dkim,e129823.arm.com:mid,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 1C53D58DD3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Will,

> On Mon, Jan 19, 2026 at 10:17:47PM +0000, Yeoreum Yun wrote:
> > > > +"2:\n"
> > > > +	_ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w0)
> > > > +	: "+r" (ret), "+Q" (*uaddr), "+r" (*oldval)
> > > > +	: "r" (newval)
> > > > +	: "memory");
> > >
> > > Don't you need to update *oldval here if the CAS didn't fault?
> >
> > No. if CAS doesn't make fault the oldval update already.
>
> Sorry, it was the "+r" constraint with a pointer dereference that threw
> me but you have the "memory" clobber so it looks like this will work.
>
> > > > +
> > > > +	for (i = 0; i < FUTEX_MAX_LOOPS; i++) {
> > > > +		if (get_user(oval64.raw, uaddr64))
> > > > +			return -EFAULT;
> > >
> > > Since oldval is passed to us as an argument, can we get away with a
> > > 32-bit get_user() here?
> >
> > It's not a probelm. but is there any sigificant difference?
>
> I think the code would be clearer if you only read what you actually
> use.
>
> > > > +		nval64.raw = oval64.raw;
> > > > +
> > > > +		if (futex_on_lo) {
> > > > +			oval64.lo_futex.val = oldval;
> > > > +			nval64.lo_futex.val = newval;
> > > > +		} else {
> > > > +			oval64.hi_futex.val = oldval;
> > > > +			nval64.hi_futex.val = newval;
> > > > +		}
> > > > +
> > > > +		orig64.raw = oval64.raw;
> > > > +
> > > > +		if (__lsui_cmpxchg64(uaddr64, &oval64.raw, nval64.raw))
> > > > +			return -EFAULT;
> > > > +
> > > > +		if (futex_on_lo) {
> > > > +			oldval = oval64.lo_futex.val;
> > > > +			other = oval64.lo_futex.other;
> > > > +			orig_other = orig64.lo_futex.other;
> > > > +		} else {
> > > > +			oldval = oval64.hi_futex.val;
> > > > +			other = oval64.hi_futex.other;
> > > > +			orig_other = orig64.hi_futex.other;
> > > > +		}
> > > > +
> > > > +		if (other == orig_other) {
> > > > +			ret = 0;
> > > > +			break;
> > > > +		}
> > > > +	}
> > > > +
> > > > +	if (!ret)
> > > > +		*oval = oldval;
> > >
> > > Shouldn't we set *oval to the value we got back from the CAS?
> >
> > Since it's a "success" case, the CAS return and oldval must be the same.
> > That's why it doesn't matter to use got back from the CAS.
> > Otherwise, it returns error and *oval doesn't matter for
> > futex_atomic_cmpxchg_inatomic().
>
> Got it, but then the caller you have is very weird because e.g.
> __lsui_futex_atomic_eor() goes and does another get_user() on the next
> iteration instead of using the value returned by the CAS.
>
> It would probably be clearer if you restructured your CAS helper to look
> more like try_cmpxchg() and then the loop around it would be minimal.
> You might need to distinguish the faulting case from the comparison
> failure case with e.g. -EFAULT vs -EAGAIN.


Oh, thanks for pointing this out.I understand your point clearly now.
Yes, I’ll respin the patch accordingly. Thanks again!

--
Sincerely,
Yeoreum Yun

