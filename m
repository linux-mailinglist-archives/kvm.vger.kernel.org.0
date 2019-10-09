Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77357D0BEC
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 11:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbfJIJzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 05:55:45 -0400
Received: from mail-bgr052101129101.outbound.protection.outlook.com ([52.101.129.101]:9539
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726211AbfJIJzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 05:55:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQFrq4S+GY5Lh9PDQbvN7S35jKnPJu99ewQgiFZUltzsoh71Faww+yHxBhrfPSLWJnRKXqUfLSTmh1/3AC7KkZclPknjnggYbdULgH9CIajk7hZAiNQk+h6hKeWltGRg0/esEEGaCw/8Hi9W+pk5iveX8prZM86Q05OJ12Y2lDGoLeKPSSmLtUMHVfHC03ELQcAQIChTgaav62nPQsxkIcqzxmbmBpvaXDMuWE/O23blqGA5UejsU1bkFcEG26hec6uQkz5FUna5dhGOjb56fvMqLokyWG+hI2LdA1uYnpJk+IYqwjin75AAhYSPtWl7fLPsfXNIfbsdUhCt16wAgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScyB/Ckz0aXOnfKzzKIPdYQaKlFllZWVNbJuHSuoGeQ=;
 b=VUlCocgZLdwPKyKpmeHYchg9KHs4mZOt/MLLExwoh9UbXlAZna3O6/npypFKkiI3Dxfq2WHYsT1eSIRWJ3kT9e/cCxgzfCRTVEn6S0KbHmd0l7tBoO/rJI+PT53Kn5IlHHsZaNfdW8k9yI8FmNR8estQBzv8YuoFXGkV8gLADER55FALWpqmRmQfmChcWVx//FDGZjw8DMwuvVDSUhdmZRsw6B2j0fHlbi1lg2dcGEJfHHdmizj7Sr7pkxJnNpP7V06UfrAaNwl8Gs5TnPHVm+ydPLh3wxITOQqF5VbPtcjJDJwhIHx0NkHDXKbb20DkQ8PEj96yQm+gk3l70resiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScyB/Ckz0aXOnfKzzKIPdYQaKlFllZWVNbJuHSuoGeQ=;
 b=ryKArQaDRfYanrzEb8sqQbC7z2zaOnGFvevkUlALNmCJsHR3sbDck1I0IpIYCeLf3EJRtXzDTFCIaJRWw7TeMHOQJ/LAzIzrjucvujbS9NiRDD8RwYoYx1amDaCmv6RJxDzuMIs66sOQgsxS/5DVabIXiH9CWrzGppITbNkfxLo=
Received: from AM0PR08MB5537.eurprd08.prod.outlook.com (20.179.36.87) by
 AM0PR08MB5235.eurprd08.prod.outlook.com (10.255.31.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.23; Wed, 9 Oct 2019 09:55:29 +0000
Received: from AM0PR08MB5537.eurprd08.prod.outlook.com
 ([fe80::a8ea:5223:db78:dd3]) by AM0PR08MB5537.eurprd08.prod.outlook.com
 ([fe80::a8ea:5223:db78:dd3%7]) with mapi id 15.20.2327.026; Wed, 9 Oct 2019
 09:55:29 +0000
From:   Roman Kagan <rkagan@virtuozzo.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
Subject: Re: [PATCH v3 15/16] kvm: x86: ioapic: Lazy update IOAPIC EOI
Thread-Topic: [PATCH v3 15/16] kvm: x86: ioapic: Lazy update IOAPIC EOI
Thread-Index: AQHVamXHKc1e3KeD0Ee/A+4BnLuUFadSMR+AgAAJbgA=
Date:   Wed, 9 Oct 2019 09:55:29 +0000
Message-ID: <20191009095526.GA10154@rkaganb.sw.ru>
References: <1568401242-260374-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1568401242-260374-16-git-send-email-suravee.suthikulpanit@amd.com>
 <3771e33d-365b-c214-3d40-bca67c2fa841@redhat.com>
In-Reply-To: <3771e33d-365b-c214-3d40-bca67c2fa841@redhat.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.12.1 (2019-06-15)
mail-followup-to: Roman Kagan <rkagan@virtuozzo.com>,   Paolo Bonzini
 <pbonzini@redhat.com>, "Suthikulpanit, Suravee"
 <Suravee.Suthikulpanit@amd.com>,       "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,      "joro@8bytes.org"
 <joro@8bytes.org>,     "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "graf@amazon.com" <graf@amazon.com>,    "jschoenh@amazon.de"
 <jschoenh@amazon.de>,  "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,    "Grimm, Jon" <Jon.Grimm@amd.com>
x-originating-ip: [185.231.240.5]
x-clientproxiedby: HE1PR09CA0082.eurprd09.prod.outlook.com
 (2603:10a6:7:3d::26) To AM0PR08MB5537.eurprd08.prod.outlook.com
 (2603:10a6:208:148::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rkagan@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b60ecfa7-819e-44bf-96d2-08d74c9ed0f2
x-ms-traffictypediagnostic: AM0PR08MB5235:|AM0PR08MB5235:|AM0PR08MB5235:
x-microsoft-antispam-prvs: <AM0PR08MB5235D985B64B1867F8CBAFF7C9950@AM0PR08MB5235.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:SPM;SFS:(10019020)(396003)(39840400004)(376002)(346002)(366004)(136003)(189003)(199004)(52116002)(81156014)(33656002)(478600001)(5660300002)(8676002)(99286004)(14454004)(76176011)(1076003)(8936002)(7416002)(54906003)(6916009)(81166006)(25786009)(58126008)(7736002)(316002)(305945005)(14444005)(66946007)(64756008)(66476007)(66446008)(66556008)(446003)(486006)(71190400001)(71200400001)(476003)(11346002)(6512007)(9686003)(66066001)(86362001)(229853002)(6436002)(256004)(6486002)(102836004)(4326008)(6116002)(2906002)(36756003)(26005)(186003)(386003)(6246003)(3846002)(6506007)(53546011)(15650500001)(30126002);DIR:OUT;SFP:1501;SCL:5;SRVR:AM0PR08MB5235;H:AM0PR08MB5537.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-transport-forked: True
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zn6Tr505xNcb6INKemjiQVOlLewsUVIQJ+MttsgZEmOZ5C/pOXhafVVxJnD2iItWEf89XnYHkgi+vQ0HVDepY/Pk4cTA+m3giew08+5yIv9/8KPAbBOw3VRWLzBDg4GeiDf7XkLZ9YQgEdv2tREoqvBD2X+jFfMzcaZc4BWWGqe0YW0J2uTW/4gWy/LbiVIUNn+RkWdwMRjVcjk4wRHvgRCep4XyN1T6FEK4+t2LqUO7dmxSIwe6A4u3hQMTW2yzVg/ALOY4BYNIkfRponK+kvbc7MnlGiyUi4lKW0wlr2HDSz9Chw7+BTkZ8DLgfPdvYWl7fsK7IA8q7SwV99r+U0BvaNWOBh4Po2SAwTphC44hlzWMVSlj5nMnCiZxkrHll2U7UfGvaAhzKWiAM164LCgKnun6HqVhLv8oLRObTawXQN95w4/QOx9sTfeGkdxDIEHbAJ/aW0u/xLxjIww3ZdZcj3M5LDvPl39isXHr2kawAgUPsjlx3aOnS8+1yPhi
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C1F78026C90CED43A60EC1EF3B89E055@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b60ecfa7-819e-44bf-96d2-08d74c9ed0f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 09:55:29.2826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lBvjILs2iaKJe3QdWVjcncSrLNoTsh+YZXGvBNm97s6mO10x3VApralrRhekYuEC2Zyn4Jx4JVcxK8MQh+tnXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5235
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 09, 2019 at 11:21:41AM +0200, Paolo Bonzini wrote:
> On 13/09/19 21:01, Suthikulpanit, Suravee wrote:
> >  	/*
> > +	 * In case APICv accelerate EOI write and do not trap,
> > +	 * in-kernel IOAPIC will not be able to receive the EOI.
> > +	 * In this case, we do lazy update of the pending EOI when
> > +	 * trying to set IOAPIC irq.
> > +	 */
> > +	if (kvm_apicv_eoi_accelerate(ioapic->kvm, edge))
> > +		ioapic_lazy_update_eoi(ioapic, irq);
> > +
> 
> This is okay for the RTC, and in fact I suggest that you make it work
> like this even for Intel.  This will get rid of kvm_apicv_eoi_accelerate
> and be nicer overall.
> 
> However, it cannot work for the in-kernel PIT, because it is currently
> checking ps->irq_ack before kvm_set_irq.  Unfortunately, the in-kernel
> PIT is relying on the ack notifier to timely queue the pt->worker work
> item and reinject the missed tick.
> 
> Thus, you cannot enable APICv if ps->reinject is true.
> 
> Perhaps you can make kvm->arch.apicv_state a disabled counter?  Then
> Hyper-V can increment it when enabled, PIT can increment it when
> ps->reinject becomes true and decrement it when it becomes false;
> finally, svm.c can increment it when an SVM guest is launched and
> increment/decrement it around ExtINT handling?

This can benefit Hyper-V emulation too.  The point is that it's only
AutoEOI feature in SynIC that is incompatible with APICv.  So the VM can
use APICv until the guest configures its first AutoEOI SINT.  If the
hypervisor sets HV_DEPRECATING_AEOI_RECOMMENDED (bit 9) in
HYPERV_CPUID_ENLIGHTMENT_INFO (0x40000004) cpuid this may never happen
so we will not be pessimizing guests on modern hardware by merely
enabling SynIC.  I started looking into this recently and would be happy
to piggy-back on this series.

Roman.

> (This conflicts with some of the suggestions I made earlier, which
> implied the existence of apicv_state, but everything should if anything
> become easier).
> 
> Paolo
