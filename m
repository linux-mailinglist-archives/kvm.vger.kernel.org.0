Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F35B697E95
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 15:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjBOOn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 09:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjBOOnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 09:43:24 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC2A14EAC;
        Wed, 15 Feb 2023 06:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676472203; x=1708008203;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=piqMmaPUu2q/6JrdccPr4eIOli8foXyK0T7oGQJJhdU=;
  b=Fr96X4b88kvFJE7LTthFYJDQbH1QQmVilJUj8MO5f+tsScijeDkRM4d7
   i+S6/n5Qk4NrNC2EnaVi1KlO8XLLmBlTErtGhanqlhKMVNiydpjgPWvFX
   /84ewCx+xJpIucAiMSLXMJ+r+ftGVZ9ylU3AyLs6fEAxdC0OVi9W5zQy4
   dkg/feTnchzWt5EldaFKSxZnq4fUnHiaFhgLO/9HzonVHX8PcmNWMTHKV
   LotRqzs391EqUZGkWDby+Zqk8LeJ7vqUlhJolSQYQJEQJuGM55gtBc/sr
   JVp7HRQr+3cafydHuOMRlm0VS89QxT0juj+RIisu9jgTGX7XfSM8SVV+u
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="330073885"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="330073885"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 06:43:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="738358681"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="738358681"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 15 Feb 2023 06:43:23 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 06:43:23 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 06:43:23 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 06:43:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UArSBtle4IyX8VP8J1IkuEokHuHzsnmTq8yqtvYJa8qZRQggAsOCuoUN+QWRYCCXEnDP4bDOteFhata7/EQivTrP/Qbh6Xt2tpDEom7gcmWPM4VoIFJgx31jFTfBr9m0svV9O/2z0c7qTx4Yg4WizOHM3nOwNhONQXuShoe2vtI91CE8fqAchgY/GMX63Bp6ca4RjyQQARQdbfBYrN3AMRv2olNqa3697YP/bUJhKSilhqhd3A39hH2pvmU4XN/ZjLo6zHTEHMwg6taLW4XwgpnbP7vM0q6vp3Ml9uGCY97YwcNyv9wGxPIx05jT2rMKbFYXKKy8sgixHgAXvr2QcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=//E7DTkdAdlh0unxYeb9+msvfa/Fw4blJWocFKZjP9E=;
 b=W/v4pxqdcGrKNqVUfEzSPKzoy/0hWrSidlzqX5CcgIsJcX+xcgweBB+zNf643LJbmIcAS4myKiXe9erracNYlQNDV2B008Mzd/Gu26AUAXRExo8W2ddPZ0q9EMGrD9K3ryGlKFVeJeNsUYYzLI32ZZqfwL1jo7d/+6ca1tPfdxcrPoaCnFeIYHzk799nloqKyVCW2GmlqBrqngu3rF44FBpe+6fKYImJjNY/RyGmLvn2dpSz4mNpmeASRV/nOIRXQ5GygjHM4QIG2Qwrs1hb+oQmsUNjts6NYE62uzBRE2aRp1p1GIzlRlbfBYRSXr255FGzOarcm1Bd5nwm64Ffgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB4983.namprd11.prod.outlook.com (2603:10b6:510:40::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 14:43:21 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 14:43:21 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v3 03/15] vfio: Accept vfio device file in the driver
 facing kAPI
Thread-Topic: [PATCH v3 03/15] vfio: Accept vfio device file in the driver
 facing kAPI
Thread-Index: AQHZP73OQ1XOEaarRU+iobEkUB6WaK7NioEAgAAlR2CAAkWNAIAAH3Xw
Date:   Wed, 15 Feb 2023 14:43:20 +0000
Message-ID: <DS0PR11MB75299F5D92AAC33FD8690694C3A39@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-4-yi.l.liu@intel.com> <Y+rLKvCMivND0izd@nvidia.com>
 <DS0PR11MB7529B43C7D357D8A0C2438C7C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y+zSRklKkL3rc2FB@nvidia.com>
In-Reply-To: <Y+zSRklKkL3rc2FB@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH0PR11MB4983:EE_
x-ms-office365-filtering-correlation-id: 91b28c91-8d5b-41dc-52f7-08db0f62fbe2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: akKMR6xM4u+65xsEkVrDBoWRZX2+HHemh7eCGhT+1RbR86nvg1wi8tDRWVzBVbrSgnF4gfupAmX334dHnyzrcdT8SlgPWBcD5sqlUOLllpAazXzeYjhAUICD7uJTnvKDMAuyDibgdFj33agBMEBevOf4HUgc5v7uxg3vk5DdBdMYGs6x9ZQNRh7V9SNtTATYY6xuBrYZH+LEpkP5jooEltSUZhAI9V4eH99Rt2Z44/RsFfxarLQQ1f1TN1XeidTNW51ONP3fapomSvNkE82V1/0gJ2KNFa7ZeiEJJmb/Ceux+pO+Jb1URCurdbCYdFw8Xn9TqIFgQDkXtoKTKawzKLIVkM1+bjW99u7jx19CU2+GD139bUI4Dp1E9EXblMTao/gLdmEW+W3GYok69dmOeqU6CpMFAFY0AqQe+Fh7FsiwVbab0IE4TTBWkM818Pn8gdUL/FCZLaYGWSZvQ49uuAMG0FY8Xn1ByhPUA44GBoiIGg362nPJutl/i0KijMSIs9b0k1+cEln0ZfPRYo+O250in4M+5h560n8i1sYkSH3VuyNm5ramhzXfnGp090zEslnpG/C6fR6KTysIyWnJbqHde+Mzs2m3pDt4eUwlyvXh+UWP6XL4qPXjfj3CswMY4M2dFBK3y6FlsQLt6mLF2JL4YKuj9Qe4/u4hIqSk3IrkyxQmk4TeObEsMvWW8jD9GboWfijGVpkXHIxTTmAetA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(396003)(376002)(366004)(136003)(451199018)(33656002)(55016003)(54906003)(316002)(45080400002)(83380400001)(186003)(9686003)(26005)(6506007)(38100700002)(7416002)(5660300002)(8936002)(52536014)(7696005)(71200400001)(966005)(478600001)(122000001)(2906002)(6916009)(66556008)(66476007)(66446008)(38070700005)(64756008)(86362001)(4326008)(8676002)(76116006)(82960400001)(41300700001)(66946007)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1ynY0ylTcPG5gKX16JBxqN6GRap+WbKF4OE2G8WM/zkpQIbvOnTB5U88ZnU6?=
 =?us-ascii?Q?mvStYDj/i+A4l1In+VEdUf9AZk46/Ri79gkKPAIXAbT/YHs6UzRKzIFIa7fK?=
 =?us-ascii?Q?9cG2bfw7QyiYNV/Z9gTSCJEy4MFro0gcTKS/7m4X4Nqy3pz5IlybvahpLSi6?=
 =?us-ascii?Q?GzxqA3fMxub0tD+uRU6UNtcyXWfaK9eqn/Pgw3lvWsCBwAZXIEmIZyPpKVEe?=
 =?us-ascii?Q?ujRRHXtmqJSV1f8vTWNTZo6NEn+IO4wikhQras29t3SoJuLEljbaXeMrtHAx?=
 =?us-ascii?Q?27DMn6hdov5T1JP1GPlCXZaALdnACURPv+bWoLqLc2BgmYDYgTuqDNx3C7og?=
 =?us-ascii?Q?Msl2YQrXjOzRe1oHiYS1dJRC9QBsVSFdPV52EiNr44qbt9HgRz6V5VpZ+gj8?=
 =?us-ascii?Q?im3QSDPM/vKcmOnCqdekifUACD5j6L1/rIb6InD6ndUuLho/MNwZUpxbgNxn?=
 =?us-ascii?Q?hBB5Qe1Xgo5lhhEn71I9YNcQe/wPEJ4lpqtZFV2yKuJjaad8uCRCFUYwWbGX?=
 =?us-ascii?Q?jW2q1+fekSDgRH4ZBBTAZACjs5y97Qv7EHolQ+Pv09xnDVpDAbLTdloVPvxQ?=
 =?us-ascii?Q?8xoRia6PvN2yTo1OwtbuyaUO7xV/IR1OyrjABtu3nDNfzttpfwuJzFGG9IRG?=
 =?us-ascii?Q?HQQN7+1FTYommDbrPawOfBeQflA9XV9TEbH/bhNUtyDqyILzaFhfnIdKq9MQ?=
 =?us-ascii?Q?5GPzSZx9DmsYwH0gHTuwRo8H9UPnFV3FiKFDqu0QDPDoQ83gTOKpxEe4QtrM?=
 =?us-ascii?Q?0EB4iH6brdzKcIuUjm0/tBUTNIIQXaJiQKUsLjapx8JnASarH8CzPJdo24Sf?=
 =?us-ascii?Q?2DSUNCoVDWSXfH3InlgNI1TcLXQYI26yNS7jHBZZ7TfhkXyNCzQWDD16zG0b?=
 =?us-ascii?Q?zRaWqF6l0it+yRuIYBv/vP1UaePJXjhTOc9ySI/JgUK6ohJSrBzWxTnQ29HO?=
 =?us-ascii?Q?8MJeztnUrXCfyLJppUAskO9nXzjQYOGRr0zUhD06ZOwbewYblwCVb2aY7gte?=
 =?us-ascii?Q?NlYuzeOUChGEuVTn5nkWcDJlGyPxn1UsMRUHhGf7DENFOWrEtTaUerUbdOfW?=
 =?us-ascii?Q?+sPs9Hdu5SOOyvgZylTDQTBAxD9255rCl2YPmK20GcKV08Ji0hNNgcHpuN2c?=
 =?us-ascii?Q?FZsl3MXwgbl7Walu7gphF9RU+Jh8/WPGRaTi5sULFdSkQ5CrBg/T0ohCBanj?=
 =?us-ascii?Q?ppqv7asbujOGgSdtcrG2CweZcvNPqLkKQIPcWVRUh+qrlDcSAzySvts9wNlQ?=
 =?us-ascii?Q?dywqhM23NRUyscwChRcqIu3BASv8SJWu2Z0uSPSKgflaAXUjeKECNPfbzmfd?=
 =?us-ascii?Q?zmvSAElZDyNHrdkPeTQkkaWOdUZ5Q0pcc/2QUw/EbAW4hvGVp89+LolFu6jg?=
 =?us-ascii?Q?L8foruixH18L/lbef37j6GNknb1Yyeek52f4Wp6TRLnxmuQZKQd+18cVQRik?=
 =?us-ascii?Q?1pnmXN/Nmz67fFJroCddykx9mkXhTt96PkD9+OjZYPvBSA9fUy9I3IU0eUI9?=
 =?us-ascii?Q?e3ivVlXsTDe6XdR1kaQ01uYmNpD1wveENu2sixi+1P+FHe57mD9lZ1rVOgw7?=
 =?us-ascii?Q?zoL2oRb0taZ3kb2l6vWlRJ7cVMiHYLXyCGgei9QU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91b28c91-8d5b-41dc-52f7-08db0f62fbe2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 14:43:20.9870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dc5UPymBTwHDBogl1/gKpvtN+VbhZvywHTpAWl8n3iG1bhlVzNxu7c0Flhav7vEW8IaNBLq80vo9JDYdvdXs3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4983
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, February 15, 2023 8:39 PM
>=20
> On Tue, Feb 14, 2023 at 02:02:37AM +0000, Liu, Yi L wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, February 14, 2023 7:44 AM
> > >
> > > On Mon, Feb 13, 2023 at 07:13:36AM -0800, Yi Liu wrote:
> > > > +static struct vfio_device *vfio_device_from_file(struct file *file=
)
> > > > +{
> > > > +	struct vfio_device_file *df =3D file->private_data;
> > > > +
> > > > +	if (file->f_op !=3D &vfio_device_fops)
> > > > +		return NULL;
> > > > +	return df->device;
> > > > +}
> > > > +
> > > >  /**
> > > >   * vfio_file_is_valid - True if the file is usable with VFIO APIS
> > > >   * @file: VFIO group file or VFIO device file
> > > >   */
> > > >  bool vfio_file_is_valid(struct file *file)
> > > >  {
> > > > -	return vfio_group_from_file(file);
> > > > +	return vfio_group_from_file(file) ||
> > > > +	       vfio_device_from_file(file);
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(vfio_file_is_valid);
> > >
> > > This can only succeed on a device cdev that has been fully opened.
> >
> > Actually, we cannot. This is used in the kvm-vfio code to see if the
> > user-provided fd is vfio fds in the SET_KVM path. And we don't
> > have the device cdev fully opened until BIND_IOMMUFD. But we do
> > need to invoke SET_KVM before issuing BIND_IOMMUFD as the device
> > open needs kvm pointer. So if we cannot apply fully opened limit to thi=
s
> > interface. Maybe an updated function comment is needed.
>=20
> This also seems sketchy, KVM is using the VFIO fd as a "proof" to
> enable the wbinvd stuff. A half opened cdev should not be used as that
> proof.

From this angle, the group path seems has the same concern. Device is not
opened until VFIO_GROUP_GET_DEVICE_FD. GROUP_ADD happens before
VFIO_GROUP_GET_DEVICE_FD.

But group path has one advantage, which make it ok. Group can only be
opened by one application. So once it is opened, the devices within the
group are somehow obtained by the application until group fd close.

Cdev path may also do similar thing. E.g. one cdev can be opened by
one application. Then it should be ok to use the cdev fd as proof to
enable the wbinvd stuff even the device is not opened yet..=20

> Regardless it needs to be fixed for the pci usage.

For the pci usage, does my below reply make any sense?

https://lore.kernel.org/kvm/DS0PR11MB7529CFCE99E8A77AAC76DC7CC3A39@DS0PR11M=
B7529.namprd11.prod.outlook.com/T/#m7c00ae5dcae15f42b6dc0b3767c7037b99f53a5=
6

Thanks,
Yi Liu
