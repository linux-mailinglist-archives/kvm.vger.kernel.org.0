Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218C46A5236
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 05:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjB1EJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 23:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjB1EI6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 23:08:58 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40C5136DB;
        Mon, 27 Feb 2023 20:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677557336; x=1709093336;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1s21TObzUG3yidIS//u2JtYz/nfhPoJYn5xBhi2cxQI=;
  b=lkTWp+Kretct+MgA/06FAcQWchLE+40NoWHglwVehc6+/aRnesLjuEjt
   faE6Gi0f1/oe3aHEq1AlC3rsnjUEDPCPX+29mMhsnX/3Xmx9c+HRlM+gF
   hrc3i5HkiBJQHerjwI2ORTlmTrsol3LGsiO7gIDdgX/cNvGwwNaOBEsii
   JMB2B93uI6jScTiW0tariek2mXcNftHRVFIfABE9FDKhqLg+nlCuRS26l
   nXsrr3ydEZie0DqBg0wU4oTIV3e/f3Vah6LnYUh1EBv3EMa2vW1p05mc6
   pdu0gfSsx1P6pYuTih63QvYYLlThMPfwXqIjhQOQ/TN5iUVviPFU3jBp4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="317842865"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="317842865"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 20:08:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="848114698"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="848114698"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 27 Feb 2023 20:08:55 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 20:08:54 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 27 Feb 2023 20:08:54 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 27 Feb 2023 20:08:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oThSTERiG2kxai9bDM4QNREJnSAUW+IkKxLCftIJzpnMdFEfsK30FNqKDw02xpzxq+AgptXknMyokQV3sDFecPg2NyUAvERvIYg3ZjZb2yzgRk73aTjUA3eeIdD5Jo3exQhnAl2jSo17M8vsbyF7k6K5u3RVyinstP9XTeKq7iN4tuJt3DMa1/IVQ36As8hut9+XOcdzB8sSGvPCvDyuPazRBKA2bs1lDu76+YUDPXtxdXD+CtGpeJJd/dHgzgKYmqe/rkALcr44ebVDInkkPuMT1TLXtkVJBJ4lCny4F//22CAzYiQQq00flOAswXLv/H6s0jwGJrSOZq3YnnlIbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bTh3hHJQJs7oLpoJA1cZMbGxga5jFUzWwus0cNQTbIA=;
 b=Iek/zi3rxts0aWsODRPNphWY/HHyoHRGIEMnY/2L4HtyEqWmEKhgmtL1+Z10CcGreDC4peoVqEzX9gMAUh41UN2At+t1edEmmPLRDCNtN5qceBtscsgprBuH87mh6xz5oWuZ9fp0bVLY3udxlsSK0Pbw/U2DYtcsV0lwP5XXexnlwqVv4hKCjUePFCIG1UDPrHzO3g78KU87N5N7un2isOGdjPxUwcFQeoaE36EioYnZ4ZVw+anepEyNj7c004yfcTJc5suFUTGABs5p11QJl9OCIcLrrblfcFLSkOmSeyMJ7iZnLLCoRGNChwdYSqWfXWZ4vil3Ae3rtaj6q6+oIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB6503.namprd11.prod.outlook.com (2603:10b6:8:8c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.28; Tue, 28 Feb 2023 04:08:53 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%9]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 04:08:53 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v5 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZSpxP1elsXPP8bE2Y+PYEE7Tlg67jK7SAgACRZJA=
Date:   Tue, 28 Feb 2023 04:08:52 +0000
Message-ID: <DS0PR11MB752997C0012647B1E9699A2CC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-17-yi.l.liu@intel.com> <Y/0CV1K0YNHA+olf@nvidia.com>
In-Reply-To: <Y/0CV1K0YNHA+olf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM4PR11MB6503:EE_
x-ms-office365-filtering-correlation-id: a4a3d76b-c7a8-4d23-6817-08db194180e3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YwJiKmqwSwBOxkUORTMjA+9KoB63hDz8w7hsn46/EodKowngPs5u1cMYqd+yjP/eQf3rAO5CJBbTaKw7UoS0VB6PVzhUNlUgD+s4SXXXWnt1ae6uGfGuRRdvPtM6AvmtNtYVqEW9anCFYCiGa1Of35kfHhXorQsBCuHQvtrmohAiHMVXyAPzDdzStNTZx54dLFLOG16wfjmgIFyO2EW6Ayv904v5mydKpDi8MK5aoegpLeTJgK0vfBrKrZIxU+Qh8sq2i0Ys0dWvfigpJ3ikajxLhi07UhqDyp7O0axPvi3wYKWXBfglbLXlFHnXphyfLkFMx/H99Qo/keoUurbOvMhYXwDEoEPEDZD9g9S+0/qJqfeN/Xp50wrIVHAFxGzNI7JzkW9m4J+1F6PXiqpRK3p+Iao34L6g8doE7kaMEYjcAfNhp+Ycw3RSq8JRDyzXhKxGLpeUwQNNCcKavNFwbA15UBMim5GQGwkKftKa7aGEam/K1W0YnbrD6NdmCi8G5uG5MisWu3T1VuJZwl5y+Hp/pd4222j5uRuL0fDm0KxSFRrlrgTRlKNuwv4qmxDqroXgWvch0XP8A14Y0cPPHNLR/6HiahfhVD10XA/u2FCIXuShYH5numqgMYviNz6JBAZ6AXaZKMDx5u0hIDLxCiX3bdP6RgLqmoC3wYepukI0U6mwjwq3MsAEKY0ZW0JQkpvZJFiEqjK3IIRGRvoJug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(366004)(136003)(346002)(39860400002)(451199018)(316002)(9686003)(33656002)(54906003)(86362001)(7416002)(38100700002)(26005)(122000001)(66946007)(82960400001)(83380400001)(6506007)(38070700005)(186003)(7696005)(2906002)(8936002)(52536014)(71200400001)(5660300002)(55016003)(478600001)(4326008)(41300700001)(6916009)(8676002)(66446008)(76116006)(66556008)(64756008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7/lE7Luue+RMvH6opmtMfOE7ha/qxBF8PWM0+9GQD7iOlV1C4Ynl9kv4XAPd?=
 =?us-ascii?Q?sjnfC5G4ipuIc14cgSFkPeqcwfWKftG/QcMv5rEKgDPxrF4ZV9NIWl514Ffn?=
 =?us-ascii?Q?r2BLT/xOG/JzIGzgNwxNLhDNaIpQraFzum5aob1z5KSUDTqbNir9f5BTB4gz?=
 =?us-ascii?Q?tpPIDIRSr30FXyncfZGWC5wHw69ij3py67EtVcdHVXiX0X1Nc3WheZaeFurO?=
 =?us-ascii?Q?j/s9nXqFY30ou+IkdjnEqqxsx8G5WwEMxUdhOGQu6Z/yF4espPpC6lNuvzW3?=
 =?us-ascii?Q?mKeWwJb1/QkmxSyFb2bPFxZ6FJORszlJG3fynXboX4Jgh7X974MjoD62zmyZ?=
 =?us-ascii?Q?HQ0D0Mns8MHL2V+IjqvGKLcaDxGmpPqQA9LJcJa8r+sGL0QY2tt/R581KqTD?=
 =?us-ascii?Q?Pah1wShK5Qi2SH1FE5/FDIzwNnMx2zB9peeZXaPXCeqJBQeHrpLPY77fW4mf?=
 =?us-ascii?Q?vxUUxB2X7wf6u6neoKiVcDlOoTt3GDg+ZFgue5MOscYKx0bzhImjgdZ3cIhr?=
 =?us-ascii?Q?MshTwolsZZfRiq+ptCq4WW8iSaSK/wQCaRzvrq58Ha9Omx8OHaAOJ2X+o4zv?=
 =?us-ascii?Q?QNswK9n21/8Wqwd3RQgMKnQytTIYLuDr2Zd/OSBv7MhxmJarNNnPL+2XW8Xd?=
 =?us-ascii?Q?+3z0bnRD/SJtol1Wsy4oDC4g6Q3qduA+yawIzC4IDDzjYPXTX/2GNIJqmCAL?=
 =?us-ascii?Q?kxgztq+XAR5H0mBxGz8y1VPLE33jvScRdZmJjx1acMOhIsibYjzcIHK1Lp7z?=
 =?us-ascii?Q?y3QJ1Zes0+GupPg8lRGfcHs7Rj618V2YLnn7qX0ogNM7rTmpysSUiWXIxYa0?=
 =?us-ascii?Q?2iwHeNtaUHj/V7ReGBP06BK/q1SxGPIJTpMCrZ+GaNjnCzAV7cwilru3bW2f?=
 =?us-ascii?Q?VWpH5vFKUXjWVlQDSvVP5J/xORXR/h+TD7VTyVoNVuOIUZiupUoWWGn7osRJ?=
 =?us-ascii?Q?IP5wGGgGEZDDv/2sKpo8UhkDxqqc6kicgRveUWAECFdj99HZ6UyfH0xJ/cSW?=
 =?us-ascii?Q?waYAyFx8m52146WXSwu0K1M5NelLnPnHMZ8rG9BM8JhtZDr0WFNG6w1bGF/c?=
 =?us-ascii?Q?/rbfw9XX0YkRTwTtGDMQnpinlTT1hpKFvsgC1kguOey/VI7CbbzJ/R90qI5A?=
 =?us-ascii?Q?Ec/r45o0llpOVrEPtXW4OiggPUV5B1SzbhFct+gyfeNP4a5/1rS/RTvr/ihI?=
 =?us-ascii?Q?QqV38mP9Drj6wC4hcdXcV0zvWr5V6PnwiNjKwZFHpwD7gb1S/wocFd+nPub/?=
 =?us-ascii?Q?TEemxRVT1L5OVUTrNyPD5Rc1qav6MnfarO4h7J471UvC14sTG9WDBacdzefJ?=
 =?us-ascii?Q?L2EIbH9OqIxs+RTrtd//PGNOh1pfP8ryCKXSt4QqiuBlrbaFv0keriO7pK5I?=
 =?us-ascii?Q?n2p5p3+8HxIlp013A/GIv4pX99dunBoOh/Dbm6KaZlQ9CDgo+LyK6OZPY6yI?=
 =?us-ascii?Q?h+DsaIsEeEEE1Q1pojeeL6rtxl3j/rAN6fwN3XK41p42guv+P+mhk2yHIBdn?=
 =?us-ascii?Q?qCc5yRRL+7UsydZMTfi6ht3W0PsaFR7ANiLxpiGrWldQIsoVwNVoyDefSOcx?=
 =?us-ascii?Q?Q0U0UUaH9FBQoWJsPnuxRv0oTD7L7oSjq10O8YYg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4a3d76b-c7a8-4d23-6817-08db194180e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 04:08:52.8700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e9QrAfZeWustmVew15/xyMyipvPZto8W+IJpdSI2GReOxnToGHAe+zuQed+NRhik0ARmsjG0pyASCnXT1qzupQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6503
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 28, 2023 3:20 AM
>=20
> On Mon, Feb 27, 2023 at 03:11:32AM -0800, Yi Liu wrote:
> > This adds ioctl for userspace to bind device cdev fd to iommufd.
> >
> >     VFIO_DEVICE_BIND_IOMMUFD: bind device to an iommufd, hence gain
> DMA
> > 			      control provided by the iommufd. open_device
> > 			      op is called after bind_iommufd op.
> > 			      VFIO no iommu mode is indicated by passing
> > 			      a negative iommufd value.
> >
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/device_cdev.c | 146
> +++++++++++++++++++++++++++++++++++++
> >  drivers/vfio/vfio.h        |  17 ++++-
> >  drivers/vfio/vfio_main.c   |  54 ++++++++++++--
> >  include/linux/iommufd.h    |   6 ++
> >  include/uapi/linux/vfio.h  |  34 +++++++++
> >  5 files changed, 248 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> > index 9e2c1ecaaf4f..37f80e368551 100644
> > --- a/drivers/vfio/device_cdev.c
> > +++ b/drivers/vfio/device_cdev.c
> > @@ -3,6 +3,7 @@
> >   * Copyright (c) 2023 Intel Corporation.
> >   */
> >  #include <linux/vfio.h>
> > +#include <linux/iommufd.h>
> >
> >  #include "vfio.h"
> >
> > @@ -45,6 +46,151 @@ int vfio_device_fops_cdev_open(struct inode
> *inode, struct file *filep)
> >  	return ret;
> >  }
> >
> > +static void vfio_device_get_kvm_safe(struct vfio_device_file *df)
> > +{
> > +	spin_lock(&df->kvm_ref_lock);
> > +	if (!df->kvm)
> > +		goto unlock;
> > +
> > +	_vfio_device_get_kvm_safe(df->device, df->kvm);
> > +
> > +unlock:
>=20
> Just
>=20
> if (df->kvm)
>    _vfio_device_get_kvm_safe(df->device, df->kvm);
>=20
> Without the goto

Got it.

> > +	spin_unlock(&df->kvm_ref_lock);
> > +}
> > +
> > +void vfio_device_cdev_close(struct vfio_device_file *df)
> > +{
> > +	struct vfio_device *device =3D df->device;
> > +
> > +	mutex_lock(&device->dev_set->lock);
> > +	/*
> > +	 * As df->access_granted writer is under dev_set->lock as well,
> > +	 * so this read no need to use smp_load_acquire() to pair with
> > +	 * smp_store_release() in the caller of vfio_device_open().
> > +	 */
>=20
> This is a bit misleading, we are about to free df in the caller, so at
> this moment df has no current access. We don't even need to have the
> mutex to test it.

Ok. so I can test it outside the lock and make the comment
more clear? How about below? Or simply no need to have
a comment here?

/*
  * caller of vfio_device_cdev_close() is going to free df, so there
  * is no need to use smp_load_acquire() to pair with
  * smp_store_release() in the writer path of df->access_granted.
  */

> > +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> > +				    unsigned long arg)
>=20
> struct device __user *arg and remove all the casts.
>=20
> > +{
> > +	struct vfio_device *device =3D df->device;
> > +	struct vfio_device_bind_iommufd bind;
> > +	struct iommufd_ctx *iommufd =3D NULL;
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
> > +	ret =3D vfio_device_block_group(device);
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
> > +		iommufd =3D vfio_get_iommufd_from_fd(bind.iommufd);
> > +		if (IS_ERR(iommufd)) {
> > +			ret =3D PTR_ERR(iommufd);
> > +			goto out_unlock;
> > +		}
> > +	}
> > +
> > +	/*
> > +	 * Before the device open, get the KVM pointer currently
> > +	 * associated with the device file (if there is) and obtain
> > +	 * a reference.  This reference is held until device closed.
> > +	 * Save the pointer in the device for use by drivers.
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
>=20
> ??
>=20
> &arg->out_dev_id
>
> static_assert(__same_type...)

Yes, all the above comments are similar with other two patches. Will
refine accordingly.

> > diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> > index 650d45629647..9672cf839687 100644
> > --- a/include/linux/iommufd.h
> > +++ b/include/linux/iommufd.h
> > @@ -17,6 +17,12 @@ struct iommufd_ctx;
> >  struct iommufd_access;
> >  struct file;
> >
> > +/*
> > + * iommufd core init xarray with flags=3D=3DXA_FLAGS_ALLOC1, so valid
> > + * ID starts from 1.
> > + */
> > +#define IOMMUFD_INVALID_ID 0
>=20
> Why? vfio doesn't need to check this just to generate EINVAL.

Hmmm, you are right. Not needed any more.

Regards,
Yi Liu
