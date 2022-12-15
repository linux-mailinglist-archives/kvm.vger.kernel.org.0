Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7DD64D617
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 06:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiLOFS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 00:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLOFSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 00:18:39 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD0E12AE0;
        Wed, 14 Dec 2022 21:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671081519; x=1702617519;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9p6oF1OGNdci07D06/uWbAO521AvgBTW3ozt8hfi+pk=;
  b=dwkstRbFpmdFr4xF36OgrrW8Wl21Ha4u+t+6vxgcFIlwBNq5NTuuay67
   vMTp5ENISL5gnWKq5lNGlZlYbKjGhWj3+5sNWepFXf3Edxy/UX4qS3q74
   AllLpj35gZxZCPr3b+rrZOybtH39YBtROdT9PecCqeeE/qTpRtdgn8UdV
   0YkEwMYCgTOi9XVUOyJR825vENU19qW7YfPq1ETYi7fWaRuyFK487qKNI
   dJbJFRy0Y/kjuF6CalqZnwQnIJm8PA8vUcinMiu7fqdGz2W1VBJntw6jg
   SEhMzk1Q7GlxXY8FV7NycODCjeZQnefaiZk4RmhcmKMpT13Sxy0DC+xO0
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="306231405"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="306231405"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 21:18:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="773584121"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="773584121"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 14 Dec 2022 21:18:33 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 21:18:32 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 14 Dec 2022 21:18:32 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 14 Dec 2022 21:18:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUL3ZvHSTgXbtW8dvI43YwzEiCEmtTftkf84I7Yp0WxeU3qpXmEmGWChJD5yALH/J+M7822bid+jYxeRyoJ/2gZjkS1HePa2DmiRcF0hcFl8me8F0E43uBka9spSVCjgvsxCiyrYcDbBDJDhxKn7QBRwxWlo2813dhtXpacKGwikxrOUANqJ+Xq4vyxtAH3c7Za8KLmBvHOCdhtLmTW2gyr91jurObxvRg2NDqcJ18I9SyZ7Vod46YkxgQnE7egC/SFWkq7cSL3w8iO3fx9456IZkYob37pbf++bd0AhuFe+QZdLH6bnNzhRjd9EAf4vBDPZU0GMXnMc1P3RVmDmFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CQDwLdtV9cR0WGdgZSbpk1llocPFb5RpQkxdKzR5XeQ=;
 b=fk3hGGIsnX8mML3YD90OtvyUMit+BJDBOmJtJB0qFFjqV39YfNbP3YRrlUVF2oOIf0d0gVoSskpBWIeHCYWSE1IJ5hk5Z6xEE3xBj0VBRghmFuEMlPmzqMe3D/QIN4Qm2Six4oOK4g6BxbvZlIse7OSUKnslMFfoLQ8Qo3N/eCrE2STlwOP1XhzFgVpp0rq1JxnFvyySXr0Lypjj53bCSSdNQotCOZacPFhC8JiJkpqfh++hReYheKQ7HAlD7DEJwfJJIQl4mxbVHNdfaUhF3ENAuURd4BasvofczrRmg7yJyHbZO2kgQZJXRbRKzSkg+p3qKyw39G+m91yu4dyv6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by CH0PR11MB5233.namprd11.prod.outlook.com
 (2603:10b6:610:e0::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 05:18:30 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::5cbf:a669:456c:e130]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::5cbf:a669:456c:e130%6]) with mapi id 15.20.5924.011; Thu, 15 Dec 2022
 05:18:30 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Li, Xin3" <xin3.li@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Lutomirski, Andy" <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [PATCH 6/7] KVM: VMX: Provide separate subroutines for invoking
 NMI vs. IRQ handlers
Thread-Topic: [PATCH 6/7] KVM: VMX: Provide separate subroutines for invoking
 NMI vs. IRQ handlers
Thread-Index: AQHZDrmN5sCXvT6vVk+HmM53wIVCP65t5D5wgAA2KgCAACvJIIAAHg6g
Date:   Thu, 15 Dec 2022 05:18:30 +0000
Message-ID: <BN6PR1101MB2161F8ACB46A3C027E0553ECA8E19@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221213060912.654668-1-seanjc@google.com>
 <20221213060912.654668-7-seanjc@google.com>
 <BN6PR1101MB2161B2CB247273CDD85F4C19A8E09@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y5ppzEEqFB1XqhoJ@google.com>
 <BN6PR1101MB2161646D0E7FF2ABCAFD4177A8E19@BN6PR1101MB2161.namprd11.prod.outlook.com>
In-Reply-To: <BN6PR1101MB2161646D0E7FF2ABCAFD4177A8E19@BN6PR1101MB2161.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|CH0PR11MB5233:EE_
x-ms-office365-filtering-correlation-id: cbd091d9-32e1-413b-0ae2-08dade5bcdc0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JkEZDdg+dzstweZugMZqmgZNLmM6D44Eje1/8sGBvyf90MzBxlYXMshzZpaEd9Id7qkgjy/sjR9Zb1NlFvcnD3B6uzYLwXadbwi44g17BqSgb/fChQ8+wA+rVpB95MLO+zCzl4cWqE7iR3wyH5XA3dohnWH/xMuSGkjbDCJJO7lURkk+BGkNdDtxbeNc0Cf+2xh5rGPqzwwNcfvBP9JPAlL+dnCGctrAAiCSf5WaQm7rFZyCJ0NHdXNhzOMf9rKpfWsBJBFXqnGf92UeOajltX5ZhftsrtZlFcFlNdbuhb8DeiyiNEmh0O7yN2orPQMjZ3gQU2Tv5+OnIbKP3a/Lp+gsp86pmrOKfUfaECB3rdzJNEfxbHNhsWRIuMFUVgHZCZeqvfoyPBTPAqCj+owjJe7G1Ab9WQGFXNpULo3HJILDo6WkCBwix+dhIMuR0V4sXrsJ44/ZdsHe1KjfmWj8ik4yFIGrwFx0ix3ec///sY88htLKArQ9UAvFjzG6x1BAZUjVvkKnVn8tyE0SkJ5n2P73rzgphA3iTwh037nQTpeRZEkOJ4dyS14zyc1/eNs1tFJ2JavtyH1hwH/twW/ELU8WqrSC118kv1/jYdPyqG93zlkuBr/aFWlRsE5O+w5U+91ZAAAomvy7+/baMv83ZMR2WOVg8GJD8fAT6PsNwLwKx5aYxfB5CfXr8PM0cKQBFCDWkRBA6mspgRBlPMIfSg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(83380400001)(86362001)(122000001)(38100700002)(38070700005)(82960400001)(2906002)(41300700001)(5660300002)(52536014)(8936002)(55016003)(4326008)(6506007)(7696005)(26005)(186003)(2940100002)(9686003)(316002)(66946007)(66556008)(76116006)(66476007)(64756008)(8676002)(66446008)(71200400001)(54906003)(478600001)(110136005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?svN0U//ZCj/Ft36z7NhwVjg2PZEg2obasyNGW7rYt2UEULrhmLbRQuTzrCv2?=
 =?us-ascii?Q?Yp41PDqo+LqfX33bOd8Ic1XdewhhD8xe70wXnb3e4aFi9e8Zb7GgCfSLFbeo?=
 =?us-ascii?Q?eCtdZU/jf8wATBrS14Pp3YGCeLycPd/kOAkSCQ2pzYYYfPzklqdPSOwBJBqz?=
 =?us-ascii?Q?reVvBE6ORixnKRsnxqEIc10lspYuaMfMwfzNByFQUb/HibyZ9pbbE9fZqNhH?=
 =?us-ascii?Q?WcPI65H8IlTjG2s7C0jB3xaYZJwUMihXdP+sukGAWYFC5w7BCjM7iQkfHk4H?=
 =?us-ascii?Q?4/FqCDWHtLCTFVatMZjByH/O7F1CU6u6paapfJCDS7L4Xf9SymNne+GXYC46?=
 =?us-ascii?Q?uAbwkwR2h7dJJjK1OMGECF8Lf23yPuh/OLBOd1R4K1hDFZcc6XcHctWc0kP1?=
 =?us-ascii?Q?Z8iad/nt1XPXAtbJzcBA0/RM4GlcOSXClBS3YhDcv93YWGKZpBUNIx7aSkyh?=
 =?us-ascii?Q?JOw4Xv08v7H7A73dXyjhGjORQpkIqXVt/txT5RzsgzTynFbzqiUCIVPV5sb9?=
 =?us-ascii?Q?uXfITHCNnYKEUaqoQL3YFmvC+hLRvWiwsgoILNmTZvSAzkjzKKdWve1rCuGs?=
 =?us-ascii?Q?7NFgYNEIkODEzyHJN+q22Oboo+LeGqKRSHkMy71ZZw+aC96tuHelmA4FsKvO?=
 =?us-ascii?Q?fOKeMRfFMjs3qqPJMDbVqUkK1K3ZHt6s5VSstowgPYF6ECjs2/jfngevelaG?=
 =?us-ascii?Q?LuKNIlpQalHAOHMMWzZF+AZj5BKzA/WipSYS06tTLsu1Xiq4atuiI3wZn84J?=
 =?us-ascii?Q?4Y5/i6R7kil1prqB3b88iuZ/LPsQ77pzUlmgbG6fKaYUAicxWOo/P5EIbcKS?=
 =?us-ascii?Q?oFRsnU15u4knPDtclOw2eeXF/0Ufazev3o2HohjbjaoL1ZgE+EcAQzCk9zTZ?=
 =?us-ascii?Q?6QPlDKx3PNIT7apYuz7V/2395ULhjS9DlntdIdgVWcBlVFa9nQ7gdC+4NiyU?=
 =?us-ascii?Q?10Clmz5p5Xw2LoPBxIG6x+e/AqSpq56HdfgRdaQEgA/RBp2YMRyCUvimAYdm?=
 =?us-ascii?Q?kU93zL5rOBRIK7RWiY9w3+vb8PQECi8Cwx8g0dfsi9ehgw4DCSYfz+E1B8WQ?=
 =?us-ascii?Q?2XXe6772FILzfGMZcBweq7hnQmAAdtD+FVTq3KOBYzt/qIpj7YnyMsSoWLmu?=
 =?us-ascii?Q?b+55JGnKolZL22ygHJSfyXbmvaSdz4nsVfsfP7lWOIFVr968y8D9M0rrO6I9?=
 =?us-ascii?Q?FMoUDi32ZSfxYk0Q7kVYl55FhPSJhpHHfZKs9KVnZJZ3+x0SMR4Zo8AXcEaj?=
 =?us-ascii?Q?hi1x8XS/qY9lS2lji2GUGqWfXeCbd/b8LvLh8ZIb9lI2h/ppV7VOBjBA4Zk9?=
 =?us-ascii?Q?KdEmnZqOI/unQYyafLE8+uk7zJkIPFGpJ4c3Diqv0HH5SBWXj/ctyrrHfJM4?=
 =?us-ascii?Q?QRuwmTh06phFsuvUhR7sUUisDiVAF/+jBOYnwOKxIti5NAcdZbC9sILweztC?=
 =?us-ascii?Q?UUs7mEHfNRYBWYoeXlm45Y5AfkuQag/Gp4nj3ZVlKEWIJjkPOGel/IX0NA89?=
 =?us-ascii?Q?+JGOihdrCxqE15z2uA73Hmb3sw3/AJUtMRAHWWXbHziOmgHOt9qn87Do7Hwr?=
 =?us-ascii?Q?udz8sVCrJg7e+2O5tL0TRo2YtHi12Z5UaGIMr9wG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbd091d9-32e1-413b-0ae2-08dade5bcdc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 05:18:30.1339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gLplR88ITlR2rhDL8Z/ruRrVISzHXufDcxGIP3dJ2R76LGJDvFr+9lHlU3oIaAUO6AOkWRdNAkAfSksmGFC5xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5233
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > > +	 * "Restore" RSP from RBP, even though IRET has already unwound
> > > > RSP to
> > > > +	 * the correct value.  objtool doesn't know the callee will IRET =
and,
> > > > +	 * without the explicit restore, thinks the stack is getting wall=
oped.
> > > > +	 * Using an unwind hint is problematic due to x86-64's dynamic
> > > > alignment.
> > > > +	 */
> > > > +	mov %_ASM_BP, %_ASM_SP
> > > > +	pop %_ASM_BP
> > > > +	RET
> > >
> > > For NMI, after this RET instruction, we continue to block NMIs. IRET
> > instead?
> >
> > No, IRET has already been done by the kernel-provided handler, e.g.
> > asm_exc_nmi_kvm_vmx()
> > by way of error_return().  That's why the CALL above (that got snipped)=
 is
> > preceded
> > by the creation of a synthetic NMI/IRQ stack frame: the target returns =
from
> > the CALL
> > via IRET, not RET.
>=20
>=20
> You're right, this assembly makes another call into the asm entry point, =
which
> returns here with IRET.

Like IRET for IDT, we _need_ ERETS for FRED to unblock NMI ASAP. However
a FRED stack frame has way more information than an IDT stack frame,
thus it's complicated to create a FRED stack frame with assembly.

So I prefer "INT $2" for FRED now.

I will post the FRED patch set soon, lets sync up on this afterwards.

Xin
