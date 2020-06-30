Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B748C20FAA8
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 19:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730287AbgF3Rha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 13:37:30 -0400
Received: from mail-dm6nam12on2080.outbound.protection.outlook.com ([40.107.243.80]:6040
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726120AbgF3Rh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jun 2020 13:37:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KNsc/5/SM6FM9JKmVyQxSO2P3ea0T1gA5t96rgbpODfyzUgNs+etsfttyVrptqHsZEtVFw31KV9k+gqMY2IyNxHoXPQp2ya2HsQPg5wMwqNBP9A3EhOW3nL56DVCQTWjhAEBq3UqVzFnod49oo1pGtJ5dm7OvkvZgON9W17dN6fcb/+RpVeeMo3WFrdmuCbzaB6JBiKv3E/qDzlzq7oVNldf7DRv288jC5Fspdtc6bMOfUCYPDPv1Bka+7dDf+f19pN6WIxn0W0WxSbrwjcS/JP+UUyj5D8shnf6EzAyUz6VT9k9DMC+2J6C2PDLzLI1LBPtWbNR9wArLL7k999kQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kf9wFscvdF1aW4yqrNZCwXS5xQSysM0X0qzVpdCaGCs=;
 b=Ei9AAY+CUt+F3A6XFrl0xEvtD0BgTFcaOZM6pBQ3dwmVllPYQLBeXXVYhjhqAaBju/5d3sTqWoIRAs4OPdC6sfGSNAbaIMm8wZi+BtCHaYS+JvUI1cBYfg3ECzydcDsQ2OTZQZ9NT5SD9EOTuMpQC7F9hUqiJU29/4Tvyo4QsiT+icl0xnPnkoD4QL/l0YIPPazG6Y3vVzxwWDgtXUWEiL+YLL5NWIuw0deKybF01AkPShC9J0IyX3/h2KcMYzjEUBHNld2bXydXRHupl6fy5K3qjWexSohzKHCIXOcWKkyRfF5ubdMSTWD3YHDXXzEfZuYp/x5f9LpM1ob+0qgOsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kf9wFscvdF1aW4yqrNZCwXS5xQSysM0X0qzVpdCaGCs=;
 b=h1hLZt0VHWjIaLP3esOoO921EqxUtVJqdAk92rGLpn8IC2M2wM1DhQpH5NzK1PjawYJI4vhCagGbIkVRWUBtULGTXU950kDU2mhXEsf+uXOzyRzteiXPq02c5j4KBG3d4xHBj9QgiZj3UNVteiWciu6bZQBUoTStYVGlgZ5EoCI=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by BYAPR05MB5094.namprd05.prod.outlook.com (2603:10b6:a03:9d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.10; Tue, 30 Jun
 2020 17:37:25 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f%4]) with mapi id 15.20.3153.019; Tue, 30 Jun 2020
 17:37:25 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 4/5] x86: svm: wrong reserved bit in
 npt_rsvd_pfwalk_prepare
Thread-Topic: [kvm-unit-tests PATCH 4/5] x86: svm: wrong reserved bit in
 npt_rsvd_pfwalk_prepare
Thread-Index: AQHWTsOceV0MLftLMEWvbhOBAHx4KKjxYJgAgAAMGQA=
Date:   Tue, 30 Jun 2020 17:37:24 +0000
Message-ID: <A93E7AB5-95C2-4FD0-BB17-00A82E6B7A73@vmware.com>
References: <20200630094516.22983-1-namit@vmware.com>
 <20200630094516.22983-5-namit@vmware.com>
 <306265c5-0593-397b-3b8f-eb237d1425cc@redhat.com>
In-Reply-To: <306265c5-0593-397b-3b8f-eb237d1425cc@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4700:9b2:3cd7:a5e0:3f6b:a192]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c794d6b7-50ec-420c-658a-08d81d1c409a
x-ms-traffictypediagnostic: BYAPR05MB5094:
x-microsoft-antispam-prvs: <BYAPR05MB509458029CE7BB31C9807239D06F0@BYAPR05MB5094.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3v7jYFAuFnSHUupKxg1+i/z6zkgiIgFAKGu4o9c6AorUv9bFlHdRI64ssczFIznPJf4JhgrlVIP6WNToLpt0oT420AC1R5RfTh3mNOBRTa5nFi1cgpASMSP0Cwq91fm7ka7Qyqg/Qp43Y/VWI2yteFmGVAXoEfdKKEPWut/hUJfPfYMQUY388kgKYXgLmoOAVylSa5Qo44QiPTwrio3w4EIKgPlCUhcmBwjuCFKU010rGsq8FgdWthDaHAvc5ROezh3sF4uW4lDlP9ex1FTrRkL7JSglM9BcDXgS0j1nwzVSyZ3fzI15qHWJGlnfpRIaMJH/4WmmQkQM5EmqjroB9A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(33656002)(478600001)(5660300002)(316002)(4326008)(6486002)(71200400001)(83380400001)(2616005)(53546011)(66946007)(66556008)(76116006)(186003)(8676002)(6506007)(86362001)(6916009)(36756003)(8936002)(66476007)(64756008)(2906002)(66446008)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 7nnszeRWWd/5NhMC3UNJMaiPOB1b1OV04vjHyQlk771tTQvC+SoarmUzRnbIO3UKYjBjvNXy63VbxACcYzVU5yPDbwb+vve7q/n2LyejGWyZ/4nwf4ntfr9I+mibV8XF9zqUlhwrBkxfn3CMwuNiv5AXyahbJtr6Bxz1x6Ffzzvr7pmmOVfLNDBWUIxikTCJ35opFL3VG4F8FK91PQ5SXk3sVnYjhgdfNRGO5r/5cCsyrz6t1RQmU+qTihSDWRqAyPHe+BExjwBCbEk6wwZNTg+B6H9PEj0znBx4u39O40Hyr96x0QRVAHgvx7NKC0j22/zNfSU59j5PUal5d93+bm7i6yFXbWUdQ+xBQcmqytCe7JwUwYINZchFuSm03A1vWbvICInUwdbfLMo/GfQCBwQNmVT05y0bXEk3MwFJVGq1rsTq86T52PRJVYQbQjHAmmD0Ikz19dtjWyAU8uKD/RbrMlG6MLJeavf22Iu2r41NkFVekEwQTnZ8fvK+d9EM+OiegfGJgGb8he2d1W3gmpAoYreC0vHl2enyX2zlt2g=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <68DECA0CF5D7D044B669503D88667A2D@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c794d6b7-50ec-420c-658a-08d81d1c409a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 17:37:24.8447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /C0evFoXPfxgXkyaRyno+YH0SMlC2LXJ6JEVvOoRgGaZ+0KckF+UUX/d3c7W1QcrJMjy1jPjOBJYozk9LaqL/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5094
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 30, 2020, at 9:54 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 30/06/20 11:45, Nadav Amit wrote:
>> According to AMD manual bit 8 in PDPE is not reserved, but bit 7.
>>=20
>> Signed-off-by: Nadav Amit <namit@vmware.com>
>> ---
>> x86/svm_tests.c | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
>> index 92cefaf..323031f 100644
>> --- a/x86/svm_tests.c
>> +++ b/x86/svm_tests.c
>> @@ -825,13 +825,13 @@ static void npt_rsvd_pfwalk_prepare(struct svm_tes=
t *test)
>>     vmcb_ident(vmcb);
>>=20
>>     pdpe =3D npt_get_pdpe();
>> -    pdpe[0] |=3D (1ULL << 8);
>> +    pdpe[0] |=3D (1ULL << 7);
>> }
>>=20
>> static bool npt_rsvd_pfwalk_check(struct svm_test *test)
>> {
>>     u64 *pdpe =3D npt_get_pdpe();
>> -    pdpe[0] &=3D ~(1ULL << 8);
>> +    pdpe[0] &=3D ~(1ULL << 7);
>>=20
>>     return (vmcb->control.exit_code =3D=3D SVM_EXIT_NPF)
>>             && (vmcb->control.exit_info_1 =3D=3D 0x20000000eULL);
>=20
> Wait, bit 7 is not reserved, it's the PS bit.  We need to use the PML4E i=
nstead (and
> then using bit 7 or bit 8 is irrelevant):

Err.. I remembered that bit 7 is not zero for no reason.

Now I wonder why it caused #PF at all. To be fair, I did not run it on
bare-metal yet, since I do not have access to such a machine.

