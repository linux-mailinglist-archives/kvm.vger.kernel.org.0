Return-Path: <kvm+bounces-69366-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id COAiJ/BOemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69366-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:01:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A040A767A
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:01:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 83B79301B175
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F019A36F419;
	Wed, 28 Jan 2026 18:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lSGFkMDd";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lSGFkMDd"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012028.outbound.protection.outlook.com [52.101.66.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B779238C29
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.28
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623232; cv=fail; b=rVaCtXuxULIFOuSuMKDU48c1uh9yLnp0vAUKYTo3cJgWpFgZGeHl/YfTgnmJ63djHJfaO9IsNul0bpxRKTGTIEEHu5nMeMrYEzdaT9b8UhbSNgmY54jpjSLDWEQpcQhq8gEN16uuAQk87dhlF3f6odIg/rArAG8c6JCD4lY6gP8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623232; c=relaxed/simple;
	bh=vXP6qVuoh/vsdHmPNEr++6N4hS349WVhyszI6hXm86Y=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=mgU/WihK+DRNvTNrWKpwZWopoFnSMqWJEIPjAr0exf16FEkJCkJannd9mTBF5oYTtxZpX2r3wkQWXrW4I9grOkFUlXfQAShKoy56gpeehwnCkLzfD3HIWooeFJBx/uK6VxTBhoR/AL3KSgi/UKI7xmTQzJiqxhJNc8Zant7/HMg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lSGFkMDd; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lSGFkMDd; arc=fail smtp.client-ip=52.101.66.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vtwQ0px+0o6QQY5Mfc+Wc80bvXJNRm+Kra7y4K2Ab9C7HqheYVd+uWIvFSlWmuFhObBBjVCy9WM8AB1wNuzm3GIoIGEwqUgjy0dWXk+i0sGflWchL+4LS7ST+8LYuSdV9pMyjiW5qJYc+a8v93q9Md3Qoyhh8nxTEXIUo+rTcTSfu4x+DRpGZGuLCc1s65PRoHb0O0bzaDjWhim2bgs5fBGfSCMFUPvIF6DbKdYE4UqXghOQHQeoQ+1PtWfJ4T/NFcN78kAGSlbW+MZSGWkRoIajLUkGAHaKQKiX1H1jIbRXcmcZdht2/BR3BTHalVZmjpu+hPcIp9/s07KU2V3T1w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xym3RG+LdBa2imW8eNEWeYj+VCwE1dWg8JXJ4vM4Yr8=;
 b=NZIZrgzZnPP+rW724sAh0RrOtomv+wAAy4ajK2LaUNdbUPWnqJUh6oKAXGzp6hTczXq7rDxFZWVONoD6ZaETrH71QnfqtkWaFMxId3XTdyuncAVSD8Qk2/lIdht5qvJgq9/qD6JB9pw7FoAi6c6O2gLgKM+TD9KmIzM3lbEy5EAleoGxaY/t5qELqSPuaTX+tePRgNJ7Dk1JqcV+YcjGsB0IFHwypd5pz5/z4Um8KlYsIem69xmMx4o0idjA4EujO81B5ramYkKvS+NVtZ2QaZyQGGISE/t4j7EAaT3zvbv8Qkhc07rEZAa0ogrvAHW0t3MyEICdKK9LFG5BLOgfnw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xym3RG+LdBa2imW8eNEWeYj+VCwE1dWg8JXJ4vM4Yr8=;
 b=lSGFkMDd9tw7kjtBdsNTLgF9R6hGkpCM3B0U9u+c3MmTaxhKYlMNd0hZXwW3oyVne7ND2k3WnuSABSKAAuaXrmaJhd6kjziEdaYUPNbI9UwimgO8nI12nybjyOlO7YEwGWRc0KOhpFRt0UM0X+gnXgHF0old1nzMABUG0LT3OI0=
Received: from DU7P195CA0017.EURP195.PROD.OUTLOOK.COM (2603:10a6:10:54d::27)
 by PAVPR08MB8990.eurprd08.prod.outlook.com (2603:10a6:102:326::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Wed, 28 Jan
 2026 18:00:23 +0000
Received: from DU2PEPF00028D06.eurprd03.prod.outlook.com
 (2603:10a6:10:54d:cafe::56) by DU7P195CA0017.outlook.office365.com
 (2603:10a6:10:54d::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:00:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D06.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:00:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JlB6CWHAx1jB2FNebGJ/dzXXVPqU1VcEwI8rHc0e5AfudJeF8hcePiHKdSCZWCQ0I8UFHPA4YS3OU8PLVwBsMPI/OpdC745d1V6BXLJZ12BIF8qrM63ptD85QSXzxswCWikxVqweCeK8AJZgXNrtGJCdJbULbjJRqmBFpygJJXR+otMZ5ivHL9D9eYU7wXuOYyfV6Xxrcu8k5pvD60+cPynmf8wHQtiLeb8GVi7kGiBmFjZ3yuuaIa6O2tj3HUylHHG//lnkz9DBLL5UWJMUZJu0IwhDsYoA6I1+FkFtYmlZcJ4fLWeRbogF3IjZHht6cL4RlICTHPCMBAl2UnV43g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xym3RG+LdBa2imW8eNEWeYj+VCwE1dWg8JXJ4vM4Yr8=;
 b=rE0zImFbvkKBn0xHpD0Fo3VsAJ0Zhx6SJVqRyokJB0iLqgE+aqCOVYpiYBhqsmCi6HzSSRJUmb5HPfy6pudlj/5hKWMKv/nfFc2IC702CJWwsvY566gCK2nR5jee6BH+OLNH+YoUMpQCPO1wvG+wCBA8J5SMdQ3fu4eVZ+2hCcenieC1NlUlJGSlKjXiZaUQYusUZAzPaksBEcl7CfS72EvaiFTXSDLi4dyChwhEPBoUvhqnfEiV8sO/YenJUjvVjujl/4yh9nxH18oI54D5/tRULqdwJaN8WODZS6pcCEcPQo7n7speRd+vknkbw7FJMkB8lfPxdFbSsui55wr/XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xym3RG+LdBa2imW8eNEWeYj+VCwE1dWg8JXJ4vM4Yr8=;
 b=lSGFkMDd9tw7kjtBdsNTLgF9R6hGkpCM3B0U9u+c3MmTaxhKYlMNd0hZXwW3oyVne7ND2k3WnuSABSKAAuaXrmaJhd6kjziEdaYUPNbI9UwimgO8nI12nybjyOlO7YEwGWRc0KOhpFRt0UM0X+gnXgHF0old1nzMABUG0LT3OI0=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VI0PR08MB10537.eurprd08.prod.outlook.com (2603:10a6:800:204::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 17:59:20 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 17:59:19 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v4 00/36] KVM: arm64: Introduce vGIC-v5 with PPI support
Thread-Topic: [PATCH v4 00/36] KVM: arm64: Introduce vGIC-v5 with PPI support
Thread-Index: AQHckH/Tn53UvD5XVU+tILkCCV3efw==
Date: Wed, 28 Jan 2026 17:59:19 +0000
Message-ID: <20260128175919.3828384-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|VI0PR08MB10537:EE_|DU2PEPF00028D06:EE_|PAVPR08MB8990:EE_
X-MS-Office365-Filtering-Correlation-Id: 74219aaf-3d76-46b7-bbff-08de5e971b87
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?ZtLLx9+HGp11kWnm9Ajn5Zx3hlJzuVCMbanwEli72A0vIGeQ3yvtLZ/us2?=
 =?iso-8859-1?Q?w2TUFrewTLrxssWMeMLOlPIgT6UkNRKE4gXIMvg9PWzfa/QqrxV4I6kYjA?=
 =?iso-8859-1?Q?HcA5wGW1zAOkU/zLrAHu8tzeb634yL+lks+SsuNb7lSBl7E0wJu6eJOtXL?=
 =?iso-8859-1?Q?7xU7pz7HyAdugj3RTbq3FFEebK6+nUa9AbUf+Vq0I6d9+PVov8iGDZqZab?=
 =?iso-8859-1?Q?fGQgjSi5vkPBqOA8nUh7aGKmFxehLdNJcS7wh1/G72bI65pFK3oU4zuwrg?=
 =?iso-8859-1?Q?xGHYh85PgULiJaUsY7NvF1e4ucJkp5jGhoWzTIJdhjSxFGO7AyaWSoJXsM?=
 =?iso-8859-1?Q?jYQaeQnjsSHsQSBWNbroyPxQEsSP3gZIhs3jlln6azT0zBrfKRAdrNVxs6?=
 =?iso-8859-1?Q?ajN3YwTRghUaUfn3IVEzJG9dd15/5Ivg+vul7uxy/UxKWrMbjn0eiTA9uW?=
 =?iso-8859-1?Q?kQpR7s5eJRaC8nDM3dWB5Yfv4Qf95Sv2pcvKF7jdcyRqzvy+GmELUG8mm/?=
 =?iso-8859-1?Q?ddi6ZvK7cA9G1i3+J+DuwYcc4VTQ+Omh4q8xCtQ4VEBldEs7PG80KEktBO?=
 =?iso-8859-1?Q?tcCZ7mjhESkxbwSAj4lL2zA2WzkcQ77nO+Of8uCm1wj0uHExjw6yNA8Ntc?=
 =?iso-8859-1?Q?hu4jU4alqXxXDRD79Cvmct5tiNU2Psd+H+BAdtqWAwMAOOStJCf97NDIO0?=
 =?iso-8859-1?Q?wKqo9/1VU57rbUdsret5GnN4qNv6nXsknlLeiqO5WlnZ07rWAIsWZ1sxhE?=
 =?iso-8859-1?Q?LLM8SipZDlwZCQa7iorXlZ3ljo1iMefD3fN/gAwYt8TV/8FgLLVvE5Xn+/?=
 =?iso-8859-1?Q?1zQwNBak0PXZzag/9gcxx5Aqaev4DJsb6DAxUvblw24wbK0oGp4twtglyc?=
 =?iso-8859-1?Q?7A3WyD6TXTxGFYD+mg9dNtge55bqobOgyri6yox08Q5hCkTuwrOHbwX58z?=
 =?iso-8859-1?Q?JQYybMLkaT94ckv4MPqzm42bVGCUPfisEY/q8rPrkY4vfLKtX1qPBM3xbK?=
 =?iso-8859-1?Q?h1QVOk6MxZbTFRoHmE5mPXoZAwLTz8fRid8O4vY1kmKqMWsDzW9hDv9OZy?=
 =?iso-8859-1?Q?1mmllQm/QntkpcO7Z//BTq9DYG0zMNxaTzVepUu67CBW0/Nm/qwtdzxkVr?=
 =?iso-8859-1?Q?AiXVG6xuqfBGnFs+kq4DJgAm8PNhacisVQVe9KERVcImGBdEOzz+5sA0Ss?=
 =?iso-8859-1?Q?GTg1wb1qFl8Wp5xnl0igBacvEjX7XKF53vFXDK+xB5Dr6zt0zkYil4Mvcl?=
 =?iso-8859-1?Q?uxmDkIUSu/vIKQoJVH9l23/ZIIBVFN0GVlRneYcMZ9l35KCLcriivFO38D?=
 =?iso-8859-1?Q?T3Vvxw0KflGNyawBKZlpuViVGV7s88v0YW5cb0+ONI0MhH9xT0WudJi0kG?=
 =?iso-8859-1?Q?RlL+5/lAQBDD08WrMQj8gWbi0OmTn8mg+6hEZkvGlxWPeh2UX+LABbXJvW?=
 =?iso-8859-1?Q?NfT9zWQ7nXKqcUMnpLyyEc+cAZZtomi02UO06yB4u75HeN4eVv6HGp4Ed2?=
 =?iso-8859-1?Q?iBC4wudPAgImvo+j1hJBKZnQfY+jOMPnERwe8oluGmwlitjAjYyRbSgd/1?=
 =?iso-8859-1?Q?OR0TCdLaMDMgEM9mEjI10aBQoSxmPynMAKRCkO09o5lwVCL4pp2n+EGPVP?=
 =?iso-8859-1?Q?MwEvM4ks1abI1CG1iGh/cG4lDVwrEnUVXWcBQmBHJldknbMmuOZNCbdqFW?=
 =?iso-8859-1?Q?zI0lGhWqWZAqNyLBY089qPTg/BTNh+EeRNnRLoAk?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10537
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D06.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3f447194-1a4c-4543-8ff2-08de5e96f608
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|1800799024|36860700013|14060799003|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?Ld0aVe30mtYw0oHsYJQZP9MdA/b4MBdtR7DIOosJUhJHX5mq/3qHKxwldU?=
 =?iso-8859-1?Q?aD+Lpn0uhvVzvmmuqUgtzM0QgbzQImJgAGJzbo6IXEtQJ252bYV+yja5Gg?=
 =?iso-8859-1?Q?MENo8vS34Amk9rOY3H145kmUbg9I8RZ8xcP+0sij1OpmINNP+1JykRcaLg?=
 =?iso-8859-1?Q?Fz1SS1vesm75ReHU2Wk9Xdyf9pOhAqtwEJEq494sQFrSd+OCqXgFxiNyaO?=
 =?iso-8859-1?Q?TvUp98xVAtOfBGqDq73QdvYgBg/lVjhgVGf2pPbwlqKzab+QugBPCyQIgB?=
 =?iso-8859-1?Q?GufMe+vB+q8oADl8SJdMkbAUN4vc9BFDtxcKHGz+QY58XgzoKSWLT4j0/Y?=
 =?iso-8859-1?Q?NfMlbLtIo+qnNeow6WbTU3/xONyNekRMCfaUFZ+IZahcW2Ytu8KrGqbjC1?=
 =?iso-8859-1?Q?PUZkqVH16jzROwCngv40DSo523SJC7HNKgdrO19jPOEobni4xyWQDNErVh?=
 =?iso-8859-1?Q?XH4oio24khdzHhQ9qi0A7eJx+1Uz8bMfT/k+AFINAQuvDlU9rRq1XwXn/A?=
 =?iso-8859-1?Q?eOCskOQjh2ZUpaGs1NtCxK9ApC1gPTfAeuuMWjocxYCKuFPodAjS8c8/zy?=
 =?iso-8859-1?Q?rSjcXXQ3icu9gjWjGXsl200WHCjdiTOnfE5/rS878n8JRv5o76Mok+VVAs?=
 =?iso-8859-1?Q?hkLC9Wc0kZmN/deVHHC++Q9yQq2Dy3AKCbmpsf6FJeBqC1YYVoXaDAN4bc?=
 =?iso-8859-1?Q?Ly0KMsdtJh9Le2C8tLPZlyDKxi4yhXI7UlhYq4KZDg8zHYrpNIl0NoM1TZ?=
 =?iso-8859-1?Q?gdP1SJvy7/wcXPJCmOVuTXFdGkXiI39HstMPnkxoSRGzcgxA7mMHFRw5gG?=
 =?iso-8859-1?Q?PEJFrfsclSsMCzIKJZZ1NnlfExpgLrHdoYqz1ggOqbEh95Yx/v5LF+MKGF?=
 =?iso-8859-1?Q?iz8XBxjHuu71Rg3iKBy6/HjK7Cd9J4IvOgrqPuErOA8fImAYAkQy+HsWWs?=
 =?iso-8859-1?Q?kQJQoabYOVu4PNnBEoyfZ6/bUBo5e6D7uwIi9Gr4ADyX+jE6i2MeI6pUfN?=
 =?iso-8859-1?Q?jMiNe1/eWFMpXlwcw3CmTFmh6/GjAXSoxRrCdES8JlibJMxxAmHBcJjosa?=
 =?iso-8859-1?Q?kl5vDRka2RWGp6Y+fpZe/p2Tmy2HceSyw2Ll+gmpNPdn9TjjTmUDRu1lFO?=
 =?iso-8859-1?Q?1zXXsROvb4yIoHC5tCZpkCbMt9XfoOYiMITfJbcbCkZPowvD5Ap9FXYZFU?=
 =?iso-8859-1?Q?M+x/GMziHemPxV1eIxLp+48VeAQJcqpJ1qvQmiB+BP6X7+IQ7lI9bl7zE3?=
 =?iso-8859-1?Q?xjCOfOxykRhYpcHsxyhUrXDFW8tuf/ltFBRbNnIDoDmopTExWiEORdNkck?=
 =?iso-8859-1?Q?P7UvlCInkdKrAr5XzpPqclwlPeB3Tv1T9KfsfZ7+1YSrPhOBlHBufbgSst?=
 =?iso-8859-1?Q?UdF+QSHfc7IzZFhbl7V1Oot+a5QiIJGY4negpC2PbxyV/oyKllMbzhO3w9?=
 =?iso-8859-1?Q?zUm8b29mM6bm4lNq8IyJdKoh2hB9H75jVt/ztaM9YDQ9MkdpeBBPIX9N9P?=
 =?iso-8859-1?Q?IL0T9B4zvvMbv/KH/21CqJJofROY02ssh1r7G8iChvh2sP04U164ExrMY4?=
 =?iso-8859-1?Q?rJtaBuBXV+1eIFxF5Wo/92yER3OmXly/IVY1zi62KIuYBBKb7yFJZVxwkP?=
 =?iso-8859-1?Q?+Ip1Z7QnqXrjdmR1Mog7PeCmWgKrBFhuQ5EcsmipM4Z5PkDSArZGlnznOj?=
 =?iso-8859-1?Q?WZ5NOqJu9DUxyBYz2t5NHFqJr4YwyFWeO96fCnW3ubRRKKuVSMuJ+EE/4y?=
 =?iso-8859-1?Q?3Eb8VkMmSQli65NB4yTp5xc7k=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(1800799024)(36860700013)(14060799003)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:00:22.7069
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74219aaf-3d76-46b7-bbff-08de5e971b87
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D06.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB8990
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69366-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,arm.com:dkim,arm.com:url,arm.com:mid];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 3A040A767A
X-Rspamd-Action: no action

This is the v4 of the patch series to add the virtual GICv5 [1] device
(vgic_v5). Only PPIs are supported by this initial series, and the
vgic_v5 implementation is restricted to the CPU interface,
only. Further patch series are to follow in due course, and will add
support for SPIs, LPIs, the GICv5 IRS, and the GICv5 ITS.

v1, v2, and v3 of this series can be found at [2], [3], [4], respectively.

Main changes since v3:

* Re-worked the impl PPI detection to limit it to those KVM can use
  (Timers, PMU, SW_PPI). Timers and SW_PPI are always present, and
  PMUIRQ is if the host has a PMUv3.
* Moved to calculating the PPI Pending state on guest entry to avoid
  potential races with userspace PPI injection. This is much less
  expensive now that we limit the subset of PPIs exposed to the guest.
* Added Reviewed-by tags

The following is still outstanding:

* Allow for sparse PPI state storage (e.g., xarrays). Given that most
  of the 128 potential PPIs will never be used with a guest, it is
  extremely wasteful to allocate storage for them.

These changes are based on v6.19-rc7. As before, the first commit has
been cherry-picked from Marc's VTCR sanitisation series [5].

Thanks all for the feedback!

Sascha

[1] https://developer.arm.com/documentation/aes0070/latest
[2] https://lore.kernel.org/all/20251212152215.675767-1-sascha.bischoff@arm=
.com/
[3] https://lore.kernel.org/all/20251219155222.1383109-1-sascha.bischoff@ar=
m.com/
[4] https://lore.kernel.org/all/20260109170400.1585048-1-sascha.bischoff@ar=
m.com/
[5] https://lore.kernel.org/all/20251210173024.561160-1-maz@kernel.org/

Marc Zyngier (1):
  KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP() and co

Sascha Bischoff (35):
  KVM: arm64: gic-v3: Switch vGIC-v3 to use generated ICH_VMCR_EL2
  arm64/sysreg: Drop ICH_HFGRTR_EL2.ICC_HAPR_EL1 and make RES1
  arm64/sysreg: Add remaining GICv5 ICC_ & ICH_ sysregs for KVM support
  arm64/sysreg: Add GICR CDNMIA encoding
  KVM: arm64: gic: Set vgic_model before initing private IRQs
  KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to KVM headers
  KVM: arm64: gic: Introduce interrupt type helpers
  KVM: arm64: gic-v5: Add Arm copyright header
  KVM: arm64: gic-v5: Detect implemented PPIs on boot
  KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE
  KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
  KVM: arm64: gic-v5: Add emulation for ICC_IAFFIDR_EL1 accesses
  KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp interface
  KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore
  KVM: arm64: gic-v5: Implement direct injection of PPIs
  KVM: arm64: gic-v5: Finalize GICv5 PPIs and generate mask
  KVM: arm64: gic: Introduce queue_irq_unlock to irq_ops
  KVM: arm64: gic-v5: Implement PPI interrupt injection
  KVM: arm64: gic-v5: Init Private IRQs (PPIs) for GICv5
  KVM: arm64: gic-v5: Check for pending PPIs
  KVM: arm64: gic-v5: Trap and mask guest ICC_PPI_ENABLERx_EL1 writes
  KVM: arm64: gic-v5: Support GICv5 interrupts with KVM_IRQ_LINE
  KVM: arm64: gic-v5: Create and initialise vgic_v5
  KVM: arm64: gic-v5: Reset vcpu state
  KVM: arm64: gic-v5: Bump arch timer for GICv5
  KVM: arm64: gic-v5: Mandate architected PPI for PMU emulation on GICv5
  KVM: arm64: gic: Hide GICv5 for protected guests
  KVM: arm64: gic-v5: Hide FEAT_GCIE from NV GICv5 guests
  KVM: arm64: gic-v5: Introduce kvm_arm_vgic_v5_ops and register them
  KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on boot
  irqchip/gic-v5: Check if impl is virt capable
  KVM: arm64: gic-v5: Probe for GICv5 device
  Documentation: KVM: Introduce documentation for VGICv5
  KVM: arm64: selftests: Introduce a minimal GICv5 PPI selftest
  KVM: arm64: gic-v5: Communicate userspace-driveable PPIs via a UAPI

 Documentation/virt/kvm/api.rst                |   6 +-
 .../virt/kvm/devices/arm-vgic-v5.rst          |  50 ++
 Documentation/virt/kvm/devices/index.rst      |   1 +
 Documentation/virt/kvm/devices/vcpu.rst       |   5 +-
 arch/arm64/include/asm/el2_setup.h            |   3 +-
 arch/arm64/include/asm/kvm_asm.h              |   4 +
 arch/arm64/include/asm/kvm_host.h             |  35 ++
 arch/arm64/include/asm/kvm_hyp.h              |   9 +
 arch/arm64/include/asm/sysreg.h               |  28 +-
 arch/arm64/include/asm/vncr_mapping.h         |   3 +
 arch/arm64/include/uapi/asm/kvm.h             |   1 +
 arch/arm64/kvm/arch_timer.c                   | 118 +++-
 arch/arm64/kvm/arm.c                          |  40 +-
 arch/arm64/kvm/config.c                       | 147 ++++-
 arch/arm64/kvm/emulate-nested.c               | 123 +++-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  27 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  32 +
 arch/arm64/kvm/hyp/nvhe/switch.c              |  15 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |   8 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |  69 +--
 arch/arm64/kvm/hyp/vgic-v5-sr.c               | 120 ++++
 arch/arm64/kvm/hyp/vhe/Makefile               |   2 +-
 arch/arm64/kvm/nested.c                       |   5 +
 arch/arm64/kvm/pmu-emul.c                     |  20 +-
 arch/arm64/kvm/sys_regs.c                     | 100 +++-
 arch/arm64/kvm/vgic/vgic-init.c               | 128 ++--
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 100 +++-
 arch/arm64/kvm/vgic/vgic-mmio.c               |  28 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c          |   8 +-
 arch/arm64/kvm/vgic/vgic-v3.c                 |  48 +-
 arch/arm64/kvm/vgic/vgic-v5.c                 | 552 +++++++++++++++++-
 arch/arm64/kvm/vgic/vgic.c                    | 106 +++-
 arch/arm64/kvm/vgic/vgic.h                    |  48 +-
 arch/arm64/tools/sysreg                       | 482 ++++++++++++++-
 drivers/irqchip/irq-gic-v5-irs.c              |   4 +
 drivers/irqchip/irq-gic-v5.c                  |  10 +
 include/kvm/arm_arch_timer.h                  |  11 +-
 include/kvm/arm_pmu.h                         |   5 +-
 include/kvm/arm_vgic.h                        | 142 ++++-
 include/linux/irqchip/arm-gic-v5.h            |  39 ++
 include/linux/kvm_host.h                      |   1 +
 include/uapi/linux/kvm.h                      |   2 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |   1 +
 tools/include/uapi/linux/kvm.h                |   2 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 220 +++++++
 .../selftests/kvm/include/arm64/gic_v5.h      | 148 +++++
 48 files changed, 2774 insertions(+), 285 deletions(-)
 create mode 100644 Documentation/virt/kvm/devices/arm-vgic-v5.rst
 create mode 100644 arch/arm64/kvm/hyp/vgic-v5-sr.c
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_v5.c
 create mode 100644 tools/testing/selftests/kvm/include/arm64/gic_v5.h

--=20
2.34.1

