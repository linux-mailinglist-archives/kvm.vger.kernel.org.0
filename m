Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17BB7F8DB9
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 12:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfKLLMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 06:12:24 -0500
Received: from mail-bgr052101134082.outbound.protection.outlook.com ([52.101.134.82]:50599
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725947AbfKLLMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 06:12:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfMIoTzxY+OfMNbwomeym2xQBcL/5pxn53Pok/fkiVw1MNZvc3bqQo/PD4GjOczrLcNqGpIaxFtwe0IfeRi9CZ6+1+HNqxgVt9DDAWS2lkL3TV82c13RJ9bEQMetBPJtNyy1JiujXbRpxFzff4HNhAIpcgrj3RP4/EIeinLxnHW49Mrv3NenerlifjVQgtG5D1sVIwjR4/CJb280lxL+XhjkghlK1M+fi5EMrTRrZ5yNh0e+pA+EkwcI4+V32YP0VsgWYEJaiLfp2X0/7Ks84qyC1Bxd9inKluQui8J4yK4nr8sslGN/3eb8+eQsxTeFRpI12A30FdyYS8Eunrh6aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IX0fztmSrBTXBX5FoAEfdqbYuHF5fLkGN1+k/XWE0Zc=;
 b=AYGcdKN68BcLEB8iFz+zubhZ1UrZTOjsShKpXuTpiKA8Y9A6gbfXrj6evO69tiOm6e5aJchQYag1kn3oKSdu1Y/4Vo5izr+VmbGfK/RVqe+PKnEXaGmJmAAp8SXs7jP3tyonAvK3Zz1lVzctB3VxWipH4RT5NJSAXK/877HCGqNqWWrKuOyR0iXR3agk85XrrwQib8RYMLng00621NfeVbz/TS9XvarFJterBt4pTo5/KnLcmdtvw2GuTQpf/lSSc6GKhFSpDCFKmOF42fMR/Qw9hzCtb1BomX8wO9MFHZfQhaiXdT7DnXMdcYL1ln8jLc6jihY7RYTdzkPUOXey7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IX0fztmSrBTXBX5FoAEfdqbYuHF5fLkGN1+k/XWE0Zc=;
 b=K233sLULIxOEKuOYW/840PBKBbQcdBw9+peT5dvzbeZ2CehJe7rCfK3zexq9wp7ZuJT4uXqnySl/MHE0vTjsNBM0F5P1+NpWcTi7I55hLZ2ne3rcpk1j6GOZc8UR2+z2fN7FMwHMAeHe2bFqODouisQfgyrzJnybZ2rcHFHrYr8=
Received: from VI1PR08MB4608.eurprd08.prod.outlook.com (20.178.80.22) by
 VI1PR08MB3981.eurprd08.prod.outlook.com (20.178.205.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Tue, 12 Nov 2019 11:12:19 +0000
Received: from VI1PR08MB4608.eurprd08.prod.outlook.com
 ([fe80::9465:ec66:befb:e8b5]) by VI1PR08MB4608.eurprd08.prod.outlook.com
 ([fe80::9465:ec66:befb:e8b5%3]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 11:12:19 +0000
From:   Roman Kagan <rkagan@virtuozzo.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
Subject: Re: [PATCH v4 08/17] kvm: x86: Introduce APICv pre-update hook
Thread-Topic: [PATCH v4 08/17] kvm: x86: Introduce APICv pre-update hook
Thread-Index: AQHVkQWF3SaRgLSvd0GUYdThH7zHx6d7lb6AgAsiuYCAALmRgA==
Date:   Tue, 12 Nov 2019 11:12:19 +0000
Message-ID: <20191112111215.GB2397@rkaganb.sw.ru>
References: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1572648072-84536-9-git-send-email-suravee.suthikulpanit@amd.com>
 <20191104220457.GB23545@rkaganb.lan>
 <a087061a-1217-962f-43ae-1d791c9d38f6@amd.com>
In-Reply-To: <a087061a-1217-962f-43ae-1d791c9d38f6@amd.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.12.1 (2019-06-15)
mail-followup-to: "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,        Suravee
 Suthikulpanit <suravee.suthikulpanit@amd.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,    "rkrcmar@redhat.com"
 <rkrcmar@redhat.com>,  "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,    "graf@amazon.com"
 <graf@amazon.com>,     "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,      "rimasluk@amazon.com"
 <rimasluk@amazon.com>, "Grimm, Jon" <Jon.Grimm@amd.com>
x-originating-ip: [185.231.240.5]
x-clientproxiedby: HE1PR05CA0232.eurprd05.prod.outlook.com
 (2603:10a6:3:fa::32) To VI1PR08MB4608.eurprd08.prod.outlook.com
 (2603:10a6:803:c0::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rkagan@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ea6ae82-446f-4481-793b-08d767612eb3
x-ms-traffictypediagnostic: VI1PR08MB3981:
x-microsoft-antispam-prvs: <VI1PR08MB398156FE43DE72885B0E1FA2C9770@VI1PR08MB3981.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:SPM;SFS:(10019020)(396003)(366004)(136003)(39850400004)(376002)(346002)(189003)(199004)(478600001)(81166006)(53546011)(6506007)(26005)(8936002)(8676002)(81156014)(25786009)(4326008)(66556008)(66476007)(66946007)(64756008)(66446008)(15650500001)(6916009)(386003)(3846002)(71190400001)(71200400001)(2906002)(6116002)(102836004)(52116002)(76176011)(186003)(6246003)(14454004)(99286004)(33656002)(54906003)(1076003)(6436002)(36756003)(446003)(14444005)(66066001)(86362001)(11346002)(486006)(476003)(305945005)(229853002)(6486002)(6512007)(7416002)(9686003)(7736002)(58126008)(316002)(256004)(5660300002)(30126002);DIR:OUT;SFP:1501;SCL:5;SRVR:VI1PR08MB3981;H:VI1PR08MB4608.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-transport-forked: True
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a+xvzLEoBHS7i0s022ez5bc5ydVMsxmSlq7LgxoGzLaQ1j4HWsA1RmZ9/9SozkWLiLW/wxb/EyNszIOwSWP4UdsYAjKomqp60bwE4gICCyuhJC3sXbfW3oXvKaDXjj/XHxcIUKW4k0dYAJBFXBStBNQCQkQnfrF4cc7ZGkQH6Hp9gf7xh5eSZhwYoY235A3SjapTZgY4Yupwia/KAaYn/sjjnz3VD9LFVeKD4+ppSdIUSMbBWGKodEWF4nVVv7bUq1q3b6rlUUgLDlXI3a8gol1AJ+CGtVIKJxiJlKuOpgZzu1ROyK1WAvG0cRM5KkP6XrlHOA6C2OCNMhYRVbdJSEkJqS+t7TaYFkw3h0m9cw7laNqwqjYgKNrh8Uu2EF0y
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D142AD6D28BC3B48B343FED6CB4B8F5B@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ea6ae82-446f-4481-793b-08d767612eb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 11:12:19.0936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nK8AZ65O001WblCCj+Az7NCevKwg41E+LPY29HKiJwskISFySh1/lonbx5A8EP4z26NHOEbZK7QEW+McVLZPNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3981
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 11, 2019 at 06:08:05PM -0600, Suravee Suthikulpanit wrote:
> On 11/4/19 4:05 PM, Roman Kagan wrote:
> > On Fri, Nov 01, 2019 at 10:41:31PM +0000, Suthikulpanit, Suravee wrote:
> > > AMD SVM AVIC needs to update APIC backing page mapping before changing
> > > APICv mode. Introduce struct kvm_x86_ops.pre_update_apicv_exec_ctrl
> > > function hook to be called prior KVM APICv update request to each vcpu.
> > This again seems to mix up APIC backing page and APIC access page.
> > 
> > And I must be missing something obvious, but why is it necessary to
> > unmap the APIC access page while AVIC is disabled?  Does keeping it
> > around stand in the way when working with AVIC disabled?
> 
> I have replied to patch 07/17 with explanation.
> 
> Yes, keeping the APIC access page while disabling AVIC would cause
> the SVM to not function properly.

I wonder why?  Once AVIC is disabled guest access to this page would
trigger a regular NPT fault vmexit, just as it would with the NPT entry
for this page destroyed, wouldn't it?  So there would be no difference
from the host's POV.  Am I missing something?

Thanks,
Roman.
