Return-Path: <kvm+bounces-42986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B925A81D09
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 08:27:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B4688856F1
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 06:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420E71DDC15;
	Wed,  9 Apr 2025 06:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bec1547O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9633415A85E
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 06:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744180046; cv=fail; b=eZjLl4burw6KK0Hu2tV2xR1f8BFEQu26YRlq6pPMs5RKwk3ibZ6+bK/tOJz6JgCPD4jlpNWTuGJxH6amm5SSyTWR8hxyBi2ykok6+95FmQSskUpE/cuFHEFOB/oNnfsnBOZAFytwC5ngfemQBX4nx0eG9vGJUuGo1+JIe6Chu1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744180046; c=relaxed/simple;
	bh=XqT8RgHJupZqwxLZtmDYa4wxFh8j+HCVXnMB9BoZh8w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=V3e1L2kr7rPe07aCYPH6hul9Aop/aC9hVgwGW7QFsGIBBuh7e9GCUHIwk/Kr6Q1Pv0RTeflfnOg/Kj0WWa0979sEQHv3WhYKkZgiGDWtTI5rQEsZ4mDzSomRos2fM91bX6M3obxMleqimxFWf1/HG534O7bhVTJgmo7K74OuUSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bec1547O; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744180045; x=1775716045;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XqT8RgHJupZqwxLZtmDYa4wxFh8j+HCVXnMB9BoZh8w=;
  b=Bec1547OjxSuhFjZxyo5XG6aW0zJOLNJLlSyfuYthi2+NYdDSnd/boiA
   XifkaIhs7eorrKjC3J4EEk0HeTWf2LS/r6M1vFV+H3FfWzewfOP5wMRKr
   hMnDrIZr16AK9367mG5avIyge8mxXR6i67T/O+AtJDrRDsDgB/paMNH8T
   YxlpQQCqqT/FiPgd3xjpAXwRzoG25lPZLvcMFiVbFNQ+tEO/0/MzNTM+7
   KGnD1YY3uPcYrtdyLUG9bZObdsIwirvHgYYAyn8KyvCwLNMG/axlEsFKo
   pteKyI4DNtCTVDJh8HnmSQGpZVZjhh2J8S4kdl2Byq9tcJ53jYurxzJpc
   w==;
X-CSE-ConnectionGUID: rgoXXZHOQNGGZkQBD8cRLQ==
X-CSE-MsgGUID: yP3TkDCmS6WtMIZaYM60LQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="45521836"
X-IronPort-AV: E=Sophos;i="6.15,199,1739865600"; 
   d="scan'208";a="45521836"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2025 23:27:24 -0700
X-CSE-ConnectionGUID: JRcCDXWrSPSyP/Ua9NMJ9w==
X-CSE-MsgGUID: XDMo9KRCRV2xHjVoT8bV9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,199,1739865600"; 
   d="scan'208";a="159470417"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2025 23:27:23 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 8 Apr 2025 23:27:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 8 Apr 2025 23:27:23 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 8 Apr 2025 23:27:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jB2PWv0r+g/RRmELqcUVlMELin394B9hd9YcDDgTKC4oS1FZAWd1WmhIZ1/8sEsqiKmB56h7O4aG4s9aRwDOv1vG6GtQ1K4o0LnrTSC0aChSqTtK3zRefCp9rYppsNgsAMMaLxp8+abSV0FO3dj8XLupYQAWAupdlB5MBKzRAfkSBq+mVzNrHquFanecvxcSvIsTYV/BpwzYJVdQQvKwqTO5dEylZ5c7knTM8+VWUvUNXWjRhuqij9riTeLH7IX99suWxXHc4CIBfr4+WCPq1xdwHZ1u0MHTtZTYQgi9tisyBUpn+Pqd3gCqINoNC6SB2KMLjck/kKWyWe/E/HB0zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bpuf8hyAJy12g9+07PzMjxnhrZZX7ZPnY5l22uNxlSI=;
 b=Zt0tkriKQ3AGM5/TLTugMwX//YpiTsOzhm6EsiEfGT6EyBRGCQiQvlZodzgSk75kHdkr0lJ82FriGLNLxTCHzRE8OvpnJ2jw1nvHVdlnV6D75HGZKUBhL32PTj96VHO7MUsh3AcntocIsWNFOoIpwUjOKLNC+3xk1lPI5ZlpBXUC6oscIj83AwVSj4GotTeK/bN3MozFQGspRxfw2rPBQ9qEnSp8LjQrFV0VJXFQ/luDcPXR7MMTKmI5TAJxtJrl5tQbfg7zvBU1lv5mzcyl//GHT4w4Ks5niFwalJtSaXth6KTamiisAKDn35fwjkXfDjZ34WrS/AZcAEsbi5qKkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 BN9PR11MB5260.namprd11.prod.outlook.com (2603:10b6:408:135::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.21; Wed, 9 Apr 2025 06:27:07 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8606.033; Wed, 9 Apr 2025
 06:27:07 +0000
Message-ID: <47b04426-73c7-41d9-b7b7-ee2fa40886ae@intel.com>
Date: Wed, 9 Apr 2025 14:26:56 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/13] memory: Export a helper to get intersection of a
 MemoryRegionSection with a given range
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-2-chenyi.qiang@intel.com>
 <90152e8d-0af2-4735-b39a-8100cfb16d16@amd.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <90152e8d-0af2-4735-b39a-8100cfb16d16@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0100.apcprd02.prod.outlook.com
 (2603:1096:4:92::16) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|BN9PR11MB5260:EE_
X-MS-Office365-Filtering-Correlation-Id: 5596d480-02f7-4b2d-5dad-08dd772f8cee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Qm01M0s0MHd1MzZSdUh1N3RIVHFmYlcva2tTRWNoT1hFMmNJRGZSbVpuMk5K?=
 =?utf-8?B?cko2V1JTQXNicXBLdlhQY1JnN0V5UEhITCsvcEF3L0R0Q3FQdmlMWk5WNXYx?=
 =?utf-8?B?WldnVXNDMnFhMjFsZ1pMbTYyVXNUK2NXSHhJbG5ZT1VNRUlhQk1BR216OG50?=
 =?utf-8?B?ZnZFaXhsT1JJaGVCZHJ4RWNobUhwcjdQTlA0M2lLTDZFSEY0TDQxdFJmSEtn?=
 =?utf-8?B?dm1TbG5Mdk15VEpBVVlTREc5emRwR3M3V3RCUW1BbGVNRXRJU1ovQTN3cjZL?=
 =?utf-8?B?KzBLRE1OTjVXTnV1SkQvS28wVTRpQkZHUXRYekpCQ0tRdm92SDVLRzBWWTNR?=
 =?utf-8?B?OU9iY0VxRGxocWM4NnJQRzBjemc0NTRiSEkveVdiRTBrU3pGbDlod2dFM1Zh?=
 =?utf-8?B?UEZjcFJIVHNpVjQzc0dITEhJMWtuVVpndVdWZVZlejhWbkc0MlcyellaOU1z?=
 =?utf-8?B?SDQwNmdXRzdUWmpydWxXSTI1OFc5M2VkcHFyNXlBTUMzaVZoQkU3TnJILzBN?=
 =?utf-8?B?NzI4dWQwVGpINGtMQjZMSHhlalVtZ3VHeGpzemlhaFgrajRiUUVhdXl3Vmxr?=
 =?utf-8?B?SjF0bGRGTGhnaWpyeExhZGpZaHdPT0xaOXlpMC9VVktyMkZlYWNsSGtaWCtY?=
 =?utf-8?B?ZTJYd2FvMDNMU09IOFc0YUZnK0w0SlZrSGJubUY5cHkwY0E4OHE2Q3EzeEJj?=
 =?utf-8?B?OXFkN1VEZVFhNzNnLzdxbmdNWkZhcHZDYlc4anoxMVZVeFVMOFN1b01kdXYx?=
 =?utf-8?B?ZzlDMzY1K085VmF5M1dtREpJM1ltZ2dZL3MxN1dhUTVnbmhOVGpRbThiMzVI?=
 =?utf-8?B?eHhTaUp0YzlIL3ZWWEZMZUZiVEFqMXl1bzU1WUk1N1NubjV6T1F2dEJOcG1K?=
 =?utf-8?B?QWFPWC8yMjQyNjJhQ2p2S3dLNU15WmN5TFE5UHQxT0VDdk5uSENURStBdWtt?=
 =?utf-8?B?U1Z4UXdFTmhzbUN5d1Fwem9DUDkyZ0lkUWhSZUtxUmxBNkhueHVWRGladDU3?=
 =?utf-8?B?ZjdGOWFVZlZ6SzZyN2ZvMloxMlNlRFltYTNZR2ZNNGZCc2t0QkNUbWFHTWhN?=
 =?utf-8?B?VHhQL3ZzbTdWTmRUU2x5MVJFeXdzeGM3K0liYlVCdjcyUXdDYkJRRzdOTC9h?=
 =?utf-8?B?eTc1Rm0venp1c0Q5NGJTUDFtMDVkeDkwUG5YYmd3NHRneDI5aWFFSGRSdmZL?=
 =?utf-8?B?U20vVXZyRU84T243U0R3Q2N5ZS80WEY5NzBxS3hZV1hrK2dXRzJJOVg3Rk10?=
 =?utf-8?B?ZUZWUGZXa3hBT2I3cUZFQTRtWGpYZlJBVFVOOThCLzJ2ek1pQXAxZzI2UHNM?=
 =?utf-8?B?MkptdHZlSW9aWUhIZjVXalZlQmpkY3M0bDlGMFhBZFBqdEM3dWFreWRMMlM2?=
 =?utf-8?B?b1Nhb0NYbFErTkR2QWpENnFNZDB1cTRpQ1U4RGRsWFpiVmFoRlZkN01Cb250?=
 =?utf-8?B?SXg5UlZqUXM4NjBGZ2ljb25KWDlsa1d3Q0ZLekR5OEFvNmdhbUpvd042NE95?=
 =?utf-8?B?dlp0dkh5akZxTlZtaWhybXNjWFZlU3ZCNUJhSGUzdTM0c1Vqa3RNY0oxMlNG?=
 =?utf-8?B?cGU2MkZDZy9vMjZLd2NnbU9RZytNOHIvMFUwd1V0aGU1QmozT2pzeHdxdW5p?=
 =?utf-8?B?azRHdGdsRVFOd1lVQ1pGRW1lVjlNVFE0Z1RZNVVleDdaeWthenhaNXZ2Q0ZZ?=
 =?utf-8?B?dER6Z3UySTJzcjZySHQ5TFMxaEFrdGREZXhSZWpvd1NZSGlpNHZwK0hTbGgz?=
 =?utf-8?B?Yjh5M3k3MktwU1FGU3NMbVpJY1JyZzZ3OVJnemk3UkV6VEdRU21HbHlwb1h5?=
 =?utf-8?B?UEE5dURjSmgwZ0tTSTJxczMybUxBcytlSlVKRzNqZFJNVVZOakhJL3I5L1hi?=
 =?utf-8?Q?iVEfkwVIn6dt9?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkF1Y0RvME0yYVdBbTkvQVdFYlMwTG1vS1dtRUY3S0hWQ0pNLzdWOVprTlor?=
 =?utf-8?B?MVUwcGRzNnJ2TVJmUWVRcXdNdmhFa3UyUWVtM0R0YlVjY3QzTzQ3SXowN2tP?=
 =?utf-8?B?c050SjZSTzRCV3VFenFESTEwcEJOTVczbHRnOWtMaEdQTllDT05YQ1hNOEtq?=
 =?utf-8?B?SnB5T1h6OE5xb3UwT2VDcUtjVnFuWnR2b0piSUo5ZjRRa0kvQTJDaTVFeU5u?=
 =?utf-8?B?TFJnaWNkbUFiOXZjam5Ba2tUTzRIVEYxMktQYnNqUDQwS1BGWDVLUlBqV0hY?=
 =?utf-8?B?OUhITTVxdlhqL1NabDlBWm5HMHdaTTU4N3ZmbTNwY3h3N3ZvSC9Vb3JNa1kw?=
 =?utf-8?B?bHg3MlFLNDBJT0N6OWNhUTBYOEtkWDJSWDgxRlZMVFNWNUo3NGMzQzFaK0hQ?=
 =?utf-8?B?UTAzanNGL2VCdlJweDlFczVnK0NLbDVOckFNODdOS0ZJaVNyZ0pxd2taUW1w?=
 =?utf-8?B?d2hlNFBSWDRjWDhhY2NyQm1tOGxkNEMxSHpUVHh2NUZiU1NjdytQWHc4dFFn?=
 =?utf-8?B?U0IvMFVleWc2dVQydi9QY1FqbzZiRlZwNktUYS9JVUpkRkhrSncxSzRraWpv?=
 =?utf-8?B?ZWNjeG1MSm9uYm9ReWdqVUNXcm11ZHM1TWlTWHpBQzlpMTFqVndHdG8xNHVt?=
 =?utf-8?B?eHpIZGR4YzR2SVpYUnMveWhhWERWcGx3VDlVKy9mZ25kR1lHVnFMZGJBaTNX?=
 =?utf-8?B?SHBzb2JkNkdiR21XbEZaYW1lOUhMd1FCYkljVEVqYmxmdHdmbDdUWjRBMHBk?=
 =?utf-8?B?TXpuQkswa0hQT2dibDBHejRrOUF0eEVublBudW11eFEwd3M0cW15N2NRWExB?=
 =?utf-8?B?ZXBHakpXTEpCUElJL29qb2ZiYVRCVG9rK0JyY0FzN0thbHhsWTdEK0JUV3Y4?=
 =?utf-8?B?dmV6RjE2bkxGUStVRmJocW5Ea056dUVoTmo3Yld5blYybi9UQmdheUJORC8x?=
 =?utf-8?B?cVVLK0JNb01VZ2UySmJtd28xUnZ0RnpDUTZmeWpvVmZ5eDVVSmphOGoyVi9p?=
 =?utf-8?B?WVA4Vzd0SVBTdVhLeGY1YWN4TTR1bzl2cFplWENPN3NiWmt4TUZhZEFmOGNh?=
 =?utf-8?B?OVFBcUNDMXhzMWF2aXVaeVlFQ0VqcEkzQmswK3gxY2kwd0lFam1EbTJlckFW?=
 =?utf-8?B?bDhTSWZxb1M5aEF0UklPRmpNTUwwTkNDbFFnTy9nZUh2TVFMcjVZUjF3cldF?=
 =?utf-8?B?OS9yeXdSYW5XSERwL04zS0s5OWlDMWpaUzRJSWN5bko2enJZeFptTmExSU1B?=
 =?utf-8?B?b3l1Y2lzUVNIQUNBTFIyanBoUWZSdnNrYzFkL3p0N1RhbnROSEdhQVZSLys5?=
 =?utf-8?B?dXpOM2JBa1lRenowVVFicUVOTmhXY3BJZXU5dDBrZXhxN0tWZC9DN3dPWlBY?=
 =?utf-8?B?YVYxLzVNWFBHRkMyUDJ4SW5tbm45TmJoejNCL0x3VDIvZXhuY2tDbTVDTm1Y?=
 =?utf-8?B?VTlKTmV5bnlRSXQ5bktvY3o1Ym1XTkxkdHozQ3JKN3FPcnBmUnN6RFBBUExJ?=
 =?utf-8?B?YzVwTkI4TlFINStFdUwvSzQ1RUZDelRxQ3huakt0OHVIc3JEOTN5OWppNUh3?=
 =?utf-8?B?amdMMklxREtrRC9YS253eHZVblNCSThyN2xsUE1NZ05pVmlRSlV5WWVtd0xm?=
 =?utf-8?B?aDlwQ0hVOEFkU1dHM1BWMzlTZm4vSXhMVmJxNHh6ZElPYlVSZTMzdW52ZUd3?=
 =?utf-8?B?ejk4SlpmeUsrbDJLVjRBbEtURkg0ZWZqbkF2SXRtUE9yYmlIY1NWcm56Wkdj?=
 =?utf-8?B?K01MdERhekdmbEZBRGpMakZTcTNZTW9MaWcvcXZBYXpKbkhMd1FwR2xkSHkw?=
 =?utf-8?B?V1JwckduTHJGRzdoOGIxTU9GZTVEWEE5czhqUWRPc0E1RC9lYXNvenZyQmhk?=
 =?utf-8?B?S1JqWXkrbXcyRmVTNGJMTUZzUCtlRTJaSjFGRk9sRHdYQnRVdnZoNXl4UGpx?=
 =?utf-8?B?N3JDd0lIclkvSHFjYW93Wmc0QTRGOXlKQjR2U2hLb05EZlZPSGlVUktvTHpq?=
 =?utf-8?B?bkhKTUsvVkYwN1dwV1Q0NGpEUno5RFV6c0RLcVNocExubDQ2TGdpZzZ6eUxk?=
 =?utf-8?B?ZXFxOC9qNzBpTVBkbW9Gc0IxSVFkL1hKOFJlNk83SERiUmhXQ2VsRjFvNjV0?=
 =?utf-8?B?RG5JMHA0eWhoRXhvcHlYUTl1a3N0RjJiQnFYTUh0Tm1qemFybXJDSkMzcUp6?=
 =?utf-8?B?dVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5596d480-02f7-4b2d-5dad-08dd772f8cee
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 06:27:07.1321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P5JDLsD4YG2Rr2a74F/9w0TuOKJZGHIGCnnu+LVEoYkKxFDGZLH2UOM/FL5qf1NaXH5FTjRDQdLRYlITNcr5Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5260
X-OriginatorOrg: intel.com



On 4/9/2025 10:47 AM, Alexey Kardashevskiy wrote:
> 
> On 7/4/25 17:49, Chenyi Qiang wrote:
>> Rename the helper to memory_region_section_intersect_range() to make it
>> more generic. Meanwhile, define the @end as Int128 and replace the
>> related operations with Int128_* format since the helper is exported as
>> a wider API.
>>
>> Suggested-by: Alexey Kardashevskiy <aik@amd.com>
>> Reviewed-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> 
> ./scripts/checkpatch.pl complains "WARNING: line over 80 characters"
> 
> with that fixed,

I observed many places in QEMU ignore the WARNING for over 80
characters, so I also ignored them in my series.

After checking the rule in docs/devel/style.rst, I think I should try
best to make it not longer than 80. But if it is hard to do so due to
long function or symbol names, it is acceptable to not wrap it.

Then, I would modify the first warning code. For the latter two
warnings, see code below

> 
> Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
> 
>> ---
>> Changes in v4:
>>      - No change.
>>
>> Changes in v3:
>>      - No change
>>
>> Changes in v2:
>>      - Make memory_region_section_intersect_range() an inline function.
>>      - Add Reviewed-by from David
>>      - Define the @end as Int128 and use the related Int128_* ops as a
>> wilder
>>        API (Alexey)
>> ---
>>   hw/virtio/virtio-mem.c | 32 +++++---------------------------
>>   include/exec/memory.h  | 27 +++++++++++++++++++++++++++
>>   2 files changed, 32 insertions(+), 27 deletions(-)
>>
>> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
>> index b1a003736b..21f16e4912 100644
>> --- a/hw/virtio/virtio-mem.c
>> +++ b/hw/virtio/virtio-mem.c
>> @@ -244,28 +244,6 @@ static int
>> virtio_mem_for_each_plugged_range(VirtIOMEM *vmem, void *arg,
>>       return ret;
>>   }
>>   -/*
>> - * Adjust the memory section to cover the intersection with the given
>> range.
>> - *
>> - * Returns false if the intersection is empty, otherwise returns true.
>> - */
>> -static bool virtio_mem_intersect_memory_section(MemoryRegionSection *s,
>> -                                                uint64_t offset,
>> uint64_t size)
>> -{
>> -    uint64_t start = MAX(s->offset_within_region, offset);
>> -    uint64_t end = MIN(s->offset_within_region + int128_get64(s->size),
>> -                       offset + size);
>> -
>> -    if (end <= start) {
>> -        return false;
>> -    }
>> -
>> -    s->offset_within_address_space += start - s->offset_within_region;
>> -    s->offset_within_region = start;
>> -    s->size = int128_make64(end - start);
>> -    return true;
>> -}
>> -
>>   typedef int (*virtio_mem_section_cb)(MemoryRegionSection *s, void
>> *arg);
>>     static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
>> @@ -287,7 +265,7 @@ static int
>> virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
>>                                         first_bit + 1) - 1;
>>           size = (last_bit - first_bit + 1) * vmem->block_size;
>>   -        if (!virtio_mem_intersect_memory_section(&tmp, offset,
>> size)) {
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>>               break;
>>           }
>>           ret = cb(&tmp, arg);
>> @@ -319,7 +297,7 @@ static int
>> virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
>>                                    first_bit + 1) - 1;
>>           size = (last_bit - first_bit + 1) * vmem->block_size;
>>   -        if (!virtio_mem_intersect_memory_section(&tmp, offset,
>> size)) {
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>>               break;
>>           }
>>           ret = cb(&tmp, arg);
>> @@ -355,7 +333,7 @@ static void virtio_mem_notify_unplug(VirtIOMEM
>> *vmem, uint64_t offset,
>>       QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
>>           MemoryRegionSection tmp = *rdl->section;
>>   -        if (!virtio_mem_intersect_memory_section(&tmp, offset,
>> size)) {
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>>               continue;
>>           }
>>           rdl->notify_discard(rdl, &tmp);
>> @@ -371,7 +349,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem,
>> uint64_t offset,
>>       QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
>>           MemoryRegionSection tmp = *rdl->section;
>>   -        if (!virtio_mem_intersect_memory_section(&tmp, offset,
>> size)) {
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>>               continue;
>>           }
>>           ret = rdl->notify_populate(rdl, &tmp);
>> @@ -388,7 +366,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem,
>> uint64_t offset,
>>               if (rdl2 == rdl) {
>>                   break;
>>               }
>> -            if (!virtio_mem_intersect_memory_section(&tmp, offset,
>> size)) {
>> +            if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>>                   continue;
>>               }
>>               rdl2->notify_discard(rdl2, &tmp);
>> diff --git a/include/exec/memory.h b/include/exec/memory.h
>> index 3ee1901b52..3bebc43d59 100644
>> --- a/include/exec/memory.h
>> +++ b/include/exec/memory.h
>> @@ -1202,6 +1202,33 @@ MemoryRegionSection
>> *memory_region_section_new_copy(MemoryRegionSection *s);
>>    */
>>   void memory_region_section_free_copy(MemoryRegionSection *s);
>>   +/**
>> + * memory_region_section_intersect_range: Adjust the memory section
>> to cover
>> + * the intersection with the given range.
>> + *
>> + * @s: the #MemoryRegionSection to be adjusted
>> + * @offset: the offset of the given range in the memory region
>> + * @size: the size of the given range
>> + *
>> + * Returns false if the intersection is empty, otherwise returns true.
>> + */
>> +static inline bool
>> memory_region_section_intersect_range(MemoryRegionSection *s,
>> +                                                         uint64_t
>> offset, uint64_t size)
>> +{
>> +    uint64_t start = MAX(s->offset_within_region, offset);
>> +    Int128 end = int128_min(int128_add(int128_make64(s-
>> >offset_within_region), s->size),
>> +                            int128_add(int128_make64(offset),
>> int128_make64(size)));

The Int128_* format helper make the line over 80. I think it's better
not wrap it for readability.

>> +
>> +    if (int128_le(end, int128_make64(start))) {
>> +        return false;
>> +    }
>> +
>> +    s->offset_within_address_space += start - s->offset_within_region;
>> +    s->offset_within_region = start;
>> +    s->size = int128_sub(end, int128_make64(start));
>> +    return true;
>> +}
>> +
>>   /**
>>    * memory_region_init: Initialize a memory region
>>    *
> 


