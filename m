Return-Path: <kvm+bounces-46000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BA33AB075E
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 03:06:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD9234E73F1
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 01:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B378578F44;
	Fri,  9 May 2025 01:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bdpYWyyt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5556220E6;
	Fri,  9 May 2025 01:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746752776; cv=fail; b=VnED7JHpqtb1sjcAbNvxYWiA9r5ykRhb7h4Tj7CkIMS31P/nV4ny6Fo+evAmTcGED9mzm7oC/jDcM3L5xYnSHYUi3Z7ncl6vBUsRNSv0I6oEd8FkNVgWLc+F4BJFRT/tVREpDrpDim2LAMIngDZKrKQTT2XK2/pidiRlS0r27CM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746752776; c=relaxed/simple;
	bh=wl3y1W+rrLo1V39DOG1MpK6J2543KiHE70sKWA/FZIs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=alUCf5p9cjWV6N3s2bonsT3PfoK3cZZso6qJrmRXTAUpyGRejBENS6Kbg1ei3TGlrCfTwGrAnK4YQFccp4yODZMG0Z0Dvk5me4A9f2v7uM8erKz6r122VIHrRZxN5NPZBEEk+RZyu4gjwyQbm+Yf+cDTmj8uvuz/Wbh+KKYXV7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bdpYWyyt; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746752774; x=1778288774;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wl3y1W+rrLo1V39DOG1MpK6J2543KiHE70sKWA/FZIs=;
  b=bdpYWyytsspT1Srb1gnULnki9l09USOlzxgUXcUfScnNaSjbFzGsu4et
   HzpXmUTDT3EP1pRJ6XN6dx2BnRB0XFJnykT+yJvxx+1ls292Rhwfmr3vj
   XSf8hieYlAoHgGTaVrX1KpNpTHKJTCv0sEQ8bQ58GZDc5BaV5TqUq+79M
   d9d8okmduktzbzRV0d07440egdyJMpSHjAZLtFNmsz3JXOVboXIncCVFo
   pjCf4ZhDncNe2PHFhDTcDoKREmmJ5fmzhWkiUkV/jZc+OSoRJ0a1kDjmY
   hnUbXgu/2MOziJK2oP5p9Vr5Dod/la6EWP5e9WiduQCFbSPSyDPpKkDnk
   w==;
X-CSE-ConnectionGUID: R3eFu8DrToa7xp+cyyct/g==
X-CSE-MsgGUID: 5qbMUw/QQlSZamU2V2xJ9w==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="36191927"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="36191927"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 18:06:13 -0700
X-CSE-ConnectionGUID: ek3i1La+Sv++ij87cjQ3bA==
X-CSE-MsgGUID: Jg8b8/UjT0C50yuSqqC8mQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="141668576"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 18:06:13 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 18:06:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 18:06:12 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 18:06:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UO5OpIC7dIqbsZTal7xn/YVhduUeTRwg4ooJl3kTBswqRlQuLn7ik/VVEFJArDZ0WzTLH9AstU2+m9X3Qz/vmCIfbmcGIJFITsNqA0r3ZXjRVhuRQ+ekRN7wRVBbJXflv35uVU5XxLs/bZHRL/2AOhUwg1qwpYVuDIqHnJsiS9fIlB7jbEyn7CyManEZnZ70SvL5DcoG2JGMxhU5Mzy6+SBczsum91wvRBiaoNj7bOiwQ1hdhqwnEeE/qNeNI2Zof+sciZakngD4O9PtwZk8TJ5uULzJuPkQ1XOIOvW3SK325wYGwrSvDJXoMAGtIZmfKWy2gJnGJf7Uh6EKWVnF6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wl3y1W+rrLo1V39DOG1MpK6J2543KiHE70sKWA/FZIs=;
 b=hUBy+t5ftd+piGT1aLuzy9LQPfaUDssoKsNLDl/hzZrUfZHP0RQFySNns50SYCMxVEx3ZWZLWueceLV6YgiKZdJWnad193KjKPnjqhHvX/cONC0fCdBUyhj5IcXEkX1ljs7zOqD48xrtW0P8NnkeroqK2zs5hpZSYwsinRlJzFMNek+XeUNEzL4XB7k9LnITHaLmZjU0lMz8R1nyCJLEqn5iJqghMMg+awr/fA1/5ie15gfj+gev73W6VhltdCFLoMjUVBzLNEVkcgnhG/Il7H1Ph8532+mDhPspHd5e2Qkg3CpvtbJ1L42SLmVoIKeDg7gGlhT02/Vyr5bff3y3XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4442.namprd11.prod.outlook.com (2603:10b6:5:1d9::23)
 by IA1PR11MB6172.namprd11.prod.outlook.com (2603:10b6:208:3e8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.23; Fri, 9 May
 2025 01:06:06 +0000
Received: from DM6PR11MB4442.namprd11.prod.outlook.com
 ([fe80::b4a2:9649:ebb:84f9]) by DM6PR11MB4442.namprd11.prod.outlook.com
 ([fe80::b4a2:9649:ebb:84f9%4]) with mapi id 15.20.8699.022; Fri, 9 May 2025
 01:06:06 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 02/12] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Thread-Topic: [RFC, PATCH 02/12] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Thread-Index: AQHbu2NcKKP5MHJtMUaG74su/aJ+/7PD5FsAgATYIICAAMnMAA==
Date: Fri, 9 May 2025 01:06:05 +0000
Message-ID: <e3f91c2cac772b58603bf4831e1b25cd261edeaa.camel@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
	 <20250502130828.4071412-3-kirill.shutemov@linux.intel.com>
	 <1e939e994d4f1f36d0a15a18dd66c5fe9864f2e2.camel@intel.com>
	 <zyqk4zyxpcde7sjzu5xgo7yyntk3w6opoqdspvff4tyud4p6qn@wcnzwwq7d3b6>
In-Reply-To: <zyqk4zyxpcde7sjzu5xgo7yyntk3w6opoqdspvff4tyud4p6qn@wcnzwwq7d3b6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4442:EE_|IA1PR11MB6172:EE_
x-ms-office365-filtering-correlation-id: c31e67da-55f7-45c4-5594-08dd8e95acec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V0xYRC9Fc0pZQnpQMTZ3RktUa1E3NGQ5ZWt4UFFIaERhNTl0VGd1UVZNTHg0?=
 =?utf-8?B?V2NvQUs5ZUV6YTlTUnNlUEtRZ05KMjA2NElMTmpWTUVtZE9zNDhMOXY0MkUw?=
 =?utf-8?B?dHYxR0xLWGxGTlFNSytsbkxVZXdsOWt0MzZPSEYvelNkWjJPQmM2OWIwL0FF?=
 =?utf-8?B?dWFZU2VJd2ZaeVM4UmNRUFh3aUFMSW90bmd6bkhGSFVjN2pkazFHOExkQVZZ?=
 =?utf-8?B?bGF1WFNyL1p6TnFWaFhucDV0RFdNREdyT3FwS0FTZGpuVThiNG5FYmtNSmRL?=
 =?utf-8?B?WUFpZ0FqbDljN2dFaUJ3TEtLSjFEY2RuYkN1aTgvQSszZ0R2ZFI5c20yUTRh?=
 =?utf-8?B?RzcrdjRtRDFHNGRXbGdCQkVkekluckc3RjVJZmZIMHNtRXFYdzdLVllzWXFM?=
 =?utf-8?B?VVIzL3p6dFdRZUhHMlhGM252VGdpMWh4SDZqVEhpZ3hMM3Jud2xsVlRhNlc2?=
 =?utf-8?B?UlBsbTNaUVlvaklOd0dpVHFrdkFzZlFIeC82eGw0QXhrZFZSemwwU3Z2bkJl?=
 =?utf-8?B?U1hhb05aS3N0dHFwY2cycHZ1R09GOWg1Nms5YVdvSGZpQ0NNSVBGT0FRWC9I?=
 =?utf-8?B?NlVaUjNpeW1GMlFteXFGZUN2b1c5SEQwR2Y3YnlRZ3Jjamd1RzVXc2Uzemky?=
 =?utf-8?B?MVFGUFdra2dGcU10dkoyNUp1dEtCUktpQWZtYVZoSVBMV0twTndhVnhocFcz?=
 =?utf-8?B?Skk0RjNGSkRRK3YwdkdIVGVybWFCeWMxM2F1WU1ab3Q2VjNIeGtmL0wvcFVv?=
 =?utf-8?B?UDFvbmQrdGlBanc2WTdPeldHYTZzQzRaRFdXa2RFVUxRbjRLY1VYWkhKbkJI?=
 =?utf-8?B?QWNibmQwamFxazU5ZDdJQmlsZlZSU05pekNqTWVTWEhIWnBGcjV2OHRsbC9M?=
 =?utf-8?B?YXQxbjJlMTZtZFJQWDIwVUJEUzIrY0dSNG5SL0JUQWxrYjZpVjBsSmlKTm9F?=
 =?utf-8?B?TlhzL25BQzZ4eHl1eXpVMEFRR01mNXIyMnlrZ3E5c2ZKUmZxY1BOSnNCYVox?=
 =?utf-8?B?VVNiMjRmejNoL0hFWmtabVlXTjNWc3lWcjFpMkNnbWZ2WWdoWGw5dnVIbkQ1?=
 =?utf-8?B?T1BTZlA2eWs3ek1SUXBDb1JOa3ptOHVqMW50QW9mV1I0M1hUT2dHc0NrUmxw?=
 =?utf-8?B?K25wNVdLWmQyejVZMWE5ZkFiOCtEejN6U21TeEpDY0U0ZWt5b2FxWExZMnBD?=
 =?utf-8?B?NWlURGM4aDZGVTFsMzgrY0FMQ1JoR2hwZ3pjNmFzY0E0ZFdxR1Fwbkw5ZDhP?=
 =?utf-8?B?K0lGRzhYVVNPa1BjSmtGWmVxN1l6MXl4MWtrdDJtcENUN1ZEUmpiQWpIN0s3?=
 =?utf-8?B?cnFrMVJMM3pPWFNnendQTXdtR0RsT1BCMTdoUDhpZGMrVEQ1NEtrMjJlSURB?=
 =?utf-8?B?R21POFV6RVF1NzhMYXBHVXF4OGRGSUJlNy9qT2dxZjlrbS9hWnNzVmNLeERB?=
 =?utf-8?B?dXM0WnhNYjZ2ajNnRi9LRFZoMUFUUzdiQTZQM3RZQnVrbHVxTnlneE4xS3pQ?=
 =?utf-8?B?N0FBbzBoZEVlaTlEci9XYTlwLzF4cGswWGpqazh3dW5qZDFybVhmaEYzenNS?=
 =?utf-8?B?S3o4dUR5Q1NYOUpYM0I3UDRBdmVSUmRuZ0xqbGJoc3g4R2VJcGE4M1lGdlpV?=
 =?utf-8?B?MFFFaDZPSE5MTmZUcEt6MDVFS3laS29TaUlmblgvaGNjaDNpcXAvM0pzdUZY?=
 =?utf-8?B?c25xQ0paYTQ5YmhXdFpUckVHTEdvd1FZd1ZmR2s5VXorZnlYaTl6VnYwNnVh?=
 =?utf-8?B?Mk4yOGVsTjA4b1VlSTRPQVp1TXhuajZ1Q3p3ZVd1bXBPZGY3RGEwNi8reXlv?=
 =?utf-8?B?eVYxcDFjbE5BT3JDUWFSc2RYK01kK2lXaDBGTUp6QTVUcTluTHVlN3Iycnhx?=
 =?utf-8?B?Y1VteGhVQ2tMN2JGakoxc3RBVlRWNHgzVWRoZ3JYRDdmWjR2WkQ3TWc1M3ZL?=
 =?utf-8?B?RXBtL3psSklHSWV0b0VMWlJ5M0c3a3BlYVhlamZZMHM3VjYvVlZXV0JjbUp3?=
 =?utf-8?Q?g0qyRQ0APWkfqgOVwklOuebUw1Oz+g=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4442.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VjhBSWVpYmQ3cyswalVTTGtQNmtkNWUxejhjUVJVVm9EWlhJNVhVR0lUdG5V?=
 =?utf-8?B?ODVDeitQWEN4RXhYTmlNOTYzc2sxVVRrMkluMjU5dkpPbFIvbUh1RGVZNXZP?=
 =?utf-8?B?OTRvRHM4ZkNncVF4OGkvWUJkTWcvWSthcVhkSHJpWlE5SzN3SFNXWTg0Nmcy?=
 =?utf-8?B?NG5jd1FwYkZvQjlOek05N0FvRWlWMi9GbnRzTWZkb29LUHR4UHV0TVlNbnd0?=
 =?utf-8?B?QUhsVFd1SXM4VzJIQ2RTS1FBMXhOdUxpOTNrdG96dFd6Vk8wTkNESnIzbVRK?=
 =?utf-8?B?UnA3TW04YkZILzNpc2VULzhvL3JVaXhXRnVxNERlNUl0cFc5ZnY2NWZxaW5E?=
 =?utf-8?B?WXdCMUgxYkU1M3lLYzF5VG9EbUVuVkg1NmFtdU1WSElTZy9LTFJkZGZiUld4?=
 =?utf-8?B?dDhqYzBzN2l2UGx5ckRoWUw4aVoyalNETEcwYjJjR0RTK0l0SnltOGpPbWRi?=
 =?utf-8?B?blI0SG4zbS8rTHJyWXpRQ1hxMHVKdVBFNEg4SjFXSXZacWJic2JrQTZ0ek9M?=
 =?utf-8?B?bmc1aFBCT1JFQ0R2a1ZTM2RGeG9uakMwSkQwOUYrQ2JjRjFPNi9aSGRJTWl6?=
 =?utf-8?B?NXdtdzFldXZmVDU4cTdQREhJcDlSYitaMlpGbUI3aU9mN0daRWU4R0t1RXY1?=
 =?utf-8?B?ZmpaU3hTRlBmOW9HbHN1TXh2N0JRNkFKdmtnUW9zUDVHdmI2L2RtbC9ZM1Ix?=
 =?utf-8?B?VkpFcXpSd3Y2Y01XWVF1UGtuNFB3andyYWpXRjFiNnlEWWJ2VElkRzJEOG5j?=
 =?utf-8?B?N3FhVDJ6L1B0OEVxcUN4RlZwYjJob1RvanhORjBOVnJTWHFBTFo3dHcrV0l2?=
 =?utf-8?B?T0Z2eERieTYyZE91cElTQzNaMG1FWkNOeUgyakpib041SXVMcTYrNVN6d0lx?=
 =?utf-8?B?blJJV1B3Wk56ckxoNzFHU0VOL0s4YXpkTmEyZDVkZWRNc2Q4UkhKaDFqVnNr?=
 =?utf-8?B?TWJIZzBCVG5TelpxZCtCaGlnMVIycW1SZGdibktodWZJOTJITi9HeHZ6aVYx?=
 =?utf-8?B?bExTYUN2TnVkNXpWME1pdmEvZUFybjVyVVdFcjJYNU5tSlFvc2JmN0xUR2x0?=
 =?utf-8?B?U3IzNnVIOWdxbVd4bWxsWW9VbUl3bWpCbVJyQ0N4UktqUWFQT0U2bk52WVpU?=
 =?utf-8?B?anVSdHk0dUdMdjIza2J4RVptLzI0bUszeGplZk5IZTZ5ajZYdzVCTUJYTStt?=
 =?utf-8?B?R1BQbXNYNTF5OFF6d21lVkF2NnhXdXFHUWszdDZRdjNURk1qWW4zdld0blg2?=
 =?utf-8?B?ZHpvc3lmMnFKYVNPbXdaU2Ixbm5RWDJuLzZsSGQvcDBxREI4bFB1eXg0YjVz?=
 =?utf-8?B?M3JDemc1RlhFL21kM3NaNjhZaFAyMWZuS1E5S1h1ZjZob09HVWpkQUFHRmhn?=
 =?utf-8?B?SnZpYmNBelNQdjBQZFlKY1k5bFVWNDhzaUZ4SllLQnNNUHgySUJGeE5FRENN?=
 =?utf-8?B?VzZqTThvcWxOQ3Y1TXVXSWRMTTBIcStJZzl1MEt0NGhab3NweUNFeW1UN3J2?=
 =?utf-8?B?QnZtOWNSS3dHY2ZEZXJuZ3dOZjBkMXIvMHRJQm1nVytZU2JRMGJkR2U1Nkhh?=
 =?utf-8?B?TWtPcWpEQlUvNWgvc29uWnVlYUYwQzYrNW14czZJdjNmbElKNEFKTnh2NTVv?=
 =?utf-8?B?UGRVdmh0R1AzMkhSbGowNFlUTE1UejViTWt3U2l3RnNpNmpqR1dkQU9PUEZt?=
 =?utf-8?B?UGRHTkVLVzQzKzlNNEordytpckhZM0VMemZ4K2JhSjFTTDlmUDM5OEwyMGMx?=
 =?utf-8?B?UVNZN2U2a0YwZ1FzK2xnUzcvdmoxU1d0cUZQckRIM2pIKzNYeHdxVmNNemZO?=
 =?utf-8?B?bEUyZHNMaGR0bHZvOFpya2gwZjY1R3RIaVVSTHFMZlpZQVUyQVRWZUI1MXJW?=
 =?utf-8?B?WDFzV0k3ZDJOS09sMlRpK3Q1TUwvZ2VubXEwamYwT0hyL0lhQ2VKNzhYMnhG?=
 =?utf-8?B?RzFWNGliWU92ODBrSjNacXcwRzRFVnQrYjZ0OUlmYU5JRlJBNVN1Rk54TDA2?=
 =?utf-8?B?MUlibytneU9ERlg1OW5VU2YzWGVYMHFYTjd2VEZGekJYSkJuVlNaUWNjM2VN?=
 =?utf-8?B?aVd4Z0kzd3orckRseWlvRWZRVVMvekE4MHVWUGNxRVkvYi91UFFYSGxWaVRv?=
 =?utf-8?B?M3ByZDB4TjY0UzU0SDFSNC9OMmxwR08vemZWeEdoZlZHdE5mWG1LazlRQmF2?=
 =?utf-8?B?RUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0A03B997FCC5694FABA3757FCE1F4D34@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4442.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c31e67da-55f7-45c4-5594-08dd8e95acec
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2025 01:06:05.8294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9pc5s32nSDEeo0kD6MknGk9q9GRlnNral5LKMNnAGa/uB5HhZfGKKLMVhFV4XpGrMO0/ngwJ0QVU+lQSZ4RSfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6172
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA1LTA4IGF0IDE2OjAzICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBNb24sIE1heSAwNSwgMjAyNSBhdCAxMTowNToxMkFNICsw
MDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IA0KPiA+ID4gK3N0YXRpYyBhdG9taWNfdCAqcGFt
dF9yZWZjb3VudHM7DQo+ID4gPiArDQo+ID4gPiDCoCBzdGF0aWMgZW51bSB0ZHhfbW9kdWxlX3N0
YXR1c190IHRkeF9tb2R1bGVfc3RhdHVzOw0KPiA+ID4gwqAgc3RhdGljIERFRklORV9NVVRFWCh0
ZHhfbW9kdWxlX2xvY2spOw0KPiA+ID4gwqAgDQo+ID4gPiBAQCAtMTAzNSw5ICsxMDM4LDEwOCBA
QCBzdGF0aWMgaW50IGNvbmZpZ19nbG9iYWxfa2V5aWQodm9pZCkNCj4gPiA+IMKgwqAJcmV0dXJu
IHJldDsNCj4gPiA+IMKgIH0NCj4gPiA+IMKgIA0KPiA+ID4gK2F0b21pY190ICp0ZHhfZ2V0X3Bh
bXRfcmVmY291bnQodW5zaWduZWQgbG9uZyBocGEpDQo+ID4gPiArew0KPiA+ID4gKwlyZXR1cm4g
JnBhbXRfcmVmY291bnRzW2hwYSAvIFBNRF9TSVpFXTsNCj4gPiA+ICt9DQo+ID4gPiArRVhQT1JU
X1NZTUJPTF9HUEwodGR4X2dldF9wYW10X3JlZmNvdW50KTsNCj4gPiANCj4gPiBJdCdzIG5vdCBx
dWl0ZSBjbGVhciB3aHkgdGhpcyBmdW5jdGlvbiBuZWVkcyB0byBiZSBleHBvcnRlZCBpbiB0aGlz
IHBhdGNoLsKgIElNTw0KPiA+IGl0J3MgYmV0dGVyIHRvIG1vdmUgdGhlIGV4cG9ydCB0byB0aGUg
cGF0Y2ggd2hpY2ggYWN0dWFsbHkgbmVlZHMgaXQuDQo+ID4gDQo+ID4gTG9va2luZyBhdCBwYXRj
aCA1LCB0ZHhfcGFtdF9nZXQoKS9wdXQoKSB1c2UgaXQsIGFuZCB0aGV5IGFyZSBpbiBLVk0gY29k
ZS7CoCBCdXQNCj4gPiBJIHRoaW5rIHdlIHNob3VsZCBqdXN0IHB1dCB0aGVtIGhlcmUgaW4gdGhp
cyBmaWxlLsKgIHRkeF9hbGxvY19wYWdlKCkgYW5kDQo+ID4gdGR4X2ZyZWVfcGFnZSgpIHNob3Vs
ZCBiZSBpbiB0aGlzIGZpbGUgdG9vLg0KPiA+IA0KPiA+IEFuZCBpbnN0ZWFkIG9mIGV4cG9ydGlu
ZyB0ZHhfZ2V0X3BhbXRfcmVmY291bnQoKSwgdGhlIFREWCBjb3JlIGNvZGUgaGVyZSBjYW4NCj4g
PiBleHBvcnQgdGR4X2FsbG9jX3BhZ2UoKSBhbmQgdGR4X2ZyZWVfcGFnZSgpLCBwcm92aWRpbmcg
dHdvIGhpZ2ggbGV2ZWwgaGVscGVycyB0bw0KPiA+IGFsbG93IHRoZSBURFggdXNlcnMgKGUuZy4s
IEtWTSkgdG8gYWxsb2NhdGUvZnJlZSBURFggcHJpdmF0ZSBwYWdlcy7CoCBIb3cgUEFNVA0KPiA+
IHBhZ2VzIGFyZSBhbGxvY2F0ZWQgaXMgdGhlbiBoaWRkZW4gaW4gdGhlIGNvcmUgVERYIGNvZGUu
DQo+IA0KPiBXZSB3b3VsZCBzdGlsbCBuZWVkIHRkeF9nZXRfcGFtdF9yZWZjb3VudCgpIHRvIGhh
bmRsZSBjYXNlIHdoZW4gd2UgbmVlZCB0bw0KPiBidW1wIHJlZmNvdW50IGZvciBwYWdlIGFsbG9j
YXRlZCBlbHNld2hlcmUuDQoNCkhtbSBJIGFtIG5vdCBzdXJlIEkgYW0gZm9sbG93aW5nIHRoaXMu
ICBXaGF0ICJwYWdlIGFsbG9jYXRlZCIgYXJlIHlvdSByZWZlcnJpbmcNCnRvPyAgSSBhbSBwcm9i
YWJseSBtaXNzaW5nIHNvbWV0aGluZywgYnV0IGlmIHRoZSBjYWxsZXIgd2FudHMgYSBURFggcGFn
ZSB0aGVuIGl0DQpzaG91bGQganVzdCBjYWxsIHRkeF9hbGxvY19wYWdlKCkgd2hpY2ggaGFuZGxl
cyByZWZjb3VudCBidW1waW5nIGludGVybmFsbHkuIA0KTm8/DQo=

