Return-Path: <kvm+bounces-68611-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aLecAhFfcGkVXwAAu9opvQ
	(envelope-from <kvm+bounces-68611-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 06:07:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 42D5651544
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 06:07:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1BF63869890
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 12:16:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B8A426D07;
	Tue, 20 Jan 2026 12:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="URDDuAp2";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="URDDuAp2"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010032.outbound.protection.outlook.com [52.101.84.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E3C426D34;
	Tue, 20 Jan 2026 12:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.32
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768911323; cv=fail; b=tq5brLQHkZX5rCKcILXK6SZ0Nwl/fGF5Lrd799JtK71TkuW7INKPjQqfmx1SOdykMV0ZCoFrTaHEhbzhzfNDlrMxLUM52GBnLBaZ9k0WoxnhBi8uzm5MjZCG1egf1cPWvr0HvCNzR+V2yGByio/IKtly6N2Re3iwGx5ffA+rayU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768911323; c=relaxed/simple;
	bh=zVSUtK3EGw1rfgVbTCc8HBqFndTBz/cYK3K5d0gkD+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r3L8NBS9jEWESHZ3Qtwvtw9y4j8tU7a1DmYchtH+W/EzcAkuWWKy89EmJ1q7fIapE6VfOP38GxYfhzsiisUnqKalcWri09UeDcjtAmBygpuIStmGDKiwZ5Pw9gH9kgE9GqBMGiFDt/ciHRKIAjNL+9X3KakcE8lxf/7HRhAC1yo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=URDDuAp2; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=URDDuAp2; arc=fail smtp.client-ip=52.101.84.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ITgZivrJp5W5I6ypQ8HRR9tlrzqztq7Ib6I2rAA3oXiYsuUSeUShvs+AJfvbuwwdrM2eZS3A6P4Pa6ysA2tTjkBqF6AepbwbAgGlV6vQrWQyBt47rT5XepQPpwZbQPFqS+U+TnkMLgaTzg+yofIgl4YYMF3Vt3L55RSZhm6vFXfq2qD77sr/PHesSNDdOWzHq2u856/hI6Q96kE9znaJlwYgxjU5YJUcd/r0f+gfeu3TrC/Ns0Jo4VL5kSVIhehxH8MibqhuoSofcOlWDMMEXQT+OGdB3ZKHrPA3o5HmMf37J0GL/O+T68YDoMmdkvFnze+2ulVEM3Zeq8S2B7e8Mg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G5NzfXaTuJb/vA1Us4OK4rNvJPgpu2TJEB2rrugo23U=;
 b=wdql0YJyCeDiypIXB0Ra0n6IN/27XEb0l6qPMQW9dndnZU5RUPzVE49BSwb8t1kov7Eo7fFfQhPmbcthvqcAcuIFsCemRMhIuFdyjSUlsSpBsmCeT0HMfxFNchkglpimMtTDmMuGrM50vYzGoPUJSwxJh3zd+AuUAiy4VeNVys/M5nlhC25x/P0NuiSJ4Kx1VxYevaAf0PVjS4gDK2UiC+jV3lkVJgLM0++6WbLHkbBzfunfPFnlac8j56tHSc+JUi2HaIiv8DxO3u1nbM/ffuUES0l44o1NiROtLwovmMQGSJt4tXbMwaLMF8J7p7qwdlvyHa1hha/3OBam3EqpNg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5NzfXaTuJb/vA1Us4OK4rNvJPgpu2TJEB2rrugo23U=;
 b=URDDuAp2Y2hy2DU9DEHHp2/BQPCHF26J1SC4peAj237DO64qrxzeHds5bCMADR7VErAHG4IwrJ58S2R1DZMd1BB7ig0m+/0up3WwulkPZW/oEzqrMyZQqPGRfBRZVqrGr602DawGOmlCv+L4fJhViEq5SY8Mgmlh970A+iZs/AA=
Received: from DB3PR08CA0001.eurprd08.prod.outlook.com (2603:10a6:8::14) by
 VI0PR08MB11709.eurprd08.prod.outlook.com (2603:10a6:800:310::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 12:15:16 +0000
Received: from DB1PEPF000509E7.eurprd03.prod.outlook.com
 (2603:10a6:8:0:cafe::7d) by DB3PR08CA0001.outlook.office365.com
 (2603:10a6:8::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.13 via Frontend Transport; Tue,
 20 Jan 2026 12:15:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E7.mail.protection.outlook.com (10.167.242.57) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Tue, 20 Jan 2026 12:15:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B3BAeherhfbtj+2QBEQFyHuZULI+m7JGhY2mqHFOxV4VqD3jDguKP3tFY33hBYxHgVwxeQ0er2Qce799UHqTyDBcxi0N9RX/z+vfu/OwJBlkj/VCRULpJ8GRPOUh6en5zYmsDcJWL9+0IW22dzwLcoBnYa0zQDrZaPgBlFjIyntWk0/IH/mVVcNZ4Le8u3qJbJ8J+rC61g57x+n5H1x6+t621fz/YCWgFNqvOW0R8vf980Nkhnv9+ZFRXsA0dqmHGxiUr+UJ2xSk4UrdEa5LMNDTHmtkbxizYkHEjqgeTfESJz9Sz1rzp9eihV0+B7uWmWn5fPDmz3rAcaz/a56ipg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G5NzfXaTuJb/vA1Us4OK4rNvJPgpu2TJEB2rrugo23U=;
 b=U5S9GXStLRYWWowNs5oGPlttM+1ev4XBm4bLk6i66wwlpl3iF6O0/XuSbU0Zr/A68TtTIAGjGgnn/d5+sUH+Npm/EWas7MuAFaOdM/mQ96ZiFFFPzMrz/ju5YIsZVH+e6z22b3nDr7BkGJ7Efd7EDQtPqkhb+tJQTA293GaGyLa6Ong4bnUc+WTaXg7VA1WEoo77FyRLkC1n+Xw07EULScqnWQ0a6M88KJQsIbLiM2/PQI08KHSN5Z1bJwMOE39H8/31WNha3Aw4kk/dEr4l0Kr/M+LqaIIXYSOxjCVsOh3AK7cBF+ajNFMkW23RukH1XmDTOP8kgTW0+k9b4d1i4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5NzfXaTuJb/vA1Us4OK4rNvJPgpu2TJEB2rrugo23U=;
 b=URDDuAp2Y2hy2DU9DEHHp2/BQPCHF26J1SC4peAj237DO64qrxzeHds5bCMADR7VErAHG4IwrJ58S2R1DZMd1BB7ig0m+/0up3WwulkPZW/oEzqrMyZQqPGRfBRZVqrGr602DawGOmlCv+L4fJhViEq5SY8Mgmlh970A+iZs/AA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DU0PR08MB9324.eurprd08.prod.outlook.com
 (2603:10a6:10:41f::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 12:14:11 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 12:14:11 +0000
Date: Tue, 20 Jan 2026 12:14:08 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	catalin.marinas@arm.com, broonie@kernel.org, oliver.upton@linux.dev,
	miko.lenczewski@arm.com, kevin.brodsky@arm.com, ardb@kernel.org,
	suzuki.poulose@arm.com, lpieralisi@kernel.org,
	yangyicong@hisilicon.com, scott@os.amperecomputing.com,
	joey.gouly@arm.com, yuzenghui@huawei.com, pbonzini@redhat.com,
	shuah@kernel.org, arnd@arndb.de,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v11 RESEND 9/9] arm64: armv8_deprecated: apply FEAT_LSUI
 for swpX emulation.
Message-ID: <aW9xkAyIKyrYzsCv@e129823.arm.com>
References: <20251214112248.901769-1-yeoreum.yun@arm.com>
 <20251214112248.901769-10-yeoreum.yun@arm.com>
 <86ms3knl6s.wl-maz@kernel.org>
 <aT/bNLQyKcrAZ6Fb@e129823.arm.com>
 <aW5O714hfl7DCl04@willie-the-truck>
 <aW6w6+B21NbUuszA@e129823.arm.com>
 <aW9O6R7v-ybhrm66@J2N7QTR9R3>
 <aW9T5b+Y2b2JOZHk@e129823.arm.com>
 <aW9sBkUVnpAkPkxN@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aW9sBkUVnpAkPkxN@willie-the-truck>
X-ClientProxiedBy: LO4P123CA0463.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::18) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DU0PR08MB9324:EE_|DB1PEPF000509E7:EE_|VI0PR08MB11709:EE_
X-MS-Office365-Filtering-Correlation-Id: 360c211a-49fd-4fd0-4bb5-08de581d91ff
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?ozmF7T3igNv29qs84pp3yYCWPzA4iP3tQQ5RXN3URBI1QRYRf3zcxYCwZalI?=
 =?us-ascii?Q?0y8UdUTU1I5PEIhK4gL0n58gwd38drCAFQjOpGTDLGof6HdNHc2iT8C+JRi1?=
 =?us-ascii?Q?75KOjmSPLQ3QJ00/ijoy+i51kxC7qJx2HfmWkrW6tEs1ID7WhqVI8zu7oPg1?=
 =?us-ascii?Q?1ZbVINs6JUYBFzDW4EAoZ7a6bhcfGYubzly4YH4DL6s8xsqMJXcPiKkZgzqw?=
 =?us-ascii?Q?0Mi4G7uV9KSWLo6UI/uH3L2YfMF038KpLH/NGDxZiBYgzorli/r0bAHOwMMp?=
 =?us-ascii?Q?ot5aE+1nNNGyb/m6yIjN1GzEmjzUT52FP50snKwA0febrNncZubvgdo1p3hB?=
 =?us-ascii?Q?nszbKvK9xtpPlDAABBLcm0rD8D9yWlye3O6IQGkC/xASQgfDVmVbmhJS/V77?=
 =?us-ascii?Q?/ano948UROwZpmb0u2Oh2CPhTbADm/JK501E8WoX6OV4G4PhIPPY9WJ0hcGA?=
 =?us-ascii?Q?ErEhGeu6pVlTy4zGDjWFLD5G/OVLMIF1+bybmH+T3PhBeZWfrOZi2ADUJVuj?=
 =?us-ascii?Q?x3HMz22c/IG2cCmQBVgZXBaxplFr4H2QCF0BgU/k9p5DWzn2hYtJTz4xhyb6?=
 =?us-ascii?Q?II0vhN5ESSRn7Qm5Opnm55eJUzKdcEz+XeUs0dfjYfF4+nC37iBStgyLRs16?=
 =?us-ascii?Q?yzy0jeuecTeia/zSD18WK9Ma2kzNOLsCCP0AAeoSQta7PD5c1bZ7xnv3uJru?=
 =?us-ascii?Q?/fVgp6BTPzpQHadAWlrR8V82Pj6BXQy8tpa38pII5BZsN0ghtC0VDnEl/uMd?=
 =?us-ascii?Q?sBhcOqF1PWwuppiSiV8sL7L6h40/PREJph1cOv5GEnOK4eFuFDrqJTzVibY0?=
 =?us-ascii?Q?iRsuUVSSU224EIroqeRu17FgH/mQ4uiFcWPXD4726p8UT5jb1MyxqIQiGjPb?=
 =?us-ascii?Q?41ujJh7VYUBxR/38UKUXiQrG2NNCVglRHb4D0B+lnqgNOlHP4zT55aqB+l0Q?=
 =?us-ascii?Q?UGlcjXaWWPv8dfJb0cKyf+nweJ6G4XHN7WdX1fNU3rTQPFGAo8JivNPDTD6n?=
 =?us-ascii?Q?PYdyqJz4sTRVKeLoDOvIek1dN2UmirUCUz9GAAaZNe8yBnlCmu1jR25yXKVm?=
 =?us-ascii?Q?yxu5YeTv7ZeLIngTi/gp6DuDsbrw9pc+VE3XargfaCnc2cPO9GB+ztiAO/Gy?=
 =?us-ascii?Q?pqqfG+STNMCXx8q9y6SBF0f+FrUalGnC/9S2qd9VaUSS1fDPm35TNYYG50OW?=
 =?us-ascii?Q?0SLAsT9RS+WH/Kd4dblyPHhhvuXISemDyDoRBdPFVjyuT1CNqUjxVXoUlvE0?=
 =?us-ascii?Q?Jb1LshjKKwU+CKRwujN7o8R+tFXu7eDKVtBk//yulN+DvuI67PQcuFs01ZKm?=
 =?us-ascii?Q?9xawGqqZ9TL8fxoyUwSXEGBh6qvtSnhdNmG+CTQuADIpvtBg5i0En4+s+oIO?=
 =?us-ascii?Q?kpAhizqFk2kOHQLJymQdCMHxPWvGRCeb4THGWR23jmuLwWIjGJgBCeRLqRHt?=
 =?us-ascii?Q?CIMQIDlMQbmP9gGIcrV0E/PGMEA5/sXPf0qrAeNVsuBQDkPh46QzPNVWW/3l?=
 =?us-ascii?Q?zfGmvf45t3ymIRKve3poORDW5YN7Ci6ljagYKI9CQBCJ7+MJqABkZc+FXGxf?=
 =?us-ascii?Q?PGNc50KFW+GtBk+N8hg=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9324
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E7.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1127ca8b-ce5e-4ae8-bf36-08de581d6b4f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|7416014|1800799024|36860700013|376014|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZyfsE9ueQ/47/TpqCdfqkiYyO8e6DBWyFS9PPIFkpo0rX2NPmEcDdaZzrIwQ?=
 =?us-ascii?Q?a8mdyJ4Ue4NZ9acyebtpUUPUn+2n0FLHjSIyy+KWld2w3g0YUGUDVOYh8ax/?=
 =?us-ascii?Q?a/NreEIY3/ETgOytdNEKE7zTtIKIgYmoVMV/lln9MKlUCbbFLPtLBuSbsXtx?=
 =?us-ascii?Q?SZHTndBYDphU4Jyw/x4J2VzLDp1nkCl8g5t9ByFaxZ1OjT89kbQ+e33keomn?=
 =?us-ascii?Q?ANS0vpUhaL3sT2r/U+18A/3F6Qrlqr+391aN0+oLkxdOMiH9qJ4BcfnCagiE?=
 =?us-ascii?Q?HiOtGTctuG0N3aUdq+H60ccsJKwBXKqV6B5gTNXn6gqNAdD5aQ7FuDHibPWf?=
 =?us-ascii?Q?0M3p6+6uk7/+OWTvlv8a33TPo4dgLryRR+Jpa4P4RDBprFHr/0gVWuwOWoGX?=
 =?us-ascii?Q?oCCd2s5qTot5hNpIaadVxkZxvPSTVkZuIO0cmAu/I9POq5HqDebytm6bHW5U?=
 =?us-ascii?Q?XOG/KkJ0odALt+NrD56L84OgE6vQxkgoSutSrgEkvDblyAmTE4pgOZY69Z8M?=
 =?us-ascii?Q?Qmut0/oNhmUK8xvcWdJzSgechIuV5KagR2F7TINNqxbhhuptwMG1PA5BFIQF?=
 =?us-ascii?Q?mVyzghWC/PHbe+O4GZljDHfVOi4/RxCoGS4La7tdWOVG4zz4/vOU6sPSvjjh?=
 =?us-ascii?Q?HH9hlK2M8GJKafh4GY1bpXTa9Zdcrwd/ktSK2LrdkaZjGLhGp1keA8Beit4Q?=
 =?us-ascii?Q?LjeAz/YJBe50mbfPeMjbWD3P3CIBPeeBwGJtzTY5HZbrpJnD4O26sqfy5Jqy?=
 =?us-ascii?Q?e4FVcTFUgJ9uU+fFikNXtvQvYq3rf3C4ZW1dKYfaT9yA0mcv63/UI22LLRkN?=
 =?us-ascii?Q?zsq0+pa3kZvaQJOGi9e1TQTzRnJk+FYTNz1zWdaEEMG8bDDJD/X5Oz+HO10O?=
 =?us-ascii?Q?u8y56SsK3ffvXvdeg/2VUjzMumhazRt9Ctv+m2B5Sd34mxrvKugTMG2Avl4V?=
 =?us-ascii?Q?Sdsce6AHSdwlA1BZLh26CKKmrCq6uYeiSEl6NCUta5Qmz4oH2kMWtNvyeTIh?=
 =?us-ascii?Q?ascKmUl8wiNqpI7vCLmOdH/poRKNCSwais2tCO7NL9vhuK1B7nl+EJYsdWvm?=
 =?us-ascii?Q?vBNGc4p66LtuYD7IMqpASVbL5iclTkozTxyMP7rpwi9FyqOuQOBinAPknsur?=
 =?us-ascii?Q?/UqTUrgBGXLh6RxF4xSIqnskHAJlzQZ/oq7jaYbfL8K6ehdjABYNptjgrWyM?=
 =?us-ascii?Q?Udbft61Yu/7fNK1fajt5ZvNyTqb3ZCokJ7eurnVF2/TDjbktTmDjFEVqV51q?=
 =?us-ascii?Q?UwJvrUilNr1bT6tsDUAWkbtmQGW4pmE4yfRehf7/21EIVWWDo97sNMG/jfvD?=
 =?us-ascii?Q?4RdHLO5u2znPfg8pL5XG84e4QkrA7/D1758QE0+UKsRkxggs+dC9RBBhQje4?=
 =?us-ascii?Q?NrAEyDKWWtnL5/EqHPsakqTfbQ3w4If3QeeQjOnNXIeVpa/WHsEjxX1QrMCb?=
 =?us-ascii?Q?nEBdwanp2Cdcnvyj5NLy3z+lqpT527JiNL23d1k4mTv/O1c3mshex5bP7XyP?=
 =?us-ascii?Q?7bmns0WGpkuPm54lpJROhRQlQQ57XYweIPobzY5y3egkhtTbve5L1O8BpM4i?=
 =?us-ascii?Q?+6w/pw4rcJo7wM+V7PhfZ9eoRiNQch5mdTgdSaRTNuc1N9/jgrK5B4e0HejA?=
 =?us-ascii?Q?Fcfr6kenEdO6eSkDnPdKMC5mibDYPW+BSCXZCd+1ST9GHqUGy9KaACLYYzZk?=
 =?us-ascii?Q?60CB5Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(7416014)(1800799024)(36860700013)(376014)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 12:15:15.8825
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 360c211a-49fd-4fd0-4bb5-08de581d91ff
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E7.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11709
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68611-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[23];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[arm.com,none];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[arm.com:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 42D5651544
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

> On Tue, Jan 20, 2026 at 10:07:33AM +0000, Yeoreum Yun wrote:
> > Hi Mark,
> >
> > > On Mon, Jan 19, 2026 at 10:32:11PM +0000, Yeoreum Yun wrote:
> > > > > On Mon, Dec 15, 2025 at 09:56:04AM +0000, Yeoreum Yun wrote:
> > > > > > > On Sun, 14 Dec 2025 11:22:48 +0000,
> > > > > > > Yeoreum Yun <yeoreum.yun@arm.com> wrote:
> > > > > > > >
> > > > > > > > Apply the FEAT_LSUI instruction to emulate the deprecated swpX
> > > > > > > > instruction, so that toggling of the PSTATE.PAN bit can be removed when
> > > > > > > > LSUI-related instructions are used.
> > > > > > > >
> > > > > > > > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > > > > > >
> > > > > > > It really begs the question: what are the odds of ever seeing a CPU
> > > > > > > that implements both LSUI and AArch32?
> > > > > > >
> > > > > > > This seems extremely unlikely to me.
> > > > > >
> > > > > > Well, I'm not sure how many CPU will have
> > > > > > both ID_AA64PFR0_EL1.EL0 bit as 0b0010 and FEAT_LSUI
> > > > > > (except FVP currently) -- at least the CPU what I saw,
> > > > > > most of them set ID_AA64PFR0_EL1.EL0 as 0b0010.
> > > > >
> > > > > Just to make sure I understand you, you're saying that you have seen
> > > > > a real CPU that implements both 32-bit EL0 *and* FEAT_LSUI?
> > > > >
> > > > > > If you this seems useless, I don't have any strong comments
> > > > > > whether drop patches related to deprecated swp instruction parts
> > > > > > (patch 8-9 only) or not.
> > > > > > (But, I hope to pass this decision to maintaining perspective...)
> > > > >
> > > > > I think it depends on whether or not the hardware exists. Marc thinks
> > > > > that it's extremely unlikely whereas you appear to have seen some (but
> > > > > please confirm).
> > > >
> > > > What I meant was not a 32-bit CPU with LSUI, but a CPU that supports
> > > > 32-bit EL0 compatibility (i.e. ID_AA64PFR0_EL1.EL0 = 0b0010).
> > > > My point was that if CPUs implementing LSUI do appear, most of them will likely
> > > > continue to support the existing 32-bit EL0 compatibility that
> > > > the majority of current CPUs already have.
> > >
> > > That doesn't really answer Will's question. Will asked:
> > >
> > >   Just to make sure I understand you, you're saying that you have seen a
> > >   real CPU that implements both 32-bit EL0 *and* FEAT_LSUI?
> > >
> > > IIUC you have NOT seen any specific real CPU that supports this, and you
> > > have been testing on an FVP AEM model (which can be configured to
> > > support this combination of features). Can you please confirm?
> > >
> > > I don't beleive it's likely that we'll see hardware that supports
> > > both FEAT_LSUI and AArch32 (at EL0).
> >
> > Yes. I've tested in FVP model. and the latest of my reply said
> > I confirmed that Marc's and your view was right.
>
> It's probably still worth adding something to the cpufeature stuff to
> WARN() if we spot both LSUI and support for AArch32.
>
> Will

If adding some check on cpufeature stuff for this,
I think it also good to include the check PAN as
you mentioned in another thread then.

--
Sincerely,
Yeoreum Yun

