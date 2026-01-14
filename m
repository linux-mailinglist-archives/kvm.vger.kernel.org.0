Return-Path: <kvm+bounces-68010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F0DBD1D9CB
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 10:39:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5F0F430231E3
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 09:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0264E389447;
	Wed, 14 Jan 2026 09:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WYOnhFN0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC4337F730;
	Wed, 14 Jan 2026 09:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768383300; cv=fail; b=lsXcNHSRZS91V0STb8SfjFt6ABdS3ORbjFz5P9rEzuAhHSf6v1wUXXAfvxYdgSNAUqN3cEBMlK0cShwheVimBv+nGIGZXuLGavK4iY5IXmcPx8V+eZA9/dFV3tMDssM0gJacy+1RRmEcajegbWjj8pgxRcoO9koKJM3AlHrAmoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768383300; c=relaxed/simple;
	bh=F/foWWj5Q97XnGfumvlDleIR8+fxhxWoFs6ET211/dQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bgwhy/AD2GSaUxEs4Tz2a/vLS5iJaCstFr+s8unNi2nJH8toV0TmqLTCjoFuph/4ug6NEGS5UOsSN5z+n2Q0RdIrjA0IV4mjS3jyivBcKGNoBwjQe2BBuXQojHKD26RnS/RH3bIZLHNpCY5kPOBIaTSjvONqrThCPg93QT2cJFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WYOnhFN0; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768383298; x=1799919298;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=F/foWWj5Q97XnGfumvlDleIR8+fxhxWoFs6ET211/dQ=;
  b=WYOnhFN0Mqs47XAGJMkmvSbh6HBQf7f0kmz2WizYY9K4sXhkdWBrZgeS
   BxokVC/8UYd8LGLVB5MkOiEbk7UPm/KoftJVWLIW0M8r2GvucfhRiKQPm
   7hyI+1zUOfmDAXkbbVWQg9lxkUBFGwLviz9eMV7WzqbokeZ6cxjdHW+OI
   zOqvlrm/XG/whCZxFVcgNkFWzybBOkROyESIeFLA80SC9UreAT+X8lOvz
   QD8GEctHQA5385jXV0o9gEAY+IxlcjvuMpZTrli3Ir7C0biSH5KcpnezU
   Rrz78jvctbTowZQ0DuqncagG1rpMKsS3n9MDGyi3N/QIXhQO+Wf3swaN8
   A==;
X-CSE-ConnectionGUID: CpNzXA5/QueytpO19y5cCQ==
X-CSE-MsgGUID: 5K7oS0oHRTK5E96dY6pIoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="69413413"
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="69413413"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 01:34:56 -0800
X-CSE-ConnectionGUID: oa4086dSQR2GijDOVFGLUw==
X-CSE-MsgGUID: Ym4Mf2BrTWaVo7g8Q92+YA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="227772975"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 01:34:55 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 01:34:54 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 14 Jan 2026 01:34:54 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.28) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 01:34:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L8Jmfrx9PiInrlgsjclT8E+AGPuZT3/S6sikiwReCaJFYClh6nKwcm/jQQE/plhvR47xJPTvw60By163Aq9ft8xhpXmbGI/HHqF2DFVBlpT/RWJoC3lEIkXZLGzt/nN2qFGLgNfT5TxTTJV7DgJkoKq/HrA3r63Hr5hxjJbLban+6JV1ohgtvE9F5s7HmdYkUszilyFb26yro/pQd5GeWac4APNe9kghmwSUPnIQlhyietobCxHpDOG4vRkMhlaVC2TtREJTNDlDcCdKENLQLh11o2UL40uECxLBaA+K1iZpcpCQJE+jdE+wrk0F1yZ8h6BXLpkR1MOgWfajOLUKOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1hvx5DhkIppxl3yclV8eXwrcQUb5HVVA4Ws6UEZPzyY=;
 b=OSfwkLVrCNHAhDDcX7sp6fvXKMtv9dcjfu3CRajXjyGY7sS9RseYzvUhG47iaV71UcpBcIkuxB8VX7dzdr2cYOJzCnG/YyEi4CIFFCexsqXm74sKgO891ZizSOGCFOXWc7kySkV8LnM1r1y+HfZ238hfN6hYWJBDRRKjV7CLa0AZuaYGXWwamZnZXOAufh8FJB6puqErt3+UFLpCad+TTB+7vPlJoHQrCmOCTSd1kxcuT2Eng3pKAHhvEBQqMb1vUHydvfNPteKNALZ3yB1c7kCXCpaRiHAys/SpG0VY/lSyuHni74uIw74uvkWk2Q8Qth0i2l1cbwbj7L1Niossjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ1PR11MB6273.namprd11.prod.outlook.com (2603:10b6:a03:458::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.5; Wed, 14 Jan 2026 09:34:46 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.005; Wed, 14 Jan 2026
 09:34:46 +0000
Date: Wed, 14 Jan 2026 17:32:36 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: Ackerley Tng <ackerleytng@google.com>, Sean Christopherson
	<seanjc@google.com>, <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <rick.p.edgecombe@intel.com>,
	<dave.hansen@intel.com>, <kas@kernel.org>, <tabba@google.com>,
	<michael.roth@amd.com>, <david@kernel.org>, <sagis@google.com>,
	<vbabka@suse.cz>, <thomas.lendacky@amd.com>, <nik.borisov@suse.com>,
	<pgonda@google.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<francescolavra.fl@gmail.com>, <jgross@suse.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>, <kai.huang@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>, <chao.gao@intel.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
Message-ID: <aWditFmWX3kOvPiB@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aV4hAfPZXfKKB+7i@yzhao56-desk.sh.intel.com>
 <diqzqzrzdfvh.fsf@google.com>
 <aWDH3Z/bjA9unACB@yzhao56-desk.sh.intel.com>
 <CAGtprH-E1iizdDE5PD9E3UHXJHNiiu2H4du9NkVt6vNAhV=O4g@mail.gmail.com>
 <CAEvNRgGk73cNFSTBB2p4Jbc-KS6YhU0WSd0pv9JVDArvRd=v4g@mail.gmail.com>
 <aWRQ2xyc9coA6aCg@yzhao56-desk.sh.intel.com>
 <aWRW51ckW2pxmAlK@yzhao56-desk.sh.intel.com>
 <CAEvNRgGCpDniO2TFqY9cpCJ1Sf84tM_Q4pQCg0mNq25mEftTKw@mail.gmail.com>
 <aWWQq6tHkK+97SOB@yzhao56-desk.sh.intel.com>
 <CAGtprH8GuKYctwJFJHcztx=q9hfwQF+1_7e8=h9r3u1V_GgzmQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH8GuKYctwJFJHcztx=q9hfwQF+1_7e8=h9r3u1V_GgzmQ@mail.gmail.com>
X-ClientProxiedBy: TP0P295CA0059.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::12) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ1PR11MB6273:EE_
X-MS-Office365-Filtering-Correlation-Id: d25b73bc-3876-42de-a96f-08de535027ac
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TlI1cnBrYzQ0U1VZWmppSS9VZmZmOUtvaFRxUnRuZUpmNGo1OEVFMUhzYnZE?=
 =?utf-8?B?NmNDeklwWkIySzBKS1ZpWmhPNG8xOEhzbVB0TElkK3VvdytXYU4rOGFkeE9q?=
 =?utf-8?B?eHJZenhOWkFPZVlmYXdic2FCM2JPV01hQUNNRGVuTFQzTHZJSnk3Vi9Eei85?=
 =?utf-8?B?WU1RTDBKQVBWM2N1dzJ3UldOMGxaQXNnR0tXeTN0bk5NRTRjT2RvY3ZLeTdH?=
 =?utf-8?B?aUxRbUVVNXlUb1RER2Yyek1ka3ZHYVNhRnBGejg1dkFXTDZKVkRWLzl0UzNs?=
 =?utf-8?B?T0REcC9RemVZaW5HcE80OTFDSHRuN24rejEzbFBkdmRUaEVYMEkyRVhybk16?=
 =?utf-8?B?aWFFTG9VbWZ2aVVXaDVvT2pTTlRDTmRJWGxYSjQxZ3ltMGgrNWJpOXNaSG04?=
 =?utf-8?B?M1BDU2IwWTVoWTFYSWdiaVRCQ0hIZlN6VnRxa2hpL3lzK20wOVFMTTZZbnFK?=
 =?utf-8?B?T3o5dGdSMDNmeXBJWUZpWFZ0Y0FsTXZ2a1FzU040dE9yMGc4NjF1c1haenRM?=
 =?utf-8?B?Mzh6dVdNQVJNLzVWWEU0WnRjcU1UNzJwdGREeHkxOXNod2xVUlBXUEVCeXJI?=
 =?utf-8?B?STVESVI5YmMwMzR1a1Fhcit6NElvS3Fub1hBemlabVczcUlvWVZHV1BDWGVl?=
 =?utf-8?B?Wk5UMlZpUHNQSHpPZGxCRkN3bTgyTFhqNW5qeExyODFmenlMOEZGY2E4WW5M?=
 =?utf-8?B?eXNTcmI1TVR0WXE4aktQNmRSdGpnKy81dSt0QXgwT1ZIK1RtTUtHWmxndGtJ?=
 =?utf-8?B?WE1GdWZVdG9JcDhqdlZkMy9qT1NoZ01uRlJ4amh6aDYwckkrNmNaUlc4RDRC?=
 =?utf-8?B?cGgrb3dvM2pWOU9rUlZrREtrYko4UVpkcnVoRWJvdEZGL0RrbTVyKy9xYy9o?=
 =?utf-8?B?eG1sakROQ0g0NVk5c2s2YTNDdDhnZ0tMUTZuUURaRDUzNzZ2aUdyb3oxQXly?=
 =?utf-8?B?RlJtSUhsbWxaN01wcDY3RW1UTldreGtXUHRZcnQzb216MmFNYUJ5WXJSOFhn?=
 =?utf-8?B?Q2hyOVhvVDBPMmFxN1NhUjFuNEdnRmIraC8xRmNJMzg5dW8rRE9xdm1DZTdW?=
 =?utf-8?B?U2pzeVB6dUloSkg5SXBXbUlZdEJnSC81a2dTOGlydUpjSDUyQ0IwUVNvMGNM?=
 =?utf-8?B?VHdneUdsdWFTU1BlY2MyRktwVVhMUXFqdEJxTUQ5RkJRYnVHellzSGZqd2Ra?=
 =?utf-8?B?SFNYZkwrQURoODdkN3N6MndTb3YvZnloNEs1WUZidFR3TVViRVRjbjNydDlm?=
 =?utf-8?B?Q0RaS0dlVUlwVnBONjJpaVVNN1NjcEVTanNVV05PbmovL0JWYkFhR29Mb2lV?=
 =?utf-8?B?bTJnRmdzNDRkaU9Od1cxTkhGSzNROGduL25TaHlMMkdvVjM5Rm9CTHZZWGtn?=
 =?utf-8?B?aVJvQm5WbDE5R2lkdUcza2VtNXFLc0RWb3Z4L3pYQk1Fa3hKN3dJYlZlbEtJ?=
 =?utf-8?B?M25MazRKeWxOMHhmbkhwK3BER2pHZk1ZK1FYLzJCeGUxbHR4STRrcnNReEtU?=
 =?utf-8?B?VHZQZ2JIYW1Bb1RqQ1pNdnpvUWM3M21kMHBvYVRUL1lwUkR1NmVMY3p6cGM3?=
 =?utf-8?B?VnYyZ2YxTm5jbDlKN1pNNEdmbkJYMEc1OWxhRXVRT0JJREpjeVpoN0o1ZVpa?=
 =?utf-8?B?SzBQUzRLbjF3R1lFbXErbjdrbG5pczlJbitaZ2VSVUlRazAraC9XRFphMmxX?=
 =?utf-8?B?TjFwMURldDExQ21QOVZ4NzlHZnFObGo2Z3ZxQVYrSEl0UDJ4T2l5Ri9zNUwv?=
 =?utf-8?B?VmNVeVJRNS8yaFdGVXJLS1IxenBHYXc4RWFHcUwwMmFJb1RsUVc3YkFXUzN5?=
 =?utf-8?B?a3JJZjhxeUd3QWhMYW8wUmM2NUhOeVpuSHlvM0dHUEw5RGFySlQ5bUpDWFNk?=
 =?utf-8?B?OFFiL0ZMMDdHaGVaV0N0dUE5U3BhVWs1TzJvR3UrTG9tZytJODBjbVc0MFhC?=
 =?utf-8?Q?fpol5fe13ijyAOsUvWeyz0XCmnTGHXMN?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXUxZmk0QUtCUllsQTVRLzJjeHNxQUxscEFHc29lOTJVMGgrZFpxTUdhQTVt?=
 =?utf-8?B?ejJheTl5U2JaekZPWmFJMXpXSlkyV1FDMGxjU2owb3NTUGZ5UWpaZjJ0VGRJ?=
 =?utf-8?B?M09NODZ5OTJRVmJpZkI5WUlnWm1aN2ExMmVXaE9McGdYb3RzN2Z0TUllSVdq?=
 =?utf-8?B?d3IzV2MybEV6N0NDOG9jVHJlenlMWXZtQ1c1bnVKVmVnOTNYcXJYWnFxcmpQ?=
 =?utf-8?B?TXV0Y1daSjlvdjNWMkdLWmlpbkdGcXFQRFJhUzh6VUVFRXlQY3ZOTkh2WWNG?=
 =?utf-8?B?T3RXQ2hLbk1uN2V1bi9SaUkzZjFuQ1JnbUowNjR0VTIzL1FZNFFQZ2wvbkRB?=
 =?utf-8?B?a2toZGIvbFRrY1dDVlIxaDVPYzVYaWhoYkZTU2xpNllzcEg2QnJQaEhXV0Vo?=
 =?utf-8?B?UC9USDA0aytNRy9TbVEwMEQ2QWxCcEc5OGFiaUxCRXFZZzVtS1N6OS9BSnM0?=
 =?utf-8?B?NFBjTHNpWkdqaUk5OEZJNWRJbytCbjdrUUF4Y0RFak12c2E5ejd5M1lVUFFt?=
 =?utf-8?B?aWtWcDZSY1hPSnFOWWhuM1NvR2Q2a0UvekVKQmdzUkZDS1ZOQzlVYTlxNVJq?=
 =?utf-8?B?a1RDVHJKQmpMMCtwYVNDdytFZCsxZkl2UStkRG9NZWFvRmRMK09HZFRYdThp?=
 =?utf-8?B?QUJCRzBjUERFUWhKbUV1TGx6dDVGYnc3UU1PKzl2WjRDZXduNy90aTgwYTdt?=
 =?utf-8?B?eXFiQUxSLzFQQXVmTStRWmQ4a25jZWRnYkwydkJuc0xHNWdTK2o0bkd4NnZO?=
 =?utf-8?B?RjhIZ2RydjNKNUFHYUJWbFJNWncwMzN4TWlienY4NlVNYzNLSTJvSjBRQ2sx?=
 =?utf-8?B?NVg0T2xOUnVUUG9tNlhTL1lJMStMOUFrY1BJaU5ndC9KUHBLRW1admNSaVgw?=
 =?utf-8?B?S1VkMWtpN0VscW1XUW5qNGxrejRIbmpUZ01IUDk1WWtVZVJFeFRDQmRvZWlk?=
 =?utf-8?B?c2o3cTg0cHRMZ2k4RldQdjRBZk9FYlJlcXRkVzRCdFZXT2hiMllEK3hMOWZj?=
 =?utf-8?B?R08wcG9URUJVK0l2VlFGUmRQcVZ0c0IxY0JYanR6dXFvQ0p5cTd3Nm5LaTM4?=
 =?utf-8?B?MHJJODVKdHF6SXRrWVQyWjdDdmZIZ1BFWERiQmFTTWxIeVhlcmVObzR3dEdL?=
 =?utf-8?B?ZnJJSlIrSlZJMjFuVURadXhwZ1dpNDltdkNEMnlrcFBVcEZqeU5QUHNjVWdN?=
 =?utf-8?B?ZnkrQ3JPRTZjTGo3V3FtYVdoMDFuV0h0ajVVb2k5aEFML3FoSzljclRQUDRp?=
 =?utf-8?B?Y2FoODVNMXNwSjlCR1FkQzljNk5Hd3Mzd25UcG5USEo1MTJOQ2NaSnJUZ0pr?=
 =?utf-8?B?YVN1cU4wWHJYMkhTZiswYXlETk8xbTZTdE5ZOWRkN2JpYnlQaFZZL1NoVFh6?=
 =?utf-8?B?cUl5OTZnOHozRFpLNUFwS3NaUy8yRFNzWk1iaWlTdTJ2dVBjNkw5NnBKOURQ?=
 =?utf-8?B?dkI0S2krOGtwRWhrYzNTUStYMzI0cUpybGVrZHVMditzZHpKeklrOFlvSktG?=
 =?utf-8?B?VkJ1UFBRS1VnM1VlYkFVZUtPZlUzQUdlU2VFcW91MThrVUVtSE1ybHdmTVZP?=
 =?utf-8?B?YTlzdnpVM3R2V05NTkg1MFJkQmVieG1hZjhaVlJJbHk5dVF4dTJXYnFkZ3kv?=
 =?utf-8?B?a0lLcElCTEE4b1p3UXhvZzJHQ2pWZ2Z2TlR3K3IvL01McWFvS3JSRldFb0hJ?=
 =?utf-8?B?VWJFVk85bnVWUXdZeEtJNnhjZ1gvSWV4dUYzaU8rSFJLNjdKM0N3cm02clc4?=
 =?utf-8?B?ZlQ5dWVkK3lIVDVqYURjTUR4eTd5ZytjNzBzTmJFamNYUmtUdWVoR0VVZmJN?=
 =?utf-8?B?Ykk1eDIyRzRUVGZlVTBqYzhMOTN1MXFRcVd6Nk1HZmFyTHZhQW01bFNtQm1M?=
 =?utf-8?B?Smw1OUJMdmVxelBSRDEvWWpXdnp4dUl5TlVQRXFMUEZUbVpTeUJQUW9GdDVM?=
 =?utf-8?B?eXZZRkI1a2Y4Q3hkMFJwaURqd29kckpmaVpNd0tuUkJhWnVYQWNUbHU5RW50?=
 =?utf-8?B?L2hybEVnVlhlYmNWWG5sa3hWUVE5S1R4aFgwaGdGMlZSWmV5MU16aVVFMksz?=
 =?utf-8?B?MlArK2VYZTlxSTAxYnlhL3BIQmN1S1picjVIVXF1b0VoZTJRNEZDMm5qMnlF?=
 =?utf-8?B?b005T1RLUHMrN081SWJaYnU1bUxsWC9DOEo0dkNUeDMyYU11aGg4d1JZVXFq?=
 =?utf-8?B?NzJMRFVnN0F0OHp3RFRwcFkyeVZVWDJ2MmhpaTZRaW9lTG82NXZLQ1BqVWNw?=
 =?utf-8?B?OFJBanVIRExXd1hpNEFrM0F3bHJWemZMWGFqZ2pWcTdYNzJWRWdqVjFXM3ho?=
 =?utf-8?B?VENRZVFjY01UMWw4a0s4Y2k5VDc3NzVKYWw4cXdnVG1iMGF2cy9mZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d25b73bc-3876-42de-a96f-08de535027ac
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 09:34:46.2484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4bRfL20jNgfaziyxrnwmVr/KrpxPe1YXqt+T1KM0n9tXdlcZ8+1//May+O8i5oKoB0bhNYk41GHMODV61GnBfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6273
X-OriginatorOrg: intel.com

On Tue, Jan 13, 2026 at 08:40:11AM -0800, Vishal Annapurve wrote:
> On Mon, Jan 12, 2026 at 10:13 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > > >> > >>
> > > >> > >> Additionally, we don't split private mappings in kvm_gmem_error_folio().
> > > >> > >> If smaller folios are allowed, splitting private mapping is required there.
> > > >> >
> > > >> > It was discussed before that for memory failure handling, we will want
> > > >> > to split huge pages, we will get to it! The trouble is that guest_memfd
> > > >> > took the page from HugeTLB (unlike buddy or HugeTLB which manages memory
> > > >> > from the ground up), so we'll still need to figure out it's okay to let
> > > >> > HugeTLB deal with it when freeing, and when I last looked, HugeTLB
> > > >> > doesn't actually deal with poisoned folios on freeing, so there's more
> > > >> > work to do on the HugeTLB side.
> > > >> >
> > > >> > This is a good point, although IIUC it is a separate issue. The need to
> > > >> > split private mappings on memory failure is not for confidentiality in
> > > >> > the TDX sense but to ensure that the guest doesn't use the failed
> > > >> > memory. In that case, contiguity is broken by the failed memory. The
> > > >> > folio is split, the private EPTs are split. The folio size should still
> > > >> > not be checked in TDX code. guest_memfd knows contiguity got broken, so
> > > >> > guest_memfd calls TDX code to split the EPTs.
> > > >>
> > > >> Hmm, maybe the key is that we need to split S-EPT first before allowing
> > > >> guest_memfd to split the backend folio. If splitting S-EPT fails, don't do the
> > > >> folio splitting.
> > > >>
> > > >> This is better than performing folio splitting while it's mapped as huge in
> > > >> S-EPT, since in the latter case, kvm_gmem_error_folio() needs to try to split
> > > >> S-EPT. If the S-EPT splitting fails, falling back to zapping the huge mapping in
> > > >> kvm_gmem_error_folio() would still trigger the over-zapping issue.
> > > >>
> > >
> > > Let's put memory failure handling aside for now since for now it zaps
> > > the entire huge page, so there's no impact on ordering between S-EPT and
> > > folio split.
> > Relying on guest_memfd's specific implemenation is not a good thing. e.g.,
> >
> > Given there's a version of guest_memfd allocating folios from buddy.
> > 1. KVM maps a 2MB folio in a 2MB mappings.
> > 2. guest_memfd splits the 2MB folio into 4KB folios, but fails and leaves the
> >    2MB folio partially split.
> > 3. Memory failure occurs on one of the split folio.
> > 4. When splitting S-EPT fails, the over-zapping issue is still there.
> >
> 
> Why is overzapping an issue?
> Memory failure is supposed to be a rare occurrence and if there is no
> memory to handle the splitting, I don't see any other choice than
> overzapping. IIUC splitting the huge page range (in 1G -> 4K scenario)
> requires even more memory than just splitting cross-boundary leaves
> and has a higher chance of failing.
> 
> i.e. Whether the folio is split first or the SEPTs, there is always a
> chance of failure leading to over-zapping. I don't see value in
Hmm. If the split occurs after memory failure, yes, splitting S-EPT first also
has chance of over-zapping. But if the split occurs during private-to-shared
conversion for the non-conversion range, when memory failure later occurs on the
split folio, over-zapping can be avoided.

> optimizing rare failures within rarer memory failure handling
> codepaths which are supposed to make best-effort decisions anyway.
I agree it's of low priority.
Just not sure if there're edge cases besides this one.

