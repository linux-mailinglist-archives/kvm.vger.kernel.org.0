Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1FAA1D000F
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 23:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731250AbgELVDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 17:03:42 -0400
Received: from mail-eopbgr1300129.outbound.protection.outlook.com ([40.107.130.129]:35042
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725938AbgELVDl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 17:03:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gH2n90+8hxdotGqT36V3NEzZz6vPEN21xyV1y8O95HMwiNZ6RBl7lIKP9TKwwMzii02+UQehi9h8H9fWcT1i9MklCqJdse8Dn4iFWwLFhXXZvpsfDm763GAmdAf/LyQzhfDIMPiGW1MkzIFSFi+6Tj82QSnO7fqOzkf2GNQYH6kPfLPBcUwq4MCpIWCeKYRThqcEzso7IthYdV5BO7iOpbESIjC2TEtZNUQZCvHjKz1QJ6GlrA0xtnDl668LpUriZvpFrGY7qmfbcagjA8VDtCgKx+S+V9XDlBU1lsKK5M89iILIiI0BqhynWm7R8v2d44QoBqMQJKXMG2owBRHXAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+oJSCPvOq9QL4A1kYIj9y06go+U5ucYIDKVkRD7vESc=;
 b=F6D+vhoaTJ0OSjcrvOvYwZS/i7q+1sAbbQ9qm9sSBn4B9IaUZC7ph07DcyYrtk7Ok50wdZAZCkm9QFpQrzPcfqRYLnJ0q2NOccSoQF0mMglzFlw33rvVFjLRr5d5LivayUsG6Hld1q0adHFDKOAxiljuUslkn/sD26sFGPpYdCJaybiSFh/lh8/SjRqvc/9PzhauUgfsabc7bS49mT4PGYgM9c6Ca6CTKJLj04h+VfhD3UrpWvj7CprC2IhMiI2HHaM+NZLylQfNWlaYl1y8oe1leUHg9ESlqq+UXVO48EIbKI7eUKriizMnjXv3s4C1wKDoA3N1pkqOgfHUMGBSCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+oJSCPvOq9QL4A1kYIj9y06go+U5ucYIDKVkRD7vESc=;
 b=H95z3pKOMq3YG9ISf0GjLhZwn4Rqxzfgh+UC2gk+1soJVgBSzZ+oXggljE5UlxfhN0MbSQflsqrCVYmAdgEIPF7iS/UvAUXi11rP0SPULLPCD3qI8YWexg2/4kKsAT4/uHBGKJ0eF8X53oRUsEW7EPlv5e200Xa9u07CRqXwImo=
Received: from HK0P153MB0164.APCP153.PROD.OUTLOOK.COM (2603:1096:203:1a::15)
 by HK0P153MB0273.APCP153.PROD.OUTLOOK.COM (2603:1096:203:b2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.2; Tue, 12 May
 2020 21:03:37 +0000
Received: from HK0P153MB0164.APCP153.PROD.OUTLOOK.COM
 ([fe80::60ed:b6e0:c811:9634]) by HK0P153MB0164.APCP153.PROD.OUTLOOK.COM
 ([fe80::60ed:b6e0:c811:9634%8]) with mapi id 15.20.3021.002; Tue, 12 May 2020
 21:03:37 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     vkuznets <vkuznets@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
CC:     Wei Liu <wei.liu@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>
Subject: RE: [PATCH] x86/hyperv: Properly suspend/resume reenlightenment
 notifications
Thread-Topic: [PATCH] x86/hyperv: Properly suspend/resume reenlightenment
 notifications
Thread-Index: AQHWKHatlCMp6vU74EexUlvyfeW2+6ik8Hgw
Date:   Tue, 12 May 2020 21:03:36 +0000
Message-ID: <HK0P153MB016460EAB0E994FFD0653EB2BFBE0@HK0P153MB0164.APCP153.PROD.OUTLOOK.COM>
References: <20200512160153.134467-1-vkuznets@redhat.com>
In-Reply-To: <20200512160153.134467-1-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-05-12T21:03:33Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=262abad1-c2d7-486d-844b-5a81b319464e;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2601:600:a280:7f70:8539:bb09:8e8:c1d3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8c71f8fb-6fbe-4e61-8ec5-08d7f6b7f07e
x-ms-traffictypediagnostic: HK0P153MB0273:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <HK0P153MB027371F208695B74381160B6BFBE0@HK0P153MB0273.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0401647B7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zSH+1QpPZlpXAs51cjhBUJVgYR1FppiDIiC17kergt4b5xTeFRAOcqbT6PvDJfLFKJKkksRYWAWL0SKLah5VD+8o6i1tnj/FpB45RIjbtjZcS/tXR185pvGdGy5RJs5ecXJri0aI/nTaOviwhYoXAgzkWjKjPo8SQH6h/0GxEC63SR3TQ0i8lRfK2EyCicG3tywtuF1WzqZ2V6g0oyShykAZCobKgcIqWSwZhuQ7K1pGbD5d7CPXkyUmxTb5oGJ3hQzGEsV2JMiV/uARbgSKm+cGSrctRQlDT1MwLcfhuock0bY9pD/8mQ07kklNKNfooomEB0889ZKJ48Ah4g9uqnK/JLvWrShJj9to2ONGG1qbaj8NLI8txrOxkdPbu1Uq8c/cuLEATjCenpzv0QqOt8xlybjEBWZ/pTrDUrmJABg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0P153MB0164.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(33430700001)(2906002)(5660300002)(52536014)(54906003)(76116006)(82950400001)(110136005)(82960400001)(4326008)(478600001)(55016002)(107886003)(33656002)(9686003)(316002)(33440700001)(186003)(8990500004)(15650500001)(10290500003)(64756008)(8936002)(7696005)(66946007)(66556008)(86362001)(71200400001)(66476007)(8676002)(53546011)(66446008)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 0foHeggjQw+6YwCt6WiRC1nBv+RFoka3hBAIY/a8Fb4iTw/LFTj3r4qRlUbP3YK+NjGYL6qBs37QEpDqyhFfNrf3JWMTvJhQlzQ3B+OqItX6pHCF94BoQLKGQPvkcrkSRA4OWU36TA4YYL97/GQiGgWMMYUCECaaeyYqtJ2DSjM0//fAj4Pm9lNGqE6fyBLyyWqTBT3LuUFInEZ3RVsRiSm/eGz+pGtk25TytbkanmFUvEl71+Ie15DRFPFqAU8YNJT/aIj5lxSwy2kkwfl5xujvou0xhkiA4wI8g0NF+UvH2gxl/XeoU18pQgn5Tf6gtimtHfenfobHwj/6PO6xjwrGLRu5kGB4+vv1wT5bS9iKT+YKXK2on2jzRRP0dJInk278QGmEwvK9yh4o3KoVE8wdcsDgiwemuFywggKoygDiWDldJflHeZHwCcF+6ksJYS3v23KoNbVwxooKkBQOU49RFTy53BMloj2Xn+7V20CH+I+yNHGEzb842fU8bBjm9Hwdc3FCuQOnNcu42mINZlpQfeCepfQsPqqPXdlBdrw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c71f8fb-6fbe-4e61-8ec5-08d7f6b7f07e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2020 21:03:36.6221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1P8APOZiG0vewToBQPnHh+kznhCxK4MNyb4B35DhUVER4ZegLk1LQWUdCrNb/w4UE21A99fZ+DRUqSCeeF2qVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0P153MB0273
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> Sent: Tuesday, May 12, 2020 9:02 AM
> To: linux-hyperv@vger.kernel.org
> Cc: Wei Liu <wei.liu@kernel.org>; x86@kernel.org;
> linux-kernel@vger.kernel.org; kvm@vger.kernel.org; Michael Kelley
> <mikelley@microsoft.com>; Dexuan Cui <decui@microsoft.com>; Tianyu Lan
> <Tianyu.Lan@microsoft.com>
> Subject: [PATCH] x86/hyperv: Properly suspend/resume reenlightenment
> notifications
>=20
> Errors during hibernation with reenlightenment notifications enabled were
> reported:
>=20
>  [   51.730435] PM: hibernation entry
>  [   51.737435] PM: Syncing filesystems ...
>  ...
>  [   54.102216] Disabling non-boot CPUs ...
>  [   54.106633] smpboot: CPU 1 is now offline
>  [   54.110006] unchecked MSR access error: WRMSR to 0x40000106 (tried
> to
>      write 0x47c72780000100ee) at rIP: 0xffffffff90062f24
>      native_write_msr+0x4/0x20)
>  [   54.110006] Call Trace:
>  [   54.110006]  hv_cpu_die+0xd9/0xf0
>  ...
>=20
> Normally, hv_cpu_die() just reassigns reenlightenment notifications to so=
me
> other CPU when the CPU receiving them goes offline. Upon hibernation, the=
re
> is no other CPU which is still online so cpumask_any_but(cpu_online_mask)
> returns >=3D nr_cpu_ids and using it as hv_vp_index index is incorrect.
> Disable the feature when cpumask_any_but() fails.
>=20
> Also, as we now disable reenlightenment notifications upon hibernation we
> need to restore them on resume. Check if hv_reenlightenment_cb was
> previously set and restore from hv_resume().
>=20
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

Looks good to me. Thanks!

Reviewed-by: Dexuan Cui <decui@microsoft.com>

