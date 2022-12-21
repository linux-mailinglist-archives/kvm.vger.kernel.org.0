Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCD2652BA2
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 03:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbiLUC6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 21:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLUC6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 21:58:13 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D31192AF;
        Tue, 20 Dec 2022 18:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671591492; x=1703127492;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Szo0a7rzl6/FHRzkuSOjL7LgoM3mKAJivYRxKDC5OMs=;
  b=hxcnp+UdYao2ufA/v6yW0ApeM3jH8yKLJmqoNw8AMzW4uHQ4kp8RQQ4m
   RDizLTYIJKwRGzYPEzNxR/ooPzka8DKGBhQyy4tJQgBydMKuKF/zxej37
   3MsBN1jEiHkcunlcayqA7gCL7tKRrqWMKTlcitmJjHtsvi766XAMM7ZAv
   IfzSaGUj/JS5+5jhIuR+ja1wczyOy1xDmrJhMy3oLzCBMdfvB4mnJCCRN
   IQTVd9evYHYxCOLRzRZP9xEP6SLh8p+Sd3yQAPzil5Cp35OnEr9xFWxzN
   PQmaYgdnK34LG5r9XLq1BaTkhfmNHKh0ZWRNWnIfWJVjKZTfyVjGzvbO0
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="300115012"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="300115012"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 18:58:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="628965730"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="628965730"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 20 Dec 2022 18:58:11 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 18:58:10 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 20 Dec 2022 18:58:10 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 20 Dec 2022 18:58:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTUF2APmUO1dSwbRupcegi85DIaFmfdNkrv6QdTfWj3hMie0BODS+92tMrCiGsCsi2LDqdMZGYu2B0HaHzXeZ59/kxWfUVqL/x69co+GcDi0cX8IMaQa7BCRuNR2xA/PMNBjbgFcCjEoFCOHmVSvH9TlPnl6rACMzmCxPoZo3FJpFzcZoGENmz3t+aJd8SMA+mOz8oiEssBluCrKfRX9yoP8DQQbCOnQXnFV2mG/b77M5I44UhHqQNJ9v544PWbTNcvnvjL1GecVrgqnJ9tslCRl/9cih35agxgCGigi6kT4Mp5XStS1KDQJJyohC/GPcuRidh93uq9QmbM6Xd2ZtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lPgXikvCFV5Q12fFlDMB75ALirFnSdLuPzcvKRq1XDs=;
 b=OWraNulcUngUVxF6TUZUdGDsyEldXIw1A7+rguJef4bp5sw+bX4AZR2ceWdZVbJQ89Azf8pkJ3L8OPimcF2uNnvDCJs/nUwYPSwdwnMDodHnry4CcevaPMwi6O8uC2C2ot3QW+sSq6G2LXwyRKzHGZcY89/zCIHolOR0gZXFje/1rG0TUopbJeEZXuu21eJ1I96mLNHhJyS3hcemVnh6QEUa8epueAv9WsXAWMbCq3PQqTpWVpYApCOnbFSEl+LVKIKI4szrftkyNjEU8JoGdQnPH9byYLXR4145sAk4UodwlgGF52sE7k/0m5406Fm1Lu+JbnW0rn6hWRoMkWVd4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by BL3PR11MB5699.namprd11.prod.outlook.com
 (2603:10b6:208:33e::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 02:58:06 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::5cbf:a669:456c:e130]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::5cbf:a669:456c:e130%6]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 02:58:06 +0000
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
Subject: RE: [RFC PATCH 14/32] x86/fred: header file with FRED definitions
Thread-Topic: [RFC PATCH 14/32] x86/fred: header file with FRED definitions
Thread-Index: AQHZFEEu5o/AN5WsE0ytIT7Yd8OXRa52eVeAgAEtzlA=
Date:   Wed, 21 Dec 2022 02:58:06 +0000
Message-ID: <BN6PR1101MB21615569318BD964A2855F44A8EB9@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221220063658.19271-1-xin3.li@intel.com>
 <20221220063658.19271-15-xin3.li@intel.com>
 <Y6F4s0K2b2G8aMve@hirez.programming.kicks-ass.net>
In-Reply-To: <Y6F4s0K2b2G8aMve@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|BL3PR11MB5699:EE_
x-ms-office365-filtering-correlation-id: 54cf3a33-bc52-4e59-e113-08dae2ff2f62
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aDbrjxxZkI0fC1QLjn/IzSHF929ioVCBO6DIzYLAkAHmRvTv9ofyWwcLHMVhAK3vq4oaE6yamk6gO1wtpAAdcv2W6HD6pMqlk+Xyrx5LvxLjvaT6wh+ZKv5OdmZkXOIf01bucQn1bbnwwL6AjVnQytwkoOEJJizjCcOquXiVB9e8fTaq/IKhOSkjehx7Hsjp0L7nc1Rv807mnyLZWZyC6v14Cj1knHxP8OjvLUreCf4Bv3U47GrWbmf6KPCUPyUJg33wLFAT18uQY0Eh7BiUEaobXWadLtZNbZ9U1tIewCJ2vqWNjs5L4JyokaIMxj1JO1jpv9Ln1QdwIrE0XbLCEqui/L0kYQTZ8Lw/u7bUvyewv5UOb7VBQ9VwSk/jWWk01zv9+U1vqblKJx6yY7xO/7FYggYUgi/KQVeQqDUH9gjuyXMQS21MpyAoJbXKIVjBieK90AjBc0Dnmy8ta4d54f8s+lp75tEYACY4DEGA+ok/C/YmJAoPoQczse+KyV2VluTs4WNIvvXEybUql867yEQ4Qmbo5Jcb09i+eBDQvMHFcYddHZe+sIbuqkbx2odhSKsQFgOuQN6KN70PaC1/ykUnr8zj9Jyt5juLDo+U2qCvFBdEbu+h1z/tKvdtB2Y10qYv3K2o+pikTJ3tl75pOfdsnBayM5B0aN6d0BOCgnhpRf1RDd6G+RVGISJSlDEGb3OZNkcGM0cCl6oVY/uTnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199015)(8936002)(2906002)(6916009)(54906003)(38070700005)(316002)(478600001)(6506007)(86362001)(33656002)(55016003)(26005)(7696005)(186003)(71200400001)(9686003)(122000001)(38100700002)(82960400001)(52536014)(41300700001)(66946007)(76116006)(5660300002)(66476007)(64756008)(7416002)(66446008)(8676002)(4326008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1e+e/LTg8DxSll6BxImzneAdf7SArPFq6l7STDBeI8vvwpAQfmPsDwhA1ve3?=
 =?us-ascii?Q?mm8feymRZchhmwNMMISa74rORtJJJcdaYvl7rKGV1uHe14jnPis5BVQ/SiCH?=
 =?us-ascii?Q?xfH9WxiETlS239jxJompm72xpz5IhCdsr/7bQjyKm96Mnqn2BMfLzVcUeysD?=
 =?us-ascii?Q?yhfzoH325FybQVtumtQUBsX+8Fz5EfCDchbivxV7mwPietyfIzuSlh+BeKxn?=
 =?us-ascii?Q?QnI6y3StLLtZKWVljFPSCbqIYGmhzxtnEQA4EaRoijnm9nTM0dbk4tOUr3Rh?=
 =?us-ascii?Q?7KjNDSOjmH/Ah2gya6g935rUoDRJaf2CMM3K+WusAnRc8gpKNVei4IXw32xh?=
 =?us-ascii?Q?o2ba8K2+wyFgiKTf2pTD1umH0rgLk/4PZpwdNqejiTqAejNuZ1FYYT2d9JeJ?=
 =?us-ascii?Q?RlhumGGKGe2pvKwTcC5K+c5JDaDWB3xwmLr5ZxoVieCCbUFElAOfsIojgpKP?=
 =?us-ascii?Q?1PmQghJ91n/XKeCnsgqX8PikfzYO2SYZG5niMMDX0Vgf9V2BzNdpqzFYuTo2?=
 =?us-ascii?Q?Wdu3xBU8BsxZrVbBqBeXMObwY+oqdigCyWIiWpHEfvayJdttvqM1YTUx3HGB?=
 =?us-ascii?Q?jfVzoLQQHa11jWxADtM41FHQKTVGlQIao6+roEUmLljArE7rodJkLRDEiC4t?=
 =?us-ascii?Q?0xp8yhbOinkBGP5awCdPumSzgCj4BUwrm+7Gmi1Vll1srGG0rfRrcxVNATqk?=
 =?us-ascii?Q?wvLTGhlCNLBdEtpNE7SVAL9/T8vDtV/fbE5NbxteKNp/tqPHFZqhQCUCBGAj?=
 =?us-ascii?Q?J81QqNnJpzlvqMBHvxv3tiLk5RCrZzHVq1cOCAAl1FZhIxeYNzMse8m1rFb3?=
 =?us-ascii?Q?6owzyQtLCz7bnUD9yv397Q6tY3zIQ6WGtsqKFUc6HSC9MsBXEUsUUkGVRjQn?=
 =?us-ascii?Q?Wc9t333RrtEZcLZl6hEHGZtkVZjPpIOSgdxfGS7E+0GIKdoUsGOvLZp6dt5c?=
 =?us-ascii?Q?CTbsA57fy1k7KjMCW9tDq+qja/phGr33il8dG7JWzepKmWW8ksg5PRePZub+?=
 =?us-ascii?Q?1x9Q8wzZZPpiIfSXHMokjNwKVlU2YuQBCfQNLhojNfL36Cs/LNDFxoLaspv1?=
 =?us-ascii?Q?cPStw/YTwNH1i5T9LJSV/I1T2BA3jX200vF50Xifrg8witZb5SEhHxHXoXQL?=
 =?us-ascii?Q?hXTQ8lgVu0Yv6IE4xYJmAykNThVHZfjGjX2OIPB0CPi3jrRN5IeDFz3RZ75M?=
 =?us-ascii?Q?hgHfIvCfIi8o+9rth5twu1eaD+2laRwbbYV9hPdC5vcZkg6DtI4nbiDwqvad?=
 =?us-ascii?Q?kEbfg3jk3MEyM6KVKb7aZUFxWfnq6m4slk8B8oE14gDPky2XvAZ7J8Lr6Ul+?=
 =?us-ascii?Q?uzoc6ZGSWccCMTyjp7EGrkLUgKGKmIKIJ3q0MYvMiKnW4LMC+sWg2GQSEgmb?=
 =?us-ascii?Q?hWxoQIFaaE6J+KFylzx2C+xbN4amE/h2tITlmHSxB9N8LvF0VGCgb+aCJ4YP?=
 =?us-ascii?Q?UCQ0fdUgTuzs5twTEAHtmk7+qwN8uyUF5ImujSHuSfgUZ5YqUMPf+dW+JJE8?=
 =?us-ascii?Q?G6TVY8pLS5h0XiBHgLBPm9fD9jGNCt+PBF4dGEwMwgXeAd3+e/JkuHX5BCXq?=
 =?us-ascii?Q?GpIPZH1qy4z7QGIdawn6Ii6kAqv2d4b3ZfGZR17t?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54cf3a33-bc52-4e59-e113-08dae2ff2f62
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2022 02:58:06.5268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V/dHqfvmf1nclh96Xcrv4tM8W+B47Pc8KQRKCvYu6LGdfdKyv80zXUFyz/+oVPUy7K7mEmMQbS3NzvADf3RQRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB5699
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +/*
> > + * FRED return instructions
> > + *
> > + * Replace with "ERETS"/"ERETU" once binutils support FRED return
> instructions.
>=20
> binutils version that supports these instructions goes here...
>=20
> > + */
> > +#define ERETS			_ASM_BYTES(0xf2,0x0f,0x01,0xca)
> > +#define ERETU			_ASM_BYTES(0xf3,0x0f,0x01,0xca)
> > +
> > +/*
> > + * Event stack level macro for the FRED_STKLVLS MSR.
> > + * Usage example: FRED_STKLVL(X86_TRAP_DF, 3)
> > + * Multiple values can be ORd together.
> > + */
> > +#define FRED_STKLVL(v,l)	(_AT(unsigned long, l) << (2*(v)))
> > +
> > +/* FRED_CONFIG MSR */
> > +#define FRED_CONFIG_CSL_MASK		0x3
> > +#define FRED_CONFIG_SHADOW_STACK_SPACE	_BITUL(3)
> > +#define FRED_CONFIG_REDZONE(b)		__ALIGN_KERNEL_MASK((b),
> _UL(0x3f))
> > +#define FRED_CONFIG_INT_STKLVL(l)	(_AT(unsigned long, l) << 9)
> > +#define FRED_CONFIG_ENTRYPOINT(p)	_AT(unsigned long, (p))
> > +
> > +/* FRED event type and vector bit width and counts */
> > +#define FRED_EVENT_TYPE_BITS		3 /* only 3 bits used in FRED 3.0
> */
> > +#define FRED_EVENT_TYPE_COUNT		_BITUL(FRED_EVENT_TYPE_BITS)
> > +#define FRED_EVENT_VECTOR_BITS		8
> > +#define FRED_EVENT_VECTOR_COUNT
> 	_BITUL(FRED_EVENT_VECTOR_BITS)
> > +
> > +/* FRED EVENT_TYPE_OTHER vector numbers */
> > +#define FRED_SYSCALL			1
> > +#define FRED_SYSENTER			2
> > +
> > +/* Flags above the CS selector (regs->csl) */
> > +#define FRED_CSL_ENABLE_NMI		_BITUL(28)
> > +#define FRED_CSL_ALLOW_SINGLE_STEP	_BITUL(25)
> > +#define FRED_CSL_INTERRUPT_SHADOW	_BITUL(24)
>=20
> What's the state of IBT WAIT-FOR-ENDBR vs this? That really should also g=
et a
> high CS bit.

FRED does provide more possibilities :)
