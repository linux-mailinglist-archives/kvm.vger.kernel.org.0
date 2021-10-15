Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996E342F530
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 16:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240253AbhJOO04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 10:26:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:49811 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237269AbhJOO0y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 10:26:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="251366923"
X-IronPort-AV: E=Sophos;i="5.85,375,1624345200"; 
   d="scan'208";a="251366923"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2021 07:24:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,375,1624345200"; 
   d="scan'208";a="525444800"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 15 Oct 2021 07:24:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 15 Oct 2021 07:24:46 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 15 Oct 2021 07:24:45 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 15 Oct 2021 07:24:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KSmboPWAeeo6rdLIQCYpLZTw4B+feQn/gmr5FQLvuIURqa7K3pXpOiAUgsWvJJM9crsK0DNw24rItRC1NeybX02zhVrqV/S6THR3Nyb7SLiKcFmIP2DjUgvHECaIzbZGtYV9L6hstEvsPjKMEuCOwEVkiRg00DCq51sqMc1mytRWu8W2/XVdFMl5AkDJqbLqO061aEO/Wjyia+hAckB/YjwEWo/ybTrbG4I5p1iSIBroPo4nU18S012/TzGSfpsgAjE3oo2EQHoH5Ch3fEk578fTrEZKFSmXPJ4b6/FI8QY5pxdr+qGRoKD+knO4OXBO08bmVfPVJ2wnxO6bBVq5mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NZE5NmIa4dqKYcLQdJifTsZhF+fGDzkvwJQ+JUHq2ik=;
 b=j9kau0ahkneiZH/mJftYvmgEFcHCgIBomy0A4hye+UmcdyylbM4RDTgHK9Bq8N+ZbUdKWx2Xk3GFR9shlP/VNfCjPOPzIokbJcC+8VJoOEEjzclLOvoA8e8oyZ7uJsOmUvVqEceQmctRlEQOrqdWboeIGCpnHBLiZ33TVjp9SzU5halQvNHST7Mn1iYaU749x9NHpFAcUKk+RoeAa7wCFKBsK4ok91AHDFrw+gRdVi/v5Lc5x2sJjYghYPJLFwG3vokkll+3TrfHovjWVSdysFX/UneRa5XgXbNtF5DmYRjFQUV6NbG2ca7+frUNux55wv5qF5IUIukfCSF15hMriw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZE5NmIa4dqKYcLQdJifTsZhF+fGDzkvwJQ+JUHq2ik=;
 b=wx+N+eRKVDxFcNoOfFCdCYtMRW4H6RM4e9ikUrnLLw0XkddB8R/GJaI4d5cQCQbXPWUaUkDoIu/Chc0zLhm512Fuo6oHxSQV2LBPgEDHht/xfVb3O2Alha0EV6On+/7wYIbOEheJIKedC9rDzxdQwavR2vrO7OYfT9lLsFHxnZg=
Received: from BYAPR11MB3256.namprd11.prod.outlook.com (2603:10b6:a03:76::19)
 by BYAPR11MB2678.namprd11.prod.outlook.com (2603:10b6:a02:c1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Fri, 15 Oct
 2021 14:24:44 +0000
Received: from BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::61d4:ab77:cc62:fabf]) by BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::61d4:ab77:cc62:fabf%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 14:24:44 +0000
From:   "Liu, Jing2" <jing2.liu@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>
Subject: RE: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Topic: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Index: AQHXv42x8Iw8v1bdT0WqN+QXiZLaIqvQcYTggAAF7ACAAAOKwIAAIoqAgABafQCAARh7AIAACH/AgAAb+oCAAFYIAIAADomAgABGxACAAPDYgIAABKrQ
Date:   Fri, 15 Oct 2021 14:24:43 +0000
Message-ID: <BYAPR11MB3256B3120DEB5FE0DD53B5B9A9B99@BYAPR11MB3256.namprd11.prod.outlook.com>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
 <BL0PR11MB3252511FC48E43484DE79A3CA9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
 <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com> <87wnmf66m5.ffs@tglx>
 <3997787e-402d-4b2b-0f90-4a672c77703f@redhat.com> <87lf2v5shb.ffs@tglx>
 <87a6ja6352.ffs@tglx>
In-Reply-To: <87a6ja6352.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be1ac956-c4db-45ed-2bfb-08d98fe7889a
x-ms-traffictypediagnostic: BYAPR11MB2678:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2678FECE677D44A2176F121DA9B99@BYAPR11MB2678.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iEpzNMDZt9Dx/gFnw5HZ03TzPpVKjyiJMTZuP0f5GqIDePkVssEh0EEGWZM+nLvWHPMmZMncO8DfJ/zPcAxPR/f4SIQJOEtWnDthhq/mRcWzebWv17Uyx2NiCF9qZe9jqTkcUKOn0okXDKK+kXAYdN8IGxBxl5Dn8YU0Q1cUmLORjB2fL3A65vKq/N/7htgsfokOe2qyIj4ROBTzmsXC29e+tqnAzr7XdIwXxpIHZoSPAIr4+HHoI76RxeDV9xYfml2pZHS5j6CXcOwpSSdByKl01K/JQWBQEpI1HgWMkw9VSqVhNCLXSJYdocOjIq4awzOsFBZ3uejL8HeNTw57Wb6H714s7KrC9trkVaZeI1C9RpyccwY2dKoVqeuEdC9FxlYRSS+XSRwihv9BgjAjmipNcjV7whyup1Z32ydYjLOqxOxG/01qkow5awbJeLJL/Pf20fZ51v3JDn+1TRN8x5u2Inrv8ppE5efwFpj21Qx/Nzcp9ch/yTkhFTTswur4PFLjrGuN7MBTAwnl+8jxGsDGun2a/0aR4DsmGYzzP/dBwdgosUxRl734Nao95dbt9NA8eGjIB3hhZ0e9w06vDerlCnHrNif4ib4ywCnigCqbd3GwozNgHvLCG4Ey71P4tH903tTJS6YCwEQSSbPeWRrJCyQpxfltUGS/vdWC4izM8RdRBJIDkcMAy6N0LdKacqSI3fRsOHpiv4zURhKEBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3256.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(9686003)(83380400001)(38070700005)(55016002)(38100700002)(122000001)(82960400001)(2906002)(4326008)(7416002)(508600001)(86362001)(76116006)(110136005)(316002)(54906003)(186003)(66476007)(66556008)(66946007)(26005)(5660300002)(53546011)(33656002)(6506007)(8676002)(7696005)(8936002)(52536014)(64756008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?23Q6uTnY1V53kRYAsvAabt8h2FiF1ybX+Y/jiDEuiGEHddsMdrtFIso8yPhe?=
 =?us-ascii?Q?xdkec/4AJtwwCO3Sia5jYMe23rXn75Yj7UjMdPl8HRF0RiCgYI6Aq7tn3ejg?=
 =?us-ascii?Q?zi43/NvOhHBgefvNYYAV418roNB8GLNQG91nClMeTb/3jEWsJ3XeDtv1hb9O?=
 =?us-ascii?Q?SFdaV4krJKt6GDx8d5P9vn/VXVC+CXWGmaiU4CbWaiLXqPydIyQbqvADRzMo?=
 =?us-ascii?Q?UgAh4gwcZy8U+g0pOljuzwdOaPu596b+XRfz8abP/Uhjw1Y+BYODfX/ZR8o/?=
 =?us-ascii?Q?e/mspvJnn49GHS3IydqPLS35E3StKX1KRWnBmA7izUdU+4zt1Jbdydifd3du?=
 =?us-ascii?Q?fUHoG9Uc84LP6V3Q0k8uxzIKesAWcoBRYGvmQ8TgdwhTD011A7mjF/gZppbl?=
 =?us-ascii?Q?9h0xSL8fWkplGaJ+2CAu8M/9SfoSqdJqJSTpQW4sKbgSZuIGu9uQJv9+ykJG?=
 =?us-ascii?Q?xyY99jYvfZo+zAMg5JsCZhn8VAZ7Zi2WMr0Qfw1GNLDIJfBg3Ugo9TSNfRyy?=
 =?us-ascii?Q?aNS3TyexjJ6jrlJ+zgm29Q/we3VGspO2tDTgtBcto5DEOEfjk+YXsSJgT6Yh?=
 =?us-ascii?Q?XbmK7urkNcgv0LYTi/7GNvYVSZQyaR0gcW0EwCcNN85abdckAfy+MdCCllSa?=
 =?us-ascii?Q?fJgC7Osfwf8q0GKls75B3Zd6DvCQdXnUI57WpAdxbbckaJWuv1H9yIaHS0P8?=
 =?us-ascii?Q?+f8+Nv1egjXLkst+qhrM35n6QrU4gXar6FyhA6Ft8H9iNu0XyGniy+VvygVE?=
 =?us-ascii?Q?UhM+VxOwaiyNfmFz2y+apMXdhrFVAGFtN4S8gm32iBSzzmxUGxaN7c2gV+VY?=
 =?us-ascii?Q?tBpHofblr5iuw+OsxJNqIS9ZJpSsFe8G+a5NRpEfPXXxX1wofnOREDbQ2FoZ?=
 =?us-ascii?Q?eCP9muZzqaVaHLsAPP1VojbmJhEdr/Qt3pW6LkkOXD756tIJd16bK2SPNp1z?=
 =?us-ascii?Q?EoVYBd+mVXj+MZgMJMEYFuMnj46BzOW2TwxN2Nh08p3Bun5ljUsZyozBUJde?=
 =?us-ascii?Q?UpxEsDkrmtpvDu3XANrM4V71vFEG2V4GxQl4I/WW0Lr2HK3JuaUJCCPXz/0N?=
 =?us-ascii?Q?59j5b21qBWEKPCEuENVwMlElaDerpLAzc2Y0VeMP6+NsA7L1KXrvOq8DYGiY?=
 =?us-ascii?Q?QndMFF6FSPAG+QYFdn7NFHhBwvB3wvxV0zegQjXSqUPV13I5l0bz2Hq5EpEI?=
 =?us-ascii?Q?OLoAlevsGQUfCkhYWALkk5c2J0aM6cvwJJblXlX3WgBjTNXanMlp0wR22P0X?=
 =?us-ascii?Q?3szKqWxPK3BP8+3duwe6tdvjzbV31V1+d678H3hU1b3m28/qq6YVKLniibqA?=
 =?us-ascii?Q?uosLUQFuh24AI/jIg87EwQfF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3256.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be1ac956-c4db-45ed-2bfb-08d98fe7889a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 14:24:44.0249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oBV1+ttzrGf/gUgu0fwySOb482YlvJTyC1/jsHmsrn6C2c2nsDZM3BeerMF52yV9sZEz0m1VZI1q8U3D636REw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2678
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On 10/15/2021 5:36 PM, Thomas Gleixner wrote:
> Paolo,
>=20
> On Thu, Oct 14 2021 at 21:14, Thomas Gleixner wrote:
> > On Thu, Oct 14 2021 at 17:01, Paolo Bonzini wrote:
> >>> vcpu_create()
> >>>
> >>>    fpu_init_fpstate_user(guest_fpu, supported_xcr0)
> >>>
> >>> That will (it does not today) do:
> >>>
> >>>       guest_fpu::__state_perm =3D supported_xcr0 &
> >>> xstate_get_group_perm();
> >>>
> >>> The you have the information you need right in the guest FPU.
> >>
> >> Good, I wasn't aware of the APIs that will be there.
> >
> > Me neither, but that's a pretty obvious consequence of the work I'm
> > doing for AMX. So I made it up for you. :)
>=20
> let me make some more up for you!
>=20
> If you carefully look at part 2 of the rework, then you might notice that=
 there
> is a fundamental change which allows to do a real simplification for KVM =
FPU
> handling:
>=20
>    current->thread.fpu.fpstate
>=20
> is now a pointer. So you can spare one FPU allocation because we can now
> do:

Trying to understand your point, seems struct fpu will add a guest_fpstate
pointer. And this will be allocated when vcpu_create() by the following
function. Swap between the two pointers in load/put. What I was thinking=20
is that vcpu keeps having guest_fpu and delete user_fpu.=20

>=20
> fpu_attach_guest_fpu(supported_xcr0)
> {
>         guest_fpstate =3D alloc_fpstate(supported_xcr0);

I supposed this is called when vcpu_create(). Not sure the reason=20
of supported_xcr0 input here. supported_xcr0[n]=3D1 and
guest _state_perm[n]=3D1 which is requested before vcpu_create(),
so this will allocate full buffer, at vcpu_create() stage?=20
Or do you mean vcpu->arch.guest_supported_xcr0.

Please correct me if I misunderstood. Thanks.

>         fpu_init_fpstate_user(guest_fpstate, supported_xcr0);
>         current->thread.fpu.guest_fpstate =3D guest_fpstate; }
>=20


> fpu_swap_kvm_fpu() becomes in the first step:
>=20
> fpu_swap_kvm_fpu(bool enter_guest)
> {
>         safe_fpregs_to_fpstate(current->thread.fpu.fpstate);
>=20
>         swap(current->thread.fpu.fpstate, current->thread.fpu.guest_fpsta=
te);
>=20
>         restore_fpregs_from_fpstate(current->thread.fpu.fpstate);
> }
>=20
> @enter guest will allow to do some sanity checks
>=20
> In a second step:
>=20
> fpu_swap_kvm_fpu(bool enter_guest, u64 guest_needs_features) {
>         possibly_reallocate(enter_guest, guest_needs_features);

When KVM traps guest wrmsr XFD in #NM, I think KVM need allocate
fpstate buffer for full features.
Because in next vmexit, guest might have dynamic state and KVM
can be preempted before running fpu_swap_kvm_fpu().
Thus, here the current->thread.fpu.fpstate already has enough space
for saving guest.

Thanks,
Jing

>         safe_fpregs_to_fpstate(current->thread.fpu.fpstate);
>=20
>         swap(current->thread.fpu.fpstate, current->thread.fpu.guest_fpsta=
te);
>=20
>         restore_fpregs_from_fpstate(current->thread.fpu.fpstate);
>         possibly_reallocate(enter_guest, guest_needs_features); }
>=20
> @guest_needs_features is the information which you gather via guest XCR0
> and guest XFD.
>=20
> So fpu_swap_kvm_fpu() is going to be the place where reallocation happens
> and that's good enough for both cases:
>=20
> vcpu_run()
>=20
>      fpu_swap_kvm_fpu(); <- 1
>=20
>      while (...)
>            vmenter();
>=20
>      fpu_swap_kvm_fpu(); <- 2
>=20
> #1 QEMU user space used feature and has already large fpstate
>=20
> #2 Guest requires feature but has not used it yet (XCR0/XFD trapping)
>=20
> See?
>=20
> It's not only correct, it's also simple and truly beautiful.
>=20
> Thanks,
>=20
>         tglx
