Return-Path: <kvm+bounces-72056-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YEjlCJZ6oGmMkAQAu9opvQ
	(envelope-from <kvm+bounces-72056-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:53:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DCF91AB474
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:53:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F07DA31A002B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A22064C954A;
	Thu, 26 Feb 2026 16:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BVjsUuf9";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BVjsUuf9"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011009.outbound.protection.outlook.com [52.101.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D21E4418D1
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.9
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772122022; cv=fail; b=nTcIilYLkn0iAxE6i6ZIoxATDGpXAXE5tBLHFFkC6u3THQ9SKRvTRIQaflDtGaT8Iz2TsPNejZQPjV57+hvONo15ScnEB3hYdjNRoh2oPxO6HCeFHhkYffQhX9+01CBj7bvD8+Was2ZGmiMsv49ZDhUCcLIWAw850cnSJOe1nfQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772122022; c=relaxed/simple;
	bh=6lsAYcrvoIt3OI5wlOMJz2kjPp6Foq9mOcmWby44gZ4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gcHaorCiHD8fljGtvGQXgVEA7IgXfDUCNkI8yXhNhCzH9xWsRm8VWFHQKPCHRq/nOPEjWFYlVPh7bgqPTYWybUpFO566dLZZBXydpT757MyPZHy9GzTFAFuKrlLXfD74+Z3wtwi2XZOjE7LofJLjIIzsT3fNg3cz3SurgqykkU4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BVjsUuf9; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BVjsUuf9; arc=fail smtp.client-ip=52.101.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=PPPkIjjOCgZAl8oTBL8V6v2x1QICqrSCh95RsVtIz2qksseFj9hfSwpSF+vhIB7o/FKJW5lHBjn/iCyfvGtV4qaBdlK2+FEVloyBs/BRsLmkWC1EJ9Qx74l50tXc4pPAQFosQXrNe3+v1ZmGGugEogLSGzTz0vVyeQRoz8xR6GDV6QUGusj0YwYm94CAbhy2uHCmkJNXb4CLR3Tlftv3wyJimpZ/q2Uel2oD6M1JdeQgNh3ETRbR4u5Dsif6HhsDBkvztNIhrpyd089pF9JHpMXkjs4bnWQhzqM+adwLxptwoLmYJV1H27wGh/s1O1mZjHnePc7XU23PRDm/rzavfA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JL/nPRc//Hsc6QS1HSEmsOIF6StOAFbUmmYToFVx43M=;
 b=dzyCZIKSmj/cUny38LU/pVJc34n4LRiKQyCpyjRNuF0uM8q2HP7IgiOc5EbfCgeY8poph4k+ouuF8IaUaj/QvJKYfwGwZYpdoC9mSAiXH6KFGWzcIry38RoycQqPEZD/eD7SmA4/VdD7m6gp59HR9pJPWW7U/I4ceKnSTD81rx2A+tMUWowcR+4IkXkIF6w9uQOWnsCwQil0CMsotHGUUgXzOHLd6Rl3WGIJZlwwoCDy02+qdsTddHSfFoDD2wTY6wzgj5n8fUxcHF/yA78yU3W2/lw8qgLWzIie9KfBS3RnZo053ozJZHm7q7V5VakRxQZ20SIMvmuo891j+goQQg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JL/nPRc//Hsc6QS1HSEmsOIF6StOAFbUmmYToFVx43M=;
 b=BVjsUuf9ziv4TObFfACvq01Nk5o2TxmJuOKO74QVCgHrujd+7/pOw2Muday3JhoDNOZfUPuU3ZSCHdJgyPe9TxTiidiTA6ehlknGqguDw4koGiE1WI6wBS+KU7cf1hHLnbXTXJaLTcIW3uF2qadz15mhG5XFeIbnDR0oRUp9AT4=
Received: from AS4P192CA0034.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:658::13)
 by MRWPR08MB11705.eurprd08.prod.outlook.com (2603:10a6:501:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 16:06:48 +0000
Received: from AMS0EPF00000196.eurprd05.prod.outlook.com
 (2603:10a6:20b:658:cafe::f2) by AS4P192CA0034.outlook.office365.com
 (2603:10a6:20b:658::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 16:06:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000196.mail.protection.outlook.com (10.167.16.217) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 16:06:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DsdD01XoW5fUWx2F1GRoUF6zQGN9vbHeMUATlrxPeo0e+1l6tRP+kqFHFvwibkwKeuA+9XkXgnH+ysRT1PdFrbWcWdKtBirpe9cOlRXCv0ZyVlluXM169fpUfLlXRaisE8B9T7GlET/d/gio4Qers0BJ9+l/PFt8NMfLwZjCCxSOF704cSynJGOSlGlwLRcmVmmWT7iZUzFo6KDyJfusloU6zqwX1AVWY/HSL41YPtI+s0YqMq1gkvT4Hjli9qGiq2nLRixyWouWUOynzOXvmk1+bfmofreNBPTe7wxA3ZLhTbi+KwsucOxFbhuONTjuzyoGf3YdkOMSF/4HfAKDxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JL/nPRc//Hsc6QS1HSEmsOIF6StOAFbUmmYToFVx43M=;
 b=JlwQV/ZksmNetsH7wiTOFVmbnNRHuf+dtz7Uj1SuHp7CgBZ4HN2qzodyLqchu3lh69d9vgfVP5jwOZ/8X4tVlQ22AMJOmasxFPcZgRMgyPFFmZK7Nhja9vH7uDfTtzMObD6h02gsXqTJDTJWP77HEH7u/SRcRg0ElGwiJHX4jn08iRjfTwRpTVOAH0TS8wj6sQ8QP7VakPZXH+sw621+4Cn25eZsWepQymZHDog+eDy2+EwLiYIyutqu2T6k/mX5eqgo6UzoVm99RSuD/pypBqaSvwbFrS4DMIKTRjhsPWzDzPkxluUw9wDxX9VpU2NOTqx/CSJ9cIQcrfmEW5vgLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JL/nPRc//Hsc6QS1HSEmsOIF6StOAFbUmmYToFVx43M=;
 b=BVjsUuf9ziv4TObFfACvq01Nk5o2TxmJuOKO74QVCgHrujd+7/pOw2Muday3JhoDNOZfUPuU3ZSCHdJgyPe9TxTiidiTA6ehlknGqguDw4koGiE1WI6wBS+KU7cf1hHLnbXTXJaLTcIW3uF2qadz15mhG5XFeIbnDR0oRUp9AT4=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by PA4PR08MB5950.eurprd08.prod.outlook.com (2603:10a6:102:e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 16:04:47 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 16:04:47 +0000
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
Subject: [PATCH v5 36/36] KVM: arm64: selftests: Add no-vgic-v5 selftest
Thread-Topic: [PATCH v5 36/36] KVM: arm64: selftests: Add no-vgic-v5 selftest
Thread-Index: AQHcpzmhT6cYKVaNJES+rjaycIniNw==
Date: Thu, 26 Feb 2026 16:04:47 +0000
Message-ID: <20260226155515.1164292-37-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|PA4PR08MB5950:EE_|AMS0EPF00000196:EE_|MRWPR08MB11705:EE_
X-MS-Office365-Filtering-Correlation-Id: d224b565-fa41-4f08-75a4-08de75510bf9
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 1QF1vmfqAba3taLJsvmrzh6gTI+jvgd3bbrD3gjKxOzBOEGwOAwZwS3GGwuG0nkyV2pqXcF0BLM/BTHuuwifpCuHmImMgz1eU7iysWGPNLLS81cpn7/L1hwV/HaGqL/dIVM28kL8F2EuuIyI8yGtCzZxukFp2deMqn1nE1CcCfqJOuOlpGjxAFWSQHbA4W9jBLCnzwNZ4dLwVwTCMcJp0F1mOTVGhqzsRZs3rRrmMYTw4kr/unCH004YEPO2Yknbl5AupMRRK9+e0lunXcO0Q63Lz4y2VyXOq9oBpIxx3FNLrSIwUMdgIX6pMvyIInjVo3OCZ97TnFcmNEpsUyupy2qnJfbPkCy2JiD3BG8yB4H1u4aqUfrBVgCAbdZt3BCPBX5bXuZuyi4KPkSVAdeLo+5PKLp2nUTJSyDDw2jCeZxgW/Wvv+rcb8gBvSEVt057FVNToo05slTKoMAi16/hYJJVr8YvAV3jt9IPCrP0jcTbYMC3qs6dx917KlCpNmRiv9u5dRcvW3U7Dbvxl1wram/Sy29XnPdlt1XPUjz0z8NRsmb1oJFzKlgjUusplDtJoRXhVLVyiheFP4Bj7i5oI6xxIpR39RGC7Edfp0oEVMq8sKYM4zDC7Gv9W615P4lVELNQrYX5ljUAw7RXSLaPaysDlhm2OO9ohg3kMTyZwKBivStnYGl7Vm5gJHYJOXH8oHQVvAAuiH/2id0xQD9BP5H54+IW+os7GgXDx0lBuO2Tcz5OVQeOz3WykhOJne+TVtyX0rPCBjbOsetJ8P8Mrja02a6ADfL8gdN2U5NGmo8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB5950
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000196.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	530e8257-11a6-496a-2e57-08de7550c39c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|14060799003|35042699022|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	TpJWJD5a9F67uSf5qgRcKPRKRJMFny9YGh/7NCUhbUgxKPd6RS7O6heAwYI8QkwgXmfhwouhhjGmyxn6ARyMkR4mO7k3ThTleY6jIYOyYmDg1AQnBMjbfZ73grsW85ghJlq8U9D0dV/r78MBWqxmlu3WmSKHLqtPbPR5eE1+vojeCf2DthTOvtLEwN08zyzUyZ9E6TSDBvDHiOf3/VZJEJXa41csqTSEIa+CSAeeA/3FdUozfppH7ajklp8NGxjEQ4cfO3McqbtNcJBB0n8jrFk7/snOTM1Fcl17DTHNpwtJ9tGzkji9cdCV6Ovrr0x2HoTDxtBsgETbvmwofwajeC4tqOs5ppgb1u2LkdYRhM6zyxttkVeyk0lVwKZuBLjUnOA8YEfkZeMwRv0JBVCi8tqFLnzs7RZqlMiaPgkOFdGldYX/6yqW42W4n8+esBkOQkqOtNTqgb9jm1vJKpinmdMmdwhCJsyGvOL+NLd39CpmZrYFnK1efGruM28EyhGRCE30tERVJuVgBznYIhV0chjMajXDvTLBlViBaaCPLlymVngRSgVRR+2sHO/Rac1LRsmnfLTiScGZIctZW3S+W6IB8xXG5oODJ39rlszzruwJ3xCSkIX+wsBGPF8hsD0fKpTYDQdWiXGOjUpql07uba5qqjQm5GhKKxfVuNrU4OScaUJtCAIMmB3W9+2FrPNZGK/YAZ8e6Ol7qYSXuIb3gCZDJ4dqidmVK8DmySk+HzDyfyNGaLJ03GZTZR4ftTd9ejnLUy3q/KWS3cQKwdok/hKTrfKoUA1thrABZ7giLJiIS3pLNkC8TzVuRBswSFunZyg/v9886uLeevRWsRQ8yA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(14060799003)(35042699022)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7ayEO0wlV71py+8/xClOLXCqh+2qSWald5xcEVH5mi+XvXqIEDYNWH04hbQ+KuKM4g704fN3Z5JxUfyQFEi+Y8x+HPt0aPdXimRvmoEB0apv3Rd26ppzIYv0nDBP/3Cdl9V5ssy0u5HmFMOXS1i44HAu6fPJXxE1TUw5gQd0EG4UAZVUFCcgi1VyL7optRxBJmNzd3shrjq6ow5/fdwuPbAnUjkiVOZ4OHG3vUGy31qLnhWRHFznK2cBWlt/hRgl3Xxs9Nb/b+mY42MPasBPsCdIbSv08EZxwXua5O8S9hjmiIap+PgQWpE7SdmTKUMaYTorPIeOpxCKmAvlHpy3ehAq2jjtgzyUzpitSWsUm+u4A+gjFwkMLt7xNhT+ewMEpD6AWJMlRmjljgcAqwvwaBFz2S/pZa+kYt9wRU98lc0ajNZqWlHZeDzmf86EACti
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:06:48.5916
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d224b565-fa41-4f08-75a4-08de75510bf9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000196.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRWPR08MB11705
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72056-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,arm.com:mid,arm.com:dkim,arm.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 8DCF91AB474
X-Rspamd-Action: no action

Now that GICv5 is supported, it is important to check that all of the
GICv5 register state is hidden from a guest that doesn't create a
vGICv5.

Rename the no-vgic-v3 selftest to no-vgic, and extend it to check
GICv5 system registers too.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +-
 .../testing/selftests/kvm/arm64/no-vgic-v3.c  | 177 -----------
 tools/testing/selftests/kvm/arm64/no-vgic.c   | 297 ++++++++++++++++++
 3 files changed, 298 insertions(+), 178 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/arm64/no-vgic-v3.c
 create mode 100644 tools/testing/selftests/kvm/arm64/no-vgic.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selft=
ests/kvm/Makefile.kvm
index 860766e9e6a09..ce6e3b8948d94 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -178,7 +178,7 @@ TEST_GEN_PROGS_arm64 +=3D arm64/vgic_irq
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_lpi_stress
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_v5
 TEST_GEN_PROGS_arm64 +=3D arm64/vpmu_counter_access
-TEST_GEN_PROGS_arm64 +=3D arm64/no-vgic-v3
+TEST_GEN_PROGS_arm64 +=3D arm64/no-vgic
 TEST_GEN_PROGS_arm64 +=3D arm64/idreg-idst
 TEST_GEN_PROGS_arm64 +=3D arm64/kvm-uuid
 TEST_GEN_PROGS_arm64 +=3D access_tracking_perf_test
diff --git a/tools/testing/selftests/kvm/arm64/no-vgic-v3.c b/tools/testing=
/selftests/kvm/arm64/no-vgic-v3.c
deleted file mode 100644
index 152c34776981a..0000000000000
--- a/tools/testing/selftests/kvm/arm64/no-vgic-v3.c
+++ /dev/null
@@ -1,177 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-// Check that, on a GICv3 system, not configuring GICv3 correctly
-// results in all of the sysregs generating an UNDEF exception.
-
-#include <test_util.h>
-#include <kvm_util.h>
-#include <processor.h>
-
-static volatile bool handled;
-
-#define __check_sr_read(r)					\
-	({							\
-		uint64_t val;					\
-								\
-		handled =3D false;				\
-		dsb(sy);					\
-		val =3D read_sysreg_s(SYS_ ## r);			\
-		val;						\
-	})
-
-#define __check_sr_write(r)					\
-	do {							\
-		handled =3D false;				\
-		dsb(sy);					\
-		write_sysreg_s(0, SYS_ ## r);			\
-		isb();						\
-	} while(0)
-
-/* Fatal checks */
-#define check_sr_read(r)					\
-	do {							\
-		__check_sr_read(r);				\
-		__GUEST_ASSERT(handled, #r " no read trap");	\
-	} while(0)
-
-#define check_sr_write(r)					\
-	do {							\
-		__check_sr_write(r);				\
-		__GUEST_ASSERT(handled, #r " no write trap");	\
-	} while(0)
-
-#define check_sr_rw(r)				\
-	do {					\
-		check_sr_read(r);		\
-		check_sr_write(r);		\
-	} while(0)
-
-static void guest_code(void)
-{
-	uint64_t val;
-
-	/*
-	 * Check that we advertise that ID_AA64PFR0_EL1.GIC =3D=3D 0, having
-	 * hidden the feature at runtime without any other userspace action.
-	 */
-	__GUEST_ASSERT(FIELD_GET(ID_AA64PFR0_EL1_GIC,
-				 read_sysreg(id_aa64pfr0_el1)) =3D=3D 0,
-		       "GICv3 wrongly advertised");
-
-	/*
-	 * Access all GICv3 registers, and fail if we don't get an UNDEF.
-	 * Note that we happily access all the APxRn registers without
-	 * checking their existance, as all we want to see is a failure.
-	 */
-	check_sr_rw(ICC_PMR_EL1);
-	check_sr_read(ICC_IAR0_EL1);
-	check_sr_write(ICC_EOIR0_EL1);
-	check_sr_rw(ICC_HPPIR0_EL1);
-	check_sr_rw(ICC_BPR0_EL1);
-	check_sr_rw(ICC_AP0R0_EL1);
-	check_sr_rw(ICC_AP0R1_EL1);
-	check_sr_rw(ICC_AP0R2_EL1);
-	check_sr_rw(ICC_AP0R3_EL1);
-	check_sr_rw(ICC_AP1R0_EL1);
-	check_sr_rw(ICC_AP1R1_EL1);
-	check_sr_rw(ICC_AP1R2_EL1);
-	check_sr_rw(ICC_AP1R3_EL1);
-	check_sr_write(ICC_DIR_EL1);
-	check_sr_read(ICC_RPR_EL1);
-	check_sr_write(ICC_SGI1R_EL1);
-	check_sr_write(ICC_ASGI1R_EL1);
-	check_sr_write(ICC_SGI0R_EL1);
-	check_sr_read(ICC_IAR1_EL1);
-	check_sr_write(ICC_EOIR1_EL1);
-	check_sr_rw(ICC_HPPIR1_EL1);
-	check_sr_rw(ICC_BPR1_EL1);
-	check_sr_rw(ICC_CTLR_EL1);
-	check_sr_rw(ICC_IGRPEN0_EL1);
-	check_sr_rw(ICC_IGRPEN1_EL1);
-
-	/*
-	 * ICC_SRE_EL1 may not be trappable, as ICC_SRE_EL2.Enable can
-	 * be RAO/WI. Engage in non-fatal accesses, starting with a
-	 * write of 0 to try and disable SRE, and let's see if it
-	 * sticks.
-	 */
-	__check_sr_write(ICC_SRE_EL1);
-	if (!handled)
-		GUEST_PRINTF("ICC_SRE_EL1 write not trapping (OK)\n");
-
-	val =3D __check_sr_read(ICC_SRE_EL1);
-	if (!handled) {
-		__GUEST_ASSERT((val & BIT(0)),
-			       "ICC_SRE_EL1 not trapped but ICC_SRE_EL1.SRE not set\n");
-		GUEST_PRINTF("ICC_SRE_EL1 read not trapping (OK)\n");
-	}
-
-	GUEST_DONE();
-}
-
-static void guest_undef_handler(struct ex_regs *regs)
-{
-	/* Success, we've gracefully exploded! */
-	handled =3D true;
-	regs->pc +=3D 4;
-}
-
-static void test_run_vcpu(struct kvm_vcpu *vcpu)
-{
-	struct ucall uc;
-
-	do {
-		vcpu_run(vcpu);
-
-		switch (get_ucall(vcpu, &uc)) {
-		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT(uc);
-			break;
-		case UCALL_PRINTF:
-			printf("%s", uc.buffer);
-			break;
-		case UCALL_DONE:
-			break;
-		default:
-			TEST_FAIL("Unknown ucall %lu", uc.cmd);
-		}
-	} while (uc.cmd !=3D UCALL_DONE);
-}
-
-static void test_guest_no_gicv3(void)
-{
-	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm;
-
-	/* Create a VM without a GICv3 */
-	vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
-
-	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vcpu);
-
-	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
-				ESR_ELx_EC_UNKNOWN, guest_undef_handler);
-
-	test_run_vcpu(vcpu);
-
-	kvm_vm_free(vm);
-}
-
-int main(int argc, char *argv[])
-{
-	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm;
-	uint64_t pfr0;
-
-	test_disable_default_vgic();
-
-	vm =3D vm_create_with_one_vcpu(&vcpu, NULL);
-	pfr0 =3D vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
-	__TEST_REQUIRE(FIELD_GET(ID_AA64PFR0_EL1_GIC, pfr0),
-		       "GICv3 not supported.");
-	kvm_vm_free(vm);
-
-	test_guest_no_gicv3();
-
-	return 0;
-}
diff --git a/tools/testing/selftests/kvm/arm64/no-vgic.c b/tools/testing/se=
lftests/kvm/arm64/no-vgic.c
new file mode 100644
index 0000000000000..b14686ef17d12
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/no-vgic.c
@@ -0,0 +1,297 @@
+// SPDX-License-Identifier: GPL-2.0
+
+// Check that, on a GICv3-capable system (GICv3 native, or GICv5 with
+// FEAT_GCIE_LEGACY), not configuring GICv3 correctly results in all
+// of the sysregs generating an UNDEF exception. Do the same for GICv5
+// on a GICv5 host.
+
+#include <test_util.h>
+#include <kvm_util.h>
+#include <processor.h>
+
+#include <arm64/gic_v5.h>
+
+static volatile bool handled;
+
+#define __check_sr_read(r)					\
+	({							\
+		uint64_t val;					\
+								\
+		handled =3D false;				\
+		dsb(sy);					\
+		val =3D read_sysreg_s(SYS_ ## r);			\
+		val;						\
+	})
+
+#define __check_sr_write(r)					\
+	do {							\
+		handled =3D false;				\
+		dsb(sy);					\
+		write_sysreg_s(0, SYS_ ## r);			\
+		isb();						\
+	} while (0)
+
+#define __check_gicv5_gicr_op(r)				\
+	({							\
+		uint64_t val;					\
+								\
+		handled =3D false;				\
+		dsb(sy);					\
+		val =3D read_sysreg_s(GICV5_OP_GICR_ ## r);	\
+		val;						\
+	})
+
+#define __check_gicv5_gic_op(r)					\
+	do {							\
+		handled =3D false;				\
+		dsb(sy);					\
+		write_sysreg_s(0, GICV5_OP_GIC_ ## r);		\
+		isb();						\
+	} while (0)
+
+/* Fatal checks */
+#define check_sr_read(r)					\
+	do {							\
+		__check_sr_read(r);				\
+		__GUEST_ASSERT(handled, #r " no read trap");	\
+	} while (0)
+
+#define check_sr_write(r)					\
+	do {							\
+		__check_sr_write(r);				\
+		__GUEST_ASSERT(handled, #r " no write trap");	\
+	} while (0)
+
+#define check_sr_rw(r)				\
+	do {					\
+		check_sr_read(r);		\
+		check_sr_write(r);		\
+	} while (0)
+
+#define check_gicv5_gicr_op(r)					\
+	do {							\
+		__check_gicv5_gicr_op(r);			\
+		__GUEST_ASSERT(handled, #r " no read trap");	\
+	} while (0)
+
+#define check_gicv5_gic_op(r)					\
+	do {							\
+		__check_gicv5_gic_op(r);			\
+		__GUEST_ASSERT(handled, #r " no write trap");	\
+	} while (0)
+
+static void guest_code_gicv3(void)
+{
+	uint64_t val;
+
+	/*
+	 * Check that we advertise that ID_AA64PFR0_EL1.GIC =3D=3D 0, having
+	 * hidden the feature at runtime without any other userspace action.
+	 */
+	__GUEST_ASSERT(FIELD_GET(ID_AA64PFR0_EL1_GIC,
+				 read_sysreg(id_aa64pfr0_el1)) =3D=3D 0,
+		       "GICv3 wrongly advertised");
+
+	/*
+	 * Access all GICv3 registers, and fail if we don't get an UNDEF.
+	 * Note that we happily access all the APxRn registers without
+	 * checking their existence, as all we want to see is a failure.
+	 */
+	check_sr_rw(ICC_PMR_EL1);
+	check_sr_read(ICC_IAR0_EL1);
+	check_sr_write(ICC_EOIR0_EL1);
+	check_sr_rw(ICC_HPPIR0_EL1);
+	check_sr_rw(ICC_BPR0_EL1);
+	check_sr_rw(ICC_AP0R0_EL1);
+	check_sr_rw(ICC_AP0R1_EL1);
+	check_sr_rw(ICC_AP0R2_EL1);
+	check_sr_rw(ICC_AP0R3_EL1);
+	check_sr_rw(ICC_AP1R0_EL1);
+	check_sr_rw(ICC_AP1R1_EL1);
+	check_sr_rw(ICC_AP1R2_EL1);
+	check_sr_rw(ICC_AP1R3_EL1);
+	check_sr_write(ICC_DIR_EL1);
+	check_sr_read(ICC_RPR_EL1);
+	check_sr_write(ICC_SGI1R_EL1);
+	check_sr_write(ICC_ASGI1R_EL1);
+	check_sr_write(ICC_SGI0R_EL1);
+	check_sr_read(ICC_IAR1_EL1);
+	check_sr_write(ICC_EOIR1_EL1);
+	check_sr_rw(ICC_HPPIR1_EL1);
+	check_sr_rw(ICC_BPR1_EL1);
+	check_sr_rw(ICC_CTLR_EL1);
+	check_sr_rw(ICC_IGRPEN0_EL1);
+	check_sr_rw(ICC_IGRPEN1_EL1);
+
+	/*
+	 * ICC_SRE_EL1 may not be trappable, as ICC_SRE_EL2.Enable can
+	 * be RAO/WI. Engage in non-fatal accesses, starting with a
+	 * write of 0 to try and disable SRE, and let's see if it
+	 * sticks.
+	 */
+	__check_sr_write(ICC_SRE_EL1);
+	if (!handled)
+		GUEST_PRINTF("ICC_SRE_EL1 write not trapping (OK)\n");
+
+	val =3D __check_sr_read(ICC_SRE_EL1);
+	if (!handled) {
+		__GUEST_ASSERT((val & BIT(0)),
+			       "ICC_SRE_EL1 not trapped but ICC_SRE_EL1.SRE not set\n");
+		GUEST_PRINTF("ICC_SRE_EL1 read not trapping (OK)\n");
+	}
+
+	GUEST_DONE();
+}
+
+static void guest_code_gicv5(void)
+{
+	/*
+	 * Check that we advertise that ID_AA64PFR2_EL1.GCIE =3D=3D 0, having
+	 * hidden the feature at runtime without any other userspace action.
+	 */
+	__GUEST_ASSERT(FIELD_GET(ID_AA64PFR2_EL1_GCIE,
+				 read_sysreg_s(SYS_ID_AA64PFR2_EL1)) =3D=3D 0,
+		       "GICv5 wrongly advertised");
+
+	/*
+	 * Try all GICv5 instructions, and fail if we don't get an UNDEF.
+	 */
+	check_gicv5_gic_op(CDAFF);
+	check_gicv5_gic_op(CDDI);
+	check_gicv5_gic_op(CDDIS);
+	check_gicv5_gic_op(CDEOI);
+	check_gicv5_gic_op(CDHM);
+	check_gicv5_gic_op(CDPEND);
+	check_gicv5_gic_op(CDPRI);
+	check_gicv5_gic_op(CDRCFG);
+	check_gicv5_gicr_op(CDIA);
+	check_gicv5_gicr_op(CDNMIA);
+
+	/* Check General System Register acccesses */
+	check_sr_rw(ICC_APR_EL1);
+	check_sr_rw(ICC_CR0_EL1);
+	check_sr_read(ICC_HPPIR_EL1);
+	check_sr_read(ICC_IAFFIDR_EL1);
+	check_sr_rw(ICC_ICSR_EL1);
+	check_sr_read(ICC_IDR0_EL1);
+	check_sr_rw(ICC_PCR_EL1);
+
+	/* Check PPI System Register accessess */
+	check_sr_rw(ICC_PPI_CACTIVER0_EL1);
+	check_sr_rw(ICC_PPI_CACTIVER1_EL1);
+	check_sr_rw(ICC_PPI_SACTIVER0_EL1);
+	check_sr_rw(ICC_PPI_SACTIVER1_EL1);
+	check_sr_rw(ICC_PPI_CPENDR0_EL1);
+	check_sr_rw(ICC_PPI_CPENDR1_EL1);
+	check_sr_rw(ICC_PPI_SPENDR0_EL1);
+	check_sr_rw(ICC_PPI_SPENDR1_EL1);
+	check_sr_rw(ICC_PPI_ENABLER0_EL1);
+	check_sr_rw(ICC_PPI_ENABLER1_EL1);
+	check_sr_read(ICC_PPI_HMR0_EL1);
+	check_sr_read(ICC_PPI_HMR1_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR0_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR1_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR2_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR3_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR4_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR5_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR6_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR7_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR8_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR9_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR10_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR11_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR12_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR13_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR14_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR15_EL1);
+
+	GUEST_DONE();
+}
+
+static void guest_undef_handler(struct ex_regs *regs)
+{
+	/* Success, we've gracefully exploded! */
+	handled =3D true;
+	regs->pc +=3D 4;
+}
+
+static void test_run_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	do {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_PRINTF:
+			printf("%s", uc.buffer);
+			break;
+		case UCALL_DONE:
+			break;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	} while (uc.cmd !=3D UCALL_DONE);
+}
+
+static void test_guest_no_vgic(void *guest_code)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	/* Create a VM without a GIC */
+	vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_ELx_EC_UNKNOWN, guest_undef_handler);
+
+	test_run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	bool has_v3, has_v5;
+	uint64_t pfr;
+
+	test_disable_default_vgic();
+
+	vm =3D vm_create_with_one_vcpu(&vcpu, NULL);
+
+	pfr =3D vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
+	has_v3 =3D !!FIELD_GET(ID_AA64PFR0_EL1_GIC, pfr);
+
+	pfr =3D vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR2_EL1));
+	has_v5 =3D !!FIELD_GET(ID_AA64PFR2_EL1_GCIE, pfr);
+
+	kvm_vm_free(vm);
+
+	__TEST_REQUIRE(has_v3 || has_v5,
+		       "Neither GICv3 nor GICv5 supported.");
+
+	if (has_v3) {
+		pr_info("Testing no-vgic-v3\n");
+		test_guest_no_vgic(guest_code_gicv3);
+	} else {
+		pr_info("No GICv3 support: skipping no-vgic-v3 test\n");
+	}
+
+	if (has_v5) {
+		pr_info("Testing no-vgic-v5\n");
+		test_guest_no_vgic(guest_code_gicv5);
+	} else {
+		pr_info("No GICv5 support: skipping no-vgic-v5 test\n");
+	}
+
+	return 0;
+}
--=20
2.34.1

