Return-Path: <kvm+bounces-57744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF30CB59E06
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:45:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FB5D3283F2
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F8F3016E4;
	Tue, 16 Sep 2025 16:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="QJcXRk7S";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="IaIyL7SC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10DA31E8BA
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041098; cv=fail; b=bI+7p/ZDwa17174rM+uxjPWue8fZ4+ILDM0l8y5C9PQ+El9fX7oGk+0g02drtg5vxbVOmmUAxHFG4oxxxh5sr5yo06DtAo9deHPS/VShG6bPufO6KWpHmw40cd7WMkdmpiSWyYAWQAvgUfygdkpKhpzkE2Erd36piaVjzLcwT6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041098; c=relaxed/simple;
	bh=4OtoN+29wOvqTWMAQYY508stjS884UwYwpqZXPAcgYk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h/85AuOab/zN9fRPQFvKDhLu2MGWHulQkEXbsr2v+LfUMXQbqLtm1aqJbv471SrrqoV3oZrtf1aedlsTMy1F1TMdDVPg0eKRzHq84YjJch+USyDANvr191NOGO4ukXT5t5UIBSUmgg+5JTr3j9eLEEGSvE9SA4942HouknWoRDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=QJcXRk7S; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=IaIyL7SC; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58GDx7sV1608646;
	Tue, 16 Sep 2025 09:44:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=1YLxEtY13k2KxA91OxQLxE2nmA1Jipmre2YK3f64L
	0c=; b=QJcXRk7SK2u1PiEG09Uu7xvH1XZJTSs+zoC2ZUoWTIlvNtsjO45Xllu6I
	HuNhbttTUmC4UPXOCR+kvvznYM467Xagb1Ljcuz1Jh4KM/xnXi41hM4enyMAtcBm
	mw0EyWTC0ifAB37U0ItSNHVMUsAEvMCVPZ7zffZ2IQDh90owQFXUQBcWk7XyTjjh
	wmv3fa+WS134iCnT+EKui5vuHjtwfBEZobY6bXAcaEm5Bv9L4TBWsbgdfdQbOUGw
	GobBCB57hMXvME1b5bL/FtTu1n21q5X7cEqiNbU7SKYLiyKeIodKvFIX0WPIuepX
	zOvn1WaILg5Mi+MxQGWI8a3dXOGmg==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022084.outbound.protection.outlook.com [40.107.209.84])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 49798qre8n-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:44:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ROjXIg3AKIVOn19xrxk2RQKoEjEdzerDAHiqNh0bTpbaYtTpRyzC625SFJ8IR/dz/KY4VClGjdp7bNzRDHRGRNlKF0qloWZauZDCv5eU5JavveKJuS9lsB3HMJZxtlRF2Qrnw3zPxZzKE4d+nAG0nj7VaYPDKhadoRcCpKCuA4P4fj4oKA9owQzF7GXmCZ/a2G5xd82/+hPbt6qxEiQJhC7FCRTAqIH3vR3oUfQrfxZVkEDG+wNBbE3afT/Pq+xp9cbkXcTDwyXZ6Ig2+6skyCnKxXa9sUeUikhgumO6oCrZR6rwm9dYqqHlnOMeMxJKraFxJzVSoakPSqVQXlExwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1YLxEtY13k2KxA91OxQLxE2nmA1Jipmre2YK3f64L0c=;
 b=CmbvuI+N7rDCl9D0A01NSFDx+BJxa2Rb7haG+geSafzdPw35n79BLlH8RqEbSQBPBUJfgA5v9vtTJeRmp/o9r6oDr1CJW+sV465xWXBHgzjjvr1yCV1JFvPsfBIAfm3gwHrLEQ8nqV03/l77X83XYhJov2uB1uSsoNb/1MBYto17A2s8+8GrcLY58r5m2thWrbD13beFTFjXdLKoSFaYohpO7Se3TxLMlZrP/e8Agy4vrQYabBgF56XNdNGWDByGpCXOQYhK2SpYAP+iOOMk+hwwlkidY7CqSuw3TA7wASqp9/Z4ebMEMh7vEJEXy9eZqmDRcF/u9xVW73Ko0TC/9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YLxEtY13k2KxA91OxQLxE2nmA1Jipmre2YK3f64L0c=;
 b=IaIyL7SCL0vX4pHC75W/b6Gey5uffLWcQRb3jQ9CmOvXG3c2vUiqp9LzHkv8TxMgq+9pYgtV3GuTynmtiau3YRmQFno0Ob2xJmyN3NQYUWdvcQLVGRoX0Ptxghqoi+n8o+ANh7ZbrIt8mtwh3pJOkAVx7UJfmYqVmR6n5zINSpO7v4fDiguxym7vFelxKIWLh6ugbrRHiFCmFECJ2y1rdwFkwT+ljrk+57ZqUkvlxlLi5R6bp4h+5tVtLDXIehp/MczEUfUCSVcMPwoYWnilXFkpQpIByRxc3jv5mPcLgz4cQfKUFRQz+mWivcB1egdiqvGHQtYZqCR9Szucoxe+Aw==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DS0PR02MB9620.namprd02.prod.outlook.com
 (2603:10b6:8:f7::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 16:44:44 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:44:44 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 05/17] x86/vmx: basic integration for new vmx.h
Date: Tue, 16 Sep 2025 10:22:34 -0700
Message-ID: <20250916172247.610021-6-jon@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: c875bf9b-2dff-4c6e-be09-08ddf5405703
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eHDyz6kzw4OPOKKMo5qz1BuaIES166BhXcjnon5j/p9Hzd9ObEbDAmFgHV88?=
 =?us-ascii?Q?XsQweLzJnXFUbWJoAUwuG1bHsFah2YQpjM1b1s7uLHXcljp7GArXLcvw6AFc?=
 =?us-ascii?Q?7EIqFQWsxklFUlLMMEhm1GOq8W4QbGEFxRjfSY4rDfnP2Y+7Jk5j7U95cyPI?=
 =?us-ascii?Q?1CjNOtqy2oabNAbV8quztqxXSjH8I9fK8iLa3nya8nk7fvSbd3nzpj2n4aTi?=
 =?us-ascii?Q?d3K2sJCVs+rhW8CZhTUzUMSpju7cZ3Iy5LZ1nyMISkRyt0USabY8tb+QRz3m?=
 =?us-ascii?Q?djwnZTRRCGdfKvKJa19KnxyLfR7UONXlk5l2+4OYO30FIC98GNaI02hYPyru?=
 =?us-ascii?Q?EEOoNlkmUnTKg8O4uZiSHI/pcf3H0yp6CVDEcy52KcgjKv+ccc2fq23NEOc+?=
 =?us-ascii?Q?vnrOO22zlxF4qoLB/6qa9B2ZzadHbg7sNWTTvmuo1WOLWy51WxkQVvY5PWIe?=
 =?us-ascii?Q?UBrhFsdXmz6Q7E/Hu29MzznmjcbZD12PnmQJ85Ga811cnyjov1S0MiEDhuzy?=
 =?us-ascii?Q?EV6xZR+XN1dZJD0n/DxdnfDpNUkF6WN08BFgFkAJKnshoXRLwlnd2nxahJGB?=
 =?us-ascii?Q?6qGk5cniJXlvW3NsQd3dFLvKzbn55b8eJRU3x1THw3uHW5qcZnBCik3UowIe?=
 =?us-ascii?Q?cLS1WFPQp1SaZLrlJm3dREswjhLiKJhoyrsGje9B9n0fARAaYm3z20F2at9M?=
 =?us-ascii?Q?/ttjTEKaUj/rRsUscK4hyD6bRFQ6+N2dX7iFGDgwY21pAxf7Zgg+y6/9+sgX?=
 =?us-ascii?Q?eOjySNqUVv/i1DvOCDUztViUiLh2LH+8RzqCEXDecgqrm94ixg9fNIymUOJs?=
 =?us-ascii?Q?R9p0HOYDQ0/3yxLSE/8YJaERIpJo0p0CXQW2on4kP6gIDoFL6/9WgyZA4By7?=
 =?us-ascii?Q?ltSS/RCKG1DPrqyClMZanOPZ3UqFSw8HT2QIJlbudKv0Gr/pJOAeP2v9D8VS?=
 =?us-ascii?Q?UgWuVLQqtYpR/CCnWwhYBE5zuPScYpwn962r9Jkrzwo77DlterjE/BinC8hp?=
 =?us-ascii?Q?dmxF4qlij7zNFUitbJuqaPZUZGDjhXnqHaU4OJh61tdqq3/4W7WtYx9To2iQ?=
 =?us-ascii?Q?OSMVD3+2Gg3W0p3lkWd0Ymtw9IgLj3D6yi5hykdWivyTgoKQjGHShMbR8BXm?=
 =?us-ascii?Q?8yfXK0pGn2xjbK4U/OMYANjjoWSEoElgp6AJvzUuLTuPQyYrvNPxiuXCTSwK?=
 =?us-ascii?Q?hoEfJpz3xq9tcEOutlN+QN6Ltbnt5aIHqVxut2oCZkzCL7qWSO1aAD4NsL5U?=
 =?us-ascii?Q?755uuzkXBqKvFMFtDwXNhi3ZG97bxa0NnUsgegepVU6pABV88nYTsWM8ya0J?=
 =?us-ascii?Q?nS6Bg/y1IPLaa8x2p6NfqMVaXhFRKXJas117KcqKMtglXzuU9lI221WTu+QR?=
 =?us-ascii?Q?pXpG4atvonQGKequoIinCSqmA0YPOoZWAXQ+/oRjzAVAY3CrnEBE7ESMhHOQ?=
 =?us-ascii?Q?u7rQVXWcXZ2uRtDMBd8CloNrL4pz/axQV4GZQ564Q4b0hGPT6MeXAQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jEx4bkBA0tPdnH3Ws3J6KG4dtSIU7wPg5XMMlT4AOgs2Ak55gNxuYUvPHkhE?=
 =?us-ascii?Q?LFH80mkm6txralU8EB0ds0dnO8XEo3eUZwmun57GCmYgwHnyYqgG5xDTpuhr?=
 =?us-ascii?Q?aL0Fy/wdt5+sU58cn22dsU3bdDDJiqjupAPbGv7jqRHnw3skadQY82MgNIbc?=
 =?us-ascii?Q?xDgRCGmdnFwKuHwrJBwH+m13hhgx9NOpb9V/JuUB8vd8bXqJzJshzNMZ9eQD?=
 =?us-ascii?Q?gnZIwm0kStKf2cp/ajBl9U4d2iC/ztMpXUGHNBz7jDSnjaRAw2WBvsKGJNM7?=
 =?us-ascii?Q?oubOw9mmF+CZVku9ODYVTF5mGRPq4dLeUZlIAiPss6rkpIP+IvNlGEjNtkTV?=
 =?us-ascii?Q?5Epwr/kJ7RMse4qLXXDflNyclf6F9viv2Q5ozcdqdXDtfu0AURTSXyZVDqfj?=
 =?us-ascii?Q?ZBSGJqafouoQW2OFuhSxKpTX+rT/reGlKnnEY9Wtlrg/EOl2lfWQkEOqfTjK?=
 =?us-ascii?Q?Sq01oI+aDUiqk22abeehmQ/R9M9il9zmRvc+Q22ARFziC0wKWsrx+E5QXzol?=
 =?us-ascii?Q?QDsJukuyyYfRwd/xtckQ+A2N00LiTFRNjKOQwL6BsnidgH0ihWsSUKMI8IoE?=
 =?us-ascii?Q?tipcyhuYF2PL+QGNms17P1bvn8JZpXKaS2wvH1T7nQc14jT8DeO3f75tEkL1?=
 =?us-ascii?Q?s9NKant7fxDlTr7heNqwT1KUJpe7T2NggGjFJlwPZmRHlyls4rNQDJToKgTS?=
 =?us-ascii?Q?HnyBTj/eVuquk/FMUWyXuMIL7IoarmRxSRsucoM7dnXk92Ii+T1wfJysLvMT?=
 =?us-ascii?Q?SVa9cIZc63KrQ5XkJs8H2sezCNoEioPRYgrgySx/r53EN6w4NvT4XUBG8gqt?=
 =?us-ascii?Q?AAC/kpkjBr5xjrbsV61fg8zYjzFvhQ1m498pnOn/kH+e1ini23hfRgmRJ43j?=
 =?us-ascii?Q?aI+4Z3S+88rwHOvnAScJ5P2nxju5TvMNuLkTW0HWRK62qbq8sxnpUhIPpVPd?=
 =?us-ascii?Q?57C6e1AqqiSMZ5X1Sz+/raXpeMdaCWKewI3Yr7EXK6w493DbawOI7UbHr2qo?=
 =?us-ascii?Q?ufdXIiyT8OBZExodFt7/1IPGZrlKYUPuiOwJB/hgmzQhuwYgaaJmYHn2Ojv5?=
 =?us-ascii?Q?CtMbSe7yf+9UzrXy39TWH1lbbPiMNDehz/zTpyGBVEyAwlsUTp7LnT6vD2DN?=
 =?us-ascii?Q?F62v1lv4ajvqJsHxJhySUscFsEoo/UYAhP1mMyQw+XLxWtLf2Sm/KU4XOP19?=
 =?us-ascii?Q?vlFP6+LHeJAWykyqUkn5fl4N8fZsun6AOuW0QrQCxxhIzV5rnzqDOWlqY47l?=
 =?us-ascii?Q?TlcwxO58x0GlcBs7PRwwrPL7iFTExEaJdx5BQs9BIxf5h4jSUAp4LqW+ehef?=
 =?us-ascii?Q?UPh2Xs+HcgzuPocQg/c++ePkTGLG5NW4hBA5fU1iB8V/byNHKh+GME0O0Lw1?=
 =?us-ascii?Q?LYP8jVgKInVVvaGrlj5TPAHv4rd07MgGFt9OWjps+5A2QPD9k5GOIIw2lc1e?=
 =?us-ascii?Q?Kb74nVi4LThgChSvMBfZVqPU6q3S5uzyV6TrS2tx88ie2OSgGpGlsXpY46Ma?=
 =?us-ascii?Q?xDn3MlJ10jxw/5mMzMLOzQ/QK8M8sTCrH8KXtG9XIq37I8+8rQOe4EZOiEmJ?=
 =?us-ascii?Q?YkYOApsjQGJP8KEzzXu/wPePX5rGmzhJBvo4w5Y/K5LL2IK5W9Uad8qNGMu+?=
 =?us-ascii?Q?cA=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c875bf9b-2dff-4c6e-be09-08ddf5405703
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:44:44.5047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DQq3KXcPtDSmAmpBvc+LClxZZwLIyHpJ9BVjnts3myeGjbVLH7wmwW2D+agB2410y7SZzE57Dvx05/jEC4Obv0vS/KWuB/Ejp1oEx7JfvmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9620
X-Proofpoint-GUID: JP_frX_k8N__B58_cCasL6oc7AII1FvA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDE1NSBTYWx0ZWRfX1n6tsZY/A41f
 gA/xKfANeklLZyvIomNt/hatQfY90rPZlSR+bgNimDswnUXcZjYuMUtN5JSFwwXmP+iN5AoaJup
 IxgjpWC6oYs4e1Cs2JOKXTFp/KcvKV6nLY08BP9+qX/GmloVBpAOZImfiz+1Ah/aHm2qEArFdMk
 Ey/M91H4Z8XF4aWb43pChNt6GXQRRNQ7vKxHz9/L7C0w5iEwxy0RJqEg/v1sbNviZC8N6AwO9Wf
 b2kRmk13NhyvDLLy+Ou1u5+D3BSvuqnMvHbEmwBgr5uXR4WYcd/ycQeilvcN6c5btWhFV2Z8QHO
 GOcsNX+IXFeZJMFrQu4sgID5+eUn4AdhcGxSmYvLE0Cou52lxJpIqT6imfrADI=
X-Proofpoint-ORIG-GUID: JP_frX_k8N__B58_cCasL6oc7AII1FvA
X-Authority-Analysis: v=2.4 cv=WucrMcfv c=1 sm=1 tr=0 ts=68c993fe cx=c_pps
 a=NQnYyjwfQkqppbiA7sK3Qw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8
 a=pGLkceISAAAA:8 a=9dieK2k5wXIRhWDDanMA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

Integrate Linux's vmx.h to vmx.c / vmx_tests.c, and do misc cleanup
to remove conflicting definitions from the original vmx.h.

Make minor modifications to the new vmx.h to update includes to fit
into the KUT repository as a standalone header file.

Replaced WARN_ON_ONCE in vmx_eptp_page_walk_level with report_info.

Renamed struct vmcs_field to struct vmcs_field_struct to avoid conflict
with the new vmx.h's enum vmcs_field.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 lib/linux/vmx.h | 15 +++++----
 x86/vmx.c       | 16 +++++-----
 x86/vmx.h       | 82 -------------------------------------------------
 x86/vmx_tests.c |  6 +---
 4 files changed, 17 insertions(+), 102 deletions(-)

diff --git a/lib/linux/vmx.h b/lib/linux/vmx.h
index cca7d664..5973bd86 100644
--- a/lib/linux/vmx.h
+++ b/lib/linux/vmx.h
@@ -12,13 +12,10 @@
 #define VMX_H
 
 
-#include <linux/bitops.h>
-#include <linux/bug.h>
-#include <linux/types.h>
-
-#include <uapi/asm/vmx.h>
-#include <asm/trapnr.h>
-#include <asm/vmxfeatures.h>
+#include "bitops.h"
+#include "libcflat.h"
+#include "trapnr.h"
+#include "util.h"
 
 #define VMCS_CONTROL_BIT(x)	BIT(VMX_FEATURE_##x & 0x1f)
 
@@ -552,7 +549,9 @@ static inline u8 vmx_eptp_page_walk_level(u64 eptp)
 		return 5;
 
 	/* @eptp must be pre-validated by the caller. */
-	WARN_ON_ONCE(encoded_level != VMX_EPTP_PWL_4);
+	if (encoded_level != VMX_EPTP_PWL_4)
+		report_info("encoded_level %ld != VMX_EPTP_PWL_4", encoded_level);
+
 	return 4;
 }
 
diff --git a/x86/vmx.c b/x86/vmx.c
index c803eaa6..e79781f2 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -28,6 +28,8 @@
  * Author : Arthur Chunqi Li <yzt356@gmail.com>
  */
 
+#include <linux/vmx.h>
+
 #include "libcflat.h"
 #include "processor.h"
 #include "alloc_page.h"
@@ -83,7 +85,7 @@ static volatile u32 stage;
 
 static jmp_buf abort_target;
 
-struct vmcs_field {
+struct vmcs_field_struct {
 	u64 mask;
 	u64 encoding;
 };
@@ -91,7 +93,7 @@ struct vmcs_field {
 #define MASK(_bits) GENMASK_ULL((_bits) - 1, 0)
 #define MASK_NATURAL MASK(sizeof(unsigned long) * 8)
 
-static struct vmcs_field vmcs_fields[] = {
+static struct vmcs_field_struct vmcs_fields[] = {
 	{ MASK(16), VPID },
 	{ MASK(16), PINV },
 	{ MASK(16), EPTP_IDX },
@@ -250,12 +252,12 @@ enum vmcs_field_type {
 	VMCS_FIELD_TYPES,
 };
 
-static inline int vmcs_field_type(struct vmcs_field *f)
+static inline int vmcs_field_type(struct vmcs_field_struct *f)
 {
 	return (f->encoding >> VMCS_FIELD_TYPE_SHIFT) & 0x3;
 }
 
-static int vmcs_field_readonly(struct vmcs_field *f)
+static int vmcs_field_readonly(struct vmcs_field_struct *f)
 {
 	u64 ia32_vmx_misc;
 
@@ -264,7 +266,7 @@ static int vmcs_field_readonly(struct vmcs_field *f)
 		(vmcs_field_type(f) == VMCS_FIELD_TYPE_READ_ONLY_DATA);
 }
 
-static inline u64 vmcs_field_value(struct vmcs_field *f, u8 cookie)
+static inline u64 vmcs_field_value(struct vmcs_field_struct *f, u8 cookie)
 {
 	u64 value;
 
@@ -276,12 +278,12 @@ static inline u64 vmcs_field_value(struct vmcs_field *f, u8 cookie)
 	return value & f->mask;
 }
 
-static void set_vmcs_field(struct vmcs_field *f, u8 cookie)
+static void set_vmcs_field(struct vmcs_field_struct *f, u8 cookie)
 {
 	vmcs_write(f->encoding, vmcs_field_value(f, cookie));
 }
 
-static bool check_vmcs_field(struct vmcs_field *f, u8 cookie)
+static bool check_vmcs_field(struct vmcs_field_struct *f, u8 cookie)
 {
 	u64 expected;
 	u64 actual;
diff --git a/x86/vmx.h b/x86/vmx.h
index 9cd90488..41346252 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -204,7 +204,6 @@ enum Encoding {
 	GUEST_SEL_LDTR		= 0x080cul,
 	GUEST_SEL_TR		= 0x080eul,
 	GUEST_INT_STATUS	= 0x0810ul,
-	GUEST_PML_INDEX         = 0x0812ul,
 
 	/* 16-Bit Host State Fields */
 	HOST_SEL_ES		= 0x0c00ul,
@@ -216,28 +215,17 @@ enum Encoding {
 	HOST_SEL_TR		= 0x0c0cul,
 
 	/* 64-Bit Control Fields */
-	IO_BITMAP_A		= 0x2000ul,
-	IO_BITMAP_B		= 0x2002ul,
-	MSR_BITMAP		= 0x2004ul,
 	EXIT_MSR_ST_ADDR	= 0x2006ul,
 	EXIT_MSR_LD_ADDR	= 0x2008ul,
 	ENTER_MSR_LD_ADDR	= 0x200aul,
 	VMCS_EXEC_PTR		= 0x200cul,
-	TSC_OFFSET		= 0x2010ul,
 	TSC_OFFSET_HI		= 0x2011ul,
 	APIC_VIRT_ADDR		= 0x2012ul,
 	APIC_ACCS_ADDR		= 0x2014ul,
-	POSTED_INTR_DESC_ADDR	= 0x2016ul,
 	EPTP			= 0x201aul,
 	EPTP_HI			= 0x201bul,
-	VMREAD_BITMAP           = 0x2026ul,
 	VMREAD_BITMAP_HI        = 0x2027ul,
-	VMWRITE_BITMAP          = 0x2028ul,
 	VMWRITE_BITMAP_HI       = 0x2029ul,
-	EOI_EXIT_BITMAP0	= 0x201cul,
-	EOI_EXIT_BITMAP1	= 0x201eul,
-	EOI_EXIT_BITMAP2	= 0x2020ul,
-	EOI_EXIT_BITMAP3	= 0x2022ul,
 	PMLADDR                 = 0x200eul,
 	PMLADDR_HI              = 0x200ful,
 
@@ -254,7 +242,6 @@ enum Encoding {
 	GUEST_PAT		= 0x2804ul,
 	GUEST_PERF_GLOBAL_CTRL	= 0x2808ul,
 	GUEST_PDPTE		= 0x280aul,
-	GUEST_BNDCFGS		= 0x2812ul,
 
 	/* 64-Bit Host State */
 	HOST_PAT		= 0x2c00ul,
@@ -267,7 +254,6 @@ enum Encoding {
 	EXC_BITMAP		= 0x4004ul,
 	PF_ERROR_MASK		= 0x4006ul,
 	PF_ERROR_MATCH		= 0x4008ul,
-	CR3_TARGET_COUNT	= 0x400aul,
 	EXI_CONTROLS		= 0x400cul,
 	EXI_MSR_ST_CNT		= 0x400eul,
 	EXI_MSR_LD_CNT		= 0x4010ul,
@@ -276,7 +262,6 @@ enum Encoding {
 	ENT_INTR_INFO		= 0x4016ul,
 	ENT_INTR_ERROR		= 0x4018ul,
 	ENT_INST_LEN		= 0x401aul,
-	TPR_THRESHOLD		= 0x401cul,
 	CPU_EXEC_CTRL1		= 0x401eul,
 
 	/* 32-Bit R/O Data Fields */
@@ -311,7 +296,6 @@ enum Encoding {
 	GUEST_INTR_STATE	= 0x4824ul,
 	GUEST_ACTV_STATE	= 0x4826ul,
 	GUEST_SMBASE		= 0x4828ul,
-	GUEST_SYSENTER_CS	= 0x482aul,
 	PREEMPT_TIMER_VALUE	= 0x482eul,
 
 	/* 32-Bit Host State Fields */
@@ -320,8 +304,6 @@ enum Encoding {
 	/* Natural-Width Control Fields */
 	CR0_MASK		= 0x6000ul,
 	CR4_MASK		= 0x6002ul,
-	CR0_READ_SHADOW		= 0x6004ul,
-	CR4_READ_SHADOW		= 0x6006ul,
 	CR3_TARGET_0		= 0x6008ul,
 	CR3_TARGET_1		= 0x600aul,
 	CR3_TARGET_2		= 0x600cul,
@@ -333,12 +315,8 @@ enum Encoding {
 	IO_RSI			= 0x6404ul,
 	IO_RDI			= 0x6406ul,
 	IO_RIP			= 0x6408ul,
-	GUEST_LINEAR_ADDRESS	= 0x640aul,
 
 	/* Natural-Width Guest State Fields */
-	GUEST_CR0		= 0x6800ul,
-	GUEST_CR3		= 0x6802ul,
-	GUEST_CR4		= 0x6804ul,
 	GUEST_BASE_ES		= 0x6806ul,
 	GUEST_BASE_CS		= 0x6808ul,
 	GUEST_BASE_SS		= 0x680aul,
@@ -349,18 +327,9 @@ enum Encoding {
 	GUEST_BASE_TR		= 0x6814ul,
 	GUEST_BASE_GDTR		= 0x6816ul,
 	GUEST_BASE_IDTR		= 0x6818ul,
-	GUEST_DR7		= 0x681aul,
-	GUEST_RSP		= 0x681cul,
-	GUEST_RIP		= 0x681eul,
-	GUEST_RFLAGS		= 0x6820ul,
 	GUEST_PENDING_DEBUG	= 0x6822ul,
-	GUEST_SYSENTER_ESP	= 0x6824ul,
-	GUEST_SYSENTER_EIP	= 0x6826ul,
 
 	/* Natural-Width Host State Fields */
-	HOST_CR0		= 0x6c00ul,
-	HOST_CR3		= 0x6c02ul,
-	HOST_CR4		= 0x6c04ul,
 	HOST_BASE_FS		= 0x6c06ul,
 	HOST_BASE_GS		= 0x6c08ul,
 	HOST_BASE_TR		= 0x6c0aul,
@@ -368,8 +337,6 @@ enum Encoding {
 	HOST_BASE_IDTR		= 0x6c0eul,
 	HOST_SYSENTER_ESP	= 0x6c10ul,
 	HOST_SYSENTER_EIP	= 0x6c12ul,
-	HOST_RSP		= 0x6c14ul,
-	HOST_RIP		= 0x6c16ul
 };
 
 #define VMX_ENTRY_FAILURE	(1ul << 31)
@@ -528,61 +495,12 @@ enum Intr_type {
 
 #define INTR_INFO_INTR_TYPE_SHIFT       8
 
-#define INTR_TYPE_EXT_INTR              (0 << 8) /* external interrupt */
-#define INTR_TYPE_RESERVED              (1 << 8) /* reserved */
-#define INTR_TYPE_NMI_INTR		(2 << 8) /* NMI */
-#define INTR_TYPE_HARD_EXCEPTION	(3 << 8) /* processor exception */
-#define INTR_TYPE_SOFT_INTR             (4 << 8) /* software interrupt */
-#define INTR_TYPE_PRIV_SW_EXCEPTION	(5 << 8) /* priv. software exception */
-#define INTR_TYPE_SOFT_EXCEPTION	(6 << 8) /* software exception */
-#define INTR_TYPE_OTHER_EVENT           (7 << 8) /* other event */
-
 /*
  * Guest interruptibility state
  */
-#define GUEST_INTR_STATE_STI		(1 << 0)
 #define GUEST_INTR_STATE_MOVSS		(1 << 1)
-#define GUEST_INTR_STATE_SMI		(1 << 2)
-#define GUEST_INTR_STATE_NMI		(1 << 3)
 #define GUEST_INTR_STATE_ENCLAVE	(1 << 4)
 
-/*
- * VM-instruction error numbers
- */
-enum vm_instruction_error_number {
-	VMXERR_VMCALL_IN_VMX_ROOT_OPERATION = 1,
-	VMXERR_VMCLEAR_INVALID_ADDRESS = 2,
-	VMXERR_VMCLEAR_VMXON_POINTER = 3,
-	VMXERR_VMLAUNCH_NONCLEAR_VMCS = 4,
-	VMXERR_VMRESUME_NONLAUNCHED_VMCS = 5,
-	VMXERR_VMRESUME_AFTER_VMXOFF = 6,
-	VMXERR_ENTRY_INVALID_CONTROL_FIELD = 7,
-	VMXERR_ENTRY_INVALID_HOST_STATE_FIELD = 8,
-	VMXERR_VMPTRLD_INVALID_ADDRESS = 9,
-	VMXERR_VMPTRLD_VMXON_POINTER = 10,
-	VMXERR_VMPTRLD_INCORRECT_VMCS_REVISION_ID = 11,
-	VMXERR_UNSUPPORTED_VMCS_COMPONENT = 12,
-	VMXERR_VMWRITE_READ_ONLY_VMCS_COMPONENT = 13,
-	VMXERR_VMXON_IN_VMX_ROOT_OPERATION = 15,
-	VMXERR_ENTRY_INVALID_EXECUTIVE_VMCS_POINTER = 16,
-	VMXERR_ENTRY_NONLAUNCHED_EXECUTIVE_VMCS = 17,
-	VMXERR_ENTRY_EXECUTIVE_VMCS_POINTER_NOT_VMXON_POINTER = 18,
-	VMXERR_VMCALL_NONCLEAR_VMCS = 19,
-	VMXERR_VMCALL_INVALID_VM_EXIT_CONTROL_FIELDS = 20,
-	VMXERR_VMCALL_INCORRECT_MSEG_REVISION_ID = 22,
-	VMXERR_VMXOFF_UNDER_DUAL_MONITOR_TREATMENT_OF_SMIS_AND_SMM = 23,
-	VMXERR_VMCALL_INVALID_SMM_MONITOR_FEATURES = 24,
-	VMXERR_ENTRY_INVALID_VM_EXECUTION_CONTROL_FIELDS_IN_EXECUTIVE_VMCS = 25,
-	VMXERR_ENTRY_EVENTS_BLOCKED_BY_MOV_SS = 26,
-	VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID = 28,
-};
-
-enum vm_entry_failure_code {
-	ENTRY_FAIL_DEFAULT		= 0,
-	ENTRY_FAIL_PDPTE		= 2,
-	ENTRY_FAIL_NMI			= 3,
-	ENTRY_FAIL_VMCS_LINK_PTR	= 4,
-};
 
 #define SAVE_GPR				\
 	"xchg %rax, regs\n\t"			\
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 0b3cfe50..dbcb6cae 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -5,6 +5,7 @@
  */
 
 #include <asm/debugreg.h>
+#include <linux/vmx.h>
 
 #include "vmx.h"
 #include "msr.h"
@@ -1962,11 +1963,6 @@ static int dbgctls_exit_handler(union exit_reason exit_reason)
 	return VMX_TEST_VMEXIT;
 }
 
-struct vmx_msr_entry {
-	u32 index;
-	u32 reserved;
-	u64 value;
-} __attribute__((packed));
 
 #define MSR_MAGIC 0x31415926
 struct vmx_msr_entry *exit_msr_store, *entry_msr_load, *exit_msr_load;
-- 
2.43.0


