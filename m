Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE1931532A
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 16:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbhBIPta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 10:49:30 -0500
Received: from mga12.intel.com ([192.55.52.136]:42006 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232452AbhBIPt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 10:49:28 -0500
IronPort-SDR: htOd6o5yqzRlGh/7OmH5DbfJcx1ilL7MXmBCdEq8FNx8BzU5O/KGf09sOoktSAaQs8Z0CNNcKg
 OYXKqGSjGZ0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9890"; a="161052649"
X-IronPort-AV: E=Sophos;i="5.81,165,1610438400"; 
   d="scan'208";a="161052649"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2021 07:48:46 -0800
IronPort-SDR: Y//QYvkquYurrVFuMqLqQs4CM2o1FKdB5yEJHDIq8L/suAzq4RbZg70TElHaOJIBHtqq0hhn3l
 Q/hQuzzc3E2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,165,1610438400"; 
   d="scan'208";a="396196426"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga008.jf.intel.com with ESMTP; 09 Feb 2021 07:48:45 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Feb 2021 07:48:45 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Feb 2021 07:48:45 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 9 Feb 2021 07:48:44 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 9 Feb 2021 07:48:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ky7Ae2CsznDM0vls6YLDzJY6/+fpc/eOYATTSvYWW5g0SdufwLKe96EyqC5kY550VDOjuT+iEDqxL1tgp5MM9SbGR1EyT28dI1Mw2riLxU3HayK9TSY3uTnMWOj5LWmWLFBHKiceXJOtmeqD3VCZry5OFkwz6kTZ5gvUuKSGtQ1eq3VYMhj1O4C4UyfDRZNeDhDU65J84Fjs5tauw9QRAkAvNEvL22sUKqXAP8ZjnRTra6dBaHneOTgh4imNcv7Grurcou7SIWE6kGcLuYvOj5vOlcRbYKPPO+0cnHkq10X2owoRcZAi68ypecEZxkG8iMKA7tE2Vn7Tan8Tm3xgkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2DCKmqLq4bISEfoBKQwWtUj7apc0xCsaL308vtwPu4=;
 b=HWoRVa88KMI8U74v9GwsqfAuO2NQGeQ7YdYBfdhiXXWQ8vxlhWffWa4lBKD2NrBRX0g+r5mtvIycRCFD2QB9pk35KyMOe+V4DYaiQLs+RIQwwcaBIjyRVuqnabRHj2VA+Qj9cBMWXqApfMkB8tgdkbZEceujHH3dfPtgKzvSi8fdab08PihJqKG/M0aM4gDfbY9ZHsfd/N0QEiyA9FV80I2MAFhbxuFDfhGgCaoAgWeBgqDxUcDO6KSCqCcMohZh80NW6UgVCGQUxbEl9C7OWab1F6cZCsKpaxwQ7T6oUPMgNPmYlkYCcZ5P/nOBsUXSLosx2exPFXKRHPcVJt7a3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2DCKmqLq4bISEfoBKQwWtUj7apc0xCsaL308vtwPu4=;
 b=ZAfPUQTkYKivX996BT1t4B7UVVrEVOGG1/BQu9ts2/Y1gtbe+8oyFSL6ZmhqoGBk7/MdJ1+98Q3OdlNKV10eHvTR1uEG+wW4gq7kKaEZxjOLMWxK18hvEkNolTERrIXXRJoCl1lFoEwIDW++9ZMg6dZmMiBQ9NCqoicHnawgCcE=
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH0PR11MB4853.namprd11.prod.outlook.com (2603:10b6:510:40::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.24; Tue, 9 Feb
 2021 15:48:42 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::78e6:b455:ce90:fcb0]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::78e6:b455:ce90:fcb0%6]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 15:48:42 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     Borislav Petkov <bp@suse.de>
CC:     Andy Lutomirski <luto@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 10/21] x86/fpu/xstate: Update xstate save function to
 support dynamic xstate
Thread-Topic: [PATCH v3 10/21] x86/fpu/xstate: Update xstate save function to
 support dynamic xstate
Thread-Index: AQHW2UTrfabGiuGaq0+dx4jPc8ZDRKpOes+AgAHIvAA=
Date:   Tue, 9 Feb 2021 15:48:42 +0000
Message-ID: <F16A56D8-803E-4B9C-BAA0-B16753BB273C@intel.com>
References: <20201223155717.19556-1-chang.seok.bae@intel.com>
 <20201223155717.19556-11-chang.seok.bae@intel.com>
 <20210208123359.GG17908@zn.tnic>
In-Reply-To: <20210208123359.GG17908@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.189.248.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff0be20c-9bee-4ce3-2b2f-08d8cd122d84
x-ms-traffictypediagnostic: PH0PR11MB4853:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB48531B26218313B899F8EB53D88E9@PH0PR11MB4853.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:751;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OCxxgcSk7QwDq6QOPNoCNLOyKhbxwwUhvtnlFFTAbJe2978ckPAR7IQzgMWErAYFzvXLu5NSXVd7ZJRgGfAtZjQin1kLEZfGCL6Bw2iAnwzV/bqqdykC0QjDjeNad/4yIHppYaGK2zhOWVWlvPpiTNcXL1mMs5yvHv8GruCg+ItSvbdXD1G/jGbb9p3cw1IZrumVEtbxGpL+LEM06CQahNXOTqur4EgH6bTxcbnjJ0bxxiX70BzKtDm8IhPyx4pwpNAiUja21KQF/7FCSp5oadwUttP7sDEbfwpN5nQEHjATIThIaANSA0KRV6WWvGgf7FsoAm59iTWeXJBNzjsC21yjZBxW3DW/7yl0cXavWHHN/zpEuj5knSJXCeJ8yeqsu8WvpyMUE7DOY+r89uJ081qeeOSseXKBdw8BH360nC+0ZEdC4YVlHBRuDlIUYuBn/8r2rEK6gqlHBML+i7q900WfPGa/02bcwdwjt66wqHZnQcIQRlYuiHvWCG7bOnWLlyO2Zjd3sh9IT0oFFYlnzdEpRo+i1AWZ0CneLW798dt++srt8Mnt5wFLE17qNB0vUR3Ddhxf3APO9lsqqFgek/5ksPlaRT/lQj9JBOBLPqfrklFtsDYj6Iw6LxMrAgWn4qH7gtydNb0XNDgvYgVuhp3h3DEJJjXkekotnrGmprA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(136003)(366004)(376002)(316002)(54906003)(5660300002)(6486002)(76116006)(15650500001)(6512007)(8676002)(6916009)(2616005)(966005)(71200400001)(86362001)(4326008)(2906002)(478600001)(53546011)(64756008)(83380400001)(6506007)(66446008)(66946007)(66476007)(66556008)(8936002)(33656002)(26005)(36756003)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?b99RBc4mi4KlfwO+l7zNhJ4ii+dfnfevhtDv+h0oGVtbX/oTnCkNMMdOWRws?=
 =?us-ascii?Q?tb7f1aW12tFkADaeZ9Jk/VAlV67xv4VqgnqhXZDYuXplgmtaFoF1qV7RYkr/?=
 =?us-ascii?Q?28N/NtjhlaMAeW21bK1kBQJFiUXf/UZYPuji/+LUfY5RVFt8OVsyMNIa64dv?=
 =?us-ascii?Q?PntGspPEbFx3Xlo3tlnMI6jxjxT96VPdlDBbAyKmrv+852dvWF82d4cByrQ/?=
 =?us-ascii?Q?+5hHhGU8BnBf1Gjwl9tnXhFiIYjRnp2RaRzY3yusXSgHFEi2IrU25sNP86Yp?=
 =?us-ascii?Q?+myK3Wjy9h3vY8wrijCIXdGfPsb7xkE79YEa+3DRZSMegvrO4/pgOzVQ5hNL?=
 =?us-ascii?Q?00CQeWo/7LcYmlw3ASUfA/p85bjSEt2AGb6FeKnqOqRpmWIzH4k8tSK4/RkJ?=
 =?us-ascii?Q?IFzDl/SV7ge1lHJ6vn2ahnluROhTjXC/i8qoE6tKERwTkqxb31mand70F2Z4?=
 =?us-ascii?Q?y96GBV/fZ2gVP3z96iacoMEEZbKJBLn/qySn4ApJiYcE8VW37CQ5L8O7My3y?=
 =?us-ascii?Q?oRlBqOCvGTRQ9a682rGOXwOz5hNKh+RZMKgmVWQUq230pGAFTBEP24w1RvlY?=
 =?us-ascii?Q?rsFuY8xSkkAU29MaE0Cl41RsksWz7TVT5qqEo27LBdlNUWzy03tw6hwcEtKy?=
 =?us-ascii?Q?yIv44Omgw7zGxnpi0NWQgLBL5dDBddEbHpmMspzeLm71JI36AK55jbb3SoIC?=
 =?us-ascii?Q?F1pc8ifqXrszHpis+QlDuTfiVz7qiNTTZ5wUfEoaTAfHXel0SqfnH1KjFMFD?=
 =?us-ascii?Q?6ut3h2RkNnhdYS4mOd+y33Hnm+pYixQ5i4YXuoVnzdlea4s6YmUOJoaa9y3o?=
 =?us-ascii?Q?mj1R4TRlt06JQgv44kRwpg2xs0GhTHP8bge42rnN5PVQo447dAIorySMuTwY?=
 =?us-ascii?Q?7DMlbsl+lyO15VkTzLMrKVwILm01LdvHJnB0g3UtHuN/0b+qs1Cod+yISkDj?=
 =?us-ascii?Q?QlLSMvJp8Lx30T9hACH5UE6X+lEwRP30O1c25LpOJ5H3EEGRAZcSY15Vp3wn?=
 =?us-ascii?Q?XSwUQgrC5S0PG4TLFn4pBsyRn6g6CqGstEkxyHBCXd+M+zwX8P339NSVpmdQ?=
 =?us-ascii?Q?qgzZ3qemPBcrv+mhzKHVpFF5YpCLpS89IZ0O27KmOh7QV5WaNv0xR6JQ6MD+?=
 =?us-ascii?Q?+5pHuTCofPtu8HlYd3UreNsvxwCPgdKkXbFSBPNvMmjCAy22OhVP4EH5/lQt?=
 =?us-ascii?Q?LF4PAdJhMw3vBHvYdbC7uwIUWaZEUrRMUekjtkIp3O5oi1h+XY1KOY9qQHv2?=
 =?us-ascii?Q?zB4ggnE85CbK61IP49wOp09XwNNe7KURzQGMddOiOxyLIcozILUpOXT5qzpm?=
 =?us-ascii?Q?uHBtnEX5JtfylHw5b53yIhUOUAO2Fuk35JX1jM0v2/o83A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4C30D23ACD28D94A9E7F9B97CFF05237@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff0be20c-9bee-4ce3-2b2f-08d8cd122d84
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2021 15:48:42.7775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 94IfpqWlOUiK8h5Eh9KfYYmVHmpWQvCNfY7Qnd4oni9ZdZfWV4Z4Cg8hJa0NWaKo+1YvA+Wq01K8b9MV325gIuopcSW0lCP3jm9X8KyKGD8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4853
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Feb 8, 2021, at 04:33, Borislav Petkov <bp@suse.de> wrote:
> On Wed, Dec 23, 2020 at 07:57:06AM -0800, Chang S. Bae wrote:
>> copy_xregs_to_kernel() used to save all user states in a kernel buffer.
>> When the dynamic user state is enabled, it becomes conditional which sta=
te
>> to be saved.
>>=20
>> fpu->state_mask can indicate which state components are reserved to be
>> saved in XSAVE buffer. Use it as XSAVE's instruction mask to select stat=
es.
>>=20
>> KVM used to save all xstate via copy_xregs_to_kernel(). Update KVM to se=
t a
>> valid fpu->state_mask, which will be necessary to correctly handle dynam=
ic
>> state buffers.
>=20
> All this commit message should say is something along the lines of
> "extend copy_xregs_to_kernel() to receive a mask argument of which
> states to save, in preparation of dynamic states handling."

Yes, I will change like that. Thanks.

>> No functional change until the kernel supports dynamic user states.
>=20
> Same comment as before.

This needs to be removed as per your comment [1].

Chang

[1] https://lore.kernel.org/lkml/20210209124906.GC15909@zn.tnic/=
