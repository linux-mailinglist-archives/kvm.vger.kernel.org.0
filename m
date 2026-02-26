Return-Path: <kvm+bounces-72035-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +CBsESJ7oGkakQQAu9opvQ
	(envelope-from <kvm+bounces-72035-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:56:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B8DE31AB61C
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:56:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2D6E0331D37C
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4256947798B;
	Thu, 26 Feb 2026 16:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H7zAnFFo";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H7zAnFFo"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011070.outbound.protection.outlook.com [40.107.130.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EF346AEF8
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.70
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121652; cv=fail; b=gH+R+8FjG1JNByM07jByBI4X6MiD76MMqzsHf85luzUDU0shCqibEyxT8gknTxzY9JsyF4iyd0ovUpo4r32mWdspaaltbieo4adFDafJNDliNDJ44Lvk4CgpRUnizGy9HuxblXiwx+c3A5zIjsqgu88F63q7NkZAP1uLFR2/ev0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121652; c=relaxed/simple;
	bh=q0+XjFPJOsDNsJBn0a1WDd7rGCWiu5keUaOEpkABJtA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SmXyciK+O/plg2wcPahKUU0GMS4w4e54QY4YADIGAHWl/tOEc9FTLEVBfy8hWFu7GkRNJXCFgh+U4bnSb+aZPAMVbWuYrIT5e3wtwXo4MuyC2bpEga8+0+26mmViGxn3GgSX2Vw3FHTcI4hLkHmKbCIiZyWQZptDijNvtAfA9Gc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H7zAnFFo; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H7zAnFFo; arc=fail smtp.client-ip=40.107.130.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=EHfu0GbKcfdpLY5XSfHvctu99QYCUgykO9O9pK41V/VCeh6HLRoRjWDPWqO8zY0YIvK5rhjhOiv7qIBo24ug/iCU/pTJg8BdOXFxYTZiPYLfDnUsWGsIKBU5XRr7d5UgjD3Zfsp1z2zCORQluq4V9BRrCiBaDHWqMZEc+5dv+iWGEMt4emDAWLut+KOlCp/LdM2OjzRfzGZl7cGY5VXiqMg7sw+DzexlJuJlseeoOosuxxr4WYO3ckrmkmpM9c3M0EkB/WQdMnb7Upaw5MKNebrkSvosXMM5Y3gJ7t7y0jfGgLo4ogGTaJo/4I0/Xv1a++jExW0OND32z2pDb0V1Tw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rc0dXXcjTKa1+6C8g45B4YLXy/pILO0mIDWTBrAMdnc=;
 b=i/dHRDkt/culAKpDJJzo/MfdmzWYpjzqNNGVzRhkBGB5Zz31knN/jh1MR12Cvytp52q9EuG7XLw3klMMpq09E641KZPTNTUvpdRwggnTk/4SBaPTn195k1tijZWstbCuFGUCD05lskhoR5iUifxjFwkzJ/7OUgyz0Ojg+z7xoA4oM7HJGCNJ1I28S+pmpYv202OTzs8wmHMGeq9DIGWbJf1p2JPRfJ5fpiU+6dECjAHn5Akk2aHhO9rhxxKl6zoNO8MMboGcomdhy3K1dkGAxynLeVPUTfwa8HqpV6Jx9T7RRPCWu4ct7gpmKQoC0NagYvp+VK8fmzaG/JSnW74O1w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rc0dXXcjTKa1+6C8g45B4YLXy/pILO0mIDWTBrAMdnc=;
 b=H7zAnFFonaSi7jXdWySK+8868R8qvJjPmymP47L9pD9jARw96HkgKqERWz2/t7CqKOriMSJ0OeBsnoKt4QxLGkCGE9X+yQNpnb7AareTQy4Ey2bt7GKZ6cl1FX21Wg5qJl5Hv1jEiYfWvAL9iPehDvX3zGG8OZ/wa5JX50nMgPk=
Received: from DU2PR04CA0187.eurprd04.prod.outlook.com (2603:10a6:10:28d::12)
 by VI0PR08MB11824.eurprd08.prod.outlook.com (2603:10a6:800:325::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 16:00:36 +0000
Received: from DB5PEPF00014B8A.eurprd02.prod.outlook.com
 (2603:10a6:10:28d:cafe::b2) by DU2PR04CA0187.outlook.office365.com
 (2603:10a6:10:28d::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 16:00:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8A.mail.protection.outlook.com (10.167.8.198) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 16:00:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C7oOsHqnKMaTCOooD9dA9pQxAhBxbLlIPvfxCuh5PCA5/HYU856vz1oHI8Nwc3YiTXKuAWuA6Axy7/uFUOEJUU+J53zbkL3dIEF0aKDUgO++5IEC0RXwM7KAXuz2xlMoPhEn9jhXdtVjXOhgTUfwTCgTE/YAhW+yfza76KoSIAtGL98KmUnJ48JtxuABJiF+Qm0sM3XXmm5S2vazPXa8PyrqmJ6s9Xo6OkjithO8fPxlMPiV3rsqbtC2fXwYH0qB5FX6EQzcdWGguCFPLz7a+rUIe9vD1dvJLUjod5gXrcsDsrN8kkYG1ZWadrFSEOEyU+RvF0wcTtdtDuM2f5BLTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rc0dXXcjTKa1+6C8g45B4YLXy/pILO0mIDWTBrAMdnc=;
 b=LbkMToCyHMGzRSCLZfDSleWG810vxaaxeh4eUHaQaDrddCmqB2F77jTWcsPQIlW1cDcMahI39dtyrgAtu/8XH30HiK0emquoAF1htVmAs1iRgPlHHcqALiJniPZeghwrJYTLDkUTW2hUYx/cTq9dz9IYGWKIWgupIHWIfl90qY/0iwiFoFnse49Ng4O1yuhvPeXyMiJc+1mnj0pSH7pEPxbmR1SbQm628rw6KuMorXfdW3mlgWKJN8MmscFwZDR5Xsnq0jatwqi+8mN+VADkQsQ4u4hxM2pQmoO5zv43NenIouo0NuEcYddaMLxwio4t9UAMCKo/hF4TXUfIYWvFrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rc0dXXcjTKa1+6C8g45B4YLXy/pILO0mIDWTBrAMdnc=;
 b=H7zAnFFonaSi7jXdWySK+8868R8qvJjPmymP47L9pD9jARw96HkgKqERWz2/t7CqKOriMSJ0OeBsnoKt4QxLGkCGE9X+yQNpnb7AareTQy4Ey2bt7GKZ6cl1FX21Wg5qJl5Hv1jEiYfWvAL9iPehDvX3zGG8OZ/wa5JX50nMgPk=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by DU0PR08MB7486.eurprd08.prod.outlook.com (2603:10a6:10:356::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 26 Feb
 2026 15:59:33 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 15:59:33 +0000
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
Subject: [PATCH v5 16/36] KVM: arm64: gic-v5: Implement direct injection of
 PPIs
Thread-Topic: [PATCH v5 16/36] KVM: arm64: gic-v5: Implement direct injection
 of PPIs
Thread-Index: AQHcpzjmKN6J/v3Y/U6WLY4TGQmKmw==
Date: Thu, 26 Feb 2026 15:59:33 +0000
Message-ID: <20260226155515.1164292-17-sascha.bischoff@arm.com>
References: <20260226155515.1164292-1-sascha.bischoff@arm.com>
In-Reply-To: <20260226155515.1164292-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DBAPR08MB5687:EE_|DU0PR08MB7486:EE_|DB5PEPF00014B8A:EE_|VI0PR08MB11824:EE_
X-MS-Office365-Filtering-Correlation-Id: 23e7317a-cf63-4619-26a8-08de75502dd6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 K10WP7aU4JOCxbvDCX65RnvEETG8ehgzPA5XvTjJ/yNR8AQdiCgRJ5SPtGEyqz1w/2r1aSzn1XnhEj/9aY+/YmNRUbsNwt1pFxCrdtuBpNb5L3ZoLdZenHkRV7ENMXrgfTs5LwrtgTN20IQp0Kg/QVHrholkqwGCnaORl5R7x7NVeNkipCX6A2e4sBJZE6HmTxes6T4qbOWN6Bt7xZBbOswRaU4tdvr1726rk8sJczXi7utCNxNyAQ+BbhG0I37AYcA0c0UhRL4EVySc/h/cxWCsa3VGetLShBA50huExW+HNDywIYEAkGG8u0rO4IiXWgiqqUFmWvUY2hvDM5eL1re6g9gd0sDvxxMRibEptB9feR2MSdE2DYNoh6nedUKEIAcVopnZTAJoV7S1pfXSMxer0RAwX+xVuZLJ43Ef4bdDFyDJA5I7KTb2w6OzA9vSo8xN5kU166JMUPCM6/TWYzEm6F50Ai4lmxafMervt/7MJ2ptw4Tt/KjETVHwOXaOjFZ8Nt1t0N/W0gHryvRm243mZo6IIHIQjktfpPU2yuYiVGKE+4Q2qlOLrdRmpbHZFCKDYZbq64o+otdlp4DkfiFAT9vLAA8ZPmAyEfhhdLTKS/J5UqadSaOxbG/CcmAUxgs0dXUyzQgCzARkOyTE8eCnRFhCtEgkDxQcZmFfKiV07C2GFunTkDG2R+RN0TcBoLY+RoB3kAy3/Njz8CV8cguj5iz+5ltL2SoBsBmT5nbL5Anx6B/sKLMUh5bxrEVYqxwD16NNjka0PeH/I1hxDo7Wx1GJO/Zjes9NacW669E=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7486
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8A.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b5b9ec86-7a7a-4ed7-61f3-08de7550088f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	C0pv8ycvdOVvM6L2okdH6UjdHKGO9Qm9MsKphPSrhm2LKJmBcbT2WfPsi/eVEv4x9jypziDMAvuTj+NGozbg2ZQibkgoYAl5vcjtDqXT3m0QNo6DEa1znPpSOPleA+GD4a0Rx3VjXxVNKMhWIuA3zPo8yR8CiITGPaK0HHuWytBmHcDcc+ipfoAk3FmmVPj3/gbWoOIP5E9dT3SJ2io1MCgVlUFL0CajDbH6f/vwGPYBgcJXL/TJX5ZlpJbum4KrV0nYGfNuhMIHFmR231DwIEvVRMghtZNzaPU7oPpdWnYQJcTGfgXerZt0EMwFq8+H/leHhDjTH4apZWuT/zoVBFvKVxJObuEfBm9iztFBQ+gGfzT/Un/aapBDAnjYVEeHlwfk2tgCI4Pa0B27+w7f0SpV/elvl3uyrqQkpvb0PwMfFDsYk1eCaW5b+2bNgZ4TrWGhMP0KKaVnMpBzR/SN9cLCrJPz/BnNo2YYRnYcYnNxfQppouITWA15SbYsoJBtdCMmykbkz3r32dqSvaDCxvlT3KJXs+EfT9jr3cPH0kyctnBngwhg9TCkvUJRxoPv4wbsKtcD49JEtcO+0WjelN1JLEKOnij3SwIPKZorYXJtD9eLkbf5io+nLiIxDa/5VroTzmevEnz7uJOKb74qqZHquOuQ1EbNHds4knaYy49S387JDDNlTkrVtATWvP1+Igst6vnJ3NuKV/iL1isT09eozY0E4qxvoUqKKXiMoZU9Ss16DXeS6foIeckdbC3/dJpcv+C8On5h35io8dxWkVGhFMFNJ3pLrgMvELT2fjhl9N8W6/PPi9A3ngcUTwk/hE2piI2djPQokta2ByNtmg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VP98eKpGbHgeC6m0YB2jjt5Jyz5XzV+SE8gRezqIAtTEJWiZR57G3sczhACe/nLhkkwo+fNuepom5rNzu73wyRsI0nBhAE62md4pP3BmI49vZJSFatKcPqpWCUmKti3DweolosmLT2d9107TNMUNU9zeSH8Vapasxcn9ZS7JXnAf7q26Qlfe1tG8B76kIYpujQNQKH8tJCY2Tkmb8eR1jTEhiDK41pferW4v2rmEzDBXk41qyRNmLuAtWkaQDk2yuT1VaYApmRNtBQbTpgy12Ye21OKRASvyrEWD+nWTsNqJEuF5HOzY8oJhBNWNBgrnBIoy61BF7EpT1NkdltKfuY1XJgR63Pgkt9QHOqEsfzQZY5ZMSdtRFJWCsC57Tdi5ZyBce9NTZxLoTZarjzUChvTGJQkKCwQIYU4jXIZhZm1lfzT0uNMXTUsksc8Vxxll
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:00:35.9060
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e7317a-cf63-4619-26a8-08de75502dd6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8A.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11824
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
	TAGGED_FROM(0.00)[bounces-72035-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:dkim,arm.com:email,huawei.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
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
X-Rspamd-Queue-Id: B8DE31AB61C
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
index 5b35c756887a9..f5cd9decfc26e 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -86,6 +86,21 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
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
index 1005ff5f36235..62e58fdf611d3 100644
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
index 81d464d26534f..d7fe867a27b64 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -364,6 +364,7 @@ void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
+int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
 void vgic_v5_put(struct kvm_vcpu *vcpu);
 void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 3d34692d0e49c..d828861f8298a 100644
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

