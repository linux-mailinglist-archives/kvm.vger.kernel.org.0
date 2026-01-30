Return-Path: <kvm+bounces-69701-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QDA/N6KlfGnCOAIAu9opvQ
	(envelope-from <kvm+bounces-69701-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 13:35:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FC13BA920
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 13:35:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A93BB303A5C6
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 12:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22676377555;
	Fri, 30 Jan 2026 12:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KwQcmwXf";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KwQcmwXf"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011051.outbound.protection.outlook.com [40.107.130.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F95F37880C
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 12:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769776468; cv=fail; b=kK4hwkVYHzlzxKywdzFQZM4j2HJZ0bkoeZv5rZa7AXxToCtwl26aKnXx6XzH3/XLP0EWEq8LK8DUmlDDbWsGYX6NRR08czuaxHi0RdkvfZSXYjPdnaKL+RwrdkEASX2yHrT/Wq83V8Dq+dog8P0w9uQvAIGkDEGEkz+29mOArcM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769776468; c=relaxed/simple;
	bh=3xEzKD1ylrR9ugWbMLL4E6oes67vJLNPFNbNb1V9vNU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NrbWTgOlo+xryMj8UI6WZFYEDIMtixtMmwn7oxQawdRpYpjigpY+AXc9MAA/e8NSC8B0f+nHspUMvbrg3wlVwi5z1WVn0gzzm5XwnIFfNN9JtOBj1qDxh82Kil4Bt2vnOWqEzJhfdsUOISwWBO1QIOPTsfUL7VxyJc3wVmrDFFs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KwQcmwXf; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KwQcmwXf; arc=fail smtp.client-ip=40.107.130.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=h3iF3QZb+yKgWXI427mpBnhHXyarFr9U5WZrdKHN0x+cj8gkBRdUidmOuDtKe1qyQYQ/0BvAT4/0odMzFfX3uxOVO82jmWHbbOFgd6QfDkDiYsJDYlBQXqV1OznWhsbU8CMV9UpAWlHkKOcdZukCZa+OkTtC9lL8yoOmic7ISVvoe2f5VMPuhdYd+9D/J4TOraJ2new9J/pqYteLfVrVWI0DfVr0UdxlN+kmVSMDUovxi1td8/TwME/e2W65cLItQ2s80+aj8bXVW3MOlcdjwuJo/rf5wsFOXHMXKCVwtbr7DjFA2ATFe31R94J18Hg4VHCItnWMuDKk36MK3ASl3g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3xEzKD1ylrR9ugWbMLL4E6oes67vJLNPFNbNb1V9vNU=;
 b=fTOIgElZbWnICnb50HVSyn63M3Lm88lN29C3/Xy02JIe0Tn0E7O8sk8SWifzADpJpUIGzxwho3j5R3AGd5a/RqUqdm/cQsYMT69LEFJr+gV/uAz9AcdHXpcdaiVztzyiD8zFNnf6cL8mAD9cG4JBfoo9vhf0/c0D3lMdQhWB26JjFTMHRQQKtwXPnVCw81wljlxlQkkFdjwjLO5NxEDYqcE3uUyUeHaR20OP2ePuwJfBe8zz8mGUjC8pnmnhnisvI+yA9CFWzP0XgxASVZJqXdYNRxmy/dRinwdfBUN3jHeF21IK/jFOaxHuqYXg/PqYn78K7QiyH7lfhK0gDWAD+w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xEzKD1ylrR9ugWbMLL4E6oes67vJLNPFNbNb1V9vNU=;
 b=KwQcmwXfsyxlSM3TR4Hc0c7h4mUOgfxqiiCVoO02nKPM37fAZ0bwUGIAMmFyZ22EbroGZbLI5pAmaHjm2HzDoa0q3hNSnUpHrptzP71yoV/IEMODBN6BOQ7F/+i2HNDHTLV5fgJd/F8XuOpVOlHZBQOKfGm9OB5Hp4/7Vq64lak=
Received: from AM6P191CA0004.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8b::17)
 by AS2PR08MB9450.eurprd08.prod.outlook.com (2603:10a6:20b:5ea::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 30 Jan
 2026 12:34:19 +0000
Received: from AM2PEPF0001C708.eurprd05.prod.outlook.com
 (2603:10a6:209:8b:cafe::14) by AM6P191CA0004.outlook.office365.com
 (2603:10a6:209:8b::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.10 via Frontend Transport; Fri,
 30 Jan 2026 12:34:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C708.mail.protection.outlook.com (10.167.16.196) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Fri, 30 Jan 2026 12:34:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MvzhzE1KV7DGq2WkJSqLz+0LQIp3Ufo35hwFn6WzEWwvEV99OkW4dCrJUcJMJCje5MoN6seQIRq8m4TwbzFwfOMQiHK5n+G8ntPYND1GdBvd40Vvk/+OqGHCCZHbVQpeenU8dDQi09XNjhUo1VLf68U0JHmwcVYb6Db3UjvTDaqo4U1/Gkc2lJHen2o9fUbdsseDo0c1N/gT9R3UAcMv36/Mqw3IxGRQhVD4e/4wPQ7KdSWigh+o7WC6MQwgiRXpZ7vJGH18gZ2sUv/0aYBy2271Ioc2nRNaPp9qaFbP6tkrFxRJ3sStDo2T358YtyLMXCB62Z7NGyNDqxfsaTKV6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3xEzKD1ylrR9ugWbMLL4E6oes67vJLNPFNbNb1V9vNU=;
 b=F+7qlQFAahFPHgWjbTJ9Yu/qsF/HVM1+J7cC+51lTUXjNPH27UrKHmUgxyiseNMY4gKn3zJR0gfxnQXG4G2U39HHASyS+VHvEKCccYb3MmVN4Lo+ThTP/H+b5JRCpeXK0gqCd7Od7zsuc+cz8f85DKHRXu2MOEFpy+i+ThEKqyCswLULkVcvB8yM0/QlgwHf7jQ95l3Ik2TJkzHGjR3r2hyDmAe1Qb+ANDyqJ8z4ppnT8ujcf4D0Xe8hdlNeUlYMuFmQzhL8vaM+bwito1HdXDG5cevnxeqIYZIFADPQZ4xlD1/thztfVYyaqdHwgBozYwF5+GfskGNj8Z4a/dc/NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xEzKD1ylrR9ugWbMLL4E6oes67vJLNPFNbNb1V9vNU=;
 b=KwQcmwXfsyxlSM3TR4Hc0c7h4mUOgfxqiiCVoO02nKPM37fAZ0bwUGIAMmFyZ22EbroGZbLI5pAmaHjm2HzDoa0q3hNSnUpHrptzP71yoV/IEMODBN6BOQ7F/+i2HNDHTLV5fgJd/F8XuOpVOlHZBQOKfGm9OB5Hp4/7Vq64lak=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AM9PR08MB6274.eurprd08.prod.outlook.com (2603:10a6:20b:2d5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Fri, 30 Jan
 2026 12:33:16 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 12:33:16 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH v4 10/36] KVM: arm64: gic-v5: Detect implemented PPIs on
 boot
Thread-Topic: [PATCH v4 10/36] KVM: arm64: gic-v5: Detect implemented PPIs on
 boot
Thread-Index: AQHckIAvBjx53nWlSk2vj3nt/XdlPLVqjzGAgAAZBIA=
Date: Fri, 30 Jan 2026 12:33:16 +0000
Message-ID: <352a2a9298e10efd3785c2215b643cf512e05476.camel@arm.com>
References: <20260128175919.3828384-1-sascha.bischoff@arm.com>
	 <20260128175919.3828384-11-sascha.bischoff@arm.com>
	 <864io3bbw0.wl-maz@kernel.org>
In-Reply-To: <864io3bbw0.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|AM9PR08MB6274:EE_|AM2PEPF0001C708:EE_|AS2PR08MB9450:EE_
X-MS-Office365-Filtering-Correlation-Id: cd7859eb-01f3-40ce-8ebe-08de5ffbe361
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?VDdSNVZ4SkZVVnlxa2had2hiblFWeUtkcXNuVGRnWldEQlNJaHJrUmtSTkR6?=
 =?utf-8?B?Tk5kdGQ1TllNUEpwT1YyKzErcGl1T1poREo3ZS83WnhiZHM5ekxtY0pDcTly?=
 =?utf-8?B?bU11MEhpNGtKcklIZitCYnZ5L0YvbkhSTXY2YytNcEMwUmlLNVcvQ3lUaERa?=
 =?utf-8?B?NXF2dlhZVXdyN3VIbHgwcnBjRkFxV1F0NTBJdHlYUEx0d2lpM0ZWejU1eVNL?=
 =?utf-8?B?eTFaRkZrOXVRYjU5SEkxcTM0REdtSEY1dXpScGdDL0VCN2cwaytoWFMvcGk1?=
 =?utf-8?B?TWdQRVcxYTJmTHJVKzQ0SVhTQVdOR2x5ZTBlN0hTNDB4T3QzRDJQNkMrVFo3?=
 =?utf-8?B?dFRpdXFvOGJtaDhCVm4wYnZMVG10eFBDcVpQUDZyVFRFU2Y2NUlLTWNOUXE0?=
 =?utf-8?B?dFpuaElLcmRrd0RWQWIwbm5ORC80TDdSOUs3dUlOd1JZYWdmRldBUHpROGti?=
 =?utf-8?B?ekpRNnJKODV6cW1tL3RhWlRIMUhWdE5zWUJoZjVSSUNMbGhvMEdhNGM4N21l?=
 =?utf-8?B?ZW5iZnpYVzAyTG1kN1NZbUdvN1BWdGRLdjQ4dzN6c3J1eHluR3RqdWhsOUVK?=
 =?utf-8?B?TXU4bXZPWGZqbFRWcHI3SXpUZkt5YUVjZVFoUHBocVZmZTB3RjVxODZjdFBm?=
 =?utf-8?B?dlYxdHNYNXhIa2kzS0NjT3BEd3FkSDF6T3d6cHhRbkRRbkg3dC96NWpFcjZa?=
 =?utf-8?B?bmZ6T2sydHg1eHd3Y1dOc0JHa28vaFVTczUwYmNtY2l4V3B5U3pnRHhrWmR6?=
 =?utf-8?B?RFd4MHFuem9kd3c1L3ZXZmxMOUhiZ0JrT2xaa2RCZDFtVnlISVhqWFZaS0dD?=
 =?utf-8?B?aFEwOXNOQ1VBWHpVU2UyZDlDUE5WakpUVTBTSUFtaForZVhaWEJycGhLc0V6?=
 =?utf-8?B?UXN6WUd3WW55UWFYRUtmZHQ0aFRNOFA1RnFpTjBVMXhzMU01bTV0SDhwVHNn?=
 =?utf-8?B?QVZndmZ5YUM4UnB3ZDNiVWhDek5pVlZ4VEhuMzdHaDZUZzk1c1FHTENWUlhs?=
 =?utf-8?B?MSs3enFBVUZWRWpQUjdvcWxEcGkrWGc0Qm0xRTlaNEdxc2hNWXRVZmJKRE5U?=
 =?utf-8?B?bFlCalRJR0dnTDFHWXIrN0MxRm5FTHF5djA3Y3NUVVl6RVRVbStIZVdtZnRF?=
 =?utf-8?B?SW5VSy9RRTRmUm9kenE3S0J5LzduaDRrWVJaMHd0N0VBSWVWdjdaUmZTeTRB?=
 =?utf-8?B?S3hGM2VET3FuZW1NNEQrdzB6a3FzK1NCa1NBN2dtYURRYzNncWp3Mkx1cjZG?=
 =?utf-8?B?WVJYdUxJSHpESURJV21HUTNVN0dXK2hrWDVnRm5wV0JGaWJ2NTRlbFk5Wk1q?=
 =?utf-8?B?Nmt2Y2pxMzlEcjc4ajFwTEZ5UjZhc21JNTl0amhHRDdQSlFJOVg2MUE3anp0?=
 =?utf-8?B?dnlQL3FXOFRZN25mY1pvS1FHZSs0dnY0WDhuZnkyd2I5WW9kOU1XM00zM0JX?=
 =?utf-8?B?bU1PZnZIc2dyQkZla0o2OVFIKzd1d2s2eXZPMUdWdHQzTmttMHZSZFdRY01X?=
 =?utf-8?B?VmhOTUdLZ0dKOUEzYXF5cE5ra21FZ1VYZWluWGQ2R09DWnhCdmZLQVpqUmMz?=
 =?utf-8?B?S1pMU2tFa3lMd0V3NHVKbVJQbkpDTzQ0VEdtbmxycyt1aXpiZTBKa1daSUhw?=
 =?utf-8?B?MERBMWN3Z1ltMURrUGN4ekloNC9NSkJmdzhHU3ZjRE9Ldktqbzd1M2dMU2pQ?=
 =?utf-8?B?SE9kYndjY05jaU40cE5kR1VDaU5LeXNUb3lFVURvRjBlVmFKMHhLN3BvN1lN?=
 =?utf-8?B?QU9ucjR3UXVjZnRMQi9lS2RTdzVzMkJTVlJueUYxMFhoVlFIKzI5UUVMcnh0?=
 =?utf-8?B?bmFVQXVoMnhCRytKRVNSTE1wclNBUVdZUXF6SjhUbUc1ait6RFF1cGdISlBF?=
 =?utf-8?B?aHp4bVErQUx4akpXcUxEckNGKy9kZVlucHJjZXA4S0lVQlVTejVDVTN1amlJ?=
 =?utf-8?B?RU9peGxhUGVmRU1uSUx6K0tucWZ3d2FaWm9Jc1BlWE9oNUoxSUwvNVA4Mi9H?=
 =?utf-8?B?TmVMLytzL0lHZE1sSVBkNDgyZmhrSHRxUTg5MWIwOThOeXY3U2hUL1p0VHd2?=
 =?utf-8?B?L3BMN0ozNFhpOENXTjR1RysyNFBRTlVPU1NZWHo2VmtmTUNqTUlMZHVMVzhS?=
 =?utf-8?B?NUpueWcvTCtJUVZieU5tSWFIMEN1WGo2NTA2Ymg1SGJDTXdnbEw5MVppejNl?=
 =?utf-8?Q?6ddX29Q2G4iqAssxUw4QdT8=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE6116D09A81F147924CAAEB5452BF00@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6274
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C708.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	82935fdf-5094-4d78-e53e-08de5ffbbe06
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|1800799024|36860700013|376014|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ektyL1lwbndiUW9mVnZWVWhVRzRwc1NpdlI5VUt1cjlCai9oNnVBWWJzZVN1?=
 =?utf-8?B?YStJQm40ekhVYVRyR3JKTkF2NDBNb2tTOUFheWdtNzB1R2lIZkNaK2RHSzFO?=
 =?utf-8?B?cFZGa2kyeXVJRmkyYTYzanBOL2swWjNDcWJLcDJCbkgyS1VseGVxSlZJbGtE?=
 =?utf-8?B?eVhvbWZOd2k5WjRBVjVBUFNOd28rWnh0YStJdVVKaGNFQy94cjRWQ1VMZFVC?=
 =?utf-8?B?WVBwY2YwRHI2UUdjYWFoQzUrYTB3SVhUVTNIVHoyNFZZYTU0Mk50YXdVWE82?=
 =?utf-8?B?cWxIaUowTXF2N2ZRRkIwcHlyRTZNQk9OWWc4bklteUJ1bktoeWFUUUw0bnRX?=
 =?utf-8?B?VVZpNnhRQ0xKTWgzQWtoUkJWZ3dINHZGdFA1RVhIK2QvaEc0OFNDTXVoZHg1?=
 =?utf-8?B?UnlnYTZJajNGTmo2WTVtc2t2cTZIYTdlYlZoSjlKaHB3azRuZWY3TmVuVGpH?=
 =?utf-8?B?djNGR2hSVmpiN3lENXpOakhHSDJXeFRJOXA5WnUxMHRMZkROdGY4QzZ6ZHlj?=
 =?utf-8?B?Yk5lUVBZU1pqci9TVzZtMngzZmhYVEFzcTVzQnhIOEIwUVFjZnk4T2lWZXpI?=
 =?utf-8?B?UXR0TVNaMmt4WXhxTjZuZi9hM08zUW9PdEtpZWtBNHNKOUNERHZ1WlNNb2Ja?=
 =?utf-8?B?YjAvNndIU3luSlB3bEhiOHlNMHNIdFFad3RvU3RqSFBFZVV0VEhURkptR2FL?=
 =?utf-8?B?a2pvaktjZFNFQlZ1aTR2cUxGalZyUE94NVVVU0hWdVM3c1dLR3ZiaWluT3FX?=
 =?utf-8?B?RERCbExmR3FiTzdtcHlIeU9yc1NTQ2RIcDJ5d01tdDhEdHJiZ1NwcFRJSldI?=
 =?utf-8?B?L2VjUWN5M2R5U2N4cGdLTnkwRUxGcHBXMERHb1czZnJBQUJLS1E0ZDNLTEVs?=
 =?utf-8?B?bC9LbnB1aFo2SHRObkNMYllFSExqa3g5VlR5VHdmWGl0U2RRdWtUemxhbWxF?=
 =?utf-8?B?L1BjdGthV3A3N29HTExhdnJVSXhaeHk5L3I1Z3d2VnRZaytoUUhZQm5KYXBP?=
 =?utf-8?B?ZlFlQ3ZkZDNKcHVrVXRmZG42M1JmcndYeitTeVVEZmE1b0M1VVhVY0xHZzF1?=
 =?utf-8?B?WHY5N0JIaEVTVVcra3E4V1p4UnpzOG53WEEzZElMYkw1TWNqdmxSVlJyaHA4?=
 =?utf-8?B?azhWdThtR2RYOXAwc09Ed1ZlckE4QnlFVGdENTBCVkdlYmYzWXlxVW9vdDk3?=
 =?utf-8?B?Ri9JWnVlZmx6c3lZYTdJUVdyQXVBMCtkTVRsWUpEMFM0dWlQVThvS3UxT2ZV?=
 =?utf-8?B?QmZ2T0M5YVJiTFZydy9iNEdCeDNoenZEQ1JtaDBBanhLTFBLdm8rSnJYUkEy?=
 =?utf-8?B?dktlTk5Wdks1SGF0NG83WG9peEZTU0tIY2pJWGp0ZCs3L0VwWDh1aGZTYzhR?=
 =?utf-8?B?dDdSdWxjY2IrczVKc2VyTEFCTFhZQ1FUTGpNQlI5amNMSDJQUlJiR0pSVWgz?=
 =?utf-8?B?VC91YUNRRXdsYzNTaVA4V1JKamhENU9mSlZ6cVE5bFdHbEFISGdrK0w1WTh2?=
 =?utf-8?B?WDM0bUFydXliRGY4dnMrOFZiK0x1aUlYcVZyNmdJM3ZqZXZuS2UweVQyd3pO?=
 =?utf-8?B?VHEyZEVoczdUc0MzT1FXY0c3cGhsaFdFbTNlZ1pWUjJXd1hWSFlaMTZXOVU2?=
 =?utf-8?B?bGhkSmtqa284YUtJMVV2b1QxVlFScEV6QWVyeUpody92TS9pL2RrMWRubFRv?=
 =?utf-8?B?dFNPaEpTdmg0SWNzTjRKMFhkQlNydzVweHE2MWU3enpjUFdza0RkSTNWd2Vz?=
 =?utf-8?B?WE5QT21qbERkcEhtNmU2b2Y3c2NIa3IzL01uNTl5UmlrNWhmNG1ScURZbENP?=
 =?utf-8?B?bnYwN3BzUmsyVURyblBDTDFBcHFiQUNFVm5NdTJyUExSa3NCc0ZlbVRkM0lz?=
 =?utf-8?B?WTUxQThkZms3b0U1RzBHUnZPdkV4aWlldkoxYXNFQUdRYnpCcXExT2hvc2p3?=
 =?utf-8?B?MUtxQnBUQm5Ra09WUVYvVFpzTzNCTDNwdEVycTBKdzVueEd3TW5xQU9rVTdu?=
 =?utf-8?B?OWZ5R29TMTdlOFdaUDdXc0p4Q25PVUs0azJQS2dZdnJwczVaRUJRajU2b2Vn?=
 =?utf-8?B?dW5BOTRRTUh3b00rWFJmRVVXdlhVVWlMb3hqeG85WlZTZVl2M2QreGxndnJN?=
 =?utf-8?B?WkNsZWFxRTI0dE5CaE52b25FVVZ3eEg5aUhnSEF2SWlPQS96QjNQTHViMFVs?=
 =?utf-8?B?OHMyMlAvdGsyb3BiZHBuNmhTNlJrb0VVSUFwV04wSytvUkZpRzJvbysxcTVS?=
 =?utf-8?B?TEZtK2ovN0NYYU1uT3FXVkZmV3N3PT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(1800799024)(36860700013)(376014)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EvtelALB2ZfMpZPZ7XgCbObjdJesCmjTOvmr9G/fnYgpr3pOVv7P/BHc6kOtGyZHlueYEooZM9VggTD5JPFP81s35GvGaulbfRwNMTtTFZ6GGUNMkU1xUV+QxqJqkGzntRODPL79uIGLbT2C7/8brSXqdSSFyBLI51j4gVG+BP2arfRRBIIyJMaA5pJ7rfUUkUnEJly+AfnfBznB5EH0p9xzGdbH89p/W+tcRYCTP5LDiTtnJjEEl8SsA+iM1+TySkuPlFuTMJ/tdUpjQORcbeRaAsnkQwyWakQPbDW5VNL3Vmt4JimmiGn487GuX/RwRkRQ/m0wi/uWrErTd6EV9HK34nKL9RTBaO79I+6aSlqGUEqpf+Ps4S9lSNPUds8u3eSJPaXPfW0CPGkJkAY6sti0EngjcPaEj8zorw9mcHLJ7kbhv6BWnN5AqRZcujpP
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 12:34:18.8474
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd7859eb-01f3-40ce-8ebe-08de5ffbe361
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C708.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9450
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69701-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,arm.com:dkim,arm.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[arm.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 4FC13BA920
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAxLTMwIGF0IDExOjAzICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIFdlZCwgMjggSmFuIDIwMjYgMTg6MDE6NTQgKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEFzIHBhcnQgb2YgYm9v
dGluZyB0aGUgc3lzdGVtIGFuZCBpbml0aWFsaXNpbmcgS1ZNLCBjcmVhdGUgYW5kDQo+ID4gcG9w
dWxhdGUgYSBtYXNrIG9mIHRoZSBpbXBsZW1lbnRlZCBQUElzLiBUaGlzIG1hc2sgYWxsb3dzIGZ1
dHVyZQ0KPiA+IFBQSQ0KPiA+IG9wZXJhdGlvbnMgKHN1Y2ggYXMgc2F2ZS9yZXN0b3JlIG9yIHN0
YXRlLCBvciBzeW5jaW5nIGJhY2sgaW50byB0aGUNCj4gPiBzaGFkb3cgc3RhdGUpIHRvIG9ubHkg
Y29uc2lkZXIgUFBJcyB0aGF0IGFyZSBhY3R1YWxseSBpbXBsZW1lbnRlZA0KPiA+IG9uDQo+ID4g
dGhlIGhvc3QuDQo+ID4gDQo+ID4gVGhlIHNldCBvZiBpbXBsZW1lbnRlZCB2aXJ0dWFsIFBQSXMg
bWF0Y2hlcyB0aGUgc2V0IG9mIGltcGxlbWVudGVkDQo+ID4gcGh5c2ljYWwgUFBJcyBmb3IgYSBH
SUN2NSBob3N0LiBUaGVyZWZvcmUsIHRoaXMgbWFzayByZXByZXNlbnRzIGFsbA0KPiA+IFBQSXMg
dGhhdCBjb3VsZCBldmVyIGJ5IHVzZWQgYnkgYSBHSUN2NS1iYXNlZCBndWVzdCBvbiBhIHNwZWNp
ZmljDQo+ID4gaG9zdC4NCj4gPiANCj4gPiBPbmx5IGFyY2hpdGVjdGVkIFBQSXMgYXJlIGN1cnJl
bnRseSBzdXBwb3J0ZWQgaW4gS1ZNIHdpdGgNCj4gPiBHSUN2NS4gTW9yZW92ZXIsIGFzIEtWTSBv
bmx5IHN1cHBvcnRzIGEgc3Vic2V0IG9mIGFsbCBwb3NzaWJsZSBQUElTDQo+ID4gKFRpbWVycywg
UE1VLCBHSUN2NSBTV19QUEkpIHRoZSBQUEkgbWFzayBvbmx5IGluY2x1ZGVzIHRoZXNlIFBQSXMs
DQo+ID4gaWYNCj4gPiBwcmVzZW50LiBUaGUgdGltZXJzIGFyZSBhbHdheXMgYXNzdW1lZCB0byBi
ZSBwcmVzZW50OyBpZiB3ZSBoYXZlDQo+ID4gS1ZNDQo+ID4gd2UgaGF2ZSBFTDIsIHdoaWNoIG1l
YW5zIHRoYXQgd2UgaGF2ZSB0aGUgRUwxICYgRUwyIFRpbWVyIFBQSXMuIElmDQo+ID4gd2UNCj4g
PiBoYXZlIGEgUE1VICh2MyksIHRoZW4gdGhlIFBNVUlSUSBpcyBwcmVzZW50LiBUaGUgR0lDdjUg
U1dfUFBJIGlzDQo+ID4gYWx3YXlzIGFzc3VtZWQgdG8gYmUgcHJlc2VudC4NCj4gPiANCj4gPiBT
aWduZWQtb2ZmLWJ5OiBTYXNjaGEgQmlzY2hvZmYgPHNhc2NoYS5iaXNjaG9mZkBhcm0uY29tPg0K
PiA+IC0tLQ0KPiA+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWluaXQuY8KgwqDCoCB8wqAg
NCArKysrDQo+ID4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuY8KgwqDCoMKgwqAgfCAz
Mw0KPiA+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+IMKgYXJjaC9hcm02NC9r
dm0vdmdpYy92Z2ljLmjCoMKgwqDCoMKgwqDCoMKgIHzCoCAxICsNCj4gPiDCoGluY2x1ZGUva3Zt
L2FybV92Z2ljLmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDUgKysrKysNCj4gPiDCoGlu
Y2x1ZGUvbGludXgvaXJxY2hpcC9hcm0tZ2ljLXY1LmggfCAxMCArKysrKysrKysNCj4gPiDCoDUg
ZmlsZXMgY2hhbmdlZCwgNTMgaW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9h
cmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaW5pdC5jDQo+ID4gYi9hcmNoL2FybTY0L2t2bS92Z2lj
L3ZnaWMtaW5pdC5jDQo+ID4gaW5kZXggODZjMTQ5NTM3NDkzLi42NTMzNjQyOTkxNTQgMTAwNjQ0
DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWluaXQuYw0KPiA+ICsrKyBiL2Fy
Y2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pbml0LmMNCj4gPiBAQCAtNzUwLDUgKzc1MCw5IEBAIGlu
dCBrdm1fdmdpY19oeXBfaW5pdCh2b2lkKQ0KPiA+IMKgCX0NCj4gPiDCoA0KPiA+IMKgCWt2bV9p
bmZvKCJ2Z2ljIGludGVycnVwdCBJUlElZFxuIiwNCj4gPiBrdm1fdmdpY19nbG9iYWxfc3RhdGUu
bWFpbnRfaXJxKTsNCj4gPiArDQo+ID4gKwkvKiBBbHdheXMgc2FmZSB0byBjYWxsICovDQo+ID4g
Kwl2Z2ljX3Y1X2dldF9pbXBsZW1lbnRlZF9wcGlzKCk7DQo+IA0KPiBXaGF0IGlzIHRoZSByZWFz
b24gZm9yIGNhbGxpbmcgdGhpcyBmcm9tIHRoZSBnZW5lcmljIGNvZGUsIHdoaWxlIGl0DQo+IGlz
DQo+IHY1LXNwZWNpZmljPyBJJ2QgaGF2ZSBleHBlY3RlZCB0aGlzIHRvIGJlIGVudGlyZWx5IGNv
bnRhaW5lZCBpbiB0aGUNCj4gdjUNCj4gc3Vic3lzdGVtLg0KDQpBdCB0aGlzIHBvaW50LCBJIGRv
bid0IHRoaW5rIHRoYXQgdGhlcmUgaXMgYSByZWFzb24gYW55bW9yZS4NClByZXZpb3VzbHksIGl0
IHNvbWVob3cgbWFkZSBtb3JlIHNlbnNlIHRvIG1lIHRvIGRvIGl0IGxpa2UgdGhpcw0KKGFsdGhv
dWdoLCBJIGRvIGZhaWwgdG8gc2VlIHdoeSBJIHRob3VnaHQgdGhhdCB3YXMgdGhlIGNhc2UgYXQg
dGhlDQp0aW1lKS4gSSd2ZSBqdXN0IHJld29ya2VkIHRoaXMgdG8gYmUgY2FsbGVkIGFzIHBhcnQg
b2YgcHJvYmUgKGFuZCBtYWRlDQppdCBzdGF0aWMgaW4gdGhlIHByb2Nlc3MpLg0KDQo+IA0KPiAN
Cj4gPiArDQo+ID4gwqAJcmV0dXJuIDA7DQo+ID4gwqB9DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gv
YXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMt
djUuYw0KPiA+IGluZGV4IDIzZDBhNDk1ZDg1NS4uOWJkNWE4NWJhMjAzIDEwMDY0NA0KPiA+IC0t
LSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gKysrIGIvYXJjaC9hcm02NC9r
dm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBAQCAtOCw2ICs4LDggQEANCj4gPiDCoA0KPiA+IMKgI2lu
Y2x1ZGUgInZnaWMuaCINCj4gPiDCoA0KPiA+ICtzdGF0aWMgc3RydWN0IHZnaWNfdjVfcHBpX2Nh
cHMgKnBwaV9jYXBzOw0KPiA+ICsNCj4gPiDCoC8qDQo+ID4gwqAgKiBQcm9iZSBmb3IgYSB2R0lD
djUgY29tcGF0aWJsZSBpbnRlcnJ1cHQgY29udHJvbGxlciwgcmV0dXJuaW5nIDANCj4gPiBvbiBz
dWNjZXNzLg0KPiA+IMKgICogQ3VycmVudGx5IG9ubHkgc3VwcG9ydHMgR0lDdjMtYmFzZWQgVk1z
IG9uIGEgR0lDdjUgaG9zdCwgYW5kDQo+ID4gaGVuY2Ugb25seQ0KPiA+IEBAIC01MywzICs1NSwz
NCBAQCBpbnQgdmdpY192NV9wcm9iZShjb25zdCBzdHJ1Y3QgZ2ljX2t2bV9pbmZvDQo+ID4gKmlu
Zm8pDQo+ID4gwqANCj4gPiDCoAlyZXR1cm4gMDsNCj4gPiDCoH0NCj4gPiArDQo+ID4gKy8qDQo+
ID4gKyAqIE5vdCBhbGwgUFBJcyBhcmUgZ3VhcmFudGVlZCB0byBiZSBpbXBsZW1lbnRlZCBmb3Ig
R0lDdjUuDQo+ID4gRGV0ZXJlcm1pbmUgd2hpY2gNCj4gPiArICogb25lcyBhcmUsIGFuZCBnZW5l
cmF0ZSBhIG1hc2suDQo+ID4gKyAqLw0KPiA+ICt2b2lkIHZnaWNfdjVfZ2V0X2ltcGxlbWVudGVk
X3BwaXModm9pZCkNCj4gPiArew0KPiA+ICsJaWYgKCFjcHVzX2hhdmVfZmluYWxfY2FwKEFSTTY0
X0hBU19HSUNWNV9DUFVJRikpDQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsNCj4gPiArCS8qIE5ldmVy
IGZyZWVkIGFnYWluICovDQo+ID4gKwlwcGlfY2FwcyA9IGt6YWxsb2Moc2l6ZW9mKCpwcGlfY2Fw
cyksIEdGUF9LRVJORUwpOw0KPiA+ICsJaWYgKCFwcGlfY2FwcykNCj4gPiArCQlyZXR1cm47DQo+
IA0KPiBNYXliZSB3ZSBjYW4gc3BhcmUgdGhlIGNhbGwgYnkgc3RhdGljYWxseSBhbGxvY2F0aW5n
IHRoZSBQUEkNCj4gc3RydWN0dXJlPyBKdXN0IHRoZSBjb2RlIGNhbGxpbmcga3phbGxvYygpIGNv
c3RzIHVzIG1vcmUgdGhhbiB0aGUgMTI4DQo+IGJpdHMgcmVxdWlyZWQgYnkgdGhlIHN0cnVjdHVy
ZS4NCg0KWWVhaCwgaXQgZG9lc24ndCByZWFsbHkgc2F2ZSB1cyBhbnl0aGluZy4gSSd2ZSBkcm9w
cGVkIHRoZSBkeW5hbWljDQphbGxvY2F0aW9uIGFuZCBtYWRlIGl0IHN0YXRpYyBpbnN0ZWFkLg0K
DQpUaGFua3MsDQpTYXNjaGENCg0KPiANCj4gVGhhbmtzLA0KPiANCj4gCU0uDQo+IA0KDQo=

