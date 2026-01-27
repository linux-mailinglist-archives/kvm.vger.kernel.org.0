Return-Path: <kvm+bounces-69241-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IOBkDgyteGlasAEAu9opvQ
	(envelope-from <kvm+bounces-69241-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 13:18:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CA83A942A8
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 13:18:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2F7943004F39
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 12:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B9FC34BA59;
	Tue, 27 Jan 2026 12:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X3SBYiEF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE948346E75;
	Tue, 27 Jan 2026 12:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769516295; cv=fail; b=fc0lo2eYUoaQeweCVrec6aq72iirZ3gdOQuyshjWNGxXQRGPKlTz6Aq2QhHyRjpLJxlMvorzQNb9Fwxrkv6qCWTjRUHsUltwzbzz+EdObI6R+LVtNF3mxJlWI93gyqW5hyyYsZkz2nEVfsDS+yvWNeC4sjxJCmrymbFgrzx6QLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769516295; c=relaxed/simple;
	bh=x9RqZrZn4uza40e2GTG9Fe4iaHCximRzqQ/ZkeOwscQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fhP9k+aRGaY8QQQBC39GH8xbvGvDpUTtUzDEZtADp6VTAmVqHYhwTfylPfV4BtS6FbO1KWVa8sCMsSyXw5g7aqrLzJApaHqcel71xEUnGVGPHjfc+oYtH44K0h2kKZ/QoTLaVjFLALejEPoz7II36qkSwaTgPTmgq6okRmzMzzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X3SBYiEF; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769516294; x=1801052294;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=x9RqZrZn4uza40e2GTG9Fe4iaHCximRzqQ/ZkeOwscQ=;
  b=X3SBYiEFwaZqb5LKsKySYWJzEdr0tdWZG5b2xW2+FGvHhKvAFjcTYxSX
   pu5rfQAkdOQrsDuvoMXjSsnKR3X4AOrOwbagpg5j9jbnPzx9lyorjc1Su
   xLm33l3HWLG2GjCeKIJobK7KGT8IZgIEEwAV2I4bba6KjrRafAu3d3Myb
   tddn8UAPg5oVSt7JkovPegXZ06m+YxfCSP5VZv8Z98nJOBJzVTy0ddVCQ
   +ju14usA3iX6L4ICfPH7NVLlqh7B0yg4LSVk7cWOIncZ8lyCx4Sb6SOx1
   vyUcb5tKXaKggNbqSXkkHYOSS4hpweESHQiI4LGy6ZF6BuS4cX0arXNNS
   Q==;
X-CSE-ConnectionGUID: vl85WPxlQtitl/JhP0bHJQ==
X-CSE-MsgGUID: QD3b58dbRji8OLPuhIdpaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="70612410"
X-IronPort-AV: E=Sophos;i="6.21,257,1763452800"; 
   d="scan'208";a="70612410"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 04:18:13 -0800
X-CSE-ConnectionGUID: GttulTsqSo+qqAu8ZwcrtA==
X-CSE-MsgGUID: sQG0TeBjTcu/1rZ3oc1NyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,257,1763452800"; 
   d="scan'208";a="207583453"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 04:18:09 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 04:18:08 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 27 Jan 2026 04:18:08 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.14) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 04:18:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s3pVbvmU9o1Wj6pefwaLt+/8FssAM4o5nk10NJa/K/BYvIHCHn1FaBw9Ci7FuRK1e+hPAOWtutvbYCuXW8uqZgxUDyBsf8spJBKGs8G2lxMLH+XzUodG5LCWIxX/hyNAjxa/2NHpW929hWVhxUQso+e7Xo9N7hZZtrPhlzMapmYwCpFwQgvClBAcTG7gBq7t9cmhN1fvony7MJgOfdG0f/C7YOZzTCaQ2XhedYU/eXPT1mbQcwYkUS1KILsMQklGTdBwTzhnDv6CUi18sCk8Kcmk2jEVEQj9McG2k4H9d+qd/umaO5nZzuBtBu63Fi2qe6wh9BxpoTtnq0DrtwuCvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YECp5m2nigSxH4klJmJbp1xrHmFkWTuyR8rQGjUTcf4=;
 b=Menuq8Ymb88OIWbm3zEiJ/5IzEAn8oyGUOmCzaFgkcCLemCzXhJbxUw8gT/1IX+e4r88fXBSb6GZObg6N+UiOt2W2bMe6bL75Qd6wZ5KB68gd///3B6H7soFD07FYAB0Zr/VTnC2t+FLXl7vcSzGR9zgEpARe0Wdy2M6U7JtAUDQMtrdn3vhRcV/ctzZehdDT0zjQMdENXeveCMp4nwNBYrBm+d9qd2Wrbg21UFoTF1o+qYt5rjoAz2DG3K1WqI+O5+vOioBOL/CZPNjVwmK66hiGTsqrj1zgZdKz+OzAarCjArCE8Te31xiAnuETa2dkTHAT3kx1fbVzotlfx23MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS7PR11MB6293.namprd11.prod.outlook.com (2603:10b6:8:97::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 12:18:04 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 12:18:04 +0000
Date: Tue, 27 Jan 2026 20:17:51 +0800
From: Chao Gao <chao.gao@intel.com>
To: <dan.j.williams@intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <reinette.chatre@intel.com>,
	<ira.weiny@intel.com>, <kai.huang@intel.com>, <yilun.xu@linux.intel.com>,
	<sagis@google.com>, <vannapurve@google.com>, <paulmck@kernel.org>,
	<nik.borisov@suse.com>, <zhenzhong.duan@intel.com>, <seanjc@google.com>,
	<rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>
Subject: Re: [PATCH v3 26/26] coco/tdx-host: Set and document TDX Module
 update expectations
Message-ID: <aXis76vQhWi3RvEB@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-27-chao.gao@intel.com>
 <6977e73a7a121_30951002f@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6977e73a7a121_30951002f@dwillia2-mobl4.notmuch>
X-ClientProxiedBy: KU0P306CA0019.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:16::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS7PR11MB6293:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c238906-8743-4b42-6a6b-08de5d9e1f3e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?84ZIn/p+KdGcRl41vbfsrNMAnxKz9+A7hcs8nHiUu5rZ+Q3QipJcvZ/1Ohmu?=
 =?us-ascii?Q?PgNP5ZWqxQz/W9SxRg0nIa4+R9iBEPK+I0WErsLLgqR7eCPIca14Og4F304e?=
 =?us-ascii?Q?5Py+xcDb5iH41kkZlE4l3HNSgUNj+DdIoBp3KxtNmISvp+mVnWg2lcfAf6N7?=
 =?us-ascii?Q?xT7t81HsBeTP4qVx1qegfV4UVpXY+ZRkP1Qqw8FPLIHPt5akb36KZMblS5RR?=
 =?us-ascii?Q?sU12YIOB8oTT0zeCWDprGEtXgSmER89U6aS87FnSxhMK7wJOssPlJ/bkHdw0?=
 =?us-ascii?Q?PmVDI+uTnrmT4yJ8nWaibX66Rif6+hf+szxMqMbbm0FPvmF//rl2Q2SI6Dn0?=
 =?us-ascii?Q?T9LoDFMtit1HTQH3ect6hvYuVJXtqESk0YNlWhrTUAFvR1hC2mD4ahDilCpY?=
 =?us-ascii?Q?4SD0En1qV2UAOX+MCsKiyFnIp3yRyYXDCXzHIzykkPzk5xJgzBpkt5Uv25ej?=
 =?us-ascii?Q?5tWoIepdOy33wlqnvsq1eCLo8NnP1Tw2QPrEdCuPl10nOG8YUtqd/ffBHhK8?=
 =?us-ascii?Q?BpINJV3s9GxHmgC19e0w0fjhVDBEqxBIHF+zkQma1lG7+97kKBlUjl8nnOWj?=
 =?us-ascii?Q?2BRmb6f07mwl9QpgRoRHZYmxiqIJg3ORZRaXTgueayEGHPifRgFDWzVvZR9V?=
 =?us-ascii?Q?jTd2ZHvkactIOHNipVaCT76/fx+I5RP6BO5zqt3PH8TnybKavHdEaoaap79n?=
 =?us-ascii?Q?VPR4exoKJhZr3FuTNjQmeQeBwC0aMjjxnPJ/NXpHl3szemfEA6ctExZUOmkh?=
 =?us-ascii?Q?X5Jlj50eLoykLA9wLnS8xwmQ4V/7Wy+gAcmJ2L9MRx9kQwoufF5YsVkgG2aE?=
 =?us-ascii?Q?b4CvqnGYW7gfkA/yS71YKjjXhU4qdv59y1xcvDtA433U1UlPm3/gFLHQjydY?=
 =?us-ascii?Q?5weUO3QNEGughRja/PKcK2l4Qnt308uK5yszu/DaZYkA/hv4SDzZbl+2Gu0S?=
 =?us-ascii?Q?KOofWX61sIQTbYcuMm2fM0lUFTcWInKCW/UBTWCS1jM6FacGb1Fix7XqMlST?=
 =?us-ascii?Q?hezUQZbhv2MBCq9Z8FMe8Ib3hoosEgXwmHmvPaeteAvbC3qaD84MXstsiPcY?=
 =?us-ascii?Q?nhtxduObj1kmkqAL9GBEfS1gWemk9c3ME3fudlSDq+3wgW9WcuDM2+aNmmJf?=
 =?us-ascii?Q?Bwvx+Dg+aZzjOHdDSEqIvqUVZrtWX6swwZvpf952yuRgm3V6gCFsTQAnEECL?=
 =?us-ascii?Q?7rPTnD3I6IqHorD3uc+VDgAcqMP6wHDXYv5XXvUt/lVOV2Kf5YMYjO4V3DnW?=
 =?us-ascii?Q?zptxHGd9zz6C8gK0wynmZfuJpTKGZNP2+lhW8+oK6pefe0nnboYZQCYO6ySj?=
 =?us-ascii?Q?ba1jtglU0k3C+1j0Z0PXitTdnw89elf3x88Em3lx21zQvo/8awVcolNcD/aV?=
 =?us-ascii?Q?QdaELe+Np9FqY3l2NqBepcvXdZhX4+UKNeJfqOiD69oVLsNgJx1aMa6gTQnh?=
 =?us-ascii?Q?3JvE6/4x0wfINjSeR5c4gZIyxEJ7jV/w4CXuehtGAqaSbck46WdR3JMIXFhB?=
 =?us-ascii?Q?kL/B7meehAB2vd1PXmp/mYXZcgjZ+xePUgMYL+3wfI6CJ/Ph7K5ryTmCKw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pNT5C+bpI8mrSkajMx1GZojVzGu9Gv2JlIM6DqnwWOYy6dgw4ofYFJuikqMZ?=
 =?us-ascii?Q?AJRhCwL/zobXwAO4gUCiXdKbLb+GiiWntCe8c0PdbEw5Tk802/TVPv45mjFR?=
 =?us-ascii?Q?Y9T75Gmaf/DZ9ftREzvMVEqqeo9ML3+NpurNVjHij1biD3NGnN8ooT4300Lv?=
 =?us-ascii?Q?cj3+ughiDT9vq2aAn/gb+8D0Cs9lVS7TYQB1oKAJCJGNYiS4iTgT1IVyRbpK?=
 =?us-ascii?Q?cHaiyfrZVmHyOQhGlu3rPBL1hlZXd40MEGEsM8fw/RsUgtviRsDmeZlYfdyS?=
 =?us-ascii?Q?xD2Z5zqgai+B6krCHM+bk9o0XBkPrdjJrexpwdHWkEYgPwGuEjebgptlv8s6?=
 =?us-ascii?Q?x4Ame3/74WntbVmmIqjU706Eq9ub2AYr/Jll8mlKS2tvFUaxqMZM18GTwTEY?=
 =?us-ascii?Q?NHQK6GqkgzonwZdDFrpnLZabxxZ+iLLWMzk9DKuCOT5QKgcG8Nv7Ph+iNgvQ?=
 =?us-ascii?Q?riX/CKdQciQEcxpI7s+nqLr6Fbbtby93ICgvXQ2BpX1QkPNQ5Mo+Y58XQJHy?=
 =?us-ascii?Q?a1QVlNwEXdflSlaLCU8QAirIvDLBuw4bmesDuWW4abdVG1U2qtQHG3YF+Cw7?=
 =?us-ascii?Q?56JJSS3M/QiXS4C6Dv1ineXRHv7WZHj2wWlVKln85+AzY+SA2l6ia1O7RGvC?=
 =?us-ascii?Q?Gv/VuhFGmeK0vgLsnigkqyMIqCLJq218UHXmmSTlonP0P5JH/WoLZnbrpxwf?=
 =?us-ascii?Q?x5M69FrbWNO7dwIpx7ksR4K2F2qjVGq4npHdDHt2Zbf4lwzU+EPfOOjGmLlI?=
 =?us-ascii?Q?BcZvusWRvdw/2c19Cf5VDBtzPebyLSOTe6Rc1ynRtDR1LNQeSne8RvNRHvQl?=
 =?us-ascii?Q?Ut3UFBI2Tmg5L8tN1EunXmaiuhguZTcnRASAGZD70z9nxtEDJqKeS4p6mFX1?=
 =?us-ascii?Q?Z7zX3IxZqZie3PLYWDweojAQ10gsWXJX/g3/yMpbiFlMeF1MQy2H5kbRrmC+?=
 =?us-ascii?Q?XDq2lIJJbUqKvI7GEEYgRy0PNZebPotgAGTL/vJ2xeHS6Zv93/To+RiT0i6o?=
 =?us-ascii?Q?x9qqT8N6K5X0+D8SAS7vXYvYTvg7fqP2nTxshixjqt/UzI4AUUVkKFHXceYD?=
 =?us-ascii?Q?pbyZ/vCw1GRVm3SwAoO0Sfsv1OWjUddWbAOl1GZKY19mVe9daTaMUlvHqpuc?=
 =?us-ascii?Q?degh7KNXmc4q0gjCBEucYmcSYK2euEBmHlR6e5W9Ar2ft8d5rT5WodYVYfBw?=
 =?us-ascii?Q?YVd7Z1sgv0xbSYpqKJibujIO91oni81ftplTKF2vb/F/JRsbUDuVaMZgi1Zj?=
 =?us-ascii?Q?QA0q0dCDEpsQjwiTmfK2Kqe+gj2E4X/O9aXcTMtYvDV7+pDJNfKVhD/8KhTD?=
 =?us-ascii?Q?MUW/L0kce9ly5wHHpmf1BwR6iqvWgk0K4o34cGNAF1fckLjtzuEVBndHjJms?=
 =?us-ascii?Q?59Lp1fAy2TPmHr5RRJb0NkDeFuW8hKmAVbL/Knfdu6ZeMPMIBCKDYReWmhmB?=
 =?us-ascii?Q?reolEqrSJRwLWDbBRiMS9GMDbpxD/qT+VNvh7QLjGmsgRWZ8gkaURPNoAy4r?=
 =?us-ascii?Q?WvqnQO3dAUw6x61k8j2YwvjoJTkIGf+oIkYqf12oVnR5SNPP5eMKXR+YUGLu?=
 =?us-ascii?Q?y7o9ycGYzVReItVkruPHrRtqWLWAyzdwL9LtiA8ukL8XD7SEW8WjCEg/vJTm?=
 =?us-ascii?Q?X/jUYE/Qe3rRrwIYYZ/XrAiLXWqrD42qYdWDPbFc+rFgwCln0Be5pz75IP8U?=
 =?us-ascii?Q?2MrnjBmtOoNvsLSN4cLkIpOoMoHkyP+tcL+rnnPhtV8pD3BWmNu3+Q2UE15N?=
 =?us-ascii?Q?HqDAO+axtw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c238906-8743-4b42-6a6b-08de5d9e1f3e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 12:18:04.5176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s/Aj/M49nuFf3JenWS/KYHF9eWedPJsrymJpe2MFSNpDqOTqxbXnOC4413GuRA/NSCSEuS+aZKZmoSY/lPHT2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6293
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69241-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[19];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: CA83A942A8
X-Rspamd-Action: no action

On Mon, Jan 26, 2026 at 02:14:18PM -0800, dan.j.williams@intel.com wrote:
>Chao Gao wrote:
>> In rare cases, TDX Module updates may cause TD management operations to
>> fail if they occur during phases of the TD lifecycle that are sensitive
>> to update compatibility.
>
>No. The TDX Module wants to be able to claim that some updates are
>compatible when they are not. If Linux takes on additional exclusions it
>modestly increases the scope of changes that can be included in an
>update. It is not possible to claim "rare" if module updates routinely
>include that problematic scope.
>
>> But not all combinations of P-SEAMLDR, kernel, and TDX Module have the
>> capability to detect and prevent said incompatibilities. Completely
>> disabling TDX Module updates on platforms without the capability would
>> be overkill, as these incompatibility cases are rare and can be
>> addressed by userspace through coordinated scheduling of updates and TD
>> management operations.
>
>"Completely disabling" is not the tradeoff. The tradeoff is whether or
>not the TDX Module meets Linux compatible update requirements or not.
>
>> To set clear expectations for TDX Module updates, expose the capability
>> to detect and prevent these incompatibility cases via sysfs and
>> document the compatibility criteria and indications when those criteria
>> are violated.
>
>Linux derives no benefit from a "compat_capable" kernel ABI. Yes, the
>internals must export the error condition on collision. I am not
>debating that nor revisiting the decision of pre-update-fail, vs
>post-collision-notify. However, if the module violates the Linux
>expectations that is the module's issue to document or preclude. The
>fact that the compatibility contract is ambiguous to the kernel is a
>feature. It puts the onus squarely on module updates to be documented
>(or tools updated to understand) as meeting or violating Linux
>compatibility expectations.
>
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> ---
>> v3:
>>  - new, based on a reference patch from Dan Williams
>
>One of the details that is missing is the protocol (module documentation
>or tooling) to determine ahead of time if an update is compatible. That
>obviates the need for "compat_capable" ABI which serves no long term
>purpose. Specifically, the expectation is "run non-compatible updates at
>your own operational risk".

Agreed. We need to add metadata like crypto library version or equivalent
abstraction to the mapping file. This enables userspace to determine whether
module updates meet Linux compatibility requirements. I'll submit a request
for this metadata.

And actually, userspace can already determine if the TDX module supports
"collision avoidance" by reading the "tdx_features0" field from the mapping
file [1].

[1]: https://github.com/intel/confidential-computing.tdx.tdx-module.binaries/blob/main/mapping_file.json

>
>So, remove "compat_capable" ABI. Amend the "error" ABI documentation
>with the details for avoiding failures and the risk of running updates
>on configurations that support update but not collision avoidance.

Got it. I will modify this patch as follows:

diff --git a/Documentation/ABI/testing/sysfs-devices-faux-tdx-host b/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
index a3f155977016..0a68e68375fa 100644
--- a/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
+++ b/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
@@ -29,3 +29,57 @@ Description:	(RO) Report the number of remaining updates that can be performed.
		4.2 "SEAMLDR.INSTALL" for more information. The documentation is
		available at:
		https://cdrdv2-public.intel.com/739045/intel-tdx-seamldr-interface-specification.pdf
+
+What:		/sys/devices/faux/tdx_host/firmware/seamldr_upload
+Contact:	linux-coco@lists.linux.dev
+Description:	(Directory) The seamldr_upload directory implements the
+		fw_upload sysfs ABI, see
+		Documentation/ABI/testing/sysfs-class-firmware for the general
+		description of the attributes @data, @cancel, @error, @loading,
+		@remaining_size, and @status. This ABI facilitates "Compatible
+		TDX Module Updates". A compatible update is one that meets the
+		following criteria:
+
+		   Does not interrupt or interfere with any current TDX
+		   operation or TD VM.
+
+		   Does not invalidate any previously consumed Module metadata
+		   values outside of the TEE_TCB_SVN_2 field (updated Security
+		   Version Number) in TD Quotes.
+
+		   Does not require validation of new Module metadata fields. By
+		   implication, new Module features and capabilities are only
+		   available by installing the Module at reboot (BIOS or EFI
+		   helper loaded).
+
+		See tdx_host/firmware/seamldr_upload/error for more details.
+
+What:		/sys/devices/faux/tdx_host/firmware/seamldr_upload/error
+Contact:	linux-coco@lists.linux.dev
+Description:	(RO) See Documentation/ABI/testing/sysfs-class-firmware for
+		baseline expectations for this file. The <ERROR> part in the
+		<STATUS>:<ERROR> format can be:
+
+		   "device-busy": Compatibility checks failed or not all CPUs
+		                  are online
+		   "flash-wearout": the number of updates reached the limit.
+		   "read-write-error": Memory allocation failed.
+		   "hw-error": Cannot communicate with P-SEAMLDR or TDX Module
+		   "firmware-invalid": The TDX Module to be installed is invalid
+		                       or other unexpected errors occurred.
+
+		"hw-error" or "firmware-invalid" may be fatal, causing all TDs
+		and the TDX Module to be lost and preventing further TDX
+		operations. This occurs when /sys/devices/faux/tdx_host/version
+		becomes unreadable after update failures. For other errors, TDs
+		and the (previous) TDX Module stay running.
+
+		On certain earlier TDX Module versions, incompatible updates may
+		not trigger "device-busy" errors but instead cause TD
+		attestation failures.
+
+		See version_select_and_load.py [1] documentation for how to
+		detect compatible updates and whether the current platform
+		components catch errors or let them leak and cause potential TD
+		attestation failures.
+		[1]: https://github.com/intel/confidential-computing.tdx.tdx-module.binaries/blob/main/version_select_and_load.py

