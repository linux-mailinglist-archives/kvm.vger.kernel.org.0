Return-Path: <kvm+bounces-51058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCABBAED4A6
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 08:33:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C69AC1894E97
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 06:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D9B61DB125;
	Mon, 30 Jun 2025 06:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="krarKJ++"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E572D199BC
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 06:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751265216; cv=fail; b=jX4PZdoLpfQYOCZYPBrcQzgD3sknl38V/hI91dMQn6VfZtdmWvBRBi1mcYCgXfmRja0Q1MGPiD0C5hwTEJvUALSvr/DevSOeHA30WqMgHrdpnzkIZWaHHowVY66tMDe5fFV1YbaNaMC2yuyGUQGOL3deaVOkU+3iNga10I2lxoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751265216; c=relaxed/simple;
	bh=9gOarsqp7NVbZml39xIPo6hR95wxVopjD7EhzSZoG08=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eld41bFjXkH0w3rx2Pj3YUHkA86l9KLoFyEMUBrlk3NR9MPX4qPyfTM/fa6kt+CNfebetJArjKM/AqmSHWv3rhdg6kmlr1U4VF3hbopmPRtOalBbe12DuB2pYDH0vETVOXxoFe+fW8V41+hEUfFhZJLaqe04Oh+UFeEV+Vdclfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=krarKJ++; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751265215; x=1782801215;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9gOarsqp7NVbZml39xIPo6hR95wxVopjD7EhzSZoG08=;
  b=krarKJ++aWuAAdv0/Gaw0CLqqXr0SEh4ksZRskDrbkJNwc5M9Sx2o6Bw
   RSbhPXVSFvhXjA3XRb6O2kYWux6z4/UTwPEglZH0O6S1628rsK2IVDwZm
   0zmyFGS4GB5q2pRIRyt0H4DnD3tFVkCfFNZ0CW4vWDemKbYZnQheZcWH8
   v0+3XfqOLR9SifqFTqjPbWucD67U3JZEUlVtJ9MqOgZ2TkoYrU83T+rYW
   WStXGMZg1Y4rx6Lrbr8g0jnzC1TFiuA2Yepgj6f12pYOzuwnWwKtfo8mZ
   fk40/xs2Mo4aKpFZrcCEU38lVPdBFhYnpS2WFCw47clb2vEgDDOS+41CG
   Q==;
X-CSE-ConnectionGUID: reTbymt8RwGhs6sFq4ZZww==
X-CSE-MsgGUID: 7qnFnAzuSQmaHyhutqvn0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11479"; a="64077945"
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="64077945"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2025 23:33:34 -0700
X-CSE-ConnectionGUID: X0FGjvYcR8KiZZunLMIJIQ==
X-CSE-MsgGUID: XISCv6aoQ+6kGh5R9SCTwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="157642905"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2025 23:33:33 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 29 Jun 2025 23:33:33 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 29 Jun 2025 23:33:33 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.42) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 29 Jun 2025 23:33:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UzBTV/UTW2rt2nrSFaY9qVwNrITyRJMwT1/To2jorN1M7FP8oW/vUwvOu1f9yBgBRoBPcZ78g7oESAS+T/9uS2w2zZfk6J1KBHE/RL/PG1/z1qlzhTdn1X2gidJI5DIJqaKzGb8HLVX1TzSKwfpZnoaj6fwDAPyqwu2HvlwqdYGkO2zo9R4eVTeSUvNloo/6yx4QQU/p4Ma/UvFPfBqDNk95VUOHBemtYTq5dX143k916OWlM/aE4z7Bketz2zA2TxuLyrVBTzQPhrY1JgpQKkV8DzWzKdr8Vzqf4FwMdutMhG44ypXcMeOXcaE1gg3+Syy30zmGUM9YUT+qXf9GLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i7lZu3vdpjHbox3UsKzrxWnoE0smJE/GZCCFs3m5OpI=;
 b=jxoi4Zm+Qn/0p1TcmJ5ZUm+Jv+cA0XloKbMsaPvRjxGEf14OXiNvZau/84EbLvHqVZKoucnB+Qk/PofEVhXKh3Zfx3kBahlFT/QptvKZdPSHQKA/hnU1rz0UdwlYiP3Vtqva2LyQBaOCFNE4jIqHh4JDSQP96CW3OFdH+YTdzWA9Z2dSIJSmSQQQXKYUcri/niNLEAAvMUGN5d6pmNXsH/4KhjPvdRCpQg06bPy8SRhzwKP7VR/WUA045vYXtrir/S38d/GNhB5BF8Oask4KWUhbUq3ZwtI3OiEFdZjaLf6DO2F8CYRYr1zI/yf59DfGW4cWyeBl89AxpwQB0zq2Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by CH3PR11MB7843.namprd11.prod.outlook.com (2603:10b6:610:124::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.25; Mon, 30 Jun
 2025 06:32:49 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 06:32:49 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
CC: "aaronlewis@google.com" <aaronlewis@google.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "vipinsh@google.com"
	<vipinsh@google.com>, "seanjc@google.com" <seanjc@google.com>,
	"jrhilke@google.com" <jrhilke@google.com>
Subject: RE: [PATCH] vfio/pci: Separate SR-IOV VF dev_set
Thread-Topic: [PATCH] vfio/pci: Separate SR-IOV VF dev_set
Thread-Index: AQHb5u2iBX8tePb160qfph8YxC8X3rQbQ5/Q
Date: Mon, 30 Jun 2025 06:32:48 +0000
Message-ID: <BL1PR11MB5271B85A82733651F7BF548E8C46A@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20250626225623.1180952-1-alex.williamson@redhat.com>
In-Reply-To: <20250626225623.1180952-1-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|CH3PR11MB7843:EE_
x-ms-office365-filtering-correlation-id: 569c778a-644f-4d74-3b8e-08ddb79feed2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?lzP6gI5Ztjg9FWFlCPaVjMic3h3hVMPydeesodpZ13gGn7qFMKANIaWbmNzB?=
 =?us-ascii?Q?SPnmF7Nl3ditZZSPVr0rwbnFjwh7THzSisHNRQRXdzBMKHIfTVZ+0lDoiCC4?=
 =?us-ascii?Q?1XIaPgeOTzEo79UGL0ioMmWtSppx8+BbUn9eBmKRtEeBMpEMuGFI7LMBFGE9?=
 =?us-ascii?Q?AOREhmSrf3wVdCJS2G8i96NzuXSd2czbZSPG9XhEZ8Rr4sCk8WdUjPr6l354?=
 =?us-ascii?Q?BDL/t7QU9MJkQtdg9RY8acqpcK2EDMzz3B5lRt7lwBcTK2KsMbjx5c1Of3LP?=
 =?us-ascii?Q?QJBeoSZDIDjuvXy7F4YVp3gFvsw81drJGijQL1y7DTk3c/2IyzUyjFBS4/Mn?=
 =?us-ascii?Q?0EH3m9LHY6JU3fzWVebHkB6m0gGWkUNJYy1Zf0ij9daJtOg8CXOkeGykaTxm?=
 =?us-ascii?Q?6w5yysXK54J3GefyLSpEXABbjOoYs3kag/uim/YaUJFCAdeP9De5Y8/wcFiW?=
 =?us-ascii?Q?LUOkfBBRWpfgXS2TXHizyrl+RndZHpujJQ2jmD/4skwkY2ZYTrJ1iBbJZX9A?=
 =?us-ascii?Q?V2/I//ZDdaB3VwvQ6JI7sJC5Cjlioa49jRQZ5XRz0S/lWOzeQTNSq4ivnZF1?=
 =?us-ascii?Q?Nmxa6YbJlS4XSDEAw7zdBSCm43PMbRuaoO1x6sR6PJt7wVMVXryQ9iaCzN4W?=
 =?us-ascii?Q?9YlDuqy4CqIV7eXZukOkukdf43Wq43TaQre37LxHqKZeXmgacsJ86MZaZAY2?=
 =?us-ascii?Q?SPdVdx4tGupkdKZBuWRZQZ8m2Aq9F8Ke/zo9c0xV50QHMQEWsgsJcYkq9eUf?=
 =?us-ascii?Q?RP9MqRtiZ1XIdeuGFIwrLVdb0AjY94y4tsNzbWCxki+pujXmQTsEYSXo8eOC?=
 =?us-ascii?Q?QuQ8TzAzmsVvs3IxYsC1kWp+7ZajOWHSXOWHOaCFC/jSJTjVZGR6AVRA+9O5?=
 =?us-ascii?Q?8HgW5APD1JdONz9DDvBYDBm28rtk+10F1fcMKS8mjWPIgId46aPAz1OqFGVn?=
 =?us-ascii?Q?n8bfB+5Vp28OghlXZAWLikow+xF1YrQxlZ48dpTMH//mAbhcPLwil/0gWplK?=
 =?us-ascii?Q?7DZV+WBep/D2t0vm4f8ZfeLJYNvwtuD4FO+yl1S8dVKbZFXsPUX3M77fPy/l?=
 =?us-ascii?Q?vIE3hWlGHAwE97rM/L/H8FdoM7LSo1znoqYYhQoyvLaMzeNo27ud7VBpQKV5?=
 =?us-ascii?Q?jcO1IfIcFtZwWZCBb8h3A0DWe73E9ANhKvdYo4Fbgg7f6aOVH9co94lTEe88?=
 =?us-ascii?Q?eIGPGECndtXIRKV9r7n1vWxovv5Ca/EKBzwN/yaB819h+rsZQuIAM5mv2cXo?=
 =?us-ascii?Q?hTHpxLbWsfg8BqvElcVux7y+kMvBStiAzJBrYNYD75Uz9Txn4ccy1hb19fsd?=
 =?us-ascii?Q?evllphyylN+p5jp8ZY3m3yPxLw44eAUInXqcM0C0jpy5TTZ5fng/AcO8iK8b?=
 =?us-ascii?Q?ziUYkUDdnjft4E0x6IbAs1QLB2LzWjWXNPpQWxylf2KPs4vjBuuAb1sye7S1?=
 =?us-ascii?Q?fHgbukJoG0iN+UakWyjVT08KMGarkwJ23gZTzy7wsPKGW6LvzxHJMlKkUgQO?=
 =?us-ascii?Q?//0CQnFo8Li42vE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CnkCxzmuyr9xK9QI1FR38HX6J/iJNElAPLASGA3WlsIERQ0hStiWT5EFWtrc?=
 =?us-ascii?Q?BWoJ6xg+EFEHqNkIg3kCBymYX1WllycCowdHsY1Gc0q4ZptKrT+qmo38WaZ5?=
 =?us-ascii?Q?SEfyDH4+hjQmE73lJMSPYMz65Xdsq37s5XpidU9FgwQv25jNUck+iG5DRr8P?=
 =?us-ascii?Q?wRd7Juw4JXpzeIqiVoLCY6kFiG+rpfAZe15t6AZ+v0e9wcPeTwwi8WGuVtjH?=
 =?us-ascii?Q?yrX3d7tArJwO8xPAxvlOtAgQ8mFzmWDtyV9deuOr8MJNahcnLbybLG+AkJ1z?=
 =?us-ascii?Q?m0R+VrcEzBhrP+GS8gLbE9OPpsVXxHQ8xx1x2Vs4+UwxAMGt523+nHKCkN/6?=
 =?us-ascii?Q?Om53swb9H7eecQHI+QQg6biPpqODuGDF8j+c3tr5qHilb8aXpkWki+q0bM8e?=
 =?us-ascii?Q?wRnDN7O4NLDW+Z4VQrkreqrCmfHoNBWOpCV6LGKWU2rvlQhLRm2cl47JLguM?=
 =?us-ascii?Q?OED/G/EjkL8TcBn92IbMOaTZLn1Tavzx01nzSZth/ab4PcmjyyaDDRgEHUHS?=
 =?us-ascii?Q?OJFDybKC7+cA5ylJ8FZjOdI0DY81vIuIlTwFSDtTHc6nGcOawgFcjlK32JXa?=
 =?us-ascii?Q?Lomrx8TM4k5HGPbonlK/2ro1iuDEEMvLKRA2o8DFGKbS/WViovsVKbuoc+zP?=
 =?us-ascii?Q?Jg64Z/Xdq7xEG8tXdfBBdUsptI9ixjgHIKfEU3tfI0eP2oEfusZ5y5Q5/DpU?=
 =?us-ascii?Q?WUeBET/CUPdRK+ZUnO1SKQwpXTa1OZkOMc3LziJvWTJPfUvGJVEaNmQrrqyG?=
 =?us-ascii?Q?bQWznpywDaAWaRe8Ey1vEFN2ikbBA8FdXmMrhwO5VSfTahKg2ISQw7LqgS5M?=
 =?us-ascii?Q?SoEvKLdzuQZO1YuNouAFYq5WL0Ck/1gxUp0AatWrJfe2ISP6Wu2mnLxgYiql?=
 =?us-ascii?Q?RT0PyRuLcYQBjenRBAP3+m74DSmkOnCa+IdDwYpYBMbZKi5iaUJcuLp8vAaQ?=
 =?us-ascii?Q?MaLqpNC4dFKtWh7B+yFDpmyrTThqdxucWhV/OcL00wM/7hfj5EPZoceHTY6e?=
 =?us-ascii?Q?XwaGgX5jV81M5ePytCrjPERFuFaCA++i06z+do2yEPFNIsdcYVskeop54wDL?=
 =?us-ascii?Q?ILYxlpE8GjRUc7ClO/ZeTzkcI4V32Ct54JV/S+KxRw1OgrfPxmCoXn1RTxoa?=
 =?us-ascii?Q?qdxagtuCw+KmZ0j5tVzM++c662HPYUAgHxzKiRF60LuVJbxKZ/SknBYJxDKZ?=
 =?us-ascii?Q?hVYsxyoVMZ6xk+2j2queoZzIJtU0RjfugzKohQswBVqXzNpDPx5N5edw4cPd?=
 =?us-ascii?Q?BGQGhoNb0hkc3qeP/Zro+4VRk0PkFUcfnk8h1liBuaEDnTPw04XwFKi0RJyd?=
 =?us-ascii?Q?lUQGmDyyg3chSX9ZxkxuopMlbSFyj9sy6QBf8bg8iEavCxu3T+xk9wCLd7L1?=
 =?us-ascii?Q?EKP1AubRWmmWGjehxlUfoHjXVeE64dZZRUU7Ico0Dbpm3z1TioCTo4oc6viJ?=
 =?us-ascii?Q?wrmn/on81HVPhsCuI1iXeD3X8u4hzn0qvNGrblyi47TeIQ1u4onygO5D5JNU?=
 =?us-ascii?Q?1JlPrnURnMK+dZsSiAa1P0nytAZLm5mqHEKrCpneb4krbo4deujIHJ+zbgL+?=
 =?us-ascii?Q?pTjzwW4yRV/ZGb3t6uSksuQlnBMzHRUJoJm9UwlP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 569c778a-644f-4d74-3b8e-08ddb79feed2
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2025 06:32:49.0281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BqVXEpy6B7C/CUqoYS8JM57RnjrDIa1tlGMJE/Glq5u7nAEe8+f1rlCBbn7LRJvtgmKxHH/WWNTvZ/kOS2CMMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7843
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, June 27, 2025 6:56 AM
>=20
> In the below noted Fixes commit we introduced a reflck mutex to allow
> better scaling between devices for open and close.  The reflck was
> based on the hot reset granularity, device level for root bus devices
> which cannot support hot reset or bus/slot reset otherwise.  Overlooked
> in this were SR-IOV VFs, where there's also no bus reset option, but
> the default for a non-root-bus, non-slot-based device is bus level
> reflck granularity.
>=20
> The reflck mutex has since become the dev_set mutex and is our defacto
> serialization for various operations and ioctls.  It still seems to be
> the case though that sets of vfio-pci devices really only need
> serialization relative to hot resets affecting the entire set, which
> is not relevant to SR-IOV VFs.  As described in the Closes link below,
> this serialization contributes to startup latency when multiple VFs
> sharing the same "bus" are opened concurrently.
>=20
> Mark the device itself as the basis of the dev_set for SR-IOV VFs.
>=20
> Reported-by: Aaron Lewis <aaronlewis@google.com>
> Closes: https://lore.kernel.org/all/20250626180424.632628-1-
> aaronlewis@google.com
> Tested-by: Aaron Lewis <aaronlewis@google.com>
> Fixes: e309df5b0c9e ("vfio/pci: Parallelize device open and release")
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

