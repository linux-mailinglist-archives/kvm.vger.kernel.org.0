Return-Path: <kvm+bounces-49568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A229CADA647
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 04:20:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 310C97A717F
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 02:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 883852882AF;
	Mon, 16 Jun 2025 02:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m8iF8r1P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BD023A6;
	Mon, 16 Jun 2025 02:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750040442; cv=fail; b=Bnf5/nmWOh/ajkg7Z5P26nIvFVg54UmhRGAsARo7zmMT+oN8uhci7eLOXXNEI+TPqJg7I4b/AovWxyVBXyXjsGk7Ss/LTNdgF0J0FP7IsyWABdvZPxc4pXThXubfaaGA5qJ73OVHwBxbqN/Snud4kIA6bxQZn/EQgVbsWnUW8FE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750040442; c=relaxed/simple;
	bh=m38tc8nPZo5Nr+vE0Karlbfl6dROg97oA86a4OQS4Vc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ntrc2fWUOc8JgNdw0JTObUa1FZH+ouMP1tK+LW2NFe0U134FgagdNrFycTL/vCwM1XTRJkKZ4XHz8FfqjdpW40in3UThSrDpALoRysYJjfPkXlosMSFXPZPxLhRCUwClTlq4MXoGAFsuei7ht1Nmz9ETJcUQDhwDMOJvU6LlEIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m8iF8r1P; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750040441; x=1781576441;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=m38tc8nPZo5Nr+vE0Karlbfl6dROg97oA86a4OQS4Vc=;
  b=m8iF8r1PhxDgqm/q+CFp4OmhxJaIo8bGCVBetjnJYUoUShfctbxkodo5
   Dyn+d4vEG3R0vCByn2J5GUruCVhssuz2JYnmtW85V0aCC+n9rH8TaQ58O
   Qkwc0Iq7txV05xbS/tEWZgdRxxWrF08bgmYYye0g7ox49eCmkGYnY3HXO
   xkj9N9KGgHUTGmSXD5nHvQQti5Qd25YDP0ck2tKK137hGzcRgQypytuG/
   Jt90NelmU188gY5SuWxh0ZB7OXbpiEq2JU+vpPx5BEUPIje/PHY1G6dWA
   SNY2113Nm4vKzN/isbSY9D3bIs6cc0oENIPfWLueXYvCxTXJuDx1sJ+lc
   g==;
X-CSE-ConnectionGUID: E86NNvZtRfi6QOPs7vBDsw==
X-CSE-MsgGUID: Ck2R0kFBQ3ac33wJuhpPKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="74705557"
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="74705557"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 19:20:40 -0700
X-CSE-ConnectionGUID: hYrTo5EKTeGtiCiUYdoB7Q==
X-CSE-MsgGUID: ugo9wX2PQz6xe5ZaHnDg/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="148239672"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 19:20:39 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 15 Jun 2025 19:20:38 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 15 Jun 2025 19:20:38 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.52)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 15 Jun 2025 19:20:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bvO0NRJ1J/di7b5lQi4uPzJDafoC7PpMv3DOHsEGjHpzk+WEoD0iWtKSVafUi6+gRs7/iP4skakwy6z/C3gKQF2I037jooXQ0ohj+mzv2t0RI9l5KiET+rTt13lbUUp+y2qjY0hoOYL2d8Vd35E1ihr4y9lCuTEoePi78ZXC5+tf0i5HSGn0Qu6tv27luBIM9tOuY5jnBIMKo5oLe58fvsI9/v9xoBTE/tnqOC8kfYMY8Af4mcb8n7qfZHEfU3jR8OGHMvJ6nHLp4QpfwJIXoahrkI4kme7b5Vjohn9Ga5kMgyP8B3ka10LxwDiJ7QgoxDstHzuv7OBSgIPZ3wPwEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gdXevTy83jzTXqBt9mMGWUXeMYO7D2rFhxljCV3q/QY=;
 b=zTnWPW0VIxEyWCNYm23kUboIRjzB4RCsGP/Rn4Sk8jUh5bWcmRw0D3WPcRQ7kuMdXglG5rUsljSAjNIL1wcez1chizl82PdOAYFEnP5wKS7Zh1NGaDgsecDF6xwa+84U665MuFbeaBwD8ES61d/geYAgt0snXOB1/Xpdaj3nmHYbrXbmHbv3Vy9idzKc8NtAZD24Q++KEeMPJkaD5LQGyqOEtWDpmSWzwgUUxt6/31K/qz4nFj9EF0tWgSv8lZWJeXCt3DY82WAbDJL7XpIqoNIHx+CUE4pHMM3BmveRq/Hy1JwqHbnJcLo7FF17jIV6jJQMQuLkzLdUwVtH+N8tEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ5PPFF330187AB.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::860) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.25; Mon, 16 Jun
 2025 02:20:36 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8835.025; Mon, 16 Jun 2025
 02:20:36 +0000
Date: Mon, 16 Jun 2025 10:20:27 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: Deduplicate MSR interception enabling and
 disabling
Message-ID: <aE9/ayZNEXoA/ZEE@intel.com>
References: <20250612081947.94081-1-chao.gao@intel.com>
 <20250612081947.94081-2-chao.gao@intel.com>
 <0d1e9a86-41aa-46dd-812b-308db5861b16@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0d1e9a86-41aa-46dd-812b-308db5861b16@linux.intel.com>
X-ClientProxiedBy: SG2PR04CA0178.apcprd04.prod.outlook.com
 (2603:1096:4:14::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ5PPFF330187AB:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fdb50aa-b6ee-4c25-fce9-08ddac7c6127
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?eIN/RTg2wfuY3JIU6mnE9iWvzrcFhcEAiEeqvDC4aKQZDxFSLL6PCXRlme?=
 =?iso-8859-1?Q?zVQ67Z5Q7KI4m78CcaNE9g3CkapRbVrb02zwHIZPloPDyELGRUBDpRFcnQ?=
 =?iso-8859-1?Q?vLkC7xUoAsxhnaldPXTVxivq+6dYCHodDAPTphOZSFL25xqhT5nPntc3Hr?=
 =?iso-8859-1?Q?MkxYWVAh0JsA6j2aPgUpBjUnRX2fn8f53NDA7UPO60YW2yZ8qbv8DKJs52?=
 =?iso-8859-1?Q?v/dOnAb+5CRVXxriObKiiyF8S49dlGmBJV+c+dNiT/upZ4x9wRh0ocQw0c?=
 =?iso-8859-1?Q?7kcVOeHMhEKhmufD6Z6SWcGwbxMwcSc2NPOpNnx48fR+Qj1iQNYM5A0Tj/?=
 =?iso-8859-1?Q?GbOCY3KKM/ZISpPEqhe0R/Ryd+pu5Fx8XOeQLu8cUemj0JIdDvJXVwUFDt?=
 =?iso-8859-1?Q?eWauKsre12TruiZhU1T/dnbFCSWC/IsjJfEXkypvYGi8mycAZCz6LDqP51?=
 =?iso-8859-1?Q?n5Mnp+EYtg2dokQ+tIOVSmqgR8N/qBLl/EL+h4T8q6ckqdiixTb6ArjsvU?=
 =?iso-8859-1?Q?fLHxg5ntBm10ABSdvRsU9It2UWHFSpb1CHrsYpQf52AV0IHSkBtzX8p7+n?=
 =?iso-8859-1?Q?br86QvNCndOUgmehoGoy2FMN0O8dq64nbGTX9MyZp1Q01R6n6XpU+AKTQV?=
 =?iso-8859-1?Q?wXs8L4I0apnmkAUcoc+R+DmKwueWVOgCezrcaHPB/DPFhv9TjDnZaPVHrj?=
 =?iso-8859-1?Q?SaA0lO9Hab4jrOduq/9AYwQsi//DrKi0z1kBetI+ZkRo7G/MS1RcDW/oyZ?=
 =?iso-8859-1?Q?Ixd79wa4uYSt0dgELRNTiHRQh+34YJKSOmd55sg7wX//Eh0qKrULI8inI0?=
 =?iso-8859-1?Q?2r1xkQOMQwlBJN/QbiYSw3ir8ORQZNr2t1NHQNaAoTC/MaUhkqsKqATGab?=
 =?iso-8859-1?Q?kfONTUkQJQiRPzZ6pqK0a3yX64zGCezol5RrexJP6pBQLtTH3qU2z2I9ug?=
 =?iso-8859-1?Q?SqGwOkIbP8gBcawsaZ+B8OehgkPdwkjaR1529TKBjbkmR4UV0OfdzueBp1?=
 =?iso-8859-1?Q?H/WTQVwI01SNF9OL5zzkyRT5OGFw8sD0zCd2BJUvK0MSjQ52y9lTKMgPR6?=
 =?iso-8859-1?Q?g2vYNtmHb02q62+Q601PzhCGQ7pKx1Vtwp0XYDN6lnzt7KJuARSNSYUS8k?=
 =?iso-8859-1?Q?4zyhk2kIynX7Ljt2ugTz1Hv3qFVVjTX71EvMGj2AaP0KIXwajuSiMhM/ZA?=
 =?iso-8859-1?Q?38VkgwPxcug52YsunQobw5bc/vqMV/mz35pno70hno6JwjpwiQ1p1+TTtQ?=
 =?iso-8859-1?Q?DQYmomcukQH7d3ClQJRyA9/dBawcZjS8ZJ8gPLTEaSX2g8AVQZceIFxVUR?=
 =?iso-8859-1?Q?sosEV9vd5PpEJa/f1ssDw7w4X5whAS7n5vDYhmp7IBf0/7iegzNmDmN6SC?=
 =?iso-8859-1?Q?+XozyvARd4FkLiFDN1DZNTSeJjuFYrGpK3Ov4tGCfHVXClFOAicLWJcoFK?=
 =?iso-8859-1?Q?rGiCXSgGJGqo0Sbx1rgXpx270hR+L8o8PY8LAQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?eSrmNih/eEhkb8wOLbifUMFb2cLR0FYgFKG+S43bf3SI0clEaH+2GmK+Xt?=
 =?iso-8859-1?Q?1bf5z18JGYQIVTLSjHl+eS0i67CYQ0J3axXKg8Lu0Zs/PA0TX0wF2Hrfo/?=
 =?iso-8859-1?Q?a4Dk4zGblMNnBEaf2pv8fdf+P00jHfy8VCDHylufeSuz3oDbF8ufRLiD6J?=
 =?iso-8859-1?Q?LpaoWT5lEC1WZNi4vP6CD3J9MbxXIms5EhaYyqbOuOuPfpwiZc3beCAm/V?=
 =?iso-8859-1?Q?ROnl+KCwflW8NnueTXt20pI8ewBCJ+VfXfv72Hz+G9S1pvWyp3NTkqeF1f?=
 =?iso-8859-1?Q?AzSFv8n9gOa7gYhrFlzD6GIpq3PcezI8LJuNG4/yfnT1QCgzSZTvHU8miq?=
 =?iso-8859-1?Q?c0BUD6lukL5Nqp6PPc2ftEDWCMorZmq+H9S2AgJbmiVPoyHcuZc/k6Por8?=
 =?iso-8859-1?Q?09J+eqfo/On0r9pny7RZenlOjxTUGcO2tyiypn9333GhzTWCGc7kvn98xq?=
 =?iso-8859-1?Q?a0TKaKBPV2YFpL+k41WjnxOAngqTd3flNVT3o8T7zGpYtfDrhZ2vyb/n8u?=
 =?iso-8859-1?Q?YsBzBJdgx3JqN3FLCu0t4p9kkDE0t82zJ+drUzi8IRB/Enwm7cCdfa0P7g?=
 =?iso-8859-1?Q?FKvBW+JSUlpPaOE8iOnMwDEBWuOSbSg5eQ6dzo5ZKhwpAuHt/24mPn2IbK?=
 =?iso-8859-1?Q?YPO4zdb0t/9lbBwSj+Hw4bLDRlx42b6OUv89Q+8V9ju7fgsM31Seqg4Gc/?=
 =?iso-8859-1?Q?btdjOYJPgMUCXodOuzMjhzuPL7AZYqMEw+uiboeTuvvsrknTeEqJsb+SBI?=
 =?iso-8859-1?Q?nqqCXYpUDHKg5wXTds73r6Hg3WwTeQY4M0XyJFj8UKTBwLUVx2idPlWstF?=
 =?iso-8859-1?Q?48cTBBc/pHvIRNVjMeedFKHSPlcU9OBPdy1AjYUvA0hoRcczzRqgO12Lbu?=
 =?iso-8859-1?Q?7PEQ4QJfxa95Xtz7wuG2MR0cyU9FKpRuJJo11R1L/980H81iW4z/QJR2Qt?=
 =?iso-8859-1?Q?fApneotQjN6V/8yj4l2vwcU+UAWxT2sJTr4JlbnGHFyL/adjbDCD0rXWxc?=
 =?iso-8859-1?Q?y1bu9WKk3WZqnQKNh3lO32muP9D1Sk0FufLWetwCI+iNa+k/g+gglDjJga?=
 =?iso-8859-1?Q?VMc5wY+LCTwiIRztI9zQaJ6vIS+Gl5m8fkGY7/NZ+tj+/P5dl0squXonXw?=
 =?iso-8859-1?Q?kmlEYNfKcAYtUMW1WqMKBgVgM5nki8cRLRNkWIOhI+pWUp6c10TMEkYh9L?=
 =?iso-8859-1?Q?tzyQAtoKHGdmkq1VtSew9sdcxPGr0PcMRY/DlLaRfrAhtfwYoeWhSQSyP/?=
 =?iso-8859-1?Q?L7qMAwsHLmCeGUF6tQNI6TZEtLaFA5rd4RR25LjG4TNwG7c9GQy6nqbFnR?=
 =?iso-8859-1?Q?3GKcv3T1MKoe8vLjmkUxkDVM4pjb/Cu6zWiYD5CAO5sjYxBm6oUh7kdrry?=
 =?iso-8859-1?Q?QN/n7WMPxoIu6heSb6Gu94ReDEOaI8XdW1S0bKHnd/CtxVsM4BRyhtH1Fe?=
 =?iso-8859-1?Q?L1NUspYSABguwafLL/0MH0l+laTe99yyAMwb66XCBr+Hs1YEo0j+d30xuG?=
 =?iso-8859-1?Q?8WnBxR+WvV3btgCfTFu5eMvaOPO9OKXWODJ0MByUk1JlIN0fXF0VVOOO71?=
 =?iso-8859-1?Q?S939Hc/zNuICyHyew+OaroWzXBwZf2sZSZHFUeFAkWs1q8Tm9W0zYd1F1t?=
 =?iso-8859-1?Q?xE5EedyEeXo4/ZRqFLuqfGqFjYnxqY4dgr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fdb50aa-b6ee-4c25-fce9-08ddac7c6127
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 02:20:36.4300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B3l2+zvuO81sLvQSJHhcmFpVm8Ty7OR7y3xjcayjxXIIQWe3EgYGSkS3iAennnMlysxnVZ44bVedEGRNVsnUcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFF330187AB
X-OriginatorOrg: intel.com

>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -388,21 +388,13 @@ void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
>>  
>>  void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
>>  void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
>> +void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type, bool enable);
>>  
>>  u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
>>  u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
>>  
>>  gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
>>  
>> -static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
>> -					     int type, bool value)
>> -{
>> -	if (value)
>> -		vmx_enable_intercept_for_msr(vcpu, msr, type);
>> -	else
>> -		vmx_disable_intercept_for_msr(vcpu, msr, type);
>> -}
>> -
>>  void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
>>  
>>  /*
>
>The change looks good to me. 
>
>Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

Thanks.

>
>Just curious, is there a preference on using these 3 interfaces? When
>should we use the disable/enable interfaces? When should be we use the set
>interface?  or no preference?

I think the set API is to reduce boilerplate code. So, use the set API when
you need to perform conditional logic, such as

	if (/*check guest/host caps*/)
		//disable intercept
	else
		//enable intercept

otherwise, use the disable/enable APIs.

