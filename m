Return-Path: <kvm+bounces-57747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB663B59E09
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:45:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 828CB32848B
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB153301704;
	Tue, 16 Sep 2025 16:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Budkk9A+";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="wXMofErO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E11E27FD74
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041099; cv=fail; b=Lh1cVDPTUtN9T2JZ+7cOkf0TUCxO8TJswkShg6+AKyjsSy25IpBC9KhGRHhvQOj+Af2warW9r9kR16jAIMiyMTCMnZXPa206qgG8NICTRfapy6DbFDqAZ21is4RlzV3yq1kpIV0Q59Sgq8fd1CiAElrIIYbVv/uIc4fpgj1Auv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041099; c=relaxed/simple;
	bh=C8j6pKjG+mW74t6+M/i2kSY0e+4JNKYRoQkhpy4jWr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IwfN7RGZSXkjVS+wvkD5/cNLIuvB+3Ux/Ljrldu0YEl0o65fqmaHM70eY1Ugy2fAQfMky7a3qyzzvVoo45C2XonaJiKUP01KilXV02A5GkWF12C6XLcNk1NpB1DK8s5qouWNGNL0AqhNEDjSeI+GOlkiSnaBUSxV/rjfhLm3zB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Budkk9A+; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=wXMofErO; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58GG3xO53598632;
	Tue, 16 Sep 2025 09:44:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=cA3SmXOXz3myOpIB6+gZJpiEW7fkq9a3jSqlCmCKv
	XA=; b=Budkk9A+9kLbA98CWEtOU0T1cIgWwY9we5BSi/tLjrPefongqoEhHm1ER
	OJJjHmklkPHtpE9cOiBluuEd87khF1dGCwz5zWW6i1Mrw9LmGsOTdl6RYQtLm+yw
	ZIvJ3SwHYODiHIDQvRIPCIfGuL19iZeulr4Mj5BN/G1YRCTJrw1mFUry0jz25Ubi
	yO4Vv8Ts1wCD0hakRfGlCJSbu5TO4KEgKvITebQQuuiaV8bbFzZMbCmYmaf1UoLy
	88CBgc4PwQSIq+DdSl/P5UfVREwZJEb7Poh/G6jWgGqbjZsSAQJAoG8ruBPYoVzL
	Iyf/Q36KN9jSvRm8qlULlQZTipEEA==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022081.outbound.protection.outlook.com [40.107.209.81])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 496pby2vkx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:44:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vlSMb6k+cLeyDqKTPwvEaLIbJ47HRGe+s+N5rEwon55lFMXGDETHYUT+Nz8kk2gzvl4wav24oLQ+SHjBXaeNz1snenzrXPxfCYBDsa2/LFp7pkSYtaN3AHCo+gDr+Y46aFytZFieKB6Jx/78fSaVBtQVvvYvVJ+QBYNup8YmhSDWlNtHfozAzWxpvZuuiUhZkArxeWMzxjY4PZlBrhWP7DVNhuPNtsBDc8aKOjEafV0C748AcU2zimsHCTKMQ2RrqzqgT7JmM1Win8CFjOmd6pPh5k5/U/v/53LBT3UFdrWtYbwhjClLeyKMOUtVWfgwV0vLUS/s462yrzL7wT6xlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cA3SmXOXz3myOpIB6+gZJpiEW7fkq9a3jSqlCmCKvXA=;
 b=oqbEJ8ECm54Df2M9UOf6Lf8dYg1jKUsUx9IsL3k+bOhbTqOxipI/bQskjGw3BP6vIFEkljcnnL2RaVXu10HZwB6ZbW6p0RNOk0M2F06gVDVcO2a+2IEl4JNy5JPeStT6WmZUt0Z/6TOO+na4p7KGUVZ5SsW7soenBH2yPnHVU3LNXn/rWYkNBWbotkYWd5WMuRnsATVVzj9ToDxEMx6RxXEGIbhPQluO6EjKCFBb/5qUIsczsRVdP3eia5jffBwejzem8NoZB9hkgJILmMq+Cbq39IZA6a65PDCZRFd4+t7oSyu8qQopXro8Zd5tUebaulGW7KU2Kyqb5Up/wF5GXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cA3SmXOXz3myOpIB6+gZJpiEW7fkq9a3jSqlCmCKvXA=;
 b=wXMofErO4u2nB/IqDtP/lgAvMQnnLyVFQqDBtgUhvYBmrl8O5XF46fSbJOeSoJYILZ2Z3dWvz1DVhB+qXyHT3nta2kS3P3jFdVkWxQLaKvy7qsQ/48axU7Dw6B9Ct9D8tqoTm+n7MFZkQnjEmMcMCe/EHmLWEychcF7w5uIXzvG3kzTlwvkSylGaEi+s3Jkdwmm9sVjmU4Qu30EhrxsXaoxZwNX2ZM7Wa5svHtk0ZYGKNzxRcc4o+NrK80G1h4bk13YfIkgf5vt3ALuVvWFci8/gtXG+SqRdiCMMIMBrzJgQ1P7r7bEYQhfXb4tJfcUhFCRLWVVsBdFn2vlfWyl3Ig==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DS0PR02MB9620.namprd02.prod.outlook.com
 (2603:10b6:8:f7::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 16:44:46 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:44:46 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 07/17] x86/vmx: switch to new vmx.h EPT RWX defs
Date: Tue, 16 Sep 2025 10:22:36 -0700
Message-ID: <20250916172247.610021-8-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916172247.610021-1-jon@nutanix.com>
References: <20250916172247.610021-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF00013309.namprd07.prod.outlook.com
 (2603:10b6:518:1::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|DS0PR02MB9620:EE_
X-MS-Office365-Filtering-Correlation-Id: 78f59b29-2658-4e4c-2608-08ddf5405816
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IrW0urcMf1LIuVsjQOsZn9Q6RU3jYdNycID0oKQVfzfS5hYUA4OO7X7aKnC/?=
 =?us-ascii?Q?Hpf3uAXlP3a62ggTqX4PA8stkdcA0JilOuQDfcQNJrowmRC6ar5GQDJqjJoV?=
 =?us-ascii?Q?jclwnBvgQ4Jsx2qqTs8k/u6Im5u+NPFizOclgQpeoA23IefH03ITfcP2LeQA?=
 =?us-ascii?Q?4C+oJb7J8u6GgNXwOUWIRxCOaRAnqVaF+MouABFzjhgiOFO41d7222BAFHP9?=
 =?us-ascii?Q?0owjiUZWveESiJoB7bwaNXUeYEhQgUwKlX1ke10qMvn0C0TWeG3wLUe1aA4Y?=
 =?us-ascii?Q?O4AnJO7bb24I1sjwq9nXmpumC/agM+LGw119q+TdkL8r6Uf2ztQztJEqzviF?=
 =?us-ascii?Q?W9AzoVCH6KYXpdLCQAI1TsyX2mNCBRoFlRLVH5QqFp/J8Dfay0Sz7dHSJqBu?=
 =?us-ascii?Q?xyXsZEHRgb4a9yhb2z8/Pj7xgC3foYH8S99iHsWuBhO0xewyUn/dwnK+WWtB?=
 =?us-ascii?Q?JRDSSoR1rw8XZtoh83NGWPea29YqAatttYj7aXKK7MnhR+iie31F/AEHt4Fi?=
 =?us-ascii?Q?+Tr08A2Wh2gV9UECh6OYIB4DB7Cwu6aFSz9N+I6GojKCkYREVX2tawWR3DuH?=
 =?us-ascii?Q?kIoJBYXok9heQ8Lsr1rwyKyigYyD79YAzfbIhMAE0uLChN6719h+3feZ+1M7?=
 =?us-ascii?Q?em2csfYNT/FPZesJmtmswujsolvpAO3OTqBAERXWjdcJnepuym9PRQldtN2R?=
 =?us-ascii?Q?nLYjxuZEaRsxSuNZg6qb28F3/G7+h/5TfB+JSbLcX8FWThug5krOxAcx+wst?=
 =?us-ascii?Q?zuOm8F4/0ZN/j6iEho4NveZVj8FHlw9Vy7yX4IrkGDeSGO9CO38Am97AryIU?=
 =?us-ascii?Q?zZ+eRA8mrUKbIdnZnQWMVfe6zvU4iHEuspCC/qd0LfclyYoUOV36GpPla3QO?=
 =?us-ascii?Q?EkC2nEpPJPwoHaKB20l6Xa0RH8J9XY4l1jkmRXycdQ9mDlEKwlGGsMfo/J03?=
 =?us-ascii?Q?TDO54u+8f99cK8AqhaGqp04A6Ej7DG2gSQuu1lfsXkF6dT3lx9vZMR0INOtf?=
 =?us-ascii?Q?vWSGIABWkAxtkBBiO51QcKZBVMyEh0iXIV62AamqWXds/GevNQHeLuCdpFsw?=
 =?us-ascii?Q?5xjZkHEUx4bt2aQ7pChv7Z7bDDHIennDxiRefrQpsdxKB3PyMEcSck5tDTyo?=
 =?us-ascii?Q?1DJzDZ2j+MyAetCZT++tC1iieh9e1JQ/ZtOhq/658tfkhZ5KIHO+M72qZnpr?=
 =?us-ascii?Q?/uZFf/oxib4iCDXTWJg7bXTr2YjHXvx7N5Qv1t8joHW3DeNE+KgFtrqHnNhn?=
 =?us-ascii?Q?C+3lXBOehUOYiRiit8BxxKOwCCvA3GjpquRuEaDGg1+Cn/VQjsN0J1Wy6MUx?=
 =?us-ascii?Q?A13CZazyW6dfk434ypdCYE7PhO5xLZrJ5gyde6yOWNMFD4dq47nVDMbSUuVi?=
 =?us-ascii?Q?XjWAhK011dEt8uLmujukfmFyAKPDOgpEdk1sBBiqbzvUBV5s/PSWIcgTKsg3?=
 =?us-ascii?Q?Jm3FBvoylUuxNsIFRwmgBUlP72LfKsWJWG/+Ccy2ViBSos9ILmHphg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cUqQlF4K0IvKQ1iKunGYkTKmGLT0J5Hp6H6c5a3CLBJacdaEINlCoDfa/ss5?=
 =?us-ascii?Q?5GVLdTrZCpLbIw+I5wCCrrEkXLGlsdlbxAc+NhpG8RhNmzcCUxdjn7VxJYfk?=
 =?us-ascii?Q?hs8iNhcDG/S3srR3KvTKr9ObexBTO7hSf8sokXRIVdx925uLdrJ2g2YBDgjs?=
 =?us-ascii?Q?TgR9ZGugkD3+vvy5gOWZ+LH4nX1BTj1E4RpHZ1g03osxzooS/MQooWfl9MSL?=
 =?us-ascii?Q?1wJf/7hE0S9pkwVqgx0zWhsM3qVAJqS9S44Ff837M5PjVw5FEKYMr3Pobsh1?=
 =?us-ascii?Q?PHoKvfmw0k8MM/R3t3oQ1fVhrU7pDkwOSqcZmLBIz/kScB7vDFzBFyN48t7E?=
 =?us-ascii?Q?nyNF7mK2ytAdS/j+Y3Ze5B/Dwr2cnBFsT/e2kxT0f95kWc8MPhMANOwoIxko?=
 =?us-ascii?Q?6HRCnWi+uaj2TsjEn1DkQFfiI3jG2T+/R/vGdTCQMIjx+t7mgWFLv6NIHAV4?=
 =?us-ascii?Q?dTx3NB2vOkCVSMwdU1VCReUcmfaxdk2cpHbnr8+xOvpooeIyK9eqfcigj3u8?=
 =?us-ascii?Q?hHninqbqnfdgBW1gzk8UjsaDcHqxkydnmqK43RCOQ7Gh+b++EmMvcD+J4uQm?=
 =?us-ascii?Q?+V+6yPN3QIeFzlR24Ca6mkKv5w8huDuKEqJxID5PAmQ5jU69V41gtg9v+1xw?=
 =?us-ascii?Q?DTMBHMhiudbYF86eon3JPKbMx95K5ATNglDs509M8QxDB8oaRTI+ra1isKjV?=
 =?us-ascii?Q?Jrn3YD8z1mCVyS4lPV7WdLtrl6b5wWrjnruBiXtyc/MTHLBx5J3+PrLFkQ++?=
 =?us-ascii?Q?TEF/FK0Z7NaBI5WD1T55knGKQez7dtw6bjU65bIIu6KNq8Hz8KqycjMgAglm?=
 =?us-ascii?Q?JhTPUb354pms8Ohf8O0/rwlygtv5EBLwQnx+71Q9GO0eKeN/caVd4WP7P/5Z?=
 =?us-ascii?Q?26S26FUjp6X+rv0LCDZ0gZDnCWMJxj3UP85md1ShjwzVc+k3DdI0Y9hmy2Wq?=
 =?us-ascii?Q?9sU35ngsM9zWlPZaiDiwbvvoSxuBd7hI0FRr4e0nqSzTlOd4Q3BR9CPu+4Lp?=
 =?us-ascii?Q?/6ZSqdQziOzIIZiysYP3Jf1MddJbLaZn80yigclj0b8YilNEhJ5UfeIVJ4GW?=
 =?us-ascii?Q?uZVWlWpTtuz0H7wvjc6nJmFOWjeoiPxF/esI/ogqT+nMJ0PbR9DuPB+qvQeU?=
 =?us-ascii?Q?yAoXH0yJRwgtDncyK/0Soy7fQjXZA9+c05scbDBcKEay2APtXEA/UrhBnZUr?=
 =?us-ascii?Q?l/ubmxOBkxHzBygfhJoBFrWMoGfwoQJSpL7Zo3DL+Af5ConZrzE9sSVSecVk?=
 =?us-ascii?Q?xp2xxBOooqw0A6B3OBlhQ55OjhBUMuRfHNlVuWZeHwqmooiPRlBKsfXZfB3J?=
 =?us-ascii?Q?EjT9Fn6zRnQBD7MHLt6tnnuf21e5PSWA8NGHB+AKA4jEGW0jDIrqI4k+UwNJ?=
 =?us-ascii?Q?exIBpT67QnkjU3mXOofBaIW6RCw5ASdDmpi5jpVDIV0y6Uy4kIqyzRR4F4B+?=
 =?us-ascii?Q?pY5bXp9H0mgSi9XL5yqiE9/zoMphGMdo7AHqs8OaZWnWn3p5GYRCrepNWc4e?=
 =?us-ascii?Q?sznRSzn7aZDFg+iSOYOq7GrqVuuBh6Qbxju1IhcNcBRw7h8nCF9nYUOC59wc?=
 =?us-ascii?Q?kgbPD8cmrTv9IzG76xRLadxA6tZpY2QGcVsXkUwUNKi8WaeeqduJ8cRiEu1p?=
 =?us-ascii?Q?Fw=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78f59b29-2658-4e4c-2608-08ddf5405816
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:44:46.3316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 68VlH8SbV4/BfebapsI3PGVCUwlZHGWpyemyzFjVQGz/bFkqNNyCR1Xd5jLOGvg05tkaiH5Au6cnE9GRUYpI57D9msS+AzvS5SG/ylfyiKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9620
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDE1NSBTYWx0ZWRfX1YBY+ZGgDFq4
 Udl3RZj4LNs8Alob9fLAyJ8//ncgO6MvUE1Ahps4Vs/lNI8l0xZcyP9j4jZwIC8nBSu77oXM7c0
 Ql16YW01fXUCDqGkUCjtVsDUfuNgIJgBWTcvvM6WeXcocNqvGJlBdrZRhdRtAl684A19Pd3SeXo
 hC8iNLF9NqMwZdHftIwcRRziuLA4lcxNrc8dOy561d+1ePh1vMZtXSY3bYdB4ew6JsCFKCi7+S9
 YsnMR1fUNZWIHxNdqwARBvZFKmQ9McTkGkTKTA0RWDxNmu4vQ40UdlGFuGUY+bFX08LehcmIe1N
 Js/uk7waaFKX9ikcZ1V2CiVA3GdHNc/wn+UgP/5f+sgXoGoBhUBjwpVylKJbCQ=
X-Authority-Analysis: v=2.4 cv=ePoTjGp1 c=1 sm=1 tr=0 ts=68c99400 cx=c_pps
 a=XJoAL0HPiv6B0cYJlRTKVw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8
 a=C9w7GClyFkj7WewoFlcA:9
X-Proofpoint-ORIG-GUID: kn2JsAUY4_FtixCmwG0Ioh35n6f127sP
X-Proofpoint-GUID: kn2JsAUY4_FtixCmwG0Ioh35n6f127sP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

Migrate to new vmx.h's EPT RWX defs, which makes it easier
to grok from one code base to another.

Fix a few small formatting issues along the way.

No functional change intended.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 x86/vmx.c       |  14 +--
 x86/vmx.h       |   4 -
 x86/vmx_tests.c | 245 +++++++++++++++++++++++++++++++-----------------
 3 files changed, 165 insertions(+), 98 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index e79781f2..6b7dca34 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -823,7 +823,7 @@ static void split_large_ept_entry(unsigned long *ptep, int level)
 	int i;
 
 	pte = *ptep;
-	assert(pte & EPT_PRESENT);
+	assert(pte & VMX_EPT_RWX_MASK);
 	assert(pte & EPT_LARGE_PAGE);
 	assert(level == 2 || level == 3);
 
@@ -870,15 +870,17 @@ void install_ept_entry(unsigned long *pml4,
 	for (level = EPT_PAGE_LEVEL; level > pte_level; --level) {
 		offset = (guest_addr >> EPT_LEVEL_SHIFT(level))
 				& EPT_PGDIR_MASK;
-		if (!(pt[offset] & (EPT_PRESENT))) {
+		if (!(pt[offset] & (VMX_EPT_RWX_MASK))) {
 			unsigned long *new_pt = pt_page;
 			if (!new_pt)
 				new_pt = alloc_page();
 			else
 				pt_page = 0;
 			memset(new_pt, 0, PAGE_SIZE);
-			pt[offset] = virt_to_phys(new_pt)
-					| EPT_RA | EPT_WA | EPT_EA;
+			pt[offset] = virt_to_phys(new_pt) |
+						 VMX_EPT_READABLE_MASK |
+						 VMX_EPT_WRITABLE_MASK |
+						 VMX_EPT_EXECUTABLE_MASK;
 		} else if (pt[offset] & EPT_LARGE_PAGE)
 			split_large_ept_entry(&pt[offset], level);
 		pt = phys_to_virt(pt[offset] & EPT_ADDR_MASK);
@@ -965,7 +967,7 @@ bool get_ept_pte(unsigned long *pml4, unsigned long guest_addr, int level,
 			break;
 		if (l < 4 && (iter_pte & EPT_LARGE_PAGE))
 			return false;
-		if (!(iter_pte & (EPT_PRESENT)))
+		if (!(iter_pte & (VMX_EPT_RWX_MASK)))
 			return false;
 		pt = (unsigned long *)(iter_pte & EPT_ADDR_MASK);
 	}
@@ -1089,7 +1091,7 @@ void set_ept_pte(unsigned long *pml4, unsigned long guest_addr,
 		offset = (guest_addr >> EPT_LEVEL_SHIFT(l)) & EPT_PGDIR_MASK;
 		if (l == level)
 			break;
-		assert(pt[offset] & EPT_PRESENT);
+		assert(pt[offset] & VMX_EPT_RWX_MASK);
 		pt = (unsigned long *)(pt[offset] & EPT_ADDR_MASK);
 	}
 	offset = (guest_addr >> EPT_LEVEL_SHIFT(l)) & EPT_PGDIR_MASK;
diff --git a/x86/vmx.h b/x86/vmx.h
index 9b076b0c..3f792d4a 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -578,10 +578,6 @@ enum Intr_type {
 #define EPT_MEM_TYPE_WP		5ul
 #define EPT_MEM_TYPE_WB		6ul
 
-#define EPT_RA			1ul
-#define EPT_WA			2ul
-#define EPT_EA			4ul
-#define EPT_PRESENT		(EPT_RA | EPT_WA | EPT_EA)
 #define EPT_ACCESS_FLAG		(1ul << 8)
 #define EPT_DIRTY_FLAG		(1ul << 9)
 #define EPT_LARGE_PAGE		(1ul << 7)
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index a09b687f..eda9e88a 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1101,7 +1101,9 @@ static int setup_ept(bool enable_ad)
 	 */
 	setup_ept_range(pml4, 0, end_of_memory, 0,
 			!enable_ad && ept_2m_supported(),
-			EPT_WA | EPT_RA | EPT_EA);
+			VMX_EPT_WRITABLE_MASK |
+			VMX_EPT_READABLE_MASK |
+			VMX_EPT_EXECUTABLE_MASK);
 	return 0;
 }
 
@@ -1180,7 +1182,9 @@ static int ept_init_common(bool have_ad)
 	*((u32 *)data_page1) = MAGIC_VAL_1;
 	*((u32 *)data_page2) = MAGIC_VAL_2;
 	install_ept(pml4, (unsigned long)data_page1, (unsigned long)data_page2,
-			EPT_RA | EPT_WA | EPT_EA);
+		    VMX_EPT_READABLE_MASK |
+		    VMX_EPT_WRITABLE_MASK |
+		    VMX_EPT_EXECUTABLE_MASK);
 
 	apic_version = apic_read(APIC_LVR);
 
@@ -1360,29 +1364,33 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 					*((u32 *)data_page2) == MAGIC_VAL_2) {
 				vmx_inc_test_stage();
 				install_ept(pml4, (unsigned long)data_page2,
-						(unsigned long)data_page2,
-						EPT_RA | EPT_WA | EPT_EA);
+					    (unsigned long)data_page2,
+					    VMX_EPT_READABLE_MASK |
+					    VMX_EPT_WRITABLE_MASK |
+					    VMX_EPT_EXECUTABLE_MASK);
 			} else
 				report_fail("EPT basic framework - write");
 			break;
 		case 1:
 			install_ept(pml4, (unsigned long)data_page1,
- 				(unsigned long)data_page1, EPT_WA);
+				    (unsigned long)data_page1, VMX_EPT_WRITABLE_MASK);
 			invept(INVEPT_SINGLE, eptp);
 			break;
 		case 2:
 			install_ept(pml4, (unsigned long)data_page1,
- 				(unsigned long)data_page1,
- 				EPT_RA | EPT_WA | EPT_EA |
- 				(2 << EPT_MEM_TYPE_SHIFT));
+				    (unsigned long)data_page1,
+				    VMX_EPT_READABLE_MASK |
+				    VMX_EPT_WRITABLE_MASK |
+				    VMX_EPT_EXECUTABLE_MASK |
+				    (2 << EPT_MEM_TYPE_SHIFT));
 			invept(INVEPT_SINGLE, eptp);
 			break;
 		case 3:
 			clear_ept_ad(pml4, guest_cr3, (unsigned long)data_page1);
 			TEST_ASSERT(get_ept_pte(pml4, (unsigned long)data_page1,
 						1, &data_page1_pte));
-			set_ept_pte(pml4, (unsigned long)data_page1, 
-				1, data_page1_pte & ~EPT_PRESENT);
+			set_ept_pte(pml4, (unsigned long)data_page1,
+				    1, data_page1_pte & ~VMX_EPT_RWX_MASK);
 			invept(INVEPT_SINGLE, eptp);
 			break;
 		case 4:
@@ -1391,7 +1399,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 
 			TEST_ASSERT(get_ept_pte(pml4, guest_pte_addr, 2, &data_page1_pte_pte));
 			set_ept_pte(pml4, guest_pte_addr, 2,
-				data_page1_pte_pte & ~EPT_PRESENT);
+				    data_page1_pte_pte & ~VMX_EPT_RWX_MASK);
 			invept(INVEPT_SINGLE, eptp);
 			break;
 		case 5:
@@ -1418,8 +1426,10 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 		case 2:
 			vmx_inc_test_stage();
 			install_ept(pml4, (unsigned long)data_page1,
- 				(unsigned long)data_page1,
- 				EPT_RA | EPT_WA | EPT_EA);
+				    (unsigned long)data_page1,
+				    VMX_EPT_READABLE_MASK |
+				    VMX_EPT_WRITABLE_MASK |
+				    VMX_EPT_EXECUTABLE_MASK);
 			invept(INVEPT_SINGLE, eptp);
 			break;
 		// Should not reach here
@@ -1448,7 +1458,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 					  EPT_VIOLATION_GVA_TRANSLATED))
 				vmx_inc_test_stage();
 			set_ept_pte(pml4, (unsigned long)data_page1,
-				1, data_page1_pte | (EPT_PRESENT));
+				    1, data_page1_pte | (VMX_EPT_RWX_MASK));
 			invept(INVEPT_SINGLE, eptp);
 			break;
 		case 4:
@@ -1460,7 +1470,8 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 					   EPT_VIOLATION_GVA_IS_VALID))
 				vmx_inc_test_stage();
 			set_ept_pte(pml4, guest_pte_addr, 2,
-				data_page1_pte_pte | (EPT_PRESENT));
+				    data_page1_pte_pte |
+				    (VMX_EPT_RWX_MASK));
 			invept(INVEPT_SINGLE, eptp);
 			break;
 		case 5:
@@ -1468,7 +1479,8 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 				vmx_inc_test_stage();
 			TEST_ASSERT(get_ept_pte(pml4, (unsigned long)pci_physaddr,
 						1, &memaddr_pte));
-			set_ept_pte(pml4, memaddr_pte, 1, memaddr_pte | EPT_RA);
+			set_ept_pte(pml4, memaddr_pte, 1,
+				    memaddr_pte | VMX_EPT_READABLE_MASK);
 			invept(INVEPT_SINGLE, eptp);
 			break;
 		case 6:
@@ -1476,7 +1488,9 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 				vmx_inc_test_stage();
 			TEST_ASSERT(get_ept_pte(pml4, (unsigned long)pci_physaddr,
 						1, &memaddr_pte));
-			set_ept_pte(pml4, memaddr_pte, 1, memaddr_pte | EPT_RA | EPT_WA);
+			set_ept_pte(pml4, memaddr_pte, 1,
+				    memaddr_pte | VMX_EPT_READABLE_MASK |
+				    VMX_EPT_WRITABLE_MASK);
 			invept(INVEPT_SINGLE, eptp);
 			break;
 		default:
@@ -2419,7 +2433,7 @@ static void ept_violation(unsigned long clear, unsigned long set,
 static void ept_access_violation(unsigned long access, enum ept_access_op op,
 				       u64 expected_qual)
 {
-	ept_violation(EPT_PRESENT, access, op,
+	ept_violation(VMX_EPT_RWX_MASK, access, op,
 		      expected_qual | EPT_VIOLATION_GVA_IS_VALID |
 		      EPT_VIOLATION_GVA_TRANSLATED);
 }
@@ -2489,9 +2503,9 @@ static void ept_access_paddr(unsigned long ept_access, unsigned long pte_ad,
 	 * otherwise our level=1 twiddling below will fail. We use the
 	 * identity map (gpa = gpa) since page tables are shared with the host.
 	 */
-	install_ept(pml4, gpa, gpa, EPT_PRESENT);
+	install_ept(pml4, gpa, gpa, VMX_EPT_RWX_MASK);
 	orig_epte = ept_twiddle(gpa, /*mkhuge=*/0, /*level=*/1,
-				/*clear=*/EPT_PRESENT, /*set=*/ept_access);
+				/*clear=*/VMX_EPT_RWX_MASK, /*set=*/ept_access);
 
 	if (expect_violation) {
 		do_ept_violation(/*leaf=*/true, op,
@@ -2588,7 +2602,7 @@ static void ept_ignored_bit(int bit)
 
 static void ept_access_allowed(unsigned long access, enum ept_access_op op)
 {
-	ept_allowed(EPT_PRESENT, access, op);
+	ept_allowed(VMX_EPT_RWX_MASK, access, op);
 }
 
 
@@ -2658,7 +2672,7 @@ static void ept_misconfig(unsigned long clear, unsigned long set)
 
 static void ept_access_misconfig(unsigned long access)
 {
-	ept_misconfig(EPT_PRESENT, access);
+	ept_misconfig(VMX_EPT_RWX_MASK, access);
 }
 
 static void ept_reserved_bit_at_level_nohuge(int level, int bit)
@@ -2667,7 +2681,7 @@ static void ept_reserved_bit_at_level_nohuge(int level, int bit)
 	ept_misconfig_at_level_mkhuge(false, level, 0, 1ul << bit);
 
 	/* Making the entry non-present turns reserved bits into ignored. */
-	ept_violation_at_level(level, EPT_PRESENT, 1ul << bit, OP_READ,
+	ept_violation_at_level(level, VMX_EPT_RWX_MASK, 1ul << bit, OP_READ,
 			       EPT_VIOLATION_ACC_READ |
 			       EPT_VIOLATION_GVA_IS_VALID |
 			       EPT_VIOLATION_GVA_TRANSLATED);
@@ -2679,7 +2693,7 @@ static void ept_reserved_bit_at_level_huge(int level, int bit)
 	ept_misconfig_at_level_mkhuge(true, level, 0, 1ul << bit);
 
 	/* Making the entry non-present turns reserved bits into ignored. */
-	ept_violation_at_level(level, EPT_PRESENT, 1ul << bit, OP_READ,
+	ept_violation_at_level(level, VMX_EPT_RWX_MASK, 1ul << bit, OP_READ,
 			       EPT_VIOLATION_ACC_READ |
 			       EPT_VIOLATION_GVA_IS_VALID |
 			       EPT_VIOLATION_GVA_TRANSLATED);
@@ -2691,7 +2705,7 @@ static void ept_reserved_bit_at_level(int level, int bit)
 	ept_misconfig_at_level(level, 0, 1ul << bit);
 
 	/* Making the entry non-present turns reserved bits into ignored. */
-	ept_violation_at_level(level, EPT_PRESENT, 1ul << bit, OP_READ,
+	ept_violation_at_level(level, VMX_EPT_RWX_MASK, 1ul << bit, OP_READ,
 			       EPT_VIOLATION_ACC_READ |
 			       EPT_VIOLATION_GVA_IS_VALID |
 			       EPT_VIOLATION_GVA_TRANSLATED);
@@ -2787,7 +2801,7 @@ static void ept_access_test_setup(void)
 	 */
 	TEST_ASSERT(get_ept_pte(pml4, data->gpa, 4, &pte) && pte == 0);
 	TEST_ASSERT(get_ept_pte(pml4, data->gpa + size - 1, 4, &pte) && pte == 0);
-	install_ept(pml4, data->hpa, data->gpa, EPT_PRESENT);
+	install_ept(pml4, data->hpa, data->gpa, VMX_EPT_RWX_MASK);
 
 	data->hva[0] = MAGIC_VAL_1;
 	memcpy(&data->hva[1], &ret42_start, &ret42_end - &ret42_start);
@@ -2807,10 +2821,12 @@ static void ept_access_test_read_only(void)
 	ept_access_test_setup();
 
 	/* r-- */
-	ept_access_allowed(EPT_RA, OP_READ);
-	ept_access_violation(EPT_RA, OP_WRITE, EPT_VIOLATION_ACC_WRITE |
+	ept_access_allowed(VMX_EPT_READABLE_MASK, OP_READ);
+	ept_access_violation(VMX_EPT_READABLE_MASK, OP_WRITE,
+			     EPT_VIOLATION_ACC_WRITE |
 			     EPT_VIOLATION_PROT_READ);
-	ept_access_violation(EPT_RA, OP_EXEC, EPT_VIOLATION_ACC_INSTR |
+	ept_access_violation(VMX_EPT_READABLE_MASK, OP_EXEC,
+			     EPT_VIOLATION_ACC_INSTR |
 			     EPT_VIOLATION_PROT_READ);
 }
 
@@ -2818,16 +2834,19 @@ static void ept_access_test_write_only(void)
 {
 	ept_access_test_setup();
 	/* -w- */
-	ept_access_misconfig(EPT_WA);
+	ept_access_misconfig(VMX_EPT_WRITABLE_MASK);
 }
 
 static void ept_access_test_read_write(void)
 {
 	ept_access_test_setup();
 	/* rw- */
-	ept_access_allowed(EPT_RA | EPT_WA, OP_READ);
-	ept_access_allowed(EPT_RA | EPT_WA, OP_WRITE);
-	ept_access_violation(EPT_RA | EPT_WA, OP_EXEC,
+	ept_access_allowed(VMX_EPT_READABLE_MASK | VMX_EPT_WRITABLE_MASK,
+			   OP_READ);
+	ept_access_allowed(VMX_EPT_READABLE_MASK | VMX_EPT_WRITABLE_MASK,
+			   OP_WRITE);
+	ept_access_violation(VMX_EPT_READABLE_MASK | VMX_EPT_WRITABLE_MASK,
+			     OP_EXEC,
 			     EPT_VIOLATION_ACC_INSTR |
 			     EPT_VIOLATION_PROT_READ |
 			     EPT_VIOLATION_PROT_WRITE);
@@ -2839,15 +2858,15 @@ static void ept_access_test_execute_only(void)
 	ept_access_test_setup();
 	/* --x */
 	if (ept_execute_only_supported()) {
-		ept_access_violation(EPT_EA, OP_READ,
+		ept_access_violation(VMX_EPT_EXECUTABLE_MASK, OP_READ,
 				     EPT_VIOLATION_ACC_READ |
 				     EPT_VIOLATION_PROT_EXEC);
-		ept_access_violation(EPT_EA, OP_WRITE,
+		ept_access_violation(VMX_EPT_EXECUTABLE_MASK, OP_WRITE,
 				     EPT_VIOLATION_ACC_WRITE |
 				     EPT_VIOLATION_PROT_EXEC);
-		ept_access_allowed(EPT_EA, OP_EXEC);
+		ept_access_allowed(VMX_EPT_EXECUTABLE_MASK, OP_EXEC);
 	} else {
-		ept_access_misconfig(EPT_EA);
+		ept_access_misconfig(VMX_EPT_EXECUTABLE_MASK);
 	}
 }
 
@@ -2855,28 +2874,34 @@ static void ept_access_test_read_execute(void)
 {
 	ept_access_test_setup();
 	/* r-x */
-	ept_access_allowed(EPT_RA | EPT_EA, OP_READ);
-	ept_access_violation(EPT_RA | EPT_EA, OP_WRITE,
+	ept_access_allowed(VMX_EPT_READABLE_MASK | VMX_EPT_EXECUTABLE_MASK,
+			   OP_READ);
+	ept_access_violation(VMX_EPT_READABLE_MASK | VMX_EPT_EXECUTABLE_MASK,
+			     OP_WRITE,
 			     EPT_VIOLATION_ACC_WRITE |
 			     EPT_VIOLATION_PROT_READ |
 			     EPT_VIOLATION_PROT_EXEC);
-	ept_access_allowed(EPT_RA | EPT_EA, OP_EXEC);
+	ept_access_allowed(VMX_EPT_READABLE_MASK | VMX_EPT_EXECUTABLE_MASK,
+			   OP_EXEC);
 }
 
 static void ept_access_test_write_execute(void)
 {
 	ept_access_test_setup();
 	/* -wx */
-	ept_access_misconfig(EPT_WA | EPT_EA);
+	ept_access_misconfig(VMX_EPT_WRITABLE_MASK | VMX_EPT_EXECUTABLE_MASK);
 }
 
 static void ept_access_test_read_write_execute(void)
 {
 	ept_access_test_setup();
 	/* rwx */
-	ept_access_allowed(EPT_RA | EPT_WA | EPT_EA, OP_READ);
-	ept_access_allowed(EPT_RA | EPT_WA | EPT_EA, OP_WRITE);
-	ept_access_allowed(EPT_RA | EPT_WA | EPT_EA, OP_EXEC);
+	ept_access_allowed(VMX_EPT_READABLE_MASK | VMX_EPT_WRITABLE_MASK |
+			   VMX_EPT_EXECUTABLE_MASK, OP_READ);
+	ept_access_allowed(VMX_EPT_READABLE_MASK | VMX_EPT_WRITABLE_MASK |
+			   VMX_EPT_EXECUTABLE_MASK, OP_WRITE);
+	ept_access_allowed(VMX_EPT_READABLE_MASK | VMX_EPT_WRITABLE_MASK |
+			   VMX_EPT_EXECUTABLE_MASK, OP_EXEC);
 }
 
 static void ept_access_test_reserved_bits(void)
@@ -2989,17 +3014,20 @@ static void ept_access_test_paddr_read_only_ad_disabled(void)
 	ept_disable_ad_bits();
 
 	/* Can't update A bit, so all accesses fail. */
-	ept_access_violation_paddr(EPT_RA, 0, OP_READ, qual);
-	ept_access_violation_paddr(EPT_RA, 0, OP_WRITE, qual);
-	ept_access_violation_paddr(EPT_RA, 0, OP_EXEC, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK, 0, OP_READ, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK, 0, OP_WRITE, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK, 0, OP_EXEC, qual);
 	/* AD bits disabled, so only writes try to update the D bit. */
-	ept_access_allowed_paddr(EPT_RA, PT_ACCESSED_MASK, OP_READ);
-	ept_access_violation_paddr(EPT_RA, PT_ACCESSED_MASK, OP_WRITE, qual);
-	ept_access_allowed_paddr(EPT_RA, PT_ACCESSED_MASK, OP_EXEC);
+	ept_access_allowed_paddr(VMX_EPT_READABLE_MASK, PT_ACCESSED_MASK,
+				 OP_READ);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK, PT_ACCESSED_MASK,
+				   OP_WRITE, qual);
+	ept_access_allowed_paddr(VMX_EPT_READABLE_MASK, PT_ACCESSED_MASK,
+				 OP_EXEC);
 	/* Both A and D already set, so read-only is OK. */
-	ept_access_allowed_paddr(EPT_RA, PT_AD_MASK, OP_READ);
-	ept_access_allowed_paddr(EPT_RA, PT_AD_MASK, OP_WRITE);
-	ept_access_allowed_paddr(EPT_RA, PT_AD_MASK, OP_EXEC);
+	ept_access_allowed_paddr(VMX_EPT_READABLE_MASK, PT_AD_MASK, OP_READ);
+	ept_access_allowed_paddr(VMX_EPT_READABLE_MASK, PT_AD_MASK, OP_WRITE);
+	ept_access_allowed_paddr(VMX_EPT_READABLE_MASK, PT_AD_MASK, OP_EXEC);
 }
 
 static void ept_access_test_paddr_read_only_ad_enabled(void)
@@ -3015,33 +3043,42 @@ static void ept_access_test_paddr_read_only_ad_enabled(void)
 	ept_access_test_setup();
 	ept_enable_ad_bits_or_skip_test();
 
-	ept_access_violation_paddr(EPT_RA, 0, OP_READ, qual);
-	ept_access_violation_paddr(EPT_RA, 0, OP_WRITE, qual);
-	ept_access_violation_paddr(EPT_RA, 0, OP_EXEC, qual);
-	ept_access_violation_paddr(EPT_RA, PT_ACCESSED_MASK, OP_READ, qual);
-	ept_access_violation_paddr(EPT_RA, PT_ACCESSED_MASK, OP_WRITE, qual);
-	ept_access_violation_paddr(EPT_RA, PT_ACCESSED_MASK, OP_EXEC, qual);
-	ept_access_violation_paddr(EPT_RA, PT_AD_MASK, OP_READ, qual);
-	ept_access_violation_paddr(EPT_RA, PT_AD_MASK, OP_WRITE, qual);
-	ept_access_violation_paddr(EPT_RA, PT_AD_MASK, OP_EXEC, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK, 0, OP_READ, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK, 0, OP_WRITE, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK, 0, OP_EXEC, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK, PT_ACCESSED_MASK,
+				   OP_READ, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK, PT_ACCESSED_MASK,
+				   OP_WRITE, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK, PT_ACCESSED_MASK,
+				   OP_EXEC, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK, PT_AD_MASK, OP_READ,
+				   qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK, PT_AD_MASK, OP_WRITE,
+				   qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK, PT_AD_MASK, OP_EXEC,
+				   qual);
 }
 
 static void ept_access_test_paddr_read_write(void)
 {
 	ept_access_test_setup();
 	/* Read-write access to paging structure. */
-	ept_access_allowed_paddr(EPT_RA | EPT_WA, 0, OP_READ);
-	ept_access_allowed_paddr(EPT_RA | EPT_WA, 0, OP_WRITE);
-	ept_access_allowed_paddr(EPT_RA | EPT_WA, 0, OP_EXEC);
+	ept_access_allowed_paddr(VMX_EPT_READABLE_MASK | VMX_EPT_WRITABLE_MASK, 0,
+				 OP_READ);
+	ept_access_allowed_paddr(VMX_EPT_READABLE_MASK | VMX_EPT_WRITABLE_MASK, 0,
+				 OP_WRITE);
+	ept_access_allowed_paddr(VMX_EPT_READABLE_MASK | VMX_EPT_WRITABLE_MASK, 0,
+				 OP_EXEC);
 }
 
 static void ept_access_test_paddr_read_write_execute(void)
 {
 	ept_access_test_setup();
 	/* RWX access to paging structure. */
-	ept_access_allowed_paddr(EPT_PRESENT, 0, OP_READ);
-	ept_access_allowed_paddr(EPT_PRESENT, 0, OP_WRITE);
-	ept_access_allowed_paddr(EPT_PRESENT, 0, OP_EXEC);
+	ept_access_allowed_paddr(VMX_EPT_RWX_MASK, 0, OP_READ);
+	ept_access_allowed_paddr(VMX_EPT_RWX_MASK, 0, OP_WRITE);
+	ept_access_allowed_paddr(VMX_EPT_RWX_MASK, 0, OP_EXEC);
 }
 
 static void ept_access_test_paddr_read_execute_ad_disabled(void)
@@ -3059,17 +3096,31 @@ static void ept_access_test_paddr_read_execute_ad_disabled(void)
 	ept_disable_ad_bits();
 
 	/* Can't update A bit, so all accesses fail. */
-	ept_access_violation_paddr(EPT_RA | EPT_EA, 0, OP_READ, qual);
-	ept_access_violation_paddr(EPT_RA | EPT_EA, 0, OP_WRITE, qual);
-	ept_access_violation_paddr(EPT_RA | EPT_EA, 0, OP_EXEC, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK |
+				   VMX_EPT_EXECUTABLE_MASK, 0, OP_READ, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK |
+				   VMX_EPT_EXECUTABLE_MASK, 0, OP_WRITE,
+				   qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK |
+				   VMX_EPT_EXECUTABLE_MASK, 0, OP_EXEC,
+				   qual);
 	/* AD bits disabled, so only writes try to update the D bit. */
-	ept_access_allowed_paddr(EPT_RA | EPT_EA, PT_ACCESSED_MASK, OP_READ);
-	ept_access_violation_paddr(EPT_RA | EPT_EA, PT_ACCESSED_MASK, OP_WRITE, qual);
-	ept_access_allowed_paddr(EPT_RA | EPT_EA, PT_ACCESSED_MASK, OP_EXEC);
+	ept_access_allowed_paddr(VMX_EPT_READABLE_MASK |
+				 VMX_EPT_EXECUTABLE_MASK, PT_ACCESSED_MASK,
+				 OP_READ);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK |
+				   VMX_EPT_EXECUTABLE_MASK, PT_ACCESSED_MASK,
+				   OP_WRITE, qual);
+	ept_access_allowed_paddr(VMX_EPT_READABLE_MASK |
+				 VMX_EPT_EXECUTABLE_MASK, PT_ACCESSED_MASK,
+				 OP_EXEC);
 	/* Both A and D already set, so read-only is OK. */
-	ept_access_allowed_paddr(EPT_RA | EPT_EA, PT_AD_MASK, OP_READ);
-	ept_access_allowed_paddr(EPT_RA | EPT_EA, PT_AD_MASK, OP_WRITE);
-	ept_access_allowed_paddr(EPT_RA | EPT_EA, PT_AD_MASK, OP_EXEC);
+	ept_access_allowed_paddr(VMX_EPT_READABLE_MASK |
+				 VMX_EPT_EXECUTABLE_MASK, PT_AD_MASK, OP_READ);
+	ept_access_allowed_paddr(VMX_EPT_READABLE_MASK |
+				 VMX_EPT_EXECUTABLE_MASK, PT_AD_MASK, OP_WRITE);
+	ept_access_allowed_paddr(VMX_EPT_READABLE_MASK |
+				 VMX_EPT_EXECUTABLE_MASK, PT_AD_MASK, OP_EXEC);
 }
 
 static void ept_access_test_paddr_read_execute_ad_enabled(void)
@@ -3085,15 +3136,31 @@ static void ept_access_test_paddr_read_execute_ad_enabled(void)
 	ept_access_test_setup();
 	ept_enable_ad_bits_or_skip_test();
 
-	ept_access_violation_paddr(EPT_RA | EPT_EA, 0, OP_READ, qual);
-	ept_access_violation_paddr(EPT_RA | EPT_EA, 0, OP_WRITE, qual);
-	ept_access_violation_paddr(EPT_RA | EPT_EA, 0, OP_EXEC, qual);
-	ept_access_violation_paddr(EPT_RA | EPT_EA, PT_ACCESSED_MASK, OP_READ, qual);
-	ept_access_violation_paddr(EPT_RA | EPT_EA, PT_ACCESSED_MASK, OP_WRITE, qual);
-	ept_access_violation_paddr(EPT_RA | EPT_EA, PT_ACCESSED_MASK, OP_EXEC, qual);
-	ept_access_violation_paddr(EPT_RA | EPT_EA, PT_AD_MASK, OP_READ, qual);
-	ept_access_violation_paddr(EPT_RA | EPT_EA, PT_AD_MASK, OP_WRITE, qual);
-	ept_access_violation_paddr(EPT_RA | EPT_EA, PT_AD_MASK, OP_EXEC, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK |
+				   VMX_EPT_EXECUTABLE_MASK, 0, OP_READ, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK |
+				   VMX_EPT_EXECUTABLE_MASK, 0, OP_WRITE,
+				   qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK |
+				   VMX_EPT_EXECUTABLE_MASK, 0, OP_EXEC, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK |
+				   VMX_EPT_EXECUTABLE_MASK, PT_ACCESSED_MASK,
+				   OP_READ, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK |
+				   VMX_EPT_EXECUTABLE_MASK, PT_ACCESSED_MASK,
+				   OP_WRITE, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK |
+				   VMX_EPT_EXECUTABLE_MASK, PT_ACCESSED_MASK,
+				   OP_EXEC, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK |
+				   VMX_EPT_EXECUTABLE_MASK, PT_AD_MASK,
+				   OP_READ, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK |
+				   VMX_EPT_EXECUTABLE_MASK, PT_AD_MASK,
+				   OP_WRITE, qual);
+	ept_access_violation_paddr(VMX_EPT_READABLE_MASK |
+				   VMX_EPT_EXECUTABLE_MASK, PT_AD_MASK,
+				   OP_EXEC, qual);
 }
 
 static void ept_access_test_paddr_not_present_page_fault(void)
@@ -3113,12 +3180,14 @@ static void ept_access_test_force_2m_page(void)
 
 	TEST_ASSERT_EQ(ept_2m_supported(), true);
 	ept_allowed_at_level_mkhuge(true, 2, 0, 0, OP_READ);
-	ept_violation_at_level_mkhuge(true, 2, EPT_PRESENT, EPT_RA, OP_WRITE,
+	ept_violation_at_level_mkhuge(true, 2, VMX_EPT_RWX_MASK,
+				      VMX_EPT_READABLE_MASK, OP_WRITE,
 				      EPT_VIOLATION_ACC_WRITE |
 				      EPT_VIOLATION_PROT_READ |
 				      EPT_VIOLATION_GVA_IS_VALID |
 				      EPT_VIOLATION_GVA_TRANSLATED);
-	ept_misconfig_at_level_mkhuge(true, 2, EPT_PRESENT, EPT_WA);
+	ept_misconfig_at_level_mkhuge(true, 2, VMX_EPT_RWX_MASK,
+				      VMX_EPT_WRITABLE_MASK);
 }
 
 static bool invvpid_valid(u64 type, u64 vpid, u64 gla)
-- 
2.43.0


