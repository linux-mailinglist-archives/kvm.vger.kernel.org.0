Return-Path: <kvm+bounces-68495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 736E5D3A57E
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 11:44:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E349D306117D
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 10:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A08730E0ED;
	Mon, 19 Jan 2026 10:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UOJxY1IU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA0330CD95;
	Mon, 19 Jan 2026 10:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768819267; cv=fail; b=J6WVZI+8DtwEP3/pV0mdKJmYFN9tOAwIELiWP16DVFYsW9Diccef+sFIsZiZEdt9bbiUpWmTmH8BpnxKBwP8thIwQtoWWYwSvVUoSoxiEQYZZeBCV411iMZfyM0c0LgvjKXZP77yncViFKYHabqJiOhG5mFVcXdYXJqD6eo/tWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768819267; c=relaxed/simple;
	bh=+kMg/DxHh1RPxnvy3xY2UmDZg+w3uUy6sI37iqhI420=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QOyVO3kcHjkMYakPtcz1Loc9IYeINqz0M4BDgMcl8ji00elAV1+Da+c1gG+2mTuPPC0W6TYP4NZx4Sz1V9AU7EzDZ8uAgkOJB0kzPMoJ9Z8uYINzCTQ1EU4ZIk462X0pMp3HOu44e+uCD9SnslhVoq85UI+4iVTHdksrWVpiHy8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UOJxY1IU; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768819256; x=1800355256;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+kMg/DxHh1RPxnvy3xY2UmDZg+w3uUy6sI37iqhI420=;
  b=UOJxY1IUogXi5qark7DrabU1XD2JgQ9u4eqRaIBwaDmunRGTqPQKQEot
   qauXyqQkdAuhbJZYCceBhlmoZjxnzu5G+FzbgACanYbIkgZR46ErzH6ec
   UmL6MJ+eLzEqaGjMLIORvJafGiQ6HZblJtsdzVCdhfdNOP+MS2OFTDlMB
   AZeVIKtjqaWHgVFKuMUt73hTd8JyOtoHYPb3JtkaBkm77sXLh8cJwJ1XR
   mZpofDAb+rqBEDOAg0/tN3ZJOSW1xadqA39H4SrC8fdZ+jA7oVURIWnR4
   zelLJhbcC2zOVXihnNmMOU2SWsiDlmN4wHOXODcEAF/G0FSf2H1wLEOLN
   A==;
X-CSE-ConnectionGUID: +MI4kqzkR2GEvloD80GNQA==
X-CSE-MsgGUID: inRn6tBkQDGBjdyClI9I1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="81470671"
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="81470671"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 02:40:56 -0800
X-CSE-ConnectionGUID: fv1roj+5QUqBz0lkYmcwhg==
X-CSE-MsgGUID: fZtXw5GVSdO7NOEuOWzRfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="237105556"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 02:40:54 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 19 Jan 2026 02:40:54 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 19 Jan 2026 02:40:54 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.62) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 19 Jan 2026 02:40:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KKz1+EsKbb1+72nlLA6ba1VHQjyHctcGvJu9cu/USvqa3Aau5OwK29p+7dlNQZCi36DoklKqhhkEn3H+EU2UKXM0uulfE1NFUxM/TyAig5/TpV9zuxEXhm67UwLlTJFdnuW4wXXyQBBI0/X878wLvS9XPNEcEpxPSgqF7OhalXjpAxxRviD0DJHfbyLnrUhX4W5ptmAtfwXrjNzxAhBiXsQIX3XVZ9N9fEdMMf6/vd6KwB+QIl6uPgpWD3Oa18yQOuUnH+skZjNrSaFFhK7JmTp5sggYFr21VjKoE6wJVX1Nl8XSkJ5akuroFHE583sAuan7673LlWFhFPatmnm7Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+kMg/DxHh1RPxnvy3xY2UmDZg+w3uUy6sI37iqhI420=;
 b=ZDLfG5rmFBg/EWzc0711qMdn5eUxMK/I1hXFJC44nd6dUWY94f6ZFxTIycLHZPecs1DNlJub4iPFZdTs72Qlhs534RrBCUXtb5D8I4vK1nQ9MDw+2I0dTN87TRyNzgbmEPSfQMD00VVHr5JpwdvEd0xa1XydJC04pf8zJk5hTVWsqH+XV2nQk9qIbrt7zflNpl3Soq5gWbudAFFYzdERi+uYvwfkMv96agLtri73T55CZ1nPCqzPYAbQuZBQirSzh9eSsavJu5bZXqi4MZ+LztlfRg9NCcE7JT2riPNK9Qv3GlTXBACF1N6ao82+7XnC1U/wWR3AVokw6RBBcRJ0nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM4PR11MB6480.namprd11.prod.outlook.com (2603:10b6:8:8d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.10; Mon, 19 Jan
 2026 10:40:50 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 10:40:50 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "david@kernel.org"
	<david@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"sagis@google.com" <sagis@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 11/24] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Thread-Topic: [PATCH v3 11/24] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Thread-Index: AQHcfvaNGzJc+xBW3kWaSmjSCr7TyLVTNhiAgAJOnoCAA0M3AIAAd0CAgAAEDACAABbcgIAACCKA
Date: Mon, 19 Jan 2026 10:40:50 +0000
Message-ID: <d9b677b4f4cbbf8a8c3dadb056077aa55feb5c30.camel@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
	 <20260106102136.25108-1-yan.y.zhao@intel.com>
	 <2906b4d3b789985917a063d095c4063ee6ab7b72.camel@intel.com>
	 <aWrMIeCw2eaTbK5Z@google.com> <aW2Iwpuwoyod8eQc@yzhao56-desk.sh.intel.com>
	 <3ef110f63cbbc65d6d4cbf737b26c09cb7b44e7c.camel@intel.com>
	 <e69815db698474e113dec16bd33116e54cb21c2a.camel@intel.com>
	 <aW4DXajAzC9nn3aJ@yzhao56-desk.sh.intel.com>
In-Reply-To: <aW4DXajAzC9nn3aJ@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM4PR11MB6480:EE_
x-ms-office365-filtering-correlation-id: 8c37ad12-490d-4fdc-fb9f-08de57473696
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?TGZ2UHUzVU1MdGZPMWtPTElXczZiMExoTkhIMWFyWjB5UGNpR2tOTFJzTXdw?=
 =?utf-8?B?UjdMeVFsNFhKU2w4ek1EVW5JdXRWbDhwakI5aHk5c1hrMUFVZWtxQXJFdHBI?=
 =?utf-8?B?UnMzOVBGb0VzUkNYcXlHQ1pnYzJYSzh0UVFRdXZMQ2lnRWZlMDV0cHpseUZj?=
 =?utf-8?B?NFlzelRqUk1YOEdYaUx4Z0tkZmpTbUNmb2FiYThmYnpjQXJ2ZjgraEhMVWdq?=
 =?utf-8?B?eCtISmRqZ3RlSHNFM2JBVEFIVFRpWFNGNmQ3cjkxRlVTU01DUDkwQUl2Y1Ez?=
 =?utf-8?B?eUdPaWNVbUtoMEhJRHZ2ZmwrcmsxNTJJdldkMWhMZTE1akUycEVhSWJMK0RD?=
 =?utf-8?B?MkVzWTVOc3NJZ1FNK3d0VnZXaXNJN1JkNThwYlBBOWhNQ1RXcTJnbmJPSVpN?=
 =?utf-8?B?TExrWkp2V2ZZbFkxeGlFVGhVVHkvZlVxR0tiQ0ZvdXJ3MEVFMEhDaWNTWW9y?=
 =?utf-8?B?aUtDRzl0ZEJQWGtZMTdHZDVhY0hGTFRJMTBvZVBmYUVCTDB0eGJ0cEtjanU3?=
 =?utf-8?B?bkNDUWYzMGdOWEZoaTI5THhuSUI1emZ4aUVHcjF5Q0kxeGtRcmtmM1MvRFBr?=
 =?utf-8?B?SHdLY3puKzBvZm5UdU5jQTV0U0tROC9uRnMxMzVlVWlMM04xek1SdytLY2tY?=
 =?utf-8?B?dGhWR1pKSk4xZ0RtSzNBN3R0WDBCODRXSGdEcGxLdUl6WWc4QnRBMktlTGlZ?=
 =?utf-8?B?RXM3b3JTTVdoV3hTbXhnYjZlTS8venJoR2FrcUtEVDk4R2x4clhrUnhOenYy?=
 =?utf-8?B?clVoL0FjaDc2M1dIVFkweXFWaE15bmNTeEJnalM2MEZTQ0tmVmp2ak01T3ZC?=
 =?utf-8?B?VHVoaVRCWXFWVHpLNHNrVFVINFVFMTh2UDQ5eWMzS1gvam01QjRzczIxZFJV?=
 =?utf-8?B?dmpWTStSdUpHQ0JnYSswbGVMWlc2ako1ODJaZ2NEYmtTS2MySFpJaEMyUTNU?=
 =?utf-8?B?YXV1d3g0ZmtsVEZ6ZUZ6eGFOK2Ura3dUZXhxSXVwL3RRN0x5bC9qSFNrNGgv?=
 =?utf-8?B?TmVrR2FBQ1BlNjhzalNHeEpSd0REUE8zeStPTkFaeExDbUgvRnVYMmpKZUtS?=
 =?utf-8?B?b3RaUkw2QlB1aWwwMmhnUEZtZDBjR1lERWdrenhGek1odlhjOWtXMFMwS296?=
 =?utf-8?B?U1puM29HV3N2WU0zK2lwaVFiTzRBNFJHdEJFZnQ0OXN2SHBjZGJTRFNBRUdt?=
 =?utf-8?B?Z3RUbFJucjNMTktZRnhGeXp0NUtFWm1WbDZ2Q1VnOU8xZGpMaXRObXpSaVNl?=
 =?utf-8?B?VThZVWswWmZ3MzY2Ny9mNi9yenBmTi9QYkd0TTFDZTlBMGZVR1N0dHJIOUZF?=
 =?utf-8?B?RWFrK3JmeFRoeXJOOExYSG56ZkR0ZnNlYUQxWXFLQ1Q4SC9ZdlZzRkFnL3U0?=
 =?utf-8?B?UytKSGJNemRnaktTTFZmRXlTUjdFMGpvRmNJMDJORXpHcVNGMnN4UWNUaU5q?=
 =?utf-8?B?djFST3U0TGdRZzQxNUhVM3oxSXY0RFNpa1cxdFhMQXdSKzdpVmpGWVAyR1ZQ?=
 =?utf-8?B?RzFicGpCeEZaK0Vlcm1QcENpM0JiRFRzVGtxQlh0c1prMTRMa3hpdCt2WEZD?=
 =?utf-8?B?RzJNV3REMEpQcDhBei8vVXYvcVQ1TnpxNVNoc1R5Y081TU9xdUt6a1VTSksw?=
 =?utf-8?B?R01WV2k5ZEF2SDd5SDRLbjhqSkl5QjNSV2pJUzVEb3N0NzdUZXR4RCtmWkFa?=
 =?utf-8?B?SVNEcmd1RlBDYXpkQmdvNEZibkxrWVlqZzF3OE9Zc09WTkgzSlR3M09ITzZv?=
 =?utf-8?B?a1Z0RWQ2QnZYSkZiUXRZWm15SmRGT1prOUxmOEgxR0hQN3ltSnBIaEJHb2w5?=
 =?utf-8?B?RHRaNjRNaXg0MFc3NTlnMkM1OTkzV3YyNEZ6NnZYZFFWTUM3WEJ0cE50WXcv?=
 =?utf-8?B?d0NiT2NCWVVUazhUUzNuSkozcVJ5eU5Ha21VejBFeDJ1MVU2NGJiMHVOQk5U?=
 =?utf-8?B?d1dQZ0JzcTRPTXVlY01jVHBIMEFzdEgxTzhIaFNTZ0FEZ09KT2RLUTdoSjNY?=
 =?utf-8?B?Wk0yWi9TdmxpQ3poS2VTc0U5N1pHWmFGVHl3dmNtRmNiTE1Uc013bE1VWXFU?=
 =?utf-8?B?Y2tERnY3NUxianhxOGVkVVpnNFZ0dVFiK0R5QkswRjU2NzJEWGJYa0FCaFBz?=
 =?utf-8?B?WmJPR3VYdHFQNHhWVkJYT2p2N0VuQWxDeCtlRWJOWU5HTEtUcTQ5ZFpzWVpC?=
 =?utf-8?Q?HgNRuGCrTpEZvI4B4TNTpvk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dzUvdUg4SGdHYjYxdVBoUXZnUGJrcUYyY2x6QnlIY1hLSU53VzBCc052MHFw?=
 =?utf-8?B?a0FaYzlRc0poeFdzQWNoNmg2ZGdSKzRzT0Z2MzNoOGVEMlFoWERoMlVHRXUy?=
 =?utf-8?B?QlZZc3pRNFZjSTFYNVM1bzVvYmw4S3NFa2NMbVZlRDRJNUtySmVRNkJ3eFRn?=
 =?utf-8?B?cUgvcXBGd2NTemNUSW1xZnFmdmZaOEtud1NiTFF6YzVreHowRzhSdlJKWk9p?=
 =?utf-8?B?Rmp5YmNUZHBaYldYQmZLTjcxT240WVJFS0piNCtlRnFQTW15VW5CNjlmTGN4?=
 =?utf-8?B?NURrblQ1MXVsVXFOSDhOZ0Z3SEJ5anhqRW8xUjJ5bEQ5eldodkEvbzRWTTlo?=
 =?utf-8?B?YjJ0ZUxJb3Baeng2b2kzQzFSMk1hblllRm44UVM3a0lBT1NzVWY5STllb0Nk?=
 =?utf-8?B?aDR3L2RNZmRCU2x3ZEhHUkhKQWNobnFJOEFkUkFzbnhEYjBzcU9SYWp3R0c0?=
 =?utf-8?B?b3dGeHBGVVdCcFdHaXZBcU9rOXZjSjNtZmgrR2N2eEk3aForeTJlU1MwSHpr?=
 =?utf-8?B?MTFSNnpDR0x3dDY1djV4SGM3WTQ1dnp2eEZETTVRZm9Ib2V3VEh4TVVNeVli?=
 =?utf-8?B?aWRzVlgwTVR1MkZIS0lxZ2VWSWRmT0s0b0RIU21DREw5bXV3SkVicmcrNWJm?=
 =?utf-8?B?bUVCVmJaQjhGZ00xWnRpbmxwdzhWU3RpbVZMUDJRc1FQSEJhODRjemh3U2gr?=
 =?utf-8?B?S2gvRWlJWU0xcmQxcGJBQzg3aFMrWmMzN1ZUZHdFdmg0dkhVUzlhK1ZiSzFG?=
 =?utf-8?B?VGF6V0hRS2toZ1craE9kQjY2RjZMTDF4SSswVWU0V0hBaUlqeTJmNzBHd2NU?=
 =?utf-8?B?STNZQ3FLRXBtbExaeHVVWnpJUXR6UUZlWmo0ci9ZN29zTnEzemo3Mzg4NStr?=
 =?utf-8?B?NForN0cySGxWQ2NXODRXdmxIWXZTTkdlK2ZQa3J5SjhocTI0MWhpbTVKV1Mx?=
 =?utf-8?B?bjBYK3lkcmh0c2REZSs0M2dUb3JUNCtYRlN0NnVQT3VhdEs1YnlRTTNoQXVK?=
 =?utf-8?B?ODFsclFLRXJrcFZrSkc2RkQ2U1pBWnpZQ3pnSkliYVV0QXNUZkYrSjNGY1BM?=
 =?utf-8?B?RVVzQ2dsMXNKc0tobWNsRTRWdEdpbGRaNkpSci9uYWRlMC9PV1RqeS9EMTFu?=
 =?utf-8?B?LzF2K1NERHNVUk4xOVNVTVpOcUxQWFVIOURIcklBQ3VtKzJsVWdOQXcxNUZX?=
 =?utf-8?B?dWw0ck0rS0VYYXVNM0lZUmRUa0EweXgwc2VzK2xKeHozeWxFUkZpZmQvZ1E2?=
 =?utf-8?B?Z3BIYmpFMVgzcDQvV055Vk9BQkZLTXAzc3RGWHNqK2IzZWJkK0xpdkx5QUN3?=
 =?utf-8?B?czFnR2xGT0NBYkRNRFBTNW5TbWdoRWJrTWxaTmxobUpMRnBNaDl1WG9nc2Rk?=
 =?utf-8?B?N2tlLy9EVTE3enQyOEVkOWgzcnEwbVdkZWxGT3JLelpZOGhHZlZtZDV1SHZh?=
 =?utf-8?B?RlhOMU9uN25hMEsvSkp4amdZNWsxK2JFNWlINTJ2TUVVblQ5ekhPS1MxV3Fq?=
 =?utf-8?B?a3U4cFRKVk5Xa1ZtUUdUbFpIc0xBZEo4T1lSM2U0b3AwZENjUWpFVWxieGlS?=
 =?utf-8?B?RHJldVIyZC9PWEp6L3lXNVNwMXRKWUNWeW1jSXdaNXBlZ1NZTGVUcU9QUWRC?=
 =?utf-8?B?UEFQYmVVL0ZNRWVvbThMc0V0bDFEUm95WWRPYjRBQWNFejlQS3pNOVh5ZVNI?=
 =?utf-8?B?R1JJT0V2OFVmZEZUd3FJcDA2ZTdnZDVzZkZxOEdCRlhac3czWG1WelZFR1pW?=
 =?utf-8?B?TEo1cWhHRjVPZ202L1NDSGJRVmphZ2VESzZFNUZrVVdUODh4bDZRZTQwL21X?=
 =?utf-8?B?UXBGblgzZmx2V2lZMUQrVHRqMHZTb1JJQ0p2V1VSU1pSZXFaMEtqVmJnNU01?=
 =?utf-8?B?b3lrWStDOGUwK2I0aTJ6eWpnUkhvTDBFQ0VTc1czUzdqZGJZYjFiTDFWVmto?=
 =?utf-8?B?Ri9ja1ZUcGt1a3NLZ1dhWnBLUDIvOFNCVFdKWHZ4MEQvQjY1MVRxMk85NEo0?=
 =?utf-8?B?Y3Y0NnFNV3ZEZ3dSajlia09ndHRIelgwMGFVbmVYRUNaeldhT0JlaGpxSkM4?=
 =?utf-8?B?SlBoWVRiemdtdkszNG94V2o1TGV2Q2tXaitNSmxGQ0VPREpKMG10UEJMOEZR?=
 =?utf-8?B?emVZRm1ZV0FSVGV6VWtIRVg5UlVNYVBOSGs1VEtWZ2V3SnFqQnREeW54RGxE?=
 =?utf-8?B?amp5Vm9nS3F6M1Z0VUJNcXh3bzl2L3dEWUtHS0tjbjI0bXNXNkhkeDFQWnJt?=
 =?utf-8?B?ZldVbHdQaWEwOVRYWHBNMmJTcys1L0FHVDRuKzFlaFc4QWF5YWtLcGVTN2VP?=
 =?utf-8?B?NTcyRERsYU1RYXByMk5kVlpYUXpUUFZUK3Z2VVV3dGc4Q3ZwTDFBUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3EAB20CB723BBB429D3C25D7BA0A5FBA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c37ad12-490d-4fdc-fb9f-08de57473696
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2026 10:40:50.2890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WgMBDE40RVzox206hh7TROCCo6v/SET6isyNo9lnirlhRdIctt+P+Nyn9paB0Vi1U+ERCpE55eKj0a75FVKFvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6480
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI2LTAxLTE5IGF0IDE4OjExICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
TW9uLCBKYW4gMTksIDIwMjYgYXQgMDQ6NDk6NThQTSArMDgwMCwgSHVhbmcsIEthaSB3cm90ZToN
Cj4gPiBPbiBNb24sIDIwMjYtMDEtMTkgYXQgMDg6MzUgKzAwMDAsIEh1YW5nLCBLYWkgd3JvdGU6
DQo+ID4gPiBPbiBNb24sIDIwMjYtMDEtMTkgYXQgMDk6MjggKzA4MDAsIFpoYW8sIFlhbiBZIHdy
b3RlOg0KPiA+ID4gPiA+IEkgZmluZCB0aGUgImNyb3NzX2JvdW5kYXJ5IiB0ZXJtaW5pbm9sb2d5
IGV4dHJlbWVseSBjb25mdXNpbmcuwqAgSSBhbHNvIGRpc2xpa2UNCj4gPiA+ID4gPiB0aGUgY29u
Y2VwdCBpdHNlbGYsIGluIHRoZSBzZW5zZSB0aGF0IGl0IHNob3ZlcyBhIHdlaXJkLCBzcGVjaWZp
YyBjb25jZXB0IGludG8NCj4gPiA+ID4gPiB0aGUgZ3V0cyBvZiB0aGUgVERQIE1NVS4NCj4gPiA+
ID4gPiBUaGUgb3RoZXIgd2FydCBpcyB0aGF0IGl0J3MgaW5lZmZpY2llbnQgd2hlbiBwdW5jaGlu
ZyBhIGxhcmdlIGhvbGUuwqAgRS5nLiBzYXkNCj4gPiA+ID4gPiB0aGVyZSdzIGEgMTZUaUIgZ3Vl
c3RfbWVtZmQgaW5zdGFuY2UgKG5vIGlkZWEgaWYgdGhhdCdzIGV2ZW4gcG9zc2libGUpLCBhbmQg
dGhlbg0KPiA+ID4gPiA+IHVzZXJwYWNlIHB1bmNoZXMgYSAxMlRpQiBob2xlLsKgIFdhbGtpbmcg
YWxsIH4xMlRpQiBqdXN0IHRvIF9tYXliZV8gc3BsaXQgdGhlIGhlYWQNCj4gPiA+ID4gPiBhbmQg
dGFpbCBwYWdlcyBpcyBhc2luaW5lLg0KPiA+ID4gPiBUaGF0J3MgYSByZWFzb25hYmxlIGNvbmNl
cm4uIEkgYWN0dWFsbHkgdGhvdWdodCBhYm91dCBpdC4NCj4gPiA+ID4gTXkgY29uc2lkZXJhdGlv
biB3YXMgYXMgZm9sbG93czoNCj4gPiA+ID4gQ3VycmVudGx5LCB3ZSBkb24ndCBoYXZlIHN1Y2gg
bGFyZ2UgYXJlYXMuIFVzdWFsbHksIHRoZSBjb252ZXJzaW9uIHJhbmdlcyBhcmUNCj4gPiA+ID4g
bGVzcyB0aGFuIDFHQi4gVGhvdWdoIHRoZSBpbml0aWFsIGNvbnZlcnNpb24gd2hpY2ggY29udmVy
dHMgYWxsIG1lbW9yeSBmcm9tDQo+ID4gPiA+IHByaXZhdGUgdG8gc2hhcmVkIG1heSBiZSB3aWRl
LCB0aGVyZSBhcmUgdXN1YWxseSBubyBtYXBwaW5ncyBhdCB0aGF0IHN0YWdlLiBTbywNCj4gPiA+
ID4gdGhlIHRyYXZlcnNhbCBzaG91bGQgYmUgdmVyeSBmYXN0IChzaW5jZSB0aGUgdHJhdmVyc2Fs
IGRvZXNuJ3QgZXZlbiBuZWVkIHRvIGdvDQo+ID4gPiA+IGRvd24gdG8gdGhlIDJNQi8xR0IgbGV2
ZWwpLg0KPiA+ID4gPiANCj4gPiA+ID4gSWYgdGhlIGNhbGxlciBvZiBrdm1fc3BsaXRfY3Jvc3Nf
Ym91bmRhcnlfbGVhZnMoKSBmaW5kcyBpdCBuZWVkcyB0byBjb252ZXJ0IGENCj4gPiA+ID4gdmVy
eSBsYXJnZSByYW5nZSBhdCBydW50aW1lLCBpdCBjYW4gb3B0aW1pemUgYnkgaW52b2tpbmcgdGhl
IEFQSSB0d2ljZToNCj4gPiA+ID4gb25jZSBmb3IgcmFuZ2UgW3N0YXJ0LCBBTElHTihzdGFydCwg
MUdCKSksIGFuZA0KPiA+ID4gPiBvbmNlIGZvciByYW5nZSBbQUxJR05fRE9XTihlbmQsIDFHQiks
IGVuZCkuDQo+ID4gPiA+IA0KPiA+ID4gPiBJIGNhbiBhbHNvIGltcGxlbWVudCB0aGlzIG9wdGlt
aXphdGlvbiB3aXRoaW4ga3ZtX3NwbGl0X2Nyb3NzX2JvdW5kYXJ5X2xlYWZzKCkNCj4gPiA+ID4g
YnkgY2hlY2tpbmcgdGhlIHJhbmdlIHNpemUgaWYgeW91IHRoaW5rIHRoYXQgd291bGQgYmUgYmV0
dGVyLg0KPiA+ID4gDQo+ID4gPiBJIGFtIG5vdCBzdXJlIHdoeSBkbyB3ZSBldmVuIG5lZWQga3Zt
X3NwbGl0X2Nyb3NzX2JvdW5kYXJ5X2xlYWZzKCksIGlmIHlvdQ0KPiA+ID4gd2FudCB0byBkbyBv
cHRpbWl6YXRpb24uDQo+ID4gPiANCj4gPiA+IEkgdGhpbmsgSSd2ZSByYWlzZWQgdGhpcyBpbiB2
MiwgYW5kIGFza2VkIHdoeSBub3QganVzdCBsZXR0aW5nIHRoZSBjYWxsZXINCj4gPiA+IHRvIGZp
Z3VyZSBvdXQgdGhlIHJhbmdlcyB0byBzcGxpdCBmb3IgYSBnaXZlbiByYW5nZSAoc2VlIGF0IHRo
ZSBlbmQgb2YNCj4gPiA+IFsqXSksIGJlY2F1c2UgdGhlICJjcm9zcyBib3VuZGFyeSIgY2FuIG9u
bHkgaGFwcGVuIGF0IHRoZSBiZWdpbm5pbmcgYW5kDQo+ID4gPiBlbmQgb2YgdGhlIGdpdmVuIHJh
bmdlLCBpZiBwb3NzaWJsZS4NCj4gSG1tLCB0aGUgY2FsbGVyIGNhbiBvbmx5IGZpZ3VyZSBvdXQg
d2hlbiBzcGxpdHRpbmcgaXMgTk9UIG5lY2Vzc2FyeSwgZS5nLiwgaWYNCj4gc3RhcnQgaXMgMUdC
LWFsaWduZWQsIHRoZW4gdGhlcmUncyBubyBuZWVkIHRvIHNwbGl0IGZvciBzdGFydC4gSG93ZXZl
ciwgaWYgc3RhcnQNCj4gaXMgbm90IDFHQi8yTUItYWxpZ25lZCwgdGhlIGNhbGxlciBoYXMgbm8g
aWRlYSBpZiB0aGVyZSdzIGEgMk1CIG1hcHBpbmcgY292ZXJpbmcNCj4gc3RhcnQgLSAxIGFuZCBz
dGFydC4NCg0KV2h5IGRvZXMgdGhlIGNhbGxlciBuZWVkIHRvIGtub3c/DQoNCkxldCdzIG9ubHkg
dGFsayBhYm91dCAnc3RhcnQnIGZvciBzaW1wbGljaXR5Og0KDQotIElmIHN0YXJ0IGlzIDFHIGFs
aWduZWQsIHRoZW4gbm8gc3BsaXQgaXMgbmVlZGVkLg0KDQotIElmIHN0YXJ0IGlzIG5vdCAxRy1h
bGlnbmVkIGJ1dCAyTS1hbGlnbmVkLCB5b3Ugc3BsaXQgdGhlIHJhbmdlOg0KDQogICBbQUxJR05f
RE9XTihzdGFydCwgMUcpLCBBTElHTihzdGFydCwgMUcpKSB0byAyTSBsZXZlbC4NCg0KLSBJZiBz
dGFydCBpcyA0Sy1hbGlnbmVkIG9ubHksIHlvdSBmaXJzdGx5IHNwbGl0DQoNCiAgIFtBTElHTl9E
T1dOKHN0YXJ0LCAxRyksIEFMSUdOKHN0YXJ0LCAxRykpDQoNCiAgdG8gMk0gbGV2ZWwsIHRoZW4g
eW91IHNwbGl0DQoNCiAgIFtBTElHTl9ET1dOKHN0YXJ0LCAyTSksIEFMSUdOKHN0YXJ0LCAyTSkp
DQoNCiAgdG8gNEsgbGV2ZWwuDQoNClNpbWlsYXIgaGFuZGxpbmcgdG8gJ2VuZCcuICBBbiBhZGRp
dGlvbmFsIHRoaW5nIGlzIGlmIG9uZSB0by1iZS1zcGxpdC0NCnJhbmdlIGNhbGN1bGF0ZWQgZnJv
bSAnc3RhcnQnIG92ZXJsYXBzIG9uZSBjYWxjdWxhdGVkIGZyb20gJ2VuZCcsIHRoZQ0Kc3BsaXQg
aXMgb25seSBuZWVkZWQgb25jZS4gDQoNCldvdWxkbid0IHRoaXMgd29yaz8NCg0KPiAoZm9yIG5v
bi1URFggY2FzZXMsIGlmIHN0YXJ0IGlzIG5vdCAxR0ItYWxpZ25lZCBhbmQgaXMganVzdCAyTUIt
YWxpZ25lZCwNCj4gaW52b2tpbmcgdGRwX21tdV9zcGxpdF9odWdlX3BhZ2VzX3Jvb3QoKSBpcyBz
dGlsbCBuZWNlc3NhcnkgYmVjYXVzZSB0aGVyZSBtYXkNCj4gZXhpc3QgYSAxR0IgbWFwcGluZyBj
b3ZlcmluZyBzdGFydCAtMSBhbmQgc3RhcnQpLg0KPiANCj4gSW4gbXkgcmVwbHkgdG8gWypdLCBJ
IGRpZG4ndCB3YW50IHRvIGRvIHRoZSBjYWxjdWxhdGlvbiBiZWNhdXNlIEkgZGlkbid0IHNlZQ0K
PiBtdWNoIG92ZXJoZWFkIGZyb20gYWx3YXlzIGludm9raW5nIHRkcF9tbXVfc3BsaXRfaHVnZV9w
YWdlc19yb290KCkuDQo+IEJ1dCB0aGUgc2NlbmFyaW8gU2VhbiBwb2ludGVkIG91dCBpcyBkaWZm
ZXJlbnQuIFdoZW4gYm90aCBzdGFydCBhbmQgZW5kIGFyZSBub3QNCj4gMk1CLWFsaWduZWQsIGlm
IFtzdGFydCwgZW5kKSBjb3ZlcnMgYSBodWdlIHJhbmdlLCB3ZSBjYW4gc3RpbGwgcHJlLWNhbGN1
bGF0ZSB0bw0KPiByZWR1Y2UgdGhlIGl0ZXJhdGlvbnMgaW4gdGRwX21tdV9zcGxpdF9odWdlX3Bh
Z2VzX3Jvb3QoKS4NCg0KSSBkb24ndCBzZWUgbXVjaCBkaWZmZXJlbmNlLiAgTWF5YmUgSSBhbSBt
aXNzaW5nIHNvbWV0aGluZy4NCg0KPiANCj4gT3Bwb3J0dW5pc3RpY2FsbHksIG9wdGltaXphdGlv
biB0byBza2lwIHNwbGl0cyBmb3IgMUdCLWFsaWduZWQgc3RhcnQgb3IgZW5kIGlzDQo+IHBvc3Np
YmxlIDopDQoNCklmIHRoaXMgbWFrZXMgY29kZSBlYXNpZXIgdG8gcmV2aWV3L21haW50YWluIHRo
ZW4gc3VyZS4NCg0KQXMgbG9uZyBhcyB0aGUgc29sdXRpb24gaXMgZWFzeSB0byByZXZpZXcgKGku
ZS4sIG5vdCB0b28gY29tcGxpY2F0ZWQgdG8NCnVuZGVyc3RhbmQvbWFpbnRhaW4pIHRoZW4gSSBh
bSBmaW5lIHdpdGggd2hhdGV2ZXIgU2Vhbi95b3UgcHJlZmVyLg0KDQpIb3dldmVyIHRoZSAnY3Jv
c3NfYm91bmRhcnlfb25seScgdGhpbmcgd2FzIGluZGVlZCBhIGJpdCBvZGQgdG8gbWUgd2hlbiBJ
DQpmaXJzdGx5IHNhdyB0aGlzIDotKQ0K

