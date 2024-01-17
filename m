Return-Path: <kvm+bounces-6372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 813BF82FE93
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 02:54:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9C721F27706
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 01:54:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF75979D8;
	Wed, 17 Jan 2024 01:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AI/OOeGv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78443747C;
	Wed, 17 Jan 2024 01:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705456443; cv=fail; b=cJBUsVj23DHVrGENg16LdKNOjj0a72gm9UmSPVYfzfY4aiImJPOLMmPq4ZxgG3TSCBlPKdCStSCAyAxcWkNA/g26sJwEzWz5/nDcN5cqHCK6TWDi/QFYCf4fGEHZmdFQRoy0Yyk4yO7Oj9z4axuW6z0EldtTQZZYysnrtpGRYFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705456443; c=relaxed/simple;
	bh=uQTL7zVPfHWJE55L1WhZ91UdNxjvlJlWUTVgGmmED0Q=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:
	 ARC-Message-Signature:ARC-Authentication-Results:Received:Received:
	 Message-ID:Date:User-Agent:Subject:Content-Language:To:CC:
	 References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	b=S093VxTGQuCqwsHUyybA8pg157BzSU1E6SmVG6cZcqQqP8dpm3sqg02AtY0atxomSoyi37avaIH6fBk7AZ88ROmNimUQEN1OvbMQlMO9v7WjFTdh1fBI+JBstfw5PPhX/N5lLoc2UpDQ1CoR4nHsoQvQx47nYzMx4k7XqoLcMFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AI/OOeGv; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705456442; x=1736992442;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uQTL7zVPfHWJE55L1WhZ91UdNxjvlJlWUTVgGmmED0Q=;
  b=AI/OOeGvKKmvQT+MkJ4siye+Fdrbb7xSuUZ9x8TVaJGr0NPnY+YElpN2
   DQGDi5DqiyJzmQfePZ0jV2aszehZwQ+U0l64Gs4+UOAUIEC0TIFQUYLfh
   1coRa07S/SitmtXvm1Mx7rlLF1OB3WY7GQGaBAz2eXtWCWomd3whUtu4P
   qDi2oQBAUx8DKqajMfTxJ+brmf3dHi5kEDPqUo0s889W72qDEOHZArdHq
   LiRFVS5iLcZW6jWS7o6qzxzpNjRWO7T1imfRRyBRYd8y3yvMCaxLsea6B
   7OI7vndPBdTcBR/TkUMq2l+3egqPhPn2eYa1fdzbImXy0/ZinwkeS62/M
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="7137008"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="7137008"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 17:54:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="903354201"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="903354201"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Jan 2024 17:53:59 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Jan 2024 17:53:58 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Jan 2024 17:53:58 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Jan 2024 17:53:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KBsjX0pHw1rMsNa6ybV+9y5Q9IUGVsPFcxSRYiT1pj+WXL5rGn33Gx0dLFfrCxAdIPeqpk+CPvx1IyaxiiLLvH/n0y90aA8cmji46uc9MvzahTHYkGFa1jLI0Jlfo5qWxa5sIXzU0iYMaXlxE6LnzMl1aL2bhzLRSbZrS6yVwufZQOd4cJ70B8Op3dJMuzBNhJD5j8Qx+q+R+cycPPap6Zoi+YaXR2OZG1xckbX+HEJy+22nyCT6/erzMhW3EXh20W5YOJ0N3KVez1/V0qVvNmJRTzjIMw2eM4RXFM4qA+qmEfmdsFdkMjPgUIHfjb2Fu3F9Xiaze4aOoOe8aalLGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BfqJiIlXvdFtLh20yKQk/z5Q44SMJko81tMdWQj077g=;
 b=L+KuQ/wOXtxUKlc1aJGkd78xP+wndBrbacSdgYE/dt3wGGk4DdWsMKpeVOkXQ4UDtbeh7FbH+cKFsQhOabVPxf+U5dO86MLn05DtUWbUpARtB7OS3Dy03fxdnIxGmkJmvQ8FRXjDzYmMsRbMwlGl71pUmRX024ZEx5LvOSCr57lH1LNHHYXO32qXXVdZ2mSFSB+znnpaJxgw+MZanf1d9jDj9ZZ047lHSOsr6mOF6a9SNnjYR8I6qI6I9cW5dE63+LJ4XURF8IxXcxBLiR6vZFwz99VhYZPd/omOXwkxfM2D2hBAxmAK1enn41cbdJqRBsL29Yvm9ZRpy3b+dci+ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by MW3PR11MB4537.namprd11.prod.outlook.com (2603:10b6:303:5d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.23; Wed, 17 Jan
 2024 01:53:55 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1%3]) with mapi id 15.20.7181.022; Wed, 17 Jan 2024
 01:53:55 +0000
Message-ID: <11b44e90-3501-42c5-a0bf-cfe5539232e7@intel.com>
Date: Wed, 17 Jan 2024 09:53:43 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 26/26] KVM: nVMX: Enable CET support for nested guest
Content-Language: en-US
To: Yuan Yao <yuan.yao@linux.intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
 <20231221140239.4349-27-weijiang.yang@intel.com>
 <20240116072223.zzniln3rcxybxxqi@yy-desk-7060>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20240116072223.zzniln3rcxybxxqi@yy-desk-7060>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::16) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|MW3PR11MB4537:EE_
X-MS-Office365-Filtering-Correlation-Id: 102863a7-a93a-4f80-995f-08dc16ff29a5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7+yS5jnuYuNBpFpadUskMXhB8PtgBeypcCIeVFcjtM5lLa+Q6vNCRxUpv7ElEiEuCYiO4gCteUGOZdcLKKbgBcVgUdRZBZfgyogK+VmKwa8c3DuDoHPgOBdUBBKV1aQDxsuOor1xQYdrIYSfgP6B4DmHVJsQrMwTKmO9ihJIVOYD/hB4YTkxnnw4rxmggm/4OvrXcafBmyCC7QufjW0gq2NnSEeKNHmd2C7TbOGrGR4ZxvKFI4oo8ssLDQ8t9epQwatN7htw7IhhMBej3Qkt7bcqMxl05d+RINolQzU47a6KQK6oZ4O+7l8kiQUa56w/PdYdDAyhbh3H9OCC1sHm+PvI/nBPmgG9/axIDkb8dcXf412cfxFqpKFVyBv4p9t2k4T5/GBkr2hj1zNhVgwzOdU09Qng85p/H9Wfqmtpo4Tc8N5vPJf6oiWaXyJPwbUGf59AY3DUFHBscMtP43misE5geWm59Zy9kfCiAnKowAg4WHD7eRFnj4m55F9bKXcG8i3qpmGEM1Rr+bfraqza0MOUM0DiEisaYngVcnNupUpdKs6lBuraVwqmFPkapHgrjURC4tSdV5W3NEfBl8/o0O+oaqm4QlHeJOZptyWXmsVNXmyhWyzSv04PCNtpaWv+x2EkRyOQksetxn7MTqfm6Rhrpy4UdBW7TkP/d30siNs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(39860400002)(396003)(346002)(376002)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(31686004)(6666004)(83380400001)(5660300002)(4326008)(66556008)(6506007)(316002)(8936002)(66946007)(8676002)(6916009)(66476007)(6486002)(6512007)(26005)(2616005)(478600001)(38100700002)(53546011)(82960400001)(41300700001)(86362001)(31696002)(2906002)(36756003)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZlJINXB2TTE0eFV0aVJJUzVpNVVyRXl6Qjh5R25aOTErSDN1UklZdnZUYks2?=
 =?utf-8?B?a2FsSVBzRmNYOFdQa1o3b0tWSlF4NmRGODVGQ2RqTUZzclR0Z083MDdCRm8w?=
 =?utf-8?B?VUpobnpSdHFPWFk0alkyYUNZZnR5NEdqT2lmSnVzc2VUSTlwTFB1OXdMNVBV?=
 =?utf-8?B?THJYR2FrMG9ZSXQ4V3BWNzFzVEdXZjJsRzdiVU1LL2YrdU9tYlNPaWtEYmtN?=
 =?utf-8?B?eTZPMDZmSm83YnV0dzRVRjZWV0xkcHZnejZmRUVGTXpnbm9IL1ZLc0hZRGhw?=
 =?utf-8?B?SEwrMmM0NWJRQWoxdElhVTNJWlpyQlJoOVB0Z0NKVXVuM1JuUGJ4ajVzNU9s?=
 =?utf-8?B?WGlYUkJzSWI1TFUrRDFFMmNKQ2FxTy9BRGdjL2VXaWZpazRRa1VBT1ZsT0Rz?=
 =?utf-8?B?SktLOWRCQ3pLaDlMMTdMQmxHV1NVdHpGR0ZBRDJwb2MwRHlNVEUwQkZDUWxz?=
 =?utf-8?B?bnZnaFVmb28zQ1dVc2NOb1NoRmxHdDJ0N0FQenp3YmdFM2tjdFBWa2lSM2Np?=
 =?utf-8?B?cmVaQzcwOWVQRStWVm5ZdlFobFdKMUFBOTN1d0hHWjYwUW1ndFNKSVNzOG0w?=
 =?utf-8?B?VWxOTno2YksybFpld0Q5dmdNY2hOQUhZNmJrMHVwb0Zhd0tzbmkyVkNRNWQx?=
 =?utf-8?B?VXVCVVdxczljZENSQUxWR2lIWUp4amNVNksrbWpwc1RqTWNVNS9rdTlVaXVZ?=
 =?utf-8?B?b2R5SGdpTVRJVnlCS3ZjdVVtbERHeHJWVHZnMS9PYTBVa0J0QlJoNUNwK09M?=
 =?utf-8?B?YmNMZE95T2FDMW1pVHFBOEYzckhSRnNBQmFmTENlQWdpTE42KzdYdEE5VFkx?=
 =?utf-8?B?QktCUjY5WmJGSFo4UEIyMFhzQUJIQlZydzkvb2UzeGlZYlZOTjVwUndVYWVw?=
 =?utf-8?B?UDJqVDQ5Mnk0VFdsUldvWm5Od0xDeC9CVC9FUTVNZFNDWG9xby83dGg5WTJ2?=
 =?utf-8?B?NjVOa3gwbUVBWUhydDQyUS9JWmtzU29zRWZiQzVPaHZQZ0FQSHdIR2dyWk45?=
 =?utf-8?B?OW5mN1Q3REgxbDdYQzVZeTU2MC9wMjV1NHFDWnNKUElsVkUxb1ZoM2lCTlFF?=
 =?utf-8?B?NkhMdGtkZG00Q1QxcmNXNGVNWWZmbEFsMnRJNElMb3dadzNoTmtFVVBVb3VU?=
 =?utf-8?B?SGRFbVgzRHNtRUZxbHFCS0Nsa0JDbmtHbGVUVnRoRFMyalpPbXVRTUR5VFpa?=
 =?utf-8?B?NlYrQjN2aU92dFdnQlpLZ1FFSmlWNnFhTkFIVC8wTGZGRkFRUi80MVI4ZHJB?=
 =?utf-8?B?T0J2OXFONUthTng0UVBYbU5lcEliQ0NzcURXSEhDOTg4YU9mTlA1YXk3QlBN?=
 =?utf-8?B?NmsyQzQ0eDI4TkplUFRFVnlncmRuQkZ1YXl1bWlXOC9hbWVhcmVJSkQzRWxO?=
 =?utf-8?B?blV2U21SN0U4a0lRK3Z1YVhSZk9XTFZ1ZGdBYUZaZStVcDJScEZqOFRlRlFk?=
 =?utf-8?B?SHFQUTZIRU5tcXdRVzE0SUZHdU9Mb2hWQWl0eDhMM2RuazJUaHFEaDAxVXBB?=
 =?utf-8?B?MW5IUlk4NU9ueWtIakxVRWgvUEFtL2w2bitaeGZQMXdYazQzV2l2S05tdTAw?=
 =?utf-8?B?MllWZVBua2VGUmhzMndrcjNmMkZvUDNaVmFscHJJTEJScks3WGZlY2hGQ2pp?=
 =?utf-8?B?VEhzdm9HcHB3SWhmK3NERnVSekZ6V2JqL095NW9YbzFTUm1yK1U2bFNwdUFq?=
 =?utf-8?B?QjlMeFpVOUhOaFdheDNrRjV1cDRZNmdZOTVqc1IvV3hHZnRNc2xVTUtoMklU?=
 =?utf-8?B?cWVGK2s4Ynh0NWtrclF6TGw1ajRwS2owLzJUSnQycWZFV0QrM2tMWW9hd0c2?=
 =?utf-8?B?SGZURUQwUitqMUs1YjM5R3Jwa0N5aTJ1Sk9qTjZUN3pSczlnMmhBa2UzVGlP?=
 =?utf-8?B?MHBxUmtGbFBSditjd0k2UmY1NTZHMmtLNWxyRXcxem9DK3cwbVlnRW1ldnMr?=
 =?utf-8?B?MDcyU3h5NHVxVXFkQjNEUk9KZnoxa05sQm0xSGc0MkwxWFJndkFNY2RudElI?=
 =?utf-8?B?bFI0eTBUeVAvUkhjbUpyUjdNQUhVWGsxUndIUGFhYVRwU3Joa1FGVW9Ebmp4?=
 =?utf-8?B?dTBydXlyMGkydlhYUmRYbVJEYkR1ZkxYeUtWRWNaVmR1K3NVM1VYczE3S1kr?=
 =?utf-8?B?bGVnU0wxWUtOd2M1bVN4OEx5R3d5eGovQlRFbUlEbDM5QkxhQ0N2YStSUHJM?=
 =?utf-8?B?T1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 102863a7-a93a-4f80-995f-08dc16ff29a5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2024 01:53:55.4173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9TZc4GIkxQRsVPXS3QKHBUVzgGAWWGIvwEtXXSBbn2SgvIWKwtO+Tn9s1T8JquLIrS6o6RXCoGvP+1qToyHx9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4537
X-OriginatorOrg: intel.com

On 1/16/2024 3:22 PM, Yuan Yao wrote:
> On Thu, Dec 21, 2023 at 09:02:39AM -0500, Yang Weijiang wrote:
>> Set up CET MSRs, related VM_ENTRY/EXIT control bits and fixed CR4 setting
>> to enable CET for nested VM.
>>
>> vmcs12 and vmcs02 needs to be synced when L2 exits to L1 or when L1 wants
>> to resume L2, that way correct CET states can be observed by one another.
>>
>> Suggested-by: Chao Gao <chao.gao@intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/kvm/vmx/nested.c | 57 +++++++++++++++++++++++++++++++++++++--
>>   arch/x86/kvm/vmx/vmcs12.c |  6 +++++
>>   arch/x86/kvm/vmx/vmcs12.h | 14 +++++++++-
>>   arch/x86/kvm/vmx/vmx.c    |  2 ++
>>   4 files changed, 76 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 468a7cf75035..dee718c65255 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -691,6 +691,28 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>>   	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>>   					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
>>
>> +	/* Pass CET MSRs to nested VM if L0 and L1 are set to pass-through. */
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_U_CET, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_S_CET, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_PL0_SSP, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_PL1_SSP, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_PL2_SSP, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW);
>> +
>>   	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
>>
>>   	vmx->nested.force_msr_bitmap_recalc = false;
>> @@ -2506,6 +2528,17 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>>   		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
>>   		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>>   			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
>> +
>> +		if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE) {
>> +			if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK)) {
>> +				vmcs_writel(GUEST_SSP, vmcs12->guest_ssp);
>> +				vmcs_writel(GUEST_INTR_SSP_TABLE,
>> +					    vmcs12->guest_ssp_tbl);
>> +			}
>> +			if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK) ||
>> +			    guest_can_use(&vmx->vcpu, X86_FEATURE_IBT))
>> +				vmcs_writel(GUEST_S_CET, vmcs12->guest_s_cet);
>> +		}
>>   	}
>>
>>   	if (nested_cpu_has_xsaves(vmcs12))
>> @@ -4344,6 +4377,15 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
>>   	vmcs12->guest_pending_dbg_exceptions =
>>   		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
>>
>> +	if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK)) {
>> +		vmcs12->guest_ssp = vmcs_readl(GUEST_SSP);
>> +		vmcs12->guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
>> +	}
>> +	if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK) ||
>> +	    guest_can_use(&vmx->vcpu, X86_FEATURE_IBT)) {
>> +		vmcs12->guest_s_cet = vmcs_readl(GUEST_S_CET);
>> +	}
>> +
>>   	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
>>   }
>>
>> @@ -4569,6 +4611,16 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>>   	if (vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS)
>>   		vmcs_write64(GUEST_BNDCFGS, 0);
>>
>> +	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_CET_STATE) {
>> +		if (guest_can_use(vcpu, X86_FEATURE_SHSTK)) {
>> +			vmcs_writel(HOST_SSP, vmcs12->host_ssp);
> Shuold be GUEST_xxx here.
>
> Now KVM does "vmexit" from L2 to L1, thus should sync
> vmcs01's guest state with vmcs12's host state, so KVM
> can emulate "vmexit" from L2 -> L1 directly by vmlaunch
> with vmcs01.

Right, I'll change it, thanks for pointing it out!

>
>> +			vmcs_writel(HOST_INTR_SSP_TABLE, vmcs12->host_ssp_tbl);
> Ditto.

Yes,

>> +		}
>> +		if (guest_can_use(vcpu, X86_FEATURE_SHSTK) ||
>> +		    guest_can_use(vcpu, X86_FEATURE_IBT))
>> +			vmcs_writel(HOST_S_CET, vmcs12->host_s_cet);
> Ditto.

Yes.

>
>> +	}
>> +
>>   	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PAT) {
>>   		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
>>   		vcpu->arch.pat = vmcs12->host_ia32_pat;
>> @@ -6840,7 +6892,7 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
>>   		VM_EXIT_HOST_ADDR_SPACE_SIZE |
>>   #endif
>>   		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
>> -		VM_EXIT_CLEAR_BNDCFGS;
>> +		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE;
>>   	msrs->exit_ctls_high |=
>>   		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
>>   		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
>> @@ -6862,7 +6914,8 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
>>   #ifdef CONFIG_X86_64
>>   		VM_ENTRY_IA32E_MODE |
>>   #endif
>> -		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
>> +		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
>> +		VM_ENTRY_LOAD_CET_STATE;
>>   	msrs->entry_ctls_high |=
>>   		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
>>   		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
>> diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
>> index 106a72c923ca..4233b5ca9461 100644
>> --- a/arch/x86/kvm/vmx/vmcs12.c
>> +++ b/arch/x86/kvm/vmx/vmcs12.c
>> @@ -139,6 +139,9 @@ const unsigned short vmcs12_field_offsets[] = {
>>   	FIELD(GUEST_PENDING_DBG_EXCEPTIONS, guest_pending_dbg_exceptions),
>>   	FIELD(GUEST_SYSENTER_ESP, guest_sysenter_esp),
>>   	FIELD(GUEST_SYSENTER_EIP, guest_sysenter_eip),
>> +	FIELD(GUEST_S_CET, guest_s_cet),
>> +	FIELD(GUEST_SSP, guest_ssp),
>> +	FIELD(GUEST_INTR_SSP_TABLE, guest_ssp_tbl),
>>   	FIELD(HOST_CR0, host_cr0),
>>   	FIELD(HOST_CR3, host_cr3),
>>   	FIELD(HOST_CR4, host_cr4),
>> @@ -151,5 +154,8 @@ const unsigned short vmcs12_field_offsets[] = {
>>   	FIELD(HOST_IA32_SYSENTER_EIP, host_ia32_sysenter_eip),
>>   	FIELD(HOST_RSP, host_rsp),
>>   	FIELD(HOST_RIP, host_rip),
>> +	FIELD(HOST_S_CET, host_s_cet),
>> +	FIELD(HOST_SSP, host_ssp),
>> +	FIELD(HOST_INTR_SSP_TABLE, host_ssp_tbl),
>>   };
>>   const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs12_field_offsets);
>> diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
>> index 01936013428b..3884489e7f7e 100644
>> --- a/arch/x86/kvm/vmx/vmcs12.h
>> +++ b/arch/x86/kvm/vmx/vmcs12.h
>> @@ -117,7 +117,13 @@ struct __packed vmcs12 {
>>   	natural_width host_ia32_sysenter_eip;
>>   	natural_width host_rsp;
>>   	natural_width host_rip;
>> -	natural_width paddingl[8]; /* room for future expansion */
>> +	natural_width host_s_cet;
>> +	natural_width host_ssp;
>> +	natural_width host_ssp_tbl;
>> +	natural_width guest_s_cet;
>> +	natural_width guest_ssp;
>> +	natural_width guest_ssp_tbl;
>> +	natural_width paddingl[2]; /* room for future expansion */
>>   	u32 pin_based_vm_exec_control;
>>   	u32 cpu_based_vm_exec_control;
>>   	u32 exception_bitmap;
>> @@ -292,6 +298,12 @@ static inline void vmx_check_vmcs12_offsets(void)
>>   	CHECK_OFFSET(host_ia32_sysenter_eip, 656);
>>   	CHECK_OFFSET(host_rsp, 664);
>>   	CHECK_OFFSET(host_rip, 672);
>> +	CHECK_OFFSET(host_s_cet, 680);
>> +	CHECK_OFFSET(host_ssp, 688);
>> +	CHECK_OFFSET(host_ssp_tbl, 696);
>> +	CHECK_OFFSET(guest_s_cet, 704);
>> +	CHECK_OFFSET(guest_ssp, 712);
>> +	CHECK_OFFSET(guest_ssp_tbl, 720);
>>   	CHECK_OFFSET(pin_based_vm_exec_control, 744);
>>   	CHECK_OFFSET(cpu_based_vm_exec_control, 748);
>>   	CHECK_OFFSET(exception_bitmap, 752);
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index c802e790c0d5..7ddd3f6fe8ab 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7732,6 +7732,8 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
>>   	cr4_fixed1_update(X86_CR4_PKE,        ecx, feature_bit(PKU));
>>   	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
>>   	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
>> +	cr4_fixed1_update(X86_CR4_CET,	      ecx, feature_bit(SHSTK));
>> +	cr4_fixed1_update(X86_CR4_CET,	      edx, feature_bit(IBT));
>>
>>   	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
>>   	cr4_fixed1_update(X86_CR4_LAM_SUP,    eax, feature_bit(LAM));
>> --
>> 2.39.3
>>
>>


