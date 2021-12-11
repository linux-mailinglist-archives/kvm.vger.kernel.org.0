Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A30471114
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 04:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244295AbhLKDLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 22:11:23 -0500
Received: from mga07.intel.com ([134.134.136.100]:27357 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235308AbhLKDLW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 22:11:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639192066; x=1670728066;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Tuqa/w1YJZQEIhDENEI4m8Z0YXsCNEsaFjuxpL9Zxn4=;
  b=SXUEuvz+KZJDahkeknUK/T0c77r5cU7TV+HxR6uNO9QBlH9oAGgBuaU/
   fziUkg1t2erPzY5WVVovfG6agejHVoViDS2us2vll1nGAo7wDUvz/UNwZ
   jR1IcNHu+/l2Eln6fuSolg9eoYthzdQt2UEH5yYjoQMb6Ci8rJEwsvLZ0
   z576r7l0nk+f6pF+RZzmThFJWIaGKoY9QejRUfbwbXbWpIzCK2MhX64y6
   Wo5Q5FbhVITaTavOYzY9f1omJWFToO7E4fWWEq4OdmqVeXdY5jEmmfCRa
   z4gV6/MVJm+IBEI3Z3OmkQh+pcL5LUVbrNZXTg+2iq2qOp7XzrOD5Re4f
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="301887279"
X-IronPort-AV: E=Sophos;i="5.88,197,1635231600"; 
   d="scan'208";a="301887279"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 19:07:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,197,1635231600"; 
   d="scan'208";a="480944702"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga002.jf.intel.com with ESMTP; 10 Dec 2021 19:07:45 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 19:07:45 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 19:07:44 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 10 Dec 2021 19:07:44 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 10 Dec 2021 19:07:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAiutmbNv8lo4syLMYAxPFcDFTqiiQyaKWSBTbf0iHJeQQT4yrIUSLj2GIpCNDrJOG9O9vrr+RzW6Gu9GIptxGZqUAhvY0i4qqtNAKRr9/FOVPBl1vU/612RhbSf6wtm1IJN3v5XO3VYg05IGCdfKPzWwqXWeOOphetYMRx0jr2YT00Q63pVil3DO5slmzL+f2cL+jI4w0cM4NPKK32FdmMfMj0KxrxBhyfqmgXJtPY0Y6zkr1cErZXN/alreXSCkvaH8c4TlweEucOKio8j+FFqN1r9lpHlO51SkRkExv37Bp2SRP2Zyrxm2xDANMcojKavdJEUN6EWRZ4HyxyLVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7sUPTEuRLwPP6EglcB5i51Eu5vPDyPKDe3z6FEcmjQ8=;
 b=GlF0EamH5pdufICW24uK71T7V+GVCOZhPOYVJq/ngcI7t8oRD2eK2TsZI/z0mhwuj6hecOt697QaZ9rIK+1pNsdwe/EQ6cA8WR6cpo7EbpaJlMuuwVrdgP6kjMAs5hTGB1uGu0E+6uCoQkKN96Fj2udKspqkvdjKpH3cznO8nrWDXKhMOeB4Its+lP6Wxc4hFr1HIy7pZ42FbIU/iSimtf4v1iKD137frdJxbKAziwRd9C7GBBBeZS70XlOkkJTfKsYIc2nQojBfczTmMz7Ae+ynmSHPnH/E+sGa+v0BF9T01ThaxGxGpkFLbw8z22mEpNmTyA481Rhq80dPNyUJsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7sUPTEuRLwPP6EglcB5i51Eu5vPDyPKDe3z6FEcmjQ8=;
 b=Xv9fBzt3wgMKDOWHMPNAeN/1BDp91piV1hedGq17w8QTYIdR/p8o1teQOklXt8LK7OJaiQmEPbHzm8FeT9iOKSte4M6xOMAC/ITo3bOXeR1cFq2XqzfO5pzaGhiRSyd97MWWMEBpI4YmtAB6llE7kY+CuWfvld7oJMRPiEHyASE=
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1396.namprd11.prod.outlook.com (2603:10b6:404:4a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Sat, 11 Dec
 2021 03:07:40 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4755.016; Sat, 11 Dec 2021
 03:07:40 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "seanjc@google.com" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: RE: [PATCH 15/19] kvm: x86: Save and restore guest XFD_ERR properly
Thread-Topic: [PATCH 15/19] kvm: x86: Save and restore guest XFD_ERR properly
Thread-Index: AQHX63yRVs4GDusAIkqrgl6cVTrHdawscB6AgAArmbA=
Date:   Sat, 11 Dec 2021 03:07:40 +0000
Message-ID: <BN9PR11MB5276DF25E38EE7C4F4D29F288C729@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-16-yang.zhong@intel.com> <87pmq4vw54.ffs@tglx>
In-Reply-To: <87pmq4vw54.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bed4bc64-b6a2-4287-5b55-08d9bc5364a3
x-ms-traffictypediagnostic: BN6PR11MB1396:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB1396FE697D2EDAB2EA7D64598C729@BN6PR11MB1396.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U6ZEq1lfvWXPp7IHurePFEiR5kY8yPs+xS4+J3tg6pf0dBRxSjtp2rBwuR50OmukR8V+BW2V/k6AwKgpVZscY6y+kYUe1Lta7+u0G161Hrm5SzGBPJ6gga2vfsOXAll/LgmkXXwuCw37DuXuoI4ycyuVfoZaeA36DE/b2uekNS8ekv/TecQIAd+H+eIuyLh12V+kx8qeKl92ltdQW3OYMx1mTU9v+eBj5Ye8mbi3RDYIIaqAI3IBb+eaulOBShQfcGJOfz+lq/kGTwWkk/fhYOsz1zPSM3oOHdk8Pb3q6SPNcLyPbKQuhmy/ipGqxWBPxLm6qku3LLXxWDNK9C2OBsdtWQkgFh8ptz9vYzkYDyIzHOefX5YnfsaoBnYeZ08zYnzMTVKBFOnl0rE7Bou7jcfBmatM5XWPj8IjqunNiiJQBCMi9HE+5IXeWGBU8IXBRd2o3pihoM+ERjuL+XYZi3IsAoemCyuIipXrhoqSzc1TvozEdJC2V6iwQnK5YPubJUYqfzEiY2imo5fO4h90knrNxymrnrZxpB6YkiJ3LGWvF3vxdZH5s17sk51mzjzfU7OVB1dwqqtf/VkfniFsNbYdIQ0GJ3aikc1kTjRAijfJtEJZwzxJcU5xtnNSdaGu+nSCc6VR0CpBt4tigqDbSuInk31mjlFf0alIZ7S7WidPE3DcTF9I+eiZfdd69p5s0RnKeLDIY3BP9Xj0DN1J/rMMxKvFdZ4kK299W0RMn4k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(316002)(66476007)(186003)(66946007)(66446008)(7696005)(76116006)(64756008)(26005)(6506007)(66556008)(7416002)(508600001)(8676002)(8936002)(38100700002)(122000001)(55016003)(4326008)(2906002)(38070700005)(52536014)(86362001)(33656002)(5660300002)(54906003)(110136005)(921005)(83380400001)(71200400001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UDfzoBuERtJ8kuAtFmr9yi3uf57hk2iQbBmZDoj0cTq4ihZcWccnoNkqez6o?=
 =?us-ascii?Q?rpCjO2EBwwhp/Q2rElFF2mZWTJwEZ7Y4QIez/kk42KtQzUomBSB3HIYJIGaW?=
 =?us-ascii?Q?fjJ/hsEvePa2o1JX8cpkkO127lW+osSSAiSjfq6yeQiX0Sl0k79Tx6OYF/rF?=
 =?us-ascii?Q?KgG1LmKj7TzdsIX9EEpraJTRt6CZbVjiezYI4l9EPfw88wcqtJH4ToyTsfJB?=
 =?us-ascii?Q?7TcuFNMu6Sr3hHPyP3nDCwCruQHCpIL0uhuddqH/K1VSXjF7y0M5vB0A6ngA?=
 =?us-ascii?Q?xnfvJ7SlrlJHdq+kkq7C+Eyi3WcrqKVMtaawXcM3iFebiEjJIjKx+pbVwvZP?=
 =?us-ascii?Q?xSlh87SlnBbxto36dFal70J59BnZ00I57HfgbJyoq0KxXAMiPeWCwXqnaDa2?=
 =?us-ascii?Q?/93buMPloQWv4UbTesDf49dRgjOryiWZrxhMEePtoeQe4KrmtxFErIFRwv4r?=
 =?us-ascii?Q?9SeyaIH0WYHkmv1p6cwdfOP70bXTIHwo3yVbNBiAIySJ75NMZcUi0z3q6p2F?=
 =?us-ascii?Q?5VaJLc1AxxVCG8d1gEkSJU7Pyjsm31A1re0lNUySgXnzmv5K14/fmIPJUmyW?=
 =?us-ascii?Q?u7dq2uGsTiL1sI0p3FtzpBZQBgEklAecV4T83Q/0Dg9BuBPk/pA/f93G5ffA?=
 =?us-ascii?Q?0SSn8o7TJtAWkvriJmLOAeM8NJen4wgap1Hm+TH9tTb4JwRjyyvU++yx1W1N?=
 =?us-ascii?Q?mJR1NQX8tOziaC0NxIr95b+StqrG2OFLDzH//ojJa66PhWvxdyQbxCZIw+N5?=
 =?us-ascii?Q?PP3oRFj2zPay5Mj9+0gecxJhj7svKzcD0ItBASI2vOi3H3x1mLbI+wwsAocG?=
 =?us-ascii?Q?mDWcgQoi+HqdPH56Cq5UIzzqAzEUr7wo/REhYX0MsS4Udjp59QwekSiYv0UT?=
 =?us-ascii?Q?pxnapy6XYZ5wPqZZ2FeIwQUnkugvbfzwFyiE2xYWC++pRFW+Vm1zGutC8NPK?=
 =?us-ascii?Q?r1dwC+HWuMsh3Au1MZv7UjifFctGGHM7e9l2/20oKmt6Hdn6d6ChX+J3/tBY?=
 =?us-ascii?Q?ilRu9osWX5udM4uKkomtWYRgGJE14F5yZhoqs4EJ5ffoiajNowhXbzMXIhBd?=
 =?us-ascii?Q?MnQbg38Hw5k3K9bDb4V2i1B0OsVfwLt9UofV0cu5z0TrPswcVkFMTh5Jp5+L?=
 =?us-ascii?Q?a2HDgxASp4EnoAfsZ8pFaTkR8JCxw0gDUnXhnTOVlcPT4u/Nw76GKhpUfDkV?=
 =?us-ascii?Q?YoOND8upzau2PH0Fl7a0tPOlcIM1bXe5oMDZ+91Uyn0LmWyvoYKrT5bEAU/u?=
 =?us-ascii?Q?gZunnlwlc4KzmADMc8zK583JqD8Gst6O5dExn5P+g+ChHPgbAptkcg9cCX8M?=
 =?us-ascii?Q?sP3tA1LgotvDIzmYN36nqlXpg7pGT6OZ9AFEXtiyig/1MXEFlg+9yQNpiBgn?=
 =?us-ascii?Q?RVBsrFdPbG5BwI4zrQNUArlX74JFWzGVXDZTa8wImo51lSc6feUleBpq5GnZ?=
 =?us-ascii?Q?3cFQoyQkCdUVtrwHoMq8psM8VV/kYk6VuFkKvgJY0fod1zLDD86AlvG9lUTA?=
 =?us-ascii?Q?LUaV/is3bJCRyD4tuWK+ayE2Ys+d6w+WWybVxYBP2NmOcbnJ+RegeryDU4nn?=
 =?us-ascii?Q?gNV7nh9YFGGdiuWDZmGOFb9jd0bSTA3azgfD9gXU3pgf9dY3w0tTeSyw23b8?=
 =?us-ascii?Q?Fw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bed4bc64-b6a2-4287-5b55-08d9bc5364a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2021 03:07:40.4190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nru6MdYYsVqlbjvbVF6+Z2ZxV/oq7fa7mMEbZocuEysvQZ5silDhzXnMdJpyS56tF08d6IE1LN0vu75kMBHC8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1396
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Thomas Gleixner <tglx@linutronix.de>
> Sent: Saturday, December 11, 2021 8:11 AM
>=20
> On Tue, Dec 07 2021 at 19:03, Yang Zhong wrote:
> > diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> > index 5089f2e7dc22..9811dc98d550 100644
> > --- a/arch/x86/kernel/fpu/core.c
> > +++ b/arch/x86/kernel/fpu/core.c
> > @@ -238,6 +238,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest
> *gfpu)
> >  	fpstate->is_guest	=3D true;
> >
> >  	gfpu->fpstate		=3D fpstate;
> > +	gfpu->xfd_err           =3D XFD_ERR_GUEST_DISABLED;
>=20
> This wants to be part of the previous patch, which introduces the field.
>=20
> >  	gfpu->user_xfeatures	=3D fpu_user_cfg.default_features;
> >  	gfpu->user_perm		=3D fpu_user_cfg.default_features;
> >  	fpu_init_guest_permissions(gfpu);
> > @@ -297,6 +298,7 @@ int fpu_swap_kvm_fpstate(struct fpu_guest
> *guest_fpu, bool enter_guest)
> >  		fpu->fpstate =3D guest_fps;
> >  		guest_fps->in_use =3D true;
> >  	} else {
> > +		fpu_save_guest_xfd_err(guest_fpu);
>=20
> Hmm. See below.
>=20
> >  		guest_fps->in_use =3D false;
> >  		fpu->fpstate =3D fpu->__task_fpstate;
> >  		fpu->__task_fpstate =3D NULL;
> > @@ -4550,6 +4550,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >  		kvm_steal_time_set_preempted(vcpu);
> >  	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> >
> > +	if (vcpu->preempted)
> > +		fpu_save_guest_xfd_err(&vcpu->arch.guest_fpu);
>=20
> I'm not really exited about the thought of an exception cause register
> in guest clobbered state.
>=20
> Aside of that I really have to ask the question why all this is needed?
>=20
> #NM in the guest is slow path, right? So why are you trying to optimize
> for it?

This is really good information. The current logic is obviously
based on the assumption that #NM is frequently triggered.

>=20
> The straight forward solution to this is:
>=20
>     1) Trap #NM and MSR_XFD_ERR write

and #NM vmexit handler should be called in kvm_x86_handle_exit_irqoff()
before preemption is enabled, otherwise there is still a small window
where MSR_XFD_ERR might be clobbered after preemption enable and
before #NM handler is actually called.

>=20
>     2) When the guest triggers #NM is takes an VMEXIT and the host
>        does:
>=20
>                 rdmsrl(MSR_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
>=20
>        injects the #NM and goes on.
>=20
>     3) When the guest writes to MSR_XFD_ERR it takes an VMEXIT and
>        the host does:
>=20
>            vcpu->arch.guest_fpu.xfd_err =3D msrval;
>            wrmsrl(MSR_XFD_ERR, msrval);
>=20
>       and goes back.
>=20
>     4) Before entering the preemption disabled section of the VCPU loop
>        do:
>=20
>            if (vcpu->arch.guest_fpu.xfd_err)
>                       wrmsrl(MSR_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
>=20
>     5) Before leaving the preemption disabled section of the VCPU loop
>        do:
>=20
>            if (vcpu->arch.guest_fpu.xfd_err)
>                       wrmsrl(MSR_XFD_ERR, 0);
>=20
> It's really that simple and pretty much 0 overhead for the regular case.

Much cleaner.

>=20
> If the guest triggers #NM with a high frequency then taking the VMEXITs
> is the least of the problems. That's not a realistic use case, really.
>=20
> Hmm?
>=20
> Thanks,
>=20
>         tglx

Thanks
Kevin
