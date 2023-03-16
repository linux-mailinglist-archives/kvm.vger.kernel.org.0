Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC9F26BC5FF
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 07:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjCPGJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 02:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCPGJr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 02:09:47 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5A0CDCB;
        Wed, 15 Mar 2023 23:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678946985; x=1710482985;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5Kcxxi/7/ntzWUZhPaZ2TyraMlCa8Oo9H2VsCxZ9srk=;
  b=gwJgWx773GujToMuIn18DQUF9Uto0FhExTxCbdkqaPlOJFQRyLz8nUhX
   SgqVnjd480BoF0HyfYNjLiwDrH2ATZl7hVea4vnyb25OKsGRrvpHfTd/E
   0SwAo+NJXpWM4GRnTWCHQaSDa3u6suoARzw9iHhjwN8XVFdoPOLiCxu68
   MJGrJy8uv2g2fQQnIVCUjaI+eJLweSMOj6DCTjoMIujuGoVf7d96jp2tT
   cOxLoqYh1V+CFc/4m5Dhw+BK10YiBQLIXvRmOTA0EuiJ7lKqpYMm/2Nx7
   10Yf0RuCcQ1UjU+ZEPJ24fTmsY/eb8aai39yGpdFoBnPNCLXL+1UAVSNp
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="402771567"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="402771567"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 23:09:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="748733289"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="748733289"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 15 Mar 2023 23:09:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 23:09:44 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 23:09:44 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 23:09:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QpLmL0SeHAKwUXnPTEKmP5nFO6bRSuj6V+YgKPTc33ARcxAVERvkwsvy37D73JsA3k/4KxwfTrueC4FW+wlSgzOro3pXiZ3ejpBpFgJgD0bkBgVkx7DdiSh+Vf6Di3ZMCdxgosPh0HWffvhnOEymSAg4G4qxwgmn6leYgU5VNQhFXtCHLBxTsYhIHEF2brCCCI4BwmXi5CNs8JxB612kLa+X4A5CPWO0pByV5FrmcGwAnzx/aShaIlT1PLB+Y8GH5nna7HTs4OYmvsNB8QyS8z8SAAAkAui6mz0cb2wa7ElFiz1JOdk25aUjAE91XG477DOt2fhSnQVy7Q9aOlAuDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UZtkMKAoHVzRLA3wMG8//5AvEJ/pjGkzgg7jKmmGgnY=;
 b=nZgT0gAoar48wcboTvNEyLFdFznLPf1NLb5O2L/hHuh4I7o1g/v/fL7yr+tCFzIMNecdWxQxZb4oo1ugY7tiHBX5cC1NFbEgtGj1sUJ435pq/kbmEDgLZPiizNtmnQ1H5arwPsnM1aYQcp9TxK9AaGCeFyTwj2Ym5Fo99u8NlTU+5AqvLH7ou1R6QAmspTSIXQGR0n6n4gFWwDzLUaDxz04RrsT50G0+BYdRNX2JFM9EmV3cu6mP9l/5Awwtwj9NyFoXBqYD1ZmJEijOd93Znx7z2n/5+u6hTdwpx2apYwv6i3wadOwhWcHOq1a29s9dnG29hVDk641pQ5wq0hzqxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB6866.namprd11.prod.outlook.com (2603:10b6:930:5e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Thu, 16 Mar
 2023 06:09:41 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 06:09:40 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
Subject: RE: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZV83lRcqRA7WVEkK2cFQjwOMGzQ==
Date:   Thu, 16 Mar 2023 06:09:40 +0000
Message-ID: <BN9PR11MB5276ABE919C04E06A0326E8E8CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
        <20230308132903.465159-13-yi.l.liu@intel.com>
 <20230315165311.01f32bfe.alex.williamson@redhat.com>
 <BN9PR11MB5276300FCAAF8BF7B4E03BA48CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529C7D0409B47430D7412C5C3BC9@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529C7D0409B47430D7412C5C3BC9@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB6866:EE_
x-ms-office365-filtering-correlation-id: 88fb1d62-0209-4e87-35f4-08db25e50785
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a5aRz4KUBshbpfCd+vQ/j18PlfTNsBytrE3vzs7ClUQuGeAaY04c7B6hqbZLqIATv1XHpdMz9zqPigFJCxfM2og33ilUlVrNDbepWJn/k8xFKKnitx3OcLuCt2601qu6mOCxXWNYs5wV2g4y7YGUJtQOfNClHtj/0XkE9eZUfYqdAQ35S4e54fRw1d45QEdlanIe8j8l2Ijosfy/19gJQNLS9zYX48FcTWYWpbP2SzlTy1o0CyPI2CHZeAABQ8lH8bJ32EWQhup3W1Lo0NydnY9921raxka0Dlu95hta9TIYlIZoeKqCJOQ6pbe5aG0BZcIZmoqw2w1Ph+6UgTWy9GeVOCDwq+bEa0G39ziJl+IntqCHKNjNWU/YAKoqAMLziJJOJWmKzB16avUIJTqBLlAQXMx7hTsFf7PVMSLuaV/jvHWgDGim8dqvWUNTT0HvKgp5g2JIesHASuemXUBVjhAvLZLGJ6HXP81lkfO7h90dpHXpvJhnhDn6gJo9+2XNxQODwOCfLPb9oIvC9DLr+IKvDdTDDblsb5JBdfQ4r0vAFcCUSflB7UWjs2cvlOTdKyWfpIsKFsFpZvSzG3s+LPUXtM40FxFq4v2KTt3bLnet+BiPDDBHyp8YdcevGaNpwpumefZHloCPo3f5z1pgkytqlkaVEqNg2PePJADanwN239OARM8xfmVrYRL/QNLYtWLJ88nCVyBTyp+nsgYxWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199018)(86362001)(82960400001)(122000001)(38070700005)(41300700001)(4326008)(66556008)(64756008)(76116006)(66946007)(66476007)(66446008)(8676002)(71200400001)(7416002)(7696005)(2906002)(55016003)(8936002)(54906003)(478600001)(110136005)(38100700002)(52536014)(316002)(33656002)(6506007)(26005)(5660300002)(9686003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?F66qr0YLv7ezpxnfhbunMV87Cz+YzQ+s3fKVPTW0m8oAAfqkChssyVPGXmxt?=
 =?us-ascii?Q?lK/0IjrbXDQqPKk2g962Cta2mKibJAFrjTW37Guo4iDIE2VngpWC88LKjKuD?=
 =?us-ascii?Q?aryOBavnBOS06S8R04fjc54aYXWezb4d+hn92o6hUr1WnNCLdDeSPBDGUHSK?=
 =?us-ascii?Q?oCb0IZwHWptMcLcQ8+fcQ2K2LxG02EzTrzFcz/UR4pD7LBiG+qJHbYGqFv7K?=
 =?us-ascii?Q?tE7Xx3hNKvVwLlOQTaA/1J/rlZwJzVJxsjUNmWjhhmWGuLSiuYBPyB29hZ32?=
 =?us-ascii?Q?oCFqcfv6zu7AKDUCc01/C4XePyC1UVZ7E/lW7vwczgXii1qi+axpGtN+Ub4K?=
 =?us-ascii?Q?TukM0/8WAC9CfS2PCBHkrmoCJ9TmBJV71VyjRXOqHRpyGd5GeL4OXOtU81k+?=
 =?us-ascii?Q?OvHkOJTmKDWNsrCAcXdVeHQv/Eso/0Flx8YnSodN9pKOH4Or0lVx75hDSDg4?=
 =?us-ascii?Q?ZwndoPVZnxoQkB1Sk0BhdMozBO+L4A49PAdU5K0UQAl4xGqM7++xIRiiG4WC?=
 =?us-ascii?Q?8FgTpXT1sWpuQBnrQNGyw2pDAQynSk36pRsv+C6fLAs0xGr/CNi8nfBNHiHx?=
 =?us-ascii?Q?xr0rIIJzF+eXxNf5z3D4HPs5CIFe4uS0CUshSOEYaNUiSvVCSVBEdOYVCUZF?=
 =?us-ascii?Q?ec1LjGRX2kAnxX11RZiV0WeZshlhtF2CfiDP0SaYO6ovF2GLW8bFWQuGBpiL?=
 =?us-ascii?Q?BWPneZLYHuxgqP2fA3LJfdGNIMbro3BrCeyp6NVRxHdoXzTm36Rv+coNF4RN?=
 =?us-ascii?Q?giwv7mJhKv1B/CVAixPrywBlV/WuJjlTrd1t5v6etWbreTzDBC+2T4YFnfRh?=
 =?us-ascii?Q?buP8uOtNLONlevUNyIwOc1xbgsAgQfUCPLb5N+BC04awQLQRb/wQltFge0wI?=
 =?us-ascii?Q?fjQ2rvHrxCfZw4Y9EhEWzlzwOLXRoFl6a+jvfR+FOTZKjf1n0r0HdQDj/ZGJ?=
 =?us-ascii?Q?+d8T9GngQqPAIU1QrM3fRxr7/MbmygP1fPN4JsXvjvEaD6qp6DOiINldB8Ui?=
 =?us-ascii?Q?ayHPOrOxp4kDD11CyMEvzuY8CF4huNNakQPlQd4VuvvIlRuz8M3z0lgcA8Km?=
 =?us-ascii?Q?T7ZIY06Be3CK543FdB1idBJh4u2f7wyt8QTKl7hRhIQa1sHk453AlXGYeoSV?=
 =?us-ascii?Q?vrOPJubcWxMLBbGHODDP095RhTmIOmANB0pSi/3gTnclP0jZJLvP7+Q07bnN?=
 =?us-ascii?Q?6Zx8utwKSTA2dHxVOrq4h1LpQPOJlVbx3UfAloHrGMtaeXndC/2Nxp4l9Il5?=
 =?us-ascii?Q?F8aAKTncJ/3uviASNB8/3zqKO6Yrc+qnWt+VeoeFGHz4bgdnzzJXOaCXaOPf?=
 =?us-ascii?Q?u+WZS40t7STnzexHAnbPk8p3Vk0dz3nz43JqOkUNwq+KsDKxVEGkGdBotVfW?=
 =?us-ascii?Q?M9xvdnq+5V9Tmos4uGjHFS+SLYACwsGxil6zoyBUTj26ltptr08MkP7XzZvh?=
 =?us-ascii?Q?/I/ScS5tjX1sPLe9IG8HaSC5k0h/Otcn3Fs0YgXyOnzi9gL0tZKUZDggunQc?=
 =?us-ascii?Q?BsIvCOY5k7tnn+kgfAAYvInvVZirW10pAsXsme5z17EwA7vXZ9bmQbJasVw0?=
 =?us-ascii?Q?Pf0HJopk0wjYihCFbsEY8qQ0hGmh/sX5XX7H/PYX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88fb1d62-0209-4e87-35f4-08db25e50785
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 06:09:40.6653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RZ9atT5kZ2nksm2FeJ6mPuJ9hLwKQpIOlIaxXA7yV80TI8C4suPPPW2DCCR/K7mfqqrbFv8jJe7cUbZZqwQmCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6866
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, March 16, 2023 11:55 AM
>=20
> > From: Tian, Kevin <kevin.tian@intel.com>
> > Sent: Thursday, March 16, 2023 7:31 AM
> >
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Thursday, March 16, 2023 6:53 AM
> > >
> > > On Wed,  8 Mar 2023 05:28:51 -0800
> > > Yi Liu <yi.l.liu@intel.com> wrote:
> > >
> > > > This is another method to issue PCI hot reset for the users that bo=
unds
> > > > device to a positive iommufd value. In such case, iommufd is a proo=
f of
> > > > device ownership. By passing a zero-length fd array, user indicates
> > kernel
> > > > to do ownership check with the bound iommufd. All the opened device=
s
> > > within
> > > > the affected dev_set should have been bound to the same iommufd.
> > This is
> > > > simpler and faster as user does not need to pass a set of fds and k=
ernel
> > > > no need to search the device within the given fds.
> > >
> > > Couldn't this same idea apply to containers?
> >
> > User is allowed to create multiple containers. Looks we don't have a wa=
y
> > to check whether multiple containers belong to the same user today.
>=20
> Hi Kevin,
>=20
> This reminds me. In the compat mode, container fd is actually iommufd.
> If the compat mode passes a zeror-length array to do reset, it is possibl=
e
> that the opened devices in this affected dev_set may be set to different
> containers (a.k.a. iommufd_ctx). This would break what we defined in
> uapi. So a better description is users that use cdev can use this zero-le=
ngth
> approach. And also, in kernel, we need to check if this approach is abuse=
d
> by the compat mode.
>=20

In normal case legacy application uses group fd array and new application
with cdev uses zero-length approach.

In rare case an application which opens /dev/iommu but opts to use it
as a container in compat mode can also use zero-length array to reset
if all devices are attached to a single container (internally to a same
iommufd_ctx). It's still kind of matching uAPI description.

I'm not sure whether we want to add explicit check to prevent it.

Of course if affected devices span multiple compat iommufd's then
it will fail.

The open Alex raised is whether we want to further extend it to
legacy container if all affected devices are in one container. But
I hesitate to do so since iommufd is the future and if an application
can be rewritten to utilize zero-length reset then it probably
should explicitly embrace iommufd instead.

Anyway let's not wait here. Send your v7 and we can have more
focused discussion in your split series about hot reset.

Thanks
Kevin
