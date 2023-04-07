Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03B16DA80B
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 05:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239410AbjDGDmw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 23:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjDGDmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 23:42:51 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E239ECB;
        Thu,  6 Apr 2023 20:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680838969; x=1712374969;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r/22OF0a20dyOkAE0gULod+Dz8Hsgh/L2rcJdOeZpyI=;
  b=T0INCh4IuM+QpATJwif0ctwuB4E8UvNAT5sWufm2T6MJHP6yVw9hwkMj
   xHYcasKVFi+Va7OPtIY8WH9yt4Sct2AEftCIsZPor8fbJa19U/30V6BwR
   tG5oPTxmnziULSwxExLaJsowHk1m7UQeVCfryS0fV4ew8OJVIB0lZqeBv
   LaHeduiTywzoA6ZNShY5vqExtALnwjHY/CYCtRQ5Imv+6hGiUsAdH2r4P
   vRyxLUD0WlBphUjF1Wzv6BLvbHV8QCAaj2WHpTHzLauiyJcm1Z+o0zXEb
   eOCfCm8ZT5B/451BwjkWyqdH/9f41HCxZbbeRFsBBV2Z0hTGEvud9rwpU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="405737998"
X-IronPort-AV: E=Sophos;i="5.98,324,1673942400"; 
   d="scan'208";a="405737998"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 20:42:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="719937693"
X-IronPort-AV: E=Sophos;i="5.98,324,1673942400"; 
   d="scan'208";a="719937693"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 06 Apr 2023 20:42:48 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 20:42:48 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 6 Apr 2023 20:42:48 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 6 Apr 2023 20:42:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XkhaEH2WJiDP5i1JRu84WGWP+DSLzrWkpwFHNIzPkwMeV/QxpaPjS/OuFBj39MQ5tIBz4W3dWXflZx/a4EbueKj2d5mbenZMpCl6e/pwg7G9M9C+ZaaCtnT9chPrpOfEuqbqvEFkGje5bYXajKhRMmoXP3CCRpyw/0jQfxlAZxqsDG5gkrcMaxjZbKBLIkiZwdZZaH5SNBwxiMVOwcfXYwIJ1nWkoi6qe3Y63Klv9Nr+JOaB5KT2MQGJppdPkZklMVbX5MqkRPw1jkKXWuBz0eI6hJQozz0QbJHP4Okb07DJCA4vSxS1mqVsc+Iqh+efYNSA8C6jX1PGXFrJIHoHLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b8Zj4lnCTrZj9PHHi8nvKxKetv5P7V/bBOT00EZ+4Xc=;
 b=gta8cX/2sNWBKKSxO557DNqpvkCXRx4FKPSXONOKs1vD2vYcYr7Ys0vQVZ7GXixXwjO7nshIrB88qjZlG8WSI+7B7aOtEvlhmKdVb97/Zq3yoX5TPLepaPPk6hjip2CgoJmWyDyURh5ePPFw3McggMo1E1JXZQAyjuwxVniiR068of7ViQE4vXzYNM+zJcOKBJukwEovSYeg4nY2B4Qvl7xVMC/d0NnN7ZlS2rrSzx1bhgGXuN9eZQp4hlvNcEqoOQavjojxh0JAc02AUcLvru8R5UjoF1SgIw36j2D6LU8SbeVR9HS+txiiSvr73yrF7++xEVhPyf/kDZYxIiFZvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW4PR11MB5775.namprd11.prod.outlook.com (2603:10b6:303:181::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Fri, 7 Apr
 2023 03:42:41 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Fri, 7 Apr 2023
 03:42:41 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
Subject: RE: [PATCH v9 06/25] kvm/vfio: Accept vfio device file from userspace
Thread-Topic: [PATCH v9 06/25] kvm/vfio: Accept vfio device file from
 userspace
Thread-Index: AQHZZK1APogyMqqusU2pI1gZ8bbduq8eEBeAgAAP8iCAAIniAIAAjJ1w
Date:   Fri, 7 Apr 2023 03:42:40 +0000
Message-ID: <DS0PR11MB752903283C1E02708EC13848C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401151833.124749-1-yi.l.liu@intel.com>
        <20230401151833.124749-7-yi.l.liu@intel.com>
        <8fb5a0b3-39c6-e924-847d-6545fcc44c08@redhat.com>
        <DS0PR11MB7529B8DC835A6EADDB815C04C3919@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230406125730.55bfa666.alex.williamson@redhat.com>
In-Reply-To: <20230406125730.55bfa666.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MW4PR11MB5775:EE_
x-ms-office365-filtering-correlation-id: e40ddfdf-9374-4592-a394-08db371a2363
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +ITzEIt5viKeIxvrp/LpqHUu0eZGIviuR0X8ddkwWI5FXb6SEIPu1/GpKMIDUiUCMGQiXXiKlD8KhT782jvWcOZMsTV1dkPMKB9bMhvwzd9/zBl/wUIe62VZKgnS7Uwxj4dIDP69SK0yWGc6Ia7raXTQGc7PbMB3mvuw4AmTk7ZPc8/cIACPqAzNI4VnSrSQTt0LRIz7OqFKdBOGmxmhKS+PaQzvgPL9CFTRGZtWVxu6OI9rcyAxTYMGwShYpyn2JLaSRCY9I7momaCJXhFDgwXThd6ot94Hj/1+aJZzS3xXPh6gNc4/1vZJQn7Xp6aQ1C3yHBR7IOXz6Sno/PQ5p2a7Sdj8PAHmqxzZrV9xD1MDuyJGmIC3qF+xTBjLvdD01K1tn7rkjWz9qsrI908JdAp1plfV4kE55zrO61cA0wz1IyYYXysvDaIueaO/u1DcGTGaVqH0fXR19E7P/J8agKsWmOJLK5Hl46vr5Dx1QrTQPTaCoq1m+6EcDkW4BP4OxRae7p7Z8bTH30yOeQRiDmr0y19nG7ktv6G7XlNsjoiO7M7fiU1JZufVSWJLLlA6+sbkAzwAYxVpCfAVx0NRnZ4Snf2K1lAcc2xKQGZT2Nl+50yuH4xXEIsCXIU7RGJt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(39860400002)(136003)(376002)(346002)(451199021)(5660300002)(41300700001)(6916009)(8676002)(122000001)(7416002)(8936002)(4326008)(55016003)(82960400001)(38100700002)(52536014)(86362001)(33656002)(26005)(2906002)(64756008)(38070700005)(9686003)(7696005)(966005)(71200400001)(66556008)(6506007)(186003)(83380400001)(66946007)(316002)(66446008)(76116006)(66476007)(54906003)(478600001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RXLSikOL44+x93gJ5gK5yL4y527jYv9pvTNpUft1eCslWA2uZPmaCaDs08KI?=
 =?us-ascii?Q?OLma3BApbE4XAPG8zLZvPkF37yKwkvMQZTUxG56ghIy9guXvsbQ557aiC/+U?=
 =?us-ascii?Q?ZcUN54XQFujpVyUn0OQ3Yv5NbUbg47DZt5qTjb22tSbyxPyOYF5r+TePfMXk?=
 =?us-ascii?Q?ugKfpAOehLzALKOeXRsX0RmdQp3K0+b8UCYTKgwzq6IyaGFMWrZlH2oGaLAu?=
 =?us-ascii?Q?YahRPEL5QfWqBu+pTu3At1z3ThFTTCsu8ZKCBgUEfWJNrNBc3aW36lsGrIu6?=
 =?us-ascii?Q?swMFfbWUi6wbqV+dB1FNVnX3ZKySdo84XAsYhYLiAWM7y48CGsDWPDajd6wy?=
 =?us-ascii?Q?mHx9dMZPCEiRXggqonffEhz1bRtE8q19gGBx2a13NCQBnM5JTDAX9WOBOw7g?=
 =?us-ascii?Q?Yr0k1yr+3Mzu8VysFRun61gqoChCsY+pCfTMvU90igT01Tu5oEXxgb1yZUxO?=
 =?us-ascii?Q?3ZjJcd8mTAQfl5HdyGvbErIe8nQHCzXyK3RmqgTDuqmP/I0vAtgszyNcY+zv?=
 =?us-ascii?Q?I7nWaGs+pFT43IAUVaon9FETLNL9ECxrIZE6cFKoe68mXIyfsKmA/C+fcvI4?=
 =?us-ascii?Q?pSck52BkYWreMSR2YRiqRnE6znoBT7lQyF5LO3os2YlmgMx/MCg6Is3+Urpe?=
 =?us-ascii?Q?8aym1UNXp5UtLXPR9kMjIpiq6qBp6kWz9S4+jnu4zKdVdCmnPJRXiZVmNa14?=
 =?us-ascii?Q?JfuLgKRAH+i9EN1LGYvf31MXNw/mY+FrnDS3LjO+S6NQyN6brlRnMiBp6zSD?=
 =?us-ascii?Q?hTyN1ItKqipX+rv5f0MG3JHnVT5Kew/Y5UjKrb9exRnRUVE1lqZqvKmupik3?=
 =?us-ascii?Q?IRAxtW/Bs//WyA+DVzllLSsgc+8fmgE6f1kxME1ZdJ9EGpnqv9ILO6mr76ie?=
 =?us-ascii?Q?Tf46QO323/gtOOz/FBqdb0zEBDrl5aFkRdhAzBHxeVeRL2qvHXRL8r+QdBG5?=
 =?us-ascii?Q?5lgHI9Fuls+caWUfzvI3fuED87dUBCpNWoc3W4AkOnDayv0yQmdP/Va5INPI?=
 =?us-ascii?Q?xtJ7eeAuklhc4DEP8Cx0RvdEPBBXoniQhFiLlT5YB0j9ewYM4VjiSJ9/Yj3X?=
 =?us-ascii?Q?PHBbHnf6xULNe5pZPHWXLpVh7hdI8hny2YpRlrZnI2O5Pxjqso9pkAfhLNn/?=
 =?us-ascii?Q?b/LdAnGYNZlv7xscWyxeoXX7KynAHgiMa2Hg0oYHhXGiBvJvA/zqndA1kfca?=
 =?us-ascii?Q?Mk5XUMwI5OvZh6pQXr4Yn51MA0m7PQL8GuAmWVG4cxq1aEaHZFT321wXDl36?=
 =?us-ascii?Q?mIx/Mg54ROMKOMZKJCKZRsmm+tUoSQjCFB0Sm1bCEPpdFAQpXvpnDTN3cBvn?=
 =?us-ascii?Q?036sFjZE5xl5+sFhROcxz8uul0OMoQ7oaeDTUY6BZgLfQx6QORqcSXGRYmgg?=
 =?us-ascii?Q?0yEURp4tUT1k3Fxzs8BIJ5RfhgVRXNr3gHHKLVGjagmeUI8USmTRcJ76pqxA?=
 =?us-ascii?Q?P1t170Ng9fLYvcD9q4oatBJpaju375+fmu60FYrzxZDQdk25SykeTeNWi1S4?=
 =?us-ascii?Q?LQa1sICWpPXxELHGwaHWj5rXSOKjw07GJZPro/A8aOQFToJ24xBa+FRyzYZE?=
 =?us-ascii?Q?C21GlY6P4X7Ptg3VMHA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e40ddfdf-9374-4592-a394-08db371a2363
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 03:42:40.5349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tqn7RIPfLfHjk1X+eF1/898+M81TNQYJMAbsNYxH/tA8MoEtosl3wbqaxBuI2rPkqEjSg48b5wIzLdXZLTro9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5775
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
> Sent: Friday, April 7, 2023 2:58 AM
> > >
> > > You don't say anything about potential restriction, ie. what if the u=
ser calls
> > > KVM_DEV_VFIO_FILE with device fds while it has been using legacy
> container/group
> > > API?
> >
> > legacy container/group path cannot do it as the below enhancement.
> > User needs to call KVM_DEV_VFIO_FILE before open devices, so this
> > should happen before _GET_DEVICE_FD. So the legacy path can never
> > pass device fds in KVM_DEV_VFIO_FILE.
> >
> >
> https://lore.kernel.org/kvm/20230327102059.333d6976.alex.williamson@redha=
t.com
> /#t
>=20
> Wait, are you suggesting that a comment in the documentation suggesting
> a usage policy somehow provides enforcement of that ordering??  That's
> not how this works.  Thanks,

I don't know if there is a good way to enforce this order in the code. The
vfio_device->kvm pointer is optional. If it is NULL, vfio just ignores it.
So vfio doesn't have a good way to tell if the order requirement is met or
not. Perhaps just trigger NULL pointer dereference when kvm pointer is used
in the device drivers like kvmgt if this order is not met.

So that's why I come up to document it here. The applications uses kvm
should know this and follow this otherwise it may encounter error.

Do you have other suggestions for it? This order should be a generic
requirement. is it? group path also needs to follow it to make the mdev
driver that refers kvm pointer to be workable.

Thanks,
Yi Liu

> > > > -The GROUP_ADD operation above should be invoked prior to accessing=
 the
> > > > +The FILE/GROUP_ADD operation above should be invoked prior to acce=
ssing the
> > > >  device file descriptor via VFIO_GROUP_GET_DEVICE_FD in order to su=
pport
> > > >  drivers which require a kvm pointer to be set in their .open_devic=
e()
> > > > -callback.
> > > > +callback.  It is the same for device file descriptor via character=
 device
> > > > +open which gets device access via VFIO_DEVICE_BIND_IOMMUFD.  For s=
uch file
> > > > +descriptors, FILE_ADD should be invoked before
> VFIO_DEVICE_BIND_IOMMUFD
> > > > +to support the drivers mentioned in prior sentence as well.
> >
> > just as here. This means device fds can only be passed with KVM_DEV_VFI=
O_FILE
> > in the cdev path.
> >
> > Regards,
> > Yi Liu

