Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9EC6BA880
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 07:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbjCOG5S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 02:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjCOG5P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 02:57:15 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23957104;
        Tue, 14 Mar 2023 23:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678863434; x=1710399434;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PqywKBgo1tm3+Q4haimR+QXtKWq77FDsxYycYX2Uikk=;
  b=C04f/dXWTydCkfml9xhz11+ipJB8AYsUPPzga5vCfiw9zwRqz3VjHPbT
   GidMx/Oo1p+P4DCSMce+pgLK/2hgyjGjgLRCP3xZ8iejgDLi0W4WAdutA
   6/zdBcprdReKTheNyRQFiXLVPKBSzjIWIQRpdiSHw+KR6W+Wu+zynfyB9
   qHkH8eCXFJPxm9Im5QjvhZvgHTwQghl2fSfFvcLx0wDdY32drjdnGBr5Y
   Xu8kVkzet9LgDIXfD3iBKuRWLzS16X7MYHaC2pUVWzrXqpFoBdDD10sHV
   aNfpZHxDL4G4Y2dk/sf9DOoWcoi3oM/bkOCkq4Lwg1l21cKovwp3vvg4j
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="365307380"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="365307380"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 23:57:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="672632042"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="672632042"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 14 Mar 2023 23:57:13 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 23:57:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 23:57:12 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 23:57:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ogtbIi2Can6520yLGSIdyph89OecMjs+5DuhatfusHklOvT/1QhallGfO3U8g1X8Wc7dcgKlhhs5uUiysifuwxStFkXkQeHU0mA7gmpqqypNfMNTxOtqwMMbXqoBhB9B0NRj6uBhp/Qtef3JdLbYnCfm05zrOK3Zr+nMnAPhgm1756dAVi8ycNeDqU84KaDUTz78ouxUcTN7qQGnXazL9p+XEyRYfOQnLj8GveV2/Eyc1W0kxWx1tflFxC4DE5sHs+lA3aQZWt72cMQyeJXMPZvBddT5IHyzQKf/0TuFkL4ewxjKKHJSBlhr0ZC9ghBinvn6HaSRR2WDe7WSGDZgKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+V09eUg9bWeRrsLAwHByHXaYUoRSUhoIWZZ/jw7lxAc=;
 b=IFFOy1P2KYTQosTfi5Ah7UfBasldSoABDKeHu1ydhClDqXHmF86suB979JZaEykROzQmAXdOmsbmycIIHDxhQAHd6ojjXMraxC4PGi8tn5oEpCGxdaxQvbCnJw32UqsWVW6PJUq94pvJ3YanCRtGTRCyserCMY6vaVRu1P7bZm1pjFCASOM/z+C1xYvAEMq13bwO60J6gkuoW/s+bLt+pTF7d7wAAe3+4GgAvjAq6SRWz6nK7nutuSq5S8fhJfi2wiy3h/OIEfsDgRRWnNU5QI8737zbEpy+F0rNESjtbPYJeQtqu6kow1k9SHVtSVXB4utFvF4hmDC1GTTr7DCOLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB4676.namprd11.prod.outlook.com (2603:10b6:5:2a7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 06:57:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 06:57:11 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
Subject: RE: [PATCH v6 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v6 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZUcIPMa9EffDOZkWyiNA29dWGmq7zuaqggAAQh4CAAAHT8IAHgPWAgAAl1BA=
Date:   Wed, 15 Mar 2023 06:57:10 +0000
Message-ID: <BN9PR11MB5276EE7424E634683BC387D78CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-22-yi.l.liu@intel.com>
 <BN9PR11MB527665CA5753E413CB4291AE8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529B3BFD999C9720836F049C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276684B2C0CD076FA3CD0938CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752922A0C9058583F677369EC3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB752922A0C9058583F677369EC3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM6PR11MB4676:EE_
x-ms-office365-filtering-correlation-id: 6c25c778-732c-45c9-8edd-08db25227ff3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 20Mjwww6ecno/9ERpKBvOWPybw5ZCwfNzvtlVj+l6bKLlLwa/D0vxTmhiq+xpUNy0DJxuMZYm/AvlqL4aahCCgLO2mz0pbaBWkiMHbMv4YmPNWgF1jOvh8j49Q3aQ54NLzXDRdMu5ugRTcKm0azEDvz8wOGe4c8sVuqxtDSK8JoeiT6CRuTAyO/lnLueOEjHCUShvEr74yU2e/6rcolYPG4oWse7hjgBclE7tD+wWtWPkyls5xsMyAI/f7URXVfiIxuXhLGf+pNsZv+nEJhE7tAqX3B4xI7kj0XkYn/2X9lN8B2/VP0aY/Ac/p8Rz7H4YyfadYFaD2pMFViG7AtgWjeRhlBRuq2OZ6J06RQNZGb4nFplcV3yc8cjnxdXQGsxrpxazbEV/nZc1ThRylI44ZZ5lvsRjTR+cSzmK5LiSOJPhwtdvsoeGWOWdE+hh4inFN82BNAPF5JXfjZPPMGkkty7DkJaEjGuOnuriZI/lNTEz0PmVkQFPPWho5mMJJSx21r02Q5EVSz0OvmxpJANgwvYJIX1lfyTM0TZr5nzSp8hS1FHaahKKAjAJkAPo+UI9hssP0gaYT3Sev+15tRHaqw9m0CAkkMN7QMNrLSHSYAYWX0/sc55dOoz1HVeBlHfB2U6fUahD/cRVdb51ybwAjUg17JdnJWgeU95KLKAv3d1jzXfRP3p0L+ei06Onn907dgioQEIyJ1nSNIYTDy14g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(366004)(346002)(376002)(39860400002)(451199018)(76116006)(4326008)(66556008)(66446008)(9686003)(186003)(8676002)(66946007)(66476007)(64756008)(41300700001)(7416002)(5660300002)(83380400001)(52536014)(8936002)(26005)(6506007)(110136005)(71200400001)(7696005)(316002)(478600001)(54906003)(38070700005)(55016003)(33656002)(122000001)(2906002)(82960400001)(38100700002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xufxmAUBqVVrg7ZBfAhnk264Ff6pI/du7Jp3IlU0HYtse4DkdG3B+VGnBidx?=
 =?us-ascii?Q?ezNRCd5A7tud1BqsbxtYY++Iu1ztOJMrB7Lcc2ORC5lvx+4n0gWAwyqoA8h+?=
 =?us-ascii?Q?yrsMqApVc7w8fJsw3JnCbeFk2eWJcDXi+mRxwUc9Mad2JiRfPS0MJwaKrCpa?=
 =?us-ascii?Q?oPj1cMYM33OhFRDqXs5oKCUfi2OnnbOlBYioQ4dHi6IastoFZEJwbfAEHlMe?=
 =?us-ascii?Q?RHseGeLZLbeh+sOTgceDDMC1uQJkKDXvKr4hUK6qcm/M27xTpdR9cLCiQtYc?=
 =?us-ascii?Q?SnZQFWKX7Wx6MOatz2M/tawbiVJkw4C5ewBa9Pe6dSY7B/+aO+OTeY3BQxvw?=
 =?us-ascii?Q?6RXIBUgZNv+FzS2OOQza+/dbov0AY4/sEOSBNqBNCA/bhgcaFprALqVyesZU?=
 =?us-ascii?Q?t+XQ6BPisreqXb6MbFupBPYQ0L0rQahmWBYmhiJtI3lWon/StA8sVEXMDVK0?=
 =?us-ascii?Q?4v06T3VBu3983H5YGrkCIwf9wQoOc0YUyRpeB9M+w62PQSn9QFzmxDVAQQbG?=
 =?us-ascii?Q?yFVNQIWErkUMxEJsGwDwYBg2iLeIj6NvI/3qGPSJdVmSFcF2zFONuMbSGztp?=
 =?us-ascii?Q?VDN6N+qUnPH1XfiYFzY4F34/6Sq22Liddqp/7UT3qOJf0CYWuBHpzAwlIXl3?=
 =?us-ascii?Q?WMXSnF0ZT7TOw2VG+/uc3ZltrKLN3QM5IsWoLfUm20kMmqNIVKD2FU49i4L+?=
 =?us-ascii?Q?quAhVADFiHL72iYOlE7BT5SlF47NL4L/KJDFDng98snyDsONg8n2mCM2t6pt?=
 =?us-ascii?Q?e0c35AQPMnkKuA+cMxVYigxRI+WCqE8xjr5YlJPfvAtuLO7U5kBILo3t1lgn?=
 =?us-ascii?Q?avJznuSGcm+F4DeLar1cR5+LK6NG49JpfMTKK6W/j7KR7hYT62NvQ7GbcbRW?=
 =?us-ascii?Q?eP5QO3/Iad4gkV4GVsGbjETHTzcj26L3G3po3NtzHRFWxgfYQSCDLb8irzTx?=
 =?us-ascii?Q?hGqzmieQbyGLnPkHKM3AUv0YC7/LjqbmORohUjWsjbDNA5xOsy2GgYDNhJ5t?=
 =?us-ascii?Q?5riDLYt8P9UqVlRUDaFGQcIFZ7PEBeHSK/7dSz80R5RIJB1pxV1NWD4Gzydg?=
 =?us-ascii?Q?y0cJlpHPD9hGxoVbdozMJv5jS7SyDZGPHYjZgWdSiMivDpv1VaQVMGP5bt9b?=
 =?us-ascii?Q?whBW1LvC4On8brr55le7Q1Kvtqhrq75DuUAHPgMSBOD7Mp7qjT+/j0Aes0u5?=
 =?us-ascii?Q?5wN7cqEF0oLsOkQX3DPoiZPXlluKGD2fBM/Ssmg8XSKEajEpgYIixS71/da3?=
 =?us-ascii?Q?X5RFMwwqfUCR5P/21HprRNkJ470aZPKNKt7eOyWJF/MGT723x5d3zjFf4o4p?=
 =?us-ascii?Q?WCAzrOOMk0nbVqxWYQe3iC0/e1nsnkGWIyj1Tt2pNIv9QhX1gwBZCHzZx6Qm?=
 =?us-ascii?Q?KqbKglt1+P/KMK56UUysrjU083YVm46MB/VqFEMmm3begfY/7g1LkSQG3/UZ?=
 =?us-ascii?Q?nPcQsKSgycDnaR5hagClr87FmmB7dYuiW/BUIWxbITJd5y6t/N8SLvhcmqXX?=
 =?us-ascii?Q?r63xdov0FvaEOcEQUXSzqpMGgWvjIkCoFXCREwN2Nl1doOGFesaKBcx4SzGY?=
 =?us-ascii?Q?6ywpTdvPa3fTgZ8nR0oIkzN9WTw9r/Y5a+4jttZ9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c25c778-732c-45c9-8edd-08db25227ff3
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 06:57:10.8216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mEyGSeYt79hel8xibXg2iEPX+XVgOlqpfAFTpWz/qX2Q/mmHee23VjibS+Qe0k43rKXly+HdZncNZdW9sIRnfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4676
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, March 15, 2023 12:40 PM
>=20
> > From: Tian, Kevin <kevin.tian@intel.com>
> > Sent: Friday, March 10, 2023 6:07 PM
> >
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Friday, March 10, 2023 5:58 PM
> > >
> > > > From: Tian, Kevin <kevin.tian@intel.com>
> > > > Sent: Friday, March 10, 2023 5:02 PM
> > > >
> > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > Sent: Wednesday, March 8, 2023 9:29 PM
> > > > > +
> > > > > +static int vfio_device_cdev_probe_noiommu(struct vfio_device
> > *device)
> > > > > +{
> > > > > +	struct iommu_group *iommu_group;
> > > > > +	int ret =3D 0;
> > > > > +
> > > > > +	if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU)
> || !vfio_noiommu)
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	if (!capable(CAP_SYS_RAWIO))
> > > > > +		return -EPERM;
> > > > > +
> > > > > +	iommu_group =3D iommu_group_get(device->dev);
> > > > > +	if (!iommu_group)
> > > > > +		return 0;
> > > > > +
> > > > > +	/*
> > > > > +	 * We cannot support noiommu mode for devices that are
> > > > protected
> > > > > +	 * by IOMMU.  So check the iommu_group, if it is a no-iommu
> group
> > > > > +	 * created by VFIO, we support. If not, we refuse.
> > > > > +	 */
> > > > > +	if
> > > > (!vfio_group_find_noiommu_group_from_iommu(iommu_group))
> > > > > +		ret =3D -EINVAL;
> > > > > +	iommu_group_put(iommu_group);
> > > > > +	return ret;
> > > >
> > > > can check whether group->name =3D=3D "vfio-noiommu"?
> > >
> > > But VFIO names it to be "vfio-noiommu" for both
> > VFIO_EMULATED_IOMMU
> > > and VFIO_NO_IOMMU. And we don't support no-iommu mode for
> > emulated
> > > devices since VFIO_MAP/UNMAP, pin_page(), dam_rw() won't work in
> > the
> > > no-iommu mode.
> >
> > correct.
> >
> > >
> > > So maybe something like below in drivers/vfio/vfio.h. It can be used
> > > to replace the code from iommu_group_get() to
> > > vfio_group_find_noiommu_group_from_iommu() In my patch.
> > >
> > > #if IS_ENABLED(CONFIG_VFIO_GROUP)
> > > static inline bool vfio_device_group_allow_noiommu(struct vfio_device
> > > *device)
> > > {
> > > 	lockdep_assert_held(&device->dev_set->lock);
> > >
> > > 	return device->group->type =3D=3D VFIO_NO_IOMMU;
> > > }
> > > #else
> > > static inline bool vfio_device_group_allow_noiommu(struct vfio_device
> > > *device)
> > > {
> > > 	struct iommu_group *iommu_group;
> > >
> > > 	lockdep_assert_held(&device->dev_set->lock);
> > >
> > > 	iommu_group =3D iommu_group_get(device->dev);
> > > 	if (iommu_group)
> > > 		iommu_group_put(iommu_group);
> > >
> > > 	return !iommu_group;
> > > }
> > > #endif
> >
> > this makes sense.
>=20
> Just have one more think. vfio_device_is_noiommu() is already able
> to cover above vfio_device_group_allow_noiommu(), just needs
> to make it work when !VFIO_GROUP. In the group code, group->type
> =3D=3D VFIO_NO_IOMMU means vfio_noiommu=3D=3Dtrue. So no need to
> check it. While in the case !VFIO_GROUP, needs to check it. So the
> code is as below. I can use vfio_device_is_noiommu() in cdev path.
>=20
> # if IS_ENABLED(CONFIG_VFIO_GROUP)
> static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> {
>         return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
>                vdev->group->type =3D=3D VFIO_NO_IOMMU;
> }
> #else
> static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> {
>         struct iommu_group *iommu_group;
>=20
>         if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU) || !vfio_noiommu)
>                 return -EINVAL;
>=20
>         iommu_group =3D iommu_group_get(vdev->dev);
>         if (iommu_group)
>                 iommu_group_put(iommu_group);
>=20
>         return !iommu_group;
> }
> #endif

works for me.
