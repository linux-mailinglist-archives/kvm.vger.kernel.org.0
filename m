Return-Path: <kvm+bounces-61915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 526CCC2E280
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 22:31:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99853189921A
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 21:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C91542D061F;
	Mon,  3 Nov 2025 21:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GphVs64e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6DA2AF00;
	Mon,  3 Nov 2025 21:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762205460; cv=fail; b=Ikwl07wP8EcQseXgUKshZc76NCIS8c3laCxNzfkvhVfSjmxBEazhTRxRw+x5K+PXlW4jxOTtSiI/p0iIZgj5oc6wcweN4jIU9kv2FuIPTFgfSA1p5zjacLr3gAMf+SYzE8WzJn4F9ekLppmJzLcL9FMLc4Kena4mMrWk/4XdG4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762205460; c=relaxed/simple;
	bh=a1fT+xQ9K2Y+7sQv48xCjtrNvCElXl6E5VSPNvNDpzM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=d+Uk/REjXCJWIJ0yOOycaOjUPQnZN/zI+kdxNTLr88uaSH9qFRQeRMFP5Tbdqux+ycvWGowXRLdxP4z82/F3Xn/h/2Okvrc3kn8aFPv8TxavR4q6jijhJ7xv8/0iZIR0WDu+NPQ4uS+umZgRb4lzN778lp+ha5T2wDddWvngrSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GphVs64e; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762205458; x=1793741458;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=a1fT+xQ9K2Y+7sQv48xCjtrNvCElXl6E5VSPNvNDpzM=;
  b=GphVs64e2Hn/RmaYOjIffshoDZD8dWx0t7e2CABogqlnBoK39smWuwKl
   iSmcd7B6BjvT1cOn/Q0KA8bnW8h7fRgCmpcOStU+PwOuni0gCedLlCasp
   vIeIEtpvrHoC68vmY2kGD5F3pbJwMyye95aKy8g7f9LMuWWSFNtajNSZb
   115hFthvHJSSir67PF+u+kfR2TfawVV9cSrctHX09afSLHoCWeensPPtI
   l64+q6l1ssSN20Yhm8hI1k632GyklrlrLSQTrfesPF8boDc1Mvewe5JUB
   JVKzVGw7usbmQJTo5jQiFnEM82CG/7Itrmch5KcLNrH/DSQH/siQQfJau
   A==;
X-CSE-ConnectionGUID: ln5Hjk0wSJug+1oMB0N57Q==
X-CSE-MsgGUID: VgEv51X7QvuuWFJf5qphiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="74584199"
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="74584199"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 13:30:57 -0800
X-CSE-ConnectionGUID: xJv6/23ZRja9zC0UAb4jDw==
X-CSE-MsgGUID: 3x72M+d1Q9WB3d4sALkc8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="191297945"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 13:30:56 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 3 Nov 2025 13:30:55 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 3 Nov 2025 13:30:55 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.33) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 3 Nov 2025 13:30:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oMPeiB0NvztJVpHgP41KcAxxJssqb6bIWPSfnqKxsMaCZvWGmGoIqqL3q/ZDwzRpHpmOKPcn6cjRLTViUWHpMwR6uLiQ5gCWp8ebERTdf9N4IqYWtsAOexVgFjes4c8D8nNGbzJfVdjoJt3hQndPUsf5kumYdnvGmHI5soGmRIS5DEi0XLXG0fbrduUb2kpTIRFrYtQxJXr/6Jz7mR1kkKLLDA260oWV3wh7YOW2MUfSqNrtehePBw5Id81qG4CFRA4Lbcz9YigN5Hb4aMJ1/OR9ynlGs9UAnN9kDjajkFIOmv58AY3g0b577xbS4Bbyee0I4/cnyb7HruiXetzYhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e71pnvIX2/4JAn5sN0tQoJdoUZr5YuuSsSDHyxYSDkU=;
 b=aCf1Oe24yiLqYpNKQIXM/LO5p+d17TcexEKtXxIotXSuRqEGXJ+xlSnz2toPN31NzpYTi+BpYi5VTuioEkH2F83vZW9JWo9RssZkkxeQQZ2ZUPQXRAad4U3M4kLxY/h2TaTh0/LGuoyB+u6HPoKwR3FMF3tvvgjS4cPRSNb2OkoLTPUAeviBe/LepN+XGBGvDnfw8W1sG5+mRxW+X+4RTlUkAXBan8Sk2A8i8EQ+hgdJ/Hmew75GFpuAPgvnTCSpfP16GyXusFiI0BoRsNwJleTXWzldENDR4IpEJHNV4NVsEFOSqGKMxOPur0WXy2XYvKkfA+/6wwBn9rQHSVQaPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6139.namprd11.prod.outlook.com (2603:10b6:930:29::17)
 by SA1PR11MB8280.namprd11.prod.outlook.com (2603:10b6:806:25d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Mon, 3 Nov
 2025 21:30:53 +0000
Received: from CY5PR11MB6139.namprd11.prod.outlook.com
 ([fe80::7141:316f:77a0:9c44]) by CY5PR11MB6139.namprd11.prod.outlook.com
 ([fe80::7141:316f:77a0:9c44%6]) with mapi id 15.20.9275.013; Mon, 3 Nov 2025
 21:30:53 +0000
Date: Mon, 3 Nov 2025 15:30:49 -0600
From: Lucas De Marchi <lucas.demarchi@intel.com>
To: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
CC: Alex Williamson <alex@shazbot.org>, Thomas =?utf-8?Q?Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
	<intel-xe@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Matthew Brost <matthew.brost@intel.com>, "Michal
 Wajdeczko" <michal.wajdeczko@intel.com>, <dri-devel@lists.freedesktop.org>,
	Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 27/28] drm/intel/pciids: Add match with VFIO override
Message-ID: <cj3ohepcobrqmam5upr5nc6jbvb6wuhkv4akw2lm5g3rms7foo@4snkr5sui32w>
References: <20251030203135.337696-1-michal.winiarski@intel.com>
 <20251030203135.337696-28-michal.winiarski@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251030203135.337696-28-michal.winiarski@intel.com>
X-ClientProxiedBy: BY5PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::20) To CY5PR11MB6139.namprd11.prod.outlook.com
 (2603:10b6:930:29::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6139:EE_|SA1PR11MB8280:EE_
X-MS-Office365-Filtering-Correlation-Id: 80a0651b-cb1f-4434-3140-08de1b20442c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U0NURDV5NFdTcDJaSWJFZFJVSFBGenVtOGJJb1l6dlF5WWdLTkZ3Q1BZVDlr?=
 =?utf-8?B?VnJaTnJIeW95a0x1aG96Q1Rxb3lveGR0bktjNG0vT1orT3V1RU4wV2pLSFBa?=
 =?utf-8?B?c3huemJrbG5zWVZMMlVRQ1dVbFVvRjdhQnMxLzJPcU1lNEJTTTJuTm9ZcXdQ?=
 =?utf-8?B?QXlUb29HM0lLWGlZTUZYejhUazF4VW1zdGFjNWg3YU40NTAyZWhrc1gxYjdm?=
 =?utf-8?B?UXM1eWpYd1VyOHhlT2w5QVY1MDVYQ2VNVlJ3QitlbVFxQ3VBQkY5TW9ibDFC?=
 =?utf-8?B?WEk2ZFVKRzlNUkppcGNFN2hhVXBZc1NwZkRMOEhYZCtrZ2I3cHFhUmEzR1pa?=
 =?utf-8?B?Y2dGRExVTTF3Q0laSi9QMVpFWXBDSnplclpiUUttZkxGbjlZVTc2L2FranpR?=
 =?utf-8?B?V0RYZFpWUkl2d3hYVUFxcXBFTWZiNFZ6QUV2YUxlYjROYmxyY0tNMFBJQ09M?=
 =?utf-8?B?Z2wzaXhtdXJUVS96akVxcWdYR3VRNzFUeGVjNUNXSDFJcnJwa2VlYjlwV04w?=
 =?utf-8?B?bVd0VnZFWTBhaTVMc3psWW1pdkdMTXRjeTNhQVg5cTh4RmI4RStTZFlXZ1ps?=
 =?utf-8?B?MnAwcUdOQmJwOGRianE2S2NhaWVHQ1piTzd6Si9HNUF6SVJXOG1nQURTa0lQ?=
 =?utf-8?B?bHVEYXBueWRIOW5VdGJFbCtBMkFqN1FvOHhFMnRrVVpETzN2K1pYa2JLWFpm?=
 =?utf-8?B?WnVYaFlIZTJZcjhsQUhZT1FMcWxybExGQ0ZLRGNFbUhGZzVwMWloWUpwUWM1?=
 =?utf-8?B?M2R2eHRCaEFpalZaMVFuS1JwaFBsT3lTTnZ2SlFkeU9iSG14aW1lUVJzRUJ3?=
 =?utf-8?B?N2dERnQ2ZGZZSVJFTzI4djJHMWY1ZlJjc2lCVTRWRnkvYlFRSVNsc3hmQzVB?=
 =?utf-8?B?TXRzUDRSNFl3YXhhdExWZXptc3BrVXJtVkVJNzVWaUt1QkFIZUlwMUc1bkJR?=
 =?utf-8?B?V0IxZ3UxWE1GcDB4WHdnOGRQWVF1WnY5YStLa3lkNVQ2blo0YWRrNktKZ09w?=
 =?utf-8?B?Yzc2Zjkveks4cWN6QlBESEJHRDZoWGlNdXNJU2pOaGFLZnhydW10TUpON0Rq?=
 =?utf-8?B?a1pGeHFGOHI1MzYzOEhzSUpwQjhMU1g4ejNkZmtkNlR4MEJNclVGcEU0aGJK?=
 =?utf-8?B?R29HeE84eEZITE5hcFRtT0tVUjVSRFRIUWJLUGVnaDNpS1liNHJmWEZBaU5K?=
 =?utf-8?B?VXcxVlV0S2ExR0hNL0ZaeFJmWUlsZmtmVkoydkxYQW1uaFIydklHbGRCaGxv?=
 =?utf-8?B?RksvNEZSeHNIVFZWaGNUc05iZW9lKzFpa3duaTZrRXFUWk03N0lhc0tXT1ZC?=
 =?utf-8?B?ZzhCQktBdlI3TXRvM2VsSTgyUHM2U25EUUtCOWJFcnNNRlFsbjBzOFlEYXF6?=
 =?utf-8?B?ODdvOEpHaGhwZjJYNHh1RFJUR2RDKzYyUlRuMHFTWVVROTdIdStrOC9OWHo3?=
 =?utf-8?B?OHRuV09aV3pmUG5rZ2dDdS9jb3RYMUkwWVhZOFBaOERxd094aDYvR2xQc2Y2?=
 =?utf-8?B?Yk1send3S3JFSlRyb2gyWi9oalJPQWo4WkpRVDA5MzRMTGFDRTRFSEROMXdn?=
 =?utf-8?B?RWFkcDU0ajlHNUZ0V1hPN3FpWm5wRHExS0xVOE9oYjNKdmxXQ2JaaUVkM0cz?=
 =?utf-8?B?VU52OGlldkdRNndYL0MzdVJqQ25hZUpOQzdpMERncXVyWjA3NTI0eUZYaXZV?=
 =?utf-8?B?MWtaTDllMXUwdyttRDJuTFNNUmhxbVNWbVdRWGFjbk5aRWhtcnFiV0NIaThQ?=
 =?utf-8?B?dkFsNisycHcvZVVQTEd5bmU5aVJ6cjV0aUluMElQNHdoc2xOOEFZSTdPRjBW?=
 =?utf-8?B?TjlEWTJPVkYrajM5b0RzSmJZc3drU1c0ZEN1SjZaVEZYbXM3ZjliVnBWdHRk?=
 =?utf-8?B?aDB0NDBheGNLN3BlMWZ2ZXJaYTJLZzgvN2FwaHlNZFd3bkxjdXpWbit0QzRF?=
 =?utf-8?Q?x3u/Z0/JF9tWJ42KWt7u5VT2qTGHDs/A?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6139.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVY5TjZ1RHZFblFOUGN5VkxJQVVURXpmT042TjhkRDhLcUNRSjl2eUttcjB1?=
 =?utf-8?B?RHRXZXdyYkd4ZXExYm9CUnlCRlRIeExEa0luWmhmL0N1YjNsZDl0d3RTTzFP?=
 =?utf-8?B?SUxublRNbmd1NnozaWg2ZlBJK2h3Z3ZvaGdZc3M4eFIzMVdPczlzZ3BMMkNj?=
 =?utf-8?B?KzJ6dWpjSGNyaG8renc5QVJXazJyT2xRVTg1RmRNTHVpNnlMb04wZlZCdHdp?=
 =?utf-8?B?cUFVS2QweThoVDZRQjJCYm5lNkR4WGs2bHBETVU3Qm1BeFdqbVEwYlZBTFJw?=
 =?utf-8?B?R2dycUlTUWMwMW81ZDNtOUhWQkNRUjBHYTRtdlhvMVp1TzhsZ01qcGl5b1hr?=
 =?utf-8?B?ZVJuWnVhRWZmSzVvc29GTWF6dEJzc1J5VzVZUHIvRnVFOFN3dm1xSUFMOGRR?=
 =?utf-8?B?aE1lWXB1R3FqcUMyQXR0SXFoSTI0b056MUlDL3V5bmRyKzV6Z2lkNlU5Mmoy?=
 =?utf-8?B?aU9GU1dTYlhOdllkclRJZVBiNFlhMGZqWnUyRTMwVGJISUhHczNnMVl2UXNE?=
 =?utf-8?B?eXBPVlBlbzZGbFR6NkNDeEp1MG1TVnpQbDVhYWZZdnhLRnJwbGtLbjQ2dUNW?=
 =?utf-8?B?SFJPQ1lPZjI2ODQ3R1p3Sk85YjVwRUNSSWpzMzFQa2NCeE95anBsSHcweHYy?=
 =?utf-8?B?bCt5S1ozUDBZbENRMGtVSnVhOFAvRVZNYVRrY251T1l3VnN3ZlB2LzNBTllF?=
 =?utf-8?B?eFYzR2hiWWd4V3RjeTBMZWVxcEtlaWhMdTVUY3JvV3VaenVJc3pMY3RHWlBl?=
 =?utf-8?B?bHFIYWp5eUNETWcvRlQ3aWRCUEx6U3N6cFhNYmhrc29weE1LR1RHemhpcysv?=
 =?utf-8?B?MmVKcVQ3Q2lPZjZDaDArWUZKVU9PbThqVU8waFVaR2ZyL0lNRWFKdDBjOHlL?=
 =?utf-8?B?cjJ4NWNFSldXdnNZZUVkdUloTm1GNTZvM0drRi9FL3kveW9nTVRJVmY3RWNK?=
 =?utf-8?B?b2U2dGEwaXhRdHhlamF6NStLbHZHdjlzdWIwbjdtb2tYTTFvcEVNZWdiZlgy?=
 =?utf-8?B?Qi80alg3dnhOTmdRdzdJTXBVQ3FvMDZtOWc1QVpPYkN6Y2NIRERBalQ1dEY5?=
 =?utf-8?B?d1pONitoeW5lVmxxb1NDaHlpb21XUGt5VHNxWjlCRW9LWDZnK0pLWnloWUN3?=
 =?utf-8?B?akVjd3A2QkFicVgwODNOUzErckVMU0dSMTlnMVZpaElXbWNtQ1F6N3puaUtH?=
 =?utf-8?B?V3RJNTNHaVJQMWhpeTF2YkhKNkVEMWNxcVUzQnZtTlJCOUhNb0hvOXNPbTFQ?=
 =?utf-8?B?cndPWVZpVStZckg0N0xnbGdZREx1WURJViswYUVKT2NkK0M1VWZYcFF0QVRK?=
 =?utf-8?B?aVB0MW81eUIzdm02V1hQNGFrRTZ6bjJJdmVOdXdpMlI3ckdlanBiNHdpbEZK?=
 =?utf-8?B?ekx4elJqd0c4MzNiWUd5RTBXTm9tZUQvZlRmMm5ORVRCUXFUSGRCbWs4Vk9p?=
 =?utf-8?B?K1FueWYyY2o0Z2NyeFl2dyt2bHh6SXdOMGJUQ1BoZVVlUjN3c3A0WDQrRmxE?=
 =?utf-8?B?ZXU4NXFaRStMK3FySXgvY0duSFNzYmY3dEl5elpOQnV0RkNra1V5cG9hOWpU?=
 =?utf-8?B?Z2ZBeWtKU0tBdnNYbFE2Z1JXUHZRclp5bGM5QVFQMmJoN2xDTjE1Z0tXTUVQ?=
 =?utf-8?B?QkpXZERxQy9BU2pkTTBOQXo2SHRleGgzMzZ3RmJzbFJSamlMazU0a2VEMUQ4?=
 =?utf-8?B?b3E2ZHQzZkdtb0FoNWFhQnNidkRwL2RtSnJzWGN5d1JHQjk0K0pYcnNJZDRQ?=
 =?utf-8?B?eGhsZGhTb1UycDNXeVJGZWJobjQwZTRQUllHb1FIajZZVjB2bjlpb3VGdERB?=
 =?utf-8?B?THlGTXpmV0pvQWVubmNMbzNYc3dRc0V1bWcrdVNraktjS3VlZjN4bHpPK0JI?=
 =?utf-8?B?aWVxUGExY3ZRT2xwaFhLNnVUY2xuR3AwM0VEUUZPOU9SbHVqQSs4RXdwaXFa?=
 =?utf-8?B?VDVsT003ZGplbWZGb1V2eHhBWnVRK2hoRmF4cjU3M1NzRDYwRXlSQXVsTEZw?=
 =?utf-8?B?VTJpbFdFSmxwdER4MU9JZkxMUUszNkFVY1oveVRBMTVlZlI2L05BVHg4Y0ln?=
 =?utf-8?B?bEtkUnBESlB3QTJrYlRNZHNuVS9wMjA2bGdiVXpZRFl3eUlXaE8zQ0JoeFN3?=
 =?utf-8?B?Q3oxcW1hcDdBbXVsK1ZWalFuc2YrTVRrTlJuSTVneEFGK2d4U2UrYXk0OWNC?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 80a0651b-cb1f-4434-3140-08de1b20442c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6139.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 21:30:53.1708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KfgCanVmsGSS26rbRfWU7Z4nEJNXDRwI72qdlj/52Lm/qs0fR/6894BThBnA7C7SD7iQYoyb6cvi8xkhjiig+BeOv8kqGDesRjmoqYL2rCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8280
X-OriginatorOrg: intel.com

On Thu, Oct 30, 2025 at 09:31:34PM +0100, Michał Winiarski wrote:
>In order to allow VFIO users to choose the right driver override, VFIO
>driver variant used for VF migration needs to use Intel Graphics PCI
>IDs.
>Add INTEL_VGA_VFIO_DEVICE match that sets VFIO override_only.
>
>Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
>---
> include/drm/intel/pciids.h | 7 +++++++
> 1 file changed, 7 insertions(+)
>
>diff --git a/include/drm/intel/pciids.h b/include/drm/intel/pciids.h
>index b258e79b437ac..d14ce43139a28 100644
>--- a/include/drm/intel/pciids.h
>+++ b/include/drm/intel/pciids.h
>@@ -43,6 +43,13 @@
> 	.class = PCI_BASE_CLASS_DISPLAY << 16, .class_mask = 0xff << 16, \
> 	.driver_data = (kernel_ulong_t)(_info), \
> }
>+
>+#define INTEL_VGA_VFIO_DEVICE(_id, _info) { \
>+	PCI_DEVICE(PCI_VENDOR_ID_INTEL, (_id)), \
>+	.class = PCI_BASE_CLASS_DISPLAY << 16, .class_mask = 0xff << 16, \
>+	.driver_data = (kernel_ulong_t)(_info), \
>+	.override_only = PCI_ID_F_VFIO_DRIVER_OVERRIDE, \

why do we need this and can't use PCI_DRIVER_OVERRIDE_DEVICE_VFIO()
directly? Note that there are GPUs that wouldn't match the display class
above.

	edb660ad79ff ("drm/intel/pciids: Add match on vendor/id only")
	5e0de2dfbc1b ("drm/xe/cri: Add CRI platform definition")

Lucas De Marchi

>+}
> #endif
>
> #define INTEL_I810_IDS(MACRO__, ...) \
>-- 
>2.50.1
>

