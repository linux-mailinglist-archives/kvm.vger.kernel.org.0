Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDE74E4CE9
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 07:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241341AbiCWGvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 02:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiCWGu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 02:50:57 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8965C4506F;
        Tue, 22 Mar 2022 23:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648018168; x=1679554168;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FNpAlNo5mrnXyjH6ffzRCVwr54cC7i6IJ3+8rWedfnw=;
  b=GoNxVlbg6G+s4OntU9ILD64DrJQjvJ17U6HOj/l0gkHGkohHStEtg12W
   ovujQ6UbFk6hAe/NWntQZVbACPJoDN8Hc8SMZPdrfEdh4YBYGaHlITPe1
   tX9FoNQ0lalv/qd9ake3iZDmJZgkWiovXormqerPrwsIP3h5YVUIXWlCo
   SeNVtT5k1Zw8wwv/tzWMzbrrWxz1/e61MO7kY9JYmSvHRTlWT06NapNYB
   Dt0/hVxLqS5+6BYMIpAbItu9Ixg7gojTKcB0riW8u28xt9SYvluZ+B6sY
   9gQuhxpTGu+Uv+hQ1FJlAjSr3mChhHga/FEXXphzI/bp0ZeljFgVj7XrB
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="257752055"
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="257752055"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 23:49:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="649319218"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga004.jf.intel.com with ESMTP; 22 Mar 2022 23:49:27 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 22 Mar 2022 23:49:27 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 22 Mar 2022 23:49:27 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 22 Mar 2022 23:49:27 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Tue, 22 Mar 2022 23:49:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FG8dlqafWk9Nqv9zng3aB5m5KByyhFrkmtXU1FZvViNKBAKZr+zXuub0JBXcQXOf3R3aKPkyLFYJA2F17hzH974hgh4KqePvnXhUT438+WJ5JJ619DB1LPqbS3R1rPWC0HmGsw4elOj/CNxqN76Aow2ak2W4KAdviZpIdQLVW7/RQNiZkiWMpgt6Wa5F7UcyzPqeN9OzVxIOs2k+FZUNe6pctyWm8bPlH6nZctLfBlGfJ75cwBJGvB9Y//ljZmcp+3KY5ZmNM3t3boXdrZlsjR4L4O15aADghuWf43m4H/+b41sY8umK7ujAW2/Lx3KgxpeWasA3Z2W7gz+SCGMplA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQCocuuVjSCV7MrMZTvcSK2ZV7r7eQg/tEGl7VW1uq8=;
 b=h8lvp8pWwxqTcNv1eYlTh/jSxg70GVJx1oEXGr5gYoEaUGOma6yvezlnQ/nzhIt4T54C9yIWgQH85+d5Yv+0D5zlt0KlXVFDLCDjtR9p5X2nYrGwVqe37767v1Ulr9yji7ShxYR58HfrmeGnmyVA6ha7zSR8iI6I8kgG6Mx07iHmcwH9Qg3OuoOUtgJmOP+Fj6Y4ozU0l465KPPMnrCcSCvNaoj4gaathcuQuTNn2NGzJ04uaS6+swDoBiBJSxmMJs/coHb8BAChf9Ynt8Npz1DiNy/yTpXx2Qtmm49+9kvjD3bWCA12kwFg7kC0MjTNaXfUFTUo5+8xUhMBGORjKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by SN6PR11MB2831.namprd11.prod.outlook.com (2603:10b6:805:56::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.16; Wed, 23 Mar
 2022 06:49:23 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::3c5c:b7a7:ca9e:88f5]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::3c5c:b7a7:ca9e:88f5%7]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 06:49:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>
Subject: RE: [PATCH v2 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
Thread-Topic: [PATCH v2 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
Thread-Index: AQHYNsgzm2oe8d+tekOJ9ppfgUsWm6zMfiBA
Date:   Wed, 23 Mar 2022 06:49:23 +0000
Message-ID: <BL1PR11MB52713CA82D52248B0905C91D8C189@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <cover.1647167475.git.kai.huang@intel.com>
 <279af00f90a93491d5ec86672506146153909e5c.1647167475.git.kai.huang@intel.com>
In-Reply-To: <279af00f90a93491d5ec86672506146153909e5c.1647167475.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81dd2bdc-3eca-4f3f-8f8d-08da0c994409
x-ms-traffictypediagnostic: SN6PR11MB2831:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <SN6PR11MB2831C7B3231C63E241C914728C189@SN6PR11MB2831.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XarW/svGzAEJXIfWZA7pqobhu/m0pK3muV/dzUrP+BodL1+J4QRhNALmICd3f5Pp+jwWpICUKbtTXtTID3ZYtGHnt1NFwffyle9jeAiiOPmJ7ZPm09upidaPdF6L/4Ue1Hla0tlLItIFZ02/9wELcaLEo6ZIjR9digKC/ptpNS1cgOKkotcQ/FBQ8qsYPebQY8rRiRh6J1npogesvDPI4jp1RolYGsOyvG982RPqsidjuWbI4EZ2rFmXXMVs33WjRRVca0TWVuNyReU0ZhYTtBR6Yjm88P5baX0W0lCN6U0KXlKDnTscXRCxNn4Sfhwu2FsOQ3xrer67lUl94enqzk5QQwY3gbpk68IPlFPZrsm6LNRLE6IPUGxOvghiYaB226sNjEdBIMmZSI8Cb55fzuyY2XfKiFjtYC8BbgzK/4r2GDpjmqQnqdabAKISgFPbKp5aePfb23RWXKV2an8H/HIvVYV1cLy+J8HxAb8SdlkUNzIL7rZ6tN1g1JjPGiuJo1ul7UVbVxJzoO/il1O22rT68vNhi0ELDcaR2nLFfvj5oTv6zBGsnxupdvKMLYCOgGKtn8ma+rkr77aerEHhBC8RDQsav7reWEnlKNtzGiHWxLTZMicx0AirArosUXS2OBaitGBRSipSRXubSQpQ8czzZCsv6Ml4Sn+zQPwUMfIBKbN5zGhli6w0K2GSx5Mo3A7kpIC7zrAtKQNzNPSxbw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(52536014)(6506007)(8936002)(7696005)(55016003)(26005)(9686003)(122000001)(71200400001)(5660300002)(110136005)(4326008)(38100700002)(54906003)(82960400001)(8676002)(86362001)(2906002)(508600001)(83380400001)(33656002)(38070700005)(316002)(66556008)(66476007)(66446008)(66946007)(76116006)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ulMQhVGS8vZtDlVwZ3NUb3XgvmfhykVgYhIS5yZOb4guZc7s2auzH/natPb/?=
 =?us-ascii?Q?8Y1s2RPZbbVZBNQCjndnf4bUDZQICPWlQMa6nNBUnlynaYD3IHGh//qiiLJM?=
 =?us-ascii?Q?aT+6dai/SjMzy6SA2xxU45Yd8ySOuekiCXXVnwdXogxWZtGK/WWD8g1CVwVQ?=
 =?us-ascii?Q?Ds+EaVxAgWOxOHwykWpqRKZpFdWnX3Qr51Yvq5ztwF58dBGrb2XaoZohwrzg?=
 =?us-ascii?Q?dZPJE3vBY/BB6FscNDIWDDH2p+c4BNEJZp3t32gDJQHV90ZRM/ICXhIvKG6R?=
 =?us-ascii?Q?ZzyYUmB0uP7lmeXpaovWZJyEmu5R5H5XbySUBEztD/m6X/9h0ajYhVbqJsgy?=
 =?us-ascii?Q?dCY9zXlHU6odyzFA6W7foB9fBGSMyXwZbcJhkiVVwwY3yXzebXKY9CCyeWwC?=
 =?us-ascii?Q?WM3NuQgP05NZMDjgzaEJLtPqmCPk4xJmtCn9ZVxXczyWFET0s8H4w3CaxKM8?=
 =?us-ascii?Q?YgOWdwB3bGVUJOuO28RxVipbtGuI7Kxob27M1jrt9piE6bbZ14Ws/QelMEac?=
 =?us-ascii?Q?u7UO3t+s7Q+vV42Z5yP4+PYIGoPhWzUcAERXBEcO0Ijy1W9a59CZHtOPx0mJ?=
 =?us-ascii?Q?VACxkdgnahSkDA3MDvbY8IpUbwtMYz4xVhSzlRJCbp6KQEP3vLem+MRBDeU/?=
 =?us-ascii?Q?uPZqfhzfXoRLuniUg57ihR7CFdY8lese0COCRVCvp18GjNHKgqkK7vveNfrA?=
 =?us-ascii?Q?1czpjV02FXiEVzcdns6BxWUZRLMQvkotgQhF/mrgrH+0ox2hQCDw0D8In4kQ?=
 =?us-ascii?Q?RAqYzmMbxtpPf+3q9p39wZZyJdaHQ13WOjC+WurdbtUX3565oxd2V1vftn6M?=
 =?us-ascii?Q?JX4jGnm4YLmmBsP4S0tEnZCaT8YuW7voJsh92ItOyTVnfSa4F0u9fkG8XGSb?=
 =?us-ascii?Q?UbqvgJPgmFgPJnKOWhqLN74E3UGs6dH6g1sUhPaK37SGiNwR6L4sUl0+WxnX?=
 =?us-ascii?Q?4O2X+9IRfe1fHIvUvQB99t9zfpSl5bmEzeDb06rhT3jsN76lvt4eGgjUThDv?=
 =?us-ascii?Q?eu+/VOuem8VSDIZvJMefnhn9dcOIAx39yrGUP+2G9Qg650wuaL4ZE96pfpwS?=
 =?us-ascii?Q?7oC761B3E1lQQxZeP29Y2Xr/ECVQvE8XFebjvnpD4+tqa7sDdpM1m3Pv8bYI?=
 =?us-ascii?Q?980cbGcJALsu2znHR7ts0iSUjax7JD+hg/Sbso9rI0R37LMSWluyw5opd46a?=
 =?us-ascii?Q?bM2KqPsfpRRjJ4SPInI9jzGCdidlew76t1iV8iestocTj2XAN2N1gKUG/jki?=
 =?us-ascii?Q?Eh6cmvHsNiRdEMJpa+HmWx9DkA4oFQ/jMJ7oAS/QJaRfEmXsylrt0Bn7t+Tu?=
 =?us-ascii?Q?DTzs/xQSizqkV18qJ5RiZ8o6OQCxXkl5sMzCYRkqdYnElXNhZ79/wdEAhY0D?=
 =?us-ascii?Q?IBMhmjfLtPcr4HmN2y/H98mdPpnNfKjDn9SdRBZ9/UR513D+jgLyM+4WY5rM?=
 =?us-ascii?Q?joPxNVNAabkHSdjtRe0euI3auc3yCEqW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81dd2bdc-3eca-4f3f-8f8d-08da0c994409
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2022 06:49:23.5478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dM1IIiw97f+3vKk7FX3K0kjxtX1T4V1s+YATqyf/aZnXLHHCbWvwdDN/g4So0zOZwkNvVKv28SkPw2beayEbLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2831
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Kai Huang <kai.huang@intel.com>
> Sent: Sunday, March 13, 2022 6:50 PM
> +static bool seamrr_enabled(void)
> +{
> +	/*
> +	 * To detect any BIOS misconfiguration among cores, all logical
> +	 * cpus must have been brought up at least once.  This is true
> +	 * unless 'maxcpus' kernel command line is used to limit the
> +	 * number of cpus to be brought up during boot time.  However
> +	 * 'maxcpus' is basically an invalid operation mode due to the
> +	 * MCE broadcast problem, and it should not be used on a TDX
> +	 * capable machine.  Just do paranoid check here and WARN()
> +	 * if not the case.
> +	 */
> +	if (WARN_ON_ONCE(!cpumask_equal(&cpus_booted_once_mask,
> +					cpu_present_mask)))
> +		return false;
> +

cpu_present_mask doesn't always represent BIOS-enabled CPUs as it
can be further restricted by 'nr_cpus' and 'possible_cpus'. From this
angle above check doesn't capture all misconfigured boot options
which is incompatible with TDX. Then is such partial check still useful
or better to just document those restrictions and let TDX module
capture any violation later as what you explained in __init_tdx()?

Thanks
Kevin
