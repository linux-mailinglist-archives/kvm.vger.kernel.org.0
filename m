Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2762665187A
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 02:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbiLTBqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 20:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbiLTBpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 20:45:45 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6035D1122;
        Mon, 19 Dec 2022 17:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671500089; x=1703036089;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fQ3FWpmN/ZTVQF7JDvfPw/YLgJwKwomCLjSZgDLLR+A=;
  b=hi9ULsVH1oPEnU2Nya56OPZf5gRm4Avqgw5rg0lXWK7bZj42grZNfYRW
   N557udqkDFVAud1vjEESe3p5NHBiXfpIas+jcgC0Z63d83qMychpwZDAu
   t7XVWE3p1twhoCSZvtt6wSu5YcMbiX/Hm4m/UXP4IwORVkXmTHMoJa3Y9
   3qEcCmM+okyFmF0A1oWA+mlroKcycO7ngiIuTzuf6aA+br4VFKOY6mM7D
   zNsGNxAEXfS1n9XzWAIvtMdyPPZ4m4BhETR4K9Ok1fUgraUcNt8DSCDgU
   9/CY6+XgTgVV/jnac3OxP89Gh/MXtS7cmJ6CJyyAP6nq8+48wf39hYz1q
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="302920529"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="302920529"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 17:34:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="644229291"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="644229291"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 19 Dec 2022 17:34:48 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 17:34:48 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 19 Dec 2022 17:34:48 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 19 Dec 2022 17:34:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jk2mM9rB71FHlFDPT/sCeJoB6aIT2eNlfVNiydtltVEhEpEe1VFjSKfruu7Gr/2nIXFv8wF8qLQb8y6OGQLollziR3PR6gpA52qjlEsTnuM+UM941Is5osVcQ0IyOSJxsP4Z+0WpweZjGNhhRk3O27pvrcw4y+dUV4fxXrbHSL70txHqQHWqmgKBKsKYBDS2dJ8xsyeiEjPKIoNX0FlpzQEJHsxyDA+aHRzmG+Oy/vjp79jHH5DUihJ03eJ6ntEcaVrNMbTDVNaef7wKy0uVVnL1l0ucbU3flnhryH9VwOqlxvga7pzbwpk3Decfx2K6bvn/KTPuZy4GxsymIFaDIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fQ3FWpmN/ZTVQF7JDvfPw/YLgJwKwomCLjSZgDLLR+A=;
 b=lfgL0B/lVh3PIenx/idG6i7Ag3A1mrBhk+LpfdlNgHj/PrDuRXQyo51vvEsK0MgYYhN4Y//yOK/A+aNG44HV0qoMf57XnwY1+a8ptQ9UbDKa5HUaFl/Avf2sAfnTqM898Kkx+K/g+x9G/hl+Jkw5kCVESHSWlIgUpD1swuHaS0bDp0AZGyvRkmhE0EGkeb18MeWMPMKLdFYuwM9auH44//PPTxThwJC520Ik03L9obRzLVytz0/7Tw8T1RoPkS9FqMtpz0egZJxYjbkbpWpotk6o/PF8sL+LalJyxToOq0J4doC6BfyOtemOX6b3AZFm18S4yPE5szBJjy7I50oaIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 SJ0PR11MB5056.namprd11.prod.outlook.com (2603:10b6:a03:2d5::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.16; Tue, 20 Dec 2022 01:34:41 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::97ed:f538:dc6a:a9c4]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::97ed:f538:dc6a:a9c4%5]) with mapi id 15.20.5924.012; Tue, 20 Dec 2022
 01:34:41 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] KVM: x86: add KVM_CAP_DEVICE_CTRL
Thread-Topic: [PATCH v1] KVM: x86: add KVM_CAP_DEVICE_CTRL
Thread-Index: AQHZEHut34nQNY6vl0i5iX10icsI565wwkyAgALfpHCAAhALgIAAR3bw
Date:   Tue, 20 Dec 2022 01:34:41 +0000
Message-ID: <DS0PR11MB63738FD0112507F78AEDC3CFDCEA9@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221215115207.14784-1-wei.w.wang@intel.com>
 <Y5ynFUdZXpN5HP7F@google.com>
 <DS0PR11MB6373187B53B558EF73FB202BDCE59@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Y6DLI7yA58NZmIVh@google.com>
In-Reply-To: <Y6DLI7yA58NZmIVh@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|SJ0PR11MB5056:EE_
x-ms-office365-filtering-correlation-id: 5132a368-d355-40ac-8b8b-08dae22a5d8c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: joRXDalMoWWOxvuFJesnb8bXwXIj8thBog6otoaRbuuU2oLtLsX2TzTLVzv5iWK96R2JaC5/eyMCNWpdThdH4MCP4gQKSFQOOcjd5wgicEbZpeNTT24JAz2BqQu6Ld4T3c7DlRLtxLo87SJgvmaO5MtVHcfyqHpvodMbg9PIFmWURBX350IUXf0memsK6pA2NsWLjt+6uc9TRhn6POyNFXQF6Vp2jPzuDDSlzD8O3GJczgxx5ZlGD4WdUbkuPSDsvoe4NNOswnaf9vRkTZJfAWmk3BanTxQo4hQG01npFCslJXRzkS/809PuBlyPzK+vCRM4cl43QHFQjkzFknUvau9h49ofbH6i8vYCZKK+E1Ml2vLbh57he4eW7auMhZ7cLTBu0cSPNmXZeeZkaGEcL5gIXec7sdmn398+Jn+uqMFwvYnSPVR4ojf6HkrDt4RDrTazd3Gihrf3MiNciQJrIH2SboD2xilSyQchLs3LDUd4iley+gGOcMs61vFwOUVVZAZA5JjzuS1zPMFAUc8gatEnb72FpVs3OMttWq3p4A8rX6C0UJ14I5hfJGVE3gQ/DyR29FiGKbpJFVwTu9SLI36nE14pM2v02RAmb4u/O2J9UM6Y+3oVXF0G2fR6ytUWQ+y1j1DfC3MRArNmG5IehyhBDB1hANC0VuqYGOpfD5Yb6KgATs9rqpYBUwVLeByiAG7j2QWTnNSwlgMhXTzBwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(39860400002)(376002)(346002)(451199015)(66946007)(64756008)(26005)(76116006)(186003)(66446008)(8676002)(86362001)(66556008)(478600001)(41300700001)(52536014)(4326008)(66476007)(55016003)(33656002)(71200400001)(5660300002)(8936002)(9686003)(122000001)(7696005)(6506007)(53546011)(54906003)(6916009)(316002)(2906002)(82960400001)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xR32QHA0u/knzjNZ73slsT+ZyHD1Xa+6QjxmgIn21HCV2Ko+6BY7QZu5gfGP?=
 =?us-ascii?Q?AjPG2Qlr8zqvP3sbEHopoCQ5RFPtlcHkA5or2cFMjt2pO1SjQ4zLc1qWjZhO?=
 =?us-ascii?Q?68pcJKhG57tLaHN5BYPrUcglvvV7eiEFoA01KlnSDukcYjTg9kTIHW/AL5X/?=
 =?us-ascii?Q?4BFEE/laIY4zlNaTnPEzdP6mjYGG8q1HFCovJJzcefwKlVQobEPdpgYLi/nA?=
 =?us-ascii?Q?uf2yzBYKVhPUrAAwyP7+Y3zwBbexebS1FsGd/K6p+MeyuksGRPP+rAyd+WTQ?=
 =?us-ascii?Q?xxnxnnpbHHRkCu/bPz2C/kqywfEWysALzuTr1/cLFAUgfshVp2ogI09Lfpqs?=
 =?us-ascii?Q?X1eet3jaGhDb5A74owGwBJv21BolmuGSdGrFVo0MgCbfKgVEpP/Gf59KYTJ7?=
 =?us-ascii?Q?d3hLle0Mrmx3CkZbaxqsdPDWhkneTK29e0ZcWcKWse+Goub63k3KEhhcZHTn?=
 =?us-ascii?Q?doW+BvUL+tIqz2cYc1/VIg5D0mHtEqLntMt28Yn4Ent49N/2YmEpobXZR2kw?=
 =?us-ascii?Q?Lp/7pC4Qe07Ptaje2fFg/7fdQkzVV6W7mxE0WvihV1OW5wsW53j1gM5Nw9GX?=
 =?us-ascii?Q?8N+Y618CLCgeTMeBO9lZUfVmS3rfGeDfEQZAyE9vGbl0AhP9YsfI0QmLFb4B?=
 =?us-ascii?Q?Jhf8nSH3ZKOSlxNkykPHyGyg84DXEZ9eznIuxckux606EagKYmUDQQRmZqzO?=
 =?us-ascii?Q?vKMqldOe+Tc1mNi5upbFXov6cIjxSw6zyLZfLPq01qeNLYXaRzxFeBgH7iDD?=
 =?us-ascii?Q?w1CAnGR6OydTiqyDmCfSKwTfRM50FY412DFoNWsF3fLXVw8VqOQH9/j2tKCl?=
 =?us-ascii?Q?kd2bkr+AGKIH2x87ke6WyOqOEZJiEfBHFMbTjoojjSvMU3DNCnmZuClfK0BO?=
 =?us-ascii?Q?zcjEiFiUBQAx9WT5SBxMcGFSEb44X0DB72bHmROHQ9xPL5lTg4noAOPflIlA?=
 =?us-ascii?Q?Cns93Jo08OYYpj+aZSBeQnuhdUg1a1Wnlgl255zfvwwRpyaJRMDLhyhFeDLO?=
 =?us-ascii?Q?co1wil9NCtbhi4J3MsIQn+i5Ie9SlG3P8vooYJHcDIKEPlLSWeax56iuCW1M?=
 =?us-ascii?Q?anivaLFvP9DJiuhrQdatxgTAELsvR5333EWFuuDrRkrE5CluQAtaHKVLf2In?=
 =?us-ascii?Q?ZHFQGvx3RNmVmKb15gBXinlSNtGkcZuXpqAyhwFckN4nTE1cijsSqxtIXcef?=
 =?us-ascii?Q?II70+GkBXTCb0PDpRP3TnGskagdtg/F1nrTQIOu6c8ZjdZEM9MxvTP/FdpNl?=
 =?us-ascii?Q?pFQU61Mv51SzAR2KVY7L8caZcv1BaucJqaGU/izUZVk4zuHEQmR5uzXURNDY?=
 =?us-ascii?Q?q4X5a6NMQ3j1n1ceDYmITqVUnwyM1npCdD7eKZqpB15qvqMZHM55a6PJ6Tw/?=
 =?us-ascii?Q?UrL4Nq58KMehLWaJjqlCK5tBAVn8uVhC4AmLsKOY61J/Faa2tFiXUctDD4Zc?=
 =?us-ascii?Q?nzbQik9Esbc6yAyPWGPb9wL2j5iv+hH3KmfrOKYPuB0XWT7AakpbeWSXMfkz?=
 =?us-ascii?Q?VWahHD7j84kmWV1BPL4r1cUWr0ABE/qIYxCv9nssYR6ibm0wITutm9KYdk0M?=
 =?us-ascii?Q?eQEUjMZqL/RwLkOvMXgwHMzo59BCa0Tqo/RuJBji?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5132a368-d355-40ac-8b8b-08dae22a5d8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2022 01:34:41.1873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MnMia2TjR76j2FajzEHWEmdw8UtpD2yATpRaE+m+MkRwKQTkzNUuAcnhJpyeS/O2pUV048ZGHb/w4M3g87McYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5056
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tuesday, December 20, 2022 4:36 AM, Sean Christopherson wrote:
> > Yes, it looks better to move it to the generic check, but I'm not sure
> > if it would be necessary to do the per-device check here either via
> > CONFIG_KVM_VFIO (for example, if more non-arch-specific usages are
> > added, we would end up with lots of such #ifdef to be added, which
> > doesn't seem nice) or kvm_device_ops_table.
> >
> > I think fundamentally KVM_CAP_DEVICE_CTRL is used to check if the
> > generic kvm_device framework (e.g. KVM_CREATE_DEVICE) is supported by
> > KVM (older KVM before 2013 doesn't have it). The per-device type
> > (KVM_DEV_TYPE_VFIO, KVM_DEV_TYPE_ARM_PV_TIME etc.) support can be
> > checked via KVM_CREATE_DEVICE, which reports -ENODEV if the device
> > type doesn't have an entry in kvm_device_ops_table.
>=20
> If that's how we want to retroactively define things, then KVM should
> unconditionally return 1/true for KVM_CAP_DEVICE_CTRL since
> KVM_CREATE_DEVICE is provided by generic code.

Yes. Also, since we have KVM_DEV_TYPE_VFIO the generic use case, it should =
be better
to move the CAP check to the generic kvm_vm_ioctl_check_extension_generic.
