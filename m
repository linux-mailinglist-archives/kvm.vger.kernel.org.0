Return-Path: <kvm+bounces-50269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52BC0AE34C3
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 07:32:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E9853AF313
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 05:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6FFF1C5F2C;
	Mon, 23 Jun 2025 05:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O2222Iey"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF36A94A
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750656757; cv=fail; b=D8nVbmYTj6STeXThmEI1NVuutLtx18HuVGL1qBuUvlG5duvdEgIxzcmWEAYaCFRx34UglO0k6c+Mlxe7rVb2BDrARirHQpYxiFxoC99SDWqvIQbSf8DngWRinVQ6Qjqq5w097StKQnqDrmlZaRi3F4o0IURcLrv9Pbe64p6uEhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750656757; c=relaxed/simple;
	bh=ECDak7Ov5ewHHPwAgBV/HE7Rk1UFFGe0GdptaOvcNto=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UJpg8IPicUi16po60x0/RYvksVKmYtrBENwQymqUuTSDw46TZjXi+hr4IuHVBjawlBsBEgie4RT1AatTvw/B2dWXWoniBgK9wVbpwM123VzPHyeY+1OvcFgaJSieU80hGBkKLSJ9YPxWkfE607V+AWEPrbQwSEPuE2cYRtqXlCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O2222Iey; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750656756; x=1782192756;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ECDak7Ov5ewHHPwAgBV/HE7Rk1UFFGe0GdptaOvcNto=;
  b=O2222Iey3SHB/zr4ngjq3iAUOlyoZ2YCok4ka1rxd0LEPuLxl300LgOD
   NibShETHGp6kz4bynKRkyofaJ4b13mlzDd+ola7nrk0NlKvDHJJfVNswj
   w1vZWTV5aRnzE/83Veqx6gvNcgYXQBOVzv+OII62hVuZqTCqYQ+U7az6u
   dxJ0aOlxicuZhDqc2ynP4caOLMCHMk7CQqyBgForp2r0GgqGrYN2nMlCY
   eXIiuEbPzSpXoKIGqq2dn31hlJrqL9Ia+Mt7Dy8IAUTf3kHZSEo9HwLsq
   f8OGow0MsdQV3jiOf5VWY/VaFZgZfL9GOO4j2nn4b652KmmU9XH3aExrX
   Q==;
X-CSE-ConnectionGUID: hQHuf5P7QmaGlYJjL1BWoQ==
X-CSE-MsgGUID: kFJBLQ1OR5CNA/OFC3kAIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11472"; a="40456321"
X-IronPort-AV: E=Sophos;i="6.16,258,1744095600"; 
   d="scan'208";a="40456321"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2025 22:32:35 -0700
X-CSE-ConnectionGUID: hZEBZqmJRg6d+9mlkbCISw==
X-CSE-MsgGUID: V6L1ipTnS46IZqRv8j3jzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,258,1744095600"; 
   d="scan'208";a="188718517"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2025 22:32:31 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 22 Jun 2025 22:32:30 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 22 Jun 2025 22:32:30 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.85)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 22 Jun 2025 22:32:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fsQinKpynUWmswKVU3CjvGbedtHXSzSHuRH9OLf7DrPu1CabMoZtNC9spStl/533uuVQorLMPCBzt3FBapIaGIXDYf09PdoLU/YBRx9bZf4lhA6Xc6qECOf+tQQF+sGp/QlFZP2NkDZMGyKC/Vopk2dfshbbdxz+8yPa2MOXWq2qmEfOYYvLpRoY0eqfwe7U351a5SHZLG3xufIP2J8LhMyl3U6wTXi8ch1Sp84zWiYwfW5Oh8oEbIycksOQM2c6ncXU4yniSzGkrHMTmVDODQtIkVmTuJnQxK2+FE8sxEraHzca5Upq15UP8raTDNYbBQTer7s54xDmPeM/Fmw16w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FyMo45//WeDkexRePJNHlnvOSMCo1x34UssnD+XRafI=;
 b=xvbcPcSUOvWw7dpLOLHxyrsFlnzC1chr1RGyAxK/JMlZSArgU8eIClhMUaTDT7ESHc2uJ7IOlK8QTlDyGpv8HejtX4jPiPcTxFGI12+oHPxFJ2PjjLwzQHWptJuE4XzHs9IjCPtDN+GNm+tr4zIbiFP1vFRBp86KWfRf01FJZH5vfy1EtHULUJukLbmnXcnbLVcFxv8vzgdfOsUKMcOwoUOwlHy1LjTE8ja0fN3r0MW4iGDD10CXsKKFQDk0fQ9hLx7uAiNmY/qvSFaYQmCugknBZzEiGBQn+RRed3DH3RbW7vu5mWZVQ3Z25krrTRpignHYf8XN6keNG2XNzSQtmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY8PR11MB7396.namprd11.prod.outlook.com (2603:10b6:930:87::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Mon, 23 Jun
 2025 05:32:14 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8835.025; Mon, 23 Jun 2025
 05:32:09 +0000
Date: Mon, 23 Jun 2025 13:32:01 +0800
From: Chao Gao <chao.gao@intel.com>
To: Mathias Krause <minipli@grsecurity.net>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 6/8] x86/cet: Simplify IBT test
Message-ID: <aFjm0WsQHj2ELpMd@intel.com>
References: <20250620153912.214600-1-minipli@grsecurity.net>
 <20250620153912.214600-7-minipli@grsecurity.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250620153912.214600-7-minipli@grsecurity.net>
X-ClientProxiedBy: SG2PR02CA0024.apcprd02.prod.outlook.com
 (2603:1096:3:17::36) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY8PR11MB7396:EE_
X-MS-Office365-Filtering-Correlation-Id: b3541c05-590c-4fea-b883-08ddb2174c46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Uak0pmOcN8Ys/40d1H38tKTOYA+MB3rPFmJSA7pcwITh3xI/2vhc8aXEr+fQ?=
 =?us-ascii?Q?5Zs1n2KHPuXzVPVZ4ripXPEY3Atq/uQCkjbPZtxQlzhpxVw4YqN6fzTHwU0D?=
 =?us-ascii?Q?iWqVLFBx7btkZa/wVeo/pulVe83vJkGkdKz01zkXN2cBGHKExxSrY54vFqFc?=
 =?us-ascii?Q?Uv27WRdndrHBen2SwfJP5BbwpAcY6qzc803pwWs3TP5klYi2w79oMS3tZ4r9?=
 =?us-ascii?Q?AQiZxGGqMwn6tlkKQBMeJLjyQebBAqaEIeqBJYWDrAJqlzjvU6+dyKDVBhdx?=
 =?us-ascii?Q?rSRy7mD1eEAyYkkdB3FVYqNSOf3jPjwU8rwdXLVbOddK+0vkMJsNnRNNmIUf?=
 =?us-ascii?Q?dm0dvg7gdSLAqwx5ftLz4kVVbEErev5ro/R8IY0XBxkrNO330637q3xXR5JT?=
 =?us-ascii?Q?LerdNb4eBF0q+V6PaXTUR37vVdGNgdnNqtyiNgbRr/l1oROZ5+vJMseczUKP?=
 =?us-ascii?Q?nchHo/Ckb8lByhnREW5A03PBY4hn9SztQM4W4NzvpGaj8FDFqdCtJNhkXmuD?=
 =?us-ascii?Q?ToUV4clV08MGyGYHLQVEjul55rRDm6zocHsVs9PNHMd29T9s+stFaTML5jZ5?=
 =?us-ascii?Q?fMm2MloGNFdayO+jy5zZsF/My+SfpJwZbNfjbNb8OBnv6WAthjaWCMVe0bfa?=
 =?us-ascii?Q?+EbC7l7iqqxCVWKdqHI/m2o5f8rBicd/C4o8rmd1t7/6TDxExN+I2lp2HWnV?=
 =?us-ascii?Q?lru5ezIlsfMkWcMGdxx9pavwV01lYk9ByTaAHrCsO2yQJ/VUKImXc5XMJq+5?=
 =?us-ascii?Q?qpUk9WtcnKzUNlSPc2JacerFvKCtmZehENKcEjeVJc5TUww0xMVwHXYNVodg?=
 =?us-ascii?Q?2pyHGl0lcjDu35LVWCMzelKkE94eqMXDdJ+N8gSXA4CV848ik6QgMIBTL6ZD?=
 =?us-ascii?Q?nV5q4dkB714w9SzbK1DXfodEWYAm7+3ooZXoqVR7wD+nER+y+H7C2B4mUDbA?=
 =?us-ascii?Q?aHR+RVVDApHGQMBeZ8e2ze6whhRKKXyR3KlZO4nhTbWsI0REjC0P/2amav8p?=
 =?us-ascii?Q?+XDkVQ/EBkGdwiH5CJ+pHyYDrysmffe9NoBmbEN60nKlqSYWjHv6z/ycvv4f?=
 =?us-ascii?Q?aOZegv9okQbu0Rgm8OFJly46xZenSX98CPDA0M3mx1F0wMzRmFjoJDPkXmQD?=
 =?us-ascii?Q?wgW/VA/2cqYGwaEvD/kypX2SAKq3sccmgcNIasNrwJs66xZ6y24EiOiScty9?=
 =?us-ascii?Q?8iA7Y5c+7zVBPp3k0PVsqF364k0mGD+VhiogE+Yyf94ELYdt7a4DJ4AZoyhe?=
 =?us-ascii?Q?6yrXt6t4/xthshAbeSO3JCRoXYdiv35Ne2hqeofmOkBmPn00jxYlZ/4sYFGK?=
 =?us-ascii?Q?4F0kzww56y2FMY1T8Ui+yqEkqgxRv1TOokU8w/B6ZcI+BKRjBGfqDGIOab1k?=
 =?us-ascii?Q?z+DLo1Tqtyiw7u6thee9LgdAtd7EJHfSr86FZ0+atxZE//8uFmrrnFUQi1J5?=
 =?us-ascii?Q?UO0kziXS7cg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P6ThzAamfPH535Xmxl41dpD4/TsoJcA5fRa5pmNhdGnB32Xq2e8LqodR8wsA?=
 =?us-ascii?Q?t6pD5QpS/YJWRdZ8FFjuQICj8SHrABK/PqcwFUXxcFs3SU33XQ74nCmvqCbZ?=
 =?us-ascii?Q?YFZtVlRoqXsAN/UycqjNiXA8fjr7EqZhKv7vaDf0/4bxPKwLj4eSrScODsZ/?=
 =?us-ascii?Q?cwWQ/zM5WZdYgE87ijERMD7niQnqJ5OKGRJVFQCuxVfDomYWQVVy8gTUD7uz?=
 =?us-ascii?Q?O9P3QF+i6Mzf+oaNV2zZG18KsZ6IFvXrDxYjzUUfvv+DeVU0imSRYNYbnaVy?=
 =?us-ascii?Q?qDzip9R+tPhBRwfGu1cxOYJpSEdi5iwCZXekrbHmQ3mVC9ruzi8rKDT0te/8?=
 =?us-ascii?Q?FibiUvZIE2vchKVO6WqoM9tsZFAbghu2grDC3NrtueZarXXqp6WTwFHeZNeI?=
 =?us-ascii?Q?WLRHPruYCIM5EtPh8ZSguc+gpp+1cFIEZgwuUIMgxvtDHErz/uEVegF4xlnQ?=
 =?us-ascii?Q?P5j9K67Hsdvhg+nKGDkwZaGXY4FoWuukg0zRfGhcmeUvNcKU2ErlwQwL7A4q?=
 =?us-ascii?Q?qvuxJLii+r+uTH9KcanOM3fNDs3T934gK57NkHaIp736RzTFo/3ZvpKOMxx5?=
 =?us-ascii?Q?OgxsAAzqWNbBDrEvARTcS3TGXzJfTSL4FFU3UEPq7Ze/cdoQDomXlZBFbhPZ?=
 =?us-ascii?Q?u3MC145OT2hASTevExRIlIOnWZ5NtXKRKCiACHjvIeEWjrNP+NQjtR5crqVr?=
 =?us-ascii?Q?MQuWRu7OKw2rqjuM0LP3sSnbeBgUlUYjZUC16oM+Siz4p42IXSAjaYYMNpq+?=
 =?us-ascii?Q?OInJScVruS5fWvpg2tg9etSHeAbIQLGiHkaz1v++GRaKy+IYDptQI2JObDkR?=
 =?us-ascii?Q?elOKzod2KXYBjKjTTPwrpBQFX07m4iEWQdhlJukK9iP69XWtggg9YwbQnbMO?=
 =?us-ascii?Q?CoTIAdK+eTgRuG24766KYTEoxaMkyjZdLiM6V4Yw5zGKs0JaOgopD9NrslwM?=
 =?us-ascii?Q?PyjVGoxjViQJpz1lzWdr6HdeWhlxBN2VCSphQyAtBFqLpcxbI4RAesqh/Ly0?=
 =?us-ascii?Q?jGTf9Id+4siTCOokSm4pluK92UOJeWaJ9f9DVImgJIf4KVPP4mSWIPHDaR+D?=
 =?us-ascii?Q?aRlt/20N/3MhqqHO6Bnw+tnpmRlLjEGH3/4sF64PVtqRW32suf1TaXBSxc/J?=
 =?us-ascii?Q?kBzyRRQyfE2QQkDfOsf0YzJEXLZybphzssumvmur9EMFbeeifI6sjA8hwdYD?=
 =?us-ascii?Q?sm3DmxB0ykHJFoBirPEQiEMe1WH8pSZZmsK5xJiwDoN+2IJBzuwgO+SUqmOK?=
 =?us-ascii?Q?eTnSqQ/iV+Y5wB8sjg6RTEjR8bK7Fy0Zi9rC7FYfxlTKyzN7Dx3LsHOaoI+x?=
 =?us-ascii?Q?RIz51i704vlIkoPdxPgBEvMFz5ekI75pIbD6zqRUh1u8DZoAL2R6G7QZkkZb?=
 =?us-ascii?Q?lFNr4P2l41eUThoiufCwbUNtX/bU8OILBDNX1dLDULfpdv7iDrgL9quijZGb?=
 =?us-ascii?Q?mVr2EvQTO4mwFuykdZ2HBniAa03oaTWzLI78hDkYBEpwuYZ0dE5FaKhwJUGg?=
 =?us-ascii?Q?ybim++HdLi73RmVMOR61Or5TMFoObuUwlcy9ZVOGo5MgtyUNCv/Yo6j7UaQe?=
 =?us-ascii?Q?yCPjWaDzgnMg1sZxvKCl4gGYyotpoxe8iROevvRh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b3541c05-590c-4fea-b883-08ddb2174c46
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2025 05:32:09.2355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WlqA+1wMGbG/jrZOvf5JGmjqyjgULx302t2ACAqAkFggRYdKjsPqHyZe+HKiU9LDh7dS9HxlIWdrsCqp1ZRYFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7396
X-OriginatorOrg: intel.com

On Fri, Jun 20, 2025 at 05:39:10PM +0200, Mathias Krause wrote:
>The inline assembly of cet_ibt_func() does unnecessary things and
>doesn't mention the clobbered registers.
>
>Fix that by reducing the code to what's needed (an indirect jump to a
>target lacking the ENDBR instruction) and passing and output register
>variable for it.
>
>Signed-off-by: Mathias Krause <minipli@grsecurity.net>
>---
> x86/cet.c | 11 +++++------
> 1 file changed, 5 insertions(+), 6 deletions(-)
>
>diff --git a/x86/cet.c b/x86/cet.c
>index fbfcf7d1ab23..b41443c1e67d 100644
>--- a/x86/cet.c
>+++ b/x86/cet.c
>@@ -36,18 +36,17 @@ static uint64_t cet_shstk_func(void)
> 
> static uint64_t cet_ibt_func(void)
> {
>+	unsigned long tmp;
> 	/*
> 	 * In below assembly code, the first instruction at label 2 is not
> 	 * endbr64, it'll trigger #CP with error code 0x3, and the execution
> 	 * is terminated when HW detects the violation.
> 	 */
> 	printf("No endbr64 instruction at jmp target, this triggers #CP...\n");
>-	asm volatile ("movq $2, %rcx\n"
>-		      "dec %rcx\n"
>-		      "leaq 2f(%rip), %rax\n"
>-		      "jmp *%rax \n"
>-		      "2:\n"
>-		      "dec %rcx\n");
>+	asm volatile ("leaq 2f(%%rip), %0\n\t"
>+		      "jmpq *%0\n\t"
>+		      "2:"
>+		      : "=r"(tmp));

@tmp isn't needed. We can still use "rax" and list it as clobbered. 

> 	return 0;
> }
> 
>-- 
>2.47.2
>

