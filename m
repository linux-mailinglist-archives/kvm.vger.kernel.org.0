Return-Path: <kvm+bounces-71999-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uGJ8HflYoGlPigQAu9opvQ
	(envelope-from <kvm+bounces-71999-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:30:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F1791A78F5
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:30:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 859D33054DF9
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31F6E372B4D;
	Thu, 26 Feb 2026 14:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="W645n4vm";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="W645n4vm"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010017.outbound.protection.outlook.com [52.101.84.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C555332902;
	Thu, 26 Feb 2026 14:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.17
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114819; cv=fail; b=WXaXZy1JO2gxqzj+RRvQx7IcyABo67dYH6IW9cHO3do6OEUwKx0u2WSppVgsaYptNNXbyucrdiH1mksojv3IbagO0H+q6IgIFqDf/hj5VEDhOm0PlltORiVwS3/bKpKA08zzsBq4jpwJIzZOOJ9mDmO5qAgAprwUlW9CH3VLUIc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114819; c=relaxed/simple;
	bh=BQIv/00MyhEGiH372ByFJhgNgLeHG2Y8ZhzSxSSR6o8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eSSr1SOUYY3SyymHKazfYp2NWw4J0Zj7qdKW8J/TECwOHGi8LrWtnFMJnRYbci97vuy8wm4IC61AHLsUtDIeTIzhD2Lhv4yzqvZ9z+xzkBgnb7XNuHAccetRrkLf6LxjtZuTppHAfcmldsX0vYiDnTLUL7hdFQGsMf5YNoQW0Zg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=W645n4vm; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=W645n4vm; arc=fail smtp.client-ip=52.101.84.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=uu83RncXK0f9Ia27Z6PotNHxMwLBjpBGHZlLneuw4erTO4zK59l+sGWyAvuBaEMPMGvqvRZvOkxTTM521dP/GsVC6gfnp74UbaejdRqLLk/4g1NSMX2k0YxrZcL1rBgQQNfoyXDMpbAoa3a85xKtQp1So7MsjbeA0SF8pd6/a2xnsmMazoQertQLmobYP/i7FBeudMcIbUjxBomciwRP09JQE3R6onBT6GfzuShE0UqAz/agmfRw040AEyHLCEAxAedz+t4/e/k/wO2pt5YbkmVH3JlfnRstbjlimvb0RR13y1PuIpQgcrMA33rJpzB65e8Q+dYuFL/n4zoylU6/rg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tjj1GwNmvjc2glJANIeb9zv6834LqMESa/87e2HukZU=;
 b=K32UeXrofq91ssTEUNmZHb/SHWFCB5W1Baliae3B/xmnyIVPons8aKgrQekhr33s0WTmAn68xh7WB9rY8/1V0szputljKGJBOIM51DYoES9nVKnZ3+7sBkuOcCPAQIlFQ7d8V1ozijUMym3KWADyUfwgZnkptUiien9ubcqM5x8l/ZbxJ9v5fQPde8bQhMR90CvW1ObAfVaSJiDdsDKqhpbhd6z8FVVfJUaL5DJyEMNPH+dKgMALrf3+phvHM6R+z+562L9Gxp3qxVUVCxSodd4ZG4fNab+8wIQgw02pGe68JMMfDJfVtMOMTpDYttxcN+Pb2tuI3d6GRQLf3hFaXw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tjj1GwNmvjc2glJANIeb9zv6834LqMESa/87e2HukZU=;
 b=W645n4vmIUYw3sPZqZ8x5Fpo+hHToC8rV/nyE7PEAx+RLs1zqrQ+XMAnlslpDjdKmvibwByNHolUZ/j8TbaCBYTYhjRVB239eCEBXQvdnh5AoXF3dWQWRPFmUJpO8jR4cjyG4yNrIaH/5A58BBkEXp+d9sOS7gSD6xvip7BoYDk=
Received: from DU7P195CA0010.EURP195.PROD.OUTLOOK.COM (2603:10a6:10:54d::13)
 by AM8PR08MB5554.eurprd08.prod.outlook.com (2603:10a6:20b:1c5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Thu, 26 Feb
 2026 14:06:48 +0000
Received: from DB1PEPF000509EB.eurprd03.prod.outlook.com
 (2603:10a6:10:54d:cafe::c6) by DU7P195CA0010.outlook.office365.com
 (2603:10a6:10:54d::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.25 via Frontend Transport; Thu,
 26 Feb 2026 14:06:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509EB.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 14:06:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N4Nd/dTTqa7FeJgniF22doUtaqqhuzpDnZpcQZ2OCZYFOtnu4pXbRBclPfjFrfer/vpEDT/EFXxHreYL3lXybHaK6x1ETtGiGlr6c7V4+N3Bqwpv2tfpMsFVIaCl0bJhPygLzKI7OECtA6i52v/1Cu8xqZXn59Hoe3yz8vZrY7cTKHxf/t5qEqQQJhSkQFbGLAuMK61iA2177cLpWPDGm5HJA+xWxZYVaOrtwyW5BMNbgSYr3p5XEB4x67TMEGLo6suc4uF5aIk8mTRsSgpKgDp2lbCNNF2WcVWIYVgOtKNU1fYwk8cRHpXg+cAGEzgL9azgDg1e+0HGHlGux6bg5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tjj1GwNmvjc2glJANIeb9zv6834LqMESa/87e2HukZU=;
 b=dKPaFxDDWxayFwCBG8fTirVps7vN8r7ug8fcAqjBm6ECotEXEMBgqJvhNGtetTTxs2arHKHvnQM2qGPq6Hedu4cEPbq8DY/rPKEVHcE9IS2f4SoxQu8dHq0UB4buXkRREtZm8M2dbTefKhJpt4ZVydkWX6zHZMRPvZmg9XIK2Bh7OGnf7AvLpKHUFjNzTB8w2sCujqaJ47yP8XXO1IC5nDljUPCHZ3OgetIo8aiwMy8YgST2DSH8aPfY8M3mHiJkzfUw6aUe7EQy2j1zwZIMCfxYVqzfDyWaOKReYWEMdoKbOjPOS4PO9qBdha9mM/CbL6WiRCZAZzek9cAQLoPh+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tjj1GwNmvjc2glJANIeb9zv6834LqMESa/87e2HukZU=;
 b=W645n4vmIUYw3sPZqZ8x5Fpo+hHToC8rV/nyE7PEAx+RLs1zqrQ+XMAnlslpDjdKmvibwByNHolUZ/j8TbaCBYTYhjRVB239eCEBXQvdnh5AoXF3dWQWRPFmUJpO8jR4cjyG4yNrIaH/5A58BBkEXp+d9sOS7gSD6xvip7BoYDk=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AS1PR08MB7537.eurprd08.prod.outlook.com
 (2603:10a6:20b:481::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 14:05:42 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9654.014; Thu, 26 Feb 2026
 14:05:42 +0000
Date: Thu, 26 Feb 2026 14:05:39 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, catalin.marinas@arm.com,
	will@kernel.org, oupton@kernel.org, miko.lenczewski@arm.com,
	kevin.brodsky@arm.com, broonie@kernel.org, ardb@kernel.org,
	suzuki.poulose@arm.com, lpieralisi@kernel.org, joey.gouly@arm.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v14 7/8] KVM: arm64: use CASLT instruction for swapping
 guest descriptor
Message-ID: <aaBTM3C2MbIvtUn8@e129823.arm.com>
References: <20260225182708.3225211-1-yeoreum.yun@arm.com>
 <20260225182708.3225211-8-yeoreum.yun@arm.com>
 <867brzah6g.wl-maz@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867brzah6g.wl-maz@kernel.org>
X-ClientProxiedBy: LO2P265CA0102.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::18) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AS1PR08MB7537:EE_|DB1PEPF000509EB:EE_|AM8PR08MB5554:EE_
X-MS-Office365-Filtering-Correlation-Id: e61ee321-230b-457d-c802-08de75404865
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 Jv6qdiNMg0MFSuDz846flCcX7UGgbM1avS4YwLaD3uzmctjLWUz1VorqbCEbjjhQy29R012e5AsDPSH3Oxhdb2BIxR5o/zl3s+vCgMWFTCjYHpSxMVYCLZLO3rfmZJT0FiH5apdwq4faMSvHNckX76hzxOZVvn9d2s2qEFH20IVpPNCg6TNEGEXMpRWi/D2ZQ1yX6jgN3e4QYZKXmqK6aE4BYtWspVw4P3SrJz1ypjJxPnE0oK6hbBBm6PEm42GJRwwqvcN3dgJXk3Pu0CeGt5c55ldNjiw9maqPuQt8X8VnasPeXoIFvKuCRtve2nQLBKGe/EhgabesQNWuDXmKmjAnYaW7iGmDzH2g9kvAJsQIKw7XcYufdYkRUiabMJaZgvDBcI72XpbtR7pPK3dN7aCuBfDxcvjbVEVdORZabdqL+rQXrf1zA/6ruKW2Wduyxm3VfPGAHrgGQ6hKUmpOzH3kM2LjNiu/DFAyvf8nlmuZ4HCJ3/X3n8phXRFKg9yfOJjAuOjVbGX/Sy9RdwaKplag0nOliUko/AOUxfuxMKrxeFmUWyOUZjLyrSGW/pKh/LrDyyMk+ku1ZLfUgsgI+Z5dXCeNkmWBAzv9Ve1x+1GfELs9OYz8FoA/gNVK+GvsiCKFXOlrh4dMaUBdZa2cM6mtFXAq/k52O1Rg5nhz40XoR5bpPLwvRWkyQeOWp2P9
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7537
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509EB.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b292a5f2-e66e-420f-2abe-08de754020f4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|36860700013|1800799024|376014|7416014|14060799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	AjN+2QJblqVsELNa2IvI5hdl9C4Z1FXKp+3U/m2lXrUxK40PbZyrpan5qQ+8cPxXpkbYkGXHtRMRFOvjyGeZHf0fUSf9H8dcYJzT/W9v8uBBULssF8e5a/Tp3ZHjtTkmFvGcXxaYEzkn8XydH80nJkfdgI0sVsymQ0xh9gQR9CBKgORxLYXU7NK4FgeWvlo9QV7RDoeOSgdJCS1/wXB6ptYVdyc+flpqoiVtKNx0uZKAvLQQoMhNJ314NnZ9lQHwkKw5mrQ86Two839bjiUjHpytA0zBiVFVoPCtp4t+xN7bWolmBPMYGHq4Ftq4CVFRKLt1uJoGkhAeHVB4f15dyUXPiIiEt5Wct0jkuea6ReejaavJzAnzPxnfGst3sHVT0x0nOl5LNZ8I/HrV0xEmgdlRzeqou681BtbLQ4qlYwRpKq6KZh50K/svq5JEn47s0E5pqzjIXEpMAB8vOBIVx2vY+KKqrho3WXkXiz4PPpYufMtdH2VaHi/7DitU5gT23ZKtxW1cVipDgYlo4xiE7E/vQT3koyg8hf/72L55WO1/uFiJyhX8Lc+7d1xn91xTOydj2cQql+k2Jzs3z//2FNDEBlBHkTKYXff6LfLjKa9fmjK6bHvA54Hvjf/XL2bTcg3KFOlNFTKmlHs06D6F42CY45XTSgyCgDqSwucA04J4GEuw/zvwY3BfSbpteHCyU1aNnUdwipH1lCxqLu44vJnMaD1X/WmfAeczxTIEDBXaFIoovpm3IXjxswvM6BSMcYJbT7nP7f1FF6CRoYdeQAqYF6rQvaH10UhRYJZ/ZRg=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(36860700013)(1800799024)(376014)(7416014)(14060799003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BP7YjMq4QVuzqJmyz4BGjoT7Yv4II48uCtqk3B4DItMBhcXd6DKesBd5nk2WUUUjqf1XENtFTJhGRxCNBWVQ0nylFEgnq3l+0eh8TQxIH5p72mx1nfM4WB7D0M8EW5S9KKNM6NjBvNKb5HOowXU3eUxXHkl8K7OhQf2n1rSQ6B9pDizynJsxbdrKaggIpVazjg136U8iDHv40nJr49IYTtb2/ashymE6Q3ScJQy8S41xyetFCHiQaVa1e8oA3hcoz+l4oHQL/tItkqHngCgsLZQqc7w9jWE25ybw5yHj0r1F44rOWLA3x6t7W8xxqRNo90yfFF/7sWvW12do+h4FkEopqBVPcXCdGTPrh0oc7jaoAvD9sKz2bKROT3gWmfjeu8bEv94LEU4/wx8+XoV6hT64c5nIO4WfdbJF/TmCwileK97f/DSbCARdHyKv4Dvr
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 14:06:48.5136
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e61ee321-230b-457d-c802-08de75404865
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EB.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5554
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71999-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,arm.com:email,arm.com:dkim,e129823.arm.com:mid];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[arm.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 7F1791A78F5
X-Rspamd-Action: no action

Hi Marc,

> On Wed, 25 Feb 2026 18:27:07 +0000,
> Yeoreum Yun <yeoreum.yun@arm.com> wrote:
> >
> > Use the CASLT instruction to swap the guest descriptor when FEAT_LSUI
> > is enabled, avoiding the need to clear the PAN bit.
> >
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  arch/arm64/include/asm/cpucaps.h |  2 ++
> >  arch/arm64/include/asm/futex.h   | 17 +----------------
> >  arch/arm64/include/asm/lsui.h    | 27 +++++++++++++++++++++++++++
> >  arch/arm64/kvm/at.c              | 30 +++++++++++++++++++++++++++++-
> >  4 files changed, 59 insertions(+), 17 deletions(-)
> >  create mode 100644 arch/arm64/include/asm/lsui.h
> >
> > diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> > index 177c691914f8..6e3da333442e 100644
> > --- a/arch/arm64/include/asm/cpucaps.h
> > +++ b/arch/arm64/include/asm/cpucaps.h
> > @@ -71,6 +71,8 @@ cpucap_is_possible(const unsigned int cap)
> >  		return true;
> >  	case ARM64_HAS_PMUV3:
> >  		return IS_ENABLED(CONFIG_HW_PERF_EVENTS);
> > +	case ARM64_HAS_LSUI:
> > +		return IS_ENABLED(CONFIG_ARM64_LSUI);
> >  	}
> >
> >  	return true;
>
> It would make more sense to move this hunk to the first patch, where
> you deal with features and capabilities, instead of having this in a
> random KVM-specific patch.

Okay. But as Suzuki mention, I think it seems to be redundant.
I'll remove it.

>
> > diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> > index b579e9d0964d..6779c4ad927f 100644
> > --- a/arch/arm64/include/asm/futex.h
> > +++ b/arch/arm64/include/asm/futex.h
> > @@ -7,11 +7,9 @@
> >
> >  #include <linux/futex.h>
> >  #include <linux/uaccess.h>
> > -#include <linux/stringify.h>
> >
> > -#include <asm/alternative.h>
> > -#include <asm/alternative-macros.h>
> >  #include <asm/errno.h>
> > +#include <asm/lsui.h>
> >
> >  #define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
> >
> > @@ -91,8 +89,6 @@ __llsc_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> >
> >  #ifdef CONFIG_ARM64_LSUI
> >
> > -#define __LSUI_PREAMBLE	".arch_extension lsui\n"
> > -
> >  #define LSUI_FUTEX_ATOMIC_OP(op, asm_op)				\
> >  static __always_inline int						\
> >  __lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> > @@ -235,17 +231,6 @@ __lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> >  {
> >  	return __lsui_cmpxchg32(uaddr, oldval, newval, oval);
> >  }
> > -
> > -#define __lsui_llsc_body(op, ...)					\
> > -({									\
> > -	alternative_has_cap_unlikely(ARM64_HAS_LSUI) ?			\
> > -		__lsui_##op(__VA_ARGS__) : __llsc_##op(__VA_ARGS__);	\
> > -})
> > -
> > -#else	/* CONFIG_ARM64_LSUI */
> > -
> > -#define __lsui_llsc_body(op, ...)	__llsc_##op(__VA_ARGS__)
> > -
> >  #endif	/* CONFIG_ARM64_LSUI */
> >
> >
> > diff --git a/arch/arm64/include/asm/lsui.h b/arch/arm64/include/asm/lsui.h
> > new file mode 100644
> > index 000000000000..8f0d81953eb6
> > --- /dev/null
> > +++ b/arch/arm64/include/asm/lsui.h
> > @@ -0,0 +1,27 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef __ASM_LSUI_H
> > +#define __ASM_LSUI_H
> > +
> > +#include <linux/compiler_types.h>
> > +#include <linux/stringify.h>
> > +#include <asm/alternative.h>
> > +#include <asm/alternative-macros.h>
> > +#include <asm/cpucaps.h>
> > +
> > +#define __LSUI_PREAMBLE	".arch_extension lsui\n"
> > +
> > +#ifdef CONFIG_ARM64_LSUI
> > +
> > +#define __lsui_llsc_body(op, ...)					\
> > +({									\
> > +	alternative_has_cap_unlikely(ARM64_HAS_LSUI) ?			\
> > +		__lsui_##op(__VA_ARGS__) : __llsc_##op(__VA_ARGS__);	\
> > +})
> > +
> > +#else	/* CONFIG_ARM64_LSUI */
> > +
> > +#define __lsui_llsc_body(op, ...)	__llsc_##op(__VA_ARGS__)
> > +
> > +#endif	/* CONFIG_ARM64_LSUI */
> > +
> > +#endif	/* __ASM_LSUI_H */
>
> Similarly, fold this into the patch that introduces FEAT_LSUI support
> for futexes (#5) so that the code is in its final position from the
> beginning. This will avoid churn that makes the patches pointlessly
> hard to follow, since this change is unrelated to KVM.

Okay. I'll fold it into #5.

>
> > diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> > index 885bd5bb2f41..fd3c5749e853 100644
> > --- a/arch/arm64/kvm/at.c
> > +++ b/arch/arm64/kvm/at.c
> > @@ -9,6 +9,7 @@
> >  #include <asm/esr.h>
> >  #include <asm/kvm_hyp.h>
> >  #include <asm/kvm_mmu.h>
> > +#include <asm/lsui.h>
> >
> >  static void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool s1ptw)
> >  {
> > @@ -1704,6 +1705,31 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
> >  	}
> >  }
> >
> > +static int __lsui_swap_desc(u64 __user *ptep, u64 old, u64 new)
> > +{
> > +	u64 tmp = old;
> > +	int ret = 0;
> > +
> > +	uaccess_ttbr0_enable();
>
> Why do we need this? If FEAT_LSUI is present, than FEAT_PAN is also
> present. And since PAN support not a compilation option anymore, we
> should be able to rely on PAN being enabled.
>
> Or am I missing something? If so, please document why we require it.

That was my origin thought but there was relevant discussion about this:
  - https://lore.kernel.org/all/aW5dzb0ldp8u8Rdm@willie-the-truck/
  - https://lore.kernel.org/all/aYtZfpWjRJ1r23nw@arm.com/

In summary, I couldn't make that assumption --
PAN always presents when LSUI presents for :

   - CPU bugs happen all the time
   - Virtualisation and idreg overrides mean illegal feature combinations
    can show up

So, uaccess_ttbr0_enable() is for when SW_PAN is enabled.

I'll make a comment for this.

[...]

Thanks!

--
Sincerely,
Yeoreum Yun

