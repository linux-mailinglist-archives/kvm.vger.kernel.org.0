Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9F76C3712
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 17:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjCUQjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 12:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjCUQjD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 12:39:03 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7255D3CE32;
        Tue, 21 Mar 2023 09:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679416738; x=1710952738;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kf2/KBxrEfXsS0kwsXhwsu8QOAX7Dz2ifdtjVW4NnsQ=;
  b=THd1NLGzNiGsl7NLAPtWeqwxyMH4GeBOPoTXRkxXT0ScqDbi1L+yO578
   YlRKUq055o4VNnlymqF1HFRJGnS72OuEu8s9xga2cTzCdWmpRqz3Hv8tY
   3ZnmDj75Qzq6jUS/ivIHUHGGHGYGSH/P+0R6x3QIVJC5Qptdzi7WpLMLc
   DAHPcTz38VGOSA7jRfayA5n1wwcFKhTZTvGWDqaZZ9GU/yKO0VnWDCq7h
   3ZRSA4Iv2vqIjBg9qME9VRoFFVd9+frI/auPzMnfXzCvfbIKRRBz1fBo+
   XsszaU+4WzKa7nCboD9cvyAJbBAIlLLESgNkijFLdPfpf2VAugvrrpRTx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="403878874"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="403878874"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 09:38:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="714059908"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="714059908"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 21 Mar 2023 09:38:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 09:38:50 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 09:38:50 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 09:38:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QkWwK8RBxABeg+mBeSasGZEl4VkfLtowgm75ASTM1oK4k8dNCFhH6xPny8kaSwf2GRnJttTmoRY2WaA0trV8W/P4NFLhT+kisDKBeIkmnhOXIBHUzTCpHLzYw/2lnuyYsM8l/h02RnywApcgE87ouz8IzKBSvbNbcX5AsaxQM8OjRCcRy7yHRa5MW3KhHubXN2KBkuLan5TUfvN3UlpxD/GbzgL5TAkI8nVivHSFvSGA2g5FKr+10sk1RoA+lgoVtg3fKkhb+WGgq3B7DeUDhsK4HIth2s2IvnXnF4lIai5VEU8l3tTGRP8gXgP1Uv1NY2FipN+l0sd0xGZ/+8dN2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kf2/KBxrEfXsS0kwsXhwsu8QOAX7Dz2ifdtjVW4NnsQ=;
 b=MAR5A69JH9YBX9fV21qcWYAfPY3zPACyCw+GXXV92x2OLa1LuXO+FCk9AqW1zFs6nBoUNEr1vBvI1GH4uyOcXKRfBGKxtvCX7tIPv1qIgL2lcgGRjV9QRBoJt1rfdi/ZVvXojKvAtLw48vlmZcma/x6DJtrgTJR9zckiHcb9TUU16xoV3EKB/NRam+BjkWbE0zrZ/zU1giwlF8FrlzNinRjYwDFBo7u6fKNQt5a9cPh0lTwSVD6zLJ0NSIHMEvnYCSrKe+nU5zcUgvmUVM4SYRqN/9dcfZf6MvfAi2pRmAFJfUQ/YEEPBNbuW75zUH/jAYWrwamJ0IxA8vqp1l5pEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by DS7PR11MB5990.namprd11.prod.outlook.com (2603:10b6:8:71::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Tue, 21 Mar 2023 16:38:46 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6178.029; Tue, 21 Mar 2023
 16:38:46 +0000
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
Subject: RE: [PATCH v5 20/34] x86/fred: add a machine check entry stub for
 FRED
Thread-Topic: [PATCH v5 20/34] x86/fred: add a machine check entry stub for
 FRED
Thread-Index: AQHZUKIOC/3kvxGGb0mH1uURdpTy+K8D6OGAgACEs5CAAJgogIAAf+hg
Date:   Tue, 21 Mar 2023 16:38:46 +0000
Message-ID: <SA1PR11MB6734AB884DD7ACB4B1091796A8819@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-21-xin3.li@intel.com>
 <20230320160021.GP2194297@hirez.programming.kicks-ass.net>
 <SA1PR11MB67349805EA11F4BAD07D62F9A8819@SA1PR11MB6734.namprd11.prod.outlook.com>
 <20230321085953.GA2234901@hirez.programming.kicks-ass.net>
In-Reply-To: <20230321085953.GA2234901@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|DS7PR11MB5990:EE_
x-ms-office365-filtering-correlation-id: fdb4bf5c-26ab-45a3-caa4-08db2a2abdbe
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xgQ0P4x11xvbnI0hJH64mAqA/KS7hdNQKAOp294snKrGBg9be/sgNO2Cib3HgRJVImMPFpPON69HaePDGjtZzxKVY8jGomm0A6M2tBMV8Nvbwwn6emL1EGAb3Au3jxSCDLSPPs4vwu6LNdVF23gU8cO52aqVwEMoFIGQVDj1BoS/m+9oQgiqr2Dgv1iJ9uCaxZ+6xNTmuyGOT8ReHaydChXhkd77dW8yY4hwPdoKECgU6FAhjHEsxqnr34PIf+sXKaBr678wocvDL497LPCkiFDMA92JBe1Y6wNwLAe85/81VtztaeTvFlp6FdGAqgPh5xPl2zm6geMHl4QJ16dg75I61TMH+pFl9GaMWtXPjD+/YakKSV4cS1ffDriC/SucSiPlLuZ1HfyXqeKzSHYi5zwWfTngLlqk/blvOijnyxu8cvouIWkE3YXK+Vtyark213jBoduoLrJwbOyk8UFJSxsxC8FYPA585v2Ktv/Lve+MG8BqJOAqG3M5siG5ju2gu/db7HVs7/1Wv+uA7yUWLo/qP0rtqoCHr8lJw2LxqliZvvEdSnUdHdpmeqltVfnOjo+a/E3tm3hifIe3zFtV9i0D7ODSjGdxEbVEAwmZmzPzgp2Q9ZDuHUF7w7vlVc//gJKsSb45BcMF4y2R1hhklQ3Ss1jkmEjVHf+tcct7MMV9jxDF6FWpE+BkXUF2i8oYBEV/ZMQSZvKHpTed3Smokw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199018)(5660300002)(38070700005)(186003)(86362001)(9686003)(26005)(55016003)(6506007)(41300700001)(2906002)(82960400001)(71200400001)(66476007)(66446008)(76116006)(66556008)(6916009)(4326008)(54906003)(478600001)(66946007)(64756008)(8676002)(316002)(33656002)(83380400001)(7696005)(38100700002)(7416002)(4744005)(8936002)(52536014)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qUZfWA2Pw6cyLSoBTKbXzafoOhZImwtz+QvpXVmc4a7CBzhEnf5KIg4+QKc4?=
 =?us-ascii?Q?G72KMu3lthMYjQSAP+3qeOTT2cQ0tSGYaPmMA1JIpZBNThsacW6CyDwr0jJr?=
 =?us-ascii?Q?wq1PAEADKrPxakno/WghogO+aMjIhqhT6GkUy0+e1DxAQGkElCc6p1D3gyga?=
 =?us-ascii?Q?aYW0PgTDOTE1oA3aMz3182T5OHcRpSaXkHM6Od030GerJcnhjNrdsiHwBTSB?=
 =?us-ascii?Q?g29v+uhTBDhAacTpQe/kdLLgaA9ZK7UpLNegZZ1SgmR4DxtVdZHUxvw3AvzJ?=
 =?us-ascii?Q?Cx7ybXBd40Q306ky3Ly83D+LDUEZ1wnNx2lkqTgY+FNWzPKEA+Impqa+66dl?=
 =?us-ascii?Q?r6aHtZpHSb461wZRZ98+h0vrrJ18/OdrE4QkoG007TbWYTkDKO0t0DBKke5+?=
 =?us-ascii?Q?jQUlTDjd+CCoMNY52shSOJxQNmS6jRHoygYH956gkY452Mz4A/w+9jueDT8A?=
 =?us-ascii?Q?qS73tyZGU18mGRhFFCNaZo4sj3VGaPUADiNeTqAt9rH0pKDYy7wj53Ydhqw5?=
 =?us-ascii?Q?VgcJRa8zTKIuNSzYL4Pvqt3A0tv9NL38QMiRhr35fNp/ptGkcirCpCmmQQMG?=
 =?us-ascii?Q?417Np63P9q8f+ys2Q81kf+b6YxenSSOlrWkyqIXHtQjz+QLmes6hclBf513x?=
 =?us-ascii?Q?bFoqKXAVjVwoYDUT7ya4LkpN3vVdUeqUAhuKqchAquYcfPIUBkmDiNju9fhC?=
 =?us-ascii?Q?K2Z8TZewuV3YMV2fdu4HY9Kh/zZmTVg617hDiabip05vXcnWD/lIE0fD2igE?=
 =?us-ascii?Q?0efykUjP+1H37H6vVp53h4NUR4YQelERqXebZQSy1jaP0+qTrDzvvhU6RbJS?=
 =?us-ascii?Q?37qUIf7Ej0CmQLZvOdyD+Lgepm8dEze7DHo6ZnEkO2kVSG/ZBVfiL+CJUtiT?=
 =?us-ascii?Q?vH3FSdNUtp3f2DICttD6K0fajyv3jOicKkeAU7vAP3/p88Lh/yJESb+jOlki?=
 =?us-ascii?Q?aubK4nMqwAkRz5xZt/IBBmHfzUb1zdu34KN16jykHL+J/2TZrt/LW419vkw2?=
 =?us-ascii?Q?y8kLB4y5Vj0Jv/7e12OhkxBpsouwN/XAkfpHqU5lir+e2J92VDjHtOaWQMDN?=
 =?us-ascii?Q?DnaMucCt1+c3kqfHU9yfc4FBM9/9Qtkn6YaVSLkJcPPm3baNhsoAp5jHRSw+?=
 =?us-ascii?Q?SZvEAgZEJGW/iDi4wRO7SBDje60HeGqx3xSfYdD+wQzg4FOqG195k8g5P/Wv?=
 =?us-ascii?Q?Rc8Xc1RGp1nYCVvYDY9k5K4sUQYjU8TaenNuPxsZMTZ4NNxqYfg6MjFTV5SX?=
 =?us-ascii?Q?L9btpVAvKm48q7yWaG1G7L0aoRIR9Xztk7fBX1kkzJ0A/KDC4lJFR5ItZARD?=
 =?us-ascii?Q?vJoSJdUkm8XvY2m/u6Lbri/k0zr3Sc/Pv5XPBSrp9p8YorBXNoM8ToGXcuKZ?=
 =?us-ascii?Q?UIsp9/FS4/Hvv2siW6Eghk+xUCffkHRoujCWXHRxmxRjZY6J07exfvrSmIr7?=
 =?us-ascii?Q?8DnPvbaU+ev23THCfSs/8d+SQNKB8QcYfOPvnU0XIGG5m1wWGEOwNyr4dm4+?=
 =?us-ascii?Q?/MyCkZJ57YrnHgiMzZ81mtTjA32+8Ap99TPQPxgtho5+f8tgLGYLhUrVbaoV?=
 =?us-ascii?Q?PB2KgeF04ve0mkLKQhI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdb4bf5c-26ab-45a3-caa4-08db2a2abdbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 16:38:46.3291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EK6/+JoW/bBxJ8msVMF2ZOCWdPBKrLqkj7FIBOsE90cdcuHiqJ3w5h4WowJONqg48BYFdJp6TFOwLR4FkQ7YXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5990
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Tue, Mar 21, 2023 at 12:04:47AM +0000, Li, Xin3 wrote:
> > > > Unlike IDT, no need to save/restore dr7 in FRED machine check handl=
er.
> > >
> > > Given how fragile MCE is, the question should be, do we ever want hw
> > > breakpoints to happen while it is running?
> >
> > HW breakpoints still work if they are properly configured.
> >
> > > If the hw-breakpoint handler trips on the same memory fail that got
> > > us into the mce the first time, we're dead.
> >
> > Right.
> >
> > Unless the MCIP bit is turned off any subsequent #MC goes to shutdown
> > ("machine is screwed").
> >
> > It's the kernel debugger's responsibility to decide how to proceed in
> > such cases. But if the kernel debugger itself is in a screwed memory
> > region, we are soooooo dead.
>=20
> Yeah, so I would much prefer, for robustness sake, to start out with not =
allowing
> #DB in MCE -- much like today.

Will disable #DB inside #MCE then.
