Return-Path: <kvm+bounces-39655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B251EA491BD
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 07:44:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A17D41893160
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 06:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61ED91C5485;
	Fri, 28 Feb 2025 06:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FCKeqHMq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1FC1C07D8
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 06:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740725053; cv=fail; b=fesy+pj96hpkg0wMOqYgNwaeHVL0fmziY/cEn+IER30o0QAh6t73on2pJXHVL+XGlljztXOxKWKUUIx1g8cGDaZahXsEM+g5xuGe2A/fdpKCB7V0JyIIjcFUpJ0A+Msi2GBFKcsUvfDHrMhvIr7d5HmoU6VQZx3RKwKHn3uC6C4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740725053; c=relaxed/simple;
	bh=Petppoy66yXbQIRyDUwPkHv4FM+QIRrkILYTEzOMMvM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=phmqKohgpUi5g+oal71lXdZ0RFFJa1UUiTxyw3hYUMEKPioyRsF/SBKhrEfO+v00P2UNPf7TLSaGmKVqx+GSh2UVtFNFiaJXOB7WeJGadKXwZmXh9louCd7llC5Z4thSOBmeVaL2F08ogv1QpVxGjerdeflFgeLoiMLb2DPBrSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FCKeqHMq; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740725052; x=1772261052;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Petppoy66yXbQIRyDUwPkHv4FM+QIRrkILYTEzOMMvM=;
  b=FCKeqHMqPyrcxB1FWNe0NgY4q7ec/WNDJobxIPr6LX8TILtRO+IaYhUJ
   i1sDXikMfL4BzrgeFHMn1uYmntVZ8SjNCaBbJ6Eebu9CK3k1igc1+/nx6
   tzbob3mQpn3sh0oR/D4qEhHVzTxlHg/3K/WxEF6SDG+0829pV8ANkjQPR
   bpOVhc6PKucRPf6I70VAY9hxpwxrgGn/bscd0H4OaVsJf/prvbdIDujuP
   OeMINx7BlSsoL7N8zrWjNcy7XLSWBwS10XXxHmIs9KYehDpeQTij4y3vI
   UPBW8Z2HplScaytDWpI1OT8oyKWbCIla+DgFW4RkpDrFbBoqKSdzJzYK3
   w==;
X-CSE-ConnectionGUID: J/hVNt0pQPqD7N9ZO4dF6A==
X-CSE-MsgGUID: TYFICiyhQCOYaQbEGYU3vA==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="44461177"
X-IronPort-AV: E=Sophos;i="6.13,321,1732608000"; 
   d="scan'208";a="44461177"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 22:44:11 -0800
X-CSE-ConnectionGUID: HtAOwHTWTg6rTahRQLqnNg==
X-CSE-MsgGUID: CqvdSTiLT6OzmD6GfAq6mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,321,1732608000"; 
   d="scan'208";a="117015475"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 22:44:11 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 27 Feb 2025 22:44:10 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 27 Feb 2025 22:44:10 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 27 Feb 2025 22:44:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QVT0aL6Kd7t+/0XCiqidP2KrbHHpkzyYoDeTCeBdEI2fQxH+ColezkPxEVivtMbBi4bkqS0GcX70Nj7GH2e4xoXx5HvANzKTusa3XE4gyuPhhZeDB2Bbb1zyvE5Zl5pNdtR1cKpJ805g3E5WHe1Oh9DSiYxwe80UcAX/soPthylP+fASw1k5I7uAkGFxeKgoaqJGvc6MeXGy20r29BG3kAmG2R+jf8npnJRuKjEdd8VkVctLCE3y2tOkyIG7pD+75wmFazPSOQsUAi6U92hZH0GgLOLojq98RCaHAes4R4VU8+eRJNuEjdm1bxR0QpqvmOmN8h//vQsFXy06e5iZFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YRYNm8ay0vqFQIwspRpoM5Gdl0kicm+goSciLu8nbMM=;
 b=N7by3Y69xHmEcBBgc+u7Z+XVL53MxEI7415a7s89ABjaGzt8ZI25d29Z7N8kljZ73Qau0Vsev3yBYj+908WMtHWwIRYUFFtuDvMfXu17u2rNz0fpZycJMXUi2jF1wbb0fJ0sehULbDEBGA1tg9H2UYQy8xDwUBNvjoEvkBk4eRhrkH19LUEp+suzy7mMg58n367UvfP6s7Mev8n92tMica0pQsKyAEisQ5W/65EDPS/hoy2gUOooe+SYkrCFNPCKt9rGAf1+wo1i1jDJo95LJij1T702zq5i4hZ3oowHwBH2W6hl+fH/cOOCs5W6TLu7xj79xplyHrkAqdd2D59H4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7247.namprd11.prod.outlook.com (2603:10b6:208:42d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Fri, 28 Feb
 2025 06:43:49 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.8489.021; Fri, 28 Feb 2025
 06:43:49 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, Yishai Hadas
	<yishaih@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, "mst@redhat.com" <mst@redhat.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "parav@nvidia.com"
	<parav@nvidia.com>, "israelr@nvidia.com" <israelr@nvidia.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>, "maorg@nvidia.com"
	<maorg@nvidia.com>
Subject: RE: [PATCH vfio] vfio/virtio: Enable support for virtio-block live
 migration
Thread-Topic: [PATCH vfio] vfio/virtio: Enable support for virtio-block live
 migration
Thread-Index: AQHbhrZYFkmSOD+lUkGgOFaMskgigbNZPJPwgAA/fICAAkuzAIAAgnkA
Date: Fri, 28 Feb 2025 06:43:49 +0000
Message-ID: <BN9PR11MB52767CE76111FF0A5D463D278CCC2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250224121830.229905-1-yishaih@nvidia.com>
	<BN9PR11MB527605EBEB4D6E35994EB8068CC22@BN9PR11MB5276.namprd11.prod.outlook.com>
	<8adbe43a-49f8-470c-be67-d343853b17f5@nvidia.com>
 <20250227155444.57354e74.alex.williamson@redhat.com>
In-Reply-To: <20250227155444.57354e74.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7247:EE_
x-ms-office365-filtering-correlation-id: 9e014680-ce14-4561-37fe-08dd57c341d5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?DTT+Jz8hZo3Ssclj/O5KlZBVE/hgmZPsTFrp9SFCfwRJGbpfuEkZBGAX8W07?=
 =?us-ascii?Q?/CLN3RD1XUq/Lh84QX/nu/G/SsoNaYK0WVVEyuTdJKQSRXowR7P8Jm7XrsM3?=
 =?us-ascii?Q?z9Au6wOTVy4j672v7elD6Suakw5tz63HSIQ8jua4o4ylVq3U9wCe+7SIF3b2?=
 =?us-ascii?Q?s4YXfnB186n0pu9IUgecV1teMCftf26vQAro0gQw6v3tHK5zyBDkMCUKaRBl?=
 =?us-ascii?Q?KnXR09YCQkgfv+yI/VgjJE+vmH4JTArZ8D2jq76xItM7pbXLEb6GN+9hF5Nv?=
 =?us-ascii?Q?vkiR8CIuntICK7B9WWXkJBpXo8y1CRUuLLAMFuJP4RmpuHg4Dd4kxwT/fvoq?=
 =?us-ascii?Q?mZ8QE7kn+lKpbvI/0df6lSNwyUDQpYKQIJRv2R1qUVJzlLRBKTu3FnPutRcJ?=
 =?us-ascii?Q?Rp49zHlM8zl0/Csop2oI5/DorTiQH1/AnLLsncIc4bJLbLW8fwz2BBwYTvsr?=
 =?us-ascii?Q?Y+kOTgg1alHAoh6cA+NCaiUIP9xNcMOpoLWMnM3L/40nM6JSzoXP9wAFjrJp?=
 =?us-ascii?Q?WDbCQ6Kk9sk9g8TT80XyeAiym9QvGU6p+R2FytNN30VR81CLA+dTZh83056G?=
 =?us-ascii?Q?69x0Ix89P80Sd9pc7s+QGfgucDISsR6oqsEF+9rHiE3fXxf6PR/i9ssN0FrE?=
 =?us-ascii?Q?92OtRdF1b261dwJ0JRi30WTCh8nDnwhqWECYhxqJWz26UdNp5W0+DuUPcPXs?=
 =?us-ascii?Q?wekishL5hw0lFkKCRjjTyAQslvzi1hzWD/pa3XWVg9QgeEkUrpIS3nVgvE0R?=
 =?us-ascii?Q?GcKPPKF+CCZcxPbXGzK3V46RKu1sECoMzpOBHSj1cYNl5AMhGbGRT3bBuxRk?=
 =?us-ascii?Q?IqdhL2Kohoz4xGNl0rQVz1/vV4WIA3lR4xkysXC0sU7Qc/w0qYQAAMH6X5GJ?=
 =?us-ascii?Q?D9Lfh3/rs1wDQtyqMB7BUnNTCwY8kVFCBKCKmCBlFR1EH5duzVIZfZ0zIGL2?=
 =?us-ascii?Q?7Y2VLr+rebMIi12IA3XZCmdr1mphdcyBUA8n3P8NV5pfp6F/aPncL5R//Djr?=
 =?us-ascii?Q?S633FJGAKOuZ59iY9u2JQ7HMHTNiZ87ABqZNuECd5Y+5aX6t9+W+22pirTRo?=
 =?us-ascii?Q?J3j13ySeCsAlTHY+uT21Ezs4rWBLCdftSWibYDoAF/KJE5iPU2iG6bT/Zw2Y?=
 =?us-ascii?Q?iHfvUqPRMUhcoYDLWxxkw1sOLib7PZSYtHwfbgJh1YMI33QRnU44TOQ4g972?=
 =?us-ascii?Q?KRJLvHGVsLHHiXJL1Vnh/Nt6EVApnWRPDmCDiwbfRIWL+YyruWalf90wfnNr?=
 =?us-ascii?Q?uv92Njk6pejbOTvSZBISVVgN3zR43ByoG6PgLoRLDnaIHkc4au1PkU3qTgrJ?=
 =?us-ascii?Q?QrkqDzPOo5tnHVuQRxxY+NiPwH2kVk3WKyxjtZ0Xylg7FEc8wOWANu6rxkXV?=
 =?us-ascii?Q?0cMG1bBOW1nKQ3uhlXjT4+1EjqrJ4XZYI95XjVrlTJsmpSKmykYwxrxslGYE?=
 =?us-ascii?Q?dWU2qdYFXBSVXEDi7lQqUWNZJxEJ0L8x?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?s7mFs3hi67wG4wdl9ocQv5ghhp6V7Z2JWLctiUKAx/QhSd2llgy3K//1yLdY?=
 =?us-ascii?Q?nmL1ZbsESU9PfZ4kKLQNaBjSAOVodo1cGxKsTLljmWChOIALQHLWcfUZpIAM?=
 =?us-ascii?Q?zQbwa6k0H5L/EJA6CfLPk5r0zE+SfpMbG1V1eWRiyJVzJI08wakJzaJ8mINk?=
 =?us-ascii?Q?mQBNvYajnkwIa+M8IRdM8MOEqUdrRMyfsMrqeaemTxeg/LS+0c17+4r+ekSw?=
 =?us-ascii?Q?NikhGF5dDQanFuh85LO1m3sFwZjrqeYABLSLCxxQbIDm7nZK4/WCm3XNqYbu?=
 =?us-ascii?Q?dzGn/TFJdmoxBmg1TKgbbgDIl32G/sc6TFhoGLuZPBMjN5hyYgbDzX3mW1zq?=
 =?us-ascii?Q?93SCdgYiG+Wf/7u/dmMzKOdKjGeBTDr7NM/ftGAB4T4PXbDEOPPCzV2leHV1?=
 =?us-ascii?Q?aYhVWWTipsP63fblSV8yS75QhoO1Y+TG6pq2iiLkLFWNIYLIh0h5m3g5KZ5s?=
 =?us-ascii?Q?g/xdEnwEcZN7CzTqVNWftWdnwMD3LC5+EVOIVui4wJGgdSTk4ZpS/skmju2u?=
 =?us-ascii?Q?R6fW9Dk9FGwRonQ/nUrEzd+zLcq1F7/MjcULo77bpmU3YwU3zkkLzRdnbr/w?=
 =?us-ascii?Q?TM6ynUDMS4jbF5tTj5iLLn9sI25mMfV0yBCdqHD19Fzqu640faenS+dBU+kT?=
 =?us-ascii?Q?hVKknvYgpok20qJ4oTh9/orVmPy8jRsPHW5SzhDZyvRW56sGnPg0jyF9s1nn?=
 =?us-ascii?Q?yrK3RLmUVu3gryT1sivxlQ1w/8whY4vIB7doeFMzzUzvfFQ15UFRwQR09H9R?=
 =?us-ascii?Q?M+n/fjt1+/gcBp6l2dfRO7yhUKDFxkqfB9Yzpz0CwqecEL3Jmq+THSV9SvsA?=
 =?us-ascii?Q?mxdP3ccJB6W/f/nb7xmYFpyZZZM5CMOns807HIhQp5uaDLlG7dMUPe0i3rfQ?=
 =?us-ascii?Q?JeCjb7jHUfRJfHBXut5CzyL+jlQQatkCnyCi3DAx+wdW8VenAKw7EiO/392b?=
 =?us-ascii?Q?VyoH2FADx/jq1xfbQ/c1t0s6jx7BJdntP+ToYkrYC3kirChP9JEcRkqB2lW7?=
 =?us-ascii?Q?fdqqoBcj/NywIFv+9evDTvJie/YiQAGa3m7rhU7Q8CD/FSMv0LF83oJIVXl9?=
 =?us-ascii?Q?gKSxlPukra9H1wMfAvTj6k2u7AwlxCLG8PKMF8mP0kttGtQY7rYFiWRWiODL?=
 =?us-ascii?Q?7osTW9CEgpzA1j4gO/hiMKYV18deGhkJ0ssdnYHQUPNONUm82UwRAOrizEKG?=
 =?us-ascii?Q?icOXyGfJB044TdBTv7h36Ysln0vo1qncIws6J3vf9Rf8k53ZvRV2hjthwbFv?=
 =?us-ascii?Q?pEdVD+dDID72DxWTBk+f+8UR8F80fE8DcTb3/Iris4v0y2LbD/Bp5ISIMGo9?=
 =?us-ascii?Q?SSrxttUpVKOeKx6G9p5GVXWSQpNLlXhDIHy6wdK+0sQ0UgBJOh8wKkqLeweu?=
 =?us-ascii?Q?JWadyMiRUYk7IMEBL3/JnDnuK6vR3IYZqg5jQp6kUJVLGOAnVRK1bqm56nyZ?=
 =?us-ascii?Q?nhP5U3O92nxOcwdRULjeAzkBjl06LZSHuibCIZ66f1pmHkvhxcxDkTR5U1qh?=
 =?us-ascii?Q?A8AXtOaAG3FoxnpisgeXkd90jL+X78/UU/9i7mjS6rLkONIxy/sGxtbw+M09?=
 =?us-ascii?Q?oi21xRtifr2rOT1k/618MfdmPghL5HF38pUTS/de?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e014680-ce14-4561-37fe-08dd57c341d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2025 06:43:49.0991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W8GvA16hyIXzzarqpu3EYdQwPP2D36UxdOhnrvt0GM7uU/38ewXA0ZXmY8dgtkJAAOcMaROlVfHZbcH5E/aBHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7247
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, February 28, 2025 6:55 AM
>=20
> On Wed, 26 Feb 2025 13:51:17 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
>=20
> > On 26/02/2025 10:06, Tian, Kevin wrote:
> > >> From: Yishai Hadas <yishaih@nvidia.com>
> > >> Sent: Monday, February 24, 2025 8:19 PM
> > >>
> > >>   config VIRTIO_VFIO_PCI
> > >> -	tristate "VFIO support for VIRTIO NET PCI VF devices"
> > >> +	tristate "VFIO support for VIRTIO NET,BLOCK PCI VF devices"
> > >>   	depends on VIRTIO_PCI
> > >>   	select VFIO_PCI_CORE
> > >>   	help
> > >> -	  This provides migration support for VIRTIO NET PCI VF devices
> > >> -	  using the VFIO framework. Migration support requires the
> > >> +	  This provides migration support for VIRTIO NET,BLOCK PCI VF
> > >> +	  devices using the VFIO framework. Migration support requires the
> > >>   	  SR-IOV PF device to support specific VIRTIO extensions,
> > >>   	  otherwise this driver provides no additional functionality
> > >>   	  beyond vfio-pci.
> > >
> > > Probably just describe it as "VFIO support for VIRTIO PCI VF devices"=
?
> > > Anyway one needs to check out the specific id table in the driver for
> > > which devices are supported. and the config option is called as
> > > VIRTIO_VFIO_PCI
> >
> > I'm OK with that as well, both can work.
> >
> > Alex,
> > Any preference here ?
>=20
> What's actually the proposal?  It's fine with me if we want to make the
> tristate summary more generic, but I'd keep the mention of the specific
> devices in the help text.  I don't know many users that preemptively
> look at the id table.
>=20

I proposed to remove specific devices from both the summary and
the description. Fine to do it only for the summary.

