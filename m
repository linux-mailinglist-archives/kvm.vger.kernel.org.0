Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740F55F84A0
	for <lists+kvm@lfdr.de>; Sat,  8 Oct 2022 11:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiJHJkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Oct 2022 05:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiJHJkn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Oct 2022 05:40:43 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0305950F93;
        Sat,  8 Oct 2022 02:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665222040; x=1696758040;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yn7jXIcB541xXL472VHjNqLOc4o1ZOnNNDUEj/9T55A=;
  b=DFtQ3k6gqCVbIljVsQClYY7HMsIzWWadynxpmZOjSYxIXBeNffioN5ll
   TtPxekidYS9a8nFjSEUYP0axlgN0na4iJhlPbaQ3X074d8GoBYLWX84S4
   6A4EmRYqhN5dHpFpNHMlKhtnXFcAGMAZ1piX0dz5nncPKTt2FvCV3gjtc
   isqhqM0dj2U08+VWcogSEMbohrJuP3P9qWNm44kgFgqlux235+qmseZeN
   BHTAHu13l7lGhiLIm2c6IfAX5Xxsmve1GMIBXN8PW5HKFsaZnhvwcgVJG
   NX827z6VNrVuinmEJVJjQvvlkQfI5ZouC8MdjrzNZbvoZbxqbq4zZfKTb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10493"; a="301521885"
X-IronPort-AV: E=Sophos;i="5.95,169,1661842800"; 
   d="scan'208";a="301521885"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2022 02:40:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10493"; a="658618641"
X-IronPort-AV: E=Sophos;i="5.95,169,1661842800"; 
   d="scan'208";a="658618641"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 08 Oct 2022 02:40:40 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 8 Oct 2022 02:40:39 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sat, 8 Oct 2022 02:40:39 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sat, 8 Oct 2022 02:40:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bYaNvnfcXfVA/l52ZH+wZezUbq0vJFtgL2AuGFXNWfb404FFMTxr7kJxpCBvSDlLTJP0o0AMjMZ14K8Eu0ov3Rcf/NThi1zyDw+kpoupFRXA3A6n3Cj8363kRnraux1erAh6Kz0h+2bDgDYdAggz9kg9NxzOKktaAYAuaIGZLZtIi6lBoTj2rNFoqQRTGHhyFIC35lwt2LZIayBR3vtFZ+dVyX67bO21mzbbOo5dP2BC3sFbARJagagBUF/PmYLW46Wn9sOd12uSmd3MS3bjrFiYCHe0EqSvDPJBGbWET2b5GIELoHRKEVlzVOCRzwZnpuouRYGxZiSphJ5lCNueAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pbfHWjmcq3fK4UEgBQO3h2cgTiGqh2zyaDIt0yCsVzg=;
 b=F7qMRH5zCD1q9wnzLw4HyufJPI4iGmD95EZmuh5ScwaFS9A5EyQeGY/fXoC9eHxBbFw0quSncQHueq6/ZOjx4EAfrBtS51AM8bA3Yaaici+5FVdOnmwll2zoarqLG4uSbbGIGhF8DcqCVK1j6z+a/T8tvP0j/SMAwg67HAdh99blQ4eLRmORcbwhgzJOsZ4OA6UryF+JcdpDiYwj3uMisDhUqEBGqQUkzb6a84Zhh/PCDJDAbffmcG4uPIHcE64/dB07TY5c8iR0+Yh9l/9FfzDVNXP9Ws4dxCo5YApyBKMV7wHyvvzvtZO7916vrL5/ps3zepx7uit3rBiybDerLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB4824.namprd11.prod.outlook.com (2603:10b6:510:38::13)
 by CH0PR11MB5690.namprd11.prod.outlook.com (2603:10b6:610:ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Sat, 8 Oct
 2022 09:40:32 +0000
Received: from PH0PR11MB4824.namprd11.prod.outlook.com
 ([fe80::45fe:4dc1:9faa:921b]) by PH0PR11MB4824.namprd11.prod.outlook.com
 ([fe80::45fe:4dc1:9faa:921b%3]) with mapi id 15.20.5676.033; Sat, 8 Oct 2022
 09:40:32 +0000
From:   "Mi, Dapeng1" <dapeng1.mi@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>
Subject: RE: [PATCH] KVM: x86: disable halt polling when powersave governor is
 used
Thread-Topic: [PATCH] KVM: x86: disable halt polling when powersave governor
 is used
Thread-Index: AQHYyNSFRsRhvKGUt0S7LgkC+L5J3K4DWToAgADh46A=
Date:   Sat, 8 Oct 2022 09:40:32 +0000
Message-ID: <PH0PR11MB48240C29F1DEBC79EA933285CD5E9@PH0PR11MB4824.namprd11.prod.outlook.com>
References: <20220915073121.1038840-1-dapeng1.mi@intel.com>
 <Y0BnKIW+7sqJbTyY@google.com>
In-Reply-To: <Y0BnKIW+7sqJbTyY@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB4824:EE_|CH0PR11MB5690:EE_
x-ms-office365-filtering-correlation-id: df57910a-812f-4fb6-45bc-08daa91124b9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZKzfWsb4GZtUouX23mWcWWSP48q9s8guPKGsE9bqRfgKAckxtF6jC8q9GxqDKmmeJQsirak1CuOQ+d/pOrtBNio0ne7NL3Ut+R0msNJEKtY0i5tnMh2Evjt92oa87jKG8ozzRGd7WM09Qm1SjDYWae0jyVBlwjzY/MWj4BmQDhPcLDjvDqXtPhFs0IvP3pSFSgfW2k1opoAT9PN4E4pwMB9anlUiyyIYWrMv+Piogsjyv1R9Ny2DCsdkkRJDS+gbjQKaYY9tRivwVPfzx5if20+phD0AQeSw85UnmIulY23MRq/98fDX9uwsWgYS8sQ3ACbwEHvi3wYmgBxlrNrx7uHnIIKnQ4SSzAJUsEwmoWjp03qeJ7vtnG3/frDr3bBPqzzrg+dWZrTowIRtK92TaXK14P0K4OYcfW77wbsJtUimmT1NUSACvLDQZY2PY4NlE/CNGKu537rm+xqxvSorqFh6PywC/5lmJlkwIPyo66MvP1Phl7asK0WJlJsmIwHfqX0AIgPRP8aYr36OCNt9+iZuKmtC5DGqV3W2Fk/hsMoFn0Vklo4ge6ZxIv4ndEI+EraXm4rdDcW/g4i5cAMDI6Pgc6ofBh5+go0HLhjkU8N/FXEfB/040vxiw1DPSKiU/klwWTwRJk77eUwlgW9GDfwSzmJIC6U135U3TqRKUk7XoQgCfURl6Hel40HjRSuKDfr0IECoKyA7a87i9Gxg3EASs4gsPMXb0nKlHNAcKzth3/0qfjg4mXy0Kmn3rVzd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(366004)(376002)(39860400002)(451199015)(8936002)(52536014)(5660300002)(41300700001)(2906002)(38100700002)(33656002)(53546011)(82960400001)(186003)(4326008)(316002)(6916009)(54906003)(76116006)(64756008)(122000001)(38070700005)(66476007)(55016003)(66556008)(66446008)(86362001)(8676002)(83380400001)(478600001)(26005)(6506007)(66946007)(7696005)(9686003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dIO0z28TILTcs1YYn/d01CXyoH2Fj3lgg9yk8XPwGbx0fR8mrAmcTDbd51Lq?=
 =?us-ascii?Q?n4em1iGblWOhT8+YBOUKjaFmv4Bn0enmAyJaFFkT2OqZTgpzQKCHdLFEV2AI?=
 =?us-ascii?Q?+Kk2g8ih90LAaegmcNVaiqAkSzAJEULKafW17B0IzPdXo3UWJrZWbn2AOLA8?=
 =?us-ascii?Q?QPHgWcFDCfCbJrAcSncmWOYH8bm84nkyWDhpPXC+jeXsM81Tg/fgQbukGCLF?=
 =?us-ascii?Q?sQRfKdLcyLM6gZRt5JSXW8x+ajTpmi5mTD9ww29/Y/cg/q/cL/2+IHJkM+hH?=
 =?us-ascii?Q?KYmNmAay7x0V4aTu0ONTch20SNcDMrSk1jXeOIxqhYDf1qF/SAMyWCzp75wq?=
 =?us-ascii?Q?XxxNA8VymYj2InNSFjVoV8wNfqqQPzn0X50Ahsdw419uzVCeUmJK6AKBVStc?=
 =?us-ascii?Q?N8mza883CiQpv5o2k+BuB4bNd8ugy6ygZysjMYa6WN+r9CbfcapDad0xz25c?=
 =?us-ascii?Q?WMYpPy1BMREW9C/9OmmwuRKYQn1BF5iNmzAB+VIrwxVpAGPeYFMC4pcyIpBx?=
 =?us-ascii?Q?2/5BHUZBlkSnVnwjoM/25iovTciOuPE/Rx89MmYP/78wV1TEZ+y3dxng/CL7?=
 =?us-ascii?Q?0wTEzwxpaobfv8T40IkjnIo6fynIWpiVd/Xak6SQd/AaobBSNrfubMkNgTbw?=
 =?us-ascii?Q?AfANZTlru/aWmSAUyhhFX0vtGzY8JOiP2g5q5z9AIfPNjX5jfmnfP0LkepDN?=
 =?us-ascii?Q?6oHZIDYZIMO9bQZpzmS4wrxyDvE/vSyBNmx5gJlAQai8a3rf6w1skPY7vKfs?=
 =?us-ascii?Q?pa7vBXAhHIa3BcUCMpmykXYKcKlajVdmlJVQiukR9DJHAUywfNkVNS+do3KP?=
 =?us-ascii?Q?Qd7h/+2vqnsicxjaWiryZfnxKNa1GiC4H2dcwFmwsQM8Au8PR2uhslyY2MZ9?=
 =?us-ascii?Q?amtBlxlJozMBcNVfXkrXytG7uIfaijtTlE+YzGB9iwlMI46/4K1/zOqgY0vh?=
 =?us-ascii?Q?2043VfdY5sMIqZZgwCakCe0mnqJODeX+EI1FxpHHiaaV/j7Keo7FB/d8zq07?=
 =?us-ascii?Q?FxPOGkwRLhVTxl55AOOzwbn7hERm3bvK0P/JGBIo9K9sevwGN1tDtswx8c73?=
 =?us-ascii?Q?1Tt0tf997pn05Px8NFK/3DUot9bKBVuWn5/BwD48Enbwt1EuXdKoU1CP/ARu?=
 =?us-ascii?Q?eTQgaqCnvrFtptviz11jguilZqSo+s6lj/7NWMVCLWofudrLqBuYaMyfqMvK?=
 =?us-ascii?Q?UazWElkz4DfRChUEVlduYXcKadlLc66+01DINeBEhCfHx39MkwzffVIEWBRC?=
 =?us-ascii?Q?GgYNkOcwQBzd6zzECNQU/W7lmeYC8DpTqLpZn/FEgUXabngwufNihWS026i2?=
 =?us-ascii?Q?GagDUsbnwb9xhbyWukX1Due9dr1KDFpc7CR5Ej11kBG1MpeQMYE5DDt80BnT?=
 =?us-ascii?Q?eCi3ATVyT9aE+Tdv1g4kUuVuB8NvySlfBuYT4OFW+ISukIqzxn+eY2Xr2qmh?=
 =?us-ascii?Q?pQXDh0QOfIp33OZ3mMYoJPUb7FJnFv3yH5YNqAvmhFvKQcZkxElDAi6TL01X?=
 =?us-ascii?Q?IE244bIDYmCPLN1K0/TLVLfhyWv5ixbUGb1AJ2AUWmIgiFik0aKpwnoth5H+?=
 =?us-ascii?Q?KUsJ39WZ25d6dfZUicCmAziEyNxatP3CokPlShQ4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df57910a-812f-4fb6-45bc-08daa91124b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2022 09:40:32.1381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 08kY3G/OCOGebsypwlTl54vtgaizNC/0cML506tVOuFKrxmSW/2TrFssbyu1qY0huzYYZdQ3EssCv1rr8zC1bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5690
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Sean Christopherson <seanjc@google.com>
> Sent: Saturday, October 8, 2022 1:52 AM
> To: Mi, Dapeng1 <dapeng1.mi@intel.com>
> Cc: pbonzini@redhat.com; tglx@linutronix.de; mingo@redhat.com;
> dave.hansen@linux.intel.com; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; zhenyuw@linux.intel.com
> Subject: Re: [PATCH] KVM: x86: disable halt polling when powersave govern=
or is
> used
>=20
> On Thu, Sep 15, 2022, Dapeng Mi wrote:
> > Halt polling is enabled by default even through the CPU frequency
> > governor is configured to powersave. Generally halt polling would
> > consume extra power and this's not identical with the intent of
> > powersave governor.
> >
> > disabling halt polling in powersave governor can save the precious
> > power in power critical case.
> >
> > FIO random read test on Alder Lake platform shows halt polling
> > occupies ~17% CPU utilization and consume 7% extra CPU power.
> > After disabling halt polling, CPU has more chance to enter deeper
> > C-states (C1E%: 25.3% -> 33.4%, C10%: 4.4% -> 17.4%).
> >
> > On Alder Lake platform, we don't find there are obvious performance
> > downgrade after disabling halt polling on FIO and Netperf cases.
> > Netperf UDP_RR case runs from two VMs locate on two different physical
> > machines.
> >
> > FIO(MB/s)	Base	Disable-halt-polling	Delta%
> > Rand-read	432.6	436.3			0.8%
> >
> > Netperf		Base	Disable-halt-polling	Delta%
> > UDP_RR          509.8	508.5			-0.3%
> >
> > Signed-off-by: Dapeng Mi <dapeng1.mi@intel.com>
> > ---
> >  arch/x86/kvm/x86.c | 17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c index
> > d7374d768296..c0eb6574cbbb 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -13015,7 +13015,22 @@ bool kvm_vector_hashing_enabled(void)
> >
> >  bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)  {
> > -	return (vcpu->arch.msr_kvm_poll_control & 1) =3D=3D 0;
> > +	struct cpufreq_policy *policy =3D cpufreq_cpu_get(vcpu->cpu);
>=20
> Preemption is not disabled at this point, which means that using vcpu->cp=
u is
> potentially unsafe.  Given that cpufreq is refcounting the returned objec=
t, I gotta
> imaging get migrated to a different pCPU would be problematic.

Thanks for pointing this. Per my learning, even vCPU migrates to a differen=
t pCPU in the
progress of getting the cpufreq policy, the only consequence is to get an o=
utdated (maybe=20
inaccurate) policy value. Halt polling mechanism still can get the updated =
and correct cpufreq
policy in next time. And even we disable preemption in the process of obtai=
ning cpufreq policy,
the vCPU is still possible to be migrated a different pCPU after enabling p=
reemption and before
calling the halt polling judging logic.

>=20
> > +	bool powersave =3D false;
>=20
> I don't see anything in here that's x86 specific.  Unless I'm missing som=
ething,
> this belongs in common KVM.
>=20

Yes, this is generic.=20

> > +
> > +	/*
> > +	 * Halt polling could consume much CPU power, if CPU frequency
> > +	 * governor is set to "powersave", disable halt polling.
> > +	 */
> > +	if (policy) {
> > +		if ((policy->policy =3D=3D CPUFREQ_POLICY_POWERSAVE) ||
> > +			(policy->governor &&
>=20
> Indentation is messed up.

Sure. Would change.

>=20
> > +				!strncmp(policy->governor->name,
> "powersave",
>=20
> KVM should not be comparing magic strings.  If the cpufreq subsystem can'=
t get
> policy->policy right, then that needs to be fixed.

Yeah, using magic strings looks a little bit strange, but this is what is c=
pufreq doing.
Currently cpufreq mechanism supports two kinds of drivers, one is the drive=
r which has
the built-in governor, like intel_pstate driver. For this kind of driver, t=
he cpufreq governor
is saved in the policy->policy field. The other is the traditional driver w=
hich is independent
with cpufreq governor and the cpufreq governor type is saved in the governo=
r->name field.
For the second kind of cpufreq driver, the policy->policy field is meaningl=
ess and we have to
read the governor name.=20

>=20
> > +					CPUFREQ_NAME_LEN)))
> > +			powersave =3D true;
> > +		cpufreq_cpu_put(policy);
> > +	}
> > +	return ((vcpu->arch.msr_kvm_poll_control & 1) =3D=3D 0) || powersave;
>=20
> Doing all of the above work if polling is disabled is silly.

Correct. Would change.=20

>=20
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
>=20
> All in all, _if_ we want to do this automatically and not let userspace d=
ecide how
> to manage powersave vs. halt-poll, I think this should be more like:

Thanks for your sample. Would change in V2 patch.=20

>=20
> ---
>  virt/kvm/kvm_main.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
>=20
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c index
> e30f1b4ecfa5..01116859cb31 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -29,6 +29,7 @@
>  #include <linux/file.h>
>  #include <linux/syscore_ops.h>
>  #include <linux/cpu.h>
> +#include <linux/cpufreq.h>
>  #include <linux/sched/signal.h>
>  #include <linux/sched/mm.h>
>  #include <linux/sched/stat.h>
> @@ -3483,6 +3484,23 @@ static inline void update_halt_poll_stats(struct
> kvm_vcpu *vcpu, ktime_t start,
>  	}
>  }
>=20
> +static bool kvm_cpufreq_no_halt_poll(struct kvm_vcpu *vcpu) {
> +	struct cpufreq_policy *policy;
> +	bool powersave =3D false;
> +
> +	preempt_disable();
> +
> +	policy =3D cpufreq_cpu_get(vcpu->cpu);
> +	if (policy) {
> +		powersave =3D (policy->policy =3D=3D CPUFREQ_POLICY_POWERSAVE);
> +		cpufreq_cpu_put(policy);
> +	}
> +
> +	preempt_enable();
> +	return powersave;
> +}
> +
>  /*
>   * Emulate a vCPU halt condition, e.g. HLT on x86, WFI on arm, etc...  I=
f halt
>   * polling is enabled, busy wait for a short time before blocking to avo=
id the
> @@ -3491,7 +3509,8 @@ static inline void update_halt_poll_stats(struct
> kvm_vcpu *vcpu, ktime_t start,
>   */
>  void kvm_vcpu_halt(struct kvm_vcpu *vcpu)  {
> -	bool halt_poll_allowed =3D !kvm_arch_no_poll(vcpu);
> +	const bool halt_poll_allowed =3D !kvm_arch_no_poll(vcpu) &&
> +				       !kvm_cpufreq_no_halt_poll(vcpu);
>  	bool do_halt_poll =3D halt_poll_allowed && vcpu->halt_poll_ns;
>  	ktime_t start, cur, poll_end;
>  	bool waited =3D false;
>=20
> base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
> --

