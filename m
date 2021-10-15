Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79D842F1A1
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 15:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239122AbhJONE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 09:04:27 -0400
Received: from mga14.intel.com ([192.55.52.115]:31170 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233950AbhJONEX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 09:04:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="228189679"
X-IronPort-AV: E=Sophos;i="5.85,375,1624345200"; 
   d="scan'208";a="228189679"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2021 06:02:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,375,1624345200"; 
   d="scan'208";a="592972919"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 15 Oct 2021 06:01:59 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 15 Oct 2021 06:01:59 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 15 Oct 2021 06:01:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 15 Oct 2021 06:01:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVcztrFzMjVrqtJrFygUZ45bhHfiJvx48nQ3g0X7/o0SM24dXoU7xwfmh669ksnKLFkGYyxw0Dk8VhZzjpt6Mced5mbu4G8X44N9BDEKj4cK8SNcXk7kfx0iWrAdkIVL6llca0Kq3MBAAjZdMoN2B+xq/wiAVr1Rbi5eYxDlJCz1w0Tw3B/hzFInsdXEc/VvMdK1GpXFsYvKj0uMmAcGgxSYW2jt2gWeFEJ7uQGIk1t9rgbaZAFzKel8KXepYvktUqV/LxFaPagoFUd56f30KnqK/U2B6cDkWrpZ786r2r7njBY+PY/omF9CF/8QbeNKiMGHsJHPwOfRBCBDvh64sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SWIJbjH/e75Gll/1ESZ9gyv00g+uQrZSEQxWNuHUBi4=;
 b=gfAYjGgE7FDFJd47fvqSRjOHyk6yrzHG/Xxe2KcpxJ7ejN9GUpEYrS35rPEKUPK82ZeSZIm4foGdFhqT9AGwftI6tvL7BPk1xidcL7r0ttnOHnK1+sFqqSIVHVDuhHq1VRe47G2o7o73RZLPqNAKTo0O1lqK3+UrfB2v9dGQAVqubrygFyrp6MvgvSxTxUwm5mW35GEgKfz2OmeFMlwLf2G4kJG5CrChTHEpXM3sqsUQ6baGTdmjV23iBDSyaFV2B6317nzbYOTsd/kU0Hwo++e8vhbKkMisX6j7I0XQH2mpTGwE1IjspcWRjVLqPS1g089iIvKO1zbqPJdGcXlbsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWIJbjH/e75Gll/1ESZ9gyv00g+uQrZSEQxWNuHUBi4=;
 b=xqo2g7ynyBz5URUTaSL2cZ0VcJLNgKEN1vxv5sP38z2TFkstvxUXvwgbNitv2ClOOA7PPPBXe+UR4RyVt3ESTJqHQ4bdTbZd1ToC6u48Xnhbp3U5+afRTWt4LdIX9n7w5kYAFDEVnOaKy3LE3M5BGMsjkEHq9+GwVo/MUKNtvY8=
Received: from BYAPR11MB3256.namprd11.prod.outlook.com (2603:10b6:a03:76::19)
 by SJ0PR11MB4846.namprd11.prod.outlook.com (2603:10b6:a03:2d8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 13:01:58 +0000
Received: from BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::61d4:ab77:cc62:fabf]) by BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::61d4:ab77:cc62:fabf%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 13:01:58 +0000
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
Thread-Index: AQHXv42x8Iw8v1bdT0WqN+QXiZLaIqvQcYTggAAF7ACAAAOKwIAAIoqAgABafQCAARh7AIAACH/AgAAb+oCAAFYIAIAADomAgAEsGrCAACA8AIAADjcQ
Date:   Fri, 15 Oct 2021 13:01:57 +0000
Message-ID: <BYAPR11MB3256EAFF1478F4C5D2372047A9B99@BYAPR11MB3256.namprd11.prod.outlook.com>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
 <BL0PR11MB3252511FC48E43484DE79A3CA9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
 <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com> <87wnmf66m5.ffs@tglx>
 <3997787e-402d-4b2b-0f90-4a672c77703f@redhat.com>
 <BYAPR11MB3256D90BEEDE57988CA39705A9B99@BYAPR11MB3256.namprd11.prod.outlook.com>
 <877dee5zpf.ffs@tglx>
In-Reply-To: <877dee5zpf.ffs@tglx>
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
x-ms-office365-filtering-correlation-id: b6ea43f2-c619-4228-0644-08d98fdbf88a
x-ms-traffictypediagnostic: SJ0PR11MB4846:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB4846AD72E2534A8C2ADB976BA9B99@SJ0PR11MB4846.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rl64ferkeT+O/eC5PODpw9hxJMhlY6NKQLSW7EgIw+61Nn5fG+CTo49rn5C3CTrEz/MXbU/LYCACL8Bcv21Q9YeBnUjLmDSceNq2fQwlLUNLI99wggwjWoE59kcTrrvdeeuo4rrrqkkP7cXYP+/ikPAyr3ysqNhKLAbSy6+Qb8KmY9bXhCIaWmHrtldOS8F6/0zB3kKfYPHDyDX3fDnGLcNPVpbHjgKssSVQ+lJSZJl5nDxncPXpiRL7awv0RqCxRflBVu5fjbJ1taEyv4nIDa4+Yx7mZhKNhMikRgcuyOj6ykMA5Uw2sFoh5pZLmKdhdTNw/0i9Oq0UtKyFWERn68TjbSVBpR15K6zwYAS/8QrycWZV0Hkirsp7Qi8Bos8dz5W8v0ZI1CGBaTd0B3Ri8/NlJSj2LjGz0dDuth1CpiQffqqi/sAqP61cWJZ/z7DWG70or2qFWvXd+Yyq5ewiDU5laskIUitcy/8/nATUMlpH4PuGZf0BpmXiz9rVKCiAniCHhtRZvc+1KP+JoALAL3tNlYqz1B7b/Aavs+sRPU03zYVhrQPK6xwMfPWV7jY8F4LFtiTOPR/eMUXDMIk6f+Jg9lmf74lDwgnNAIAv/gsHEniuoxzmh7N0w8D5POAv8Yiwko2E54kYvxirrlVvkqzvmExuQ5nX3uuECuOrzgfNJNxyQI+5I+VQivIAfjdaT73rXEqkS7F4l71+KAZDVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3256.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(71200400001)(38070700005)(64756008)(53546011)(316002)(66556008)(66946007)(66476007)(66446008)(76116006)(186003)(52536014)(8676002)(122000001)(38100700002)(54906003)(82960400001)(5660300002)(7416002)(110136005)(9686003)(55016002)(33656002)(86362001)(2906002)(508600001)(26005)(4326008)(6506007)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/Wd/MobNRwM+3Nf34vxfXvXjoUy06JLEQglH1H5MrptUWk9bfHiRDDcys4KW?=
 =?us-ascii?Q?khZZO9Z+5T81zvx2gCaXLeiWbVrb8ER+UqWco/2se2hQj4byA2dxB5JlnRa9?=
 =?us-ascii?Q?e/DWU7AUcEQks9Er5C9kep9p42qnBE2eHdDscRRUJIK346SQRXBjFmZ6M4wJ?=
 =?us-ascii?Q?nbvZZ3xpKTeIkwMktHsvUJfcAyk5cKFBoODn2QXofq4c8UMNZjMBCZvwcN3Z?=
 =?us-ascii?Q?ljH5iSgOSqFFvEwqmL0YoanhAqEr85rAgbERHY7ryK6CP3EtV/ckYfszcuK8?=
 =?us-ascii?Q?T3U7//bCho16oZHCPbmApVZS4BrqStwufP+KN0VSeHrkfCsXPetUkarlSlT3?=
 =?us-ascii?Q?zMx3F1/UQuzy4tSv+CAceYF3+jBApa0ITgV8llzK2qNfpYHVd3eJ8jo3P/Cv?=
 =?us-ascii?Q?XW51s+nEoAy9oEOTb6c/TQjMNj3rsXG/bz8P+HkURfoDn+LGRWtSqyR1mn+j?=
 =?us-ascii?Q?ZD922Mj5LzCMoxL7cnRf8AuZArTttNSw/+sXIpex5IKrh1MAXbxd7K9+hHGx?=
 =?us-ascii?Q?qaAPzucYZadq7a18sVVoBQW0PE6ON+a6cPvVxGSCnviIq4qo9QIAwhf7IMF1?=
 =?us-ascii?Q?Bd6OGJ72uqq4jcGPQk07XMYJhF5GfJPgJd/8fCuAHoBw8ErfwDq1OLQ+O1RY?=
 =?us-ascii?Q?ac3aGfCMivUFUioNelDnoCv/ZGst6iPCGJYY8lgV9yu+qK/+jyiB8RQ2NeTH?=
 =?us-ascii?Q?QaZvm++xUJoMcossX3dNBN4b8IVo4aNpWLbd/ksiQWoInM6zjqJGyXaZwSn/?=
 =?us-ascii?Q?WDw2DrizTALzr5P47fZbdFBmFKoJ/gcfPBz0Do8+ZRZzXeOeqRR1k8MWXJIn?=
 =?us-ascii?Q?pBDYlrafLVqrqTYolk/c0mot+71A/a2d42DwmAmaEe/Btc9TlYMW1MflqSv8?=
 =?us-ascii?Q?bPTInsozW31drSjyTWoJuqWGKBOjOqetV7Nr18As3/ECgIvLkJR+h1I+PZGh?=
 =?us-ascii?Q?TeAoEC+9RUO85WRQPUpOzD4NVo8uUQm6j+hZtg6k3m+2DQcdikvkCfHMhvLo?=
 =?us-ascii?Q?FkkGQklrS4GI1ABo0i9CxGFl7znhMvlOBLjlR7X8Kvrj/z5Z2vQ4pj4RZDbF?=
 =?us-ascii?Q?yHygqCWFKSwFHGWGq+hG40gRd7TBhFq2xOQ/aeZ45RziUODWlXx9ScbPOO2T?=
 =?us-ascii?Q?sMNmcu+ySJsSOaQui/YVWDam3XcAmgapiruRa+3ddGqGfZeXoYAsuDKpN2OB?=
 =?us-ascii?Q?XF9stqP7GdGekum+pJ6B1Oqf+2fmPxpceYdJnnrmUcAeEetuVxyJAdAL3kC9?=
 =?us-ascii?Q?abdevS9+OXx3ifbfhA+hWtdejuegdFD01+rfDqAx/YBRHZUKog9ECk63Yc2U?=
 =?us-ascii?Q?M0sNDSEC2OsISI48uzz34I2o?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3256.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6ea43f2-c619-4228-0644-08d98fdbf88a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 13:01:57.8181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bqLWY3DVkQXAS9ThUBr6OWFY+ElE3x1dFHMZ/d17lcf+KqajBUtvYOvqQb0sFkx2geTquINp9Un8j2jHCIRKvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4846
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,
On 10/15/2021 6:50 PM, Thomas Gleixner wrote:
> Jing,
>=20
> On Fri, Oct 15 2021 at 09:00, Jing2 Liu wrote:
> > On 10/14/2021 11:01 PM, Paolo Bonzini wrote:
> > For the guest dynamic state support, based on the latest discussion,
> > four copies of XFD need be cared and switched, I'd like to list as
> > follows.
>=20
> There will not be 4 copies. Read my last mail and think about the
> consequences.
>=20
Actually I saw there are fpu_init_fpstate_user(vcpu->arch.user_fpu)
and fpu_init_fpstate_user(vcpu->arch.guest_fpu) in the full series,
so I understood that we'd keep it this way. (Your last mail corrects me)

But yes, these xstate copies really make things complex and bad,
and I'm glad to do for a good clean way. I'll reply the thinking
(based on your approach below) on that thread later.


> I'm really tired of this tinkering frenzy. There is only one correct appr=
oach to
> this:

>=20
>    1) Define the requirements
>=20
>    2) Define the best trapping mechanism
>=20
>    3) Sit down, look at the existing code including the FPU rework for
>       AMX. Come up with a proper integration plan
>=20
>    4) Clean up the existing KVM FPU mess further so the integration
>       can be done smoothly
>=20
>    5) Add the required infrastructure in FPU core and KVM
>=20
>    6) Add the trapping mechanics
>=20
>    7) Enable feature
>=20
> What you are doing is looking for the quickest way to duct tape this into=
 the
> existing mess.
>=20
> That might be matching the KVM expectations, but it's not going to happen=
.
>=20
> KVM already violates all well known rules of encapsulation and just fiddl=
es in
> the guts of FPU mechanism, duplicates code in buggy ways.
>=20
> This has to stop now!
>=20

Yes, this is an opportunity to make current KVM FPU better. =20

> You are free to ignore me,
Of course I won't, because I also want to try a good way that both KVM=20
and kernel are glad to use. =20

Thanks,
Jing

 but all you are going to achieve is to delay AMX
> integration further. Seriously, I'm not even going to reply to anything w=
hich is
> not based on the above approach.
>=20
> I'm sure you can figure out at which point we are at the moment.
>=20
> Thanks,
>=20
>         tglx

