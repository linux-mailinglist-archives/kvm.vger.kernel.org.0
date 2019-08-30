Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28048A3D1D
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 19:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfH3Rlu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Aug 2019 13:41:50 -0400
Received: from mail-eopbgr720097.outbound.protection.outlook.com ([40.107.72.97]:62649
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727434AbfH3Rlt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 13:41:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZNjPmaVtDZU2jAy47MeasN2X7ikYdU8TTgZcWfqKTK1onVXI41c3f98kFdLq8G/iqENV9ewkLUMqGivzGfAPvAm41/qULRh0DPZS3MzN/4lE3myOlFUWsEJ9Wtp7AGizt/JO9cEWUmZMe/0PEH8YT6UdEz+iDUtoU4h5pK4ye8sNxUEskcg4+pkcDH0K/htYlpUjJX0402V3VFM+3N0n9qAOUTzsnCq2MEZ2bd+HdVXmaJxf70bx+1f37nQpWhca0HO9xnuQSTyhwy093Jzei3ycZIlrCXlbK/r84xyXYSh5iLmeVT+R7c5irpFbzkCpUNEMdfgFEeRqudq1PIHXbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oexsqe6FMa+egYRrxcs6nfgxPWGndpfhoiDhojZdDe0=;
 b=Kk7Nec0AInGWfkFk/IYUnVKl47LaywOy0FmPGZAWw6sB1jI6Ps+pooZ4SZE8EXlEyp/UYM7luCndSnei9AH8+sjvEIkjnsM+11ntrk+zy8JSepzBucpThUK8t9YlGYkhPRZrFN8GLmiVABr49g4q+frwnvD9tn2GtK25a0yfaSuVWIkP4NAlEvqIjdu514lk7GB8Tsbd8L6lCx5FLWSs144vaBFAlirrYZhuX3HhEF+CQ9GgJMnEUEZeZp483dRZcwsuROeF5/fh5F5mIt+Ib9gUkR3HKaJFTiqdfx+Vi+mOMKW5x4q9dEo3kZJGAMF2yJXm9IjDgSABhZvO0BaBKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oexsqe6FMa+egYRrxcs6nfgxPWGndpfhoiDhojZdDe0=;
 b=m0p/mIODkMTy+vD9+HRYfjC5taoGdLGkhQv2dxT0vBV5jo8iGJIDWrU80B1iLIN5zukdWdPYXSOsjYWBnEeunEepQ7dG+YebpfsQFts/n25KpYEHmgAv49b8WdJvFldx9AZ0sBV60RnYTme2JsxUddWu/2hrtoH0+oCP/yOM1lI=
Received: from DM5PR21MB0137.namprd21.prod.outlook.com (10.173.173.12) by
 DM5PR21MB0844.namprd21.prod.outlook.com (10.173.172.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.1; Fri, 30 Aug 2019 17:41:06 +0000
Received: from DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::c437:6219:efcc:fb8a]) by DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::c437:6219:efcc:fb8a%7]) with mapi id 15.20.2241.000; Fri, 30 Aug 2019
 17:41:06 +0000
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
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
CC:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] x86/Hyper-V: Fix overflow issue in the fill_gva_list()
Thread-Topic: [PATCH] x86/Hyper-V: Fix overflow issue in the fill_gva_list()
Thread-Index: AQHVXvphdgTb3vS6T0iILxQzg0FAQ6cTtUmw
Date:   Fri, 30 Aug 2019 17:41:06 +0000
Message-ID: <DM5PR21MB0137B7C2AAD0FC65CB3E1306D7BD0@DM5PR21MB0137.namprd21.prod.outlook.com>
References: <20190830061540.211072-1-Tianyu.Lan@microsoft.com>
In-Reply-To: <20190830061540.211072-1-Tianyu.Lan@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-30T17:41:04.7566166Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=079b217d-92f2-49cb-b3e4-013ede42540f;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db772134-055b-4ad3-bbe0-08d72d713c99
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR21MB0844;
x-ms-traffictypediagnostic: DM5PR21MB0844:|DM5PR21MB0844:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR21MB0844F1EAFF80741F7203D4ECD7BD0@DM5PR21MB0844.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(189003)(199004)(66476007)(52536014)(7736002)(229853002)(22452003)(8990500004)(305945005)(25786009)(3846002)(6116002)(26005)(8676002)(4326008)(14444005)(81166006)(7696005)(256004)(486006)(186003)(81156014)(53936002)(102836004)(6506007)(55016002)(9686003)(8936002)(33656002)(6246003)(74316002)(6436002)(10090500001)(2201001)(66946007)(76116006)(7416002)(11346002)(14454004)(476003)(10290500003)(76176011)(446003)(86362001)(1511001)(71200400001)(54906003)(2501003)(110136005)(71190400001)(66556008)(66066001)(316002)(66446008)(478600001)(99286004)(5660300002)(2906002)(64756008)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR21MB0844;H:DM5PR21MB0137.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2h5A9mx0fvCS0PRkAjLwgsBZfM1gYgra1TaSh3yslr/k5UrGkaNjQ14fk6KR0uWm2aPKpyPCY9nGTX+MuwtrbXypRdRWgBoTy7zSk1mQFJ4J5PYwPd7gal48j29pDj3xPoWQNUi0icVqvis2z4vkoKQHCpgTmewOY1Jbr3uycHYpsLRbavg6xxw4KwSyZQ3gowR02tX0ZXausaZtnTScT8VCcC+QPkTCnmZukTkCV3n2bruk8v0V92bxf2CExnigJUwlpIY0zqiYUII5caNE845cOPNOBdJ3K6WrkUKFGEPrm3d6Degee+ntgBjJHuF2IdeTLT9C9HeKTmCQZzTfOitwMEiaeNxyQXkhulrN3zjaElg03n5MUNn3XRde27FKf9MAy2BYwjurJTVJbzFplfl2jmG0Cw/HNXQmdh5hxso=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db772134-055b-4ad3-bbe0-08d72d713c99
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 17:41:06.5646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hWwZfohga8a8L6XZnIPs7sjocR2zafNg4TnzzHWN6t/guLYkKnptCg0OAB+AeECChMMvWaRBAn8CL8GaWGyNb6IGpwobSijwmNXeriMv/mE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0844
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: lantianyu1986@gmail.com  Sent: Thursday, August 29, 2019 11:16 PM
>=20
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>=20
> fill_gva_list() populates gva list and adds offset
> HV_TLB_FLUSH_UNIT(0x1000000) to variable "cur"
> in the each loop. When diff between "end" and "cur" is
> less than HV_TLB_FLUSH_UNIT, the gva entry should
> be the last one and the loop should be end.
>=20
> If cur is equal or greater than 0xFF000000 on 32-bit
> mode, "cur" will be overflow after adding HV_TLB_FLUSH_UNIT.
> Its value will be wrapped and less than "end". fill_gva_list()
> falls into an infinite loop and fill gva list out of
> border finally.
>=20
> Set "cur" to be "end" to make loop end when diff is
> less than HV_TLB_FLUSH_UNIT and add HV_TLB_FLUSH_UNIT to
> "cur" when diff is equal or greater than HV_TLB_FLUSH_UNIT.
> Fix the overflow issue.

Let me suggest simplifying the commit message a bit.  It
doesn't need to describe every line of the code change.   I think
it should also make clear that the same problem could occur on
64-bit systems with the right "start" address.  My suggestion:

When the 'start' parameter is >=3D  0xFF000000 on 32-bit
systems, or >=3D 0xFFFFFFFF'FF000000 on 64-bit systems,
fill_gva_list gets into an infinite loop.  With such inputs,
'cur' overflows after adding HV_TLB_FLUSH_UNIT and always
compares as less than end.  Memory is filled with guest virtual
addresses until the system crashes

Fix this by never incrementing 'cur' to be larger than 'end'.

>=20
> Reported-by: Jong Hyun Park <park.jonghyun@yonsei.ac.kr>
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> Fixes: 2ffd9e33ce4a ("x86/hyper-v: Use hypercall for remote
> TLB flush")

The "Fixes:" line needs to not wrap.  It's exempt from the
"wrap at 75 columns" rule in order to simplify parsing scripts.

The code itself looks good.

Michael

