Return-Path: <kvm+bounces-13274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1004D893A41
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 12:41:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90CEA1F220FD
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 10:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0460A1F600;
	Mon,  1 Apr 2024 10:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G+pnFm9N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE926125AB;
	Mon,  1 Apr 2024 10:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711968093; cv=fail; b=YwJyN7eI9NQFY0DtBAR99KzYIBDliHYL5QMx+TkQiLv8gGnQ3g2uJbgqQjF1CE6EbzE059p5SYsRQpd5jkKG1a/EML8vH7Ldh3FADojW02LlyXoipHATQIIBEoKH/dRZboHcTIPHltrKYGeslZ/sRUQMysWkFWF8LriieHv9UBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711968093; c=relaxed/simple;
	bh=CDobd8B9cYhM9/5KBPlqPJvr+QOjud75qk4TmCZjCxQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ohvSHfgUuZ0yUZOyXpRXbzqTza46sRbHS28YZIMcW8lthNrweoj7qnsnm1oTFleSkh6QVJbt85iwawg7A1YNjsOzkLTn3NuccjYh2oFsEKHNTQwnnqEyXihWbXm2zGR7dpqemF9ZD0nFUkqZrezsz0mRzrMQ612WrUxfDt2xftQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G+pnFm9N; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711968091; x=1743504091;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CDobd8B9cYhM9/5KBPlqPJvr+QOjud75qk4TmCZjCxQ=;
  b=G+pnFm9NKZ2mJjC4KJdwsb6uRKP+Z7w1iqmoXEHoz8jV6M+XG7gHBV3z
   FagSmJXMn2d3bmzJau33Vw0qj7A6cZ28RnZ76/Qe1R4ej2xBrMPe90R4r
   8BUVTfPNB8JMa/uLWfUe4BTf6VnC6V85S8cnbNL3xyz2gNfWI/I/WhA18
   rVAzsyg1OaqlgKM0JPX6wdLNa2QdQPBe/n90j5993RHT3BpwuOxFI/Bk5
   e5lfHrFXYgbXD5PgZPcKqbMi0BZRylHEK9SoBt+3+WxxU6EueiddR5PRn
   vJ2YjQ4o/eg7E+YL9UTJc9/WQPMjPm2V/rx8F9bQszDIG9MxiTauxzrNb
   w==;
X-CSE-ConnectionGUID: CyX0UoPxSIqyRmAr5pQNow==
X-CSE-MsgGUID: kTmFgCceR8yGKyubdGJb0A==
X-IronPort-AV: E=McAfee;i="6600,9927,11030"; a="10875659"
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="10875659"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 03:41:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="22171727"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Apr 2024 03:41:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 1 Apr 2024 03:41:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 1 Apr 2024 03:41:25 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 1 Apr 2024 03:41:25 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 1 Apr 2024 03:41:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSsPlBsZ4CZDdpxNP3Te2HlqyPyEhuY9aaSe5l7FpEmKskOV+kdUiLCLJkTtJGd7xFY6S2NwaL0W8vZc5nvp3+sXQiNfClz8Nk1y0lfPSofp3nz9h8cOmPifYQMVK/DQbIfja7xl1ydwp0NCGXXjo4FjTRDY/ejCRfy8hqjQyFRZEvn6tWzftga43YaB6BOWWqznIz+Venmgjn6W28AOJ/Cx9o7j/l4gKvn0m2ITTbqmAKn72lG6ZTM89UuAbOpyAo2lB9xn4Qui4QYsKOOkjCjrobFmLHzBGWbWfEXgvuO67ntqUWxM9M9PsMQuVIWlrigrG8XOkMnBqMrcOkrtDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDobd8B9cYhM9/5KBPlqPJvr+QOjud75qk4TmCZjCxQ=;
 b=eGMGUG8W8k133RfEZzlXOxmWAVuEQFHyumVVaHCWHbrK14otRR2mIIw0gWceY+ku5XY8IYUJUKo5avtgklZcWC6NRnQTa2hR3hK9AIMZHEm5tYN5c3ENhZfNoCUkqlet8QTUXjtdsh99mYnI9f9AgP3O5/E8ntS3VLbGkWFPrmSfjt1uY7zO64KUDsxi8eSFEpM87iZsp5I1xTrFt4IGgK8APJtwe28QV6/aQRdhQYUjmupXXSljnRcJwmW05rlx3fVwzj5ISBz6NEjiGAIdglImU3pUcicO51ICXxV9BaZ6sq8YXWd07LL6mB2FMO2AdujV1zcN8crX6BfDCPO7eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7747.namprd11.prod.outlook.com (2603:10b6:930:91::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.39; Mon, 1 Apr
 2024 10:41:20 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7452.019; Mon, 1 Apr 2024
 10:41:20 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yuan, Hang" <hang.yuan@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
Thread-Topic: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
Thread-Index: AQHaaI2+d2CEUIDjsUCuhszN5EFGpLFJbQMAgAL1FoCAADFDAIAAPsEAgABfB4CAAJ2wAIAFolCA
Date: Mon, 1 Apr 2024 10:41:20 +0000
Message-ID: <8feaba8f8ef249950b629f3a8300ddfb4fbcf11c.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
	 <a0627c0f-5c2d-4403-807f-fc800b43fd3b@intel.com>
	 <20240327225337.GF2444378@ls.amr.corp.intel.com>
	 <4d925a79-d3cf-4555-9c00-209be445310d@intel.com>
	 <20240328053432.GO2444378@ls.amr.corp.intel.com>
	 <65a1a35e0a3b9a6f0a123e50ec9ddb755f70da52.camel@intel.com>
	 <20240328203902.GP2444378@ls.amr.corp.intel.com>
In-Reply-To: <20240328203902.GP2444378@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB7747:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +ZudFBF0DSL5L8MYRI2ItNr/nyiHZd6t/h9rgX33CoA0Ya3NRLicM6c3kMJay31zrl9OoZWwq5rH/8zgaJjQfVxnrSe/aWw82wZ1xFAfPbS94ULgHekUjA/JsqM9vUpmh8hLJIBfSrEQnPPHQuXQslMmJyg4hzfOZLIupYjpUnrs+Y9IqIfP62KQFB30KUjeeS0p+enf8RuTZxawbpmQqL6qGIthL2VWmMGskUQ3qhN4QNg86Qe69io710Yt5TRSTbMqlmGmAz58kN2fRz0kt8TltKi2IO90o2UbjPZ4dBh7KffwyEXfVF2eGzINRJrZ60ki+u8bwJzCq8CsbtWS2oNuc4EG/1gNkvepFRzd8IyO4+N46oF5gRPoAJmdso5IeVgifg2NQ1Kev2SQWbcrsoBbBBqO0dj8fdMSyl5IJgYmn0mVAGWwUqKH3lscTodP2vs7o1Tmj36zCPV5YdoJdJh06SsHsSorWJxbMnssSlzb+ejnWV4CCbmvObg/+2YWe7qUe8HSySiVWEhPjMwrN6q+UlW83dORTbXDCifpHu+gNwraIRpKIfI2tBIDRqavz6s3/LCfjzf22jOmuWowKHFxw2mFM/+sS+Vjb3Nwu48+3XQOKshj/mtcDead4ueosCQnRmtCSbSgOyVDDxgwWCngck5SEDtB0KRLeR6jbhc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K05uaXFQY0pLbU1WcndhMTFHODIxTy9SaUk5WUhWbTF3Z212a2dhdlg4MFlZ?=
 =?utf-8?B?d1oyekt1VC9nQWpkTWV5eCtWNHNCZkU3UldOVFJDa2VjMG5EcmpiN0pGM1lm?=
 =?utf-8?B?cnNBM1Fodjl1RERWQlBwRVlkclFIaFFPQVZkSnVKUzk2L1I4TVNLbnlpSlNT?=
 =?utf-8?B?R1JDVno3SnNrWEp1UWxGejBqL2NPVlQvNyt4S2d1M2Fvb25NTjQ0MkZJSWFO?=
 =?utf-8?B?M3lGdjZQNHdzaVNWckRQVWFxbTBQdTR4WTRLQmppQnFTbDBpZitEN0UvTGVI?=
 =?utf-8?B?MzdEWnJra0prc0Y3ZVg3T2VYR3hwclh1TWJXQTVhV1BuSEdHeXR2QjRwUENO?=
 =?utf-8?B?N244RVJkSUNTWEphMVlIQzZoY3QzY3VzVGE1RTB3NmtqNmVKNHYzQ0xvV1VR?=
 =?utf-8?B?NU5kTWlGTG5zWDkzNzl0UDArUGpVL3dCd05zdGh6d2lOTXBrZ0N1ckE3ZUF0?=
 =?utf-8?B?QXlxVjIzcjdZOWhrY3ZhcmU1NzkrRFphQWhJYXdTSVZCN2RtVkl6bHhSZXM0?=
 =?utf-8?B?S3kvU3cySUFDRnRKcmhqZ2gzT0pvRk1YcFdNZ0FRVnpaNUZha3FiZFdidlpY?=
 =?utf-8?B?R1FUcnJ3clBWUHBEM2hqcU93RS9jdUZ2aWdYUWE3a2gwRzFjMG9WeUdhcGpC?=
 =?utf-8?B?STlPaTFNdS82NE9wZWJZZnhaV0RhRG5wZHU3b0hSOHNrTmYzYTRoblhmdWxD?=
 =?utf-8?B?UzdCU1NlemxzV3QxUC9tQVlZeTVYd1FQRnVWTkdUYU05YThLU3ExVTVrSjdt?=
 =?utf-8?B?QWxyL2xxUy81VnNpKzE0WnYxaDhCdCs1ckhXYWdVMTNnMS9kbmk3Qm5haHFX?=
 =?utf-8?B?V0Z5NFc1azZQbmdCbDI4azFHU0Z0MVUrN0UwSTNGeG0zLy9jZTh6aEo1dkh6?=
 =?utf-8?B?WHNCYmdYNW9KRmI5SHZxS2RjajUvZXIzUTRqd3FEdXlHV0xhU3pYbnZiN2R6?=
 =?utf-8?B?Y0xLV3pocTRJb1Vtem1wUUczTXV1QUVRZWZlT294QitOVGxzZzBFN2F3KzZ2?=
 =?utf-8?B?a1ZTZVBWM0djRlBwWE44ZmZ3ODdHVWNVUUlydkx3TWIvVjdaTi9WNmpqd0RR?=
 =?utf-8?B?cmpXYkVxaUJTMGpEM25TM0Z1NFdpaSt5L0MycFlDaHRmVFh3Ni9NSURwR1g3?=
 =?utf-8?B?bndoMU1aaEZnTFd3SlpXUTNnVEdOYlBpdG5RdWdRZTM5aUpyYml0WWw3WU0x?=
 =?utf-8?B?QUpPTGNYRGdCSk9TeVBqKzFDSXVoMjF3K3BaOXVmcDRHVWpEbHRHMStIRHdS?=
 =?utf-8?B?dklTeUFPM1Q4Y3dtRW1yKys2TEFVWHBIeWR1VnJuSXFZcWpqTUFaa0xmNzdK?=
 =?utf-8?B?Tkprc0VjZlNtUWgvblJ5Y09ZVExITGtwUElEV1liN0hPNjhMRGlCclZLcFd0?=
 =?utf-8?B?bEh6N3c0RUN5dDh3bFZPQ2crTG84cTZLTDZ6VTUvZ2FrMmYvSGh1RC9hTVRX?=
 =?utf-8?B?aDFtWUdBZERnNDdQOS9nZnhWa1FLRHprRldRdG9QNGRobS9aTm5GTkRjRjEx?=
 =?utf-8?B?ODFYSjl6b2dMT05hdWw3b1ZEdWhyMTNCOGg2Yk9iSWFoT0F2TE5YNXZ3UFJL?=
 =?utf-8?B?SDNxZGY2bEtzamtYbWp1a3J3T09UTlV3NFVIWERMRitnckZuQUE4aVkrT2ZH?=
 =?utf-8?B?WXg2YkFFL1pNVXI4MjgrUWhrdWh5NTBBSnVMRlk0U1hyRWtVQ2tBeU9XeUFB?=
 =?utf-8?B?NDl2eGpNZXJkVVB2Sk5xUEtUd3NjRk4xYXNQWEVYVXlYbnlYQk5KdHZRelRq?=
 =?utf-8?B?TCt2Tk1DY1IxdVNTck53a2gvRDNTUHBkaStraVVzM0Z6b2IwUXNVbW9OWUR3?=
 =?utf-8?B?WGxCcXdiRi9Ud2JsNnVWUjNEbnBabjZ1VGpuWm9GY1FYVndEOFI5ZWxER3Ey?=
 =?utf-8?B?ZzRRNmgzNU5sM0VFNVZ1THBjdXNDaHllZEMwZEpWdTFXQ29RZGJxU3RnM3V2?=
 =?utf-8?B?YkxZejdIVm9vb2E1UXA5UFJLaDVtYXJXR3Rwa0VOR1J1VHd5ZFZLRHhDeUdJ?=
 =?utf-8?B?T0R6NHVJSHFhcXR5QWsvdWMvZmdZUlZEZ2NVRGx3Nkt0S3IwalE0a01wN1py?=
 =?utf-8?B?RDRPZjVqTkVEaGpxVWtXREwrZjBHelRIVDJZV3piK1NvSmtkYVp2YjdqTjl5?=
 =?utf-8?B?SEtmOU42TVZjNCtibnRLS01uWVdUSi9UQXJkcVJ5ZTRhRktPTXlhTG91MFM3?=
 =?utf-8?B?eHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C6B1BB3690D8241BF791A6253EAC101@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca88c0b3-3701-4188-42c2-08dc523844a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2024 10:41:20.2193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8fHTd1XbsXUCnDWDRYfG6F4Hzw2HaJsYdNgz5RijarBlYrrGpVPx8EKlxF6Q2Ti3cP1SG5LyrmN1Rx8XDNS0GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7747
X-OriginatorOrg: intel.com

DQpbLi4uXQ0KDQo+ID4gDQo+ID4gQW5kIHdoeSBkbyB5b3UgbmVlZCBhIHNwZWNpYWwgZnVuY3Rp
b24ganVzdCBmb3IgY29udHJvbCBwYWdlKHMpPw0KPiANCj4gV2UgY2FuIHJldmlzZSB0aGUgY29k
ZSB0byBoYXZlIGNvbW1vbiBmdW5jdGlvbiBmb3IgcmVjbGFpbWluZyBwYWdlLg0KDQpJIGludGVy
cHJldCB0aGlzIGFzIHlvdSB3aWxsIHJlbW92ZSB0ZHhfcmVjbGFpbV9jb250cm9sX3BhZ2UoKSwg
YW5kIGhhdmUgb25lDQpmdW5jdGlvbiB0byByZWNsYWltIF9BTExfIFREWCBwcml2YXRlIHBhZ2Vz
Lg0KDQo+IA0KPiANCj4gPiA+ID4gPiBIb3cgYWJvdXQgdGhpcz8NCj4gPiA+ID4gPiANCj4gPiA+
ID4gPiAvKg0KPiA+ID4gPiA+ICAgKiBXZSBuZWVkIHRocmVlIFNFQU1DQUxMcywgVERILk1ORy5W
UEZMVVNIRE9ORSgpLCBUREguUEhZTUVNLkNBQ0hFLldCKCksIGFuZA0KPiA+ID4gPiA+ICAgKiBU
REguTU5HLktFWS5GUkVFSUQoKSB0byBmcmVlIHRoZSBIS0lELg0KPiA+ID4gPiA+ICAgKiBPdGhl
ciB0aHJlYWRzIGNhbiByZW1vdmUgcGFnZXMgZnJvbSBURC4gIFdoZW4gdGhlIEhLSUQgaXMgYXNz
aWduZWQsIHdlIG5lZWQNCj4gPiA+ID4gPiAgICogdG8gdXNlIFRESC5NRU0uU0VQVC5SRU1PVkUo
KSBvciBUREguTUVNLlBBR0UuUkVNT1ZFKCkuDQo+ID4gPiA+ID4gICAqIFRESC5QSFlNRU0uUEFH
RS5SRUNMQUlNKCkgaXMgbmVlZGVkIHdoZW4gdGhlIEhLSUQgaXMgZnJlZS4gIEdldCBsb2NrIHRv
IG5vdA0KPiA+ID4gPiA+ICAgKiBwcmVzZW50IHRyYW5zaWVudCBzdGF0ZSBvZiBIS0lELg0KPiA+
ID4gPiA+ICAgKi8NCj4gPiA+ID4gDQo+ID4gPiA+IENvdWxkIHlvdSBlbGFib3JhdGUgd2h5IGl0
IGlzIHN0aWxsIHBvc3NpYmxlIHRvIGhhdmUgb3RoZXIgdGhyZWFkIHJlbW92aW5nDQo+ID4gPiA+
IHBhZ2VzIGZyb20gVEQ/DQo+ID4gPiA+IA0KPiA+ID4gPiBJIGFtIHByb2JhYmx5IG1pc3Npbmcg
c29tZXRoaW5nLCBidXQgdGhlIHRoaW5nIEkgZG9uJ3QgdW5kZXJzdGFuZCBpcyB3aHkNCj4gPiA+
ID4gdGhpcyBmdW5jdGlvbiBpcyB0cmlnZ2VyZWQgYnkgTU1VIHJlbGVhc2U/ICBBbGwgdGhlIHRo
aW5ncyBkb25lIGluIHRoaXMNCj4gPiA+ID4gZnVuY3Rpb24gZG9uJ3Qgc2VlbSB0byBiZSByZWxh
dGVkIHRvIE1NVSBhdCBhbGwuDQo+ID4gPiANCj4gPiA+IFRoZSBLVk0gcmVsZWFzZXMgRVBUIHBh
Z2VzIG9uIE1NVSBub3RpZmllciByZWxlYXNlLiAga3ZtX21tdV96YXBfYWxsKCkgZG9lcy4gSWYN
Cj4gPiA+IHdlIGZvbGxvdyB0aGF0IHdheSwga3ZtX21tdV96YXBfYWxsKCkgemFwcyBhbGwgdGhl
IFNlY3VyZS1FUFRzIGJ5DQo+ID4gPiBUREguTUVNLlNFUFQuUkVNT1ZFKCkgb3IgVERILk1FTS5Q
QUdFLlJFTU9WRSgpLiAgQmVjYXVzZQ0KPiA+ID4gVERILk1FTS57U0VQVCwgUEFHRX0uUkVNT1ZF
KCkgaXMgc2xvdywgd2UgY2FuIGZyZWUgSEtJRCBiZWZvcmUga3ZtX21tdV96YXBfYWxsKCkNCj4g
PiA+IHRvIHVzZSBUREguUEhZTUVNLlBBR0UuUkVDTEFJTSgpLg0KPiA+IA0KPiA+IENhbiB5b3Ug
ZWxhYm9yYXRlIHdoeSBUREguTUVNLntTRVBULFBBR0V9LlJFTU9WRSBpcyBzbG93ZXIgdGhhbg0K
PiA+IFRESC5QSFlNRU0uUEFHRS5SRUNMQUlNKCk/DQo+ID4gDQo+ID4gQW5kIGRvZXMgdGhlIGRp
ZmZlcmVuY2UgbWF0dGVyIGluIHByYWN0aWNlLCBpLmUuIGRpZCB5b3Ugc2VlIHVzaW5nIHRoZSBm
b3JtZXINCj4gPiBoYXZpbmcgbm90aWNlYWJsZSBwZXJmb3JtYW5jZSBkb3duZ3JhZGU/DQo+IA0K
PiBZZXMuIFdpdGggSEtJRCBhbGl2ZSwgd2UgaGF2ZSB0byBhc3N1bWUgdGhhdCB2Y3B1IGNhbiBy
dW4gc3RpbGwuIEl0IG1lYW5zIFRMQg0KPiBzaG9vdGRvd24uIFRoZSBkaWZmZXJlbmNlIGlzIDIg
ZXh0cmEgU0VBTUNBTEwgKyBJUEkgc3luY2hyb25pemF0aW9uIGZvciBlYWNoDQo+IGd1ZXN0IHBy
aXZhdGUgcGFnZS4gIElmIHRoZSBndWVzdCBoYXMgaHVuZHJlZHMgb2YgR0IsIHRoZSBkaWZmZXJl
bmNlIGNhbiBiZQ0KPiB0ZW5zIG9mIG1pbnV0ZXMuDQo+IA0KPiBXaXRoIEhLSUQgYWxpdmUsIHdl
IG5lZWQgdG8gYXNzdW1lIHZjcHUgaXMgYWxpdmUuDQo+IC0gVERILk1FTS5QQUdFLlJFTU9WRSgp
DQo+IC0gVERILlBIWU1FTS5QQUdFX1dCSU5WRCgpDQo+IC0gVExCIHNob290IGRvd24NCj4gICAt
IFRESC5NRU0uVFJBQ0soKQ0KPiAgIC0gSVBJIHRvIG90aGVyIHZjcHVzDQo+ICAgLSB3YWl0IGZv
ciBvdGhlciB2Y3B1IHRvIGV4aXQNCj4gDQo+IEFmdGVyIGZyZWVpbmcgSEtJRA0KPiAtIFRESC5Q
SFlNRU0uUEFHRS5SRUNMQUlNKCkNCj4gICBXZSBhbHJlYWR5IGZsdXNoZWQgVExCcyBhbmQgbWVt
b3J5IGNhY2hlLg0KPiA+ID4gPiANCg0KWy4uLl0NCg0KPiA+IA0KPiA+IEZpcnN0bHksIHdoYXQg
a2luZGEgcGVyZm9ybWFuY2UgZWZmaWNpZW5jeSBnYWluIGFyZSB3ZSB0YWxraW5nIGFib3V0Pw0K
PiANCj4gMiBleHRyYSBTRUFNQ0FMTCArIElQSSBzeW5jIGZvciBlYWNoIGd1ZXN0IHByaXZhdGUg
cGFnZS4gIElmIHRoZSBndWVzdCBtZW1vcnkNCj4gaXMgaHVuZHJlZHMgb2YgR0IsIHRoZSBkaWZm
ZXJlbmNlIGNhbiBiZSB0ZW5zIG9mIG1pbnV0ZXMuDQoNClsuLi5dDQoNCj4gDQo+IA0KPiA+IFdl
IGNhbm5vdCByZWFsbHkgdGVsbCB3aGV0aGVyIGl0IGNhbiBiZSBqdXN0aWZpZWQgdG8gdXNlIHR3
byBkaWZmZXJlbnQgbWV0aG9kcw0KPiA+IHRvIHRlYXIgZG93biBTRVBUIHBhZ2UgYmVjYXVzZSBv
ZiB0aGlzLg0KPiA+IA0KPiA+IEV2ZW4gaWYgaXQncyB3b3J0aCB0byBkbywgaXQgaXMgYW4gb3B0
aW1pemF0aW9uLCB3aGljaCBjYW4vc2hvdWxkIGJlIGRvbmUgbGF0ZXINCj4gPiBhZnRlciB5b3Ug
aGF2ZSBwdXQgYWxsIGJ1aWxkaW5nIGJsb2NrcyB0b2dldGhlci4NCj4gPiANCj4gPiBUaGF0IGJl
aW5nIHNhaWQsIHlvdSBhcmUgcHV0dGluZyB0b28gbWFueSBsb2dpYyBpbiB0aGlzIHBhdGNoLCBp
LmUuLCBpdCBqdXN0DQo+ID4gZG9lc24ndCBtYWtlIHNlbnNlIHRvIHJlbGVhc2UgVERYIGtleUlE
IGluIHRoZSBNTVUgY29kZSBwYXRoIGluIF90aGlzXyBwYXRjaC4NCj4gDQo+IEkgYWdyZWUgdGhh
dCB0aGlzIHBhdGNoIGlzIHRvbyBodWdlLCBhbmQgdGhhdCB3ZSBzaG91bGQgYnJlYWsgaXQgaW50
byBzbWFsbGVyDQo+IHBhdGNoZXMuDQoNCklNSE8gaXQncyBub3Qgb25seSBicmVha2luZyBpbnRv
IHNtYWxsZXIgcGllY2VzLCBidXQgYWxzbyB5b3UgYXJlIG1peGluZw0KcGVyZm9ybWFuY2Ugb3B0
aW1pemF0aW9uIGFuZCBlc3NlbnRpYWwgZnVuY3Rpb25hbGl0aWVzIHRvZ2V0aGVyLg0KDQpNb3Zp
bmcgcmVjbGFpbWluZyBURFggcHJpdmF0ZSBLZXlJRCB0byBNTVUgbm90aWZpZXIgKGluIG9yZGVy
IHRvIGhhdmUgYSBiZXR0ZXINCnBlcmZvcm1hbmNlIHdoZW4gc2h1dHRpbmcgZG93biBURFggZ3Vl
c3QpIGRlcGVuZHMgb24gYSBsb3QgU0VQVCBkZXRhaWxzIChob3cgdG8NCnJlY2xhaW0gcHJpdmF0
ZSBwYWdlLCBUTEIgZmx1c2ggZXRjKSwgd2hpY2ggaGF2ZW4ndCB5ZXQgYmVlbiBtZW50aW9uZWQg
YXQgYWxsLg0KDQpJdCdzIGhhcmQgdG8gcmV2aWV3IGNvZGUgbGlrZSB0aGlzLiDCoA0KDQpJIHRo
aW5rIGhlcmUgaW4gdGhpcyBwYXRjaCwgd2Ugc2hvdWxkIGp1c3QgcHV0IHJlY2xhaW1pbmcgVERY
IGtleUlEIHRvIHRoZQ0KIm5vcm1hbCIgcGxhY2UuICBBZnRlciB5b3UgaGF2ZSBkb25lIGFsbCBT
RVBUIChhbmQgcmVsYXRlZCkgcGF0Y2hlcywgeW91IGNhbg0KaGF2ZSBhIHBhdGNoIHRvIGltcHJv
dmUgdGhlIHBlcmZvcm1hbmNlOg0KDQoJS1ZNOiBURFg6IEltcHJvdmUgVERYIGd1ZXN0IHNodXRk
b3duIGxhdGVuY3kNCg0KVGhlbiB5b3UgcHV0IHlvdXIgcGVyZm9ybWFuY2UgZGF0YSB0aGVyZSwg
aS5lLiwgInRlbnMgb2YgbWludXRlcyBkaWZmZXJlbmNlIGZvcg0KVERYIGd1ZXN0IHdpdGggaHVu
ZHJlZHMgb2YgR0IgbWVtb3J5IiwgdG8ganVzdGlmeSB0aGF0IHBhdGNoLg0KDQo=

