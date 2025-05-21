Return-Path: <kvm+bounces-47219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AF9DDABEB1B
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 07:05:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 627227B2A17
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 05:04:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C2F22FAD4;
	Wed, 21 May 2025 05:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jDgijrig"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A83512E5B;
	Wed, 21 May 2025 05:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747803924; cv=fail; b=m4bfalzRi/SnYhBFXMDlLr1AeJytbu+hZVHz0QBAVI3Vc6LjFf6Tb7ntdiC1USRaTTdc3rSHn8TSH5xle/b7lIOc7crR0OYTucAwzhQMyd1zPqpzofFQCvnxSoWUZWMbOR/8fZ+pvYn+ecQ8sxFz5N7AVr2bjAJ8Q5I7sYI1Vlo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747803924; c=relaxed/simple;
	bh=h22ZCtfnA+rNMrc81uElV9uY/0KvT6ujlx/MQFeXI+o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FS/gx5iSU+AGyGqZu3ljstxGd0yATd/c6immPBE2xghi2UVhbdfpvihJuD+ioAtvfRn64xsEbZB+/OzWCoh8xyKj4JcMJYXIJB3UlVx788KGhFC7lw6ieNKjhmCAB2pqJo2iSXHyWPfxNzIowNEKEwfFlhvc8mYdAUfAPeXmsVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jDgijrig; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747803922; x=1779339922;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=h22ZCtfnA+rNMrc81uElV9uY/0KvT6ujlx/MQFeXI+o=;
  b=jDgijrigRFe6W+2G0nNtgymOUPqree5Sk+GvA/6wOADrKNrwP6CpZuEH
   +feiRllRf9stjrofPM4O++pUaN0y8/b/X+JmMMSsLvfNU/OmblLTo3io9
   drCK8gn4fN3CeesdM0iL91ADqDbPftCM4KogyqNDxb+zCTapI0pD7JEZt
   eL3hJcXq0Bv1RYD6qeCNL0dR1HGjZBI4rXCgzRerDzInATPXBVhGlnhDX
   +Yo1KOanYBRHpuFQBO3lNuMuDuqOjlmub2ahLoN1IzP8QBVRB8o6NAviX
   l6snyLXyyqvp9S9hl4GtBHb8OR+hDAVlBt28dVF9+C+tvDMsL5UIlryuZ
   Q==;
X-CSE-ConnectionGUID: Z/EBAXQ2QkCYvtuLEGyjSg==
X-CSE-MsgGUID: 7xyVZ5tNSmGfer1tFzT0sA==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="67182381"
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="67182381"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 22:05:21 -0700
X-CSE-ConnectionGUID: OLJD8A3wRcqHa0ZfiK5Rlw==
X-CSE-MsgGUID: v30wNppcSUW70iDaNxxl1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="143901655"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 22:05:20 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 22:05:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 22:05:20 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 22:05:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zz3nvgDi8vIuRmeICxTuKeevAl0oCEakLxVzKsqXG7grY4Kl/3yqXjhZlgFeZ2jhAEq7JLerdrDc14DYIRHQI+KxRMiVO4cgE/uQAgR7VDU8UCpfHJ2p9tanjQhDCmuDRVZW6Jx49Heav2UUYskvApQU5S3fV18sI+8EDpsHJmZa9CCfGTD/C87dAwLZhb6QQezrKQRQrBWPG9vIzhGwuDbSNirNcmwkvI4erRytF2eJR1r7K8od8Hoql97u+AFMpjpVBxcClI1rKW3Hb9nHjUzo9+HJODalHlvdFeBDRb477XtidbozLna1OBsHUSBU7i6sB4cAZZClwe84Tqag5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ScKRrsJF5JOyBjkL8XgP0v8esXPpWgKWnOtPH2MJmWY=;
 b=bG9/+objvly/ZFa7+g/L3773fXYHXkp6rht32291JOqrClmEy6/mnrKqqVp4E0mN/j8qwXxg9kdBV/Vlk8riwCfY0JY5UJj0QOw2i7z4da6leUaPx3tWpYl9mIgW71d3wSaLpBn6t9owZVDd9sHRQt5kNZZt2pu97lmHXX8YjnoMACx8kMTnGD/iME9DLHJ4wfLfYizYxQIdjgv26A0zUy6v8s5kSJptK8BDkoNN06DzJ9a1M0I6m0dK6al3yQCfWp0Ln0yVdIdZx7nYim8K8WjK+zYrcIc7KrCmHoMLvIuob0Hb0osLWAYz+E0yTRSxuQ052x2aORrf8hvZsVUAQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA3PR11MB7553.namprd11.prod.outlook.com (2603:10b6:806:316::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.19; Wed, 21 May 2025 05:05:16 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 05:05:16 +0000
Date: Wed, 21 May 2025 13:03:02 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vannapurve@google.com>, <vbabka@suse.cz>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <zhiquan1.li@intel.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 20/21] KVM: x86: Force a prefetch fault's max mapping
 level to 4KB for TDX
Message-ID: <aC1ehlu1MfKI4J7m@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030913.535-1-yan.y.zhao@intel.com>
 <8e11fd2e-d77b-46cc-94c9-e542003c4080@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8e11fd2e-d77b-46cc-94c9-e542003c4080@linux.intel.com>
X-ClientProxiedBy: KU2P306CA0039.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3c::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA3PR11MB7553:EE_
X-MS-Office365-Filtering-Correlation-Id: d7180db1-8e05-4fd0-2581-08dd9825130c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?NhMlcWEdqezpz92WHAihZZoA/mmghsxFRIG2yk9hZIRi3ws0RVAUlNMRVS1m?=
 =?us-ascii?Q?Ipskx+FK0dJUTUz4HeLWsJoG+k58QnEiES99KYT1Q0ux/m9/Fxdd+NXduKCP?=
 =?us-ascii?Q?/PL5xP1CI0wa9C6C+81/zpsPObAq9btS6qwtktf+w9DQo9ZKpvlKPwBBBQNO?=
 =?us-ascii?Q?/+ZBpwhNSkYGgFMJQY4Sgl5dQpMHWiMQ2Gk7i83CiDX2YEnKB8aksp70aBUw?=
 =?us-ascii?Q?4iNZtXoVOZbupxoTNOI5nv0alB+44vdeS4NNFByjQfJ9bgzP8/4qKhm1zZ3h?=
 =?us-ascii?Q?NAsEGlMkXykKDqEDSC0xwparrtorks09E1BflS8D8reCL+C+wHu9WzxUd2B6?=
 =?us-ascii?Q?W2t72KDtf3rmFRcovS4PyWw4Hnimy82aPgWYAx6HHiLoMOf99/BVFMeV11eL?=
 =?us-ascii?Q?w4ACf2TxF7TwNQNNloH2pEwwlG0AKLWcDOhjsGsN7mVszrZCK0luBg6oPbTO?=
 =?us-ascii?Q?EdHmzErGn7Fufp4t6JS26dS8uxkH45slgUayu+MRiSHReisw6upQL0fpg7S0?=
 =?us-ascii?Q?dsTasN8w6PrZbP5Fl8vOxM5a055h/l0fn1B2KGE0/ebBzs8mFN1o4/flHfdB?=
 =?us-ascii?Q?ESDy3I+gx57hdtaYf/WhaUEIlUtdrDKp6xoht0jgJZywjkmLwcQutfRxd7nW?=
 =?us-ascii?Q?AJXrjBhtBq2HjSfp408tOBFEEzdSyFNIy/WQb3o83EIylnLKZ1VDZT1pA1v5?=
 =?us-ascii?Q?tbTN0XkEmgdEg5ybdGuUODOxuJEbXL9UkD/kaPpClJ6RivUYFBeyZhe5thSQ?=
 =?us-ascii?Q?qG/DdYwASfiYphCnbo+x5WK9Bpw6vLtCTacJlB//K1PTf8dcJADxaR8ytFAY?=
 =?us-ascii?Q?nz9XM38s5KY87E39eFdYYlfQq+P3OKoXd3pSU56Pndhg9xTJRVAiegfiAyD6?=
 =?us-ascii?Q?KzhbbMnKCDla8Odtzlw+eAkLm6ap8ZrZpbM56hFXYs10VV1ig4dbRq79TgRG?=
 =?us-ascii?Q?7mpeBjElOQGAIHT4kcrhHcl23u/3WDaAbDIK3YDYhGibfkFga/jOvK9PNCPY?=
 =?us-ascii?Q?rAINx2tijmaF1dwLnRj3u2g9FV3u7LxTa0gWUHOAJ/u0waboQ0LKgP8BYcqB?=
 =?us-ascii?Q?pxVjSZeO70Jy15b3SvHnuRPF/1ISj24AQU3Ywt3nQBjF1PVhrHKdYvs5KVxy?=
 =?us-ascii?Q?q4D+d1CXHZeclgjwvSZvT2jwSim8qrGmRiXnUqTm24MEKZ8oZyolOn7BLxys?=
 =?us-ascii?Q?eyMGyPBj2ggbIsj7get2tfVQTwsN3JwwLsdjvH5P0an6ezvU6WwQmg5VLnqS?=
 =?us-ascii?Q?lIAmBh4tElZWqF+w+w7zRPJM6di4V19H3saWbbkk8QZD1iCiuygJEDy+J7jP?=
 =?us-ascii?Q?X9kLZMHnhAVkU/ooqLuGkQ/7dAJ+JxAouJ5WUVettAATT1ywDLS+WQ6Pfz/R?=
 =?us-ascii?Q?yP8Q3NR4ASLX3ePM8B6l5aEoeuMD0EYJvIv6zy/AOY8L6RbaXs4ji3aIc6d1?=
 =?us-ascii?Q?hOImXwhNPj0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X1u492Ofr350vSy0OypcFQrkIQZdsC8lFepz38pHC2DZbNU7Nt55Z8zG1/rC?=
 =?us-ascii?Q?KeLM2Kg5oB91NW0QA5P6QIpIqOaAAxcRqkSreq6I2d80Ifvld5g4E31LUuuQ?=
 =?us-ascii?Q?lcS5MUX4DziNdiwYiKJrlfMMfqwmNwoFSNw4dHf27fRutpG7d2H9pDZrKbjp?=
 =?us-ascii?Q?9zYgbGZpP0oR6073e1b7n7OWd15qzVQN94aIAJh0z7+koKfFNnKAmJTrZ5U9?=
 =?us-ascii?Q?koEiy0VW5ItDymmJd80n03j15D3TEA9eQy7f6BTpSzkqYN/87PfE7gf0jOQs?=
 =?us-ascii?Q?MxMklVDuFcjv7iV81k78+QPjVv/MS5nGv284AOG7/XXrpe8rG4wy0JAOdysM?=
 =?us-ascii?Q?b57Z+EIPqBuEz9J5zQSgchZOE0wLUQk39u4gAKsMKCV7kEDXQg6NsyI46Bt+?=
 =?us-ascii?Q?vqoZg/OOZdk6310W3VyImZG7h/z/bTPZ8NwhgeMoGa+fteLwiEVF/cxV/LyJ?=
 =?us-ascii?Q?jwCoodnezEnHMxaZlYQiGX29OxXdExLx1gkKBjcE3JgJA1FtINPSyuX0ZdgG?=
 =?us-ascii?Q?HxI3q0jnSSG7DuarHIxo47u3BjqEk6CtXIbi/pIj2EsN5kJ8QVmgUT+t/t7U?=
 =?us-ascii?Q?MCrkimKGBDi6TcUJMzV5xDmXM6TlEdmbmR3IF8mIYpbpkTeCYTh9n61mYIY7?=
 =?us-ascii?Q?StENx8CqiRlpuM181w43Y/xD6bpQk1s6o+Sna2kzlp8CeJ9+GQ9IqxlKGUZ7?=
 =?us-ascii?Q?vZOWNsbnPGrCKGFgQRzqikuP/IGZMsPqICUBCpTdcVZhfwV8eTClkpr2BjC+?=
 =?us-ascii?Q?OE7rCFA/p5Kznh4i1AGnlrTS+9oqLq/4N/xCRLc+SGvsUhmW7IseusrlpbcU?=
 =?us-ascii?Q?nubBf2PVo/ZsWEavG2XYLMfPOUI+nSILIWyrNGjh8jFD/RWvaK1aWcq9GCLX?=
 =?us-ascii?Q?vCtx9CAM/uhIeMlc2ImN+bEsGwmTV448M4ti5fQ6b095iW6/ByhjWSU47uHf?=
 =?us-ascii?Q?G92yTO1sUDCiiBX9SDoHTRiHwIIq8ifmS8zLzLqknfuF8mPwilUf9v0f1BqV?=
 =?us-ascii?Q?+8Vpw/ViYw5D5pa4LDPCwJ0Uf+VOASpcNCMPaXUdMnD+MmNd/We8ae5boJgI?=
 =?us-ascii?Q?ovqoqQiULlTS6GWs1zCunXIFUbgoy1JDqipiztKi+J+Sbl+hOJqWGI88x1Vt?=
 =?us-ascii?Q?cqoDrrnAjl5KII/5lbPv7MJesNuUo/nA4NtuaR0X2UUddKBOmfghGVDdA8hn?=
 =?us-ascii?Q?DbmVuJPRVzhlNE6Xl0qryg8BhfDk/94PiKj8VXSdvR7yTNkwB7ZYtTQChDu7?=
 =?us-ascii?Q?sZD3qMWjG0egTZK9YiV10LpHqDclBQLJX1hAlUX65vnU3mzssD0q5b9E7Kl9?=
 =?us-ascii?Q?7CwHQ8baxrRRwbINkZOtQ+FxP8C2FN+n+/sKFjG2+RoqWP6UMxSbvX87uc2y?=
 =?us-ascii?Q?F72wOjcOc6o0k+4t4M/R6tLfd8MLlXvcY/WDTVhYGAuf8bt9gPSdDWIge3G4?=
 =?us-ascii?Q?3vCOragPKFhmpvS1qoVWl81kGwOLD3e8I243qvgFA5uBQGCGdDQ5GpFwp8qi?=
 =?us-ascii?Q?5fAWhj2A3Iv/fW6Mas8GtOba/64foKkOPketvK2CzU95sNt5QDXmP2tawEDg?=
 =?us-ascii?Q?1Z+dl7XN4E7xcZ7DPwWbbqSGv3vibiHRRRKdUSVN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d7180db1-8e05-4fd0-2581-08dd9825130c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 05:05:15.9081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c9cS2lESfKxdu1bsrdTKPmka4vVTPH/u4cXGY3nyeP5Js6m+Hjl7Emn994fylB720Eih1JCB42j0ahrq1u12ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7553
X-OriginatorOrg: intel.com

On Wed, May 21, 2025 at 11:30:42AM +0800, Binbin Wu wrote:
> 
> 
> On 4/24/2025 11:09 AM, Yan Zhao wrote:
> > Introduce a "prefetch" parameter to the private_max_mapping_level hook and
> > enforce the max mapping level of a prefetch fault for private memory to be
> > 4KB. This is a preparation to enable the ignoring huge page splitting in
> > the fault path.
> > 
> > If a prefetch fault results in a 2MB huge leaf in the mirror page table,
> > there may not be a vCPU available to accept the corresponding 2MB huge leaf
> > in the S-EPT if the TD is not configured to receive #VE for page
> > acceptance. Consequently, if a vCPU accepts the page at 4KB level, it will
> > trigger an EPT violation to split the 2MB huge leaf generated by the
> > prefetch fault.
> > 
> > Since handling the BUSY error from SEAMCALLs for huge page splitting is
> > more comprehensive in the fault path, which is with kvm->mmu_lock held for
> > reading, force the max mapping level of a prefetch fault of private memory
> > to be 4KB to prevent potential splitting.
> > 
> > Since prefetch faults for private memory are uncommon after the TD's build
> > time, enforcing a 4KB mapping level is unlikely to cause any performance
> > degradation.
> I am wondering what are the use cases for KVM_PRE_FAULT_MEMORY.
> Is there an API usage guide to limit that userspace shouldn't use it for a large
> amount of memory pre-fault? If no, and userspace uses it to pre-fault a lot of
> memory, this "unlikely to cause any performance degradation" might be not true.
Currently, there are no known users of KVM_PRE_FAULT_MEMORY.
We can enable huge page support for prefetch faults (along with allowing
splitting in the fault path) in the future if performance considerations arise
for future users.

