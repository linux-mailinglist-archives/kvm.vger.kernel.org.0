Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04ED7A718A
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 06:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbjITEdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 00:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbjITEdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 00:33:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47CFAF;
        Tue, 19 Sep 2023 21:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695184424; x=1726720424;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KodWI222Ne4KcR+J4h7jJIpwYezt6mL7WzTywnyFLHo=;
  b=XkhIbcKfeBKbvtlFkA3d3RYD85WqWTVPKQXMdDwmWk+fm5vH8LS8gtx8
   c3I0/LnaK+PVqcOaoYljji+jtIcKEkLgjqEBfAESboKlcVPPa7wKsYwBD
   ab30IUDBCcPBfW+DNPIMpfzTeFGQmozTQ1IxJa6HfXB9KyrDJui9/0OlT
   dC5JKZlJ4oNaSqGK9XBo2S0zZ3lcAPslEuXZCGr7yZwQ4mQXFtCW3Tlpg
   zAc9NMOSB21krgx1wVXWE2xEmSeI8unuU0gL1TUpgyG14cyWdr5D2bbE1
   8SccVGF0TTc60j3i/fYRBvmHL2/8lFB/V5FUvBpOf1B+Nkc4DVQEx+cW8
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="380020870"
X-IronPort-AV: E=Sophos;i="6.02,161,1688454000"; 
   d="scan'208";a="380020870"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2023 21:33:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="836695527"
X-IronPort-AV: E=Sophos;i="6.02,161,1688454000"; 
   d="scan'208";a="836695527"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Sep 2023 21:33:41 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 19 Sep 2023 21:33:41 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 19 Sep 2023 21:33:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 19 Sep 2023 21:33:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GDGdrb+ENySOSoaJwFbw7TvyFIbnqaTP8IP40GnC2Ulga0UvZKEfvRIVJwHjXVsAzYHuJSp9m8u9qrhNzRWgJiUu/u8bZAv36Cpbd8Ny1ImyCdIz8giK6bIu6UrqMp250UTCM30io5a+c29ronDjWWdSxwJbxQIJPLR/tXY8fMY/CUBrnBR2NPQ7fWok52VyK7ag27HIBSLIqj01w0fw7PdF5zp8wcj5q4O0hYLT1YkfLmz+Xd54KCV6pZiIID/+8cBVMMk5WimrfgVwgLcl8aHJ3m/8JPEurF/Ee/wAbjXb0Am4VZzuiyVl0rpbqVgdYWEWnP8pnxEgOEvC6wae5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cuWtYsNSV45fWFoOBKicjRCIAtGyvumISLu68v8Tnfw=;
 b=UwqzdeYdSGLKU4z2foRy/kpYEqkZ8JwwcOv5KKxve7edM1IpzozjbIPX7JyifsUpfIrLARDIKjGSHHX4/EAjYLvMWLhi4EgxSCggbBcK5Q0D3EgkWkRF9p1lFyxeY2US5mgz/5d5P8Uow8e7JpbnsErbyzj067ugsR0JjZBz/uEu7gmGugk8UsWBSZ5/+uAM0hZNyMhNVdpoDEHrBEtOUvP7E2O6KwQDcmt2LZg6YOAKQZ/SA9ZY926YG6xx52PKIdEbeeoZG15IOcX+tw5cEAS0dhZ1g1bekwFtB5irj3TNK41y8X7JCrFfgLOXEbw+plt0Pfmdm9qgqhxp11FRaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CH3PR11MB8187.namprd11.prod.outlook.com (2603:10b6:610:160::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.26; Wed, 20 Sep
 2023 04:33:38 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61%5]) with mapi id 15.20.6792.026; Wed, 20 Sep 2023
 04:33:38 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
CC:     "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>
Subject: RE: [PATCH v10 36/38] x86/fred: Add fred_syscall_init()
Thread-Topic: [PATCH v10 36/38] x86/fred: Add fred_syscall_init()
Thread-Index: AQHZ5strXMSQ17oxYk2by6W1B7FxqLAh2QeAgAFNrPA=
Date:   Wed, 20 Sep 2023 04:33:38 +0000
Message-ID: <SA1PR11MB6734C02FFB973B2074EC6CC8A8F9A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-37-xin3.li@intel.com> <87v8c6woqo.ffs@tglx>
In-Reply-To: <87v8c6woqo.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CH3PR11MB8187:EE_
x-ms-office365-filtering-correlation-id: c40c0e54-f61e-4c4f-7255-08dbb992c296
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: khPSh9PhOUeMIRmEw4KIle6Rf8sOG8VwkEu2VnURKMnAICdS9+mt1eUdVSS2cafnVDyKS0tFtQQSmp7Fib4DZYOobmiukEGiAqCDNX5XNx6dPKJfO/CJsrN19Qov80o5qSeqdAlRdvIbY+N+WlIeP8KFSokZO7aCVsMnO4G/lgxazUNZrj+a450O/DDrUfTlKen/l7sZpgcz3gq5MY6u1NWj2eoir8GVpVV3ujfbUOCQnOxOynUA3JAqr4g84OksuOb2HJ8AUuwPEiz4aEMasYXmoGavXxMu/29s7yr3RKj9dkMMTT/PIcH6LHZJHh499izxOgi65n3LeqS73eEb17IbeQKIE+fauLH4rAJg6XQSPIdEyjSfLIqwktE/frhqFQmlF/YfiD9iF3vzMtwT0ZIDSMzuUzz7HTxDGcDIEPwGKVH1Q7UQteoLTZPCNlbhIkHrdasfhf2J2aLJdOaC5kSq0SYDXb15hSiC+W8K1+Aev50yhEswlwtWAE3l+MR+tQMcqmwbmkeNTlCZ0v2L4hxO80t+GRiVil8CspzAtkHbHny+Y3r2zO9P8GasgKahnwCLogd6EhHqPjYLBMLFxNqVAfeCEi/uIeDWZMH+PDLoYItU9avgLD9LlAua7TM1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(346002)(366004)(376002)(186009)(451199024)(1800799009)(26005)(52536014)(33656002)(8676002)(4326008)(8936002)(7416002)(2906002)(4744005)(66476007)(5660300002)(55016003)(86362001)(9686003)(71200400001)(6506007)(7696005)(122000001)(38070700005)(38100700002)(82960400001)(41300700001)(110136005)(76116006)(66946007)(66556008)(316002)(478600001)(64756008)(54906003)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jZ6ohgHOzvXsD6IYtOKwm9p/axEO9d/fyVqePdBFmr/1y1yiGkLHAr8PIBYG?=
 =?us-ascii?Q?wT1efeGaLkeHQ9qIMw5lrRR6quIMkiIBdGVvlyzlt0rCmgHqyDa/AVdi1tGg?=
 =?us-ascii?Q?i2qnmeEgZmoeM/A2uLtoOQNj7cfjTe5GlsWgHSZ3boxDnM8U+Myqw9rb/rHd?=
 =?us-ascii?Q?fYSASLigfqu1p1UwGl58x4/DMMz0Gyxx2Oq2vXSQnvdQkcqPMV6pE3GVwPFk?=
 =?us-ascii?Q?EhzQJFKNWmFLV6jv3W2QAQJ984ty09YjsqQ7esDMNLuDzy4hEhXJRvoCa9yS?=
 =?us-ascii?Q?2N0SSzALvJvlBqS6F4U1MITb9Cp1eXNDzDh1Ji9UPJf4/8vMOQsfiuNQgz94?=
 =?us-ascii?Q?3SoHMb6B8H6x18YwhXH0CNBj9czoUaT57MAdfu68ww51Uoce5FFbo+BwJ0kM?=
 =?us-ascii?Q?K/iMKTpvAq4NPz5cpdwtRfV1A3KojQWoPIBdP2buV2lvgUiqkbak6my1Xj+N?=
 =?us-ascii?Q?bO+sxDXIS5JVhu+PG57PCCytJewputXFT9RDOfJDQJ/5RTV+WcgJYGQYTSTj?=
 =?us-ascii?Q?f5kf0Ci2zc+LU7iHl4b92xsNCtLOEeOlUz2UeNTAWrmSFv3yczcBxHgzW7ya?=
 =?us-ascii?Q?JGEI4JyLHnu8LDewB3SGBTOSd3h2ASDp9fZz3Vmw1m6Uq4u8ZqcyqCGCgeVS?=
 =?us-ascii?Q?mor6DT+e5qpeSVbyh5XR4l6w5JVyjiYkY+P9FoYCqTQqPP/LQjFL5ZxuKLy2?=
 =?us-ascii?Q?lB7eUfjCKcxrE6x371W4u8cqPfquOA4S+CbCMTfTnGqG8DnNE/+yeqmo1AH5?=
 =?us-ascii?Q?0V5ZwEjEFoslpkuvfCcZpuTjLVGspRaqmdGt3hwCwK5cYzAann3cK+LYMuhe?=
 =?us-ascii?Q?bXSYlkgD8MKSNMdRjk9rImOZ2604+2rlJD0Kk2PvR9cInM/yw8eN5RD/Fo+5?=
 =?us-ascii?Q?HRaBq1bRoehr3GyY9UtJQIhVygtoyhfZRFDQLnDOw/f1vcIoaQ/W+SYzB5or?=
 =?us-ascii?Q?jSVLKQA8NOow3l0N9mQwPGsn0q0Vqt9iU54zpfV6F8Rad9MOcki9op8aKB57?=
 =?us-ascii?Q?HbYGMAOfN6+P3pmkczBDLTbrLVkN0Q336ITpbT5yEMZAnAqPE4csMuS+OS5t?=
 =?us-ascii?Q?cTYqR74VW2Lqlz4WmuAK/Oleo2L3B29KmaUCIt+A/KoVc9LlrAEl5cX+tEXG?=
 =?us-ascii?Q?ygrmQ44DrAWbHrxzGy2uL1BivUPKS2v0tkGopp2b90XZCpM5c+fuaA4fOWck?=
 =?us-ascii?Q?8qO2Y70Z76lbUAR5lrbw/P8/xC7YQIqLw8xl08IDBNHRUaiJBqgCXVswm+px?=
 =?us-ascii?Q?8WzM3gxPdlhAAIuJ87KSXANYULGk7pSaTo9sWGf/CUSVhi0Ve3966jBRL1Kx?=
 =?us-ascii?Q?hw+PHDkSNyDM67aY8mccqstPlpVhOuaf1FfrQM30HOAAFYpsXzGwREP+IaNV?=
 =?us-ascii?Q?jJpvoWilQCAr59Qe1q0BWL6EXJJJ4qp35BOnGcbCRIbIKxt3neCs1Alh7FO6?=
 =?us-ascii?Q?jdjQCIcbtnJqQ3oVTjLXXQ5ssMEzzT85orUauR//KK4vUbwWciUAVi5rD+3/?=
 =?us-ascii?Q?cH4O+qogp1db1dqBsoaUn2H1TvBdcuS+G7JdKnpLo1rJqVCYgdHF/J/o41s2?=
 =?us-ascii?Q?Sej5cA8gCWV+b25DTqU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c40c0e54-f61e-4c4f-7255-08dbb992c296
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2023 04:33:38.3441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KIdLu7r7wJ74jFtFEdlCvuzKRT84bG+qv3nJ0V30Fcf2ryKHYN9rOKCDbpFuBYkE4e+J9fkJcJF7y0cJuSi9Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8187
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +static inline void fred_syscall_init(void) {
> > +	/*
> > +	 * Per FRED spec 5.0, FRED uses the ring 3 FRED entrypoint for SYSCAL=
L
> > +	 * and SYSENTER, and ERETU is the only legit instruction to return to
> > +	 * ring 3, as a result there is _no_ need to setup the SYSCALL and
> > +	 * SYSENTER MSRs.
> > +	 *
> > +	 * Note, both sysexit and sysret cause #UD when FRED is enabled.
> > +	 */
> > +	wrmsrl(MSR_LSTAR, 0ULL);
> > +	wrmsrl_cstar(0ULL);
>=20
> That write is pointless. See the comment in wrmsrl_cstar().

What I heard is that AMD is going to support FRED.

Both LSTAR and CSTAR have no function when FRED is enabled, so maybe
just do NOT write to them?

Thanks!
    Xin

