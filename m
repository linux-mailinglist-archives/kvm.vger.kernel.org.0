Return-Path: <kvm+bounces-72048-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qEeqFUl8oGmMkAQAu9opvQ
	(envelope-from <kvm+bounces-72048-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 18:00:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C5171AB89A
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 18:00:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0B3F7315E8A3
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C91A48BD52;
	Thu, 26 Feb 2026 16:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JkeTlBuS";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JkeTlBuS"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011014.outbound.protection.outlook.com [40.107.130.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E37C48BD4F
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.14
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121838; cv=fail; b=HNrnVdUsBrFJCH9wuOlPA+j6AYpGQVlu7imKIopr5pmPJFDrwGXWE6bT8CttwevY8vkLCcW87ZmUSWz6So2i6mcs+UhilWv4JU0609LCBoEYz+guxrLwVGN9AfMtu0kPn1GV0zjxsEKptFFezp6RJeOeQ7bE1fg7sYdJ12h2KwE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121838; c=relaxed/simple;
	bh=XtEc/xH9pmTuPEGAdZyQMrqxsaj3V5ZwiTxjTc7oQI8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Tly1wIxlkL3E/qiruOJ3HVgrL1hN92y3G2FR9XIZF5PHXhkjLj9Qn5tXI8wcaBS0Mq0Px//AuvkY2WMFzRURw7mlvNObTgX8JTcWMbVtvLv3XhGCemdmCCLbtO867m2rsbJ7rBhCgTuioIr92vQqYGmKwBWY9izZAApffirNEgY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JkeTlBuS; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JkeTlBuS; arc=fail smtp.client-ip=40.107.130.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=bKls+Affry2XmG9zjjq2A+45MnS7alqAki0miWsMfDCaRyMMhuqnedN8dzNAlLTi2j1xltRLoIYHz2wf/J0NiZIljFYCDr7v10+B7BTwBeQmSFStq5mozpEuJUInBOSpwlFqlU/M8JAknjpk1zwBkh9W/WZCxJlvlMXF9+B/Io64zKQoe/nxoRDBsaD6WxkUhnNQ1m+dwZn+zrv1NzBGaoWDt6UAgV3jGfuenVjKowiPGYdo1XzEiPgGUNsmDlhZFGExntHmUeWdU6bi9Bvfhtt9pX5tmt1pF0y+Gabr2ys+3h/Nc14xxUEW7y2MqRdTBc75vRSI7ZFBiKz4c1tW4Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aGpjJrTIfxe2SoWYHRvFH81coaVZBBkic+aMEyAngLI=;
 b=mRDnRzFQfNXox+dF+3B+q+CiS/o3tPtETOcsNi+R7D4y2jsR330Q8odtbKjaOxC06BAm/Y1s3uZarZTwdRnQ7wP/QWEI8DS9ftJuYR21GP1sTrfsra8YNcgeZSR/LMS5TkApOQR1fzCToXWMV6I3tco9BmwQKUObtDDu68RkZ/2TJtGXxVgeEX+JuPCqeFlLeXepPzGHFFP37qPRAMei6sh1j9ws0YPrrhS6HTu6WGnoyPseXatgnUMTcICgi6gbgQVQgNHxSreJVUXMlw7/h1Uu0aD3daXdhlo6AdqSK75rpwo1EWftIiC9XWYqUrDU/0pQ57veK67xGTHTc7dYqQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGpjJrTIfxe2SoWYHRvFH81coaVZBBkic+aMEyAngLI=;
 b=JkeTlBuSQBMynpqoJXqX8+Dfm0UVHDsJ4HSyN3//NUNlxVwt8YpD13E16OJdy0AQ/zeW1QfpMyvP0eNurJgZ28LHViNFLI6pbhAb8MV2ZjhDt7nMOCqADhouW99yglakYdDkPyrhUTpwdQ2T7OHf5aYckPXBt2dPITfWAi4wsaw=
Received: from DU2PR04CA0341.eurprd04.prod.outlook.com (2603:10a6:10:2b4::30)
 by PA4PR08MB6015.eurprd08.prod.outlook.com (2603:10a6:102:e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 16:03:46 +0000
Received: from DB1PEPF00039232.eurprd03.prod.outlook.com
 (2603:10a6:10:2b4:cafe::2c) by DU2PR04CA0341.outlook.office365.com
 (2603:10a6:10:2b4::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.25 via Frontend Transport; Thu,
 26 Feb 2026 16:03:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039232.mail.protection.outlook.com (10.167.8.105) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 16:03:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j5tNHeU438YAOwAzhsg9pBQ2IBYoyPUVNwaSHPMK6nzl/v2J5F+96o8o5Wivehw0ASr5xcnHNwUou+Jq4y3MP9E6skrwobZLlXORpgEJg63osfEVMRy+k2sb9NsNjLO4LfJKZuab7qmc4XHaePdTzpzY6zcCTJAw7XYWMtZr6Rc26HojvY6z7T6kXRaAR4D0kmW4UJ+eFJdEX6JNKXHWW9p/SyHdUTfvFhbs4MHmlbYB9ZywZi9/lR+SAwoDtDLBezgXxMeFtFbi4zOQnogD1E8seOg3Jm9U0UalW52QPBPdlt2lgMk08g4J9r8EtXgOTq191AIOpk8CPgGhkJYyzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aGpjJrTIfxe2SoWYHRvFH81coaVZBBkic+aMEyAngLI=;
 b=MS5utRuX8rGy8AIMd3El3htnVNxFO4gOvExEqL0a3SmTI/DVjaCV26+01qeqArvk7QfulNoH3n61mhPQtIkva1Vwrtzr0JxMpKJO+DAgCB9Kov1w1QKUT9U1sbQVOCnXb2skz14+arimk3BPvThvwOvUz954GUi4GVUyrOCUA411E1pnfEDtZqFZeILBnrNmnJHxTHL22+HiINfpmnruUIHEnFGH5Y4CmylBwTMu2HqAtCZdmg5O6zNdaOtG910CkoPqH0CAmveB7hCKLDVwBMiXCabP5HFidNss3HHsJMvGNkPbqMGCxdayyHGP+SbVoRamrovb7WUJoS0VRh9nRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGpjJrTIfxe2SoWYHRvFH81coaVZBBkic+aMEyAngLI=;
 b=JkeTlBuSQBMynpqoJXqX8+Dfm0UVHDsJ4HSyN3//NUNlxVwt8YpD13E16OJdy0AQ/zeW1QfpMyvP0eNurJgZ28LHViNFLI6pbhAb8MV2ZjhDt7nMOCqADhouW99yglakYdDkPyrhUTpwdQ2T7OHf5aYckPXBt2dPITfWAi4wsaw=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by DB9PR08MB11312.eurprd08.prod.outlook.com (2603:10a6:10:608::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 16:02:43 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 16:02:43 +0000
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
Subject: [PATCH v5 28/36] KVM: arm64: gic: Hide GICv5 for protected guests
Thread-Topic: [PATCH v5 28/36] KVM: arm64: gic: Hide GICv5 for protected
 guests
Thread-Index: AQHcpzlXWGhq5N5yhECSZ8Hw1Klyqg==
Date: Thu, 26 Feb 2026 16:02:43 +0000
Message-ID: <20260226155515.1164292-29-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|DB9PR08MB11312:EE_|DB1PEPF00039232:EE_|PA4PR08MB6015:EE_
X-MS-Office365-Filtering-Correlation-Id: d931bda0-a688-4841-858b-08de75509f50
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 PGeHixOso/8ezojfEAq4tbHIwgn4xF9AzFXUSRewrIM/0fKC+cAMNxfTtrfkc8lsnlmi+zjeVy2GZTlqvgntmbCFRUF5UmuimLv/p28PZzX8wVsBudpppD0+CjiF+ojnL6K73WB7qMPuMSx6X0UxOhkbT78s0xGut+l/PIPgZKPJRAdSgkkSlcVh12WnFL7P4WpI90/Uxt7wXC6Ky03e0UPjpAUwTz4KbM9TVPtorfSR+iRr7SE9P3zOEcjZ5g4EQ3eHrg1hSsHh5ti4A9Yqbi6QtpXretM0KyTm7fODEBEKoCmBgQ+CfCa9mjQvuGlZplukZ3VbQvPE9uYMWlqMuOtMrLNfOBXfxAlFkmcgp6wIMVdLL9qVNsaDWbuWJPe26aLz0YglW/tzl/eYOusnJrhbC4x+J6K9a/lT0R5xrUBkGFeh6FyFAEAV3+EIyd+hHdYr11BQkDdBiY0M/0bLNgtvjyvlx4vrVTOuWns9a2eztKeTyPrwuWdLTlvRNy1Odh4QzHYJOo+iAv/3Fa2Bn01BuQTI8wpMn5zyqYP65GXiyLYSNaOdWuOgUD23uP+9az4ILfw5Wb0vEhpOIy180jzd6zh2YUsWUASdPY2D460t4yIv56jc73chNxdUniagRcHuXgGp+6UOHl4Sj5xdm7AStWuW7loDPTQD0Ui0UbyyUcWxjWurzgTduO+wBrjysr2WQGwdeqlfbMJM3CwUGMZT9z0jCqRxXgbBXCOdeU2X0OveXX+k/LDNnc2J23meQLlXtuEuGCYN1iQphi4MJg4Pk3nIWrCA3FKpbteSc+4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11312
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00039232.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8ca3190e-2b0e-440d-ef94-08de755079b5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|36860700013|376014|1800799024|35042699022;
X-Microsoft-Antispam-Message-Info:
	s+y7aZ372NGbusUy+2cZh8p6o2IbbuYbLe2IL58znLEZZC/m6a+achk9znZqdWhBHCIzAoNzQVPAnTaTl6c7nsPhXDeJcElDL56YKbt8WJ58zCxmjgkN2CT1rxLI2nSk+neTm3Hch1hpTDAXm4Ko77Rp1udNQ/tYqyoj3tYEE8RgWFfuiQhKKN7HRj1cx8BIra6gdlIC7PNFjpx27DfY/SRw+6sRZSu2/v3oSH2FH6Eox9DcN2LMi8kKoiDLLGE8vitzc9UxpHv8tbEBM2G/rDZc7bQMIgPQyN1K+0/qoWU8obpEUler5D9lkD7a2Na7Xtpdo9kUNCsD/crQ3mN9r2+9l2IZjjuA5F1IDIyeVaVsyOQgDaKNlX4WdOq486gxWsbWjVp8yr9jX04iCWsOCDVnmi3m+gGOM2OcRqmLpDlo+RK4ZevAib/wS9x6e4i0qg56moC+3aUhOVUSmwNQzvtTZoQFvCErZ51ZFxvXHzIAcY+5mMIg7024V6Saa/NZzAz+KD27/9gDLh+ECEEN+cFYCB5qZ8wmX4dbq6jKzyh8Iw/aSRjC9OYKK044eN8XJOPCU7aztY/xM3uorhVcVwKqlg9m+3H2EfKI6ja75f0eFSDrvwBkdaHquaoSfZ/WSLCwyeKbWdBznk2mxfIktT9Lna7LPP7l54Qtr4nkrf4dYnfK2SGj0UnHwhC57hjQSTYgXw0SmA2RmsAIeHSwHvqGq8hbFoDPyg92fhj5xIsTjVHz4Q/KFzgQQbEVmVnc1dPhHTkSSANgMqZqrzR7g1IPBPl3AzSRiSTRfGV2XyE/9iHgHDCMJ+dwzTUJFP5PIAh/P3ZZUmfvQ4mVUX0Wqg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(36860700013)(376014)(1800799024)(35042699022);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	anol/FOSjrwe1q8GRe8z/+yxl0AKMcA9T6e5Z4NOsh2mHb5VBA0KDG7WB5WnwvPtnH4Mm8cvsPYxQo+JlD33qprDRJqvOTb7hlGBqnIIc+3qWX5ZYpv/uzgLiPsy5kx/36yfk/mV7xDd7usnxBbcdMo7o1HJ5k0FLe0sQyG41FmRMWyxVd1dhh/velBUVn/NbDA021Z9zCk3V59MvtiXJ83nHD6C4a42WmWb6crtnd93zK65NrJByeQTX26peul+iFJw+qnS8UOhjKCIvezf7zlpNosD3MAdPaFykg9V315dsJrD82AlrddangsCPEY9A97U0bLtOMLonmPRyfT0Rdjqj7BvQnUgHl1UMf9xOUP1LkocFpT66hRIDZecRmSE15uwN1xl3lmdeCz+mbJFMR1PQ8LmMacMYsJ+av243czL3kQdfeL3CVzY41axyY1S
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:03:46.2815
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d931bda0-a688-4841-858b-08de75509f50
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039232.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6015
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72048-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:dkim,arm.com:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 5C5171AB89A
X-Rspamd-Action: no action

We don't support running protected guest with GICv5 at the moment.
Therefore, be sure that we don't expose it to the guest at all by
actively hiding it when running a protected guest.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h   | 1 +
 arch/arm64/kvm/arm.c               | 1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 8 ++++++++
 3 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 3dcec1df87e9e..8163c6d2509c5 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -144,6 +144,7 @@ void __noreturn __host_enter(struct kvm_cpu_context *ho=
st_ctxt);
=20
 extern u64 kvm_nvhe_sym(id_aa64pfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64pfr1_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64pfr2_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar2_el1_sys_val);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 563e18b1ec5aa..40d69a96d78d0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2528,6 +2528,7 @@ static void kvm_hyp_init_symbols(void)
 {
 	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) =3D get_hyp_id_aa64pfr0_el1();
 	kvm_nvhe_sym(id_aa64pfr1_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_A=
A64PFR1_EL1);
+	kvm_nvhe_sym(id_aa64pfr2_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_A=
A64PFR2_EL1);
 	kvm_nvhe_sym(id_aa64isar0_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR0_EL1);
 	kvm_nvhe_sym(id_aa64isar1_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR1_EL1);
 	kvm_nvhe_sym(id_aa64isar2_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR2_EL1);
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/s=
ys_regs.c
index 06d28621722ee..b40fd01ebf329 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -20,6 +20,7 @@
  */
 u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
+u64 id_aa64pfr2_el1_sys_val;
 u64 id_aa64isar0_el1_sys_val;
 u64 id_aa64isar1_el1_sys_val;
 u64 id_aa64isar2_el1_sys_val;
@@ -108,6 +109,11 @@ static const struct pvm_ftr_bits pvmid_aa64pfr1[] =3D =
{
 	FEAT_END
 };
=20
+static const struct pvm_ftr_bits pvmid_aa64pfr2[] =3D {
+	MAX_FEAT(ID_AA64PFR2_EL1, GCIE, NI),
+	FEAT_END
+};
+
 static const struct pvm_ftr_bits pvmid_aa64mmfr0[] =3D {
 	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, PARANGE, 40),
 	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, ASIDBITS, 16),
@@ -221,6 +227,8 @@ static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu,=
 u32 id)
 		return get_restricted_features(vcpu, id_aa64pfr0_el1_sys_val, pvmid_aa64=
pfr0);
 	case SYS_ID_AA64PFR1_EL1:
 		return get_restricted_features(vcpu, id_aa64pfr1_el1_sys_val, pvmid_aa64=
pfr1);
+	case SYS_ID_AA64PFR2_EL1:
+		return get_restricted_features(vcpu, id_aa64pfr2_el1_sys_val, pvmid_aa64=
pfr2);
 	case SYS_ID_AA64ISAR0_EL1:
 		return id_aa64isar0_el1_sys_val;
 	case SYS_ID_AA64ISAR1_EL1:
--=20
2.34.1

