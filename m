Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79381723AF6
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 10:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbjFFIGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 04:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbjFFIGS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 04:06:18 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49039A7;
        Tue,  6 Jun 2023 01:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686038778; x=1717574778;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AlU9c07hIZVuhT/r4yGtm3OMfLW5QtztlJj4hNRpa/w=;
  b=dQHlOjxUU+I71Jbs/z84STCCrOPILGRu+049O833x7tzGOUxMafkolwm
   dQq9YTsmmxnW7cQcQkX1/r74Wm4YZXnjZF9Q7fEPs45AD6vPWQR8ytZaP
   czn9AHdlBlUVuATNB5x+WBWBWTblv6wblVfAJZxsCKbyVUSQk1ayLCD6a
   siCepX+cAtsjeTw0t9DiECCCTlUV5yZh+njLEz9gcPazDwxASwjCRUWPl
   QmuGRBIYM1ClYfFKoLi2rZ9og63Yjq4fES0nZVTxsp141VSqIx5mXc9sq
   9uSRAIP6i0VOlG67XTgdsjjkOFi3aODm7AVZ8SW25hiWkP+ATOg4/iSB1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="336224564"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="336224564"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 01:06:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="853313356"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="853313356"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 06 Jun 2023 01:06:06 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 01:06:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 01:06:06 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 01:06:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asg8aq5KhwIdjvuSeSSyHRMcLBvL89uoUrWPlp0xfIzrN5oMSr/5akWQfU7pEdF1Z6OvhVr0Vgb7V/0PwzqQEigxxYilkKGQIEcIWUQbcZowpqcSAQThhRuBxsCLnaceGzk8Vq+KPmLWJL72jkCMtqz3Xgw0Nv7fHAWwaSfwUIcRaMEx8Ep+su6tkoLXcRZPrFcyD/NBrty83u6GcQCMXObiRlafut6b5F1VrrgFqX76+jtwdTT93UV1TzA0ECBpr4greLy57SMsvtbhhge7TYqX4wYBDqOY2vdXoJ1JZ6GKj6vCSlfY6Nx0xIwPnnwj4jO3L3EmheG5JuRb4IXo+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AlU9c07hIZVuhT/r4yGtm3OMfLW5QtztlJj4hNRpa/w=;
 b=GXJi3xJ1j66iWKzLaw9WGxyjjatqc39nzN1/HElOxxOhJWLYU0aOJx9kqZ/LNfy+6BP2K9CidekBPKtu0C3q5xsSadnqzTWIGsJHRk1jV6S5iyDuk4Q2eUAaeiC9yFEND5RfaNXfY5wlQDIrKch3wfH1bMpFfQuChXLJz3lWAj87ogbN+e1DK+e7sf2C8Gkbipn6yWN+xjg5+fnlR0zrrYQ9yVNttNibG7ybmjaPLkykktWQJrgpTkO+tNwno8vf1d+9w8HXeazwX74iBxpPf1GLXqdsLAGMtmi901RezNPWSvQKAyXuGBmwCO4nDsVYzp7ftK4B9ZwSr/gqY4Zwwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by DS7PR11MB7860.namprd11.prod.outlook.com (2603:10b6:8:e9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.32; Tue, 6 Jun 2023 08:05:58 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d38:3229:72d:88a4]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d38:3229:72d:88a4%3]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 08:05:58 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v8 03/33] x86/traps: add a system interrupt table for
 system interrupt dispatch
Thread-Topic: [PATCH v8 03/33] x86/traps: add a system interrupt table for
 system interrupt dispatch
Thread-Index: AQHZa4hOKZXMhio+zUqz+Q7AFX3w9K98OigAgAGJbJA=
Date:   Tue, 6 Jun 2023 08:05:58 +0000
Message-ID: <SA1PR11MB6734EA7912EFC0642AB18E5AA852A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-4-xin3.li@intel.com> <877csi8fyl.ffs@tglx>
In-Reply-To: <877csi8fyl.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|DS7PR11MB7860:EE_
x-ms-office365-filtering-correlation-id: 05424213-8783-4400-9474-08db6664dc65
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zu62fjo+H/Lm6+dUD+5Ubiu8DjotM7uazV0l0EQFtV4RkHSokGkoXNZsjokbc8O2JL8AXZZjphLKpY+o/5aJDq3gAolNdrcouz2JrTWBVP3enHINV00Lwuz7wcxd0XbzfZe1hf0EOM8iMGfzf4JCxDajoJSTsdGLFzxY9DEFaz1KgXwEDOs41Mg6dE3G7DqeweMW8X8LlysORwsrsn3oSdclgbuJFVot5zfLUcszFlCgK4WPcvC+XREN5JXNEoRVrI7cXNZ4T+t9OLCxH1OX0mI9vCUcMzuSmbPHhVEK7x0x3BKm69pEaKr2gvDfGS0GAdjTzrZIp0B4A4AWDsKUu9nnidELk8Bk40jYrhKz64O2RHb9mX6utlLhPOzh0kJH9j1MC/xdZYEeVu5EkFmTH4ChZEm6VrUnZa4IgalI6dSiB2hUDEfp/WSzx0uQEWFzbIYvN4bRbTNGZ8CbzOQyEDGiUt+dXvdL5gL2SELj3gHo2YL//R//07RVk14Ti3Ln++70BOcGM/HJNTTJJspLMOK5a7A2j4gR12Dlip0bN1jnuATckv3YAeqVBTV5DemCRcMVFVwDtVWzHRcBkUkbglgPl/nko78NrlD0GC/mHl4dGKI9rs0uTBRK5Dpgd4K9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(366004)(39860400002)(376002)(136003)(451199021)(2906002)(558084003)(33656002)(38070700005)(86362001)(38100700002)(82960400001)(122000001)(55016003)(7696005)(316002)(41300700001)(52536014)(5660300002)(110136005)(8676002)(8936002)(54906003)(478600001)(66946007)(66446008)(66476007)(71200400001)(4326008)(76116006)(66556008)(6506007)(26005)(9686003)(186003)(7416002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/HYOJbtr/QY9cCHHxKrB9Qvux0m4sb0BTc8E9v/qeVcSjUmVkxhFTuRlZRwW?=
 =?us-ascii?Q?E8tEpVnTJAdQuyOkD9/leqFp9OsjDhZOduAgpsQdNvGfkIhzt2tr4XDt8AUg?=
 =?us-ascii?Q?8JF4l3NpYs5B9F8NlHB5b0sSJ8u1vJcqTl8AU3Edo5HiBl/V5kbqSiQZbEp+?=
 =?us-ascii?Q?/UQQ8dMXtREoUL6FEinx7Qf4pP6KyJNnZodpBGE/cqKTmVVXlGpwgS3ER3r+?=
 =?us-ascii?Q?qmdTCV4WUd88KyLwkEewYa8XhRWHuq07MCUAIbvgDCZX4geKrlBR7m1ZaooW?=
 =?us-ascii?Q?6fZZsoFDGT3d28OlpdWXfe/GukFjuJ5QHF73deKMnpBQPkoy598g4l0AjLhZ?=
 =?us-ascii?Q?Jtiorb/tW1ZIWePgtmzc0ze2qi343vI9SVk7nME79htFYjQjgVefwjPhPxf+?=
 =?us-ascii?Q?W4gFwD9liy3IjHC2O1qAqLGFByICPLb68Ja2E5McJYsHNSfqsnEI/zu9tuob?=
 =?us-ascii?Q?g1NoZsSosBdu7tctmZScmuADNhEGduHAAVI0Xt6NyWhzB37ZS2iYRAUXFui1?=
 =?us-ascii?Q?8eEacCu5/CGR51Y0LMzIp8ldS52RmMSiI1f8DuoR4jEkqrxtisJsL8Njpet3?=
 =?us-ascii?Q?gPxc1eIGWEYfdCn7GUK2oee2e6u3G16u5C9zCTfHH+UeiXNvBaet6WKBNXRL?=
 =?us-ascii?Q?+x+OAIzdRvQG8aZ36/lM9iHDeyVTgUZJQiMGy2ZUas0HvOwA6YmLGytr+2zY?=
 =?us-ascii?Q?Zfhy+vfeM6FJ7v5n7gw3BvHNvVeXLBfjZ+HKt4sqla7lG0dffW0+nd0cLSQ4?=
 =?us-ascii?Q?RszIpeMt+RkSd+TU10ix/Kx6OfHbbdzNOniWolqmCab+kPrNLjN3m3RVMHyY?=
 =?us-ascii?Q?pfyPBtLix+dlk3tJG3Q1sPZwwogwXUzL/97jI99AL/wz/hl7sWz1eeJaqj9V?=
 =?us-ascii?Q?kLfndmWofhs/aImmExVf/PMp5HfeFaBm6ue7Qa/JKryqU5FGkyMVdOby3IKe?=
 =?us-ascii?Q?v5+BlrCHQ0+n91WdtIgxc7taIlnegTq3WZI53ecytR1hYLcrU8GQMauAYxxA?=
 =?us-ascii?Q?wGyN0Cauuqhz0a9TD+sN7w/C4bDD7Cnq+lWwC8oQD/nzDSZ+jVZqDzXnjSGK?=
 =?us-ascii?Q?M8jajtaP4Z1JXt6Ap1uqw1Cs1Lqto2p4GRNShmNyKUaovcaBoIE/1iNPrs66?=
 =?us-ascii?Q?76SEgf8aYRqsmk233VzxQpewmH9q2fzr1GzUJoo1LsqWt8RIJkpbW1moP3HO?=
 =?us-ascii?Q?6JQyDX4ucUoSc8myNyaG3iIN9AfH9+5uIuxlMfAydDkM7dPiuak1TbnEG66p?=
 =?us-ascii?Q?AsZuYqEXHr+rhhXu+lC2U7FEZ3NSiscYsffNcgKC/qxoCwcixl2OEDxb+SHf?=
 =?us-ascii?Q?7wH1TFDDzKhsZyLElzEkE+eCTiyUn5Iisfp4dGutfsQwOjCx5YBbDcw21Jhk?=
 =?us-ascii?Q?iLgbNPkW8YejZA1zzaWaMrRifeS/j4RNCT9Bx8/6hc2WiKDNbjVGkZgNqptu?=
 =?us-ascii?Q?nGaTAOpVW+kbd3R62jQzVZ+6BF6esVIhVipmkXAiwIKXd/38WqBHXPECVP95?=
 =?us-ascii?Q?qZmVDZ50oi5DPhwFcmc8yOcGT7WOyAn2avtrixKe/40Mor33VsE+zKGar33r?=
 =?us-ascii?Q?5a3jePVzX2bLQcZIpQ4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05424213-8783-4400-9474-08db6664dc65
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 08:05:58.3148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JUPeJ/bkQ4l6WNCA5bvmpbJzUpIoXBbUANHYjTR2saxF5vh1aP+y9ybMg7ZTEEBiY1N7xpEA5mCYV7toeXELBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7860
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +#ifdef CONFIG_X86_64
> > +
> > +#ifndef CONFIG_X86_LOCAL_APIC
>=20
> Seriously? You _cannot_ disable local APIC on x8664 builds.

I didn't see this is explicit from Kconfig, which caused the mess...

Thanks!
Xin
