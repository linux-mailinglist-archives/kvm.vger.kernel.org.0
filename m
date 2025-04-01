Return-Path: <kvm+bounces-42284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A65BAA77377
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 06:22:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32682188ED1F
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 04:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC7F61BFE00;
	Tue,  1 Apr 2025 04:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="DJCaYxSu";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="RK84jteb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD558F54;
	Tue,  1 Apr 2025 04:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743481328; cv=fail; b=EcqAje/TTtbBBwQOcZy4RFnxNh0FbNlflwIA3r1xL8IeJgj9kKu4Xpja2kx+jdSTs0BK6bM/ScM4Ou7JEOST/a6rvW/yZxvEhI+kQ9hXM6PKwq0XQ571ooPRXpAriFqm9RJtRsQsT4yIw+PgZcVzqcqva5RzJDiRblnWVEIP7ZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743481328; c=relaxed/simple;
	bh=VJmzd/H+Zh+f/MuJxKT4Mtrq0hGOG+cEI4MSrhVTMm4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=sFk8eTlA85rO2Cfz/lXs6XcEaEJFERSC6x6E1iksXf6AcvTARYFmqv2Cwk72zpisPBvhu+FTt+HnMKH0caz7DrLKWXoSlKW5Z2OHdUQxPsMrfPP7CubZM97t1029MHZlF6wql60i1vTUxP6ieBhHspVRAycUjFgmbpOTi7iijZ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=DJCaYxSu; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=RK84jteb; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52VLBBjo032068;
	Mon, 31 Mar 2025 21:21:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=iZvSv502Tok0y
	LphyycVkVqDLTrfQoVeXBl+iRb016k=; b=DJCaYxSunRNef1JO6L0Kr9ICHVyZA
	IthHDm18K9vLANsmv9DEhWmxiuxMEvUiYZhY1jNUwQ/OZjGLwCUFFzYWgjjWoVyT
	vTbCKnuHjYJNn+3kyPQB8CQ2W0fWKQ9DSFEvjU5w82P+JBi0Ct/SyTPC/bww9j3t
	ExDrH0DSnFi/nl90Pvx/rn+DG74nbSLEcZyafkJiBcC4WgCmonU3CC9Ej7Sv5caJ
	jFcbrR72h3saX3lnjRZitYwvCDJ5V9nSeNL4IskG65noNlJXmo9uJ4JLniVKp3TC
	yEe+wHCO2+bsDqXZDDCYg/f934scquBaPnMOTaWxrieqfyptqJX/5cIRQ==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazlp17011029.outbound.protection.outlook.com [40.93.14.29])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45pfxmmeut-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Mar 2025 21:21:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dIIFLDPg9bed3o3hJeD0rcagPi8GAjkX18ZMoDZb9+JLG02KNnyITYBl6d1oRK75zDWtB5HdkUJ9jJXyeNsmwtMBfqiHSKmUthIcqepIi1F02MMldvOq1pi8JLL+FP54WNREvV6p82ZD6Z5phG1iO3BMb2uKdJZgzDvwXCM9klvJ0hpifINdTE0DwdMaXLfU98rIjz/phPNOjXkr1ip0YMF05/B5d4gHzUcd9+H1yb9q9e6uPt/8eqjOszFBGdLRfUYRrtS9czQgdlX4PNOTio1oMphOOFxb0qTwiS7/mdBEw/kznNUM5VWeV4cr2LaeeZPRgFiAgfI6okbG4Xg8xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZvSv502Tok0yLphyycVkVqDLTrfQoVeXBl+iRb016k=;
 b=FWn8NcEqaI34bLEIUGi1ocWGclX/+YQPKD8weA1QkWMts6pqjUjspcXcHWiwg4LPd/j3gXNzdupb+v569l/qfhXQHUWJsgepFjLOCM+9JD8jsyR4NR6oGpVDUuyymn/nUc3cEu0qPKKXmVqFZPdH9myLsQ8JptJL6EHn4u8EMUSOIDJupocTvwHZoPSugRscozscgypd1EqUi55HWiMcwCRXGCIFXQgSr2+BaSxu71J5m0p0CUijXQXRcSu57yy7N1yQ7XfGKXNZdz07vB6kBaGXIZK9XMo1ME5likxVjgqkwzFLgcZWuJVAY8x9LO1UIeJd4kko5eOsxPnkGO7r/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZvSv502Tok0yLphyycVkVqDLTrfQoVeXBl+iRb016k=;
 b=RK84jtebATIX4djPVeow+h3ZJrCj1rQic9ixMexRXBwgEEfif+trCc/jdfUFcKiSndgqhtS4CCUmQ+eul5R4J4qM+mXMsvtylYClXbD6OcUNt4FYUbQPD1TBkOpC+KkwJp4oHVNyos2lmcnAAzpkxEDM61RJr4DKIOxAPiLTGzbvRccWN/nPmwhZtnmN2EUL7dkv+9jrt0LQePS3j9zDU1k4zbax370ksKE2MqnqWHNx4I1bDDcgDMo4g3disElSCinCZEMRMPAN2A9u73ORMQZkeU8jXTDAFW/9xEZw9hs/vPfos6rRvWm4XEmRC5MeDhQfaYEVB8XTWPOF78lekA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SA6PR02MB10357.namprd02.prod.outlook.com
 (2603:10b6:806:405::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Tue, 1 Apr
 2025 04:21:26 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.048; Tue, 1 Apr 2025
 04:21:25 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH] KVM: x86: Expose ARCH_CAP_FB_CLEAR when invulnerable to MDS
Date: Mon, 31 Mar 2025 21:49:31 -0700
Message-ID: <20250401044931.793203-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0149.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::34) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|SA6PR02MB10357:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c699920-e4b2-4980-e5cc-08dd70d4aa8b
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|7416014|366016|1800799024|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UmYGXYrS5nf2l2v+2Zu30vezpf2Utf9ayFOfpM43ymSRJxiu7l6ZP6lj2j2C?=
 =?us-ascii?Q?Hhn7aA5cTlj04Wu3+qB9OV4L+PAWiQheCNCiqYnMf7/y8rtqJxiLhWRjrIfq?=
 =?us-ascii?Q?k52L4nRT+i/MCTTV8HlsrqSCSOfdW/0JsFDXBaCQlP9z2BO+E/3I2PKeAzy0?=
 =?us-ascii?Q?hLtL7mbh2uUXddQofXxceBOqBtC6RIZFqRDrC1CbY4lmOCJxBVUuNaToSSZf?=
 =?us-ascii?Q?X/sjgWA8T/V79RhJV85KZBwIdxqt/whiM23A/a7T93b31DICRSVu1gHkz7OG?=
 =?us-ascii?Q?+8+jW9+OQz7maqJ897F5KF7FM9tyk5+xHDIWKtK8k1XCcuq1e47oMzTCAfes?=
 =?us-ascii?Q?uaEMbGFMCsp3qjiyEiKxLkAmhBcV2s6NsnTKrsCg2NAoHr+nMrg+LqUReme7?=
 =?us-ascii?Q?Q64KOIgq+n3tVsehe8y7XM2VaVF8pqPhVH7yrK5VAHeRoZxgHPa9XbtFL2UM?=
 =?us-ascii?Q?PaY3JOMCjgg2PLOyma9mVT6yDVVg6S+d/bz9Ap7A2V8YypldBT2XmCcIePQl?=
 =?us-ascii?Q?plvV8j6LQE7epvOkuQ8xAOZtQjkF1BlEM79RTrqijfepUp0b5BDAeqcSWQDY?=
 =?us-ascii?Q?HopyXe7dTDprSr1hXOzfpvZSW+yL0SpeLOU4lp30p91FeWRk8w9uVNBNUKob?=
 =?us-ascii?Q?se7TliIQ79Lux8ucTod86Ev/k4at2/5qb9zEuwDPDG7gycwgfptwgoo5as9N?=
 =?us-ascii?Q?CNwm+IB+0U500d0i2AfdyKI8ISpjMh1sTfsDoNqeLuCCae4h798Ui4jzqSns?=
 =?us-ascii?Q?IcrelSYrdXlU3nbSZK3R+UaIsdvrowwp/kZLxVMnLE9K1jZTLlwZcPjrWKNx?=
 =?us-ascii?Q?put6tWsEmJOJ+HQbQDwqf22f/GzA/vLqPfzd8prFFu86vj17gGtq03s52FGS?=
 =?us-ascii?Q?tGA+KcPN2zvG8DWPH3lO00Gv+uRy/90FeLlec4plb1/gvW+3Iqp17a3+22W2?=
 =?us-ascii?Q?NQIFjXEj9Tcno7U9pjiAsPplX1xec+8ae9Sp4MIl39m1De3CZUKK93h3W8Gm?=
 =?us-ascii?Q?e6bceoO+hZvITIaxxB6qHNhB5wZcmMVRxGLuBSV7u6G6JzIsaL8WwM9RgvT1?=
 =?us-ascii?Q?7WHhtfUZaB7c1Iu1MqdmS8g5rsIG5izItPG2stFTg1N0AwdWtV0ymaNSGi1w?=
 =?us-ascii?Q?EwtHNMSM/UpiMttnOHdJKom6HBz6Z1iIjqX4VIpweMTJID5QkRXh2G5672K+?=
 =?us-ascii?Q?clTRWqPzFxEuBcN6bdPKElA8TUboVqPLESQ2oCLk8B1w8g8eYrdnC2lDjp+x?=
 =?us-ascii?Q?AIFm8GrE9Mr2Y2XiXhnuTTFS2qEkGD80lq0khqsxan+j5wkZwxd/tV3f0ZCp?=
 =?us-ascii?Q?DtvMpN7ZPzU4CO8+sqTIKuR1KzPULniZ1CkZtVQSX8xCUPPRhKZTML6wo5D8?=
 =?us-ascii?Q?Qd1ByUqqjWSpzHS3IPeiKdZCSiD5OSyUgy3f5/OcPvIT6h+ZPa4DH8KLEvBD?=
 =?us-ascii?Q?GvxybCIADP3ud7joXsygBY2ZOAdrLDgp+fWWomYqZxN7ZlZBmOEN3A04UVan?=
 =?us-ascii?Q?udZVBF79RUWNekY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(7416014)(366016)(1800799024)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OQBRIzgYOIAwjFv3o72EjZb9L2m3Lfs763dwscgGcfxVtIzc33rk81zxd6Dz?=
 =?us-ascii?Q?nPk+E3mWLG4yfN+IjHOq875SFLSc0cCuVOfr7ylayyJFq6bFQBiZh1pis9JF?=
 =?us-ascii?Q?6oyTsa8FWpw2wr/czDOGZ/+H5BTdO+OpVo67fidTQqkXY+7i31FyHTTaatR/?=
 =?us-ascii?Q?NQc+sh4BNm1XFUVZgGZJJ0OnMmbWgk1b0RoH27JcDORQHlz8Lv/WElIdTdIp?=
 =?us-ascii?Q?MPic85LBGrc996pF2MiFQx4DTkTBCa+wdYK6jnIy3kZ1kIXUlFDgIgUPQhxp?=
 =?us-ascii?Q?Y6LaEl1IeCmXas2n/UQn14pZPWe+ZzvhDj3+dM7qy0azCWykmFeEb4GGga+6?=
 =?us-ascii?Q?hPcLKv/Vd/SnlouSxP6utJ02KpigPxZ1Va9BmwwuN7WUpPiOUdXkKvd9B4ke?=
 =?us-ascii?Q?E+4m9WGKdiH65jF+wC+GZvVhYZYKT9fSy8fXU6OtrXx3soGlILyF/WDmN/Vc?=
 =?us-ascii?Q?ldsF1GSlFjkm7qGY4dBxsAt5uVY1Re/e0Bb3VYFGuioFPznwdBlSsLtYMlAl?=
 =?us-ascii?Q?VoST+xysBT3uUdG4QtMfUsPZiO28ovZkN9U6oPXswFCI9iiBRkU+6h87niyp?=
 =?us-ascii?Q?37nurt4s3Wz16dtTmWpgmS06Ht+xyg8F5DPrPxhzttWWlRw7+dWvfJOWMXId?=
 =?us-ascii?Q?ymujQ+bUCfBk3OnF7QJ+NioA25phnArbJUELvKeAV2Tyvzxmkk2pnqfzYokU?=
 =?us-ascii?Q?Wi9vdj0Wke2Qs1pnwxN4/Casv4YkE/5DBxptcv+HRZG69awKB5GF14VSnpII?=
 =?us-ascii?Q?WrZmknsQPnd37UpDhnS+HaIdkXW/YSE5zKmvQe7fdv0bpzj1Y8gdnq5yeCaS?=
 =?us-ascii?Q?SGzLs3t3N4/sLNiEZyF0GaFcSrNa9CRkTR1SyiPSwkEafWtxeysNcG1cuiE0?=
 =?us-ascii?Q?5rt6+d2VM/+ADGcVmsQwAhmT94HNxO50qrQDPiz1cFdThj5HfBR+PvpVP55T?=
 =?us-ascii?Q?RLj9/4p2OxdFMgZ1qHTsVRoQpHxBh5UNtHXis9JRYhBchOoIxiBwaSS8hczI?=
 =?us-ascii?Q?ICS9iy9DwN87DCAgIGuVBVWailL/XFRUGoupYNiN+jJtS8K2+PLVIOGwmuR0?=
 =?us-ascii?Q?keT75xM7bG8yJsaTltDWuDaE+sHnRvCK2ZWTNXae2yZOHJN1Tn+9CaExtET2?=
 =?us-ascii?Q?8bCx6krNG0hlE8U2rb4/YQZgKkbU/ORKWUSydSxuVBJe2ryLIBRvT/ROxAK/?=
 =?us-ascii?Q?XUDm4F00em/2ru6F2xveP4Snv5njf6NWNIERUlQkiWqU/wu3eCDxpI4X8H8z?=
 =?us-ascii?Q?1RDo0qZO8KipUa8LcVxSb2L72kpb9tIg4CLfOMTAla8eCOW+1pa2JJLfba5O?=
 =?us-ascii?Q?d7cutKYarF+bI/g2tLeWpWLPHK+KelwHz79Ghv1lJ0sf48BJGUWER1JKzgIY?=
 =?us-ascii?Q?UsB1Hk6d3AYccK1VrM+bLzmsrqOcEqwz8IxoTS4kUxRBRc+gD2cKB3+qGYa/?=
 =?us-ascii?Q?+4GJY6QF+go0SOoo7EqAgsIprtWLp5Myyr4b8AoL8Kf64YqPa97a1AfSgVxS?=
 =?us-ascii?Q?0Arwh7hKGJHJQwWx0diKMKqJpjYLOhaDTIf+Qt0swopnkyVuiCHRi/JfIa5A?=
 =?us-ascii?Q?IJAG4hTTyfTOyk5MzNVAx64cNL6mAxYTQfkn9geahm4HTHYxpgYrPIOP2E0C?=
 =?us-ascii?Q?fA=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c699920-e4b2-4980-e5cc-08dd70d4aa8b
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 04:21:25.4168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PU12gppsUGVYtBnK/5nPSvAv9ap3a8VGodl3RWSDnpNpiHm78DiZmZfY4LjYVqEGO7aVvSzH/4I3CNcWPkTemMZ0IJNcQotdH29sgS/Xj3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR02MB10357
X-Proofpoint-ORIG-GUID: Bn3c-8DUE0LPZ1rNtZvHSrL2lPLP1uWY
X-Proofpoint-GUID: Bn3c-8DUE0LPZ1rNtZvHSrL2lPLP1uWY
X-Authority-Analysis: v=2.4 cv=IKsCChvG c=1 sm=1 tr=0 ts=67eb69c8 cx=c_pps a=SyDKAmCqRQVBsfptwLbjyA==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Vs1iUdzkB0EA:10
 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=64Cc0HZtAAAA:8 a=Aiiw1AQcM_unW6Ac4i8A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-01_01,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

Expose FB_CLEAR in arch_capabilities for certain MDS-invulnerable cases 
to support live migration from older hardware (e.g., Cascade Lake, Ice 
Lake) to newer hardware (e.g., Sapphire Rapids or higher). This ensures 
compatibility when user space has previously configured vCPUs to see 
FB_CLEAR (ARCH_CAPABILITIES Bit 17).

Newer hardware sets the following bits but does not set FB_CLEAR, which 
can prevent user space from configuring a matching setup:
    ARCH_CAP_MDS_NO
    ARCH_CAP_TAA_NO
    ARCH_CAP_PSDP_NO
    ARCH_CAP_FBSDP_NO
    ARCH_CAP_SBDR_SSDP_NO

This change has minimal impact, as these bit combinations already mark 
the host as MMIO immune (via arch_cap_mmio_immune()) and set 
disable_fb_clear in vmx_update_fb_clear_dis(), resulting in no 
additional overhead.

Cc: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 arch/x86/kvm/x86.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c841817a914a..2a4337aa78cd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1641,6 +1641,20 @@ static u64 kvm_get_arch_capabilities(void)
 	if (!boot_cpu_has_bug(X86_BUG_GDS) || gds_ucode_mitigated())
 		data |= ARCH_CAP_GDS_NO;
 
+	/*
+	 * User space might set FB_CLEAR when starting a vCPU on a system
+	 * that does not enumerate FB_CLEAR but is also invulnerable to
+	 * other various MDS related bugs. To allow live migration from
+	 * hosts that do implement FB_CLEAR, leave it enabled.
+	 */
+	if ((data & ARCH_CAP_MDS_NO) &&
+	    (data & ARCH_CAP_TAA_NO) &&
+	    (data & ARCH_CAP_PSDP_NO) &&
+	    (data & ARCH_CAP_FBSDP_NO) &&
+	    (data & ARCH_CAP_SBDR_SSDP_NO)) {
+		data |= ARCH_CAP_FB_CLEAR;
+	}
+
 	return data;
 }
 
-- 
2.43.0


