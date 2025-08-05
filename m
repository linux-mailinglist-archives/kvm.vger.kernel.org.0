Return-Path: <kvm+bounces-53957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67D0CB1AD01
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 06:03:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F39D17F9EA
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 04:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8848B1EEA5D;
	Tue,  5 Aug 2025 04:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PylygSIS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0464191;
	Tue,  5 Aug 2025 04:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754366622; cv=fail; b=QmwCNo9I/DOY4fPKoJHVPCvJuw+erGcg8GxOl/0hcTs71GBKawsSUHEZavM6vmSkgBEPVkrKffi/0DIOuZCB15rTCSMK+s+NOcOw7evtSz1EGMIyo7AJxNCqC63NfnZ7QOcPQSyNiLVi1o92KpDN+lQyBw+zUKsj4qIWIzYPSPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754366622; c=relaxed/simple;
	bh=mPqGfz+2i503U5EfImEJB0uLNKik3KmARZ7CpgCbQYk=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=I+S/ix8OBFDK+LYcqCiS1ytLS/L9a5/iJHTgURqAx4hbTQXQVrHRG8+NFJuxkEFcmOWc6N1f+caY5MshcEjyHKE1UsqOjAg5Q/J76KVaLKIJArlBT4grM3kU2ArmSrq0kxtLU7GavWBh0HYV57kNICf4ZjbKyj9SsU36fF5xhbc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PylygSIS; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754366621; x=1785902621;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=mPqGfz+2i503U5EfImEJB0uLNKik3KmARZ7CpgCbQYk=;
  b=PylygSISe/mKPkPeG2SsOLEgaSgbemc58NOhA5ua6GkClV/lPTbIJx5B
   scraw/8DDWx9FYxETLxy25TpfJ9Ly8rnjAkGLHSQFBoizO2fyyBvi9TN6
   YNY1e4fa4Oi1N8gGDrqTdMfVpMkzePDkqUxSlM8yGvCQIS1U7rTBH0RTQ
   BeWvjDwK6Mh+oahoidlQRLb3A9yt8+8raAMLX/BIXarq4f8/5V0hGkyYF
   mBBBCOQbdWN0LqmFMYOAGXvEt5ypAnlhqd6Dhb2H/giv/6c1zSaY6TsbA
   i99Vu9hcg74CkKSiYj5HGizeyAesY+2735mj3mch7ezw/gb07L8Xn7SqD
   g==;
X-CSE-ConnectionGUID: 8+lU8wzJTA2Sxq3AxdK4aQ==
X-CSE-MsgGUID: tH6b0nToTiKq9VO0yr/tsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11512"; a="56722880"
X-IronPort-AV: E=Sophos;i="6.17,265,1747724400"; 
   d="scan'208";a="56722880"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 21:03:40 -0700
X-CSE-ConnectionGUID: dSBvOSquR4aEKLfRpbO3Pw==
X-CSE-MsgGUID: fIcpzsAmTfaqhJGSrYJJug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,265,1747724400"; 
   d="scan'208";a="164651363"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 21:03:40 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 4 Aug 2025 21:03:39 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 4 Aug 2025 21:03:39 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.76) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 4 Aug 2025 21:03:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fTzVtIqrf6z12EVT+0B31kDgqjBaaTycF7bf72msZm4ZdkCFvfvXogpR33eEBXNaEF3/+YcN0f56iZIAKU1YZNY28Xs1/ibka+vQGkG4v00A/QWav9MTXK73wSp8ktlW/oJTjHlzbUpT/8PNBtgXdreym7E6B5AUoxdxODRFs3QNiSlGd6H2DzbZorgdeCfZRiLpWVPSzLnMnIVY1Bogd0rtuYohffC1X2Uw8fGG7MvtVqb+q5xCYhDX6hFPtmzrstq5au58LjuhtC9Qqtp4Ai41iYl0VdpgYq1TGwJ7POosl2jpgRkk8OLrlwWG4SKd7fPOx8nNqts77h3337OijQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kcFqhMsD4XkbwoRkFykrsj0fZjqFruyGW+Wqc2Oy+sI=;
 b=LyEZypOaCqeI6aQzeARXtZedEXqixnxJXPC9k6Q3mNxR+1Yb9ik+hRkmtLPSDt6r/d0lAmdsu/GQan1o2EtTRg3tE0DtaMRgWzelbXZfOQUQByJmr176JaeEpWERH7N3bly3IdHMyCK2qA/VbMdQ/M5eGNnXmd5M8NSMw2VRXI5x9qYQ93O3JGvRhTIgskaT9gUR+ACVzyXGeYnYdjm9R59X/GaV5qNPEgt2lMxtfjhbQ+GWUeQ5QbsyaImqG2Elni8KcxKxSQXOS2argFwwpHyy72/qSNTYqaCiCpEdZl+R10escoGrO0y+sutz9N5NFQt88qtfgdd/14Ag8CpB0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA1PR11MB6492.namprd11.prod.outlook.com (2603:10b6:208:3a4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Tue, 5 Aug
 2025 04:02:53 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%2]) with mapi id 15.20.8989.018; Tue, 5 Aug 2025
 04:02:53 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 4 Aug 2025 21:02:51 -0700
To: Sean Christopherson <seanjc@google.com>, <dan.j.williams@intel.com>
CC: Xu Yilun <yilun.xu@linux.intel.com>, Chao Gao <chao.gao@intel.com>,
	<linux-coco@lists.linux.dev>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<pbonzini@redhat.com>, <eddie.dong@intel.com>, <kirill.shutemov@intel.com>,
	<dave.hansen@intel.com>, <kai.huang@intel.com>, <isaku.yamahata@intel.com>,
	<elena.reshetova@intel.com>, <rick.p.edgecombe@intel.com>, Farrah Chen
	<farrah.chen@intel.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
	<linux-kernel@vger.kernel.org>
Message-ID: <6891826bbbe79_cff99100f7@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <aJFUspObVxdqInBo@google.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-8-chao.gao@intel.com>
 <aIhUVyJVQ+rhRB4r@yilunxu-OptiPlex-7050>
 <688bd9a164334_48e5100f1@dwillia2-xfh.jf.intel.com.notmuch>
 <aIwhUb3z9/cgsMwb@yilunxu-OptiPlex-7050>
 <688cdc169163a_32afb100b3@dwillia2-mobl4.notmuch>
 <aJBamtHaXpeu+ZR6@yilunxu-OptiPlex-7050>
 <68914d8f61c20_55f0910074@dwillia2-xfh.jf.intel.com.notmuch>
 <aJFUspObVxdqInBo@google.com>
Subject: Re: [RFC PATCH 07/20] x86/virt/tdx: Expose SEAMLDR information via
 sysfs
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0124.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::9) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA1PR11MB6492:EE_
X-MS-Office365-Filtering-Correlation-Id: 2563fe01-eacf-4bf0-0672-08ddd3d4f3cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V2JhQkp1eHlNcmVwRW5iNG54U2NEdEo1RXd5QzkxenlnYkhjcmdFQ2JUMmlC?=
 =?utf-8?B?bVh0Z21NeEVDeG5NQnVEa1huNGREZkVQeTVhWFowSkJJc3ZOdDF6Ti9TTWh4?=
 =?utf-8?B?V0w3QWtIT2wyVTNUeTNLVU44dzdFNDhRWHFReXNXaHdSWDdKRVV5Mm4zSmVr?=
 =?utf-8?B?a0c4TlJTT0pxZHpOZG1xREc0eldhTEpqVDlleStIUEpiYzVIRXc5T0xBMDE0?=
 =?utf-8?B?Q2Evd21RTlVUdFFoVFFBeDRCK0ZsQ084ZUY0bXBYZEpITDNFVjY3ZEQ1TmhI?=
 =?utf-8?B?UnZ5L3hONnZiR3ZBUHUzM1luaHA3KzQ2Y3RpRzFPNTk1ZTdGVWtTT05RNXg2?=
 =?utf-8?B?ZW1VTXJvdnZiOGVjK0dya3dnOU1MNjdMeXo4TU9nWitZa1k4YnZISmU2MTBt?=
 =?utf-8?B?N2dKSzZRSUpESnQ5aWg1OUJ3MjR0MU9pOE13Rk1jV2NRMFhrdXR1OUlHd08z?=
 =?utf-8?B?ek5IN0JLR1Q3U0E3ZkliVGxxbHpXQk9CV21XaDgwZWZ5VkR5ZTFzemYrOHRQ?=
 =?utf-8?B?alFRQTlVOGlpVmdJOVk2RExXZHE2cC9NcHREcjBqK3ZkWFQyNmg2ajd0RzlP?=
 =?utf-8?B?UXVublc1NVMxRWRONnQxVHBaZlY1MFczanI2RHZ0UDBzekE5M0NYeHJ3RUVS?=
 =?utf-8?B?VnlEbkdlWTNVdVdMdzc2R2VTZzE2Tk94aEd5VTVYbXVDMFJrK2FqRzFzVlQ2?=
 =?utf-8?B?cmlIN2pCSkxyUW1jNnBNQUtJN1IvRnhuUVNpTUdlLysyK1hKLzdaa0h5dUtV?=
 =?utf-8?B?RGhweWgzall0T3NmZGU3Z2lvdDhXWnVvbEtzanA2bld5L1BuK3I2T3FSZkRs?=
 =?utf-8?B?RldiOFBXTUVvbTkxYUlpWXFPdVhUVmFaVC95eEIrLzhXa2RUMHZFVlpEN3ZV?=
 =?utf-8?B?YTBCQ2xBN2dSTUpUMWVYWnczWE0xZHVXYlkvOFJGb3UxM1V4SGRuMWJYaTVN?=
 =?utf-8?B?RGJ0MHZMRUhHdVpZdXFNeWxNQ1kxR2FZYk5YKytGRTZUMi9WQWZnaGhla24z?=
 =?utf-8?B?TzJvWlA0TzJMdXYxRnphWG00M0xveC9GWHNrRjZ1N215cGl1WlZ4cVRyQjJ5?=
 =?utf-8?B?MzlhNGhTOVRLN3ZrOFpaZ2VlM2E0dmVzeStibkxzREl5WlNxek1uYnZQYWRW?=
 =?utf-8?B?QlFJS09mTlBDM1ptOVBDaFFISTVFajUvY1R0cG9DQ1dKb3FmOXhNclM0VTFZ?=
 =?utf-8?B?SmZZQXdtNENqNjgwdWwvNXN0UXBDcmhBb09WNWE5ZmVZcGhxajdkK0JhbE5D?=
 =?utf-8?B?SjJOL2phbUdEanFOdzdQSXJLRHI5VVhKTXBmY09wb2pTSDhjOHk1dHF3RTVN?=
 =?utf-8?B?aW5CeFhvMnJvSGc0YzRwTml6b2FmRmhjWlVXazUvVnYwTGhmd1loUVNITEcz?=
 =?utf-8?B?ajlOTG45cWkyQjk1ajFwOHhmMENYOXUwZU9pZSszUG9wdGF1TjNldGY5WVFk?=
 =?utf-8?B?U0dCY1A2YUVKaFp4YWt5Szhsc3JVUmtGOTI4Ulhkb2REanoyaCs4aHFiT0Vj?=
 =?utf-8?B?b3dOQ0lYSm4vZ3E1YlBOSnJLbDUrZE5yaTdGRm5iN1V5NnMzanE3NlpabXhz?=
 =?utf-8?B?RGgveDdDODZlam8zUGpld3Y3SGtwdEp1aldSaFVJK2JiY1QwODAzM2dlaTVB?=
 =?utf-8?B?aFREbCsybUtCVVZmYTVRMHNvamZvMFJIR0FqQzdIWEpiMmtaaTNxcVJUaWxU?=
 =?utf-8?B?T1A3SU9PaVdyMG9jWllBTEtHcForUk51bmhHK3lVUEJqU1k4MjdCNTZ5cHl4?=
 =?utf-8?B?MmlEa2VjM2s0QUpKQ3MyaHdrUnlhR0Mxa21lSFcwMlE4V2E2SjJnS3hXOVRr?=
 =?utf-8?B?dnMxL0U5QzhVdElySkxwenZsVlVVcjhnTFZSU2Y2S053eGJIRDNUbUdrWmRi?=
 =?utf-8?B?QWRIenp4WGl1Mmlaci9XT2ViLzJRbk1TTnYrWktFOFlVSjA3Y3c3cisxb1Bx?=
 =?utf-8?Q?+HtpsYGr/io=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3ZXd3hBanRId1JNQ0xYdWlsV0dLd3U0dlBUQkk1WXZQSUxYV3RBTGNBbVRD?=
 =?utf-8?B?aDlLV0p6cVNIU3FmdDNFSXVBeExLSjRyT2x6bmlRV293MWQrYUhXVlVVVFhH?=
 =?utf-8?B?ZnFJMkV3M0RLQlo4NEEvY0w5c0ZWaExkZDFNVERvUDJxK2FrdEtlV2FyY25F?=
 =?utf-8?B?RUhrR0NabUZTS3FyeENTZnEwYzFZL1I2UDNBb1dGMFZGQys3Q0FYZDkwbGR3?=
 =?utf-8?B?cmVnOVBGMEZ2b3VvbGNabjlSL2M0MnJEbWgvUEYyY0JSanZaSWFuNStYVXdm?=
 =?utf-8?B?OGtEeUlQbUw0cHUxbjNaa2pxYlNaZmJacE5ISmcvYWpkVkRzK1pyMitaYTBM?=
 =?utf-8?B?R004TFRrWUtDM1pjSC84UWJCdE9SRFQ2R08zbDVJaEh0S0dVTmJ2ZEo4ZmQx?=
 =?utf-8?B?dTVQamxRNXg5R21BOGttWVBYazZ4Z2l1Y29iTENKK1VoNG0wQ0V1RmVTSVV5?=
 =?utf-8?B?L2c4ZkxUZUhQM2RPaU9RKzNJWW9tMkJYTnN4SnVvbmNaTXZFeWpXMzlIMFJU?=
 =?utf-8?B?a2tYUjN3T256NC9HbXllTERNK0EwWmFaL2VqcGJYT2lsdFplYzF3d2hLMUpj?=
 =?utf-8?B?dkc0a2M0VVNOM2ZjekJpK0owSFNYYTBiT3k2VEttRjc4VUhiVTl2NTY3SFMr?=
 =?utf-8?B?b25yM2xWdGgyMC9BS1ZaVEF1SHVHTE1sdmlucGlGNlhJUGo3K3NlVWh3ZkJ4?=
 =?utf-8?B?czRLdGN1dFRscllzancxWXRMU1hST2tseS9Gd1Z1VDdtRzFMeDdrc29TK1k4?=
 =?utf-8?B?NkEwbEJGZlJPeWJNVWt4Qk9ybzZ5VCtEdmVscGVSME02TXBjbm94N3RIelpk?=
 =?utf-8?B?NXZEWXZXODJmQmhBYnpQeEsxenEwV3RGNXFFbENmaVZOMXNLTFZ4dzh0aEhy?=
 =?utf-8?B?MlRXU3NVdzRGQzdwc2ZScWhiRGZSQUtwUmpnbkZRU0VUZTBsSWVOTU8raVMx?=
 =?utf-8?B?bW95NWtaSFRkNVEzenZxMklJVDY3U25JZCtydmdNNSs5WnJEZnk3TkRWQWxp?=
 =?utf-8?B?YVBHZ1FRZ0VFRWc5Z0FDcWVqQkVuNlVWbHFQWWVJSnVuNkZKS01pQ1ZaWDk5?=
 =?utf-8?B?RzQ4ZWMweDRFQVozTUg5M1hEQXkrYlFiUFhVL3R0cDBHaXZlc0ZsQ0dmcTdK?=
 =?utf-8?B?YmVXRXpJZURKckY0VG1tcEU1SS9kVTQrcGpWWVdjZ1Q5eHZwV1g1eUU2UjhR?=
 =?utf-8?B?RmF1TFhib2VrMk1nWi80dDg2OXdlRi9KTVpIWXYxZHZxcU0xV1VnclJsc25P?=
 =?utf-8?B?OEdhRnlYcnltTVh1NHFjVW9HeCs4djBjWEZwS0dJMXJXaW1iekViZHlEdTc1?=
 =?utf-8?B?ZThNM1hDS0picWlTK1hmK2cxcFYzUm9TZGliNjNlNTFBZ2NZT1VYaGRqSDMy?=
 =?utf-8?B?anAzSXRtZ21TS0VkK2JSb0twRkNuZGYrVDlyRWNSVmpsRjRYSnhxNkFCUk5p?=
 =?utf-8?B?MGlBbFZ3QTFxaG15elphNy9WQStNQ0paVEJERThTRGZvSmI1R2JwZlU4MDM1?=
 =?utf-8?B?Rk80REUzd2I2L1FsdWRxTUlQZHZCWEwxc0dzeENXeDMyR3R2dVY4ODV2VCs5?=
 =?utf-8?B?UXBEaHNzQVBHQnBzclYzMFd4c2dnZEREeERiOWsyREhVUzJpNG1kUzNPbDZm?=
 =?utf-8?B?UVhsek5yUXpJbEd4SmlTL2lRd3NYcVlPWXZSUlBqUXU3UXFyK0oybFNlNC9k?=
 =?utf-8?B?OGNTQitWV3JLelZqeEJCbytJM1BnUDh2MXZIbndQVlIzTmg0YkN1ZWZFMW1s?=
 =?utf-8?B?ZENkWDNTSzcwcXNSSEZpQml4M3cyZE50MWFyc3lheUk3YWZ6T3MwVUpXUjNE?=
 =?utf-8?B?RTh1elY4TXlKcXBVUExiTzgyMGIxTkxzdFNZL0loMEVqdUFUWEFCZStCdVFr?=
 =?utf-8?B?LysvYS9WMnJTWWRFVnZteTd1Y1J0VklQeTFvMUEvOTBjWWloT1E2VWJNbkFH?=
 =?utf-8?B?NU94WG9zYytMNU1FejJrY1ltaUgyVVZjd3J3SGZMeXlDMkljNmFBUmJFWjZ3?=
 =?utf-8?B?RFdhY2xQVzRYUkhQbHdnRUprVWVlNWMrSlRQTWhMUGtIdldWQjlwL2NEZ1c1?=
 =?utf-8?B?TGFiV0JSM1dLWWlmZzZrUzVpSDc3YmR2SThxc3dSNEx6WTFkZThTRW5iQkJl?=
 =?utf-8?B?T2ZQUGRrQzltT29DeFJuZGQzaGRpQUFDbm5SV2tvQlJ0aVBBbFFWcHVJMEd1?=
 =?utf-8?B?a2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2563fe01-eacf-4bf0-0672-08ddd3d4f3cf
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 04:02:53.5332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9EIC1CUhsApfD+V6S+zGUSNm0+dVbZrdXJ3AaqcixV+dcOzJVlz4lV2TfhjHiLER+DHggHKFGlC7bn87EZIGom2cc/rFMuFa6AvxtQK69r8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6492
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> On Mon, Aug 04, 2025, dan.j.williams@intel.com wrote:
> > Xu Yilun wrote:
> > > So my idea is to remove tdx_tsm device (thus disables tdx_tsm driver) on
> > > vmxoff.
> > > 
> > >   KVM                TDX core            TDX TSM driver
> > >   -----------------------------------------------------
> > >   tdx_disable()
> > >                      tdx_tsm dev del
> > >                                          driver.remove()
> > >   vmxoff()
> > > 
> > > An alternative is to move vmxon/off management out of KVM, that requires
> > > a lot of complex work IMHO, Chao & I both prefer not to touch it.
> 
> Eh, it's complex, but not _that_ complex.
> 
> > It is fine to require that vmxon/off management remain within KVM, and
> > tie the lifetime of the device to the lifetime of the kvm_intel module*.
> 
> Nah, let's do this right.  Speaking from experience; horrible, make-your-eyes-bleed
> experience; playing games with kvm-intel.ko to try to get and keep CPUs post-VMXON
> will end in tears.
> 
> And it's not just TDX-feature-of-the-day that needs VMXON to be handled outside
> of KVM, I'd also like to do so to allow out-of-tree hypervisors to do the "right
> thing"[*].  Not because I care deeply about out-of-tree hypervisors, but because
> the lack of proper infrastructure for utilizing virtualization hardware irks me.
> 
> The basic gist is to extract system-wide resources out of KVM and into a separate
> module, so that e.g. tdx_tsm or whatever can take a dependency on _that_ module
> and elevate refcounts as needed.  All things considered, there aren't so many
> system-wide resources that it's an insurmountable task.
>
> I can provide some rough patches to kickstart things.  It'll probably take me a
> few weeks to extract them from an old internal branch, and I can't promise they'll
> compile.  But they should be good enough to serve as an RFC.
> 
> https://lore.kernel.org/all/ZwQjUSOle6sWARsr@google.com

Sounds reasonable to me.

Not clear on how it impacts tdx_tsm implementation. The lifetime of this
tdx_tsm device can still be bound by tdx_enable() / tdx_cleanup(). The
refactor removes the need for the autoprobe hack below. It may also
preclude async vmxoff cases by pinning? Or does pinning still not solve
the reasons for bouncing vmx on suspend/shutdown?

> > * It would be unfortunate if userspace needed to manually probe for TDX
> >   Connect when KVM is not built-in. We might add a simple module that
> >   requests kvm_intel in that case:
> 
> Oh hell no :-)
> 
> We have internal code that "requests" vendor module, and it might just be my least
> favorite thing.  Juggling the locks and module lifetimes is just /shudder.

Oh, indeed, if there were locks and lifetime entanglements with
kvm_intel involved then it would indeed be a mess. Effectively this was
just looking for somewhere to drop a MODULE_SOFTDEP() since there is no
good way to autoload "TEE I/O" for TDX.

However, that indeed gets dropped / simpler if all of TDX's system-wide
bits can just autoprobe and light up features without needing to load
all of kvm.

