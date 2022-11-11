Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B346624F3E
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 02:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiKKBMw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 20:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiKKBMv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 20:12:51 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824AE45ED0;
        Thu, 10 Nov 2022 17:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668129170; x=1699665170;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/+QDzBeNnWmPQN7csCHZ1dAfHHl59ruwbdjVJiQuCug=;
  b=EYf35gPo2+02/tyEgAZ0H+kGWgxPZjfSpNLF8pQ8PTEPOy96fYGaBhid
   tXCkF8L0m9Q0N6nXEXsPM82S9Bqx8WQpnUa1qCUVht97QYlvgSK5LzK2u
   n3i0siE6kucV6kO7h0M/cu5pqtYATgzNJuu6ylvmuY0mEWYWDa/dyelbr
   bwurYzehcVz6bQmbS7QGd8WEgtG0rS/vZfOHstVMARf1rPqP3SJ1ddvbL
   3cOlzJThppDEIbQH4aik/KLMqJ4x6Qld/FAgUMBI2UTLSt+mU8o1SlD3o
   ZH4ceZvqw739xQQzwb7eXeIQakozaLsTsDx52gsHw+cT3v5CxZOMdgBbJ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="311495086"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="311495086"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 17:12:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="726610906"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="726610906"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Nov 2022 17:12:49 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 17:12:48 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 17:12:48 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 17:12:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXVky63DbG8sawX5lAz4N45c48cgjxrMIbPkt/kq4B+sPd9ewu7L4iqwUeJmsAXxtkBUl4vhH0ICZgg1u78FVRREiA8C7GC7Y4VX2e9TqmHekIwa4xa2+wWaFh77KwhfTIoby+lbn11q7EEExueyl+nfKYNvERcfnkZhTOxXSRGBeUDxkuBvmh63fZHbYAyvJC/KisgPUdBZcAcZzpJxvRSq5KmfIaSK8KnFZ9M4pISPP4ma03/RDeRdDma4G+m7rWRjC6w4mN1ZemyXHDbfc47JRqD/RXTnwbv7k663sVqh2UoBAeFqqMvOjRmG62TV8RUkqW93J6hd164fvGM/uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L1PYha7bnKo2FPKldPbc8NvOgGSOr3hwWxrEwu9ZoJ8=;
 b=Pn1/nHpgG8eaChcMkIalSM+UoOTUmK8uYrk7WsQGspe37+T5rzbFM01Tl+DVf3zdmybTls0IoYegUrUxYZ0ls86nzUNxNTz0oOq7nNr2hxmpGrujB0DcBDOOmTVC6ztGMmgJB+MMaeF+Wu0hguDZooi5zBG6ccDp2byJaYxmgXnNF3oElvB7MCqGCOV1/imq79PRynerffNUNFIGGU1BmmfCU7FxK9j9GOrV81tq7IkgUR+GNFgoBA7hJBmiUB89ok8uXF+Ejm7pqcj3uRdfTdYKFJ2SUtmTIgXLOFvDdA4drvOynGz1rIbEgz/Fk0RwEOBSyECyutsRmr4UMFq6eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH8PR11MB7045.namprd11.prod.outlook.com (2603:10b6:510:217::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Fri, 11 Nov
 2022 01:12:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::737e:211a:bb53:4cd7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::737e:211a:bb53:4cd7%6]) with mapi id 15.20.5813.012; Fri, 11 Nov 2022
 01:12:44 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Li, Xin3" <xin3.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: RE: [RESEND PATCH 2/6] x86/traps: add a system interrupt table for
 system interrupt dispatch
Thread-Topic: [RESEND PATCH 2/6] x86/traps: add a system interrupt table for
 system interrupt dispatch
Thread-Index: AQHY9M8sal/Ms8IVqkWPKs+WGoQ50a432uWAgAC4OACAAFX+sA==
Date:   Fri, 11 Nov 2022 01:12:44 +0000
Message-ID: <BN9PR11MB52768BAEDEBCAE301383C5DE8C009@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-3-xin3.li@intel.com>
 <Y2y8obdYDXo9vlH/@hirez.programming.kicks-ass.net>
 <BN6PR1101MB21619E2092AFF048422C6311A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
In-Reply-To: <BN6PR1101MB21619E2092AFF048422C6311A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH8PR11MB7045:EE_
x-ms-office365-filtering-correlation-id: 0655f354-759e-4300-2b1a-08dac381d686
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l3XXa8MqmkF8IGNxMdqlhI7l049p2NJ3KOW4ZA3gpX01AI9nfYKQ2NTSINaYk75Lh5TDz0ejSBAI1b9YXcA+ZdxQhEAfVgIXPXyztr3gknDHdbmaOXrv2tBi5DDbm4/JJV7VN/XV37bSWjOk527pv0IOOFfAAYQJ6ynCwAvbznJShYhtPCP7pwig4rJ7HmZscXANnakWLdjo4bLRGYs2lG5TGWUZDLbe7c4kX+zLONpA3rW+xZ0SSnrPI+zVqWMSMO8zIw1PPEbs9SwngFL8b7P+pQ/LBgpbM1oooHAELG6AtAXC7Q5UvUxoNnAPw16uXn9o5m2hHazeo/hDuAoYWMZ8qk6R697pHRZHBa9f/CtMHgEUAf2gERbn4Iao1DtwzxDmstLEeASbhHKhuroAoDBHuL3Eo2HIlU52SHK8fNJEw4/GfvZNgFkksr6hrXLKMf0UdYBI0G6ODrR/8jEc/dO6E3RUbQJ/T+8PYKS9RET8ZCtEbipS1bK+qOiERUtEJkghdbfODeMooxz+EdhJO/3ht75ZQtRNpE+TiQEugZov9hWTWck9xznzMkMsnx7mllHoiqd49h/lcWF3euUuB6hiPCi0845hbjF1SNdvx7WEXrbO6Zejw3US8jMfkyefGUrfuaFjax0JQ2AqRe88yKj4s0tJHl5cKL+4rqNTndj2ijYdCjJpbeKKt8tUrKEhP5NgnpOWDPPY7Qcr2WGk0EKpOOPYS8QgJQA8A2XafHwuaTj3BQbW7CoiMmKPPzQ0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(39860400002)(396003)(376002)(136003)(451199015)(86362001)(38100700002)(33656002)(478600001)(122000001)(82960400001)(38070700005)(186003)(9686003)(2906002)(26005)(6506007)(7696005)(7416002)(8676002)(54906003)(66446008)(66946007)(52536014)(4744005)(5660300002)(71200400001)(8936002)(66476007)(110136005)(316002)(76116006)(4326008)(55016003)(41300700001)(64756008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VWlLwIDvqfacp6WdA4sjIJY2FXcYKbSepg5qqCLpJJqXv/PXYLOcUdpG1aSn?=
 =?us-ascii?Q?ojCR+QMG+QUleRi88r4qPB8pxsjct1wQp/0R9yzxSwyvLJoPcqiOp2RBQXmI?=
 =?us-ascii?Q?QSzvFd23RZIz0+vMaNOnbCJ/GCyn12Ij6z+88oRkaEc2q9Gqj/p/S5vkle8L?=
 =?us-ascii?Q?tvH0EtzjYbFjS8Jyj/5660qSJN68kq315sQM8j/0Z7TPFF1S9cs8QHGf40vK?=
 =?us-ascii?Q?dtICPrTnD0vR7FAC7wGNiYJIAAFYw4o7TOXFsxJBkE8tusmQM/Xldp1i8DH5?=
 =?us-ascii?Q?/nLPMg8G9gkgUc97szpTYb2Sq18/hL/0t0ZjjgliG7lBtKoS4d7GZ3UkDFo4?=
 =?us-ascii?Q?NecQmNOjUxgjuB/rUViJ3drTbcXH0vxckt03J2gJMm5UqCYvqfSLpezuJZnL?=
 =?us-ascii?Q?PHE8sYeW27jov8QUT3UjY7lGt+CoUap5BzPLfISugah90/dvIZkT6sq7xiXn?=
 =?us-ascii?Q?0SzyGUgW+lOsROD3WZbn3EI6YdWWFoI8ADedTkOw219OxKAGA4IVGmy+eAql?=
 =?us-ascii?Q?N9cRx1hfBYNFZf5o82lgSbrYojcjHgQl8oCGgUEjIhldcR7yOaKB2DMLXH+i?=
 =?us-ascii?Q?Jq7qpOctBVlc0vwwjmNclE9FFD6rWeYRYJUHnYg5NGNX7uY01kenHpG7wkd1?=
 =?us-ascii?Q?IUgKa6nRi8bM8hWI+sBDZbUxjatAbz/ZCeXSZtuHEaxMaf98sV44ypkqFtuG?=
 =?us-ascii?Q?Jpt2QGQKBOuB6BCF7pAudV+kAdeLiLS3iBJTlrnD9W/CTg/5Rs47oBs6xVrs?=
 =?us-ascii?Q?pMU6LRMJlz+YGJPk5PjZCYNtl8l8KALBk65zCydzI2vPC2IfWFHBCkNdTaTP?=
 =?us-ascii?Q?DQClEDA6Y//wCuwejbo4WyeETsFjrJDMgS4ha2kuZUS+/EmjgcEKfiYSvNSI?=
 =?us-ascii?Q?i71Rn3igua5s/Li44bMCmwSrlrVn1zy/kBABkWVO40TzdfglqtbKBxod5ANE?=
 =?us-ascii?Q?5+fFV7xMtMBu6JOQv8xoLvJNdOAxiKnwR2kWaRTbknRCorhcmxTbc2jPurJi?=
 =?us-ascii?Q?LLJ+XYm65LD/mIMY+5rfNMkGMi8C45KwrWJahjifNOee39xV+a4AF20kHAYK?=
 =?us-ascii?Q?UcplWIC3dGOzW9QiFxgcAClU1dNwOuhGJf8YZACrYhs09o2alyOYswzDGGoo?=
 =?us-ascii?Q?bjHEilWMijKrTjJ7Gk9K/LrKS6GIPmUOjaP+K5Y5M0xbbWwIWDBsyxaq8L6F?=
 =?us-ascii?Q?NhNJ4dTPTLcfviUL4UeaZVAh6HVrnkb5IovE7WxwoiEr+m4GSWTPvAUu3rGf?=
 =?us-ascii?Q?B0Kh3bSlvXt7fsNbfeGNb7z4PP7orcPuSNa+J9bGDHK8zHhsAEiKBVTIpbhb?=
 =?us-ascii?Q?voovHEf/XcinLPITTXzY8uKF3hU6zzhgx7qe1u5B1si9qH1JNgGGDPWZC2Vv?=
 =?us-ascii?Q?NdNyZV59Xit24KYI9wHzaMiSxzu4AbZGcZ7KeBzhoRhh4qpOc3xpYKoopiwI?=
 =?us-ascii?Q?xKQSZuAhQWG+hgqhwqYyYv0J0v7onfFXpXClNWQ43yUPc7Fo53J+zqXyq1jb?=
 =?us-ascii?Q?GldG5f1yxrHy5ftgA2Bdl6p069CZ2PX6gHBDADALimXJYqd0qCVcT0zij2To?=
 =?us-ascii?Q?X9UPSQBHHFz/ekZvzy55MEWRJUCcBxQrzC0GQkic?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0655f354-759e-4300-2b1a-08dac381d686
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 01:12:44.3192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lyStL8Xq+MC6TN43nsXTZ+mId5RciOgnQSLPj4mpUtPdtqvZEdlB4WLOrXwJphwZetI2TyJsrw9SavW8feNd1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7045
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Li, Xin3 <xin3.li@intel.com>
> Sent: Friday, November 11, 2022 3:55 AM
>=20
> > > Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> > > Signed-off-by: Xin Li <xin3.li@intel.com>
> >
> > This is not a valid SOB, it would suggest hpa is the author, but he's n=
ot in in
> > From.
>=20
> HPA wrote the initial dispatch code for FRED, and I worked with him to
> refactor it for KVM/VMX NMI/IRQ dispatch.  So use SOB from both.  No?
>=20

If main work was done by HPA while your work is trivial:

  From: H. Peter Anvin (Intel) <hpa@zytor.com>

  commit msg

  Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
  Signed-off-by: Xin Li <xin3.li@intel.com>

if your contribution is non-trivial:

  From: H. Peter Anvin (Intel) <hpa@zytor.com>

  commit msg

  Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
  Co-developed-by: Xin Li <xin3.li@intel.com>
  Signed-off-by: Xin Li <xin3.li@intel.com>

It's documented in Documentation/process/submitting-patches.rst
 =20
