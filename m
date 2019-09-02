Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1EE2A598F
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2019 16:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731598AbfIBOkd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Sep 2019 10:40:33 -0400
Received: from mail-eopbgr750130.outbound.protection.outlook.com ([40.107.75.130]:29710
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730830AbfIBOkc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Sep 2019 10:40:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kq2biLw9HFXdggMqewz8pyGTy5TYByh0BgDHW/CTc9uS2UnZtBNJf6n0NNPew9tzPxGn6jiHJr+EMGBOZuNCixpy3BJinUYG+GftEz6HCVaeX6v6vxw2WI+mwMTQkvKwz3I19MQsPzdxEvmg0CjaeIp4hoU86tpQAQVbTY6jRbE0bci0QVRuYv1WMBjsmd7Fg3Bb8nup0cymRznfTPJa7zs1xNxpqj4KKLGxpYP5x7ey9fWW7yCcbl5f8MRqeEy9YLGxcSQIb1IoZKZ8Jw5/ADrPMEr+5bM6LUEEAFP20bMJZ4/5ZICBEhn2ksS1HVP7QhTTKdInA7lycfHwl78pgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q4EGcA4uF+U0YPEY9+XtI783eny5k/mbsya35N0MCEQ=;
 b=jkkMCJqHFCJUZFKm5jtbZrhDWzTVl3ZiTm/PQgcPTpgV05sWuU6p/Cv5DZNF5Oao+B0zntA7NYH49IIIpmw2u26IIH4qGzIEPjxiNQioahwNo5NnKFGrTzGQFCXblG/0AoLGy2cYCG3DGWseoYQvaVCoj6qK2wVvOXxzy7drY1VDMol//eCe6UCpn6StqpmLDb85GhMxIfBlOLX0JGMl3p4JG/swHML9SIWc/hW0LeMHmlYx71NHymIFmcGFHqTyZG/CIkql+LoUxRF63rH7W2ZzVgNbumAdSNJQ9VeWiTM/baGFwEatNCC7IGfkOtT+VqJdfUptzJh8HJSERdsgOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q4EGcA4uF+U0YPEY9+XtI783eny5k/mbsya35N0MCEQ=;
 b=EVxmpHXpkzbujpbcLpI32pI7Sf1n2+bpexmsuAm7GIVJF2pdyIT/BR/qqwT7OjgF8RZSYXzrWcRDhRkmF/HsNjZf9tMPU1+jhehdaFDQJQ5cWpnlpQ4f7STk3M5B6HtagqTKtYut1l12m9U3pcxU7K4rp0eoeeoszuZWmU3Am38=
Received: from DM5PR21MB0137.namprd21.prod.outlook.com (10.173.173.12) by
 DM5PR21MB0700.namprd21.prod.outlook.com (10.175.112.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.3; Mon, 2 Sep 2019 14:40:26 +0000
Received: from DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::c437:6219:efcc:fb8a]) by DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::c437:6219:efcc:fb8a%7]) with mapi id 15.20.2263.004; Mon, 2 Sep 2019
 14:40:26 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     "lantianyu1986@gmail.com" <lantianyu1986@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
CC:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH V2] x86/Hyper-V: Fix overflow issue in the fill_gva_list()
Thread-Topic: [PATCH V2] x86/Hyper-V: Fix overflow issue in the
 fill_gva_list()
Thread-Index: AQHVYYvUITYCw+y5jU6ew4FN0rlxzKcYdOig
Date:   Mon, 2 Sep 2019 14:40:26 +0000
Message-ID: <DM5PR21MB01379A2DC17C13ABCFEE5E05D7BE0@DM5PR21MB0137.namprd21.prod.outlook.com>
References: <20190902124143.119478-1-Tianyu.Lan@microsoft.com>
In-Reply-To: <20190902124143.119478-1-Tianyu.Lan@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-09-02T14:40:24.1421229Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e6ae5408-2b9a-4e9d-a873-ec1ebf59a379;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e309f0cc-64e6-480e-17f0-08d72fb37e6e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR21MB0700;
x-ms-traffictypediagnostic: DM5PR21MB0700:|DM5PR21MB0700:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR21MB0700A82EE1D8F7EF185AE09FD7BE0@DM5PR21MB0700.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:359;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(199004)(189003)(14454004)(54906003)(22452003)(110136005)(316002)(66066001)(6246003)(478600001)(1511001)(53936002)(2906002)(5660300002)(6436002)(52536014)(99286004)(71190400001)(55016002)(25786009)(9686003)(229853002)(256004)(8936002)(2201001)(7736002)(2501003)(86362001)(10090500001)(26005)(446003)(186003)(11346002)(4326008)(76116006)(66556008)(66476007)(6506007)(66446008)(6116002)(3846002)(8990500004)(66946007)(64756008)(102836004)(7696005)(76176011)(476003)(486006)(81156014)(81166006)(8676002)(7416002)(33656002)(10290500003)(71200400001)(74316002)(305945005)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR21MB0700;H:DM5PR21MB0137.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NH//qtB+HHtMlioKbkDFl8VqOXi9ozWQ086ZzivDU+uGVohpMspEov5ffp3AzmlijVEm4ESWEhBi89pZx50WrNdIYd3fRtMWgx1tGTcj1lppRj8beu0VeFbzMxq4PAiIIY6Y44nE78mZwB83OyXeXV1WbfxheuTaIxvi5RCM1d1+nPM/AtJlhTv1EiAOLkQEjO5Lck+7u/LUbIFKAH0O9wxNr+q/y/Vl0PHbsh/dyAr4Y2vKF+KBkLTyCudcLr0QsgIWmSh0g+leNqgjEnthlvz7Jo376C0PUvnYnC2xBa+ML3tptwFbMYDROvkLY4jOxpTkRxJNCDgLgIEHGvAF0qUMmHEneAV0xJVp2PwKLo9SJoeVvIIXhh5QOBh9NtUdogzTSpTPkwg4YGxFXtwASJMg3X+PxZAA4s40Yl7JTek=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e309f0cc-64e6-480e-17f0-08d72fb37e6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 14:40:26.1041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rzo4F6shxpFhxPVkmlW1kvDxaYycxNZkNs0V/yiA+GMv6Wp6ovLFZzIO8uA/e0h7rnBP2DlmzbeRuTBgvHWDpmF4El2R0rSN2wVtusYwj84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0700
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com> Sent: Monday, September 2, 2019=
 5:42 AM
>=20
> When the 'start' parameter is >=3D  0xFF000000 on 32-bit
> systems, or >=3D 0xFFFFFFFF'FF000000 on 64-bit systems,
> fill_gva_list gets into an infinite loop.  With such inputs,
> 'cur' overflows after adding HV_TLB_FLUSH_UNIT and always
> compares as less than end.  Memory is filled with guest virtual
> addresses until the system crashes
>=20
> Fix this by never incrementing 'cur' to be larger than 'end'.
>=20
> Reported-by: Jong Hyun Park <park.jonghyun@yonsei.ac.kr>
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> Fixes: 2ffd9e33ce4a ("x86/hyper-v: Use hypercall for remote TLB flush")
> ---
> Change since v1:
>      - Simply the commit message
>=20
>  arch/x86/hyperv/mmu.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/hyperv/mmu.c b/arch/x86/hyperv/mmu.c
> index e65d7fe6489f..5208ba49c89a 100644
> --- a/arch/x86/hyperv/mmu.c
> +++ b/arch/x86/hyperv/mmu.c
> @@ -37,12 +37,14 @@ static inline int fill_gva_list(u64 gva_list[], int o=
ffset,
>  		 * Lower 12 bits encode the number of additional
>  		 * pages to flush (in addition to the 'cur' page).
>  		 */
> -		if (diff >=3D HV_TLB_FLUSH_UNIT)
> +		if (diff >=3D HV_TLB_FLUSH_UNIT) {
>  			gva_list[gva_n] |=3D ~PAGE_MASK;
> -		else if (diff)
> +			cur +=3D HV_TLB_FLUSH_UNIT;
> +		}  else if (diff) {
>  			gva_list[gva_n] |=3D (diff - 1) >> PAGE_SHIFT;
> +			cur =3D end;
> +		}
>=20
> -		cur +=3D HV_TLB_FLUSH_UNIT;
>  		gva_n++;
>=20
>  	} while (cur < end);
> --
> 2.14.5

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

