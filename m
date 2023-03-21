Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563FD6C262E
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 01:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjCUAFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 20:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjCUAFB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 20:05:01 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AD0EC53;
        Mon, 20 Mar 2023 17:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679357099; x=1710893099;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X7MTlWqbIOafoIInhMNwnyk7jdxWh5VPPNgMpiBpv+E=;
  b=kJHld4mBHcuDnvPapQzUOi5Ebj62O3qTdUbmi5kqQx5DZ5eKVc1DsHTM
   Kgxz4RUt3J1Ca1NdC1wvvTEHBarfAEsWgvAfo0hx5zZFMlIr3TuOCUelp
   EgKGuiS823IIKSxEfG+KPWnjUW3WXNOGpamNxN0rMX1l0R2DWUGWVX8kt
   BnE3lOj5YPaymuh0dYMFVb44YGrf2mnPpX364NRAHgs9dv7YbmytB8qbS
   2WT3v067N6UFV9hszCI2wcyq6RN7jAl3g1v1CypGouQv2c6Vm5CO4zclu
   9SW3B2aNR4LulNuVEyzDmXEibv2cBatCmOT6hTW1HO3aLqKbU+4aevLS5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="318458146"
X-IronPort-AV: E=Sophos;i="5.98,277,1673942400"; 
   d="scan'208";a="318458146"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 17:04:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="824689798"
X-IronPort-AV: E=Sophos;i="5.98,277,1673942400"; 
   d="scan'208";a="824689798"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 20 Mar 2023 17:04:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 17:04:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 17:04:52 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 17:04:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+Tz3h/JIc7HbjRYAS9UFD+6pREbLJWO0vlM9wNoMRvMQFbKYuWqP1ufYsQg6XqEl3C07OcXP6uXNxT7o/KEVjg0zQ0+0CJmFMZGLi4CoFFxuwCQbEfo0z7LuapIC3t13Oq6sJd4gHkmxteQYHriC0BQo0Yi+umZxlFdJm6SdQpkeU8/RRpMgbQYi9yd5pH3U4o5YEQRavg/xhosMRFlvlYkJ26rZ5S4PPSP1IhDokEDpKkSD3ij2uhBOsB82ssB1G4miWUSnQsubix5b4W7VkfM0DZgEHwnoxZfGYFEQ5Mcm4CeXcV/817EoUvg1nK0G9iWQ9OpUtXOQA81/Nm7Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8c5+Ef+lnaaPslZkE27sIKl9twllBFrZkdVPK74w9Fg=;
 b=WsaIVhX6tahghxw78t5RLQkUMY8zLgb+o3Gxmt8BpTwiT6jLYKhKsRWB0blJlx6QkV8Q5K0Wwgn/6AV42x1BDnQzegLeDDfUbUgkrN3pOZhmTRWR0v2Gc5+lrKyNS7ITfk4kKyZP8cJ9sWRWuRtA/TY/8pnH6VJYb1sPdviJiQWvxNhJp5URyVgXqVO2p8WVWF5Dji32vEMl/wVWNMm3Ei3B2Or4GFS0t31u6Zn/x/Xn9n1sdphLYpFfCRj8ZMZaDO7bEEPRyuu4u3hW9zGAvHz4JwSD6acycF14lP0VFwzEuaGIcemmcMdHr15eVM2Gbsg4w3PKxyFaTRDpcxyJmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CO6PR11MB5587.namprd11.prod.outlook.com (2603:10b6:303:139::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 00:04:48 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6178.029; Tue, 21 Mar 2023
 00:04:47 +0000
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
Subject: RE: [PATCH v5 20/34] x86/fred: add a machine check entry stub for
 FRED
Thread-Topic: [PATCH v5 20/34] x86/fred: add a machine check entry stub for
 FRED
Thread-Index: AQHZUKIOC/3kvxGGb0mH1uURdpTy+K8D6OGAgACEs5A=
Date:   Tue, 21 Mar 2023 00:04:47 +0000
Message-ID: <SA1PR11MB67349805EA11F4BAD07D62F9A8819@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-21-xin3.li@intel.com>
 <20230320160021.GP2194297@hirez.programming.kicks-ass.net>
In-Reply-To: <20230320160021.GP2194297@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CO6PR11MB5587:EE_
x-ms-office365-filtering-correlation-id: c08caaa0-081c-4b51-b457-08db299fe268
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mrbzn+IeFhAByVN7IaJzf1axDhumF6H/zrOTFkF9qvN8fdLQZXHmiAI2K4B3vMM3YrmDyVB6nHGnivJbaLhIufPqE+gDN7CZhQopRnd+nj4PKYbeuo74PgEQ9gBJgxyjL2dYOUS2Lcwc1+AOvbeKidyg27pVD6zhN3kQqMSAz1jEVsD+Retkhk1sEpuV45QWlNj8bmUQWjE/dvdLt3dynUCnO8/iW3LiG7Iv/0/ElsfHY+qDfh8OQ9ALGvx9r4miwvwJo1u3kw4IBInxdGEP5P5oP1ciRGqaciD8tcdshf7rbRe4QyTjYwCnm+OneHPKExz/FShbwYLXRCelHqb3nAEwbJXntF9JwxxPDpP3+s/917tN1RVDhRSW/pgaLJP8EzLTo5u2GwJRHXCHI3r3QeJMzzbgzbhxNIrDT5jrjPwkp4TMVAwiUCkig+xeOi1Uvc5yyYp57Vg1TUE3ezU2tDKCChNGsO5CCWcqtV9X/QsxRjPQhMT22FLy6jzsIDGY1ApetF8KGK+2H/7hd+4dxrGlJTCUbIqTMiQxxGakb7UUQxvprCdBQnobd2Gf+Sh+XTWkL4ac5Q3EAhwgFKag59oBrmP5YneIWnzilM4h9MHjoa1IBbnnQB2tFiZ/ja5gbpjQGzZzcEkKeVommsfWz77j42BXQTmmCdB2eoF52RrZqj6bTjvsrZzMSyHmDqgAMAZvU3sOIpEI3eZCDsSl8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199018)(7696005)(71200400001)(186003)(4326008)(478600001)(83380400001)(316002)(64756008)(6916009)(76116006)(66946007)(66556008)(66446008)(66476007)(8676002)(9686003)(26005)(6506007)(54906003)(52536014)(5660300002)(8936002)(7416002)(4744005)(41300700001)(38100700002)(122000001)(82960400001)(2906002)(55016003)(86362001)(33656002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pI0SF5+kbO0gljveCHxJhSEs9dmnIuv25AMeu3H/eIwWr1tQ6xP9PYoNEs0u?=
 =?us-ascii?Q?/mzzNcaXiITC6nScC7oubu4lzxfHwAOb+hZTC9VzfTBUj3KPoOww3bsBtpB/?=
 =?us-ascii?Q?bbjGd7i7RzGtr4Bnp9ItIRgxIfiLYRYaF3nZw4/PUfkY1+swTOYFYHEK440x?=
 =?us-ascii?Q?wv/9tTvi+0baJr7WgfDwxZ0Ky8DoobKw4DalkTccY6m1Ar+LSqzNTherf4qy?=
 =?us-ascii?Q?2n4bwRUZzVAvd03yl03WjDIohuF8K0ciG1C6LL9AUzIHRTLCBNC5m6T3MBAk?=
 =?us-ascii?Q?XdBzpg98UjF14IsOMn3UxPLhBw6aFu04ADxnraBJU+53CCqOFnwtzIOpKNNp?=
 =?us-ascii?Q?jO4Vtip2f/oQ8vfd4RFVcF/D3QXe/7qnPWCTrQpEbRwtfb3NIELIhWQPUc5q?=
 =?us-ascii?Q?8QpTZOfSb8V3QjJkYYX6pBnnenKXkJTcU5wCRsFwHUv/vfxXQ2FOWN9TayLk?=
 =?us-ascii?Q?5azaDbEV0s8EVfQQtCVgHyP2BnGkHh9SOhQIXlRem7agL74Q0fuviJO1uxVr?=
 =?us-ascii?Q?/B6RIMYCAuLj8H01xNxuuZb0IcOHFfZDEMYcUm2SwevFvWu7fIKDZliXrbje?=
 =?us-ascii?Q?yRK4ZLIEKIjS+zGSzYqYNTg5xqFwlPJbnvz0VgeE82/K49wm0Q+srkDZ2iHq?=
 =?us-ascii?Q?ozku5tHIT+YCv2evFP7ZXxbSFO1nR5TMWCrw5S/500oihjIatCC9eKEiQJy9?=
 =?us-ascii?Q?/nTwvG6kFoiihiMM4car+uYIdA8dOEFW4cxJG6YCA56qDDt0OjxDREj5KaDw?=
 =?us-ascii?Q?8/Xa5K1Bpd7tlp2ifiUI7JvIIW3SSwACrMmf8K8hN143ac7T1Cuy4KD4II9t?=
 =?us-ascii?Q?cD1RKG1dcN0vYdMlIR0F9fjltTr3TuwcVkbil3xBbYCUdkX2ZlM11qkLLzTv?=
 =?us-ascii?Q?nYe+W+HFKzNd2wp7cKx02iPTObJK0RcQllFsTuG/R4F83mVdU64ESXzv+xiv?=
 =?us-ascii?Q?NoEAUcSx7rV1NqxdtcAd03O669/H864tYvCEe9Gh9ADvEDfUpfFz9xb8LZ2Z?=
 =?us-ascii?Q?VQfWI+DKnmRUPw8X73AlH1lIlGSagNppDIzavfSxZdoBOrD4J00BBJ9GFcID?=
 =?us-ascii?Q?LhRPT482ZXOEEOD44ykibxrG2MulCZkHCBS0NL0OjJOjOe0w/s3vtkrS42iw?=
 =?us-ascii?Q?BKOCtdRCCVW142l9j1uoXheAJ8WHI1cdOSAetLJTtRQemW6rvfh1INK7zCLj?=
 =?us-ascii?Q?q3ALb+dAJJFnnpC6X6AqRojNGYYWO4D+gEn8x0mwSywdGsoiQZ0GU4ajr++D?=
 =?us-ascii?Q?phkHHS72uZD/dKarhUmRae2H3EzBAwAW6DQ0y3ZzPfaOaccEZtVXPj1W6BHj?=
 =?us-ascii?Q?Xkxvu+ChTlfWist0fYBizMxO3vsCWyJfFfr4JplUavI7VVKAXeAR2URF8jVd?=
 =?us-ascii?Q?daNHslrT+8BsmHF3BvM3g4A1NTTC9TiRgA6IS9mahpcutcfNsVKRuiOfzxKb?=
 =?us-ascii?Q?TpxStyg40GIS9DEBmB2ee0bl7mH11nxJ3SVf2eSsWc6zVVgRAzD9BMmyUXEH?=
 =?us-ascii?Q?c+c0s0F7PVmH+JePGEzzIGNTRAoq+gvRBaFuVq2Y1aViJZf4Y2q080cM8q4J?=
 =?us-ascii?Q?wDn79qm4jYEuKkvxIK0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c08caaa0-081c-4b51-b457-08db299fe268
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 00:04:47.7952
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aVlduY+/6m/Z4eG3H9CsEAveftFCv+opccqiMhAe3CKsID3hPVgYRntUn1T/wrXyvtGgdd98HhK3LZ1r8vzRHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5587
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > Unlike IDT, no need to save/restore dr7 in FRED machine check handler.
>=20
> Given how fragile MCE is, the question should be, do we ever want hw
> breakpoints to happen while it is running?

HW breakpoints still work if they are properly configured.

> If the hw-breakpoint handler trips on the same memory fail that got us in=
to the
> mce the first time, we're dead.

Right.

Unless the MCIP bit is turned off any subsequent #MC goes to shutdown
("machine is screwed").

It's the kernel debugger's responsibility to decide how to proceed in such
cases. But if the kernel debugger itself is in a screwed memory region, we
are soooooo dead.

Thanks!
  Xin
