Return-Path: <kvm+bounces-48471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4520EACE991
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:02:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05BE7176F3C
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 06:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC271C5489;
	Thu,  5 Jun 2025 06:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L8wGNfp/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526AD1FC8
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 06:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749103340; cv=fail; b=DC94sE1X2vgPXKnZtqu5ZSm3VcCFe5naIsLL2GCXPPSTqXH9azAvDCUVXWF7NOMDtj+d5cMYJSBViQdNWpMj2ihZ0aOmOXwh+czWmNZ0vVHcMDZPB/2OdbPVNWJLQbLrtGvOH8/2Lh90QMIrDngY5RromZFqgwAOJ2fve34Ceio=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749103340; c=relaxed/simple;
	bh=x6uemkhHgbZnzTF862+hcM7RRQQIg2Di1cLL/FdNDD8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Mee1jRaWSGXc0wWdnL09tjAsjOoWkjPnpdl7u6Nc1PNVDse+F2xcafHTQpaZR8yGq7uSeNadyvRxgiRxUdOnsznPz/tm+AB7S+mpTP+wUWCvqUajHBkf+Aq8dhiJW4TwwSM2FyGVfnTYidwSY4N9Xeuw4pjKnB5VGuJaLceF9Mg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L8wGNfp/; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749103338; x=1780639338;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=x6uemkhHgbZnzTF862+hcM7RRQQIg2Di1cLL/FdNDD8=;
  b=L8wGNfp/4JweIFbDZ7/u95QoYKNypUDnFoqShOH6Flj5lGSzIsyYY2mX
   3l07ACtTMv+l3FW32mtg1mSUMa/MQ8ilstHc/7iZ2FqDas6z7Akp9B4j1
   vdijiqPfwJS8HHcL/9jtbYx7eMs2ARw2a9HANP9Kxv2858b8YvjjWh/Yj
   EK2yHxIJ+Lt/nVcub6E3JJeOcTk53H3AVBfZJObcMFdfZLxRCWoWx3jzk
   vK6uiZrPo1ZteQ/Vup+pgujLXOBKlCfK3kDR58ESz3l5HaGtM2NO2DSyG
   BUwByS4JBTqkvskxSxd6xccZotlCD3ggXoGYJLEujjyhUdH6QiDkb9ErH
   Q==;
X-CSE-ConnectionGUID: B0rtltS1TQuc2xf+jLopAA==
X-CSE-MsgGUID: eH9DKSwjSWGRnO7ssG6Feg==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="51351302"
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="51351302"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 23:02:17 -0700
X-CSE-ConnectionGUID: bOfqDZ6YSQCktIAZ9gtHyg==
X-CSE-MsgGUID: oS1f0frQRb2Zsme3r62ucA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="146392830"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 23:02:13 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 23:02:12 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 4 Jun 2025 23:02:12 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.56)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 23:02:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AX6OeInoGCLpBWXLUfxvrvCxy9wcow3WiZJJyUJcfO4PvMOqlrTDAmD1ahr+yRcRB8ZqCM3l1RbyRf0uyMrG0w8YOmqsmnQIzTdMlS1EwZU1cBkTuVU3cKRZpHkJRXYHK5EqSvagAW6FrdBMb++idCVVoNOvl2WKv4MiGr0Tl2RJk+wJ4BvQ/i918EDwJ3YPbAXkTzp9OApwA7pJyyUnLeWco6PlNH/07ekxCOAdx2WiYg6ii8M2evf5UWmBmnvk87QJPWrzMMkOdOHJgGpjTTvJhAncRM2GDguY3wSfybO3c+PtJYmST/M0OY9+i0VJEl/q2cqn0PK9UkDXiBMGaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hlQzWcS1X4I6H+lEI9upQ4KF2BJ3Z5VQJtyihesxtG8=;
 b=otL2g+WSbqZ4I47SRLrc6+tsu1VZ7ohsFrFT98+9UWJ0G3gdY+26HxXtmacsJRZENnG+8wX+h40vswrH4KZPfgiNpN5xdZDzVa9IYuWvFw0Q9jsDVSDdanl3Y9IZAcZHM5fcGH0v8Tn5OzT0iwhhfgtbPpNJXwp+aAPu6bTAb22hMEvlCYQBYrw9hQ4pfhj8azLVXRe0TdYhnvjPdNfaJdljPEwRAqru4Z9sBghfBvGHMtzTKPamS80K97Cst46ZxCnceLqZROACZeWCdc7mpVfux0vNSC57vzrx2NRdWUU1sDN/+funEfR9aLZGJpfV7teZ+JZj01c3gPWhEyzGUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH7PR11MB6674.namprd11.prod.outlook.com (2603:10b6:510:1ac::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.37; Thu, 5 Jun 2025 06:02:09 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8813.018; Thu, 5 Jun 2025
 06:02:09 +0000
Message-ID: <0fc5d786-5cb7-4fe6-aab4-b641b815c04d@intel.com>
Date: Thu, 5 Jun 2025 14:01:59 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/5] ram-block-attributes: Introduce RamBlockAttributes
 to manage RAMBlock with guest_memfd
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>, Baolu Lu
	<baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, Alex Williamson
	<alex.williamson@redhat.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-5-chenyi.qiang@intel.com>
 <55ebb008-a26f-4173-937a-3bb2d8a6c972@amd.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <55ebb008-a26f-4173-937a-3bb2d8a6c972@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::6) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH7PR11MB6674:EE_
X-MS-Office365-Filtering-Correlation-Id: 8043a4ab-2bc6-43f3-dd3b-08dda3f6819e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?R1h2Z3VWMmZIQkZhQnBZakx3WnNtL3NaL29Wb2pySkwrY1R0dDZYamhoTDhj?=
 =?utf-8?B?aFZUU0RYMUU5RlBoTExrVERCcXJmTm93Qm5vNm12bUcyQjc5SURKOEp1Nld0?=
 =?utf-8?B?enVkSzZOWlExSyt1a1ZENEJwejF5dmFMK2MycG1KaUU3Nlk4OHF6d0tXd0hK?=
 =?utf-8?B?L0FXR3Y0a3lVRG5pZWtRVVQxSDhGZlMyYnhZYkxMVWJIaWRyN0NqV3Z2aWlK?=
 =?utf-8?B?SmJqU1dCNXd1QnVsNDNwRDUrSm9IK2RETGZ3TzFZL2tNR0Y3U05vclR5ZkNr?=
 =?utf-8?B?RU9RN00ra2VuRmpTS3NXbjFka3YwUXFVaWFSVmwyc2VaL1dDa1R6WXBZMTBh?=
 =?utf-8?B?bUVBTjdoVFJiVitCYkJ6WldQbndPZjBvS25mOFg1a3d6dHcza09BM1JZQkxz?=
 =?utf-8?B?UUFIYks2SmtRdWNSMDJyTlBSakJ6OVljdHpXdTdJRHZmYnZwSkU3UDlORFJK?=
 =?utf-8?B?N0xnSmttbm9NWlI4eTdpMWM2a3YvazRRQ2FXcVFWQ1orVzRiVmRHeWFaUUNl?=
 =?utf-8?B?Z0dUdDdmSGJoREJMMGdNVno0SGlrdkRoTzAxVm5wQ2tuU1JrM09NM3VVZS96?=
 =?utf-8?B?bjZWSFRiS3NCYUJlblo5OEs1eE5rTno3QytEeU02RlpuZVorcWdMSHVjOUtV?=
 =?utf-8?B?S2hWRmZGR1NYdWZWKzE4RWpvdWhNZmwrL0p0SHdkbUwrakd5MGtaOVBNaUtz?=
 =?utf-8?B?RDRnZWp3NzVTMFdHUU9qQWhIWEhSdlZ5clNKdmNrbXcyc1ZVVEFSOGhHTXhi?=
 =?utf-8?B?UHZoUWxFYzFRNnBmRzFyVnJDay8vdEtsVWNPNURSUmNSWmF1QWxlc3FrVnZh?=
 =?utf-8?B?eG03RExSL1FJY3FyM2dIeHZrYzYvaXoxK3pRMThIWkpCdkRyVzlsb0JicHBm?=
 =?utf-8?B?QmdIWnJvQTBVcE1hQXlXQXYrajBKVDJENnFVbFJQNU5MN1JxeE9JZlBTNHVZ?=
 =?utf-8?B?ZzMreldqVEJWQ1RTTXYzZWxPTm9Vbk5DZmxqYW9PZ3pHT2RnZ21lVWd4WU1H?=
 =?utf-8?B?NVMvM1c3UENMaUhuYVM1RWNrdDNwYk8yaUJRV0JTUDJ3K0syQ0NYNXJhT3Nt?=
 =?utf-8?B?NWtOZUNsT3NNQ1JrdnVXQWNpTFRlU1N1N0VKbDVFTVo0eW5qa09iMTFpY25n?=
 =?utf-8?B?RTFndkFCZm5CKzlJdytqelM1ZTc4Yjd0OS9jRmFaQzZVdGd0NmtqQWcrdHJ2?=
 =?utf-8?B?eENGL1lQbkhCY0FWUCtpVkhiRDU5UEFrWXhETHpvSU1OOThETnZUUGdzVDZx?=
 =?utf-8?B?R3A3cXRqcWlzNmtESUJaY1ltMW1OVHc1S3c5OEhDRis0OGp3NGRGZFFqZUJI?=
 =?utf-8?B?ajdyQ3B2WEs4dXpkZFF2d0tUS3hKb2lTWjJlYUF6bXdqWjhOWG1kNm1Hcnd4?=
 =?utf-8?B?ZEZLN05BRnVReTNOd1lRVTdOa3JIUlpKblI1TVg1WU1vZTA3ZHFianovVVdp?=
 =?utf-8?B?TlBpallaTUhNR2JLZ2lWMGhab0ZjdEg4a3BjLzNHeGRQeWpJSFo2cm5CUnd1?=
 =?utf-8?B?Y3l4UDZCOENVMzFRTHBpSGpKY3FQaTdhdW55NzNhOHZaVndPVWpzRnY3OG1E?=
 =?utf-8?B?NXdWaWg0dWNvRzRsS2YxTXQ0NXFLUXFpcW5hbHhTRVY3TGttNVhIcDNld1Rn?=
 =?utf-8?B?aG1acDREb0c4cnZyei8yc0xjZko0RndoYlMxSzFlWHR5ZExpaWFmZzFnZFRO?=
 =?utf-8?B?ZlpmME9xU1huL2NJRnpTRlNKcm1XT2JxeStNMnZXNnhxN1AxUzlmY1c2ektX?=
 =?utf-8?B?cmEraFlJelVJdnVaU3ptanEwMlFTK2lreFQ1a3k4QUFHV3NGRk1IL01uM3VD?=
 =?utf-8?B?NzZYS05WaExtWEdURUxEYURoajl6bUgraHFvZ0J0T2hsdVlFSTRiZXV3TFZR?=
 =?utf-8?B?ei9uYkl0S0p2RUtxQUZ0d1A4WVJENmxmREpMRWdQbTc4dFRzR1RlU3VVM2Iw?=
 =?utf-8?Q?wJ/Hwj3N0DU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXZBMHhZa0hEdkxiSGovOXJKNXh0Ykk0UkdJYW14bExRbGxXSi9UQnNnMDNN?=
 =?utf-8?B?R3IxSU92WGJlak4vaGg2SGlnV3UzZ28zd3Z1c215bjMxWVlHaXFmNkFWZ0Vo?=
 =?utf-8?B?TXpVcWt4anJMQkpOYUpQVWJwTTFPQ1hCWmV4SUN6bWdsTFkzc01ScUc1K0p0?=
 =?utf-8?B?MDg0V01DbElGUXF1MnpsK3dLUUdONnBOdnJyRVpaek1yN0pYZGZFdU96Mk50?=
 =?utf-8?B?b1JHb2QyZmF6OCtYTllTUzhGWGZrVFNBNDVYYkZTNmlsM3pYSUZQeGxnZXY0?=
 =?utf-8?B?cTJqRzBFMnFwUW9XTFlRSUdGcW45L3doQW9jV2dva2grbDl6THRweUlPaFVQ?=
 =?utf-8?B?NGtTdUN6aTU4Z0ZCWjRwL3U1OXhoWERlL2Q4S0JHMTk4cFF1a1A5Q3dEZnZK?=
 =?utf-8?B?Vk5aTXZTSmlNSjFFMVZzNlFtUk5uaVRDZFlKK2Jsdm9nYnZtY3B0MkMrSUw4?=
 =?utf-8?B?dExRRFVSbkVrTDRiek5ES29xSFpDeVY3c0d2Tnl6dFRudnc3aUYvRW5ZZmVm?=
 =?utf-8?B?VUxNWVpkV2Rpbmt1SXZYN3RjYVVBTVJtWXV3bU5EOExmM2ttR2VXUFQ4Y3Ri?=
 =?utf-8?B?Z3lOVis2SWlwMm5GSVNtN0ErcG1zUWV0Z2kyTEdWK1ErUitjUU9FL240T3lP?=
 =?utf-8?B?WHBDVVFMR3Nla0JISFBlVnZzcEtHblJZQzhmb2Z3SURsQ0M3WWlqdnprWmRC?=
 =?utf-8?B?SXdDZkI5a0JiZ2ZNc05PK25ncXZGeW9mT3pGNjlMN21mWG9xT0VLVS9XMmda?=
 =?utf-8?B?VW5oR0pJbVd0U3pWRVkvYmFRSzVuQTN0TUJyRGNDYzFtZVJCSDJ2UWp1Mm9Z?=
 =?utf-8?B?TWRMd0F2NndiQjhqS3FndFoyRnNabnZhMmVZQ21uNzBMMHFBZDdWN2oyV3pq?=
 =?utf-8?B?aUFGaWRkVkNBaitnMkZSbFIzZ1psZi9WZmxWTHRSMXY1VUpjUURiUHV5KzFT?=
 =?utf-8?B?cXphbFVsZWoxRldNKzMzZ2hXU3R0UkpRUjBtWGRwRFBnWU54SmxITFppempk?=
 =?utf-8?B?WkhDdnppdCtYL2pXUjRpR2M5dWJjTGtBMElSNk9zNzlNck5yeE1FeWJPWTZD?=
 =?utf-8?B?RlU4ZDVyU09OUkJqNmsyK3BFQnZ3RE1QNEk0bUFsRjlRVEY4eDlpWDBpYm5s?=
 =?utf-8?B?T0VpS3dLdzYzZmxTQTFNTEt4Z2E2aHV0N05NcVQvMHd3WUJpK0M5YzAxR0pv?=
 =?utf-8?B?aTlzd1kwOEZKOHJSRUhGSDFYRk1tTGZQYTJ0cWtVMmdONXZSZldTajFqQTR3?=
 =?utf-8?B?RDNDdGVWNzc4TWFlZUsxbityWnJDV1FWTjMwc1JtZkxEMEptUnFnNXU2Y0Rs?=
 =?utf-8?B?ejU4clBOcDMvWm16TnJ6VThENW81MWlWdGcxTWhaanppcUR5NHpVbkZWblRi?=
 =?utf-8?B?Umw1S3FkSjFUQm5xclM2NThsbWZHTGhDRCtyM0hMbFlxb0IxaGpDdHV2ckEv?=
 =?utf-8?B?WjQ4bkc4ZEFOOVQzNVZkWlIvR2RIQlI0b2g2NkFaRWtyVGFXS0U0UTJDVFdS?=
 =?utf-8?B?WnkxU2F5MW9ZUE1BYkUwQUcyVXpadDFqMUxmLzd2K1YrR1BCQ09IQW9paFNh?=
 =?utf-8?B?eVhjeTJTNGkwOVdtOEw2K3ZyYkkvVldzOHp6Y2FoeWdRemFhWGNmSEEva2VP?=
 =?utf-8?B?ZVFGZmxFS3BzeWp6VkJPK1pPODFxRFBQSGtmMjBEMldWOUZ3R0VTdE0wTUhQ?=
 =?utf-8?B?Mkd3VkE3VWMxSW9zdTBFaVE0RlJVbUlYMXRwSlplT3ArbE5FeFpVWlY3Vm9N?=
 =?utf-8?B?V1Nyb1JxTVFVZkdaMDYwL2FITjltV3lBVjU0T0RlMEs4dzMzU3IwUDFQMzVy?=
 =?utf-8?B?MUVMbHpKNDFHaHFEWnQ5aWRGRDhNbVhRdE1DUHo2Y3R0K0tqbXAySVJyZU9W?=
 =?utf-8?B?SXZVeHM5T2F4L2Q5Q2hGWitreE5vNHN4MTNKaGM2SWFXMjFUOFdrc2gxTXVN?=
 =?utf-8?B?K0J0VzVMSzNYWHB4T2ViTWJ1bjQ1ajgwNW5tUnV1b2tOUmM4WnZndW1Sd3N2?=
 =?utf-8?B?Rk1CNmdNeURTb1ovK1c0V2xGN25OSktQOHBmUnJOcFk1amhieHlOejRkZWU3?=
 =?utf-8?B?M3N2YlBTaU1McFJ5UW1FTy8zYlhQUkp4RUhnVnorNURMeUJuZ3FubDhHWjZE?=
 =?utf-8?B?UWRkUC9FMXRFYk8wN3NHNGI4ME9Zc093YXJKNS9TWDNjbHVFOTQvcm1DRjhP?=
 =?utf-8?B?Q3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8043a4ab-2bc6-43f3-dd3b-08dda3f6819e
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 06:02:09.2361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 637IptrLQSMPCPyf1ohQQNpahM7ywRuqcAkejYjkJX0xAHVLlaStgOyqAfuvfvd0GYhFECtevFUK3ZujD19slg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6674
X-OriginatorOrg: intel.com



On 6/4/2025 7:04 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 30/5/25 18:32, Chenyi Qiang wrote:
>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
>> discard") highlighted that subsystems like VFIO may disable RAM block
>> discard. However, guest_memfd relies on discard operations for page
>> conversion between private and shared memory, potentially leading to
>> the stale IOMMU mapping issue when assigning hardware devices to
>> confidential VMs via shared memory. To address this and allow shared
>> device assignement, it is crucial to ensure the VFIO system refreshes
>> its IOMMU mappings.
>>
>> RamDiscardManager is an existing interface (used by virtio-mem) to
>> adjust VFIO mappings in relation to VM page assignment. Effectively page
>> conversion is similar to hot-removing a page in one mode and adding it
>> back in the other. Therefore, similar actions are required for page
>> conversion events. Introduce the RamDiscardManager to guest_memfd to
>> facilitate this process.
>>
>> Since guest_memfd is not an object, it cannot directly implement the
>> RamDiscardManager interface. Implementing it in HostMemoryBackend is
>> not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
>> have a memory backend while others do not. Notably, virtual BIOS
>> RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
>> backend.
>>
>> To manage RAMBlocks with guest_memfd, define a new object named
>> RamBlockAttributes to implement the RamDiscardManager interface. This
>> object can store the guest_memfd information such as bitmap for shared
>> memory and the registered listeners for event notification. In the
>> context of RamDiscardManager, shared state is analogous to populated, and
>> private state is signified as discarded. To notify the conversion events,
>> a new state_change() helper is exported for the users to notify the
>> listeners like VFIO, so that VFIO can dynamically DMA map/unmap the
>> shared mapping.
>>
>> Note that the memory state is tracked at the host page size granularity,
>> as the minimum conversion size can be one page per request and VFIO
>> expects the DMA mapping for a specific iova to be mapped and unmapped
>> with the same granularity. Confidential VMs may perform partial
>> conversions, such as conversions on small regions within larger ones.
>> To prevent such invalid cases and until DMA mapping cut operation
>> support is available, all operations are performed with 4K granularity.
>>
>> In addition, memory conversion failures cause QEMU to quit instead of
>> resuming the guest or retrying the operation at present. It would be
>> future work to add more error handling or rollback mechanisms once
>> conversion failures are allowed. For example, in-place conversion of
>> guest_memfd could retry the unmap operation during the conversion from
>> shared to private. For now, keep the complex error handling out of the
>> picture as it is not required.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>

[...]

>> +
>> +int ram_block_attributes_state_change(RamBlockAttributes *attr,
>> +                                      uint64_t offset, uint64_t size,
>> +                                      bool to_discard)
>> +{
>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>> +    const unsigned long first_bit = offset / block_size;
>> +    const unsigned long nbits = size / block_size;
>> +    bool is_range_discarded, is_range_populated;
> 
> Can be reduced to "discarded" and "populated".

[...]

> 
>> +    const uint64_t end = offset + size;
>> +    unsigned long bit;
>> +    uint64_t cur;
>> +    int ret = 0;
>> +
>> +    if (!ram_block_attributes_is_valid_range(attr, offset, size)) {
>> +        error_report("%s, invalid range: offset 0x%lx, size 0x%lx",
>> +                     __func__, offset, size);
>> +        return -EINVAL;
>> +    }
>> +
>> +    is_range_discarded =
>> ram_block_attributes_is_range_discarded(attr, offset,
>> +                                                                 size);
> 
> See - needlessly long line.

Yes, doing the rename can avoid long line.

> 
>> +    is_range_populated =
>> ram_block_attributes_is_range_populated(attr, offset,
>> +                                                                 size);
> 
> If ram_block_attributes_is_range_populated() returned
> (found_bit*block_size), you could tell from a single call if it is
> populated (found_bit == size) or discarded (found_bit == 0), otherwise
> it is a mix (and dump just this number in the tracepoint below).
> 
> And then ditch ram_block_attributes_is_range_discarded() which is
> practically cut-n-paste. And then open code
> ram_block_attributes_is_range_populated().
> 
> These two are not used elsewhere anyway.
> 
>> +
>> +    trace_ram_block_attributes_state_change(offset, size,
>> +                                            is_range_discarded ?
>> "discarded" :
>> +                                            is_range_populated ?
>> "populated" :
>> +                                            "mixture",
>> +                                            to_discard ? "discarded" :
>> +                                            "populated");
> 
> 
> I'd just dump 3 numbers (is_range_discarded, is_range_populated,
> to_discard) in the tracepoint as:
> 
> ram_block_attributes_state_change(uint64_t offset, uint64_t size, int
> discarded, int populated, int to_discard) "offset 0x%"PRIx64" size
> 0x%"PRIx64" discarded=%d populated=%d to_discard=%d"

Maybe a string of "from xxx to xxx" is more straightforward and it can
also cover your information. Anyway I don't think they have much difference.

> 
> 
> 
>> +    if (to_discard) {
>> +        if (is_range_discarded) {
>> +            /* Already private */
>> +        } else if (is_range_populated) {
>> +            /* Completely shared */
>> +            bitmap_clear(attr->bitmap, first_bit, nbits);
>> +            ram_block_attributes_notify_discard(attr, offset, size);
>> +        } else {
>> +            /* Unexpected mixture: process individual blocks */
>> +            for (cur = offset; cur < end; cur += block_size) {
> 
> imho a little bit more accurate to:
> 
> for (bit = first_bit; bit < first_bit + nbits; ++bit) {
> 
> as you already have calculated first_bit, nbits...
> 
>> +                bit = cur / block_size;
> 
> ... and drop this ...
> 
>> +                if (!test_bit(bit, attr->bitmap)) {
>> +                    continue;
>> +                }
>> +                clear_bit(bit, attr->bitmap);
>> +                ram_block_attributes_notify_discard(attr, cur,
>> block_size);
> 
> .. and do: ram_block_attributes_notify_discard(attr, bit * block_size,
> block_size);
> 
> Then you can drop @cur which is used in one place inside the loop.

Yes, looks it can reduce some lines.

> 
> 
>> +            }
>> +        }
>> +    } else {
>> +        if (is_range_populated) {
>> +            /* Already shared */
>> +        } else if (is_range_discarded) {
>> +            /* Complete private */
> 
> s/Complete/Completely/
> 
>> +            bitmap_set(attr->bitmap, first_bit, nbits);
>> +            ret = ram_block_attributes_notify_populate(attr, offset,
>> size);
>> +        } else {
>> +            /* Unexpected mixture: process individual blocks */
>> +            for (cur = offset; cur < end; cur += block_size) {
>> +                bit = cur / block_size;
>> +                if (test_bit(bit, attr->bitmap)) {
>> +                    continue;
>> +                }
>> +                set_bit(bit, attr->bitmap);
>> +                ret = ram_block_attributes_notify_populate(attr, cur,
>> +                                                           block_size);
>> +                if (ret) {
>> +                    break;
>> +                }
>> +            }
>> +        }
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block)
>> +{
>> +    uint64_t bitmap_size;
> 
> Not really needed.
> 
>> +    const int block_size  = qemu_real_host_page_size();
>> +    RamBlockAttributes *attr;
>> +    int ret;
>> +    MemoryRegion *mr = ram_block->mr;
>> +
>> +    attr = RAM_BLOCK_ATTRIBUTES(object_new(TYPE_RAM_BLOCK_ATTRIBUTES));
>> +
>> +    attr->ram_block = ram_block;
>> +    ret = memory_region_set_ram_discard_manager(mr,
>> RAM_DISCARD_MANAGER(attr));
>> +    if (ret) {
> 
> Could just "if (memory_region_set_ram_discard_manager(...))".
> 
>> +        object_unref(OBJECT(attr));
>> +        return NULL;
>> +    }
>> +    bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
>> +    attr->bitmap_size = bitmap_size;
>> +    attr->bitmap = bitmap_new(bitmap_size);
>> +
>> +    return attr;
>> +}
>> +
>> +void ram_block_attributes_destroy(RamBlockAttributes *attr)
>> +{
>> +    if (!attr) {
> 
> 
> Rather g_assert().
> 
> 
>> +        return;
>> +    }
>> +
>> +    g_free(attr->bitmap);
>> +    memory_region_set_ram_discard_manager(attr->ram_block->mr, NULL);
>> +    object_unref(OBJECT(attr));
>> +}
>> +
>> +static void ram_block_attributes_init(Object *obj)
>> +{
>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(obj);
>> +
>> +    QLIST_INIT(&attr->rdl_list);
>> +}
> 
> Not used.
> 
>> +
>> +static void ram_block_attributes_finalize(Object *obj)
> 
> Not used.
> 
> Besides these two, feel free to ignore other comments :)

The init() and finalize() calls are used in the
OBJECT_DEFINE_SIMPLE_TYPE_WITH_INTERFACES() macro. It is a common
template. I guess you forgot this again[1] :)

Other comments look good to me. But I think they are some minor changes.
I'll see if need a new version to carry these changes.


[1]
https://lore.kernel.org/qemu-devel/89e791a5-b71b-4b9d-a8b4-e225bfbd1bc2@amd.com/

> 
> Otherwise,
> 
> Tested-by: Alexey Kardashevskiy <aik@amd.com>
> Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
> 
> 
>> +{
>> +}
>> +
>> +static void ram_block_attributes_class_init(ObjectClass *klass,
>> +                                            const void *data)
>> +{
>> +    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(klass);
>> +
>> +    rdmc->get_min_granularity =
>> ram_block_attributes_rdm_get_min_granularity;
>> +    rdmc->register_listener =
>> ram_block_attributes_rdm_register_listener;
>> +    rdmc->unregister_listener =
>> ram_block_attributes_rdm_unregister_listener;
>> +    rdmc->is_populated = ram_block_attributes_rdm_is_populated;
>> +    rdmc->replay_populated = ram_block_attributes_rdm_replay_populated;
>> +    rdmc->replay_discarded = ram_block_attributes_rdm_replay_discarded;
>> +}
>> diff --git a/system/trace-events b/system/trace-events
>> index be12ebfb41..82856e44f2 100644
>> --- a/system/trace-events
>> +++ b/system/trace-events
>> @@ -52,3 +52,6 @@ dirtylimit_state_finalize(void)
>>   dirtylimit_throttle_pct(int cpu_index, uint64_t pct, int64_t
>> time_us) "CPU[%d] throttle percent: %" PRIu64 ", throttle adjust time
>> %"PRIi64 " us"
>>   dirtylimit_set_vcpu(int cpu_index, uint64_t quota) "CPU[%d] set
>> dirty page rate limit %"PRIu64
>>   dirtylimit_vcpu_execute(int cpu_index, int64_t sleep_time_us)
>> "CPU[%d] sleep %"PRIi64 " us"
>> +
>> +# ram-block-attributes.c
>> +ram_block_attributes_state_change(uint64_t offset, uint64_t size,
>> const char *from, const char *to) "offset 0x%"PRIx64" size 0x%"PRIx64"
>> from '%s' to '%s'"
> 
> 
> 


