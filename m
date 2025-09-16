Return-Path: <kvm+bounces-57709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A45B1B593BB
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 12:31:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D3E01881BE3
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 10:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EBF5306B29;
	Tue, 16 Sep 2025 10:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NHc3ZiVv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5CF2F6581
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 10:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758018437; cv=fail; b=MZpoE3tiaRURO/Vg1QjDM9H363EsfeP2yHNciwd7TIHhHEKBeSx8W+JvN+H+QX3bgEaYMFpliJv9mvffdzQyI4PTrjYWu2ihhbhNO/TcejXwPDRHNagcKL3rPGq/jiYPHDo4/NE+IT7nY4MUJiTaKdt8EId+iNebdxQX6vfPxbc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758018437; c=relaxed/simple;
	bh=kb3TTuKy5kRsaWvs85HdFf+C9q3gbNZhEIBXK1ksqAE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=INN+wcItTC3sJDnFpJoN3qcg/CCy6cJF/uWFJLf2YYEFtqtOBgL2Keueay9s+rBymH4+5Dq9RuaWO1H48PpdW/E1YAqKXSY0SEG1t7ehUuTIowOH2jOO/dtlMvmM5leBjiLuZL38JWBUIeYcv0HVHoFdk67VN7ZAStUUXHfPEEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NHc3ZiVv; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758018435; x=1789554435;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kb3TTuKy5kRsaWvs85HdFf+C9q3gbNZhEIBXK1ksqAE=;
  b=NHc3ZiVvjagqoH0+fsYJmSJIQ5WbbDkLm2jSgIx7a48VoYB9MbsCCalZ
   4i1B32YdbhntCjG5aEsgvtwcaLVYHzRZjyqxFiGrIYoVot2V7P/jVfBQe
   4fFrMta7QHqe7Ew60gDgGINDg6WWcHKaJz4YghSqL0LXvgE8NgDEsA2Vr
   RzqeiT70yz6rfMSUCwB0rVAWJ6xIol4+yJmVcjzpRhBJa8K3VkdTTLkD2
   HsjI9jJDM/PLWInFtX/YoSoU8AWQPIUnOxzR2pvwCBWFliBKZ/nV7baMC
   zr+lQL/dt442/rS83K8BEJwr0VZ8JDY7NIxgtbkQO/HiVikJqbSkY1f3f
   g==;
X-CSE-ConnectionGUID: PqIvcDAVQxWXQhRNC5AILw==
X-CSE-MsgGUID: o3pGlgV/QyiayR058AE81A==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="82890072"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="82890072"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 03:27:12 -0700
X-CSE-ConnectionGUID: 6XbbVJtvTumJryu6Y4VKdw==
X-CSE-MsgGUID: nQRBjMloTi2bXddHNmCaDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="174503919"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 03:27:11 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 03:27:10 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 16 Sep 2025 03:27:10 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.63) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 03:27:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PbJAPIkEYcqJkimKFaqCaxubkAOj26UWtGZo+uaqnR7mhL9DBfzw28hDM0TlgkgiNr5WTNZiRhl28+t60IXS7FkgWtNOHilffB4fnT4fBWDHXhFeDPKI0dQlcbwTvboWQXYd/1Evbj4BoZips/i3sjdMOm9yBUtdCzNEy90urYoBMzB+V7l+gnHsy8mdynhJQAjb0mW81KKMnGn+MMJUW4OQiduvnkwOHiKA4v90mTzS7jL7d+0SwVIo6h3PfZZ7pvIz4CpfvN00girLyCxtWcSOyAtBF2Yji0d9pXOu00ubMayr2+cyDqdP4rSRWUssU7x2Udx5l+SXz2RLqws2xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kb3TTuKy5kRsaWvs85HdFf+C9q3gbNZhEIBXK1ksqAE=;
 b=JSM9P9qX6mN/Mv0G5LXBj8knR+BA04kSt6ebqbZP+47T8CC/x6uzOPpHewvDMSKDSgLHwshbmF4J5GxrwL/qkL4va+CtviBrMZWIHhvSN6A7cQSnBotwLdpTInGlTHT5yxCzrHO+ADqKJB0tbxVB0r/LYnmWwbJGnLy1oXEs3yPH5LK+/0HYHF5ufOnc/3gY9X8v/tLLrVbjmlQs5HUUF3/XsxhrRqJJB8CtWMOcDXXapHS8whzSlscpB8YWvlxQB4wMM/QBQtHp//9gp+gbvLGEAgNtFkHp7BZUiR1kb6w9qBJ0TErswIc189/fMrbkMIqBBwi7+LcOYiMNEn951w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by CY8PR11MB7011.namprd11.prod.outlook.com (2603:10b6:930:55::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 16 Sep
 2025 10:27:05 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814%4]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 10:27:05 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v2 2/4] KVM: x86: Move PML page to common vcpu arch
 structure
Thread-Topic: [PATCH v2 2/4] KVM: x86: Move PML page to common vcpu arch
 structure
Thread-Index: AQHcJh86omC9Nm5qh0mOG0q54ZAePrSVnKGA
Date: Tue, 16 Sep 2025 10:27:05 +0000
Message-ID: <fa0e2f42a505756166f4676220eff553c00efb1e.camel@intel.com>
References: <20250915085938.639049-1-nikunj@amd.com>
	 <20250915085938.639049-3-nikunj@amd.com>
In-Reply-To: <20250915085938.639049-3-nikunj@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|CY8PR11MB7011:EE_
x-ms-office365-filtering-correlation-id: 8a92c38e-ef7d-41bd-8e6b-08ddf50b9550
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?OGZZVko2cHlsYU9QaUNyQS8wVlpLRDhTc29qUjZFMlREeWpnVXhMSnNQVU9Y?=
 =?utf-8?B?eFA1R2RoeHhyendnQTl4LzBWQlk4UXJUTXdMYit4blQvZTlreEdqODBaOFhE?=
 =?utf-8?B?Z0V6bEFLN3NlVmFKbDNtT083YWw5ZzZLWmJIY2ZyUFZmWGpZSVFyWmJ5U2pC?=
 =?utf-8?B?RW1lWTVjR0xXeFZiUzc2bWt6QWhYOE10UEJLZndCN0szc2ZWUnlQZGtGQSs4?=
 =?utf-8?B?T0xsVCtnbmhmeEdkc0ltR0FOb2pmM0Z2U2srbC9PNmtOdDE1OGl2d3VjREYz?=
 =?utf-8?B?aTVXMGZpUnozK1NCaFJ6Y0JjQzZpTy9aQ2JMWFV2L2dHN0Q1RDZ3RldQeVBz?=
 =?utf-8?B?bjlWbjgwbnF0QmVSWXFrMGI2b1JTdUhPaDRNSkNjZjlIdHJHZGxDUGE5TTVy?=
 =?utf-8?B?SUQwL0RUeW1HckJrZURiTWk4bTl5akpqZTEzS0dKd2c1OEMwdm5FcFcxWU9v?=
 =?utf-8?B?RjZ2MmRWZXltaU05bTdCdGt2N0kwc3VQb0p2c1l5YXpJbkNzMXVxS0xjVld3?=
 =?utf-8?B?OGdURTZxcG5DUG5lQ0c0RDJtMmE2eDlRZjVvOFlBL1c0eTd2VFNXTHQwb0pn?=
 =?utf-8?B?bUJ0VVM3Q01kb2tta013UEVTYVVGT2N4MmlXbnlYS0VkT3FaOHhLRmQzUkJU?=
 =?utf-8?B?U3E1QlZmNk1IU0dxd1FTRm5YNzBSYlhRdEJjWEJlcnQzWG1mMUtpWEgzdUdm?=
 =?utf-8?B?ZTVzdjRlaXNnMGtMS1pmM1J4MzhTcHZjRG5LcDJjUXFCbVowSDAySG13ck1w?=
 =?utf-8?B?TTRoSzJEbHNJRU9VTkRaTGRaLzk1R1FSM0JRZHJGNTM0LzE0K0hNck9JWTJh?=
 =?utf-8?B?YTU1NEpXWEp5NHR4Z3JaM3hiZS9LNUlhbGF1MDFPOHNCRW5CWU1tU2FuWm5w?=
 =?utf-8?B?S1BLcS93VW1CekVGMGxNUC80RUhJM0F1VHQxeWpZdU1PV0FwRXpZa1hTeTFZ?=
 =?utf-8?B?SXUxS3BZKzIvbWRhMkhtTm9PWDNDMGZzOFprRUlmTmVGS1ErdkthdmpVZ1lD?=
 =?utf-8?B?S2gzS2lGdkRBbkh5emQvbDJFQjlVNFBiaGJEc3djOG9BZnZCQWlReUE0RTdJ?=
 =?utf-8?B?SVpUQVIxUHF2cUR3TWU2aGMrRkhtNUNPUkpxSDJ6Z1FENzV2U0oxdzRqSFg3?=
 =?utf-8?B?NHpUcDFUeVhyZmcxTjl4T1NvclQ2Wk1VOXBSei9ncjZVaHZ0UTM2Qi9YYVdl?=
 =?utf-8?B?bmVmYkJJUFZDT3I4eUlsVjRnMG9uQy8waEI4Qlk3eUltRU4vK0FRN1V3bVpM?=
 =?utf-8?B?VHRDbEYzMW16aFh4ZnFFSlIzU0k4UGVDUXJhNUtoeW42TXIzYkpSemcxbzhz?=
 =?utf-8?B?eU9nRTJhKy84TUIxY2NzNndkYUZiMFJwRWNOdDQrbXh5YXJBZnlvNm9aMkRk?=
 =?utf-8?B?WUF4M1ZZSWxlQzFqdVRZYk1OZEk5T0JHd3NxbWkzbDE5bFhic3AvWnFCd0NF?=
 =?utf-8?B?WjZsbGpka2tadFhqK01CSTFrUXpOaEc1V21KU3UrazdwRmZTTnNZYXR1R3cz?=
 =?utf-8?B?VVBTdVMySDZaTGJSbGZmYkJoK3U3Mno4c0QrbTB6NFRmZ2dWd0plNjhpZngv?=
 =?utf-8?B?cVNrT1VyMlI0NnVHaTNJdGtxdUxlZmg5amF4SUxQZU1TZ2JWRS94eDhNZjNY?=
 =?utf-8?B?NCtzYi9laE9TR3JqT2xoZEl3bWNpdy9ZTGJjUW9EcEU0dlpXNm9ieUUram05?=
 =?utf-8?B?ejY5N3ZnY3ljanRMWXpmazkrVHRmemZYZURCWFQ1L0pKVHhwaHFCc3h5clB2?=
 =?utf-8?B?a0xjZ2QvYXlHdUlYaFRqRXdtMlpUSWtkRVZvbFlUWEk5TXRvcktGdGVJR20x?=
 =?utf-8?B?L1U4VWo3ckNJRmZLREFNRy9mczh3UnRkS1BlMTVHRU9NQXFzV1gxaU9LLzhQ?=
 =?utf-8?B?UEZFWHNNNkV0SUF4MmlhTTNlS2tEQkFyR2N2YkpUYktEYURtMGVrKzNBSVBG?=
 =?utf-8?B?b3R5TE1OUE9OaVFkc2lMTHU0Nzk2elBRSGd5THlEbVZhVWg5SkZZb1pKYjI0?=
 =?utf-8?Q?2jqXhY+T51RGdqDThVY0RaBhzA556M=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ui96Wms2ekRHQlFXYlFHbWhNQVRzUFRmTDJmVVhpVDkrWExlZDZWVWNUcmZL?=
 =?utf-8?B?VTg5c2IwN1BsUS93TXZEOUJPeGRVVUFoRXowZVJkZDJ6ODlhVmpoR2dKTjF1?=
 =?utf-8?B?RnMxM0QvRGp4ajFSUi9XKzl4bnE1ZUdtcG1Qa1U0cURzdXU1YkZIMERhNkZr?=
 =?utf-8?B?eXZYZmM3OWVDc0x6V3lnMGVWZFVRaGw2UFk5SERYK2EvWTllQUp3REhuSjVm?=
 =?utf-8?B?bXZmV1R4QnZ0VjhKRFZCTWo0NUUwUWRCTzFwYWoxdXFvZGFKZ2FZKzFtQURP?=
 =?utf-8?B?SDZ1MXoyMnFDNDhaTTFhZTgxS3ZBWEplVXJ2VkFEc3JjK0tESGFRcW4yQTI5?=
 =?utf-8?B?ZGZkUTcxYTgxdCtNRVZVZWNBTm41WUJxNnFjNXhLVkdUajRrRjE0bHpKUHhU?=
 =?utf-8?B?RndTTkMwTUNNaThJZFo2Q0NTVTlTK2lWTGpwZ1RQVDhvS1NpMmFoZkY1VEp3?=
 =?utf-8?B?R3ZHSG9xMkJCUGFFZnFkcU5yM1JwRTQvME5OTHVqNUd5T2w1bFJhbHJLRjg0?=
 =?utf-8?B?NzNiancxSmwya3hTbUpxWlVhRmN1YWxCcnlwV2VmZC9tUHNkeUdIVXh0NEVS?=
 =?utf-8?B?UEsrOGloZy9td3hqZUlaZGc0UnhmbWtuQXA0dnU4RVByY0k4UThpd1NVUFpG?=
 =?utf-8?B?SnltSlAxbzRrcDdLbkwwV2VNMmJPSTJzd05kNlpuL3d6K3hSVHlYeXorbVd4?=
 =?utf-8?B?Sk1qMkVLY1F0SzhUalZ6RVZoNGxUc21xWXNteDNzdnljSWdhZzcxS0ZuYlp0?=
 =?utf-8?B?VEFwWlpkUE81Rm5KbVdqd1ZjTlNMSTNaZk1PWStYa0o4R2tQaXNXVUE4K2Jm?=
 =?utf-8?B?UVdNQ3UwRTB5M2E0TFllKzhSbTF5WjNVNWU5Z2xXcWJuNExHM3duUlppaDQ2?=
 =?utf-8?B?b2YwWVV5djV2dUNsQlRmQkxpYk1IVjlBYzJILzhiVEpiZnlpZlhJem5RYnBS?=
 =?utf-8?B?UjJ2Wk5iY2tkeDdVMmZVUVFkbTRpTDREK2dLWUlLcTRZTFkwVW1HNFJLK1FZ?=
 =?utf-8?B?ZHl4ZE5MSUVyQTVGZ0VYTmV5S0RGR2svTHplSkJOOHdVcU1wY3FsbytoRXZi?=
 =?utf-8?B?Vk8zd29ycTdNTExYVWdKRU5iMVAvU3FPNHFDS1R5ZnE0K0ZtSEgzbVFtTW9H?=
 =?utf-8?B?WUtDRjhhdFlqbzMzUER5RDhRZjNuaDl6S3RpOUJCN3B1TnpnU0hHSnVsTHUw?=
 =?utf-8?B?d3VCdVE3YkRoRTdiNEpXa3JPRFU0QlN6c21XaU8zTVA3VzJHSWZuem4zektP?=
 =?utf-8?B?Yk1lL3R3Uks2T1JybHpXcDlMNlBzZCtuRTZ1TUczQW5HVUtVVHU1M25iRFN3?=
 =?utf-8?B?WUNIZE8rcnlhMXdhNmEwR1FvV290blF5dEJxdjhiREw4clRDN0l1aWZsTkJV?=
 =?utf-8?B?eTZndEsySGdLL0RhVjVpa2NLSjV6RUt0SU94NWpIcGZvTytFdWJhNWtsallB?=
 =?utf-8?B?M2tEcitsM1ZJVWNsSXBtNWNkQnU4a2NvRzlHZVJoTjdyelZGUngvT2lSdWhW?=
 =?utf-8?B?T08zT0VHZ05jdWJqRVowdGxtU2pobk5ERTNIdm1BaWlKenZSSWxvRHk0ZGtQ?=
 =?utf-8?B?RkJFN0xPdlMrbFJ0V1VWeVlCbEQ4WGtZSElNTjUrK0gxQkFQb1pSWkhTUzhs?=
 =?utf-8?B?dzk3cHNud0xLKzRMeFNlSFBjSDk1bFFFekxDckY3Wjl3c0tTaEdJaFJuVTc1?=
 =?utf-8?B?eFBjYVM2Vk1TN2p6bTk1QjJSd1kzL3JmVlYxam43dXhXR1JyZ0c0LzJiUnps?=
 =?utf-8?B?UTFMejh2WXNVd09XaHdZaGkxdlRxY0FEcG5lQmpsWkxhZVoxMitNNWVLMFNl?=
 =?utf-8?B?Q3hFZ0IzL3VtMTVITDhkUlNKNVg1K3lxOEYzOG5icE5RanVBQWVjdFd1anRy?=
 =?utf-8?B?RUlsSElIMzdSdGdhc3ZDUkx0T2dRS0REa0dDaEtPdUVnOGZMaGxUMGlLS3ln?=
 =?utf-8?B?UkxWaTVrNTdzZkprdElkSjlOa2t5ZVJKbEJBdldtZ0s4T3IzLytVMDM4aU9L?=
 =?utf-8?B?UDcyV0F5QVFkSEpXY0tTcHBwTmNGK0srM2hxVzdNaU5NYWY0czg3UkM0NkY5?=
 =?utf-8?B?Z1B3UkFiQTRsYmtHdHorK0FZRUFxZk4vZ3oxUnMrckF2eFNaNE9oRUxLYzgr?=
 =?utf-8?Q?6xStdhIXqrun2KEeEQrVG/GKW?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E6A9E5E138F1A44ADE4921CCC1DCC2D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a92c38e-ef7d-41bd-8e6b-08ddf50b9550
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2025 10:27:05.4482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XmxJGPEMZKhBJ2hvhHWqqYm6oatuU3TUzxhso2+jxLSkND7vlXo8g0vFsTkJV40mrQkV0cGm2gAYvqqpYQunkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7011
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA5LTE1IGF0IDA4OjU5ICswMDAwLCBOaWt1bmogQSBEYWRoYW5pYSB3cm90
ZToNCj4gTW92ZSB0aGUgUE1MIHBhZ2UgZnJvbSBWTVgtc3BlY2lmaWMgdmNwdV92bXggc3RydWN0
dXJlIHRvIHRoZSBjb21tb24NCj4ga3ZtX3ZjcHVfYXJjaCBzdHJ1Y3R1cmUgdG8gc2hhcmUgaXQg
YmV0d2VlbiBWTVggYW5kIFNWTSBpbXBsZW1lbnRhdGlvbnMuDQo+IA0KPiBVcGRhdGUgYWxsIFZN
WCByZWZlcmVuY2VzIGFjY29yZGluZ2x5LCBhbmQgc2ltcGxpZnkgdGhlDQo+IGt2bV9mbHVzaF9w
bWxfYnVmZmVyKCkgaW50ZXJmYWNlIGJ5IHJlbW92aW5nIHRoZSBwYWdlIHBhcmFtZXRlciBzaW5j
ZSBpdA0KPiBjYW4gbm93IGFjY2VzcyB0aGUgcGFnZSBkaXJlY3RseSBmcm9tIHRoZSB2Y3B1IHN0
cnVjdHVyZS4NCj4gDQo+IE5vIGZ1bmN0aW9uYWwgY2hhbmdlLCByZXN0cnVjdHVyaW5nIHRvIHBy
ZXBhcmUgZm9yIFNWTSBQTUwgc3VwcG9ydC4NCj4gDQo+IFN1Z2dlc3RlZC1ieTogS2FpIEh1YW5n
IDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBOaWt1bmogQSBEYWRoYW5p
YSA8bmlrdW5qQGFtZC5jb20+DQoNCk5pdDogSU1ITyBpdCdzIGFsc28gYmV0dGVyIHRvIGV4cGxh
aW4gd2h5IHdlIG9ubHkgbW92ZWQgdGhlIFBNTCBidWZmZXINCnBvaW50ZXIgYnV0IG5vdCB0aGUg
Y29kZSB3aGljaCBhbGxvY2F0ZXMvZnJlZXMgdGhlIFBNTCBidWZmZXI6DQoNCiAgTW92ZSB0aGUg
UE1MIHBhZ2UgdG8geDg2IGNvbW1vbiBjb2RlIG9ubHkgd2l0aG91dCBtb3ZpbmcgdGhlIFBNTCBw
YWdlIA0KICBhbGxvY2F0aW9uIGNvZGUsIHNpbmNlIGZvciBBTUQgdGhlIFBNTCBidWZmZXIgbXVz
dCBiZSBhbGxvY2F0ZWQgdXNpbmcNCiAgc25wX3NhZmVfYWxsb2NfcGFnZSgpLg0K

