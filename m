Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9338E6A14DF
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 03:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjBXCVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 21:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBXCVi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 21:21:38 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FD35E870;
        Thu, 23 Feb 2023 18:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677205297; x=1708741297;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4vPvTNV3mHh2SP5Vgx6xqdNOAk/ZMNFsRCe6HX2Mvbg=;
  b=eVS7fnoVtZmkbk4Cb6MZQUECElLm7JjJLEXQHwyh8k28wUkT/aMTABQ4
   r/AnjLKR70L2Z/uepRPOXneijgY3zOZJ3Nso5oY1FS+V5Z0ji5RIEcxMV
   GCoJWF9lcWez+MA1gcJe/LfG55qjuLX1IDcV2C3c8c0pNW4eOaCD5BnXU
   CmcluP9qsQKBsTQrw5oFilk288Ntp8WssZO6XdyOGM6csLtWhFBteGkoq
   TUTUurr5VqamIk6cdUA8OLHQshZS8D01OEDyvDJGXDUFmxdmRiwI8qbjP
   njwKbhSsuamb1gWYVngNk+n3notuoE+ibWFomVF7X8GdPUeBCF/yG+1Tl
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="317137903"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="317137903"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 18:21:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="846790000"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="846790000"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 23 Feb 2023 18:21:36 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 18:21:36 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 23 Feb 2023 18:21:36 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 23 Feb 2023 18:21:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQ4s7nm6KYQHCkyql7fPJVshcu9W4ZpD3z+k9O0Gbwxw+LTuoEyctD5QjfOg8wtxNOQ6ZPucVEWv+ERLt/GN/aRT83jqkRt0+xFBp+rWVVTMDxY0sS++5Zya7EQjwNV/Xuwe/+bemhVR8WEjXNwS0cLeQfKXmXc3V2J81UdXhs6G2So2FZ33XPWUjNg6GwBbtj46i8Sx6onXOJTLV2dZMWqVEj2yuBZXLmTn0q4zvO9HeZAh24cQ51gqc0X6hllIXupmGmgsPtDxkEiZpI7Ett0LAJrsYzyhi7sJ42TqRKUEe9piffABxhd9Ky+nQLV6OhHVbHyoC2o9o2PVu2o9fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0CS2lVwDEYRY0+5/bk9q6lH6WXpeFzc6qzc1n2S2v3I=;
 b=deSq+z3ciyzhKRGvLeooga14CDWofuilklMEj5M0jHR6TgwAypiv1gEHTId9ZDcRkm6YvOwieIw4mGNdB1sd6t5idmuVmd9LmD/2Hb07vVxnzdRY5wz85b7GGaekFQ1kErA6FbPxgyKgivAPbBUyeN+VjdGDXaYcew+Pp4ZvyNxqFDnXOqqFnMVwNJmslpcC/Hm8Fv+t0zc4iApngaDPeG1OurDeSouMXXH6/bGUWFtLwOT3vHcYfU2obJwF3BEA1GT35lw7TdBg2UtjqaS12nsBQ4/kwbRuV/w/CYLSqccEd3m9i+/n71a6BJ0s34M3gw3FtjyuL8pNRVFdU7BjCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA2PR11MB5212.namprd11.prod.outlook.com (2603:10b6:806:114::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 02:21:34 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 02:21:33 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Thread-Topic: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Thread-Index: AQHZRade4YzkLtsVl0WRYDgmHuz0/q7akQpAgABomgCAAD40AIAA70ywgABhHoCAANlkIA==
Date:   Fri, 24 Feb 2023 02:21:33 +0000
Message-ID: <BN9PR11MB5276C959AA31F8515002B6B48CA89@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-10-yi.l.liu@intel.com>
 <BL1PR11MB5271D122329B6908BDE1F8328CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <DS0PR11MB7529B33D098225CFAAA7D63FC3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/ZOOClu8nXy2toX@nvidia.com>
 <BN9PR11MB52767915B9A5E509BC90E0888CAB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y/dobS6gdSkxnPH7@nvidia.com>
In-Reply-To: <Y/dobS6gdSkxnPH7@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA2PR11MB5212:EE_
x-ms-office365-filtering-correlation-id: 5de090fe-73be-499f-9f81-08db160dd93d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3kscpaTx2BNXk6ydftLC3YnuLgIThZ4q6+4kH3idOM2QGfBahAUrt2CVYuoVYA+wyg01Ht6IBLYDU/tUPqxjNgyJVw3CaooK5NzevMchqrzx1fDi4351W7ZLEraX//OuQykrUeu5jkutIYY0ZokrCi5Wtk8i42TUJBeEAoVZwD8Vap4x/NfNX31xC3JOHWSRKoZSwbVcn7P2p2QM4B8Yac3910+Aa5hm8bMyEP7GKUIkYGiiQupKfpNYS0rKPghY3nAU/0gvj0QTc+lUcea08DgLFnoQRZqbCSHj+nbeCbJeriqIiBujQcbLbE0VklrqeDJ4lWAW8CpbJl8IFDhfArSylSua9Tl54YgH8OqUnIHdHvsnHaK6Qljn+9o2WXAsn2jM/jkuKjjkCMqJ2A/t/KlJ3OCUnxtBqkispfh8lysPQjsQZypKdhL8pcQskkNo8ZOo0gJ0nPV7oJXIaq57kFqTxe2CuOkczK01d135ERbslEyIbu5L82gEPE5Dh19759qV680KKbC/00R7QQYdclK6B4xyAcDA+JvGH27glYGRErxvwk9NxrftsitrezD7p0PjaCX6rrAIO0GbAgeGVlZA9fhWU+tAZjeGFHI/p3kNss+zw9rlaDtjo1s22OWoECIvFSm242c0zYlTnf5TODu3ieFz434eyHBn0XHXAUJrMLNSKo42DEHfL+mrq5H4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199018)(83380400001)(38100700002)(8936002)(71200400001)(2906002)(52536014)(5660300002)(122000001)(7416002)(38070700005)(55016003)(86362001)(82960400001)(33656002)(478600001)(26005)(6506007)(7696005)(66446008)(76116006)(66946007)(4326008)(6916009)(8676002)(64756008)(66476007)(66556008)(9686003)(186003)(316002)(54906003)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HP73ITBeRGQYxnFxqAZ7g6EAOLKAStSRQVrdLniJzA8zV1a/cA2/zrVoOZgV?=
 =?us-ascii?Q?2TP1TIBJRoTETVs8/gmJWviwUUh+eupWlZ1Kt0bL7sSNOH6nNharJtYaq29B?=
 =?us-ascii?Q?vBCweteXgvGoWBO5K7yuX7fCz1+qEL147WDeNV+LFK0JU0POBfU+ht8LMgLH?=
 =?us-ascii?Q?utlju0j698/a1dsiMpWU+Te6jP2DukgoW6Uj6y7WbApbfBzghh0htJQuv1e2?=
 =?us-ascii?Q?8vk2jppp1Lz1IwsZZ6PTBhmuwaJmq4e6Fh/GJSnjo80hXf7hbso6rJR3Nhuj?=
 =?us-ascii?Q?shWLVd0DGg2RG/DSXGkzsiGkX2Fzshjq9v7KacUjYaF2rr6e4+ujb+rzEXZU?=
 =?us-ascii?Q?9rFDGmi6loHtSdZLbNrtmynd9SInyaQjTh0ckMxY4wspmkVKsWMIG++O4fHb?=
 =?us-ascii?Q?nLpdC6c9WVIfWnIVk3Y8/g2VMmTidSgC2TBjrzOVBsWnY1oERz8CwURbHEkP?=
 =?us-ascii?Q?MwPabOPjYHcxpup46M0nsFi3aXaJr2bMS5C2V+aMF0JestPvv6SveSAlStJW?=
 =?us-ascii?Q?SMDPdBIVsriIZkr+ZNBy55/veH8KEuAHdPk5wsu2R88rQ3mKNeEcyxgzJEb8?=
 =?us-ascii?Q?6MtMj9zM4BxCKzTIh5OfsI5ygeXQMc0OrPyEEn4+TrrA71mWZ7CFkA5YVIM8?=
 =?us-ascii?Q?I1IZlf6xI0t7TTzYWavUUw6wG+Kv6Oj5hX9iGqgnD3+ciJm/u7SQu4rbNlgx?=
 =?us-ascii?Q?aKJvhnfevj5qt7P6Xc+LTfokilZM5m8hjGtuOiJ/Ayw6TPhuQ+itK0EV0h1x?=
 =?us-ascii?Q?nsruw3tYUf7xMYoPdBQkHlZh2KOwtma4E8NsNFwX7OOrTSXboAMzH8lvVhV7?=
 =?us-ascii?Q?P1b56nwtV+91XLCKoI+L5EdjrxgJquQMp54OnlAF7vqQygXpIo8I5Wc0kUAT?=
 =?us-ascii?Q?ELodhSp7mpBQPZ7HGmGfKCFAF0PKbkuBEVMCBkMztoIh9Bw7k9zqWsNHP9La?=
 =?us-ascii?Q?uNrtyLtNgF7Ydw2zabyMIjyxqGhthKKU+85i+Mj6VEIKn6lhTeS41npLkEwf?=
 =?us-ascii?Q?kwP+M14A8FpiShHvzpsVt2rHfrvgTAc4rigY6wr5XpKkSHAe5rWmyhMI9sYy?=
 =?us-ascii?Q?05AQL87+sXOZtUQf6XZQ+NaGcbNcqECn+ssXmfK8n1xBC4qnGat4gQwhyINi?=
 =?us-ascii?Q?nsSranoNneIw1XZPaS+ZKXx6k/chjHTvDXQIzbM8m4uVoBYAVmehVIN2/4DM?=
 =?us-ascii?Q?gI81qVPOWByPH6QfxZr9jKoEiXONCQDTWAVk9IDBYLViZ7idu0DqXZJ2t4rE?=
 =?us-ascii?Q?Ga+4i80Y+lujAEyH5oLizaP60cte6rq/EhtM6CjNqDiDDIAo259fLQhTQ6cq?=
 =?us-ascii?Q?HIEarozT7mxTaGMLHy83jxB9mfBK7vwqWI2iHuHAWdRG/zAsvO+l7QohOaMY?=
 =?us-ascii?Q?8QqJvMD4unYXRFrWmYgY9koRz1ClX7ycANn866EU76OEreGWytmZy1Nuvsxt?=
 =?us-ascii?Q?260nkzhHOWHUGZ8HDX54wiRmhGjMjjd1UxdWXnZPSKfr5h2BGwrE/wQrAg03?=
 =?us-ascii?Q?dFFFSd4kLko2f8LSgVkYxVr7WzCljQaaRIudF+w7P06LoSOnn2H++sfPCLGU?=
 =?us-ascii?Q?JiTMjRvotgbvh8lEJoS4oVeXe+bZFZC5OozLFPgh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5de090fe-73be-499f-9f81-08db160dd93d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2023 02:21:33.7668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jvpPcZBscfP+yZ0/asDiH0IfrqGvsODNwkgXLgs+gOxT0Q2pVS/fZF9DvFbBAknhNX5N6Y2HyGls2JoR0+26tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5212
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
> Sent: Thursday, February 23, 2023 9:22 PM
>=20
> On Thu, Feb 23, 2023 at 07:55:21AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe
> > > Sent: Thursday, February 23, 2023 1:18 AM
> > >
> > > > > static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
> > > > >                                struct vfio_pci_group_info *groups=
)
> > > > > {
> > > > >  	unsigned int i;
> > > > >
> > > > > 	for (i =3D 0; i < groups->count; i++)
> > > > > 		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
> > > > > 			return true;
> > > > > 	return false;
> > > > > }
> > > > >
> > > > > Presumably when cdev fd is provided above should compare iommu
> > > > > group of the fd and that of the vdev. Otherwise it expects the us=
er
> > > > > to have full access to every device in the set which is impractic=
al.
> > >
> > > No, it should check the dev's directly, userspace has to provide ever=
y
> > > dev in the dev set to do a reset. We should not allow userspace to
> > > take a shortcut based on hidden group stuff.
> > >
> > > The dev set is already unrelated to the groups, and userspace cannot
> > > discover the devset, so nothing has changed.
> >
> > Agree. But I envision there might be a user-visible impact.
> >
> > Say a scenario where group happens to overlap with devset. Let's say
> > two devices in the group/devset.
> >
> > An existing deployment assigns only dev1 to Qemu. In this case dev1
> > is resettable via group fd given dev2 cannot be opened by another
> > user.
>=20
> Oh, that is just because we took a shortcut in this logic and assumed
> that if the group is open then all the devices are opened by the same
> security domain.
>=20
> But we can also more clearly state that any closed device is
> acceptable for reset and doesn't need to be presented.
>=20
> So, like this:
>=20
> 		if (cur_vma->vdev.open_count &&
> 		    !vfio_dev_in_groups(cur_vma, groups) &&
> 		    !iommufd_ctx_has_device(iommufd_ctx, &cur_vma-
> >pdev->dev)) {
> 			ret =3D -EINVAL;
> 			goto err_undo;
> 		}
>=20

Yes, this makes sense.

Yi, while you are incorporating this change please also update the
uapi header. Rename 'group_fds[]' to 'fds[]' and add comment to
explain that it could be an array of group fds or a single iommufd.
