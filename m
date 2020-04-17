Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5001AE882
	for <lists+kvm@lfdr.de>; Sat, 18 Apr 2020 01:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgDQXHm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 19:07:42 -0400
Received: from mail-eopbgr1310113.outbound.protection.outlook.com ([40.107.131.113]:32457
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726036AbgDQXHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 19:07:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W8nY51giSedU8SPZdpnGqNlXiPKqflf78OHm06UFenkkR0vx42y5+Tr81E3RoxXB1oXvUSm2MeGpOoD6Osz68/AGNSf++YP80Op9VblQo9V8ubszIWsuaq9p94Og2HRRhig8IVIMcClM/G2Z0tQ4aSgol4x/iMTGSnSt7a6lrZ0Z0WkqV3VDqkjNpEM4rO910hSbc4tVwoYDgkpwI/pvDlVAn3UZGRGItCD/bf1QLkiDebJESyReofhFFSNO11HUitiaeeli447ni4okKTgny3od8YPJqxFEW34S8T/9KwEgdPzePCf6p9JUkBJafK23hf921pHNd5RV+h9zjMLHnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUvK8PhqN5D0DVkkiaZkVPw+btV96IcFhSRz2qAvs18=;
 b=UP6LioA0AchA8J50zk5Yk2Nv2p6RWxi7b4th6hCOyJlVW9Gkk1+YB/GLtj/wFOav4SS1Vi2syTzyB0JxalmudFwc87KvTglkF90kxWFVTnJviFUqpagQkwySgAHJkVPlhLb7ZkDmnQdIbSbHfjlcs5O/8blTHjIdK4flQYKBOr2wf3l3pinEUAJz26/BbWZBCuGuy6I9tLqSatf2cQxhZtjs5sX4F3zDE2IEplqkKJyi6rmjmF56jZfuyhuA0pVHu6IapZ8B8thkmo+kCBTHGb7Lvxz9J/aHqlZJRaIpbdWaDIMouT9FQNmQgpbo6+W1LAB7O3ttS4nLbGuVGL1JCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUvK8PhqN5D0DVkkiaZkVPw+btV96IcFhSRz2qAvs18=;
 b=JSL84TXrZ1eeA8ur00EgQMj4BuG35P/XDzVH+A5ko699AmXOcfD78PRHrgq1WeFVcD+yjcAsT62eZa/+YssYLH6cv7UzWXBkfc4FjTM3v19nwF66z+qR3M+j+jZCZJaDlEW+BQqzQvvk6droTbZ6AVCzAYuT+JxBEP51M/HkJu8=
Received: from HK0P153MB0273.APCP153.PROD.OUTLOOK.COM (2603:1096:203:b2::12)
 by HK0P153MB0131.APCP153.PROD.OUTLOOK.COM (2603:1096:203:19::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.3; Fri, 17 Apr
 2020 23:07:08 +0000
Received: from HK0P153MB0273.APCP153.PROD.OUTLOOK.COM
 ([fe80::2d07:e045:9d5b:898a]) by HK0P153MB0273.APCP153.PROD.OUTLOOK.COM
 ([fe80::2d07:e045:9d5b:898a%2]) with mapi id 15.20.2937.007; Fri, 17 Apr 2020
 23:07:08 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     vkuznets <vkuznets@redhat.com>, Wei Liu <wei.liu@kernel.org>
CC:     "bp@alien8.de" <bp@alien8.de>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] x86/hyperv: Suspend/resume the VP assist page for
 hibernation
Thread-Topic: [PATCH] x86/hyperv: Suspend/resume the VP assist page for
 hibernation
Thread-Index: AQHWFLBBfBcacZSsfESBcN86F1My4ah97Qsg
Date:   Fri, 17 Apr 2020 23:07:08 +0000
Message-ID: <HK0P153MB02736C41200574F4196283CABFD90@HK0P153MB0273.APCP153.PROD.OUTLOOK.COM>
References: <1587104999-28927-1-git-send-email-decui@microsoft.com>
 <87blnqv389.fsf@vitty.brq.redhat.com>
 <20200417105558.2jkqq2lih6vvoip2@debian>
 <87wo6etj39.fsf@vitty.brq.redhat.com>
In-Reply-To: <87wo6etj39.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-04-17T23:07:06.4996719Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8b000693-a052-4d43-922c-3da48af3830c;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:7f70:6de6:6792:4d71:47c3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1da9ccb9-b1db-4386-34d2-08d7e3240dc9
x-ms-traffictypediagnostic: HK0P153MB0131:|HK0P153MB0131:|HK0P153MB0131:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <HK0P153MB01311B038A9A0B0383BFFBE9BFD90@HK0P153MB0131.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0376ECF4DD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0P153MB0273.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(2906002)(10290500003)(5660300002)(71200400001)(478600001)(186003)(82950400001)(82960400001)(66556008)(54906003)(52536014)(76116006)(4326008)(8990500004)(64756008)(7416002)(66946007)(86362001)(66446008)(8676002)(81156014)(7696005)(6506007)(9686003)(53546011)(15650500001)(33656002)(316002)(55016002)(8936002)(66476007)(110136005);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MYEIRTPWm7Ao3qcZVwd3f115e90ghDsPjltblx5iA0yHqI4YQ06ymtIrnLEaEVvFmHWKo6iBnO3+Gc3NHnnKBxBSgSe486KXZCyV1kTe1ypdR+ORO2MwrGqo8qKqFTiWIzD49pRuO54DxMv8dVF2/RHplgbfv/GWipUmGpZFp8TyEl+kisNH0G4yWIbQ04xMKaQ2cy4Ci1rygLjyLQvbh/8m5+Mv5o6SHIaRhctsGO7f1psoej8UjQ4hD8yIhW+R/jRfD5rUGB9y+cI8yONXtRm+dNBU70HX3//dS0a7iRMjW/G/YxGp7H4z43baBvJHEr5AxcHU/fZPeo/DjgXdJ4ysAiq08R4wIjJJ8r+fBXmSxVF4k1DNw5MTxq2gPXZ4b+DgURqMHpfkuRFjowuhFKA8nbi5kjo5gDO/UsVeEyX/ad1UwHFMAXbpbqx6JHLs
x-ms-exchange-antispam-messagedata: ZxZKn3Be7/CVSk/D3qGkxttxBRTQlpkYCohfwY4GV/gTq3fCwTvpYYHJr4eH2D9fkdOHnQkfcEmPIJ0lGNycTeGnol5ENaMhHOtoydA9E/6NwURxV5tTCPRpYOs3RN03xbSwsCxZGsnYTu9qsqU0vV85/0/ILz8c8vTtSTlWlryLN5vR9X+NAl7lEwpWg0csw6ePKv8wm34GcEnnOT5C7HFuhGGszP4evb+D0MfM02EIWdOZqn8hu+nLbSyNYKD52aVa/2xWBa9y5rplHFuvf0x2Hxb9MwugOrqfcAM1rr3n6H+ZpMc43/Ebek3KUu5pKhaS3gOiX22f+yJDiZ85ZDNQAoYUkLx/OrhK7EcI4J0KYFRNdhZlIboa9l2hMIkXvjAh0IsESt8tRto1cscabKVoxp/NTLw4PZ7m9RJRLVeX7JiSGwWkm6S7TGu36Fijanf/3m+q+CwF1ljJTR4t/e7ASqdiAJcVSuIA5BrxdTbNwG/Jqolct7rUiJ6iZ+kH93rLDRDcuskdzOjO6a+alUBnKqhMYjUKCYxe8EKIDDH3jfxcXPABsgtzhtm8l912NTC/AHAmcIFQrNRB8oeoLpiHpUCbdmykV5UaorXT2cBYVCqMAHhXhZ3OkDjH4dCgR1P1TGFR9U+EqI1H1CftM/o4t34EBrXJN8p33PW8U7aMa6FhenZ2+EjEtiT6IiFZKnh4uZx/R06p6N2pM4ga9Q3dzq6zxKDIR3LhynRv1/sx6G2YQoeYBgX+N88ZSN7xAxRLZQPoIM42PadSIq23MducYLhwhL0jZEL4XFLrBbSrVolzW0PPKUKChSq7L4HiOAbqY7mymZYGNxMOlm1ZqwOwGNWGDK8KJOVoEgDtvp0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1da9ccb9-b1db-4386-34d2-08d7e3240dc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2020 23:07:08.1275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qw0WJDYQayeuHoLwMtOC8eVBoNY1g38MXFAeWf629XO0o4Jeszc+Jj5S7MBItuG1nsyHRI8sK9cMWsUDzPPDhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0P153MB0131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> Sent: Friday, April 17, 2020 5:04 AM
> To: Wei Liu <wei.liu@kernel.org>
>=20
> Wei Liu <wei.liu@kernel.org> writes:
>=20
> > On Fri, Apr 17, 2020 at 12:03:18PM +0200, Vitaly Kuznetsov wrote:
> >> Dexuan Cui <decui@microsoft.com> writes:
> >>
> >> > Unlike the other CPUs, CPU0 is never offlined during hibernation. So=
 in the
> >> > resume path, the "new" kernel's VP assist page is not suspended (i.e=
.
> >> > disabled), and later when we jump to the "old" kernel, the page is n=
ot
> >> > properly re-enabled for CPU0 with the allocated page from the old ke=
rnel.
> >> >
> >> > So far, the VP assist page is only used by hv_apic_eoi_write().
> >>
> >> No, not only for that ('git grep hv_get_vp_assist_page')

Sorry, I unintentionally ignored that, as I have few knowledge about the
optimization for nested virtualization. :-)

> >> KVM on Hyper-V also needs VP assist page to use Enlightened VMCS. In
> >> particular, Enlightened VMPTR is written there.
> >>
> >> This makes me wonder: how does hibernation work with KVM in case we
> use
> >> Enlightened VMCS and we have VMs running? We need to make sure VP
> Assist
> >> page content is preserved.
> >
> > The page itself is preserved, isn't it?
> >
>=20
> Right, unlike hyperv_pcpu_input_arg is is not freed.
>=20
> > hv_cpu_die never frees the vp_assit page. It merely disables it.
> > hv_cpu_init only allocates a new page if necessary.
>=20
> I'm not really sure that Hyper-V will like us when we disable VP Assist
> page and have an active L2 guest using Enlightened VMCS, who knows what
> it caches and when. I'll try to at least test if/how it works.
>=20
> This all is not really related to Dexuan's patch)
> --
> Vitaly

It looks you imply that: if there is no active L2 guests, it should be safe=
 to=20
disable/reenable the assist page upon hibernation?

Can you please write a patch for KVM (when KVM runs on Hyper-V) to abort
the hibernation request if there is any active L2 guest? The pm_notifier ca=
n=20
be used for this.

Thanks,
-- Dexuan
