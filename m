Return-Path: <kvm+bounces-66600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BC70ECD81B4
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:10:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4437730AD3A2
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 376702F3601;
	Tue, 23 Dec 2025 05:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ZwI8ZNuD";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="YcHT1zFn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A982B3009E4
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 05:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466312; cv=fail; b=LDh3wlKGCML7s7dEZVZAlX1jd2/uR2kqQ6cdT4nDcmjJtqWg6AltQzteGfO92Q0A03khFtWEQjhWp7dRi/CISql6eke175aZe2NSRQTDzwvcZmxhKkBHBHxQBT7e/IUeCtpqGz6s61mhYsUFptttVrhZGgUHoPq2IqV6IXI37PY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466312; c=relaxed/simple;
	bh=Co7ow8RMRE1LPnFyPwlI2+3+tqn8m88u5+JcicDSg4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PJcLuNXGBkKGcVPuUMC7L2O7oQ/0Ca29eXgLlTGlNTGi8fEIRCtmBsUSGneE6Nm0oAZKgpKl5hWdjvEZjaDSqj7OSxD7ZRppoTM2hpIGWNusflHiPPrqyHDihE3PEDBt1oWAvPLkUn1rfH+KoseTDVPcilQ8tl3anB9AzbQmFuo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ZwI8ZNuD; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=YcHT1zFn; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BN1Load733160;
	Mon, 22 Dec 2025 21:05:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=4XatUr19U2rhc9KFECrr7ehzC1Io+crL5/qnLydGs
	4E=; b=ZwI8ZNuDZ7zq25GphyzRj/b1Z5wNgVCfPFdyrIbuPGNyXmhoR2x913P7H
	HVpfKppvHmE0Lub5GRIS/JkbcxNZd7/+nDneoego8yp8A9bK8Q0GPYTWZPL+mFLl
	csmrYfwri63YFzHnAIWVYfGmmc3jfZZRYNgeJeXTLX8rSsQnQraMqcnrCLaY86qi
	HbfBR7RchMtFa+XcYm58R1e1tMB7do5tvRouzAMcjvT4exj6LVIn4OO0me8SwEh7
	741MIyOQbbN/rTrjRQ/wfHG645Mp6/ejhLCYSG6fHT1rVb+FXTuA3oReqjIXtjv8
	DCDpwIUk3f8MjYPANVRW+PCYpyC6w==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020112.outbound.protection.outlook.com [52.101.201.112])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5t77cxqc-4
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:05:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rpKEEBi7OPTFBRgHGBxRtoOxzZ9+0E9oye63vXDIOnt2gNJPOSopU7s3WcHpSvt9d+P8vmALhpFoTkdBsXB1ezQjj1uXWI509wxVhKJ1Xvl8dk0tPNOLTOFmyT/6FZAQ6deaOZWHFRuSS1jd9tBW9RoOQiBzc3CYGecKTDc4li/F7RZ1NmelYn/V9L6VbZwc6ju+7aV0ovtCbO6WJlU86RxMksyYKxwbfGrGNbZrTY7X6lcvwH7lRXFEUSaPsxrc8s57hzDnGnfzoC1lX/Xd7sqi8DgykH2iVxOMqdOy8neqxAzJlDmufMX5XXCqEs8ZxXlW6cppCKwXWFZ5dLZ0iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4XatUr19U2rhc9KFECrr7ehzC1Io+crL5/qnLydGs4E=;
 b=Vq4nAcVVTfx8k9PGW8UdyPl0JfOStCfyD/GW2QhO7U4+seI6OpGoaBLsA4E1bPRDNAy7cBObAi5tQwe0Gjlq5S2Ov8iJfykBJKf1VL+flTtTkTcGpVq9DP0oMvbro2Hsc8CbyOVAPUnTlPmvvBTErFlZg/KO+b7yJUIuxfFUbhv/mPIsoZm9T4feTC3/4uy/pafz9JFA9bJF513NNb/9noLlC0GOztpk5XCnycPk4P3Mw9BT1tlM8KB8SetVjWJx1yoUOsniachUPwCPOZOsrVdvo6+M5gqMh/G/A/EL0KQ7iGs21Dm7B5svG/fS2RDIPhbqZRkfr1ENnL3KUUF7JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4XatUr19U2rhc9KFECrr7ehzC1Io+crL5/qnLydGs4E=;
 b=YcHT1zFn7frGhHv0qq6YN2RNNrjpeaOeYZ4tHshd5WWQYUtbH4ZWZXeQ+LnfgQlMyr5YIwsGCElaHnMwwHz7GXaDF1YOBlHyh186FbQmX928nMr2XGOndi5al6URgGaJI+w9yS8zgBDpkd30LoH5QEXiKBUo2pgc8IWkzgbjCnhO1g0XceeKewMXM5oaDbytABpA0GsEQKeg2mGodR6hXVJEiaC3xePOxwxEignsnRL4TlXTxEP3uoquiDGHGjoNbop+/sNSDIZCibr3YnQOUlyPfr4x27DD4MyUfjzjOqh1A4L6OiDP2z12vayoCcF4o+PtHmToYV2jQeY/LCnXHg==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by PH0PR02MB8488.namprd02.prod.outlook.com
 (2603:10b6:510:105::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Tue, 23 Dec
 2025 05:05:02 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:05:02 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 08/10] x86/vmx: update EPT supervisor execute only tests for MBEC support (needs help)
Date: Mon, 22 Dec 2025 22:48:48 -0700
Message-ID: <20251223054850.1611618-9-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251223054850.1611618-1-jon@nutanix.com>
References: <20251223054850.1611618-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0018.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::15) To LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV0PR02MB11133:EE_|PH0PR02MB8488:EE_
X-MS-Office365-Filtering-Correlation-Id: d70d3420-0651-48fd-6935-08de41e0d403
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|52116014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SxZjCCrAso9KCaJsFaXirQffSC6pPZpBVcUXL/6Sgm/As1Jfm43GidesGM/z?=
 =?us-ascii?Q?fAXOmQa2Zaqof6hUMhzHlH1Ylu/xXk5cDnu0Der2XfOfagx5U7dgq/sUx7JP?=
 =?us-ascii?Q?+TuDrFD/35FmgzmmzUfI9sh3y5vW+/aPsTn4d7oiRBXNR0Ql0z5Rpdb3qHQq?=
 =?us-ascii?Q?w7QslK7PE00SWB1qmE2HE1kUXo2q4YldEzq1lcV/moB7u6RH8IijCAW7b5Bw?=
 =?us-ascii?Q?LscKwlyfcbqkNmATjzJstgmn3gzS+9RX0Uk15kMMqNRPWbx1lWV6Y2WZRDWP?=
 =?us-ascii?Q?SjCKzRan/2HvZu6YcLWFQGywaZl2EvX70KRzcMulh7Uj2KcBlT1Et3Tx73yc?=
 =?us-ascii?Q?WHGFG8OW+cIGKJ/inmiDGu2l8aMWR/cAhzQrmHiA+aDUqLgxUhqBqEfUxSTn?=
 =?us-ascii?Q?T/40PuOWKLr/yH067S7N+V+WZrpUMgE2sUw6lJ6dXV0ZV8mPYPBLIwlzz6Du?=
 =?us-ascii?Q?62b64tndwcWnIwwFUahuVTMB1nVEyFTgUv7SMEj22U0LMyCmzq121fOROLJd?=
 =?us-ascii?Q?Hd5c3akqW5xw43zn67C/rhYm2d9ZWg7cmzuph6UR2GKPsDbaqN88T9IW8wWz?=
 =?us-ascii?Q?x/o4Lh7pkP8e5cRqttT/7HRAp+sIvDkFyehDrIBsiWgEdHD2+MyAKu7mssb4?=
 =?us-ascii?Q?u0EheX7dXRd5JAQ+xY5xp5a7pRB5q3uFxk7fdpgtqj6+AQreJw2mBvPmiviz?=
 =?us-ascii?Q?EMF5/XcizTapzSaW+z0JIkRpRj9w2U58aeLWxC8D2Vaa5EyAh0nILZ4/X2IT?=
 =?us-ascii?Q?lcRCydKOmgs5s2NQlxqDA5499JlKl09VKBUGOyYT3nqecf80qWbnSQWB5TEC?=
 =?us-ascii?Q?r8nkmyk1T3vRXECAZeBLZ/sTqHB4WuPEaPLl8UQtTW69TiZ47uFu51UMSbl1?=
 =?us-ascii?Q?ejI9dOndLwxdjwJHmokiOpCw4qp8UFlZmts54QEADiR59yiWIoasd7wohyP2?=
 =?us-ascii?Q?nAj4u/TphLHxBK9X1oKq+ZFn3JJb2FPowuL7AJil+l2Zzl/wgF+NnYKV1vUq?=
 =?us-ascii?Q?gzHauTdFcfXvGl8aAm6Mz9kbJ2Vj4Lk0Va0AxSkMIXBIBO8bm6eUCkrj2NEF?=
 =?us-ascii?Q?QVgBBhQe9HPG/dtDHlWks9joZ55jvZ9gJ+xFVaNC5Le9omeIBDp7/ylI2xcn?=
 =?us-ascii?Q?gtOU5UIZY336m9T1q/7WyxUivtxzOsKu0MYhjdtn7B6r4Rjh3vWZHSRHqkr4?=
 =?us-ascii?Q?C61PhMoiTC4IhdOXuW+qqh9wUgxgTriJMN+BK0/C96FO2UuhFviO780zqFqC?=
 =?us-ascii?Q?8DsnTaW2TPdaZ9UGUlBqFxeZqeI1jk/jnUoq38MisrxCRe9Gp9XOa46pdZNd?=
 =?us-ascii?Q?ysGq1ZE+bbzrtkAdEvZSjgsfAU9M1EScR1CCxqTIKAQsqzyIoNzjMr752F6f?=
 =?us-ascii?Q?F6iCiq/bo7GEnfVpwYSfNpsMFSOpPb59jQmmbvLNO3OGXVPN67ZrEXDhuvJj?=
 =?us-ascii?Q?RMSXe8hcLypX0XcK+bVkAtxwr2OzCFpW/uxCNNSC0ecUeVVh6Dc2CRrqdbcz?=
 =?us-ascii?Q?mavbto/HmROxNMso2eTPKwII8Cwu42jbqzfb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(52116014)(366016)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e6NvpEIiXHPblNnGf8VFmuif4C7m74ofPYRS2Pdr+1wShmpd0ie11znyc3Yn?=
 =?us-ascii?Q?Q/2ZB8417pFugTPssmXRcBJg+hFKJZ75joThGp718oqq4uCmMSksXMwd8X3f?=
 =?us-ascii?Q?GsRXcn7+VRaRBsnshzypWgpurLm1NtqWBVEJZ50l37J+IjPLg8XZTBpaA6rO?=
 =?us-ascii?Q?6jrynC5eGiDP5na1x/xv7FmuMDjsenAyoEIjTq0/n4SeLpJDYHPXWBVk1sw4?=
 =?us-ascii?Q?150JLAOb78kHTvtz3R+OImUncfuqb3BAFv4RHujn3nr1bn5SCSTfh60kcJI6?=
 =?us-ascii?Q?9RuhpKrynDlwEe3GeobLEr0BymDNbEjvHcMOUbzqFCuZtAny41yUUQIZQcSq?=
 =?us-ascii?Q?j7kN8hU/i67F5XBeUCLs1i1mCnpcY8t/SGYO9/ISRsXEr1RcrVOI1q0xb1+v?=
 =?us-ascii?Q?H5CmECU2cSKgVmzBNHRgWV1DvsZjVveTPaqEWjP8wG47IASrhLmhIzidGtS0?=
 =?us-ascii?Q?4fkVVvs8wKTX/e1ux+WUnAkMwY5Hvf8vrbfvmHBpXqC2H2xMSOhWXmUgoWtp?=
 =?us-ascii?Q?2nhxOlO2a+/rKBg8H4/ZtZ7huqiNWRmVxneKQBRUO3gB7HTQaB8A5lzp3TMJ?=
 =?us-ascii?Q?6hVZwlFqSjARhddKqPI0aDTwvnkIxLrGfOutw8G5H/6XQ2LSDPv9Xcw+gMq4?=
 =?us-ascii?Q?Seo8F4u1iRyfL5mrfGsIHiSPkgUSfkqoP/cF/0hocR9ir7IeuYW21rfNBWIM?=
 =?us-ascii?Q?ieg4jpV1xD+S9093mcU3q9/cvbqvbdDmIRft59AZsMCY3UkuVJ2SYPLpWibc?=
 =?us-ascii?Q?AraYGAelwp9P98ppb0cH+V+Ddl41Z2lUoMedBGsn0zklK32jPR19tVIfp3PQ?=
 =?us-ascii?Q?oW84geVIS6wcAQp2vbk65FlBYQRSjH+HO2sVBSXsPNQoYqN6z14/Kz5MxP1+?=
 =?us-ascii?Q?5+11+SumwkQ8nZT3cF0Pu+WizYP8BgocUfVYTr80SYlXqekMq64GT2Nht4PI?=
 =?us-ascii?Q?nMEwPvwaXkUxZkupQqDKIYLN8UFHpLsp90Or6zJCQbQpTwzHRzzrGOQFn2kY?=
 =?us-ascii?Q?Ggdb2L54q/2izDMFb55FltxcmEbSEUKVT1Nr8E/8YXBQ8NftinG8MHvAIjhH?=
 =?us-ascii?Q?y0Qx11IHU4lRQl3bnUu2mwQtMctor9bzp0RfgbP/49fVZs1MWkO/tbCRUzO3?=
 =?us-ascii?Q?mLHB3oZYIwYrnWHLVTg5NNC3f/kDPNrPMQbu9TifqyPmMzmzbNUZALTI2XXF?=
 =?us-ascii?Q?DfHFuZQMf1ENs7tavRSN6quVnkPCsYGnBb6HFe0jZ8wAHSkBlFxkRy2Ry/Yn?=
 =?us-ascii?Q?vVup/4jrQxw0LZdMuOQAX1gh7sg+LuxTHVLTKoXCV0VvHDZhfvzdJZZyK4L6?=
 =?us-ascii?Q?vqD1ai6FjjDZ4uTb1N0aLiWruEEjHw1weLZRAS0aZlnqylTgUhCeROcnp/Kx?=
 =?us-ascii?Q?hjxBLHWYYT2BFFEKiWei+ju2IbES8a0XihX7Idv9QoPPK5dRAVnhxtFDszuN?=
 =?us-ascii?Q?yFtHE6tIq49EV0J1nBMsjkHgjD8lFSTRiL4QyVLFN2YsrduhrA+Ph0HwI/+P?=
 =?us-ascii?Q?Rlahkv8/TDWpVvCRLmOO0Xgp94iSus5jzxoc/S519laK1BfY64/iTUs2GPNf?=
 =?us-ascii?Q?WyKk8lBpqELJveuqqAdgPVPJsrI4n8wPZTHoGlXvrNuv35b7lloGcjIMUaf9?=
 =?us-ascii?Q?kP/nAK54DJBS1p7UjDfEiIvmnzjzjhv2fOu5PWCvwjbDU9YZQA4+MbVZpbvP?=
 =?us-ascii?Q?BIJKVEjG+uEaJmi251jAAeQ+/oRZ9qkziTrT6+9eNR0DQQYtoQfdvEm6Mp8j?=
 =?us-ascii?Q?sKQ1VP2K2IRDv1q+PQcF80o2/vHysTM=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d70d3420-0651-48fd-6935-08de41e0d403
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:05:02.0056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IWRLMwryLnNmlJNmXejoPsZUm0HGY/AZycycixUzlUVpFVbVkaZ6mzhjgbrkuNhPIWnnztO6wwinzqgGsHJ5ChkNmbmz1IKceQfjtFr3tFc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB8488
X-Proofpoint-ORIG-GUID: BjZIFsJawXYlSCX_qTebPhDMJO3xOKm6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfX2Dt9Y+uBpkUZ
 Ye95Z8T/IbipjA6SV28Iz0j+kK3oCocWM1QALE0oJ3+LacCBXUTXFWl9vanikDUXt3RR0AfeJ+L
 tfNArTZc2XXP2I+rKZ+PSzEb6QURyOgrugrzBKNb+vAUPulyiEY/KYFIqGvB+BvesfJMCSFCBuU
 Ykf9vgaY3H7PcLfhJjczF5z45vlg2TQpqz6a1iyYkrX7fSotewCuJ9moERZAMbny/SZ/gEGzN4h
 izOq2dwRgif7qLjQAVf4475g2RBO/TdiAL9Wema2Mue6TunbvJXF5zDu0ikZdxCAJoUlC1O8zQj
 FCp754E5eVKP32DbPz6P169oZczi1547/3jj48omcxB1krLmSFayuBHj8NlLzl3ILLRnqiYmsJ0
 Izpbo9RkZ16SkvPds8eXdF5BVdbKHMgmAK4B2mRGkMiX0h1Unkyp5ZQF3RR1SU75YP+9vz//TQt
 k4+pqDTin1wBpYrPj6g==
X-Proofpoint-GUID: BjZIFsJawXYlSCX_qTebPhDMJO3xOKm6
X-Authority-Analysis: v=2.4 cv=MrxfKmae c=1 sm=1 tr=0 ts=694a2300 cx=c_pps
 a=cE3fiHRxMl4nLvvI2vbFbA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=64Cc0HZtAAAA:8 a=eDCt9oOlNWnZb2Eq10gA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Extend ept_access_test_execute_only to cover MBEC EPT --x case, with
the caveat that it doesn't actually work as expected.

Need a hand with sanity checking this, as both of the commented out
test cases produce a tight EPT violation loop on the kernel side, and
I'm unsure as of yet if its a test side issue (setup?) or what.

Tests pass with both -vmx-mbec and +vmx-mbec (for the case that isn't
commented out)

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 x86/vmx_tests.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index e869d702..3705e2ca 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -2856,6 +2856,14 @@ static void ept_access_test_execute_only(void)
 		ept_access_violation(EPT_EA, OP_WRITE,
 				     EPT_VLT_WR | EPT_VLT_PERM_EX);
 		ept_access_allowed(EPT_EA, OP_EXEC);
+		if (is_mbec_supported()) {
+			// FIXME: this does not produce the expected
+			// EPT violation, instead we get assert:
+			//   Expected VMX_EPT_VIOLATION, got VMX_VMCALL
+			// ept_access_violation(EPT_EA, OP_EXEC_USER,
+			//		     EPT_VLT_FETCH |
+			//		     EPT_VLT_PERM_EX);
+		}
 	} else {
 		ept_access_misconfig(EPT_EA);
 	}
-- 
2.43.0


