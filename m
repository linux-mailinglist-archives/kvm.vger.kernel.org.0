Return-Path: <kvm+bounces-38920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA02EA40427
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:30:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D1114274B7
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 00:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F1F138DFC;
	Sat, 22 Feb 2025 00:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GVta3Te2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FD28494;
	Sat, 22 Feb 2025 00:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740184245; cv=fail; b=g6wmacXZiS8fGxrOOvNJP0zVDIjjzim0fKFT6XK9qEgn6AYAd/NDQEVz/fI1KhMoJ/d23TKRYvRyWWQrGSu4ZgOR+YfOKEwlBvgp2gAYpk3/0wul/IuRa3xIyU8BDFf8JWHBxUuLlkaHMPbLYrxSB4wvzyyTfhTsGZ2QGWCzGiw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740184245; c=relaxed/simple;
	bh=2jG7c2izfL+UgxAxCZznD7+on+lNLowiEErESnJmdyc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hhi9LTjhkoMOphKEUcsPzT0na/q1esxNfYVBiG4mmd1vu4GwJfBA2lqX5Ot5qqREvYz4KCOVw83mltnFjxI8JDeJCibXfLTeFysssUi/7C2MxyryTtfSfU2DeM0iQcxPQ3Uwm10WI1xpzWGhhhGrublOnOIkrCOBOvMVUN9zn6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GVta3Te2; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740184243; x=1771720243;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2jG7c2izfL+UgxAxCZznD7+on+lNLowiEErESnJmdyc=;
  b=GVta3Te2JwwTBZQnD7LS45IB1dooYUGapN/hEu2M8v28pRzCzAU+9RBe
   ZjdIIWiTGBh1nSRsVjKq2lNLy/8/8x09fK2FOTn0dNaVcZ7D/JgfwfKvd
   JT+lXvtee0nx0IpXeO92hZeD75DJBLUp7qbcvD/paeaQdRg8zmED4yfIN
   fuN97GOz+4jIBfDupCBOKQ5xJ1ALcNiQep/40apiogceD6aUhr1gm+aKo
   ESkW5wktjscpJeCsfuGWUE8ljOHo79TeiYYCaRCnaqZDf7RRfXvB9ISNN
   9hskDn4RmWQwzbpVEEimP9WA3bb3YrCobkeA1PPxBzP84hPnN0LQ9tc/K
   A==;
X-CSE-ConnectionGUID: xmTM7MvDRWOBDwB0n3n7+g==
X-CSE-MsgGUID: o5ycBs/hQ6KZaUDxuZzedg==
X-IronPort-AV: E=McAfee;i="6700,10204,11352"; a="58565923"
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="58565923"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 16:30:42 -0800
X-CSE-ConnectionGUID: lNuucLN/RmSG45qHavLRxw==
X-CSE-MsgGUID: 7iy3IGwTQW+8NufkZ4MS/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="146354957"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Feb 2025 16:30:42 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 21 Feb 2025 16:30:41 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 21 Feb 2025 16:30:41 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 21 Feb 2025 16:30:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=knO01wzwC849hNoQgRr3OZ8/5um4UE4rUWa9yI9D4rXNtQ/jccmY3cNVkBayxC9Ewa0E5Nq8ZYRkIMQ6rXMWBaP9kAi2PesmO2gSMCbtJhOY7GjxKjuXDzZ5nzMeaNGimUaDhvdHKp1LaGifuZToAp1mx15wUoIiYEcaILzyqjM10xBgsJDvbVfnHf4IYgRgoBDv/zQ7OWqzmMQYQ977cx0Q+BaTiK5T4cuUwWVbx+H0sIzk2Y0TsMktLSKy9tsoKBDPmtpqzeZQzjk0KqTcdjsdWs1xPTb1cMmJ1EUj/n5irar7l4j7n/VvMU2XiR2Pfc+lddNrgi7LAsHpQLecNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2jG7c2izfL+UgxAxCZznD7+on+lNLowiEErESnJmdyc=;
 b=WamoqdqdYAvt+0mSIufDBfIohy35yx555xmen82x2M128QAJ4nmiZvJqygjAOUKpR6QmsELOy3CqY463qeZ8IY4A4GMYVsrmYZT1XDakjxZUZv2aO0bWFS1mEujlUVXYG4BcTpfI4tdzakZYryw53VPJu8kVsK/SNu+6F2OwlMeRewnAx0IK2q7ThJptRCpNRlMoli/C+3XPJZKRj/0AHYnoaPL8JLBguecXUw7hywmcY7El6jgnjGqT6Xmk5AYH5Os5W1PpA1iiTbSYPuGZxfnfiv0UDvRWrNnI1Op1e7FxFx6iiJYu1X9i3jhls7HjStg13T786u4XqKV9mCRavQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6282.namprd11.prod.outlook.com (2603:10b6:930:22::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.16; Sat, 22 Feb
 2025 00:30:38 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8466.013; Sat, 22 Feb 2025
 00:30:37 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>
Subject: Re: [PATCH 20/30] KVM: TDX: create/destroy VM structure
Thread-Topic: [PATCH 20/30] KVM: TDX: create/destroy VM structure
Thread-Index: AQHbg7nd+dTzQSQxxUiUXnM4PeudDbNQ7xkAgAADxQCAAYepAA==
Date: Sat, 22 Feb 2025 00:30:37 +0000
Message-ID: <5da952c534b68bba9fbfddf2197209cb719f5e41.camel@intel.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
	 <20250220170604.2279312-21-pbonzini@redhat.com>
	 <Z7fO9gqzgaETeMYB@google.com> <Z7fSIMABm4jp5ADA@google.com>
In-Reply-To: <Z7fSIMABm4jp5ADA@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6282:EE_
x-ms-office365-filtering-correlation-id: 5886ba14-07e1-4405-4b8e-08dd52d820fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Zmo5cEpYR3BJTHVad0xVTVBvSVUwZ21EWE1ZUk02b2IyNmhZeXRHdllqeE5o?=
 =?utf-8?B?UFhibHk1dEVRbmIxbEZuMk1OZm9SSTBxb1cxV01YaWZFcUtkbVQ5V2haQjVw?=
 =?utf-8?B?eWF6cWRGTjQyVmg1TzdqV3kvbC83NGdHVDZZeURVZEFuWThlMDAwQ2djTkxz?=
 =?utf-8?B?Y05VKzBxTjhkYkhnTVVWMlhPQ1FqTndFTzZvZ3BTT0VVTGJZUWFMOFNpOVo0?=
 =?utf-8?B?V0lWc0pQRjhHZmFBSlpjYWxCYVZGdU1wcHB2UG9Bd3BwMmJHTnNMYXNMSDl5?=
 =?utf-8?B?SHNzeEMyZ1RKMFVYMXBoL1JjR1hSeXgwYTNxV29UaEVwUEE4T3ZETFk5NFBO?=
 =?utf-8?B?azJFM25NMzdqQ2luUlJTYU5tbkRSU3FuZHFLL0g4M3V2MjFKaDgwOWZDL3kw?=
 =?utf-8?B?dVZMVGk3a1JPYmcvTnQ2WHRsUVpqSFZtUlU3RmpPVFhyaFBOQjQyU1dQdUkr?=
 =?utf-8?B?SkxYZWxWNm52em5wcytPcG1ad3R4UDRmSjN5ZjlZVllzVEE3YVFuelpDY0dm?=
 =?utf-8?B?LzE5NDE2Z0Z3WEx2aDBkd3hydjlYQ2kxR1o5UmxuUk1XZnkzeERYVk8zalZU?=
 =?utf-8?B?K1IrcmNJdlRFL0VOQ1NTVDJrZzJHcWxKcEQ3aXVxZC9uRDI5T1ByK2ROaitn?=
 =?utf-8?B?T0hjU0tOREJDT0xpTmVsTWx1TnlhN0RMelp0akVXZnpDWG1EVC9pN2xsVlBj?=
 =?utf-8?B?d0N5L2FRbmlVT3I0QWpFSGdkQWVVT3AzaWpZeC81RWhKUDRHazVETVhMOHVI?=
 =?utf-8?B?UDdGRnNlNllHZkpmZTJoZzRpSlJsRkZPdEhMVlppM2dqM3J5TVQrQW5xZ0JW?=
 =?utf-8?B?bzMyRG1DemI3OFBzcUowYWI2WUY5VHRONWtDUVhvLzcyM3BnK2Y4Ujd2T0Uz?=
 =?utf-8?B?VDRobmlSZHgwYU5Ka3FHTjZiTHV3d216N3Y5S2NaSWlvQ1U2bTVpWU01ejM1?=
 =?utf-8?B?SUxUZEZxeTdQODQxRjVkY004WWhBeURsd25heHUxT2Rubi8xUm5vRXRPQ3ZW?=
 =?utf-8?B?bzIxcDFmMGpsbVAzQm8raFF3RWpLc2RZY1VjaHFYcnFMOERFb3AzWEdkUEpl?=
 =?utf-8?B?SHgvbnFLU0V2dWIxTEpmWUg0NlBxeXBpTERiQmRBeDZka2QvWXNVTzR0YWZV?=
 =?utf-8?B?aCtOaXZwdDVUR1pOckJqb1ltWXpiUlVmUlViSEZ5cktVMnJidkszOTFBbGJo?=
 =?utf-8?B?VlNUYzBwVDU0VWV0cU8vZHZVd3lFUysyRmppNWFQUzhRNFZXRzJvaUh5OFRj?=
 =?utf-8?B?RHNtNHAvZk91bHZ5Mkp6WVJldHZjSUFnQU9HTTEvOVN0YjJXU1NUZ25YVUMw?=
 =?utf-8?B?RGVEbk5hN2RldkE0RitzM3hWeWMxaXBxL1B6cU1HQ1RoNkpPTEhVZmFRWE9R?=
 =?utf-8?B?U1NCMi9uWTJnR1AwaTdXSjRoVVh0OFRiOWlLR2J1eXd1N1FQSS9zbmpYdTNJ?=
 =?utf-8?B?T01aK0FhUG9kWDlBVjZ6MEJWbUlUZ1Byb3BqQjk2K0NOc1VQK0c0aWh5TFNn?=
 =?utf-8?B?QUJmcEdzQ3pzR05SV0RGOTNySXArTjgzSzUrYXhGeXMzMFBTY3paL0tkbXFT?=
 =?utf-8?B?SUJzMWtldys3endpM3Npa2J3N1ZnZ1NXUFhqMjVmeHRSUFdma041WFVlMUwz?=
 =?utf-8?B?S0dyK1NxS3pma0xoZ2k2YkZwRU1NZk1XZ01uQTQrVXFlSUNtZCtGMXlsSHlK?=
 =?utf-8?B?cGN6dUFBc0U5MS9MQm9lZmZpSExZQlgwQ0hKcEh4R3Q1SEJKdUhZVDBxcGRE?=
 =?utf-8?B?c1hBR0NPa2VQQnQ3NHIrekx1NStsYVA0TEpITDhNWWw3VHBia2VEUi8zRzh5?=
 =?utf-8?B?YjUveUQzQzZtaEJuOWZXeHZHQnNVejl0NFBhK2FYVHpIVExYUW0wa3pmZ25Q?=
 =?utf-8?B?aFJnYk9JSnNka0toK2dmNzlZQU5mMlowL1dlMVErTVd2anNibjJWZXBkQi8v?=
 =?utf-8?Q?MPPWWvX439+uYqh2YVMEBxuN7W+ILO4o?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SGcvTUYzb0hENFhUMzFPOThVQ05tUG9mb0lncjIxTGNPZTVhYTF0enYvK0Nn?=
 =?utf-8?B?MHNsa3JObEliM1U2SVRrTmlTQUo2aU9kQ0dSNmtJSzVQVXpBSk1BRHhqbktG?=
 =?utf-8?B?b0JXWFYvRVBlbjRmd2xubFZaMm9oVXluK0Q1SUwyZExWZXl1N2FRWHNKRzBN?=
 =?utf-8?B?WXE1NVBSY3NEaEVNMndWS05uTU5Md1M3UlBpZzhFN0Nvc3NudnQ0MWM1S2VK?=
 =?utf-8?B?QjdxWDVLOTkzN2JMdFBuMEJrYXAxN1habDg3TGI4SHNzczJtMVpuRlAycXdK?=
 =?utf-8?B?NDRCS016ZHFZTk9NcHZnaFlGdDhjZGxxZGZmekxMbzRFTGp4QWJqUlpSRXh3?=
 =?utf-8?B?N2dzaVdsYml3NlNmVGIzcTk3SGMzOHpiL3k2V2VTZUxKN2xGWU9RMkNJa2dB?=
 =?utf-8?B?bTlQanVkaE1FRG5BTmxaZ2hNektWQ2dGNVdQNWpkejF2bjd2RXRLb1I4YjZI?=
 =?utf-8?B?dmZ3TXFkWWtJZURvV2dVRnpKWGc0Z3Z1SzNKM2J5ajlzajFDOW02eXhkREFQ?=
 =?utf-8?B?UGNpcDlCb3VWY0JneldNWEtITXJVOWVzbW1yYnBBN1FmR3Q2UEpzUVFuVFds?=
 =?utf-8?B?VkpsZzFnVVVzOTBxMk1OVjR4bG8rZWJsYXhPeU15azR4QnNsMnpkVk5SdWx4?=
 =?utf-8?B?Q1JEQlhrWnlKdWtqSkQ2S1hxYWV2RFpqMWlDbTRVNXcxeUZIaGt3NjJuWnV6?=
 =?utf-8?B?ZGNMaURwTU1wM0pINk51bittTGt0ZE5xN1gyUjFJZXBLTnVvbE03SWtoWkdG?=
 =?utf-8?B?VGx1V2RySWJuam1jcUg0ZW1EQThTVkV4WGwzL0JLT3RRNStsNGtDc2o1Zk1L?=
 =?utf-8?B?MWlvQzZVb1MwM2ZoN3dSMWozU3gxS2JXNEhSNVBKazFBMmRMU3NSMWxtdk9z?=
 =?utf-8?B?cHhoUUgrazNSQTlHR0IzTTVQSzhFZmlOWld5S2VzRlQwd0ZrUXdTdTZ1VzdU?=
 =?utf-8?B?T1VUNFFPNHFuRlE0TEhseDl3SjFTdnJFTzVIVHArcnYwL3YrNEZ5WERObVRE?=
 =?utf-8?B?NnRiaGJrdlNEOExVTW5TNjBta1FDbzN3bjFtOFBHaDlqMmp0RW1NZWpKcmhW?=
 =?utf-8?B?ZnZ5SkNtb3B1TXFqSFk1TXp6SDE3RVdPaFlkbFBkeHNSWXRKUnlseTRjUUtZ?=
 =?utf-8?B?WG1yVWVBcVpPaWwxT01ia0JYUTdGNzI3OUo5TnFMQjgyZmwrSXdLU1pJem92?=
 =?utf-8?B?b1VicVRRb2poUzBWK3FZZzQwbHdoUlRtWS9WQVdwZXQ3WTJ1cXlsR2sycWRY?=
 =?utf-8?B?UVVyNmFWRjk3SFJBVitGWUR4ZGNVMk9DVXpvTkQ2ZGs1NFFYZXJYTkRvUXdh?=
 =?utf-8?B?RnQzNDJtQ0dITFFOTDhQc1dpN1ZRM0J4cWpSOEZhb1I1U3JvZWNXM3lMRXBj?=
 =?utf-8?B?NXAzQ1cvVUFHZ3hTYUlTMjc3TDU5L3Jra1JDZjRDZ2dvaE1veGJZWURQcnpv?=
 =?utf-8?B?MVgzQmx4Y1Z4MUw1QkE5TDEzNVk2S1dEWExMTThCclRycHNrbVBDdmEzc0VF?=
 =?utf-8?B?UjhwRkdpTDdISEZXUW9KMHQ3KzU2OGFpWnZRWkEvUmNjSi9ZSW5wUkVDbVFC?=
 =?utf-8?B?MUZzWmdPdXZWRTNiakw5VVVjbXhndlBKWk5vZ0Y2UXNkazZzblZyekkwNUdr?=
 =?utf-8?B?OGp2M1czRlJPeG81ZGdXL1RQamYyM1AwdEQvRjdUeFE2Y2poWEtuc0NUb0lX?=
 =?utf-8?B?bExSUUdueWtQcVVQa0l5SGRuZmJ6VjcvVzIrQkF5SUhFc1dCamp0elFvV2x6?=
 =?utf-8?B?OHY0WU9jUnZNVmpFdHFmNWEyRTNadU1ySUs1UU9qd3RJSlZmRVZqWEd4MnNs?=
 =?utf-8?B?d3AvTHJ1Q1FIMDREZGs2K1hneVdoeldydkVBd3IzTEZtd1ZTVDgzQ0M0SDh1?=
 =?utf-8?B?UFJXL2VWaFIyQldGeVN1SjBUbWpSek0zWEhtdG9pYmpudTZ5WW0xTEhPZk9K?=
 =?utf-8?B?VUxvNC95UlpDYytOcjRBZjJXeGczd1EvRjBpTnZFb0F1OXpUQzRyNzFJbjFU?=
 =?utf-8?B?bkFuM2ZEb1hjNWl6QXJud2k0bjRRWGpMTUtKcWkybjdya0hyYkhneTQvU2dC?=
 =?utf-8?B?Y2ZRM1FoNkNJcExNb0UrNW5KajBUMTVncFR3Tmh0YUFOdUtRTllMRSsyb1hO?=
 =?utf-8?B?NDhodG5TNUw1QjA4R1ZUdTdjQnNMdWtCVXRTNFEyd3NxQXZjQmxFbmp4dTRQ?=
 =?utf-8?B?K2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A02DD16D3A0F6A4A9695BE76FC0A1F36@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5886ba14-07e1-4405-4b8e-08dd52d820fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2025 00:30:37.6195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JduWLTXdUTs88iDnUo1bJXH1NVCE4vqLY12Ew5PyfmOzmqafevgDoOGarHU7HNoYQ1T2g8J5j0CCkb9RU3iH60hKL7x8gRI18YtSWqdEYN8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6282
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTAyLTIwIGF0IDE3OjA4IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBcmdoLCBhZnRlciBkaWdnaW5nIG1vcmUsIHRoaXMgaXNuJ3QgYWN0dWFsbHkgdHJ1
ZS7CoCBUaGUgc2VwYXJhdGUgInVubG9hZCBNTVVzIg0KPiBjb2RlIGlzIGxlZnRvdmVyIGZyb20g
d2hlbiBLVk0gcmF0aGVyIHN0dXBpZGx5IHRyaWVkIHRvIGZyZWUgYWxsIE1NVSBwYWdlcyB3aGVu
DQo+IGZyZWVpbmcgYSB2Q1BVLg0KPiANCj4gQ29tbWl0IDdiNTNhYTU2NTA4NCAoIktWTTogRml4
IHZjcHUgZnJlZWluZyBmb3IgZ3Vlc3Qgc21wIikgImZpeGVkIiB0aGluZ3MgYnkNCj4gdW5sb2Fk
aW5nIE1NVXMgYmVmb3JlIGRlc3Ryb3lpbmcgdkNQVXMsIGJ1dCB0aGUgdW5kZXJseWluZyBwcm9i
bGVtIHdhcyB0cnlpbmcgdG8NCj4gZnJlZSBfYWxsXyBNTVUgcGFnZXMgd2hlbiBkZXN0cm95aW5n
IGEgc2luZ2xlIHZDUFUuwqAgVGhhdCBldmVudHVhbGx5IGdvdCBmaXhlZA0KPiBmb3IgZ29vZCAo
aGF2ZW4ndCBjaGVja2VkIHdoZW4pLCBidXQgdGhlIHNlcGFyYXRlIE1NVSB1bmxvYWRpbmcgbmV2
ZXIgZ290IGNsZWFuZWQNCj4gdXAuDQo+IA0KPiBTbywgc2NyYXRjaCB0aGUgbW11X2Rlc3Ryb3ko
KSBpZGVhLsKgIEJ1dCBJIHN0aWxsIHdhbnQvbmVlZCB0byBtb3ZlIHZDUFUgZGVzdHJ1Y3Rpb24N
Cj4gYmVmb3JlIHZtX2Rlc3Ryb3kuDQo+IA0KPiBOb3cgdGhhdCBrdm1fYXJjaF9wcmVfZGVzdHJv
eV92bSgpIGlzIGEgdGhpbmcsIG9uZSBpZGVhIHdvdWxkIGJlIHRvIGFkZA0KPiBrdm1feDg2X29w
cy5wcmVfZGVzdHJveV92bSgpLCB3aGljaCB3b3VsZCBwYWlyIGRlY2VudGx5IHdlbGwgd2l0aCB0
aGUgZXhpc3RpbmcNCj4gY2FsbCB0byBrdm1fbW11X3ByZV9kZXN0cm95X3ZtKCkuDQoNClNvOg0K
a3ZtX3g4Nl9jYWxsKHZtX2Rlc3Ryb3kpKGt2bSk7IC0+IHRkeF9tbXVfcmVsZWFzZV9oa2lkKCkN
Cmt2bV9kZXN0cm95X3ZjcHVzKGt2bSk7IC0+IHRkeF92Y3B1X2ZyZWUoKSAtPiByZWNsYWltDQpz
dGF0aWNfY2FsbF9jb25kKGt2bV94ODZfdm1fZnJlZSkoa3ZtKTsgLT4gcmVjbGFpbQ0KDQpUbzoN
CihwcmVfZGVzdHJveV92bSkoKSAtPiB0ZHhfbW11X3JlbGVhc2VfaGtpZCgpDQprdm1fZGVzdHJv
eV92Y3B1cyhrdm0pOyAtPiByZWNsYWltDQprdm1feDg2X2NhbGwodm1fZGVzdHJveSkoa3ZtKTsg
LT4gbm90aGluZw0Kc3RhdGljX2NhbGxfY29uZChrdm1feDg2X3ZtX2ZyZWUpKGt2bSk7IC0+IHJl
Y2xhaW0NCg0KSSdtIG5vdCBzZWVpbmcgYSBwcm9ibGVtLiBXZSBjYW4gZm9sbG93IHVwIHdpdGgg
YSByZWFsIGNoZWNrIG9uY2UgeW91IHBvc3QgdGhlDQpwYXRjaGVzLiBJJ20gbm90IDEwMCUgY29u
ZmlkZW50IG9uIHRoZSBzaGFwZSBvZiB0aGUgcHJvcG9zYWwuIEJ1dCBpbiBnZW5lcmFsIGlmDQp3
ZSBjYW4gYWRkIG1vcmUgY2FsbGJhY2tzIGl0IHNlZW1zIGxpa2VseSB0aGF0IHdlIGNhbiByZXBy
b2R1Y2UgdGhlIGN1cnJlbnQNCm9yZGVyLiBBdCB0aGlzIHN0YWdlIGl0IHNlZW1zIHNhZmVyIHRv
IGRvIHRoYXQgdGhlbiBhbnl0aGluZyBtb3JlIGNsZXZlcg0KDQo=

