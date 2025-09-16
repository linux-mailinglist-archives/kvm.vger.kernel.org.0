Return-Path: <kvm+bounces-57756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17F4AB59E10
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:46:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 239BE1C02D09
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 460A330F529;
	Tue, 16 Sep 2025 16:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="0e9jXv4d";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="MFhdYX4S"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972023016E1
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041107; cv=fail; b=HceObZN3Sz7GzXOM6ya+HAMS3FitqrEGZ8psw8kNWErjE+Nnxj5eBx0RNabzAw+fwQDeW2NiFwntXe1uH3J3YqbdjQL1gpIak7EZpfxPgWE1AED9PR+hbqhgKoTdKGJnT+4AAWNZOWEU5jw7hcrFMs6ZLEvvCEDchwV1rmaiEd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041107; c=relaxed/simple;
	bh=dqV7wppwQ1ZIWDvi2BFfxLMF7gri8pkbx9NiW1Hg7d8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tbXhLle5cRtwyvKuPvAeHjcLF6r1Hg5x19GzBnGd7UEFfMqx6zGseJ1XcGykAIewvjIXpFZ5BlewkftPEtCXcQuOoHwWxn5qApPsXJLU5Q2o/f2+XlpGp/nv4nYsP6cfquXFxLrpWZ6poIfGjPprUucivR9FxIiM6UOZRQ3J6uI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=0e9jXv4d; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=MFhdYX4S; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58GGVbp53598659;
	Tue, 16 Sep 2025 09:44:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=cgu/LPsjNYGWT+gK+SlO7durNrn90q9oe+Gkgc3yB
	o0=; b=0e9jXv4diX6T3B0BAmBRN3KdMhiY6q1p/1QRb7rcENKuflwwXisbVAUMN
	7H36KuNEGXnbCbcAqmf3Q5ccTcLSRG3O0sng16cQOGXYztAr8m4J2mmPOGMee3wM
	IgimfwcPQEDi6Fv4868c62jB4fSwFC7uRiTnueNkYZzR/Amq2OpSVeub62BJxxWz
	kVI98lx8imuPqqFyaogvExaCrgN+MtogUR3X6JNrbeLJSfGBLAW5gb6Cd78Li1Ng
	i+XBndrsTCC0w8cgPWhsrBvCQp5JKItC9zB0Y5IocMJeRjsyrCDxTBEFPhc9caO3
	EM41HIbzEg5gatsYHo/sl3bngCbjQ==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021100.outbound.protection.outlook.com [40.93.194.100])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 496pby2vm0-3
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:44:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R+xsZj1U0Uh5qG2xYRV+l5iaYyApEoPRZdRhhCESjYYuNlI0bVFRSJjwSNZDy8XNIqV/c6r9CVZZpvcC7eFOM8aBBNfq73MRlBaRVKusA1P/v4SNrXTscY6rnGrJsNViow0xathhWEOUkj2xlVZIjJPvE1IPTPHLrpMiQ4hB3YIxphWaNXsD+7EzvOYUF6nUKAkmHhxaU5gQ/aqI/I5TjIl/OWL8BrIsQy63xcE280i5Icb0L9LFOoWMp3mFic9UuBEl+YYYT2YMpdyTaClT6naSJeMBMJKhq8MdgkWN9hJjiwNqG+61SkHVRVuzDuBj4g5RHyZn6g49gjvFtGL2Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cgu/LPsjNYGWT+gK+SlO7durNrn90q9oe+Gkgc3yBo0=;
 b=dYq1aHfFX35SQXqOfotfGqt6GzGOPe4uNesMGPyhvchFym5R2baALEkMK6UOw99OJYk2e7nxjgas786LD/BqfKe8Vm7mEVQi4TN1yM3dNijQl5NOhAtFXXeS3G8HBFkl1yl7Fa5HuUsj6kf95BXXJvTC51zkTXqgdMCW3wUYDEW/QUL1e0VkjCfGhESsgHQawmvfd8WYiBaiN+nT647ItFoUI5uKwnE19vJyS4Mm2CHZGDuorp0e7sUGbb3ZnuG1cb7V0bvQ2K3dDE+VvCG9SVjP58houQ3BcWhOGlUVKTudZMlFM/Zg9A2Z/a0R57m6C+qVAFLzyaVADqH+gRm1jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cgu/LPsjNYGWT+gK+SlO7durNrn90q9oe+Gkgc3yBo0=;
 b=MFhdYX4SVmXtwswzHfMn0jP0vnuy779uBobGeP3kgnb8J5juKPd7jeyc4CVzTwRzlQDGcKyezXbaOl9sCSyT5oOWsjC4VlVdZb6qwAw7HGAbHFhfqOH6eAceZUS62OvC6rARTfhPAsYMzCVNec2mh2tzY1EP9UAqG1NGgm/NoRC4hHu+GNc6APB3qRUCv/+LE0Ywd2Cm4iVnFSlmPJhJyIpgN8/38BhCfDW5kdpwRxaBG8ubYCXTA4LAErupMon/5LDSMfkEofHWHE/RDVebegKbj7qLzVzrtklHV9jhXq6ptT7tCNbKrP0aM7wppoNBnT9x1gHfzGlc+GzWZqrl1Q==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by PH0PR02MB8501.namprd02.prod.outlook.com
 (2603:10b6:510:100::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 16:44:54 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:44:54 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 16/17] x86/vmx: switch to new vmx.h interrupt defs
Date: Tue, 16 Sep 2025 10:22:45 -0700
Message-ID: <20250916172247.610021-17-jon@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|PH0PR02MB8501:EE_
X-MS-Office365-Filtering-Correlation-Id: cd198468-0a03-438f-f6fd-08ddf5405d09
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4Ae5WUxreYJRPF3DrRyRv0ka3asWMHLkyv5bqUDn0y2OiW4J0UR5Ba8Brjie?=
 =?us-ascii?Q?20iKLkgkOCOg2JyCUm1YaWlOwP3aEwNRNkbPxVeELY1AxtsUXHAduEterFJX?=
 =?us-ascii?Q?FAHH5BX9j702CUQPw5Ycn8JOxjbiG/AKRVEba0COFuEdR+KnUuUnCGFDMZat?=
 =?us-ascii?Q?fLQ5/UhRBV4l8MAj91gFFksWbIg0W0u/+v+sgzkhgAp2lqX68jVLIV8u36kv?=
 =?us-ascii?Q?/TgRh+UxshI/lNiECIO5i8lrKa28KqXHUj66iq/tv3XDQTV46MZfpLYGMofe?=
 =?us-ascii?Q?g9jRSLbusXHRm4XjusLPHRxZlAamynFybF7j2OvjEIhyOftdmGZ/n0hVSqKN?=
 =?us-ascii?Q?W+3CDp+boJZnHQWnQaWNn42vP5FX0ReuEaS6pnSgcjI07HVIn0p+RdqSCfRw?=
 =?us-ascii?Q?LMk3estL9u+tdTzYTpIAlg42J4ggupTXQn1RMLtlGzgRPz/Kyhcqe9UBuQge?=
 =?us-ascii?Q?YTUZeYrpsvMk/oWIIasRtjIZzRWtxzQu1TTcXMc3vZIBDIdGBJNGUKx5VQAa?=
 =?us-ascii?Q?ujz26rSrd+AqeM5s4r8DkDsFGRh1YJIeM1iDhsl8oLD1xeXDxz1AUBgjus/N?=
 =?us-ascii?Q?Uid9umpbTpeF/Oysqdl9Li6fY+Sb6RETLegzBdQVUlc7jXCMoHZ1UtsHva4k?=
 =?us-ascii?Q?FuJRZfU+EWfwM7VKMcnAf2LArznqBphvfpl8XFuv3eW5o0kuND9vqkGNk+LX?=
 =?us-ascii?Q?GeZhz5pFkNQGtc6CwUDeb6MJTzvKn6kzk5YzRvFbHahon/RPf5VlJVaKFfeY?=
 =?us-ascii?Q?LavIZlm7hWABsLLp42JBxbacJMBxr4BWJHAoMmGG9EIoiyKR7roAMj4mv0ef?=
 =?us-ascii?Q?KAigOQhJ3r9yRPc+ZAqsUiejS/TWl+QgCMtIIiRmxtJrn4HgqxAMasn4v5pp?=
 =?us-ascii?Q?M2GNNYVMJtoHtSsg1kyr8mRYtjWwqOzYCcmCDVRWU2VY0biuWW7JvXMPN8pj?=
 =?us-ascii?Q?w851urGA9VDBxi+RXKZ1KJsh40CN+rOi1ol9UXfVQ4JVzls62PWOV2GKz4g8?=
 =?us-ascii?Q?uDn9Rwxe6faJrYWb13ZP3KH74CKArXV04F9UfLJnS/QtwZ/fdEgi1IbeyCnW?=
 =?us-ascii?Q?q1TECgh3PUqPdo0sabFcuj79Lw2/Hb9NXLnTlU7J7tWWN6mZC933C00BChf+?=
 =?us-ascii?Q?z8gG88v1zrs3jLb6u25ES40jwJdcKrLgiqlYViXKN7vF7w5CLvTxnoAfbcaW?=
 =?us-ascii?Q?zWYXIGd3KGecUxmKrgEyLHHqYG98FKOw7Me9PBUO8osmlab3Omad1i0AcpGX?=
 =?us-ascii?Q?s/Aa8xLIu3FyMWaCcSXx3ilL8UJP7f60FED9JpsRnLiiTdPXT4yIov7h3x5c?=
 =?us-ascii?Q?6g5t9HuZ1tp0Q/BaQJUadpgiqdRWe1xVJoPvn3/0Ruj7ubFVJFunJZDatdJh?=
 =?us-ascii?Q?ewZp6pCp91yaw4rNS0RVMxMU4NOXjToXCVCp/3xTNZX7HhsQilA19ErjByiO?=
 =?us-ascii?Q?vv5qRysGXQUmGyZVEmHZXgr0d49oHOTtowg6Ct1u+gp50uyBMS4Abw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?H7X1HDmbx9e33FlmJrwl17zpjMnP5uPeqa+huNZQJxIUZUaCmDlLs38O1ESv?=
 =?us-ascii?Q?0MsIeunFv63aepqBs7/F2Iucc5WWrixkkKyPwF74eN+YyEQ8gV2jQC0YJtQd?=
 =?us-ascii?Q?jrKnalcdHFv87YI1b8kBJQ9QlF5uobgyCISro7rtPww/Wir1sPwRusnUuP3V?=
 =?us-ascii?Q?bqku6aECHuFhQTAPHCpqTw1e9x6kji63af3WJpVy6o1IESyxD5UKth2IwzFZ?=
 =?us-ascii?Q?eUzzn03LkCb0GgVo8sfOaQRyRzzXj8coaFmzijbYdQ9cb/rYJUSt57OqhYw+?=
 =?us-ascii?Q?DTDXTnBUGsSt5pvrAXJE4Hr/5PEAbXwu82dzh4XwGT5JqZFD2qe98RUsijJf?=
 =?us-ascii?Q?3Xhmn6aGIOmGKiPMqpEJtPuSygreF5Bt+U5NHCVeyKARDT10BRQH+u6VEO3a?=
 =?us-ascii?Q?C5vDzc2DVnYBSELLD6UKhNQAJ5lelws6CKBYjdnTuYgjM1IXYGygPCW+2vDh?=
 =?us-ascii?Q?rFCJhuEc0Si5E3fRc/MguzoO/klEJLk58rHHt8rxp3NcOpMYlxwu9VazEjgC?=
 =?us-ascii?Q?CWlpqXJvqA1/ijTycCwsochrNpfsDZqMLxSfnPnTHPV4Lh1mWR0JCEY0ciJL?=
 =?us-ascii?Q?BX6Xkk+JVibgIfHDt9Pu287RRwB2u8gfM+x9qphr3cK2ReQLFt4LH1hELFLC?=
 =?us-ascii?Q?BgTXCMPQ6lcsii1hZ6oup57Ll7v3tIMrDULj1XvjMrNYiLpHY0U3Q7HKmkT3?=
 =?us-ascii?Q?Cc4jrzJkxtAzHQ9AaC4IGlR0FeqBvxh5WsyLTe13epTCzYl3EwumGPg8iQND?=
 =?us-ascii?Q?gPa0+z0sBUgGn5HKjzr1x71agG3QhGPKBzZPm1ptW3gHRvQqUEKpTsXfb/Yv?=
 =?us-ascii?Q?n80psM3IlwFMCifqDDNOsAH5Td8hltEfoe5oiAX40MYCUSCsFYLM9/Lbyx9F?=
 =?us-ascii?Q?6COMk+2FqUrf07D4UW9BZ3VA5ZIHc5N8DIyzHLXCM2ch1tYSAT0aZCYLkh2l?=
 =?us-ascii?Q?ycNnKsNl+rCyay92SHuQjYzpblpZUnOQpQ9LOo9JNacEubQ4qtmbSj3iafq6?=
 =?us-ascii?Q?tzWhNwuXU59ypF8EkClo+pbU8WFhxrZvjlhzlCsG0ciQ8UrpXETthmuU9Rsl?=
 =?us-ascii?Q?sg+S/5dW9yF442vKvoWA0LzX4EJ6qRX/PEN/GDEf3ke9rF7YlAiz9E1Q/NdQ?=
 =?us-ascii?Q?wCvIEfMzrGaokJyPmEPAvp9GcDFfQ99VhvKxGLh+IHintf7AwAhInRShBziv?=
 =?us-ascii?Q?iD7zttZ2SOB/wFcXSojBVAF9dtDW4A5bYo90XCYCqTa/pCJNGrJEvE3R9ltb?=
 =?us-ascii?Q?0L2UauC9pyAuYCHLf36YeoG0tll6Ql8NLrD15owU/9Km7FfbenXm7yS1pHVz?=
 =?us-ascii?Q?Lz3LGL2tBkcqbVbz8zWHCjcGFkXYccrAtcFbrayVPn5+LZ34DKTYjBYoKAMH?=
 =?us-ascii?Q?npW5aK+ac9Df/T26hruxQtxRK2t0sDNAE+yOfYWY7IZyN+pf8hwnJNKB31NT?=
 =?us-ascii?Q?y/U0LQ7Z7PckdsIcj7OoPwp3CYF0kOPL1w6960sEACUl0VdqvmbSWkokvAa8?=
 =?us-ascii?Q?35Sj3Bf27tdmA92hmJuPY6VFzkuz8KfLrMgaLtuGWKjNof6X1W+CB/nO6QDO?=
 =?us-ascii?Q?w+mKqJhhifp1qLw8m44HgzsxoTIJibkftwdqiDAIZ5y/Aw6dKlbwlJYsmD6H?=
 =?us-ascii?Q?Mw=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd198468-0a03-438f-f6fd-08ddf5405d09
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:44:54.5775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qVZq5f6CbMjB+NPqwVbwasHTV/HHnJLzVw2Pz78QOB6if8GYnBN6154JEISCuhcqmCV83dB+IyZwDiooqMnDMvCSStrsAfYV6gufn5mIdmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB8501
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDE1NSBTYWx0ZWRfX4swS1P0pYcsX
 dFbxLeijhrvCXw4eZ+UvRdzFb9Wbk5RdSWE7b4B0zazwT3apkEiN5mZ/TRVZWwgWUh7+n98zBQs
 Gz7WXXuddRScx42XaVvpHeAMfv5HlXwqdjxmGxMu3zmT5J06X4U6mLUtJa1aGIA+6LVxUBbPoO0
 BH8iMW71oHn+xsNSTmpeOUoCzj8h+cxU4rlRcSV8FIuV/lLkOnSgGSIrvkY6dC3qETeKlmB85Cy
 4ogSFU+7FXktdjHTGlgqM+D3sZ+4Zq8kMzzKIJJTSbKPPx/sqp1kra7OnJKWJWjdH6PKA82Zu8g
 RLDoDgKlQOBEaBCHQkB4ZEPNwTq1vVZ76DwKALny2NiYE4CPHMiqxEZM1wm9L4=
X-Authority-Analysis: v=2.4 cv=ePoTjGp1 c=1 sm=1 tr=0 ts=68c99407 cx=c_pps
 a=q7lH8giswqu+5i8oUQ1grQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8
 a=1RFaDTrvd-M15aC5SB0A:9
X-Proofpoint-ORIG-GUID: Fbgh1rNbGmZWHKWQllrRVc_2WeuBApUP
X-Proofpoint-GUID: Fbgh1rNbGmZWHKWQllrRVc_2WeuBApUP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

Migrate to new vmx.h's interrupt definitions, which makes it easier to
grok from one code base to another.

No functional change intended.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 x86/vmx.h       | 22 ----------------------
 x86/vmx_tests.c | 12 ++++++------
 2 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/x86/vmx.h b/x86/vmx.h
index 8bb49d8e..99ba7e52 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -406,31 +406,9 @@ enum Reason {
 	VMX_XRSTORS		= 64,
 };
 
-enum Intr_type {
-	VMX_INTR_TYPE_EXT_INTR = 0,
-	VMX_INTR_TYPE_NMI_INTR = 2,
-	VMX_INTR_TYPE_HARD_EXCEPTION = 3,
-	VMX_INTR_TYPE_SOFT_INTR = 4,
-	VMX_INTR_TYPE_SOFT_EXCEPTION = 6,
-};
-
-/*
- * Interruption-information format
- */
-#define INTR_INFO_VECTOR_MASK           0xff            /* 7:0 */
-#define INTR_INFO_INTR_TYPE_MASK        0x700           /* 10:8 */
-#define INTR_INFO_DELIVER_CODE_MASK     0x800           /* 11 */
-#define INTR_INFO_UNBLOCK_NMI_MASK      0x1000          /* 12 */
-#define INTR_INFO_VALID_MASK            0x80000000      /* 31 */
 
 #define INTR_INFO_INTR_TYPE_SHIFT       8
 
-/*
- * Guest interruptibility state
- */
-#define GUEST_INTR_STATE_MOVSS		(1 << 1)
-#define GUEST_INTR_STATE_ENCLAVE	(1 << 4)
-
 
 #define SAVE_GPR				\
 	"xchg %rax, regs\n\t"			\
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 2f9858a3..338e39b0 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1763,7 +1763,7 @@ static int interrupt_exit_handler(union exit_reason exit_reason)
 			vmcs_write(GUEST_ACTV_STATE, ACTV_HLT);
 			vmcs_write(ENT_INTR_INFO,
 				   TIMER_VECTOR |
-				   (VMX_INTR_TYPE_EXT_INTR << INTR_INFO_INTR_TYPE_SHIFT) |
+				   INTR_TYPE_EXT_INTR |
 				   INTR_INFO_VALID_MASK);
 			break;
 		}
@@ -8803,7 +8803,7 @@ static void vmx_nmi_window_test(void)
 	 * is one byte.)
 	 */
 	report_prefix_push("active, blocking by MOV-SS");
-	vmcs_write(GUEST_INTR_STATE, GUEST_INTR_STATE_MOVSS);
+	vmcs_write(GUEST_INTR_STATE, GUEST_INTR_STATE_MOV_SS);
 	enter_guest();
 	verify_nmi_window_exit(nop_addr + 1);
 	report_prefix_pop();
@@ -8969,7 +8969,7 @@ static void vmx_intr_window_test(void)
 	 * instruction. (NOP is one byte.)
 	 */
 	report_prefix_push("active, blocking by MOV-SS, RFLAGS.IF=1");
-	vmcs_write(GUEST_INTR_STATE, GUEST_INTR_STATE_MOVSS);
+	vmcs_write(GUEST_INTR_STATE, GUEST_INTR_STATE_MOV_SS);
 	enter_guest();
 	verify_intr_window_exit(nop_addr + 1);
 	report_prefix_pop();
@@ -9479,7 +9479,7 @@ static void single_step_guest(const char *test_name, u64 starting_dr6,
 	vmcs_write(GUEST_RFLAGS, X86_EFLAGS_FIXED | X86_EFLAGS_TF);
 	if (pending_debug_exceptions) {
 		vmcs_write(GUEST_PENDING_DEBUG, pending_debug_exceptions);
-		vmcs_write(GUEST_INTR_STATE, GUEST_INTR_STATE_MOVSS);
+		vmcs_write(GUEST_INTR_STATE, GUEST_INTR_STATE_MOV_SS);
 	}
 	enter_guest();
 }
@@ -10982,9 +10982,9 @@ static void handle_exception_in_l1(u32 vector)
 	enter_guest();
 
 	if (vector == BP_VECTOR || vector == OF_VECTOR)
-		intr_type = VMX_INTR_TYPE_SOFT_EXCEPTION;
+		intr_type = EVENT_TYPE_SWEXC;
 	else
-		intr_type = VMX_INTR_TYPE_HARD_EXCEPTION;
+		intr_type = EVENT_TYPE_HWEXC;
 
 	intr_info = vmcs_read(EXI_INTR_INFO);
 	report((vmcs_read(EXI_REASON) == VMX_EXC_NMI) &&
-- 
2.43.0


