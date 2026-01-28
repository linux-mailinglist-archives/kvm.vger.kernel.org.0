Return-Path: <kvm+bounces-69382-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YGTIEzNQemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69382-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:06:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C7F1CA776E
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:06:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C2E98305F3E0
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B4C934F468;
	Wed, 28 Jan 2026 18:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Bu1Yrpeu";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Bu1Yrpeu"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011062.outbound.protection.outlook.com [40.107.130.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B788230DD03
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.62
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623481; cv=fail; b=AHtEJubmKM518Ichc20uCwaQrVs66FcoZ7Z4sm0+WTT1mPjOFnrQgz2BFZpTO1MrQT0y1L7U2tvWuEAtcodlJOTLbC0a/ICsF1r37xVYB4PeYnu83xIBgRDf94Pu7ve/XdxXtInPBHC11mPu5nX6k/13PG5TMDUS6lqNgp5C83k=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623481; c=relaxed/simple;
	bh=6MrEuYlaZkd0JtF+uhLqxlOwSsY2XGhj2hMWWWDwMT0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u1KEulnq3E5wqFSOKbsHeiHjsyfVGWJVRLJ5pvyO6g6l04SMcal+A4zTxn4XkJ9RACeJqTamFUt4foQSdQFoWg0IK4ypdtmbu+yAUdaqJNl+luDkd5YKX8FnEJYqFm6xztOexfVbYNDSbtm4jpJvihvdWGpCLPkCAnJXlk1KGfI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Bu1Yrpeu; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Bu1Yrpeu; arc=fail smtp.client-ip=40.107.130.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=MHSpKfDq9EleTNI6tX0gI0TeB8nom6ZdOCVakzWELYjYCax3XaYJIIsUPruT/SvYVNBUlnlwuhkP47DQNgQdi0nUgTzKMIGBVG/3B3K4bPi9UWc1/nWlvjFVm/5501GqkqXbTMKimfMVk+iRaYR4WDsnaR/SMNSJSF+rJA1ODEyFDpJeULG3tbsPwJO+LzYudIgyHnn4E+3TnyLWH3bXYpQWcY/D6+BIrQwRTT6WXXkJ9Vc9a2tpPSsFZHZ5as2Bg7kRLL3HR49p8oDJRWY7BdnLE0dnQWA1tqT4cDQIVruOrRIzG29OhKRJOKVlxquh/MCVuB0caykmWfJda2g6qw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lFoc3Z6uPB0JiC2q/v8IJQPJM/H1uwXFMSc1VQ4PLvo=;
 b=H+8a0iwHYl7YA2r00JlaQpo9BOc8wapIJtI08nvwhGJmM/8dbj1oeivI7Q4HD6oPKzL/2SNUSYzT3Z7tZWvPLlVTc30lHW2dBcsKZP9r4tL0oG3ly1TZfOJFO46c9aMtiLYFNqWpS6ijM/UuneytVldhzqA5GzzB55K9Vr4ulJ2zsgcSkfB+TlD/XWsyA5SPK+YwBbxE/K1ls61/ojtJEgSV7Ql7fmqw4F0gMZ2SdB7TEF8eu4AxRs18Tcz3p0GJI1twNUzEus1xkxxyGdDnfeQdzqMDDJ180fQ2POyNjsAPbkJOqxBNUWEdw0Xqmd/Pa6IjHCobLAV7mn97spcxlw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lFoc3Z6uPB0JiC2q/v8IJQPJM/H1uwXFMSc1VQ4PLvo=;
 b=Bu1Yrpeu6/+AUsp+AGTeeHx9kkP0BIW3QaxV1IKeRTK9F+5B/vtL9mE9KwV2Ka5dn9ks+tVFo3o0mW/dfT8WEoA2dfgTeoNdTz8ceEuhg86YTl2fnXyDeHdfRtDYweOvvRtgjIXG/ASzvlfccsHk0fhEnuvVKNEdyS2wND4pLpE=
Received: from AS4P192CA0027.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:5e1::17)
 by AMDPR08MB11458.eurprd08.prod.outlook.com (2603:10a6:20b:717::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 18:04:29 +0000
Received: from AM2PEPF0001C716.eurprd05.prod.outlook.com
 (2603:10a6:20b:5e1:cafe::4f) by AS4P192CA0027.outlook.office365.com
 (2603:10a6:20b:5e1::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.9 via Frontend Transport; Wed,
 28 Jan 2026 18:04:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C716.mail.protection.outlook.com (10.167.16.186) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:04:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=leDdYCKVeN/0la+Gd+WWJhubLdL4Qs5cdoQ4TGgRn9Anck3qQ+FiGhB1/gWUOKcYlhoK46Xu9DE0Q25VNVYbjG9neaIUVh9k8p5V5O3VcyDpgbFtV0d7zISbxPwawDFLW6UhIhM2UaaaQFT9gzMR7Uw6z46APxnZP4bM523pEvpHh46IGbdT7gLpdvlostQ18M2ckwIlU9N3PjvGEAhcZKXUP8wxYk3K37D2idZbSJ0gvu4Y3LPhfHsGBLKUzMNbl4dVzJsRKQcMZClaIrvUNB/3dNX7PiNZJI+nGWUXldLWfIg8jg5zMnXkPnmLIznY/ZP55HOscx90ZX3RTcroJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lFoc3Z6uPB0JiC2q/v8IJQPJM/H1uwXFMSc1VQ4PLvo=;
 b=aYRxzEAx/k4OTyF1mvigGEsQ/LAvOGyAT6aLLK6HbvNEOXdWLjvVNao8wmYm85W3LTbsM5NrGGFnWsCyH82NFJ8E0Dqx/0wy0+UWXLcwdWIzrHWPoolq/9LaCi1CEJmqwDTuvPsfDSd+ql5xwMttuDiJNPKNpoM/MLdjCtIqnNj6gRtR7Y6UYw2KUVWVKnjJDMdXDex7ubka3PD0OZA3yRrioxPqw0+RwSPVvRZ33bikAMjM1qBA7roqU35o8Q0xhKKA0a43eAbxNUxtVGMu1qc+9+AVxP2OPdIf4WEW6uT+bTARSMGIQVJq/fTIfQLLwMNR5Ye/GjVtqcvX+3LzQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lFoc3Z6uPB0JiC2q/v8IJQPJM/H1uwXFMSc1VQ4PLvo=;
 b=Bu1Yrpeu6/+AUsp+AGTeeHx9kkP0BIW3QaxV1IKeRTK9F+5B/vtL9mE9KwV2Ka5dn9ks+tVFo3o0mW/dfT8WEoA2dfgTeoNdTz8ceEuhg86YTl2fnXyDeHdfRtDYweOvvRtgjIXG/ASzvlfccsHk0fhEnuvVKNEdyS2wND4pLpE=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Wed, 28 Jan
 2026 18:03:27 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:03:26 +0000
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
Subject: [PATCH v4 16/36] KVM: arm64: gic-v5: Implement direct injection of
 PPIs
Thread-Topic: [PATCH v4 16/36] KVM: arm64: gic-v5: Implement direct injection
 of PPIs
Thread-Index: AQHckIBmYZNzEkM/IE2UHW0s2cWF8g==
Date: Wed, 28 Jan 2026 18:03:26 +0000
Message-ID: <20260128175919.3828384-17-sascha.bischoff@arm.com>
References: <20260128175919.3828384-1-sascha.bischoff@arm.com>
In-Reply-To: <20260128175919.3828384-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|DB9PR08MB8483:EE_|AM2PEPF0001C716:EE_|AMDPR08MB11458:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a8edb35-3817-42c3-602f-08de5e97ae9f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?DJY4bLf51FmjJTLldIXzUfioemem37WeSr+kjvFgz5Ui/VujbzJGeMVtDl?=
 =?iso-8859-1?Q?t146LXXAvtbJxh3Rp8/zS7MVE412lnMNvpyikwv/sam4UcZ5aZYrVWSA4H?=
 =?iso-8859-1?Q?4Psb6kiHMz/HRSKsi9hkILbPbQPuRFjtLamcd1SUlSe/yCcGo1nSRYmZoE?=
 =?iso-8859-1?Q?EP1odLXCUIAmfKY/3YvpemLhGgM+npsJw5Xp77FmQF08s+TPaCnBmnzwR9?=
 =?iso-8859-1?Q?0uFj7S12galUN9fKXmt9vNA2i0erFW3P329Kle1lmPI49QdABhOLycQcrY?=
 =?iso-8859-1?Q?C8zeyCrsKogeiVsg8eDKM06+VH1pLVwAE9PFmcw65DsTMTtTekNqURILev?=
 =?iso-8859-1?Q?Yejbu66hZqzXOJvfQmJJBmYkg4iLUPWJODK/0cVYbUzbuMrcR2FeOSc6h/?=
 =?iso-8859-1?Q?pqQ2/6F7Wet43eShLJ6n9xrdrMPPcX4TyWKZje07jyYZMf1vzJDvFlEqv4?=
 =?iso-8859-1?Q?ng+u/0FAb/JJ+e+56YN0wcXAABDiedfjFmopbeikAv65r8x7fJkVmK0ALe?=
 =?iso-8859-1?Q?7MLaoW37IlXYbUzWpeQqBNyQvbauJu3oJP8eRKhcRnuln1xlAZmT9EJAeB?=
 =?iso-8859-1?Q?tqcayHndzMw/xxo6Khdx+zez/NX3QKEa+qG9hsXpVxSH3tAE14ynbZ8gXF?=
 =?iso-8859-1?Q?vYLsuTOWVeKBEwgjTFInP45VUdKYlofAsd22kDDifYtijVfmB4m+pvGUOs?=
 =?iso-8859-1?Q?Ojge7ACj4kvL2WrZ5Q+j3PDyrEPd4XAnLVVXGucoPfMnWH4GYuj4owKc65?=
 =?iso-8859-1?Q?u+s+YTaCMF3N/pa833HpWdxqNvP/f3Vbb4J4MxwJMS/oqtxGdAsMkdmKZJ?=
 =?iso-8859-1?Q?J+abNQIU27s3FMNWuQBF32wc6jdwtlL0My8NiggR1iIH5duQpVkiqqHeBS?=
 =?iso-8859-1?Q?DTffmkhQEg1FJvUj9QygCeEpF993sMBX5VoV0XDyxwodknEVBUIXIpyCpW?=
 =?iso-8859-1?Q?tBPWkiaHm5g5CN0JSr9Azd2Uy/ixtVLbm66IT/3Nr+LL7XTzbIxXsXIRO6?=
 =?iso-8859-1?Q?J8aIMBzC6jrNX3owfvn7X9PHlB+o2RHV2yIfGQ47CVzQ8TTy+DDgUdaNfC?=
 =?iso-8859-1?Q?v4hqohPr14m2MGf4FP2jZw96zJXTi8u3OP9TYuZzp8E+NV5kgF4+GrTKQH?=
 =?iso-8859-1?Q?1MMzBm0W4xruUDtn0eKIrUuWqS8DwJExfiCLOO0SeZlCuMczF5FcS2smq/?=
 =?iso-8859-1?Q?/Ytfua4bWiHVp0vTI15XMohcVfo1fAGUPDQIqFtZJ6n1v9Ujtwh8mdECF+?=
 =?iso-8859-1?Q?cA1GZinzd1Kjo4sAP2wFylsGlpc/ravqfyLsfR2+4dr4rRus83NJMXH57b?=
 =?iso-8859-1?Q?IogPvryXIh3e8ckb8T+D/PSc69K/U4JvZUQ1mRI07mgBl6pVT3oJfYyFOs?=
 =?iso-8859-1?Q?GoKYJ8cFE3YeRaqmD2uDmuLU9nQD+SpHY5UzooLdaka6xNrMxRALlxrn5+?=
 =?iso-8859-1?Q?O0ozAk6kplSfe7HpybzOZfkTo2lx1ohW0Av042+Xip4Sjin9kYWk1lflY3?=
 =?iso-8859-1?Q?2NHVuKU789KxwPtsG6IK4VfOylZfhcXlqLT0H1Woflu0lm5Ipd78fkTKG4?=
 =?iso-8859-1?Q?CKqpVpcncbaUPZlrPDP5MqyjbqQCYmsgabkJUp8fHubP0ftMmwTxfP9FFf?=
 =?iso-8859-1?Q?IsjOEq6kNRt2WX+0HHhBlv4PW38Ss4f7+Hcgxqk/+EQcx82RbwPdllV7Ep?=
 =?iso-8859-1?Q?hS0h9DwRQgyHRyAFo3M=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8483
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C716.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	48cc977d-0d8a-4349-7406-08de5e978930
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|14060799003|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?Zs7UH2NPxZj67UEiWvipkrTEJHSn29ehlwqik2KA3yLCmUNs1EfOEy77Os?=
 =?iso-8859-1?Q?TKUeZ6OOaQ6fquoHH8PaqotPdbNvgmoCq5rs51ashiWDQ/qxk+IWEw0sWh?=
 =?iso-8859-1?Q?sunJUh0xFJX4EGof1DB6E/aO/CtzKjHpFY0gLDEzrQ+l13akBsmlwhPSog?=
 =?iso-8859-1?Q?aqJFAjVRs4VQduF290Y0RDa8qhSONoeBQ98I4T94NIc1y4JVBQ4JYSYkV0?=
 =?iso-8859-1?Q?qxDz+Psg0vPFVIeEZ94pCSJ5Mgw0uFyUa7NedXY3BU/q2RC1oPGYHtZE+j?=
 =?iso-8859-1?Q?SNTHmepnbvNJaYO3KvWOYgN8gtkNZUoB/Re2iGp/8HCbkAkwx0TCWwRf54?=
 =?iso-8859-1?Q?8JhoZLOhaDfsGztK21CXHh5UNYGu0kaOioLn3vIVjssVruYsoIgKWuG28W?=
 =?iso-8859-1?Q?IX+8qEkmLX+WFzuVDT3z9HaVYRKd+3BvTZk7Q241vX5p8lFQAVRWi3+Adq?=
 =?iso-8859-1?Q?uDACO3Ioa3vjsNhmFy7TqaE3WxLTbv72mbk5yv8Ppd8tUDIu0BiqRyiUzm?=
 =?iso-8859-1?Q?Kj2C1bm+XYdfm7pOUAnDh1rNJIbaETyf0fx/soyV4R77bgZrm8PIJFXNPx?=
 =?iso-8859-1?Q?bGtJTG/4s4ykr6dWbM1tPpteNAOLaUWGxUWljF75g3RxUnbwh3jAKpK8nb?=
 =?iso-8859-1?Q?EXnRx6dJZxTp7UyNxC420RyUlRDymN2Y39vgm2bPAoz4Mp1y/YPLDMfQj9?=
 =?iso-8859-1?Q?ROg4ooe+UTFhemSU3+busUlpM3whuh52IaWqzkXRQUXwTS9cC/CmTbSxi0?=
 =?iso-8859-1?Q?0GUF6RMvrLYw7b56csqXH14Dbg+vQdfNzHl5Hk/WEEnglxxmchYfGqcjmf?=
 =?iso-8859-1?Q?ymzX6+gt4kvxiZVQrEX1F1LETbLRGdL8p2c/ibgw/Uls3/x3x+vfoc5BKz?=
 =?iso-8859-1?Q?r/dTdr5SeayT3pWmVAssNaZPiHMezLg9MH2PKr/nBpWQAZ1Jis5emafG4Q?=
 =?iso-8859-1?Q?z46qx3w1Aqs4kH5oSbBY69g4a2rUzykV+7i2tDAJ88dPlplfkj1tHc9GqF?=
 =?iso-8859-1?Q?ASO2o26N8IFmnYiKUztJUzn6FHlPqJF3CuuSvG3KU5XLsEt+POx9R+aS6p?=
 =?iso-8859-1?Q?eFNJGpfXScqQm1oISULFxcf2FS1eA5lBL8vyHeKtZnk//al0Zce/slA1G4?=
 =?iso-8859-1?Q?sWiYOec3HkBFRcYqYRmhe88P0lDuxF0aMGWvyaB4f/t7RvwDknL0NGOUMX?=
 =?iso-8859-1?Q?NTj/mdK2UR+E1HXNRddacLesWct2LQgXDQQLu3aG8qiyLbFWdoxe3etW70?=
 =?iso-8859-1?Q?4iAF6eNmRPyTaP1EDQx24SvI5QufJPgtcbUETIvJ8C5SKAqXacEgZ/myqJ?=
 =?iso-8859-1?Q?YUymAyaNZGbk6+lyguJa//NABtMflkh1pk0JclO80ynWNUwZh0J6ZTO/n0?=
 =?iso-8859-1?Q?0fCzInXGjxGNC8RV28i9sCkZDYTxIDIzpfnBAZxnF610PjAQaVCqFphQz/?=
 =?iso-8859-1?Q?ktzka6kLv1M/NBQJXX81Q0Z5dLRm+MFpXauEUVC9S1vHEwk9jdPrNbdvZD?=
 =?iso-8859-1?Q?ReMgfPfTRHRBmxMVQjZIth9fqk6rqTjsKpW0taV5y6A8l1wLdpsU70mPB8?=
 =?iso-8859-1?Q?2HUK2lqkdCdMlH1aGRdfL0gUvJIVoMe7MXOBAGXgNKusU3+iGXVMIjL63X?=
 =?iso-8859-1?Q?Fhvy9pPK4lgfxDIICb+nIIldKtB9Sv1S8YdSePvVBHZzGcWzzIR7nqqFlD?=
 =?iso-8859-1?Q?wObi7hYeeQl9erP5drp7h3dG3DKegwdFbdH9TxSLFOnDE5cfx/YbhiDs7t?=
 =?iso-8859-1?Q?UmHQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(14060799003)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:04:29.4905
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a8edb35-3817-42c3-602f-08de5e97ae9f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C716.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMDPR08MB11458
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69382-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:email,arm.com:dkim,arm.com:mid,huawei.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: C7F1CA776E
X-Rspamd-Action: no action

GICv5 is able to directly inject PPI pending state into a guest using
a mechanism called DVI whereby the pending bit for a paticular PPI is
driven directly by the physically-connected hardware. This mechanism
itself doesn't allow for any ID translation, so the host interrupt is
directly mapped into a guest with the same interrupt ID.

When mapping a virtual interrupt to a physical interrupt via
kvm_vgic_map_irq for a GICv5 guest, check if the interrupt itself is a
PPI or not. If it is, and the host's interrupt ID matches that used
for the guest DVI is enabled, and the interrupt itself is marked as
directly_injected.

When the interrupt is unmapped again, this process is reversed, and
DVI is disabled for the interrupt again.

Note: the expectation is that a directly injected PPI is disabled on
the host while the guest state is loaded. The reason is that although
DVI is enabled to drive the guest's pending state directly, the host
pending state also remains driven. In order to avoid the same PPI
firing on both the host and the guest, the host's interrupt must be
disabled (masked). This is left up to the code that owns the device
generating the PPI as this needs to be handled on a per-VM basis. One
VM might use DVI, while another might not, in which case the physical
PPI should be enabled for the latter.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 15 +++++++++++++++
 arch/arm64/kvm/vgic/vgic.c    | 10 ++++++++++
 arch/arm64/kvm/vgic/vgic.h    |  1 +
 include/kvm/arm_vgic.h        |  1 +
 4 files changed, 27 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index f9f64cc0b58e..4c34ac6743d1 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -87,6 +87,21 @@ void vgic_v5_get_implemented_ppis(void)
 		ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_PMUIRQ);
 }
=20
+/*
+ * Sets/clears the corresponding bit in the ICH_PPI_DVIR register.
+ */
+int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u32 ppi =3D FIELD_GET(GICV5_HWIRQ_ID, irq);
+	unsigned long *p;
+
+	p =3D (unsigned long *)&cpu_if->vgic_ppi_dvir[ppi / 64];
+	__assign_bit(ppi % 64, p, dvi);
+
+	return 0;
+}
+
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 1005ff5f3623..62e58fdf611d 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -577,12 +577,22 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, st=
ruct vgic_irq *irq,
 	irq->host_irq =3D host_irq;
 	irq->hwintid =3D data->hwirq;
 	irq->ops =3D ops;
+
+	if (vgic_is_v5(vcpu->kvm) &&
+	    __irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid))
+		irq->directly_injected =3D !vgic_v5_set_ppi_dvi(vcpu, irq->hwintid,
+							      true);
+
 	return 0;
 }
=20
 /* @irq->irq_lock must be held */
 static inline void kvm_vgic_unmap_irq(struct vgic_irq *irq)
 {
+	if (irq->directly_injected && vgic_is_v5(irq->target_vcpu->kvm))
+		WARN_ON(vgic_v5_set_ppi_dvi(irq->target_vcpu, irq->hwintid, false));
+
+	irq->directly_injected =3D false;
 	irq->hw =3D false;
 	irq->hwintid =3D 0;
 	irq->ops =3D NULL;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 9905317c9d49..d5d9264f0a1e 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -364,6 +364,7 @@ void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_get_implemented_ppis(void);
+int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
 void vgic_v5_put(struct kvm_vcpu *vcpu);
 void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 8dfbaf6fb6a9..4234bc686f4e 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -219,6 +219,7 @@ struct vgic_irq {
 	bool enabled:1;
 	bool active:1;
 	bool hw:1;			/* Tied to HW IRQ */
+	bool directly_injected:1;	/* A directly injected HW IRQ */
 	bool on_lr:1;			/* Present in a CPU LR */
 	refcount_t refcount;		/* Used for LPIs */
 	u32 hwintid;			/* HW INTID number */
--=20
2.34.1

