Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207736C2622
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 00:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjCTXzC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 19:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjCTXy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 19:54:58 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2001FCB;
        Mon, 20 Mar 2023 16:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679356476; x=1710892476;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nRpuQFTTOlHDwBrIOmvP2g37HogdHk1Xyx7X657r4pQ=;
  b=AOVHaNpZq25DRSG5eXNT8RjaRU9vtG185WqoOKBRdVrtyVfFJLtl6SaE
   xMGmjqXO5heHfHKE/b9fl9XRy+McBTu/7PwMjb4JOn0i5FJ6QZeSgrfWR
   xV//oDjU4GDwuf/OGwyXATNqhYy13O6yrkAxKkxzkFMmzRciPTh0ePChG
   Ulzz74pMd3C5mizDxoYC7/W8bbHqivkG3EiR+mCXVeV/sKgiBVBIIOS9O
   asj3D7wtWd8DUe/6cKtFHFa7b1co7rPup6+qCYg7SDx0OP5ZF4OFMDkOO
   wnzuHYxg0MGU5RuXPDTLOKxl3cO1Xc1/Gp7O6kdVTW4m48w9GQtoak4nb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="401379680"
X-IronPort-AV: E=Sophos;i="5.98,277,1673942400"; 
   d="scan'208";a="401379680"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 16:54:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="855460745"
X-IronPort-AV: E=Sophos;i="5.98,277,1673942400"; 
   d="scan'208";a="855460745"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 20 Mar 2023 16:54:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 16:54:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 16:54:34 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 16:54:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PmPfsMssrBEy+Qvvne71PRbvaGY7yt96KE/rt4trlfDMguv+NV90eTRR2+m4Sct3vhRixyy6Bt1cgNAsiVQoTcfWHXkR8MS/rNkPZEGwDxBe/afhw6RuGCEDu35GoyN8mx4sFNz8dP3qUUqVKxvA8RNVtRXeBoyCXkgJcKXeF4dsoHgIT8ODHUzdzih9+HMO0/X5KwZB6Bm2DeUZlvjNrmfxtrmqBscAV2yEgDlntWde3Yye4wXwBnp7IaAdjlb4V1bLmv6Wcgb4QiZWGuwGYoNyW+AFtsSbS01+p4u1cdvIJCzVW1sUe+7Khk9WZGwdiY3q3KbJYuHpqFswvwFw+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HsnDxS7l0lHrMYoRSJtNmi2bEGWOzWVUOiBDJghF4Rk=;
 b=FtJzKuTtuvA7j6VnsKOuBeuRQFq4b1NqNNUNC5z8/MGhSeL6PbhoJ/d9rUuS3yXdsoODV/ZiDKUrVJZFTYh/l0z3dnoEb72RvgMTI9Qqt1Jkf1V/VDBBIssgg12tBDw4IVyb+qk2gFpvAiSPsJvGe5IY3pbGgnWelD8EZagO7u8wHMk/HMmbwp+vgdJ0Sxotzl7GfGBk0pRO5z9qZ9Jt2A6ew/HNvRywlFxB9CLpgbdK1hmOGZWHlO+9H7ADmEsdc6bjFFsy3aMTH0fs1jQWt1cxeML3/riVeCoo+q0Dx/3rHOeBvwPEV+S/0jICqGHEqDHRVRDYBGz9lM9AtpMTcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by MN2PR11MB4518.namprd11.prod.outlook.com (2603:10b6:208:24f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 23:54:32 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6178.029; Mon, 20 Mar 2023
 23:54:32 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v5 23/34] x86/fred: update MSR_IA32_FRED_RSP0 during task
 switch
Thread-Topic: [PATCH v5 23/34] x86/fred: update MSR_IA32_FRED_RSP0 during task
 switch
Thread-Index: AQHZUKIQEOuHchhjNkaFGLQ0E/KREa8D93eAgABz+TA=
Date:   Mon, 20 Mar 2023 23:54:31 +0000
Message-ID: <SA1PR11MB6734A6ED3EDA2525A28C951DA8809@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-24-xin3.li@intel.com>
 <20230320165233.GS2194297@hirez.programming.kicks-ass.net>
In-Reply-To: <20230320165233.GS2194297@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|MN2PR11MB4518:EE_
x-ms-office365-filtering-correlation-id: 74607d90-686e-44f7-084c-08db299e7353
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tN5ONfJIOPr15tWwrufBBH/QJ+I+/zpVvjSIQyUAWeFnM3CzLtkkfjYsCQ4VnO5jSJ/1y/LaGk0fbR4+T2RzcuxyHhLtck7e6ifyq5Lu5V3QBoA+BVKLQyZKhlPnzRMvmULCiS6O47hW1wkgRUUIvQgx2hqiBC85Hp3cfgwGMpfvNkoHdkiE5QEmOiYAsQh6J5S6vraBdTMICBCEETkJeBG8m7ejQglSlXjgA3OQ+sIL0bMJvFYZNxRmeo+M6qUpfVCMJ3hQZaHIgPbiwPeLwfH4IVZdGU8R2rsJrcW3wmzBqTPyhx+ZVbjPLBVjtbLXlSh36N11jdvXC7FcMAEOs03vzLMsXRM+l2C+9p270YllvjhOyz8SlQnV0j2Pmns3W/rfZKQbLjY2vN1t4Q3oR+/NVdklRZYMTsH0kaSNjtDR+pn40taiy7ZLjuy5+NXp0B+CIPbEcJyRmxaZfn1No0MWuPWndxi8SeJnjl1/IArJKx1DnDcQL/+o4tWXJ5S2a3PlQfbizoVOABFuZ7Njoa5X5UqjiwVTXh6iKQ00n8vgHVCY5mtiyCZoSDi/lNrNaCl0l2YYhafjuthScFKmmswmlBc/rKatfsUAT3RBQxJcefWUZwE/7PgmL3v7/cAMFT3SNiw0z9RYs0PoTMaXFSznd1nwT1e8OmzeJ2ciTj0IrLZtr9HNn0i0sS+GTuzrlMSrQyEDjdOqtnWbFSDA2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(136003)(396003)(346002)(376002)(451199018)(71200400001)(4744005)(8936002)(38070700005)(5660300002)(7416002)(86362001)(2906002)(9686003)(7696005)(55016003)(186003)(6506007)(26005)(33656002)(4326008)(8676002)(6916009)(41300700001)(316002)(64756008)(38100700002)(122000001)(66946007)(66476007)(66556008)(76116006)(66446008)(82960400001)(52536014)(54906003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gV/DwPL+J7d/G85wJrwx0lQ2L73z9D2v5ecmzm9qxJB32yuuW39IGz6rdeeD?=
 =?us-ascii?Q?dU3eh8dA6/LR31kw4SVgDOyXC8FJfmztsuMJpo34MnA2uCmIuqnPA6YQhTLP?=
 =?us-ascii?Q?uFzLPTqRfs8XrVQZQcCda4kQOO1q76f+oHUm5VdH0yqUuXtYpcoKe7WFF5ho?=
 =?us-ascii?Q?p27XK2BtNsAIksY63av/nBy92BAK0EPUz1N9wUFqK6/2HawHPBRNUQKgGmsH?=
 =?us-ascii?Q?3BE5sI5Iwb6ObbD9CO3O/2hJZdcXfordr5nXEPzwn33Wka+bU49DN92Wnotf?=
 =?us-ascii?Q?yUxkGOjQCqz2I0TVY0qzkU3pbe7jtdc1DmeBYKzcNh7Z1VNLGy+l9TzHSy7m?=
 =?us-ascii?Q?KlOjIJatny7CgI/tdBXqfv05BnXDC/LLwmbaJL5IPBqZ26C4nnAuyd1h56lc?=
 =?us-ascii?Q?Y+oraGaHDSFc5X8dZ2FtydPtX7Ou/svSI9mrA5lkJ67eH1ah3PpU1e9SKf3l?=
 =?us-ascii?Q?CzyGzCvE4pqKohvFbRr59qmLikJgwfJ8p3TVnwOFiY6/49E6MMOt8PqyVNyn?=
 =?us-ascii?Q?TzW3X8rJKCbO3DWuA3FtK23n+sYsBYo5MzAWBe/9jkw1LbXCz7qrZBY5Wv6X?=
 =?us-ascii?Q?Y2Dc7hnON4lL0q5jjDzPR8moHkyGsNEg1Lg3zJAs0HLIbrk5jBcDhoo+7H6A?=
 =?us-ascii?Q?nZqs6Q2+3Ti/cwd+YAaFT7dgv+Y3B3kBeTM1dhEk/AAAJBua0mlXr0Qw7i1v?=
 =?us-ascii?Q?8r+s78+p450ZPHzN3/7sJ2ZM1SMPD1GbUXXz6ST60V8s6qLXaKS8AXRO4I/W?=
 =?us-ascii?Q?xXQXhzsB0BDKGq9QnlADVFTYSvaRXHGHeE6GeFG1yMTixF5p2ibI/7MXNWPJ?=
 =?us-ascii?Q?GbFiN0hkd4oLW6JVzGNneJeUX72DktNDptexgTz5HDmXNNj5e1w96G0ZLP/7?=
 =?us-ascii?Q?1q3anSKBVcBblC+e3Oz0YPAK2SlOtdjVF5dKgShCoLnWdyAElwMqClbHKsJG?=
 =?us-ascii?Q?aFgk7oJIuRRgAFbHECxjq+hwnPHl6foSnM/71nDrVqwbnpSoAje3N22F8fJ1?=
 =?us-ascii?Q?eodnYEuNLEphyjvaedgiEGlb+j2iBhsm4T4ztGwADI3hn5tXHmNO6KlvrYf5?=
 =?us-ascii?Q?AdJ/+WtfxRHLq1+XpMJi/0W+9/COBke6o3nW2HGMrTfIksSkLpKv/ByhzvRC?=
 =?us-ascii?Q?LTEuCAAnUgQ2BO1g+3gA5ADBc5nHatcc5zZUIEq/o1ohzfUtqctPWNj7xFG7?=
 =?us-ascii?Q?KfsK0RtCx9VA9ME7cRpEqJrFvKTt7YkVZcPXgUe/5HXAY0Xvs+2bXetmkCg4?=
 =?us-ascii?Q?ZQX+TRWBjJhYJVpyOemldtz2RbGiBz7coGl6F3VI9KqrjGrv0daQxmA7mgsz?=
 =?us-ascii?Q?+Az0LwbAqI/ua/5FwrzeH5/btaBP33Mt/vlaNKy6jl4JFMQGnd386Sua4ZT7?=
 =?us-ascii?Q?6KtFVdVB9fOB2Y2Dvbt0E3BnCguIlghkGqQYw0FMR7cUBBp8vMAoiM+L7Zu5?=
 =?us-ascii?Q?zGuYaTT0Tsnmn7V0KygLlp+1CgONccxaeyNnDNM/OM292BAsl3LPN+plOvhR?=
 =?us-ascii?Q?Feej6Fdb/KavMEb0XkaQ90n2Xn7sxf+zlRCcSNz0buKI4QvFzIxKHDm+4frk?=
 =?us-ascii?Q?2Wzh4yEXT4tUoPoa1d0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74607d90-686e-44f7-084c-08db299e7353
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 23:54:31.8825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mGD2hFTuT2yi+XC2WR5lS9RCQqfOzDJuVM8calHDNHypTXjdjrLLx8It/fnSXtxbpwZEcnFGm4IA4wxIdQhEKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4518
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > -	if (cpu_feature_enabled(X86_FEATURE_XENPV))
> > +	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
> > +		/*
> > +		 * Will use WRMSRNS/WRMSRLIST for performance once it's
> upstreamed.
> > +		 */
> > +		wrmsrl(MSR_IA32_FRED_RSP0,
> > +		       task_top_of_stack(task) +
> TOP_OF_KERNEL_STACK_PADDING);
> > +	} else if (cpu_feature_enabled(X86_FEATURE_XENPV)) {
>=20
> Whee, so hardware will really only ever look at this when RSP0? I don't n=
eed to
> worry about exceptions during context switch?

You're right, we don't.

RSP0 is only used in ring3. Exceptions from ring0 just keep using the curre=
nt
kernel stack unless a higher stack level needs to be used, e.g., RSP3 for #=
DF.

Thanks!
  Xin
