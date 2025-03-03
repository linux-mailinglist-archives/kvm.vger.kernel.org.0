Return-Path: <kvm+bounces-39835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9815FA4B59B
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 01:22:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A393216BD8A
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 00:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A23A35967;
	Mon,  3 Mar 2025 00:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Apz5fr1w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A2A9476;
	Mon,  3 Mar 2025 00:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740961364; cv=fail; b=u3I33AE5A8mdpQFpX3wPCISH6kOzOoA7Fd7Ym5WVBLSLPQy0GmGKLl/qjy0qVzajPtOru8+9F59bhOP6Gk8z8jsVFwWGjbqDGELds2ZbR0fb58c1rkSMQJwq27qR0yGTFR//x4O0KagJ3KoJZp7lBcaCCbHWc27EI0pznH1IfPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740961364; c=relaxed/simple;
	bh=aPC3nP9FBUduW2SBY/CT8670nn/F0xmqlOfMnT7kPC4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iSxHy0FyDSL+/Zt+whg7QDDMV38gwI41M643PjaeVjqr1e/YS+Pp6uf8M2Vd0aXVaTg2/unk9QRkOXunnENfY33r5x/qhAtq9a1ncutiV8NYPHGyGLAmwwgRK75UM0xcxgQ4XUo1GKp0OY0TXlMd/PrD1FnL/m/t0H3gQqGq/C8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Apz5fr1w; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740961362; x=1772497362;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aPC3nP9FBUduW2SBY/CT8670nn/F0xmqlOfMnT7kPC4=;
  b=Apz5fr1wGfHU0xP99r+Pr7k7QvQxh8NoGJYgDcUfZG5/rzWGL2utwYPR
   Au9oOqqFDpvV96B1gDcmx6nl0xDyOrirf+6MdPP1FQW2VvvJKualKJxff
   K4pRs629ZBI/EAIMhpP2h357TGG+GFHfOl7PBqvzzCx8ClAkYfGAvTu/r
   FyRi6ehvi01DfuWXF4Bqdrq1kcXKLNcFaK4prU1nPQ3fyfzOxdgh/dTos
   bUNJXQSexYfHNJbQT2OkDkUN2UPW0x3kjuanWir82BlV27233WF1T5seF
   yKdi+m6S7rrg/Vsiq0WGERgO90WQqM9TiqrsFARR6qIHWIhb4QJqDX3D5
   g==;
X-CSE-ConnectionGUID: WTB2hg61S8+ETLdrYTqd6Q==
X-CSE-MsgGUID: X/IxZ9iESviYptJpYLTmjA==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="41947101"
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="41947101"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 16:22:40 -0800
X-CSE-ConnectionGUID: S6d0D9j5QOWyXoT59OenDQ==
X-CSE-MsgGUID: jxS/oQzMRdqfjLdRUlw7YA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="117706974"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 16:22:41 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 2 Mar 2025 16:22:40 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 2 Mar 2025 16:22:40 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 2 Mar 2025 16:22:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fK8T/8vHlksJF0e7XcnY/JFAxr2/E1wau+U05+r61V3kdkzXHqvwaPraTh/mHzD9i9b1J1RgaH6fTOBHwtemNglObJnXoFWM95XquOw1f0FYqfN0dzV9Qk55fCFK0qPVz/yy10OQeDytIqCbVbqWqcKvOzmwYbkTk+kShcMydVNeJhNR/ZlruqkTkMY+fSylQamdNO0RS2wPC3rANe0IYT+Mw9LoMMuqZXm5Jf2ufgjf/0kHwJ1a3ohv4JawlLwJQbD1x4r9a5IQgQnwKPGhAC0CRr3NNz0IuzvIVlrTTDKFEaQOrdt2zYkkBnxGU8onusvwaKpeLOSP1sThZcR2Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mw0DY/7iB98z+XaqmRqjV8FUCGk1bZihRofLnhZacOI=;
 b=GpSMxHOwaVEHHHI12GzDbozU2uvu+t9KSfUvTaI0LLQ/Efwr/tru8k2sXwld9UH0VQsLGg9QbNpTAS6/VCOt4icl9J56b1fUN4EjGpk1mLVDAuPFqsX0aZglHui0cvPFqUOWIHbliObHam+BVQHQTHTU+9l98/VgWk22MQCtRUYrp3miKfUeF9XbQvXcCGroSo9MLNpxEwleh0Gi0dv/PMq542cy3d48JtvzgGASzq25X83T8WwdHVi47EzXVyEjjPm020B3iKf2/kFWfKRXaOy5xcA3IJmuG7mFlfKSTd/ccURauIQPjy2+AdCFBOmUQKEBTFt4K/HZVOlVkH9Rgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 BY1PR11MB8005.namprd11.prod.outlook.com (2603:10b6:a03:523::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.26; Mon, 3 Mar
 2025 00:22:37 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 00:22:37 +0000
Message-ID: <8a86c242-1761-4d2b-b2f2-4a009c2ba766@intel.com>
Date: Mon, 3 Mar 2025 08:22:29 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/33] x86/virt/tdx: Add SEAMCALL wrappers for TDX page
 cache management
To: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <seanjc@google.com>, Yan Zhao <yan.y.zhao@intel.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, "Yuan
 Yao" <yuan.yao@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>
References: <20250226181453.2311849-1-pbonzini@redhat.com>
 <20250226181453.2311849-8-pbonzini@redhat.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <20250226181453.2311849-8-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0190.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::11) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|BY1PR11MB8005:EE_
X-MS-Office365-Filtering-Correlation-Id: 707486aa-5c2f-410b-9dbe-08dd59e9805f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?clBkQnVKSi9UUXpod3lmSnFuOHlxMHpLUWVONW1Lb1liMENOK0JPZVZhOWxM?=
 =?utf-8?B?S0N3VDFvb1ZNMER3TWl1UE43OWtDYlNQUXdZTGJWODgycHhDZ0RpZlhIbDBh?=
 =?utf-8?B?Q3ZXOHAxNHNFVDJEQlk1dVBoc0pyL25aazRDNUI4YkY5aHphNlNZK0hNWjk4?=
 =?utf-8?B?N0h0YWtzZytMWHhIV1lmL3F6UFc2czdpNDltbGw1R0dob1lmVXZIdnlNcGZX?=
 =?utf-8?B?RXZCcTRBMUpwYXVjZkpXSEdCN0RzY3FzRDFsQWd5UjJxdk9YVjl6aXJkNG9K?=
 =?utf-8?B?eW1lekRWcDZxMFJHY1ducEphcDFnMzMwMmtpc1hodk5wWDFPNXVZUWprdFNs?=
 =?utf-8?B?TmRlMGljcGhSTGZWM1R4NVpMZDR4UUtReWF3SmZWeFJHSDljMTZ6a0lvc1Jn?=
 =?utf-8?B?WU42ajU0TE9meGQ4SCsxSU1DazdaMm9Qd05NZXpVSEMzQ3ZEOFcvZStMd3JM?=
 =?utf-8?B?SjhlNkJOY2tBWmI5MndhNDJRcFhpMDVsb3dKbTNLdXBmVXl4WitDVkJRVytS?=
 =?utf-8?B?WmNERkVrWjhBT25qSXlkSTZabkZwWks5N0tSRW1IZmZpeDlRcGJwK2dEcmlI?=
 =?utf-8?B?NW1KVHBEc3lENkJYUk9MRUxweCs5UFJsMUM5WmN2NVpkY3Vsc1R3aDl1bmov?=
 =?utf-8?B?R0FHNG1sY2RlcW9yNzc1YU1RT2JYcFFJdFZqd291ckV5end0QUV3VnBJMGdx?=
 =?utf-8?B?cGdLTjRtRHFMcjE1RTF6ZitYWjF2REx3VkhpVnRBOTZNYzJ3QS9HM1dsd1h5?=
 =?utf-8?B?enowN2plZlZzQkpsbEVqYi9hVDFsM1cvbW9RUE0rd1VqUy9iMnh0R3RFVXFB?=
 =?utf-8?B?NDFvL0xxRUd4ZjMwZDJwYWJCTXJ6bGw3YTIxRkFSTmM5eGw0UjlpdnJuc0s4?=
 =?utf-8?B?QmFmUXNHaU1uLzFSanFLS3BOUENNQXBJV3ZudWJRWmJxeU1hR2s2SElnTHA5?=
 =?utf-8?B?Sk9CMlQzdGZKa2ltcW41eitFbDJwQnlXUjIxckZwZWVGYWFlZUZEVHRORFJn?=
 =?utf-8?B?ZkcvRW5tRlc0UjlGQk9JWU9pNmowVXRnUVU3WXBMKzZkdm9EVzVkaUNtMkdK?=
 =?utf-8?B?bFpYdXVYUTQwS2o5dTBLOUowWjA1RlFibFBhOEhoSnJUeFVmeGxSKzlPZ1Vq?=
 =?utf-8?B?TVZIWms4V3p4NkFkYnFycTNhWXRlR3ZZRWdIZ2F6am9Cb0V0RzU5d0pBa05H?=
 =?utf-8?B?SkRzRGZtUCtIRVVmNmIxRk41OWh2R1NHRFRXZXRwZTRqMGNMa0F1MHhsRGZw?=
 =?utf-8?B?WldrUk1XcmJHbUNMb0psMWlqYXlxaVFhcFE0dkpqMFUvdDFEYlVnM1Zlbm9P?=
 =?utf-8?B?bWVyU252Q2ZBdHIwektvaTBUV0N2MzN0TmJuWHlUWk1XeGJvaGtkbzhrdnVI?=
 =?utf-8?B?Z25XTkhTRUNBR1MvNXM2SFp6VU1zbitWdWNrR0Y2UG8wdHRaOHcyYWRISnlV?=
 =?utf-8?B?LythK2xRWTJpcytFdWQyeUF5cGxBSW5CckJINXhleVpndlR3TVlBeTFLRE8w?=
 =?utf-8?B?N240UkgyRjBYM1VFSXpscXE1K2dTZS9WNkhZcWFOWnRqZG9FVm1pVUxaSTVY?=
 =?utf-8?B?b2E4MXY0NlB3eTlQWm9DNkdYOFovWVczUDhWcUoxRU5JeTVSQUdxb1o1cXhC?=
 =?utf-8?B?bEtva2VUamc3aTluVk9yQzQ5Smp6QXBER2tUM0lGcmQyTlV2MWowY1JXcmVk?=
 =?utf-8?B?Uzl6UGc1MWQyOFphakdQRDFqYmdBN1VwTnpVUUdwSkYrdktralk5RWF1R0p3?=
 =?utf-8?B?T1Awdzk4WWdBdEhpWlV0aGZBOTY0eS8wSytDbTRaUzdXYzY4L2FFRW5vb085?=
 =?utf-8?B?eUk4eVcrVXRnL25lMVlnZ1pBQVk4MUdma3VRbmJyN0RGTURLejhaWXlNS0JO?=
 =?utf-8?Q?L1Q3Otk4xUMgi?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjJzTDJyVjFMWGhVUE1xdFMxRm9hMXhZSExlNk5pNnJBbGQ3bUtORkFlemtN?=
 =?utf-8?B?SElzY2ZRc01mSkVyWWUwb2k3aXdERURSTGlOWkM2UlBHUmVkNmJJcUs5ZzNi?=
 =?utf-8?B?cjNLTkgveHkzdHhEMmU0SklyK2xoUC9jQ0JHMFFyMWw2clVkc2hLTXppMDFp?=
 =?utf-8?B?Y3lDYWEvMm5ubWI5MFFEeFc3MkpSajYyY1haeWsrdXgxOUlnNEZFRWNNZmZM?=
 =?utf-8?B?d0ZUMzR4elVWek96cnlEZThDVElVY2JhU2w0NkJzLzlQbWFJSmI0N3Qwb1Ar?=
 =?utf-8?B?bUxra3VYWFZRWk13WE5OR21hMVdVSHVrNjgrYWRtb281d1p4aVIrNlRoWnJt?=
 =?utf-8?B?czBxSmhtM3haU2NKSU10SmJWZnB3TzdmSC9RSlV4SVlPVkVEUG0rTGVXM2FG?=
 =?utf-8?B?NUVTY0J6UU9mZ3FZN05Yek91enhDdTR0OVlid1hmOWpCUklrRkg2YUdBY21i?=
 =?utf-8?B?YUxORkYrWk5PNnZDMTNOdi94eUV5VXBZanhUY1NZcS9ienpwRWtxYVVrUlFY?=
 =?utf-8?B?Q1paRkVBemV2UTI0MDAvczYxVThueEdDSDZiczZTQ1I5NXY1TUNGb2pWOHpm?=
 =?utf-8?B?WHcxdG5ENlVOdE1RL1VFRHAwcWZyU3duRDd2UUtXQjRKbm9sNitPT0gwTTho?=
 =?utf-8?B?U0Fqc2lHUFpSY0ZPN2xsV3M0QkZQa3Urdkl3SHZ0dHFhQ0MzZGt2Z29QbWRO?=
 =?utf-8?B?Y1dYdWVpNmJ4YzB3OHhZM0plRzhQWjBnRlRpRWJNcEVwejg3c21vS1JLeFpL?=
 =?utf-8?B?UGhIblVkbXdDME9OVkM4ZVZxMHFDekh3SDdXdWx6ZFdobFZFM0dPbmxjbmJX?=
 =?utf-8?B?UUh3Zk5DaFludWZ0Q21KL3pTem9TOVZlYWRRMTlkYkNqaDJCTDlLN0xRRElS?=
 =?utf-8?B?bFNuK2dVeHNuVUJEejM2U0tpQVJYOFhSWEl2dHNCeXl2TytTTDBFUlVBT2JB?=
 =?utf-8?B?dTZsZHhrSnVQRGoyK0NsVnpIbkRHeFhyS0FKTFYyYnArYy9EMlROM29uZDhV?=
 =?utf-8?B?TFlScHhVSURPbGZNZnJwc0lIL3RBVDIwaXVlenhqRU52OXdVUXRBSjhnMStK?=
 =?utf-8?B?ZzlTcXdiRmR1cTFyZytwM1hrMjNUbFFIWE80UExYRTh3ZEZOKzd6VmhIMUpq?=
 =?utf-8?B?UEdmWFU0Smcxd0hSWFB3aXM1Mm4vQ3FzbEFJUDFjQkdaMm51dEdueHBxWWhU?=
 =?utf-8?B?MWNXM1BUanN1Y2RFY0M1R0tKbDdtTU9kRmpvRFJ4MFdtbS9xL2NRL2FtN05u?=
 =?utf-8?B?djZaMkJQc2l1YUdwNEJPSnNMUERlOTZ0NEJyc1BHYzlHRVF1U1VUeFZNRkRM?=
 =?utf-8?B?dGYwUFNtT1NFcER2a3NOa3czT1NneUdNRDdxTldPSExsS0pudk1QM2F2MTlZ?=
 =?utf-8?B?ay9GUU5kbjBPSzhGQjBNK3lwczFia01wRHhtR2dFQkFnRVlOanF6QTErcy95?=
 =?utf-8?B?UG1CQ0JrODJpNUZYTER1OHR6KzJpN21IUTZpQWZaV1VKbFd4aWZDTS9jaFhG?=
 =?utf-8?B?ZWRmWFpJR2YzK25wK053c20wZmFwZ0NLZjNzbEtVK2VzN1QxOXVuRml4MmFX?=
 =?utf-8?B?eW5zNU5ORG5LRi9xZE1BV3VRNTJ2U2g3bHE1WGtrcnp5Qmg2ZURld1RvOXJm?=
 =?utf-8?B?dm5HOFIvS2xDTXVMV3hLektVQWd2NVdhWVVKS1IwdnpXZzgvdkpQYkI3MHRO?=
 =?utf-8?B?OGV1NXlpWVFzMERPQWtZVHpaekx6REQxN0pxUGJPcDlya040blFydUYveXFa?=
 =?utf-8?B?UlVJWFpPdnFkbjhURjNSb1NVRFp2eCtBY0NDc0V0dloyTFYxUElBa1lpYnZU?=
 =?utf-8?B?TGZoZHN0QnVlQ2hyaUZlYkZaRDd2VkRiVFR2L1R4bitLamJmenllUWo5WFhw?=
 =?utf-8?B?dDN3YUNJeFIyU2N0L2NlSXY0bmZUVis3RE5za1hNMW9kVHFYbmIzaERsQXNF?=
 =?utf-8?B?anNvRVZYTGFCZStlZEpsQ0FWN1lHTUFSNWVxRXRjRHpCSkNZeEo2S3lEczdJ?=
 =?utf-8?B?bi96ekdQWWtxcWVmb2JuRWU2QVRjMjFsRmlkQzdHL3VqOVQrelJ5YnM3aDdY?=
 =?utf-8?B?UHUyRUdvc2hvTnRFaS91ZlM2akJoYlU0VjVkQXdGdUVrVjJrZ3hXOTZ2ZG9G?=
 =?utf-8?B?UUttRThjUlhGcHdHSHNFZ3JiNDJQQVMxMWllKzNiSVFVZDFCS2s0dWphT2Zn?=
 =?utf-8?B?UUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 707486aa-5c2f-410b-9dbe-08dd59e9805f
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 00:22:37.5786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vbckBggIttWyckL8dI+4ckXuBKyNuvNwsVHpSuOdFWh/FNMwUtosLa0VoraKNSWdGmeT4IsT54HL+b9E/RpExg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8005
X-OriginatorOrg: intel.com



On 2/27/2025 2:14 AM, Paolo Bonzini wrote:
> From: Rick Edgecombe <rick.p.edgecombe@intel.com>
> 
> Intel TDX protects guest VMs from malicious host and certain physical
> attacks. The TDX module uses pages provided by the host for both control
> structures and for TD guest pages. These pages are encrypted using the
> MK-TME encryption engine, with its special requirements around cache
> invalidation. For its own security, the TDX module ensures pages are
> flushed properly and track which usage they are currently assigned. For
> creating and tearing down TD VMs and vCPUs KVM will need to use the
> TDH.PHYMEM.PAGE.RECLAIM, TDH.PHYMEM.CACHE.WB, and TDH.PHYMEM.PAGE.WBINVD
> SEAMCALLs.
> 
> Add tdh_phymem_page_reclaim() to enable KVM to call
> TDH.PHYMEM.PAGE.RECLAIM to reclaim the page for use by the host kernel.
> This effectively resets its state in the TDX module's page tracking
> (PAMT), if the page is available to be reclaimed. This will be used by KVM
> to reclaim the various types of pages owned by the TDX module. It will
> have a small wrapper in KVM that retries in the case of a relevant error
> code. Don't implement this wrapper in arch/x86 because KVM's solution
> around retrying SEAMCALLs will be better located in a single place.
> 
> Add tdh_phymem_cache_wb() to enable KVM to call TDH.PHYMEM.CACHE.WB to do
> a cache write back in a way that the TDX module can verify, before it
> allows a KeyID to be freed. The KVM code will use this to have a small
> wrapper that handles retries. Since the TDH.PHYMEM.CACHE.WB operation is
> interruptible, have tdh_phymem_cache_wb() take a resume argument to pass
> this info to the TDX module for restarts. It is worth noting that this
> SEAMCALL uses a SEAM specific MSR to do the write back in sections. In
> this way it does export some new functionality that affects CPU state.
> 
> Add tdh_phymem_page_wbinvd_tdr() to enable KVM to call
> TDH.PHYMEM.PAGE.WBINVD to do a cache write back and invalidate of a TDR,
> using the global KeyID. The underlying TDH.PHYMEM.PAGE.WBINVD SEAMCALL
> requires the related KeyID to be encoded into the SEAMCALL args. Since the
> global KeyID is not exposed to KVM, a dedicated wrapper is needed for TDR
> focused TDH.PHYMEM.PAGE.WBINVD operations.
> 
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Yuan Yao <yuan.yao@intel.com>
> Message-ID: <20241203010317.827803-5-rick.p.edgecombe@intel.com>
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/tdx.h  | 17 +++++++++++++++
>  arch/x86/virt/vmx/tdx/tdx.c | 42 +++++++++++++++++++++++++++++++++++++
>  arch/x86/virt/vmx/tdx/tdx.h |  3 +++
>  3 files changed, 62 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index f783d5f1a0e1..ea26d79ec9d9 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -33,6 +33,7 @@
>  #ifndef __ASSEMBLY__
>  
>  #include <uapi/asm/mce.h>
> +#include <linux/pgtable.h>
>  
>  /*
>   * Used by the #VE exception handler to gather the #VE exception
> @@ -140,6 +141,19 @@ struct tdx_vp {
>  	struct page **tdcx_pages;
>  };
>  
> +
> +static inline u64 mk_keyed_paddr(u16 hkid, struct page *page)
> +{
> +	u64 ret;
> +
> +	ret = page_to_phys(page);

We did "make allyesconfig" build test, and see the build error:

./arch/x86/include/asm/tdx.h: In function ‘mk_keyed_paddr’:
    ./include/asm-generic/memory_model.h:72:23: error: implicit
declaration of function ‘pfn_valid’ [-Werror=implicit-function-declaration]
       72 |         WARN_ON_ONCE(!pfn_valid(__pfn));
           \
          |                       ^~~~~~~~~
    ./include/asm-generic/bug.h:111:32: note: in definition of macro
‘WARN_ON_ONCE’
      111 |         int __ret_warn_on = !!(condition);
   \
          |                                ^~~~~~~~~
    ./arch/x86/include/asm/tdx.h:155:15: note: in expansion of macro
‘page_to_phys’
      155 |         ret = page_to_phys(page);
          |               ^~~~~~~~~~~~

Maybe add the fix:

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 847252f520df..428243384696 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -5,6 +5,7 @@

 #include <linux/init.h>
 #include <linux/bits.h>
+#include <linux/mmzone.h>

 #include <asm/errno.h>
 #include <asm/ptrace.h>


> +	/* KeyID bits are just above the physical address bits: */
> +	ret |= (u64)hkid << boot_cpu_data.x86_phys_bits;
> +
> +	return ret;
> +
> +}



