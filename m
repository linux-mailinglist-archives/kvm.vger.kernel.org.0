Return-Path: <kvm+bounces-72042-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GG1ZMAp1oGmtjwQAu9opvQ
	(envelope-from <kvm+bounces-72042-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:30:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 22FFA1AA61B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:30:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E52913237227
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5232C480349;
	Thu, 26 Feb 2026 16:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RS6uJXGw";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RS6uJXGw"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011024.outbound.protection.outlook.com [40.107.130.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC60147F2C1
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.24
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121744; cv=fail; b=GKJMK7W97lWiPfTJrEPLAcK7lgO9ksNh2YVu/GS84L23wY7f1ND9wpNqU0zRSoT3BAPc7f89iWGFRddIA3MofLysTnwiSz5z0rSIfVMUQP4+5xoMt/oIaiBQJPZQirP+Y11+rdLH+RayaSpzr3xDcIPK/+2NeQ+4ZLqQ3gl7GD8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121744; c=relaxed/simple;
	bh=ev66aZxO9mvVjA/k7MoHMebCcWgARqiKDhYwEx411mc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=alRClO646KVA1t1a5IOMw5WWNJHiGJZb6h7ENsmeGDqzBjAGaihdJ+5gQL80jvz5WCZwhxRDff2fh8IEorE1TGkMNTtKH63XSEekuREQgOuZI1dGFAR7W1QwG3KUTdWx72RneEzcXBXt2VaK97x5ud68R2B/QboWVaocxpjVgXU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RS6uJXGw; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RS6uJXGw; arc=fail smtp.client-ip=40.107.130.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=R8QLHuwNOHS0g/LYi92jujx+ymIAguMUcN8Fb7EN8CNMrzoouGveq1WZQAor5uN+3IpOV1wO1dS9trJ1j1qURY1Oyd8PoVU0/Vw7nX+sO8AqUh6toBQ6tM5NQ6Wfap3HYr0jnoHigfl4ALtqwdIm2Mdy1CTIe21SC0Z3pvDGa6+TGbJ/HxJKKluhXrHTnVruN6TzZuZDZeq7h1jyrW2qkbLV1Rgjfgl5Nt9Uw+zgI1TDg/Xj8ryYENa+1M4Q0W3kmSsZhcGVxKJK8vDsRNZqOj+Z2YtL+k2qjjiP0+5Im8ESBmFbz8JSAumsHop3Y5HPM2Mcf01zWnsAfhxO4TR8ZA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gwUlyWKrLuWHy2EmHv3nmNHvueYik1V457hhqKkb5/4=;
 b=m2nrMYXW2AvH/f6P4oqHG+wyUA/S/tQksj2r/q6H8JnHlWdeli59BOdqPcPKm0AI2RbFKcZxUjNilE9cwXgDVRCJQJwRXQPw3tYUvGfdnF6JhYFbMNkr1OeuFlTJFVBpJaIhpSq6Wa8NWzOaAK7roSQiOXeoYi9Q6LxCYvx4cfEcWzQaIqxXn8eOIw+EQzNYZQ7xAG9wdacKyj8Eusah86gqV8VAVdwdKCv2oWZ1UJHkOXXcLih7HZ8xItIU8OJdLqtGBEWWEWIgLgISu5r5gMPK6ETLIlXayyCZRIBr4mUWCiM2ueqMdJXYAZG08Qskthwm87aEyjIHPxuEidnYzQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwUlyWKrLuWHy2EmHv3nmNHvueYik1V457hhqKkb5/4=;
 b=RS6uJXGwe5pCr+12KLzm8dMwnuhEQnvFYq4ASn3JI/D0H8TZ1PbGuediwuetM8TGdiiU0UHrhVtUz6c9HfQ6GAIFCrg8hs3S9y/ALm58vyL/MymNSaSQ1CViLlAZdATOh8BQcH57wyXYJqO5sUSuraT1YWn5EQeKSAFemye3p24=
Received: from DU2PR04CA0247.eurprd04.prod.outlook.com (2603:10a6:10:28e::12)
 by AM8PR08MB6452.eurprd08.prod.outlook.com (2603:10a6:20b:360::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 16:02:11 +0000
Received: from DU2PEPF00028D12.eurprd03.prod.outlook.com
 (2603:10a6:10:28e:cafe::25) by DU2PR04CA0247.outlook.office365.com
 (2603:10a6:10:28e::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.23 via Frontend Transport; Thu,
 26 Feb 2026 16:02:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D12.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.8
 via Frontend Transport; Thu, 26 Feb 2026 16:02:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LBhKopQhxd02y44a1uyUAMONhMLDIWOzskAP+Wg9EJV6qyIiETnPu4KcbVbw6+MayxOhhZjT1Ea4kuZ4UpEQzTlzKZGTs4caDc+1Mg7UarCZGDlNgnyXYF3lcBDPUd9Uka2nBaMnmEtmpwiXBV4qoLc2U94N0s1x3JdhLyIkchO4FgcdOmHF3NFVK+j8MYB9Hwt2sNBWQVZUyDJtom+xCBwed61EaSrqD4L8HWgt6LSgviCIfXD+OjfUSiZNl8Lx7sxguRAbJaZpUBku/w1ABa3mCc0Rmg0MPbaNZ6KS6sHCYFW+3k4y2+5IOxy1Msbmu5QUb32oiurmGoSBqpZS0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gwUlyWKrLuWHy2EmHv3nmNHvueYik1V457hhqKkb5/4=;
 b=eqyBh+cf7EhPyxSFNIodsCwJNWPj5yhdE/PiOrj1Y6uCvbNFXAqn3Uy6InfU1lIJ+P8wji0a7KCYlvgl55NQ/mzupuVu9c1fcr5mIz6b7wdLokRvDfzt+JempPNdx4661K7ZNxGUgzcvVe+3BS4pKOtkq/grhBzRZa4Nbxs7KLsLdlUFxvrjoIZRJvfyWw9AbTab0wm9UDdqxMEv9aCs48j2j3KtadjpXytUZ/g8pkOKqwpwJSETKDnCV6DTutNDVkrOnI4mYPHqrKaEtoSxe2dBOtJksVaexfIAw5kI247Z7JWqczg7ixirKs84XEwVNuHy/jn8H9iKzvxzWuBMpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwUlyWKrLuWHy2EmHv3nmNHvueYik1V457hhqKkb5/4=;
 b=RS6uJXGwe5pCr+12KLzm8dMwnuhEQnvFYq4ASn3JI/D0H8TZ1PbGuediwuetM8TGdiiU0UHrhVtUz6c9HfQ6GAIFCrg8hs3S9y/ALm58vyL/MymNSaSQ1CViLlAZdATOh8BQcH57wyXYJqO5sUSuraT1YWn5EQeKSAFemye3p24=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by VI1PR08MB5486.eurprd08.prod.outlook.com (2603:10a6:803:13b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 16:01:07 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 16:01:07 +0000
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
Subject: [PATCH v5 22/36] KVM: arm64: gic-v5: Trap and mask guest
 ICC_PPI_ENABLERx_EL1 writes
Thread-Topic: [PATCH v5 22/36] KVM: arm64: gic-v5: Trap and mask guest
 ICC_PPI_ENABLERx_EL1 writes
Thread-Index: AQHcpzkeCa26FIu9wUeOLI3Sa/cJ1Q==
Date: Thu, 26 Feb 2026 16:01:07 +0000
Message-ID: <20260226155515.1164292-23-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|VI1PR08MB5486:EE_|DU2PEPF00028D12:EE_|AM8PR08MB6452:EE_
X-MS-Office365-Filtering-Correlation-Id: c9e1c3d6-58a2-4a89-c51d-08de75506636
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 1bW7h5G7CkG7eGcO8cRQ+4v9V2hRffzXNkgZgpiKVFpAYqWrETLEm/7dfaKmAZa2wu0GfMDtHZ1abSFWsYadchapDTI5gMON4L1CZ9O7DxrLqOtt+CDohTq4Qb4LX+camPNfmqmS2SMA3h3Xz/O2GTP9sFHMDGmn19IAisUnbdP/TooicpG5GPWUGE7BOwWsKW/DWl+wVVuuuGwrunWrJW30yl/Gx2BBXJ0UVHLWICjz3dMnN+/9ffLPThG84zf7QHD9FrERUPDiEOxMqtnW8TYZgZD44K+MMR0nkKW7Vvbl/m2PZAd9DfMFM9StxhtoRIvZN4k06P88GHtnlNl0l4JCbNbz6Krz/LbKulRwoZ+/xVNrtE+X0F3hJUqgjqVUivNjf+/uISRJNMqsw/J1yJtykUkyNm2m1EUETYC+jt+/pf5gFfdbQzRKeRk0O2O0Qtu55teS1U5KrM/khbZ1wwSOcIut+Hc/hCqCnrf7T4shg+4oN/jNtm9Pvr+dqzwcQK5DN/adNGnB+0kv+yjo1ypUJzQZTJHY6qW+diXv+wvWEdWes0NiI+XqwOccTNhn3DxLcFEaQuHTLE313VIb5KfoXyyjqF0tbDo7EHuFcpOJgASeWpCezg8W7cyDp+L3brYDyhSHTWtdpGR3kmQR+TyGP+y89QQRJaYFpIxp3irgwMtaLAzfG2yPE5q4xvQmJ5LCmlr6rVNRcKh2ziF/rwlh0weD8dz/ObRyPi46amFE6Yts60DGktKSjxhesZpa5QiDaUqX/DSwaB6aENXB+Ne87aWnDePWF0Ave7sVsLw=
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
 DU2PEPF00028D12.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c78d817f-f06d-4d0a-6590-08de75504098
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700013|1800799024|35042699022|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	loD3MDt4P9aGa+venz7Ti/N2JkDyiOHsKC7v//5uPVL0Nnu6WmboWhrS+vuTJQPMFAOFrjg38OrxtD0Z74yys6RRA4pyAgIeSv15emt2tON2ppPEmFSMBN0WGeQG8QRhP/VgulParhcgz4S/FsJjLyRndu4Tbt5a/MpwgRjaI7lg73bG6KpyHa4Caws3fnZAg9QhV9pPcz+OZwXYNFx9bA4hMyXakqEIKMbf9D5qPd0jtPGw/jDLjTkutlFL55bVKULwUUzy3cxoZruY4LbD3tyRYA3OFlhUQuE23V2sdR22xOE1JXNbSUbTSbm8fXsD3ZUdEf3aXMA/o4Mzg2ccjMyaXVZFXgu2n+btlz4wNKaUf+wszDAfeg3AphaBE000kUktv06hXoP18LmNAYv1C1OlxE8GjUG15yii6aYFo56DQ4RMvNCydtgn9gPjZJEgsHW+MGZd40sutiL3N9pWrBwz+yVD0H4FZIK4XLrs4qNAA8+YYgW/hVuRz7cy57UHpVvlr3AnFxvcop65enQ2tjOniuh4yW+rieXTH1ltmAzlzYt22uXUkaqYqxp8QSw6ZYaM9uRRn71PAUQJo5nIu43jPNkzvFI2Y02JjDZr/a9l6UyoJbLhRQ+MdzQN3Dnthysp8i7+wcCCwMuh9r+vbb3J0O0RNFfV5GWZEjOP4q0ojNzhwlcRwqeYvBdJKfatjEZqcRHNcKZdwYEl5PL2pVglV7q2hTU5iSDtW7XtSFF5osFYHWMwVBNZnB+uY2kOCye3Ahn4RWhv+o2RcKda5hXUUDT4s6E2BLf0o+hi/fXBYgmcjSnkoNixkv2On77/Fwv2XBb41DrrfmQGDmxxnw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700013)(1800799024)(35042699022)(376014)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ev+PLgW++d0GPDEoz0em3PO649l7CdEqVdiU48huA16ez3Bm959uhoLjfDNqG18nVmLRqRTJ6uZs9SjwzA1xc0OUSNLVG47/tzJ3O4xmXiGsUeh258LUmGVEm8MHBLPyHNiQbzkGeNpNPyJighVkejyyCpM4uriWAH3YIA/2d7/rknkZjxJfpCCffXuLvDVtWqO8/XiLXNhLAb5SW2VoNdIdfI5cz+GTW+EczVe9nEuWixOB8YNWctv/xBcVas/v+GU8JDVvFvc8RMTJfaoABQ8Mv0yJQKkHuhuKD+yX8zjHnQ0ezgjlep5aUFM1srW5I1TLkEqlmRm5+Q0ZuVLx5DuPnm1Sy/q5aU7dredLP9Y/jtYfkdgbuTL6JlX/cl+qsJXYM23QHFjBHbS/4GXKGWbZL4XOsi7XrgI8VfCtHd4+33VeuPK4bSbaPGt/DVTX
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:02:10.4751
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9e1c3d6-58a2-4a89-c51d-08de75506636
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D12.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6452
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
	TAGGED_FROM(0.00)[bounces-72042-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,huawei.com:email,arm.com:mid,arm.com:dkim,arm.com:email];
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
X-Rspamd-Queue-Id: 22FFA1AA61B
X-Rspamd-Action: no action

A guest should not be able to detect if a PPI that is not exposed to
the guest is implemented or not. Avoid the guest enabling any PPIs
that are not implemented as far as the guest is concerned by trapping
and masking writes to the two ICC_PPI_ENABLERx_EL1 registers.

When a guest writes these registers, the write is masked with the set
of PPIs actually exposed to the guest, and the state is written back
to KVM's shadow state. As there is now no way for the guest to change
the PPI enable state without it being trapped, saving of the PPI
Enable state is dropped from guest exit.

Reads for the above registers are not masked. When the guest is
running and reads from the above registers, it is presented with what
KVM provides in the ICH_PPI_ENABLERx_EL2 registers, which is the
masked version of what the guest last wrote.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/config.c           | 13 +++++++++-
 arch/arm64/kvm/hyp/vgic-v5-sr.c   |  3 ---
 arch/arm64/kvm/sys_regs.c         | 43 +++++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index 60da84071c86e..9af9d96351b89 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -811,7 +811,6 @@ struct kvm_host_data {
=20
 		/* The saved state of the regs when leaving the guest */
 		u64 activer_exit[2];
-		u64 enabler_exit[2];
 	} vgic_v5_ppi_state;
 };
=20
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 5663f25905e83..e14685343191b 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1699,6 +1699,17 @@ static void __compute_ich_hfgrtr(struct kvm_vcpu *vc=
pu)
 					     ICH_HFGRTR_EL2_ICC_IDRn_EL1);
 }
=20
+static void __compute_ich_hfgwtr(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, ICH_HFGWTR_EL2);
+
+	/*
+	 * We present a different subset of PPIs the guest from what
+	 * exist in real hardware. We only trap writes, not reads.
+	 */
+	*vcpu_fgt(vcpu, ICH_HFGWTR_EL2) &=3D ~(ICH_HFGWTR_EL2_ICC_PPI_ENABLERn_EL=
1);
+}
+
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 {
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
@@ -1721,7 +1732,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
=20
 	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
 		__compute_ich_hfgrtr(vcpu);
-		__compute_fgt(vcpu, ICH_HFGWTR_EL2);
+		__compute_ich_hfgwtr(vcpu);
 		__compute_fgt(vcpu, ICH_HFGITR_EL2);
 	}
 }
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index 47c71c53fcb10..4d20b90031711 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -31,9 +31,6 @@ void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_=
if)
 	host_data_ptr(vgic_v5_ppi_state)->activer_exit[0] =3D read_sysreg_s(SYS_I=
CH_PPI_ACTIVER0_EL2);
 	host_data_ptr(vgic_v5_ppi_state)->activer_exit[1] =3D read_sysreg_s(SYS_I=
CH_PPI_ACTIVER1_EL2);
=20
-	host_data_ptr(vgic_v5_ppi_state)->enabler_exit[0] =3D read_sysreg_s(SYS_I=
CH_PPI_ENABLER0_EL2);
-	host_data_ptr(vgic_v5_ppi_state)->enabler_exit[1] =3D read_sysreg_s(SYS_I=
CH_PPI_ENABLER1_EL2);
-
 	host_data_ptr(vgic_v5_ppi_state)->pendr_exit[0] =3D read_sysreg_s(SYS_ICH=
_PPI_PENDR0_EL2);
 	host_data_ptr(vgic_v5_ppi_state)->pendr_exit[1] =3D read_sysreg_s(SYS_ICH=
_PPI_PENDR1_EL2);
=20
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 589dd31d13c22..740879ecf479e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -724,6 +724,47 @@ static bool access_gicv5_iaffid(struct kvm_vcpu *vcpu,=
 struct sys_reg_params *p,
 	return true;
 }
=20
+static bool access_gicv5_ppi_enabler(struct kvm_vcpu *vcpu,
+				     struct sys_reg_params *p,
+				     const struct sys_reg_desc *r)
+{
+	u64 mask =3D vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask[p->Op2 % 2];
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	unsigned long bm_p =3D 0;
+	u64 masked_write;
+	int i;
+
+	if (!kvm_has_gicv5(vcpu->kvm))
+		return undef_access(vcpu, p, r);
+
+	/* We never expect to get here with a read! */
+	if (WARN_ON_ONCE(!p->is_write))
+		return undef_access(vcpu, p, r);
+
+	masked_write =3D p->regval & mask;
+	cpu_if->vgic_ppi_enabler[p->Op2 % 2] =3D masked_write;
+
+	bitmap_from_arr64(&bm_p, &mask, 64);
+
+	/* Sync the change in enable states to the vgic_irqs */
+	for_each_set_bit(i, &bm_p, 64) {
+		struct vgic_irq *irq;
+		u32 intid;
+
+		intid =3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+		intid |=3D FIELD_PREP(GICV5_HWIRQ_ID, (p->Op2 % 2) * 64 + i);
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+			irq->enabled =3D !!(masked_write & BIT(i));
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	return true;
+}
+
 static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -3447,6 +3488,8 @@ static const struct sys_reg_desc sys_reg_descs[] =3D =
{
 	{ SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_IDR0_EL1), access_gicv5_idr0 },
 	{ SYS_DESC(SYS_ICC_IAFFIDR_EL1), access_gicv5_iaffid },
+	{ SYS_DESC(SYS_ICC_PPI_ENABLER0_EL1), access_gicv5_ppi_enabler },
+	{ SYS_DESC(SYS_ICC_PPI_ENABLER1_EL1), access_gicv5_ppi_enabler },
 	{ SYS_DESC(SYS_ICC_DIR_EL1), access_gic_dir },
 	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_SGI1R_EL1), access_gic_sgi },
--=20
2.34.1

