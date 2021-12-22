Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1178F47DB91
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 00:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245314AbhLVXvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 18:51:36 -0500
Received: from mga04.intel.com ([192.55.52.120]:59698 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232471AbhLVXvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 18:51:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640217091; x=1671753091;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sPxQWRzFXhsEaMuroMuUPvEdhZz8vaD2vllyQYHtKRw=;
  b=aXqcIiDUpIZCfmZwPf7xG6WkGvhpgjd95+kgPctD0m4tE7NRR9CV5p6p
   1qeWypZXdKZb8WnKC7RSdb047vjjSNwwLh+pudhN4+zRyh6RsoXEeYBCz
   DlDtnOeLjfwbb2lIgv9/vB0Kq44pbXM+THtLawE3CTtoZx4S3Z4B0zky6
   q3iCZ3rSg/9Ql/WbSI357k+tiyGEnJESwZ/vHvrfdkmq5bqijeMIHevZc
   8QlezCNCCxtDT+QAHxupQXclTlbuaDCh8fuyDsARK2CTznoMtX72Ydt5E
   C6KNvUneppCicUB0whKfIv2ZhbbkPuK3kHhWhfSCnBW1Oysf69GCyhI+Y
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="239478991"
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; 
   d="scan'208";a="239478991"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 15:51:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; 
   d="scan'208";a="685187469"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga005.jf.intel.com with ESMTP; 22 Dec 2021 15:51:30 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 22 Dec 2021 15:51:30 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 22 Dec 2021 15:51:29 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 22 Dec 2021 15:51:29 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 22 Dec 2021 15:51:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tp53E2i2isVR6GxPjPkcfu+yF1THZ/Ay3vWPFMcxVXGN35+OJbGGAnNaXqba61FFjPHG7mNHWnW4cRBDaJ59rl+FTE19hI/CnyvqGB9G6khZvG+m3AsGahWx2dHWiCsbKap0yI4FjJIOEgSMrh7VZecStqSZ4DB5j3QwvQLLiSv7R6MPlB7U5inK/T715uwT3IGZVcW1kVq7pJ3eG7M6PzxhRdfEsmKJs5NAdv9glMABDzCH91r09vPut5lN71b7CDqMJmrEeg3FfjKsQWIOjCKrf5p0EzkSGkZe88CNH3HCcXWuKMCCKGfofHxG4whpw/HOde6GE5QcPYArVy1jXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m7qfGP0WChZqRvB9XkQ1bEU03HVJnuhN1JY2RiEdnm8=;
 b=XR/6A9psjfNVmHhyxN5F970AP8anSRD/1RZMx42JxrTo1c5NQHecG0axDs3PHW5XCrQN6JNIxy0+E3z0UZR2KsS97hhu8vss1jHqM00r+i8TktUVoa4YyBPq2aDEMguX8APEnDUU04OfPKPAA+ESSMWU4Vor5Slg2IBxxM8P6zeL1/irX3rPGV/ua0HVKx9PEa4hnNb0y54QOSXztaONy+BlNvfhdTCww8g1wcG80LRoOqMadsFQreWQ9UXiwYm9HjzUlSnFYS3U+PoieDTn91yN4aqP8a2BPZ/+eHuQwHKNaKTNOSTyv2tXmwVm2PPgdjx2m9MJdohHqlEwKfxirQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BY5PR11MB4435.namprd11.prod.outlook.com (2603:10b6:a03:1ce::30)
 by BY5PR11MB3975.namprd11.prod.outlook.com (2603:10b6:a03:184::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Wed, 22 Dec
 2021 23:51:22 +0000
Received: from BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::495a:4bae:83b3:b111]) by BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::495a:4bae:83b3:b111%7]) with mapi id 15.20.4801.023; Wed, 22 Dec 2021
 23:51:22 +0000
From:   "Nakajima, Jun" <jun.nakajima@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
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
Thread-Index: AQHX9cqX7SWtWES7r0ekmxWWLzZDHKw+m16AgACWsQA=
Date:   Wed, 22 Dec 2021 23:51:22 +0000
Message-ID: <5204C914-9C5E-4273-857A-198A955DE2D2@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-17-yang.zhong@intel.com>
 <d16aab21-0f81-f758-a61e-5919f223be78@redhat.com>
 <26ea7039-3186-c23f-daba-d039bb8d6f48@redhat.com>
 <24CFD156-5093-4833-8516-526A90FF350E@intel.com>
 <3afdb885-d2d9-c099-bc72-c813521b6b39@intel.com>
In-Reply-To: <3afdb885-d2d9-c099-bc72-c813521b6b39@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd402f87-c64c-43ab-4e91-08d9c5a5f541
x-ms-traffictypediagnostic: BY5PR11MB3975:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BY5PR11MB3975E018DFD21F18D27A1ECD9A7D9@BY5PR11MB3975.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7X4Ppg0u6hm/dYlgWrMrzKFa1nf9HzcXyUbuwK2toz/FiorzRJIwPTWMWSJLEBJIbna1Cvg2doSejsVjpzVH6BnEB78bzFY2c+JDlCwhcHard+fy9PpDj/XvPPznHkUu0ON429VGT5CQAqcanoCGUd26mQPKx2pPgUTKW75wfM2eUSADB6h4vainaNzwrTS3Kzfg1mvvpTM8N43pTZoWn4De80n/hw8JDYzE58NDWbOurq1JpphuixZvmtZ9L9zonND63vU6e1t+YFxpcQFETvamxMhahxg754PnOF8ENmKTUVIv2uEJDtGMfQBjIo6cjwDyLHgDuQGL7sKoGXmAEsLuaBmdmqebgBCO/N7Gv5BORj6f2M+DPnyg2xxhn/+t4WcZ3Z3iq3WVddPle3hmGVjFh02BuB/zJYUy2GirRcT+YPSiBrZr9vT6HqqBNnIg0KEJqW1VYZyzLGjKVVkH18XqEkkAzLRWtUas86BJUbTkmjCd30LwHQ7iBoTAHXeR9wEJyp4Ue0tiJMCITvz5szZxzTAKHO/7XsCyfn3xnKD0ebwg/gfFKXml7DIepwN+ULOfAuMjrLD2l7I18p2/iUgirqlPEbxkUBUmovBIN8r4FowRfwASQUKhzRzO4tA2DbV+K6yBXMDFz4+gld1d6Nfut0BDFog2UUlKHiAsK2mTQIOD6qt1HasM0KKGyQZCmJ7swQr6W8XfEDgD0PVy+R930h02ccqWLti5AwHhYLN7oghY9C43faLmCKQTbYKG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(2616005)(4326008)(316002)(37006003)(6486002)(54906003)(6636002)(66446008)(82960400001)(36756003)(38100700002)(122000001)(38070700005)(83380400001)(5660300002)(6862004)(7416002)(6512007)(508600001)(4744005)(64756008)(8676002)(6506007)(186003)(8936002)(66946007)(76116006)(71200400001)(53546011)(2906002)(33656002)(26005)(66476007)(66556008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wQh7fzXKsrYojAR1G8uLyA+jX1Hf7pgbb/p7WA+m6VnxLLnI1PkXOX5lZ1I2?=
 =?us-ascii?Q?T+t2ptEXoSJx3hRkmz95p/cOLzWtDvPrVtvu2YCGDIja88/WQF2sG5Szu2+T?=
 =?us-ascii?Q?xtKpS3osSYuPuWAlA8e3jwGkLV144GgIvwiVdd/DSs1C/llwbcbNa0y9oj2Q?=
 =?us-ascii?Q?8DxCtrQB5uNi9Kj9nY9qgHwb9bP9VWuGtcL/JnRkFEif0W06tBIQwVqNEDtp?=
 =?us-ascii?Q?LhS/lEvkCZ/V+4jK88x5aepUN/bRe0/hsg+043LrHDhk4MTuk+RYG/e43W4g?=
 =?us-ascii?Q?Gf4SMbWI3hH5krRgVpci8RTXh+9muJeYNTOE9IqMGAhCVLNOai0pyM/eigV7?=
 =?us-ascii?Q?XySLEpzyQe6pdXrzipMQ29NtftUuhAaYV16hm8JCgFHIIGm9+DIMTa/VNN7v?=
 =?us-ascii?Q?0BudnOBR7MB+W/EYK+XjaZT88+A9xDkD0iszoVSqlU27qkrl+q/5qshc/FVu?=
 =?us-ascii?Q?j9sSW9kCF2kGR6I7gIVV4XD5bvvZsoLmx0vBgim4MlhEQaQ1lyW4T4q5Sj1a?=
 =?us-ascii?Q?Q+m5h2NJO9rf8HHcSihdD+TAQpiazq28qqDFgTtwB1zRm7yM8INpKK+clI9Q?=
 =?us-ascii?Q?U61LKsIhdO/JHbGWPh9GUuCSJjSNG60rwtqXBKkKa7w2RFikn3ky6cFywba6?=
 =?us-ascii?Q?uzBQM03c1UvBUuDtr5UrjB3beWCq8rzMJPZpnhdnLebPzCvnv8KMY490fc8M?=
 =?us-ascii?Q?/7Id6U4FEY9agEMidOB91k+Hm78Uc2exeaXFcjbA+Uo97o7r+NgRHL4HSTmp?=
 =?us-ascii?Q?mG55aJIM8F22rJGc4LhkVpEryPT6VEiNirHymQH2CshY9EpGbxfl/EV3UN1w?=
 =?us-ascii?Q?hTwhh42b35npsY/3+oRjXXMLyqAcHlvnrwji+dPp6cKF+r4Ct+w3YuCcYrJk?=
 =?us-ascii?Q?nCfGJ10EDy1uQFYJc60LKb9v8E3v/XP/fSD+DhslNtgKT2PFQO8uKu1YnExy?=
 =?us-ascii?Q?g6I7XGutJt7YDwzov/XAl+a7EuyodV7lPFZbxpwhgyGrnCJ4Pd2jlWwZy+xc?=
 =?us-ascii?Q?LbTbW4HIksMtYZH2syvLj2ZKpxs+vnaXnllJB7Hmtyk+wQ5Ab4b4Wbh+ezgE?=
 =?us-ascii?Q?Ubnr3hpKnYIyYnhA0wF65QHNO32wJJKHetgh7Nd09KWm9csL1CyvHx5L3lX2?=
 =?us-ascii?Q?RKmzwwbK88//BB3nY4JnzTjJ/xer4SYPyUqzeFUaA3isMLTXCXjbkccHw3f5?=
 =?us-ascii?Q?dqRaKT/tCpPuZaluagw1gMKosmo8Euq3xpN6ETfLa9rU1ky+vMqAqg61RKt1?=
 =?us-ascii?Q?8Z4u9retYoA4rErKxViL3rfyIvNs32DARcGHYkU5HrX1XwgFxrllB2gw4Ivr?=
 =?us-ascii?Q?kTgGoMeSf7TjNSZ5+u5k4cxTm8g86xzk4aCrV6QNTByfS1WdDqLRXpGs1h4r?=
 =?us-ascii?Q?v+7Un7dHV806t0SSaEz5HGaQdf8tUio1iaGXnvwvh2Dval1B+8qm/1auUSuU?=
 =?us-ascii?Q?gGXGLj8JFOCwniOnLCMavc9jVCq/umjK7D9AVeJI6knbNjtIYSsQChtJceAq?=
 =?us-ascii?Q?X+vmw16x3UgA4DZDyklZum8mrpbmhlBY1IfIqzSNKNSyChPU3oS0LZ783nWn?=
 =?us-ascii?Q?bCEfGfdF2l8ITsfSnYomxfPxGOpw2C6IxAK050dS4jOUKBBgq8InoWGB+h26?=
 =?us-ascii?Q?uS1AnP1dAyLaJITePk0THbs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <54CCAD5ABBD89646830200E993F5BF10@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd402f87-c64c-43ab-4e91-08d9c5a5f541
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2021 23:51:22.2020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5h2VRsFTYNzVUa9jav5KlFtNbi86+Njxivy+5LtxfrHp8tHNcGja3PCrSwfNQz89PcX1q9AwdLmkraE5snhOXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3975
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Dec 22, 2021, at 6:52 AM, Hansen, Dave <dave.hansen@intel.com> wrote:
>=20
> On 12/20/21 9:54 AM, Nakajima, Jun wrote:
>>> So, I hope that save state 18 will be frozen to 8k.  In that case,
>>> and if palette 1 is frozen to the same values as today,
>>> implementing migration will not be a problem; it will be
>>> essentially the same as SSE->AVX (horizontal extension of existing
>>> registers) and/or AVX->AVX512 (both horizontal and vertical
>>> extension).
>>=20
>> I would like to confirm that the state component 18 will remain 8KB
>> and palette 1 will remain the same.
>=20
> Is that an architectural statement that will soon be making its way into
> the SDM?

Yes, with the other clarifications (e.g. setting IA32_XFD[18]).

Thanks,
---=20
Jun

