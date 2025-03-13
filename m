Return-Path: <kvm+bounces-40995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 02575A6021F
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:14:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09DF219C553A
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 684231FC7C4;
	Thu, 13 Mar 2025 20:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="f0EUBn/W";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="SLsykAG7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746D41FA851;
	Thu, 13 Mar 2025 20:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896647; cv=fail; b=Qj+7oLVM5d5aBNyU3nCSg9T8S5VPVqV7Smk0XPtuf7EgdLiJj+ricn9EJTs14cPTAv43xjjMJzENcqhmPcLIrGbxvFS4yQ/eNDgLdPaaMvxZNTj6V5KpbIFj2row5zAXLxAoZ5M2aYlYXOMLPq3oL34JsPQG2LaNVSzfMUQ3y9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896647; c=relaxed/simple;
	bh=9MwHrfVMNjULF/8fMS9rEUpOSYn2+rlvEO/XHzwNqXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y580JvL1e6+cLUhiAPlyPLNsUQs7tENeiniWIZfkfE3SadENICoqzDcXgTfKGMuOPqhFn/NOkmI9Pzrf5rq6Opwy4jIUv+uxMntNDR60z7VxKiPm6WPoQs4+Je/WGEGvs6fvryFW5IJCqs4DvGW7pznz+3iCA6Q/L2tFnFAFqfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=f0EUBn/W; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=SLsykAG7; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DFSGj3009058;
	Thu, 13 Mar 2025 13:10:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=7mpUmj73o8MtCeMUZ41O/ege1+Ol3z0Dm5leFevXc
	eA=; b=f0EUBn/W8r90i39wYZdS73hZ8/KSx0Weg5nApFgG8Q7yGZY1V1UcD1sc8
	djLx0zs0m15aFNI1LY6O/Q7VjSQKHoIgNsG8u6bqkiBfxOrq9Np+LaqT6dpP4i+g
	IDRhnDAkkEnegxLQxYKMtVTkX7HCTBUyBcCCWfwRTc9JlWZaVy6dgWtekCcPkEew
	E4tc8qL+ywl3cIK0AphSbtZ0csGGrWQ0jGewy2OVFpu++utnwcwB985hBoN0Bm2U
	ttdsOozTmD5NnSQAMvXVW7fQe7VGYihvNosqBfwEJIWvDFYAQ2b/yK4o6xh69Ew4
	3jPWo8gaQc7mh6slL3BeEPpJ70+KQ==
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45au9g67ja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 13:10:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GjxIZDl1Qg0oyqKkCJXpvPRKzG91WKwYHK34GN3Rl+MNdJn5+HYPAeT4ZA71sZWcpWUihxhWYn0BInAOk0eOAffnusscvCHmVKPqJmExfz+hcNJIb+qeyX6r4E8ymjV38HlD5VED5KN0f5ZoIPtemN0w1iJ/5E7YJvtwj/HkJuR8sndoT3yuPdcmoIxPCDbctHCup8ReVONXf5j8Eqv6deOcJKBMIpUjANWFYnTy8nQ5P45dn0kNrQTlY0TN92lRR7S3wos7mSrXS9cMnuukE7bjy26Zjw5/yGXextyuvTlgzahD44UTSUbwkoXgL2J5DGEGyKJd63JEKRMKAgpO2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7mpUmj73o8MtCeMUZ41O/ege1+Ol3z0Dm5leFevXceA=;
 b=sT+wTZiO5dE0f4lvpys2fKhy1sxbdb+Y0jYM4idNsG6M44J8/WaOIdFt1d0ThE4Zf2Bqfpnuo9pIvXeylB9+IwiZDXfxpV9QuWjOv/yoDO9B4eAbONsnXYTTqWPV0/8sNvdYJUEreE07JHCqJSl2aNLLZDdyQF4Nc7oQ8d9a3nW6qcIZ0ssaH8LMPGrxjtzYWEMvJMID6cIct+/AzvweI9g3kcvK/ev1GU1nW9tfN4asEqgZ8TcHiRr7h1hHQZQOyRe6WLP6Pw5SuNxYVlFIq9dixlDx5IHzUVASvzo/1D+PfyL3BOJF9mQQqb0/hv15U9UI+bYSFediiILQbQJr4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7mpUmj73o8MtCeMUZ41O/ege1+Ol3z0Dm5leFevXceA=;
 b=SLsykAG7P+aGl4Pgpa+tEdChrwD6+uBtp4WCcZyyGo76tZVNawvaNpZRCDA7b1160XDpKcxTm2mFJZGp83Ov2yZO/xHtCasszGPoDUA7dV4LkJDvP9jubURgXY5/skq4NQVDNeNMzqe3tiU7t/TQ1Y5nj835aim/PnPmzjsVH1LJTwI6wjub4s7TZejzQ3tO0gwVX6mtJ1VifHH+gLt7UlXTatgWn2bAgtUT37vlkK34oDYUyNbG+LBUReA9g31eV1hm9moagU1muytBcrCoHqfvq5XlvHLM5YsvU1T3leSHD17MeBliIeml1K3gPn3SBPGM+FRem6teHmnJwE+4kw==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ2PR02MB10313.namprd02.prod.outlook.com
 (2603:10b6:a03:56a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 20:10:25 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.028; Thu, 13 Mar 2025
 20:10:25 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [RFC PATCH 10/18] KVM: VMX: Extend EPT Violation protection bits
Date: Thu, 13 Mar 2025 13:36:49 -0700
Message-ID: <20250313203702.575156-11-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313203702.575156-1-jon@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|SJ2PR02MB10313:EE_
X-MS-Office365-Filtering-Correlation-Id: 52cd7046-ba77-40e0-9d60-08dd626b175e
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|52116014|376014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TpdtdFm/m6uD4p2mMPBWs7jRnAZEdcvk7rjhs2KQwpqsZgp4koof3CH1ef7S?=
 =?us-ascii?Q?45Y4QHeh8gn447wystTQTQUUIIttTcqQJ9VjNfkqMazz2rGv06Bwfg1gC3at?=
 =?us-ascii?Q?KiY22RPyrOFIxY+xZTkzkg2am4WneFKMfpeLPotUPdv0r+zuCelCYZjbOvjX?=
 =?us-ascii?Q?hgSyUvAygICnnSWvyRJ6gtjPRI/x9KLKZfl7QgsdeWyj0RW7Zgk68uZO9CwA?=
 =?us-ascii?Q?HGrjvywEiAZe18mmdVnybRTCPwXMAYd+OYd7waSZgE9D59C3ffHmBgSMeR7N?=
 =?us-ascii?Q?PXQHUCwAGDS7AouCf/liTfceiC4lCMgrKMRtSFl6JpHDRd5BnW44gbC8sDCa?=
 =?us-ascii?Q?uwV6t+O7pFXJLQ022A1oq5QWplU8giupj2oME2zbmGpjefqRl0dEwr+gRt+z?=
 =?us-ascii?Q?/aHxBTzLoOP5lrtwjQuDNASfd021tt8M2L/ZISULcuXP6mLPHVtlTQ6FP5tm?=
 =?us-ascii?Q?sP5HV/mt49WgT+lqJUI/nCHvsxQCcVGYzBq8VdOsAMRMKmN3++OGxSzS8q4w?=
 =?us-ascii?Q?SXxjYeIl0dtaTsP0eG54L58G21E3DFXpZlrI758LjYezxDhr7jC7r3KGNJPf?=
 =?us-ascii?Q?j1DXZq0SmqiJQ7N0LrUznyLacpFOXrXltrQzWU1GfRGuZGE1bFHsarsllia9?=
 =?us-ascii?Q?PnOA3GsuriSYsL49F9UeqRvvDdYDNcLtTvAIUjmINjo72Cyw4eN4jrUPcTSy?=
 =?us-ascii?Q?yIukkdMcI+OO45HGTCuEGk4G33rmamrnzdIB04oxGzA/U2i6MtgbCuKOL7Dq?=
 =?us-ascii?Q?tnlFlrDlclhl/qmq/PfCTTR+NPs4fWztSF3aqilHcb2JSP4m+WxoKTbJf2GJ?=
 =?us-ascii?Q?KgerXmDSZEoQHBY2UqTQgmQ0z3oLuU+TT3D6L1KOzHelPS0L6C5awla0Fttt?=
 =?us-ascii?Q?m1STsdk40/meIuZG61te1a/nSk0IIBEXnmo16ONeIcET6KdRgcjwAJhpiaPK?=
 =?us-ascii?Q?3wS0r9HtjSKdFXQ6pibwmDhSdIKsbElqaR3srX3BjVNXWPgXR/BCC/n+D8pe?=
 =?us-ascii?Q?0gWqcYwDoggGHpQLJOqNtMLtMv1zfwlCkmhT9YlQgbJq1hLa7cYzDKDUf58O?=
 =?us-ascii?Q?w4mRT6QehnY/Ft6/WDryVrPY7IDGByle9zVUjT3amjtu/8wSkt37iM1pljZa?=
 =?us-ascii?Q?i6K2DazHEyjg4CrX5bPjYCHb9Xeeeo4kNWgj0JTzc3usSVbwtEPBvwt1oglE?=
 =?us-ascii?Q?9ntXt1lsvzNgQeE33wLxuNLqKCLX3lO8yGa6hm5q/Q94lEZmJcj5JvliErKK?=
 =?us-ascii?Q?smHy9CzXKezuoWD5CEDeFxCs/ufLv7zLq9wynLH2r5lu4z4fzxSFpWb9X0ML?=
 =?us-ascii?Q?mi2FfOtrfw7TaNPV+qyHAH5gg+qRhKdkE7ZYqJVxwsCqPKM4K+scJuvy6irz?=
 =?us-ascii?Q?qPjFLEoTGcbZAj6kC7UzAwsb7s5IL3JoZN3f+XyM7DdCxlWhheRkpTuRFEm8?=
 =?us-ascii?Q?TDa02KPRH06Y0WjBj/3iGCm0nX6o6ew9ohQEG8pkkIvhfQ8UR2K82Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(52116014)(376014)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5CKHp118NCwC7DtGFt8oXR1sFsnQ3myUVcODj71j29S47xxmCsIzxswzLMjo?=
 =?us-ascii?Q?lx4UIegunu/HSyI865IXTz1n5aLxvRZg3+qlvHdimLNlnvoUvjFNkg+OgcN5?=
 =?us-ascii?Q?6BeqC0rF0J3u76luLt7wRy5cR5GFiOQOnRkMeSCAy0msmvQrWdtEmSvV2lkc?=
 =?us-ascii?Q?zM5fnY0NxohjT8lim9btwW1VKlPWy7tTXtiJ4Lp/v41jtHxxDnMHcvv9KArN?=
 =?us-ascii?Q?Afv0hq83CP+26MlVIQ4c3MZIcpwMDYMx7h0kGL4eleIHA+Z8aZl+4YfIUOB9?=
 =?us-ascii?Q?nZOO2TGJiUMDRg9gnDLz0OgwigpZXN7x1wDsqHGia3UQXFtDp2peV+Fk/7xa?=
 =?us-ascii?Q?gUFVo49lcR8+sef2ydaVRTD3p4E8zP8y07MXgxxe26ZBjRSy1JSi4rwbhjt7?=
 =?us-ascii?Q?RUb71vW9LXiAkaq+OxDBCWCS0vMwXtScaZa2fZ+rBTZagUqcknBt7vDcAiTT?=
 =?us-ascii?Q?LgrwCcyzRFAOqvznuxl//6Za/4/WsE3s3wdWJbzq+0U+LIGGwhyJjjduvImO?=
 =?us-ascii?Q?wV4rgtAshbPuqhj46PpnBvL41PMVwcqMhGJve1bnL/inuQPdjU0Li49X9gP3?=
 =?us-ascii?Q?0XdcVgBAeOsgPsibfOM38fBeQ4qGvjkS9M4swqSgzxBmY2Bt+x45u0WL1Rth?=
 =?us-ascii?Q?Qb5DYtNO89/ux+DGJxKHFne/xsQ7CW1mLB2tWoucOfRpIgbmfKyZXgqaOy2v?=
 =?us-ascii?Q?bSX2yNpLj1iEdfa5VkHF/rmScLldZWfVVGaMVIs8iZbCxT4DXoJucpUPPbxW?=
 =?us-ascii?Q?piJLUGa1CN4vt0rsxCqVW6WDAYFQ6ZGdZDe60F9HCVpLydGyuYEc/0Xbe3kp?=
 =?us-ascii?Q?ssqQ8YFPaMVRHlPaCv72hvZJoOv8bUXex32h+yUD3iFASBUXTKGXMMSpYrR2?=
 =?us-ascii?Q?EGi4EuM05q6sdlVfAxmCRGksFp7NfqArUaIZgV9jbltASYn2v0RgjqqsJyIR?=
 =?us-ascii?Q?44fxnnRxrqWKbzURxkoo/XzJOTKxoeoNsdvU4ml/YoHfdmHlB+dzeBt7QZ9G?=
 =?us-ascii?Q?lV/d/kbZGa0R2IqKu0W9iwJzhZ6VMN4A/BnQX8Se0NQm1x9/2FJBSKKmhRB6?=
 =?us-ascii?Q?M74L6QFf2tW95nUl8LZPeGr/8xfutxTOHdO31twrsVJyn5SjWc3Ztxjil8dH?=
 =?us-ascii?Q?USEKtCUu06ukSyY/VfJ5JX1JnfUZdwnaZ5NTargAVyg0G76P4Yyzoh9P21Bm?=
 =?us-ascii?Q?ewpiRYg0sPp6cGSKDS0eAy6I7YBE2/op5jC5fmVwbelf7VvqL+YaNtOkZDq6?=
 =?us-ascii?Q?jgzDykrYNWCfM24lrTzis2ihYet1cEGLhGDvzDIfLQQhSAgNwKVuC0Is89Wy?=
 =?us-ascii?Q?xV7wUcaE43uFadW7eX70vslDEBpRDAR9sK0fmyb1gT5UZAp76U3oHo5wPtJf?=
 =?us-ascii?Q?5C2GOXXRgerN/2U5PC0krEF3GBtvEthuuKFmi2xYuOXahNuMpMN7JqGIug/s?=
 =?us-ascii?Q?b37x0a8c3QRL5q/+HwQaZlU+0efKx4NRHiaxK/qbshpAsVngJ5WGBAf68zEX?=
 =?us-ascii?Q?J7RNu0iZ9Zluzi8Bj6jbf5syAKgs21trHkaPAs+5RPnGkqVf12PADFhjDQW+?=
 =?us-ascii?Q?omaRkXjxEgZnUjJOOt/GoyCslI1SnkeypHvtQmSeS5HMYnDVkoBlkjey8Ul4?=
 =?us-ascii?Q?LQ=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52cd7046-ba77-40e0-9d60-08dd626b175e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 20:10:25.1483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r+Ekfoyn6NQ1YmpgjG9kgH2aFo8GWisVArW5XpUK9MXoeIQeuQgrg88OuQWsYajI2UCVZQJcnp8LtmGteDwvHrBbZpFa7yVBNAeGY4VoUMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR02MB10313
X-Proofpoint-GUID: 7QqK-jzqCIq-IIpsnK4xx8yvpMB85WqJ
X-Proofpoint-ORIG-GUID: 7QqK-jzqCIq-IIpsnK4xx8yvpMB85WqJ
X-Authority-Analysis: v=2.4 cv=c4erQQ9l c=1 sm=1 tr=0 ts=67d33bb5 cx=c_pps a=oQ/SuO94mqEoePT5f2hFBg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Vs1iUdzkB0EA:10
 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=Ow9csONg1Gpis9EHYRkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_09,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

Define macros for READ, WRITE, EXEC protection bits, to be used by
MBEC-enabled systems.

No functional change intended.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 arch/x86/include/asm/vmx.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index d7ab0ad63be6..ffc90d672b5d 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -593,8 +593,17 @@ enum vm_entry_failure_code {
 #define EPT_VIOLATION_GVA_IS_VALID	BIT(7)
 #define EPT_VIOLATION_GVA_TRANSLATED	BIT(8)
 
+#define EPT_VIOLATION_READ_TO_PROT(__epte) (((__epte) & VMX_EPT_READABLE_MASK) << 3)
+#define EPT_VIOLATION_WRITE_TO_PROT(__epte) (((__epte) & VMX_EPT_WRITABLE_MASK) << 3)
+#define EPT_VIOLATION_EXEC_TO_PROT(__epte) (((__epte) & VMX_EPT_EXECUTABLE_MASK) << 3)
 #define EPT_VIOLATION_RWX_TO_PROT(__epte) (((__epte) & VMX_EPT_RWX_MASK) << 3)
 
+static_assert(EPT_VIOLATION_READ_TO_PROT(VMX_EPT_READABLE_MASK) ==
+	      (EPT_VIOLATION_PROT_READ));
+static_assert(EPT_VIOLATION_WRITE_TO_PROT(VMX_EPT_WRITABLE_MASK) ==
+	      (EPT_VIOLATION_PROT_WRITE));
+static_assert(EPT_VIOLATION_EXEC_TO_PROT(VMX_EPT_EXECUTABLE_MASK) ==
+	      (EPT_VIOLATION_PROT_EXEC));
 static_assert(EPT_VIOLATION_RWX_TO_PROT(VMX_EPT_RWX_MASK) ==
 	      (EPT_VIOLATION_PROT_READ | EPT_VIOLATION_PROT_WRITE | EPT_VIOLATION_PROT_EXEC));
 
-- 
2.43.0


