Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAFF31A525
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 20:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhBLTPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 14:15:32 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:10314 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhBLTP3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 14:15:29 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6026d3a80001>; Fri, 12 Feb 2021 11:14:48 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 19:14:48 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 19:14:45 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 12 Feb 2021 19:14:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TD9n8hbFgxLDhuAk9j+mUBRdukizZcRdjNEQW2Yz6D1bkuQBEiLpCbrBIZrD5Ok0eqadMCVR89mFHy9psuw11nLt4kmIdRfKJxloF2LeF6oQlItO19xYqZC33KGzOj/Y9dmy8lklOlGYbfYf7lk8i2Lw/qfhkYL3M+cG6yHf5N9G5Dot5b6NHjUdRBC7XLHkqL6EObjenRX7gkYX5E1RcniKYxKi56i2m5ctbqzCXEQ9sEZsrfRPDjYmyh8tA1N5XwsS8stA4coKNkUcO51aaXdVWzUaGQPy1cTYkfjEHQHNF9ujlEBspSsI7lG9r8nTOsrLTjKFDXzznXU/SspH8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QY7pI6janZHs9kpAEAxoz63NCTTjPdCoT320HyCxjgQ=;
 b=Q+W9u9zopRC9rgPE/lopx3Tb1FN0mi4ZfOOMxt5E7lD4LSR2IIb5KW/39CYhEG+dL31y6NsSJUn/46PGu89Kb/VZDa5fOr2Z4chM0yy9CWDR0moDuHCkw6Q8AA61X4WviV1NhX9RMj73bovlaRvVtColrlj5rUAIECCsrh+q0r3wnZqCxiM516UQwbV86yQyEjBpayj/DlW3nTEVJ2OdmZGV8OxSGsa5LMkpZClmZ+cj+g3C2ln2+eVSBRuOgSUEQZiYDu2Ct8qww1HncCwnso9MGEtn2Mpi+SwDaiv9GjUlIB2g2NuogmRIrM+do9tnM8rfrq1Kw2SZ3t299pGS+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2487.namprd12.prod.outlook.com (2603:10b6:4:af::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Fri, 12 Feb
 2021 19:14:43 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.030; Fri, 12 Feb 2021
 19:14:43 +0000
Date:   Fri, 12 Feb 2021 15:14:41 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
CC:     <alex.williamson@redhat.com>, <kwankhede@nvidia.com>,
        <tglx@linutronix.de>, <vkoul@kernel.org>, <megha.dey@intel.com>,
        <jacob.jun.pan@intel.com>, <ashok.raj@intel.com>,
        <yi.l.liu@intel.com>, <baolu.lu@intel.com>, <kevin.tian@intel.com>,
        <sanjay.k.kumar@intel.com>, <tony.luck@intel.com>,
        <dan.j.williams@intel.com>, <eric.auger@redhat.com>,
        <parav@mellanox.com>, <netanelg@mellanox.com>,
        <shahafs@mellanox.com>, <pbonzini@redhat.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 04/14] vfio/mdev: idxd: Add auxialary device plumbing
 for idxd mdev support
Message-ID: <20210212191441.GU4247@nvidia.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
 <161255839829.339900.16438737078488315104.stgit@djiang5-desk3.ch.intel.com>
 <20210210234639.GI4247@nvidia.com>
 <92c0e4b2-c85c-bda6-811b-8547b027d1ee@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <92c0e4b2-c85c-bda6-811b-8547b027d1ee@intel.com>
X-ClientProxiedBy: BL0PR02CA0078.namprd02.prod.outlook.com
 (2603:10b6:208:51::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0078.namprd02.prod.outlook.com (2603:10b6:208:51::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Fri, 12 Feb 2021 19:14:42 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lAdtp-007WJF-EI; Fri, 12 Feb 2021 15:14:41 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613157288; bh=W59+Xy4Yajr8FztdOXMZS49J9m3JsW1Cs+qg2tGacM4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:Content-Transfer-Encoding:In-Reply-To:
         X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=OFeSMy4U66tZFo8aUNhDVxQli3GolKZWkGDB/OI4MiTH0t9c5H2KD9F5V4wftjcPu
         mv4gxBU0Ea3PUxURpV5SCgF4/QmGaSG17yfsooODItw8ujyDXO69O7XDmamQjNVVCj
         m/Bp+E7XI+CUhpEXbWcYeIKe8ksRELXcj4NbwXYIF3zHK9jcpUdkQhygn+d4KM7+A/
         /lg0r++ABH6tu0ew9GJ4eexygwR14RFYtzIW49l3sbGHF4BVz1kBm3HzwdquYXrAQ7
         0DUY5WMopWRdpj5Sc4AIV5mLLiygfENI57IlrFqTMSPdEuFS9YqW21VPAzBGrhcZ0m
         giVoIPGF8nF8w==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 12, 2021 at 11:56:24AM -0700, Dave Jiang wrote:

> > > @@ -434,11 +502,19 @@ static int idxd_probe(struct idxd_device *idxd)
> > >   		goto err_idr_fail;
> > >   	}
> > > +	rc =3D idxd_setup_mdev_auxdev(idxd);
> > > +	if (rc < 0)
> > > +		goto err_auxdev_fail;
> > > +
> > >   	idxd->major =3D idxd_cdev_get_major(idxd);
> > >   	dev_dbg(dev, "IDXD device %d probed successfully\n", idxd->id);
> > >   	return 0;
> > > + err_auxdev_fail:
> > > +	mutex_lock(&idxd_idr_lock);
> > > +	idr_remove(&idxd_idrs[idxd->type], idxd->id);
> > > +	mutex_unlock(&idxd_idr_lock);
> > Probably wrong to order things like this..
>=20
> How should it be ordered?

The IDR is global data so some other thread could have read the IDR
and got this pointer, but now it is being torn down in some racy
way. It is best to make the store to global access be the very last
thing so you never have to try to unstore from global memory and don't
have to think about concurrency.

> > Also somehow this has a
> >=20
> > 	idxd =3D devm_kzalloc(dev, sizeof(struct idxd_device), GFP_KERNEL);
> >=20
> > but the idxd has a kref'd struct device in it:
>=20
> So the conf_dev is a struct device that let the driver do configuration o=
f
> the device and other components through sysfs. It's a child device to the
> pdev. It should have no relation to the auxdev. The confdevs for each
> component should not be released until the physical device is released. F=
or
> the mdev case, the auxdev shouldn't be released until the removal of the
> pdev as well since it is a child of the pdev also.
>=20
> pdev --- device conf_dev --- wq conf_dev
>=20
> =C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |--- engine conf_=
dev
>=20
> =C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |--- group conf_d=
ev
>=20
> =C2=A0=C2=A0=C2=A0 |--- aux_dev
>=20
> >=20
> > struct idxd_device {
> > 	enum idxd_type type;
> > 	struct device conf_dev;
> >=20
> > So that's not right either
> >=20
> > You'll need to fix the lifetime model for idxd_device before you get
> > to adding auxdevices
>=20
> Can you kindly expand on how it's suppose to look like please?

Well, you can't call kfree on memory that contains a struct device,
you have to use put_device() - so the devm_kzalloc is unconditionally
wrong. Maybe you could replace it with a devm put device action, but
it would probably be alot saner to just put the required put_device's
where they need to be in the first place.

I didn't try to work out what this was all for, but once it is sorted
out you can just embed the aux device here and chain its release to
put_device on the conf_dev and all the lifetime will work out
naturally.=20

Jason
