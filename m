Return-Path: <kvm+bounces-72055-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6O8HG5J6oGmMkAQAu9opvQ
	(envelope-from <kvm+bounces-72055-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:53:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D6D1E1AB45D
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:53:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A920031FD05F
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B92643E9E3;
	Thu, 26 Feb 2026 16:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iqDGqZ+2";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iqDGqZ+2"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013034.outbound.protection.outlook.com [40.107.162.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE16C4C954A
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.34
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772122020; cv=fail; b=KksrceEs5Q2yC0GqTSEBsCXkcVDTsjXoJd3WyonLaUw1iUf6xgd0g0TpH3fXEwWZ6QRw2QMSnbFCCpMY5UU5DGyLH+A1APwQvjSQYC9CWvlsp4bwFQfY8p1bWqvNh665PoGZWQVjrLjN8FD7xQhzrScCmRKQZs0B0FSDD6E8yH8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772122020; c=relaxed/simple;
	bh=/wdTr4rRW/Dr9PRtehnGlP1RldFJVDjnEgjZkZrXjuE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KqOd967fXBi/bqZmXwrcGoG1N8m8wbULLulnAj1p2O5BuE8WfN5ITVuBwtsSsu/o6CuKsPcnJRbdZy8IVoE3q8KBvl5DWzLem3TztBBe9tVFaHch7YKVZNoSSTAaFVOvcD6Z5NfeBxvfc0cS0yJJ7v0Y/Gl+9a4Vfyq8zdUy8nk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iqDGqZ+2; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iqDGqZ+2; arc=fail smtp.client-ip=40.107.162.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=yfPbREUkOH3evPNtx6fD/S6HlGU9xQV9dETOxp3DOOrykRhpPraAQn0eBAu3qW9HtZXIi9dRbo7xa6UW1mTzuu7n2Qy9x1vL7Qf+iJxVnm/e1gsEQ7LdlEJGJtbXRV7l0/11hmfk2cyM/syFea/Cm8B9R2eOLFR2q6uCv9KRC35Ve7mp1NYwk4uE+b6vJtSPew8YllyOIkBs5Tw48UOIb+AnF4ZN8yeNkZ8GnjytGTIUDrIvDMLc9taFeSsmnX37zzrPf5nN/ycvdX6T+OGAIVtdfZy5+41W0EVnItP5KeqjdNl0djibEs0Ko2humqAmJByDRY2bXSj3zrkxM3RzMw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hebf0HeusOemTZFvqEe/EsBXhIPh/r7+s7cOJw118iU=;
 b=KHyPzt2Q5JHIdY7Gvd46/iKJdX/EgiixbBIshM555OdC/1vRDO60D5bjP+SUYblKLHSyYvFwtLrcuTAdExil/WFhvYDKfWTrRYGOcqTSWSUA9KxHH/8T03piCEIU1wp2uHTYCEUD2quImmQrSMY5odpzQ+He6WvURgMvhtybOY4A0YfTVkA3fOvJAJ14gTR+hFq1i/J7d3HC/sij0b0tkKF4FeKzbtZSAvS2EwG3Q0Woi7y8ScqNLqwdYXY0M0r2hGKESsN0wtLLlNzlhTD0TBAelQ1wpS8+YiEjfpWEGEo9pinVxiwE9eYVRNaLLJZmHDshViNUDOmgqviwwfSmOg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hebf0HeusOemTZFvqEe/EsBXhIPh/r7+s7cOJw118iU=;
 b=iqDGqZ+295XZT6y9UeKqdZ1Wne3AEiCRedrS2Yapw3XdvjWTgeNNY+u46a6b4fL5uOo5jigPGFgGxFqvtzWzUQ/c0OiEUWtlO1hcvpRBr6/Y6fE1ew7fYPlPDVB1ORuvx1pUSDzs0RhPPDcKEAYNGStzJQ9JArAhHNqSKLmtsGU=
Received: from DUZPR01CA0169.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b3::13) by VI0PR08MB10969.eurprd08.prod.outlook.com
 (2603:10a6:800:250::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 16:06:48 +0000
Received: from DB1PEPF00039233.eurprd03.prod.outlook.com
 (2603:10a6:10:4b3:cafe::1b) by DUZPR01CA0169.outlook.office365.com
 (2603:10a6:10:4b3::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.23 via Frontend Transport; Thu,
 26 Feb 2026 16:06:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039233.mail.protection.outlook.com (10.167.8.106) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 16:06:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xa68J/cgkxSpDdYZkAmM181lkR5Lgi/IuRbY6zJCObcwWaVHgZInK8ydiSwB3Yhpbovvg7G7n2yWos/RzhYpz4BBAM/bhyB7Dyrqv3ia7wpaUvBZBRUGGdSfxRc/rIzIjObhl8ivDLEZRh3A+gOmDbVRglJgR9I72pb9ND9wuLSlnAA10mXJvAbALiKT8CebPzfct3UAFCQbMjqU2dOmCPhcMy1iV6Sg2SRnsvuqI+W2hyz1cZqMCSUhiYR6VHudxwEofslbbZs5JgSIoZ0EXu75gC8oJsxb0p1z/81oPVyG0Upvx0LqjvRzPyT+HrvjIGlA0v2vdYo/yCJ8pLJK8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hebf0HeusOemTZFvqEe/EsBXhIPh/r7+s7cOJw118iU=;
 b=enrsFdliDWP4IWw3XvrctC+4pV4y9yfRQ9O0cgZlkgB3qO0y3/dprioSK8XTiQuCIjlY/sZrxeXbmkH+IpXjOg9TjSaTRgYHCmulbgk/B+iuVCRjjjyb7TU3ZBaQoJZyKrCMP7m3pOhyJc2JflBbcmXsFExeyXU5yi9xDIq+nQH3cXmWQTXbNMiwYr+1lqAlWbI9byCTJvODF33raTpqZb6OXd+zmJ6WktwrPH0TIiIzeXWmgRRVV40rHXVv0/xzYBU05fIVFd79mcBrlZvv6vCN9p30so0S91dPadPmhykhj7POh4mxwVGWae5Oysj6Gnik06GA2pUBHWvUYlWeDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hebf0HeusOemTZFvqEe/EsBXhIPh/r7+s7cOJw118iU=;
 b=iqDGqZ+295XZT6y9UeKqdZ1Wne3AEiCRedrS2Yapw3XdvjWTgeNNY+u46a6b4fL5uOo5jigPGFgGxFqvtzWzUQ/c0OiEUWtlO1hcvpRBr6/Y6fE1ew7fYPlPDVB1ORuvx1pUSDzs0RhPPDcKEAYNGStzJQ9JArAhHNqSKLmtsGU=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by PA4PR08MB5950.eurprd08.prod.outlook.com (2603:10a6:102:e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 16:04:31 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 16:04:31 +0000
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
Subject: [PATCH v5 35/36] KVM: arm64: gic-v5: Communicate userspace-driveable
 PPIs via a UAPI
Thread-Topic: [PATCH v5 35/36] KVM: arm64: gic-v5: Communicate
 userspace-driveable PPIs via a UAPI
Thread-Index: AQHcpzmXAqqGLzsX2kahds3TU55X/Q==
Date: Thu, 26 Feb 2026 16:04:31 +0000
Message-ID: <20260226155515.1164292-36-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|PA4PR08MB5950:EE_|DB1PEPF00039233:EE_|VI0PR08MB10969:EE_
X-MS-Office365-Filtering-Correlation-Id: 165ae7d2-8521-476c-4ddc-08de75510bda
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 Dc0TdhKtXHwmB+W/Rb3KwWAGZHxz8vQ4UKolwy7b6RkHKZF5tjGYe2VcDC0ias+TuY+ZW0dienDwXCmSY7i1TLoUEAPEL5USd8Jw1hidc7cbBTo+4dcTMmrKcpMW1EdMTwrRkbTeGmXo2Zl86FSoijJeJmC29p6mbZmLUDkMaSJTUMZcwOXOGznE0DglaEbJEIjzVoqWJzB1AflbazLXJ+TAot7mu+bfHcMQKoZhvpT7oNzTQy04pDOrBR75vh8bQQCNZUYKEWblMEFkqlBnwmEE0KXn2pGpQby+j943hDJ8t//M8cnKAwMyWbnyI56rqWDyWjg8DXsICL3iHmsOsfgCGmu2KmzqEpmUn94DdysUPaSIbAeU5m6Z3FcOp+h8Mf6jUBTAuy8v8jPCavEKdKpzt0bIz46foRXNeYOTusTrMU84FqGauLeGXhek74+8hFoEF9onGELB1UP7QfrqMdCpSXFLTCFmJckNVoGBXQ20UpHsT08j10IA/M0ZfjK1chTiY2kj2kgmO2hY7xUBpVYDCuCLpmvZukGBeF6vKk6V5dQdOn0qP9vulPqbP7xyzwwNs3512+xGUM3B5L2n5jGSlxopOjMqpIs+5gx9HQOoCA42XqKERLBtjiD/xon+RYDdAVS5hMgBkOJ0gAttXxCa/kAxdrn4pfmu7zGvkybkUVDxwNY+EUEv4ulq9GFFsjMVZpJzh1w3ujrNcrFpzyhlbi3Lcks0rRaSlCeHDdb6MK09h7877lljtTuZNmHQyTHW81Dt5dLYpW9Cor1/VoropH173XpErT5/d+pAZB8=
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
 DB1PEPF00039233.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e5f97caf-1550-4825-3b74-08de7550ba69
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|376014|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	jqs6bb9+ZSNMY8HkmkNfr3MMswsS/JaUfoE7VgwhdaYZawAk5m9LRr2kNJoNLc7FGllyHITkwIczVkXBd3QQ0Q0P+AV5N2u75JAkwGtXaFIlxFhslNUxXye8vXhkGhs0ihZtUg8HpuYX740WLGvP3T4/RWEudlpzhJ8myEOXpBGx+jq5AZk7c2tr1uRXACgo6MNAVXE5fhv4uw24g9l2jruqH02uNmJ8b4O7o4TWdJummMeyFXJ1TyPKY1s3PiZLrTmS2IiIorOJNQFinQbwx92FOET1vWVATaolHLJgnrCpSBoYDz3gVr2EeUXD0JdKxrosujhd7Q3jFSKzaL2zcudsdkSY4CpRuwcTFSDiXklTMwlMRj+6Dw+Rm79quODZuO2/CthM97PJzdcUrLLEnqVd6lKvh07beN/czQ3XtwOhRcmvJ2ygSdjWb/R0Bhi6qvtuIun8ApYPvF11hHkTRPUyxgjV7qcfdNXBZX9jedbHk8sZ2FUGzNu3jRnPcTHPYbb5klUckH8669oKpkulQKF41JgpI8yPWre5C6TS6IeCtr5VmOZ/nai1RKbx1K/qugAwnL3emZ6vrVEnB9xcculS8K/lY2Dbw6MIHHP8QmWJLTWqtyzWyNLdFswEKiRF2YCSnV/JMw6b5Fc9clxGqUS8q8ugNzriziFuidXzQUwas205KJffpALvccCv9V0mEIPKhoZNLdBNBeMMG/c55RoyccKB81iwaf66UunZi7RGVxzUcrYyRu761dx9VTqPYsrZtzVkca77g2OHL1dbpUh6g/YBsH7953/dZxJZznvODdSfHHxYEm/1XlwyKrKawYnyHVL1R7w2vqjedRouZA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(376014)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	AbknPq9GIlehNsNpz6sbyjJf9wObWMPJ4XLawtkVaTto4kaTnMFS0Gxeq4xWkkbhyl3TkXNfmo413DVUCx9FiJ8T0xAFXuHuJ74bzgaGPJ2ua21Wl/0R2b4WuuvIppdqE75/CIWK/Kn5lLVA2CxKS+L7hJ/r/dbEdvsnvG9m5JJP3cHRQyBRykCMQHzgwE0Y2A8dmyzBYfx2TxlrOZK2pYQO6ACn2FsreWH3XxWUFTpkEgn8gQik11yICwwLtC9BaKaMuJ0fWQcxeIHtVF3/AcZyyoTqWX8pAlI0uHntvBGygTanC6A7C4pzSRHu/SuISzxgAYN8iFfm9dc5lwS6BgfyH+6hWDl3IpS6UgcN6NbCKWQ9nuiF49M+FY1eAhadziJhdkp54dgvocqb+HyEEdZxy4+WzwWoDXUSgakHa2ST8jE8wpVY1gqYzgqPFMRh
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:06:48.3650
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 165ae7d2-8521-476c-4ddc-08de75510bda
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039233.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10969
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72055-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,arm.com:mid,arm.com:dkim,arm.com:email,huawei.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: D6D1E1AB45D
X-Rspamd-Action: no action

GICv5 systems will likely not support the full set of PPIs. The
presence of any virtual PPI is tied to the presence of the physical
PPI. Therefore, the available PPIs will be limited by the physical
host. Userspace cannot drive any PPIs that are not implemented.

Moreover, it is not desirable to expose all PPIs to the guest in the
first place, even if they are supported in hardware. Some devices,
such as the arch timer, are implemented in KVM, and hence those PPIs
shouldn't be driven by userspace, either.

Provided a new UAPI:
  KVM_DEV_ARM_VGIC_GRP_CTRL =3D> KVM_DEV_ARM_VGIC_USERPSPACE_PPIs

This allows userspace to query which PPIs it is able to drive via
KVM_IRQ_LINE.

Additionally, introduce a check in kvm_vm_ioctl_irq_line() to reject
any PPIs not in the userspace mask.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 13 ++++++++++
 arch/arm64/include/uapi/asm/kvm.h             |  1 +
 arch/arm64/kvm/arm.c                          | 10 +++++++-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 24 +++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5.c                 |  5 ++++
 include/linux/irqchip/arm-gic-v5.h            |  3 +++
 tools/arch/arm64/include/uapi/asm/kvm.h       |  1 +
 7 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 9904cb888277d..29335ea823fc5 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -25,6 +25,19 @@ Groups:
       request the initialization of the VGIC, no additional parameter in
       kvm_device_attr.addr. Must be called after all VCPUs have been creat=
ed.
=20
+   KVM_DEV_ARM_VGIC_USERPSPACE_PPIs
+      request the mask of userspace-drivable PPIs. Only a subset of the PP=
Is can
+      be directly driven from userspace with GICv5, and the returned mask
+      informs userspace of which it is allowed to drive via KVM_IRQ_LINE.
+
+      Userspace must allocate and point to __u64[2] of data in
+      kvm_device_attr.addr. When this call returns, the provided memory wi=
ll be
+      populated with the userspace PPI mask. The lower __u64 contains the =
mask
+      for the lower 64 PPIS, with the remaining 64 being in the second __u=
64.
+
+      This is a read-only attribute, and cannot be set. Attempts to set it=
 are
+      rejected.
+
   Errors:
=20
     =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index a792a599b9d68..1c13bfa2d38aa 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -428,6 +428,7 @@ enum {
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
+#define   KVM_DEV_ARM_VGIC_USERSPACE_PPIS	5
=20
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 40d69a96d78d0..a945951dec61d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1447,7 +1447,7 @@ static int vcpu_interrupt_line(struct kvm_vcpu *vcpu,=
 int number, bool level)
 int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level=
,
 			  bool line_status)
 {
-	u32 irq =3D irq_level->irq;
+	u32 mask, irq =3D irq_level->irq;
 	unsigned int irq_type, vcpu_id, irq_num;
 	struct kvm_vcpu *vcpu =3D NULL;
 	bool level =3D irq_level->level;
@@ -1484,6 +1484,14 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kv=
m_irq_level *irq_level,
 			if (irq_num >=3D VGIC_V5_NR_PRIVATE_IRQS)
 				return -EINVAL;
=20
+			/*
+			 * Only allow PPIs that are explicitly exposed to
+			 * usespace to be driven via KVM_IRQ_LINE
+			 */
+			mask =3D kvm->arch.vgic.gicv5_vm.userspace_ppis[irq_num / 64];
+			if (!(mask & BIT_ULL(irq_num % 64)))
+				return -EINVAL;
+
 			/* Build a GICv5-style IntID here */
 			irq_num |=3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
 		} else if (irq_num < VGIC_NR_SGIS ||
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 772da54c1518b..21d21216f2185 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -720,6 +720,25 @@ struct kvm_device_ops kvm_arm_vgic_v3_ops =3D {
 	.has_attr =3D vgic_v3_has_attr,
 };
=20
+static int vgic_v5_get_userspace_ppis(struct kvm_device *dev,
+				      struct kvm_device_attr *attr)
+{
+	u64 __user *uaddr =3D (u64 __user *)(long)attr->addr;
+	struct gicv5_vm *gicv5_vm =3D &dev->kvm->arch.vgic.gicv5_vm;
+	int ret;
+
+	guard(mutex)(&dev->kvm->arch.config_lock);
+
+	for (int i =3D 0; i < 2; i++) {
+		ret =3D put_user(gicv5_vm->userspace_ppis[i], uaddr);
+		if (ret)
+			return ret;
+		uaddr++;
+	}
+
+	return 0;
+}
+
 static int vgic_v5_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
@@ -732,6 +751,7 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return vgic_set_common_attr(dev, attr);
+		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 		default:
 			return -ENXIO;
 		}
@@ -753,6 +773,8 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return vgic_get_common_attr(dev, attr);
+		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
+			return vgic_v5_get_userspace_ppis(dev, attr);
 		default:
 			return -ENXIO;
 		}
@@ -773,6 +795,8 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return 0;
+		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
+			return 0;
 		default:
 			return -ENXIO;
 		}
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 626d9d62cb7e6..ef5c65067b02f 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -137,6 +137,11 @@ int vgic_v5_init(struct kvm *kvm)
 		}
 	}
=20
+	/* We only allow userspace to drive the SW_PPI, if it is implemented. */
+	kvm->arch.vgic.gicv5_vm.userspace_ppis[0] =3D BIT_ULL(GICV5_ARCH_PPI_SW_P=
PI);
+	kvm->arch.vgic.gicv5_vm.userspace_ppis[0] &=3D ppi_caps.impl_ppi_mask[0];
+	kvm->arch.vgic.gicv5_vm.userspace_ppis[1] =3D 0;
+
 	return 0;
 }
=20
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 30a1b656daa35..55d5fc28a08be 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -388,6 +388,9 @@ struct gicv5_vm {
 	 */
 	u64			vgic_ppi_mask[2];
=20
+	/* A mask of the PPIs that are exposed for userspace to drive */
+	u64			userspace_ppis[2];
+
 	/*
 	 * The HMR itself is handled by the hardware, but we still need to have
 	 * a mask that we can use when merging in pending state (only the state
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index a792a599b9d68..1c13bfa2d38aa 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -428,6 +428,7 @@ enum {
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
+#define   KVM_DEV_ARM_VGIC_USERSPACE_PPIS	5
=20
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
--=20
2.34.1

