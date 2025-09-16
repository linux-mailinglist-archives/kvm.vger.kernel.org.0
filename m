Return-Path: <kvm+bounces-57741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D207CB59E03
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:45:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 585AD326BEE
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:45:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 045D927F16A;
	Tue, 16 Sep 2025 16:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="KEDhePl4";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Jc4XoLnE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7ED531E8B6
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041095; cv=fail; b=Sq/n08MqkEFEj5tk5RDE2E89x5flEYOtRDyFXfp4Put3nloYdo3RJ/fGLXJJxrXiFYCYsz7Ia/nuzjGDALciJKcVXkmJsdPBQA/24G824drTSeUzQ9zus5CK5P6kUhveLlcjYfbTR9NoaLBTIJSjNG7xDWMjroD4GPnoHY7eoSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041095; c=relaxed/simple;
	bh=c87tMbRAgkLP11Gliy6WoY/RADolqSp/988WFL5FkHA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Pe6AHGAUvUbwqa/Bpur5Hiu/WVS2qlLSeOD6V3x8gBjCQisL1nf8wiFp6PD1rj74mxRKc4SXci3q1yVyzj14rH0/vHqqMyynRsXRcP8Vq6OQNWnad6Tw+OnGYfgSOEypYWWsBZqPCfD7mvxlgF6Ij2Zp9jf4cnyeTtTHJrmc8ig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=KEDhePl4; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Jc4XoLnE; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58G8mwEF3768189;
	Tue, 16 Sep 2025 09:44:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=ggTUqBb8+uTmU
	b6yFXomM19R0c+awCILTdCNaCwrK0E=; b=KEDhePl46/kNW9cMO5jhpti93uv4i
	JDPZLKAA5x+y4pPV/ygTt3B0JvavFI61CHfO6fLUrtm5DJugPcCuIa9GIEnEEOvc
	uwI7XAyaDsFu9vr5YAIhpqtrjMLr17w0kB/jGIgU5Kyf2ylOMGWvp/9R9a/JrL60
	9O+I6fr/PBU0pTeXwpd8NqcyLU7u3BTDhDFNY1ty+JClqPklx255d0Ah0cY6VPMi
	aXdYeTah6hzoY/85zC54Ww9rI3orNBJeVMACSTYwj8VoVuLr6IjuBm03KmV5tnQU
	qXC7C5TxpnhCefEnTcVX9tK5liFdYPPPOAFLRtRT+O/OXnzoIO8HmZYyw==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023143.outbound.protection.outlook.com [40.93.201.143])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 496uaq287s-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:44:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CioJSQsqnkRQl/aYGsXldaGNp6ake9ZevdosTba4Erm546OMMKxBUiKqOc6gkYu1UvA4w4k4/aiWY+3uriubO9Qb5fYr/b1VOknqr8bjqSfDveta9B+Fzv5I8hVWn12hZb9KVxGq42ZFVveqqMYTl19UxaKNKJ54wQAoQc7c7I7zUHD44ZMhq5UyhxFvz7FvOg6/Ll97yUeCCdR+yKRCYKB/i6vyDvrgrSCSJ6DMcJ1cHAI8lLw0SbzVV9l3hRNRY2aCO+nFT+54ZRTnnAaa7zF3QWmIgq7iNDQQwTSaEKoPeiomnZDQ3ehQE4HVUOZoG36ONIZL6h88fjATj7Ghng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ggTUqBb8+uTmUb6yFXomM19R0c+awCILTdCNaCwrK0E=;
 b=ig6As5Bn3BD45AXWM/ELWZ0KDi3ph9y5kg8lPsi9jW/sewLKHuVgdlO2529QFzWhumkHjL2nyKprNUdA9UXjkXY5dqhuHCXmmhLtyVzB2lPrAMUgBuDKU6lx76kr1HjGVsjnjphOeSb3gLJ7BMRBvJ7fgj2EZZZL/gFWohYWeU51j2DEhcFZ1m4z5Ramw/1NSCuEBuWI95FmF2Mz00AE4rkH+DHmrYvCsvQhupOMrS28cfCA7iwLj3ErWVF38NsISrevEaCg+i17SofpB6SPtj53g4T4bgqgHSSeEdIHV9XPAsAqPB9ef3fTggBQe4mhEB5NAqKF39faBq1FFbf05g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggTUqBb8+uTmUb6yFXomM19R0c+awCILTdCNaCwrK0E=;
 b=Jc4XoLnE8XvmpbuUva0bW7y4EWshEZCXv/itZiUTQUJAJ/4I3aet8OUjntrTqhs7G7Szc7v9KjLlfSFtcwVWFywMYBHbPyUVZe+V1tMvXPIjIuEP4j7e+mpYtV3MaY7iZUSvXnTOv+Xe0U4gSmsluLF8QYX1hi3YJkoyLpqa5EvLKKYRRrVRuUWOh8RcErN4qPUyPRa8nzs0mYMY7YVpJM8YITBFhsuNylvM/hDZT/HuEWksphIgDfCUPQf/anqHo14PbgpgwNXu1NNuHLxL7xZFK8HyXchAez5oG3egMlpc14cnEPXvTRyZ3t0rAqz1XMEoJfjF8dqVOT3wmtHhJw==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DS0PR02MB9620.namprd02.prod.outlook.com
 (2603:10b6:8:f7::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 16:44:40 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:44:40 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 00/17] x86/vmx: align with Linux kernel VMX definitions
Date: Tue, 16 Sep 2025 10:22:29 -0700
Message-ID: <20250916172247.610021-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-Office365-Filtering-Correlation-Id: ea797dc7-2622-4600-1838-08ddf540547f
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BNAniBQmPX6UOz7xRd6itKPmRsdrQSVANqWRMj/UdJflfVoI4ikbf2D7n01Z?=
 =?us-ascii?Q?CuINplFfHBryByGxRwpG29iay0+T4nMfR/p7NeOawUMCySdl5nVbE3j/NP2l?=
 =?us-ascii?Q?xgf+PE6azZIXyrKIPnXkKOyl68BS1JDsEocxlYOz4EbyWAt3RLk5HwhS/So6?=
 =?us-ascii?Q?/TC1SCxXrMCrQzltgOKLjP6IeYk5/Bu21bZFLFEEnoRm4MPEQkKlNlr5NNYH?=
 =?us-ascii?Q?X2SMQ1aPKyTz6vwJdSUy8xq6nLFa6eWumQ08frEabpWS0B65GfEhlK41DFwQ?=
 =?us-ascii?Q?uVBbGgdG066Jj0pHfIwL/szug3cN2uERMIXPhDqnoQseEGyX2BAUhCpotVyT?=
 =?us-ascii?Q?6rUczDlhlr/4b4S4hJywrEUAheiWv03e9srrO7F+VcYCQTPDOhFsK/bTYkRY?=
 =?us-ascii?Q?5MnYB1KQFZ6qL4yLRTvrml0qVPUEAc9ZtY9OoyTZBt3gbUyvn09JLcj3j+AJ?=
 =?us-ascii?Q?Scf3dDsNf+YV64bnAbKkNI2ydsbA+w71m1Vjjd/+0XSgqDcnB0u02UFw7KR0?=
 =?us-ascii?Q?F6mU6XKm+ur/gxI2FzpoIZUF6nt516YRtTHVIK3zmbL1ntE36SYwlWstfkcB?=
 =?us-ascii?Q?gZZoy/P6D/mJRicTkLPZLBwKuJN4fcrcfvpawh7L1zctoW7FeEusARsLnwJS?=
 =?us-ascii?Q?KSsEWGBOncYokTDRdxeWXQOkc+sWQFNl14VD8ccra2vbSft17l3wwjH+WI1U?=
 =?us-ascii?Q?2ZxiUWRbjmIEKAjgVrucMTC8VVE3l0AGvTBzngJbzc3WyTk3RIcQ1QKmvtzu?=
 =?us-ascii?Q?p4FjoUB5/Kp8cwFP2tw806Kjw0z6kNfjhtKxfrIcbKoh2R6R0M2L3ufPS0bq?=
 =?us-ascii?Q?yLkjrbF+dfyZo5scY6PT5LaTdBQblWj3i73w7y+RzP6aGCLD7p/EUL862DUw?=
 =?us-ascii?Q?oAmqjSbkvz2BSToIzlemCdjaoo/usriM//qarItgAbjXoYq5INap9bJL3S5x?=
 =?us-ascii?Q?1B/no8GO6WXgcCZ6oKxIoSgQ8+AHg935T29IPLz1Xw0B/yNbxjpSLU58eeZS?=
 =?us-ascii?Q?Uw3piQUcAaX8kxdsEl648zI/m2Q9bsA2f60nPf1pvFz6/2qq0mP1P81M4NFX?=
 =?us-ascii?Q?lpClLGSfO/7LwGOhyvqdeDcHMDbo53uzyGU3lg87T+pJvnhVU8sdzQkFQc/a?=
 =?us-ascii?Q?mLZnF/83hz1Vgvg7c1ReCQsv+eElrz0hn/wTziaX4pdGOcCdQIQIAR/KfOaZ?=
 =?us-ascii?Q?rgsH7WAq5TZ9+UKYc/waeYZJpznAFtVLsnMkb2vnYxfd3oUJYpVzKXmueBO9?=
 =?us-ascii?Q?Bi1/cfqsIGJ13ny3fTCPSo3DitUSjCO5MJkEn/1ZvYbrchz+kadMCCVoLJ48?=
 =?us-ascii?Q?z5xqskbdAgt/y09+oXkSkPDSn0V5LDhi72RMyjbMU76/hQNmfN7ANWdPviHB?=
 =?us-ascii?Q?rGT4XyCGU+KfND4P3qLEAwopM155DRLBmpPShNxtcnanxFzE5SEEYZYpmg4k?=
 =?us-ascii?Q?aQLOEUhFzm6dAt2DgTz48fmOs+PhsL7i+pLCq2/gGZh5YbfjXj8GKQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pe20/iFtZf0QiYdfMxC6OjZePklHah5k7CT8JoNvhcthxTBlAHutbZMZmeu1?=
 =?us-ascii?Q?oU9wsmfn+DqNMktywF9NbW5b3f0lJGYeTFbmgj5249uORceBeQoY40/jd4w3?=
 =?us-ascii?Q?xlJQchh6ydbWv4RoY8DZ9Lj+RESPFez832ElGyc/docezGAwGHoKIkQcm0rJ?=
 =?us-ascii?Q?fMCAHjkpVzZm2X+AU8g/b794cJhQ3jheWVGNCV8LQYGLnb/CmFX8xVYoTdqo?=
 =?us-ascii?Q?BLhTb+BSrVK7BDWkMB/a5sHWKWwCno7mAD9dtyZl0gT2nSfwWtHGRbZDEZzl?=
 =?us-ascii?Q?tvoGXrB0KEXs+eZ7xY5uxwZmRIOHJ0+M7GWbPYWGbBmUtiWxqUZFvsdmaUKz?=
 =?us-ascii?Q?BlNQ2CbCPUwbdUYpullZ37p57810ACHNg3U8RuCleGL6YwJapI8s5L6EPi5A?=
 =?us-ascii?Q?iLONCQ2NGEncNJyz8u/83vTYfhM/qzIFvaEnpJZLF03j8zohH4hfoKlDP+oc?=
 =?us-ascii?Q?7gi9zasWMd0xtwkZMuTB2MYY6WE4CKXI6ImP5vRtlHMcEqjx2deTAwhpyOu8?=
 =?us-ascii?Q?mqw4MvQacxyj0c1WCn6WEOCSStLcxbMdiopMu9BFtVG0a97tNTLNEcRbrc+F?=
 =?us-ascii?Q?ilBQK+1mvCUhOeadEFg9+6MGqT+XZckSqDyfgwh4jk2NWfGchaHnNU/O4u/Z?=
 =?us-ascii?Q?wjbCeG/BDOqtyyWsrECZU1CrVKslMKuLm2ur79bQItver5am29qtJoXNwNJA?=
 =?us-ascii?Q?UC3HexNi+/MlmE5Xgt5jXSSXo80OXtAzI40KL4vIk5ji4GnJxCYXFkgSETTg?=
 =?us-ascii?Q?FQW0aEDP3y+CBjRLd6o1TgYTvZpFwG6HzaYangSZ6aNvRRFnEUrZFnjWMYOp?=
 =?us-ascii?Q?7wiGls/eikavY/e2L/YlwZOS8M44aT16ElcMmABVjL/WtzuFmliUrEVHZrAl?=
 =?us-ascii?Q?Z5Y9KrIc+laUKbiMRDNKzVhcn5oI2mtbbhmAbsJVL3yqVPXzZYxEGglfMnWO?=
 =?us-ascii?Q?cHQXu85qCrr2tre4CVLubiWqDdx3OrMg1BbV9uZoCWrXaGAEi3hhuFu4YkxK?=
 =?us-ascii?Q?ko8niC6wBvl3+sctDachpnFqVM6GvSKT9jfkIJybKwFmEsuRlc55qniNAqH/?=
 =?us-ascii?Q?kCghfLVaKOC4yiR4fvASKJTlWpv/05H3KSYHZKPd7Hr9T+6s5LeR2bIm2WaX?=
 =?us-ascii?Q?w8MAyTsHe4hzj/i+Z7+isEl4jXwVGqU7d28NGH02ESQnY2qZjcbYZ4706BtX?=
 =?us-ascii?Q?YjtiX1i1Uijacqj+rbnre6x5I/E8i1FFx3yAArM4NopOuciH8pssYRmItszj?=
 =?us-ascii?Q?KbMW7sZuOZkAkLVDvOlBXXjCIhZKRddkPEqJjHgREwGGmfdXUqCcniRkEp6I?=
 =?us-ascii?Q?8wj4zfGL6h65A1UKOXSQPYgTVQniU3im8chbbxia32eck2TOf6lwZGB57GW3?=
 =?us-ascii?Q?wwotDwi/DbWuNtWg5+Oz+SNReKHnxbne7qz8ENEPCdHs4BgvOrUUtUOHrOYK?=
 =?us-ascii?Q?OQEPg7gUZj++tVtRtIadJI4UN/5ZsXmblDVMBdZNVfQBzFfKsgRZ2fBNCNWv?=
 =?us-ascii?Q?n8fhCPDbTJLAR4ev2Xyf+SuhUw3y/n78ZRj+st/SmT8zl02Xc6P7LQRJyXze?=
 =?us-ascii?Q?eZiwDHPoXg5MlgT//bQUPd1gtBwIfpYf2hCRObAcgArnSl7LdkruUY5vjg8n?=
 =?us-ascii?Q?Yg=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea797dc7-2622-4600-1838-08ddf540547f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:44:40.2577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kpj9HXFBjVVyBl1JrpOJxpO8E2u/npmflGg9//htNkwuHZtJdQlvQ2hht1GCwJqgUEQjrR58nVxqaUyaxIAv2syxjZOPZ6NPtrH5orlu4UU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9620
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDE1NSBTYWx0ZWRfX7tRWXYQfvE5z
 WswdKtuGWfOjBGqq702GYN8VqMXAJo+/Eg94CDlQ8cgmgRyOnoO2ttuxwOO8euA8/I/oWTyfce4
 tGvy+lp1ID69Wx/cWYqldu6uHDfUV4OlYYP2yf936TNauGv6K4bxGt7Jnb5scSRky2b0IzuT63R
 T856H5Pr7iY+u5cLJTHiag1vAhNWeSDgh3nan87VHBjLD9fXL5z09d61fG8ZpwiGGtJoe7yS4VS
 18GfaJ/oY/74wfllX1qNLfYNmmMpdQ4kbk8AzlP7IY2qCOXCAqSW3Yma7znRjCSIP7LrXd7v1G1
 2cJ7W2vLjG62GyOfeUYWMzj+B0MpsjcVW/qJpCWtEdeWETgaVYHXc9Tj13/+U4=
X-Authority-Analysis: v=2.4 cv=Qppe3Uyd c=1 sm=1 tr=0 ts=68c993fa cx=c_pps
 a=ZOsnctmsBCw54sLOPzIoIA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10
 a=H-4V5jwbPzjDMspKX1UA:9
X-Proofpoint-GUID: pYgdgcgKB6ImGFoXeDv077YveVsWmHYa
X-Proofpoint-ORIG-GUID: pYgdgcgKB6ImGFoXeDv077YveVsWmHYa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

This series modernizes VMX definitions to align with the canonical ones
within Linux kernel source. Currently, kvm-unit-tests uses custom VMX
constant definitions that have grown organically and have diverged from
the kernel, increasing the overhead to grok from one code base to
another.

This alignment provides several benefits:
- Reduces maintenance overhead by using authoritative definitions
- Eliminates potential bugs from definition mismatches
- Makes the test suite more consistent with kernel code
- Simplifies future updates when new VMX features are added

Given the lines touched, I've broken this up into two groups within the
series:

Group 1: Import various headers from Linux kernel 6.16 (P01-04)

Headers were brought in with minimal adaptation outside of minor tweaks
for includes, etc.

Group 2: Mechanically replace existing constants with equivalents (P05-17)

Replace custom VMX constant definitions in x86/vmx.h with Linux kernel
equivalents from lib/linux/vmx.h. This systematic replacement covers:

- Pin-based VM-execution controls (PIN_* -> PIN_BASED_*)
- CPU-based VM-execution controls (CPU_* -> CPU_BASED_*, SECONDARY_EXEC_*)
- VM-exit controls (EXI_* -> VM_EXIT_*)
- VM-entry controls (ENT_* -> VM_ENTRY_*)
- VMCS field names (custom enum -> standard Linux enum)
- VMX exit reasons (VMX_* -> EXIT_REASON_*)
- Interrupt/exception type definitions

All functional behavior is preserved - only the constant names and
values change to match Linux kernel definitions. All existing VMX tests
pass with no functional changes.

There is still a bit of bulk in x86/vmx.h, which can be addressed in
future patches as needed.

Jon Kohler (17):
  lib: add linux vmx.h clone from 6.16
  lib: add linux trapnr.h clone from 6.16
  lib: add vmxfeatures.h clone from 6.16
  lib: define __aligned() in compiler.h
  x86/vmx: basic integration for new vmx.h
  x86/vmx: switch to new vmx.h EPT violation defs
  x86/vmx: switch to new vmx.h EPT RWX defs
  x86/vmx: switch to new vmx.h EPT access and dirty defs
  x86/vmx: switch to new vmx.h EPT capability and memory type defs
  x86/vmx: switch to new vmx.h primary processor-based VM-execution
    controls
  x86/vmx: switch to new vmx.h secondary execution control bit
  x86/vmx: switch to new vmx.h secondary execution controls
  x86/vmx: switch to new vmx.h pin based VM-execution controls
  x86/vmx: switch to new vmx.h exit controls
  x86/vmx: switch to new vmx.h entry controls
  x86/vmx: switch to new vmx.h interrupt defs
  x86/vmx: align exit reasons with Linux uapi

 lib/linux/compiler.h    |    1 +
 lib/linux/trapnr.h      |   44 ++
 lib/linux/vmx.h         |  672 ++++++++++++++++++
 lib/linux/vmxfeatures.h |   93 +++
 lib/x86/msr.h           |   14 +
 x86/vmx.c               |  230 +++---
 x86/vmx.h               |  356 ++--------
 x86/vmx_tests.c         | 1489 ++++++++++++++++++++++-----------------
 8 files changed, 1876 insertions(+), 1023 deletions(-)
 create mode 100644 lib/linux/trapnr.h
 create mode 100644 lib/linux/vmx.h
 create mode 100644 lib/linux/vmxfeatures.h

base-commit: 890498d834b68104e79b57a801fa11fc6ce82846

-- 
2.43.0


