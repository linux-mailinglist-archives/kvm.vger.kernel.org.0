Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEE6476E70
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 11:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbhLPKAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 05:00:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:50078 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230155AbhLPKAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 05:00:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639648805; x=1671184805;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8mdDKZXPW0U8w3h7EOJHvfYBDiPNht78ht6OQubefPU=;
  b=kNTdFC0HE2VWv0Wo2M/8bms4vm+mNHQaJFIBh0/dYqn860gbg/Ni2sSI
   J51uqt+uiH8yBc4O9uYZ/15zhF2iZTgxM9xjKcLwqt7IsC3LS9dAWlmYF
   vTRFF9aPigfVha/jGJrDp0zaGot5TWN+BLJ/gcP+W3/qfx+nYTtwyCh8z
   C/4qbtW/RnQ5W3KumcmONEiUjwO4vRruXiXcCui9KUoNT3rqctyYMJiWV
   fvSVfzsMHiXnMYxfDirowZ+qtENW8D9gYlRk7jmflynw7iNhbg70oltK0
   H7DW8iBpVmNkDAIBt7WbadLQOYjLQpjDRVHvw6uYasHy32jq+bPUTleGr
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="239265562"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="239265562"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 02:00:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465981857"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 02:00:04 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 16 Dec 2021 02:00:04 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 16 Dec 2021 02:00:03 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 16 Dec 2021 02:00:03 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 16 Dec 2021 02:00:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MqSl0sL7x32OA6J55oSR1r/F9xJzmJZohmcl3ALlbxC1YiwJB4tK3XK6e0SoGRusMUEZUM+gU5CwTNyTB1tpkuTMInUThtg03+GXJzAk0s4RoZRagIinW5AcPTB93SXBeXEP0vVjutCeYwq4DD0HyPfE4V9BxHtXVGyjI1A6849mTPqhAgSwR4EtX/c5GIhG/FVok9O2oqgG8RZsLxs4h/StggbOD8cUNLyI1UR4x0h25BarXbjfSydYlIxTVi22b+1BB+ztDKYUmFzYfCCsICtqfFHQNSROOEhrtkPjc4PpIgCy2zjv0vNv93Ye7vDcPVsK1Zacy0C2svwlP/DsFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fa6V77Dszjt44BXAq4EpPPqVoYPxlrF9sIGKEtp7PFA=;
 b=htsPgGHHLHQIIDf+mknPCZD5D/69Q/852wq3J2HUu2rBhuuCg4IDV2yNuyp4qnZ9+hsZSPiaCFeqyv80Elj1u3l0TseaYsl873Q91ob+J+47AcFAH9cPM8vlkBex4lssxbyq338V3Q9mEL5dwsgw9G4GTBH+Irj8t6s/hu7rZFiBT8TX1P0eEEpwQIBJMjOKdvS/z19/Xf5I9ZFFvW/PxS/F2WXVOc4e6tkOCaCFAOnN8Sl0rAva/POyNUUPj6v+IvCEq4Hf00WVu/nYSzXkvw1C2HKj4IBbxXhvISqquf/mhxby3/LT/Dz+lJCdIz7B5uTVOAunZYCmbmGqKmqe4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB3859.namprd11.prod.outlook.com (2603:10b6:405:83::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Thu, 16 Dec
 2021 09:59:58 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%3]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 09:59:58 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "quintela@redhat.com" <quintela@redhat.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
Subject: RE: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Topic: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Index: AQHX8JViV3rUbi5iYUCgo3JeBUJUo6wyGCEAgAAIi4CAAAi/gIAAH5YAgAAT0FyAABRSAIAAEuhSgABOroCAAIPaAIAABQ6AgADz3ECAAI+dAIAAA/xg
Date:   Thu, 16 Dec 2021 09:59:58 +0000
Message-ID: <BN9PR11MB52761B401F752514B22A23768C779@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de>
 <854480525e7f4f3baeba09ec6a864b80@intel.com> <87zgp3ry8i.ffs@tglx>
 <b3ac7ba45c984cf39783e33e0c25274d@intel.com> <87r1afrrjx.ffs@tglx>
 <87k0g7qa3t.fsf@secure.mitica> <87k0g7rkwj.ffs@tglx>
 <878rwm7tu8.fsf@secure.mitica> <afeba57f71f742b88aac3f01800086f9@intel.com>
 <878rwmrxgb.ffs@tglx> <a4fbf9f8-8876-f58c-d2b6-15add35bedd0@redhat.com>
 <BN9PR11MB5276E2165EB86520520D54FD8C779@BN9PR11MB5276.namprd11.prod.outlook.com>
 <87fsqslwph.ffs@tglx>
In-Reply-To: <87fsqslwph.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c12bde2-29d9-44d9-920a-08d9c07ad1e1
x-ms-traffictypediagnostic: BN6PR11MB3859:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB3859A2A556D33E3D4B8BC8508C779@BN6PR11MB3859.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6Z7MF4HNwU540tWzc4WjYkbPydyvn05/P+FMQNMxFveqasLx1ZqcGcPXGKhl1opNe8yl+d3CblBWLN1nKKM6crrlKcEHHoZAxymAwQ0wxHLp93USfHYdl6HLok45q3vZcsiWlJvsn3cp5TEDcDbmiA9QSM4IG0pIA3+e1uHVKkDVXcruJ0TRNv3upvZ7Wy2XM0d4lO/PJy54VKxHtDZpMskO1nMf18xaEbDfAu8H45YpUSdbCAxqSfjzesM9kftBUkGehQycx8+agb/zbDJj4JmWBqz1yO+VgAHe8/bQNbxX9YEAFeA/4O4VXs7FMvqcDZSzxw2nFtht3eH+MlGjlMdC/i/RWHMvfyudiZ05Oy7K6yQB+Twa1wmJjL7AEK9SuBddiyB+KdnGi1AxjEnxqU7g5HNTWn+0Bpyh/p/40dL0JOWMyIYdipGZcWePMwL0ap5Fw4u6+ijBTrae0oqHSGzPdbnrPu9Y/VYcosZBxBCFIFxWF8/MVkAoa0cguqYNnlkkJg5xrCdK/FboDYr8b+kpi/A9+LPVj4tPfUEYutDsxEcpPT7ukFSxruuUdEA7ChafEvZIQkjV7/rYTv6TAP9BbT75rHMcCfV0faZZFiwnHo4SfFIvbm9PV14w1MWyavfI9xqGu/+OUQvXI/qujvaYZF/yVzZGNOfhgD/clKEdAhTRj2E5j15nuI5fKlU6mjds8kZWKLAxswa7dHjCdg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(33656002)(83380400001)(186003)(64756008)(508600001)(76116006)(9686003)(66446008)(66476007)(66556008)(316002)(122000001)(55016003)(66946007)(8676002)(38100700002)(26005)(5660300002)(4326008)(2906002)(38070700005)(7696005)(82960400001)(71200400001)(8936002)(52536014)(6506007)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OSUIpuVlKY4m+3zq2hNEdukO1REIPylE0JthzvOBxieDvj2uHTnC2SE7tG3s?=
 =?us-ascii?Q?Gung8Ty/0Mu9DGw9nnzLsj19DskLAfXVjujhZyrohBMLMLnK1gF4bLXXUob7?=
 =?us-ascii?Q?zNs2DuUPzYhy9mgAZ4r+iiuofzqduaaEtGfDNsu7AGB542KuJGSC+kyKRtIU?=
 =?us-ascii?Q?/YuiC8ykznL9yNg4qIMc5mUi03yHSeN/FgQI/6gAp+wVWBVSygrf8CX6EvaO?=
 =?us-ascii?Q?cQhvuclPFUIIRMn66fDmc0+k1IVnQg9h5nesJMPf6JLtZ16kc0aR5sGaDr1/?=
 =?us-ascii?Q?FbgyYqU+au6XiGHha2bOK87a3MmOKJnbkBphmLZqnVZvFMoZUUo6P0P0WfU4?=
 =?us-ascii?Q?NxDDWP2ekM/JmP/IF8lrg4xVn3dzqMu24t6aPP6LErXoJ+Dx1iovHcQ5xzur?=
 =?us-ascii?Q?m9swvFdeOFMAQ500J/ZhOp705ZLOQSXbO57PVCG25Dbnle/84Vk9hvtJD1yY?=
 =?us-ascii?Q?0A9qA9KR0DUCziW9JCXmMAOA86noEK8P7w4fIkPGJuCREiEaws0LsToCdjzm?=
 =?us-ascii?Q?NBpY2lg1TCm6bjGuCBCbDVhwZftJSZIHUEB+IXHfh7GOsItY1pImsS2JkHB3?=
 =?us-ascii?Q?whZlGo4SeqAPgxj8eH4R5PaA1cjTdWY4xyyNiaWDh+XGpUAHbU96bF21xE3M?=
 =?us-ascii?Q?aRpflQoeeiEj2PQ7rC/bmfjBu1OE+zcLrkJeif530RfvsEchNrlGCrPFll6d?=
 =?us-ascii?Q?jjuAutmNFIrszdyyrGDLSdEqcieDdDos52cxoat4q5Drbn/C8MJ5cSHDltnW?=
 =?us-ascii?Q?YhOWCBO1JjDd6D3v61agaCzmxu2hQTUiZO59dgymlTyWE8PRhVD53TarFekM?=
 =?us-ascii?Q?+7DXA9oL83VDPcXHbs/pzTN5Jq9If8j75+VjXUOysfQA31P5wnb1Mmf2k39f?=
 =?us-ascii?Q?gWyjXqybMnayXjz4NiDK5CEzjQxeoreVKqn1AOda8VZzasqJSVBnEQH35HgR?=
 =?us-ascii?Q?ng1DIWbrovSpQegWQlq6EGfp1TcDGnnnxTm87yg4yxD+krwyW1sZuN/cVhfY?=
 =?us-ascii?Q?fGdK0h1v5fNU5hNWuHRu9i0NMBKLUxh6mQZfrraMqlAlGchG0VLSqoS7lVR/?=
 =?us-ascii?Q?WDipAxdSDOpsC79jYh6dgyWnkol6wFhBL8wbwh9j/czCi2YTjvg7MQbQYCOa?=
 =?us-ascii?Q?NRAfZyDT15S6G2U4PQ8xxv+1aE2KBrplpIKx1uqf3cW5UhtBWtjzedT686lD?=
 =?us-ascii?Q?fnPa8R68/Aocq4FgoGtGgOWbnZuv8z64MuHcDWsgzKy9hQ4JrxxH8XVOeiQO?=
 =?us-ascii?Q?6GEubzVsdxMfe7P1yDg0Somscxg+Hwqg9dT0O5/iWT3Qj1ZGLfw3QaLPCNar?=
 =?us-ascii?Q?vWpwz92dg4vW4FVbT02h555Fh6wwIdLrpS7tPTNAwCxNwp+7zI/G6zG1fd5x?=
 =?us-ascii?Q?1ToqXN3LvNpvhe0OtL6JaH41lWh+hGmVr43v+ECPsMyf2ylFm9O1+OsxDEbH?=
 =?us-ascii?Q?qnpKcckZfOdiXK2hGEPqnrzgCXeKnolQfrbZQDg7TONhfXGPCsK881ISJbRC?=
 =?us-ascii?Q?KfEjgfuxDrnQDMYNdlE09h7HVIudMTAh29tsOZ3IeCOKECqL+ujCKBOoi2ME?=
 =?us-ascii?Q?ekGKGc0zE46ODFGAunqQ6YA/i11fEzP+oMoyhk6yOvP62ba2xG+P2zdZ+PDO?=
 =?us-ascii?Q?AaEJiSZ4/sJdV1Ac4UO66xY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c12bde2-29d9-44d9-920a-08d9c07ad1e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 09:59:58.7717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MfACXszK21QSI+AxSnVsAuGDqodJyMph2LG/FmtppXq4lcipTWLtXR5QZJc8w010YVevmkFbBLYmnnxXKE7EjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3859
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Thomas Gleixner <tglx@linutronix.de>
> Sent: Thursday, December 16, 2021 5:35 PM
>=20
> On Thu, Dec 16 2021 at 01:04, Kevin Tian wrote:
> >> From: Paolo Bonzini <paolo.bonzini@gmail.com> On Behalf Of Paolo
> Bonzini
> >> Considering that in practice all Linux guests with AMX would have XFD
> >> passthrough (because if there's no prctl, Linux keeps AMX disabled in
> >> XFD), this removes the need to do all the #NM handling too.  Just make
> >
> > #NM trap is for XFD_ERR thus still required.
> >
> >> XFD passthrough if it can ever be set to a nonzero value.  This costs =
an
> >> RDMSR per vmexit even if neither the host nor the guest ever use AMX.
> >
> > Well, we can still trap WRMSR(XFD) in the start and then disable
> interception
> > after the 1st trap.
>=20
> If we go for buffer expansion at vcpu_create() or CPUID2 then I think
> you don't need a trap at all.
>=20
> XFD_ERR:  Always 0 on the host. Guest state needs to be preserved on
>           VMEXIT and restored on VMENTER
>=20
> This can be done simply with the MSR entry/exit controls. No trap
> required neither for #NM for for XFD_ERR.
>=20
> VMENTER loads guest state. VMEXIT saves guest state and loads host state
> (0)

This implies three MSR operations for every vm-exit.

With trap we only need one RDMSR in host #NM handler, one=20
RDMSR/one WRMSR exit in guest #NM handler, which are both rare.
plus one RDMSR/one WRMSR per vm-exit only if saved xfd_err is=20
non-zero which is again rare.

>=20
> XFD:     Always guest state
>=20
> So VMENTER does nothing and VMEXIT either saves guest state and the sync
> function uses the automatically saved value or you keep the sync
> function which does the rdmsrl() as is.
>=20

Yes, this is the 3rd open that I asked in another reply. The only restricti=
on
with this approach is that the sync cost is added also for legacy OS which
doesn't touch xfd at all.=20

Thanks
Kevin
