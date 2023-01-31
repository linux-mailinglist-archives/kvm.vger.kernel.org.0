Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E063682461
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 07:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjAaGR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 01:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjAaGRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 01:17:54 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD1C30E9
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 22:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675145873; x=1706681873;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XP6SNp3sX4JyHLCJSBNUV/q2aPzVGsyBpFwu4MJE7Hc=;
  b=aVUCxgvyeQnRJPCs9OsQp2LRr+/t29G3/IqjUhdG94fzP+BgIB19+iSG
   NQh5ZDaA/byRXmGE+VoNr6XLGMXJiqlQ4nSKuQlaWJqIy09nprIzQXV/c
   iqjjKtDfUcm1kThWDvpW8tcx+wKk+quv7bREsDMyZcMK4Mp5bI/CD7ElG
   E7NvsgGHG36Vv/qvPrR6QXn+Vo8rrclwGo5ujNTC/BNJG276oDC3FCCV5
   3cFs+JA6+VcDqo4I9E4pNhg70htsK2y5fLqKDZdkH6taY4DK4Q48beg5B
   CpQM7SxNPtXaEAKbhREb1ktgD/CP/BuOZXzlVMhRzrogi2TX6a89aXJUf
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="329869612"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="329869612"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 22:17:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="666368058"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="666368058"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jan 2023 22:17:52 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 22:17:51 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 22:17:51 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 22:17:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bQCYgAYlSQaCytNB8QqNzAyIigd78VPPUtUZ4qX8WPB/bpIV7S/1aLoJc7DJLhuKQYfvtkD3NrwBltuNrf82EKHCZ8AqVAnqVILQhi8+FAWi/b7+TdjBemHpceDMJsMKbCvZVyPlcyh4N8CCw+x0J9W3We6+TT+CiyNBtRCCtLcyRa48JOfGfmphJgOauhC9mrMhaNJGWka4mrZr4DWOY0RjLGPQAkg45diexcaxHW2qWAGi4M1KPZzgapoqwyIss7KnCwcilGR1w1VLxLdgWpMMLm3cb3GcCfNl7ktkIifZD0r9EFsBzACz0MATIiG6rH7bkANThvzp5Hkqts7mgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gpfUvX14dOVHqCBJV7Ix43NItB2ZM68JrPYeo+6jTGc=;
 b=IkadasJEuq5PX+j6lv950uJ1r425yj9i05Ib5g4VVRxRKIPek24Sbol4jYEysoqPurBDtwF00xlL7lBBhappdi97cOm11WH00mNmI2qkDygXea5dgPHqg8DhqOSsG4xdoIlgMZ4m/pRww8ACC8mhvM9bCrrQRSTvfiIY6FRTKW6QTwecm1OiZWJn1p+8+dkFCnVYMgLNKlMo0/AqvHjJuHx6xZTTyp5SX1wvT+unALPmQhE2FyxdbY25Lx3U++hS65J0OJOi7J9j6DKvP4kBEvuE/Hykcw3jCYsoD3+jlTrU0P/coMvp3G/krldOBqPfakB1UZlGJjTXbfsCjMV52g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS7PR11MB6038.namprd11.prod.outlook.com (2603:10b6:8:75::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.38; Tue, 31 Jan 2023 06:17:43 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6043.036; Tue, 31 Jan 2023
 06:17:43 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "Martins, Joao" <joao.m.martins@oracle.com>
Subject: RE: [PATCH 11/13] vfio: Add cdev for vfio_device
Thread-Topic: [PATCH 11/13] vfio: Add cdev for vfio_device
Thread-Index: AQHZKnqaai01Bzm81E2l807K45qc1a6m7C+AgBE1TKA=
Date:   Tue, 31 Jan 2023 06:17:43 +0000
Message-ID: <DS0PR11MB752907425E7A33271307B92CC3D09@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-12-yi.l.liu@intel.com>
 <BN9PR11MB52760F47BA7B584015225EF68CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52760F47BA7B584015225EF68CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS7PR11MB6038:EE_
x-ms-office365-filtering-correlation-id: 0ee2a35b-1792-4cf2-8b43-08db0352dd1d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oUh+LCj3s+Z3X8aUSEDDREvpdS4qBbAp1T9Z1JHDSyIK7157Exqct5pc1JJRCaWS78PKer5rKQF3ZC0wNrs6Rt8scpaePOJNfTPmZWA5iPacWerXSpvWRfp+3d1Zw7a2g0iodjY8DoY7XKQBg8H7Fw7uuUM/aPX0cpjIOZAETcy8w4HW9ayzBd3uY+SFoU+Mmexclc45NBwvBltPfjchBydlVmCbgt9I3DZ36/1JN5iPskQexSyQTmfmt85qYYttxUATPBMgi/b3nbFuHZIEg7DDYjaji81iBeWnNoL5noeonv+5FR/87WLULQS73M2l/ZiFYjoH0uEEKKTKVUuZGM53QIKkByLJa00EkSdwNVqMDpQ/PJob9MSTlEXWdUjnFGXUZDYzuWITysDNv0TWJZqFhcxd1XyKxPcUBsJlRYlNqFc+V0Ii/AkfPhnJzoKVRZh48ro+Z7gW4PcDCpYQd8QDx3Omb4cMCx8fCeE3ZYwFshdMsvu6geCo5F8xrWHHlLiBfvW73KLO9E+2yxrh+50mJGmHrk2dbF0eNximrDrnpxwsE1rJaXdyWDXFiGv9HHlEqLUfChpxsatDgDmFW8d9MCLyQGlBBnM4CkyymFBq5vAXXOn6+slzozmF5ruvXPm7poMQndpO+omhK90WdEVmi1I2aRAGPMR5qt3UO3hA8asfNwsta0ekqEYgNB9rqlBIE7PvZ8AZ3nZgH1IECVHl9jPjXyBhunQhSlovUhM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(396003)(39860400002)(346002)(136003)(451199018)(6506007)(110136005)(5660300002)(7416002)(54906003)(7696005)(38070700005)(316002)(71200400001)(38100700002)(82960400001)(122000001)(9686003)(26005)(186003)(41300700001)(52536014)(8936002)(33656002)(4326008)(8676002)(55016003)(86362001)(76116006)(64756008)(66446008)(66476007)(66556008)(83380400001)(478600001)(66946007)(2906002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AYTsuKOlOO83oThYamUQPaHoWGMI06EhqQURvRxWEtTmfv9khOfCErBnDLko?=
 =?us-ascii?Q?4LKmUQlxWcswBXaNTorYKw/nR1Ir1k4fwisH0xsSabC/K56laOri4XlFAJW6?=
 =?us-ascii?Q?jPrXC6ry0O4hrJ80FQ+loXueXyDnq4DRq7G9e3M+tU44+cRuEFXSJ9cIG2oS?=
 =?us-ascii?Q?wdi9r1aUH1+Xyg4almwbSBYqyqpCHIMGaPSRwDCZ7YJm0Viz0dkIjfW7ak8n?=
 =?us-ascii?Q?2sxEYkm6ZZklzM3gT+OwyFtiyKhpeiagb/8gqooR9sapWMPwDnhS9GZ8ROtA?=
 =?us-ascii?Q?0698iJch77tyOdHAJ1ZpN2Zh0Tk0rvFCKMTTiIz96gvAOaLrsq4yHutbHP2R?=
 =?us-ascii?Q?5HEcedBK5KmGkt8TzUUoAqAu+YUIO/MG5xN17sydxL1U0kYK15SNlGAAmaOR?=
 =?us-ascii?Q?837xMmHpPYc6gpepABm9z3iHHVwGkFVFMHw03K3eHg+mOrMhf1DFyo+kQHCp?=
 =?us-ascii?Q?wHfducrXsp0GLzxEDR74TxLwgvrGJwIeRlzbPTCwPRlvuURu6VMLHk8L7oM1?=
 =?us-ascii?Q?ibfS8z+z+vJlTALU3fy6pmOwNQsl1EHP22ay8mAU/wzijKdc0rRcLNruKEos?=
 =?us-ascii?Q?P/6nN3h6BMK8H1h1NDybkaBWiTNtZe07JXEcrUEJZMD3/OuSfIgLPBiK8DLb?=
 =?us-ascii?Q?9eTnK8PZn3ELvdwUhby5p7rZ5h0wkTpW+xGW3GTJpXTl+IehwYS48S7Shtz2?=
 =?us-ascii?Q?lTe9hYVpoYxCMTTj7jDsGbtND1ebXU2bG840hB9ZPOGtlGsSnbBh7lToKJ2b?=
 =?us-ascii?Q?34SJdkh9O2ZijP/PaZressGMWeet6lgqi4Lje4j/hOyEhDsQaUcugqwRMUa5?=
 =?us-ascii?Q?w2Qa0kXwbNwA48We8tXZInk1J3GXqer69OEXLV4LE+H6sI0shw4adfLthVR5?=
 =?us-ascii?Q?uUbEyUal+aYiGv2TeY82TYlAOZQYb9HJcbj4sEM7uo7W8jm1pUkmQcWU6HqP?=
 =?us-ascii?Q?UebDkniKkk6eZneekeWD5SyjWle87RTQTB8f+k5wLXCSQGA8WAr8bdP3s5Ni?=
 =?us-ascii?Q?Q/Okmmh/k1nGVcCDalR2jeRuI6M2VOevWYRjtyW7NbEuoSNZD4D6GDGmIl0Y?=
 =?us-ascii?Q?8JYcM6W/DXP15ai0sr8tZ5JtvwKZjZyoAbbt4U0Wiqi5mSY5bO0q2h1n+R6J?=
 =?us-ascii?Q?wJG1OycNPFfDrB4mJiNKmKy1DR3o3pvAboKmEtW3EFZuK57ieHilXpZjEBlS?=
 =?us-ascii?Q?W2J6t5PpbAkejp8hVUQFaPTUE9gJ64bah1DUA64eNl4YfKRAaJ0jreT5e0Ua?=
 =?us-ascii?Q?tzpOLqBodeehm4M+I7ccw4DoQwtRAn7GP522G6n7WNty1yIt1hEAlpc4fws6?=
 =?us-ascii?Q?WfpP3uzkpPAuIWwYsMwhTDGCXyVeTRvtJwuWfM+sZ1XpkuVeIPov70gD+F6N?=
 =?us-ascii?Q?PZD4ovTW6ToDta0xAEqsKpIolvuparA2KEjob+dM3yIePl1rS9J2KpCvfU1N?=
 =?us-ascii?Q?gIrp0Q+6/k/GHlymJsteL3L9HHH/oqQeJ7ku9iqFNqQ6NSLkfkk/k/FheasY?=
 =?us-ascii?Q?kslITKq7dIwYSb6uMq5lbe0f64BCTLp+vhEDiwGC4CVQzcyur9tAZ32nIPgg?=
 =?us-ascii?Q?JtsKYVlbK9SRiUBGuYV0LmgzVPIOaeZybLmXOsuR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ee2a35b-1792-4cf2-8b43-08db0352dd1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 06:17:43.4803
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ljd+pynP2pDyPzQrPD11UGe37dMM7yRWY9dvv+xFo5MWSvkI+vCDS6r/Bd6alVP5W2uaVLQI9phPlrX5qaSxBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6038
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Friday, January 20, 2023 3:27 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Tuesday, January 17, 2023 9:50 PM
> >
> > @@ -156,7 +159,11 @@ static void vfio_device_release(struct device *dev=
)
> >  			container_of(dev, struct vfio_device, device);
> >
> >  	vfio_release_device_set(device);
> > +#if IS_ENABLED(CONFIG_IOMMUFD)
> > +	ida_free(&vfio.device_ida, MINOR(device->device.devt));
> > +#else
> >  	ida_free(&vfio.device_ida, device->index);
> > +#endif
>=20
> There are many #if in this patch, leading to bad readability.
>=20
> for this what about letting device->index always storing the minor
> value? then here it could just be:
>=20
> 	ida_free(&vfio.device_ida, device->index);

Yes.

> > @@ -232,17 +240,25 @@ static int vfio_init_device(struct vfio_device
> > *device, struct device *dev,
> >  	device->device.release =3D vfio_device_release;
> >  	device->device.class =3D vfio.device_class;
> >  	device->device.parent =3D device->dev;
> > +#if IS_ENABLED(CONFIG_IOMMUFD)
> > +	device->device.devt =3D MKDEV(MAJOR(vfio.device_devt), minor);
> > +	cdev_init(&device->cdev, &vfio_device_fops);
> > +	device->cdev.owner =3D THIS_MODULE;
> > +#else
> > +	device->index =3D minor;
> > +#endif
>=20
> Probably we can have a vfio_init_device_cdev() in iommufd.c and let
> it be empty if !CONFIG_IOMMUFD. Then here could be:

Yes. Btw. Will adding another device_cdev.c better than reusing iommufd.c?

>=20
> 	device->index =3D minor;
> 	vfio_init_device_cdev(device, vfio.device_devt, minor);
>
> > @@ -257,7 +273,12 @@ static int __vfio_register_dev(struct vfio_device
> > *device,
> >  	if (!device->dev_set)
> >  		vfio_assign_device_set(device, device);
> >
> > -	ret =3D dev_set_name(&device->device, "vfio%d", device->index);
> > +#if IS_ENABLED(CONFIG_IOMMUFD)
> > +	minor =3D MINOR(device->device.devt);
> > +#else
> > +	minor =3D device->index;
> > +#endif
>=20
> then just "minor =3D device->index"

Yes.

> >
> > +#if IS_ENABLED(CONFIG_IOMMUFD)
> > +	ret =3D cdev_device_add(&device->cdev, &device->device);
> > +#else
> >  	ret =3D device_add(&device->device);
> > +#endif
>=20
> also add a wrapper vfio_register_device_cdev() which does
> cdev_device_add() if CONFIG_IOMMUFD and device_add() otherwise.

Got it.
>=20
> > +#if IS_ENABLED(CONFIG_IOMMUFD)
> > +	/*
> > +	 * Balances device_add in register path. Putting it as the first
> > +	 * operation in unregister to prevent registration refcount from
> > +	 * incrementing per cdev open.
> > +	 */
> > +	cdev_device_del(&device->cdev, &device->device);
> > +#else
> > +	device_del(&device->device);
> > +#endif
>=20
> ditto
>=20
> > +#if IS_ENABLED(CONFIG_IOMMUFD)
> > +static int vfio_device_fops_open(struct inode *inode, struct file *fil=
ep)
> > +{
> > +	struct vfio_device *device =3D container_of(inode->i_cdev,
> > +						  struct vfio_device, cdev);
> > +	struct vfio_device_file *df;
> > +	int ret;
> > +
> > +	if (!vfio_device_try_get_registration(device))
> > +		return -ENODEV;
> > +
> > +	/*
> > +	 * device access is blocked until .open_device() is called
> > +	 * in BIND_IOMMUFD.
> > +	 */
> > +	df =3D vfio_allocate_device_file(device, true);
> > +	if (IS_ERR(df)) {
> > +		ret =3D PTR_ERR(df);
> > +		goto err_put_registration;
> > +	}
> > +
> > +	filep->private_data =3D df;
> > +
> > +	return 0;
> > +
> > +err_put_registration:
> > +	vfio_device_put_registration(device);
> > +	return ret;
> > +}
> > +#endif
>=20
> move to iommufd.c
>=20
> > +#if IS_ENABLED(CONFIG_IOMMUFD)
> > +static char *vfio_device_devnode(const struct device *dev, umode_t
> *mode)
> > +{
> > +	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
> > +}
> > +#endif
>=20
> ditto
>=20
> > @@ -1543,9 +1617,21 @@ static int __init vfio_init(void)
> >  		goto err_dev_class;
> >  	}
> >
> > +#if IS_ENABLED(CONFIG_IOMMUFD)
> > +	vfio.device_class->devnode =3D vfio_device_devnode;
> > +	ret =3D alloc_chrdev_region(&vfio.device_devt, 0,
> > +				  MINORMASK + 1, "vfio-dev");
> > +	if (ret)
> > +		goto err_alloc_dev_chrdev;
> > +#endif
>=20
> vfio_cdev_init()
>=20
> >  static void __exit vfio_cleanup(void)
> >  {
> >  	ida_destroy(&vfio.device_ida);
> > +#if IS_ENABLED(CONFIG_IOMMUFD)
> > +	unregister_chrdev_region(vfio.device_devt, MINORMASK + 1);
> > +#endif
>=20
> vfio_cdev_cleanup()

All above comments got.

Regards,
Yi Liu
