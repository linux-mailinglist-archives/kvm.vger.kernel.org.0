Return-Path: <kvm+bounces-72535-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KHv7Lhnwpmk/agAAu9opvQ
	(envelope-from <kvm+bounces-72535-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:28:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 34E391F1766
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:28:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AD7D7306360A
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 14:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3C263DEAD9;
	Tue,  3 Mar 2026 14:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="l5qMwXHc";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="l5qMwXHc"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013030.outbound.protection.outlook.com [52.101.83.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F9F396B6F;
	Tue,  3 Mar 2026 14:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.30
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772547867; cv=fail; b=rkwSxyunH5xZh5k8km02teU6yvx0gNB4FhRSQxkGwX1Kt6XC6KRuInuV/EFRxDhyDSVag92KVK7xYcz00tVgR8dFAaHrnSoicLbhsFgAuHcrNShzTWBcWEPHMzxu8BPXAli4CzgAH2ZiMIfn7lMflSaObXkTkagu9CXfNpVfvM8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772547867; c=relaxed/simple;
	bh=+3zE5XpaAT0RtywpeIQqD428H36sMrnjvMwudzi5MnA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eowF0zRdFApOM1qQOAg0zxEdf1jqC6QGUGhIdRTrwzCsruAhAfgu/OY8gneOAj6mU7NOG2jNuIDrLvcXzpZSl1pc1q8J3ddtX5LFitoQajXMBD/Q1SO0gzmx0XeeLo91czLYLzmB1gSGBZ8tEYun3NRDB7Mgg6onkKmW4amRCxI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=l5qMwXHc; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=l5qMwXHc; arc=fail smtp.client-ip=52.101.83.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dp4rTrErntM1JtRCEQrAoyKRtfDWcOTWyLgpNKGOVFkeiiIYVYwqThVvqbJqQKgiBw76eIn/iZIGChfGZJpAIzhG+tXwVjVoU7kLgwYjzyv6MblnFnmMwpZs6IVpll1Ud9Yyvohs4A7tYH07G1gmoPm9tlNRZ5GUXs+TJXtjCJ8XdF+gEaf9lBJFep30hnW1z5vzm6MSAiVF14SZf+0RglijV91uy6aDJBkrehwdO+zMg9AuUZWgPen94TBLapdVU7yaEd3Cj6Y/KO2061qPp6q3X9rZju5IPzow49inWUvMYsRxLNW5VFZHte68n/icdIY5ZdiCcOmnj1FAWP+n9A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ERtLLnajr8gGkYvOi3J74mDYNyBnQJ3+K9Ro07OFa0w=;
 b=yWQaRVf0QfzNIagOg5J2g2rV2Imd91K5PcLKspZu9FbTysZBaujkW7agPwDfZvMT2r56FNkIK3Ja9ijliXzooWytmaVS4oiNDVFKd/TDN5ICZh4m4nT6mMtoeqkR1vMdGRW7FllXciqgf9oUGtQBCr5uU8bOqq2yL+9totBWKcd757yzwTXURQGRdbvy3gdm8CgXRYMeANEY0qYjZNO04m48pqVmziy8tHWgsdD99n5495bF/6ZsziegGCHqt6fgY5xSzLxQ9md6HiFXIbe1l5X5mquT4UXejJiC192gMhmtdmqrm6gPh3FT0xFRLszM+RngcoaSvVutM91Gg54PKw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERtLLnajr8gGkYvOi3J74mDYNyBnQJ3+K9Ro07OFa0w=;
 b=l5qMwXHcaHMGKLXIp5llpbuIM348EiggDgq1gDoI4LPhQcKetAX/Zk2yZ8MLz/s3aOwvFqw0pSYtC56PFxq2DsvQPoXMdyztbeSXhBt0HTJyb3S7gs0Z/GCO7uh3oBRXoUY+g6lmz/ZEACJ/nubDfQBue6S3ONPoCw39G0yYzw8=
Received: from DU7P195CA0004.EURP195.PROD.OUTLOOK.COM (2603:10a6:10:54d::34)
 by FRZPR08MB10950.eurprd08.prod.outlook.com (2603:10a6:d10:135::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 14:24:17 +0000
Received: from DB5PEPF00014B9B.eurprd02.prod.outlook.com
 (2603:10a6:10:54d:cafe::7f) by DU7P195CA0004.outlook.office365.com
 (2603:10a6:10:54d::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.22 via Frontend Transport; Tue,
 3 Mar 2026 14:24:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9B.mail.protection.outlook.com (10.167.8.168) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.16
 via Frontend Transport; Tue, 3 Mar 2026 14:24:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S4xDYV1O27MRF53EKbMW/zAR6yMZg7VuD+unX8+thDMpavfBLOk2D/AEAujf/O3UrsnvtzZlepEYdpOVZghSf49oJY6CS+Cra/0AtJa/i1I74UHDru5eb9eS0WzDmrncXL4Kt5AVNdOUmh+UAT11J5dUG8CedDvsmcCG32F+UZvI/n67OBB3S58DzrdN3H5yQY9Tn4tNk23Bu8CU9onu4w6xWmwEapSX7BrXNTsJ2KOjvr7BFHtRk5+eUmYzQmQfhLjs5T4evC/W1UxS6KXwts7Ue17B3Dx9VXxXnrcL7oKXbE8m1uq8S0vAWlLc76ne/6l4uW72nXXUFZmPMslKzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ERtLLnajr8gGkYvOi3J74mDYNyBnQJ3+K9Ro07OFa0w=;
 b=qkZLNLoIk3v9bDQ/JG9TPYnQ209lKSaCSiCKTN7IqEDBP/elszHDW7ijCBOnkOedAUsn1WxoAgdihSCu7aTueMXwPsYwkS49crG2W+QraDLoISlg81b05c92DUjugTACtbStaSv/Yb0y6lDCFAOKG5WO0wcCje6wBWen6ZXOX6J7BipEAYNnyryPwT9dz3KFQpRblJqyyT8lhMUfoZwfcCDZH4weB6s/Ef6hhVtQSalbNo3/uK8kW8IMJa2BbDv2wWA3tms7Ak01zoytM5uFfajcdetTuAMMCdUEWdCh0Ve31UoLB46aWVsOIQ8STdBMCO+gMRdKqioCwODdKinmdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERtLLnajr8gGkYvOi3J74mDYNyBnQJ3+K9Ro07OFa0w=;
 b=l5qMwXHcaHMGKLXIp5llpbuIM348EiggDgq1gDoI4LPhQcKetAX/Zk2yZ8MLz/s3aOwvFqw0pSYtC56PFxq2DsvQPoXMdyztbeSXhBt0HTJyb3S7gs0Z/GCO7uh3oBRXoUY+g6lmz/ZEACJ/nubDfQBue6S3ONPoCw39G0yYzw8=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by DB9PR08MB9587.eurprd08.prod.outlook.com (2603:10a6:10:461::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 14:23:10 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%6]) with mapi id 15.20.9654.020; Tue, 3 Mar 2026
 14:23:10 +0000
Message-ID: <d87ee902-3b5e-4cf9-8b97-d83f8da02a5a@arm.com>
Date: Tue, 3 Mar 2026 14:23:08 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 06/46] arm64: RMI: Define the user ABI
To: Marc Zyngier <maz@kernel.org>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20251217101125.91098-1-steven.price@arm.com>
 <20251217101125.91098-7-steven.price@arm.com> <86tsuy8g0u.wl-maz@kernel.org>
 <33053e22-6cc6-4d55-bc7f-01f873a15d28@arm.com>
 <9d702666-72a8-43e4-8ab3-548d8154a529@arm.com> <86fr6h838s.wl-maz@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86fr6h838s.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PAZP264CA0016.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:21::21) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|DB9PR08MB9587:EE_|DB5PEPF00014B9B:EE_|FRZPR08MB10950:EE_
X-MS-Office365-Filtering-Correlation-Id: a9ad1ac5-a5ab-41a8-3b67-08de79308d5b
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 RiFGBWsR/iaCDsUs/LlcvIH3Af3Sb4mjJtwXt8vtkJbhtRk8S5G28CFFWIZIjV/jwHEn4aYty8JPlkNtbYnPJKvoftFnf4YJeAWgp7EVzPcf0j/8y1cfxmjR4vKryQxkTVDslUWDCUK0i8sRz1FkXKVCnm+rGphgjEw9mYTpv8dXRJYT3Qs0BSdSk0sTYmyJ4bvBg5O4wsXZPsFtr2gS+DgB+V7t6zw7GA0DQTcSEa5i+sKZ8qmIhf+elxSMr3tnC5Sk1CIG46IBu/WczMDx6rPZQhp/Ey9fZT3s2Vlf8FOPGLuiNjw7WMnskW7sUrErGdB9dhahA7YCPGNP43u4ZHBM3EP/7b8oD88UTvkoNv6DrhFimjelTgkGNIqY01fBSRAT2vuNsoCWrW5EwUrJjkLso0wERKzgvDrevcGMuHu713X9SVZSeDEZcackxgYh6KpPN7OIdRMJjenMyeltnlXdVY6EYRvAxcI+WqaRI4hEBzgIlnG7cjO0S28Oz0tOJWKQSwQaWdFHuOe34LP8L/ArgBnLlCbvrs+7ebPjZo+8hj0VFbNcZ9eKknO4rg3dbrhkxLkWfY5F6Fx6NiAiCn87/IKYCHofX5wAz6HD2iPg02AzFe0GHVP+5le6Yf5Lnjv/j7UWewKEbAiJOZi4czILeAGT9gwFmUYCZNfQk0R0vIaeXvo81uOCoQ0ujf6Ie01m9dxc3kUPMZcNLcHKf19jHLzvJblPXsoV94Xt9Ms=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9587
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d56096fa-aabf-450e-0e25-08de79306550
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|35042699022|82310400026|376014|36860700013|7416014;
X-Microsoft-Antispam-Message-Info:
	XYFmnE8i3hu8Tt7mZSXTDuCaH1y0zUQGH00gulKWA7+9fM6JWWz8VtPpe4yQgeDv5nCyBQM5IONdFeYb1Q+P3/Lago+gmASU0MiuMyj4F04iBwxYdRrJqVmV9YG4hHZoQ13y14oGJzpzZwG6rB9pMYq3dBtx/ROdgZXvhDPpsUXAetoepu6tZh6qv8oC2flXRTZv/y2PCOSo1drf22qYOOupW3RLUVKCjUUPXyYkzKuaj+UGTYmqIYdE5ZRYJJm3Ao5xPRcl74qKXe+C9bl2miWtiPK7KbJDIn2xPJRi6om36lBCRCYIykjNnWhzkQlMieSWt5VuTipNsuwIRiLtfgN3adMdG4a6qcUwe+DWIk+tn8UZNI29naR9yJumrWWyvTEv6cXZa9JnQKKkFtH69sr63kfts+24Fb4YyGx1zsv/Y4BYP8JE1xUz9h2NcUh7oI77i2k2307jiVOM+0D+fPsYB6wzmQCkQpRw7WxjM70c/cc1ZD0/I82lTZ6SotuIsn71JPs8nAte0g/ox7w0E3TwBeGl4aSBorEBMebHIhf7vCAdn4Tj8NdSv3ryuR7MzUkyZN4WA6PvtisDSyhuQrAnGh8WwLmx+jQEj+6B/oB1pnZoG8BCgd3oyquKnpNq8FW3KLb4z2xixH9eMHz5v6Onl2ED/gD+q3aVPc+iBAzK+h3wXCotuldPGS+i73IkyNMwG90iOVpcR4cmAe9voISh460+TQDqrL5IsE1lwWQtbtD/sIw43bCDqFIU7rGeFWPEmlnIPDBS2XAIZqWls50FUYrrSWsWrh1dEz6eDqdHp5bHQf9p7RdqB5Bx20iqLnzRbZYBIR2N+tYQpY+LhQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(35042699022)(82310400026)(376014)(36860700013)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IXqL2Z++UKoe3TkCnjB+86/+1WOdYzmr1W+etsAoZcPVPHsRpM1+1maFBXuxUnJhDE6yWFsSEqpDMIbzb+S1+tlznR7p+Y4SiUHbg03DgzYQP0K4qtTTYCxq2t7kg0NUf/Vhcu85dLTYEVWIl4421275r6N9tlKEcpNP8wbkjK1UDiZd2zEd2Z6yDVWDVTeVOE3y1LfQMopJ0xUDeevboQVOFH/+H4kmWrJhAF2v9CU93krIBsuPO+UMXDxzPRDPVimX9jLlrkOvYjWmOhhN6YBZMIW6S/rsn6rMuQk6Ghfn6dS67D0WL/6nh3+kCW3vVm1ffAVVt8TdV2bMU1xKrFyyH0RQ2MxFanM4VnrVrEK0mF3rWBvv+vvt5NU84aBjSDjm2CeIBE0N2Mup4/r3rbtjEuuQx7YewZ7cHpZ+7tj99NFLg3C6xV2vNMIrRIk+
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 14:24:16.9068
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ad1ac5-a5ab-41a8-3b67-08de79308d5b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRZPR08MB10950
X-Rspamd-Queue-Id: 34E391F1766
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[23];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[suzuki.poulose@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72535-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[arm.com:+]
X-Rspamd-Action: no action

On 03/03/2026 13:13, Marc Zyngier wrote:
> On Mon, 02 Mar 2026 17:13:41 +0000,
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> On 02/03/2026 15:23, Steven Price wrote:
>>> Hi Marc,
>>>
>>> On 02/03/2026 14:25, Marc Zyngier wrote:
>>>> On Wed, 17 Dec 2025 10:10:43 +0000,
>>>> Steven Price <steven.price@arm.com> wrote:
>>>>>
>>>>> There is one CAP which identified the presence of CCA, and two ioctls.
>>>>> One ioctl is used to populate memory and the other is used when user
>>>>> space is providing the PSCI implementation to identify the target of the
>>>>> operation.
>>>>>
>>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>>> ---
>>>>> Changes since v11:
>>>>>    * Completely reworked to be more implicit. Rather than having explicit
>>>>>      CAP operations to progress the realm construction these operations
>>>>>      are done when needed (on populating and on first vCPU run).
>>>>>    * Populate and PSCI complete are promoted to proper ioctls.
>>>>> Changes since v10:
>>>>>    * Rename symbols from RME to RMI.
>>>>> Changes since v9:
>>>>>    * Improvements to documentation.
>>>>>    * Bump the magic number for KVM_CAP_ARM_RME to avoid conflicts.
>>>>> Changes since v8:
>>>>>    * Minor improvements to documentation following review.
>>>>>    * Bump the magic numbers to avoid conflicts.
>>>>> Changes since v7:
>>>>>    * Add documentation of new ioctls
>>>>>    * Bump the magic numbers to avoid conflicts
>>>>> Changes since v6:
>>>>>    * Rename some of the symbols to make their usage clearer and avoid
>>>>>      repetition.
>>>>> Changes from v5:
>>>>>    * Actually expose the new VCPU capability (KVM_ARM_VCPU_REC) by bumping
>>>>>      KVM_VCPU_MAX_FEATURES - note this also exposes KVM_ARM_VCPU_HAS_EL2!
>>>>> ---
>>>>>    Documentation/virt/kvm/api.rst | 57 ++++++++++++++++++++++++++++++++++
>>>>>    include/uapi/linux/kvm.h       | 23 ++++++++++++++
>>>>>    2 files changed, 80 insertions(+)
>>>>>
>>>>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>>>>> index 01a3abef8abb..2d5dc7e48954 100644
>>>>> --- a/Documentation/virt/kvm/api.rst
>>>>> +++ b/Documentation/virt/kvm/api.rst
>>>>> @@ -6517,6 +6517,54 @@ the capability to be present.
>>>>>      `flags` must currently be zero.
>>>>>    +4.144 KVM_ARM_VCPU_RMI_PSCI_COMPLETE
>>>>> +------------------------------------
>>>>> +
>>>>> +:Capability: KVM_CAP_ARM_RMI
>>>>> +:Architectures: arm64
>>>>> +:Type: vcpu ioctl
>>>>> +:Parameters: struct kvm_arm_rmi_psci_complete (in)
>>>>> +:Returns: 0 if successful, < 0 on error
>>>>> +
>>>>> +::
>>>>> +
>>>>> +  struct kvm_arm_rmi_psci_complete {
>>>>> +	__u64 target_mpidr;
>>>>> +	__u32 psci_status;
>>>>> +	__u32 padding[3];
>>>>> +  };
>>>>> +
>>>>> +Where PSCI functions are handled by user space, the RMM needs to be informed of
>>>>> +the target of the operation using `target_mpidr`, along with the status
>>>>> +(`psci_status`). The RMM v1.0 specification defines two functions that require
>>>>> +this call: PSCI_CPU_ON and PSCI_AFFINITY_INFO.
>>>>> +
>>>>> +If the kernel is handling PSCI then this is done automatically and the VMM
>>>>> +doesn't need to call this ioctl.
>>>>
>>>> Shouldn't we make handling of PSCI mandatory for VMMs that deal with
>>>> CCA? I suspect it would simplify the implementation significantly.
>>>
>>> What do you mean by making it "mandatory for VMMs"? If you mean PSCI is
>>> always forwarded to user space then I don't think it's going to make
>>> much difference. Patch 27 handles the PSCI changes (72 lines added), and
>>> some of that is adding this uAPI for the VMM to handle it.
>>>
>>> Removing the functionality to allow the VMM to handle it would obviously
>>> simplify things a bit (we can drop this uAPI), but I think the desire is
>>> to push this onto user space.
>>>
>>>> What vcpu fd does this apply to? The vcpu calling the PSCI function?
>>>> Or the target? This is pretty important for PSCI_ON. My guess is that
>>>> this is setting the return value for the caller?
>>>
>>> Yes the fd is the vcpu calling PSCI. As you say, this is for the return
>>> value to be set correctly.
>>>
>>>> Assuming this is indeed for the caller, why do we have a different
>>>> flow from anything else that returns a result from a hypercall?
>>>
>>> I'm not entirely sure what you are suggesting. Do you mean why are we
>>> not just writing to the GPRS that would contain the result? The issue
>>> here is that the RMM needs to know the PA of the target REC structure -
>>> this isn't a return to the guest, but information for the RMM itself to
>>> complete the PSCI call.
>>>
>>> Ultimately even in the case where the VMM is handling PSCI, it's
>>> actually a combination of the VMM and the RMM - with the RMM validating
>>> the responses.
>>>
>>
>> More importantly, we have to make sure that the "RMI_PSCI_COMPLETE" is
>> invoked before both of the following:
>>    1. The "source" vCPU is run again
>>    2. More importantly the "target" vCPU is run.
> 
> I don't understand why (1) is required. Once the VMM gets the request,

The underlying issue is, the RMM doesn't have the VCPU object for the
"target" VCPU, to make the book keeping. Also, please note that for  a
Realm, PSCI is emulated by the "RMM". Host is obviously notified of the
"PSCI" changes via EXIT_PSCI (note, it is not SMCCC exit)
  so that it can be in sync with the real state. And does have a say in
  CPU_ON. So, before we return to running the "source" CPU,
Host must provide the target VCPU object and its consent (via
psci_status) to the RMM. This allows the RMM to emulate the PSCI
request correctly and also at the same time keep its book keeping
in tact (i.e., marking the Target VCPU as runnable or not).

When a "source" VCPU exits to the host with a PSCI_EXIT, the RMM
marks the source VCPU has a pending PSCI operation, and
RMI_PSCI_COMPLETE request ticks that off, making it runnable again.


Suzuki

> the target vcpu can run, and can itself do the completion, without any
> additional userspace involvement.
> 
> 	M.
> 


