Return-Path: <kvm+bounces-70011-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YCXaMSHngWl0LwMAu9opvQ
	(envelope-from <kvm+bounces-70011-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 13:16:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 43BD8D8E29
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 13:16:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 54BDB306F45B
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 12:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD6FA33F8D3;
	Tue,  3 Feb 2026 12:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fcdm58zN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D83033C53F;
	Tue,  3 Feb 2026 12:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770120984; cv=fail; b=g+WRkCxrNGsOetek0kwNNbfi/Jp7qfdEcj4D9Wij9PNngRqYthOUX3gs5eGNO4g3demaMxcqeQu8pZls2iK+K+ZCCF2fr6w4l3uGWqyt6iD/xhIW1d51LxaKaXsEYLofA+p34vD+1oAO/bS27tDBUmoNwUuuwltp63mbqkh2FYc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770120984; c=relaxed/simple;
	bh=CaZ+O1ADKT+htBMiLXEUV7RhkDsHDCkYHgVu/W2cYuM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gbPgFgo6LPFsCl7+/jgc80WzNuOCr09Iz27wbZ6FDXhR93wF/YB2FhTcKSsAgJUIXOkglBcyYk3raL6DmLq3bi6HCSz6UO08CbyGgHGINBYJkPWGyw55Ex5GGniED4Z+MGzfpLEQSnKY93SWtdVo3zNBaL4O92SM/l0pEJZpGD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fcdm58zN; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770120982; x=1801656982;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CaZ+O1ADKT+htBMiLXEUV7RhkDsHDCkYHgVu/W2cYuM=;
  b=Fcdm58zNVaMhWv7o92O4lGWStOvH3X9INcj+PGfV68ZaXYe6utKQga3V
   36NqWry85ZfchMDMBqazgjXorwwz3kXKZqa8maSr1NJCdZZ1o975AB3TL
   bbtyLblfwN7aD+j8Y4MPO+4eHOhlxjFvW8020EkSgyqoBaMvw0h0rw1yS
   tYEE9rSs022hy57ulYqkU/H6Jod/sTP1JtN4Y5WLFSME/aV5kvOxVGKYW
   hYFSA9NT+scxdrmqEiYBdx103qGWQpz+atO+N85PhOCw1INIelMzdgK5Y
   0k0oDOYmonY++0fNNdGISIdxU2My4zl81f8XQu2FJineHPGC0lsA5Zm9o
   A==;
X-CSE-ConnectionGUID: QUVATO4HTL6CKk4XeDKs/g==
X-CSE-MsgGUID: /DksCJoHSJyLfwNndv9Y4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="58869822"
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="58869822"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 04:16:22 -0800
X-CSE-ConnectionGUID: 1n5DL39SS0yREfKTgA9PQg==
X-CSE-MsgGUID: xd4khjzFRSycJBaX+eRwWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="209251259"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 04:16:21 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 04:16:21 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 04:16:20 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.16) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 04:16:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W5eUo88F0FEIG+2QvtcCgfeqMT8P7+ZGdT2ClnWAwI/ocqe7u4RtLW55SDHPVD/ybG5HsaleNIgzHRakgYqYLgWCD3unGk050hHeRuGklCnA5zNjlnWPN3d6lzgWQoP8OMkFfM2sgCGbRTrufg0V9oW4KmqmjjoxGln8DBlwpeHfoBpPibDCkIY1woowESKD8RbBF746vAwr33xRdvnQFPDCIszbVGxuBVvq1KxoXVlecFUltfRi6zPWf6Rr22HrPx79lLOyOb/m0Y1l4JnoF8oEp2Yz0DWn+kIh5dAAT3SghpRE4V9oiOf7huZnyOFqfFlrFVqxzAIjmuFAH//VoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LY9xJshPuEFJed4viQa07+4+5d8iLj0CMZoA+wFOsfc=;
 b=wpJCC2kDZN6yb0Gjo7sXCD8O6miUv2uqmr80jEYIOGuOaLtaCh/HhWVi4dVvqa5A+iiTewdCEL5mMlZgFQnTwZzVyOw9sN48dO2DNKIMcIKNA5tmKEV86ft/MNTK/BClv4f8qZDCgRWhRQw+1iOciN9R8cGIcA14iJaUv4T2nKHbFaEUKpKbSHUrUqIc/BOqcH7k345nO+l8+H92Ero4bvw6Q8mRUolpQFAdBU8gGDvx5ei3l149U6OrzexY+auTZ3gHW8zT/WvDyhPsOQfdskyOqGZbnwVoblqwAd4Q+NDVFXHF1TwUVZCSTEjjAN8KPOZPB+MmhnKbyRlJ0qcdUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB6718.namprd11.prod.outlook.com (2603:10b6:a03:477::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 12:16:12 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9564.014; Tue, 3 Feb 2026
 12:16:12 +0000
Date: Tue, 3 Feb 2026 20:15:57 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <reinette.chatre@intel.com>,
	<ira.weiny@intel.com>, <kai.huang@intel.com>, <dan.j.williams@intel.com>,
	<yilun.xu@linux.intel.com>, <sagis@google.com>, <vannapurve@google.com>,
	<paulmck@kernel.org>, <nik.borisov@suse.com>, <zhenzhong.duan@intel.com>,
	<seanjc@google.com>, <rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>, Farrah Chen
	<farrah.chen@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH v3 07/26] x86/virt/seamldr: Introduce a wrapper for
 P-SEAMLDR SEAMCALLs
Message-ID: <aYHmUCLRYL+JX1ga@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-8-chao.gao@intel.com>
 <301f8156-bafe-440a-8628-3bf8fae74464@intel.com>
 <aXywVcqbXodADg4a@intel.com>
 <fedb3192-e68c-423c-93b2-a4dc2f964148@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fedb3192-e68c-423c-93b2-a4dc2f964148@intel.com>
X-ClientProxiedBy: KL1PR01CA0031.apcprd01.prod.exchangelabs.com
 (2603:1096:820:1::19) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB6718:EE_
X-MS-Office365-Filtering-Correlation-Id: 89e437d8-9435-46e6-6fc4-08de631e050f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?cSDSo1aQ4xoosAI43qqOMK+n8/Kk9ldALaAq69+lokRXVVhZDkj8LJWcxrUp?=
 =?us-ascii?Q?j9Lzf3uMRofBv3Wif9gmYLjAdELUuWJyPXkufhgrHG2QydeacI9jbfS98c9I?=
 =?us-ascii?Q?yBuYpsx0k+8C9DFq9huEBbxZxUlNGX/Oetsj6uONP7VMYSgI26do0ICY6Wtw?=
 =?us-ascii?Q?zapj/mFp2s4e4g0KTOLjRs2+M+mTKWZxbTUZvb7djRq+1E68S1HOekaanmm0?=
 =?us-ascii?Q?LJvD+H5kMWa5CYR/oWkjWOuH9BwYYLA1KWWz+uTbmX7cNzdiDptszkBmqRQ6?=
 =?us-ascii?Q?rZERYdDVPO6sdJXSOl63vSgjoqTqJpl1395cDZ1pmvR/szSsXYUlAPxX67wR?=
 =?us-ascii?Q?fQXKIZaniMaC1sQhOAYhjzs891bxsqtALG1LVLYIw3knL+YMcr35jQAiTael?=
 =?us-ascii?Q?MHlhLNkJ+wx/hj6FJB9f6sWnk8r8/7RBJ57cAH4hR92vN9PcWDa+ddbdhCiC?=
 =?us-ascii?Q?kp+pprtUCnqykj212v+V36sQc7gbVi4CoH9djplzQqeiHlaSHBK/vIcyznPE?=
 =?us-ascii?Q?i+SpRkNQv8xfJkxMcpV/mAfip1BhE9Bx02/O1o/nFN2AUMeHQGyDEb23AfHI?=
 =?us-ascii?Q?BWzBzcs93lMWrSCIwIB4AbEGxET7FGJKZLHpdGGU/c3uPvbFEWdggu9w2YYu?=
 =?us-ascii?Q?gqlT+iOfCua1O2/3FqilDvRftzjkkls/AI/4AKx3tjUwYZwVvp1Abzj6/8lM?=
 =?us-ascii?Q?M2qjb49F0PwJVA4S05gdB7DKcTtQQv64juEB8Za0zD6lp22LzDbFbyd/3Auu?=
 =?us-ascii?Q?xHQv1VLlaf5pbgP/vwS7rKi0TBNhk1+m26mdteSeC5+AEAlmyiadOFfPm7Su?=
 =?us-ascii?Q?Oj9ymyRVkPjitGl6dTGNEIs9DuOFf5l4x2Nlv42bcpS12SDAHNLbD+GDK/tY?=
 =?us-ascii?Q?x23xr/h0O7YzQZdRH4z3TcfXuaFgLg4nayASJJtogP0YS6QULIx+ZbbGb7yY?=
 =?us-ascii?Q?IuOowpmtcBVkOjW2EuaClILfUo5b1e4iee6AE0ALT/7uTw6XHmEp+/WxUQvA?=
 =?us-ascii?Q?I66AV6xgU8DxT0LoC3Vx/tPzcnK0waJCHBsBUwRSEvdKNIRdu6Q4+QJGtWeT?=
 =?us-ascii?Q?vpZuvggEMwGkzVr75Y3o75UcdyixVXP3Hv0zqEeT2exodTgKVicg8+GFsM8q?=
 =?us-ascii?Q?iD8cvCReQOnUt2FwWfir+prQgHx8iil0gNG77XNxhj4vuANR6LhTsMeYssiU?=
 =?us-ascii?Q?KNmDdYAWR+2vC2xL2BDNRgXeWgt24payPewto1EEd5wtBL9Q4mfrgm4tdl3b?=
 =?us-ascii?Q?ApOVFTUnC+6iojj1EgFCF7DyY7J11r2FtDAkRArMyvYgeXHb/waGORp/M3Q2?=
 =?us-ascii?Q?YEml0LQM603TyksXgqknA3+liXOVy2SiRVRgJr2Rtin/mnA2bjSfcfXJKI7x?=
 =?us-ascii?Q?0YhUG8/i3v+Ot1N7gySpJA+h5IUyqL1U2WHYlQDwdEqZfgYkfYMzRVcQpLST?=
 =?us-ascii?Q?GH1HPVAPadL7CUG+PP/Zh2VYg10zsxHwxqsH181EX+mkQQyfy1VjWdYNkZja?=
 =?us-ascii?Q?XcP2Uw0stL2Xd+73/BblAUJXOw0IuCL4VfoTI2VfVDwgjavcVGArLYKU/66h?=
 =?us-ascii?Q?xis5mYicxxMvmY/tTnI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OF/ZRoBiCpozWONkK9EqwGrN++I/yCNxGVVXZClpzr2EfHhCF53idos4KVlH?=
 =?us-ascii?Q?/BH3c/J2tgBHK7ctu3bE+g4CQGayO/PVFj/RxJDL/jkeNTQYlTiUyoXz/jZT?=
 =?us-ascii?Q?JwL1zvJtE7SghgjPWrCkR0RPvrsLLVPv5pVa1BJ1mHCD7NM1juk1tyvtjDee?=
 =?us-ascii?Q?wzOo+meEQGs+x5tvx62WjCo/KxexUC7nceqGyjP3XOFkQU13GQzWS1ml1jZ9?=
 =?us-ascii?Q?m8Wq6VLu+hw76lkwvsNNmgE9kLa+exaKTLALoqEoBNKGf63+l2qWLIqqLDz3?=
 =?us-ascii?Q?85fY8jnsFmR1OJBM0pRsGxgoBaPEXi+drgF76ADaT0wwa9n+1xXO4Gkhzkdv?=
 =?us-ascii?Q?nK/PxSICZsL6B2BNVMRKwiUv/Vi6Wh6bjeqOU7NogEf4z5v+Iq/M1Mr9skGL?=
 =?us-ascii?Q?cTHC+VP7nXukhHi6f/71+e1YMJRelQ1gcKMi0vHzoWfbPJ5OhzApQRrkuNnQ?=
 =?us-ascii?Q?QHv7J6gTZYLT8dRhCveLMTjhLgRsjikU24SBEpF5vj/UUAOU+wcKmuw5IKMq?=
 =?us-ascii?Q?SKGwMFlrcNGl9C7l1YOhPG7HAFamZJ1HxAmPNIh2ysELL2xaNcWIwGqBZS4k?=
 =?us-ascii?Q?iwBs7lHNgPQvM89nB4IPKGEuKxaSezwyQA1qWFzik++KTrX41JVOT7c+a/iQ?=
 =?us-ascii?Q?pkMmEz76SqohQEM1iHDNfthYGi58+35MOG1mcTYK9jBwkleQcYaRuenswZBh?=
 =?us-ascii?Q?Tq3NBq8tLCpgHiUk41w/Zk4dBrYlxRCdrnTVHSxWPLjkkGlMll2qOtPnB9/C?=
 =?us-ascii?Q?4Ct5BeI0aY8xEgYFSN4jYj4aaTccifWv8/prglgTrUj6oBJUzrMjrS+lP0Z6?=
 =?us-ascii?Q?aieK5YhUegCQZyTBXVELRfWojnyll/3Xypm4JVn/y48Zgt3iCQETfT4aLIMJ?=
 =?us-ascii?Q?xdzQVXzo0UymiHPfl0Z/WJ7+7emVNITyq8ZEuhB4jPsuvoPnr2JyI8CIF617?=
 =?us-ascii?Q?PIVgtdrbC+ICoHbOkA41rhVXUFq0p4HT0vKFPhzAfz3D0irCDwbmEt2Tregq?=
 =?us-ascii?Q?XChLG2Hbe8WNcyJ8btGAGFjfTtuOZk7nxkVjs6pDk11pzsJgmTJ4biqa7gpN?=
 =?us-ascii?Q?JchywXK2N5iQ5YhOF9If2XFVZBglZG/dOujB4mgMFCeb0rp/y3Kl32LjOr0Z?=
 =?us-ascii?Q?FWa+geOth0vJCDrJWyOQOQ2oiPR1Yq18JEm0ipx/1ZEkzBrF9gwiwm+03IDX?=
 =?us-ascii?Q?sWkQbR8qaoQTFGA9KX4Za0EaZxNwxKVGOPvTnrj4GOzNx/Dbq2a8jn7jjq2x?=
 =?us-ascii?Q?BZEc48UFxy2BHK5r0iBoSYVUZZZAX/c/xlgxhoHDYtF5EEpjWGDlolIj5Kx3?=
 =?us-ascii?Q?krnttXhz3LN25MYg+Fpv1zjq/l6LqSqWI5R31SB1S31SkTcoE3rlkkofBnMS?=
 =?us-ascii?Q?67h3ALYPorilzAXdRbD29DlHtw9KdivO+pIfzW4MdvIiVzwsmXTnDQabQrES?=
 =?us-ascii?Q?x6B8cX/H2QAjJd3BySWL96KPkJ9bK+bXgZYpUv+gfZp3jLXqHNZKpBR6yqsd?=
 =?us-ascii?Q?yE5RGkAHvvjQrsgx6nolpNGF9zAQulVzNb30OiEVZUdQSCyRZKwXAIMgsYsb?=
 =?us-ascii?Q?eLKE+E4USom9Z6RgGabAc5J6+ysBq37DKIsCQU1n9jYFdbUZMGFfea7LrLpW?=
 =?us-ascii?Q?o5zz9LfF7EtN13OIyFXZrJyiHLtFvjYfNwjMUCeACy9HGcjLS3tO+9nsVNPU?=
 =?us-ascii?Q?sKXn7L93jG7HUn4bllVJ/ZOzMnMhCoqLuTBdMR84JHbCkmwnsXsM3c5umE8F?=
 =?us-ascii?Q?4ipmg6P8wg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 89e437d8-9435-46e6-6fc4-08de631e050f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 12:16:11.9995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pvzpt0xf35JT/MYfC/OlQRiWw5m5SMxabX0LdV4raYCgqKRdugXDsePOR7Jk3zmQkmafwfk/ucrMGGGK4XTf1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6718
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70011-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 43BD8D8E29
X-Rspamd-Action: no action

>>> I'd be shocked if this is the one and only place in the whole kernel
>>> that can unceremoniously zap VMX state.
>>>
>>> I'd *bet* that you don't really need to do the vmptrld and that KVM can
>>> figure it out because it can vmptrld on demand anyway. Something along
>>> the lines of:
>>>
>>> 	local_irq_disable();
>>> 	list_for_each(handwaving...)
>>> 		vmcs_clear();
>>> 	ret = seamldr_prerr(fn, args);
>>> 	local_irq_enable();	
>>>
>>> Basically, zap this CPU's vmcs state and then make KVM reload it at some
>>> later time.
>> 
>> The idea is feasible. But just calling vmcs_clear() won't work. We need to
>> reset all the tracking state associated with each VMCS. We should call
>> vmclear_local_loaded_vmcss() instead, similar to what's done before VMXOFF.
>> 
>>>
>>> I'm sure Sean and Paolo will tell me if I'm crazy.
>> 
>> To me, this approach needs more work since we need to either move 
>> vmclear_local_loaded_vmcss() to the kernel or allow KVM to register a callback.
>> 
>> I don't think it's as straightforward as just doing the save/restore.
>
>Could you please just do me a favor and spend 20 minutes to see what
>this looks like in practice and if the KVM folks hate it?

Sure. KVM tracks the current VMCS and only executes vmptrld for a new VMCS if
it differs from the current one. See arch/x86/kvm/vmx/vmx.c::vmx_vcpu_load_vmcs()

	prev = per_cpu(current_vmcs, cpu);
	if (prev != vmx->loaded_vmcs->vmcs) {
		per_cpu(current_vmcs, cpu) = vmx->loaded_vmcs->vmcs;
		vmcs_load(vmx->loaded_vmcs->vmcs);
	}

By resetting current_vmcs to NULL during P-SEAMLDR calls, KVM is forced to do a
vmptrld on the next VMCS load. So, we can implement seamldr_call() as:

static int seamldr_call(u64 fn, struct tdx_module_args *args)
{
	int ret;

	WARN_ON_ONCE(!is_seamldr_call(fn));

	/*
	 * Serialize P-SEAMLDR calls since only a single CPU is allowed to
	 * interact with P-SEAMLDR at a time.
	 *
	 * P-SEAMLDR calls invalidate the current VMCS. Exclude KVM access to
	 * the VMCS by disabling interrupts. This is not safe against VMCS use
	 * in NMIs, but there are none of those today.
	 *
	 * Set the per-CPU current_vmcs cache to NULL to force KVM to reload
	 * the VMCS.
	 */
	guard(raw_spinlock_irqsave)(&seamldr_lock);
	ret = seamcall_prerr(fn, args);
	this_cpu_write(current_vmcs, NULL);

	return ret;
}

This requires moving the per-CPU current_vmcs from KVM to the kernel, which
should be trivial with Sean's VMXON series.

And I tested this. Without this_cpu_write(), vmread/vmwrite errors occur after
TDX Module updates. But with it, no errors.

