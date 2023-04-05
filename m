Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BDA6D7887
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 11:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237241AbjDEJiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 05:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236449AbjDEJiV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 05:38:21 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B9F1B4;
        Wed,  5 Apr 2023 02:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680687477; x=1712223477;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SFDNxK7EdxnqlFy6gMPWTNDN0n2NLFMsVk3l+BD5M1o=;
  b=J3dWuJ2USVm+FAJhnqtyG4mpui8uzUcwx1cyUTVGVlfL7WGFEOjyCnxs
   KjP/5ez1v5YAcBUO6USLCqdJFs+pTdLLLMlroQEwxEifh05r376mUgldC
   HbOVf+v1UEw1nVcWw6q2uVEGMLImfygEAqKYQO/El3XT64CRtNERL36SC
   bq64icR/MnpNxtYFfVwOkxfAb/oH9mhU9MCyul032wY6KV+J6Tlx+Y+Ul
   kzi8fkDOREyeIKu+e3mhu40cVMWHZfg8sPtdgHPnO66xPT0LZaV7/PBTw
   dhLrCBRbd8NSX7Ix3ddHKPd7FQNrZyG7KccLJsJwnEeEeWqRR1oU/65LE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="405183534"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="405183534"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 02:31:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="1016411782"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="1016411782"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 05 Apr 2023 02:31:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 02:31:41 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 02:31:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 02:31:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AeFj7EO4fOv12T8smPZw4i8vvpALs6pXKVWboI+m3MR2zoBznPJsHrJ47QqDKVRmIwhep+XvK1iQdlSV5ogGP8XLvAWd5KoEs7R1KR2h3amSfoH/3NOMUn9ZRI+tQElriin1WD3UhhiyjDrXgpjw3ik/jtnZfXUwvtsAQZHlRB37cYWGFT1kF5Mz3iVSTs5K5YpYAETGzTZeyQM9CyEveMWSsLWPyVhy8M/kVHRlQ6umCafaY1615AQXZnVoH2n2xRlZevE3jVcLW5O9+zvM6vuK1M7SU+oPLbhJQVu6WqXlJfsfsxiSb++kKjLTlcP2M8T3JijORzL+v8GNeUvUBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vDb4mugiQIHIHQ0l+swTc3Fgu4ckf5ouPT5gxx9KNEY=;
 b=WGWA2dNuDF79bfst+SWmVcSCR3TZBpAFHAW251GQBIvxgu3bqnkFV9yvHYX6+jI/jS9gZ6EUAPo5n1bn8kKvwx1KoAL9gECKv4yaR3HGchvOI/ymQPJ0cfu9gygllgtyAtFSpwV/LeQpbtUkA2p4DSBI0Hzd+zPeM+Luf5SL9Rr2JSlhwH4YCEtJstddlaZCj0BAOKWDqQyMUZt1OfxIjrdBSZO/TQY9+dY69pwWLF/qZO3k4aP1g9/fwpalfU7z88hwogQRU/fEaQOHPG3H/DuxewcOxKn7zd+bClldsshfTX7QHghYI0y1MtQ1avATrWUZexdw2Zl1dvKqRZGEqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB6913.namprd11.prod.outlook.com (2603:10b6:930:5b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.23; Wed, 5 Apr
 2023 09:31:40 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 09:31:40 +0000
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
Subject: RE: [PATCH v3 11/12] iommufd: Define IOMMUFD_INVALID_ID in uapi
Thread-Topic: [PATCH v3 11/12] iommufd: Define IOMMUFD_INVALID_ID in uapi
Thread-Index: AQHZZKiCScQNamljh0Wf7fmaPGy2SK8bp64AgADRndA=
Date:   Wed, 5 Apr 2023 09:31:39 +0000
Message-ID: <DS0PR11MB752985764A642C7B12436C53C3909@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-12-yi.l.liu@intel.com>
 <20230404150034.312fbcac.alex.williamson@redhat.com>
In-Reply-To: <20230404150034.312fbcac.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CY8PR11MB6913:EE_
x-ms-office365-filtering-correlation-id: aa05e99e-6271-49fd-b44b-08db35b88f70
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sg86iz2RfTmtUOnk7RNYxk55CED2j9MpespYjFKdSCTFg2EZVOdK53eduHFoQHstjoQ7VhSNsO2gHWtyzNXS/gnGwlV2dEFkQiW4kXEObz2ztVfC3wsBA+WY9382L0eog/8ZsZRPpfzol11vJWIY/zzpQSz+1QL+Y+yZDxcL8nb64oEEWldra7FZNpeuPtc+7xoZrBbxZEUu7lNKdJ9WJB2ihpiZTV8NOLc0KuhpKYUhZZCb74B1ab9+JVqD1oj6XrGEJ/x8U2Pgd476Dke5MqIqzS6jjESpCA53N+hK9blSITkEO0YpZkX4j+/yq5OS7XvlqBB3pr5crVw1Ut9Z4sEaWpecP4N85kDbo+kk1tDFpnOrbPGB2PVDTbRiCHJpFL0IhLgzj/ibFgX8bFy7oEsFZBa1xA48E1uXJSNDUmxEz2qFjeGFwDjRy24aHVtP0ImWW3gwikgTL9RKsXDUrGKTw8+XczbwkpBiXBwZPcIe5q9xqxb9XWoECYgYZr/CoqeoEpfE4YmPDGPvoVuybNuJsZA9/nQ/kS4+VOJIKy+EFu719n5kO8mmp+ygt49VYmfYifr+HKoVXyZXpX/OarzmQipQSYXqftQ2v4fMu6Gnj5Cn9/PUlWF2CTDn6oN/hBFeWQNiH1izyKpDKV5VFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(366004)(376002)(39860400002)(346002)(451199021)(316002)(38100700002)(82960400001)(9686003)(6506007)(71200400001)(41300700001)(38070700005)(55016003)(26005)(186003)(122000001)(5660300002)(8936002)(7416002)(33656002)(64756008)(2906002)(4326008)(7696005)(478600001)(8676002)(52536014)(76116006)(6916009)(54906003)(66476007)(66556008)(86362001)(66446008)(66946007)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+BmFiAq3M3/0PB+QM2VJqAJqLwRI6D3FPPsTjHHbXNpPaNPdwVprjH3o54Ol?=
 =?us-ascii?Q?2I8Pp2iipmxrajBTZUFsOqY+6eljMJwrCiyFtXIYAG7bzSM9SCl32Yoj7LBZ?=
 =?us-ascii?Q?0lKQwbJvTlorcVc32bVwlPXfb2A83FvN+hZ2/9zmamlCMt0YbQgnAdsNHeJk?=
 =?us-ascii?Q?kxIoVAlUExiUsIRTLm07ZbK1pREPVcPgUhjYGhbYPpzUk+TbovI5wjSYyipb?=
 =?us-ascii?Q?IOWH5DM1GJYzhtwsWUdSTEOhzV5v7dxFqnobbmzg4/cPWW8J9aAf2UYrGDgy?=
 =?us-ascii?Q?0jk1zAZT1T9N2GYcRzjC6x29U/cWpp+0tgSbgSpiMMsq68+oAzl5x4RN7Lh3?=
 =?us-ascii?Q?JGpKbTUnrltzvedHrFaBI6gK2d4HQ0rkrPBofPlTv14/9Tl/DI5ujFA1TOAa?=
 =?us-ascii?Q?/Y3+t8LZjhLBUWUeUKRw1CfUDoX7hHj4z1as29oMN5CX49ILYmdZfjrOPvHV?=
 =?us-ascii?Q?HlHt70NkPHiyr7biOKJ65Ks4f1UjFpuNxA5rxRtLW1FKYeJfYrPOZ9cQNT6f?=
 =?us-ascii?Q?tCcO98PKGvxr2bnNizkKRaBvuVIucoPYI7le0TbXzs8fJKtYjvSJw73AJEDX?=
 =?us-ascii?Q?ov/OcCd3eDkbXEYCd/UVa0QaR3udQvERN4aKJmgEnuoesTECaVGjzpVCftAI?=
 =?us-ascii?Q?ICBxTbrwO2s8dsrRxQioYqoG1cheyRVwWyQnloc1THfOBHIeMq0QgX7riTEm?=
 =?us-ascii?Q?wyBA6b0+a7MlK3tK/JOmPjf87Aqvs0AjATcdEAH11pICI0blzDIYVrAafqXK?=
 =?us-ascii?Q?gdHbrbQwEzmS55vHynO4C9rUqRrNcYLsxhYnkufn3CheZYTAXQQqo/O/RE2A?=
 =?us-ascii?Q?cpl1zmdwvMhuRA3Y3DCPR+Hhu/hpJX4f1LxVloxXB37Ci3VztcOXch5IShw2?=
 =?us-ascii?Q?IvECwTcmGvEwtoOwJKaObHGE81Et8Kk19NZTB/LD1OJNSYPzhmBcMjiXCD2l?=
 =?us-ascii?Q?Tm5pJb/9Q9pg4Fe4nW8z6XoxiqQ+Kr34hEfi5RzNzJ7HN9mUN+Ds2ULUoM7V?=
 =?us-ascii?Q?hQqa2miLKTje/KG76LTtnnu0y3oStv5/h0JQLRcm6RjIiyeEgcOtyWt28gIu?=
 =?us-ascii?Q?exwDWtBnlsCF8yZLRffRlf9xlt/ZMzEPBp8xxzTcGN/SNFP0RNeprCqzHCEH?=
 =?us-ascii?Q?VNzvE/tm1dX/TrtZAKWzmqRVeD+iZ0azLv4RmFLv7ibAI3dGQ+E10iXEZL90?=
 =?us-ascii?Q?guHNx0JD8RmXcxUQksHgnkHhbM2K/yJJrWgW16NH6/hFghfl1Uda0674qkV4?=
 =?us-ascii?Q?SyYxVcR+nIkLd8B4mKQDzNgFn3qO1W4MV/AbNS5thWPB+5W6xVMPAdPLAXTI?=
 =?us-ascii?Q?nXXwfO4JyRkmr+bVJ4eBbgRBPyjTljJQc5FfHeZFK31B+vj7eutAjyEfi2po?=
 =?us-ascii?Q?0qcJ1NbyrHWMVxXfeT2H8aP+WtLVd/YXqCmHHuViWRJ14PT5iMdKJ0fMR8cY?=
 =?us-ascii?Q?5a8pJHzY8COC5ZlcgVMkOemlPxjp3g1w62cjQSzyHV9z/Qh/NSneK9QKVXSX?=
 =?us-ascii?Q?guGAlaOfuZGYmG01REXvPxPS5Rj1FqRLN5E22PZt0LLmGi565YjxY1Bd/DAg?=
 =?us-ascii?Q?BO17SRRN5vWlOjeIGqiNU0phtGWnu0M6qOkdQLdq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa05e99e-6271-49fd-b44b-08db35b88f70
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 09:31:39.9234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oPSoD4bw0klbVmIytdcdRdmQYU+sqvPbyW273ZdIOEHU0Vo4kMiyanW5JYBF8zf06SXJFpjo9hDvh0uPAyL5jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6913
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
> Sent: Wednesday, April 5, 2023 5:01 AM
>=20
> On Sat,  1 Apr 2023 07:44:28 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > as there are IOMMUFD users that want to know check if an ID generated
> > by IOMMUFD is valid or not. e.g. vfio-pci optionaly returns invalid
> > dev_id to user in the VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl. User
> > needs to check if the ID is valid or not.
> >
> > IOMMUFD_INVALID_ID is defined as 0 since the IDs generated by IOMMUFD
> > starts from 0.
> >
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  include/uapi/linux/iommufd.h | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.=
h
> > index 98ebba80cfa1..aeae73a93833 100644
> > --- a/include/uapi/linux/iommufd.h
> > +++ b/include/uapi/linux/iommufd.h
> > @@ -9,6 +9,9 @@
> >
> >  #define IOMMUFD_TYPE (';')
> >
> > +/* IDs allocated by IOMMUFD starts from 0 */
> > +#define IOMMUFD_INVALID_ID 0
> > +
> >  /**
> >   * DOC: General ioctl format
> >   *
>=20
> If allocation "starts from 0" then 0 is a valid id, no?  Does allocation
> start from 1, ie. skip 0?  Thanks,

yes, it starts from 1, that's why we can use 0 as invalid id.

Regards,
Yi Liu
