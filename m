Return-Path: <kvm+bounces-72551-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IK04Nr8Zp2m+dgAAu9opvQ
	(envelope-from <kvm+bounces-72551-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 18:26:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AE671F499A
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 18:26:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 895A43135E6D
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 17:23:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 671ED351C24;
	Tue,  3 Mar 2026 17:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VlpZnjv7";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VlpZnjv7"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011015.outbound.protection.outlook.com [52.101.70.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E3F3537FD
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 17:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.15
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772558626; cv=fail; b=Xh3qMAqM7uw8PSsg3R6z/9ZoY1uWN6/T2Tw4f/nc+rsSowN+zfCckjt2GQEYF8GmlIw6ILehEV1UxbFmn6Er9amdfk6JqXlrkniuaNM1DOt4hCgqR1G9fIdOOnJO3PPDzKP5MwIEVJI7Xtq9qaTfLLo3AW5pVwfosyugqd2rbPU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772558626; c=relaxed/simple;
	bh=IbXQqVK3mfKRAeUOgpV4iE6yW4vHbXfX5D4iGpMQR/g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T7x2P1AiXMabBvHpQzQwQOc4PX7g9Bja++Gr+Cbo/kP7mgT8xYGd+ajaOrhzx7aGKi7js5cVBCBjdxDTAy6+YAv5QFkCaIy10zX0DEar6o8NRtvaJD6/olMjSW8r8eV6iAv4I6q9VF0EQJwuWFfQcdnDPwJgSz6NJ3dSftlMWm4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VlpZnjv7; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VlpZnjv7; arc=fail smtp.client-ip=52.101.70.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vr8JHOrxw9yEUlodWil6szpyXpnIBC0/hlDatr8EBk2M6J+OAiPAP5CEXSnwJdoCEtjxiAJlxBRDw5/Gk5BxXi3L78hLDkDDVCuOjyUim6kIqZ3YMhXA/If9hN+iX/2ESA1bPeXQkodrw2MXN8kqN4O8lz/7mTO5011gElk7x8ylWyLIcnKUZH9YxT8WBaQ/l+8qflIYVDd9IKNJNDJR/M/EQn4wyMl/FtFK4RiHM9MTEUc8mdaVxaYYsUVu9fay2Lb14zLiduZg/l1QanQ6feob8ybDaseIVdkcTnrz5s/5z4yHIiXydI2HINeYwPtddpMz73kgyilkOCtS0MFyaA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IbXQqVK3mfKRAeUOgpV4iE6yW4vHbXfX5D4iGpMQR/g=;
 b=QjK8rLxjLi1b2R0GdVOn6yeQoJ63JkakVpvD9vi2TBY1YWaEKM1VFpzC/59ue4JhLtgfTXS7iXmohUuYlpI5eyUQIpJPdJ6S7wlojBdUsvh/RzbmRyAS7t9XL4dmy+KCm87KQpJwBmbHlbDmx3XltWxxGcenVh1Kelpwt3xLuND6yQrDwqB/URGCxZ3XXjZAquGM8+3tOikgU2BOhmxInhRAuYkwKqdvLf8r4QY/GcIsQFEuGMwd8dbrtbkIp61KhRyeIBzsLcoZRIjTWK2gfepIvmEyBTrepmILj5vIc+guRGaW4r9ep5sHWuINxbnc6XV6+xgNaJL5+WCSCBEHMw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IbXQqVK3mfKRAeUOgpV4iE6yW4vHbXfX5D4iGpMQR/g=;
 b=VlpZnjv7TWX3RLw5xHlyxHfTiRJapkDhzcirh5c+JRTawzUtnpbkpGlz+L3v3cTXa8nKNMBYCFglWNIqiBUrWXNWz756QdikzL+YuoXh3X5W8fHp0HnXbGWn5wlb4NnsaMxSi7ixItXNG51QSDMPUEIetQ5oqaegDtCat61iIKg=
Received: from AM9P195CA0029.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:21f::34)
 by AS2PR08MB8574.eurprd08.prod.outlook.com (2603:10a6:20b:55d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 17:23:37 +0000
Received: from AMS0EPF000001A5.eurprd05.prod.outlook.com
 (2603:10a6:20b:21f:cafe::f5) by AM9P195CA0029.outlook.office365.com
 (2603:10a6:20b:21f::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.20 via Frontend Transport; Tue,
 3 Mar 2026 17:23:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A5.mail.protection.outlook.com (10.167.16.232) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.16
 via Frontend Transport; Tue, 3 Mar 2026 17:23:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t3l5Vx/VHJbT/RTCeGxdqGjujHojONP+aoXzrIdHg2UrnmdrsvkP76zUnM+u0NCy3/fRR4YZIVuaodwtqRKpTBeJ0mAi6Qwztv5PxBeR8N5RpK6Qw0K0fdevVHbywahvWlVyMN+XzLCuqIcs4edOFLlH2Z82azCfLWcJuxEXeM1fYM2rS1f3TLenU4kJSDDmNHZqbbZFnK1J/NAaymzI17zaCYKFzH+cDrXMolow5NOyrwpKCvcTbDUISMUozV63pORCSvPXK4jpuXxXpfKoO7uG7S0CnKRZpQkwq34SzMFmUNIPs/6AfjoIQrRzFSJpq7qZJX4g8Qwf/l2N2qlv2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IbXQqVK3mfKRAeUOgpV4iE6yW4vHbXfX5D4iGpMQR/g=;
 b=tP5hVsMBC/H/EvTVvUAJVXi0+h+r+trwA35aJBRPdP0yDWL22yY+IrfLt07rzTDcbv2kd4vxdEbcgpOyAywrqEfum71HoLce40QWHEKkzC3eogaKdBowYiWkRlOewGuUsQnLuwSTSj8WdDB55pK2JtgY1qN24NhwshtaN//Mfx9h/VAqMNq/EKY4EAxxRpanPN4Wo3bLonlZy13fBi6shWTibkSjldSoF+abJp1X3nsO71nzydyf+WWF0uDyEdqu5+JVC77ySy/q5ttd5Ln2FglnxI6+Jgo7NOQZrfQmD6kZ9uSxtzg7XilnVSRdNCMxRiN3fPQskpc5wFZv9lrWNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IbXQqVK3mfKRAeUOgpV4iE6yW4vHbXfX5D4iGpMQR/g=;
 b=VlpZnjv7TWX3RLw5xHlyxHfTiRJapkDhzcirh5c+JRTawzUtnpbkpGlz+L3v3cTXa8nKNMBYCFglWNIqiBUrWXNWz756QdikzL+YuoXh3X5W8fHp0HnXbGWn5wlb4NnsaMxSi7ixItXNG51QSDMPUEIetQ5oqaegDtCat61iIKg=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by PAXPR08MB6592.eurprd08.prod.outlook.com (2603:10a6:102:158::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 17:22:33 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 17:22:33 +0000
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
Subject: Re: [PATCH v5 09/36] KVM: arm64: gic-v5: Detect implemented PPIs on
 boot
Thread-Topic: [PATCH v5 09/36] KVM: arm64: gic-v5: Detect implemented PPIs on
 boot
Thread-Index: AQHcpzilUvdE+ac9kkujPr4tKP7EirWc8TmAgAAk+AA=
Date: Tue, 3 Mar 2026 17:22:33 +0000
Message-ID: <69d486ea3519d5b19731deb6e1cb844a53f8679a.camel@arm.com>
References: <20260226155515.1164292-1-sascha.bischoff@arm.com>
	 <20260226155515.1164292-10-sascha.bischoff@arm.com>
	 <86bjh57xuy.wl-maz@kernel.org>
In-Reply-To: <86bjh57xuy.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DBAPR08MB5687:EE_|PAXPR08MB6592:EE_|AMS0EPF000001A5:EE_|AS2PR08MB8574:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d5b1bf4-cb26-48de-e7d4-08de79499a71
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 9+lWg7HngvZ2GPPzjBCmJB+URGbLu7QGatqG+eLfgqUNGWuuHYHCC7gfr0MsnKp7hNwFU9RT/euA8a1o2fXpCgR0vHoiDTunTgydBD/CVQVzzUD3tt0EcSabrpnx77i08hgkQFar7hVN+1o8MQ2yp8Z3CL/V/WL+KOhP9Q+fsOoUwbtZywnHVv28tk5v/6rbsq1VfM8BD96gzh9VhSDcWSmN7kP300EKJx1TXjeWfOmABOEITFR12wf4+3w3c+4XZ/m0YoQ+Fh6cBJCx3RogIby49vzZu8+7NKjosyk9TOZnH59L+iDluQb+elEubpx672DrL6XAxptBd/G2KuwDH/bzMvNdvF8YjeCTpBzwoI1DJCJKluSfLz/YrGkKfCaK6IYp4mtEgZSPcfY5fOcufJG2lmgs4KSvJ503+SLhHNjVKhixrh+wx/bimcIM9fDEqRVTt9UPLfYRI+i5flKFxuacsY2V4J7HPSJMGWbXHHRiTqyoSozmdFBdWSflgsEK2yz/0Xao7529gC2p0QCOfK3rk0gsGij6qcFa9TKLh9Ug1CDkIEa9DMSjSqmEdQD2w+4AZrWAUW0wJOwq0Wyr4VeP42Z4mRFPojnxCQKP6BBuEeQrM3algMNnzgKBHFy6QvjIj+3mAeq+t3G95+BuEAALLDnLg875VaAJgm02tWhF03i2gf6vEawrrwCANzVhkOg5IVW/6HKURmbDL7/tkUsk58vdpBPcE4K/ad5oyBHOD5K+QYMAHKSUzJ1aka6Xc0HUzFn+MmJs2L2OprLTqoiC4BtgL8mRIGxSDVjsdmM=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <501821091B5DB1408E2E8E4AC6A0895D@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6592
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A5.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bd51b85d-4acc-48c2-9a86-08de794974eb
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	luaP38oDKFCMwgxk+5NhqWbpmHyn2u335TY+5hXBwiX/v8O2BQNsRkChwCGYJ3t64sNZ0Vl1aeOiQDBUldbdPKYkjHjfMduBtnQVmsSjTWRrnYpiqy92u6QmLpywuzKgmh63WB4MsHnubFJp0OBoywRsRm1B7T84OJlDjibk777i7C2G6xq21pZyr6mRFCownBpY0D5GWSyoTAFryrc5vLeN2t2OnntBYscGw4QOKeez2T/2fA6qZpRBopVLYsS76ZHCrx2FPDtjFkgvFJls0ayciblpXJBz4kGtu+JJQAXd1bEKZjaknqwH4xqO3rKLl14WMryYcge3Il4lhoONZInAUOfWu7W/Ck6CVkI3fAOhBnqYPmLm95/HX1BqlHNqXywIPAhwLFUvtWd7QN3ewr5BeIRbyLP2ZJx1Hg2C3H8OoX/ZuUbzwztUYiL8oFOn0ojPeXd2+LE3PqnPY2PSAcREp6U28Lm7j44QtAagonXWt3Txoo5ujbHbljeo4gQ74eqQAa8vPGkbkUyh1TlfFxHbq7lpvRxrbmceNBZ1K9K4i1aJwr4Dsqc9Vn7E1X/lCaQVj5aOVRzCqDonsLk6eXgV1SRFZfYdue9mRfjsyTZ1dDXenmOR3fzZKILt2Z/Khlyk70ubPgkaBMyTJEvXV+mZnvHcHUJb815x74aG236hOD5FBl1gWYZepGfmjsYv8fKdAUnXlNm0OsCUzU/1s7fCoBYu1Syk6K3Oc8TFApZrDvmScyKpmedND/Q4488nGXBFJiAS3mv4aeA78+g3VZFRzbuGCqOQz+pWHiMvYaRTzPh6UQb7MzGR1jCq5XPC7tVDd2wncH9MaJnQ8zEzWQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NB6p50U2pmjyXvjmUHXKgCzIKR4h9Fheg06hyblaE7fCuN+P7nfkEDFYaLYeREcPwSL2QiBkvmpQan+VAyuHpEJOjOtbl0+IehL7IHREELI1RFbLzq1XeV1v6wX7B/9KLBCi7Siie3R3XAbNgGPTj9SCPz0hwm+8UYR5WePBwzIi1V0cZWmll+PnKFOtylwzRWRL1bXlAkWggS7gVAmZE8KfU26xIAA4Lq/VhaWw+FDIONaBnqRT1AuAofXGk0Ynk7WMHKNfROh6NelL+92FlHcyC35KBWzxaC7mnAOWIG6ndXWs8P3K1Do/hGKh2YSEoxyV71eGunC/DbLbqc0dGlhTEibXNhUR6p5Q1ZtfbS4V5v4cYOATDZHaXfgMwzgFCDAJWViI81TZlzvUXL64g+vzxm64nTgKMF7cL1s1b5jfcX0kllYgXZ0w1KLA16EH
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 17:23:36.2858
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d5b1bf4-cb26-48de-e7d4-08de79499a71
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A5.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8574
X-Rspamd-Queue-Id: 3AE671F499A
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
	TAGGED_FROM(0.00)[bounces-72551-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,arm.com:dkim,arm.com:email,arm.com:mid,huawei.com:email];
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
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAzLTAzIGF0IDE1OjEwICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIFRodSwgMjYgRmViIDIwMjYgMTU6NTc6NDUgKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEFzIHBhcnQgb2YgYm9v
dGluZyB0aGUgc3lzdGVtIGFuZCBpbml0aWFsaXNpbmcgS1ZNLCBjcmVhdGUgYW5kDQo+ID4gcG9w
dWxhdGUgYSBtYXNrIG9mIHRoZSBpbXBsZW1lbnRlZCBQUElzLiBUaGlzIG1hc2sgYWxsb3dzIGZ1
dHVyZQ0KPiA+IFBQSQ0KPiA+IG9wZXJhdGlvbnMgKHN1Y2ggYXMgc2F2ZS9yZXN0b3JlIG9yIHN0
YXRlLCBvciBzeW5jaW5nIGJhY2sgaW50byB0aGUNCj4gPiBzaGFkb3cgc3RhdGUpIHRvIG9ubHkg
Y29uc2lkZXIgUFBJcyB0aGF0IGFyZSBhY3R1YWxseSBpbXBsZW1lbnRlZA0KPiA+IG9uDQo+ID4g
dGhlIGhvc3QuDQo+ID4gDQo+ID4gVGhlIHNldCBvZiBpbXBsZW1lbnRlZCB2aXJ0dWFsIFBQSXMg
bWF0Y2hlcyB0aGUgc2V0IG9mIGltcGxlbWVudGVkDQo+ID4gcGh5c2ljYWwgUFBJcyBmb3IgYSBH
SUN2NSBob3N0LiBUaGVyZWZvcmUsIHRoaXMgbWFzayByZXByZXNlbnRzIGFsbA0KPiA+IFBQSXMg
dGhhdCBjb3VsZCBldmVyIGJ5IHVzZWQgYnkgYSBHSUN2NS1iYXNlZCBndWVzdCBvbiBhIHNwZWNp
ZmljDQo+ID4gaG9zdC4NCj4gPiANCj4gPiBPbmx5IGFyY2hpdGVjdGVkIFBQSXMgYXJlIGN1cnJl
bnRseSBzdXBwb3J0ZWQgaW4gS1ZNIHdpdGgNCj4gPiBHSUN2NS4gTW9yZW92ZXIsIGFzIEtWTSBv
bmx5IHN1cHBvcnRzIGEgc3Vic2V0IG9mIGFsbCBwb3NzaWJsZSBQUElTDQo+ID4gKFRpbWVycywg
UE1VLCBHSUN2NSBTV19QUEkpIHRoZSBQUEkgbWFzayBvbmx5IGluY2x1ZGVzIHRoZXNlIFBQSXMs
DQo+ID4gaWYNCj4gPiBwcmVzZW50LiBUaGUgdGltZXJzIGFyZSBhbHdheXMgYXNzdW1lZCB0byBi
ZSBwcmVzZW50OyBpZiB3ZSBoYXZlDQo+ID4gS1ZNDQo+ID4gd2UgaGF2ZSBFTDIsIHdoaWNoIG1l
YW5zIHRoYXQgd2UgaGF2ZSB0aGUgRUwxICYgRUwyIFRpbWVyIFBQSXMuIElmDQo+ID4gd2UNCj4g
PiBoYXZlIGEgUE1VICh2MyksIHRoZW4gdGhlIFBNVUlSUSBpcyBwcmVzZW50LiBUaGUgR0lDdjUg
U1dfUFBJIGlzDQo+ID4gYWx3YXlzIGFzc3VtZWQgdG8gYmUgcHJlc2VudC4NCj4gPiANCj4gPiBT
aWduZWQtb2ZmLWJ5OiBTYXNjaGEgQmlzY2hvZmYgPHNhc2NoYS5iaXNjaG9mZkBhcm0uY29tPg0K
PiA+IFJldmlld2VkLWJ5OiBKb25hdGhhbiBDYW1lcm9uIDxqb25hdGhhbi5jYW1lcm9uQGh1YXdl
aS5jb20+DQo+ID4gLS0tDQo+ID4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuY8KgwqDC
oMKgwqAgfCAzMA0KPiA+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+IMKgaW5j
bHVkZS9rdm0vYXJtX3ZnaWMuaMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgNSArKysrKw0K
PiA+IMKgaW5jbHVkZS9saW51eC9pcnFjaGlwL2FybS1naWMtdjUuaCB8IDEwICsrKysrKysrKysN
Cj4gPiDCoDMgZmlsZXMgY2hhbmdlZCwgNDUgaW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiA+IGRpZmYg
LS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IGIvYXJjaC9hcm02NC9r
dm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBpbmRleCA5ZDlhYTU3NzRlNjM0Li4yYzUxYjliYTRmMTE4
IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gKysr
IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBAQCAtOCw2ICs4LDM0IEBADQo+
ID4gwqANCj4gPiDCoCNpbmNsdWRlICJ2Z2ljLmgiDQo+ID4gwqANCj4gPiArc3RhdGljIHN0cnVj
dCB2Z2ljX3Y1X3BwaV9jYXBzIHBwaV9jYXBzOw0KPiA+ICsNCj4gPiArLyoNCj4gPiArICogTm90
IGFsbCBQUElzIGFyZSBndWFyYW50ZWVkIHRvIGJlIGltcGxlbWVudGVkIGZvciBHSUN2NS4NCj4g
PiBEZXRlcmVybWluZSB3aGljaA0KPiA+ICsgKiBvbmVzIGFyZSwgYW5kIGdlbmVyYXRlIGEgbWFz
ay4NCj4gPiArICovDQo+ID4gK3N0YXRpYyB2b2lkIHZnaWNfdjVfZ2V0X2ltcGxlbWVudGVkX3Bw
aXModm9pZCkNCj4gPiArew0KPiA+ICsJaWYgKCFjcHVzX2hhdmVfZmluYWxfY2FwKEFSTTY0X0hB
U19HSUNWNV9DUFVJRikpDQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkg
KiBJZiB3ZSBoYXZlIEtWTSwgd2UgaGF2ZSBFTDIsIHdoaWNoIG1lYW5zIHRoYXQgd2UgaGF2ZQ0K
PiA+IHN1cHBvcnQgZm9yIHRoZQ0KPiA+ICsJICogRUwxIGFuZCBFTDIgUCAmIFYgdGltZXJzLg0K
PiANCj4gbml0OiBwbGVhc2Ugc3BlbGwgb3V0IHBoeXNpY2FsIGFuZCB2aXJ0dWFsLg0KDQpEb25l
Lg0KDQo+IA0KPiA+ICsJICovDQo+ID4gKwlwcGlfY2Fwcy5pbXBsX3BwaV9tYXNrWzBdIHw9DQo+
ID4gQklUX1VMTChHSUNWNV9BUkNIX1BQSV9DTlRIUCk7DQo+ID4gKwlwcGlfY2Fwcy5pbXBsX3Bw
aV9tYXNrWzBdIHw9IEJJVF9VTEwoR0lDVjVfQVJDSF9QUElfQ05UVik7DQo+ID4gKwlwcGlfY2Fw
cy5pbXBsX3BwaV9tYXNrWzBdIHw9DQo+ID4gQklUX1VMTChHSUNWNV9BUkNIX1BQSV9DTlRIVik7
DQo+ID4gKwlwcGlfY2Fwcy5pbXBsX3BwaV9tYXNrWzBdIHw9IEJJVF9VTEwoR0lDVjVfQVJDSF9Q
UElfQ05UUCk7DQo+ID4gKw0KPiA+ICsJLyogVGhlIFNXX1BQSSBzaG91bGQgYmUgYXZhaWxhYmxl
ICovDQo+ID4gKwlwcGlfY2Fwcy5pbXBsX3BwaV9tYXNrWzBdIHw9DQo+ID4gQklUX1VMTChHSUNW
NV9BUkNIX1BQSV9TV19QUEkpOw0KPiA+ICsNCj4gPiArCS8qIFRoZSBQTVVJUlEgaXMgYXZhaWxh
YmxlIGlmIHdlIGhhdmUgdGhlIFBNVSAqLw0KPiA+ICsJaWYgKHN5c3RlbV9zdXBwb3J0c19wbXV2
MygpKQ0KPiA+ICsJCXBwaV9jYXBzLmltcGxfcHBpX21hc2tbMF0gfD0NCj4gPiBCSVRfVUxMKEdJ
Q1Y1X0FSQ0hfUFBJX1BNVUlSUSk7DQo+ID4gK30NCj4gPiArDQo+ID4gwqAvKg0KPiA+IMKgICog
UHJvYmUgZm9yIGEgdkdJQ3Y1IGNvbXBhdGlibGUgaW50ZXJydXB0IGNvbnRyb2xsZXIsIHJldHVy
bmluZyAwDQo+ID4gb24gc3VjY2Vzcy4NCj4gPiDCoCAqIEN1cnJlbnRseSBvbmx5IHN1cHBvcnRz
IEdJQ3YzLWJhc2VkIFZNcyBvbiBhIEdJQ3Y1IGhvc3QsIGFuZA0KPiA+IGhlbmNlIG9ubHkNCj4g
PiBAQCAtMTgsNiArNDYsOCBAQCBpbnQgdmdpY192NV9wcm9iZShjb25zdCBzdHJ1Y3QgZ2ljX2t2
bV9pbmZvDQo+ID4gKmluZm8pDQo+ID4gwqAJdTY0IGljaF92dHJfZWwyOw0KPiA+IMKgCWludCBy
ZXQ7DQo+ID4gwqANCj4gPiArCXZnaWNfdjVfZ2V0X2ltcGxlbWVudGVkX3BwaXMoKTsNCj4gPiAr
DQo+ID4gwqAJaWYgKCFjcHVzX2hhdmVfZmluYWxfY2FwKEFSTTY0X0hBU19HSUNWNV9MRUdBQ1kp
KQ0KPiA+IMKgCQlyZXR1cm4gLUVOT0RFVjsNCj4gPiDCoA0KPiA+IGRpZmYgLS1naXQgYS9pbmNs
dWRlL2t2bS9hcm1fdmdpYy5oIGIvaW5jbHVkZS9rdm0vYXJtX3ZnaWMuaA0KPiA+IGluZGV4IGYx
MmI0N2U1ODlhYmMuLjllNDc5ODMzM2I0NmMgMTAwNjQ0DQo+ID4gLS0tIGEvaW5jbHVkZS9rdm0v
YXJtX3ZnaWMuaA0KPiA+ICsrKyBiL2luY2x1ZGUva3ZtL2FybV92Z2ljLmgNCj4gPiBAQCAtNDEw
LDYgKzQxMCwxMSBAQCBzdHJ1Y3QgdmdpY192M19jcHVfaWYgew0KPiA+IMKgCXVuc2lnbmVkIGlu
dCB1c2VkX2xyczsNCj4gPiDCoH07DQo+ID4gwqANCj4gPiArLyogV2hhdCBQUEkgY2FwYWJpbGl0
aWVzIGRvZXMgYSBHSUN2NSBob3N0IGhhdmUgKi8NCj4gPiArc3RydWN0IHZnaWNfdjVfcHBpX2Nh
cHMgew0KPiA+ICsJdTY0CWltcGxfcHBpX21hc2tbMl07DQo+ID4gK307DQo+ID4gKw0KPiA+IMKg
c3RydWN0IHZnaWNfY3B1IHsNCj4gPiDCoAkvKiBDUFUgdmlmIGNvbnRyb2wgcmVnaXN0ZXJzIGZv
ciB3b3JsZCBzd2l0Y2ggKi8NCj4gPiDCoAl1bmlvbiB7DQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1
ZGUvbGludXgvaXJxY2hpcC9hcm0tZ2ljLXY1LmgNCj4gPiBiL2luY2x1ZGUvbGludXgvaXJxY2hp
cC9hcm0tZ2ljLXY1LmgNCj4gPiBpbmRleCBiNzg0ODhkZjZjOTg5Li4xZGMwNWFmY2FiNTNlIDEw
MDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvbGludXgvaXJxY2hpcC9hcm0tZ2ljLXY1LmgNCj4gPiAr
KysgYi9pbmNsdWRlL2xpbnV4L2lycWNoaXAvYXJtLWdpYy12NS5oDQo+ID4gQEAgLTI0LDYgKzI0
LDE2IEBADQo+ID4gwqAjZGVmaW5lIEdJQ1Y1X0hXSVJRX1RZUEVfTFBJCQlVTCgweDIpDQo+ID4g
wqAjZGVmaW5lIEdJQ1Y1X0hXSVJRX1RZUEVfU1BJCQlVTCgweDMpDQo+ID4gwqANCj4gPiArLyoN
Cj4gPiArICogQXJjaGl0ZWN0ZWQgUFBJcw0KPiA+ICsgKi8NCj4gPiArI2RlZmluZSBHSUNWNV9B
UkNIX1BQSV9TV19QUEkJCTB4Mw0KPiA+ICsjZGVmaW5lIEdJQ1Y1X0FSQ0hfUFBJX1BNVUlSUQkJ
MHgxNw0KPiA+ICsjZGVmaW5lIEdJQ1Y1X0FSQ0hfUFBJX0NOVEhQCQkweDFhDQo+ID4gKyNkZWZp
bmUgR0lDVjVfQVJDSF9QUElfQ05UVgkJMHgxYg0KPiA+ICsjZGVmaW5lIEdJQ1Y1X0FSQ0hfUFBJ
X0NOVEhWCQkweDFjDQo+ID4gKyNkZWZpbmUgR0lDVjVfQVJDSF9QUElfQ05UUAkJMHgxZQ0KPiAN
Cj4gQ291bGQgeW91IGR1bXAgYWxsIHRoZSBhcmNoaXRlY3RlZCBQUEkgbnVtYmVycyBmcm9tIFJf
WERWQ00gaGVyZSwNCj4gZXZlbg0KPiBpZiB0aGV5IGFyZSBub3QgZGlyZWN0bHkgcmVsZXZhbnQg
dG8gS1ZNPyBJJ20gcHJldHR5IHN1cmUgc29tZW9uZQ0KPiB3aWxsDQo+IGZpbmQgdGhlbSB1c2Vm
dWwgYXQgc29tZSBwb2ludC4uLg0KDQpBbHNvIGRvbmUuDQoNClRoYW5rcywNClNhc2NoYQ0KDQo+
IA0KPiBUaGFua3MsDQo+IA0KPiAJTS4NCj4gDQoNCg==

