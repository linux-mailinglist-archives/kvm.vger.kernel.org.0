Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30FBC6248FF
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 19:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbiKJSEE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 13:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiKJSDm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 13:03:42 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A9253ECF;
        Thu, 10 Nov 2022 10:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668103374; x=1699639374;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CUy9DX7pZtDwx+b2MeVPkXpOBbYJDs/RHe0vCHZMPjM=;
  b=FO1qYJ9f081JUWiZFGXZOPZq2t4Q84l52VAQDfVv7DhS/lSNuBxtAh7F
   apIgHXEzKhDpR4FqzlO4x2F4C/rmUblVyvmxbivDdfPuNQ10rwJr3qZH3
   QOt1ehNeroahW16BAGDvm2cXDcSBam6EjMCWGmQfSNFLh+J5rLEWplEWM
   XqpLUufhJLSFZZobEVVk7NbGhpyiSKgjPK8T/32q/Le3facn1KY0hgKGM
   2UlntnOXn7zqnzW7uM9u2oo/D3c4YQo3AtimfRKImMnCPzuv32PJyzzBW
   QQ6zKbctlM62kSRz34y6aalkxRvu/iu5AhJmP6EyUkrzvy54mgY2t4BIY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="298890523"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="298890523"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 10:02:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="812143375"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="812143375"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 10 Nov 2022 10:02:33 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 10:02:32 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 10:02:32 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 10:02:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQ0OR1WJpWHGrEnSfkAP76vfay28wX0b/F0yyhKc3xrB1Gp1icezU1S1LNI56ojgCIzZBO6PFxYVhFUDragaJlInXorxtG1hhaPqYAnbliADczMC3GN0VaIoumXgNj1VIE1r6vJdLLfFhsTtaxHBYXzP/GwH30t0yBZcEk1s8fyjTQC5PGuYT90MfgwrJwpoWEPmeQHtFkIs9pWotvmFhR/XOth8VedciDJwzXf+qOHL8aQjXYzNVo+GlHJQi5O9kjMn35APV/2lYpAUVQk9Wng33CCxp/i6JKYlOT6Rd1ka9pvmwqSR7juLGbDiru741MEWXxU946vw8TSSqL6sXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=57E2J2v9px1EdiXPP9nXRiQ1+sd2hzjZ/n8zV9JtZZw=;
 b=Sn3g4lPQrdUES8Ipx5Zilc3AYJ48KogUYSfWQ8+pBrwtrl9m2rp/QWCHpTjQJW1G2XDQcd3uc0Qp/8EFIUX98BNOuRkMUThcxC/8isHjMixYSDQmmTDsM0OEWPcPC5I3iprv9JrrmMsOAtM47kCxWMIJA2GUkXMOjiXiIl4zuw9qXGZh7f5lsJ6EkoIQL3xRl61ROQiBNT+DurUffAC7CWEqy5FO3Ujz24ix1paDeGKDBH3xPZtCCNT1+PQgbxvExduAoBv+f1NtHzSGha3LA8dk+3Rnp4O5aWamswCtyOMD7Vp+BXymooexVfNWh4osLKBIrOZIvsMvEmj30MmJpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by IA0PR11MB7401.namprd11.prod.outlook.com
 (2603:10b6:208:433::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Thu, 10 Nov
 2022 18:02:24 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c%11]) with mapi id 15.20.5813.013; Thu, 10 Nov
 2022 18:02:24 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RESEND PATCH 4/6] x86/traps: add external_interrupt() to
 dispatch external interrupts
Thread-Topic: [RESEND PATCH 4/6] x86/traps: add external_interrupt() to
 dispatch external interrupts
Thread-Index: AQHY9M87lZSUdLR7jEy/xIW4XbLhCq44WD4AgAAa2ZA=
Date:   Thu, 10 Nov 2022 18:02:23 +0000
Message-ID: <BN6PR1101MB2161BDB955216695E1951C2EA8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-5-xin3.li@intel.com> <Y20lyBl67GDZVOeB@google.com>
In-Reply-To: <Y20lyBl67GDZVOeB@google.com>
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
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|IA0PR11MB7401:EE_
x-ms-office365-filtering-correlation-id: 5d93abeb-c3f6-45cd-63c7-08dac345b846
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yAHna+JGDl6dXfoeSW6kPucWNL2tgGyHPwRDNC/vmIEAjguTbrIloJRvsfEpjhcdRP4fx1bUyW2HePYhREQ2NSzEWLdk8pOt/FTCMurE7n1BE3ZfNiyQxnNx1mfVm6Qi5fqlarlwvOS5gOaVJ20NMcjyhrHteDWxCHkF0Pd3FxPvP43CqC7/N8Pi72LDmlIf9m4rM6MP336TJfIgOQM4hKuV4ymKcIBfZxIVJWjGW6wzNvbusyTFeW7Guc8b6UWFtGsOKRTu5QbhbFeSZU9uRZPs0Aj79ZNM8eaN+3E59ijppRQ9vIi3sre9d/6N9ldIuvb43B2S3BhoyMG+s9VTyNzVkPO75WihlEn8I4qG0oOAZpp2/UHPpSaV6G47t7mP/SMzlNBMOhgIusMoo7XQlILAuHdDpLOP+AOuOI8eyq/gw7VIUgE07b203bGfDXQi/dY5GstnbnQd55P8rVj3J7hcv8RvxtpuWWlD7SJjbBUdhP9u+I8CuZ/BgzC0piClN4m/2LI9tObOr409V9a/hQjOaCIw1W80Gy55Fpk9ojsKfWQwQriQDBRryGGxmU7RyEHljrhli2z/OwjAO90T/ACKpixJWYz2+9//nswa7Tdteh0d0e3TsMz/ylI2ev8Ogy9Y+xacYIqPljBsk29imxLb4PZlBN+DwfQBTmxiu+yVZ3ik1as8zJ8UITHCWQk6MlCXDV7tJaZERYZqD6H0Inv1o/pSzrzji5zREv0/z60USfe/r8zzNbnNDQGN9D0scM3BdO9up7Z94LNqlB3zCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(39860400002)(366004)(376002)(396003)(451199015)(66476007)(4326008)(66946007)(71200400001)(76116006)(8676002)(2906002)(6506007)(55016003)(66446008)(7696005)(66556008)(33656002)(478600001)(38070700005)(26005)(186003)(64756008)(86362001)(316002)(6916009)(9686003)(54906003)(122000001)(5660300002)(66899015)(8936002)(7416002)(38100700002)(52536014)(4744005)(41300700001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nzng6BwKQnzWuwSmhmeq4aKvXDqqptgZXxNbbxqNXVYC9vR2Gb+IOO0yV4Ma?=
 =?us-ascii?Q?kkJSZHsTl4QJ4oNk6pyCdv4ZBxov7zZSdsP/2z5TtzVf5bFOAEt/o30bj2AX?=
 =?us-ascii?Q?FKqQRIPkVTHWpgYeDiiWsJM7L3FkMyXHcRvJPGsD7ShRqo07jNKtJQxBl3Tx?=
 =?us-ascii?Q?tWVf93O/nYf2fGLVvFDENF4OBh+YvTuekHar2mFJhhU0gn681ZvW/Sgr4me8?=
 =?us-ascii?Q?b5A4MrePcOCJ58ZtCp1EPyUqMb8DLvHaLhsYKmoaz6pA4TZgfDjmOO8KqjEa?=
 =?us-ascii?Q?AzzikCIaoJ/5CJD6ZnHbL/y/NieclCCnwmcIdW7+/AmQeuQNJHdW9Fw6mO/z?=
 =?us-ascii?Q?h5rHAm0sSFvx9UfYu8cGSV1mCAuPMa6ZiVddlUTG+2hjaKQWT+3IQPFw9Dr+?=
 =?us-ascii?Q?7c2AY/+IC8QQbGqVHZhh6DAbzvfppYPo/yPNHy1FZvp5yrKmDtGJlqgfuEdm?=
 =?us-ascii?Q?cmhYyvx3Qxegz4VD71SEaIHwuU027vue4onukq5yrHqS7qylAzs3V7AkzniS?=
 =?us-ascii?Q?pFRF+hplGs2o/yAlSgoZdeENFGARb9Gnexa8BjJT5Hov0L7a3JXJqU64zqnr?=
 =?us-ascii?Q?BZ7Zsqcbua1mmGVwBAViZ10uYGOmCPKT22yaokTM+/9f3Npp/QuOPDW61yut?=
 =?us-ascii?Q?Pn6FlHiWZ8IcQYeglF1SukTl4IyAkMajm0m8XPE3XXWKs5MbUARs4GmbGujN?=
 =?us-ascii?Q?6w/gEi/vWir0Jedim7q9QPQD8MHkjbBxYq18irpS9aGripgSwTvjPpGPrKsE?=
 =?us-ascii?Q?t+lviJRVhDyA/Xh5Ey1jAg810PJxuZ6X9rVFaZ9TV8NgnlBoY5F8gAu6FqD3?=
 =?us-ascii?Q?+4LyCxVf0FSgSZs9ibGVO54c7rFATFLuLsRLddAhxtNNvVf4NHIgMf/qJR30?=
 =?us-ascii?Q?qp4c1dqP0poX9do+1cD/yxbdd00YqKC5Q8jwxCRXGrSc4eJ0fAfOs5RVC+vZ?=
 =?us-ascii?Q?YKOdl306smFxiCgxXAvM454QJ64z3VU1WdD3LkGnFxH0yCrlc0j8CG6YApH0?=
 =?us-ascii?Q?iBfRYFNOf846c/K62/LydVSRhH34O8e04P7vjjpWfNjmnah5BkpumIIAvS0J?=
 =?us-ascii?Q?HVoIdnxnD/icUSnXudyiYx3BinnNcEMReIUfZEpWcRPunlOOGK+oZFznntlA?=
 =?us-ascii?Q?iELTqGZeNkKMwr90/J9Miq17VSMEO+gFZxHbUXyAtZkeCQ5R88KDdfRGNBMC?=
 =?us-ascii?Q?Gdnp0KR3amNF7tJPd5rnRDM4ygbGOm0b7bC8u38E7ZosUqqGmXk177fZ9mq6?=
 =?us-ascii?Q?zB3HfaQDIPYtmwR9rxl8RqtQfYgXbrSWBAuUFGD4khnPuRf2MA9hojz8DjTF?=
 =?us-ascii?Q?l/zeUF79X45lFnY6UhTVVb6GJpaHfc60Sd7FzCMn9EXJynySALwiYsulpM3v?=
 =?us-ascii?Q?CCbYvzojpRSzDozOB0KHbz1IW5PPlHfF6CtS43uoQSzxPmG2BuxycYtkavgW?=
 =?us-ascii?Q?Fy3M6Gb9WR9yZCw8wA+Kyu/6RNRHpsjxPMwdCVP00WFZR2gMy63X7FhFCY/C?=
 =?us-ascii?Q?lcYWch+5s6zrAkF4rG0TeuH7rLkXgidgsTzMMJQs4pOLCedXQkeK9uNiHbL1?=
 =?us-ascii?Q?u/+648vEbKttm62NbgA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d93abeb-c3f6-45cd-63c7-08dac345b846
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 18:02:23.7502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: moe7M2Tz8AHaQOkxBOp6d7g2ZQVCL9MRaXdj6DuhDXKTQ+ZNiRfHYrKQdHwPSUHsyOlT98CDRYOAcxY/a2E7BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7401
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +__visible noinstr void external_interrupt(struct pt_regs *regs,
> > +					  unsigned int vector)
> > +{
> > +	unsigned int sysvec =3D vector - FIRST_SYSTEM_VECTOR;
> > +
> > +	BUG_ON(vector < FIRST_EXTERNAL_VECTOR);
>=20
> Why not return an error up the stack?  KVM and/or CPU bugs aren't unheard
> of.
> Dropping an IRQ obviously isn't ideal, but there's a non-zero chance that=
 letting
> KVM WARN and kill the VM will keep the host alive and thus other VMs
> running.  A somewhat sophisticated setup might even react to the VM being
> killed by migrating other VMs off the system and initiating host maintena=
nce.

Make sense.

What about having it return a signed integer?
