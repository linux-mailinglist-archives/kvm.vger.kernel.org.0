Return-Path: <kvm+bounces-40807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 488A7A5D3CE
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 02:04:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF1A73AB60B
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 01:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62B948635B;
	Wed, 12 Mar 2025 01:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O42UeOyb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967082F24;
	Wed, 12 Mar 2025 01:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741741433; cv=fail; b=ESkZ8SYyTrST3i6SjDAMRgZGWGVkjYuT8yY1QlNaW9eHvY1pxj0pM2YH6CzdBaWUuPmjCR+IZoD6vU+YMfFVK9sZINg9CNBp7e2wY9AHvoP8BrU5SbDXqEnyNelBATQLJNodCZznZrwv5Y7G/Cy9juy9b6aeKhj7PbS8i7SI3fU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741741433; c=relaxed/simple;
	bh=nuVI8kHYIo1PxSy9o8yIqnr1rN3cYw210PKJcgj3O0A=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PnWuI6kzG0eHgQlatWgxi9wEsM11ZousLbrFeL2i/HL1mSNFRUd2wEyg6VroCJxkiV5g8/Oezk/wTIQAZWyYno93x21fhW4bmJU3HGUOmXfOOrID9CktSZjeOiFuHKHjvjSSL6KOP3bjuhbSAruh0uv4dhSvA6a+6T3Nxkep8Yk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O42UeOyb; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741741432; x=1773277432;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nuVI8kHYIo1PxSy9o8yIqnr1rN3cYw210PKJcgj3O0A=;
  b=O42UeOybdcKxBnBa4BJXFyNg+9ENwYAuTplu75wQFX5q6v9hBbh7MFmF
   EYUkPKSoQm+5hfMtFiHAwQUAIvnexrI+b8kRB8b8qJwphYmga3oGnKlzv
   UNVfgCh75Da2A7hlv/VXiLqcCl+y9YOioUqAAb85kQjiIFcKokY9t4I2/
   hcs9QN8Q3VPgYziSCCExDnazlj7lVARfPZjxiAzyXlnwbuhRL8/Wx+ZS+
   oLAD06cMvYOcjm321Qi6lYyKCNyjHVUD9dpDOWSD1PR0M09Utd0XnuyvS
   iAHhyO2zuEenSmlNh6l2TSS67aHx3A01oxPS234cmvdtaRti3KQz8AOOf
   g==;
X-CSE-ConnectionGUID: 0Cyukw1rS4ycRzoYyr+hiw==
X-CSE-MsgGUID: lKuOon5EQLiPifa36Xc7BQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11370"; a="60350868"
X-IronPort-AV: E=Sophos;i="6.14,240,1736841600"; 
   d="scan'208";a="60350868"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2025 18:03:51 -0700
X-CSE-ConnectionGUID: AHXQTeHhQPumIILycMVjnQ==
X-CSE-MsgGUID: txLrvxZJQ9219HolA0UaBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,240,1736841600"; 
   d="scan'208";a="120187552"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Mar 2025 18:03:51 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 11 Mar 2025 18:03:50 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 11 Mar 2025 18:03:50 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 11 Mar 2025 18:03:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CFK5uZuWTT8bg+qtN73ApJzOK3sXAfAs//x2MrZR2d8pZJjEizgSR6ewzcBwVo0LuKjAakLtTuCydYzlogLk5Bi6FL6Z0ai2r+zouX5vuWdlsLt4sBkWyKEZNJ7vDi1dmoMXdBOypLamoTR+emYYtBzC6TuKtK6Whi7f9RrKN8ODrZc3HK0OsOLCvQ++Lzem6nbmGqbUDheRXU7R12gbUda1lq/PD5xSxzNxQAMhlDrJyP8/2Hr09FCpOX4GoH+9wD22qE7cIG7XKyQKWQAbYyClmKXTYvbY9BIdlc2wsWq8193RlAVwT9fE0AhrF73FGkCn+v2dQW9cySB3Njj6YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ApVLwUUIUzh1Y3NZzg7zsBpPbZLNiwbSaocXs3L7cIY=;
 b=da9tFwURzKMwvATcvum+dYTkX9oGCQI+sxWYDs+ZlCOFrauy3yI72gNpLWQ7mqIQem5m6vFgtcy28X/4qezFXzKBpk35IlDEvFU0PEFSqt4iBO4ecJme8ZlEAi/UIE53SG2oEFaZZJKJNfBjnN0SJZZMP9ZJ/8nkZHV6RS6ek1nq9qtE3jjBN3JowCdLZp7ZCnYPmcHhPJ4lbE1zXWVEL0xi33wzu2xRJ7sdvMqyY19XuajwIyaxpx9v0omrsAHWQ2BtDok+5lPwTP12oJ1tg5kHXwHuLZzkCWoKOLws0WobINY5l72XCIFpokiO4VYC89EL1BgLZHg3RHd/Z7kn4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 DS0PR11MB8206.namprd11.prod.outlook.com (2603:10b6:8:166::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.27; Wed, 12 Mar 2025 01:03:48 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.8511.026; Wed, 12 Mar 2025
 01:03:48 +0000
Message-ID: <3d70c9f3-bab4-47fc-aaf9-428c7d14b644@intel.com>
Date: Tue, 11 Mar 2025 18:03:46 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/10] x86/fpu/xstate: Correct guest fpstate size
 calculation
To: Chao Gao <chao.gao@intel.com>
CC: <tglx@linutronix.de>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-5-chao.gao@intel.com>
 <b34c842a-142f-4ef7-97d4-2144f50f74cf@intel.com> <Z8uwIVACkXBlMWPt@intel.com>
 <481b6a20-2ccb-4eae-801b-ff95c7ccd09c@intel.com> <Z85BdZC/tlMRxhwr@intel.com>
 <24b5d917-9dd0-4d5b-bca8-d9683756baff@intel.com> <Z86PgkOXRfNFkoBX@intel.com>
 <b624a831-0c91-4e89-8183-a9a1ea569e6c@intel.com> <Z9An8TJ37Ok8BRNQ@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <Z9An8TJ37Ok8BRNQ@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0025.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::38) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|DS0PR11MB8206:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a7dc8be-e8ef-40ef-f49c-08dd6101be99
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZCtpVFJTN0JQc2FWYktKWjBOdFVNaE0xZ1hyV1JEc2xRYytKV2tBZ3pITFNx?=
 =?utf-8?B?aldQdXJqNHJVR0Q3aUxzMjJvbmdFN2hVdVBKeFgxQ2xMOG9laUNnNHgvTzRY?=
 =?utf-8?B?dHQ0OHlialRWWkg3TFIvWUFWZDVYNXZVWEk1YWhMY0w4M050SXorWFdIUnUz?=
 =?utf-8?B?ZjE0My9vNlhLRGZIM1NUVnFLMllVNjNsN3Bwdmd6clAwQUxVTG5mTjM3QXBh?=
 =?utf-8?B?VVFqQTR6VUhzZVJRNzJ2VWxIdWpFWkhjd1lQTTlkTjFtaTJGVEFOMXY5dzdk?=
 =?utf-8?B?QzNETHAyYUVpUVRGY3hFMHMrUWpBRWhDajdSN2w3VXJRU0NTOVA0UmhFVGx1?=
 =?utf-8?B?cHFVRXB1TjJCMFd4RDhvd2Z1L1ZibjJTRXBvMldyb2FLSW1ZWE5BNHp1cjBk?=
 =?utf-8?B?TGJFbkFhNFIybUl0VEpKOGdRWElLanFhS1N4bDB3WTJXSEVrZ1hkUFFhQzZU?=
 =?utf-8?B?NmRFalhhYmJsdXhpOGxrdzY2RlJBNXJLVHR0d3lXM2JsQ0pLOGdtN0M1eWJl?=
 =?utf-8?B?WXlCRHZFbjR6MWtjNGpkbXFzcHJORCtxZ2ppaTdMQ2o2amZHQWVKc01LWUoy?=
 =?utf-8?B?TXZtY0MyckNoTE9hUVVMdUhLK1J4M2xhYU9xN1F0U0NJa2FuREZmMkRSTitn?=
 =?utf-8?B?NDgxRXlOSFUyZk9HRUdCWGxKSitoM0dMVE5rbDNFSzM3bzRTT29mUlVZREN3?=
 =?utf-8?B?KzVZeFQ2bTBNeWVLaEoybjdibk81VkxUemdNd3RoRmI1NkN0OFNBYzJwOUM4?=
 =?utf-8?B?QVFPM2hOSWdmaXFqU3B0Z0tJdEt4QTFZSlBQZ2FNMzNYSFFza3plY2pUMUEw?=
 =?utf-8?B?cytHWDNuK2ltZE9PZi9LUitZMldORW5BZTlRMW9kUnZDRHphVml5MEVZMCs4?=
 =?utf-8?B?dlZGQjJyb3IzYnhuVFY4dXRvbHVHaDBkTDg3akFKRE43ZU5qbzFpMU9RRFFj?=
 =?utf-8?B?NytRZGhOd1I0aWNqNW9ETW1HbGVVMHpUTzRnY1JHZDNHcjBLYUxJWUo5eXBi?=
 =?utf-8?B?Z3BHSzVrRjBxdCtSN2pEbnpLcDNQMjBFdzVaY2FFR3hmSXo5d3VoK3pJMjhk?=
 =?utf-8?B?SE5jaHdudlZTTXgrQWcwVnF2blB6Nk9Ec0htenRESjR2bCtsWHoveGZIaXAw?=
 =?utf-8?B?ZitrdzlwQlVob3lyNXIzaHljMkQ4TDlCOUJyYlphUFZLOHhDaFl5bFdVbXhJ?=
 =?utf-8?B?V2lURGRtZVRoRW9UbTVKc1E5OVZXNTBaR0l5N3pXemlWNnlzQ0I0UTlPWkdv?=
 =?utf-8?B?U3FndWlKV0F5UWNrN1QzWFAybzlCUXYzYkQvVzFFR3RFUXpQYm4wTWRUVUhK?=
 =?utf-8?B?dEJmSUtaaHMxRkNLaEpWRlhLSjR1ekRhOU1XM0JjbzV5ZFpoVDdkQ3NDUjlK?=
 =?utf-8?B?bi85WHVOQll3UEozWGdlK2hsdE56cFZMaG8vQmZKSEl5M0FKMml2WDVMQ0x1?=
 =?utf-8?B?ait3STVGSGp4cjJWdTJ1RFByVjNpUTdtTkRVaDBEd2FwUUJzNnVudFVOb1B4?=
 =?utf-8?B?NDkyYkJaaWVITS9PaDdUVVNjdG5ESFVSTlNaVmFISVVUOStlWVQwZE5jQmI5?=
 =?utf-8?B?a095VFhlSHBOVmZIaWxZSk9LQ3FCVVZ4UjVzU2pEYjNNTzJZeVNIc0ZMbXI1?=
 =?utf-8?B?L3c2MnpxV2pxRWN3UGEvOW53OUk0VVZqSWlKU2pIaTRRMEhQVEhtYXU3SWZt?=
 =?utf-8?B?blhxVUpLVExrYmcwTzFMcTFUblIxU1gvUG9YU3gxaUhMdncrTUhMQ0NPdGZD?=
 =?utf-8?B?ZU82ZXYxRFNWRlhOSGdzSkdpK3I1SjNDbXFYNFErRDZzeUtxSGI2T2tPaCtE?=
 =?utf-8?B?cWtMbXlGcmNOVWdpano3U05ZN2xyWGhrK1RFQVZGakQ4ZEk3dVJ5blhIcEdr?=
 =?utf-8?Q?CpWS7JzMRbcN2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFVoeTRIb1hGb3BMbUR0QnFmZUlETjdreWw5WGFzdml6WC9nb3d2alBEK3F2?=
 =?utf-8?B?OUZRMXJabEszdXlrOWY5SnRjZ0E0SW1xWW9yRklOaXB6QjQ3VDRLS1lhL2Z4?=
 =?utf-8?B?YXFsR0tmVjdOdUR6WlpDNDFUZVZDUHduM1piMHVqald0SktkVlF6K2hiNEx4?=
 =?utf-8?B?OXRua2hEbU5VK09saTN1bjBKNGd0M2NqSHR0YlFlcEZzWnNyU2liOWFLV0dI?=
 =?utf-8?B?azZ6ellqWXBsQVY1d0VwWjdDcUtJbzNsOHpyZ2s4NUdVZGxqbUN5V1l1THpQ?=
 =?utf-8?B?QTgxc29aRHBjTVp2SEplek0wYmhaSGNFb2tsYVZ6dFBqaXdvL0hVTTRxcXQy?=
 =?utf-8?B?QjRkcXo5NFFXQ0lXRUIxUUY2emsrZjlRd3dSR2sxZ0xiMlFOL2NNcGZZVmNN?=
 =?utf-8?B?bUduazljUjF2QXNEeWdQYlB2eG5mcmJVSk55Y0ZMWDJCNU5YT2VsdDM5OEpl?=
 =?utf-8?B?K1lhQml2UzloaHlkZVVDSUdNU3BBL3AvbzZDUDRIQU1CbGRyUC9qem9Xa04x?=
 =?utf-8?B?UGFvUFpLYlR5SmpuSnJERmN5RzJ1UjVJR0JjMlB2UmRrczU4WUtXdm02Z0to?=
 =?utf-8?B?Z2N1a1dsV1lOdDBwOHJLamUyNVRQY3EwREdzQVlWZW5IV3dOcXJpMVBOWi9B?=
 =?utf-8?B?bUljbHg0OHQ4Yit3WHNDcFZmSHYwcmZLTlRGV3JOV2d6bTBrS2lnVDAxYndM?=
 =?utf-8?B?TXc3ZFpkd0N0ZWFtMDE5MjIvRkxmdUdyRUgzdXNaOGVzTS9nVmFQN25BekY5?=
 =?utf-8?B?T3NYRnYvNHJUU2xWM2NMQ0x1SWhNdDhVYXR3SUZLajRVYXd4QXM4UjN4TENJ?=
 =?utf-8?B?RmtVQlgrNGJrTE05cEZWUGZHU0xFUlZReVJJbjRMZlFSTXB6ZzBtd2RBZHlq?=
 =?utf-8?B?ZDd4Mnp0cFUxV3ZwUllhMVB3eEt6SGZoODhKQ25hS0VaZEp1UWJic0dtL2xC?=
 =?utf-8?B?L24rRXZ6ME55Rm1DTHVmQVJjKzRHU3VxdjZoU2JlNzlTRlhrT1YvdGtwRnFG?=
 =?utf-8?B?S1JEMnV2NWZKOVBnZnBCWEYxUXpXSVNDYmlmbG1oaHczUjVFMG1MV1VSK0ln?=
 =?utf-8?B?MzNsNGwvRktIbWVQczAzUVJkUTgxS2gwYXE5ZTBRK2o0SzY2bTVnZmNQNks1?=
 =?utf-8?B?bDA3RXhOWWFZMVk3MWJGL2JtVmRzR1IyWUtDNmJId1o3UFdDVGJQbzVjYzk5?=
 =?utf-8?B?c2cvSTY0VWtwb3Z5aGxWaU9XeUxCYXBUc0dFTjkycU5wdWFkUGZUU3ZrUXNp?=
 =?utf-8?B?VTkvYmwzeVpEdittUUYyeDhTazhmUlJScGlaYW04VzFMaVF4cFhyZFA0UnBK?=
 =?utf-8?B?Q3h1bVFQenl2QXBSQk50R1JsWjNDRS90N290T3VMN3lxb0tCSEU3a1FocVFo?=
 =?utf-8?B?c3E2ZjdGSDRJekRSejFUZkR6cnhiMSsyM2dIZGlrT2FQSVhLUFpIUmo1ekdv?=
 =?utf-8?B?UXBTYkxmZ1Jxc2FvdDg5NGdUaFA2M1J3WnlPNTlYOGw2dmUxWnEvSE02Zmt2?=
 =?utf-8?B?Q3BENFptcW1qeGJPNzQ4RHd3SlBxdVFMZnh3VEtNQUpiOVd0WkpaemJ2TEJz?=
 =?utf-8?B?M0lnK0hZMnpQeUQyemZPaG5VcEwvY2Q1Mm1DaExST2RtUGZaWk10ZFZTRHUw?=
 =?utf-8?B?QW9NemRDTWRHWkM3OFZZWmNqdzQydUZEaU10a0dMSnBRRVFZcnpoMVVmTlFy?=
 =?utf-8?B?T3phcGkwZGlWQ21iUnVkVEJKek5vR3FuRk1MRlBmaHFrWjJRM3QwaTNadjZW?=
 =?utf-8?B?YmRVV0pJL0dZY1NoUTJuNGhhVFB6VFJqckROWStBMDZPWjk2QTUwL0Zick1R?=
 =?utf-8?B?dDIvOWtHMHJoWUpYd0wrcVdwZnNjVVo0bHZmRmFPQzdOek1pdHlJYzdvZ2or?=
 =?utf-8?B?VWhWMkFHR2V4ajhva1pLcHdGclppVjM2U0xaeHpPaFpMWGVjbVlOSDY1Rytn?=
 =?utf-8?B?MXN0OXVpUTBucGRybFhGaytOc2NBVjZmVDFlUkNMTGtaeUowT0Z5WmRaVlFQ?=
 =?utf-8?B?WkhCN0pSbHpUMU50T2lhVURlZW5HVWVtNUtEU3ovZUxueTN2eWRBSzdKK0dZ?=
 =?utf-8?B?U1FsUmVDd1MzUlJ4ckVpbjE2OTh4VHlsRXVPcjkrUlJpdUhTczNVUldxcDY3?=
 =?utf-8?B?eEYrR0JoWUlGVGd1eXhBTlZRQlBnYzFZV3lBbXdPdDRHM3JwMmhzZnlVbG9k?=
 =?utf-8?B?Y3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a7dc8be-e8ef-40ef-f49c-08dd6101be99
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2025 01:03:48.0314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NueigdsoWFfMT6RW3YWYNf7iCGKXBlYnu8TJjtxs4Lypg1rW60JKUehgdVd4++t1BI/M5PSzSeiK0Bszk+nMcyAAltAEEhf5/AJ1WPn/Z0o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8206
X-OriginatorOrg: intel.com

On 3/11/2025 5:09 AM, Chao Gao wrote:
> 
> One thing I'm not entirely clear on is "the fix is only partial". I assume I
> need to update gfpu->perm to reference fpu_kernel_cfg to complement the fix.
> Is that correct?

Yes, I think so.

Thanks,
Chang

