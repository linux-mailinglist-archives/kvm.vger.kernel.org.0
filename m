Return-Path: <kvm+bounces-72045-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QJN0Iah7oGmMkAQAu9opvQ
	(envelope-from <kvm+bounces-72045-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:58:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id AFA751AB751
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:58:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4985E31244AF
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E5C7481A86;
	Thu, 26 Feb 2026 16:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TlvlYKFI";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TlvlYKFI"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010055.outbound.protection.outlook.com [52.101.84.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BED1480DEA
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.55
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121789; cv=fail; b=RUoGawyQXanBqRIqAH3ZxaW2PoNFk3787UNnd6Q653ZGjVrAOZntz4SP9foDaU4OkeQWReo8F3iiBPhyDPR7YEoZn+ZyFRmTmap9Qo8H+Cg5VQj8KymDUyCCckVnzgihycrv4Kj6G6jTavK8CK2gds4dZHY2U1cl0lu2EXelTbw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121789; c=relaxed/simple;
	bh=W6DSohLFoZuLGbEuBm7UG246w9/Q/Q+NqnbFT2RV+wE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gJbccTc2btWe7ZoU247z4oKOdjY4KEm7rx2d9vxjTBgohixO85a4mahVH2uyJY8WvrNso/Hl8cROIxpHcRrqXWdGAsLGOrGz1C1HOHbKSyIQ/3drGhfXZP4HYkxbGwX+HKkZ6GK9KvDfgFo6D7JP25midhloSH4ITMbkpWyBN3I=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TlvlYKFI; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TlvlYKFI; arc=fail smtp.client-ip=52.101.84.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vQ1+tEqAizUpchzTCY+YZuZhSuDmk9EOHV2aH6EvyqnfoyC8ZWED1UZndrbCO6xHWGDn6xpGlq2CosQJIdcKs7fIs7ctO0Cz9/DGAy/3UN9jr7zpfRwuOFy8BTkfekG5+Y1vwcEiGAy9H9q5OY1bEG/KkuXrr7T088m6QO2RABoE25aKyfUunOJMv4sxf70wVsejA+dT5wteXshBAofVZi4ADIOktkRTycQtgXOWcZCw0I9awrKSjuVL46fjQahoZ7DkibuFow6OUpYuDch+mS6pCLkcnaYqvMWVpN6XfmEcgwWiLr/V69ht/6n7+x4mq3qCP/bUhul5H7NO8L51fQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L80zYTeC8F+3xCkTuJvWnwuBr8Z7TxMWp7R7RBqfyqM=;
 b=RjKBZNtAqBSJ5434MTmAj6EpYHInt3oPI47nlOdqwanzYIlm+Nq51Q3unptCsYOZxDUDVYeJWNHh44lKFBMygWq9rXYn1XIClgY3buxqkiLHiI3RLWZw2fj6Td5sEleuQ2cjWmhIp0nG5LGAx4G7WxsB3XsbrkR0FEJgvFxvlCtqBhjCJoxxGQVpfo+e+wSbNWnjSxLTof9krayqIg0kKxTLgxNYUTULiDc1yFIDdhlps/lMeZrCGraPuyFc3FuYHhB7Q9ETiAUIx41lnOCmR3H9BS/oftM+dIxvNIKqu+WkXeofJNmPrmF4Q4NjtJ6MAcQTPmfyPZBHenSdHqCyKg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L80zYTeC8F+3xCkTuJvWnwuBr8Z7TxMWp7R7RBqfyqM=;
 b=TlvlYKFIuPsf+oAAb/EaUwdg5HWfFR2hbdB3revhIlcG+5vk0wuQ9JHnionTGZH8of7yNVnPZ1G21Mv2taESaIWcObTN5++20F9GmLj4a98JIbxUgxOuLsJSHC4fzBJeZeO7in+ZAwxCDN5aC1NQJ9NCx9e2Bx0/M9quwDagHIw=
Received: from AS9PR06CA0641.eurprd06.prod.outlook.com (2603:10a6:20b:46f::27)
 by PA4PR08MB6256.eurprd08.prod.outlook.com (2603:10a6:102:e6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 16:02:57 +0000
Received: from AM2PEPF0001C712.eurprd05.prod.outlook.com
 (2603:10a6:20b:46f:cafe::9d) by AS9PR06CA0641.outlook.office365.com
 (2603:10a6:20b:46f::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 16:02:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C712.mail.protection.outlook.com (10.167.16.182) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 16:02:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tl/ns7h+ypvOJz9eqXkSgCJcccVGY3ZWCGsoLTo7s1h7iWEPzwqXfqsQK+rSZI6xFjRYbvrsFoQ5euSGmVW4I2IlTmY4SiX0Uqp0TjrwtyQsM5dHb/G04JTSBrzVqg+a3VeGDvb+KfefWmvQA93LKb2aubGIb8NTsJDP8Ep9eIgDVinwmvFJP/eG7fwJjjgmEe7B6Gz+EK7Iutp5K3CUsYdPXVoivU7eVE+mbR4brcO1+JPBMfCEpKmVGcestp6RqDkph2xqJBKWbiVMtb3TbGnJvzbZkoa0dgzgjnMoe4kJOrb7ej4teVIsf43+rydx7PADlxHKb5v7UKQY3zZjww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L80zYTeC8F+3xCkTuJvWnwuBr8Z7TxMWp7R7RBqfyqM=;
 b=lvhmlzEX1+z4hgSDo67cCYGQEm1xcmn1Qpj8UfhPoY5T5oe9//myjDKR2l2yXtK4QGxrnzXqQVZzId6G4+403oleLc5SUZmHElNmwPlU0OFPZIbUadwyiB/GJjtJyr9eHlwwI1B4xOx2uyrvEZ/B64TUCEZwvHvSnSn74SA162xEIzeY6TyXWB9vg8YyjGWvBXDyCLP11EOSu3ciiVlrV3sd0WK9g+Vi6Vy2OgrqnkP4vW1DNF5Ck1aDDmkzDa1uXFW6INYru0N+GeQHAoMSWk60qhkuqpwnfDGpYXqoMOJGJN8KShuJ9Ip16Lcz+ITW8+OTyNKlelG7azRpwcLLCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L80zYTeC8F+3xCkTuJvWnwuBr8Z7TxMWp7R7RBqfyqM=;
 b=TlvlYKFIuPsf+oAAb/EaUwdg5HWfFR2hbdB3revhIlcG+5vk0wuQ9JHnionTGZH8of7yNVnPZ1G21Mv2taESaIWcObTN5++20F9GmLj4a98JIbxUgxOuLsJSHC4fzBJeZeO7in+ZAwxCDN5aC1NQJ9NCx9e2Bx0/M9quwDagHIw=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by VI1PR08MB5486.eurprd08.prod.outlook.com (2603:10a6:803:13b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 16:01:54 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 16:01:54 +0000
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
Subject: [PATCH v5 25/36] KVM: arm64: gic-v5: Initialise ID and priority bits
 when resetting vcpu
Thread-Topic: [PATCH v5 25/36] KVM: arm64: gic-v5: Initialise ID and priority
 bits when resetting vcpu
Thread-Index: AQHcpzk6U0koeZucwEC1Kx0VYrf1fg==
Date: Thu, 26 Feb 2026 16:01:54 +0000
Message-ID: <20260226155515.1164292-26-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|VI1PR08MB5486:EE_|AM2PEPF0001C712:EE_|PA4PR08MB6256:EE_
X-MS-Office365-Filtering-Correlation-Id: bc0fcf5d-8652-491d-9d23-08de75508221
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 JmkIwGoBhVxYxjHtI3I0qDJDGbjPGJQ5KcSK9o7HoCJ6UhAPHjC9itQJYjXlQN0ZccP4LoYkpiwNdguIqgih1RVGORyRLqRG7LOSVtX3mzs40OlrtjXccW4ZK8pOZgU36SW+1DmKGpG+Bp08VN8F9T4DerkUQF8VXI5pCnplj4pnAp3Az70lmfW9bsocDgE3mcSktivgpSPrMqj4iPyVVTkqICBqYyTDh1uDCzOBfyC5Hd+2OGtgD0azAa4/I0SEPOt2to4H2rOaYtDmCNv/vA+7I4kJATgRU5GKV1Bvkz4OOUv3ijmsjYKKodW94Vxy5vfnIprtrTS8Q49iExfjMKnHeQyEik0lYumUg+7KlTozYcIXyVlIfX5DSORqofLBSG0tRU3QU6Q7/+hsiTl/Wf6fOPOYpAofgD9ULOcymG5q412BduvUcuA8XX8PTPjs63QvIL/yY6bEXdh0hYgoQFu6NLvh77e4jdVcXAhhClbiLoTKuWoT0ZrSYX++RqCpOX5a7fKjjNVBKjyuA8VAjeOHvlpGas5RCeDAUrP/X6icw29qZjaRRARVJ6OO69dIogH46S2AZs1Z471u/G+aSF4IP2OHo/+5r13m9co4MyTZXKpnVnBgb7yYV+64G/31mV49XUvusLxlN9eQmc0+FS66IrKJH3TL0kGAihHTjbiFfoAAXhbWiN+9W9+Z79sHhUGHL5ig2pUEn15FaG3c6rpeIoduwSPqe5bMVcJshLb9Z0KRSyDvFNl1WGkZ3BkaHI7H+vSeZx8gdOKTe8mWAJg5m4m002csIRTCF01xGhY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5486
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C712.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e98980c9-d98c-4474-853b-08de75505ca7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|376014|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	mOZb2NG/LDQ4QmuijstrbqiG4EPLRjDrv73bCw/2gh0GjzuvEuwWMqlZmkAEXToSKyYfzxi0nZ3j1dBnfulEAcvGD6DpvyOTmAFFQvCFU7UyVYJgtjmSdTkpg+cIJ8ubddBjuh9bVeGbt56CRWuoT/UEsEp482iXOlutNjcUzDbzBilbjCFD/DRrH7zUDG8sY6ZRISdoapeEQ1HivihsoiY6rsTZDmyX+fdO/48/zaeZUfCdasMCbHZnaJKeSzigdtwJhtTq4BZpXaGHXNQVq+Aszo1HajaJsFkkOwajgjWuWZHfAjGcWlzWmQ2RVZsDQmwdhf5vZ9tKcu5FLa3GBm0xOlphiWG0Vap9p1dntQZTeIZhTGRs9p47HfoHLUCNtgn9VpzReJEc+M5Vc72Q4thfl9Z9Ckv+AhxSHYg6o3nuZK05W7hOVAZ8CJbfaamwbzmQwDRwF7fGq59d/16KC26U7kfCJH0X0V5k4NAPJleM/h05vSBgzLm+q7nOpupaPwlkonf+06QXmMbBH01I+C8g1McB22uE4AXdG+6++WWGp4E3kSYzD3BkdKL36OYhbX4KbuRjQY27hcFoQzaNqDF/wryM2dJuG5R2lNtqzyIR1WAQHSffa8r65A7Y+woc+63hSSHhMftseWp3yd3o8OAZIrxGaP8EcUCUFFOjxkVwE4/ZiaOsFYFQ1eqSoIsxP3FMdsSzAf3vWfKBZcniyb34BTf++USn3XhxbOcGxETozr8bY91phqHNgF3/tp5F/+okNyQV2vxSyvUcxuCXRJctizKhkFUnaFXzven9Fpyis7gXUvcWnFeRu0Bq7yzibjuwiXhccmRT693QQHRdrw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(376014)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EHtc2EuU4Dx0z8LNB4/GBy47fs0KKd3M4Fi91cTmOD0l/sKymaEFp7YJVKOJv4UDEtGRUgaqij/jBKqh64BcR1h+drvsvbyabyZ1GuPE2x/GmDGEwkAzf0H2bHPZ5UYlV6qL9cG6m9LGIs44S/J7itRAfxrK55UA/JZDuFIBp1lh3prJz0skc0LzTkQDS8AgNCQN63X2TZwd8lH7cIcHGGv9N+GrDcQuBfnWfFQYCJeDRA1vbEfxviDFU4CJmSL7GO3eCWIBbnjfMEUZe9+rjmWMtCU5PspoZuRo9blu1XESYVzvAklYaRZQZgxC4FyPno0vLFCZsL4K5nYfBIOd/5tcOektw97jROK2/737+2B+fMVyvz4rC2MYB0n7OnCPTeA9K8W/briQdHOLma4XmLR14Vp7DJbpWyyGU39+F5xD/CLCqkS3WWu9+HGU2DIn
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:02:57.3322
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc0fcf5d-8652-491d-9d23-08de75508221
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C712.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6256
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
	TAGGED_FROM(0.00)[bounces-72045-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: AFA751AB751
X-Rspamd-Action: no action

Determine the number of priority bits and ID bits exposed to the guest
as part of resetting the vcpu state. These values are presented to the
guest by trapping and emulating reads from ICC_IDR0_EL1.

GICv5 supports either 16- or 24-bits of ID space (for SPIs and
LPIs). It is expected that 2^16 IDs is more than enough, and therefore
this value is chosen irrespective of the hardware supporting more or
not.

The GICv5 architecture only supports 5 bits of priority in the CPU
interface (but potentially fewer in the IRS). Therefore, this is the
default value chosen for the number of priority bits in the CPU
IF.

Note: We replicate the way that GICv3 uses the num_id_bits and
num_pri_bits variables. That is, num_id_bits stores the value of the
hardware field verbatim (0 means 16-bits, 1 would mean 24-bits for
GICv5), and num_pri_bits stores the actual number of priority bits;
the field value + 1.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c |  6 +++++-
 arch/arm64/kvm/vgic/vgic-v5.c   | 15 +++++++++++++++
 arch/arm64/kvm/vgic/vgic.h      |  1 +
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 8de86f4792866..59ef5823d2b5e 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -381,7 +381,11 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
=20
 static void kvm_vgic_vcpu_reset(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
+	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		vgic_v5_reset(vcpu);
+	else if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
 		vgic_v2_reset(vcpu);
 	else
 		vgic_v3_reset(vcpu);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index b94b1acd5f45e..a0d7653b177e2 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -86,6 +86,21 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+void vgic_v5_reset(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * We always present 16-bits of ID space to the guest, irrespective of
+	 * the host allowing more.
+	 */
+	vcpu->arch.vgic_cpu.num_id_bits =3D ICC_IDR0_EL1_ID_BITS_16BITS;
+
+	/*
+	 * The GICv5 architeture only supports 5-bits of priority in the
+	 * CPUIF (but potentially fewer in the IRS).
+	 */
+	vcpu->arch.vgic_cpu.num_pri_bits =3D 5;
+}
+
 int vgic_v5_init(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index f6de4e6b8ced4..17da8e4ebca72 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -364,6 +364,7 @@ void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
+void vgic_v5_reset(struct kvm_vcpu *vcpu);
 int vgic_v5_init(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
--=20
2.34.1

