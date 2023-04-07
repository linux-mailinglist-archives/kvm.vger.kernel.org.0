Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A59B6DAD66
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 15:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbjDGNYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 09:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbjDGNYb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 09:24:31 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494CD5FEF;
        Fri,  7 Apr 2023 06:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680873870; x=1712409870;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IdI1p7dMSSZcBA/k0wGHmyS+S08B9bv+8cJ/4FI2fIQ=;
  b=Y8u4h9mppz6VFk5WyCX4aKDz+0Jo9cjpdL/nC+qSGJhLKZzVjOZraJ7R
   Hl/PO2aWi05qScZAvdW6m3c7D1xoBOH35Xp/G136403xUXvnDrZsNO6tl
   fMqztph8VI8bFSU/oJS3wUbQfGn35+DgfmD13hXeoZM1YPXBFuCRc8oz+
   vdlXCkGHPgl15+9YHLQ1ac9eNrUKPcJ8o8PkeZS9QWDcEoRyM3NvyH0Ai
   iVGuY2a4ezn3s196d9XexwLCpkt/xYb8lYjIW+N87X/0h8sxzG+NZHtVx
   wGjaaeIEEkwxGJVD0NnxAT4+dNqehARLO6ou3RzkD5wvGlY1D8Kzt37BF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="327058396"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="327058396"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 06:24:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="637701744"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="637701744"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 07 Apr 2023 06:24:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 06:24:28 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 7 Apr 2023 06:24:28 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 7 Apr 2023 06:24:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+A/Nnrqc+J8pjq968zfG4MaNt8dONOIp077737N5X09uS67iWo1nKNLOORNlBpP3QFe79WKouZeAXKkNnasPDKYJolmkGO+vLKXNDBtY5Ul1xdbKlncso28b0TAmUfva2cm3SxDwq9x1Cvuzs7QZawHTjblvRT6HQFgNd6P957po1rhY/5Io2JaiDtij1rP4zLwROx8JJWZA7sFMDwvxyL0Ih/6eYunsGAQntyV1kVAFPJcrZTZlAFoasgE22VmhOkuDF9KufJrierTXGd+cBJOUY5exHTcc4pAFr+Vv08W3oEPAmHplO7/aAoJbeI8Ck9lo/YRAvvQN99V0yMQpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xvgz4GWg7Fvdq4owmGqwsFBJ4QN6/sCc7jy6ShyhbuY=;
 b=DICGeDJBO4eTuSJ6k63gRMNcRMZ1dGT6pfi9jTtcqL1v/nrKWe/n0JtNi88ajNPn/oPOKtp3IWw4eg81xOdZl1Cp2Yc2CGNY3DGonSTGDDdWMPxvLsmpTWVNZqr2o7tjIq21eFRHCz+LM61VNFUDR0rMIJHMJ2CX2TzDQeZ0dsehWAcgXtzIMWkHGmYC4lHMTyi1WCjNX+nWG/XS5QZpzLomzYgNbnsvoFuY0mDFyVAHQvpiSR/C2RqQUkcz3dFuvPow5SKIGM3N8QikrkBgztITK+ChN5A6bz0HRTT/T5vAz0AJ/zGSU1Rh50C9jWApocCBMVYrYcO5Fsxn6jWsLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MN0PR11MB6010.namprd11.prod.outlook.com (2603:10b6:208:371::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Fri, 7 Apr
 2023 13:24:25 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Fri, 7 Apr 2023
 13:24:25 +0000
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
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8ZTcVQgABjWoCABfZ/IIAAIQaAgAAVGHA=
Date:   Fri, 7 Apr 2023 13:24:25 +0000
Message-ID: <DS0PR11MB7529B0A91FF97C078BEA3783C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
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
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MN0PR11MB6010:EE_
x-ms-office365-filtering-correlation-id: 20863d77-e5ea-4984-30d3-08db376b6877
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wTZVcENtqC/ARdPFB1Q8cGKwC3nPbxvGtgri1mg6FoD6J6kXCPpHJLOQWFIP4n8LGn/gnLysefdoI75UWL8cO7GfkFtidoLjy4Zvsyht6tb8qRWlcY5QpZVe0kB6Rh/J8F8aPqo5KdTje80Fpi0OnTpo/1YYzG4wixaobVky1dx62I1uGL1cl3s4JQ/+BpSI8YPjvzRs644dtjrcQxD7kPJSfLYOICVoSeSOZxqu78C0JBKisoI+e4ILHJ6/5dTaX2/k1WRbY++4TWzl8xuHzIDg8h5bykmycMrGInVp39xXXkodSVb8WIT7sbAy6vhy1lK1BTmgYZhOPLyXvwQ2c4na5IuKuPQX4fltP7D/gemA1bDbLmlrqQmMZrEdv0+n3wM1pJvZ0j2oUhYHaCa2HdkXGm1XMqVDIfQl7m1LnmunS5o8O0psdh9P74wINajkjDbtr753KuRlHTIbuJW8zqrvaS0IHKobbUtgMdkFZir/1GrrZgmXKryRbNM3bxpRkXXRmjNQkFWV3pXBX/jI+a+rIC346tGkN+w0lacmPGmTBOQNsX79P43o2F8G1xWX7TrwRlj9NUyCBfbvn1cJVVKfP5w7kgbbky9ybNeZpOukdcnYoHi9J2obRzb5rVhl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(346002)(396003)(136003)(39860400002)(451199021)(478600001)(71200400001)(4326008)(66476007)(8676002)(66946007)(54906003)(76116006)(38070700005)(7696005)(64756008)(6916009)(66446008)(66556008)(41300700001)(316002)(33656002)(86362001)(6506007)(26005)(9686003)(83380400001)(5660300002)(7416002)(8936002)(55016003)(2906002)(82960400001)(122000001)(38100700002)(186003)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?S9FgH8j7DP6NUx/0Zq4Gm9ZpU3ICU1GcBP6Nnke7I2lqmwaMFu1jOao6xpFQ?=
 =?us-ascii?Q?+XZqf2+fMxQgZJiiPbcINaOvDQFfNQUcdwQ7V9qGKUVJZDxXpW6AV80srAc/?=
 =?us-ascii?Q?1qr/zru5BczTCSbzV++qpqS1ikVZ7Z54Ru9Z8jUrWxaEvZWK3sC4LLH+jtnw?=
 =?us-ascii?Q?fPwG7MnCKOpddZFUkBvIv1eRRD9ZMOkNiJl7GQCaQiXykXcVvTkKSZVa26NR?=
 =?us-ascii?Q?P4c5dEwJs+JrrmMHBPUmZ6HTydZrSBe+q8UGCh2gamEy2KkpR1tLdUgqPc1t?=
 =?us-ascii?Q?R2e8mgyGDADrzy7wzSfyPggCigeGO4CL6HYs1aIf3u606cFR09EiIYBf1Jdp?=
 =?us-ascii?Q?rL+ii9AtwWGbhool3Wf/9j8bOZAzJOfDOIu+IRbiv+NKTLn5o/nlO2BKismK?=
 =?us-ascii?Q?k1vxDUtei6ZH62T3Os74lN3PSGbrx7kdXMT/zQHH+eYNRrwRbvroz/0Ho60J?=
 =?us-ascii?Q?/aNFFQUctz8hzGLYnxgsjfzXqZHkMjPleOD4Pw6VS1wIiLxFFjzolUiCwKhV?=
 =?us-ascii?Q?8e3uZRV8ZzUkbeQgVUW+XkGzGqAfpBy8WP4nsIZ+S2FiJXthcwCUckOSZimc?=
 =?us-ascii?Q?sK6lMavsSveqS05bzT3WV4FlLkJN88P03yaUr2eE/5OhhDi3F6IBHAUtVbaa?=
 =?us-ascii?Q?EhsjJxRpRnoDQA7Ak8+FfWKHOwtmnRC0K8MtJF/Ja0rB/VzBTyZ5eM0erfDW?=
 =?us-ascii?Q?uxAKqI2KbdSXSkNjkvgMdq5fr33nWIGw7DSgkbKoMV9uVsUUnJ51DNV715hl?=
 =?us-ascii?Q?acOVkzHVan/TlINdAhWmldrBJFVEpSGwLwyAjR3qGFScQkXScAQm0qIgWDV5?=
 =?us-ascii?Q?i1Ao0J2nQXSoewv2SrRswGX2zOwdWe5w1IMrbMcszk8qR8a6mPAZ5mrHZnju?=
 =?us-ascii?Q?Y0VgUetzIplyNAE9XKofcrZXqJChBrefR+OP8oPJHyUrNq/+3zwlJb0HWrNW?=
 =?us-ascii?Q?wR6PJL5WspM1bL7t+BRS2xq6C+5RW+2U7LiPRqg6kmWWksgI++6kO5nKUZbZ?=
 =?us-ascii?Q?c7TyXp/eUdtVokhQa9Ubbop6GUqbvJSL6UWW2ugPmyveuIhQlLCzmOhD+hVW?=
 =?us-ascii?Q?Z/9U0G5Ona4YREpXmmmnCmNqpEvnb4VPwXpGTDPbgujVRpabR95MvFiYxeWs?=
 =?us-ascii?Q?bvYPJ370tnAY9gBhz8nhP7vMvOZ38UPaivxx2ibgId0LAgwuAyojRs6xrdoT?=
 =?us-ascii?Q?Tki+dm9SCqjiq7tCp/jUc0pbzbkWKdV0TXHMRQWKW/AClrNXxYv1UEbE3CeD?=
 =?us-ascii?Q?B3btkrutiC8CxHWT01y+aSwfeJ5UXEFvIeV0jWJLkj5rAXlIrHzB5v4J29WX?=
 =?us-ascii?Q?9krhk5fKoQOUkI0h+WhCP0VMwb8n2cb8XOz6KRDKFROT+m57enVEWOXaOfhD?=
 =?us-ascii?Q?yfmD3DqG4oImOQmuzYcifPVWoqJxx2Nd/h40lovQl7ilg1K1JSR2cmJa3jol?=
 =?us-ascii?Q?vbcsZEPe9L/6pJKoMBOMyn3R+zKb4xH1VIhm7TEy3qDKeLyeH0z7DFLi/Ipf?=
 =?us-ascii?Q?zboEbd/Vj2I6tJSo+eK0MYwfyTfwXSwOInELL9Q2h5KNLzGgY38FF6MGrMWx?=
 =?us-ascii?Q?3CskuQyoMD6Xk1wJdSo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20863d77-e5ea-4984-30d3-08db376b6877
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 13:24:25.6698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sd5ZFWfUw36AlurZAmg+abU2YNcj4TdxZ97t/Isjfa/001VU29B+7Rmo1PseAvOpP1vf4KshWEqQsVtO0XRBig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6010
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, April 7, 2023 8:04 PM
>=20
> > > > > @@ -791,7 +813,21 @@ static int vfio_pci_fill_devs(struct pci_dev=
 *pdev, void
> > > *data)
> > > > >  	if (!iommu_group)
> > > > >  		return -EPERM; /* Cannot reset non-isolated devices */

[1]

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

hmmm. As [1], when iommu is disabled, there will be no iommu_group for a
given device unless it is registered to VFIO, which a fake group is created=
.
That's why I hit the limitation [1]. When vfio_group is compiled out, then
even fake group goes away.

>
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
