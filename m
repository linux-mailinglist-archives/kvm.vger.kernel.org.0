Return-Path: <kvm+bounces-21201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B3CB92BBA2
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 15:44:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC7E51C21715
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 13:44:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD1B415ECCC;
	Tue,  9 Jul 2024 13:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ietbFtHJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF3915CD58
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 13:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720532682; cv=fail; b=MbDqD5m0Gj3s0zPI+zb5OJ6PJtMT8lzWuLE/p13saTOTEsqD56vTurdQLbxONUxdDuoK6no0jTe99X1jc1wJI7i0ajV23jQpbC++Gdcc3p6HHse/J4hXoHucO72f2H+iE/93Qq8Fd6K1wvZqzuBFtvp6FedFxCHrufI7HUusSv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720532682; c=relaxed/simple;
	bh=iPgYumTgk7dB7hEl57RGTF+01H3Oir3UrJGd6IS66U4=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o91Ae5onB3TL0IuJuXhcFa38AcVunldUDLVHqLWMO2ef4QrYPxoaIt572ssutCD7IMFkS/zZgwkfGVVujydd2SyFbwOwILmN1mxWMqPzlKiq9A9rqf1RJjCbdHyCPLpaScYlk773ha8cW2Pa4kznwnMrsfmegpcfyhgITd1DXbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ietbFtHJ; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720532680; x=1752068680;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=iPgYumTgk7dB7hEl57RGTF+01H3Oir3UrJGd6IS66U4=;
  b=ietbFtHJdj1iIq8pv60bAwhZhtt/Bnuxd4Z9d98cRRAEfRDNZfcIlVSt
   ME1xRFcy5w9Uu+vjEBmxC1r6FVctvbsvw+Eu+Bw5CUR0vJvWCDFm7k9bi
   vtWP75ImcHu+zE5R44HaHYxcZ1zeUfZSz4fVKBS1hEq4a3Csik9+PFLIo
   EJ8BPmwoZ+k006/W+Kw2QI9XWdNYiJ5L/g0Sm584b9HZVgToxH9l903QO
   xoqZq7yMlxqOXDr/B4GS8eATsffq1QxG3ruSCWbpXrB8j2n0Agc9U81WH
   0jJbUcF1vPq/LVqxwEtuTGmVt272Wtvl2FwvlUuMTjq9zGWOafYqhoOq9
   A==;
X-CSE-ConnectionGUID: FD8HbTWpS9u76pim/LSeDg==
X-CSE-MsgGUID: DJ+21tzHSm6dTK36xWjhIA==
X-IronPort-AV: E=McAfee;i="6700,10204,11127"; a="17926246"
X-IronPort-AV: E=Sophos;i="6.09,195,1716274800"; 
   d="scan'208";a="17926246"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 06:44:40 -0700
X-CSE-ConnectionGUID: W6YEpYU5RZihzpz7qxMWXg==
X-CSE-MsgGUID: M963eyb8SMOFcePU6HvPIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,195,1716274800"; 
   d="scan'208";a="47832367"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jul 2024 06:44:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 9 Jul 2024 06:44:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 9 Jul 2024 06:44:38 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 9 Jul 2024 06:44:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5GA9GNm1yzR2PuHaEm4ECey+1xx9vvnbbCBoJRnAKiYKyy20uxKSrUzEUwB1YwhUKyIbxiBc+lkpOphTnvZzyf/wOEOVaJU2c0u4SQMT+xZasxI3VaGFhSxyJIRV8UCsCbaH6FLBnmSM/0TJzxiZeVLpJdJcaslOf0eq3hjbzJq0C0IAXst+e/ffr+Nt8u1mmORszfV2RL2KnQd/X7re5N28Li3nJoYqwG+JDL3YRbHqp0fBFpBqfGrN7w29M8X/Qm/TaIu6SAItNR8ulMm1pMWUQdiD641ibv340PsMJ+eXieAiL2juJHqtVnl1rS4mz41Is8JAzwITSa75PZ74w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zE13+7HwMHEC+l81t5C4Ltf7zBq4ZvdLvJsvQHYVyBg=;
 b=jf2VcEW2OEIkuABYQWmFt/oawwcnzD6GoYoVvJSqPiWatJfAN8JUfTZhmdzLweiVxzMsAtESJpPcWbFUW4pXla7NnJ2kPsOpgdP1o8EHS4cBnv91umgqMP9o6lzA8o7uLI8+uJlIr7jKtPaOaTe++CTOkxeREf684Vv6IyDzTLbAilmAmWql2/Mt6fWVyEeZ+n46zBf9ahPuXhV2/ia5LY1bhrAQ5EoqZAjjHYblT6NU/VxVF55+tUAi+Itb+nOLUc1vcYVi1ND6dN/TGo1MTkTa/CEzw1KioU9nBAb5Rot98nwNKnbL2hkma22lhfYC7Eas1df3MvsxZWFHR6eC6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ1PR11MB6178.namprd11.prod.outlook.com (2603:10b6:a03:45b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Tue, 9 Jul
 2024 13:44:34 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7741.033; Tue, 9 Jul 2024
 13:44:34 +0000
Message-ID: <f709cd03-ce5c-4590-9457-dba052082f51@intel.com>
Date: Tue, 9 Jul 2024 21:48:30 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug 219010] [REGRESSION][VFIO] kernel 6.9.7 causing qemu crash
 because of "Collect hot-reset devices to local buffer"
To: <bugzilla-daemon@kernel.org>, <kvm@vger.kernel.org>
References: <bug-219010-28872@https.bugzilla.kernel.org/>
 <bug-219010-28872-7nnWxWVTff@https.bugzilla.kernel.org/>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <bug-219010-28872-7nnWxWVTff@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0038.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::15) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SJ1PR11MB6178:EE_
X-MS-Office365-Filtering-Correlation-Id: 8886fe47-80c1-4f6b-0184-08dca01d447a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T2ZWeEFMZHJsYjZueDB1eCtJelh4NHVSNTIyM1JCVTJBeVl4RUNOeXUxNWJm?=
 =?utf-8?B?ZlFyaWxBcnd2RW9OcER2RDVXMmt4WmEvTm9JS1lwR00xS0poeDhHVStDVzRM?=
 =?utf-8?B?NmxGRzd6bkxEeHZjcXdVOUFqMm4rRDlnNHNqdmlHclNBbGwzOGNyK1V3MWhI?=
 =?utf-8?B?bUJZMzJTMVgxZkRJVG5IaHBxeVRBZitVR2poZ291eVZJRWxrNUFsT2p1Qjhq?=
 =?utf-8?B?RW1DL0FTTjBDNDdCbDlsU3MweEJFdVlFQlNvQTU0a3ZFVjRKUVc3cG5pTVlR?=
 =?utf-8?B?QUhGR2l1Mjd2WFI0SEU2b0YyTExmejVaYktFRmtCUmw3T1p2VVF4VE1oMEtv?=
 =?utf-8?B?SmRsTnM4Y2t1L2k4d2FUL3pvSkRXT1dhei90NlI5SFNSSFRxNzJENWVMUjkw?=
 =?utf-8?B?eDFGcHdHNTF6OFM1TkRHb01SUUZ0bTV1SDRhQlAxZjFTL1piTHE2bjJZdSty?=
 =?utf-8?B?TXRlaTdsZmw2L1U3ZDdJc3JESnJnTG9ROHFiMDZYK1l3WmdjT0VnYjhOZnZy?=
 =?utf-8?B?bUxod1ZuUFRXUTAvTFQzckJEWDV2TXNvNEg0alV0TXUvOC92NDBLZmtaVU53?=
 =?utf-8?B?TmtNNUFiS2wzdDZxbXZnVzRlZXcyNHg2cmJqeXdJcUNwcFdRcENRR3JtVk1l?=
 =?utf-8?B?NnBJRFlyNmFRY2thUXJ1OGhOekhKbHA3bW1LWTN1cWhDTFZ4clJoWEI1bUI0?=
 =?utf-8?B?YnE1YTFPRW5hYVN1emQzUmRPTTN0SDVPTHNmM0crMXNzZzk5djVtQ1FPQy94?=
 =?utf-8?B?eTVXSksxV0pidXVqcDlyOW81QVZMWmtiUHAwU2pvRndZaU4wM1lBU2Y5ZGRC?=
 =?utf-8?B?MUQxNVFyY2tNbm5POXFuMkJYcmpyajNCWWNwMi85MlVvdjN4NEt4QkxqVjdk?=
 =?utf-8?B?b0o0eVozVEx3TzVYMkFOUHhiUENFU2pvNFJUOFJzMFlZTWI0VHBMV3VxM2RI?=
 =?utf-8?B?cWdIblgyTWNpdjZnc2dBK1B3NXBYMERkUWQwNGtDaVV2aFRSZWZ5aWhpODRx?=
 =?utf-8?B?S3JPc25ZS3dPb3dGbWUrM3J1YkkxNm5ScWZBV0VRdnAvcWRwaE5lMGxhb0N5?=
 =?utf-8?B?YXF3VHJhbURCWEhGY2NVaTBCOEFPZUUvK1BocmtHbFQrdk12SStENTQwZzNB?=
 =?utf-8?B?ckZ3MTFKTFhFUk1mMkVrYjVhZWdRU2ZTNnhlRGNPcDJIZ0tmOEpHalJEeldN?=
 =?utf-8?B?KzIzSnpwZytrczNRdDdwSXdiOTVCNVRzV3FOL0JmYjdENTBsSWdNOUxNbk5D?=
 =?utf-8?B?QUNvMndpOWtsOG5kU0haVGhRMkxiTDNCZ0hRb0NEQTlhT3M1ZWlFMVoyTS9o?=
 =?utf-8?B?Nml5dWlHOW4ydnhtS0h2bWZ3S3dxN3dHVFd2VTBlMUNJMWNYTmNPS2JDRmdX?=
 =?utf-8?B?UHNXWGltWFFsbFd2ZnJTcktQSFNHUWxrNGdXbEQ4VEViVWw0eXNzcnVCdkUx?=
 =?utf-8?B?SkVBRmVnZ2ZHWXIwNWNTTUJ5SDJUcTNxTE1BQm1vM1NVc1drR29NazRFUFdU?=
 =?utf-8?B?THMyaFdrb1F5dVAxR2ppOUh5cS85S0VMcVhHRUJvSjFaMXRvU1c1TmJ0RHIy?=
 =?utf-8?B?a3lkS3FTME8rbkhnQW5ZWElvZVIxbkwxcnNLczl1ODhZK21kMVg1ZUtaZjlD?=
 =?utf-8?B?MCsrWU9XUnJBbHdsVGE1S01XdjZCRWQ0YWRoZDB4QWNwbHkwalZtODJHVHlH?=
 =?utf-8?B?NThaUmhycVp0a3p3aHZuR2JMTFVlS1d5SjBSSUFWOElHQ0tsazRJZ2o1NHhv?=
 =?utf-8?Q?pq0gRX9HGYaX9MpqEc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXU5MFpxakYwNC9uYkRLWjNmbnpCc1dBd291ZTZFK081b3VXRk9BQzdNMDYz?=
 =?utf-8?B?cE1uaEU5Zld0N2JzZjFrWXllZkZJWVFycTRkYnlCcXpmTiswdkVjOG16Sm5a?=
 =?utf-8?B?YmtzNVVIbjdBNzlGRGFwMHlLNnFObU1TZGJoeGxic1pXbHZqNGVFQ1VIK2xx?=
 =?utf-8?B?dUNkam5ObmNwYVltdmJpL1RLOTIwbitINFdZZDAzRDZVRkNPbWFZQTRpeW44?=
 =?utf-8?B?c3paMDR0RUZMV1ovYkxqQWJBeVZhZG1IWnl2SlNPZGsyYktuMVRGVHdnV0F1?=
 =?utf-8?B?eWV0VDUzUHBkMHJFazZLK3RVSWU1bUY0cmwyMGJYbkx2UWZ2eDlpOVEyNzJ1?=
 =?utf-8?B?aVl4dk5lRXU0WFVPVHcwTEwyU01XM3hpeXJrRXJMRHBheFQzQ2YvMHRhbzd4?=
 =?utf-8?B?YXJnUVFkdGVQRXFETjNieER4ajZXZmpNMkRjOGxCcjZPWVZzVTVaeUhPcXlH?=
 =?utf-8?B?RnFaREIzMkNyZitEOExoZVZnMWVXaHhIemxRbVdHY0NWSFJ1WVgxSzBHcFRG?=
 =?utf-8?B?SHh3VVRnWWw0SUF6cWNtV2xsNFYycEN0L0Q1OTk5OHhVRG5nY2hscEtwV0VU?=
 =?utf-8?B?ZUVYcEJ1S0ZIcVc2bDI2Q1lmLytDUnoyQ0hvb1RyOGZjamhVVFhCQTJ4YkEr?=
 =?utf-8?B?OHkzR3Y3OGZhemtKWENqM1FFNVlJMDQxeXBqTFZTUkNrYkN0UVdLWUF1bUNN?=
 =?utf-8?B?Y0xFenVkZHNHZDhKM2M4RGVUSlVJaFUwcGRMck85bHZzQUE4MkpqMkpVNVRR?=
 =?utf-8?B?U0pMd3NjdXgyYml2ZE44KzBIems0dUIrZU4zQjNOMi8rMEk4OVpNSmhiLzZ6?=
 =?utf-8?B?MzJIZ0sydUhuc1owdVVHcytPdzF1MnJMZExKdkJ1dVl4cVMwSkhLQkd3RkF6?=
 =?utf-8?B?WXVLNE5QZStmSnZQOWhFWkRocG5IemVhdm1jUUc2ODV5YlFWakZwYVU4bXhF?=
 =?utf-8?B?ZTFoZnNFUTlYUHU1akVZK2ZjV00wWW9wUFVYa3hkV1hnSHNRQWFiSStGY2M5?=
 =?utf-8?B?dENrMmsyTlo3ZjlkMFZVOFBrTmhtVEpGQmZtN3pnd3VUMnJjL2tpWDVuZGZs?=
 =?utf-8?B?QythVWo1TXJ5YXRkcmpyVEV1WWh1WkQyWlc0NWgwbHNQNklrKzdSUlhsV1FT?=
 =?utf-8?B?Uml3L3BFNUcwVzg5aFQ5UnN2eG93blp3TXRSbEY4dXBUNEt6UkhUeDNicHZO?=
 =?utf-8?B?MEdhQjgyT25idjhrTlRmdFRONUtUOCt3Z2xBYXovTm12ZjJrZ3BvTFVTUlIz?=
 =?utf-8?B?aEpWeGZCTnplcWZpaXhiR3dJc0l0SFB3VnozaUJOSVNrSk5wd1d4RnY3dm1P?=
 =?utf-8?B?UTlldk1pRmcrR2RHRGtBVE1BTTVTUko1M0NWZkNFMEJHU3JGZlpaNEh4a0Rw?=
 =?utf-8?B?d0hQaGR4M3VacmFwM0gzaEV1bTFlSW1ac2hoUklhUFUyRlJzVGZWcHIwK3Rh?=
 =?utf-8?B?ajFRYTcyWU9CRDlCa3ZYOWlhVHlCczVIY2FRQXBXOC9YcE1URHJJOTFqOFN4?=
 =?utf-8?B?Sm9kWDZXL3pnYmZOVnRtclZ5bEdmSW02VnR0dWxuMlhYdmp4N2RYT0VqaTJv?=
 =?utf-8?B?dHdRaGJQMzgzekdKMHZZejRSbkZxQlpwZVpHTk8veFZVd3g4RlZmZGo5aDFr?=
 =?utf-8?B?NUlnbHY3R0YzVUltcGoyZ3dIYUUxSXJrbStpcHJRWS9SNU94SW04cVJ5ckw3?=
 =?utf-8?B?bXJBNjB0L05xTU0zMDBULzd3Z2VoTFB1RmhRaGhRV2UyK3E1d3piMFpsc1Nm?=
 =?utf-8?B?NEs2MjNuc1k5aVhJWHNXWXNwdE8ra1k4bTVEUkRWeHlMNnBEUHFYRnBxbWZZ?=
 =?utf-8?B?S1NicUo2WVNLalVVcDJGdS9waVdZK0RXNWkrZnczZUtwdkxtekJpMm5rZHFz?=
 =?utf-8?B?RUk0YVhJM0RWYVowNXZjUFNmeldMSm5FOG05RkNyamdXWW53NEFPcWMzUncv?=
 =?utf-8?B?ZGRqWXA5N3BWejNENHB1TVNubFNXZHNYbU9BQjFIcm9VS0VneUMxazBhdTk1?=
 =?utf-8?B?bXF0T3VTaWdOWEhBSUZKenRzUlVjdERGUDdDSlpWOUtJMnFDOVBDaldpZ0hB?=
 =?utf-8?B?Y1N6aHl5TFpFMkVZcmhNZWRBai9naG5CNmd3QlpCdnhaZDJ1a09PUWlYdEll?=
 =?utf-8?Q?HR7FZ50aAZO3HRuoXfDzT+SgE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8886fe47-80c1-4f6b-0184-08dca01d447a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2024 13:44:34.6678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 94v8EefbYQJ1bVQUHqw9dEaVjHNXsnPmp2XsDDajSSK1wFmkOAjQ83SwzdFdYok341DG4kfgBxx0OsZPAjNxTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6178
X-OriginatorOrg: intel.com

On 2024/7/7 01:19, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=219010
> 
> --- Comment #1 from Žilvinas Žaltiena (zaltys@natrix.lt) ---
> Additional information: passing NVIDIA GPU, Samsung NVMEs works, passing Fresco
>   FL1100 based USB card does not work. Fresco card is single VF device, but like
> that sound card it does not report FLR. Reverting "vfio/pci: Collect hot-reset
> devices to local buffer" allows to pass every mentioned device.
> 

It appears that the count is used without init.. And it does not happen
with other devices as they have FLR, hence does not trigger the hotreset
info path. Please try below patch to see if it works.


 From 93618efe933c4fa5ec453bddacdf1ca2ccbf3751 Mon Sep 17 00:00:00 2001
From: Yi Liu <yi.l.liu@intel.com>
Date: Tue, 9 Jul 2024 06:41:02 -0700
Subject: [PATCH] vfio/pci: Fix a regresssion

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
  drivers/vfio/pci/vfio_pci_core.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c 
b/drivers/vfio/pci/vfio_pci_core.c
index 59af22f6f826..0a7bfdd08bc7 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1260,7 +1260,7 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
  	struct vfio_pci_hot_reset_info hdr;
  	struct vfio_pci_fill_info fill = {};
  	bool slot = false;
-	int ret, count;
+	int ret, count = 0;

  	if (copy_from_user(&hdr, arg, minsz))
  		return -EFAULT;
-- 
2.34.1


-- 
Regards,
Yi Liu

