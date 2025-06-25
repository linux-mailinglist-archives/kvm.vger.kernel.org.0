Return-Path: <kvm+bounces-50614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A6CBAE76E8
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 08:25:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A51CB173589
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 06:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D9A71F099A;
	Wed, 25 Jun 2025 06:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ax5gPXKP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5B33FD1
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 06:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750832694; cv=fail; b=WijCdg/NIcSQHny3FWg+hTIzcLIVO+BLqrhH4v34IxSILFUGfWsOhFs1MjFw3+KWNx8jtG3oVZCiqXhfKult0Aw2Fk6q6oXA7UmoovQoUxT2Zpp43O5TgKHkoAi2Ga1GBK1Ylrk6TWwwPi9AgCen6nU/FE2pvNqL5+cGeWp4vDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750832694; c=relaxed/simple;
	bh=8bo3KGHlqoAP7XEJg7VRQe8ADEiytQ8aHtlcIgoIrdg=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=tuWMYOqfwqoq9aS+DlXyKzgh2R2ykXFDeh70nZrcG0Alk2TgzTawCdklwmes5r2HMbJHeB5+Hrl/jAT+ZYSn6+FR8nhn1BaPjZvelQ+Qhkeo9j7zTjjIti9x+ofxCb63LxygJh8M6I/mmkkWKmhHRMPkxi11ZNzBZNh5ROChSjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ax5gPXKP; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750832692; x=1782368692;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=8bo3KGHlqoAP7XEJg7VRQe8ADEiytQ8aHtlcIgoIrdg=;
  b=ax5gPXKPGmHLKxkyU8RBLNuqRUk126ytmDxSx+icsCmFZnJzZ+DrPLn6
   5peEEO1WefJP7UAWKU4eGB6Yi0kYAMFnNw0Dov23UvNcfhtP+ggZmLBn1
   Nh3/Ft8HjnoEz+CU2RpKWH5owXp4I97F1weCmPo//67iXgK9u4saiOA0P
   Bncpaft1r9Ah0wQp718o1F1DB5HUFbxXZvAV0CAmyuV8dIDtgCNXjWO4t
   ASw0MsiQFax+INTG+h50CsOZNuGjuRZRGmCwGhFVt0xO8z8HKIDA+zzCi
   lG+sGW2QTMn9M2hYNKXSD84tT2qyX+RZNDpDFZI214Yo9Bh46ILnXLZd4
   Q==;
X-CSE-ConnectionGUID: cMq9wAc4SLm6nFUngE7xWw==
X-CSE-MsgGUID: sY52L5LxQgC9Nv1bgRC00w==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="78510993"
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="78510993"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 23:24:51 -0700
X-CSE-ConnectionGUID: WNKqzwa3TdmbsfJwwpNJhg==
X-CSE-MsgGUID: jaPF/y6kTJOASSmnLkmABw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="157886180"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 23:24:51 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 23:24:50 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 24 Jun 2025 23:24:50 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.69) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 23:24:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dWpC5ZyxsVZQIZYANiqFczggJI0xaY3/myVp03kvfk2icrjFB22DKVr0KrR44JMN0FXSVii71lrulx1M5Sttpjjel6JNFlt13gzj5KgZBEV+OV+QPB+Q8SNM1EneVdxpXGvL+Racpug/S+cuc2iqDm19NsHewGBzH3tHYNbHAAhqc8q+J1dAsex3RO9Y60vyNtEg/DhWF+9LAE91reObXIlIYXAv1C3GPXx10+oKbhW3rZ6ds2ojjs4CbLE8d6kQMhTPaKUqLeixgARZz2wx/7HtXkMqLGNBk7cSvwnHXhUpwtDQeOjluejU1R5Gn+Z4xgwFrZ9GApWqLGRsBBA//w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3JwamGQxS3y4ehq4X/BCzi4n4GtbDBQe2Fs+OoSv/0M=;
 b=IIZlWHet80UlRGa+JPSVfhEEO7d7FBdKh6YkG1Ir+LrLsYHAKAFlKcwT7BO3Ax6hrHNTzZdQwDevexFyPxtJNq2NNQ0Uw95JB/S6rVXHsLdvdB4+z0muhf8/vqwdmRFl2MmplCuxfG+bfTZ+X0XJXqM2WSZB+CJxbh/S3U8uHBpH5MaLJ+6q/Nu7VjeIHHLzWHfvXs3qSqIC9UIsOga5zAqPYRixE0rjIjeDth+f8eHMoe0DxLcv0vHm/KSQpHLxlDKRoYs7es0TbrBPpq0I7BDdrstzOq20LP+9Qmzmq+ebgaiIh30omty/IDJB0KaFeKhcyjaDtJupKyEwb3ho5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by LV8PR11MB8748.namprd11.prod.outlook.com (2603:10b6:408:200::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.25; Wed, 25 Jun
 2025 06:24:41 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%3]) with mapi id 15.20.8857.025; Wed, 25 Jun 2025
 06:24:41 +0000
Date: Wed, 25 Jun 2025 14:24:32 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Fuad Tabba <tabba@google.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Sean Christopherson
	<seanjc@google.com>, Ackerley Tng <ackerleytng@google.com>,
	<kvm@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [sean-jc:rev/map_gmem] [KVM]  4f0f45b2ed: kvm-unit-tests.x2apic.fail
Message-ID: <202506251406.5ff35080-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SG2PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:3:17::20) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|LV8PR11MB8748:EE_
X-MS-Office365-Filtering-Correlation-Id: 59e87584-f7e5-4b08-9c12-08ddb3b0f81d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?YDdcSPGDfwL1SxmxjHpGhz6+pmUipeW2Ak5JW/flwdbko5vObRlLj6SbhUxU?=
 =?us-ascii?Q?w2SjtAxq5mYSXW9crRd8LCVcuT7rdFIdfRBJtuNeTGHr6FWnK6QK6RftyxI7?=
 =?us-ascii?Q?CU6kM5KemOYlq0GWmneGTLJJ7XCH8lbfXfYlgbeyR6nmLd957pn11zkINnMk?=
 =?us-ascii?Q?G7auYMjMq5SsIgakhLorsfax1dxnlH0p573ucDRY2u3xJIDqJer49P5/moOH?=
 =?us-ascii?Q?1a64PpjyFELaa/eJpgYd5LEYU5AVsUcFYPSRK8ts4v7wMy1AYuXh6roCrcz4?=
 =?us-ascii?Q?5rWt9tDUyI+ye5XZwA5G0qvLQmljveTK4V0KfRigFMlNtHdvf7jkFj2ze+vY?=
 =?us-ascii?Q?H9lohb1pq0uUW9j4LDoXKxXYZa4r1jb7ZA6/7JV64KbfsJn3zyG5N62ISG9l?=
 =?us-ascii?Q?1sWAxvvBqaOr4ko4UlLaCv8NpeliQw966ZJNeAisltel//mCCQEyWb5el8SY?=
 =?us-ascii?Q?C2qqNvB/DYkOdiosww/DLp+WSPOhfRrrF46ozDcpm7jZI7HE+aYMKWg/Isz3?=
 =?us-ascii?Q?uC4MhjW3l3k0vGZjWkcqTGannRD8AIXvejPZ4fDH7QuAyYtCCWYvy1zSNGXl?=
 =?us-ascii?Q?zN8HkS9lqDYPkoy8pIcwFsZb9y8brkDwpmZU2Tu3CwsjLHwU5k0N9FJqo4qm?=
 =?us-ascii?Q?OZKe090cM7QK2a/JGUd7Ftq3iMyNEBOBOs7XVk89P4WvbK70eWu4zJ4+z40i?=
 =?us-ascii?Q?3/nMliIeXzJ6LnvAwaKeWkjtOQcL6ky9VTXzFQ8SB+ZoLxY9JKhutbJUJyWZ?=
 =?us-ascii?Q?rbL0w7FDxUS3Sl/Ic5rd4b/nmVn6UiUGFyHArjpS7svhzIs26DRtD9KglSzf?=
 =?us-ascii?Q?96ZFs7N51S67pZ3Wvh+fhZvhRGnp6Wj41M3pfaeMFjmoDmpdeo2s0ii02Ijk?=
 =?us-ascii?Q?Scq9sscbUgXrLa0mnLnFsYPMad+oFWs47VWyeVv7nLDF5fh1Y6fcRiXxaGU6?=
 =?us-ascii?Q?aBGu3mpC8B8XMwZf0XNV0rJX24lZE426Z/DE/xogjwuhhDGayCuJDosSdnSZ?=
 =?us-ascii?Q?VCAFbq9DJ4PfgXb8DjePd8AodX60+7bfDQpGObFQLM/sdJrIDoM3a5BOIB4H?=
 =?us-ascii?Q?PZl9WsQNUpOuGYz0N00UcBBZbcMQXRUA2CTzMrV8MBC9TqbqSjtV/I3hViI8?=
 =?us-ascii?Q?ZORFnTb91C0/argJpE7VNxO/kQN2Wxa7NC1FCDsljrm3klLCtEB1o4lPcQCH?=
 =?us-ascii?Q?OICceLdR0+0y0iB+zL+Mu+fGSfO7sQHr6OFiXlPv/v0Zmw86KwciOwQcBUzx?=
 =?us-ascii?Q?siY9B0dm1C9hg42cKeaUYnskmkrasUYG8r6+pl/g3WN9VBF62wn4G86og3YZ?=
 =?us-ascii?Q?ff4Hxnl0pJzkMZcT5jOv4DzLb2TrRu9VIeK2tfKC9pVG2qmejLKQZ5CH7z7i?=
 =?us-ascii?Q?u23jzQI/zk7pFhc4CRGb7XpqiKvl?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FG6lUOTttTecMSbLqbjTdKp+VZ2cj1B4a3I0TTaP9A/foWHvJpyHefjRfjwg?=
 =?us-ascii?Q?g+VD3upxFBa/hXp8aBiem4ctZTz7+8OKvI942PGxMqMrBNEGQQRxgASg+u5v?=
 =?us-ascii?Q?RsDivBxxYyd2qsvTvqpBr63ZHB2RUfKpf0XzGFm40FXk78m2EXfOiXXjVkhK?=
 =?us-ascii?Q?HIFTZzo6P+rVDB05R7AwO16Cf2Rwpua4apZmkITwl13Veo0hzDLZaHvoyQIi?=
 =?us-ascii?Q?QTAyTwXq3u8C3vc1swpaCFHYReacMzek/yjlf3UP5bq3ewQuTpLgDHnODF1d?=
 =?us-ascii?Q?H/D2ZILnifm2ro4Y7cUtewAOYX4xcLmRUwfcrm0JqFfGoWlWwKK5Pkb444si?=
 =?us-ascii?Q?qLzKwDhrBi6d+kVvdwt8Go9F2DJKXqkMXtvQ2kxpNoD/qW6lk0VeG+wjXC8b?=
 =?us-ascii?Q?Mj5uL9NYrOiB40CTZJq54x2T4jT6mxjRlWXfeSck5I8eENc9ehXIy+q+4vRp?=
 =?us-ascii?Q?n+UA7JUtzet5iOdTew47L8zJfDLkdBdCeM8McJMZCeI9hVGCOHqbHprkkyHf?=
 =?us-ascii?Q?KrnZhiWq9YNC+UwB9G3XSB0zIgRZZ6rhqtIMExY2miPuJMjzrrcu/VBEdDuS?=
 =?us-ascii?Q?AgUkK26dji62sTlgBevyqagiENJI7/dM8Ts1ZS/XzjMrOISHKF/5ss8Kt6K6?=
 =?us-ascii?Q?f4aCFTkwQpj4nSOAcSFUGcRwJZpyeslRaWN5laLee5buYDBhrZG4YmbYNVP9?=
 =?us-ascii?Q?EsoxY6WZ3kutuHW6iOBn/gwhvfB5e+w+EzxjsTuvA9WpDO+kNRCLxtgazU5N?=
 =?us-ascii?Q?LgXmyrSMeEtzkxnje3A0oXOcStOn1EjBuNOLaVqGT/ooYL8NxfgiCWE2Wlha?=
 =?us-ascii?Q?oAYMscvhxsm3oCvmXrgvuesKBG71kmpA1DHGA/isRJhkLGXRu2PEg/YH3R0A?=
 =?us-ascii?Q?H/FR43FaFN2+I14GD4qHomi6B3SLk1MtMDF6qmyml75alY3dXrLBUe6+R6lo?=
 =?us-ascii?Q?bMP3yWgMfvx6A3zxdV0SLoDp0QIQzi73fXAvcQLTAMi9M+LI/dVb4o7DQMRH?=
 =?us-ascii?Q?A/7tWIFvRkNKYY4QwmVZFA1aCCjjtkhVWcHbJOqbEgE/8q98+QM99ZPUTIxV?=
 =?us-ascii?Q?4kUe21DSvOqoNVkv83x0zRvgJ7Z0XKWQZns04cjdPwMGaFPLAjUwvJjXTsUu?=
 =?us-ascii?Q?G7RygLwSjjZJHLV+quB0rgUy+3/XhEvjVopN8n4+ePSsmeOhtoZx4px6dgMT?=
 =?us-ascii?Q?6lauvoiSCeYo2RkCEYJzSfLnqJ/7BXtmE+qC3LjFfIWKE6M2l57m1uRuxxO9?=
 =?us-ascii?Q?yAlNKMV4ByzxOegTQMypdbQ8VMrneWH3ddbcyK8XFRB4GNwNhtZGY+SwHLFp?=
 =?us-ascii?Q?S4bVs1iTj++nRA0q6O4T27yKE/ptzClZUZXlhWXK+zHR/WP+KCseX04D8ijJ?=
 =?us-ascii?Q?MwkdGnibEeTAXQrvNCHJjDHsEE7oy3JuCwGx5cN6kA4erKenTPSFcwchHk2i?=
 =?us-ascii?Q?T5dUIU17v8iSUh5cuPZbI220sTlpMvY998E+bjwInkFxqu00lXdUM4/ZdhcB?=
 =?us-ascii?Q?X0G5Ga0Xz5SxeBIHRoU8023/I7z6kDqwSvwzrg73thYi9/Ct5E5eUUW1syNZ?=
 =?us-ascii?Q?B98T00wUOmwiYq96L8g7q8lZ7whBRTW0Uhn9lEX+miG5a//ltd0OupwDC9aq?=
 =?us-ascii?Q?fQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 59e87584-f7e5-4b08-9c12-08ddb3b0f81d
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 06:24:41.6971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RZex4VZtKuodjQn1YiajS0UrskgTeJwErZCwq/u9c+cQyHPHYbdcYbEw3YDW/ophqGF1oIkEZnfopqJ3BSD0Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8748
X-OriginatorOrg: intel.com


Hello,

kernel test robot noticed "kvm-unit-tests.x2apic.fail" on:

commit: 4f0f45b2eddaf5c476302a35cae8962fc3142419 ("KVM: x86: Enable guest_m=
emfd shared memory for non-CoCo VMs")
https://github.com/sean-jc/linux rev/map_gmem

in testcase: kvm-unit-tests
version: kvm-unit-tests-x86_64-50761232-1_20250606
with following parameters:


config: x86_64-rhel-9.4-func
compiler: gcc-12
test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480+ (Sapphi=
re Rapids) with 256G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)

besides, we observed more cases failed on this commit but pass on parent.

0b2874537210b158 4f0f45b2eddaf5c476302a35cae
---------------- ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |
           :9           67%           6:6     kvm-unit-tests.access-reduced=
-maxphyaddr.fail
           :9           67%           6:6     kvm-unit-tests.access.fail
           :9           67%           6:6     kvm-unit-tests.apic-split.fai=
l
           :9           67%           6:6     kvm-unit-tests.asyncpf.fail
           :9           67%           6:6     kvm-unit-tests.debug.fail
           :9           67%           6:6     kvm-unit-tests.emulator.fail
           :9           67%           6:6     kvm-unit-tests.ept.fail
           :9           67%           6:6     kvm-unit-tests.eventinj.fail
           :9           67%           6:6     kvm-unit-tests.hypercall.fail
           :9           67%           6:6     kvm-unit-tests.hyperv_clock.f=
ail
           :9           67%           6:6     kvm-unit-tests.hyperv_connect=
ions.fail
           :9           67%           6:6     kvm-unit-tests.hyperv_stimer.=
fail
           :9           67%           6:6     kvm-unit-tests.hyperv_stimer_=
direct.fail
           :9           67%           6:6     kvm-unit-tests.hyperv_synic.f=
ail
           :9           67%           6:6     kvm-unit-tests.idt_test.fail
           :9           67%           6:6     kvm-unit-tests.intel_iommu.fa=
il
           :9           67%           6:6     kvm-unit-tests.ioapic-split.f=
ail
           :9           67%           6:6     kvm-unit-tests.ioapic.fail
           :9           67%           6:6     kvm-unit-tests.kvmclock_test.=
fail
           :9           67%           6:6     kvm-unit-tests.la57.fail
           :9           67%           6:6     kvm-unit-tests.lam.fail
           :9           67%           6:6     kvm-unit-tests.memory.fail
           :9           67%           6:6     kvm-unit-tests.msr.fail
           :9           67%           6:6     kvm-unit-tests.pcid-asymmetri=
c.fail
           :9           67%           6:6     kvm-unit-tests.pcid-disabled.=
fail
           :9           67%           6:6     kvm-unit-tests.pcid-enabled.f=
ail
           :9           67%           6:6     kvm-unit-tests.pku.fail
           :9           67%           6:6     kvm-unit-tests.pmu.fail
           :9           67%           6:6     kvm-unit-tests.rdpru.fail
           :9           67%           6:6     kvm-unit-tests.realmode.fail
           :9           67%           6:6     kvm-unit-tests.rmap_chain.fai=
l
           :9           67%           6:6     kvm-unit-tests.s3.fail
           :9           67%           6:6     kvm-unit-tests.setjmp.fail
           :9           67%           6:6     kvm-unit-tests.sieve.fail
           :9           67%           6:6     kvm-unit-tests.smap.fail
           :9           67%           6:6     kvm-unit-tests.smptest.fail
           :9           67%           6:6     kvm-unit-tests.smptest3.fail
           :9           67%           6:6     kvm-unit-tests.syscall.fail
           :9           67%           6:6     kvm-unit-tests.tsc.fail
           :9           67%           6:6     kvm-unit-tests.tsc_adjust.fai=
l
           :9           67%           6:6     kvm-unit-tests.tsx-ctrl.fail
           :9           67%           6:6     kvm-unit-tests.umip.fail
           :9           67%           6:6     kvm-unit-tests.vmexit_cpuid.f=
ail
           :9           67%           6:6     kvm-unit-tests.vmexit_cr0_wp.=
fail
           :9           67%           6:6     kvm-unit-tests.vmexit_cr4_pge=
.fail
           :9           67%           6:6     kvm-unit-tests.vmexit_inl_pmt=
imer.fail
           :9           67%           6:6     kvm-unit-tests.vmexit_ipi.fai=
l
           :9           67%           6:6     kvm-unit-tests.vmexit_ipi_hal=
t.fail
           :9           67%           6:6     kvm-unit-tests.vmexit_mov_fro=
m_cr8.fail
           :9           67%           6:6     kvm-unit-tests.vmexit_mov_to_=
cr8.fail
           :9           67%           6:6     kvm-unit-tests.vmexit_ple_rou=
nd_robin.fail
           :9           67%           6:6     kvm-unit-tests.vmexit_tscdead=
line.fail
           :9           67%           6:6     kvm-unit-tests.vmexit_tscdead=
line_immed.fail
           :9           67%           6:6     kvm-unit-tests.vmexit_vmcall.=
fail
           :9           67%           6:6     kvm-unit-tests.vmware_backdoo=
rs.fail
           :9           67%           6:6     kvm-unit-tests.vmx_apic_passt=
hrough_thread.fail
           :9           67%           6:6     kvm-unit-tests.vmx_apic_passt=
hrough_tpr_threshold_test.fail
           :9           67%           6:6     kvm-unit-tests.vmx_apicv_test=
.fail
           :9           67%           6:6     kvm-unit-tests.vmx_eoi_bitmap=
_ioapic_scan.fail
           :9           67%           6:6     kvm-unit-tests.vmx_hlt_with_r=
vi_test.fail
           :9           67%           6:6     kvm-unit-tests.vmx_init_signa=
l_test.fail
           :9           67%           6:6     kvm-unit-tests.vmx_pf_excepti=
on_test.fail
           :9           67%           6:6     kvm-unit-tests.vmx_pf_excepti=
on_test_reduced_maxphyaddr.fail
           :9           67%           6:6     kvm-unit-tests.vmx_posted_int=
r_test.fail
           :9           67%           6:6     kvm-unit-tests.vmx_sipi_signa=
l_test.fail
           :9           67%           6:6     kvm-unit-tests.vmx_vmcs_shado=
w_test.fail
           :9           67%           6:6     kvm-unit-tests.x2apic.fail
           :9           67%           6:6     kvm-unit-tests.xapic.fail
           :9           67%           6:6     kvm-unit-tests.xsave.fail


If you fix the issue in a separate patch/commit (i.e. not just a new versio=
n of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202506251406.5ff35080-lkp@intel.co=
m

QEMU emulator version 7.2.17 (Debian 1:7.2+dfsg-7+deb12u13)
Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
2025-06-23 19:14:12 ./run_tests.sh
=1B[31mFAIL=1B[0m apic-split (terminated on SIGABRT)
=1B[31mFAIL=1B[0m ioapic-split (terminated on SIGABRT)
=1B[31mFAIL=1B[0m x2apic (terminated on SIGABRT)
=1B[31mFAIL=1B[0m xapic (terminated on SIGABRT)
=1B[31mFAIL=1B[0m ioapic (terminated on SIGABRT)
=1B[33mSKIP=1B[0m cmpxchg8b (i386 only)
=1B[31mFAIL=1B[0m smptest (terminated on SIGABRT)
=1B[31mFAIL=1B[0m smptest3 (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmexit_cpuid (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmexit_vmcall (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmexit_mov_from_cr8 (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmexit_mov_to_cr8 (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmexit_inl_pmtimer (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmexit_ipi (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmexit_ipi_halt (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmexit_ple_round_robin (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmexit_tscdeadline (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmexit_tscdeadline_immed (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmexit_cr0_wp (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmexit_cr4_pge (terminated on SIGABRT)
=1B[31mFAIL=1B[0m access (terminated on SIGABRT)
=1B[33mSKIP=1B[0m access_fep (test marked as manual run only)
=1B[31mFAIL=1B[0m access-reduced-maxphyaddr (terminated on SIGABRT)
=1B[31mFAIL=1B[0m smap (terminated on SIGABRT)
=1B[31mFAIL=1B[0m pku (terminated on SIGABRT)
=1B[31mFAIL=1B[0m pks (terminated on SIGABRT)
=1B[31mFAIL=1B[0m asyncpf (terminated on SIGABRT)
=1B[31mFAIL=1B[0m emulator (terminated on SIGABRT)
=1B[31mFAIL=1B[0m eventinj (terminated on SIGABRT)
=1B[31mFAIL=1B[0m hypercall (terminated on SIGABRT)
=1B[31mFAIL=1B[0m idt_test (terminated on SIGABRT)
=1B[31mFAIL=1B[0m memory (terminated on SIGABRT)
=1B[31mFAIL=1B[0m msr (terminated on SIGABRT)
=1B[31mFAIL=1B[0m pmu (terminated on SIGABRT)
=1B[31mFAIL=1B[0m pmu_lbr (terminated on SIGABRT)
=1B[31mFAIL=1B[0m pmu_pebs (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmware_backdoors (terminated on SIGABRT)
=1B[31mFAIL=1B[0m realmode (terminated on SIGABRT)
=1B[31mFAIL=1B[0m s3 (terminated on SIGABRT)
=1B[31mFAIL=1B[0m setjmp (terminated on SIGABRT)
=1B[31mFAIL=1B[0m sieve (terminated on SIGABRT)
=1B[31mFAIL=1B[0m syscall (terminated on SIGABRT)
=1B[31mFAIL=1B[0m tsc (terminated on SIGABRT)
=1B[31mFAIL=1B[0m tsc_adjust (terminated on SIGABRT)
=1B[31mFAIL=1B[0m xsave (terminated on SIGABRT)
=1B[31mFAIL=1B[0m rmap_chain (terminated on SIGABRT)
=1B[31mFAIL=1B[0m svm (terminated on SIGABRT)
=1B[31mFAIL=1B[0m svm_pause_filter (terminated on SIGABRT)
=1B[31mFAIL=1B[0m svm_npt (terminated on SIGABRT)
=1B[33mSKIP=1B[0m taskswitch (i386 only)
=1B[33mSKIP=1B[0m taskswitch2 (i386 only)
=1B[31mFAIL=1B[0m kvmclock_test (terminated on SIGABRT)
=1B[31mFAIL=1B[0m pcid-enabled (terminated on SIGABRT)
=1B[31mFAIL=1B[0m pcid-disabled (terminated on SIGABRT)
=1B[31mFAIL=1B[0m pcid-asymmetric (terminated on SIGABRT)
=1B[31mFAIL=1B[0m rdpru (terminated on SIGABRT)
=1B[31mFAIL=1B[0m umip (terminated on SIGABRT)
=1B[31mFAIL=1B[0m la57 (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmx (terminated on SIGABRT)
=1B[31mFAIL=1B[0m ept (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmx_eoi_bitmap_ioapic_scan (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmx_hlt_with_rvi_test (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmx_apicv_test (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmx_posted_intr_test (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmx_apic_passthrough_thread (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmx_init_signal_test (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmx_sipi_signal_test (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmx_apic_passthrough_tpr_threshold_test (terminated on SI=
GABRT)
=1B[31mFAIL=1B[0m vmx_vmcs_shadow_test (terminated on SIGABRT)
=1B[31mFAIL=1B[0m vmx_pf_exception_test (terminated on SIGABRT)
=1B[33mSKIP=1B[0m vmx_pf_exception_test_fep (test marked as manual run only=
)
=1B[33mSKIP=1B[0m vmx_pf_vpid_test (test marked as manual run only)
=1B[33mSKIP=1B[0m vmx_pf_invvpid_test (test marked as manual run only)
=1B[33mSKIP=1B[0m vmx_pf_no_vpid_test (test marked as manual run only)
=1B[31mFAIL=1B[0m vmx_pf_exception_test_reduced_maxphyaddr (terminated on S=
IGABRT)
=1B[31mFAIL=1B[0m debug (terminated on SIGABRT)
=1B[31mFAIL=1B[0m hyperv_synic (terminated on SIGABRT)
=1B[31mFAIL=1B[0m hyperv_connections (terminated on SIGABRT)
=1B[31mFAIL=1B[0m hyperv_stimer (terminated on SIGABRT)
=1B[31mFAIL=1B[0m hyperv_stimer_direct (terminated on SIGABRT)
=1B[31mFAIL=1B[0m hyperv_clock (terminated on SIGABRT)
=1B[31mFAIL=1B[0m intel_iommu (terminated on SIGABRT)
=1B[31mFAIL=1B[0m tsx-ctrl (terminated on SIGABRT)
=1B[31mFAIL=1B[0m intel_cet (terminated on SIGABRT)
=1B[31mFAIL=1B[0m lam (terminated on SIGABRT)



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250625/202506251406.5ff35080-lkp@=
intel.com



--=20
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


