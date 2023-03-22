Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947C56C597E
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 23:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjCVWiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 18:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjCVWiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 18:38:23 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24A92196C;
        Wed, 22 Mar 2023 15:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679524701; x=1711060701;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eoigw9bJ6ILdMhJXbtdL44WipOP8UpzmUulhd1OqxhE=;
  b=XqVU5nqEtLXOEEB5iHDWg8hEVOq7Y93XHHzpcmfLS97XNYPmvLw/c0W5
   f0VVXV0b3JFf+4+S7BfRbs2rBmC4cZoNS9b+tNuOjFLGhskVls4xMgoQk
   yuTe8RMXEqw6pEnoghOQwZXfaso9Qnq4ztq28FkpVYHzqIa+HV/qGKkUY
   GkKHvA+i7JhyMUznh9tUeXrmNCb1XIJFPXusvspBYW3Dqn1gGT3mi+GmA
   g59nFxR5hD28jkcwlPhb7/7QVDT3pTVYMmOzoHEgEtcRS/B0i5hR64CbS
   Kg7h6BT78rYDIR6ZBBl9OGZtRJtyuR/KzY5Va3oS6RZdxN76ASGgguMDq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="340885686"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="340885686"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 15:38:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="632139120"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="632139120"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 22 Mar 2023 15:38:19 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 15:38:17 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 22 Mar 2023 15:38:17 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 22 Mar 2023 15:38:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqJNv6aMxM+wHim51/I6LugOx9m0GB1Vauj06lYk5eylnNI+G8hUWdslVTWmXQlrK1wt3cSMtXax2eAnx19+NR1l8GmEp49r/zUSRdWYBRWYTJVkmTUSBlcUVHGrPAcx0/0/mUxaq5/WRBL9B7yk3/at5vMTRS0+Ff384Pin0wTUSU7rffDGRH4nylq2VrgLbwaOXO5f3hNr/Q0Od6tdcAqH6CV1GEeDIIQoZJSj9z0+bWQEcUUptpEHB/+qYo/Uetp976tho7T26v0erocHq3GZYQnSrYJ5Lmo0MSr9hoUKnc73ek/Vc+k+c67fxDm7A+v0yfR0F/vcxfzmRVE6Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eoigw9bJ6ILdMhJXbtdL44WipOP8UpzmUulhd1OqxhE=;
 b=iYAGXJVANLn58KHPWD2KTiaRXX9ECCaV0dZooSUokLNfJSbxBg+F10ZMbLvy6AAyWOOeQK8iyJ51Lo/b9SruV8UMAbafercX1Bp91IIYEOYSf4AslMZ7TthTVzQyF7+Uyp1Qre5njq8w2gzM5OpLY1dbvTtPHUBMVLcXZvav7+0am1u/q84MjSSPC/0QKqvMelKuj4zk1ouZnJux/0gvHtHHCjyT4yc+c3Geq+0RgRvx2CYWOkUfUyFShhkBSIMBD/nvJGykXD8e7SoFLX4NWh9vdFWwRKIP1qSSw96YL83GPXDprzv0+8NJhXp/madW8d0llm769SBQjUZdWKsOrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH0PR11MB5904.namprd11.prod.outlook.com (2603:10b6:510:14e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 22:38:15 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 22:38:15 +0000
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
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v5 05/34] x86/traps: export external_interrupt() for VMX
 IRQ reinjection
Thread-Topic: [PATCH v5 05/34] x86/traps: export external_interrupt() for VMX
 IRQ reinjection
Thread-Index: AQHZUKG3Kdahp7VGA0+nukurnTn7Fq8HLL6AgABOnsA=
Date:   Wed, 22 Mar 2023 22:38:15 +0000
Message-ID: <SA1PR11MB6734A61E1F8F442BF1D6FB4FA8869@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-6-xin3.li@intel.com> <ZBtAQc8Jz5GWGrJr@google.com>
In-Reply-To: <ZBtAQc8Jz5GWGrJr@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH0PR11MB5904:EE_
x-ms-office365-filtering-correlation-id: c3a6b9b5-acaf-480b-1152-08db2b26202e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NQSLUsHxvhCr80galRHIYh6COwIB9WpSK07k83W5BVIpQ66JEC6AOMFSlo7AAGCFPC9WH97KezQCKIXVqHT3CI7Dz1Q7PesUOpCe5xqVu4kykuqdKohRDHag+ReGNQzgMjBs3EGBIgUHxcvO+px0H+c6h0WR60ST65jFACbYjvN4RkF4YHJAjaRZx4SCMOt0XLxBHYV/D+THj7YPb+2Pz3VL1c6jZKufjQMBoPcGrwIV2bXC3j3satlsjwHGBV0Tv18UWwgUDYvZ780TjaLsf582yTUVxA7d2x3p8sRNHMKl+bPnhtncwUcwU4x+0gtHchVlUvPjl9a8n8pAQkps3nnIwWX1Ib27nZSKPLewK1ZQ7vki2/DT0WsyrZL4wic9eNOKdDzzwCEvJngM1uKB5ERd+AhfqHQv02ywXG8RWcHctQquTksI3tMUDTFpGicr9eN40+wLTC9Gxs8kOKTi0UXqDY1cD2NC4cn99s/uSfV0KGS1ElHKOIwPxpVX7EEhTO349S1CS1B7XoBhSIehXGFTql3m6N0Od962cg+LVoKahoMsgEWoSfrYZSM+9VbwVZs2SvNR+Lf6In6+rbq2Hp6+4RDFUFPuYA6fPUZULb1g89St8anOIj7o63cG7BydqYB5OzEGRrDWsZOw8PRpAWWlG24SDqMBObWpgu95CBLIWnElOs67ZIbhqxoBiEXhk7xZ7pwPcpC1n6AYE1bDZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(136003)(366004)(376002)(39860400002)(451199018)(4744005)(2906002)(122000001)(86362001)(82960400001)(38100700002)(8936002)(186003)(5660300002)(52536014)(33656002)(55016003)(7416002)(41300700001)(7696005)(26005)(6506007)(9686003)(478600001)(316002)(71200400001)(38070700005)(54906003)(4326008)(6916009)(66476007)(76116006)(64756008)(8676002)(66556008)(66446008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?s620nc5hTHA89bEY/3aXSRV94sAGuI7ibdKg1nCP3wB/3cU7EUOjOgSiyAWA?=
 =?us-ascii?Q?wQbcHyUGnp4dsBrInELGkwV0bg1sunIBJngBUmPztV6g3FjYRMqnlqVLauCT?=
 =?us-ascii?Q?E2UgYGTPRVc6QQQT3VV8cFEce9Tfivcin6214mgvoGA81z6xo3ttYyVHyxmy?=
 =?us-ascii?Q?R80rS+P/qGgjnyEZAyHgB+LMf2qpY8vMpRlZvH9u9ZaYZAnMdtLBhwPKVR8b?=
 =?us-ascii?Q?cagaMccB3gSKcTdlB2wz/UuSljzSlKpfhn7eu5V7oWXm+AHHk0ufGrn5qj4W?=
 =?us-ascii?Q?ttnyJ5cbvbcKzdyKoktmSWoPpa8Lbt4v8kpskkrqpuwkUt2INxrsGZg+qHR3?=
 =?us-ascii?Q?RgiJTzM2aV9jepNHJmQw1z6/dd5GM+29XuF22jiHrfPjWjWmTa2Gw8FF3KGy?=
 =?us-ascii?Q?mzzmuGoPuDWWXgR4tRiXnBW3Vk0PD2GuBG9O3C84MsEE2AfKdCtt3Au2WBG6?=
 =?us-ascii?Q?2XMjyG/jIk1uE3cEFr3zoDpoNSpFpD5k0TTPv9XsKmlmCoGND2MMHvzxiivY?=
 =?us-ascii?Q?VgQLVnp8bSu47sHD00LfnW/+OumFvjCaCNOiRbZOLVjl+PSkkbOPjFopk7un?=
 =?us-ascii?Q?MwEWruZBt77bTsbZFqs1DC9xbERw9lsr96QEcSgBjvgPI6G/E2NfahALg7zd?=
 =?us-ascii?Q?ynFOqUM+XjZS640hk3pyoltYJOv7+ceBe9rhEOfehfKOFF/hT6rR5+ZF0P0/?=
 =?us-ascii?Q?lb+/JeItHX9pNtRzGAgbuKaNM3+JlTT6szYy6zltU4iWOnMbbu2eAcxcUn85?=
 =?us-ascii?Q?K6b6G8CE0LMMp6emSTirlIA3Bo99eVT+wEYY0ms0q8cZGwS/kO58CCfZidE0?=
 =?us-ascii?Q?tERgozN0r5mOeAeeguHPO2oFGOTw4pZk9IVktJF55rkEMj4tI+DX4XYJhSPH?=
 =?us-ascii?Q?o1ddlRROWPneHay3khYVLOJYCRWSfA30HcHiyz7su49KP8AXmpiaOjFGXm4Z?=
 =?us-ascii?Q?VAX2b324JW1rEICWDLmKx3WhElF0xzlKo5ThIc8FsRhKgc/qWFVE0jiPHeYu?=
 =?us-ascii?Q?rGJTPkTX/w/aaIz9xm6+oWmKZvM+Q/ID1IhmjdxbhDt4uRYVDxfaD4sFo+U0?=
 =?us-ascii?Q?tNrdSQ5160mifXAI3MB13TvUCzMtn6/qvJMoQwEYBoJzFv5MErt0OQbXgxsO?=
 =?us-ascii?Q?y2HGxAneYWrfVMwzzVxg8/jPpdrSBkGaj6PY7dTh+TeGDzGi7j8pf1QXy9wS?=
 =?us-ascii?Q?dqdbV5SKCQPYEYLK3LHSzdHDV8YGt2WuIBQmpBZPARozxKqUY2KXKmmNlt9I?=
 =?us-ascii?Q?k4PXmdyFeD9uKJCPRn91qAYqaQqqlnu17NQrq3J4/d661IpVgJebu32NHjpK?=
 =?us-ascii?Q?8s86XzWiXEtT6SYVPH3w1NSiIJ9K8psk2NogMp/Cy9d9j9v/eIdCCcLNf4Sj?=
 =?us-ascii?Q?T7iFzn8V1GpG7XFI1AIZhJBkPoT4r7x6VpTAVmEasEeClORUi3RbCr0H8Gq/?=
 =?us-ascii?Q?v33aTuiT75ztM5bqYA/uGoOC9fJJAnIQvp0qBGZiADn0aAOS9l1Gc4kL9jEa?=
 =?us-ascii?Q?z3qU7nh1PWkD4rxiOYKZuUx8wMnD18tPUEGG9Dz/cEG5Tr0GmGcICqhBoy9B?=
 =?us-ascii?Q?vhPAc1eiNxMhdDmOl4E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a6b9b5-acaf-480b-1152-08db2b26202e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 22:38:15.1230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: frSyZ/37Hjw+UiLtMfA649Y9Q4+ucRKLSMO7CZc9K9nyQNPjR+Ddq5g9DmWlyzjuSERG0BsPEUIw+8nvaCUL7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5904
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +#if IS_ENABLED(CONFIG_KVM_INTEL)
> > +/*
> > + * KVM VMX reinjects IRQ on its current stack, it's a sync call
> > + * thus the values in the pt_regs structure are not used in
> > + * executing IRQ handlers, except cs.RPL and flags.IF, which
> > + * are both always 0 in the VMX IRQ reinjection context.
> > + *
> > + * However, the pt_regs structure is sometimes used in stack
> > + * dump, e.g., show_regs(). So let the caller, i.e., KVM VMX
> > + * decide how to initialize the input pt_regs structure.
> > + */
> > +EXPORT_SYMBOL_GPL(external_interrupt);
> > +#endif
>=20
> If the x86 maintainers don't object, I would prefer this to be squashed w=
ith the
> actual KVM usage, that way discussions on exactly what the exported API s=
hould be
> can be contained in a single thread.

The KVM usage is the only one now, thus it does make sense to squash into o=
ne.

I'm working on v6 and will merge this patch into the corresponding KVM patc=
h.
BTW, I will stop using "reinject" as asked.
