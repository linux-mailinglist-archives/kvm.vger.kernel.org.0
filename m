Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7076D053D
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 14:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjC3Ms1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 08:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbjC3MsX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 08:48:23 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1337D55B7;
        Thu, 30 Mar 2023 05:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680180488; x=1711716488;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G93lNDew61ZQcH6tKnLIktOuNeb35yNTPWhtJSujqRw=;
  b=FQy89pKk5GG9PJE30F9CQCYm3u3j+V0cg+MCKl2+Txtf4jaZPKhkFica
   /rj4VTDGU2dxVuoOeIAk2+MPmzONV8szoK6ztt3zwZe0fjArukJj667b5
   dlWxIUBY4NXlSOGljMzcpnSpydHDaCq9UcrYP9zogXjdum3lv2w7oIa5/
   7WY8xt3f2KQk1+bkM6OiIwJNBDyFfcNJRGEN/VhsuErAilCzryR7ttCN+
   7f3XGOyRTVrTCvo6uBswZPrleU5VPa8gGt8r6E74WbnkUrRbVnxnVdfqn
   l9Tz75LtG3rtSE9VnKumgyD0Wi4ym7vI+iywkVnM2NkwXFFNUx/k1CvGy
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="338655969"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="338655969"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 05:48:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="930718677"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="930718677"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 30 Mar 2023 05:48:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 05:48:06 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 05:48:06 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 05:48:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NxeOWxlgCxeWllE+BftZtuxR53FWflt2Fv3ru5W0M6ufOsVUrjA+QIRWaCByye6TaJpJBuA78CL33+vgEfDxrP8cd0TsW11pDbf4NEsQ1sJjlcjO7KL1BH+WrE0//sukuTLUAY29xUu9h85M8KBgB9XV057w02b+k9aH7KCOIKS1+O3uq9k76PvUTdznhzt/e3Y/do09ov8lmk4hS23Pg8guFG7F9PVV13Tvtc0EPVdLOmi53L95KDSmUHKvjxr8IJ2I2gbIyM3fDh3cCWQnbqavS9lRbIaN3KRFvYslDgBed49EaRl7zKu33TZtSN0exi25Evpx8QkNyDjUsmjhaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6cffpSIOtRm6Alv95ECXBpD52SXYlwIt+6MXTKmKPmg=;
 b=WbMnZMsensNDtyPnEoKAq+hANyJbcx3QahLBhMzjZEsyrvPkgI28/EmMNmrTNv011AYC0HzFr9Y1I4E2LSFa8Qv2r2FqI9lQsqURLqMZvVQS2+EI4VUFi9GYH82lqfQQtfFk9oQ7mBBBp59PnHWnaUWgLEkMucqQwVJdSkczDkXpHhbtqxRiGId+RoBFSdeNBMlheZsJEL47u4Ybk7nYujx6mPo6Nxz/xpSDtFS0IFR9htY/IbqJfhrxJW46WkjZhqKOmQ7lwi7Q/VYLBUSDlBXKXBSfpbCJpf2MYxhS+MpQVNNwX5DZaJVwRTW2UTg69Nm07ITGxL8Fd8xV4hsSbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY5PR11MB6161.namprd11.prod.outlook.com (2603:10b6:930:2a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 12:48:04 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%4]) with mapi id 15.20.6254.020; Thu, 30 Mar 2023
 12:48:04 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Topic: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Index: AQHZYI92Dc+A7iEOnEaMeK3O2ipWfK8PAuSAgACBxlCAADScAIAAh+4AgAABaZCAAARdAIAAAahggAAHN4CAAAKPcIAACUyAgAC3rPCAAHDDAIAAZucAgAFd2IA=
Date:   Thu, 30 Mar 2023 12:48:03 +0000
Message-ID: <DS0PR11MB75298AF9A9ACAEBDD5D445ECC38E9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
        <20230327093458.44939-11-yi.l.liu@intel.com>
        <20230327132619.5ab15440.alex.williamson@redhat.com>
        <DS0PR11MB7529E969C27995D535A24EC0C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BL1PR11MB52717FB9E6D5C10BF4B7DA0A8C889@BL1PR11MB5271.namprd11.prod.outlook.com>
        <20230328082536.5400da67.alex.williamson@redhat.com>
        <DS0PR11MB7529B6782565BE8489D922F9C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328084616.3361a293.alex.williamson@redhat.com>
        <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328091801.13de042a.alex.williamson@redhat.com>
        <DS0PR11MB752903CE3D5906FE21146364C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328100027.3b843b91.alex.williamson@redhat.com>
        <DS0PR11MB7529C12E086DAB619FF9AFF0C3899@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BN9PR11MB52762E789B9C1D8021F54ECC8C899@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230329094944.50abde4e.alex.williamson@redhat.com>
In-Reply-To: <20230329094944.50abde4e.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CY5PR11MB6161:EE_
x-ms-office365-filtering-correlation-id: 59801f66-a69b-444e-93c3-08db311d007b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6eqoeCq2LNLyyF1UYfB1RAzBuBtSKefIMNlo1wQ65VuxXRZ++w1OSw3TKlbKXmsAInlcMHWeDgf8J24f/8aBHnIecr/GlYwyoEdUVyKIWCGjTO83BX+gQb8ntpK3xeGVeKAPqKItBfgx/dJpjkTsjXC6ayW+0rKp9mIM18O2BL8lvyj5Ql99DIlYJWiTBpIVQAuB7T3qnH9oX28jjZhlsxWFlal72l89Z6hrPqQD59gS+etSGgOvakj1P5TuxM8FRwwM3k2NnevIJzAq0jWurV7ZYUyN1+JzG8CrCHhrmVfbsWCKjXEF7MOVb5a7i/WecKGRCfyrnvCg5ShtTxQJXHfHcmCYBwnr3fPyXKq/m+y/6XmGxRNPU6FQj55ti5+HB5KaIGnwRzchkzjWHVihMUhNEaXgw47rjfhhst6I56Tljcd25yjjlYX+6/iM8mKV7mmkjpxgnVzf0f2A8Gr4iPRvhL5koskrVYx3KQTyg+shQpfymV+qGRYDcK/tNo1B6mCdP2UFCo+i6d1S94yEyK5T/lVYR+tlU8fbhHblW5YEYgQIKq3zvzjWbAg/nPa+QxdxfkdHqEqMAbY1+FhOu/sIiKYFXDdQdr/g3owpCKWUr/byszpA0JevDfzAPddP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199021)(2906002)(38100700002)(4326008)(41300700001)(8936002)(122000001)(5660300002)(7416002)(52536014)(33656002)(86362001)(55016003)(38070700005)(82960400001)(478600001)(316002)(71200400001)(6636002)(110136005)(54906003)(7696005)(26005)(53546011)(6506007)(66476007)(66446008)(83380400001)(8676002)(66946007)(64756008)(66556008)(186003)(76116006)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bYqH2LIIHUwnnJCBDHt9/jNnMUZSoOsokIszPuE7SAXnRgIcev9IwrtlUaXn?=
 =?us-ascii?Q?0mnAzmv6Jbi/DyWs0WXBtN2IGRVL4qEoA69tyb3jVseV5VegiNgetFE2IoKD?=
 =?us-ascii?Q?n5P1lsyH2sWd6CEowpDi/ykwWwVdJDNNQ+m/vHWUD4tppiGOEUHZgEzVIbVF?=
 =?us-ascii?Q?xrhKGjCaIuV5TNxf5B1XC4xUMVxew467LMe9eXTTdK/Vcfl1LBtDQePZLeu5?=
 =?us-ascii?Q?fOXsbv7cKaqhlHm9/AOGFjJH+bhJVJUadC7jn9cgqGI12beotJDC2SPmSxQG?=
 =?us-ascii?Q?28Wx/4MFYLtvYdSFyDWEHtFaWlgZjJl1HiCLh2DiPnJgA37sCN3ZuWfT1iL+?=
 =?us-ascii?Q?VaXG2B/ZV2wA0TnzLLymPWeZDqMyxGEPqp8MoF1k+Y4HHSnna5nkUOahYKnC?=
 =?us-ascii?Q?ynUvmUs0GQJ4sOc4iMvkF8JRYEJAadYGGIf5vzR95IIRpoFm7mJyzPvKoMN1?=
 =?us-ascii?Q?lVFTpwRQ/5OWhh+BfSAV8tdXrAFxz/1Q8wMFpKTabxcbBMrVT/N5L5JjdGqb?=
 =?us-ascii?Q?PjBSFgJYgghdB6Ul8Dp6DnG+QjBH8IVJnuJYlpdKCR8weMc+3zkRLaLgZStb?=
 =?us-ascii?Q?UANxEb9RFZqllu8XYqP/ljyFK73xa8fMkEb1GtBqDKvFN6GEYKkooONuH4y2?=
 =?us-ascii?Q?TGwnPit9aCJNY2jO3EepcIO4AS40/hiroR8imlRiW4b1cYOw9P4H5sDgFqij?=
 =?us-ascii?Q?ubuPQU4x/iPc03ox9+JEqlscqyCNrNSlQ1GcoSgmeTp11gUvF93chIuszbWF?=
 =?us-ascii?Q?+1NZlEq1YBogxf3s31a7hcTV5y0DWhCy/0RVNrkT0+H4bZSeqXTWngsRwPBS?=
 =?us-ascii?Q?YySrijhI5NkAagRnlz1qSv1WCgeiA9IOI3v5g1soozrgOXBqNeozFMChFUhH?=
 =?us-ascii?Q?IY+NUrt4giYldTKRd1JDk1/ihAPth/ZNzANcz3VwIu+YSI2jCQp5MDI/KpUN?=
 =?us-ascii?Q?d4MJfallpbL5TtAm1HYBoIglyvV2nqmrcvm5KqAVy+VQUE34bB5ym8QWsTH5?=
 =?us-ascii?Q?8NendMdD7PfNk1vn2btCnmYLiN28EzHwPGTXSvN1KHvcSdUNLtzJSRIVPT3a?=
 =?us-ascii?Q?nxiIZCpcf0dzGFbmscwUVnpjIzybxtZdKRxyoGncQzD0Nj/uK/0zkWb5w4m7?=
 =?us-ascii?Q?o57VGslKp0QZv+yX3nt3DcptTnSUEltGyPu29/MgsB/+p/K/yMX1Qpp2FIsO?=
 =?us-ascii?Q?2VYYXCOn1wx1OQM0j1IBN5+oTMW5zaC9ombC6imoUIZ7GDsrYzz2G0hGq8eh?=
 =?us-ascii?Q?+bdiycuj5q0B7YigCQhnjxzxQSi4FLxzrFoHn3V24jojKmsMUFVBVFc2fALP?=
 =?us-ascii?Q?NshD5XzeAr9ZyC0qsSp3xf1r2IKOL+U1AXOmhjdw08Al6jidI0jyaZ51f33k?=
 =?us-ascii?Q?O/TD/yt2FfVgSOsfEqBZhEaC98T3wxxf9hw5H75xq046jV1CLnFdyoCQkJQ/?=
 =?us-ascii?Q?M43HhR9SZUKdTs2hXKl/xX/xmlC8HLsk+2ZL2jnX3QtKgI5ADopZpL4FlpKF?=
 =?us-ascii?Q?skkXCpT7yi1whgoN3JXqVTSsq0o+J9/hwuIDgdiwuYw+1nTKC/DTfHzHwR+f?=
 =?us-ascii?Q?rIfrHovQGrgnPo5V8368mEmh2X0lz2abjRExhfbK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59801f66-a69b-444e-93c3-08db311d007b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 12:48:03.4677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WIu8o6VQjFDo5uxJ1uLgbE4U5l5+wJ4zyuJzvDXIXHonpBBI/AJxCy6CvzWJT//NyLxwWOqNUYmOKA5xwjaA3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6161
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
> Sent: Wednesday, March 29, 2023 11:50 PM
>=20
> On Wed, 29 Mar 2023 09:41:26 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Wednesday, March 29, 2023 11:14 AM
> > >
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Wednesday, March 29, 2023 12:00 AM
> > > >
> > > >
> > > > Personally I don't like the suggestion to fail with -EPERM if the u=
ser
> > > > doesn't own all the affected devices.  This isn't a "probe if I can=
 do
> > > > a reset" ioctl, it's a "provide information about the devices affec=
ted
> > > > by a reset to know how to call the hot-reset ioctl".  We're returni=
ng
> > > > the bdf to the cdev version of this ioctl for exactly this debuggin=
g
> > > > purpose when the devices are not owned, that becomes useless if we =
give
> > > > up an return -EPERM if ownership doesn't align.
> > >
> > > Jason's suggestion makes sense for returning the case of returning de=
v_id
> > > as dev_id is local to iommufd. If there are devices in the same dev_s=
et are
> > > opened by multiple users, multiple iommufd would be used. Then the
> > > dev_id would have overlap. e.g. a dev_set has three devices. Device A=
 and
> > > B are opened by the current user as cdev, dev_id #1 and #2 are genera=
ted.
> > > While device C opened by another user as cdev, dev_id #n is generated=
 for
> > > it. If dev_id #n happens to be #1, then user gets two info entries th=
at have
> > > the same dev_id.
> > >
> >
> > In Alex's proposal you'll set a invalid dev_id for device C so the user=
 can
> > still get the info for diagnostic purpose instead of seeing an -EPERM e=
rror.
>=20
> Yes, we shouldn't be reporting dev_ids outside of the user's iommufd
> context.

Following Alex's suggestion, here are two commits to extend existing _INFO
to report dev_id.

From ad5c81366813c5effd707a0b5f5e797f5fdb3115 Mon Sep 17 00:00:00 2001
From: Yi Liu <yi.l.liu@intel.com>
Date: Thu, 30 Mar 2023 05:29:36 -0700
Subject: [PATCH] vfio: Mark cdev usage in vfio_device

There are users that needs to check if vfio_device is opened as cdev.
e.g. vfio-pci.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/device_cdev.c |  2 ++
 include/linux/vfio.h       | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index b5de997bff6d..56f3bbe34680 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -66,6 +66,7 @@ void vfio_device_cdev_close(struct vfio_device_file *df)
 		return;
=20
 	mutex_lock(&device->dev_set->lock);
+	device->cdev_opened =3D false;
 	vfio_device_close(df);
 	vfio_device_put_kvm(device);
 	if (df->iommufd)
@@ -180,6 +181,7 @@ long vfio_device_ioctl_bind_iommufd(struct vfio_device_=
file *df,
 	 * read/write/mmap
 	 */
 	smp_store_release(&df->access_granted, true);
+	device->cdev_opened =3D true;
 	mutex_unlock(&device->dev_set->lock);
=20
 	return 0;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 1367605d617c..86efc1640940 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -58,6 +58,7 @@ struct vfio_device {
 	struct device device;	/* device.kref covers object life circle */
 #if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
 	struct cdev cdev;
+	bool cdev_opened;
 #endif
 	refcount_t refcount;	/* user count on registered device*/
 	unsigned int open_count;
@@ -167,6 +168,19 @@ static inline int vfio_iommufd_physical_devid(struct v=
fio_device *vdev, u32 *id)
 	((void (*)(struct vfio_device *vdev)) NULL)
 #endif
=20
+#if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
+static inline bool vfio_device_cdev_opened(struct vfio_device *device)
+{
+	lockdep_assert_held(&device->dev_set->lock);
+	return device->cdev_opened;
+}
+#else
+static inline bool vfio_device_cdev_opened(struct vfio_device *device)
+{
+	return false;
+}
+#endif
+
 /**
  * @migration_set_state: Optional callback to change the migration state f=
or
  *         devices that support migration. It's mandatory for
--=20
2.34.1


From f796cafd6c51e49adcf76352dc1daf14712c3a48 Mon Sep 17 00:00:00 2001
From: Yi Liu <yi.l.liu@intel.com>
Date: Thu, 30 Mar 2023 05:44:45 -0700
Subject: [PATCH] vfio/pci: Report dev_id in VFIO_DEVICE_GET_PCI_HOT_RESET_I=
NFO

for the devices opened as cdev.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 59 ++++++++++++++++++++++++++++----
 include/uapi/linux/vfio.h        |  6 +++-
 2 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_c=
ore.c
index 19f5b075d70a..49e0981037f7 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -767,6 +767,20 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core=
_device *vdev, int irq_typ
 	return 0;
 }
=20
+static struct vfio_device *
+vfio_pci_find_device_in_devset(struct vfio_device_set *dev_set,
+			       struct pci_dev *pdev)
+{
+	struct vfio_device *cur;
+
+	lockdep_assert_held(&dev_set->lock);
+
+	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
+		if (cur->dev =3D=3D &pdev->dev)
+			return cur;
+	return NULL;
+}
+
 static int vfio_pci_count_devs(struct pci_dev *pdev, void *data)
 {
 	(*(int *)data)++;
@@ -776,13 +790,20 @@ static int vfio_pci_count_devs(struct pci_dev *pdev, =
void *data)
 struct vfio_pci_fill_info {
 	int max;
 	int cur;
+	bool require_devid;
+	struct iommufd_ctx *iommufd;
+	struct vfio_device_set *dev_set;
 	struct vfio_pci_dependent_device *devices;
 };
=20
 static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 {
 	struct vfio_pci_fill_info *fill =3D data;
+	struct vfio_device_set *dev_set =3D fill->dev_set;
 	struct iommu_group *iommu_group;
+	struct vfio_device *vdev;
+
+	lockdep_assert_held(&dev_set->lock);
=20
 	if (fill->cur =3D=3D fill->max)
 		return -EAGAIN; /* Something changed, try again */
@@ -791,7 +812,24 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, vo=
id *data)
 	if (!iommu_group)
 		return -EPERM; /* Cannot reset non-isolated devices */
=20
-	fill->devices[fill->cur].group_id =3D iommu_group_id(iommu_group);
+	/*
+	 * If dev_id is needed, fill in the dev_id field, otherwise
+	 * fill in group_id.
+	 */
+	if (fill->require_devid) {
+		/*
+		 * Report the devices that are opened as cdev and have
+		 * the same iommufd with the fill->iommufd.  Otherwise,
+		 * just fill in an IOMMUFD_INVALID_ID.
+		 */
+		vdev =3D vfio_pci_find_device_in_devset(dev_set, pdev);
+		if (vdev && !vfio_device_cdev_opened(vdev) &&
+		    fill->iommufd =3D=3D vfio_iommufd_physical_ictx(vdev))
+			vfio_iommufd_physical_devid(vdev, &fill->devices[fill->cur].dev_id);
+		fill->devices[fill->cur].dev_id =3D IOMMUFD_INVALID_ID;
+	} else {
+		fill->devices[fill->cur].group_id =3D iommu_group_id(iommu_group);
+	}
 	fill->devices[fill->cur].segment =3D pci_domain_nr(pdev->bus);
 	fill->devices[fill->cur].bus =3D pdev->bus->number;
 	fill->devices[fill->cur].devfn =3D pdev->devfn;
@@ -1230,17 +1269,25 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 		return -ENOMEM;
=20
 	fill.devices =3D devices;
+	fill.dev_set =3D vdev->vdev.dev_set;
=20
+	mutex_lock(&vdev->vdev.dev_set->lock);
+	if (vfio_device_cdev_opened(&vdev->vdev))
+		fill.require_devid =3D true;
 	ret =3D vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_fill_devs,
 					    &fill, slot);
+	mutex_unlock(&vdev->vdev.dev_set->lock);
=20
 	/*
 	 * If a device was removed between counting and filling, we may come up
 	 * short of fill.max.  If a device was added, we'll have a return of
 	 * -EAGAIN above.
 	 */
-	if (!ret)
+	if (!ret) {
 		hdr.count =3D fill.cur;
+		if (fill.require_devid)
+			hdr.flags =3D VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID;
+	}
=20
 reset_info_exit:
 	if (copy_to_user(arg, &hdr, minsz))
@@ -2346,12 +2393,10 @@ static bool vfio_dev_in_files(struct vfio_pci_core_=
device *vdev,
 static int vfio_pci_is_device_in_set(struct pci_dev *pdev, void *data)
 {
 	struct vfio_device_set *dev_set =3D data;
-	struct vfio_device *cur;
=20
-	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
-		if (cur->dev =3D=3D &pdev->dev)
-			return 0;
-	return -EBUSY;
+	lockdep_assert_held(&dev_set->lock);
+
+	return vfio_pci_find_device_in_devset(dev_set, pdev) ? 0 : -EBUSY;
 }
=20
 /*
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 53c72e26ecd3..3fcbc84d51ba 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -743,7 +743,10 @@ enum {
  *	-enospc =3D insufficient buffer, -enodev =3D unsupported for device.
  */
 struct vfio_pci_dependent_device {
-	__u32	group_id;
+	union {
+		__u32   group_id;
+		__u32	dev_id;
+	};
 	__u16	segment;
 	__u8	bus;
 	__u8	devfn; /* Use PCI_SLOT/PCI_FUNC */
@@ -752,6 +755,7 @@ struct vfio_pci_dependent_device {
 struct vfio_pci_hot_reset_info {
 	__u32	argsz;
 	__u32	flags;
+#define VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID	(1 << 0)
 	__u32	count;
 	struct vfio_pci_dependent_device	devices[];
 };
--=20
2.34.1

Regards,
Yi Liu
