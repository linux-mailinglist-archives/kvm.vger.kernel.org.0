Return-Path: <kvm+bounces-47335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C30FAC01A5
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 03:06:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76A451BA30E2
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 01:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A655854640;
	Thu, 22 May 2025 01:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aB3KcuBS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804DE33F7;
	Thu, 22 May 2025 01:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747875992; cv=fail; b=XeEmKjEXKabqDpiGNVF2A5HihI/pguKW8shYQUikjq32vZBIAS7ZJ+PCrcOsxhZ2f8JMRm7ZdpEhMQPubJa5x8xDL9kKGUVriqkOuMkaAjZ+wLG5kOQ1F/b7gOj0HzLe8x3AIzsVvQLlvDVAAkLV7PeW0dkY41l7sG5wj1pUWfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747875992; c=relaxed/simple;
	bh=vSrA1NCs+uFu1JDMcGMnrqcHXhYRdtMYYtkXqTPXyTU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=d9xmzxAGB14ZXmbIFm+CRFeZt+HX/TeQODv/ykiefIPMlfLmwWtY5iP8+PFmHjdLmH52Cma61nADiC/sJyQD4S9RNINV+mGF3+FsXtscTVOmpSw8n1S4DuK9xIKYno3vZXKgOS50RpGpZxajfbXTftjNa9Lo8LFse+Xq4zuv4j0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aB3KcuBS; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747875990; x=1779411990;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=vSrA1NCs+uFu1JDMcGMnrqcHXhYRdtMYYtkXqTPXyTU=;
  b=aB3KcuBSAn50IAwGVrO2adn80hz4MAmcO5OsJLDUvq0AYPmTXQ2BIX8/
   mLelgGbTKCAbSO1+d0QwGtNxpV/RNKViCtOOTVzsGVH0ST+UBjw22kCPo
   BoQ9x0roR9DHtfVkWTpzDG9Fk9fUOAxWLCZIPOMVcSqP7LDpfalLxSaAG
   jCaI8EQgR4g868Y/ltsCo1/G7ikdnT7G80Aa+hHkRLAN79sJGXnZ+Ggoe
   ZzMQPJ8Bz4oPcU/dGNWcA8Oeytqzao/XU9wyjLnQFCXC7AryKIB6AXQY0
   FMapLEu22PVR8JNjtr4rfDSXnEoP6HQZY1Rb1zZWlgd/p+B88ODeNkQFf
   w==;
X-CSE-ConnectionGUID: ED1DxwqQSoCVPSIyyqAW5g==
X-CSE-MsgGUID: UhPbubfKSrS+NcVEvw/wNw==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="49586642"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="49586642"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 18:06:26 -0700
X-CSE-ConnectionGUID: xhuda1jCRx+31BbPOPBe8g==
X-CSE-MsgGUID: SE2ZJDVvTcG4FBoztr+KEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="140236937"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 18:06:25 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 May 2025 18:06:24 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 21 May 2025 18:06:24 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 21 May 2025 18:06:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EUnZXz/HfmMZG9YcZDh1E9Gi8bUv7nRqiosLznU0t8R18D11Sg8heETl9wy5BITHD2NMytlnUV+G2z8YTJjw4zm9GtdU9Q/YUMKXwgy09AMrzD5CsomFAY55JIuj+rGUB+LMOcUK5t3ayiolwmt8nTcD5phXRZadTo0CKAga0HQnnXSP3A2l5T24WCm2JXou+HQ8gsT3cQI7lbN/KtC9kOGdmkg5ycvtTEJOfyCVJJR1qjOsAnkOl30jc2z7W60YvWCgtpXiqEg2411+0kBf9eaS1Fj0tCujrbRy04/rFwvOoVBckVcTVH+aNuXFIxgeU9wlqphLH15uPSGoChXx8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AzqHJ6EbKyJd4p2Bv8J8kJtljr9+hFNdZYkGvkophUo=;
 b=xt47a+G+8kpvWv6u6BritjT/St3Bb99iYqssd8QRMlappXazI/5mGzMKamvCtRMzw0rl/WERjXMrRa68lkJBu84EMorjgyll4paTvTtyy4Hk1mrEwIobFw9VYAA3kIidSabsde6lTNKKhvyFCJJVpPaltgrWHqoWah77coYXXoYwnb4K8yx/Wug4Vzc1hqmRqNeI8cYHP1UfhPNw+ALEyPv26HUBCgVLHP87BuTMe0fPoOfntnS4LYUKFoLzYJTLB5ZMQuvZlfjubTtpg/3nW3WB6CJGjn3M7UxxDd6UJ3s+1fmxcBqhTLzMBqVumqjomryF0xmBxQCYsUCWWzZCWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6822.namprd11.prod.outlook.com (2603:10b6:806:29f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.32; Thu, 22 May 2025 01:06:14 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Thu, 22 May 2025
 01:06:14 +0000
Date: Thu, 22 May 2025 09:04:05 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Peter Xu <peterx@redhat.com>, Maxim Levitsky
	<mlevitsk@redhat.com>, Binbin Wu <binbin.wu@linux.intel.com>, James Houghton
	<jthoughton@google.com>, Pankaj Gupta <pankaj.gupta@amd.com>
Subject: Re: [PATCH v3 5/6] KVM: Use mask of harvested dirty ring entries to
 coalesce dirty ring resets
Message-ID: <aC54BWeyfyUh4BZS@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250516213540.2546077-1-seanjc@google.com>
 <20250516213540.2546077-6-seanjc@google.com>
 <aC2Z1X0tcJiAMWSV@yzhao56-desk.sh.intel.com>
 <aC3pNVfgNcnuJXUG@google.com>
 <aC4taDzB45fUNQJr@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aC4taDzB45fUNQJr@google.com>
X-ClientProxiedBy: SG2PR04CA0216.apcprd04.prod.outlook.com
 (2603:1096:4:187::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6822:EE_
X-MS-Office365-Filtering-Correlation-Id: c89c8777-76e6-404a-efbe-08dd98ccd925
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?+9mTcJJtdCOUV3aR0Kli3DRpQiZD704u4/NqW6Hrk2l1H5Q7/4tNEoEbLjOw?=
 =?us-ascii?Q?/9zmdo9vUrlQZQ1FvTkMepzMt8rBzxvPz0Jw5hss+M+XaNBqAuchSTWP0KwG?=
 =?us-ascii?Q?qB5QtLOUG/tOef9e+LnjR/glydFKMKx2dJJrWgO1xlFUl0hhFlFEhkH/cchh?=
 =?us-ascii?Q?m78b2jLmCX3na0XsAjzWu/nMum3VNVJESQy3Lm2utQrf9YHQuTHrmvEFj5Qr?=
 =?us-ascii?Q?SG/Tz650d0kEh1IVTZRgfjfBgHPL9FCse+29l+nJpWGN7b+O1KEgSfkUwu9w?=
 =?us-ascii?Q?ikx9twFVuDw/HufoSDDWetOgkBN97FcRCgX/xBorCBezD8/Hrm8r0oM18Vzo?=
 =?us-ascii?Q?8Gi4ftl9xBhTHTBnZEjslGwAaqVNFS+5oWvN+nPbO8BtY2qmFS9nlodWqCif?=
 =?us-ascii?Q?GP0GnfGi/jP0rN9GQ5FbOw4HtWaSsAbS4pRux8Liz5Us+L4XLBzrOdtHlLVF?=
 =?us-ascii?Q?VGOSbHG0lDluEs2YT5m9ClAUkqNOO91AcGHbdYms1VLhiEvZwJ5bRoTU4pb2?=
 =?us-ascii?Q?nbjDjZZx+1zX8q4hN6FsyPxVxhgGAyxrL5t6OwZWp06sICGGngz6HgLi9dkl?=
 =?us-ascii?Q?FeeddF9Ql9E3mrkvLkjSN5Jh9v9Cyr1idq/rtuq3SrJN76QiegrOuMRE9xTx?=
 =?us-ascii?Q?1jiqGMvvnalSHO1FytJE4H8v/v7amJe4BGNWbmSbU3+ZKEyMMmXoXftJyJiv?=
 =?us-ascii?Q?Ujdplme9cssA31037Dw5DKCbEDwb/VkagfJBorpGMgLcf3KeQtJhvjg1bIBT?=
 =?us-ascii?Q?t7MmeN4n/oCKK736LUhCV6pME3pKu1SW8odiKkFnZUyGWa+EimXOZnBR7PKt?=
 =?us-ascii?Q?liO1fAzjgANxTywtLbDv1jQuqnHQWaP3J+vROhvWX9DsrPCpOndoRY9cgcKb?=
 =?us-ascii?Q?0IUsZTrh1eV4be+TMkBXqTr3gOnFnaGREgFR2oh5ffhVjkjSbODvYmAKMnH+?=
 =?us-ascii?Q?TQCk98ObMj1wm70o+HLGhJd+qDDS97H4ffEGSeRxTwJ2+R16OBuL0UaGAbT1?=
 =?us-ascii?Q?CvG0AzDSkgcY05Np7jmnP1PY8mRcSJ1pJf+DKZqcQkEraOZVL8xXOnevzt4E?=
 =?us-ascii?Q?2HWyOi5dmKkTF1JpSKx4s/t0nLFQlCiC+Hicrz4dLvh1il3jVICJInJhrCN+?=
 =?us-ascii?Q?MYjE34P+NeEhZuMsPCXLNH70snAHVllKI4M0AWJIu9Zb+JOkVvoFbNUQvYQq?=
 =?us-ascii?Q?19ZKmJD+Mf69NHCs8YQKFnKaVV1+hhQ2Omcce6KIc/QOq5i1EFagFEWx0as0?=
 =?us-ascii?Q?GbvjVCwNizx5JRMpVr67LEd/YIwLPhGWdqBvkGteeGmI4rrb/JjKP5YUGJqF?=
 =?us-ascii?Q?ABMm92CBuMt8rFx9pbvpgmTKiTpo12fZbPCnBEMrXoOpcQTgTvMoOlePTPnt?=
 =?us-ascii?Q?JJBCqqiE05Y//yK3FuEXNYTnne6ajmjQx3h0Fr++Ktg8cqpZ3zVMIkywXRx2?=
 =?us-ascii?Q?9iA8sVAjRso=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hp8L3r2xlxRMfEmoXIs/1n0M+qRw79NrItnrAPxmGhNrj0uzxOpFO4E7coCq?=
 =?us-ascii?Q?bZvRkO054eG8VpruMPXZjWdvHNVNFxiAfwRUG3sJbWei0uKL6eM4gX44WxPq?=
 =?us-ascii?Q?+qib5mjV7NsAw0fRWgdxkzRcm1YHhyfL3WhPIGYHDx2T1Exq0XkmPf3UkvM3?=
 =?us-ascii?Q?zygpBJzs8gw4FpF7OOg4fLwP/rl1VvlfI3MmRUstr1+cn7ycgpnUMzHR3AX7?=
 =?us-ascii?Q?5NtmV4yxJ2TE9g4Hxl/uTCJS5ujiia/0OTpfzD0xfuRs4Dvzk8j9LvQGOdDs?=
 =?us-ascii?Q?/gnFxXjJRi+UJDMri8v2VEygwCsbMNb4ihQqxGoG+88cGu1FsnyMYKQEpNe1?=
 =?us-ascii?Q?YW9LiURKdeGck8EhkXz1iQlbCfCbsqW80e6/cu56Pj2605LT8PNMableq1Ut?=
 =?us-ascii?Q?hgAzjMXRQaVQrjjjRc+dV+xJlcvPabJu2ix6H0BkoEJ66vJGDzLarWP/KPs6?=
 =?us-ascii?Q?BOmE7//TU0M6QbfjHELF3fd/O9mR8wRzfV6KDcx1dQOgauirGt7vKWRy+Zk9?=
 =?us-ascii?Q?cTE1y+IcUmKKOUezrzeMNtIBkVInEL2Aa3MhkqTxzfta1JMvdEIrKsc22lZp?=
 =?us-ascii?Q?Hkx3zxesHxHgHJp4EEnSKaBE0Z626Ai8A42XhkblpB+gMaQmxyIdfC5qAY5X?=
 =?us-ascii?Q?lsfW/3XawCm/zyNXHX/49GNu0p2/3MYtZk5wbJFwh8gqRLBOeP/mvQU0T2Q4?=
 =?us-ascii?Q?NLo1zLp3vpEdZCP12nH2dpl2f9oDoHWzgdZEKctLXSnxVSXqtT9ji3iUP3ID?=
 =?us-ascii?Q?UwMIZLm45yA9JVG5ixyUSEY9pnRzdoCc6JHP7bl6UeagKb9XvGoejOGK1N8u?=
 =?us-ascii?Q?1cW8Mbl9NwpOYMCbWcGvhUTranR3Y3hXk8QSXOQwp2UAsF3TZnmXeT6/II4Y?=
 =?us-ascii?Q?Rj9ZadbdVFAd20kkdTvsc5alzRPQNqMQP0mduuUFCuoIGq2KJRYNSythmI5p?=
 =?us-ascii?Q?Vfd6Z8eVzxSClgavsNsBKzG9oTOXKuzeTGv5169Acnf4apDtCURI+xLsZAe4?=
 =?us-ascii?Q?GX9l4eCG86IJPp0ahWhe0sCnf//jWPhPDh+dn1Lky4MnXlPhC7Dq8+GZDA6s?=
 =?us-ascii?Q?+V9T1DMOhokZIHVyRMxMMddrL3ndhXu07/r9eoujpB7qLnaj5rBVYGQ7PMxp?=
 =?us-ascii?Q?ADIqrJ1W3bniGNHpm59F6w7Yk0M78f9Hu5VQ+bq806EuAPiMARVAtBKyqzHy?=
 =?us-ascii?Q?agKGTc+4hjcgh6BLAtJGFSwNonqVyMZAMfHsVLS4AVkR0eZnCTxb79B+OqTU?=
 =?us-ascii?Q?zkqYYzXvFqckCt1q7dTxnfv12VPk2JwAoAVX+vikZBq5JwCKr2GG5kQzTf6b?=
 =?us-ascii?Q?+wdX3D63ADXqcXZEsvDz1scE/x63uXbKjWIqDqxGfqA1tFr+EbypeRKgfOpa?=
 =?us-ascii?Q?Z8fphZ45cQ/oe/IgV+3uLgy66377UwQKdEwwzRXUitg/45BzaaktNR14xEn4?=
 =?us-ascii?Q?3HETMJv6FpRrlaNGCREwoS3oqb5iKmsJBh+0/0TfqzWQY6coxkkSqX1Airv0?=
 =?us-ascii?Q?aXUNLc2NDs5qIYvTufCuhfXj1A0vYBjPTDKsJ3h+cdk/tUALydkzrIRMrKA1?=
 =?us-ascii?Q?+XkiQucbSityTVNFTBmFSEpWVuMN0c1thUftEOwF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c89c8777-76e6-404a-efbe-08dd98ccd925
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2025 01:06:14.2614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lxwrhzRAiAnb64Or0pwleQ7bOlB8Wehi8O1i2KaiQdPHz65S4B26sMc457WRJ+uTbKGAj15rGfiApRmYxcZCQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6822
X-OriginatorOrg: intel.com

On Wed, May 21, 2025 at 12:45:44PM -0700, Sean Christopherson wrote:
> On Wed, May 21, 2025, Sean Christopherson wrote:
> > On Wed, May 21, 2025, Yan Zhao wrote:
> > > On Fri, May 16, 2025 at 02:35:39PM -0700, Sean Christopherson wrote:
> > > > @@ -141,42 +140,42 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> > > >  		ring->reset_index++;
> > > >  		(*nr_entries_reset)++;
> > > >  
> > > > -		/*
> > > > -		 * While the size of each ring is fixed, it's possible for the
> > > > -		 * ring to be constantly re-dirtied/harvested while the reset
> > > > -		 * is in-progress (the hard limit exists only to guard against
> > > > -		 * wrapping the count into negative space).
> > > > -		 */
> > > > -		if (!first_round)
> > > > +		if (mask) {
> > > > +			/*
> > > > +			 * While the size of each ring is fixed, it's possible
> > > > +			 * for the ring to be constantly re-dirtied/harvested
> > > > +			 * while the reset is in-progress (the hard limit exists
> > > > +			 * only to guard against the count becoming negative).
> > > > +			 */
> > > >  			cond_resched();
> > > >  
> > > > -		/*
> > > > -		 * Try to coalesce the reset operations when the guest is
> > > > -		 * scanning pages in the same slot.
> > > > -		 */
> > > > -		if (!first_round && next_slot == cur_slot) {
> > > > -			s64 delta = next_offset - cur_offset;
> > > > +			/*
> > > > +			 * Try to coalesce the reset operations when the guest
> > > > +			 * is scanning pages in the same slot.
> > > > +			 */
> > > > +			if (next_slot == cur_slot) {
> > > > +				s64 delta = next_offset - cur_offset;
> > > >  
> > > > -			if (delta >= 0 && delta < BITS_PER_LONG) {
> > > > -				mask |= 1ull << delta;
> > > > -				continue;
> > > > -			}
> > > > +				if (delta >= 0 && delta < BITS_PER_LONG) {
> > > > +					mask |= 1ull << delta;
> > > > +					continue;
> > > > +				}
> > > >  
> > > > -			/* Backwards visit, careful about overflows!  */
> > > > -			if (delta > -BITS_PER_LONG && delta < 0 &&
> > > > -			    (mask << -delta >> -delta) == mask) {
> > > > -				cur_offset = next_offset;
> > > > -				mask = (mask << -delta) | 1;
> > > > -				continue;
> > > > +				/* Backwards visit, careful about overflows! */
> > > > +				if (delta > -BITS_PER_LONG && delta < 0 &&
> > > > +				(mask << -delta >> -delta) == mask) {
> > > > +					cur_offset = next_offset;
> > > > +					mask = (mask << -delta) | 1;
> > > > +					continue;
> > > > +				}
> > > >  			}
> > > > -		}
> > > >  
> > > > -		/*
> > > > -		 * Reset the slot for all the harvested entries that have been
> > > > -		 * gathered, but not yet fully processed.
> > > > -		 */
> > > > -		if (mask)
> > > > +			/*
> > > > +			 * Reset the slot for all the harvested entries that
> > > > +			 * have been gathered, but not yet fully processed.
> > > > +			 */
> > > >  			kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> > > Nit and feel free to ignore it :)
> > > 
> > > Would it be better to move the "cond_resched()" to here, i.e., executing it for
> > > at most every 64 entries?
> > 
> > Hmm, yeah, I think that makes sense.  The time spent manipulating the ring and
> > mask+offset is quite trivial, so checking on every single entry is unnecessary.
> 
> Oh, no, scratch that.  Thankfully, past me explicitly documented this.  From
> patch 3:
> 
>   Note!  Take care to check for reschedule even in the "continue" paths,
>   as a pathological scenario (or malicious userspace) could dirty the same
>   gfn over and over, i.e. always hit the continue path.
>
> A batch isn't guaranteed to be flushed after processing 64 entries, it's only
> flushed when an entry more than N gfns away is encountered.
Oh, I overlooked the "pathological scenario". You are right!

