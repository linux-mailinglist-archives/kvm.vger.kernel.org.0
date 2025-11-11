Return-Path: <kvm+bounces-62738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C5F0C4CA7B
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 10:28:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 930F14F8F5C
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 09:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F37922F1FEE;
	Tue, 11 Nov 2025 09:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NsdOV2Yf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1871F2F12AD;
	Tue, 11 Nov 2025 09:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762853021; cv=fail; b=XIHe5xttJbnNxrFJtLuhIWHg91uAHBZm4Jz0abzK7bzfp7zt8mZWxXCLzFkTQP5GjfSSNsfpY2zShcIqTNIOTmssHyM74zFLhOjOChklbenuRdVvLYb2WfH7+A3vD2jk574BAqhWIwijGkhA9YNn8yvk5U+d0zG78Z6Cr/YuWCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762853021; c=relaxed/simple;
	bh=hBNo25lCRHGLJi84qVHZpMc5jmMPbzYTIoLgAupcLE0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=vB2+IEJ2QjIpOSWyWdlXwAVSSVM2x/HlABfEQMOIP6ZpHipa9dKK8y3VZKZ7h9OReZV3ORfb7nBe2RXnugxvKjHFhtUTs+rGrCqqF4/RM/23cxdYToBvRWVyqrwGhA1iPBrqqzXvO3HxkjOu0RJS5AnN3pI5qYfqVO+2+MNcMsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NsdOV2Yf; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762853019; x=1794389019;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hBNo25lCRHGLJi84qVHZpMc5jmMPbzYTIoLgAupcLE0=;
  b=NsdOV2YflcVlNH3UMP7ue0ADlHhvXaPAO+uZRxkRg9I/r/sC2RhItkQK
   SUG0gEjs4rYygEqBrtiVAVIHoEmoE4+DTxbwP+eE19jIB0/UNx9wuWaJG
   dGveXURbT72QG8o2Ovhby7BjyaHaFUYZFa34UBSqwyAmSnf4VRDJzns23
   mcTJJOgmFWIV5WiM56X+uxrre0XNkEyIGjBLfqV4qZ++r3gx2qRnDR3OE
   IQceuWA5rvVZwOPgDq0tGsyfChM/Y7x06cF6CqPGLonoTS26Qz0aItS5S
   HiDXi0ZcV64pdR6VV6F8j76yNNKaiFkdJaHuOgT25kdUEXAavRmFxB7Px
   Q==;
X-CSE-ConnectionGUID: wi4CU/7ySjauV6ZsWqu+yQ==
X-CSE-MsgGUID: cODaFciCQqOeNW39jpZgAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76259770"
X-IronPort-AV: E=Sophos;i="6.19,296,1754982000"; 
   d="scan'208";a="76259770"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 01:23:38 -0800
X-CSE-ConnectionGUID: SIHNza0yTcuWOB+wJMXmEQ==
X-CSE-MsgGUID: IQ1ATJbnRXO6u9fsOxsgbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,296,1754982000"; 
   d="scan'208";a="194110729"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 01:23:38 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 01:23:37 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 11 Nov 2025 01:23:37 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.19) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 01:23:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BsdUBazc+1PBhsWcBepNRYkkKDQUwIJROoHBLtABVA8UI4ZZF/OjtLMStneTIPaYS3eAGJE2FrTxDfvNGzwSVnAmRy7CgO+1iNU2Y1N+XEdi5PrfKbYLp/khCRBYMFwiwTrLu/mpJX5c3hsZcLD++5f/YqD516Skl857nsqQd+knSeQeKzNNb8WYrgex5ZqOjWwMRA0STcysjIhyFwWByaipYORK1XFEBd9q9KMTw5uW/4nUPIBX95Oi5XnwiGn8Qdb4OfNbgkXWhay2Oer8T/bqLvugh3QJlddCfO+DkqDKPUlyXI+HtF7zNR7YBVxwL5pqaukop+aUcy6lAc1CKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hBNo25lCRHGLJi84qVHZpMc5jmMPbzYTIoLgAupcLE0=;
 b=MuxvJAtHURj2G5nbbrTPvUly8gTVHcOPV+6P5ta0xGqj14dQEbnBuvFIRUJTMJUQg4kDnV0HgFM/Zw4cQpgVjH8qc9ivEyjd2Of1LIEdYGT6Bj/EollLyq9gC85PQQ+AOL0/7gSdwWAVg60pypjBSrvHz7md5gH0PZY2f6q0AMIW01NB0g2Kead0722DIDfz5O+FTo6S+Hehp/XbvC9bnq6gnII5y+NuyLq6BRnSIyVdwfYIu9z5X5fFPcslWKdI6/iCZv2y78eNEdV4qLkedzvDSL0PrdvjsYtZo02qBHNYcoTRXhC+Z89O+5LH1HYLJAd9OEuaAsSNTC0K4XFLNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA0PR11MB4720.namprd11.prod.outlook.com (2603:10b6:806:72::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 09:23:30 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.013; Tue, 11 Nov 2025
 09:23:30 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "zhiquan1.li@intel.com"
	<zhiquan1.li@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>, "pgonda@google.com"
	<pgonda@google.com>
Subject: Re: [RFC PATCH v2 03/23] x86/tdx: Enhance
 tdh_phymem_page_wbinvd_hkid() to invalidate huge pages
Thread-Topic: [RFC PATCH v2 03/23] x86/tdx: Enhance
 tdh_phymem_page_wbinvd_hkid() to invalidate huge pages
Thread-Index: AQHcB3+qgPjJH8tKFUSGhVyOSb/37LTtyqyA
Date: Tue, 11 Nov 2025 09:23:30 +0000
Message-ID: <fe09cfdc575dcd86cf918603393859b2dc7ebe00.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094202.4481-1-yan.y.zhao@intel.com>
In-Reply-To: <20250807094202.4481-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA0PR11MB4720:EE_
x-ms-office365-filtering-correlation-id: 7ec601c4-59fd-42ec-001b-08de2103fa45
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?K1J5K0Yvc09TcHRxSDA1T2lNQXZtaDc1MUtUOVcwOEcyMzFGWWhoV2l0S3lB?=
 =?utf-8?B?N0tmU1hYUGRycjN0YjZGaXBwNGpXb2lNSDFCRkF0Z0tDaFRaLzM5VVpFOU56?=
 =?utf-8?B?OXFjcHdvQTBkWmtDWkN6ci9LN0w2ZGY0cmJ6OVdlWllzRHdtQ09PL2prNmxw?=
 =?utf-8?B?QVR2M20ycGZhUlJJTFFaSHJmNzFwRmtwNE5iQlpkK2g2Tk5ETzhIbXp1ZUl4?=
 =?utf-8?B?NnhGMWNEcDRjcU5OWU13bVMvNkRTaVphbVRBRHc4bUZ4VjVaWGd5Sm5pbGZZ?=
 =?utf-8?B?blJwQjNJUW1mS0Y4aHBCTWRBRFRCcmVDZG0zVERRbG5YUkY5MUxkUEpJWFh4?=
 =?utf-8?B?MS8wTHdXcUU2eTh0VkxKNmJsL2x6UkN5aXVlZ1lkbFg3bGpUcTRyV2p0R1pk?=
 =?utf-8?B?SWl3ZlRKcWxxd0NzRnJYUzdkM015a0pLZi9ZYmZGVEQ0ZmUySGpmZUlQZ1BI?=
 =?utf-8?B?Q3YrYytjWDZqczhPQ01iMnRCekhpRFJPczFkejVOSmJ0ejNHZi91d09PbXBr?=
 =?utf-8?B?S1NBa3BLTVNEbzdteUFzbEttblFYUFVSN0xoTUEzTGlpMmFxME13N3ExcnBH?=
 =?utf-8?B?RUJ3dzM5OXVwSWY1YXB6QytTSkZEUG5iUnU3dnFCSEJSQ0JPeE9NRjlxbS9O?=
 =?utf-8?B?WGhoM1d3d1hGR1BMcmZGOTU5d2pqZGZZRkZsQkNpWWQ0NndsMW9nRkkyMXZR?=
 =?utf-8?B?MlNkMjl5QW5KL3NVZFdtaXNubzduWTBqYU1qQnBRdEU1ZlVjV09nWE5hL25F?=
 =?utf-8?B?QzJSRWd6NXIrVzJiMTBQM3h2U0Q4ZWs3UTJuQm5pUURlbERFcWdTVDhjSmNQ?=
 =?utf-8?B?cGhueVkyQnA1ZFBkNGx4Q2NOUmpDaStQTk83RnRBZG5vd21oRHJZUHZzMHRP?=
 =?utf-8?B?ZUFyb0ZFSXF2NWdXV1orelNhanFWaUlSVXVuQ3FZVHpZOE5JN1BlSk1pcHF1?=
 =?utf-8?B?NW5jdld1UnRqM2tDdGFWdEZHSW93SDNQelhDS2hXNy9YNHRGditKRG03ZzNO?=
 =?utf-8?B?a2owcmt5ZHhYQWVYejVwcHUvN3krZ3ljRFl0cjRJSU5hTnNvbkgvRXNwRGFK?=
 =?utf-8?B?NVN6ZGNja0ZicXR6czV4MmpmbGV3cnZGeXREc0M5OG1kQjdMZzJVVjZoWWxi?=
 =?utf-8?B?b21UNkczZHJ4V2FhaFQ0WXBhVFVUSnRiUk1QRXN5b0JtWkVmT0ZTWld0ZVlu?=
 =?utf-8?B?NlhCRzJXMnpaK2lhK1M5TnR3bkdxcWJEOHNOUHVWRDh6VnR5bzR6d211Uzhi?=
 =?utf-8?B?OTg0S1lrcGgrQnpNeVlPdG93MndpdGNibTdySGV1bXhUbWU3Zm9HUWFvT0Fh?=
 =?utf-8?B?a3VucFRKTE5XTXJtOUVVcmRERytkZU9kZUxLeFN5SzNhZEhBZ0xyZkY2dGZG?=
 =?utf-8?B?cHNUYTMyL21KNU5ldThDY1ZJeG95T2VMYVZ2M05aS29HTmpDN1pOVEY0aGxC?=
 =?utf-8?B?Uy96ME1yMnIxeUN2azAvbTZBU2Fxd0EwYW5kMndJT2NscTB4WUtmU2RLU2ZF?=
 =?utf-8?B?VkUwYTVvbUVkLy8valpFaU9qYTdCN0JwNHFQclBiTlBxZ0R6L0c0a2oycVRT?=
 =?utf-8?B?QTlLSnVyT0JxeHdBdUNFZU9iQXpqd0swRnBTb01zQ1JkK1JYQmg1K2ZsYjgy?=
 =?utf-8?B?K0dBelRWQ2pVY1Y1QWIrWTlIYTA2YVp4Sk52cHdoYmVMNW9sU2xvZEIyU2th?=
 =?utf-8?B?ZytBd2IyZk0yN1l3K1dKZDNIb2hBZ1NqdTRGY2JoOEpacUY5VWVaazU5QktW?=
 =?utf-8?B?U0ZydlIzbGVtWlZJbGdBRS8rZmg1U25sNGR1bGZ6TEdqMzRtT08yeGVxaURn?=
 =?utf-8?B?eFZUL0QxWXBMaGtBRlM1d1RMdWJza0h4eWtzRVpRZjJvVHlJNXFOdXNzc2w4?=
 =?utf-8?B?VVd6Y0xWbWNBVG13eHoydHdlV1RDUG5PM1l1aDZ2LzFnVThwdXgwdlZxdG9G?=
 =?utf-8?B?RksvYlEwZlVGTE93cFNwcW8rZ0V5OHlIQmgzQThNNUkybWJjVE1wMXJ2bzBO?=
 =?utf-8?B?OEZwaUhLZ1Q0ckMvT3FSTG9oWmZ1VExCWm9saUxEenpkYTdNZXJQUHFzbVU3?=
 =?utf-8?Q?esvmSf?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVd5TUl6TlNCUXFaRDd3dnA3ZWQ5NEJ0STZGYU1yOTdOVUhGcVQ1TkhVOWw4?=
 =?utf-8?B?MlFlR0xKckU1N1ExSTM3MnoyYlJ1dUJoZ1hKM2JsenBCTmtGb3lUaVdDb3VO?=
 =?utf-8?B?bFFTRFBUeXlUUTAvalFUUlVtRlZ6V0htcFhFNm9xZWRld0d0Um94SGh2eVFU?=
 =?utf-8?B?VXBIYjNsRllid3BpNGV6WmpVSHZ6VTdlVUhPMS8xSnoxaTN0M3RCbk92RkZ2?=
 =?utf-8?B?NmpsWEd6cW5JV2w5WFRvV1V3NXNsN2RYREppQVRTVCtISkdibXhKTXBJVEZN?=
 =?utf-8?B?N3FtckpCTjNZU0MrM1JzSk1OaFFXbC9DMDlZM05BekFSdDlsUXFicEJOTnVm?=
 =?utf-8?B?QWVYYkwwUjFyNm0xdFh3dUIzWWRXSHhOVXY0cVJtNUsvalczVWc2VHNnNnM3?=
 =?utf-8?B?bFA3WWQySWdmSkN4elF6SUNPb3FDdEhuUmVkTGxLRW82NVN1MG1US2piTHBI?=
 =?utf-8?B?Z0V3UExrZTF1Rm9tQUtCTFR6aWN2QzA0eWNhR3hPS0ZxRUw4ejJaQ245UXpj?=
 =?utf-8?B?Mmw4aVJkcWpyRm9ONWkrcUJ2ZXl4MFdjODd2Y1M2dXRDOC8yR1l3Z2J1Mjk0?=
 =?utf-8?B?ZndlOFFUdnV3ckxtUVRPUXBlU0t5YjlBZS9FNElUdnhmR1VFb2JKajFGMjJm?=
 =?utf-8?B?T1JjTUdHanlzUWY5MjEyQ2w4U2k5RTNQRUc4Rmp4a0VoWXhPVjJBTzNBU1VZ?=
 =?utf-8?B?Z3BjK2tIMXpHaVpRWmRPM2F5K0tmNXFpYUtiUi9tVUEyYUpBaUhNdUhvYXFN?=
 =?utf-8?B?cWx1UW9xWEtVY2x6MjJwTWc4R1Q4dG5jZGkrR2FITTVQaHJ6RmZ6d0xtdFVt?=
 =?utf-8?B?NWVGOGxVQUFoRElyWGZuVkdUZTl0NWhLOHNWNDVyT1d2cFNQNzl4bkNrczZv?=
 =?utf-8?B?ZCtya3REbzM1QitFUWYzb0VMMHVGN3lmNGIxd2R2WjVqbDFUSnFnOUkzMkE2?=
 =?utf-8?B?R3NFT1VISTFPQ1dLNEo4NTdndWttSmFoQksvTVhXVUpST2I2enhXRTc3NGRK?=
 =?utf-8?B?d09sVGNVRU0vSUxKZVcvbmUzN3cwVDdCOU5YQjN1dXk0RTNramEzVkJpU1ZR?=
 =?utf-8?B?dFBOT1FlZDd5RFcwTkNSRStBN2VoalFtNkpCU1REaCsvK1VEWkZQTFJhMTQ2?=
 =?utf-8?B?emtQMnlPd0g4VFNyWm8xL2wvRGpuL3lzRXA5emlIeU5qNkVhSTdsRWtUY3Zt?=
 =?utf-8?B?dnAvQkM2UnRNV1FHb0RNSUVHN3IvdWNQdW9YNVpTYUpmUWxrT2FPV0pGYnBP?=
 =?utf-8?B?NThNZG9FczZHZU51UHF1UVNHQjJuZzZ2ZTZWQTBBU1dPZjlQR2VMbE9VSGV1?=
 =?utf-8?B?Y0Nocm5yYjBDdkxaSG1iZktveDZnQlhYRzhCVnNWR3RGNTRjVkFYOUpmSldT?=
 =?utf-8?B?N3I2UkI0VmlVQktVSnlqbkVRRmtLMjlqQ1FjNUpVbUpka2N5WS9vb3k3VzlI?=
 =?utf-8?B?dkpKdDJuc2xSV2lEelNsRGFmdGd1dzV2ZFltc1FFaktSaG5LUFRGWmZINnBJ?=
 =?utf-8?B?MytXV09ac2pWdVVWMit2YnA2bXNCdmJHQkNQNmY4eGZ4bjIwTTVqUXV6SzhU?=
 =?utf-8?B?dlpNMDI5UmdqUDV4QWJMdkZDcTRzcVJPYXF1NmdzVHh0Sks5cC85Tlk4UkMr?=
 =?utf-8?B?dnd2SUpPSDlXT2VGMmFCd0h1Z1A1aVJMN2RkeHVCVjU4YzI0RTRYK1RZVWd2?=
 =?utf-8?B?V1JtV1hXVDVSdmFnaVplUTZtYjlqUXR4NGpkci9vRWVXcVZpQnE1Tk4xOGl1?=
 =?utf-8?B?Z1VrMlpVOE5kZlJNMlFKWk9TTUgvYW9IVmt6QnA1algraGpvRDhZdUNWM0Fs?=
 =?utf-8?B?M0lxR2lzOGM2Y29nU1cxVmxPNnhQMGJyWitTMENVWjdBa2lxMThJNGRXRkJq?=
 =?utf-8?B?Y1BSQnQ0UmJrOUpIUDJicmI3U2kvN1g0Q3JCbnFNTnBXWkxsMGhSVm1YOEF2?=
 =?utf-8?B?NkdTY0JCNUdIQjcvaWdaYlgvYmkwUysrRVJoUndnV3NoWFFkSzRUSmFzSFl4?=
 =?utf-8?B?SFRSUkxvZTJrZHpwT2ROcFNOUk0xaE5OMy9vSXpaWit5NXltNmdTL1Y4c1hH?=
 =?utf-8?B?VEVyWUptSVJKZHNVbVRQVUpKVnl1SnlvM2xpTXFveUI0OGJaVXlWdFlTQldh?=
 =?utf-8?Q?Ls1h7Ft9CR/IIkE4SsdXQ0u/p?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD3E9C8047215D4BAA9DB69F1F69278D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ec601c4-59fd-42ec-001b-08de2103fa45
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2025 09:23:30.0277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hROE00u0KdZV33inbJjYJtOPbPtizSCtApCy3wnplbIYLTAj8Aju5iYqZokkc7xun/Y52p5I7jA/NLddoeSadw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4720
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTA3IGF0IDE3OjQyICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gLXU2
NCB0ZGhfcGh5bWVtX3BhZ2Vfd2JpbnZkX2hraWQodTY0IGhraWQsIHN0cnVjdCBwYWdlICpwYWdl
KQ0KPiArdTY0IHRkaF9waHltZW1fcGFnZV93YmludmRfaGtpZCh1NjQgaGtpZCwgc3RydWN0IGZv
bGlvICpmb2xpbywNCj4gKwkJCQl1bnNpZ25lZCBsb25nIHN0YXJ0X2lkeCwgdW5zaWduZWQgbG9u
ZyBucGFnZXMpDQo+IMKgew0KPiArCXN0cnVjdCBwYWdlICpzdGFydCA9IGZvbGlvX3BhZ2UoZm9s
aW8sIHN0YXJ0X2lkeCk7DQo+IMKgCXN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgYXJncyA9IHt9Ow0K
PiArCXU2NCBlcnI7DQo+ICsNCj4gKwlpZiAoc3RhcnRfaWR4ICsgbnBhZ2VzID4gZm9saW9fbnJf
cGFnZXMoZm9saW8pKQ0KPiArCQlyZXR1cm4gVERYX09QRVJBTkRfSU5WQUxJRDsNCj4gwqANCj4g
LQlhcmdzLnJjeCA9IG1rX2tleWVkX3BhZGRyKGhraWQsIHBhZ2UpOw0KPiArCWZvciAodW5zaWdu
ZWQgbG9uZyBpID0gMDsgaSA8IG5wYWdlczsgaSsrKSB7DQo+ICsJCWFyZ3MucmN4ID0gbWtfa2V5
ZWRfcGFkZHIoaGtpZCwgbnRoX3BhZ2Uoc3RhcnQsIGkpKTsNCj4gwqANCg0KSnVzdCBGWUk6IHNl
ZW1zIHRoZXJlJ3MgYSBzZXJpZXMgdG8gcmVtb3ZlIG50aF9wYWdlKCkgY29tcGxldGVseToNCg0K
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzIwMjUwOTAxMTUwMzU5Ljg2NzI1Mi0xLWRhdmlk
QHJlZGhhdC5jb20vDQo=

