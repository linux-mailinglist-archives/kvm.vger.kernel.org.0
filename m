Return-Path: <kvm+bounces-38812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B01FA3E916
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 01:12:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 324224217A7
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 00:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0BFB33EA;
	Fri, 21 Feb 2025 00:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H0Km9/U9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCA229A1;
	Fri, 21 Feb 2025 00:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740096764; cv=fail; b=MOLVqKIXYwVIRw23mlj2VGpuxvReH0pZcV4AhOoqD6Ul/53zpaFLKR5QHZYF0C49XfFz6jVOdXYFLTbeQJgdtHRewHfekEPh/SgR5vyhKGWUBR9CkSaUwdR13yP6Hzni9Th9yQ588EHwzknrTWISfm5V9/+zxhxJu3od3/ycdVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740096764; c=relaxed/simple;
	bh=xE+YTG6Ck1SdAnzOyztx2DjnOA/DX8Z083TqaM/JXEs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FKq58G6FHhHgmHaNwJb9uiNbnP2D+Vm2gvH3f3pR1vmze9I9vTffCNMq2EZq1basCIS0scY1pRzVMW9RrI1pJDQYHQTYmiE/anwQTzEMTkO+/ttOVY5OFpWqhfKtOfSvOw+qNxO59bYaFo45qaf8w6Z4yVdx8jChFImpMD4iXUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H0Km9/U9; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740096762; x=1771632762;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xE+YTG6Ck1SdAnzOyztx2DjnOA/DX8Z083TqaM/JXEs=;
  b=H0Km9/U91JveujkXJhN/GLRWsW1FqP8KrMNyLt2dxO58UI07tFUMbtRo
   hfGFVcVJisqwxpQENLLR7y3uQGNYVcWPYHxFym3RB8LChurL8CSqFb+ub
   R8Lop0iiHcvtlvU/DLjaPofDWxRehxG/RpRMRgpB9N+Tutem/g9CoCMQG
   LX9IByzH5tJzpt8T0pbzpfYnyaZJ+SsW5zrDXA0Zji2cLFPKyQkB5zGry
   xsKKRg1Joenk/We8ebV6ivVaLELIHqVsryj/leuteOGCMt61WR8IPuTsB
   kG+cI7O/GeyhbUzC7RC2uZnfCLorBEoovjyeLX1rMwacAhKjrAcRy7qHt
   w==;
X-CSE-ConnectionGUID: LtvUnQ/sQvmLwBMIYpGyoQ==
X-CSE-MsgGUID: Jv0Q+Hl9TRGdY/YVDyISFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11351"; a="40616620"
X-IronPort-AV: E=Sophos;i="6.13,303,1732608000"; 
   d="scan'208";a="40616620"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 16:12:41 -0800
X-CSE-ConnectionGUID: t0rOARQORTKcAMFZ0Ag9zg==
X-CSE-MsgGUID: 2P6jgASiTiG+ScwoZsOcWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,303,1732608000"; 
   d="scan'208";a="115149271"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 16:12:41 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 20 Feb 2025 16:12:40 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 20 Feb 2025 16:12:40 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 20 Feb 2025 16:12:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qsgq7qfFl5j4y3w+HamCRIhJ3Ev6Q/lZeovSUqTdTjpbk6/92v0tJNu16APlwbWMK/XlQ9YWQChWtXg+JuU9bV+hcB2LxVAAFPN9ZefRz4HwE3CJ9yxTx78b4wAL48B895uBx52jseADeuUe0AuRZxW2aiotji5Qtblv19/oTzsmLkjoctPQESNOtokFDHLe7W2BWNKwGsvZAb2X1a3bAALQLOMdIFWHju441M2g+J9eBrgLi38DzL3JLbGMkj1sKJsSQY6iEXRVMR+WfQiucJVpxs+HAFjkX9xmMRh313AwY9FLP4OfCbzf/Q1VAqGe1RO7CqspkQ5CxH7kDZkLNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xE+YTG6Ck1SdAnzOyztx2DjnOA/DX8Z083TqaM/JXEs=;
 b=i/PMLBC3iLGFflh0Z+W5+jQPuO3yYHzWdMENxQjMcSxejFffd8STdUmn1biVtF+C/NvzgPcuGTojeupHzhFLIjrBhnN+jrjnj9KyaYMq8ueAQBQL7Z7EaGwcIIVFCQ2EJ/XqHBwjjPuvclxmAsKMa9tkiJMrjSDYbf7R+Ex46aa8tyzSVgbroswhoBud6GpdbHyT3g5V2xtv1Ub5c7DWxyJy8HVoYwbCNH77BceJNKnJ92ruUPqeW/+998HkokePkzWfTtypvSWDQJHFXbY4hGjw2QWbvvlIbrl5Q/crqxypLYPy1LC/yW5qeWzNCeNlXkV+xUiaWbpqIOKCBIGD9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6189.namprd11.prod.outlook.com (2603:10b6:8:ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Fri, 21 Feb
 2025 00:12:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8466.015; Fri, 21 Feb 2025
 00:12:37 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 13/30] KVM: TDX: Get TDX global information
Thread-Topic: [PATCH 13/30] KVM: TDX: Get TDX global information
Thread-Index: AQHbg7nWRzXCP848Rk+IU5qbafSFprNQ4yeA
Date: Fri, 21 Feb 2025 00:12:37 +0000
Message-ID: <5f7525877c21bb9dccd77c5a14ad79b585791aba.camel@intel.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
	 <20250220170604.2279312-14-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-14-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB6189:EE_
x-ms-office365-filtering-correlation-id: f82cc256-96ff-4f5e-a0ea-08dd520c72d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?amFuUEpvQnFxU2JKMmE0L2Ezc1AvU0FiazJ1Zkp6dlFDT2orb2VVNHlRRnhl?=
 =?utf-8?B?ZHVyRldLajk0R3gxMVQ3dUVpK2tPeDN3OU5JYk05a3c2TWFmRFNiUFQ2MjQr?=
 =?utf-8?B?VlNHME8yeVd3K0JwU2IwMlpUSXB1MTZYM0lqYjBFM1RqbDRlZUJ1SlRPNHF0?=
 =?utf-8?B?bDdEOEEwcm5JbmVZL3B5UnVVbEJxaTZCZXhBTFRRRHFWdDFxdkViNGxjRUNi?=
 =?utf-8?B?aDB5SXBVV1B6YWtqcmVjaE1Yd0dmMlNVVWl1ditSblN2WkV3elRkLzNJZ0lZ?=
 =?utf-8?B?UHFHZWJpMmR0YW5EZmMvMEZxWHRocFE5YnIxUllWWm5SaWRRcE5wNUxqM081?=
 =?utf-8?B?a2xRekxxbnJhbGFBSWZFZ0RDRTdnQXhDTjRDdTVYZC8wdHpiVVdYdXIyL0tV?=
 =?utf-8?B?cTVMc2FJOVFlQndVMUllN1pyVHZweEM4NkU5aHB0b0dBUHlWOFhlcElMWWxY?=
 =?utf-8?B?QTNhdGh0Q2VIbkJmVXN2L3lYVm5IYkNvUjVOeDFEOWZULzFzZkxUdFdITXUx?=
 =?utf-8?B?M0IreElCNnRqYXdyckJha1pCL1Q0bVp2ZjNsOGVvcU1nZ2ZEekFybTlKdjZQ?=
 =?utf-8?B?YUtrbitpamhZdnBaMFlsaGJEQlhORGwwWTRNQkRuSm0wNlFWaDZoVThrb0cy?=
 =?utf-8?B?ak9pdFZ6eU1RTm9SYzZvd2JOOGF1TzRyVEcxTW1KMEVvdy82K2ptTkx1bFNa?=
 =?utf-8?B?amU3QnV1NzB0cFNYL1NJL2gwVVpQUjU4cWEzR0xSWVowTkNyeld0djRHUlRS?=
 =?utf-8?B?Z1B6ZFNTWU4wdGRhN3FTWnd3R04rbXpaZW96d0EyOTVCTElEUFpralRYWHMv?=
 =?utf-8?B?bFpWQTR5dEZheUpHWUQ2Z09lZGN2SXM3M1NNQUFOMTBEbzN4Ylp6NjBEN3pC?=
 =?utf-8?B?aDFLNnA0N1pzeDhkbDBOTEJrRWZ2WjJpK0hZTGpyeWlrT1M2cGxPRkV3STJy?=
 =?utf-8?B?TmZXSUxpUWJvMUtwNExldWtqQW9HWWVWYTVqN2M5KzY5Y3pDWmEzajJ4VU43?=
 =?utf-8?B?MUlhN2dZTG4rSGlpRXkyM2VEU25OYnc1QTgrY0pzRFFqR2ZxMndUZG4rMDNu?=
 =?utf-8?B?VjhQc3BmdG53Zzk2NzFySWk2dGlqOXk5WUJicjNJNFBSMG9aRXJCdGRlaWlw?=
 =?utf-8?B?S1cwcE5wSkRIQzZDa2xQMHNIZlFLbUFkQ1Y5c2dtNzBONklJd0I4aTg4TjU1?=
 =?utf-8?B?SXFFandVc0xxT3IrTzBZc0hUUWV4eSsxNkl4dGlVN2w3TUY2dFRQOWEwR3Nu?=
 =?utf-8?B?ZkZlMno5alVrVkZCSGdLVElabUxEZUtCWFJta1JEbzFIR2tXeUVXNE52TDBU?=
 =?utf-8?B?L2g1WTFsSHdjTUxHSk0rNE5jVXVVTTh5cjY4K1JQWmQ2QmpCdjdRdVBMN0Jn?=
 =?utf-8?B?NysyWjhvRERVb0JxN29lc0FMMHNvbFlFYVUwUFZVMDBHck1LUzB6R1dpS05n?=
 =?utf-8?B?NjhYRkJiYi8xT3pieEZDdDJQejR3MEUxbjhPMFhYRkpiYWJPMFlFTDlsUC81?=
 =?utf-8?B?SFBNZ24vS0oyalRPcU1lcE1DeDFmdFBpSWJOU2JHYWF5ek5oZjJwejZWTWlq?=
 =?utf-8?B?bTRrYThXVjUxamEzc2Z2b3FGZ1ljNWM4cEJjOHV4Y09WN2hoS29KNG5tTG5x?=
 =?utf-8?B?aUNmWWxuSWNHbHE1Y083aHIvWjE3ZnJzSjdOOGtyOGhUQ1dHZGJsSkw3bUhS?=
 =?utf-8?B?cHprcmFUQUFzWHJSQ21nMzdTZUp1dWxjbXUwOWRWbndMVkJFTEloSWVjZFQ5?=
 =?utf-8?B?ZzY3cW1BQnNFaFhBMWFyQU8xemFFbzF0WGEzQWxMZmFFR1VMeDl4b2V1cmhG?=
 =?utf-8?B?MFU1TzRLTW5OKzQvc0RkOEVwMURlL0ZkRkUrREp0Y0NTbk1EYi8rRkN3T21S?=
 =?utf-8?B?bWRPcWlLUUNPNE94SkdZaXVxdittckRUWkpDOGJnSW5ZNUtsWFNveS8wd29L?=
 =?utf-8?Q?mqXUso4ba4n1F421QjrbNC0kU4xRehU7?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bGgvbnk2bG5mWmFVT1pxaExtdm9uUk1USWhhREptYkJ0ME5BUU1INy81enhC?=
 =?utf-8?B?TWMrRysvYkxkZjR0K01KVitneXJmSmZlTGxXYmVXSFdhenUzWnYwRnBOMWpi?=
 =?utf-8?B?SnFncy9wbk9qVlhMMHIyWFdUUW80U1lIYjJ4KzlsTmlMMjZZVDhhNXQzbHdo?=
 =?utf-8?B?UUMvcktoSlJjZjVtaExoTlV5Rzdqb3B1NDcyWlN1cTlvK3FjV2VlY3pMV3FQ?=
 =?utf-8?B?dytzek1mbU1QaUNlMDFBRU81OWUrUmkyb3VwYzZnTU02a2t6NWZXQ1pwRHpL?=
 =?utf-8?B?aHBRdTZFaC92YjBlc0ZMN293ZEJzZVJXVmhLR0lGYnNadFBSL2gwMUluNVph?=
 =?utf-8?B?K2pzWGtWUjlzOUYzNnlVWTl1YWhXa0xwSEpQWnRiZ1hJYi9wTVRzNDgwQ0dw?=
 =?utf-8?B?TXBTZnhaMlRlN1pFZStXR2xmODhNTlRDRjlIMHovc1BzRVhSanpvRUNTRXY5?=
 =?utf-8?B?YTcxdlJxQWtHTXpuZU12WnZXaldQNWVaN1ZOZDBGWEoyNmNKU3RVeEdIU1pH?=
 =?utf-8?B?RERyblRadzNzUWk4bjVMeVBkTlpEMm9wM25tbWRGUWtpR1FJdTB2NHBVZEpK?=
 =?utf-8?B?RmRRcGRJT2dLd0E1ejl2dGw3dmo0ZzFGK2Nxdk11ZmlkMDZCN1Z6QU5Idk4v?=
 =?utf-8?B?ZkM4aG9ya29wODNBWi9oZVhRcG1KYkttQ0NVd0tuTDJmNTJ2UzFvaDlqWVNR?=
 =?utf-8?B?Y2FDVWpMVlFoOXBLMzVydUN6Y0l3eUdBNXQzaGpFM0lwWGYxa1ZpVEFZS2Vz?=
 =?utf-8?B?VzV6L3JJUGtpWGJnd3FWdUtQa0FtMllKb3hPakU0aGRvRzVIbk5CcGxPQTg5?=
 =?utf-8?B?WGg3bkRaZS8yQjlMRHY1YlhvNDZidVIxZmdZZHhQMGtnVWt5MkZLbDlPUWlx?=
 =?utf-8?B?dUJTajJCMWF3ZExpamFacDJtNVFTY2FEamZES2FBS3BiS3BSVzM4RXV6RzIv?=
 =?utf-8?B?Y3RNUWhqeGxQNXdSQjBMWTdtR0pGZGpWQ3E4ZVYza0w3Sk9mazlNd21RaHVV?=
 =?utf-8?B?djk1UXBrUGEzeHVVQmtPeGRwS0Jkcll3S3BNMVlFQTVQaWdIZS9RSk43RjJW?=
 =?utf-8?B?YldxTHJnZjQ5TlJ5dkI2TmxybzJOSG1DME1FUS8wVDMwVXdkTUU1dXB3OU9M?=
 =?utf-8?B?VWVGYkUrcGlubDJhU1RsRjlJSmJxaG1FamhBMzZVbWVlc3luOTA0bFlkVkRK?=
 =?utf-8?B?SmI2eTA3NlFsY2J5a3FuUmMyTWhnTnBFQ2N3M0VxekRDdys4MUV6cVZVVDNQ?=
 =?utf-8?B?bFFZcDR5NWRzNmZlWWlVLzV6VHhPdzNJcmZRRHRvcS90S2I3YS9mdS9KeHhO?=
 =?utf-8?B?aVdocCtiUWlOOEtiYytwK0oxdlVNaXVka0x1M3pYQjIrWElDNklDVzdKdjNa?=
 =?utf-8?B?ZnY2WHppalhYSWs4N21SbGZKQXc3WWFmOVM4bDBHMnFlaVFmUkZieG5WcXA2?=
 =?utf-8?B?dzhaNzY2cTFuRHVObEZkVHJBVGs2TVpqWmg2WnowL2JRblo1TjNFVHhOODF2?=
 =?utf-8?B?OU9iVHcycWU3SFRSeXJmYUpab0U0V29RRjdGc2tkRVZjeXM5aWlFNnM5eDRt?=
 =?utf-8?B?dlVwczlBemRJZnlvdmsvd20yY3pQUlc2WC9sVEVYZ3ZwZk0rckFqK1pUbUc1?=
 =?utf-8?B?Z1dvTUdLZlRNUXBXRlFnVVhEcHA0UjFKWDhFSlNZK3ovUmV5VmxsNzBhWjhK?=
 =?utf-8?B?YmFJbUpXdENNYlNJSzFQTjhGenQrUno0MGthckVxaFpEb05WeHZHQThUSys3?=
 =?utf-8?B?UFB3N05udHhJRVpGSkZ5VVNPOWxpQXFMUWljN3cvOGtvazZ0SXhjMnVhcEs4?=
 =?utf-8?B?NzFFR3FZL3BUZEVBUTRnK2lad0p6TGNVTU05UVdPN2Z6R1J2VE9ERXV0K040?=
 =?utf-8?B?a0h4K0dnalY5aWRYRDlicXkxNnZBRFMxUkdyaXNlY1VxdHd5MjFtVnRlNGpD?=
 =?utf-8?B?WVhrWjlySEdDdEs0QXd2R3JMQndFQTVIaDhOOHpkWFdoRFhoOGg3NUdteFR4?=
 =?utf-8?B?VlZRTkdaTHhXRmFlZWo4aTFIQzB6ZUJqVENnbVBFSU1DbWNpeFVIME5tU1px?=
 =?utf-8?B?WFVITTE0ZjM1TDlYVFZlajE4MzlpaXJzK3pEUEE2cTdRSHNYb1Bqem5QMHBI?=
 =?utf-8?Q?SDVjfMfq2UdskAOpaN8YG3LQd?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE58AAF47BCB2B44B15EFE15B692B683@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f82cc256-96ff-4f5e-a0ea-08dd520c72d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2025 00:12:37.4966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Id9JPYHR27QCJb+66RwdPDcbQv/gUYEYGz0VX7R/Hg+noob/bY0Jh5GyQAbveHLEO2ETuqd9f8+vlMbnY7qcCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6189
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTAyLTIwIGF0IDEyOjA1IC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBGcm9tOiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo+IA0KPiBLVk0gd2lsbCBu
ZWVkIHRvIGNvbnN1bHQgc29tZSBlc3NlbnRpYWwgVERYIGdsb2JhbCBpbmZvcm1hdGlvbiB0byBj
cmVhdGUNCj4gYW5kIHJ1biBURFggZ3Vlc3RzLiAgR2V0IHRoZSBnbG9iYWwgaW5mb3JtYXRpb24g
YWZ0ZXIgaW5pdGlhbGl6aW5nIFREWC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEthaSBIdWFuZyA8
a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogUmljayBFZGdlY29tYmUgPHJp
Y2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0KPiBNZXNzYWdlLUlEOiA8MjAyNDEwMzAxOTAwMzku
Nzc5NzEtMy1yaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogUGFv
bG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0v
dm14L3RkeC5jIHwgMTEgKysrKysrKysrKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRp
b25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYyBiL2FyY2gv
eDg2L2t2bS92bXgvdGR4LmMNCj4gaW5kZXggMDY2NmRmYmUwYmMwLi43NjFkM2E5Y2Q1YzUgMTAw
NjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gKysrIGIvYXJjaC94ODYva3Zt
L3ZteC90ZHguYw0KPiBAQCAtMTMsNiArMTMsOCBAQCBtb2R1bGVfcGFyYW1fbmFtZWQodGR4LCBl
bmFibGVfdGR4LCBib29sLCAwNDQ0KTsNCj4gIA0KPiAgc3RhdGljIGVudW0gY3B1aHBfc3RhdGUg
dGR4X2NwdWhwX3N0YXRlOw0KPiAgDQo+ICtzdGF0aWMgY29uc3Qgc3RydWN0IHRkeF9zeXNfaW5m
byAqdGR4X3N5c2luZm87DQo+ICsNCj4gIHN0YXRpYyBpbnQgdGR4X29ubGluZV9jcHUodW5zaWdu
ZWQgaW50IGNwdSkNCj4gIHsNCj4gIAl1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiBAQCAtOTAsMTEg
KzkyLDIwIEBAIHN0YXRpYyBpbnQgX19pbml0IF9fdGR4X2JyaW5ndXAodm9pZCkNCj4gIAlpZiAo
cikNCj4gIAkJZ290byB0ZHhfYnJpbmd1cF9lcnI7DQo+ICANCj4gKwkvKiBHZXQgVERYIGdsb2Jh
bCBpbmZvcm1hdGlvbiBmb3IgbGF0ZXIgdXNlICovDQo+ICsJdGR4X3N5c2luZm8gPSB0ZHhfZ2V0
X3N5c2luZm8oKTsNCj4gKwlpZiAoV0FSTl9PTl9PTkNFKCF0ZHhfc3lzaW5mbykpIHsNCj4gKwkJ
ciA9IC1FSU5WQUw7DQo+ICsJCWdvdG8gZ2V0X3N5c2luZm9fZXJyOw0KPiArCX0NCj4gKw0KPiAg
CS8qDQo+ICAJICogTGVhdmUgaGFyZHdhcmUgdmlydHVhbGl6YXRpb24gZW5hYmxlZCBhZnRlciBU
RFggaXMgZW5hYmxlZA0KPiAgCSAqIHN1Y2Nlc3NmdWxseS4gIFREWCBDUFUgaG90cGx1ZyBkZXBl
bmRzIG9uIHRoaXMuDQo+ICAJICovDQo+ICAJcmV0dXJuIDA7DQo+ICtnZXRfc3lzaW5mb19lcnI6
DQo+ICsJX19kb190ZHhfY2xlYW51cCgpOw0KDQpXZSBuZWVkIHRvIGNhbGwgX190ZHhfY2xlYW51
cCgpIGFmdGVyIHdlIGZpeCB0aGUgYnVnIGluIHRoZSBwcmV2aW91cyBwYXRjaCB1c2luZw0KdGhl
IGRpZmYgSSBwcm92aWRlZDoNCg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMg
Yi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQppbmRleCBhODg5MDg3ZjExOWYuLjc3MGFjOWI4YjUy
OCAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCisrKyBiL2FyY2gveDg2L2t2
bS92bXgvdGR4LmMNCkBAIC0xMTIsNyArMTEyLDcgQEAgc3RhdGljIGludCBfX2luaXQgX190ZHhf
YnJpbmd1cCh2b2lkKQ0KICAgICAgICAgKi8NCiAgICAgICAgcmV0dXJuIDA7DQogZ2V0X3N5c2lu
Zm9fZXJyOg0KLSAgICAgICBfX2RvX3RkeF9jbGVhbnVwKCk7DQorICAgICAgIF9fdGR4X2NsZWFu
dXAoKTsNCiB0ZHhfYnJpbmd1cF9lcnI6DQogICAgICAgIGt2bV9kaXNhYmxlX3ZpcnR1YWxpemF0
aW9uKCk7DQogICAgICAgIHJldHVybiByOw0K

