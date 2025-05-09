Return-Path: <kvm+bounces-46058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC85EAB10D8
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 12:37:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20C45520A6E
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 10:37:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7739228ECF5;
	Fri,  9 May 2025 10:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="joXyiQ1U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBB128ECD2
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 10:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746787064; cv=fail; b=qKwqI59boJND8W6iWcaOtTGgVm3FIt8ED07HMzaTcsN3jB+x1gIs/EO69FQOMAt6IbvsJHMYatce69859obIOu2S0cvuLK/Dn1Oq59sCBW3hZyvcBjjsrgjb0dbjRUjC0PcZ/3020JRuvoIQSgb5GGM9/Nc8sBbrPOuiKZ5rLPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746787064; c=relaxed/simple;
	bh=z0sDnzzerfh16AIBmvSS8a7Ul1d/vnx9qISDo88HAaM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Br9bGf3v9WkDYIA6bXxiKinyV8mV5hd1c8RyuV6NG8GSPsT3VvyHdtLoi7gZc3uxWtqKhVu9CGqPWVHuSs2tc93heYVK8euDyjEkBguTuyUvoMVe7P1EiY+i/HwVKeWJYqlsA+OMZIwtm3cLyYK3w3+e3hv5yIDOsuRZtguKy7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=joXyiQ1U; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746787063; x=1778323063;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z0sDnzzerfh16AIBmvSS8a7Ul1d/vnx9qISDo88HAaM=;
  b=joXyiQ1UnG87knNz75i4lx8al8JvRPUggdMnsa37lIbpbhKHhH2YOhSi
   CQl5I4NF2ifTbVfpAdSsf9kMS6S8OBmUD8mCbG6dPnBaG9OWslqrvk1Gv
   A/AhOhC69xtWlSnA7baP2r2R91ztoX47VxiL6OFnZlkgpNB/tW4gtZASu
   xfKMdJxZ1FvzwwjKL1ikGX0XyHLypmdchmfqoM8xTO9KrWI3IoPVxB0rZ
   Q6Touhwdf8U/AYGxeWGSPbPqfseI4iI3D1o2Ng3MAgalxvRAOEKiwIG/H
   No3WBHu4ZItct977FeMl8+aJ8PNSfQlwGL7GoQyptgtiA7vcyKbh/48pk
   w==;
X-CSE-ConnectionGUID: xpIcF38yTYCyGfbDHVZDYg==
X-CSE-MsgGUID: xzBUjm05SPy3miTQ19XA6A==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="51267894"
X-IronPort-AV: E=Sophos;i="6.15,275,1739865600"; 
   d="scan'208";a="51267894"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 03:37:42 -0700
X-CSE-ConnectionGUID: syFRneFvQj6PHL5lmazmMw==
X-CSE-MsgGUID: LrrQiRXLQ2qf//fGkWN7xA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,275,1739865600"; 
   d="scan'208";a="141689004"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 03:37:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 9 May 2025 03:37:41 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 9 May 2025 03:37:41 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 9 May 2025 03:37:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xkymHQVQH9cKWa8xX93H57FGejPzbK0Ysqx33oYYDq672xI37GxbCYa3w9JFrlEVEu4WRYsupHsYqGumQTcONoUclZvDcUdRqH+4pU/C1L8tQdcQ+TKwLnMsarY6Z7eGQL3wPk0LilD6u2d7GAtbw84dhaa6DLE+9gSNZgVjxbw/JjDtDPKB9NeYGibvj9xmw/hPLAInOM7WFsu3dvvtQXVneHZa/XT8Q+5FU3M78YTCrXNOSxOycinlJUzqjxStebo5M6vaL31WWNd0qLO9Kl1GtZg7FEUOtrzwpNo8Nbv8YryGktPXQ5SXcmN1nwwTRFZLyYHGqGrsIlH4LPc1jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gGk54g4BtkoU71PF3YN4B8Bm5si6Juqp6bYMwymnRYU=;
 b=mhlso42j3xxbO29gJze8Mb8KedfCt+Dwwip3rAuC9xBb0qxJoMU2cY4M+HEwiRzZ/o5Ah6+6ozbGeYZoyNWw1YCYVcDaAz0+DL40XWY5Ni/tA6KN4uvxh09Ucr/6JxqDoJUORbQ+4gRU9yTzprh174zLnPFJGCuhXlyM+da3uPaCC9AYxs9yzAPThANzf74KGxn92euRZNw+mhoDfx3yZ0tOmIHo77may15irZKdG+Mkc1xRutYGk2lmx264r1r7r0/q3h2FGqplkXBn+pCcrCyWEPiTGzKbCrR5x2MvWv+HfZENwRiYkNjQ8sVwcPUbkIfqy2eYR0qejGOo+8Qmrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH0PR11MB7469.namprd11.prod.outlook.com (2603:10b6:510:286::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.26; Fri, 9 May 2025 10:37:38 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8699.021; Fri, 9 May 2025
 10:37:38 +0000
Message-ID: <61762920-5860-44b0-a7da-0edc50f513e1@intel.com>
Date: Fri, 9 May 2025 18:37:29 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/13] ram-block-attribute: Introduce RamBlockAttribute
 to manage RAMBLock with guest_memfd
To: David Hildenbrand <david@redhat.com>, Baolu Lu <baolu.lu@linux.intel.com>,
	Alexey Kardashevskiy <aik@amd.com>, Peter Xu <peterx@redhat.com>, "Gupta
 Pankaj" <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-8-chenyi.qiang@intel.com>
 <013b36a9-9310-4073-b54c-9c511f23decf@linux.intel.com>
 <b547c5a7-5875-4d65-adea-0da870b4b1c2@intel.com>
 <96ab7fa9-bd7a-444d-aef8-8c9c30439044@redhat.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <96ab7fa9-bd7a-444d-aef8-8c9c30439044@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::16) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH0PR11MB7469:EE_
X-MS-Office365-Filtering-Correlation-Id: fb6b2f08-297f-4a47-98b1-08dd8ee58477
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?amdRVCtmc1V2Q0dFZ1laVEtyaG9YdEdvbTdVUTJMK3lmSlhKQjZrc0ZOclJP?=
 =?utf-8?B?cjB1dlFIVTFHRzQyUzlaY1BCV2lFQlF0SEswTXFKREwrTDh0NGw5TjQyWXNY?=
 =?utf-8?B?MjVOQXNWN2NjZElEVG9pcVJaV3Ywd0dWWlZXWVkyd08zOXg0TmdEOTRKLzhi?=
 =?utf-8?B?UWFweTVtVlBFOTlTaVJGNGl4YzBuTzZsWFZTRC8yZklzNHBmb0g5Y0UzUThp?=
 =?utf-8?B?cW1iVUZNVGFNS3BEbjlDbldPR1ppYWZWZi9nYVBtUlBRMEN2WUlpcy9xVXo5?=
 =?utf-8?B?YzNURTgvdSsxbllnSmlBaEZUU0JXR1l5YkdmQURqUXZkdWM4RVpQNnZoUlFR?=
 =?utf-8?B?RmQrZnZoSHNkYjRwbU84dFQvdlBJL3QrSnM0L0hjMmhYUUk5SG9RV3V1VjBC?=
 =?utf-8?B?RldwQjkvZTkrbVJvc0h0blpTRmkxbjNjTlUydnlWcjdwOW81OTMvOC9kQWVZ?=
 =?utf-8?B?WHNTaHdSbUE4dFpNa1VDZG5DTGRPVFFWSFMvNWlBSmhrbGIxWUNPUG5KV3dT?=
 =?utf-8?B?VmlwU1JWNlN4REo2ZnhaaElBMmhiWFNPNlg4a0FFZjhFN0NyUE1MdEE5eThQ?=
 =?utf-8?B?eFdHdkpSaXJ5NUc4WUo4ckFKZ2swVlVIaERCclVQR0ZUZm02MVRObzJpcXNN?=
 =?utf-8?B?angvYWtMMXhBSm1OSXIxTVF0azNzdmJ4T0Z5b0NLWTduUmFaRjZzMFhHRjVv?=
 =?utf-8?B?VTZ2cnVSTlo0dVIwYUVQcWUxMEkybnZNNCtYRTFtYlE0ZDBSeXRBVDFnaTE1?=
 =?utf-8?B?eWJqQjU3RUhIc0lsSmo4MENVb3o0bS8xT0VCdEpqZ3NtTVhXODdwWlNodU8x?=
 =?utf-8?B?RHZCeXpnaEM2U21zVlNsbVBVVW9GNFhwcjVzWDZCV2VvTE5JWllzMklyMVRh?=
 =?utf-8?B?STdkWE03bUJzUlB0ZlJra3hGazB1bEFSQ0ZuR0xBc29FeHB5RnMycENKNStl?=
 =?utf-8?B?MnpWQ0pSbDQ3elhtYTQ3eDdsQmRyTnU0Y3lJRGJFU2tLdVFiZWloWGc0SXVm?=
 =?utf-8?B?SWptQk41Y1JCTmRZYStORTdPaEhTRGZWZVRSK3h3dzhtOGF0N0FEMlBjVFZn?=
 =?utf-8?B?M2JhdHNJK3ZpaVdobDU4ZTBtNTRWTEszeHJ5dVpsYlYvdFdzR2FnWkZDK2o4?=
 =?utf-8?B?d1A5TmdsU2pyTkwxUTV6VDZ6L2RKL0RTdkdYbkdVTE55eG9WdmZGQ0xqK1dD?=
 =?utf-8?B?MkZMUTlZY1JxUGVaNEl6WGZMZnFHMldTOUhGOGJ3L0tKbzlpQTVYeWhVUlhZ?=
 =?utf-8?B?QTFoejVwWUwwZzNxVStVbE5pSllLRjFLMUQ1RjNkRFFJb2p2S1YwMEVxeEh0?=
 =?utf-8?B?a2pmRnJIWVE2OEw0azRhYlUxeGdFRVRtOVZvdm9WK0VReTBLWEd0VXhYcjhs?=
 =?utf-8?B?dUZKeUVBVWVKR0IrcTBCc1VMeEZoSXhJWWh6Z1I1OUt2N0d0bnJuSlh5SHpB?=
 =?utf-8?B?eEIwWmNYSGpoeUw4dXQ0L0xzMDdHNmxDdEx3MzRpV24xd1JhZVpESytlVHNj?=
 =?utf-8?B?RENvWHZqRUMxVFk5SDZCc1Q3RUV4S2R3YWFacHNnMlFlbDJpM3E0eXVuZjBE?=
 =?utf-8?B?N25PZEpUcXZ4Wkl4NG9seGowTGlWb2VQbmN5a1UvYm1ONVc5SVg2Nzg5QWwv?=
 =?utf-8?B?Tk9KUWJuRHpwZ2JLMk1uN3dxdHFUV0M2a2pEKzRSS0p3V2hBbkpDQXpTeEx0?=
 =?utf-8?B?ejkxTUFpUmJKUlhjRmRIUThqaHBheXBhLzJCZy9sYmljMUNET09mckdqdHU5?=
 =?utf-8?B?VmVQKy9KL3k1d0YrbHZWbkEzV2l1bDhlY2d1NzFTTEEzd2FHeW5yNWtRT3gw?=
 =?utf-8?B?aEVVcm92UXoxcTBUb3JDRW9nOHlrTWt2dVVMZ09NeUdIdFVjZ29pSmdOYTJV?=
 =?utf-8?B?Z2o1NDlPYjhHdmNtUFEzQ0gyVjVNSXVpbHRtcFZTWHhwcm8veDZzK0plbEVv?=
 =?utf-8?Q?pUG4l9ZkU/w=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHIraVpmeGJoMXh1QXBQTjVLYUJVN2xHUU9LTkRFR0NQbHJmOVZ6Z2U2RHE1?=
 =?utf-8?B?azNlUXQrdFFsejkvb09hMWhhb2czY283djdjYjhNMkt5bitYZmJrdVFtQWdr?=
 =?utf-8?B?ZVJzVE1kcEVJamZzU0FISXA5OXQwYzBvRHpVd01xcG9yZitpc0o1NlcwMEND?=
 =?utf-8?B?VmVSVy9WbXMyY2pFTUJUNmJ1bXlzdUtndHovTmdOTk5CeEZETENRUUJkTng3?=
 =?utf-8?B?RXlaYnpUZ2VRU2FQU2NRR3JBQlE0cEJVWTVxMVdsNTQ5OXJQUnYxSUZ6LzY4?=
 =?utf-8?B?ZzM0cnI5RXdzbG1LMW9mVDgyNnFTSTU5ZGNMaTlhcFZCZjA0QlhoeVpWOU9T?=
 =?utf-8?B?eUhndjUwdVFyQ2h1TVIwTW0waVV3bStrOVZoWWhJMnFaS3R1K2F5ekRyd2x4?=
 =?utf-8?B?T09oQjQ5RzJTUS9iWmRza2hZaEZ6VEE4YVVsRjZiSWFHbEtIOTZid2FpNFYw?=
 =?utf-8?B?VmZSQ2lMOWlCT0FyYUJGTHB2MzhWOHlCUWkvdm1oQTRDYldEL3ROWUJXWGVX?=
 =?utf-8?B?VHRnTUdYYnBUaXdwb3lFZitOazVFUHorTlZ0ZzBIQnhVWGlwc1ZEQnpDRW4y?=
 =?utf-8?B?NkhMZ0E3WVZjTVZ0TG5Ob05sVWhoc0l1MVhXRTZ6aEtkLzF4YWpYZGJLVGhh?=
 =?utf-8?B?VWpzVEh0eGEwSHFLZFllVmJsM2kzcFl5bHQxRHRtZEVMNytBQnovUVZ6RDlK?=
 =?utf-8?B?cG9BVjNHbUJ1UkFweW9ERVdkV1Z5WFErMXdGeVBBQlVJYXFFQ2pINndjdkNI?=
 =?utf-8?B?S05GRUNISFMyemRZaitoLzFYTkdlT1lzQnVza2NFSlo0Z0w3c0pEUUFSdUp2?=
 =?utf-8?B?SXZ2bVVyUFZvOU5sdUwzU3RVemFCL0x2VWM4bmRMS09PU0xyRGJ1T2hIbTJm?=
 =?utf-8?B?cTBYb0xVOVl0QmdzWnhVMnZtdktwcE5jcHhjV1lKbUJjL0oxWE5PN3l4UFdO?=
 =?utf-8?B?UVM2RTczTFFncHhFdXBscFFIYjltd3RMc2ViR0FnM05Yc05BSVp4M3ZMN1Nm?=
 =?utf-8?B?OTZZU3ZzekRnTkRlMjdLTGcxQ3FFT1p0eC9KVkZkZ3JEOWVHM2Y1a05lNFFY?=
 =?utf-8?B?SENKU2ZrK3VFTkIyRjVCSS90NnpVbEQ3aVFJMmhBd1JJZStFaGtnT0R5bWNG?=
 =?utf-8?B?NVJENUJ2UTloSzJSYThIVHZENGJHL0NFMFJDZWlqc0U3VEdYVVN3c1o4blIw?=
 =?utf-8?B?TnByc0dKRzhGNTltZlR5VkYyaVdreW5Yb2xZaVRzU1FtRXk5V2wxbmQyaFU0?=
 =?utf-8?B?V0QyOGVhRDV0ZFJPcnhIUU1NbUV5eUFrSllYek5oOU41OWowczNaM001REdE?=
 =?utf-8?B?UlpXbEdtek9HTXpndzhrNi9YdWpRV1dFVkJ6Nm1aZzBJSXRyMTVFVUxjNHQv?=
 =?utf-8?B?TlZkUGJ1MTMzcnhWNnZGNDBCR2svTy9ZQmpWVVl3Y3FpRWU1TU1UbzM0TEYv?=
 =?utf-8?B?cHhUcDNKMVZFUk5DRW1pb2h0eTlHNXJjclM1djJFZWQrM01EZGN6ZWhaS0xx?=
 =?utf-8?B?bjZ1a0ZOT3BQYXh0dkpRaGxYM2lVdnlzdW9iQk1TMVFkbXVia1I4WU9mZUZn?=
 =?utf-8?B?UlVxNUhPMWxuT0dWY09Gd3AzK25YdTNhUGFhaTY2SWhJMVZIL2dQOC94MUlC?=
 =?utf-8?B?RVQ4clVrR1MzWTV0bk1HVk5td01XYXlDMWlTVzhQNnRTdGNyRDlOWmR0V25k?=
 =?utf-8?B?VzZrVkJteWUwMWxiS1Bkc0poazEwbzJyZTlDek8veUZhVjBWcTJscnBQaGoz?=
 =?utf-8?B?NVd5V3FnQzQvV2tET1RTTTVXV2I2VHN2SGNPQmJJRzJkeStPMW1YUlZKV3VV?=
 =?utf-8?B?L1ZmRVBmc2VoQjhOMXlvY2lhdlZKYXZQNlYrOGpYc2d5Y0xjMGJCbERXS2lM?=
 =?utf-8?B?V2dYTjMvSmFDY0xKQnN6dUlLdVRqTGF6RGV6M0x3S1hyOE9ISDJoVDJTbXRs?=
 =?utf-8?B?eVBvSXErOGlTOVB2bzZkUFdKdHBjRVRxTlNqN3VHallHL0ZabWZtcE1oMTNE?=
 =?utf-8?B?dzduQ09YYysxK3I2dmgyVjVyVEVjNnlVQ29qV1NQQjdsbTNRQUpydFNwYUpH?=
 =?utf-8?B?dDhpOEZTZ25tYWkvNXB5dWJHTjZmbHhMTnN5aWxUb1AxT3QxOVZMTkdCbHI2?=
 =?utf-8?B?UkFEb21qRVFnSUJKeEtqS3p5MGt5clNIdHp2RUhVVGxlbjZwZENOYzVEbWZp?=
 =?utf-8?B?akE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb6b2f08-297f-4a47-98b1-08dd8ee58477
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2025 10:37:38.0744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uJX7/7nSl6q+tlXnv1FlidO2hkpEt8WhFcNbnXpIZ50aQ07JrzhkNEbeNZ3dzI7qyC+XYgvfBbfPxFTwodbZSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7469
X-OriginatorOrg: intel.com



On 5/9/2025 4:18 PM, David Hildenbrand wrote:
>>>>
>>>> Signed-off-by: Chenyi Qiang<chenyi.qiang@intel.com>
>>>
>>> <...>
>>>
>>>> +
>>>> +int ram_block_attribute_realize(RamBlockAttribute *attr, MemoryRegion
>>>> *mr)
>>>> +{
>>>> +    uint64_t shared_bitmap_size;
>>>> +    const int block_size  = qemu_real_host_page_size();
>>>> +    int ret;
>>>> +
>>>> +    shared_bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
>>>> +
>>>> +    attr->mr = mr;
>>>> +    ret = memory_region_set_generic_state_manager(mr,
>>>> GENERIC_STATE_MANAGER(attr));
>>>> +    if (ret) {
>>>> +        return ret;
>>>> +    }
>>>> +    attr->shared_bitmap_size = shared_bitmap_size;
>>>> +    attr->shared_bitmap = bitmap_new(shared_bitmap_size);
>>>
>>> Above introduces a bitmap to track the private/shared state of each 4KB
>>> page. While functional, for large RAM blocks managed by guest_memfd,
>>> this could lead to significant memory consumption.
>>>
>>> Have you considered an alternative like a Maple Tree or a generic
>>> interval tree? Both are often more memory-efficient for tracking ranges
>>> of contiguous states.
>>
>> Maybe not necessary. The memory overhead is 1 bit per page
>> (1/(4096*8)=0.003%). I think it is not too much.
> 
> It's certainly not optimal.
> 
> IIRC, QEMU already maintains 3 dirty bitmaps in
> ram_list.dirty_memory (DIRTY_MEMORY_NUM = 3) for guest ram.
> 
> With KVM, we also allocate yet another dirty bitmap without
> KVM_MEM_LOG_DIRTY_PAGES.
> 
> Assuming a 4 TiB VM, a single bitmap should be 128 MiB.

OK. So this is a long-term issue which could be optimized in many
places. I think it needs more efforts to evaluate the benefits of the
change. Currently, maybe put it as a future work.

> 


