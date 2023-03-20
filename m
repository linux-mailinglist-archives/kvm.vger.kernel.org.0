Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202BA6C1ED0
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 19:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjCTSAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 14:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbjCTSAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 14:00:08 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE689423D;
        Mon, 20 Mar 2023 10:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679334906; x=1710870906;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nhixpg7VTl7nMBYFBFnG6Su2TPTwj+eYw/JAcC1nDGE=;
  b=fAm5uDDeo3Qv2xdMEWifZKeRpL9Kf/bd0XmKlBRB1uIkT6lz1ChcWFa+
   nEzEYuGJdTGJ3uf8ICu+kybIUaJ4udvd1wbbpQ6wE8zHIMpmUPQAZqP43
   dDcf5fefrFPVE8BsQjJ7LqOvrPlePa7d6+oFNNRSgWfiBHxYphGRgx2Z9
   YbkRz1cutWaY6hhekhoNR/cgXUSdV+IFAziPkcvqdajX3trCLBs90/SMi
   MPeCLEKwImuNLHjX1w+i0otcofEK31+ttceYRAymjBHHZ2aH7qB3kYy9n
   UCGOAPrFVW/ORoFZLwC4+8LyeW1vAnyQ9lMrvPuoOEXCw1edAhP4qzUNQ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="403607351"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="403607351"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 10:54:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="711434741"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="711434741"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 20 Mar 2023 10:54:00 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 10:54:00 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 10:54:00 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 10:53:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBSBR4y64QdltTrtCc0U/5RWgFjAJ4SNp1MRd6qjUa8VHXyEXGUlTT8qobZ30Ooya+m7WVQiNXVwztfRgpU0QbXrAn3MyrjCY8uHDmaUHdbKCQqIMimeDEtxmbu+4ndJWtG0hyrlUUAwoXJ+gYVVHKT4fHm/PHbhltAOWGGi9tLjV/cJefb3tAxEXfbRQMqT4ycdLnBO3PMvV1zMmIhmlm+dqCZ4j4ePA5GpN6t/zNICZEEPK+QowWG1w6ba1SxRxNONHpFyRrsudd8wpx3Pk7Sr9gx6Yd3sxMx1jUnFouVdQ4px9CYBTMTp3wSG7udfxAuWnUcEkePd+eQNeIK6Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=48IK0buZjR0Yf1Xl/iCe9gnnalZqztk4e70m0Q71Jpc=;
 b=cnz6UHCljxvKCHsBjy0BQRxk+yExZnvAgVPUi1FJAfewuXGc6AqpuIkH4BVrgYVFTs/odp5dw1/ns8FJOHz0tK9cwttk5uKrHQr8u2F2TdxfuOK/tLnUAL0Ki2Z8KHwCEm93Tex9EzTN1owRQ10EhP1dWY7LnJOEWe99VY/RCKcE6EvboXRgRLI4l2Dz7OEKk/a1mQJV4r+zWOQYWTgspX65DLSfvgVIASKcfbf6fe2LK7XVp3qUPOuUgop5ZYdSmaegApE7Le8nvjLmMxZmih/P0Jby9q2aEyXxntjcsSH+BZyz7m2o3AU6P2DGyeU+3uzw1tbqF5HtDeDmC8opjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH8PR11MB6880.namprd11.prod.outlook.com (2603:10b6:510:228::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 17:53:57 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6178.029; Mon, 20 Mar 2023
 17:53:56 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v5 04/34] x86/traps: add external_interrupt() to dispatch
 external interrupts
Thread-Topic: [PATCH v5 04/34] x86/traps: add external_interrupt() to dispatch
 external interrupts
Thread-Index: AQHZUKGztfjifB1+wEenbg44nnnakK8D4jgAgAAl+AA=
Date:   Mon, 20 Mar 2023 17:53:56 +0000
Message-ID: <SA1PR11MB6734EE8426F9E496CD417D72A8809@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-5-xin3.li@intel.com>
 <20230320153630.GO2194297@hirez.programming.kicks-ass.net>
In-Reply-To: <20230320153630.GO2194297@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH8PR11MB6880:EE_
x-ms-office365-filtering-correlation-id: 7eb76c6e-7d4e-4ae6-a826-08db296c1368
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iHIo5hn8QKdg2C1RmYFP78IUqClm4XfXuqxbDbAg81HfUeDdZLfyvBYLUtsg9TxBRCyZQ98JjzoxFcLUVc7MR1ng42eW0VaTk8CRLEjvC2U4mMm25lsi/13DMyHoB2GH+axgZHqDIGcaTF+RGl4qss9V3X3taTUcp+6IgvrwmXq6Tu7Q5WQxybstX6RmwuVaHs6HaoNb3WtENOm+bt+wS2XV7HU/sUbVklxVDDc4gJttm8S6lgemIpy2NDIwFXwjmg+oFMjkZRzXPV+tADcD8YRJy5xEKn/WdTvywQihpcZg2D9TO7pQIKUkQmA9DwWo1tpQivkGxKmSF1ehOEmFi4WOa7H2SkD+nQXH80QawYouXqyVW2Bp24xUw7Axv2M3Lfhk0s6WLgapnVvA2ThN8j63ykdaif5EV8YbKQ1nc+gS9poO3qkq/Q9zSkekgdqS1I1QXOEnRd4CijH9CP13vPVwIiRIbgVqDQrGpbLeGukAJZ1mFpUoeByYawe/IswFIsfE9xwzS2q4fWQioW9NEmRCxRo8apLtUiH7/AZRKzdKr9y+OgM6nowpNsxkjqcSoxgEnuIvd4hdyhnhJFOmAWuzrhZRvTiNB2r08oiC4bqwV5TwgFHiHxei/xEGQSSj4mCoy2rGz8R+ZyOlBYQ5dt31DkakpRo21VKLEz8I2HlMF6MXDZuctMY9PLmVjvUAHXMnhjmVUWss+7wnPj1tDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(346002)(396003)(39860400002)(451199018)(76116006)(38070700005)(33656002)(316002)(66946007)(64756008)(66556008)(66476007)(66446008)(8676002)(4326008)(6916009)(86362001)(122000001)(9686003)(71200400001)(38100700002)(82960400001)(4744005)(186003)(7696005)(41300700001)(6506007)(26005)(54906003)(5660300002)(8936002)(52536014)(55016003)(2906002)(7416002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rYrmQgOUYhZXlTR4zBQobFqyWyB98460teStTn+yFlR2+ReRhjyXeSjEjcen?=
 =?us-ascii?Q?NDrezFoAHvH0E2wnllPUqnAYNApk5C6uGnP4qz0GsERo1DOvDuauYeXQG0+m?=
 =?us-ascii?Q?JQS76CDAa1TZTnb21Vc0pvPH+rXv6EMJK7yyphTgo/Zgmh4FM2MiXo2LhDc/?=
 =?us-ascii?Q?Ku9/uIKcGCzJkQ1Clo8XPeqJge34WLoDGftrgWUmTPxy9dZ5Ti0+L046Arqo?=
 =?us-ascii?Q?ZbXcHk6Ogx8fLEelH0xp0oWyDIxRq8Ajp+i/5w+9/Xi9gRK5sOUpJO4KcCqW?=
 =?us-ascii?Q?y6etRlt5HQnRpzjkkFfpvNkd/cdggGGyqAa+6ubgAjcd4eSpPokytM0k0o3p?=
 =?us-ascii?Q?M6R3RqBvLpnUiaMLRqz5Lic6KGBZ6uRdOFvSiomkGa6zT8KEK6Wv2r1t5hBR?=
 =?us-ascii?Q?H1kGkNeSol8ElVKHwIKR15haNx+OhCTBoHYhN3m73MKheKVSX7/aG8K8PUnp?=
 =?us-ascii?Q?PV94lTEZTrEw8oJafIy+X2UTa343e36Ztv2StSaYxA/Nhou225uAxoGXLScl?=
 =?us-ascii?Q?LV9E8LHR/2PTlThpSCtZPcR3QMSY/NTmGDpHldDbw3/KcW/Y3ud86p/CQGge?=
 =?us-ascii?Q?T7kBOYoKwze6tiEwpmzzqOAmRKoChywC2VHPSixZYbPXiOa7NwNUiUmSTBUR?=
 =?us-ascii?Q?wG3ODagi3jLUP3k7jVm3IA0BC3zdnSKdL9bjdb9jG6N/RKNO+b+ybL1XWVOU?=
 =?us-ascii?Q?762gtOVuyGmDGUxoxaPIAqWB80mAbKbpeInR/4spORMxLzdGy3TEl5BDCY8N?=
 =?us-ascii?Q?cxpMwDSJhapIJHeQsfqvsZHPdFJJUsuYpPX8TksKZSQ3stwon3Zo3M7L6a8d?=
 =?us-ascii?Q?SyxPQfT0tlWdzsW65XSNEoF1O8iDKDZwI3mRibneIsa5TuoGcL6s9S/6Qb/F?=
 =?us-ascii?Q?Ep7/8W4OSa5AkQyZVJ+s9Td30hHZ888OLKGKE/1gYGxCLo8NxmsEe0bKQTfM?=
 =?us-ascii?Q?P96ojZ0bRFMmrio8JlHDh6LC1sN+seLYO9yDyEXC4PtSh004sDtE8+kqBvY6?=
 =?us-ascii?Q?BlkRrnFGddo8uIxEB2EtOmh2lzXefLTjwnl/LR6uYblFpfFwVfnyOqERRmNC?=
 =?us-ascii?Q?sg5xg3ah/laOOmzo4XjfZEthGxuj50wtDnLM5TAtV3PSB6yi4V1xNRJ7BK1g?=
 =?us-ascii?Q?tgur0gNfLDuVfDqtbW6cImYwWasSqqtkeOVci41aL9wWzm5s3FY0wiprZjcq?=
 =?us-ascii?Q?4oRhg82CxCWr0JYs5F8ioi7hhAYtxJ1+33DILzcBAc4QuCMF/sZuvQHNet3J?=
 =?us-ascii?Q?5nzbEU+OshcFps7OKCRL0nH3DWh4Kg95h7/YQqEys36wIEw6lPwv43qH/J4K?=
 =?us-ascii?Q?k1jZhHeSucHHu2Eel+05rhG9QqxgQ+HTxZmxluqQQi8Tv+lo5W9JvmVyBHLr?=
 =?us-ascii?Q?1sRL8sdonqWR1USf4bW7hIhU0XRMoPJZJjQ04PcCRvK3oQDEkUdsqPfVjaml?=
 =?us-ascii?Q?vJSHbskxbs3nGh8kMkFsq9mHKFt5/RiGh90HidksCswMMdg7ShUZHWrsULs0?=
 =?us-ascii?Q?zle5d1OmMtUu9pQUMlADcHsH6WUqF7slEzdXiA6d9ZKUjeMMbo9MIabMvj3h?=
 =?us-ascii?Q?QtMm19OJT5mPde52DfE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eb76c6e-7d4e-4ae6-a826-08db296c1368
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 17:53:56.1733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jx0Su8G5NxU6UKEWUU/hR4KVCg3Q937vP1n54UrhUqsq1R3Xmc8cMC2bf+OSQWNedIIxqOs7Kn+Wz99B1ucc/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6880
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +	if (sysvec < NR_SYSTEM_VECTORS) {
> > +		if (system_interrupt_handlers[sysvec])
> > +			system_interrupt_handlers[sysvec](regs);
> > +		else
> > +			dispatch_spurious_interrupt(regs, vector);
>=20
> ISTR suggesting you can get rid of this branch if you stuff
> system_interrupt_handlers[] with dispatch_spurious_interrupt instead of N=
ULL.

You're right, however I only fixed one.
