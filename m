Return-Path: <kvm+bounces-59820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 65214BCFBF6
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 21:42:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80EDC189B371
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 19:43:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F44A288CA6;
	Sat, 11 Oct 2025 19:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XFTlgSvk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA77228851E;
	Sat, 11 Oct 2025 19:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760211674; cv=fail; b=aiGlVNqHjZPco4Aim7wdSZlGE3Y2/NE2MQVACwpEq4pC+g5bOIOcbExnboig2OPkt0VHU73qD26/IewdxZz7Rk+Bslnvw2+AViEsVYLPqrurqFaeaNd65SGWJvIqn82BE0YDccnkRh+IGDGCnljuFJjcc0wZVKcizGjXS6cu6Ug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760211674; c=relaxed/simple;
	bh=gl8XG4mx589vqHS6kLJQ2Afc7fhuj9YLFN57rUJqr9Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EwdtIBEc8DgL71uzZaH135JceaYLIVAoSaXwj/6HeWaz+p/xmY34fM36WQ6jjsrGqWe86Ducam4V8L8t0ArZ5hTTH92bZYNYghgshNzMhyGKV+7Z/7fhKVvkV69lD7c85BYESkQZNx6zii0uSnNDKg+ugpz1zlQPCwckzJH/qh0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XFTlgSvk; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760211673; x=1791747673;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=gl8XG4mx589vqHS6kLJQ2Afc7fhuj9YLFN57rUJqr9Y=;
  b=XFTlgSvklI2PpWDZtS1D4Rt1ciL/tMGF3j3AC38gI6WNJ+lyNQciGbsM
   nvimHNTbnFgISwYuW1OHFHMysHaE8O4UuMB3r+yiOjeydopoxTFkt4XiY
   zSm9VUmDHmcHU+CPfHiPnrlB6QK3IsSNmsuaT0M/SuHgRflGn2JTUJwUb
   vz1/acaVJ8jO4zSnVbLaZB8KGjPWWCrZcjpLZnWZqzI7V7lsjyyh5ebnK
   sCMRpMSWW7r/mVMGoPcpoXxurxuFFLfGGAJeIscV+Lcvc9z0hGnYvZg1s
   6auvnSxmqrzkkb4TQZcgxyjG61iGpeMH/4zNSC7axFF6VcxX9JleWb6AG
   A==;
X-CSE-ConnectionGUID: IKqrl2V5SnCPLBQnwURzgQ==
X-CSE-MsgGUID: DakODtGATZC9NH5/dgYvSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62342195"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62342195"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2025 12:41:13 -0700
X-CSE-ConnectionGUID: Vvdq/0MyQYi9LshNOWt65g==
X-CSE-MsgGUID: l7P3OahnT4m6Fy5CFFvTWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,221,1754982000"; 
   d="scan'208";a="181661712"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2025 12:41:12 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 11 Oct 2025 12:41:11 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sat, 11 Oct 2025 12:41:11 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.6) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 11 Oct 2025 12:41:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MZqYMMeO7/vRAuMZNnfxGzsvk2SHNTsoXO0GReQ8NbCT/DQ898QKYERKJlu2HG29vVIYTI9oT+zerB+9PUpudneOJpGTj3rdbavxm2wHRPTLxHfpzQsOcdh7cJoi/jz7Zm4OwsK4oz6Y5RvDxudIEqQc7L379DZLs0eKr5gqXHSryOc7Gn6wXb8+DFvd6tCTeJlQ2GWfeGjnEQlP5YuTXbb4VajbjBmPpcfc7HFQqGc2LL4POzIIbwMaetoN/QjzPZhV5YYR2jxyJqAZD1KU3oFL711H4CPVGb7h2j5K3gnqd/kHKC0lJP2XP2u41cIdEQhhOeP1P5qWZ0Q8KSqw5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ZQTsFmi72U3B9CC5aW65rZ4Q+pyvaeU2BNMffNLNQQ=;
 b=jKr+MrOhnC0TxTgEmfMMSk47uBYbtMHa0TlZbVhqvpe4VpmrzsUvmtNH90dpYCNntDx85RWwGwn396Gdftisjoc/Kw/AHgqDlWfY6RbdG6SZDgdILWOB35uDKjJTpdvYBVAZTMMg4LgnMXNiO4ki3Xao8fzojVBLzzWrN7AHBlQ1vOUsrGhoC/OE8PeMDyQNw2JxUeZ+07Nv7NcndKC2BDQYOBTZq2U1rO8o71fKwny3vWlKmGwyY6LrhaXCXUCDGuKcldKfe2TGyo5MDWMgjbmlnLIv3LkUmlj2q+LtzQIUcxZW3M5N6mIFrDkZIOdwef5XDNKHjnFJDkcXCXfxWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 DM3PPFF2E67D388.namprd11.prod.outlook.com (2603:10b6:f:fc00::f60) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Sat, 11 Oct
 2025 19:41:09 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9203.007; Sat, 11 Oct 2025
 19:41:09 +0000
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, Lucas De Marchi
	<lucas.demarchi@intel.com>, =?UTF-8?q?Thomas=20Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, <intel-xe@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <dri-devel@lists.freedesktop.org>, Matthew Brost
	<matthew.brost@intel.com>, Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>, =?UTF-8?q?Micha=C5=82=20Winiarski?=
	<michal.winiarski@intel.com>
Subject: [PATCH 12/26] drm/xe/pf: Increase PF GuC Buffer Cache size and use it for VF migration
Date: Sat, 11 Oct 2025 21:38:33 +0200
Message-ID: <20251011193847.1836454-13-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251011193847.1836454-1-michal.winiarski@intel.com>
References: <20251011193847.1836454-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0188.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::7) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|DM3PPFF2E67D388:EE_
X-MS-Office365-Filtering-Correlation-Id: 1888ba8a-77c3-4a47-0bfc-08de08fe209f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y3MvU1hsQTJYTXlZR241cmh0cE9KeUlBQzB0Mldzc1hzcDRJYWM3L1ZNNExR?=
 =?utf-8?B?bXV1eE53clV6N0IzekZ4RzRVQ1F0Q0pDeDN0ejBicEJaZ0xTTVNnVmNTVmdH?=
 =?utf-8?B?OHhwdU1wVTNXYzdqMExKbDNjWDM1VHpGR29TSnhDVWx6SVlYMlc2b2Jnd2l5?=
 =?utf-8?B?aEJnbzd0ZEx1MmptcXpOc0Q2cU1ZejY1Y214MVVTTkdPdTd6UGpSRzBSVWJQ?=
 =?utf-8?B?MXZ1dmx3ZW5yRFZuZDFtblNrK0NiQk90Wm53QVhhUjdFRWQrcFMrU3lvVnRK?=
 =?utf-8?B?Z2N1eXBCUTJtYVFtUzN3S21DSEU0QnpvK1BUdkl1Y3RrbU9PVmJ6Q3A0NUpU?=
 =?utf-8?B?M2J3N2p4b3VJemx5bG4ySjJSY3hQQURyMnpjRU5yUlB4S21xNEoyT2tmakY3?=
 =?utf-8?B?KzhaaC9kaTRVZDVHY1RkTFlnQ21EVHUwcEdMSnFBSGdtVTRDVmhxMGlQc004?=
 =?utf-8?B?cEJjSTdMWi9Eb2xNdlVKbzNFSE1WMENRc0ROUlZwN2NtR3h6TTI3cXpaMGdv?=
 =?utf-8?B?Z2laMjBMYmQxWlB0MlJ6UHlnWEdod21sREV0Z2JEMWJxQlNsc3ZRazlOSnhN?=
 =?utf-8?B?Snk4MXBDaW5MVG5kaFp1eWYvdWlackpUMk1wbW9rS0ZiWXNFMFdtQVorUVAy?=
 =?utf-8?B?MXNvTXhFM050Q1hrdy9JTU45WjkzMFpSMERoeWVSVDBEbzBxeWQ2WXVnQzdV?=
 =?utf-8?B?QkpxMTZZMjl5bDdSM1hCQVUrYU1ZODJrbXA4UTZKKzdXV0kvSmg2bTJiNU1s?=
 =?utf-8?B?M1RBUUs1eUdTRmVscVBJSHNia3Y0THRyekJjQjBSaFV0OVNhc1hOQWxMa2FK?=
 =?utf-8?B?UHE4U2FkTS9WOUxUU3lwUEt6ME5BMzUwRURBRk9oRHhUK3ZTb2lrREdiRTlX?=
 =?utf-8?B?NUpjb1F5WXJDT0w3UXFXUWtmZWFVT284OGl1YlJOdzc0cUw0K3pnYVFUZ0NX?=
 =?utf-8?B?cFFjUFhGbjYxMC9xZkwxV0JZVElUZ2d3cGhOMTBTNUtBc2RTSXEvTHMyNWhL?=
 =?utf-8?B?UFZMTWxzQ0QyeHhrMEZFN20xekllL3RMME0rVUtMOWprZ00zZjZTeVhLU2g4?=
 =?utf-8?B?SlIzdzRIK0hQczFDcE5RNUErdk1zalByK1hKWVdBVStEZXlNQTcrVW14TVNr?=
 =?utf-8?B?WVpJaTFoZG5MVzZOeDFON2w4USt1eWNHMnR6b0l2YmV5TDk4d3VwbXhlci9N?=
 =?utf-8?B?YmJHbDVoUzJCRnRjZ1djME1heGUxUTBmdTFVRGJpSXlDMDkwT1YzclV4YWNK?=
 =?utf-8?B?RlZEK1VSV05OVFB4ZU50VjBKTll0c090dDNIMGRZRTdvNUEwQWZlckQvcWtB?=
 =?utf-8?B?T3gxOGlkdGx6M1dZbllGWDBDd2x6RGhId0lUZEoxVWxxWkk0UFRlc0UwZ3hD?=
 =?utf-8?B?eU5KTElLWDd5dlpWZS9mRGg1TXd3ZjJwM2kyVnJXT2NTUEpEdm9kN0xRNXJa?=
 =?utf-8?B?WisvNnZ6cExrUURsUjYrK0d2dzE4MnN6VldPdjV4bnFwa3lUWEticnA2MjFr?=
 =?utf-8?B?RERjS3o2dVVDNE1hWnZNT0pJYWo2cldZdW1lcVNpNmVKdldUeUordURXYlEz?=
 =?utf-8?B?eUFjNlBQc3Uya21IbVhvaDBHYkhwejcyWE5XWkFSR3pEbmpGU1NNUXR4ZW93?=
 =?utf-8?B?SHRnQ2w3eDZIdnNkdEJvblRVWDVTZ1p6VkpQc0lLNDNkclROUnMzaVROSU1X?=
 =?utf-8?B?VDBTY3ZFQmNtSSs0akliNVV4MFk5SG9nWHV1UzE1dDVjV0d0eEx3SDc3Q1U1?=
 =?utf-8?B?VXMraGhBcGtTOWwyM3NweUFUT043b3crNktXMXlJMEFZbUxkWHg5YzZ2M2F4?=
 =?utf-8?B?VUphenc3V09hMGh5TnU1VTlQWmVBT3ErdXk1WXZIRnNManZxTHF1WVJiYUtI?=
 =?utf-8?B?UE80Nmc5dGo4UFRLV0pORDRhMnYvN1U4WWp5dlNVbmNFWU5adVIzVkJ4SEdF?=
 =?utf-8?B?RmhQdWVyY0o2YVBVNVJVQTlXL0RCZTQ0bFFWUUtVVG1KRm9CMjF4ZjBBMUhM?=
 =?utf-8?Q?lOn4dtv0z4ArDc9ky3v3bDnNYtDkks=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1RhWEJJT1JwNjBRMVJRK0h6d1MvZHRpeGx2QzFaaVdVR2ZVNEFvTVgrMzlU?=
 =?utf-8?B?bU1FdGlPdDZQRWRyZFJlTjhHeTF0Z2k0TzFCZHRzMFd2M0xQYm1FZmpZZTVa?=
 =?utf-8?B?U1VJeTlRVm0yWnFQODE3OHlmSzJ0VW5PWkpDZTBWL2ZHUm1pcmhESUxiMGVa?=
 =?utf-8?B?eUVlc0JzOVdBMkVoTy80UDAxOSs5VWRmSDc1cXZqVnNNamhhYzBYNFcydFRt?=
 =?utf-8?B?bXorTndQd0txQ01ZbEloTnVHczhLVFZ2cys1bjFYdFpTYlhDa3VNVVhuVjQ5?=
 =?utf-8?B?cEtSRWtIUTBNTFZYT0NLenZXZGdQSzRXWEp6OS83N29TL1dPTVAxS2VyL3hU?=
 =?utf-8?B?MUd3RkVXRmhORVllSDRYUHhPMFQyeG9naFVxeWxPaGtUSm9rbDQ3Q1JMalA3?=
 =?utf-8?B?bXFLdC9BMlk5VEYyRzh6UVdIK2JrTVFpMklpS3dqR2NUemRNSTB6ZjB2ME5Y?=
 =?utf-8?B?RFpmY3pHSUdYTTYyTk95aU4xV0s4alN5N1RwRXZKSjlVSlV3VVd5Mmh3a3Rv?=
 =?utf-8?B?TlUrZ0ZZOWpXbXNxa0FQVnFFWmViTHBuSGNFZWZYSktPYmRTNDNtSzJOK0lZ?=
 =?utf-8?B?UDhSK3psaE5BVWk3bE1RSDBHM25NQjBRdVNUVHpiQ0JWbVg4Z1VtTGlGR08w?=
 =?utf-8?B?YmlRY2hEaEhraXZtY0Faejc0V3JzZkc4VDNoVENRUFJsV2FycFJaTk15NkNT?=
 =?utf-8?B?ZjdETjVnZUhEQWFTZmlzMUh5U3pvVGZ3ekhGN3haSXBlL2Robm82RndZZk5h?=
 =?utf-8?B?SzY1c1pWUXZYL1RpNkJQT3psYUF0M2haa09qL1BWOWNVeEwxY0tqalZyQXkw?=
 =?utf-8?B?aXd3a1pRL09YQTh3NWRJT3pDaC9KOWg1L0tqeWZVVFc4cWUzR1VMRmJUcDNy?=
 =?utf-8?B?QUp1N25XV1YxTW1NOHZFMFRTR1ZuNFdYcEJ1MWtoMXBId3BuNzZtcnE1QytG?=
 =?utf-8?B?QlJzVnVEMjEwQ3VNYWwwdzF4T3Y2OFQwVno5akx2ZHI1ZXBaTlEzM2J3VlpE?=
 =?utf-8?B?am9vcDlIRjBNOHh5SDBlSnphaHRGSHdhYVllNDdZcml2VVM5SmhRWlRhNjRI?=
 =?utf-8?B?bkt2Mlc5ZExES2N1UnBFbFFDUzZUMXNFVEJKU2JGZHlGOEZmSmN0M2QrclM2?=
 =?utf-8?B?dVFBU1ArZUtEdFhKdDN6aFBFZzBBRlB5K0k2TG1nSUlUTGk0bHh2WmVUdzNL?=
 =?utf-8?B?L0pMKzlEb1A0Yi9zZENrOUIwMnVRSyszR0RPNFJWQjgxNytveFFKWm1QNVQ0?=
 =?utf-8?B?TVl4NFdUdVhyOThDa0VBdFRzMkV3dzlqU0c3UCtVTmF0QlBFZnMvb2k4bU96?=
 =?utf-8?B?WWg3dUZRanMxeEJOZEhBZDB6NSt6OXBHWWxsTC9XeHFjS2V2NVVpUHhyeWFw?=
 =?utf-8?B?bGNFL21taFRmWWtXVUtYSjJnbDBpMjFpUktEbmRKNE4rS1cxMXh3OUdpQmo0?=
 =?utf-8?B?Ti9Dd0h6RzFNdmg1eXg2NHdYR05vU3J6Y1VEU3RlU0VvNTU2a3hST1NWcEtI?=
 =?utf-8?B?bzg0REpKbGFReGdtVTBhRFQwUnhxN1FGWHdJNDJNMXB5ME13QXYwOTlNNFBv?=
 =?utf-8?B?UmoxWVVyNVJ0ckNQNWxmcE5zK0FMU0RMY21reks2bjZzdmFGS1NjSzc1Q3Yr?=
 =?utf-8?B?b0NRTHBsZ3lpaW91dzdYY1BQRnpIWEdrTXU4ZFdIN1YrczE0VTUwMTVGRURs?=
 =?utf-8?B?MFlYRnhJZ0YwTEtoUStFSWZkcmo0WTZxcHFFellJMXZ3VEpMc0c5UWdFdndZ?=
 =?utf-8?B?Ym5UMXZkcTNWWGp3OXZ2SVg5VEhrZVgyNGtJZzZVNUI5Z2pTNTZRUUh1bFFs?=
 =?utf-8?B?a2FxL0pQWDczRnRsVHFyN1NyUnFKRGgzRmh5Uy9tUVNjRmtpL0Mxbzh4Wmp4?=
 =?utf-8?B?eEdEREF5OUtWbVJlaTlPNWxoeUpxbVNxMXd5Rml0eW1ucnlSK0VNcWJXVUtF?=
 =?utf-8?B?N1NpOW5yMkhPMURvemhCRi9yTkFUNnd2TkhFZlB1ZnZkaFVSV2RQZHBHMHBu?=
 =?utf-8?B?dEdSRWtiaG1LamNEVk9qMllRVWpTZXdKb21xS1A5YlpnNWgzSmFtTnpZdXp6?=
 =?utf-8?B?alVkVFllWnJLZGpHNmlQUWxKZ3Fid0EwaGV5dzAyUU5ZVGdtcGo1RjFmRytv?=
 =?utf-8?B?dXMzSWZPOXZ0US9OazhnYVRmd3lJTGhGcjJOZkpYeGNvL1g4YTJmcDZPUEVQ?=
 =?utf-8?B?Nmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1888ba8a-77c3-4a47-0bfc-08de08fe209f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2025 19:41:09.6203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nfQ8yV7JCUGSsWOabcGfQqa8UnEuL+QpQbIFNB73MpuGdA5v2beQYAIvtduOMNntX7dh2VigPgJ+cj3rHUxWWfOAfX1hz+yPSv5P6VPUpz4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFF2E67D388
X-OriginatorOrg: intel.com

Contiguous PF GGTT VMAs can be scarce after creating VFs.
Increase the GuC buffer cache size to 8M for PF so that we can fit GuC
migration data (which currently maxes out at just over 4M) and use the
cache instead of allocating fresh BOs.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
---
 drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c | 54 +++++++------------
 drivers/gpu/drm/xe/xe_guc.c                   |  2 +-
 2 files changed, 20 insertions(+), 36 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
index 50f09994e2854..8b96eff8df93b 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
@@ -11,7 +11,7 @@
 #include "xe_gt_sriov_pf_helpers.h"
 #include "xe_gt_sriov_pf_migration.h"
 #include "xe_gt_sriov_printk.h"
-#include "xe_guc.h"
+#include "xe_guc_buf.h"
 #include "xe_guc_ct.h"
 #include "xe_sriov.h"
 #include "xe_sriov_pf_migration.h"
@@ -57,73 +57,57 @@ static int pf_send_guc_query_vf_state_size(struct xe_gt *gt, unsigned int vfid)
 
 /* Return: number of state dwords saved or a negative error code on failure */
 static int pf_send_guc_save_vf_state(struct xe_gt *gt, unsigned int vfid,
-				     void *buff, size_t size)
+				     void *dst, size_t size)
 {
 	const int ndwords = size / sizeof(u32);
-	struct xe_tile *tile = gt_to_tile(gt);
-	struct xe_device *xe = tile_to_xe(tile);
 	struct xe_guc *guc = &gt->uc.guc;
-	struct xe_bo *bo;
+	CLASS(xe_guc_buf, buf)(&guc->buf, ndwords);
 	int ret;
 
 	xe_gt_assert(gt, size % sizeof(u32) == 0);
 	xe_gt_assert(gt, size == ndwords * sizeof(u32));
 
-	bo = xe_bo_create_pin_map_novm(xe, tile,
-				       ALIGN(size, PAGE_SIZE),
-				       ttm_bo_type_kernel,
-				       XE_BO_FLAG_SYSTEM |
-				       XE_BO_FLAG_GGTT |
-				       XE_BO_FLAG_GGTT_INVALIDATE, false);
-	if (IS_ERR(bo))
-		return PTR_ERR(bo);
+	if (!xe_guc_buf_is_valid(buf))
+		return -ENOBUFS;
+
+	memset(xe_guc_buf_cpu_ptr(buf), 0, size);
 
 	ret = guc_action_vf_save_restore(guc, vfid, GUC_PF_OPCODE_VF_SAVE,
-					 xe_bo_ggtt_addr(bo), ndwords);
-	if (!ret)
+					 xe_guc_buf_flush(buf), ndwords);
+	if (!ret) {
 		ret = -ENODATA;
-	else if (ret > ndwords)
+	} else if (ret > ndwords) {
 		ret = -EPROTO;
-	else if (ret > 0)
-		xe_map_memcpy_from(xe, buff, &bo->vmap, 0, ret * sizeof(u32));
+	} else if (ret > 0) {
+		xe_guc_buf_sync(buf);
+		memcpy(dst, xe_guc_buf_cpu_ptr(buf), ret * sizeof(u32));
+	}
 
-	xe_bo_unpin_map_no_vm(bo);
 	return ret;
 }
 
 /* Return: number of state dwords restored or a negative error code on failure */
 static int pf_send_guc_restore_vf_state(struct xe_gt *gt, unsigned int vfid,
-					const void *buff, size_t size)
+					const void *src, size_t size)
 {
 	const int ndwords = size / sizeof(u32);
-	struct xe_tile *tile = gt_to_tile(gt);
-	struct xe_device *xe = tile_to_xe(tile);
 	struct xe_guc *guc = &gt->uc.guc;
-	struct xe_bo *bo;
+	CLASS(xe_guc_buf_from_data, buf)(&guc->buf, src, size);
 	int ret;
 
 	xe_gt_assert(gt, size % sizeof(u32) == 0);
 	xe_gt_assert(gt, size == ndwords * sizeof(u32));
 
-	bo = xe_bo_create_pin_map_novm(xe, tile,
-				       ALIGN(size, PAGE_SIZE),
-				       ttm_bo_type_kernel,
-				       XE_BO_FLAG_SYSTEM |
-				       XE_BO_FLAG_GGTT |
-				       XE_BO_FLAG_GGTT_INVALIDATE, false);
-	if (IS_ERR(bo))
-		return PTR_ERR(bo);
-
-	xe_map_memcpy_to(xe, &bo->vmap, 0, buff, size);
+	if (!xe_guc_buf_is_valid(buf))
+		return -ENOBUFS;
 
 	ret = guc_action_vf_save_restore(guc, vfid, GUC_PF_OPCODE_VF_RESTORE,
-					 xe_bo_ggtt_addr(bo), ndwords);
+					 xe_guc_buf_flush(buf), ndwords);
 	if (!ret)
 		ret = -ENODATA;
 	else if (ret > ndwords)
 		ret = -EPROTO;
 
-	xe_bo_unpin_map_no_vm(bo);
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
index ccc7c60ae9b77..71ca06d1af62b 100644
--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -857,7 +857,7 @@ int xe_guc_init_post_hwconfig(struct xe_guc *guc)
 	if (ret)
 		return ret;
 
-	ret = xe_guc_buf_cache_init(&guc->buf, SZ_8K);
+	ret = xe_guc_buf_cache_init(&guc->buf, IS_SRIOV_PF(guc_to_xe(guc)) ? SZ_8M : SZ_8K);
 	if (ret)
 		return ret;
 
-- 
2.50.1


