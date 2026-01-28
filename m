Return-Path: <kvm+bounces-69360-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cGxALulIemkp5AEAu9opvQ
	(envelope-from <kvm+bounces-69360-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:35:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DC2DA6FD0
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:35:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 84B75301326B
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 17:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 987EF35293A;
	Wed, 28 Jan 2026 17:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fGsxlM3r";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fGsxlM3r"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011029.outbound.protection.outlook.com [52.101.70.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9948B1E3DF2
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.29
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769621536; cv=fail; b=mnZ3B+XFoR83xgDvVZT6O2KMemQ+9F+1vB69mpxBLz45+NFxS2CzfzKZ3J67vnfSzHVnx1by9oJX0u+ClrIluejv2pJWqA2CbwLRksCEtmQPNmrD2oGKSqgn5sjD3ZtXqkR3jSjMqipPLLB66qZhX7sXXJJamPskfI8THkW/8Yg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769621536; c=relaxed/simple;
	bh=hrKLAip9QuQwKIfQzg/X7aiO6rcBP4eRr0+JKRKd0KY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DyqPSjdo73Hj5mKdPYU/fzUlc9SkPEf1qZryjZAAhiH/WDdvllfaqlb2gbRTNZKLJbtjlAtS5TbQwQNZFrPl5HLWUO5tFZfqvdiCRW4qnp+SUlbwJCGxzdGjNUHCxTcVOnez55isk7BQgTYK5qYL6AMxGqWePGLFchIyEGA6gm8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fGsxlM3r; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fGsxlM3r; arc=fail smtp.client-ip=52.101.70.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Tg8ha5daDoIzRgpiJsFGJ1lDfYrHkvrnSGa9J+LeKHakl8+L0ZLZjZSx1UKfkUeG6NLqPh+iWzi3vhnhmUHdZvPHPP2zbZaCNC9h+3QnnRu0KNTboNV6bsm3dlRUpjs1BD4cX5OUKi/Vs7nX+hmr03/YpAlqC0yweV+6iXyWAcbkPscsXrG397I5BPU1Cvb6myHwU2B7zDoAIjRtUId4YhpYiEIUiffkQwl6xybUwhHXFgopP8j5ihhHEIODKi2AfzUWzisJYPzxjB0OZwjmog8hNCurOTpIhbACoBWABsFbKkiEBTj3PJGbWlS7+XkjqytwIDOrOK6kWfpeUeP5yw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hrKLAip9QuQwKIfQzg/X7aiO6rcBP4eRr0+JKRKd0KY=;
 b=CoSggmOVhWFRKvTP2+PnK3eW7Lfm551wuNa36cgB3N/wGd+mxjywYPqupgnVYa8MH3rDgS5/lneTxm1aHm7v7eP/lDyYg/qAZFfOJtCsxEOa/cfDiLDfjn4CNwQfFE+2aWfMxqwOjXaBJA7HP1Gmd4STmjySI7t0XABKljdIsxyUO6cpVCWrhEXkwOO506YVriotNSRjrAWUvJWh09BCL0oGok7URlgI1qwiKuRPvGymCSnoqv403V9Zz5e5LZL/nKc13kfs7a8nRB67r8B7Sz3Oz/QMDLNiy6GZ/yqgvnUhQuh/HH6elrB1JsispkqohORR54TDWTnjlkhPg7/eTw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hrKLAip9QuQwKIfQzg/X7aiO6rcBP4eRr0+JKRKd0KY=;
 b=fGsxlM3rpK1gt7Kvtc78BlGehFXQzrnrgaGkj9Gv58qD3HkoO3+L7FqFYnV+y0mnXE4Xf0TA0OlkRi7Uc3VnliCcd+Yagdg/CuUrSY0j4O4hWNDZsE00LaDvcEsUqQv4HFmyHmVWkFZCUpMlKn/pctewNLx8hOayTJKjSo7KsFk=
Received: from DU7P250CA0024.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:54f::17)
 by AS8PR08MB9241.eurprd08.prod.outlook.com (2603:10a6:20b:5a0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 17:32:07 +0000
Received: from DB5PEPF00014B97.eurprd02.prod.outlook.com
 (2603:10a6:10:54f:cafe::f2) by DU7P250CA0024.outlook.office365.com
 (2603:10a6:10:54f::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Wed,
 28 Jan 2026 17:32:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B97.mail.protection.outlook.com (10.167.8.235) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 17:32:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l+INh04lKs8nlJC8AAxWqC4tR0hO+hEx4/YDjfa/HWq6u7Jos2Cnukuq2yNwdT2nInEVvyx41NSSgGlnV9D7mYZAJq3qpDJLuQH0T2m2Xzgdnf6GfqfZwpwbaIkLVwao7Uare5JUqfwHxtuDa86w7EOVpxnNod9chSSRIZdAzOMJIT2hLGR7/iYXmgggV+CEQoPU8UJvuYLibVKAnSdL3D7xZUey8eJcD2LWk4kbvJz1CD88O3GN09h6ROXJHSc1eHzUI1fcs3akiI4W2GFElF0BohQS5GMo4cAskqqzVPwW8zjIof1QyQgOxcduMdR6WQVebJ5dTcF7u9MK9r9Nbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hrKLAip9QuQwKIfQzg/X7aiO6rcBP4eRr0+JKRKd0KY=;
 b=q7jb7QZC0UCvS9C4Pqu0mZ+N+RC6tJM5ECEVHWRe/qyrsZAUMIfuKZxTh7MMsKWNgJVUcXnyLFVVtE4W1EXdsUA47mt7b76n3CgGCj/rY3nruW6UWsx36c8vOu0wLf9ex5De7IcKMtRgq+5Io7QQVaCmE80K58KgomOKF0rGeB/owdcEUf2qHeBRnDKLPJyHKpK9bR6ghHK4hK8iZIwP351X6xTHmegTdWuUEF9EGPHZ2vGB2iFYCFsa9SjeC71Y6WkRp332TiM8ZppBDEDEYYF5/DUS4Pc4Hb/umpAlTNvHUdkWBf+X4NwSopowkgGoR2d/1edwO5jrddKj7wfZUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hrKLAip9QuQwKIfQzg/X7aiO6rcBP4eRr0+JKRKd0KY=;
 b=fGsxlM3rpK1gt7Kvtc78BlGehFXQzrnrgaGkj9Gv58qD3HkoO3+L7FqFYnV+y0mnXE4Xf0TA0OlkRi7Uc3VnliCcd+Yagdg/CuUrSY0j4O4hWNDZsE00LaDvcEsUqQv4HFmyHmVWkFZCUpMlKn/pctewNLx8hOayTJKjSo7KsFk=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VI0PR08MB11020.eurprd08.prod.outlook.com (2603:10a6:800:256::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 17:31:02 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 17:31:02 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v3 15/36] KVM: arm64: gic-v5: Implement GICv5 load/put and
 save/restore
Thread-Topic: [PATCH v3 15/36] KVM: arm64: gic-v5: Implement GICv5 load/put
 and save/restore
Thread-Index: AQHcgYoNuP0mM43sl0ee5XSBBQND3LVOsu4AgBlBvAA=
Date: Wed, 28 Jan 2026 17:31:02 +0000
Message-ID: <87220f6745dab3bfda8e0f65ed9cb113c34d91f5.camel@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	 <20260109170400.1585048-16-sascha.bischoff@arm.com>
	 <20260112154916.00002911@huawei.com>
In-Reply-To: <20260112154916.00002911@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|VI0PR08MB11020:EE_|DB5PEPF00014B97:EE_|AS8PR08MB9241:EE_
X-MS-Office365-Filtering-Correlation-Id: 49f6e1f7-f714-4f82-f813-08de5e93282b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?YWZCYnA5amVHNGhxNE5nb3BVU242L2FTWUVvTitkS3IvV1pMamFUeXNOTkdm?=
 =?utf-8?B?RGxEUVFDM3FLcGtTN0oyOXZWRnIzall3Rk0veFZWaDZTYkRLQnVoTEl2S0xO?=
 =?utf-8?B?WEY5OVg2bnlWSm9EcVhBVGFwOFdwWVNMc0JUeGRBZTNrZzhxNzV2LzZUR2xD?=
 =?utf-8?B?aUxtNXUxK3hhRnJMRGNTdkhnT2g4a0JPUS9qUVZNYldJRmgxLzhwcWNFVUMw?=
 =?utf-8?B?RUZEakpOeXNFcUlBWVBmbUxtNzdHOHp4QjdTUUJlMGEzVFduR3JYaGVRRTAy?=
 =?utf-8?B?eERiVUVRU2laUDVKM1dMZVFoeUJiSThaTklPWitNbS9abWhESndBMTNaeXI4?=
 =?utf-8?B?eS9rTlk3WXc3cUc4Q1NjckhIYVhwaWpjbTNZWkdURjlFNFhvdFNjRGlZUUhW?=
 =?utf-8?B?MEtXanozTVJab0E5ejN3S0hiQ3pmUjRSM3hGeDYxRHlGOUhPLzVUVzUrdWhS?=
 =?utf-8?B?b2hyOXRjekZLZWozV0NodWdvVEIrOHRsT0E5K2JPMFpiZXZSdjhoRk9IOHVw?=
 =?utf-8?B?c3I4ZVAxV2ljNktJdGdncWNGL1RuUGFGOW1UL3NEV0VlZFRib3NUQ3ZneTgv?=
 =?utf-8?B?bThXSUpySlRsV05OZWpUMEtBZnpBT3ViTXZ2U1pmSEJueVlIVzZ0anJ6bTBI?=
 =?utf-8?B?QWNaRFhETjZMcnpISHZDZ2tXc3AyOFJVSEZ3NVpBaEtIMGU0dDNIb2ZteGta?=
 =?utf-8?B?V2VRalBIZEdUc0ZmdHZqTk9Bd3dyVkhGMzdIRDhOMHovbm1zMDJhQnoyYVpM?=
 =?utf-8?B?Ymx1ZUdZU2lzaFRMSlpMb1UvZ0J4MXJUNjlRRms1NlJPNVVoNEpHZDF4MVRl?=
 =?utf-8?B?aHh6eVB2L1RNYy9od2VBTkpJL1IvVCtld01VWDBDZTdjRitlSXNuRnpobzZw?=
 =?utf-8?B?M1ZQcUVnWVhoa3d4eFROd1Q5WTFoR29STlQvUDVOZ04zYmQvaEcvMEtFbjI4?=
 =?utf-8?B?eWpGMzhsZjZ6QWt5cDIyMXdmWjJ2d1hSNXZZQzl6OWxMZ0tqNUJLakFjNnlV?=
 =?utf-8?B?bkE0cEZMS1FVOWdrenJkSGJ0UFNmamQ2TXhRZXJNOHFJZUtpSXdROUF0K2E0?=
 =?utf-8?B?Zis3TG5ZbjBtZnUxTzgxU1k0aFdIaU9CMkE4azh3QVpGRDhMRGFCKzlqMVZX?=
 =?utf-8?B?UmljN2FGSC9wUXhJaFFEemRFVEUzM2FyUFhIL0xiUVBQVFh1WlQzKzd0QjMw?=
 =?utf-8?B?ejB3Y1VyOVRPb0VJUjdoK3IweXVaL2kxZy9nSy8zWkVORUg2SWhYSEdCRVBC?=
 =?utf-8?B?cHVyZ3d0eGt0U0JXallSVkpqcVo3MitmQmVQWndtR2lXbXBtOTVmdWs2S2NU?=
 =?utf-8?B?WDhzaTAweEl2dlJyUnJ4QTlsMDJSQk9UVVZvZnVRb2ZDQlVhODlGT3hRV0RN?=
 =?utf-8?B?QWt5NUN6dVBYdFFPMk5DZVIxN2JSczlCVG80K0VpZVVncDAzRTMwMlBqRkNz?=
 =?utf-8?B?UG8xQWd2a3FyZEo3M1JkQzNWTnRGcndtMzd5dkt2RWpRTG9LSnl3eWhkaHd0?=
 =?utf-8?B?YkpDbXEzNGoySXA5Qk5VeTlKeEQrTTJNOEJvRzVsZzFpQUpuUGFwOUpxRWhP?=
 =?utf-8?B?QXR0RG9FSi9tdE5ScjFaYm83a3NacWlJQnl4NmNJSmRIOUhTTmRpeHdOK3Q4?=
 =?utf-8?B?TjJwQ3JvT2hiUU92MXpiSk9CbXNidFJ2Tmp1Q0FHMGtvaUFkcCtrRjFuS2pO?=
 =?utf-8?B?dk1wWjROSTF4Rk56Z3NocFpMK2dzRm4ya3hOaXg3dmZic2JRaXppWFdTMW5u?=
 =?utf-8?B?bXZyUDlaOWZjK2xIWTFBaW5QcnlTa0tCcjlMUm1qelhsNVhHQjJvT3VQY2Z4?=
 =?utf-8?B?R2VoSHVDUUdKeGhEQ2duRjcrZVd4WXhtQmNUVjBtZ3daY2p4RDFsN3d3THZS?=
 =?utf-8?B?K0ZKKy90QVBJOEcxZC93ckxxeVdFYnhHTG0ydVJPdnNCeTYyNDNLWUFUZm04?=
 =?utf-8?B?SUliU3lKQTVZaUNSTjM5V1ZDYWIvamZzdVZqNElsY0xIS3RMQ01qeHRQT1VZ?=
 =?utf-8?B?czczNmdwOUtBY05SdnpaZ0xEeDFkNFVpU21ZZi81Ri9RdGZGUERIc2VOUHZj?=
 =?utf-8?B?ZTYzWFdEMHRmb1dRZDA1bkZlMitUa0pzSVJVY1lNUllSRGs0ZUpURE1PNWRm?=
 =?utf-8?B?eFhkcmNoU2pkQm9VR29jSVRIV2cvYng3bHVOdHdtWXk3aG9hREdITjdVMTZk?=
 =?utf-8?Q?6kx405rMRo/KWqp05oq8Ylw=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2C9BD11FFD9BE54E968F082B895EB40E@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11020
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B97.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b632e76d-85fd-476a-90bd-08de5e93026f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|14060799003|1800799024|36860700013|35042699022|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YnBjMlBZNWVmZXBxQUhTYW5EL3Mwa0w2OVFZR2IrQ3JuV3lheE1kMkZCYThB?=
 =?utf-8?B?aXYvZ28xMjNmQ1pkRVRqTWxUclpmaUdNT1p1SDR2N2M4VUorYnREeTRjUFZr?=
 =?utf-8?B?KzJ5TXh0RW9lZWYvNVQzcGM1WGZDa0pwVTV2V2FacE5tamVFVzU5Tm1CZ1dm?=
 =?utf-8?B?WnZmd2JzSG9hZFZDS2NFb3ZUVTVVWG9hWnNpbVllV2NEK1QvM3J5cjJLdXFG?=
 =?utf-8?B?NGJqZm1QVVczT3REUFcrQkJGUVg4b0hqMG5XWUkway9zVlJrd2kyQ3BnSVA1?=
 =?utf-8?B?Wks4SEpKdDZHRmpRWmNRSkdVK00zSU1CemsvNy9zSkl5TzFnQ2s3eVUraEw0?=
 =?utf-8?B?TTVhVFd0VGJxNW55TmdTNEpDSXNWalRXa1NvMDVMNHpIRkZocXBjUDhBeTVP?=
 =?utf-8?B?OEQrMldMUTNreUZ2U2hncjFPa011S0FVZ2hQZFl2eWZpeVJ6WVdtSEswWE5Y?=
 =?utf-8?B?UlZaOWtCYkxNSjNOV09RQllxdHdaZ3RQeWlVYjgvVFlWMmxwT3I2Q25KYUlR?=
 =?utf-8?B?MTZ0c2hrVytycEZ3Z3ZVMFFiRzF0YXFDanVpNWd0TFozcEhSc21meEtVT1BS?=
 =?utf-8?B?bG1qb1JEVk1WTDNhc3JlUjhvZFdHOG84ZGUrOS81eG1VUUgwZXZkaXNocmdL?=
 =?utf-8?B?VTRTSzJCSXcyM2M2M3oyRU9iR0dUbTk1N2FRZnV6MWtYblV6VXFseUlCNXdO?=
 =?utf-8?B?Z0doQVFENkFjU1pGUktSQmY0bERmUldzd29mWTkrbFg5MDdUWUplWUZROW1L?=
 =?utf-8?B?c25BdnB4UEduSkZmMzlKNnVVYjU1VTVHRjZiOW1HM3hCVjBZaXZSMVZ6ZytO?=
 =?utf-8?B?NzNUVVljMG1FMzROenYxdDhjSmllL1pKMXUrMHgrUStaSnBvMEVJdWRydU95?=
 =?utf-8?B?c2N3MXM2V0VoajJlOUROWUp5eU1pSVJQZDJ1d3NMUFdXV0Q5TDBoVnhrbkxY?=
 =?utf-8?B?WE1tdEdYRThqY29LV0wxU1hmbTJQcFZ6bjI1Uk9iWjhtRkFyYmlRS1NTUTdL?=
 =?utf-8?B?N1RTenRzbWl6U3FZV0YyYWJDc3ZNV1dlc3dwLy9ENk9Lbys1SllPNElJaTBs?=
 =?utf-8?B?bXZ4UXRoMW5YalJlZUtYVER6bXhPUHhRbGxFajg3aUJuWldRY1pocDZsUEM3?=
 =?utf-8?B?L2VCem4wUEhCUDJnSGhHajZCMS9BZEVjVHkxUlRONUFvMzE0SThWUUIvSC9i?=
 =?utf-8?B?dXRBVnhKZkNOV0hBbVQ5R3h6SERNTWIrOEJlNzhqOUhZbGFQQUVvaDVndUZq?=
 =?utf-8?B?WGlWMjdzc2xWT2JwNkU5MW1xTE1Qa1JmcHpjbGU0MDkrcFdGK1RtRTJpcG9P?=
 =?utf-8?B?MXFtenpCb3RMWlBPWW1tZDdxdWRtb0hjbWJDN1oxQzR5WE1kTTlaSG5KSGJp?=
 =?utf-8?B?clNSM2ZzT3VmRnNKNEJROGx0VTh1TVBKTjArTG9odEpOVVZ0blBHejNGeW9z?=
 =?utf-8?B?T3UxOUxlT1BmcWw2VDgxcWRvSW5mZ1BQNitPcTM3aldJUGVYSDJWOWZVS0M5?=
 =?utf-8?B?TGJXVmIrR0pZU1IxdXJ1eGpIY1dSZmcvb3FKdFQ0TzlWWitvTW0rWkVCM3kv?=
 =?utf-8?B?SlNZdmtYeDdNTkhzTm4yUis4aG9GRE9kMXNkR3k5SWxVbm9hQXZ5WUJVYXA5?=
 =?utf-8?B?SHgycFNSVVJpYzhHTC9QNFJoc2FzQ2tKQVZBQklsblZnekd3d2p0V210bk40?=
 =?utf-8?B?Z0dsT3pvWHNXbytnQ1VnRGRZZEUwTEgzTlpyUlpuc0lBTFlJaE9EOFRsNWZK?=
 =?utf-8?B?V1R4VWlkSS95YzhhckxKVWFaNmJ2S1o0WkhEVW5WZjlwaWdzK0JSU1Bod3NX?=
 =?utf-8?B?TDFrT2FOOVFUbFJFeDd2NHhucFZrZE9nZUlNYmwrOTA3WEFjTVdIQkozcHRV?=
 =?utf-8?B?T2NQVW5qaURHcFB2Mmk1eXlRTm5Hc0xDSWkyVm5hVDZFSU5RQnFMaUtld0kx?=
 =?utf-8?B?RER1VWxyM2RxeEdYbjJiWm1nLzVMYmR4Unh5Y1ByR2Zvck1xdUdaeVQyREVR?=
 =?utf-8?B?cVRmZWRtYjczL2JmOU43U0tvd0N1L3FGM2gzZjY1Q2RTRmhjRkh4Yk9jUU9J?=
 =?utf-8?B?bUhJRXc1QzV5dVNJUnc0OU1HWTJJRlRrYzRkb0E3dk1yeHlCL1hXTTF5OGV6?=
 =?utf-8?B?d3phbDlYV1VDdFBhMW4zNTh2R1ZPaHNIUytLSTRmTDZRMU5hVkR0RFBGazhK?=
 =?utf-8?B?WGRMNStwSjJMUGYyUm1vZWl2czBaYy96YzYyT0laTHN6SlI1VGkzeFAzUlNK?=
 =?utf-8?B?QWFlK3lqNHVpQzd0RitGM21TOVhBPT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(14060799003)(1800799024)(36860700013)(35042699022)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 17:32:05.9222
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49f6e1f7-f714-4f82-f813-08de5e93282b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B97.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9241
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
	TAGGED_FROM(0.00)[bounces-69360-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
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
X-Rspamd-Queue-Id: 1DC2DA6FD0
X-Rspamd-Action: no action

T24gTW9uLCAyMDI2LTAxLTEyIGF0IDE1OjQ5ICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDkgSmFuIDIwMjYgMTc6MDQ6NDQgKzAwMDANCj4gU2FzY2hhIEJpc2Nob2Zm
IDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4gd3JvdGU6DQo+IA0KPiA+IFRoaXMgY2hhbmdlIGlu
dHJvZHVjZXMgR0lDdjUgbG9hZC9wdXQuIEFkZGl0aW9uYWxseSwgaXQgcGx1bWJzIGluDQo+ID4g
c2F2ZS9yZXN0b3JlIGZvcjoNCj4gPiANCj4gPiAqIFBQSXMgKElDSF9QUElfeF9FTDIgcmVncykN
Cj4gPiAqIElDSF9WTUNSX0VMMg0KPiA+ICogSUNIX0FQUl9FTDINCj4gPiAqIElDQ19JQ1NSX0VM
MQ0KPiA+IA0KPiA+IEEgR0lDdjUtc3BlY2lmaWMgZW5hYmxlIGJpdCBpcyBhZGRlZCB0byBzdHJ1
Y3QgdmdpY192bWNyIGFzIHRoaXMNCj4gPiBkaWZmZXJzIGZyb20gcHJldmlvdXMgR0lDcy4gT24g
R0lDdjUtbmF0aXZlIHN5c3RlbXMsIHRoZSBWTUNSIG9ubHkNCj4gPiBjb250YWlucyB0aGUgZW5h
YmxlIGJpdCAoZHJpdmVuIGJ5IHRoZSBndWVzdCB2aWEgSUNDX0NSMF9FTDEuRU4pDQo+ID4gYW5k
DQo+ID4gdGhlIHByaW9yaXR5IG1hc2sgKFBDUikuDQo+ID4gDQo+ID4gQSBzdHJ1Y3QgZ2ljdjVf
dnBlIGlzIGFsc28gaW50cm9kdWNlZC4gVGhpcyBjdXJyZW50bHkgb25seSBjb250YWlucw0KPiA+
IGENCj4gPiBzaW5nbGUgZmllbGQgLSBib29sIHJlc2lkZW50IC0gd2hpY2ggaXMgdXNlZCB0byB0
cmFjayBpZiBhIFZQRSBpcw0KPiA+IGN1cnJlbnRseSBydW5uaW5nIG9yIG5vdCwgYW5kIGlzIHVz
ZWQgdG8gYXZvaWQgYSBjYXNlIG9mIGRvdWJsZQ0KPiA+IGxvYWQNCj4gPiBvciBkb3VibGUgcHV0
IG9uIHRoZSBXRkkgcGF0aCBmb3IgYSB2Q1BVLiBUaGlzIHN0cnVjdCB3aWxsIGJlDQo+ID4gZXh0
ZW5kZWQNCj4gPiBhcyBhZGRpdGlvbmFsIEdJQ3Y1IHN1cHBvcnQgaXMgbWVyZ2VkLCBzcGVjaWZp
Y2FsbHkgZm9yIFZQRQ0KPiA+IGRvb3JiZWxscy4NCj4gPiANCj4gPiBDby1hdXRob3JlZC1ieTog
VGltb3RoeSBIYXllcyA8dGltb3RoeS5oYXllc0Bhcm0uY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IFRpbW90aHkgSGF5ZXMgPHRpbW90aHkuaGF5ZXNAYXJtLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBTYXNjaGEgQmlzY2hvZmYgPHNhc2NoYS5iaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gUmV2aWV3
ZWQtYnk6IEpvbmF0aGFuIENhbWVyb24gPGpvbmF0aGFuLmNhbWVyb25AaHVhd2VpLmNvbT4NCj4g
DQo+IE9uZSBjb21tZW50IGJlbG93Lg0KPiANCj4gPiAtLS0NCj4gPiDCoGFyY2gvYXJtNjQva3Zt
L2h5cC9udmhlL3N3aXRjaC5jwqDCoCB8IDEyICsrKysrDQo+ID4gwqBhcmNoL2FybTY0L2t2bS92
Z2ljL3ZnaWMtbW1pby5jwqDCoMKgIHwgMjggKysrKysrKy0tLS0NCj4gPiDCoGFyY2gvYXJtNjQv
a3ZtL3ZnaWMvdmdpYy12NS5jwqDCoMKgwqDCoCB8IDc0DQo+ID4gKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrDQo+ID4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuY8KgwqDCoMKgwqDC
oMKgwqAgfCAzMiArKysrKysrKy0tLS0tDQo+ID4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMu
aMKgwqDCoMKgwqDCoMKgwqAgfMKgIDcgKysrDQo+ID4gwqBpbmNsdWRlL2t2bS9hcm1fdmdpYy5o
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAyICsNCj4gPiDCoGluY2x1ZGUvbGludXgvaXJx
Y2hpcC9hcm0tZ2ljLXY1LmggfMKgIDUgKysNCj4gPiDCoDcgZmlsZXMgY2hhbmdlZCwgMTQxIGlu
c2VydGlvbnMoKyksIDE5IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNo
L2FybTY0L2t2bS9oeXAvbnZoZS9zd2l0Y2guYw0KPiA+IGIvYXJjaC9hcm02NC9rdm0vaHlwL252
aGUvc3dpdGNoLmMNCj4gPiBpbmRleCBjMjNlMjJmZmFjMDgwLi5iYzQ0NmE1ZDk0ZDY4IDEwMDY0
NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL2h5cC9udmhlL3N3aXRjaC5jDQo+ID4gKysrIGIv
YXJjaC9hcm02NC9rdm0vaHlwL252aGUvc3dpdGNoLmMNCj4gPiBAQCAtMTEzLDYgKzExMywxMiBA
QCBzdGF0aWMgdm9pZCBfX2RlYWN0aXZhdGVfdHJhcHMoc3RydWN0IGt2bV92Y3B1DQo+ID4gKnZj
cHUpDQo+ID4gwqAvKiBTYXZlIFZHSUN2MyBzdGF0ZSBvbiBub24tVkhFIHN5c3RlbXMgKi8NCj4g
PiDCoHN0YXRpYyB2b2lkIF9faHlwX3ZnaWNfc2F2ZV9zdGF0ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUpDQo+ID4gwqB7DQo+ID4gKwlpZiAoa2Vybl9oeXBfdmEodmNwdS0+a3ZtKS0+YXJjaC52Z2lj
LnZnaWNfbW9kZWwgPT0NCj4gPiBLVk1fREVWX1RZUEVfQVJNX1ZHSUNfVjUpIHsNCj4gDQo+IFdo
eSBjYW4ndCB5b3UgdXNlIHRoZSBoZWxwZXI/IGUuZw0KPiANCj4gCWlmICh2Z2ljX2lzX3Y1KGtl
cm5faHlwX3ZhKHZjcHUtPmt2bSkpKSB7DQo+IFdoaWxzdCBrdm0vYXJtX3ZnaWMuaCBpc24ndCBk
aXJlY3RseSBpbmNsdWRlZCBoZXJlIG90aGVyIHN0dWZmIGZyb20NCj4gdGhhdCBoZWFkZXINCj4g
aXMgaW4gdXNlIGxpa2Uga3ZtX3ZnaWNfZ2xvYmFsX3N0YXRlLg0KDQpJIGNhbiBhbmQgaGF2ZSBu
b3cgLSBhcyBwYXJ0IG9mIHRoZSBvbmUgb2YgdGhlIHByZXZpb3VzIHNldHMgb2YNCnJldmlld3Ms
IHRoZSBoZWFkZXIgZmlsZSBjb250YWluaW5nIHRoZSB2Z2ljX2lzX3Y1KCkgaGVscGVyIGNoYW5n
ZWQgKEkNCnRoaW5rIHYxLT52MikuIFByZXZpb3VzbHksIGl0IHdhcyBub3QgdHJpdmlhbGx5IHVz
YWJsZSBoZXJlLCBidXQgbm93IGl0DQppcy4NCg0KVGhhbmtzLA0KU2FzY2hhDQoNCj4gDQo+IA0K
PiA+ICsJCV9fdmdpY192NV9zYXZlX3N0YXRlKCZ2Y3B1LQ0KPiA+ID5hcmNoLnZnaWNfY3B1LnZn
aWNfdjUpOw0KPiA+ICsJCV9fdmdpY192NV9zYXZlX3BwaV9zdGF0ZSgmdmNwdS0NCj4gPiA+YXJj
aC52Z2ljX2NwdS52Z2ljX3Y1KTsNCj4gPiArCQlyZXR1cm47DQo+ID4gKwl9DQo+ID4gKw0KPiA+
IMKgCWlmDQo+ID4gKHN0YXRpY19icmFuY2hfdW5saWtlbHkoJmt2bV92Z2ljX2dsb2JhbF9zdGF0
ZS5naWN2M19jcHVpZikpIHsNCj4gPiDCoAkJX192Z2ljX3YzX3NhdmVfc3RhdGUoJnZjcHUtDQo+
ID4gPmFyY2gudmdpY19jcHUudmdpY192Myk7DQo+ID4gwqAJCV9fdmdpY192M19kZWFjdGl2YXRl
X3RyYXBzKCZ2Y3B1LQ0KPiA+ID5hcmNoLnZnaWNfY3B1LnZnaWNfdjMpOw0KPiA+IEBAIC0xMjIs
NiArMTI4LDEyIEBAIHN0YXRpYyB2b2lkIF9faHlwX3ZnaWNfc2F2ZV9zdGF0ZShzdHJ1Y3QNCj4g
PiBrdm1fdmNwdSAqdmNwdSkNCj4gPiDCoC8qIFJlc3RvcmUgVkdJQ3YzIHN0YXRlIG9uIG5vbi1W
SEUgc3lzdGVtcyAqLw0KPiA+IMKgc3RhdGljIHZvaWQgX19oeXBfdmdpY19yZXN0b3JlX3N0YXRl
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiDCoHsNCj4gPiArCWlmIChrZXJuX2h5cF92YSh2
Y3B1LT5rdm0pLT5hcmNoLnZnaWMudmdpY19tb2RlbCA9PQ0KPiA+IEtWTV9ERVZfVFlQRV9BUk1f
VkdJQ19WNSkgew0KPiA+ICsJCV9fdmdpY192NV9yZXN0b3JlX3N0YXRlKCZ2Y3B1LQ0KPiA+ID5h
cmNoLnZnaWNfY3B1LnZnaWNfdjUpOw0KPiA+ICsJCV9fdmdpY192NV9yZXN0b3JlX3BwaV9zdGF0
ZSgmdmNwdS0NCj4gPiA+YXJjaC52Z2ljX2NwdS52Z2ljX3Y1KTsNCj4gPiArCQlyZXR1cm47DQo+
ID4gKwl9DQo+ID4gKw0KPiANCj4gDQo+IA0KDQo=

