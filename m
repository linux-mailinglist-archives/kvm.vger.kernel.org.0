Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D386292B3
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 08:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbiKOHu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 02:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiKOHu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 02:50:57 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C1E1D0F0;
        Mon, 14 Nov 2022 23:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668498656; x=1700034656;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oclojXb28+flmHtnDtJymotZ+Kp2b60pNpzak4X4jUE=;
  b=VW73J2JB+uCipZ1FBzVwk7IfmkHHQmw9XjHNnUnJv5B60K+h4XHXuIQB
   OhkgpBHL/FkS3gFqg7GSpKM+IJLKKRPVUrde6gzITDbpfBPbx8gHZY/Kr
   GzFB8nyQkCb2rvgnv/SMqw9X9wQ+eKrRqjH1WBShC6KN4t9yBHNCaBP3G
   rGFgHILmWb421lYyzzrLJShNP5V0Tfuu10o3tLMiEx2fn9P9RqpgZUEU9
   XILRMql8rtrmP0AbEMrToVv0FXUCEuEWuulibadfSAEu1YbQImHLrr9KO
   899+u35YIX/lSsyPrRzYSkeBRujDEkElLO+//AoN8RnM1oRKwSoroYKKD
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="313998174"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="313998174"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 23:50:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="641115998"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="641115998"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 14 Nov 2022 23:50:52 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 23:50:51 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 14 Nov 2022 23:50:51 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 14 Nov 2022 23:50:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewSdfe7FBTMThp2dRtP6WEcfm8sUc8IBnzYSOifiNKoyBrhMyejMjrwcNckwOch803Jbx0OGFsZSE4OYJ/4KGEhoA8mVVK3YPxt/LWr9gz6Bj+hOmRkbE37bIglHUfdobJrF3v5Xal/PPHp/lpet55UsKxzudyf2kMdK8InW4GSUm4uyc8QwZRlSmfCkXs6dfpX268fFQWeZ2uqoyOC5ZdgMfFF/XE8EHX2hFQmadQnMgAC0qViym7L0ISZMmcGGDq8psu3K3yQENeEfd2sMlcAparL/Op+JbYkwqqzrxstthwA96TSV49JWxiykK1cNjKPzk0z8KuLMPe4kLBCcxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oclojXb28+flmHtnDtJymotZ+Kp2b60pNpzak4X4jUE=;
 b=g9yec7k9322tOdvmjHuE2JEaXLw0h7upFp0Pgn9ukZJT03z4QCKXoNAv5CTPKFvmVnS4NP5XPXRy0nEFZuVAbkHIHvN+G8twMctgXPUmx8f4DDxePvpm6+zXuSJfODN3U+i/7ujNfEIhzXShBxCBgAOcgJOE4PUjg0CeeYCfJgelTdXGg0JcbLw6Y+uUGZPhOQJ/h7T6mGIvha6RNwfIKXD4zRQkYk54ma5vnOCM8YWw2cVUOjd+OwYot2WTQO3XLZ2Qi4JewffCHHBw7uOQ2NUjfoYfW7Zhr2Fii1481iCkc5Sa0inNLeqc61TWJxEL6ZB0Ai4L+tLW6gNwZAIbDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by DM4PR11MB5376.namprd11.prod.outlook.com
 (2603:10b6:5:397::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 07:50:49 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c%11]) with mapi id 15.20.5813.018; Tue, 15 Nov
 2022 07:50:49 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Topic: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Index: AQHY9M9YytlyKV7ob0GK/oJbeBhPY6433PwAgACmfxCAAO8aAIAAL0qAgAAENoCAAAgUAIAAGnuAgAA1qHCAACERAIADuBAAgABQYICAAXpoEA==
Date:   Tue, 15 Nov 2022 07:50:49 +0000
Message-ID: <BN6PR1101MB2161299749E12D484DE9302BA8049@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <Y2y+YgBUYuUHbPtd@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161976800EB14B74A24D9F3A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y24SoNKZtj/NPSGy@hirez.programming.kicks-ass.net>
 <6097036e-063f-5175-72b2-8935b12af853@redhat.com>
 <Y24908NWCdzUNqI0@hirez.programming.kicks-ass.net>
 <6fd26a70-3774-6ae7-73ea-4653aee106f0@redhat.com>
 <Y25a0Z2tOMWYZs4j@hirez.programming.kicks-ass.net>
 <BN6PR1101MB216141A21353AB84CEA541DFA8009@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y26jkHfK9INwU7Yy@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161E8217F50D18C56E5864EA8059@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3IFo9NrAcYalBzM@hirez.programming.kicks-ass.net>
In-Reply-To: <Y3IFo9NrAcYalBzM@hirez.programming.kicks-ass.net>
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
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|DM4PR11MB5376:EE_
x-ms-office365-filtering-correlation-id: 624394ea-6108-4177-205f-08dac6de1c98
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 17fUALNNL9NYEik1tPna1wI2l5yeqMK/b1HaqUGBU64ChWWj4My73qaBD7HiTGQWTwJM55+MbIRVyJqSkza1fuhTR+DgrjteTn1f1qfKphh2n2PdcgCi/H1yEMKgwbewA9GBgiBpcliNwbTcJ1n2duGBWJVIRkzZ069er78GCYjs38TgWmuR6jAwrTw4fxgkGv+PWU3wO6dw8Ss+ZemnfCaYlA4YOnNqoKSTOpJCN4nZCNbknxa0P34lLKRGo/rnFrOcB0RzEeF3IP2TlnhbsgwW6xjE5YP0nbu//LkY9DKuzplheM9Lz18Au+S5FZraRRsiOuEpNrMv40fRO2QNikrnbbWtWeopM4R0UIOiXoOMZ70x9nWVNYAUfJFPObAZ43TxxqXnCJwV49SV/GdmV05BAP/X73gSVIdc17gb6BsG5H3skbe6zUn1Kg3yn+HY3E5IurcdMOWD6os2248i1hJ8Tt4FIOym+uRhiau52sGN4zzjC+6bUDp/YBwA6cviY4ap3rvUi0gFxEn/ukPXo5ruRID0/7RdiEeh/lQHTR/ziYTNqkVKPaLmrXTGqghVn6NjZfD6IyqTg8EjGwdnJ3BjJSOcjfLgVOlHkCRRRqCgDw3gN2fZvAkmc07JI+B8z5wd7OTmwd7dnW3E1nF/k2zCLwFOSpIVpL5w+qaoTSWD6sZBux2FtFj1EgBjkCxB4u1vmIRTeUQDiUJIqc+1xHeoIegkTfwrNamDgJzZJjW9jCzQTFuB3sBVaYm3B/AZPuieAl5zi1b7Cuyl5rKNwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(39860400002)(346002)(396003)(366004)(451199015)(71200400001)(41300700001)(33656002)(7416002)(7696005)(8936002)(52536014)(55016003)(5660300002)(26005)(9686003)(6506007)(122000001)(478600001)(38100700002)(186003)(66476007)(64756008)(316002)(76116006)(8676002)(82960400001)(66556008)(54906003)(66446008)(66946007)(4326008)(6916009)(86362001)(38070700005)(2906002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ekVvbvdgeIg0zlaNLS7vrl4PnOdI6BlhgLCb5/l4a45gp693aJCG1AZXPTdI?=
 =?us-ascii?Q?uGk2Tq5JrtouGNdf+VF/wlkaJ4m/Zim4mSgJitGinGd0KHPMSX6+r+XmQkgn?=
 =?us-ascii?Q?iZF96WS2AkjNKqoD1xRxEIRDtO39c1nGu/mkb3s3miwxda9kpBlGqmDrjPY+?=
 =?us-ascii?Q?2asLk3nViAj5ICRbhIJ77ej6fMLzixUYredG2y+0BUCNLwxFiDZIwLkkCysf?=
 =?us-ascii?Q?4CdzrmFcloNR1M6sT4V/bOKd6OrhOZH+stbkiquKyJDh9kmSI+8sHxVHvXts?=
 =?us-ascii?Q?w3SaA76PXiOBrwYdQR9vqzaz5k9+EgzRVEODMV3Ut+9oXMRi8j9sQH5+pO8L?=
 =?us-ascii?Q?LUQ8rn5SLn+b9cGB1FrlsML+Mmj4q5ZTs42TJO9fyiAqrbXJcmt2WTrTZpz9?=
 =?us-ascii?Q?L4AtvNtMSohw7K+qNVkvUGTfBbKYIKB9rE1yiRJ/r3Bs4LwyFHfKmUlDIhxX?=
 =?us-ascii?Q?WUyTWV6/7RnUwPIrgdM1+WwljlcS2GYIWChHSyIaZPksIUR7jKXaTueUYUeU?=
 =?us-ascii?Q?LThs+jK1e1fsj3DV/UrC1WhHA35bxZzgyA5AJstJgxs38IR7GExRTy+O0zcq?=
 =?us-ascii?Q?gqXtbdQntXpWQKDOiWtL8vye7zDeikNb1wdnYsDkLsudf6D9iD42gzwP4o8B?=
 =?us-ascii?Q?RTBc9XL6QM/3EkSIA78n34p+h5M1uBT2bPPhI5eyDwvl4/Tij5i1Iw3kgP96?=
 =?us-ascii?Q?68sPASKVNfq8Zw17Z8+ZtcEogfYkfbt3TOQ2sAyXof/hOxDRX7NRLrQ1YeAs?=
 =?us-ascii?Q?8QPHJa/5RnU7j0gHmE8ye9HzCY605BiZZUoV5JNXObnfqPU2RG30QSYoyS49?=
 =?us-ascii?Q?0pJOw741YJK/xb9q188E214CySO8OYYhlEmcPRpPv1Dti1eXRyqmHCrKykHW?=
 =?us-ascii?Q?CVjl7KhLWMTGFKHHB95AhdSOhGeh6O4K5J4a8q/3ry1vm9znfd20IxabLJ0w?=
 =?us-ascii?Q?MpRVc+M6rhn1nzVt2f9RxL1O1mEAy0s/N6bmjU/Ta7V50RwMMcZjvCqgsXyn?=
 =?us-ascii?Q?BMKLq5mV+HwWB0tmw+WnKna9dVorqU9R39tR/BIdKcR2Z5OVt75aWJkC/n9m?=
 =?us-ascii?Q?41GUFByEB0RuyPwCQdcUnGQtBQO2KYiG5YalYMyPRO/deocSivFFROuTziXe?=
 =?us-ascii?Q?Yzdd83N/1SNgMgepzivDKRTeVbPzMp9BP7liH0WKrRJR1TXR4aCStZfSWO25?=
 =?us-ascii?Q?jyR9Njl/5rAdseflExfzLYRMflW7D/IYBXVs/aR1wXweLnzyH1UW8VtLzigd?=
 =?us-ascii?Q?XYOKHqvt5g9yF1IUPpCru3vH5d8gEFK4qY3pJTQY3ivYK9YyU+p55Pgvl1CH?=
 =?us-ascii?Q?EHUDN1aZc4eIs7RDApVlZvMlQ9G51h0fb8oJc0h/4z9+kRbt49UZh9lk5KJ1?=
 =?us-ascii?Q?UNtGi6/MDkL82yJgBGJfWD/pKyhmJsxhKdP17SwizQh+bsv+ePmhKP2mgJ8m?=
 =?us-ascii?Q?zV/DNzlhvpHKUesIhrd+63wuUWw8uqZ5AlFRsJZ9BUDYT6lZhQsok2qXlgyx?=
 =?us-ascii?Q?USgA93lJ7pZhWrjNh7gM6wjazgSJtCHx0D80AFqE9IrvjO+sZS9c1jitqb90?=
 =?us-ascii?Q?YxViuNZ0CoA4Q02hmMA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 624394ea-6108-4177-205f-08dac6de1c98
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2022 07:50:49.0805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wxC4/8dF9jzQT6sU3+57aA8Ax7JdL3FUul94ef2dsDb/efbBITWLxR45JdILku4Xd6lyWrzFo1AKzlR3Yfey5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5376
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > But what about NMIs, afaict this is all horribly broken for NMIs.
> > >
> > > So the whole VMX thing latches the NMI (which stops NMI recursion),
> right?
> > >
> > > But then you drop out of noinstr code, which means any random
> > > exception can happen (kprobes #BP, hw_breakpoint #DB, or even #PF
> > > due to random nonsense like *SAN). This exception will do IRET and
> > > clear the NMI latch, all before you get to run any of the NMI code.
> >
> > What you said here implies that we have this problem in the existing co=
de.
> > Because a fake iret stack is created to call the NMI handler in the
> > IDT NMI descriptor, which lastly executes the IRET instruction.
>=20
> I can't follow; of course the IDT handler terminates with IRET, it has to=
 no?

With FRED, ERETS/ERETU replace IRET, and use bit 28 of the popped CS field
to control whether to unblock NMI. If bit 28 of the field (above the select=
or)
is 1, ERETS/ERETU unblocks NMIs.

>=20
> And yes, the current code appears to suffer the same defect.
