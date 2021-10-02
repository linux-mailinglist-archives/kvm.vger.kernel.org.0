Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3293B41FE95
	for <lists+kvm@lfdr.de>; Sun,  3 Oct 2021 00:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbhJBW4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 18:56:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:35536 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234050AbhJBW4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Oct 2021 18:56:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10125"; a="222545136"
X-IronPort-AV: E=Sophos;i="5.85,342,1624345200"; 
   d="scan'208";a="222545136"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2021 15:54:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,342,1624345200"; 
   d="scan'208";a="711032049"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga005.fm.intel.com with ESMTP; 02 Oct 2021 15:54:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Sat, 2 Oct 2021 15:54:29 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Sat, 2 Oct 2021 15:54:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Sat, 2 Oct 2021 15:54:29 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Sat, 2 Oct 2021 15:54:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGO97KUb4Cwsht7DkDH8QphPibOavMSvhA9Z3geqgRrTMzHaDBNNyNE686N2HMYARFzw+LvGNEK6S4FI1+mFxFWffqmIlMg8pCsukZ39ggfWb8UPYkpv7eAFTPTu+AlshjIsSBbmkt4vyEs+1OmwGLC88kq8SKM4OSGsSg9Ew0EkhQPHCZmew6hPOQuVEzjdE2zXt60Pxu0JmMixkP9XDYC9wYyXHD38lM8iaQN5OA+DV5jPO/VCaHdusSkclfsWl4vi7qbNNU8/u//bfSBt2Em2ZZcE79nWwazJcxVQyKwtASHZK/LgPBLs+3GmQlIGj2FdHlHRpt5cN1EqlUFC4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FGMe7DYbQYLNaUeElztDGIzBKTg96xNOxppAcOEifAg=;
 b=O+PADUK9/qDc7vpN0X9pOmi9AiCAN1B+XFifvXQue1HuYQoqz9GKhKxcZ+zLU/FLqxfAxQlf+mLt+8VFJ8d71JauRRB/So3fgT6MdeB388bUajJ3DWu15XXeGc8HjD27/NNtLhm/P8/O63GYjEi7cCcn7w3vX4sS16pKu3gDGkuy2ykO3sco/ywQT3k12FJ470xf55+JoLEv029YPd7vEagLdWdX7WBYeITcyleWfhq/lKKlSZpRSxiSH56pfbp2ebkK2fpUFZu5Dm8iGnF/4+NDvbazblhWBypggb2grwtPNKb/TP9OqKWiOf6X8NmB7B7GCemzzymX+J0KyXSYbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FGMe7DYbQYLNaUeElztDGIzBKTg96xNOxppAcOEifAg=;
 b=rDc7/cF+4u0Qu6S9h1XXGZq9TteP5yLDlIWGMXbgXYcOyNY2/s9epWUV/fCjumnsg/a7rAsv2s2/p7F/lo3ovyC1llFbwiAueTL+d9m2REQcvubEf7QGfk48x9tYRAsAnmgB6LJ4QhqXH6Yrpg8U83/JASfok3pct9Rl/C9kqlk=
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH0PR11MB5062.namprd11.prod.outlook.com (2603:10b6:510:3e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Sat, 2 Oct
 2021 22:54:25 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::b427:a68a:7cb6:1983]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::b427:a68a:7cb6:1983%3]) with mapi id 15.20.4566.022; Sat, 2 Oct 2021
 22:54:25 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     "bp@suse.de" <bp@suse.de>, "Lutomirski, Andy" <luto@kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Macieira, Thiago" <thiago.macieira@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v10 10/28] x86/fpu/xstate: Update the XSTATE save function
 to support dynamic states
Thread-Topic: [PATCH v10 10/28] x86/fpu/xstate: Update the XSTATE save
 function to support dynamic states
Thread-Index: AQHXmcps/AuzuQhndE+G6RIIKQI9gau+ghQAgAH0JgCAABcSAA==
Date:   Sat, 2 Oct 2021 22:54:25 +0000
Message-ID: <0F4DCBED-7A0B-4C0C-A63A-3C7E9AC065D5@intel.com>
References: <87pmsnglkr.ffs@tglx>
In-Reply-To: <87pmsnglkr.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac2a30d1-9778-421e-61da-08d985f7953f
x-ms-traffictypediagnostic: PH0PR11MB5062:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB50623564278A9F244CAE8E21D8AC9@PH0PR11MB5062.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A0CvGLKuTzZM20W7xIJGHnbOG7aSWeS1vCs5dQC16hfyJts5+RGP1QsHGYi3uX+uckWxQoz5y11zwFLYnAS/RDugznsc0CsKVVQy2LSQkIXU7GJuQun6h7KXtWJjqivfypQtpNvcqajYPsEQ7ZUCi6DbfeaWwntW1+ft2uPkLfsenZwWA1YQPy6x5Pl+yn9/5U8vfCQBZJE4HzzROJ3xdAmebvg62F9q2yX/ChOX/Lik5ECAW+v7ZHhBPbKiMkmykVHSHd9bXTudldiEnusRo4JdlQ17rBVptlJgoJgO7MGeEY8ZwrJmd6ExKxFAUL9h+tqEWGS9nvyg3rcN4BcGjdVp6kmw+szG3wVUSEg4WjXLTRvVkCU8bWzGEI2CGQmtZkDaM20IXaltUwiah9cUegNX6y7TAtIhL0yastvSilrM7h1guX90Djos3LZBy1UeVSj/gwY1penI6TdjjqsPO9lO80t3592hJE7XeXAxSOhq0aGe92w8sMZagwU/ooepvXfz9EaMJMS59iLEYjglF8Ot/Lr7TOYNDGN9IBywvQ9IuZokMA0E2Dh63L3LyXzzJGmAFemw+SG55gmbH4niRwD8KEJ60yBgybz/O7NHZOJPXMtnQ/VdOryHTVIuL/zwMWtVQP7CmRkLPAU214r9pnHPy2EGOegT6C8+SPFp/U3uaq7ibLmif1EcJbPk2YSrCmo3ZfaTADAmfsfsXa+0ytBH8gZ4WdBRbQ7Avq+ksXeY3kGRZCiFJKV/oiU+b06r5gSNXgjXWTnObfyEz0tvKZD9FeyhUFTsTmBRUeamuWvdT9yNei+6ijLoYcqmqPuJFCK+UITSur3mxVcQnvBWeT6Vp94j/m2ThlXejlB0lctRZeqzI3X8xr2t5riIede/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(83380400001)(38100700002)(122000001)(86362001)(6512007)(38070700005)(316002)(2906002)(26005)(33656002)(186003)(8936002)(2616005)(76116006)(36756003)(5660300002)(66476007)(54906003)(6486002)(66946007)(66556008)(8676002)(6506007)(6916009)(66446008)(71200400001)(966005)(53546011)(64756008)(508600001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wtF9JPN2cdorgmIsGURGEe3KhhQdUHR9vnh040TN49diegLa1wiFssmI97s1?=
 =?us-ascii?Q?pPQ5v0I6N8sebjdDMyRN3yX6BNSu7nSIkel+GEmsb8evJ2RKlOWB2z4tQV75?=
 =?us-ascii?Q?yGmvc3Q8U67vdi3pP2blCT+t18ciZr6KdaB78eK0wdxT8KGGfL9lctXs87QK?=
 =?us-ascii?Q?0pVosvLd1moQYQ5WKGkiv5rGme8zBlPgR/GLE3eEtypGVKokefwEog/zNAqQ?=
 =?us-ascii?Q?+lmWVaaHZ9MpQ+wZeo0VHyDwC/HWs2AkSItZAjpB00vnfEyiXzRxP480yjL2?=
 =?us-ascii?Q?pGCl9L3UxY3H3WYjBCL/Wjo3P6kHYkdfX1QMgXEflwum8U+/+NjI12hLsJHI?=
 =?us-ascii?Q?FSlUShep3jOxMXHzpOxwiOJODU1YdFMj72KyYljlBEassf3J0X06yVuE1qi3?=
 =?us-ascii?Q?WAQgjYxMqso/h9zmSvwOzTamB0AXgEullUzLwg+nLwjfmXiKXy0NiFlhKrD/?=
 =?us-ascii?Q?D2FcvavNZFZunJnUAg2FUCVU7izvJ2EYACC8Q5lIcMg479dayvGIt0ndSoBC?=
 =?us-ascii?Q?27mlaoa39yd6U2V4wDIjQAuXY2xeoiRnV3yqL5U/3IJcUOtXxr4tZ82PrcQ2?=
 =?us-ascii?Q?IyxAQFyVjCEHXFThBD1FIu4ab3nyG6uK5z7ZPFlxditVFPyXMB5ObEKjN2lv?=
 =?us-ascii?Q?21gEIZDomDrbIoWE5t15uTmqIIwpmFjVq/99tlPtyGYEEU9rpmeRIEb/Jr8s?=
 =?us-ascii?Q?l33oo3DNaQOWFaM90hrV+j7PvfHRxiNt+eCjLhcjQDpL3ev4kO9wfsp5Q0r/?=
 =?us-ascii?Q?4LcYyUmzetxv0QE0PrMYiCb/9S/jvgMrgCCqbdWw0awxD4bIETFiKl9Mf19z?=
 =?us-ascii?Q?WHZdBwqz8RexMi9A730bBcEBlCeBSSIS2Rvknjx8xWbBUl84+ASrg6/qyOMZ?=
 =?us-ascii?Q?AVOT78zfMZ1DfWT3teYAchJC0/pDXbKf4ho4fF0OnfkHCusn59jGI8D3k1NX?=
 =?us-ascii?Q?oVbZ66f5x39rqToRa5ysDAaUiw0bmiAt3TxrduVXw5YtieQHTUuRbbbjZnxr?=
 =?us-ascii?Q?RMYynLXNiaXj/trKLlXAwGLvB7xOa9xCjOOGC5KtLzjhEHDUjQgT8+NB/bB8?=
 =?us-ascii?Q?YUmlw1yDDlysM25V7nPwp+kFl7LlZ11K3E6zr4v5y/T5hZ0jt5NYoTrAQOgj?=
 =?us-ascii?Q?kLRlNNf/7ZQabn9MkBlD8EwKkoSN1tlQGGiBOTqCsKDxQEHG5uwi9XzD686H?=
 =?us-ascii?Q?0TxFH0b7CNu0Bz2gvVoQBhw1e+wpoWlKETMcfaPrLg4FPQkwgwr3tWFF8S2U?=
 =?us-ascii?Q?mf4mgn8Ji/EODA1h+slt2mQLYiVpLNp5DpPtnD2Ist35ejqH36wPQvXCGhWx?=
 =?us-ascii?Q?jklR96vmhYmCBq1LAK1o/LJz?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2D220912796B244FB88E134BCE5F74EF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac2a30d1-9778-421e-61da-08d985f7953f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2021 22:54:25.5189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xekiAV7jSZRhp3Tjbz8XeAtSxY/L/sC5PTBR6rklhSCAVyvtJPMZqUQXbYlDSqVfFmJgNYHcXZ/4NTMCVDmVK9OUGzs0+QB27Um1QB5jWQI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5062
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Oct 2, 2021, at 14:31, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, Oct 01 2021 at 17:41, Thomas Gleixner wrote:
>> On Wed, Aug 25 2021 at 08:53, Chang S. Bae wrote:
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 74dde635df40..7c46747f6865 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -9899,11 +9899,16 @@ static void kvm_save_current_fpu(struct fpu *fp=
u)
>>> 	 * KVM does not support dynamic user states yet. Assume the buffer
>>> 	 * always has the minimum size.
>=20
> I have to come back to this because that assumption is just broken.
>=20
> create_vcpu()
>   vcpu->user_fpu =3D alloc_default_fpu_size();
>   vcpu->guest_fpu =3D alloc_default_fpu_size();
>=20
> vcpu_task()
>   get_amx_permission()
>   use_amx()
>     #NM
>     alloc_larger_state()
>   ...
>   kvm_arch_vcpu_ioctl_run()
>     kvm_arch_vcpu_ioctl_run()
>       kvm_load_guest_fpu()
>         kvm_save_current_fpu(vcpu->arch.user_fpu);
>           save_fpregs_to_fpstate(fpu);         <- Out of bounds write
>=20
> Adding a comment that KVM does not yet support dynamic user states does
> not cut it, really.
>=20
> Even if the above is unlikely, it is possible and has to be handled
> correctly at the point where AMX support is enabled in the kernel
> independent of guest support.

I see.=20

> You have two options:
>=20
>  1) Always allocate the large buffer size which is required to
>     accomodate all possible features.
>=20
>     Trivial, but waste of memory.
>=20
>  2) Make the allocation dynamic which seems to be trivial to do in
>     kvm_load_guest_fpu() at least for vcpu->user_fpu.
>=20
>     The vcpu->guest_fpu handling can probably be postponed to the
>     point where AMX is actually exposed to guests, but it's probably
>     not the worst idea to think about the implications now.

FWIW, the proposed KVM patch for AMX looks to take (1) here [1] and
Paolo said [2]:

    Most guests will not need the whole xstate feature set.  So perhaps you=
=20
    could set XFD to the host value | the guest value, trap #NM if the=20
    host XFD is zero, and possibly reflect the exception to the guest's XFD=
=20
    and XFD_ERR.

    In addition, loading the guest XFD MSRs should use the MSR autoload=20
    feature (add_atomic_switch_msr).

And then I guess discussion goes on..

Thanks,
Chang

[1] https://lore.kernel.org/kvm/20210207154256.52850-4-jing2.liu@linux.inte=
l.com/
[2] https://lore.kernel.org/kvm/ae5b0195-b04f-8eef-9e0d-2a46c761d2d5@redhat=
.com/

