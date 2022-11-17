Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B110D62D1C5
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 04:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbiKQDhu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 22:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232905AbiKQDhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 22:37:48 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B3553EF0;
        Wed, 16 Nov 2022 19:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668656267; x=1700192267;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=orK1bULw9Zlxy1Moo+nWrDNHM7pV29EPHix0E39r7ng=;
  b=fuZH7gMtF/E358cpdZ/Q519mH92VL2p2PX1OeGeqYQcAesOEm0z2PIxR
   JyN68cMTy5FS+papuxpTNXpKnWcDBdroMKLxj35X4C9B8uJznONvw7f6H
   6vO6fZyD/fVOV+eUgmYhiDnWDFc7MMvsJEnmsfwbgrzKkd3k6WSEtcNJG
   yqOAO0xptxmfq3x4l6NcjYAbuhtAXviL2XlgiU7BW+yJ90IZv40pE2rZO
   n/MBxOf6QcAx65391GwSVLbb6HaEkHNTEHf8nbnYZEnZMnByi94sYWGjZ
   tMHQiMlD9ynSVmoWqnPRllIS8qDAbMxb2xmICJ5XePhkvl3FkT6MRendG
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="339568544"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="339568544"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 19:37:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="814352996"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="814352996"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 16 Nov 2022 19:37:47 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 19:37:47 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 16 Nov 2022 19:37:47 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 16 Nov 2022 19:37:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPJmFV2WnLL6esOD/3Ik9OWJPmBoMdb9n5WC4BBeV4D9T5dwq4yirpOdSWYZwqet082C1NAtxhw5PdN/HB3s+7d5YDjNh8eSlANv+W3FiBHGLM53Gw0AyV5pV1PwcFo3E1EoqLcrSAExI5SfdthOuF3Yo/+rj2xxKwh5WSKb9H4xylKFjt/4qgPMEo53LPdMyH6ZrhWjmnRIw3qMoWDHS9ooY3Vp+bABfugPlIb79qVD4mfrO0DUEow2yRtBzGyG2raIMl4dpE+blioYbY856NzzyF31oMAloxnYGZB7mS6835zvJNgV07UPSU7jvwHnsKjGmiY3bxOxuvZl98ZvHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JUz9UaQI8kuz3KvQ2vt4I1cgu2Po2NgRLjQ2O5K3NE0=;
 b=GPvgRpnYaeIq/pXSZH3M3PDYXRzaJitsiHZtyuceYfHruAKCycpjvdfSXZcZiXE/cWg8lnTDGQqEBhmOQ70QYRkHMZR+mBVhHRTiCIfPblJRwngTe945D/Fe5aKcZ8Bd0Cj9iiC+Y1Ua0aeRqB1V3JgJR6CQXPbHWUZk4IKHbCN/65dmG7/uMg3ROlr7P/SFrhlzafmR6ovbIwcNceyxyoiktXUSbVKSaa3lc3BdX6yN3nDQWyZGs/S64uue9Ip/SNLzJdu/qjyDGLownkFJjbSpWIrPafBI2saY8p8y2hu1jtAEm3+hFLX706anraNbGjvVteZ16wE+OM+zkhBoKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM5PR1101MB2172.namprd11.prod.outlook.com (2603:10b6:4:50::12)
 by SJ2PR11MB7647.namprd11.prod.outlook.com (2603:10b6:a03:4c3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 17 Nov
 2022 03:37:41 +0000
Received: from DM5PR1101MB2172.namprd11.prod.outlook.com
 ([fe80::8100:4fe1:7c5:275a]) by DM5PR1101MB2172.namprd11.prod.outlook.com
 ([fe80::8100:4fe1:7c5:275a%11]) with mapi id 15.20.5813.019; Thu, 17 Nov 2022
 03:37:40 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Topic: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Index: AQHY9M9YytlyKV7ob0GK/oJbeBhPY6433PwAgACmfxCAAO8aAIAAL0qAgAAENoCAAAgUAIAAGnuAgAA1qHCAACERAIADuBAAgABQYICAAXpoEIAAGnIAgAK/reA=
Date:   Thu, 17 Nov 2022 03:37:40 +0000
Message-ID: <DM5PR1101MB2172D7D7BC49255DB3752802A8069@DM5PR1101MB2172.namprd11.prod.outlook.com>
References: <Y24SoNKZtj/NPSGy@hirez.programming.kicks-ass.net>
 <6097036e-063f-5175-72b2-8935b12af853@redhat.com>
 <Y24908NWCdzUNqI0@hirez.programming.kicks-ass.net>
 <6fd26a70-3774-6ae7-73ea-4653aee106f0@redhat.com>
 <Y25a0Z2tOMWYZs4j@hirez.programming.kicks-ass.net>
 <BN6PR1101MB216141A21353AB84CEA541DFA8009@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y26jkHfK9INwU7Yy@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161E8217F50D18C56E5864EA8059@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3IFo9NrAcYalBzM@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161299749E12D484DE9302BA8049@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3NZQBJugRt07udw@hirez.programming.kicks-ass.net>
In-Reply-To: <Y3NZQBJugRt07udw@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR1101MB2172:EE_|SJ2PR11MB7647:EE_
x-ms-office365-filtering-correlation-id: 03a2a8bc-1392-4634-41fb-08dac84d1478
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0Qb12Dugy5tBGicrL7f2mWUjTk7XmRb7uO1spcKPGFVWhTqKqb5fRgNpkiAtvQ7J4QNxDCR9wTw4SWP8B03Wkq+JyOuuWFB7/8QoCjp6Wj4gzTzwgsCqUXBXsH/m8Tdn6Ojt5w1H68UxMOfNhN5TSNERSJ1jnDqAKCV3tEwIpa4TyEKbjTWL+r1LoQJEgnSoroVmapuNI094ewVagYITxVGp2+Si6KCv39sPzSN5JKN1UoT3vCls9Ku7YbhFGt+O7EZv+ciREOr+tB3LljHC2+quV1SNpgQvT0W1G0V8B9dxMSes7+5SQx8kgxUTbrZVBBPwKN4c6zZBxBPRdHmtRykcfkwqieHwQ3pI9gQbYPJLfW6DGvEMn/rKLJx323UHOxDAKRQ7rPKlQVnExbbeiNPGrrNXY7dUaI70jkoWZFdebWXjUablnkC1XULgq8Ao0sdwjnu7W8QphkI95pXX8h5aK2WQswbK8aOZ/basvXR2TT9XzONznBpXrjBJAA1k3qA7Zz1Rd6xFBtyzYvPlK6/iVxgiYGICE3dc1Xu2v6a9joW1JZAowU29hCJ02gKcmHK1cRLIQHWUJ2mx8mD6E7dWCAQcd1WTrFyiqg5KBAwhyEiJcCWG3vkYWmDBZWC7yLDYq8DOEOsSm+iObIQSsA6AlaIZmV4HqZApMQvvQ91si3qjyB/dQQZuKVWWQuE/6tbCIlbJuuqeO02SMZjx3gA6CWVGyHjNIciXGBuP6JPxQv4HmVMDrNl7EDvaYJnKp8eFzkNkgbB67hnvoZZw0g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1101MB2172.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199015)(66899015)(33656002)(86362001)(38070700005)(7416002)(5660300002)(186003)(2906002)(122000001)(26005)(83380400001)(6506007)(7696005)(38100700002)(66476007)(478600001)(64756008)(66446008)(66946007)(52536014)(76116006)(316002)(8676002)(55016003)(6916009)(9686003)(71200400001)(54906003)(41300700001)(82960400001)(66556008)(4326008)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pOZ77kbfwR9m6n8740N0CLPRFE3IJXIBkPVVA2excRqkFeKtmItlCs42R4AI?=
 =?us-ascii?Q?nnPN0hnpKDLvHx8+Rfsnmk5UJLXMBI78lGGlEiULW0oStrmboLNObdWVL9Ez?=
 =?us-ascii?Q?06MOivdwTuLzRL57A/7QoS2QlbuCpEHG4C8/v55ZS/tlQYPHkif0HFsUJfpc?=
 =?us-ascii?Q?nIPNXzy96Sl/6u3aE/S9f4Pqkq/fLhQdoaKJJeUBcmZUj7Mhazk4r12Mh5pa?=
 =?us-ascii?Q?FaWyY3tPijx/qn4Uvpoih4CKY5HABX6O8bTe6bBXUeh6jIlFgYQqPq8mCeGx?=
 =?us-ascii?Q?W6C91c7MKP/FUy8o6LA64krwvA7T9zPD01zdRdbhqfCr12/r2kqvtbGTvJIt?=
 =?us-ascii?Q?P0v9oo+/345iBoz1tvgZdBLy9iADVe/t5ob0f5tEODzW19vJS+8VjpuH8bZ7?=
 =?us-ascii?Q?WdecyUGx/advlFTrBPtLecJViECb5kj5bZBnRYiWblB6HTsYkUCOK9gPnEHR?=
 =?us-ascii?Q?oQwxgRziCf+9RwLLe+fWzEPUz2qRRFkWaoEEqF+VLaCePNPQb27vhCAwogRT?=
 =?us-ascii?Q?5KlkuuFz3i82SLgbNvATKFj1Ru78Md0oMOaQQPdF9Icey1YTqUFIqFqCFTnb?=
 =?us-ascii?Q?wSa46SGrOMX0PVmR9gosquBox19YWDugdSoHgTUhL1JPicuJ1rCBGehO+7KJ?=
 =?us-ascii?Q?G+y8CTwo7Dl0jq1nDZbvbYmBfyjJ0IPmm3IMYixt4+AkcnHqeMm6zETmWxZS?=
 =?us-ascii?Q?8y0BKBl6XrlkGQP4ne6reiD49tnTuFAHEaNvK8OfMZIiMzAQlDKsxUGNQO6I?=
 =?us-ascii?Q?cwvFlyw75cycgfbQQYu9NNz32HOgndOntI/fD84LAaT+sGopmNUih+ScYOvJ?=
 =?us-ascii?Q?BTBVxnCZV/0nIrAe29Bc5C2PC9eB5kLozVUq84HPSLa2fx+cBl5B/Drfe3YX?=
 =?us-ascii?Q?etJeM5DVNAN84HwwYPgMGoQuwVVocMlPN6YfZdc1W571kpURfUSFsyi4K2fB?=
 =?us-ascii?Q?ZRXJm/lRoM8tcNLMKEYuzR55HQF7oOZ8qBOq8XwajC5Dv1X0V5aTucO9T3VU?=
 =?us-ascii?Q?gWfX9PwZ08oUQxkS4ArftfV0sGJmfbZwuuqoovFvlKeTODE/byQIEZRy81qY?=
 =?us-ascii?Q?OTCZ8qI2H6yWPc27r09Yg56gkAhk4e76nme/kegCUcueRmdA33M8jSONWNQH?=
 =?us-ascii?Q?c6ajoHUKTOKorKcDaOnkCchKljovykVfeRot5YgXOS7mQVVf63SXOkRTWClV?=
 =?us-ascii?Q?GgYRaSAgIWxiTmZmH9so1f6tR2wi+ZSSN6aun7zdDyACZIAAMsAxZVEczxLp?=
 =?us-ascii?Q?hWe9FQsvKRYrn1iOzy0w9rAg7oGqlWE2Z1SjDI6tACtT+ELSIdsZxxK9IZI1?=
 =?us-ascii?Q?lZykE8h9kj+blHVJleKOvOkK4Vugc9stZnX54YunMWHZ9FxISiWxIslmln1b?=
 =?us-ascii?Q?8HpIaajhw5f7Js+pVOoWjiV9f9WWZE3xIu/cf1qOfItVW1O1cDGgOB31lrHY?=
 =?us-ascii?Q?W9pok8+ZUB5ZbgkRKpvWySrBe9lg2OKP5AJmx478Pf/NwS+lmm/1Ugf3GKEZ?=
 =?us-ascii?Q?KsHX1VxDLlzdYI7KJT93Gb72ErQ3E8hZhDmrc6ZmavVSkJqb7V+H7HG4IHpY?=
 =?us-ascii?Q?lIu9HPgi63M4RM7kv5k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1101MB2172.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03a2a8bc-1392-4634-41fb-08dac84d1478
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2022 03:37:40.7652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 55OuwNiX8/qepFbN2iDSEyYCu8IL2sgRjaBEnDNFPEsfr7D+/P3Ch64zou4DqxOQ5LXoy8maX1GrwRB0aoqvRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7647
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> > > > > But what about NMIs, afaict this is all horribly broken for NMIs.
> > > > >
> > > > > So the whole VMX thing latches the NMI (which stops NMI
> > > > > recursion),
> > > right?
> > > > >
> > > > > But then you drop out of noinstr code, which means any random
> > > > > exception can happen (kprobes #BP, hw_breakpoint #DB, or even
> > > > > #PF due to random nonsense like *SAN). This exception will do
> > > > > IRET and clear the NMI latch, all before you get to run any of th=
e NMI
> code.
> > > >
> > > > What you said here implies that we have this problem in the existin=
g
> code.
> > > > Because a fake iret stack is created to call the NMI handler in
> > > > the IDT NMI descriptor, which lastly executes the IRET instruction.
> > >
> > > I can't follow; of course the IDT handler terminates with IRET, it ha=
s to no?
> >
> > With FRED, ERETS/ERETU replace IRET, and use bit 28 of the popped CS
> > field to control whether to unblock NMI. If bit 28 of the field (above
> > the selector) is 1, ERETS/ERETU unblocks NMIs.
>=20
> Yes, I know that. It is one of the many improvements FRED brings.
> Ideally the IBT WAIT-FOR-ENDBR state also gets squirreled away in the
> hardware exception frame, but that's still up in the air I believe :/
>=20
> Anyway.. given there is interrupt priority and NMI is pretty much on top =
of
> everything else the reinject crap *should* run NMI first. That way NMI ru=
ns
> with the latch disabled and whatever other pending interrupts will run la=
ter.
>=20
> But that all is still broken because afaict the current code also leaves =
noinstr --
> and once you leave noinstr (or use a static_key, static_call or anything =
else that
> *can* change at runtime) you can't guarantee nothing.

For NMI, HPA asked me to use "int $2", as it switches to the NMI IST stack =
to
execute the NMI handler, essentially like how HW deals with a NMI in host. =
and
I tested it with NMI watchdog, it looks working fine.

For IRQs, we still use the dispatch table, but with a new func added in
DEFINE_IDTENTRY_SYSVEC with the noinstr entry/exit code removed:

#define DEFINE_IDTENTRY_SYSVEC(func)                                    \
static void __##func(struct pt_regs *regs);                             \
                                                                        \
__visible noinstr void func(struct pt_regs *regs)                       \
{                                                                       \
        irqentry_state_t state =3D irqentry_enter(regs);                  \
                                                                        \
        instrumentation_begin();                                        \
        kvm_set_cpu_l1tf_flush_l1d();                                   \
        run_sysvec_on_irqstack_cond(__##func, regs);                    \
        instrumentation_end();                                          \
        irqentry_exit(regs, state);                                     \
}                                                                       \
                                                                        \
+void dispatch_table_##func(struct pt_regs *regs)                        \
+{                                                                       \
+        kvm_set_cpu_l1tf_flush_l1d();                                   \
+        run_sysvec_on_irqstack_cond(__##func, regs);                    \
+}
+                                                                       \
                                                                        \
static noinline void __##func(struct pt_regs *regs)

How do you think?
