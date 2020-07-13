Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25F721E0EE
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 21:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbgGMToz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 15:44:55 -0400
Received: from mail-co1nam11on2086.outbound.protection.outlook.com ([40.107.220.86]:21216
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726318AbgGMToy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 15:44:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0/WYnPFmkSeajrEnl+ISNnZNWQyoW6ds3g+obgte4tRoSGdvHNHh7Lb1J+RFtsiXU+4ouzm5/MkyemiGBD4Zs9jwSpP+sO5u4ZaT+nMxzzr0AIAGimlayYhGXL6EGCT2O6EcZmWppp/LX3P+mCWqQjYWqwsUlaXXJPvd8tuKSDCy+Ngo++vR6zz9nY0+Fhe9SMz1uxX/0NcDAdykJnMN/9Vi5oNSaNgLcsx2BsgNGS9KA/vIs7mAqXAzC4ZPl0+NtGFft8q/yJfQ5+Tr9jdr3dvlytLh5Z4DQ+yDMeCYgQOpjNUOlDPsT5d/5Je4mY+N5hQeCe/jFqkGcvlJJURFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sc5WtMFyz+v+6u8pw++D4DwvCkNkNsCAu58ov6rJE1s=;
 b=CtZmMynMF6KqxXFS5bPeHC1aszCi4usDSjEQWNKklKSX2Qr6678raNOAC2/mS5AtQUi3E6An3R3ZlZE8YYpEEsG31cNUCbONZ51PjkDcUlA31ghWoC6bN4MPOrPv+tGcccmu6AONehU0e6rYAYjwgXFLRc2H1jpFOKwHYoO9cAIGPNUWMB/Wa8GNyHWjOzj3WUiN/EiIxSsbh+hP52Ca/yIEmEBMsGY1bpbPe+GXw9BTV+fKACRd62L/pQ3SciBWkV9km/MQXgSus2gZUmjQT+OiuyTr45Iuj+gnb1R1Xhp5/vfjFYFk1JJzab5oqRYiipFN6zl3xalLRtZsD+bwFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sc5WtMFyz+v+6u8pw++D4DwvCkNkNsCAu58ov6rJE1s=;
 b=ZqcLRD+W0yHegNH421baRuUHZdAZRy3vD5qf8QzamH80BbHEBolL07o+NLOXpKbCC92A45uVUJv6/EabBRoxxf4nHWi/xNmVFXOA7z4nSOh0AVWYL9H7HQSgWNx/nBRrvkyy7TuPJknrqutf9Zc3/B9hnAbs5fvqdOYV8DRRzoU=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by BYAPR05MB5510.namprd05.prod.outlook.com (2603:10b6:a03:77::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9; Mon, 13 Jul
 2020 19:44:52 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f%4]) with mapi id 15.20.3195.009; Mon, 13 Jul 2020
 19:44:52 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Thomas Huth <thuth@redhat.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH] x86: reverse FW_CFG_MAX_ENTRY and
 FW_CFG_MAX_RAM
Thread-Topic: [kvm-unit-tests PATCH] x86: reverse FW_CFG_MAX_ENTRY and
 FW_CFG_MAX_RAM
Thread-Index: AQHWV561TFp+0pSAjU+cc8AanWXP96kFo86AgABJGAA=
Date:   Mon, 13 Jul 2020 19:44:52 +0000
Message-ID: <DD340172-C77E-497E-BE34-507921FA8C8F@vmware.com>
References: <20200711161432.32862-1-namit@vmware.com>
 <5fb8b8c6-bb1d-ba97-6ecf-770959199bff@redhat.com>
In-Reply-To: <5fb8b8c6-bb1d-ba97-6ecf-770959199bff@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4700:9b2:c93b:d519:464b:6d2e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5294e7e3-3523-46d8-293c-08d827653630
x-ms-traffictypediagnostic: BYAPR05MB5510:
x-microsoft-antispam-prvs: <BYAPR05MB551061205C146F1BDCD67CDBD0600@BYAPR05MB5510.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h7a00DIQYRhEW0oqsxc7iiDxTzV+WcGUkCCir77AoZetrquRjaa7D9hlKRYJMfyUcusg59zPoUQGpkcv42J/5Qi3/JjIVmz3juT5DuKhPKhBCogj5/yHoNwjro7Go/S4fj3w1mUkYU319zTUGfL8cmwucWalRU568svZzGG9gNWg01rqOZJkXLF8Dm91iAs+Gg7GAICnfT8M8XgZpJlq5hBZ+UNuOF5FLAOJcb3x4epSxBSwxzfB5TLaMBCud+nJG+Rkf4cbndX37vOLd9/yQPQFF1Ptpys+9QkLY2qcjoQ13+TsVkYcj60IRAsuf3mFkkm90BNLf72zbyedHPnPfQ4+Da5Auhm2/pcHqDrCDnk19aiostJrYKwlEGg7SpCnhfMxTSixQiKuF5kWqH3Mcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(66476007)(76116006)(5660300002)(64756008)(66556008)(53546011)(66446008)(966005)(6506007)(66946007)(2616005)(6512007)(86362001)(478600001)(71200400001)(33656002)(6486002)(4326008)(4744005)(8676002)(83380400001)(6916009)(316002)(54906003)(2906002)(186003)(36756003)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ahwIMs1wdG9Gle2H+M8Ss3WoRuBM/sgI+FqahiJb6xDObb0tAb9I15uz/fghc8+V1DwlacFiagnENxOcKJWP+fOLBJ7LIt0Ux6LAy0gWWApqDD3JwqhTYYbLCRKW5Guro0vnJ1XyEScWdnv5obDtwYX+qEKrjMiUfHcj4DFiQ/vaovD4YCUkKtfrYcObWnaMoK8S9RbQxI9nIsuV+f3arlii706dzaXIGRWU7QIo4TOFFzZYuLszqRDmtaOwcj42+B0nyztqKfiEV56yWdHp6LaMY7URCC45ZXM0iDX6Njs6AmIcWmjQf0a18DcJzDxGTfDl5ChSqXi4YNnG23PicCXVh8Ikr1y7mlfdwmmBzqZ6+HvzaIqeaetBsQOL+PFxPUg9WN5KkROjXVfRGiPaYlbPXEviIvQ564WQtLIWuLaQzo89UdaPYYFUfSYH9udiq1J5GgOcgradMUDfaMfPkLQk5dJjjcMpVXXlSYVMSLxVZfmpnBCjbSY/YX4xrMPq9Gi5xl90jRScb3mTg70hbUTBg7VNOVTOnTO9smvNBGY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <07B72AED403DD64BBE350A915047541F@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5294e7e3-3523-46d8-293c-08d827653630
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2020 19:44:52.4792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PzR8Uo0urpe8NFL3XIST9aj3BXXf8jYfFZ//ABIbwZfBsnEx2KZRXrN+uJRCrPnfvwnwflKfsd8RU58AMR0ang==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5510
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 13, 2020, at 8:23 AM, Thomas Huth <thuth@redhat.com> wrote:
>=20
> On 11/07/2020 18.14, Nadav Amit wrote:
>> FW_CFG_MAX_ENTRY should obviously be the last entry.
>>=20
>> Signed-off-by: Nadav Amit <namit@vmware.com>
>> ---
>> lib/x86/fwcfg.h | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/lib/x86/fwcfg.h b/lib/x86/fwcfg.h
>> index 64d4c6e..8095d8a 100644
>> --- a/lib/x86/fwcfg.h
>> +++ b/lib/x86/fwcfg.h
>> @@ -20,8 +20,8 @@
>> #define FW_CFG_NUMA             0x0d
>> #define FW_CFG_BOOT_MENU        0x0e
>> #define FW_CFG_MAX_CPUS         0x0f
>> -#define FW_CFG_MAX_ENTRY        0x10
>> -#define FW_CFG_MAX_RAM		0x11
>> +#define FW_CFG_MAX_RAM		0x10
>> +#define FW_CFG_MAX_ENTRY        0x11
>=20
> That should hopefully also fix the problem with Clang that I've just seen=
:
>=20
> https://gitlab.com/huth/kvm-unit-tests/-/jobs/635782173#L1372
>=20
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Indeed. Sorry for that. It happened since I cut some corners due to the lon=
g
cycles of rebooting and testing bare-metal machine (bad excuse).

