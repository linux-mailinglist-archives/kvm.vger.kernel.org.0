Return-Path: <kvm+bounces-35115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC92AA09CDC
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 22:15:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F176188E5DD
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 21:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8D352163A2;
	Fri, 10 Jan 2025 21:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HiiCGrtC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="T7ZN3ntJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F6C20896D
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 21:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543682; cv=fail; b=ABv44tpP6HwuJTCFGYJs5tMzewSrvYSjPjH61nxEUdRct17UWZLB1Dk+YQQRWwaDemdRDRKmXYfKTk6LP24VgKlm8v7KvAkpkdJseyNLXpqY9Z0w6eDbnNvf5CaD2lB6ItdYLW63oZ4MoFU0TiJXxhGBsOI/6yRTPYBPv1qHYpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543682; c=relaxed/simple;
	bh=hduK7QalYex4bGqL9J96jtmIyI6J8sU7MvVrLsRcwwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fNKr3EQy+Ups22rEoAJ7gIj3AS+l7gek4nWKQlMHckUK6aQMgAujQzCo+6jmhvdJ3HGFiraTgaqeeLziQ4QB1gOHxYDRuz6KV45JryxS70m/A6vPaIpC4rczthS/cWDCruho8NB8ZZsuoYBUyG6IWX6YdEixBJkIeOCNwv/N8Hw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HiiCGrtC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=T7ZN3ntJ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBtBc005923;
	Fri, 10 Jan 2025 21:14:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=w7i5Tk1RbO0VXPKpnPE2xZgNZswwBA3qWAl5VM6sOXY=; b=
	HiiCGrtCNgDDXAi+fz6LUbZa3O3zZTZOjJjIXFs4G9EHbKobg68fVgldc6DiBO4P
	6fc5dob8+gWfddMnmGtSo41c6VsvpNUUetr6MSGCMUKxySZU4JU5MuZntp6Cafhd
	gSaSCv/1gpmx0cccSlXhyuCT3y4m83cQbe8dGZeDLzrhzMU9a7EDOsxV4OcbrXFu
	7LciHfCGPYWQL8bEwilltmyFu+Xo4iq0xlkGLiSzmo3VqGjMxmAVrvvqjySC00/C
	HUAge/Ibbj/Ip7jcqfgu8E+u8GN8vfqdfmCsT6APHDBLsV1l0hwZPB4qo/Jc2rEW
	fNUNyeEeQpoF6etqIdfMQw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442gy5tqy7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:14:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AKIpLB004868;
	Fri, 10 Jan 2025 21:14:23 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2046.outbound.protection.outlook.com [104.47.70.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xuecwpwk-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:14:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WqW3T/z4oAB59yDGOrXoHigZXKDf+eAFanqnxYqBgOi6AG4WVcNMi7yiq65JJmEoy3wb8jvXHezrL7vPdTc8e92znH869h4NW6QOvrhXcVQgcq5CHoMdoquND/uaGDn1bBaMbo7ZBTFbwZikeiOEm13VTBErARsnmygEyaRkvu+akjaDDCbaPj0q2Rjzp3Gb/FeptEeeaGSpABgDFYctCAlQePYRQ31puOj5of7nFi4ygJoc4bwJCVi8rCrjiv1cGnnJl5BtzFSBbhLILIk/K6t0GMm6oRussfJKqc1tXA3lfj18yINFMKEQDLPhg8F9Y9SGcGWCUqz3yBkrGrtFsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w7i5Tk1RbO0VXPKpnPE2xZgNZswwBA3qWAl5VM6sOXY=;
 b=DSb0goLeG3yjbOOyPtVWujwKgMYbZi048JXw/VDpXt47aJoQZLFHSMK3al2u/g/8zcQYaGkGjqIDpMhcE37fcQEXJEAHgZnnSL3bwVHWybkV+1mJW6YMZdPytlvLjW8j571MNXaSWKijU/3rT0M7j6SyL72EDFMbLWrDDGE6SbLNNOxsSu/ERKdXCOdxga9uzPVYprpqppEEWgb8oSq+wcEFkDjam3B9/zUYET7Q5OhJCgSrcerWk3Z7clmX4K7qb0eGgLP8ZMxX/qc+5xvzYNLcSc+TWelhUf2Rqt3qa03tt57h0HmyCSUax+PQvudI6MQw0XoJyKTFCYxTxuJX2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w7i5Tk1RbO0VXPKpnPE2xZgNZswwBA3qWAl5VM6sOXY=;
 b=T7ZN3ntJkuqQbAJOQBLcGBLyLG8bN7GVMw+kAAHK1qUcVcs/uaj+OeT6craTeffn3BcneZ6lDvTUxx318Tl9T4A8wxAGY8EBvEQN5jIW8AnmBC0lcymOW6t9joKKeX2+XbL6IXDzidqoQ/+qnpmRUvTwoZATW5a2tIvUfD3C6M4=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BL3PR10MB6113.namprd10.prod.outlook.com (2603:10b6:208:3b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Fri, 10 Jan
 2025 21:14:22 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 21:14:21 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v5 4/6] numa: Introduce and use ram_block_notify_remap()
Date: Fri, 10 Jan 2025 21:14:03 +0000
Message-ID: <20250110211405.2284121-5-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250110211405.2284121-1-william.roche@oracle.com>
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20250110211405.2284121-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0043.namprd05.prod.outlook.com
 (2603:10b6:208:335::23) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BL3PR10MB6113:EE_
X-MS-Office365-Filtering-Correlation-Id: 917fd33b-46be-4bce-9ca6-08dd31bbc0b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MNakKXsV2fpE3ZY7snFBxL86TWzIAHZ1RUhlZJvl6VRnWakQCvDU/V9Uvbj3?=
 =?us-ascii?Q?VH26oL2/M1w7CwWzTCLAAtWgyJqDXYCX7KzkjlD8wY5mYOkhcmABo3rQAsP6?=
 =?us-ascii?Q?xQXk+hJ6NeatPm9CooLn+nMxx2sHbI8HNbRPZU6n6xpAZT86pyGGgrhPiolA?=
 =?us-ascii?Q?anWx2UkmTEP++41AQSm0GeGltKX26lmur4faHqL3IWIijFqU0abQmKt+KU/G?=
 =?us-ascii?Q?iYjszH+qYmCLyCo2evbQekwUvoDStnMsYoqm1582k+1bTzPUFVN+UkmmL9nX?=
 =?us-ascii?Q?VglxqOO/zO52hiMs3uj9/QupqEfXYh4PXvkzRz54riOFOP3Xxd8JelM2uV4w?=
 =?us-ascii?Q?ZUajAZD9TQdCJFvGyQ7Qg+96EKskciSmiceGwCJdiGCjLyAN9iPTt8OD5ksF?=
 =?us-ascii?Q?jPiFleDTl2F/KByd7oaIfcUY5JQv+X0XVLcgSnzBAcJnHoCIv3fgb3XFpPTp?=
 =?us-ascii?Q?IuuuMrIsMDMxe9GxiXT5kFwQfEgZfBpVXHdfFOLM4zbHpkkKxRh0nRlgAhj5?=
 =?us-ascii?Q?aWK7kF30JECyTrOmTiJDFaXGDBoQDxEtagsk0e4JY/AG1xVAXL9pvfofahlS?=
 =?us-ascii?Q?Lm3MWTkwijkGGEeq4tzpb2qX+Q74e3VGnYsH5qTGKm8hNoK08ocwe+W33HXL?=
 =?us-ascii?Q?vtb5KB2r8arnZR38a45Y2jOSsyfmt26m9pfqzitGApGx3UfsyGLqD3Xpe3bu?=
 =?us-ascii?Q?QbnX82/pJi5SMYfenJJ8aNpfkhe0ttxd//B1+ZPi1VxQtSlETwc/9ZwbhALe?=
 =?us-ascii?Q?PlTGkPAhkl7XY3PT9Sc24RKFmjsbtNCJiDKa3B/H3SC22HUqxY1M5DAw7z+m?=
 =?us-ascii?Q?+vueeHvE6SqWXlZu9k6N+zkqT+3lrfJD1ubmFsUp0npLPfX3FlIvGl8mRFH8?=
 =?us-ascii?Q?/Uq+7my19CCS6KGNesAPmvfig7l3u2ZjMNVhPP3n1bNFNDHc5YvNyNfsddx1?=
 =?us-ascii?Q?mNxCKeclF2WfuxOgY1+pR5PEaMCxP6e2VNOVIkh8HAjUNqtJJIEjXpL7p3AV?=
 =?us-ascii?Q?hgdpQsp9FLRYB1aFIGz+Qvp4MnBTSXgky2oFF81W/aFWVrIPyTUKugpt842r?=
 =?us-ascii?Q?xh7yr9WnhV5XsqsDcGQJEUt71CFs5+a9xElgAfgnPqsBh3IrAjBjkBTnHC3d?=
 =?us-ascii?Q?nz/GUrfDtMLraMWGQd99qX/TI1LMGx6EeTAt+0wu2lWjTsUgZyeM3s2Uf/kC?=
 =?us-ascii?Q?KNrJkr4Ov0Kpkduth/bsShAkmtcNdxaKcPQZGuFNwEEEFpbM98HulFRLZose?=
 =?us-ascii?Q?9sHxl7XLHTvOuBFGEvuA2ptSOVC1P4yMR6KRqqueT6QtAPalgiOv6HzZIkn5?=
 =?us-ascii?Q?AtNA//4adasa/2Hw/IhsQyrMCgZMDbkMiIdrKKZ5wQpMPUbLNOjlTXVUqoCu?=
 =?us-ascii?Q?gTQEoLo+kVOUFJTdCBcXfoUHn07F?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Tc1NchbPcSoK8C4YHSNj/F1IhWlH4fB66FQTcEuOyBJ54oN247ud6vsurGwi?=
 =?us-ascii?Q?B9JYY7997B5I+YekJD6evDR0e4A9iaJCuhtd6MYcllP181AczUFH9aqiT6S5?=
 =?us-ascii?Q?wb1alLDShwhDtztJSbGn1rMHIamOX2gnjb5MKGKOuIg+2n1SOHxhLken3EcT?=
 =?us-ascii?Q?CsKhnoBrHNQp//8omn9RSbvkqKvfLfNeiiqZ16USXgRR3109sxWcGuuODPSK?=
 =?us-ascii?Q?0LGDKLLb66pJlnp7LflwH43eFq0BeVEBmWgy/icWNwhPUFobfNUwwMs0CvQ7?=
 =?us-ascii?Q?+v+W9wVxzXglRTAE/pO2PDgPnB9MXiTWLoC+bA9oelyciI3J3YVzXRSHxjjF?=
 =?us-ascii?Q?uDFdJc/wsEbowghDpS/e0X7CApl8ORn43rG4MBXzTwkGTO2N5JwKOnTSztYg?=
 =?us-ascii?Q?TfA8Toh1qDd3UhYUaH/jlZvxs9qXo9fcppbK2o1xUGKXdbxn8+ccEkdfgdmt?=
 =?us-ascii?Q?PYlB775XpzkF7oqn64GfJ62qSlc0yFWigA920l24KuCdTlLcql9rqnmCqBwJ?=
 =?us-ascii?Q?na5XZDJIcz5EiO2MO2n1LVOjL4E161t4rf/kCSupAUs5tgBNWSJg6vEMIsbk?=
 =?us-ascii?Q?7JptLunIumRZbizhQJ8mTOyKsvZKPHKMDmz+OosMh7lbV/21XqqIXbrDZIQY?=
 =?us-ascii?Q?fWseDsBye1EGOdvPLOPtjau0UNue9rC1G3594RsFLpxF6Q5pygvh4/QSBpmN?=
 =?us-ascii?Q?tw2P2pOCh69thosUG8FNJirrW425C1jMleYE+OYenaznkON9MSDIYS2yl59T?=
 =?us-ascii?Q?ir+JTAfCIstoFrE2VtFF4CB6E1j905LTHlRuD9pG3yC8wzQvaGrLzCsVIO3e?=
 =?us-ascii?Q?/gybWtrlLvyl2HUOJHJfCABlSCqnRd8wo6w3YoW5WFRudOcaF4LNySQQo50Z?=
 =?us-ascii?Q?zASQR6OAePVvKEOjet7Shj2Misg386c245kRZ9ork8XaCsAxu1BND5A4ACzv?=
 =?us-ascii?Q?7CfcwbV56iPMen7bIZ5B/PtDyxOKXHv6Jr1volX1LC0zFKyiDHdYcUhoeedy?=
 =?us-ascii?Q?RN0c7Gcos9LbvPf/dvgH/HWtw6m7B67Q3YlsWxNPRD7+3rFe3A4eUqfE96gE?=
 =?us-ascii?Q?6aujcZFi4yGsJC7l7KkjXFIT8klX4wmPJYHHleYxsOGppR0CNLoq/hA8mB/v?=
 =?us-ascii?Q?rz+k2aLCXnMFxt4oVENzYWFor94WbcRxu27sZe9MOdQyOp9l/wEU1uBALIaJ?=
 =?us-ascii?Q?yVUeWI/7tmc7gsuZGBshTxrS2YnUrXlroH8pjkuLLazVbwgBT9XUw/iKE0yV?=
 =?us-ascii?Q?/q7DSgLSg9izWQiAPAP0fprASk1FkS9KFbvyMRaSsqy9p+nLe5uALuUNsvKI?=
 =?us-ascii?Q?kjUVhDnusiYVooeZ7c4HmHIKuviNGWWmiRz7PzMOfdlHvEhJljIYbTZ8s4BC?=
 =?us-ascii?Q?1lKLim/KRmInGMcLc/U2kawyiT/mipC16bSEyL655Xxq8sA1/J/XzFtlmOnf?=
 =?us-ascii?Q?3LpLBv+2taIZvs8o98lr7xe0wMWrmguSAi0n9iNwxxpjI3i9WH2+CuWc4X35?=
 =?us-ascii?Q?l1VNnVPAMZmCUm6uLNOU+zJ2gSP3kU22l7NgH8cU66iH2naJHuicZairWQyJ?=
 =?us-ascii?Q?zlJeK3E8K6qw/V756Q9vHTGxqQC6lsq/mtm/fbzT1STwvRhFQdz0BASOZ87x?=
 =?us-ascii?Q?yQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4DQ6omdP8uN97dr0zDXzGJY2rA8CFMHohI7ye8bQIdnZ1FnFsS1JA0zshpExlf5CZvEsp0qH9fEKnSKdEAXQcgk+r8WbjIQz1Vz5OBvN99UW9GAaxLrHZ7pu+vvcn8ef9qw/OfV7MvhyLf7xeICUBJkLrnM4LPfYPPwRHs0xRnPFKJ8BO/fnvCId75NjFuNIuG+UmOZKE8GT/k9sV/E8CQVE/giPFUotclc7wQuvduR4IreoMq2JPN2TguEzefZdikLa7cZO1uhV47Fh7+MZ4YjzVs+Zk/dQw/t/fvT/jPxZkZyMmMXmFCHAcYIk9rVq+jWXdQwW51fr0wVfNRZCCEYxpAMz21nwKootAhCsp79rcXJ4KhpBfi7GmpCIwhua3E2EASHNTwRD0X7nUrKgjraVD3cm6zGRYO+Bf9cndwTqkVJK22ZZc5PInLsNqiapmD5yVB60qx6FG0+anBWSeSI1Cw963JQBK6td/mgEb41ZbXtr5rSWs0yPyrfNnp4ztE4L1pfOqYSEhK/SZVZnmCc+84rBL3PwKiDOGQA9wJ4LN+hMU2o7vzmpuiLERXqadR6cBSv+mXu3t3XN74lh16gLM0gcK0JxefCijSxYKw8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 917fd33b-46be-4bce-9ca6-08dd31bbc0b1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 21:14:21.9285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UKffb7yKWLsY5XGyXGsbW1wRMXmLOO6LrW2/EXhBq3EggsZ2xo8fQlouv7Znd0jmuORoXLX8JPgOTMshwq3ARqrEB1dPw7ux+GjByF25dHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6113
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100163
X-Proofpoint-GUID: rVC1zRBOjc4emBH8_xsV27Dev4FTkc8_
X-Proofpoint-ORIG-GUID: rVC1zRBOjc4emBH8_xsV27Dev4FTkc8_

From: David Hildenbrand <david@redhat.com>

Notify registered listeners about the remap at the end of
qemu_ram_remap() so e.g., a memory backend can re-apply its
settings correctly.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: William Roche <william.roche@oracle.com>
---
 hw/core/numa.c         | 11 +++++++++++
 include/exec/ramlist.h |  3 +++
 system/physmem.c       |  1 +
 3 files changed, 15 insertions(+)

diff --git a/hw/core/numa.c b/hw/core/numa.c
index 218576f745..003bcd8a66 100644
--- a/hw/core/numa.c
+++ b/hw/core/numa.c
@@ -895,3 +895,14 @@ void ram_block_notify_resize(void *host, size_t old_size, size_t new_size)
         }
     }
 }
+
+void ram_block_notify_remap(void *host, size_t offset, size_t size)
+{
+    RAMBlockNotifier *notifier;
+
+    QLIST_FOREACH(notifier, &ram_list.ramblock_notifiers, next) {
+        if (notifier->ram_block_remapped) {
+            notifier->ram_block_remapped(notifier, host, offset, size);
+        }
+    }
+}
diff --git a/include/exec/ramlist.h b/include/exec/ramlist.h
index d9cfe530be..c1dc785a57 100644
--- a/include/exec/ramlist.h
+++ b/include/exec/ramlist.h
@@ -72,6 +72,8 @@ struct RAMBlockNotifier {
                               size_t max_size);
     void (*ram_block_resized)(RAMBlockNotifier *n, void *host, size_t old_size,
                               size_t new_size);
+    void (*ram_block_remapped)(RAMBlockNotifier *n, void *host, size_t offset,
+                               size_t size);
     QLIST_ENTRY(RAMBlockNotifier) next;
 };
 
@@ -80,6 +82,7 @@ void ram_block_notifier_remove(RAMBlockNotifier *n);
 void ram_block_notify_add(void *host, size_t size, size_t max_size);
 void ram_block_notify_remove(void *host, size_t size, size_t max_size);
 void ram_block_notify_resize(void *host, size_t old_size, size_t new_size);
+void ram_block_notify_remap(void *host, size_t offset, size_t size);
 
 GString *ram_block_format(void);
 
diff --git a/system/physmem.c b/system/physmem.c
index ae1caa97d8..b8cd49a110 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2238,6 +2238,7 @@ void qemu_ram_remap(ram_addr_t addr)
                 }
                 memory_try_enable_merging(vaddr, page_size);
                 qemu_ram_setup_dump(vaddr, page_size);
+                ram_block_notify_remap(block->host, offset, page_size);
             }
 
             break;
-- 
2.43.5


