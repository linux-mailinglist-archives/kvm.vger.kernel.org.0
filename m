Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB0FF8F98
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 13:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfKLMXD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 07:23:03 -0500
Received: from mail-bgr052101132080.outbound.protection.outlook.com ([52.101.132.80]:25918
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725874AbfKLMXC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 07:23:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ky4TFqh3mdWupNjHBlsqzxcf2dy7PBYHlSOyLUngB+4XBVv//AnyMQXdVbzMNz0LDMDTgpUHWH31rm5vVZIMw0OJJs8i29FUoesIVUN9j5lSOa0wdqufzWUiMMN0rDBeGjR0KutMVQe3EJ+7T05P8q+UWUlpoPsb2sSCjHXjrQsae6pjIsPa+YDvtc3gzAMbel+tDsJLuvgaur8s1RpNpeMloubbojevUJFGRFiVCJ291ZUJaa3b8CbYRuUPNMZgC6FoI+npt0iSFUk7dbwgDdcs9Ll64CAoeFA3sRnxei78lWdXMCLi9gIBmAx+NVfxW9TBuMhKXag9UEebq5PzNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTVOBzMWmoUNany0Uh+PpnunPP4IA7hsmSLlNawgwwE=;
 b=OGETXgEi8b/xOatjA1phFiLmZ2POSk3OUAESS7VWHmaCTFRcjy7v8kgvmW4UrB9l0eD/1ABxgf4x99VT7LLCgLN1yOi7BUg6DMDYcuyPNl4+dFPpBG055FYEcGoa2UhB0hAcW65Wb96lJus/9VtFNxDiJrHPkzbtMEH1JoE0Z4ZPuA8m7BzX+HSrsWMvOmpxGBtWjrQtHnKufnLq7GyS0TLxD6Oga2axV36EWZcbJw2bIR7VFnT0tRhpKs3zMXpUXIowNJgFEM/RBWlhl+yI8a6wqoMvW2mZV/4EsXYHHVb5lSWFHSbh5q4IMtcSFk8pvApGd9QFnlT5nX6N1vsAIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTVOBzMWmoUNany0Uh+PpnunPP4IA7hsmSLlNawgwwE=;
 b=p6/wHYhqUW1ZLaRTIR55txo6zyadlhRwiC263rS8UMueoRH7/LmQLetSG6oavs0GMEwqLcsRK4fLTkaHa3bAbfVLhjHx03iJk1yXrW8kMbG+PGVGWXzPLXiDpneLofalmJQcJ1Ck//Gl0brhCufumCnZYm9C3BqR4EqmoP1yCNo=
Received: from VI1PR08MB4608.eurprd08.prod.outlook.com (20.178.80.22) by
 VI1PR08MB4014.eurprd08.prod.outlook.com (20.178.204.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Tue, 12 Nov 2019 12:22:50 +0000
Received: from VI1PR08MB4608.eurprd08.prod.outlook.com
 ([fe80::9465:ec66:befb:e8b5]) by VI1PR08MB4608.eurprd08.prod.outlook.com
 ([fe80::9465:ec66:befb:e8b5%3]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 12:22:50 +0000
From:   Roman Kagan <rkagan@virtuozzo.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: Re: [PATCH v4 13/17] kvm: i8254: Deactivate APICv when using
 in-kernel PIT re-injection mode.
Thread-Topic: [PATCH v4 13/17] kvm: i8254: Deactivate APICv when using
 in-kernel PIT re-injection mode.
Thread-Index: AQHVkQWIuGEgJ7JXrk6/VQ6c7w+tYad3peqAgAQEBACAAYodgIAJF2eAgAE6SgA=
Date:   Tue, 12 Nov 2019 12:22:50 +0000
Message-ID: <20191112122246.GC2397@rkaganb.sw.ru>
References: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1572648072-84536-14-git-send-email-suravee.suthikulpanit@amd.com>
 <70fb2b49-2198-bde4-a38b-f37bc8bc9847@redhat.com>
 <20191104231712.GD23545@rkaganb.lan>
 <ac4313a6-df96-2223-bed3-33c3a8555c98@redhat.com>
 <9361adbc-77e8-4964-c859-8956e1fbb182@amd.com>
In-Reply-To: <9361adbc-77e8-4964-c859-8956e1fbb182@amd.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.12.1 (2019-06-15)
mail-followup-to: "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,        Suravee
 Suthikulpanit <suravee.suthikulpanit@amd.com>, Paolo Bonzini
 <pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,      "joro@8bytes.org"
 <joro@8bytes.org>,     "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "graf@amazon.com" <graf@amazon.com>,    "jschoenh@amazon.de"
 <jschoenh@amazon.de>,  "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,    "Grimm, Jon" <Jon.Grimm@amd.com>
x-originating-ip: [185.231.240.5]
x-clientproxiedby: HE1PR05CA0276.eurprd05.prod.outlook.com
 (2603:10a6:3:fc::28) To VI1PR08MB4608.eurprd08.prod.outlook.com
 (2603:10a6:803:c0::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rkagan@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63945da4-34e3-43b4-e80b-08d7676b08a1
x-ms-traffictypediagnostic: VI1PR08MB4014:
x-microsoft-antispam-prvs: <VI1PR08MB40148748A91088F118682B63C9770@VI1PR08MB4014.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:SPM;SFS:(10019020)(376002)(39850400004)(136003)(366004)(396003)(346002)(199004)(189003)(102836004)(86362001)(305945005)(7736002)(6116002)(3846002)(486006)(81156014)(81166006)(1076003)(6916009)(476003)(8676002)(8936002)(66476007)(66946007)(66556008)(7416002)(64756008)(66446008)(52116002)(386003)(6506007)(5660300002)(2906002)(76176011)(53546011)(9686003)(26005)(99286004)(6512007)(6436002)(33656002)(6246003)(4326008)(14454004)(478600001)(229853002)(36756003)(6486002)(14444005)(256004)(58126008)(316002)(11346002)(66066001)(71200400001)(186003)(71190400001)(446003)(25786009)(54906003)(30126002);DIR:OUT;SFP:1501;SCL:5;SRVR:VI1PR08MB4014;H:VI1PR08MB4608.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-transport-forked: True
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jf8bmVWeTOh06FWOlfUR0rVf4yT30p8uhddbnfqULcPPDUqIVsz6TIP4RW0QKYk6IxEr5b/m5f5LE6RJmXTRN76Re9da+ZBM+c0wtt07Utali5MffaXBJSNOnNn88+UGtr0KFcGzVGrb73RsHVIciEIum6IGQskzfN3yOsBCjw44fpOd03NnixZAsoaCvX3N467VwECN0QaHfjNiN2vBLl6imd5azgZ3AtN9IJYA3Sws7F5dYbphzOJ6ben6xHnFwj+h/SiR4Wb5IDtJRY0WQATkgifIH5jjj4n2XiU9RF6OLkuM1LM8TcPd2UPLX74el27bT+2u8cgxe7OEoSeHXcIJVPY8WX6u7Dg34hGQlIwhVGsC3fDlkTdDdOX7avUI
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EAD6731BFB68364DB7E13FBC48BE210C@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63945da4-34e3-43b4-e80b-08d7676b08a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 12:22:50.2872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d8f6+Y3ix68u+WhmiT56ZSTf4gS5ZwD7YM9ck+nzMqT0TLJv4rg3GqoKRFg1EYgUzJY5+mGOoaUscKUi5xF8MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4014
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 11, 2019 at 11:37:53AM -0600, Suravee Suthikulpanit wrote:
> On 11/5/2019 4:47 PM, Paolo Bonzini wrote:
> > On 05/11/19 00:17, Roman Kagan wrote:
> > > > This is not too nice for Intel which does support (through the EOI exit
> > > > mask) APICv even if PIT reinjection active.
> > > Hmm, it's tempting to just make svm_load_eoi_exitmap() disable AVIC when
> > > given a non-empty eoi_exit_bitmap, and enable it back on a clear
> > > eoi_exit_bitmap.  This may remove the need to add special treatment to
> > > PIT etc.
> > 
> > That is a very nice idea---we can make that a single disable reason,
> > like APICV_DEACTIVATE_REASON_EOI, and Intel can simply never use it.
> 
> I took at look at the svm_load_eoi_exitmap() and it is called via:
>     kvm_make_scan_ioapic_request() ->
>         KVM_REQ_SCAN_IOAPIC -> vcpu_scan_ioapic() ->
>             KVM_REQ_LOAD_EOI_EXITMAP -> vcpu_load_eoi_exitmap()
> 
> The kvm_make_scan_ioapic_request() is called from multiple places:
> 
> arch/x86/kvm/irq_comm.c:
>     * kvm_arch_post_irq_routing_update() : Called from kvm_set_irq_routing()
> 
> arch/x86/kvm/ioapic.c:
>     * kvm_arch_post_irq_ack_notifier_list_update() : (Un)registering irq ack notifier
>     * kvm_set_ioapic() : Setting ioapic irqchip
>     * ioapic_mmio_write() -> ioapic_write_indirect()
> 
> arch/x86/kvm/lapic.c:
>     * recalculate_apic_map()
> 
> Most calls would be from ioapic_mmio_write()->ioapic_write_indirect().
> 
> In case of AMD AVIC, the svm_load_e::vsoi_exitmap() is called several times, and requesting
> APICV (de)activate from here when the eoi_exit_bitmap is set/clear would introduce
> large overhead especially with SMP machine.

This doesn't look like a hot path, so I'm not sure it needs to be
optimized for performance.  Especially so since
kvm_make_scan_ioapic_request does kvm_make_all_cpus_request which isn't
particularly fast by definition, and I guess the extra overhead there
won't be noticable.

OTOH introducing extra code paths has its maintenance costs, so sticking
the simple logic in svm_load_eoi_exitmap looks attractive.

Just my 2c,
Roman.
