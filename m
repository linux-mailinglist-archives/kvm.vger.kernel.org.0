Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0FF87546D3
	for <lists+kvm@lfdr.de>; Sat, 15 Jul 2023 06:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjGOEU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Jul 2023 00:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjGOEU1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Jul 2023 00:20:27 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFAF35A8;
        Fri, 14 Jul 2023 21:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689394826; x=1720930826;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t6u0sWpW1Z6cQfl65EmdN7ZF/30rMzxfOv8DntzwYGI=;
  b=S5KMl5B1mvwqC4ZtfzEGRSCN1azZXA6Vb3DL9kKvH1tLhjs1augPtjUl
   WUnyZl2vhgx8+JRwwU+0/mKzMkyJxB2rQLiTMuP2taj7B31dxxqzX+Ggi
   yb419PiSG0UbEhCBY6kH5mAKH+ISWcma6+gZw3V7d175CSoBrQmYYGdhc
   ojStz02vbNCNK5ru5OrKSrwMKHKpmjDmBoihIPSObPlgPp/yAKFr+0dV4
   tEf1dd16ZoNNnivvHVLTbCXwnDYnJ59AuLYobf+osGDPqv99LQU66SWPm
   EBGtSCHQMq64l1VnIIM081oT1iY+yYH3jebXC+yogfjNmDh4xNdg6K7s5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10771"; a="431808369"
X-IronPort-AV: E=Sophos;i="6.01,207,1684825200"; 
   d="scan'208";a="431808369"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 21:20:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10771"; a="699916508"
X-IronPort-AV: E=Sophos;i="6.01,207,1684825200"; 
   d="scan'208";a="699916508"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 14 Jul 2023 21:20:26 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 14 Jul 2023 21:20:25 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 14 Jul 2023 21:20:25 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 14 Jul 2023 21:20:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ST/yncisQA3kn/OJvyaJYID4IM+eKoYpCNAZSPDqJ77KqJpoclXdaWbEAdzjlBc76gb2mXnjEl5rOvsJjoTvXy6Rd5MdSbq1xbpWWAB8yGCBA4I6UI6Qjo1UuoUl2KRMtdsuzFLwHSKbIZMiy2LI37b8HSZP+hlPWcGpcnLQgMtoR5SU/WBZAPR6H4PtnSuTn9/Im9zRGmBGXSv/Qhjc/7GDsRLBeqLFSwJYEOWCEHb9c+JjVn5kiearNO//22Cpgnp9FtKPy4Lc3A8x7BxvL1CrG25uq2Hsm9knY0MzWRez0LYkMA6a3lb5kWnWpITgrnPhc77t1TklH+MQoShvPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lef6Qrdk0rAxX13nw6UZKET+LnymidzyjOmK7cqeHo0=;
 b=n7XkS20BBndQnBapshlfgy2MwukOFyvWcrZb77TXfRyCyoImywXZvGHptdk8xW462lYvLfYY9a76StqdPh8ZAH+lyrfwpYUmoDRYHHxmvZYYsHixRTp2uMA2HLT1KsixLOpRRwtYXgDVvMs+MiimEWYETRRhrdGJwOYemVLlRpDrBwjZSFEvvWlFXmPhVQ29rrFPPmGgvsffNPu7gYLCx93oS6WBxyohweTyFTyaK0o+7ooDwaXvRoSdQ8v/ziOr+lCB4qt3vhGfQYPzPuKE4RTzOTw8536CJ+SN8MpOfy3gKXODhBjmDkLW52H9N8oni/dtP3qsR/+cJPsbZh+2YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ2PR11MB7574.namprd11.prod.outlook.com (2603:10b6:a03:4ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Sat, 15 Jul
 2023 04:20:21 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::806a:6364:af2:1aea]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::806a:6364:af2:1aea%7]) with mapi id 15.20.6588.028; Sat, 15 Jul 2023
 04:20:21 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v9 09/10] vfio/pci: Copy hot-reset device info to
 userspace in the devices loop
Thread-Topic: [PATCH v9 09/10] vfio/pci: Copy hot-reset device info to
 userspace in the devices loop
Thread-Index: AQHZs5/QXQJdyJhVckGpSOI0Z6K7Uq+5SUKAgAD2ocA=
Date:   Sat, 15 Jul 2023 04:20:21 +0000
Message-ID: <DS0PR11MB752919588C5A572EDE30DB2EC335A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230711023126.5531-1-yi.l.liu@intel.com>
 <20230711023126.5531-10-yi.l.liu@intel.com> <ZLFPd2coVKPcI05G@nvidia.com>
In-Reply-To: <ZLFPd2coVKPcI05G@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SJ2PR11MB7574:EE_
x-ms-office365-filtering-correlation-id: ed3c40b1-2cb7-47f4-aaf5-08db84eacddb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ts+iGj6hYcce1fn/fvfebXzOrvlYqYicC7fjKx7znH8gyfYABU5MQQrjbQ9kqKxTM4Zf94EUwSJezAmRsIPxGA8vkfUFlEEo64kyd+AhjMTsxNfRo7ewfh9jCVw/HiR7wE4svzl7111Z0OErv4qvkFqTHbnxKlJugSxAyqR0g0DUX2fUp/IB+21E3m6pC8IEILDzkZptk9J4lnEChInbOKK11oCbKjBS5XDVgj7MA+ENVQT8TLMRoIO2DKqOIbMVwFc1w26KB80uNluftkXZZeSuKEGI0bc7TowdyN33qoVAi+8zRUj5C+hlAbceHZ/dUZKJL0Rc6BPPPmHiCXJ2TDWxANlM/l3CtlJPIeMy6izAH1slidtSROWWi3T+78depvtN8jO0qdAAQ4+lXD53KOfhcRAXEpq4NMJa+KJ4iKmGLS+OwnZKwdj9ITQc4Bx85IEPD6oVmSv4ZejUF5SSF9suc9a+FGrkcZ2OyhjqEnaqVhGeq9ffoKF8uObP8qeiXHzhBvn+EGOueGg/S+UbMOus8nR4hdLuOyR4MwPVVLL5Pps4Tmb/w0nEN4EFKNsO2lWyLG+rUsirTSZYADFzxhsRhoXi3dpPEAcysS+S37E9l7nC0FitvNrOFPFJPwJW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(346002)(366004)(376002)(136003)(451199021)(76116006)(2906002)(7696005)(7416002)(5660300002)(52536014)(9686003)(71200400001)(83380400001)(186003)(6506007)(26005)(55016003)(54906003)(33656002)(82960400001)(122000001)(38100700002)(86362001)(8676002)(478600001)(38070700005)(8936002)(316002)(66556008)(4326008)(66476007)(6916009)(66446008)(64756008)(41300700001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iRx+gIuibUqA1W0+K2BGBGwQ9bQvdSE2v9DZAtPjkzV6it10E2El7G+6zsH+?=
 =?us-ascii?Q?sHC6Ume4lzsL6UKtX7NO7eli6mJ2wpMjl8KlCwmRiIcZx49tFPiC5OPf17Vh?=
 =?us-ascii?Q?Ym6Eb/PTY+gyqbDm1RlfIRP5zLuIkAIIpzxXAf5qUdLRCSAxiSVsgB6htrUZ?=
 =?us-ascii?Q?bZpZ8lt7LmIiyalRrVy3t1L2AmppnNVBQGwiNkuuOY4SKK5ZTOtZe0GAXNuS?=
 =?us-ascii?Q?j3FDYFnDCbLTGgJlhqJKT0OZr0kb2QyE8GaZKXl/0PHCClCjiq8aZ5wxYyGe?=
 =?us-ascii?Q?UOnuEYyKNlwU6J5iflXkF72k7ysnoylEtA7739MUagz6jKLO5DmAsVOVx3jm?=
 =?us-ascii?Q?4/6eKPbm77cZix41oS0B/vC5yzPFzKwhpTP/roKwbyhv8vIBRdVghcvuHdZk?=
 =?us-ascii?Q?seipUt7xtDvHIEMlaYLLA/6z4gb7zXcewzXckT21v7m9uFOvVEccGrHF+UFq?=
 =?us-ascii?Q?JbSTvS0u3v2i09AO2YabdeWVxoyFagMz24Ce3rBf65c1nB28M7jceZZafjBU?=
 =?us-ascii?Q?7b6d+0twVAvzzdblyy1xeIFGljs/zeY5cAjrl/k8NhhhMZCHzNuTy4Xq9hif?=
 =?us-ascii?Q?dI5B2cf5ooya+DhW988//b4P3wsX/Q3G8tJOUS0Zea/BN+HYe5rMfCaZVQnY?=
 =?us-ascii?Q?o+KV+fvywQJpUQw5UPezrv8ESR2RcRM2D7tsfryZhf+Ltd8butTnDC59S8Ml?=
 =?us-ascii?Q?Yf2JyhgXvlRig1gFsHy6DaYXg+PDt80cnWed5kkovEM3fAFImLRPCYeHUfjV?=
 =?us-ascii?Q?WB8273wEYkxZ2vK6Xl9cAy0joZlymZPsgE4bV6uXWgPbpkkIiliuaUUzPtHu?=
 =?us-ascii?Q?ptdCtSo5pD3Y64gFA5yUjhPgVuRGw43dbgZ4XFIZ+agM7wRGw70TNR/TtMp3?=
 =?us-ascii?Q?42w5cebar6Fwdet4vxEfmTI5SUeKA0xk1oi0Pe33yemRBkU9knzwSFtVLEmR?=
 =?us-ascii?Q?eAqzV7gPQOZEtCitEKWECmVinb/D1vCGCp9YkgYXeuDODLvpwlJDmD2spPll?=
 =?us-ascii?Q?s471Iqdh+AdztOzaNqZzc5EIu8bAUcIdB7s9sZC0tdsuWUSBVdM14/e5a3xg?=
 =?us-ascii?Q?y8vdV9cw+RMSwDNRkp5aa+3qH6bYcoTy+1+UKSXboSseaNz+2cbUWrH+eMaM?=
 =?us-ascii?Q?/PJ6RIvGOca4TtI44Rffibf9TC21s6ac/iglOYgrykYgGOLBoYH58pb8dgT6?=
 =?us-ascii?Q?DrhH9WqxkgeZoO8I4N4Zg15fcXt/Ma2wYSYbnMIR77GSaWYUFRCAMJM7jw7T?=
 =?us-ascii?Q?vKFl9rYCbf0mvQh0nKNb4yYHnib+GfHGQAfSq3kVYYpC+kv7ZklZlVs6fOdU?=
 =?us-ascii?Q?dhgolQiJklPA7rBAcfNxDj9ompN8jlV3UZpKDbFVSCBpLVHaedLOcEAaDMDJ?=
 =?us-ascii?Q?Dsg/cJmQ363pd9uKdOVGl7f/xG84AlHs328a1+r9cI7z0QOosDLGiiDLTPUI?=
 =?us-ascii?Q?q4NZF0YewawLnpL+GVT8FPnruNtL1+HH9rw04byUZJeWuWwqET1ET2eEpXSV?=
 =?us-ascii?Q?nC/WX6wOPcmg1n8b9nr9HC1aNIFft5d1Qzq4WX1710isk/hH49eRoPgoOvee?=
 =?us-ascii?Q?U1Kn8uuVw28rRxGpEv4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed3c40b1-2cb7-47f4-aaf5-08db84eacddb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2023 04:20:21.3519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fO/SRQAt4UubAaUV5lO/DTqssO2POgHAeYrEgQ3cmuXtXs4jgX2aiXGxaseA95HvHjo/Fun1lLz4VeaUb+Vwhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7574
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, July 14, 2023 9:37 PM
>=20
> On Mon, Jul 10, 2023 at 07:31:25PM -0700, Yi Liu wrote:
>=20
> > @@ -1311,29 +1296,17 @@ static int vfio_pci_ioctl_get_pci_hot_reset_inf=
o(
> >  	ret =3D vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_fill_devs,
> >  					    &fill, slot);
> >  	mutex_unlock(&vdev->vdev.dev_set->lock);
> > +	if (ret)
> > +		return ret;
> >
> > -	/*
> > -	 * If a device was removed between counting and filling, we may come =
up
> > -	 * short of fill.max.  If a device was added, we'll have a return of
> > -	 * -EAGAIN above.
> > -	 */
> > -	if (!ret) {
> > -		hdr.count =3D fill.cur;
> > -		hdr.flags =3D fill.flags;
> > -	}
> > -
> > -reset_info_exit:
> > +	hdr.count =3D fill.count;
> > +	hdr.flags =3D fill.flags;
> >  	if (copy_to_user(arg, &hdr, minsz))
> > -		ret =3D -EFAULT;
> > -
> > -	if (!ret) {
> > -		if (copy_to_user(&arg->devices, devices,
> > -				 hdr.count * sizeof(*devices)))
> > -			ret =3D -EFAULT;
> > -	}
> > +		return -EFAULT;
> >
> > -	kfree(devices);
> > -	return ret;
> > +	if (fill.count !=3D fill.devices - arg->devices)
> > +		return -ENOSPC;
>=20
> This should be > right? The previous code returned ENOSPC only if
> their were more devices than requested, not less.

Yes. it is.

Regards,
Yi Liu
