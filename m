Return-Path: <kvm+bounces-43069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A69EA83B4D
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 09:35:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5043346077E
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 07:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE286202C43;
	Thu, 10 Apr 2025 07:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U2MSqPu4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D001DE8A2;
	Thu, 10 Apr 2025 07:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744270469; cv=fail; b=kvEcwqK4L8Kvdja6Sj+f/1uFGlqmXg18YgBLcUNdFh1cQVRHY02bJH8oKKFYEVNFBk4eXvQU7rROXZTLrhBN22uISIpWimgevN0FN9hf1Mclf2cbHbfr0LO3P/uxi4XEb5dHA2u9Ii5fj8k/S8inmrlo9ymrhbM5li7mt8MUxqM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744270469; c=relaxed/simple;
	bh=l1NUOHZogXe4MItbhZidza+VAOz9zWOtAYdynbICc+U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=euJ65rvg3REhBKKp2rFmGzsLzts19nPBDaMyXBnXCmPltFyjoMPiT63CeFZSjvwSqgFoViw+FiLtLBX5EOILJSoegWAQfPkrB9WN1NF51+bsgePDr204Xeky4BBAHxyXjWJpe8Tw4d1JIE2FvwBD9EMhi5O1ZgLA7Y09yTLySms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U2MSqPu4; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744270468; x=1775806468;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l1NUOHZogXe4MItbhZidza+VAOz9zWOtAYdynbICc+U=;
  b=U2MSqPu4ftijdTIIXYsCJXWS3AgENGOXUkY4yqakBHkKFzNAS+yxr+fa
   OKI6u/TRSzF9j/NHA1VgLRrXJ5GeJLd9qWgkOQ0DBQ0+9UV7YL1vC7QGG
   qdqerheHa5ZWb8LA6Dg9w9b23J4uH4Bdi7PUT4r2ATv5wRCNzpi2UxnOD
   Y53GbXXQog89eq5POjMbYR9mGH0Hl32COnG3N65+cj4uev+4qZ7/zD7K4
   Zy9JmDvtEsTQcOLmIjN8UBOBGz/K9YDEj/SSqVmVRIDMHqe1LGqxwU31y
   0h3CHJUEQdrKJWR5S/H9NghmYmguBo2In83B17TsvVmTBrU56pbgpbsJI
   g==;
X-CSE-ConnectionGUID: jtVZ7NS7SIiYV7dkhaidMw==
X-CSE-MsgGUID: Old88fSAT8GKoHMeixHAZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="49615100"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="49615100"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:34:27 -0700
X-CSE-ConnectionGUID: Jnl2A5hoQ+y8bt9zS9yo9w==
X-CSE-MsgGUID: V17DnvAcTzCcuPENtiaDiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="159804978"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:34:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 10 Apr 2025 00:34:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 10 Apr 2025 00:34:26 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 10 Apr 2025 00:34:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ac75UtsxTqW8ajgd+y55tPJoMXbG6pNmx3wze/BYnQdiJRh/sOq+ZEtlOOC1McAjkJefkL187+xxhT62iVs4bWhyHXF15Eiysn2APMX4w19yi7nmQsDnhOGkn0lWLqgemcQlee1GhIAubyZ2XRuPDQuc0xfQYV3wPzqG/ibV2akpyfw12BMaFHTNVnFTZkpD3eL8/Auyxoj+uzTpsND7YaqqUciDWTXs7pibXx9JXR5FeW7lTJAMGYM9UWvPrzTk0OvFAqHTEEbPKNcrnr/G/aZgGTOS5v0dGvrrrUf1u20ZB4wEr7fPTB0GKgFzIJMXmdmFJMZ5VutP4M/epa/HHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l1NUOHZogXe4MItbhZidza+VAOz9zWOtAYdynbICc+U=;
 b=aBwFLCI5XArKwtIH5osRQZlcEowYPP5kLaAg7l9kTcMUqBfzEqv09dgNXxuaxRGtcMd/rovrFNGjS7Ybr7Px/Dzbr2+sxlB53p7QbOjvYALQhdfd/SsWHLiZ18yYrWk+UEMfMsTSCPntsIZ9WKOKdX2IuspMR4qg3y0ZTCTApuYR0+j0h9zg7bv+ZTKiLp6IGde+3naQ21c37Sd4E2/Pf7c7pRciWH1Afxs3ma521J+/OcK3K8Fqeog3CGIGm7FMFyZPMoTkJRKK6PxAl4uNpa3bxn7FPy3+s1qdsBVXl/f3v2RV3lA0CWU2RxuFvF2tNpX5y2lg7su5xt3Q43tujg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ2PR11MB8585.namprd11.prod.outlook.com (2603:10b6:a03:56b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.33; Thu, 10 Apr
 2025 07:34:05 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8606.033; Thu, 10 Apr 2025
 07:34:05 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Sean Christopherson <seanjc@google.com>, "Michael S. Tsirkin"
	<mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>, David Matlack <dmatlack@google.com>, Like Xu
	<like.xu.linux@gmail.com>, Yong He <alexyonghe@tencent.com>
Subject: RE: [PATCH 5/7] irqbypass: Use paired consumer/producer to disconnect
 during unregister
Thread-Topic: [PATCH 5/7] irqbypass: Use paired consumer/producer to
 disconnect during unregister
Thread-Index: AQHbpabyrMTjULSzmke5qbnGFyr847OcimVg
Date: Thu, 10 Apr 2025 07:34:05 +0000
Message-ID: <BN9PR11MB5276BF6CF871031E42F393638CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250404211449.1443336-1-seanjc@google.com>
 <20250404211449.1443336-6-seanjc@google.com>
In-Reply-To: <20250404211449.1443336-6-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ2PR11MB8585:EE_
x-ms-office365-filtering-correlation-id: b6dde71f-30bc-48f2-e3ba-08dd78021288
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?K3hJUzZMU0FtM3V0aU1SOUhiTHJpaHkxblorWlVPOE05S1diY1R4YUEwalpL?=
 =?utf-8?B?TUpqQnBLU1pHZ001dnhwNllqYTNQejVLb2N5alpBZlU0NXJGUVZsbDFEVzBY?=
 =?utf-8?B?YnBEK0xmYkJzUlZPSHpselBHK1pROTdwSitiT0haNWsvdTc5VDVpRjNWSGQ4?=
 =?utf-8?B?Z083eHRjSlRsUzFSbkZCaWRzeTRlWlJ5dEFsRnJkTHlsUGJOT0s2QVIrNUN1?=
 =?utf-8?B?NzNNYmJtcnRQSEpFYytlYWZ0UGxuYURtUXFyTVF3cDBxb292WVJZQlNteDBN?=
 =?utf-8?B?aFdqRVREZkFCeEx0RHJjVjBaZUk5SDA5Z1ZiMDg3SFgyaEhhZklmeHFjWTAx?=
 =?utf-8?B?d2NZT3ZndWg0TmNYL2tSQ2tRZEIwMTgwZ095QzloVWxwTmFSVlhQU3dQd1d2?=
 =?utf-8?B?Q3ByYUUzYnFGTXovTzRxbnFEbXlJdS9QWkljamprMUFtRnFTSmtUaUNVM1lP?=
 =?utf-8?B?WXd2TlFpK3VlQ3U4aHMxU3JLUjhDa2dMdGVWVk1zQW5jSnRzV2JiUkpLb3Nj?=
 =?utf-8?B?MXJ2d0czSG5BVCtTNmtHb1pkdERxTEdxNDdBOG9jd2RuM095eGpOTVQxQWpr?=
 =?utf-8?B?NGNHcnlZYmF3ZTMvQmZkd1dxUmhTa2d0RW9Tanh6M2JmSitTZ0ZiV3hYUnAr?=
 =?utf-8?B?WmJkcndpZVZoM3NuVjIySlc2RkF1TEdCdnkxMU5SbVBIKy93TFFSdWJFcitn?=
 =?utf-8?B?bFBnSGtWMTArSzdpYWpZSU4yNFRhUlBEVjRZbk5UbFF4MUVWbHNUYjAwTk5u?=
 =?utf-8?B?M2FJMjRBQ2w1a0ZRUzNxRjVOenlTYXNwY3J3SC9nNG4rMnJNMm4wUVdCejMz?=
 =?utf-8?B?bzFKWjErdStvS3IxMTU3OThFU25wTTYvYnlnWW5NVVBVQU1GazBHY0FZdHNy?=
 =?utf-8?B?VnZFMWdnbW5jMGN2RjJmNHR0ME1MN1o5SzB2aDJBOHVrTEpPTDRJTkNkbmRv?=
 =?utf-8?B?ZjhWWHFRb1NmT1MyTGRROWhaN1dyU0I5L2VrcjlHK3BBWEY2M1FiSm1tblRQ?=
 =?utf-8?B?ZU9iNExkWWhkSkY3QmZEMUM3aVJjTnNiV21Tb3dqOW5Kc3pxQnVjbmRtK3k3?=
 =?utf-8?B?MDJ1WitTNWJhelhkbnh2dGRJVmVsMTVBWUcxT1lLKzZHQjEwbUVoWVNsOHRq?=
 =?utf-8?B?Z0VsYlBBeVU1bVR5Ri83dWt4VzdveEoraXJPVyt0RHVPcE9DK0lVZkVTVGh2?=
 =?utf-8?B?WlBLQllrbWRMdkYvcE9nakZLYlVRYjBhQnJaZlBhU2F0UXJuUEN2aEFiakZD?=
 =?utf-8?B?dWc4LzFrV0pzQ0tsL1I5MERQSit3aUpqcWhlM2FCZU9ncXpwbkVxeW0xNERP?=
 =?utf-8?B?UTROZ21NOWU5SEFjOGt4KzVvSFVwbjlEckRrbVFaOXAxNHJBSEhPakJ6MmFU?=
 =?utf-8?B?V3RwQWdod3FZL04zRXJmWWgrMyswV3h6aHZ5R1BZdkNyOEplbW1Kd0JCSU5V?=
 =?utf-8?B?aU4xRk0xU0RsQ05IbW5KSFZxVVhGQ2hrNi9hNHNHZ2hOVzhlNzVYQldQS1ZF?=
 =?utf-8?B?R3V0R3lsR1VZY28yM3MwUkU2Sld4MjMvS2xwQ2tGTHIvYU81VElKcFN4K3Nj?=
 =?utf-8?B?YTU2cnc3QXZ0aHZnN3pLWUU4ZHlLZ0ZzdTVyOVRrMjdobmRYQ2w4OC9leU13?=
 =?utf-8?B?NnFEY3BxZFJncVFIcTF3eGd6Nzc2UkFBQllzU0p6d3I4aUpOVlp5aWwrQjNI?=
 =?utf-8?B?K0pXUTdsUzlnUjR5TU92VmthNEtiUlFTbjJRemN1RnJlSnh1eFBwY1RGRC9q?=
 =?utf-8?B?TDB0b0pldVR5YmVDMG1mVHRBNkdMMnRzcERtVDhWanYyRVliK2hvSFhaMWJV?=
 =?utf-8?B?ZG01cFhuangvalQ5ejJJNGF6b0xqOWtjd0wreGwydStWWFpmZWVnMzdTdHpI?=
 =?utf-8?B?aCtrTFg2T2ZPQmVqR0ZXdUY5WDlGTHhFNjVpdllPNnZqWmx6dGNWMWFFZFNZ?=
 =?utf-8?Q?t6OCCLnp2mfB51dSeev+WBKPNsOB5KiU?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0JFL0dON0VzUnRSVEh4c25VYjlTQ0l5M1ZQczJtQ0o5aVBqOTIyaklOSndl?=
 =?utf-8?B?MlhhbnVjSWw2RFlDTGM2aStxN3JXNDRpdFJFWlpQTjZzQWJtd2NPNU00NGZz?=
 =?utf-8?B?VVQvdjVmUXhDdWZVMk0rZTNJekp2VVRUL1ZRNDJ4R1BCaXNpSjU2aEpmaER6?=
 =?utf-8?B?UEloa0FzL0hHbkNLc0plSFlabkwvUC9qQ29wMWZ3NDRRU1lTSGd6LzZmKzVT?=
 =?utf-8?B?LzJXdXpkK29jQUE4RFhpYmwrUFdPc0swMisyVkx4SlNLaGF6MmUzN0QyVHZh?=
 =?utf-8?B?OHFNMWxzeVE2TTFWQ3lXVmZJNU1LcmlzSVgwb2FHM2NDOTJHOEFIWnErcHAy?=
 =?utf-8?B?RVlWcm91Z1FSdkRMSWFXTFZ4OGF0VWdaeU0xR2IxSDZCL0QycUVQS29wSklV?=
 =?utf-8?B?SVhvVEJkQ3dBNU5iNlhGWFRReXRYOE14WXBscEZzbFZVbFVyZ1N2RVk4REVI?=
 =?utf-8?B?S2M1S2ExN2t5d2tPQUdQcGVTNHJ1cjNKT3ZsV2xrZmhKcEpyVGdjYnBSV2xN?=
 =?utf-8?B?azdkN3oxTGFWM2dJMVJmWmxyT2JZWjM4YkQzTDhKNkZSZmJlUHo5RUYxSlJo?=
 =?utf-8?B?TFpOVDZLNTUrcVppRTQycytoa25WaU5SamhTMnR4Mll1Z2FtKzNMcjZHcHZN?=
 =?utf-8?B?RFd6TU1FOE9GZjE2MnNJQ29aZndPV052dmZJSXBqaDN3Wk4vbFhnVnZucFVY?=
 =?utf-8?B?dDZDYVF1R09KbFYxbHo5dUNqTUxLVVQyVG5KdTcxZXNjbUJtWlZDcHlLZVFa?=
 =?utf-8?B?cG9kdFlhWXltK3pna3dmOUt4Z1VFcUc1Ui92ZU1lSHQ0QjBjbHM2R0oxaU5O?=
 =?utf-8?B?RFNJNURrZEtBYlozalMxN29RbVBKSUpiL3VYVEVlUGRsdkl3b2M0KzZ5aVJq?=
 =?utf-8?B?UlVWaGN1dFFmQ0VkUlVsZDFBV0lIQmxMMmh6bEtYbmdncFh0cDZOVVp0RFpv?=
 =?utf-8?B?SWF5M2cwTldNVTA2YmdwSFlibzBISDNURDYyRisyM3V5Qk8wM3VMWHdlRTAv?=
 =?utf-8?B?YWpmVXRSWmlheFV4TUxCUDFSR3NYVHlpRThnWWdhSWJqcUVGZG1xc3dmWWJT?=
 =?utf-8?B?cVdIOTFSWGhRcWwxODhTeDFGaVZTU1IrU0RRRTFTa05uTGo0dmhRYkR2am43?=
 =?utf-8?B?cnJscG1mTzcrQ2VBbG5paGJGdDcwSjJvZzVlb2VTa2Z1V2lpYmZDUm0xa1Uy?=
 =?utf-8?B?NndDd0wrZmRkTUZpM3g1eldabjFMWDJodU9MWVdFYmY4RWM2aXd3YWJyL1NY?=
 =?utf-8?B?YU1Tay93endHaVA0TmliOFQ3TW03Szl1L0htTVBFbXMyT1pXTHlVWjFSTGZU?=
 =?utf-8?B?QWhDWjBYR3YwR3RWS1dDVFBNTUw2ZFY0YlZhQnpLdTVBUXNqNEt4TzJ1Ung3?=
 =?utf-8?B?QkdsMGlyZWh6TUJRK3BocWsvSXoxejVKSmpWTDFxRDlTTGEyTTIzdndIVmJ2?=
 =?utf-8?B?eTlNcWxHd0hlbDhWUnNneUdxL3RCa0NwdHVKa1dDc01LR1dmVmVwRFQ2ZjhY?=
 =?utf-8?B?bU90cFJtVElnVjg5T0FCUE5STEM3d2NVa1BaK0JTVll2TDdsQWplUTVjdDlC?=
 =?utf-8?B?b3MyNjhlbVFRb3orYjFsSDBmeWN2RXhIY2hPYkVzbXhsZ2x5Y3o5T3ZQeWs3?=
 =?utf-8?B?MmhSWU1mQWU2ejJIVFB6S2hwMjVtdjdBYm9BL3FSRCtJcGRBa2VaMTB1ZndR?=
 =?utf-8?B?eGIxNnVxK25MMXBaV2QrQzBScmprRkUxL0dlcVZoblorUGVBbVVaeWlEY1l6?=
 =?utf-8?B?SkRSbUFLK0tSSk9UbmVrS2pVWThlQ0NGVmdFbEsxRDRZdW9TbjRIUUlXVUtt?=
 =?utf-8?B?NjVFVjlEK0Fjbm1OTkN1UnR2TUhsQWhMcFJlMlRSTmJVd1BlSHlqR0I3RlVi?=
 =?utf-8?B?Q3Rnc3lvRnJVb1g0RG14Q1NhQlo5c3BsSkRsc2NmdDNwK2Z0SnBFRTNZRGI2?=
 =?utf-8?B?UmZGdkthYkxqcHNHVE03alJGUTViNE8za1NHR25ldHZDTHRndXBaUjZ0TTNW?=
 =?utf-8?B?UDBJVVFpcGViSElWRGdId3dRNXNaNFpsQ0Fpb2lvOVI2M21xeHlvaTlLaHo1?=
 =?utf-8?B?djgva2hpUnlTVzNDd2s2eVVyaUJ1QmtFTlNrdFdlU1AvcTYwN0tLTm4rZlFq?=
 =?utf-8?Q?4qdvwi8Evugh55QVJ08rvv4Tf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6dde71f-30bc-48f2-e3ba-08dd78021288
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2025 07:34:05.2177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kdSRAo7C7FOcBKXw32FDkKevaA6MrIaFL8hkEmQ3ByZOd+DXvrl5t1IoEOFgEmNczNE4dB9wt/0MG9y4gJPKMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8585
X-OriginatorOrg: intel.com

PiBGcm9tOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gU2VudDog
U2F0dXJkYXksIEFwcmlsIDUsIDIwMjUgNToxNSBBTQ0KPg0KPiBAQCAtMTczLDggKzE1Nyw2IEBA
DQo+IEVYUE9SVF9TWU1CT0xfR1BMKGlycV9ieXBhc3NfdW5yZWdpc3Rlcl9wcm9kdWNlcik7DQo+
ICAgKiBAY29uc3VtZXI6IHBvaW50ZXIgdG8gY29uc3VtZXIgc3RydWN0dXJlDQo+ICAgKiBAZXZl
bnRmZDogcG9pbnRlciB0byB0aGUgZXZlbnRmZCBjb250ZXh0IGFzc29jaWF0ZWQgd2l0aCB0aGUg
Y29uc3VtZXINCj4gICAqDQo+IC0gKiBBZGQgdGhlIHByb3ZpZGVkIElSUSBjb25zdW1lciB0byB0
aGUgbGlzdCBvZiBjb25zdW1lcnMgYW5kIGNvbm5lY3QNCj4gLSAqIHdpdGggYW55IG1hdGNoaW5n
IHRva2VuIGZvdW5kIG9uIHRoZSBJUlEgcHJvZHVjZXIgbGlzdC4NCj4gICAqLw0KPiAgaW50IGly
cV9ieXBhc3NfcmVnaXN0ZXJfY29uc3VtZXIoc3RydWN0IGlycV9ieXBhc3NfY29uc3VtZXIgKmNv
bnN1bWVyLA0KPiAgCQkJCSBzdHJ1Y3QgZXZlbnRmZF9jdHggKmV2ZW50ZmQpDQoNCmFib3ZlIGJl
bG9uZ3MgdG8gcGF0Y2g3Lg0KDQpSZXZpZXdlZC1ieTogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBp
bnRlbC5jb20+DQo=

