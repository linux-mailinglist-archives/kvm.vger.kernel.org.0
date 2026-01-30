Return-Path: <kvm+bounces-69742-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aKXMOfLnfGlTPQIAu9opvQ
	(envelope-from <kvm+bounces-69742-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 18:18:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 428D3BCF39
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 18:18:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 04F6D305EC2A
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 17:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EAB7356A07;
	Fri, 30 Jan 2026 17:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="X+d5I+0V";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="X+d5I+0V"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013064.outbound.protection.outlook.com [40.107.162.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD7932FA1E
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 17:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.64
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769793269; cv=fail; b=OApCeGvPgjN6C8d+guG3AjtDrFtpTbdvydWAv0cKlJHvLeab/rKPXHilsqDLjSRIjIJTzrC2yrzQRoF+kbIst3qWNotbQBZbjhIZtbmY9Sf4LV+TVbpevLOfDiqidJM/wiqOgvrr+j5A288vC5+rtWHV7KuNSQgZE03Zss39h+w=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769793269; c=relaxed/simple;
	bh=hX8giXm9jErlUnuq1R8g8L8hAdYVZfwLLCT8hghqe8k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j8ynOW/7svdPRxVv3k4gpL60pqn/3GoV/dXtdJZFXi4D/e47vE19EkravkpiExXZewCEYTaKW1FuGxa/X0kDwUYBrFT8m4JHe5TxlWPPb9jGi60bCjfnB7hzUSrZ3lUzgGvGktWuilPbsAqFkgk9UgU9NPJYRPQ4RWnhrJEFES8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=X+d5I+0V; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=X+d5I+0V; arc=fail smtp.client-ip=40.107.162.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=gwgDljvDUKeLrj2LYKI6UcYH9lWMItQf9dHxeqBPlGrf5ij7MbA04LVUHp1+V0jlGiZZX5i+Nbw8Wh1GBVlIVn1jUNUNiMw+XSOurcg52OcyJOAUl9LkQgzT9HJE3TFMbTgzylOYi8Vu4FBsZCkm8Pm69k3M03ceEXelm9PG2gzy16KRBYSn8CpSZAcPhqgw9iCnp1lC/iCqNaSrzotU8WKpJaeI/0hk+mzDwyRXTJN7awBMpbBqp/ySk9rJKOx29ir8fS/CTzoUJJVw/LC+0oA4dknYuPE5wjd0z8doq5NhgZf9Lm/VozN2ULXk0GERRu9xZ7ly55Jns5iYWfUeqQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hX8giXm9jErlUnuq1R8g8L8hAdYVZfwLLCT8hghqe8k=;
 b=CM2czw7slLHvjO9p+fboFAaxXJ/ECU+NOYywiKhEkHEVA4s9yEXMrT4jSpLcpm8WwmuvXJi29solIqIjk/RcJX38lLfjxJymp2hZ5eRFkBa7U92oexibAFGMkhYGfl1A0ANFqbHdiMdpCmNTd02DHqGhBJ0uHiAP1HZYkvACXD6/QaMpXmoAQmHURQMYHR4RglVZxOGaBSz+tPajW2M9aIzKVALeTOfyzecAMtaeDKU+JNrnN76KsYiu3hBK+dnQX0Qdco5uyRwtu4t74TcsvucV5LDqduvTDCubP5GdLg8Cpt2mK/WGreMwwHR759KPUdPAaG5j7SNu+LON4dk3Fg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hX8giXm9jErlUnuq1R8g8L8hAdYVZfwLLCT8hghqe8k=;
 b=X+d5I+0VAB/n/hELnh7pao/eTXhuYjYCNUEQj8oQxFEfl1BCACYeSjKzMAP82DEmES8d0P8a2G8ov0xq6R4r+nEbMs9Oin1uGp6melDG1cZJlHRIidQN81xXbjzB9N4WNsfu46o7w5J6mvtvPuSB7pqrMpOj/7y7qybexqH2Uz4=
Received: from DU7PR01CA0017.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50f::19) by VI1PR08MB5342.eurprd08.prod.outlook.com
 (2603:10a6:803:132::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.9; Fri, 30 Jan
 2026 17:14:22 +0000
Received: from DB1PEPF000509F9.eurprd02.prod.outlook.com
 (2603:10a6:10:50f:cafe::45) by DU7PR01CA0017.outlook.office365.com
 (2603:10a6:10:50f::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.11 via Frontend Transport; Fri,
 30 Jan 2026 17:14:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F9.mail.protection.outlook.com (10.167.242.155) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Fri, 30 Jan 2026 17:14:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yBPLPP9YXV+FKlkSJQe7QAalplT0/Uo7B43FSO5tc7lzgR5bbrpG7ojmmxqMzXWAIl/s/wxWZYI97OGnkrUArk5jmmeTwcUuzCOvf91886TSSdEGiMuaV7+liZpJrRT+XVnGErp14+jvCNMnFDMBpZE66VgxZ4CL2d/SAHx0eEF/dcGI0igGbCphfEMKiJKg8s1YOHTKKxOEYsxDC5xS2hvIVkjDAvA1in5P6kPr6+e6cK9BW1xteCJqPE2gaLB6KHmYBESB7DEDozMqTQ4fwKv986P2qhbzsau7qrBTSnYBE+v+TJQ+vR5jHou/wiwVQr7NuaGya/H+V2tf1Txt9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hX8giXm9jErlUnuq1R8g8L8hAdYVZfwLLCT8hghqe8k=;
 b=aUYb1C3ZvKlgvwMzg0uRTltJXdds3/pYBX0x84QBBO+P+ofTmebIuyRYGJFGvOAU2LP9vnU89Nb74+F0ligIlR4PNQGfSCR60ALQCUTK8DGqERE7g/CRKZMWF2NADEENUD5zX/vk/sVjtwYYoqsNYBzM1eJHLnYs5oHojt8qYm+Fa0T9wER3m+OzPIRw/n4mGJxLFUpB0HxqSNRRBDCBjn9AvEae900ouVDYsPG8/A/5SQJ6J9Iawrr8sOu7IQYEhmPXZNtupyk2Cy/aercL4TCzWOf/8NjfI4UmEbnYVliJNGT7U7ISfUEP/FpJs0OoafTqrDzoAl2BzLgDzcbbww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hX8giXm9jErlUnuq1R8g8L8hAdYVZfwLLCT8hghqe8k=;
 b=X+d5I+0VAB/n/hELnh7pao/eTXhuYjYCNUEQj8oQxFEfl1BCACYeSjKzMAP82DEmES8d0P8a2G8ov0xq6R4r+nEbMs9Oin1uGp6melDG1cZJlHRIidQN81xXbjzB9N4WNsfu46o7w5J6mvtvPuSB7pqrMpOj/7y7qybexqH2Uz4=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by GV1PR08MB11026.eurprd08.prod.outlook.com (2603:10a6:150:1ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Fri, 30 Jan
 2026 17:13:18 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 17:13:18 +0000
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
Subject: Re: [PATCH v4 11/36] KVM: arm64: gic-v5: Sanitize
 ID_AA64PFR2_EL1.GCIE
Thread-Topic: [PATCH v4 11/36] KVM: arm64: gic-v5: Sanitize
 ID_AA64PFR2_EL1.GCIE
Thread-Index: AQHckIA4JFetpw4etkOirhfjQwNVw7VqmMUAgABdrYA=
Date: Fri, 30 Jan 2026 17:13:18 +0000
Message-ID: <6a45dd02fdd2e70e0722dc5b3087ecfb18f01e98.camel@arm.com>
References: <20260128175919.3828384-1-sascha.bischoff@arm.com>
	 <20260128175919.3828384-12-sascha.bischoff@arm.com>
	 <861pj7baav.wl-maz@kernel.org>
In-Reply-To: <861pj7baav.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|GV1PR08MB11026:EE_|DB1PEPF000509F9:EE_|VI1PR08MB5342:EE_
X-MS-Office365-Filtering-Correlation-Id: c8b5e958-938e-4272-3fbc-08de6023027b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?TVhhWXpaSTZycHIvd2lJZWV5d1RtNHliMzgya0dUYWJJbGQ3YS8ybktMSkFq?=
 =?utf-8?B?Z0FiWEtrR2FmVHJEY1JhOENVUUxVWitSanJsTFRuK2srSDh0TlVhTkZRZVR1?=
 =?utf-8?B?MmFYVHN3OHRkalYweUFOd3lYZGZmY1p1S3hlK2swVE9QVkN0ZG56SzhmbU8y?=
 =?utf-8?B?WmF2bzkyMzd2YWl2MGtXRFptOVJHbGVjMjhzQ05iNm9wM1ptOXFIbVpZOGY4?=
 =?utf-8?B?YlN1MTRsVUF2WURhSTVTYStjOHFRdko5WkhuZm1kaW5rNmRkWWxId2V6Wjg5?=
 =?utf-8?B?QUxVZXlDY3FjcFgwUi9hY3JnN1ZpdnFFbE9UbXlXZXFLbnMzSnhFTFVCTUFx?=
 =?utf-8?B?M09LY0g5eHFvWWxKT3huSTV0am1McHRjRHNHSFZOUUpLclh2bWd5bHIrb2do?=
 =?utf-8?B?dk9HN3dkc2N0Z2cvVUxaVGlnZVVxcFV4UU1WbEN2eGNLZDd1SlF6ZW1kaFRw?=
 =?utf-8?B?VE1VSlYyR1NRQ1hsRXJGdXlOeVNnd2dSTTAyT2JNTi9OejdLY2xpQVc2ZzNX?=
 =?utf-8?B?bGpkRjBRR25reVVCYWM5dURycUpvZUsrdDIzMUcyakdBb25SZVlpdDZ2NHBi?=
 =?utf-8?B?ZHNxb01GWXJkSnBlN1ArZlJTQ24wdEJBSitFU1BJNVowd0Y1Zk52RzBxZW1C?=
 =?utf-8?B?L0JXMUxsU21NNVMxSDVkTHp4dUVlS2lUaUtqRkJPUmdWcTVOZHpMM2QwS25R?=
 =?utf-8?B?dHdSN20zcjRiWHBtdjFBMnJxYWYyaHRwWk0zaFR0L1A1YnRyRWl3cXJ0SitS?=
 =?utf-8?B?NzZmdWJPTzFjOHV1UVJ3bjM2cnZ3b3h1RkQ4L2k2L2VsM1JoSUlaOWdmYjA4?=
 =?utf-8?B?RVo5cWdWZEZGa3dxcnNhTTZ4Y3pQZTJWaFNmb25oWVZscEJtcENPL1VpaE80?=
 =?utf-8?B?NG96bDFEb0x6SHZLVHI1S2pncjhpaEtiS1pQeVA1ZDg4eXhoL1ZYWlEybkxZ?=
 =?utf-8?B?MHlTZGJoYUprdWVBcTQrSlhyZG1uVXlXSnBodWxVcVZaSnF5dk5QbVM1dU5L?=
 =?utf-8?B?S3FKdmJZQVpjM2VYd1M0SDlETmNvZE94QWkzdmE5aVgyT0ZUTGVDcXdzNENR?=
 =?utf-8?B?L0FDU29UWisxMXgxbFo2cXdjd2toRnZxQ1VMSjQxdkVsQnZ2Smc2UUhCV0hw?=
 =?utf-8?B?c2svM2lSV3RJOWg3YUZGYStndDZLQ245bUFRVzB6b2lLbGtYNjBoT0FUTEdu?=
 =?utf-8?B?M0ZYZXNWcUhnOVM4K2R5OEFHdW42VEIxTDUwMFIrbHFObERKUTRqd3ZVc2dX?=
 =?utf-8?B?SlRLK2s5WVhxa1lyTzNKZmVIeDJqMnBiQ3NEMzNqRkg3WE9PVHRXdmlqVnNS?=
 =?utf-8?B?UzQyS1BDbm1teXVOVGs5akJDbE4vZVlYNmdsNnlLTis1a2ZoaDhtejdLUmoy?=
 =?utf-8?B?S1ZjdUpuMGwxR0RhUk1mMGEvOW94UDZDM0xqWXVnTlYvemg4MlJOMUdZR1JO?=
 =?utf-8?B?UFAzN3Q1SmU5SkdQcHJ6bzhPS2dsZExCU1NmK3dkNkFZS0t0cG5FR1NUZG01?=
 =?utf-8?B?dHhRTmYvN1dwaFRrcHNPbDl3dFZWUmYxSVJPZS8zaXdabnd4TkhEN2xNMDd1?=
 =?utf-8?B?MVpBa0hlUXZ4akZzQ2dHUEZkR3c5eEhTZGE4ZUtURklMYzdwb3B0TmpvT3Vn?=
 =?utf-8?B?YXczWlRCaStQZDF2cjRvMDY0Vjg3SmtrUUlDOGI0NWgrS2RENy9HdmxKdjl6?=
 =?utf-8?B?Q0FuS21OR3dQVUhJZld0Q1FwN29CeFluWDBYWHo1QVNRaUtmOEhNZExsa3Zu?=
 =?utf-8?B?dk4rS0RCV3UvdjRMSWo1RWx1TWtUb3I4S1h1RGJIcHZXUDJJZGhPT1FSS3Fq?=
 =?utf-8?B?Z2hrYmNYejdRTEEvQTlOeGtsYVRyT3g3Nk5sZzdJNWkxZk5rYVVpSkVvOGVz?=
 =?utf-8?B?MG9oeEVPWUVDQzJEUk9FOHhHa05uZ1pMb2t4UEZROEQzRUpDMUY3ZVluYmFP?=
 =?utf-8?B?RXNaekd0SWZRU24veEMxRGliQm84bzVTVzl2YXNHNmVoQzNuaU9EM3cyWmJJ?=
 =?utf-8?B?T09HK1QyZ1NEeDlUWjVscExiMEdhdzBqMVgrcTF2OGhWOUZXZk5WRTI1QUZO?=
 =?utf-8?B?RG14SWsxTkVwOC81VjhvN0orVXRiQVdpazhKOGhzQmNOZUtMUmEweTh5c1Jz?=
 =?utf-8?B?cXFmT0ZESG5uU1lpWjI2RmttM0xobnE4K2xKTE5iY3VsMmhwaW1qWmdWZU1p?=
 =?utf-8?Q?uTQM04LtYJGk3YoHZdlEzRA=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <C6949E51DE9EBA42BF6E2F9A8C00C12E@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB11026
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F9.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8e54c6ed-89ac-4ee6-e12d-08de6022dce1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700013|14060799003|376014|30052699003|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dnkvYU5QNXNkakdtSXRIYlhIdTB2QXRQbytER05CVTZFMTFTMmEvWnlNVUho?=
 =?utf-8?B?R090UVVOQWtBN09ZV1VYbjIxd2xGeG5sOSttU3RoRlBKUjF3eEtYZHJvWWRF?=
 =?utf-8?B?ZXNmSTdNeldHNjVCZWw1Y1dmelBFQ2lEckVkVEU5RnpCc1YxdHN4VUhJOHY1?=
 =?utf-8?B?N2tFaVdrSVErMU1LdWVEcEl3SFVnQWVJcFhtNE5CR09sbmJkSVpzK2UxTGJX?=
 =?utf-8?B?d29RTXYwSzc0OGJsb3EybG5NR0hySWVrRThIc0pFRDNOQzNDTTBlRkdCQUp0?=
 =?utf-8?B?V0c1SkxITlZORzU0bzlJSkRVUXV5WTNzMEVzVkptTE1ZbEZrSlRham9HV1FV?=
 =?utf-8?B?VG5Cek1GME1TdUxqQWhmTy9GdHc2a0tTYVFiL3JLYVlrWk9HUVBMbEt6RFZ6?=
 =?utf-8?B?VVh1SjVrQXF6M1paVktrZ0F4RW92OGVUeGxYY211MnFXaS9nVzdxRVA5b2Fs?=
 =?utf-8?B?N0xSUlhTR3hpVHZIMHYvRDE1V0dNT1YvYkRKaVRaZVNUTUZGd3pwcjVpQkJJ?=
 =?utf-8?B?d3dYd2pwT1Q4enFCQ2hwUDg4L1Z5NE9BVTlEbEFJNTRVdGIrbXJvek40bVZQ?=
 =?utf-8?B?SVJtSkNQcU92dER6QlBaVGRJVVdDTGI3dkxFNld1NzhzYnMrS1A4bmFmdWMy?=
 =?utf-8?B?TDg0Z1l2eGhweHlGeFp3Nk4xaW5SdE9VMmhWa04rSitQT3JjZ2JnWW1uaDVD?=
 =?utf-8?B?dUFlQndXdUxETHlnOFU0dnV2SytEbTRlVVFCemNmeWdWUU9YcG5MWlpOaUp4?=
 =?utf-8?B?SExVYy9qNzBmbi8vWWxsVzBZWWJXamZCU2F5ejJ2bmZTYWdDLzdiWHlEdEJs?=
 =?utf-8?B?WkJ6Q3lQTlRpajExdXcrMjBWcG5XdEIzMVp5N3FqVHlBK1NGRTVJMFZqc2ky?=
 =?utf-8?B?YjdlU29pdVV2MXlibGdwVHpvVEhvVVZ3a2Fka0pRbURyY25zSHJYZnV3RVRY?=
 =?utf-8?B?ZTBXQ3dUS3h6QUZEL1V3L2ZrRXBFWEkzSVdsMm5maTF2NjdEZDZ4S01LWEhE?=
 =?utf-8?B?Rk5DVXpkMU9ib2V2K21qanhuWjV5ZXEraUY3MnlEUGdjMURyTStRSnFMS3ZH?=
 =?utf-8?B?bkhFTDBFNUxKMmlJaTBSUUZWeXhFc1h5dE1IN21MeFFNME1IOWVVeE1CRktH?=
 =?utf-8?B?a25NblhJZ3RsQXRjaUxnbFJPNmk2THZneWRNamRyTkVvYUFtQldsS25XOERX?=
 =?utf-8?B?VlhlWmhBa3gzMU0ybys5aGhndXhpOEFiYjFYaGV2djlma284dlRZQ3ZmOTdn?=
 =?utf-8?B?R3hIbWsrbnRPMU9YaG5pVzNLZDdvWllyK3lqRnJXemtJd1hmRWRpWUtrb2hD?=
 =?utf-8?B?cGN4OVZFbGJWbitNZ2EzOTN4K0lLWE9yQytld1FxSGNaYWI4QzB2ZTF3TFVG?=
 =?utf-8?B?dzJoU2xPZHNTU05ab2NZUUpvalVCTHNBajhxRWJnaDJrWERuc29qRjVvZ0ps?=
 =?utf-8?B?L0tPc0FGa01hcnlzYU11QURtWHRnQW5TTUJvTm4yWjNoY3kwOERPUnJic2Np?=
 =?utf-8?B?Vk9tWXNHcWhERElQZm9XV0lNaDNQUTJYUVIyQ0FuU1pTaSt3WDNjY0lxRTUy?=
 =?utf-8?B?S1dZV1BIU0luQU9wQktsQXRLUjdwcEJ1c0RJMVh3ZE4wZDYySzQ4ZFFuSHlK?=
 =?utf-8?B?WDg5YnJyaWRWOEVST29XTzRUQnB2eVlOQllJTU9ic2FQYjgxT25FeUVqakMx?=
 =?utf-8?B?aTZ5bVpqdGFKeFBzTW5sdzhMa2tORmRlUFhIZ1ZIVlF2Zmc3a0dHWkcrRG5m?=
 =?utf-8?B?WTh2NU90Q3ExSE9GRld3NjdDaG40eEtGSTk4bCt4bFNiWk93SEd3aWM4Szdn?=
 =?utf-8?B?S3B4SGxjcE5wSSszMGh0Q012ME5kT2xIK3RQb21Eay9NSnI4c2JMNGFHVW04?=
 =?utf-8?B?aWYrN2QramRVSXdzLzJkOFZsemRwb0FLZWt0MzlqL1hUdUtHbEtOU1BtUUt3?=
 =?utf-8?B?MGtTelZ4NGZjN3NFYmxXdjIwbFNWOElZa2U4NEoxSFJiNGkxaXlrT3R1QjdP?=
 =?utf-8?B?Q0JldURESzRWZkp3ZmxEZVlsSjNsNWRFdmJodkg5eE5yeWRGZjM4c0gxK2Jr?=
 =?utf-8?B?SmVpZHY4MzZjWnJ1T0Q4RTZlL3g3bkNGbnA2ZDRFcDduWTBlcUNSM3I4Qmk5?=
 =?utf-8?B?OS8wRjNxQXpNdEwraVJreFZMSUV3bExtUTNyR2czSWZHaEYxOEc3RndpcHFy?=
 =?utf-8?B?bS9QclJTbCtLRDYzcnlTQkFUQU9VMXIxQm1oUC9FUmtlTDFlUm5TSHJGSEhI?=
 =?utf-8?B?Tyt2S1pvSDVaZldnZFhkeTc2SEVRPT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700013)(14060799003)(376014)(30052699003)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JjF+Is2LuQMRFlffIHPWrkwCQpXg1YEt3lvJwPTyQ5hUAlY0ooKF3QVn93cXpcWuW5moA1aevMJG1UhCGL4UMSOCMQnV0dFDwxobrVqQKbM6S0idZJKO2IEZFUYxs8ypIzSscisvqESiuqjxU8nXX+GlnjcVe6S52hSDB/HshO+iJsLioJlxVBxO7CkrNoYXJpPQa+kof9WH8kJMz4H+tSa+M2rl/byIeHCxfF8O+7unIc71NB7O+u02M5YLN51TKo40ALrqMSPa34EeHOX8Soj0ZvFlW9IylCA4ZfemVNeFyhvaGQObY1zUojaQZISXzo4pfEoR/VHldWRkfqTR5QLPUbK+5r82grm0cJuolTLCEBYaeHO9It+oUMUdEh0fyjzeV+8QENkMHBBp3NtzzLUAx2Anv1MMBOpGPQvDoa9aWLEMFuySgiLakSpYZKj0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 17:14:21.3852
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8b5e958-938e-4272-3fbc-08de6023027b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F9.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5342
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69742-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:email,arm.com:dkim,arm.com:mid];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[arm.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
X-Rspamd-Queue-Id: 428D3BCF39
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAxLTMwIGF0IDExOjM4ICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIFdlZCwgMjggSmFuIDIwMjYgMTg6MDI6MDkgKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IFNldCB0aGUgZ3Vlc3Qn
cyB2aWV3IG9mIHRoZSBHQ0lFIGZpZWxkIHRvIElNUCB3aGVuIHJ1bm5pbmcgYSBHSUN2NQ0KPiA+
IFZNLA0KPiA+IE5JIG90aGVyd2lzZS4gUmVqZWN0IGFueSB3cml0ZXMgdG8gdGhlIHJlZ2lzdGVy
IHRoYXQgdHJ5IHRvIGRvDQo+ID4gYW55dGhpbmcgYnV0IHNldCBHQ0lFIHRvIElNUCB3aGVuIHJ1
bm5pbmcgYSBHSUN2NSBWTS4NCj4gPiANCj4gPiBBcyBwYXJ0IG9mIHRoaXMgY2hhbmdlLCB3ZSdy
ZSBhbHNvIHJlcXVpcmVkIHRvIGV4dGVuZA0KPiA+IHZnaWNfaXNfdjNfY29tcGF0KCkgdG8gY2hl
Y2sgZm9yIHRoZSBhY3R1YWwgdmdpY19tb2RlbC4gVGhpcyBoYXMNCj4gPiBvbmUNCj4gPiBwb3Rl
bnRpYWwgaXNzdWUgLSBpZiBhbnkgb2YgdGhlIHZnaWNfaXNfdiooKSBjaGVja3MgYXJlIHVzZWQg
cHJpb3INCj4gPiB0bw0KPiA+IHNldHRpbmcgdGhlIHZnaWNfbW9kZWwgKHRoYXQgaXMsIGJlZm9y
ZSBrdm1fdmdpY19jcmVhdGUpIHRoZW4NCj4gPiB2Z2ljX21vZGVsIHdpbGwgYmUgc2V0IHRvIDAs
IHdoaWNoIGNhbiByZXN1bHQgaW4gYSBmYWxzZS1wb3NpdGl2ZS4NCj4gPiANCj4gPiBDby1hdXRo
b3JlZC1ieTogVGltb3RoeSBIYXllcyA8dGltb3RoeS5oYXllc0Bhcm0uY29tPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IFRpbW90aHkgSGF5ZXMgPHRpbW90aHkuaGF5ZXNAYXJtLmNvbT4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBTYXNjaGEgQmlzY2hvZmYgPHNhc2NoYS5iaXNjaG9mZkBhcm0uY29tPg0KPiA+
IFJldmlld2VkLWJ5OiBKb25hdGhhbiBDYW1lcm9uIDxqb25hdGhhbi5jYW1lcm9uQGh1YXdlaS5j
b20+DQo+ID4gLS0tDQo+ID4gwqBhcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jwqAgfCA0MiArKysr
KysrKysrKysrKysrKysrKysrKysrKysrKystLS0tDQo+ID4gLS0tLQ0KPiA+IMKgYXJjaC9hcm02
NC9rdm0vdmdpYy92Z2ljLmggfCAxMCArKysrKysrKy0NCj4gPiDCoDIgZmlsZXMgY2hhbmdlZCwg
NDMgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEv
YXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYyBiL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMNCj4g
PiBpbmRleCA4OGE1N2NhMzZkOTYuLjczZGQyYmQ4NWM0ZiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNo
L2FybTY0L2t2bS9zeXNfcmVncy5jDQo+ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3Mu
Yw0KPiA+IEBAIC0xNzU4LDYgKzE3NTgsNyBAQCBzdGF0aWMgdTggcG11dmVyX3RvX3BlcmZtb24o
dTggcG11dmVyKQ0KPiA+IMKgDQo+ID4gwqBzdGF0aWMgdTY0IHNhbml0aXNlX2lkX2FhNjRwZnIw
X2VsMShjb25zdCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ID4gdTY0IHZhbCk7DQo+ID4gwqBz
dGF0aWMgdTY0IHNhbml0aXNlX2lkX2FhNjRwZnIxX2VsMShjb25zdCBzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsDQo+ID4gdTY0IHZhbCk7DQo+ID4gK3N0YXRpYyB1NjQgc2FuaXRpc2VfaWRfYWE2NHBm
cjJfZWwxKGNvbnN0IHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gPiB1NjQgdmFsKTsNCj4gPiDC
oHN0YXRpYyB1NjQgc2FuaXRpc2VfaWRfYWE2NGRmcjBfZWwxKGNvbnN0IHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSwNCj4gPiB1NjQgdmFsKTsNCj4gPiDCoA0KPiA+IMKgLyogUmVhZCBhIHNhbml0aXNl
ZCBjcHVmZWF0dXJlIElEIHJlZ2lzdGVyIGJ5IHN5c19yZWdfZGVzYyAqLw0KPiA+IEBAIC0xNzgz
LDEwICsxNzg0LDcgQEAgc3RhdGljIHU2NCBfX2t2bV9yZWFkX3Nhbml0aXNlZF9pZF9yZWcoY29u
c3QNCj4gPiBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ID4gwqAJCXZhbCA9IHNhbml0aXNlX2lk
X2FhNjRwZnIxX2VsMSh2Y3B1LCB2YWwpOw0KPiA+IMKgCQlicmVhazsNCj4gPiDCoAljYXNlIFNZ
U19JRF9BQTY0UEZSMl9FTDE6DQo+ID4gLQkJdmFsICY9IElEX0FBNjRQRlIyX0VMMV9GUE1SIHwN
Cj4gPiAtCQkJKGt2bV9oYXNfbXRlKHZjcHUtPmt2bSkgPw0KPiA+IC0JCQkgSURfQUE2NFBGUjJf
RUwxX01URUZBUiB8DQo+ID4gSURfQUE2NFBGUjJfRUwxX01URVNUT1JFT05MWSA6DQo+ID4gLQkJ
CSAwKTsNCj4gPiArCQl2YWwgPSBzYW5pdGlzZV9pZF9hYTY0cGZyMl9lbDEodmNwdSwgdmFsKTsN
Cj4gPiDCoAkJYnJlYWs7DQo+ID4gwqAJY2FzZSBTWVNfSURfQUE2NElTQVIxX0VMMToNCj4gPiDC
oAkJaWYgKCF2Y3B1X2hhc19wdHJhdXRoKHZjcHUpKQ0KPiA+IEBAIC0yMDI0LDYgKzIwMjIsMjMg
QEAgc3RhdGljIHU2NCBzYW5pdGlzZV9pZF9hYTY0cGZyMV9lbDEoY29uc3QNCj4gPiBzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUsIHU2NCB2YWwpDQo+ID4gwqAJcmV0dXJuIHZhbDsNCj4gPiDCoH0NCj4g
PiDCoA0KPiA+ICtzdGF0aWMgdTY0IHNhbml0aXNlX2lkX2FhNjRwZnIyX2VsMShjb25zdCBzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ID4gdTY0IHZhbCkNCj4gPiArew0KPiA+ICsJdmFsICY9IElE
X0FBNjRQRlIyX0VMMV9GUE1SIHwNCj4gPiArCcKgwqDCoMKgwqDCoCBJRF9BQTY0UEZSMl9FTDFf
TVRFRkFSIHwNCj4gPiArCcKgwqDCoMKgwqDCoCBJRF9BQTY0UEZSMl9FTDFfTVRFU1RPUkVPTkxZ
Ow0KPiA+ICsNCj4gPiArCWlmICgha3ZtX2hhc19tdGUodmNwdS0+a3ZtKSkgew0KPiA+ICsJCXZh
bCAmPSB+SURfQUE2NFBGUjJfRUwxX01URUZBUjsNCj4gPiArCQl2YWwgJj0gfklEX0FBNjRQRlIy
X0VMMV9NVEVTVE9SRU9OTFk7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJaWYgKHZnaWNfaXNfdjUo
dmNwdS0+a3ZtKSkNCj4gPiArCQl2YWwgfD0gU1lTX0ZJRUxEX1BSRVBfRU5VTShJRF9BQTY0UEZS
Ml9FTDEsIEdDSUUsDQo+ID4gSU1QKTsNCj4gDQo+IFlvdSBwcm9iYWJseSB3YW50IHRvIGNsZWFy
IHRoZSBmaWVsZCBiZWZvcmUgb3InaW5nIHNvbWV0aGluZyBpbiwgb3INCj4geW91IG1heSBiZSBw
cm9taXNpbmcgbW9yZSB0aGFuIHdlJ2QgZXhwZWN0Lg0KDQpUaGUgR0NJRSBmaWVsZCBzaG91bGQg
YWxyZWFkeSBiZSB6ZXJvZWQgYXQgdGhpcyBwb2ludCBhcyBpdCBpcyBmaWx0ZXJlZA0Kb3V0IHRv
IGJlZ2luIHdpdGguIElmIHdlIGhhdmUgR0lDdjUgKHNvIEZFQVRfR0NJRSkgd2UncmUgZXhwbGlj
aXRseQ0Kc2V0dGluZyB0aGlzIGZpZWxkIHRvIElNUCwgZWxzZSBOSS4NCg0KPiANCj4gPiArDQo+
ID4gKwlyZXR1cm4gdmFsOw0KPiA+ICt9DQo+ID4gKw0KPiA+IMKgc3RhdGljIHU2NCBzYW5pdGlz
ZV9pZF9hYTY0ZGZyMF9lbDEoY29uc3Qgc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiA+IHU2NCB2
YWwpDQo+ID4gwqB7DQo+ID4gwqAJdmFsID0gSURfUkVHX0xJTUlUX0ZJRUxEX0VOVU0odmFsLCBJ
RF9BQTY0REZSMF9FTDEsDQo+ID4gRGVidWdWZXIsIFY4UDgpOw0KPiA+IEBAIC0yMjIxLDYgKzIy
MzYsMTYgQEAgc3RhdGljIGludCBzZXRfaWRfYWE2NHBmcjFfZWwxKHN0cnVjdA0KPiA+IGt2bV92
Y3B1ICp2Y3B1LA0KPiA+IMKgCXJldHVybiBzZXRfaWRfcmVnKHZjcHUsIHJkLCB1c2VyX3ZhbCk7
DQo+ID4gwqB9DQo+ID4gwqANCj4gPiArc3RhdGljIGludCBzZXRfaWRfYWE2NHBmcjJfZWwxKHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gPiArCQkJwqDCoMKgwqDCoMKgIGNvbnN0IHN0cnVjdCBz
eXNfcmVnX2Rlc2MgKnJkLCB1NjQNCj4gPiB1c2VyX3ZhbCkNCj4gPiArew0KPiA+ICsJaWYgKHZn
aWNfaXNfdjUodmNwdS0+a3ZtKSAmJg0KPiA+ICsJwqDCoMKgIEZJRUxEX0dFVChJRF9BQTY0UEZS
Ml9FTDFfR0NJRV9NQVNLLCB1c2VyX3ZhbCkgIT0NCj4gPiBJRF9BQTY0UEZSMl9FTDFfR0NJRV9J
TVApDQo+ID4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ID4gKw0KPiA+ICsJcmV0dXJuIHNldF9pZF9y
ZWcodmNwdSwgcmQsIHVzZXJfdmFsKTsNCj4gPiArfQ0KPiA+ICsNCj4gPiDCoC8qDQo+ID4gwqAg
KiBBbGxvdyB1c2Vyc3BhY2UgdG8gZGUtZmVhdHVyZSBhIHN0YWdlLTIgdHJhbnNsYXRpb24gZ3Jh
bnVsZSBidXQNCj4gPiBwcmV2ZW50IGl0DQo+ID4gwqAgKiBmcm9tIGNsYWltaW5nIHRoZSBpbXBv
c3NpYmxlLg0KPiA+IEBAIC0zMjAyLDEwICszMjI3LDExIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qg
c3lzX3JlZ19kZXNjDQo+ID4gc3lzX3JlZ19kZXNjc1tdID0gew0KPiA+IMKgCQkJCcKgwqDCoMKg
wqDCoCBJRF9BQTY0UEZSMV9FTDFfUkVTMCB8DQo+ID4gwqAJCQkJwqDCoMKgwqDCoMKgIElEX0FB
NjRQRlIxX0VMMV9NUEFNX2ZyYWMgfA0KPiA+IMKgCQkJCcKgwqDCoMKgwqDCoCBJRF9BQTY0UEZS
MV9FTDFfTVRFKSksDQo+ID4gLQlJRF9XUklUQUJMRShJRF9BQTY0UEZSMl9FTDEsDQo+ID4gLQkJ
wqDCoMKgIElEX0FBNjRQRlIyX0VMMV9GUE1SIHwNCj4gPiAtCQnCoMKgwqAgSURfQUE2NFBGUjJf
RUwxX01URUZBUiB8DQo+ID4gLQkJwqDCoMKgIElEX0FBNjRQRlIyX0VMMV9NVEVTVE9SRU9OTFkp
LA0KPiA+ICsJSURfRklMVEVSRUQoSURfQUE2NFBGUjJfRUwxLCBpZF9hYTY0cGZyMl9lbDEsDQo+
ID4gKwkJwqDCoMKgIH4oSURfQUE2NFBGUjJfRUwxX0ZQTVIgfA0KPiA+ICsJCcKgwqDCoMKgwqAg
SURfQUE2NFBGUjJfRUwxX01URUZBUiB8DQo+ID4gKwkJwqDCoMKgwqDCoCBJRF9BQTY0UEZSMl9F
TDFfTVRFU1RPUkVPTkxZIHwNCj4gPiArCQnCoMKgwqDCoMKgIElEX0FBNjRQRlIyX0VMMV9HQ0lF
KSksDQo+ID4gwqAJSURfVU5BTExPQ0FURUQoNCwzKSwNCj4gPiDCoAlJRF9XUklUQUJMRShJRF9B
QTY0WkZSMF9FTDEsIH5JRF9BQTY0WkZSMF9FTDFfUkVTMCksDQo+ID4gwqAJSURfSElEREVOKElE
X0FBNjRTTUZSMF9FTDEpLA0KPiANCj4gRG9uJ3QgeW91IGFsc28gbmVlZCBzb21ldGhpbmcgaW4g
a3ZtX2ZpbmFsaXplX3N5c19yZWdzKCkgdG8gaGlkZQ0KPiBHSUN2NQ0KPiBhbHRvZ2V0aGVyIGlm
IG5vIGlycWNoaXAgaGFzIGJlZW4gaW5zdGFudGlhdGVkPw0KDQpBaCwgSSB0aGluayB5b3UncmUg
cmlnaHQuIEknbGwgbWFrZSBzdXJlIHdlIGhpZGUgR0lDdjUgdGhlcmUgaWYgd2UNCmRvbid0IGhh
dmUgYW4gaW4ta2VybmVsIGlycWNoaXAhDQoNCj4gIEl0J2QgYmUgd29ydGgNCj4gZXh0ZW5kaW5n
IHRoZSAibm8tdmdpYy12MyIgdGVzdCB0byBhbHNvIGNvdmVyIEdJQ3Y1Lg0KDQpPSywgSSdtIGxv
b2tpbmcgaW50byB0aGF0Lg0KDQpUaGFua3MsDQpTYXNjaGENCg0KPiANCj4gVGhhbmtzLA0KPiAN
Cj4gCU0uDQo+IA0KDQo=

