Return-Path: <kvm+bounces-35349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A49DDA100EF
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 07:46:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29C08167881
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 06:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DD5224633C;
	Tue, 14 Jan 2025 06:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HkNnHzUP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0ACD23D3F5
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 06:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837156; cv=fail; b=kL4MHdnl5EkTO3GSc24sWRmHtnmI/LO64/fxyt9/8fr6wFZGopN0jUOTDH5r3tqJsBceNRpFP8/V8RZRgPdyuTiqnYhPJfCiD0ToCP5kCoyRUL0vXL4MhyE2o8+hzqQIUIhEmBGY5mfR0K/YmwKQalf54Ez4Zh4z23Qq35ELA50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837156; c=relaxed/simple;
	bh=Rxx5KbcqqxZ2yDnx79N1zLPkBX4D+Aph97HIx/6b/Tg=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NWctZJfOCpQ1PRAvB7vVI5ztAXseavgmfqwMBUvYQgY4WvjabmK2qQcJ5/g5Lys6zfEkSoHNW2H9KoCNSa+ZL5SmJK4oIcXrJXXngpW6Wd/PDnxuL82ST8PfLwqsJbCf1qGnvQfxyVzecjU+dgDjM2mMkkn+zMNov613N9WGNX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HkNnHzUP; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736837155; x=1768373155;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Rxx5KbcqqxZ2yDnx79N1zLPkBX4D+Aph97HIx/6b/Tg=;
  b=HkNnHzUPKjQHJE7JqmpKZbraeLd/nQg+/Ql0NR7R2YlOi0H4RuenT048
   7qm/PBZ7dQGF12gWSiK45MNlIt0sE0LgCKDtOiW50CMPof3LsGZjb46U+
   slyC23vbluiJzn4OFi/CN+QSlzKtHtoPy7MTIP9QJmBRf2FGkMS4Xa70J
   IE4cRrzQMSWbgnPVxIB81h0KNQjMDYnh/uR5BMM9tUGzEak6TsxVXSmGh
   VAJCaxE5yeXBurOA8lIKnBC3ft7LCb+NTjFJxbtFR59KlCp9rfKfnmcTc
   VF09+I+CKbOhJQ0C9DutYe3HOi59a2dsxfJtALngebR1R3DHFjPvzHCYy
   g==;
X-CSE-ConnectionGUID: l2os9OL4RWCQesXxfL/y0A==
X-CSE-MsgGUID: 5aqqx3WkSlaaw0eTVysowA==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="36812245"
X-IronPort-AV: E=Sophos;i="6.12,313,1728975600"; 
   d="scan'208";a="36812245"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 22:45:54 -0800
X-CSE-ConnectionGUID: nlKz8z4NQ5+7Txp1ifqcjQ==
X-CSE-MsgGUID: fqVZZ9HzQvSYtY3zDsn4sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="135587872"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Jan 2025 22:45:52 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 13 Jan 2025 22:45:51 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 13 Jan 2025 22:45:51 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 13 Jan 2025 22:45:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J631G+zPUTAhhGPttTga+lHXvclWLJIfJeSFgiazUMGEL7I36Bvz15pkIm+pMj1MGs65tbCnDRDJg6TS+fbjVuv7tvF9161hOaFSYur5Sr/VcpiaSIN1ZKofLsGxm8FSqBDC2mpnDspaaIARTNIItvfP/aDhnERuN/xurCKT6Zm+32WLZ/IC3XZ61Z2h6uaIcgzrtCx5R+WadpYwUJhjkdaYhOsbW8sWF6M932hupHEjHL5gaExb+fh3m35WvKxxy9D7Qz0XcON8yyjGdjbPMn3bovD86H4kvoRSoiC+yASexaOol4kEXF/7cwQJoipKbW+ODU7/4N4docUFI3nd+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tTnci6jG8W7jmBKEnZdBIFRXX7PxH+0wcgl6gi2CKH0=;
 b=bnVFDr6ZhB1NUvPOk7//H1AzGcNfXd6nVrZFVC1l1p4Icy7jvLKK+uqyQYBORpQXSB47XlM0VfeUkF0EYu1cd6HwGr/IpzYhoGGnALtDlfqzr8NqowUm6UgEW6h9UBqStp92q8ymykH45aBq0l3oNZJ7KvXFHASU32Ynu4zKGYTF0NQ37cq0P9RCizY3Z8hL9GfIGaDZqTj9UaBdre+/zGKZIwpSuwhp/gmupKZg+lKPizsc+QRXvoezEYIgT1zF+IlVDYRsOE/33Ceijw6DjHipPa95iMNZWPyCf3rKvljDosMfWsbVbe5xk2ztfUG0nLCC3TfxHq/B4rqCfbJjqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH7PR11MB6771.namprd11.prod.outlook.com (2603:10b6:510:1b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Tue, 14 Jan
 2025 06:45:46 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%5]) with mapi id 15.20.8335.017; Tue, 14 Jan 2025
 06:45:46 +0000
Message-ID: <fc7194ee-ed21-4f6b-bf87-147a47f5f074@intel.com>
Date: Tue, 14 Jan 2025 14:45:38 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <219a4a7a-7c96-4746-9aba-ed06a1a00f3e@amd.com>
 <58b96b74-bf9c-45d3-8c2e-459ec2206fc8@intel.com>
 <8c8e024d-03dc-4201-8038-9e9e60467fad@amd.com>
 <ca9bc239-d59b-4c53-9f14-aa212d543db9@intel.com>
Content-Language: en-US
In-Reply-To: <ca9bc239-d59b-4c53-9f14-aa212d543db9@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR06CA0015.apcprd06.prod.outlook.com
 (2603:1096:4:186::7) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH7PR11MB6771:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c48b917-d7b8-4c75-2552-08dd346712e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aFhwMGdLenZNeVVRREtsKzFjNWUyYWpGczFVc0psQ0VPY2poVWlneXhQWFQz?=
 =?utf-8?B?akQ5dm9FS2RDeG5kU1FYUnJnOHB0UWJjWTVVUzk2a2lTeC95SE5WSWxrWmpm?=
 =?utf-8?B?NXd1ZnZ6QXFUZ1Ziem04Z2plZkNSZHo0WlhqQ09RaXpQR0gwZlBIck50K0xB?=
 =?utf-8?B?R2hERFRpTTJYbHVTNE5EeGVZcEthdUNOeVg2UldBalVUYWJlaDJXd2hoUnU0?=
 =?utf-8?B?czJZRjViaVUvWGRZeis5T2hMVEhNZHlEWjZVSVpNWGhwbjhqWHYxMSt3YzdC?=
 =?utf-8?B?UWJ0ZWpjV0RJV3lBanRMVlpTSXpxVXJodDNSd2VVbmpWQVFTZzFiM1FpS1p2?=
 =?utf-8?B?SEJad0tPUmFTaVovdHh3YnhIZUhEdGI1c1gwSk1rNmc5SExRSkhVekRudG81?=
 =?utf-8?B?Q216cjgvNFowdU9KWjNPUitCd2txUnNXalk4VWlUMXdSRytmWGx5M3BlTSsx?=
 =?utf-8?B?N3hrK0dZRkx6YnI2bWNWRnplWXhWektvT3ljK1ZEbVZ4V3lBb0VDbzJFd2ha?=
 =?utf-8?B?WjFBNlFtQnR3Qzk4ZlV0U2lqcXRoNnY4dTZmdTdib2FQMXRhcWcrSGpyR05i?=
 =?utf-8?B?ODBTcDBBSGdNODdFSExqWFdVZGtIRVhpNUN1UWFHS0NsdWgyVGtYOGFNbmtM?=
 =?utf-8?B?NUU3UWRnUzF1MVI4dnhvNWVDa281VUdySGNXWmFTLy8yZG84a0F2cDhlbktU?=
 =?utf-8?B?T2swODZha3NSN05OaDZKUEd2UXlBZHY4NjhlaHlaelZzUXVocEZoUFFWTTht?=
 =?utf-8?B?TnZhQ0NFZGU2bGJXd1Z5TFluRDdUOHg0THRzS2NvazZFM1lJK0F2Q2tiWGlR?=
 =?utf-8?B?bE9hY3F0Uktpdm1abTRrTlZnS1F6WWJod2JFSDZWUDM5TXJXLzV6VUx1cksv?=
 =?utf-8?B?Y1JsaENxb2phT2NkNUNSaGN3RzZabE1qdU5qNUh2Q1FGR01Uczd4eVgrek5O?=
 =?utf-8?B?U1dSK2VOYm9RTHVSL0JjRGExOXNDZ1NMMjVqZTRIY0JQcGtTQzR6eks5Nm10?=
 =?utf-8?B?SzZWYWVOeWJtYWp4K1hWSUZndWl6QURDSlgvNTRoTWVmZGVQdStvVmt6WjdB?=
 =?utf-8?B?WTRYVWN3S3BISkprRmRWNStxYUY4Mk8vaDQ0TEVtYVVZNm9qdnl6UmhtRHAy?=
 =?utf-8?B?K2k5YjhXZVhJWTN2WHk4M1lJaXNEM0dyYm90L2kvc25uSGlzWUJtTHY2aGRY?=
 =?utf-8?B?c0dPUkNJUVlUTVNxNXQzYjZRVHluYUxBTmE0TkROVkpJS0htOUtEWTNnNzNP?=
 =?utf-8?B?N1gyb1dQWkZSSmlmNktYcWE5dWpmam1ZWW5jRFhoczAyb1NZV3d5eEJmMXhE?=
 =?utf-8?B?Y3FxV2ZqTWJyOEhpNzhYVHdPMHdNZTg3RmJTZEZ5cHdKK1ZFc0p4ZktSVG9K?=
 =?utf-8?B?SEJvcExiTE1ZWTMwZ1B4aFZ6SXlLZXphVWoyVDNrK2lYWXZ6Uk5GK3NsZFNB?=
 =?utf-8?B?WkVvcUFwOHErenlGYXdjR1l3d0lQcmxiR3p5S2ZGTm85eitqREpVd1ZHNTly?=
 =?utf-8?B?Q0pualNXVkI3cTkzQzhuWFhMU0hZZ295ampXV1ZNYVNWS3cvK2dZanMxMUtp?=
 =?utf-8?B?QXpYQjBHVXMzTEtIN00yWXBNMFZCWUxYSEJOYlV4VDNiMEV0UnhreFBzbnM0?=
 =?utf-8?B?Ny9xTE05a1lWUW80UEI2TXNJajIzTXgxVmVody9PSkhFc0ZNNDZKak1iMGhG?=
 =?utf-8?B?Q1dkL1dqTUV4UGhDM2hLRXJacFhpby9tdFBqbHZEOGZBNGZVbmNzZkpuUDFn?=
 =?utf-8?B?SXdrbHhXTi9CdGdFSnQyMFdkdUN6QTJaQlZrRXp1RzJ1MjVpczVYR0VFekRj?=
 =?utf-8?B?amt5ZzVEVG5hcXViMFA1VU5jblY5UGtYckRuazVnM0tTT1B4OHNnN1o2bXV1?=
 =?utf-8?Q?9yiSo6QzwmT4G?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RURtdzZvTGlRM0o2dXBsUVQ5SERHYktZRmY5dlVRaGNhaVlBQWl5RTVVNmJY?=
 =?utf-8?B?ZUsrUTVkc0tNU1BtY3hYT0RTNnV5aERNYU5xa2dwblpndDdMZm1Ca2IyZjND?=
 =?utf-8?B?bzFSMyttT0QwYjRDVHRMOGw0Q0RkVjhIc2NYYmJyd0o5WHVnbEJjTGFuL0FR?=
 =?utf-8?B?aEUvenV3NS9SdHpIQkZDZHRNRUgzbmR5ZXhDZTZZTjYwTTdOOEQ4Qmhid1Mz?=
 =?utf-8?B?cUdvWXc1b3BNem83RkMvb0F1QndSaVhQOGViTnpCaTE2NDBoZ2Qza0pQUmVV?=
 =?utf-8?B?dHphemFKeWxzQWJsemZnNExaWmtwODhoRDcyM0ZTVkUzYXN4SlllcDRsSlRh?=
 =?utf-8?B?b05oeFRrR1B1NXNGU2JPd2trMDdYVENCRTJWeFF4Wi9JSjRlM1k3UlkwWkVr?=
 =?utf-8?B?M1N0K3UxblJ4cUVYVEtOT3lka0hTZ0kxcC9UK1NCZzhCZjd6ZC9BRlJJbml5?=
 =?utf-8?B?clI5VjlNSzlMR3B4TU9XV2diWnJRYnlVWTk1YXVjUHZqNlVKUTczWDFwMHgr?=
 =?utf-8?B?dUZwSW5TdkdQc2tndG9vRmozOWJSNlpSNjNMVXZJdjc0SElRNjMxWU1CS1F5?=
 =?utf-8?B?NWNaeXRYZlZCc24wbkpQSXNCOFhWRHM3aVVVYjRha0l6d05rSmVKSWdVZ2sy?=
 =?utf-8?B?RHlnSWZCVkdRa084QmsrSVBna24ySkcxOVcrUm0zRmZiVGxCTkV0MUoxT0dX?=
 =?utf-8?B?Wm5uTmRDYS80ZlBySTdWMkJXV0gwNk5kTk13ZE54N2hxTW01SHdHZnAzTjQ0?=
 =?utf-8?B?SVlwWCsvK3FnUS92QkM4MS93YW1STTJCVkZPU3VzWjVpaXc2R3NqVHI5Z0s3?=
 =?utf-8?B?ODk4VmthSjdtcUZIYWdXUlBGWHZUQnNzM2xQNWJ6NHhWM1V1Zzc2bUtvRHRC?=
 =?utf-8?B?ektSTVh0K3BLNlpIbDBZZnRzeTNPR3RubE1aQkVCQ2MxTXhnbnBYTG9Oblk0?=
 =?utf-8?B?V09TQXFxc0grZDRuU0RQQjBSRzZndTBucjN3TVVUK2xyTkoxYkFwdGZLVkFV?=
 =?utf-8?B?MDRLWURkTW9wOEtwT1V1SVVmaGNaVHdxYW5PWVlSYXBFT2hCb0hiUS9BTEdG?=
 =?utf-8?B?U1dFVm1hNUxFcE5jdjVxZGVOT084VnFFQ2gvbk53M3gvOVEvcVBaV1N2SVd4?=
 =?utf-8?B?WUpsYUtreHFQaytZUzBxeVdqblNjQlBxVzk0NlJBeUNtSm5wNXl4SXdTN25S?=
 =?utf-8?B?Qndxamp5WWhRdytGL2N1aHVCR3ljV1ZNNFMxTHJUVjR2Ty9UZ3V4N0JlUElm?=
 =?utf-8?B?V0N3UGgzMmtxYlA4a3FTY2pHdE5wQ2toTi9ZSU5XNW1UWm1RYU51VHpxQnI3?=
 =?utf-8?B?NjlxbUk0MlRvZWJRY2RwOTE5aGsrdmZyS0xmL25NUTJZVEN4YXZhVGVsb2Mw?=
 =?utf-8?B?NmZzR3VPWElwR3VWMFg0NUZTd0xnREszcTdMQVk0a21FZG5SaDJKRHBFM0dn?=
 =?utf-8?B?ZGhIeFpwYlYxMG9QNTJvZDc0NGNVOVV2dVlLZDI5M1JWeHlvUnNuT3ltTGto?=
 =?utf-8?B?cFhKbE00T1p2R0tuTkFzZ1BUUlRsaGpLTjJGZ3hHcG5oR29jRURPWit4VEND?=
 =?utf-8?B?MzN0K0lkU2lhcTNuZjBJUTNkQ0p2WTJmZXMrTnoyY280UzJnYzdaa3VTME5E?=
 =?utf-8?B?UzZDY2NLLytXQXJHaTMwTk1qQmpOTVM2K3Mrd3lFRVpnNlNaUGFJOG1Td25N?=
 =?utf-8?B?eW1LWDhSSUJsS3pQcjBYNTRLcVRDNFU2eUdJbUZEcUhLRjl1L2FCbHBqd3Zi?=
 =?utf-8?B?UUhYdnp5S3F0QldRYmc5aDFQY0liQmlWQXB3NkdFN1AwamdXNVVsVHFUZGhs?=
 =?utf-8?B?SCtQNEh3dmxMNlVUcUVFc2o3QXc2b1B5NlpxdUpFaGJydzk0eDloYzNyb0lr?=
 =?utf-8?B?dUxNT1VrZHJPbVBIczdEdDJCT1NSMmdxcTZvV2w2a2t3eEFrNnBLUzdraElG?=
 =?utf-8?B?cGhoWjZncjA3NmdGeWNmT2pDQ2tKM204K1B2M3d4ZEtNeDVEZXJGc1RZdjJs?=
 =?utf-8?B?K0dVQzB6YnFIT3hHa0orcEpOaXFVY2R2ZWxpbk1oSy9YK1lZZ3JCRkp4anJL?=
 =?utf-8?B?di9PV2lMelVjaWVEMVR2TDFGNWg4dVYyVXZ4dzFudjBUbDUzRm8zR0F1d0lL?=
 =?utf-8?B?ay91TDFQMVg5SW1IN00yZXZXRjlNakdWZyszRThNWWUySHh3TlBUekpnWVdi?=
 =?utf-8?B?cEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c48b917-d7b8-4c75-2552-08dd346712e2
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2025 06:45:46.3040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9+BijZxG0ieqYC8ZCsB+h3DZb5H96/H83l1QqUA9regEwGEwXSvqfjef/RNA4vRVprDdfxMJqxKiO61vO+0HJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6771
X-OriginatorOrg: intel.com



On 1/9/2025 12:29 PM, Chenyi Qiang wrote:
> 
> 
> On 1/9/2025 10:55 AM, Alexey Kardashevskiy wrote:
>>
>>
>> On 9/1/25 13:11, Chenyi Qiang wrote:
>>>
>>>
>>> On 1/8/2025 7:20 PM, Alexey Kardashevskiy wrote:
>>>>
>>>>
>>>> On 8/1/25 21:56, Chenyi Qiang wrote:
>>>>>
>>>>>
>>>>> On 1/8/2025 12:48 PM, Alexey Kardashevskiy wrote:
>>>>>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>>>>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>>>>>> uncoordinated discard") highlighted, some subsystems like VFIO might
>>>>>>> disable ram block discard. However, guest_memfd relies on the discard
>>>>>>> operation to perform page conversion between private and shared
>>>>>>> memory.
>>>>>>> This can lead to stale IOMMU mapping issue when assigning a hardware
>>>>>>> device to a confidential VM via shared memory (unprotected memory
>>>>>>> pages). Blocking shared page discard can solve this problem, but it
>>>>>>> could cause guests to consume twice the memory with VFIO, which is
>>>>>>> not
>>>>>>> acceptable in some cases. An alternative solution is to convey other
>>>>>>> systems like VFIO to refresh its outdated IOMMU mappings.
>>>>>>>
>>>>>>> RamDiscardManager is an existing concept (used by virtio-mem) to
>>>>>>> adjust
>>>>>>> VFIO mappings in relation to VM page assignment. Effectively page
>>>>>>> conversion is similar to hot-removing a page in one mode and
>>>>>>> adding it
>>>>>>> back in the other, so the similar work that needs to happen in
>>>>>>> response
>>>>>>> to virtio-mem changes needs to happen for page conversion events.
>>>>>>> Introduce the RamDiscardManager to guest_memfd to achieve it.
>>>>>>>
>>>>>>> However, guest_memfd is not an object so it cannot directly implement
>>>>>>> the RamDiscardManager interface.
>>>>>>>
>>>>>>> One solution is to implement the interface in HostMemoryBackend. Any
>>>>>>
>>>>>> This sounds about right.
>>>>>>
>>>>>>> guest_memfd-backed host memory backend can register itself in the
>>>>>>> target
>>>>>>> MemoryRegion. However, this solution doesn't cover the scenario
>>>>>>> where a
>>>>>>> guest_memfd MemoryRegion doesn't belong to the HostMemoryBackend,
>>>>>>> e.g.
>>>>>>> the virtual BIOS MemoryRegion.
>>>>>>
>>>>>> What is this virtual BIOS MemoryRegion exactly? What does it look like
>>>>>> in "info mtree -f"? Do we really want this memory to be DMAable?
>>>>>
>>>>> virtual BIOS shows in a separate region:
>>>>>
>>>>>    Root memory region: system
>>>>>     0000000000000000-000000007fffffff (prio 0, ram): pc.ram KVM
>>>>>     ...
>>>>>     00000000ffc00000-00000000ffffffff (prio 0, ram): pc.bios KVM
>>>>
>>>> Looks like a normal MR which can be backed by guest_memfd.
>>>
>>> Yes, virtual BIOS memory region is initialized by
>>> memory_region_init_ram_guest_memfd() which will be backed by a
>>> guest_memfd.
>>>
>>> The tricky thing is, for Intel TDX (not sure about AMD SEV), the virtual
>>> BIOS image will be loaded and then copied to private region.
>>> After that,
>>> the loaded image will be discarded and this region become useless.
>>
>> I'd think it is loaded as "struct Rom" and then copied to the MR-
>> ram_guest_memfd() which does not leave MR useless - we still see
>> "pc.bios" in the list so it is not discarded. What piece of code are you
>> referring to exactly?
> 
> Sorry for confusion, maybe it is different between TDX and SEV-SNP for
> the vBIOS handling.
> 
> In x86_bios_rom_init(), it initializes a guest_memfd-backed MR and loads
> the vBIOS image to the shared part of the guest_memfd MR. For TDX, it
> will copy the image to private region (not the vBIOS guest_memfd MR
> private part) and discard the shared part. So, although the memory
> region still exists, it seems useless.

Correct myself. After some discussion internally, I found I
misunderstood the vBIOS handling in TDX. The memory region is valid. It
copies the vBIOS image to the private region (vBIOS guest_memfd private
part). Sorry for confusion.

> 
> It is different for SEV-SNP, correct? Does SEV-SNP manage the vBIOS in
> vBIOS guest_memfd private memory?
> 



