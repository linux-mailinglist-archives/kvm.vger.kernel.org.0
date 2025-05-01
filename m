Return-Path: <kvm+bounces-45099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 73405AA5FEB
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 16:25:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F02B09C8099
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 14:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B02661F758F;
	Thu,  1 May 2025 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SHVMDR4i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447021C8FB5;
	Thu,  1 May 2025 14:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746109475; cv=fail; b=KtRX9DdPoiZU6r4/+sPsgPz7lPX4vRNfkmQK+NqeiKUeRPcZkQq7/IsuVNpIJS7SlPVoW8JrndcR8alNGxIl8ISo1tp/hVGegopi82oyOLW2kQNmrmcTce3/n5ROlINQKWnAMRhXBJCm9ZVvYul3OJdTuVTpZrZ5FRKPf0bGDps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746109475; c=relaxed/simple;
	bh=T8BlutkHknhlG+pmth4Yvga5F0M3j2jqVN/i/0AQk0s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OtDdOXA2uOQUZkP/4e7u1bfGz0ZrViqAQjZqQ7Sd7lAaEy83qYQNeKGbZM2kQWAccmjq6abn5BVOrADDVIBdXDxzaYPFJ65fRKqg4T/XpgLIA+ZJy3OAcu2Y6kIWy+rqUEV/DLXR/lnA5kIoZeVzafedjJsauW+Qfnv6yr4X4gM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SHVMDR4i; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746109474; x=1777645474;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T8BlutkHknhlG+pmth4Yvga5F0M3j2jqVN/i/0AQk0s=;
  b=SHVMDR4i09/4D+wCe7P2xJYh6bg4fhQgOMgeUIL3iOPpvQEQKDKC+TKz
   PcY3qunG+R7VWyx+bbFNJhiYrPhCZIEwRo3CQ+QA0tWM4mfjZFuKC5LIK
   ONjaGFcRqQFtzSO4CJ+qWv2ap8ywLLgVjv6kwGTv3qYHI0dqOWu5Yi9xP
   d/UDRIENiNshUTcvw/BYR9uLrif87ztvjbJDBIx6IctRDg9KUkMv9uguc
   WjPNE/fpC6AICQehbUDTEmUlH4Pk7ynhhPL9591bjJxhv/xaBVuMM9K39
   n5OS2IaPnLZGU2B4OShjmao55H88TnFj+jYUG2LeFkA9MXcbLq1tGRQFq
   w==;
X-CSE-ConnectionGUID: xnwtdemdRs2GDU4gHxL9kw==
X-CSE-MsgGUID: Wd8aK1ueS264feIAntwZ3A==
X-IronPort-AV: E=McAfee;i="6700,10204,11420"; a="47030493"
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="47030493"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 07:24:33 -0700
X-CSE-ConnectionGUID: vRqDMNzTRzivT0GxUrvBzA==
X-CSE-MsgGUID: Tbcqm3krQUWpQ1MRYssNvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="165456586"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 07:24:33 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 1 May 2025 07:24:32 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 1 May 2025 07:24:32 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 1 May 2025 07:24:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mqCM5+gLvZJefC2+9i7bwXlo8RpCY14w1c0xiiIZmSjbagTGwi95GOGJxRBcwcsXKI1TI9iYPBVVS46WdjLQk+CPJ2VBVyk0GdZao0by0uHCXTTLyyyeY0+e5Thw58fVZwov/AABh1r1gra8KQPLHgG89aLUCJJg9ylHkt3jGdPGJH76JQTyAnF0gvy/qtZGg+IN2C6NWDtbWxFzyRQdMps02wsweqGNqrwcfMUpgc3W1Ie7wYiZXPqxAbrRWIY714v5T8tY/FgSVfj1vLAFXwrjc5aQvN5F6bM3CN2+FeZ8y0Jf5gX6JHSjd1ObonRR4/vcGktPRTBC2NER7Qcdbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+OPrkZEsa8BVsK8NXqB1qKQGJ+0/BipaVwSoxy8Ud0A=;
 b=t2iOt/U0PlQcADPY6OLYBClsXdFTnTa3gmWhAekVeHCKG15ovPuavVUq0gE8gVnmzb/LI5RR4e+73A7H1Fl1e70d6MGc+00xcMMARDShUTWylkhfrKV5Gqpd7aBdRHCw2EN85HPd5nkiQqf7V46P48S2eTqRVgttaawQhKsnR5talXcDGe9OvOLTBGX4EgkYMWMkw+ZdjsJ5QGy/et+wsjDC6xFb9CoUVzLHsMmqFPM3ObZJkcj2hwDyhx139mhKqkxFDXy7kNJrZAOeXGEIqMDOpywqcqFVAfgLQTwftEeHF3Vvl2Y6ifunhJ2PvH3ojrb37BV8NjjPDvRn9rhSHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 SJ0PR11MB4958.namprd11.prod.outlook.com (2603:10b6:a03:2ae::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.20; Thu, 1 May
 2025 14:24:28 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%5]) with mapi id 15.20.8699.021; Thu, 1 May 2025
 14:24:28 +0000
Message-ID: <3c4cc319-feac-461d-a846-7275b0ebca4b@intel.com>
Date: Thu, 1 May 2025 07:24:25 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features for
 host and guest FPUs
To: Chao Gao <chao.gao@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <tglx@linutronix.de>,
	<dave.hansen@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Ingo Molnar <mingo@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>, Samuel Holland <samuel.holland@sifive.com>,
	Mitchell Levy <levymitchell0@gmail.com>, Eric Biggers <ebiggers@google.com>,
	Stanislav Spassov <stanspas@amazon.de>, Vignesh Balasubramanian
	<vigbalas@amd.com>, Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
 <20250410072605.2358393-4-chao.gao@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20250410072605.2358393-4-chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0050.namprd03.prod.outlook.com
 (2603:10b6:303:8e::25) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|SJ0PR11MB4958:EE_
X-MS-Office365-Filtering-Correlation-Id: 224e38b8-e824-440f-5fe1-08dd88bbe1b1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Vng5UDFKL0FZZ0xKc1V4T204bGtvZE40SGxmN2llTVpybldHQ1ZrZXAyYkJm?=
 =?utf-8?B?eG9vN2swbFZSK0x3SWlqSFJyOEl5VXdiL1dnVytJRmxySDllOFhIL0ZWTFJN?=
 =?utf-8?B?Q1JuckpPODd3bzc3NXREbmlQbzlYckNXUXZsNEQ4NUhoQ3Uwak1xSFN1TlVu?=
 =?utf-8?B?RS9lK2htaklmaUE1aHF0cGVjUnRMRXN4dUpvMkkxazJsc3E3dWgydURzbzJ5?=
 =?utf-8?B?MzhBTm5EYTlxbVd4WWFad0htL2NPL2o4TG4veXhqeHAyQ3dsUkxkb1dXSlNN?=
 =?utf-8?B?dE53ZFBLZS9rQSttd0FkajV4bXpzNWJ6Qm4wYjlIYXVRSEphc0xJOGRqZEMx?=
 =?utf-8?B?OEFQK1MxWHo3YnpmYW9mc2NxRzYwU3p0K21jSFNwSXZiaHZnek9aMEhQbGdo?=
 =?utf-8?B?OWtZU3NFd2hiK1cwQkUxdS9NeThZUDRCUTJIczhxd0M5VjlNZUdxNUdIL3hF?=
 =?utf-8?B?YklKSkdtdUp5MndQTzYyMW9rWTVoR0tzRUFuNTNQVDRoeTFSazYwKzN6MHpq?=
 =?utf-8?B?a29sNHNEVlo4YXJvL2lRaHhCRUs0cTFTZFhxaHRhVDk3TUFFLzE5Z2xuUWNj?=
 =?utf-8?B?a281T0hQanl5c1dyQngwRkNMc21KVWw0Zi9HRnpuRlBLTE9oQTFLN2g3WEE3?=
 =?utf-8?B?OTI1Wlg4czJmYUhBMHFEa1pqeFBvYmd2aUZUbVIyUE05MStIWGY2S3h2YS9E?=
 =?utf-8?B?MHMwbWluYnBiVkM4NVFEeDdUTkxXQWlvR2d3ZHhtTDExZDBUL0xKa1MwVEZS?=
 =?utf-8?B?WXV4YktoUDJXM0Q4UEtvNE8zb0oxWEsweUo2WHpoVjNWRTBBdDVBdCt0eEth?=
 =?utf-8?B?Q3hpS2djbGpGazFOcnNEcVN4OGxud1k5aG9uRzNWV0YyZ2YyMk5Qc3RRbmJ4?=
 =?utf-8?B?enhub3NQY2RCc2tneEtNakRsQVpsbENkZ0ltaWM4Nmg1OGFnQ1lIaDlMTi8w?=
 =?utf-8?B?cWRZUG9pTjlZamxMSWFVM3Uvd2N2MkxrRGZ4MjNuZmcvNVpIZGNpdnVrL2dY?=
 =?utf-8?B?QTlTdHBkVGZpUzFka1hHd0greERTSk9TN0VLeEQ2RjFqNVJ1NXQrelh2MFpq?=
 =?utf-8?B?TjRSb3ZCMjQzcU9OQnhwdktKeUFWUUVJVUkwT2R1N0tyZlUzKy9LNFZhY3hI?=
 =?utf-8?B?WGkwNzd2YVp5a3ZYSjZmd29XVVJURkFBaUJMWm1BemtFT3dyYzlBZ0RXcEV6?=
 =?utf-8?B?ZzEycmJLRElPWG03U05MM1hXWkF6K3ZGZjduSWVCMU1jQXB2NHFpTlVZait2?=
 =?utf-8?B?aUIreUVjZGlSWEtPdzY0WTg5QWpQaDRxZmFpYmowaUxNc05zZXhzMThtNVZm?=
 =?utf-8?B?S2g1M1dPVktmT3orOC9CaEI0SDk5RlFDZWw4RDRuS3gvSnJmc3l2RVNMSnd1?=
 =?utf-8?B?WEtLN2hKQ1lhRVprWEovMXpLelo2QW1vMVg4YkFwMldQTTFvL1Ywbm9mcnZH?=
 =?utf-8?B?S1dJM3ErdTBmcUtrdFJSTlZEeDRhc1RlbzRJZkZuanNQVURrL0tqVkw5c3Aw?=
 =?utf-8?B?TWQ2TzhkdWwweUdMZDhOYTgrbFZIY05pbUdad0Z4WlVTdFo2VHhJY0E5VE9t?=
 =?utf-8?B?TDhMdkhOd0d4NGxGeHltUFM5ekRQSWQ1OXNzNFUydmZLK05Hd1hWQ2VmSE83?=
 =?utf-8?B?RjF0Q0lQZzdGcjVPQktpcU9IUEwrdkV0ekhoOTU2emZ5VSswQjFWZFlraWJm?=
 =?utf-8?B?bEdEbFBBVVhkd1d0VFBkbGRyeDlLOUx0NWx1RjVVbjUwQzUrdFowQ3hFQUhJ?=
 =?utf-8?B?N3I2WlNLeU5ZVWswUnpVZ0NzckovWEJNNk1NUjEyL2J0bWdGNDdJM1hVa21G?=
 =?utf-8?B?WUZ4QlpHMWlXbEs4emNuVTdxQkFlSEMvOTRERlA1N21HYmdGb2dydnRzWVd3?=
 =?utf-8?B?Q294RUJBcFlzYzF2TVlyNURITCt4dVc2V1JHdFpGeGRZOFE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzQwMGoyM0o5V3FJOTRrVERqUHJ4bkRqS3lrdEJaVS9iWkNrZERtYW13cThR?=
 =?utf-8?B?K1piOWI0S0RrMUw0T29lZEx5QkNlYmkzWm92aDhNTjl0ZC9LK3lOU3FFeXV4?=
 =?utf-8?B?aW9OSjV2anlNNEttZkhyT1pQbFhzVVFrMXF4OTBHdjRxN1JiZU1QaW11Y3lG?=
 =?utf-8?B?ZUFrRkJtSFRyRlNrakUyeTFacFJObDgvVldESUE1dnpnU1hFQTZuRExGN0lq?=
 =?utf-8?B?Q2sxc2x4NElkdzEwbHVkRVE5UU80ZW1UMzROU2pYTzRiVDVqaTc4SlNwSnBk?=
 =?utf-8?B?dlVjb0F6U0VITlo2Rm5raDNtaEczRUdxTUh2WmhreldHb1NDRnIzTWIwOGVj?=
 =?utf-8?B?YWtTeGRxcFJGUlF6Z1JmWmlVT2hHZGxVWnFSL0Y4VVB4ZzN0VHRmMmgwYkdJ?=
 =?utf-8?B?MERJSjhWV25tYWxtSGdiaFY1NDRPWnRkRTdYV2hzenZjMUZMNU5ueXA1dWZs?=
 =?utf-8?B?TmY4WDdjYnJRNTFNOVZKZkk1eHZyNGVvZ2lINFh6QXFQUWsya1ZGOHJ2OU1B?=
 =?utf-8?B?eStLbStGU0xkQmFDaFNkTFI4SUF4L1VKbW1wME1NNkgyT3d4Ly9mYjAvdDB2?=
 =?utf-8?B?Tk1NeXNydWp4NjFGeFJwc2JGOEVwTnBvRVdiRThmZ0x1VktxTVlmUTdtWUs4?=
 =?utf-8?B?bEdrQ1p2QzN6TzR4K0lMWWZ4SkxOS3VoMFQ4N3ZkZmo0cHJwNkNTOVZvdDhI?=
 =?utf-8?B?UkJnV09rSUQyZ1R6WVh5b0tXWTNHN2RCemhGc3FZQXo4NkNTR096N05wbVM5?=
 =?utf-8?B?em05eWV4N00wSlNzT3ozdEowTkNTUlhqeUNCaXc5bXREbUNtOGFja09pT3po?=
 =?utf-8?B?ZmpjbjRyb0JkdUZuZXNZSG5mMUJrdWwwSDVhRFp0NGN0bjUwdFpwWlhBbFNS?=
 =?utf-8?B?ZXRIRVhGbXNmQU9EeW5XV0JlVVcyY3ZBYjdjWk53YlllWXQzK2M0T3NhMlpV?=
 =?utf-8?B?WWd4OFJBYnM3S0tkYmlPNjRJVzVkKzl2MFYyY1orN0VNS2FtMmNtWU5pLzZo?=
 =?utf-8?B?alR6REJhdnp5SHVsMzBIS1pIYnJIc09PY1NDRWJYL01VcUJmeHN2ZGFZOVlX?=
 =?utf-8?B?eHhZUlpCU21UMDkxT2gvMzRyYlM4RTNzVVpiVWxaSE9naHhuTiswQkdoQk52?=
 =?utf-8?B?Y3I3Q2xXbnpabmdDTVZrMnlJZ1NsSWNUNE9KMlVFdHhBTjZJMVc3cmRGK2l2?=
 =?utf-8?B?VGRuUHVMWFlkLy9HaGNKQWNlOUZnZEFvcGpTOEVmaXpqYkFrYkNybEZ4V2Vl?=
 =?utf-8?B?czJvYzIyb1U3bEhJZ0NOOU9vbGMrWDJCK0t6Ly8zM05tRENLK1F3WDd2cXhy?=
 =?utf-8?B?WUZUalhqZjN1RjdPYUhBVzBJbUhTY2pUWTlxK3lzWGVDcStWY0ovSWsyandX?=
 =?utf-8?B?Tm5CWFlhZHdIaXpFNjdoTTFSSzlaUnQwVG90QUtnRW81UnhsOHB6T2lEZWdi?=
 =?utf-8?B?V3oxZDJJbXdoUXZPTm1EUGVZZlBndEt3MCtURGxpMGNwcTJvbVc3RWt3Mjl0?=
 =?utf-8?B?bHVlQXk1U0xSQmkwNTBTUjVrK0MyQjhUM3liVFRjNnA3V2M4Z0NNbnNqNmEy?=
 =?utf-8?B?cVh0MVN0L20wT1BoOFBxUHJIMm1EaTN3NlphdHNuNDZPYWxTWUhYMDRQUEtW?=
 =?utf-8?B?MmV1SHoydVNrZHRUNmNlUjU0ZDZLanZHWHJvazU4MVRjV2pHMzRRMHVicHpw?=
 =?utf-8?B?dG9zYVNZMTVNbUk3RjdQeCtWbURxTkRDTTNFVU0zTEc3WDJSTFZrUWF4OVMr?=
 =?utf-8?B?Q2pRRXpVcVMvLytLUS9nMFA3bHFaTkNtRVRQM1J4c05VYWFhVE83UnRYakZG?=
 =?utf-8?B?dGtYOERIQjd5eG1zRlhVNHVKMTgxQW4vWGFtRDArejV0bWp1UWU0ZzRYR0Er?=
 =?utf-8?B?NVVpS2Z6cElGNUNLV3dEU0Jkc2RQNFBEbWFWN25pU05mNTZQb3NqVy9iYjRW?=
 =?utf-8?B?MGczNWc5bC9rWm9IQndYcnRydFQxQ0QvVFgzTm1PWjdOZDF3RnNyVWx5dXFr?=
 =?utf-8?B?eTQwWGd5ZkdWYTI2YU9Fa0ozdW1KUFNTd0pJV1VJS3N0bFFwVmt1M3kwYXkz?=
 =?utf-8?B?cE9aakFobkdtUlZFM2NuVFJjY1VKTWZHYjYxVVNGa2wrMGRYc0ZiRG9MMXRI?=
 =?utf-8?B?U0VFeWNvZWtZRkIrWEErZFdJT1UwSUxMbnc1MFVRNkFocXdjKzdXUGhWUVpI?=
 =?utf-8?B?ZVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 224e38b8-e824-440f-5fe1-08dd88bbe1b1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2025 14:24:28.5714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: amP/IqI+WNgXCwDUhkzr5KlHFToCpH2D67iPn4dAwvoWN9YBh3ZmsdR/2IZWIeNHMIi5hgnKLd+SaJU4RNCWj8zh/K9Yf920mlsEuk4wLfI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4958
X-OriginatorOrg: intel.com

On 4/10/2025 12:24 AM, Chao Gao wrote:
> 
> +struct vcpu_fpu_config guest_default_cfg __ro_after_init;

I just noticed that the patch set is missing the initialization of 
guest_default_cfg.size = size (or legacy_size) in the following functions:

    fpu__init_system_xstate_size_legacy()
    fpu__init_disable_system_xstate()

Without that, it looks buggy when XSAVE is either unavailable or disabled.

Thanks,
Chang

