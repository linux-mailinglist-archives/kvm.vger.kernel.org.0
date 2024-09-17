Return-Path: <kvm+bounces-27021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2372797AA3D
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 03:32:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DEA81F2383D
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 01:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FBC818C22;
	Tue, 17 Sep 2024 01:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nKjsg1G0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3EBF9FE;
	Tue, 17 Sep 2024 01:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726536720; cv=fail; b=sqZZo0x4pzKv5U05HFC+B53iPiGihg+DRp2ozSHA4eakGpifoCrEZwowFJ32yWqGDsRyCTE7hQsbjH9NzBWq4CMGpiEndPNbsyB5rRGwsmGstKrIbHsYVs+G4CEkNGosJ/bDBCfguoKk70WlmK85CtIr8HOs8ObddcoE1mm1twk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726536720; c=relaxed/simple;
	bh=BxP18mjEhssgeBHrRzUolNeMZKbHI8PtmyZeJft5gnw=;
	h=Message-ID:Date:Subject:References:From:To:In-Reply-To:
	 Content-Type:MIME-Version; b=DTgHFBTLSSR21NL3kNaUMMtNwjA61vN2YOl/UyguViGfH5NtTQJm1ILYbpQHzlDdXsiMlVg26MGCg5zclYbJeAjPKo1MkcK7zoX3qDisL9zvoBQnLIf180E64YrAXlBZ29PWcgSJJ9AmB96hfYOzaOT3c9lG9UtlIbKung4v7Lg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nKjsg1G0; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726536719; x=1758072719;
  h=message-id:date:subject:references:from:to:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=BxP18mjEhssgeBHrRzUolNeMZKbHI8PtmyZeJft5gnw=;
  b=nKjsg1G0t6NuqK5yISuCeFqZP8KJcIdjsLcg7V1gVMh9wyC4Ung04/Bl
   LZ9hAbC2ldAsw76LVhzggQ8JECSaT2o4a2mRIo+jHeE9fKzC/DwLBOzfe
   Gbvex48e04nm0RwWR4R8rJoAET3kv/18w1ehd8G+FBNEKKwHII9zcqoq+
   1THqJ554b3nkFkygej02/im5R7ZzP4Hnt4CEplDeUIz1wmD7a6+8Og/Xk
   HPC/LH072g3CvSvg92ZOywlKH0WW2nLVJVw5+SQCYjS7vw5PTUszSH731
   dOBd3apczT8SEEwA6Ee5uYc54LGLzGk6tb0yitOplKRqKVRAxIWlSKxdz
   Q==;
X-CSE-ConnectionGUID: FPNqmIvmRma2PxnxsiPOjg==
X-CSE-MsgGUID: +A1zFZmDSGWxKEF/IuQlgw==
X-IronPort-AV: E=McAfee;i="6700,10204,11197"; a="25264203"
X-IronPort-AV: E=Sophos;i="6.10,234,1719903600"; 
   d="scan'208";a="25264203"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 18:31:58 -0700
X-CSE-ConnectionGUID: hGwxteRNRrCIQQm4Apj4qg==
X-CSE-MsgGUID: tTthOBeRSReKp9m7nQDW/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,234,1719903600"; 
   d="scan'208";a="73794674"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Sep 2024 18:31:58 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 16 Sep 2024 18:31:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 16 Sep 2024 18:31:57 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 16 Sep 2024 18:31:57 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 16 Sep 2024 18:31:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P/WSF0PJSOUF0UzVFzmBgTOHsSEr6szccxa67n+vgyiRoM+NEuTrU5MBXK0P1PcOW2tbpP+DT9vd9sHBmP3RubmzjlNOw4gHXmspX+6RMJopGEcOHvhuwd13F007AVHZUYwU7bqXQKaaiPkIt00K/AdNpvgctXvDcWQWtkGEyko8UfQah0HbJbP5JroWWK7t1jN2aewMTzqzEL4W9QgLiGg1gyrbE9RNC8x9W+MRaacj+zyY1MLeTiUBcy4yw1nfMyR+X/hn4rKBm2QfywejzeUfi7w3ob1Vyi977ZRum6R7/hDt7ycJElPEgZZYE6mpyUrxBJfK04soAcQPmIf0fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UHlUaflNbVTZZKLjLS3Jc0dKafjxVm/RpCNo3Gof9UI=;
 b=ZXTnKQ/egU7PoXuPo6Ds1R52/rSSeIJMvbCWfQiKiXCPOdqMUUaNLkPFKEvCg7UkyeGzmEsrM2qFRUceaF794rtWKuR78DP3+1MLAk73LHpCmZ2rqQ8AlUdZcXebSfRiymQ/uwvjMDb51sxikbsVUPgA6QcLfFRFmBGfgEetx/LOowY5MLBRfPJOvvzd40FdYtFyV5D6Zf9eheEFfJrPF6VvRcX1tkrog0WEHoYvPshMjgAmgs0J1brQ4g/R2T18F+ir3c70My0/oSaVoztGpo3ZzO5qXWmNU/ZsUCHcGQNSF+ihIQSUooP91od3/CDyhw3FFx+KiD0+fdR+EnE39Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by LV2PR11MB6046.namprd11.prod.outlook.com (2603:10b6:408:17a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.23; Tue, 17 Sep
 2024 01:31:54 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7962.022; Tue, 17 Sep 2024
 01:31:54 +0000
Message-ID: <acc6f7a3-2dcf-4f23-b99f-4944fc66369b@intel.com>
Date: Tue, 17 Sep 2024 13:31:48 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
References: <Zt9kmVe1nkjVjoEg@google.com>
 <1bbe3a78-8746-4db9-a96c-9dc5f1190f16@redhat.com>
 <ZuBQYvY6Ib4ZYBgx@google.com>
 <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
 <ZuBsTlbrlD6NHyv1@google.com>
 <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
 <ZuCE_KtmXNi0qePb@google.com> <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
 <ZuR09EqzU1WbQYGd@google.com> <ZuVXBDCWS615bsVa@yzhao56-desk.sh.intel.com>
 <ZuaurXwXUyEjP9WJ@yzhao56-desk.sh.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>, Sean Christopherson
	<seanjc@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yao, Yuan"
	<yuan.yao@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com"
	<dmatlack@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
In-Reply-To: <ZuaurXwXUyEjP9WJ@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0262.namprd04.prod.outlook.com
 (2603:10b6:303:88::27) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|LV2PR11MB6046:EE_
X-MS-Office365-Filtering-Correlation-Id: c8825b8d-5c2b-4c6c-b51b-08dcd6b88338
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dUtFNFp1UzUwYUxrcTlQcFFKY2lqV0lZOFZlS2ZEa0hDRDY1amRKSW5yNnNE?=
 =?utf-8?B?Smw3ak5hNFplK2Q1Um1CMmtjRXI0ZEJVcEIrLy9iRWYvWWRFVDVyeDRoMlZ6?=
 =?utf-8?B?MlNXM3psZGU0cFZrUTN0b2IyYStuUFpkU1dkMTFqcUdNSUF0ZzRBTmZSak1h?=
 =?utf-8?B?QlhXQWM1S2NRNGhhbUIzeG5xK3VHZGNaeWZrYWRiUmgreldTWHRCMDUwV3p0?=
 =?utf-8?B?UDJ5RTR6MmJYcFdBdS9JdmpNeGJIcFkrUFQ5TmVhQmdGbzlBd1lXcWFlM0lr?=
 =?utf-8?B?dDI5YW9sMkxTMHBZbEt1ZHlFQTJhaFFSclZJckUyUHZvT2QwWHhveWlGeVU1?=
 =?utf-8?B?TklDaW5Eekk3Zi9FRnBxR01jN2FGdEZxelVodzR1OVRtOHo0enJmWjJpdGE2?=
 =?utf-8?B?Q0p1eUpHUHNIcWFBM2pVZXR3YjE5WDRjMTBFeXFJZVozT3ZiZ09HV1ZaZmlR?=
 =?utf-8?B?UVNVY09SRXZOc0JPT29RMHBGbzJIdGhzd2xsdjBocjIzaHEvYkg1QTZqdEhQ?=
 =?utf-8?B?QlFjZUhoaVp4enI1YzNHOEk5ajh0TjdndWVIeHNuTzU1NSswcGV6YnpkcnRS?=
 =?utf-8?B?SWQ3UitvdTg2VDhtanc3ZVFKcWhTd3pZbFd2WEVsVzYvbXRpWmJjcmY4NUFU?=
 =?utf-8?B?U1B2Uk1hV01pbUxUK0RoN0xWQmRtK1BOWHVUWitOODdEcklHR1ZYTVI0Q3R2?=
 =?utf-8?B?OGxFMk55SXhma1JQSkM1clNFVEtlS3o3TjNYbnhVSWFaR04yNTk2SVlwUThY?=
 =?utf-8?B?L085azV3YlFBbHlGWGc5UVRhSjdrZEVGU1RUb0dvUXduZ1J1a082TFVDTlYr?=
 =?utf-8?B?OE4vb1RqcHhGN1hMR2U3RHBzS2wwR1N2ZFpic2taOHdZQmNWQllFWUxoQ3hK?=
 =?utf-8?B?cDR2akVNMng2RHJaU1pScjhReWYwTk1FR2tjOTlkYy9WK2FSampHQ3ZaeWo2?=
 =?utf-8?B?clYyejU3d2x3dUZMN1c4NytuWGxpQkJMT0FBRTV2ZkhLa2lYNm5FZ0ZEcktj?=
 =?utf-8?B?UG5JY1VLZ3VuUGdzM1pCWDVhSlNCSDlRcDJSWWF2Tnc5TnJ6OWRIRFc0QjV6?=
 =?utf-8?B?bEQzNU55U1I2dEVGMDVKNk1YL1dGUy9kZHdMbWlQdUxQS3F6ajdGN3VhRzF4?=
 =?utf-8?B?Z2h0NlBEdEpsZzhvNVlzM2lYNlBHaG1oVWJ2NkRiQlVUK3pFTkpBSmpCSktV?=
 =?utf-8?B?L1VVR1hXUDZCRzA1clU5Zmx5S0hCcUcvWXNCQjhJdjNWb1BjZnVSQi9ITjNZ?=
 =?utf-8?B?aEI1R3RRNmdPbnZ1YVd0bTNBQ2RUUUcvbU5BTngwdXl4ZjVqSVh1TndseEQz?=
 =?utf-8?B?cmNSeStZbG5ubWFMeUY0U24yblRFNEJXZTFZZTVtMGFnZzZuSWxwSEFRbjRT?=
 =?utf-8?B?bHpIV3FnL0hyTWxucmQrL0tRbnp0d0VDaHdOY1FlS24ybDBpTXRodnIveXBD?=
 =?utf-8?B?TmFXdEtncWpjbTdhR1Z5dk1tLzUwVnA3UkQ4cVU4cCtGRWpDcjBWZHlqMTFJ?=
 =?utf-8?B?dGtYdTNoNlIybWtsVGFwQkNzMHAzdG9LQk43cjJHOWNoMFVYQndpa2dXTWFJ?=
 =?utf-8?B?Nm1GOFBPcWNZano5YS85a3U4TEl6Q0tHVU40a0VsVW9jSTZkVlpUR0c1UzdG?=
 =?utf-8?B?K05UdVFZWFc2Y1Nld2I4WWRZeElBclNNRkh5UmhYL21ybEQzZWI2d3NVUUhT?=
 =?utf-8?B?TkxnYWoxTk92SmJSVTNyOXpSR0hTZjExa0xWWlZLQXZ3eGFWeWRGMzNEaGZL?=
 =?utf-8?B?NmQ4WWRvbDExNUNkeCtLb0x0N3Z5MjRnbk4rc04waGFwdW53N3ZkcU8vZ0dG?=
 =?utf-8?B?TE4zazV3cWR6amErVnR1NmNFUW9FWXBMeW1FUVE0b1l4WkZZQUl4M2xkM25G?=
 =?utf-8?Q?0PCfaJ0B1i2ZT?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTM4bE5PdUR6QlVzc0lDeFlLV0trT2k0MzBHYWsrS3RPejB6bXVNZVhReTVL?=
 =?utf-8?B?QlI5a1pNYjFwNkRZN1NFdWJ6WHpqN3l5V3U2NVFzUEJ2YURXNUVTNDhoNzBz?=
 =?utf-8?B?cUtjZkx5NzlXQkFPalREZDBoMFU4Zm1EMjg0cWR1Y2VNbndScUxrYmVmeG0x?=
 =?utf-8?B?aG0vcjJ5aHR1SlFPNG1OR2pqemFEZHdLSm1JbXZEb3hMRjg2MVFJRXR4elBO?=
 =?utf-8?B?aUNvcjk0a3VlOHBkQ2JiRk1pd1ZDS2l6ZHB6aGsySGh4UFB3bmJtVHd1WW9H?=
 =?utf-8?B?MkNybGZpVVNubEZZZWVKdWlIMXdVUG5CbGsyYTFKT1hVUnpnVzFPdVRtR2pS?=
 =?utf-8?B?S3lvRnQxeVM4eU8reFZpeTdMbzEzdzI2dGt1V1Z3TUlMUTJZT2hkVDQyWlNr?=
 =?utf-8?B?aEl2VTNkQmwrekVLUWpya1JEUWFkRVpxbE5jbzQ3OGZheHhUMkZ2TTFVMWoz?=
 =?utf-8?B?NEJWVndqREF2c1FUVWxZdnJqWmF1Q0tGZUI4b0dZSGRGU2Joc1lJSHpkZmVU?=
 =?utf-8?B?aTNhWWoyZ2RmZmE5cHA0ZXIwTlJTMVp3enhkUFJGZmtZdkZIUWYvcUVTTkli?=
 =?utf-8?B?R25VVUxQK1hrTS84MXpFUXdBZHRqUUt0a3dJUDF2UmN0YlppNzVLZlY1Rkxn?=
 =?utf-8?B?WmFLMnI3dUJac2x5YlJFNDIwNGNteUVpelQyZ0NQb0lOdkV4ZTRIc1dHV3hE?=
 =?utf-8?B?dUw4aDFFZWF2Z3VXVlNndmdDOEdzU3BxK3h5b3BOWjNLMXRlWTVNeGVaTnJu?=
 =?utf-8?B?UG5CcWVRQm5hLzFseFo0SG5rQ0htQWkvaU13NlFxN2pyOFBGZFcvVGFWY0NT?=
 =?utf-8?B?SDBJbHJEWlVyVTdYaEZIL1dLOGtoYTBzSUJlNWZKeTVoa2w0QzlDa2E1dFgv?=
 =?utf-8?B?bFJtZ1pZcWlVdGd6aTV6NVZOMjNkNVFzZjhDTFQ4R3ZGQ0VLUXMvVkFTU2dy?=
 =?utf-8?B?Zm5uUVRKWnlReFhLbFArWkZTRm10NlN5bHhYcXhhT0pVT28zLzVMNmMyS2tO?=
 =?utf-8?B?dnBBNDVRbEJmZ0xQaWlKNEhnNGpxYktNbDlvNG1JOUZjTzh6SHZXcXBpeGFQ?=
 =?utf-8?B?OFZCcjQ0MGZ1Yjl3YmY3c2k1WUdIRTBHNi9XY3JEK1lEYURmeGZ4dXRnT3hX?=
 =?utf-8?B?alM5ckVkaFpFdHhjeUQ5djFaZTdHdjNnUUE1VXphNkYwdjc2aFBTUzdVekZj?=
 =?utf-8?B?RmozZFpBc3FVSnFKeS9HT1ZVOXZNdkRaVWlWOFUra1c4Z3lDUkk2ZUpuaTVr?=
 =?utf-8?B?aXhWOWdXZDBldjFIM2dlRy95WUNjTmEySEpWVmJ4dGEyU1FDb3dEdmRZeHdp?=
 =?utf-8?B?K29JWVM2eUdBOU9xeHh3VnJyTU9yV20xeEtwZnhpbDh3STNTdzRNVlRmbTlV?=
 =?utf-8?B?Z1RxTHhSbUc3KyttM3o1L2QvNHlOWXN6dlFzSmxBWW5SZEZBWm0ydThKUXRx?=
 =?utf-8?B?WU5RMFV5SXVvY0RKVSt3UG40MWMxKzlONFNscHBqT2RzYUMzYjNnTGFHYU56?=
 =?utf-8?B?MW11eUhTUHEzVy8wVVFYSy9aNFZCelVqbVRJRWMxb2RMRGNWQmN6clRPZjFv?=
 =?utf-8?B?d2xVcHpPYW1xRWdjcTdjSDNLcWF3T1A1cFlLREZwazBOWWtTL04wQlE1VHVv?=
 =?utf-8?B?OEJMb1l0K3JRYkNkcHhqdjhtU09icHRtZlF0OGEza2RnVVhkMEphOWVvQnB2?=
 =?utf-8?B?S1Y4UFZXRGg5WUhmOXhjRVRTS3NsN2o4dVdMb01zcmZkQ2lqZVRoNzg3RE00?=
 =?utf-8?B?QzdEN0p6cituSjVDT1hYa2NUU1RRcDRkZ3ZvZkdZVHVLeTJkWnU0QTN6SGhE?=
 =?utf-8?B?czl1YVdVU3lPSExqK09ldnQ4U3EvVTJIVURtWld1eER1Q1ZlOGgwekxOZXd4?=
 =?utf-8?B?TlBiYUFqbzVNQTcwYzl5RkE0MTY3WFlvd3RUcGJPMjJ2NllUU01aUDljT1FL?=
 =?utf-8?B?N1RLT01zeUJaUmdicWk0cmx4Rkc1b3I2S1JJZ3A3RmJyQkdBV0VtRW5RKzVh?=
 =?utf-8?B?UDROL1hDdG8xbEE1Q3I2VU1XUHVsK1g3c3BUWlV2cm9Cd2pzSExqZ1dVSFhl?=
 =?utf-8?B?Y1VwTkVBYXZBTFk5UW5wckcvQnZKdzBFNGdPS0NoekF0MGRvazNuRTJNNG9u?=
 =?utf-8?Q?whBLcoXUSuXJeB3/dzRTQMzBo?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c8825b8d-5c2b-4c6c-b51b-08dcd6b88338
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2024 01:31:54.5102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2odxdVmnCRTLK6jSG4Iz0JcEmRXKRy7W8/NwRbOW6R52G7vwudt9l8RSZo6ynSYNtz7iIBqzQn3aW0XxN03w7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6046
X-OriginatorOrg: intel.com



On 15/09/2024 9:53 pm, Zhao, Yan Y wrote:
> On Sat, Sep 14, 2024 at 05:27:32PM +0800, Yan Zhao wrote:
>>> Similarly, can tdh_mem_page_aug() actually contend with tdg_mem_page_accept()?
>>> The page isn't yet mapped, so why would the guest be allowed to take a lock on
>>> the S-EPT entry?
>> Before tdg_mem_page_accept() accepts a gpa and set rwx bits in a SPTE, if second
>> tdh_mem_page_aug() is called on the same gpa, the second one may contend with
>> tdg_mem_page_accept().
>>
>> But given KVM does not allow the second tdh_mem_page_aug(), looks the contention
>> between tdh_mem_page_aug() and tdg_mem_page_accept() will not happen.
> I withdraw the reply above.
> 
> tdh_mem_page_aug() and tdg_mem_page_accept() both attempt to modify the same
> SEPT entry, leading to contention.
> - tdg_mem_page_accept() first walks the SEPT tree with no lock to get the SEPT
>    entry. It then acquire the guest side lock of the found SEPT entry before
>    checking entry state.
> - tdh_mem_page_aug() first walks the SEPT tree with shared lock to locate the
>    SEPT entry to modify, it then aquires host side lock of the SEPT entry before
>    checking entry state.

This seems can only happen when there are multiple threads in guest 
trying to do tdg_mem_page_accept() on the same page.  This should be 
extremely rare to happen, and if this happens, it will eventually result 
in another fault in KVM.

So now we set SPTE to FROZEN_SPTE before doing AUG to prevent from other 
threads from going on.  I think when tdh_mem_page_aug() fails with 
secure EPT "entry" busy, we can reset FROZEN_SPTE back to old_spte and 
return PF_RETRY so that this thread and another fault thread can both 
try to complete AUG again?

The thread fails with AUG can also go back to guest though, but since 
host priority bit is already set, the further PAGE.ACCEPT will fail but 
this is fine due to another AUG in KVM will eventually resolve this and 
make progress to the guest.


