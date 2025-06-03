Return-Path: <kvm+bounces-48259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D0DBACC01F
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 08:22:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4AE81891722
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 06:23:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0270B1FF1A6;
	Tue,  3 Jun 2025 06:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rjl2jP4l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B2E125B9;
	Tue,  3 Jun 2025 06:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748931765; cv=fail; b=Ryl0fRt5ZrD8dxiaNtb8VMp4qsvxKbqcq5Z0Yx2bz1BGLYsxTZhTj7sqsibc+efROBxUkdeFNTzwlAVQz724l3hEIR5ty3OANoQsyzEMizkGFgy1feC3zdS30YTAtrak/7WURvXcIOqUR+4dxHDeIR1JBBXIyxZ0vOs78dt7Rs4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748931765; c=relaxed/simple;
	bh=HS/UrQMlADiYTl+0il/xIgRJLT1aPEqbJEnmOWR4958=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dhlWPb8w1SYCRaGRTbWdRJgWWrc6plSejE3LdcCxzDBVdb1sBwcOTrEsp2tde4WZINBoP6mD4eG+C406W6V2wXcOArC9TxgQ6hXorw1/eTmf5bOzDcosy3CUBnbwHW7eM0p0LPN2m6UFlB1mnZ0vnKQhzN0RqArLpajjMrcOjO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rjl2jP4l; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748931763; x=1780467763;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HS/UrQMlADiYTl+0il/xIgRJLT1aPEqbJEnmOWR4958=;
  b=Rjl2jP4leb/XspvAOJ4KbSgoCTHLH9WsZibjvRt5zXOu5lKAWwA+btYI
   L4SRnDqPm5P5C58k/7pycy/gIrja9a7l/R7LLlqrRmFl6R3Zn88c6MAPO
   iLFcM/O9S6WgdrFqZjyelwePi3tDoqFBVDKLncqcp/HTPettRCUNfuhXQ
   QbtFqgcA9xnq4zARCVSPyNFPD7NI1XIN5D+NdZM1tEK9orgYbqi6LENLL
   IOTXPeWSKRtAlrBNz0ooON7ATr8OtYFZwfNb922X2ZlLCkkeR4TuVL5Id
   7jiccRSvSkgzrC8ryrFcBEMIz1MyA74p6oX2GAXdxjotau5w/ePLCreBj
   A==;
X-CSE-ConnectionGUID: ve01RdYBRJmdBOu289Rx9g==
X-CSE-MsgGUID: JEBoWhCcSPyL31iURBZJAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="73487909"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="73487909"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 23:22:43 -0700
X-CSE-ConnectionGUID: zh5/uvAVSwudxVZUNqJtpQ==
X-CSE-MsgGUID: bmJp0+//SPKYxezPNDQhoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="145740546"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 23:22:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 2 Jun 2025 23:22:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 2 Jun 2025 23:22:42 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.84)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 2 Jun 2025 23:22:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nda7q1i/Bvx2iIECcg4bXIFpssqttpq6KTd66KtfTVybl2wgbclYemyK2Z0WLAjrGBhpRW6z5N/KZLYP6Hxl/VTV5neRQEDPcDepUTBxGjkGr2+rBKGacnJ33eNOZKZN9ut9QMLaKXN05kmi6aGUxM/E7rUcRC/C1L0qifM4YTUPjuNmu34w5uur0p16rzkDaIODEGyQLARNuLh0vBWwSqMk9Cwa3EgK3qzhd+1pTP400GIh2ze+CmB3S4B3nfmte8GLUonbvlem68j1YrldstjjorlpHW58GfawKhTx9lIk4LTMDXJeFyl7Rvd8/MP3PIUZQSnR6J2JgwJHzP7C9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=01+6ZEC17cwfsrRgT5Gu029kw9UHuoxFErnx9TZAPtc=;
 b=ImboOsA/lrXkU0iqS2odNDrs59rdx1FZVEadWauN5uNb2Z/a16kxuTgbbqqDo0cZCnWzmiibx05v4Oap7XHJ03p5dzUWWAZBJ+Wpv9RFt4N8WUFi0D28DDYc9itG9FnbDUfoKAJwCRibcQNbgadV8oyyQheKPqdxBPRyeGxGcNrHrQSL5ih2qxMFpxjYnMuq6eeyH+af6ooquQZzuAwqIRQ/7gB7YSe8BRvTx4H8T3k1gciZWCn8Wv0hv3Z5col1YupYoMRVPSxNXop90l2NQNvGyZ5hflwHNF8uA8tmFCu9DDQu5TBTEvqFyIr/TLt70hRFEBJjNvsr3ZJzjJSxGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB7683.namprd11.prod.outlook.com (2603:10b6:8:df::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Tue, 3 Jun
 2025 06:22:34 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8769.031; Tue, 3 Jun 2025
 06:22:34 +0000
Date: Tue, 3 Jun 2025 14:22:11 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
CC: Dave Hansen <dave.hansen@intel.com>, Sean Christopherson
	<seanjc@google.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <tglx@linutronix.de>, <pbonzini@redhat.com>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eric Biggers
	<ebiggers@google.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar
	<mingo@redhat.com>, Kees Cook <kees@kernel.org>, Maxim Levitsky
	<mlevitsk@redhat.com>, Mitchell Levy <levymitchell0@gmail.com>, "Nikolay
 Borisov" <nik.borisov@suse.com>, Oleg Nesterov <oleg@redhat.com>, Sohil Mehta
	<sohil.mehta@intel.com>, Stanislav Spassov <stanspas@amazon.de>, "Vignesh
 Balasubramanian" <vigbalas@amd.com>
Subject: Re: [PATCH v8 0/6] Introduce CET supervisor state support
Message-ID: <aD6Ukwqz2Q5RKpEm@intel.com>
References: <20250522151031.426788-1-chao.gao@intel.com>
 <aDCo_SczQOUaB2rS@google.com>
 <f575567b-0d1f-4631-ad48-1ef5aaca1f75@intel.com>
 <aDWbctO/RfTGiCg3@intel.com>
 <434810d9-1b36-496d-a10d-41c6c068375e@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <434810d9-1b36-496d-a10d-41c6c068375e@intel.com>
X-ClientProxiedBy: CP5P284CA0239.BRAP284.PROD.OUTLOOK.COM
 (2603:10d6:103:22e::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB7683:EE_
X-MS-Office365-Filtering-Correlation-Id: 02c132c9-d4e4-4451-7b17-08dda26706da
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?QEfhqxS+0jgWGV0p6gVhdX2SuKGUpP4D4suuF2eFJDUL9mf+yGzIcdaIdBbl?=
 =?us-ascii?Q?gBsMk59StpszS4rdzcQj6Hg8/jOnaNHVaDqq+Q42LN8DJt1kB3lZUOg0rvnV?=
 =?us-ascii?Q?+4DjZg3mIyre6muXNLJTK3N7sAcTM0njJsXoeuPFH0am/LjVB9YyqGCwRano?=
 =?us-ascii?Q?JSRHm4w34pD31QbgM3Vk67o0d3r1n68Ah5qzG0nmEuytxUbAJLYKC7/sKxg4?=
 =?us-ascii?Q?LYRR2skaJFgMaM0Thh7B3RAhTrvWY/xAtQ/eyI4h1CPB3rZRSXYt8K5HMlAo?=
 =?us-ascii?Q?NU43kiA7d0peeEzPtQC0oXAwkdSaPrly5gP3em8eOW4KFkmjoAAzRIt2DNFi?=
 =?us-ascii?Q?UBXzKIQCyCcaeAh+dGVAH/Zaa9Sg54d2wA5Pl2kdy1nbE7xfca/0m79W8+6f?=
 =?us-ascii?Q?QsZPIi8E9GsGzSZxVPo/GEmdSjsBOSfjhiZE484d75rJYMjsxOlct7Ad5Wdw?=
 =?us-ascii?Q?nNbhjpxvG+lyn9hJdWkK/nFfNvjkW1rqFBP7DPAQcb6RKxrFPaqM43PB9gZC?=
 =?us-ascii?Q?LE2Q+0uk2fN+OBWVlqDEZzjntJ3+KDWhIWc3hfzA1NBmDQHyN8NTyYBEYOuN?=
 =?us-ascii?Q?Zh995641xzXOdw3ETnkRJ6pGOzRkPNW4rZQ1BjVUhEdPD5xGEvosQeW4Fjpo?=
 =?us-ascii?Q?nBqJxMUGC/xW2NCyJaViF3AVMPxXcon2dWZO67aAJC6lTT7yCU4bey5/GjRR?=
 =?us-ascii?Q?1EUYx1ObPX4rbCpmFfEWbnPT1ged6lXa8C6RZjLtKByD2gWJkieh3VmdRdly?=
 =?us-ascii?Q?QYmFBMqdd+aIuQvFC8dqqOz+z4tANKEKC5ERmEd8HeEJgkQ8TZ9wW6aU1DJ2?=
 =?us-ascii?Q?xajbxCFYn5kbT4PSSqVoJyxlPF8Tf5axnL+xJ1d49p3aC89G/d6ILifUtiBT?=
 =?us-ascii?Q?F9131jsZHTe2YFLqYg3cbFPTqXLwhURDK8zjtRtqWJb/ew6V1hLm+CVNgpZf?=
 =?us-ascii?Q?fRidcCTX+YxY8y9sQSkn3zjkU6S4W9tnit4W3BApKdu7k/a+KT0tesOpEHZL?=
 =?us-ascii?Q?U/Z9uVJsv5uuqXIm0kQPNOsxJT6iimfCzU+BiFnPrPDExQrwGtUwhewpMATq?=
 =?us-ascii?Q?tAHsqkXBE2CYsWnDrXRY5PGNsfdcezbUJ1pdJCfMr7Y560Vqpcq8ph86Aib/?=
 =?us-ascii?Q?au6BSWxu0gsBaDv3R7hYvqrtXPWgizEXC6NFArolQKem71XC9wzRduB71JeE?=
 =?us-ascii?Q?TzZOSlxSJU0G+YdQSrY3SQAWRyGWqycwfkN6UjPZqZ3Y8+lp6+pnVP0uOJvL?=
 =?us-ascii?Q?kcNdPR0fN+Rash+KDhYEwXXKkb62U2+gJNvLDl0hnXEHQDT2ghQSh8AuwY0N?=
 =?us-ascii?Q?vVeIJbGes+kgXlsr+Y7z9QzF1J+mgt/SeG+A5aU+hkN/xin3fbVUHlTQ4hS1?=
 =?us-ascii?Q?L7XJ+ZpepI56Q9eSiG0fWPxUbsaGTfUunQ7fondYWonbk/pyq3koOjMFm9zS?=
 =?us-ascii?Q?BFHS610Ku88=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wMdL4rXqrJARV031V/691msp4WVVCijaARFeQCRmctJHVlOQzlrE5B+Pn/Nk?=
 =?us-ascii?Q?oCwKhaK5ch3iDjnED7ksCp4AMWxhXway+vbemo1v9UYTyBleqomfC8VT6OGd?=
 =?us-ascii?Q?7FjRbuLnnp+OBgW/pOR2+jRu07+5WdebR644MYPa4yBGaJR6WlYdd8IwEd2W?=
 =?us-ascii?Q?YaidOyivgActpTEgRP38YX9aPPVRuM5SNg6NWp+LB0wcSW3HFX+ezXEn3Yil?=
 =?us-ascii?Q?0jRWyZYoiLKkStaVOLv9e7/aFi+WxcgHhP4W3MoqaOtdmTd7LZpYsK+PbZNf?=
 =?us-ascii?Q?Jn8PN9C6PptyigJnK1OQHLcb2GP4MwHr1+giCB7+3DdmU+jMBe8FqqXeHcAj?=
 =?us-ascii?Q?dvGjaCWdK/NejjNRIaWWG6GbXzga2AgKMRMH3HBtJCrN3UmMfSuyKDDjTbGo?=
 =?us-ascii?Q?XSqcPXbZb1eFO4Mryii2HvoH7N0t8SR/NBIKTdzdOYsQwU40bcJQLlzTDYkf?=
 =?us-ascii?Q?tmXlAFeS9YgS0M+x4yhzcHzb2QNyDFhBRYoccj+q+wTSQzoOUPDPWNcOG/GB?=
 =?us-ascii?Q?PGns/qksxdzUT65Fu1cUhSUZmn4uEdHGqepNtNh7aCfVqPVWHkpRWFytbwsN?=
 =?us-ascii?Q?JrI4QLwKX33Dlmac2m0JE2j1l72aSbzYh3sghbQAVJBVTmt5l5Xf4eADeEWK?=
 =?us-ascii?Q?KyMzGJY6edyRKT/V2ioGRXh/cUwOu2wVh0oHAnk/bfeVxvchFh6sB7/Fz49/?=
 =?us-ascii?Q?mvnj+/mvwxCrQgEMyynru7FWHS95+B2GyadbLf1VUCTWCLpGZ+AmZ7m4/Wo6?=
 =?us-ascii?Q?XRJ8H10DYGhKnw9dJpZyh777cUNm0AdhemoeqC+bW94hvftPGQIk80PmYnCl?=
 =?us-ascii?Q?3e2vb1WBitcTpxD13ZCWyH0NrPEBsbH4+p942t1kupuxDCCX7q4aQ6NJeE4E?=
 =?us-ascii?Q?PhvcbJlkW4qTKwTqwcFX85VTFjXCb0FDP1dQ6syIRg9eWnKPkhnrchQUwe/M?=
 =?us-ascii?Q?NEPfzEKX3/vfbTUN2dd0VyKWRVIBTJARQepbAgAKaTU5Gvf0fOIgaxnBxt2a?=
 =?us-ascii?Q?bMkFlFLcgs6h2p04ZvC8fklGiANx3/+SGPFQRDJrgfW9h7pHtl6vbCmjByWh?=
 =?us-ascii?Q?bU+HOE/DB2HkmldcbmPp0goIAP92NMArf1An+r+/mplP4Lk08BuVw28cd5mc?=
 =?us-ascii?Q?DVSXaaKFmRny9VkllsDALZE6XmqRDMtQixOKni1PGXshW4tKIgv79voUN/rY?=
 =?us-ascii?Q?KuJJYEA8c590xpi127VDXXZnnenzxPsNbKxSR2z0IborRA6JyIpO4UKWXmBh?=
 =?us-ascii?Q?VrCDJ/Rl5slmShsrRoTPFf8RJxltnu+yNZOTUwkJerZKuJCoxT5YU0C+AKk9?=
 =?us-ascii?Q?2AGae9h+wOLn/C73sjUaNnxohF01igUFH1sgd4Jz8xoyj+lYfd7ElmRrBsya?=
 =?us-ascii?Q?S1yZeJw11vGAaO9JjxMkXA0+YDfSEyhx5tiFXs0Nh5beHIOkCfL3KNh2LXu6?=
 =?us-ascii?Q?IUmxs9WBIg19ktQvyOsbUEQ5U0wGtOilALJJPtu/fXbniOHdYY+31fg/doQC?=
 =?us-ascii?Q?6Ypz7d7qqwHPhWU/iMrJHfQFBHf8a9YWxwU4cZ9K88XqlxrU0YRwB9/1oSy2?=
 =?us-ascii?Q?FbtZcrEGHQFdq8URjjhH8q5+et/C4CQZpVwuU1li?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 02c132c9-d4e4-4451-7b17-08dda26706da
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 06:22:33.9271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rTRI0SdQBvcT96UZEIGo5jBn2btw/6Xcbs7qpwWUnkHyimXJhRccsqljggRp3PeOadJ/pEjuEb7etphu7YC60w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7683
X-OriginatorOrg: intel.com

On Mon, Jun 02, 2025 at 12:12:51PM -0700, Chang S. Bae wrote:
>== Preempt Case ==
>
>To illustrate how the XFD MSR state becomes incorrect in this scenario:
>
> task #1 (fpstate->xfd=0)  task #2 (fpstate->xfd=0x80000)
> ========================  ==============================
>                           handle_signal()
>                           -> setup_rt_frame()
>                              -> get_siframe()
>                                 -> copy_fpstate_to_sigframe()
>                                    -> fpregs_unlock()
>                                 ...
>  ...
>  switch_fpu_return()
>  -> fpregs_restore_userregs()
>     -> restore_fpregs_from_fpstate()
>        -> xfd_write_state()
>           ^ IA32_XFD_MSR = 0
>  ...
>                                 ...
>                              -> fpu__clear_user_states()
>                                 -> fpregs_lock()
>                                 -> restore_fpregs_from_init_fpstate()
>                                    -> os_rstor()
>                                       -> xfd_validate_state()
>                                          ^ IA32_XFD_MSR != fpstate->xfd
>                                 -> fpregs_mark_active()
>                                 -> fpregs_unlock()
>
>Since fpu__clear_user_states() marks the FPU state as valid in the end, an
>XFD MSR sync-up was clearly missing.

Thanks for this analysis. It makes sense.

>
>== Return-to-Userspace Path ==
>
>Both tasks at that moment are on the return-to-userspace path, but at
>different points in IRQ state:
>
>  * task #2 is inside handle_signal() and already re-enabled IRQs.
>  * task #1 is after IRQ is disabled again when calling
>    switch_fpu_return().
>
>  local_irq_disable_exit_to_user()
>  exit_to_user_mode_prepare()
>  -> exit_to_user_mode_loop()
>     -> local_irq_enable_exit_to_user()
>        -> arch_do_signal_or_restart()
>           -> handle_signal()
>     -> local_irq_disable_exit_to_user()
>  -> arch_exit_user_mode_prepare()
>     -> arch_exit_work()
>        -> switch_fpu_return()
>
>This implies that fpregs_lock()/fpregs_unlock() is necessary inside
>handle_signal() when XSAVE instructions are invoked.
>
>But, it should be okay for switch_fpu_return() to call
>fpregs_restore_userregs() without fpregs_lock().
>
>== XFD Sanity Checker ==
>
>The XFD sanity checker -- xfd_op_valid() -- correctly caught this issue in
>the test case. However, it may have a false negative when AMX usage was
>flipped between the two tasks.
>
>Despite that, I don't think extending its coverage is worthwhile, as it would
>complicate the logic. The current logic and documentation seem sound.
>
>== Fix Consideration ==
>
>I think the fix is straightforward: resynchronize the IA32_XFD MSR in
>fpu__clear_user_states().

This fix sounds good.

Btw, what do you think the impact of this issue might be?

Aside from the splat, task #2 could execute AMX instructions without
requesting permissions, but its AMX state would be discarded during the
next FPU switch, as RFBM[18] is cleared when executing XSAVES. And, in the
"flipped" scenario you mentioned, task #2 might receive an extra #NM, after
which its fpstate would be re-allocated (although the size won't increase
further).

So, for well-behaved tasks that never use AMX, there is no impact; tasks
that use AMX may receive extra #NM. There won't be any unexpected #PF,
memory corruption, or kernel panic.

