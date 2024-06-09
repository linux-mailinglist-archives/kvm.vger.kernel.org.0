Return-Path: <kvm+bounces-19145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41AC69018A1
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 01:26:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A3ED3B20B58
	for <lists+kvm@lfdr.de>; Sun,  9 Jun 2024 23:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A67055466B;
	Sun,  9 Jun 2024 23:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KBc6ZFwd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA831F932;
	Sun,  9 Jun 2024 23:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717975561; cv=fail; b=UdR/fDMO5vhDRTyeaJ7Pcrl/v5Ew9LHytlRwp1dpY7cauY315eKE/b0RKgXj6bRHrUWlzwrENNlRboV/4fnxM96xwUkBqBysIED/TZReQ1AX8WtjgK6jkppNsTmH7ISNDhDsmdi4j99xKghukZOcD9IJ3rPeGw3uETmgSYEF8NI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717975561; c=relaxed/simple;
	bh=WAEXXRhxMGO5d+ZbZ2gbyaCrU8J4pU+/OnihM4v+9r8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Rm9RCX+VHCpFaviayFZpJBOhjqik9dwuAKcPs2I5XOkQFgmUJ6p27zdqjDKbgtXyHHES+40y7mZnZze2E8JUY5PD+PrA2O9pP7BRg9ZwuqopCFEVMFnhIBUPBPqH70I8lDzdM0cTtXRu4vpQw38tcYn1Ed8rmV5MOPO2V8QxRU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KBc6ZFwd; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717975560; x=1749511560;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WAEXXRhxMGO5d+ZbZ2gbyaCrU8J4pU+/OnihM4v+9r8=;
  b=KBc6ZFwdFjYN6QcxssZGTvHhRusdbMtwTiC//CVGY86cQAVp1N+KrbHZ
   K62/cvNOG8POpZ3w2pJxeY5M74P9ETw02muJlTLtdouueYim113fy092K
   Em51+NRREkM787YzW3IWw8LZixcbO7O99B09/C7dFqITu/zY9s0WohDzY
   86pGJQFegt96SIDpMsYTg+UJYPgGnRFe+TPXYKbSS/TtpePZBQA5ZfFhM
   ltgcmSFy+xe4gex3zwdIoZMeSx6K0eoklKRyJ7UMqkltRKC+lBeMdc5lS
   4K+L8opc3oUjabO+J9+SL0W7wj2Y8ykqXxt+BsouvwYqPprnOm6BvvMZg
   Q==;
X-CSE-ConnectionGUID: 4kEgrNIMT1Grigb8fdMFMQ==
X-CSE-MsgGUID: YYymcDBpRt6BMHOJvp+Jiw==
X-IronPort-AV: E=McAfee;i="6600,9927,11098"; a="25734264"
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="25734264"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2024 16:26:00 -0700
X-CSE-ConnectionGUID: RUdxAmO7QMye4WgyuU8p/Q==
X-CSE-MsgGUID: SiWI6FfdSOyJfzp4twgW5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="43451544"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jun 2024 16:25:59 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 9 Jun 2024 16:25:59 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 9 Jun 2024 16:25:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 9 Jun 2024 16:25:59 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 9 Jun 2024 16:25:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUKXU9if6L9CqfMf7v0P/uvKOs81p6OZ3J5ocDlFh9562QJb8QwASbVyqhPIGMjmHzaIqUOGu5K/0hUrt3MGbkItwLI7XdJEbnl10OXjbplg2Atj9t82yVsIi2t4snLnN7NPl6T1RHP/a5IW1p2nBgpjAb+ft26bKhWRLRsenSLYX7oT9kowyM8hl+yYb8cHx5lfGDx2e/XSaMuCVUdKsdpK5gGpGAZCikD4qeBYCKSWIiyU1JZeZoMHd8Ca6KrLeNL/07fPHZ1syNqeCsVyR9t7xjfikJd/DG87KrmYuZCJTccnaHWKLDdcdv/P24X1Ckgz8vYsC+cAVqEalozyLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WAEXXRhxMGO5d+ZbZ2gbyaCrU8J4pU+/OnihM4v+9r8=;
 b=lA92hSVASb2J+OKekRJo0fLVEFPRUIHWccyWGmrIsHGkaKTPCRq0O84591uyWZhZ9sHZucRj3CuAY6M41PNA/rbpCBZU1dPUdlxQfpQhKvCh4CUV7JLadan0963255HBLU9R76EscUotEhNxQtWtPeVgGsJ3Bw1NsXmV4Inja+J/9vzfhTmPoaI0MWWUdISPReViZMCsMpYSJw2Du1u9tjG0jKK6q6KKrwuRrtdpJMpLJoEBBLTEju4lPV+I0IkuaZI8wh/m2J1Z7womVljeCdorunPkL5DFd6Ad8Nul/rgoSbQ4/aVVDH1cO29Zs0Hdobi+z4s0Cp6Rw5KbFj/G1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB4840.namprd11.prod.outlook.com (2603:10b6:510:43::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Sun, 9 Jun
 2024 23:25:57 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7633.021; Sun, 9 Jun 2024
 23:25:56 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com"
	<dmatlack@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v2 06/15] KVM: x86/mmu: Support GFN direct mask
Thread-Topic: [PATCH v2 06/15] KVM: x86/mmu: Support GFN direct mask
Thread-Index: AQHastVu8k/3LnCT00Gh+DIw8MCP5LG7+4QAgACyz4CAAPLTgIACge+A
Date: Sun, 9 Jun 2024 23:25:56 +0000
Message-ID: <38b1eb36f1cc0514221251cc8ede35ad173fe77d.camel@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
	 <20240530210714.364118-7-rick.p.edgecombe@intel.com>
	 <CABgObfZuv45Bphz=VLCO4AF=W+iQbmMbNVk4Q0CAsVd+sqfJLw@mail.gmail.com>
	 <9423e6b83523c0a3828a88f38ffc3275a08e11dd.camel@intel.com>
	 <CABgObfbGeMoKKEMwY6108Z5UT1y=NzRhg-oBC-jpEpugD5_=Mg@mail.gmail.com>
In-Reply-To: <CABgObfbGeMoKKEMwY6108Z5UT1y=NzRhg-oBC-jpEpugD5_=Mg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB4840:EE_
x-ms-office365-filtering-correlation-id: bc580dfa-c8d4-4ba7-2ae5-08dc88db83ac
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?a0VBUmZHOHlpYnhvcmk4WUg4aW56QUsxdGVSQ1ZCR2FGelJ4NnY2ZXY4d0xm?=
 =?utf-8?B?MHNTMndIaEc2cWZBS2I4NGltajQ5MmtqRXByakFyK0dLYk5adkc1K3d1UG9h?=
 =?utf-8?B?Y0MxS2R6bVEzRzd2ejZVRjdWR2U5MVVwN1J3Z0ppaE10NzYzQjZkN0s1amdy?=
 =?utf-8?B?UUJRR1dhVW1zTVh6Y0NzUGgwZ0M2eGVjNS9RcWsxSWh4Y0ZQWTRGVVF1eCtw?=
 =?utf-8?B?UVpKYkZaVnB3RlhLNXpRWm1JVmlCMlJ1bm5NZ3RiU3NpUkRmVHJBU3IxVy9R?=
 =?utf-8?B?RU54YzZ6WWduOEhRL3k3YVhmM1BDUG8zbnhSSWM5b09rc2kxdS9HdjV6bzFt?=
 =?utf-8?B?RVVLQVkwY243QmFKRjZjd3JOM24zM0RNS2R4QUNPdjFKazJvd2RiMG5waFRF?=
 =?utf-8?B?dGtDQVVJOSt1TllQdzJDS21NbXdWR3E0U3J5U2dQNzkyVnI5Q0xNR3E4K0tT?=
 =?utf-8?B?OHc1dm9tV3lmOEw1eWlHNE83WHQ1ZG4xM2NiV3dBdEd4Q3BXK3E1ckpvU2Nu?=
 =?utf-8?B?NEE1Sy96Tkg5Sm4vN3VFZ2gwcnBtSk1PRjlyT2I5VkVDL1FoVzVzSDNFWTRy?=
 =?utf-8?B?VWxEWCtyWUdtTllXSVhnUnRYbmR2UzRXUkFKckZITkNoNkZRSDVMVGlJUkpZ?=
 =?utf-8?B?Y05HWXpPVFNZZEVoSm10UHFnV3NuUHdqdER1Um1WMzVaNnZKQ2pjOW1xUXdR?=
 =?utf-8?B?Ym9GN3REQmhBM0FsMlY0YjFXL2hSZExSaDNVcm9TMEZiWHNueGVMMEJnRVFp?=
 =?utf-8?B?TGxuOGpNU0doS09zR3A1WTR3OHZHV3VWWldFR0hjNXJXbjJ3TENncUMrVlhJ?=
 =?utf-8?B?Mnoyc28vWnhabk4zaWJ6T3FrK1VGMTZSSXcrb2kzZWhjNU1obEhvUXJ6RGxx?=
 =?utf-8?B?MjVjTFZoU2xLTEk4azhWZHJyUjNDaTE2dnhTb2NmSHMzOERucWFWL3ZlMHlW?=
 =?utf-8?B?RmZHc2FDQVpVT0kwRzN2cnlhb2kxd0p6NCtWK2VsTzlVcXlsWEhaclJZN0t6?=
 =?utf-8?B?bzFrZU93MmFLSmdyT29wMGFxdzA5eXpLWGVUNlZVWi9waGNtTDl6VnYyaGdG?=
 =?utf-8?B?TDUrMGhKMTExUlJjVUlNNlVPN2Y4SlF6aDY5c3l5RUJDVTFieWFZODJjcHVm?=
 =?utf-8?B?S2ZObXlkekVrZ0YvYjVtaUNPVVlaY2x2MS9kcnF0WFZXSjZJZXhiOG5LRlE5?=
 =?utf-8?B?U0M4bFZ6ZFlkaEozeVdDMVlKanRNaVNDTDBySW9LMVNyc1lFTlJmcUlEZGJL?=
 =?utf-8?B?STRLMkE2amwwYTZ6WnQzSFBlZ2tGbnlkS2ttbG9mZUErZk5GZ0ZqQTBLcWh6?=
 =?utf-8?B?UE9CYk9sZ2pnMUZjSnRoYTRrZ0RlSXk5UkdweUlWREVhTXF4RGR0YjRtTWlO?=
 =?utf-8?B?R3IrN3NQb1NRRThDMi9JSHBZcUVsTjlvdGZ3Qnlsa2NWNHdoMFMrNWNjcEtL?=
 =?utf-8?B?RlNML1IvdEVYOTl0UXJMdHFRY21VRkZQMjN2VEZtOWtOWTNXSU5WSTdaZlZL?=
 =?utf-8?B?aVRDNE5SNWp1THpLOFVnRG1WQVBpRkhyNU9hQ2ZtRU5ZQmVRMzJEbTQ3UkM4?=
 =?utf-8?B?YitJUmFIVE03OGp6MHlqQkZ2dTBOZ0ljbFlkR2lUQzJ4OWFWWEpCME1uU3o2?=
 =?utf-8?B?TkltenFDYU5tYlI4ZVluZEk3NHlCQWNKL1h1KzlHeHd6UGFGb0JuMWx2Z1Vn?=
 =?utf-8?B?eld0cEVZWHVnMXc0RkxnOFR1RlJlSVNlREx4NjZKZEp3VVU0ZW0xZGxEK3Iv?=
 =?utf-8?B?NjZMVzFwOVRqRWdKYjJocW5vQ1JKRjJ3bGZzQTN1U3FiVHo3dGY5bzIxT2E5?=
 =?utf-8?Q?80J6H6aebJYcMGMUJNAYjZfE4aQ+cj/2bkQt8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L1F3QUM2bHlkMTlzMHU4bGp3a1VCaFZpamtoRmZTZFd4TkFaZlJoNFFQUjZs?=
 =?utf-8?B?cEFQb2NKbnVWVGMzaDh5RnZJV0Vuak10enR0NFRJakR5QXJ5M3BjK0xwVmVk?=
 =?utf-8?B?aDlmckZsMzc5VnV2dDFDZlRNVzZDc0hvcFd6NjdwN2xYOW9mYWtud3VFVFRu?=
 =?utf-8?B?dlRCaHh2ai9GR1lFZVdKcXRWV2FUSkcxQ3h5VHovNWRaeE9FWngrNnhLZ084?=
 =?utf-8?B?V08yTFlnTVg2SldNSFJJQTYyZXFqS2xYQXBhdE9UNC9qWk92VW1tRmt1bXFE?=
 =?utf-8?B?YWdtMUhIUzRXanVISzFEOTRkZG9tUDZNaXVFakI0U0FPVDcvaU42Zkk2Q0Fx?=
 =?utf-8?B?amcyZkNEd2dzZEZVVzVNdTJqYlE5VlhvbUpmYTBjMVhKaHhIazdxeTc1Kyt2?=
 =?utf-8?B?MnQza0Fxc2FyR1JMN09abHQrTHNaVnV2dUNlMTF6S1k5NHd0QlFqRGU5U2ZH?=
 =?utf-8?B?VTlCamkrNnZWenBqbkRMTmpacitYVVZZaWRyWnZWUTZQZzZ2dU9MQ3IrS09u?=
 =?utf-8?B?NXdMaEE2dnA5czdXK3RpbjVRWnZkWTNGRFhnR29oTlhXVkhKcEJxOWFZekNr?=
 =?utf-8?B?d0k4SU1taEIxcGc1RmV0dDhOTFRsSzFWT1pEUjBmZG9pM1ZicDNYYjMzRkxv?=
 =?utf-8?B?OWY3M0x5ZThCdkc2ZDNIeTQ0clg2Y2hzY0RRV2FaTzd6NHhUNGkrWUdSWGlo?=
 =?utf-8?B?eFMyU0hjd2FyUlQ2Yi9VRisvOUVwWitXUFcwL1hUOWFHcVpXeTYyOFV5NTE0?=
 =?utf-8?B?YWYyU0pmeS8xKzYveXhSeUExT3F5UmF5VzFQRXl4aHlnOU1IU3B6SUpQY3dn?=
 =?utf-8?B?K3pJSkdiUmpPVXlFV1lTd1QrZDJKQzNLalQvRUl3c0VqK0doVlhRa08vWjlW?=
 =?utf-8?B?azIzdVQ3Z1MxVDBDYkRHZGMvK25WejZLL0NSY20zTHVwWHJ5QnBqTEpjWnhQ?=
 =?utf-8?B?QnFrbUVnbWhVeHVYa094Ty9WdWlxc2haSjIwTk5GT3JkeHlKWHhpUlYzZXNX?=
 =?utf-8?B?aUJqUGdHa3pqQWhaMXVHbjM3ejlzdlR0a3JXWlFzT3dKcHJjU3JtZ29jMTln?=
 =?utf-8?B?N0xiZnAzYUE3SDlSZHRMNDYvSjlNbjB4MXFWTWtibzdSclZEVm1JbjJ3d2Z2?=
 =?utf-8?B?QU5EeW1DaWNWTXlZbzZEZzF3NzNQbDhRVWZkK1BzQ1F0NjNNOGdjRXhzZVpK?=
 =?utf-8?B?SDM4UUlpZTlXM0NBdmljOGVjZnZOeXFSbVpJYzBGUVdYakEzQ0FkTjVQaUY3?=
 =?utf-8?B?aUV5V09wM2VjWlJMOHVkeDk3Z09ZVy9mNmI1OTdHb1ljbnk3MkkyWXNVRGxI?=
 =?utf-8?B?UDVYSHQzQWlnMHhERXh2ajNEenZXYTJ1Y0VhOUtYWmVXWTNmUXdST2Q3aTJ6?=
 =?utf-8?B?cUxMQUcvcGdjNkZKVlF4aUh2dXhvek9wVHlGQWl0UDJJS0trSWMyRmhtVFAr?=
 =?utf-8?B?anJiNnljYmV1LzlQYS9HbC8wWE5MQ1BFUWFSQ0pRaDI1UTZpSWQ3QlF2enE4?=
 =?utf-8?B?L3Budk5hZ1hRdFVmTkx1Yi9EUzNIV2x3M3k5TnJJbm5UZWF1dlUrOTNzMmpM?=
 =?utf-8?B?ZnBYejlFU2hMS2ZjcGNhM2k5OUVtUUxYVE1ucnYya3FWblVFdHE0OTRQakhV?=
 =?utf-8?B?cGlnWHcrZ011bENjNEIxMFhWSnhTM0xVWmJ1WmJJZVU3S2M1VmQvTVNja2Rq?=
 =?utf-8?B?NmtURnZQaWNxeXQwNjVoMVJoRnF3QkhhMGVUOGZJTUFLVlhabUFVaFczWERU?=
 =?utf-8?B?Y1BWTXppRkRGTElMM1B1QXAzZzROWDdhV0J6VDcwWFo0alBBZi9wQ0ZxUzdQ?=
 =?utf-8?B?S0Nha294MEc0cWpCeCtmTi9CNmpoeXFmdHcrVTU2MktoaEhXTDM3bmtkZlFH?=
 =?utf-8?B?VitVU3JmbW9zbWRsNWxnYjg5L3NrVk1tTWxyWXkvbWlTVjZEVHNUQ1MxVFY1?=
 =?utf-8?B?aS9RbUNFOTd2UEtaaWJZV1BQcEphYlNMVUJPV3BpSkV5ZVEyMnR2OTAwdlVz?=
 =?utf-8?B?UjFaSU96MW9kK2FFYkdZckk0emFybElzSElEMmZaYXpTTFE3Q0MyMGVnUHNP?=
 =?utf-8?B?SWdlSkFURGRoWFFLUmh0bTZEK0Y1REl4K2J1dm1OY1Z1SUMvbDljZ0ZERyt2?=
 =?utf-8?B?L0ZkZE1pbmdDVmVlOUNLR09FM1pjK1BhVVhVRVFKUVYyVExBZXRhWEJwcHlk?=
 =?utf-8?B?R2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE57635AB03A35419AFD2D3CC571510D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc580dfa-c8d4-4ba7-2ae5-08dc88db83ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2024 23:25:56.7449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ep4pmoJceA3G1SRYBP4104SdyRsvfqW4kKb6PQcryir/gYgM2Xqhn5Dh4fy9SbV18zQZ8uRARZCSmYO8BsCFvS3EKFmz9lzKudCjVrVG/Tk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4840
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI0LTA2LTA4IGF0IDExOjA4ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiA+IFRoZSBkb3duc2lkZSB3b3VsZCBiZSB3aWRlciBkaXN0cmlidXRpb24gb2YgdGhlIGNvbmNl
cm5zIGZvciBkZWFsaW5nIHdpdGgNCj4gPiBtdWx0aXBsZSBhbGlhc2VzIGZvciBhIEdGTi4gQ3Vy
cmVudGx5LCB0aGUgYmVoYXZpb3IgdG8gaGF2ZSBtdWx0aXBsZSBhbGlhc2VzDQo+ID4gaXMNCj4g
PiBpbXBsZW1lbnRlZCBpbiBjb3JlIE1NVSBjb2RlLiBXaGlsZSBpdCdzIGZpbmUgdG8gcG9sbHV0
ZSB0ZHguYyB3aXRoIFREWA0KPiA+IHNwZWNpZmljDQo+ID4ga25vd2xlZGdlIG9mIGNvdXJzZSwg
cmVtb3ZpbmcgdGhlIGhhbmRsaW5nIG9mIHRoaXMgY29ybmVyIGZyb20gbW11LmMgbWlnaHQNCj4g
PiBtYWtlDQo+ID4gaXQgbGVzcyB1bmRlcnN0YW5kYWJsZSBmb3Igbm9uLXRkeCByZWFkZXJzIHdo
byBhcmUgd29ya2luZyBpbiBNTVUgY29kZS4NCj4gPiBCYXNpY2FsbHksIGlmIGEgY29uY2VwdCBm
aXRzIGludG8gc29tZSBub24tVERYIGFic3RyYWN0aW9uIGxpa2UgdGhpcywgaGF2aW5nDQo+ID4g
aXQNCj4gPiBpbiBjb3JlIGNvZGUgc2VlbXMgdGhlIGJldHRlciBkZWZhdWx0IHRvIG1lLg0KPiAN
Cj4gSSBhbSBub3Qgc3VyZSB3aHkgaXQncyBhbiBNTVUgY29uY2VwdCB0aGF0ICJpZiB5b3Ugb2Zm
c2V0IHRoZSBzaGFyZWQNCj4gbWFwcGluZ3MgeW91IGNhbm5vdCBpbXBsZW1lbnQgZmx1c2hfcmVt
b3RlX3RsYnNfcmFuZ2UiLiBJdCBzZWVtcyBtb3JlDQo+IGxpa2UsIHlvdSBuZWVkIHRvIGtub3cg
d2hhdCB5b3UncmUgZG9pbmc/DQo+IA0KPiBSaWdodCBub3cgaXQgbWFrZXMgbm8gZGlmZmVyZW5j
ZSBiZWNhdXNlIHlvdSBkb24ndCBzZXQgdGhlIGNhbGxiYWNrOw0KPiBidXQgaWYgeW91IGV2ZXIg
d2FudGVkIHRvIGltcGxlbWVudCBmbHVzaF9yZW1vdGVfdGxic19yYW5nZSBhcyBhbg0KPiBvcHRp
bWl6YXRpb24geW91J2QgaGF2ZSB0byByZW1vdmUgdGhlIGNvbmRpdGlvbiBmcm9tIHRoZSAiaWYi
LiBTbyBpdCdzDQo+IGJldHRlciBub3QgdG8gaGF2ZSBpdCBpbiB0aGUgZmlyc3QgcGxhY2UuDQoN
ClllYSB0aGF0J3MgdHJ1ZS4NCg0KPiANCj4gUGVyaGFwcyBhZGQgYSBjb21tZW50IGluc3RlYWQs
IGxpa2U6DQo+IA0KPiDCoMKgwqDCoCBpZiAoIWt2bV94ODZfb3BzLmZsdXNoX3JlbW90ZV90bGJz
X3JhbmdlKQ0KPiDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRU9QTk9UU1VQUDsNCj4gDQo+ICvC
oMKgwqAgLyoNCj4gK8KgwqDCoMKgICogSWYgYXBwbGljYWJsZSwgdGhlIGNhbGxiYWNrIHNob3Vs
ZCBmbHVzaCBHRk5zIGJvdGggd2l0aCBhbmQgd2l0aG91dA0KPiArwqDCoMKgwqAgKiB0aGUgZGly
ZWN0LW1hcHBpbmcgYml0cy4NCj4gK8KgwqDCoMKgICovDQo+IMKgwqDCoMKgIHJldHVybiBzdGF0
aWNfY2FsbChrdm1feDg2X2ZsdXNoX3JlbW90ZV90bGJzX3JhbmdlKShrdm0sIGdmbiwgbnJfcGFn
ZXMpOw0KDQpPaywgd29ya3MgZm9yIG1lLg0K

