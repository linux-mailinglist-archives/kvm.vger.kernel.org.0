Return-Path: <kvm+bounces-70770-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aHipDNJki2kMUQAAu9opvQ
	(envelope-from <kvm+bounces-70770-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 18:03:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 44F5711D7F5
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 18:03:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6BCC9300D56C
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 17:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47D7B325702;
	Tue, 10 Feb 2026 17:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rYFyII4q";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rYFyII4q"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013030.outbound.protection.outlook.com [40.107.162.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3173F3112DC;
	Tue, 10 Feb 2026 17:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.30
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770742971; cv=fail; b=l42S0VH2VtMBEdJofBOmrsenlsXqzzZrH2cDlMQqYlVPS+XoDW+h0dIobZSVgymWZaSD1jJfcIzbGuhsmNvNvS6N0NvsYJoQgtJrK9l5oIqekVInC7UNUWQxk+ta8EcPzz1Tect1Y5RiMBdI14+Cqy4PWg60CQ4ajb1BsAhsOVE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770742971; c=relaxed/simple;
	bh=c/Q4xy2ywrLpoEcYPgy94DJM65c59kr5AmT8q7h95rs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rNsEx217jNIwII8AvJeZ5qjllBu3eVZGzt0wCsjb7mBSXnxnMCB8aSOT2RF+zPyNtc4C6e937gMFRaz9tqAgDIzvsE1e9gfNDDieqy91z1EOTDBwVgi2mzNRYOE6m+JW7NCZiuk5uATQZcVyqo3TEKsmVLCbA+8RcytDkWUUTfs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rYFyII4q; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rYFyII4q; arc=fail smtp.client-ip=40.107.162.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BQStxKwv5M+ZBC3dzJf3ySgKCp9cmPMzZx00IZo80cCQjO/LbBbUkwhpLLGyBPcQc4TYgfQxGTKl2PT9dclmDz9UhTkTb7qGqlHA3sq+YWJi466pmlQX9Rc15LcL0TvV89awJNNg5rg6SBDf3ilWZy4FLReJpZx5VaaZ+yAxXTDxYu4bP03bENcpxcsYLhVLHRmIMcEJl47dWe3YiOaKBWKvFWTAC4j78NYCEPAoue3Ou8hQccXSKxk2IERAvEa0x5+R3w9evZiR403KSQIGK/yn5YnSYTu6LvLb1Azu+eLTF2P7DspdDiy6PxZDvnc07/6jN9CMGA1NyRqQ2O00Fw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s+0wQf7IKMzdtNoC/P8KGz2Eq/UtyI856180ZfzVPRM=;
 b=Q+Gp9wbtkf9d2CIild2mCBjAk3ZCGB1ejIu8z2mrr7zEV4jqMLt6MZmRudiA9xIk/sjn/+8RSMT1MdVnERs90xww+bH7RnPd35TwdQHJe+lbjnlC6zAd2/6Jx+xIjEV3+D+PiSRhGVKYODkS7IjbEH3JU9sZd8s4jv4BGrKH483J5omiMAj98YdrA6qT922uDs1cZ+ClNDIiDd/tvrjGx3NJDI0roIwl6yAadOKIJbNDDQ2cMm+tdm4aE4786HvwchRywtkCrZslfVhNyTiLRhymSjTjZKZeQuL1wIvtLoiAA3/qfsuql0kFcLqxMRXP58kK/Nb1cC0j4Zxj2QXbJw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+0wQf7IKMzdtNoC/P8KGz2Eq/UtyI856180ZfzVPRM=;
 b=rYFyII4qEtvHd2IRsUsR3HAZBhGLCjJjzqbCBszjRLMt9TTxdte/yycig5kEz9XEPWRj+iA/5pVxu+uVtmifFN1gip/gcPDiJTP4Pfh9lqr/bka9Y6l6F4A4hqi+MPT/p/yvVt4iWFU5E+tkkTuSRpzhjALZ26zGZZMH0DZHU7Y=
Received: from AM9P250CA0020.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:21c::25)
 by GVXPR08MB10406.eurprd08.prod.outlook.com (2603:10a6:150:15a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Tue, 10 Feb
 2026 17:02:40 +0000
Received: from AM4PEPF00027A69.eurprd04.prod.outlook.com
 (2603:10a6:20b:21c:cafe::b3) by AM9P250CA0020.outlook.office365.com
 (2603:10a6:20b:21c::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.19 via Frontend Transport; Tue,
 10 Feb 2026 17:02:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A69.mail.protection.outlook.com (10.167.16.87) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.8
 via Frontend Transport; Tue, 10 Feb 2026 17:02:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CPqtCtjJYMYIw9CYfes7VmHYDyGG/0NS1gaDShqzPfiBc3BHNZ03FnGue/xx4ZAQ0csWUXqrKxrj8L+S49+2BPbJWAMnQL4DJpovKxfizeGFsdmo5E5Ve/mq8g/5+UblhXZl7b5uqHh3m7H6811ckRelpqK9towqg00JUt4xGZhUsVR0ICS/DD5vpvZE+p05A4uQVVlmlhvg0xLlgYXZiqZ+HBB0f+OM0mNYWWab5aviP5P18gC7gusMdp4vgnb7cemjmIMGjP2UcC656EqJGqnCUWGxWOThwxOdee5wOJIbvUpRbfAKhik7qG5LKlBMwE+Sm9ll8PYzrsvj8KXtcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s+0wQf7IKMzdtNoC/P8KGz2Eq/UtyI856180ZfzVPRM=;
 b=xGxsPQOjqx/jw1Xh9btCTE9qrxpmUWQtAII7I5GMZpmZJb43iPty/ePmzCC8D/Mt6svw/f41FZzPGIAxtfyYkQWYpBqw+SH7twS/0lphentFmSt6l3tCVy+Ijow4O5GnT7+L6Tyl6q98qwe7a7rrp7XMCUDochql2U2/kOVu7ANXqwFy3IpE1DV0x/CCfJ6UBE1+HW7zFDZmkKPK44Ae1oCxkLFX95lZGqfj6KRVliEA/n3HILDtJjN4d75btneFuORhs/1hO/ptpHoOLjFigkRmCofy4KXGiUqKCsAdVt1k+dY7BhKTc6AaTPBVUPWUQNzJsdvVHLugwcjR4863jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+0wQf7IKMzdtNoC/P8KGz2Eq/UtyI856180ZfzVPRM=;
 b=rYFyII4qEtvHd2IRsUsR3HAZBhGLCjJjzqbCBszjRLMt9TTxdte/yycig5kEz9XEPWRj+iA/5pVxu+uVtmifFN1gip/gcPDiJTP4Pfh9lqr/bka9Y6l6F4A4hqi+MPT/p/yvVt4iWFU5E+tkkTuSRpzhjALZ26zGZZMH0DZHU7Y=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AS8PR08MB6102.eurprd08.prod.outlook.com
 (2603:10a6:20b:23d::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.8; Tue, 10 Feb
 2026 17:01:37 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9564.016; Tue, 10 Feb 2026
 17:01:36 +0000
Date: Tue, 10 Feb 2026 17:01:33 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	broonie@kernel.org, oliver.upton@linux.dev, miko.lenczewski@arm.com,
	kevin.brodsky@arm.com, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, scott@os.amperecomputing.com,
	joey.gouly@arm.com, yuzenghui@huawei.com, pbonzini@redhat.com,
	shuah@kernel.org, mark.rutland@arm.com, arnd@arndb.de
Subject: Re: [PATCH v12 2/7] arm64: cpufeature: add FEAT_LSUI
Message-ID: <aYtkbezCx9vW8SHz@e129823.arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
 <20260121190622.2218669-3-yeoreum.yun@arm.com>
 <aYY2CyHWtplQ-fuS@arm.com>
 <aYouAv_EjICIN8oA@arm.com>
 <aYsAaaQgBaLbDSsW@e129823.arm.com>
 <aYtZfpWjRJ1r23nw@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYtZfpWjRJ1r23nw@arm.com>
X-ClientProxiedBy: LO4P265CA0251.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:350::19) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AS8PR08MB6102:EE_|AM4PEPF00027A69:EE_|GVXPR08MB10406:EE_
X-MS-Office365-Filtering-Correlation-Id: c72932e9-123b-498d-c4ad-08de68c6334f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?jmLc4lBV9GH5fnggUKDmlHSdhgezMTRqabioYoeY8SF0V2rMIntgWUTKjwrg?=
 =?us-ascii?Q?//wAXQw2fp+t8opF1e9gVHlmmZ3icf7LENaJ7DVFBLtZU8piD2ITsRgtOJJE?=
 =?us-ascii?Q?3p+PQd4mzwrilwb9vk3aWIJ7+u+m2gDcFhPH3XgIRpOcl2bFE0J1+7cAuSBm?=
 =?us-ascii?Q?a9giLoKJoSuKgJJK3cS6SL46qwAWsyHhpoXjtYviFoIUrTtD00HOUbnrEdMT?=
 =?us-ascii?Q?x3MURj8WZtzoU/D1qlsL5ViAalIIssmR7jydH7SaBDoFS2V2A3Rrzha1NsIh?=
 =?us-ascii?Q?CUemdYHs6aB2FM05aaeRM2iwOvgWZ+mvH3X+RqkRKOIAiYzDVkToxzdZTGQ7?=
 =?us-ascii?Q?lsnHWYcCMPt8VDMAVm9YkIAc5OLsCJZRthiMCO+/aoZD8c1kGPfdnOYhHBfJ?=
 =?us-ascii?Q?MaEz3jm45o+/Kt5OHcfm6LVUIXEfE/V5m2G4KOEwgZOpoSGQScQ+eY/MXP4W?=
 =?us-ascii?Q?vJd5etmW3YM6eCm9onAN7j8gPbbw0Nu6icejx6ZS3YZIIoT/tjbbrcsG1WPP?=
 =?us-ascii?Q?Xl/PoaYRceYNCbrfnal2kapbKlsO0S4M84aqBa6DVLKdkUF8A7nwXpEwKWgw?=
 =?us-ascii?Q?sjxOk3cH7Sue7t7+niJY7zPkmlbN5xHFPIYYLNoYx/DRwbzwYbAeZtILCWdk?=
 =?us-ascii?Q?SOxVHkUmBy+IdHJPAxXbQ1BqqWzdm/gqXsMvSxYEA8qA/eoZwckyrk/1/B9B?=
 =?us-ascii?Q?hT82xGiRML8fSCXEVG7ObT0YSqequ+y81VF611Rs1SjCgmFYFbw++BrwuYTj?=
 =?us-ascii?Q?/luRGjp06e+bCobuzuVwr69NYsdZmuxJ+n0XEXc2ID/REhfA0wB7AF4qmK5s?=
 =?us-ascii?Q?YfRkQbrWpDVf4QiIZNL4qLjMybe6k7sNXzqIFzsmBBpiXJ7ZhmN+6Cn6rD0u?=
 =?us-ascii?Q?uEcIxczZCJLeMyv9VAeb1uDaicWAJXSl2p/C4nNyNMESbreLqytDysLn0qju?=
 =?us-ascii?Q?7p2ZhxIQrkLOcUUsyf8vz2QQ6LbpB/IKnSopGr16oJ1RWkNc1peNydfgvZYS?=
 =?us-ascii?Q?VgU8zUL72zLTgMsM9CMM69cZ+5ZmGvU6y4uxN6PwkUVeceZMJ3HrZiPSTT+B?=
 =?us-ascii?Q?pKdekPSX3e2rWOrBdljUmhniqABRNNot7KZz414ZJQAayi1mrwSF7+guR9+6?=
 =?us-ascii?Q?CFKwEQMmL/nIfI5VdbQM0nJhlE/GjCgcpwOcuM6Sk9zRtAEo/tSNiMUDOHXe?=
 =?us-ascii?Q?sCE1+vDKT+dqaTTYV+D1rx1uSYUcswXB8aOIxVB/BAhsxz9Z29eMKtwhtiyK?=
 =?us-ascii?Q?qpWG1EB6Z131L415cQng5aFy611pyQd4tt15KQdjvxW7jmyW+dh+xUGT57rk?=
 =?us-ascii?Q?62UEHSOlG+u2Lup+gwYdG8ToLk1y5S2et0sYYziOaOygTuXrRxk+QqblxWDz?=
 =?us-ascii?Q?5gAahSdzRs2JsbVWpFZwAIoX2CRDbpsioAfJHfihRHLOOVrJOIilL4pe9aMB?=
 =?us-ascii?Q?FgNH/YeXGHXN2xKq6oOuiS7ibT21xSijxnTus4ikdJJUtYUbJO2chI2Sw65D?=
 =?us-ascii?Q?FJ2DBf8X7IMiGcu8ErpON3afTcGsZfvrgIEIxDJ+W7hNcf3IutmRmaD5Bl+n?=
 =?us-ascii?Q?Ham20gODOdx419CzcVdROr4GvAAvriiGzvH/i88e?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6102
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	71190f22-fdc2-48d5-0eeb-08de68c60d08
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|36860700013|35042699022|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G6VBUURpiHah+4fzCCx9LiNBkiV6xBlpRyvqi8ZBN9DGvEcEDMpBeobCON3g?=
 =?us-ascii?Q?/VRk3qFDNftcO+F2DqhdvffgV3fCYmBmizVpO+/HHC8gs5ndP/GqEGamxNYL?=
 =?us-ascii?Q?1K+kuUAwNnL3LFGks79N2hhaxBjBrGIelr7yAL7yc785kjmkZxa3slLIamTD?=
 =?us-ascii?Q?WBpgXWao6d6LPlpuRoxlvxCksYG7FmHPS2+4XHiOvBx+aoQ0THJSRsZxYvRP?=
 =?us-ascii?Q?ZEJbckOtXQu8jWU4EgYgLtcPb8K+nbrGKMFqCA8jLCytooXhHO9+IOMptr9D?=
 =?us-ascii?Q?ePHs+kDOzhJ+xslKfjQr1S2kt2wbKiToHRgK0CNVHkkYzLzRX+LnIZLebvTw?=
 =?us-ascii?Q?UGhu3j16YSduxJ7KTV6qSScyX38fZ0Ikemndmqtj/hJgaAfQjrbmr7/CwWVL?=
 =?us-ascii?Q?eLrVu8yjdqWr3lMRy/S7PKycYCbFt6E5kx44JWKr3YWV8V8/SRfy8sRpvCz/?=
 =?us-ascii?Q?GqeJD3PKJ8J21665WUCcRdbja5XXKxBT9BWQueid0GFEICnjwN1mO8cIdy5T?=
 =?us-ascii?Q?faesAtzCZ8PjjUlAoGDe6xbJsR0w8yVOU/Hz7G9cdxLwyrl0PzPVt19oLjgM?=
 =?us-ascii?Q?N6J69ap1wUfbw8e9w6VyMR+yTqrnWj5rY+bMcdisqxghD8mi8FUOvTeLV384?=
 =?us-ascii?Q?griUtyLZXn0i+UJWi5JOtfDcXIfQirP2AVRRRGG/X+Au2OqLonh8ilmH9sbE?=
 =?us-ascii?Q?6eTdS/E0rDaGPoReb0luoqSm1T7I152ARee5hEKDFl5vcz4UjV1SW4+ZVB2H?=
 =?us-ascii?Q?A+zxJtkwnr2DhbCMiiKSLRY4Pe13dT2Uok6t6je1b/Ak9+xd9eHRi+F+yuUq?=
 =?us-ascii?Q?qCRTXRO0qPij1CVHEnUC8PKfYQ0HpI0rP1BCa7ikuWBt6Gm60joU3FHHK1y7?=
 =?us-ascii?Q?QN0BIsyV8gLhK6dSPFqda3BrAb/beavTGziEbNFMyNyn8QHKvbWmIztfIRgg?=
 =?us-ascii?Q?QuiZT7pHM3TDPEBajyj31bEYr3/4hy7rL8dMulfoCQWPrrK33z12/k2M97BM?=
 =?us-ascii?Q?ncG177BaPi1EGf9FqK5qdd4maraFnv1+xGMH1bv8TNonpvUrCmwVwSDTfrg7?=
 =?us-ascii?Q?wZ6/+gsNWhkZyK/fvAcpbyQVhp9LKJFC4A+o0phhneMW68njpk+Sc6kDtCRR?=
 =?us-ascii?Q?9V3upX8l05FaYNPlwf5iLSzrsRHjYwSvpYW2CQOctuI03tagGrGBhPoAejob?=
 =?us-ascii?Q?7WzaqF42ULBrJ8Qjvv0Ah/52zWR5rqn+l6WoT62gFY+Ijjycyq+P5IgDacS6?=
 =?us-ascii?Q?Pb570eRe9dxeG1U5lDggkZkJH3xDUksMcg9j0CgVwnPKbkt0bgRy29t3jbV4?=
 =?us-ascii?Q?fTwKX5V1tNswB67SvQ6cnh5BeKDJ3AiAnPDBz45bnVmkkLNoWfqqPVITZqhs?=
 =?us-ascii?Q?2KZGn6dKhXJbYAImqrKF3F6S96gmMK5kLoL+beRH2SAvP/i8Jdhx28AAaKOb?=
 =?us-ascii?Q?kCkc/4db9hVJmd0ogjosrK66bhjDLCfMfy1ej4GUipjYNwygEB/qq1RGj7Xr?=
 =?us-ascii?Q?swS2yCSXibCccDBet0iiL7EReJx7c2tqQdLd4AAugq/9y76Z6WsGCYx/RAv3?=
 =?us-ascii?Q?c4blLttlpHVbaBFpymtibx1YmnCQPU/T3o8XffhBD8lNi9KwZG8Y6FXz2M4q?=
 =?us-ascii?Q?BwmRbgkw17Jm1kyDTQNQFwVvKGrBxLh/In1oOqgojmvw67UM5djwXVEcfSuT?=
 =?us-ascii?Q?al5M4k8dbe0kPEi7snTBS/K/DCE=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(36860700013)(35042699022)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mkvOjt3NwDJF7CEJBTqSQ+lRvozEQiM/UTv4xCxBFjALCFzQh+S7ecFiWqyFTT9RFWYGt8+B33xN2eCCxtwAD36lhVHTi38/6G/KmBfVg+n+WAfedM4147XrUUg883IDY+C3sUxqAKBOvNRUqJt+h7wutguUY0F93Wx7lO3CZOKy6BHx1WLhbDCzA7UXiw76+ROGoQaXdNfeYS4qVgHup/RDTc9eQ3RTv60YS1i6e/UswroaLLMtiGR6e4wkfhEq+2fjCH4KIDF+mKMU1XJFl6QnWoFENAkLHx4xNW6Pp52EHiAkxlJOavc5SzMoTaMqJueT939KZOw8GnMB2mfhggtXTdgJ2Tt/bVBfOMEJ6oFM6xDrFjj1sPx7E/LewFUqeeIjAZrRi6u98eVGKoKajlP4jUxqXOiYMqfL22Jw69WYpw3UdxAkKiIdV2FzMqWI
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 17:02:40.5958
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c72932e9-123b-498d-c4ad-08de68c6334f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10406
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70770-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RSPAMD_URIBL_FAIL(0.00)[arm.com:query timed out];
	RCPT_COUNT_TWELVE(0.00)[22];
	ASN_FAIL(0.00)[1.2.3.5.c.f.2.1.0.0.0.0.0.0.0.0.5.7.0.0.1.0.0.e.5.1.c.3.0.0.6.2.asn6.rspamd.com:query timed out];
	RCVD_COUNT_SEVEN(0.00)[8];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,e129823.arm.com:mid]
X-Rspamd-Queue-Id: 44F5711D7F5
X-Rspamd-Action: no action

Hi Catalin,

> Hi Levi,
>
> On Tue, Feb 10, 2026 at 09:54:49AM +0000, Yeoreum Yun wrote:
> > > On Fri, Feb 06, 2026 at 06:42:19PM +0000, Catalin Marinas wrote:
> > > > On Wed, Jan 21, 2026 at 07:06:17PM +0000, Yeoreum Yun wrote:
> > > > > +#ifdef CONFIG_ARM64_LSUI
> > > > > +static bool has_lsui(const struct arm64_cpu_capabilities *entry, int scope)
> > > > > +{
> > > > > +	if (!has_cpuid_feature(entry, scope))
> > > > > +		return false;
> > > > > +
> > > > > +	/*
> > > > > +	 * A CPU that supports LSUI should also support FEAT_PAN,
> > > > > +	 * so that SW_PAN handling is not required.
> > > > > +	 */
> > > > > +	if (WARN_ON(!__system_matches_cap(ARM64_HAS_PAN)))
> > > > > +		return false;
> > > > > +
> > > > > +	return true;
> > > > > +}
> > > > > +#endif
> > > >
> > > > I still find this artificial dependency a bit strange. Maybe one doesn't
> > > > want any PAN at all (software or hardware) and won't get LSUI either
> > > > (it's unlikely but possible).
> > > > We have the uaccess_ttbr0_*() calls already for !LSUI, so maybe
> > > > structuring the macros in a way that they also take effect with LSUI.
> > > > For futex, we could add some new functions like uaccess_enable_futex()
> > > > which wouldn't do anything if LSUI is enabled with hw PAN.
> > >
> > > Hmm, I forgot that we removed CONFIG_ARM64_PAN for 7.0, so it makes it
> > > harder to disable. Give it a try but if the macros too complicated, we
> > > can live with the additional check in has_lsui().
> > >
> > > However, for completeness, we need to check the equivalent of
> > > !system_uses_ttbr0_pan() but probing early, something like:
> > >
> > > 	if (IS_ENABLED(CONFIG_ARM64_SW_TTBR0_PAN) &&
> > > 	    !__system_matches_cap(ARM64_HAS_PAN)) {
> > > 		pr_info_once("TTBR0 PAN incompatible with FEAT_LSUI; disabling FEAT_LSUI");
> > > 		return false;
> > > 	}
> >
> > TBH, I'm not sure whether it's a artifical dependency or not.
> > AFAIK, FEAT_PAN is mandatory from Armv8.1 and the FEAT_LSUI seems to
> > implements based on the present of "FEAT_PAN".
> >
> > So, for a hardware which doesn't have FEAT_PAN but has FEAT_LSUI
> > sounds like "wrong" hardware and I'm not sure whether it's right
> > to enable FEAT_LSUI in this case.
>
> In principle we shouldn't have such hardware but, as Will pointed out,
> we might have such combination due to other reasons like virtualisation,
> id reg override.
>
> It's not that FEAT_LSUI requires FEAT_PAN but rather that the way you
> implemented it, the FEAT_LSUI futex code is incompatible with SW_PAN
> because you no longer call uaccess_enable_privileged(). So I suggested a
> small tweak above to make this more obvious. I would also remove the
> WARN_ON, or at least make it WARN_ON_ONCE() if you still want the stack
> dump.
>
> However...
>
> > SW_PAN case is the same problem. Since If system uses SW_PAN,
> > that means this hardware doesn't have a "FEAT_PAN"
> > So this question seems to ultimately boil down to whether
> > it is appropriate to allow the use of FEAT_LSUI
> > even when FEAT_PAN is not supported.
> >
> > That's why I think the purpose of "has_lsui()" is not for artifical
> > dependency but to disable for unlike case which have !FEAT_PAN and FEAT_LSUI
> > and IMHO it's enough to check only check with "ARM64_HAS_PAN" instead of
> > making a new function like uaccess_enable_futex().
>
> Why not keep uaccess_enable_privileged() in
> arch_futex_atomic_op_inuser() and cmpxchg for all cases and make it a
> no-op if FEAT_LSUI is implemented together with FEAT_PAN?

This is because I had a assumption FEAT_PAN must be present
when FEAT_LSUI is presented and this was not considering the virtualisation case.
and  FEAT_PAN is present uaccess_ttbr0_enable() becomes nop and
following feedback you gave - https://lore.kernel.org/all/aJ9oIes7LLF3Nsp1@arm.com/
and the reason you mention last, It doesn't need to call mte_enable_tco().

That's why I thought it doesn't need to call uaccess_enable_privileged().

But for a compatibility with SW_PAN, I think we can put only
uaccess_ttbr0_enable() in arch_futex_atomic_op_inuser() and cmpxchg simply
instead of adding a new APIs uaccess_enable_futex() and
by doing this I think has_lsui() can be removed with its WRAN.

Am I missing something?

> A quick grep shows a recent addition in __lse_swap_desc() (and the llsc equivalent)
> but this one can also use CAST with FEAT_LSUI.

Thanks. I'll apply this with FEAT_LSUI in next round.

>
> BTW, with the removal of uaccess_enable_privileged(), we now get MTE tag
> checks for the futex operations. I think that's good as it matches the
> other uaccess ops, though it's a slight ABI change. If we want to
> preserve the old behaviour, we definitely need
> uaccess_enable_privileged() that only does mte_enable_tco().

I think we don't need to preserve the old behaviour. so we can skip
mte_enable_tco() in case of FEAT_LSUI is presented.


Thanks.

--
Sincerely,
Yeoreum Yun

