Return-Path: <kvm+bounces-66588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3111FCD818D
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:06:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5A42A30572FE
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A6D62F999A;
	Tue, 23 Dec 2025 05:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="cD43jLLF";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ZpXD1gkI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF932F3C31
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 05:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466304; cv=fail; b=M3lZV3YX046RZm6+9hueifDeWVTG4uKAnAuIQo+k37e0fpVe75+gn+k/DpBx42D5IXPkOE4ukJubX10x4xEWKaPC8C6tnOs43I545cBYu+qYuG5/fF+zcXiAnXdWsM4fpL1b25Avr2/pD1E/eazGcwvFyUK23Bg35tO5t4f8e8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466304; c=relaxed/simple;
	bh=OfTdKq633ux0NXedgF2Uc8XjT3mdfp5ZM+2ECPyjflY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P2GYyotvsJyVVBJ4Ox5R7P9jftnnVhNuPxV/56alsGP6Bcnm4s2TWKN14TNzweWuoGB4NDX+/kiDo7F0Ps7yhIToP/3ST9aKKvFmbHC8IJlDrTuGltYCRR94cUMlzYxYynx6nLSnrDy7Y1OxJ/1gXYMM8nAQT5FqFnPB9JRtilQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=cD43jLLF; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ZpXD1gkI; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMLNNoO723792;
	Mon, 22 Dec 2025 21:04:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=yYllDhxiGqDnCuUMXBYB3tPhRH5KjWGAiObRcHaPV
	Gg=; b=cD43jLLFC5MBOlokdLDYtPoBUteSqSm10fy6rirK1nG/IXcYwKlcmWIgP
	atux+VzXNE0JApJDwRKiSQqUsdJHOEl+3efsyHqF5i1yF71RZAxVJ0nVmQrQ/aww
	Ptr+X7S4sakXvpSmHzU19JPpAhYkKHN+fip5gcy9H6Q/Ah9Tou5pTYDP1vAj6WnK
	s6wlNhCOQbbez1i3cfQ6z1ZFPGdvaM6EVXfIUDd7kkUDH2jSWdFNHqNEpQpXxIAd
	cBlxUMKOpDjv7gsdBzxj+rsL43g9mb0+CR3XPILvTMxkxtBz6F8rCrmNf8oDQeJH
	QPu3w5E+/VR1wAHarO9eUVyx6seKQ==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021103.outbound.protection.outlook.com [40.93.194.103])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5tsjmwva-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:04:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Om/C9UqRGKmdc2Wt0rMUFNiOTSG5Sx6lO8FUtAMXumy7HZKjo0qHaQzj5nelDr2ZqCjwIAvkQWMekbDMAn2g8MoD3QKFqKrufTb0iA5wyxPc48f7+xrMoxFAypknio8h86E/E6ujoaF2EaNxmG6GprR0PtylaaZ2R1zDAt4FLS2C4EJSCZkHIaqMYqVk/MLuDZpNHl9pel1WaxzIHttJzMMB9fYw1xiufpqb4TyLPeVvAYhqO715GxyRdXgVAOB7M5qoherlXy72F42SFqu7ql5qZyjjtANd9tX7Q9UCnpeR4TKczqhkL+bn10YxiONVYTUzp7z3nPnnThIrBFMY5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yYllDhxiGqDnCuUMXBYB3tPhRH5KjWGAiObRcHaPVGg=;
 b=rby1uY2SVmYPckYuqBdKeoQH+qcVfVHQz3gd5qnCdnEPLYwVQ8+IUswk4uZp0FrZ8uD5XRKNtqSrRALdxC7FY70aTGZsBNK7O0FGO901czQ1iHIgNdUmokrqnF6S78GxKyd8+thyEFnj1hU6xqUW1WwL8I3QihOLOg/p6bNAkmqYSzl7P0W62sGiPYz7ZVm++JsQexLLV5CzRZZESfEmMP/khk/sMeaT293y5Gd7RTQLNkhAb9JjnCRaY0pcrFVCZ9+pAS1FfsND+mW8OSe/iE3cCvMbOi+NfOVNSqBX8aTAQNUDDZ4Z6iwCBbKI6e+ssSYS25iijVKgbjulcbGR2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yYllDhxiGqDnCuUMXBYB3tPhRH5KjWGAiObRcHaPVGg=;
 b=ZpXD1gkIUtuVXQAG0wHC3KRpIkCDr5B6DldPr46cHiy7y1Sw/EiAq6EjGeidrwoi9bCkrFq4/yUh2HFWtLkckdLtXfmJNkhl4mompgu79RURs+7eJbC7Zucu7FLG1zaumm3Bo75/y4u93GlpxM6uDU0ERiDFOUaQVJHc6ish2FcL+8Uvd2VsQHHy75L2B1qqal9Rze8l05UzasvE09rYL6iWhqNMbhQr0dZ9LztYvrXCpO82EO11mIPIKbCc0gvj8jZznU7V5JqGSURFoFrAx24KHF8vw8wYek0ql511ExfUO7rUtjKT9ufpWi/dsZFoa8t5PXpAlTkhIlwqbogabw==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8560.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 05:04:58 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:04:58 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 01/10] x86/vmx: add mode-based execute control test for Skylake and above
Date: Mon, 22 Dec 2025 22:48:41 -0700
Message-ID: <20251223054850.1611618-2-jon@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: LV0PR02MB11133:EE_|SA1PR02MB8560:EE_
X-MS-Office365-Filtering-Correlation-Id: 1167ee1e-4dae-4cae-e22d-08de41e0d19c
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OnqKMh41FVXJ7rJN0XbqneTLOXGeQ6MejqDDUk6mUtX8yOw02FcoCh0rgz84?=
 =?us-ascii?Q?9x4Lm9iyOM8CLKoOa8I9UvzCiDzQBUp+AdMB6KRfYGpxMkbwreFxYemlxkQz?=
 =?us-ascii?Q?81Q6Ni+Dj5XrGa6l+2b3HmHFznlwBTZGAb7F1IcOrmVYh8mS5C9V5ujWOFbQ?=
 =?us-ascii?Q?wpUZnLEHu/1EqzC4FRqXlPDM2ND0BsjO0hD9dXka2cYq2N8FntHUzPrrjrsy?=
 =?us-ascii?Q?J8FdENjfa69PD8cSuzDtQebgllE1GVcpz6YPLRDz7nAmMFOoq+kgEdji9YeD?=
 =?us-ascii?Q?lPbl4czQfpiTYrNlPPbQct2bgV0GPRrqaF7++whctI5qZ/immlRZjbBXG1Vn?=
 =?us-ascii?Q?ZXZNrhOX4j3Kyv6fjkZaP/jhSueFAKBdN+6yKEDu//kzh3fqUajVaDMdivPU?=
 =?us-ascii?Q?jQapWcXoASEuFlPDpWm+7Y7jrt6mrrWPtPxoP6H3RztLqNWq371mxKEV8ejy?=
 =?us-ascii?Q?uwO3FLVdKj4PDxCrkBM9eU+YskPBmvOYpmk2k115zP7W0Hh/7qwm+ZNyrQEz?=
 =?us-ascii?Q?Po14vSpomf3AZVae2+Ye6S8Zm5gnFtU0dmFeIBWbORMd2gQPL8CeuvfjJ0Eu?=
 =?us-ascii?Q?xnuJgS7dHvoAU/aYkBx4Hy5BuVmyU5pRsOX0ooQbIesXgLmnD6MaH+5sQK63?=
 =?us-ascii?Q?Cm05pkiyUI6yl61GRPkGJAitIbv3IBJ7P0AlJUaFrWUXHlI8bWCGfql8IBAm?=
 =?us-ascii?Q?kkMNadnWmg+TgTfrepdUHoQwHstU+WDAdPhsBUcNUsuVOOdLWZpFiKPOZjfx?=
 =?us-ascii?Q?HY2DK2CA38hnXDiyLYBOmqDyXi0xi79LD66I0HIkEQKwCqMMF8MJ76panjQs?=
 =?us-ascii?Q?OYCOpj90cG06F+pcOd3nyQj9sz6hLlVE4sxdAlC8tKSSORwjeb+uqYzcVilX?=
 =?us-ascii?Q?Tce78+3+8dk/xRm2/56Z6bgbNbJP1pfOrG7OFpmWWsEi6nJaDCZhEoZwyxxh?=
 =?us-ascii?Q?ztElNoYpCDYlxheqMJpKbaeZtLv0WCmyCm82ACMMBsUfB+lRT9fhhYOvVW+V?=
 =?us-ascii?Q?+Uj7rG3cXb7C1oHso/0/GPNa92XUPBwwrJ8ckFMpfn9BBD8ahEfVks0Hi/l8?=
 =?us-ascii?Q?YLpGEf4p3cDAi+PrB0he7JbAZ7I3nKesQH7ElPGfLX6Mt3Q7xoIof0sgjhtc?=
 =?us-ascii?Q?Au0Ka3iCyEOeBU2DGK3uoiwABO45Llqrzkqt07Zb3pcjFOfAsqt8XWs6MHo5?=
 =?us-ascii?Q?Z9d3Zm889TIo6BJKoodZeBPEHE7eEx4yC57A0AU7wcVt8QGBM29jy+EV8C+h?=
 =?us-ascii?Q?x2E1Kj67a9oQL1D0NgzffNTCavY/rGJciBmGbquCf/tE7lcGyB9M1IbkcRcw?=
 =?us-ascii?Q?Woi3PpGQu34DEpZSuFMgHfu88plsVZAx6F1PzssIydHD9lamrWqx4sRflfCf?=
 =?us-ascii?Q?UT2NGsWxVzvcTi7l+5cr2q6HLCLUlwoEviMtWJMqV6iuAStpaX71klrAzKA6?=
 =?us-ascii?Q?nl03uL9WKGegGCqSxbG3U7fZEpUCuDeaoKn+qfuQ/4HbW93Dqxk4iOrhS3l1?=
 =?us-ascii?Q?2xBGbpzGhGpiJaSRI7l2YapA/sQeofv9M3lw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(366016)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SIiHRGvPxg8EEdoQHaFtd3fEsT9kyl58gsD9jnOFgsTN4k8qOABYkJGvJpdF?=
 =?us-ascii?Q?AoYZeApwbsSvjBaybG9lL9/03X+NwhiontzYYKCDe3IXL5CReQHavsSWd1Jd?=
 =?us-ascii?Q?gkPnEjixBnUYSNyebdnsRajHc1Sxfa2Z6WgG9r15h+LyJ35cFySS0O9hD4kY?=
 =?us-ascii?Q?zSCCM0cziUVBwiCZYFoVIpQlcZwLLPrH9brc1cXCYA5ZKeRXD9UnVeCVoMx0?=
 =?us-ascii?Q?Kag09fSi2Z2GizrU24hdkm9NRuR6ta78Zx7ijq/snEB0pITlbAUOAUjz5caV?=
 =?us-ascii?Q?dqMzK2gcYozfNhn6vctQdM38udJr9ffxaIcbrCiEZlFwk6S0pGjlc1rQMMkg?=
 =?us-ascii?Q?2g/Y4BlozDmW2a38kDbm/fcKGWyTVE9yF3W6FjgsO+jCyn4bDuNJtvNV0MSW?=
 =?us-ascii?Q?pg9Uo71HIfH9gC40kYD2XKNej1Xyb6Hr3d6P2C+91eTVknMTvTOX5lbTReCV?=
 =?us-ascii?Q?UbmJ4HGa5wqIShMdnIdSkFpcsKCeb31VKpIPss2oFJqUH/0kZwktZkQrjWUF?=
 =?us-ascii?Q?qCuoYlZncJviNA3Ij3PVthtA6/PXu1BkHbsfl9J60Hz7e0DIvq6Wml05bIns?=
 =?us-ascii?Q?lOHcRSF9mmp5UBScBFs+OpXXdASU5umZ7Yw+jxx7b+ly+BnylYgiKlnVoy8F?=
 =?us-ascii?Q?A8hM1PhkdBahu6Y1Vz5koYj92+1t271lpQBds4NGCI6bpzyrBeGBjGVaRKtX?=
 =?us-ascii?Q?c17GpiGoNbnBKgbwkdsnVcv6sxzfrLakj4jQY3TU9xGusM15qtncAySh1XVQ?=
 =?us-ascii?Q?D866zDnH4xQwgNn2O8AdDioTr02Ry1PzeHGNg6pEW0JhGJ34LWXUg78ccGG9?=
 =?us-ascii?Q?fwmkLJNxGKJFI/cngZNI7tHLZtW9/LMuNerRQ5pVxOgzhh83h1tlNWoyFjfb?=
 =?us-ascii?Q?l105+WxBKa7otdkxejQhCc3syaV2c211XF2a4mBYwV61AVmwGtvAaHT9ZYas?=
 =?us-ascii?Q?NXP4xA9L/jBFX90/oCPeBRLZ2HeAO2ZJFKRcVGF4lgQVsIPu3t5l/cq6mmf6?=
 =?us-ascii?Q?/9huJfWYkT7+lbNwVbCfuSIFA3mbpjVE5+lj95sLTcrFHuqcMwz3ZG39nq2I?=
 =?us-ascii?Q?ULZ/iOi27g9yQhYamSAQUhf0GSI2w67QDLvdKvfchdtkCYQdQaJIQHBYQQcZ?=
 =?us-ascii?Q?h4kf0TzqxMEBap5ib7XAJ6ftXZ3H8PBWVpcJNGDL9mqWM8CATcQXamSRWsqS?=
 =?us-ascii?Q?bAFzr3wKzMyxwA2i1n6ihjEPrS/p4AMhnpobua85qJOFSYjlpgYwM1Efljt0?=
 =?us-ascii?Q?npGyFTFgYWIK6iG0sRHFr3fZSKeeFxgAZPgSCf3IIoRoC6hBv52HDP9JZnnS?=
 =?us-ascii?Q?HM7HhHN0j69NAY+Qi9N4w9DM1EG8D+XMCnqBPPzBIzVuPIy4ThMq8Gv8q0/X?=
 =?us-ascii?Q?RAMCAwT59tZ1rtL07hd28pCDFvZzJ/SAoe4UXqIGPxuOntFGcq6MoZbHzTu5?=
 =?us-ascii?Q?ldzrAVkAUg2/Grc4Eb/NCuWDden6+V/6nSfp3xDZbQ/D+quqU/dkSKCviJEL?=
 =?us-ascii?Q?OOp4SfezBzQm1dWAfNtQYvFmpOHtd6TRHKTfAYwL0D+/PMthAV7C91Mz6hkI?=
 =?us-ascii?Q?X+20nd5p4z8xi+wOtxlUuMTSyMjxrKgWk/JcgvcxbvEoVqcKMZlIzK65D2do?=
 =?us-ascii?Q?cObzJLw4nBVWtP/6893daDP8C7gYtW9zdLWVgcl3R6aSEC1K5eT4NWIXTXSu?=
 =?us-ascii?Q?22uSqJTo0ynz1RvE6oNYeJUi7e1Zj6Td0QAGrA3SZNlSZuPYeDqtwtdqCPuE?=
 =?us-ascii?Q?2ZDMi9UlzV+OOOwu5PDyCx1grTrRe6k=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1167ee1e-4dae-4cae-e22d-08de41e0d19c
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:04:57.8934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e7b2sKZ4wSCG3YugrWqt2ZML2kpDHox0xzlX6lNIIuwOfecTTWcO7rdpckkGhr5qCQPlBFRP8Di/CBIVco6btJxmV6VsPXOyEZzYQijlxgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8560
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfX0da0+Rw3bABy
 HgEEW8enygDohna0Bu2BIncI8gH4xpOuEQOLFZ8x4tjXGpcyFQdv5Im/uKYduhRLZR0r2D4jRLT
 zy3Uz11SZZQ22XZNefUUA1laHUiq9X/n6A37Z3WT5zY1TRjm9eyvZ6pJ8LZfYTkblFumT6nyoyK
 louP2pqnc1oOM5Bhh41ag9rZwvQqQNnOSNZkQo+KkaB2FLEwZPaBgoApOIk+CDDr7VGum4SGqHq
 o5DUtGDvZJpzfbhB2hsoIFGUi85ES8GvxrtHmqcgzYnX5Yf7F3YIP+/xIij+d5RjavrM20ijz+u
 mYMKarKDaMjbawj8eTWU6Qoq8OYsv7yK334gT60vL949HwN7OWl62PtyNrggXPAhH5mzw9pxVeR
 h9SFoSn601wu0k1QtEIYFTq1mHJ6H9fztZR/y0kfhtx63k5ZWT720KGKHR0TuqyKL/nbXsHDX6h
 3y/BI+q5SMPQjAFJ3Hw==
X-Proofpoint-GUID: M89uCCDfKFFPn0ikq6yNN_gbQhV1-J32
X-Proofpoint-ORIG-GUID: M89uCCDfKFFPn0ikq6yNN_gbQhV1-J32
X-Authority-Analysis: v=2.4 cv=Xr73+FF9 c=1 sm=1 tr=0 ts=694a22fb cx=c_pps
 a=GZ5nxs7iJwyXCG4rR3qJ+A==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=64Cc0HZtAAAA:8 a=zKBhIuo6mipeLcZBzDAA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Introduce a new test for mode-based execute control (MBEC) in the VMX
controls, validating the dependency between MBEC and EPT VM-execution
controls. The test ensures that VM entry fails when MBEC is enabled
without EPT, and succeeds in valid combinations.

Update the unit test configuration to include a specific test case for
MBEC on Skylake-Server CPU model, as that was the first CPU series to
have MBEC.

Tested on Intel SPR Gold 5416S.

Passing test result
Test suite: vmx_controls_test_mbec
PASS: MBEC disabled, EPT disabled (valid combination): vmlaunch succeeds
PASS: MBEC enabled, EPT disabled (invalid combination): vmlaunch fails
PASS: MBEC enabled, EPT disabled (invalid combination): VMX inst error is 7 (actual 7)
PASS: MBEC enabled, EPT enabled (valid combination): vmlaunch succeeds
PASS: MBEC disabled, EPT enabled (valid combination): vmlaunch succeeds

Test ran with "-vmx-mbec":
Test suite: vmx_controls_test_mbec
SKIP: test_mode_based_execute_control : "Secondary execution" or
"enable EPT" or "enable mode-based execute control" control not supported

Note, all other tests pass (including EPT with MBEC enabled and
disabled) with MBEC v1 series.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 x86/unittests.cfg |  9 ++++++
 x86/vmx.h         |  8 +++++
 x86/vmx_tests.c   | 76 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 522318d3..b82bbc4e 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -324,6 +324,15 @@ qemu_params = -cpu max,+vmx
 arch = x86_64
 groups = vmx
 
+# VMX controls is a generic test; however, mode-based execute control
+# aka MBEC is only available on Skylake and above, be specific about
+# the CPU model and test it directly.
+[vmx_controls_test_mbec]
+file = vmx.flat
+extra_params = -cpu Skylake-Server,+vmx,+vmx-mbec -append "vmx_controls_test_mbec"
+arch = x86_64
+groups = vmx
+
 [ept]
 file = vmx.flat
 test_args = "ept_access*"
diff --git a/x86/vmx.h b/x86/vmx.h
index 33373bd1..75667ccc 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -510,6 +510,7 @@ enum Ctrl1 {
 	CPU_SHADOW_VMCS		= 1ul << 14,
 	CPU_RDSEED		= 1ul << 16,
 	CPU_PML                 = 1ul << 17,
+	CPU_MODE_BASED_EPT_EXEC = 1ul << 22,
 	CPU_USE_TSC_SCALING	= 1ul << 25,
 };
 
@@ -842,6 +843,13 @@ static inline bool is_invvpid_type_supported(unsigned long type)
 	return ept_vpid.val & (VPID_CAP_INVVPID_ADDR << (type - INVVPID_ADDR));
 }
 
+static inline bool is_mbec_supported(void)
+{
+	return (ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
+	       (ctrl_cpu_rev[1].clr & CPU_EPT) &&
+	       (ctrl_cpu_rev[1].clr & CPU_MODE_BASED_EPT_EXEC);
+}
+
 extern u64 *bsp_vmxon_region;
 extern bool launched;
 
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 5ffb80a3..ad7cfe83 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4867,6 +4867,69 @@ skip_unrestricted_guest:
 	vmcs_write(EPTP, eptp_saved);
 }
 
+/*
+ * Test the dependency between mode-based execute control for EPT (MBEC) and
+ * enable EPT VM-execution controls.
+ *
+ * When MBEC (bit 22 of secondary processor-based VM-execution controls) is enabled,
+ * it allows separate execute permissions for supervisor-mode and user-mode linear
+ * addresses in EPT paging structures. However, per Intel SDM requirement:
+ *
+ * "If the 'mode-based execute control for EPT' VM-execution control is 1,
+ * the 'enable EPT' VM-execution control must also be 1."
+ *
+ * This test validates that VM entry fails when MBEC is enabled without EPT,
+ * and succeeds in all other valid combinations.
+ *
+ * [Intel SDM Vol. 3C, Section 26.6.2, Table 26-7]
+ */
+static void test_mode_based_execute_control(void)
+{
+	u32 primary_saved = vmcs_read(CPU_EXEC_CTRL0);
+	u32 secondary_saved = vmcs_read(CPU_EXEC_CTRL1);
+	u32 primary = primary_saved;
+	u32 secondary = secondary_saved;
+
+	/* Skip test if required VM-execution controls are not supported */
+	if (!is_mbec_supported()) {
+		report_skip("MBEC not supported");
+		return;
+	}
+
+	/* Test case 1: MBEC disabled, EPT disabled - should be valid */
+	primary |= CPU_SECONDARY;
+	vmcs_write(CPU_EXEC_CTRL0, primary);
+	secondary &= ~(CPU_MODE_BASED_EPT_EXEC | CPU_EPT);
+	vmcs_write(CPU_EXEC_CTRL1, secondary);
+	report_prefix_pushf("MBEC disabled, EPT disabled (valid combination)");
+	test_vmx_valid_controls();
+	report_prefix_pop();
+
+	/* Test case 2: MBEC enabled, EPT disabled - should be invalid per SDM */
+	secondary |= CPU_MODE_BASED_EPT_EXEC;
+	vmcs_write(CPU_EXEC_CTRL1, secondary);
+	report_prefix_pushf("MBEC enabled, EPT disabled (invalid combination)");
+	test_vmx_invalid_controls();
+	report_prefix_pop();
+
+	/* Test case 3: MBEC enabled, EPT enabled - should be valid */
+	secondary |= CPU_EPT;
+	setup_dummy_ept();
+	report_prefix_pushf("MBEC enabled, EPT enabled (valid combination)");
+	test_vmx_valid_controls();
+	report_prefix_pop();
+
+	/* Test case 4: MBEC disabled, EPT enabled - should be valid */
+	secondary &= ~CPU_MODE_BASED_EPT_EXEC;
+	vmcs_write(CPU_EXEC_CTRL1, secondary);
+	report_prefix_pushf("MBEC disabled, EPT enabled (valid combination)");
+	test_vmx_valid_controls();
+	report_prefix_pop();
+
+	vmcs_write(CPU_EXEC_CTRL0, primary_saved);
+	vmcs_write(CPU_EXEC_CTRL1, secondary_saved);
+}
+
 /*
  * If the 'enable PML' VM-execution control is 1, the 'enable EPT'
  * VM-execution control must also be 1. In addition, the PML address
@@ -5327,6 +5390,7 @@ static void test_vm_execution_ctls(void)
 	test_pml();
 	test_vpid();
 	test_ept_eptp();
+	test_mode_based_execute_control();
 	test_vmx_preemption_timer();
 }
 
@@ -5551,6 +5615,17 @@ static void vmx_controls_test(void)
 	test_vm_entry_ctls();
 }
 
+/*
+ * Check that Intel MBEC controls function properly, which is a
+ * Skylake and above feature, and is not supported on older CPUs.
+ */
+static void vmx_controls_test_mbec(void)
+{
+	vmcs_write(GUEST_RFLAGS, 0);
+
+	test_mode_based_execute_control();
+}
+
 struct apic_reg_virt_config {
 	bool apic_register_virtualization;
 	bool use_tpr_shadow;
@@ -11506,6 +11581,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(invvpid_test),
 	/* VM-entry tests */
 	TEST(vmx_controls_test),
+	TEST(vmx_controls_test_mbec),
 	TEST(vmx_host_state_area_test),
 	TEST(vmx_guest_state_area_test),
 	TEST(vmentry_movss_shadow_test),
-- 
2.43.0


