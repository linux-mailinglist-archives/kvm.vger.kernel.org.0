Return-Path: <kvm+bounces-57740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D8A7B59E02
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:45:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABA954E59DC
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:45:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A28225F984;
	Tue, 16 Sep 2025 16:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="GyZa782m";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="XrPFWVsB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EB431E8B4
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041095; cv=fail; b=ojNnpt/lyxee+P47TGbngucQWH1kn/zPKetbO3J7eeVLg6F78NWQC6m0cwABzKuybpOM3mE0IUux+e+TyM4N8iYIylPnwDYtL6eF+JKrYg/F1HjKKr0Lb7uljl68dZBugtu5gfW0afoPJbdnvLpCF71o4I2mYPvRkiNlNqY2jAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041095; c=relaxed/simple;
	bh=Jlj16uoP5qWl41PWBLnMM0xOWSZJt3zNr3XpJ/T+94k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BE3MhLe1MN4BNPH4lLcJKfJQIIV+stxvE9SbCuRKupJXavW1UlK31hO/AJ4vK7WRu+IuNF3Afyoj29RyG1Zt7kvavMJekZXrt9bClM7OO5vGjVRnvuMhZ56p4Cafzx03RbwzhJQr6tU+MO66edE5N4kNZPQHMITSqMxT16V8vpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=GyZa782m; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=XrPFWVsB; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58G8mwEH3768189;
	Tue, 16 Sep 2025 09:44:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=zfyEpRVVd2jtuKvpveYPw063xjuGpQndgFs77azim
	sU=; b=GyZa782mAW9cQGBJI87n1OpVcseXcapZTbUN6Bi6UuLSbJ2cVI9VIMq/Q
	RiApFYJCxiBA6VYFnH5Ox6JYwR8YPMgRHG1LFYLRi6QztfcuuAZhtylT5/xdgS9v
	V+tURpU6XUwvXo6zNSirXZBrYAkBA8qxMhs2I72C6nppKwtptdI+07AJs/u5yFN8
	G6IYRZUV2fQSruLzLYhZBzRR3NdKS48GdoKWurRMcZOMe+iiSPdK+GzxbpoXMuz1
	kbJpvuDQvOwNnBZ0a8wXJUrRwHkBBU4GeqEn3Z+oeNUqw6pugfyoh89/zkfNmMO1
	dge0PBvHOBTWXU+El3SrZGHAvPdbQ==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023143.outbound.protection.outlook.com [40.93.201.143])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 496uaq287s-3
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:44:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lK7OvntDJ99Iahrkjw1Y8eO6lzp2yZKz6mLhIT9OjugsiRmKCaju+CdLiT05xLZ/f8L9gDnByIB9TqOg1wNQx0YwHuP7pYYLujpicV2IQngKlAKNg7RDIrCA+iwuF05yrXm5Z2F7MfRh7XNV4yyoYNqIQRTi3xHj6rIc5dTeaVBodFur1xfgmGX5bDs+VnBE9LvCDY7j4RjwT2PhtIFhPcVPf5bu+vE9OgwvAxiCXsG2qcxLqMcAot2/dpcyXW9YIM2mpcG0bE74UJVNIExOccgg+NbhMPRLmjg+CZFjL0I/N8tGA58nfvWyt+Oxnq2kJmhDcTaFJqAY7gGAgB1f4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zfyEpRVVd2jtuKvpveYPw063xjuGpQndgFs77azimsU=;
 b=THv9K8IGRoayaPOc7Id9S7bTAErn39iGT1xn1J8V+2w3XqKJzRUq0+s07v30oJGZRvTUD/4+Yo/w42nzY+FBHWd9qtYPgohAl4SD6ktRDQmda4qqdAHHnpRkpyz5IpSlCQ9ckDN+bDgBPsMT/TJvvnCPUeNQGs5K/0Twrq+sxh/OURBXTRYxqgmF9Rg08puxZ6JN6lZEcr7PNLzvnVLDRNByEmvxmUWOxs9BkY9EbNrSlTOwbOD4QGybBONOZXMWQFVffJ0oUgQtLZQwE4z8xepb4DdaAOwa7PlN/GJy3ri33mCaHh7jqFKq0pZLVpXl+eZUGk1jwtdXEaq0a8RW/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfyEpRVVd2jtuKvpveYPw063xjuGpQndgFs77azimsU=;
 b=XrPFWVsB44K77xTG6zzQEpCdJsiS/j8FBBU1zB69loEYzUufvCCso2xPpuPeSsbLnokDm5D07Cj9j9iTaNm9OQSfepMskquF91XnRHoqMG3SKavoZqWaFSRQECfNpmQHGvNpOvFLxMwmzzsL040Vxrne78y4PgsRtjsLWDBBz+MwvCbAAX0Kd41uXFG+pZClNZ8jPnRk+yHS7/0Fk6F4PFMRtf5wAz9hy3OsDjvy+jzDSs2pzR0mPEtVUhti3KfzbSu4JDJIRpZzPthJTEdDi7i/1/clzNi+ZH0ERMja2Oc0mbv2BNVl3SGnValvSNSxPKxpzyvjpUtftHGomFYCWg==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DS0PR02MB9620.namprd02.prod.outlook.com
 (2603:10b6:8:f7::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 16:44:42 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:44:41 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 02/17] lib: add linux trapnr.h clone from 6.16
Date: Tue, 16 Sep 2025 10:22:31 -0700
Message-ID: <20250916172247.610021-3-jon@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 067cbd4a-ef64-49ab-7bc9-08ddf540557d
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uvioPG+trjkoYQ9gV2Fr2IcqxDd9aDXjObLvYzKOw4zOYcOYlG7OSD5NXEhG?=
 =?us-ascii?Q?qyE37FpPv8iomBPPTTFYggC2kIMP77sKv3DDSiDo25RLmyHsGL8nRkFIGdYg?=
 =?us-ascii?Q?YJrq7TH+AWxb5QVGYi4Q5t24S3w3OrQXgHRbp/3VemoEFX4q0rUsvGeZarfM?=
 =?us-ascii?Q?jWsdtfd9Q3G6SsdWiBs6yFb2MaDR6E0Y7JMw6z0KlKBkQ0JLDrx3V8Kic73b?=
 =?us-ascii?Q?6y1PJrixGtf6jg5PZv9AM+8ZQ7v6Xg534czmjEGPVi5V9to8CqKwkEqovWBD?=
 =?us-ascii?Q?beknlerwYXVtW/S/nctqOa5f/D7+FOSdVxdFssS4y2gm7ZqUeh875+2NFMrw?=
 =?us-ascii?Q?u6NlxQoDMxHvV1qHE+so/9ne5k4/zkLuO/xFtZpQy8IHRTQUZONYh9fB3Jvr?=
 =?us-ascii?Q?aKIVMERNfPnGU/zTq/r4iqp7tI6w5FeLke059s/wYlX9YPyGyaLlUZjBdeW/?=
 =?us-ascii?Q?GGN4TFmNtLdBntSYkDq8Po+aW5vGGKCAOfiht67dhYoZh4SDWS6lPD7cj2Xd?=
 =?us-ascii?Q?pans0v1mH9vVcn+omcFx3CDPH6lCbadWjE/7Wck4bgHYt4IctMJZhlT7+KLl?=
 =?us-ascii?Q?adEZaa/+behVmjw0l+e+9q+L21WVxkywF3O639QQCoO+XtXvLtYHwHkti+1X?=
 =?us-ascii?Q?CzeIs5fhys+OM6hpuOFzaiJc7YjgbiLpkoDwIE9Vsj73jXlPOcA3J5CDgo5O?=
 =?us-ascii?Q?ifiHCTQBz1d8frGZ7ylL28fSpjllX45VRriZwHZDhXBL2DA7jWs9Mm1jJsk0?=
 =?us-ascii?Q?DBWnkyWixfcSVq3SkqWu86Wb9ImcIuq8jfdvMrfveyBYl16/zK5e81+KCNBW?=
 =?us-ascii?Q?6MW1VyKFphZJboAAMpQq0NpyBxzUO414/BM3h8ZKegz1ilhuEu9dB/0fyD/t?=
 =?us-ascii?Q?mdO6j6ZNSykT0H3Bx1N94L9pTz96A+iu7ax1+HODYrssuXw1xK8usxLSs0OT?=
 =?us-ascii?Q?urQk0qRiKNqYWBXXY+vC0xJ7YpSGfpUtqJ8HstmsU6RgaIn44KhaluwSYTZT?=
 =?us-ascii?Q?4v06CMnmqoXqmaUDsnKRIfz0xzXQ+ml5huv9yHGBjnMLgGMkMZSdEesuEGNn?=
 =?us-ascii?Q?NGQqaph9vU7egEfiLfPbCGToFrqS8lHU9H1r2NP4BWa2ejLYHrZbQ/68S4Zb?=
 =?us-ascii?Q?YBGFok7X5wCaZddtOahafCwr147F1qiGjvdHk7k8G3b+KEzvp8FKTiyeKXhr?=
 =?us-ascii?Q?yh2ad8pA8x/eexLgoAH+61YhFjz28FQ4ElDMw/ZdSh/aaGNyVMG3tzhLfpGv?=
 =?us-ascii?Q?Lk3ZkQv33aicAUN7RCtig8QieIkjDbgIGTtO8u1hZ5wVD6cScDAK364uIzFC?=
 =?us-ascii?Q?Ko07E/ytgi4AVHngtUamyLJ7nwvdfXjTaE59i1WDxcT98urbGKc4gSB8OWEv?=
 =?us-ascii?Q?ApO60eY+H96LfoazGk1w4CBd95oq5qWvOV2oqlBqRxyOMKAdfwObKM9EeGDt?=
 =?us-ascii?Q?NQ0Gf9VSfdBYp+LO/2e6qGT4JzwS633wCc7ifvqdWX7LtKE2TmO+gw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XQiVCzu6sjiE04+AcMyMUoA0ZchOgsuT3LUfLxBaTFjA9xqas7KAGUIM6RhS?=
 =?us-ascii?Q?PX720hnEWWgjRYOHe6vDuT1lGjmW28H9v6677frRh8gufBDSYo1JlZl6Ypsf?=
 =?us-ascii?Q?ejuDO00JejBA2AXbdZMqdnQ9KCI/TOrZP3300l/DWlBfZkiiaLu+A9u/lW43?=
 =?us-ascii?Q?O1m/m11Lwdhq8hZZNJajsYS2FWwDdfKEeHXP+AQpJKcQZP6fyAqY2LR13pwL?=
 =?us-ascii?Q?CSx5sjEsCQvDFN8icCMGjtGklUQS55uYKNvv63A/O3PcnaKm71xSTVy33X5S?=
 =?us-ascii?Q?fgf2jJQRdVsHpIjL7kse25VxVBKBXB6/12mZSiR8nPdEB3F6gHBZllYirbWX?=
 =?us-ascii?Q?qNUELQHfPAOBjh5U/Z8XpfIhmzgwk89IdR7VMxjk25rPisznCFqlERdji8wG?=
 =?us-ascii?Q?deU7YgBVOH+5bSvbVeO9kh7QeUf5I6CWCVmaAgAXxGQbdkmMVcB76GLao0wk?=
 =?us-ascii?Q?H7mXhWFtY7Y54DIVpmAL44gWz0dZU9xQD8s3VafhuPzkkezZ2ev9t+a7EltB?=
 =?us-ascii?Q?0BnXtrLByatLUylgo1tKbV5lJ7qGfHDiXtqApcTGvcWC9r44KglbH94TEDBV?=
 =?us-ascii?Q?6K3+W5jK9MPZCSLu5YdpeMokn3JCO9EuTueNT0onXBMfVVYC1G1ebV1upwOs?=
 =?us-ascii?Q?utvzbhPdAEsTN9iuup1chC9KtkMibldTRvOEPn+Xz+fRX/49DqjyX7IU9w5H?=
 =?us-ascii?Q?7+LMYivJdYQYD5krkgJgTeFsfjXZWxB0mKQrVTDqyFhkoiEpi8kAKqlI/bAS?=
 =?us-ascii?Q?phIkq1BsFL4DKw948uM1jgTPnvbX9DQQURaCXrtPyf3/mX7UsXVBfXnM1pjb?=
 =?us-ascii?Q?bPysVERMgE70DV6DvghQHv1bxomP2urVXbXfJsggo09HVnlUPVw1MbBPJStR?=
 =?us-ascii?Q?K8PdZzWjCYhBqDhWg75ATK2exFwrHEHz7wbYb+5+4CWyva8vIEfd+LGSAKL2?=
 =?us-ascii?Q?20/d5BItavAqe8F8ZSV9gbKs6P1Wjx0xxsMB3jgroeH2dgi3oA/hV1oh9w2m?=
 =?us-ascii?Q?lDXmOgteJbZRw2nEGPAEPw1wKXQMNbWMoeZS2LxD2U2gEahwpCEIUqvJmdcl?=
 =?us-ascii?Q?whx2sd86S6AvlgREnLPdMQjjYrJ8At01pF/TtMCKrWIBTuPAFQuyUN9SIYLU?=
 =?us-ascii?Q?ZwNGrFjmWo8hA8JVz1i/WNpbM04dPM2WAy1BcghlibnL8nBfOBORN3a5Ugt9?=
 =?us-ascii?Q?/kaWHu93CQY6t0ZkWyIhWiDCVZO7o7FFueO83XiHuvK7rfgMJJPzxB1ER8Px?=
 =?us-ascii?Q?x2LEW+8L1HmLSxeU9Cl8ZSL7w35nn8OfKgDXb91p/fMwJQZ3hCUjvdxPpuuG?=
 =?us-ascii?Q?lr0zzofhtnzLJWkqh8x2cVEap5hYGka46OKk26fEG6zn66Xq8duTBjbyK9Vs?=
 =?us-ascii?Q?qVxFMNqgvDjKlakSlOvtgwdlbXdoy1VTZdrTeZoQ08k/GgZVVy3DLmZJcQgN?=
 =?us-ascii?Q?eoSdTSC+iy5bPwkHCYAH7bDV2vzTVk1p4Y8lzPX3sFkVTo+K19WlMcTe3Rl+?=
 =?us-ascii?Q?ftcjiaZHRH+uUmDCBLJUHla4tdBdkjjkcsh/7VY1VNNe/qzjdWY94FA6wGTM?=
 =?us-ascii?Q?DJ2ZkvXYxIMgOt1dSLJnNdt7F1OZIB2Uwbs4QIWW4b8Ifv/70cqevuT9ARZa?=
 =?us-ascii?Q?BQ=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 067cbd4a-ef64-49ab-7bc9-08ddf540557d
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:44:41.8832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TcOGEZB0o5bvrxrl4HP3c9A5DiP83WEpweqTvz1W6pTefjib7I7pUJlcFhig3pw7gEvds2wIoLawe4caSwb07i1hG9LSGuoqw/FFlQchBGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9620
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDE1NSBTYWx0ZWRfX+cl3mAJSiLhO
 8e2GKNTwrq0qtT45tEgTrjQkMNao1FDUQFZmdSxW4AjN31Oz0VBEMycgr/vwh+n6U4TSWd7pnB1
 bhaTJdJAFGHkejyPrP/JXcpIQJJkEWhK2x6S5wLi87kNz3q0LNXeSybUgu2/Jc5SHfmU72p8int
 Wk1N3ToXNACYKComZMHjzbbgzGDZ+WTg1U0/7y94w2lelVE+3+303d70It58htnx3uF0oq9VpeR
 AB9eii1qO1olm1gN20MlHUYiO4POcVNkvKLGOgE/AyGb8KpU8Tem4ASJmdcV4E3xeuu8LFjeTZV
 AnI6rDUzQ/NlftBF/KukQww2rDdZkZVWYdvV853JVK1+dzPHmQkkH5EEdnKg0s=
X-Authority-Analysis: v=2.4 cv=Qppe3Uyd c=1 sm=1 tr=0 ts=68c993fb cx=c_pps
 a=ZOsnctmsBCw54sLOPzIoIA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8
 a=dudULdNPZ4wVulxo5yQA:9
X-Proofpoint-GUID: 1dbmHisJhXSBz7lE6Pno3gGyp8_0sSg4
X-Proofpoint-ORIG-GUID: 1dbmHisJhXSBz7lE6Pno3gGyp8_0sSg4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

Add Linux's arch/x86/include/asm/trapnr.h from [1] into
lib/linux/trapnr.h, to allow definitions in vmx.h to resolve.

[1] 8df7193 ("x86/trapnr: Add event type macros to <asm/trapnr.h>")

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 lib/linux/trapnr.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100644 lib/linux/trapnr.h

diff --git a/lib/linux/trapnr.h b/lib/linux/trapnr.h
new file mode 100644
index 00000000..8d1154cd
--- /dev/null
+++ b/lib/linux/trapnr.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_TRAPNR_H
+#define _ASM_X86_TRAPNR_H
+
+/*
+ * Event type codes used by FRED, Intel VT-x and AMD SVM
+ */
+#define EVENT_TYPE_EXTINT	0	// External interrupt
+#define EVENT_TYPE_RESERVED	1
+#define EVENT_TYPE_NMI		2	// NMI
+#define EVENT_TYPE_HWEXC	3	// Hardware originated traps, exceptions
+#define EVENT_TYPE_SWINT	4	// INT n
+#define EVENT_TYPE_PRIV_SWEXC	5	// INT1
+#define EVENT_TYPE_SWEXC	6	// INTO, INT3
+#define EVENT_TYPE_OTHER	7	// FRED SYSCALL/SYSENTER, VT-x MTF
+
+/* Interrupts/Exceptions */
+
+#define X86_TRAP_DE		 0	/* Divide-by-zero */
+#define X86_TRAP_DB		 1	/* Debug */
+#define X86_TRAP_NMI		 2	/* Non-maskable Interrupt */
+#define X86_TRAP_BP		 3	/* Breakpoint */
+#define X86_TRAP_OF		 4	/* Overflow */
+#define X86_TRAP_BR		 5	/* Bound Range Exceeded */
+#define X86_TRAP_UD		 6	/* Invalid Opcode */
+#define X86_TRAP_NM		 7	/* Device Not Available */
+#define X86_TRAP_DF		 8	/* Double Fault */
+#define X86_TRAP_OLD_MF		 9	/* Coprocessor Segment Overrun */
+#define X86_TRAP_TS		10	/* Invalid TSS */
+#define X86_TRAP_NP		11	/* Segment Not Present */
+#define X86_TRAP_SS		12	/* Stack Segment Fault */
+#define X86_TRAP_GP		13	/* General Protection Fault */
+#define X86_TRAP_PF		14	/* Page Fault */
+#define X86_TRAP_SPURIOUS	15	/* Spurious Interrupt */
+#define X86_TRAP_MF		16	/* x87 Floating-Point Exception */
+#define X86_TRAP_AC		17	/* Alignment Check */
+#define X86_TRAP_MC		18	/* Machine Check */
+#define X86_TRAP_XF		19	/* SIMD Floating-Point Exception */
+#define X86_TRAP_VE		20	/* Virtualization Exception */
+#define X86_TRAP_CP		21	/* Control Protection Exception */
+#define X86_TRAP_VC		29	/* VMM Communication Exception */
+#define X86_TRAP_IRET		32	/* IRET Exception */
+
+#endif
-- 
2.43.0


