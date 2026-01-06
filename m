Return-Path: <kvm+bounces-67137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 04457CF8B86
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 15:16:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E48E6300D412
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 14:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D24733A010;
	Tue,  6 Jan 2026 13:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kwg+CEvD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2000339873;
	Tue,  6 Jan 2026 13:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767706334; cv=fail; b=fzTFhFzLxfWBcR4VWz7km8/coqzklvXK63caBJsefY04yoL8rSrschqSeUC6tuYhrdbhNBtZem5jeYWDF5/cmn+i02T/Y3D5ot9cxMXAeMc2oETBiISJ5sXkj5rPhAB1UJSeqMQk6BHg3wrAmkTKKfT2Yeh02H6GUFQFy7CyOl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767706334; c=relaxed/simple;
	bh=ajN8rjjykZoMaLo9Y+iMXUyR/nIvQuiRVmdCl/aIixo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LaHJSw4Jg5vUmi+TC1IdolVn7eNpFSRr9iGuDVWwM27IgV1hNWKwHZVgqjIo3FufRdXS43Kw96gNI1tzN8bSAJyfNKmkkPvjZDVkNyxm4sfivMzJ9YprJGddN701972nJmqTiP7qJifWwy1hyXFkp7bmN7g1+PGRYZbRpOC8t+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kwg+CEvD; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767706333; x=1799242333;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ajN8rjjykZoMaLo9Y+iMXUyR/nIvQuiRVmdCl/aIixo=;
  b=Kwg+CEvDy8OA9LOrMKNFc8Z8tmUnZdQIS9gRu+ZxhXnwp9L9YXnE+LcF
   wuupPS/WWJGOStIGbgyGBxVKnELjqOyYm+WQ5ZpyR+5kv9Jpwz8dmJ3qU
   XlH9Bp1pL7Q+CmetGx/Ou2MAyz3s+HRM07AEH3xB2IbCxV2WYSfDCmvvV
   N5mr5wUXVnx9DlZ9Q0am2I17zRPZDoBNf2+PLBE4iKfR5+25YOSS2Lf7L
   iB98AEerstWomRXzKkOtpCjjRD7Ekb42ZXpzwm6GM6FnEsMuR/zFUyeD0
   cMh6f7uKt/eNKmAip94FQsibmH41Qcsk9uCga3dDdk+Z3ON1ZjwiFWjIS
   A==;
X-CSE-ConnectionGUID: d4wrcPTgSb+u2F+FttTfUw==
X-CSE-MsgGUID: lF0AugPAQUe0yOVpSMWCdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="80519934"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="80519934"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 05:32:12 -0800
X-CSE-ConnectionGUID: xhw205j9Q3SEEfM4vFyT5A==
X-CSE-MsgGUID: gnjkiS5ATEeuJyTEa3T5nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="203116348"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 05:32:12 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 05:32:11 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 6 Jan 2026 05:32:11 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.32) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 05:32:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MbS5CM5caiCWKl+wg+DCxluB7ZzpFek6k3WC1zhOg5inQlNgH/mAEf79wHUhK9Afs89EUGlzAsbeWLoTVbaFuHn298+ExDGsTAeONkMwk0S0RgPb/41v2081KZSiE+BcwdxJftxGtuazsNZ6xLIHcedBzIdggy3Lp9UBCh8ky2Pgf/+CDEyINmWNnTJY16yuD+UOVzggU/ZTNiL3VVowYtncPUAPB5PxYZJ4JZxAAJmqB3IbtholTma6CxNYvbMSK2RHRWcTSdLW840whCI0jnnsCMnd6w/nruIiHXgDuETZir2o6slAzAV94lHJoA4If7BmJiNHIZ6mo/cXO5VNsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pmwlONCdTx1fAVoaAr9nWHvUV15iWLfaBcL8/DHNV0U=;
 b=Q7BYzUOmA4RWd5nMLVDK/ej4NlpsptOj/5TZ+9ZGqDo7K83IUsHr8hm24Mh2kzpuJMv0jcn3xrzWOGNlrAru5YnoD09it8Jri4aUfexOBUFQadifQb6icpUKMmR0Kv0u0IYP7EZzKa57SacaNggc+X1SWwIGMd95Rb45PoJxIEQgHaLqDGVqmTvbBr2NMjJi7EINO+1qgIPCKPbNTMV2tDz92Vq62K/Jt1F/3LnBrKhre6x+y51pISeXHqnLRf4GDsUMOS7hSj0aifzRv2FCK1zAy0CkxohBXz3iUEP+yz3MxkVzvfUP1pIXtmEEpTH2WySodJInakSZ0ri2g14rGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA0PR11MB4541.namprd11.prod.outlook.com (2603:10b6:806:94::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.5; Tue, 6 Jan
 2026 13:32:09 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 13:32:08 +0000
Date: Tue, 6 Jan 2026 21:31:56 +0800
From: Chao Gao <chao.gao@intel.com>
To: Kiryl Shutsemau <kas@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, <vishal.l.verma@intel.com>,
	<kai.huang@intel.com>, <dan.j.williams@intel.com>,
	<yilun.xu@linux.intel.com>, <vannapurve@google.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/3] Expose TDX Module version
Message-ID: <aV0OzCYCZbkMVyLb@intel.com>
References: <20260105074350.98564-1-chao.gao@intel.com>
 <dfb66mcbxqw2a6qjyg74jqp7aucmnkztl224rj3u6znrcr7ukw@yy65kqagdsoh>
 <aVywHbHlcRw2tM/X@intel.com>
 <idebornlxlwj4zuk4h3upaibez7vcqiynzuqj65q6sycidax65@uqsqfqqosekx>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <idebornlxlwj4zuk4h3upaibez7vcqiynzuqj65q6sycidax65@uqsqfqqosekx>
X-ClientProxiedBy: KU0P306CA0010.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:17::9) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA0PR11MB4541:EE_
X-MS-Office365-Filtering-Correlation-Id: d61ebc80-631b-4f56-42bb-08de4d27fd6d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?96fqjIpm+WDgbumdde+yFQgvZUY1AzBWoiESQz6DmoXZ2FyP7pbEF/+TZfyO?=
 =?us-ascii?Q?HC85pNQl5mMqjTLWky3wV3lgw1QS+fHqwMhCL+5nMyJrGClCgKN1wdoel8Cz?=
 =?us-ascii?Q?S9p38NE4nM54FiaAnnda/DfItYTzn8qnz1L/4Rvqh33r06HvhuLUWx7L5Fde?=
 =?us-ascii?Q?DNEpYI9X/TJ0j1diZbZ64ECXzErxMtMBLvs3kG13hJMXFsMpzIvg1sKmnkRt?=
 =?us-ascii?Q?e+l/Ik1T0+JYtvu09gTkqzMkoURnZG9iRC6obDITtx5LH/+VqWVCs9Hr3WeK?=
 =?us-ascii?Q?71H1uGYdQA0uhNcEdBQyRzGhrE+ZakBpx6F0tv744uPrj09dd2ceALDno1pe?=
 =?us-ascii?Q?ElJeP7jQNGelmCmVhKVdH64EirYHEs8wQNdBz08s34xm0Om1SR6bDYOCeMkU?=
 =?us-ascii?Q?ITSE00R3Jk3FYGLqqCQjqXrjssJ+Rcv8kIVvb8fbQq7nJF6931/G7etV2ybe?=
 =?us-ascii?Q?1Gf1ECk8LOPHdbMuKWMCSPkaa1nKGz87ah4WdCHs8DRDW9MbeQjZmCeNGm8H?=
 =?us-ascii?Q?Jc9H0J/nhgAOnpOYJN5dcJObBzozfRtmKz0OnuJG5XemTvRsO1hJrl/kyGzr?=
 =?us-ascii?Q?RA7/yQ5V53vsljK1gcyPmALpqbYBNvfjXyp6u8AFoY/PNqJbPPQKsMoVrPBs?=
 =?us-ascii?Q?oViMUklPJTF+JtZ7uc1IbY55hx+q254927dM0z9LeXNNfqHUjhbUV9MyfqC5?=
 =?us-ascii?Q?fxVwhLUN24vwa85WLWYKV2TVZ3+F4QwFZIDN183/wSqSoN3j8Fg/9Clto+af?=
 =?us-ascii?Q?v1J/P2CY8vpsPqpfV/csLn4Z6unczJ5hYw8CoDwy0KtUN9CtypzpZpgXYQfg?=
 =?us-ascii?Q?uehWredLuKyZLEn3k6RiJHRd3hU6tG+R0KCEFcas01i7UsT/9Gxc6H/sk8i2?=
 =?us-ascii?Q?nvGF+QxOrBWg+G3kvM5hner40wwcXh9C/CwWCdW9rgu4ly9zIL/ziMV7VdY3?=
 =?us-ascii?Q?ExfkHFNmogAwCo4PytZodeEwD1vQHlgVemmvynBpWD5tbcT8IJEq9hBPZ5LC?=
 =?us-ascii?Q?aObTyxreURrq4QMmKaK0mKs/BpDp7n+OaqAgUyVZdLAGz9YlkiGebmEYOPMe?=
 =?us-ascii?Q?XkcfEHDPEWuhJrSBjuwtxR1nY5ymKZUqlxf26mc914O/RnZ3PTBUvgY9VlK8?=
 =?us-ascii?Q?HhUm/6P/kFkuj0JrMiOAXlLzVslclHk88aHsgfa2y+Y5YNVjrUQ7x27lVgdV?=
 =?us-ascii?Q?EfeyochAZMzc3Pz+L+AJKjXFIlyzivy0rYevCf+f5k5d9mfYxTUaBXVH/Mzs?=
 =?us-ascii?Q?L9IOERqb7W36+91DnOK9actxP2i6OeoiW7UC+1OKHPX8g8QoTAcPLS/Jt9Bz?=
 =?us-ascii?Q?eFI3z6kdLcXZmzRMzqIK6duUM16wHcegQOMaaaV6/nBJig68iFOK20XuwYmb?=
 =?us-ascii?Q?vAYVW4a1yXiPptqTx1muKUBzikWth5GHWCt/UaokJ5SI1RqOJINiV2iUi7R+?=
 =?us-ascii?Q?LMFGqnAYiF4KfCH94hNf9uhZZdBjLHdZ3q5yMwreX41oUhMFXK3tmg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0r5QVDG2zXAujThLtx4lY6sGQ1Z2CzjtS6bKU4Y+++dl6Aob0nw9csQrVCdf?=
 =?us-ascii?Q?PrFd0CkpGCjrs3LxMIF7EZB+wpwiTkAulkasneosiq/WPezsncFkkk2PGiQl?=
 =?us-ascii?Q?FHb3sOsSKwSA9/U0qPoq/zlQEHm6XAP9n23cQ+g+LzxxbNHn2O9lt5QFwrY+?=
 =?us-ascii?Q?HxM1h7dKeITTSFITLWWeBKTaTUVcjH8KBc2WXwRgP5FUuNzM0HXBF+c8IYHu?=
 =?us-ascii?Q?1m+Xqm4LsdG7Dpa6RUfYbmeAe3tI3pG9x8QYm6WPc5xmNoC3zaqtphjrwcS6?=
 =?us-ascii?Q?cXRLoSHooRjS1OlVeqfM6J7cSebXSS2gNOXOmAhZ1Vfm/sJt+qPmuwAcscfh?=
 =?us-ascii?Q?AlsfznzY3FLh+quSWZMzaX3OCYV6M16t8o6uRNgRZlo7U6pTBEmGiUrV7IUe?=
 =?us-ascii?Q?KAx6dmCZ6roKpeuNhPOEnhq+G5+KvG673CUROEChA3Mu15BUqtjFdihVQjhY?=
 =?us-ascii?Q?MqSclNh2MgVM7m1H64gXufFAMCAZ1vd9498Av4D5iR2K0uKCrshT3cIef++H?=
 =?us-ascii?Q?sJCGIgfURpmTvKNelYflkafHbahHh93ayMwW5YzlvSeN0zoHRsM660NhOmB1?=
 =?us-ascii?Q?1QFx3rqlS2jKFwZ2giX1oBIm96Mgjdsn8lpa0IXGpApCcYre+nA3D1DuLU4q?=
 =?us-ascii?Q?JJIpTJrGTP1MnOicaYsmaSKqsvcjCRV5Yhm8EIoiy07p+SHlEPQjgPJ+X1Cn?=
 =?us-ascii?Q?w3H2LiQ80d0U/JpXtUSL1EPKhvFiaWM5zjWU3fCusjU040g0BVpOlACt2XRk?=
 =?us-ascii?Q?wIt1u9uMn4UzmiFhwqTFgA7QFd6Ghw+e3FaWDdJCyqWbJ+duv5FF5H9AkDup?=
 =?us-ascii?Q?vmZm6NfuM+z3TjShCKGyVJLZw5Yx5g9AOaSUfvJEVw+73v1JTw+CB1eGuB2G?=
 =?us-ascii?Q?JB2Zd+yl9O5ZGCZeiWbRQ7FSLcaryAsn8slUdquwrpZJTzhLa1vEtfni4Ssn?=
 =?us-ascii?Q?IzxoFz61JcFLL1FR0DoQwqbj/G9+SzKi2LPkr5Zbzap+i54XgQoVnvz7wxEq?=
 =?us-ascii?Q?cdBoIukorV8v8XVhnKRPPmoJyxwC7yAqhdmIXiySQYelolVe4mtrBuJdV7Pg?=
 =?us-ascii?Q?yNyZVmiHhAHbgwKdjKBRJ14anNyyOXHWmCXF8YpNbPtInODTktz0/jP8hNF4?=
 =?us-ascii?Q?ut52pcl8dI4PwQmIVwdPh5UuQEuMeCGO8lO1w1AZ91R5xQWFS7uB8Sm8z5No?=
 =?us-ascii?Q?O2DKT4Ba9mYTPIBsERmhwI8aQX/ab76eGT1IjI09iEWo4u6rz2LfH3KfvLq0?=
 =?us-ascii?Q?v68e2zwuzDdwZ53Jr2+LB6qvlStqxEpOvYx+1zWshXpjkoNqMnEGxY4cxOFU?=
 =?us-ascii?Q?G060/efSJcQ+fpFaNpWmIdOOCHCwgPOPgDDwExXNg72RDE6oRvJLlxnvk87S?=
 =?us-ascii?Q?wZ9JSvpfHMF/Pf1LuUdTppTRnBiTUK53Jz3PyFiZQWTUTBaL+C178H2nLCZv?=
 =?us-ascii?Q?6BCW5U7aQplhO6CAYwZDoZiWG8n2hYXAAsQZry7d16qU9/s9b7/uY2cFPVLO?=
 =?us-ascii?Q?zS6tBOoXnVm//E2+WfXFk2IZkerTxJ37rB1vAAsZpnTUnhhoEnIAHyDrh4TU?=
 =?us-ascii?Q?3UPz966SFlFHrF9tICWyOGudlfl5kbhGhjKWSLDn8t3jO2HBqIvS5uxJzDp7?=
 =?us-ascii?Q?8JQ3tKj5B9WdVCA7VRMBoainGC7s6WHEjPDy0Ozx6gIcdoySFLFyzqjKl/+R?=
 =?us-ascii?Q?l/2pCHmw/H+EqF8uDraVve+u1DRRbo3ssuhsT9iPPzHNgcofVYk6AaHuz0Wr?=
 =?us-ascii?Q?e6fSyh45Cw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d61ebc80-631b-4f56-42bb-08de4d27fd6d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 13:32:08.7700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ffJTsIRI093emCL5WSwV1KFDNU7bDWGiPJzP+t1xoM9plZ/MENbovaq3/C1PVuRG9abbLoWffm2qlbtETRkmqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4541
X-OriginatorOrg: intel.com

On Tue, Jan 06, 2026 at 11:19:46AM +0000, Kiryl Shutsemau wrote:
>On Tue, Jan 06, 2026 at 02:47:57PM +0800, Chao Gao wrote:
>> On Mon, Jan 05, 2026 at 10:38:19AM +0000, Kiryl Shutsemau wrote:
>> >On Sun, Jan 04, 2026 at 11:43:43PM -0800, Chao Gao wrote:
>> >> Hi reviewers,
>> >> 
>> >> This series is quite straightforward and I believe it's well-polished.
>> >> Please consider providing your ack tags. However, since it depends on
>> >> two other series (listed below), please review those dependencies first if
>> >> you haven't already.
>> >> 
>> >> Changes in v2:
>> >>  - Print TDX Module version in demsg (Vishal)
>> >>  - Remove all descriptions about autogeneration (Rick)
>> >>  - Fix typos (Kai)
>> >>  - Stick with TDH.SYS.RD (Dave/Yilun)
>> >>  - Rebase onto Sean's VMXON v2 series
>> >> 
>> >> === Problem & Solution === 
>> >> 
>> >> Currently, there is no user interface to get the TDX Module version.
>> >> However, in bug reporting or analysis scenarios, the first question
>> >> normally asked is which TDX Module version is on your system, to determine
>> >> if this is a known issue or a new regression.
>> >> 
>> >> To address this issue, this series exposes the TDX Module version as
>> >> sysfs attributes of the tdx_host device [*] and also prints it in dmesg
>> >> to keep a record.
>> >
>> >The version information is also useful for the guest. Maybe we should
>> >provide consistent interface for both sides?
>> 
>> Note that only the Major and Minor versions (like 1.5 or 2.0) are available to
>> the guest; the TDX Module doesn't allow guests to read the update version.
>> Given this limitation, exposing version information to guests isn't
>> particularly useful.
>
>Ughh. I didn't realize this info is not available to the guest. This is
>unnecessary strict. Isn't it derivable from measurement report anyway?

Measurement report only has SVNs. it doesn't contain the TDX module version
directly AFAIK. But yes, I think the module version could be derived from the
TDX MODULE measurement (MRSEAM) of the TEE_TCB_INFO struct.

>
>> And in my opinion, exposing version information to guests is also unnecessary
>> since the module version can already be read from the host with this series.
>> In debugging scenarios, I'm not sure why the TDX module would be so special
>> that guests should know its version but not other host information, such as
>> host kernel version, microcode version, etc. None of these are exposed to guest
>> kernel (not to mention guest userspace).
>
>I already dump attributes and TD CTLS on guest boot, because it is
>useful for debug. Version and features can also be useful for reports
>from the field. Reported may not have access to hypervisor. Or it would
>require additional round trip to get this info from reported.

I would say a bug report likely requires other host information - CPU model,
microcode version, and kernel version if the TDX module version is needed.
This means we'd need that "round trip" regardless, unless we provide all this
data directly to the guest.

I do think exposing features within the guest would help with debugging. But,
this raises implementation questions that need careful consideration - do we
just expose the raw feature bitmasks or create human-readable names for each
feature? And it looks like an ongoing discussion [*] may intersect with this
topic. So, I prefer to handle it in a separate series. 

*: https://lore.kernel.org/all/4c8524e5-b3e1-4113-a4e3-d3615465d9a8@intel.com/

