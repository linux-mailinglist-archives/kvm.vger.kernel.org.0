Return-Path: <kvm+bounces-69723-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KtrZJGi5fGk0OgIAu9opvQ
	(envelope-from <kvm+bounces-69723-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 15:00:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 00D1FBB6BB
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 15:00:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0C6A2300D165
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FAA7317712;
	Fri, 30 Jan 2026 14:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EZEhSKCP";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EZEhSKCP"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011066.outbound.protection.outlook.com [52.101.65.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B32130EF89
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 13:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.66
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769781602; cv=fail; b=XdSjeiwUE7GLV0TbF2OyGloNGGDrerCBYrx8UQlJ3SoZeofCorUrEgBbBSAdV0miykmdi0PQW69FYbmE5MnhV+SK4oBcKAh1aT+s9gDCns6qPoHtDu3BDPyLk427RtpoKEfJsHXxIkaAnDYFsZlUQDBBzadcSodHCEQ8cOPWTQA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769781602; c=relaxed/simple;
	bh=sT4fZfoO7aT6EKFOFhy9McqxBucCy773pRdhBm51NiQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jxdH2a0vGLIA+lpuJtRxY/enjiwtz6/+I8MDZW8CYpCpglvQrlas842StHNd5ZbMbaGvMd7GdibtPbQWmd+C9wEtlOODIfsnripTlhrBgvZ0OQkzLg5kX+tXCESX25fz+BF8ccFIMHyCvOF5q+yLUqVFswvf2UwP1TkU39B6VqY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EZEhSKCP; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EZEhSKCP; arc=fail smtp.client-ip=52.101.65.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JYOTtiG52RwZhu1b4fPIPkOAt0Iu0w/tcFWMQm2OPH79FhPRhMuztt1cmtKV7wUZlZqt16Kf5OwpCYhQ4jDwXQiYnA+I4l7t/cQB9ZxmNjWkzRP1pxQTsBKWBh0ntNsTR1SnAg7OOrHIaDjVERhPnEDElTsPkWKU+r/ZwKReXTxUTg5e1uCRRv3+xmHTloRcRA3p+sYSNFkmRIOrGNrqPrCBYc39AEQAXTckOhEDRZSRAAYUE/7uLlEQro/k7MepYoM5POxCM83Un20/z9LATDAABocRh0hqfhZ+aMlVAtvAO+aDathM/yGFsFUCX2RCKTelDLsTjoFVp5jr2YIqVw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sT4fZfoO7aT6EKFOFhy9McqxBucCy773pRdhBm51NiQ=;
 b=p5WczqxgzzZuIdR9SjPAm/ogwd5rVmgnXwm6no3S3WI0ztxWF/ZG7k9iBKlw9WzMu2oganWNqQpJtYnxth+bh0VW1JuAF0C8TnRgPra2lUWPuKoDzrKXcKX4uDLX26l0+J/0b0O6Pu2R2TYMcUEd4tKFz77NLfSnZ+ooONhAYipqriuO5Tpqd5K5zGWlbF5A1Bp0SPWbHbeP9vvBl5oFArh+l7Tx6HSPB2205eBrujIco4MXVB25yc4FS2V79Z4r/pn8IZq/yCBeQ4R2OajSAi2NHrxEy2xLdM/iTfjcAkWZT99D+SooSIB5M6k0XWeHSIomd88hNkU4MMDiT5eT4w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sT4fZfoO7aT6EKFOFhy9McqxBucCy773pRdhBm51NiQ=;
 b=EZEhSKCPNKrc8a31g3TR7fI6bJs2bNFmEGWYymWf8PIDzg4qSiPqz6Nu6oAnrDQv87ofAMFW2sXvcUMUdaK4eNRe/5aT8XX6lEaPVokZHdsSuKIWVMPgr+aVq0YMSb3KMWN33wGzcRSXA5PQjKP1YyvELoubNS1MJiWZtrDekS4=
Received: from AM6PR0502CA0059.eurprd05.prod.outlook.com
 (2603:10a6:20b:56::36) by AS4PR08MB7653.eurprd08.prod.outlook.com
 (2603:10a6:20b:4cf::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 13:59:50 +0000
Received: from AMS1EPF00000045.eurprd04.prod.outlook.com
 (2603:10a6:20b:56:cafe::63) by AM6PR0502CA0059.outlook.office365.com
 (2603:10a6:20b:56::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.11 via Frontend Transport; Fri,
 30 Jan 2026 13:59:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000045.mail.protection.outlook.com (10.167.16.42) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Fri, 30 Jan 2026 13:59:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HASOEcUSA/lo6/BGgLnvD5HcKbBW2K/qOe64Pa1joGex7df50ubC8B2vvRdMXWicHpQc6B1cSqNWidNUHNfTsiaZLRZYHhb9ZJgaww9PNM1WILq+WxCC/A/VYBh7RlRc306l8JX0rIHEiV2iEKQGmbha1F85z3PGDVvGa6EzvjuNWsqSsLQtkVlIhkr5C6YeC3StpOPYMCoioTi5DiAdRw9nAR/PaPQLiYsXd/RytcpBSRp4EIP+ZyYdZEO5XsGhi4dmG4ihoOAf2oLlY5S+5RF6vUYUTskZBopsyPkq5LwuPoe8d2ih3vLFiA+hZHpl+51Oq4XtQGPTdM+HzSisCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sT4fZfoO7aT6EKFOFhy9McqxBucCy773pRdhBm51NiQ=;
 b=AhoEoMO/UN5TroWPaeFP+3AryLv7z6vpEtzIOsMglVVOogaukdtSP96hZEQfBEHJVTsq1+7j3JGEhLmi0IXea06D8C3wJGKFAaRPUPqzjtcxekBhAo9zw5bHmReyjJP3GjB8m228u44ukSOQ/2OUVMyPfhfkwymNCNKoieN8d+X9zITisMclK18TPGgY1sppTKdtYKDCdKhuY9ELcZt4J54kAwF6fwLhkRY0rA/X9lRBlzzwvVStM1bz2nAi7spPw7Z430tJZ9O/XxxM0OuAFaCUC6fPaoFd+T4dRU+y2mU7/aL83BP+QDCB1lOuHsBxu4cUuvR3yz7FIs06R+eu8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sT4fZfoO7aT6EKFOFhy9McqxBucCy773pRdhBm51NiQ=;
 b=EZEhSKCPNKrc8a31g3TR7fI6bJs2bNFmEGWYymWf8PIDzg4qSiPqz6Nu6oAnrDQv87ofAMFW2sXvcUMUdaK4eNRe/5aT8XX6lEaPVokZHdsSuKIWVMPgr+aVq0YMSb3KMWN33wGzcRSXA5PQjKP1YyvELoubNS1MJiWZtrDekS4=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AM8PR08MB6595.eurprd08.prod.outlook.com (2603:10a6:20b:365::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 13:58:46 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 13:58:46 +0000
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
Subject: Re: [PATCH v4 32/36] irqchip/gic-v5: Check if impl is virt capable
Thread-Topic: [PATCH v4 32/36] irqchip/gic-v5: Check if impl is virt capable
Thread-Index: AQHckID5tQirLkjj/kOXNQEu8G8Q27VqkhyAgAAt/AA=
Date: Fri, 30 Jan 2026 13:58:46 +0000
Message-ID: <5d113d62e327477ba21f99f89692e8e92ed005f8.camel@arm.com>
References: <20260128175919.3828384-1-sascha.bischoff@arm.com>
	 <20260128175919.3828384-33-sascha.bischoff@arm.com>
	 <86343nbbek.wl-maz@kernel.org>
In-Reply-To: <86343nbbek.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|AM8PR08MB6595:EE_|AMS1EPF00000045:EE_|AS4PR08MB7653:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b907d9c-7358-4259-08dc-08de6007d5b1
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?MnFDc2pDRnVvaVFHSnUwSXNGT1hZQmdrMWJocGhiRFFCb09CblFDVWoxVlM0?=
 =?utf-8?B?SnZMVkNMM0lyUURIdjBRMlpScnkwUy9hZlRqOFdWdFFwTndIWmtmRU9jSmJa?=
 =?utf-8?B?bVlDaTJ5WGVqMEtheEhJZk9WMTVITEpmTllBUkRuVjR0MlZTTE82c1V5aEhx?=
 =?utf-8?B?dzRGMzdmK1Fic3VqYzNlSDVjNlZpWnVLSWNmZFA0MnhqOHh1ZlBWQWNTSGxm?=
 =?utf-8?B?MEpuc3NyWTNaUVRmQ0M1VmpBRHB5enFXUEE2djdRdVNGN1JOSlpzZ2gvcXZv?=
 =?utf-8?B?Zm5OOG1FSzVWdExCTU56Myt6N2FnSG1ZOVhCV3hnZ2ZWWjYrMHNubFRMc2VW?=
 =?utf-8?B?MWl3NGJjdldxM1RtV3d4UWlqVy9GdFk0VVM0cWhvZGhLL0VqejN2RWRISE9R?=
 =?utf-8?B?NVVJTXVHQVE2TzVrRWw4NnFlcmd3VWVpY29udkR4OFRLZDcwYmowT2NlZXgy?=
 =?utf-8?B?MFN2MWlrY0tHeXNxS3VEUlp4UEVaU1M2TC91UXRQRG9kSHY1N29UeG5CMzBY?=
 =?utf-8?B?Z000ZHFNUVgvSjBmR3pxNm1pa0tJM0gvaFc5SVBBR1VtUzVEWllXcE8zN2E5?=
 =?utf-8?B?UFJ6RURwRGQ2c1lQM0d4T0NhRzNnMkNyYlREUE1TbCtTSlRYUjU4Y0xLWU9H?=
 =?utf-8?B?dnloQU9KK1U1d1lNRTZXdUI5VDJvRzhPd1pxRE5MOHZSeXZrVHliaktBRlN5?=
 =?utf-8?B?Vk9CM0k4Y3NKeTA5bFFVZlFiMk14Q1BlMWpGWGkxbmhQQzlPaHVBRFdUcHNK?=
 =?utf-8?B?MUp4dWE3andtc2J0RFQ1ak1SWmlxbS9CUkQ0RWNwa3JaNlNHVFF6cHhDZFFM?=
 =?utf-8?B?UkVmekVxdXRReWRTditIU3ZjTE5EaU54UkZqNk9wb3dVMmljYVFPcUtsaFJ4?=
 =?utf-8?B?aDU3RXVHZndMNDd1bU9wdkZRbmRXL3kyZmFsUFR3NzVXY3BDVWdrL05rTjZk?=
 =?utf-8?B?ZUdxdmF4d2I4bjR4T2RJVWxoTUQ4citLUWMrK2w0QmduQmdOa3hjKzdtUEpm?=
 =?utf-8?B?Vm0xZ1RvUS96OUM2c0ViY0lDQWs3V3g2M2J4azc0MHJ5T2hYSXZQRWN4cjRM?=
 =?utf-8?B?MVViRDUrSWUyTFdXdndJelF3ZElieGFtTEN5R2xTcDJOeHZQbU5vSmpTWmV0?=
 =?utf-8?B?YnVKQ29ZZjdWNUlnQmNiTWkrNFplVEdYS2daczM3Wnh4c01Hdm43b21nYWND?=
 =?utf-8?B?NDV3V24xeFFsSTBoaXcxeWZYWTNobjRiaWhFREh5S2RIMWFYUk5KTlVWc1cx?=
 =?utf-8?B?bEIxUFR5R0ZYWHZIVnRvY3A0VTVINmEvektIdVlLcWlMaStIMXI0akpaNWJw?=
 =?utf-8?B?M3dkL0FiWlZiQ1c0UE5MbXR5NDhZZjE0bnV3bWUrcmVhSGduYjI2eWlVK0ZP?=
 =?utf-8?B?V1c1cUxaWm5GMFo4ZUgvRmxvRHo1eUpVR25OTHNLYVIrTDh0TDhYakUyRGho?=
 =?utf-8?B?SzBhNHVnUHllUWY4NjhnTkkybkgrS2EvOUtvKy9wVzRKSDIxRW9OZzJQb01s?=
 =?utf-8?B?YkgxUW1saThxeEIxU25taGZ4RGVUUUwxVm1Oa2pyaVZZQVAyU3VVampsMXNs?=
 =?utf-8?B?aVkxNTc3czR1T1VEYVZOZ0twWCtMQ3dCTy9lVXNsT0N0RUFNOUJaVmkwYm1Q?=
 =?utf-8?B?dGhWay9OekszRFhSTXlXT3RINU80NEg0cmwyaEFZcnQ1cklJSTY0QlZxY2wy?=
 =?utf-8?B?YzhFK3pCSS9rWFFUeUcwY2Q1MCtNbFUrd2FnUnI4WmN5YlhzRTVELzdCQVJL?=
 =?utf-8?B?M25ZWTk3TG5vNkFSSFFtekw4MXpMZy95U1ZESFZNQ2RYQzJYRDRWbnc4c0Za?=
 =?utf-8?B?NTN6dTQ4WS9CQU83ODFDN2xmd1BpWThRWWJCQTEwTWxYZDd0RXNzbDVaK3Mx?=
 =?utf-8?B?QVdXSUMzRS9HdnhlSWRLNzF0MWZkRlhxTW5BakhDaXJPVzE1eUt5dVRrbWU1?=
 =?utf-8?B?N0xWaktUeUlmNnVUTjRaVUxRaXZqQ2pMTmtDR251SC9wMzA5TURLY3V4UmVF?=
 =?utf-8?B?Y3B4QmZuY1MzM2Zlc2paekNSZGJBZUF6ZkYxZ2xQV2hCS1VlVkh1Z1pkRnZq?=
 =?utf-8?B?Uk96RE1JZ3B2YzU4bU5BcEpJMThJUzY5STVnVEVVaUJsOHcvT3pWRG5FaUxq?=
 =?utf-8?B?YkM0MWV3WDFPVm1qUHUrdCtBcitJbFRXT0JvYmZKeFpSeU5SbVZWYko1R2tl?=
 =?utf-8?Q?3q+OFJRh4EmfNgLY1kikJp4=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <0F19367BF4FCE247A70279BA161C1CF7@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6595
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000045.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	788dc23a-82fc-4dba-8b20-08de6007aff1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|82310400026|36860700013|14060799003|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RnRNSkVRaS9IVVMvckxQUkUvRHRFN0lOWERIK2tMVDlZYnFjaDZzWHpraGJt?=
 =?utf-8?B?YmdPNDI1ZklBZzA5aU12enhYUDhmbnRhZFhmWVkwdXZyN01nb002b1hCNGpw?=
 =?utf-8?B?UHlzQllMTURMaVpyNklEMWYzTm5EUHAwRU5jMDRzTVRJV1c0bVpJNFVONmlj?=
 =?utf-8?B?M2xGTVlPUmJlcnJQUUpVM09JM3BucUs2NHRyR2JERTlEOElkd2RudHZpTk4x?=
 =?utf-8?B?RzFjUXdCN2ZBUXUrblVhNCs5ZjhkUSt1cFQreUtHa3FYVGRXZks5dnRCejFn?=
 =?utf-8?B?b3ZvUFZBNFBBT1FiWitXd2lzVFlCMUpwUEExVDN1emg4Q29sc29OaXNLY1Zu?=
 =?utf-8?B?S0FsY2VtRzJCeWRMZEgxMy9uKzhyN0NCaXNWZmdzWXVPeS9ySndIc1Q2bHBZ?=
 =?utf-8?B?TmR1TEhPZmFydy9lRE9VVEpXemE3bXJjZjlibVJSd05La1ptNE81NHE4Vzg0?=
 =?utf-8?B?Q3hJamZlVDRPdXQrZzZVL0FxVEhVUWZnaUtaMGVhY0M0NytnS0FTTFJYRnpx?=
 =?utf-8?B?KzRNZmRhQ1ZxMmYrcjQ3bVU1cmpqOEZxbUlxUzRYbmhEZEhnek5ZWDA4aS9X?=
 =?utf-8?B?VFVXaU1rM1doZGR4N0gwaXI5cTZkZkxyaTNuWVlRTFl3dWhSeUJORTdmZEpx?=
 =?utf-8?B?OG5QdWlnelJ0WXBGbmdFK01KdkFMbSsvYjdldGZ6ZmYzWUtKc0tBMGpRalBT?=
 =?utf-8?B?STM5bjl5SzN2N0ZoSDgrbzUxdmxaMWNQRHhQc25PaWg5SVhDSXJvaEtzNnlo?=
 =?utf-8?B?eFJoZjJVUlRpbVJkZFpzM3hGZ2NkQ09jZzE0ejFwY1VCWnN6OWw2eEJqU0Zz?=
 =?utf-8?B?bmdhM2hhT0FIenNPWm5iZVVEOTRycytLVzA2S1NuMmx6NUFtNVBacGFKbnRZ?=
 =?utf-8?B?SzFBekJzYTVMNGc1bHdzVFhxOU9xdVZqd3R1WEF3TGlSVnpCcGlTeldBcS93?=
 =?utf-8?B?cnRkM1RMUFg1NjJkNGw0dDVtaDFSbU1tNGMyTFc3eWtvZ2VlYWw4TGVLblVG?=
 =?utf-8?B?b01ZVzYxbVlyM01vSFBaZWZEc0FiQlI1UWxkdTRBYnB5TzREdlBCdDc0V0xN?=
 =?utf-8?B?SjBEVXpKL0tsY1BxRURYalJhWG9PT0lFcVY5K3dQNFRNUlp4SHpSZjJnUWg4?=
 =?utf-8?B?U0JxdGZITVV3ck8wQTFZVzl1QytndTlsVWRKMTdDWURidkluZWJNSzk4dHl5?=
 =?utf-8?B?NWNQeGszUGVqOWhkVVUzL3FZbGNLRWFKZEVLVnRnWEUvQlFZYW5uQUMzRGdZ?=
 =?utf-8?B?S212WStTcnZKM1hNQjhHTE5hNkU5SHJPSkhkMXRPWWwzVkdYc3RZVXY4bUZQ?=
 =?utf-8?B?YVMxRTZhaUoyeFVlNzNhRDNaaXlSRXdJWnFOR2NXTW5YS3FqYU5jZE56Y1cx?=
 =?utf-8?B?cWdvWjFHaTY3L0FIZjJ6SEdsYWFsK1BIa1pyaXFtVVFaSkxmZFBic3JVWlJw?=
 =?utf-8?B?YVZ3UmF2U0xSekkyb254Ty9hbWV3bk5RL05POEExRUxNTXJQanU3VytFN2FS?=
 =?utf-8?B?SS9OdytjNi9VbkZZRnk1R05OZVp0di91M3MzT3FYNUtRNmRpL2lsVkFYRWZL?=
 =?utf-8?B?ME1xVzV3ZGNVNjhUZ1BvM2UycFhBRnVRemdiaXJVM2hZNWNXNWU0cTNmWXlQ?=
 =?utf-8?B?Q2N3NHlUa0luODNUaytraTVBanVXTHJOUGdiekRrZC92bUsyVkd3ejE5Tmxl?=
 =?utf-8?B?K0x6NnUwK3VKQm9HaWFUSHkxM2tvWFRlT0lpUkFFa1JjcVBGcytNQ2NYQTV0?=
 =?utf-8?B?MUhrYjFoTTR3V0dzSzU1ak9xZzd1N3EzS0lLdEN4dTB3a0xYdGFTNG9rclhE?=
 =?utf-8?B?NTNzZzdpcFpLTWtla3AwL21sZ0JPa2pqZlJwaGUyZzkvRlBCZkJMbnBBU2U2?=
 =?utf-8?B?UGI1eDN0Qk9URDd0ZkVZdTlOcHdZNXg4cWkvUUkvZVNlMXBCa2RSVTIzVlNy?=
 =?utf-8?B?UEVDTUo4SEtuejdybUNJdnpadnNkeEpOd3hSMDhsQmpOL3JFNExtdnc1SE1o?=
 =?utf-8?B?M01lSWdQVkk2cDQ1SjRwQmcvK2F4YTFIQ2M2ZnBPbjZ6Zi9CZ1FyaHM1Q1pC?=
 =?utf-8?B?b1huYS90blpQR2ljM08zRWFrSW55eFdKMmpST1pWTzZtcXV5VjVrMElSWHJP?=
 =?utf-8?B?RE9rZEhxN2QzZEhhVmlZOFBsTURJanIzaFVDSWV5V042c0xKOWRoWE5MRFNr?=
 =?utf-8?B?SloxUVNYU0ZXb3JxNGV6OEpGay9aYmljZng0MWJPYTBsbE9pS2xVRTRoNDVE?=
 =?utf-8?B?Rks4aWhEbmJlbGs1bHRpaDJxK0t3PT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(82310400026)(36860700013)(14060799003)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xiHb38jIQhthSf8RS/9/aHuvQXHvOnd3+wGZbYZBW2iow/qDdfW1oYOE4wFgEtIsXdA+Uvizdpzl4dXg+YHUa7RZNteQ+ANJef1KQ5+LwrHAIu1hZdNfuV82IFUvnWbYbcPdKzH6VHNbozE7np5PfM9kBfiuOQ2Jf/cmRsk5koCuuTuwZcvDL/9Cbfnm4GYlx2rZwy2eQ/Cez1gtdm0WZozW2an+kEo1/7MOYuWvlHKMfveiOAUrbhQtRaCTJhBJyn8MmCLWvZCKgMHccTB6AUxBR+7AMjOKWDUNOYxXIa9GFUAYG1KARyU5DgW89w/cXX/U/vEulwdRVSQ6KeMPgmjX9SemNIB+9S07PYJJA59Hm2qbPMeHhJdANBDIgbY9uDEpkYDOvRXE6bqXK74x0qMiIMS5pYfntek4cZJ1bC//jPi+uGc4tDc3x7JFoc8S
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 13:59:49.8419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b907d9c-7358-4259-08dc-08de6007d5b1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000045.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7653
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69723-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,arm.com:dkim,arm.com:mid,huawei.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[arm.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
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
X-Rspamd-Queue-Id: 00D1FBB6BB
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAxLTMwIGF0IDExOjE0ICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIFdlZCwgMjggSmFuIDIwMjYgMTg6MDc6MzMgKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE5vdyB0aGF0IHRoZXJl
IGlzIHN1cHBvcnQgZm9yIGNyZWF0aW5nIGEgR0lDdjUtYmFzZWQgZ3Vlc3Qgd2l0aA0KPiA+IEtW
TSwNCj4gPiBjaGVjayB0aGF0IHRoZSBoYXJkd2FyZSBpdHNlbGYgc3VwcG9ydHMgdmlydHVhbGlz
YXRpb24sIHNraXBwaW5nDQo+ID4gdGhlDQo+ID4gc2V0dGluZyBvZiBzdHJ1Y3QgZ2ljX2t2bV9p
bmZvIGlmIG5vdC4NCj4gPiANCj4gPiBOb3RlOiBJZiBuYXRpdmUgR0lDdjUgdmlydCBpcyBub3Qg
c3VwcG9ydGVkLCB0aGVuIG5vciBpcw0KPiA+IEZFQVRfR0NJRV9MRUdBQ1ksIHNvIHdlIGFyZSBh
YmxlIHRvIHNraXAgYWx0b2dldGhlci4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBTYXNjaGEg
QmlzY2hvZmYgPHNhc2NoYS5iaXNjaG9mZkBhcm0uY29tPg0KPiA+IFJldmlld2VkLWJ5OiBMb3Jl
bnpvIFBpZXJhbGlzaSA8bHBpZXJhbGlzaUBrZXJuZWwub3JnPg0KPiA+IFJldmlld2VkLWJ5OiBK
b25hdGhhbiBDYW1lcm9uIDxqb25hdGhhbi5jYW1lcm9uQGh1YXdlaS5jb20+DQo+ID4gLS0tDQo+
ID4gwqBkcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12NS1pcnMuY8KgwqAgfMKgIDQgKysrKw0KPiA+
IMKgZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjUuY8KgwqDCoMKgwqDCoCB8IDEwICsrKysrKysr
KysNCj4gPiDCoGluY2x1ZGUvbGludXgvaXJxY2hpcC9hcm0tZ2ljLXY1LmggfMKgIDQgKysrKw0K
PiA+IMKgMyBmaWxlcyBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspDQo+ID4gDQo+ID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXY1LWlycy5jDQo+ID4gYi9kcml2ZXJzL2ly
cWNoaXAvaXJxLWdpYy12NS1pcnMuYw0KPiA+IGluZGV4IGNlMjczMmQ2NDlhMy4uZWViZjlmMjE5
YWM4IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXY1LWlycy5jDQo+
ID4gKysrIGIvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjUtaXJzLmMNCj4gPiBAQCAtNzQ0LDYg
Kzc0NCwxMCBAQCBzdGF0aWMgaW50IF9faW5pdCBnaWN2NV9pcnNfaW5pdChzdHJ1Y3QNCj4gPiBk
ZXZpY2Vfbm9kZSAqbm9kZSkNCj4gPiDCoAkgKi8NCj4gPiDCoAlpZiAobGlzdF9lbXB0eSgmaXJz
X25vZGVzKSkgew0KPiA+IMKgDQo+ID4gKwkJaWRyID0gaXJzX3JlYWRsX3JlbGF4ZWQoaXJzX2Rh
dGEsIEdJQ1Y1X0lSU19JRFIwKTsNCj4gPiArCQlnaWN2NV9nbG9iYWxfZGF0YS52aXJ0X2NhcGFi
bGUgPQ0KPiA+ICsJCQkhIUZJRUxEX0dFVChHSUNWNV9JUlNfSURSMF9WSVJULCBpZHIpOw0KPiA+
ICsNCj4gDQo+IEknbGwgdGlkeS11cCB0aGlzIHdoaWxlIGNoZXJyeS1waWNraW5nIGl0IChzcHVy
aW91cyBuZXdsaW5lIGJlZm9yZQ0KPiB0aGUNCj4gaHVuaywgaG9ycmlibGUgc3BsaXQgYXNzaWdu
bWVudC4uLikuDQoNCkFwb2xvZ2llcyEgVGhhbmtzIGZvciBkb2luZyB0aGF0IQ0KDQpTYXNjaGEN
Cg0KPiANCj4gVGhhbmtzLA0KPiANCj4gCU0uDQo+IA0KDQo=

