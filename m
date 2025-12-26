Return-Path: <kvm+bounces-66701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F92FCDE599
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 06:27:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ACDA7300D426
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 05:27:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD8825DB1C;
	Fri, 26 Dec 2025 05:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ipznSdiy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F996487BE;
	Fri, 26 Dec 2025 05:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766726865; cv=fail; b=FR8EKCPGDnLwuRyxnRlj3wvFrWszNk4xwyu7ArresNXpV7HtQJl82k0vZN7QZ6L9U3ilVJzXU1gzPYlt8OZuaNE39UMbzRHEhHvgV46OVnT1+SlykZwHTovepQVQ8Gmk+GQ3RF8pQSwVQV7988jLJBtcHogPCMdyaUMX/AscoBk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766726865; c=relaxed/simple;
	bh=WDL9pndbItuaTrZzcZ20Xcnmb88qNuXA0sJvDJkCmQ8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Lj9Xz4YpO85bJXYKxQGBnjZX3Bkld1Mu5HNAtlbEGVMjuEIGIaGe/YNR1BILjwQLrMITyiWCBkxKoTXm8ng2X/7StyiovvLwLWh2m9/DDCmM51knHWbTDWDDuiB7dVmtIfPxwuDPNqCHmwszdQF+6buS+GMjGfIL83xhal9HN1k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ipznSdiy; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766726863; x=1798262863;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WDL9pndbItuaTrZzcZ20Xcnmb88qNuXA0sJvDJkCmQ8=;
  b=ipznSdiyjRUsw02NHxbfgKrViJrG1BapC90QmDUOX5mPdwvrp+0vsttJ
   6LR6wTAPg19TtN2EFfehATMZiYW+aav17kcuihMt5C92zxatCH/HnngYb
   y7veqs8DbRzT/9Ypbf2rMpVqBtKu/UNLdMqLzbVxhQwLw9qtQ5YnbH6E2
   JYs/e89c2z5BEKVjCzQ8ldSNeeuD3HM7G48Yd8gVReiJPylt/Gb4CZ84i
   xr4n3Z6iuHcioz1Fbro8tSdvrEbe8Tn9KxQXqeHRvWOtIqsqUfzDjKZpx
   iWQWAAYZTEWne0BwX2pBRGUacfdrj9n1qLfu6JxT1K3W2R3PjZyaU9ivq
   A==;
X-CSE-ConnectionGUID: sU/FZr4nQl69QdDjnI0efQ==
X-CSE-MsgGUID: YmT5wr30SuarSyhITrqC+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11652"; a="79218092"
X-IronPort-AV: E=Sophos;i="6.21,177,1763452800"; 
   d="scan'208";a="79218092"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 21:27:43 -0800
X-CSE-ConnectionGUID: C7BEZPK7Tg2mv3J+RbrxbQ==
X-CSE-MsgGUID: 4GmS+CSRRXGiOddGrCIn8w==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 21:27:43 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 25 Dec 2025 21:27:42 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 25 Dec 2025 21:27:42 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.9) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 25 Dec 2025 21:27:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L5vZBU73TO6eksi6a+Fd6OM8bJrZiHLODo6Se6/Gg2t1gmwSMeILzxWImQ0gmoUDxY6r52TLWra/2RSfacwd7dbjfxwGS/0P00QC2ePB3XWfhFIhpthNzP5sq4NCDC3CIWRUIVXQi6bKFTjjlw/6WAEXyluHxBO3ZbjGHWIG/IP3YWSrak56MGhyQTyCMrI0rN9s3jc7LmwThfbQti0WqJtSJ9HHWxJOmh1P/XTLZ8I4fe0eb6Chcfj2P/UsleTLPsLBWlvBE37AGZg2vvdGNlUbcvxuNem5J5wS3CcPpE0kmtCXSea+35gTv/Lsy1GlDxgilQ12TP24yd66f4s2Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9UiGqV2k3hexbn6LkPiFapnjy5ZDquQ4Z9Qz5JAWiCQ=;
 b=EAUD4cD5LBbOqpwR60nOd6Ueqgg07YisnvgWe1YsrPWyo3vZckdXedvNExE8bSRAi1d0DJj7kVnH8yRSWnC3+JZkYoE39ylGRevWK36J18QzWUzlE0Q7SiQ0/ktd6l3fDOvQoGiNBizGqXWT+P4RSeQovaCJcRX70ue3mVMymnD54aEM/7GLtEgNdx+yzGfVrrJBuco6j8jmxfmkk45HAOuztainqFPM9mOwWK+Td78e5aE7Sqi17neprg41CP86UUxazDeY58foss51oapO0SOs0KAi/pmfGQAKxFnzxUIcJla1bgdNEwowyr1cbsxEtnlFo5JNPfF+++/F3XLgVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MN6PR11MB8244.namprd11.prod.outlook.com (2603:10b6:208:470::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Fri, 26 Dec
 2025 05:27:40 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9456.008; Fri, 26 Dec 2025
 05:27:40 +0000
Date: Fri, 26 Dec 2025 13:27:31 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/16] KVM: VMX: Support extended register index in exit
 handling
Message-ID: <aU4cw+l+R+ukJZi7@intel.com>
References: <20251221040742.29749-1-chang.seok.bae@intel.com>
 <20251221040742.29749-9-chang.seok.bae@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251221040742.29749-9-chang.seok.bae@intel.com>
X-ClientProxiedBy: SG2PR03CA0109.apcprd03.prod.outlook.com
 (2603:1096:4:91::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MN6PR11MB8244:EE_
X-MS-Office365-Filtering-Correlation-Id: fcb9b1e0-5d38-4a88-566b-08de443f7c72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?KgKLlHAVslvikx1165LJ5oNE5VoDw+0AfAdH+3hTiYOuWtwoZ4iHA98u0oVN?=
 =?us-ascii?Q?Dbj1mYE7rzrc30zqU4eqbapDGgUdOBV2wvylChVqM6D2DyqFQidWfd66bvh3?=
 =?us-ascii?Q?OiEhRP3YtEkhLihCJdyt1x2JfIT69ORmYIVnQ/R7M8UoBp3iKZ30gepCEWvM?=
 =?us-ascii?Q?wioGk54uTO11erSdG0m8uzsn+0wjm91LbXqqQntgQLgAfz2CyzuS/i+g2saf?=
 =?us-ascii?Q?S/9yF4txL9sZtKn5k0KNp4vaFasofI+6+Q/Z4670gXe74wZ9IoXBu58ql2GW?=
 =?us-ascii?Q?+IwErDWdoj1xpJndPmS8ByXgzX/QdshIviu0KWQKfzypdYISEzAIaZ9ACz/g?=
 =?us-ascii?Q?NlzmWYJgMVhNGfvfMJpQohvyFJHIDW1XCLH1HSphVIZAWwqW+Y26AMtAssYH?=
 =?us-ascii?Q?x7rN39/XLGgamsKgEnTl+BtHdAM1r3UMxWqBqEPc0PMYezFx6YUW5WomH/2O?=
 =?us-ascii?Q?KeBN3kDlOMXRRMIL64dJyUerirfnms/Y3npp2U4Lwt6KbhV1pBRW4gE9Hu23?=
 =?us-ascii?Q?OOMTn8H+sZbDftFOX4ExvAeiB+SfstFdu5FjSC7KKb7vS7eRIKjY8vgrjFaD?=
 =?us-ascii?Q?eCPjGU5lxfinGdk/lTpGBqL3nV6zugrvlt46wXNWpai372evuL+ITkEfKpmz?=
 =?us-ascii?Q?qFePdit2eCndK4b0XmgyBHNyRjJom63iE5WYUOUl4p5L4orwTWWbxNear2Hd?=
 =?us-ascii?Q?B52uECc02cvFn8Mb4YgdX3udV0vCiVrI4XZ5NnPO20JCcCeF332EQRLRZlxJ?=
 =?us-ascii?Q?CX11GQ9AMWBZg39QYrptD9qcbOjN3wOUXL90KqDMPA7pv/Gply0FQysG0Av8?=
 =?us-ascii?Q?JCvawjXKwBTLeSG59+LV8CxqU+ZK6/jRe329gWoWTGVxM4/oZoPi8oQQlhao?=
 =?us-ascii?Q?f46+F3HpBIHkhJwuFb0aYNegc4gc7qjbYWd34rhYyr7t+rJ57JsFc/Wf5ZTn?=
 =?us-ascii?Q?tVDFbgkjOxYmRuGSiw3JE+7zfAf9A2xBSmh7tLFslFQ29sd9mIcoGH78P8e2?=
 =?us-ascii?Q?yMhPr4uxpbc8VEbdtM6yLkVXFXY2hp51nrMsnadfXaF7MqPIr/rSZgHRXlWN?=
 =?us-ascii?Q?UPzJYh27roM4KKdjFE5JWdyrpbu3r/hzvPqJdMYqQqcspIRjblKPNlI7WXEg?=
 =?us-ascii?Q?yZANKkh++hWig1/+mm0lGjI2iAWk+UOkUrpH/k10892kCy3FAhMRdjtNY8F5?=
 =?us-ascii?Q?p/DX/wHu42kUt+7Gz5lOr92PDpEBmP/dxAZD8dkPNp7Plu+T8EfkT5/IudLW?=
 =?us-ascii?Q?bhwaqIC8KY4VhGGT6wDVcEJFExpswcTNp0BTMB8du3S1V7HfKjA89TSpnwjZ?=
 =?us-ascii?Q?+y4FQ+R5URm18CwJZnKCJ2m1AjKofzaSl9wtC4lvvCvcXPSZj1klRxPk7MkD?=
 =?us-ascii?Q?bzfVaWXlRb4Fz+WkjhjXPLT416c5P9pCVE2wD0ka0MtWyrwdwxpAP65dYATl?=
 =?us-ascii?Q?k/F461pdcOMY/QkXhi/ujXJNkAHhTR5A1hLaoyHEtvKjSR+8R5PXAw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1RySfyz5EjjeQxm2DY9+q4TG0j/Gr3M+uss/4CR49Okx93leFI9XO4e/QdTj?=
 =?us-ascii?Q?FAD7p+TRWWTSNYBkafWX0aEhIjc3ycmnDMM4PHcvwfv5AqRoPqogrGSNZLJw?=
 =?us-ascii?Q?CN2ufgBxWRdejsLm3T0HeQCy69gODMVvNe7IFHoHDfxjQFi/JLtOI0cLOu+R?=
 =?us-ascii?Q?+fOox02UtyUbHwV4NO4obthvTEzYAtGJ841UoLIWeXYXvfas15PC8X35RFMW?=
 =?us-ascii?Q?MR8gVGcNsRMuFF1oFN6YxcVJge9bRPXE1yjE5mCkbvNyQ+qpm0UgvpTgUoQX?=
 =?us-ascii?Q?gCZatJ9MlMbjUcQEhK9tzuwhA+s8w8aYeAXSV2iT5D2/+fRyngaGplm64iI6?=
 =?us-ascii?Q?nHrBMWcLG51mEbKJeH34onOBtMdAwmwfN0DLsGTzYPdvIokbMNS44DmYNfsA?=
 =?us-ascii?Q?NmC0tfpnIIlKOhVNPimER8En3b6xhQ1o2F+fy1ShrZTFnoRwcyhZzTxEMXNH?=
 =?us-ascii?Q?XUL+giBUcm9U86rFcsk/8G2X3SStaDEi5y9k3P1xim4YF6a00Ux11W/JULjG?=
 =?us-ascii?Q?Vn8HEJWbfaIFP7Y8MvtY7INL5mq7CGlp2wv2BiG6Pkb9pLrgspU1yKqAzxYk?=
 =?us-ascii?Q?zIXPcgWPaudBSl8ChE/hCO3sypl1U1pWP03GN/TFJkegU4qFH7VbrzgdWWA5?=
 =?us-ascii?Q?j1fRxHnEbeoZw8zHHqMlVfC8SOZ7W2ofYQV3vZdFUDVvojVu4/+RPbfMS+EH?=
 =?us-ascii?Q?R9gDTjKaAaqnote/BxTaxkYCbzMJNfXWOOk1k2OmUzGgQzhtU6+CnGregjXu?=
 =?us-ascii?Q?9ovBW418cEM2x13G9CWsv4yzWWv+8T879r1wKAKMXTASvl7qI6lFvWaR11ne?=
 =?us-ascii?Q?Wv+gibdrBUPCxWJzp50HJHPmdq6yU+udoJP7tbqrHay5PVn0IRQawTFTgU98?=
 =?us-ascii?Q?Rq4aXTwWExgyjXYb4fm2BQ5QGBIo+FsyW72mBj1Mu3Vh0qXMYK5RLKR50/vz?=
 =?us-ascii?Q?lh6ZWikA+vWrKu2GYleAOZm3v0lRqzA7AlyO89g++sdYYOnZhw8whJSqrs50?=
 =?us-ascii?Q?9ZMae4/NI8jExQnDltsEkEsnMZmZ1aPFQeIFy5pcqJq+RHfirt9/6CCgBvWM?=
 =?us-ascii?Q?nsFonHeQRxPWJfX2zsqyg5mNhBwGc7a/Q6z9f2rGAyNw40ZZPJLpnMNNd3T+?=
 =?us-ascii?Q?TcPvs3sGIXtovf2bGRCR3+1Tq2DsgKHErXfkY30NZWaCcr2uq+aHoYlho7ID?=
 =?us-ascii?Q?z4spjzC4MF+7hkxQq9a5ikWkcuqm8o1P/vWn14kS4AN05AJxKYPupehJbSBU?=
 =?us-ascii?Q?UJtt3gvVV24X1fEai715391/PKMOu4QKTNj+L2D0ZV+p2Y4BYJUyWMC6klNc?=
 =?us-ascii?Q?aGw8khOQl//jhq6zclpQHDyCzfG3p4uNsab0ByA74PkPoMUAbFT+l5rk3zXP?=
 =?us-ascii?Q?5RSWkiUwK3gs/R4PJbqwfuUBZqS2B0XtxPzIkPRYPLhZE0NbWPEfjFqa7rxO?=
 =?us-ascii?Q?nn3e/LngGe9QBOzhtzaRjgqNXv5UXYrJZybt9vYRUXhXZ2jZr4upP/yuc162?=
 =?us-ascii?Q?zdcb50jsfEXKv1yx9nrKqjuVSUFAR1w3m754Gn9TFVT4CQJLcstZcuYTgoJj?=
 =?us-ascii?Q?A5/inTyvZwO7WkSZpVPPjbfyEfo7hoZo5rn0K9s2Ree1x7jLgy0WpHud1eJB?=
 =?us-ascii?Q?oO8avrPOFNvRYfTEfUUyOnMz4k7vqBSDW7mt8iUS0mmxmWrLo0uvs76Vs2he?=
 =?us-ascii?Q?U24zhaOOiHSp264Hx1DA1atZHHkRNndEKnYZ5NqkzDJiDOSKOyuKB1XZ2jXy?=
 =?us-ascii?Q?7SDayvWAhQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb9b1e0-5d38-4a88-566b-08de443f7c72
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Dec 2025 05:27:39.8796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uYvLwMqZmHZB8SQHqNcey1tDegPGpMfSAwRhJ57uNgG2fSAFcfGEtBfusq5G0SFAojI/jYXl04cfLKLJF3ArFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8244
X-OriginatorOrg: intel.com

On Sun, Dec 21, 2025 at 04:07:34AM +0000, Chang S. Bae wrote:
>Support 5-bit register indices in VMCS fields when APX feature is
>enumerated.
>
>The presence of the extended instruction information field is indicated
>by APX enumeration, regardless of the XCR0.APX bit setting.
>
>With APX enumerated, the previously reserved bit in the exit qualification
>can be referenced safely now. However, there is no guarantee that older
>implementations always zeroed this bit.
>
>Link: https://lore.kernel.org/7bb14722-c036-4835-8ed9-046b4e67909e@redhat.com
>Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
>Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
>---
>Changes since last version:
>* Switch the condition for using the extended instruction information
>  from checking XCR0 to relying on APX enumeration (Paolo).
>* Rewrite the changelog to clarify this behavior.
>---
> arch/x86/kvm/vmx/vmx.h | 25 +++++++++++++++++++++----
> 1 file changed, 21 insertions(+), 4 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>index f8dbad161717..937f862f060d 100644
>--- a/arch/x86/kvm/vmx/vmx.h
>+++ b/arch/x86/kvm/vmx/vmx.h
>@@ -372,12 +372,26 @@ struct vmx_insn_info {
> 	union insn_info info;
> };
> 
>-static inline struct vmx_insn_info vmx_get_insn_info(struct kvm_vcpu *vcpu __maybe_unused)

...

>+/*
>+ * The APX enumeration guarantees the presence of the extended fields.
>+ * The host CPUID bit alone is sufficient to rely on it.
>+ */
>+static inline bool vmx_insn_info_extended(void)
>+{
>+	return static_cpu_has(X86_FEATURE_APX);
>+}
>+
>+static inline struct vmx_insn_info vmx_get_insn_info(struct kvm_vcpu *vcpu)

@vcpu isn't used in the function body, so it should probably be dropped.

> {
> 	struct vmx_insn_info insn;
> 
>-	insn.extended  = false;
>-	insn.info.word = vmcs_read32(VMX_INSTRUCTION_INFO);
>+	if (vmx_insn_info_extended()) {
>+		insn.extended   = true;
>+		insn.info.dword = vmcs_read64(EXTENDED_INSTRUCTION_INFO);
>+	} else {
>+		insn.extended  = false;
>+		insn.info.word = vmcs_read32(VMX_INSTRUCTION_INFO);
>+	}
> 
> 	return insn;
> }

