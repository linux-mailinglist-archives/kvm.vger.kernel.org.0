Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B216A840C
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 15:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjCBOUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 09:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCBOU2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 09:20:28 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFED7EEB;
        Thu,  2 Mar 2023 06:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677766827; x=1709302827;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Px08nKtfqpCpdhJgghQxl3IrON+OFXjnrxHI+hG8uvI=;
  b=G1ejxmRbS2RIBpMmkTs/YRQj7xwtEgj7euJaY4eYYnuUVO3Kiam2of6C
   m6bJ1hwEoRBxq6ZwKir2uz73AyAe51Ef8mdYfy8QTJDIw4iJsgTny1qoY
   8atYb3CFjFePuxLW9O1k9ucuzd4OTM26x6qBdoVtB0bHnKim0cQG3sVpb
   MonTPLCnaAZRbeKtRSrTSAGkvkICbXjP94ghlIOw1Q4Y0h6RE2kZXOBIv
   REOcmA5IsTGtJffPE2KHy3K3xLO4jQ8cdtjwx+IYmjSArtKBFhwTnJypp
   axjd864cvkPTP+CcXNiEbqYasQ4BwEKc+vTB+EtKHXmuQCTj6a7UEYlJy
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="314392205"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="314392205"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 06:20:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="705272150"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="705272150"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 02 Mar 2023 06:20:25 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 2 Mar 2023 06:20:25 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 2 Mar 2023 06:20:25 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 2 Mar 2023 06:20:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5139BDzp7jSq1rHUsyJi4AgoeS2UED1Sz0K/cy9U2JLu9PHDu+8gbIxkYQxBZH+miBl6/DKc2UADoCDjjUswNQl6PnPN3mu2Z0O5uY5sFWcFTdCgfmAqgAkpbqzU64iBghGuGPH3YlFmJWS0DoYctaY2gYw99YDI/OpNCPjEwjoKb6vb5gkiJ062OXqO4bLWGDwkFycPlzY9aVZG5gBsK7RJJcznI2uazP/mye8TLg4uaOFSV4D6z8VCD6LqmBobrLZwBvlA+gqyRAMjlz4qfhy/uMgxq0k17qyYb5RdZJdJqUcEe43txJDUYMSWvdYelUaQyahw18XRHxfnlTl6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=844IlgL3KxtqOz4YwuArh2LwAAyIX6FxtpTMJkBrSrQ=;
 b=SJiV5Kw0DGV/VuYuloOf9epBm2ootaS3eFFXUoREa/Y01cpycZ2Z83JWRyCAyEIpxHkbFD1oStN8s72s9r6liVf6aJae53NaXjDzN426EHFdlePSlxqBf698bA3h6ZkiJGZUyFERsHwiFB2kYlI2cDuCzeD84KsU0LfPkwHZO0Kxn8OHDNKqpEKmesbmpEWzZjVFfPkQX7NgqLDkSwdW599od8tPDWNz8V1IyWcNAVUqwYyK542Ke9dueMXHfISskjlWpuxu/IamiquXAMOI0p3u0V4gscSJiE/ZLlo1IblT4ZGGnRa6ezen58XHd/aSV0fksi05zBF16/D4cGZaxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB5577.namprd11.prod.outlook.com (2603:10b6:510:eb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.20; Thu, 2 Mar
 2023 14:20:16 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6134.030; Thu, 2 Mar 2023
 14:20:15 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: RE: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZSpxNz0d7VXviIEytrFhyB5GUvK7m/3jggABFoQCAACyCAIAAGw8g
Date:   Thu, 2 Mar 2023 14:20:15 +0000
Message-ID: <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-10-yi.l.liu@intel.com>
 <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZACX+Np/IY7ygqL5@nvidia.com>
In-Reply-To: <ZACX+Np/IY7ygqL5@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH0PR11MB5577:EE_
x-ms-office365-filtering-correlation-id: 162c02f0-1578-43e7-344b-08db1b293e60
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JH/nO0B9OqqKsGSSI/MfyrhQbXV8O9kOsRjMl2OAPYhnh/iF/6SUQL4JBmB3wVdPTXV6rZUux3OjVAA7SVuJAnSCv+sFSw6R3Apg8sGx+GbELiNYIHpKzxkhN2Ad8y6IbII/3qVES1T+xeabo0IGSNCUqtqR0/5haNiiwntr2UtcW/2ZfMxFyBW58hXuK8f1gzYBRjxK7OqZPY0OEVl9HwrOzdKCt87W0tgGbMJPyPj/VvXF1z8H7yGTG7HWvuRy009k0DfOvrNtKtpNygSyZ8QTIVoZzPQVpEiIAeqYRW9ZHCmiJf4gBDdBvyc43s0GIj/rcCr5rDNc9d1hAcS0poTXr6QFVwSt5N2LmXM2xFLEkkw2eouzNJnOaRtlgF09KsYd2NnU/XpaIEuuPTVsrwiNVij18OmobOBAc0BFN9EHE/YJGgAryx3VYDp4rPIp2QEZfFr3BaZKvpCeQZ6FubzUR2wRH89mGbkdZFJ4JVvc+J3sVN5nKleSjSTrk2f4x1oCtVJ/OX8+0iJsCDrLJiBxr4uAbsFQp0mGg8fklebm6Y2TSLOkQdh6zA6bisGxem9dfkzyrRYvY4URKS3lWBb+RdO5OI8HK6vqlbq03YrZCIKqlVl8A0vyXeZz8+fOx6eL9dB6fPQcPa/XCJkTFs8FkYJtP9Op7wfjti9qI8iCeDCN0QfD+ZPPlhgNBGJzZBVgmhB3Ki+1xpSBNC2Drw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(366004)(136003)(376002)(39860400002)(451199018)(186003)(6506007)(9686003)(26005)(41300700001)(54906003)(6636002)(110136005)(4326008)(316002)(64756008)(66446008)(66476007)(66556008)(66946007)(8676002)(7696005)(2906002)(76116006)(478600001)(71200400001)(8936002)(52536014)(5660300002)(7416002)(82960400001)(38100700002)(122000001)(86362001)(33656002)(55016003)(38070700005)(83380400001)(66899018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xbGQs6o4M4eurJolKdZQJt9TPjv24yvpge7EZSgt2be6siGffiYz7/JUmBuI?=
 =?us-ascii?Q?UCVVTpW0nbKuh6QvFApkCodi7jlcplRGG6JJA3lUgJ0Wnw4sO8l76HRRKW76?=
 =?us-ascii?Q?LNC7ij7qYpcODKjS6DKFXw6gd7tzBgrHhwErVHhJ2/8vEKzOLmjE3Ie8Viy1?=
 =?us-ascii?Q?ho0LmcydIHDsdSbot9jHUr/ZfaLzdAFrCy27BhhSoeAkVdHglnRFC5o2rLLx?=
 =?us-ascii?Q?oeXyoaRoyBaqedF/q16Sgnd/fzLNeVxpO3TjPJI/zx2jNwXxauIw2ShFcVp3?=
 =?us-ascii?Q?TVGPRQS15IX26ehnaRgO/hJGZKtbgFhnR3JRdEABQ7uO2jLfWoKLTq/HFQZI?=
 =?us-ascii?Q?gS0C1DDCxIwo4caZ524CwTJQZPdUOuKq8V58+2j6N5NiY6pIuq151cDwTbpm?=
 =?us-ascii?Q?2qbNazo6znWWg0UtpuX7rDrQbCMNieNM+6EHZBybsH1YKv43j2MTh9HxqG13?=
 =?us-ascii?Q?Jv4P0OgK8lz7WR1ycqWTrvhovhMwNuLwF7wb7mYd8MItJMD1MDNh/+hBIVDB?=
 =?us-ascii?Q?1r5vIhiiRLt9IJCxBP/1d0NeF7sueLq+d4xsiyOjoSVH0tGZhPXQOxPKqzVr?=
 =?us-ascii?Q?3zagw2WRiTwKeXtuyTjfIeECk/tgN582mkVX4yx68V5qzVB+nDf+xRs0OauE?=
 =?us-ascii?Q?c2e/IdDBbsAWkGoyDwZUOJ7GHKoqMhLy7kqLfgzrtOG7LG5t/wlnmbg/lWzy?=
 =?us-ascii?Q?iHV9iTWTlOAK9zrgQnQQfm4nW5N8W8iUXWOjV+UjpRHeSj1tqa3TKMUNNeP1?=
 =?us-ascii?Q?y3voQy+myR6Dgd4JZSGQSIPlFq0LRK3cNdTiYMglUtHGZchGtPj5gH8TacpW?=
 =?us-ascii?Q?J3g8bNkigk7ETr78/p56oTQCAr6tzPWGv8lggtlNq7foKJDTYVDfH1NIeQUP?=
 =?us-ascii?Q?s91aUiVZEjSiolrknED4sk361S6x0mHfwgotJvDcPQKBZsKOntXUyZvwJblK?=
 =?us-ascii?Q?WSotYPId00pYnGum4EwmTqxwa3BGtYOHsBgpoFneDZbmXQkg+IyrvA7W0k+L?=
 =?us-ascii?Q?sdT5eq/t4BAPQborUBZ0vxf+05B6D2K/8Sbd7dC5ANUQYLjAlLj+UL2xOX8K?=
 =?us-ascii?Q?Q0SuQZZZBKEFn27+iVz8jkCr6Zb8m0AEMCJNHSyGftuiYGXT0lXA7uttrCwM?=
 =?us-ascii?Q?LV6F6XaUYl6Zr1uT91GxNrAZlsM83m56C5RiK3/dOpw7nUP+r1+Hr3ps2Bi9?=
 =?us-ascii?Q?ZYPaIhqXXFlbUFrd3QsHcDrBiCoq+vT6CqKe/hWGme8EQDEkVYVWLBQSGzpV?=
 =?us-ascii?Q?hv8qFuwKUaUjxOtIcLWiuAEBnXAqTyZYn2rGRCmbGJxzRO0fHO4OU4f+pAZJ?=
 =?us-ascii?Q?Y3WNJlj03Z68rgJ6HiUEFq5Whp9kkZaOqw5YJ3/baQmL6d98g7nI3v0GmWpv?=
 =?us-ascii?Q?CCY+itfLdTEyYOZ15Qfb7IbMBiiRGYSGik1HJeFrsus/fScD8aQQGLDe5j/X?=
 =?us-ascii?Q?vG2lpLyExRZkICZOFbtT5PTDH/QDi2m2gVGsHfDL/Zca1Q8CKHPGmaWr/4/J?=
 =?us-ascii?Q?7zm2gr9MeywcAfam2LIcbZ6SNHwjtCTbaRM5rMhAVA+LrGAKBoWO5Y5FsSNF?=
 =?us-ascii?Q?CFYLbFUi7kk47W7EAJhKUEo8D7nW0KwGDO3aQeyC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 162c02f0-1578-43e7-344b-08db1b293e60
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2023 14:20:15.7002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9CORiIV1A71Gf1117XA2fipTGNVOxOSZwnJ93ftXZRKbmpfIkB/fK4iEfTmVxsTofxUtFjkmxyHibt2Z+6Tbug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5577
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, March 2, 2023 8:35 PM
>=20
> On Thu, Mar 02, 2023 at 09:55:46AM +0000, Tian, Kevin wrote:
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Thursday, March 2, 2023 2:07 PM
> > >
> > > > -		if (!vfio_dev_in_groups(cur_vma, groups)) {
> > > > +		if (cur_vma->vdev.open_count &&
> > > > +		    !vfio_dev_in_groups(cur_vma, groups) &&
> > > > +		    !vfio_dev_in_iommufd_ctx(cur_vma, iommufd_ctx)) {
> > >
> > > Hi Alex, Jason,
> > >
> > > There is one concern on this approach which is related to the
> > > cdev noiommu mode. As patch 16 of this series, cdev path
> > > supports noiommu mode by passing a negative iommufd to
> > > kernel. In such case, the vfio_device is not bound to a valid
> > > iommufd. Then the check in vfio_dev_in_iommufd_ctx() is
> > > to be broken.
> > >
> > > An idea is to add a cdev_noiommu flag in vfio_device, when
> > > checking the iommufd_ictx, also check this flag. If all the opened
> > > devices in the dev_set have vfio_device->cdev_noiommu=3D=3Dtrue,
> > > then the reset is considered to be doable. But there is a special
> > > case. If devices in this dev_set are opened by two applications
> > > that operates in cdev noiommu mode, then this logic is not able
> > > to differentiate them. In that case, should we allow the reset?
> > > It seems to ok to allow reset since noiommu mode itself means
> > > no security between the applications that use it. thoughts?
> > >
> >
> > Probably we need still pass in a valid iommufd (instead of using
> > a negative value) in noiommu case to mark the ownership so the
> > check in the reset path can correctly catch whether an opened
> > device belongs to this user.
>=20
> There should be no iommufd at all in no-iommu mode
>=20
> Adding one just to deal with noiommu reset seems pretty sad :\
>=20
> no-iommu is only really used by dpdk, and it doesn't invoke
> VFIO_DEVICE_PCI_HOT_RESET at all.

Does it happen to be or by design, this ioctl is not needed by dpdk?

> I'd say as long as VFIO_DEVICE_PCI_HOT_RESET works if only one vfio
> device is open using a empty list (eg we should ensure that the
> invoking cdev itself is allowed) then I think it is OK.

Sorry, which empty list are your referring?

Regards,
Yi Liu=20
