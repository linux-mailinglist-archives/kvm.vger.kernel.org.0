Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39249EF118
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 00:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbfKDXRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 18:17:34 -0500
Received: from mail-eopbgr80121.outbound.protection.outlook.com ([40.107.8.121]:59462
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729710AbfKDXRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 18:17:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XG1byXH+lDN5trBCN4vALuNuuCtqxQ9XiZ6fIWAL10HtapJsPMSYtqBFueXNPXe5J3M66qyKRRf2BqXo7JqbwiwGTztmgrdDaRGOWpYpWDurscI09W8zarRpx62AY1Rko+AuzrMHwDJZKQ0HFCRo27gufg+jp8V6/9ijtwcWgP7u/6jm+SIASQQqmDIldrlBSVHNKCIdyYftFaw5bzhhb7+/cQ90OX37Z60Xz3JyF3lH8MxKtYjSfeyA6K0M2eBCFiaIqYimGsjOrcYZyP+3HgrKky8++j0pEv+8eV+hQPjnSF4q7Y22YHecS0WpqQXytN3VQgLELy/jbJ0tX1zJLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1whj7e02fhEqgHVElKkVl3BPxEh3KGr8rZ5/CMwNuHM=;
 b=ImaN0JxkUy3fB4rwqJkGr+rK7q8HfYOPqOeSczQmXwyN9Zv3BeF9eavNGpbdmbIfk454XxagbX5mBuB3OEu6kT5CclqMsO/MRBmNNdMeiVRA/5rCzvTB35sC/9PhFSBvywutfVNQZRxzm5U2spuWIoXtePwfuKF9ETVnRAecZstqkRSCwwj1WbJQ8lBtck2U2LMOHJgRRLhIw6GvT7+LguHZdMXImA6xs35Qu3kZhPl9zBd4FyEhsuY35qv48gAznIQPOyMPBh+q4ZO+PoixD+6t305tAwKAbpMcaixcccC9M/0/5xZuzLtnP7Q3rj905kAwT5Py8KGv/NpMolheaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1whj7e02fhEqgHVElKkVl3BPxEh3KGr8rZ5/CMwNuHM=;
 b=Bl4vgOyFmVkxQyuOyP7MXSdaYgB2Dqf3xEp4kpnVxwzRuC9u6gWzA50PXan1ciyWCuTuGeegheBzjjCzneJGJho8CYwHlaUNFIR/14dVBAaG2GBJ6W5qnwRTGSLGrqvgX8pIasQDD5jFchzGEcIQc9OUUferzSg6Z6puAcTqIKk=
Received: from AM4PR0802MB2242.eurprd08.prod.outlook.com (10.172.218.15) by
 AM4PR0802MB2148.eurprd08.prod.outlook.com (10.172.216.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Mon, 4 Nov 2019 23:17:16 +0000
Received: from AM4PR0802MB2242.eurprd08.prod.outlook.com
 ([fe80::9c3e:dc5:e056:9f89]) by AM4PR0802MB2242.eurprd08.prod.outlook.com
 ([fe80::9c3e:dc5:e056:9f89%12]) with mapi id 15.20.2408.024; Mon, 4 Nov 2019
 23:17:16 +0000
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
Subject: Re: [PATCH v4 13/17] kvm: i8254: Deactivate APICv when using
 in-kernel PIT re-injection mode.
Thread-Topic: [PATCH v4 13/17] kvm: i8254: Deactivate APICv when using
 in-kernel PIT re-injection mode.
Thread-Index: AQHVkQWIuGEgJ7JXrk6/VQ6c7w+tYad3peqAgAQEBAA=
Date:   Mon, 4 Nov 2019 23:17:16 +0000
Message-ID: <20191104231712.GD23545@rkaganb.lan>
References: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1572648072-84536-14-git-send-email-suravee.suthikulpanit@amd.com>
 <70fb2b49-2198-bde4-a38b-f37bc8bc9847@redhat.com>
In-Reply-To: <70fb2b49-2198-bde4-a38b-f37bc8bc9847@redhat.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.12.1 (2019-06-15)
mail-followup-to: "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,        Paolo Bonzini
 <pbonzini@redhat.com>, "Suthikulpanit, Suravee"
 <Suravee.Suthikulpanit@amd.com>,       "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,      "joro@8bytes.org"
 <joro@8bytes.org>,     "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "graf@amazon.com" <graf@amazon.com>,    "jschoenh@amazon.de"
 <jschoenh@amazon.de>,  "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,    "Grimm, Jon" <Jon.Grimm@amd.com>
x-originating-ip: [2a02:2168:9049:de00::659]
x-clientproxiedby: HE1PR05CA0129.eurprd05.prod.outlook.com
 (2603:10a6:7:28::16) To AM4PR0802MB2242.eurprd08.prod.outlook.com
 (2603:10a6:200:5f::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rkagan@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cef5ef4e-5a42-4567-4ef5-08d7617d21d7
x-ms-traffictypediagnostic: AM4PR0802MB2148:
x-microsoft-antispam-prvs: <AM4PR0802MB2148AC42DC5948DD37EA0E43C97F0@AM4PR0802MB2148.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0211965D06
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(376002)(39840400004)(366004)(136003)(199004)(189003)(58126008)(2906002)(186003)(99286004)(54906003)(6246003)(1076003)(81166006)(6916009)(7416002)(386003)(316002)(6506007)(53546011)(66556008)(46003)(7736002)(52116002)(14444005)(102836004)(25786009)(71200400001)(66446008)(8936002)(66946007)(76176011)(305945005)(71190400001)(66476007)(64756008)(6116002)(8676002)(81156014)(4326008)(446003)(86362001)(11346002)(256004)(6436002)(14454004)(476003)(486006)(5660300002)(33656002)(36756003)(6512007)(229853002)(9686003)(6486002)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:AM4PR0802MB2148;H:AM4PR0802MB2242.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VZynJ4uSo9AoohH9nSUCZlKGhFELpJ5SEUQ6ekirOIghSH7ldfcy6ouK3baJ/VgTzbzPD/OrlFVrVRtsWLCbxfpMi8YL+k+bN2g1xRnJZcha/UjrSef7lBxRKCmbo009p7y7J7uYrixHLuv/in1ZmPSPgSw9WEUigugVkhUSYg72SL9nkNssen6UXv7q2KgklbQ4KADpii35VzZQqE8pMXlvwt1M25Fxw/ZWVFBVIakWi9EI/e7iGwmbtuKwZOhTrcZTh28xAx54GIbYpxFqAryDXlFtWH+leZ5+f7l6IFB7hsLF8NCPfmC8XGPAqwpBMw6udVwEGkpppQ+TPTKbxU6n9HBVTwH1p+SFS7r8PposKrNEAdyIid7AlJV6g+JKYQzAYz6OY+N5sKqXxiB1N+E6RsbvOW2IGMKIEAQrvXFd1/Mew5TuFoCNcFOdIuV1
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1E9E02A7B00175419990AB4044E8DEC7@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cef5ef4e-5a42-4567-4ef5-08d7617d21d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2019 23:17:16.5038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9O30jMnqwZKSXlrWh0FtHrw+kcFWNeclq+kC0rEJ6geBLnZEIJrJsFoP2EnTk/i0rLFcA4ABgonn1k1LjmaGkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0802MB2148
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 02, 2019 at 10:57:47AM +0100, Paolo Bonzini wrote:
> On 01/11/19 23:41, Suthikulpanit, Suravee wrote:
> > +	/*
> > +	 * AMD SVM AVIC accelerates EOI write and does not trap.
> > +	 * This cause in-kernel PIT re-inject mode to fail
> > +	 * since it checks ps->irq_ack before kvm_set_irq()
> > +	 * and relies on the ack notifier to timely queue
> > +	 * the pt->worker work iterm and reinject the missed tick.
> > +	 * So, deactivate APICv when PIT is in reinject mode.
> > +	 */
> >  	if (reinject) {
> > +		kvm_request_apicv_update(kvm, false, APICV_DEACT_BIT_PIT_REINJ);
> >  		/* The initial state is preserved while ps->reinject == 0. */
> >  		kvm_pit_reset_reinject(pit);
> >  		kvm_register_irq_ack_notifier(kvm, &ps->irq_ack_notifier);
> >  		kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
> >  	} else {
> > +		kvm_request_apicv_update(kvm, true, APICV_DEACT_BIT_PIT_REINJ);
> >  		kvm_unregister_irq_ack_notifier(kvm, &ps->irq_ack_notifier);
> >  		kvm_unregister_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
> 
> This is not too nice for Intel which does support (through the EOI exit
> mask) APICv even if PIT reinjection active.

Hmm, it's tempting to just make svm_load_eoi_exitmap() disable AVIC when
given a non-empty eoi_exit_bitmap, and enable it back on a clear
eoi_exit_bitmap.  This may remove the need to add special treatment to
PIT etc.

Thanks,
Roman.
