Return-Path: <kvm+bounces-45545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0558AAB8B9
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:40:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AC7D1C40A5C
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 06:36:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D80EC2F20CE;
	Tue,  6 May 2025 03:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TLclY1HE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23C634FAF9;
	Tue,  6 May 2025 00:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746492969; cv=fail; b=DWGZa6RpnRwyFqiBdcIlvHwYWMRXPNNB/I9Rgpwx3LLJfvbLJOUpn419YgHhEH8Rxz42MzRdupWhLmdSZUupdaeE0/Ek8BYuPNJf1ffnozIO/Wv/AK7u8QN+UJ75HH5NukSSddikRsGiqYhB3X/cVhK3ZKeWUylNMBZ9Xg6jBnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746492969; c=relaxed/simple;
	bh=F4lh1V/V5d2qRgDWrdM6Deu3bL0waEiMC6wchGMnsjw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m1vD9DgE1rg3UfXdPp438nSMxr4LNRNObYFYpMjDYnZ1yPC/wG8HkRUPP3XobNnfuIdsFMOTcNg0wL6nXVGVh65NvoC4O0EwGwFVBsKX50MdyTiKeN3OgA2P2oCbMYSAaJiyEMoVzfCHxn7+pxESRfbU9LxLvR9xroOH5V3MU3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TLclY1HE; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746492967; x=1778028967;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=F4lh1V/V5d2qRgDWrdM6Deu3bL0waEiMC6wchGMnsjw=;
  b=TLclY1HE7iy6g5HQTGDH1oE46w8QiHHR75KNtgKE77z3ZHjNxHzr2ZoQ
   gkBghO4JpD0IxUCc5TkMCw7Q+HL9Vqmz2QKyoqbRKIheviaxxGlFsPFAQ
   AY/7MQhRg4J+wE2Nz35s9tU+687xJaZNs3l+i/azTiD//P6aexl3H1bif
   ihxlUWTPPagGgWckKp9jj1J/w3qosww8fqfrinTL3J3GiSfmU3VJqAZJI
   XiiGyI6dPiAC5DWOnZPCFmape1mpVCNKn1woTm3HjL42GhEOt0W8hmcfA
   YSIU9ZkxP6/Yc5jqo+ZF0hbqiMJ78QLnoSDciSr/1236/uyi0QSePWEy1
   w==;
X-CSE-ConnectionGUID: iKOnc1O3SZ2oDmcflxmn3A==
X-CSE-MsgGUID: Txolb+eeQ9Sx8mtoIUzoDA==
X-IronPort-AV: E=McAfee;i="6700,10204,11424"; a="70634631"
X-IronPort-AV: E=Sophos;i="6.15,265,1739865600"; 
   d="scan'208";a="70634631"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 17:56:05 -0700
X-CSE-ConnectionGUID: FdhSwTJERbOK7LManzvR/g==
X-CSE-MsgGUID: 7Gi0+tErShWH1jPIBgMRHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,265,1739865600"; 
   d="scan'208";a="140572616"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 17:56:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 5 May 2025 17:56:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 5 May 2025 17:56:04 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 5 May 2025 17:56:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WqjPnmiMzwHL1ChHo0TCo71R2Xua5S/8ptWkoNowtEkqFm3XPk5UgmRJiK7Bc0RAq7ctc+q5LnHvN2kYFT7ZsC0UeBB6NZETbMATCX4ltonEZBKNXIhePpnHMDnOQtOcvambW/Ot9+13AzecfqS8Iho7RxCOORVpJTkBM2LIwW1X2PCWshrTnRsjOM3BocuTsIwUPouBomBUKw3HZnm9yCo+jQ6qYHhFsRIg4i1CyRIWm1bvOzWaAW/GYc2tKX7FPs4KNBIOMW9GWqDbH6d7YZcPqyFLQAFD3BO778tVU2Bv9gcOcbo3D3AAsvT8beOCwJDSECOz/DXgSxKAUz4xLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PL/mLh1wYn20dP457bAMZS/lqRNbR9lFyFk1WeOj/aM=;
 b=GNmXjjjqTs3OJyLs80KPrSmbQTPCJwIYxpST3rE112shFrepZRKCzOi886aFXErP0NjUiSmBRyMVtjIF5lvHp9F2StUmrOIOSRrODQkiM7iwQsUIi2gvLP6A7NinLZbpDIqO36PEE5e9wA9FK58cEyt/Ro0imOokW8pJHnr68H8lKyEwe4eCp3WbpLJnoOnbBkNUK+Se8kiL/YjqCEninPnNieU3E5xIarJcAQmk/9fmdEFM3+2PnyRE6yybh0evAFGQLJ7fuLaclr/rspYnrHobbJOqnijEqeIGYCYOvjxdychVLi40Tb0cOE/Zy1oQQjByg/i/FMjECUPUx3oeJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB4790.namprd11.prod.outlook.com (2603:10b6:510:40::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.26; Tue, 6 May 2025 00:55:28 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8699.024; Tue, 6 May 2025
 00:55:27 +0000
Date: Tue, 6 May 2025 08:53:26 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vbabka@suse.cz>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pgonda@google.com>, <zhiquan1.li@intel.com>, <fan.du@intel.com>,
	<jun.miao@intel.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aBldhnTK93+eKcMq@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030603.329-1-yan.y.zhao@intel.com>
 <CAGtprH9_McMDepbuvWMLRvHooPdtE4RHog=Dgr_zFXT5s49nXA@mail.gmail.com>
 <aBAiCBmON0g0Qro1@yzhao56-desk.sh.intel.com>
 <CAGtprH_ggm8N-R9QbV1f8mo8-cQkqyEta3W=h2jry-NRD7_6OA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH_ggm8N-R9QbV1f8mo8-cQkqyEta3W=h2jry-NRD7_6OA@mail.gmail.com>
X-ClientProxiedBy: OSAPR01CA0312.jpnprd01.prod.outlook.com
 (2603:1096:604:2c::36) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB4790:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d35056e-e12b-46f6-889e-08dd8c38b140
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cktCd3J0Y2VJVytqY0VDMkxvZlltTmtBMG42NmhPWXY1djFhN0FpaWlYbmRN?=
 =?utf-8?B?Vi9TbEp3ek0yUjVJMVZDWE42YVR0SWRBaU5GMEpYMHRCVTBXUnErUmh0ZU1N?=
 =?utf-8?B?ZW9mZmI5djJ3SjhSaTNxbEYrWVB6d2pTT25pdW1MclBXTnZoNVQ5TkZ0QWdU?=
 =?utf-8?B?bk5XUEp4M1NvTnJaYnNoNjRxWEdRSTFvU0NwQnJzNGgwYzhEZlNrUy9qZE5P?=
 =?utf-8?B?M0FxcFNpOWlXM2UyY1Z5MUVqdjYxUXpvN1M4clI4QlQwaldiRk11Q3RxdmpN?=
 =?utf-8?B?THJ0RDhVKzhBWHVINS82azIrL2Nlcld2RDk0TnNWK1o4NHkwb3I5NldtR25s?=
 =?utf-8?B?UEVHcjc3dVNWbjgrOGJjSE1aMHc4ekJGZDlEcWpUeUZBTEczaHlOaXY0amt3?=
 =?utf-8?B?N01oaTg5cWlJbVNRYXN4TDZZQ1VBSHgzaDFxTnRMbEQ5UHYyOFErNnEvSDBj?=
 =?utf-8?B?cjFTVE10N28waUkwMm9qSFZBNk4yeFVRdTFEcTVlSFFQUHJyTnU2TnEyL2Fp?=
 =?utf-8?B?QU5EdHYwWHR3NEJoQWt0YzB2eE9TckxyTC8yelJ3Sm5IaTRjQ0owb09uUGhr?=
 =?utf-8?B?RVE4b0RSeEw3eitSVFczeEZRakRDTjYyRWZUMFAzZ3ZINFZxNkR3TUVUUjJr?=
 =?utf-8?B?S2VQeTNRTy9xQVpMaFJidkZiS0lFMUx1cXBBSEdkY3R1a2w5MkdCQmdKY2Zx?=
 =?utf-8?B?RHRxeFRkRHRBeGRNMmNwOU5uWFpXQXdhMHB5WDFtaERLL0hWK2dGelVNL1dT?=
 =?utf-8?B?VmRWcXRFZGxWRFN0Q1RqcjQzRlBnbXJBT0hqVUEvLzUxTXNrRFZLbkNYMWlq?=
 =?utf-8?B?YXk5Vi9rZHpRZU1nVHphTU94TkhuQXpyQjlBWFZFdXhIVzNMTlg1R09Lbktt?=
 =?utf-8?B?OElVRDNDZWFmWVdvRHJqSm5jZEhqKzhUQnJRNGNjcXpoY0ZJTkJVQW56OFg2?=
 =?utf-8?B?elBpUm5mbU5wK1JJc2t4QkFpQ0IwWkhnY0Z6U0pwNko3WUw3MWV0UkdpYllR?=
 =?utf-8?B?VWtwb1gxM2lKWmc5Z01tSGRnMW0yS1pQdzdScWdIcVN1czZmdzFLVEVIc1hm?=
 =?utf-8?B?VFBaMHo3MzFNeCs5OTNoaFFkUldXc2wvVXRld3VRTDJPODZoWnZ3amYvUTF3?=
 =?utf-8?B?R01zM2xvNVBwZ05yZExIbXIvaFMzR3BXSkg1M0hLUTk5UjNUOWpwampUaVR5?=
 =?utf-8?B?dGxBYWxMSU42ZmlTREJyK1BxU01SWEM0V2dRTjBaRDNRUEZYMkFXZ1Bpenlm?=
 =?utf-8?B?ejdjN0NjZ2pBSkZML0dmaWNiRG10TUF1QjloeG1iQVFkcXBOZjdpUWxxVzZo?=
 =?utf-8?B?S2dHQlF4WlYwRG90L2FJa1hxUC9kNkFjZlQrN1RCZFZNcTVJdEpBTHRheUU0?=
 =?utf-8?B?czRONmV3aWc0dUJSMTBGNmltcnJETWkwN1R4NFJUcEJOcTFFU0c4VFM1K0Zx?=
 =?utf-8?B?Q082eFRFTGYwNncxMG9XenlybHRWMC9JQ21iOW5GRmFFOXkzeDl3d2E3c3lW?=
 =?utf-8?B?UExXcytCcitHdjRqUThCWHpybStQM1dzbFQ2a0U1MzcwMHRQbTJyajlBVDNY?=
 =?utf-8?B?UWoxd1V1TEF1YXgzaHBGanVQWUpITGd1V0dTNWRKVWdDQ0hUTVNxUGlBK0di?=
 =?utf-8?B?TDRtSS9nakEvalJrNVB5WlAvOXRRNVdHZnkxL3MzczFhck1FWnBYQWoraGFL?=
 =?utf-8?B?Rm1FQVBwS3RzWmxIWXV3cnBrV2dQQWxIZVowWVZOcmdyWHdIdnUzaSt3VkNn?=
 =?utf-8?B?ZVRiSk9ZTGJISTIyUTJvRUd5UFR6a0laMTNrYVA5L2RQTmVzS2crOC8rYjNu?=
 =?utf-8?B?bzZ6Y1l5dnUwcmhYd0VMWlQ1aDFzYTJod1hTOTlIbllBODcrZk9Gcm1SNUpw?=
 =?utf-8?B?aHovT2g0cC8xMTl2UmxIcnY2bFU3UDU0ajc5cE0xdzRyekNOUXhHVWhpK25D?=
 =?utf-8?Q?HsLkZ9dcXHc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dTBVYkx1MUR0c2JmRGc5bkFlZytBU1F0NW1BbHVWbE5GVmgrSm9xV2NqS2Jp?=
 =?utf-8?B?Z2g3WUN5aUR5d29Jb29Pb0NRM0FrQk1HYXNna0gxSlNwcEcybkM1aXRJTUpM?=
 =?utf-8?B?QTAxNXBRc296bVA4aHJubFRBSmZzSXFyK3hBcTBPN3FaQ0pxbVR4dVNZNFlx?=
 =?utf-8?B?VGxnOFpJdDZLVlZvRmFWQ3ZPVDRURFkxWGxGVFVlMzJOdy9VRkJXc1NQK0RS?=
 =?utf-8?B?QmpYcGF5QmNsbmFEeFRIR2xuUHZTMFhFNzRCTGNoMmNyd2t3OHpYam9UOXJR?=
 =?utf-8?B?VmFodTA1MUluSDNNRGllWWFoSS9KbTI2UC9FWHdmZUVzKzNOVjRnaVJSWFR1?=
 =?utf-8?B?MTFTY0YxSkJSWmlQa0dZc0U2VlViUVJyT0hQcDJ1SEE3RzBGOG5ucnFCYi8w?=
 =?utf-8?B?bStyZE83cHZBcU0zdTFqeUMrbGlqWWkvTUczNWhaRk9Xb01ZNEF4YzJHa1Rn?=
 =?utf-8?B?MVFLL2puSEF6clc4SURUUEFhSjJUeEpuVnl4eGNhQ0J1UzZZZjBoZkVaeW1p?=
 =?utf-8?B?YVpxR01xelRJZ3dNWVlxZlFpZW0wVlRVYVlYK1ZkZGlwY0pJQWV3WlBhQTNO?=
 =?utf-8?B?S3ZIOVorU01TYnZQbFg4UG1mZW1HYWhOT01URHRDb1RGNFpVNTF5VkhhWnZV?=
 =?utf-8?B?MHhNbFdXYUNtdU1YTFdsZ2kzaG1tcDhSTkZqNHJEV01zYUF3cCswWitva0py?=
 =?utf-8?B?L1VGRHRRVHN6Yk1mQkpFaCs0clZYVkZUNUhUcHpvV0dra2t4WEVpWi9jT1Na?=
 =?utf-8?B?UUxRdzczeXZ1T01HUHdBNkg0eVRKUjhTeHZ1M1VEQlVrQ3NiY0REZ0VKUkRE?=
 =?utf-8?B?MTg2UklGS3hIMVEwc3BPbTNSa3BHMkc3Um5NcTlVSmw2bVREY0lldnJuQjNI?=
 =?utf-8?B?UjhjT1ZIUlM3RDVmQVFpVldlY3NXS1hmL2NyTW04NitKMVY3dmdzRGdZcnZU?=
 =?utf-8?B?VU13Z1Q2Nk53cWhYVXlaUHRjMHNSTG1uWnRPTWQzV0FucWtBbVZsb2dJWTQv?=
 =?utf-8?B?Q3lWdk1ySXU0K2hXdEhpdmtWd293NVB2NUJGdEVwZzVlSU9Zb0tpNStWdUFZ?=
 =?utf-8?B?QnFuN1pxL3lzUUhSYVk1dWJiM1dwTTA4clE1blMwcm10WmloemJpeFZRS3Y4?=
 =?utf-8?B?WjJEdGRJRncyNmRzaHlKY05lVzNkYTZpWk5JT1hwcWM5NlZReDloamx3OHJi?=
 =?utf-8?B?Zy93U1VRUllEYU92QjczSkRUY1IyaHRPYkdrMXROKy9VM2YyazZRSlltZHNh?=
 =?utf-8?B?a0JnY1F1VW5EUjlFOGIxb2EvN2tIQ1VyanFvWUpaY3FlK1hoUWtUaEI0Rmpm?=
 =?utf-8?B?T1FiZmpEdDdFZVFPN1pMeDNFeDFVVjJZZXlhQ1pIVVI4UWpUeDBMcURlNHRl?=
 =?utf-8?B?emNpRmV5c0JwcXRPOXVkT0EyQk15Y01RU3F2aG9KR0dwTkI5SXJwSzRWNnA0?=
 =?utf-8?B?NzV4d05oZlZWVE1LTThlMGNtbjBWdkpBeXQ4aTJhd01wRVVBWmI2dWk0ZWRp?=
 =?utf-8?B?K3MrSVU0c09aa293YjJZQ1pqbUxpbmVnS2QyZ0Z3WnFFeWJLUWZPV2VxVG5y?=
 =?utf-8?B?Y21mUFdLUmtZTnlsbHc2aG1KSVdjRElIVGk5V21wK29FTmhBeGF4eUJhdWhn?=
 =?utf-8?B?Z1JwNzcwVnUrQVdaRVlvT1FVVHdaa0NndDkzeldmTExiU1ZhSVpLM1NjWmlF?=
 =?utf-8?B?TWdaVGJMRStRUWppbWl5bEpJVkxPU3J1andZNFhGVDhINlBZRFRyRmlHVVor?=
 =?utf-8?B?N0ZSNmg2Wjc1bzNzN0NpT3NVc3pINDRvRTMzdTQyUVJpRXU3aFBhLzFCNUw2?=
 =?utf-8?B?OU41QlhXaFdraDdvVTMvT3EvYTk1RTBNMVk1ZDdoN3I3S0s0blpGTFFzdjJs?=
 =?utf-8?B?U3U4UFN4eUovM082cnQySi9ZV2lYRVFyNlJrVHRhQmdoRldiZG15dy9vaU1x?=
 =?utf-8?B?S1F6MFYrYkRaRityc3hOWGIvbHFXL2Z2akk0YTNMWWY5VmdVY2VxMnlSMzN0?=
 =?utf-8?B?L0RPSkpoNk1oRzBKZU5rZUx6VDd0cWNLbXplSndlZFBLQVBVWGxuamptaFBu?=
 =?utf-8?B?ZjFKeFV3QnpSQzlKUCt1MmdVdnNTYkM1RHI2NHJ2T3VtallIQmNpc1d4VmMx?=
 =?utf-8?Q?xkAm80ADWo/Nh104p/mbNc8+O?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d35056e-e12b-46f6-889e-08dd8c38b140
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2025 00:55:27.8446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: in4zEwRtd5lHokspYPm2C0Z2WY/d6UufiTDPMyNfiQTTzXHGRn6yg0Me35zTkWTRLum93SZmhCvMdkVkwubrOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4790
X-OriginatorOrg: intel.com

Sorry for the late reply, I was on leave last week.

On Tue, Apr 29, 2025 at 06:46:59AM -0700, Vishal Annapurve wrote:
> On Mon, Apr 28, 2025 at 5:52 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > So, we plan to remove folio_ref_add()/folio_put_refs() in future, only invoking
> > folio_ref_add() in the event of a removal failure.
> 
> In my opinion, the above scheme can be deployed with this series
> itself. guest_memfd will not take away memory from TDX VMs without an
I initially intended to add a separate patch at the end of this series to
implement invoking folio_ref_add() only upon a removal failure. However, I
decided against it since it's not a must before guest_memfd supports in-place
conversion.

We can include it in the next version If you think it's better.

> invalidation. folio_ref_add() will not work for memory not backed by
> page structs, but that problem can be solved in future possibly by
With current TDX code, all memory must be backed by a page struct.
Both tdh_mem_page_add() and tdh_mem_page_aug() require a "struct page *" rather
than a pfn.

> notifying guest_memfd of certain ranges being in use even after
> invalidation completes.
A curious question:
To support memory not backed by page structs in future, is there any counterpart
to the page struct to hold ref count and map count?


