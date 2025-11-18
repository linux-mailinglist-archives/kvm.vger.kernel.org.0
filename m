Return-Path: <kvm+bounces-63458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 99A49C67017
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:23:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7440D4E9BC6
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 02:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA10F31577D;
	Tue, 18 Nov 2025 02:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dFH9RST5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9D0279DC8;
	Tue, 18 Nov 2025 02:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763432575; cv=fail; b=RK94AOg6gNFFBzzO9isf0XmZ+8I2t1q/Of++WgxtSlGTURu6mUaFnA5gWLKyfRhL6G3ukwvdyZKeoiBwvYgbKjoup2KeGd0BB0KCjR7z/uHDmHvMbEyTIjH5C7aZ1QvYi2PHMLQYUuWpKE9pj0vEgQyXiDzwNdf8NMB0FdBefKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763432575; c=relaxed/simple;
	bh=sLvPSjNM6NDqzfO5HufsJYhpbhDpi2rZAK8B/oz+PIo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r+VP5wJ2YZgPBSLdNCTgs6BJCZsn0BxWLeoNESj6Ku5BYWrTRXijnvzuhhhi/1vU+57v1rYUUEF/9cR393/5PLyAiEM1nxwYsuEZ+t8qgL5M+y2MM5VdBpB+GvRAyznHy/AFQcF5sj+54lHNDEg0/3PKY8S6N5tVbCH0kIuaHK4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dFH9RST5; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763432574; x=1794968574;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=sLvPSjNM6NDqzfO5HufsJYhpbhDpi2rZAK8B/oz+PIo=;
  b=dFH9RST5JNCAv92ujMmUXUDDhPx83bJAM+Kk6g0+Ls/1M5e3Fuvfx63C
   6xYQWB0lLzDXG8Oz3/OqUXRm/GsQCvNS5bKyNtg6I6U702aOwK4BBSxd4
   z9CwV2cdWFjfiWdTHET/DtsqfNJsSH1Kc8Z0iOfDDOqHrqFsRJUh2saW9
   Z124vb99jAFrnPEEDu5zlxvYFkFJHy5wRxcPxEBnBlyokJwGfQ5suBA+q
   4YOT9Bxn6DpWJG0rWH2IMAyRW1sMkOMGfzTbnSMW4Q1A9ZS4OKeZOSfS9
   ndgXLKnR5KpGLjzzMEHWY6akNMi5mds91QpafwcksSR8Rk9Oe2dBSQxH4
   w==;
X-CSE-ConnectionGUID: fYJMRUFXQNGsWFY41zlmBw==
X-CSE-MsgGUID: tPk64PWHQu2fMFbizsYbag==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="64447348"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="64447348"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 18:22:53 -0800
X-CSE-ConnectionGUID: 47NjqvCVRV6FWfrnqpDGzA==
X-CSE-MsgGUID: JvCIJZk/TWOR0NC0sSxOHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="190417167"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 18:22:53 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 18:22:52 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 18:22:52 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.34) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 18:22:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PwQkLA9r1VXiOBa96CviMoDWG0vYMDQ+saNmUmcKyXnjmQPAfX2NoXgs3efqNDMpxLBqV6h/IZ4dSyGJCkdduqLDquVQriz/FhpKGgQWQWC5tqYWC/kpHQKKElpnikFlQzikKqXbUsDJcNyNg3y0Tr3o79h44ne5bECpvgQF6ws5y30smyqO9v9CWUUrtxMDJCME7KZgyjUTl7pHC5K+pPajEEiWzzkSl1GIEAe5GwT/M8K/lHI9OHqe3KujfrSu+jJnb3hFHn5AIHW0krwyNi8HVF3CUEH6N/lhS7S3E5IzQsKTddtjiV3N7FnWNkdrqcFXRoj5srER6s5coyR+aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vPqaMkIuhMaqV/mjTZKdEllgBB8XwlxtI/75SoMf40g=;
 b=IblWHZVfwo/jbHTPQTiLECphdMpQo1XhAfOWPS8Ml4/kGOuIPfqXMv/eJzBJ4iEUsFUS59qL5rIVOuDnvzBMRMX4gvSGTamZ8TzfIj/+8Kze4shmdoRo/RHe1l/QujRidWbjFHWRtgUp1aFwg8l+RJsMrd+B0qiSgtloKzAXfXbq4ZoeA9Jwk6CFJyWnZuErNIJozi0IoCqhBNNbHUebN2x82c7qDOXZGr0kZQAhh1kOf5taIlP8MpItFvCuJEMGHXNIeZZXsLqUAGLpQyzuflkx4WEvKnkKWvXb0EbQYmfWokiyrl2gAHf+8KnEc7GUqyDGlyPGs1JEH78JpPjGJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN6PR11MB8170.namprd11.prod.outlook.com (2603:10b6:208:47c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 02:22:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9320.013; Tue, 18 Nov 2025
 02:22:49 +0000
Date: Tue, 18 Nov 2025 10:20:39 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kas@kernel.org" <kas@kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings
 if a VMExit carries level info
Message-ID: <aRvX9846Acx8NSZ8@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094423.4644-1-yan.y.zhao@intel.com>
 <5e1461b8e2ece1647b0d26f0c3b89e98d232bfd0.camel@intel.com>
 <aRbYxOIWosU7RF1K@yzhao56-desk.sh.intel.com>
 <6635e53388c7d2f1bde4da7648a9cffa2bda8caf.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6635e53388c7d2f1bde4da7648a9cffa2bda8caf.camel@intel.com>
X-ClientProxiedBy: KL1PR02CA0024.apcprd02.prod.outlook.com
 (2603:1096:820:d::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN6PR11MB8170:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f5708d4-7e43-45c9-1c16-08de26495e87
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?xDUPr++6ZVqQEThkdArzvOo5/KprmM0AGOCsd+zNSRFQEPoJwlfuJKyYIK?=
 =?iso-8859-1?Q?M3RP46u+w43qFDSOn2g3Z88zDK9PVMk3Yqpsj0SAlBsz1f3z5IqLM+VmrS?=
 =?iso-8859-1?Q?u9m0fjzQ95TXISSfVecefLg0DeraUoHNOMnAZtM4DOJLfHRNSpqJBXYBgM?=
 =?iso-8859-1?Q?EXyU2AwXGXA5mRjGWILUF5zeaFhHud7LyRFCO8VHVNo8oDLP7W8YGCUPSj?=
 =?iso-8859-1?Q?MJC11mH85x7sGrlvfEaAFaNeNr8GSn6nRh6JWNhKdrSSZsCg3v6GhG80h2?=
 =?iso-8859-1?Q?G5uz1rFNh4NtrVP/Lnh+A9aba4sL5GEaYVqPuS07IJE/QHai/Ahor8xaVI?=
 =?iso-8859-1?Q?glOlKk6vpXI6ckFbyIQkbxfTKElJNoOZQLxgdyod50EqReLv1e9vzCvYJ9?=
 =?iso-8859-1?Q?e1dGGo0UwY/8zk/MX3iOx8zb5M0sQ1GTDoIAH6Ws8IctG+5e9gApbZXTOM?=
 =?iso-8859-1?Q?AHGWCUgAMsw3IKGfVCSL+z0aWkV9j6p3hKqsCjg0SuNd76BIrBPP53iRwd?=
 =?iso-8859-1?Q?U/esqPM89DZVgDK7PrJ/CztasMInGB+SlLiClo6rE5aZcxoeap20h6eBKc?=
 =?iso-8859-1?Q?kNQMLQUCuEDU0AsD1bQzWSk83kKKYM6hA/k8gXGdE49V5ENlSeEfohHJYa?=
 =?iso-8859-1?Q?IEAwHAGzAdPMk7kG2JqDChKw2WLclnQpRYjbVdcNxxNyYOCnSjybrui+ns?=
 =?iso-8859-1?Q?VjwkiSCVaoF8UYtbjulD0C+NLfNUbg/PIZ3vtBp7++lWYG7RQ5n6aAQTXK?=
 =?iso-8859-1?Q?I7dD4YEKrFVxq0/GTuucMDl7tgnCTjYZRtPfsv7yzIqbmUDVJ2ael1Haj+?=
 =?iso-8859-1?Q?meYPMjMW1/kEMfCi2yAykaOe6Gzg/Sy5VyXM5Jt7hnZIbKMEvpMH8B+xwQ?=
 =?iso-8859-1?Q?Cb0E/zDMKQ04DACD04Rmo+zMPiTsA8IPHYwQLMf/I2/5KqVsNqwAvzCvLO?=
 =?iso-8859-1?Q?hC2UcPiamodUuea4lnLbLx6tVlbBjWcRofk6KZ2JT2LJf8B5at6ulmnfQG?=
 =?iso-8859-1?Q?ZeHlSnmyk4M0ySVA6huQVpyJqKIoTrI22jfxBUtvTqzCL6jsRvSAQITWbF?=
 =?iso-8859-1?Q?4nE8XNCKAbV3nPOy/BMXE8gxygTeOBqXKSTrjIdHGkKplH44t1RexHWp1r?=
 =?iso-8859-1?Q?0B19U3xMHODvLmOgvpWXPziWXDgqpGsZkHEJxQqtUKIZYlTXxn6OsqrpwC?=
 =?iso-8859-1?Q?hsFwDQiWTv77c3DcHcJ+MudfnHByIRoRdCDLMv5fqQqps7+3RNi92tQ+Og?=
 =?iso-8859-1?Q?trfeA7jyT32/5xoeVClw5tQG2X/696rsG65TZKMIp8l5wcMJHeuS3vDaPf?=
 =?iso-8859-1?Q?VvQciZJaymvxOW59F3s2rTz860LjKMkAH02+GsQwBO2MXTHNEGjPqQ+EDs?=
 =?iso-8859-1?Q?UnykurU9vxOk33RltRZGczVFK71Kafq0s5kvZXdBHyW0cv+61/yJWcXyfZ?=
 =?iso-8859-1?Q?bWHzPdXGHW26aAi7FadaQBclC1gg3Qwf7b6T4L48hiCEeMrGgZMCkVaUjI?=
 =?iso-8859-1?Q?WAP1OWFakNvAsE2KXaJUpd?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?pIebpi/Z5r2Jj5xBt5pOLycNM6vPUWIwi/brdbYjritLvHjqfaf7O5Pkcg?=
 =?iso-8859-1?Q?iMDxjxFNBzjYzKqop74x/KJKPIT1wW+5IogQq6nhxgthGBtOu2aNU/7+Nr?=
 =?iso-8859-1?Q?ibUCv47qeormVFvswAUBbaF6G+jYtkSn6EKFTZNEzccTtVBPJYUUk7hZCk?=
 =?iso-8859-1?Q?77JBV6LEMR7Vo8v85r546VlFDd6oe5dsNH7atthCxM1T85HlgGNg3ThXaH?=
 =?iso-8859-1?Q?7gCWoWWYR6k6D+Zfsp9hVFF6q0YtkxFdAju6cpttPZUTCxgLFtZbIzZmcm?=
 =?iso-8859-1?Q?jA8fZYGLuCLCGowMsJb9EgC1scCIr8V7FFuYkvt71wT/CE7Y69QNKJiA+R?=
 =?iso-8859-1?Q?ttxvAoWVAS0WY15ycH5mUmMfafLZSfDg1xiHD6wVk0cmz13O7GIGA+cUEz?=
 =?iso-8859-1?Q?u+6+uIHHQ1q+WMQrQzTNLNexq1q35qS08zRprXwTD3SdZcP2cS+IBYDw9F?=
 =?iso-8859-1?Q?JZRPGJ2q01hdC1WvkOTKxI16+79M2L2N7lunzp78d9FZj7n7/2i7NDz1YJ?=
 =?iso-8859-1?Q?jzCkI0/DklvCY0FgqB/r5oyAeWD7egpfYt6dOziYBScDD/OktfuUhQvor+?=
 =?iso-8859-1?Q?k2jdTdWuKrnlRTl5JtbZTyb0rgajkJ3kCBE9b6/mg5pcOM1JT83DTBgGGp?=
 =?iso-8859-1?Q?loOMcIuqvASAk78v3IquvpowKQVOi1xof6AEoTg+RYKePBdAnputJ2Joyz?=
 =?iso-8859-1?Q?/EVS/RiveJFvZCXfLBeBOOmUENXqgDNlpOJ2v0fOaqzYfDUw2Bj0f6JJQ+?=
 =?iso-8859-1?Q?LYUd2sWg/zlP8/FlZNk03a71CWyoKXcmX79MeFVCMjXeMOVvrpOpbzsG+g?=
 =?iso-8859-1?Q?hpGhxi7z+VTw/oOPSo6/c4cZ3GJB66NCq3bb2t5UmDYeW59HZSodVLhhdK?=
 =?iso-8859-1?Q?zUy+4KSabC5bPq/xoRKoCYBG6VyudTYpaBPmrqTzCSOHDm5s3eNVpUKZTj?=
 =?iso-8859-1?Q?UghwuQeZNQRgX0nxjGDgDNx7Qilkav/1Y9662tNVYjmrLGLFNAr0LvoI4Z?=
 =?iso-8859-1?Q?sC/qtnbesh3iA4/dLbuk5qqp6Ysb55o77WboaIft0eBPO2M9Mr4BnvbweH?=
 =?iso-8859-1?Q?WSbxUAB1k3+Ub13AWIaVfH1Lwcbxih1GAD/WQkNoJE+nf6IYsw/lpivoyN?=
 =?iso-8859-1?Q?32Y9leetjOFIHVJUDf4bSqFBKdUrfdX+bTR1mN9B8HzdhDYWz/BTxv6Jx9?=
 =?iso-8859-1?Q?ecb8mx+v1j2Js+naET8j5QaNP58eqjd5fChfAsFP8VW8oWuyEWKsmAwsLK?=
 =?iso-8859-1?Q?YYURVckhFAg27J0Ym6yjjsQQN8lPRwzBupv0pcqxDFlce0l0h+zA5TKc/1?=
 =?iso-8859-1?Q?D9IGiptqm5j4jlvlACY5BTIrJobyI7wjsPZXK4srqeBJwCRqBS16sVjCrG?=
 =?iso-8859-1?Q?jaxd8j92ys4Ai618lKlEj/nM7ZoQ2uB0Jmq2+qwQbcckRdsCm69IOwtche?=
 =?iso-8859-1?Q?3ZTEVwbsiJ6qKy/IN3jCI6wHGDcuC2fYnBCpm1q2oNrH2QwAurOpI34xQF?=
 =?iso-8859-1?Q?U4n8wBfgNKvEFhxPIUrZJrkJdIk+0+w5RF6y0zO/ertUg67lBMOfyx9aQR?=
 =?iso-8859-1?Q?tuxgjTWZT2vIDdKTorzHPnfeMfzW6ktVJlDg5MRBYFFBDHL1NyJABJUFv+?=
 =?iso-8859-1?Q?e2btOp+KTYcrvrKjRJnkT2Ut60sK4H2HkW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f5708d4-7e43-45c9-1c16-08de26495e87
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 02:22:49.5294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8iFC3dvaItbkHoiloolOH0MRpI1ZPHSZ4R+WgxbV/B1R3FYO11u0Z8jCgs545BKNiJ3qAMhdAg8J5S+IvfYZkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8170
X-OriginatorOrg: intel.com

On Tue, Nov 18, 2025 at 09:04:20AM +0800, Huang, Kai wrote:
> On Fri, 2025-11-14 at 15:22 +0800, Yan Zhao wrote:
> > > Will 'level == PG_LEVEL_4K' in this case?  Or will this function return
> > > early right after check the eeq_type?
> > The function will return early right after check the eeq_type.
> 
> But for such case the fault handler will still return 2M and KVM will AUG 2M
> page?  Then if guest accepts 4K page, a new exit to KVM would happen?
>
> But this time KVM is able to find the info that guest is accepting 4K and KVM
> will split the 2M to 4K pages so we are good to go?

If guest accesses a private memory without first accepting it (like non-Linux
guests), the sequence is:
1. Guest accesses a private memory.
2. KVM finds it can map the GFN at 2MB. So, AUG 2MB pages.
3. Guest accepts the GFN at 4KB.
4. KVM receives a EPT violation with eeq_type of ACCEPT and level 4KB
5. KVM splits the 2MB mapping.
6. Guest accepts successfully and accesses the page.


If guest first accepts a private memory before accessing (like Linux guests),
the sequence is:
1. Guest accepts a private memory at 4KB.
2. KVM receives a EPT violation with eeq_type of ACCEPT and level 4KB.
3. KVM AUG 4KB.
4. Guest accepts successfully and accesses the page.




