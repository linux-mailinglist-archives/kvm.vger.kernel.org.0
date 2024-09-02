Return-Path: <kvm+bounces-25677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E7F09686AA
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 13:51:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9D16280D59
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 11:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18CB21DAC45;
	Mon,  2 Sep 2024 11:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K5PShlph"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F291D6C73;
	Mon,  2 Sep 2024 11:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725277838; cv=fail; b=W8DtVeyIGfwQwYlSemKdkF3nt1LEozhQaWVtvIKIyDEgbN9Er7YDxX8fb36+9JdTaU85CVtJvOVMeWSpCtVBi80jlpVNwKCOCvtpAXpPCmfpVMx2j66sx6kVhysX2SKhIr8xnTcd7gCV8+YzwR/GE0BeM+rc1M2QPd3LgWUdD8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725277838; c=relaxed/simple;
	bh=086+IORfVf2ntpyJzISaBde55lpZpdTty8XaVN1N8fM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qa4ndSoaWOMz1iyMcZbrSXFcj+XX4suaUZSnveaYxavIRlyZfRVi7dYo5+5T0HW5InRyZNHLD/HKj+0zoscKdPnPdcCns7Oh8nt+qPrh7Z3DRMR9Kkw5EyJl6H6OSNXa8jRaKsL9X0YKVH9mvYvZE5WIEwGvJ6ToVM1IYdJCVLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K5PShlph; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725277837; x=1756813837;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=086+IORfVf2ntpyJzISaBde55lpZpdTty8XaVN1N8fM=;
  b=K5PShlpht15c136Jb8ZJCbu+R1ytu4EOcLHA3sWN4vr3LKRARVBh1TGI
   pQlRZ3vjRNiLHVR93BR3hW/Rm/ITUiQblP5kYDB5h52pSvKD7z2CsSjnu
   aza6dnyvWaX9Vdt1ZW+rF5jxgjKZT1VLixBT0DsPbcvtYqTjBA2lRW4zT
   /gZJprRToAHmxE70LqnbQ9+JbNNa0T2FYpiEUxr2y6eIWD4dQDrzjzxk4
   wfOLmigMWP3kpRAK+wqGqtYsWvaiYmS6BTBHjkpWU+7916GREWEWqB5A2
   5MPV9+8dkEi4LLhZMXFU0YVuLG28Eu2QiqKHY9hASwaqWD0ocCMEmtE8X
   A==;
X-CSE-ConnectionGUID: f9WfM71sSPqfI4DMRrHOZA==
X-CSE-MsgGUID: lJXhqV+OQXiA017c58L0Xg==
X-IronPort-AV: E=McAfee;i="6700,10204,11182"; a="26757479"
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="26757479"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 04:46:53 -0700
X-CSE-ConnectionGUID: zpC54r2ZTGinIQGUHi1aNw==
X-CSE-MsgGUID: etvoLuyUSbWNVRsmoyGpwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="102041697"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Sep 2024 04:45:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 2 Sep 2024 04:45:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 2 Sep 2024 04:45:29 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 2 Sep 2024 04:45:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pbhc817ba1/iVYlMsgxbx4dcQ4It4HrDSERJ1slskhlpSQipPgflNCGxxORZ6o9w/cLH3DQ47+nrz33HjB0IJD+jl2bHfXQIZrOv6nPacue2y6kXrNTTkRzUDGnvpmjlu3hZQsGIggg8fYxAQ2zjHUJPF5auPMTqsFcrzQ9jqY+/gWRDCMa2+IM1nQ1rbv9bIDpD51CZ6RBQXFi+6OL5qVi9LhbfES9/2QzROAOXcncIs8/JsEcmPfDD/pbQTrCGJKykWtLW209oWxGqTKGE0jI21PccQS1NArZ15AkpcIIIquMaJGEpwVXv/rd4OTablA4XqqAKg3K+4G4ljWQYoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s13z4HloHNClW+VPgclbI8//IBkeKykLz8SU8/0QX6Y=;
 b=a1ad3bbMDfMibWAlBOWtrt1zp9ETcIyWmiKLEt8WUUBWzW9anIhWFLNYNlvWy8Zx8IS6eLikS2enPWmq0OY79LXf4XUNFKVb27qwiF21EQAmR9gvRT3esyBd1ykgk6cmS1x/gxD7a37eexUKKIOQ4FrSaianN0rnaidFCr+I2h5obyCX9G3QFbRpA7XVIwK+TAtuhAerN7P179wWS3JCcx0jd0BglQbotHhbuQ9PWHqHXcg/6fvZS1HNrX01Zy6CXXDrpMkRFqt3/Ky8ZvC+MZkbHx0OeUXgctBeKvKarqz4L7B2Q23G0NVP8jLz9YDjb2DMRV+7cWFPx+O2v8ZzXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7850.namprd11.prod.outlook.com (2603:10b6:8:fe::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.25; Mon, 2 Sep 2024 08:00:35 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.7918.024; Mon, 2 Sep 2024
 08:00:35 +0000
Date: Mon, 2 Sep 2024 15:58:38 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Peter Xu <peterx@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, Gavin Shan
	<gshan@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
	<x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	"Alistair Popple" <apopple@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Sean Christopherson
	<seanjc@google.com>, Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe
	<jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>, Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>, David Hildenbrand
	<david@redhat.com>, Will Deacon <will@kernel.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>, Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 07/19] mm/fork: Accept huge pfnmap entries
Message-ID: <ZtVwLntpS0eJubFq@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-8-peterx@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240826204353.2228736-8-peterx@redhat.com>
X-ClientProxiedBy: SI2PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:196::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7850:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a7de561-92c8-4c91-50ab-08dccb255328
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?73lMykghlxJ6MFDlnPkUXqL173GQEL+ZroL7qikObxf3lxPuK0HF23zFNhzw?=
 =?us-ascii?Q?eGf3z5DvdLPJZXwSPi7er7M5o+n/9Sup4tTSE0LII88oXBOg80MN4n0o9+D2?=
 =?us-ascii?Q?K5LVPtWDJoYOxK8HcXTpZjlcUupJLucfg9atLWkdAF4parUQxQPNlUMGhoVc?=
 =?us-ascii?Q?ngmGEaIgSy5PsLrUsYI8cbJgGFuOnfIh5BcEf0nPp8qWd6IRwtXfu2+S4sJX?=
 =?us-ascii?Q?pRnK9RsrgZyR9x4MPnc48h0d7SOfq/4rAJWo7fdYxKmHnmZNgDDYAMEtgQxe?=
 =?us-ascii?Q?DqEDkX+cXnT6cJ0XtVbNTpECefAxS1F/zChIAh6pke8SXJMHUdQGbZOKsQCJ?=
 =?us-ascii?Q?IBCrHvQTBpWlX9rWa/au81/4Oj6pO0VLIUJCExsVsrsADxy9Ak8qC7YN3Mbh?=
 =?us-ascii?Q?fepNzselJVAPrjmiqpN2MQ9euEoR2QTRwBK2IckX10L/EhzAhu8ys+2HCRlO?=
 =?us-ascii?Q?5adR1JPz0o4q49g3tV2qdkEQ3g4TraUfBdo4Ak0RKLl2u+BNcurBv3Gjl9Uy?=
 =?us-ascii?Q?HJELGbZcwatXuFIC0cqGsEvJA1WeM38dECEzswqA+nChWomBU2Mrk9A4ckd1?=
 =?us-ascii?Q?E+v+CQkMEgZ/2rgIQr/PuDKtv7+0SPL+y2Vmk3fWx4PHEzxQXJafG90zrQM5?=
 =?us-ascii?Q?vMhGBkbdqofpNN/mMTXtwtCmTUbUgV5ohuQ3nu/OQDfaO5w2dzElGEtiiZKR?=
 =?us-ascii?Q?LP5IzYPe17LN76s3SypJ5ChlR85t5TB8Op/YpasgtdAIuFLL/xq9a1vOo+Wg?=
 =?us-ascii?Q?fY36xy+C0YZOMSMiY0mdZyjWo8TrFoMTbxvyUU4JHJsuHcJLK+eL4O5J3aAy?=
 =?us-ascii?Q?Nl4A4+4K1Du5OOhdPFRFnKg5FZXySNadzUpWy9hFlceQuuAYXX9UHFnCnkt/?=
 =?us-ascii?Q?rzkj+nlYQSA5KSfNKjWmm292D1dZ0nJUgbcX7OXK/psI2b9KZgcpEEcrs866?=
 =?us-ascii?Q?cWyb42Lc+eeR5LHMV6ezEUiaHLcEFUQdDzOqB/lfg/xGSkkFmxfK29u7I9Nx?=
 =?us-ascii?Q?mTQhudxSGQgzhgS5+tt4ZeqPOYyyxzyWe6ErshhkL9likzTXGerBHEMBKpoa?=
 =?us-ascii?Q?D0UmgimOwku0ER5ZdUgiV3hq/ERL6OfOdHLA4QwLQCZGmaQu4H1TBr3KeJNT?=
 =?us-ascii?Q?M4u8EwSe+x7Tw7RhPDW6f99UlkRXKicZNroIL+ff9W5EDyTcW8q1kf0W1zF8?=
 =?us-ascii?Q?dKoE7f5SX1JufjdiWWoQ/lR2vU/GFifJ61leeVtep4/hYVsdJN4R+p97M7es?=
 =?us-ascii?Q?Js2Ajm9HEEQ1Z9GdrI8/x5SrRtzYmRUvGPXOemXBJhxvtDlIZTj+rZzn++cZ?=
 =?us-ascii?Q?6+hu7hcuzMZ3fS+bnf79Fb/vGIDfgE5soE6mPXyTRK9PxQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xCriXZ67mrnh4yq1KdYVW2hSDIMpCJ0PBglhqKu3JrmcQlujBp3qHmbd9CwL?=
 =?us-ascii?Q?1Cp8S/RYrHFBCKIdrsrOCVc9ggi3Oz8eEuo3aq+8aTG5abGPCBNzL3isL4TK?=
 =?us-ascii?Q?HsoZ7aqtf+0IBKxYMaMQ9fw0OxALFH+JbDQbPr1gFLc4R+j0M5Lxi3Zto10M?=
 =?us-ascii?Q?NRhQYC+JKBm50l2wNdw03WMFTolG/V8zbFBfnRNcrrIB0vmQ1TcFZrLO/2HJ?=
 =?us-ascii?Q?XYbLvfGW3t/Vr4aAlzv7fsUKk+mDMrqmRMukbpyt0iKXpVmNSqu7EAl2TmHh?=
 =?us-ascii?Q?B6PT2rBXbLIv631ckpPrv7Evy6yVraRofVjLzuBzER4JsgKnBzukBicQj765?=
 =?us-ascii?Q?+UCHutkGbQSnsKOBGe5P+HXCuat1LZcBjpYrcgeh8LcjpQdgE0OAEy2Iwebv?=
 =?us-ascii?Q?/aa33nvxXwTRxSyqtjwCRCRJkDl3JX/09VUhxcxMOgeTboCTuxl+SnCJOPuC?=
 =?us-ascii?Q?h8qastY3+Nn9viiubJ3m7LyGyNCzZ54dI87Y0OS3vLdRPdBclhWihB+JhSJJ?=
 =?us-ascii?Q?v0oRrb5oTRjmdE4xYUGRv/gzFpBlwGKayessfIbqrQ4QPOnLZxjSxYVrfYBG?=
 =?us-ascii?Q?b4UBoxh9qt+5PD+9A+hF4rTyACTeoB3anFu78NrLx7DCdVk89RlpaBQV7RLX?=
 =?us-ascii?Q?uIjEcyl4DPqJ54iHnWEUm4yEwRoWNi4eSYaY10mQrp8iNHA8v9FkzBStwg2/?=
 =?us-ascii?Q?+di9ppRhsxlxugkHe8dQxalklE9G+ccigID3tT75FsnMhIMSC1ok3xqeOi8p?=
 =?us-ascii?Q?wNlqjo4phLBQuDByhBoqNL+tQKLunZjJP7d/6MT0Pl3tPR3i/4e/+RWeVzX8?=
 =?us-ascii?Q?Vo+UgwqiQaeTV8wxtY/eBlEuYlB2YujpP2YfDLSlG99nj7e+QQegOx2cf9HT?=
 =?us-ascii?Q?ddvKKgfM4Oo127+aLV8ORoHWrT7E2thdC4K5brX1TECySADG31s+1cW832JS?=
 =?us-ascii?Q?jZybiA7rbJCxOXiuhspzgQ/j+X/cPunEhKxrfn8bA9HtEB2T8Uvwf5QE2eHz?=
 =?us-ascii?Q?4pIOzANdzEL6ExFM985wOg7GhAe8yUXEf+FKjX3C3XzlSjRDhWgPqHLK/7qA?=
 =?us-ascii?Q?WzmAFcPAk18ia4YxhfzU3b97QLZIZ1WJ5t3lMMf0Ijg3OkSW4OQCA/oho9Sw?=
 =?us-ascii?Q?IIXK3KTcgVQ+UNuKK+So39lAyoX1GzwRuLN8+guWaS2fOGxoYCLdulhj+bl2?=
 =?us-ascii?Q?o+YxozPjls3+8VesedNvjIZWjl/w4HHfvNUgxEGoS0a0azLvcBV9JNFTs6j5?=
 =?us-ascii?Q?opeL5HsOWqeJX8FXPFTYmZRtsccKWc/D3WWVYn667TpgAzCoc5VkdSjD1iwX?=
 =?us-ascii?Q?8QY3h2uFrhQe30ta9YNR6t48dkK3L6XPm+B103K/NDaQrPizyEYh2SBwVxqi?=
 =?us-ascii?Q?el66aFlzpt/Di1lbmhCB5nF5XVnOdoJul2bC02z1VGwLNG9X5IVshtxHpLHv?=
 =?us-ascii?Q?C3KMgSf/WU6PO7T/oifCT81GLY6UCGK+bYOsDt1g+P2Okj0iH89NoR8pqTUF?=
 =?us-ascii?Q?h9v00nEhIBmJjWvUC1G74YIveOc62NE4OxnOisxrVToORsgcPOwZDORvwVQJ?=
 =?us-ascii?Q?lSe1iKwG6fBgSPNuDE8tClK23R4cen0uol36GYjY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a7de561-92c8-4c91-50ab-08dccb255328
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 08:00:35.0713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gMHCbS/yHbDrrpwK8vZYhYBKZSXJTNySNgbSbn52i0h5iJGTGQbxNm6pLVwTPscqP2926BthlI2qikdjMr6B7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7850
X-OriginatorOrg: intel.com

On Mon, Aug 26, 2024 at 04:43:41PM -0400, Peter Xu wrote:
> Teach the fork code to properly copy pfnmaps for pmd/pud levels.  Pud is
> much easier, the write bit needs to be persisted though for writable and
> shared pud mappings like PFNMAP ones, otherwise a follow up write in either
> parent or child process will trigger a write fault.
> 
> Do the same for pmd level.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  mm/huge_memory.c | 29 ++++++++++++++++++++++++++---
>  1 file changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index e2c314f631f3..15418ffdd377 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1559,6 +1559,24 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  	pgtable_t pgtable = NULL;
>  	int ret = -ENOMEM;
>  
> +	pmd = pmdp_get_lockless(src_pmd);
> +	if (unlikely(pmd_special(pmd))) {
> +		dst_ptl = pmd_lock(dst_mm, dst_pmd);
> +		src_ptl = pmd_lockptr(src_mm, src_pmd);
> +		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
> +		/*
> +		 * No need to recheck the pmd, it can't change with write
> +		 * mmap lock held here.
> +		 *
> +		 * Meanwhile, making sure it's not a CoW VMA with writable
> +		 * mapping, otherwise it means either the anon page wrongly
> +		 * applied special bit, or we made the PRIVATE mapping be
> +		 * able to wrongly write to the backend MMIO.
> +		 */
> +		VM_WARN_ON_ONCE(is_cow_mapping(src_vma->vm_flags) && pmd_write(pmd));
> +		goto set_pmd;
> +	}
> +
>  	/* Skip if can be re-fill on fault */
>  	if (!vma_is_anonymous(dst_vma))
>  		return 0;
> @@ -1640,7 +1658,9 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  	pmdp_set_wrprotect(src_mm, addr, src_pmd);
>  	if (!userfaultfd_wp(dst_vma))
>  		pmd = pmd_clear_uffd_wp(pmd);
> -	pmd = pmd_mkold(pmd_wrprotect(pmd));
> +	pmd = pmd_wrprotect(pmd);
> +set_pmd:
> +	pmd = pmd_mkold(pmd);
>  	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
>  
>  	ret = 0;
> @@ -1686,8 +1706,11 @@ int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  	 * TODO: once we support anonymous pages, use
>  	 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
>  	 */
> -	pudp_set_wrprotect(src_mm, addr, src_pud);
> -	pud = pud_mkold(pud_wrprotect(pud));
> +	if (is_cow_mapping(vma->vm_flags) && pud_write(pud)) {
> +		pudp_set_wrprotect(src_mm, addr, src_pud);
> +		pud = pud_wrprotect(pud);
> +	}
Do we need the logic to clear dirty bit in the child as that in
__copy_present_ptes()?  (and also for the pmd's case).

e.g.
if (vma->vm_flags & VM_SHARED)
	pud = pud_mkclean(pud);

> +	pud = pud_mkold(pud);
>  	set_pud_at(dst_mm, addr, dst_pud, pud);
>  
>  	ret = 0;
> -- 
> 2.45.0
> 

