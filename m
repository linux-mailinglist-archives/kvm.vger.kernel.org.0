Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79CB56CCFE9
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 04:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjC2CXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 22:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjC2CXw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 22:23:52 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0412D2728;
        Tue, 28 Mar 2023 19:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680056631; x=1711592631;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9v/Dz46HFwlm6CtSjqBlv2LyeFWZsU1oqASycvVZdrE=;
  b=hY2J9w7DABZRrg4do8ejOj2FTotcNfwvN7hcLtMTWXD6g5gm3QkK/wZg
   UncGm5uasAb+NMsbLCglKbtYT2GtueSUqHRvbjT0UdalduCfsBzNb5yHc
   ZrxMsXqmE81D7vbfHjWG6dtY6mbhhzcddVjpmfslJ6T/ENsaJlIGenBAV
   pvRUGhgturwEz5ZHQN5MJVDAAlqw+pw7ECaHTzFIrCKVgu7N5HiRf2yil
   8mQ/hyIr/Ce4KEDeIzcQRatAaKthy9XVBUkCDoBvrF8a80I/4C5SoFjSe
   JgsXAT9rdHsoRTQ1gY4xvKv0UAwWeyksQBN5YS2cWTJZQisEIN0rjlISz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="403371843"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="403371843"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 19:23:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="808023510"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="808023510"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 28 Mar 2023 19:23:50 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 19:23:49 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Mar 2023 19:23:49 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 28 Mar 2023 19:23:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQ/jgOzVbTHT0lY32Zy8nnesYnE0QX0jmXVOIFYJNmCbK5PiFtbilzAbIlFBpWZT4NT7umpzYJpUa/DEaJZp8XxEwb1n8GBwP8NqW6GkzlmuJ4MK89fps8OtNVYVy8Tv5nC7wSUOE4z+2Qne1IHp/xoaTQ1sK24KvGKGKNDiS/KfWPt+xCiV9adj/s+K+Guw0ppJgOZH4tKBRn+EFPJQDcQfG20CRy7+Iptg7TaddRK0UzxcXKvpv56gaTLKGPRSkO4uMdsksIFKzsvMbDh9oMVwXOHT8cNhVDr6W2ApbeWcR2ckHQ9c25qNpJ0ghxs0JoBGztWF3CJCsFQVac/biA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bBkrvYBS9OtumCOaUG6lHy7MCcXKdrNik5b/C2YYRy4=;
 b=FU5TB+slW3PczW7BlaTTncKxuhnnNEVo0G0ckTgf+m0vCGtBwUNw1hj4v760CAjeIHrTc5E4PHjfdVQ2Veb+W3YHTPiuiQdi5vX+IkcMECdhT2OBXhSMvfDaYUx9IHfSI5CO5bznmVSHXeiiVsaKFUHrWNqH9bkQHhkusKpyQFQtAvSbIQ5pmJPK1ea5yTGmvdgtYPCHzk5mxOd2UaD4UmqUU4OE+DOMLQH++0dQpAPARJwjSHIxtPsJOow9iGliz79lr5F22YTLlsHopQTLwYvgQMW5yhBbK5GJgNffPH+bxvvxlyJSgLXH+6zWpo5dpPEZYY2HLtFU1sGeg75mRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS7PR11MB7834.namprd11.prod.outlook.com (2603:10b6:8:ed::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.32; Wed, 29 Mar
 2023 02:23:47 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.041; Wed, 29 Mar 2023
 02:23:47 +0000
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
Subject: RE: [PATCH v8 08/24] vfio: Block device access via device fd until
 device is opened
Thread-Topic: [PATCH v8 08/24] vfio: Block device access via device fd until
 device is opened
Thread-Index: AQHZYJA93wXE63qmz0K9dUYg4gF16a8QuNoAgABPTxA=
Date:   Wed, 29 Mar 2023 02:23:46 +0000
Message-ID: <DS0PR11MB75290A2ADD9EA54E7F79893BC3899@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
        <20230327094047.47215-9-yi.l.liu@intel.com>
 <20230328153352.6c1e2088.alex.williamson@redhat.com>
In-Reply-To: <20230328153352.6c1e2088.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS7PR11MB7834:EE_
x-ms-office365-filtering-correlation-id: 4304d62b-be75-43fd-9c83-08db2ffc9fff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RmafkFQczj0toeRq/NpKRRJZGFhDGr3qvlM3YCr1QlrufWUDYVnxwWK2OH46IJ7Rox/0NQuMMkjaRY0p2PzJ1cDxirb4/BsjBs2AvjAywFOo8heuqtuVvA4mxTen9/WDVkf6ObUuOTHy8RS46r8B/jScLAdoXVE1My6xt5cinhY+KyKfiGPuvUF70ArH7Shblk1UF8DxQRNT6m88NG/MHt1H9R4JR6dEKVXNJ56FYYeeTwv3aR7AJ31ANJwclofXoP1eQq8IPOqM2JGnj/s5D4x1ACEhOb5Urjz1bDIPysa/NhijArbU396fIkuEi2BD44g8tSBUZEtX8laXzN0jNuTw6yctine5orfDBKHChhE1XKeDCdsA4rl8Wp2mnQL/t7jcTGk78utln5EGswH0lgno6XWkhSLwb5sEtF39l2+PRWGr+L86k9lrYUsWX3anC0cm8aMQPOf9y5pYKVJvEGHEHdl0XpSYgWvJWylvMa5osuRgSWK9tTDwcLvtApRFOsSQ9JGk+pYG+W4d97JLOQuwSrAe00vQBtXWFm36CPu7fU8I63tzfHEtjDxMjEmXlsRtOtF4pbWm3gasaP0VRF+KWNLphhRQZbOnr4ACzAFwdmmbwZp5xJfzXoWvcOqbkND19gSOyFMs5oPLshWUug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(376002)(346002)(39860400002)(366004)(451199021)(33656002)(38070700005)(86362001)(2906002)(38100700002)(55016003)(83380400001)(71200400001)(7696005)(9686003)(76116006)(316002)(4326008)(478600001)(5660300002)(6916009)(66556008)(66476007)(64756008)(66446008)(66946007)(54906003)(122000001)(52536014)(8676002)(186003)(26005)(8936002)(6506007)(41300700001)(7416002)(82960400001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XfMKoQwCLGUP9wtU1iC8l9CAUyiGyj2L5zCgIbU056zOg4eFXZB0EE/QKcgA?=
 =?us-ascii?Q?b628lbqpm777OaqxRRw5pcjnv9FtRakIWmLORsB+qbXfkWsZnujj65kWb9Dq?=
 =?us-ascii?Q?f8TaD6qVq6EPqoVzgJnAitDS65rMIt6qu9bPPeFsG9jMhCcgl9kTTsUmKrX1?=
 =?us-ascii?Q?kumzZI8A+VNtCYtMPJPV2wGXAu8AAUpDV/geDSwwFzIG3vRey/NRvqYe7hm2?=
 =?us-ascii?Q?mq3C5jnQTYCjndsonIFRH5ompqhfLX/zxbXkroyj5ZLhxDjjTMlGmTrv/9qX?=
 =?us-ascii?Q?/uHbG7aH9x40MoAFmHDj88EFrX6VZNSVUVW3VXbKMyOuzJ3mTRyxWMZTVZWx?=
 =?us-ascii?Q?IOdFDtuYekfxOH5L2mkDg9OAECwIrN6iRs6g1adepiR8HIKpaESXqkyxPSXo?=
 =?us-ascii?Q?Zrb7GjAuPnjgJ421bIVVVHvWOWU9iTfZBPe8TiECVzu5qvXI4OMA2FJiNBkz?=
 =?us-ascii?Q?McrD/CZWY3kpr3w42/dZyuL4LloX4KJTO6ybgQJh3OIyhJceyZt/WdVRMOm0?=
 =?us-ascii?Q?+08wQemnNgJ3knoJVli3++H9qARwjq16x3gn4hzsSJUQWEg871fNPjdNF7oK?=
 =?us-ascii?Q?dG4HVEm8Q/itpCAu9l5Eerkcez5zPUjq4V2KjDlpY+v9/LrMkjoVdHbGoTJT?=
 =?us-ascii?Q?zzVDU1lW3ebhSCNl3M3wAmOOXhK2cvPNJbiQS5Kx8DcAAqtD0egKfE+IgpG2?=
 =?us-ascii?Q?SRR9Cimeo0D28skv6v2bs+Kg/oKJRKbkZTCDjITfr8akFiIEIaO7V4r8YJXj?=
 =?us-ascii?Q?eKvC6T1C1pYHrIHOSNGF3Zy8lCtVhYbDsBxy1LDJkLCqAzbNH0o3KwCMazbD?=
 =?us-ascii?Q?L11A+UQ5YqoiL7n3wkhCX2auX3ceHrwK5GBabo9CO7waXIc5nKcQOrfcMxE4?=
 =?us-ascii?Q?l4BCP46Alje1C0zOmJowsvZCChYzWt0XfbWSSENXQd/3WTYOfl0LyBgzB8dM?=
 =?us-ascii?Q?Yxpjrb+JZAGvy3DFq588hsDPTdf/bqEr2u88FFSqRBj8wQz71vm44vZVy4zB?=
 =?us-ascii?Q?lt9VZ/CsLBsnkZBK9yR2H482t67imR4+28sxSqBOLLKE9lUnT1QW1gwjRzJh?=
 =?us-ascii?Q?92Qna/gZY5//7hI4fVXb8326qbQNfmFkfEnARAztUGY+cDnEvpOWmo4NyrOI?=
 =?us-ascii?Q?uf66rqCPyNT83M1RW+NOVtME/8xlimK6LRDkrJFmdvcETyyqVpkMiNv+Bk0n?=
 =?us-ascii?Q?kYbyIZjo1jSJZvxi+icqq20Gv+reya+t8VT+3IH9tH2gXgO9jU+Mrr738RyI?=
 =?us-ascii?Q?v6l0aGCrwv8aNd+KQT4vIpxYUozWIr1S5fhSKTqKJFtch4GB7dv8gHpvarSq?=
 =?us-ascii?Q?R0UR62qXiSY2AEYpjM9vc5DqyIxYsRAyquIURpqsRs8SGzhKmg1zfqOOfknJ?=
 =?us-ascii?Q?Yb1fhghS1b2zTevAupRKXGTkLMnQAtXpOePUaIIVfDt+57c6iGfPNU/kkc1q?=
 =?us-ascii?Q?D/Rml4dDEb1Tuu8Thf6jRTTFJj13lPzRv3AVfcEYIqJMAGSHVyVN8a/Dd0nV?=
 =?us-ascii?Q?PAtQwCCrOPOWK5GoxfM4Gh5jhLi1/l3IxyVtLDl5bLOV1Gf9ehhPFYxj5wJg?=
 =?us-ascii?Q?N8bf1jAekIG1YrvTq8hpJJITM1n6ZcCqF9eHQpbX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4304d62b-be75-43fd-9c83-08db2ffc9fff
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 02:23:46.5337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: piHW3Qdg8VnHc4mK+h8EIMH+qWJ5YsXPWIh9xtdfYbe50MqOfCt8uwrMirvHcRm37mwh5UiAOi6nSshqpkdY1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7834
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, March 29, 2023 5:34 AM
>=20
> On Mon, 27 Mar 2023 02:40:31 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > Allow the vfio_device file to be in a state where the device FD is
> > opened but the device cannot be used by userspace (i.e. its .open_devic=
e()
> > hasn't been called). This inbetween state is not used when the device
> > FD is spawned from the group FD, however when we create the device FD
> > directly by opening a cdev it will be opened in the blocked state.
> >
> > The reason for the inbetween state is that userspace only gets a FD but
> > doesn't gain access permission until binding the FD to an iommufd. So i=
n
> > the blocked state, only the bind operation is allowed. Completing bind
> > will allow user to further access the device.
> >
> > This is implemented by adding a flag in struct vfio_device_file to mark
> > the blocked state and using a simple smp_load_acquire() to obtain the
> > flag value and serialize all the device setup with the thread accessing
> > this device.
> >
> > Following this lockless scheme, it can safely handle the device FD
> > unbound->bound but it cannot handle bound->unbound. To allow this
> we'd
> > need to add a lock on all the vfio ioctls which seems costly. So once
> > device FD is bound, it remains bound until the FD is closed.
> >
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/group.c     | 11 ++++++++++-
> >  drivers/vfio/vfio.h      |  1 +
> >  drivers/vfio/vfio_main.c | 41 ++++++++++++++++++++++++++++++++++---
> ---
> >  3 files changed, 46 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > index 9a7b2765eef6..4f267ae7bebc 100644
> > --- a/drivers/vfio/group.c
> > +++ b/drivers/vfio/group.c
> > @@ -194,9 +194,18 @@ static int vfio_device_group_open(struct
> vfio_device_file *df)
> >  	df->iommufd =3D device->group->iommufd;
> >
> >  	ret =3D vfio_device_open(df);
> > -	if (ret)
> > +	if (ret) {
> >  		df->iommufd =3D NULL;
> > +		goto out_put_kvm;
> > +	}
> > +
> > +	/*
> > +	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
> > +	 * read/write/mmap
> > +	 */
> > +	smp_store_release(&df->access_granted, true);
> >
> > +out_put_kvm:
> >  	if (device->open_count =3D=3D 0)
> >  		vfio_device_put_kvm(device);
> >
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index cffc08f5a6f1..854f2c97cb9a 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -18,6 +18,7 @@ struct vfio_container;
> >
> >  struct vfio_device_file {
> >  	struct vfio_device *device;
> > +	bool access_granted;
> >  	spinlock_t kvm_ref_lock; /* protect kvm field */
> >  	struct kvm *kvm;
> >  	struct iommufd_ctx *iommufd; /* protected by struct
> vfio_device_set::lock */
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index 2ea6cb6d03c7..b515bbda4c74 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -1114,6 +1114,10 @@ static long vfio_device_fops_unl_ioctl(struct
> file *filep,
> >  	struct vfio_device *device =3D df->device;
> >  	int ret;
> >
> > +	/* Paired with smp_store_release() following vfio_device_open() */
> > +	if (!smp_load_acquire(&df->access_granted))
> > +		return -EINVAL;
> > +
> >  	ret =3D vfio_device_pm_runtime_get(device);
> >  	if (ret)
> >  		return ret;
> > @@ -1141,6 +1145,10 @@ static ssize_t vfio_device_fops_read(struct file
> *filep, char __user *buf,
> >  	struct vfio_device_file *df =3D filep->private_data;
> >  	struct vfio_device *device =3D df->device;
> >
> > +	/* Paired with smp_store_release() following vfio_device_open() */
> > +	if (!smp_load_acquire(&df->access_granted))
> > +		return -EINVAL;
> > +
> >  	if (unlikely(!device->ops->read))
> >  		return -EINVAL;
> >
> > @@ -1154,6 +1162,10 @@ static ssize_t vfio_device_fops_write(struct
> file *filep,
> >  	struct vfio_device_file *df =3D filep->private_data;
> >  	struct vfio_device *device =3D df->device;
> >
> > +	/* Paired with smp_store_release() following vfio_device_open() */
> > +	if (!smp_load_acquire(&df->access_granted))
> > +		return -EINVAL;
> > +
> >  	if (unlikely(!device->ops->write))
> >  		return -EINVAL;
> >
> > @@ -1165,6 +1177,10 @@ static int vfio_device_fops_mmap(struct file
> *filep, struct vm_area_struct *vma)
> >  	struct vfio_device_file *df =3D filep->private_data;
> >  	struct vfio_device *device =3D df->device;
> >
> > +	/* Paired with smp_store_release() following vfio_device_open() */
> > +	if (!smp_load_acquire(&df->access_granted))
> > +		return -EINVAL;
> > +
> >  	if (unlikely(!device->ops->mmap))
> >  		return -EINVAL;
> >
> > @@ -1201,6 +1217,24 @@ bool vfio_file_is_valid(struct file *file)
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_file_is_valid);
> >
> > +/*
> > + * Return true if the input file is a vfio device file and has opened
> > + * the input device. Otherwise, return false.
> > + */
> > +static bool vfio_file_has_device_access(struct file *file,
> > +					struct vfio_device *device)
> > +{
> > +	struct vfio_device *vdev =3D vfio_device_from_file(file);
> > +	struct vfio_device_file *df;
> > +
> > +	if (!vdev || vdev !=3D device)
> > +		return false;
> > +
> > +	df =3D file->private_data;
> > +
> > +	return READ_ONCE(df->access_granted);
>=20
> Why did we change from smp_load_acquire() to READ_ONCE() here?
> Thanks,

It should still use smp_load_acquire(). When this is added, its major usage
is under the dev_set->lock, so it is functionally ok since the writer of th=
e
df->access_granted is also under the dev_set->lock. However, as an helper
in vfio_core, it should use smp_load_acquire() otherwise needs to add
lockdep to check if dev_set->lock is held.

Thanks,
Yi Liu

>=20
> > +}
> > +
> >  /**
> >   * vfio_file_has_dev - True if the VFIO file is a handle for device
> >   * @file: VFIO file to check
> > @@ -1211,17 +1245,12 @@ EXPORT_SYMBOL_GPL(vfio_file_is_valid);
> >  bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
> >  {
> >  	struct vfio_group *group;
> > -	struct vfio_device *vdev;
> >
> >  	group =3D vfio_group_from_file(file);
> >  	if (group)
> >  		return vfio_group_has_dev(group, device);
> >
> > -	vdev =3D vfio_device_from_file(file);
> > -	if (vdev)
> > -		return vdev =3D=3D device;
> > -
> > -	return false;
> > +	return vfio_file_has_device_access(file, device);
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_file_has_dev);
> >

