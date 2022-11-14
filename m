Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D963262747D
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 03:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235653AbiKNCSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 21:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235443AbiKNCSw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 21:18:52 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A354B21B1
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 18:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668392330; x=1699928330;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FTOBEATt4trcbXEcaQ1PpIMPv0z8FBoRVdczl0KzXug=;
  b=KqNfCwBIBb5f33iFRyd2/9pazFSiqRV0yZwB4jbJiSk7f6tr5zaGEE+N
   lmwoIoa6P0IPJoIuP0uEzB84aI0J6N7/7Yn2TesMpwX1gyMyykZoqrsTU
   oONz3LWDSczC+GMYRHAxXpA5DsMH798O13KzbkqvNJcVaCx1IKHSX0ibQ
   mLpdJCOemRkzb2eXlvHVsjgFcWBepVUuu+urzxf55wf26NefI5KYabdzZ
   rKvZKB80N0J5SALNDqBnlzI2g8Ul/Ih2fyaRadIO7UvjMJcZGG+nTfAtE
   9/ACXbEHTXuBUl33fi+sD6nfaWCn2Can9lam3pJ1MFCiiwV0OUhNILQdS
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="338647457"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="338647457"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2022 18:18:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="967390273"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="967390273"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 13 Nov 2022 18:18:50 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 13 Nov 2022 18:18:49 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 13 Nov 2022 18:18:49 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 13 Nov 2022 18:18:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKBono86h+9ogpvX+4eNbnIs5GP+ZtqGI8RUNcF9k9fSoyJe5ATe3Evhpdq0rRFQs7s2bB/PsNAmssXaSBYQOt5nzDasnMn/fhucczwGVabZRQqFtT5iSycNd1ysaHpCioRcwn79l/cTHuG2bemz5UZ123Jl6k4CxKlB/ue8tTlTLviLuCFb0edpRE6ypsQCDe5pGbPSSvckwa41SRovTSGLO1TdjcBRErdTOjxnoFWSwOdqVvIQSBV2vjV4mY50Wpa1ds2VV1HG4t/qcBlFdAjVcmu7fuxx5VAwOHdr6T9axTxqEi2sqq86iw8Eou+4oLfZsbYT7H+yWys56Lxe4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/FWZRZNAktFWdeSgBSQa4qd8URKgvzZK0x9USLGGxRs=;
 b=VcmwEzXHkktOhKCOkVd8HFfq5e3SdBH6h0FYCtq1unYKyqaFvQe+E+Pjrw4xUutd4Cv2YGCsXt1b7oGlwZNHRRxowlCJSbwbPlEyFSANLdUR/buGohkf/wYEZUUxLztjhuToS/6+XH9Ue7TaeM4CQO7B2I9e2gDuOqCQ0fD0HXCRAvFcXsZP6VRH+LPL6EMXzaNhO7gGi9OnL3M1s10M6Dl5u4AnD7JUAQXqAVPaI46MNl7ItumGQcphinA7uezQklK1HQqCqMbUtxnZrirBntbQdeSFw9xSr9KPsby6rtWvjOW+Yz3E0hjOBWoLpV9RJXua865hXXDlmHt27YI/1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by SJ0PR11MB4957.namprd11.prod.outlook.com
 (2603:10b6:a03:2df::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 02:18:47 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c%11]) with mapi id 15.20.5813.017; Mon, 14 Nov
 2022 02:18:47 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "linux-kernel@vger.kernnel.org" <linux-kernel@vger.kernnel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq() for
 NMI/IRQ reinjection
Thread-Topic: [PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq() for
 NMI/IRQ reinjection
Thread-Index: AQHY9MwiNyyftQUqnECEfv3VPyPgfK44UVAAgAAslsCAACVigIAFD4ag
Date:   Mon, 14 Nov 2022 02:18:47 +0000
Message-ID: <BN6PR1101MB2161D6F9D0E5DD5BF2018E47A8059@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221110055347.7463-1-xin3.li@intel.com>
 <20221110055347.7463-6-xin3.li@intel.com> <Y20f8v9ObO+IPwU+@google.com>
 <BN6PR1101MB2161C2C3910C2912079122D2A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y21ktSq1QlWZxs6n@google.com>
In-Reply-To: <Y21ktSq1QlWZxs6n@google.com>
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
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|SJ0PR11MB4957:EE_
x-ms-office365-filtering-correlation-id: 27433c1e-3f57-413e-0242-08dac5e68fd9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WM2zbj/vIT7/K6QyfNtftEr+KZxTLoCf99YJFfwZMvXihOeX/TTrB9Ky7X59hpwRCdLpRWyWvVJsr3E0WYlOOKyxaEROpAbWdMicH+pt/h56ZOGrvjIR7f/fw75NZn9VNuOhBtjO9id0aibyMB6Gcn5cSf9pDzwZvTXaTexyPW4h/3yGKRGLfp4m7ufv1TyS5ICIOXUHGqw7EWaSsOEX8PaaZWgeI1M65otg4rS/nqMCxbgo7V9wt31K3EXwqspgkeuJ4lshEuBkOZP8ip5vqqPlwpvhB+cRx2xWbeAIVv9h3hITjQB3pGbmdHmhX3iXPidPUOLy8v3xUsNiMvc0nHxJDA9mjSwWZXZJP89cYLkQMxMu+S+L1RzooAsC1sh2+0n/28BtRLJWWfPcoZ7w9AbdVW+fs0PmS4VqJN5w37XjjKVO/NvGhQZkAm5+mIFGEJ7h7rylJ6gZtsMS9hAqwsyVwjdWmdODp28FYlI7bifTd724n9d7h5zizOSCGKR+/vJjwYQq+sunudPA4qSJEg/g8iWCIv2eaZ3c/2NBe3YF5ymIkgyaEJHkLCG1XuQYWrqNyi/y2ssELaqXw/UCO7JXtwbedmRGx7MG44pX0ABL9CjluQkfA5baBwuHqxweXHXpUPia8NSpU3Lp6z2O8ehMucWPE3OK0vxNeIFJ+5UgCwgvFBZgfGMgGnUlE1wXk9Ymx4ts+Wd85kgII1WF8Ss+3oeULGoqE3FmBwUl7+MCCH6/0kUXHC7ZGV0FVZuXFG+uBPEh1Y89wxoAqEJf3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199015)(83380400001)(186003)(38100700002)(82960400001)(38070700005)(122000001)(2906002)(7416002)(8936002)(52536014)(55016003)(478600001)(4326008)(26005)(9686003)(5660300002)(6506007)(66946007)(7696005)(66476007)(71200400001)(64756008)(76116006)(8676002)(66446008)(66556008)(41300700001)(6916009)(316002)(54906003)(33656002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ip5QyCpnZ3IECQQG/mvtAM/rHrJUwdj7IbB6mhMlOITD1BE42ZBvBwLwo6gj?=
 =?us-ascii?Q?ptP+po7CVAYCKAkcnnVvxLOP6mh/0tmwMpdYBK17ozn7uDIbKaQLvRildV4l?=
 =?us-ascii?Q?6KxBcORQ/bTBcSlR55HFJpWCQFdrVeGHbMdOcfEmf/JMXL/zUHMK7Cs/M2OT?=
 =?us-ascii?Q?frjt13R/1UCwM3vqa6OYm4JCIrR0Pcj5n3Jmp99lIHdMxzDJqu8tkZpf7D+4?=
 =?us-ascii?Q?6wo9rrNOV4tMA+ONjEUorZ1GExgXToiztycaKaVoIr2R5tlN/E4RhJMDpJGb?=
 =?us-ascii?Q?ikpXOEBk0JNzgncIfrKbuGgEA3vQ1LAzChJt4bpGZC/aRfTkE9sstlLfqJjY?=
 =?us-ascii?Q?b/MAkXO3PVoTPuIDc/bOBVWc+w4qdGCE37W4nrCs+yi0ZotMWoUj7vv0WgiE?=
 =?us-ascii?Q?owjL2f63S/R+ZqmVV9kSINIEV51QoY1dRdkRe5HNC/imqaeUzUulB18RJCFr?=
 =?us-ascii?Q?25G26MlxnKFK+YWw4IlklC6xiALYyJuxzhYEl2eXlWYxLGgQ0EMVL5LFNyMB?=
 =?us-ascii?Q?7KAJvDIyTSYZekeLEazz/o+sL9TLfykyKMyDTS70ycjT/rIcNPeeiAwHJk/f?=
 =?us-ascii?Q?9ptZSgxF2W6IAmDlBDGJfcU2htPGwLBujtxOslJ0UA5Ipw1qdKOxuaCdt10Z?=
 =?us-ascii?Q?ScPOVNtbp0T5fium7O/t8cVPNDq8MxnEGJFEBW+OuZwXGrWo/fTutedXj2r6?=
 =?us-ascii?Q?BVi/xNbAGjjetAPul5ImTasFdyFdTmFg+rcqmOvgIsk6gaWyazM2nnHiWh5u?=
 =?us-ascii?Q?jgKifOHvHPy7ZuCqKfa/6FT2SwogOuTVfdmRqRRFfwPi8ltFUDefow242QOp?=
 =?us-ascii?Q?zse1M19+/NtespvuEP7KO7aPt9DejDTTAkD6XdPw4tew25BRcf1/xN1ktN9v?=
 =?us-ascii?Q?AokWh1xoUs0W+XuWG9MRTge5WsV6h5xDFPTxotbB5Hfmsnz8kmhemvjshTFT?=
 =?us-ascii?Q?kVDf6o0a7YCbp6Wczn4NZqnfW6cVmUpwk2j5wJ2DgbIFLdRwP40VL/jUI0HM?=
 =?us-ascii?Q?YStpr1aFtOWUA12iq8cpXJcRrnOZPQI0UeMvfV10+TGQgaSzE5V1WmQgRJFP?=
 =?us-ascii?Q?wK81KuedPYXIPWeNQAJ131/86/EEHuQKIfoGOZRBODf2PZJNu/RSHjGdXgps?=
 =?us-ascii?Q?d6Wn2BSJM7Jlj/QWkyM62Xr0uqwzFfG3p4Omv3VEWd47NMAnLdAEfYL1+o4G?=
 =?us-ascii?Q?tcJ3GCt9PQauwW6gixqojErDIPt71e/vrzDRaMSVHuV6nLX729zM7W4/J0Z7?=
 =?us-ascii?Q?H2Z3KgiN9uBU4J+vZkAxe+QpisluLwpZkdCarA/dVyrGBKz/d/Hpix9difDM?=
 =?us-ascii?Q?jAmF8V/7NYKVR1ziYLypx/BJWHkqISJCHGaV5+aiNOs4kKMIYqIgNJXyr6Xq?=
 =?us-ascii?Q?0gbrC0GD2YeVhCQEvTjmXeVaFB92FCdPavuj7S1YpWe3rflFrXoPDdbhfv5d?=
 =?us-ascii?Q?YySj6i1pASrYBrMY7JyzEXbmnnmhOA3HvnEMQQwB/kyfzoHczEI7gbQps72/?=
 =?us-ascii?Q?pXsfWpTfZCmciWe7TInqa11t8jcllZXY8D0YYgfQuSimb4m3gkv7oA8J6qFV?=
 =?us-ascii?Q?djVLMl742seD2Ig9sJc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27433c1e-3f57-413e-0242-08dac5e68fd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 02:18:47.2703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9p/P0fi12iXGt4xIDYwfJeOjOrX2Wc3ID37AOklFk4KJVKC+LcuYjm5M0OMbLjfoYLREApzvX4avl4rJqhCzUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4957
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > > + * call thus the values in the pt_regs structure are not used in
> > > > + * executing NMI/IRQ handlers,
> > >
> > > Won't this break stack traces to some extent?
> > >
> >
> > The pt_regs structure, and its IP/CS, is NOT part of the call stack,
> > thus I don't see a problem. No?
>=20
>   bool nmi_cpu_backtrace(struct pt_regs *regs)
>   {
>   	int cpu =3D smp_processor_id();
>   	unsigned long flags;
>=20
>   	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
>   		/*
>   		 * Allow nested NMI backtraces while serializing
>   		 * against other CPUs.
>   		 */
>   		printk_cpu_sync_get_irqsave(flags);
>   		if (!READ_ONCE(backtrace_idle) && regs &&
> cpu_in_idle(instruction_pointer(regs))) {
>   			pr_warn("NMI backtrace for cpu %d skipped: idling at
> %pS\n",
>   				cpu, (void *)instruction_pointer(regs));
>   		} else {
>   			pr_warn("NMI backtrace for cpu %d\n", cpu);
>   			if (regs)
>   				show_regs(regs);
> <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D HERE!!!
>   			else
>   				dump_stack();
>   		}
>   		printk_cpu_sync_put_irqrestore(flags);
>   		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
>   		return true;
>   	}
>=20
>   	return false;
>   }

Right, this is an example in which pt_regs's usage gets broken with my patc=
h.

However a bigger problem emerges, how NMI handlers should get called when V=
MX
is running. If we could address it, we will probably be okay with pt_regs's
usage.
