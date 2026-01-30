Return-Path: <kvm+bounces-69690-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cNDkAkh6fGmWNAIAu9opvQ
	(envelope-from <kvm+bounces-69690-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 10:30:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CE9DB8F06
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 10:30:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 064A53017FB4
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 09:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6B52353EF1;
	Fri, 30 Jan 2026 09:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HZtcHI3U";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HZtcHI3U"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013036.outbound.protection.outlook.com [40.107.162.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8C6346A10
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 09:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769765441; cv=fail; b=ri2VXNwdjs/PAJcrc+1PK2um7ugZ4gkUk9u6tZ2V4ss1LdN7oihQzGG3j5nG6Ojy/f4ybGiv0et5GxDPA5XwVyABvyvd6Re1OnHB/aStoDjxnoVFPBWXRh2gfzUHIawOWJrD+H/kFB+DF1RAIxADnxjkEdODoN9WAAotz69Tvtc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769765441; c=relaxed/simple;
	bh=jawjRAqvU/kGzZl3/fC2xLyZOkeuk53poT4lzE+1CEg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rmnoWvC6zPd09FSA+VImSpxBiy7S9yn1WSyhF7ExOaml51FefESSxMOcq1mAeVXpySl6WmgxMemdUhOCS60QCvp4eEdL4Q+cvV3ik6R3i6RLW/GPatOQIcFUc4EhZdlETbcGzxZ9l0XHvdyn8R2g2ztknL7yyfs2uugGhW3KcB4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HZtcHI3U; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HZtcHI3U; arc=fail smtp.client-ip=40.107.162.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=tEMj7ofYeY5Mf3Bgpb/wifaXyKVUuWcnrhD3sbq6/cmNip9ikTSkv7Luh3YcjWvBmsxu5ZHZtUJM/XzjbXEzUMQniJGqtBlHe9WCnWi/r80z3Fz5RwrmPYZP+vM1EzWwM8UTAxXvFMN0Um96l+8vwZv3Ma02V2GnL13WYpX7KlJXgon7z5+VJb/gtcFQZs187meh1OxrpZ4Sqd4mQQ32gcGQX7YKd1G5NUWJpQrj7hSvEpfOwEqcyZw4aawxhcIrpLx9f9/B64By4HT0/3Qk1ouG2uSFzaW6bfmQnyxo6++polrTouIxMn1xzeIT7+gmUHZpR/YP6uWZLP1DyHEyjQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jawjRAqvU/kGzZl3/fC2xLyZOkeuk53poT4lzE+1CEg=;
 b=kPw0bGowMkX3cdWOlCbY6SV9Rldh0/eMm+qp5snJbG28ZdZhOo/OmAwW8B04uxLtQHA76D+E1K0pLV2v9YFw38Rmog3Wj5vWffxxi5lNfyER9vfzX87AnyqwkZ563q+MaF0TglgRJ/xrBl3Ls7DaAP+M9USJy/OFmP2QL3lRvHFG5kCYtyVN5FFRdxIM71SZRJOR9f67nc1P/aKDY8M/3K16PXJvJGmyI/urPM7WV3WqTYZ419PSyDd1YINEWL2QRJifWDGgPYrv93N64FBCQDMLA7sMpCZBv10uwvMV6ot3WmwS7S3jHIXnx8d0oeWYshZ76GRbYK8rls0c6BfdlA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jawjRAqvU/kGzZl3/fC2xLyZOkeuk53poT4lzE+1CEg=;
 b=HZtcHI3U5Pbiy9cgElFZVZukPVq2SReq8y/uy5bqzz0aVbjhPyFGbFXjI9AgqwjKXe78h5RZSOzKVxV8Ijps3nWgxPNHC3SsJ6B7/Jb4rpZCA6HcwnGevtfF+Xm4kXwl82UFUE6L+d0uycYSDPX7uanyu1BpJ15C2D0nitCv5Dw=
Received: from AS4P195CA0045.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:65a::18)
 by AS2PR08MB8973.eurprd08.prod.outlook.com (2603:10a6:20b:5f9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 09:30:25 +0000
Received: from AMS0EPF000001A0.eurprd05.prod.outlook.com
 (2603:10a6:20b:65a:cafe::4a) by AS4P195CA0045.outlook.office365.com
 (2603:10a6:20b:65a::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.11 via Frontend Transport; Fri,
 30 Jan 2026 09:30:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A0.mail.protection.outlook.com (10.167.16.230) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Fri, 30 Jan 2026 09:30:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pe6xA77Djeoy2Q3l9Nw78gfMzmAKGe7HRfv25QOXYCUnYonASwVPrku8RikWOyn1uBd62hEyKlxZYU/kl/zjSyJLPJeJoT39av8HMigT7aOjpGjj2wq6CW7B5TsOdI+RkJafg7zwu76xXhfVYSwDeRv58mpYNGH+GVjrO2dcn6tj4Yhhl+AiOY47MCOEYJKl21T65a0c1GWMzucy38Y2E9ur101VMSr5NPaRmx9OwsmMA0bP4E7HwePNxDTWvEyz6i1JOUWX6nN+YVDWndijo7rs3C8ikLKsdJ/IzqO8vd9UbbvVaFqaNzGaF+RsIVNMXfqYtlqxGOfLJM7G2wQ2zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jawjRAqvU/kGzZl3/fC2xLyZOkeuk53poT4lzE+1CEg=;
 b=RA0ChSVF0lJoZel19/TLdUyPpk7velibpOhaRx7T0gltOKSYU78qBcIZqKUCTa/XRZJKlZkYFPLz6WFF4spQRnTHiZmDDmtLDbqx3qKZj5LvdYbsMqoO3J4CF7z85dEkGdHGlgq5/yXBNsDLHRL5UfVM1vSiAeJdd5EhFJiS6gm4eMyzOgj6SLg1l1uVkU5hQTR5zUbjvtHB7dZ220nK/VpKdJY+cHP1uUztv8WsD8oFv/jHF5EAveyzoANAeJJzLMX4xLRF0q1xEDNGYmWNNxOreFxQMgz9w6IFqOvCqj+iq8voCFxzugf2xGC8mxZfjd/GVrpdDMlvf84FoS7qGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jawjRAqvU/kGzZl3/fC2xLyZOkeuk53poT4lzE+1CEg=;
 b=HZtcHI3U5Pbiy9cgElFZVZukPVq2SReq8y/uy5bqzz0aVbjhPyFGbFXjI9AgqwjKXe78h5RZSOzKVxV8Ijps3nWgxPNHC3SsJ6B7/Jb4rpZCA6HcwnGevtfF+Xm4kXwl82UFUE6L+d0uycYSDPX7uanyu1BpJ15C2D0nitCv5Dw=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by GV1PR08MB8692.eurprd08.prod.outlook.com (2603:10a6:150:86::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Fri, 30 Jan
 2026 09:29:19 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 09:29:18 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>, Andre Przywara <Andre.Przywara@arm.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, Alexandru Elisei <Alexandru.Elisei@arm.com>,
	"will@kernel.org" <will@kernel.org>, nd <nd@arm.com>,
	"julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool v5 3/7] arm64: nested: Add support for setting
 maintenance IRQ
Thread-Topic: [PATCH kvmtool v5 3/7] arm64: nested: Add support for setting
 maintenance IRQ
Thread-Index: AQHcjHSJbLhfiNY8DEm9o2xt8kI3y7Vkw1sAgAEusYCAABVegIADY2+AgAESDYA=
Date: Fri, 30 Jan 2026 09:29:18 +0000
Message-ID: <38537f6988b599a9f69ba19b80aa5959d4ea64b8.camel@arm.com>
References: <20260123142729.604737-1-andre.przywara@arm.com>
	 <20260123142729.604737-4-andre.przywara@arm.com>
	 <86fr7sb69h.wl-maz@kernel.org>
	 <8db77da0-4772-499d-b140-350e4470e30d@arm.com>
	 <c3b611b88e47c534ac050d02a8b4706111d679da.camel@arm.com>
	 <15de1a60-1dfb-41fd-a747-bd9564572d22@arm.com>
In-Reply-To: <15de1a60-1dfb-41fd-a747-bd9564572d22@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|GV1PR08MB8692:EE_|AMS0EPF000001A0:EE_|AS2PR08MB8973:EE_
X-MS-Office365-Filtering-Correlation-Id: bbbd2a5d-6e25-4342-1428-08de5fe23280
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?UWtybGtLZzUvc1E1K0hDVGU2ZFFrRG1JV1lLN3VYN1lpdDZaSHZpaGI3b3Jr?=
 =?utf-8?B?dW1welgzRS9oT3g3c0JzUytka2NXTnowWXVZTnpvWWNiaEk1d0xuNCsrdUhI?=
 =?utf-8?B?SXF1YlVVdjZwR3BJYTB1Z1hyZjVyZ0pyWVpEOVJJclc2SmtBbThsV0lPZ3Bu?=
 =?utf-8?B?Zjg5VmVwd2pxSTBzbU41d3JxbStoM0ttSUJHKzVVS1Mwa3NxVWFtTnBVcUJR?=
 =?utf-8?B?eDUxQnErUTBmNUNycW1BcjJ2cHNzbXMvRGxNTWRWNC9YVUIvZnh2cU15dFBD?=
 =?utf-8?B?cVRqUXlQcWRkd1JSTVlKTW55bUFkVUVNZzM2cUVrMTNnUEhOZlhYRlNQWTBE?=
 =?utf-8?B?dDZ0aWRtUUFmUStTcTVlWmxlenJ0Nk80R2ZGeE1BNERXQk9JVWpjRFRHRE5o?=
 =?utf-8?B?TEVmSUZHR3dKaXRrajR2ZWNMeWtjVWxwejNlbnJTZWEwZkUrN3ZSNEdUZEZ1?=
 =?utf-8?B?M3IxSWZaZVFZcmNxcGVBQmVwOFFFNk1ZODYwUFBCcnVrc0JmK0gwYUd6SG1O?=
 =?utf-8?B?NEplUlVuanBkRHVuRXluUmNWNTF4SmdySXJMTllicU5LQ2tqQXlGYVZiTnJv?=
 =?utf-8?B?ZndQak1UYWdIaU05cjd0SEdKenV1eCtINGkwc0dmS2F6NFl2K2pJUE5TOWdL?=
 =?utf-8?B?V29DOHk3TEUzUFkxUlFtS0hDZUw1c0t1UC9RTzRseURNdXNieDRtK0NDUUo0?=
 =?utf-8?B?ZG03eC9SZzZCTnBCVGM3c0c3Qm1JNVhSa3hLcC90WWtRY3NzNlc0NjJWSnhJ?=
 =?utf-8?B?WFRsYUdlcEYvT25xNE93OXh4U3ZMLzdXM3RuaFdiVjBpU3d4dlNpNUNTamxR?=
 =?utf-8?B?allIRmRPV0hwcS9Mb0pNNmZOUm9xcS95TmYrbTVwc3ZNcklRMThLNm9PM3c2?=
 =?utf-8?B?bWxKdFlqcE5SbVdIQ1JveTZLTkFab3NRMGFFTlBZMTVTVUNkU2Q3MysyYTBU?=
 =?utf-8?B?dFNXUnhtaWc5Sm5mYjRVT2ZNbVBOUzViS0haTEtHNDN4MEQ3NXIrWlUxRGRN?=
 =?utf-8?B?VlVPMHRTbTREWkh2dnRzaGZJRm1xZUtwbzVJNVpWQm51aDNtOHlrSis5UGdH?=
 =?utf-8?B?REE4dzBCQitLbjYvVjJudjBSRzUvVC9ra2pYRWMzaTlJNXI5QWxVaUpDc0M0?=
 =?utf-8?B?N1hZelF2YTQvV3Q4eGZrTUhLSFZTYWNOWnJWYm9nZlMzMzNnTzFML1VMOG1R?=
 =?utf-8?B?ekR2NThaR2tFR1pSN0ZJem0waUFWQVkvSXZncW5sa1BDT0tEdnUvT0NBdUR2?=
 =?utf-8?B?THIzaFBuWUxScldNa1BDejJVb0NpRW51VSthdDZXZTFKdGQ3Z2U3V1VGQndE?=
 =?utf-8?B?clUxT1BzSmZCdlRTdm5PdDdFcDdtTkNOTmFnMXlmMHJHblE2YXVBVFZDUGIv?=
 =?utf-8?B?aklVOVE5NnJFT3prZU9mVk42UXpLR29aa0w3ZElkZW9Xa0E1djNjR29BLzYv?=
 =?utf-8?B?L01uM1JzSEtvQWJ2UHBUcU5ZR0VtQUVDOWd5N0RvN0RUeXJqeWZ2aE9ENWQz?=
 =?utf-8?B?QXZ3OGZkKytQOFM1OXZqWngyaU5ZRVlnZU53VTg2M1daejJzUDhqYVVjWFF0?=
 =?utf-8?B?aXJhOTM3ejQvODIwVzJJZFBIWnZJUC9IU2s4R1BlUk54VHhGMzNnT2pQTUlR?=
 =?utf-8?B?U2JKd1YwZGpoTTRkK003c2t3d05XcFlIUStLdW9UNFNPV1pjL2Rxend0czRL?=
 =?utf-8?B?OTVjUVNGNFN3Q2FTTUpodjQrck5TMmlEY0RkUmhnRUZWOGV2MzFpZmdmditM?=
 =?utf-8?B?MjR5WXpIc082RXBleXJ2YlU0VEZSQzBwVWtBY25ySDl1TGlwbnpNZkNQTS91?=
 =?utf-8?B?STFldTU0emRuejg1Q1dzMy9rejFlSVI3Sk4vcXJXNWVFUzZxOGkrbG1manVl?=
 =?utf-8?B?U1hPTTduMUFick5iaFVhV0p1eTZEK2tBdnp1K2puTmpTUFZZaGRCcDZDMDht?=
 =?utf-8?B?OEpCcEcrMVZ3ajBEMjMxTVkxYVRHdXlWSFF2TDVZcXdWUWlGVGdyVzhXVVB4?=
 =?utf-8?B?aFNuWloxOTZJUU45QnBBVmFMYXU0ck1IS0l1bGdDUThQcW5FMGpmRUlKc1Js?=
 =?utf-8?B?Qlh0QStxdVJJak52Zjd5bDJkci9BaklJU08yWk56VS9wTXZMd0Q4WE1tY0t3?=
 =?utf-8?B?VURTNzhoc1ZTYU9JM1hpdTl0OUtDOVNXb1F4bTVJUWpmcnFsSVhxaHo5VkFT?=
 =?utf-8?Q?UGmQoT+cAwbI98D1S5fXn1g=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <3027A2A71D41A84DAB077C211C5CE2E8@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8692
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A0.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8211277c-96d1-4037-b4d4-08de5fe20b26
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|82310400026|1800799024|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dTBzTFpMUXV1Y0VocHZhbDFFaWpsWDF6RWp1UkVjUmh2UFlpa2xGVjJ6MjJn?=
 =?utf-8?B?dDNaSHJpbW9xRjVKSlk4UVp5aTFVM2ZoVUwyVGoyNVJRNURrMnBLTGZydHpn?=
 =?utf-8?B?RmZVQnlKZkFWd3V5YSt6RElNUHZIQjBWQmhnTmxpaUVIL2pHWTBLTWFYUUw4?=
 =?utf-8?B?bitKbjk4SHNLVE1pY2c2VGFuVXMrK2lqNXF4UkhvY0lseFhnV2ZKVER5dVlS?=
 =?utf-8?B?Q1FMcjlzWkZUVUVkbWF6UExKdDFSUnJmMnBwZHhWRFBqSWJhNmRHMlpjUzEw?=
 =?utf-8?B?ZUt0blZKM1psYlFyai9hMlBPY0l5UGQ2TU8wcGVTL3dzdmN2dWtLVkk4R21V?=
 =?utf-8?B?YTBYNU1EN21hVytHVzVHUzh3VXlxWUJqNkl2bHlEdnh3R1kyRVhwaUVSc0RR?=
 =?utf-8?B?dUxOYXFNTmU5Y0ozdkVlTDFLQjM4eTBiaUViSGF2dHl3UmNUSkNwOHZ1R1d2?=
 =?utf-8?B?ZHFzWk5BVGhyeFV4RUhpdjc3L0xpc1MvdHErMGNidEI2ZExlTEFSRmZIU081?=
 =?utf-8?B?TjQ0TlMxcm1yZ254MlZ1aEdwanNMM05NZGdIWUVZcFZuVmtldGZhMEVIRmI2?=
 =?utf-8?B?d3ZtSzhsc3JhMDVpa1gwQjN2bWtzbC9mcVp6bjJtZ2ZIZENYYmp1YWY5Mzlr?=
 =?utf-8?B?bkpGY3RiMlpQdS85aG44WGQrblU3YVRRZVI0RGdaZVFrU3VJa1dhczh6dHpL?=
 =?utf-8?B?dHprRWFxZmlFSUNwTFFYaytocEh3Lzhwak4vWUdoWjdwSWNSaDB0ZFVnbDB2?=
 =?utf-8?B?ZS9OUGxvMm12eGVhWmUxK2wwM3B2RGhydktvOGtoMmFuZG1ZT1lwcWdVMjdj?=
 =?utf-8?B?VXA3bk9QR2lFUURpR1grWFNub25pK3lVZmlDbHJ3SXUzaS9LL3BINWwwYU1W?=
 =?utf-8?B?TjJEY1FXODBYcTl3VXJHMzdrbjF4UXFybnhEK1dRZkovbGg4Q00yN2Qvbmxl?=
 =?utf-8?B?bDBOb3dvbkQ1Qkp4ZjRvTVFXMUgwSCt4L2xCdm43T3BNZEZReFBySlJCRzRh?=
 =?utf-8?B?VCtaUmNZZmNrQ3FtYkZ2ZjlBQitFWFJaakJhSURSSE1kNytEMDd3ZVNHUm01?=
 =?utf-8?B?Y1U2eVZETUFkeUowNFlNWjdGWjIrT2U4U1JlMVptOHFFTy84dU1meXFRTE5L?=
 =?utf-8?B?QzhMN1paNFpPUk0wY3hGWmdGM0NrQUZJbFptY2NUbXJWS05mMjhjRkcyWXJO?=
 =?utf-8?B?MkJWeFdZYW44V3lUM2Vqd3B0REw1Vlp1eDRzV2syaXJtZGtYNFdTSnB4TGZ6?=
 =?utf-8?B?QytuNFFSTU1KUXhBWTU1ZkVjRldKdmRGNlMyRXpEMGlFVmJCVm5Sc1hhek1V?=
 =?utf-8?B?NDdSQXBBL2sxR2ZaYXdIdXREcSt3N1M2ZWZQR0x4Q2tyK28rSDV1NjlZMnk3?=
 =?utf-8?B?Ri9WdGgzWkIzWjFmS3J2SC9QaVZCSk9WZGl3MTZRUGl0N2dlVW1NVUh2ZkFi?=
 =?utf-8?B?ajVVbzlveVplQllsRWxoMnl4ZW92N0toNXJGNWFWK2dwdFVvYkNkdjZ5dTJh?=
 =?utf-8?B?eXIzMm9kVmczRURuWjU5ek13SkxRSnJxUXZ1bW9TSUtlZ01jTmNTZEN5c0k1?=
 =?utf-8?B?aEpMRHF3Y2pjbXQ5L2VBdTN2YlZWVHNVOTBBOEZDbXNwMFh2czlxakNwSHFE?=
 =?utf-8?B?akxIOTh4MkUzN2ZPWFk3dVUrK3prTTVkVkdmUTJhdkZmWS93bzJOTkNWcWZz?=
 =?utf-8?B?eTloVEVjMlpXaitEZXA0S2JWeXFqUTJsMWd5MEVmekFWUkhTUk9RMGFGb3pN?=
 =?utf-8?B?SC9qWXJuYmZ3WEk5ZHF3NUxTYnBEUGtVV0Z4UmdiWHYwQUJ5NUljei9iY0k0?=
 =?utf-8?B?SGhFRERyREtscEw2Tzl5Uzh2djdiTUVMRkcreDJGV1FVMUFMQUgwS0c5WGdE?=
 =?utf-8?B?WnlWZ3NaWUdLNm1lS2dYaXFjbHgvNjFHNmI3NzFqVVp6ckdaQnBoUjNRb0Qz?=
 =?utf-8?B?dXdoQURxb2VMazdqNWdaVzRQa3YwQVZXU3oxWXpNV1RveTFwSDB0TkxaZm4y?=
 =?utf-8?B?UjRZSTBRckUyTkgwNXpFdW1LV0ppMElMSm9wMHgrSGhORGdNck92cXVuSjBy?=
 =?utf-8?B?Ykk1a0xyM3pkM0FlbTNPSDgwYm1CaUR6dHFYVTMvUk9ncnBmTjAvOGhRU1hD?=
 =?utf-8?B?WG9iaU81YWt6RGtuUmhoSllzdTg0Z0Rwem15b0p5OWNnaG5tR2ZzZGNXT3ZC?=
 =?utf-8?B?NU1ydjVSTEhNakc1Y0o0aFpaMFNIT0ROdGR4QlFiNktad0c5R3p2VzRVTVQr?=
 =?utf-8?B?Q2lTMlROM0dWeElRejd0WkNSaDVBPT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(82310400026)(1800799024)(35042699022)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mYvHRS9s0epUQVglPJ2WB4HjMtmbkIujWYKw+UEZKT999r79i+CPCDwfNf5hxIiT5ztRHRfM9hK1HfdfvUHR604dG2mPF8DCOuaF5CUE+YTGhlTNVgdDURDnGf0xbMg6uPPT3/wjPTnTF5UV3ZLsmn/4kEXOyPvYgO0un8G6uLg6wyOk9aeZCgNkO9ibd9Gyt4vDcLIutS5HZYgQqb2tK5VcJRZ6s+zjkgBbK/8IjedfSm2YyX04Iap2oiyJtle/xwdTF40E4RTxt39r8sYQkAL8fTLdg5dl8PrOL5ZxN2QcvFOgjeoP2rjqXorT6Q2LUA/dUNIoNOf4XHr3qOZql4Z7Pm1N6DGUWQJuEr90BCKl3bt7I91XVDZ9KZ7N+bcqi8L4qRowiPcflqX9S08VQfAoHN3L4VF6keqjsWCJoDz1bObdfwYBqcKkR7UdRt99
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 09:30:24.6559
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bbbd2a5d-6e25-4342-1428-08de5fe23280
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A0.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8973
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.44 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.linux.dev,arm.com,kernel.org,gmail.com];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69690-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,arm.com:dkim,arm.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 5CE9DB8F06
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAxLTI5IGF0IDE4OjA4ICswMTAwLCBBbmRyZSBQcnp5d2FyYSB3cm90ZToN
Cj4gSGkgU2FzY2hhLA0KPiANCj4gT24gMS8yNy8yNiAxNDoyMywgU2FzY2hhIEJpc2Nob2ZmIHdy
b3RlOg0KPiA+IE9uIFR1ZSwgMjAyNi0wMS0yNyBhdCAxMjowNyArMDAwMCwgQW5kcmUgUHJ6eXdh
cmEgd3JvdGU6DQo+ID4gPiBIaSBNYXJjLA0KPiA+ID4gDQo+ID4gPiBPbiAyNi8wMS8yMDI2IDE4
OjAzLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+ID4gPiA+IE9uIEZyaSwgMjMgSmFuIDIwMjYgMTQ6
Mjc6MjUgKzAwMDAsDQo+ID4gPiA+IEFuZHJlIFByenl3YXJhIDxhbmRyZS5wcnp5d2FyYUBhcm0u
Y29tPiB3cm90ZToNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBVc2VzIHRoZSBuZXcgVkdJQyBLVk0g
ZGV2aWNlIGF0dHJpYnV0ZSB0byBzZXQgdGhlIG1haW50ZW5hbmNlDQo+ID4gPiA+ID4gSVJRLg0K
PiA+ID4gPiA+IFRoaXMgaXMgZml4ZWQgdG8gdXNlIFBQSSA5LCBhcyBhIHBsYXRmb3JtIGRlY2lz
aW9uIG1hZGUgYnkNCj4gPiA+ID4gPiBrdm10b29sLA0KPiA+ID4gPiA+IG1hdGNoaW5nIHRoZSBT
QlNBIHJlY29tbWVuZGF0aW9uLg0KPiA+ID4gPiA+IFVzZSB0aGUgb3Bwb3J0dW5pdHkgdG8gcGFz
cyB0aGUga3ZtIHBvaW50ZXIgdG8NCj4gPiA+ID4gPiBnaWNfX2dlbmVyYXRlX2ZkdF9ub2Rlcygp
LA0KPiA+ID4gPiA+IGFzIHRoaXMgc2ltcGxpZmllcyB0aGUgY2FsbCBhbmQgYWxsb3dzIHVzIGFj
Y2VzcyB0byB0aGUNCj4gPiA+ID4gPiBuZXN0ZWRfdmlydA0KPiA+ID4gPiA+IGNvbmZpZyB2YXJp
YWJsZSBvbiB0aGUgd2F5Lg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IEFu
ZHJlIFByenl3YXJhIDxhbmRyZS5wcnp5d2FyYUBhcm0uY29tPg0KPiA+ID4gPiA+IC0tLQ0KPiA+
ID4gPiA+IMKgwqAgYXJtNjQvYXJtLWNwdS5jwqDCoMKgwqDCoMKgwqDCoCB8wqAgMiArLQ0KPiA+
ID4gPiA+IMKgwqAgYXJtNjQvZ2ljLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCAyOSArKysr
KysrKysrKysrKysrKysrKysrKysrKystLQ0KPiA+ID4gPiA+IMKgwqAgYXJtNjQvaW5jbHVkZS9r
dm0vZ2ljLmggfMKgIDIgKy0NCj4gPiA+ID4gPiDCoMKgIDMgZmlsZXMgY2hhbmdlZCwgMjkgaW5z
ZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBkaWZmIC0t
Z2l0IGEvYXJtNjQvYXJtLWNwdS5jIGIvYXJtNjQvYXJtLWNwdS5jDQo+ID4gPiA+ID4gaW5kZXgg
NjliYjJjYjIuLjA4NDNhYzA1IDEwMDY0NA0KPiA+ID4gPiA+IC0tLSBhL2FybTY0L2FybS1jcHUu
Yw0KPiA+ID4gPiA+ICsrKyBiL2FybTY0L2FybS1jcHUuYw0KPiA+ID4gPiA+IEBAIC0xNCw3ICsx
NCw3IEBAIHN0YXRpYyB2b2lkIGdlbmVyYXRlX2ZkdF9ub2Rlcyh2b2lkICpmZHQsDQo+ID4gPiA+
ID4gc3RydWN0IGt2bSAqa3ZtKQ0KPiA+ID4gPiA+IMKgwqAgew0KPiA+ID4gPiA+IMKgwqDCoAlp
bnQgdGltZXJfaW50ZXJydXB0c1s0XSA9IHsxMywgMTQsIDExLCAxMH07DQo+ID4gPiA+ID4gwqDC
oCANCj4gPiA+ID4gPiAtCWdpY19fZ2VuZXJhdGVfZmR0X25vZGVzKGZkdCwga3ZtLT5jZmcuYXJj
aC5pcnFjaGlwKTsNCj4gPiA+ID4gPiArCWdpY19fZ2VuZXJhdGVfZmR0X25vZGVzKGZkdCwga3Zt
KTsNCj4gPiA+ID4gPiDCoMKgwqAJdGltZXJfX2dlbmVyYXRlX2ZkdF9ub2RlcyhmZHQsIGt2bSwN
Cj4gPiA+ID4gPiB0aW1lcl9pbnRlcnJ1cHRzKTsNCj4gPiA+ID4gPiDCoMKgwqAJcG11X19nZW5l
cmF0ZV9mZHRfbm9kZXMoZmR0LCBrdm0pOw0KPiA+ID4gPiA+IMKgwqAgfQ0KPiA+ID4gPiA+IGRp
ZmYgLS1naXQgYS9hcm02NC9naWMuYyBiL2FybTY0L2dpYy5jDQo+ID4gPiA+ID4gaW5kZXggYjBk
M2ExYWIuLjJhNTk1MTg0IDEwMDY0NA0KPiA+ID4gPiA+IC0tLSBhL2FybTY0L2dpYy5jDQo+ID4g
PiA+ID4gKysrIGIvYXJtNjQvZ2ljLmMNCj4gPiA+ID4gPiBAQCAtMTEsNiArMTEsOCBAQA0KPiA+
ID4gPiA+IMKgwqAgDQo+ID4gPiA+ID4gwqDCoCAjZGVmaW5lIElSUUNISVBfR0lDIDANCj4gPiA+
ID4gPiDCoMKgIA0KPiA+ID4gPiA+ICsjZGVmaW5lIEdJQ19NQUlOVF9JUlEJOQ0KPiA+ID4gPiA+
ICsNCj4gPiA+ID4gPiDCoMKgIHN0YXRpYyBpbnQgZ2ljX2ZkID0gLTE7DQo+ID4gPiA+ID4gwqDC
oCBzdGF0aWMgdTY0IGdpY19yZWRpc3RzX2Jhc2U7DQo+ID4gPiA+ID4gwqDCoCBzdGF0aWMgdTY0
IGdpY19yZWRpc3RzX3NpemU7DQo+ID4gPiA+ID4gQEAgLTMwMiwxMCArMzA0LDE1IEBAIHN0YXRp
YyBpbnQgZ2ljX19pbml0X2dpYyhzdHJ1Y3Qga3ZtDQo+ID4gPiA+ID4gKmt2bSkNCj4gPiA+ID4g
PiDCoMKgIA0KPiA+ID4gPiA+IMKgwqDCoAlpbnQgbGluZXMgPSBpcnFfX2dldF9ucl9hbGxvY2F0
ZWRfbGluZXMoKTsNCj4gPiA+ID4gPiDCoMKgwqAJdTMyIG5yX2lycXMgPSBBTElHTihsaW5lcywg
MzIpICsgR0lDX1NQSV9JUlFfQkFTRTsNCj4gPiA+ID4gPiArCXUzMiBtYWludF9pcnEgPSBHSUNf
UFBJX0lSUV9CQVNFICsgR0lDX01BSU5UX0lSUTsNCj4gPiA+ID4gPiDCoMKgwqAJc3RydWN0IGt2
bV9kZXZpY2VfYXR0ciBucl9pcnFzX2F0dHIgPSB7DQo+ID4gPiA+ID4gwqDCoMKgCQkuZ3JvdXAJ
PSBLVk1fREVWX0FSTV9WR0lDX0dSUF9OUl9JUlFTLA0KPiA+ID4gPiA+IMKgwqDCoAkJLmFkZHIJ
PSAodTY0KSh1bnNpZ25lZCBsb25nKSZucl9pcnFzLA0KPiA+ID4gPiA+IMKgwqDCoAl9Ow0KPiA+
ID4gPiA+ICsJc3RydWN0IGt2bV9kZXZpY2VfYXR0ciBtYWludF9pcnFfYXR0ciA9IHsNCj4gPiA+
ID4gPiArCQkuZ3JvdXAJPSBLVk1fREVWX0FSTV9WR0lDX0dSUF9NQUlOVF9JUlEsDQo+ID4gPiA+
ID4gKwkJLmFkZHIJPSAodTY0KSh1bnNpZ25lZCBsb25nKSZtYWludF9pcnEsDQo+ID4gPiA+ID4g
Kwl9Ow0KPiA+ID4gPiA+IMKgwqDCoAlzdHJ1Y3Qga3ZtX2RldmljZV9hdHRyIHZnaWNfaW5pdF9h
dHRyID0gew0KPiA+ID4gPiA+IMKgwqDCoAkJLmdyb3VwCT0gS1ZNX0RFVl9BUk1fVkdJQ19HUlBf
Q1RSTCwNCj4gPiA+ID4gPiDCoMKgwqAJCS5hdHRyCT0gS1ZNX0RFVl9BUk1fVkdJQ19DVFJMX0lO
SVQsDQo+ID4gPiA+ID4gQEAgLTMyNSw2ICszMzIsMTYgQEAgc3RhdGljIGludCBnaWNfX2luaXRf
Z2ljKHN0cnVjdCBrdm0NCj4gPiA+ID4gPiAqa3ZtKQ0KPiA+ID4gPiA+IMKgwqDCoAkJCXJldHVy
biByZXQ7DQo+ID4gPiA+ID4gwqDCoMKgCX0NCj4gPiA+ID4gPiDCoMKgIA0KPiA+ID4gPiA+ICsJ
aWYgKGt2bS0+Y2ZnLmFyY2gubmVzdGVkX3ZpcnQpIHsNCj4gPiA+ID4gPiArCQlyZXQgPSBpb2N0
bChnaWNfZmQsIEtWTV9IQVNfREVWSUNFX0FUVFIsDQo+ID4gPiA+ID4gJm1haW50X2lycV9hdHRy
KTsNCj4gPiA+ID4gPiArCQlpZiAoIXJldCkNCj4gPiA+ID4gPiArCQkJcmV0ID0gaW9jdGwoZ2lj
X2ZkLA0KPiA+ID4gPiA+IEtWTV9TRVRfREVWSUNFX0FUVFIsDQo+ID4gPiA+ID4gJm1haW50X2ly
cV9hdHRyKTsNCj4gPiA+ID4gPiArCQlpZiAocmV0KSB7DQo+ID4gPiA+ID4gKwkJCXByX2Vycigi
Y291bGQgbm90IHNldCBtYWludGVuYW5jZQ0KPiA+ID4gPiA+IElSUVxuIik7DQo+ID4gPiA+ID4g
KwkJCXJldHVybiByZXQ7DQo+ID4gPiA+ID4gKwkJfQ0KPiA+ID4gPiA+ICsJfQ0KPiA+ID4gPiA+
ICsNCj4gPiA+ID4gPiDCoMKgwqAJaXJxX19yb3V0aW5nX2luaXQoa3ZtKTsNCj4gPiA+ID4gPiDC
oMKgIA0KPiA+ID4gPiA+IMKgwqDCoAlpZiAoIWlvY3RsKGdpY19mZCwgS1ZNX0hBU19ERVZJQ0Vf
QVRUUiwNCj4gPiA+ID4gPiAmdmdpY19pbml0X2F0dHIpKSB7DQo+ID4gPiA+ID4gQEAgLTM0Miw3
ICszNTksNyBAQCBzdGF0aWMgaW50IGdpY19faW5pdF9naWMoc3RydWN0IGt2bSAqa3ZtKQ0KPiA+
ID4gPiA+IMKgwqAgfQ0KPiA+ID4gPiA+IMKgwqAgbGF0ZV9pbml0KGdpY19faW5pdF9naWMpDQo+
ID4gPiA+ID4gwqDCoCANCj4gPiA+ID4gPiAtdm9pZCBnaWNfX2dlbmVyYXRlX2ZkdF9ub2Rlcyh2
b2lkICpmZHQsIGVudW0gaXJxY2hpcF90eXBlDQo+ID4gPiA+ID4gdHlwZSkNCj4gPiA+ID4gPiAr
dm9pZCBnaWNfX2dlbmVyYXRlX2ZkdF9ub2Rlcyh2b2lkICpmZHQsIHN0cnVjdCBrdm0gKmt2bSkN
Cj4gPiA+ID4gPiDCoMKgIHsNCj4gPiA+ID4gPiDCoMKgwqAJY29uc3QgY2hhciAqY29tcGF0aWJs
ZSwgKm1zaV9jb21wYXRpYmxlID0gTlVMTDsNCj4gPiA+ID4gPiDCoMKgwqAJdTY0IG1zaV9wcm9w
WzJdOw0KPiA+ID4gPiA+IEBAIC0zNTAsOCArMzY3LDEyIEBAIHZvaWQgZ2ljX19nZW5lcmF0ZV9m
ZHRfbm9kZXModm9pZCAqZmR0LA0KPiA+ID4gPiA+IGVudW0NCj4gPiA+ID4gPiBpcnFjaGlwX3R5
cGUgdHlwZSkNCj4gPiA+ID4gPiDCoMKgwqAJCWNwdV90b19mZHQ2NChBUk1fR0lDX0RJU1RfQkFT
RSksDQo+ID4gPiA+ID4gY3B1X3RvX2ZkdDY0KEFSTV9HSUNfRElTVF9TSVpFKSwNCj4gPiA+ID4g
PiDCoMKgwqAJCTAsIDAsCQkJCS8qIHRvIGJlDQo+ID4gPiA+ID4gZmlsbGVkDQo+ID4gPiA+ID4g
Ki8NCj4gPiA+ID4gPiDCoMKgwqAJfTsNCj4gPiA+ID4gPiArCXUzMiBtYWludF9pcnFbXSA9IHsN
Cj4gPiA+ID4gPiArCQljcHVfdG9fZmR0MzIoR0lDX0ZEVF9JUlFfVFlQRV9QUEkpLA0KPiA+ID4g
PiA+IGNwdV90b19mZHQzMihHSUNfTUFJTlRfSVJRKSwNCj4gPiA+ID4gPiArCQlnaWNfX2dldF9m
ZHRfaXJxX2NwdW1hc2soa3ZtKSB8DQo+ID4gPiA+ID4gSVJRX1RZUEVfTEVWRUxfSElHSA0KPiA+
ID4gPiA+ICsJfTsNCj4gPiA+ID4gDQo+ID4gPiA+IFRoaXMgbG9va3MgdXR0ZXJseSBicm9rZW4s
IGFuZCBteSBndWVzdHMgYmFyZiBvbiB0aGlzOg0KPiA+ID4gPiANCj4gPiA+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgIGludGMgew0KPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGNvbXBhdGlibGUgPSAiYXJtLGdpYy12MyI7DQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgI2ludGVycnVwdC1jZWxscyA9IDwweDAzPjsNCj4gPiA+ID4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpbnRlcnJ1cHQtY29udHJvbGxlcjsNCj4g
PiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZWcgPSA8MHgwMCAweDNm
ZmYwMDAwIDB4MDAgMHgxMDAwMCAweDAwDQo+ID4gPiA+IDB4M2ZlZjAwMDAgMHgwMCAweDEwMDAw
MD47DQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW50ZXJydXB0
cyA9IDwweDAxIDB4MDkgMHg0MDAwMDAwPjsNCj4gPiA+IA0KPiA+ID4gQWggeWVhaCwgc29ycnks
IHRoYXQncyBvZiBjb3Vyc2UgY29tcGxldGUgYmx1bmRlciwgdGhpcyBnb3QgbG9zdA0KPiA+ID4g
aW4NCj4gPiA+IHRyYW5zbGF0aW9uIGJldHdlZW4gdjMgYW5kIHY0Lg0KPiA+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgXl5eXl5eXl5eXl4NCj4gPiA+ID4gQXJlIHlvdSB0ZXN0aW5n
IG9uIGEgYmlnLWVuZGlhbiBib3g/Pz8gSSBmaXhlZCBpdCB3aXRoIHRoZQ0KPiA+ID4gPiBwYXRj
aGxldA0KPiA+ID4gPiBiZWxvdywgYnV0IEkgYWxzbyB3b25kZXIgd2h5IHlvdSBhZGRlZA0KPiA+
ID4gPiBnaWNfX2dldF9mZHRfaXJxX2NwdW1hc2soKS4uLg0KPiA+ID4gDQo+ID4gPiB0aGlzIHdh
cyB0byBhY2NvbW1vZGF0ZSBHSUN2MiAoaXQgcmV0dXJucyAwIGZvciBHSUN2MyksIGFuZCB3YXMN
Cj4gPiA+IHRoZQ0KPiA+ID4gZXF1aXZhbGVudCBvZiB0aGUgaGFyZGNvZGVkIDB4ZmYwNCB3ZSBo
YWQgYmVmb3JlLiBBbmQgdGhvdWdoIEkNCj4gPiA+IGd1ZXNzDQo+ID4gPiB0aGVyZSB3b3VsZCBi
ZSBubyBvdmVybGFwIGJldHdlZW4gbWFjaGluZXMgc3VwcG9ydGluZyBuZXN0ZWQgdmlydA0KPiA+
ID4gYW5kDQo+ID4gPiBoYXZpbmcgYSBHSUN2MiBvciBhIEdJQ3YyIGVtdWxhdGlvbiBjYXBhYmxl
IEdJQ3YzLCBJIGFkZGVkIHRoaXMNCj4gPiA+IGZvcg0KPiA+ID4gdGhlDQo+ID4gPiBzYWtlIG9m
IGNvbXBsZXRlbmVzcyBhbnl3YXksIGFzIGl0IGRpZG4ndCBmZWVsIHJpZ2h0IHRvIG1ha2UgdGhp
cw0KPiA+ID4gYXNzdW1wdGlvbiBpbiB0aGUgb3RoZXJ3aXNlIGdlbmVyaWMgY29kZS4NCj4gPiA+
IA0KPiA+ID4gQ29uc2lkZXIgdGhpcyBmaXhlZC4NCj4gPiA+IA0KPiA+ID4gQ2hlZXJzLA0KPiA+
ID4gQW5kcmUNCj4gPiANCj4gPiBTZWVtcyBJJ2QgbWlzc2VkIHRoaXMgaW4gdjQuIFNvcnJ5IQ0K
PiA+IA0KPiA+IEhvd2V2ZXIsIHRoaXMgbWFkZSBtZSB0aGluayBhYm91dCBHSUN2NSBndWVzdHMu
DQoNCkhpIEFuZHJlIQ0KDQpBcG9sb2dpZXMgZm9yIGNvbmZ1c2luZyB0aGluZ3MuIEl0IHNlZW1z
IHRoYXQgbXkgbXVzY2xlIG1lbW9yeSBraWNrZWQNCmluIHdoZW4gSSByZXBsaWVkLCBhbmQgSSB0
eXBlZCBHSUN2NSB3aGVyZSBJJ2QgbWVhbnQgR0lDdjIhIEFyZ2ghDQoNCj4gPiBSaWdodCBub3cg
b25lIGNhbiB0cnkNCj4gPiBhbmQgY3JlYXRlIGEgbmVzdGVkIGd1ZXN0IHdpdGggR0lDdjIuIEF0
dGVtcHRpbmcgdG8gZG8gc28gZmFpbHMgYQ0KPiA+IGxpdHRsZSB1bmdyYWNlZnVsbHk6DQo+ID4g
DQo+ID4gwqDCoCBFcnJvcjogY291bGQgbm90IHNldCBtYWludGVuYW5jZSBJUlENCj4gPiANCj4g
PiDCoMKgIFdhcm5pbmc6IEZhaWxlZCBpbml0OiBnaWNfX2luaXRfZ2ljDQo+ID4gDQo+ID4gwqDC
oCBGYXRhbDogSW5pdGlhbGlzYXRpb24gZmFpbGVkDQo+ID4gDQo+ID4gSXQgbWlnaHQgYmUgd29y
dGggY2F0Y2hpbmcgdGhlIHYyICsgbmVzdGVkIGNvbWJvIGV4cGxpY2l0bHkgYW5kDQo+ID4gcmV0
dXJuaW5nIGEgc2xpZ2h0bHkgbW9yZSB1c2VmdWwgZXJyb3IuDQo+IA0KPiBNbW1oLCB3b3VsZCB0
aGF0IGJlIHJlYWxseSB1c2VmdWw/IFlvdSBjcmVhdGVkIHRoYXQgc2l0dWF0aW9uIG9uIHRoZSAN
Cj4gbW9kZWwsIHJpZ2h0PyBJIGRvbid0IHRoaW5rIGl0J3MgYSBjb21tb24gc2NlbmFyaW8gdG8g
cnVuIGEgZ3Vlc3QgaW4NCj4gRUwyIA0KPiB3aGlsZSBoYXZpbmcgYSBHSUN2MiBpbnRlcnJ1cHQg
Y29udHJvbGxlci4NCg0KSSBkaWQgY3JlYXRlIHRoaXMgb24gdGhlIG1vZGVsLCBidXQgaXQgd2Fz
IGEgR0lDdjMgRlZQLiBTbywgdGhpcyB3YXMgYC0NCi1pcnFjaGlwPWdpY3YyIC0tbmVzdGVkYCBv
biBhIEdJQ3YzIGhvc3QuDQoNCkkgdGhpbmsgdGhhdCB3ZSBhcmUgc29tZXdoYXQgaW4gYWdyZWVt
ZW50IHRoYXQgcnVubmluZyBhbiBFTDIgZ3Vlc3Qgb24NCkdJQ3YyIGlzbid0IGEgY29tbW9uIG9y
IGV4cGVjdGVkIHVzZS1jYXNlLiBNeSBtYWluIHRoaW5raW5nIGlzIHRoYXQgaXQNCmRvZXNuJ3Qg
cmVhbGx5IG1ha2Ugc2Vuc2UgYWxsb3cgdGhlIGNvbWJpbmF0aW9uIG9mIGFueXRoaW5nIGJ1dCAt
LQ0KaXJxY2hpcD1naWN2MygtaXRzKSBhbmQgLS1uZXN0ZWQgKGFuZCBldmVudHVhbGx5IEdJQ3Y1
IG9uY2UgdGhlcmUgaXMNCm5lc3RlZCBzdXBwb3J0IGluIEtWTSkuDQoNCj4gQW5kIHdoaWxlIHdl
IGNhbm5vdCANCj4gY29tcGxldGVseSBydWxlIHRoaXMgb3V0IChhcyB5b3UgaGF2ZSBzaG93biks
IEkgZG9uJ3QgdGhpbmsgaXQncw0KPiBjb21tb24gDQo+IGVub3VnaCB0byB3YXJyYW50IGFuIGV4
cGxpY2l0IGNoZWNrIG9yIG1lc3NhZ2UuIEF0IGxlYXN0IGl0IGZhaWxlZCANCj4gKGJlY2F1c2Ug
dGhlIHZHSUN2MiBkZXZpY2UgZG9lc24ndCBpbXBsZW1lbnQgDQo+IEtWTV9ERVZfQVJNX1ZHSUNf
R1JQX01BSU5UX0lSUSksIGFuZCBiYXJmZWQgYWJvdXQgdGhlIEdJQywgd2hpY2gNCj4gc2hvdWxk
IA0KPiBnaXZlIHBlb3BsZSB0aGF0IHRpbmtlciB3aXRoIHRoZSBHSUMgZW5vdWdoIGNsdWVzLCBy
aWdodD8NCg0KWWVhaCwgaXQgc2hvdWxkIGdpdmUgZW5vdWdoIGNsdWVzLiBJIHdhcyBqdXN0IG9i
c2VydmluZyB0aGF0IHRoZSBlcnJvcg0KY291bGQgaGF2ZSBiZWVuIG1vcmUgZXhwbGljaXQuIEkg
d2FzIGp1c3QgdGhpbmtpbmcgb2Ygc29tZXRoaW5nIGFsb25nDQp0aGUgZm9sbG93aW5nIGxpbmVz
IHdoZW4gdmFsaWRhdGluZyB0aGUgY29uZmlnIChhbmQgYWN0dWFsbHkgbm90IGFzDQpwYXJ0IG9m
IHRoaXMgY2hhbmdlKS4gRmVlbCBmcmVlIHRvIGRpc3JlZ2FyZCBpZiB5b3UgdGhpbmsgaXQgaXMN
Cm92ZXJraWxsLg0KDQpUaGFua3MsDQpTYXNjaGENCg0KZGlmZiAtLWdpdCBhL2FybTY0L2t2bS5j
IGIvYXJtNjQva3ZtLmMNCmluZGV4IGVkMGYxMjY0Li5hNTBiY2MyMyAxMDA2NDQNCi0tLSBhL2Fy
bTY0L2t2bS5jDQorKysgYi9hcm02NC9rdm0uYw0KQEAgLTQ0MCw4ICs0NDAsMTQgQEAgdm9pZCBr
dm1fX2FyY2hfdmFsaWRhdGVfY2ZnKHN0cnVjdCBrdm0gKmt2bSkNCiAgICAgICAgICAgIGt2bS0+
Y2ZnLnJhbV9hZGRyICsga3ZtLT5jZmcucmFtX3NpemUgPiBTWl80RykgeyAgICAgICAgICANCiAg
ICAgICAgICAgICAgICBkaWUoIlJBTSBleHRlbmRzIGFib3ZlIDRHQiIpOyAgICAgICAgICAgICAg
ICAgICAgICAgICANCiAgICAgICAgfQ0KKw0KICAgICAgICBpZiAoa3ZtLT5jZmcuYXJjaC5lMmgw
ICYmICFrdm0tPmNmZy5hcmNoLm5lc3RlZF92aXJ0KSAgICAgICAgIA0KICAgICAgICAgICAgICAg
IHByX3dhcm5pbmcoIi0tZTJoMCByZXF1aXJlcyAtLW5lc3RlZCwgaWdub3JpbmciKTsNCisgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICANCisgICAgICAgaWYgKGt2bS0+Y2ZnLmFyY2gubmVzdGVkX3ZpcnQgJiYNCisgICAg
ICAgICAgIGt2bS0+Y2ZnLmFyY2guaXJxY2hpcCAhPSBJUlFDSElQX0dJQ1YzICYmICAgICAgICAg
ICAgICAgICANCisgICAgICAgICAgIGt2bS0+Y2ZnLmFyY2guaXJxY2hpcCAhPSBJUlFDSElQX0dJ
Q1YzLUlUUykNCisgICAgICAgICAgICAgICBkaWUoIi0tbmVzdGVkIHJlcXVpcmVzIGEgR0lDdjMt
YmFzZWQgZ3Vlc3QiKTsgICAgICAgICANCiB9DQogDQogdTY0IGt2bV9fYXJjaF9kZWZhdWx0X3Jh
bV9hZGRyZXNzKHZvaWQpDQoNCj4gDQo+IFBsZWFzZSBsZXQgbWUga25vdyB3aGF0IHlvdSB0aGlu
ayENCj4gDQo+IENoZWVycywNCj4gQW5kcmUNCj4gDQo+ID4gDQo+ID4gVGhhbmtzLA0KPiA+IFNh
c2NoYQ0KPiA+IA0KPiA+ID4gDQo+ID4gPiA+IA0KPiA+ID4gPiAJTS4NCj4gPiA+ID4gDQo+ID4g
PiA+IGRpZmYgLS1naXQgYS9hcm02NC9naWMuYyBiL2FybTY0L2dpYy5jDQo+ID4gPiA+IGluZGV4
IDJhNTk1MTguLjY0MGZmMzUgMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL2FybTY0L2dpYy5jDQo+ID4g
PiA+ICsrKyBiL2FybTY0L2dpYy5jDQo+ID4gPiA+IEBAIC0zNjksNyArMzY5LDcgQEAgdm9pZCBn
aWNfX2dlbmVyYXRlX2ZkdF9ub2Rlcyh2b2lkICpmZHQsDQo+ID4gPiA+IHN0cnVjdA0KPiA+ID4g
PiBrdm0gKmt2bSkNCj4gPiA+ID4gwqDCoMKgCX07DQo+ID4gPiA+IMKgwqDCoAl1MzIgbWFpbnRf
aXJxW10gPSB7DQo+ID4gPiA+IMKgwqDCoAkJY3B1X3RvX2ZkdDMyKEdJQ19GRFRfSVJRX1RZUEVf
UFBJKSwNCj4gPiA+ID4gY3B1X3RvX2ZkdDMyKEdJQ19NQUlOVF9JUlEpLA0KPiA+ID4gPiAtCQln
aWNfX2dldF9mZHRfaXJxX2NwdW1hc2soa3ZtKSB8DQo+ID4gPiA+IElSUV9UWVBFX0xFVkVMX0hJ
R0gNCj4gPiA+ID4gKwkJY3B1X3RvX2ZkdDMyKGdpY19fZ2V0X2ZkdF9pcnFfY3B1bWFzayhrdm0p
IHwNCj4gPiA+ID4gSVJRX1RZUEVfTEVWRUxfSElHSCksDQo+ID4gPiA+IMKgwqDCoAl9Ow0KPiA+
ID4gPiDCoMKgIA0KPiA+ID4gPiDCoMKgwqAJc3dpdGNoIChrdm0tPmNmZy5hcmNoLmlycWNoaXAp
IHsNCj4gPiA+ID4gDQo+ID4gPiANCj4gPiANCj4gDQoNCg==

