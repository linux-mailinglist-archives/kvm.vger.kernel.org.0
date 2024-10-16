Return-Path: <kvm+bounces-29013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 660D99A104F
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 19:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 260F2281486
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 17:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5112210183;
	Wed, 16 Oct 2024 17:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HwEh5c9y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eAvdhi4R"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE8F1885BB;
	Wed, 16 Oct 2024 17:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729098326; cv=fail; b=ZsFIY3+x160yX8fNwRJT/+LDtJlHJGrykBMw3/gw+sOllrl9Y3uQSJ+Eg7xunVItlrOumWHDAefiVWGZju06GbWWUhD2DNhSActIxqagoGWuqq2ba3PTgfvmIfYf8FswxmNd4mWOGuPOdjgCD4ILDMfy4SVhjJlp7yZDeZc5SP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729098326; c=relaxed/simple;
	bh=+PlmQyC/qpyEPCX6qA8RPTxDLuTPfKS6N/GGmnDlxTY=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=eGZpo/VR+Ne7AGsVHYmj3p6PjkBdmivs0OqgQsvgctET+AG0JGc6Cql5LYMR7fWyS7li/hljR3ddTt5+Q+dIFczEPI9G+fxgEFXxWP3rhXNtaz1opcpMJyiJz5vTRhjazyxfoKXK5Y0UVSpdJ5zCMZX6pw2VumnDZt2WE6LhoQQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HwEh5c9y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eAvdhi4R; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49GGBXK1012717;
	Wed, 16 Oct 2024 17:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=q4PB5f6XKHIv2uh3lG
	QU6T1jIzPkuRVNixsc4fyHddQ=; b=HwEh5c9yC9Yeh/VpOOHmjOFPZMS8w4Y3bZ
	roedXre9iegUjl7DbRxQNyK+CkP60eIRTjzujFiQs7qbkcNThEGcpMlo/bQoeA3l
	w5DpdbfYkQCCrj9Jq7osj5pLuW6QHJOOGPyb1meO8AfKasfwzfvnCnPOrlLnMlV6
	YtZZBTBJruTLmH8Gs16/3a7MddgVy9igm6B1+GCIMrvo9zRhYzxm38CSaeQQnwOP
	yChdM3/i3EySPmimwaXmQR2D4ly7IcN3kG5PEMGRtrXsem7+Zujr7FSMrQcjLYbC
	IwOnTzpVUSgG58d5DFG+6JgaZwDJ1J3RS7zWzch5n9nCd2rpomBg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427gq7md63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 17:04:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49GFxuld027223;
	Wed, 16 Oct 2024 17:04:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjfpm33-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 17:04:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E3lWK3yS0kMrM6DMNtY4AsnTU5KkkbPq97DGSNqiXO0uXXiaGFcSs6Y/O5Uaw4RDcmOEGItJcvEMfFKLSojBYckb1UVYRFG1zbNzRwshGDWXHSMLNOFFCfpSlTVwHkNvQdx8xEt/UJXaL/OCRmiqU66ISVmxRKhaa9NTedvqpKyT5fyaXs+PaCawMDlo43aZQ6pD7Ckd+hqu3gsVYjUc7c5vrHeTWSautAFtH6SFgqH0zsBRipSsdVDQPIEjY9vXOZqzynVAo0JqLCVOTGtCAQ0mGeGVOUpyAV7KhkgfE2VdNPw5naGfgiGRnS+Ez/5rm9kQbvfn+CK5yTUXCEQCOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q4PB5f6XKHIv2uh3lGQU6T1jIzPkuRVNixsc4fyHddQ=;
 b=aV9Ol51CG0kNuam1tmABgzL7b4om1H3BBxD3izx6ZeEawZWwQg/8EHn2zeImR6TbS89iDmkh6qoSn58u8n4UDpLwkP+QZ0i6KiJ0YkkvyicOInR6+OooZg/XkRdXJeg9eYOGobaLNAuiPjLPyXnIrTJZBgEDU6fOYKm4/4r8Kg/gGLe5aB8uFYBU8CJadjNfEY0Y+6hdu3nmVKUxvUHiGkqj1DFY9helr/3/wBeLHB4rCv1m4vsyqUpzfEuSMJmRAbPwrhSWUKvfWboP2sFNmttTGxCqLtCmS5+VMEFVXiIpy7agfiYLErTx4QFbACIxGW4zLS276Jnm2shwFL2GHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q4PB5f6XKHIv2uh3lGQU6T1jIzPkuRVNixsc4fyHddQ=;
 b=eAvdhi4Rj0f+jDF2qTjOG5Zf6C0JLz1+Fef6CuqwQwXd/dF7LHoQ2rHDphOv58+9/OHm5+4aIKPtiTqRacPvupg6jDOz7438U57WaDnPtlMLUCjkYY8iScyzyRFN82c2xO8Ad7oC/Xa+eO1/ZVQWXwg+H+06VdPWvs+asoz7gFU=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS0PR10MB6823.namprd10.prod.outlook.com (2603:10b6:8:11e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Wed, 16 Oct
 2024 17:04:21 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 17:04:21 +0000
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20240925232425.2763385-2-ankur.a.arora@oracle.com>
 <Zw5aPAuVi5sxdN5-@arm.com>
 <7f7ffdcdb79eee0e8a545f544120495477832cd5.camel@amazon.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "Okanovic, Haris" <harisokn@amazon.com>
Cc: "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rafael@kernel.org"
 <rafael@kernel.org>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "wanpengli@tencent.com"
 <wanpengli@tencent.com>,
        "cl@gentwo.org" <cl@gentwo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "maobibo@loongson.cn"
 <maobibo@loongson.cn>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "misono.tomohiro@fujitsu.com"
 <misono.tomohiro@fujitsu.com>,
        "daniel.lezcano@linaro.org"
 <daniel.lezcano@linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "lenb@kernel.org" <lenb@kernel.org>,
        "will@kernel.org" <will@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org"
 <peterz@infradead.org>,
        "boris.ostrovsky@oracle.com"
 <boris.ostrovsky@oracle.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org"
 <linux-pm@vger.kernel.org>,
        "bp@alien8.de" <bp@alien8.de>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "x86@kernel.org"
 <x86@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
In-reply-to: <7f7ffdcdb79eee0e8a545f544120495477832cd5.camel@amazon.com>
Date: Wed, 16 Oct 2024 10:04:19 -0700
Message-ID: <87wmi8ou7g.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0114.namprd04.prod.outlook.com
 (2603:10b6:303:83::29) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS0PR10MB6823:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b838ea5-4479-49f0-3582-08dcee0493fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZLaaMAXC5joX1MrYCPKiiY8e+rBIgBsjRHNG4mkX21AxGD5545sPj9bMYi7H?=
 =?us-ascii?Q?CBSM4sBO6iB/2gDxWoGjHqiEVRITMU5mq+2/qx2qgTQ2YdNH8KfT9j1deHl/?=
 =?us-ascii?Q?gjLsS4EcoF4FQgHFUapm9OI9EgC64jPnzzatCy3kFoUrx68PyXwLe+9yHVMg?=
 =?us-ascii?Q?gbsSGdnAYqmsxbNzOWyb8pT/Hh2Gf1qIRwDIgfBHX2F5A6DIRjiU4Yfc2gs5?=
 =?us-ascii?Q?OByXEdosokAmPr3CME20RPXKOz29fiqNzxb46ZTwRgoif58/4me7q/v8AEx3?=
 =?us-ascii?Q?Luw6E/pZpYrL8XJtYBvYJ2vYFPCmfdYlS+s4U9ImAIE0J+/Q1HtEilTRSiyo?=
 =?us-ascii?Q?NNfuVyByP6feQcIY7ASJvcA8tkr9MCqDx5Sm9sfdDMHC8Y9K6LRCW1KkjSbv?=
 =?us-ascii?Q?qNkP9LqAcqdt6geHXLR+ur3KP1ztF/OUlcFXBaKMFKJEXN0SWqp/nu555bee?=
 =?us-ascii?Q?HyYQNefYE6h3Do9RLnikDjO2Z3jv/N94nweELw/5ve3dZVZLsOFxRabFGajh?=
 =?us-ascii?Q?YVblaVvo9g9AsZxh2dEu8uyYslcf0XGDrDBOUX6L5j7lJxz6oUV0VrGLdTK4?=
 =?us-ascii?Q?qLd2OFcsTQIgMlf5ObO8aO/iJ9fVvdOmj6pjSUOsh1suCrvMQnMCI6LiKkTv?=
 =?us-ascii?Q?0nEm4uUIdetddWG1xJyNoMwkdFoq+Z3gTnjf+3c1KoJHopMLcS19cetTtBcB?=
 =?us-ascii?Q?gch2VbfyOPXtmsqSRPrMuhXK7LatIRecmSYkCzce5WT8YfK6Sd7rovyUx5FC?=
 =?us-ascii?Q?DPSXgpexL2go3mWcUtCc61pqW1sMKzhC+DdO5RZu6rmY0ww2uQY0OGOYADbU?=
 =?us-ascii?Q?pb1PvJisGcCVX+EnTY1A8924AbswBYKboVIWj0TAG3UXlM0dYUmAFXbJlodf?=
 =?us-ascii?Q?GMl7+oFTtFvNrGLUolCqqdhGxF6TcBOcAzzG6G2pVwLhB6PJsjV8jXS1qy/e?=
 =?us-ascii?Q?FZENa11d30wOvZC4LI989C0glQ6MM0XmLnPPu2nZpLL97gt10C2h9wT3xzF+?=
 =?us-ascii?Q?zJ4Hg6gXKpDbfM+AwaABQXxVCoP1qeHIvLid6m9tbE8t/RdFKV9lanDdzxKr?=
 =?us-ascii?Q?PgwgMfAG3q8lRh12WOLVvknmAbYM7SqG39zTi02YK9HosqxOQ0Ej101KwomT?=
 =?us-ascii?Q?9VCdZkJjICL0YDmIMQhiDqxWEkhDvs8v4yjQWNQCiuSJMEQrjElKiTMqN80Z?=
 =?us-ascii?Q?6G+Fgcr0EWurvHirAD0uUjWl3/CoWAI9spKIzxouQQZuMNCWEZhmF3Pf+9il?=
 =?us-ascii?Q?+uY50pIzRsfvbEoF8wStRNLQ5lOSxfyYtFvhwCreCA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RmXDhKgJTw8JInqR6LpvEAsWOij0P5yCzXmHFYRUVcWBPRgjKjIah80FlXr+?=
 =?us-ascii?Q?JoAyGTqywBPVkIkhi3bFuY2VpFBpMPsOW39Yozdn/ksZo6krDZ/yfFngcv0/?=
 =?us-ascii?Q?TrMCCbFDnH2DtZ//GqqQ4oRlU7J0yz0tLKw0rXXVY7TgzFezOd3knXTCRqNQ?=
 =?us-ascii?Q?9KymcjgnGTyV2qQfUXbDk3iXlK0XMD/vTlIu/cCvqfOTvsQx0MCSeOTdNx5e?=
 =?us-ascii?Q?XEx90VtJrCHuQWpL2wjfg7MQH4XpLgd5vkpzqvsGuaEyDh9tuKGz0TOkxteJ?=
 =?us-ascii?Q?Ps+EDmkmImQ0BJKlSRPDPJuoxbiW7hlESTOTeTsZE6on4l1jWWRZqIFHTgmQ?=
 =?us-ascii?Q?jo4L7ZBt7o6EGA7HGVnmbrf86Ozh1SrkSqhpqNk8dq0kawEStQdFapjfyq7A?=
 =?us-ascii?Q?4zTOtcrOyFqZ8fX2pyhCmKlpZBKbAEd+f4fr8mDMuZvfZkLtZDQr+dKb6tm3?=
 =?us-ascii?Q?GoxJ3G4YSbxxAoNc0WWsnZzMQo1bcaerTsnTZ26yCxsdqIl1x3CEYCnTill6?=
 =?us-ascii?Q?dTO3CrAebetgKNNqa3Rb5TERucMHIcxIBJ1S4/3zIiGf+pPxYjPWmQBZQSB4?=
 =?us-ascii?Q?34pKw1/je5W3ANbQsZnz3OmjTjG74YCcOjOHG22zOQZH2mcDgusDQgNEpfV3?=
 =?us-ascii?Q?rfBl95qdvRNrJcgC4Ar4RQzews3ycMQw4FZ7j+gLRVlJUVmyBfeSjwVbC/X4?=
 =?us-ascii?Q?AjmQBUcxSAh/dZcJUgVU7pICf/P+EFL3AcmlA7W7Cb0B10TLnMKOWti/EZBh?=
 =?us-ascii?Q?WkXftJDxcSVHAtbO/aOmKh6UX7604He0r3fUZCkYmAK7huDcddkLxRkTpHX3?=
 =?us-ascii?Q?NUH0JQTLpkZBxgDUsuPnd7WzrE+IXg3LdCvW2S5bZtbET0N229Ydopl3eUzQ?=
 =?us-ascii?Q?61TgN5AXIn2Qq9kZyK4QRL1BbdrEKkRWey5h5gFqEe4LWPtqqw68ru6W9mB3?=
 =?us-ascii?Q?5cpSF0pDsJrz7OD8XTxdOdzzwGhElZOeth0xm4LD1DzZ2Phflw3XSrz8LhWo?=
 =?us-ascii?Q?6KcPooWOZL+PJ3XXQqyienX+k8byvGSh4UbAMgJWGDRQ6NIjUgGRYJOGHLQl?=
 =?us-ascii?Q?GSiRAqUEHKT2XhBfkkvIlF3jEmX4/BP6FvkMNs2zYC/3mHVu31vxs/1MUsFI?=
 =?us-ascii?Q?gExlavJYgES9fkzs1VMq7+VF7oLMK1a2byj031glIPmVqdADv/e4CrRcNXwU?=
 =?us-ascii?Q?OolyItCPdUdZH1EG6DAtNPn6GGjVYFvYKVBEip4FRD/eM2bxO+sDFZ2Mgtlb?=
 =?us-ascii?Q?sC5Nr8wcNyM8gI6TJh8pcyXFA1pnOHyk2FlD4h4OIVEn1igFTSUlr0Q8Bceq?=
 =?us-ascii?Q?e4/2t2vKoQY8IpYVipPbrQar/hgxnpEyN+0zo3QiumZlUD0klAehzFjEkzNW?=
 =?us-ascii?Q?pp63d8zH4Sig+W5RCxJoIdyZZ6EZyvmKmyv155QwfBZMesU4/H0p626A4EVD?=
 =?us-ascii?Q?N3iNZQ+JroQA0SOZdOkbk6xAGZcdKhSnNAlPCPG/UG+P46F8iafX9X+Sn0SD?=
 =?us-ascii?Q?pxTSfMPM48vfGSjFZp4twGW7av29HKlMxA2Bt5ukOagJNbqGYuluNsXvfkpH?=
 =?us-ascii?Q?5uGQKjW1wr7MokkhFKTF0rFUgnSlcKDG1lG/RVC0?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LpyZHEgrZ0bcu738ARHy4OKPwAc7E9deiVN/0voUZ685XXClOa4xaspppVWfpZ2hLm8ZzMf7g2gMbr+ESjuyu1ya099K90VHGFpdK1NJhZx9EpIfMoR7Lx7leX/eifYDErDS6GzdLT8gNd/OH/Ca91O8sgf1yCzA3LFcvVJqAOsU3k8BtzI0ovHRHFr6jGKWKSjiX06+4aaD9QG+o7Z10TlYWrgKOoyudp2sH6s5e9gQZTzsYEoSVP/iqcnTBQfztp7IDRaDYNq/NnI1FUreyGKCAhv6EO60jFBF4vMiB1lkcTFVCyPUjalbQVp0tIbszKwc8G2uD6QBaLvWHj1tV3FhAgQb6DibBedYarFqOp5QGIcE7t+w+sNyt/T6xWdKIwEzIgnglHGOwZgUFad0bFsb6nch64lTMWjTYkshZYNsVK7KJ6JisuPjTcsAHirADu+rm1Q9GJ/nrT8y/eIDmLTobHOUTDmCptfZTuR24UGv6UTxY0HR3v2HtTsQR+nlJ/Ofee7ui6yNiHqZ4HChkCK7NzeeVkAcoeIex1qHpvSc1Iha1XGkdck75BvzHDdrZfs3soxCekBh3DfFd8EJrxz6J2XxUMcWBDA+lEAvY+M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b838ea5-4479-49f0-3582-08dcee0493fe
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 17:04:21.2025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jv328EdDazzj3f6TRQwN4SgZxP7h9zqEqgbWbCDcm/ER/dfyBWcO26+WqGRNT5HfFBYmVSalz813AKZRK+1SFN6ql8n4aq18sS8pkHXiuGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6823
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-16_13,2024-10-16_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410160109
X-Proofpoint-ORIG-GUID: QSmvJX1hSiwAiZ1zVenl0_DqRktTkat6
X-Proofpoint-GUID: QSmvJX1hSiwAiZ1zVenl0_DqRktTkat6


Okanovic, Haris <harisokn@amazon.com> writes:

> On Tue, 2024-10-15 at 13:04 +0100, Catalin Marinas wrote:
>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>>
>>
>>
>> On Wed, Sep 25, 2024 at 04:24:15PM -0700, Ankur Arora wrote:
>> > diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
>> > index 9b6d90a72601..fc1204426158 100644
>> > --- a/drivers/cpuidle/poll_state.c
>> > +++ b/drivers/cpuidle/poll_state.c
>> > @@ -21,21 +21,20 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
>> >
>> >       raw_local_irq_enable();
>> >       if (!current_set_polling_and_test()) {
>> > -             unsigned int loop_count = 0;
>> >               u64 limit;
>> >
>> >               limit = cpuidle_poll_time(drv, dev);
>> >
>> >               while (!need_resched()) {
>> > -                     cpu_relax();
>> > -                     if (loop_count++ < POLL_IDLE_RELAX_COUNT)
>> > -                             continue;
>> > -
>> > -                     loop_count = 0;
>> > +                     unsigned int loop_count = 0;
>> >                       if (local_clock_noinstr() - time_start > limit) {
>> >                               dev->poll_time_limit = true;
>> >                               break;
>> >                       }
>> > +
>> > +                     smp_cond_load_relaxed(&current_thread_info()->flags,
>> > +                                           VAL & _TIF_NEED_RESCHED ||
>> > +                                           loop_count++ >= POLL_IDLE_RELAX_COUNT);
>>
>> The above is not guaranteed to make progress if _TIF_NEED_RESCHED is
>> never set. With the event stream enabled on arm64, the WFE will
>> eventually be woken up, loop_count incremented and the condition would
>> become true. However, the smp_cond_load_relaxed() semantics require that
>> a different agent updates the variable being waited on, not the waiting
>> CPU updating it itself. Also note that the event stream can be disabled
>> on arm64 on the kernel command line.
>
> Alternately could we condition arch_haltpoll_want() on
> arch_timer_evtstrm_available(), like v7?

Yes, I'm thinking of staging it somewhat like that. First an
smp_cond_load_relaxed() which gets rid of this issue, followed by
one based on smp_cond_load_relaxed_timeout().

That said, conditioning just arch_haltpoll_want() won't suffice since
what Catalin pointed out affects all users of poll_idle(), not just
haltpoll.

Right now there's only haltpoll but there are future users like
zhenglifeng with a patch for acpi-idle here:

  https://lore.kernel.org/all/f8a1f85b-c4bf-4c38-81bf-728f72a4f2fe@huawei.com/

>> Does the code above break any other architecture? I'd say if you want
>> something like this, better introduce a new smp_cond_load_timeout()
>> API. The above looks like a hack that may only work on arm64 when the
>> event stream is enabled.
>>
>> A generic option is udelay() (on arm64 it would use WFE/WFET by
>> default). Not sure how important it is for poll_idle() but the downside
>> of udelay() that it won't be able to also poll need_resched() while
>> waiting for the timeout. If this matters, you could instead make smaller
>> udelay() calls. Yet another problem, I don't know how energy efficient
>> udelay() is on x86 vs cpu_relax().
>>
>> So maybe an smp_cond_load_timeout() would be better, implemented with
>> cpu_relax() generically and the arm64 would use LDXR, WFE and rely on
>> the event stream (or fall back to cpu_relax() if the event stream is
>> disabled).
>>
>> --
>> Catalin


--
ankur

