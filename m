Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C224B1CCF
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 04:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344597AbiBKDHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 22:07:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347540AbiBKDHJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 22:07:09 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB3155A2
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 19:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644548830; x=1676084830;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dMGRQHN8neVq+McEg4hHnVer0FfSxq7yTPf+QpgqyTo=;
  b=mNtmgx1L3PZG/Fcc6wu4kYA1+kOSjYts1lKS68i7bwfw6qnejDlYjQ8n
   19cW4HabUrbolwOYl3NOfeF1h8EqFoCk9FZ9IPziK+Ri367VoealGEom5
   yklc9vo9on44yCeGTk1gC4LwNZtO7v7osGl1xBnerrv4aRcH2b/s/dBv1
   ZTd0SHFP8BJP/NgzgLMYiQe8TxR0caoQhGLQkilBnYQP5FN+V6eKAGfj6
   YgvIxqFLlV2ojQzD5cGMieUADvnSWWrz+wUsZ9OEyW7NGu/qdLhzDzToO
   yLrOC4VPQ7d5NdcnupTTYlWQEkCUl+/c/Eae5kmDMgFJy3Sfwf6iMbGDv
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="233203279"
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="233203279"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 19:07:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="771948815"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 10 Feb 2022 19:07:09 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 10 Feb 2022 19:07:08 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 10 Feb 2022 19:07:08 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 10 Feb 2022 19:07:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zka71WNkgsAs38HFMaYMtm0a4oN9gEpOrl31KKLojgliOctOvkEBjYN/kfTxBDZ0LgjTiw8sqltdEiIM4zzjOSS892UFkpOEtZI7c3NQFBal/vn+3wuQpNbDZHkhYWRIk67ipQt+26PGKeo7XEa0f0Nk86mD6bEIJzIQINVkICl0gGV+YeKsoOxuPY4P/nPBhCZHbaxQG+G0l0oZ0O3KBoFq+TsLzoBgZ6fZVtUP0fYp7s1OQU/SwHAAqYh5eqGiCuw+pTi6IdV5mM1Q2FX4He2UHryMb6VMLw4bm1JF/fuxjBA9HzX0YKHiNFSXJMQHkTeAUDW7gf6UAPf/KZD+hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zFuoecrmP6dBX7jfkUMpZgnKF6JOpjpr2LxO9ozqYvQ=;
 b=aA9ZFmRCaXckLQyRmFvY6NerS3eakgX/0/5wWUOuKui7wJHVaEl9aVa3cbRQ+mznhwRZ9SSzCueoP3yBYGFSVDa8H5GVut//qlUGFfcMJyDsGRm3JhitgsfDWkV6uMmE7gtXZQ3OFTZpCoidK3awShGiIjhbZgz/d3z/ks2m19GOjRmiSYsALM2qpQPO0T6b3+5g/Jj+Grpk2UUXJZdEp2WRCLYbMI6Tf92E9PSDceYtWoLcuHOA2UcWTy8HfYl0JIJK5WoaC1j1/QxZIM/6xdBFxfAQocfL32peXcAuJdNTXGkfeRUWh5cAxwJ1bc51bfGtuZtlMjqYjQA4P+JFVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from CY4PR11MB0005.namprd11.prod.outlook.com (2603:10b6:910:7a::25)
 by PH0PR11MB4918.namprd11.prod.outlook.com (2603:10b6:510:31::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Fri, 11 Feb
 2022 03:07:07 +0000
Received: from CY4PR11MB0005.namprd11.prod.outlook.com
 ([fe80::953b:3766:389c:c0ed]) by CY4PR11MB0005.namprd11.prod.outlook.com
 ([fe80::953b:3766:389c:c0ed%6]) with mapi id 15.20.4951.019; Fri, 11 Feb 2022
 03:07:07 +0000
From:   "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: RE: [PATCH] x86 UEFI: Fix broken build for UEFI
Thread-Topic: [PATCH] x86 UEFI: Fix broken build for UEFI
Thread-Index: AQHYHpubnaQjXH7CF0WnD9PxJ5PSxayNp4xg
Date:   Fri, 11 Feb 2022 03:07:07 +0000
Message-ID: <CY4PR11MB00057BD9BF249FE147C2203A92309@CY4PR11MB0005.namprd11.prod.outlook.com>
References: <20220210092044.18808-1-zhenzhong.duan@intel.com>
 <YgU9tBiSdF1u1+c7@google.com>
In-Reply-To: <YgU9tBiSdF1u1+c7@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.200.16
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af9e921c-a268-4d35-3e90-08d9ed0b966d
x-ms-traffictypediagnostic: PH0PR11MB4918:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <PH0PR11MB4918028FE2AE9E16F6BA296E92309@PH0PR11MB4918.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H70OHpPds/rezWRNwsrOlXMVlSyTvVogdC+PpIc1S6DiRoDpGJrLGWudSGG4/SyyE60EcJHhy8lDBdFLu/j7AT4kgKrQT+CaHaXXr3HzBkZlKBm4JLe94NJCLKijq6zm6XSYaj/HKJ2w5zSIN4+5cuveRPVzi61xUUNCuYtM9QLmvKDrAjqi1I/HnVc6y5Pj3f9oPWDbLGrIo32k9mo4lq03EcDrrW0l7PxhyyI4GeNqfZNAdiOmXwxJeK8hq2jgZ1oKw8nkR9duix53y0bCDJ5RRfvSZESzMUTEDlca3QIu8OaYwuoGPx6MuzLLfgYApcLWzJZPSJcbzn4DGCB8d90kkzsQDQOQpYXficSBO5meft2va8Oo30mez5yZL3gM0qeJU6wPDcXlFPJ64Bb5KZ5yIsI/VtCdcUCHWD021aHuS2lcWmULSOxUyxfGVp5ighq4645AD22VSI3lf2DeLFSMaBR3camOC8Lcm6HYIiRJ3CJ71Fh6DTfnIlq0U6xGFSQxys77eVsDBRCPgbGOv1M6XTdKE0o720grSPR5CDOozCgdvBZGEDt7hJj3n8DP1F106iAKPWPTjDMODpHwd6W01c97FAKa9QcgsXV/PJrIrdXO7xe/GWgbMD4lujLvprAxySW1aHNidTaazAPNkEUloTBxXco2OVu9f9YIqG+6JB9+4nUH3KH4ajFWJ4PVRADRoXdqq5Q9QBnj44Va3xYtCAms9/lJJFPUNa732PU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB0005.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(33656002)(55016003)(8676002)(83380400001)(8936002)(122000001)(38070700005)(38100700002)(86362001)(5660300002)(4326008)(82960400001)(508600001)(66476007)(64756008)(66446008)(54906003)(186003)(52536014)(316002)(66946007)(6916009)(71200400001)(66556008)(76116006)(6506007)(26005)(7696005)(9686003)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?55t2Z5ajUJ3IBObTMIl6pJk2VDCdDg3YSeM4AgOnJ7KndTafzvVad74gdOI3?=
 =?us-ascii?Q?cWeL3ICfuOtBWhUjUk17FTVDlxektUpOKxEQziURb1btlNqMguQJzh3TX4dL?=
 =?us-ascii?Q?9AmnlCq1BMdRfqfzwifiC0Ety86pony6MA+6QpDylEhuAscPSHsYAM9lIleH?=
 =?us-ascii?Q?3dVMmiCu+t4nkOvSsben+Grf2z7HBqCzndDSDRm0h7r/sfN4bt1Aik3bSStF?=
 =?us-ascii?Q?voHYtM7jubibJ91VAa/IT/WrLOJr4i6rmeZB4szy6GTfl1ce712JE6p+pl57?=
 =?us-ascii?Q?+uvvIjoThO0cyXwNQW/tw3cBinRR/m+lE0EolMumJBJlphaD9KrJVf6ajoEe?=
 =?us-ascii?Q?ORAM5rpofSlDX/r3KWt/7UI/w/k+h753bgXN2BzWg0hUmFw0CnCbOW58AGIN?=
 =?us-ascii?Q?OkldZ80GDJe3I2rMfG6Ak5IU7q0/agfbfPxXNgZVOUvtfdtyXehtD9up5Ccj?=
 =?us-ascii?Q?M89gDrdu2QalwTvIBc9bt+49MZgZq4IeVP6eU7eUm4M63t46oeFGI2tY3r0r?=
 =?us-ascii?Q?E8mhBXn84AChHocphivQo/9Vg/IZhL9Ed8rb6Y3JUZUMUWAPxMZuJLjUQaAu?=
 =?us-ascii?Q?dXFJ0HCBYoYy0nkxQaVH419L2NqXIGG0Gqp6D+KfqDUCdepHENjxgEZa7cJT?=
 =?us-ascii?Q?cLsD8GnJDr+xcBt1P3IP5ekTSPu13jjRveBmvOR9FsleZ5b0jVIlmFhSQqsr?=
 =?us-ascii?Q?ULSIeqNFUhuXxNCfnQ5+kRMgkAw/KPuJ75U0OoKXmjKKuLag6xlFwY47g2Za?=
 =?us-ascii?Q?F7hNVN3xHakHmY2H364uy0gNadzUK7zP9qtPVMx3TuFEGfvmcjMlcUH4HXSQ?=
 =?us-ascii?Q?iyygwrmBWCgzrF8/YG0ukYB0RXSGLrn/q3hmxLjNGlgXVaV57WXkTx2Xo1/P?=
 =?us-ascii?Q?wK+VtLxy7QI41TQI1pwbRugiJNT7/Qo1XkXEvuO2QIfeRtbwQ6IwENZjuntd?=
 =?us-ascii?Q?hj2UceZ7tXf5sIs0e+JQ4ZR31ytcsgmf6NefDf/Sl8R40Z2jKmOsfc8mrzDq?=
 =?us-ascii?Q?Ju2pYeS5IRoaMBnguw2SpI2p0Guy3N1fKEsLdY2uzhH3cYK0GcIva1xLuBN0?=
 =?us-ascii?Q?Y6kheedcY+L2+yzD+XLM7irQ6rw0nsakZU1U8YsBeU7ojs/zDZS+xZ90KXRP?=
 =?us-ascii?Q?DcKeTbNZVvsorX2PI4bO56jHQJR3GllkBMj6HUVTZecXsWZI8kVx39sQ9vGh?=
 =?us-ascii?Q?D3VnwWnae8gJxnIuEmpc4I9qOSmHzGoc1EcFEBT5erMWjkLbdzSDoMQIRrgo?=
 =?us-ascii?Q?/AzwOlD0uBU2Ik3eL30fW73sSqaU/2GQeGvU5fknTSoSJbwNyHAIrIp/Hrfx?=
 =?us-ascii?Q?A3PzzvIm+hneXKC2QRS5PZQi5Nja1f6ejYeEB36/w+Q20kO1VTNpUae7xHLh?=
 =?us-ascii?Q?q5ngGYk+NTEdh2Y1O+8GKir8rPR+K9stkMwI7spDTQWXMqO/nZLCd+WuraSN?=
 =?us-ascii?Q?dq08wddcz3F2YORk3yIGfyeBiE/gF35zWSxdz7W0TpEjYMgNm5iilvRRYVQF?=
 =?us-ascii?Q?ujlK/Hllrq4mgotAO4E9jdYoLqJH/5F/zLK1tOMN/cYdd7Zi8DjgF3p5PSHb?=
 =?us-ascii?Q?Zpq6DV1W9/+o1zi4RxwvFHKo7/QP7XlPUb12bS7M4O3veohXx2sbrnWfK1n4?=
 =?us-ascii?Q?kQUui9nhBKPJyEgpfvt9l9jpHl7AVYcvksyA0yVHStKPwvWhXymFoOipzF6V?=
 =?us-ascii?Q?MpWoog=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB0005.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af9e921c-a268-4d35-3e90-08d9ed0b966d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2022 03:07:07.2550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kfn5gMOzGn6FuuLyZCG7cj16DZRChW3MRaVAcTh+QLuj0JN/NCbgAu7dR+7wPfyMTu2HPv1+IryecP0xPXKQzJxDhJtFc1w7UNU+n+uLnCM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4918
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



>-----Original Message-----
>From: Sean Christopherson <seanjc@google.com>
>Sent: Friday, February 11, 2022 12:31 AM
>To: Duan, Zhenzhong <zhenzhong.duan@intel.com>
>Cc: kvm@vger.kernel.org; pbonzini@redhat.com
>Subject: Re: [PATCH] x86 UEFI: Fix broken build for UEFI
>
>On Thu, Feb 10, 2022, Zhenzhong Duan wrote:
>> UEFI loads EFI applications to dynamic runtime addresses, so it
>> requires all applications to be compiled as PIC (position independent co=
de).
>>
>> The new introduced single-step #DB tests series bring some compile
>> time absolute address, fixed it with RIP relative address.
>>
>> Fixes: 9734b4236294 ("x86/debug: Add framework for single-step #DB
>> tests")
>> Fixes: 6bfb9572ec04 ("x86/debug: Test IN instead of RDMSR for
>> single-step #DB emulation test")
>> Fixes: bc0dd8bdc627 ("x86/debug: Add single-step #DB + STI/MOVSS
>> blocking tests")
>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
>> ---
>
>Hrm.  It would be nice if we could enabled -fPIC by default for tests that
>support it, having to compile twice is going to be annoying...

Agree it's annoying, but enable -fPIC for non-UEFI build may not help find
this build error, because the error happen in link stage to generate xxx.so=
,
while non-UEFI build will not generate xxx.so.

Thanks
Zhenzhong
