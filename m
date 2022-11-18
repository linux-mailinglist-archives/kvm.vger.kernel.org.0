Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A170D62EA0C
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 01:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240483AbiKRAGK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 19:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240291AbiKRAGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 19:06:06 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4564D94;
        Thu, 17 Nov 2022 16:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668729964; x=1700265964;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LO+JMyw3swSKtZInxFM7EbXUsU0yBHkMaQviRrFTZyQ=;
  b=oHVoQNtyQ16JtlsqoV6zafNdXvU6Olwq3taPOJeJeyPoRUSJFBcRB4TU
   iVen77lqQXOlZqcX32jF56pywD3kFcgMDpt5vhIm5dghboedGdgZHTWqa
   SG154C7bLRQlK1GyO5Jn3VDy4QzrE/ubxnoVkmdyZX5m/Z+Zcdz+1xvIy
   ddprCV4PA1VXl8R1TdVwGw+hEvups26ViiXtH4D0QcWfCtc7PphGQPM9q
   CXWx18o+Q6SR+PlUBjbP/sUCON1dY8cI6RJzukRbJvBYKtFo9qvH3IoPU
   SNUkpzkmuIivJ3siFGXDc6OXFeU8wIzrNVJfY7UlmMJODGlhqo5Ykg0e0
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="293401248"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="293401248"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 16:06:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="745760309"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="745760309"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 17 Nov 2022 16:06:04 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 16:06:03 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 17 Nov 2022 16:06:03 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 17 Nov 2022 16:06:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdWJ/eLdcleWaYE9ibu/BRZ70vjEoD7EhqiczOcAsmlhPkq+2AUNEl+p22Dz8RtORErjBvt/PrRxTwC3i0IdWysdZ97n7/aZDXjcQ7qDnX5lm8dPWbOtN+AFKfUlvxPtUJXtd7/l9suf5XJ0ha1i2f7DJ+Ps5N9dNDr43gbuzNl4w1TqQLRgV8Q2H44nqQ+cEjDoPj/7Hc0nKTLVOLlMi9yyXmuxjhluGwKP9DwVTj1fu/GwlfzKtZgQjSL9hDqdYb0t8G++HuM/gbLd0izMEYXy0OxZoX5q8jjtAvmBGsFz1ocfy7LgjE5et1cW4yW+3jUvACodIcqHK5eMkBLl/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1iYbZpaUTCGfGd9P05C8Irxqym+0RtC6CWVKkletdhU=;
 b=JpYX9b9VH14c6aNWI72Mu2a6lUDFFTIEeUVFxdBJfvi7kKEhaRHnJCQtR/5Prp1ThchAhW/LEbXmRHGtbmK6O/kQLtgxwFVTzmRza1MxN25UxW+wEHA5P6MTbE/5r7eu5nvces2uDQyjsoCav46ejIsejE6B5cSqvlac9+xFgNleG9/uWvMam31r/1D8wYMb5I1QQokWRb/ID/I+ExqMelXBUkbhxv1Ld62fvqaLwXwRGVeLXr6SD/PCEQ+i88tmI6reNPAjLBIPrishqhdVvUuGCuy90FWhBzXYaQlCLBB3z/uBhZetbHHZCb3zLfJ06NbFFHdTUTrh9TxVOyuW0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by SA2PR11MB5164.namprd11.prod.outlook.com
 (2603:10b6:806:f9::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Fri, 18 Nov
 2022 00:05:53 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c%11]) with mapi id 15.20.5813.020; Fri, 18 Nov
 2022 00:05:53 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Topic: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Index: AQHY9M9YytlyKV7ob0GK/oJbeBhPY6433PwAgACmfxCAAO8aAIAAL0qAgAAENoCAAAgUAIAAGnuAgAA1qHCAACERAIADuBAAgABQYICAAXpoEIAAGnIAgAK/reCAANL/AIAAhVlg
Date:   Fri, 18 Nov 2022 00:05:53 +0000
Message-ID: <BN6PR1101MB21611347D37CF40403B974EDA8099@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <Y24908NWCdzUNqI0@hirez.programming.kicks-ass.net>
 <6fd26a70-3774-6ae7-73ea-4653aee106f0@redhat.com>
 <Y25a0Z2tOMWYZs4j@hirez.programming.kicks-ass.net>
 <BN6PR1101MB216141A21353AB84CEA541DFA8009@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y26jkHfK9INwU7Yy@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161E8217F50D18C56E5864EA8059@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3IFo9NrAcYalBzM@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161299749E12D484DE9302BA8049@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3NZQBJugRt07udw@hirez.programming.kicks-ass.net>
 <DM5PR1101MB2172D7D7BC49255DB3752802A8069@DM5PR1101MB2172.namprd11.prod.outlook.com>
 <Y3ZYiKbJacmejY3K@google.com>
In-Reply-To: <Y3ZYiKbJacmejY3K@google.com>
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
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|SA2PR11MB5164:EE_
x-ms-office365-filtering-correlation-id: 2374ee2e-c3b0-469a-fd68-08dac8f8a8d4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lZLpAph64d4y0M19hSQyqKB5M2PC9EaD6HFWn0xHa4DkFQ9U/RsjxFMi/Bs42HAlbGUXcmWgxnZ9qca1Twu7BdpWP9AGFSwPKm9JGFhxYlHfr3hXFhDBJrLYgi7QWa+SaA8KQM3qvOeYlKJhqBklxBxCsr6jgogtjIaUEtkwkDvIWKenUoF8jS9ZICsKz12V7CiKyV3jq9lX8rDcDeFAiM5CLLyroy2B9L1adJGVuy2V2NO1VkZjUYmTB2ue31dqFaOTW+r88Lbw/S87282eiTD0q83ATU6W6cu62YyjNDl+SLfKX68dfWMAYg7RfsnAEB+eV2+KgxiZ+PnkGjguPtdNP74lZ4UgIo0VBmVjjhL3zt6jHZ/cW9gQ5OcxT4q7222lQVu/RzpAfmjPCV5yQV1ErV1vBATfnXadhpjW2IGUaeWcWroz++mFj29qYr8xAyjOvJoDnCjlUzn2U6Sto9/cUC0hbwc+RR3OLpEpwGDkTqfvy1JSYtrJkrSMX1CsYSHs8ak7X4IAaNl1k+5Qr+HkR6zSacl5LqcrBWgF/PvFScqL5VHrp4yKESLncpPTwvUrkb5lw35wXTa4kVSQzqgmJkfBtqIXJ3J3oNqHnc56/JXcJyUt/dg1hS7rdJ/3cP3PhLWAN7CyzsfeXhlpnGzunN+Jy3Jtk04I21Oo/VNVMubm5FIzL0QjfN+3yCDZl0anIR4VvyK4RKuBsjBBGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199015)(7416002)(33656002)(5660300002)(186003)(6916009)(7696005)(6506007)(54906003)(316002)(26005)(41300700001)(76116006)(52536014)(9686003)(8676002)(66476007)(4326008)(64756008)(8936002)(66556008)(66446008)(66946007)(122000001)(38100700002)(38070700005)(86362001)(82960400001)(2906002)(83380400001)(55016003)(71200400001)(66899015)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aB3THmhxR+k9//7OJ/fg3wFgDv6deCId7u3GJ59TcS8kue5Bd+gM1GY1b578?=
 =?us-ascii?Q?utIpto11FhAArTEdbyUT2B28fG/zIucdzLpJAKhdoeA+yyE019PyHO9hdufO?=
 =?us-ascii?Q?Va80osTR8cJo3+rp5F0i7F9uAtbIuGr33pZsDGbLBVNVayXgZEUJLaz55WjD?=
 =?us-ascii?Q?Xl/l3Du1MlRZv+s22HmkWLJN0vHvK/6BJeEH0jIQawYcX/octoFg+PcOUY8P?=
 =?us-ascii?Q?9DzBCIAQ/rcw1OilwHnP6/nmGgRUPT7wc8cw6289plO/FcaCwy0xf5ZGHlfD?=
 =?us-ascii?Q?T9iJ7Ceqb1ivA+hDBtb4zT3Ym7rUvlA2Gx/5mcxheJPlP7qaedQ59DZQhU9E?=
 =?us-ascii?Q?L5zUSFriT+/clgJLMd25Hx/l7EW0H+RnAAF6NTe56OAriqs1BEOFKJtoxFKT?=
 =?us-ascii?Q?Q6MD+VJG/cx0fidZGsKCBWfQeFnPGYxx7oRJResdh27oe2K2ch7j47Ax41Xm?=
 =?us-ascii?Q?8NxjFPOgGUspgsp1EZ+hfuI4jg4RPissQ0XMuXDW//x3e/nOdYlb6IHMpduf?=
 =?us-ascii?Q?g8f6fmkhUnUTq01dCABzA98ZwTczfOjvvjKJmrHkRUFeJph9weJMqbZ0Yu4r?=
 =?us-ascii?Q?kFYS7r88Roh9ccOL+qSInrZwpFrtxYHcwmZJSDEYz5Q7bnf9hWo1SSjf0CvY?=
 =?us-ascii?Q?GZYYFv5Nkc2ufud/W2nVaRsCobAQ7h/NsBKJB+8DG9FpdQdsXcuUKGwCbxoo?=
 =?us-ascii?Q?JWZaMu9N1EoqKXvFmpQvN9uV3ltzxrWRxBCDvU1W0OnJs7DwsEdMgd+zGrfF?=
 =?us-ascii?Q?6UN2IN55JXeidC6BP88cekKDoCFrqWdjkiEwTMx7SNA2X12tpZXBLawYCVZ3?=
 =?us-ascii?Q?cKMwBKsPa9wihXLKTr45E10pkSW+O1Z7eM3gg6bBGWdozQLCr7+zn6evz9o2?=
 =?us-ascii?Q?QHfg/+hWhYqaqXHcypth/MeEa+2hk5SLLm45dNLvU/jpRv0jh9/Devs6D+I6?=
 =?us-ascii?Q?EC2oxIV5YgvB7S00DmKViV/ssQTFbqSvchMslitPPIqvrIOcOniXHeJJo1fh?=
 =?us-ascii?Q?HzrNvUkuM63SBYhixzsPUBnikcs6+I2uF7IX53EGO0x9NrEGdeMvaW97yE60?=
 =?us-ascii?Q?7ssLWumsuVOMIEv6ypt1SwdnshwgJQQ8RYI2PwFVPQdsV6ZH/3INhf0kTnxf?=
 =?us-ascii?Q?dkm98BnWZT8q+nsiWwJt6jEi1MQm3SVZgUquUVGY46XqSTHcErqXrJR6mmXA?=
 =?us-ascii?Q?CM7QL85ufKn7ZYfsjJP0fpHJrNHsUIquDT1NtoKRMVnX4AJDCY5L4VKK7eJc?=
 =?us-ascii?Q?KKdx9rr6mk8+9t21Nmh4bcN1nH21+nIfi2VpdzAvLWA5nyo0+sUkvRAe68Ii?=
 =?us-ascii?Q?eTMSBdrB1ai9y+1jL1XwRumxxzY+NK+RgtYDB7mMcLLDGWaIJG6L1G3nrok2?=
 =?us-ascii?Q?P7+wg8C0aH6v7P7yogaG1bHgo1LbgvGUglq3CjS4xWEqbfL2d27K/waGfd7K?=
 =?us-ascii?Q?m/rV7ifNFZnmJFMZ/OPcZ3whkm3TjeuK5xDkTr12QGgQOrOTfKD8AmvMEDvH?=
 =?us-ascii?Q?ZQde8tDCV9v5uZzpWCovafLP3hngAgS05FLJCwvsiyHZnU/JlWNQ80dg97CR?=
 =?us-ascii?Q?R50czSiB7JGWB5nDEeo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2374ee2e-c3b0-469a-fd68-08dac8f8a8d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 00:05:53.5853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AW3Odj5t1Gbjf5kG0960FKxqWjAWjcJ24qYcdRmcFujbhBxct8NWQTvbYJwQMvRgxQqZLstmkVXs7GemeweZOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5164
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > > > > > But what about NMIs, afaict this is all horribly broken for N=
MIs.
> > > > > > > So the whole VMX thing latches the NMI (which stops NMI
> > > > > > > recursion), right?
> > > > > > >
> > > > > > > But then you drop out of noinstr code, which means any
> > > > > > > random exception can happen (kprobes #BP, hw_breakpoint #DB,
> > > > > > > or even #PF due to random nonsense like *SAN). This
> > > > > > > exception will do IRET and clear the NMI latch, all before
> > > > > > > you get to run any of the NMI code.
> > > > > >
> > > > > > What you said here implies that we have this problem in the exi=
sting
> code.
> > > > > > Because a fake iret stack is created to call the NMI handler
> > > > > > in the IDT NMI descriptor, which lastly executes the IRET instr=
uction.
> > > > >
> > > > > I can't follow; of course the IDT handler terminates with IRET, i=
t has to
> no?
> > > > >
> > > > > And yes, the current code appears to suffer the same defect.
>=20
> That defect isn't going to be fixed simply by changing how KVM forwards N=
MIs
> though.  IIUC, _everything_ between VM-Exit and the invocation of the NMI
> handler needs to be noinstr.  On VM-Exit due to NMI, NMIs are blocked.  I=
f a
> #BP/#DB/#PF occurs before KVM gets to kvm_x86_handle_exit_irqoff(), the
> subsequent IRET will unblock NMIs before the original NMI is serviced, i.=
e. a
> second NMI could come in at anytime regardless of how KVM forwards the NM=
I
> to the kernel.
>=20
> Is there any way to solve this without tagging everything noinstr?  There=
 is a
> metric shit ton of code between VM-Exit and the handling of NMIs, and muc=
h
> of that code is common helpers.  It might be possible to hoist NMI handle=
r
> much earlier, though we'd need to do a super thorough audit to ensure all
> necessary host state is restored.

As NMI is the only vector with this potential issue, it sounds a good idea
to only promote its handling.


> > > > With FRED, ERETS/ERETU replace IRET, and use bit 28 of the popped
> > > > CS field to control whether to unblock NMI. If bit 28 of the field
> > > > (above the selector) is 1, ERETS/ERETU unblocks NMIs.
>=20
> Side topic, there's a bug in the ISE docs.  Section "9.4.2 NMI Blocking" =
states
> that bit 16 holds the "unblock NMI" magic, which I'm guessing is a holdov=
er
> from an earlier revision of FRED.

Good catch, the latest 3.0 draft spec changed it to bit 28, but section 9.4=
.2
didn't get a proper update.

>=20
>   As specified in Section 6.1.3 and Section 6.2.3, ERETS and ERETU each
> unblocks NMIs
>   if bit 16 of the popped CS field is 1. The following items detail how t=
his
> behavior may be
>   changed in VMX non-root operation, depending on the settings of certain=
 VM-
> execution
>   controls:
>=20
> > > Yes, I know that. It is one of the many improvements FRED brings.
> > > Ideally the IBT WAIT-FOR-ENDBR state also gets squirreled away in
> > > the hardware exception frame, but that's still up in the air I
> > > believe :/
> > >
> > > Anyway.. given there is interrupt priority and NMI is pretty much on
> > > top of everything else the reinject crap *should* run NMI first.
> > > That way NMI runs with the latch disabled and whatever other pending
> interrupts will run later.
> > >
> > > But that all is still broken because afaict the current code also
> > > leaves noinstr -- and once you leave noinstr (or use a static_key,
> > > static_call or anything else that
> > > *can* change at runtime) you can't guarantee nothing.
> >
> > For NMI, HPA asked me to use "int $2", as it switches to the NMI IST
> > stack to execute the NMI handler, essentially like how HW deals with a
> > NMI in host. and I tested it with NMI watchdog, it looks working fine.
>=20
> Heh, well yeah, because that's how KVM used to handle NMIs back before I
> reworked NMI handling to use the direct call method.  Ironically, that or=
iginal
> change was done in part to try and make it _easier_ to deal with FRED (ba=
ck
> before FRED was publicly disclosed).
>=20
> If KVM reverts to INTn, the fix to route KVM=3D>NMI through the non-IST e=
ntry
> can be reverted too.
>=20
>   a217a6593cec ("KVM/VMX: Invoke NMI non-IST entry instead of IST entry")
>   1a5488ef0dcf ("KVM: VMX: Invoke NMI handler via indirect call instead o=
f
> INTn")

Sure, I'm just thinking to put asm("int $2") in a new function exc_raise_nm=
i()
defined in arch/x86/kernel/traps.c. Thus we will need to change it only
whenever we have any better facility, and no KVM VMX change required.
