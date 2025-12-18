Return-Path: <kvm+bounces-66244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EB5DFCCB23F
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 10:21:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E7B5A3048621
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 09:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 733CB3314CB;
	Thu, 18 Dec 2025 09:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ft2IHQO2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAA72F1FD3;
	Thu, 18 Dec 2025 09:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766049631; cv=fail; b=jqkQIrEnzTgrvMjJCL+O4K+PA6Jk9kWmRQmmQqPa3uK5IIMhnonUtr2bFMq4KPebM8dyHQww5VgyDfEwBflvb/As0tzQKQbBKwwnwtjJIB91B7vwYGxoCVx57VaJuQEgm5AuFnUDYGBCz/blbB1qWhG4R/TwLtbEkbGSl3jkMB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766049631; c=relaxed/simple;
	bh=gbcpDK4kiIioeDQEsGxQcoa2Vk4SI0J5KhaCGzqy3jo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cANGG87MwsE5AVvd4kNxGecXSXyflFqOGEiPg2P3IgkfAFudkDC5+CmF5Q+W5mfiXgW2+6QWMHC0g6sFM9LTgfmEjLFzkm1Ya9gba7MkIYuEHyrs1SlezmKFHhgZcGC86UkJLYlYriOKR+g6IGy3/hNnRtTuSwl8FZE6GkW6xic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ft2IHQO2; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766049629; x=1797585629;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gbcpDK4kiIioeDQEsGxQcoa2Vk4SI0J5KhaCGzqy3jo=;
  b=ft2IHQO2arsO62Qh0MyMZes221+wsY6TDWWxjP0x6fgzRl3+SyvU9zMR
   fQlwEF+qqBK38j4LvQp6++So2tCWW0xT4iWzSxneZ23b7g253Uijxphdo
   FR3L7P2QYrXj2gc3l9CaCj9lVky3vCXknMe/e8j4xBJP2llTOqNqj2VDN
   R3JrQnwXmakOCvu1jHXgCcI/ubpvyBtSjB00Pr/z06QQwHyiomgc2NYaL
   k1mw30kncXL/Rfir1VFyAnON3hjVMu9CAuzHGWx7rTiOygaCNC3CqYuZa
   zhX2rw11BWIb6UaW9fuDy4L8vKfSgfOO04DmHeHqLP/COvOUPX/KxquDK
   w==;
X-CSE-ConnectionGUID: Szz5DynNRXu3xQP71Ljjng==
X-CSE-MsgGUID: +5s5u2zfSIunhecPgwjRKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="85583879"
X-IronPort-AV: E=Sophos;i="6.21,158,1763452800"; 
   d="scan'208";a="85583879"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 01:20:19 -0800
X-CSE-ConnectionGUID: bWFUeIgfQpeAcMUVG6gChw==
X-CSE-MsgGUID: gxm+8JAGQ+m66M9d9hATfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,158,1763452800"; 
   d="scan'208";a="221941574"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 01:20:19 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 01:20:18 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 18 Dec 2025 01:20:18 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.40) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 01:20:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hx3zMw67jbRKdM7CZ2eMaqhMzpRIxx3f4vaHp1iSJfcQWyAIK8x40grkG7voL2b5Rm1FOihqx8zZSt5Uwjr6GIaT06d8/aBou1h1eT706mOVsY67kt75JOoGa1ju2xn2VzrW7JQ8ARaBoehqj/NakJ1pY0/pgz+CIqUUjiEtpTnd+Z4Zak0CF8zA9MJ6b44A/STE5ns0s7+vMRCh9tq6zVSHYuXvhuf/nbHJN5L3cuPhcsaES5/0PnuSGidjdxvjRKRO52v+bKsDvAta2NYicZeNKvU9BiOXMeUK9NGPCQU3Qm05qwGOxQraHyZrn7eSRNw7hrAczaMNTbLLYEjYoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NzpsXefwLhygCr40IcTjhHeM4AiJDlTa/pmBrJUDCZI=;
 b=rEi7GiiR1mjm8IyC+72pPR/ItQFqUWq/225KEdECzj8USEvunKZurHu2Dzxz1JJ3uuBkO571Y+c2naPDx7+52eApdOcb8Sz3q79Xv5ddNWyzCgfb5vyTolyna9DVTx5rX3y0x5JI/ZMpwZ1tDJ+MM6NnUYYCMT9p394c71Q+wWg4hE/zCI5+0ZLyRh6nulsPvg6swRhueO6H15kth+zcrRBuOIq9cZvqSWJ6XISrjc0eMfGFX2FAYHm4/XWXx6G32I57mLEizbGu9ViFUPUzlvZde7I2IdGpSRJpzH2TRoZwl7a3DIps4zXlWRSdgazXiq3vdVm7PmI2O58X+HzqOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7494.namprd11.prod.outlook.com (2603:10b6:510:283::18)
 by DM4PR11MB7351.namprd11.prod.outlook.com (2603:10b6:8:104::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Thu, 18 Dec
 2025 09:20:15 +0000
Received: from PH0PR11MB7494.namprd11.prod.outlook.com
 ([fe80::353f:c8a8:2933:d288]) by PH0PR11MB7494.namprd11.prod.outlook.com
 ([fe80::353f:c8a8:2933:d288%6]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 09:20:15 +0000
Message-ID: <b542507a-eb97-473e-b125-0fb602d0f4c7@intel.com>
Date: Thu, 18 Dec 2025 17:20:07 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] vfio/pci: Disable qword access to the PCI ROM bar
To: Kevin Tian <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	"Shameer Kolothum" <skolothumtho@nvidia.com>, Ramesh Thomas
	<ramesh.thomas@intel.com>, Yunxiang Li <Yunxiang.Li@amd.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
References: <20251218081650.555015-1-kevin.tian@intel.com>
 <20251218081650.555015-2-kevin.tian@intel.com>
Content-Language: en-US
From: "Chen, Farrah" <farrah.chen@intel.com>
In-Reply-To: <20251218081650.555015-2-kevin.tian@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0032.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::23) To PH0PR11MB7494.namprd11.prod.outlook.com
 (2603:10b6:510:283::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7494:EE_|DM4PR11MB7351:EE_
X-MS-Office365-Filtering-Correlation-Id: 94482881-c131-4828-33bb-08de3e16a746
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MzczUmhoNzFhTG91V09Kclg0c3hnTlFCVENsMnpaTzlQWlpkQVpKd1JmTHhM?=
 =?utf-8?B?Y041ZzVPbkxxMUJPNEd6ZS9zRGZndnd4dUlKeG5MMFZnc0FJbFJsRWxLMVp1?=
 =?utf-8?B?cVV4SmRmaDNaZGtBWm1LZ0V2N1o4SXp3VGxCNzREdzVoUUlmVDFtNXJFZVBC?=
 =?utf-8?B?K01pNHFTY2QyaGMxaHNrY2N0RUNYV0JpV21Xbm1OdnU1T1dNZkJ1MXRqRWdt?=
 =?utf-8?B?QUxvMjVrU0MxU0lPV25pbFc3dmUzNmUyMllOMk1PK3d1RDVFSzBIRUZublpI?=
 =?utf-8?B?dTNsVnN0TEQ3UWlPVGVBdXhEamdobUp1eTFBRGhqRG16K2I1NlhLdmUvOW1o?=
 =?utf-8?B?bmx4L3ZBRlROTFRud2VwWXZFMXFYMWNRS3p3NVdlajZVVUdkQ09uZU41VlhT?=
 =?utf-8?B?dWxVeXZmemc5aytsYzVEUVdmUERTTjZITVJBQ2RDdXRFN0EzU1VkTU90U0dv?=
 =?utf-8?B?Q0FpZUpncENFZWtoNWNlUGszME1jRjRKdkg2YURSK2RVZVFhS2l6cjJEWHBy?=
 =?utf-8?B?M3NqbTRoRTFGVWtkUDdkWnRINnY2WGZYVnk2VCsyZkN5ZllSVjFiSkY0cVE0?=
 =?utf-8?B?cjZqM0NFRldlT0FOaUVmN1Rjd0luZjZpanpGRDZHQWdpQnYxR3ZGdU01MXgv?=
 =?utf-8?B?cHB1eE8xeHpFbEUvc3FiNWpsVDNoRmhCczV0NXZwdjNPMjlxTDZOUzVTVmxC?=
 =?utf-8?B?Q2NLVFhGMHhyV2JNcWsrbDVaQTIzNFhNeVExMDArbXppUlBxU2RRdEhSYnlP?=
 =?utf-8?B?T0tWcmVZaU9YVzZUVzNSYnlmc2tQUHpNVk03S0FMRGMyZGV5MzdEaVZnbEdG?=
 =?utf-8?B?N2d5c0VVcTF5Zzh0aVR0eDNLeFpjU0s4dXhIRVRpUEVBc3UzUFI1YkU1TFM3?=
 =?utf-8?B?RGdTL3lTSHNWZ2RxR3pGc0RobGQveUgvRjVHVUlSY0N3Y3RQRGtKRWVVVSs5?=
 =?utf-8?B?b2pNVTFTdXdsUG1QVlhoYTQ3V29PQVU3Z0txdExBb0lncHFMdE9UaWt4RW5j?=
 =?utf-8?B?UUNWanh2QUs2MVhpMlB6cjc5ek9DcDV1MS9CRGRLaXR6M1FIbFYzdVFDbkhN?=
 =?utf-8?B?VmNTMFM4OFJDb0ZJWTcrdlNOTXNjUnZCYTNrekVlY04rcjFZUUZOQ2hCV29l?=
 =?utf-8?B?RElKV1IzWm5zL000Y0Q3MWcwcTRubCtHejROTDhseTdSQTk0MUJKaEFlTnBo?=
 =?utf-8?B?aUNGNG56NWRpUVVpbDVoZlZnMHVrOG03bDVYanlCMCsvL3NwVVZKZUNqSzdx?=
 =?utf-8?B?T0hqUG94cUJkQ2ttc0ZQSWhBVUFvd09vN1YvVXhVYjlyV2EyczZaSjFXQ2VU?=
 =?utf-8?B?TUNKVEVuYmg4SjM2cTZJZlhOQ1FWRWJGWlcyblRuTkFxandicFZEeWZ5dkJZ?=
 =?utf-8?B?dldUSW1BNEJnZU5VSEJPTS9RMVloL1pUclNXbzlIaWNuQWhweW9MMExDZ243?=
 =?utf-8?B?YThZdndWL0pxTlU5SWx0NUFhODZEbmZYTkJ2M3BkdGhLUVZ6Sk1vdFhHOUpj?=
 =?utf-8?B?ZVI5Y1ZLckMxZStRUHljTE1IWVNJc0IzUERCczV4UFd0ank1TUhZZi81WnBn?=
 =?utf-8?B?ZEtUUnp4TUdrM2R1UzFCajBKQ244SmtQU210VWYrS3pHOEJpZTBVbkdWc3hY?=
 =?utf-8?B?OWhoNnM5dnJCQlZzeEtvUXBoaFJYWmNsZGlpZTlQQXdKZ3FWdEdWZG9KcjBk?=
 =?utf-8?B?MEdnOGZ2T05KamtjSy9xS0pIeW14aHdxbEJYVmVhZ2NLNkJzdy81R0lhYndk?=
 =?utf-8?B?aEt6Q2dheUhtbmhGeXBxeHdTdE9GWGNDazc0bkRZY2lIU1NZSlZMZjNxWWNJ?=
 =?utf-8?B?M0ZQK2YyTzVCMTVsNWNmRFlDUGZkcm1mM25NZzJSUU03eThZem41bVFWRFc3?=
 =?utf-8?B?ckJ0UE93Q1czaXpiUGxZM3FIYkkxd1pEdEF6TWowd0JtSnA5RzBEWnNOd3Rm?=
 =?utf-8?B?VTY1U2Q1dGNZbUdKenM4S0FNR0lEUCtweDVic1ZSNDlWS3hES1h2N2NmUGJR?=
 =?utf-8?B?WXRRK2F4VXZnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7494.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXN2dlpBdUpYY0VlMjd1SUU2NGFkcVFPeC9WYk9QeUJVSXN1NC9oVFlGNm1r?=
 =?utf-8?B?bVFXanJxUUpQTUFMTGRFTkxBM1hWTHR6SUh3ZFBZRjVGenhnSGdWYmZDeWVj?=
 =?utf-8?B?NHFFU0pDU09pM0xVSUFsVm1Ba2hnQ1hrelE3SDQvUlVJZXh6dFR6dzN6Zm5Q?=
 =?utf-8?B?NWhpdis0aW81RzE1REIyUmtONXpJa3FFbm5DS281Qks2NXpOcnl3dG9PdTlU?=
 =?utf-8?B?WEk0UGNjcXVlVWZVbE13ekttL3BQOXZJZXhoeU1oZk9Ub1FaUEE4bzdPVnBI?=
 =?utf-8?B?L3g0YlJ4OGN5LzZjMlRaekl0M3VVcmp3ZThtM1MwR2creE1iRzlBSWltNm5I?=
 =?utf-8?B?dGNpTXBsM0lueFRrS2pqUFZDSW5YM0R4ZExEK1NjditaU3R6eHo1V0dlTmt5?=
 =?utf-8?B?Um9OKzNQOWpLb1FPWEJkUjg3WHhJWjhibWhOQ0xmZUJ6MGZKY0kwYjkzeEZv?=
 =?utf-8?B?MTV5U3N3dWErdU1jSFAvOUZGTmlnOHZIaFFpZWVJakZCcHpPY1gvWTNFMHpG?=
 =?utf-8?B?bS85bHg1RW5hZkdQMUJyd0h2QXMrMDZEUDVaYVRkZGFjTDBCd3pUWENsWGVr?=
 =?utf-8?B?M0V4Y1d1bTRkRndzNGxpRHRvWmgwZjBDVStKMERyTDBYbVVXVkFOdVRqcU1s?=
 =?utf-8?B?MXR3Qy9HUXZiUm4ySGE0emJKMEY2M3RSMXFoV0cvYmdEbkE1cDJtQ1NzQU1P?=
 =?utf-8?B?M0plK1RJSTNsS1JmN3Z5b2Y5YkpiOHNzTDBBNzE2ZS8yRTI3cWZwZ2l2U05Y?=
 =?utf-8?B?N0dkbVMraGZkSm50Mjk2SFdSVC9KV205ekdFUkVVV0kxZ2dHVXVWRy9OUUhn?=
 =?utf-8?B?K2JhNWh6TmEveEdJbTU2OGNOYXNSdHVjclIrODkrOHJYVFVOVFl6aTVDaXov?=
 =?utf-8?B?ODBMWGRyVkZnbFlvTG1lYUwxTkVKVzJSdm9lMVVQa09kM2dnY1JZVzEzcnM5?=
 =?utf-8?B?SmNyaldoeEE3azV5QkFCQ05OY09mRUpiMS9QbXJFSllnTnVia3NjUzAzaDFE?=
 =?utf-8?B?cW5NWGpJVlJDZ1hrTGRUNlFIVlUxV2Jia05qckFsZDBqYW1jKy9wb0pjcm5E?=
 =?utf-8?B?TzFnUkdoaEU3dWZxOE1sOGZhTDA1NTBNM1pWN3BXMlQyMjFYYjdrUk5VNlpz?=
 =?utf-8?B?cHZ1MCtEMGJsbHlUQTZlZjNnRXNiMHVhVWwyUER6MmZkcmRrZkkyOHNTc3h3?=
 =?utf-8?B?NTlYT3h2dVJMbjJLRksxcDZMeUQ3dk83QjIzMGdva2xXN0N1ZHhZR0U2ZWdD?=
 =?utf-8?B?RG9tMTVLNjdrSVRWUnBFVFN1SGdha2ZjakxBaEk5dXYzd0Y0R0VtK2U1cVl3?=
 =?utf-8?B?MHVNWTllNmFQZkM1MFVnUmkxZDJRaXBza0tjVXlKaUZ1VVJiVHFVRVlJYnZJ?=
 =?utf-8?B?QWhmcXczVk5nMU5IclFscG9hd2tKRVdyQ3JpSnFtdE4ySUpYWnVXOFRQVVdD?=
 =?utf-8?B?VWI4cnVpM2ZDUGVSbnRBclJ5OXAwMFlsdStJZEFVcVNvbXluZWFWVEsySXVJ?=
 =?utf-8?B?NHBHeklVZERRNEhDZjAydjZ0SXVRWlplWDZRSGVxZTdieGJrWmVlVmJGSTMx?=
 =?utf-8?B?YllPR1RUM2hBekZVN0J1akRzOTVWRmVMS1pQMmdGVHZacEVvMlM5d1F0REVk?=
 =?utf-8?B?WUhYdVlrdWFPMXY5SkhMMTlWdUdHSkN4K3g3SlJTa1ZEY2tzOXI2M2RDT21P?=
 =?utf-8?B?Zm9WWFdoRVBjNVpnZG5iVTBMWVhsaURwUTR1Z01SdktDUEdWbVRkYnBrYmNH?=
 =?utf-8?B?TFozUWI4VGtXSWJ6c3h0aWtkOWg0RHV1YnEyQ1p4S2RIZVJSRXpNSjdlbVJG?=
 =?utf-8?B?WHlmTVMvZnVIMmJSYnc2UXNFTkpXd2pJL2Z2cHJ5cWxWVHRSTTJ6TFBaa0l6?=
 =?utf-8?B?Q2x6TWI2bjJQcmxJVjM4bDFRcy9KMURZYmw2REl4Z0N4MnJ2Ymk0Z09BaTBB?=
 =?utf-8?B?MjZNNXNuRmdOWWJoa2loM0YvSG0zU2RtOVVSTkdLMkFISWVua3Q3VHllTjVR?=
 =?utf-8?B?emY1VkI2Z0dvbkpvU0hreFhqTHZpcVZPVkJzWUFwZ0RCWlJDUzB3WUpZR0Iy?=
 =?utf-8?B?SFdrWkticE1aV0l6bWlGQVRsQ1BQMnBrem15dkhnU0I4SVBUTUM3dVNhelQ3?=
 =?utf-8?B?Sy9lMUF0OFFKS1htRDhpcDBLcG9vMEo0dTRES1ZERUpWZHBWMUlOME1oWjd5?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 94482881-c131-4828-33bb-08de3e16a746
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7494.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 09:20:15.2896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MUoyjz7KdqBpWhdK+8EXtPzftkCTcrh2hQq1IXfYTrj0Z7xWrHCKi6ny3+Pe/ZgNzVdY8oeW+WciJ4vHl/Xq7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7351
X-OriginatorOrg: intel.com

On 12/18/2025 4:16 PM, Kevin Tian wrote:
> Commit 2b938e3db335 ("vfio/pci: Enable iowrite64 and ioread64 for vfio
> pci") enables qword access to the PCI bar resources. However certain
> devices (e.g. Intel X710) are observed with problem upon qword accesses
> to the rom bar, e.g. triggering PCI aer errors.
> 
> This is triggered by Qemu which caches the rom content by simply does a
> pread() of the remaining size until it gets the full contents. The other
> bars would only perform operations at the same access width as their
> guest drivers.
> 
> Instead of trying to identify all broken devices, universally disable
> qword access to the rom bar i.e. going back to the old way which worked
> reliably for years.
> 
> Reported-by: Farrah Chen <farrah.chen@intel.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220740
> Fixes: 2b938e3db335 ("vfio/pci: Enable iowrite64 and ioread64 for vfio pci")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kevin Tian <kevin.tian@intel.com>
> ---
>   drivers/vfio/pci/nvgrace-gpu/main.c |  4 ++--
>   drivers/vfio/pci/vfio_pci_rdwr.c    | 25 ++++++++++++++++++-------
>   include/linux/vfio_pci_core.h       | 10 +++++++++-
>   3 files changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index 84d142a47ec6..b45a24d00387 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -561,7 +561,7 @@ nvgrace_gpu_map_and_read(struct nvgrace_gpu_pci_core_device *nvdev,
>   		ret = vfio_pci_core_do_io_rw(&nvdev->core_device, false,
>   					     nvdev->resmem.ioaddr,
>   					     buf, offset, mem_count,
> -					     0, 0, false);
> +					     0, 0, false, VFIO_PCI_IO_WIDTH_8);
>   	}
>   
>   	return ret;
> @@ -693,7 +693,7 @@ nvgrace_gpu_map_and_write(struct nvgrace_gpu_pci_core_device *nvdev,
>   		ret = vfio_pci_core_do_io_rw(&nvdev->core_device, false,
>   					     nvdev->resmem.ioaddr,
>   					     (char __user *)buf, pos, mem_count,
> -					     0, 0, true);
> +					     0, 0, true, VFIO_PCI_IO_WIDTH_8);
>   	}
>   
>   	return ret;
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index 6192788c8ba3..25380b7dfe18 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -135,7 +135,8 @@ VFIO_IORDWR(64)
>   ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>   			       void __iomem *io, char __user *buf,
>   			       loff_t off, size_t count, size_t x_start,
> -			       size_t x_end, bool iswrite)
> +			       size_t x_end, bool iswrite,
> +			       enum vfio_pci_io_width max_width)
>   {
>   	ssize_t done = 0;
>   	int ret;
> @@ -150,20 +151,19 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>   		else
>   			fillable = 0;
>   
> -		if (fillable >= 8 && !(off % 8)) {
> +		if (fillable >= 8 && !(off % 8) && max_width >= 8) {
>   			ret = vfio_pci_iordwr64(vdev, iswrite, test_mem,
>   						io, buf, off, &filled);
>   			if (ret)
>   				return ret;
>   
> -		} else
> -		if (fillable >= 4 && !(off % 4)) {
> +		} else if (fillable >= 4 && !(off % 4) && max_width >= 4) {
>   			ret = vfio_pci_iordwr32(vdev, iswrite, test_mem,
>   						io, buf, off, &filled);
>   			if (ret)
>   				return ret;
>   
> -		} else if (fillable >= 2 && !(off % 2)) {
> +		} else if (fillable >= 2 && !(off % 2) && max_width >= 2) {
>   			ret = vfio_pci_iordwr16(vdev, iswrite, test_mem,
>   						io, buf, off, &filled);
>   			if (ret)
> @@ -234,6 +234,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>   	void __iomem *io;
>   	struct resource *res = &vdev->pdev->resource[bar];
>   	ssize_t done;
> +	enum vfio_pci_io_width max_width = VFIO_PCI_IO_WIDTH_8;
>   
>   	if (pci_resource_start(pdev, bar))
>   		end = pci_resource_len(pdev, bar);
> @@ -262,6 +263,16 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>   		if (!io)
>   			return -ENOMEM;
>   		x_end = end;
> +
> +		/*
> +		 * Certain devices (e.g. Intel X710) don't support qword
> +		 * access to the ROM bar. Otherwise PCI AER errors might be
> +		 * triggered.
> +		 *
> +		 * Disable qword access to the ROM bar universally, which
> +		 * worked reliably for years before qword access is enabled.
> +		 */
> +		max_width = VFIO_PCI_IO_WIDTH_4;
>   	} else {
>   		int ret = vfio_pci_core_setup_barmap(vdev, bar);
>   		if (ret) {
> @@ -278,7 +289,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>   	}
>   
>   	done = vfio_pci_core_do_io_rw(vdev, res->flags & IORESOURCE_MEM, io, buf, pos,
> -				      count, x_start, x_end, iswrite);
> +				      count, x_start, x_end, iswrite, max_width);
>   
>   	if (done >= 0)
>   		*ppos += done;
> @@ -352,7 +363,7 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>   	 * to the memory enable bit in the command register.
>   	 */
>   	done = vfio_pci_core_do_io_rw(vdev, false, iomem, buf, off, count,
> -				      0, 0, iswrite);
> +				      0, 0, iswrite, VFIO_PCI_IO_WIDTH_8);
>   
>   	vga_put(vdev->pdev, rsrc);
>   
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 706877f998ff..1ac86896875c 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -145,6 +145,13 @@ struct vfio_pci_core_device {
>   	struct list_head	dmabufs;
>   };
>   
> +enum vfio_pci_io_width {
> +	VFIO_PCI_IO_WIDTH_1 = 1,
> +	VFIO_PCI_IO_WIDTH_2 = 2,
> +	VFIO_PCI_IO_WIDTH_4 = 4,
> +	VFIO_PCI_IO_WIDTH_8 = 8,
> +};
> +
>   /* Will be exported for vfio pci drivers usage */
>   int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
>   				      unsigned int type, unsigned int subtype,
> @@ -188,7 +195,8 @@ pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
>   ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>   			       void __iomem *io, char __user *buf,
>   			       loff_t off, size_t count, size_t x_start,
> -			       size_t x_end, bool iswrite);
> +			       size_t x_end, bool iswrite,
> +			       enum vfio_pci_io_width max_width);
>   bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev);
>   bool vfio_pci_core_range_intersect_range(loff_t buf_start, size_t buf_cnt,
>   					 loff_t reg_start, size_t reg_cnt,
> -- 
> 2.43.0
> 

Tested-by: Farrah Chen <farrah.chen@intel.com>

With this patch, I tested device passthrough with an Intel X710 NIC. No 
PCIe errors were found, and the device works well in the guest.

