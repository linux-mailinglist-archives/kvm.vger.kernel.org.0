Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541E86DD288
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 08:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjDKGQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 02:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjDKGQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 02:16:35 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFA1171A;
        Mon, 10 Apr 2023 23:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681193794; x=1712729794;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RPwDOcrxlNc+5UGID7vCbxH+k7vzDLRQ7SVM0hVAzQs=;
  b=mqM7SonMYLi1WOAkCFDs7J3HCvDuphLf+mJUaTUVl9sTKIn4JLcbvYZ+
   KZK97aoz6z6Mws7inXmJBQi7IZS/hkgLl4bt0rwRy5DX7cIzb1xsqPuW/
   KLRxV2VsdvzEjdb32rNC13qN5FdTzechk/LVfqcd7cIixIKyZ07lrfSrp
   IsJb1wlTZAdpJg1RijRhpM1izIHflexA3DcJp1Pj68F6tJV9UvThrkGj2
   kvYNpcZuH8xfsf89wRTM+dcDIK2m75mIo2okD3vkEY4nNNYBvcIymZGf4
   W/8n9IHu636lr2cVxNc1iNw6y13n7d4Q6sd780Fiy3XoA88AWbdLgIB1+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="323169163"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="323169163"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 23:16:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="691046527"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="691046527"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 10 Apr 2023 23:16:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 23:16:33 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 10 Apr 2023 23:16:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 10 Apr 2023 23:16:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RtsGd9M8LreKswGs2IzFrSR56K/BTZvVfBlPKCu5tku12HKPwlYeSId3Z2z41QbvE/thOG8PjIbKdzgrKZqtHo7Bo+hKpeln6jXPkd+Tw7xlniZonfKOfZ5FFq3CFVXe+O4LGBApDG0cCsiPSuqv98j5nCJGr4kGAnxlducz5TerCSh1zbMPZlbwUdWIKAii6nw3VYDC4WOnAJW1EcJyv4R6IqeNx2HaQ2yOxgiqOeWVNTOM/nynb4RRNSMudF4gAS+r0WBZB7HuryRMbX3LMWw+NHJwbysfd5rCqc0KVc5g1RlSo7MqmyOOjuTyPC1LU0bEcokHwbrtrNB+GsbhlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ezD+OK0qFG+Ch2DGd8227SDucBpdgjM3EC8xMbICvY=;
 b=iVfjEZpOFysPc7sh4klvIjpMs2Y87ih+MZAUL/iHwwGgGh8eQJlWKa03YXLA1Zvc7cMLZL8Z7J1g5DvfaleHNWvTQTlQr+UWgvWjNv77vI+ws/8fl9ZBQd8qzI+IdLIbtFiIkZnn+6afMSDFLeL2bnLerZzCqTF451OEHuKQDDW0NY9mMmGwmoX6/96c73L0UpN+Ys71VfUkHcg/7coJ1WU49lThPYuToFovdgV5oJWhC5zGldywOT+5pVn2ZUjJwq1mO/G3BD8hBAJIPBZbQZ8yJAX0wEcK7gnnKecPze7vLkc8w4aMomEzS+UznisPb0558ld243BjIC6418CWUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA0PR11MB4637.namprd11.prod.outlook.com (2603:10b6:806:97::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Tue, 11 Apr
 2023 06:16:29 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6277.036; Tue, 11 Apr 2023
 06:16:29 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8ZTcVQgABjWoCABfZ/IIAAIQaAgAXlhuA=
Date:   Tue, 11 Apr 2023 06:16:29 +0000
Message-ID: <DS0PR11MB7529255FD142A9F83C19896FC39A9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-13-yi.l.liu@intel.com>
        <DS0PR11MB752996A6E6B3263BAD01DAC2C3929@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230403090151.4cb2158c.alex.williamson@redhat.com>
        <DS0PR11MB75291E6ED702ADD03AAE023BC3969@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230407060335.7babfeb8.alex.williamson@redhat.com>
In-Reply-To: <20230407060335.7babfeb8.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA0PR11MB4637:EE_
x-ms-office365-filtering-correlation-id: d49f2b52-bd4d-4779-412d-08db3a5449b5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2bHigMiLojndL4Iik0jyYwuqhEXdX3WIxldKaaJMpP3nN942gsqfoqhfgwb9/9eSuKdbxMem9/oyoDofnqf1uYnXLnpmwWqeEpGmaq4Ff5KplB6gY0DQSGRgtZr7aFnLT80GfWpMLD9u+40eRYsVtriffIX1Ur5EC2hjCx7aipiO5Ckr/2M/12DGEWvxW1sAvDL6UNcN/86eFNDb87AzaKNRICPj8bigpSSnJlBbsm4RfR8uUH2BYN/8qGlno3XP1gYh0fNpcn5ovv2eXv8LGT2nwuIz1pX8P3qRcUtdsanO/XifARPQrzEaEQt++x2cSOp56xhG/pyPTTdsQJgoKh53ldTsShEX5+qvUw3v9ZO3b2RJLnLHqT0GmGtHVMF+rTBLYoQWSSqlSTFdcOc8hNVcF7rs8G67QmtCDVrqaXontPQHm0jtDrPskJHOgw3ButQVe9F/H0rIJ9TqlTEAeee89Pf1xyjcFuYYviE+/GddfUUQltw1snSZzNRELBfzQLY7e7oO0JwgiE3HjRcVSoXT8IW+BylX+XdT7W30EMWdiqfA/0VzgmFpcIqGZijj03rT4FAxiKg2GP8SObvOmFrOhf/3ANhoO/s49xc2NTM/qVNytEPZmFepDjjKGLFD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199021)(7696005)(71200400001)(478600001)(55016003)(86362001)(33656002)(38070700005)(83380400001)(38100700002)(82960400001)(122000001)(2906002)(9686003)(316002)(6506007)(186003)(54906003)(7416002)(26005)(66476007)(52536014)(8676002)(66556008)(6916009)(8936002)(5660300002)(41300700001)(66446008)(64756008)(4326008)(66946007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KN48IwnNb+vjiO6D75+pgNXeR+Ef8auBFndbLk9fVH2iz8slpRQGdQnRf0KP?=
 =?us-ascii?Q?3e3vNJTgPtaHoEsZk/TIiiI2CA+WVhy9dFflxOSA2TC4u0V3HVgf93ImXsoQ?=
 =?us-ascii?Q?+T+63orkiieE3akG2v8Astd7n/yL8tMXuF0bXL6Upt56LawHe8lzrEeKnr1R?=
 =?us-ascii?Q?jNxcQgcEm/b3mfKOtqdgZTawjYkhPptwZMNVIcuj4PglibihfQwUUorSkP/I?=
 =?us-ascii?Q?zxUP0nhXhNmjLI/HqKhj2NHyltT2KeMZjuB1WacjD40AvqT6e+cOFU5LIcvG?=
 =?us-ascii?Q?tcdlRq6jbKOqy9oMtxePduP9R72wmIoF47dLyjGwc7IVQ7lQqoAIe1TdXnle?=
 =?us-ascii?Q?gaZHuzI/S0X0fm0VMcRgqMvqPOKMiZGRlKvSNay/LuKYCLN9JvweuBqW+sAY?=
 =?us-ascii?Q?7eb/fR7Yq/vIEhfBhiD3wLEI/fB4lMATXJbvS5ppfhmjeh+Wr0+wvUW2bk+w?=
 =?us-ascii?Q?HgzEkgc/Zxquk7JdvjHdIg9o3tU13AvnDyTK1atgfYqm1A2MRBgt3ogusac3?=
 =?us-ascii?Q?1EmkmIUcrgwi4Dsne6kHUy9/f98Qsm/nIKEJtXDwkNcliWYxwEAcylBTWvdz?=
 =?us-ascii?Q?xR0lDn32lgmcHu2FIb9JFgC7xZL6J0cy6AYUUbwS7e7MI4fqto4Y2k8aHoXR?=
 =?us-ascii?Q?VmVlGM31F7yAPl0GgQlpBzbIcKmdoSK89bFFNoYplcvxw18NWeuTQEoRjtf7?=
 =?us-ascii?Q?Poz2qduia9UQ3s+IbfO40kLld8fkwn7JKe2EFBfEvvTX6fCoa8zOiYjS924T?=
 =?us-ascii?Q?iJcDFvkWxOqU2Ph8I5yqmsXPPF58Jn0SKSQhvh5ub6nOaNDOPTp9oYczeYSx?=
 =?us-ascii?Q?7dS+MH8cKVWHvQ3TQDual0acw85iHMbag+3/SYFDxlU7nQ40YqpEX0k9iWjY?=
 =?us-ascii?Q?1J3tKO0iksbTDihMiqJ3NSK/sw6XdV6N6fpsrTDbzzuQFukIUCyGzAcPe1lA?=
 =?us-ascii?Q?tIt0caz93qfhZSWX2HEnkduFhtCHdZw1lprGzfyiVT3Pj+H5ygi+G5Js6csB?=
 =?us-ascii?Q?YWxnmL2OhEbK2yYGh+9vm/9OeqpY2+dx3G+ljOekXuHFC4a6kfFTQuXp6FJh?=
 =?us-ascii?Q?bl/xontaNg1ReruICO742Xy8AFU7NLeaKrW/6XrNs2J19SmOPyUDEMYkKbQU?=
 =?us-ascii?Q?a6cm+DVd2M2nVpJXLfliG5RsdizNpSxiEBEw7s8Kj4IalFKG+gV6FejGCVkk?=
 =?us-ascii?Q?tS+6c9BVITfhk13WWBREzG6zoyHcSNKBknYeihULzAabYSdxQ2bPbwuj7LU3?=
 =?us-ascii?Q?YoMRFyA2SXKx1OMC5YYlbqie3hbC5Yw7t+hEf84Zw9P7G0rwK2mHqivZ8BVw?=
 =?us-ascii?Q?o0GYoPRAjDpe6BPrmGPqMhxEOFHKeu5/PfkxG/kHbq1DBAMdYJzBHtzjzp8T?=
 =?us-ascii?Q?9AbXd/uLYVmXyy7+nLe6ecCNCTbWlf5btvAKmnZoE66S+7/NRQcW9Kb2+ICO?=
 =?us-ascii?Q?t7OuqDH+9qqEBGNzXfl1taKSNxPZBiXSrcA9/nvvzqMQPO1HHDT6Y7zPOiA9?=
 =?us-ascii?Q?U0bm2ywQ0dE10KYWw4DhsOb7S3gK0SoLF2G2+tyaAje5TRh90uTv33xKMTkv?=
 =?us-ascii?Q?0xeorWazVI7hemhm3YY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d49f2b52-bd4d-4779-412d-08db3a5449b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2023 06:16:29.1147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PmmDpgwcVj3dvediIH5Vfwzg3BDantl6ruAAaHZ32UQWsDvjXUIyl4cdcieMtVyZkOZRC95uIZrZy3LcqUr9Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4637
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, April 7, 2023 8:04 PM
>=20
> On Fri, 7 Apr 2023 10:09:58 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > Hi Alex,
> >
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Monday, April 3, 2023 11:02 PM
> > >
> > > On Mon, 3 Apr 2023 09:25:06 +0000
> > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > >
> > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > Sent: Saturday, April 1, 2023 10:44 PM
> > > >
> > > > > @@ -791,7 +813,21 @@ static int vfio_pci_fill_devs(struct pci_dev=
 *pdev, void
> > > *data)
> > > > >  	if (!iommu_group)
> > > > >  		return -EPERM; /* Cannot reset non-isolated devices */
> > > >
> > > > Hi Alex,
> > > >
> > > > Is disabling iommu a sane way to test vfio noiommu mode?
> > >
> > > Yes
> > >
> > > > I added intel_iommu=3Doff to disable intel iommu and bind a device =
to vfio-pci.
> > > > I can see the /dev/vfio/noiommu-0 and /dev/vfio/devices/noiommu-vfi=
o0. Bind
> > > > iommufd=3D=3D-1 can succeed, but failed to get hot reset info due t=
o the above
> > > > group check. Reason is that this happens to have some affected devi=
ces, and
> > > > these devices have no valid iommu_group (because they are not bound=
 to vfio-
> pci
> > > > hence nobody allocates noiommu group for them). So when hot reset i=
nfo loops
> > > > such devices, it failed with -EPERM. Is this expected?
> > >
> > > Hmm, I didn't recall that we put in such a limitation, but given the
> > > minimally intrusive approach to no-iommu and the fact that we never
> > > defined an invalid group ID to return to the user, it makes sense tha=
t
> > > we just blocked the ioctl for no-iommu use.  I guess we can do the sa=
me
> > > for no-iommu cdev.
> >
> > I just realize a further issue related to this limitation. Remember tha=
t we
> > may finally compile out the vfio group infrastructure in the future. Sa=
y I
> > want to test noiommu, I may boot such a kernel with iommu disabled. I t=
hink
> > the _INFO ioctl would fail as there is no iommu_group. Does it mean we =
will
> > not support hot reset for noiommu in future if vfio group infrastructur=
e is
> > compiled out?
>=20
> We're talking about IOMMU groups, IOMMU groups are always present
> regardless of whether we expose a vfio group interface to userspace.
> Remember, we create IOMMU groups even in the no-iommu case.  Even with
> pure cdev, there are underlying IOMMU groups that maintain the DMA
> ownership.

I just realize that there is one case that does not have iommu group.
although not implemented yet. There was a discussion on SIOV support.
IIRC, it was agreed that no need to allocate iommu_group for SIOV case.
Kevin or Jason can keep me honest here. I failed to find out the link
of this discussion.

> > As another thread, we are going to add a new bdf/group capability to
> > DEVICE_GET_INFO. If the above kernel is booted, shall we exclude the ne=
w
> > bdf/group capability or add a flag in the capability to mark the group_=
id
> > is invalid?
>=20
> As above, there's always an IOMMU group, it's never invalid.  Thanks,

Regards,
Yi Liu
