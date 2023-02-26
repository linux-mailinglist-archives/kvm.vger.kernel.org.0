Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E226A2EF3
	for <lists+kvm@lfdr.de>; Sun, 26 Feb 2023 09:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjBZI7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 03:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjBZI7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 03:59:08 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50CCBDF9;
        Sun, 26 Feb 2023 00:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677401947; x=1708937947;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AiQtSFxtoc2bGfLzYcgwb8/X1Z9vt6IdUmmBAP9jGv8=;
  b=nm7yzOmYgtIRjc2scxV/kRZq0PYP3mZVvs32pKq+Z9o09W33QfSo8OBt
   5djJf9RYssXdqgOApCIm6JDKzOrTmlE+qlDF3JZsomRzZspCeizt5trWm
   yq6W883FsgrTKZ14NwH27BCJXaMXvphUzcxqpXgeEIZi3iMf38NoWy1/f
   USOe6BKCwiuBWnpYKXQaT3dIY83N3KrO15YPhtFpPljnw+AiHFnEuX0hH
   SNNtkbzeqZB4FG7sKF9MUQRbl0EUStOsPPd9M5TcTZIl7kwV10zR3nTei
   gLUA1DM5AkmJ7JnbRPN7ZXMdW8Jy8L5rwNgbBmygbgZVxT3mpBKHVjQpN
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10632"; a="398471160"
X-IronPort-AV: E=Sophos;i="5.97,329,1669104000"; 
   d="scan'208";a="398471160"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2023 00:59:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10632"; a="797225184"
X-IronPort-AV: E=Sophos;i="5.97,329,1669104000"; 
   d="scan'208";a="797225184"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 26 Feb 2023 00:59:05 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 26 Feb 2023 00:59:04 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 26 Feb 2023 00:59:04 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 26 Feb 2023 00:59:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SnBRKP7u0zAlGx9WmW9YNx92MFw8JWEqBKfyyamJXwllahmHOv/J6DAN1vIZoKaoIfq1OND5EvdbccgWxfpXOguHbsD+NiMNSaXnATv70lrqZY2Dd87DxYRzraKT1Nm1gkfDc11YSedemq1gm8E4tkpOUCLTbDyKK1QFvOIkyXglwj8/GU/p24NgE9xc14Iab3AatGc8ptz/nUg8cPWPH6GCNdG2NAt9VZBaKH5N7vpQSUIv5uCb7bls07AwTV3UBBNb8QHgj6KBKgDIByyG/HOJNr0XMtiXW6jedTUyRMNUGsnxk/ZhR+sMxK6E+V/4uUTcYw4HfXDU0cyD0TudCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QCCQgQWvGfZQuRmDoZrYBSzPp7TyBXCeUUiwf+SKsXs=;
 b=FaKfehUpKdwhdBT7vNUvLsa/KrEb1QPQWuPJcn3aT8xd+gpxQIqwyZD/ZpMmkH9KuX/YmpW3L3WSj7Xe0eVo9pWW78+L15uFCahmruowaB1HeQowOKHYbLDFAtqjZy+cQ8a1F/ew6PBlvtM1tkIFsFbfOZnXvvaTYGMVHCSSHXFGPa5Wh+dRyAB2t+s2EjJ7lCFTb2g3rrb/swnSXY46IJMKg/PC2rTDJHqKlQuj5incD93veBivbQpxDBpuWK6sI1UDg5QsCnZ4Dh7qI3q4c7SuwDl2heM8G9oVxFsRRnK1pxdtJ4CrrVxNZeyWjBIbO/C/nC/HwizvPegZ983PBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA0PR11MB7355.namprd11.prod.outlook.com (2603:10b6:208:433::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Sun, 26 Feb
 2023 08:59:02 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%9]) with mapi id 15.20.6134.025; Sun, 26 Feb 2023
 08:59:02 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Thread-Topic: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Thread-Index: AQHZRadeNlgrDl2wokCstlukf6hiCq7akpcAgABgJDCAAEUdAIAA9TSAgABbNoCAANnbgIAABBCAgAOERXA=
Date:   Sun, 26 Feb 2023 08:59:01 +0000
Message-ID: <DS0PR11MB75292B46BE9CAC31EF4AF833C3AE9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-10-yi.l.liu@intel.com>
 <BL1PR11MB5271D122329B6908BDE1F8328CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <DS0PR11MB7529B33D098225CFAAA7D63FC3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/ZOOClu8nXy2toX@nvidia.com>
 <BN9PR11MB52767915B9A5E509BC90E0888CAB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y/dobS6gdSkxnPH7@nvidia.com>
 <BN9PR11MB5276C959AA31F8515002B6B48CA89@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y/gilafqe4Xm45jY@nvidia.com>
In-Reply-To: <Y/gilafqe4Xm45jY@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA0PR11MB7355:EE_
x-ms-office365-filtering-correlation-id: 6f49d9fc-292c-44e8-89d8-08db17d7b4b0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eLY5dujwMLu61gitunGHMC9abvZ25Bv0WzY6KjSLr7DMaVNRDEqfnBw3MYC4tVH0/4z99Wb1ZIBzl4t0L3XQFL9R2/wF0WweM/LHlZTdQxE18oml0qJxhU0Cb4fBW1tqUXosrJ8E+cQotZMHsGg98ytLHjMXIu9PPTPPyyQzZUA94xwcd/f8s9O4geFu6OZHnKFxRmmSj7DEE8Xl40Sc/GeQ5CedTWMsCZruwUwMgEP4A9WQr0ZJuOI82rqvUnJY0UzOX0orzz4TecEj79AN4Qrdve70rVVvLdq6bv2CiRIXBGUX0KAyW8LwkFgKCQKraOKDPg1VYCcj3cVsvssIllx5cjHgnM1Vl+quHoPYN9cNOEJxkQ5WU8UETEO88sNlTJHzg9/bM/ge0T96OHwpn1JK6vF0psHZqGtfDWIUSDmTg3BpZfWzvePQROZ5ZnxIZ7Vr84diI84TDW1RkWoOqIXSln30MsntR5XJ1JfTQ8+6MisWZ9/ldSo2zhefZsMaih8eIrS4k1aS7r52ajnFz6yn2zHxlLc3CxlhPty5yz6CnhXiKW1DNzjq8i+zAjHsC1j7LZC9ajMZcmy6UDrT32opVsOQkarpGmRjWEr6/ok8yzaEwrqH9NhQ8ZJUPJi8xkdYhguuhtcYL6kwbZC9oo5oSHviNHRNzsjFepN+bp8PKRLnypyCCR4dxzBO6/sFCQxV9tpLqjh95HzohP/pWhUrugZaOK3jwKvR7Z+DPB8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199018)(9686003)(82960400001)(66476007)(38070700005)(122000001)(83380400001)(52536014)(38100700002)(8936002)(6506007)(4326008)(41300700001)(76116006)(2906002)(5660300002)(66946007)(7416002)(55016003)(7696005)(71200400001)(8676002)(26005)(64756008)(186003)(478600001)(110136005)(316002)(86362001)(6636002)(66446008)(33656002)(66556008)(54906003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6Jt0t5/UnLqCgO03nCcy9EYGx/RU6V7+51raiT2ZmgAEaqV5jqgXFsjw+Dvm?=
 =?us-ascii?Q?AB5o9piGuQUvWndvRQ2WLhpoNs6kYjB0jDxrrs1JNZs9LKEfzbGzNYjqspga?=
 =?us-ascii?Q?SKk/1YRIWcNBGb/X7H+IxE3uMol2E9FW8+aTHS9ZfFVuA3qBRkbAdr6FeE6p?=
 =?us-ascii?Q?Td9dw+bFSL6EyLVdaA/eC8lRZ3ymjkgsp3Z/bbaZ0L7TBxvY5jp7o0cKjh43?=
 =?us-ascii?Q?PpHtLgFRhWMc3fv7x+lh2KiMI8FeISdL5Urg0LxGfLG+B8zTy+g+unasKt3u?=
 =?us-ascii?Q?AyrgBl3cWd7ZxWalBl5cnou6yBSgBr40mfLK4GVdDs6RuUJcLwhMaHEkUFfy?=
 =?us-ascii?Q?2QFbiw/r0h23oel+HsvcRiDSJkcTy+cYPSPmGZrhLP8dSCjjWy1fzKBgFg1l?=
 =?us-ascii?Q?/DtEzM24oG4TWP8I4J+U4bpsdCcRboBnb/Izq8lQJ10qBbTcq5JPw1CnGJOz?=
 =?us-ascii?Q?++y9bwDKYNfKfBaQGrkABEmtBgBnMWfryPzJvq/FwtCIxTeYONmxeGFvws44?=
 =?us-ascii?Q?a5uWc0VHGx0HwzUi+asIsfeiHH7vrsq7vNhjQfKc6VVfxdG3/WsAlma0DibN?=
 =?us-ascii?Q?DwquU4QwtM4zukqpo5zl2h5tJ23lLTuGYgWhQ8sEK4yrvdFMfuSYbjk7iQDb?=
 =?us-ascii?Q?xkn2mtX0cBBj1NhbAjOmAf0eFYzPrfuhhJ+gPnr8gNPEHfxgLA2m67Sdmlgv?=
 =?us-ascii?Q?zGWeTVIV5HwLRB95bhr+7WBEbskREPWuBHu3Ob+Oc7ZFZ9TMOjZB5CeetCp4?=
 =?us-ascii?Q?SsXoh2B7tdBH7ALtpUeV72ChfhHeSQSgPCclaun4MGFUAIEm/tv6bZtex94d?=
 =?us-ascii?Q?HyKyvYnzsAspe8iyRNg/8jFY9k4q+IgSVsSKpomB5y4lCxlPLQ4ocNPn+71C?=
 =?us-ascii?Q?LsAx//2DKciPN68SwORlu4Ya5AuyfXbt5uD81UOrxJLwPP8u/6mQ0KxDo4je?=
 =?us-ascii?Q?g/FwQ5v8GBCGCM0cxw1prJaDeyLpD0fAs2Kv+Rv5WlNQ8J/pvGdzQNWyWyuO?=
 =?us-ascii?Q?JxVR0N//6+cmg581WPzgRLKdTKycMCs5Z8Yw/8FWrBAhfnGYsAU5xjc+/PU6?=
 =?us-ascii?Q?62GNY6EqeoEPRSVMNPRtFf0UVcvH2yAjpcYAOuOat1WvwZdzd2p8Alfwj4nQ?=
 =?us-ascii?Q?fymojlVGV4Xoxz2z+d74PmHU9447G+PrVe52uVW4zN9D3A9Du1buL/58njN7?=
 =?us-ascii?Q?R9m+3FejpTur7dmEy68jxfYMim2vR735h8Mhr2XKk/QanoU2F1N5xJ5FFqCr?=
 =?us-ascii?Q?6OvmOSzPqZk4me2zrJ58Zv0JpIYD4YjsnTW76P4BcO61oz6N9dny0uuHvPAI?=
 =?us-ascii?Q?TqErFCU16a9agd9Psu+xPs4kA9vhA0PQd3OBTBb8iRDFWYO0J2XRR0kFX1Ja?=
 =?us-ascii?Q?aakMcQAXN8zBbKDaobiWxF84QqOrU1s+N9N0u/NVY2NYy5x5UPIexL8UomN1?=
 =?us-ascii?Q?TVH92zghu0zT1D5qdSgxtcRuR5hFHoJyCtZQEXXY0MRgV3xux0VFVwOt9z7h?=
 =?us-ascii?Q?yBaCfnCfpDC7BwbaBxf4xw5DUhzCt6ARiCVqCqNcCX4AJ7tWgMYri9KU+y/l?=
 =?us-ascii?Q?D45DjLO8RnVTw3LaZAxipEDj5RMoOMv9U5KeVZbe?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f49d9fc-292c-44e8-89d8-08db17d7b4b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2023 08:59:01.9620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 51FNFrmyhSF83WGG+GR0vJC8dr0rWqZaL9Jdk+ZWHBAqQw9hUm3COwYBp7lW+WjfwqnKOzvyDhhDGnjI2SocTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7355
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
> Sent: Friday, February 24, 2023 10:36 AM
>=20
> On Fri, Feb 24, 2023 at 02:21:33AM +0000, Tian, Kevin wrote:
>=20
> > Yi, while you are incorporating this change please also update the
> > uapi header. Rename 'group_fds[]' to 'fds[]' and add comment to
> > explain that it could be an array of group fds or a single iommufd.
>=20
> Upon reflection we can probably make it even simpler and just have a 0
> length fd array mean to use the iommufd the vfio_device is already
> associated with
>=20
> And the check for correctness can be simplified to simply see if each
> vfio_device in the dev_set is attached to the same iommufd ctx
> pointer instead of searching the xarray.

Sorry, it appears to me the below concern is not solved as above logic
still requires userspace to open and bind devices to the same iommufd.

"
  > Say a scenario where group happens to overlap with devset. Let's say
  > two devices in the group/devset.
  >=20
  > An existing deployment assigns only dev1 to Qemu. In this case dev1
  > is resettable via group fd given dev2 cannot be opened by another
  > user.
"

Thus, I think we still need to search the xarray to check if a device is
bound to iommufd or not. And this check needs to be more relaxed.
E.g. dev1 is bound to iommufd, but dev2 has not. However, they have
the same group, so dev2 should be considered to be "bound" as well.
When 0 length fd is used, vfio just gets the iommufd_ctx from the device
that is to be reset, then check if all other devices in the dev_set are
considered as bound with the below interface.

+/**
+ * iommufd_ctx_has_group_for_device - True if any alias of struct device
+					is bound to this ictx
+ * @ictx: iommufd file descriptor
+ * @dev: Pointer to a physical device struct
+ *
+ * True if a iommufd_device_bind() is present for any alias of this dev
+ */
+bool iommufd_ctx_has_group_for_device(struct iommufd_ctx *ictx, struct dev=
ice *dev)
+{
+	unsigned long index;
+	struct iommu_group *group;
+	struct iommufd_object *obj;
+
+	if (!ictx)
+		return false;
+
+	group =3D iommu_group_get(dev);
+	if (!group)
+		return false;
+
+	xa_lock(&ictx->objects);
+	xa_for_each(&ictx->objects, index, obj) {
+		if (obj->type =3D=3D IOMMUFD_OBJ_DEVICE)  &&
+		    container_of(obj, struct iommufd_device, obj)->group =3D=3D group) {
+			xa_unlock(&ictx->objects);
+			iommu_group_put(group);
+			return true;
+		}
+	}
+	xa_unlock(&ictx->objects);
+	iommu_group_put(group);
+	return false;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_ctx_has_group_for_device, IOMMUFD);

Regards
Yi Liu
