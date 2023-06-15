Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62413730DCA
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 05:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238271AbjFOD4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 23:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjFODzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 23:55:47 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AC42130
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 20:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686801345; x=1718337345;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9HVh19T/xrssGO0M38LxYkdXFGBa+4hTIqfPloLZATU=;
  b=jzwEKyBdtOCbdOihB/o1w71INHXLALBm1uNqExCnCu6Aiki0RW/ODEUB
   9WXDjiPHZuJQBKDbI81QfhvzuMVmAdfit2v3qpxtpcKN2mELOenuhsaKD
   VOjj6fkUsKkgmvHJUyr7DO6Lz4D8qb9zXAFJwzCnSVyOhrn+COrPfjoTL
   BcM9aKhxOsnJ4LEPFcw4XYHjrL7JYa4mrgZctNe5CjdDjK3pn1Sm9B1zy
   w6xsE+pyZhOKXgXGNFIeh5WCkyMVe//eoeRllkQSasDKzrHROfkTefOUe
   xRl5OT+ZZxZyEXDNPhD9TAEQKghO/DYz2AbbBuoW5uV7JHKxrBGxv86Nw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="362184553"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="362184553"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 20:55:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="662627831"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="662627831"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 14 Jun 2023 20:55:44 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 20:55:44 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 20:55:44 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 20:55:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNZuF7Xz+zzCRC+0Lfnhu0km+HUcW4eyi2Loh14xO50Ut4BDOTeokSkMMYegUicp7kFy8dN+79uspop4ZC22kS+8FvDyvaSCacSlHF5qDthPU72qSUGS908XiIoAdStr5cVopVbcUA1hE9tUCYueBiPTIb8xjWQBOhqw83f1uqeKzArEIC9ZCD96BixkebNQuBgOkdhhnCduO4XEh+t6+mCNeS8JkkKichAnMzYgme58xFyzea+YzlIR+FChiuSRNOqkgiKnpLYxobsRCkICjHl+D7drG55sdO9RJixwnbLT2KhFO6wDW3QTSRi80+25oj/ZyS2kfB6lr1PWd4sxYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cpBjlUGrunxgFf9lx47tP6hN76TGKJc3HOINvuj2VcY=;
 b=eLekLcacW6O3idCJcm57c/9+cnP22NCiSPH5hZDBLnXBYW3UB7A/ncgB8pKQjzhiunWljI4aDgsQjneGdiOxYOgmxAPoBrLV2W/tt73f9tfUlIxnLBQRCUi0uMvBmpneGU2vhxx3nxoOk7WXjmpJv+hEYtmnZ8fAJRUojORy4ufJWLJtX2jUKJj/mlE5jUwEC563blbpkUMDiL66LM8zTm4BWd1aSsktpdF8i1/W5s7X2pxQct2hjBJ/CYEuHmi25mBPW021acc4V3wuk0E24FGzAc+fvyQZLJUgKspM6g4K3mo3BSLZJGB3cUZ5tLVhLmo/PrMJtYRG7Vug2wsoTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 DS7PR11MB6294.namprd11.prod.outlook.com (2603:10b6:8:96::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.46; Thu, 15 Jun 2023 03:55:40 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::e8f3:851f:3ddc:fdeb]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::e8f3:851f:3ddc:fdeb%7]) with mapi id 15.20.6477.028; Thu, 15 Jun 2023
 03:55:40 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        Anish Moorthy <amoorthy@google.com>
CC:     "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "robert.hoo.linux@gmail.com" <robert.hoo.linux@gmail.com>,
        "jthoughton@google.com" <jthoughton@google.com>,
        "bgardon@google.com" <bgardon@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "ricarkol@google.com" <ricarkol@google.com>,
        "axelrasmussen@google.com" <axelrasmussen@google.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "nadav.amit@gmail.com" <nadav.amit@gmail.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: RE: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without
 implementation
Thread-Topic: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without
 implementation
Thread-Index: AQHZlW423muHblFfrkaOENvhBA1a26+K4T0AgABrGqA=
Date:   Thu, 15 Jun 2023 03:55:39 +0000
Message-ID: <DS0PR11MB6373969DA5CCDD6EBBC9CB7ADC5BA@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20230602161921.208564-1-amoorthy@google.com>
 <20230602161921.208564-10-amoorthy@google.com> <ZIovIBVLIM69E5Bo@google.com>
In-Reply-To: <ZIovIBVLIM69E5Bo@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|DS7PR11MB6294:EE_
x-ms-office365-filtering-correlation-id: 424ebe64-2fb0-4f03-69c1-08db6d546247
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iYESQlWd64zIyahhoc9kAeN8g/+rt6M1RlhGrbqS+Z5zVT8kPJ7TK0JCxc10l/P3BsQ8l1D9mNaUls3YVjx6216kl8xsofuijArOR4SBph3okeAjs22a71zgtflRd07yMTQswhh6yQJz/Bh7k/RvwjB/dzIO77JNGcsW1u9kbMar5Fec89vMFx3tYCqM/JQTmfLG2p2mL+8TWtXovi15K8/mLPBZ7a3+daNHo5xpage+aEdU/hA2N4KIUl7GK6xpY7NaVKUfM04ODKhCP/idWabSyqO23AC7smi/G4h+Ns5J7mqsunMp7n7rCXfx70qzIKMJGUNwrYl/49yAdnFKIpAx1uTM+4iFhjUWdpWFBlMtW3PnzUmRjXk7N/KfprjSwKnBHZtcYKJkInuvBE0/ZGcRIea3I4bVOXncV7lvXvxrISYoTkCtuh1YhWFXmaPYQDqGjgLwLgSnvfc4E8Wt7pNhgMsZEVn3FEXYB4b8/QCfu/9Rxc0+zP8CRhkLzmn2FiM5TlynZQgZIkh2tzePPk+QuL33KEEG+Z/Nz7r4kPcVBOkxJwRrhTXIyrRZnEleKxbmeCodXuv0OEeKrPDfDnrCFpFDMz/dN0OWFj9oNFTzzQ5kd4UbQDuZndm7LJrJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199021)(186003)(26005)(53546011)(9686003)(6506007)(41300700001)(38100700002)(316002)(7696005)(83380400001)(52536014)(33656002)(110136005)(478600001)(71200400001)(5660300002)(54906003)(86362001)(38070700005)(2906002)(8676002)(7416002)(8936002)(82960400001)(122000001)(66556008)(76116006)(64756008)(4326008)(55016003)(66946007)(66476007)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1iA/QCoyYYc80y6M1mTRmfR0VLFQW4lnmuS5eujgV+429kedkCEzPtnRhdsw?=
 =?us-ascii?Q?tfgbXMSQmxfMa64hToLS5A3/lrrLGPGq7T2GTufHCKdLuo9Uo3YTap+Eh3T3?=
 =?us-ascii?Q?ElBJk5dhLARyVMVDXr7VbmhAIcfSTcEZwYDKFCMogG0f4wU0edSCrz91spxo?=
 =?us-ascii?Q?QWuPsQ7O96Bu8X6xSf8A6fLGi9e87BCPh+n1grX/dlRZFuPM6KspHOIfqOQa?=
 =?us-ascii?Q?c/ayDobQXO+Y+8Ot8xhT7BmLtCOQPYEhg5nOfyKDFgnakONSptCldh0nu2ho?=
 =?us-ascii?Q?ZR48oC7yLA7mWvmrCrso9G+cZBZtdUsvX4kqQlaq8P5ePJzCIqYNrZvZJEwG?=
 =?us-ascii?Q?W6lnUWbfcZ1xz8IVQo2Glq3Oi/ywGNmZ9KvXoo462cyHf/QQJTSahbTF3J73?=
 =?us-ascii?Q?qQQpn7jSYu/CIzipCoADlOVsodTW8FMESyGiBv0RSgc5zaRhagQnbPnjfP39?=
 =?us-ascii?Q?xcnJFmWk+4pmNU3lpafN0IzPsLmjiG2Jpy/bLfU1aEIfTiYyzxrUZUBwdqBV?=
 =?us-ascii?Q?I14auTwVcoFLYybuoEly/92jFki6fkdIplrHqR596kzYXU1lvD21SP1BsHO+?=
 =?us-ascii?Q?mw8hlsVjXIvsxka5+WgeeIddV4e0pjORgiGO2THEv+JZajfQAmelxSmDsTXC?=
 =?us-ascii?Q?hrR7eFQJvEhwNA2eEGdAQDHcxtbUJAClvpkCbfln9aRJ8cidqsA62TTl/urz?=
 =?us-ascii?Q?N3MVSXyF5bXBABIPkhHZ6SGT3vBayZdxK4z3ZNhHxGdTRPhp481M2F27Pj6G?=
 =?us-ascii?Q?vB93oqfc/wD/1QkzAbroejWo6d840YNGyk8j23SPId/eIj80V1Lgo/Sbflxy?=
 =?us-ascii?Q?++53dWeMlW9vD64W/PCO9oPgEKGzJyrJqiSbe37b+Yr7IL0gcqFYykAmEhUp?=
 =?us-ascii?Q?EQ5pTbdVgJ302XcAOa5Okh3Rqh+iz6eGg9NLKhSk5UMJIapmxF47ueToKCYT?=
 =?us-ascii?Q?C8LnkdpDmd2BgwUCBDHIWnddl/zwwZQTbERNr8er4g79eFIbgrMtfLhKH2ny?=
 =?us-ascii?Q?slkuIyNrzyEaOCx2SASUTEvK9HnQbNIYxKjJc1XAp1QLyDw5a1mzXoiN0Lof?=
 =?us-ascii?Q?FRvfgFqNK94n3lk8xrLt4Jn3T5afUNE6pl4WxweQ3f6nAcF/cAyvglECrILk?=
 =?us-ascii?Q?WSzDRysJ+xccF7DU/f/P1t5HudKGW0jCL7vyEOkDa5erue1CqgCZBwdz/bhz?=
 =?us-ascii?Q?leRhBlLV1hZUJh1B2I1zHu1cqmSgcXyLKvd8EIARdILKSfiGNgrKj8eg5t0f?=
 =?us-ascii?Q?PmGWpmJAUIiEKD7YG+b7D2TEs6xO4nw+d2UUswwUrVHpf9+3Wi4T9vzofthI?=
 =?us-ascii?Q?vuZn/HlBoyUiDwKye/MvAD18lHnEZv6wmMSR7K38vijPTRNC7/XM3SoKtFLw?=
 =?us-ascii?Q?1GPQelfHgcICk//++N1lHVyuQhTIDt8t4diZ0XhN9UVsVb9GgP73zVLLzAyS?=
 =?us-ascii?Q?cxBVbdcxN5nIM4PqBNgBs3eHlya1/L8HRjsz99QcauBajsWEm7yVUa6gbeQU?=
 =?us-ascii?Q?yz3I6P2g/t16/q3yB95DLwxf/ZDk95b8Ym2v9SAlbHQ5yAGSCeCtmsS0BnWM?=
 =?us-ascii?Q?04uT/hI67wXlns+SCZ26tppXdKUtBQdHgYXXchbK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 424ebe64-2fb0-4f03-69c1-08db6d546247
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 03:55:39.6170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8qMQbFLXL4QYC3NVQQtyrol5+r6ctQhqOunmv6ROjklqd2zJCLU21vOoyX5bibIdWihMIkC9ysy81hk9AITVpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6294
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, June 15, 2023 5:21 AM, Sean Christopherson wrote:
> On Fri, Jun 02, 2023, Anish Moorthy wrote:
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h index
> > 69a221f71914..abbc5dd72292 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2297,4 +2297,10 @@ static inline void
> kvm_account_pgtable_pages(void *virt, int nr)
> >   */
> >  inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
> >  				     uint64_t gpa, uint64_t len, uint64_t flags);
> > +
> > +static inline bool kvm_slot_nowait_on_fault(
> > +	const struct kvm_memory_slot *slot)
>=20
> Just when I was starting to think that we had beat all of the Google3 out=
 of
> you :-)
>=20
> And predicate helpers in KVM typically have "is" or "has" in the name, so=
 that it's
> clear the helper queries, versus e.g. sets the flag or something.
>=20
> > +{
> > +	return slot->flags & KVM_MEM_NOWAIT_ON_FAULT;
>=20
> KVM is anything but consistent, but if the helper is likely to be called =
without a
> known good memslot, it probably makes sense to have the helper check for
> NULL, e.g.
>=20
> static inline bool kvm_is_slot_nowait_on_fault(const struct kvm_memory_sl=
ot
> *slot) {
> 	return slot && slot->flags & KVM_MEM_NOWAIT_ON_FAULT; }
>=20
> However, do we actually need to force vendor code to query nowait?  At a
> glance, the only external (relative to kvm_main.c) users of
> __gfn_to_pfn_memslot() are in flows that play nice with nowait or that do=
n't
> support it at all.  So I *think* we can do this?
>=20
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c index
> be06b09e9104..78024318286d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2403,6 +2403,11 @@ static bool memslot_is_readonly(const struct
> kvm_memory_slot *slot)
>         return slot->flags & KVM_MEM_READONLY;  }
>=20
> +static bool memslot_is_nowait_on_fault(const struct kvm_memory_slot
> +*slot) {
> +       return slot->flags & KVM_MEM_NOWAIT_ON_FAULT; }
> +
>  static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *slo=
t,
> gfn_t gfn,
>                                        gfn_t *nr_pages, bool write)  { @@=
 -2730,6 +2735,11 @@
> kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t
> gfn,
>                 writable =3D NULL;
>         }
>=20
> +       if (async && memslot_is_nowait_on_fault(slot)) {
> +               *async =3D false;
> +               async =3D NULL;
> +       }
> +
>         return hva_to_pfn(addr, atomic, interruptible, async, write_fault=
,
>                           writable);
>  }
>=20
> Ah, crud.  The above highlights something I missed in v3.  The memslot NO=
WAIT
> flag isn't tied to FOLL_NOWAIT, it's really truly a "fast-only" flag.  An=
d even
> more confusingly, KVM does set FOLL_NOWAIT, but for the async #PF case,
> which will get even more confusing if/when KVM uses FOLL_NOWAIT internall=
y.
>=20
> Drat.  I really like the NOWAIT name, but unfortunately it doesn't do wha=
t as the
> name says.
>=20
> I still don't love "fast-only" as that bleeds kernel internals to userspa=
ce.
> Anyone have ideas?  Maybe something about not installing new mappings?

Yes, "NOWAIT" sounds a bit confusing here. If this is a patch applied to us=
erfaultfd
to solve the "wait" issue on queuing/handling faults, then it would make se=
nse.
But this is a KVM specific solution, which is not directly related to userf=
aultfd, and
it's not related to FOLL_NOWAIT. There seems nothing to wait in the KVM con=
text
here.

Why not just name the cap as what it does (i.e. something to indicate the c=
ap of
having the fault exited to userspace to handle), e.g. KVM_CAP_EXIT_ON_FAULT
or KVM_CAP_USERSPACE_FAULT.
