Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F31242B1C7
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 03:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235294AbhJMBJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 21:09:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:6644 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234321AbhJMBJ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 21:09:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="250725337"
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="250725337"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 18:07:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="524432285"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga001.jf.intel.com with ESMTP; 12 Oct 2021 18:07:23 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 12 Oct 2021 18:07:23 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 12 Oct 2021 18:07:22 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 12 Oct 2021 18:07:22 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 12 Oct 2021 18:07:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGU7DV41AhwfyeU6kR9wCJgn2rO1+mnNCmWo2fZfMJbCdcWCLi5Mc3W2nXHH65ZAiYNrUNsAdPP5aHopqeWgCGj/iOZ3elMxdX+MB7tYhnB1BnTAH0StvjPFMn/+mStmvQoQ6PKURfU9ifvtaBcoJ+sjajrpf4DwJaXnZ6WDtM5iX0Jgsrzn9M8eD4vTWDqTvVQ8Vo4zYhq4Uce53xutY7E2HXxWd2qsAVSL1gs7hwACfQt52Sdo97TfXaVbuOZ/LiDtnuAz/3iIHreojX2bKWBUARWMtw04/RMdj2zDmzV8JuQm8Fqriae6mUr3cUUBCKCmjRZRqLoDu55tFuOT6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjRqK7/cLs3npvCoCnj13hd6jH7343WWRRHYquWV2DQ=;
 b=ikSvCCsGUuSKseXtDuuwyBaF3CgvPP2Km5nhRmFdsMBH2oX041b8FsAhkadBO5iBsFmiIRdrMrA39cbFi+UHv4mCWKx5nCo751R0QlnlHZQx28IbwgqEdnSpz2Jv4Ld62j1+pG11hnAsTsa6Eptv5ZrjbVqm0D3QbH7DfDQ+RScIe5mpUFC0ZjEmiVBJ+AA8U32xdFDIpx5OPy4iBaoYjo8FUJu4Ho4Haq4SdNejDOIAt00INCIE8XUva6FjwWno/bX0EdPDLpf9ZjjDeV0ped+wO7w+3P7iBpjox1EHDW76xIsCXX/I0oWXm4n+tqYipHmfSfyWjj1JI4ucgrhSVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjRqK7/cLs3npvCoCnj13hd6jH7343WWRRHYquWV2DQ=;
 b=nQrayXrB7kl38jDuwM5w9+Z/5bwhvxSWrxk3qYQqQPKaj30oOhQAj1qNUNIvLXpMJTeHmJTvJ3+a3P7+7QjrEKHVRrPzYBYaVbOkb6Drpotsca7w1NqaofJtM3jZ2EE5KjH7yXPgatClA09R+pa2Bw84zLPgo4nbNTX7FKj9r2w=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN8PR11MB3844.namprd11.prod.outlook.com (2603:10b6:408:91::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Wed, 13 Oct
 2021 01:07:20 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%9]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 01:07:20 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christoph Hellwig" <hch@lst.de>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 5/5] vfio: Use cdev_device_add() instead of
 device_create()
Thread-Topic: [PATCH 5/5] vfio: Use cdev_device_add() instead of
 device_create()
Thread-Index: AQHXtxtagArROLssOEyJXJeP9bkSmKvPF1aQgAA9PICAANhEAA==
Date:   Wed, 13 Oct 2021 01:07:20 +0000
Message-ID: <BN9PR11MB5433F98E5D2A3642F86116778CB79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <5-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <BN9PR11MB5433538884DA4EB3B5BF89628CB69@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20211012120505.GT2744544@nvidia.com>
In-Reply-To: <20211012120505.GT2744544@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ca93b29-c461-425b-77ec-08d98de5ce7f
x-ms-traffictypediagnostic: BN8PR11MB3844:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3844568657793176DD2B29CB8CB79@BN8PR11MB3844.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G8uuinfAPKOEB1Yz7rNT/NUUXXDr2+XW8pFY6CMzbjPBVzzInixVZE5SgZv9aq1DoWqZvu27ZyEboSa5c2wx1AbISH9m0oGPonvTfVCXqgqUUqXlRzlk5IZlH9TrH35vTEEGhBFOBoti5u6xUjIXA77jQ5kLD8MN8Zq6Ex40R5+3/nliPkFfArPlllQZg2IMSgG/LUp3jgIg8bqQ4KRnFXy3dldWKm4xuHomIzzplGu23qmbSjf2a+H3dbsVkWMh6GpJ/BS8N55GML7jZUAMUlB6oimNiDCyos/l/qHMb5eifaOPdVCr865Fiom4xW9iTJ8jHGqYdXmVxMlg/DFzyIJw1z/N58S3ZZH81A1Dzu2UEeDg25eyyRfi7BicMUu6cH5wYSWQx+s76QhO2iPFk98zSw15DoN7IWSY4pjAtyLM2Dm4PZPoeRPi1TTqIDvnJsR1LA1qZzq7noTX9yYxHZYj8t5/Nz8HN9CZ0m/I53ThZhMx3NsiGd/Ju/mpqJ04GQxKw99DMn6WB9sdn+a3X0gV96fkizluqGOQ8nbmdUbnYJnCHadR0x3PAlvgqxIZT7NgjWND7oxSzeqPl6fmw+S0gwjrs90j0r0Pw6f7AGXFDVIzadMHhuCy9vy/j/cTRkivRQ7D9sGmiH1EilsrgD+IodxtYl9jvZFKQZuv8JoG33WCm6nMY7KJ0zzs4+/t5pVUVOoVg/e4+9yDgjSdRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(66556008)(107886003)(66446008)(5660300002)(52536014)(66476007)(66946007)(508600001)(186003)(2906002)(38100700002)(6916009)(6506007)(122000001)(71200400001)(7696005)(4326008)(83380400001)(26005)(64756008)(86362001)(54906003)(82960400001)(33656002)(38070700005)(9686003)(8676002)(76116006)(8936002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vvYqPv1TVY34ply5jOztgRA5qWADpdWNsb1t5OKvibaos5S7/lI/ovLpm9Td?=
 =?us-ascii?Q?2QDoBqsZlb432lJ9PtKptohJPngchIExVdZmuQZqNIAVRcy2w7V8iGo0Ci2n?=
 =?us-ascii?Q?9h3kl1s2jYkBcMvfvjIOPGVaYx+FAzXtNOB62tWfwFn2kp9OHC1d/Pe3mljL?=
 =?us-ascii?Q?P27DKKYGZfrkbIoLEEARhgQIGrz23h8V3PfJ+iicv8HCsW+KqD/FuWl498Pz?=
 =?us-ascii?Q?mKetC2/EIixUH8wUDDrnFtXB2XGXZj9CuRdmBxlxrPjWtK2HlC9ZyRdvc0Ns?=
 =?us-ascii?Q?E+CM9qbJIBAiDBp0TZKcyDGDOhJk8CBahWOKFCzRPdWeUqXeUBuJqTkPeNlu?=
 =?us-ascii?Q?xuxXZcFhKukUM2BJoA0/n87lUmMseO5HRGswXZmAVgAmnCfQ0322llxjQg4/?=
 =?us-ascii?Q?BnmLdJwkbHQKG3ub4vzG7wnlX6/yzNoiS9Imsb6d5ikvW0Em/dqWjATmWgKv?=
 =?us-ascii?Q?FNtugezGCP8Ox7dm9i3ZagHLTKOMD/CMMMpCU4wRsOyIY1GeNL25j3gLyDcp?=
 =?us-ascii?Q?MHYszWejHViTKlwBmkXaBL8dV2xlOIQ7bp8I3+EAboGGxzhqNk9xFAcmK86X?=
 =?us-ascii?Q?sVQFY1QFv3RziEsjWX89XsM2R4dIsTccieb8OQ2bVZxcEq1X/jzSn4FOYEjR?=
 =?us-ascii?Q?2aP4yGZBQIDyLVAaWc43ZRhHHp4+bLAS1FS1wxZFa/oEDoDoUjEF5cx73+mT?=
 =?us-ascii?Q?7dvTvAK0knGCTNM6LYjlbBxvPzf2nNPC6M79ffGvmCfDHKp61ymx/zEgG7fS?=
 =?us-ascii?Q?cOSTYvR3FzhxS77rOKD0FG9XL68vJtrS3XLE6mPQoAv/LLJ/FOGKEPQQ3VoG?=
 =?us-ascii?Q?f2xOT2vhMLhbvYbUArr3ePFtJfY/ld2tiJJkzou4FV589muiERdCN8pCDsCG?=
 =?us-ascii?Q?5usG4Knl6EiPdmmdxXwjh8zasp78r8aonJllBFS/8JHeojFHse7efsT+X6AF?=
 =?us-ascii?Q?5/EjZJ1eh2gD8X7CTc+/kMV09qw3KfKpzoGcA7ok1n5epucFUrNkiwHBIAP4?=
 =?us-ascii?Q?K+QOegutaNXpiDiNMwZrZeFHEiWt3h3faiR+ASy7lP/FlAHURQtG1J85D9Fr?=
 =?us-ascii?Q?14tLzERXGNIcoY7PNYJCNx6gIVEbEr1oXcLnn5rZBL1+Q0QvZF/FydOEQM6n?=
 =?us-ascii?Q?o5SJLgayJh6c3VRjg0WmiFDjn0PpSqfyH3iHQUEIdAUx6qlljWvFrbykZkZb?=
 =?us-ascii?Q?VqImmCfOpVhPl7Wt2FeDxJyScKZk4DXhzyNgHZzOg+tUniKU3VGbNL3qvfVZ?=
 =?us-ascii?Q?T7KAAI5WO5JahH+no8rAhXABTtzpgjWmy66iIxc/Qv+sFbR2TU0NNqNUO/Tn?=
 =?us-ascii?Q?yWtXc/5Oinxfn9/4xIeZ/p96?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ca93b29-c461-425b-77ec-08d98de5ce7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 01:07:20.0316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gXtYhCCzcw+e0UmZz7Ar+VUyWSyfVVxdW9cfbHblltu070s8bb+7pRXU7pQVMxyp2nRCb6l9LIpPcMbrOVw97w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3844
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, October 12, 2021 8:05 PM
>=20
> On Tue, Oct 12, 2021 at 08:33:49AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Saturday, October 2, 2021 7:22 AM
> > >
> > [...]
> >
> > > +static void vfio_group_release(struct device *dev)
> > >  {
> > > -	struct vfio_group *group, *existing_group;
> > > -	struct device *dev;
> > > -	int ret, minor;
> > > +	struct vfio_group *group =3D container_of(dev, struct vfio_group, d=
ev);
> > > +	struct vfio_unbound_dev *unbound, *tmp;
> > > +
> > > +	list_for_each_entry_safe(unbound, tmp,
> > > +				 &group->unbound_list, unbound_next) {
> > > +		list_del(&unbound->unbound_next);
> > > +		kfree(unbound);
> > > +	}
> >
> > move to vfio_group_put()? this is not paired with vfio_group_alloc()...
>=20
> Lists are tricky for pairing analysis, the vfio_group_alloc() creates
> an empty list and release restores the list to empty.

items are added to this list after vfio_create_group() (in the start of
vfio_unregister_group_dev()). So I feel it makes more sense to move
it back to empty before put_device() in vfio_group_put(). But not a
strong opinion...

>=20
> > >  static int vfio_group_fops_open(struct inode *inode, struct file *fi=
lep)
> > >  {
> > > -	struct vfio_group *group;
> > > +	struct vfio_group *group =3D
> > > +		container_of(inode->i_cdev, struct vfio_group, cdev);
> > >  	int opened;
> >
> > A curiosity question. According to cdev_device_del() any cdev already
> > open will remain with their fops callable.
>=20
> Correct
>=20
> > What prevents vfio_group from being released after cdev_device_del()
> > has been called? Is it because cdev open will hold a reference to
> > device thus put_device() will not hit zero in vfio_group_put()?
>=20
> Yes, that is right. The extra reference is hidden deep inside the FS
> code and is actually a reference on the cdev struct, which in turn
> holds a kobject parent reference on the struct device. It is
> complicated under the covers, but from an API perspective if a struct
> file exists then so does the vfio_group.
>=20

Make sense. Thanks for explanation.
