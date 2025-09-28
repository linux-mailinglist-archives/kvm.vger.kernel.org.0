Return-Path: <kvm+bounces-58934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB421BA6B82
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 10:37:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 024FE189B839
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 08:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FA292BEFE7;
	Sun, 28 Sep 2025 08:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bY0ATk8Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394AD225791;
	Sun, 28 Sep 2025 08:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759048632; cv=fail; b=TrycF0C/v4A5UgwnM2JNGDPqea8bQJwuZ8mXdXUtd7xuYFm/Q6F5Sp7SC6whrMFPw+PMXYvOc8dWWdNpvH5+9YG+5hD7O6Gp1i9Fic+Zhp02Kb07G+xRgPdOCBTIXw4124KamUoAL5tntjBIp5kNbj+dxCcgx6uS5XzGnJQq/ag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759048632; c=relaxed/simple;
	bh=Fs/CU6IQs2oGVIKzA8SY1c+fSAiRmsu4pd8+WXB6VVw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UPES2w08Wrr5LMO/OF5jsHdK3zT1wKmpfLmSAlG+I1hzInPTGNDn1jxciuwLypNmbu5QTTZTrx2HJPu25N8Mp0EtEsUCZ9HcKAUJotG3FlcqCM0WwegIBvOJ4rOLjAokUSYrsr6f8BgqrjncuXgHoGshtwZUj2X8+pZEvi4TsKo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bY0ATk8Y; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759048630; x=1790584630;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Fs/CU6IQs2oGVIKzA8SY1c+fSAiRmsu4pd8+WXB6VVw=;
  b=bY0ATk8YdQRAdEGk2H/+w2MdyyWCEQHX01MljqIlj5vZg9MYhAYb+iqG
   vrDZs/SNDPX6PA/fFT5i44nmnhk9LXwpY/BZi/E/f6I/JJDsQ4JpZPv0j
   pTdYz0JxghxSz63lhsBLUXvyRWLu7aLKPNklFVAkZ9NTbDApHJdbeUSzS
   5U61EcyNKHO9/7VltoJv+NO7gKWqrKBaTYfd8AYXX1l7TLK5T4og1WSoe
   4ZiCYSvuSWgplNzInOdST8bf3+hcFLupZN87TYbOQ/N88zQr+6i/jT85n
   P9chPRPNq5x4l6z9wm1TP4l8UNg+aucEGw1QFjOLeHU6XQ8Nv+S/ugSVI
   w==;
X-CSE-ConnectionGUID: uBX9+XcuSRmnQfVIaES9Rw==
X-CSE-MsgGUID: /M+W1bTvQyCqqsXzV9YXzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11566"; a="86768202"
X-IronPort-AV: E=Sophos;i="6.18,299,1751266800"; 
   d="scan'208";a="86768202"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2025 01:37:09 -0700
X-CSE-ConnectionGUID: kr9a6IV5TbWHrjaEiGI7fw==
X-CSE-MsgGUID: Zs/Kxv7TTVu7EocvUUSkPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,299,1751266800"; 
   d="scan'208";a="177550323"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2025 01:37:09 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 28 Sep 2025 01:37:08 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 28 Sep 2025 01:37:08 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.26) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 28 Sep 2025 01:37:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EqoZv1G1f9dZK7DYb4NriVh3u3cWvh17ldADpgRsUpAktRFrPWB8KKkbe292BFVlfWKuQfgk5R1fQKb+NEmql5BNDnHylFCwEgqg8LHIGAdc/Yf4Fx8ZIzmmpwBeficdgsOHQ4yvqe2sZapBuxG/SEwVkI1WkdQvSZf/g/XLABFCjapQmyVL44aRxP55y1Ew498+cbc1H0w4nkE0nP2jlnkxFrI8Mvx1pCOVB5ACNB7yyJ0SxErHuIWrWcNcjZbomH8bubomhK08NMHyyVO78v7U7fCcO4NzxoPPQQBmYJcYCfCf9bieiCX+0tICqkwpZyFxeDFgtOPogopNVlrTiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9TAEnA8U9OV4jRGhu6s05pTbjanWtdCrimRNbcsUmg=;
 b=jP3YJ1SI/2g0jjnfS8yt+/wCwGBbzQKabMcmosndD0yYafhjgrBfZUqIxCUOA9G9iWW6baebPCM8NDS3HDHbpse7rHIh+XLFTDONqWpZ1UQKKwql8VIJlB+i9CWtbMCUfyoPok7jWfqBfzbS5oTysrgZPQrXnGQcF9fAhOJSz1ng8fpnhjHO92FDGou6JD/n4ag652zv/IO5KM1/kwur807120kV4oUfcf6dmOCt/sZEeUSzGUV4sK60hnBc8HpMuzxSCkiIkZT2Pe/p1Y1sgFh7RiEHSbCsvSXKGF9g63/PH1vabKIj2x8VJOPw2qyBr3wgZWmz3GU8Nv8rWJM/kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ5PPFE62D2CE76.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::85b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Sun, 28 Sep
 2025 08:36:51 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9160.014; Sun, 28 Sep 2025
 08:36:51 +0000
Date: Sun, 28 Sep 2025 16:35:42 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 11/16] KVM: TDX: Add x86 ops for external spt cache
Message-ID: <aNjzXoyP86S+Sw9y@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-12-rick.p.edgecombe@intel.com>
 <aNJGP6lwO9WOqjfh@yzhao56-desk.sh.intel.com>
 <9f18cd1aa0d51e7cb7bb2cc360f67b8cf92ed487.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9f18cd1aa0d51e7cb7bb2cc360f67b8cf92ed487.camel@intel.com>
X-ClientProxiedBy: KUZPR06CA0009.apcprd06.prod.outlook.com
 (2603:1096:d10:30::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ5PPFE62D2CE76:EE_
X-MS-Office365-Filtering-Correlation-Id: ab8a2e88-c267-41cb-0aa3-08ddfe6a2bf2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?OtSpxnS/uOdXktAnOlZqRYRD8ukg3zJVIvpOAhrN/m68+ChmtnIkClv1oa?=
 =?iso-8859-1?Q?vyoMHff0g36TTHjr4jrRmyauN/oeE+y85bY7lTwRNrWYO69sUjYqVun/P0?=
 =?iso-8859-1?Q?/wmtJXl00fMRMly8Ii3IZHdQk1s7IX+caYOWhNhfQ9YoqmfuX732p7c8tV?=
 =?iso-8859-1?Q?W5DMtUZhgMQsDdyZMFmZ+bSIznralS71Qy2b0frW5UynuEgWaXFU/IsneZ?=
 =?iso-8859-1?Q?uWsVT44Ye0HPPSnyOZC+TZMbMYJJrfr/GMboOe7xHvsJ9+kXXUtLaMYSfj?=
 =?iso-8859-1?Q?R1UY4OeCq1UdR/VeKOcJpJoA731LqpIwlvAAOQE1HVaLFNs6L4dsxbb7qB?=
 =?iso-8859-1?Q?5a1Z91kB/mQ3AcI4EO7mMBz0vuQ8iaIU7zIiBJjpLfeqv6dO5gX232y//H?=
 =?iso-8859-1?Q?fjp+PySa0vhTehIq/ePNl3Yf9MVpp4vqm9J4lWIeA885SIbR/+2uJ5Lzlc?=
 =?iso-8859-1?Q?qqFBmCjgV9m0UsHpxURpvsxMsyTvvGyLuIPGS2uusdPlRnwRrzpdFWqfv8?=
 =?iso-8859-1?Q?r9JKMcZ36JpeFihWMu/NuoBA5HRh45qAHknZgnIovi05y9uZQrg52qjUW7?=
 =?iso-8859-1?Q?4obnQ2+Bs29ur+3L+7/4gAJEbzfj30eEWe+k4xOhjbMs+3YMh5A57d/lua?=
 =?iso-8859-1?Q?ve1l458u/Bl8hdRjxlot5ynIsBSoWykCQ/6Ge333DLMM3f01JSz7CyjTQt?=
 =?iso-8859-1?Q?G9CGNrd0pzkhhnWTJgMSb9GYD40Eu/Ge+aQxVJ3sFumxvVryG5XZrB0VJt?=
 =?iso-8859-1?Q?CN4KdX2y2y7v7r2aKdzgeH0MNAmYO6tAl6P/v+YpikCY4VUy7pDKvKBa+a?=
 =?iso-8859-1?Q?vWGWUgNkmHpiw6gJtw/oeXH70zkqfc7hOs0LpxNXwMBZpiMhnvmEyMLSlR?=
 =?iso-8859-1?Q?yrZ9CF8wHuhiFWEa0plZJN4+QTtSltbTFWUZYh/3pOYUqjy99bfkpSlqXs?=
 =?iso-8859-1?Q?mNXBlLarJv+E3xAmcr+IgHaUbkjtc6iZXzRUtucjuYAXHHkv5i9HWr7MDn?=
 =?iso-8859-1?Q?pYLEyFeakdPtj2XSC25xbRzoQ3Jc7uTRCXKpKntDD6YJYtwBUP/Qll/b54?=
 =?iso-8859-1?Q?DysV+0ok3yS1rElDKZTd1ew7CiRZqnK9dji55NyIRZok/HsP0ui/Ep4UPG?=
 =?iso-8859-1?Q?nEQeJrH34Dtq2s0DVjlN4DuqEHiKmGtg6NHCJ8jI+ignLlX0sNka4MBD0m?=
 =?iso-8859-1?Q?m5MVb+DXe0GKNJ3u/cyzz+CZU12jdmMna97JNUY88I4vODGA4tOZxD0Q9e?=
 =?iso-8859-1?Q?mb7Z5g+axRTomA0xwAYiLP5+9yu4iFPvPYMTnl1a4kxYVFkDhf4I8+NCZo?=
 =?iso-8859-1?Q?I/M9eYvHslyxnonB/G+DqvJgucvSg4RJQd44DoY16J7MsgQuOC0r4wXx6c?=
 =?iso-8859-1?Q?qaxUjMBbU/naO6qUz4POQM7uGzTj7CRQiEzUaqwXGG9t/HOGcj/dcMiri4?=
 =?iso-8859-1?Q?LAHzqll4RP6MzN0HS68Qk/zzVV/jecnt/ZciOHb5W14QDyObgGWtjCXY89?=
 =?iso-8859-1?Q?1ol8ua8cbwyw/y+7ME5tYg?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Xz0dsrrhO/RhhKONC9ZQfVt4c4gHcj31LymPn/9U3GRvtoVvPxvzKGBihQ?=
 =?iso-8859-1?Q?smFQ65kSZ43jVGFsDRYnv7HfDYNCPoNgX4KKAuyc4+V0LzYkx7jJd568Kb?=
 =?iso-8859-1?Q?8pcC+COTbw3yrHYJezYqfwrTG/Em1tHheZDPYHtHQ1MlxC9rX1Tt8ZCyr1?=
 =?iso-8859-1?Q?JF0EhOkTmu252ZwcPZQJrMTIEqAVidHANXPentMOHOjlv40BUidg8y0PbA?=
 =?iso-8859-1?Q?4GTSTey67RstzVou5RSZUYM6gyKKo5zWlGL6wOcgcViiEwp4T//mykTQoA?=
 =?iso-8859-1?Q?571JHpYOIlTMzq0aFjzRTnDRVYJ1/iMsh6BwkOFVp1mwLpnlWtETtaMj/E?=
 =?iso-8859-1?Q?txoRbMBDSLAIrHipkyMosJ4n7Ek0kparJEsdxdhhS1gFLb8klRuoqvl9Qw?=
 =?iso-8859-1?Q?gCrfPXuYYtcQ+UjUIhGCUnuqXxtURm0aoMtWTnXYkPqcNHvSSaJr7ip5Sr?=
 =?iso-8859-1?Q?WVtrQZrSNfgZg/fIHRksFjc0uKn5zoivic69QU+Q/0jya2RDNaaYV1V9f4?=
 =?iso-8859-1?Q?SL6SOKGnc2DLjqhVsJAGntRO2mwbAGxH9/l+L4yyzNu0oZWmZpEjrlPP57?=
 =?iso-8859-1?Q?9MVvf3V05IlFaQvOB+wSOw46BaIge7ZlCuvOysV07pbfvfv2S8WOechr6f?=
 =?iso-8859-1?Q?VOHUWUVYzuxPuDNMg35fNjbufzud+d0WDx6sZoMniWN4TUX4IdphoT6fTB?=
 =?iso-8859-1?Q?Qe0rIMAwwf7iGZ0a4GM8HLH630rVsWuCa6mahZRkwleifsfXCCpCYVHIJ5?=
 =?iso-8859-1?Q?ZzuYzvY9ECtPf7Qdus44RHgxoewWIdhGvCPMHd/ySorDTswYyMtjqEjWCc?=
 =?iso-8859-1?Q?GMOog61gkGXSy71USgFAYKmrBgFDcNdwaYEZiYv1hQCAKDy/BviV1jjNSX?=
 =?iso-8859-1?Q?SWE9cDu6CSF1ExEVaiQG4WCr8aci76eeArWcvt7Uyl8UXUP6TvGSHEdWje?=
 =?iso-8859-1?Q?2tgCJWi5kHhzsg9c1gYtP9DxiQ48FNWfyTGA5MFKaWWGImOwDRQAfpwknL?=
 =?iso-8859-1?Q?V4VVj6oJU7VKMs6i08KqD6sYNsTL5MNgYfQNbZOe+YupYDoNj1blS2PBsZ?=
 =?iso-8859-1?Q?NoT6kxhjsjMZkovEsAvYYeg0uT1UR8RkRFSdoQ3Vo8Ut0WXgC44tzJYpA2?=
 =?iso-8859-1?Q?vetZ2g+ukuH9RPK6VkObLadbmACax/RPzvA49goLTsvGHkT9VSRCkSj+4/?=
 =?iso-8859-1?Q?YsNbH03UxLnZyaI5Wab38p+FBdLyCqOLCQTT211B0K0Z1/kUr2J4UGgTj5?=
 =?iso-8859-1?Q?RqpcsRwuELyFKZ45+UzmuMcT/kd5ltIwb6I7bCM8iFJZb4LG1QX/pstoKt?=
 =?iso-8859-1?Q?UuajtFSq0Zpug9WeZzkwpc9wJ9GEIy0HdLnz1B79hN1+PuQLVTI9rjPe6u?=
 =?iso-8859-1?Q?pHxYxzKiesEkD3uX09WCh+aD1Qfk3qx7OhQPB3I9d6TNN1SMLt8eJE92aG?=
 =?iso-8859-1?Q?HcDeI2jBBaXn89umsE6vmNgYg7cHpww3UbrGEFEkd+ZDgmQG2aRfs1mIcE?=
 =?iso-8859-1?Q?YdpiTRwFEkbTyp3bdtvFa39YTZRVxm466x2wj3OwZdqbI6IGNV6PTOmb9k?=
 =?iso-8859-1?Q?qShcT6E66QScyie6TnuKufi7M1IxZxOFeUjgfD/5xQYxPzBzbmfq/YSSoD?=
 =?iso-8859-1?Q?TSrSjpEJGjjkk9G/nOwvK6Y6bCaVty1Gtn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ab8a2e88-c267-41cb-0aa3-08ddfe6a2bf2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2025 08:36:51.5450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3l274WFxmwlFlyPrzRbdNKHB9sDUz348a+mIwzlCE+YIU6393nGmRt3B3tIcVks28yHaCm8iT0cI4O/qPeKuBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFE62D2CE76
X-OriginatorOrg: intel.com

On Sat, Sep 27, 2025 at 06:10:44AM +0800, Edgecombe, Rick P wrote:
> On Tue, 2025-09-23 at 15:03 +0800, Yan Zhao wrote:
> > > @@ -625,7 +624,6 @@ static void mmu_free_memory_caches(struct
> > > kvm_vcpu *vcpu)
> > >   	kvm_mmu_free_memory_cache(&vcpu-
> > > >arch.mmu_pte_list_desc_cache);
> > >   	kvm_mmu_free_memory_cache(&vcpu-
> > > >arch.mmu_shadow_page_cache);
> > >   	kvm_mmu_free_memory_cache(&vcpu-
> > > >arch.mmu_shadowed_info_cache);
> > > -	kvm_mmu_free_memory_cache(&vcpu-
> > > >arch.mmu_external_spt_cache);
> > Though pre-allocated pages are eventually freed in tdx_vcpu_free() in
> > patch 13,
> > looks they are leaked in this patch.
> > 
> > BTW, why not invoke kvm_x86_call(free_external_fault_cache)(vcpu)
> > here?
> 
> The thought was to reduce the number of TDX callbacks in core MMU code.
>
> > It looks more natural to free the remaining pre-allocated pages in
> > mmu_free_memory_caches(), which is invoked after kvm_mmu_unload(vcpu)
> > while tdx_vcpu_free() is before it. 
> 
> Hmm, that is not so tidy. But on balance I think it would still be
> better to leave it more contained in TDX code. Any strong objection?
No strong opinion.

But if we opt to do the free internal in tdx_vcpu_free(), it looks like this
patch needs to first invoke kvm_mmu_free_memory_cache() in tdx_vcpu_free().

Also, better to have a comment in mmu_free_memory_caches() to explain why
there's no corresponding free_external_fault_cache op.

