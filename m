Return-Path: <kvm+bounces-68491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 89BA1D3A4A3
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 11:18:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CF077307A692
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 10:14:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0D843570DE;
	Mon, 19 Jan 2026 10:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cDuXxXtj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0BE247DE1;
	Mon, 19 Jan 2026 10:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768817677; cv=fail; b=rz+pgOChMJQZNa86CTk7y/9ng69ftFR2ag8fASeVuolQiHXNa4ACK4o/fDHwOWA/XM2mgi5o3coFeDWc6NScbwj35X5eIrJL9u+b0gxmMcyvKE4wrUg59007lgAFVdO1vZLkwfaoIr9/oheQ3LPDq/l2wOrQQlPPH1oZJYKaKaY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768817677; c=relaxed/simple;
	bh=MUMT8YlBHi/P0MboFeX28W3C1mRTfI7GJy09g+g+zgU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=d4FoaTTCse1WIBbRUqWG4+nx6H8J6QEgKeKAveb/QXK9FyeRCT77Fdewzu6K3FZFmUVXPd3gdWWFRC44ZXiuvnCHbmQIaMK9Hqj2FBD9I58yQikzN5OVaTCL059REPPXsQAvWl72pL9fkarmKWRo5guO4QpDCd1G3bYTLu9qVLg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cDuXxXtj; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768817676; x=1800353676;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=MUMT8YlBHi/P0MboFeX28W3C1mRTfI7GJy09g+g+zgU=;
  b=cDuXxXtjGkReWoSskeprxoyhKpYsgN0SeF9w3mTvcO5hV9qe/oJqLFt0
   kV1VEzn8WVhpFBIbyniGcyo65F3DrbTTVDqUQ0HGKIUDF8gaGTFUVC03k
   d93VVPFi9QB+lVf1F7yy4OUA93DVesKbh5UB1etVBGPnc/W37woc4/loq
   zQMYsbCIlBTkKRdKG3W6K8VKjTnaYfQhN6/3xX2AAsTUBZPNGPk80LhV6
   yiQubx0tVk3BpZY3HaNYg3uYKReb2wpQNn/CGuiwLBaPedlIRE/VpSwu1
   iDBbGACYtrwsS0SMoqgLb/v8LO2P5K0D142CD9cDbD1uqWNCZiQltXklA
   Q==;
X-CSE-ConnectionGUID: /diTBMy+Qf2H9E3+i0XSUg==
X-CSE-MsgGUID: Cb5R/+N2QO+CXx+/G7ejPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="70001678"
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="70001678"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 02:14:36 -0800
X-CSE-ConnectionGUID: T4Uve7XrSdWB6dzMrsWhsQ==
X-CSE-MsgGUID: kjDMC654SzOq5sKHa44nMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="243406623"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 02:14:35 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 19 Jan 2026 02:14:34 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 19 Jan 2026 02:14:34 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.53)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 19 Jan 2026 02:14:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gQ29JE10r/pTe8DTV5QVgAkHNeY6Z2za8M5d3Tdo1Hhfsgs3hOa7xxY8HRDBNbixRdBB+7GnxxnnEJmh3NY92D5F1u3eMhqD29Fvi+3eoZgxR1xvqGpafr8p+EQGI64wo01GUAFT8NaKcKdSP6PUejP8upC1gjdXgEGSEcbz39kSgsISC0pcPDCDPQ9emfrqSWNd2Sx8LKIMiNKN/0pL2dJBK5eQ1XCaqfn57+I2I9vkGX5b3hZFUYQ7aw5wm3rUhZiQdaa+PJxjKGsOFIyLv85PZR8WkMQ0JYYw59zGvohm8F2jwwPukgnJSMmGMzAeDXU68F3i5RBWvgsorQEYPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CRH0fmZgz9usAapA4B28mMo+yuT3JkRoESWrZluxoS8=;
 b=WhXM3ouxuLieNzjGR+DzT5XUH2eOIUCJXxxfYybiLiaLlW0HIehxpNtJVYnfKS0vzsT86RN63VwzxDRZPC2zSIzHr4vy+reDEhZl5KOPLcO9on3wGWAC25MzZOYKyK9mhQQxlGNjlyLjC2dnwCfVtjYzyt95UZdiV3PDg7Dk9PIOllpK/535fY+IOKa09lMVR0agKf/BVC7dlXMbSIk5p2Xn6VDXfw6sKcR8j5ccvUDTT+6pC7+af8UK8VNMRJoQ9iyAxN7pW360fkuSF6HBJ1GKQYWo45Zar+EnHSewNLpa5UCTwSfiyt7VCWWfZ1Ym+CjEJxYSrMn6UdhqRTAPqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB5181.namprd11.prod.outlook.com (2603:10b6:a03:2de::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 10:14:32 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 10:14:31 +0000
Date: Mon, 19 Jan 2026 18:11:41 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Du, Fan" <fan.du@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "david@kernel.org"
	<david@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "nik.borisov@suse.com" <nik.borisov@suse.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"sagis@google.com" <sagis@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 11/24] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Message-ID: <aW4DXajAzC9nn3aJ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106102136.25108-1-yan.y.zhao@intel.com>
 <2906b4d3b789985917a063d095c4063ee6ab7b72.camel@intel.com>
 <aWrMIeCw2eaTbK5Z@google.com>
 <aW2Iwpuwoyod8eQc@yzhao56-desk.sh.intel.com>
 <3ef110f63cbbc65d6d4cbf737b26c09cb7b44e7c.camel@intel.com>
 <e69815db698474e113dec16bd33116e54cb21c2a.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e69815db698474e113dec16bd33116e54cb21c2a.camel@intel.com>
X-ClientProxiedBy: KU3P306CA0001.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:15::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB5181:EE_
X-MS-Office365-Filtering-Correlation-Id: e87a64d3-d480-462d-ad9e-08de57438987
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?mIFK7tiPirYOW6YiNdyOQotW+7xKc0WNWZZLmDCVk1Mdo5f0z8YFYbcpPM?=
 =?iso-8859-1?Q?p4dWPwU9FAp8266+EsfHlW6bBuByg6L8WpyAOjBW4PPkin7oicYUwXEeR8?=
 =?iso-8859-1?Q?nUO1YPWSJzGoY9yn7VKNXfteWviN9ltQJU/uGbpsqSAkwsoDGv7Hu73BlU?=
 =?iso-8859-1?Q?AmynBR+VBn11tM+8C2G5LHUi7js0uwIlkTxyf0dzryOJv8Wcp2G+LaGiwA?=
 =?iso-8859-1?Q?7NHArb3zWMoiZ/v3FyRm9stO79+0MwVAuqsoC9TMC4tanfBi4CgBaYSqVK?=
 =?iso-8859-1?Q?8kg+GTTYTLCQflh9V3qVNIb5zKi3ikyCnG04cOMMc/cJTRkYCVcpAdqFDn?=
 =?iso-8859-1?Q?mY5Vdd2dZQbAeinrdcU+8sUFw0+fbkmi3ES6P0h7ykpVIbqJxsO6e9cqUG?=
 =?iso-8859-1?Q?Wdv1S4tLLvmpEjZVymGk3ruh2bSPZ/zEWdR74sy0w10oxlTVCk/QxTKVDQ?=
 =?iso-8859-1?Q?BHCkvEutFAuU7DcmJutnbNoi5StoeFb5doqzk1k5wWhSRlbEUG8PEvTuSc?=
 =?iso-8859-1?Q?Yy/xGRps66a0l2snBF6NyKp37rlQEa5KL8pDXMBKe6s03L/GOot+bBKTvJ?=
 =?iso-8859-1?Q?jFH+j+wbVgwO01OgpdBLxlm+fMpKPo7wg6noEJX8EQNJht3etN0LolmC2h?=
 =?iso-8859-1?Q?x/0bqdjHoiEX9X12o6DIg/rQynxF9Gp4WqQbzqc6Qcoq+I/H4WQUlx9LdQ?=
 =?iso-8859-1?Q?vJqPdoT94GkDWQtsEy5lSIj02cA7QP7mgUChn/7Da1gDKXKXY3znPdo6Yo?=
 =?iso-8859-1?Q?PO4NigY8F7+5MRF1BjzXs+XpymOZkcr1j/5ZknaUZqviipXpp448lmxCvI?=
 =?iso-8859-1?Q?hiCgG5ucl9uQ8RUz8OTtftMgVXLTnPm9yF4jtos/8GDf8B1w8rJbpPH1h7?=
 =?iso-8859-1?Q?LLDLiRslxR9TmmqpQiHcwSD0LzOfpSsaOmEhbB2vmrvuB2qBrxIk8doYTi?=
 =?iso-8859-1?Q?ugdH53F4Hcs7V42oURumpuAlgnlgGPd2uYqPUV2uH9QrvmfvmVq71srohO?=
 =?iso-8859-1?Q?Jct1F6ADhXUymkzwA8ZfPDUX/itian2mGV6oH3q1L9q4cbrtwPld4bpwQz?=
 =?iso-8859-1?Q?lX600dYvnSLAFVRljpl8lKBvatR60nWatU1t3YeWO7TSB1QnACjM0OtluX?=
 =?iso-8859-1?Q?p+UQTVhVTX86FhLmok2o8FntVKTdhemXE+RF2ZGArawnHqioM8UvoBTXAf?=
 =?iso-8859-1?Q?wZY7kJXjyk2hV5lBb03wA4K6roNlcyJ5I+d3TwQKGlnTHmTmpHTePiJSTB?=
 =?iso-8859-1?Q?Pgx62hCLSbj5mOnvmIOVkGRF5+lPNz73bjoaANnEaS7wyAWpl+DUj4HJh2?=
 =?iso-8859-1?Q?CA+z/9lZVYTnpzZAaGJ9mdtZH3f4yckhoSyPI6n3PQa5iRX+9ECwCBjFI7?=
 =?iso-8859-1?Q?GgV9pD6Wuwu0BDg/23TV6VPHCjHpkRkABJPR0qal7OeoUrv7SlUca1Q0ed?=
 =?iso-8859-1?Q?SoF4DInK6PUkULi5Uv7SO5Njy3mULbKG149fS58L38VxEgPvokPmmnnWcl?=
 =?iso-8859-1?Q?Zj+/PE8AxJOo81NTyBgJPXWC/5/XtIUwZ1mOmTZXz6A/mKmx0ZmDTk9YRj?=
 =?iso-8859-1?Q?xdhryaBGQ1QPrl3rRm+T9ZsdhXByOs9mOhZZ2H03pX/fy2XITjVwXO/tTd?=
 =?iso-8859-1?Q?CVcR4586VDNBI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?jkXRIl5PfZVwG+UJc3kNrHKsvto+tGnr4xArPD11vkSjP6kZw2rxIUat4A?=
 =?iso-8859-1?Q?oGtAHSHX6tkJ+5zgUqniLgLYaQkTuJp69XOmuFgPHOsF/v1qOZNJtmlJum?=
 =?iso-8859-1?Q?uL1/kMi5lZ3kdJ2rOWl9hX1b6nQndzLjgX/VGeamvPnep1QSKmkDgsu14d?=
 =?iso-8859-1?Q?pnLr8yTpgJQN9DBErY521ohlQe3z3TccfcghwtYNkcQTtYqrhKXXAHx5q0?=
 =?iso-8859-1?Q?T8p1PLMje/Fy52VrBagySO4DcaSOt1Dj2npj8QcOxg1ZiDkado/AwpcQ8n?=
 =?iso-8859-1?Q?KklNpmL87Jlv+axBmO0rTk689vFSGCZMn91SuHmWNwjFWb9moxhCxtqIw2?=
 =?iso-8859-1?Q?8LTe/l69TaSllT+raekdPIunlIgfSOtPZCZvFjUYv9D5BW1LPlfJbDxrY1?=
 =?iso-8859-1?Q?g+YZVLVpAc/eC6FvD+Qd1MvJijM/gDzOXG5iD2UislEQyWHIgjP+Gpw0Pf?=
 =?iso-8859-1?Q?RewXbkcMvnPrxI7Pc9zpkNkRkgzAkOzS8CGHLGjaRSfClsQXutdiRq631u?=
 =?iso-8859-1?Q?zLenrn8D/tF0U1Vs69jA7kfXCQqxrrm1HYrXZ5mYPXLRWrGyhkDKDr4r5V?=
 =?iso-8859-1?Q?kNuLeW40saEDEiI8N36jz3Or7/ayG+SjHBEniS0FE66UHzpDhHySlp9fCY?=
 =?iso-8859-1?Q?7jZrP8sQCtezpUaO3RM4g/0KnHwLK9Q+e/Y4GWX7gkn/323/D4zGI9CMyA?=
 =?iso-8859-1?Q?FHoOchLW1TPYK3FtKi8yE3urEX7jGl7ZAtxEzUAHhMW6yeH4AZ4UKvrkpJ?=
 =?iso-8859-1?Q?pRmusnmUpQMZuGNsOZYJrg95q9U99TXeiQf7YTW26BwG9jAT5/6oFzHYYB?=
 =?iso-8859-1?Q?QDSbnAeK/KDjoimxkaFWUgwVT0+GbxnVI9rOxnFRF9bai2vLnjQYYNvoe3?=
 =?iso-8859-1?Q?ypEC405DWWN9/5HTUUiSb7y8KoaKrXlPAx1uzefyAwDtFULwizPxNASQHt?=
 =?iso-8859-1?Q?lEpZlMk/II6kVbfk9FnNHiXapwH8ZAglxjDN84YGIrZE60Jbs6CSSuYe1T?=
 =?iso-8859-1?Q?nFxm15nLOFwVdgmKe5aUV6HyNMrzh+ekRNa/RQ7Ba3a/8xJalB57pNCwoU?=
 =?iso-8859-1?Q?oNg1jsJsI9wxVCvzrxQM1/VHLtPvbAM7XMNvKWy8BV4PhNYjlRVzVjckPm?=
 =?iso-8859-1?Q?qZYWYEpnOhgSXzFK3blI3o88IO8ZcbK2ozj/djgUxAdsh9Lm1uqRfOFnDw?=
 =?iso-8859-1?Q?bh4aSigemKH3KJQFqaUdq5/6DiaYVkzWioiQG3Sj7D3E2tg7l1FVERzUtv?=
 =?iso-8859-1?Q?keHr4Uy1lictb/XBskCm2xrTStptNt0a6K361lvy6jqBPRpCOpbq9zpxXn?=
 =?iso-8859-1?Q?ABTcl5iCXmZJfhfwytpNiROdUzhI0mtYMxV0FKKcfglz5S4esJvk3NCSNx?=
 =?iso-8859-1?Q?QHkptnKjmWcx14MhWCftOLiTEg3vJ6lx+MYi2DKrHiLM2L3nTIly1xioPJ?=
 =?iso-8859-1?Q?rE71O6Aiw0yilpxMvW5jnWX1J32IjywWent41MWtIsqGYrq/Xg38amp5xa?=
 =?iso-8859-1?Q?e3y663zf5qn6uzvCT9BM1lyswyMeWpDg++Ti77chG/h3T094zQ9cqBdqzU?=
 =?iso-8859-1?Q?9UyfyvclO9cWb+jwkz1xnyJ1+YGc4aIBtQgauTCUkk9oKvxLjlURzpHIkL?=
 =?iso-8859-1?Q?3IYNoMffzzAwtlc2A9TB4lYKcR1ZlY5w9o0+Wa80uxnOHqkDZiBgXlXF61?=
 =?iso-8859-1?Q?MVHLk1lj58geSApdHVV37ghvoVNZEYNJUZqXW+J1U/eSGDwzzx2tUPII6v?=
 =?iso-8859-1?Q?aQt5VATEXCmJo/6RIsBgnnXerKKrUmzZrbPvw7MuSbi2jpBiSI1H1UsAmL?=
 =?iso-8859-1?Q?+UGxktt9zg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e87a64d3-d480-462d-ad9e-08de57438987
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 10:14:31.6291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7s9uMr9np+povedoTeB5GZeHKVECKDg/eXYttmPtVfoKFSWPMC0toxB5u2+eRheMt99ZzwXVRFA6iZ7ioAcErA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5181
X-OriginatorOrg: intel.com

On Mon, Jan 19, 2026 at 04:49:58PM +0800, Huang, Kai wrote:
> On Mon, 2026-01-19 at 08:35 +0000, Huang, Kai wrote:
> > On Mon, 2026-01-19 at 09:28 +0800, Zhao, Yan Y wrote:
> > > > I find the "cross_boundary" termininology extremely confusing.  I also dislike
> > > > the concept itself, in the sense that it shoves a weird, specific concept into
> > > > the guts of the TDP MMU.
> > > > The other wart is that it's inefficient when punching a large hole.  E.g. say
> > > > there's a 16TiB guest_memfd instance (no idea if that's even possible), and then
> > > > userpace punches a 12TiB hole.  Walking all ~12TiB just to _maybe_ split the head
> > > > and tail pages is asinine.
> > > That's a reasonable concern. I actually thought about it.
> > > My consideration was as follows:
> > > Currently, we don't have such large areas. Usually, the conversion ranges are
> > > less than 1GB. Though the initial conversion which converts all memory from
> > > private to shared may be wide, there are usually no mappings at that stage. So,
> > > the traversal should be very fast (since the traversal doesn't even need to go
> > > down to the 2MB/1GB level).
> > > 
> > > If the caller of kvm_split_cross_boundary_leafs() finds it needs to convert a
> > > very large range at runtime, it can optimize by invoking the API twice:
> > > once for range [start, ALIGN(start, 1GB)), and
> > > once for range [ALIGN_DOWN(end, 1GB), end).
> > > 
> > > I can also implement this optimization within kvm_split_cross_boundary_leafs()
> > > by checking the range size if you think that would be better.
> > 
> > I am not sure why do we even need kvm_split_cross_boundary_leafs(), if you
> > want to do optimization.
> > 
> > I think I've raised this in v2, and asked why not just letting the caller
> > to figure out the ranges to split for a given range (see at the end of
> > [*]), because the "cross boundary" can only happen at the beginning and
> > end of the given range, if possible.
Hmm, the caller can only figure out when splitting is NOT necessary, e.g., if
start is 1GB-aligned, then there's no need to split for start. However, if start
is not 1GB/2MB-aligned, the caller has no idea if there's a 2MB mapping covering
start - 1 and start.
(for non-TDX cases, if start is not 1GB-aligned and is just 2MB-aligned,
invoking tdp_mmu_split_huge_pages_root() is still necessary because there may
exist a 1GB mapping covering start -1 and start).

In my reply to [*], I didn't want to do the calculation because I didn't see
much overhead from always invoking tdp_mmu_split_huge_pages_root().
But the scenario Sean pointed out is different. When both start and end are not
2MB-aligned, if [start, end) covers a huge range, we can still pre-calculate to
reduce the iterations in tdp_mmu_split_huge_pages_root().

Opportunistically, optimization to skip splits for 1GB-aligned start or end is
possible :)

> > [*]:
> > https://lore.kernel.org/all/35fd7d70475d5743a3c45bc5b8118403036e439b.camel@intel.com/
> 
> Hmm.. thinking again, if you have multiple places needing to do this, then
> kvm_split_cross_boundary_leafs() may serve as a helper to calculate the
> ranges to split.
Yes.

