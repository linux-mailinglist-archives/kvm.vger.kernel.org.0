Return-Path: <kvm+bounces-38620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 546A9A3CE4A
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 01:56:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44EF318927B3
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 00:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DC27130E58;
	Thu, 20 Feb 2025 00:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QWgUWtXy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00983214;
	Thu, 20 Feb 2025 00:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740012972; cv=fail; b=L+Z1fVTio/lzcDVPjuYE2af2TUAYuqog5Fz5ZkAga8Q6CTztjZ6qTAZWLOHc6teY3bWW85lSyIx4cGZPE9iu+ok8HIwpHc1eyGNs8GZ4PiCCD6phRwm8OWJacp1MQh3EgusB5Br9yT9EziyfTCF/AtFvJgZgoPiS3H5eOWiIc/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740012972; c=relaxed/simple;
	bh=ViTKkTR2k6sxeZZ0if7bDSHuKzFN7ZfjDU04OmeRzsI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JYKfvSZZ0Zw7EKzA2RasjD/BIf+Tpcg2Y0RxbyM30Kc/NzJlG79mRX/taPS7WLUazIcAUA45Si+rPk9osFa849Iz5odO05UYihcRemU9oKh6Nv80CkiY0QISZqH7KjvUqjfQw2YelafsnCDEfx2aAE8+8EW28GZQOoeTenjZNBY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QWgUWtXy; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740012971; x=1771548971;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=ViTKkTR2k6sxeZZ0if7bDSHuKzFN7ZfjDU04OmeRzsI=;
  b=QWgUWtXyb7LS8/syrvGwLAZeETOWRt8XEl11eQBQ9VlofbSUgmkN0WSk
   8LQJZtFMc1xvqxPuQxPbwJdERXQ4QbcfrCS6IIbCXBlCRcXmOgSX6CI0Q
   zVKX2wsshNkc7uxhd6G4NzYV2qfRbJ3OoYtlvHbCXrGhpKoiYXDBijIUT
   Cf/ahXqfEY70BzEGxDTrNCnjnSk6R1SMKz1S/TbH4ZpLTbqg5sZLAGqCz
   niHKJd8AvM6eqmuBhBhlhW4VNCasFnmxiHKlszDJvtkWc3I7+0zCGZI6W
   GXQT9epEkbYEeJlbwzF9hsBIkzePAsI1aZuDxEHNAIuIlhW8/mUTJknQI
   Q==;
X-CSE-ConnectionGUID: MxN2uqNdQ4aCrl6t2nWYVQ==
X-CSE-MsgGUID: qZ9/ku2YS/2bFGOzIbQh3g==
X-IronPort-AV: E=McAfee;i="6700,10204,11350"; a="40699059"
X-IronPort-AV: E=Sophos;i="6.13,300,1732608000"; 
   d="scan'208";a="40699059"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 16:55:59 -0800
X-CSE-ConnectionGUID: iewJe9SnR/+awFj0WNm9Xw==
X-CSE-MsgGUID: ViHgVXO6QomJoKelemEDTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="145768385"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Feb 2025 16:55:57 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 19 Feb 2025 16:55:56 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 19 Feb 2025 16:55:56 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 19 Feb 2025 16:55:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xr2s88VAtNa4al/MmrxfntFKebOfJ4not/LfnmNHEC8Xai6BpLDjIjTcf0BWBMws7TPndbRGx6NYFimB/15A1pA8LdR3rxsJ7tPJ7dvAPqqjvJvKR2KboD4m9mMyoVHQkiLueSTrA92RIqN3dAUVh+JpnjIGMnSRlGpv20kBLjq7GmS0mMvf+UAHUwSBb3VvwNmGFEqqN30Z+5OUn0GF1uxFafkK7OUk6fo/QZk7PItf0AAv/6Iuf7QvHK8upCDSfyE2w0C6e5F9VpxMnbN6b6QP3FgnGxiI91k+vZMDhFwJla4lJZkfvUtAJhkAXvu7UqMyQy5kw9l1d3YmjA6L3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pbF7izDIe06NsKURUjbk9u9AWt3gDJ0f2mXPJ2aujK4=;
 b=cZvqFc4DNEl7SdVUugOUyMhB8ALRryAGgKl06KG/y/A0AdPBYrllxHzg0lKsZ3CCIHaA3C1kjBvLSk56sSn7+ALBFM7iScqJzdDhojPUfYGnnZoO/8M0g974//CJ17b7lWSV8y0UZg0cLE2no7759AKZvnkTdzS53DZVqKY2LydziDls5Nj1bGBPQtnM5KpXtK+rVyk1qWXm3vnglfi93FE7WL/4fCJJDxbB1bhTphKxgQXSBC9HMUcJYLdUCyMvPYWyGQjnUuX9iBpLShbxXqNiAGQ9jkTRwgjQ9sKqgDy9bUmIn+loF5C1YjtKD/itQvcjq0baZ/Jo1SF204ihyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB6540.namprd11.prod.outlook.com (2603:10b6:208:3a0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Thu, 20 Feb
 2025 00:55:50 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8445.017; Thu, 20 Feb 2025
 00:55:46 +0000
Date: Thu, 20 Feb 2025 08:55:36 +0800
From: Chao Gao <chao.gao@intel.com>
To: Jon Kohler <jon@nutanix.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "vkuznets@redhat.com"
	<vkuznets@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] KVM: x86: hyper-v: Inhibit APICv with VP Assist on
 SPR/EMR
Message-ID: <Z7Z9iKOHf9VBKkoU@intel.com>
References: <20240806053701.138337-1-eiichi.tsukata@nutanix.com>
 <ZrJJPwX-1YjichNB@google.com>
 <CABgObfZQsCVYO5v47p=X0CoHQCYnAfgpyYR=3PTwv7BWhdm5vw@mail.gmail.com>
 <ZrNyKqjSiAhJGwIW@google.com>
 <028DBF5C-FB12-415C-B128-3EF275CF2A8C@nutanix.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <028DBF5C-FB12-415C-B128-3EF275CF2A8C@nutanix.com>
X-ClientProxiedBy: SI2PR04CA0004.apcprd04.prod.outlook.com
 (2603:1096:4:197::22) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB6540:EE_
X-MS-Office365-Filtering-Correlation-Id: 1107ed2c-0e83-4cf4-01bb-08dd51494f96
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NEZpMkY1Q2M3TzlKcm15VEtFQXI5MXpJWUhOT2doY2ViQ3phMEQwYzhzeHo2?=
 =?utf-8?B?b2w1dFliL3ZIRjRSMXlFK1ZPVWF3WXJTRkIrZUhsM3FEVTNwTjZDWnZNVFFO?=
 =?utf-8?B?SGdhV04wQlQrUUpqVlAzTUFyY1dnUUR6aEN6THRvMGkxYnB2ZFhYOEFYQ083?=
 =?utf-8?B?M0NwUDkyU3VjeUFDQmF1TU84Mnh5TzE5ajNpYmsvYTEvOGhHUmFTaGs3TVY4?=
 =?utf-8?B?MWFMVHRIN29HK2lJVWQzSkFXUzFsd1Q0WWlSZ1V6Y0I3Y1NJNzBEd283L2tz?=
 =?utf-8?B?cTkrMytwemppaU45b0RqSGp3WGUzTStMQVhLSGJ3L04xWHVnczVOUHJOV1lE?=
 =?utf-8?B?cXRsWTBEZXJmMWhQeVlTdGdPSkdGazIwR3F1ZjZnazRNWkE2UXpvOHhPQjV1?=
 =?utf-8?B?NTYrR3lMaU9aYlV3dzlQZ3o1ZkMzb0h5dlh0Y3JHT0RSdGxCMEx4YU00Z3B1?=
 =?utf-8?B?bnp2Zk81ak1aRDhidUpYRWJtVGM3U1BINllWcUFrQUZuclhFSmJNeStsSUJT?=
 =?utf-8?B?WUdzTmQwTHFRaWFlRE1tdVd6SExHanlKOS9BN0t6VlBJbks2TkYwdHVLVm5J?=
 =?utf-8?B?Qk5lRE1oS3FsbXpGZ01RTVpjSittbGVpbWx6MjhacGd6cVlMNmpOYlE3ak1B?=
 =?utf-8?B?M3hXSXkxRXdxZUdlZmlXMG44YmlLV2NReWlxZmpzMnRWUU8rOTQxQmQzdWFC?=
 =?utf-8?B?NGpGcTE2ZGJqR2ZQRXVmeW1BL005VTdBYmZQWGtEUmZaTElWQVJWUEpwS1BU?=
 =?utf-8?B?R2ZPc000d2lzN2UxOWcwQ3VndlFSTFFQY210MG1TWXNnZXR6eGQ1VGRKSms4?=
 =?utf-8?B?bTl3ZGxjN2Z5RGxsZ3pNcEN0bWw0eDZiQWJCMmRLeEt4VnIwdXVVRTh3UFQw?=
 =?utf-8?B?L0NwVzA5ZWxxZlB0MmJNRXpkRnV4S0taYXFDd2c5Wk43VGtCeHp6dmdVckVS?=
 =?utf-8?B?cVRITk5Fc1hZQlM4cjdsTlRzZlJlS1hMZ2RHOXU3eUVWQ042VXJSd3ZpMGti?=
 =?utf-8?B?VWw0T3prWk56M09HYUtSbjBPV0FJTU0rZ0x2ejFoUWhsdmlTbVgzRE1RdWly?=
 =?utf-8?B?Y04yemlMb2I5WnVVRys2T2UxWklQQTlEVUtSazRKUWpGaGZCdTcrMTFmNndL?=
 =?utf-8?B?L0NBYTViYTM1SW5EbVRPSnVabFpvM1RsNjFvNUxDSDJWV2dkdXFzaUtOdXho?=
 =?utf-8?B?M3lIajVUd2ZJdlFJOVdUaUxyMWN2Zzdtakl3TTVHaGJBMXg3a0ZNM3QrclFz?=
 =?utf-8?B?LzdxU3lKNzljeFkweEZPbmlIbHFiTGd4TXh5ZnZJUkVaNlNBeWNSek9VSmQ3?=
 =?utf-8?B?TlN1VG11UEwxcWltUjV5MG1aTTVRZE1wb0wvdHZKeVNmZmRoTTUrYjJjUWZq?=
 =?utf-8?B?OVVnY3VlZXpEbElibVM5NFRxUW5KN2U3RjhnOTEzUEp3dGtxellMTHRkSTBs?=
 =?utf-8?B?MGZxUXpXRjh6c2RtZk90cTdrYWllemh0Z051K0Q0WWhtMzJZc2NUQ3NEMFZj?=
 =?utf-8?B?c2N3TDg2eTNES2VuK3FjdTN1M3lsc1h2b3I3NXpmdmhJaWc5aTF0T2lrZlcx?=
 =?utf-8?B?eGpDd2pNZ2tMbzl2S3pTcElSdkhCSzdwYzdUZlBGQXI4enp3KzJRUmVldkxa?=
 =?utf-8?B?dFphcER0VWRGRzVtdVpMNUJDdTNIUVJYOEdsN0NoMVRkRnlqOXZhNEVCZW5l?=
 =?utf-8?B?SktobWU1eDBSK295SUk3NkdCWlcwaG9rMUlaVlNQSUk2MXptTFFuU2d4QUFv?=
 =?utf-8?B?SXh0UFlZSjJ0WjFlbSt5NlBrak5BYlZPK1JtN1ZLZkU2UExJU1BOQXhBWmRL?=
 =?utf-8?B?RFNuaE9uUnNZTHRxM3dLdz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFhZNE42cTJkYlBIc0MwcENhRDlHWUV1bCtER2JVWmpTbU53L1BJVzlQbFNy?=
 =?utf-8?B?SW9EQnN1STJGMm16em1YVGZVVHlndG1FNDREdmdzYlY2Z3ZCcGxFT1Vzb0E3?=
 =?utf-8?B?Y3hyRUIxYjNjNDJFdFMxRjRUNjhndDlsNXRDeTFlVmR4K0c0dW5aSExyM1d6?=
 =?utf-8?B?R054Y2RHOFI4UWdXSS9BNmkwY0tBbytLUys4dWtnV3BROVlORmJMbEJxMlZB?=
 =?utf-8?B?UTV3QUFOY1RRYTFIODFPb1E5b1FJNmJVOFRaOUduR2hIWHE5MzdjTDBqNmtG?=
 =?utf-8?B?WTVnYmhmQ2g2djR4WkVCYVJISStyc0N4eWI2cWgxYVBMUW9QQ0xaaFNOUm0v?=
 =?utf-8?B?dHVCNGkrV0ZJL3VEaGtTVTJwc2hYTFZkeTNXQmNZUndUVzIveUFGNFljTmtT?=
 =?utf-8?B?OFhWdlZ3ei9JdXh6bHJxZ1hHYldkcXZPbUt6aklVVms3QVpvSGVET2Z5dGJp?=
 =?utf-8?B?NFNaUlhzVXY4OUZmWDVTeDJjd0JxaDhOK3FNZENhQk5rem5EV0JCeUxRamNP?=
 =?utf-8?B?aU1JTVJqQWhZYTRVa2hVUzBycStYN2hDUlpwSnk0TkV2SDQvdWEzWXVEc1F0?=
 =?utf-8?B?ZkZCUkpKUWJSdXdIK29XcjN1em5pVU5tWmF4dnhyblN3TEloRS9zaHM4TC9B?=
 =?utf-8?B?ZU1jK3l3RzRpWnJ1UThkUk9vazFkd3FzNDZ1NG1lK3AxUjdGSzRqSDRCTlhG?=
 =?utf-8?B?WThkZncxZWRmTE5XU3M5SjhXYlV0QmtXR3Jjdm1PVHNGMzM2OVJxOThmQ1Ix?=
 =?utf-8?B?ZTh6STBzSlJJSnZWY1lvN1hLSkxCUWFoV2pkZE5yMm8xNFVIZ2w0UDhNVG9w?=
 =?utf-8?B?VzhOUjJGb1FwcWdqZDFYY0hUaWhadlRZdG83ekllcXZ4Z2JhRzViNTFTVS9H?=
 =?utf-8?B?bmU4VGxuL0pHd25waTlkd0htL3Jzelk3S3FabTBSNFZrdkU3SnF2Q011cUo5?=
 =?utf-8?B?ekN5eFpEQmRVT09lWDEzaVB3NXhyMzFPU0Z3V2d6clhsRkk1SVlPSVF3Z2cx?=
 =?utf-8?B?Uk56SDRsTEtySjBXWmdsWGZOMDNPaUd3S0FIQnZWdXpPK0lNTDNCVjIxTisy?=
 =?utf-8?B?QkNwZUlGaEdwbEtXbVpkUGVxWHczaEduakowWUVnME1QME1aRU1hbmxZVXpr?=
 =?utf-8?B?d3VvKzZZdGdGNFZMNXp4V3lWWFFXWU1BYjVkQWFlTklMazNrZkJGUEUrSUNj?=
 =?utf-8?B?RzlMaWJvbW9WTTM0Wkhsc21Xd0xtQ1BjZzhEQ2NKbkxIWW9GcSt1cm1oT0s2?=
 =?utf-8?B?U09BYWZGT0dBWTNnOVJLSWU4TEkraGlWR0E5WFNKcjVzK1JRYXBSQ0Vmb2RN?=
 =?utf-8?B?Y3c0am9yU3BsOHY4bGRBdWNIb0tKNjhOOXpKcGNYUzllNXJSNktWUElmQUdE?=
 =?utf-8?B?N093RVVCNC9vWXRZVmdXUiswOWtURkVINjFONngvOU85Ui90WUpMRnVGUkZ0?=
 =?utf-8?B?eVJyMFNPYy8zYmJZRHpnZWpEOHFDL2V0YVdHNFdtUXRvNkNiZ1FsVSs0aFE3?=
 =?utf-8?B?Z3pQS01XWU51ejVuSmdCTFdyRjJVakY4K3BKWDdNNkFESWxmMVowNmlkZGIv?=
 =?utf-8?B?N1BwTmJBUHdFek1POVlEd1BNOTVneXQ0c09kYTcraTJaekJSNHVRRUJIZDFz?=
 =?utf-8?B?VW50ZThVVXJTaUJLRjVOOWhNUEFUNC93YXFtdDlSSEhPQVhQazhlemdmbUZv?=
 =?utf-8?B?SDlDZ3VmYjhQRC80V3prM0NOTk1vREFOKzU4djBuSm55a2FxV3FWWm1EMVBK?=
 =?utf-8?B?L2JvUTB2S0VOVnBhN3hmem13NTJkOU52RXRsdEZIbjR0WkxEbVBaaTNYaHdW?=
 =?utf-8?B?WE5VSlpEd01lL0QyT2FhOVFoekdjeTRwUG5qZUVlUHFSd1dUQ1VjeWlBL3Bs?=
 =?utf-8?B?TzA1RE9xcGlxNFRlSXlLVkZWTkdSdXJIZm11Q2NZNy9aaFZqcVdLK2d1QWdk?=
 =?utf-8?B?T3dTTVl1ZGg0eVZuaS93R3V5UHVPVWNWZGhZWWpkMFhZRXdnUlNBbGYvNURB?=
 =?utf-8?B?ZkRMblVlZ0krTFlwdWx3K0d2c0o0UWxuaS9BeUFKT1pDWE9HL0UxMmhsaloy?=
 =?utf-8?B?Tm1yaXJoVXZhV1pqK2NwQ1I5UVNiekhMNG0wVmdKUHZHVTUyZmZYRW13ZmQ0?=
 =?utf-8?Q?dUwTNpgv8OIsmuSphZcoXYmXO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1107ed2c-0e83-4cf4-01bb-08dd51494f96
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 00:55:46.8421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OTwxI7tCuRTMHAXuXtRim0+iiMFAf4lM/UKsFqJtsmeJ04gqgmMjIvvfOmy8M7KAEnVEzzR0WWZAo5qe/x3EgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6540
X-OriginatorOrg: intel.com

On Wed, Feb 19, 2025 at 03:03:39PM +0000, Jon Kohler wrote:
>
>
>> On Aug 7, 2024, at 9:10 AM, Sean Christopherson <seanjc@google.com> wrote:
>> 
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>> 
>> |-------------------------------------------------------------------!
>> 
>> On Tue, Aug 06, 2024, Paolo Bonzini wrote:
>>> On Tue, Aug 6, 2024 at 6:03 PM Sean Christopherson <seanjc@google.com> wrote:
>>>>> As is noted in [1], this issue is considered to be a microcode issue
>>>>> specific to SPR/EMR.
>>>> 
>>>> I don't think we can claim that without a more explicit statement from Intel.
>>>> And I would really like Intel to clarify exactly what is going on, so that (a)
>>>> it can be properly documented and (b) we can implement a precise, targeted
>>>> workaround in KVM.
>>> 
>>> It is not even clear to me why this patch has any effect at all,
>>> because PV EOI and APICv don't work together anyway: PV EOI requires
>>> apic->highest_isr_cache == -1 (see apic_sync_pv_eoi_to_guest()) but
>>> the cache is only set without APICv (see apic_set_isr()).  Therefore,
>>> PV EOI should be basically a no-op with APICv in use.
>> 
>> Per Chao, this is a ucode bug though.  Speculating wildly, I wonder if Intel added
>> acceleration and/or redirection of HV_X64_MSR_EOI when APICv is enabled, e.g. to
>> speed up existing VMs, and something went sideways.
>
>Hey Sean, Chao, Paolo, quick follow up on this one. 
>
>Eiichi was working on pulling down Intel Microcode 20250211 [1], and I had
>asked to retest this one.
>
>Knock on wood, it looks like the issue is “gone” with 20250211 on SPR/EMR
>
>The EMR [2] and SPR [3] release notes allude to some Erratum regarding
>some vmexit fixups that sound interesting, but I’m not sure if they are actually
>the backing issue,

Yes. EMR137 and SPR141 are exactly the backing issue and have been fixed in
recent microcode releases.

>or if this is sheer coincidence, or if there was another fix
>but just isn’t fully documented as an errata?
>
>These two are listed as “fixed” in the release notes:
>EMR137. VM Exit Following MOV to CR8 Instruction May Lead to Unexpected IDT Vectoring-Information
>SPR141. VM Exit Following MOV to CR8 Instruction May Lead to Unexpected IDT Vectoring-Information
>
>@Chao - could you help confirm our observations one way or the other?
>
>[1] https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files/releases/tag/microcode-20250211
>[2] https://cdrdv2.intel.com/v1/dl/getContent/793902 (EMR microcode release notes)
>[3] https://cdrdv2.intel.com/v1/dl/getContent/772415 (SPR microcode release notes)

