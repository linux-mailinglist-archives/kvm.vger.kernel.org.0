Return-Path: <kvm+bounces-47206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C687ABE94C
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 03:50:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09BBC4E1782
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 01:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B5441C6FF2;
	Wed, 21 May 2025 01:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PRz1RcZL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351241B3925;
	Wed, 21 May 2025 01:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747792190; cv=fail; b=G2Tr4H8s5wWArJ/8+fzFI9iez6/XGRrJvI07Q1hqtVML2KQRSq7IGIxGLk+jRGBMQx3afvMjOEKEZo6rJ1yQKbDk3wHQjXn0s4yaAZzwzQAhbKy4HRAHhmjhjuSjRdAWSH++4j4cCIX4PyfSjUQeb9IW2TD3Yr6rxx5b2WxzW+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747792190; c=relaxed/simple;
	bh=QPRTWpYqdTHpRR1p3DoK75TLiMozOKsATfili0eoYG4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XJorqpOcC8ujj6q1vFbDVzA7ERCwnQ6oiAYFs6EeRoert/5uUjj4GrtDDqWZXqf3m9UO+nJglp19cQqnIBGl4nZzLYVlG0DpP7PX3GHR01zgI8qN05EnaoMGkmq/CFODZRyCJCUcyYWvsBBhv2azSs6wQSlL5YigAdg8gXau2b0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PRz1RcZL; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747792187; x=1779328187;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=QPRTWpYqdTHpRR1p3DoK75TLiMozOKsATfili0eoYG4=;
  b=PRz1RcZLVMvNNrEmjN631v/YBhHRuw4DAv/5WHwSmazgJNT/3nbiDyqx
   u8ZaBXAmbbWEwgVj+a/8GcAM861HYU4G6KrzFMwJ5KEJ+xwdqFZBp0Z+g
   emFdcayOvq4SjDOFPhvb5F8TSGzz//jzqF86QOb4yeZniuGD7HTGQFOdW
   nK+USbbZ8pb2oYp4wWxcYWw2VDic2Cj2r3bnrHLcmdafGEyrV9M6n5gaV
   JGZEeA+fKiaKjFm10dqNHcfunktFNjht0NTt9meEJfxWA7u3U6YSoQ5YK
   PE/BxAbMYu1DkI3Ir9/EOWrjphpshkoxftDCQBOvPI7hTTUWBXLMTNbvW
   g==;
X-CSE-ConnectionGUID: 80uo3XrPQdqQNoTslQ/SFQ==
X-CSE-MsgGUID: KSu8otHpSOCyUW9OtpKLxA==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="60406601"
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="60406601"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 18:49:39 -0700
X-CSE-ConnectionGUID: 0I33BUCsRei8VqKlN0/5Fw==
X-CSE-MsgGUID: 3UuslT0LTVixCiMQ75st3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="163148805"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 18:48:29 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 18:48:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 18:48:29 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 18:48:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k5QI9IroUSIdlGRnbXSt0XFwo0UH4XLeyhzwiJZQr0YHjbQq5PEFdSt5QIjKeJIxjUd6YkTXLoSOkFInOE4hOdD4HgGYN6xPWfRNHU9RD5sTeRysIfHQhR2JOOliBZrSmM1mu97tne6/evPxoe6+u9RA00Q1ibS05xBSGACKSCqMa2HtcXHZfr2nrRhrC0y6ejZHEccM0WyfaLG+cxpCxvAiivV4vlUTWc+d7f8JGcdiRzOLwgGtV7kJnja0pZUsl2TsIKpJTpyvGCYpk9qQYi6qWVeLhydu2s9UchUOfreT2ctnT1dW8Unu+i5jOqfgxjT8U3Yrl/O7J2/GpXbF5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=swZEvKIwqHXozCLiPvORRPSEk1hKfvs5/gkPh99Ri70=;
 b=Jf9HTDor/tHV0cLf5uYXlBfxFXVOwi6JhOiLuuNJxVNwTU1k+b4UlSqDa6akCBkwrEtbsiBiDdDX+H2mHEc9N6CIQIbGJBZx9prsRzpldt3bp2o0lcARC98eVv24vzUFmNrK1hGUVnpkXA1oLNWgcR5w8RFW/XhjJOggZ6S+zCOmUetxJXWI8Q/av0XynU9q+7GaXh8K9IrbIb1U5y8s1dR3DQjNRg9EihhiGLeUsa6ARbOtJ5rgkHwXkeG5vs65nT+jHpU17YofSiAodOg1EqnDEcnUp1CJD5jafPSBi7Cnx4ukUO2y9YO2gXQaKZs7OVHv6kV6kN8IndNgufJrtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB8466.namprd11.prod.outlook.com (2603:10b6:610:1ae::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.30; Wed, 21 May 2025 01:48:00 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 01:48:00 +0000
Date: Wed, 21 May 2025 09:45:51 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Reinette
 Chatre" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Add RET_PF_RETRY_INVALID_SLOT for
 fault retry on invalid slot
Message-ID: <aC0wT68EY4Ybz+wI@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250519023613.30329-1-yan.y.zhao@intel.com>
 <20250519023737.30360-1-yan.y.zhao@intel.com>
 <aCsy-m_esVjy8Pey@google.com>
 <52bdeeec0dfbb74f90d656dbd93dc9c7bb30e84f.camel@intel.com>
 <aCtlDhNbgXKg4s5t@google.com>
 <aCwUO7cQkPzIe0ZA@yzhao56-desk.sh.intel.com>
 <aCyqJTSDTKt1xiKr@google.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aCyqJTSDTKt1xiKr@google.com>
X-ClientProxiedBy: SG2PR01CA0187.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::12) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB8466:EE_
X-MS-Office365-Filtering-Correlation-Id: 17773126-dec6-44b1-f30a-08dd98098469
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?W/QgpiZanOMZm7K6oNjOmISNG3u+LniCY3NCIPV/YZNp5lQZAPcpIC3hZS?=
 =?iso-8859-1?Q?XTBVXT+snoyPaEPXrF2GWxO4xEqYwK0FC0tMTHvV7UdlbRj2C9CbmuAH+z?=
 =?iso-8859-1?Q?QC84LDzCoxG8WY2c+ScM/dALCE2lrgiBIbEQ3bZTHfki9NDFf5XgbT1vNq?=
 =?iso-8859-1?Q?1tFnPULBNJ3aqnk0vnZep1i8sYTmpGwOCOMq0Fh9PGtcKmejCEUCGRLwuE?=
 =?iso-8859-1?Q?GRl8U+VTalBF0LGGXkBeLfAPMEFWjmQinWe1zl6SixdFxFz4rDiYYnRsc+?=
 =?iso-8859-1?Q?WUshPpXjDUnDa6khBtMmc3VEZQC5CQKBW5q6QdIohq240Yp597aVWXM/mN?=
 =?iso-8859-1?Q?JI1oZuT8dqxNXj7IsH/1yooecQyPzlQE9ertWPVbhqaFJokmedpqycoE3r?=
 =?iso-8859-1?Q?T0AiUXLOLjM03L/9hwrk6hTl4oRMli5Z/H+maC+FdmTfN5tuEwENtrrrst?=
 =?iso-8859-1?Q?XuoUI0SvVFse34OM5Dw3czhWOEtJTdoG39jsgAjQu8gIFeF5Retas1sBAa?=
 =?iso-8859-1?Q?k+IyZ2OyOjHOGM+WnW4iSDBclv3NM+YiJdv1j0LrPHdgkScBLGB84WbC7R?=
 =?iso-8859-1?Q?K1l+r3rmmf8Fgdphs/b5GztM9RjPVMi9bDTh55SjWyHIRDt/pp98cIyeDC?=
 =?iso-8859-1?Q?mEvpe/EUfhrEMKRA2/XQwd4XRUc784B37d7fkn+Rkz8gAKGWpfKTioUUC8?=
 =?iso-8859-1?Q?GEd+rSAbVhTcKk3wR5CE23iWOEJ+Kr362wfkEaAeTbh2Svd68VoGpcovxg?=
 =?iso-8859-1?Q?cEU7UCHec9MCVDx0ll73RwJ36VBnje0uH/Sf3h1ZiInzmpWZTLxDicDTvd?=
 =?iso-8859-1?Q?zKnG4OY4umUPG8zePo2XnIxwtYBbDVnDKvdU6YEQvJjGlXDdvURv1D+V7v?=
 =?iso-8859-1?Q?cae4A/OaIqPTXGGWZHrXHamOxef1VNsFeGuQVyvSJFFKK8Ge/mC8V4UtDi?=
 =?iso-8859-1?Q?w2HqkVCi6IeQj3U4SB8HyHgjZiwIk1xn8A/3ZxMTHGrD71stuIP71EA5Uw?=
 =?iso-8859-1?Q?ItVmwGp2AEIqRL8dtelIoZSEJyNbMciZBahoPwnQkD1WEQ7ry6/rKOyi1P?=
 =?iso-8859-1?Q?FY2ScNwfMnBzMpeJcl8tlVwDV6yQKNr2zmrrpYZ5/4Uuog76qKSKWsWRaw?=
 =?iso-8859-1?Q?c7pSds4e7Cz5JXg+w+oV822QomFkfT65ULrbQAjdmKb0Rr3TUEpFH4DcNA?=
 =?iso-8859-1?Q?V7g9xlZEPubWENQQEY4AwqZwioSVAySDl35nyS9axTJrWI2r0McKrp3PkX?=
 =?iso-8859-1?Q?Ws/MbIoxecEE+WVyJ7ETu2s3Iia6YpanQGdXbCceM71CO6+cBqNOcib0gc?=
 =?iso-8859-1?Q?ifV/RnGHakAmN07iiROAHMM54IT7j46spUsjaUBXAAnpZ6+KrpkZj/jDiq?=
 =?iso-8859-1?Q?9X37m8I9HPA/qnrpMPxMYMk/aN8FjcL/qRimUvJ41AwjHz0z+Cxk7r6uXZ?=
 =?iso-8859-1?Q?CY5a51MSE0qiPwS7?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?LS8SMzRL/O2XY+Z3G5XkOHx+G3odcERoyyVXHsO5Xi/DyC+37+dm5mV1EQ?=
 =?iso-8859-1?Q?vmvousZHc4SfUeiIaPXZ+n5Wa6Q+qHL9pLXUmIubS+edLLSVrNS1js8Lu3?=
 =?iso-8859-1?Q?F8iTB+1kK+ixe6n9GJODmScsDnFEaGt3nllbtRGyqi4IhndAMGnxKfyXeE?=
 =?iso-8859-1?Q?IjygveyTAcdAb5N7tDPGNEDG0wBF016VotILHtQOpln9r1GTLZKHIiG17m?=
 =?iso-8859-1?Q?a0UhuI29GwWUYFLhpvkEoRYfKdbr8yVRkXE31xtJFP77sqUU8vnHNZVMM7?=
 =?iso-8859-1?Q?XIQNioncKnWUdNtIGV/bkv1bL38OgPyMVYzSBH4Zy9b05455tFh9GLI+qM?=
 =?iso-8859-1?Q?BCOgj82T95tXomNHzLhGFddgRmJcVqtK2kv57k2srGNGXYGO0tFjgd/2VF?=
 =?iso-8859-1?Q?Ov72ccI6aw0yu7EtgrIH5hnvHEwEZKU9lrXnjI0hHOMqQYSBql9jDfWiZb?=
 =?iso-8859-1?Q?esoJW+qVvRG2l8EBKDkZhVCrA9XWo0Iu5ud1fl+qaISYgtKtBHTVI2sM2q?=
 =?iso-8859-1?Q?QZltljmCTZqRgAaI4Vgr4KaNEMHqj/I8AzeSjtCWK4GGhT5sybfmM/xuIL?=
 =?iso-8859-1?Q?VeTD1ojSy/LfaJ6QIbaICYHnnu9PF+Lj04crho2SrktmN2edfSyBIiF21C?=
 =?iso-8859-1?Q?053EeZkE0yC49PlDFsMRUcdYy+b58vWbu21ORwel7T+vOq9wN92dVo97JV?=
 =?iso-8859-1?Q?MakZPNbHjogvJ/4/6MEcMiSCdxVNQRin40KnDX+EfObB42yYjiEn3CE9Z0?=
 =?iso-8859-1?Q?/fQcuv5dlnPW23I7oZ/fz/27EqPYP+QpWOiUUv1x9vszadWiQr726rY3YT?=
 =?iso-8859-1?Q?qydb6uR4R+CR9fp3fS7UU1FAqtUB8+47n0CjKzsq0cdBD/kV9CyI0CD5mL?=
 =?iso-8859-1?Q?vTNo4bx+1p/AVp37zJ+xHeGZ8YO1SKJ60BMuVZqGPYrNzFgqQlxljS1OUx?=
 =?iso-8859-1?Q?Gm2x+ec6kHxREP/rJsoZOgC4CfqTVCcMg8E2UgvbueDzJL/7Z4LEx7gNZC?=
 =?iso-8859-1?Q?nMY8h6y27Ap5nKZjtL/J3QUKGmJij5SvKCKSz28uFhazvTa+dzAYNt841z?=
 =?iso-8859-1?Q?2yNkj7yMeom3G5ms0Le65G7FX7lKxRw1bCruUnnXD6b9UG0xXAA3Ac3cB+?=
 =?iso-8859-1?Q?LpnfAN1VcoDLRUTyuy1mHjkB7H5boaz8tWgjRkloGoLGnHEcIKCOY1DYng?=
 =?iso-8859-1?Q?T1YxdrqYY8qLXaR8AVk2HJJBZIXdjwwtYpZxpu4+hgEdeNC4Q3kUtISMW4?=
 =?iso-8859-1?Q?QjqZjIgHtcaJ/mxnO8XtOFtnb+90e8mw15jJxD4ClV1l08onLdWsIMPKw1?=
 =?iso-8859-1?Q?tV1pPaXjPuTNytoe5VKe+HlkRRjThkj+gkmt+51KQr/C1hunaZ7qcE3P/E?=
 =?iso-8859-1?Q?5xvBW176qIhtmM0a24QyfpqY6A+DTF3DIsoD6UsJMcvmCJ9B8SThmK+bWg?=
 =?iso-8859-1?Q?X70ARfP+KYBtO5SY9pY7ftEm0f0iUj6SIn4KJ04Pm0J6sp+0ENFvRlruYN?=
 =?iso-8859-1?Q?cey1vVP8Il4Jv67KTs4a+AAbOjtqgDOWdf+k4ydu32vSMwxQpz4PAnl1xL?=
 =?iso-8859-1?Q?vL0X+Q/S0lxP6nqmz1IrPDBpXRM0ync/FQMdG+F1iRSgVXhyo2Swo3OGs0?=
 =?iso-8859-1?Q?E1eMr/hYSu7aTDr3E40aDhLyqeOWb0xA1L?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 17773126-dec6-44b1-f30a-08dd98098469
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 01:48:00.2494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LTSAdkPYBKMMuxUlvhf9zGDK5hxguAB1SmmzGUvOel/JT7hLakm52grm9z1TsjRHCEOk14YFoURsmQsNaO+Gqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8466
X-OriginatorOrg: intel.com

On Tue, May 20, 2025 at 09:13:25AM -0700, Sean Christopherson wrote:
> On Tue, May 20, 2025, Yan Zhao wrote:
> > On Mon, May 19, 2025 at 10:06:22AM -0700, Sean Christopherson wrote:
> > > On Mon, May 19, 2025, Rick P Edgecombe wrote:
> > > > On Mon, 2025-05-19 at 06:33 -0700, Sean Christopherson wrote:
> > > > > Was this hit by a real VMM?  If so, why is a TDX VMM removing a memslot without
> > > > > kicking vCPUs out of KVM?
> > > > > 
> > > > > Regardless, I would prefer not to add a new RET_PF_* flag for this.  At a glance,
> > > > > KVM can simply drop and reacquire SRCU in the relevant paths.
> > > > 
> > > > During the initial debugging and kicking around stage, this is the first
> > > > direction we looked. But kvm_gmem_populate() doesn't have scru locked, so then
> > > > kvm_tdp_map_page() tries to unlock without it being held. (although that version
> > > > didn't check r == RET_PF_RETRY like you had). Yan had the following concerns and
> > > > came up with the version in this series, which we held review on for the list:
> > > 
> > > Ah, I missed the kvm_gmem_populate() => kvm_tdp_map_page() chain.
> > > 
> > > > > However, upon further consideration, I am reluctant to implement this fix for
> > > 
> > > Which fix?
> > > 
> > > > > the following reasons:
> > > > > - kvm_gmem_populate() already holds the kvm->slots_lock.
> > > > > - While retrying with srcu unlock and lock can workaround the
> > > > >   KVM_MEMSLOT_INVALID deadlock, it results in each kvm_vcpu_pre_fault_memory()
> > > > >   and tdx_handle_ept_violation() faulting with different memslot layouts.
> > > 
> > > This behavior has existed since pretty much the beginning of KVM time.  TDX is the
> > > oddball that doesn't re-enter the guest.  All other flavors re-enter the guest on
> > > RET_PF_RETRY, which means dropping and reacquiring SRCU.  Which is why I don't like
> > > RET_PF_RETRY_INVALID_SLOT; it's simply handling the case we know about.
> > > 
> > > Arguably, _TDX_ is buggy by not providing this behavior.
> > > 
> > > > I'm not sure why the second one is really a problem. For the first one I think
> > > > that path could just take the scru lock in the proper order with kvm-
> > > > >slots_lock?
> > > 
> > > Acquiring SRCU inside slots_lock should be fine.  The reserve order would be
> > > problematic, as KVM synchronizes SRCU while holding slots_lock.
> > > 
> > > That said, I don't love the idea of grabbing SRCU, because it's so obviously a
> > > hack.  What about something like this?
> > So you want to avoid acquiring SRCU in the kvm_gmem_populate() path?
> 
> Yes, ideally.  Acquiring SCRU wouldn't be the end of the world, but I don't love
> the idea of taking a lock just so that the lock can be conditionally dropped in
> a common flow.  It's not a deal breaker (I wouldn't be surprised if there's at
> least one path in KVM that acquires SRCU purely because of such behavior), but
> separating kvm_tdp_prefault_page() from kvm_tdp_map_page() 
> 
> > Generally I think it's good, except that it missed a kvm_mmu_reload() (please
> > refer to my comment below) and the kvm_vcpu_srcu_read_{un}lock() pair in
> > tdx_handle_ept_violation() path (So, Reinette reported it failed the TDX stress
> > tests at [1]).
> 
> > > @@ -4891,6 +4884,28 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
> > >  }
> > >  EXPORT_SYMBOL_GPL(kvm_tdp_map_page);
> > >  
> > > +int kvm_tdp_prefault_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level)
> > > +{
> > > +	int r;
> > > +
> > > +	/*
> > > +	 * Restrict to TDP page fault, since that's the only case where the MMU
> > > +	 * is indexed by GPA.
> > > +	 */
> > > +	if (vcpu->arch.mmu->page_fault != kvm_tdp_page_fault)
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	for (;;) {
> > > +		r = kvm_tdp_map_page(vcpu, gpa, error_code, level);
> > > +		if (r != -EAGAIN)
> > > +			break;
> > > +
> > > +		/* Comment goes here. */
> > > +		kvm_vcpu_srcu_read_unlock(vcpu);
> > > +		kvm_vcpu_srcu_read_lock(vcpu);
> > For the hang in the pre_fault_memory_test reported by Reinette [1], it's because
> > the memslot removal succeeds after releasing the SRCU, then the old root is
> > stale. So kvm_mmu_reload() is required here to prevent is_page_fault_stale()
> > from being always true.
> 
> That wouldn't suffice, KVM would also need to process KVM_REQ_MMU_FREE_OBSOLETE_ROOTS,
> otherwise kvm_mmu_reload() will do nothing.
In commit 20a6cff3b283 ("KVM: x86/mmu: Check and free obsolete roots in
kvm_mmu_reload()"), KVM_REQ_MMU_FREE_OBSOLETE_ROOTS is processed in
kvm_mmu_reload().


> Thinking about this scenario more, I don't mind punting this problem to userspace
> for KVM_PRE_FAULT_MEMORY because there's no existing behavior/ABI to uphold, and
> because the complexity vs. ABI tradeoffs are heavily weighted in favor of punting
> to userspace.  Whereas for KVM_RUN, KVM can't change existing behavior without
> breaking userspace, should provide consistent behavior regardless of VM type, and
> KVM needs the "complex" code irrespective of this particular scenario.
> 
> I especially like punting to userspace if KVM returns -EAGAIN, not -ENOENT,
> because then KVM is effectively providing the same overall behavior as KVM_RUN,
> just without slightly different roles and responsibilities between KVM and
> userspace.  And -ENOENT is also flat out wrong for the case where a memslot is
> being moved, but the new base+size still contains the to-be-faulted GPA.
> 
> I still don't like RET_PF_RETRY_INVALID_SLOT, because that bleeds gory MMU details
> into the rest of KVM, but KVM can simply return -EAGAIN if an invalid memslot is
> encountered during prefault (as identified by fault->prefetch).
>
> For TDX though, tdx_handle_ept_violation() needs to play nice with the scenario,
> i.e. punting to userspace is not a viable option.  But that path also has options
> that aren't available to prefaulting.  E.g. it could (and probably should) break
> early if a request is pending instead of special casing KVM_REQ_VM_DEAD, which
Hmm, for TDX, there's no request KVM_REQ_MMU_FREE_OBSOLETE_ROOTS for slot
removal. (see commit aa8d1f48d353 ("KVM: x86/mmu: Introduce a quirk to control
memslot zap behavior").

> would take care of the KVM_REQ_MMU_FREE_OBSOLETE_ROOTS scenario.  And as Rick
> called out, the zero-step mess really needs to be solved in a more robust fashion.
> 
> So this?
Looks good to me for non-TDX side.

For TDX, could we provide below fix based on your change?
For private fault, -EFAULT will be returned to userspace after the retry anyway
after the slot is completed removed, which is unlike non-private faults that go
to emulate path after retry.

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4602,6 +4602,11 @@ static int kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
                if (fault->prefetch)
                        return -EAGAIN;

+               if (fault->is_private) {
+                       kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+                       return -EFAULT;
+               }
+
                return RET_PF_RETRY;
        }


And would you mind if I included your patch in my next version? I can update the
related selftests as well.

Thanks
Yan

> ---
> From: Sean Christopherson <seanjc@google.com>
> Date: Tue, 20 May 2025 07:55:32 -0700
> Subject: [PATCH] KVM: x86/mmu: Return -EAGAIN if userspace deletes/moves
>  memslot during prefault
> 
> Return -EAGAIN if userspace attemps to delete or move a memslot while also
> prefaulting memory for that same memslot, i.e. force userspace to retry
> instead of trying to handle the scenario entirely within KVM.  Unlike
> KVM_RUN, which needs to handle the scenario entirely within KVM because
> userspace has come to depend on such behavior, KVM_PRE_FAULT_MEMORY can
> return -EAGAIN without breaking userspace as this scenario can't have ever
> worked (and there's no sane use case for prefaulting to a memslot that's
> being deleted/moved).
> 
> And also unlike KVM_RUN, the prefault path doesn't naturally gaurantee
> forward progress.  E.g. to handle such a scenario, KVM would need to drop
> and reacquire SRCU to break the deadlock between the memslot update
> (synchronizes SRCU) and the prefault (waits for the memslot update to
> complete).
> 
> However, dropping SRCU creates more problems, as completing the memslot
> update will bump the memslot generation, which in turn will invalidate the
> MMU root.  To handle that, prefaulting would need to handle pending
> KVM_REQ_MMU_FREE_OBSOLETE_ROOTS requests and do kvm_mmu_reload() prior to
> mapping each individual.
> 
> I.e. to fully handle this scenario, prefaulting would eventually need to
> look a lot like vcpu_enter_guest().  Given that there's no reasonable use
> case and practically zero risk of breaking userspace, punt the problem to
> userspace and avoid adding unnecessary complexity to the prefualt path.
> 
> Note, TDX's guest_memfd post-populate path is unaffected as slots_lock is
> held for the entire duration of populate(), i.e. any memslot modifications
> will be fully serialized against TDX's flavor of prefaulting.
> 
> Reported-by: Reinette Chatre <reinette.chatre@intel.com>
> Closes: https://lore.kernel.org/all/20250519023737.30360-1-yan.y.zhao@intel.com
> Debugged-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a284dce227a0..7ae56a3c7607 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4595,10 +4595,16 @@ static int kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
>  	/*
>  	 * Retry the page fault if the gfn hit a memslot that is being deleted
>  	 * or moved.  This ensures any existing SPTEs for the old memslot will
> -	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.
> +	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.  Punt the
> +	 * error to userspace if this is a prefault, as KVM's prefaulting ABI
> +	 * doesn't need provide the same forward progress guarantees as KVM_RUN.
>  	 */
> -	if (slot->flags & KVM_MEMSLOT_INVALID)
> +	if (slot->flags & KVM_MEMSLOT_INVALID) {
> +		if (fault->prefetch)
> +			return -EAGAIN;
> +
>  		return RET_PF_RETRY;
> +	}
>  
>  	if (slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT) {
>  		/*
> 
> base-commit: 45eb29140e68ffe8e93a5471006858a018480a45
> --

