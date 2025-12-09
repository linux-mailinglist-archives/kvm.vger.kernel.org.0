Return-Path: <kvm+bounces-65536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E52E6CAEC28
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 03:55:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BDEA63031993
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 02:54:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF872FB99A;
	Tue,  9 Dec 2025 02:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZdCSI/Nq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034292FD676
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 02:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765248876; cv=fail; b=IT1mDBFMM3VqGYA1p8ndFtwVKLGlqRdJiWbWatE5yYSnP++dc0qFjroelZEPmqkPDo94SOZD47HqTJAv6F8ktjhJdSF8lqG9NzCSRjgCzF2xUwUReP4AV3ZKXdy2Doc7u3wBY7nlcEE1v/8yKQQET8JSW85RN8Mr6m9hSduPxLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765248876; c=relaxed/simple;
	bh=GBxaJ+CHdOMI/0D6/6w23OfRVfSt95TDog5BfqhDQd8=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tsmcbknKK/84722pnY93V0y3clnEJ4M/Ac5lGSNhp9TGCAUYOgzQw1LtFYhZZTQy4vUsoNWEF+iDjNC5ccF3R5LE/+gZNoEhGWlGPCSWvzPpWPyVCvqziNKarClrHNeAHfEHM5do6MzS2x4V4MTmzqI12fkvW9FMbWvp7Q0tud8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZdCSI/Nq; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765248873; x=1796784873;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=GBxaJ+CHdOMI/0D6/6w23OfRVfSt95TDog5BfqhDQd8=;
  b=ZdCSI/NqxBEpRsRJ3DV3Gfs/Ci+wWKrh5lkJKrYSQEQk7U840UaA4Isf
   imcYGky31Yj5lMhgToTw9/ObF/reRtuBnWIdzskOcwvUvLM5vdlRHSnLY
   VqzXIpX0zNlHClczz6HyGah8xqQxFFrwdmDrX4FZZEh3S4Wx5u8dnruan
   JJhJmZfyJ4KwD4FALXLjejBZnXFXC6S6TzS6j8VqJSDvCCf6BDBI4yW51
   w8WfyCh4M+xUp95GLzVS5RipuhbequNzJ7wkkTPvbdoasoPQauC77GDUh
   67Bolz8oYDBLXGUb8/rJ1TuwCFUn8ZFVyZye2QZtYbYkbQ9MweLeVDwqn
   g==;
X-CSE-ConnectionGUID: 6mS3u5K0R5KkmB0FhvEL+A==
X-CSE-MsgGUID: xip2YXcETIKsfTMvTe/1pw==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="71055937"
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="71055937"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 18:54:32 -0800
X-CSE-ConnectionGUID: +/OwUb6ATaqNHAfxi1gxLw==
X-CSE-MsgGUID: uxe+nGkMTCiB0U8D+ff+dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="195383238"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 18:54:33 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 18:54:31 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 8 Dec 2025 18:54:31 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.46) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 18:54:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yCjBwNhcEkUY+12m6t6qwtUrzaEvt2s9Bcog3JR0rjvWTfeH5+MF+o85aJfB1eHqlmaLIAGz2IEfJ0CcwmNxXozZ/MRwQpawqD5iYFZXw38Uy9wtroNAdjpMe1R448UWFhwcHKEW4Sk4YLltwic2X8WwC+5JPbUatWvIfwTqiRk8GR2SB+B8BSqsmKwKW6xjwk/HjvfYeKgys/AMPBqPJd3qnsGej3Rz23IOsijZZSevFaCZP/n3+AxemN3QZokxyJF4QJdzHI+J4cG25fh6gGbk2Ww0CFIyi4RhNagtF4zYGkQoj62avSft+p+eAyiCJIp9bfUET8CFOEHLX2PwIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GBxaJ+CHdOMI/0D6/6w23OfRVfSt95TDog5BfqhDQd8=;
 b=GNM33sBqSAPWWHACCGTIAx4hcWSJigLXbSj7oEVJbfpo/1Jc77JQjMd24VEXaZDL8uEkI/LjZZWzvTidzHMMe3+DJuoxnEvexEcrYl9/ftjX2mp/iQCROOUPNcYVr23PDkIyUri3knABP/3GMNDz8I+mVkoX2YCfr/W5Nvs1rFKIY6fGNnAayZ99JT7vthn+BkqIRQxKf8pC/caW6bflc3cLLzMkP5uFaguDlUwofRLaQ3vYVRGXiVFACdwxrRjSpxB7H6skwO46CzQeSX50DdFFaK1hY/uMunGCWRuYIu51fnTSp3qjJY2yvW0ugPv6zCoNLLcT98InpfG7qKQFGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH3PR11MB8316.namprd11.prod.outlook.com (2603:10b6:610:17b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 02:54:29 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9412.005; Tue, 9 Dec 2025
 02:54:29 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "bugzilla-daemon@kernel.org" <bugzilla-daemon@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [Bug 220740] Host crash when do PF passthrough to KVM guest with
 some devices
Thread-Topic: [Bug 220740] Host crash when do PF passthrough to KVM guest with
 some devices
Thread-Index: AQHcTeedeUKDEeE3tU6pTbelyspn9LUYzbUQ
Date: Tue, 9 Dec 2025 02:54:29 +0000
Message-ID: <BN9PR11MB52763E1F73B1F982922D29FA8CA3A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <bug-220740-28872@https.bugzilla.kernel.org/>
 <bug-220740-28872-OFut6o5vJZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220740-28872-OFut6o5vJZ@https.bugzilla.kernel.org/>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH3PR11MB8316:EE_
x-ms-office365-filtering-correlation-id: a1dc77dc-61ff-426e-b508-08de36ce45cd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?dU5QTitsOFg0ZVc4NXhRUVpoWS9iZEhhT2FnTzBzVUM3dTJuUTV2ZTFBcFJw?=
 =?utf-8?B?R01TcFpkVTVIaGxoeE96dEU3RHBWU05qTkhqZnRVV0ZOdHgyblQzRnVhZXRR?=
 =?utf-8?B?bHNXbXQzM1JxUzBPWlFWaHk2U1IvNWE1VjBxUUtTOGtYd0gySlI4dmxnZ3FZ?=
 =?utf-8?B?RlV6MUFwSG9jUW5nQXAvWTlMVXlyWW9nRTdiSmhhMmE0a3Y3RmRjSDFVbTBE?=
 =?utf-8?B?NlpmS0VwaVZPS21JTGUrKzY5UU9jWklJNFF2S0RiaGx3MFlEazRLNURFZ0pB?=
 =?utf-8?B?enUvK0R4Ym5VNDJCN1l3dHBSVVRQTkV1b2JEYnF4VCs2aGlNQkhldi80dkNi?=
 =?utf-8?B?Ry9TbGpFTGplU2xIb3pOT0h6bjNFM243OXliV01WUW11NEM3VG42d3BKZXNS?=
 =?utf-8?B?bXNmT1dYclBJVFNkaXY1VjJDUmEzd0gwV2JpNXBSU1IwcTVjbEd0MHNRT3ds?=
 =?utf-8?B?bEFhS2hoUTlFTFRlUWlOK1paSVhONGRmNVJQMjMxU2x3dENyQjU0bnJOSDY4?=
 =?utf-8?B?YVB2S2xWTEd6Sm9BTTY3bzlkbEg0TGdmUENKZXp0S1N3QUxVWXpvcGdiamdQ?=
 =?utf-8?B?eEYzc0cvQXFiLytDUUdIOUcrK2wxV0s2cHBvVVc0ZUYyUzlEYmt0Ulp6RHk4?=
 =?utf-8?B?cGFuVTZKa2pESDRDK3dkWlJSempFUkc2U2NlUzVQQlFUbmRGeStqVkNOY1FB?=
 =?utf-8?B?ZlJYSlE5Ulh5VHd5VG5tQXRMbk1XUHBDbFp0M0padlpWUnZqcFppb1U3ZmxD?=
 =?utf-8?B?czJpK1FhS2tNS0Z2cEc3RkptSDQ1cWNJU3RZUi9YQ0VYVzRNWWFCRlVLYmFu?=
 =?utf-8?B?dXhrZWh4Y1IzNk40UzM4cG1HcjFrTnZ1VHRCVXI0b0Zvanh3N0RqYnpJV0E1?=
 =?utf-8?B?SmlxM3FxSk5xbkZZU0xCQVRlNWxHNXNuT1BXVmk2UzVoajNEaFV3emtIT0Rv?=
 =?utf-8?B?NUYvWXFnTmlxdE5QWFhTUklyVzVvTnBDSkNVd0JyK1NMVmw4SDEwQU5KVmFM?=
 =?utf-8?B?V2oxWjdZZkc1MmVYZkQ1YkVRZDlxaFNDSHFwSXBDRTVIWTBWRjhYVC9jZXJU?=
 =?utf-8?B?NmJJeVFoYXJRaEV6V1RCTUx4VHFLUThFTlQ4UVNXV1hOUmg5c01TTnhNanh5?=
 =?utf-8?B?bVVsUURGQUlPWXlLOFN3VDNYY3BsRU52M0JOeG1FSW8wQUF0Q0J4ZS9MaWsv?=
 =?utf-8?B?bDNGSW56RzlWVURnaUhvYWkwdnVEeDZldmdHNjNGM3ZXVXExb3Nsazcxa2Ru?=
 =?utf-8?B?TWJlWW9YWkx4amJ1YjNVNVNxY0tyS3RqR2o0d2xnbW9sZCtlLzg0aVpNYTFR?=
 =?utf-8?B?aXBUNkpCY2FBZUVXNWQ0bTRTQytxV0tCSUFFeDN5VDA5WUwxV0sxRUgrZGVk?=
 =?utf-8?B?TXpha0FpZUhqRGl2Qzh2eWlPMENKa0I1aVNyZTRtZ1QvVk80ZjRObHgxOFBU?=
 =?utf-8?B?UndPTWhvQ20zT2V4bHlmRm5TaEhsSlUwUXRYaERFeWgweXgweFBvclcwNklh?=
 =?utf-8?B?d2Z1SVZMVHh3ekViaS85U3UzVTQ2QXZRaFpWQ1pLbGUrWFp6Lzk0Zi9KbkRG?=
 =?utf-8?B?aEs1WmF6eHFuWm1wWWIxaFVUYkhNdnNYV0srNGVVRXo2UUxGamVBWWI3NjNt?=
 =?utf-8?B?ZnhRSDF0OWVmWnUvZExrdmhiRk5NRmJVWGQzL3doWSs0TWZaQ1RRckxjaFA5?=
 =?utf-8?B?TTZUT0h2SWRCRnptQk9LbXdmTityZWV3YXkvSloxWFoyY0xWbms5UlJkZlB3?=
 =?utf-8?B?dEcyZVR5Q2NqZXNaK2FYK3ZBaHl1Z0x5cGJKZW9IZzZpNVpVN3NlSzFRUVVv?=
 =?utf-8?B?WEg4MUF3ellsZitsZm1RWHlMVnpUQXZHankvOXYzM0FuS04yUzRpZzdlY09o?=
 =?utf-8?B?QXNXSUhoRHJaZDBudmtGbUZYczBOUU9GWnZpZzVXMHdXNUJwbDFiYWRWRjRk?=
 =?utf-8?B?TTJrcVVnREdVekFweGxuaHl5YTNsZ3A2Ukc4VUh0MXk5eGR1eW9BR08yN1pM?=
 =?utf-8?B?d3U1eVg3QXlCYzZzNCt5dTVCMXVKNDNVWHl3Uk4ydTVWd00wUEx6cmF4Nk8w?=
 =?utf-8?Q?g7Zfrt?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a2FNYWxFVCtNYnl0VVBlMk5kV0R3TzY0WUhqL1ZyVkVvV3dlU2RLeDl0L1kv?=
 =?utf-8?B?bkcrR0pUVERKclJneGNETm9vWlRtdUZNbHpybDRwUGZ0V0dNT1hHdGlzOG40?=
 =?utf-8?B?VS85OFFOUjVQOWN2bUZ6ZTY5NFNEMnQ0Z0dyY3BsNUE3eGZyL3IvaDYzaFhp?=
 =?utf-8?B?TmEvSXh3NGFCTXY1YWhQQ1dmSy9HK0VtZnllQ2xBbzhWNlNIWnBEUGZkZGZJ?=
 =?utf-8?B?M3RDOVpiOUVHR3Y5dWp2QXNvSmY4WnF2bXY2dzJ4RWdoclVkcEc2ZGozeEFU?=
 =?utf-8?B?RThuTWxHWXRVanVPMVV3Ry9qMm5OREFkVXlOTWI1eVJtdXdiNDRDSTlWSGo2?=
 =?utf-8?B?QUdxQkhTWmxFNUdycXhNZGdKQjR1RHNvVHZhZzE2YkNZTWp3QVJBT0ZPcFVS?=
 =?utf-8?B?Uys1MmNteWtybTZQWlpDaFd5UmtCRDdkTUJycTl0eXhuc2hNSXRtVWNUaGJV?=
 =?utf-8?B?VjZ3NFBWK2tWaWdBelgyRzBmanUzcVNqTmZMUmowUnhFNnJybzVXdndKcU9O?=
 =?utf-8?B?N2ExekY1NE5RTGJCWUhQb2w4eWtZbkJyT0tJVjkyVFo0T3NmalZxRlk2SU15?=
 =?utf-8?B?OWNYVHBva1RJRXRjQlBLQjk2akJmODJEZHVyRUovQ3MxRHFJWmlCRXU4clMz?=
 =?utf-8?B?MDNwWUFrRkttR28xSzRDck5FYkg0TEhWeS9UdWc3Q1pjRHBuRnlFTGdCRnFD?=
 =?utf-8?B?RDNRWjdxNXU2ZnRkZ0hBZzBBdW5iakk2Z1hSbmJEQkZ5VUc5T3pibUtJeTBX?=
 =?utf-8?B?a01iQ3owbnpJZUdCaC9ubGV6M016VzlxWFV0VDdZeFRrYzZ5WGM3emJLWmJz?=
 =?utf-8?B?VTJXMzFLNTF6YUVjQ1oycktINjF4ajNXbEY4OEpYU0x2bmZLOG9mM0k5Z3dm?=
 =?utf-8?B?d1FGSGk1dzhoRjVLVG1lQzlMcVBERGhUSDhKaVlVTUl0TlBqR3I4WHV0QUlo?=
 =?utf-8?B?VTBrbU5qNmtTbFRDSm5aelZoMGpQdzcrUXhCaXVVKzlNK1NZL1MzMWJmbkV6?=
 =?utf-8?B?c2c0VXdMZ1V5RXEwV3h1d2NHNjR3RlFNRVp1TkhIM0VvNnpBRlkybk1vY0Zn?=
 =?utf-8?B?UjRCRHdzYnRIdUJCRENscm9scHZ1YlpNd1JkSU9oeU0wNzU2UmRhWUdleUdi?=
 =?utf-8?B?NEJza0h6NWxMNzNCVm1TZXdLSWpXS2J2L1JOK2QrMHl5WFk3WFZ0VTVWQTBG?=
 =?utf-8?B?ekwvcUVDWkUwZGtzeEZnRm9zTXAwK1l3TG1mcDN5U2o0cVRkM2w3MmFZanhw?=
 =?utf-8?B?R2I3aElYc0xWMG4vTDJ3cDkwRkNhUTBob1FzejBaRDlicFk3allGU0x0ZmNU?=
 =?utf-8?B?UTUvWnpreUd2bGp6VVFNYjROd3VnUkZBZmppS1JoQnpndEU5S0NlU3M3S2g5?=
 =?utf-8?B?VWV0WUd0bjNhcnFGemwrNGlPaFI5Z3U0amxuNU9jc2pTaU5OdWFSZmkyVFpS?=
 =?utf-8?B?SENvS05uZExxdTFKNXk0Y3Y3OWxmUzJRbEV4Ukp5aHlpZ1NQeTcrZTlPZWhy?=
 =?utf-8?B?eHpvZENuQm8wSFczNnZsNUpsVC85ZS9UQ1QxN09sUmhEWHRydmxaUjdXeXM5?=
 =?utf-8?B?V0R2RGc4cUhqaDdETjFUc3dhc0VQRk5wNjNOYVRMUVlob1A3RFBUbGFBSFlM?=
 =?utf-8?B?eG1oMlRSUUxMdHllSzdsQmMvMXcxeVA5bmI0RGpSVTVCNXVZVk16a1BBUEN2?=
 =?utf-8?B?ekRXSXo4WE9qWWxhS1ViR0JhY241V0kwdERDVEF1cXMxL0ZBSVBkdlRzV1N5?=
 =?utf-8?B?V0RmbWNxWDJndERxQzQ0QXl0REdQYzVsRmQreGNweFIrUER4a00xdUs0bnJt?=
 =?utf-8?B?N2dqdytYR3VtWEl1cnFiY25yZzhNSlZObEZKTC9iT3lvM1lVZE9TOHl0UUxr?=
 =?utf-8?B?NkVIV0FZMmNOOEQ4WHcwemkxT3J4M1FGbVBWaWRFM1pBRy84dlJpNHZqOWpv?=
 =?utf-8?B?aStUeGpibkFxVEtCVnBqL0NKYkxhanlNNThwd2lFK210MzFSSmIraEI2Qnph?=
 =?utf-8?B?R1NndmtEZXpFbi9ERVpPSmRZRUpQVUdkcSt0bklNbjFya1R2eVhXNnVrRFFZ?=
 =?utf-8?B?U1hyOHZSSktIRDFKSERWQXprNWlVRGZMQ1lqRUpremRUdGdZbzVlY2RtRXAx?=
 =?utf-8?Q?mX5yBNQLAmG77zhEjN045ds3v?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a1dc77dc-61ff-426e-b508-08de36ce45cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2025 02:54:29.5328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8Q2YlFm/UMOJlaxLUrnXySvY9GYUk2dNwepeXUZttT7F8z/LbY9GyiqVCXf4NhD/j0kF8vg50R4Uk7goehVjZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8316
X-OriginatorOrg: intel.com

PiBGcm9tOiBidWd6aWxsYS1kYWVtb25Aa2VybmVsLm9yZyA8YnVnemlsbGEtZGFlbW9uQGtlcm5l
bC5vcmc+DQo+IFNlbnQ6IFdlZG5lc2RheSwgTm92ZW1iZXIgNSwgMjAyNSA4OjAzIEFNDQo+IA0K
PiBodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTIyMDc0MA0KPiAN
Cj4gLS0tIENvbW1lbnQgIzUgZnJvbSBBbGV4IFdpbGxpYW1zb24gKGFsZXgubC53aWxsaWFtc29u
QGdtYWlsLmNvbSkgLS0tDQo+IEkgaGF2ZSBhbiBYNzEwLCBidXQgbm90IGEgc3lzdGVtIHRoYXQg
Y2FuIHJlcHJvZHVjZSB0aGUgaXNzdWUuDQo+IA0KPiBBbHNvIEkgbmVlZCB0byBjb3JyZWN0IG15
IHByZXZpb3VzIHN0YXRlbWVudCBhZnRlciB1bnRhbmdsaW5nIHRoZSBoZWFkZXJzLg0KPiBUaGlz
IGNvbW1pdCBkaWQgaW50cm9kdWNlIDgtYnl0ZSBhY2Nlc3Mgc3VwcG9ydCBmb3IgYXJjaHMgaW5j
bHVkaW5nIHg4Nl82NA0KPiB3aGVyZSB0aGV5IGRvbid0IG90aGVyd2lzZSBkZWZpbmVkIGEgaW9y
ZWFkL3dyaXRlNjQgc3VwcG9ydC4gIFRoaXMgYWNjZXNzDQo+IHVzZXMNCj4gcmVhZHEvd3JpdGVx
LCB3aGVyZSBwcmV2aW91c2x5IHdlJ2QgdXNlIHBhaXJzIG9yIHJlYWRsL3dyaXRlbC4gIFRoZQ0K
PiBleHBlY3RhdGlvbg0KPiBpcyB0aGF0IHdlJ3JlIG1vcmUgY2xvc2VseSBtYXRjaGluZyB0aGUg
YWNjZXNzIGJ5IHRoZSBndWVzdC4NCj4gDQo+IEknbSBjdXJpb3VzIGhvdyB3ZSdyZSBnZXR0aW5n
IGludG8gdGhpcyBjb2RlIGZvciBhbiBYNzEwIHRob3VnaCwgbWluZSBzaG93cw0KPiBCQVJzIGFz
Og0KPiANCj4gMDM6MDAuMCBFdGhlcm5ldCBjb250cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiBF
dGhlcm5ldCBDb250cm9sbGVyIFg3MTAgZm9yDQo+IDEwR2JFIFNGUCsgKHJldiAwMSkNCj4gICAg
ICAgICBSZWdpb24gMDogTWVtb3J5IGF0IDM4MDAwMDAwMDAwMCAoNjQtYml0LCBwcmVmZXRjaGFi
bGUpIFtzaXplPThNXQ0KPiAgICAgICAgIFJlZ2lvbiAzOiBNZW1vcnkgYXQgMzgwMDAxODAwMDAw
ICg2NC1iaXQsIHByZWZldGNoYWJsZSkgW3NpemU9MzJLXQ0KPiANCj4gVGhvc2Ugd291bGQgdHlw
aWNhbGx5IGJlIG1hcHBlZCBkaXJlY3RseSBpbnRvIHRoZSBLVk0gYWRkcmVzcyBzcGFjZSBhbmQN
Cj4gbm90DQo+IGZhdWx0IHRocm91Z2ggUUVNVSB0byB0cmlnZ2VyIGFjY2VzcyB0aHJvdWdoIHRo
aXMgY29kZS4NCg0KV2UgaGF2ZSB2ZXJpZmllZCB0aGlzIHByb2JsZW0gY2F1c2VkIGJ5IDgtYnl0
ZSBhY2Nlc3MgdG8gdGhlIHJvbSBiYXI6DQoNCiAgICBFeHBhbnNpb24gUk9NIGF0IDkzNDgwMDAw
IFtkaXNhYmxlZF0gW3NpemU9NTEyS10NCg0KRXZlcnkgcXdvcmQgYWNjZXNzIHRvIHRoYXQgcmFu
Z2UgdHJpZ2dlcnMgYSBkb3plbnMgb2YgUENJIEFFUiByZWxhdGVkDQpwcmludHMgdGhlbiBpbiB0
b3RhbCA2NEsgcmVhZHMgZnJvbSBRZW11IGxlYWQgdG8gbWFueSBtYW55IHByaW50cyB0aGVuDQp0
aGUgaG9zdCBpcyBub3QgcmVzcG9uc2l2ZS4NCg0KVGhlcmUgaXMgaW5kZWVkIG5vIGFjY2VzcyB0
byBiYXIwL2JhcjMgaW4gdGhpcyBwYXRoLg0KDQpEaXNhYmxpbmcgIlBDSUUgRXJyb3IgRW5hYmxp
bmciIGluIEJJT1MganVzdCByZW1vdmVzIHRoZSBwcmludHMgdG8gaGlkZQ0KdGhlIGlzc3VlLg0K
DQpVcGRhdGluZyB0byBsYXRlc3QgWDcxMCBmaXJtd2FyZSBkaWRuJ3QgaGVscCBhbmQgd2UgZGlk
bid0IGZpbmQgYW4gZXhwbGljaXQNCmVycmF0YSB0YWxraW5nIGFib3V0IHRoaXMgZHdvcmQgbGlt
aXRhdGlvbi4gDQoNCkl0IGlzIGRpZmZpY3VsdCB0byBpZGVudGlmeSBhbGwgcG9zc2libGUgZGV2
aWNlcyBzdWZmZXJpbmcgZnJvbSB0aGlzIGlzc3VlLCBzbyBhDQpzYWZlci9zaW1wbGVyIHdheSBp
cyB0byB1bml2ZXJzYWxseSBkaXNhYmxlIDgtYnl0ZSBhY2Nlc3MgdG8gdGhlIHJvbSBiYXIsDQpl
LmcuIGFzIGJlbG93Og0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL3BjaS9udmdyYWNlLWdw
dS9tYWluLmMgYi9kcml2ZXJzL3ZmaW8vcGNpL252Z3JhY2UtZ3B1L21haW4uYw0KaW5kZXggZTM0
NjM5MmI3MmY2Li45YjM5MTg0Zjc2YjcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3ZmaW8vcGNpL252
Z3JhY2UtZ3B1L21haW4uYw0KKysrIGIvZHJpdmVycy92ZmlvL3BjaS9udmdyYWNlLWdwdS9tYWlu
LmMNCkBAIC00OTEsNyArNDkxLDcgQEAgbnZncmFjZV9ncHVfbWFwX2FuZF9yZWFkKHN0cnVjdCBu
dmdyYWNlX2dwdV9wY2lfY29yZV9kZXZpY2UgKm52ZGV2LA0KIAkJcmV0ID0gdmZpb19wY2lfY29y
ZV9kb19pb19ydygmbnZkZXYtPmNvcmVfZGV2aWNlLCBmYWxzZSwNCiAJCQkJCSAgICAgbnZkZXYt
PnJlc21lbS5pb2FkZHIsDQogCQkJCQkgICAgIGJ1Ziwgb2Zmc2V0LCBtZW1fY291bnQsDQotCQkJ
CQkgICAgIDAsIDAsIGZhbHNlKTsNCisJCQkJCSAgICAgMCwgMCwgZmFsc2UsIHRydWUpOw0KIAl9
DQogDQogCXJldHVybiByZXQ7DQpAQCAtNjA5LDcgKzYwOSw3IEBAIG52Z3JhY2VfZ3B1X21hcF9h
bmRfd3JpdGUoc3RydWN0IG52Z3JhY2VfZ3B1X3BjaV9jb3JlX2RldmljZSAqbnZkZXYsDQogCQly
ZXQgPSB2ZmlvX3BjaV9jb3JlX2RvX2lvX3J3KCZudmRldi0+Y29yZV9kZXZpY2UsIGZhbHNlLA0K
IAkJCQkJICAgICBudmRldi0+cmVzbWVtLmlvYWRkciwNCiAJCQkJCSAgICAgKGNoYXIgX191c2Vy
ICopYnVmLCBwb3MsIG1lbV9jb3VudCwNCi0JCQkJCSAgICAgMCwgMCwgdHJ1ZSk7DQorCQkJCQkg
ICAgIDAsIDAsIHRydWUsIHRydWUpOw0KIAl9DQogDQogCXJldHVybiByZXQ7DQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9yZHdyLmMgYi9kcml2ZXJzL3ZmaW8vcGNpL3Zm
aW9fcGNpX3Jkd3IuYw0KaW5kZXggNjE5Mjc4OGM4YmEzLi4zNDY3MTUxYTYzMmQgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX3Jkd3IuYw0KKysrIGIvZHJpdmVycy92Zmlv
L3BjaS92ZmlvX3BjaV9yZHdyLmMNCkBAIC0xMzUsNyArMTM1LDcgQEAgVkZJT19JT1JEV1IoNjQp
DQogc3NpemVfdCB2ZmlvX3BjaV9jb3JlX2RvX2lvX3J3KHN0cnVjdCB2ZmlvX3BjaV9jb3JlX2Rl
dmljZSAqdmRldiwgYm9vbCB0ZXN0X21lbSwNCiAJCQkgICAgICAgdm9pZCBfX2lvbWVtICppbywg
Y2hhciBfX3VzZXIgKmJ1ZiwNCiAJCQkgICAgICAgbG9mZl90IG9mZiwgc2l6ZV90IGNvdW50LCBz
aXplX3QgeF9zdGFydCwNCi0JCQkgICAgICAgc2l6ZV90IHhfZW5kLCBib29sIGlzd3JpdGUpDQor
CQkJICAgICAgIHNpemVfdCB4X2VuZCwgYm9vbCBpc3dyaXRlLCBib29sIGFsbG93X3F3b3JkKQ0K
IHsNCiAJc3NpemVfdCBkb25lID0gMDsNCiAJaW50IHJldDsNCkBAIC0xNTAsNyArMTUwLDcgQEAg
c3NpemVfdCB2ZmlvX3BjaV9jb3JlX2RvX2lvX3J3KHN0cnVjdCB2ZmlvX3BjaV9jb3JlX2Rldmlj
ZSAqdmRldiwgYm9vbCB0ZXN0X21lbSwNCiAJCWVsc2UNCiAJCQlmaWxsYWJsZSA9IDA7DQogDQot
CQlpZiAoZmlsbGFibGUgPj0gOCAmJiAhKG9mZiAlIDgpKSB7DQorCQlpZiAoYWxsb3dfcXdvcmQg
JiYgZmlsbGFibGUgPj0gOCAmJiAhKG9mZiAlIDgpKSB7DQogCQkJcmV0ID0gdmZpb19wY2lfaW9y
ZHdyNjQodmRldiwgaXN3cml0ZSwgdGVzdF9tZW0sDQogCQkJCQkJaW8sIGJ1Ziwgb2ZmLCAmZmls
bGVkKTsNCiAJCQlpZiAocmV0KQ0KQEAgLTIzNCw2ICsyMzQsNyBAQCBzc2l6ZV90IHZmaW9fcGNp
X2Jhcl9ydyhzdHJ1Y3QgdmZpb19wY2lfY29yZV9kZXZpY2UgKnZkZXYsIGNoYXIgX191c2VyICpi
dWYsDQogCXZvaWQgX19pb21lbSAqaW87DQogCXN0cnVjdCByZXNvdXJjZSAqcmVzID0gJnZkZXYt
PnBkZXYtPnJlc291cmNlW2Jhcl07DQogCXNzaXplX3QgZG9uZTsNCisJYm9vbCBhbGxvd19xd29y
ZCA9IHRydWU7DQogDQogCWlmIChwY2lfcmVzb3VyY2Vfc3RhcnQocGRldiwgYmFyKSkNCiAJCWVu
ZCA9IHBjaV9yZXNvdXJjZV9sZW4ocGRldiwgYmFyKTsNCkBAIC0yNjIsNiArMjYzLDE1IEBAIHNz
aXplX3QgdmZpb19wY2lfYmFyX3J3KHN0cnVjdCB2ZmlvX3BjaV9jb3JlX2RldmljZSAqdmRldiwg
Y2hhciBfX3VzZXIgKmJ1ZiwNCiAJCWlmICghaW8pDQogCQkJcmV0dXJuIC1FTk9NRU07DQogCQl4
X2VuZCA9IGVuZDsNCisNCisJCS8qDQorCQkgKiBDZXJ0YWluIGRldmljZXMgKGUuZy4gSW50ZWwg
WDcxMCkgZG9uJ3Qgc3VwcG9ydCA4LWJ5dGUgYWNjZXNzDQorCQkgKiB0byB0aGUgUk9NIGJhci4g
T3RoZXJ3aXNlIFBDSSBBRVIgZXJyb3JzIG1pZ2h0IGJlIHRyaWdnZXJlZC4NCisJCSAqDQorCQkg
KiBEaXNhYmxlIHF3b3JkIGFjY2VzcyB0byB0aGUgUk9NIGJhciB1bml2ZXJzYWxseSwgd2hpY2gg
aGFzIGJlZW4NCisJCSAqIHdvcmtpbmcgcmVsaWFibHkgZm9yIHllYXJzIGJlZm9yZSA4LWJ5dGUg
YWNjZXNzIGlzIGVuYWJsZWQuDQorCQkgKi8NCisJCWFsbG93X3F3b3JkID0gZmFsc2U7DQogCX0g
ZWxzZSB7DQogCQlpbnQgcmV0ID0gdmZpb19wY2lfY29yZV9zZXR1cF9iYXJtYXAodmRldiwgYmFy
KTsNCiAJCWlmIChyZXQpIHsNCkBAIC0yNzgsNyArMjg4LDcgQEAgc3NpemVfdCB2ZmlvX3BjaV9i
YXJfcncoc3RydWN0IHZmaW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2LCBjaGFyIF9fdXNlciAqYnVm
LA0KIAl9DQogDQogCWRvbmUgPSB2ZmlvX3BjaV9jb3JlX2RvX2lvX3J3KHZkZXYsIHJlcy0+Zmxh
Z3MgJiBJT1JFU09VUkNFX01FTSwgaW8sIGJ1ZiwgcG9zLA0KLQkJCQkgICAgICBjb3VudCwgeF9z
dGFydCwgeF9lbmQsIGlzd3JpdGUpOw0KKwkJCQkgICAgICBjb3VudCwgeF9zdGFydCwgeF9lbmQs
IGlzd3JpdGUsIGFsbG93X3F3b3JkKTsNCiANCiAJaWYgKGRvbmUgPj0gMCkNCiAJCSpwcG9zICs9
IGRvbmU7DQpAQCAtMzUyLDcgKzM2Miw3IEBAIHNzaXplX3QgdmZpb19wY2lfdmdhX3J3KHN0cnVj
dCB2ZmlvX3BjaV9jb3JlX2RldmljZSAqdmRldiwgY2hhciBfX3VzZXIgKmJ1ZiwNCiAJICogdG8g
dGhlIG1lbW9yeSBlbmFibGUgYml0IGluIHRoZSBjb21tYW5kIHJlZ2lzdGVyLg0KIAkgKi8NCiAJ
ZG9uZSA9IHZmaW9fcGNpX2NvcmVfZG9faW9fcncodmRldiwgZmFsc2UsIGlvbWVtLCBidWYsIG9m
ZiwgY291bnQsDQotCQkJCSAgICAgIDAsIDAsIGlzd3JpdGUpOw0KKwkJCQkgICAgICAwLCAwLCBp
c3dyaXRlLCB0cnVlKTsNCiANCiAJdmdhX3B1dCh2ZGV2LT5wZGV2LCByc3JjKTsNCiANCmRpZmYg
LS1naXQgYS9pbmNsdWRlL2xpbnV4L3ZmaW9fcGNpX2NvcmUuaCBiL2luY2x1ZGUvbGludXgvdmZp
b19wY2lfY29yZS5oDQppbmRleCBmNTQxMDQ0ZTQyYTIuLjNhNzViNzZlYWVkMyAxMDA2NDQNCi0t
LSBhL2luY2x1ZGUvbGludXgvdmZpb19wY2lfY29yZS5oDQorKysgYi9pbmNsdWRlL2xpbnV4L3Zm
aW9fcGNpX2NvcmUuaA0KQEAgLTEzMyw3ICsxMzMsNyBAQCBwY2lfZXJzX3Jlc3VsdF90IHZmaW9f
cGNpX2NvcmVfYWVyX2Vycl9kZXRlY3RlZChzdHJ1Y3QgcGNpX2RldiAqcGRldiwNCiBzc2l6ZV90
IHZmaW9fcGNpX2NvcmVfZG9faW9fcncoc3RydWN0IHZmaW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2
LCBib29sIHRlc3RfbWVtLA0KIAkJCSAgICAgICB2b2lkIF9faW9tZW0gKmlvLCBjaGFyIF9fdXNl
ciAqYnVmLA0KIAkJCSAgICAgICBsb2ZmX3Qgb2ZmLCBzaXplX3QgY291bnQsIHNpemVfdCB4X3N0
YXJ0LA0KLQkJCSAgICAgICBzaXplX3QgeF9lbmQsIGJvb2wgaXN3cml0ZSk7DQorCQkJICAgICAg
IHNpemVfdCB4X2VuZCwgYm9vbCBpc3dyaXRlLCBib29sIGFsbG93X3F3b3JkKTsNCiBib29sIHZm
aW9fcGNpX2NvcmVfcmFuZ2VfaW50ZXJzZWN0X3JhbmdlKGxvZmZfdCBidWZfc3RhcnQsIHNpemVf
dCBidWZfY250LA0KIAkJCQkJIGxvZmZfdCByZWdfc3RhcnQsIHNpemVfdCByZWdfY250LA0KIAkJ
CQkJIGxvZmZfdCAqYnVmX29mZnNldCwNCg==

