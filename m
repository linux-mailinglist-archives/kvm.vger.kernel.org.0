Return-Path: <kvm+bounces-53714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9918B1588D
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 07:47:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81DF13B8FC2
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 05:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 539521E5711;
	Wed, 30 Jul 2025 05:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DLeMpcW9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0463572634;
	Wed, 30 Jul 2025 05:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753854435; cv=fail; b=MC355GRSx9RKHDLVITatk441Z/JnZmbWuFBR2ZrkbJcYEgG19cJZjCjVZ+eRHD1C0QbZUaKfGxFzUeqxcQlrtL+Yf/K55ToXgNPCoBiGjbey51WBo5TDCfOdvKC/wutnHLSvUg2Ziah4G7PFthken1R7AlypHYKNJZAaAO0QC5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753854435; c=relaxed/simple;
	bh=c5n28me1fbjVrYsFLrjz/Su0fFuX5h9u/2Ce78p3e5s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OcUFClyvgP1zxX9xcSZ+QJHdpjR81AYu44YueQrgZ1LOYlF58vcShWFOQ61Z3rqkmDWaEISDT0VwtwmJ2Ed/swkJeBjIDj6ZMY7npcKWQhJS7dI7zeYcUNPI9/T6jx4q7ch1GTSPOpYvrzaG4MX7pxMtlp9rlU/mfwZnyZmqzGc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DLeMpcW9; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753854434; x=1785390434;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=c5n28me1fbjVrYsFLrjz/Su0fFuX5h9u/2Ce78p3e5s=;
  b=DLeMpcW9VJkiaGn6qu0lIv7snX99Ruf6eXYw4GP/hZn8Ds0jPFv53o3A
   cqc2qcfPturAgHmy4f7ZJV4y1DPP0vY6dcX5b7rOKu/x93AjWSsM31ZTe
   FZVfOHV+pk9hSlcVzpNvnOxwIIJbgu4oVfUpslDdqCOGOmdK2oILFJIMy
   GcWe4+62uT5wVAEGIDIe8aZjcdoEClXIzHAQXUWq+9yXBxDwoYYpUo5jC
   yde3vykNz00TQrop2B9ayCcNhBb1tCuSSUelogEKj9JlL//BA5XX6ZwSX
   JuG3FiBsBs8vw943KpcLtFuKflPEGZzTQM26kPG4Ho8Usb+gOPcSyb9gU
   w==;
X-CSE-ConnectionGUID: DLY7x27SSVuaL60dF4jJ8Q==
X-CSE-MsgGUID: ZC1DPJ0NQs2bbj6g3V7/3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="56222458"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="56222458"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 22:47:13 -0700
X-CSE-ConnectionGUID: TLbNiTlaTbuM/mUWc1yNEA==
X-CSE-MsgGUID: jrm0cgh3QdeDN7az29YLww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="162923377"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 22:47:13 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 29 Jul 2025 22:47:12 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 29 Jul 2025 22:47:12 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.40)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 29 Jul 2025 22:47:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vqfj9ARB2aiIsP879BUFTyJTcpU7f/Btkrd2lE4r7I6P66HNksB4rirURrv8j45fYrwU7k1WSGnyvJRET+mGR+QbnbiTG+CMTU2tK6rkIyuwnGx9OP6yhrSxtpXjuXNCbJWPQxkpoys/TAmyi+B76ymlMKTH+MUgzJf/AHvtyZ9Brwz57q9YZvzAB5jipAtqIYIYhNAva3QFmFPPOYJ2MMs5cVTwYLiN8bkFCJtXpl6PSbgoZoBp8g68cP+v6Kbs5fOXaSVvJqnlehyoJIB6/SilykmeenSISSQbaa3f3YHgay6Z5sCf1JwhOXYGWw1CbVavtkI5+XFJqk98YEeVjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kHRGpwZAPAp3zjcLmxohq9cjdFX5bHFf0DKo/qUUdeQ=;
 b=l/Pa8ogUTi69Vq+JkpYJYvMhdSJlpK+lvUs3/Fvub1+GTT/v8bR2Ebo1URQwBQBOuFssCQKMA0m/+FJP3FvjfnwGHjGzSQlU+AkeQiExIJklydog6ZCBXl9pMtq9eJvmd43WDCwARCIUAOm7PNNV5GcqYp/CdbHN3zSwiz0W0S4+B7PLUIaoXRo5Yur3Ahrga8RgFzjN8pRthPvKglwWgVYm/0dLE7HwttxiCiihy1CrUSuby53/t0o+/bFBcxRUic3k8h5ZAzM/K3KANPd9Xp7ba2NA5y2aE5D1HYkltCfeQXPfb8OyoAFpvD4lA8fyp2Tf7EEV2apQNSB3dMocDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY5PR11MB6367.namprd11.prod.outlook.com (2603:10b6:930:39::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8964.27; Wed, 30 Jul 2025 05:46:09 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.8989.010; Wed, 30 Jul 2025
 05:46:09 +0000
Date: Wed, 30 Jul 2025 13:45:35 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "Annapurve, Vishal" <vannapurve@google.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"maz@kernel.org" <maz@kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/5] KVM: TDX: Exit with MEMORY_FAULT on unexpected
 pending S-EPT Violation
Message-ID: <aImxfy6mJbtq0yP9@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250729193341.621487-1-seanjc@google.com>
 <20250729193341.621487-3-seanjc@google.com>
 <1d9d6e35ebf4658bbe48e6273eefff3267759519.camel@intel.com>
 <aIlRONVnWJiVbcCv@google.com>
 <e45806c6ae3eef2c707f0c3886cb71015341741b.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e45806c6ae3eef2c707f0c3886cb71015341741b.camel@intel.com>
X-ClientProxiedBy: SI2PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:4:196::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY5PR11MB6367:EE_
X-MS-Office365-Filtering-Correlation-Id: 96d6e6e5-c3af-4768-51ef-08ddcf2c622c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?ffPZKq5S4ZN5zmcePbSDGMI9+i5EclKFPfu6V3+6+no1R7IqOKE5JgNtfs?=
 =?iso-8859-1?Q?5MTVSO5ZNMqfKf+SvSED8MtL9sWMUtzO+jZCSpnWDlubKdkDx4x0SylVof?=
 =?iso-8859-1?Q?Gqvf0LS8jFAnwmqvbMgK0SPqMJTNXoIwvA7Akv9iD9LGpWVhHJwnKp9G1+?=
 =?iso-8859-1?Q?Pnel/7zk/d5+qolxQuEVo6b4vbWyhgZZ0HgTk1QTWNDAvN12cmp2ZLBkq4?=
 =?iso-8859-1?Q?I14VHHn6u15UU2OdlJzFjhNIsdgTkj1sg9FLteRWlDsSr72y/Y1bxmGuL1?=
 =?iso-8859-1?Q?BHJxCOKhu4yLrJIa0kO1OSwF/oWMQXwij5G/StYVI76tQpWMdKhN2tySFY?=
 =?iso-8859-1?Q?7rS6/2mQhoeLYUWngSbFwPsPJ5brXsXQx7THMXBpwPxzcYERzlbH4S0RNz?=
 =?iso-8859-1?Q?wUw9wdCJbe2qbb0XgGRWf41bOhgq39TTtaMUYyTCuu5YHlD+SpKSMk1Y3H?=
 =?iso-8859-1?Q?Se0BDNTyKAhRwsWzy1R2Kl5liO3YuILT5DhV7jMlGUYyZv3Y6MiWBsttx2?=
 =?iso-8859-1?Q?colLDMF86GcHVTKmFlEYjtE7WXiqVkDu/UaO12I6pIsZqIGDHsiy/mSxtU?=
 =?iso-8859-1?Q?ZQXN6WiwIOakEbDLgR9MEHbI2DkgCO3ipUU9Hkhn2b0cPkN52mYh/I8ghy?=
 =?iso-8859-1?Q?2ex3cKx2ykozAMbfx34NK5LDfWVTf0qTtZZZzH8XQtYJT/bQXUZB9AqLCb?=
 =?iso-8859-1?Q?HDiHkFrT80TR3mJ0C5Fa2sPcsAdNKecX77QLZrKCG5H5gdSJQJU36X3Xou?=
 =?iso-8859-1?Q?gwd1HNaLXOLcJqdiwqD9uvOh5F4z4tHrSi6KEqFnwVi8gTtCbr3RmhKcg4?=
 =?iso-8859-1?Q?dn0oMkVveOOrQsz0axXWeXVdz4SBg4/mDIYUYZLhX9jtCX8CjYXBk38HJ5?=
 =?iso-8859-1?Q?LgSaOBE1CNsUpPjGrHLr505yTcoXXRLmiPlHUnaDQ8uyBDuUr49LoVfE+O?=
 =?iso-8859-1?Q?DrrPzbNmMfPw4n6CN65lZhWjFZFwjPtghb2THZBee9jG9eSr7Y/VxD5GYr?=
 =?iso-8859-1?Q?5D0V/sfnOGYlaR3pw9g09w+2DQ+uCN2G5rasymikId1OrQw9ylcb/6okky?=
 =?iso-8859-1?Q?GnQbHuO92EPMl4bgcvfw3Ag4rYKJdgqYyE8rNJ//Bl2ahgdq0beFnIXCqk?=
 =?iso-8859-1?Q?+iCw53IwHMtPRarrfvtFo1+0Mc0q1ZzqarjeXjPgCGFZ05uztKa+q5l8CI?=
 =?iso-8859-1?Q?If5I+T0DulUEhfMxW/5eQI6Jx7uWi0DQcBY/KacWZg+d/MWUtSD9JDVReJ?=
 =?iso-8859-1?Q?KxykK9BqwY4J48ZJO6ROx26AB4MMfr1ij/BtWm0rHrlNsqlNFgUOUZW4pN?=
 =?iso-8859-1?Q?rWhKygsESVEZd9Zla6lSykXRLCWp41ijNrhMclSBJAKF5FWJS/GKTh32T1?=
 =?iso-8859-1?Q?74jQ6keKjH9b1W2NCsE87vBJPMwlTSkszbiff9WsEwr1e7M56jitSZMa2n?=
 =?iso-8859-1?Q?rTWKA1QLPIRwAt7G38o3lMAVUmFGY/VQUrhvcQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?C0zwA4qy8gHmaI3ZpEF2AUN0DI/khAzttCuQDjIHojcGzAfIK6EfZp1cYW?=
 =?iso-8859-1?Q?HulN55pnhNEqqPao1uPBWfqDQqYjWV3SGwCk6Bf9/vLsyCUbtlI4j8NbBV?=
 =?iso-8859-1?Q?CsRwDX8Sy0208Pp+MPdv20yhztbkeKeTHmE1o7KdldJJa9dYRwmPxRQnDg?=
 =?iso-8859-1?Q?AtV9eCYzO6y0YfY0BVHcSowPxmnaNvXQXeBKpO6vApzNyfg8RXAIuDD5+y?=
 =?iso-8859-1?Q?NqkHqBF2nsvHotAEpQKQt+g/iYcXGYeUby24LbaF/n8l9sCkwIVA2q5ZIl?=
 =?iso-8859-1?Q?YMuQPdqa0TZXlkCrv0AOxtLPS9UBoO2uHiddPLXzSYqxIUasuW7aJ/jboV?=
 =?iso-8859-1?Q?tvkUAvD5WP/B4Z//8LD8sRTwJi/c9kJtkJqdCtwxkFIEjJoQ5Upl8/ik+0?=
 =?iso-8859-1?Q?TiZxEI0b2IVvk8fMUGpepZAx7GVsAOFyvmsVTNzggdzZAN5mxpg7rPdLK8?=
 =?iso-8859-1?Q?PKrMa8Nb3O69bhnTtXft64TcBHKPKvS3/sGnwFtOEg9cVa3e8j8DP/YhQQ?=
 =?iso-8859-1?Q?kTzk6sIeDPoy9qdmDdIHuYcNcQ5deLyHlWTbJRe0Hg7ZP+e1V522bd+zPK?=
 =?iso-8859-1?Q?/PWH7kZ0cNTxkwVddpTnpuo6Kp4Nukn431OAfRJF4YxdbLmNj3o+2oVZuX?=
 =?iso-8859-1?Q?mIALnvKQNFsOcFFKOC7D4dNogHYIK/37irHWBTkIBZZmAGz1rKgEgtNh2u?=
 =?iso-8859-1?Q?8P4jrTlYKGQ6mtB/Kl9qe97GLdBuBmCFQt10huBgRL0SuUul9ECdGJO78V?=
 =?iso-8859-1?Q?/rBeDs0hSZInsS0vkPd47cDDACB7lEOQpIAVoGyA4RK96ARdtTJNp4q2vg?=
 =?iso-8859-1?Q?sqDNRlhO6LbRaisSHlkSRHYy6uhdrzf6T50to+6l4/UYVp3QhOv7lc+QgH?=
 =?iso-8859-1?Q?J+drn5tapYCqaYZh/OuxEnKbgx08GdfR3/p3ypSCebO20dyLncoXxpbw31?=
 =?iso-8859-1?Q?ScRFMhqwhnDhLHiWCSUp1+R2bDa3aNk+Qojg3wm8JSHx5JkGDYiSPwdAPw?=
 =?iso-8859-1?Q?gw230N0zsrSu2qkB/pmauPuhsOMgWPKbyRdALMQZ1vaPrWJqNifpPliJmR?=
 =?iso-8859-1?Q?kBOUFrCQpmsig4+T7iopR9wFTIUd3Dmwocj9r5LeKJxD/MMl/AEmFLq78s?=
 =?iso-8859-1?Q?Qw/nNdkdqc8cosf+hp2eiUQsNRCF9wbwAY4J0Uo7LTtq6H80zJWSd7Ix1N?=
 =?iso-8859-1?Q?uLdAJSoqwjtJxVYG1VC0Bfy+GO71OcPxNz2O8+JrpuUijsrtqsZjjkdtaN?=
 =?iso-8859-1?Q?CPPGoKceFgS38BS4CtrVGxtqBubym1pRjFj+OQDSFGn+Mo/OIkHzynODw+?=
 =?iso-8859-1?Q?hwLBFY41ZmI5lvGAUKJ+khX5HdyncX0K1yXQbLeoAqrBzel2F//WmFZ7mM?=
 =?iso-8859-1?Q?e3B5Ro56RqaV8GoKk+QlhGr4Jnp04jsATg98BMR2lHpCv+wYZuZD3AIQgh?=
 =?iso-8859-1?Q?c52OGmzd1uEi7BCwOTQD+Qt0yWp0ufpTUovYqPbcQLh2Nup+TPGqHqKhzw?=
 =?iso-8859-1?Q?gXTju4mRJZ1kNjKr70LZXZZOd5BMPGqKqM2PTuSuqWog5LQ7u8PikNCkSt?=
 =?iso-8859-1?Q?ZJThYtefywRWNzj4TQ50h8HSi0fykwtEys94hNy5mFMK9xAfeFrkZNSI6y?=
 =?iso-8859-1?Q?8YGBbtvN1h5SqaxNYdGWjqeqnTikdNeb9w?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 96d6e6e5-c3af-4768-51ef-08ddcf2c622c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 05:46:09.2168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BPyXZopGxTeErHOIvrfJM2uzmZplPKLKf+UuQqrviuC6Dyv4b1thcp6WRfjmfXE1lx/yS/iW8XcKIbool+01pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6367
X-OriginatorOrg: intel.com

On Tue, Jul 29, 2025 at 10:58:02PM +0000, Edgecombe, Rick P wrote:
> On Tue, 2025-07-29 at 15:54 -0700, Sean Christopherson wrote:
> > > The vm_dead was added because mirror EPT will KVM_BUG_ON() if there is an
> > > attempt to set the mirror EPT entry when it is already present. And the
> > > unaccepted memory access will trigger an EPT violation for a mirror PTE that
> > > is
> > > already set. I think this is a better solution irrespective of the vm_dead
> > > changes.
> > 
> > In that case, this change will expose KVM to the KVM_BUG_ON(), because nothing
> > prevents userspace from re-running the vCPU. 
> 
> If userspace runs the vCPU again then an EPT violation gets triggered again,
> which again gets kicked out to userspace. The new check will prevent it from
> getting into the fault handler, right?
> 
> >  Which KVM_BUG_ON() exactly gets hit?
> 
> Should be:
> 
> static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t
> sptep,
> 						 gfn_t gfn, u64 old_spte,
> 						 u64 new_spte, int level)
> {
> 	bool was_present = is_shadow_present_pte(old_spte);
> 	bool is_present = is_shadow_present_pte(new_spte);
> 	bool is_leaf = is_present && is_last_spte(new_spte, level);
> 	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
> 	int ret = 0;
> 
> 	KVM_BUG_ON(was_present, kvm);
Yes, this KVM_BUG_ON() could be triggered in an earlier code if
tdx_is_sept_violation_unexpected_pending() wasn't checked to prevent repeated
EPT faults.

But the KVM_BUG_ON() is no longer reachable after the commit cc7ed3358e41 ("KVM:
x86/mmu: Always set SPTE's dirty bit if it's created as writable").

With the current code, even without putting VM to dead, the worst case is the
endless invocation of EPT fault handler, returning RET_PF_SPURIOUS.

