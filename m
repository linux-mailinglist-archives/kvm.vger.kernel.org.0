Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6A548A943
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 09:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbiAKIWm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 03:22:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:50625 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231130AbiAKIWl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 03:22:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641889361; x=1673425361;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OxmPUCi7olAEWScujAdh+gKHhL99V5GLKI/JkUz8ZaU=;
  b=iuGzwsHwts4oWKs34k9ufbsIk3LLrBp1C6tNzo7pMOxrFg8nBs0PhE0E
   qeOsVI74XNdsqDPUpzl/sZse2z2ZMKaveLDUB71fmtir+LF5UtQ5XRcZP
   0LN+4g3GW4EZWPwRkuUTvaoMuSk9cWGQB7xfmGzVPQGLCLigzRBMO4F5O
   3mJCrxiocIKFbsg0om7e6KApg2Wj7bt37MEsiXFv3N/Ai7ikioH/vOdMV
   uCU68YtzBfdEwU4KUGXUw35ikAvl7cVX/ozwC1en3Lr7lJme9zDpGE515
   HJ31fWzyl+yq2LloIxSizRVTMdppTHFMiFWoll7RVKMjBwaYaUNnN7lI6
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="230773345"
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="230773345"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 00:22:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="592625582"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga004.fm.intel.com with ESMTP; 11 Jan 2022 00:22:40 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 00:22:39 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 11 Jan 2022 00:22:39 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 11 Jan 2022 00:22:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fI3FKQzIDLWJI/vQPeBTI2W6gUI4vaLBAkrorzN48+VSfib1JOxXmlMUbWVij2w0JoGxosipWPE5pja9aWEdEhwmxial/o9U0sCS1qBBPvMGtVgFsLOvO7Mmvq410Vpsc+SHlc45ATckYPGq0DDMR0VoWYpeky4KzPUreS50NBCpagxmPl36KnwFTOfD1i34OTFdeUXZFd8ACc6NaRwfC4UjWxXP0wBacsrZjxT1sRNEDFBNQXE/O2rOqbIzkysdwgipuwQlxUsDkcAmivPrv4Vyx2cElVQrTJFrkOpa0Emgqte+SkmgfklGP403HAZUFLELZ7L9mafx8ObwHV2SwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iGsFIZVdpCM6bcmqsh2l6QWIB6FrJxhNGiJdkcv+P1A=;
 b=CTGOVOWYCyZ+bKJlayzLwwbk1MHJaOLkaW+faeFZxqo02U1cAYQ3y4Fwsjo6sxudKeCoOoJdJ3LPlrDy2vbH9Ypl8hnUD/Z3Z8uzKvKrw2lVLVpEvQIYrsz7d9QIw1FSz+s5H9CPYd3MOe69i+W0QoF2zYxN+2UkY6L87gVwdB4dX7CN3B5iLRFoixj/6AgebVhXGyhboILW4jHrzCMSUC3UwUPHIW8twVdp9zMv9tU0lDfEgZH3st9vcdLv888ut0JKyUa+uSm2pv/ifudKhsPLEqtzN0+NZPot9HczoxlHkh44LLP1FZnqOZA7rrNBBksDDmF8SP5ersdr21pLqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB0003.namprd11.prod.outlook.com (2603:10b6:405:61::26)
 by BN6PR1101MB2209.namprd11.prod.outlook.com (2603:10b6:405:50::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 08:22:37 +0000
Received: from BN6PR11MB0003.namprd11.prod.outlook.com
 ([fe80::c5d0:ea31:b791:1251]) by BN6PR11MB0003.namprd11.prod.outlook.com
 ([fe80::c5d0:ea31:b791:1251%7]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 08:22:37 +0000
From:   "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: RE: [kvm-unit-tests PATCH] x86: Assign a canonical address before
 execute invpcid
Thread-Topic: [kvm-unit-tests PATCH] x86: Assign a canonical address before
 execute invpcid
Thread-Index: AQHX/WX0ImmCXeW7w0O1106u577TI6xLL6KAgAAg9QCAEjd8AA==
Date:   Tue, 11 Jan 2022 08:22:37 +0000
Message-ID: <BN6PR11MB0003E1AD91178BA8CD226D1392519@BN6PR11MB0003.namprd11.prod.outlook.com>
References: <20211230101452.380581-1-zhenzhong.duan@intel.com>
 <Yc3VryxgJbXXwyy3@google.com> <Yc3xVIo8x+4DtQwx@google.com>
In-Reply-To: <Yc3xVIo8x+4DtQwx@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.200.16
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 804f1895-4a6a-4988-63c6-08d9d4db86e4
x-ms-traffictypediagnostic: BN6PR1101MB2209:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR1101MB220969B579976C9457E9374892519@BN6PR1101MB2209.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +p+OzBBbf4Fo4c3lu+ncD5ERUpJf1I5ehp3bElLRS3cnHvEGngFa/TW2t6Zf9OpaWFiv+hNLmWOKQY7EAahzlyESVoHzz+Nml6r/TNVGV3mWXeVNBcBgT4JeI42FHAnLfsibf0UKoFXBeOaXERqb5eryv8XCrIvDireDYcX2odRFt68GodGsaYpq/xGkbOvvhQ6XJstRm7ygmYLN5KI94R+ejM7cN7ygxG/yQyIBRv/cqWYJ6dhuFLXlo/giW5okkZ7xv5txcLJCeIlb52JeaL+ncUT63OXn4+ZQkygABdou8v6MdmlsRJmvW7wDt7b+xa93sobaHdHdIdv9aGyFLdsn/z81Bt9q+YfGgPemEK2MUYq07BGPHeFdq9str5Wf9p7SaW+KWLvXMFi6AnPP1OtKnc1POUnWgERGWx6m0V3Bs+M1ZK4SZFzAoi+IgzbiLDG4AAHm1+yrikanQl1aKdc1nIVFW05NMMxtE6L1dCVXYsv1u9Nu7OoKpYRpnZMOn4prawtmDTEaMuFC6JNU9uTD9zMc6OfPALEAtKIFroUXjF6+CWxwKr5vkqKnnPkDMEGbTUGttINBD+falpjYosFtAiO3jA+KW/Uwwolm8Dg4kFYwROVbuOBkLeZDazI3w/pmD4M3eQtzuYYmbXte78ruBSrTe6wQTOSXy1ZZod2rctoh11cSMX7a1x1X/5nHnR/2e+Z/74NrkEMkoqJWHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB0003.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(26005)(9686003)(86362001)(8676002)(52536014)(7696005)(33656002)(6506007)(64756008)(66556008)(66476007)(66446008)(2906002)(8936002)(76116006)(66946007)(5660300002)(508600001)(186003)(6916009)(54906003)(55016003)(122000001)(38100700002)(82960400001)(38070700005)(316002)(83380400001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WJV4Kpf6whe0oRLhMe1eqrBI51Y7bx7KH6q+YbfCJBy53VrmvmtY+T51sh7/?=
 =?us-ascii?Q?rUeKazWW5kyurEw8kF6PCOtZvOKXBCn6XxqAPPfwYcN9an8bMxlCgisqaXhE?=
 =?us-ascii?Q?VwTaB1d5m0mDdBOqfdHAPFQlG1nH+KeyRbt8pkRRoPUDM0aCk8wob9hvos/3?=
 =?us-ascii?Q?MeW5y8o0tbjXhQp+dfyJChhAxowxzQ3lTQxt9vACseBuwedEbsYx2FruxnWF?=
 =?us-ascii?Q?U6z1+s1ixyIiaRTvgM2/owmt0DXJBGWtH6i+INVOD/b7QGfwoa8/mloIDw+A?=
 =?us-ascii?Q?UhHaO3ObNibsNHTuDBSpr8bMTUbIt/1aK1yen176PyzrzuZjhfpzFQnJx45L?=
 =?us-ascii?Q?40NxCoPLVbagPE9lP1cASh/t/IcxOFWrFNi78qyT4ZeZ20EJXlAcjAKZy731?=
 =?us-ascii?Q?I1fBPoXnOv0bBM3KVRRzAMbkn6onq3NtM/6/2TnSWF0FqBzX1bVHr91gFr1I?=
 =?us-ascii?Q?2Ihcu3iYg6DOfbfEvcV5maTODEDdbLlH4E6P9Xi1/nmIhFtPfT1cfmxc6Omh?=
 =?us-ascii?Q?PhM/eRfDEDgXAiUUQZEyC0C/jyd2Fp+b4WM7fZTocbURPRVpcGzX0uxprb8Q?=
 =?us-ascii?Q?O0YRpwt7bmVXPw2ekWnauydmLuJrfCqFhmgUX64xxtwlNosv3mGzBOiipPXN?=
 =?us-ascii?Q?TjY1eK7Ll/rAnvIyIrgl9ZC3yB44uwtun2vwqD8zOMvD5UBryK8nT4eLPvuN?=
 =?us-ascii?Q?Hn+uLqXxO2Burt1/oHBmvo4uOaH0JgGryzE+6Vvgpg9swWuMJsItN0AhYn4x?=
 =?us-ascii?Q?Gs1nNUZvYIbUymZexTPh4trm+Hnk/ZmmqBzwAf6sLT7fgu97Gr0mavaL2KnB?=
 =?us-ascii?Q?9sExEq12iwtKIJdAV6QDYfj0VRw7KRofcnAug0WBTRlHsXdPNUwcAlxex5Y5?=
 =?us-ascii?Q?F4OGBKborpWfmapnA5e2Ur8/EdbIh7Qc4yjcz+eXWsn2UmiVNSyBCez5gwwT?=
 =?us-ascii?Q?+PxsFkGDTZTDXRhlXGkfzXJKHWSLcHeZ7b1tcJc73p+rrj9plGpYMr4P6rxi?=
 =?us-ascii?Q?Ur9XIMd2un6kEVDOOBZuB3xC5zdBJ1GXTLXKkWOcq2cSk2ew3zeSyjzNKjY5?=
 =?us-ascii?Q?KZAI43PlpgBX6rpsilbIY1LEM05KlWzut7lGcEA+kzUea3s3klKpul6aJ2Tk?=
 =?us-ascii?Q?YpYsPLtuJQGgREBiREFeDy6NxEmvJMPEZIwS+7Scpiri6+Mldx8DgrXynzav?=
 =?us-ascii?Q?zCExlGH8JRf8N2rRJeo40PvG+zR+e0/EymlnBBmO2dOb8uwrRuOptujKCtRE?=
 =?us-ascii?Q?GBKJWpb+UNcu69nphv+doH7g9K2cJ8cjfptgNjyUXN1HnIVTBHmr0IxVaMm4?=
 =?us-ascii?Q?i/RVOfgUFWiGjPz4SgHyxeK+wywTqHOfrm366nK081trGEfJH57Le6S6Pzbr?=
 =?us-ascii?Q?XEUKk0MGqrdnYd1Se7UERtF3DkA5Sa9bsWYbqDQZM3CcGmEM5vKZ5TEG2V53?=
 =?us-ascii?Q?qivmfF/8Cfv9nuA06ce4GAT2oQGZmEQQ7DFRX6h4IqcUPwvg6Vb7Z/0MJgEV?=
 =?us-ascii?Q?/jiAcvfVU71yqumX2jWGuWupTzhxTsyf/i8wbKctWZIVTWw0HV9VhQrE3TMD?=
 =?us-ascii?Q?RCtHdm6cNJfkTidH4VdbezzDf7kepRsmEBPrM/hxyMdVq/59oBJ4UX8rOQBn?=
 =?us-ascii?Q?rlV6P4/8eeYUMo1DQP9dy1kvtz9cFEAp5emwiNFu/DEQhn7vmn0JaEZ8K/Ed?=
 =?us-ascii?Q?uf88dw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB0003.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 804f1895-4a6a-4988-63c6-08d9d4db86e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 08:22:37.4426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qIYIUMTe98jhl22RHcWxNilIK5trXCKlHicxqkdVS0afsQplFObv836AsCyzX3Axb+Vk5u88D21ndq0w26FdpWbzVllnxTg4JcBP5Kfo2mk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2209
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



>-----Original Message-----
>From: Sean Christopherson <seanjc@google.com>
>Sent: Friday, December 31, 2021 1:50 AM
>To: Duan, Zhenzhong <zhenzhong.duan@intel.com>
>Cc: kvm@vger.kernel.org; pbonzini@redhat.com
>Subject: Re: [kvm-unit-tests PATCH] x86: Assign a canonical address before
>execute invpcid
>
>On Thu, Dec 30, 2021, Sean Christopherson wrote:
>> On Thu, Dec 30, 2021, Zhenzhong Duan wrote:
>> > Occasionally we see pcid test fail as INVPCID_DESC[127:64] is
>> > uninitialized before execute invpcid.
>> >
>> > According to Intel spec: "#GP If INVPCID_TYPE is 0 and the linear
>> > address in INVPCID_DESC[127:64] is not canonical."
>> >
>> > Assign desc's address which is guaranteed to be a real memory
>> > address and canonical.
>> >
>> > Fixes: b44d84dae10c ("Add PCID/INVPCID test")
>> > Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
>> > ---
>> >  x86/pcid.c | 3 +++
>> >  1 file changed, 3 insertions(+)
>> >
>> > diff --git a/x86/pcid.c b/x86/pcid.c index 527a4a9..4828bbc 100644
>> > --- a/x86/pcid.c
>> > +++ b/x86/pcid.c
>> > @@ -75,6 +75,9 @@ static void test_invpcid_enabled(int pcid_enabled)
>> >      struct invpcid_desc desc;
>> >      desc.rsv =3D 0;
>> >
>> > +    /* Initialize INVPCID_DESC[127:64] with a canonical address */
>> > +    desc.addr =3D (u64)&desc;
>>
>> Casting to a u64 is arguably wrong since the address is an unsigned
>> long.  It doesn't cause problems because the test is 64-bit only, but it=
's a bit
>odd.
>
>I take that back, "struct invpcid_desc" is the one that's "wrong".  Again,
>doesn't truly matter as attempting to build on 32-bit would fail due to th=
e
>bitfield values exceeding the storage capacity of an unsigned long.  But t=
o be
>pedantic, maybe this?

Sorry for late response. Not clear why the mail went into junk box automati=
cally.
Yea, I think your change is better. Will you send formal patch with your ch=
ange
or you want me to do that?

Thanks
Zhenzhong

>
>diff --git a/x86/pcid.c b/x86/pcid.c
>index 527a4a9..fd218dd 100644
>--- a/x86/pcid.c
>+++ b/x86/pcid.c
>@@ -5,9 +5,9 @@
> #include "desc.h"
>
> struct invpcid_desc {
>-    unsigned long pcid : 12;
>-    unsigned long rsv  : 52;
>-    unsigned long addr : 64;
>+    u64 pcid : 12;
>+    u64 rsv  : 52;
>+    u64 addr : 64;
> };
>
> static int write_cr0_checking(unsigned long val) @@ -73,7 +73,8 @@ static
>void test_invpcid_enabled(int pcid_enabled)
>     int passed =3D 0, i;
>     ulong cr4 =3D read_cr4();
>     struct invpcid_desc desc;
>-    desc.rsv =3D 0;
>+
>+    memset(&desc, 0, sizeof(desc));
>
>     /* try executing invpcid when CR4.PCIDE=3D0, desc.pcid=3D0 and type=
=3D0..3
>      * no exception expected
