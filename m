Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8CF3678D2
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 06:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhDVEqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 00:46:16 -0400
Received: from mail-mw2nam12on2055.outbound.protection.outlook.com ([40.107.244.55]:35296
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229578AbhDVEqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 00:46:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWA7zephkmtoNKEggj2Jy3Pe2rr6Ju0wqKVuOPIfa+K/Ruodh1AYST/3BNibcG6YeWy69Cx2nKSRVMKkR6KyxAf26n2R16ln5O7uadLWv+4id4WNrPGaMO0Oy06EMUXL8p2ZGu6zm/47siEQURAqg+APNKwQeVBpYZlqEY0OrPSbPcRgZhlojQJoOchKy/nZ6fnGzM+BAhKuCKVkSFIW0HVZkWo0bL+EeELGfP0Tw1uhKqdUlIIUch/1Zbudi2tbVP4xWEXManpNMMSefGyZ1MqBHROTtC8c0f1q/spxzqtv5ODSV+L/zb0mZZ5SObHKFV+NRJna56Ux8IDs1ih/7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXUHQnxPY3oLNyzeTfgFvrNx9J6Xc6EP8Z/F+NZ9NaU=;
 b=c8kjAdl7gVzaTljI82hVn3BLHSLQUb9HVrhioZ6m35hsoSt0xhn/hVx40MJQR9rcbP4QJWju942n1cqJZPnWom32LjrZvcYambyNIJC0RpWwtAhDNRue6sDwu7Qgx/6yjNh2dCh9yoKayJNh5ly7u8c8OHYE8YUJEVu2Y/qDZSJCCNlPFpEUNG0Y1Z50h7YbwkJbWFsh3SR5nj7FbN4LrjRfiun5wdtguaPZ/88MdT3XGwneRb7jadIXK+TjqiWaaQ1ubk7yMq/i+tipAf4+7P3N0XOMUnrIHpqun2U9IboENRy7MS2E1+8EUOYB78n2vg4HKPmQsSrlJoO43Brj3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXUHQnxPY3oLNyzeTfgFvrNx9J6Xc6EP8Z/F+NZ9NaU=;
 b=LkFe9T0QND9JzaXBQMdLJwMMBGIHvZtHOYLQodWkjkopjI8W93k7hpfEmo8AH2Qp0kOFRJ3iTd6R+6d6cJ8e+JKx7zD3ksjRkPubJdN0Ol4bimeGI/Iw1pzVA79vo01UqiuqpOSON3dFjijLFysgxlLALAIJh+N7OS8/N1YJ20c=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by BYAPR05MB5909.namprd05.prod.outlook.com (2603:10b6:a03:ca::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.9; Thu, 22 Apr
 2021 04:45:39 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::3160:ae0e:f94e:26b]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::3160:ae0e:f94e:26b%7]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 04:45:39 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
CC:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: linux-next: manual merge of the kvm tree with the tip tree
Thread-Topic: linux-next: manual merge of the kvm tree with the tip tree
Thread-Index: AQHXNzBSUrhwGdGsYUiaVBc7YAkxAqq/9k0A
Date:   Thu, 22 Apr 2021 04:45:38 +0000
Message-ID: <142AD46E-6B41-49F3-90C1-624649A20764@vmware.com>
References: <20210422143056.62a3fee4@canb.auug.org.au>
In-Reply-To: <20210422143056.62a3fee4@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: canb.auug.org.au; dkim=none (message not signed)
 header.d=none;canb.auug.org.au; dmarc=none action=none
 header.from=vmware.com;
x-originating-ip: [24.6.216.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 184733a2-84c1-4265-6198-08d905497a2c
x-ms-traffictypediagnostic: BYAPR05MB5909:
x-microsoft-antispam-prvs: <BYAPR05MB59099B2271CE28E0A21F2643D0469@BYAPR05MB5909.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 13cvY0XA9yvT9p/twcTmVuYBBMaQi/EEUKxJ1lYrtd7goTxXVMcR+tfQFbj56tw9gfWrOL3HDO9dUbZaJsm1gUcax29OUpbj0SDxJ2ah9b7UUx26m2mKXfz4TRHg4jMqr4fdwESlvN28rZ5ovf36U5IRFoxK8lOmov73IN1viycK54YkaqdPLiTppPn5CyXO8jJ/2W123fGLplikEO97fZ/cTeHh4eCRxK3bbsi3Ie3qcXo6sBOvymzCr56hgFdkjfR0vN+hctlV0tZImo7NqQ0VR0wm/VM+xaOkKsyFAmni7hxUo2tr5GZzrLOc0z5lYEJQjcbaRCsbkrLK5xVwuaL/qezlVpkWOVNrpf29Ep52JOpWBK4ObgiKbsnkiPGMNh1JukOCO4kEujrWwiOW3F3AFnQ8EoELHXMWFojjtYRYnH4LXYhE2oEr3LL+kjX5xOP9lD6N4aVgpMO11XpcpHFPXTjYxaO93hhrwD+52H/EmNOmiqV/S7l0IbCYl4SUVuo/Eau1UsAevFEmj9Y88ag7b/yY8cBp5ePIL0Pd+acz5IgVMALSg3DwaUxMT0CcyGLd4IUNSm55VP1JDvNOrg6a1TDrYY6gfc6vkadi5FVKWr/7ck2wJznGDNr2oi69lDCBPmTccZPnyMURu2PcssT6CK5x0cDstrmdbSuKylo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(396003)(366004)(346002)(6506007)(53546011)(64756008)(66556008)(66446008)(6916009)(76116006)(7416002)(122000001)(36756003)(66476007)(71200400001)(38100700002)(66946007)(33656002)(186003)(2616005)(86362001)(54906003)(2906002)(26005)(5660300002)(6512007)(6486002)(478600001)(8936002)(4326008)(316002)(83380400001)(8676002)(4744005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Uo3rraxYdoZfTA7iOGS23s4jTlFuuOsi9Q6zAoXJLusve7L99vU4w70OmTXG?=
 =?us-ascii?Q?uxvKVu6UN2ZoztzGhvaqDeFOGCJYRapCQngkj3PBGBPLtYImhG2Kj0IUrqSO?=
 =?us-ascii?Q?ixspfwoyCiUaYGa9RuxoH7squAViCmso5cdKhrk+sxFAFGk8h4fIyO4UZrSt?=
 =?us-ascii?Q?epxq1v6BcSVU2kibPYWIV9VManJ2mvAovP7JEbCYtQC4Ec0FsivzeK3poeiw?=
 =?us-ascii?Q?tCUo24RQms+gxawE6jsaBsjrBv5YNGayHj+f3zPIPlUJZ2vAIDnJo7nUtX+l?=
 =?us-ascii?Q?N37/gy/roMLtU8BxtKiTq3sqNkpkTxFm0q9OrHgYquF3paWzZwfYLczrOT3a?=
 =?us-ascii?Q?ZWJ05yKW3OjakmBLToEPPIFG2/eBNN9gBThE9Hjb+gkCFJI46Xy/1qc+Bvpn?=
 =?us-ascii?Q?msJlCDpex2rLwJvYhK4loAXgdTpj8k44VkUmbO02yIJV9Gm32ueGtximrGcZ?=
 =?us-ascii?Q?f4fEtKSifC7xjXB0bB82p8e/kPPV/4xqLSOPCL+7MZc67BuG610sJekE5XqF?=
 =?us-ascii?Q?NTwKcIr0VU6KA2DzQerF+nPBUILlV6IRhkcfZfurIpd1OuYEgeryy9vSojEq?=
 =?us-ascii?Q?bpjXbyQdhM3+AHsNAG+vPj7/XBx0a9+kUo9HGXvC9uxbZ4uWT03ve543KTnu?=
 =?us-ascii?Q?WdFTgsETY/cjvn0h5KJbouEpyb84o5xF9ZGWtRwK/ochiLrTm7+zg69q25NY?=
 =?us-ascii?Q?2neZPx6vEtOtlkIfHABE+Ww5HuXUZO1hoRoVVqNs1iVDvrVF+zxBdmdSL34r?=
 =?us-ascii?Q?rwgnK51ARntTPzFYkf9SSG5mkfxDpwU57K6dzMEvtuBuKUzpspO1H93MACZr?=
 =?us-ascii?Q?Vk+0kWcu47Ry8bQIBNlOqqfmmDwbdW9x4a46ome8NAWQaR1oAktInP+RINFd?=
 =?us-ascii?Q?uzBfCwcmcVGJk51CuUorAVQzzmrLZFM80WwtDjtYpJR8wSCLAThX6jcX8ZEC?=
 =?us-ascii?Q?YOQdkktjdORJ6lE30M4h25LIWGAJ/r2OtNVCEtg6GMumyGJ0341zz0w374D/?=
 =?us-ascii?Q?9ayCDo0NuM4Z1TcIpzqYwXre2Le/hlD+UAPVK1UjGTshcdUbxNhK5vWuryxf?=
 =?us-ascii?Q?KUkJPg/+MKv4efgD2WvwSjbpKLIpJhgGSsL2RzAgG1zzUQ7/kHeC04tyCSRr?=
 =?us-ascii?Q?p1WxzAhocF4kJLAKWtCPE9gm1BwiNMwUaQ48qltsMFjWxv2tofR49bf1yIt+?=
 =?us-ascii?Q?bN+IWrDHDeIIWhy2Fo3v9eUlQdVLM1gT+FPAQVZjDxermbjhBkTohFU7elYl?=
 =?us-ascii?Q?q1yuCtWrWLk2BquYusFFq7A8OWM/vxEKGH6/muly+8LL1Y8Qhe+4HClHRtYh?=
 =?us-ascii?Q?cbRVa/2eOxkwJExJ7uQrHyY7?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <74F8121D26A55F45BFD63DB3A13188FB@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 184733a2-84c1-4265-6198-08d905497a2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 04:45:38.9286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VCDk/+3mo0YkzO8SmpeZXHFqSTe7m7Lgc/LzDGkXqOeqk2kYLjIraOKAr5cuTeER4Yg6ci0EzQ0McVyeC6H6WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5909
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Apr 21, 2021, at 9:30 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrot=
e:
>=20
> Hi all,
>=20
> Today's linux-next merge of the kvm tree got a conflict in:
>=20
>  arch/x86/kernel/kvm.c
>=20
> between commit:
>=20
>  4ce94eabac16 ("x86/mm/tlb: Flush remote and local TLBs concurrently")
>=20
> from the tip tree and commit:
>=20
>  2b519b5797d4 ("x86/kvm: Don't bother __pv_cpu_mask when !CONFIG_SMP")
>=20
> from the kvm tree.

Thank you and sorry for that.

>  static void __init kvm_smp_prepare_boot_cpu(void)
>  {
>  	/*
> @@@ -655,15 -668,9 +673,9 @@@ static void __init kvm_guest_init(void
>=20
>  	if (kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
>  		has_steal_clock =3D 1;
> -		pv_ops.time.steal_clock =3D kvm_steal_clock;
> +		static_call_update(pv_steal_clock, kvm_steal_clock);

I do not understand how this line ended in the merge fix though.

Not that it is correct or wrong, but it is not part of either of
these 2 patches AFAIK.

