Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932606901EC
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 09:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjBIIMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 03:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBIIMj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 03:12:39 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85093B0F1
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 00:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675930352; x=1707466352;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Cl/IxLVTUqHsry8u5t/IFufaNZrvE73EAg4xuFsCvXk=;
  b=B+PI8HFgI2DMaVJcyBiqebjGZWOJRNfMMW+89SKCT4FZdzpxXL1ZfLRa
   /nxiwMklEd2pMCzd9EPJE+FGdwIGCluycD5SUNuZ0ZQwFXAGJTW4N7DUT
   qY8/21y1ew0swiCU1GAz0mmSz1Vg/MEYfTk+NqEg/RcS5K4ICvZzUQ4q+
   seOSKKwKYq3Eo6DVtGNeQDb1ADZfjPbJn7VAPM1Ge2hXzXLYQmZgzEIP+
   JIrjR9WrcSELWKCDds2Zi8COgGrN4DQ9qKeiE+0CL9pVaJR0A+xMg++07
   eMTURh5v+TEuX+qm1oOnpazEXEFVQcdFyDNgnGro7SNNo+8BokhuHn1VN
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="309694821"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="309694821"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 00:12:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="667554123"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="667554123"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 09 Feb 2023 00:12:24 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 00:12:24 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 00:12:24 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 9 Feb 2023 00:12:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ullw5shXwKmilKrAfSHczZGNnTHdjoCuc9LT7r8IPo3WRFADTFPhDDMyAEX/zroxSVYxk62st+MHjSFDcuIOdCORz3c4knHS27p9uISwJeiURjhTMxpZDV37OBb02khrFS8SdLglJEKXuELMG2JdwxpzDWxoArmuUa7M5qf50zFZnPdX1+hzfoaUldn4sEg4FOVKKKlPDlwXkYVFDEtwa7BCRt4MWclE4Utq1/tVFMisk01KcwfmmwtTd1A0tTADYMV/XVVOMfSo9tfp4FwyXmllCP03RaMyc3mvchR2F9CvfMfiyCueGmN5maj9zl50grUXbxA1V4Ofcd7J9f85uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwpIzoIQSAAbyv9ahHN+oaW85/dz9qSUX3KA5tGkI8g=;
 b=Emw7/bpxAsimyL1R0SRaUpPJpZOod0l/L2mhWzrwJCEWuNKRDjp4IvOTDv8NX+5oXU+J2HmD5zICXYCO+KjWfyUk9jerREI7CFx5O8U56+ba6ZNGl5TF5eXKDrzRXrvSMsAPS6hoJUklEhWFEDYQ+i2qmxCJLD4vm18cHpoDaHnnFfaWAyoz2L/nMo3ti6j+XFkc+gxmynE3yUMfU3QGwno/V+ySqoycVQfks1glJbs9xvmhjnshi5WqbitFlc1g4EiMaATA+rhezqza8uHvbTgXzk78L+WMtlzvd9ZO5Xmwc4GPZLdKc+mNEhzyIqeCKfwhYA19aEpfDufrCC2nnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA2PR11MB5116.namprd11.prod.outlook.com (2603:10b6:806:fa::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Thu, 9 Feb
 2023 08:12:21 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 08:12:21 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v3 2/2] docs: vfio: Update vfio.rst per latest interfaces
Thread-Topic: [PATCH v3 2/2] docs: vfio: Update vfio.rst per latest interfaces
Thread-Index: AQHZOKbkEaAh3bStZ0u9OK6j+rjDqq7FttoAgACS5UA=
Date:   Thu, 9 Feb 2023 08:12:20 +0000
Message-ID: <DS0PR11MB7529FCDFCED13A44AE1FD5BAC3D99@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230204144208.727696-1-yi.l.liu@intel.com>
        <20230204144208.727696-3-yi.l.liu@intel.com>
 <20230208162132.0c3f573c.alex.williamson@redhat.com>
In-Reply-To: <20230208162132.0c3f573c.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA2PR11MB5116:EE_
x-ms-office365-filtering-correlation-id: d74789e1-c7b7-4d2a-041d-08db0a755e00
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ISNetkFuh0vO5Gdthw+xwyxg6BnUCGNihWVuAbMluNF9HsE9hcsHp/NX5yLMr1o8M5MNLRzSZJ9jUay9Medh+SA+5TX/Qd+pJV5Z+0q3+loeHGoFDmBMLYECz1U+emkZU87lOczPYPV2ViB/MCfdxB/jqDLpoqEbRCehg2bxY+VmEOX/ljMePY8S4Z0zG82Qyx/F/LqK7GGaRmxnpiKc76//C+5GTQhSoiLzgiHA9uXvKGvN+5Zub3ru3Z3RvlK7p7gugdy9RG3E9ZLBWHSaNzKfEDXKsN4gPcsSYZFtE50tGqABoGRmuW/Spd5+qAt84Cv8duhPr+/xhbe/PHrsZ/5I45LfU+8f89RVIDZ+GfBkSohz0JKXzQO3Lq4HraQVm2GZ+G+VaMH/SOmYMFMASfZW/DsjPKRF6o2qd99toqVLlLL/yzUPOgX4bs0pwDcidcgu+iJcrvm2j2gWlnJQGJer8Gz5wGsHltEI0dUZN3UrVS21HiHDZCOl1NZZhiyNtGWInn4rB28N/IWht3uG5MaEGR+zGwb0jpjqLF2gRg8IB26y9JBdzF5cFSpHhqR322jbQlO4otKjy8AWp2ssoEicy3lRaqqH3evbVvrTTaFMMANOz3H6L204Wtodm2z8Sr69URp5S/DDc79o5ZaySw2I9duD3gYzpvMFL+rwDHfCEZ/wvnI53cUyy/iGoyNhr5Jkwb9bTO+BxCQI0EBY4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(376002)(366004)(346002)(396003)(451199018)(2906002)(15650500001)(52536014)(8936002)(5660300002)(41300700001)(33656002)(83380400001)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(4326008)(6916009)(316002)(9686003)(38100700002)(86362001)(55016003)(71200400001)(186003)(6506007)(54906003)(38070700005)(26005)(478600001)(8676002)(82960400001)(122000001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4dKXV/ME+0COIs9IFRIF73+U05DEdaYsHVuNuWdhv4xKwXaJLzmSDlsZnvqs?=
 =?us-ascii?Q?JKV4VGkx/lTy1Plw5TEdCJX2E5FelTOjGVTLB+7L2SqppmNSYAAA+pEMGm18?=
 =?us-ascii?Q?4s4nzLs7RVtxJU73fG9qFxs/LEhpgZ74hXq2WKzaTjmrM2DBXLd9wTa1+/2y?=
 =?us-ascii?Q?MS5ylnY1IKfe0JdQa9TvQ65XvJZMA6O+cL1TiYa9r6E27dXcCLCVplnrZSnV?=
 =?us-ascii?Q?UT2Q/5Sv30O3lp7j4GlYDgajupRaTIHjOEupEUeLopfyBgUUjNDoD4RdtOgJ?=
 =?us-ascii?Q?RsdQvOlWoXavUncN4y7/5f8T8HgeMXkcaGCMhhpow4swLGjIndqnr2m5gn52?=
 =?us-ascii?Q?9bsiHaLYGnz3NlOxDBOJbqBn8/dFKpZidZA5jMebGlP25xXqSNpYW60KQ0SY?=
 =?us-ascii?Q?Ds0oq/b3I8TOokFPGWoaN2O2jGTUXCdWZdapfUX6fZ9VBPzAOtHLJ/pc/OHi?=
 =?us-ascii?Q?5Nxco535I0MtIKdO/NXzQwuSC6LcF+BoK1vE4Jvx6TQqfmfXawjbEQAizfrx?=
 =?us-ascii?Q?429TtWlgGyOki92rRxNopwvNLEUytU3svTliWvwbFhuD6zwcyjWtLpxm6OaQ?=
 =?us-ascii?Q?bhH6hzD+COttMXckJ1a6HplzLDBWOKJ0LDaPjnjviwahHTVU6OJpjYaGOwjL?=
 =?us-ascii?Q?qwodOS+M7oexIYf0S5qG5E3kfrhF9eYrHDW3wOaTiW1V7+T4OwK4o+iqBdtf?=
 =?us-ascii?Q?ewMQU0C7GU1KkU65Pqh+vGcLXJk4VQRNx6LorvOhcNoYvX94DDyEjtpaLwPy?=
 =?us-ascii?Q?k2S3wLOFEnXsyJI4IZt95xszjXNM6YSF/ic3OrjCJEqy07O+L2DXhPxPr0ef?=
 =?us-ascii?Q?x3fKlY1nZjiNajcw/nAOYbfxmvMoW+2tRHPCZYUJq5/ubOgUwjuaM8CM7oN2?=
 =?us-ascii?Q?WgP5DDOEsM6AqpTAh9+sAfdVyfC7sPw/KOg36ImNE+4jwLRzbjgZmYeXhOHJ?=
 =?us-ascii?Q?mb4+AKm33CBr54KRbT/ZAPzXXlU6K7CMCFt5Ph5k0l/3nZV7qnw07Ghzwo9C?=
 =?us-ascii?Q?P79UUPpgZQGTBB03Vr6HgsPdGrfCX/dZeL11msJvp1ByDOFFUs39xtYPc/Kl?=
 =?us-ascii?Q?8qsGgX9lipMA0+0OnXBtkwH5rCKdHbHbZs7tIe70rtkKlWwPC8W6sDrhwtCw?=
 =?us-ascii?Q?SBAK6tI2YAb50SkaeMBQAIDx7qHF8SdACCl9LWQ9w1+SHvaOI6rTAmk5o6Tn?=
 =?us-ascii?Q?s8iOfx4iM6Av+IuABKUwaSyf0cMzeJCHt80CEgqM6IYeqhbVHR9uWxrATsDW?=
 =?us-ascii?Q?egPiYy64CARCJLomzp6+tjg02CdGPaHioCm4LFRnvjaaGlFL6KK/AEpxePFO?=
 =?us-ascii?Q?seygc1TOBxfPAu30WvAD7vDGV447a7fWOYIrZTsyZr6y2PXwwx182+ugs6C3?=
 =?us-ascii?Q?IqLON82yqWOLnkZZhVVog2P+9fatB6xmUjfiVfXRP+b0Mg4ooFa8wL2LyndG?=
 =?us-ascii?Q?X2WLs6Oi9MtuFBhlOAKmjInF0W5wJZPBsxzGLM51xEMu69kiv4T5Y5J3bp2B?=
 =?us-ascii?Q?zymkOyNPRb2WWJiLd+d9cIthM00Sk/kJz16kDeTDN/4cISel7nZEA5jlTW5W?=
 =?us-ascii?Q?TDrlZEbLOre9bxs3NJMt310gHa3H+u0/l1woQARX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d74789e1-c7b7-4d2a-041d-08db0a755e00
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 08:12:20.7099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jc+7qe4mNW0k9N/LD0FZ3dwXSHiG3n8YjpHmptvxF+VVI5CPvL8R9lD1Mi57MtfiAaUcGrPxzPUmnPmP60XJxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5116
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, February 9, 2023 7:22 AM
>=20
> On Sat,  4 Feb 2023 06:42:08 -0800
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > this imports the latest vfio_device_ops definition to vfio.rst.
> >
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  Documentation/driver-api/vfio.rst | 79 ++++++++++++++++++++++-------
> --
> >  1 file changed, 57 insertions(+), 22 deletions(-)
> >
> > diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-
> api/vfio.rst
> > index c663b6f97825..0bfa7261f991 100644
> > --- a/Documentation/driver-api/vfio.rst
> > +++ b/Documentation/driver-api/vfio.rst
> > @@ -249,19 +249,21 @@ VFIO bus driver API
> >
> >  VFIO bus drivers, such as vfio-pci make use of only a few interfaces
> >  into VFIO core.  When devices are bound and unbound to the driver,
> > -the driver should call vfio_register_group_dev() and
> > -vfio_unregister_group_dev() respectively::
> > +Following interfaces are called when devices are bound to and
> > +unbound from the driver::
> >
> > -	void vfio_init_group_dev(struct vfio_device *device,
> > -				struct device *dev,
> > -				const struct vfio_device_ops *ops);
> > -	void vfio_uninit_group_dev(struct vfio_device *device);
> >  	int vfio_register_group_dev(struct vfio_device *device);
> > +	int vfio_register_emulated_iommu_dev(struct vfio_device *device);
> >  	void vfio_unregister_group_dev(struct vfio_device *device);
> >
> > -The driver should embed the vfio_device in its own structure and call
> > -vfio_init_group_dev() to pre-configure it before going to registration
> > -and call vfio_uninit_group_dev() after completing the un-registration.
> > +The driver should embed the vfio_device in its own structure and use
> > +vfio_alloc_device() to allocate the structure, and can register
> > +@init/@release callbacks to manage any private state wrapping the
> > +vfio_device::
> > +
> > +	vfio_alloc_device(dev_struct, member, dev, ops);
> > +	void vfio_put_device(struct vfio_device *device);
> > +
> >  vfio_register_group_dev() indicates to the core to begin tracking the
> >  iommu_group of the specified dev and register the dev as owned by a
> VFIO bus
> >  driver. Once vfio_register_group_dev() returns it is possible for
> userspace to
> > @@ -270,28 +272,61 @@ ready before calling it. The driver provides an
> ops structure for callbacks
> >  similar to a file operations structure::
> >
> >  	struct vfio_device_ops {
> > -		int	(*open)(struct vfio_device *vdev);
> > +		char	*name;
> > +		int	(*init)(struct vfio_device *vdev);
> >  		void	(*release)(struct vfio_device *vdev);
> > +		int	(*bind_iommufd)(struct vfio_device *vdev,
> > +					struct iommufd_ctx *ictx, u32
> *out_device_id);
> > +		void	(*unbind_iommufd)(struct vfio_device *vdev);
> > +		int	(*attach_ioas)(struct vfio_device *vdev, u32 *pt_id);
> > +		int	(*open_device)(struct vfio_device *vdev);
> > +		void	(*close_device)(struct vfio_device *vdev);
> >  		ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,
> >  				size_t count, loff_t *ppos);
> > -		ssize_t	(*write)(struct vfio_device *vdev,
> > -				 const char __user *buf,
> > -				 size_t size, loff_t *ppos);
> > +		ssize_t	(*write)(struct vfio_device *vdev, const char __user
> *buf,
> > +			 size_t count, loff_t *size);
> >  		long	(*ioctl)(struct vfio_device *vdev, unsigned int cmd,
> >  				 unsigned long arg);
> > -		int	(*mmap)(struct vfio_device *vdev,
> > -				struct vm_area_struct *vma);
> > +		int	(*mmap)(struct vfio_device *vdev, struct
> vm_area_struct *vma);
> > +		void	(*request)(struct vfio_device *vdev, unsigned int
> count);
> > +		int	(*match)(struct vfio_device *vdev, char *buf);
> > +		void	(*dma_unmap)(struct vfio_device *vdev, u64 iova,
> u64 length);
> > +		int	(*device_feature)(struct vfio_device *device, u32
> flags,
> > +					  void __user *arg, size_t argsz);
> >  	};
> >
> >  Each function is passed the vdev that was originally registered
> > -in the vfio_register_group_dev() call above.  This allows the bus driv=
er
> > -to obtain its private data using container_of().  The open/release
> > -callbacks are issued when a new file descriptor is created for a
> > -device (via VFIO_GROUP_GET_DEVICE_FD).  The ioctl interface provides
> > -a direct pass through for VFIO_DEVICE_* ioctls.  The read/write/mmap
> > -interfaces implement the device region access defined by the device's
> > -own VFIO_DEVICE_GET_REGION_INFO ioctl.
> > +in the vfio_register_group_dev() or
> vfio_register_emulated_iommu_dev()
> > +call above. This allows the bus driver to obtain its private data usin=
g
> > +container_of().
> > +
> > +::
> > +
> > +	- The init/release callbacks are issued when vfio_device is initializ=
ed
> > +	  and released.
> > +
> > +	- The open/close_device callbacks are issued when a new file
> descriptor
> > +	  is created for a device (e.g. via VFIO_GROUP_GET_DEVICE_FD).
>=20
> Each call to VFIO_GROUP_GET_DEVICE_FD gives a "new" file descriptor,
> does this intend to say something along the lines of:
>=20
> 	The open/close device callbacks are issued when the first
> 	instance of a file descriptor for the device is created (eg.
> 	via VFIO_GROUP_GET_DEVICE_FD) for a user session.
>=20
> > +
> > +	- The ioctl callback provides a direct pass through for some
> VFIO_DEVICE_*
> > +	  ioctls.
> > +
> > +	- The [un]bind_iommufd callbacks are issued when the device is
> bound to
> > +	  and unbound from iommufd.
> > +
> > +	- The attach_ioas callback is issued when the device is attached to a=
n
> > +	  IOAS managed by the bound iommufd. The attached IOAS is
> automatically
> > +	  detached when the device is unbound from iommufd.
> > +
> > +	- The read/write/mmap callbacks implement the device region
> access defined
> > +	  by the device's own VFIO_DEVICE_GET_REGION_INFO ioctl.
> > +
> > +	- The request callback is issued when device is going to be
> unregistered.
>=20
> Perhaps add ", such as when trying to unbind the device from the vfio
> bus driver."
>=20
> >
> > +	- The dma_unmap callback is issued when a range of iova's are
> unmapped
> > +	  in the container or IOAS attached by the device. Drivers which care
> > +	  about iova unmap can implement this callback and must tolerate
> receiving
> > +	  unmap notifications before the device is opened.
>=20
> Rather than the last sentence, "Drivers which make use of the vfio page
> pinning interface must implement this callback in order to unpin pages
> within the dma_unmap range.  Drivers must tolerate this callback even
> before calls to open_device()."  Thanks,

Updated a v4.

Regards,
Yi Liu
