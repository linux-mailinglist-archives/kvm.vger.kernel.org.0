Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B783F4F90A7
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 10:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiDHIYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 04:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbiDHIYB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 04:24:01 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E551BA185
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 01:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649406118; x=1680942118;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DZAuuIzRWVvZZRFkTkxXEiNZX0CgaqSOh2PYK/D6IuQ=;
  b=agkL7sNf/nOjC6msKya6zev/ANMRw7aYy+oxI0g/Xq3Vydr7UMpnWO63
   YlTKP1Ex+VSVMTJlb9iUbZRkbRSMZTrbSizS43c+htSEm8NpTpwYMZpo1
   QQZqY2aS1PQbo4COU6xs+MwoEDVOhg4aObY4PiWyrOvkNaBJKW/vjOfpV
   YGfrAZxIhxsFx2SjTPa5RMcIuT3BUD7NqMCBR0rywgjqW51WIwAipK4fB
   olnmOX390J0FzpWCPeUDso1j2Ob3etegwP7wFkM66fEUceDQxi/+Yo4zT
   Bjnxjbp08lExb+32jidfa9Rq0Gra/GWFu5WmFek/3PU/eamw0+RkkZ9Yf
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="249072933"
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="249072933"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 01:21:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="589146331"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 08 Apr 2022 01:21:58 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 8 Apr 2022 01:21:57 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 8 Apr 2022 01:21:57 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 8 Apr 2022 01:21:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z41P0FKPDlLOfoFLPg7xBQdedJNk29c4B0rq+47HWsm6YJsHW+tBqoMcWJPPuy+0J7mYpk/jbZObclgJveA578EepipjKfdkGtS2eUqLyzGX/EiLe0Ql9KKgCyYpHFycxqeAomYJm9KIbZJjIl7S0jKMjK2kiC9nglLcxi4vBigqQ6puXGmjRCrjPjJ3oPo4rKR0n1qTB4jAFopXsDPQUmK8aC3Hxe/lzLbWJ/joXOpLpYz+4YFpLELPBr3WPKYiyVDPNiTKL7ehyqGP9g1jxHEQOlWpWl8xQBiNA5MOucf9mvvA+fT3iziSnnGcK01orDwhii0xz5ndF2gJ8+QVGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P78lYteRom7BWtw4ka1nutdU0Oai5p2mxGaP61RjwjY=;
 b=KrV5LAghn1EMMYKTUwcJxDUNxvffweScgPGvoNIusgleP0Ioy3n3YkqJd/6a5qYuPktSbximeuOEVydp9YMfHJBZx4/tzaipzZ4nmb/BVmYgNzwV8C5gMufRBvLRRUQRp/xWgFPA3+Mo9LOuo+F5K5ijw84ihQe4pjUg7rR0GiTziiKN1TDeD7eVNBJsn/joWMdtEKracaj2VFjoGvKNeg/pJCkel6ArO4gK4KhRt9TYljZIr7HwX7yzurBXPpi/GtU3o7UjnpCMGhlAO5RGSwBw+Omovan37ehuLuIvW16gWHMz4N3f19PTGGC6arsKY6U25kcq5WxK0otL8/yr+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN8PR11MB3636.namprd11.prod.outlook.com (2603:10b6:408:8c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 08:21:56 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%9]) with mapi id 15.20.5144.026; Fri, 8 Apr 2022
 08:21:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Cornelia Huck" <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Joerg Roedel" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>, Jason Wang <jasowang@redhat.com>
CC:     Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>
Subject: RE: [PATCH v2 3/4] iommu: Redefine IOMMU_CAP_CACHE_COHERENCY as the
 cap flag for IOMMU_CACHE
Thread-Topic: [PATCH v2 3/4] iommu: Redefine IOMMU_CAP_CACHE_COHERENCY as the
 cap flag for IOMMU_CACHE
Thread-Index: AQHYSpOOEHsaRTs/ZUO9/b8cxBl8XKzlrSeg
Date:   Fri, 8 Apr 2022 08:21:55 +0000
Message-ID: <BN9PR11MB527673C3360785759CEFF5708CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <3-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
In-Reply-To: <3-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4bfdab95-0f8c-40cb-dd07-08da1938d81a
x-ms-traffictypediagnostic: BN8PR11MB3636:EE_
x-microsoft-antispam-prvs: <BN8PR11MB36368ED5958893C47A6C70BE8CE99@BN8PR11MB3636.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ivLJuAnf0rurKUD7Fp2SViA7Ncc6GqL6QprlZaP9/Ht/pWmiJo/ixdCD6QoBhPxM797N3lYNWxfAAtpkDrEatWZtgHHmFpZiuMbnkvQNmBCkyz2SpWBKrPDXi4+1nhBR6aUdCFP7m3TyUKTJEGF0F0RISPZABzBULnyNNP+mfxCBSXRt6SMHDopW8x0W03Fe9xvHyrhCWUjkzOkCX+Fi9ViM5v0kUNl+NNyqI6dXmWZiM5nGPAw23bnO/PNkwVRj1R1pyaWxfpKRSq5JmHHLaToBsiuiF50L5/zYsK5m35/MpNOTyAVGIaUalG03yZVkfxcqpixKmeFK8c+90gkfax/yom/dreSWNmTlCQ6qCFNGqiv4wscum7gO2VoIlPWEAgzR74az1TooOrKTR6SasFte/tAzYyP+j5nnOAmuxg9bECOof7CRodnIourLpTL+2tkpxwImi1GmmVXF945iwLMazwgQDrNVupxN1oxlhSHQ/MTfEZrIkZ5Mmae9Ff6pgCQspIVxuvZltyUUm6LFRfig6OwSKal+fTl1KG0HQKVSsDXW7+YmPBZnDXElJZz0fRfiPRkWHyxiu4104Tw7WQDiOU8COWJGfBtCrX3HwZkG5GnrhQlcxaX/yEXvYI88e2cA+8owJcHcQMNvw8HeIV7+MhKtPgrrCo/RBMzc7ztMSijfLUnyPxIBcrNkDNqS2seo2t0PORLem6uHeFnJiNQcmbKwmQYLbwPcsGj+A9dkj79XdEuWvCxvWje1zKM/DxsYA228+8VWH/fWnhOgQihri05izfUm0gCyH2jKCKGaMQAstTt7qmZUp+8xDBgD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(966005)(26005)(8936002)(122000001)(82960400001)(186003)(52536014)(33656002)(921005)(76116006)(38100700002)(7696005)(6506007)(66946007)(9686003)(64756008)(316002)(2906002)(5660300002)(66556008)(71200400001)(66476007)(110136005)(66446008)(38070700005)(8676002)(7416002)(55016003)(508600001)(54906003)(86362001)(4326008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?s0PmGbO0prCoMPxPixYsZnhoIk3gPSdzpYfJB8j3xfg0GsdSrCjQo2EprZs9?=
 =?us-ascii?Q?ti68fEiJya4mkPStgU1e3lWf68EDED1SvKH6T1jsNI0tauU0iKkKSa99a8z7?=
 =?us-ascii?Q?emtZhKiLhTBwp92JeBtFCteDK7DWJhalC8GwtOAqwHw8qWinhk0cgkgXXqGH?=
 =?us-ascii?Q?wx0WxMYLD72CSZ8wHN2SbvNRWMRSe85s0zIHSZtLviW1Auy8QsMGVL1XUuyl?=
 =?us-ascii?Q?OSFBQ6cGARXtpsvHbWALoD807+/OR5yBk5vtnw/mrVL0X/MNiW3Bgq/69vO7?=
 =?us-ascii?Q?4OFjUd/0VMpH4gGcOqTzNgYnOpv2AUiQm5C8JU5xnjaOP6XFeOj8j8o+fZ+c?=
 =?us-ascii?Q?JPLvTKmlH6IVXwgIKZZ1u7mOBfD3pE8QkocT3sNRfJC78fPoHAr3xfOGXaJ5?=
 =?us-ascii?Q?b50V9h50mAxJHx6aHcV0gtpHKi5Iww/+wMc7OZnKhCgjngJvi9DHPreCrThO?=
 =?us-ascii?Q?MAXEZcRLJY7AJjO3R6z6bOEvLsDoYc8bviAqLM58gnRFf68AXBMAnPMBLU2K?=
 =?us-ascii?Q?nXdiN7v21q0JVl0vVAKa14oVcGNhR5yoFScX2BOO4bwZ6Am04p/6KhAqPZhg?=
 =?us-ascii?Q?kJyMdBcXqFmkg8/uPdlPFIfYojY0rbrCJvk36ndbYMIeyXlCGZIsv3xQKLfc?=
 =?us-ascii?Q?AzSkpm8ZxsL+7WVhXY0+hKia7+QA8o3odA0Gid2fKS8UfG8D1h/SpalB1kbY?=
 =?us-ascii?Q?n6Af0nU6PKG2gjjKSWQoX2/xrX4cGfQovrzY6+ZQGOnsVEC2fOXrGZioKgem?=
 =?us-ascii?Q?VDmGopXikjfEX61Lr5H7/OwVNm4iXIw5M2Jq5h7JCfN+Grl+3nvpcm5iXu5o?=
 =?us-ascii?Q?JGe9ysrzN/hB+oIhDJXvbwo0bE+lMYFN/qqqoWYIXUlFGC3pnVKfC+jdWs9r?=
 =?us-ascii?Q?AgoGwrx8gkh1xUDOH7nZTThl3eXdrAOQssbVoz66AFIELrmJbfCRg+XXiWCe?=
 =?us-ascii?Q?hPPwXB0kNX4ddefALhXDrWdDAMI3n+BgaaVTPFJosBH4N24/BEFfBNxwW5A5?=
 =?us-ascii?Q?mafca8WdJgUTGt/S+UD2XxbTRa8uq2PxcL11CCMT6JeFRMaAPo3HR6zpBH3f?=
 =?us-ascii?Q?qInYZnik5dgImmJGwqV2aXdE2tDs10+RBUEYrcOU3i1dcRRLUlv6nz+GnWZn?=
 =?us-ascii?Q?AhoM04el3ne2zMDrSQxQqEKvoTLKH92NjOHpLIxeG0QEIRknAMYeACISQTeI?=
 =?us-ascii?Q?RtUg3KAb+yUbrcD/b+2nUZI/fgRaT4mWdwcQgsrzZdNIOz3jBsGak0Kq7fov?=
 =?us-ascii?Q?HLNI3VlweabCbbBBny0TiY40+dNocDU78AC+yeoJvxdTCOp/O0WukcIL56my?=
 =?us-ascii?Q?R+uPpu4tdiKOoDCZ5Nc0JJ2xf69jGWqtSebtFUEGi/gk6NwMtOr0RlnRDAa7?=
 =?us-ascii?Q?bPdHiqZ5vkFacjx5bl05yWlZY9C1m+pS0vNw2Xl7O+xJPwYp1heMbuZrm7lZ?=
 =?us-ascii?Q?DjsBERML8mD2/1t2DW4Tv9oif943hdxLhDD4gVayOx/9tKL5on9fXIeaUoVO?=
 =?us-ascii?Q?6T1ffpuRQ07P+pZ55C6MtlXil2g2FflyR7nEOW2X4RUNv3gYF26cYOZDFHUK?=
 =?us-ascii?Q?4zyONUDqAsu0n0awRgdIQPDxeuy5Zw1hcU9KYDxH1aF8U1A9QecIZFJgWZlE?=
 =?us-ascii?Q?D5HfD5jcf35XOa/FlVKRfwBnPaSE6M8ur8t5SqK2BMkWeQCdmpUruLmLEAf+?=
 =?us-ascii?Q?bgdiCFobgHmxllk6X61T8zlBmQmBXfMjIpXMU26Gq6sTbsMisW761zozXPfF?=
 =?us-ascii?Q?Yn5NV1mXow=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bfdab95-0f8c-40cb-dd07-08da1938d81a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2022 08:21:55.9911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 85TUKjmIDawmmzBIuuK+q9JvqpLkNDUBdSSnprAABeNHXsLrsp3AgM9H9pA1uDZ7i+4hdPJH59fGZXQfZVNRnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3636
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(CC Jason Wang)

> From: Jason Gunthorpe
> Sent: Thursday, April 7, 2022 11:24 PM
>=20
> While the comment was correct that this flag was intended to convey the
> block no-snoop support in the IOMMU, it has become widely implemented
> and
> used to mean the IOMMU supports IOMMU_CACHE as a map flag. Only the
> Intel
> driver was different.
>=20
> Now that the Intel driver is using enforce_cache_coherency() update the
> comment to make it clear that IOMMU_CAP_CACHE_COHERENCY is only
> about
> IOMMU_CACHE.  Fix the Intel driver to return true since IOMMU_CACHE
> always
> works.
>=20
> The two places that test this flag, usnic and vdpa, are both assigning
> userspace pages to a driver controlled iommu_domain and require
> IOMMU_CACHE behavior as they offer no way for userspace to synchronize
> caches.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

btw the comment about vsnic and vdpa matches my thought. But
a recent change in Qemu [1] possibly wants confirmation from
Jason Wang.

[1] https://lore.kernel.org/all/20220304133556.233983-20-mst@redhat.com/

Thanks
Kevin
