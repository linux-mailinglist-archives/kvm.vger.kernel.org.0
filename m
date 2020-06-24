Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D930207A41
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 19:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405557AbgFXR2H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 13:28:07 -0400
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:6125
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405456AbgFXR2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jun 2020 13:28:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iIEhmcQIbTn8O9HbtgH/VKiljdqu1A02Ls1rPzVjJ9y3irp8On/4GIfZkw11ZaM3Zda7er26KQMwPhV0Xhh3y0N4yytiNqGRVlXlzpSbZE5o7G4Xl+Pk+Ym0mnmFz6e0s2NMGt5qqR/I/Tv2Wgyh2jLtDxU+LFxln9korCPDhDqv1yV2MOmgA8gKNHhI8dyyceJyJf4nViSCvBLBWDPvPMDxwF/F0CPqtTyeoNaRigSuAqQ54zvZ0jcVatmXk4gYrM0g8vyUhTJEYasCUNs1awQnuvnN0bafwXBpJ7/hmFftdpiIyRMpw8lMZDz/GfS6tNXHW33iy0FWshBuvRNUWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgM0n7bx7mX2bOH5xZQeSsZw/5XgFzwTOSPUE4ry4AA=;
 b=YlHhBQLxEb7jTqudBibRxW4nwCrFgTzPI3KKdAxqumCp+PWeErZAxi+eyTCsffGNxNRVo3FnerljTlgxLE+i9zTv6GbJPz9XEGYH+CvW5VswfvC3UMKzGh5nPpsS6giopqV2H9F0xut1mPEClhxg+G6lb71rdLIIiv1LpiFHITNknxr/X/E0VJyHjKuyaVOlaDsSM9bbExM9u1qsrquSSSMmzXUQgxlQsIE6awzZo2NsDe8nU/EFKOVplS6vY4fzCM0vXmLMR+LN/OfoHB1e8KXKt0tuD5xWojip0Qi+3G20emybfqENjQkXApLCW3Mrf4BvgQ8sXQ3L2gE8VAOs2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgM0n7bx7mX2bOH5xZQeSsZw/5XgFzwTOSPUE4ry4AA=;
 b=nnuCNm66nxU5noVitxHSC9BvSiXY8G7L2Y2kVBTkW3wJk8BKfJNQxCTF5eUQKmhX30x4ZzTDhQkuD1dMbUZJpQELxFReZo8t+ZZW+uqSwGQriywoyjbdZpl04wHt2ncLcQkkMhPXD5mWQvpg94Z/wQ4HWtRh3UOOx3pq3Wtq22o=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by BYAPR05MB5528.namprd05.prod.outlook.com (2603:10b6:a03:75::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.10; Wed, 24 Jun
 2020 17:28:03 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f%4]) with mapi id 15.20.3131.017; Wed, 24 Jun 2020
 17:28:03 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Thomas Huth <thuth@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH] x86: Initialize segment selectors
Thread-Topic: [kvm-unit-tests PATCH] x86: Initialize segment selectors
Thread-Index: AQHWSTpzP3iSwZGVVEurZMREhdkMqqjnuhAAgAAV2QCAADdBAA==
Date:   Wed, 24 Jun 2020 17:28:02 +0000
Message-ID: <3A313913-BDFC-496B-8F44-4760333E306C@vmware.com>
References: <20200623084132.36213-1-namit@vmware.com>
 <40203296-7f31-16c7-bebb-e1f1cd478a19@redhat.com>
 <a9956a6f-5049-af9f-4e26-e37eb26e19c6@redhat.com>
In-Reply-To: <a9956a6f-5049-af9f-4e26-e37eb26e19c6@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4700:9b2:55dc:2130:bbc8:d35e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2347009-bdcf-429f-7753-08d81863f313
x-ms-traffictypediagnostic: BYAPR05MB5528:
x-microsoft-antispam-prvs: <BYAPR05MB552848E5783B6A3BC785B5C8D0950@BYAPR05MB5528.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-forefront-prvs: 0444EB1997
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n+a2AHB7qxk71Mfoz8MHLCvErfRVkalSSvU9i0LvTXpKvRkG5HDbJ/8zfsRggWGE/acuVxRu3UTf85NlPRlRaQWJFsvYIdFSe7VdpUgpNrWEfI7495veYtpeKAaOqM0GZNz25RvB6zV7CcjFGBjEr3c3Ynnze5f3LINXTNI4+4PELbtBAB4/FLkIDB2UyfmyLqLcclcChN3Bizq05ZxLBttuLClEvZHEef1LK8NRcvtDieT05DsHL/1X1lcfMLcrrwHnYyTu125OF1esrlcBUQ9hNebho1gem3yLYCSymHX7QiWxp0bWHT8Eq2wmOwfJctGbOi4KCO4GRNQlIBMxH2NZ0ovF8FnSxuW5T5cqCWl1XODV1Z8f7Zo/5IyHieBWAatihHNEPgrFOF2wMZGPdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(8936002)(966005)(53546011)(66476007)(478600001)(2906002)(71200400001)(8676002)(33656002)(76116006)(186003)(36756003)(4326008)(6486002)(66946007)(86362001)(54906003)(6916009)(5660300002)(316002)(6506007)(6512007)(2616005)(66446008)(64756008)(66556008)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: sm5C5kn6rZMM1wOIb/5c/dOZPqO4TO58wjWizTht4k5Rtw2RGCAPQ7SikAxIBB0hUnFn/FiQ0XllmdF9DhcaMk3xSwgfmrQlg8if70sH0MPRtfHagxWjA2sB5qUWHO01JqM7+iLebivPPT0XHABkMjAS8+7FH3gzVMyIBHMzERKeHq8LDBHDgvXlEWzT45E4dCRBuPkS25MFqLPkSXWZAQt1tZRdDUdCAjD31H+oCcbXY7Soy8x2ra8K6N9usFlCwTH0vi1sIU0iTMgRXIwiEjYd7j5DkRb8hlzlQ2FVheFGeOKuNmjGg+5Ru9UIPi78fAYUp/HmK2RJnR1WEWWPMt7oCeiUwoMhQrBeBudgayP6zuRKmApWgBkjfCrZfRnWV5TC8OGL4ciHKjxVsxQ66FN+2USMy/2DdYiGFTeyeKRQZG1lkSZRHXa1FbACrcJ3LwlgC2ITkpIeypebikRLpK187mBHjvR3xn1sS7XB6Hhzvf3lyCDwcqOmiP1m09+L1cOh+68azUn6ACJ655i0AM8HNiZI9idjaL8AkjxgXn4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E6EEDB280E1BBA4B99325445048F86AA@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2347009-bdcf-429f-7753-08d81863f313
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2020 17:28:02.9534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tu4E/yllcMal6Y7RiFtp62JuDudAGoNB0o5uvzQjNLZDZTcr0eoe0z5uQfcbIAadMhGYeEaq/TXSi+Hi9vybdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5528
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 24, 2020, at 7:10 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 24/06/20 14:52, Thomas Huth wrote:
>> On 23/06/2020 10.41, Nadav Amit wrote:
>>> Currently, the BSP's segment selectors are not initialized in 32-bit
>>> (cstart.S). As a result the tests implicitly rely on the segment
>>> selector values that are set by the BIOS. If this assumption is not
>>> kept, the task-switch test fails.
>>>=20
>>> Fix it by initializing them.
>>>=20
>>> Signed-off-by: Nadav Amit <namit@vmware.com>
>>> ---
>>>   x86/cstart.S | 17 +++++++++++------
>>>   1 file changed, 11 insertions(+), 6 deletions(-)
>>=20
>> I'm sorry to be the bearer of bad news again, but this commit broke
>> another set of tests in the Travis CI:
>>=20
>>  https://travis-ci.com/github/huth/kvm-unit-tests/jobs/353103187#L796
>>=20
>> smptest, smptest3, kvmclock_test, hyperv_synic and hyperv_stimer are
>> failing now in the 32-bit kvm-unit-tests :-(
>=20
> And that's just bad testing (both Nadav's and mine).  Writing to %gs
> clobbers the PERCPU area.  The fix is as simple as this:
>=20
> diff --git a/x86/cstart.S b/x86/cstart.S
> index 5ad70b5..77dc34d 100644
> --- a/x86/cstart.S
> +++ b/x86/cstart.S
> @@ -106,6 +106,7 @@ MSR_GS_BASE =3D 0xc0000101
> .globl start
> start:
>         mov $stacktop, %esp
> +        setup_segments
>         push %ebx
>         call setup_multiboot
>         call setup_libcflat
> @@ -118,7 +119,6 @@ start:
>=20
> prepare_32:
>         lgdtl gdt32_descr
> -	setup_segments
>=20
> 	mov %cr4, %eax
> 	bts $4, %eax  // pse

Unfortunately this change does not work for me (i.e., it breaks the
task-switch test on my setup). Admittedly, my patch was wrong.

I actually did not notice this scheme of having the GS descriptor and
GS-base out of sync. It seems very fragile, specifically when you have a
task-switch that reloads the GS and overwrites the original value.

I will try to investigate it further later.
