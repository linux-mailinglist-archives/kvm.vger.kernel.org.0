Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8950928AB5A
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 03:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbgJLBTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Oct 2020 21:19:39 -0400
Received: from mga14.intel.com ([192.55.52.115]:6712 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbgJLBTj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Oct 2020 21:19:39 -0400
IronPort-SDR: qTAmnYp9FJA67n5MsUY8j10lvgSZ1OD+B6wx7y76m99tiNwjakdJz7n7HiSHtxA58g/Z7AvHMZ
 0kgyMLujFzfw==
X-IronPort-AV: E=McAfee;i="6000,8403,9771"; a="164890354"
X-IronPort-AV: E=Sophos;i="5.77,365,1596524400"; 
   d="scan'208";a="164890354"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2020 18:19:38 -0700
IronPort-SDR: ENr5O3DMvqgMXJBB7DwBmwd6Zpf7xUFaj4giJu1FfY3m20N+qEZFWy0deQjha3q0eU3eG4IH1S
 SVKnvBhooHUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,365,1596524400"; 
   d="scan'208";a="520500221"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga005.fm.intel.com with ESMTP; 11 Oct 2020 18:19:38 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 11 Oct 2020 18:19:37 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 11 Oct 2020 18:19:37 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.54) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sun, 11 Oct 2020 18:19:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqeAXrTxDy9uTXYO3davL1MFBDvdaTarRMaUCQ5pkjQ5NDmThA2Qb0gy3n+GZmpYTr9dOyycXz2CsT8qRFfpVzIaN/1lMUO7OclusEap4LQMCdD9xjqg9hXznfb7B23wKRL3RO5BtXQzafNRe4mGVoIvNdjgAT8b++UrMMLTkZA8BJJfpwijT9rMDmWnuft7Y07OjlL29jSNxtrc12zo1hQJvJylgGm/QxgmEuq0reeUlwpWegdAHuDQKfqsFKUn/P81ELzWQSv59Z1TRCs++WxGmLHvYzLx92z7XjGTb86THKbgw0a4ZtS6pFOiSURcjdlRsePah8atBBKu3FzICg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wY0lBv+pLBj/OBBgvO+vtGENANV2IvfFyxPpZq4u/RE=;
 b=alwlaMM5bjQH5/YWeevEpf+rxogwetc3XEdzdbbMb8pklcSpIREMkdA9Re82YBfXi3DZmRRpQB+k/T8OP3NuGp7xHclLeSGdPnmKWxwqxxhfWwRVPcb/SM8cdsyGCv1Sbz5QB5Oiq7bEtIsoPl8eOmYW7PVLg4WJovo48+XyprkBAXSGN4/Gs4mxFlqZJdo051+d/6r/TmiXGwFTaRvkvSxuOCmTHc61Y2qG9T9FGz2l5GOfKS9bWHg0i+QCk+TgeHmX2Rrif9VB5NZdDfIRv96itWrt6so2/9gTJkq+nQKcc+c7uUUReR1QzgB7TxnyN4LB8VNqs/f5JDMIpBGfNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wY0lBv+pLBj/OBBgvO+vtGENANV2IvfFyxPpZq4u/RE=;
 b=dxeF6mPj1ww/rD8fBXR8uE2J0BYGdPpzQSycoh/sQusVsfGZWuMkE6Ny4RESqpkaAJUl1Hges1ppR+u0VZSexBoDvfigblJvf7Xxcak0KNxrGsDBW+Zuf8tLnPZoBIt+Www1oc2+85zajcL2IbkahZV5PYlb6ktfwe2sVwqQdUM=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16)
 by MWHPR1101MB2207.namprd11.prod.outlook.com (2603:10b6:301:58::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24; Mon, 12 Oct
 2020 01:19:33 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::9976:e74f:b8e:dc15]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::9976:e74f:b8e:dc15%7]) with mapi id 15.20.3455.029; Mon, 12 Oct 2020
 01:19:33 +0000
From:   "Qi, Yadong" <yadong.qi@intel.com>
To:     Nadav Amit <nadav.amit@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: RE: [kvm-unit-tests PATCH] x86: vmx: Add test for SIPI signal
 processing
Thread-Topic: [kvm-unit-tests PATCH] x86: vmx: Add test for SIPI signal
 processing
Thread-Index: AQHWkw6i3URq225llEmaCd1JoJ27OqmHFl8AgAmNrACAApzMIA==
Date:   Mon, 12 Oct 2020 01:19:33 +0000
Message-ID: <MWHPR11MB196876354169E0DB6046BA5BE3070@MWHPR11MB1968.namprd11.prod.outlook.com>
References: <20200925073624.245578-1-yadong.qi@intel.com>
 <MWHPR11MB1968C521D356F1D1FA17EE6EE30F0@MWHPR11MB1968.namprd11.prod.outlook.com>
 <3705293E-84DE-41ED-9DD1-D837855C079B@gmail.com>
In-Reply-To: <3705293E-84DE-41ED-9DD1-D837855C079B@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.46.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3026e8ec-44a0-4e8b-cdf0-08d86e4ce09c
x-ms-traffictypediagnostic: MWHPR1101MB2207:
x-microsoft-antispam-prvs: <MWHPR1101MB2207D75A023EE3E2FAC5EBC0E3070@MWHPR1101MB2207.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /vWkoTQhGsDVNtfChq9Q4IWVmL8Uv6AaBE8E1fE/CxmOJoyzNapMAAETrB7p5rXkpDiyTk8q1k9TosYwqQzib4EgHuVpe7wiv8UeTvrSNGOwgkI/6wNsZhnxda3hCFQC27em6ZedQD+fvnHCoqsvo46CVTRk2VZeB/Y37d5FpcX7jLyryFqmFItydqr3OVEEjGqZOgPkLmR1RJA22s1AOXWW6/98lU8VxYnnaQw9EnbKYy0cNmQnLny6p3sZo9iaFbQNH78qU4j9DHRCMi+gLahgnljb0ufj+anpYXmXEouRR+AqF6PD7yEHeMzq/wKy+Q6zsVm9cGsHE0ELrvZn6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1968.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(186003)(54906003)(64756008)(316002)(6916009)(8936002)(55016002)(66476007)(26005)(71200400001)(76116006)(66946007)(5660300002)(66556008)(7696005)(66446008)(52536014)(33656002)(2906002)(478600001)(86362001)(8676002)(6506007)(9686003)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Llgc68so169RJIJzERnXdhlqV0xA7nLeBKmw7BCPqWmcf0KT5WF5GwR4zVfxWl10kP6Th+ORXDbPL6XaCFjc/mAtB0KcUkGn605PVsfZta0/WlIEVhy8qKvhmxXQ0ow/8fNEtfDk3v/TVEvD6WrUz5c93jlbYPezs6Y10Pyn6IxBPFC4k6LVNSGdu4R+9X0ABFWYLsTjcQA/ySv5jpHFzXtId5vxhGlug+69XvD66RPa88xMeyo9cTdxeGJg4JtkZnVbwpYBqtrLBhnYnQmmfDPGcS0PaizGqfO+uiQFOeXgCmrJxd+eN0aRUFR4nZOtM9hU2NEBlAZQU9+kk1hrEDQrczySf0oAvxSaIIEBAe5pKOMLe4WlXkbiRlFMsp/Varms+pbA6Wp/l1tfZwmQC2kjEf6ogCl+lV6ivUDmDjl4UrVOzaOaYMV9/mKSwaPpYH/VAaOtjaDSjAg1ZC31s/vnFRDgJ+br0KoMczQjWYMLaDpfpbT2XCRsnWrnVbhaeEiGMRwP1YJzLQSVN7jaOCcG2QpLBH3xAzYnaGb+YJGPT1ctJQ1Y7H7yktYXc4VILWklLEadPPzB+lgl6jKSg1AB6PSPK9s64vaUpFC6CXujLlFk2j7K6BInA8Q3z6X+RleQqxbuU+AeuOL5jVRDsQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1968.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3026e8ec-44a0-4e8b-cdf0-08d86e4ce09c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2020 01:19:33.5928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Et4ceR2sVgrtNdmDvU2b0z4vYZRTSXTut4ZOJ8R7BOLQ64l4rhxeoXzooYhm0gCx7nTXA36WkcPEW3VgDbEbNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2207
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>=20
> On my bare-metal machine, I get a #GP on the WRMSR that writes the EOI in=
side
> ipi() :
>=20
> Test suite: vmx_sipi_signal_test
> Unhandled exception 13 #GP at ip 0000000000417eba
> error_code=3D0000      rflags=3D00010002      cs=3D00000008
> rax=3D0000000000000000 rcx=3D000000000000080b rdx=3D0000000000000000
> rbx=3D0000000000000000
> rbp=3D000000000053a238 rsi=3D0000000000000000 rdi=3D000000000000000b
> r8=3D000000000000000a  r9=3D00000000000003f8 r10=3D000000000000000d
> r11=3D0000000000000000
> r12=3D000000000040c7a5 r13=3D0000000000000000 r14=3D0000000000000000
> r15=3D0000000000000000
> cr0=3D0000000080000011 cr2=3D0000000000000000 cr3=3D000000000041f000
> cr4=3D0000000000000020
> cr8=3D0000000000000000
> 	STACK: @417eba 417f36 417481 417383
>=20
> I did not dig much deeper. Could it be that there is some confusion betwe=
en
> xapic/x2apic ?

Thanks, Nadav.
I cannot reproduce the #GP issue on my bare metal machine.
And I am a little bit confused, there is no EOI MSR write in this test suit=
e,
how the #GP comes out...
Could you provide more info for me to reproduce the issue?

Best Regard
Yadong

