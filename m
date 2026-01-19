Return-Path: <kvm+bounces-68500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 81444D3A68E
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 12:17:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EC52B308C736
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 11:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C48635970D;
	Mon, 19 Jan 2026 11:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oA2NjZvs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296A135293E;
	Mon, 19 Jan 2026 11:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768821256; cv=fail; b=frPp58ZLAGguIVha0b8hwcLAtOPVe6tux8YSeZR9yBdbkt8AbLQpPwFId2rm6/GQxzMKIanw71+jfD1w1WV01pkOz+rxXkHGI4pIEjY8iWFD+S+dLm3dz8f1GRB176/OxpWxCiieP7MnCmpysWfG9IBOBx5fEdeh0sqKyqP8nzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768821256; c=relaxed/simple;
	bh=3GDS2GvcHSDdA34xUYFBza5nYdS2wdtNmBkjfmt9OYM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mktjDx/JbAhQmuonNQFQbUgIImSre9qcejEiurOZKT4OgcMsM4PFd6qQTlFDHwDg4QTdeAjyYLSPSGToOh2yv8NE2/nNYnHsySL+LPv5CZoD5FPXQb1Il2X2GCeKeGbYSZyoUjbpEe3lBCTLDE5Lhb99aE+8o0oRFBPBlU8V9WE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oA2NjZvs; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768821255; x=1800357255;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=3GDS2GvcHSDdA34xUYFBza5nYdS2wdtNmBkjfmt9OYM=;
  b=oA2NjZvs79Lw6tFxW0Jq8UpLEWa7KE/GtZDB5TWZ8ADYgtH4SJoDPBFf
   zve5P209ScjAXSUpWG6v7dhFra5QCQXtDHZPvhLhaP6r9TOZ/c7pIMBnE
   Jux+z6ZAiPdCHeaXn38SBJoTGJR5P7gkh0JmXjFE/0jXlSXsaB5VRm95e
   oUk1bq97bRKVnOayp+Z/FUk6SPQkDOYaNbZI03gkxBd6N3U8sejm2gZQP
   tEFw4q/Ldmwm32nHbhXzSia65wW8lSCInQncaCHuSybDyy/k+zU5R//o2
   8DePzbjgxdOKvFc9e7cOk0iEPgLRVjWqzWxTYG4vmSr1ydashJMtqgZyb
   A==;
X-CSE-ConnectionGUID: n8KAIA60RECQKTKuGwPvfA==
X-CSE-MsgGUID: 41CtPJB6RHGdi8Ngn3IaFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="69935400"
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="69935400"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 03:14:15 -0800
X-CSE-ConnectionGUID: xjb1dfY5QGyt4Y1mD+qCGQ==
X-CSE-MsgGUID: SLbK3z6dQeeXDvLYeAqmew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="210695938"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 03:14:14 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 19 Jan 2026 03:14:13 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 19 Jan 2026 03:14:13 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.58) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 19 Jan 2026 03:14:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s/A2UqW4I4dqHIk3ST/+xDif4VuB9uUJY3wDaIltnmhqzw6XY50hPVWtfr7/h6Z4azeFsFP10GgizpEr3sQFhr10jFrOc00R+n3y4kW45ijPsJnR4joN0w334tlW2YUsslLhg2atFIRf7G0+DaRMlqpwC6VtdYp+Q3kJ6kykPbfog6xuMeMXFiszsF55IGU/KyogsFSgfHOxUampivI9tGMwl+lTi1bczfEWXbV6SQxMutkvatRMaRh2qWcH1x4tpbcAf6KeI5zf4xakkCVAj04I9DqewoJU3ZHgIRb1EdSUtYvOsBnqAqB//W7JJ9MR/p7QQy6wi9jMNZdl4LvUIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UdIi2CzehPPKbzRbdCjtrchX3mkrViRQxYv6nKfW8wI=;
 b=O1Nb3r81CB5f3edFK8feeA9rvnE+Hfq0UNR+Qlf7bpHD6M3ss5IT5sejGVV0FxR2BygRYE0h6rT5OXAyGQG3yj4E92EF7T+hKj/FC7cg4y+0OGl1apARq4Z3U1Yv4nsf3+WQJznVr7A+Y8F//8Rp1pXwqBl9jgAhLSU/+BH9Rpzc7EAp+3mMnAT4M8XrQx1TdSSj11jMESMjTahoXs+3xbof5jvFCM57ufR0ySf040UH6CHibhMx8C92ppl48bDDxnZQmw3DZEn3UIsDMCkPS/rc11jyXs0PhovQ2/IapD0darHrmAhJcV2niAYbh+bF5Ks8AJgUrifuKGwLKBDXkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB6558.namprd11.prod.outlook.com (2603:10b6:806:26e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 11:14:10 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 11:14:10 +0000
Date: Mon, 19 Jan 2026 19:11:53 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Du, Fan"
	<fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Gao, Chao"
	<chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "david@kernel.org"
	<david@kernel.org>, "kas@kernel.org" <kas@kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, "Peng,
 Chao P" <chao.p.peng@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "sagis@google.com" <sagis@google.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Miao, Jun" <jun.miao@intel.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 22/24] x86/tdx: Add/Remove DPAMT pages for guest
 private memory to demote
Message-ID: <aW4RefKjby5Z8GWJ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106102413.25294-1-yan.y.zhao@intel.com>
 <2b9d6a33629b40c92ecf1d9ed5d75e2158528721.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2b9d6a33629b40c92ecf1d9ed5d75e2158528721.camel@intel.com>
X-ClientProxiedBy: KL1P15301CA0054.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:3d::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB6558:EE_
X-MS-Office365-Filtering-Correlation-Id: 206bd571-c47f-41db-9934-08de574bded3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?oQl2aD6AWTS/kFKaOPIMl8RhEauLb5l1vROrUQb/4x13J01TTGRqI8YsOP?=
 =?iso-8859-1?Q?FixVvuwUC04YJt1/zySPAC7u0TnxoqNDLep5o8jrUkCs/K8W4nr87uo5LI?=
 =?iso-8859-1?Q?DKHCF4hUe9z7lbADKeY1lAAYK8/SIjxAzo2vYp0RDKBd/inRU6Azjjks1q?=
 =?iso-8859-1?Q?C+KeHyjvtExZ8WACgKqESeHzUfzJH56ZZdubVCj3eA3WuLkCxw/uX7Zxwv?=
 =?iso-8859-1?Q?oOAl9fRRrNL8lDFiw1A9FgJMM8QGTcijE4HIUdGIer8LVtefYOOKwwoey3?=
 =?iso-8859-1?Q?OMKrWt2DrqBlyrxEniFBe9NI6gyMO+yNDKoKkWX6sgdGBRa43LftiyVKI9?=
 =?iso-8859-1?Q?P1noPUUJhsFNabtJxONVodcRfNR7ftIKHIkU/PVBp0cGWDW3xaXqTANtXC?=
 =?iso-8859-1?Q?SMLE8TqVS1qEPI0e0r32PeMgUM3Zy1IQb2fZXHB2orMmY2MbF5Fn4fECbX?=
 =?iso-8859-1?Q?hBnGzP0RSvBiNXtAuU54qUkJOLrFDVIjBsKDKg2nUKZQqYcVBX9c5jjHaD?=
 =?iso-8859-1?Q?uLHTrAZ7KFYvCwcI1anGxSX0SkUxCvUdvp1QT5LaKvN5fYi1S7hhWBnNSK?=
 =?iso-8859-1?Q?dZye+a75xhUx6w87UNxjkK9Ni9wSROCjBNYPZHNZsok0znqhUhc8n++cRc?=
 =?iso-8859-1?Q?6LzKD+Vx5++vsoV5F2vkvXwCfOw3U0vLf+JJjBIwj9eBREcOThmXoPKAJ2?=
 =?iso-8859-1?Q?uA8u4/M/8zr/ugfNDvUR5V9960tycPjvx349JPHG9fulKuD732w/IZBAKq?=
 =?iso-8859-1?Q?MdUm84zsTgIk/VqJ0TMu1dqXVnkY0M6yPNcdcqgSI1NddjkbIcpdqQymJP?=
 =?iso-8859-1?Q?1rnEmVKYSM4NTvlkdVQkt3e+X7xXmPlNzQtl4196cVlNAEQS5iu7Hzelgs?=
 =?iso-8859-1?Q?5FWPkRwt/WiKNcUbXzAC/5hefuuEWCdnB674TpDqR2UsHQnWcEKCc40J4j?=
 =?iso-8859-1?Q?T+yVa+G9teTiRMD99jRuw84MnaUDUf+o+MOc00DRKbxulwX37Af1OUd5HC?=
 =?iso-8859-1?Q?MD91F7ftOSk+Bhk4hejXnDCR2fxJmoa6xlNR1wgpqiAtOIW9M/oLVsrMI5?=
 =?iso-8859-1?Q?iRO39vqfcvmNy0io/04K388XuAGxk9bTFdHsdka1NRNHzn8YMIGl/orVde?=
 =?iso-8859-1?Q?2STcmEwf0iqRg1pRNxkNCbrOa/7Gjs4pMWN7vS/qfe2oEfgdljtxR9aGOE?=
 =?iso-8859-1?Q?XvTmGwsvY4locIDMu4lkdbzL/ikQvl6BB6YPEoMKgohq/O08YaIefVG8hd?=
 =?iso-8859-1?Q?LEzSgof4/hPcqfRt5ab8PuD3ngeKaiVV+0vb26RLQaoo2G2IGGVL4Bj/9M?=
 =?iso-8859-1?Q?HjPKbDgbgmE/WuJUvs7agBG8nPJHCNGKGNLCiGkCwZL/2jv0Akhr5PvEYY?=
 =?iso-8859-1?Q?7Spa4H3PBugQdji69vJct+62h2/L+6fcwsZ9PmFEwKgfTkoqlw7raLutuw?=
 =?iso-8859-1?Q?067g+mjxlWnxHfX5/abepySQGAM79Bly0/1XhHRn6AInGqsecQvzpnSku9?=
 =?iso-8859-1?Q?BMpLhAHwtj/UxvFcDye9w9NM8M99Vk2ta3om6Jqd+CffjnHk+xqKHGwIDy?=
 =?iso-8859-1?Q?xFOZse1NbCp2h5R5gJUAUzI4zJrY19WMklqviwVg5P7Z1GWVRqqwDg3zPs?=
 =?iso-8859-1?Q?hLvMlwHq4ACWU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?SpUDOwI7qqQfS6dmY9qwo8WK3n9md/nZy0R1gup2i1I43OOkB86iY2c1P0?=
 =?iso-8859-1?Q?f3iDL3PHLHB5QbuRQfoYNaTJW6fwLbccoe0qY9VGtOVPutwuSO3s6YaRau?=
 =?iso-8859-1?Q?CXUIETaLr7vs6C+82s3IuuA9u/pimyLZWzsVJK+41XMekrUBwGKjZVEHE8?=
 =?iso-8859-1?Q?kIwOQ63yUAbgcrxQyppYtU/Ug9LnXXDFp4+p3TAqxwLSkaK1++0G+Vy1lq?=
 =?iso-8859-1?Q?bMyLo5znK3spXoYvMqF8/9ALxsUmn88NJ80S+V5P6gYjr+Nb//3YcTNUAp?=
 =?iso-8859-1?Q?di7VfOX4/29fOZ1gIV5HPEUp0rGOY24AxD4DVxGVSs5+CpVu0/oeJcnpgc?=
 =?iso-8859-1?Q?0KKyaSVxgoYZXeKZtBk+P8wvLUZS0YNFN96TZJWGtEYFSKWVC77M+7KqI0?=
 =?iso-8859-1?Q?36F99U8LfFWP5VNziYob+hylTlM+1LvfrkU1OrOJgbLHIudABEfDdkUnxp?=
 =?iso-8859-1?Q?fKHb7sUrN1HQUYkleQJ3TdnTlkGbPyCiVewV/l2UiSJa3LkNfEYaUB/H9j?=
 =?iso-8859-1?Q?5s6uiueGJR14ErcAFhvhClb8qUkuAYwPjQ8d6kKTpIpV91sNitr6TN+6gQ?=
 =?iso-8859-1?Q?+bL7GlaFqCiZZ7hg3NCbh8hqyU6TKmeN3ZD9NIwFzrtQO/cCwYJzmpQqd/?=
 =?iso-8859-1?Q?bXuBKJzshAL+42aHs8PrfouWh7A/z1X/BxglZfX2SNEFEztqdTh0shgouR?=
 =?iso-8859-1?Q?wuIKUYaI/ejf1Wl4Q+xLPpYZBdpJqYTHb5BjJEu0ezXfgsiZdRf5hNNgah?=
 =?iso-8859-1?Q?tgR/SUVxH2CkVx/crY5vz12wq+Ek1z+lAgh8zfCKRS8jshMNfdQMWV+vsI?=
 =?iso-8859-1?Q?oC2amqvcGey5aMtW/fdwc8dsXq06geccwoKmLOqdiGH7eDWjmTdDupWDk2?=
 =?iso-8859-1?Q?hJTPAF97dMugEre/H1UuI5+75hjrOJutzKl1/QOTRppjI3MbMLtMuZ57fe?=
 =?iso-8859-1?Q?ad/zF9gB/+IPyo9y6BEjtBbZJ++Zo1hUQ4CdsXcN7yeAPG7i27/H+l+sMb?=
 =?iso-8859-1?Q?1ZPWh5BFwe3Ruf6fT/ghv/gxQg33S3905iXYzLuS+0pmgfszEgbnidn9GO?=
 =?iso-8859-1?Q?mEi7Mo7Ao2KsDUbb/pgpOvrbSVwTmql12uChFyAeiOI+fhXDJ2tsDdYQun?=
 =?iso-8859-1?Q?JdFBk85ybzG1QWnA38r8iURAza5xA2i5ueodhMgxIIv6XSg5LjQqPktfQD?=
 =?iso-8859-1?Q?x9TUJSW4sSNxr9fJlKQdRUN/90X+og488je2FgT0KoDD3+bpCDQETjBQk8?=
 =?iso-8859-1?Q?MDy4CS0iW02OpE0b2k9wLgezXcHp+LkCM6KWl3uAVxaZPh/VeHA7cYdIdl?=
 =?iso-8859-1?Q?9iAVG3a3VGThD+jZOqxRBcv+h7XEYuUXBxdiYlnys2uw/9R6oqWFMiD/L1?=
 =?iso-8859-1?Q?CvYHaqS7rXXngKTbxdyXfS+r9xwIpx8GfWqB0wJugd8pYxWvfQg+oQqVuM?=
 =?iso-8859-1?Q?a5+IfuTU1RlnKu8grFOzobhJYUWFnX0/3I8DbQ+vv0EQFcuOvUvtZ0VL9y?=
 =?iso-8859-1?Q?zJ+RDfJytCJ5eZ1hmBYpNErrNCv+VtFhX0CzO8WY8+reDH0FkQmafMFFnz?=
 =?iso-8859-1?Q?iFaNTmIQIhf50fKPg9NkxHJ/vKkYrSVY804WsNcVq6OdH3sha/TPsK9bJr?=
 =?iso-8859-1?Q?M9Sw83FNpq4oLmlw9bZGP+2742nZCTnDValf4Qo7+/+qhUAWp84ZeTFQcN?=
 =?iso-8859-1?Q?1xSUjMIZ9OFowKC58qBTsmME/sfzbS5K1PkdIvu7chEyQF/bzugGXMlDN9?=
 =?iso-8859-1?Q?jsQByj9OAtCjtQJYsoFn7Jx5XBbbi6gEEfgaFTW6DmKDeXhVVVJwH3wZ8l?=
 =?iso-8859-1?Q?GrBIvyBFdw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 206bd571-c47f-41db-9934-08de574bded3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 11:14:10.6794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r4qz89zaQ8u3dSgHq9SXmvyYqU5Vrt2GI2VQM4WqEfEQvR0VQZBTBDXz7LQAnJcC5LNJ96vp23hdluAo/xlCfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6558
X-OriginatorOrg: intel.com

On Mon, Jan 19, 2026 at 06:52:46PM +0800, Huang, Kai wrote:
> On Tue, 2026-01-06 at 18:24 +0800, Yan Zhao wrote:
> >  u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *new_sept_page,
> > +			struct tdx_prealloc *prealloc,
> >  			u64 *ext_err1, u64 *ext_err2)
> >  {
> > -	struct tdx_module_args args = {
> > -		.rcx = gpa | level,
> > -		.rdx = tdx_tdr_pa(td),
> > -		.r8 = page_to_phys(new_sept_page),
> > +	bool dpamt = tdx_supports_dynamic_pamt(&tdx_sysinfo) && level == TDX_PS_2M;
> 
> The spec of TDH.MEM.PAGE.DEMOTE says:
> 
>   If the TDX Module is configured to use Dynamic PAMT and the large page
>   level is 1 (2MB), R12 contains the host physical address of a new 
>   PAMT page (HKID bits must be 0).
> 
> It says "... is configured to use Dynamic PAMT ...", but not ".. Dynamic
> PAMT is supported ..".
Good catch.

> tdx_supports_dynamic_pamt() only reports whether the module "supports"
> DPAMT.  Although in the DPAMT series the kernel always enables DPAMT when
> it is supported, I think it's better to have a comment point out this fact
> so we don't need to go to that series to figure out.
Will add the comment. Thanks!

> > +	u64 guest_memory_pamt_page[MAX_TDX_ARG_SIZE(r12)];
> > +	struct tdx_module_array_args args = {
> > +		.args.rcx = gpa | level,
> > +		.args.rdx = tdx_tdr_pa(td),
> > +		.args.r8 = page_to_phys(new_sept_page),
> >  	};
> >  	u64 ret;
> >  
> >  	if (!tdx_supports_demote_nointerrupt(&tdx_sysinfo))
> >  		return TDX_SW_ERROR;
> >  
> > +	if (dpamt) {
> > +		u64 *args_array = dpamt_args_array_ptr_r12(&args);
> > +
> > +		if (alloc_pamt_array(guest_memory_pamt_page, prealloc))
> > +			return TDX_SW_ERROR;
> > +
> > +		/*
> > +		 * Copy PAMT page PAs of the guest memory into the struct per the
> > +		 * TDX ABI
> > +		 */
> > +		memcpy(args_array, guest_memory_pamt_page,
> > +		       tdx_dpamt_entry_pages() * sizeof(*args_array));
> > +	}

