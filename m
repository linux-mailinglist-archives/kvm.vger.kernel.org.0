Return-Path: <kvm+bounces-27868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C9AB98F84B
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 22:55:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0FD61C21A30
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 20:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E17CE1B85D4;
	Thu,  3 Oct 2024 20:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M7MqW9Zm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3729C224D1;
	Thu,  3 Oct 2024 20:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727988940; cv=fail; b=nCYTg/3Jc2Pgj3QVPzEeAeoOzooMraeRb8SZsquB159hHAPpuMUIt/az6lv79IxNSbH3f7wFEs8zF6iV4/YLtA18XBKGjcNfd+TK2D7n+cdU2IiblNkNDJ9fp3/2sUya3CliWftT/1K6o187yKrQQMpomMQyfuKUyLTMxPxaUWI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727988940; c=relaxed/simple;
	bh=/u0JobN0CxWIfaZuvjCq0sfdMm4EldjxDxwP1eHE3F4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HfvyaP41He0JzIU5NdjEn64BwPO8k1NIuv+2D4xXIb15B7AonFX2BW8PYJy8w9a1NqDAC68H3ko/YFH4RUIKxTF5JXQSJ/VP2T2+sFE0hG6E1vFkr3pM3SNRFGefc0kYz9TeTLivbAZXGYuMwkN2Q7D23//WvcHDWuRPJqAFlds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M7MqW9Zm; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727988938; x=1759524938;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=/u0JobN0CxWIfaZuvjCq0sfdMm4EldjxDxwP1eHE3F4=;
  b=M7MqW9ZmuZqGrikJKZjMJ4NbHXJha3P/bD7S6FKkzK/vWs88xEgWmpTc
   +KVADNjqTdZfIz69LIQ3MdQzJU+3fj8E3gI4MIv8jMNqpqcVuHZ5WN1QE
   D7I+w75kRistxv6JaWVe5EzOAkIy8kXaOmagdkU8hJLZzpm3xqjIcLocR
   dZBlRlYWdy+hAWuQvm4EB3h0CrUWmcwzOvINdxT8F4fmuk4pLWtOsGC/n
   ywBGGuklkHMUxPepJ/0O6ry3nhUlh2EPdW5HwHtwn3eKauID+ZP/SPR3x
   GcnklfLZ/bssdKzZFopXTrHiylYGdcKuPSST8E0UlY89nsmQUMS2SBPOM
   w==;
X-CSE-ConnectionGUID: xZ2JJjZSRpOx9p8i3gqkdQ==
X-CSE-MsgGUID: goPwmPnPTZWO50VYPsBACA==
X-IronPort-AV: E=McAfee;i="6700,10204,11214"; a="31089838"
X-IronPort-AV: E=Sophos;i="6.11,175,1725346800"; 
   d="scan'208";a="31089838"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2024 13:55:37 -0700
X-CSE-ConnectionGUID: ejLotVdBQFuxhUo3cvIIWA==
X-CSE-MsgGUID: 2H7Z4iRFQbSRIo5pfJ4img==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,175,1725346800"; 
   d="scan'208";a="79324603"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Oct 2024 13:55:37 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 3 Oct 2024 13:55:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 3 Oct 2024 13:55:36 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 3 Oct 2024 13:55:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gIckNtIjM7R8QXZplPMW1OBCjvPMzc0VOumuUQ18Rrs2l+QZTGzw5qfJ5MknQaiI+HSv9otYrfnrOIYR7Gn0JAOwGoLNJP4aOwBW+t6Nd9MbdzuMo/eFO5HccT6rOxFVxqMk2qovtRwCW/D60QU5z4IQ/8AsBQQa3fHCc6mGc2B8lrlgf1GM1GgaqnPwqtGa2nwmS80k7Y3OPvNWGWSFhgEr1pgTE9tznDtB1hpJErVosyhSDaIhkdqq+rciF8CPsK0ualhrQfeid4N1m51JWgjEKSvMTuItrGIMJAUHvHWRXIA3kbOFxClbqycGOIIBV4vHhNOvb8vZ+WQgieB+6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UM9h1eDF+iqInZT6vX6CayxesZQYZIKQ5xYv2ouFYMA=;
 b=fG72mkngLa+2wW06eXfX4WAtzrQqgYx7P/ydAQiqBhqxd5A4JbZuuGzWXJ9yHqTrPGBZYuQPb68PAlMcewz7WJj02Gx/7r6hJODdnyySWSV+fpi75BVIa1vrGV6WhZ257OAIZ4tIorCMuitabiyqXm73QapicZki/G7Rvzh4aZ4Jf06dXkZznvUNqwFefhVUTOXnO/0bRoqWUWME3RhR52jHgh2LENE+9ehoQYmO6SiOZj9GGZ8bWwdG81qtEjCllF6luuzRLcCxKx14eTngHQAiJQc8BKTYSJoS97TE4PlndtH9jY9w+Gscy0IDjcsXz5hMafafzX/t3hXvdmOIRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6139.namprd11.prod.outlook.com (2603:10b6:930:29::17)
 by PH7PR11MB6649.namprd11.prod.outlook.com (2603:10b6:510:1a7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Thu, 3 Oct
 2024 20:55:26 +0000
Received: from CY5PR11MB6139.namprd11.prod.outlook.com
 ([fe80::7141:316f:77a0:9c44]) by CY5PR11MB6139.namprd11.prod.outlook.com
 ([fe80::7141:316f:77a0:9c44%6]) with mapi id 15.20.8026.016; Thu, 3 Oct 2024
 20:55:26 +0000
Date: Thu, 3 Oct 2024 15:55:23 -0500
From: Lucas De Marchi <lucas.demarchi@intel.com>
To: Luis Chamberlain <mcgrof@kernel.org>
CC: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>, "Stefano
 Garzarella" <sgarzare@redhat.com>, <kuba@kernel.org>, <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-modules@vger.kernel.org>
Subject: Re: [PATCH v2] vhost/vsock: specify module version
Message-ID: <pyocjxtoqd6qtbkszq77odcakfh7arn3bmj72xb5elso3rksvy@tdjcfqddf3sd>
References: <20240929182103.21882-1-aleksandr.mikhalitsyn@canonical.com>
 <w3fc6fwdwaakygtoktjzavm4vsqq2ks3lnznyfcouesuu7cqog@uiq3y4gjj5m3>
 <CAEivzxe6MJWMPCYy1TEkp9fsvVMuoUu-k5XOt+hWg4rKR57qTw@mail.gmail.com>
 <ib52jo3gqsdmr23lpmsipytbxhecwvmjbjlgiw5ygwlbwletlu@rvuyibtxezwl>
 <CAEivzxdP+7q9vDk-0V8tPuCo1mFw92jVx0u3B8jkyYKv8sLcdA@mail.gmail.com>
 <Zv71BrHKO_YwDhG_@bombadil.infradead.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zv71BrHKO_YwDhG_@bombadil.infradead.org>
X-ClientProxiedBy: MW4PR03CA0064.namprd03.prod.outlook.com
 (2603:10b6:303:b6::9) To CY5PR11MB6139.namprd11.prod.outlook.com
 (2603:10b6:930:29::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6139:EE_|PH7PR11MB6649:EE_
X-MS-Office365-Filtering-Correlation-Id: cefd89e6-6ab9-4a52-058c-08dce3edb505
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N08wbVp6UmxUOXFPMGdjeHBkaDlvdnNmeU84N2l5NVd4L1RBaVdQZ1Foc00w?=
 =?utf-8?B?UnFXbzlUbDAydGpFTjNNWk4vNklCN1N1VElibEwvQ3NmckJOaWRVLzVxVTM2?=
 =?utf-8?B?SWEwOWtvdjQ5eTZTWTcyWE5xOGJYVVJxYnd3b1JFejhyWmpRUUxKQlg2aXJP?=
 =?utf-8?B?aTIvR1pncmRPbUY3NUNPVXFsYTZmRkI0V0IyWkpMYWx6ZFBkWGJoNll2NGtT?=
 =?utf-8?B?VWI4cUZSd0l2OVM5RTVKMFJkeVpmV0dCTGNEczM1QWo2dzd2TDB3dk1KaTZq?=
 =?utf-8?B?a2FxQytjV2UzQUtZME5QNUdlOTFzeFRTTHR0MTFTMUJFSzY0YS9nRnUxcGNz?=
 =?utf-8?B?SUN2dU1haTBMRWw2N3V0VWI4bVBDQVJCdzRsVElrRXJXRWZVSmhkYmxEWlhZ?=
 =?utf-8?B?NHRscXJkMFE1bXc0cFQwV0dMcG1xZjRtWng0Rm5aby9TTWNmQjhtK2tNVEEr?=
 =?utf-8?B?STZzRnkxU0pPMWx0RDJtOGhydXVqUFloQnNjcFdJZGovMFVlOUNwZitlRy9h?=
 =?utf-8?B?RU1ObzVwbFhSSlhtM0pFcnNycGI4OTBaSy9LeTJBeWJVYURMTUtIaFRrWTZr?=
 =?utf-8?B?Wno5TGJIWmtkR29TK1k4NGQzUVNpVVhlbzJ1aWdNdEh3Wi94YVFDMCs0OTFz?=
 =?utf-8?B?TXdxS2FWWEd5cE5iVWQ5RGx5YmRxcVF5MDZwZEVod2N3cVJMVW1HVTV0Q3g5?=
 =?utf-8?B?bUNqSWhJbjVHdVJIbEdIWHRoT05NcjZiOVZaOUQ1cTZHWDd6UWJCekdjOGJp?=
 =?utf-8?B?UWlkRnZ0R0ZLVmwxOFNycWxDVkxsUWd4UEFzaytsNFlYbXM2TWVBS09xSEs4?=
 =?utf-8?B?MkFqcWpZY3Zhd2FrYjVwQXZyYytROWx2MCtpTjltQjd2T2JCTEVmUk9ERmxr?=
 =?utf-8?B?ZXM3OEJLMTZ5MFNsMTJsQ3lrZ0YrNXdkNVBpbU5VemhKMkIzd3JzOW94RkZk?=
 =?utf-8?B?eFhGOUNDOEI0dFM0WStRUFNrcXFMcm93OVk3NXdUWm1Eczd3VGlCRExzTk9W?=
 =?utf-8?B?cnAwb2R1NGNGTkpJa2lNbzJNbFRzSksxZ0gzOEZaZDlHVEZ4WEtoZnhkcGZ4?=
 =?utf-8?B?bEhBSGkyM0NBSFNwbmJLMlNWa3hFc1p3RW5aZGtOdlRDU09EZmlaS0ljYy9p?=
 =?utf-8?B?U3ZkZmRERWlxbVNwWndMbFlZalZGMFVQLzU1OWpiZXB1clphQmk1SVBxZFd0?=
 =?utf-8?B?Z2picjhETHBtTTl1RVQvMU9FMXdBUEs1SzEzRHU1SnpjM1FwK0xhVkdVaklK?=
 =?utf-8?B?R0sybTVKNkdsei9xRm9RbzloeVdrNGFRM3R3NnJGbmwrRjRBcFZEYk5BY0lN?=
 =?utf-8?B?SzJGdjJsSzlXREdUL3hQUFpjVTcveEVCdkdqRE04NE8ycWZOMUpvbDA2MG1S?=
 =?utf-8?B?ZGN5eGVGcU83cjlEYnRTS2YrdkJpTHhxdURoc2tjTms5NHJmMUdSTFdMTkxm?=
 =?utf-8?B?T0JMRnhIN29GOW40akI3WEdmelY2aTN5RHBMaEc1QTV3dml2a0JTVEs2RXVt?=
 =?utf-8?B?b3FTQVNuODRDZFNOcHFrQlgvbWJLL3U1eUtnMVNnVmZRbG4wOHZoUnVvdmFL?=
 =?utf-8?B?ZHZxVmJpUUhXbW5tSGZLb3k2U0NjVzd2eWU4eHdvcUVkQk5iRWxVbGVkTXhz?=
 =?utf-8?B?aVdQWEluZSt5cHlJa1RZb2laUFZ6RjVGTC9RUkcvWWNxNnJ5NkZlN05BWVhG?=
 =?utf-8?B?d1dQa3FSUlg1ZHNQbkhjVGxkck9LYjlZU2VJNWRxa3lGb09MODFZT2hRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6139.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0VHUHYyV2ZqbnZqcERjSWJQUmJZR0F2R1RlclNjSzM3NTVOakdXVjBTR1hk?=
 =?utf-8?B?UUFtNFhRd0grTzZ0SkVBTWowSFR3SysydHdUMVlWbGE5UjEvUnM3Kzl1VERu?=
 =?utf-8?B?OTUvMXFvYmNUalk2QkdyRlkwbFZaV2ZEa0hzaTlTM1g2YjBTVjgvQWxZNjNM?=
 =?utf-8?B?aDQ1VmlON3hWbTVlMW0yOHF2dUlrQnpsQ0R2WHc3MUdVQ1ZvSEpmaGl1elF2?=
 =?utf-8?B?YjFpQ0twZnQwUUlZQXhDOHVQOUpjeGo5SjU1YUpZaldpdWhnQWt1Q05RTVA0?=
 =?utf-8?B?OE9lczJLM0FLL05DbWNPNlVoTTBDZGZzcWVFaVRmcjJJRHhwZE5QNDBqZkRr?=
 =?utf-8?B?SzVQNG1DckRQUFIrOWxqR0lwbkNORmlQeUVMZUxkNVhLS0NHdkF1ei9KVUVx?=
 =?utf-8?B?S0ZTckxGV29hczdULzdDazFtSkt1M3Irc1RmKzA2blZJMWZseUxmaGdUY3JO?=
 =?utf-8?B?WE9ITFBJTndtSjNITTlsRFZNNnY2Z2dPcDJwMkZkc3gyY3AyOEVsT0VjYllV?=
 =?utf-8?B?N1BkQ0tad1pxVjVGYTcrMFJxcThFWUFZU0lycUtxK1BVcU41UzFsMjQza3hO?=
 =?utf-8?B?S1c4QW54ZU1tQXlRS1ZIajI1VXBNTWVZd0YxU25rcVh4bEtqOEhybjhhMEFJ?=
 =?utf-8?B?TnBWUlVrbUFIM1p2dGhUNVRwM1lTSDJRTUJhWHFwV2lWMytzMjlGM2Yxcy9Q?=
 =?utf-8?B?eWZZV0pMYUdEUitBQ3BaQnd1SU1zYVVDdG0yY3JsM1JyU09XeUtob1JrY0lN?=
 =?utf-8?B?ZG1oeVArM1RRK2xuMXE1QVNiMmhObkZjakM4N2N4QUMxN09wVTF3dFoyVHYr?=
 =?utf-8?B?TEdlTVh0RVBSUWdqQVZDd0xpOXpXUyt6RkFjZkpNRzFkelFGZGRZWlpiclZ5?=
 =?utf-8?B?eGJSNVJVMEI0S0NWTGlUcUJtdUxIeE1Xam92VVVyNHFrclBJNGN0WlJVdEdn?=
 =?utf-8?B?emhuM1VHeldGb1pTTkgyRU5XQkY0WVZ3eWl6S3FzRDNESm85T2hIYU1HTTEy?=
 =?utf-8?B?VXYxdDlQSENNOFI1TklnU2FvZVhhQmRoTEhrMmpELy9RM1FPUllxZjFzN0pa?=
 =?utf-8?B?QUlvbjFIR25RdTFsQVBuRWJYaHJteXhrVlRIcytqSjl3ZlFaRUkrQUxTN1RF?=
 =?utf-8?B?dGRXUGdjRzRNcGxWcThSd2JJaDYySEkxN0p3Wnh0WGM4bUtHY01wVEdST1Zz?=
 =?utf-8?B?cTYwb3BwMlR2NUM0TXhwUktWUjV6SjlmUUlaU3lidERITnhLdElaMnVyMkE3?=
 =?utf-8?B?L0xPZ2txNGRlTUVQZ3grZWZWZ1BXTVRsZ2lHcCtuRm5XQWRPSDI5ZUR3bUIx?=
 =?utf-8?B?eUw4dzA3clMrcVNacTZGVjh2QnBndC9oLy9sR0FyRzQvMVpXbHdQc09FUVpj?=
 =?utf-8?B?ZU5iZHlqMnNtMndCVkYyV2UzNDcyNi9BMU1vNnM5UGROcFhBTkthTEIzS01R?=
 =?utf-8?B?UXpGQnVxZmJFWHNYNVo0RlY4S1RTNEFMaGJsNDYrdlpnRXdVaWNjZnZXZi9X?=
 =?utf-8?B?SnAwc2piZXFKZjFMTTQ5cklOWmZ2eXJZS2lZQW5adWFCbSsrR0pHR1dqZmhR?=
 =?utf-8?B?ZkJseHgrbHFKbVJkaEdwOHd2bHNRaFZFSFJTVE9RdWdzNURnN1N2S0s3eFZ6?=
 =?utf-8?B?RU41MDN0OHphZjBKdTFEdzUyRTAyM05tdVNqSjY5NDBXZk8zNktHcVdVN3hL?=
 =?utf-8?B?bWs3aE16cHAyZHVRVHJsNDFTZDNKVEY5MU9mdEJpQ2NBMHhLUUpCdElNVWNu?=
 =?utf-8?B?ZllMOFhJQzJDWXhaV1JGaDh4Y2prV3BIb211MHZPaVNMaGF1YkprWUhON1B2?=
 =?utf-8?B?QThiYlZ2WU14WU4rNEM5WHFSYVEzYkFlMEptOEtSZzZuNVVvRU5SUUFsYWxj?=
 =?utf-8?B?SXJuTnRHWEdVODNFeUdGQ2J4djRXTU92dVlaOGFGL0RucDYrYitXRE1vWk1j?=
 =?utf-8?B?RWVVY3RYb1dIaUgzOXJYWVAydHdSTlBTTjBVV2U0Z1hIS29QeXFtVEE1dFRC?=
 =?utf-8?B?Q3lsejk4MG1rcGNmejBycnVqdVFNcXpGSGhxZkFsMU9BUUNseFRRbTkvdmtI?=
 =?utf-8?B?WmlmWktMbUpwVDY3ZWpGcWVaeFhRcGhKbTg2TVIwSzdNd01ZWWNoZCtWbGxr?=
 =?utf-8?B?MnVLbHF0cXZYRStEeUZzVW1VaHBOK3dLbWducXFvSjdOcmM0RzltRUdsMThr?=
 =?utf-8?B?SkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cefd89e6-6ab9-4a52-058c-08dce3edb505
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6139.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2024 20:55:26.5423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r9uXW8SfE9/gjNvHNMc4nwqd5EwHHYshJfQGzvDNv260CiUcVeEb30oXvlbP0yywfd6bfdLP4JpbuTN1tS0qDhIB3tm2KrbVrVGlQGoblgI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6649
X-OriginatorOrg: intel.com

On Thu, Oct 03, 2024 at 12:48:22PM -0700, Luis Chamberlain wrote:
>+ linux-modules@vger.kernel.org + Lucas
>
>On Mon, Sep 30, 2024 at 07:03:52PM +0200, Aleksandr Mikhalitsyn wrote:
>> On Mon, Sep 30, 2024 at 5:43 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>> >
>> > Hi Aleksandr,
>> >
>> > On Mon, Sep 30, 2024 at 04:43:36PM GMT, Aleksandr Mikhalitsyn wrote:
>> > >On Mon, Sep 30, 2024 at 4:27 PM Stefano Garzarella
>> > ><sgarzare@redhat.com> wrote:
>> > >>
>> > >> On Sun, Sep 29, 2024 at 08:21:03PM GMT, Alexander Mikhalitsyn wrote:
>> > >> >Add an explicit MODULE_VERSION("0.0.1") specification for the vhost_vsock module.
>> > >> >
>> > >> >It is useful because it allows userspace to check if vhost_vsock is there when it is
>> > >> >configured as a built-in.
>> > >> >
>> > >> >This is what we have *without* this change and when vhost_vsock is
>> > >> >configured
>> > >> >as a module and loaded:
>> > >> >
>> > >> >$ ls -la /sys/module/vhost_vsock
>> > >> >total 0
>> > >> >drwxr-xr-x   5 root root    0 Sep 29 19:00 .
>> > >> >drwxr-xr-x 337 root root    0 Sep 29 18:59 ..
>> > >> >-r--r--r--   1 root root 4096 Sep 29 20:05 coresize
>> > >> >drwxr-xr-x   2 root root    0 Sep 29 20:05 holders
>> > >> >-r--r--r--   1 root root 4096 Sep 29 20:05 initsize
>> > >> >-r--r--r--   1 root root 4096 Sep 29 20:05 initstate
>> > >> >drwxr-xr-x   2 root root    0 Sep 29 20:05 notes
>> > >> >-r--r--r--   1 root root 4096 Sep 29 20:05 refcnt
>> > >> >drwxr-xr-x   2 root root    0 Sep 29 20:05 sections
>> > >> >-r--r--r--   1 root root 4096 Sep 29 20:05 srcversion
>> > >> >-r--r--r--   1 root root 4096 Sep 29 20:05 taint
>> > >> >--w-------   1 root root 4096 Sep 29 19:00 uevent
>> > >> >
>> > >> >When vhost_vsock is configured as a built-in there is *no* /sys/module/vhost_vsock directory at all.
>> > >> >And this looks like an inconsistency.
>> > >> >
>> > >> >With this change, when vhost_vsock is configured as a built-in we get:
>> > >> >$ ls -la /sys/module/vhost_vsock/
>> > >> >total 0
>> > >> >drwxr-xr-x   2 root root    0 Sep 26 15:59 .
>> > >> >drwxr-xr-x 100 root root    0 Sep 26 15:59 ..
>> > >> >--w-------   1 root root 4096 Sep 26 15:59 uevent
>> > >> >-r--r--r--   1 root root 4096 Sep 26 15:59 version
>> > >> >
>> > >> >Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
>> > >> >---
>> > >> > drivers/vhost/vsock.c | 1 +
>> > >> > 1 file changed, 1 insertion(+)
>> > >> >
>> > >> >diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> > >> >index 802153e23073..287ea8e480b5 100644
>> > >> >--- a/drivers/vhost/vsock.c
>> > >> >+++ b/drivers/vhost/vsock.c
>> > >> >@@ -956,6 +956,7 @@ static void __exit vhost_vsock_exit(void)
>> > >> >
>> > >> > module_init(vhost_vsock_init);
>> > >> > module_exit(vhost_vsock_exit);
>> > >> >+MODULE_VERSION("0.0.1");
>> > >
>> > >Hi Stefano,
>> > >
>> > >>
>> > >> I was looking at other commits to see how versioning is handled in order
>> > >> to make sense (e.g. using the same version of the kernel), and I saw
>> > >> many commits that are removing MODULE_VERSION because they say it
>> > >> doesn't make sense in in-tree modules.
>> > >
>> > >Yeah, I agree absolutely. I guess that's why all vhost modules have
>> > >had version 0.0.1 for years now
>> > >and there is no reason to increment version numbers at all.
>> >
>> > Yeah, I see.
>> >
>> > >
>> > >My proposal is not about version itself, having MODULE_VERSION
>> > >specified is a hack which
>> > >makes a built-in module appear in /sys/modules/ directory.
>> >
>> > Hmm, should we base a kind of UAPI on a hack?
>>
>> Good question ;-)
>>
>> >
>> > I don't want to block this change, but I just wonder why many modules
>> > are removing MODULE_VERSION and we are adding it instead.
>>
>> Yep, that's a good point. I didn't know that other modules started to
>> remove MODULE_VERSION.
>
>MODULE_VERSION was a stupid idea and there is no real value to it.
>I agree folks should just remove its use and we remove it.

agreed - that should really be gone and shouldn't be used for this
purpose.

>
>> > >I spent some time reading the code in kernel/params.c and
>> > >kernel/module/sysfs.c to figure out
>> > >why there is no /sys/module/vhost_vsock directory when vhost_vsock is
>> > >built-in. And figured out the
>> > >precise conditions which must be satisfied to have a module listed in
>> > >/sys/module.
>> > >
>> > >To be more precise, built-in module X appears in /sys/module/X if one
>> > >of two conditions are met:
>> > >- module has MODULE_VERSION declared
>> > >- module has any parameter declared

I knew about the parameters dir. I didn't know about MODULE_VERSION.

>> >
>> > At this point my question is, should we solve the problem higher and
>> > show all the modules in /sys/modules, either way?
>
>Because if you have no attribute to list why would you? The thing you
>are trying to ask is different: "is this a module built-in" and for that we
>have userpsace solution already suggested: /lib/modules/*/modules.builtin


yeah, that's right. The kernel build system provides that information
and depmod creates and index for lookup. There's both
/lib/modules/*/modules.builtin and modules.builtin.modinfo, which allows
this e.g.:

	$ modinfo simpledrm
	name:           simpledrm
	filename:       (builtin)
	license:        GPL v2
	file:           drivers/gpu/drm/tiny/simpledrm
	description:    DRM driver for simple-framebuffer platform devices

For the libkmod API, you can use kmod_module_get_initstate()

To be honest I was also surprised long ago and thought that it would be
a good idea to have an empty dir for builtin modules... This is what I
added in kmod's TODO file:

	commit 5e690c5cbdebca91998599a2b19542802ae0f7b0
	Author: Lucas De Marchi <lucas.demarchi@profusion.mobi>
	Date:   Fri Dec 16 02:02:58 2011 -0200

	    TODO: add new tasks and notes to future development

	...

	+Things to be added removed in kernel (check what is really needed):
	+===================================================================
	+
	+* list of currently loaded modules

and later expanded on the idea:

	 * list of currently loaded modules
	+       - readdir() in /sys/modules: dirs without a 'initstate' file mean the
	+         modules is builtin.

I still think it would be "a nice to have", however there was never a
pressuring need for implementing it.
	
If we are going to have something like this, then please don't do that
via a dummy module parameter or module version.

Lucas De Marchi

>
>> Probably, yes. We can ask Luis Chamberlain's opinion on this one.
>>
>> +cc Luis Chamberlain <mcgrof@kernel.org>
>
>Please use linux-modules in the future as I'm not the only maintainer.
>
>  Luis

