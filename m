Return-Path: <kvm+bounces-46969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A73A0ABB796
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 10:43:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EBD316710E
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 08:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00D8A26B2C0;
	Mon, 19 May 2025 08:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QgOCZ0TR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BB926AABE;
	Mon, 19 May 2025 08:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747643671; cv=fail; b=nMkURnpA4XRzCdpdP2tFgui69lHWtfbS0jWytYe/BB9Crxa7iQZFDpB4ynjpPdjJ5th0/jG1XyI35v2BLJNcLnphHaIxCmdr2kd88KD1LCBtNvUx8m4U/IokurTYkr0IzwTHcNtZL3DHsO/qhXlXKDGbIll/nQ0QQ0mZlRIEoFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747643671; c=relaxed/simple;
	bh=dnRWMgymcUA0Ph/r7eNT8gmBTbObhdQvBLRfTEYvSZM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YL+H8w0IBF8IiaAfB8s3DY7HqVf6Q7mLKquOZlaG+ie1HyQzKveaV0rbiGkwymBp+K7kPwFfUnhdpVTP8oY83KqeS41UZvF/dBrHNlSVuEzxRifLye9sbKrgnoEntD1g9TNP4UMQQBXmt1sitnw3xbhivddo5V9aQAOKA8N3OjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QgOCZ0TR; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747643670; x=1779179670;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=dnRWMgymcUA0Ph/r7eNT8gmBTbObhdQvBLRfTEYvSZM=;
  b=QgOCZ0TRdxB2Peexu63dprWdP1DNquH6IUyVeGfi5dgNyRFOiBQOjv4Y
   wVSZwvj+qOCfgGIw2BZy4xqbhVYBUx5f5fgKcN7rjjhbU4f4mGOjtFxVr
   /NKTmLcUuQG6MDzVYsGfmw5lVnf7mgx1GlvUzg1Af0l4AjpSfNRa2zdq+
   Urbtv8tM+Q3F9insJUZZWRt+IxarbNUtaw/y3x9Dt9c9V//+5Jz0W5j09
   bxPErC3jARsIulyWyD63ZbyMv/V/jHDsPfl0VIrNaMJj7SDIxVPWqj5cM
   sNmVed+MuZDLzAstrj3Dqu70SR7dBD54lWQjv0apFqLLQjsqjFQFwG/YK
   Q==;
X-CSE-ConnectionGUID: oFYAVwmASFyMH1+b6fc3aw==
X-CSE-MsgGUID: IXF2pcLkQAS7AYe/h4BExA==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="49464671"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="49464671"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 01:34:27 -0700
X-CSE-ConnectionGUID: EdlfAd91S0mrd5AK6pIaoQ==
X-CSE-MsgGUID: Aqn6IjImQu2Mae8v85pnKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="176415586"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 01:34:26 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 01:34:26 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 01:34:26 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 01:34:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A9Z67jswaLzZ+wMnz0KjPen9c9A/cKmdQzKUyAyV5Bs6acIqEsjkibfQ2PTEnARO2NglqIHw7VCyycQjcIr9EWP1bPDxzNmaLzOVCdS5yeGfOzjJwSGNVXlo3tIbVPjD1qRGFPDC+GmJ6f3d2fYXOzq8oa+0bUxmYw2jswaGQo3zDHmbdG4S4g6/5prsI3gdzBVhsDUN+0lIopxKiZzyylKHmDS/YQctKcaiQEHEMihwNzG1g6WNZW5dqDBspfYEXzs1R8YVSFyabWE2vXjXk5RzCfJ+rsZWfuenhFvRVm1hf6YsyIgdINqw/I7zFVhtYwhNWRoMY47cTvK3UCli9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jj5BcT4bWtHzEId3OZOXs9VYHAiHZA5n1htCl5vp8sc=;
 b=i7s855Aq446itLYNC1K5qiIlOw3agNeCtyzlsXK3wCmLxJMxQOQ7Bi13M0RRPlP1LOjhjXUKl+zAqPpYQOgK1rKRPPxZuVGIfeFjfu4j/Fen/rzYsFrQXksWRGUaBBUh1gfBwlV6G8HVkhfEEqTxN6seMKNAbUlKDCK3y2NMZlMH0m5mmwodGhv6LDrw1UU0Pv3oprGCZm0eRnD21aa6z7kO7WXkSTEvNyp496Ke11/l5iNEI6mxoNN9fewXcL8N9fQJHimXndVSsK0t1tqak6hEmly/X+AvgUufDlx/1xTqtiHZ6IdYnK9TEW6bi1C0ZsnrA+5sZffeDNaGHwISdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM6PR11MB4721.namprd11.prod.outlook.com (2603:10b6:5:2a3::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.30; Mon, 19 May 2025 08:34:23 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 08:34:23 +0000
Date: Mon, 19 May 2025 16:32:11 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"Du, Fan" <fan.du@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"tabba@google.com" <tabba@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030618.352-1-yan.y.zhao@intel.com>
 <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
 <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
 <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
 <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
X-ClientProxiedBy: SI2PR01CA0042.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM6PR11MB4721:EE_
X-MS-Office365-Filtering-Correlation-Id: d2315fc8-a608-49b1-7374-08dd96aff52a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?Jj71OxDggCWrAU6vBPVuqhjwvqXTDGf+Ns+OewVanXuJF81r4RTqy9IT4y?=
 =?iso-8859-1?Q?kb1jmOGC8WSW+aMkXIzkoL8IZEtzlyJNojlrZgaeH+jOrknTNVN2BIFG+L?=
 =?iso-8859-1?Q?MGNCLqme5WM7D1irr3yMXalJjGyH7tsKxYfNHQ+UlgLplWt/Hmu0Phd1EA?=
 =?iso-8859-1?Q?YWUnah1KFAzFVA2jUuCDd2T2wQ56I3zeupGnhqCyQe61Zcdd57NTAssKIY?=
 =?iso-8859-1?Q?9fJkoxzxko286kWeSwVS24XOH6ZI3tc4ytdY+CCDYe5AfNAr3seeURbu5u?=
 =?iso-8859-1?Q?XPlU+njaGhTXqaq3MXcIWPLbJe3DDSwjrTW5pUeS0QPs/3KEYXq4gx4tjo?=
 =?iso-8859-1?Q?yZEkNLSkw8xhExQAUWkS7QfJ8n1y8cK95mvJBpIsJe7TEx/U6a3iz4xe9E?=
 =?iso-8859-1?Q?2D/KWmJvN8b1iId/q+ejqISCICyCJo6gHoyN2Rj5IwN3fTfKukz9mYjelf?=
 =?iso-8859-1?Q?OF/Y0ULVkn9qkwInKgrVeWk2px3KJuHk4F5vjkEb3Q7Epkfw0wvFoTsmuO?=
 =?iso-8859-1?Q?cxwqgAVOwueok3GhURcWZF4msrT3b+5mVJOUfw6u8i6PnlAtlQ8qIr8exa?=
 =?iso-8859-1?Q?3wtWOkpAoTnxihrjakoDLrxoR5dObcTFVry9npurdkGLsZB+vnDHadYluf?=
 =?iso-8859-1?Q?CUk+WH5tEE/ykxcdlP2MrNlB9mE08dqArRz324IulGizh9rZzNd8o3LLmi?=
 =?iso-8859-1?Q?o5RoPAYDJYWgYcxyzEiIkicZva4nFsM2mF1PKICTd1sy5Rmo9K7ctVxrnv?=
 =?iso-8859-1?Q?UeTw5n1kiGofHAq5AkSnKmZs7h5xaaUsuLMI5F0GFNxw/bwchna1wcFVNT?=
 =?iso-8859-1?Q?3tiRCXyml2zjP5+XWaQm2+PBHCPEo1hAvblb3pDpqTdullEN3LQOD1E/vY?=
 =?iso-8859-1?Q?QymJxH5hgvlMLrpqT4Fo7n4LwlHRydlLWN23doBQaGzGWRWw/qPNSJNWw3?=
 =?iso-8859-1?Q?hYPE1O+Xo81VG4oaITDO6pSWi7hi/+J/XsWJ7pbWmgqQGVbCaCusOjBaPA?=
 =?iso-8859-1?Q?11DtLdO/MjSRPY/NqTUrNR2nC5G+YrqAyJarRJsp32+H/DEarCr5/aqjSi?=
 =?iso-8859-1?Q?ATy5/23yquxrSENCod/fBVy9sxeXcnJcCQBNLe7uMOTOg0hbuZB+fBt6Cw?=
 =?iso-8859-1?Q?xiBXkcyOONt5EhHI/WVZ8L+LmmHomSb9xP2MlnbjmvrHKojdyfAoCapxoO?=
 =?iso-8859-1?Q?A3HEEog+AqmzNPcglAuH08ct+ovx+mRku5yxTTKgZatCorspneZbabkMSo?=
 =?iso-8859-1?Q?tuMF+/wj7rIvFu2QBwDeO/vNOKor3CjpsqGFDPOG8XypVmI/GOwtZ6qjJF?=
 =?iso-8859-1?Q?yKeVVsvZ/j659IDbX8GYoSzjgP/jQ4RSISmncGpdUp7ft6fqVkH+Bs3TUJ?=
 =?iso-8859-1?Q?fN1L9XEVTYV4QnvAK4/c4G8YXMZZzGP9MSG2zRW2ubNp05sRV9Goh4R8cP?=
 =?iso-8859-1?Q?tmRn87/lDUZvJu1R?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?TN/YCimB1kqn8swj1LNTdOrDtbI7owKTb5jFNGMQvDnyvriaANS3vaq1FJ?=
 =?iso-8859-1?Q?EqC4csxcomxlTGLl8GHjWjcutpwacXsV3G4Yxi/V9L8U3oRb4sQGsmLSWV?=
 =?iso-8859-1?Q?k5aA5Qyct86HtU4mARHJJOtMJJHRKqKiLTJqd+JRUjit/nfo9KXXgSutgB?=
 =?iso-8859-1?Q?ezbjoboWAobWInY49zZk6z+qDh/KbCyvV7IGRMHpUehF+CK8QhiAz+u2ym?=
 =?iso-8859-1?Q?zrLOFoVOV9V52uzed2QtEkyNwAnOK/8n3vnrdiyYCpsZNWnM6eGiHD5Jes?=
 =?iso-8859-1?Q?M/UgntqKustVhFKTeqQGZIaNmsqFn1K9J7oTI3kdoiREC0QoZIl/uqr0Sn?=
 =?iso-8859-1?Q?cWmbIfW551DkxMETIjryVtFcgZkTFRFs3cJfgGf8a1JLQgiK9EhDs/QkIu?=
 =?iso-8859-1?Q?fwCoc2oPVP55/oMx/bYkPm2x9/M2Oa2EmZvVgZO8u86f7JzmKBaMaeYA8p?=
 =?iso-8859-1?Q?BAZzuheM7W6kzwOY1zvtXbvH2bm8KT5bg2ZAfTyRAlReIPCNtv3wwMJN4u?=
 =?iso-8859-1?Q?pzV7Ho4vp0DM372JpZU84ZbSGa9W5eUSz7hg/PDmI36ahKUe9OmTK0/8qn?=
 =?iso-8859-1?Q?W3eVOBv3GDDeKqdnEr+XWlhh6d14FkA+iB3P4qAbSZIPum+mK6YLIeu8fu?=
 =?iso-8859-1?Q?MTYnF690hTuYRb+DNcrTvFZ68ssDJst88Ww/knxtsWRqnvccBUCOmPCLCz?=
 =?iso-8859-1?Q?1RFwx/PjPfl4k3nGsS3U1i1zfD2A0/l6M0Rwlku9vzrRpoBpSJFVnxbhy1?=
 =?iso-8859-1?Q?GzOqYlR8zCVpbDmJcJtWq1Bsf319tkJpcJKNLLAnd19aj+aj2pg/UWOTkX?=
 =?iso-8859-1?Q?nDUoHpED9h824Kt7rgv9B0ys/nfkFu5fVzul22486a5FfImVHzI9NXjf+Q?=
 =?iso-8859-1?Q?zBpSU3QrdTQigDamXQUZ0JLWHqBXJBUg9cE95LguhPyLZg5qAtq8V253fp?=
 =?iso-8859-1?Q?ZmisvP5ZlNubrhNnT1QagL5SHDc787SZJn0DyXAIFXam+lktRBjBPFe6BB?=
 =?iso-8859-1?Q?kuGSw+UfCuTfz75ev8hPa7raUXfqTynuadXVX79q3zYQzSepLfVbAwYhph?=
 =?iso-8859-1?Q?/jnqDfP336GvuIlV37oxxg9FZa7rO1wUBMGJJK3YhYwZ2BOP7iTx9PcMfN?=
 =?iso-8859-1?Q?0AZhTdmhtdHw63pGqGjolxCDoflbcBIpbgLokDyiOsYvvLPiMYeU0wfzH5?=
 =?iso-8859-1?Q?n4oGrMBMIiuTCeCF4/GdcoHrGcikTnm9AaHaeGLX63CY2AnJ+EtIeE17VN?=
 =?iso-8859-1?Q?Jus/XfeZ+OvhlUW2m8rLr/l5HfZ2NSZyRQ6OCgycdWK154VgVL1WMcYxsw?=
 =?iso-8859-1?Q?gauoS25kstqwMbFJfuOP7+VG+fSeTn4xOcCMFQPPQ6Finke0oCvQbXvmv3?=
 =?iso-8859-1?Q?ED6W8XEHJXQIEdc24e/jRqyZGXtYDmVmOp84rSBO5KZqDB1FxlL+XOnNhb?=
 =?iso-8859-1?Q?mnXIvgmnSQHifud9xIa+oBy0wNItQ5lTr5x/mi+S8fycdIRGdUzCZ7PzyZ?=
 =?iso-8859-1?Q?xmq5ayTJvAA3bBBnpv5GEUtsx1jNVOZ1bUa3O9Jd4g6a7/IgmJ9djvTVMu?=
 =?iso-8859-1?Q?REVZRviTJxyHwKoK9/wOiLMbDHDNxd37+pb/w+Lchge5+lVa19Ff/WMO28?=
 =?iso-8859-1?Q?DuLpL2Xg4/nrXT6sYjvBIs4h13pkjhhYAv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d2315fc8-a608-49b1-7374-08dd96aff52a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 08:34:23.4511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t1obkgqLsYFLRnt65y8IQw/BIAvIW9VbPnzw7KXy0d92tNsqJB+L0QjQ7lIGyzvl+yjK/q9iWYQo1ne/6+ZxXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4721
X-OriginatorOrg: intel.com

On Sat, May 17, 2025 at 06:35:57AM +0800, Huang, Kai wrote:
> On Fri, 2025-05-16 at 17:43 +0800, Zhao, Yan Y wrote:
> > On Fri, May 16, 2025 at 09:35:37AM +0800, Huang, Kai wrote:
> > > On Tue, 2025-05-13 at 20:10 +0000, Edgecombe, Rick P wrote:
> > > > > @@ -3265,7 +3263,7 @@ int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> > > > >   	if (unlikely(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE))
> > > > >   		return PG_LEVEL_4K;
> > > > >   
> > > > > -	return PG_LEVEL_4K;
> > > > > +	return PG_LEVEL_2M;
> > > > 
> > > > Maybe combine this with patch 4, or split them into sensible categories.
> > > 
> > > How about merge with patch 12
> > > 
> > >   [RFC PATCH 12/21] KVM: TDX: Determine max mapping level according to vCPU's 
> > >   ACCEPT level
> > > 
> > > instead?
> > > 
> > > Per patch 12, the fault due to TDH.MEM.PAGE.ACCPT contains fault level info, so
> > > KVM should just return that.  But seems we are still returning PG_LEVEL_2M if no
> > > such info is provided (IIUC):
> > Yes, if without such info (tdx->violation_request_level), we always return
> > PG_LEVEL_2M.
> > 
> > 
> > > int tdx_gmem_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, 
> > > 				       gfn_t gfn)
> > >  {
> > > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > > +
> > >  	if (unlikely(to_kvm_tdx(vcpu->kvm)->state != TD_STATE_RUNNABLE))
> > >  		return PG_LEVEL_4K;
> > >  
> > > +	if (gfn >= tdx->violation_gfn_start && gfn < tdx->violation_gfn_end)
> > > +		return tdx->violation_request_level;
> > > +
> > >  	return PG_LEVEL_2M;
> > >  }
> > > 
> > > So why not returning PT_LEVEL_4K at the end?
> > > 
> > > I am asking because below text mentioned in the coverletter:
> > > 
> > >     A rare case that could lead to splitting in the fault path is when a TD
> > >     is configured to receive #VE and accesses memory before the ACCEPT
> > >     operation. By the time a vCPU accesses a private GFN, due to the lack
> > >     of any guest preferred level, KVM could create a mapping at 2MB level.
> > >     If the TD then only performs the ACCEPT operation at 4KB level,
> > >     splitting in the fault path will be triggered. However, this is not
> > >     regarded as a typical use case, as usually TD always accepts pages in
> > >     the order from 1GB->2MB->4KB. The worst outcome to ignore the resulting
> > >     splitting request is an endless EPT violation. This would not happen
> > >     for a Linux guest, which does not expect any #VE.
> > > 
> > > Changing to return PT_LEVEL_4K should avoid this problem.  It doesn't hurt
> > For TDs expect #VE, guests access private memory before accept it.
> > In that case, upon KVM receives EPT violation, there's no expected level from
> > the TDX module. Returning PT_LEVEL_4K at the end basically disables huge pages
> > for those TDs.
> 
> Just want to make sure I understand correctly:
> 
> Linux TDs always ACCEPT memory first before touching that memory, therefore KVM
> should always be able to get the accept level for Linux TDs.
> 
> In other words, returning PG_LEVEL_4K doesn't impact establishing large page
> mapping for Linux TDs.
>
> However, other TDs may choose to touch memory first to receive #VE and then
> accept that memory.  Returning PG_LEVEL_2M allows those TDs to use large page
> mappings in SEPT.  Otherwise, returning PG_LEVEL_4K essentially disables large
> page for them (since we don't support PROMOTE for now?).
Not only because we don't support PROMOTE.

After KVM maps at 4KB level, if the guest accepts at 2MB level, it would get
a TDACCEPT_SIZE_MISMATCH error.

The case of "KVM maps at 4KB, guest accepts at 2MB" is different from
"KVM maps at 2MB, guest accepts at 4KB".

For the former, the guest can't trigger endless EPT violation. Just consider
when the guest wants to accept at 2MB while KVM can't meet its request.
If it can trigger endless EPT violation, the linux guest should trigger endless
EPT already with today's basic TDX.

> But in the above text you mentioned that, if doing so, because we choose to
> ignore splitting request on read, returning 2M could result in *endless* EPT
> violation.
I don't get what you mean.
What's the relationship between splitting and "returning 2M could result in
*endless* EPT" ?

> So to me it seems you choose a design that could bring performance gain for
> certain non-Linux TDs when they follow a certain behaviour but otherwise could
> result in endless EPT violation in KVM.
Also don't understand here.
Which design could result in endless EPT violation?

> I am not sure how is this OK?  Or probably I have misunderstanding?

> > 
> > Besides, according to Kirill [1], the order from 1GB->2MB->4KB is only the case
> > for linux guests.
> > 
> > [1] https://lore.kernel.org/all/6vdj4mfxlyvypn743klxq5twda66tkugwzljdt275rug2gmwwl@zdziylxpre6y/#t
> 
> I am not sure how is this related?
> 
> On the opposite, if other non-Linux TDs don't follow 1G->2M->4K accept order,
> e.g., they always accept 4K, there could be *endless EPT violation* if I
> understand your words correctly.
> 
> Isn't this yet-another reason we should choose to return PG_LEVEL_4K instead of
> 2M if no accept level is provided in the fault?
As I said, returning PG_LEVEL_4K would disallow huge pages for non-Linux TDs.
TD's accept operations at size > 4KB will get TDACCEPT_SIZE_MISMATCH. 

> 
> > 
> > > normal cases either, since guest will always do ACCEPT (which contains the
> > > accepting level) before accessing the memory.

