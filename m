Return-Path: <kvm+bounces-59833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 12665BCFC32
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 21:45:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E00CF4E9F85
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 19:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 336892BE03E;
	Sat, 11 Oct 2025 19:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TfprgPLn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA392BD5BB;
	Sat, 11 Oct 2025 19:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760211734; cv=fail; b=KQaCOZIaqrsU7n1VnhOd5Klp8PwQYb4GrkqAoh2BCQFmDOcclIzvMb0WOduOsGBKm5vyauTI2G+g9Oqp8qHxd3h8GKqcpGRCA/US+O3n15AWmp3quUTVUBuZKUg6cHXwM8Sw5LVSTZc39o2eSyZ/oYk4A9aBIMY+KQ7XIhHpXqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760211734; c=relaxed/simple;
	bh=fbB39gcVczD9Pu307FLkPhZkPUtt6pywxfvmxW6DzZI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fix7mSf3M3SSHk6gj8LdBkg4KcE71uf/99MTlvG6YY4rigAmuYkopSyWzXKItjAdQIdonRRLTu5THaGEcM01OCOan6Vy20r8gCSdqXdsMqSfxLmd+n7pF4xczoJd93+gZM+x7K3aOoocjp4IslzqQOmsyMAMpwTnqQ2TKpdJsKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TfprgPLn; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760211733; x=1791747733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=fbB39gcVczD9Pu307FLkPhZkPUtt6pywxfvmxW6DzZI=;
  b=TfprgPLncSNgOaowZl15CWINrL/8eY7mhJLV6RouUD8upeIcnNYMp2LC
   zd2yLgsBkyzDma2HuUdqrEKC8TVW6N1ZCjGMybhlrylBIUIKn52GJajTy
   nwu0MsnJfo3Bds84qad99RhCj7S7R0fEkRz9tcStQFYZ9a1nUDTDu7uAR
   nKfrIeKj783drklOzZuo5C7kRxQGh25/KZLsVkn1Jt19HR52RY9zmKlDs
   u19mIL3lgiNe3Ol4qcayegYf7SX2lxxIZ2cdyxp5vRLtqcxOFRrc6Al75
   d2VcOJiHa7YLPQdiMU3dI56Mnw9Y6u6WzQV7woKC3WF/lG+bBH+M4IGfc
   Q==;
X-CSE-ConnectionGUID: MFIIIFADTtOjbcvDZfI90Q==
X-CSE-MsgGUID: G5HJiRUiRGuPvoDUBK4ZCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="66227506"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="66227506"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2025 12:42:11 -0700
X-CSE-ConnectionGUID: lHnjVX8ASMGiHParOisz4A==
X-CSE-MsgGUID: ydszTYa7QM6HVuTunNYRvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,221,1754982000"; 
   d="scan'208";a="186525195"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2025 12:42:11 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 11 Oct 2025 12:42:10 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sat, 11 Oct 2025 12:42:10 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.51) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 11 Oct 2025 12:42:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uV5DuLPoOLD4t/hXD3BmBIxb4Zn+HN2BHpGlPUJiTweVHXcSFral8k6mCg+RkvvrRQVJWEePxT32PuFIzbeKPxua0Jompg+G+fCnjvV/minsvrkWR3C/niRFCPMTvS6OcLJQBsSYohMTuqjFy6T0t5zWvnp5nj2fSyKs3O6AJA+6ycpr1FLrSRXg+q1hn3sInLIwQRoRRQAFJtCQePkzu6YRijhFRa2GyOeKJDclTqk8Qh9rBWsfo+uNo1styGUMvL6JtSSgQTtNCyD0ylBwccTmxVRksjfbEdzL5X+F4Tm9PTwXFbONwxadunpRxwQ+x8e13d8X8jL6cTNTxXfhiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VmSYWmyeRIBBgumHs7d8Wd2K/bhJOfcrBUjD6G4bdGA=;
 b=j1uzhrmqrZcl1iK8o+9NmFhEe4jbj35JWTBTNJYZHKAP64lEJmGBxoMz+aqBlnEoAc+JNCsM1SaDo2Zkw5nlkwRQwG8Ma1lAAB2W5NESVBk6HggaC+dE/cZS+xkPZLiG3lHNZ/iuidOBvR3LGleV17pH0sIE7/p+Ykn+tlT0nBkdjeaO3Vz/2BSerbZzwoYZMXc7j9Dgqz6AaHxmAAhtVkg1TmUvXCBAo3KpxHVYdj/sVR8oGSUtq44YWgA6dPz46buXAu//eI+7a60eFQXhiKpAHRTVj7fIAzz8Yck1o9oTefI9fuhXjrikYIBwVo7wZZ45jL500M8ocMhMzsGAOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 MW3PR11MB4681.namprd11.prod.outlook.com (2603:10b6:303:57::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.11; Sat, 11 Oct 2025 19:42:06 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9203.007; Sat, 11 Oct 2025
 19:42:06 +0000
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
Subject: [PATCH 25/26] drm/xe/pf: Export helpers for VFIO
Date: Sat, 11 Oct 2025 21:38:46 +0200
Message-ID: <20251011193847.1836454-26-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251011193847.1836454-1-michal.winiarski@intel.com>
References: <20251011193847.1836454-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR08CA0206.eurprd08.prod.outlook.com
 (2603:10a6:802:15::15) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|MW3PR11MB4681:EE_
X-MS-Office365-Filtering-Correlation-Id: a77af0a1-79b4-4eec-c7ff-08de08fe4258
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TmVLbmhCNWxTczdFYytieTlmTGsyKzJ1TEtZZ2NIUlliVGpnOEpnVW16UXhP?=
 =?utf-8?B?QTBjc29QNXJpektVeVY1amw3SEtLQzRIcnVNSEUzWE1WeXRTVU5KOXltYVM0?=
 =?utf-8?B?ekJ4UGJ5SncycVJNR2xkVjZFcElSTFNlbitqdjlyb1lwMnQyS29LU1hWdEhm?=
 =?utf-8?B?VG4wcVl2YmRXdnQwU0tLaEN3bWFMbHFqUERSeDZoQXp4RjFwMGtYT1pFTzNv?=
 =?utf-8?B?eVlsVmpCNjI3Y3Fzd2V2akx0OVhpR0xmUEdPMWxKL0ExeFg1TFpsWisrUkpy?=
 =?utf-8?B?VkFiMi9yVGV1WmwwMnNublZVUysxa1d4OTJDeStZcUJyRytjVlNkR1g0SGFL?=
 =?utf-8?B?STU0d2d6RmMwVkxwQnhLYUhyZmdHbDJSWHFkc2NuZkhBbDY2SVdjVEtYV2Ey?=
 =?utf-8?B?MDFYOVkvcVNVTEZ5dnR1Qi9nRG0xRlc3Wldab0ZKT2w4OHZROHF5SDVOblZT?=
 =?utf-8?B?aDRNRFBpMGJ3RTlwT0lqZjNvR1lIRExJVE1WeGIvTnBhQkp1UW9TVEFWYitP?=
 =?utf-8?B?dUV4WmZnbWZFdW5qMHFWNWFYUk1vMFlhdEYyQWthWWJZanJVaVNOY0svTTA3?=
 =?utf-8?B?T2RERThRS0RyOHN1aUxtcXJSaHFnaE5ZQnczMmFNcUw1UjlSeElOYkV3VDlr?=
 =?utf-8?B?cGNOQnQ4c2JTbXppeGFXQi9NZmc2N1JIcnM3M3RZYUY0bU5PMjYyelUwdWNu?=
 =?utf-8?B?OEsrWmIzdzBvTnlQdnFZWDBRUnphM2w2MXBBQkJOSld4S0hwVGhPRHJlQVo2?=
 =?utf-8?B?L09ZdTMwVGQrd3hwcVdURkhOK2JLT1FiN1grS1I0SmVwMkVTb3JYSkhYOGx5?=
 =?utf-8?B?N1JYNnJSK2ZodFZuTnliWllLY3daWGFFeEV6Zk5pYkNkY0pXK1B5K09nK2Ro?=
 =?utf-8?B?R1Z3K2pkUHowL09HbVd2dmJlSUVNNTJ5ZDZSMnpzczNWS1dhbmtJK3p2Mkpr?=
 =?utf-8?B?eCtLUjZzclh1VmRYRW8zUEwwMW1UWmlsUThmZ29UMXV6S0pQRDZrdWZnN0FR?=
 =?utf-8?B?bDJjQm5mVDhyVXhadklmYmppbGRmTnhNclcxT29TOTh4akR0dDhTb0JuVmxi?=
 =?utf-8?B?eHQxUndjRTJNN0lnekVyRDIyWExmTW13dnFLOTJZMHo4QnczMUdJRHZWaThG?=
 =?utf-8?B?R2FFSlZpUEpiYUdzcmRZdHkrUUp3YjNBWHB2VFpWcVMrMlVNYUZqNUY3RC9G?=
 =?utf-8?B?TlpQM3ovd3c2NXV2MlJNMHRwalRiRE1DR2hVb1lMNk03ZkFmak5MOE4ySXJ2?=
 =?utf-8?B?VXJyc3JKY1hpUlVLbWphemdvNUpLaGU5MGtpZjFMNEp0NisrcXdkNUVZSXR0?=
 =?utf-8?B?Sk4vOFg4V1ZrNlR2c0tPTmR4czJRNHhJcSs1VFJzYmFMQlNBdGlyVm1aTkla?=
 =?utf-8?B?OVY0Zi9YQ2FrQW5nR1o5UTFHK3pEeXZycVNXazcvK1JtZGg5THRCVW0yQjJX?=
 =?utf-8?B?Z05VTERSbS9LbzlHaDVySTRkR21sQ1dHWFRPcll0ck5PVEwwRnBBbEVkc1RJ?=
 =?utf-8?B?SEF0MVNZV0NuK0c0M3lvM09peHhHQzJWSkxpcXdkYUZQTUJYMUNqV1AxMXRq?=
 =?utf-8?B?YTFiMmFRU3ZOUXdENy9WZlZFZFhwdUcxRjFvVUtBVFFsbEticldDZ0pWeU5K?=
 =?utf-8?B?U1A2SUs4dGZJNEJlMTFvaEtZcnBiVDR0ZjJoK0grRmJLc2pxY1A2Y2VMSWhV?=
 =?utf-8?B?d3RqV0ZwRkFHb1haSHlkczBkM2xxL0tSWUVBSzBjYXNLWm1ER2xlcUdVRXp6?=
 =?utf-8?B?Qk5JKzI0cGR0TytYSU0zWjJkdnNWUG40ZjN4RXZTUjNQQ3lmOUo4SDZsNllM?=
 =?utf-8?B?Nzd4YnpzUnFRYjJnQ0tjVThyL1NodHVzUERSaXBFenVKUWU5VVlHKzhobWxm?=
 =?utf-8?B?ZXRLMmZ5R3BEMFdqZ1gybWFOQTY3dExlQzJtdVYzTWtMais5MWtJYithdk5U?=
 =?utf-8?B?ZmNyNEk1cDFOZStsL2wvZlVUN0VLMUwzL2k3OFRMdWFrWXRpc1lBUW4xd1B1?=
 =?utf-8?Q?FmE3U3W6YWtdLcVi7WN066Pngkc60o=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TWRXU2FEQ09SVXZVRzVpZC9MVXh2bFpMR3pKV0FMRUhyR2ZaS2kyZktiaGZu?=
 =?utf-8?B?TVE4cDE3aTFRZGtPLzRROFBmSHFRQTViRnNkRVM3MlFjZ3JhWVc2Zi9zUnAv?=
 =?utf-8?B?MkNsRTRzSXh5bGozaS9makRad01NZVVZaFAzQmc3a2N5bXBxU0ZiTzFxazBJ?=
 =?utf-8?B?d05UT3J0SjNhaGp5YVg1WUx0SlJqdEJtSDU0S3pSaVB2b1BWRTNTVFdub0pU?=
 =?utf-8?B?UXlrSTdCeXoycW5pVXh1K2FBNkp5TGRwK256enRyRzFNOHRFZnV6NkNxTlVP?=
 =?utf-8?B?NnpmYlFKL0VLNUhSM2MyUkhhdlpFZWczak5ydS9BUWpSRDBPY2VYT1JwbGM3?=
 =?utf-8?B?SG5BVnVmdU8veWNVWFV3U1VhQnhtUkhqNitCZDdaWG03WVpXMlJXanZ2Snp0?=
 =?utf-8?B?bERuRm5pbnluNUJhbWNXWjd0R1p5MzcrRjE0VGZrWnZSNjZTRXRiRWlEVGVm?=
 =?utf-8?B?V2FxaTcyOFZ2T29YbHAyWUh4ZnBsSnFpaG1vSVBVUkhIMmU4QjRWbC82d1VF?=
 =?utf-8?B?WGIvaW04NFdJOGdWc0RXdmtLdjYzWFJoMy9tb3JSRjZkVGd0WFBRbWMwWDkz?=
 =?utf-8?B?bXc1R1U4VW9tcHlQNmg2eHd3dE8vU0tMV3d2aitOb3B6dERuMmhySzBWVXBm?=
 =?utf-8?B?aExKVWgxNUh4WWVxQ0pNcWlXUFdySkswV015S0ZEVWpCOXRZYWI5Z1RHL1lB?=
 =?utf-8?B?NDE3T2hwc05xdm5VcE5Zci9kYzNtQ2VpVXdoQTYveVZGdSsvdFltdVpEVlNh?=
 =?utf-8?B?NzdOeVVWdlBtV05PN3B2UVFQR1Z4YlB4WmRNL2I1TStYdkdhKzdVN2p6ZVBQ?=
 =?utf-8?B?RTE3OGxYTnpRNnBWdWxuVEhndjZPQmUvT2xSbm5ic2ppaHhpYUFsK2NQMWxa?=
 =?utf-8?B?MEUraThxUWRlRExkSUlrT1dWdUh6TlNFcUd6cVpjWDdRV2ptQnVpODRDcWdH?=
 =?utf-8?B?RjRLYkpMM0pjbDZpd2tKYUIrWlN4WXRNKzUvQzJXTTJIRGNhbkZQbW9ablM4?=
 =?utf-8?B?YWJPSXRyQ0xHRm9aRFQ1WnV1NEdFWElmdEpJYmxVaUFaY3gxMjV1VnA3RXQ1?=
 =?utf-8?B?OVBUQStMWDduRkhqRXdxcWt3SlRsZHFiN21tNElXYjJIbkhrdE9qd3JvU1Jo?=
 =?utf-8?B?Wjg2YVdDSThvWGdjcTZidmhQTWhpRnFuOHZ1aTUrUDR6V1g5TGJNYzZhQVVl?=
 =?utf-8?B?M1BMaDFCYUc4YWsyNTYzaGpsMC9LTVhteURFWUMyL2N1V3k1VnJhQzhoa1l1?=
 =?utf-8?B?K2ozOURZVWp2MnNZbkJ1akJjQStzS1ZjRDZMQmVTazY4RHkwU3BqY3pxN0Zh?=
 =?utf-8?B?KytLRGFjQW40d2wwaGVQcElFam4rb2U5QTNmM044ak5sS0NIRTVaYlRucXZi?=
 =?utf-8?B?T0I2TzJMWGY0WkZUMVZNVXdhK0xJbnRmSTZ3ZDVLOWhVTjJTdGVTNnQwdEth?=
 =?utf-8?B?Yk1QeXk5MmRFUUdEM2YyQ1YzbFhBT2lhdUZuZE14S3ExNTAwT3NsMGZYYkpQ?=
 =?utf-8?B?WTQrTmRHZXdBQjNXNWN0UmpGdlNOVVMycm43b2ljQzZJcFk2RnpQU1JNWDVE?=
 =?utf-8?B?RUloZVpGOXFqUXBnZFh0Z0twWTFidWJlQWJIUnU2eFBnSnRLUitZc29QOU4y?=
 =?utf-8?B?bVpQWUVrMGJXK1dxdUpTT1VMNWxLMjQxbTBvckZmSTE1bmFsTGYxVnNwd1BR?=
 =?utf-8?B?aUVZWlBDZXdMdGtETDVlTEFQQkY5WUMwaGhOU1RhVHVsQ2xXak9hcVd2QmRm?=
 =?utf-8?B?T0tjWExYd2p3VlNuV3dwUUJwN0ZtZmFpeTc5WTJkbDFNUms0Q1FaRVg0UVBj?=
 =?utf-8?B?aDFpTGlhWVRBWUxvVjZhK0ZkdjllZWJRTHg0MHpCekFiUklvOWdpdEl4Smxv?=
 =?utf-8?B?R2d0QSs2cXNwek5jejQ4QklaTkh5S01BQWNPbGtPUFJ0VEZiRFkzdkNaMXkw?=
 =?utf-8?B?aGEydUI0cHYzYjNtdUtoOVo5TGFNNTVHRkxTblNKUXFtN0MrRnBsK2VuT3hu?=
 =?utf-8?B?SzF4NGswTStjcFlVZzFRVHdEdEt4aWhWVGU1NDJpb3ZZbnNrbk5lenJPeEZN?=
 =?utf-8?B?YUU4ZDVybmxZWmdoSDR0ZjZNU0tBWUJ5RGJFckVTUlMvMG9HcDJzTXFJaGJW?=
 =?utf-8?B?ZmRqRWljUlR6a3ZIZ0NER0NnNzB5R0pvd2RzelYrb055VTlaTlFjVzFhaHFq?=
 =?utf-8?B?QXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a77af0a1-79b4-4eec-c7ff-08de08fe4258
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2025 19:42:06.2153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S0nZv+uhKbvzu38bGt4r/4YSlMQhHnRSzM5sOpq/IUYEHzYW9/kVbpyQlHObesDvBTHVt9nZLL1bLNBAs5ZQqCGarYcamA9KWM9xR4d+Up4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4681
X-OriginatorOrg: intel.com

Vendor-specific VFIO driver for Xe will implement VF migration.
Export everything that's needed for migration ops.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
---
 drivers/gpu/drm/xe/Makefile        |   2 +
 drivers/gpu/drm/xe/xe_sriov_vfio.c | 252 +++++++++++++++++++++++++++++
 include/drm/intel/xe_sriov_vfio.h  |  28 ++++
 3 files changed, 282 insertions(+)
 create mode 100644 drivers/gpu/drm/xe/xe_sriov_vfio.c
 create mode 100644 include/drm/intel/xe_sriov_vfio.h

diff --git a/drivers/gpu/drm/xe/Makefile b/drivers/gpu/drm/xe/Makefile
index e253d65366de4..a5c5afff42aa6 100644
--- a/drivers/gpu/drm/xe/Makefile
+++ b/drivers/gpu/drm/xe/Makefile
@@ -181,6 +181,8 @@ xe-$(CONFIG_PCI_IOV) += \
 	xe_sriov_pf_service.o \
 	xe_tile_sriov_pf_debugfs.o
 
+xe-$(CONFIG_XE_VFIO_PCI) += xe_sriov_vfio.o
+
 # include helpers for tests even when XE is built-in
 ifdef CONFIG_DRM_XE_KUNIT_TEST
 xe-y += tests/xe_kunit_helpers.o
diff --git a/drivers/gpu/drm/xe/xe_sriov_vfio.c b/drivers/gpu/drm/xe/xe_sriov_vfio.c
new file mode 100644
index 0000000000000..a510d1bde93f0
--- /dev/null
+++ b/drivers/gpu/drm/xe/xe_sriov_vfio.c
@@ -0,0 +1,252 @@
+// SPDX-License-Identifier: MIT
+/*
+ * Copyright © 2025 Intel Corporation
+ */
+
+#include <drm/intel/xe_sriov_vfio.h>
+
+#include "xe_pm.h"
+#include "xe_sriov.h"
+#include "xe_sriov_pf_control.h"
+#include "xe_sriov_pf_migration.h"
+#include "xe_sriov_pf_migration_data.h"
+
+/**
+ * xe_sriov_vfio_migration_supported() - Check if migration is supported.
+ * @pdev: PF PCI device
+ *
+ * Return: true if migration is supported, false otherwise.
+ */
+bool xe_sriov_vfio_migration_supported(struct pci_dev *pdev)
+{
+	struct xe_device *xe = pci_get_drvdata(pdev);
+
+	if (!IS_SRIOV_PF(xe))
+		return -ENODEV;
+
+	return xe_sriov_pf_migration_supported(xe);
+}
+EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_migration_supported, "xe-vfio-pci");
+
+/**
+ * xe_sriov_vfio_wait_flr_done - Wait for VF FLR completion.
+ * @pdev: PF PCI device
+ * @vfid: VF identifier
+ *
+ * This function will wait until VF FLR is processed by PF on all tiles (or
+ * until timeout occurs).
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_sriov_vfio_wait_flr_done(struct pci_dev *pdev, unsigned int vfid)
+{
+	struct xe_device *xe = pci_get_drvdata(pdev);
+
+	if (!IS_SRIOV_PF(xe))
+		return -ENODEV;
+
+	return xe_sriov_pf_control_wait_flr(xe, vfid);
+}
+EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_wait_flr_done, "xe-vfio-pci");
+
+/**
+ * xe_sriov_vfio_stop - Stop VF.
+ * @pdev: PF PCI device
+ * @vfid: VF identifier
+ *
+ * This function will pause VF on all tiles/GTs.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_sriov_vfio_stop(struct pci_dev *pdev, unsigned int vfid)
+{
+	struct xe_device *xe = pci_get_drvdata(pdev);
+	int ret;
+
+	if (!IS_SRIOV_PF(xe))
+		return -ENODEV;
+
+	xe_pm_runtime_get(xe);
+	ret = xe_sriov_pf_control_pause_vf(xe, vfid);
+	xe_pm_runtime_put(xe);
+
+	return ret;
+}
+EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_stop, "xe-vfio-pci");
+
+/**
+ * xe_sriov_vfio_run - Run VF.
+ * @pdev: PF PCI device
+ * @vfid: VF identifier
+ *
+ * This function will resume VF on all tiles.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_sriov_vfio_run(struct pci_dev *pdev, unsigned int vfid)
+{
+	struct xe_device *xe = pci_get_drvdata(pdev);
+	int ret;
+
+	if (!IS_SRIOV_PF(xe))
+		return -ENODEV;
+
+	xe_pm_runtime_get(xe);
+	ret = xe_sriov_pf_control_resume_vf(xe, vfid);
+	xe_pm_runtime_put(xe);
+
+	return ret;
+}
+EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_run, "xe-vfio-pci");
+
+/**
+ * xe_sriov_vfio_stop_copy_enter - Copy VF migration data from device (while stopped).
+ * @pdev: PF PCI device
+ * @vfid: VF identifier
+ *
+ * This function will save VF migration data on all tiles.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_sriov_vfio_stop_copy_enter(struct pci_dev *pdev, unsigned int vfid)
+{
+	struct xe_device *xe = pci_get_drvdata(pdev);
+	int ret;
+
+	if (!IS_SRIOV_PF(xe))
+		return -ENODEV;
+
+	xe_pm_runtime_get(xe);
+	ret = xe_sriov_pf_control_save_vf(xe, vfid);
+	xe_pm_runtime_put(xe);
+
+	return ret;
+}
+EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_stop_copy_enter, "xe-vfio-pci");
+
+/**
+ * xe_sriov_vfio_stop_copy_exit - Wait until VF migration data save is done.
+ * @pdev: PF PCI device
+ * @vfid: VF identifier
+ *
+ * This function will wait until VF migration data is saved on all tiles.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_sriov_vfio_stop_copy_exit(struct pci_dev *pdev, unsigned int vfid)
+{
+	struct xe_device *xe = pci_get_drvdata(pdev);
+	int ret;
+
+	if (!IS_SRIOV_PF(xe))
+		return -ENODEV;
+
+	xe_pm_runtime_get(xe);
+	ret = xe_sriov_pf_control_wait_save_vf(xe, vfid);
+	xe_pm_runtime_put(xe);
+
+	return ret;
+}
+EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_stop_copy_exit, "xe-vfio-pci");
+
+/**
+ * xe_sriov_vfio_resume_enter - Copy VF migration data to device (while stopped).
+ * @pdev: PF PCI device
+ * @vfid: VF identifier
+ *
+ * This function will restore VF migration data on all tiles.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_sriov_vfio_resume_enter(struct pci_dev *pdev, unsigned int vfid)
+{
+	struct xe_device *xe = pci_get_drvdata(pdev);
+	int ret;
+
+	if (!IS_SRIOV_PF(xe))
+		return -ENODEV;
+
+	xe_pm_runtime_get(xe);
+	ret = xe_sriov_pf_control_restore_vf(xe, vfid);
+	xe_pm_runtime_put(xe);
+
+	return ret;
+}
+EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_resume_enter, "xe-vfio-pci");
+
+/**
+ * xe_sriov_vfio_resume_exit - Wait until VF migration data is copied to the device.
+ * @pdev: PF PCI device
+ * @vfid: VF identifier
+ *
+ * This function will wait until VF migration data is restored on all tiles.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_sriov_vfio_resume_exit(struct pci_dev *pdev, unsigned int vfid)
+{
+	struct xe_device *xe = pci_get_drvdata(pdev);
+	int ret;
+
+	if (!IS_SRIOV_PF(xe))
+		return -ENODEV;
+
+	xe_pm_runtime_get(xe);
+	ret = xe_sriov_pf_control_wait_restore_vf(xe, vfid);
+	xe_pm_runtime_put(xe);
+
+	return ret;
+}
+EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_resume_exit, "xe-vfio-pci");
+
+/**
+ * xe_sriov_vfio_error - Move VF to error state.
+ * @pdev: PF PCI device
+ * @vfid: VF identifier
+ *
+ * This function will stop VF on all tiles.
+ * Reset is needed to move it out of error state.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_sriov_vfio_error(struct pci_dev *pdev, unsigned int vfid)
+{
+	struct xe_device *xe = pci_get_drvdata(pdev);
+	int ret;
+
+	if (!IS_SRIOV_PF(xe))
+		return -ENODEV;
+
+	xe_pm_runtime_get(xe);
+	ret = xe_sriov_pf_control_stop_vf(xe, vfid);
+	xe_pm_runtime_put(xe);
+
+	return ret;
+}
+EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_error, "xe-vfio-pci");
+
+ssize_t xe_sriov_vfio_data_read(struct pci_dev *pdev, unsigned int vfid,
+				char __user *buf, size_t len)
+{
+	struct xe_device *xe = pci_get_drvdata(pdev);
+
+	return xe_sriov_pf_migration_data_read(xe, vfid, buf, len);
+}
+EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_data_read, "xe-vfio-pci");
+
+ssize_t xe_sriov_vfio_data_write(struct pci_dev *pdev, unsigned int vfid,
+				 const char __user *buf, size_t len)
+{
+	struct xe_device *xe = pci_get_drvdata(pdev);
+
+	return xe_sriov_pf_migration_data_write(xe, vfid, buf, len);
+}
+EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_data_write, "xe-vfio-pci");
+
+ssize_t xe_sriov_vfio_stop_copy_size(struct pci_dev *pdev, unsigned int vfid)
+{
+	struct xe_device *xe = pci_get_drvdata(pdev);
+
+	return xe_sriov_pf_migration_size(xe, vfid);
+}
+EXPORT_SYMBOL_FOR_MODULES(xe_sriov_vfio_stop_copy_size, "xe-vfio-pci");
diff --git a/include/drm/intel/xe_sriov_vfio.h b/include/drm/intel/xe_sriov_vfio.h
new file mode 100644
index 0000000000000..24e272f84c0e6
--- /dev/null
+++ b/include/drm/intel/xe_sriov_vfio.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright © 2025 Intel Corporation
+ */
+
+#ifndef _XE_SRIOV_VFIO_H_
+#define _XE_SRIOV_VFIO_H_
+
+#include <linux/types.h>
+
+struct pci_dev;
+
+bool xe_sriov_vfio_migration_supported(struct pci_dev *pdev);
+int xe_sriov_vfio_wait_flr_done(struct pci_dev *pdev, unsigned int vfid);
+int xe_sriov_vfio_stop(struct pci_dev *pdev, unsigned int vfid);
+int xe_sriov_vfio_run(struct pci_dev *pdev, unsigned int vfid);
+int xe_sriov_vfio_stop_copy_enter(struct pci_dev *pdev, unsigned int vfid);
+int xe_sriov_vfio_stop_copy_exit(struct pci_dev *pdev, unsigned int vfid);
+int xe_sriov_vfio_resume_enter(struct pci_dev *pdev, unsigned int vfid);
+int xe_sriov_vfio_resume_exit(struct pci_dev *pdev, unsigned int vfid);
+int xe_sriov_vfio_error(struct pci_dev *pdev, unsigned int vfid);
+ssize_t xe_sriov_vfio_data_read(struct pci_dev *pdev, unsigned int vfid,
+				char __user *buf, size_t len);
+ssize_t xe_sriov_vfio_data_write(struct pci_dev *pdev, unsigned int vfid,
+				 const char __user *buf, size_t len);
+ssize_t xe_sriov_vfio_stop_copy_size(struct pci_dev *pdev, unsigned int vfid);
+
+#endif /* _XE_SRIOV_VFIO_H_ */
-- 
2.50.1


