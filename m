Return-Path: <kvm+bounces-71981-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ONocIYVToGlLiQQAu9opvQ
	(envelope-from <kvm+bounces-71981-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:07:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DAADB1A7372
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:07:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8BCD3323408D
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:59:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADB00394487;
	Thu, 26 Feb 2026 13:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DKlquQEE";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DKlquQEE"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013062.outbound.protection.outlook.com [52.101.83.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F69427EFE3;
	Thu, 26 Feb 2026 13:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.62
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114102; cv=fail; b=MvY2CC8swS1pqYa/etmgCBxqlPRNEGuzXtbHeOHpwzI6lIPCa2m2gGiYiURTDSBddf1ce3yMWMj6z5qQR9+kBqG/AKxBsotd8gDHkUJ3txRUJDM62u1QX7qkW1rK5r+9GxJhml4dj9IbtXx/3rVbD4HuFpMPNOXuzOmsD/IWzRI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114102; c=relaxed/simple;
	bh=dOz124qkT81iGlkkpaCGaQZe++IC1Lb2Tqd6rikPgns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ve/Co48X0QSfyIRYAxfQl62VmtcT+wmW7E9nnv/lIwT16+ob/2i0MwP6l9B/OuoawXuL9Oqgx0TKnxBwbYRS7fENeUV2wqh1ESSUUhG7eG7S2PmfCKTaKD3saYXFmPoXc7pBU91lOO5XF9rgkLCN7o1KZpCbB+wH44D0V9sJtMk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DKlquQEE; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DKlquQEE; arc=fail smtp.client-ip=52.101.83.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=A2Mco6JU1P4tY06KFf0x/UPQlBQDmE8k3UHHQW9pSoXq81tMFIbxMB8bTN9wS+HhsPKGUS7j87bNJzU08878KybHY6SbcN2LGfUioG06FWtyURqcpiVrt+tk6CsMx8czyikg+LdPQoOm8a77LgiMPLyOjDHoM6MMHNWUFtOM48s9mtoq+GwQK9porY4Ek7I07/yyMgvuV7jvAg2ttFoPdnpKs6sOhTLHfaMSjQzUPg5mrzTBukoAlfIA+MSKK+78Qn8ctf3Lk5tbrC378GbTt++nLeCKQ+DOdIyyUDZ9m8/rJahiKPzWD78yfLR++NiuuHz7G+Dte25bIm9ut4hSwQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDWOFxzdREWKnUMCI6CQ45R8fG30bqGpAobXOl9tOck=;
 b=TWgjxJ3xzwr7B3hrR4tPYig7qUPuxETKb/uRCKyEIH2we3/xW48GdmstVcYVkD4MtaRpd/Xfwrahp2Eg/VnNQniVbK2hQGUoHpByk9u2VwswHG3V78W1xg1KRqn9ZW63uQcKLnjL01Du4Js0MQE3595DfiGWQORgekYNSx/oq3J+NhUkBkms2+bIepjAIssW2YEA0sXAg9qQtfr/pWqw4+ylaz5PRNUXJYZ+9UCER3RpzcOwP+767uK37YCVAK7c75XAPgBgUewbcfxFzZENbYWpvE35yBbg+NjQ4wsRrom+gn0s+7lj1v0MrYnbFZqZrNLHxYahoLCwmQ1w41yrfQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDWOFxzdREWKnUMCI6CQ45R8fG30bqGpAobXOl9tOck=;
 b=DKlquQEE0hPdkFxwbhmT54WA/6iFXnWTEKwiHPAjwcYccXT9kstHnaFT27qVUzr2z1ccrCRRAh4yxtjZdm54CpjVp3i2Zx3nGUHxt/hpzA7Dn4WPbfOFwRAaGZYAecVg1cql6aZr6jDsZam279bq7pfskH+C4Jhq0HcSKqz85ek=
Received: from AS4P195CA0010.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:5e2::20)
 by FRZPR08MB11164.eurprd08.prod.outlook.com (2603:10a6:d10:13c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Thu, 26 Feb
 2026 13:54:55 +0000
Received: from AMS1EPF00000048.eurprd04.prod.outlook.com
 (2603:10a6:20b:5e2:cafe::76) by AS4P195CA0010.outlook.office365.com
 (2603:10a6:20b:5e2::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 13:54:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000048.mail.protection.outlook.com (10.167.16.132) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 13:54:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LmTZzVLKxfwMP+KltB7fGIjiiJnZht3/QvHAn90MkBFe+kLXalgn4WkbA35V/sZ0nDG68OHCdbTGxt1D8RAMPfcbxhxSQ/UAde4hnTaAkTaZVv5+WM6zR1uxWMAhKhbz8NsheWnHEz+LvxNxyeOVnXZOjYOZyCjgeS2TVdgm3ugg4W2kGP/WxaWGSHcdzl0u5r8aYsJpXnaDLPEW1gkJKDJDGHbL/oJiNKjIM8UASE+n8JkJoTkd9UhnR/8qrjiLr8HJ5wq9hB9BgNCMQwGmp/p15N1IfD0IXGTiyFUpge6P3QxE2+LX6+Pf/EaxCEXcyoOWeU232IpGszgAwoupSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDWOFxzdREWKnUMCI6CQ45R8fG30bqGpAobXOl9tOck=;
 b=iEUcZWHErL8CPn2ZIGf/r+HOXkYE7U21yT9I1ensR6raY2S/viKwKnqzVRERGfq/vE2Y9QM4/owWz0pWmPNz5Gn45PgFaHNoFK/FLtywimPg4Uj/R25AWFlcLaOwSQV+V+ZJCHsbxl3mdTwmBWg4SxalpzCcD9BpbXF+Px6F1bcciAzcv5JPO6SaOb7yGE0cHQlvtHXrHrnitjbOG9Liz22+rcojTX/+QZcDaMceSeyYSB9gbyGlux2bcsgGiiw+raRc0/06yYxO/SIm2NGyyPfPObccoY0RzO45UDYUfqmVokpRM77TpHk+fq3066Ry4r/do6gDZvulTq00BQRzqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDWOFxzdREWKnUMCI6CQ45R8fG30bqGpAobXOl9tOck=;
 b=DKlquQEE0hPdkFxwbhmT54WA/6iFXnWTEKwiHPAjwcYccXT9kstHnaFT27qVUzr2z1ccrCRRAh4yxtjZdm54CpjVp3i2Zx3nGUHxt/hpzA7Dn4WPbfOFwRAaGZYAecVg1cql6aZr6jDsZam279bq7pfskH+C4Jhq0HcSKqz85ek=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB9PR08MB11312.eurprd08.prod.outlook.com
 (2603:10a6:10:608::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 13:53:52 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9654.014; Thu, 26 Feb 2026
 13:53:52 +0000
Date: Thu, 26 Feb 2026 13:53:49 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, catalin.marinas@arm.com,
	will@kernel.org, maz@kernel.org, oupton@kernel.org,
	miko.lenczewski@arm.com, kevin.brodsky@arm.com, broonie@kernel.org,
	ardb@kernel.org, lpieralisi@kernel.org, joey.gouly@arm.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v14 7/8] KVM: arm64: use CASLT instruction for swapping
 guest descriptor
Message-ID: <aaBQbXnwKkAbIcAt@e129823.arm.com>
References: <20260225182708.3225211-1-yeoreum.yun@arm.com>
 <20260225182708.3225211-8-yeoreum.yun@arm.com>
 <afa3974d-0dc1-4472-ad3d-dbfa078bc9ed@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afa3974d-0dc1-4472-ad3d-dbfa078bc9ed@arm.com>
X-ClientProxiedBy: LO4P123CA0518.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::11) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB9PR08MB11312:EE_|AMS1EPF00000048:EE_|FRZPR08MB11164:EE_
X-MS-Office365-Filtering-Correlation-Id: fda4cc92-46f9-4297-001d-08de753e9f16
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 Y+PeB728jX86C7E68EGpuUrcHhWdT4Vj7LYj2Ltn88U0IxxCUZ0fUMkz7tyL9CumXLIENDK+LWmNyHXbDzN6S/mbxMehWveR5iUxtAEgTm5opsgglUztpZ2kR4KXD388qUFtk4sEZumQMl+B2RxIgDurftyR5RJHGU/HDUAaNK+P+lHEUZGh2sJ4aEcV91vdLZ2VQIj0WQiWUraOF02RxCPbFb0YiK8V56DUFaUzol4zG+UDk/PLM2SgnsSnsDofCNe1UAALB1H+EP1dt5KHsIxnvNrlGgnNIhKyJlaJsjiUKR7yafUIYZwLjgaNE0JlsPGoYa8lj96D0mkQjDA9J6cbf/o5j/uawjbCURfC6fEvEnpSOh8OeUmO/B3QlZrMgmGQGLGtoot7b4fRV/+qfgZmjR3VgXBIfcM0nF9OCzFwHcj2uAjSXYe4JaUFEj2NtooQOwmkfmsL8B9+aoBhrc7A61m3eN+8Q46ug+8kyURAjuYgeJ6Dfz9eYJveZvXzBOd7NHzXmedH7VQWTmxs1oS/M2ELEDXKfIJA4Y7O9LzfF1CyTTktPNmjoJmETbvCq9VRgC7Lez5WGrGhxK3F2bMgl4s5FbremXrU4yDGFXszb7pn9QCAtjQdyBzJDSmDczuRm4XxrjmFJzBlA70q71ZS++QSRdFCfusgmRVBBafHQUY1GbitAXSjb8dxg0b2InTvUtYmYNIo6nACasOGkOmq6qPfSX2kbv6hmY02YnE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11312
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000048.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	27385ae1-eded-4810-fb3f-08de753e79cc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|35042699022|7416014|1800799024|14060799003|376014;
X-Microsoft-Antispam-Message-Info:
	hmbNZbk0r8NL61u2Dw6CX9j9Wb16qQYSqcWafhT6egTfTPd8tKj1NF5QmDFMNLbuyuicTIZ3/l0nyPnIMEvUki7bEw2jQt7g0r420DBInVhNW0pztPDynz25u2lRnNTD6f1gKPP3puIO2anh8hrpmxPpNTORk3O7+Z9s/ZuIMr1wgvTi5z1Lar811APFmugJEzA2iFmkopkWtHMWsXzosvWBE2oOKC5xr+pr4E4A+bzfRQ9+IYEu/9lSSxNmK5ydM7e1UzgTUonXSRBVv5lXz21hy4lBJKkglw/xcrclf0iQWcuJJXFg05R3msMejJb412KFSpO4312NdIdmP73fXy8tG1CvATWcVae94O0Ldz+MRkK2THuLHIZLfDq10KmIV6onH23y73ujKXEdqxDcgWoF+Lw0QBqYr/g43fGJ9aVCi+dd170imiNr7h2fJR1uvI0FVU3DF4+6lkIVaGpQFWDMPTJ0b1+zWHyALlP/J9T/3VKOCw+zp4KJo6HxIXEa/6a78sRX4W3RCRpdbNdSbgTsmAPso8gFSYP7fBoXiSqMd8i8vI391wsHWe2LB1g2Eogxz+GyN6L/pz9XYw3Hbkp14I28y7EZpTvb8cBcSEy8jRDSX1gi2tBDmYCXmHfPSrmhFHU07+vgrL4pi4KHz+0EqLSZnMkn+8yLZeMNodFAcAaA9jKtZEZNdA8wmaB4TqY8v4TbtGcQQRGNn2iBe06qj/aUV37kmlnsb+BHXZJ0O1N00UYXmU99lx1V2LlueAhHhJWMOp/1KXQyHm+jSrdYH1QRn2wF4mbXvY6U8tOoiyOpPUIxYKk57rz/bOstV5MKOgnA1Sebyr2E5eaVlg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(35042699022)(7416014)(1800799024)(14060799003)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RSFWlrA62hu2rAClBtlleX68RwpTpnWMUAyspSqU/5g+211TKMjI50Xcl7PtA0ESssY3LCrhxZKMgyPLnyBePZqr9YJed4H44R0fsZxgWvx1/rm9bvvXDAZx6jueUH/FxohmAvTUuAg2iGONOF3k0veDem0SawBvU/uNgKPmkD0l5T2QVkMB+53uR8Xd8zdkhH6/hvR8ZzOxN20RMOkW8OmXWR/qcMjuRwCKqOM/YJ1ByWrn9/eZT7E9+1WtNqXTxoR0CFYcvYE/U1en5M0pe+3fYsCCc8EgjFsM/IJEHzKWEhyvqqESk4vmG9XrudXdITpTds8hmSy8dq3sClC0C7ngn5WXlPS8w7A2a2qO9FWmAyWoUVXS3Vvf4t5zj381L4OpVWT6Ws0QhFTQSn04/aP0MPJT4jdnDezQ+9ZQA7u547y/FMovD8H4Vi7TxHpj
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 13:54:54.9678
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fda4cc92-46f9-4297-001d-08de753e9f16
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000048.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRZPR08MB11164
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71981-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,e129823.arm.com:mid,arm.com:email,arm.com:dkim];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: DAADB1A7372
X-Rspamd-Action: no action

Hi Suzuki,

> On 25/02/2026 18:27, Yeoreum Yun wrote:
> > Use the CASLT instruction to swap the guest descriptor when FEAT_LSUI
> > is enabled, avoiding the need to clear the PAN bit.
> >
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >   arch/arm64/include/asm/cpucaps.h |  2 ++
> >   arch/arm64/include/asm/futex.h   | 17 +----------------
> >   arch/arm64/include/asm/lsui.h    | 27 +++++++++++++++++++++++++++
> >   arch/arm64/kvm/at.c              | 30 +++++++++++++++++++++++++++++-
> >   4 files changed, 59 insertions(+), 17 deletions(-)
> >   create mode 100644 arch/arm64/include/asm/lsui.h
> >
> > diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> > index 177c691914f8..6e3da333442e 100644
> > --- a/arch/arm64/include/asm/cpucaps.h
> > +++ b/arch/arm64/include/asm/cpucaps.h
> > @@ -71,6 +71,8 @@ cpucap_is_possible(const unsigned int cap)
> >   		return true;
> >   	case ARM64_HAS_PMUV3:
> >   		return IS_ENABLED(CONFIG_HW_PERF_EVENTS);
> > +	case ARM64_HAS_LSUI:
> > +		return IS_ENABLED(CONFIG_ARM64_LSUI);
> >   	}
> >   	return true;
> > diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> > index b579e9d0964d..6779c4ad927f 100644
> > --- a/arch/arm64/include/asm/futex.h
> > +++ b/arch/arm64/include/asm/futex.h
> > @@ -7,11 +7,9 @@
> >   #include <linux/futex.h>
> >   #include <linux/uaccess.h>
> > -#include <linux/stringify.h>
> > -#include <asm/alternative.h>
> > -#include <asm/alternative-macros.h>
> >   #include <asm/errno.h>
> > +#include <asm/lsui.h>
> >   #define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
> > @@ -91,8 +89,6 @@ __llsc_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> >   #ifdef CONFIG_ARM64_LSUI
> > -#define __LSUI_PREAMBLE	".arch_extension lsui\n"
> > -
> >   #define LSUI_FUTEX_ATOMIC_OP(op, asm_op)				\
> >   static __always_inline int						\
> >   __lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> > @@ -235,17 +231,6 @@ __lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> >   {
> >   	return __lsui_cmpxchg32(uaddr, oldval, newval, oval);
> >   }
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
> >   #endif	/* CONFIG_ARM64_LSUI */
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
> > diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> > index 885bd5bb2f41..fd3c5749e853 100644
> > --- a/arch/arm64/kvm/at.c
> > +++ b/arch/arm64/kvm/at.c
> > @@ -9,6 +9,7 @@
> >   #include <asm/esr.h>
> >   #include <asm/kvm_hyp.h>
> >   #include <asm/kvm_mmu.h>
> > +#include <asm/lsui.h>
> >   static void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool s1ptw)
> >   {
> > @@ -1704,6 +1705,31 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
> >   	}
> >   }
> > +static int __lsui_swap_desc(u64 __user *ptep, u64 old, u64 new)
> > +{
> > +	u64 tmp = old;
> > +	int ret = 0;
> > +
> > +	uaccess_ttbr0_enable();
> > +
> > +	asm volatile(__LSUI_PREAMBLE
> > +		     "1: caslt	%[old], %[new], %[addr]\n"
> > +		     "2:\n"
> > +		     _ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w[ret])
> > +		     : [old] "+r" (old), [addr] "+Q" (*ptep), [ret] "+r" (ret)
> > +		     : [new] "r" (new)
> > +		     : "memory");
> > +
> > +	uaccess_ttbr0_disable();
> > +
> > +	if (ret)
> > +		return ret;
> > +	if (tmp != old)
> > +		return -EAGAIN;
> > +
> > +	return ret;
> > +}
> > +
> >   static int __lse_swap_desc(u64 __user *ptep, u64 old, u64 new)
> >   {
> >   	u64 tmp = old;
> > @@ -1779,7 +1805,9 @@ int __kvm_at_swap_desc(struct kvm *kvm, gpa_t ipa, u64 old, u64 new)
> >   		return -EPERM;
> >   	ptep = (u64 __user *)hva + offset;
> > -	if (cpus_have_final_cap(ARM64_HAS_LSE_ATOMICS))
> > +	if (cpucap_is_possible(ARM64_HAS_LSUI) && cpus_have_final_cap(ARM64_HAS_LSUI))
>
> minor nit:
>
> You don't need the cpucap_is_possible() as it is already checked via
> cpus_have_final_cap()->alternative_has_cap_unlikely()

Right. It seems a little bit of redundant.
I'll remove it.

Thanks!

--
Sincerely,
Yeoreum Yun

