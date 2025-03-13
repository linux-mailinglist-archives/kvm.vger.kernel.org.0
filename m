Return-Path: <kvm+bounces-40994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2302AA6021C
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:13:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46C08163FA5
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:13:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C7181F8BDA;
	Thu, 13 Mar 2025 20:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="gQafNbnj";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="fm5qT+/E"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DCB1F582B;
	Thu, 13 Mar 2025 20:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896642; cv=fail; b=I8fKAN20PB2sxnOPLXAepcZ8RUW6KsKgBWBhy0SZEhEADwjqL3hwlkmx0udhJZvMyo7u13NW7N6/euU96KrMLvzBHUQxavQKTic2yXwUjakJ6F/0htFZVpUV62UENoSG2m8mioPAFnIt4X5ccqz++a3vJ/DIj+u0fYY98LT+oc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896642; c=relaxed/simple;
	bh=qPq3uiciwPy9xSSj1fNCH5NNuqq6XOe1LFoHM/Hw42U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YZWPzblVSNhsl/tA7TFzDCWpE1jmpu5smgBkIbInBYkGo9oW4UNkZTSsM8yp+kjfBx9j+fRqqxYUW6v8BSKyACJFXHwoSg8Qb7JKAU0E2L4UrzgeuezirVzUDQNK3FUUs3+UBAbaeFNt+1aXUogPpNOebBJEWDWjwYzJANRWd4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=gQafNbnj; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=fm5qT+/E; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DFGSCD016569;
	Thu, 13 Mar 2025 13:10:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=kJVutqTH03O3kvuXtc7biB/LkKoLfuaHXGI04NdTw
	Us=; b=gQafNbnjbdlYeojI6WzdTX+fun13vjWmXaHVsSVYsWn4wAOy/wHOEDiQr
	GgbBDmG0W8TNq9U8aMQSw7iPUSp1o9GjpKU3HxUvIlNg+RjE/TiAk40xU3fOnoAN
	YwegJyks2gqfJmKu2vIAX6VvmvEn35VLP31Ojrj/FX2sV8Etkq6FxzSWX/1Ss1tt
	Z06rTclEDOoux/r+C+2CIOU2zo65nzM3y4w4KH1yze0plTjUR/lShzOxB+1D++NW
	s4m+AynPaR4d5byiFCjKph4LEhMUCegCWsWNBeT2HSv07Yfmof2q2NfrlfdUxhii
	6JKYuptkerIHQ7V47PXsyovQqDC2w==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azlp17011030.outbound.protection.outlook.com [40.93.12.30])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45au9ep6t5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 13:10:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Em2hQgoK3tJ2n9TxlBlrHZ2wnELGWAibGngu+9jANAP1zvLGXgTWK7/DwaeCutnSvhAm8ys4UtojlXusgR6U7aF9e9Ru33AH2tBQEUQhuWm6ypKIyk+HA2YQtxNRdgGHIbFb2rt00iCNpBxC+rwmca0TrvhVL29WrbNTsT+NBLTGG8sWpThEu21RovMPNvqhrRVWYSzD3yiyIqQrgHdqgSfJXHFsoZN1NPqTaBQwTT4HZtCv47hXRQ47HVvOFsezFgA0FPoJaKoVNzhv9GBAWdGGu9U2UxG43kXBBasTWbUdpfBu5Y+8n0VRQx3lPEPPxbFPag2BkHRhGY1t033OHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kJVutqTH03O3kvuXtc7biB/LkKoLfuaHXGI04NdTwUs=;
 b=U+kUrBNQKdE3Nb4JTuTmhWFETxADS9jQMg6/jt5PT/N0mhtabgsZeC4T17/iTbopublQqDi4V1oQLxnx0vm2MO6oGOns/NrvGmC9Fou4R2ROkDaPrAY7d1nCNbug/N5gUOeJoVG4HYgBrXeB0OruFD6qrkek6jvcTQKiZ/af4Ifrn5UYazeEnaaXGk12y5jvCOMYX/+YPsPz7v/F9tKa7o+K/nh1maoYUFblLhtymGJK7bUlgg7ItMgcuj+RTdg4ChI8A0lDpHqetenOOyyqEewagPxLhfqXddIOv91x6LsZsrEjyxLlmGpHsITbtPHP/Dlchf00nlD6UbUkXTHOaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJVutqTH03O3kvuXtc7biB/LkKoLfuaHXGI04NdTwUs=;
 b=fm5qT+/EySQnKG8Yy0GAJMJo0JdGwQoiumaH8yyRXmPKTKsdDvdOajRwL7JRFr01nXJm7jDiKaRAwhfm/vrtvhnR0KeB8HkoUpc2NvigjiY27vfvXHskXSYQUybB+V7RVeQDF5NJOsdEkRIFnVx07InkndLusKvBF4dKmQVgmCdrB1BikN/4feogx35cOO37twN5Rd7KUW8D9WHcDl6y6LXWbvz2ko0E+CDt/Z8tMicWRRtQmm30A4pqUq8ZtOVeKiHx/8DSjtFza91olAlYBMNQymk+ZyLIVbDll/fbG9TcegE/vHL32Ase/TW8GztzEaVLTnC9bMeC74rCLGRaKA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by PH0PR02MB9384.namprd02.prod.outlook.com
 (2603:10b6:510:280::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 20:10:12 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.028; Thu, 13 Mar 2025
 20:10:12 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [RFC PATCH 05/18] KVM: x86: Add pt_guest_exec_control to kvm_vcpu_arch
Date: Thu, 13 Mar 2025 13:36:44 -0700
Message-ID: <20250313203702.575156-6-jon@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|PH0PR02MB9384:EE_
X-MS-Office365-Filtering-Correlation-Id: 4334e7f4-1c2e-4ed6-85af-08dd626b0f90
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|7416014|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WxmkNYyuOSpYxb33SyWyL/K+frl9XJ/5d+GZesIFBya33ChvdM049yqasOMD?=
 =?us-ascii?Q?VECxeQc234IZgjaqiw2SLwOouy1A6WvEEwabtOTlBm/86dmC+8ss8OPQuTIp?=
 =?us-ascii?Q?OITwiEqqxyCtqC97z22EUur5jPJVCFOG39Y6pEW6pWRWmTOPTE0pV64SvO7U?=
 =?us-ascii?Q?mGR5j2ZamQDG9Rh2DQR5UgrxLe7IWTj0TO8ixqT+mUSfwYV8kKFr45rMqFr7?=
 =?us-ascii?Q?xX4V2z1cjwzVl1vetfcoEil0JrXJJ+1PcGY3nRB4wZ8jWHX8SHDYa7SQpL6D?=
 =?us-ascii?Q?NCY82v8kZHITicrvA6Ec1o/p6Ozi2AQip+5ZSiiQAKfBiQ85kBjkk+cg1J6H?=
 =?us-ascii?Q?4E3j5uWaXxw3mVYhzaLqTYDPQYJTAfVPy8HBOfESE5UUdbyacP88V3J0FcVJ?=
 =?us-ascii?Q?MyRGEIRWayfY0FPMsyPt47OPwmERIpRoYPFXKbYZisNR1Ttap1Gb02YAkTtS?=
 =?us-ascii?Q?8ovlK7LbaBQJIu7fuAjtfA+NPORaZgd5A3Jo6dcJXIthyKFRWXeJ47Q/2xM+?=
 =?us-ascii?Q?Uw+FEd3os9b60n8doXUtxOLdWWVIUcncgl9oH42LIOSXtCI2TcEFe5hhuzZz?=
 =?us-ascii?Q?FtHEAbfZBkxu9plG3f5GuVbKG8txJOkznqMGQsBMYqKqXwG+sI1QC2LxMztJ?=
 =?us-ascii?Q?iLpqZ2orN47LI7m0H76Fs2wbye78gWe95SM0vsT9qk2ZeAFm/myXlbz3qUTx?=
 =?us-ascii?Q?4DTtNCLSjJrkGk1bHQQRlT/asQ6agp2wH+t9OUTLfn/CD6NpvPuHzkI7ySdq?=
 =?us-ascii?Q?V8Q04EnznXIgzGJadz3ku17rc8CbqVy8CgDjYvpqn0CmB10DeswiTq6NW8rH?=
 =?us-ascii?Q?eE7UUKQSU4M/M3UxasbfRyUQIQs75Z+q1pNtRuJP37SSlAuQHOG8kvWntm8h?=
 =?us-ascii?Q?pPybzfjsS2fTYgq9R3I1BU1yaXFWESQ/w13R85dVwprSvMm7d55wiaM4RY9f?=
 =?us-ascii?Q?g5fjtdEES727AHkYkXGx6jAZtA5xNtQ4h+N85x3jATvUsNEF/duTmxoe9U1M?=
 =?us-ascii?Q?1hyawPLbhkAvcR62RT5L+Q89HuPJDoyzTGX0G1a/p+tnakvhe/d0lhvya9Vw?=
 =?us-ascii?Q?zI+mtuh0itDl8dt3PyeS5QFWqNLOeDUzfdkOKt7WwbC8CtFbcGpLl9oJEG/Z?=
 =?us-ascii?Q?ieeUudRnaw9d0ipAAtxyffOARBx0v4qmaNwP+7Y2T9k6LRzhUInNQiRNYpsC?=
 =?us-ascii?Q?2Nib0vcQ+YzUOgqdwA/mPE0sUNj9pTv2lnM0aolJ/ZPJUIxQHP8eDCpiYa1p?=
 =?us-ascii?Q?z53PJHTkiLnLkcfVb+gSC9Ykif1BoNBg7dIg7WlVUJsj6Syal0Wgj8LmXqzX?=
 =?us-ascii?Q?hh0ia8ayl21UlVYC6RrGPYYoK49p9SmDlZjLZ+YMIVC8xlkFAkNlDCm9zQ/F?=
 =?us-ascii?Q?H9MyZLkTH15ERhh8/JM8OyBt9V1Ir0Oup+W7tfWszKV3st5P3+EzdJ7xV5NU?=
 =?us-ascii?Q?W4+ALPp2kcfn19tnu1D7hpgaCMuYP+oW1BosZFEchqCnXUv4LEBnAA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(7416014)(366016)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XpxBmbtX2Fb+/y5NCpouRKp4zurIe28tmkUpE9Q35BFnDJ6L+8+cTnFAN8oj?=
 =?us-ascii?Q?zU0egUX9E0mHC/j9yTmN+ooMPkJeGykk5oDIBdlOzC5V7Xoo1X0IipLoSlgx?=
 =?us-ascii?Q?UAYGzKhezpoN5sSztmtPcQ1EAXfjhcW9jSpUB1rDQpGkCQEAa7mfyTtiGoAZ?=
 =?us-ascii?Q?syCDldRJNXIAGSWFMFuCqIiuMvB1dQqJyJYZ95jhCmWYt9tgC0CIhQxUjvwz?=
 =?us-ascii?Q?Rj3uThH8Io+FldnyhUPM4sz31iLXj4LFzNFUHut8jZjQrNFoC/gpEpLsOarl?=
 =?us-ascii?Q?uHUTwGBdDCJP4ooBqaAAu4zhRBOHL8+5RMNB+CytskRgoBJrf7Py60eHBWvy?=
 =?us-ascii?Q?GapoxTcce8JYhF9qJFPpJbT++hxYYh0p/f79+cMq545LK+v0tb+PNahRLMtA?=
 =?us-ascii?Q?Cu+U9oxA46TuxMW0uNZGrIfU44bGTTcXpzzB324bW2zWZs79uqrAdJRQYL98?=
 =?us-ascii?Q?moxLU1AG6VoD3uuWg/rBR4MtHph0xAYV0dBYamjjIHoei21AYK+YKLktRRAe?=
 =?us-ascii?Q?ml7yJkuMso2O1mLASLVkYwcZ0BpdOH+0SHzxE0qEwHc/VeQqsOdpEDJ36j0Y?=
 =?us-ascii?Q?60nb9lL282Li2PM3MYm+fyzA2ixJhqnVZi8YNudTnLEH+XxwEz8XUXtL4FHH?=
 =?us-ascii?Q?BX+OH9BWa9QoEbnXLV9Gn2Wr/fsU/CoC1nSRuwn1VnAgy2DDpDRHzm9+eStX?=
 =?us-ascii?Q?L2dHHuUvpzB5GLUy3beqyNhsRu9CAHu4eXOcNpCOF3vg8cI+n3/UTCnk8aWM?=
 =?us-ascii?Q?sC3cLX/kW6PkUcgDcvp43xB42sEcqC7XSaXELzCwnif2w6FYhfzEetOT2btk?=
 =?us-ascii?Q?lguFwZve5lZ4leKx3mC0nvtO9pvQn99YX8XklWnuGMgmQW+DEPZAGz1ABPvc?=
 =?us-ascii?Q?P3D7Nvfo/JL0qQAirAXm8ZI6hCRaFcOPFjB3lBvppwinzWd9NU9GsRG97VYB?=
 =?us-ascii?Q?PtGSFsqSjIzBcuZH1PzDDXMVFJo+w7kF7hiao4fRGDvt22U3/7/HIZ9YIZtO?=
 =?us-ascii?Q?Hk17B7VaJ6OwqI6InekjKfv+x4pE47vkJPhbKD6xM8y3cf0wF6JPRaGaQJ2u?=
 =?us-ascii?Q?pOyXpS/XEq3qLQGvm4dBAG3v1B21sWfwD7jVeLcNUedfKIdBpM///H6W3StZ?=
 =?us-ascii?Q?ptLrt5w+OfLGyR8dFbGzZzokV52OS4ccQiVuaxkpokUlKEV2GR3qEM9PN2Fn?=
 =?us-ascii?Q?vas5xvYEbhsxqbvWsuHScR/dk5va9vtume4su0jAF4oXcnNpdFnFqnQBb5zB?=
 =?us-ascii?Q?3sqwAgu/Cac2Wr5hAVk0CPToonfvRtTOq86Yt2mKMDOJyK42Y7YDP6j4dgag?=
 =?us-ascii?Q?yIXCpygVq0ZzfWszFR7R36faPbMsjl31Il88i6c+2i6SkV2cusrBLqaEFZ1C?=
 =?us-ascii?Q?vLUxMYMN3LJTQkL7rRW6gu3KmGFoZsRZtnVVADbmmNDW2GPcEa9KJeiwYoZa?=
 =?us-ascii?Q?bxbKLx0fnRi5SUR5hWEItSgb7ATXpyGQ+NJL0AIizpam6cIp59JjFhCfQ8NT?=
 =?us-ascii?Q?aThtV6Ka74Edr+KueZIF6Uzns4DkMjixR4y1AdsK9RlhFhLRp/FOq/LPin+I?=
 =?us-ascii?Q?vy6DonMzJ6dgkOeFRHLzWFGdQzAH1xhP/3jMNkmvUcoMkgwnGHSRPgR4Jx/7?=
 =?us-ascii?Q?BA=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4334e7f4-1c2e-4ed6-85af-08dd626b0f90
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 20:10:12.0891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AZabvJsRujCLh4S3ZzPW0Ua32BZy2P32XLgGAeaITxnCocMtRPkUJLMDh4X2DD61yl4ZuW6eRMkEgvt1dHBYWA3WX4nj6M4lPL3u5yeke28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB9384
X-Authority-Analysis: v=2.4 cv=NL3V+16g c=1 sm=1 tr=0 ts=67d33ba6 cx=c_pps a=f1nyBA1UpxJqkn7M4uMBEg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Vs1iUdzkB0EA:10
 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=CeLJxxsBtYHG6eP2vm8A:9
X-Proofpoint-GUID: RwVXWYGs3Rcb1VMpfP1DNPj-OHhyHq6u
X-Proofpoint-ORIG-GUID: RwVXWYGs3Rcb1VMpfP1DNPj-OHhyHq6u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_09,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

Add bool for pt_guest_exec_control to kvm_vcpu_arch, to be used for
runtime checks for Intel Mode Based Execution Control (MBEC) and
AMD Guest Mode Execute Control (GMET).

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 arch/x86/include/asm/kvm_host.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fd37dad38670..192233eb557a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -856,6 +856,8 @@ struct kvm_vcpu_arch {
 	struct kvm_hypervisor_cpuid kvm_cpuid;
 	bool is_amd_compatible;
 
+	bool pt_guest_exec_control;
+
 	/*
 	 * FIXME: Drop this macro and use KVM_NR_GOVERNED_FEATURES directly
 	 * when "struct kvm_vcpu_arch" is no longer defined in an
-- 
2.43.0


