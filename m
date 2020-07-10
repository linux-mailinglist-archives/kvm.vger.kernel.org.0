Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A3A21C0CD
	for <lists+kvm@lfdr.de>; Sat, 11 Jul 2020 01:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgGJXgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 19:36:00 -0400
Received: from mail-dm6nam11on2046.outbound.protection.outlook.com ([40.107.223.46]:47457
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726328AbgGJXgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 19:36:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+ra4oGK0EwxrSivO32JXQiWzUNZ9zP63cepwo93Fp5M10zYT0Ks2u9VViXWc0Tv6OcfnqoaQHyAx5JSd4l5D8Fm4awVG9eca2EhBur2AbOW9qDIrTW3b2cCcwwbMIgFUazO3EzQpBNUJoUTohjlDvtnKDa6JzG92VbBISWDbriSj8AbeA3bWlnZfYzSoS2vCH5buEYRLufk/aMNYdcU4PWolh24wayfglYM8fZkjZUKFM5ZQbGHZqYpp+kpNSIUtTUwlj2ZMIFiEv4rlqRTZ4BhLkjvkWpJgJ74dVoDJ1Kp2kn2O5N+wFqcjfOOScrRjbKsPnOYxR0EHRn/XzInlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wu5s8bDr0pwy+NncqHRhFkJDYVVjeNJL9rZFSQdlR2I=;
 b=JNl8Coeok2ph0z/5oxo1jz4Jp5ahrvogGFi+kfJysNn/ynyCm6dP/DoZt/fhtJF97y/POjZHNdSdP0FcAcW3Mks6zpDmhzqaND+GKvkwAhev62PZ2qZi32fnx5X4qJV4jHsLkfC+AzEsW81GIHyLqxiPHyfIX2RRsT26FQePmF26KTXTauZ5Fb5SeGvQWb4Oc7wnuncDsUTowslOeNUnPas2ak5cS41QQ+GtxkJ5XZusgru1TrpS5/rpVxOeURavFHoIe+VIhoXsx7ECerHYCc9ORTo8AvZx1FpknMVfFBU4c3dwbwO/4zzmhdpDNA7xP1VCaVWgTXL4I9W52xHmYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wu5s8bDr0pwy+NncqHRhFkJDYVVjeNJL9rZFSQdlR2I=;
 b=HqB47EC47qovOtF3tDdJV3pX1A2jlw9LFL1cqZztUvfV7Z9hWoNr6Axv7wAwuWHk28eEi6Ee6NQ1k88rUcZqRKkmL/nUhIB6kc5YKwzaYy2l3OZnk2sWmgkvkKWuHftR3foZhUbtm0T/jHDUqcr7MVbEZLPlKBfjdCWRc9S0odk=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by BYAPR05MB5512.namprd05.prod.outlook.com (2603:10b6:a03:1d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8; Fri, 10 Jul
 2020 23:35:57 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f%4]) with mapi id 15.20.3195.009; Fri, 10 Jul 2020
 23:35:57 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     kvm <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 4/4] x86: Allow to limit maximum RAM
 address
Thread-Topic: [kvm-unit-tests PATCH 4/4] x86: Allow to limit maximum RAM
 address
Thread-Index: AQHWVujuqjvx/Xdif0211QRqEBXQ6KkBd+UA
Date:   Fri, 10 Jul 2020 23:35:57 +0000
Message-ID: <818B848C-9D69-42C7-AC69-CDC73F9A29FD@vmware.com>
References: <20200710183320.27266-1-namit@vmware.com>
 <20200710183320.27266-5-namit@vmware.com>
In-Reply-To: <20200710183320.27266-5-namit@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4700:9b2:48f0:f214:d1f2:ad5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d21abe32-810a-46af-665d-08d82529ff05
x-ms-traffictypediagnostic: BYAPR05MB5512:
x-microsoft-antispam-prvs: <BYAPR05MB5512A84F87FA5149E5EB6393D0650@BYAPR05MB5512.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r/V//YFBh+fYNMD3k/MH9H7Dhs1tn7RdCR6Q4fnTano2qpbA8dklz03CSlM/3KnENhMR5zKc/FeOSeROPB7mYXqCuw0oTE+u4hsjyTPsMyZHBa2zrOyCsxgIOcKmShRyl5k4KwOWn7+GALddxZHT3EBrDwoqVF3T9BpnPmBvPdnzBaX/9xyPBVRO11tC+z9QSOnDWkncAKPkkwmRDr7zhw7oNq31n8+e5LW0Af/DgZeplhW72aFJZdL3WW5pV2AzUs5S2WkZ7M7PZaOqTGD6T9wHVcKWM0nMeM1GW7ehTGEOfyqsSSIFqAMW25zmLtwEHxTyL4BUp/ogSBvOEhfoYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(376002)(346002)(39860400002)(396003)(478600001)(76116006)(316002)(53546011)(6506007)(33656002)(66946007)(66476007)(6486002)(64756008)(83380400001)(66556008)(186003)(2616005)(66446008)(4744005)(6512007)(71200400001)(5660300002)(8676002)(86362001)(8936002)(36756003)(6916009)(2906002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Eta3lUntPn3Cw1AOEjMtYH9b9IHjVJ018tLpvFn+LDBpweUEBuwAH4rZHtyJEV6ULknIgDf5C25IKL2eit6zoWpvuDW8goo7MuqfTUwj1JoL3qRp45EIBxjsKswXQZJTSyLBiOm+mKnTE9GHs8JCsVrxvvoxrBm6DN/4d+wZG4IpsdGCvHYqXfXWXBGjj3qN72d2LexVYAighTNPscsOgQD0716PqXobUREM6bjzIN5Q2WPDTH5XNKyN7z5DzEmyYlCMbWlZ42LhyR6BngBQRB/Hf2WWmLaAWRw5LPMm3WYzSXjyAsYGyD5M6XFFnIcuAdoN2FWOCYqSQvhTGXapxjO/moJmqIad+/03dgqbIQuDqA4F3C5bseouVDEscU0LhmncYOAzboXZrL2J4HOJ5qhNlAxRxZtOj8jvXxsVw2reV1S8uVjOuXmaoCbXdTCpTQD8IK53o4cKZMHV21n+l3XN57yJgTIJ2JI7DweSXQyBKHg0gdTOCE1FrQdWFAn7zqLvfVKlxwhS17retrQx8morBLWVzJiY0TMFzYnqoPA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <088FFFD4C378FF40B28A211E81358EDC@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d21abe32-810a-46af-665d-08d82529ff05
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2020 23:35:57.3157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x0Uep2taUvob7+vP30UT/jbmJxmwn0OesXdl3RhbB9pUsoZQHftajbq2SqaV05ZUmoGLVzD/a7bxbWJL8VfdmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5512
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 10, 2020, at 11:33 AM, Nadav Amit <namit@vmware.com> wrote:
>=20
> While there is a feature to limit RAM memory, we should also be able to
> limit the maximum RAM address. Specifically, svm can only work when the
> maximum RAM address is lower than 4G, as it does not map the rest of the
> memory into the NPT.
>=20
> Allow to do so using the firmware, when in fact the expected use-case is
> to provide this infomation on bare-metal using the MEMLIMIT parameter in
> initrd.

Sorry for my clumsiness/laziness in rechecking. This patch was broken. I
will send an update soon.

Anyhow, the latest SVM tests pass as well (excluding this screw-up of mine)=
.
