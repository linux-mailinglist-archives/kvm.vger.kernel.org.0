Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2356C44BA
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 09:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjCVISF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 04:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjCVISD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 04:18:03 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE944EDC;
        Wed, 22 Mar 2023 01:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679473082; x=1711009082;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k6ZPTtngDQKfa3VAaKX/8EZ5a+QoemKeXIoSkPb5Zcg=;
  b=Y1VKQi1i+uDj5JSQqpp07htfJqqJV+cIEPRTSEotX/lGmouwCdxW5NpY
   Cn3FqS0eFOHJg6AQeiXMFovy30oKtf00HgbRYiqgrDNWJcOGf5GNf8VJ0
   FhufNOWkhaMZPIv8TA23MHMwJ0Iar5l4aQViQRuKi3Aj+kQQKyR2Usv6G
   SQMCorpD5DxGd4HvNQj0aEjOj/dYQKtTmJlMFsPmmIqcIwsVpoMBqslQ8
   8Ey1pQwtsgs302/AgC8SuQiJd/DnQR+WGrNwwgwY2548I7ufrqdXKI8jm
   vIg45NDo+xHVBkItrgMhtBz+hXo93/mDEFkb1/cmhJT7R2VP3Fpw4zDk4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="319544684"
X-IronPort-AV: E=Sophos;i="5.98,281,1673942400"; 
   d="scan'208";a="319544684"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 01:17:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="684217023"
X-IronPort-AV: E=Sophos;i="5.98,281,1673942400"; 
   d="scan'208";a="684217023"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 22 Mar 2023 01:17:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 01:17:56 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 22 Mar 2023 01:17:56 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 22 Mar 2023 01:17:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V69SH1JZSftM4DT06uvQuhg6aIgw8GcdUxnTSuJe4ofw51LSi/eub/SQJt/m9XGfk7gTWTl28dbIwvXfrTLAPr4BGYl17Fhoq5PDDA4l052YoyBtd7lB5ZRs5b5XUD9nHTvy3iXpe5TqQ2981Lx39bdxVeFQ6XwPkiezOjDov+x14iWSxrDlD+i+XGhL98PsGSh4itfB+KpPipou4yeISSSaE6E7/wmMQGAhqEQ0FPTK8C1EiNuhGTgAIjBrItgG26qxVVpse/Te6QNfZYF6nLL6Xw5BOP6hhJ/gpnSD1qiJTJbLhqCrdS+mNNXC+yUyguwnXodCNsa7WHmLEqJoeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fzB4KrrKaMRBtb0A/H1/8yVmp0CE4aAnmbNhmgb2MqY=;
 b=dqqlYMIM10nYAoF36Ej+xC/zGFU7OXH2ADa8+y2DSEsJy9Nks7nzkTuaGfH27zpaTuv85RYCK2AEBJ+0ERPX4bYiNAHR+oO5oe2cnyUpxAQLaI9YDt3rPHneUYsxmD9nMHWAG0sSQyX8huErB8wVbcQXbTkwusViHM9Eh16lD3s1Bmf37PNA2KC4kLXjuH0lmxgcuzx6h4Ic2StQ7u6uoyQJQw70sI5hvYeyZ5u3wzLwSQ45nhnzAt64X0kloLzSbSymb+qSbGsq8p9EYF3MtD7za3Y3AT3ct4C/2ZNJfIcNe9oNfZBtss5OG8N/bnjuGlMcn+yUXuNXtJR5x8Z/ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL1PR11MB5320.namprd11.prod.outlook.com (2603:10b6:208:316::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 08:17:54 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 08:17:54 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZW095081R6kW/70aeRy5pC5KSt68ERp6AgAANFoCAAV3gAIAABT4AgACOijA=
Date:   Wed, 22 Mar 2023 08:17:54 +0000
Message-ID: <DS0PR11MB7529B8A8712F737274298381C3869@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <BN9PR11MB5276300FCAAF8BF7B4E03BA48CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230316124532.30839a94.alex.williamson@redhat.com>
 <BN9PR11MB5276F7879E428080D2B214D98CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230316182256.6659bbbd.alex.williamson@redhat.com>
 <BN9PR11MB5276D5A71E43EA4CDD1C960A8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230317091557.196638a6.alex.williamson@redhat.com>
 <ZBiUiEC8Xj9sOphr@nvidia.com>
 <20230320165217.5b1019a4.alex.williamson@redhat.com>
 <ZBjum1wQ1L2AIfhB@nvidia.com>
 <20230321143122.632f7e63.alex.williamson@redhat.com>
 <ZBoYgNq60eDpV9Un@nvidia.com>
In-Reply-To: <ZBoYgNq60eDpV9Un@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BL1PR11MB5320:EE_
x-ms-office365-filtering-correlation-id: f56e5028-9c2b-4d03-4208-08db2aadefef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AWZ7Aoi7IuGwVXbrXXoUgdbCm4LwLDWq5vuFl0rRzXzhbQoVE1DUU044q+DScdaBF81fZZjxR8S1sR+LkybSFXAfEMfbq9/xL7aTMlQbpG7D0LnHeqGPDYjwDfUmS8Mm8oGX2kQSsbEIneMT6c1DvI+NxcvtFf4FydVOVlcyxQYTpJ4Nv2XLQN2m3eDuiWACWTBlZ1aCwmxGgwJCoHmpYdZAK6mDBljlwqDWfPUs9DWQZ5+v+Wv2eFlYUMtjeu/AQoV3vIhGCXlCZCAMiFuv0HnP6DzcjnxSnDIpoCXY6U+qGORiAXx2r2G8odqo3IjKaueErbNEEbxLVuwsoLDgzcgPc50MvYfS+R320KELJrGiTG0kl09pxDmJLTKX3P20hLCn3xypfVQ3aXIQdjI16XAjKYEHDagxIZRC9e0PMjpbGcbBI8DwYbqGksYeXX4jJl1qnRKrNPB9gdOvGW6Dr04Z43SlcKqPJhdg724OmYz9yVn5SNFZBf2RzfPFwpHvCWxn9iyONHGmI9DAw19dvXVS6lQ7N/qCk1e7j+UN82Czwd3OfecLg8rVXB3XLjcH1QcakvU6Yve9l8FC/CLvaeXkTtTxlVxKXhQ5L/mbEfl0hGD4nEH8Su09oVOU3ymyir84pW4XuQlQ0JQjZXcVEglXmhiL5ppPVsVYPjp+xorGeknRERc/13b82rP1qhFHkRC4qSuIPeQK+YTOjJN6jx4ggIDVB/gsvKpybQrfy/I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(136003)(346002)(366004)(451199018)(38100700002)(86362001)(71200400001)(7696005)(83380400001)(54906003)(7416002)(316002)(110136005)(76116006)(8936002)(55016003)(66476007)(66446008)(5660300002)(8676002)(52536014)(4326008)(41300700001)(66556008)(66946007)(64756008)(478600001)(2906002)(33656002)(82960400001)(186003)(122000001)(38070700005)(6506007)(26005)(9686003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uoBOEXpjEKD0ey38Jd4I6vSRf1zXKghMGoB96FAdmYeBbbNViMfyRfWH3sLZ?=
 =?us-ascii?Q?1RRTKDINYB8axcfpbE3I/KA8rDEbjcle0pBY0rgb9BQr7hBuCEKBDj5pKcP/?=
 =?us-ascii?Q?7DfUnMxZtUQYBeT23cnSwMI7y2lO2hdlnC4P0mKE5PtJFSvI33OpfbeJAjQb?=
 =?us-ascii?Q?ujN/hwlN6k5MLdFWndqkG5VE9VTVfpP6EbOGLXwq/2al6nSnoJ8R4YqYLdd5?=
 =?us-ascii?Q?A59teKdsit+Hpwnk55HIKEHuD+aj42eNgx1t8K82bHYWqQ9U2JsM/sYpDRyI?=
 =?us-ascii?Q?insuTvbKNHfWCRNCes/fTfHAn62TzxGNpHTfZzkLvl0Czc/Xrsb/fq5PrPJF?=
 =?us-ascii?Q?RPD1q+ID/q7wC9UzBq6qKB1EBZZuKbPkC82bcA2L7EY8aCmKmMww/Y35nG7+?=
 =?us-ascii?Q?Bb2sHH7iJKTqE8gPJPSsLXedthf3VkmjhDoIAE57AUJCf/uIJz7AfdNI/knd?=
 =?us-ascii?Q?SrvDCBT3vSngI9Vz0JZbGGj1igWWbWfZ8zB05I4J57Vr2USq8+a1mvEAPg8z?=
 =?us-ascii?Q?sYewH2jJBGXyIi96NvZe3rPCuArI0J8XexmHtLxzR5o4elx1N+EST92wYJg2?=
 =?us-ascii?Q?Rygu9iDGG2ccydmQe0OC0mAWolTA80DuD1yPdUI/ITT5iCVNKuFjM03I7Hby?=
 =?us-ascii?Q?6s/Jhb3tupKd5rCj896vlwsuY9uAf2aHHQfw3054EqhiZ+OlQ+aoQ9eVCpk3?=
 =?us-ascii?Q?E8fMgV/4QFziIvi+Yj08sbfqavXP/lTHqIRdhs3TvgmgwKuUC1c59e+qlcfX?=
 =?us-ascii?Q?C9o9gwLe6fO0uaDM/M+jCzZ26z05OUur+CTl1vU9ODGa08cb743WEfNas5Oc?=
 =?us-ascii?Q?4gC6M8vOH2Bon1O+7zFQlaLn+nTvSlFot5WVTiVl52jQu/4zBb5r5X9AuXry?=
 =?us-ascii?Q?zUXWzEjKH4kapFHnbM9szLv/IpnS15IWMPKAcsuBvEl10xIyxBWEOBiPx2P8?=
 =?us-ascii?Q?CG/XqxDN029H9t2trrTHf/f+2nSZZy+aUNDH3v32CpQCv99ajYZvd2PazcAq?=
 =?us-ascii?Q?ty+g9JJZw1aceHgHIqR26UNNpVT1K5D+JqzV+rt766MWnzPlf22QVv5JW/d/?=
 =?us-ascii?Q?otheRPSVx0IStu7J2mZzVdO9JXsZJf50mO64YWI2mUC+c22fSvx4ODFNrb4r?=
 =?us-ascii?Q?4xas/O0JaiK05CXHQG1T3MdOdAED12TmB3xcvGuPjdovQXL8RACfmmcMemia?=
 =?us-ascii?Q?br6JAK3p5lcRELUjmVdstw8sl47vXX6ilV3xhN6Ge3bMTodee2AAA7yqVGbM?=
 =?us-ascii?Q?/wTrSfZDls4JKKHqj4Rhlld4+Cg1iDuCcHOhae0PHsbJT8KM4GljUC1YkOSm?=
 =?us-ascii?Q?Qz3rZhNSquz17qd2/bzD8eP0e5FCaFgxH8CDlCeHcvnbkW4bUacKB68prqPm?=
 =?us-ascii?Q?Li2X3AaRuNY5x3VOk6E3dyvQA549+bSk9yqkZUnGpkp3yxFN947a09XpE+jd?=
 =?us-ascii?Q?FFcQCY0RTZS6ANimrC6e7/SWNNssAT6TR+NFyAzqLzYTUQKf9PVV421AEJKm?=
 =?us-ascii?Q?jMLdyEYLlZRc5hKc1/kPaPp2uhqMBkTlSZmYsalEo8xgziv92YrZYYHqcM/6?=
 =?us-ascii?Q?uqNse8G46rjAfe2+p2Zl2DqLmUxbAJrNP5iuSuX8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f56e5028-9c2b-4d03-4208-08db2aadefef
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 08:17:54.5888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DHyn1fZAexybhUXg4WtojcHrkCiUi6lC6d+C8slmCjpFgPsC9BwqDpP44/AXVAp7y+z3BoWy0HDiijv9+E1VAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5320
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 22, 2023 4:50 AM
>=20
> On Tue, Mar 21, 2023 at 02:31:22PM -0600, Alex Williamson wrote:
>=20
> > This just seems like nit-picking that the API could have accomplished
> > this more concisely.  Probably that's true, but I think you've
> > identified a gap above that amplifies the issue.  If the user cannot
> > map BDFs to cdevs because the cdevs are passed as open fds to the user
> > driver, the _INFO results become meaningless and by removing the fds
> > array, that becomes the obvious choice that a user presented with this
> > dilemma would take.  We're skipping past easier to misuse, difficult to
> > use correctly, and circling around no obvious way to use correctly.
>=20
> No - this just isn't finished yet is all it means :(
>=20
> I just noticed it just now, presumably Eric would have discovered this
> when he tried to implement the FD pass and we would have made a new
> _INFO at that point (or more ugly, have libvirt pass the BDF along
> with the FD).
>=20
> > Unfortunately the _INFO ioctl does presume that userspace knows the BDF
> > to device mappings today, so if we are attempting to pre-enable a case
> > with cdev support where that is not the case, then there must be
> > something done with the _INFO ioctl to provide scope.
>=20
> Yes, something is required with _INFO before libvirt can use a FD
> pass. I'm thinking of a new _INFO query that returns the iommufd
> dev_ids for the reset group. Then qemu can match the dev_ids back to
> cdev FDs and thus vPCI devices and do what it needs to do.

Could you elaborate what is required with _INFO before libvirt can
use a FD pass?

> But for the current qemu setup it will open cdev directly and it will
> know the BDF so it can still use the current _INFO.
>=20
> Though it would be nice if qemu didn't need two implementations so Yi
> I'd rather see a new info in this series as well and qemu can just
> consistently use dev_id and never bdf in iommufd mode.

I have one concern here. iommufd dev_id is not a static info as much as
bdf. It is generated when bound to iommufd. So if there are devices that
are affected but not bound to iommufd yet at the time of invoking _INFO,
then the _INFO ioctl just gets a subset of the affected devices. Is it enou=
gh?

Regards,
Yi Liu
