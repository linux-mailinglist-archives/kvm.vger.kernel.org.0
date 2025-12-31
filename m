Return-Path: <kvm+bounces-66896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D4FACEB07F
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 03:18:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1C7C23026A97
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 02:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A991222599;
	Wed, 31 Dec 2025 02:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ll1IgKaI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BD24A23;
	Wed, 31 Dec 2025 02:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767147493; cv=fail; b=DOFwbLlGb/LNU6uD4Yjf5L9oYd+p4+bMx/WZMBYGEwa1gqhcdJSfYqAjZOFHoIVm7ZvVMSW+pUnebAa3c/D0Vgg7xvehlVRBGlvX9PWqU96Y1zIBmG6ewsg0/nEUHgq0XONVBeT6ohpipi308uTsjzm2CRY7hOLBshHs0PeH2HU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767147493; c=relaxed/simple;
	bh=DruChoFMVVMf2en0T/mKpYIXU44pVtMdl+qiwvCTobQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GxVseDg9z+7fUaYpxlgrpQzrkeEQOi+36PijglUD9K/rvU0wWAWsfLlzsaydyx7ig+I8oi53OHjV7IDFT5DUWdcjnS6u5RmtACdybCdCXoajz5qua2Lf8LTtchXB9uB4Eb08ADHmIBLwNsMDvrcPb1N2iQMhfG5W/kZ9Xz7tCF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ll1IgKaI; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767147491; x=1798683491;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DruChoFMVVMf2en0T/mKpYIXU44pVtMdl+qiwvCTobQ=;
  b=Ll1IgKaIk50bjFdwStWtxKArrTguoduo57m0pqtcLXZQ4L+zV7WoVaIP
   PgdLxOf9CBJEQMXXVOR3Bhdth7f+DSLObU5lilt4kwnXGk5kdQBvtNAmt
   6KsmoTH08jbH1rQG09Z8WaUHLMPi4d7NX04q6vafSXBPXcjgBJMudqpzK
   XDp+zBiRtQh7MDU1RiNaD6Cbt9jQRTvqn3mTklFGJq0/nP0ZZFs0YAFWM
   sluM4yRgXCzKNv4GPMWW4zt9Mn8mmgrXQLkb9w56KVEUHtCF448kEqrfG
   D4XNNaI6yfrh3VNxdhMwgd1h3BKgVANJUZuXnIkruBjlVI/upIWNvj95V
   g==;
X-CSE-ConnectionGUID: pvsdBKTXTsOjk9/sSFwkVQ==
X-CSE-MsgGUID: 5cVj2t0SRDiC1j8PW84E+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11657"; a="68481125"
X-IronPort-AV: E=Sophos;i="6.21,190,1763452800"; 
   d="scan'208";a="68481125"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2025 18:18:11 -0800
X-CSE-ConnectionGUID: iGf82D87Q96QIIqB7s9INQ==
X-CSE-MsgGUID: H10mis5XSJaQ5zmAiJGnUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,190,1763452800"; 
   d="scan'208";a="206391074"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2025 18:18:11 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 30 Dec 2025 18:18:09 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 30 Dec 2025 18:18:09 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.47) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 30 Dec 2025 18:18:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AaHyX5Da3AlaxQ54fW4694gGrJWDsWj+FMdmQYGL8+jbZ5ke6yjabQ0jFz4Xrw47zIJUALor4cQ6GehS0sI/Ne9sew3cxIVNHXCxVG7CLL738CquxYuY2ktRA9Aqj1rPPn2/YCRCUCiMX75Z8302e92AdnuH3pMsLlou+BZBq4TpQrM0okiV3inQvZH9RATw1rKD6h9Uu7ZH7gl1Hae/nGsJ+jBSu8uL2ah3S9be3l6+lNf+DXWtYOEzrfl3cJ6/RiaKqb6HOp7YI/gfWC12pPLMT9mMVegseRGS7G4A2/isGvgr3hISue/JHqtGe6BRJa/2E4El3BT46ZpwY6K4Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KmjN7ShsGKwsFfPDNygXu4SZyXWTujYMaIRmGGDca2U=;
 b=tDbyMH+7OopA30OtDVGKKI/1FxbEmzMcsy6DAEiIOyDcUYZR9v9YdaOxnZheFcAcgjdFPzq6ZAXJC7SVESqIClhO//cO2oQ6YDAJvzACnRnWfIiSjK+gcZLvXG3D+2+G3YqVmQaW533nAQJSlTZv+6283npQxButsHKeVKh4GeQW5hwGg2/5jMVL4Ijeehjsx4nUOuD6ydPOuGJ9baGzcMMq+r9WDnRVo3dFGpMN7thD8E2r2GHvp9D9KFCEeRYeR8Thb4lGuvxq16NYw+gDopjaFMBKKSlMvQ7scB1xKMjtT7I59sHBnOQjnniGRQiEDx6mr313vBdV023z5co8XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW4PR11MB6788.namprd11.prod.outlook.com (2603:10b6:303:208::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Wed, 31 Dec
 2025 02:18:01 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9478.004; Wed, 31 Dec 2025
 02:18:01 +0000
Date: Wed, 31 Dec 2025 10:17:52 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Dongli Zhang <dongli.zhang@oracle.com>
Subject: Re: [PATCH v3 06/10] KVM: nVMX: Switch to vmcs01 to update SVI
 on-demand if L2 is active
Message-ID: <aVSH0GhLKqPcwPA5@intel.com>
References: <20251205231913.441872-1-seanjc@google.com>
 <20251205231913.441872-7-seanjc@google.com>
 <aUz2J/cK2PN/n0of@intel.com>
 <aVQ-MNmUa1fb83zH@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aVQ-MNmUa1fb83zH@google.com>
X-ClientProxiedBy: KUZPR03CA0010.apcprd03.prod.outlook.com
 (2603:1096:d10:2a::12) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW4PR11MB6788:EE_
X-MS-Office365-Filtering-Correlation-Id: 295f0845-7901-46bf-992b-08de4812d255
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?GzV4y4VcH8IoRuvlrl4EFg6k3hu96ofb5X6B0v5lTlrNopv38C8hZFWxqaFJ?=
 =?us-ascii?Q?qscESzgF95Q3sPc6MnMS3/1qS3G8Kv7wHFGB8hnV94of2Bo6i0jB2MWPxh8F?=
 =?us-ascii?Q?wNGL9FVmLY9MgvZZ+7VHWfDouNSLD+IGZd3dfzvWjVdFLqCimZyoK6rkPq+W?=
 =?us-ascii?Q?XiL+a8gptdXCm2jlK8QAZqsejhv2/mKWAbrx5f4Wlcr75JFLbk/o/zl3dnsB?=
 =?us-ascii?Q?hIVhxhdif4cH27WApodIE/dg9E4yGifD8TGskWDgTjc5l3SHIOpNJJaWC3ys?=
 =?us-ascii?Q?JlF67IGJWw+3TUN8jD9xbt5AogGr1ncTl1gGhqbHRO02xeWvP4iEXKqLdurK?=
 =?us-ascii?Q?VzJNT4+V+woLkHO6b6nBG7EtNlfGr5j18xsgdRNs8MTD6NnXcbrBgUn5B9gs?=
 =?us-ascii?Q?LNCumgWn03eecSbPKVfeBYrCQe9s/tpynYmLeBbxzuj/fZbvTNremp/4av+C?=
 =?us-ascii?Q?YZM315plRpjalckaUfAMwJaJ+2hjPU4W5joA1YsWda6rWsPHwthfps/S3Q4M?=
 =?us-ascii?Q?3W5mJ5HC91hxOT66BND5HI2hvrX81o1/LUlLPjnUtDpqrHNtbgVtMAboDiFg?=
 =?us-ascii?Q?n3CmnXm0YNOMu5T7djjh4S3ZKJ0ofBHikh1zYtPrRPLVss4d0PHVnXTOWlGs?=
 =?us-ascii?Q?NEYSNwg1oP/zFp214AoZH/QVa6J5cXIAPDOJcYpu7biFo0nf7mUbcfrhRz5J?=
 =?us-ascii?Q?lKu/dR7A1WIefgsg5iDaMq/7pKdMN554qp8hdtj8cKAgmPz+7pZM3WcYJIJG?=
 =?us-ascii?Q?PrUMM1gLhMjqODximhE4/wyT5xqDJuPQ1+YVSCTXFPcsTRoG0Klhw+mOLgjO?=
 =?us-ascii?Q?LVlU9+sFveocPmtS5X6Xz16eBNVRImy/9iPjqlw7/5YvF4zJJTnwpyQiO75a?=
 =?us-ascii?Q?Q4sOXNIXmpqJfcPe+hI08n4/cDLfBypop/oON5l4TLaJUkj9IZZOGTxpSbw6?=
 =?us-ascii?Q?gnENJ+c9em1WQIiXgixQF4bC6gXao/tgov4CC/ynHPBFM5yc0BCOqGpC1MkL?=
 =?us-ascii?Q?wSXy4TULjVsR1mLqLqqBTr3XHWkjQUKCM3m97S4l2C9zqGUWnu6gU2e/LT3W?=
 =?us-ascii?Q?KVu+9FoOJwZobLTHJOiG7sxeoo1annbjG1AYTJewFhjHtGzdCFxhv51GdHcc?=
 =?us-ascii?Q?/wgwYBCx+sFzvJUIamEiHHu6wifT6eiHDVBa2FqPtNdjwJ5a9plM/VHJx9zt?=
 =?us-ascii?Q?ZTEISs8RhHXQvQqTCTbxzA/qY88xPjF98MT9NldGHJHd6IwwkRaYykqL5xpH?=
 =?us-ascii?Q?MZbVPfgbhQZjSFoT67LhS7Le1Q24DMnQOozCayTHyuX/ApuhPoLCSXBoepg0?=
 =?us-ascii?Q?JkMkrMv0w81O0SXmetm/hchyrhHiNrsHNiPnFo4wcqB194f84B1pbNJdF4OZ?=
 =?us-ascii?Q?02gG/yntSS7jQBFvrrj3C8z8riTmwtODozxFDslB5BjXqwEZbw1pKEE/tYdy?=
 =?us-ascii?Q?ZojTHHiYiTrAMZGOUSBVm6t3JvGdXKCR?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5RXJktXe7PM7qwGVlDuhlYNmdORXtIWADd8RQpSrbljIGMYExN7ImMIoz7j+?=
 =?us-ascii?Q?RtecBUvxXb5As3j7M1oDQbhbwqg2vSbx4E7LOqBuktPToiYYuyTXNvykCG5+?=
 =?us-ascii?Q?htJ+wLPVSt0Ux8b2uE502mTmTQQNqGKfvfeuHRhEhm9GXwPjgLTSFPDslhXt?=
 =?us-ascii?Q?ox/RuJXm6JlVxA6PHX7NQPPjNgyKNK4eXWoYr/yunkN1H1ALGrzWetxaOs52?=
 =?us-ascii?Q?fYBe4JHvxs1Kx+9XKnXC9UfflB1BoAw1rt0QhUF9lnCQ0lj87UW66Ouo3UNo?=
 =?us-ascii?Q?IIBUN/bnlg5hE9e5UDTDiyUVJnsaM7g0nUvcKeSsjaWF+GFgt8LQDQlVxAcO?=
 =?us-ascii?Q?tC8Rh13mGwbS75mFCblqKq8L0P65K2c7bAZgNse/S3dqpDbYCLxJHygQvF3p?=
 =?us-ascii?Q?3xHEIh5b8i2+RBCTnah6XlhovGzOCqBduH1Cds6DJ5Le5rRoXv2SReMDF8pJ?=
 =?us-ascii?Q?K8PWU9CH4GBtGIl8blAqKNeG0ZGnPdBSk46QaQrpDUk8qqB7dGAxZ3APXRP0?=
 =?us-ascii?Q?6NaDN2+Y2w78Ay49grlm84z5/i4K6vhTKcDqh6KXf0c59cW2APAjL/rX+SQl?=
 =?us-ascii?Q?ne0E1mtVHLukBc4ruFY0P4rL+WRDqyhGKEmNnxMIwidV7Gf/0exr4VmuLOMl?=
 =?us-ascii?Q?y4QHyJRZxfPpNwoNAGmHx0+f44wy5UMlr9BZEhLfBJ/kIu2fAVnMQngydgLq?=
 =?us-ascii?Q?MXzfnOl1GY+QrWrk9PyVFhUXUbn1eGTfJpBXfkEUah69z7VJAwNP/jgcOR60?=
 =?us-ascii?Q?gIDAoFxcb5VZ2GsVOfiJfB3UC4sUlYVAwo/F47ezvox1qMhk6SNt9fAWICl4?=
 =?us-ascii?Q?dBMerSC6O149FnORGjtyC10JYsBTopyIXv4OmxhMHZ6FpbRCj0a6MUx715xS?=
 =?us-ascii?Q?v/aIPQ5hzLUGCoT5lrpReYJWn6x3M09hmRqzYKnczLBYHiARiUb9Vg36VOtV?=
 =?us-ascii?Q?G7u+ui6mPyJcAjrH3oCSc9Mh6/5YSXxiK6FED0RYMfsB2GUIRn+qdhqvh6O5?=
 =?us-ascii?Q?LkNrC50m4uxVbM3sTAMcCHpf+aAGe4JmlDfjqF0CEZFyeC0M0so/V53BU/EZ?=
 =?us-ascii?Q?MxbV2ptr6jw+16OXDorwhvH6D+z2nyBl0LsrYfo5YosU7uoosc3nyF3Ah4Gq?=
 =?us-ascii?Q?GyGogO3hVRUx0MXfdfxXg8Q2o+/WNJROYcilnqWmPWnAk7tNa9Nk3UNiO+bQ?=
 =?us-ascii?Q?BKdlq23tU6bjjOSyRrwsnEpggM1Std/fd/THrRC90NjX/kPcyik9WvOZhe7y?=
 =?us-ascii?Q?2daWlgB9+z/HnFqEmveWOLKzQg30f0ULF0OF2y/aby1Wp3M87Vob70lLLjoN?=
 =?us-ascii?Q?e5249kzw5ZwJakvoN0aCP6MTbEEYEbNlZGEOapzDoC8e3GnbBTpA+JOuULF6?=
 =?us-ascii?Q?ToBIGLipT5MZy2tLtmlTDGQ5FU6fVa5wS6vVOgQf0OciplTSP+cC9zhcqYzH?=
 =?us-ascii?Q?+I7ryZOiyIYrVGBa3nrmRHP4Pdo3OjKqKOWwoGa88Z+1Q29dx6V5/1lzt5/m?=
 =?us-ascii?Q?Jn6y+TBIow7ZwChgy2Sio0dNy9c55A5x4Z53q8doI15XzI5bTqSDXuW1vCF5?=
 =?us-ascii?Q?907XyJnm/A3jAyDIUkTMXADfhbC+fZXcVLMi1X51e+NAiUuMrpUF7W3TmiMO?=
 =?us-ascii?Q?6cyPlLFQDav5Ou0wxs6lplUFre1fBp09O6Oxk1wiGsHzJNJoa0mKF/vChPEX?=
 =?us-ascii?Q?kcAPxgO8o71V9cvNUimGAluCm8j1/s0xLpMGrFKVZrI6YihsJlqVsRjmPpWV?=
 =?us-ascii?Q?Bm4Xq8U9RA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 295f0845-7901-46bf-992b-08de4812d255
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2025 02:18:00.9530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +m7mPURyFZQ355Xkmc3G8K69TptHxmefw4DZI46WPGB2KnM+VDpwTHOgR3DSxCloMQ8mZOP0tz670q49l7S51g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6788
X-OriginatorOrg: intel.com

>> But I'm wondering whether KVM should update SVI on every VM-entry instead of
>> doing it on-demand (i.e., when vISR gets changed). We've encountered two
>> SVI-related bugs [1][2] that were difficult to debug. Preventing these issues
>> entirely seems worthwhile, and the overhead of always updating SVI during
>> VM-entry should be minimal since KVM already updates RVI (RVI and SVI are in
>> the the same VMCS field) in vmx_sync_irr_to_pir() when APICv is enabled.
>
>Hmm.  At first glance, I _really_ like this idea, but I'm leaning fairly strongly
>towards keeping .hwapic_isr_update().
>
>While small (~28 cycles on EMR), the runtime cost isn't zero, and it affects the
>fastpath.  And number of useful updates is comically small.  E.g. without a nested
>VM, AFAICT they basically never happen post-boot.  Even when running nested VMs,
>the number of useful update when running L1 hovers around ~0.001%.
>
>More importantly, KVM will carry most of the complexity related to vISR updates
>regardless of how KVM handles SVI because of the ISR caching for non-APICv
>systems.  So while I acknowledge that we've had some nasty bugs and 100% agree
>that squashing them entirely is _very_ enticing, I think those bugs were due to
>what were effectively two systemic flaws in KVM: (1) not aligning SVI with KVM's
>ISR caching code, and (2) the whole "defer updates to nested VM-Exit" mess.
>
>At the end of this series, both (1) and (2) are "solved".
 
Fair enough. Thanks for this explanation.

> Huh.  And now that I
>look at (1) again, the last patch is wrong (benignly wrong, but still wrong).
>The changelog says this:
>
>  First, it adds a call during kvm_lapic_reset(), but that's a glorified nop as
>  the ISR has already been zeroed.
>
>but that's simply not true.  There's already a call in kvm_lapic_reset().  So
>that patch can be amended with:

Yeah, the fix looks good to me.

>
>diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>index 7be4d759884c..55a7a2be3a2e 100644
>--- a/arch/x86/kvm/lapic.c
>+++ b/arch/x86/kvm/lapic.c
>@@ -2907,10 +2907,8 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
> 
>        vcpu->arch.pv_eoi.msr_val = 0;
>        apic_update_ppr(apic);
>-       if (apic->apicv_active) {
>+       if (apic->apicv_active)
>                kvm_x86_call(apicv_post_state_restore)(vcpu);
>-               kvm_x86_call(hwapic_isr_update)(vcpu, -1);
>-       }
> 
>        vcpu->arch.apic_arb_prio = 0;
>        vcpu->arch.apic_attention = 0;
>

