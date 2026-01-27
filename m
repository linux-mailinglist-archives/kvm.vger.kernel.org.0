Return-Path: <kvm+bounces-69236-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QLelA4WQeGmarAEAu9opvQ
	(envelope-from <kvm+bounces-69236-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 11:16:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E03CD9299E
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 11:16:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1C7E33006B42
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 10:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3537E2FBDFA;
	Tue, 27 Jan 2026 10:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NyTwkoCP";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NyTwkoCP"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011070.outbound.protection.outlook.com [52.101.65.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6332F5A35
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 10:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.70
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769508985; cv=fail; b=HBX6WcdvcDvoaJug2IG6q53RuZ8G5zMFn0DSpZOmJPEpaAWiJgG3vHntTuvZvsRNsjYXr/I9aRUzhVVDhQfEifU5z+IM1yK07fDcIJdCIP/tkmxmiRgyapM1BzTJ6FRcE0X3taWmsxo0ZnjgLEJBxk2aHJ/mGz0MbYS1Pol9eS0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769508985; c=relaxed/simple;
	bh=MD+f5zkBryFpTKoICh3dWMSSySh7EOHwE+nzoJY/PN8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ye0+hCuTutJ3NoVG6F1coodMto8MCxlg6KwuiESkfI8p4hUG54uXnjz2d9GQ5kA/TAE1FRFTnnnJQHIFUOzGPfw5CnCX4i7+aNMavB82ejzubuTH8NNv9WcgPdmkRPh+UHlzF3H1aJBaADBIRUOJcx/GcnBH92C2wnF+Y/2wggM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NyTwkoCP; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NyTwkoCP; arc=fail smtp.client-ip=52.101.65.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ZubqukbfMihJ3MPmiOP8IwpC/LdZZTbKCkxgYB0brd00YTYqduK/0lXB9nMdIuPq7Zbrd+/UE8iogkW79A96Fh9CUBELmZ/i2Kep/g0U8YgSPZ3m85xH/oAHcbvTb4xYmuvvt3LU++93PyI+uPmnjZcfRrraqzgsk5FfAq2Rc4Hg4uMaFY1Ty7/XwyMkR3W4H6kNBqT4uC6P7f41xKR7MAjsFcOfKhiJGfvqAfUKdAFKE8NubZh9jTAkR4KoQfBQf5tVxStu3KOj9lmSxu+qdRIdv7CzMqNXDfcA2a78Kbsrl4ytItd0pqv6p2kEDJJ4sGb94ZGTfQJnEaUa+MjZNQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MD+f5zkBryFpTKoICh3dWMSSySh7EOHwE+nzoJY/PN8=;
 b=id6SVX0c777tPHWz/sVQUtbhBst1SCvcqckBXc2AxVbEK4aWwgf903lUSRrpP65+vb5nbqtFTtN2qM04yKwxYfY1qzYshSRTLh70QJc6VV4C2FIhMIxElIngb0KOPG3dAyQWIxe28R/bP9kxh0zgg8iQ2ZLHhlRwhkAAolnDNlJxbMxXIBMWhQT3iHWLmafroXiRKxnDouf9rIIcgW+wPQe5kplg90Cm1EMBhgbrvnNYft1nh0EEoSy2FEB8sRmgI6+aSp0XG8/c+SdNbIEqYLw3ESxed6UnlQC5PFtmdY2iS34EFvx25O6POiyEhTf/52RHTHxC1u/EspEYGHlbmg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MD+f5zkBryFpTKoICh3dWMSSySh7EOHwE+nzoJY/PN8=;
 b=NyTwkoCPJiyx5joP4DjCuzqqtK+exYkRElSZ9jq5xVVEZp/oO/L1vxsZbGWkc9XYmYj7FFkYLmJqCO6UyZLkNXrEPNn5ge5LSqm1lZ/DszcJLAMNCqoXnhgO89ZdYNJ3lPMfvIFRTMB+f5pNY+4lqZFJL5R+4lE7cCrtbRyvtb4=
Received: from AS4P192CA0015.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:5da::10)
 by AS2PR08MB9344.eurprd08.prod.outlook.com (2603:10a6:20b:597::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 10:16:17 +0000
Received: from AM3PEPF00009B9F.eurprd04.prod.outlook.com
 (2603:10a6:20b:5da:cafe::9f) by AS4P192CA0015.outlook.office365.com
 (2603:10a6:20b:5da::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Tue,
 27 Jan 2026 10:16:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009B9F.mail.protection.outlook.com (10.167.16.24) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Tue, 27 Jan 2026 10:16:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LPBV+FEB6wrNJC9wkjSalbFN86wXlhuQgm5jzSqDIP6xlE1IcJW9IPMYZ6Xz2zEDFWTb0d3KEnH1A52+2RgV5PAUagswkIO6a5m9gb4RSTkm745EYyfTgTcnWOVpjc75TMPnBU/szqH7c5W26SUn5Jct2Uqxv+TlAOjKYGRFrQQ5WqRRh9FYnWZ+rQ+KSq3E9PITDO5q75mU+5TYC9ZQYZ1PlPqZFbSdoHOnNU7VNoelO53EmlqG/4sRGGS/XITsEVIFEY40u3jaA+KsK9w+pfnJnJIGCBCEEKXHSLqDOPT7aMrfoKy3l1slYN4JsrNKSXJ2/Tg/KP9qG4BVIi9vOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MD+f5zkBryFpTKoICh3dWMSSySh7EOHwE+nzoJY/PN8=;
 b=KeKytPMaKquNBPxN5yCwcYgAf8Q5Ndf0BMCb8wiXT+RrsZJiIfbMXCpUWA5ZLXlD8Rp0v5TglI7qvjYJecc6X+FI+JOfWZ8z4b/tLFqK6+X9slsPgdhWHKdHwVUY8lrZhVAny0rWw+9d2R0P0vJe9ly6IQRvuOt6cbdJSyFRjjrvt4tr5dG9/CpoveklWMZjQjo+PAGqoHsZaOXShaCPCVZfR30FaH5erB8/OvZgBJa0ZW615Q1JWY22RvBgXN3z09mQQkJ/DiKfbpaXEFDLe6gzQZio/SxyO7g4Ght3OhYVjSU+txDYLdPePd+wEsut1pePN93u3ehJ6Q335JSTLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MD+f5zkBryFpTKoICh3dWMSSySh7EOHwE+nzoJY/PN8=;
 b=NyTwkoCPJiyx5joP4DjCuzqqtK+exYkRElSZ9jq5xVVEZp/oO/L1vxsZbGWkc9XYmYj7FFkYLmJqCO6UyZLkNXrEPNn5ge5LSqm1lZ/DszcJLAMNCqoXnhgO89ZdYNJ3lPMfvIFRTMB+f5pNY+4lqZFJL5R+4lE7cCrtbRyvtb4=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DB4PR08MB8030.eurprd08.prod.outlook.com (2603:10a6:10:38a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Tue, 27 Jan
 2026 10:15:13 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 10:15:13 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>, Andre Przywara <Andre.Przywara@arm.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, Alexandru Elisei <Alexandru.Elisei@arm.com>,
	"will@kernel.org" <will@kernel.org>, nd <nd@arm.com>,
	"julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool v5 7/7] arm64: Handle virtio endianness reset when
 running nested
Thread-Topic: [PATCH kvmtool v5 7/7] arm64: Handle virtio endianness reset
 when running nested
Thread-Index: AQHcjHSK5xpfIYmyUU2H4ZO+izUXsbVf6puAgAXoIAA=
Date: Tue, 27 Jan 2026 10:15:13 +0000
Message-ID: <793619e5b16449137c159b782857066082f86d74.camel@arm.com>
References: <20260123142729.604737-1-andre.przywara@arm.com>
	 <20260123142729.604737-8-andre.przywara@arm.com>
	 <86jyx8b9l2.wl-maz@kernel.org>
In-Reply-To: <86jyx8b9l2.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|DB4PR08MB8030:EE_|AM3PEPF00009B9F:EE_|AS2PR08MB9344:EE_
X-MS-Office365-Filtering-Correlation-Id: 467ef9f3-6053-4bad-812b-08de5d8d1bd6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?OHdiRlNZRGZvNGlSZmpnRjlabitYa1lGRmhZWEVkM002Z0xKTjRNaTJnYlZR?=
 =?utf-8?B?UE1hRE9FYklTZi9GMzE5YXQ5dkJhNS92cHFDeGtiUTZaTzFzSHdoMktkenl3?=
 =?utf-8?B?TFBhNUsxRlRHU3NtRHN5Q2RxLzl1ZmJ2amJKcUh5Ui9QQXpWWWR6QkpzVmhQ?=
 =?utf-8?B?Q1V5bGdOL1lhdTRaOUxzOGFBdWh0am1NSEhtTFVlSDM1dTlCWXJKSEVWa013?=
 =?utf-8?B?SGswVENGNS8rK3dGY1dsNnhKRXBPUmdDbDlodzY1M01hT0drUnBPM004WTdR?=
 =?utf-8?B?a1F2MThneVpUWEVxM0YwdnZoNm5IOTJzNEFSVnN4S2RxZ0RNWVlBZEdpRjlV?=
 =?utf-8?B?Z1BkU1VidVdwSURBdlA5MWpRVUtkK2N3RUExaHRxaDFQZGgwVC8vQkI1c096?=
 =?utf-8?B?bzR4RkdoTjQ4NkJKUnNqMnFqbEpHSHlEMkdtaThZR3pMZHZhdDNLY1B3M1BK?=
 =?utf-8?B?bXUvMGFWSnJBWVEwbWV1aWEyck9KSm9aeW5scWhVWmlzSWhwak80bDZ5aUM2?=
 =?utf-8?B?ZjNlc1NCOTl3Q3k3Zzdvb3lzZktvWWNxZ0U5RERUdllWTXpUNWlNcllFSWtV?=
 =?utf-8?B?cjVqZ2NySkU0dStDbDVOcHhCdWNHMG9QNE5JNUZpcC9XUGtiN0h5RFFIeUth?=
 =?utf-8?B?NWpwZHpaVnJuZUpYcURkdFRMUDFHdGF4eXJmVXBUU3QrWVcyeGhBWmZ6aitn?=
 =?utf-8?B?YjNscUluN05UZWREQlEwYU92Wlc2RTFJNkh2bFg4K0RpclRacVQ3UDFVMDIr?=
 =?utf-8?B?NDRlTXp4VVBiTFRBSEV4VUllcTBVSlZucVQ0QTk5NEFybUlXQlF3QXhUb2hC?=
 =?utf-8?B?ZzlmOHEzZHFXZ0szeVdEVUE1WDJMdEhGKzR6ZmQybDFwOGprV3o5ellxdzg5?=
 =?utf-8?B?dk1WVDRXK3JoTVM3UUZXNWJzd1lvZzdxMSs0RFQ5dy9JWnhyN3ZOOFZ2TjFx?=
 =?utf-8?B?QlFjaFVOS1lWNnJVTmd4MXI4b1kwWXN0MmQzdjZpZVJCZjhYdHFxcE9hU0Fp?=
 =?utf-8?B?STVEaElkVjd1TkJUVWw5OVFPS1YrSmhvT1VIODlOdFNjUGVQN29OdTdtMkhh?=
 =?utf-8?B?NnpjdHhHZmdCSmtmb1JNdElmZTZncE1EbVJGeDEwbVJhUGh6ODIrcXdHS1dI?=
 =?utf-8?B?VjZCVEJlcHJzMUdoaWprTkp6Wk5EWHhGcThmMkkyNHVKRkhEaWVjNXFtOWV5?=
 =?utf-8?B?em5ucjJwMEUzY0lvcDdJWjlQeVFxMlBqelUxQXIyTThydzdEcmkrRTdobWto?=
 =?utf-8?B?b0psM29wOGpwNmZleTMySkJGUzdqV1dpTVJXeHZlN25oWVZibVVBRm5sWWVQ?=
 =?utf-8?B?S0tsUXB2VHM0c1FMQVcwVWhUM0dYVXNid1BUbUUzQXBianNqb2VTblFvSmx0?=
 =?utf-8?B?RzR3azQ4WkhmL2pqMjRhampnSHNVb3B5Zlo2czlYOFBubjZHNFI4K1c3M3Qr?=
 =?utf-8?B?c29nOWZ4TzAxRjhZTzh4ZGdkTUpzOE5HdXhNZDFLUmVTSGozeThMZkh4ZG8r?=
 =?utf-8?B?ZUszYWk0eEFGcEM5NEJ2bFJDcnNjZE4wTy9jV1E5bWdiTzJLN1NWOTFFa0dL?=
 =?utf-8?B?VWhVWGVOdWpyejVSek9IZlFHQVd1dzFuM01kYk16aENNd0pKeEtpRFpKakVP?=
 =?utf-8?B?RzZNM3hubmUvVWV5Um9SRVdrK2JnbVBZSXg4MG9iSHhtbWNKQldTUTlkMGd2?=
 =?utf-8?B?amVaRUJYSFkxWXRUcnVDYWppdEZUcFBRdmVQWk5JdVAxT0dxajlvZWtSQVo4?=
 =?utf-8?B?RURoWGJaeXBWYWwzeWFGYnFzWkVjQ2I0b040VERBcndlMGV4NGdrRjZVR05J?=
 =?utf-8?B?TG90bnNEa1BIU1ErSmlpTzVtMHNGTWhxQU9LWVBXYVAwNmRBWXdwOEZCSWho?=
 =?utf-8?B?Ui9LRkwrQzJIL2VmdVk2NmhHQmNCV3JOMVB0THR2ck93UkFLOG9CTHhmS044?=
 =?utf-8?B?MUpNaWRZYWdwTGpWRkpmRy9LKzdNL3pMdHA1OVNsYXJ6dlJCUVpCS1ptZVZz?=
 =?utf-8?B?aVdhTmtueWJEbkV4Zkl4NzUyUHY5VGpTYW9BQ1R5UzRzWU9KSDhYVmI2WUV2?=
 =?utf-8?B?WURxdjNzVWQ3cEYzbHczd0RqSEw3OXBnaENQbmw2V3NWNXI3UStjb2s3eDRh?=
 =?utf-8?B?clkyNGtxb09LS1J3U1VBanZSL25YZ0JCMy95SWgrbld4SW9LZzB2N0xTZE56?=
 =?utf-8?Q?AC7JVatDqwyyWDo6fvY89nk=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <4642372CC6B16144896AF271F4FB5400@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8030
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009B9F.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7111c0e1-c1c2-411a-3a13-08de5d8cf600
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|35042699022|14060799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YktyWFdTRHN4R2wvbnVxYzdkWDN5UHFCbGV4OHc1U1YxbmlRNVVjMHFJL1FK?=
 =?utf-8?B?cVNWNUVmZDlNRVZSVlkxV3JUdk1HakRNWlR3aC91Yzhrb3lacFZFdzFvOWF2?=
 =?utf-8?B?TUJxZGtQUWdMYWMvZUlMaGpqUExlajdQWlZMVElra3lGcW4wKzdrQmlDeGRy?=
 =?utf-8?B?d2Y4MXhySG9HZlp3L0VpZ2xmeDh0QzhBQU1namgreFgveHRFeFcrMTY0bE1u?=
 =?utf-8?B?TVVKUXAyaEd0MS9jbzlhajdoZXBNVUpTSkxhdTZqQ3ZVdzlzdlM5UVRURGJW?=
 =?utf-8?B?b0FVZUxNV2FLWFU3ZUlVclB3N0RudkVUd1NVZmZBVWIyKzZLWjhxTTVjTmZZ?=
 =?utf-8?B?aDFYZUdJRHJWRlBxakdFbWNRZG9uaEZzOGZmSDRtUkRKN1J6WjRCQ2tOTWY4?=
 =?utf-8?B?QTRiRjNUQkFJa1ozdUZBZUtnbFE1RzMwNVcydnBjQUpROTNZS0svYnBTSGJD?=
 =?utf-8?B?U0x0OWp3eUdOckpUT2lURjh3QTF5Nnd1QVpzZGxhWThOdFpINVV1c0s3eWE5?=
 =?utf-8?B?MkE3NzgvVUQ5MER1R3N3RDFhMzRWNm44Ty9kOE9IYTVwY0JEZk81VUVtV21x?=
 =?utf-8?B?SGNMMHYrZ0hVNjlHWVRNejNlQ1QwS2ZicDdrRks3MFVzTzRiZ3kyU2dnZklR?=
 =?utf-8?B?c3k0NnJkZFhCQ3RUUVVHeExvMmxmb1dVd3h3aFZGa0xiVStaQWtuUnc4QmR5?=
 =?utf-8?B?Z3RMUk1VT1lBMHhPVXNYekZ5RklBc3A1M0cvQ2hjVWZwaXY5SnZiSnVUZlVh?=
 =?utf-8?B?cmhqYmNINWhoREZZdHRZTmdQSFZnMlRoUnJZb2FoVTIrd3lEVEVkYURHVTNq?=
 =?utf-8?B?S2lPM1kxeXpFako3RmhjZkFrQytOSkhISWNlMUJaSE9UbnZrNUUrMytvTFhC?=
 =?utf-8?B?aHpaS2Z4M3lKMUVwR01KYTNGNTlLd0RkK2hFY1dvZVBQaUlpTlZUNDRBVGU3?=
 =?utf-8?B?K1Z3Y01YMDVjRjU5UU9pVjE1OEVJQ09RaWVvZ2lTS2ZsaGM5S3F4ME9qSnJX?=
 =?utf-8?B?UUtjemFpbXoxeWQrNWRMYmZQRmFpODhqMHVQdCtOVytUNnVmZVY1UGJEVlZo?=
 =?utf-8?B?ejBUUnBoL1MySk9MeWZPUlBoVndhMUpYNW5UdmZOdmxha2laOEliMHNOSmxa?=
 =?utf-8?B?SGhRd0VQd3diMXNJYXM4Y0JpRTZXM3RVUVV6a0gzNEVKc0ZBMzQrTEkvUlZa?=
 =?utf-8?B?c1I2TEdCNFE3eVlIQytVV3RzZzJiNU81L3pIekY0Rzg2K1pOdWtQbmw5bkgz?=
 =?utf-8?B?ZFNhRmQzdmtOVFZPMmZwS3VEaWpucFZwOWVsd3p0bW5YQTBUMk1mQUlySTFi?=
 =?utf-8?B?YitudzJ0NHc2YnloRnBreGxPeDBCTkFsMnpWUCs5aTBMdTZzd2U4TTdQZmla?=
 =?utf-8?B?OW5pVHdCTmUrR0V6TFFmNitqaXR0emJaOXBLVHUvcjJ1bmRLdXVDeFdTRm0w?=
 =?utf-8?B?bzkxWFFEdk9QeGx1MTFTU3ArS1oyMDM3TVk2UFBzQzJmemdudXh3bXpRbXFh?=
 =?utf-8?B?dzZXRXp2Q0RCVzJFME9BNjVVaUJ4dTFCQ2tWY3VhMERTSEU2TVRNUlRwMm81?=
 =?utf-8?B?VUVSdjBMcUJNQTYyRzZZcUhQd3djRXhEZTAxSnJLdXZGWlZTZDlwamNwVnZy?=
 =?utf-8?B?cTY4bWg5b2QvOWw0VXYyUWw1ZXVWMFpqakYxTTNEWTR4N0lkZ1B6S1VweWJh?=
 =?utf-8?B?SFJ2WCt3SGFOTzAvZHllRVhmdk5seFB2ZlNRb0FrMlZ0Q3VOWDl0eEJudVJ1?=
 =?utf-8?B?aVdHMDY2MWJLNU1oTUI1THI1VGdzQzNxTTlsVnhncWRFdG8venRVblVRTCtq?=
 =?utf-8?B?TzVaL1N1d1JxeE1NMkZibjBJb3drTFNWNTRmNGZIdS9vSzkzdld6U2RKQlA1?=
 =?utf-8?B?Wm5OZHlwWGVFcE5NMS9EQjhtMWtaQVlIdG9yWHVqQ0kxa1RCYktsRjh6Q2lE?=
 =?utf-8?B?ZXZDS21zaDdOY2xPenJsQm9ML0FSbDJEQlQvelY5UkJIaTE2dWhiejBYZTFj?=
 =?utf-8?B?UnQwU3dYT0toYmRoMk9jTmN1MjNOMEdBdzZVOGx0VGM4ejVsSnVVVXpKczlP?=
 =?utf-8?B?SytxVFMvdHpzMkJHeFJsRlJvd1FYT1FHWStsUnVIVUp6WnJUM3VMZVcvWDY0?=
 =?utf-8?B?UjZHcmZ0aUFzYTFneC9tdXd0a3h3OHBEUE1PeTF5UmlZWmdkaW1SQWVxMEJX?=
 =?utf-8?B?aGtaSWxtekdLKzRoSHBQa1dWQW1Cbi9tZnJ1TTB5eDgzSXJsMGpiS2hlNkRY?=
 =?utf-8?B?ZFpYVWlxelJzcnZDVTk5VXRrSk1RPT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(35042699022)(14060799003)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 10:16:17.0829
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 467ef9f3-6053-4bad-812b-08de5d8d1bd6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9F.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9344
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.44 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
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
	TAGGED_FROM(0.00)[bounces-69236-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,arm.com:dkim,arm.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,sctlr_el1.ee:url];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	BLOCKLISTDE_FAIL(0.00)[2603:10a6:20b:5da:cafe::9f:query timed out];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: E03CD9299E
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAxLTIzIGF0IDE2OjAzICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIEZyaSwgMjMgSmFuIDIwMjYgMTQ6Mjc6MjkgKzAwMDAsDQo+IEFuZHJlIFByenl3YXJhIDxh
bmRyZS5wcnp5d2FyYUBhcm0uY29tPiB3cm90ZToNCj4gPiANCj4gPiBGcm9tOiBNYXJjIFp5bmdp
ZXIgPG1hekBrZXJuZWwub3JnPg0KPiA+IA0KPiA+IFdoZW4gcnVubmluZyBhbiBFTDIgZ3Vlc3Qs
IHdlIG5lZWQgdG8gbWFrZSBzdXJlIHdlIGRvbid0IHNhbXBsZQ0KPiA+IFNDVExSX0VMMSB0byB3
b3JrIG91dCB0aGUgdmlydGlvIGVuZGlhbm5lc3MsIGFzIHRoaXMgaXMgbGlrZWx5DQo+ID4gdG8g
YmUgYSBiaXQgcmFuZG9tLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8
bWF6QGtlcm5lbC5vcmc+DQo+ID4gU2lnbmVkLW9mZi1ieTogQW5kcmUgUHJ6eXdhcmEgPGFuZHJl
LnByenl3YXJhQGFybS5jb20+DQo+ID4gLS0tDQo+ID4gwqBhcm02NC9pbmNsdWRlL2t2bS9rdm0t
Y3B1LWFyY2guaCB8wqAgNSArKy0tDQo+ID4gwqBhcm02NC9rdm0tY3B1LmPCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgNDcgKysrKysrKysrKysrKysrKysrKysrKysrKy0tLQ0K
PiA+IC0tLS0NCj4gPiDCoDIgZmlsZXMgY2hhbmdlZCwgNDAgaW5zZXJ0aW9ucygrKSwgMTIgZGVs
ZXRpb25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FybTY0L2luY2x1ZGUva3ZtL2t2bS1j
cHUtYXJjaC5oDQo+ID4gYi9hcm02NC9pbmNsdWRlL2t2bS9rdm0tY3B1LWFyY2guaA0KPiA+IGlu
ZGV4IDFhZjM5NGFhLi44NTY0NmFkNCAxMDA2NDQNCj4gPiAtLS0gYS9hcm02NC9pbmNsdWRlL2t2
bS9rdm0tY3B1LWFyY2guaA0KPiA+ICsrKyBiL2FybTY0L2luY2x1ZGUva3ZtL2t2bS1jcHUtYXJj
aC5oDQo+ID4gQEAgLTEwLDggKzEwLDkgQEANCj4gPiDCoCNkZWZpbmUgQVJNX01QSURSX0hXSURf
QklUTUFTSwkweEZGMDBGRkZGRkZVTA0KPiA+IMKgI2RlZmluZSBBUk1fQ1BVX0lECQkzLCAwLCAw
LCAwDQo+ID4gwqAjZGVmaW5lIEFSTV9DUFVfSURfTVBJRFIJNQ0KPiA+IC0jZGVmaW5lIEFSTV9D
UFVfQ1RSTAkJMywgMCwgMSwgMA0KPiA+IC0jZGVmaW5lIEFSTV9DUFVfQ1RSTF9TQ1RMUl9FTDEJ
MA0KPiA+ICsjZGVmaW5lIFNZU19TQ1RMUl9FTDEJCTMsIDQsIDEsIDAsIDANCj4gPiArI2RlZmlu
ZSBTWVNfU0NUTFJfRUwyCQkzLCA0LCAxLCAwLCAwDQoNClRoZXNlIGNhbid0IGJvdGggYmUgdGhl
IHNhbWUhIExvb2tzIGxpa2UgU0NUTFJfRUwyIGlzIGNvcnJlY3QsIGJ1dA0KU0NUTFJfRUwxIHNo
b3VsZCBiZSAzLCAwLCAxLCAwLCAwLg0KDQo+ID4gKyNkZWZpbmUgU1lTX0hDUl9FTDIJCTMsIDQs
IDEsIDEsIDANCj4gPiDCoA0KPiA+IMKgc3RydWN0IGt2bV9jcHUgew0KPiA+IMKgCXB0aHJlYWRf
dAl0aHJlYWQ7DQo+ID4gZGlmZiAtLWdpdCBhL2FybTY0L2t2bS1jcHUuYyBiL2FybTY0L2t2bS1j
cHUuYw0KPiA+IGluZGV4IDVlNGYzYTdkLi4zNWUxYzYzOSAxMDA2NDQNCj4gPiAtLS0gYS9hcm02
NC9rdm0tY3B1LmMNCj4gPiArKysgYi9hcm02NC9rdm0tY3B1LmMNCj4gPiBAQCAtMTIsNiArMTIs
NyBAQA0KPiA+IMKgDQo+ID4gwqAjZGVmaW5lIFNDVExSX0VMMV9FMEVfTUFTSwkoMSA8PCAyNCkN
Cj4gPiDCoCNkZWZpbmUgU0NUTFJfRUwxX0VFX01BU0sJKDEgPDwgMjUpDQoNCm5pdDogSXQgbWln
aHQgYmUgd29ydGggcmVuYW1pbmcgdGhlc2UgdG8gU0NUTFJfRUx4X0UuLi4gKG9yDQpTQ1RMUl9F
RV9NQVNLLCBTQ1RMUl9FMEVfTUFTSykgYXMgd2UgYXBwbHkgdGhlbSB0byBib3RoIHRoZSBFTDEg
YW5kIEVMMg0KdmVyc2lvbnMuDQoNCj4gPiArI2RlZmluZSBIQ1JfRUwyX1RHRQkJKDEgPDwgMjcp
DQo+ID4gwqANCj4gPiDCoHN0YXRpYyBpbnQgZGVidWdfZmQ7DQo+ID4gwqANCj4gPiBAQCAtNDA4
LDcgKzQwOSw4IEBAIGludCBrdm1fY3B1X19nZXRfZW5kaWFubmVzcyhzdHJ1Y3Qga3ZtX2NwdQ0K
PiA+ICp2Y3B1KQ0KPiA+IMKgew0KPiA+IMKgCXN0cnVjdCBrdm1fb25lX3JlZyByZWc7DQo+ID4g
wqAJdTY0IHBzcjsNCj4gPiAtCXU2NCBzY3RscjsNCj4gPiArCXU2NCBzY3RsciwgYml0Ow0KPiA+
ICsJdTY0IGhjciA9IDA7DQo+ID4gwqANCj4gPiDCoAkvKg0KPiA+IMKgCSAqIFF1b3RpbmcgdGhl
IGRlZmluaXRpb24gZ2l2ZW4gYnkgUGV0ZXIgTWF5ZGVsbDoNCj4gPiBAQCAtNDE5LDggKzQyMSw5
IEBAIGludCBrdm1fY3B1X19nZXRfZW5kaWFubmVzcyhzdHJ1Y3Qga3ZtX2NwdQ0KPiA+ICp2Y3B1
KQ0KPiA+IMKgCSAqIFdlIGZpcnN0IGNoZWNrIGZvciBhbiBBQXJjaDMyIGd1ZXN0OiBpdHMgZW5k
aWFubmVzcyBjYW4NCj4gPiDCoAkgKiBjaGFuZ2Ugd2hlbiB1c2luZyBTRVRFTkQsIHdoaWNoIGFm
ZmVjdHMgdGhlIENQU1IuRSBiaXQuDQo+ID4gwqAJICoNCj4gPiAtCSAqIElmIHdlJ3JlIEFBcmNo
NjQsIHVzZSBTQ1RMUl9FTDEuRTBFIGlmIGFjY2VzcyBjb21lcw0KPiA+IGZyb20NCj4gPiAtCSAq
IEVMMCwgYW5kIFNDVExSX0VMMS5FRSBpZiBhY2Nlc3MgY29tZXMgZnJvbSBFTDEuDQo+ID4gKwkg
KiBJZiB3ZSdyZSBBQXJjaDY0LCBkZXRlcm1pbmUgd2hpY2ggU0NUTFIgcmVnaXN0ZXIgdG8NCj4g
PiB1c2UsDQo+ID4gKwkgKiBkZXBlbmRpbmcgb24gTlYgYmVpbmcgdXNlZCBvciBub3QuIFRoZW4g
dXNlIGVpdGhlciB0aGUNCj4gPiBFMEUNCj4gPiArCSAqIGJpdCBmb3IgRUwwLCBvciB0aGUgRUUg
Yml0IGZvciBFTDEvRUwyLg0KPiA+IMKgCSAqLw0KPiA+IMKgCXJlZy5pZCA9IEFSTTY0X0NPUkVf
UkVHKHJlZ3MucHN0YXRlKTsNCj4gPiDCoAlyZWcuYWRkciA9ICh1NjQpJnBzcjsNCj4gPiBAQCAt
NDMwLDE2ICs0MzMsNDAgQEAgaW50IGt2bV9jcHVfX2dldF9lbmRpYW5uZXNzKHN0cnVjdCBrdm1f
Y3B1DQo+ID4gKnZjcHUpDQo+ID4gwqAJaWYgKHBzciAmIFBTUl9NT0RFMzJfQklUKQ0KPiA+IMKg
CQlyZXR1cm4gKHBzciAmIENPTVBBVF9QU1JfRV9CSVQpID8gVklSVElPX0VORElBTl9CRQ0KPiA+
IDogVklSVElPX0VORElBTl9MRTsNCj4gPiDCoA0KPiA+IC0JcmVnLmlkID0gQVJNNjRfU1lTX1JF
RyhBUk1fQ1BVX0NUUkwsDQo+ID4gQVJNX0NQVV9DVFJMX1NDVExSX0VMMSk7DQo+ID4gKwlpZiAo
dmNwdS0+a3ZtLT5jZmcuYXJjaC5uZXN0ZWRfdmlydCkgew0KPiA+ICsJCXJlZy5pZCA9IEFSTTY0
X1NZU19SRUcoU1lTX0hDUl9FTDIpOw0KPiA+ICsJCXJlZy5hZGRyID0gKHU2NCkmaGNyOw0KPiA+
ICsJCWlmIChpb2N0bCh2Y3B1LT52Y3B1X2ZkLCBLVk1fR0VUX09ORV9SRUcsICZyZWcpIDwNCj4g
PiAwKQ0KPiA+ICsJCQlkaWUoIktWTV9HRVRfT05FX1JFRyBmYWlsZWQgKEhDUl9FTDIpIik7DQo+
ID4gKwl9DQo+ID4gKw0KPiA+ICsJc3dpdGNoIChwc3IgJiBQU1JfTU9ERV9NQVNLKSB7DQo+ID4g
KwljYXNlIFBTUl9NT0RFX0VMMHQ6DQo+ID4gKwkJaWYgKGhjciAmIEhDUl9FTDJfVEdFKQ0KPiA+
ICsJCQlyZWcuaWQgPSBBUk02NF9TWVNfUkVHKFNZU19TQ1RMUl9FTDIpOw0KPiA+ICsJCWVsc2UN
Cj4gPiArCQkJcmVnLmlkID0gQVJNNjRfU1lTX1JFRyhTWVNfU0NUTFJfRUwxKTsNCj4gPiArCQli
aXQgPSBTQ1RMUl9FTDFfRTBFX01BU0s7DQo+ID4gKwkJYnJlYWs7DQo+IA0KPiBBIGRpc2N1c3Np
b24gd2l0aCBTYXNjaGEgb3V0bGluZWQgYSBzbWFsbCBidWcgaGVyZTogd2hlbiB1c2luZyB0aGUN
Cj4gRUwyDQo+IHRyYW5zbGF0aW9uIHJlZ2ltZSAoRTJIPT0wKSwgd2Ugc2FtcGxlIHRoZSB3cm9u
ZyBiaXQgKFNDVExSX0VMMi5FMEUNCj4gZG9lcyBub3QgZXhpc3QgaW4gdGhpcyBjYXNlKS4NCj4g
DQo+IEEgcG90ZW50aWFsIGZpeCBpcyBhcyBmb2xsb3dzLCB0aG91Z2ggSSBkb24ndCB0aGluayBh
bnlvbmUgd2lsbA0KPiBjYXJlLi4uDQo+IA0KPiAJTS4NCj4gDQo+IGRpZmYgLS1naXQgYS9hcm02
NC9rdm0tY3B1LmMgYi9hcm02NC9rdm0tY3B1LmMNCj4gaW5kZXggMzVlMWM2MzkuLjdiMDEyZTdh
IDEwMDY0NA0KPiAtLS0gYS9hcm02NC9rdm0tY3B1LmMNCj4gKysrIGIvYXJtNjQva3ZtLWNwdS5j
DQo+IEBAIC0xMiw3ICsxMiw4IEBADQo+IMKgDQo+IMKgI2RlZmluZSBTQ1RMUl9FTDFfRTBFX01B
U0sJKDEgPDwgMjQpDQo+IMKgI2RlZmluZSBTQ1RMUl9FTDFfRUVfTUFTSwkoMSA8PCAyNSkNCj4g
LSNkZWZpbmUgSENSX0VMMl9UR0UJCSgxIDw8IDI3KQ0KPiArI2RlZmluZSBIQ1JfRUwyX1RHRQkJ
KDFVTCA8PCAyNykNCj4gKyNkZWZpbmUgSENSX0VMMl9FMkgJCSgxVUwgPDwgMzQpDQo+IMKgDQo+
IMKgc3RhdGljIGludCBkZWJ1Z19mZDsNCj4gwqANCj4gQEAgLTQ0MiwxMSArNDQzLDIxIEBAIGlu
dCBrdm1fY3B1X19nZXRfZW5kaWFubmVzcyhzdHJ1Y3Qga3ZtX2NwdQ0KPiAqdmNwdSkNCj4gwqAN
Cj4gwqAJc3dpdGNoIChwc3IgJiBQU1JfTU9ERV9NQVNLKSB7DQo+IMKgCWNhc2UgUFNSX01PREVf
RUwwdDoNCj4gLQkJaWYgKGhjciAmIEhDUl9FTDJfVEdFKQ0KPiArCQlzd2l0Y2ggKGhjciAmIChI
Q1JfRUwyX0UySCB8IEhDUl9FTDJfVEdFKSkgew0KPiArCQljYXNlIEhDUl9FTDJfRTJIIHwgSENS
X0VMMl9UR0U6IC8qIEVMMiYwICovDQo+IMKgCQkJcmVnLmlkID0gQVJNNjRfU1lTX1JFRyhTWVNf
U0NUTFJfRUwyKTsNCj4gLQkJZWxzZQ0KPiArCQkJYml0ID0gU0NUTFJfRUwxX0UwRV9NQVNLOw0K
PiArCQkJYnJlYWs7DQo+ICsJCWNhc2UgSENSX0VMMl9UR0U6wqAJCS8qIEVMMiAqLw0KPiArCQkJ
cmVnLmlkID0gQVJNNjRfU1lTX1JFRyhTWVNfU0NUTFJfRUwyKTsNCj4gKwkJCWJpdCA9IFNDVExS
X0VMMV9FRV9NQVNLOw0KPiArCQkJYnJlYWs7DQo+ICsJCWNhc2UgSENSX0VMMl9FMkg6CQkvKiBF
TDEmMCAoVkhFKSAqLw0KPiArCQlkZWZhdWx0OgkJCS8qIEVMMSYwICghVkhFKSAqLw0KPiDCoAkJ
CXJlZy5pZCA9IEFSTTY0X1NZU19SRUcoU1lTX1NDVExSX0VMMSk7DQo+IC0JCWJpdCA9IFNDVExS
X0VMMV9FMEVfTUFTSzsNCj4gKwkJCWJpdCA9IFNDVExSX0VMMV9FMEVfTUFTSzsNCj4gKwkJCWJy
ZWFrOw0KPiArCQl9DQo+IMKgCQlicmVhazsNCg0KVGhpcyB2ZXJzaW9uIG1hdGNoZXMgbXkgdW5k
ZXJzdGFuZGluZyBvZiBob3cgdGhpcyBzaG91bGQgd29yay4NCg0KSXQgaXMgcHJvYmFibHkgd29y
dGggdXBkYXRpbmcgdGhlIGNvbW1lbnQgYWJvdmUgdGhpcyBibG9jayB0b28uIEF0IHRoZQ0KdmVy
eSBsZWFzdCAiZGVwZW5kaW5nIG9uIE5WIGJlaW5nIHVzZWQgb3Igbm90IiBzaG91bGQgYmVjb21l
ICJkZXBlbmRpbmcNCm9uIHRoZSBjb21iaW5hdGlvbiBvZiBUR0UgYW5kIEUySCIgb3Igc2ltaWxh
ci4NCg0KVGhhbmtzLA0KU2FzY2hhDQoNCj4gwqAJY2FzZSBQU1JfTU9ERV9FTDF0Og0KPiDCoAlj
YXNlIFBTUl9NT0RFX0VMMWg6DQo+IA0KDQo=

