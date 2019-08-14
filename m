Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0958CAA6
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 07:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfHNFbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 01:31:01 -0400
Received: from mail-eopbgr00086.outbound.protection.outlook.com ([40.107.0.86]:16878
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727151AbfHNFbB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 01:31:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aH5KcvWA9T4sjRdx+PFH0eRPRbCMKHEo+5P8eZPmi59kJiTt9WkF3kKmm1UCUg4+S/Y1eYzhsej2pK3Q3lhEqZbgRbPLu1Rgm0W8zjKlopgKZUR7rxD8dN7eCQuIywVuXAdJFSOFH7vwa6lsBL2b7aBr029zmtVzEJ2AJG6Fyr+sx4DXLGj4bjVoCqdnwVzmNqEiOps6OKCuMjDzfGEKAD6uAZIQnwt09ewthVkp66AZTZbS6wnFhR+9QBTzlkcDZcrGl6R1Cv7KC09hwU8j+FX/5sn+Sf7xU1npq3c8d3jKBIewhR1pHo6XXftC66in1Bt+HGjE3r48zll/wWry3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joO4mFfTJfJLRxTHR9EbgCoQU22O8xSTHwPo2WHLdkE=;
 b=YARxAbxaWU5rWNRckHyiHne1H2McPQ5CMY8S9Hu6HHNg6ZdZ3DWClBEEBdGUOVgK2nHebr5Y1xXwcKwtR/OyOa40hXd2+N91tvFZ39bl64U6l+vb6nEAlflEyQCE9jzAb1P0JYEsjNW++ARhUaaAnUr10OZdAAuoiwBbI9uaF+S/SWBfNR8vgj3Kr9i5rJKbZwFbg8u20MWRFwenKpk1+7gI+uDSLNRREzAlf+ks+0AdFO0gbNssc+TOojMLlEBVh6EHpsYJCMM4/PGU9VRn6EdqWtWh7WWVL+pWF+WzvW8oEpUoGfXDjQ4STfIr0dNWj/ydvbuiRBr1jiwhCjFUlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joO4mFfTJfJLRxTHR9EbgCoQU22O8xSTHwPo2WHLdkE=;
 b=Bn8tNFHAfBOXm5z3K6lMrMhAOJ7JFIiQ5ofR4QC9sVZhNcXj/kFjs3q7yRWvywVAVcxoky3jFWHZyvUlfSBYNqmibXe1KPVabGPQcO7Ea+YX14KqK2334IqQz+E5gbt8hwJty83K70gJoX09v61MNw3iZNP41ZQuZHqrpPZZIxs=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4372.eurprd05.prod.outlook.com (52.134.124.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Wed, 14 Aug 2019 05:30:57 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 05:30:57 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@infradead.org>
CC:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Topic: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAAIWOAgAARmQCAAMQW8A==
Date:   Wed, 14 Aug 2019 05:30:57 +0000
Message-ID: <AM0PR05MB48663ADDB6D58CDA42DA6F6ED1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
 <20190808141255.45236-1-parav@mellanox.com> <20190808170247.1fc2c4c4@x1.home>
 <77ffb1f8-e050-fdf5-e306-0a81614f7a88@nvidia.com>
 <AM0PR05MB4866993536C0C8ACEA2F92DBD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190813163721.GA22640@infradead.org> <20190813174020.GC470@kroah.com>
In-Reply-To: <20190813174020.GC470@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41e95783-6287-436b-c0a0-08d720789596
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4372;
x-ms-traffictypediagnostic: AM0PR05MB4372:
x-microsoft-antispam-prvs: <AM0PR05MB43722933230E59435231BE30D1AD0@AM0PR05MB4372.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(51914003)(13464003)(199004)(189003)(71200400001)(99286004)(9456002)(71190400001)(3846002)(6116002)(6246003)(66066001)(74316002)(6436002)(305945005)(229853002)(11346002)(25786009)(256004)(486006)(478600001)(476003)(446003)(4326008)(76116006)(66946007)(33656002)(66446008)(64756008)(66556008)(66476007)(81166006)(81156014)(5660300002)(110136005)(26005)(52536014)(55236004)(53546011)(8936002)(316002)(76176011)(7696005)(54906003)(53936002)(55016002)(8676002)(7736002)(2906002)(102836004)(186003)(14454004)(6506007)(9686003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4372;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2pgig9xzjYsBEbzOJYQn/2sq8LUVSxxhvMQsYwFKYCl3ynW24islg3ttcUVxIL6o8L03UQJSdQBAK6cM4DxvhEyJ2b95ID+8cBrHYOm4bHaWlZ9oxl/Pulgeb+3YzCejCfqQxojvNsNi/tqJn4sT8S1nq3XLRVmAGjVmjR2wXDu60TOSvASYca7li0Ytp76HQmzoHElIOmyPDGk/cOh0p++Wng7zaDIloni4B4KicVEtABUUiryWZ+ryfm0+QO/lLeguN26MG6XjiA4bP3NWF91B2iA6CGu6jXOCrSgLjDWJc5jvj/aTU8vjttLcVVeOMynVVwOyZ/GCpZJe5evLUa2WsGI6tpK8ZnBxvgkq5qNPvgbgoBte7qzNSEDzYwSYd4fYFtDxBNc+frr/1ek56s6c2a3SxLEl9MiSGwWG8Cg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41e95783-6287-436b-c0a0-08d720789596
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 05:30:57.3124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jocvH181Ctjm/Nuth+tLUZlLDXRQd7nxagIhbpAMK+RAI6XtU+G9TYdHyzHeWLTDnn5dTkEIdGJAj+PTyfRpMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4372
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Christoph, Greg,

> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Tuesday, August 13, 2019 11:10 PM
> To: Christoph Hellwig <hch@infradead.org>; Parav Pandit
> <parav@mellanox.com>
> Cc: Kirti Wankhede <kwankhede@nvidia.com>; Alex Williamson
> <alex.williamson@redhat.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; cohuck@redhat.com; cjia@nvidia.com
> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
> On Tue, Aug 13, 2019 at 09:37:21AM -0700, Christoph Hellwig wrote:
> > On Tue, Aug 13, 2019 at 02:40:02PM +0000, Parav Pandit wrote:
> > > We need to ask Greg or Linus on the kernel policy on whether an API s=
hould
> exist without in-kernel driver.
>=20
> I "love" it when people try to ask a question of me and they don't actual=
ly cc:
> me.  That means they really do not want the answer (or they already know =
it...)
> Thanks Christoph for adding me here.
>=20
I pretty much knew your answer and I was just hinting Kirti that if you ask=
 Greg you would get the same answer.
So we better cleanup without reaching out to you. :-)

> The policy is that the api should not exist at all, everyone knows this, =
why is this
> even a question?
>=20
Yes, I am aware of this. Few subsystems in which I worked, it has followed =
this policy cautiously.
But when I heard different policy for mdev, I asked others wisdom.

> > > We don't add such API in netdev, rdma and possibly other subsystem.
> > > Where can we find this mdev driver in-tree?
> >
> > The clear policy is that we don't keep such symbols around.  Been
> > there done that only recently again.
>=20
> Agreed.  If anyone knows of anything else that isn't being used, we will =
be glad
> to free up the space by cleaning it up.
>=20
Ok. so this small patchset makes sense.
Thanks for the ack and direction Christoph, Greg.
