Return-Path: <kvm+bounces-68469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E1A7ED39E26
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 06:59:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A30E5303B7F5
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 05:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0450258EDB;
	Mon, 19 Jan 2026 05:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fE6DT3Ws"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9520F1B424F;
	Mon, 19 Jan 2026 05:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768802206; cv=fail; b=Etw2m6tVYGAodcQq7eqTPVUeBKSD5Es747xwLIa1dx+PQ8zI2tK2hPMJ0fAcd8CSEbTSLRF4T61+Q8Vw+zvcCWxNBjzvDzYqj/PEL1r6wyzDz2F92pbmO9VAJ8m5odmtCl6DcQSXORz3q/stnRGY0BDMu2mH02m3ImUmZ4DFQkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768802206; c=relaxed/simple;
	bh=LF35nWSvONvN2PfcYymXnLPsJK+OOrdIob8c7WRot4c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TfFsm66UXe6R+tvxW110zbPg3hWYeTn8FIaSopltzKXMqCK8FufRVs0fYf3keFS+BzBX9STHlefnxPTv2voO4OF+HXSjV9DrcLyPsMpOQ/YR9pBcPWfE/1cN8xiXSlof0kPSIxzi83oYQaf2nL8iHcW/sMz3Hd8xnjKBEtg77jw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fE6DT3Ws; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768802206; x=1800338206;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=LF35nWSvONvN2PfcYymXnLPsJK+OOrdIob8c7WRot4c=;
  b=fE6DT3WsF2m6DbejvO4bxJ6+alRCIEuwqe6PutWxXhY2pUFkYr10cFmf
   cfgZnn6FR0LZ3hfxHbPa1aRzBZuYSuDjpkQbgClqwFuJb3Bc77D7CdWhR
   4nhlzI7fS8ZiM26BZjoMd8N01KK8M7r8mC9Eln37aB5B558rqeADdJMR6
   5M1Fm+JkQQdGYAorJMY5nGVx2J3KnnGwcC858SraRhUmvNdtEQgYyCodE
   0WECqTFys+cbcmaPUit42wuyvKv5a+hPRIACQK3YNl3XodEFDGvVwb2fu
   fyDyuBeVhKvEYjx0ytixPZC/hf0oYHAW6hXwN/cPwR9YPhasQTCOCUeii
   Q==;
X-CSE-ConnectionGUID: QdgPlgwQToiTOVkPfCHmWw==
X-CSE-MsgGUID: QDogq+PwSYCmqDFOtKCjdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="87586098"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="87586098"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 21:56:45 -0800
X-CSE-ConnectionGUID: r6Kgj26gQ6CPD2RhoaX70Q==
X-CSE-MsgGUID: qalBf7u7Rd2vRaJ5A476KQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="209919345"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 21:56:44 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sun, 18 Jan 2026 21:56:43 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Sun, 18 Jan 2026 21:56:43 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.68) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 18 Jan 2026 21:56:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ecqmh6pYmLtnlZ0xvgdb34UN4xXpxUSrEaS3HqCqHbdYbU+r/bXNTei2aqteQEimtIdNjU/QKJRlGxGrKaT4nQSzrgOiKvsIqjgas5JJtsdVWqSAEb9XFJw/1KjIiODZh6C4skl8RpyB4w5G6o7URBxq8qCB0JBRWjV8B9DW+kxM4AYDuf5Rf11r/+OLk3eq3Kh2VpzYQI2ePik9BYDhAoEoWLSSrKmTSejXBsLu0P2nSG9vwqksC5gTOYqU4ZE9fH00XXQF3qO7NTNdvsNVjJVcNl6YY8jJXEx6PZsQhlyvck9aCDwmF9AjQhfCxDdNrxBQEeNSk05fCawbpI2waw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ylt/HlyPPtrZBXGXqdkerixFSfcJZ/kdKf7/JG69Rg=;
 b=LGiKMHA0m0GjEicMeyarPMJ/chVgP8TwlosZ1qsvjS90J1oQ7/1FxgHyRtdzeeihxe49BdIptFXXQbdiJAn/1VuQdPudk7NLpzpLhTPlqJGC57NpFAKGNeT7ah5sUauEDygvaYczS4bqOcer6MYEsQlcgHECQjNjvDLUuZlAqz70IZ6N6YsCPoLF85r6VwHsj/IqmS6sEXRMQpVJpNf+hR/PXS4NMGWJiiWO9lGvZzMEvuCaOmPXw0eQuJUMfPgZta5QIwPNNkjo16ETKw9DEWiNS7/e19+jFRoPBh7ysP9l44/30DCnNm0uVmi35w1FQOn4ChB17LuCg4nvoxY8rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS4PPF75D68BA1B.namprd11.prod.outlook.com (2603:10b6:f:fc02::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 05:56:35 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 05:56:35 +0000
Date: Mon, 19 Jan 2026 13:53:47 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Du, Fan" <fan.du@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
	"david@kernel.org" <david@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "jgross@suse.com" <jgross@suse.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
Message-ID: <aW3G6yZuvclYABzP@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
 <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com>
 <aWbwVG8aZupbHBh4@google.com>
 <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com>
 <aWe1tKpFw-As6VKg@google.com>
 <f4240495-120b-4124-b91a-b365e45bf50a@intel.com>
 <aWgyhmTJphGQqO0Y@google.com>
 <ac46c07e421fa682ef9f404f2ec9f2f2ba893703.camel@intel.com>
 <aWpn8pZrPVyTcnYv@google.com>
 <6184812b4449947395417b07ae3bad2f191d178f.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6184812b4449947395417b07ae3bad2f191d178f.camel@intel.com>
X-ClientProxiedBy: KU2P306CA0085.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3a::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS4PPF75D68BA1B:EE_
X-MS-Office365-Filtering-Correlation-Id: 8552978e-c350-4650-230e-08de571f80ef
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?cWpPxXti3nUuGwAESWlqMBqevRt0fCerBjADGPxhYoyNVFQP5ahXiWzU46?=
 =?iso-8859-1?Q?0s8n/EBwFgx5HHRrh9ciPbZBFXoBmV91OmwLvMxb9mXCvHKd3XPZ4owDax?=
 =?iso-8859-1?Q?e71eXU508kDMFsZ32SVtyknF1wdEcv3cgts58Opd1LHkEUDQk6nQJ0dN2e?=
 =?iso-8859-1?Q?VvAIsr7GBwFYVoHkJc+ws+zqu9l4fSLGBoIZRHlPCTvVYjr/8ZeAxPuUvO?=
 =?iso-8859-1?Q?qpS/symtXgWWjiAgt5pDuQs8L+fT89CrCiOQ41C+GIWq6A9RI+mJkjIi71?=
 =?iso-8859-1?Q?A/vdB4d3RLRI6ZPR+BjfCmhmmmARRfdDe9bN2TBPv4Y5moM3Z7rOrShYs4?=
 =?iso-8859-1?Q?pX/Rgro6WlYBD1qXtJ7ppUa/TplhrYINjEvQLSFOKKdA3CuDzZ+0sVigOa?=
 =?iso-8859-1?Q?QgxIyXsDxQ+1ZDCdxtxsguzxKNyJeVa6IgnYqWo2AQ3Vo8BicKU850lRn6?=
 =?iso-8859-1?Q?eksr2XwyuQzQoit/42pg4rPYjlS/7mh/R+b3LAQr9RqnZpCz37Ijgd6Gso?=
 =?iso-8859-1?Q?98UHa6b9UMlsbvU9zTlas1ucdG4Giwv+mVmeP5wHFhxBK+m9ukwTOctOHV?=
 =?iso-8859-1?Q?6DehQE4C452xj23wSR8VDdBdb3NfZpUHdgcglXvqXjzKz29C0IopQBja0s?=
 =?iso-8859-1?Q?aAN/c8aYKdAMkKIE5VkR97fYgRH5VfRwvX0zMZwdTL8y7k5HgRdapOtvs5?=
 =?iso-8859-1?Q?tlHjb+n4OZRQOgqgnHrbBWIKfq+HnUwv1lplS/C0CnaTV7XNW5uYmX7I79?=
 =?iso-8859-1?Q?vWs5vHabTbsR/FlKARXm+CCmKsjpr88H0hLOnGc0qw6PrJUxwDx4HmPqjk?=
 =?iso-8859-1?Q?zhSTlmzNgF6qZrZJEnJwWQOioto8EtRgVxbCvVqlNxZ4hK5FfSD7of2zX5?=
 =?iso-8859-1?Q?OuxYcMULMvtnyziTVAPut+NRrPIwit77PtYPoPuTSAvbXPVOwBZ/owjxIb?=
 =?iso-8859-1?Q?QJynEA/KolHGaiEclQdOVQGdeuYq/Qj1zWI70MoBEhx2Rzmt72t7EHeASU?=
 =?iso-8859-1?Q?t6jGgvCIXIcXGvoCGHAuZhRWun4y+9bqtnAwB7LEeNgumfb3OFYgj04wKK?=
 =?iso-8859-1?Q?tNaIdh6nAUq5Y3U4esrnqJccQiad9b6TgceyZqG7KpelbF5hqw7d1Wjr2Q?=
 =?iso-8859-1?Q?iOWDIDX1U0DefVeOnLyqiRuuuO4KJM1D6uQZgChEzjfkocT0mIj7IziJPT?=
 =?iso-8859-1?Q?GUz1NvTLUN/Aqi7ouRsluZQ+s4+I5BhEPfRXzTH/Iq/ArQj34UEo76QuLx?=
 =?iso-8859-1?Q?lZMuWeNCbARtOb0E9HyEeMfbt2IUdamoLg31Yn94sbcxQFB8VxHU5Qf9dx?=
 =?iso-8859-1?Q?MpkO+V1Y58Gzh2nc+Z0r7gjDHQAf0Y1ZmSdL4EnelV8Hw5teXKxjT3V8xJ?=
 =?iso-8859-1?Q?JCsVk+9ZrIy5MgVE3yxcoTcxHI82cT9aCWM0wJYGKE+m+3+NoXUQih553w?=
 =?iso-8859-1?Q?Edo8wsjK2SxHsAV5XyJF56bBJ756Bf3TJ5MDjM1vklGcfY74MlliPoXGvG?=
 =?iso-8859-1?Q?/5/2mbTZnvOuBmlLy7D4nQMe8Ebr1zy7qRsD77FKdFr0JHVf566HBk+1Gd?=
 =?iso-8859-1?Q?U8RkIqWCX5oKQ6aG58QhEanb8BTJCPJO7V0gCRsIfx3uzA6GQ43fQFxVK5?=
 =?iso-8859-1?Q?MRAXbATAlcOJmRN6v1ec/QcB2bRu/8S857?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?XX0hxx6xRhubJ5Nb5BPtMr6QG4bp63ZmMbwdWl8LrwJ11/FtrQFnQjHNlu?=
 =?iso-8859-1?Q?yVCPAFNAL51dpJgjCMnPag+GQ43JG3FH0v2+Xoi1orL4is4MHxEhtIzYxg?=
 =?iso-8859-1?Q?FUrRFIMVHbCpqCVROxaacNYtvJiL/xt+fIKz9yYIQKW00Aq42YQdANUZO/?=
 =?iso-8859-1?Q?jnCkj4kWC+K6K8pIvMp2oUk5CkSQWmeeS4VBQGDoHeTtM0s3cTw8NTZ5eC?=
 =?iso-8859-1?Q?bPLmOlapwHySkKDI8b6EpIwZoJ6REEW/OMmYvdthXOmfrYqZP5R31eby+H?=
 =?iso-8859-1?Q?CagKgnOTIUgknXJ40gIynFWcW5JhitAB0Grolkv0j2B68qPwAZmXJkBY1F?=
 =?iso-8859-1?Q?zz4ZOie4X6vtkdfPBoUwWY7jIh4Sk7GhjwuZSBiuiUf7d5dM6ihWiKD7MC?=
 =?iso-8859-1?Q?dSEhbg6b9/dRw+bGxXX1Dcnlaew2l9etEMvGUcweWlisR6kd03cI9dRODO?=
 =?iso-8859-1?Q?MdHfsE5MLl86mzbtkE19qXwaZSSmNSnOrmFiT3DKNV9E23CoZYo04+wvJi?=
 =?iso-8859-1?Q?Z42NnJEltYlGVTurvWuQ8jtR0w3WcIRmUYsLug4XOVu++VqMVBFd0EmsEK?=
 =?iso-8859-1?Q?4MgPAA1nDiZjkwpShCSwk32WgfnsSecfzEPxNiNyvrXJRyBcyFhTtKJn0M?=
 =?iso-8859-1?Q?dhAjtRSM2SPdsHJPzCn09HgA7A2CPf+RHVXjoeRofHLBTHygn8E1v0aE1F?=
 =?iso-8859-1?Q?a/WFUYvGyHp9NviVQmKRwcNvxyBNpFJ6VJ5c5AB7UKwOVvgxcpNW99yuO6?=
 =?iso-8859-1?Q?oNSziXHi9Cw+IcjdOuGS5Hs5XlGwAuy1iuPgUadzZEDfecs0XvAqnk4Lxi?=
 =?iso-8859-1?Q?GZ8+Pu8H2aan54VRIG/gYoC5fD4cparmgL+GjfXru+wKb+UIUebFZOzFQO?=
 =?iso-8859-1?Q?ujhhLOy4a8MJBpy1BUzubZChMXj7z6Uq07M3AtYqPmDKWAWLZCDs2lTDrC?=
 =?iso-8859-1?Q?2KabV7Whq5Wx2cwIZ6ey8zNIzGvh6jJtQXiLLFgtfDvqxebofbjs0pLYA2?=
 =?iso-8859-1?Q?x4tINOYUpWDuKwPurQ9pq5yWSa7Mpv/fUcvJoLVMfV2Dr9TmXQNLNiSYmN?=
 =?iso-8859-1?Q?S/9+eWH0UV+v0CUZXW6T/fybLUnQ1kHB8rlqaJ5W/H3oSITR9aX7KMaYO0?=
 =?iso-8859-1?Q?3ch+6H44APuFOxXUSJJN2doVNW9oinfneJtBJl98eIIh4duCXBwfuBWvZY?=
 =?iso-8859-1?Q?NXebOntRG1L47JKiIBLqk4gxfjrHRx9x1vA02E8Nb14Q4NIS9Jpm0Rji3u?=
 =?iso-8859-1?Q?p29uAcdEU+8f4J0ICsv4uMkyW2ejT+Ah1/qBa0HJT6XN+ivnsgdF0rM6xy?=
 =?iso-8859-1?Q?BiR4m1OfiU4M7aFzo71/dXTIb+lJpa0kauT3g+4OC+9K5/yI1cn+vIs9Is?=
 =?iso-8859-1?Q?86+DDlYtY6mF973eurYsHCv5WEYuWnqO5dCg3R0Z4nRYuIVd6yMVslPULw?=
 =?iso-8859-1?Q?VsITjs09DAR55hNGpLBicknAgW8QBAzmuQk9FwikRaRYQwzQG6Nvnnp+0k?=
 =?iso-8859-1?Q?5oKebchHakytrk0oH003nGOYTbfRQctsst2vidxcUaGpbMtBbWrYI5ADAx?=
 =?iso-8859-1?Q?Abn2ZMVA+N+2c3cmzb8Z6ydddiq6ZtSri8q9AANOh3I3bjE6XYyL2CLuLp?=
 =?iso-8859-1?Q?J3aBeFcEDQZPW3wPGSLCntfyym/kg5tMjceggtubDKYLdf1CYx+DUu9Xph?=
 =?iso-8859-1?Q?DeyrbTiODgRp/2wnB4rn3As9RaClL2tm1jn9E5rhj/mmebm5wZIIoQTvd/?=
 =?iso-8859-1?Q?f3X7YMdf2EAESSocdczMnUmnPVKrInHTU/ejKV74mlFSgS5wNCs6Eyl4Ja?=
 =?iso-8859-1?Q?ZZB3TbhNvw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8552978e-c350-4650-230e-08de571f80ef
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 05:56:35.3664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ti9aPIDpyyPmXnS/dfQvYzJ4dQ8WHkgq5uS6xOHa7s85o4IVv5G9HRSLM82++mMCGz20SDEAPEcEaCKWIXKofA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF75D68BA1B
X-OriginatorOrg: intel.com

On Sat, Jan 17, 2026 at 12:58:02AM +0800, Edgecombe, Rick P wrote:
> On Fri, 2026-01-16 at 08:31 -0800, Sean Christopherson wrote:
> > > Dave wants safety for the TDX pages getting handed to the module.
> > 
> > Define "safety".  As I stressed earlier, blinding retrieving a
> > "struct page" and dereferencing that pointer is the exact opposite of
> > safe.
> 
> I think we had two problems.
> 
> 1. Passing in raw PA's via u64 led to buggy code. IIRC we had a bug
> with this that was caught before it went upstream. So a page needs a
> real type of some sort.
> 
> 2. Work was done on the tip side to prevent non-TDX capable memory from
> entering the page allocator. With that in place, by requiring struct
> page, TDX code can know that it is getting the type of memory it worked
> hard to guarantee was good.
> 
> You are saying that shifting a PFN to a struct page blindly doesn't
> actually guarantee that it meets those requirements. Makes sense.
> 
> For (1) we can just use any old type I think - pfn_t, etc. As we
> discussed in the base series.
> 
> For (2) we need to check that the memory came from the page allocator,
> or otherwise is valid TDX memory somehow. That is at least the only
> check that makes sense to me.
> 
> There was some discussion about refcounts somewhere in this thread. I
> don't think it's arch/x86's worry. Then Yan was saying something last
> night that I didn't quite follow. We said, let's just resume the
> discussion on the list. So she might suggest another check.
Hmm, I previously had a concern about passing "struct page *" as the SEAMCALL
wrapper parameter. For example, when we do sanity checks for valid TDX memory in
tdh_mem_page_aug(), we need to do the sanity check on every page, right?
However, with base_page + npages, it's not easy to get the ith page's pointer
without first ensuring the pages are contained in a single folio. It would also
be superfluous if we first get base_pfn from base_page, and then derive the ith
page from base_pfn + i.

IIUC, this concern should be gone as Dave has agreed to use "pfn" as the
SEAMCALL parameter [1]?
Then should we invoke "KVM_MMU_WARN_ON(!tdx_is_convertible_pfn(pfn));" in KVM
for every pfn of a huge mapping? Or should we keep the sanity check inside the
SEAMCALL wrappers?

BTW, I have another question about the SEAMCALL wrapper implementation, as Kai
also pointed out in [2]: since the SEAMCALL wrappers now serve as APIs available
to callers besides KVM, should the SEAMCALL wrappers return TDX_OPERAND_INVALID
or WARN_ON() (or WARN_ON_ONCE()) on sanity check failure?

By returning TDX_OPERAND_INVALID, the caller can check the return code, adjust
the input or trigger WARN_ON() by itself;
By triggering WARN_ON() directly in the SEAMCALL wrapper, we need to document
this requirement for the SEAMCALL wrappers and have the caller invoke the API
correctly.

So, it looks that "WARN_ON() directly in the SEAMCALL wrapper" is the preferred
approach, right?

[1] https://lore.kernel.org/all/d119c824-4770-41d2-a926-4ab5268ea3a6@intel.com/
[2] https://lore.kernel.org/all/baf6df2cc63d8e897455168c1bf07180fc9c1db8.camel@intel.com


