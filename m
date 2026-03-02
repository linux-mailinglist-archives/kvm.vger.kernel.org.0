Return-Path: <kvm+bounces-72362-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gBPlHbiBpWl1CgYAu9opvQ
	(envelope-from <kvm+bounces-72362-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 13:25:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AC531D8455
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 13:25:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B85E4301BDE6
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 12:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2315A36C9DE;
	Mon,  2 Mar 2026 12:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PF487MB9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF5B36C9E1;
	Mon,  2 Mar 2026 12:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772454317; cv=fail; b=FYETT0V/Ruu6ORNioJoUcQDR4+eBVk85//rlEi+9Wt10Di83PoxJFbQLgdSc9qjv+m9xcjUXx6JlO4LEn0P5FbU/JOx3kRNsZEgeaJOSUwRFF5jXLoR8nUUCML5uA+0dzKQaaQQDEntA1cx0YB6Ai/4TgTYTR6WDPR/N3/N5xqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772454317; c=relaxed/simple;
	bh=85Ah1MRj4jO1nNJoakwdW82JD4qpNlj+vxPBYq1vMJY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cDcEKXcXl9yBOP9rZODzmzbcKNLcZQ5bXGMQZca2RuKwuUxtPr4L4XVbzupri9DLFP8xSxYswDcGIFXYoP4cHWozKwXNXuFr1NsFlubto7kIwRTOxr423XK5X/piN1H/4G+e0zlGeh9/5H4OPMrgCBmSdpMoynGXMebZAMqgZNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PF487MB9; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772454315; x=1803990315;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=85Ah1MRj4jO1nNJoakwdW82JD4qpNlj+vxPBYq1vMJY=;
  b=PF487MB90SbAESa27CTHhenA4xRdJxszoN/fc6HWD8cXB+ZylQGG6u1I
   CNWM1RN7x6vlMTp413QdJOm8+lf8P8KjQpQEaX3G8ejablLnKA8Cyf0lO
   WB3CJ7M3GF5h9pbJDdYDna1jMUg4aJBPD1GIoPbqGOFt2L71KiYNdKqjd
   MN9wQ/bazEroaYgaZNQnplOeRWxtS78JlOoAmifN2GpMtWzjH4o2/brBW
   kK2J/U6yMiFWlyalp2BZBGg4+a8GDKv5RzGW3g9yysQ3ZTE6GW4e1pfAH
   Lef+G0Mh02rA0+OhYk8cPIUx2tYk0hP3oxNsdgC2pLJixZP5cr+Ho375f
   w==;
X-CSE-ConnectionGUID: evh6yFItRTqxHKo7JC5TDg==
X-CSE-MsgGUID: R6q61bmUQ2K3LD1xhhSy8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11716"; a="77071492"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="77071492"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 04:25:15 -0800
X-CSE-ConnectionGUID: srPpvAiOQzG9jx4VDFfkPA==
X-CSE-MsgGUID: i3FLuSXTT/Gs5i7djQWSSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="216861405"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 04:25:15 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 2 Mar 2026 04:25:14 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 2 Mar 2026 04:25:14 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.43) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 2 Mar 2026 04:25:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xQCTNFPPqjt+ybvLyG4RvLdECmE5+IOuTx5Ln3w8nTYyv8n7gpnuZ+dRF0vCd8HqvaBNMZABJ/HagsAYmWfWFyb+ixjOhCargfrEMFc4N3uaPVUNydy3kEjK83ymhLQ/9bS9QGFl+2hACRzHloA1Mb9i5TIEh+vksA4tMchpN6/4Z7UZ5gGt/4xDfI9rye4b+u6BmIjhj702DEXZwz6vTji8xyYJbKJOB7/hw05mJkEb4x/y2nMKHuO36DpIcLcZQA8sdpSMrxTPg7n/y8w3zowrJCB0w22LU8vc6AlpW42EoeVO0Ji8Wil2WwMKlXK28ZU7ZVJQoVRqrmwkMfkDjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d/10TWMD3jWVEr5yGo1wv/W00zaiPqRLuWaDGALjGZ0=;
 b=v/w/wMWYDPevnURZA6rj1eQuYMl/pZc8ptuLCSEI0np2UGHFY2/cExtlbjSUKRMxgQtq0jH9loPdyVyjoxRJuCHNTtQy2/3toEBa5ZK6wL+NQE1laxnNZ0INl80YA0UCGSkg2t7EiUfsvq1cQ7ShTL1YnMFyyknCW1oMMD9JlULR+HJRsBvVwjovnd4ButJ0f8A2RzjgURKQqT8an+zJADL6DZfWmTUaDvofEgOMahHWhrfQg+spJtldDAOePn9pXRz0Ko1xm6s/BCp4me87phcHDltsxnJCjFsabzwclZwJuqVMaCIrromO6tqzaStLJ6Mir4uRWLz/rcwzhpLT6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ5PPFE5BD61D44.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::85a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Mon, 2 Mar
 2026 12:25:08 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 12:25:08 +0000
Date: Mon, 2 Mar 2026 20:24:53 +0800
From: Chao Gao <chao.gao@intel.com>
To: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>
CC: <reinette.chatre@intel.com>, <ira.weiny@intel.com>, <kai.huang@intel.com>,
	<dan.j.williams@intel.com>, <yilun.xu@linux.intel.com>, <sagis@google.com>,
	<vannapurve@google.com>, <paulmck@kernel.org>, <nik.borisov@suse.com>,
	<zhenzhong.duan@intel.com>, <seanjc@google.com>,
	<rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>,
	<binbin.wu@linux.intel.com>, <tony.lindgren@linux.intel.com>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v4 01/24] x86/virt/tdx: Move low level SEAMCALL helpers
 out of <asm/tdx.h>
Message-ID: <aaWBlUPLMYAODVtd@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-2-chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260212143606.534586-2-chao.gao@intel.com>
X-ClientProxiedBy: KU0P306CA0088.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:22::17) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ5PPFE5BD61D44:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b978dd4-dfc7-40a5-8b62-08de7856be01
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: zx0lR5D4pnZEZmNMLibWUu0nk28JC4p2isFSTXJfoLuXzjXR6j0oAtCS/MQxOb61yEZBHxoTaU0gQYlolykdRKng2LSluskHNRNltHgli/3O6AZYGl/FqvERwjSYAOI9YZIkzSn45XVduKsFhd3acbOWJhP5SD8i0E69w2qbBVJ/yAwdW7OgjlgT2DwGwPPAz4UpeJnzX7Q68BCpzXblGUBMIsIX3LT60GUE19SttspqDSr1v0DIXhpgRGsDJRPLSEUQrAUtLEnBJRrnaz5svaYqf43ucRQcazaHd/mnFpGy+lw+aUmNrziqjFdHrVy1w0ZsDNFAQ+NG+GgCVW7MbriS/HUpSdxyo9roIIpeEmPWYITCIgXdUvph3DE1puMHuvtXYrQBfGMc2uUELRDUFBFt0FQl2rSjJJc1A3MSSpNI7tcTwyt31TYWr2KqyFY43j/WmxzC64RLDrfW+VCLjHGe7lYKlfwhaQNVeKUY22b/HnCqzjll68aloVHXwluRwj66yt4ZG3kjxjjpD5XdNvaS6HOohXrtFuvdexUISaVs4hkJHPgH0LnBtsChmu46auuRcL8OmcSTkwFgVQqary14ZgKmu9tJtTlFZJ4qpxeZ4lloDmb3d8cMC8cWlDakZcUpU16LRfFQPtm93GWsBuiMMsi+oaFkL+LMhWwoIeGhZTt3iSs7xCYY1JTuYHL2ZY334Dzr2pWnUFOmluWJcDtY8he0/D7eqGnMjgModsQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N1s73h44mmxJh/0PJnAT+LjWn8ZcpSdcTQO3Lmuy8EeGiGcViMdGP3AjcnTk?=
 =?us-ascii?Q?L4XqpbzlE1r3vJ00xPdWHYEcXrVT4a61IukkLCCbvoFvV618krNqpLwip2cu?=
 =?us-ascii?Q?NEUdE9zsPdLZ+G7m7tWketo+dWN7x040BToWxPGu2vZ5BI7C+dA2zST/HBSX?=
 =?us-ascii?Q?8CDg9ytScXLDn2t63naJhNCEfjBRo/TTJUQszpqW3OBpf0HmRlTy93ON8d1D?=
 =?us-ascii?Q?84M1bjXItp93s3dQlxitlrn/YcKf+28S1m/CbR87ywIi1rOF5iWDf2cTXfs6?=
 =?us-ascii?Q?DWeQBNXlE2cmnvRLeFaCzHpGpYHLJRoepTG01mwwcbzgbcnsGpP3APl+CWpm?=
 =?us-ascii?Q?Pmu5W97U03RyyN7xlrPxr1q4egBqyTJgf9C0rtUxiYqA+4jb8j0tWe1Z8CKu?=
 =?us-ascii?Q?GXCnT3R6+fcixqn8pPOIdb93gofQKU74YO+SfS6ybZYWNrV+BqPfLS1c7Nsi?=
 =?us-ascii?Q?HxEfDY/AeUvy2sFd60MM08lLm6pAldt3wbfEFHLarVcNGv4Q2yH6LfLfpXE8?=
 =?us-ascii?Q?ljqF5+amX4rqBDplQQvMusNvlAsqQqA22kxkjwdTNwrp0VOX2YD63Fsg942k?=
 =?us-ascii?Q?i8nBiw4DqVBhtJ0GsKRZkLrGXRCR0hacgBFq7EsGyxyWh2EPGQVkAA+NtL40?=
 =?us-ascii?Q?YqQyj2HcpugowJZkPuhsg2AHr+S91lDQ2jXHgp8tv3zvtoeVNqwmIOrtFP/g?=
 =?us-ascii?Q?eDIyjjpWVKYqOF2F0jkeO7tijCM1qLRNwgeCT8nJ1gA1ALs9HVWHAPv0dFjL?=
 =?us-ascii?Q?gA0wnQHaMoL1JR1rtatV85U8BlguMIteHC80maUnz9wv/Wjk+C83scqdU9Y8?=
 =?us-ascii?Q?b958TOU6kiyVQZnjT21a3bhK+1rxrD+6+WiAlaU3hdp82WnGi9vhP0/BNLKI?=
 =?us-ascii?Q?KZle4I12ps6MatD6xFmLZ7awt5kEKpgpRdmGaIqM+uD0YPArUS9nHSvCjJcm?=
 =?us-ascii?Q?v8iNUIGxFm0yo7QccvRnfCVnw05KEMgUJifTeg5CydFkZaHvU8akb7VURfFK?=
 =?us-ascii?Q?WMpM6bJIuZvXcckz+kGNcFK1CmeP/d3G5D9T4y43IomSJzZPNo9z0GT6/ChZ?=
 =?us-ascii?Q?ffHE8rTlU6V/s2aV7JjpqrcSOSdSd09+fqWZOzhRDXkPsfVVro5NFKrDVNUh?=
 =?us-ascii?Q?7BH9lMB6afO07+e7ohXuV+ozuVFxkinaVRYPPuMvw4bCnCHwqi3gO+wxM4s0?=
 =?us-ascii?Q?CyjADUTZCDivXBVFigA5JH9m86PEFgxzWv9ENdC9O0IqofjosQE9mxijg9jP?=
 =?us-ascii?Q?ZLDuakn1ZsKOJGkUv0DIXJIL1BAKbmnErcbIybIW6yNSujFly3GGjl8w2B0x?=
 =?us-ascii?Q?+GClR6fW9jeRFtsKjU0cOnFLKuMNtCs5QFnfjyRlZ/XNCiUxnTqYnfgH7PVC?=
 =?us-ascii?Q?QIn7APt7oKz7fHXx3BoAMsn10NjYePlGSPP7nnW4m+cEPRv7ZGu+zRvmPdwK?=
 =?us-ascii?Q?Us+R2EJ1HMo8MBFBtIGPP92+Hne2QCm+M7XGmen7I1IBH0fWu/DrxquHdGea?=
 =?us-ascii?Q?ButyHlUsm1xfsQ5JxFJUwQUVkbODz9fm2j30Pn/6d4Ep09DgdVV6Wpqzkk8i?=
 =?us-ascii?Q?HkcryvcqqKvg5EOXna2Hs4yqfu0gJg0MbzoaJTqgsCVm06/zOdwSKujhUb2i?=
 =?us-ascii?Q?9q9DifXoL1JR/tRbdLuWZh4gNu+x+AipmpllBUS7VwBeSdULty2okIIP/uCG?=
 =?us-ascii?Q?oidJ6tCslhRUmrGK46SM6/km370719+up6ZLMfYmxLrZNcyp2RwVQhGLa/Eq?=
 =?us-ascii?Q?SqIU1zCt/g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b978dd4-dfc7-40a5-8b62-08de7856be01
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 12:25:08.6955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KKezsik9pSfwjESAj5PBB4I2tRxhKM94utdgL+hNFtF14EjhsGL03ohu5OA2PNddt56eevLfruvMCc25Vl4Kcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFE5BD61D44
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
	TAGGED_FROM(0.00)[bounces-72362-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 1AC531D8455
X-Rspamd-Action: no action

>-static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
>-			   struct tdx_module_args *args)
>-{
>-	int retry = RDRAND_RETRY_LOOPS;
>-	u64 ret;
>-
>-	do {
>-		preempt_disable();
>-		ret = __seamcall_dirty_cache(func, fn, args);
>-		preempt_enable();

...

>-	} while (ret == TDX_RND_NO_ENTROPY && --retry);
>-
>-	return ret;
>-}
>-

<snip>

>+
>+static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
>+			   struct tdx_module_args *args)
>+{
>+	int retry = RDRAND_RETRY_LOOPS;
>+	u64 ret;
>+
>+	do {
>+		ret = func(fn, args);

Here should be:

		preempt_disable();
		ret = __seamcall_dirty_cache(func, fn, args);
		preempt_enable();

This looks like a bug I introduced when resolving conflicts with

  commit 10df8607bf1a ("x86/virt/tdx: Mark memory cache state incoherent when making SEAMCALL")

Sorry for this issue. I will fix it in the next version.


>+	} while (ret == TDX_RND_NO_ENTROPY && --retry);
>+
>+	return ret;
>+}

