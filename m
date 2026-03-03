Return-Path: <kvm+bounces-72550-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yEDZE/cYp2m+dgAAu9opvQ
	(envelope-from <kvm+bounces-72550-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 18:23:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B31521F4934
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 18:23:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0359D3013EE7
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 17:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E693C3537F6;
	Tue,  3 Mar 2026 17:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dR4pcrUg";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dR4pcrUg"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013058.outbound.protection.outlook.com [40.107.162.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07B03537E9
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 17:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.58
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772558578; cv=fail; b=lNLwMtPGUL++mWH8O5wWGXD45pjdT+AGwJAqgvrbTkZja5+KR6qnzE7kwnS3gefiaBYa6hfPeaq/7oFPIxEhD13PfxzojOp+dzdWFCsk0a0SH30QoT9fIzhGL6dDk8LKcgRqNBw53ecnN9/VHjudbsUWIacWL+m5RdFi3Mc8LVw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772558578; c=relaxed/simple;
	bh=xKx/O5nUYL3MyQEOZIm9kuKtKLH8k367jx4K6pnWmtM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rpL0GCNTo/fcUm5m73C++ZumaWEGdoZfcWepse2s7QQk3g4MP9F0q3dUSKzYv2ZYJy0oHtZ18ROCznJB8kpG0lA4fZcEPMmX2bDAzeMmMg8vbYOvK70vxT92OCQXA7YdmsxzPY6vjThvANX3Nqj/S32ahPjjX7T3bVDmc+NeleU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dR4pcrUg; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dR4pcrUg; arc=fail smtp.client-ip=40.107.162.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Y34o9l1WGL1nQFhJx4kTfFCbyPS4kb2niEXBQrgTjJpmtL5IHHjQNOw9q1IAVbzALm93SoKOR2p1PFaVsemsfwdxjQgUYvFFQ0OEuicwmtVjsmOzv31YnTmsXW/Y1gXk9pbBSfIKrK7W5A4OzT1NdL0FQgJDkk7aWLtJMXHG8pbVMbBd0ZL81YFFEUiUUy5IUtpPxSrHmz/zk5IEn80SAmtMKdzoPhZGzN4UehTRDkBJdIgs0PLYKTQQxuigQ3iPsNsABmyWXp86R+MmUM7NqwuN9nqOD2cCSCac4ltHFS7n92g1nmi0HMC87tuuj6XabWSz0KVjts3M3srvtvLv/w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xKx/O5nUYL3MyQEOZIm9kuKtKLH8k367jx4K6pnWmtM=;
 b=D9aokUJYVy2tYOBIa5aenfowwe7EJRqugOoig0sJ1VILIRWYb/oEtXfgG2q/XMcH9GOog0okEuvUA50vKN2m+6IUFp8hFo0WHkb76wXH3nuZ2QTYfWrgzzSV+R/+rIWeB7nk/MnDNBHYagNBoqg+tVM8iell4YAbGiQX2r3AmJ5QPrkNN257XEH8lKdouTjsaeQ9c45HaBdfpKm6LKuGdKd05fEzv9sMJzMjigsWN8l9ywJQZyfwd5s66rBguqSV4VDx2BNmmxmFrGZA98ZRn2mA9cYgvHQmNR/sap7lclOjk852tp1FElf0Q79OYTvcJmDAAOJf/dBsSu3l46m+1Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKx/O5nUYL3MyQEOZIm9kuKtKLH8k367jx4K6pnWmtM=;
 b=dR4pcrUgpbeQYctWHbOwWPvyZs7ya8eUbAHIIYV8zu7pUSW5/uJ9Fwumk79jyq3UA9r4H9jvl9RAT6MjSezt5UPrm+9B8B3tA4P41edrJQ+J3lhIoDtjvgpOS2a/Bd89cCq8OH2OwKHs/M1BeCphinTLNc/XYPfL6bAMs0NYIRQ=
Received: from AM6P195CA0006.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:81::19)
 by FRZPR08MB10999.eurprd08.prod.outlook.com (2603:10a6:d10:13a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 17:22:49 +0000
Received: from AM1PEPF000252DF.eurprd07.prod.outlook.com
 (2603:10a6:209:81:cafe::bd) by AM6P195CA0006.outlook.office365.com
 (2603:10a6:209:81::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.18 via Frontend Transport; Tue,
 3 Mar 2026 17:22:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DF.mail.protection.outlook.com (10.167.16.57) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.16
 via Frontend Transport; Tue, 3 Mar 2026 17:22:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HAk51H9e7YmAFbuGk7A5YW2aWlS9eNnPuNKB0/Uo/KkLfrcG/A88BTs8FHn7FWzHq903/TuTViRXZPdLcCCZTRoC2yp7CvQG2Ji3b93XXaId6UV85a6iBgrzSYnlwIxidTEC2A5REVprUEKCE5nW1FQI4xgBY9JxeSp1VGC+qHEc7cqqYw5dV+9UiOQM6/eufCfi7k3MdqeH/c6DeXozAAqt3CCuM8pshi0i3Y8eHHvJVzrLys0SrtQhTx0iT78oyEpIVZNmadYriRNBG4He0DuMfu0oKGuLQHiHq/nRtWp87xCbngzUk2kU7MEMm2a25Iy3X3OiLlQBl8A4TteN+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xKx/O5nUYL3MyQEOZIm9kuKtKLH8k367jx4K6pnWmtM=;
 b=wt8hncbh7fD1J9LQ6jF6Ii0532bDS9kjNwAiZu89MwFFcC0G7JQIKwMRn0TiLY3XCF17O6IM3ZN5O/guPT4ENUz9fMFDBh+UwdERJmIAwVsyr4LiaovYAAmk4gVkUpdlpoKU2eJDdXkFeLwoHWzh6aaUT286Jw8RMqktDdsGc6mT513wgIcnAKSB92ey82ER5vnXsMIEQc4J7fxg6vVesGdqAf6jhA9a4fRf2PvMR/NTvtKSzTRNXTy6Tl16rzey/2T9Akw1evby6QAzeVC4JNxrCrC5ynDiw7mNXYxx5DmFKm1uKuKS5y2qp1dfjwg/gEG6YoA6KbpV6odUSVpd4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKx/O5nUYL3MyQEOZIm9kuKtKLH8k367jx4K6pnWmtM=;
 b=dR4pcrUgpbeQYctWHbOwWPvyZs7ya8eUbAHIIYV8zu7pUSW5/uJ9Fwumk79jyq3UA9r4H9jvl9RAT6MjSezt5UPrm+9B8B3tA4P41edrJQ+J3lhIoDtjvgpOS2a/Bd89cCq8OH2OwKHs/M1BeCphinTLNc/XYPfL6bAMs0NYIRQ=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by PAXPR08MB6592.eurprd08.prod.outlook.com (2603:10a6:102:158::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 17:21:46 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 17:21:46 +0000
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
Subject: Re: [PATCH v5 07/36] KVM: arm64: gic: Introduce interrupt type
 helpers
Thread-Topic: [PATCH v5 07/36] KVM: arm64: gic: Introduce interrupt type
 helpers
Thread-Index: AQHcpziT3fzselMNikaB/ISa0/5QPbWc744AgAAmbIA=
Date: Tue, 3 Mar 2026 17:21:46 +0000
Message-ID: <f743ad814848e4e2a7b6e41bcfa62d51026e2f72.camel@arm.com>
References: <20260226155515.1164292-1-sascha.bischoff@arm.com>
	 <20260226155515.1164292-8-sascha.bischoff@arm.com>
	 <86cy1l7y4x.wl-maz@kernel.org>
In-Reply-To: <86cy1l7y4x.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DBAPR08MB5687:EE_|PAXPR08MB6592:EE_|AM1PEPF000252DF:EE_|FRZPR08MB10999:EE_
X-MS-Office365-Filtering-Correlation-Id: e60222af-8d22-42e3-28bb-08de79497e79
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 iLvWUoQymxFV68pqfIjkIFkvrkUMjeE1yS8gmXXc7KQ1F6x/PxCirExrSCIsEd/OgwlupIuxIhE9jVHDBSh7+HjAMua+rJ1dRZS1JXlU5ZrLkjTvhIKf+OXOec2hMlOBrAp5D1qdAc+imBPhvxT3X0CSS2yl8l64ItwVKd8BFtUn2ZUCjk7FzHoc4IEnD3i01PuWHbSMVhWvpK2NFJ30ydN7tSa+X4DsSAJtukST9VqO35G5iKOpHNxgmw7SUpogcdPuijfLKElMy8P8tpgDF17xdy0PMRRl42UIyAMxc3cfivbpH98fCWNsvC/cfEcY3cdsn0geDkSd8T9rnW1+uU9jzYgfl2vKgtZhAVOUjf3N1T/LTekEtdTxHc5MPdgZNCftSulOul6j5bsklAN76mGKK4J2rKcrBhWLctj3tb8Qvriwhob29yAOnW3JnYsIkkKomyr9EXcWp0TTnY+sSJrAXaa6mCUKgli+UopsOAWFq07FYnWO6gBrYm9AyFoixt5LGeZXcOgx0N0S//rI9Mp3mcGiBtNp2TKjVvockrbsGH1ACJ2Yc5Lp7+6tw3AMuPXFiL1Fp1r4RHkH2A1hFtr3CYsLy/FaHpytLrF/Toh6+S3hTESLqWrhmFY1Sc48xVoqCUxOAWmWdd8mzJRezix8/7KecTINA8Gd5m2bgNKV32PC7O79u5Iwj7biKh3oNwgohI9tJzSbOLaaZmzFMjVf/BBf9oJ0DBM4/G2qk7ALPbG4NVE4Qp3p5gDsOBBsEJWXxqSE/KQcG1qlAYDRUb8Wcspq6oOiIFenYjLKwB8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <B45FE71BEADA7644BB3862790FD35DED@eurprd08.prod.outlook.com>
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
 AM1PEPF000252DF.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	500e734a-ff0c-4393-f836-08de794958ed
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|36860700013|376014|14060799003|82310400026;
X-Microsoft-Antispam-Message-Info:
	obfOuTAPxGqEBkalMboEvxA0wogQb/ESCFsBNK55EouZcChLWxz67r5Rf5QM6tR2UkYgZ5P4gabdPIFGPxVY2b8HJssPGuFuraf4W2e5Eoza7QDAY+AWYLD8IM39ae7mYh+dVh7LuUXvDHawstcn7ZTApLNeiylNFz0GWA4k6NoKDRTWagLWUL9zA5ItO2VrpU/91x2RFe2nHZPkdQyo1zUHA0uWwcs2mSCGHvjzMFtGs4JOqpmz5nIGjoiksMM8lurijaCZvnK/sBbcUKIGFTKUBD2CBDEZJ281qMDlmGc/JY3n5XQeN4UM0y26/3ni8axPkF4RoHutULvMzUS4vpeG55knTO98rMLBn6ArcYsO3wlEjsTPY2s0pBZEz2cpjUVTS5FG1GqaGFQdx7ohBEFP5rOPqmt8UP1dd87IPcMcyPnR93QIJ9Oo+saTwIx4ap/zsLdmRpXova1OITZbLbNVWx5MtuebjLimgvC4lM3pNZejXx/gBW6+P+qA30FX44t0x6FqdLic8wTZILiSgE7yu5LfIowd7jPk2fZiarQVGEfsRWwK0/L8rUBvPI0qaFY2T7/n6/5wvhl8EloJM1mm9EHe0815gnzjtej2cP3LP6k1OOuM5o1TszT9HOCRrEit4uooZ20ICh0vcvJ14m5VxLrWA4Q79cgEup7Dp6mhGMqRWhtVQNbpBt8Iti/TxjOdfVu4PCdKpch1GiSVViTzZCjKv94j7xlJwuyGo6D37KhgGZi56LU7gQ4Mj311PH/JuKXwwHVhdfBzCc1xVzlytnDmxQOoQfPl/E9Z9q4pycuVBprciHWGJz3tZEIb+wch2O5bEFJGma5/sr+Tqg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(36860700013)(376014)(14060799003)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UQtVucEborlLvaPF/XaAPhRKF80l0qkvTY8rSWR20Uz4PKmQHGlaUnYrLAK+GRUGcCxcQH8SnVDaGcHSjbmF5bQhlOZoKDixJEll2pfWXT6QtEE1v3Hf5lszEYrdQwBaW6VuuH1tTic9xQPxi8fmnVjbhYGEwWI1lAf1ivfeiHnzObK7PUarLEKCf5taVmiEKgfkUc2Axya1QYYB2VUk3RaNkO34mm1FhX5stWPzDEtbigRa5urpCUSEJDKM687OySgoHmMHidoVjPhUJsEf6hSqsOU15rH+nmbpD2VxQujJ/2UGFKNbUanTXGhRfEXE6UyUk94Vl1VNX1P1c9riR/oURW/lzaqLflJzo58ggghERTsexziJJHCEdq8hg8mVtYTNH2KbNuUFnG4eHNViL8VB9jVexTNjGqyuBhcX3HtDmOAMIHuBxk5v54IaspnT
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 17:22:49.3592
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e60222af-8d22-42e3-28bb-08de79497e79
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DF.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRZPR08MB10999
X-Rspamd-Queue-Id: B31521F4934
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
	TAGGED_FROM(0.00)[bounces-72550-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,arm.com:dkim,arm.com:email,arm.com:mid];
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
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAzLTAzIGF0IDE1OjA0ICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIFRodSwgMjYgRmViIDIwMjYgMTU6NTc6MTQgKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEdJQ3Y1IGhhcyBtb3Zl
ZCBmcm9tIHVzaW5nIGludGVycnVwdCByYW5nZXMgZm9yIGRpZmZlcmVudCBpbnRlcnJ1cHQNCj4g
PiB0eXBlcyB0byB1c2luZyBzb21lIG9mIHRoZSB1cHBlciBiaXRzIG9mIHRoZSBpbnRlcnJ1cHQg
SUQgdG8gZGVub3RlDQo+ID4gdGhlIGludGVycnVwdCB0eXBlLiBUaGlzIGlzIG5vdCBjb21wYXRp
YmxlIHdpdGggb2xkZXIgR0lDcyAod2hpY2gNCj4gPiByZWx5DQo+ID4gb24gcmFuZ2VzIG9mIGlu
dGVycnVwdHMgdG8gZGV0ZXJtaW5lIHRoZSB0eXBlKSwgYW5kIGhlbmNlIGEgc2V0IG9mDQo+ID4g
aGVscGVycyBpcyBpbnRyb2R1Y2VkLiBUaGVzZSBoZWxwZXJzIHRha2UgYSBzdHJ1Y3Qga3ZtKiwg
YW5kIHVzZQ0KPiA+IHRoZQ0KPiA+IHZnaWMgbW9kZWwgdG8gZGV0ZXJtaW5lIGhvdyB0byBpbnRl
cnByZXQgdGhlIGludGVycnVwdCBJRC4NCj4gPiANCj4gPiBIZWxwZXJzIGFyZSBpbnRyb2R1Y2Vk
IGZvciBQUElzLCBTUElzLCBhbmQgTFBJcy4gQWRkaXRpb25hbGx5LCBhDQo+ID4gaGVscGVyIGlz
IGludHJvZHVjZWQgdG8gZGV0ZXJtaW5lIGlmIGFuIGludGVycnVwdCBpcyBwcml2YXRlIC0gU0dJ
cw0KPiA+IGFuZCBQUElzIGZvciBvbGRlciBHSUNzLCBhbmQgUFBJcyBvbmx5IGZvciBHSUN2NS4N
Cj4gPiANCj4gPiBUaGUgaGVscGVycyBhcmUgcGx1bWJlZCBpbnRvIHRoZSBjb3JlIHZnaWMgY29k
ZSwgYXMgd2VsbCBhcyB0aGUNCj4gPiBBcmNoDQo+ID4gVGltZXIgYW5kIFBNVSBjb2RlLg0KPiA+
IA0KPiA+IFRoZXJlIHNob3VsZCBiZSBubyBmdW5jdGlvbmFsIGNoYW5nZXMgYXMgcGFydCBvZiB0
aGlzIGNoYW5nZS4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBTYXNjaGEgQmlzY2hvZmYgPHNh
c2NoYS5iaXNjaG9mZkBhcm0uY29tPg0KPiA+IFJldmlld2VkLWJ5OiBKb2V5IEdvdWx5IDxqb2V5
LmdvdWx5QGFybS5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IEpvbmF0aGFuIENhbWVyb24gPGpvbmF0
aGFuLmNhbWVyb25AaHVhd2VpLmNvbT4NCj4gPiAtLS0NCj4gPiDCoGFyY2gvYXJtNjQva3ZtL2Fy
Y2hfdGltZXIuY8KgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAyICstDQo+ID4gwqBhcmNoL2FybTY0
L2t2bS9wbXUtZW11bC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA3ICstDQo+ID4gwqBh
cmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMta3ZtLWRldmljZS5jIHzCoCAyICstDQo+ID4gwqBhcmNo
L2FybTY0L2t2bS92Z2ljL3ZnaWMuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCAxNCArKy0tDQo+
ID4gwqBpbmNsdWRlL2t2bS9hcm1fdmdpYy5owqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHwgOTINCj4gPiArKysrKysrKysrKysrKysrKysrKysrKysrLS0NCj4gPiDCoDUgZmlsZXMgY2hh
bmdlZCwgMTAwIGluc2VydGlvbnMoKyksIDE3IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiANCj4gWy4u
Ll0NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUva3ZtL2FybV92Z2ljLmggYi9pbmNsdWRl
L2t2bS9hcm1fdmdpYy5oDQo+ID4gaW5kZXggZjJlYWZjNjViYmY0Yy4uZjEyYjQ3ZTU4OWFiYyAx
MDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL2t2bS9hcm1fdmdpYy5oDQo+ID4gKysrIGIvaW5jbHVk
ZS9rdm0vYXJtX3ZnaWMuaA0KPiANCj4gWy4uLl0NCj4gDQo+ID4gKyNkZWZpbmUgdmdpY19pc192
NShrKSAoKGspLT5hcmNoLnZnaWMudmdpY19tb2RlbCA9PQ0KPiA+IEtWTV9ERVZfVFlQRV9BUk1f
VkdJQ19WNSkNCj4gDQo+IHZnaWNfaXNfdjMoKSBpcyBkZWZpbmVkIGluIGFyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy5oLCBhcyBhIGZ1bmN0aW9uDQo+IHJhdGhlciB0aGFuIGEgbWFjcm8uIFRoZXNl
IHRoaW5ncyBzaG91bGQgYWxsIGxpdmUgdG9nZXRoZXIsIGFuZA0KPiBwcmVmZXJhYmx5IGhhdmUg
c2ltaWxhciBpbXBsZW1lbnRhdGlvbiBzdHlsZXMuDQoNCkhpIE1hcmMsDQoNClRoYXQncyBhIGdv
b2Qgc2hvdXQuIEkndmUgbW92ZWQgdGhlIHZnaWNfaXNfdjMoKSB0byB0aGUgYXJtX3ZnaWMuaA0K
aGVhZGVyIChpdCBpcyBpbmNsdWRlZCBpbiBtb3JlIHBsYWNlcywgYW5kIG1ha2VzIHRoZSBoZWxw
ZXJzIG1vcmUNCnVzZWZ1bCB0aGFuIGluIGluIHZnaWMuaCkuIE1vcmVvdmVyLCBJJ3ZlIG1hZGUg
aXQgYSBtYWNybzoNCg0KKyNkZWZpbmUgX192Z2ljX2lzX3YoaywgdikgKChrKS0+YXJjaC52Z2lj
LnZnaWNfbW9kZWwgPT0gS1ZNX0RFVl9UWVBFX0FSTV9WR0lDX1YjI3YpDQorI2RlZmluZSB2Z2lj
X2lzX3YzKGspIChfX3ZnaWNfaXNfdihrLCAzKSkNCisjZGVmaW5lIHZnaWNfaXNfdjUoaykgKF9f
dmdpY19pc192KGssIDUpKQ0KDQpUaGFua3MsDQpTYXNjaGENCg0KPiANCj4gVGhhbmtzLA0KPiAN
Cj4gCU0uDQo+IA0KDQo=

