Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37929670A1
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 15:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfGLNza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 09:55:30 -0400
Received: from mail-pr2fra01hn0211.outbound.protection.outlook.com ([52.101.141.211]:12641
        "EHLO FRA01-PR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727158AbfGLNz3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 09:55:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NzBOmjjWKKmXGPhUGq9gB5nbyQi1+lyp8qQEMx/oUoTY6O5COU9Fq37buATtMRgdTKFP8lgv3JCt9DNnOIbGxpzzkBlsS6OYq2NGCp46JteipzgMbZhi7E7bVQr7UaViESDGOL73HGLGKXlHY/wza8sNjVk/nrsRVNjR+CPzSAugP/u92Gb77lgFalY9YI1acjaLN9iRtjCT1vAMnu5lsuu+qfzd9LQKCpz7QcihA0W7BOQK+UXKvYhGFCOOQIrEFMjvHoyTF5jCvRB/iJF7wX0zxoBzl/6Y+7aSRHkeug22hhXoI2BOlJP3X4U1cD13ACSdetHz+mJVv11wSjnprQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZliQVgXdGRoIL/8ZIliPg3yU2/XmSi6A05UccHYH2w0=;
 b=DddigbYW/forJ7Dp4hfy7suNX6awMV05IV+tUa5qEp7BmVkFz7Z0bnUfDGYb8UQzsiSH1VqAXNmK2UIVwV86GU/Uhd367yWW5+UPRqX/VKGn5VWVmkDJfkYa1fAfDBJvESlTUF8+kKYsgc19AQmXcdEHyt8zM8mfs4KI22103jmgO3Nvl+/1O2dseWM+wDUlbjLOCIVeUGr+m7Wpi13XSSUYgF1WJ0geHd7NLB6AGLC2aCcYFdm1TfbyJ2igC87eAm572b09d1yfXLmDTgK73BCC8tF+i3Rf3Dh/oz9H2ZHoFUDt+66i4tHu7Yqhj6X32wKFaowYPATzi4guCEkLlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=virtuozzo.com;dmarc=pass action=none
 header.from=virtuozzo.com;dkim=pass header.d=virtuozzo.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZliQVgXdGRoIL/8ZIliPg3yU2/XmSi6A05UccHYH2w0=;
 b=KxYbFp2RiDCUbezRa84lryqW3m6ou0m78RqkvJtuyA1vERy50jIQtBwHIBpSJ4EYBnK3IUV2Krms2oP2nfUb+W+alr1HrOkz9Wh9ma2Vw+fy6iDOq5Ujkj/6pNfvNcNr83SL32arjaeWYTwxD7zYRC/GYt0LCn2qIG4mpdlYY8I=
Received: from PR2PR08MB4649.eurprd08.prod.outlook.com (52.133.107.81) by
 PR2PR08MB4636.eurprd08.prod.outlook.com (52.133.110.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Fri, 12 Jul 2019 13:54:31 +0000
Received: from PR2PR08MB4649.eurprd08.prod.outlook.com
 ([fe80::bd59:a723:4d09:9e88]) by PR2PR08MB4649.eurprd08.prod.outlook.com
 ([fe80::bd59:a723:4d09:9e88%7]) with mapi id 15.20.2052.020; Fri, 12 Jul 2019
 13:54:30 +0000
From:   Roman Kagan <rkagan@virtuozzo.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] [v2] x86: kvm: avoid -Wsometimes-uninitized warning
Thread-Topic: [PATCH] [v2] x86: kvm: avoid -Wsometimes-uninitized warning
Thread-Index: AQHVOLZnDJqkDrZxKkKAHlLZPaQCbabHATaA
Date:   Fri, 12 Jul 2019 13:54:30 +0000
Message-ID: <20190712135427.GB27820@rkaganb.sw.ru>
References: <20190712133324.3934659-1-arnd@arndb.de>
In-Reply-To: <20190712133324.3934659-1-arnd@arndb.de>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.12.0 (2019-05-25)
mail-followup-to: =?iso-8859-2?Q?Roman_Kagan_<rkagan@virtuozzo.com>,=09Arnd_Bergmann_<arnd@?=
 =?iso-8859-2?Q?arndb.de>,_Paolo_Bonzini_<pbonzini@redhat.com>,=09Radim_Kr?=
 =?iso-8859-2?Q?=E8m=E1=F8_<rkrcmar@redhat.com>,=09Thomas_Gleixner_<tglx@l?=
 =?iso-8859-2?Q?inutronix.de>,=09Ingo_Molnar_<mingo@redhat.com>,_Borislav_?=
 =?iso-8859-2?Q?Petkov_<bp@alien8.de>,=09x86@kernel.org,_"H._Peter_Anvin"_?=
 =?iso-8859-2?Q?<hpa@zytor.com>,=09Vitaly_Kuznetsov_<vkuznets@redhat.com>,?=
 =?iso-8859-2?Q?=09Liran_Alon_<liran.alon@oracle.com>,_kvm@vger.kernel.org?=
 =?iso-8859-2?Q?,=09linux-kernel@vger.kernel.org,_clang-built-linux@google?=
 =?iso-8859-2?Q?groups.com?=
x-originating-ip: [185.231.240.5]
x-clientproxiedby: HE1P191CA0004.EURP191.PROD.OUTLOOK.COM (2603:10a6:3:cf::14)
 To PR2PR08MB4649.eurprd08.prod.outlook.com (2603:10a6:101:18::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rkagan@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a7f7a63-77aa-4ed9-8215-08d706d07676
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:PR2PR08MB4636;
x-ms-traffictypediagnostic: PR2PR08MB4636:|PR2PR08MB4636:
x-microsoft-antispam-prvs: <PR2PR08MB4636D160D4340FC19483C353C9F20@PR2PR08MB4636.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:SPM;SFS:(10019020)(396003)(366004)(136003)(39850400004)(346002)(376002)(52314003)(189003)(199004)(26005)(6116002)(66476007)(86362001)(66446008)(64756008)(3846002)(68736007)(66946007)(486006)(54906003)(66556008)(14454004)(256004)(14444005)(36756003)(66066001)(186003)(446003)(11346002)(58126008)(476003)(316002)(7736002)(305945005)(6506007)(81166006)(81156014)(386003)(6486002)(5660300002)(6512007)(8936002)(6246003)(7416002)(8676002)(102836004)(99286004)(2906002)(53936002)(6916009)(52116002)(33656002)(25786009)(1076003)(71200400001)(71190400001)(76176011)(6436002)(229853002)(4326008)(478600001)(9686003)(30126002);DIR:OUT;SFP:1501;SCL:5;SRVR:PR2PR08MB4636;H:PR2PR08MB4649.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EpoJ5qYy3iE1uYT6Ijn1gwCbtWslZxLa5ZdiuWKj3TbzbHUPdC2mNqrS2iw2XgPGtJwhutvsGZ48qAJaHYbUzUZU+H8wfkHF8rEZ0oz3UoPmIq04+lEwOgQai2TOyQL4B6cJ//GuxHcW9LjIJ2kq+Z+jQ096l/SUpbJc0Rl8qS6PWIwzz+iJ3dW8ZeDRG2D3W14A4uQEUVZeGDNapd4GC2fW0BusbFw8MnCLxgoHOo5Jksl26LZsWEbbfiHsBEXycfNqKvtdJgWeOHnAR8RGXdw+6Be4fk/dEIJZC3EI7fOmp/fGsGLX43zu7fLNEqe9ZmcByuXKnOQ/lwRQlKucHmLogSkzPnyGI+/Bj41Oub2EQO8r13tGy604rBxneGVexDz3t5IyZXRDpqnkCHi3LV/yDgDs0TBcLwvDWH8lRwORYfFWfQm5HHY+qJc9GDNzOnOTOH6sNgG5WCALtz7CscaEEjKd/cJbuIIk/cv/NWamb057TtHW7YICrApw8Bhb
Content-Type: text/plain; charset="iso-8859-2"
Content-ID: <43608ADB0A8B3C49BF5F65BF0FBE848D@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a7f7a63-77aa-4ed9-8215-08d706d07676
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 13:54:30.8355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rkagan@virtuozzo.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR2PR08MB4636
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 12, 2019 at 03:32:43PM +0200, Arnd Bergmann wrote:
> clang points out that running a 64-bit guest on a 32-bit host
> would lead to uninitialized variables:
>=20
> arch/x86/kvm/hyperv.c:1610:6: error: variable 'ingpa' is used uninitializ=
ed whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>         if (!longmode) {
>             ^~~~~~~~~
> arch/x86/kvm/hyperv.c:1632:55: note: uninitialized use occurs here
>         trace_kvm_hv_hypercall(code, fast, rep_cnt, rep_idx, ingpa, outgp=
a);
>                                                              ^~~~~
> arch/x86/kvm/hyperv.c:1610:2: note: remove the 'if' if its condition is a=
lways true
>         if (!longmode) {
>         ^~~~~~~~~~~~~~~
> arch/x86/kvm/hyperv.c:1595:18: note: initialize the variable 'ingpa' to s=
ilence this warning
>         u64 param, ingpa, outgpa, ret =3D HV_STATUS_SUCCESS;
>                         ^
>                          =3D 0
> arch/x86/kvm/hyperv.c:1610:6: error: variable 'outgpa' is used uninitiali=
zed whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> arch/x86/kvm/hyperv.c:1610:6: error: variable 'param' is used uninitializ=
ed whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>=20
> Since that combination is not supported anyway, change the condition
> to tell the compiler how the code is actually executed.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: make the change inside of is_64_bit_mode().
> ---
>  arch/x86/kvm/hyperv.c | 6 ++----
>  arch/x86/kvm/x86.h    | 4 ++++
>  2 files changed, 6 insertions(+), 4 deletions(-)

Reviewed-by: Roman Kagan <rkagan@virtuozzo.com>

However I still think the log message could state it more explicitly
that it was the compiler's fault, and the patch is a workaround for it.

Otherwise later on someone may decide to restore the similarity of
is_64_bit_mode() to other inlines in this file, and will be extremely
unlikely to test clang 32-bit build...

Roman.
