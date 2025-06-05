Return-Path: <kvm+bounces-48467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ECF74ACE899
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 05:23:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DC311897076
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 03:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 008B01F5842;
	Thu,  5 Jun 2025 03:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bqh9UWJp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5D227738
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 03:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749093808; cv=fail; b=DBCT/W0o4U8o2XZtyaBI5Utk5ldvibU0UKRb/nrm0tpW8P/kLL3HI/IGR9m2+myXSVKJiLQNN7TOi1zVnSXhra0IKc85XysoD5SOc8E+e+1TiWDP+Azji1rHrzcDNygxWMZ8ToMPPJWMpz2Jf7YLJf7pUyuibS6hTOQWJ2brCG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749093808; c=relaxed/simple;
	bh=BNqrk4nvNmvmaPeJHZgKUOGX9UQerzeStt4Lb/3gr38=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b+0fUqkvSusmXWDSt6Q/4DlZVDJ83HwXin9eDhpoFOb0PIzXDoVl45eAR4Jh04Y7YdOb1HQI4FoktmdmNlm9mxyR+Ug7CMzHUDvwIFQFZ6hcHoRk6L9rT8w0ZSrpUrOXVCdYaYoISlj06PyH/zGWlvBgxpxAtXunopcKKYbq/+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bqh9UWJp; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749093805; x=1780629805;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BNqrk4nvNmvmaPeJHZgKUOGX9UQerzeStt4Lb/3gr38=;
  b=bqh9UWJpwIFARFmD0JaoDdsg8SwERpNVDKG2Ooo16fT3R8ld+WmEnk/I
   TiR+wGcYQa8PNVk9nL1XlBGDyNiR536bsnERI5zR4V3NxURATf/Eex9c0
   PsrBlm2AcibzYp7S+bJGOwcXaVNUFh6poTzzhU2lZWGqJELpdCpF2XqAf
   QtL4az0xesSYTiR/vcjDICRyNlNtaET+mrok+0bRdQHNbQs47i37Z3PVJ
   fYzXScI8X4b/INiQAxB8e8YJzTlhXNiu9vBL6CoFtYcyeVoUjWJYe2Y++
   73nKARToJ4jDu9UAmWDmKbEDVOS0RlhQhEmlZanz3N8KdDAYB6/EZKZCL
   g==;
X-CSE-ConnectionGUID: KDQymZ/HQrG0QJdpa7+sSg==
X-CSE-MsgGUID: Y7nrbhWDTkK3bb+wuFccTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="38828113"
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="38828113"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 20:23:02 -0700
X-CSE-ConnectionGUID: /4AvXz/YSLmlyozu9DQIkg==
X-CSE-MsgGUID: sTwXsjBKTwm3H9RZjRCkIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="145868880"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 20:23:01 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 20:23:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 4 Jun 2025 20:23:00 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 4 Jun 2025 20:23:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lR7w3QDfPRfP5pKaFKm7km9amHRsAKa8XpzD3Um8Bkx5C5KGL+COCece2SqafC7A2gjXXCy+/hX8v5T1VeGLaXelHqGg5UcbiHCiRyUUd5/woKU/I4HVLW1b6jzwlTdQRW12crpioVkO4/uJWQ1n2M2zRFf+T9WaNeR/AtZzA/C96InUQwL+gtiYBzKa796c8kk7qqesowkWL9fz8hGmAr6lh7pxyWxnK2EVeCveZHCodWJe4QKnLdCMO7PjtZm2J77M+uxK465IxVtAgLH+y+jIK4LNgMLjaQJXzv23t8vqX2UsnXGYOPBJv62O4/twFf2N5VXHeI7+FDUrIpWw5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Su3STCkQi3ZN29Bcsqu7FZH6hABBqhSugDW+IwqNK0=;
 b=FVYbxdhx7U4zumkOK5bDYpE6AFLpFx0pvQEkG70Vkw5O6mrCqQy9u76YlOX35LCZyc9JcjI5Mr+CyKPKS50AgjIXMzjbsThJNpX3XDL7WiXdXAxsg3EEZw1hiDY4Ca60VHOEZlcJRvabtcAtJOoQcIONonseFJ42uQrQ21pxCjgtO9cD65+RNZKj98Ln/JJEqwqNlrwAERd4qnfZv3mRZpGF9bQ2/W5R0YW8UPMl2YFoPqq8J95sS4W5/KBp85g6z1WMk+pvEHIPmzQvvxL5Ip6fQEK5916x9epc/RrGgbuVSIECZp0IOEJ8DgLZjiXTyFnpzL7v+0gLoF/6s110Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 CO1PR11MB4833.namprd11.prod.outlook.com (2603:10b6:303:99::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.34; Thu, 5 Jun 2025 03:22:30 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8813.018; Thu, 5 Jun 2025
 03:22:30 +0000
Message-ID: <9851f478-21c9-4503-b9ac-abc180c058f7@intel.com>
Date: Thu, 5 Jun 2025 11:22:19 +0800
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
 <d22f7319-6748-4d06-805d-a6b1494e425f@amd.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <d22f7319-6748-4d06-805d-a6b1494e425f@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KU1PR03CA0036.apcprd03.prod.outlook.com
 (2603:1096:802:19::24) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|CO1PR11MB4833:EE_
X-MS-Office365-Filtering-Correlation-Id: 877a54b7-9e03-4e20-4caa-08dda3e0343e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RzlyaFBmaU1VN09oMERkOVNud3hsanZ2dkw2L08rNmJKV0Y4eWZPTXQ0cEkx?=
 =?utf-8?B?Z3VzZ1JVWVZjV0EvYVl6VnlLWjkrWWROaFFCbml2dVppL2w1SzY0UE44V2Vj?=
 =?utf-8?B?WUYwMjdlZ1ZmbXZURmxiaG9WVDlia1YvOTh4cnMxRUlWQlc2S3pIWUlRY1Rm?=
 =?utf-8?B?ZVNpVVRwbHVyR3pPalZwR0pqSFZPbzRLNGNOR3Vhb1g5SkpsUHlWeWpISDZh?=
 =?utf-8?B?WUhMcFZkQ1FvVW1mdTBtYXRzUjl1bytObWplcDhVeWt6MTJwNzZ6SjRCenpK?=
 =?utf-8?B?QzBPT2crNDBadWVySUFCU1NnRjRYTVZ5U3FsTnVzbkROeUlUdGk2NU0wdFQ0?=
 =?utf-8?B?aXhwQXBUV1poMEVNZGVrNVBkc2VnNllUZzZ2Z3JEbmlwVW10cUZiUmFZT1RD?=
 =?utf-8?B?RjBVdnE1OXhoa1JRRjRhMWtHcUwvcGRqZkFWcHN6OTdmUW84eE04elhXM0My?=
 =?utf-8?B?Zm1aYlp1WXlCbEwxTFNoOWltOGdFRlpwMm01MHdoaXF0czBualVDRFRlYU5F?=
 =?utf-8?B?OFBpa01lSk1FL2RhTFc0OEJ4cFh5c010Y3BUK200TTB1UkEyOHl2NDV1bTI1?=
 =?utf-8?B?MzlsNkt3OTBETjRuRDhKUEx3ckVlZlpVd3cxcHlqa1Jacmg5cDBFVTdOcXJP?=
 =?utf-8?B?UnZ1U0c4dEZLWC95eGRBek96RVQrQ2Q1b2JhKzhPdnM5VHo4TEowYVp1Si9w?=
 =?utf-8?B?WFhTRTdoQk5kbHJDWE0xRlhRdW1NeDBwWTE4K3JVczNDRGw2MFNZaUlhajd2?=
 =?utf-8?B?aEFwcmpQYmVjR2RQMElsS3FVTXVxd0lOdjZNZ253U2tZYWcyY3k1bTlCUHBP?=
 =?utf-8?B?c0FsL0pnTVdvbzFpU3VmWDcrUlhNMHZUYmlOZGRSOFdMczlia0srZUdRcUZI?=
 =?utf-8?B?cDlac215SisxN0REMXd1OGluK2VBRmhmc1NnSVQraFhmKzF1K1FINEE0aUtp?=
 =?utf-8?B?TzlDNnc1bXJBZnFnZCswVktxK0tsWU9SZUFXMmxhckxaMUcxOFpaOElFTG9K?=
 =?utf-8?B?blQzeWpYYURwaUxqOGgrbElYMVI4VEROVGV4SVdqRHBJbktGYWRiOFk5QU5L?=
 =?utf-8?B?b0FtblhVazdRczFlcGNHcHMyK2JlNkxlelkyVkZJNHppenl5TXUzQ1lXTEN4?=
 =?utf-8?B?QzBZTkR2SDdnUTJjNHBsRnlvaE90UExwQlMzRUFzM05uRktYTTRFMXBaejg1?=
 =?utf-8?B?YmRzVEMyMHNFNkFxaTVZbm0yaDBsci81MnFoUkRkTXE4d1BVc1g2YnFmMGdp?=
 =?utf-8?B?VTZOQ1U3bW1teUJ6VmxwUkVVbk9VWVAwbS91aUZPRCt5V05SS3kvRmpneGtv?=
 =?utf-8?B?aGpVTHdYb24zRk9QcTR1MU5EbzRId3NjYllHRldDMVpLcnVuR3MreW5ya0Iw?=
 =?utf-8?B?SnhGZXUxT1ZWbTRqcmp3T2pOUktBZEFwTUxTTU1ES09yN0lEWnlhSThiTGJr?=
 =?utf-8?B?cTF5ZzBicUNWS2lOeGQxQWJGdGRvZHZrRDhUY2ZVbkNEakRNTDc5WHJna2lY?=
 =?utf-8?B?aTJNWjg1YXdjNncvaVgvWG93TjM2SjBVNnZCeDRRY21kYm5pZ29Mdzl3Uk5I?=
 =?utf-8?B?VEN5SElZU08zT2dkT2grUDgxelRvcTRXVTZZZGIwWGM0RURUVWJZWVpCRS9j?=
 =?utf-8?B?YzBuclk2NGJiYUNwUG5na1JXVHUveEtDZTN2WHZDbEZxOXFSV2FtcXNUUk1r?=
 =?utf-8?B?L1hUbGNYUGV6dUlvVjdRVG1ZbnVGNDZ3UlZZLy9nZ3MyeStLQU5jYzNsZXFR?=
 =?utf-8?B?NzdrRWw1VWM0djI3RWxJTm1YUXpnN09mZTlCeWpVL1kzUk93RFJGcllsWnlP?=
 =?utf-8?B?Qy9KQmRveEpEdEUrdWpqOFpGQzZNTUVFZ2NRQmNici9kZUNJMzlsdEljbUUz?=
 =?utf-8?B?MjVNZU0ybXR0SnpXbGloZW9nV255Y1I0dHdHNHFHNTRCaVU2YXgyUUZwb1JD?=
 =?utf-8?Q?0gek2ftVt5s=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YjJCYVZ3WE9SRUNjTFMwaVFFNWt4akErbWlIT09XZThwK2FGY011aXJIOUls?=
 =?utf-8?B?YVFvZHVqaUR3OGx0YzdwQWUvcENWYzJXeHJraWE5SEM0M3Z0dU5YSDM3QmJw?=
 =?utf-8?B?UVFKM0Jwd0FDWjcySnBBVVZPM1FxZ0c2YW96enltMm9QS29tTVpXL0pOZDgz?=
 =?utf-8?B?WlovZlFqZ0pmK2Mrak1jaW4wNWdtbHNLY0ZUeXhBNnZ5L3M3cVR2QlhYazRm?=
 =?utf-8?B?QXQyT254SmM4V1RxYm80bSswVG1ScGIycTh5UlhRRFFKTjBPSFgzL3JjOHNr?=
 =?utf-8?B?VnErL1lLYXkySnZFV0ZSZ21MeHVmd1I3VkZYSW5memNjUHZ5YmtuTXFwY0Yv?=
 =?utf-8?B?Q3M4cCtGYUxXVnVwaG5TeVZ5REVnTFF0bkNkVW12V1pRaGRiazd3RHZZdklO?=
 =?utf-8?B?RU4vajdPWHBEcldyNk1rRGRVdWw1S01iT01NdzZ5NVRFenpROVJuZDlaekVH?=
 =?utf-8?B?UmlMTUJXQXZjOVVSZEh2VU51d2Z5NHZ2YnFienpWbU8rWHpuV1JFK01YR1FX?=
 =?utf-8?B?QmJhNzY2R09GUnltZWEvd2JPMEpFTExiVGtsZWRpRGdtajBHMk5Hd2R6Z0RI?=
 =?utf-8?B?UEkxY29sQUJRczFndU03N3NtUzczM1B2VmU3MUZPVHdaU0YzZzhMZDJwbGE0?=
 =?utf-8?B?VXZPWEoxdVNUbFJvV3ZUejJEK1hLL0hLbzRFNEJPS0JOd3ljR1E5RE5RdkV5?=
 =?utf-8?B?V1JQRWlMazFTUi9EalU5THZFTmFmZW1TVkVVbmlmbG9lRmhGOVhrWEpvKzNt?=
 =?utf-8?B?RE5NZEVzZVJ2dWNjK0N1RktaZ0p2R1B2N3J2cGx5bzZOeGp5RG1RMmJ6UzM0?=
 =?utf-8?B?RjVMQm9zYkpET1pTcGxka3ExYmt1bGFWdTE0dC9Rdm1mYnRQaVVBL0xHUXBu?=
 =?utf-8?B?T1N2QUxvSVgxbnVHdHplNXU5WFdTODY4b0VUZHI3V0dna2R5MWJwMHlhelFm?=
 =?utf-8?B?N1FUeWZJalh1TlJoQUNWMWVlcmExempUVlpNRmFQSS9zbU9SWDUrY215USs3?=
 =?utf-8?B?QUJTR2Z0MUM3TGxYNU1xeHBaQWhsbHFLU295K2oyWXU4WmNucDFEL1hCMXpy?=
 =?utf-8?B?ZGE0TmJ1NXYrUzIwTjhLbng4OWlEOVRMWXhhVUJjWmJ5NEpZckQxc3NOa1hs?=
 =?utf-8?B?VkZ4a2FwNTRoN0d5OHhnZlUySkZGd1lud2F2QS9hNFNiNkd3WXBUMnA3TE9X?=
 =?utf-8?B?RnFqKzc2eUxVQzJtdU14NFBieXc4NG5XM1JGcFVvUXFEeHh2ZlpPakZPVkFO?=
 =?utf-8?B?WmtkSHlWWmlQV0Rnb2p3eHd5d2J1Qkc0MFpRM2tRQ1UyZVpQcTdoM2pYcjlo?=
 =?utf-8?B?TVpqZE1sQmxBaU01TjJyRTRscUZLTEFtMnRYQTZ2Wmw0a0s2dWQyV05aMjZv?=
 =?utf-8?B?YUxvNWVHVElCdzNLSUxhei9CeTJmVzI0ZFRadlZvV0YzTHhqTkZoUTR4QjJD?=
 =?utf-8?B?Y2x0TnNmQTZEVzgrcklHNmZqRmdNekJUMGFaQ2VKbWtJVTVDT0pJQWd6QzRB?=
 =?utf-8?B?aEtjUWI0b0dxT2hTd2M4b2ZjbCtPeDNlNUxGNlY0V3p3ZUpZaU1aVDdsVFE5?=
 =?utf-8?B?YThGQUVtazhBc1l5RWdlU1d0cjJmQTRQNU1BVTJydFE0cE56WWJFUUtHWXJV?=
 =?utf-8?B?YjVRSEVMTU01dVlqcVcrV096bGlKT2o1c3o3aE1NL1luL1o1c1NwSlBnMXJF?=
 =?utf-8?B?T1U3QlZMTlhqOG1NeU1TQXBIbFdHc1NVZ2xVQ2NTa252dTRKa0pqbTU3NGFR?=
 =?utf-8?B?YkhKUGdSUnc0dEEvWHFOb0Z0ZzhnczN1Y2VWL1NYVkhlc2JzcWRIUHRiQUho?=
 =?utf-8?B?ZFpNK2tZZEVUMWhZc2hBQjVvb0xmNDRUdHllQ0RyYWhwQmtreU1CVG01Mkt6?=
 =?utf-8?B?eHVnWkVDdi9yOGJUVHdxb24vVkFPWUVCR0VFVXIzMCsrSUZoeHRoR1N0Sllq?=
 =?utf-8?B?bEpISUp0YUtXdkpkczVEcnNBNXRSRWNvcUcvNlkwYlNXTXJPdnlkQkJtTEtj?=
 =?utf-8?B?ai8weGl0RDNEbzdZQ1krTHhtQXpORjNQVDduZXNVTFVaTDd3MG91ZzhsMWQ2?=
 =?utf-8?B?OThpamZtb1FRWkpFRGxSRWhDVDVQWVRPWTMwWmFSN0Q1QUppOG9mbjVHd0JT?=
 =?utf-8?B?K0Vycmwvc3lvZ3pWdE9XQ1BEQjVHWHo2MDJocUR0cTlaT2tveTdjbklRNjNP?=
 =?utf-8?B?SEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 877a54b7-9e03-4e20-4caa-08dda3e0343e
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 03:22:30.5509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iQRZAyvo9cKbgVA678od1fjTNzaZ3oqt1mYav8thvCQtx5TfuUmB7Irypd4utjxDvMRKeg1GUqb3w8T6HQfWQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4833
X-OriginatorOrg: intel.com



On 6/5/2025 8:35 AM, Alexey Kardashevskiy wrote:
> 
> 
> On 4/6/25 21:04, Alexey Kardashevskiy wrote:
>>
>>
>> On 30/5/25 18:32, Chenyi Qiang wrote:
>>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
>>> discard") highlighted that subsystems like VFIO may disable RAM block
>>> discard. However, guest_memfd relies on discard operations for page
>>> conversion between private and shared memory, potentially leading to
>>> the stale IOMMU mapping issue when assigning hardware devices to
>>> confidential VMs via shared memory. To address this and allow shared
>>> device assignement, it is crucial to ensure the VFIO system refreshes
>>> its IOMMU mappings.
>>>
>>> RamDiscardManager is an existing interface (used by virtio-mem) to
>>> adjust VFIO mappings in relation to VM page assignment. Effectively page
>>> conversion is similar to hot-removing a page in one mode and adding it
>>> back in the other. Therefore, similar actions are required for page
>>> conversion events. Introduce the RamDiscardManager to guest_memfd to
>>> facilitate this process.
>>>
>>> Since guest_memfd is not an object, it cannot directly implement the
>>> RamDiscardManager interface. Implementing it in HostMemoryBackend is
>>> not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
>>> have a memory backend while others do not. Notably, virtual BIOS
>>> RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
>>> backend.
>>>
>>> To manage RAMBlocks with guest_memfd, define a new object named
>>> RamBlockAttributes to implement the RamDiscardManager interface. This
>>> object can store the guest_memfd information such as bitmap for shared
>>> memory and the registered listeners for event notification. In the
>>> context of RamDiscardManager, shared state is analogous to populated,
>>> and
>>> private state is signified as discarded. To notify the conversion
>>> events,
>>> a new state_change() helper is exported for the users to notify the
>>> listeners like VFIO, so that VFIO can dynamically DMA map/unmap the
>>> shared mapping.
>>>
>>> Note that the memory state is tracked at the host page size granularity,
>>> as the minimum conversion size can be one page per request and VFIO
>>> expects the DMA mapping for a specific iova to be mapped and unmapped
>>> with the same granularity. Confidential VMs may perform partial
>>> conversions, such as conversions on small regions within larger ones.
>>> To prevent such invalid cases and until DMA mapping cut operation
>>> support is available, all operations are performed with 4K granularity.
>>>
>>> In addition, memory conversion failures cause QEMU to quit instead of
>>> resuming the guest or retrying the operation at present. It would be
>>> future work to add more error handling or rollback mechanisms once
>>> conversion failures are allowed. For example, in-place conversion of
>>> guest_memfd could retry the unmap operation during the conversion from
>>> shared to private. For now, keep the complex error handling out of the
>>> picture as it is not required.
>>>
>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>> ---
>>> Changes in v6:
>>>      - Change the object type name from RamBlockAttribute to
>>>        RamBlockAttributes. (David)
>>>      - Save the associated RAMBlock instead MemoryRegion in
>>>        RamBlockAttributes. (David)
>>>      - Squash the state_change() helper introduction in this commit as
>>>        well as the mixture conversion case handling. (David)
>>>      - Change the block_size type from int to size_t and some cleanup in
>>>        validation check. (Alexey)
>>>      - Add a tracepoint to track the state changes. (Alexey)
>>>
>>> Changes in v5:
>>>      - Revert to use RamDiscardManager interface instead of introducing
>>>        new hierarchy of class to manage private/shared state, and keep
>>>        using the new name of RamBlockAttribute compared with the
>>>        MemoryAttributeManager in v3.
>>>      - Use *simple* version of object_define and object_declare since
>>> the
>>>        state_change() function is changed as an exported function
>>> instead
>>>        of a virtual function in later patch.
>>>      - Move the introduction of RamBlockAttribute field to this patch
>>> and
>>>        rename it to ram_shared. (Alexey)
>>>      - call the exit() when register/unregister failed. (Zhao)
>>>      - Add the ram-block-attribute.c to Memory API related part in
>>>        MAINTAINERS.
>>>
>>> Changes in v4:
>>>      - Change the name from memory-attribute-manager to
>>>        ram-block-attribute.
>>>      - Implement the newly-introduced PrivateSharedManager instead of
>>>        RamDiscardManager and change related commit message.
>>>      - Define the new object in ramblock.h instead of adding a new file.
>>> ---
>>>   MAINTAINERS                   |   1 +
>>>   include/system/ramblock.h     |  21 ++
>>>   system/meson.build            |   1 +
>>>   system/ram-block-attributes.c | 480 ++++++++++++++++++++++++++++++++++
>>>   system/trace-events           |   3 +
>>>   5 files changed, 506 insertions(+)
>>>   create mode 100644 system/ram-block-attributes.c
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index 6dacd6d004..8ec39aa7f8 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -3149,6 +3149,7 @@ F: system/memory.c
>>>   F: system/memory_mapping.c
>>>   F: system/physmem.c
>>>   F: system/memory-internal.h
>>> +F: system/ram-block-attributes.c
>>>   F: scripts/coccinelle/memory-region-housekeeping.cocci
>>>   Memory devices
>>> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
>>> index d8a116ba99..1bab9e2dac 100644
>>> --- a/include/system/ramblock.h
>>> +++ b/include/system/ramblock.h
>>> @@ -22,6 +22,10 @@
>>>   #include "exec/cpu-common.h"
>>>   #include "qemu/rcu.h"
>>>   #include "exec/ramlist.h"
>>> +#include "system/hostmem.h"
>>> +
>>> +#define TYPE_RAM_BLOCK_ATTRIBUTES "ram-block-attributes"
>>> +OBJECT_DECLARE_SIMPLE_TYPE(RamBlockAttributes, RAM_BLOCK_ATTRIBUTES)
>>>   struct RAMBlock {
>>>       struct rcu_head rcu;
>>> @@ -91,4 +95,21 @@ struct RAMBlock {
>>>       ram_addr_t postcopy_length;
>>>   };
>>> +struct RamBlockAttributes {
>>> +    Object parent;
>>> +
>>> +    RAMBlock *ram_block;
>>> +
>>> +    /* 1-setting of the bitmap represents ram is populated (shared) */
>>> +    unsigned bitmap_size;
>>> +    unsigned long *bitmap;
>>> +
>>> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
>>> +};
>>> +
>>> +RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block);
>>> +void ram_block_attributes_destroy(RamBlockAttributes *attr);
>>> +int ram_block_attributes_state_change(RamBlockAttributes *attr,
>>> uint64_t offset,
>>> +                                      uint64_t size, bool to_discard);
>>> +
>>>   #endif
>>> diff --git a/system/meson.build b/system/meson.build
>>> index c2f0082766..2747dbde80 100644
>>> --- a/system/meson.build
>>> +++ b/system/meson.build
>>> @@ -17,6 +17,7 @@ libsystem_ss.add(files(
>>>     'dma-helpers.c',
>>>     'globals.c',
>>>     'ioport.c',
>>> +  'ram-block-attributes.c',
>>>     'memory_mapping.c',
>>>     'memory.c',
>>>     'physmem.c',
>>> diff --git a/system/ram-block-attributes.c b/system/ram-block-
>>> attributes.c
>>> new file mode 100644
>>> index 0000000000..514252413f
>>> --- /dev/null
>>> +++ b/system/ram-block-attributes.c
>>> @@ -0,0 +1,480 @@
>>> +/*
>>> + * QEMU ram block attributes
>>> + *
>>> + * Copyright Intel
>>> + *
>>> + * Author:
>>> + *      Chenyi Qiang <chenyi.qiang@intel.com>
>>> + *
>>> + * This work is licensed under the terms of the GNU GPL, version 2
>>> or later.
>>> + * See the COPYING file in the top-level directory
>>> + *
>>> + */
>>> +
>>> +#include "qemu/osdep.h"
>>> +#include "qemu/error-report.h"
>>> +#include "system/ramblock.h"
>>> +#include "trace.h"
>>> +
>>> +OBJECT_DEFINE_SIMPLE_TYPE_WITH_INTERFACES(RamBlockAttributes,
>>> +                                          ram_block_attributes,
>>> +                                          RAM_BLOCK_ATTRIBUTES,
>>> +                                          OBJECT,
>>> +                                          { TYPE_RAM_DISCARD_MANAGER },
>>> +                                          { })
>>> +
>>> +static size_t
>>> +ram_block_attributes_get_block_size(const RamBlockAttributes *attr)
>>> +{
>>> +    /*
>>> +     * Because page conversion could be manipulated in the size of
>>> at least 4K
>>> +     * or 4K aligned, Use the host page size as the granularity to
>>> track the
>>> +     * memory attribute.
>>> +     */
>>> +    g_assert(attr && attr->ram_block);
>>> +    g_assert(attr->ram_block->page_size == qemu_real_host_page_size());
>>> +    return attr->ram_block->page_size;
>>> +}
>>> +
>>> +
>>> +static bool
>>> +ram_block_attributes_rdm_is_populated(const RamDiscardManager *rdm,
>>> +                                      const MemoryRegionSection
>>> *section)
>>> +{
>>> +    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>>> +    const size_t block_size =
>>> ram_block_attributes_get_block_size(attr);
>>> +    const uint64_t first_bit = section->offset_within_region /
>>> block_size;
>>> +    const uint64_t last_bit = first_bit + int128_get64(section-
>>> >size) / block_size - 1;
>>> +    unsigned long first_discarded_bit;
>>> +
>>> +    first_discarded_bit = find_next_zero_bit(attr->bitmap, last_bit
>>> + 1,
>>> +                                           first_bit);
>>> +    return first_discarded_bit > last_bit;
>>> +}
>>> +
>>> +typedef int (*ram_block_attributes_section_cb)(MemoryRegionSection *s,
>>> +                                               void *arg);
>>> +
>>> +static int
>>> +ram_block_attributes_notify_populate_cb(MemoryRegionSection *section,
>>> +                                        void *arg)
>>> +{
>>> +    RamDiscardListener *rdl = arg;
>>> +
>>> +    return rdl->notify_populate(rdl, section);
>>> +}
>>> +
>>> +static int
>>> +ram_block_attributes_notify_discard_cb(MemoryRegionSection *section,
>>> +                                       void *arg)
>>> +{
>>> +    RamDiscardListener *rdl = arg;
>>> +
>>> +    rdl->notify_discard(rdl, section);
>>> +    return 0;
>>> +}
>>> +
>>> +static int
>>> +ram_block_attributes_for_each_populated_section(const
>>> RamBlockAttributes *attr,
>>> +                                                MemoryRegionSection
>>> *section,
>>> +                                                void *arg,
>>> +                                               
>>> ram_block_attributes_section_cb cb)
>>> +{
>>> +    unsigned long first_bit, last_bit;
>>> +    uint64_t offset, size;
>>> +    const size_t block_size =
>>> ram_block_attributes_get_block_size(attr);
>>> +    int ret = 0;
>>> +
>>> +    first_bit = section->offset_within_region / block_size;
>>> +    first_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
>>> +                              first_bit);
>>> +
>>> +    while (first_bit < attr->bitmap_size) {
>>> +        MemoryRegionSection tmp = *section;
>>> +
>>> +        offset = first_bit * block_size;
>>> +        last_bit = find_next_zero_bit(attr->bitmap, attr->bitmap_size,
>>> +                                      first_bit + 1) - 1;
>>> +        size = (last_bit - first_bit + 1) * block_size;
>>> +
>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>> size)) {
>>> +            break;
>>> +        }
>>> +
>>> +        ret = cb(&tmp, arg);
>>> +        if (ret) {
>>> +            error_report("%s: Failed to notify RAM discard listener:
>>> %s",
>>> +                         __func__, strerror(-ret));
>>> +            break;
>>> +        }
>>> +
>>> +        first_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
>>> +                                  last_bit + 2);
>>> +    }
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static int
>>> +ram_block_attributes_for_each_discarded_section(const
>>> RamBlockAttributes *attr,
>>> +                                                MemoryRegionSection
>>> *section,
>>> +                                                void *arg,
>>> +                                               
>>> ram_block_attributes_section_cb cb)
>>> +{
>>> +    unsigned long first_bit, last_bit;
>>> +    uint64_t offset, size;
>>> +    const size_t block_size =
>>> ram_block_attributes_get_block_size(attr);
>>> +    int ret = 0;
>>> +
>>> +    first_bit = section->offset_within_region / block_size;
>>> +    first_bit = find_next_zero_bit(attr->bitmap, attr->bitmap_size,
>>> +                                   first_bit);
>>> +
>>> +    while (first_bit < attr->bitmap_size) {
>>> +        MemoryRegionSection tmp = *section;
>>> +
>>> +        offset = first_bit * block_size;
>>> +        last_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
>>> +                                 first_bit + 1) - 1;
>>> +        size = (last_bit - first_bit + 1) * block_size;
>>> +
>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>> size)) {
>>> +            break;
>>> +        }
>>> +
>>> +        ret = cb(&tmp, arg);
>>> +        if (ret) {
>>> +            error_report("%s: Failed to notify RAM discard listener:
>>> %s",
>>> +                         __func__, strerror(-ret));
>>> +            break;
>>> +        }
>>> +
>>> +        first_bit = find_next_zero_bit(attr->bitmap,
>>> +                                       attr->bitmap_size,
>>> +                                       last_bit + 2);
>>> +    }
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static uint64_t
>>> +ram_block_attributes_rdm_get_min_granularity(const RamDiscardManager
>>> *rdm,
>>> +                                             const MemoryRegion *mr)
>>> +{
>>> +    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>>> +
>>> +    g_assert(mr == attr->ram_block->mr);
>>> +    return ram_block_attributes_get_block_size(attr);
>>> +}
>>> +
>>> +static void
>>> +ram_block_attributes_rdm_register_listener(RamDiscardManager *rdm,
>>> +                                           RamDiscardListener *rdl,
>>> +                                           MemoryRegionSection
>>> *section)
>>> +{
>>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>>> +    int ret;
>>> +
>>> +    g_assert(section->mr == attr->ram_block->mr);
>>> +    rdl->section = memory_region_section_new_copy(section);
>>> +
>>> +    QLIST_INSERT_HEAD(&attr->rdl_list, rdl, next);
>>> +
>>> +    ret = ram_block_attributes_for_each_populated_section(attr,
>>> section, rdl,
>>> +                                   
>>> ram_block_attributes_notify_populate_cb);
>>> +    if (ret) {
>>> +        error_report("%s: Failed to register RAM discard listener: %s",
>>> +                     __func__, strerror(-ret));
>>> +        exit(1);
>>> +    }
>>> +}
>>> +
>>> +static void
>>> +ram_block_attributes_rdm_unregister_listener(RamDiscardManager *rdm,
>>> +                                             RamDiscardListener *rdl)
>>> +{
>>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>>> +    int ret;
>>> +
>>> +    g_assert(rdl->section);
>>> +    g_assert(rdl->section->mr == attr->ram_block->mr);
>>> +
>>> +    if (rdl->double_discard_supported) {
>>> +        rdl->notify_discard(rdl, rdl->section);
>>> +    } else {
>>> +        ret = ram_block_attributes_for_each_populated_section(attr,
>>> +                rdl->section, rdl,
>>> ram_block_attributes_notify_discard_cb);
>>> +        if (ret) {
>>> +            error_report("%s: Failed to unregister RAM discard
>>> listener: %s",
>>> +                         __func__, strerror(-ret));
>>> +            exit(1);
>>> +        }
>>> +    }
>>> +
>>> +    memory_region_section_free_copy(rdl->section);
>>> +    rdl->section = NULL;
>>> +    QLIST_REMOVE(rdl, next);
>>> +}
>>> +
>>> +typedef struct RamBlockAttributesReplayData {
>>> +    ReplayRamDiscardState fn;
>>> +    void *opaque;
>>> +} RamBlockAttributesReplayData;
>>> +
>>> +static int ram_block_attributes_rdm_replay_cb(MemoryRegionSection
>>> *section,
>>> +                                              void *arg)
>>> +{
>>> +    RamBlockAttributesReplayData *data = arg;
>>> +
>>> +    return data->fn(section, data->opaque);
>>> +}
>>> +
>>> +static int
>>> +ram_block_attributes_rdm_replay_populated(const RamDiscardManager *rdm,
>>> +                                          MemoryRegionSection *section,
>>> +                                          ReplayRamDiscardState
>>> replay_fn,
>>> +                                          void *opaque)
>>> +{
>>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>>> +    RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque =
>>> opaque };
>>> +
>>> +    g_assert(section->mr == attr->ram_block->mr);
>>> +    return ram_block_attributes_for_each_populated_section(attr,
>>> section, &data,
>>> +                                           
>>> ram_block_attributes_rdm_replay_cb);
>>> +}
>>> +
>>> +static int
>>> +ram_block_attributes_rdm_replay_discarded(const RamDiscardManager *rdm,
>>> +                                          MemoryRegionSection *section,
>>> +                                          ReplayRamDiscardState
>>> replay_fn,
>>> +                                          void *opaque)
>>> +{
>>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>>> +    RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque =
>>> opaque };
>>> +
>>> +    g_assert(section->mr == attr->ram_block->mr);
>>> +    return ram_block_attributes_for_each_discarded_section(attr,
>>> section, &data,
>>> +                                           
>>> ram_block_attributes_rdm_replay_cb);
>>> +}
>>> +
>>> +static bool
>>> +ram_block_attributes_is_valid_range(RamBlockAttributes *attr,
>>> uint64_t offset,
>>> +                                    uint64_t size)
>>> +{
>>> +    MemoryRegion *mr = attr->ram_block->mr;
>>> +
>>> +    g_assert(mr);
>>> +
>>> +    uint64_t region_size = memory_region_size(mr);
>>> +    const size_t block_size =
>>> ram_block_attributes_get_block_size(attr);
>>> +
>>> +    if (!QEMU_IS_ALIGNED(offset, block_size) ||
>>> +        !QEMU_IS_ALIGNED(size, block_size)) {
>>> +        return false;
>>> +    }
>>> +    if (offset + size <= offset) {
>>> +        return false;
>>> +    }
>>> +    if (offset + size > region_size) {
>>> +        return false;
>>> +    }
>>> +    return true;
>>> +}
>>> +
>>> +static void ram_block_attributes_notify_discard(RamBlockAttributes
>>> *attr,
>>> +                                                uint64_t offset,
>>> +                                                uint64_t size)
>>> +{
>>> +    RamDiscardListener *rdl;
>>> +
>>> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
>>> +        MemoryRegionSection tmp = *rdl->section;
>>> +
>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>> size)) {
>>> +            continue;
>>> +        }
>>> +        rdl->notify_discard(rdl, &tmp);
>>> +    }
>>> +}
>>> +
>>> +static int
>>> +ram_block_attributes_notify_populate(RamBlockAttributes *attr,
>>> +                                     uint64_t offset, uint64_t size)
>>> +{
>>> +    RamDiscardListener *rdl;
>>> +    int ret = 0;
>>> +
>>> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
>>> +        MemoryRegionSection tmp = *rdl->section;
>>> +
>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>> size)) {
>>> +            continue;
>>> +        }
>>> +        ret = rdl->notify_populate(rdl, &tmp);
>>> +        if (ret) {
>>> +            break;
>>> +        }
>>> +    }
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static bool
>>> ram_block_attributes_is_range_populated(RamBlockAttributes *attr,
>>> +                                                    uint64_t offset,
>>> +                                                    uint64_t size)
>>> +{
>>> +    const size_t block_size =
>>> ram_block_attributes_get_block_size(attr);
>>> +    const unsigned long first_bit = offset / block_size;
>>> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
>>> +    unsigned long found_bit;
>>> +
>>> +    found_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
>>> +                                   first_bit);
>>> +    return found_bit > last_bit;
>>> +}
>>> +
>>> +static bool
>>> +ram_block_attributes_is_range_discarded(RamBlockAttributes *attr,
>>> +                                        uint64_t offset, uint64_t size)
>>> +{
>>> +    const size_t block_size =
>>> ram_block_attributes_get_block_size(attr);
>>> +    const unsigned long first_bit = offset / block_size;
>>> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
>>> +    unsigned long found_bit;
>>> +
>>> +    found_bit = find_next_bit(attr->bitmap, last_bit + 1, first_bit);
>>> +    return found_bit > last_bit;
>>> +}
>>> +
>>> +int ram_block_attributes_state_change(RamBlockAttributes *attr,
>>> +                                      uint64_t offset, uint64_t size,
>>> +                                      bool to_discard)
>>> +{
>>> +    const size_t block_size =
>>> ram_block_attributes_get_block_size(attr);
>>> +    const unsigned long first_bit = offset / block_size;
>>> +    const unsigned long nbits = size / block_size;
>>> +    bool is_range_discarded, is_range_populated;
>>
>> Can be reduced to "discarded" and "populated".
>>
>>> +    const uint64_t end = offset + size;
>>> +    unsigned long bit;
>>> +    uint64_t cur;
>>> +    int ret = 0;
>>> +
>>> +    if (!ram_block_attributes_is_valid_range(attr, offset, size)) {
>>> +        error_report("%s, invalid range: offset 0x%lx, size 0x%lx",
>>> +                     __func__, offset, size);
>>> +        return -EINVAL;
>>> +    }
>>> +
>>> +    is_range_discarded =
>>> ram_block_attributes_is_range_discarded(attr, offset,
>>> +                                                                 size);
>>
>> See - needlessly long line.
>>
>>> +    is_range_populated =
>>> ram_block_attributes_is_range_populated(attr, offset,
>>> +                                                                 size);
>>
>> If ram_block_attributes_is_range_populated() returned
>> (found_bit*block_size), you could tell from a single call if it is
>> populated (found_bit == size) or discarded (found_bit == 0), otherwise
>> it is a mix (and dump just this number in the tracepoint below).
>>
>> And then ditch ram_block_attributes_is_range_discarded() which is
>> practically cut-n-paste. And then open code
>> ram_block_attributes_is_range_populated().
> 
> oops, cannot just drop find_next_bit(), my bad, need both
> find_next_bit() and find_next_zero_bit(). My point still stands though -

Yes. a single call is insufficient as found_bit == 0 can also be the
mixed case.

> if this is coded right here without helpers - it will look simpler. Thanks,

Do you mean unwrap the helper functions? Since there are no other
callers, you are right, it can be simpler.



