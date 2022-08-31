Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5B85A732E
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 03:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbiHaBHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 21:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiHaBHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 21:07:16 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADBE9836D;
        Tue, 30 Aug 2022 18:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661908035; x=1693444035;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Fj6SgysU48Lu38jsadmej7LYKVQDJ2ivuXn/rFQ0zaE=;
  b=DRN7VonWSFx4ldMIDPbzLSR/P4GE/uaHl4ljCVJwddLENwH2j+PpAvd6
   Mp4tfjwgwjhENXzd8RO3OVJfYu0EmWjUVERAFigKEd84mQLFwRnE+kvX6
   f03AuscoiRR95vl1bubhlsg2XVuu0Rjd+ePGwC/aT2xbLFDnhPS7Oig0p
   bGuRDVt/ic0Qkb7vld0d/GbZgCxo4r1852cFlshHKX0jbhKXFYjtNbTbq
   TAV9ZN3U0OQJtZjFeGSej+JXiJLmyus7Jh5shwCJTdcauSz5IP1TRPsUp
   tjkSrOpoyjUZ4QKBElEwRP22Z3HySHe+/p/QEEFZkj1CSWKge0Eht58cO
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="275091762"
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="275091762"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 18:07:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="608042021"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 30 Aug 2022 18:07:14 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 18:07:14 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 18:07:13 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 30 Aug 2022 18:07:13 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 30 Aug 2022 18:07:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YsuGtL165lpdqQeMtDInSSviat53IqCLSsO6eQpLpgwSubuHKOKL2JIsPeD/0vNefCOwMSyk3u2w3sAOw4f7xs7G0GuNCkpijoDgX1vqv1TytaHWrRry4cXODh8Y8PiTnLaWIJlxQTLkASKgkc043UjcmteZdx4lrsUX4YdDSoyLEPdgqCwzjZOIZgMMsLtI6PweQWBesW6I+ptyvHSCtR+IqS7EffjimlXhV0mJBeMnT625euYvUkAwXLyJnYok+HyvkS/o3KAd4qKbsOTiBQSrv2tbcJQXjaoNra5p7XRpJELCHD80OPynKMGDKuuJXwgyxfs+JlDjmVD0FoG8+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hHIGW6m4vF/qSrFVFO57wlqKSrlMi3vQVqME/AFeRyU=;
 b=WTsqjdG3rb3WC1gXJb5M1h2FIWEqJ32W72YS4RdmC0ZuSpvNWzr915ppSVpDxOFmUXGulaEcZGqwnSI6TUfLEH0hkVkIO+mv2JpKcEahygYnEuqqdW4E3rlA5ua5mzNo2yOOjucwmS4NpZ7piKDQ2XEEZHY/EizFdghXcHK3/KCOj5WJj+zuOQD5sfN4zSdKwQf0AAH7HyUcfX9YwW5s2wh0qnbePMiwowxMg1VVAEX/5KiZoWgb+8qeNXkHlTjl3J+Ktdd27UPTwe8B6eXahRsjiFdnN2zZJ4nluLxMqgwYpEQqZEMJL/TJlCGHZTpAa5OupxeFCg3SFs9Bm3HLXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BYAPR11MB2968.namprd11.prod.outlook.com (2603:10b6:a03:90::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 31 Aug
 2022 01:07:11 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708%8]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 01:07:11 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] kvm: x86: mmu: fix memoryleak in
 kvm_mmu_vendor_module_init()
Thread-Topic: [PATCH] kvm: x86: mmu: fix memoryleak in
 kvm_mmu_vendor_module_init()
Thread-Index: AQHYtrpTE8hRcJCftkOclVuF10QdUq3IBKiAgAAReACAAALVAIAAJUEA
Date:   Wed, 31 Aug 2022 01:07:11 +0000
Message-ID: <BL1PR11MB5978F8CB6B5900184C704EDEF7789@BL1PR11MB5978.namprd11.prod.outlook.com>
References: <20220823063237.47299-1-linmiaohe@huawei.com>
 <Yw6DsUwSInpz97IV@google.com>
 <e1199046d184ad7210ebb100fc2f4b77d1ef4fba.camel@intel.com>
 <Yw6UuGqIF1op5zYp@google.com>
In-Reply-To: <Yw6UuGqIF1op5zYp@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c1c9466-554a-472c-7dbc-08da8aed222e
x-ms-traffictypediagnostic: BYAPR11MB2968:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vzg89GZ/VfFmXnjxhfSpeW+zGUNTpKvWADcfFQTMuSC8Y/BZ1bMVWLZGl7TsAZo+5H8aYuI/kDoWehVu8ou4q6+Rx/cornniykrXUXTBk+n/lVctBUeMJsEliEnpAH9qvjWULREcCIWvuKSMxXaa+HgdgO3wGspEkvgva+4F6ok1rBOVtv8Py78Vj66PjpntMWHW9yHrtXFfOMtXBn6H7PgtuPMdn8m+UbiaYZ0RZKoxZVFqk45fljoms8yJAGCslFO1zZlpHIoromiw9TefvylSa0OuElMVkLuzI4kBkrb5vZXZqyH9ox4fyRGJ8MFDEATmLUSchssYTFnA9yc8TPc3dr6+CX8Tj4ZDyDpKDpt0cgYDu3hGx2adnwEPhtbLtYG+TFDdrIlRal4vea4r2P1w7WNXCM8H10IlOuFdfU6tmpL3nhxVr5vUSIh4eN2uWQ1RCjdeNCBPD7QGGqOMtUffREMV8qKXr+I5GCxXK06ImDpvsGSRqXQmki8QALhQ4OMaR2lfzGYBEE22hwrrvTeMHlLs1cPw2w62eBe26zTf8idqPKPwZTx2xEfqtTBn4up5g3ur12Q8xc1jpXeTr7jhYv57iuHT3k0pxt8i6xVy7RWIyz4szeWZtCHjQxaap/Exw3+UKECHsFFnCmfN9aVc6oZM9IPEiyxKZOQOxnVoGOJ0RH8mLxL2/5cgRR8yJPtCmPI4vpj9ijaHWBATmnTyUvbJ4+otFC6k/4WP1Io7J4dmXdg4DBKP0M0V67Gentd946U6JheQFfu+EqL06krVud1QbWLbruzeeT2TgYQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(376002)(346002)(39860400002)(136003)(4326008)(5660300002)(52536014)(66946007)(41300700001)(55016003)(38100700002)(966005)(122000001)(478600001)(6916009)(7416002)(66476007)(76116006)(66556008)(66446008)(64756008)(8676002)(316002)(54906003)(71200400001)(8936002)(9686003)(83380400001)(2906002)(6506007)(33656002)(186003)(7696005)(26005)(86362001)(82960400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fnSTHCFzOF/F6a9ke3lBkrNknbsHLUWLG2rck6D0JAtusrUyrIkadAhnnSz+?=
 =?us-ascii?Q?Lu8FQk9bdc7a5SczJljNQ+bNDgTmr9UrfKi2RLoI+slGQxDMeJZg/HhnWUEO?=
 =?us-ascii?Q?LPB/0ptwHmkU5U3YBfu37WNiHyFLxI4vG6Oci7NECKV+oTwpO29r73ZZCaCZ?=
 =?us-ascii?Q?7jLtX50uJy0Cs9oeWzfexhJSD3tTtyg15xoaRNEDu3bcm+nQqvUD7ws3mcqy?=
 =?us-ascii?Q?Qlb05AEPB4p18iapJCbsRqLQdWGMdov8j3DgW85hWo5PeP1WWlmlHZLA9SMo?=
 =?us-ascii?Q?AbOFihDAe8Qw147FvlxRukYMRI3aeHeUnz0QxGLWGpJbm8xUNS30gGAxizFz?=
 =?us-ascii?Q?fscufC5aA0NeRiYVp2ZWjcaLcTSRD/rmDHlKd4aPUYxKpAjg90oUhK96fep9?=
 =?us-ascii?Q?ErRtSPMRG9Zw13kWR0ZsIM+9EEQBYaouPlZp011IqruNX6bqx2D9xYSIyKqJ?=
 =?us-ascii?Q?pYZkb+KykBaGqDb2FVy+kMGHdGo5fdhvacUvs61gS2Rv7VcxJYYbVa19Xy53?=
 =?us-ascii?Q?x6ZxtJDTM3pjvrUQnWLqXDJsUMbpsFZQ1//BGaJL+5hWBpdNUsblPlOcAB6U?=
 =?us-ascii?Q?K0JxUHKX+5qam1ZsrApTwrMZy8URDJ7ArI+xUJt01wnjKMdO6m9MV8E1O0wp?=
 =?us-ascii?Q?6x3vI25iX6G2LWpjRnJenSkHG+PQQUJJdMBg0fBWWvPqs6E0Q1SkLm3RNOol?=
 =?us-ascii?Q?7roybbwLZDycNSgUCezvoP+36zM6bx+pABY8wy0SCMPQ0PjWe5zrUbE+rxL8?=
 =?us-ascii?Q?m/8ejHc7fLerF9vddmWGc2YnlBMosFHeZdjoKdeGemtSmN5hl829H6aCyUgx?=
 =?us-ascii?Q?cqtLKpzkFonUM6T77vxlLrjYmFGSk5OJmonAVV9WMqUqxn0lzARc+vHiOfCH?=
 =?us-ascii?Q?PPyNiql6nUlszeemr+hYv2sF8lWWnugNbyVAvmkd3JQ7GpzBoMWzp1GFgSqo?=
 =?us-ascii?Q?WpIoQYG4h2hUgODg4i9L5sV69yVKB8MjOf1VEvCQRHa2GoY8z5QbwJpkKB9d?=
 =?us-ascii?Q?FpuEQF7mcA8uKw3HIudeBahhL/yGTlzH0jnHsGwZzhRyuh3LpL5rnbLu5Fo3?=
 =?us-ascii?Q?B5o6RWv1IUrEB184RNF4XlqFFoI5vqj8RRPn2utmxA7wUb/32ZZhSdZax4gq?=
 =?us-ascii?Q?EgQWQOHUXvV3pVoNmkJUuPvFMFuzi6kAF6vTYiMeN080p6cAiC737/YVisSH?=
 =?us-ascii?Q?iadiymKq9tHprICmdGiCnf59uoL/1aRYlGloGeXQu6ht2iYgLId5NrTUF9fD?=
 =?us-ascii?Q?qccKspXJ/3ZLicHz5tSVBztjL2o6uosfmo8yKGNI4f0nuCszEQGeFDml6jyH?=
 =?us-ascii?Q?NV35Cyksodkui7ynZw0UfBBMKxNcBW2V7Q/JcVLyerl27Q0ijQd8zM204+bY?=
 =?us-ascii?Q?nEEcsf2O49CiTNgqdvAsz0fhXPsYpGRR+4GPJYRrig7ExWCXXDwqby8QRlCw?=
 =?us-ascii?Q?3kOZn4m7dshMUhSY2uHrKSaKOfq+ZAkCHXdiqFWLjT9XOawF7vH4B42iNpQW?=
 =?us-ascii?Q?NJJV4DiNZa9SJtGWixwuF4VBpdRSnwq+s3MVLtBhZe+lwbsOxHcLegRTIOWN?=
 =?us-ascii?Q?vsptlhtVhGvgIGM1finC+o1E6kKCC7zp6v94zUqM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c1c9466-554a-472c-7dbc-08da8aed222e
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2022 01:07:11.1232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: obIfNyz4cr4QdBZVn5VDA/gOzhpRzCsoqO7uaigUNiChKYtUN8tcjWe0i3MpLOjnQhc4WpGZVehQxxlRQZNxaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2968
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Tue, Aug 30, 2022, Huang, Kai wrote:
> > On Tue, 2022-08-30 at 21:40 +0000, Sean Christopherson wrote:
> > > On Tue, Aug 23, 2022, Miaohe Lin wrote:
> > > > When register_shrinker() fails, we forgot to release the percpu
> > > > counter
> >
> > > > kvm_total_used_mmu_pages leading to memoryleak. Fix this issue by
> > > > calling
> > > > percpu_counter_destroy() when register_shrinker() fails.
> > > >
> > > > Fixes: ab271bd4dfd5 ("x86: kvm: propagate register_shrinker return
> > > > code")
> > > > Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> > > > ---
> > >
> > > Pushed to branch `for_paolo/6.1` at:
> > >
> > >     https://github.com/sean-jc/linux.git
> > >
> > > Unless you hear otherwise, it will make its way to kvm/queue "soon".
> > >
> > > Note, the commit IDs are not guaranteed to be stable.
> >
> > Sorry for late reply.
> >
> > The commit message has "we".  Should we get rid of it?
>=20
> Avoiding pronouns is obviously my preference, but sometimes even I set as=
ide
> my crusade to move things along :-)

Yeah sure.  I was replying just in case you didn't notice it :)
