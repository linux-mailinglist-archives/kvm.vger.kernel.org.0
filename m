Return-Path: <kvm+bounces-44995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EA2EAA564C
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 22:59:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E79B172395
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 20:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EADE2C2ACE;
	Wed, 30 Apr 2025 20:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nvMjlDwR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB512980AE;
	Wed, 30 Apr 2025 20:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746046504; cv=fail; b=HG6K646M2R0OvdSzy7vGDlNATvynwefmS1mEUak9b7WYLiTzXKu4Hpr00GeptSeSEyzgm6o3yk0cKR7WJrERQGLFG67zgyLuumc51MgFgusyG67LwQeQErmPvp5uQquwxfZ9O5ZH7Vy3cwBMYaA1daejtQb5GO/CzdBiushXHis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746046504; c=relaxed/simple;
	bh=wQnXJwD/GCfX1vIJsMaChMk95aGHkWmqYAsgFTqC87s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sgkffCkkOGD00UYWe+4LuhJVAwa4SkyRbqzjK1F8W7gKmLCs2fMwzx95ufJGlvIx6flIbcIWzl/jIfM84XOYME5ebvFdTLcLwi8e6j+GUHCoon2wAYSXTR6A1aphmE4FYCpteM1lnhmuupg4KIZErU6vK3OsP8zo0T1dmGcCvdI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nvMjlDwR; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746046504; x=1777582504;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wQnXJwD/GCfX1vIJsMaChMk95aGHkWmqYAsgFTqC87s=;
  b=nvMjlDwRcXaHZaxFJ+dRi5p5MfKToxJP5X9AReKAg0fREQC8HexA2WDO
   PyAAooN6L3v+iTkzrPl+esTfSNXQv8XTzWGF+ueqXP2YYTaIeeIE9B/vW
   DCPbqEGEUDJQEZ8W6tkM2bsQZFm+0wgkUwMilx79NpASQY6856FbgGVa+
   Q3eHXxpnEK/FHiVn80GfCaSEbWqPt/5mOpI8G84CIM1ubQkQFcsKgF99l
   7MK4/ddX3SjVB1gUGyGfVu675HL/+Wg/ihVUiQOmldsLrRk2FJUpfJU+F
   QFnEaj/Lg+S6uQjsnk9+s+6GENGmfh71zfQHjzl4yFU8xDw/qzhU0dCAn
   g==;
X-CSE-ConnectionGUID: nqrLh4KaQyOR+cH2bZwcmQ==
X-CSE-MsgGUID: 0AS53gEHSAW14+9VIKFB4w==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="59102644"
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="59102644"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 13:55:02 -0700
X-CSE-ConnectionGUID: 9RzygOMwRLmXM6c1JKYzcQ==
X-CSE-MsgGUID: lRM7twCfT1K5NMBTP6z+9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="135175029"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 13:55:00 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 30 Apr 2025 13:54:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 30 Apr 2025 13:54:56 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 30 Apr 2025 13:54:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rd/Kf0NV/1RmcMrRxVxZC/Sfg0iD9Sm09H33mPuoLHARP92dWM214aJlqZlUVAs8H1iCVi78zDW47oOl46XKd4KAaY5LTcTo8IZqc4X/xjSWLVwq0GilixRr0a7vPHXjpGGY1h0h+2tm4KGzW/NrtvTx72zSEcALmuT8IZy5g1Wqc+WQasXlXT2peQMULWxNE6oW5XdXUCKJy4FmzaWc6dDv3D8ZcLxtmwJItlazQuMYgV+CM4HCQUFbG9s0XGoa6N6wVtYJRapC22zZaQHoxtDfWu3AqaTnxpCJCGTNObh8LwtU/IhPo5eC0czcAaOI1eMxxsRnJk3p4AObVORqNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LHxKt1avCW86UTsaj5v2FzFrh1y9cY8Dt6bHPnHW1sM=;
 b=ganpJm44qdHvyIsRPfP7t6Kzwh911XZaVxWCXRWHYyfOMTMaQcq2mbzWGz4rfb3LQBjmZMNBFFoKf89tKxFowFhIqrkjlf3ZQl7czGrN+y13Caof1ah0ZEUYvlXkTAFb8O40gvUhbpvjJVPDPI6EuLUUXdfhRpda8gYYdvcqtQdIJMtAxbQlQBEiuxSq9fa1tcn+/fDVxL7CGoxxuQtOf52B35u/mvexK96vy/lDmQx1d0KGHCQ7fQIZG5emd1mKG7Xm0GboHTisF0gXOjSmYJgVeGHrBJXx600qp7Jn2lazPgI8uwWchLSK5bnd4jwNjfVkV2HTztlKRpLpuSi3Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH0PR11MB5205.namprd11.prod.outlook.com (2603:10b6:510:3d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Wed, 30 Apr
 2025 20:54:54 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::7de8:e1b1:a3b:b8a8]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::7de8:e1b1:a3b:b8a8%5]) with mapi id 15.20.8699.019; Wed, 30 Apr 2025
 20:54:54 +0000
Message-ID: <f20ffdf1-7566-4466-9e92-b6d9878b6fd1@intel.com>
Date: Wed, 30 Apr 2025 13:54:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vhost: vringh: Use matching allocation type in
 resize_iovec()
To: Kees Cook <kees@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
	<eperezma@redhat.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-hardening@vger.kernel.org>
References: <20250426062214.work.334-kees@kernel.org>
Content-Language: en-US
From: Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20250426062214.work.334-kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0104.namprd04.prod.outlook.com
 (2603:10b6:303:83::19) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH0PR11MB5205:EE_
X-MS-Office365-Filtering-Correlation-Id: 97e50d56-ddc0-4ef4-0cc0-08dd8829422a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bDliaTgrdVhlcW5ud0loY05QUFNNejVrbFhsNm9Ba0VLT0pla2FxNDFQUE13?=
 =?utf-8?B?RUtSNHpnNkI4cTJCdHRzNWVzZFE4ajQxOENOVU10cEF4eWlwUUQwYWlsQTNW?=
 =?utf-8?B?Z3p1UUhRYjcrOXU4dDhXQkVWR2RpN1hkSUtyWmhTRWhxUkorK1dBcEZsN2RS?=
 =?utf-8?B?SzZNUTgzMEdCb1ZyWEtGc1dWMm1WZ0pDcExpaVROV2pHM1l1c0o5M01iWHZM?=
 =?utf-8?B?MXFCK250RmpZa2VVd21oUG5lb3VMZWNVSVkxR0tJVlo2ek50ZzNDcUxnTVU3?=
 =?utf-8?B?M3ZlV0pFbHR0L294Vy9vajRKMHJhV1dKbVAzYVNvRXdEOVhXdGlCbW5Wd3ZI?=
 =?utf-8?B?ZkhUYjVWc2RKZStWZnBwSmF0Q2Jtem5qZGQzRWJvWWNQN1FoTnArL3lYZGQ0?=
 =?utf-8?B?bmxiNk5qMk9ZUUxxdnBYTXk2cUlYdjV2Y0ZYb3JIdnB6N2FXSGtlczRIbFlw?=
 =?utf-8?B?SWNUM21QcW9kWHJOUitBRG5CcGp2cE0wZisrVjd3b0Q4Vmw0MG04QStVcDBu?=
 =?utf-8?B?bGF6L091T1lwWUMrVmtDZTdwVVRRTXZpUWs5eTFNWVRnbThJR09SZGNDVjI1?=
 =?utf-8?B?eFZkemhPVHVnRlNiVGx3K2QyZTQyMWdIbEI3UHY4RFRyRk5Rc29CS1VjL2pm?=
 =?utf-8?B?SjRKQnhaVjdrcTBBblh6SXpIcnhFeE1aSXlvTmMrQ1JGeVBaSnhoTVdMM1B1?=
 =?utf-8?B?d3RKNHJpN1gzUUcvbVZGYkR6YnVoSEdHMlM1QVNOc1NsRi9FbFF3amRXbnhY?=
 =?utf-8?B?SHQrNkxIQkpLNG9ETFU5blU0RS96ajBlNTgvZjEwajlaajlPYWUrY1BUOHgy?=
 =?utf-8?B?bjhuRmZuQ2M0MTVMeURWcFg5cC9FeUdnRzJPYWdTdW0vR0NlRWY3RXdlSkl4?=
 =?utf-8?B?cUtNbDhmYXdkSGIzdjNmWXBxV2RiMDhDM1VyZGcxMm8vRWp4UVpmTXJ0RWlz?=
 =?utf-8?B?dEV1a1dLQnVicElpdnNIUUNoYm5LQVR2VkNjQ0xnaGpMRXNFSHFUWjdBQ0Rq?=
 =?utf-8?B?WFQwRFlBS3dveHdWZHAyRk1kTnNJNjcrWDN5a01Qb3VDRnVQbGNPTVJWZFc2?=
 =?utf-8?B?S1FnczJ1OGwrdEZuRlB2TG14K2tZUDRuYzViYW1rSjM3a29ibUh2SzBCaTJh?=
 =?utf-8?B?RzFITGJKd3VhYVNWclhuTWRrNEtnUGVVV1RmK2tVL2EyWmxjV3VrckIxSlhq?=
 =?utf-8?B?ZG1BczVBYVhpdmdiYWxVdGltdVpMejZkeVUyQ0N4TTJEKzg3c2dhY1crQzBs?=
 =?utf-8?B?NnRxZ0pPVzNRbVZST2ZsaHFzazdJSUh2bHFMVVN3QlNvb3ZxcnUvT2JqdTFN?=
 =?utf-8?B?YkswaTQzbUJpL2dHMHF5ZlN6U2FTNmxZcVdSckN6TWtjOVV3MDYrc1VQdDVi?=
 =?utf-8?B?UktIUHc3UFlOU1ZBdVFVTnV1OGErVzBiNGlIWmVFajZ3bmErYUFDMnFyVlBr?=
 =?utf-8?B?MGJRVmt3NjVJWXQ1YjVDbE1mQkpFOHZocVUrUWttWFRzbm5HQ1BzYzRDRVd5?=
 =?utf-8?B?WkI3MlVzODJ5TTRYNzhIb1J4c3hxeHVnZWlpcnR4S2lBQzFFTzRiUVRFUkZO?=
 =?utf-8?B?cEYzZmRXRDJHSzVncUcrL2FOdFd2bUk1Ym8rNVRxZDI1dFZ0SVpQMHN0eUox?=
 =?utf-8?B?dVpWQXd3aDh6azVMM0d3eU9GYktReFFOaVFOamlDVEE4cExqbXUyTlFQeldt?=
 =?utf-8?B?QTRkOS85UWFMaHhyNEJEWWlHUGtIeUZERCsyWGlhU25ud2kzUEFXVVFlSDIw?=
 =?utf-8?B?UUFSNkwycFN0bW9uTUZuOThkYVhKSlBvSDZIYkVvZE02dkpiSUpVTzZ2cHMy?=
 =?utf-8?B?c243enNKY0p1bEszVDhJZHF6QkZNZ05jTlZVb1E3VkViWUZWNjkvSXo1SmQy?=
 =?utf-8?B?cGVWUTJHYjIyWWJYTEp5SThHNEJnT0FtUGlrWGlBLyswZUEva3FkOU5XRVVm?=
 =?utf-8?Q?kzNnLmC07u0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MnR2bkUwdnAvV0xxMEU0M3JVREFhRXAyQk1Lc3RVNmhIckkwUmRabVhjM2Iw?=
 =?utf-8?B?NWJJOSt4SE9Jdk05TzVlZ3JsY3crWDZ5QkVyOW05TXk3ek5DSTBLMGo4ZXQ2?=
 =?utf-8?B?Smh3WGFZaVFxZGtNeDRKeWRUaVlWb01vN2cwZUtGb3IwRGwvamVKMTlHdklT?=
 =?utf-8?B?ZUoxVGhsZ1RqRjQ2a0NmNTlXeTRDVzhFenFhVXFmdDB5Mjk4L0RCTXdpZ2lo?=
 =?utf-8?B?WWp4ai8rdDRpWHN5bXlBM2o2KzFIQmhaSitzNGRnMGN2Zm1rU2djenlWSFpT?=
 =?utf-8?B?MXJlMm4rMTZRMFBhMFZvbm1iTzlCNjJzTitmYXdOUUc3T214a05CV0lSTGNC?=
 =?utf-8?B?SEREeEVaZ2xxeCtKOENLd1dJLzdJbHBFN1pCRHVzZC8xRjQ5WTg4K2E0OGJu?=
 =?utf-8?B?RUZlWWk5U0FaSHJ4QWtBb0dkWjFCenoyQVZQWTZhWUZsS08zQ24vM1d6aHhQ?=
 =?utf-8?B?MEc3VGtUOHh5L2Y5U2Y0VmhJMk5tcUlYaVlOaWxaUWRScmliRSthUXNGK3hy?=
 =?utf-8?B?SXpwYkt2c2xsSEZIQUdYWENBM05KVkpRLzA2T1BPbWwraDBzK1pvalVEU3J4?=
 =?utf-8?B?V0E0NE1wcDFoUmhUYlFVQ0hDUTdtZW1sQnZZOTJSUE5HR1hScU5tVHhsb01M?=
 =?utf-8?B?YVBoTHJQaDVJcURmZ2I3N0xiYXhxS0ptR0g2Q0crcGYwT1ZOYmJzRXpyMFlY?=
 =?utf-8?B?ZGErWG1keW5UbjY3TjVkNytGd2lTSkxDazhubHkwNXZpRnhRdUt0ZVpaMkIx?=
 =?utf-8?B?WXVLOVRiL1FiclZjQlBHTzNwekI3Z2RnVkVtQWtuZnNnbUVmMEJ5bTQxOWNS?=
 =?utf-8?B?dkMzQm1lU21tVnB4cUtheWJRYmp5RUtOSjJaclY3SnVDYkZSK29EOWoySlhD?=
 =?utf-8?B?VlpSUi84SzUvMlRFUEM4MXdrU1N1WDdYSWVlM01sU2JIM3pOaUREVXlMeGVB?=
 =?utf-8?B?M2VyUUpnWEFrc2p4TnJPZEtOeTVaM2JkanMxSUxwWmZUV1RLMllybnU3NnJn?=
 =?utf-8?B?Q05MMlBvT3NpZlBKVHA3OU52eGFjNmE0NzJwUThvRENpZlU2VEJWcTB0aytT?=
 =?utf-8?B?SWVFRzk4UDRsODZzM0JoY3VFTTY1L3JoeFdsOW9iVEZPaHRORGpEZWFlWDRE?=
 =?utf-8?B?blRlbytzRlppVFJrN1VtcUFnQ3d0bkhMaHZCK2tMR0d5TEZlajJxVU1VSGt5?=
 =?utf-8?B?QVd4RHAxSytpN2kvZzJwTzRtOFI2R0xKcC9WS0ptU2RxQXpxcTlxdDV2c3li?=
 =?utf-8?B?L2hhakV6cGpEYlhFcysvQndreVJ2ZC9JVFZmbG1lZDI0SkdZZkRFNW9PWllu?=
 =?utf-8?B?WVA5SVRmMlRBeGdQcktmK0VSTld3dk1JNHkzVVJKTzZaOEFnVFlzeitEanZP?=
 =?utf-8?B?WEJ5WjJaL2dmRlVwanFhcERhMFF4N3QrbGhtUEdCOVhVK3VJd1RsTjlOaUp1?=
 =?utf-8?B?WFRNYjMzekFNUjJhTklJYmpJYjJkbmd6YU5iQ0srNkJ3dW9sMm5nK2YzVktZ?=
 =?utf-8?B?WFhCbGx1UGgwQWE4WW1rd25qSzQrTWxCVFk4UWxXSlZZYXZFZlRpOHEwOGFS?=
 =?utf-8?B?amhaVk9wL3RhKzV5TEdMaTNEZlFhc25IelVZRFdXVWtWdmViT3hJUzMzTEFQ?=
 =?utf-8?B?djRLVHhSMWpSaWxtRnNjR1lobDR6cUNqTkM5WGlvTUpLQ1pldnBvT0lhbzNB?=
 =?utf-8?B?b1N0VFc4VzdXNHBUbisrZ2NvOHZKaGp4djNYSGZBU3VWUXpHZk1PZ0dxOHdU?=
 =?utf-8?B?Vi9rMXNzbndiZkJWTUZPNEJVYm01dXhxejdRVzBjZktNS1hyclpqbTJ5T1dB?=
 =?utf-8?B?VjhDdVEzL2JHbU1oVys4VUwvQVAvanZqRXd2VDFrdW9Kb2gwTHNCVW9OTTds?=
 =?utf-8?B?d3crWDQ5eVdod01WbU5EMXF2b2ZWY25JS2pIVDZNWVhSSkdBTE1jdzM4eE5B?=
 =?utf-8?B?Y2hRVjQrUVRsMzlHWXFRZlNNa0tMZEVaczlqRjRMc0ViU1pRSzllMnRnQldH?=
 =?utf-8?B?bzdPNnBJbFhLWUkvbytwWU5yUFVHNzh6VHJnNDZ4T05oYU10T2diY2hQNTYv?=
 =?utf-8?B?Zk03WkdSUExQVjhsVUNZQWxwTTlZa3VaNUFiQWJMaTZsaVVwTDJ4TkxzajJB?=
 =?utf-8?B?WGdXbS9MVWxEOWU3aGh1Zk50U1VQQm5iN1JsUktGZUE1YWl1MkNHbkVjQnJO?=
 =?utf-8?B?UVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97e50d56-ddc0-4ef4-0cc0-08dd8829422a
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2025 20:54:54.2620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BbeJJZy9GqXY1pcXXQAo6bizX6JO/SE6fwVfP5zQgQ0HV5uPJf48FwdxW9l3trfX1sM7n7oPBULnL92rOrxIn9vFXjQBCCZNWbVA2N1NTTY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5205
X-OriginatorOrg: intel.com



On 4/25/2025 11:22 PM, Kees Cook wrote:
> In preparation for making the kmalloc family of allocators type aware,
> we need to make sure that the returned type from the allocation matches
> the type of the variable being assigned. (Before, the allocator would
> always return "void *", which can be implicitly cast to any pointer type.)
> 
> The assigned type is "struct kvec *", but the returned type will be
> "struct iovec *". These have the same allocation size, so there is no
> bug:
> 
> struct kvec {
>         void *iov_base; /* and that should *never* hold a userland pointer */
>         size_t iov_len;
> };
> 
> struct iovec
> {
>         void __user *iov_base;  /* BSD uses caddr_t (1003.1g requires void *) */
>         __kernel_size_t iov_len; /* Must be size_t (1003.1g) */
> };
> 
> Adjust the allocation type to match the assignment.
> 
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

