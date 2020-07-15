Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FDB22127E
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 18:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgGOQji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 12:39:38 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:47228 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725770AbgGOQjh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jul 2020 12:39:37 -0400
X-Greylist: delayed 1043 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jul 2020 12:39:36 EDT
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06FGCCUY006053;
        Wed, 15 Jul 2020 09:20:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=1pqt3bonB+dUiEEflBcOwaz4+OGuwfQZg+qPQFNCYjU=;
 b=oMpXJrAGRJ9lIUxI6zTSugIzxdwmPzvwUj2AwBc0PE84nu5tSJ9ZtdACl42LWUVpdcZz
 2+yiXJQE9c0542VoW8xRkRMbcBe9fJhprNPgN8HXNY2y37yDgqlGv5YbYLguSPz/ir4G
 a8vJu5D/PXZW2aWIP0NxtkDDyhsp5QhwCZ4FVWsv7ETaCpdDWzLjdwNL9WsKMMFYtkcc
 H1nyYI1k/czO7zeXWiHHWXF07JD4U5Ll6fRGyzVuXpDjC8pL3XLya+Cq/Usd0x7bfozd
 TRvOYFw54g4zEKn4GgbHQKKjsSIUeTxTMz8Sz9YCbn72wtd07vkuNpRvzOoeRl26OFe/ jA== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by mx0b-002c1b01.pphosted.com with ESMTP id 327bhj9hk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 09:20:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KTzTrj1xRJMXQLkpklGUopDr+xufo4tTgX+2djd62wGnUqUI0OYQdOMW0LaKp8mgOdSb+b2VK5u0ZMxIv3JftBH8qgKUyeuR1FuMW88nrGnPnCYR5zGDnufW+xqRwmHniZPleU3pqcbSIc+2bbtCsa5QZF6AT1gTr9juua08Uoxiqi+J3FxoG5GvHGpeSZ9G40CterNd6+3km3lWGoNWhgwiZCS6XNuds2iKo4juseYTQGS+n4XUI1Y2CmvtdA0Vyb3U0gjgZMfiQl546SatP6e9CwlNQ1jRZg7FkfLJHzTQyzE+q6fVe8mJhr5uTy1gdXfDoZu/bKGhkgZpnuUBdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pqt3bonB+dUiEEflBcOwaz4+OGuwfQZg+qPQFNCYjU=;
 b=d6BNGJbd/ViSTbTU/O+eFE1is9k0qvGYpiM6v28/9Vq6TTFbo1BN/c/SrfxFVI+l58kagGJdIPoreAL/SsvOQLGyUJnPz89bBI0V4LrQVyC0SnFtXspS+eh9xjT1dGednQUK+mbtbohfwfTRE2i0/9eakELjKZIcW93Q1SnCXs21W8QoCfpfKbk44wm6Ptlmc1fsKCInwVKBfcLqAZztlW5GzlyZkqWveYFgyNgtUuGXkpqECc2jIjZxrtlfj3uuH6i3l+uYHlgisUuVReKJ4lJnLJvqGn381Nqz+Fa4FZJk2jqUH0udTy1+kO+SvbV0QmkK88mzdXFR9oBFlidT0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from MW2PR02MB3723.namprd02.prod.outlook.com (2603:10b6:907:2::32)
 by MWHPR0201MB3404.namprd02.prod.outlook.com (2603:10b6:301:7d::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Wed, 15 Jul
 2020 16:20:37 +0000
Received: from MW2PR02MB3723.namprd02.prod.outlook.com
 ([fe80::41c0:3347:6d78:a869]) by MW2PR02MB3723.namprd02.prod.outlook.com
 ([fe80::41c0:3347:6d78:a869%5]) with mapi id 15.20.3174.025; Wed, 15 Jul 2020
 16:20:37 +0000
From:   Thanos Makatos <thanos.makatos@nutanix.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Nikos Dragazis <ndragazis@arrikto.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
CC:     "Michael S. Tsirkin" <mst@redhat.com>,
        "John G. Johnson" <john.g.johnson@oracle.com>,
        Andra-Irina Paraschiv <andraprs@amazon.com>,
        Alexander Graf <graf@amazon.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        =?iso-8859-1?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>,
        Felipe Franciosi <felipe@nutanix.com>,
        Swapnil Ingle <swapnil.ingle@nutanix.com>
Subject: RE: Inter-VM device emulation (call on Mon 20th July 2020)
Thread-Topic: Inter-VM device emulation (call on Mon 20th July 2020)
Thread-Index: AQHWWpp0s37rL88/sEC6+WdVwr18HakI0k+g
Date:   Wed, 15 Jul 2020 16:20:37 +0000
Message-ID: <MW2PR02MB37233BB32983D69B16BB9D648B7E0@MW2PR02MB3723.namprd02.prod.outlook.com>
References: <86d42090-f042-06a1-efba-d46d449df280@arrikto.com>
 <20200715112342.GD18817@stefanha-x1.localdomain>
In-Reply-To: <20200715112342.GD18817@stefanha-x1.localdomain>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
x-originating-ip: [92.29.225.29]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94f593b2-c32f-4deb-f15b-08d828db027e
x-ms-traffictypediagnostic: MWHPR0201MB3404:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR0201MB3404146D3DC2ADF3E1A5A68D8B7E0@MWHPR0201MB3404.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IOs2Pll/SFWysXFWtrN/+HLKicshYm21JYwpupoV+1/1VOxjq7sxVH/HDcHHeT+ffAwsb4ZTigf2mFwuYl8e+7MJXAieA9ls1quoqFY09roxeUEHmq0X13tsLEMiRupNmN5HjzuTWxIUi2blM7E75/hY4dSf70ykUstula3lA3RaV4AlKFvgfrvQbbxG+2p2pynLS4SBd13ACmFdIoRxS36rGkHor29W8EBqOR4towPM4oUAkpjrnAlxZdBCG6QSHFMkBr0FTj88+lyzVecEsrzqoTsQ/gPwFv6iT6EYTtvbeTxu5M7Sb9x8I04hXyoyWDAv8hsMC9f91RS9zCPnWPYt4CIAIKPK7ketJYKT8CYIlJGzxk02sDyvguT775xLtsm7muF5SMr6k6A8lyXAyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR02MB3723.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(5660300002)(86362001)(33656002)(83380400001)(53546011)(54906003)(55016002)(6506007)(498600001)(9686003)(110136005)(7696005)(966005)(76116006)(66476007)(66556008)(71200400001)(66446008)(26005)(64756008)(66946007)(52536014)(8676002)(7416002)(107886003)(44832011)(4326008)(186003)(2906002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 6RMMPFeJEFy1E7jZQzCr/OGCLhjJYm8jLTyMcDYk5gddsem4aVOkY1EgybEOq95HH/2WG/59Bqtwt0YDs5EtinQw/jOBK4f7rOtMOdGf9H6XtSWbbo0vvv90jtlYPT/YM8PYjHlCIGkNsABSr9ZR8NHioXDrTctpvDjDa4ltOxaEQhQZVJg5k40N6xavoJCoeaDrmrrwuOydguLvpE3vy4e21sUNiGBalvm+HPitKq8n2hjmiffglZfmMJyVy2jJkf1Ib9W1kHXttcaukaj/R/B8IEE9eYl527gpjGvrUyzm81EHBPEo5wFbLZLX3vZrVCmu8C+jF+iTlb1HseR5jggdCMxhZ/EB0TyxvUFg2KdhZVJtcZwlSrcFYhC7egUGPRI/fhFpMQSCrPT08IO7Zc8lAxO4JjQ9JhJVLgV9Hn5MxLhhCMxcY+GgNNyz05xQE+jLn0NjrXZ0jsSJDuuDTXOZkjItILf3Junmfc2gT7k=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR02MB3723.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94f593b2-c32f-4deb-f15b-08d828db027e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2020 16:20:37.4929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3SkyBBBiJwtDH/6IzPg/pyKE78sCooDYZPAbraUo3D8kZoUhTUn/RyspzoaoQG+gbFF3YCbAQtQTJhJJzhb7xrZlo3jv7uZmnEK4QEvYxW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0201MB3404
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_12:2020-07-15,2020-07-15 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On
> Behalf Of Stefan Hajnoczi
> Sent: 15 July 2020 12:24
> To: Nikos Dragazis <ndragazis@arrikto.com>; Jan Kiszka
> <jan.kiszka@siemens.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>; Thanos Makatos
> <thanos.makatos@nutanix.com>; John G. Johnson
> <john.g.johnson@oracle.com>; Andra-Irina Paraschiv
> <andraprs@amazon.com>; Alexander Graf <graf@amazon.com>; qemu-
> devel@nongnu.org; kvm@vger.kernel.org; Maxime Coquelin
> <maxime.coquelin@redhat.com>; Alex Benn=E9e <alex.bennee@linaro.org>
> Subject: Inter-VM device emulation (call on Mon 20th July 2020)
>=20
> Hi,
> Several projects are underway to create an inter-VM device emulation
> interface:
>=20
>  * ivshmem v2
>    https://www.mail-archive.com/qemu-devel@nongnu.org/msg706465.html
>=20
>    A PCI device that provides shared-memory communication between VMs.
>    This device already exists but is limited in its current form. The
>    "v2" project updates IVSHMEM's capabilities and makes it suitable as
>    a VIRTIO transport.
>=20
>    Jan Kiszka is working on this and has posted specs for review.
>=20
>  * virtio-vhost-user
>    https://www.mail-archive.com/virtio-dev@lists.oasis-
> open.org/msg06429.html
>=20
>    A VIRTIO device that transports the vhost-user protocol. Allows
>    vhost-user device emulation to be implemented by another VM.
>=20
>    Nikos Dragazis is working on this with QEMU, DPDK, and VIRTIO patches
>    posted.
>=20
>  * VFIO-over-socket
>    https://github.com/tmakatos/qemu/blob/master/docs/devel/vfio-over-
> socket.rst
>=20
>    Similar to the vhost-user protocol in spirit but for any PCI device.
>    Uses the Linux VFIO ioctl API as the protocol instead of vhost.
>=20
>    It doesn't have a virtio-vhost-user equivalent yet, but the same
>    approach could be applied to VFIO-over-socket too.
>=20
>    Thanos Makatos and John G. Johnson are working on this. The draft
>    spec is available.
>=20
> Let's have a call to figure out:
>=20
> 1. What is unique about these approaches and how do they overlap?
> 2. Can we focus development and code review efforts to get something
>    merged sooner?
>=20
> Jan and Nikos: do you have time to join on Monday, 20th of July at 15:00
> UTC?
> https://www.timeanddate.com/worldclock/fixedtime.html?iso=3D20200720T1
> 500
>=20
> Video call URL: https://bluejeans.com/240406010
>=20
> It would be nice if Thanos and/or JJ could join the call too. Others
> welcome too (feel free to forward this email)!

Sure!

>=20
> Stefan
