Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C963695649
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 03:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjBNCCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 21:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbjBNCCw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 21:02:52 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E651ABE0;
        Mon, 13 Feb 2023 18:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676340164; x=1707876164;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vHXKAogXHbYqZyHo+PANKzhX3M/HdJnx7WXNPzWau/M=;
  b=UKz1lzow0V/7AKUocsu7J+kmSVOuQuXYSI83w343aoDZ6763t4TbH4qP
   CNm3Y6jqn0cxVHXtzBVqUSkebIP2dDsXL3w1w8l2aoi/7XRPznaC5B4s7
   JDpLiEOEONDg1bS8B3Vg7iDmUllbM1fN74l1LCWGGUddn7NUL+1fhSPoE
   bDfnGRZlLBLymBgfXN/DnjOx28p+lkW0U3DBLzlye9qXuSDWuMjmffTwJ
   D3O3g4B/rqIgySQ1BEn+ujoWxXNJfWv8RXSEOkZp2+ZFJsMwZEUSiY5UV
   g2DJdpbQFs2BxR+wjrw1gf3beTDh2s06uwR7dSThqQ16MzkPosFD4YKFS
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="331055658"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="331055658"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 18:02:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="618862448"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="618862448"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 13 Feb 2023 18:02:41 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 18:02:40 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 18:02:40 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 18:02:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7HBBm3J8v7SFWTOyyI52tV++ZSrjAAhepZVXI6NtK+kHAff+1+HL4Ty/jfkLXIhEE+8xqCezlM7whD4uFL5r6VNwh2ffifa0rcHura9ig2trGaYlLWD3wSWxgEMZNE/AM8Gc6+VnD1dYCiWozaKiYCOoAd6wSA2HxkTlZMQVvjuCgP5xA/YZuIKWMUe4oFvpFJAnFUkvKsxY61C38kUwKdKxC0OSqs6CRtHdPBuWKqldQsa2zqLRs2JSdPBsVp+c6JVGFcBQPDOunB3JyD/Q73AH7Lk+IaGw3pmP/WyIZkkNdRTF02DhtOuG5ssKdxpK3oBCJxjamBJTArbV3EzDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wr/PZn/1zKpcpN6DOjB11qBSihuNbMXI1GMLDp0/eZQ=;
 b=ktyW75tLz1NaT/bMDq9eNAcxekGXiwtH644heunrcd97/3zZ+X+fK8YQl6mCnFxpVhqKcARkVM7POB4/hD8aLPUqFA7QnOXcpY+CPKR2DJuNWcG3mHad56j4NXxfPg+uiqOsuv+Y9vWl1atTBFDF9BZYRIpOh+CUv6b1GZ0/cIpT5czFWQL+a6BuYas6hmCgeiETDMUI0ewqu54/0yAYipWm1RJPbezn8LoOAm7LhqVdkC9QIKOy3I9j75X61vBKTQ/BrII5KsUSzS8tqqFJH9DKPnQ/7a+UhepmBUaho+mN6/6649isplRtvIlfhlpoaHGRinrPqYCXjL7X3m2aQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SN7PR11MB7065.namprd11.prod.outlook.com (2603:10b6:806:298::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Tue, 14 Feb
 2023 02:02:38 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 02:02:38 +0000
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
Thread-Index: AQHZP73OQ1XOEaarRU+iobEkUB6WaK7NioEAgAAlR2A=
Date:   Tue, 14 Feb 2023 02:02:37 +0000
Message-ID: <DS0PR11MB7529B43C7D357D8A0C2438C7C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-4-yi.l.liu@intel.com> <Y+rLKvCMivND0izd@nvidia.com>
In-Reply-To: <Y+rLKvCMivND0izd@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SN7PR11MB7065:EE_
x-ms-office365-filtering-correlation-id: c7cdfd4e-7f85-4a33-74cd-08db0e2f8c21
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rX3t26B5/2n/1xLhYRKgulT9fW9sRIHeyyHWc1rHidFcaBgo/1t3U/Oy/0srP2YDQXwHqyqCV/ewXaju7DP38VhSI8JMXaB2II5VidBpwcvjnGtAkWSEDMiqJ9NCD9OVdwCRKxpQ4P11VApct1jLCuUsG0KKfHCcPOZ6FOdbgfOMuVOz8UNXkJyJyT1z2Mp1L2qfAkYdHNWNknEN3KCJuposBP4jyFYdmuGtwbxm9iQSVNa0JQ8gbfD4Di0xecIrSCNOaymTSYpquWUKEBTNG2QcaHIsnIlBpLY/E+1zS8HyZ9fc/wDWlIoXC5sXuL790OKo0A2LcFoJhE07RgLXI49rqpY3vQ/qnupIJk6C84bF3FW2vyVVBNKJuXSr25OwUAixF+m/6rqlua57a4WdwKyFm08rdTOesY3QSjmYOGw0EPui8cq7t+x7H8kTuB1yzfBxMQLh9hd6ZrOrKBY0AVpNve6rogNp4q3b6HIPGm4V/D13k5Sm5cPXkaHlhA/WTwSxqxEWpRM7AwH+ib59R6fNyEym5xftl8yOhDlgcD+eZlq/ocvtkDZCMUGpGTR/9+887X7/XaSS9qqDU4LznIwTBLOld+P8frBZ34vpmnLuqbW23sXWFywP8ZBdK4nMDlSxjcdA/VKDJrJInUFDJzwS9sbLOrGD8c5wS80/IsKh1I5uY4BXYFuRYfoaJHkbgg5ZVI7rc1l/VoD2ZfbYxxQluE0GSK22+ruAc2IrxKg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199018)(82960400001)(38100700002)(5660300002)(71200400001)(41300700001)(55016003)(38070700005)(122000001)(86362001)(33656002)(83380400001)(2906002)(186003)(7416002)(8936002)(9686003)(52536014)(26005)(6506007)(54906003)(316002)(66446008)(478600001)(66476007)(66556008)(8676002)(4326008)(7696005)(76116006)(64756008)(6916009)(66946007)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hRtnoUMOTS9TEB30XKXA1i0oVE+7t0uPxxw5hdJSNB3oyBDzuuHHpGqEAPLL?=
 =?us-ascii?Q?bkgaNaL+c4O6GBV3k3QGWx8ZVpI98sDwlwQcFvG/KJ/Nddk2xV7j1FQeeuWM?=
 =?us-ascii?Q?nK/PjXhmODuOTHydf2cdlCi+UIDVJ9ISUUltpLDDAaNHpKqP3Bq+jnzFb3cT?=
 =?us-ascii?Q?BZbVCQXrgOqqgtHEh3GuXfJD9YgdOJQRZi/qw9zcvLPfe9xqHtcaYBsLfc+D?=
 =?us-ascii?Q?o7XvNO11N6PdA44w0RTEjKiORgBKtbtaH9WUqb0xstKIgMb5XEnWAxEIpe+Q?=
 =?us-ascii?Q?UwCYpaL9PgpqLbD1Qmo6TXSJPsNqoUWfFecwDKKQAJ7TiEkPT/Rdz6w8+7wO?=
 =?us-ascii?Q?w5j7rcFrdHtFRXdymlbRTLm6u81TI+dQUct6yWhEooZUyLr8tBds7SHxehLT?=
 =?us-ascii?Q?Qpic8Dil/XNUK4aTz64dZ5X+B+WCI3JfN06wzkJUlcx1rIgo9/XFEtMLRSwH?=
 =?us-ascii?Q?tznRBzgVca4N/EpXjUq2xMWc94fEZIX+Xnxq3x9JpT8iQ8mE6A1LU/W0hcM9?=
 =?us-ascii?Q?hYLOwBbSmLdVP84YTVoypxxtjrliNTvDjI3x+VNCXDCj78uAD6I0d22r8GKJ?=
 =?us-ascii?Q?ht1HsnQxIdHl85YC7UTPyKmv5BInFANljUyFdoL0Z+OZDE9x8A3AGCWMIHNK?=
 =?us-ascii?Q?OizfuprprJr6bb/d17Xi8f1VC3MzvxJQiKx2CxlzdPVzs0fscGisrvc1Xdcf?=
 =?us-ascii?Q?croJcyC8BHd5e3ncXh053azE5o4f1CRDoCoHNy853Ck9kGur5yEa3gKMQWYR?=
 =?us-ascii?Q?CVYed8qDyXUhtmpGiSb2RhL5KCP1PYJ0Jq7Z36974XLO1uKMfb1f3ptmbvKd?=
 =?us-ascii?Q?3zm/5dBXIxl5qBL8op8djxDuNrvKmW9Y+wJW2rhMt1K5NiBBxiC/Te+Ix1DU?=
 =?us-ascii?Q?zFQu2at7SgyZjvWW8z5N3kRHegKoI7VwDkSjinyDjvWcyDXTRlx/Q+73R5Pk?=
 =?us-ascii?Q?36yVUEaUXeHYS5pPhTgkGMV44NLXzPwvBZu0P5TTx9zaThopGoTHbbprjNlR?=
 =?us-ascii?Q?EKUsaJyWMRlLW/RuM584ihyk4zU22NiH0hxIMtZZ1YWn7K21GgNhVmjAXdpg?=
 =?us-ascii?Q?ZzOZVJY5ofS+DpYlK4eJqZnBtdIQdv9Pf4b9gjFgqCt5MCnO0SXuSMRnrTJz?=
 =?us-ascii?Q?oz+Mi+y+pDN7Yqa8JV465FRzSsI+17mwsNNpdDb5AtVVxeKQwQaeQecfsP3b?=
 =?us-ascii?Q?8JnX/C3mbdHc0KOeQ+HhOHuxE80rycxtCS2O4qDc3EyYqz3Xt3CiGxZZx+j9?=
 =?us-ascii?Q?yZoGEPndpEAV6S7nQWe5GJIaF9IfUGTAG/FhXfuJxVSal50mP0rRO2LOMJB/?=
 =?us-ascii?Q?eU+GL3iYNaWsMSRGJw4Xt9MP6RLa0uzJPs9W+A25FNjACrxy2FhreWh9IPNx?=
 =?us-ascii?Q?uz+Ax7ttFr8mjOK0pwYu/hueHQ8Q7QVhdUmQck8Bbg3iUtwZxd/1kVaR294A?=
 =?us-ascii?Q?wgQUTFHaZVhiZp6OYqWu+kqimP9HbfG4tcWwCqt8oTY9dfGiQ38NMHXY/80t?=
 =?us-ascii?Q?fozlJJwPsjrYpHbU29OtCyVwAk8vTOiAklnRc4hc/navHGh+b/2UFkzqQCkL?=
 =?us-ascii?Q?cpjpF0vE7lrVm1HiViy9ImoIOw7SvAnV7iUPRNDG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7cdfd4e-7f85-4a33-74cd-08db0e2f8c21
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 02:02:37.9999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KSBroKTA8nBulxmUxFF3maXq8y7uYciYD3rl980C8wXtR0fdbBqRbhlmIGbtfss/6+hOv6wVv7XRNgzuOgasiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7065
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
> Sent: Tuesday, February 14, 2023 7:44 AM
>=20
> On Mon, Feb 13, 2023 at 07:13:36AM -0800, Yi Liu wrote:
> > +static struct vfio_device *vfio_device_from_file(struct file *file)
> > +{
> > +	struct vfio_device_file *df =3D file->private_data;
> > +
> > +	if (file->f_op !=3D &vfio_device_fops)
> > +		return NULL;
> > +	return df->device;
> > +}
> > +
> >  /**
> >   * vfio_file_is_valid - True if the file is usable with VFIO APIS
> >   * @file: VFIO group file or VFIO device file
> >   */
> >  bool vfio_file_is_valid(struct file *file)
> >  {
> > -	return vfio_group_from_file(file);
> > +	return vfio_group_from_file(file) ||
> > +	       vfio_device_from_file(file);
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_file_is_valid);
>=20
> This can only succeed on a device cdev that has been fully opened.

Actually, we cannot. This is used in the kvm-vfio code to see if the
user-provided fd is vfio fds in the SET_KVM path. And we don't
have the device cdev fully opened until BIND_IOMMUFD. But we do
need to invoke SET_KVM before issuing BIND_IOMMUFD as the device
open needs kvm pointer. So if we cannot apply fully opened limit to this
interface. Maybe an updated function comment is needed.

" vfio_file_is_valid - True if the file is vfio files (group or device)"

Regards,
Yi Liu
