Return-Path: <kvm+bounces-49610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29F2AADB018
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 14:21:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51D9E188E047
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 12:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BD6B230D0E;
	Mon, 16 Jun 2025 12:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wc8KKL6N";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WEB2fQCL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01962E427F;
	Mon, 16 Jun 2025 12:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750076493; cv=fail; b=aAlTvqdDpr+yCTinnBmxPOngEnyLTlvAd58a1k6p5soDU3f7ztG07WhLxfOcNKgEo3DAtWDz8b73nrUgMHhxLEDWVksb3pLpGEM88XUxKX+I+Ieciq2KJuzwE/fDQKnbz/hAEG972gKs+bJgaOnQOTtm5QkDwR5fTspW+x941Cs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750076493; c=relaxed/simple;
	bh=mneUYeS0shMTsj/I76XbVspeewNU9LFCSBYZ1D57wck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AlCGRoatHcddpztSpc31hX7uu5u3v4vORbSedzHE61quGpd+LylmPcwGyzvfkA2haQVVHI74q63XmLiuiM/F5h3vpfk5hgXY+/MfBbt/gcCiRT127IU4KeO23j3wVuNy94p9ssgJY2owu/aYbTqcS49+BQjDrFc3auajYmZYbMQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Wc8KKL6N; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WEB2fQCL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55G7ftbu026596;
	Mon, 16 Jun 2025 12:21:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=mneUYeS0shMTsj/I76
	XbVspeewNU9LFCSBYZ1D57wck=; b=Wc8KKL6Njx8sVphBlvWrnrwNeN4I3x+axh
	ur0RaU+oWCfPZ3mjV2+kX0HbCOG5+dHvF6QyHZ1BB/WexHPVWRrxRlZPQhLrQLbb
	XPNZoCePKNWjOE9YBVcUGd9LaxbQBlVh30TVXG05fKXB3wO/uXqBfGjuNZVLbR8C
	TmT7YyqE98JI0xesn3NV1SJRZ6CATU1yt1BuzD6Z5sxkXVGGqjuIH4YoIHzOT5As
	4cW8d0LA0UxaRs/ahryH/pgSE4LhDrbuDp6XROJ1nXiM+2aUvjNarGz1eDN/m1L5
	0uOm0DaoXb5MYdSuhFj8w5D1CoC2d4x8crdGPmfpmYzNNoDOHBeA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 478yp4jd37-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 12:21:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55GAe8AX025986;
	Mon, 16 Jun 2025 12:21:02 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012040.outbound.protection.outlook.com [52.101.43.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhe3frw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 12:21:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b0vVaj0D+3B8Mx3xLfCmfG+4Ppo54UcmGKGsBZOYaeVT+q9/ERu9XRCLGYW6bqixFRtL3nalP4eKyR+71KW0ZEloaOd/aNCwAI5Qpp+TbYFjvQFZM0O3tP77wPe+1J0WJZpYLUCqoxESRm+8C8xqGgQ9ZnbcNn5ihamWwnPTXgmF3soxOKMIRnmMKu/KYxgFVXV2EQ2gfUrG0lTIiUFo9XKrmw9vz2RgrHPvuCWO+EVWUNRH0VUF/eJuS7lwhM8D2Rjz4BE28zgG8ObEim2cAGcFYV0jCP8qLs4VrXKz+Pmt54mzs2sth7BjXevaiWUQ5qtJkGniGEL45wPZrJJNbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mneUYeS0shMTsj/I76XbVspeewNU9LFCSBYZ1D57wck=;
 b=FwaN1fRkj35cc2sR0pDY9mN+ccavbwFtrxrcwKt1jmgHulxq9nuyQpA4QZFOVGKTI+Iodx3P+f/0QM3jPIaIhuadIW87kJPE2xGRSx1mLh7/+FfX4bb3Q175ZJRjsNUjdy8KWDXFwOkS4Jv8o4nt8jxqlTzl3HqSFPJ+O8+MBBA7FR24JOdHwHAv5j2BWr2xjNhkF3enjdyLS0k2EVTrQpVKZVrapj13U2XF4kzhU0EpKACjMAL8+dVN4TfUR4HSHjLsOE2JjTqzqr9+jsFuDuym4jzxe2B6vj6ORWYKw0HT+m/MAAuw5i4phDrVUDvZzRguDFuGLHCBa2v9SUD8dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mneUYeS0shMTsj/I76XbVspeewNU9LFCSBYZ1D57wck=;
 b=WEB2fQCLazcLajE+BHD4/SUhSuWprXoDy1vbk0UWyf7jxpyYhttH5/ydD89NzSf1nPQvbuspDQEYPKrH5zzTDKRt8fRjI0TLfpA78vSZ9rilCp3kt7AbsOwvXeWqZI1i9aV3G7PUIvp/0ZHVGEVSK5tEAaYCtY+80BIsleRuKwc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA4PR10MB8709.namprd10.prod.outlook.com (2603:10b6:208:56d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.26; Mon, 16 Jun
 2025 12:20:58 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8835.026; Mon, 16 Jun 2025
 12:20:58 +0000
Date: Mon, 16 Jun 2025 13:20:55 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Peter Xu <peterx@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
        Nico Pache <npache@redhat.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [PATCH 3/5] mm: Rename __thp_get_unmapped_area to
 mm_get_unmapped_area_aligned
Message-ID: <bb6230a2-8a9d-4385-ab14-a40b273f4c60@lucifer.local>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-4-peterx@redhat.com>
 <77g4gj2l3w7osk2rsbrldgoxsnyqo4mq2ciltcb3exm5xtbjjk@wiz6qgzwhcjl>
 <20250616121428.GS1174925@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250616121428.GS1174925@nvidia.com>
X-ClientProxiedBy: LNXP265CA0039.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::27) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA4PR10MB8709:EE_
X-MS-Office365-Filtering-Correlation-Id: df170f9d-551d-4d20-090d-08ddacd03fdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x3x9fYP1amf+AoE9+8Et8b3DYPed7aqyBDgf0CM3t+Tq2SdLUF+s/2l1xTv+?=
 =?us-ascii?Q?iRvjI3EDZC93BA4h9pWgk6BQslP4KSYlwEueOPV2LIav0gpb7bw08iz/r9zN?=
 =?us-ascii?Q?BOYkD8mM5icEr36vDD/uMkKRFtqSd7J+ezPu/e7M1vAAU6wSgEKrnDB7IF2F?=
 =?us-ascii?Q?WskAGIczJgm9i3swZA8YOW6c9z/k1BpqSlW8ua2q+WBDYmUnhBL/fAoNri4x?=
 =?us-ascii?Q?4NTI3aeDWmJsmGt4WmMtsYBrB2CIi2fDW3Bn48aFz/emgaydLiwgIx1GV6m3?=
 =?us-ascii?Q?CtOYYfSMdOd65EXiFpcYP4C9efVl/y/05KYwQzm+U0vAl+n5ZlvWtXlhqbcd?=
 =?us-ascii?Q?MBnuCzXg8oxX/IuswUnOT/KbyhX9LZmsNbn2cVdUdm0EzzOvu2VwSC7K0DrA?=
 =?us-ascii?Q?xyQPvEcz+CfYQwVMrX38apYy1w3A7fiiU4hM6yKzJiUHeD3z7H3FqUR4IzOb?=
 =?us-ascii?Q?WzkduxYc6WtDSoWufbaS0tKJIWv6mKQJa4y2wQTr37xvIk53AII/dUveqdcl?=
 =?us-ascii?Q?v2QIVm0mvlg+B45ct4lrt5ATzfnOrMVizCzWnycui4Jzj5wc+3peE48ZV2++?=
 =?us-ascii?Q?9M/0T5DLatkeRdm9DcZsqf9P8FhTMJ32ylXhO6W6hYeflIH37lLIusYfOpdj?=
 =?us-ascii?Q?ZKBcTZ0+jqefhWJuPvsdhAt8Yl8+NzdzBUhmKP0HuSJX/7CByb9ND4SN1dd6?=
 =?us-ascii?Q?xBwyH2zB2PHcA/0Csv9xT2D1X+HNVjMW9ytKI3zMa83mM0/f5UIQK79c0nkM?=
 =?us-ascii?Q?qqc/EYdtBqAOtCgbilXqALIWhhSdqpu1zJ7eU6eV0hIDh0XrEaNMr8h+smhM?=
 =?us-ascii?Q?2HTxG0lXf9Iap0RDzBPbexw3pqZOWAyq7BjlPnU/hk+vv2YpvBpvMxapdbD/?=
 =?us-ascii?Q?lPA79dDXcTN4smhVPlwU6uZ+/FdofTL66+rqKylc6Uk9iDlRuC2ELx5Znc0x?=
 =?us-ascii?Q?ApZ7oE6vZaZkg0+Bl/kdXJJArri7yfEL75t6aKukQFgsm60nRB86tLNH3BBT?=
 =?us-ascii?Q?S9Up/0k0HIs7d96Yojv8He+MQccuujvSxf2b/7CrD4HI2jGAGRLQcCClI9xJ?=
 =?us-ascii?Q?QyJiOx0bY0u59CYR5RjdIf5jpBR324p5+l+9W3L9V/3+rcNnXiHoyDbCNJCe?=
 =?us-ascii?Q?lhW1G4q7N1iFglGqN/4Tqso71W8ZyiIgMPbXPPDYlCqV/AD0fGlgiooJPjmF?=
 =?us-ascii?Q?zq2r5G7HCsns56jM+eXrw6XAul1wE2r5D8/M039H1oydUiSfxTrMHrcSTwIq?=
 =?us-ascii?Q?nKH1uVyoBVQGd/7+C0OUVoNs+dLyA43MmGwrL0/Vp9w8/in2YF3uT50fFPQJ?=
 =?us-ascii?Q?JcEosM5eswPdez3623M5VtsRAZAmXGKbJjjjDRN3Lgki6eCj4jC8eSYbd7hH?=
 =?us-ascii?Q?2oWK06QywHKDzQddkUrYxbOmks6yik1lVxXne2CNpsdSvxV9Ond5lusd3+2n?=
 =?us-ascii?Q?cTYn9GYsh4A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PRapFNNmc7xo0L2YxLjOUti+djdaNtyJornXmqtJCSPyfkLJVxddY3DYW12Z?=
 =?us-ascii?Q?xlZkIGkwEvGdu0WEGzh4ScybU/7OuhcIoxCnYBmqY16lp3vkcASqmIlrpAWj?=
 =?us-ascii?Q?6FPDZ6QAzxHhDdI9iNuqjpWkB1Qsggn70OPY1R/6fvrh2LbTp7jXEd4By2MJ?=
 =?us-ascii?Q?NvPfypmfHPDZLzH4GKrzuGWfpSmHfu7uoqxFUJAqYSL5m0h/RYHZApB9n25y?=
 =?us-ascii?Q?8Hm2XcxTg0xXlzXHR4QFwVBlJm8/WQKg60NzbtnoUnqGaWgzog3DQH19eUEp?=
 =?us-ascii?Q?dDr2FOAjsgS4ADJCEV2eivGWu6E8/3WIAsoepClPvrGALoUant0vCd40xjpR?=
 =?us-ascii?Q?ERlQUnWliHTQuaWO9ILWHsSL8vaMWzrapbhJ9BTKSQKx0KizqmUt8hdv7SFD?=
 =?us-ascii?Q?znCxjBO4QXvjl4p9wQvarCrQwiPWWvoJKbgASJbSFQAp2Izq9vCDVJ0pReE1?=
 =?us-ascii?Q?9IMtZCEtSpLVwx/45ol3h2qhDQ9009Txuzfl40NS4QDObBnlVcr9emZbFcsm?=
 =?us-ascii?Q?9wHmtI7OGvyE87K+ipi6+fAUXqWlZvxck9b57nYZqnPeCFPedy4ImnIClW3K?=
 =?us-ascii?Q?wPK+2OVizheA+RkN3divPCiTP/J86MFUkAY/CDCSrEPsMLrAAUXKJMHVNdd5?=
 =?us-ascii?Q?OgHHUklZ+Nf+lCanrcMm2h0knee3YFLfXI0VEyAyWmxYMH0AMTWhc8PxNIRa?=
 =?us-ascii?Q?rc+r9/iJcm6uNDkS3PmWBq0aZ3xNABEQp/0oCMIqbVNMcnpunh8ozJ7B/fJ/?=
 =?us-ascii?Q?eJmHOFaFS1NgaLFj7hvd0/khvkmp2zTXmXiI57zCOdIzQi3jTTybUCrHwc+F?=
 =?us-ascii?Q?nnUF7CaWaZERTrRZZE2J4hiEh86IRxaKjczpON56HUcmf80S26YPG0FMEHOZ?=
 =?us-ascii?Q?xGO5Lb4gegaoCnbTMmYvEI3cwuUJTaNFgb1Gcu7l0DG0oBgtwwMs2ujNTx8/?=
 =?us-ascii?Q?VYkPonewVXLHSySMN3e7qenDRXyeDP6fDqdYqiTdWxQ+jz/dkAuVyhzDI2Wv?=
 =?us-ascii?Q?bV09i+I2YS3y8PNkv9yrE7PWZsJZLBeWV1Q4siB0kLFz+FC9dbTTALCIGjnz?=
 =?us-ascii?Q?TeNfqRENSxKij6Ed7a3CDabLlymR59zim2xVUJ9IY2VaDLHrZNHFt4DZyFy7?=
 =?us-ascii?Q?oBvotY/gpdAt99qHuku17+mO2SIk8F/w5z/d8lTz6qU6LG5uD1XWFNNVxFSl?=
 =?us-ascii?Q?GS5z/nRCvSgGc9ArGTmk6QDxkh/Efnyrc29wYQuTVxvonAF6GRI45BETlEOp?=
 =?us-ascii?Q?YFGC5PTuyF1Q/h1hVKMPmR+7GkkbgKplQFr9SHkhglyc3W/RaBCUJPqlrJuF?=
 =?us-ascii?Q?x1iqOWgtY5dzPQq2y4AojeBEoYeCfKks+S1Dz4JTtH4erVxpadSnxR1blrna?=
 =?us-ascii?Q?PH0kjmjsiIqsHSe+VsO9TXuy7fbgGOSPeR4Pnq7Va/fwU/apkp0MeTkMB5cV?=
 =?us-ascii?Q?ALT3cZQLU23+xvx/6HRPgSx7CEQbLdKR24YCZC9lxYDbZBDXU+LjPEPAdjTt?=
 =?us-ascii?Q?IbVC553piJ3AwrQwj53SLTqiGtt4TVSo6YZzFMMDzDQqMtoaRU2qOQU41nrq?=
 =?us-ascii?Q?7sXr1SfOMqnQ0PK52TXuXEssuFoRGNj8I2wVNQzu8ic2gho0IaFBpw28wPgS?=
 =?us-ascii?Q?Wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZCrxmcFL/lF14AABMsNW40FEffb17X5H37AxOYGgxxUSl+/F0Z4tsjnumx2LpuSjs4IKgK3icNjlOIzoEeBjb9BVls4t6LFjk6nfLEc7KM0Qy22ChsiZDObxUfXlx3yXAwobpEdTLGbIqKssiyJUVRbuB5ZdG1lLYR1k8kZQbszQzHnb+N1rBhBrwUq8inv8K1g+4uHybA2um5HCZ+593CymGusnTzrR9uoBCEO+tv7t2buIYVXuZWyYu48Lw2UiqMZ/U7vzJXL4iAaZouaS7A3/TXbKOdXfAhYqOiVwSpE5Icgrp4adGGcZc5Ptf5jQTuyJuUJYZaATjlbb47IdlJ7nAeZ+ZEIzq5nKoeCLXFVz38qsDZd9oRkyaZof+zEhLrMiBoGMT5xY1Zr1W3hS6vzEGBvq8LA1LVjzZSKrJSXsxRiHIU7T7VppqX2HBNfcotBBCBjC0klebzfGunGjiXfcLMxyFKh90US1DUv4EY9Lhmr1MJk98ElO8vazfv0DNFM3JDFNXT33LbgdNZdU8ZYrAD/vSPffJ8eezF5zaTBJhwTi7/7vJaJbAU2/yjJnpKBKqTjCvHh917fjmrz7UNRyP5jxrRnJ7+H5AyrNI4A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df170f9d-551d-4d20-090d-08ddacd03fdc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 12:20:58.2223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L0nnW+w98kmrlMRyEmdwjx/w9prXN+PqZArmOwgJT4wCp1Lzgvey2N+uTF67AJYSUQDfWZLeCC6zwaUEfx4cMGKWqPBkNDh8bcGEsxvje+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8709
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-16_05,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=594 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506160077
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDA3NyBTYWx0ZWRfXyaDRkT7hAAjl U74Pn5k4tbYS9n+vQY27i7pSttx065OvmKiAYhss2FiV9t+aVIp+Lz3yzJCwSOM5FY9AD3vkWdC IWNrAlF3pbdNpoUYYArGGa/JGQ+H5xBK9OFXGUTDtwwE0jCf0JFrb7XaBwGQOoKBDe+pg6wipaq
 N6IgMi43DOUvxRyrXVyQ5RRl4TtaNRCMYV8L8jI0I0Tqbu9ihflNP/WsOAEvlu8r/6CTut80n1A NlOYHUDIpfL6vnLi8uwbiXu7pEsUS3aIoOe10dl9adB5NfIaVvzIfuZJEQAwTumquQjbkg0vc0G p5rTMZusSVjTCeV1JDaRqwCHBIOAcCPUHbR7nzPcPSO8+4gkk4ecJRUBa5UOmrV93XAdlRIl011
 ykp8+4QRjCZkIDKaGCTIRRLv/zvSqAFd79dnZoeH7KE/tzOGU5+BD/RIPLdSuas+oDGlSSqg
X-Authority-Analysis: v=2.4 cv=K5EiHzWI c=1 sm=1 tr=0 ts=68500c2f b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=hSkdONpc0T1EGQFSDxoA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13207
X-Proofpoint-GUID: RilTZpa8IUDqgJsWNPj4LvP7nM57o3Yl
X-Proofpoint-ORIG-GUID: RilTZpa8IUDqgJsWNPj4LvP7nM57o3Yl

On Mon, Jun 16, 2025 at 09:14:28AM -0300, Jason Gunthorpe wrote:
> Also, probably 'aligned' is not the right name. This new function
> should be called by VMA owners that know they have pgoff aligned high
> order folios/pfns inside their mapping. The 'align' argument is the
> max order of their pgoff aligned folio/pfns.
>
> The purpose of the function is to adjust the resulting area to
> optimize for the high order folios that are present while following
> the uAPI rules for mmap.
>
> Maybe call it something like _order and document it like the above?

Right, if it were made clear this is explicitly related to higher order
folios that would go a long way to making the generalisation more
acceptable.

But we definitely need to have it not filter errors if it's generic.

>
>
> > I also am not okay to export it for no reason.
>
> The next patches are the reason.

Regardless exporting it like this raises the bar for quality here.

