Return-Path: <kvm+bounces-51150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E39EAEED6B
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 07:04:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B44617D83C
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 05:04:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 551BD1F8753;
	Tue,  1 Jul 2025 05:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U5rHoB0m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA84572627;
	Tue,  1 Jul 2025 05:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751346277; cv=fail; b=sn9klsep0qErASHW/3mC/OqFvZU1F7HAURpmIIFhWxESuaaF72Wf9llE4HdL4JXuD82UNnhaaIHApC9TCbQ8Et3I4Z7KOmpOZ7jtBwyju8F0odK2SbyPEXJiyuuQU8llrBtLKO/ufHkT8eJ2eLI8Mp1t6L3KRz4RjvIUbNFpFEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751346277; c=relaxed/simple;
	bh=mCOOCs+URuL7fCjrThOEt9iGf+ToNfG4zE8voHtVhcM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iADHtbpGp0KyPAByKMlvo5Iszy4bVTkJ3O1LuHjDOw+l/+dW8Tnyw8Guh5g7jA+77E0HPAr4amIkztrRqn86ANfNTQipypJWiAImRxRy+Vjww/bSFo0GwTZr3RKx0W6DlGNjdm2BXx/AP8KidQm8vetKDD3qWcEVtRr1wnrt1LQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U5rHoB0m; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751346276; x=1782882276;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=mCOOCs+URuL7fCjrThOEt9iGf+ToNfG4zE8voHtVhcM=;
  b=U5rHoB0mT48XM/LYgX1aMg4E8JjcIeOBKiBX4TVymzP/RqBn/FkUknou
   GBGLvblKr8hGbY/yqWRwHCPrT9EgsHJ6egPZKtrLxR59MZQjLHZDl0o/b
   GhuJFvtVFwcUrUCwauxhdgAZU9be97VekJuycPwcbNV4Lip3cGK8GE01P
   r731ZoZNthGmyx6t/DU+fJp5OXD5/4zqpIc3IdHfw9Obm1WwiPvZNGzMK
   vVv71z8ah0o71f9R4HgAuj1IW1uJrczlU48vsvr/6AW1PUw2iLMKB05h6
   MIVKACFg3mViYjIH0gPYKNYa2dTjCSBAGxbgyhgJhfXXPlMZVHaZZ4lea
   w==;
X-CSE-ConnectionGUID: scDIzOUcTxOx7IVNE3Dwxw==
X-CSE-MsgGUID: vnRBrCURRXOM5+M1lZl0oA==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="57396099"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="57396099"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 22:04:35 -0700
X-CSE-ConnectionGUID: 90JxfbQcSgCcBqjFXRQDQA==
X-CSE-MsgGUID: bfuDLjNTS++iQTSbIU8yJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="153049748"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 22:04:34 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 22:04:34 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 30 Jun 2025 22:04:34 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.85)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 22:04:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ADCaqSbpstudHi7Qfo67ceU0TKz+j6DtQpWcsZdWblsuxtafd1KICGDL7o7EYerVTlwkVIVqEf1sXcxUqw2O9HMQ18a/1Yxe2lJq4FDTWhW32lUIZYdDRvw8dUceSAZPvDqCM3e+sedFB6CYZC8NWWu/AvLICw1p/nqckF/ETdxnr1gtSnXacJ5KHVDftUyh+aHJhWuvszDxdWEuTn69dTMqgIR0gOE8VsJgDsscHVZRhcb3wUbWmVuVE499HeHXNDbCz1LHA6O/06B7Lc5fQtmgdO+1HQKAg+kTxWdqc6NIcBrMrJtKRE6QhVZbJpoPcyGCzUbcUmzxfzvH/i3qlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X7peaWga1ZWgAds14ga+a4msysbzdHTMM7v2gHb+zFA=;
 b=pJmJqWdILs0lvHhswqEz3wuPhiinf3Yh4vdCTbuQ/NCmo5j1UDAV7mLtJ/d9/jYCTaPPGK1viHnr03G2qkfpUP1jyuhnzH2ZkQTzNjUJvsg1Dwdi72cpe34wQGjONLQR3NHR2dd8TILdvBc/r7Gps0RXqUm/TPr0AigaPUNfJ/n6rQhHt43iROJDAXclwo6PkvNdQ1VRo+/gWCgWCdOWbPAZ+nb0/4JAUFBrp28+cWq6z2+3JPv3O2L3RKdQKDwNXQ/Yiy0mFfpAtTYXivyOWN3d7ZxEuP9eFvT+BrzLBoBBWQp94lmow43Ec14o5e+pNHkYUHbhkhcbxHGwU9f4LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by IA0PR11MB8354.namprd11.prod.outlook.com (2603:10b6:208:48c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.26; Tue, 1 Jul
 2025 05:03:48 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee%6]) with mapi id 15.20.8880.029; Tue, 1 Jul 2025
 05:03:48 +0000
Date: Tue, 1 Jul 2025 13:01:09 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "ackerleytng@google.com" <ackerleytng@google.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
	"Du, Fan" <fan.du@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com>
 <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
 <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
 <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
 <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
X-ClientProxiedBy: SG2P153CA0003.APCP153.PROD.OUTLOOK.COM (2603:1096::13) To
 MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|IA0PR11MB8354:EE_
X-MS-Office365-Filtering-Correlation-Id: f1bac6a3-391c-475c-69b7-08ddb85ca9b6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?5v0qSusjPVMhRZAZa4LW+EyJTrOz6Y1pcFh4mpLJ1Tse6I+ZzBCRD8CPwXwj?=
 =?us-ascii?Q?EgJbdgLNTVPN86Vm28vMBTyKfn7qliLWWfwYJOy3IJISRDDiVhjaZnNriHB2?=
 =?us-ascii?Q?+2bClWuwuwnBNC5a8iM4bqMHWxA/14LJKQxvYoP880Bym/6n+d8o8W4qCQeW?=
 =?us-ascii?Q?3KYJG+pKFb9lF9NGyEirbW2sxO0RublV/RGkcWf0twcdPeqBLjhZx4UawieM?=
 =?us-ascii?Q?7cmVW8EEu4yHgff3z8suOtiAhXMXjbAa0HYq702P2ICup0eBxDux9I5kmZv+?=
 =?us-ascii?Q?Pt2NcOkI1BtW3SQkUpOuqXoLF4eIIJOIlHQ/DTFzibDW5eksNW73LoCINZ4z?=
 =?us-ascii?Q?9QJf541UWP2EXb+krwyhJedMXSglyL84aIeDhm8zK2qz1cOZKl9yWJVNiqUw?=
 =?us-ascii?Q?ItHtupa4D0LwGGSmU4gv7aTm2WoD+WznjZ6aLcWcQklgBJFPen9NWE+oOzYU?=
 =?us-ascii?Q?P0QwGp3i+XalYwskUe+uIC3NIZnh3ThDZqnvZBQI3rQI12nraUgbqq6oIcOD?=
 =?us-ascii?Q?sAEyuV+YoWMNIt4GScRn0084hqMzu1Waio/Y5VHBYeTZGmWsGpZvC/CfafcG?=
 =?us-ascii?Q?f9DA4vjbke382NdaiOGvwr/pl4rAkCzwnzyKySWl4PDJSE6Q3OqYrBjo+YRT?=
 =?us-ascii?Q?xOJMDpZwxi8RqkrEbjDMl8CnFgoo7YNDavBFEB+HgVt2OQjk+nkCdzqNG9gC?=
 =?us-ascii?Q?g1HYTYHr+3C0D0WAtxMYsCRNOmpJ9K1D2uGZCZ2cZSNJ7XOpaSYlevQE0IUm?=
 =?us-ascii?Q?e8EJhiB0FBR6+jbzoAFiuqgVpCbUhZE0QA0Xl46O4/OoJ7mTSJM4Khj6du2I?=
 =?us-ascii?Q?DfjlnAompKckQQSfISt1PH2UTFm24AE8MJNRMNQY0jboY97NSCjHPiYCnNuC?=
 =?us-ascii?Q?i5rVJe7OAynLNQvxzuv1tD9abFFQsuzCV9Z3GLBuWjypMe/+ebVfAX4jwkor?=
 =?us-ascii?Q?Uoa8jqdI1mkTKD7FdHgXwgGoXayolnJn+RDzYV0MOEtCVgDKaDB/wELt4HVh?=
 =?us-ascii?Q?il3kSU5cqXPNtHd4XwYRhPwv7x0Ivg3sJqglhNFPmO/VOPs0Br10sv6e+tVg?=
 =?us-ascii?Q?YR5bhHlfCBogGkfIVTU9M6u7pROcy8GGuJdNH8G0GnN4vJUQ3z97PJzAet3u?=
 =?us-ascii?Q?dfqcOTNgY4sIuDzB4rRL/+IbF7ndmpaFvM8z7bECE5BHZnr3xFj34/lUSl88?=
 =?us-ascii?Q?R42ooN+aMnPLDcV79tuqemGAG+jzHOECNwaB708r0rO97fu04vuQmT1fCjcM?=
 =?us-ascii?Q?1O59L1hdIwd6zvG0Ix/dULASXHUoliph/pdJ0lL63bnJRQZS5rwrWFe5M9WA?=
 =?us-ascii?Q?pbjfEVuSBDq5nDqwl8zDQXIURZYGtWtA35qW4HAHM9VNaPzVaNIeyc0XymW9?=
 =?us-ascii?Q?U2bHwifKFJRB90l3QgFxIQZc/abVQK/6nke4oL6pTIOhGjcrlKMwl8qIT4N4?=
 =?us-ascii?Q?QSdI1IdZ8aw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ufjYUgvNHPj6m9ui5HauvHCk4HRmSoP7SY/ZZTnJyZTGCpHkrznKC6GK7FhT?=
 =?us-ascii?Q?CHs8oGftSdOrN1GFfTOZCzeXyYAEHdeqH4v8DqfjQWk3DfmDDyXMog3reTcB?=
 =?us-ascii?Q?b3rbY2j+rhnR+ZHB6lw1XOw0HqtegZsuISHgU9e1fk9dM7qjGaoLPtRHC7iz?=
 =?us-ascii?Q?IKh0rwRajJZtGdWkbpbcP4QZkaDAWhxYrCw3HelgcPmnirTCKVS7xSeMDMtl?=
 =?us-ascii?Q?rFOz16Sf7K2zmsBdfLt0pUmXBoIiX4gJXdXR0tEaSGLXsGMwprc7bGKtOwJe?=
 =?us-ascii?Q?yfi3wISnRMguYi4NySgs+MsasGlUUb6KAQX6P2gQRHqPTOT3csOu+pclxZKQ?=
 =?us-ascii?Q?b7ScyKn4KoIyrP49RZzRdQvsLMF9qzgX264U+Nvw8z5I2jx4kWG+bFp4FbwW?=
 =?us-ascii?Q?pKbPKT0XEbvPm0ST9N8u/jtlsWROHnKCfD45BmUJTvzlI90G6ertoH95widM?=
 =?us-ascii?Q?Pz3VkhxqQ5Z4kZtU2rNUpglgdDjIfjDhgG/6bQ3fswxFg1U0ApYknPmoacdS?=
 =?us-ascii?Q?9FJZEVLyePtJ+F5kfedgB0WiE7+E7R7I7f0/AWDA4ABkK/bW8ykk0HixuV4g?=
 =?us-ascii?Q?pGZ7XYDkNHtCoBSHR77e2xCl1t6br24OZHOfOjLsSwjJR0qoCvmKGYqEjtJV?=
 =?us-ascii?Q?63E5nvCN+uteOeNI9RfUaihzZj7liAdEXuaLoT6oJex3fhDLQQnIhs9zq86L?=
 =?us-ascii?Q?65ggjRAv//rXtUuWmVfZWFW2Ni9HNuAQW+APaQXLRccVMiUMFBec50az9wOs?=
 =?us-ascii?Q?JYv3vGsrJ/jqNFk90AKxnReO2SJ8yZuCDGoH1EjCApcfYQb3yJXAdyRtNiKh?=
 =?us-ascii?Q?KbICS4pIHRsJG1x/NYMZOcQAKjAHXVbshdzYo4pXGqJAbf5NsP6h59YaDYqi?=
 =?us-ascii?Q?fYopEPEfQxUHDMDjv/CmtyAgSN9iWExWHywVXsWDPbGMhitertVV3FxWScs3?=
 =?us-ascii?Q?kMNjargWOkew9TGWbSkqD6gfGq9oBjolLrA1XNsstM6S7zzsygtmCKHS8P2o?=
 =?us-ascii?Q?Glsr+XrFvyQOkahyxa7KoL0Jw6XnnTv3QLDnqA/dY8dnlmkRA9MB1hWB3L6q?=
 =?us-ascii?Q?30DcYN/Y6aqKYtWIdjH5uBhqQSk+Oqm9mJXEb8tNDzgOUn9s2W8DsUrFt9On?=
 =?us-ascii?Q?EWTodgNnhEQsn0lQBw97PyWsxAFdjbvsjGljkBI4tVuzioe4Xa64MkO2COlz?=
 =?us-ascii?Q?EqXyTS9mximdLiegn/EVpdyLOzJYVkpyzO4MWr2gvrZLVe4Ikz4FVmrsc4yl?=
 =?us-ascii?Q?jSgJJvay46mb9m8ogwYn/RaOQEdupsC8a3bHYx1G+CAY5tuur4LZ1m1AJ8nf?=
 =?us-ascii?Q?3XVlwzJo9c07h99/d5V7cHScqGDczZTuEWVx4nphzMNAnoG21z9Dfyjc2mpE?=
 =?us-ascii?Q?ZjWsp6faQbBZPXkVDmEC6k3qVLoDeoseOcSKRuWu9as5Lu6v1/HFbiaS3A8/?=
 =?us-ascii?Q?y8fwFgEXJ9czj6UlJaN+ttWUfGfrGYglEfsEY2fkzDX307bXop81nzDbRuD4?=
 =?us-ascii?Q?E+TR9n6MnBAd+uIVOd5SsjwtqSjYHwpkV1HVByvk2QkElEE2ychzrsVJUgns?=
 =?us-ascii?Q?JdsCqGC1qTHsJ7WgIJDDfAdkOcm9CKaGg2eZfIll?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f1bac6a3-391c-475c-69b7-08ddb85ca9b6
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 05:03:48.2619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /45pYUq1rsAMHyanUDerIY66eDkUWmqvuZZC56NszE6ueU/nC5QolVoTnevaWzN6TD3H6Zybj5uQGPY7RtQvIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8354
X-OriginatorOrg: intel.com

On Tue, Jul 01, 2025 at 05:45:54AM +0800, Edgecombe, Rick P wrote:
> On Mon, 2025-06-30 at 12:25 -0700, Ackerley Tng wrote:
> > > So for this we can do something similar. Have the arch/x86 side of TDX grow
> > > a
> > > new tdx_buggy_shutdown(). Have it do an all-cpu IPI to kick CPUs out of
> > > SEAMMODE, wbivnd, and set a "no more seamcalls" bool. Then any SEAMCALLs
> > > after
> > > that will return a TDX_BUGGY_SHUTDOWN error, or similar. All TDs in the
> > > system
> > > die. Zap/cleanup paths return success in the buggy shutdown case.
> > > 
> > 
> > Do you mean that on unmap/split failure:
> 
> Maybe Yan can clarify here. I thought the HWpoison scenario was about TDX module
My thinking is to set HWPoison to private pages whenever KVM_BUG_ON() was hit in
TDX. i.e., when the page is still mapped in S-EPT but the TD is bugged on and
about to tear down.

So, it could be due to KVM or TDX module bugs, which retries can't help.

> bugs. Not TDX busy errors, demote failures, etc. If there are "normal" failures,
> like the ones that can be fixed with retries, then I think HWPoison is not a
> good option though.
> 
> >  there is a way to make 100%
> > sure all memory becomes re-usable by the rest of the host, using
> > tdx_buggy_shutdown(), wbinvd, etc?

Not sure about this approach. When TDX module is buggy and the page is still
accessible to guest as private pages, even with no-more SEAMCALLs flag, is it
safe enough for guest_memfd/hugetlb to re-assign the page to allow simultaneous
access in shared memory with potential private access from TD or TDX module?

> I think so. If we think the error conditions are rare enough that the cost of
> killing all TDs is acceptable, then we should do a proper POC and give it some
> scrutiny.
> 
> > 
> > If yes, then I'm onboard with this, and if we are 100% sure all memory
> > becomes re-usable by the host after all the extensive cleanup, then we
> > don't need to HWpoison anything.
> 
> For eventual upstream acceptance, we need to stop and think every time TDX
> requires special handling in generic code. This is why I wanted to clarify if
> you guys think the scenario could be in any way considered a generic one.
> (IOMMU, etc).

