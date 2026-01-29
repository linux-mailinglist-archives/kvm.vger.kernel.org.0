Return-Path: <kvm+bounces-69548-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mFGNFd1pe2lEEgIAu9opvQ
	(envelope-from <kvm+bounces-69548-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 15:08:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 254E7B0B72
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 15:08:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6DA25300D5D7
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 14:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0938B387569;
	Thu, 29 Jan 2026 14:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WORdHAfZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FB23803DE;
	Thu, 29 Jan 2026 14:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769695677; cv=fail; b=m5/9UxW2f+6qb+7LbxLmUXdKXc7xzANOg3E5i4y82DcZTcOMy9c3doZ0XhumSLgocgtqwICP6z8uSE3wv3SJV1ByKYyPllNfDC063UZnwWTV0BGg3KDdQgj9GLB8XjTLA9lytwQiZpzZk3nvmcjDYJgZmxV2QW8PdwPrFRMesIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769695677; c=relaxed/simple;
	bh=zzUVcp0dHnVTV/cQdxVTOS/1QbNVtkLMUdLqNkTQG4Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UxUYsbjhQfJ5F1HD71DKeRevqBlzaPLvWVEftG6+XZ4hd3uUSfTm1uA7zFaDDfMP6MJAzEsl9tZY9FLoDsClNBmZn+y9sovSJZAFs0xCyQ2jZyne78cJkCh26b0zoiE3RP8N38xijlM3BqfHmB4d3RFQecAgkFWhoRN7Oa70kr4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WORdHAfZ; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769695675; x=1801231675;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zzUVcp0dHnVTV/cQdxVTOS/1QbNVtkLMUdLqNkTQG4Y=;
  b=WORdHAfZtQH8nFfPm8cmVCkreBfZuAm6FIY8pJNiAohV0ZfPAR2rklvM
   EEe3ZZZxGyklRD4ZYAwfk20TFP5Sv0RogZ3d4cZyd/BrBjVzdIyQB7r5j
   g+jf0jI1yGDIGZ2lOhNuCf3zm4f6vPiTouZ4g3CqGQOGbg06k83BbrCUu
   UK05VqQtyjyP/pIjYjMEQzIDmZmYlSmBeZ7VTJUy1gllRDwstWVFYKotW
   TRPKU2liO6kt/iF1mZgnnC7kSBlDPtjXx6Jdgu44mGGL92Yc2q9wDOikB
   8iNSwYYHLts+am/b8Xh0JOo4/QNJiJ9UEOVoGXgdq7bB+IDEptes4JYoh
   Q==;
X-CSE-ConnectionGUID: SG4RoQ6zTwGJt7dcUk8Ukg==
X-CSE-MsgGUID: Z93EPScjQeKMEtaJyl2H8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="93594325"
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="93594325"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 06:07:55 -0800
X-CSE-ConnectionGUID: wd2pEnK9SpmHhfhchcRn2g==
X-CSE-MsgGUID: 6vXv1CGjSQ+b1LCzSVkXCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="207834293"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 06:07:55 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 06:07:54 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 29 Jan 2026 06:07:54 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.35) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 06:07:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RaBo0liRpDGhevTT90ZFHrm+0L52XbzUzcn/I3zXuHVdpRHEyyT5AwvdzsaJuib8kLyTVcfFay24F/dl02nqwvBlgzg/m22rMG9/n9dVkq4zW0njFuYXvGWCWEXjdXCfeJxk1RFk+DnWzXizJa1xyoIWRXtMyxfHL6ekCJmTOwBOSm03c58UB0Dat9uVl8+TIpzCezwJkDyHCCDDAwpHT0/2R3WnTFeUbQe+F2OxzC+lv2dXw95i0YHjXRfktlu1l2PGuRA6k1uniGSm95oNk4HSNWxFL4aBt8+5f+iCir0TVzDMSICOD1j2BoHq4DkCO5lOzm8PnboItUGbhYn8HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ijzF4nv806n9kazgw4lUwFeSszHwM8YG31HNS+BVyR4=;
 b=e6Iv03v56mScYjrMa6h4wxon8D64gqYpN6BLdSB0vsFL1f/6Mq7Brp1S0PUMMOrCz3Q9pkZNKJORwKQkWfEOSSOvP6Ea4rMe//VwJfVlw2XkF1bLx9aSJAvxoASphHh00RbCt1cmozb98gD2HKhS1q2zoaYjAca8YauwDPgKJXSh04AzSdFoFL0LnJNKAf1hP4BPz2/Fawj5Af2EiutAUiKzeGRx+R3BA9AkcRrZaS4BUMGkkPF8vHLVGKdEPA51evdoH5xQ8G83QOUOec2/CFAIy3Gkt2jEKJDkm8Q1eHM8sf7mwWmGMW9I2bCO8N30KrUbAi8/iMxWxs3lWKxEXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CO1PR11MB4916.namprd11.prod.outlook.com (2603:10b6:303:9c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 14:07:50 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9564.006; Thu, 29 Jan 2026
 14:07:50 +0000
Date: Thu, 29 Jan 2026 22:07:37 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <reinette.chatre@intel.com>,
	<ira.weiny@intel.com>, <kai.huang@intel.com>, <dan.j.williams@intel.com>,
	<yilun.xu@linux.intel.com>, <sagis@google.com>, <vannapurve@google.com>,
	<paulmck@kernel.org>, <nik.borisov@suse.com>, <zhenzhong.duan@intel.com>,
	<seanjc@google.com>, <rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>
Subject: Re: [PATCH v3 05/26] coco/tdx-host: Expose TDX Module version
Message-ID: <aXtpqefDbfW/HCWW@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-6-chao.gao@intel.com>
 <d82dd253-aeea-49c5-a21b-44864bd78f25@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d82dd253-aeea-49c5-a21b-44864bd78f25@intel.com>
X-ClientProxiedBy: KU1PR03CA0044.apcprd03.prod.outlook.com
 (2603:1096:802:19::32) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CO1PR11MB4916:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cddc065-0744-415f-d633-08de5f3fc949
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?J9cGHx50eFOp/fEfpSd+6L0J8DHH2o/TxersW3MSOUiDIJpkqgGVMJ4jdghU?=
 =?us-ascii?Q?LxTE4J7gIdAasix7pUMtwQkQcWvyeX4YfCSLypmdFqBoUU94xmzRYzzl7HZY?=
 =?us-ascii?Q?lGFQOUI+NROrrgG7TbWCNbpIer5p3jNiElge5OW5pYmfOzjm46Tyyq+ejbaR?=
 =?us-ascii?Q?02NEQPPFketiKJ/NAELpr5HWAKWEX3iV9zypjzUPa0vEhV0F3A1p3qCgmLHV?=
 =?us-ascii?Q?MWyg2je1iAe12c6WFBwJwYYoaPAYhQP2rC4PKqXtEbXUNz2LuWebPOCh9x+b?=
 =?us-ascii?Q?VTKSKG0jM0xg80PIM2AENJAdwTHXXTnSp6QcHm0TQ77P7Zu0OzKpDPpPXkgn?=
 =?us-ascii?Q?ef3ZWtwb272x8MTEogBx/S6+rLZKX2V93LGGGvADaB2hhu4CoBckcgAFA3/K?=
 =?us-ascii?Q?uf3PEg5ICJ67aLvBoUna8MoUeVBboEjpl7uOvl5tnOCUpfhPe54U6ZKldrQg?=
 =?us-ascii?Q?/gRAO+wNzjs4VFbdyQ7lMDonW2PxwFSoOMI17ORGFMPyKN0FyYFXU0TPwBXA?=
 =?us-ascii?Q?2Fj5j8FmkVly5jFDe4xLGoVQYG/BcF6/kkZx1dYD4M42Z00UNNnnLXoSaTbH?=
 =?us-ascii?Q?7IVHwPVbBb1QNXvT7tdtoh5fcqPHxtsdTwBHQRmmnfmJloPtrUZoPOA6lZYE?=
 =?us-ascii?Q?DLaLoriNfYiswTUwj/ldAmmz8v0XEnQiQsYkVxgXzfyDHpYnD2BroaTGkEAa?=
 =?us-ascii?Q?m6w7EuInjJrWh50FOGL0hDGpSGnVYVIRbnFhynf1pz5E8W/nHCWugFuSRBy0?=
 =?us-ascii?Q?DLIFWRmoQpb8TFWs1HfMk/BMBp3l0k83nl8+qQnHt86Xcgm8gzEpyAioHpee?=
 =?us-ascii?Q?4zHezacJGTns6B8SE1rVhC2jug+K4PI/3qKv0hYCORDSITlUHuUQoTBLwT7g?=
 =?us-ascii?Q?5FZfGwOW4TxS0z/gHnrb9wEdtWGkHW3odSLdSYOqbcEH77amf8Chf2ucSxoF?=
 =?us-ascii?Q?yR6oR+L9o0D2rS2nL2gPxNwGovoPQS5dhZ+G6B+sIL4t/trxepz03cSFIaxS?=
 =?us-ascii?Q?fD4Fof0mX+I32r0ttroKPJBdiku2Udi6BQJZC+7Whz4v/AliU8IlwTlEul3U?=
 =?us-ascii?Q?rQCrvYAoU47gzx6pYfYBV+NuOzavOjJeFEO2lLoO3PnGQbsU0knlZGbmYscU?=
 =?us-ascii?Q?Ii00hzM2o5+cUbM4rT/6uSaIuUFROtSpCawrdmC5RFFpzKiv4db++uLTeGy2?=
 =?us-ascii?Q?C2NsrMWWrONPOoKcFIScZekbApXzeMOJSt881wEDJffhK1msfta1tQDexc4V?=
 =?us-ascii?Q?4xdon8mnMsYyi2frm/8AAK41CpDm5ubKMsvQB4PRtob8VLaiEGJMxHauUrX7?=
 =?us-ascii?Q?5w6ha8/Tdd0RVYQ9ByZP4M36eBlLhAax7EE8dBf2Riaj/4UmfRkM6xc2uW2g?=
 =?us-ascii?Q?Z7C1IsZBfDnho8RqH2y2Q9gE6zudgp8QNgfRwWC8yMOwPRBi2Y8AAGMWhsub?=
 =?us-ascii?Q?D1k2eRf+qSBONYb2Yhra7wAqk6tRnvR0OPBU5oH3GniU8yBViFSUQEhTs2iq?=
 =?us-ascii?Q?yoOw5rx/32dxuW3+6XSTMitkCsdOzjRgwq+QdE5azC9W5loid1jrA3irrOAM?=
 =?us-ascii?Q?MD6SGPEWEwD7Wixs+vg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LXPKr63ncfBY4DiXoZS2BgtxlGaf0UWuiFS+LPh8izWQp9lIekTme2eBwOy0?=
 =?us-ascii?Q?8jS77TxV/OheqDPfcKiCYrKvKjMHYdGMBHQny1/rI/Uc54Buzco1pCQBN8rs?=
 =?us-ascii?Q?8/s7yi5FsjQ4GEaowDOQ7drcMSPMZYt1xSEMtsXCVFKSqXJGpZG9Nb+JmoE3?=
 =?us-ascii?Q?D3EB7iuin074cyAlQMTSJTOfFv/Is4yfFTQHMoVBWfhl4CKpOo0U7OosjOnb?=
 =?us-ascii?Q?tgLkk829KZ3IJfNDS3XGJIQnsaSSw/MWmVXhPE+dpV8lBIkvf5Fvy2V0S362?=
 =?us-ascii?Q?ZcPlO/kDKzIa8ZPm918MRe+J67XJNwWUVSTgvI8gmtwdZVjLz3zoioUGM/BF?=
 =?us-ascii?Q?3hYbrCd++S+W20sXn48L1sdLgZ1D4EpIrQWd9FayrKNMVsQ/0dNw/fhv9DbQ?=
 =?us-ascii?Q?6pLAWhmKIr2czYKYJMkSGb3ZKD/3MU5Q7T0uyKorL4vxOoQvS1VLM9l7e185?=
 =?us-ascii?Q?vN5osSpmwUvoNFdDQihvp7NI76l5YDfzP+lJu112vGgOTz0cduCSgI0NLn96?=
 =?us-ascii?Q?NOfN/jRZW8jXQvEAdFszcvCyoNsKjYU7zWGeote8irDwKX7wkhqfMPezBWgj?=
 =?us-ascii?Q?M+MRULY62ZFpMHzWkUXWApredeHlA6cs/vaFnmfn9HpWdNMRyQTlXN0iQFjB?=
 =?us-ascii?Q?6+Jotey8608PC1xk3NfuGgVzgRyTOf22vj35g8ERitd3Qtzooz+cOl/goA2d?=
 =?us-ascii?Q?8SN3go209g1N+y6lJ5g90L//QWE6Cdb+t2CJvkY8KlNIynq8/W8noiJ0MeFt?=
 =?us-ascii?Q?dK4BJwjqAaLx8xaf2sX0kl12JM/V+vvd/3pQT3k/UVR6EAdm+PGN21MOqC6O?=
 =?us-ascii?Q?t6kCHbT63IvDsm5HAjtkWdMB2+qsg30DJXfNr1cTWY3reWjAuVSIzcHOM0R8?=
 =?us-ascii?Q?COXGiC2+xs5RZcoR7qeEwwU2CUP4IV4xiFXMdrjoU9Pfl9jDK+TV/sxis+Ae?=
 =?us-ascii?Q?opu3v5ufoOYB+5Rf1wR/2PvlVQJhywmkXW2P3Q22QwSkirKLdr439Cc9XXeu?=
 =?us-ascii?Q?ONqeTVtRrqHcUW9Ae6Z8Net8quFo3bp4pz5rh4no7RtMin927RDD2xiil7S1?=
 =?us-ascii?Q?jS6IicFfxCesy9GXL2Lx9IUyhBvSRH2nsWiC3PeHDUsfZXVYjx/8BDf+HqJu?=
 =?us-ascii?Q?0yQTWu+7u4OqAEUM/WMDqZa9lyeJrpwlOc193ltMG8p7yMWGdon++4bDsSY+?=
 =?us-ascii?Q?ZvGsCekF8f79sM/zhsoAopN2HsfN92MxnTYVdsU8Ug0e8yfzFBU9iKj5+GOd?=
 =?us-ascii?Q?CJtlXvIYtH0+qlWzBxho1eeDEKmz57Az4fkKwLo6SVcIUd7yXE4dSyz4b+4M?=
 =?us-ascii?Q?h3e/Wzns7WfkLcS5DLGSFj1bpK2doLgALAMODanf7BMdn1lC6uSSs+NSZud1?=
 =?us-ascii?Q?5hdEROUoSw9kWM6eF69yeiq4XJEwVHTnt525q/zKP5jUphnncO8mQi7exGRu?=
 =?us-ascii?Q?lMphysi1nkyszCjK9C1WZLbeeY5h6AE/K2twpvntDwpXfP5f7V1V/vH1K7OZ?=
 =?us-ascii?Q?wOLyRVdSjXWvlvMmj5+VTNlLohaeHQq2CiY2OL2hPHxp6nR9n8dZpQQAvmZF?=
 =?us-ascii?Q?KWpS9M2o0pO67hxLGnUOOci1BJwRvgY3PqKcGxy6LrNccvdlhbGXdbvOPfgC?=
 =?us-ascii?Q?BYp6kBo1zvBV/LOWG/mn1T3q3CJQ65qn8shkBtOJJRcE0oIpZ4F6gB05IQC0?=
 =?us-ascii?Q?hI2ePJU0BvXHW2EM1fIOyF8MAFfTeruHVBC8q+ZLgg8Nwwgb6aURl8tVvv7T?=
 =?us-ascii?Q?c00Tdbc96A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cddc065-0744-415f-d633-08de5f3fc949
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 14:07:49.9255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2A9uEJcVUUTlkl/PQVLR2Iy20XJ9qKfh5ZjkpEffcbLsnf8hsV281gAdoDN8Vdhi5Us2vZqc5E5ObJgaNXG2pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4916
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69548-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 254E7B0B72
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 09:01:35AM -0800, Dave Hansen wrote:
>On 1/23/26 06:55, Chao Gao wrote:
>...
>> This approach follows the pattern used by microcode updates and
>> other CoCo implementations:
>> 
>> 1. AMD has a PCI device for the PSP for SEV which provides an
>> existing place to hang their equivalent metadata.
>> 
>> 2. ARM CCA will likely have a faux device (although it isn't obvious
>> if they have a need to export version information there) [1]
>> 
>> 3. Microcode revisions are exposed as CPU device attributes
>
>I kinda disagree with the idea that this follows existing patterns. It
>uses a *NEW* pattern.
>
>AMD doesn't use a faux device because they *HAVE* a PCI device in their
>architecture. TDX doesn't have a PCI device in its hardware architecture.
>
>ARM CCA doesn't exist in the tree.
>
>CPU microcode doesn't use a faux device. For good reason. The microcode
>version is *actually* per-cpu. It can differ between CPU cores. The TDX
>module version is not per-cpu. There's one and only one global module.
>This is the reason that we need a global, unique device for TDX.
>
>I'm not saying that being new is a bad thing. But let's not pretend this
>is following any kind of existing pattern. Let's explain *why* it needs
>to be different.

Thanks. I understand your point. The pattern I was referring to is: using a
device (PCI device, virtual device, or faux device) and exposing
versions/metadata as device attributes.

You're right if we look at the details, they're not exactly the same pattern.
I'll revise the changelog to make this clearer.

