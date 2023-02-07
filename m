Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D4E68D0EE
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 08:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbjBGHvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 02:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjBGHvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 02:51:49 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81883A9D;
        Mon,  6 Feb 2023 23:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675756307; x=1707292307;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2oTZboRbyS8EWg/IDGFFFUcVnHuNW4Jqd42K8IFMETI=;
  b=L3GvXmn+3Wncg7sBeXgdx0Tpe4B/zCu9bQ95wSduRSe1V3lciqswMVZV
   HdH/qBZQVnfWSpNEDLxKp/XIn3qddIA8IS8mzdYN4qUawB91cCMmxj4Av
   f59Zm7XoB93L3VvfxA5PGUa71RB6o3yHlfJ1gGnrx3MGnR2K9mIoFe9z+
   TLFpHeNfl/l4+Iu/bssJS6zn73AGIyQvqC/8WMLAIE/86xqRoya107J7P
   kz/skL/DG+z7x8dXFqaXAvua8OTSgu4RbruGtPcMLc0OuHqKLImM9DUqG
   jGJ4VpKAK4iU9CB3SQSVMQVXvtXrnf9pAQMb0zVvCs+8mgmQyHJWui1zw
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="391828728"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="391828728"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 23:50:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="668699543"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="668699543"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 06 Feb 2023 23:50:49 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 23:50:47 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 23:50:47 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 23:50:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nVP6V8l5FAprc0C/ly8J+XNc5WKOFgtJg/nPSkbZGoJg1KbBCukOyY31+ABqsOSK8ly3+yHSDlMmAoxUVke0XPGwVRWW102G4k9Nx0A5G1wyq5NUDP+a8jUPDDgSoyefK7m++1OGfTXfESK0rYvVr7k1itiJWuOVXGFNHDOEv9l6bID2OvcSKfoA2v5BFcCoGQmJRt1mjQfhYpkYZLahIzrO2b8Vjqg2XI3q3HPpGKIGaR+ZZi4fGubxVhlgNrcrRjPoLOAvNpLr2s8dcgSdhnSzLEjlEtcphHbV1TlO26+ms+/DWpg3SB1vUhbw15dLl6/Zzns9T3uffQ2FjjHtOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fVfHXVQsxGaxKgCWj99IoSHwhLMkN/eDTqwXfoWS7Bc=;
 b=Hdw0jYfBpSZTdeCYM+RZcdaR8lGX7cKGhZwEmutBv5ZAUeKNjkFphy8Af2rtaOZsWB16xHrY3aEyOrWKY3inaipiFlWqDbgSAXpbY4AnxPkgYxlR+bp34F4P7nOAmXO3M5BvfijPVMyp9CC31tAj6ZBhIEkRe9wI3YwdBCRX8A13Cw2HSfaBVT+AtM6/rr87p0IQXm+I85PCU33q6U6IzQj5AMMAjv3bKBbbHFb8pF67l6u2QmofRSzyqeQTBekKDWUvGCi8a/3f2ym0QQVErJeOLDzdYliJ0nyAopADocK6Mo2nexdAyeBABZWxep6GQ/UD1WxcMWp3EO7dbnrXuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH0PR11MB8087.namprd11.prod.outlook.com (2603:10b6:610:187::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 07:50:40 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 07:50:40 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Subject: RE: [PATCH v2 13/14] vfio: Add ioctls for device cdev using iommufd
Thread-Topic: [PATCH v2 13/14] vfio: Add ioctls for device cdev using iommufd
Thread-Index: AQHZOgpFACxvcC0IEkiFAGPnOf4DEa7C1/iAgABFGdA=
Date:   Tue, 7 Feb 2023 07:50:40 +0000
Message-ID: <DS0PR11MB752976AA5F3F5FF6A1CC246FC3DB9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230206090532.95598-1-yi.l.liu@intel.com>
 <20230206090532.95598-14-yi.l.liu@intel.com>
 <Y+HIWRM/TjWcuT6I@yzhao56-desk.sh.intel.com>
In-Reply-To: <Y+HIWRM/TjWcuT6I@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CH0PR11MB8087:EE_
x-ms-office365-filtering-correlation-id: 7882da83-4530-449b-5ee6-08db08e0023f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QXaR5Gt0EXwRLdQ446p/UUFPoRAOW5oKlaK38lIpEVwuOOloeF9LgiLI80QWuTvIZK9lq1uTlyxqjUu+SFTnTeQe4d361xah7KDUt9T9JGK7XjBcLT5Vt4STHcsUzwieADY+5KlEEyy7BDRPkut9B95Ega1ynXmz+B9dqbxAA0HxC9Zbc5tnAQtrwxeKoxlLSqRK7y2A7T/SkAOtBwCuSwDA6RTmIrIlTjV7FjwEwwtFsS6q+iFpO56SYveMToLdRjk8qee0J+PlehbsKgjIPGevNjfjhy7M7R+rRKz5sf96t6PTMXCQ1Tq+s9uRqoplNlZTiYykFSoU4XlAlWjVyIUsKVErEkrZ7KRqYmAroNjZMLTgpwn0UDecvbaTH9Oy/KqfX9Bl5xEv+XmIAzW6XoSer4t1KDaoswBie6s2FSWUcuJd+Cg3wDo893Mt0xnKxld7AkbIHUtFWd4VTxo6WhMeGVydfCOqdMLYS96vSgUlP4h+LDqly/X5Rf6oNPqDuQu2rrS0Wun3YV+afVf4PIswVUQKDEFHOraJNOgNrhuP3A0NjdbhktJSbVrSiPS51upsQO7IhBWZKxBGhLwMOLweueHEhOoLQFzFX5DR3c3RC0fG1pC9/1K/sxMsnoXQ7r6bkvyVxPWEJT3N8fPAuzeDzAXV6G3kASoWAWUhofXco/IIN0iy0Yzd4KSSECrkaX6WcpZHmRLYP1obEbNvqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199018)(33656002)(7696005)(41300700001)(7416002)(66946007)(71200400001)(316002)(38100700002)(54906003)(6506007)(6636002)(6862004)(478600001)(5660300002)(66446008)(52536014)(2906002)(66476007)(76116006)(8936002)(66556008)(4326008)(64756008)(8676002)(9686003)(26005)(38070700005)(55016003)(83380400001)(122000001)(86362001)(82960400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kyASksqwhQ0HR7J0veWypp9c8dUVfeIfld2g1Qa5ZhY3R8MWotSpn7tzorDu?=
 =?us-ascii?Q?FrgMoLtQ0RUzLpSNyqtuT7b7YPg3EZ8HW/nCog5dF24qpPukfeWdXX3wT6Ky?=
 =?us-ascii?Q?np2H+uPwEfzotiVmhw1yOhFBrk6L1GQC/tEPS26xmt3ZoJmmisTf43Al8O+B?=
 =?us-ascii?Q?RHLF6KOBe3ioPIi8MmToL4u0rmyrY8PZfke4qrUkOnsx5bL5xox1jgecLqok?=
 =?us-ascii?Q?q7RQzyzZKK7GhpEPvkRtdoC9uTNJoOGU4U0hjSbvF6G92Gol7cVBt+wSdhny?=
 =?us-ascii?Q?RoPbtJaDgvqrwmsb3wpDlyCm2Ysv/xCHgGrWgKVVkpH3V545ncMmjaS1Sd63?=
 =?us-ascii?Q?R2J0uTRpizvGKE3iw6+Z7++SdG8w9nzp9E9VjuBYZvRQcfLaZjLpf1fuSKx5?=
 =?us-ascii?Q?1B1IiKYUukeIRhhIwzy3ISS8SP4FO6So0VlhigX1YjrTtpPolqyJmvV2w39K?=
 =?us-ascii?Q?x50EEWUnF36PTlHJ0hCMSUx/Ust+ocS3Pa4hiPiZ2RT3ihqF+Ou0Gk5MDZJs?=
 =?us-ascii?Q?pekVcR223v+iYVCkHDb+VtBGyrYnXclsW8R3gQv17Pj/Sg555PCKgAx3my7x?=
 =?us-ascii?Q?Xoozqp0SuTHE5emE+BH7E7krtACi3gOcbB1jYrAIMnAQbJ7r38RPrFuXIvSW?=
 =?us-ascii?Q?cEygu7nwmQvToaFloOj5bJ/q1Xag439WWb3ngZH6AQ7VFx/QaPqGQ/sOv/f4?=
 =?us-ascii?Q?uoDUwUXWGpYeRq0QRBhNL6j12tdmiNWH2C+gIT9wYr3aYHdk9FupMZHHxfid?=
 =?us-ascii?Q?dK/PHz8NMx3S7dFRkpiDPpc8MAolKM4gEv8mftC1IoAVvXkoRkBGP6CHFDCV?=
 =?us-ascii?Q?ebnYbPRLrQtQkj6ZDN72c/kFFdLsB72pGdBh+jY7azpnxIKuGr136DOles3D?=
 =?us-ascii?Q?P4Sac0D3padlkASTtZjxyNqlYDao91QySECTzk+jsh+eoHCi1BNEaWaFvTCb?=
 =?us-ascii?Q?jhy5WsKGARRi0WvZcVz/EsSm0iN78jlhFPzOWtL4OonCbJ9wlW1hI2cdvrB1?=
 =?us-ascii?Q?H8t2jZry8UNbI0kvlxADZ9tKN7KTBE4uMncJoz9xmR7qSwtQ0imxTDkP2CId?=
 =?us-ascii?Q?6NWjzEbL5iTyxWkIrxgpqoibb1tkVncuRLFdmhiLB7+xHvrEIzibKjNOUyew?=
 =?us-ascii?Q?9gZ+zivG91uA6o7Q1LLBjRLVoYVOR3k3PWeOEAB408gMXfEgqH/vFNEfRYJP?=
 =?us-ascii?Q?pIMhB3de2pB/qeK/HOnP9zJS5AvmkLz3ZxwvIVwByY8ZKG5Fsg2npdUahKBQ?=
 =?us-ascii?Q?ELaLWfzar6t9oPcLlG9CsgwGXPCa29epuGcLgmNYlrIqHwK6wLMqZ88Woc2a?=
 =?us-ascii?Q?+gSdAZ9thnpgNso0Rn2aMDiigf8AftkKGCDkG3leUBB3jVETDH8aFWQ7egll?=
 =?us-ascii?Q?Z06afHd3t+Q+cDeDPrxeYchrcplwh7hyqwczNGTAPG1pZBm5BpblopFtOOKa?=
 =?us-ascii?Q?xUrvO1VZ6UM4T79ak8pEJQUebUtjEoNDh8wgP1N9jdFXp7UAeyj2PxdBKe97?=
 =?us-ascii?Q?qFxpZvxpiTw+7c5w+Xyeacm2nSH4mFPXBS5afHLjK2+rLVvzpP2qSGfrQKZe?=
 =?us-ascii?Q?squTYEkQf9QFRKxFZe7QIsO0TQHGTZCJLquaznJk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7882da83-4530-449b-5ee6-08db08e0023f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 07:50:40.5836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fH8/FEPEwC72SUNhphB/8ps1jALN/GYhWOqYlVVK2fiCUpUXLTX4Yy7NawKxrOrga9x8kZSySlVVpRE1uWWJFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8087
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Yan Zhao <yan.y.zhao@intel.com>
> Sent: Tuesday, February 7, 2023 11:41 AM
>=20
> On Mon, Feb 06, 2023 at 01:05:31AM -0800, Yi Liu wrote:
> ...
>=20
> > +void vfio_device_cdev_close(struct vfio_device_file *df)
> > +{
> > +	mutex_lock(&df->device->dev_set->lock);
> > +	vfio_device_close(df);
> > +	vfio_device_put_kvm(df->device);
> > +	mutex_unlock(&df->device->dev_set->lock);
> > +}
> > +
>=20
> ...
>=20
> > +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> > +				    unsigned long arg)
> > +{
> > +	struct vfio_device *device =3D df->device;
> > +	struct vfio_device_bind_iommufd bind;
> > +	struct iommufd_ctx *iommufd =3D NULL;
> > +	unsigned long minsz;
> > +	struct fd f;
> > +	int ret;
> > +
> > +	minsz =3D offsetofend(struct vfio_device_bind_iommufd, iommufd);
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
> > +	 * Before the first device open, get the KVM pointer currently
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
> > +	ret =3D copy_to_user((void __user *)arg + minsz,
> > +			   &bind.out_devid,
> > +			   sizeof(bind.out_devid)) ? -EFAULT : 0;
> > +	if (ret)
> > +		goto out_close_device;
> > +
> > +	if (iommufd)
> > +		fdput(f);
> > +	else if (df->noiommu)
> > +		dev_warn(device->dev, "vfio-noiommu device used by user
> "
> > +			 "(%s:%d)\n", current->comm,
> task_pid_nr(current));
> > +	mutex_unlock(&device->dev_set->lock);
> > +	return 0;
> > +
> > +out_close_device:
> > +	vfio_device_close(df);
> vfio_device_close() is called here if any error after vfio_device_open().
> But it will also be called unconditionally in vfio_device_cdev_close() an=
d
> cause a wrong value of device->open_count.

Oh, yes yes. Good catch. Vfio_device_cdev_close() should check either the
open_count or access_granted.

> df->access_granted in patch 07 can also be of wrong true value after
> this vfio_device_close().

access_granted will surely be wrong if open_count is not correctly
counted.

Regards,
Yi Liu
