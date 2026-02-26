Return-Path: <kvm+bounces-71960-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sAlQKJcuoGkXgAQAu9opvQ
	(envelope-from <kvm+bounces-71960-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 12:29:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 466871A50AC
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 12:29:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4417D3036AA1
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 11:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FD1836BCD3;
	Thu, 26 Feb 2026 11:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JRXgCl3n";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JRXgCl3n"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010036.outbound.protection.outlook.com [52.101.84.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CEF3164BA;
	Thu, 26 Feb 2026 11:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772105363; cv=fail; b=XpBIB93Ozp7LaHrDyaLhVBwzy1AAKWbp98YHvsyK2Yi7pOmUgrxACy1+EXqA1yIyPfr4H4teSDwi2FHHXtRrIzL9zSh2z/fAW63FXHAJLUYgqyl6uKsr3yB8Y2Wsy5hOYhtuQp15cUEgtKwvhja0Wb72qJq8R5t7mNPFIr6y3Hc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772105363; c=relaxed/simple;
	bh=hRtWoY/ImrVbfa284kfizurRuWVy4SNf46hLu9yWuBg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZwEiWhJqoU0rrkPg9V6L434+K4YzjF1rab2qgMyBZ1HUC5446z70F88MJ/AoTL6Amxv4v1lxx9g5M+/8d4jsNJUbpOZfdhF4sYzcUBaQzQQYjVMY3D0uglrdpledXM6aPALRbS1RRqVbaZSqkwMnfG2Vqv2CGweYaMRRGV7owaU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JRXgCl3n; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JRXgCl3n; arc=fail smtp.client-ip=52.101.84.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=weG0WnBXC4mSB3Gf+x9oHM563hAXqqijvEMMX0jZkZRBsNiHcnQDNAFGmw6wJEZNLSr7xj7Gov3ipkLd625DVhCRaypOm/TAGHJFDmvpp2FTRupP4JsNfAy5SCJ+TowH+E8KMimducLg8lbiwKdIcGu6U4N9q0ZS2KYbiiXlBrBD57SRKa/qPc6CV3IxQA0Pe8KLUr5gjP31ZKjW2P1FqAy2OdslugTVb/brkB9hPTzk6Ajgf+8lT47veTu7XTYNOOe9GjR8gUmPPrG1MNG/wajPBN2AwGBjijuZxyQIezGv6w8F9xSSnAnYtpBRAyLMV5Cx06yIBvOb/Z4G+YoElw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zK6bTydDlx1NfRJe1RZiiChrI33aJM4oo9iaCZZEjRQ=;
 b=LXwGdsCJR5E1LcidEVOqOieFpJP+Ic6mZwaA670udPgktutKc6FCKxO9U1Dv6feKPEYCbqr1ytKNHLk529vI/lQntf9ru56vFSW1ge5YdBffLfbSiorzHG2jFyOCbNf0kyQ6i2zAeLi2EtvrUdlTygudjdsfMhtNIoUEmv3TD23oHF/6p6LwRKGYiwgFaHDcwnKWnz9K2P75AoAjjUnpSzJKCCswvwhM3R3OKvMbxyaxWBkkjsc5vYSNLPYF4q7egm596Q54CAEyySbzUi/MkoO0X3p8AwyCvxzA0eKwsFCvPQF4rjD1akWhZpS1Q1TYkVzjRzuIo4YYIEewY2NMgA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zK6bTydDlx1NfRJe1RZiiChrI33aJM4oo9iaCZZEjRQ=;
 b=JRXgCl3nmibk9GFbBk7GMRHioKta0uyAYWBborJ2Otz9zFY6pkJJy7S5t92hhYWOxX/mMHRDOBRVPQPKGxmo//GH1RtslKd/LzaPCV5qRE/48n7YkirHS1uOdL7hiZJ9OpfQrerNuIEmg8973js7v15BFWp6ZCr+aB0epNzzSUw=
Received: from DUZPR01CA0051.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:469::15) by GV1PR08MB11179.eurprd08.prod.outlook.com
 (2603:10a6:150:1ed::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 11:29:11 +0000
Received: from DB5PEPF00014B8B.eurprd02.prod.outlook.com
 (2603:10a6:10:469:cafe::b4) by DUZPR01CA0051.outlook.office365.com
 (2603:10a6:10:469::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 11:29:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8B.mail.protection.outlook.com (10.167.8.199) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 11:29:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dlUyB4z5z9ifrOLcEqt1wCHrtzASp3MvBF9ZwcdL+YeTRrnUSjTPsHlPh5huIjbm2s5jMo2smSWHRFGWXKhz1PIEIJLjVDEff1ly3ldNJkuHvB8pU7+Ih10BE/dmjIGVtj8IRnLYNCpI+8jUy+dlRo+ofnhFn6/OyM1Wvknz1x3kstoHTxQtBBiLgtN/XQqyc71J7yFNNo7W5waJ6CtdYR0wzmvYsFZOiAMOBNLiTKpyjVD8Et5VP347CHDiCI0ClTX9cdrTWxrtorCgDR1bUk9T52NWlEylGMPHxG0YtjuAREcKHhGYmbs6DIjO6kOLJCN1EuR/0pcIwH2lM2zhYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zK6bTydDlx1NfRJe1RZiiChrI33aJM4oo9iaCZZEjRQ=;
 b=oaq707ogRsyhfN5yKV7rdT+CM+s2H7x8e+hvIRRn40F8y42EnzeC59vrYYPbl5R3UwnVO48nFo4LYuX64LtwYB1OHegCY5oCI3ROlGcwbWaMkqU4z66MfQJTS5dSVZfChJHZzRr4zTBxiYBasfdEt4MjdkDtzYFT56wR6FQW/gBpGlZzaFVstqCYtKZD9el0M0Eh8laLN14qoJMdrBTkjzsZHWtsPECk6jRAmDDKz0aHyCqY1T1HVrRS0/SMhXTlQdML0F1JZ4MiFOgjg96L8iKj05pK+8204Piruwb1iCexwsAtLTYdmehTpt666oth2v2sAK8px/7MUOTRSe+WRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zK6bTydDlx1NfRJe1RZiiChrI33aJM4oo9iaCZZEjRQ=;
 b=JRXgCl3nmibk9GFbBk7GMRHioKta0uyAYWBborJ2Otz9zFY6pkJJy7S5t92hhYWOxX/mMHRDOBRVPQPKGxmo//GH1RtslKd/LzaPCV5qRE/48n7YkirHS1uOdL7hiZJ9OpfQrerNuIEmg8973js7v15BFWp6ZCr+aB0epNzzSUw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by AS8PR08MB7718.eurprd08.prod.outlook.com (2603:10a6:20b:50a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Thu, 26 Feb
 2026 11:28:06 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%6]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 11:28:06 +0000
Message-ID: <afa3974d-0dc1-4472-ad3d-dbfa078bc9ed@arm.com>
Date: Thu, 26 Feb 2026 11:28:05 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 7/8] KVM: arm64: use CASLT instruction for swapping
 guest descriptor
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
 oupton@kernel.org, miko.lenczewski@arm.com, kevin.brodsky@arm.com,
 broonie@kernel.org, ardb@kernel.org, lpieralisi@kernel.org,
 joey.gouly@arm.com, yuzenghui@huawei.com
References: <20260225182708.3225211-1-yeoreum.yun@arm.com>
 <20260225182708.3225211-8-yeoreum.yun@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260225182708.3225211-8-yeoreum.yun@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0067.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::31) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|AS8PR08MB7718:EE_|DB5PEPF00014B8B:EE_|GV1PR08MB11179:EE_
X-MS-Office365-Filtering-Correlation-Id: eef9d5ec-733e-4347-7ca0-08de752a430a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info-Original:
 W388bd/kiGby5Nz7eD/NSmz8piCUTlN7AGaj97ewfNKtKracGJjoNFW0okN8ademND6R1lBQVZ+dIEXM5ihk0Le6laMwjijnejTb8s5bGJ36GBxYJZEWP9lHhCrYURfBgpZkC9Sns4p9RQJKEMOoUeEZMGZ9NJ4SLivBwMfuSCB+btmNE7d/U5EXUenRNBIS2i6Cl1T/mJZQ5Z5tlnHBo6W4wwk1kZl/9IXDZdrUZ6VQ13/IfXmHvfw25vTUCV4YXpkJaeTG/SrqXhvCMwtXiacRl19mV/wIj/ynYB2ERfHXN66m46aJsmOvbdO66Ato9ASSgPiH+L/IxrtKOJBKR3VagLutv63dQXMUHcjwAsR3AAg+jMHFM5PCgOupoZhbVfo8MO+lUBAp005YIRK60aDdUHXvIry51WeWWw4iTbbioXa9OD1OOZQTo+ps1plHTZOQvkcq+rlrg6WNxBrn1IqATLH17v7XMjgn0DDx7lbugZ3Ol9pB2MSwUqJwhzC6uNnLlOgaEUWTQERh7ONtdFLT1fIlDVA6u5Zo+YXphqCtiOyEv5pIfBm/EOLvbbv+kpQicOQHLEas5DExf8aA+fa14G9NJSdpO1djno1R6H67jdP1MZaWTJFms46NcFneIPhzIz73FG6WGwhx/idC9BS3713C5vuSHichUWTAYGxPV6pbaQWXjy+3BjmHgVK1D+53J2x05D3GWYuon2zwkaR75uXBP+vkwsPUzTjbEEs=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7718
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	25beff2a-8812-4e3f-2347-08de752a1cb4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|82310400026|376014|7416014|14060799003;
X-Microsoft-Antispam-Message-Info:
	M0UDC1OaoeLXJSu/q5X+0STvUW07ejCg/iWNgiGCD915NRZyDvZ16tMd+JFE/lCpW6pOlFr5D37YUQtKOTF0ndz9keJLHctXWKdnsTeKT9b+sqltJKU0TygVBKhUpiWzkcHJWrHF+MvWH+nlfAhCvn0LF3QRXpspgVITLUjfH7qekDHb7a0ZSWrTC2Nw/aGFrQEESh1If+gdfQN59UwrF0AmTcuQpwHeYodOh3abCHV04Q1L8TsmxryRY173YzjKiDk4MGcmqpplHqnjB1/gqPwVZEHC2TJd8JzB8RZiZvso6AnjPGZigT0erVr86kwDHqrgAxDOHzjlAeZ2tOWY+YQQ24jB/VA7I/hz3CnB7sO1tgAd2WlIEN5Yxd8GuPoZQ50s5VQpfnE+9P3sSI/2gwn0OhP1IwLxWibCOsZRS1r8l7T7YnSV8f6muAKqTAdpI6TyTSa4B+CsVwD8lNSeqHpY1c/wNPCMqgvEl4UcU5tcC2LEZakqkhNkj6SV/fD8fRDJGnihVLsPDLJxdDw8gO6bdxb8u4qQhRiBRCtpQR7+2sA7qDV/JCByf0+uharFCDEfwAabVFoqhmpc++tiaMn0fw6h33Soi5NVZhQ16eik4McwhH3D5mPClPBEZYTDFwEzFC9h1yNLIj/eI01TEUkltV+5rkXOKzEB0ymhyKsiTdHsO5W1pZwWs/RL/+6sfwiIJ5sELgizDjS5Ap4bZ/8MAQJhfpBCca7t4eRkvYaDrBpKb/X+nclwpvWiwKCe8IHVVO9hqimcAQxvhiZaVK1IwzV0w6JxVuEke0GGCsVP16HKutAaoAqXnZYa21Drx04SLIEDAKXhZLtaoRpRAw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(82310400026)(376014)(7416014)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3MyOttvcPUpd8imegsG9aeRCMamdk9GwuXjJwSOXzDLAsQGQskuzEb6OxRSEL7N5Pe73rDYhaPppllmWuzs1PoZodHE82JRx4swgJCrHiJlzdnHliE5XRXbS7Y5XhSG/N2gNY4u+YpxRQcLDrxXAjFFaJKBaqe90Ep9BESc0T2aW/dnnW+e2dfSOWANaZgFMNL9xZCgp0iBMmf6tkAFJdx6w/C1vudDYE/qOUXNo41y3h8Nz2L0Z3/1QzrglrBSko5YlgnnOq1xy2tw48bq5AZOs19ueR5O5No3kWDuaeEG64qNB+StpS2EV3jBYBzLTJ4t9cFjqjpLPrBdsgokQfnwcLtnqOaSouQOYsE7nDK6shCP6TB50V8YvZdBPO4tEmTRLofh4BuC6UvsA59fDnhFrIh4ZbszqA2Fc4SZ7zIl/Ed6+hsB+4B7ghGE8A8PW
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 11:29:10.5951
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eef9d5ec-733e-4347-7ca0-08de752a430a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB11179
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71960-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:dkim,arm.com:email];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[arm.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[suzuki.poulose@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 466871A50AC
X-Rspamd-Action: no action

On 25/02/2026 18:27, Yeoreum Yun wrote:
> Use the CASLT instruction to swap the guest descriptor when FEAT_LSUI
> is enabled, avoiding the need to clear the PAN bit.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>   arch/arm64/include/asm/cpucaps.h |  2 ++
>   arch/arm64/include/asm/futex.h   | 17 +----------------
>   arch/arm64/include/asm/lsui.h    | 27 +++++++++++++++++++++++++++
>   arch/arm64/kvm/at.c              | 30 +++++++++++++++++++++++++++++-
>   4 files changed, 59 insertions(+), 17 deletions(-)
>   create mode 100644 arch/arm64/include/asm/lsui.h
> 
> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> index 177c691914f8..6e3da333442e 100644
> --- a/arch/arm64/include/asm/cpucaps.h
> +++ b/arch/arm64/include/asm/cpucaps.h
> @@ -71,6 +71,8 @@ cpucap_is_possible(const unsigned int cap)
>   		return true;
>   	case ARM64_HAS_PMUV3:
>   		return IS_ENABLED(CONFIG_HW_PERF_EVENTS);
> +	case ARM64_HAS_LSUI:
> +		return IS_ENABLED(CONFIG_ARM64_LSUI);
>   	}
>   
>   	return true;
> diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> index b579e9d0964d..6779c4ad927f 100644
> --- a/arch/arm64/include/asm/futex.h
> +++ b/arch/arm64/include/asm/futex.h
> @@ -7,11 +7,9 @@
>   
>   #include <linux/futex.h>
>   #include <linux/uaccess.h>
> -#include <linux/stringify.h>
>   
> -#include <asm/alternative.h>
> -#include <asm/alternative-macros.h>
>   #include <asm/errno.h>
> +#include <asm/lsui.h>
>   
>   #define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
>   
> @@ -91,8 +89,6 @@ __llsc_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
>   
>   #ifdef CONFIG_ARM64_LSUI
>   
> -#define __LSUI_PREAMBLE	".arch_extension lsui\n"
> -
>   #define LSUI_FUTEX_ATOMIC_OP(op, asm_op)				\
>   static __always_inline int						\
>   __lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> @@ -235,17 +231,6 @@ __lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
>   {
>   	return __lsui_cmpxchg32(uaddr, oldval, newval, oval);
>   }
> -
> -#define __lsui_llsc_body(op, ...)					\
> -({									\
> -	alternative_has_cap_unlikely(ARM64_HAS_LSUI) ?			\
> -		__lsui_##op(__VA_ARGS__) : __llsc_##op(__VA_ARGS__);	\
> -})
> -
> -#else	/* CONFIG_ARM64_LSUI */
> -
> -#define __lsui_llsc_body(op, ...)	__llsc_##op(__VA_ARGS__)
> -
>   #endif	/* CONFIG_ARM64_LSUI */
>   
>   
> diff --git a/arch/arm64/include/asm/lsui.h b/arch/arm64/include/asm/lsui.h
> new file mode 100644
> index 000000000000..8f0d81953eb6
> --- /dev/null
> +++ b/arch/arm64/include/asm/lsui.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ASM_LSUI_H
> +#define __ASM_LSUI_H
> +
> +#include <linux/compiler_types.h>
> +#include <linux/stringify.h>
> +#include <asm/alternative.h>
> +#include <asm/alternative-macros.h>
> +#include <asm/cpucaps.h>
> +
> +#define __LSUI_PREAMBLE	".arch_extension lsui\n"
> +
> +#ifdef CONFIG_ARM64_LSUI
> +
> +#define __lsui_llsc_body(op, ...)					\
> +({									\
> +	alternative_has_cap_unlikely(ARM64_HAS_LSUI) ?			\
> +		__lsui_##op(__VA_ARGS__) : __llsc_##op(__VA_ARGS__);	\
> +})
> +
> +#else	/* CONFIG_ARM64_LSUI */
> +
> +#define __lsui_llsc_body(op, ...)	__llsc_##op(__VA_ARGS__)
> +
> +#endif	/* CONFIG_ARM64_LSUI */
> +
> +#endif	/* __ASM_LSUI_H */
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 885bd5bb2f41..fd3c5749e853 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -9,6 +9,7 @@
>   #include <asm/esr.h>
>   #include <asm/kvm_hyp.h>
>   #include <asm/kvm_mmu.h>
> +#include <asm/lsui.h>
>   
>   static void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool s1ptw)
>   {
> @@ -1704,6 +1705,31 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
>   	}
>   }
>   
> +static int __lsui_swap_desc(u64 __user *ptep, u64 old, u64 new)
> +{
> +	u64 tmp = old;
> +	int ret = 0;
> +
> +	uaccess_ttbr0_enable();
> +
> +	asm volatile(__LSUI_PREAMBLE
> +		     "1: caslt	%[old], %[new], %[addr]\n"
> +		     "2:\n"
> +		     _ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w[ret])
> +		     : [old] "+r" (old), [addr] "+Q" (*ptep), [ret] "+r" (ret)
> +		     : [new] "r" (new)
> +		     : "memory");
> +
> +	uaccess_ttbr0_disable();
> +
> +	if (ret)
> +		return ret;
> +	if (tmp != old)
> +		return -EAGAIN;
> +
> +	return ret;
> +}
> +
>   static int __lse_swap_desc(u64 __user *ptep, u64 old, u64 new)
>   {
>   	u64 tmp = old;
> @@ -1779,7 +1805,9 @@ int __kvm_at_swap_desc(struct kvm *kvm, gpa_t ipa, u64 old, u64 new)
>   		return -EPERM;
>   
>   	ptep = (u64 __user *)hva + offset;
> -	if (cpus_have_final_cap(ARM64_HAS_LSE_ATOMICS))
> +	if (cpucap_is_possible(ARM64_HAS_LSUI) && cpus_have_final_cap(ARM64_HAS_LSUI))

minor nit:

You don't need the cpucap_is_possible() as it is already checked via 
cpus_have_final_cap()->alternative_has_cap_unlikely()

Suzuki


> +		r = __lsui_swap_desc(ptep, old, new);
> +	else if (cpus_have_final_cap(ARM64_HAS_LSE_ATOMICS))
>   		r = __lse_swap_desc(ptep, old, new);
>   	else
>   		r = __llsc_swap_desc(ptep, old, new);


