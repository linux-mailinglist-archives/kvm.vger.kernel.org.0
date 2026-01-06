Return-Path: <kvm+bounces-67135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 598E7CF7DB0
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:47:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E81F830390ED
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:46:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B550733A71A;
	Tue,  6 Jan 2026 10:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Awl+nJhG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A8A33A03D;
	Tue,  6 Jan 2026 10:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767695972; cv=fail; b=YfB/FJv+oow7+5XybNzCA6Kuxsxx2Y5KpB7slNyjpWeE5ksnHO4u2sGsWRvewWLKSoHxH+XcJK4TOZ3ZXR6vxmtzigRF1wlyRRweE4z/IypVEQzH7sy6/piQFOmzSdapWlv03UA4Lutn7Q8xzHsDHtuXKkOcN2vtBhgkNHE1avY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767695972; c=relaxed/simple;
	bh=J1UC8lJtlqvoc1Pi9OJtLC3OshImvwxG+a5uVBXTiuA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iMo1KRrBuOTvT+sbHKx3lw/3DRNp1UMysYwHmnwnpIXuFEy+S7aZK2dSSr2N/6lrNgB/hC4cOpgfC1sspJ0p9OyWBICX5+klcuytRnQ2oC8q2ulvTaq5n+tCJykbxMEY5G+WKODbl8Y1X2wOIqmjpZbVxgikK7u9jtNyptMpDJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Awl+nJhG; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767695972; x=1799231972;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=J1UC8lJtlqvoc1Pi9OJtLC3OshImvwxG+a5uVBXTiuA=;
  b=Awl+nJhGF8HYV9R1UPSspkFW3HVMO5uanz6e+SJ0gMavJkev7b2ke7nB
   Lzulbbe/qA2HOIi4GQ9FG3BVBYvAAv9hkCiWkLhfZyFDPTlRJlGyizpES
   7/I4NIhenCp7QfKuzjgzSQZt9Ye9K6VxONtkTxAKlkn2EmcFz385sr05J
   Ddv+MrHVKSOsTgoBwwUR/45LDcgmZlrAqbGa3FNgpQk3v6G2mtgkfy4ag
   T1A+u0bay/WE9tzov6CBEDec9CXntXF29FVRCx04iySxFMS40JDtIHFTS
   wtKVmjPABbufS7InW5lYmEnoM5ZHAyPfOcBSXxnDwnK5lyBASmy+c2vAC
   g==;
X-CSE-ConnectionGUID: NrBAWLclQwq/Tf0Py8Mheg==
X-CSE-MsgGUID: m6nDnCKoRIeUzYDcxoZzvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="68802951"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="68802951"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:39:31 -0800
X-CSE-ConnectionGUID: /iydLBTxSWGDw66XOiA2ww==
X-CSE-MsgGUID: s7BU+uKASfG0hZCvI5fKhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="201757608"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:39:31 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 02:39:30 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 6 Jan 2026 02:39:30 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.22) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 02:39:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vOm5+dIS2W0oTo7AXZ12Ymh0Wk2fB4wkhwBO+OyvHfM5+j3wOJxOLoRh1aZs+65r6KGUFck9JK66T6fgsFiNRRUyY1JulO2LKh67RlstpkhYnyaM0FBPT0KRBTQs5925UgHLxGCLzd7WwfAIbAjZd7o4SX9dLJj5tZGgzFefEy0UyCnc+q5bxazKfRxvLrzHDdnxE15JKtrNhDbAPs9Sflh8UgXUes1YouNLGwG6F/Hmd6gZh2Z+DXfXdb50FyWnZd6gNXAzoibBvJILsbts1etbxii0bfbHx74ctbRQgf3T1iJR6T2NrtPnmL6Go6Cum0/P9MZ6uDwPFHZa6I0SHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hQhQhRrJULUK5cLIk0gbs1nV8XypWagejkrHEipRen4=;
 b=Eb78sJSArV0XQ94kNiBUOh+bIuhc1h80+SMQPLDY4N661HF+Hfk2wo5T0QQsmn++BN2drWg0QRs/QToSsJKDoLam4YdBRTV1Yy2gHi8mdm6h99g+aM7rDENVtaGI9KmAxgOs6lKTCiY5y+c2xsfBttjsQiFsEukqbJWY7jOgTaF1k7x+6Y/S0eXZiQXMt6EhrsvuK7COTzMLMewO9iGfHQjhxg43fhH2/PO2ZDpUxCSXJ67ctvqQZlcsnN+bN9b+6AvPXSHbcCr965IjzBa52/uAh9rzPK5gKPpdLUm2vtw5TnuqWO6wJlNCVlEg0TrlrhoyjmspaVLmsrbkyV0P2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6200.namprd11.prod.outlook.com (2603:10b6:8:98::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4; Tue, 6 Jan 2026 10:39:26 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 10:39:26 +0000
Date: Tue, 6 Jan 2026 18:37:20 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <ackerleytng@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vbabka@suse.cz>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <zhiquan1.li@intel.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 03/23] x86/tdx: Enhance
 tdh_phymem_page_wbinvd_hkid() to invalidate huge pages
Message-ID: <aVzl4Pa34I/uo1pU@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094202.4481-1-yan.y.zhao@intel.com>
 <CAGtprH8zEKcyx_i7PRWd-fXWeuc+sDw7rMr1=zpgkbT-sfS6YA@mail.gmail.com>
 <aTjKV/hAEO4odtDQ@yzhao56-desk.sh.intel.com>
 <CAGtprH9foQx=XLXXMqYnga27jWjCSkqj5QHVnAM_Akv7CLNmbw@mail.gmail.com>
 <aTjS/c8c5wNZcSgO@yzhao56-desk.sh.intel.com>
 <CAGtprH9vdpAGDNtzje=7faHBQc9qTSF2fUEGcbCkfJehFuP-rw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH9vdpAGDNtzje=7faHBQc9qTSF2fUEGcbCkfJehFuP-rw@mail.gmail.com>
X-ClientProxiedBy: TPYP295CA0005.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:9::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6200:EE_
X-MS-Office365-Filtering-Correlation-Id: 507fe1ab-aced-43f5-1c37-08de4d0fdd31
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eStqM01ZRk5PUDZSK0I4S0x3UDY5eFg5Z3ZCOHFVSkM4STBhVTZKSmtTM01l?=
 =?utf-8?B?Q2o1YTVFMHNxVzBZTUo3bXFiQThJTXBMZTA4NXVBcHFreVduTUt4cWtlSTVX?=
 =?utf-8?B?YkpVTHNQOHM4Wk9wTVNxR25WOTFTN28wWnlwMmNmWHh6ckkrSGlaVGtOVHIw?=
 =?utf-8?B?dEs1TTh1WkNrQXhOZE55L3VhL1ByRUlrZFl6WFg1ejRtSDNPUnR0b3d1Z3h1?=
 =?utf-8?B?eU5CM0RFaGVWRkNKZXJQV0I1VGNrM0xkYng2WmNjOVRkTy9KNHVEZ1dTMkYv?=
 =?utf-8?B?U3Q1UmFGL2ExNDZLR0pPY3VXa2NIVkgybGpRRlZ0R01tczZnejdlZ1h1RzJt?=
 =?utf-8?B?a0pmT1RTa0hyUlJKZTRIRjV2MnlLanVvQlNPNTVJak5KUlY3OVYwNDBwZndr?=
 =?utf-8?B?RXdpS1krZWZ0ZkxEbFgyT3N5b2JpWDlsMTFvc2xqWUp4cllDQ3FFSUIwZEpZ?=
 =?utf-8?B?VFhheWk2cjZHSjVubDlWWW1HY21EOUcwM05lYUVSck1NYmtMVlJKMlM3Vm5C?=
 =?utf-8?B?NjVzNUc1SUdmMkI2Rk44RmpHcnB6QXJrcVdrbW15MS91eDNZeTVLc2J0akpj?=
 =?utf-8?B?NGJFNE9qcFVma3Fldk5qRTRBWkZrYXd1WTc4N1k0eGtXeUJRYVZaS0hOLzhL?=
 =?utf-8?B?MHFMWnYxQkF6bkRmR1VDMGpEYjJvcWdta21jMkg4Z3U0UjZrZWVYOWFTVVNo?=
 =?utf-8?B?clpBZ050cEpKSjJQNnRocUJvUUhvMDNyRnQ3WENzT3JMYkFhaDJlR1pBSVdz?=
 =?utf-8?B?eFExbllSZnBuY0RTL2p0VmJsZDQ2S3krOEZqWHVPU3JadDEzOFJmVEJrQmE1?=
 =?utf-8?B?UXl5ZDR3UmQzNzVobHFnWW5OMDJCR1hOc2krMUxBY041Y3ZWdXF5eUxyTUtC?=
 =?utf-8?B?a2p3V05WSDMzbGpOUStqQlIrNTA1ekFRQkllZE85Uy9ZVTU2QXE5MnVhMUxH?=
 =?utf-8?B?UzFIcXdvS3NWRHE0OStaRDZ3S3JYTE1sSGNQS0JWU0RyTjRjZUZQcFlCRU1G?=
 =?utf-8?B?V1Z2VEtlN01BSGYrQWNqcng3OVNybmlZOFc3c0JlN0JwRTloMGJYNFRqSE5G?=
 =?utf-8?B?ZlhPMXRhN3BzZTh0NFljLytTTlk3OXgzNmw4bHBENElXdkNvd3VnQS91b2Jp?=
 =?utf-8?B?b090QWxSODdLR2lubkZsaFJkYUxZYnJ1K3pYNWEvcVY0QWpXN2w4ZmxMQm9w?=
 =?utf-8?B?U2UyYnBzSW9kQzNWaHFMVEEzWWtidm5JMmo5TUE5RnpYUXFkZEthQjRhQnJh?=
 =?utf-8?B?dGpxWmZzQXFUb25Ia0RrVW5IWGtLNnBwUVA5TTJtNU5ZRGNqWEFtclRETC9r?=
 =?utf-8?B?alU0dEQ2QkZLVU52L3JHcnZuNWtIQTllbDhNU0t2eTdURE1hWEpyN25rSDVs?=
 =?utf-8?B?NEN1L3NRblhCT2lvWkxjZnpFRVpZcnBlWmNxR1RuRmhDclBKaGI3dkZIUURw?=
 =?utf-8?B?dzRXVG1UMWpHcXMxQXc5cVF5anI0em9SQyswVGlyQkZXcHQ0dkZiUzlNaGht?=
 =?utf-8?B?V0tHdWRETU9yUUErTVdIZW5EN1VDSnUwblFuc1JGMUc4MFYrMjhNWHNQYmd2?=
 =?utf-8?B?R08yeHJJVHBZby9qSmFoMUFJQWN5WkdEQy9GZSsrM2ZQK2FreDN1QTg1Rk5W?=
 =?utf-8?B?U3J5QWNTQk43V0l4Q0lESlJCTisyUzh3R2UrZG9nY0pPVHdlSVJMck9lSmhh?=
 =?utf-8?B?OThsdm9UQzFMRndUdWYzSlV4UW5XL1lxNlp3aGpjVzFqaXdGT2gyQndzNlk3?=
 =?utf-8?B?a3VBb2hDUzYxQi9QS0NSVlIxRjY4VEhrMEtueEdOTzdjSFhERWFNS0c5bFlK?=
 =?utf-8?B?QUxMdVo0a3RZYmNUSUs4dTZyTnk1NHFGU2s1RVVMRzlham10M2d3eUs5Q2Zt?=
 =?utf-8?B?UFdxeWQxUFkwcHI5SFc5WmhjTUJzcXhybHJXMmlYbzNXQzFQZmVHd2tQMWln?=
 =?utf-8?B?cVh1RGpXY2NtMmd3cEZML0FYbnNLRERvRThoMHJFSkFNeFNzV25YZnZtOFRR?=
 =?utf-8?B?Zm9WaXZxaWZ3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3ByNzd2VUxnVVdxeFIxMkxrZGxUQjFMVFU0QXdlV3ZVV2NhMkQ4MnozSkIv?=
 =?utf-8?B?clJ5MVZKWXRibW94S0I3VHo5Risvbnd0elh4REI1RFZqNDNPcVhkTFM0MDhS?=
 =?utf-8?B?UTBneElFckQyWGtFb1Y1MGFveVJXU2RnYVFYNnhLQ3R1Ukt5TG1yVFMxQnlK?=
 =?utf-8?B?NnFweWhCM1RTTUx0NXpaL3FTSnovZkxNSndOY1d1SU1FR09lblh5YzVVZDg2?=
 =?utf-8?B?V0VpaDJvQTRMbDV5Y0hFa25rZ1JwTkNvZWZLdjZkRFUwWXZjY205NHNiTXFy?=
 =?utf-8?B?OVY1K0IzWjdxVXNlT3B0QStWTDdrdm5kTThSY2JsRFNiczNpbzN1SGZ0SkpF?=
 =?utf-8?B?ZjVValpGOUV6YjlrZ2ZpdjBHRjUrSDJCUE1tVFN1c3BnVTV3OEpxT3dZRk55?=
 =?utf-8?B?OXFjckRmT09TTGxDSHpNYkJmL1VuVjRNdStLRkRuY2pSbUFNV3RKZVlzRTRZ?=
 =?utf-8?B?VURObS9zTWNXa2x4ckhIR1QxNTNDdUlOK25ZdldLRWlhNXN4cWdZQ3UwMW5M?=
 =?utf-8?B?b2s5WXoyK1BpdHU5SVAxQWlQbUpZQjkzakNUOENxZC9QNVdOTGIrWFEwMi9u?=
 =?utf-8?B?b0NmZnFLV3ZYZXloc3BCOHFzNDhsN3lBRDdJVWZwdFBrSThCQSt1R3R5bjFT?=
 =?utf-8?B?azRpQWYvK282M1p0WUg0bGFQdUpRTXY3RnNDVWFLWHNqOFU4VGpEZEtqalhj?=
 =?utf-8?B?eEREd1N3TWgrMkY2Y1UvdFowZEZoVlJqQjIveDdYbEVwU2E1MEdtU2xOb0M2?=
 =?utf-8?B?Tld3YUN1OUtvb2JYSGZvRnhicDc1Qk82dkdkZjJ6OE1EMFVySnRlbXlsVC9a?=
 =?utf-8?B?UExvT3BSeVYzeDlESTVLRUVDU2FjU2VBZWNMZnVUdG9GbStBSjNuMGJCbGFp?=
 =?utf-8?B?Q0MzamJvZVFBcFRBNm90NWV5RzE4OHFaL3l3OG9LSWNuL1EvL0lieVkwWEp2?=
 =?utf-8?B?WmFmYk5uWU83V0Zob1MwZjhMM3Npb1NXUU0yWjRuTzZKN05rNEpsNHJFd1BB?=
 =?utf-8?B?TjdSRktDUU1HRis3Tm9FNFpKVC9CNVhSNGJHUWRQdVBUQ05lZEpWMEU0dnZB?=
 =?utf-8?B?YVJxeGlIKzN3NnpBQm40VUx4QUpEMXIrRi9xRVhCVGRmNTFYNnNJMzZHeUIx?=
 =?utf-8?B?OWU2S2lLS2U1cVIweUNHM0JCZ0czZHI0dnBRblpNNGR0a3p0d3dkazR0b1dv?=
 =?utf-8?B?S0YzY053ZTI2L0lvaHBVaU5pcVVxYit5dXZHR2hsQTI4Z1BpTUlVNFZFV1NH?=
 =?utf-8?B?eEZVZExBd3MyTzVBSUtXYWI2SlJVNHlxQnkrRURoK3RJcGYyVWxJRUFXaUsx?=
 =?utf-8?B?Rm5idU9reGhxejVPaEdkNWdqd3p1MW5uUm1YU2ErV0NqVVJJaXRTUGlnbFRs?=
 =?utf-8?B?ekMvTnNZVnoyYUlxckwrNWRlWFNwYjhDZ1ovWGxYZHdQZUNiMk5WQjY4VVlX?=
 =?utf-8?B?ZDdwUFFQQmIvSi9aV1RWL2E3b0JpUHFOa1l1dzh0ekt1RGthc0UvTUJMdXJ3?=
 =?utf-8?B?UHlDOVFzNVRuOUF4Q3VMYUVhVW5ZTnp0OHNYdkM3SWMvQWI3YkpmR0RVOFly?=
 =?utf-8?B?bDNTcnYxMjhpWGJkV05wNVRIOGtNZzVTVXpiM2xnYmo1RnFOeFlzdzBhWEhi?=
 =?utf-8?B?b3RMTjdDVlE3dWZxLzhtQjZwTWlIeGppRUhSdEdrUjE5eGo4YUFnc3Q3LzAv?=
 =?utf-8?B?R3E0QnlNWDJ6VmN6UkJRWjM2N2FCQXdmSXRvNGRyNXp0R2ZnYVN0YVNNNktu?=
 =?utf-8?B?U2RrTFBmb0dhT0J3ZGM0MEE4cXJTRWNETC81Wm5Ec3lYZ3doL1FpenNpTmpo?=
 =?utf-8?B?dDNHQ3JORzBsSnFreUJOaFBua245ZGxuOUNkbW5rYzA2NlNlSFJXKzlrRDN1?=
 =?utf-8?B?NElpZkhmb1RZdkV1azJOelJCSXkvTGNGUkpZMXc2UWNDR3N5SWZCU2JqU1Z5?=
 =?utf-8?B?c2lhekZnUGo5Tktpb0dLRHNUSFRuZGkwdlhOak9rY3VEUFo1L0F5bVpEOWwv?=
 =?utf-8?B?K0ZaQXNFUm9oZVg0VVJIR1FFd1NxdVhEdmkwOWlOZTNhUDZRWmpQZFFGaGhK?=
 =?utf-8?B?Q1JKZDRDR1hDVkRUd3RYSkJoY0x6ZmhZa21RNHRYN2VvN1d4RlpFNE0za1JK?=
 =?utf-8?B?aHRYQWRHTG0vQlhTeitRbjhtNE9URkRvbmZRbzhTck4xU05lMGd6UHFFakFG?=
 =?utf-8?B?R0IvTzhVY2JHQXlpMzRKRmkxUW9rdndBZlBrT2hldEJLejNBYWRKVjE1RkRC?=
 =?utf-8?B?VGJEZnJTZ3NtNTVoUHFhRytwcFdyZGNzQ0RkemtEdXFZQXdKTEVWNkZ4blNq?=
 =?utf-8?B?K21tVWFwODZSVVFJZk5jQmQ2OENFMno3TGtxb3hoZDkxcXNrY2VmQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 507fe1ab-aced-43f5-1c37-08de4d0fdd31
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 10:39:26.6117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jhMyNTCAEJZTaIQUR1eh2rCET2mX6fEr5giFD5g/xqL8C8w6Sg/XfNbQeV/CP4hS9PxdQMPqrm+/A8Hm0U0dxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6200
X-OriginatorOrg: intel.com

On Wed, Dec 31, 2025 at 11:37:26AM -0800, Vishal Annapurve wrote:
> On Tue, Dec 9, 2025 at 5:57 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Tue, Dec 09, 2025 at 05:30:54PM -0800, Vishal Annapurve wrote:
> > > On Tue, Dec 9, 2025 at 5:20 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >
> > > > On Tue, Dec 09, 2025 at 05:14:22PM -0800, Vishal Annapurve wrote:
> > > > > On Thu, Aug 7, 2025 at 2:42 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > >
> > > > > > index 0a2b183899d8..8eaf8431c5f1 100644
> > > > > > --- a/arch/x86/kvm/vmx/tdx.c
> > > > > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > > > > @@ -1694,6 +1694,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> > > > > >  {
> > > > > >         int tdx_level = pg_level_to_tdx_sept_level(level);
> > > > > >         struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > > > > > +       struct folio *folio = page_folio(page);
> > > > > >         gpa_t gpa = gfn_to_gpa(gfn);
> > > > > >         u64 err, entry, level_state;
> > > > > >
> > > > > > @@ -1728,8 +1729,9 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> > > > > >                 return -EIO;
> > > > > >         }
> > > > > >
> > > > > > -       err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
> > > > > > -
> > > > > > +       err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, folio,
> > > > > > +                                         folio_page_idx(folio, page),
> > > > > > +                                         KVM_PAGES_PER_HPAGE(level));
> > > > >
> > > > > This code seems to assume that folio_order() always matches the level
> > > > > at which it is mapped in the EPT entries.
> > > > I don't think so.
> > > > Please check the implemenation of tdh_phymem_page_wbinvd_hkid() [1].
> > > > Only npages=KVM_PAGES_PER_HPAGE(level) will be invalidated, while npages
> > > > <= folio_nr_pages(folio).
> > >
> > > Is the gfn passed to tdx_sept_drop_private_spte() always huge page
> > > aligned if mapping is at huge page granularity?
> > Yes.
> > The GFN passed to tdx_sept_set_private_spte() is huge page aligned in
> > kvm_tdp_mmu_map(). SEAMCALL TDH_MEM_PAGE_AUG will also fail otherwise.
> > The GFN passed to tdx_sept_remove_private_spte() comes from the same mapping
> > entry in the mirror EPT.
> >
> > > If gfn/pfn is not aligned then when folio is split to 4K, page_folio()
> > > will return the same page and folio_order and folio_page_idx() will be
> > > zero. This can cause tdh_phymem_page_wbinvd_hkid() to return failure.
> > >
> > > If the expectation is that page_folio() will always point to a head
> > > page for given hugepage granularity mapping then that logic will not
> > > work correctly IMO.
> > The current logic is that:
> > 1. tdh_mem_page_aug() maps physical memory starting from the page at "start_idx"
> >    within a "folio" and spanning "npages" contiguous PFNs.
> >    (npages corresponds to the mapping level KVM_PAGES_PER_HPAGE(level)).
> >    e.g. it can map at level 2MB, starting from the 4MB offset in a folio of
> >    order 1GB.
> >
> > 2. if split occurs, the huge 2MB mapping will be split into 4KB ones, while the
> >    underlying folio remains 1GB.
> 
> Private to shared conversion flow discussed so far [1][2][3]:
> 1) Preallocate maple tree entries needed for conversion
> 2) Split filemap range being converted to 4K pages
> 3) Mark KVM MMU invalidation begin for the huge page aligned range
> 4) Zap KVM MMU entries for the converted range
> 5) Update maple tree entries to carry final attributes
> 6) Mark KVM MMU invalidation end for huge page aligned range
> 
> Possible addition of splitting cross boundary leafs with the above flow:
> 1) Preallocate maple tree entries needed for conversion
> 2) Split filemap range being converted to 4K pages
> 3) Mark KVM MMU invalidation begin for the huge page aligned range
> 4) Split KVM MMU private boundary leafs for converted range
> 5) Zap KVM MMU entries for the converted range
> 6) Update maple tree entries to carry final attributes
> 7) Mark KVM MMU invalidation end for huge page aligned range
> 
> Note that in both the above flows KVM MMU entries will get zapped
> after folio is split to 4K i.e. when tdx_sept_remove_private_spte()
> happens folio will be split but the EPT entry level will still be 2M
> and the assumption of EPT entries always being subset of folios will
> not hold true.
> 
> I think things might be simplified if KVM TDX stack always operates on
> the pages without assuming ranges being covered by "folios".
Let's discuss that in v3 series
https://lore.kernel.org/all/20260106101646.24809-1-yan.y.zhao@intel.com/

> [1] https://lore.kernel.org/kvm/aN8P87AXlxlEDdpP@google.com/
> [2] https://lore.kernel.org/kvm/diqzzf8oazh4.fsf@google.com/
> [3] https://github.com/googleprodkernel/linux-cc/blob/9ee2bd65cc9b63c871f8f49d217a7a70576a942d/virt/kvm/guest_memfd.c#L894
> 
> >    e.g. now the 0th 4KB mapping after split points to the 4MB offset in the
> >    1GB folio, and the 1st 4KB mapping points to the 4MB+4KB offset...
> >    The mapping level after split is 4KB.
> >
> > 3. tdx_sept_remove_private_spte() invokes tdh_mem_page_remove() and
> >    tdh_phymem_page_wbinvd_hkid().
> >    -The GFN is 2MB aligned and level is 2MB if split does not occur or
> >    -The GFN is 4KB aligned and level is 4KB if split has occurred.
> >    While the underlying folio remains 1GB, the folio_page_idx(folio, page)
> >    specifies the offset in the folio, and the npages corresponding to
> >    the mapping level is <= folio_nr_pages(folio).
> >
> >
> > > > [1] https://lore.kernel.org/all/20250807094202.4481-1-yan.y.zhao@intel.com/
> > > >
> > > > > IIUC guest_memfd can decide
> > > > > to split folios to 4K for the complete huge folio before zapping the
> > > > > hugepage EPT mappings. I think it's better to just round the pfn to
> > > > > the hugepage address based on the level they were mapped at instead of
> > > > > relying on the folio order.

