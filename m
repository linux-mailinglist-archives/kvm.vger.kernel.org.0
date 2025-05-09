Return-Path: <kvm+bounces-46057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DC43AB105E
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 12:19:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EA651889DEB
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 10:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EFEB28E615;
	Fri,  9 May 2025 10:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QoouHyLt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7BA227581;
	Fri,  9 May 2025 10:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746785918; cv=fail; b=lVFMciaAj1pt6TS1VCaYjbTm4q5AV23XYnSRBC6FbXeD0pduGvX8LsDEq/b2OaWkW7DbcR2VAaNLzaWtYP8RVQP/z2uwwxAH2HpXNJjQ8lkj9IjyL1XVRdRxuN+rJr0qag+CpCZkJ5EuCSsmd4XvXjuF0vtIy6ktb1pGSfQwWhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746785918; c=relaxed/simple;
	bh=CIULYLGZt0IQKnxK5gysCjSkRBM7cyXmeVuYdszgg+k=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kbPKk5PUMcpfA/4elP3HJeG2pTUabvsi+CwcUBnnRmsAXsocha9nJvDZzNkIeepCbesNFhZjoes3hge8lHalixr753EZpFRxyQN26ZlGYvGzcbYJLGX2f7Itw2dli+io813HlyB3nmXA7P0dmfqExheCYXBl3QtPFZ5RHk3SKKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QoouHyLt; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746785917; x=1778321917;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CIULYLGZt0IQKnxK5gysCjSkRBM7cyXmeVuYdszgg+k=;
  b=QoouHyLt//fMcSNdvUVOwd6xIGG4yCmfUVx3dE+RBBqnwC+UUKZMqhDB
   v1qbyD/UpQ+So0pBe27KR5CzSkNeXWwBmD4dy5G0IdXj11Rd11TpIqVst
   gAFkWnYwTFki7dQLiWcHBEv8NfJV3WTwkBLoS48bcg/yxZiFWLWtOJxEt
   npFi9Vjcp9/f4WJkPo4MpTJgIsTXy2Bli0FQolKGLvsfT/XmAuJ2Zi9mb
   41Br0+vU/2uakidX7ei0tl0UJTM3vcJuitJhXH9v0vyEBNt6mlk+qMBPG
   ym8h6vjNmLqhL8MdRGYmzrIh2mxiHmcymt/FRFhys9WFdg7lchmQlZvAW
   w==;
X-CSE-ConnectionGUID: /7HV79sSTQeRV05gOJu0cA==
X-CSE-MsgGUID: P1/q26/KQA6X/ldrmnA29g==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="47718698"
X-IronPort-AV: E=Sophos;i="6.15,275,1739865600"; 
   d="scan'208";a="47718698"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 03:18:36 -0700
X-CSE-ConnectionGUID: CQKEUNVITCO0l87uSUVcPQ==
X-CSE-MsgGUID: qKIKu2ZkS1WxDO2YwcHyyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,275,1739865600"; 
   d="scan'208";a="136966622"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 03:18:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 9 May 2025 03:18:35 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 9 May 2025 03:18:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 9 May 2025 03:18:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m0lvIfD+h5y79TDo2GKwQ1eBKS5cMYqV9C93079AD+4sdR3o6E6aRtrBnWjASxDhT8G0rfRsouDYdUvl4QSumvvePXooP2GeKzvxgg2U6tB2G6/lTKuBmSd5iIqu434+KwplQoV2WJoPyo0uJ7dU9S4Xa2p4duX4hYz+qL39t3esaSZVUs7wNuYjF0hljLvxjQ31U3A1E9kyd7bO059tVMF7t3RKjLGClDTlQppM2CQv6Io5qxuffXs3APrUa1Wqu6lbUkUk0WpbkqkhiPi0FbAXNPVfobYe2xKTLvDw1fVXFDeRqBiTqYEXSp7XgqybcT5gE6Jq6y6Tw8zORwUOEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CIULYLGZt0IQKnxK5gysCjSkRBM7cyXmeVuYdszgg+k=;
 b=EQE/CSuc4V3xppgyKu8XsTJ80DJCA+GJzAKIA7rGC75rrYwAPQ89PjdJMYDoKHxdFC/wLIXjUafJWPEn3c69INzKWXWYO+WpuhY4mIqNuaVBWXVLQ1dvYO4yE3xa5XIR7Yn7ANQARSUm4pC4/i3n/a1N+TemOKN6Z6LWM12z6SkzG9T3w/lSVr0xWDMkmbJUp5uviNT+a80N8E3TlP02LlzhTBOIhaF9v3TJdW5uDemNoWXyc8lbnY/8zq52bCRfMzOkQ1o39j3v1ac7OSrl2tuUAaBFcH25UV2PxX4hgWhKsOy0LKoPyJMcSU6HHgm11BuDYVhgPO9TS4q+9Q02lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MN2PR11MB4614.namprd11.prod.outlook.com (2603:10b6:208:268::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.24; Fri, 9 May
 2025 10:18:11 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8699.019; Fri, 9 May 2025
 10:18:11 +0000
Date: Fri, 9 May 2025 18:18:01 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <rick.p.edgecombe@intel.com>,
	<isaku.yamahata@intel.com>, <kai.huang@intel.com>, <yan.y.zhao@intel.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 03/12] x86/virt/tdx: Add wrappers for
 TDH.PHYMEM.PAMT.ADD/REMOVE
Message-ID: <aB3WWUSESKt9niJV@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-4-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250502130828.4071412-4-kirill.shutemov@linux.intel.com>
X-ClientProxiedBy: SI2PR01CA0020.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::6) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MN2PR11MB4614:EE_
X-MS-Office365-Filtering-Correlation-Id: bcb0d95a-d83c-43d6-9bdf-08dd8ee2cd4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1zR+6J0Po6X0W8ATeSbQj+5cJTOdNACPGfLGbUUb5aBdi0rNaCrEcnUMiBRA?=
 =?us-ascii?Q?tUz+4A5on1jON5Tl5TLkYc/3iqcLiYvgU1E57qxoWtECiN6pHrul9VhjW48j?=
 =?us-ascii?Q?lUJ28PW+OqRIdmfNvZAGld5GpkNnfJ5X9YkzUnv6bJiCWe2k2lVIxW3w0uWH?=
 =?us-ascii?Q?+dklK4ceCCJl5vLR+BX1oSP2F9JjwjVo+enl75lpTtGVY81uth5g4c9rA4TC?=
 =?us-ascii?Q?RmaRVv8v9j93YV2I/vvp/65RNyY/V1R5449Pb/kbyAxXjuh5YntfCooYI4zy?=
 =?us-ascii?Q?j7yEoTKmPp7MOBEW0IxEXJf9kA/51R0nkuMrOQHOXiTu+bIn76kC8hTzvRZk?=
 =?us-ascii?Q?UHVHW3FBx9w0ssqGT6E4KjW+U7cREQXbTYQk708P5vmyj4sskFG4O1lhCo2+?=
 =?us-ascii?Q?OKyuNaB4Mq3MaanRxF3GjFOK07vWgbquMjxd63Kf9iIDA4gmdJX8DPEdq44A?=
 =?us-ascii?Q?lelSYgyI2c3YX1M+7Y4AJaijKj7dgiYaliUlderB+FpD3lSn4VIuz5nmSU2C?=
 =?us-ascii?Q?0Ws7HKQ0kiIIxlQwwHSlVTjNX/wN43cTIYn9gt8HJ40mll8pIgEGWR84YVGD?=
 =?us-ascii?Q?2eI0yeT6B+nxmzAbN3HSdk2r0uEtq0HDKJd6dUsYBCbCMyeCqzDgH2QDFFSk?=
 =?us-ascii?Q?PhQMdWTKWMZ15ibaRWPTB+eG+1ZG/daZrHyEnAZE7grcRHb+xpsqox3sGhsu?=
 =?us-ascii?Q?lfQU2Xz1VtfD9m1QL+52ZtjAMvlysOOYkSFC9tmZwwmTvCyft68pQm2zpkgw?=
 =?us-ascii?Q?bsi5xli7+ZTINwpZnQygkFL/rKZdZWINfoeqDjnjg6RXhmrs7Wq2W1nnjo6C?=
 =?us-ascii?Q?T7ffJDEpZe7tTR8vXwn5J6jRBa1b0IdksAPn3TECORanbwzMtOleURRpT3VX?=
 =?us-ascii?Q?fihU0vx/yXVqsy/lTN51pMwrxhLeTfsyw8if8aiG/sKoMMxX10hCjHYn4KL8?=
 =?us-ascii?Q?DHnUofh1qGyKNzXtodPO2I7l+MxgoL/QSj3lHnX1Ee3st9jEPrYWOtfudSHF?=
 =?us-ascii?Q?WHrOSNfRs3HEdGdPfyzgI4x0i4h3geBy2mxdBizlrvTxAO2QVSKy+wgsmuN5?=
 =?us-ascii?Q?RiZwgFechJU7UQJxXt+KCE6x/TH4y2lDQhQnc+WlrtKpiaCAt24CyAJwzgPw?=
 =?us-ascii?Q?UnEeQEPjPIFfI4JcW9S5Zokfv58eQGmMfTIBWUGO2MSlxiuYeNyehxi1oV16?=
 =?us-ascii?Q?ozBNhymfTZtanIZFMc7k9JfCoe2HGlJSjM/8/SZYoJLk6hIoyNWuKbpNZ2L8?=
 =?us-ascii?Q?cfR3EoG9SuTMAMRsQ502MstOHxWHSO/gtQDx2ADu6Nj9qQ+ji6+H7xHdi/7s?=
 =?us-ascii?Q?/VBLdL3vEEE0romscbNIb7yrYda6GZerxDrXIID9ACEFSbtBGja21I3bweu3?=
 =?us-ascii?Q?QJrApPs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H38TyLaXfGrKShS+J9n4D93ly1Pu7wA+h10ke+ToGolW1xBiq05HTGjdLlee?=
 =?us-ascii?Q?nZHoML4CT6buF4UIA7BX1vgaJ5+NjnXJ5C91hApRXrkww8sxkY4rTn/V8Uqi?=
 =?us-ascii?Q?187T4qwxAruiRZKYsJwKC9qMaTJTU++Fuwv8axDgcLojjpJvL62H27B94VWN?=
 =?us-ascii?Q?TSTmPsFwNQZiUtmRmrCIAoEdRks9qaa1VGU+dJYm1Z+HAKBBBV+3e7fDzk0d?=
 =?us-ascii?Q?bLK7DciAqI3VpgEpsvC4vqI5ogA8fZmbBJD1Wmtff3GC9ZCN6D3O3qTvWT+I?=
 =?us-ascii?Q?oY4BlXzcueqdL3VTrNPKPt4LXKzxAAU/e5cAeiDqwYAmhDE/Q8o+3fru+awB?=
 =?us-ascii?Q?7XFjPLtmpzAqF3ukHUFns/YUPYfT3vprMFpd6lgMwwIIL3bbJtlHUpmnXMAG?=
 =?us-ascii?Q?55yk6UIO1H3hoPFtHNuxn6uGwjrtObbqmvAePzin/QgfPnHlxAP6y7bXnfzy?=
 =?us-ascii?Q?HbMrDIIxarjX02/HRgyf+FAvggEvvbVJibMon5HkpANppXm1KRSfvKoAjqOP?=
 =?us-ascii?Q?d/uiYm2ncJrxp7vHLtFWcpNL7dx++Jtdpm/8GOknfTO0D3K6dyEW3CnvnoAH?=
 =?us-ascii?Q?aiqSLTYV6+rY7YewGWRET9F0qjERbAlCc8o7KoSm91+H80wppaGXHgcdAqk3?=
 =?us-ascii?Q?fr7l6ujDPG0ekMF+oeJORu0R4pQ7xTCGPYIe811skVw9AIvlBOfYEBii2zFu?=
 =?us-ascii?Q?aQTM3jSwQCwQ57YZJWlcRsB13p2oD5zqr6HArhdS8lZnOd5AMG+ZNIkZM+t6?=
 =?us-ascii?Q?hd/G5LcusQrlPhAmjlSUAwi9S7leYzd2mS09FJnq0CZkoWeUGRTPmDBz5Gsx?=
 =?us-ascii?Q?TDEq2HGdrpq7DJNDuW1qL/TOObsTDeR/LX9i3ulFVgWd5GmXkJfzwK+xzwRs?=
 =?us-ascii?Q?9CCFPvX7MFdcrTqb42n1IcnG4YFrouRINLDOfiF5h+wmLO2W8Z+Y41YO1Yn2?=
 =?us-ascii?Q?gBn+o3BAU0g40sLrkfaXLc/7SGdsRF8kvuDLOll6ORsxhorASUkZOxPZOweh?=
 =?us-ascii?Q?xu8x0iiIskGIZ9oHf7qfWc81ugc/owCJdZUxgA0Dib3ZHnysWwtLNr4if/RG?=
 =?us-ascii?Q?Yy3V9Xv/x5qUtHHTCwRnvgw9rq5kY92cNZ7SmJ9/xT4EJmwbDLHbwXhpdYwL?=
 =?us-ascii?Q?hreyrRJ48Lp4+Kn8zpNJqmrr+n02qeF8aQr74891df8/Hg9wlbMwPPcmAWl1?=
 =?us-ascii?Q?BIyb/SrfDPEIN63b9pEwQ8h8Zo87nEEOY8V31G+exeowXGmsRlxOyK73Lhe1?=
 =?us-ascii?Q?zXZholDzJwTTKnB3V9zeJBBHB2riOIsgl3QcFNuSzNRChLebO/x+HykrNHB4?=
 =?us-ascii?Q?W3SYNw0ALETv6mXJwa8rn+WnZLVAmKcThTtvqs7PF+Cab2POMTOptThQaQ+x?=
 =?us-ascii?Q?eMWkxQ/VuFVnaW1bDZS4lx9pI69tv6DSzc59jgDC52vEjtjIbQvwgPRxIZ0S?=
 =?us-ascii?Q?4DuxMmlv3Zf8GEObzz0JDEvK0MmuEGIsPcR3DwkKNnebbSLgjPf7ZAORPKOJ?=
 =?us-ascii?Q?IOXo/cKHa0cGqO9Rb3iiXz2bJi8pi9r/aNzRnpwLL441sP9RZrIOkxef/K/N?=
 =?us-ascii?Q?1ceRgwdKXLpdHMcz+YjK8VVjh4tyd8Jl4TbJKng1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bcb0d95a-d83c-43d6-9bdf-08dd8ee2cd4c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2025 10:18:11.6133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dqxUZb2XQlBJZec8oYalodaVkIq3fxlzmmNITfJlcZABeG/f9Wv6yIcEM7MfZAEBR8AcXh4sdE1NNzsKT0ogmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4614
X-OriginatorOrg: intel.com

> int tdx_guest_keyid_alloc(void);
> u32 tdx_get_nr_guest_keyids(void);
> void tdx_guest_keyid_free(unsigned int keyid);
>@@ -197,6 +202,9 @@ u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *ext_err1, u6
> u64 tdh_phymem_cache_wb(bool resume);
> u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
> u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
>+u64 tdh_phymem_pamt_add(unsigned long hpa, struct list_head *pamt_pages);
>+u64 tdh_phymem_pamt_remove(unsigned long hpa, struct list_head *pamt_pages);

When these SEAMCALL wrappers were added, Dave requested that a struct page
be passed in instead of an HPA [*]. Does this apply to
tdh_phymem_pamt_add/remove()?

[*]: https://lore.kernel.org/kvm/30d0cef5-82d5-4325-b149-0e99833b8785@intel.com/

