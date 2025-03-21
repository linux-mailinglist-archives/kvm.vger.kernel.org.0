Return-Path: <kvm+bounces-41651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E1E3A6B99E
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 12:13:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB3141887371
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 11:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D183522171B;
	Fri, 21 Mar 2025 11:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HFDEOiT1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A521F4199
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 11:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742555587; cv=fail; b=SXxvY39y4Wn70c7PaohBS5PFlE5Md6XSGlKOxNYc/RE8M2D009vJEtINu9JZS56wnylNILkX5US/XLK/TuVAMF2N+MdzbjPc+iITimlUzPr+nHaLDajIiOwj/6ytP68jw8foAfXYsMrvY1p1aEGFcMxdPs7hanaF7tZu/U6jgkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742555587; c=relaxed/simple;
	bh=wSlktVRffjofRqtMRfYcXPY9TwBijSWvCxOa+Es4+No=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=n79ZDw6o99tiTbzVGCrkbAqVK6HFKEIDE7Q5GZ9hN3IJoFsdJN89xc7Z7TuriL4QMJJTXqfEipkUh0ORGAra3EF3IAxnkRSny6hQCXuS5ScZiizDGkTrSkAU1jaLgD0SsqCJGOQ2B+Jjel9Q/B/UU9c9s3/Q7HhR8NIIBOzarVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HFDEOiT1; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742555585; x=1774091585;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=wSlktVRffjofRqtMRfYcXPY9TwBijSWvCxOa+Es4+No=;
  b=HFDEOiT1taJ1sgCwR8L+KWErg+EGDQtuofaTpYOAVFqD03mMc3nYpRUK
   t1JfZpnyQTZdx3i5AF5yMSMBToNlCqG+vQ/gvdC7l2Xx1gOV4ZPD2A1lf
   08P6gZNjbdppfSY/bTqaaOTd1OG5makw/3oq11L8ell3JuoWc7YrxEzCr
   QWJLrNVzRMNgopk0cwdXHR8s2jkgW/PxsYjG5RhNpEkzXHK/bvYqAqga/
   GLm5OaQFGdIzUPv33cHyIEY8HPvfcpHv6uLHDfW5b7N9Vyb3RAdsdD2m8
   4RA8a6UXVB1YkMXh/9CchNI7AjZKsMmBmJ4/E8mXnq0+19+ls4fAOgG+V
   g==;
X-CSE-ConnectionGUID: /SKYgKjyRDW9STO6YW95EA==
X-CSE-MsgGUID: zb9pGUQsQYGgwsWwfCLZCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11379"; a="47698820"
X-IronPort-AV: E=Sophos;i="6.14,264,1736841600"; 
   d="scan'208";a="47698820"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 04:13:04 -0700
X-CSE-ConnectionGUID: 96zLxTRZQsavrtYq1Hbyqg==
X-CSE-MsgGUID: orLF81xRR4e6HWaqENMcmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,264,1736841600"; 
   d="scan'208";a="146597798"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Mar 2025 04:13:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 21 Mar 2025 04:13:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 21 Mar 2025 04:13:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 21 Mar 2025 04:13:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bY4uSihheUu2wc93cKSSaJ9XNdbAvL1PNrcn7nrkqzZ9MXznp50rWRXqkhsAMuzS2njvexL4DOAXdiUYFzdX+En2TOOgsFeXxfFGoefFB7E9pcrHgjNBt+G8Z4g7N13LOLH4d7cA7Izah0ceOndllZqRM4lkuj71L+lpOgTUJwoauU7JcWHfdp+ZKXRiA1xbCco3x9Fr2t9P/ZU9915r4f8CWlXb+r9U9gkOpx+AHhBA6TLSXvZ3+CV27lhpcgTQSEd9zE0jVU7242T9So48RGBwJqzZNdf2/CZt/wPhpup9J4iq5RWxK6D7bXZHrCVsLk77dutnEcJLcSyvgfTuYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=And8tTE3ItxDXoMNHFtxk4vk7xvrKrhZddUGvb2jImI=;
 b=xaZlXc9Mef7EFbc7VEnQEvPrKvBKIFId3MqkiMaby9OELzSgvVq6SsMi7w5p/AzOB3xFzsK9p+vLRgg9cmMqlDHJJHvUZK9rYtkIORUmWMwySqgNLB2g8zc2356QXuFF4fK2eUu9NI5bUM88IrX7Cjo+f88fxsvItsC4LX5GZrfw4W5jsLSD5AV1Qd/lX2mgMzbDQMcmIqaQbyBb9cdGXTIhaBTCXqsXqUpS3LNGuppwc7tHvDOo6wVdj3r/3vsLupiTnwvf0WKOB5NWdc/eKzD6TXrt9kBm0kyhvSQHXNRGmwB1v11PnQPQjiSaDYOxdm5ssEACLc1mDcrqYOW0ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7643.namprd11.prod.outlook.com (2603:10b6:510:27c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Fri, 21 Mar
 2025 11:12:47 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8534.031; Fri, 21 Mar 2025
 11:12:47 +0000
Date: Fri, 21 Mar 2025 19:11:16 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Maxim Levitsky <mlevitsk@redhat.com>, <kvm@vger.kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, James Houghton <jthoughton@google.com>
Subject: Re: Lockdep failure due to 'wierd' per-cpu wakeup_vcpus_on_cpu_lock
 lock
Message-ID: <Z91JVHlG5jjSczhR@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <e61d23ddc87cb45063637e0e5375cc4e09db18cd.camel@redhat.com>
 <Z9ruIETbibTgPvue@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z9ruIETbibTgPvue@google.com>
X-ClientProxiedBy: SI2PR01CA0036.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7643:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fd21b9f-48ff-432b-1e1e-08dd68694fd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?FoxCev2Bk4oENakAzXMC5fmpcspRwxLSlDmGvatUZRV/FWnYk/92HVtNapYc?=
 =?us-ascii?Q?FyvutmOsNCOyy9quiptzzTeNdk2pi7Nc26OmPzz6vjpzrtIngO/03D+gYknf?=
 =?us-ascii?Q?mXtdq76LD3Dkz/Wmk2HS3HoXJ4UM8YXENJJDn7QYgKWag+O1M7tTii8Ewqf7?=
 =?us-ascii?Q?xCBBm87Os8ZTiS5RarQHkJrqAKAfZJxD8t3NXKKR8j4HUZ4S7g6qZy9RH7j9?=
 =?us-ascii?Q?MBnU15R1FoZhBu8qW3XQ0UofzfLz/+QpyTFWHTBZWOMzvpQTAYHxdXDZHonA?=
 =?us-ascii?Q?j5BSwo7tyCtWELMKQU2RgRNVlu0pn12RnPTDrcu9IWqdsEjRnUk0IBXg9bS4?=
 =?us-ascii?Q?ojyi5/F7c+/TJ9JOJqQ8uhG+KkTe25FDU0P7udurPRIVp4o7eBioAWdT54Ic?=
 =?us-ascii?Q?t3fqIDGBt0Fdjgy4A9J38uUTTNFSQFcEq30xImAnC5PzUPtiMl/CxgtuSXJK?=
 =?us-ascii?Q?N6/PEHOjTTvdgmlTB3vK/y3vfFrA4ZBKv0YVcyOFmVYRtCPsI8lUpHjaatAZ?=
 =?us-ascii?Q?qYknutDehwHUWmX1IRVX5Y+G2+dsb5ZBTGprg5ZRXHm53NDdksiSg9ZFLeZX?=
 =?us-ascii?Q?Ob3G3isWChVCr9QTo22iR8Bv7Y0y1dbBT7y/kQBcn3F6pMqJz5Mn0AKPukhu?=
 =?us-ascii?Q?8myp9wQJ8YRzpZup5KhM5PhK5bc72j/gwo3azv5ZYFCWWHDdsNjMZFamFREI?=
 =?us-ascii?Q?5Mb/CWCd0gb5FjnuvnbdtH16jdwlv8BaiTP5aWqDxgcTZuJeJ8643CvamWG+?=
 =?us-ascii?Q?a+Mv5vyFHVZkKcLSrEU3gwbOxKEldCtUfjz9vznNp0DJFTIxAcKGmpRZJqTj?=
 =?us-ascii?Q?vQSwN8i1NKexmSJrvIoBLaRIi+ooJbsQgeQVCBci7XCAFRtUu8TVB9Wq61BR?=
 =?us-ascii?Q?0gI8M5QSOMR3TQf6naXtG6m3O2iB3DICe0ITVTPhOaL6gB4EYOYBSl+Y7ZL0?=
 =?us-ascii?Q?U4f9ctaXA81rUhSj0MGUL9vqHizBNTHIJvSQ/IUkculd/TUUOPP7u8TpiAQR?=
 =?us-ascii?Q?61xnvHbFpqdvASuClOUsZeq6OKn88np/3XY6Q6eoRyzC56PaA4NyfWrRooX5?=
 =?us-ascii?Q?tDE9G6ouk9ZNqFb9bsi46tHC/yKv7cACAIGw7Gj/x4KEXTsuKeXKYW/NQXxv?=
 =?us-ascii?Q?HexL/OFkoghyYyAIxsZVBiPfRjJo6sEwZdzBsQ6s/Qxtd9E5weTnhWQ93TuC?=
 =?us-ascii?Q?k0XqOSNvcgx8zxErGzlmEhaqrKheBiXUdcAzPKBxIcWoVNVoxldbIWVwMz93?=
 =?us-ascii?Q?J5YSGSt7d0B/2IQH6TxpZn4CH2xAjnhOB84oqUzm9hY6mGr1jRsw53ooXZ34?=
 =?us-ascii?Q?MSCn3YY6HZuUZN0FsuZmThCRCrkbQjHA8ViTU6kTme2BhmEa8YNwNh3Umbxb?=
 =?us-ascii?Q?N9WBLtf0+/oCkr5J8DAAMIulBGY9?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ACNisH+PxOuuZzKamycRo8kV7qeG8jAoan6KuyyU0TASy/of0LR/b8pAGZLz?=
 =?us-ascii?Q?acnOuk1l+VCOUV1tX3W5+5GbfeLPPY374ZtwUiiGi0pm9S8QBR2OQ2zwH0Wg?=
 =?us-ascii?Q?zpHZTfOEpgWufZheyZfi8Q88usv4EYXZIVIyTqzcKaSf9Ab15cfUt7N6Kgz6?=
 =?us-ascii?Q?9sc2LnA1C0xGJjtctbFxyKD4u+fl9swFew5AtmXdET3bSZjS+7qhRBfq9G0P?=
 =?us-ascii?Q?m1vVpfMtqAqoVZFOub2eYFnAGtPy99LsRt5Rbr4gDV5Q+U/VvekHH3FB12XK?=
 =?us-ascii?Q?NKBpIrWVrSg27XW7qKrdu2SUphSFmRBCMV3M4/BPbLimB/XjJpdZZz+YVquJ?=
 =?us-ascii?Q?W4NlGWDWtbQl5gtMQuyprD9l5gyOplShXQJmgKB1hx3tUXmfPgxt9UJDuLfL?=
 =?us-ascii?Q?KTgPrUqCYwSM4U+WWXtvbyGK+/p3t+bR/7RTDa1g5xHau2vDT5gp9VfvHzee?=
 =?us-ascii?Q?oKGBSJaAU31ZysCM4gYfTzXWkNARpL9G+luhVUD2ggAUBDaxlupUMuKgY+bf?=
 =?us-ascii?Q?fiImtbrV2WQLRHUj4oa2QFNVwU7onVVjMFGNUTJoge7NGD73cRYGY4CWq8p1?=
 =?us-ascii?Q?a1SiTlURED3jlh1zjszd/dyh8VmBkU2N/d9FbmSdOKuq1vdg6kxqeZCY3tfc?=
 =?us-ascii?Q?SDQ2yJXo0obO5i13E22RwIPhXhsC+iJaRO0t/UjiEpoffitAp1PGD5HksWSQ?=
 =?us-ascii?Q?Mmg7ACGhcRKfNkh39wP1bqxgrvxNaH22clmS1zGjGk3I+tQOMbhvlc3n4xjW?=
 =?us-ascii?Q?trpmkIVF39iQghFp+GLXwnl3BnjdbIltAOOPUs1MBh5/FqceSwDcoMZVd4+1?=
 =?us-ascii?Q?5Tgt5kTYKR0vqfZgQSyveqVRPxf7PPkfJZ4OewiQoGwfdxk1iVBtk90sB7da?=
 =?us-ascii?Q?ynndHxZmwWXaitW4Yn2QOu6a+dnENCm8FBIrNoMFWDkER2C0tYzex/OBvYg3?=
 =?us-ascii?Q?e8qm4ELroP28aEEPNtVp00pi8muerQ15EprlYzeHH0MLZXP+nKx+oC/cnEgi?=
 =?us-ascii?Q?BlohDybYmMijl8VVf0HKO3aL3kcRtTvUNra5O0cHK/wY56cACgOMqmaslyq+?=
 =?us-ascii?Q?QTPR0IZ7R4/QGxZFFGL4dF6QUsKVERe7KXll2Osfv9A5XDYwStn4ysivfO93?=
 =?us-ascii?Q?0bUzufHuvzVoiCROOpTEZdKTgNIdyJ53gnU9VO2872xP//BH4V6Uuqg1tJQP?=
 =?us-ascii?Q?lcE7PV91OTxWFhJxqLhSf8lsJtnkAudqt5aOGwGn7xMhVGLho1au94XMeCfh?=
 =?us-ascii?Q?Wjku3J3wbGcsCB86/Iec/FlZy/5ez1xeAweVXGzVXPI9i3STmaYdMx+70DHr?=
 =?us-ascii?Q?CAChCRqslcAuDuDGh5d1x34K4RITUXwe2Os3DcNY40H7aCmxxbkqlRjdf6d2?=
 =?us-ascii?Q?e8rdhKD9LjX/h9gKTMMTsaXwwjoL7W0okUoWsN4uzgLhArxzPDbzio/KM0QT?=
 =?us-ascii?Q?x/s/3EpM8IdX1wiAheLAzR1vT2AG+zHhwPlQ8iNHx1qqyA7Pobf+oErfovS1?=
 =?us-ascii?Q?osrrwpVzdJoBJvOlzFXiiBR58Ll0ODXR/wNG7PtP0mWr6uUc0Ufleiw9cAXu?=
 =?us-ascii?Q?QnqNnwpPP6k7zF/LrBpYMoK2Uy9/YwdvzgvqgTya?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd21b9f-48ff-432b-1e1e-08dd68694fd9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 11:12:47.8386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LuyyNFWhruhRchbCIQcEzIB+zS9Pmz6PByKyAiHBKDpXB7BZKimgfdWU72DFrVy6MIW0NPsh5x9YZ7onG4RGBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7643
X-OriginatorOrg: intel.com

On Wed, Mar 19, 2025 at 09:17:36AM -0700, Sean Christopherson wrote:
> +James and Yan
> 
> On Tue, Mar 18, 2025, Maxim Levitsky wrote:
> > Hi!
> > 
> > I recently came up with an interesting failure in the CI pipeline.
> > 
> > 
> > [  592.704446] WARNING: possible circular locking dependency detected 
> > [  592.710625] 6.12.0-36.el10.x86_64+debug #1 Not tainted 
> > [  592.715764] ------------------------------------------------------ 
> > [  592.721946] swapper/19/0 is trying to acquire lock: 
> > [  592.726823] ff110001b0e64ec0 (&p->pi_lock)\{-.-.}-\{2:2}, at: try_to_wake_up+0xa7/0x15c0 
> > [  592.734761]  
> > [  592.734761] but task is already holding lock: 
> > [  592.740596] ff1100079ec0c058 (&per_cpu(wakeup_vcpus_on_cpu_lock, cpu))\{-...}-\{2:2}, at: pi_wakeup_handler+0x60/0x130 [kvm_intel] 
> > [  592.752185]  
> > [  592.752185] which lock already depends on the new lock. 
> 
> ...
> 
> > As far as I see, there is no race, but lockdep doesn't understand this.
> 
> Yep :-(
> 
> This splat fires every time (literally) I run through my battery of tests on
> systems with IPI virtualization, it's basically an old friend at this point.
> 
> > It thinks that:
> > 
> > 1. pi_enable_wakeup_handler is called from schedule() which holds rq->lock, and it itself takes wakeup_vcpus_on_cpu_lock lock
> > 
> > 2. pi_wakeup_handler takes wakeup_vcpus_on_cpu_lock and then calls try_to_wake_up which can eventually take rq->lock
> > (at the start of the function there is a list of cases when it takes it)
> > 
> > I don't know lockdep well yet, but maybe a lockdep annotation will help, 
> > if we can tell it that there are multiple 'wakeup_vcpus_on_cpu_lock' locks.
> 
> Yan posted a patch to fudge around the issue[*], I strongly objected (and still
> object) to making a functional and confusing code change to fudge around a lockdep
> false positive.
Not a functional code change? Just splitting a big lock into smaller two to
protect a single resource. :)
Kind of with threads A, B, C,
A, B: take lock 1,
A, C: take lock 2,
B, C: don't need a lock since they are mutually exclusive.

> James has also looked at the issue, and wasn't able to find a way to cleanly tell
> lockdep about the situation.
> 
> Looking at this (yet) again, what if we temporarily tell lockdep that
> wakeup_vcpus_on_cpu_lock isn't held when calling kvm_vcpu_wake_up()?  Gross, but
> more surgical than disabling lockdep entirely on the lock.  This appears to squash
> the warning without any unwanted side effects.

This can fix the lockdep warning in my side as well.

> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index ec08fa3caf43..5984ad6f6f21 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -224,9 +224,17 @@ void pi_wakeup_handler(void)
>  
>         raw_spin_lock(spinlock);
>         list_for_each_entry(vmx, wakeup_list, pi_wakeup_list) {
> -
> +               /*
> +                * Temporarily lie to lockdep to avoid false positives due to
> +                * lockdep not understanding that deadlock is impossible.  This
> +                * is called only in IRQ context, and the problematic locks
> +                * taken in the kvm_vcpu_wake_up() call chain are only acquired
> +                * with IRQs disabled.
> +                */
> +               spin_release(&spinlock->dep_map, _RET_IP_);
>                 if (pi_test_on(&vmx->pi_desc))
>                         kvm_vcpu_wake_up(&vmx->vcpu);
> +               spin_acquire(&spinlock->dep_map, 0, 0, _RET_IP_);
>         }
>         raw_spin_unlock(spinlock);
>  }
> 
> [*] https://lore.kernel.org/all/20230313111022.13793-1-yan.y.zhao@intel.com

