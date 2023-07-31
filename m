Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDED769CDF
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbjGaQiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbjGaQhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:37:48 -0400
Received: from mgamail.intel.com (unknown [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476E61BF4;
        Mon, 31 Jul 2023 09:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690821431; x=1722357431;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=49RgyO4aXFLQmhq6aGUugMt8PqBLQ2mg1p/4/wrpoK0=;
  b=DOeSYiiXH/V+RoRayyYxr6t41cgaVU5RDn33CrPV9nOo3yK5vRtqy3TE
   0m7BvC9LeVVWRedi200IfpeyAneX8t8OxNrC14yw/VRye+pf+LFHDQFs3
   ZpSXq6X1gKBUX0c5b/630XsytCGHOEdvYjA/T6iuNESQRELrgco1mviVm
   TuzPDvDXnyJHuk91meXKQFTAtuqw2x/oOffTodIHtbk9eyjo9YqZT5pbZ
   k+Bowf1jwXzPiintnHRYcgYHxFkcNfoi1t5ubpw7I7/2l6e53KhE5Lm2O
   B5mzi5TRwprdgU3/cEQmfDAXz1nwiCYIPdRmioHZk/zPZuWHRCkQJCvDZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="348664988"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="348664988"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 09:36:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="1059052767"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="1059052767"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 31 Jul 2023 09:36:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 09:36:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 31 Jul 2023 09:36:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 31 Jul 2023 09:36:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WWRC9EXycQCHI1JwtNptAUhovI9AGMTKtc0WufcHZ0HU+Kd3v1W2M7LfVyTiGrBMMoz34TiOG7TFoybw1iHfp1TzzzSRDog3vJTzmS6nDU4vRJ3w+BIpXkESBekcp1guDdi4/pPnZ2OXPr2CUbM24AArTFBRrGnLqR4xQ4n7BwmDBXPMuDmrHDO6JDUkQhLBeOekBJw1ivyVwCvogkNdOm5kNjdCeBNXnX7GADCbgy1S82O4jtjIVNIVE3RaW8u4zJzsVy7dnSmDpgqVeh4ghfQMvHEbkbeZp1j1OmNdiIi9r2Xh+CbNf3VaJvHpd220/+TzzU8hfu60Bs76jxzYlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hZM3IZCj9KuMzD5OWVeNhHThYuQ7QseQN4yi6Sx4pnc=;
 b=NvFx83XXc30MW/mCM132CM1zAOiNqtGcjnP1IkOpXdTw+4zsKHlGcBSov4/SjFFTuCPUNtWZjDxJ6CK4aDuCmuDWp9WynRUJdG4WIQCvYKw1x1MlWb4nXZIb0jYDWQTC+TJMY8swiJisxD4pUK9cUs3F8vlag5VnnvzwZHLHmGfHHeroNncOkTnBTzhYWHpaMNnv133dJczG1+SqUaEVhYKAPFo6UJV0c8gOZKv6SencstvZg9KlJhYD5cb+itbLLjZ8nO0F5k0+ycPdS+RS+HTmIe6BDajx64QyDwS5UAPwXZss0SSIcRxYUUI6zAvBSoYWeAqY6suP7gI4doEWRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by SA0PR11MB4766.namprd11.prod.outlook.com (2603:10b6:806:92::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.42; Mon, 31 Jul
 2023 16:36:45 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::50e4:2cb8:4529:af04]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::50e4:2cb8:4529:af04%7]) with mapi id 15.20.6631.043; Mon, 31 Jul 2023
 16:36:44 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
CC:     "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Borislav Petkov" <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "Cui, Dexuan" <decui@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Liam R . Howlett" <Liam.Howlett@Oracle.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Breno Leitao <leitao@debian.org>,
        "Nikunj A Dadhania" <nikunj@amd.com>,
        Brian Gerst <brgerst@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Alexander Potapenko <glider@google.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ze Gao <zegao2021@gmail.com>, "Li, Fei1" <fei1.li@intel.com>,
        Conghui <conghui.chen@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Jiapeng Chong" <jiapeng.chong@linux.alibaba.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Ostrovsky, Boris" <boris.ostrovsky@oracle.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Yantengsi <siyanteng@loongson.cn>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sathvika Vasireddy <sv@linux.ibm.com>
Subject: RE: [PATCH v9 05/36] x86/opcode: Add ERETU, ERETS instructions to
 x86-opcode-map
Thread-Topic: [PATCH v9 05/36] x86/opcode: Add ERETU, ERETS instructions to
 x86-opcode-map
Thread-Index: AQHZw3zoe8WDZngsCk2Vpcje4URgCq/Tn9qAgABzJoA=
Date:   Mon, 31 Jul 2023 16:36:44 +0000
Message-ID: <SA1PR11MB67348E503BDAA548E84D5BA1A805A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230731063317.3720-1-xin3.li@intel.com>
        <20230731063317.3720-6-xin3.li@intel.com>
 <20230731184309.9888dfd44fa1a5fd69c779cd@kernel.org>
In-Reply-To: <20230731184309.9888dfd44fa1a5fd69c779cd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|SA0PR11MB4766:EE_
x-ms-office365-filtering-correlation-id: 9e043996-a3d9-43fb-3271-08db91e45399
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qgTFPD0vvh/pbLUzfCEsk1qklqAy5mmnjClGG+j6+RZYPOdQ6vUr+v1QvUNsYId3nEC9G+v8iQ6f6z/bzVOu7mHtbmnIMmB6vBI1mjAArv3fX22N5clBlt+0RS+FjYXhSZUqkRLSMg5xklhFXBdEe4PfwXA10EG2rtgR7ee3Lo9h7Esut9uowIA4gadE+LQs0C0n5kWwwsZiGoTS+spwUIpYsmC7xtF821zf/iDFEnVNsxMllvpw1c0gCSQklMW+bDFedxYM4d56yl6oEgg1AP+IwdoUZm7vUc+3HadIxKXr03pokbBuam6dPR0Fg030gIhO+GCoBc3ymbe0kZQ4FOBefhUuxwn+BEGQF9KQSFYKs5Ccq9AEBmASymHbB1TAEtWVh7mjVYhTrBvuE6sql1mnc95pWD9Jjegvp7nBvrT/JAagDOv3Se/zvxCh1Gid1+lCwhesyBD2j0EOZO6HGnN8h5pR7UEQFVsTPo/TGMryw0v6P3XEMvVTV0rEybgGeJzjT8RFZlU1txdlIyEDDJ3h02EREXYXHqwSob5u8zINwhoGv75Z6mGtRYlAApQLFJ9cxV3uQ5lVe3TzwR2Pfcm6J5jBpRKMEfO/HvI5uNVt9U2ccB3bK13G3eveiKf1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(39860400002)(136003)(396003)(451199021)(52536014)(76116006)(2906002)(66476007)(66946007)(64756008)(66446008)(66556008)(6916009)(4326008)(7416002)(7406005)(7366002)(5660300002)(4744005)(54906003)(41300700001)(316002)(7696005)(71200400001)(8936002)(6506007)(26005)(8676002)(186003)(82960400001)(122000001)(478600001)(38100700002)(33656002)(38070700005)(9686003)(55016003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Jg6NUDMD0WiuAZY7n6ciD1OJk4KhYlkc6r78IR5Wz/DgIHaGvaNLAt/7FULz?=
 =?us-ascii?Q?KJcc6w5H6Aicghx0005zjkkPhgFUIw0CSgxK7gjZx42z06HX5flgwpgjHa/i?=
 =?us-ascii?Q?08LjhDmmnrnIbEzqAvESI4GeKVLbNl4YJclqyWVRfxZu08eiVXMCf8JD855P?=
 =?us-ascii?Q?ju2v5wbuGhzefwD+O3aBrcWvRPn0oO0rD0les4YPLFGXEg46Kfu9LwtWOUIy?=
 =?us-ascii?Q?3V7fjTzIiXMJlKXKwMwv5NsKzrbe5YwAgp3ttZ8PJvtyD/3woq0bBSq6petC?=
 =?us-ascii?Q?PrmbXlAQjicmN7B0ZV8XxXbqj0T65qlLsDvXAS7/TZzJOsmKfAOdYdwla9ty?=
 =?us-ascii?Q?VPmZwmp17XTjYONkiuXY1favscSTzwD7Fxr5JRgkpaAprswf7V9tjZ1On9K2?=
 =?us-ascii?Q?L3JDbPrJNg/KR9a30KFuMIdci15V+AcGYkZemxZzvKVj5bPuH+IZ2/O20JVO?=
 =?us-ascii?Q?dG5DS1+vo/oK0Vrm4lPkY1ZLhQbH9jLXfrVKomoY2yDZ8twfCyVDQ8BmM4BA?=
 =?us-ascii?Q?YQAW9AybsspK1bjJKCo4qm5fWCtKCsmGvrp8SmNkMyy2VMC57bdDLo2CoThC?=
 =?us-ascii?Q?Hz/tJVdB7d4XGDzPgIkMJy/kKjINS5LECL2459mwrP2ukbKBRuW26FPTH66C?=
 =?us-ascii?Q?j3KToUDiBSxeBHdJIKd4+HHWFcbn6BIemO4j1JBwjn9emZuW2O2jG1yN6Ies?=
 =?us-ascii?Q?Hsa86fQcMlNIBtVCkb7ooO7AskBqt4opcmdIgonsRo42JEofP3mIqKW5TTs7?=
 =?us-ascii?Q?2v2GAouSARGUpq1vHJxItAvZ8Ua/eUXJ+XkpApDPLtH+20p8w1aPYWyUCKL4?=
 =?us-ascii?Q?rxO1wJVkxZoMsOflF0+UscndLrGxDeNDCW/lW8jKG8iqjPtNT7gVTPD4UFv9?=
 =?us-ascii?Q?C3iX2JUc0yKFphKV4lH+b7aIAsSXnSQfU2GdyxEk85LCSfim9DKFtTwzy3v+?=
 =?us-ascii?Q?suu/FRkcuYJtuN4g1VpGXYPpryMgntY3vCSm4e8V6Ma7bIoEcJiEP78PB91P?=
 =?us-ascii?Q?f4f/pb0ts8pfVro0r63Qjr5eXz/nr148HM0ruSxInUabyT6ZmzAZfDYJkQgC?=
 =?us-ascii?Q?cdZP5jy4NOh5NNp1K6/mzifxCmykPfU17S/IRgf6XPdHkO/lpQ8NfPhl+PCN?=
 =?us-ascii?Q?nVKUjJYkd5UcEKIvdeDjO6JpPX2fpgNMQQjWLBIregIzUyUil8RF+8kz8knq?=
 =?us-ascii?Q?XP48sjWETMxXz8xCB7AdWwSX0KR7okaDBQJTo+wG7EOQE2FPSjtUMnkbp32s?=
 =?us-ascii?Q?gkCiIWAGOooQYpHXhfG8IxnhDz8Ptf1KW5xA3kg8lTQAkjO7jVTRFDaCbv1N?=
 =?us-ascii?Q?qwEIIvO7K3M6Qd7MnF86E2gwpBOzc/yR9jCMDPjnXjJC/3BrmSZOaXwbOspJ?=
 =?us-ascii?Q?M86JLgf9pGPaARPJvbTalHKT9glkWd3z5YSPONrsDyAbkA+YDlcI0CEpqf7j?=
 =?us-ascii?Q?lD1kwOyfOxL2tUNsHcxSnE1bTHgs/AzdW5TsNWtIAd2zxfFthjmcaIZ+2Roo?=
 =?us-ascii?Q?zR2S2A60RIezp7v9mRUJn4r9woSfMKL9nmM/fneHfZtRg/kiQ+JZoxPm+UvV?=
 =?us-ascii?Q?xzmC7DBqYan8Ws+ocnU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e043996-a3d9-43fb-3271-08db91e45399
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2023 16:36:44.4107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eACxot9jVLCzFTNdkJoROJ/GJ+sWbF1GUMo0C1rvQmcEmybjwGoVg/Fb1sRrv5XYnoliRwnENsFGv/RWXLrJ7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4766
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

> > Add instruction opcodes used by FRED ERETU/ERETS to x86-opcode-map.
> >
> > Opcode numbers are per FRED spec v5.0.
> >
> > Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> > Tested-by: Shan Kang <shan.kang@intel.com>
> > Signed-off-by: Xin Li <xin3.li@intel.com>
>=20
> This looks good to me. (ERETS has the opcode F2 0F 01 CA, ERETU has the o=
pcode
> F3 0F 01 CA)
>=20
> Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
>=20
> Thank you,

Thanks! Will add your RB.
  Xin

