Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05D3697413
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 03:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjBOCFM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 21:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBOCFK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 21:05:10 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E81F2943E;
        Tue, 14 Feb 2023 18:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676426709; x=1707962709;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A7ORWepufljanCkGnptEREamrHF2y59aPvTePTn2L6Q=;
  b=ax3Z+blDER/kKdEZnZgNthgq6X6HvP+7IP7qncAfIEwEa+viCxcpcbrU
   1q/7PcBc8tnha52PljndRk6KW+QwwdUB3xyooNI+blKOQJL0O0Aj2kl6i
   OWMpEgsBZtFp2nhSbqnt/cl/enlNkVEBZaOEVRzOC/jwlFvHYENZAM95V
   AX/HUuzHnyd4q8tYTNykr6ro16xjhPkkPvU7ugsBhCyPruUivdLYFsgUA
   mXe+DLqom4r6v6mDtAascLIekvfM5ATRLuFcgTNBeOKoKIKcjRx7qZFaG
   WCI7jR1znPAfxlqEDubVHmNuuV84KUzO0ohklpQodb+DKWMjJDyvC+uCS
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="310954725"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="310954725"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 18:05:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="843387127"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="843387127"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 14 Feb 2023 18:05:08 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 18:05:08 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 18:05:08 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 18:04:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f6nLRVTQz1ZfIgMML9JZUSBr8fz21LbnsznCq7bYhHELWddvMCvKMPsbd8rCvnnLMcbN9ItF9EMjT9Rr3ypCL1hyLnZdeMW/9p/TeDyMookvZaYsvFnM4WGdksJsAeTu+2GGt3uyP01IqFSg/cT0dRDb/a6ZBwEFeL5c7i1Paqg9lp1/dQ4ELldHi6UIgIaVxges8Ogl8zPxdB5G3hj/E509wl05ufHdcJaXsXEYXvA810BEI1oqeJulZE31kf4DrhXwvCGncM/AhvrIX0xnUaTnbwMWuUFwwHi8A5ze41+Wj3weDFIr0MYa5tyOkIIB62/JhkYnPnGR6IOgSxzCKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8r/+rSGsDaN9qzllrYYjaj5fWj4wahkClcN/uD4qm6g=;
 b=USKnGO8XC3089G72LBJ25eBDupHSG1BZP5lwHJRCnv56cDjl682y4XwHFD0sj+qkjTkdTRhlSDkbWbgJbYXTCTSm7KMnui3zUXA+Brc9puZrlH9DdgkZDrkbzsLUZrU2gEzDfcEXEY3cJ8oMHHPgLLYCj6oyvCQnfgSkwg1jsqFt0CBq2EQuwLMBLUdd1fYESMWcuKtRp/tXUxN1Dc3U5Nk1wItyfRwl2jaWUjymatBxd+Pgb9PR30k1lZDlw1iWPo8dsQ8yLJuuikYTXyDWGt6qfyDizJ5Cq7AEYl6Var1/0r6jbgOH6he44ENV4WwgFosGvtiOH9teZMzM+1TA4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB6827.namprd11.prod.outlook.com (2603:10b6:806:2a2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Wed, 15 Feb
 2023 02:04:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 02:04:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Subject: RE: [PATCH v3 14/15] vfio: Add ioctls for device cdev using iommufd
Thread-Topic: [PATCH v3 14/15] vfio: Add ioctls for device cdev using iommufd
Thread-Index: AQHZP73TvQpA9MeASkiSDIZ0QSeJSq7PG6oAgAAoBiA=
Date:   Wed, 15 Feb 2023 02:04:52 +0000
Message-ID: <BN9PR11MB527610103F75E77E8D5DF9998CA39@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-15-yi.l.liu@intel.com>
 <Y+wbrgqt7+045A6o@yzhao56-desk.sh.intel.com>
In-Reply-To: <Y+wbrgqt7+045A6o@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB6827:EE_
x-ms-office365-filtering-correlation-id: da69ed8b-9b6d-4802-ef23-08db0ef90682
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O+F+XP+Obgw9No7bN74pLbPXFJzFMugXSAmBJGkptfCXQarP/IjOjMTt348E27lz0svX1tYKJnBTUbrm/w1K7dv8NFkghaJbQNkCRBx0JfUETrYY1J9ijJwQ/x2wUfm7quOQKy2akv+Hhj3asRRmVVMHKpnUpcgmz+/6W9FixYf+k9tb64OXNX5cuLke5TN2HE7ftwxf4fW28tKdCpGszObGXl1dkueSnWipskHToDvrkP9FB4ItyvtsY/Q5hMn7Izr1iaX27FO45e+/L8fH1oi76yVXvENpCsB0vQfNl/4GTJBMIIlGp67G9+KefgRPYKeAWwDaUZn6cSim7MNpe6v7dLU+mzjsA5I8AbpgmTdLnM8/lrWZ9VTuF51OZzD/h+8V+YQdmim2qmtX5BLvhJHpArFCIzF1AfeGsNMjzW0iBGoEjWA5JrqCoOlJ7ZCOVg/4dusr5fBpiR3HIexTUN3n/k3Rp2sx1iVig7W/GEF8B8bNl+Q85eR+nys5QQHNZmhAGO2AMv6oCYTB7Crl7buyA1Qv7fBmJas6PQ7l+2EIXUCkBUHltOG4j4nw95gZY2m2YlHq6c3WYFJcUCj0xmAvGcvXF0m4sYJUI9cMk0byGokL25bZ0NQkrxKzEiHprqfADuCFFwOl2srg3v7GCM756G4mVYUl3EPCo2B6/h51Ft1OlpqvRjxZTPZeWRvkRRbXt7RgwjkodNQAPmZGvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199018)(122000001)(38100700002)(7696005)(55016003)(66476007)(38070700005)(6636002)(186003)(9686003)(33656002)(26005)(6506007)(5660300002)(110136005)(71200400001)(7416002)(8936002)(478600001)(4326008)(64756008)(52536014)(2906002)(76116006)(8676002)(66446008)(66946007)(66556008)(83380400001)(41300700001)(316002)(54906003)(82960400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lZxKv1xts2mczM2Nof0bzeTOoWcqwyJs/GT7YpzIPDB47CrLH3MAq8VFhK+/?=
 =?us-ascii?Q?dGjaAl+S0mGNuZ+Zkab1DFneBCsNqYzI5w65GxDnM54AUn4MFHPfqPyXWV2t?=
 =?us-ascii?Q?e2mVp9eC5RD5OYxWdv3imT7lEt5L2G5dwElC6wce4xgf/rmNFIIsl5B9NtVK?=
 =?us-ascii?Q?f+Vn2t5HHQtCI28b0ZBANBFDIVkkvyXgph19ZnPeY9anBv6MTj8N3L/q7Fbs?=
 =?us-ascii?Q?Sc6oVhQUHGVIxEpNYzWpVN1XcOKOCdHbnZFGuedyRZPgXCEtHs46fa2Gj6Ar?=
 =?us-ascii?Q?esxEm5mxjJvLaQhgIweECphfI971FhIg3fhdRE1QpMHCpnPIznlnfOoHrJhi?=
 =?us-ascii?Q?f5etytdZgewzE4yVVJE9edimeueW47qCIF2pN7AmlTtjxapLXAAZUFTolD+1?=
 =?us-ascii?Q?xSegp2KdycpLZVifxynoh9Y6siVfSc7SorJ1DQrwiWoRE80sbEnsC7BmuSFd?=
 =?us-ascii?Q?gc6M1oAiyuTT2zit6CVrb1RXg1c6EU2uceT8gbWiSXkusGJADX3IB+5dMU/J?=
 =?us-ascii?Q?moizX5J+7u5pr+HdAp7aG4Iqr7Ma4qyGw1fKzpQl9rgODYYmFqgPZNShCO4Z?=
 =?us-ascii?Q?nC8gS3qci3unX49Ndsp24gwCfk6bfX8yAeiq35UwjE+CSsrCpYpp//twplQZ?=
 =?us-ascii?Q?guiR1wce7wZ4NPrk0QJ6TxVGWNXHQzWXJPaLLSy4FO/dWGmUIYujqmoBLKPy?=
 =?us-ascii?Q?2k1jIPo3Td/Sv7s/vygoxWe2P0JVmK5VxjhwhoPOlrxkWA0/kK7d9+G5MECK?=
 =?us-ascii?Q?p1XiGiIcXjsnk/dSAHvnRP7VlymDmle3QpQTau7BWVpUYwXmL7eE98tGuyCZ?=
 =?us-ascii?Q?szKQTIOMAG1TdMI0Q15ogPPXclgnveSg+0UhU8X4YG1p25mxX8v2ez6fKJ2z?=
 =?us-ascii?Q?u2Qwrr+cHvwcfJ2Fk8pl7aVgijfat7Wdv9PtqFsnRqheBTt/QEnr+hWZ6jMy?=
 =?us-ascii?Q?jLVr6D5TPwiiR4BYk6OXS0cEyrAuDXdZhXSApsOdjbrBTcSY0Ul7brvAnK77?=
 =?us-ascii?Q?atj3od91nN4H7oU54YtCUo+DW2C5UKSoviYa97Nwo+dfZFDuktBnZogRCXqA?=
 =?us-ascii?Q?2DC4oiTeavQJH6ugmR8eQRH8iMpwzLlhr8F0Dq1CQr/1HtNcy0GbLwN6xz7e?=
 =?us-ascii?Q?UTTjlIGVypjJIB+x87Xxi6Yi6X2rd6SqjpE+GGT3M7vFeIHgyWzSoNyAyrY+?=
 =?us-ascii?Q?pPeCeBdGER0xFdKv2j5tPRmre4Gx+ulWOdNs1bDxIE8vDftuBW7CyquZNT8R?=
 =?us-ascii?Q?gqj9uJ7fP5qIJvmhjXV+pw7VEmQK76Sm0faXIKjben/bHcQFvYfRM6eg1wxt?=
 =?us-ascii?Q?t1tuy4SybeV3jNwQmeIcShel2gjhx23pPvqExPKWe22dmSsRcilYv7Jp4y31?=
 =?us-ascii?Q?Kv6uhE0I7bdvNh/LJP1LrsOu4SUV3voY/qv5M7+/UJOdQK6SpN3eoBubnIIH?=
 =?us-ascii?Q?zZG3IBB9BA3q/zMQv3Rln9ZJE4xC7Z6Kih3mvsk7vfrcWt/fuQa2Qt19Pru7?=
 =?us-ascii?Q?UbIQb7XNR60kjAhSt5XcJOnF7eHY0P6B5mHSBc9NPdumzSTW/7G7aUbWD3Mm?=
 =?us-ascii?Q?gMkb4UhAo+piHD8Va4g3XfCw/BsZfsU5Ne+i3k22?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da69ed8b-9b6d-4802-ef23-08db0ef90682
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 02:04:52.1477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8T79FWJdN65/3yEd+6DD6+iHB14tM0LMc8NOXOsl/s98G5oe4V6Gn7FW3Mcs5E4H19FGb3DlPFfQC9HcMVyM8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6827
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Zhao, Yan Y <yan.y.zhao@intel.com>
> Sent: Wednesday, February 15, 2023 7:39 AM
>=20
> On Mon, Feb 13, 2023 at 07:13:47AM -0800, Yi Liu wrote:
> ...
> > +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> > +				    unsigned long arg)
> > +{
> > +	struct vfio_device *device =3D df->device;
> > +	struct vfio_device_bind_iommufd bind;
> > +	struct iommufd_ctx *iommufd =3D NULL;
> > +	struct fd f;
> > +	unsigned long minsz;
> > +	int ret;
> > +
> > +	minsz =3D offsetofend(struct vfio_device_bind_iommufd, out_devid);
> > +
> > +	if (copy_from_user(&bind, (void __user *)arg, minsz))
> > +		return -EFAULT;
> > +
> > +	if (bind.argsz < minsz || bind.flags)
> > +		return -EINVAL;
> > +
> > +	if (!device->ops->bind_iommufd)
> > +		return -ENODEV;
> > +
> > +	ret =3D vfio_device_claim_group(device);
> > +	if (ret)
> > +		return ret;
> > +
> > +	mutex_lock(&device->dev_set->lock);
> > +	/*
> > +	 * If already been bound to an iommufd, or already set noiommu
> > +	 * then fail it.
> > +	 */
> > +	if (df->iommufd || df->noiommu) {
> > +		ret =3D -EINVAL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	/* iommufd < 0 means noiommu mode */
> > +	if (bind.iommufd < 0) {
> > +		if (!capable(CAP_SYS_RAWIO)) {
> > +			ret =3D -EPERM;
> > +			goto out_unlock;
> > +		}
> > +		df->noiommu =3D true;
> > +	} else {
> > +		f =3D fdget(bind.iommufd);
> > +		if (!f.file) {
> > +			ret =3D -EBADF;
> > +			goto out_unlock;
> > +		}
> > +		iommufd =3D iommufd_ctx_from_file(f.file);
> > +		if (IS_ERR(iommufd)) {
> > +			ret =3D PTR_ERR(iommufd);
> > +			goto out_put_file;
> > +		}
> > +	}
> > +
> > +	/*
> > +	 * Before the device open, get the KVM pointer currently
> > +	 * associated with the device file (if there is) and obtain a
> > +	 * reference. This reference is held until device closed. Save
> > +	 * the pointer in the device for use by drivers.
> > +	 */
> > +	vfio_device_get_kvm_safe(df);
> > +
> > +	df->iommufd =3D iommufd;
> > +	ret =3D vfio_device_open(df, &bind.out_devid, NULL);
> > +	if (ret)
> > +		goto out_put_kvm;
> > +
> > +	ret =3D copy_to_user((void __user *)arg +
> > +			   offsetofend(struct vfio_device_bind_iommufd,
> iommufd),
> > +			   &bind.out_devid,
> > +			   sizeof(bind.out_devid)) ? -EFAULT : 0;
> > +	if (ret)
> > +		goto out_close_device;
> > +
> > +	if (iommufd)
> > +		fdput(f);
> > +	else if (df->noiommu)
> > +		dev_warn(device->dev, "vfio-noiommu device used by user "
> > +			 "(%s:%d)\n", current->comm, task_pid_nr(current));
>=20
> IMHO, the "smp_store_release(&df->access_granted, true);" in patch 7
> should be moved to here when bind is indeed successful.
>=20

yes. in that case patch7 should put release in vfio_device_group_open()
and then add a new release here.
