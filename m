Return-Path: <kvm+bounces-20663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8593D91BBC5
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 11:44:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 152331F22EC3
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 09:44:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB0BD153578;
	Fri, 28 Jun 2024 09:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WW30j+kN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E5D152530;
	Fri, 28 Jun 2024 09:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719567861; cv=fail; b=pzlT0lmGA19RHB8qkcVvjLbY74xFxSKyRExzQmiUOu0auQFn8GOPmcfKgWZYZA6CMuRbXVfky1fofS5lfKLHV7UsAYwoOLjuX+GCPRoYwtJljNtmaHannffNDVNjNd6c6NAb70f4jlQiVOBWAwr1wasgXhDH8EEJVTGNZNqgOFQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719567861; c=relaxed/simple;
	bh=3FoAUeN8qKTSvJUfXF2J5IyvcMsdp/SNY+y2KvO2GXc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pD7lUhDnZ6baFmHnfdusw7mTEgZxwwktPnBhEPmaygUftEiyl+0m1u4v2IFkAQMb7hDc/hrSmByttIotU+G8UfrI4bSRYxNZ+KwMD0+CHngUUhLfAVjLZgGGfeTjkCaS6pBEI1jcbRVcMX+9w4TJVvEgL5FQL3vw2JTdwj3TDvQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WW30j+kN; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719567860; x=1751103860;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3FoAUeN8qKTSvJUfXF2J5IyvcMsdp/SNY+y2KvO2GXc=;
  b=WW30j+kNdKz5zszwXDhXJ8CFRgJEEKa8RWyfuzo2wely7Vtsnys174A6
   8Z8hPhf6byPObQsEgm4Kxz+iaBF17h3kbCbWI1y+B1SF8Qd1Ex+hIWG4u
   mdLyGrshCrd+LZR9ul4tk66Fas26JKVL5fFiZs33d+xZYaSKrSJtnnVp8
   wEVxsqROay8dJO4KWOmBMIAHeOkrj65ZU6IveE3pw5A881dAfdwnVq2yx
   KURehczAocFBmtWHEIsPOjI09lkePZeDbbGIuZy9udZiw/yPRyKLJlsU3
   BcyKfi8Vbn+eIQAr+j6fFyJoaOoz0xL4H3LLatcPJyfAQD3PQVl/kSUWW
   Q==;
X-CSE-ConnectionGUID: zF+swnY0STKrjdPO4GtJTA==
X-CSE-MsgGUID: MztTcDoaQu6queeVZdhRpA==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="16420411"
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="16420411"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 02:44:20 -0700
X-CSE-ConnectionGUID: K4LiQssjQdqbTdP2yTsx5A==
X-CSE-MsgGUID: MgndNKwES/uyaXM0paEpHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="44572769"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Jun 2024 02:44:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 28 Jun 2024 02:44:19 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 28 Jun 2024 02:44:19 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 28 Jun 2024 02:44:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EWYIO46SYTWg8AGFYvxbY/h+dgSEupQBZmnIdf+yGQUSPXtgO3tDb9x4u7GnVP+whpn7r6DZ0Ntn3/3PQAKYvMsbMqa4tofFQKihdoKVElUC63S+jBJ01pxRBZbaE6CUtbGdgE3wTIuEOIH98mLZtRud9jz8fkoI5okhdvB9OTkQJMJ/dnE3/eYf9CtsMEZFmLdZdxbEZ+zPPg2ouGNUMz14wv8OCWoNvESj9i6IlrQz0Wa0y3wenqDepHyafrVEmZpf7z/veO8Xg/twheuPLdF1j24ANAaB/K7ODQ1xUP5pBFe0fzsp503pEQvBNWBMsn8IVVTVex4V18YrlgnWzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJa8nuEz6tm40nXhf5PKXbJYKsYd7dOawi4IllIIo1E=;
 b=hGuPAugBVAlqdYSP64OMzQPTJotdUvdZMSLPMvc+7nDXRPMuCZV222UPbULj7yBFAnJBG1OsfiLf4UbfUSXqIERpWRr92cpOleMkL2QrA+jRiu7n0aDnzzFQpOW5SNo9a54aVe90bVOlkyItcBFW4FJd2s7ZR74Si6lq7uBGVkgQx+7e8DZXMvIDMcPNMF5ycamlXeAnTz7C3DOeHefH2mwdtlfm0XHB4vXHapTwcZbvYRO3BgneWXZRFgp7CjBaG0l4jmynMUX928RPMdnOntfXmw0MxK08cuy8RiQGlGFfTQe1IYdidoiU8iapvWhMBtbl+JGtEyDO/ZEOe10cAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB8017.namprd11.prod.outlook.com (2603:10b6:8:115::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.34; Fri, 28 Jun
 2024 09:44:17 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7719.022; Fri, 28 Jun 2024
 09:44:17 +0000
Message-ID: <cba9e18a-3add-4fd1-89ad-bb5d0fc521e4@intel.com>
Date: Fri, 28 Jun 2024 17:48:11 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio: Reuse file f_inode as vfio device inode
To: Yan Zhao <yan.y.zhao@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>
References: <20240617095332.30543-1-yan.y.zhao@intel.com>
 <20240626133528.GE2494510@nvidia.com>
 <BN9PR11MB5276407FF3276B2D9C2D85798CD72@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Zn02BUdJ7kvOg6Vw@yzhao56-desk.sh.intel.com>
 <20240627124209.GK2494510@nvidia.com>
 <Zn5IVqVsM/ehfRbv@yzhao56-desk.sh.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Zn5IVqVsM/ehfRbv@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0027.apcprd02.prod.outlook.com
 (2603:1096:3:18::15) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS0PR11MB8017:EE_
X-MS-Office365-Filtering-Correlation-Id: 23d32f96-2b63-4e54-1266-08dc9756e086
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VlJoNVlqRmRQd2pTNWUrMk93b2NRRGFrejlWY2IzTDdVRWx0ZlJsMU5SL2g3?=
 =?utf-8?B?VmQ1S0wvSW1ZbDZLdG13My9SWDhzWlJGaUhYd1hYdElpKzZ6aXJKMkJMQlN5?=
 =?utf-8?B?c2lYZGUyMGlGQklVajRTU0YweEFZUWs2SnNNb3BwdmI0K0E5ODUrcytUTThM?=
 =?utf-8?B?N2VBNWZiNmREWnhZVXdXZkhIY09OeGk0anJEZjFMTkRKMjVIcXdHR2Uza0N2?=
 =?utf-8?B?MmRqUjB0dE9ERFlhdStocDBIQ3gyNG1EMXo4dHY4eUJhOG1TNWZhb2tHZStL?=
 =?utf-8?B?bTZscWMwaTBvcU5vVzUzL094V3VmYkl5b0R6Ty9xOU1sTFJXK29XSk92U0dL?=
 =?utf-8?B?bHROb0tjVE1nY3FvY3FGSnd0cytjNXptWFMxODExWm9yY0hRbDc3N0JmTCtI?=
 =?utf-8?B?ZGw4REIrZXFFdDAyTHRFRkY1aWRDeDlTQkZrTU9BTVhla3M5UU9Wcjg1OFc4?=
 =?utf-8?B?ZmNkZVhKTE1hVHFydFErRklUUDhQQURQaHlpYWZXWEJlN3VyWlFZbDUvM3No?=
 =?utf-8?B?M3dZTENpNVFrV1F4RXRCaW5oM244cllSa1p1ZmZXUmR5VEFSc3lEZlQ5eW5Z?=
 =?utf-8?B?dlFKNGw3U2FucVdrLzJqMHNKSXFNU2p2bUhsUTRGM0tqanlXRG8yVy9KaUw4?=
 =?utf-8?B?eWNHNjNBYk1nelRhYjNJbXI3dzc5WGtkVklmUCtJL2picE02VjRlb1NKT0E4?=
 =?utf-8?B?WEIrVHdNNDkrN2RMVXN1blM4RzhDSXUxa2crK0owTUFHU2ZuYjZteTFGVnFw?=
 =?utf-8?B?aW0yUEh2VjU3OUo0VUtuYktBME9tZW1Db2RVekoveXlNeUZ5SEN6aTF4Nkcr?=
 =?utf-8?B?ZmVkUjF4QVZyblRqYzFBT0RHNE5uSFloTFVYRTN2RGU3Q3RPTVVCUDlxelBL?=
 =?utf-8?B?NHNRWDkvYU5RNkZWTXI1RWZqMHh1K3JUOWRic0pyRkRuSzJkeUlnSWh1cC9K?=
 =?utf-8?B?NjdJREp4Z2dsMHpXSk1mVDhKT0kxbjZrVEplUTNpcS9OZVBqcWZvcTFZcjM5?=
 =?utf-8?B?WEhFZkJQb1RHbDFaak5DVTNDLzcrWnY0Nll4MzBsTzFrT1V2MTFJbHM5b3F3?=
 =?utf-8?B?WjBaN2tzc2YxNGlRNjhzTHJPVzE1c3BjYzl6SmNGNFdqMDBSUVRXRm5PTVBm?=
 =?utf-8?B?L0ZJb2RoQ3BaZEhubEY0WTYrZTJjcnZmTFNzZmRjUVdUS1lTUElTaTE0RnZv?=
 =?utf-8?B?aEowZExhdHBvUWx5OVBzb3c0OWszSzBsK3FJandKNXVCb3VoYk1NWWpsSlBz?=
 =?utf-8?B?SjVMTXNXYUhTTm05dWdSd0YxdUhGSzdOSW1BM3RKLzZqYjVFNjVLWlgvM2Ew?=
 =?utf-8?B?UFhBQ3JPblJiK1p0a0lDMEtWZkJ0dFM2aUVFd3ZRRXpYbXo1K05meHMvUG9W?=
 =?utf-8?B?N1N2ekZqSWY2WC9uU0V1SjFndS9TR1ZxaXNaaHMyRHhKN2ZQSlM3QU5ydGlE?=
 =?utf-8?B?dDJFRng4T2pwWFUxYnVEYUgyektHa1UxSi9vSFdXd0IxM0tYSUI4ZVBzMnRT?=
 =?utf-8?B?ZXVDNnpxcWVETU1iRUR1ODdsR2RGaWlBWktVd1FQOXU1ZzNUbUEzOHNid2pN?=
 =?utf-8?B?QUYxZUppY3QydzVLQnFFVVBrWFBZRUpEQ0YvMkVLSEwzd0NndllrSGFiNFJG?=
 =?utf-8?B?L1hFaDdaYUptMzIrdzAvNnliVGtUb2ZlNWh4ZHZQald2Tlh5TXNkUkxBakZm?=
 =?utf-8?B?SWNvSzI3NXhUcGsvZlJibHhqV255M0pHTDZrbUxaZXNYbzdCOEliOUljSVN3?=
 =?utf-8?B?c3FCOXZ0bFE4SEZWdENZbnRMbk5PWXQyUDIzam1mZ1ZBcXRJSXNjMmVFbmhz?=
 =?utf-8?B?MHJrYkVsYllDMkl1anZ5dz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wm0xQnFMZ2hmaTE2OUdpWGhDMU03MGc2cFJYNHBsNEhDdFFVRHZ3MFh1V2xS?=
 =?utf-8?B?cnM3dXhKVnBENEs3U01PMFg5QWtZbjNLUGw2dHJsOU9lcyt4MnR2dFZqbWJl?=
 =?utf-8?B?VnRtdWpLanZVcWdSSk5IZGw2TzdsWEEzeDRPT2tRRUVkUFBkMlBrU21Iamgy?=
 =?utf-8?B?M1JWYitjVjBHS1pBQmcwbmVFdTBBTUNJTXMzM0NzY1g0dTV4NGVKOGNkVXVz?=
 =?utf-8?B?T0NSNnprajhzWXBsdStQUGh1VkN0bElVNFJTVW9aYUxiSG5iZGg1dGJML1lS?=
 =?utf-8?B?RHVoVzh0YXArdHlWVm5oZUxucVB5YUUvUmZOOUNUN3hxblBmWW40SE15VmtW?=
 =?utf-8?B?NGFlbm0vOFAzWXVJdHFnTkJoa3BFVWtJMzNwaW5ZSVRhN0pPMk95ZWlvUnhI?=
 =?utf-8?B?cnR5Rnp5NElDaUJqbVBLVzRwWGRya2tJcW1FMndXSHowSk8zS3lVQm8yK3VS?=
 =?utf-8?B?aWMvWnhqL2NJNTZtTmZLQTN6VFNRMFpDM0R0QXJlbHdyRUR6bDJ4TlNhQzY4?=
 =?utf-8?B?N0JpTkRuN2tySGZqd0c3NklzZ0t3UG9iWlJtcFU4eFp1MVRwemRjQ0FvOFdT?=
 =?utf-8?B?aHlyaDNod1NUTisvdGNGN3ZjWE0yMlk2WkY0Z250T0xqWktiRGZsNE5WcDI4?=
 =?utf-8?B?bGMxdXV6R2ZXOTBSNm5rOTlGTnVLdi9xZkxjR0VBMEhwT0o1ZlpjZ2hOcStH?=
 =?utf-8?B?QlFNSSt4bnVsOG9pNDdzQm5NVVJ1aVlSV0gxU3lnQmdzbjdNaEZoTmlzNFVX?=
 =?utf-8?B?UHNKNCtwQUxwZGFUL3ZXSEpLSGlNeVhsV0toMzRacGhRdHRLeHdZYXgzbEhI?=
 =?utf-8?B?dy81ckNQUFVTYUxKdS94SWtRRFdGeGFxMVRWR3lMbjFOdkFMdC9NeWFWd2Y1?=
 =?utf-8?B?VjRoWWpEc2Jqbmlhc2dzVUpnWVcvRFZ6OUJoRHBWczE1djZxT3N6QThPeTl0?=
 =?utf-8?B?R1BmQXkrMzRyZnNNYzdFQXM1VzQwbkhtSU9NUkVKbnBnVlk1VFhJNTE0MXdk?=
 =?utf-8?B?QzRHeDRSZjRyaER1bDBHeDRqSjZSdU5DTzVRK1NHTi96RG4xWHhVRG5FVUY4?=
 =?utf-8?B?OVJNcVdIZVY2VFhraXhhOVluVHNVL0lxVUdjZU5jbktCL0t4cjZ1eE0veHht?=
 =?utf-8?B?QmRUdTdpNm1HR1dhVkZMT2xKSVdvVHpaOW40V1dOWEd6UmF0K3JCcmEyeFJT?=
 =?utf-8?B?aGJwVU1ZcHU5SThsQ0p0dkFtNUZtK1ZqNHdQbmhIb0lTQVZGaHB4K3dIQmtN?=
 =?utf-8?B?SDhFTllweVkvamxkVStsQ3FxYm9vRlV2TnNIS1Vmd2tIUXgwKzdWTEUzdUg3?=
 =?utf-8?B?YTI5YWhGb3NFcGJzNU9hcFZUcmt4bHVYanlyNU9XNHlsamVlSFlJemhrcWZn?=
 =?utf-8?B?eTkxYzFtZDNQd09lVmtPc2MzUnBNTFoyOWszdExGTlE4Snk1b3pveFM4KzJP?=
 =?utf-8?B?NVVDZGNKN01icFVYd1BGdGhVQXRoK1RUODA5SWd4Qm5uYmsrT0s3dkg4VDlz?=
 =?utf-8?B?aXZpMHVKSytMYjlaN1hzU0ZMUHZvSmNQb1h1WE1NL1BrcnZvTGJrSUpyUUpN?=
 =?utf-8?B?R0FOa1ZVeUtTUTZXOFFFdE9IMGR1Q2JOdmE1cXhqbTY4MFNHNHZmWGhGUkVF?=
 =?utf-8?B?Z2lySXllb3NEUXYwWHFWM2dvYlpYejdTYU9XdlRtd01zS1lwbFNpV3J3N0F3?=
 =?utf-8?B?eTBIMlNSeDh5N0dQTEdzbFRsalB1Rmo2Qmxnd094UnIyRnRiOVI0TDQwb21l?=
 =?utf-8?B?RXFXc2pWUHl1WGNWcmg4alVTYmZwU2VXaytGSVZWK1ZpRVNIbnFKblRqUC9N?=
 =?utf-8?B?TXNsaDR4L3RJRVV2VWUwcGtWbUpMUXVMR1hJTWhuTXJyZEpzUnlkMVZKa29Q?=
 =?utf-8?B?MVVtdFN0SFltaENSemFqeHNIbEIrcWtGRXBHYXBWUHNLQ29nV01uZ3JnQXhL?=
 =?utf-8?B?VTdHVlJsNXhXQ211WXZ6a1YwbXZYbU1XTDg2UGozLy85S0VpL01uVEIrVGJ3?=
 =?utf-8?B?NWxPNHM1L0lEMnFqVkdOUFcyU2dvbXRzeVYrbk91elV1YWFMVGhpR3VSZzFQ?=
 =?utf-8?B?MUJFNlFPR3hEQzkva2NmaEYyRHhob0NBbWZSTGpsVVM5Ylo4VWxiNUI1SC9o?=
 =?utf-8?Q?yl2rpb0uHf1tOwIHca25YApMK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 23d32f96-2b63-4e54-1266-08dc9756e086
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2024 09:44:17.0858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FG6OZ6XRO+1A/KCdKLcrbLTbway8/ZqHGXdxSCYKZ0BBNAsHYHJsRgDM542XLl/FPuDK/7WK55WyocIGyMZZSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8017
X-OriginatorOrg: intel.com

On 2024/6/28 13:21, Yan Zhao wrote:
> On Thu, Jun 27, 2024 at 09:42:09AM -0300, Jason Gunthorpe wrote:
>> On Thu, Jun 27, 2024 at 05:51:01PM +0800, Yan Zhao wrote:
>>
>>>>>> This doesn't seem right.. There is only one device but multiple file
>>>>>> can be opened on that device.
>>> Maybe we can put this assignment to vfio_df_ioctl_bind_iommufd() after
>>> vfio_df_open() makes sure device->open_count is 1.
>>
>> Yeah, that seems better.
>>
>> Logically it would be best if all places set the inode once the
>> inode/FD has been made to be the one and only way to access it.
> For group path, I'm afraid there's no such a place ensuring only one active fd
> in kernel.
> I tried modifying QEMU to allow two openings and two assignments of the same
> device. It works and appears to guest that there were 2 devices, though this
> ultimately leads to device malfunctions in guest.
> 
>>> BTW, in group path, what's the benefit of allowing multiple open of device?
>>
>> I don't know, the thing that opened the first FD can just dup it, no
>> idea why two different FDs would be useful. It is something we removed
>> in the cdev flow
>>
> Thanks. However, from the code, it reads like a drawback of the cdev flow :)
> I don't understand why the group path is secure though.
> 
>          /*
>           * Only the group path allows the device to be opened multiple
>           * times.  The device cdev path doesn't have a secure way for it.
>           */
>          if (device->open_count != 0 && !df->group)
>                  return -EINVAL;
> 
> 

The group path only allow single group open, so the device FDs retrieved
via the group is just within the opener of the group. This secure is built
on top of single open of group.

-- 
Regards,
Yi Liu

