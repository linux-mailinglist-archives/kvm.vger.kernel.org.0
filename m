Return-Path: <kvm+bounces-46727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E27BAB90AB
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 22:17:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF77C502E05
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 20:17:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EFDE298CAB;
	Thu, 15 May 2025 20:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dwmT4VtK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="O6CQDRh+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A612E29B78F;
	Thu, 15 May 2025 20:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747340190; cv=fail; b=oFyy8hGbLRpcLuaXgUWaMzVhSvCx81r7Y6mh+MbG/Xwn649QolGH1cQDF23Pvb44wY2SH2HKtHGFFLddnxfbBSnDoZUgGpHU+YdEASnNb7lw7rq8iLLfohDTRMLjzFjueHUFNdS9di07sdH7hf3ZiBYNzwR1Kg3YeRpXqWohIWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747340190; c=relaxed/simple;
	bh=82Xn3OKcstpcCaQso1S6WuOkqY6trVgqOfseEUvWOk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Lcn3n+mOtlLiXOkC+McVgU325prza+pVjc9dBO161h/xmvmL2grgJHtT9yK87mvDHT72EJ+D/PyT0c9KgVfsa2iMggHMndeE3BPk2XSSDg8bi8B72EpIALpTJDx21hT1Q/qiaKwEx2o5u16xQNcYHSibn2RyYTGa1KwVRXrVYl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dwmT4VtK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=O6CQDRh+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54FJE1rD023112;
	Thu, 15 May 2025 20:15:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=E1teKaSZHqhhubctZrKJnEkLkbKVu7pu/k3ZLt693TE=; b=
	dwmT4VtKBFEauTvj0rLd3tgOHTxFQMtUB5L1WfAnW9b4X0/+KHS7CFVgl7bg6tic
	8+6HCwGlPealwszQPyttsj+uAX8coW7lodCZLfbFCG1+kHqet5+Anl1NrtANmBiZ
	FA6znNbEGOSX4Adaz9lSdePM5JL1QkfJne/TJuEa3KAGHOvwUlxXyRyr5/Lc3UEB
	IBTzrhpmXWW/0S2Se1+b8UHCGbRtqrEr5kmDfCvkIj4BSdKIsFBDEjACGBKVrys1
	rKbmnpSiieZdc8zEkmFPId/M5cC89q9IcDBMhGOpYUpp1beTm3/rvSb+jDo8C19d
	kbBEZGJzzTZsGohHDxq1dw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbccwbqa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 20:15:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54FJBSbp004463;
	Thu, 15 May 2025 20:15:57 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazlp17010007.outbound.protection.outlook.com [40.93.13.7])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mrmek50k-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 20:15:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ALKZg8uupnbgHTQs4Ou7zsiyku9wuBe8xk0i/aqM2VOog+D0rbN5um4kHzedBVLcAug9oFI0EhgXIEVhKNSPty7nSnH1jAYwhH5Y5O2ZdgJwhoMLrfXf85Uoih6WoBoc6gq3IhBI6dLPUzmOEa88vlrRc1a7LVUS0bqmt/ol7ZqVV/FqVx0dJ9fGl3R60/gGBZNjGLQSM68Cw979wmLbTIP7ljVCjqV0iXhYPkFh9dPMovU0Euzr/mPz0qRq+Y6Sn2SvJmu4ntSogzKX44s3C76lvldhRd3yJXe/dsJQAQCI9kNxqPrEDr7h6AfNKp2awPbGu9I4K5UaNW65l8NzSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E1teKaSZHqhhubctZrKJnEkLkbKVu7pu/k3ZLt693TE=;
 b=SMFBDwlysSlkhoEiBD5sr5tAav3kaqPFPW5P8BwRYml5NZgAUE8PR2566H+p4rP3moC+5rbVTdvhqcPVH53Z0mstKGHyS6Qhy7Y6ui3dxLIvHFK89/K0SLxuClaSvxPsPOe5nCd6j2No+UygRcBLfvzTC1EfldXNfpnmb/UoH+bGa79HCmA6rw6YrffOVoaVjIq8D995ggOL7MOd6gDExdaJA+yyaN2fqfM4UVPUrv0ReF2yLSjJ/QBgVDVJyZTVFuMAmmdNYokOLEPGuODnvgXezRLSuyvM7tthK6y/E0tCYqnBaPGhfLFpM8vUVvnViF4scd7Q/SMwSY4TblhcYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1teKaSZHqhhubctZrKJnEkLkbKVu7pu/k3ZLt693TE=;
 b=O6CQDRh+0kffFvCRi+Ifjb+jPpzGltebHzAr6hcPWeF+aibfSiH6zpfyYIHIIVXiUmtx+DzX9SUxBrM8uQ1TpAJTafXkmGwxaaZKOq3S33i74e21zSAWR/J9B9EeNL3s+95OLaASTi8cmaz0Ps//6+aoNUwoKxbELqtk89SGpHM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA0PR10MB7275.namprd10.prod.outlook.com (2603:10b6:208:3de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Thu, 15 May
 2025 20:15:55 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8699.022; Thu, 15 May 2025
 20:15:55 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Houghton <jthoughton@google.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
        Yang Shi <yang@os.amperecomputing.com>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
Date: Thu, 15 May 2025 21:15:45 +0100
Message-ID: <3cbd58e6fb573f9591b43abeec66e6e2f3682f7e.1747338438.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747338438.git.lorenzo.stoakes@oracle.com>
References: <cover.1747338438.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0094.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA0PR10MB7275:EE_
X-MS-Office365-Filtering-Correlation-Id: b9c5d336-90a3-4f4f-758d-08dd93ed4c39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ea+qbuMVmXvCA3DM3c+hSL+mYShZ7PIv8w/u83xXbc5z0ylm4DGg8sQr6rFo?=
 =?us-ascii?Q?huC3GIRLejh3768oFktb4wBXwsdc8wynVxlN+ASr6Ggy39golMfz0yN+czDN?=
 =?us-ascii?Q?L0uMO+I1giSIg/Y5/DB4f7h2UiD7AVP2bTygTZL6Vt544kVJMzcxCvi8BiIX?=
 =?us-ascii?Q?y6r5xgz2b6QC5xBFJm0cCOgWDr5i4wPJj4gFf1YJmv45haYpWwlZQ6zjJRZx?=
 =?us-ascii?Q?Ev/L21kkBXAj7NihOY9eG9tKbqSCMgDoK0o6+STru5Gt7LdRcRNEQLQLhFvV?=
 =?us-ascii?Q?k8f0BrYbZeA63mQ31uIwHGCuUnWotnNbgI2VcYP/edGEbSvv6SmrJy48i9zb?=
 =?us-ascii?Q?mKmZ+MCrd0cE8jN5UbdAWXmDTQUa8zvjKTERKC0zTBWd+ohYxqyybogm/M3v?=
 =?us-ascii?Q?nn/+s9SgTkEBP3P+XlACtx2oPz6KR6xdbTc9LvI1pXRrnNDyQXAnoOzXbnHg?=
 =?us-ascii?Q?4dTe1x/C7jkDviGuMVZxVN9WfUeHb7GM9h904AtXfrZlc0Rye3cVbg1d6mAu?=
 =?us-ascii?Q?sHIR/ZD/6plK1d/bR/GI2ruJ+0d3+OwbqX+0mje3IaAbxtc0Bq8HS6PfsJAG?=
 =?us-ascii?Q?b3g+yOLyN9Wkz4ij83MmfO2ug6GSeoeWBOL3Yee6tnDfuiu9RNUiro5mj2Nf?=
 =?us-ascii?Q?OZcUxgYpJXLIBQ6jPoQbZjk7MzTveYaXOpPqr/+g1+f10+GFJy/D1AdckjoM?=
 =?us-ascii?Q?DKgolzu2exM29GxtnSMESxAS0UxlDRNKiR6+1m9WEdz62DiFRa09VigMXoxk?=
 =?us-ascii?Q?oaPISv3jMzgInA1jEdaV+iuzokDrLxrQ29x3Ul2koiyldd178p9HiroXJVvz?=
 =?us-ascii?Q?Jh3Trwo/Cfe+XVmWqt10YYENs78vNVN9BmFPzHAhOjA7W8wmnSJIRnmE3l5e?=
 =?us-ascii?Q?Sl8LwAWuwNzgELGoiipL/oxS7DmRqysngpvE9f/h+MjcoPgaEyKY3pcdeBCA?=
 =?us-ascii?Q?S728tG1J/0y1Yc19TIIl3W7JG1NznAoRYcobwPtDbFXgWd2C9gTRVm0wzEek?=
 =?us-ascii?Q?kM1kY38gKyG4jDdewDqm+F/kIgfHvLRnovsXLRukl/1B6fyw811xDiAZmH+/?=
 =?us-ascii?Q?JS9QSjj/jEcsyyR+on61UDxhZyc6MhS6p/laCgyVfg82yKMJKiRmTvwp3u6v?=
 =?us-ascii?Q?5yU6d8VNG2xMqifbyCTQW4te7YaBbh/4/DxXPSZETnzldgY+qFgZ3ZrVlj6m?=
 =?us-ascii?Q?VWogUh0dFqbzZr+qfXPa+1lj3zt9GHOB2+FNZ+m421wt3MFi9bUIP1es4q3a?=
 =?us-ascii?Q?qadUO4VcB2kM8OScR9SrYvRZvxt15Fkg765AR8Mgs2QGVVFY8m5O1xKEkaV+?=
 =?us-ascii?Q?Z6fLeHyV5yLeIHaM2VcKJP8cNPPHJMt5JMJCaj8+CpyVGIrcpfcRIqHaTOxx?=
 =?us-ascii?Q?SVvoq998ZoT9bBYTXfMW/1+J61TLyxBNCtb7W2sDlP+HC3w3ys+NGRdtYeWJ?=
 =?us-ascii?Q?pYi4BDfk49c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fILLRM521lcKewmexwgH/WstXY3rtVdC9Ds4dihLk2Exou5i9LGQtMk8MHa3?=
 =?us-ascii?Q?vSPc8R+OOBQMAjilRbykcMtTpe7oRuNZysVsz1oScOdBi0nYSiy8PHmtcPAT?=
 =?us-ascii?Q?XDOX4AD3S7sAN9Q5fvGohgLXbMyilYQ1fNQEmOjU8jZPpqMKl9Jzyhq5STq/?=
 =?us-ascii?Q?nZhijGDbLIqKLmAKyj6S88S4Ogqv6njTvh6EZQzKuWTL80tava9TXrz5TNfL?=
 =?us-ascii?Q?o/XhdDaW+Q35tIJQqi9i0Jfs9HiZKttjz5ZP5dcjVN42nCNbKdXT/lrbrC+x?=
 =?us-ascii?Q?lVaWbBJlfBEpZ1aM+x7cb5DI3Q65itgMHhJuXpDBoeC27g9VHLhUoxpJpfOx?=
 =?us-ascii?Q?oPuykBbQSXziVOiIyrfjjXO0YnVA7Se7u8/bLcJOF8jSHAEPBYqGDHy2TAcS?=
 =?us-ascii?Q?wjePEtTbjAYqLwZ9OU8uyPERxrNBAJ3k2HQBVJPNPFfsNQLywYBukqdsdqw6?=
 =?us-ascii?Q?m8CV5+OsXZQ+A9N2+TFSSEieZp9ntKDIQSrBpWXVIzqeWEDSkyz9IfdXgEKE?=
 =?us-ascii?Q?XKoRmnrmy6NYDX0RLs0Siw54VWWLePanu+p2j+viRWQuJlrTMz4I1s4xsQ+E?=
 =?us-ascii?Q?/6Ss50zs/5ld9QB/f6b5EpvnTAY8CNg6WB2T6E8aHnL4UQeCBghPDYqhmkHw?=
 =?us-ascii?Q?/ZZbdzW822KH7yZIpjIOguA05DmbE/cnS27QltRueuoKSfsx3TwA+3t0ma2l?=
 =?us-ascii?Q?hgoV8XMM78NdQz0Znk5mL22jbD/qYkeCXtuuKux7NpQWzGrGjZ7NMR6Fe04P?=
 =?us-ascii?Q?py9aMqlLVWjBfc9orS7Z2ckhsc/QXDNcG4kSH4+F62wrcN8YlX1WVIEOKKda?=
 =?us-ascii?Q?nteHv+OylBr2NT9jV5DHuT4AdMK+pPDVH0RS3OwfEhg5XFQ4Ui6ofeAv7dGj?=
 =?us-ascii?Q?5Jfk5qtggLBNA0E9JLBVTLWh/dwXXLhkJ/CMf1I//6R/UtwjzB/HzmsddlaQ?=
 =?us-ascii?Q?yTCYXoi1mzakXEqyWnr1EuyQ0krox9Lwa+/8KWNpb8rBi/IYve/wWWJbg4DC?=
 =?us-ascii?Q?w1BkiUjz5otZt2IVHJWOZ/4jR2vK0OhIimbJMGPukpUvrDe51ToxQpf+yuC1?=
 =?us-ascii?Q?LhJSIqzYndOuzAqpzwXpYeYKUd25PXRuj/gh4okfAnq4vIjTLVn8vOIPbNih?=
 =?us-ascii?Q?6kiazIIxZ/8IhPhsMKG94QyO6akCL0K7/8M0G+Jd0ay8OVMLY+v5kXVRwMEW?=
 =?us-ascii?Q?Plzqn4Wr8xV3Syue24PRgEC8k9uzGi4mdM8hd9I2CLRF6KTpYszYqQDNoBCx?=
 =?us-ascii?Q?42jU4JK3sXImACNJFbVtQXTO/qjIBzVh+jS0zXY//VQfCZTXXKP0Ro7Uz3uI?=
 =?us-ascii?Q?4qxH28yXafuraz98Ax3AVeIW6RhPH4OmUGp9RvejZZVPASmG121PvM16RAI3?=
 =?us-ascii?Q?8FiAhySOyGomG86zbNv1065Y5x5N27UOYPdc29nJkCk7NlacegvPpG1TcoPp?=
 =?us-ascii?Q?qRZvMsBb4Cf6WHqr7nVa7VzgH9B8Y7XWO09exkFpV+L3wBbU6B0BIXjf0Qnc?=
 =?us-ascii?Q?BoP0ffhUFWUjEDES2fJIfmIn8N+kEZir6MEIGs9116pQObUMuImNLg3wVB52?=
 =?us-ascii?Q?W5T9uzWWYQbXKLHOGzp+zSSezWqd5ArehaB1pLP4k8CxPvXaTcI05T+O3KkC?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1YB0L5ZKHa3ZTxKJPGCCOsj8L+OyFOerS6PTtnoRcbmpo7oS6Gallx35Kcwo909OdaH98SKMr/JiQSgBfBNASe1rM2SFDBq9DDOK5v7fV8U4gk/dM4NQVk7TUgQdS7WSWUBYPX8MmoLE64RDGsHEADApzqInys0EDU39uwR+lqdMkuqa4ZzZSoOdA8X9IsvRNluTMPNhu6ejS7X6IDOk3+2lrf8pqyKawxAvWD7C2hcCiDMC5o6OedRuK2dGGCm+dHitqsOTbmRIIMkZ/17BxuA5iXRUPCKtRosi4OAwnZT+NlJkNpHpHqIkTBVijGZhTUgmQOAeHGt/VfcYtN1yAEaALb2AOswsJuhV7sbnedzQZMZ2qqouVAl+be6MUzJHLchIHEXDxmjW5b/DjpROV5c7fFheC4jzyBSOlkOn9vtXvnLgXwwLizk0NKOQtHpkqb+plZVhi9+E+SZ6bZGLX0BjwgSuC92ulKQFwSBsGY62LiYvdW7DFKeMMOatgCmmlESatoxvNaxo8OYCpIVfvn2S8tbsS6anXSz94RqrpW46qk0rpIftBCVU2Mfr2ZApJpZuJoeKDEqi9/Jqkb8sPqDEOw3Pyt/0zTLIE7Yefmw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9c5d336-90a3-4f4f-758d-08dd93ed4c39
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2025 20:15:55.2655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WyUyDbZ5ARKIIEdE7GdNnVUQaLGL0u0ZQUc28OQBu/+MOsDDKx2PkJWD6MrrdXMFFnhcfvNaQTp82XITe9CO63iC5P7NQvzv6TgiNkCgjqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7275
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_09,2025-05-15_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505150198
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDE5OCBTYWx0ZWRfX/F85emCUrZu7 N+C3IH9AbibM+yHKarJzKCg2dCVPaLB4WlB3Fu/fWFH0BEyEG3eOi1SCTs0TCn03b5Vgxakmavd /aj/fp8NzTqpPN2ko9s/lBtmhjW3SdZdfUnKubPDpq0o47Gy5Kj2jw8WfF6wnqibVxAjzNwKY2o
 yWJmeRrD9SOrw7tTzRWZMDWWvgCNKtiWmG7FvWyU4F1SoOkUP5iis5H4+lpNVZgnJQQzaDo3t0Z Tr29Iy03PgsvNUHJ71Qmpb/Eh5zfULd+xdKpZoe7AeY3oJ88ngt0Dxo87DZCkLXC5TIpxL3uJA+ H/uZGkoKY5Trpg0ArT/wNVv5VgeIG/ny3K9q6L38RN8kkwA7isustF4KA3ttrNboU5/WIzaCz+n
 +iuCljXxN30heVU63KZ/eioibBxcnlrYk8Pb9TGElVa+ud6dM3+GMS0Zi2ZbGeAzSMZ864Qn
X-Authority-Analysis: v=2.4 cv=Y+b4sgeN c=1 sm=1 tr=0 ts=68264b7e cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=TAZUD9gdAAAA:8 a=VnNF1IyMAAAA:8 a=vzhER2c_AAAA:8 a=20KFwNOVAAAA:8 a=e7gHu1jynlkptK2ULBEA:9 a=f1lSKsbWiCfrRWj5-Iac:22 a=0YTRHmU2iG2pZC6F1fw2:22
X-Proofpoint-GUID: -fk0vNYj7_g8Dlx4FHyFmTFpoKHi5WIB
X-Proofpoint-ORIG-GUID: -fk0vNYj7_g8Dlx4FHyFmTFpoKHi5WIB

The enum type prot_type declared in arch/s390/kvm/gaccess.c declares an
unfortunate identifier within it - PROT_NONE.

This clashes with the protection bit define from the uapi for mmap()
declared in include/uapi/asm-generic/mman-common.h, which is indeed what
those casually reading this code would assume this to refer to.

This means that any changes which subsequently alter headers in any way
which results in the uapi header being imported here will cause build
errors.

Resolve the issue by renaming PROT_NONE to PROT_TYPE_DUMMY.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Fixes: b3cefd6bf16e ("KVM: s390: Pass initialized arg even if unused")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505140943.IgHDa9s7-lkp@intel.com/
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Acked-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Acked-by: Yang Shi <yang@os.amperecomputing.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/kvm/gaccess.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index f6fded15633a..4e5654ad1604 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -318,7 +318,7 @@ enum prot_type {
 	PROT_TYPE_DAT  = 3,
 	PROT_TYPE_IEP  = 4,
 	/* Dummy value for passing an initialized value when code != PGM_PROTECTION */
-	PROT_NONE,
+	PROT_TYPE_DUMMY,
 };
 
 static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
@@ -334,7 +334,7 @@ static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva,
 	switch (code) {
 	case PGM_PROTECTION:
 		switch (prot) {
-		case PROT_NONE:
+		case PROT_TYPE_DUMMY:
 			/* We should never get here, acts like termination */
 			WARN_ON_ONCE(1);
 			break;
@@ -804,7 +804,7 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 			gpa = kvm_s390_real_to_abs(vcpu, ga);
 			if (!kvm_is_gpa_in_memslot(vcpu->kvm, gpa)) {
 				rc = PGM_ADDRESSING;
-				prot = PROT_NONE;
+				prot = PROT_TYPE_DUMMY;
 			}
 		}
 		if (rc)
@@ -962,7 +962,7 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 		if (rc == PGM_PROTECTION)
 			prot = PROT_TYPE_KEYC;
 		else
-			prot = PROT_NONE;
+			prot = PROT_TYPE_DUMMY;
 		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
 	}
 out_unlock:
-- 
2.49.0


