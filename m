Return-Path: <kvm+bounces-72031-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cCFQIwhzoGmDjwQAu9opvQ
	(envelope-from <kvm+bounces-72031-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:21:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 280461AA164
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:21:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 67C7232262BF
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:14:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A7E24534A5;
	Thu, 26 Feb 2026 15:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YjDXuTsi";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YjDXuTsi"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013008.outbound.protection.outlook.com [40.107.159.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF86426EC2
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.8
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121596; cv=fail; b=hv7dTLrZpaazPiVDu8f8/f6w1AaCcNvXMQGt7xeSi85nSrpPn/jIO5K07iW4ZQOMg+5cnPlUSXkSwVB2pzInmQcOGVd1wS5UvR1lX/IKayolk6Ki5d4wxiIxmomazOEMxgMWWToZwKiozLrtr8KYG8Ynow8uB79HLgb3eQzEMMc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121596; c=relaxed/simple;
	bh=TQ+Gx4PWB6xzpzx8mPdzVNUrLKj1tupf4owg46XDrnY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qk2qjA/Ty8eHEPUPqa31I7ZeOLjlxq88cXAe6gjlttbTXo/HR8I7RIAC6lH7dShIdraMeyDYvv+uP7Hsf7CcpbKDnOgv6Ts83fhaMUk8hZZn7NyXVDBvrcjUeS32Vj1TVSBm5l/1Jwel5qAbF6zPx15ZeSBCf76Nk8uuTI/XO6Q=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YjDXuTsi; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YjDXuTsi; arc=fail smtp.client-ip=40.107.159.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=OXEH9DNnOlNFGs0ar1zykj+yOoLrTb7tGuSFcFS8A4zg4/XsYAEfJe5CAjCJy3ncRZMegn8tRC/9MR5a0K+JCl59qEfUQCdGyDA4QMdbkaKWORwW1yk/Rel0vlQZ1esaThpexoE0uhHW/xC2IjYZgb0VMw7Z3mPVSrzpAynMVrCh4X9eod+E109c3bpuF6pVDeCDkr/mLr3JLL7OZbHzp8xUVc35xlV9pvjJg5axvnQCgSmlIrPSgEpVTtBsjQTS4ozRDXJqorhXevm475Sbn0SqXUmjwqWzis4nWWuWJLXh2VkjLy6dek/nbFxa2FOLHGiyXdNwoUPz/thU1FZq5g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ahzKW4hFvBF9vv49RdL18FU/csqKMwqxFCL47/I7ulA=;
 b=TnLS0MKaXlQN36sbfTey/8gCgjxcnUlYIdi/zdvHBU8qvjCKTDqNUf3woyrPO0EWRQARB/KDxuxCdt7N8HNy8zC7TAif8by7ZQReFX3YKi/nptN7lqpTMVCC5+xEB0IBqXTHMsplSUniJXEyOTpqXG0hTNTdazK9sX+huBOG/6+kBbWQQcSHpQLNAsKKU3iRwWmfzgFEta4Us1WffyuU8YNkjjdNoOBam14plr00njJfyAchC4oRz/ou3YcL8x4s1YJebxEbWhKhXcCsP+min4RYJJ7OlU1DtCSPNl8D8D6XDy6NZZEO4nZkoXjHmoEeO+DBeYmRpSVT0e6WXIBe6A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahzKW4hFvBF9vv49RdL18FU/csqKMwqxFCL47/I7ulA=;
 b=YjDXuTsi3tbkarHA0DYVnJrSa0k8mbYjJxOzZX7iZ9YgucBM7yDMJVZCiAbQ8hzoUvmFVR9JptMxgQ3b3dffDA4BwjojBeNTrv6FVZAe56zWAeqYPyyvsRlxUFMpBhffDo4ZtZGk+WzWXgHIJqF9zGErqsJXQi/ogG77lnxiTp4=
Received: from DU2PR04CA0228.eurprd04.prod.outlook.com (2603:10a6:10:2b1::23)
 by DB9PR08MB8724.eurprd08.prod.outlook.com (2603:10a6:10:3d0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 15:59:37 +0000
Received: from DB1PEPF000509ED.eurprd03.prod.outlook.com
 (2603:10a6:10:2b1:cafe::9e) by DU2PR04CA0228.outlook.office365.com
 (2603:10a6:10:2b1::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 15:59:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509ED.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 15:59:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LxXC3ESJ841lZ4TiGNd3PUCWAxpwb7/PgVzsy66eyhoi3gdsJGLEqQhSJ0j3yy2WyCmH251jyuRAcvIdPFJ70ArRZSC2+JryiNNaEg7DpSTU2lFbb9lCP3Je0jUxwZ9eHlUEXXa1CaJZjY9T1o/RN9ZwMzP1GK2Ypx0uvYk6Z1+KfzwN8VJ/WbnyLCd0Z2c3A2o8EPtDT78USWr4D5Du/B6iZUnszsIa5TauQ+lUhzbWolWKV244A3vHXve45Kt1YJ+s5N4Vj5z81Tna8h6ae0lWXNySUgea97o6Si9Hb3oGKHTMoj5zB5tSigiLNbuualgrDtViYZOmnPQtQWXZrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ahzKW4hFvBF9vv49RdL18FU/csqKMwqxFCL47/I7ulA=;
 b=ldAdoAEaLpLUrjtDFjjXy6QtiBZUe7HcjDm1EV1o74mzRZla0Ve9D+9tG+pRfnW6OWAR2juVTu+jRPkpMA9QESnD8EYdXoeqnd7M+fr6s5u5JiShTmeekNHQxXdlB69EXpKmQwL++wUz51Ld0Y99SrC+57FY/Lwqo9IXpat2YwAvGuf9Qsr9XZbIfhweDOlRhkyJj+tcHL4bpdjD2ufq0t33ksKrWPk9lbI4JNI5TlJKbQU1rRDeU53DvRGxbQ9/QB9lpOt9sXcGGpW0zufPH9s74SIVA1jwoFxiZQFAcNc3WNk2wTC0NG1eU0hYTGyqkgWNORK7kw81mz9ElQhk6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahzKW4hFvBF9vv49RdL18FU/csqKMwqxFCL47/I7ulA=;
 b=YjDXuTsi3tbkarHA0DYVnJrSa0k8mbYjJxOzZX7iZ9YgucBM7yDMJVZCiAbQ8hzoUvmFVR9JptMxgQ3b3dffDA4BwjojBeNTrv6FVZAe56zWAeqYPyyvsRlxUFMpBhffDo4ZtZGk+WzWXgHIJqF9zGErqsJXQi/ogG77lnxiTp4=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by DU0PR08MB7486.eurprd08.prod.outlook.com (2603:10a6:10:356::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 26 Feb
 2026 15:58:33 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 15:58:31 +0000
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
Subject: [PATCH v5 12/36] KVM: arm64: gic-v5: Add emulation for
 ICC_IAFFIDR_EL1 accesses
Thread-Topic: [PATCH v5 12/36] KVM: arm64: gic-v5: Add emulation for
 ICC_IAFFIDR_EL1 accesses
Thread-Index: AQHcpzjB0snwpfkad0mq/B0b1GJ7Yg==
Date: Thu, 26 Feb 2026 15:58:31 +0000
Message-ID: <20260226155515.1164292-13-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|DU0PR08MB7486:EE_|DB1PEPF000509ED:EE_|DB9PR08MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: b7b77786-aecd-4fde-748c-08de75500aa6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 L6z8BYLhwiPAXsep8cqDs3N3ITU9xtJJCIlYeyJ122QtaQkyF3kL2UrdG/JGVIPVaDgogZw3u8St5FmI1/RIgeFi54EJTjYbD5qOXqV4VRm0YOe7Ay1YmwUzaqOIztL351Xou0DumjN6cZYv/+132TyVlyDJjN/GYaMcsuWbsUSV2e+YDBE8Da9Mza9xZDp8qLUui10Nv/RZiZNJHEtUNWFjt8WF+GJs9WctF3XAXJrVrsXl3+cVaWz4ozwW+19OHHlW1cDhd2q8qmQgfOvrOYHQG+IrYYKP0G0/E++dPkK0rvYDvYv/MWoyscLocST2Tv504hDkwrB2bLQx/e0BKlRlddUN2+w7fotdk33S4dc0eKLgo41FU1f32qv4CD/aW98izxy2JGHhCAGjGnVOXkg5v9kEFP/aDYvlHor+flkeniawFjylI+LE1dyzbhR+MU5Ic5iqAXoQ+7dyhSlRiWaLFfAd+dhN44emenxP93el0IMak9lXOp5o533TXkYPPSIcUSiJnf+j+tRkJJVuxpsG5T93RQkmnoLYTosBZU/8CFud74Rkz9eW0eJnFeCY5N3t9cDOpRL0kyliS60j15m4qze9XVKV/VyzUGseou8GRqYS/47fLcr4JcPMHnOGZ1f8xh1EpdpFsgPLay4iYY7MTOuPA9Vh57SuqqjNvDtaXzU/vY95ZjLizO98cHRzC++p7L5oRpfSPtf6XcoFwkOVzVD1n0W9IK6rvBduROaKZo3J/HeXYCX1anfYelHzxq57RjTa7Xb0HqiKpFrScoTkLb/eNw5G+Tsg+GzqAwE=
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
 DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f45ba355-bb57-4586-5777-08de754fe3b7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|376014|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	0V74SnWBAGoLE3TXSx+QcuYcOZFhKYyidl1+yAnoeTA1SyMCrBi+CLdI/b2POGPsV26z+ucWm6HGoBzicmbbcxquKRjNMKPR6LKvBfMqPfo++fH+7j7wCFEL0Teu/A8zKHDIvjd+W+0fqfc+uXzTx8sXmignhF28EOo2u/ATEHWD9dF0sWHxVuFTdPmKKgl1+Zn+lY9upUvu7htsEg8Sg5OCU4Z05e8hFUn5rKJpfLIBVJn+lni80dvfBALO0g6r3XPPby4gUpkLo0vNocS0nNfdQH0wWASY5tPAZNar6hSlNTM3uRHRXUjVsC52e5FmDSbULR8xO83K7MSMtLDfxBxOLzYfdSb2jXTiKXfMZIIszH5Kc18DwdwkucwWioAPMU3vnsN+3LiZgFvqYqfRAFPAgZj7RWqzTh/QHnjcBsp3xO9TTSMVWWd7jwMUF3oNLoTUQMy/R8/6O/d3BrJfss5xCy9394tmV6tNzjV8U4cUR368fHla8i73VBWJGgbYirDKwtaSTIM0U/K8N2Tjw8OhTcrQ86lW3n4jHYuCn3hzyvgxFy+3SWbeToYZJdfZr7AL6HKyXFSoaGlIlfO6wXJWMapD4AGK0/Y1pK4egQFDHuB3bPYJJC4g+DWr9nOy9lvxOJvoatt0dc/SE/wt0H57zKDekzPEnzEIEpBLFQTikgd0IiIFOhm0BTFMsHBdrgE9rlqbsvZt5iQIG2QXibsG/5xgXrNWhqFvCQfJJdxTMuuVJaNI8WUuyvQ5VZ7MYRlxNFsrjQgLWxYXuiEaPL+bbpRpr5WDjIb9yZrS61gcnhW2HABwGg9VI6pNO17kLrQYQmHoebQIcTIJhlSicw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(376014)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vIgrbcw4ZSg/KuWsgE9zX0V+xdBFpyBQHAsSJ3AxQT5lKGafE8Wo74IziDsK2ZwTs5GvE6sewmhW2cNPZ+RX8im3/+egY0Lkvl7D68c64j0cfe3KTVEoPFo4oMadpsk1SvOl/xOFttcNtQtuqi5zClMT1LATcanhdiV7cpskWUm9A9suzoH1oQ828YJmROsiQMOCYpcVXeyBsqeUOtgtJxP4jSrq7+u0Ia9cr8fF5WGIxsWeuKmT76Zq0MXgAVMWyYuJ/GIkpTtrbPP8c+QbXbPdFV49FfKmieq+7IlBAeoEygJkr5CGI874ZrrCAudi8MJFPi92l9xBM/wuwsn+fOz/fBl54/hpWVz/ZJoFp1/eUdgeu7kzmUkXC53F6MNLBWjUUz3RTnrwCK+WeDxQRxOy+RzpsO05/EzBbC3rHAbySS63G4qIwpCdLUM/K7jV
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 15:59:36.8716
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7b77786-aecd-4fde-748c-08de75500aa6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8724
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
	TAGGED_FROM(0.00)[bounces-72031-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 280461AA164
X-Rspamd-Action: no action

GICv5 doesn't provide an ICV_IAFFIDR_EL1 or ICH_IAFFIDR_EL2 for
providing the IAFFID to the guest. A guest access to the
ICC_IAFFIDR_EL1 must therefore be trapped and emulated to avoid the
guest accessing the host's ICC_IAFFIDR_EL1.

The virtual IAFFID is provided to the guest when it reads
ICC_IAFFIDR_EL1 (which always traps back to the hypervisor). Writes are
rightly ignored. KVM treats the GICv5 VPEID, the virtual IAFFID, and
the vcpu_id as the same, and so the vcpu_id is returned.

The trapping for the ICC_IAFFIDR_EL1 is always enabled when in a guest
context.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/config.c    | 10 +++++++++-
 arch/arm64/kvm/sys_regs.c  | 19 +++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h |  5 +++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index e4ec1bda8dfcb..bac5f49fdbdef 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1684,6 +1684,14 @@ static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
 		*vcpu_fgt(vcpu, HDFGWTR_EL2) |=3D HDFGWTR_EL2_MDSCR_EL1;
 }
=20
+static void __compute_ich_hfgrtr(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+
+	/* ICC_IAFFIDR_EL1 *always* needs to be trapped when running a guest */
+	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &=3D ~ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1;
+}
+
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 {
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
@@ -1705,7 +1713,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	}
=20
 	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
-		__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+		__compute_ich_hfgrtr(vcpu);
 		__compute_fgt(vcpu, ICH_HFGWTR_EL2);
 		__compute_fgt(vcpu, ICH_HFGITR_EL2);
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b8b86f5e1adc1..384824e875603 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -681,6 +681,24 @@ static bool access_gic_dir(struct kvm_vcpu *vcpu,
 	return true;
 }
=20
+static bool access_gicv5_iaffid(struct kvm_vcpu *vcpu, struct sys_reg_para=
ms *p,
+				const struct sys_reg_desc *r)
+{
+	if (!kvm_has_gicv5(vcpu->kvm))
+		return undef_access(vcpu, p, r);
+
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * For GICv5 VMs, the IAFFID value is the same as the VPE ID. The VPE ID
+	 * is the same as the VCPU's ID.
+	 */
+	p->regval =3D FIELD_PREP(ICC_IAFFIDR_EL1_IAFFID, vcpu->vcpu_id);
+
+	return true;
+}
+
 static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -3402,6 +3420,7 @@ static const struct sys_reg_desc sys_reg_descs[] =3D =
{
 	{ SYS_DESC(SYS_ICC_AP1R1_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R2_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_IAFFIDR_EL1), access_gicv5_iaffid },
 	{ SYS_DESC(SYS_ICC_DIR_EL1), access_gic_dir },
 	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_SGI1R_EL1), access_gic_sgi },
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 0bb8fa10bb4ef..851b37ccab84d 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -447,6 +447,11 @@ static inline bool kvm_has_gicv3(struct kvm *kvm)
 	return kvm_has_feat(kvm, ID_AA64PFR0_EL1, GIC, IMP);
 }
=20
+static inline bool kvm_has_gicv5(struct kvm *kvm)
+{
+	return kvm_has_feat(kvm, ID_AA64PFR2_EL1, GCIE, IMP);
+}
+
 void vgic_v3_flush_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_sync_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_load_nested(struct kvm_vcpu *vcpu);
--=20
2.34.1

