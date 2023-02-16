Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF85698F5E
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 10:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbjBPJKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 04:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjBPJKM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 04:10:12 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EEF5FF0;
        Thu, 16 Feb 2023 01:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676538611; x=1708074611;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2huVKU/DZOrRNQScGUvmmXUvec/KN1MgYhomuLb1+VM=;
  b=e3QPeVty1XQKv6okMsKyAvr2ufIuSyReaBBCT1TsSCe1jOheA1Teoys9
   vgrTQrz2ldbh8W01SfWRop75Qr2NS1J6xKDb2WXkyGhFHU3ruWpWDxVRS
   hSMXerNfqmCGpD8QZPdQpm86vcYrCjKk1zo9Y2Npgc0RemIJV36W/kwgx
   einKi7IsbQYogD+cSpxyz96HQCSHeZECRdRsugMJdSYsToeZn9o7APd2y
   XXwWZbuCRrFcPH52HabhNzD68jjIydzwAvEqZxohXqVzWbScppTk7dWD2
   g3EN8c8PeH0ezlYqOh7ZMqJNlr1nLZu8znm+umu2k1zKGGBmP4/wqCD/v
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="396309819"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="396309819"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 01:10:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="663390204"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="663390204"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 16 Feb 2023 01:10:09 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 01:10:09 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 01:10:09 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 01:10:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P9rR5ns0gbQheNo6sp7nSG9DgBupOKFm6w2I1T7iY2nppj9XwfwEIfw2cRS1naqbPQ88wQycJjIgCSM2hnLQbXXqLqoCVK8ZjptkbCwrLu0hgnlOsU7jZtppDr18m9E0wDLNXtK0KtXwSUtGyNnZ9zn77f8i/FHz3MRoe/GFHeN9chXQI5TnZyfmYBzDSJyqpCk/o2QqnvK8d/Dz1wM5vWslb4+PUOl2V6CfD9dSlIW2W9rI+zlQYfFrzG6rBPCw5o9c5lnmu5nUoEB4fKxB2XjkZTdtqjT0j6Vpf4KsgU6C5q0o9twsi0sDxtfYjUZeWrpYiLhaciKO+zpe+QUN8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=caVkzJFqF5LTAMuWsYTUQ0xSi3hbM1jzd1Q4mqqrqNc=;
 b=ZT/OjpbIQRoAZjzcOzb9zSItZj/T39ENGXgaquUbBywoSOtQYvTG+9QYP+p9dGftpdaHrprdgfXCKFNAZtATc6DwD4Ym9vf9XxrQaIowtLXMzApxmeDhv7aCq65OZ7nJHMRvICaQIksDicjRqf9xnREi3XVbzD8zj9xaG1mLRKrkLCK9009Yw7A98btYWQyfk7kRpDuB3+wrNeXzpgy5tfummNaLWoJGPiNr8OjdhYguF5sPz04xW60eH4WMzQBPLk26CvulqkznB1F+rOYnQhUXsJgDyZgvjpUGWeftBxTSDb6au5fJ9eUH9nndk8LlIDTJbI/JGc5yHxmekIJp0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by MN2PR11MB4549.namprd11.prod.outlook.com (2603:10b6:208:26d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Thu, 16 Feb
 2023 09:10:07 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::13ce:e90b:7753:6c2c]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::13ce:e90b:7753:6c2c%5]) with mapi id 15.20.6086.024; Thu, 16 Feb 2023
 09:10:06 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Thread-Index: AQHZP73TMP7ZzqInoUK0sXtp8iwKVK7RQKyAgAAL3yA=
Date:   Thu, 16 Feb 2023 09:10:06 +0000
Message-ID: <SN7PR11MB754074DEC60C9852D42EA4A6C3A09@SN7PR11MB7540.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-15-yi.l.liu@intel.com>
 <Y+3oObuMG/v3+x0N@yzhao56-desk.sh.intel.com>
In-Reply-To: <Y+3oObuMG/v3+x0N@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR11MB7540:EE_|MN2PR11MB4549:EE_
x-ms-office365-filtering-correlation-id: d2b2a329-31e3-44c5-8817-08db0ffd9866
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cmCZxNs+mdQdMo3iRNMuwsbO9JTMneBoTSG3FzOFlI2cGmjKp415WAHNP1R0mbmMjVh5uC5tIA0UqjYEkG5mjt5CIywEZtGAI5RDFZAPCRmhgurYlOLyyEOjOwll7Wc4K3XdMCdo4TohTmmyQ0Kdiqi2xDiSuCnJzhiT3oRj35TVUUolnXmWU5+5gG9Z9jJCafvYdvCRcdxucREnW58DbuJ2qhPAveFeD58AG/e7kwZGIlZkEgMBHvkn65p90MKCEIJ5QmTt13/BQT11ew2e1GJC6ug8awmrHpgwIXOYdQC5ZD10AY++moQjvqPhxRIFAZfkcXCtm56W4im0GXRa8zA6CxBAoG+IU2OfxkzLSlKY3zwNgE9A5dxs2a3oT9HM7L+zq29/z1KTtwfr9+hxZPY2crBNu0eH8bCkRcNM8QmDBfGaCCdgDhFgjqxU2RZeshg3YM4WjnK9m0WHcXzZe/g11Rdzt2zDtrfECXIJbe0FvVkqDc0s4EGVkpuYtjVG8SsfYWiRz7hq92xhZBd/72jGns46itJHOLAMyFjr2Gaj1QfZHDN3Wyk2MBvwp14ImVE0RVUJZBqppOlM5sVvpzBELQSVowDOCJyTHiSF6A0fPn+0zG9gTdpATBkxLDgUqzktRJiKmCK1Ho5y1AKYfzAur6+ZfXOp5hBTiEVL4kUiGN3rfsDRlQFVsSl+N97iT8ZZTH3UVWFilFzpkG9iqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(396003)(39860400002)(376002)(346002)(451199018)(86362001)(6636002)(54906003)(316002)(52536014)(55016003)(8936002)(7416002)(5660300002)(38070700005)(6862004)(478600001)(76116006)(33656002)(41300700001)(66556008)(4326008)(64756008)(8676002)(66946007)(66476007)(66446008)(186003)(26005)(9686003)(6506007)(2906002)(38100700002)(122000001)(82960400001)(83380400001)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YU6Vp1n7h01zEWmdrNuSoSWZ7UT2/xrfAjG2Fg7atyLLPJVttnod2QZd46Qp?=
 =?us-ascii?Q?cQ+RFOUbOrLAsNgI2Yo5XPSeDOIdojWKrLjYsUs6cJ3V9BV7zdTg6qtQnaau?=
 =?us-ascii?Q?1IlYHvy0Hbpd2Kq5KT+2/Cy3p4e83BVviOZjvVdmHTFMPwCuu6CJXKOGEWUI?=
 =?us-ascii?Q?DBvtVeDi2o0nE15iKSEdpsCBXS/VwHUhlDd5L7bZ9t5CmB+ZuuGWpebFpI1c?=
 =?us-ascii?Q?IphMqwiS5LQ3eD5dz8hzQbpdpOhHQWqzcB3MJeo9FEEVhnqoKQB8UShMugKB?=
 =?us-ascii?Q?QhqIbFHMA8RKwQlpOwuasXYzXNv6uRGWsHo1t4tdVhNpnIIRsd8n05nNBg7w?=
 =?us-ascii?Q?0C0T2EyQF1t7Pz4uWHb1KH3OXd5SyCif6O5bgvVavQBlvUXz3gSa4ic9eZ28?=
 =?us-ascii?Q?FH12mqQvhT9KdtK1yycVXzZoLmlkrD2mimkjsoGAnZWHlEOUX//8tg8LTT/8?=
 =?us-ascii?Q?wXnPY2cLDwN7xzNs/E49GON+fcA88dpbbCnFErSigIYICLsxiZxqPZORulFw?=
 =?us-ascii?Q?WFBWplnQX5B9H0eE48CdFGhh7uTtPd8CKDW/w59l8IhKYHx0xJoZ/sKkOTbU?=
 =?us-ascii?Q?MLHzg40/tpC7uUzDZtlqktb00Fc90YvhA9eDJfPhnSC/Z0erY9nx7N1yVPL+?=
 =?us-ascii?Q?f3BfScffIh19wqFeoQ8kfATqdTBLWJMN1bJskrgESzTO9mkBOmfL87tBTnVu?=
 =?us-ascii?Q?MEdqQ2wmesIpQlcLo1O5Dk3/Lob/Dl6lq/+nG0tmUGFEKPZVxCz74umsMnPU?=
 =?us-ascii?Q?qlMz5/65R6TVUcchgj3Qqy+lqoR7jsTFmtmcGBTsANi9o56JGyRsRMiiaZRD?=
 =?us-ascii?Q?I1Ku1lrSQnuvq9HAOitascRSDzoqtWMgwMU7khxBFIxPhdVXSdMEAXMFNHBS?=
 =?us-ascii?Q?rdrp6xS2Dyy9TZ1X0PQnQRdhs+LxZ8i8qvQkl3yZKfe+z6B2pO87jgfGI2LV?=
 =?us-ascii?Q?UwOLNdxFeivRNLEtnOY5nYZtlyute126hSEjQxQ0aMS2ocaDkO1+6N6SW+yn?=
 =?us-ascii?Q?nyV7tjnp5sINpUSm5KHOo0+A1zBVG66EY2vL3FiotbH4LRrz2Ap2eivwiFSP?=
 =?us-ascii?Q?RhTZtjxS9V7Q3rHPxOePGvkMrVo5j6OPSLHwqO1jCIwmoLkfBMTKGSM1U4KO?=
 =?us-ascii?Q?NIinD6gz0oU+DH24YFLZnGRwvgHjTk46aAnZ2FDGbyrpbEj9Fa1AYCTVJc0Y?=
 =?us-ascii?Q?s4yOEIFf+NMtnkcdFCrn8tvTCMhvsPqsxB+Srh/Jwqnd9UmjsF1t0oFkWxTq?=
 =?us-ascii?Q?NL5Bn76T8mDjzvEq+L6RM4xKrlapGOnIBBIQR3wGs1P0OncId9KTT7fBuw8N?=
 =?us-ascii?Q?ClD99cV3Jbqwzc9kuBDcvVBNBmJmkLJrlELNbkW2fZOAiGtCh/hlOdW9n7O9?=
 =?us-ascii?Q?6sTf6UyKkgLuZbCHaKi75DYWqLxX3r+uRD0SOATukNAVWkVJrOsb7mI2eVNw?=
 =?us-ascii?Q?ZE3hS3Xhxq0E5QVDmkLA/rtHahMsPL0ICM4oBpP89u0NzWAf+uG4ZrU0iuDX?=
 =?us-ascii?Q?2NBYLDZQx+Ew5IHMD42VOcoExmQn71IYSXzR7clyn+wviIAc47zn3NA9hPcJ?=
 =?us-ascii?Q?GHzl/mYXkNFbIllJDZLIRSLcpIp3CSWQVxzaTvRU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2b2a329-31e3-44c5-8817-08db0ffd9866
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 09:10:06.0587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iroCEE8sK1TniGJjtHBwI+K6ob4VYxY1L+VJfqTIAQFt92FzoXSDl0sdq88ZahmIiMXXhVuq2mW7IZqNtlPkLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4549
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Zhao, Yan Y <yan.y.zhao@intel.com>
> Sent: Thursday, February 16, 2023 4:24 PM
>=20
> On Mon, Feb 13, 2023 at 07:13:47AM -0800, Yi Liu wrote:
> ...
>=20
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
> Here, the iommufd file count + 1,
>=20
> > +		if (!f.file) {
> > +			ret =3D -EBADF;
> > +			goto out_unlock;
> > +		}
> > +		iommufd =3D iommufd_ctx_from_file(f.file);
> iommufd file count + 1, again
>=20
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
> iommufd file count + 1 in iommufd_device_bind for first open.
>=20
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
> But, only one file count is put.

Good catch! Yes it is missed. And needs to call iommufd_ctx_put()
in vfio_device_cdev_close() as well.

> Need a paring iommufd_ctx_put() after a successful
> iommufd_ctx_from_file()
> above to avoid iommufd_fops_release() never being called.
>=20
> e.g.
>=20
> @@ -1222,11 +1226,13 @@ static long
> vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
>                         ret =3D -EBADF;
>                         goto out_unlock;
>                 }
>                 iommufd =3D iommufd_ctx_from_file(f.file);
>                 if (IS_ERR(iommufd)) {
>                         ret =3D PTR_ERR(iommufd);
>                         goto out_put_file;
>                 }
> +               iommufd_ctx_put(iommufd);

Since iommufd is recorded in df, so needs to hold refcount till
df->iommufd=3DNULL;

Thanks,
Yi Liu

>         }
>=20
>         /* df->kvm is supposed to be set in vfio_device_file_set_kvm() */
>=20
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
> > +out_put_kvm:
> > +	df->iommufd =3D NULL;
> > +	df->noiommu =3D false;
> > +	vfio_device_put_kvm(device);
> > +out_put_file:
> > +	if (iommufd)
> > +		fdput(f);
> > +out_unlock:
> > +	mutex_unlock(&device->dev_set->lock);
> > +	vfio_device_release_group(device);
> > +	return ret;
> > +}
> > +
