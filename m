Return-Path: <kvm+bounces-40539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 67196A58AE7
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 04:50:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C220D188C30D
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 03:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82EC11B6CE5;
	Mon, 10 Mar 2025 03:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cp/znHzB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59B228F5;
	Mon, 10 Mar 2025 03:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741578606; cv=fail; b=CaOy4N/hfakknmVDMRNicb3HdwIROpCABffechRQ1bZME1khquncw3Qr18WdCH8Ly5+BVsro21XO7w8766GtNHh7moH0cbt4EO8mmMwvWS6IUmm4xq2YG7/mAUoqu6e35kkgUV7Dy15C6z8ZqNxGLqJy4z0Pmg6p22asRjdrVLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741578606; c=relaxed/simple;
	bh=BtGAuhpBojkW476shtZyRUtjMpLJp4KZ5XKDXczICVg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jfyUzy6APo1ClwzFo0dlDN6A0xQ7KS1jWb7GCV7BD/LBZmjLVYQ8GIRhayP7dh/ffOU3/okNsTXukfhvwbLfROk3dP8KS3sgV4GkwU8s7rKvrkOgCdWdOa/V3iMRnosKpFvueOAUupeFysWSupo8TMF6EugLyfiWPmEi0Dt4CIg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cp/znHzB; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741578605; x=1773114605;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=BtGAuhpBojkW476shtZyRUtjMpLJp4KZ5XKDXczICVg=;
  b=Cp/znHzBuA7woU0YEHCydoqBck2wA5bX1GboqFrTXHv2RCHSO0gU48CF
   AreOSkYa1CGNHi/g1ufqlMUtmD/t0FVsKLdvaAx7PY2l8qN+5BhxYC5uk
   ja5bEUwvFWslPUVSoyOz+CCD+vZ3Uz3qphPZx1gPRa/RplZcV3CfsdEGU
   Q6XsliSysRyAOhzhIPFrpNUvRg97IRPF7260GcjAKuX9fNzath9bcB/9a
   w7U/nOqLESxKh7hiEatRGWNIVcL6kFpDtqmWX9ZTehOdiVNAyTiAnGrZQ
   Ir9St6jY6Udgtn2rlloYLSrspsE7NtLJ4l7s62VJL4eVE3AzcDj30xffH
   A==;
X-CSE-ConnectionGUID: G2FIgVumQVKJl+ck1BhbSA==
X-CSE-MsgGUID: IDn5XceaRpWDW9+2/B/OAA==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="46205688"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="46205688"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2025 20:50:04 -0700
X-CSE-ConnectionGUID: w40Tc434Tva1swPK3BcHJg==
X-CSE-MsgGUID: E+4Y2OUyRZS58/f+OBqX/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="120354857"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2025 20:50:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 9 Mar 2025 20:50:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 9 Mar 2025 20:50:03 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 9 Mar 2025 20:50:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oDmKVONzsnPDvxGHpKBBJ+AERmKKtnpIh6umreHqopspfh5Vt3nGoVf6lGJVltJ0vfKuXQFbUbLI4a/9M6qUDCufRG4iFdpK0oXvUyBGhhqJWcYVHMbRKkh/3zGGtlaulumlmXSzVDF91N4p3KbLFp7xTS+bGAiXfJ8Ew7NZ2Msz3Yuar0XR4JkhR0gffnk8r9oS/3yxdKIoN/zhQo91rMWhx7OVCnHHv2TfFrb1YO9CyY2as1q+X9dFZFuHHhdti73iUlRoxr3kQAdOqhWVNbPwfIA6aMnUzLXLZ+CyK8QiNTULCLrB2EKH+Ez+vJVyTGruO2o/gqZo+ioWNuWAJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/cmS+Pi5A9i8Hs6qCZyAko7oCkja6jdLyvhRYTRwzDs=;
 b=LQb//mrFOH2M9sX4abI6BUA/hrPEfx+bGieTks+nse33GQfQZGPF3LyndZLs/L12OFNkg16SXrYxGkpnNUtzRM6qUqQTmioiN6HxqzJOBw9E20ikIOnLOVR04ihvFmHDDBCEiS2t8GOuuH/0rYRv7k8RrgaYMxnXBvSAsCfQAwZ6a8mN4Yg4ePvPplpDyKnXh6ylR1lQISLA74D0jSg63qTCxXYsKQvbhxazgkUPiCPH+30h777vGAX3MWuzt6uOKLxdt1HVbEuAEuu/iXRJmS3snBDJ8IOJUCBWge8bQdt8EpbGk/iD4sSLkZdy5oOJ5fl7CqhPx1goLzCfPghAzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB8811.namprd11.prod.outlook.com (2603:10b6:806:467::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 03:49:30 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8511.025; Mon, 10 Mar 2025
 03:49:30 +0000
Date: Mon, 10 Mar 2025 11:49:19 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
CC: <tglx@linutronix.de>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>
Subject: Re: [PATCH v3 09/10] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Message-ID: <Z85hPxSAYAAmv16p@intel.com>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-10-chao.gao@intel.com>
 <e15d1074-d5ec-431d-86e5-a58bc6297df8@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e15d1074-d5ec-431d-86e5-a58bc6297df8@intel.com>
X-ClientProxiedBy: SG2PR02CA0127.apcprd02.prod.outlook.com
 (2603:1096:4:188::7) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB8811:EE_
X-MS-Office365-Filtering-Correlation-Id: 074321d9-4f2c-4971-91af-08dd5f868ff9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ck82R3V2aUlKWFRXNnp4MStKQUNzMFJlY1ByWnF5Y0ZvOGMzMC8zaUFTYTM5?=
 =?utf-8?B?U3dWeXpFZHNDcUJVN2tNbHlKYk9tVk9GOE5lYXhVYlpHdGRFVG5EbTM0TVJz?=
 =?utf-8?B?ZWlGd0ZmNEJJLzcyRkZCVnlZRytVOWhEYnpIVUFyNGZlcW5HV1licVhSLzVa?=
 =?utf-8?B?Z25kNFlkSDVwVnRuSm4yVmZWbXNWeCtKWitESUtDM2N4OXBNOGNvZ2F5N2xp?=
 =?utf-8?B?NVBHQS9KS2NQSll3WlgyZlczTnhGRHo4UjVZeEdXWWdPa3krL0M2WEZwSE9H?=
 =?utf-8?B?U0FvejhCdnlZendEbXNXc1JqMEptT25ZeGgzN053OFh2N3l4Z0hLSExwQU1Q?=
 =?utf-8?B?c3o5N1NVNnVybnJjQjU5ZTcwM05KK1JveXpLbU9Bbk5PUXJlZ1VKU3ZpTTk0?=
 =?utf-8?B?bDYyU3c5ZGRhelJHNzlNVWhDd2Z4Y0RWTk5IejVoVVBCZFlGVWI2Uis4Zmtr?=
 =?utf-8?B?Q2lyNHhCTUp4d0ZJVlp5R3BkZCtNUFVnNkc3MnNoK2hUYjN5VEc2eGl3K1E0?=
 =?utf-8?B?SzZhRmNQM0RaSU00TVg3WENaRENHWW1FY0NHL0V5VmNpd1pmRzYwY1djS04z?=
 =?utf-8?B?Nys3TjA4Y0JXNjZGSWdvM2N5cWNDV0RGRHVNNkhkaDNYcElHZk5GdW94NzZ5?=
 =?utf-8?B?MVNiemVvWk1tdkpEZTdJaytLOHFZOE1zc1oxUGZhSXAxRzBzNG9Db21pb1Fn?=
 =?utf-8?B?Y2hPUTVvdzlpTGhRVGZWM2Y5c3BRUVRjN2ZJOS9XakpKWSsyWGRySTd0YkdP?=
 =?utf-8?B?ekV1UkxYcisxRFdRc1FvV0NXMU1sU2RxQ2lHaHpKRkxwcmRuUFYrMkVwbmhn?=
 =?utf-8?B?aGJRZXlROG5hZ1ovMW5jWFlsTEZ5WkhOSTRPN1pxL05tbUg0a3NuQlRoRndW?=
 =?utf-8?B?UXd3eTJVbzFJV3g1OUk3MUtRODRpNlVFeE40ZnY1ZGlpeDhrSU91bjFDRHlD?=
 =?utf-8?B?R3ZvYnFRbkVEcHAwWmkyb29TY21wWlBNQ2NmdFBoOG9tS0Zxc2NZREtoSnpU?=
 =?utf-8?B?OFZNc1VxRkJTeUpIRTZadnY2MkoyME5XWDdlVmRCa0U4a1dMa3h3dm5WZzR5?=
 =?utf-8?B?amJzQWU3Ulp2bFJ6c3dXN2x4RUZ1ZkhTNGh4T3VELzVCYzBDMGlGVzhxMW51?=
 =?utf-8?B?YU5hSUxVWkRtNWRFSTJhSW9BTVBpdjFQN2tTRE8ybDR4S3FwcW10YmhDT3Qr?=
 =?utf-8?B?Y2w5Z2Fna003SmJzZWU5a2FkTHpYZGJjZFMyVjhHNjFrMWJOS2NXbjFid3ZR?=
 =?utf-8?B?NG1hN0Frdmo3TGZpcjJEY2Jma25rY3JPcVVId20xRXR3a096c2ZFY3U4dEsv?=
 =?utf-8?B?dUQvWnhhNzZ0bG5peFk3cHIxWUpqZmdsdVVDK0hOeXNYSmtXVENacHdXWFpL?=
 =?utf-8?B?THlzd2dJM2lXYUpqZXJmd3RpMGFCTmo5bFlEYzNjaDZaS2Q3S0hSQnY1Wk81?=
 =?utf-8?B?NEtLdkxqL2JWSEIyRDd0TmVhZkRYdTVWUUhrWU5XMGhRTWkyUjhwTzdsQUhp?=
 =?utf-8?B?WERTby9KbTI1eTFCMW9xSmF3Y0ZpdHBTYkZtVEVmVkdMbkVPUTVMOUtSOXd3?=
 =?utf-8?B?dVFsODJwSHlSNzFyUEJsbjVUVnQ0OWo0NWFQb05FQW5LczBjNjFnbGZHNW5R?=
 =?utf-8?B?UGRYQ3psUDhWMUZqVXQ3c1plMXZGS1BSKzBFZ0JHYnNrOUhtUVpNa0hDUW44?=
 =?utf-8?B?V0J6MEV6MkVZOHVxUnlOd3NBd1RGQUtpeWZ2T1hnTm1WUm9OMGUxc0FPZ2p0?=
 =?utf-8?B?Q2lQZTdrbnU2UUljNnZXenJwbmtVZjc5dTdDNzJMOE9CdXdXWXVuZnZDU21Q?=
 =?utf-8?B?VTQ4M09KcmpHeXdlL0llUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkZXVy80Mm9xRnArZE5ObFZDWHZISkdiRUVlTHV0YUk2NWI1eUVvNTRzTFg0?=
 =?utf-8?B?aFdOZFhtRVJ6T29iWVZLeWZjeGRFVmZvMjhTbTZNVjIyaUpDSnBzZUdBLzZD?=
 =?utf-8?B?MUlLNThBWldKRm1pUFVnUi9wUlE3eGNLcGFhM0pTT0ViZ0VCaytlZ3Npd0RW?=
 =?utf-8?B?UmhsVDljWXJCdXZOMy80K2dUTnhNYTlBaVVBTFczZk50RFlFK2J6RFVCSzRS?=
 =?utf-8?B?YUhLZkhMV3UzM2ZvUUdEVzVQWjRQdk0vaGdiRVFiTlhxTE5rYTZMM2hoVW5y?=
 =?utf-8?B?UVBQbDJCVDNRMzVhS0IyczBhcTZCZzZXa3dxTkNnbmZmbndIb3EvTW9aRlgy?=
 =?utf-8?B?cWJUcW01aU1uUDI1c1RidE5NUHZNN3doZDRmNEZpZEw0ME9BTzJBbUMvUjVG?=
 =?utf-8?B?RFh6V0pjNWprbHhpQTc2dGxHRE1lVk54Y3c0UHJBV0dNcFJjZkFzcnJmcGk3?=
 =?utf-8?B?RmJPbFMyKytBSnRsQitnRUlqQTFoOW9USHF5RFNBSFRkU0d5YlphUzhoRzRr?=
 =?utf-8?B?U0o5WHQyNWtUVzFZK0I2Z0ZVYmxtQVl0QnVoRGt3NEdZaDNtY0l4cEZYUVBK?=
 =?utf-8?B?eEhYMVFtbnBQd2N1M2RhdDMrTEQ2eC9QaUdtaExVdytqQVBkQ2JmQW5hOVRy?=
 =?utf-8?B?TjAxODdscUNDdUZqOXdhVlNLdnVkS1dMNnAzQ2drajlXRDZHUnlIY3o5M0Jn?=
 =?utf-8?B?NE0vYk1BejNPV1J1KzlBc0hXYXZ0eXhybG5QaEkveUI3ZmgyMjJvbDNQTlgr?=
 =?utf-8?B?MXJ0czhkL2hndlFqU3M2bVJvb0t6Lys1TWMrdHlpUWhCZm9EeTdZRm9oUEQy?=
 =?utf-8?B?SVQ4OGZ0dTNZcHNPVDJhWnV3dDdxWkdhejAvV2ZqTGJXOFdmQWRXclNrTmdC?=
 =?utf-8?B?RDU5eEt6Q3Z6OHpwSlBRMTNyM3ZOYzU5ZnU4bStZQ3o4TTJGV201eTV5NFN0?=
 =?utf-8?B?Y0JzSDVoYU1YNHJZWlFDa1NUQzlWaW5xajRtTkRxSUdHSThhZ2Jia3N1a2Rv?=
 =?utf-8?B?SWY1QXkvNUZyNDVURm1mdjRtU01IcEhEQzlLK3AyQ1FXRXJNSW1wN3JoaXpT?=
 =?utf-8?B?SzJiaHNRUDNtSzNHa0pkbWVhMGMvdWJCZmpFNEE2aWQ4dnVaUTg2Ui8rL1RW?=
 =?utf-8?B?eTQyWVZVVlM1dDVHNndhM3QrTmlsMUs1L0xTbzZKT3dobG82WE81Mm1IZmV0?=
 =?utf-8?B?R1hZakoyWVN2bDRVdTFjSHVWa01oVWR4czUxK1Zrd1cwa1YyeldPVG9TZWEv?=
 =?utf-8?B?OExXN1ZZOUtJRXRpMERRVHJUbEtyNW5MU21VUytxalNwMGp1Y1piTlByUDVV?=
 =?utf-8?B?QmN4OE1NekVTZ3pNQmNCbVoxRzYyUngyMFFYQTRVWHd6QW8wSm1LNDU5Tyt4?=
 =?utf-8?B?WVV1cWNlSENpTjVaWkplc1o3VS94aHJjSnRjY0U3QUs4NElmSm1lRExrbGVx?=
 =?utf-8?B?THZ2aFAxMDk2aVlTSHZBSHdEb2dvdTgyQ2VKeTZCNzh0NXp5dlFjQytqNUNV?=
 =?utf-8?B?R0phbDBYN1Fkc2JjNXV4ZHc2eGlzMTR6VUFCM3NicmdiR29PSGFCQk1Uc0tY?=
 =?utf-8?B?WnVFQnJ4TmV0aWRxZVBTaXNjY1YvMnBQVW9qZFJKUWw4dmNiZGRyRG01b2FQ?=
 =?utf-8?B?VkYzRDFLUGh4QlVsRWN2WlA0WUsxZzIwZGpxaTI2UmhVSHJWQm9BQWpIbzNE?=
 =?utf-8?B?QXBWY0pHT3owV1lCTTA5N0lJQlE2VERYT2oxQjZFdjQ1eGxoeGd3c1pHYXRt?=
 =?utf-8?B?eWNJZGJXYWEvVHVHbDBNTzdxU2FBeTNLR3pXb2toYUptK2cza0pBdEJGR2NR?=
 =?utf-8?B?MEYyQjFUemJydENSblpDTTR5Nzk1c3pzUVlZUmI1SU55WCs1Si9iVnNLZlVZ?=
 =?utf-8?B?NTl0ODZvTUpGSmxwZzE3SVZXendWaFUvL1NMOWR5ZUdQZzQzZVJQMHFUY3VS?=
 =?utf-8?B?K0tvZmMxNmNjZVUwTXRtbnlqai9zbVFLT2NhbDBTQkt0dTRTNEhVRTZGc2g2?=
 =?utf-8?B?VzFHR1JDZGRvTzd6b3E1dFdQbStha0t1R282a0c3RGtXTkh3Mjh5VmJrWFhh?=
 =?utf-8?B?N01ENjc1T3dXSUN4WGxhUk1CNTF6ZUU4YmtWOVZuUWI3UHljc3dCeVRacjdL?=
 =?utf-8?Q?pRYLKrx40ZuOFIxd0icFhX9ZR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 074321d9-4f2c-4971-91af-08dd5f868ff9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 03:49:30.3843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZkbyDyYfTala8KtXNYJc1QqL4NvC7GOt9kb46sSvPCOkpiLzgDYf6I3/pDxJ5EDWGiA8VifNLY9iCK171mCx1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8811
X-OriginatorOrg: intel.com

>When introducing user dynamic features, AMX required a large state, so buffer
>reallocation for expansion was deferred until it was actually used. This
>introduction was associated with introducing a permission mechanism, which
>was expected to be requested by userspace.
>
>For VCPU tasks, the userspace component (QEMU) requests permission [1], and
>buffer expansion then follows based on the exposed CPUID determination [2].
>
>Now, regarding the new kernel dynamic features, I’m unsure whether this
>changelog or anything else sufficiently describes its semantics distintively.
>It appears that both permission grant and buffer allocation for the kernel
>dynamic feature occur at VCPU allocation time. However, this model differs
>from the deferred buffer expansion model for user dynamic features.
>
>If the kernel dynamic feature model were to follow the same deferred
>reallocation approach as user dynamic features, buffer reallocation would be
>expected. In that case, I'd also question whether fpu_guest_cfg is truly
>necessary.
>
>VCPU allocation could still rely on fpu_kernel_cfg, and fpu->guest_perm could
>be extrapolated from fpu->perm or fpu_kernel_cfg. Then, reallocation could
>proceed as usual based on the permission, extending
>fpu_enable_guest_xfd_features(), possibly renaming it to
>fpu_enable_dynamic_features().
>
>That said, this is a relatively small state.

Yes, there's no need to make the guest FPU dynamically sized for the CET
supervisor state, as it is only 24 bytes.

XFEATURE_MASK_KERNEL_DYNAMIC is a misnomer. It is misleading readers into
thinking it involves permission requests and dynamic sizing, similar to
XFEATURE_MASK_USER_DYNAMIC

>Even if the intent was to
>introduce a new semantic model distinct from user dynamic features, it should
>be clearly documented to avoid confusion.

The goal isn't to add a new semantic model for dynamic features.

>
>On the other hand, if the goal is rather to establish a new approach for
>handling a previously nonexistent set of guest-exclusive features, then the

Yes. This is the goal of this patch.

>current approach remains somewhat convoluted without clear descriptions.
>Perhaps, I'm missing something.

Do you mean this patch is "somewhat convoluted"? or the whole series?

I am assuming you meant this series as this patch itself is quite small.

Here is how this series is organized:

Patches 1–4 : Cleanups and preparatory fixes.
Patches 5–7 : Introduce fpu_guest_cfg to formalize guest FPU configuration.
Patch 8 (Primary Goal): Add CET supervisor state support.
Patches 9–10 : make CET supserviosr state a guest-only feature to save XSAVE buffer
	       space for non-guest FPUs (placed at the end for easier review/drop).

I believe the "somewhat convoluted" impression comes from the introduction of
fpu_guest_cfg. But as I alluded to in patch 5's changelog, fpu_guest_cfg
actually simplifies the architecture rather than adding complexity, with
minimal overhead, i.e., a single global config. It was suggested by Sean [1].
In my view, it offers three benefits:

 - Readability: Removes ambiguity in fpu_alloc_guest_fpstate() by initializing
		the guest FPU with its own config.

 - Extensibility: Supports clean addition of guest-only features (e.g., CET
		  supervisor state) or potentially kernel-only features (e.g.,
		  PASID, which is not used by guest FPUs)

 - Robustness: Prevent issues like those addressed by patches 3/4.


It is possible to make some features guest-only without fpu_guest_cfg, but
doing so would make fpu_alloc_guest_fpstate() a bit difficult to understand.
See [2].

[1]: https://lore.kernel.org/kvm/ZTf5wPKXuHBQk0AN@google.com/
[2]: https://lore.kernel.org/kvm/20230914063325.85503-8-weijiang.yang@intel.com/

>
>Thanks,
>Chang
>
>[1] https://github.com/qemu/qemu/blob/master/target/i386/kvm/kvm.c#L6395
>[2] https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kvm/cpuid.c#n195

Thanks for these references.

