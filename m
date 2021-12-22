Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A8547DB8C
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 00:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244870AbhLVXrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 18:47:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:28415 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244354AbhLVXrW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 18:47:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640216842; x=1671752842;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EFvOUIX58Jr8eQWu1gPNM9vVwHN6uL2FdPoQRxp/jiM=;
  b=d6FdM+O9oYfYiwYMfEIQXj1ayj5sITuj40x5shrcXpv4nxh59kSu6Pb0
   4INofj+kBp7ncNIz+21hcmXjqdUtsdyPf1I+iaoNEDneVyBBpH+AkgeqO
   Y9f5jkOih/Dm4g4VhQ8EBUDTXZ3K6ycTxHkM/wStCCOua4fGsKK5T2TcW
   dxelW3vqULiHi3wKfZc+crtCfziJnqU5MGBEfnmawkW/gB88n7Zi7b9dp
   W3onOrL1i0TCcYvyDH0QHaQpj+PdAbl98Ei0lcl1+kCPHaC5dEutyRETC
   ZTeaZ5jwW8V69NzFbazW6gdJkTnztTWH2cGp030F7R1O4499Ko3/uwhIr
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="238260695"
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; 
   d="scan'208";a="238260695"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 15:47:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; 
   d="scan'208";a="468339899"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 22 Dec 2021 15:47:21 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 22 Dec 2021 15:47:20 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 22 Dec 2021 15:47:20 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 22 Dec 2021 15:47:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXYZZoZ4tO9hDLTu/s5MQso/fNc4lysv6I9rSDkdAdCg1GWCMS2JXmdyWaeqngdCNWE1ZSGvaKs2Wphe6EYeymXDp32WEvKE/04dQSS80Rd8cF96VLZ8vo1nLGmUQ4Ffim0UJ6YgXKGboQFkuDNYMQwPclb0rqepwOnSnt5SS66fOJZ4RuoBVV887KeRA7YuPWLb4EFZpERyczBX4feqIJ6mIo3dXtkEQL3x3AoN6zJiSuX2hNQSdrDWaSXbfTZYh2QHQagufZjBx3WdTnm+bdnOJYaAJoCmK1zlselsMxCUb5k6zM7t6q8htiGdwu6+RF+4TeU8lNBU5432HgHa+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ea9dyJk+FoMSY5KgKmQMWLn7s5zzYrsnc2g3dmvVZww=;
 b=Kx0J5QEJai9oI5tcfNiiaKUrh0o5cUAu+bmn1aEdQnqvymo+NxeY7qrL8xuPjjDdaKgyh7+C2efj/yTjXAR6b1bSv+ZjmdUD5FSKo34ItEA5CRoLujCSjNXAhjAY9hnq4N5YMgqk8n/0xs/Yn4gabgRphIGZPmA/GdiqLw9uLB6xlXlGgeAE4pKh8Sr+7IDhzc83EvhYbUzqwXtXpEX7ikhooskMoKFr6j+ClQT/z4xDMaknb7Inc6dOdz9i3HhG9UM2SRzGIdd/8+1jh/xRWxyotkfVmYO6OxNGx0SwzSAdtmVQdpzxFP/HsLwFvdmz/roW+D54kagqbLam6TMdlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BY5PR11MB4435.namprd11.prod.outlook.com (2603:10b6:a03:1ce::30)
 by BY5PR11MB4182.namprd11.prod.outlook.com (2603:10b6:a03:183::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Wed, 22 Dec
 2021 23:47:15 +0000
Received: from BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::495a:4bae:83b3:b111]) by BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::495a:4bae:83b3:b111%7]) with mapi id 15.20.4801.023; Wed, 22 Dec 2021
 23:47:15 +0000
From:   "Nakajima, Jun" <jun.nakajima@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>
Subject: Re: State Component 18 and Palette 1 (Re: [PATCH 16/19] kvm: x86:
 Introduce KVM_{G|S}ET_XSAVE2 ioctl)
Thread-Topic: State Component 18 and Palette 1 (Re: [PATCH 16/19] kvm: x86:
 Introduce KVM_{G|S}ET_XSAVE2 ioctl)
Thread-Index: AQHX9cqX7SWtWES7r0ekmxWWLzZDHKw+mUGAgACXqIA=
Date:   Wed, 22 Dec 2021 23:47:15 +0000
Message-ID: <C208E9D2-654F-4712-9BBF-90FC677CBAB3@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-17-yang.zhong@intel.com>
 <d16aab21-0f81-f758-a61e-5919f223be78@redhat.com>
 <26ea7039-3186-c23f-daba-d039bb8d6f48@redhat.com>
 <24CFD156-5093-4833-8516-526A90FF350E@intel.com>
 <a17363b8-41d7-af74-f66f-362bfc2c6c9e@redhat.com>
In-Reply-To: <a17363b8-41d7-af74-f66f-362bfc2c6c9e@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1585a3eb-6673-4df3-807f-08d9c5a5620d
x-ms-traffictypediagnostic: BY5PR11MB4182:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BY5PR11MB41826AEB599034BCAB7E96E19A7D9@BY5PR11MB4182.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UpkuyjMcHSGenNqv5wMPZnklgmRlUA00R/HsOaVB/mQiEXt2O+DEhgAopoO+5Eps54RKawuSYZa2zWxm0SVyfH5pjyCnxhNnWiefo/L+n4ATaOSlKrchprWM8uL1V//65bQXvqtHj2yO4AcqR0uW4MEb3NsXLvy2GyoZjLCvRoD2bXuqZIAjPNWJg7TgnZMPBGmZh9CHD6p6cenZXUiApkqb8iwYli+1IFypYx6je1v+XiTQ5dyWP9qwqkcZ2YrP5HLiIWfV05S9mCZDYX0MF/ZexV7H3r6jgA/UP9+GYRRQwf9szuQMu2aUzTzQAVR9YqZChRxICoEWuWcouG6wJUMO8ME8uGYX8NMBXXDiNYrq2+CR5X4nDlez/mbsbl95Ph/gfVl/yaLyeoxZXf0bhbuHG69xDm5lfTOAoEXyjYX9upW1k6vyi1ceRJsWb4GvzXD+ZBn04l9L6CbxsNLkjq9slH/BRV1VQVxJZc8LhmFnN+j/+PLgw/RU41susFFigSYrXmspip+dcQwXY4/mGvDplCm39QOq3p2S/OVnMT69SpqP++VWWCpLaAnEBCJmq/nxpHYcVDwG/a3bdgNmzM465CaUSInyM4PAFNpU16wBnoBlDX4ji72F4ECTFNOh2mLV7hZfggV9Km7SgNfTn5OwPi3/nVEdIRuxCY0YlRuHl+5NM7Bz8k9Zo5li59Q1/ka/2JhMpoVNzDewbHN2TInF2ON0CLNjQ1czGudfQiHd0DH5RTOHXjunuuH0ZKHV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(4326008)(53546011)(122000001)(6486002)(186003)(66556008)(8936002)(33656002)(6916009)(83380400001)(8676002)(38100700002)(508600001)(71200400001)(38070700005)(54906003)(7416002)(66946007)(26005)(6512007)(2906002)(82960400001)(36756003)(5660300002)(6506007)(76116006)(64756008)(66446008)(86362001)(2616005)(66476007)(4744005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Dh+DNUyQS2YxEiy9mVNJ0+4VZ2plVaKws8xK6XSbfj2w1pPxATLdSd74pGEM?=
 =?us-ascii?Q?zpSfRpFzCSjUZAP2FNNMb16BGUv3qSr82QQX4DaffR42kUEdPFwm1+7BKsp2?=
 =?us-ascii?Q?tfsmDP3fTs/cCPAfMX8nek6bFZWEoliXGgcq2qlS1eouIrjl00NrXowZy01z?=
 =?us-ascii?Q?jllNtx9ohxAL5FxL6GFG78Sn1ZPJlL6Xo9yzRX/oSck6mdGN3zRTd94mAghW?=
 =?us-ascii?Q?jd8HAyMS/kivfcgbVNwUbv1WiyrdPYcHRl/9S7qoo35bn5Uvr3xOjjQv6iGQ?=
 =?us-ascii?Q?YG8fd+c0wJ7HU0TegEBcWywEX3xt8ECtiXyjjNNgzTgTzWEXDFYe9C5RBBze?=
 =?us-ascii?Q?j2l7r3AsJ1m5msgz+X31tvC2kj+dlQObwS8FBF5QcyM5fyLW+T7HclzF6Gc1?=
 =?us-ascii?Q?FiW9MqEs5y12KiBBkyMBM/P3kqG9GzsdqfCBvJYQsn/pqX/Zd8ZepYvzayc/?=
 =?us-ascii?Q?O4+IfqOQ6beqI/LgoUHzn/4VbFBD8lVKjTn08ktxylRPn27jj0VsNMZbOql0?=
 =?us-ascii?Q?Mz1Ry6RTP6m5z1kKF1fPWJm0qquFyOxH82mLY7yG0Z0V5YjH4NrXgD3JZWwV?=
 =?us-ascii?Q?oS2ljvLua75xpQyv33nTAj4fzM1o8Gszc9GGPys/4v0vDDi8/AYmfjOsuXpl?=
 =?us-ascii?Q?54akPuxbnZOzdAYFKik5B2tB1VYZ6rrsIiendV2uyU/4PCMEe1AYB6wrhCrb?=
 =?us-ascii?Q?L77ptF9KTJkorEw3Ba//G6Bm24B39peqivX0fI7GpLhoE56cR2lE4mO0ZEN6?=
 =?us-ascii?Q?vWhiU3u08g6flU77j0i7OflJt3nFbaZvKVgQ0tknV/3oAEmLvN54wPP8Vouk?=
 =?us-ascii?Q?6QJutH+yaZKHcPqT1VtGCy5/1W7g0bHIJRT8sJR/IajyIfpys9GjgcfgQKR3?=
 =?us-ascii?Q?LWyC/koa4bPQ1XbrlNocrh28hEBdqxMiURttC6jRTsf6OrBfvT1pp3Kc3KRZ?=
 =?us-ascii?Q?qJdtsQQvJtxHx/MbKY76raNsEMtX/mG65C0wvdRZAJtSc0tUK1pNwh+8nLNs?=
 =?us-ascii?Q?YqAqMlcR39NhV5v5NZZu+I20/i04D4fuHC5jcqxCkoq698IeKbefKApD6+9E?=
 =?us-ascii?Q?sQvDOePSqfKGk9+PLP6OhdmuasAI7rS0zkMmOSqvp7gmlcpFTtKbqtItgJGO?=
 =?us-ascii?Q?9LXYyLR+YQK1xpkkzCuCH9/SBAGntb9ookNF4CUtelPie7EeKFFnyDsfAxuR?=
 =?us-ascii?Q?9GIZ89OYgJvg+6xtosukvOkr2SbfVBA1yexihlkxlcdPylWUmg8dh3KCPeI7?=
 =?us-ascii?Q?HNd+es8wJM9sEwWC5Bi2OJxbj3FmAgaJuFpqXQ187ewVJH7F/sJq5OXq+msA?=
 =?us-ascii?Q?39TQ6J1TixpICpwpRaas6RvENLIpL+xR9g9OvrsjXblCvYKlKegZO6OrzEC6?=
 =?us-ascii?Q?0oYx14NyxM6G8UtTstBFzaS8dyNeK43ZpAw0t/GrSsvHS2puOMOJxH1FDxls?=
 =?us-ascii?Q?xJBzNTHyVhu4uDrn8LvKEZXKfp8iv8gQSaZg+64n6HbiXorjNkyBw1aM0COR?=
 =?us-ascii?Q?499XX26TPLOj7DGzMTGVwlHCFlPq1P9OjWmM/LYbp479gbkSUR6itJuGdED4?=
 =?us-ascii?Q?EXeVs7PIsiZKsarZxTUGyMePn/y5Et/+4+OhoT37YcV/USGCrjJr+pq7mIFE?=
 =?us-ascii?Q?4ADmyQtbvXhC3B3rSe3fwyw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0A03133FED569B4CA4CB57C4025738D0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1585a3eb-6673-4df3-807f-08d9c5a5620d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2021 23:47:15.2455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7fmpoYXxERz8lbNhbgDgpaORPT+nfOh+bDIlDYcfj+BZaiuEd06UsXgnO73uzP3Pu6e2RGehqOANbHU1yKSwKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4182
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Dec 22, 2021, at 6:44 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 12/20/21 18:54, Nakajima, Jun wrote:
>> Hi Paolo,
>> I would like to confirm that the state component 18 will remain 8KB and =
palette 1 will remain the same.
>=20
> Great!  Can you also confirm that XCR0 bits will control which palettes c=
an be chosen by LDTILECFG?
>=20

I need to discuss with the H/W team more and come back. I think this reques=
t is plausible; I will suggest it.

Thanks,
---=20
Jun

