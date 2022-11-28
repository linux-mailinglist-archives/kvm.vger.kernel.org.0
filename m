Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBC663A138
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 07:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiK1GbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 01:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiK1GbI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 01:31:08 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEED13FB6
        for <kvm@vger.kernel.org>; Sun, 27 Nov 2022 22:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669617067; x=1701153067;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wUMMqhWlunkoB/FFIxxjDlCYvm/d3lZ5V88C+oMTn6E=;
  b=k0ZRkFI75YRL+2uibnZCtuXiiXmJCpgB66ETqY7WkVtCoPijkeyqhq3b
   s34w3RFc5Nn68Cb0JLBgaY9vBLe09fNkEhZ2qOLuw6AFCaZ8ST69PqRBE
   rVDW0uHE9IZJ1JHKb3c9r7WPScjfGViYlwPtXqAisqwoiYkl7OnLubN0Q
   fkWcqEJREayNeUjcWcBybwdywgQnv1Opu70n0JRKShfQpe+o3GyLdzoad
   5XID4VLjgg3418OV37Gi56AEQtXlr9h72xnF+TH6KsFdtFzlVfTW7V4+j
   VqPLmhXLntspLmUX0SkXSvTku5HlXMKruM5qOyPA9LB+n74qlIAI65Gnl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="379013283"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="379013283"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2022 22:31:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="888297319"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="888297319"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 27 Nov 2022 22:31:06 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 27 Nov 2022 22:31:06 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 27 Nov 2022 22:31:06 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 27 Nov 2022 22:31:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=douaGofjO7ASKLnKf1FVCdKwMrV+1K7rAjQoWAlMXYXOkZrTD8N3SWh//keDHvkSpUwUvg8+rpAnmJpa7enJOwmViAHZM7b0Y4C1V4DAXPU+vz8a30ICagTEqKeYv2cJPzMFHz3oY3ihx7HP9F5ddJdDOcYIHuaE2+QfF+xhEtWQiXorTY0mukA6uxklYfRA1/xrrZw69uFz+sg6hwddaq42ymysu1KFDQ7NBRjOwT63GxtNrdi29Fg0Iv+GWmkrZymRTalRrFbTYXkgYViTDawIg0EN2Ewo1XZld5pDV5AfP2wr4eHIkhCwQkbP0sP6pVbRfNpfNnKbZlP7wKLUqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P82TlauLyxbVjdXLrLXSl6obl3it/v5Q+BLjrvBvXA0=;
 b=K5bYcXUYYW6e9i9U8px2ubXr8pWt+Sb3DECoESkRovdWjNGLZdzW2A2YZFJdVKP37NHCkAxqNCA72clVATgbHN5/DHafG8+gRwygY0VlNIObYNZKSHX+SE8EmIjG2kAdzYRXJlF8tIImHhAeuR6/cCwVwCF6EzJhzw+BzLxft3PDnnbSw0qKzLfW3vwbH+L/NhDbgk0fkv97e2K2S2Q/xr6nUB98Mz6zPSkYkM4JH9bVSlxsUWi+mvT/8dMHPMnpLDlA1djrA9czCbzxA0wSFyJB3uXDIJwyeyxEbEOVWR7T3XPrndffESzi3+YLBOLxAMzfzNFy5C3faOzpDlOQaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA2PR11MB4859.namprd11.prod.outlook.com (2603:10b6:806:f8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 06:31:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde%9]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 06:31:04 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Subject: RE: [iommufd 2/2] vfio/ap: validate iova during dma_unmap and trigger
 irq disable
Thread-Topic: [iommufd 2/2] vfio/ap: validate iova during dma_unmap and
 trigger irq disable
Thread-Index: AQHY/0JNDOImPJXOIkCz+4x7weUmDq5NqDwAgABiZgCABcLDUA==
Date:   Mon, 28 Nov 2022 06:31:04 +0000
Message-ID: <BN9PR11MB5276902DF936A54E52A6EDBF8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
 <20221123134832.429589-3-yi.l.liu@intel.com>
 <BN9PR11MB5276E07F9CB1A006FAC9E4098C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y39qrCtw0d0dfbLt@nvidia.com>
In-Reply-To: <Y39qrCtw0d0dfbLt@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA2PR11MB4859:EE_
x-ms-office365-filtering-correlation-id: 93e6558e-f606-401e-0afd-08dad10a200e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1X7wBLy3K1MK4j7O62W8u+FDZBGfOG/46mEfc9iAvZtvF4g2Rw8HzeBXJCOW6Xp3yTNBxC21zoOPo7lXZAGwZQKTg7TdIbNz2kDQlbgZp+WxlKrjHUScU6Y8UibinbY4s/Evr7HpuPD7AJkJuA+IpBSCsAtwZkWbmoVpyrbAPP7BO8yAjffLgbvf4Fiq1v2iCK6TSV9m6wbTNwlzL0bV630d9FRhP5mvZQbMYAmB9F2+oKOO073dszFBl4N4sSo8H3c3wwh0hu3dxf8j+BTfVHPjBMcDt8TfA65LZE3Jf3ylDhZ9JgcW3aZdbMYE0FbmIh96u85VqbhOYfDNz+a/fluB7KBQabBFw8HtbIUH+G78zR/7B8KRPg5SF2t5TrTavDt2udkg2w0CJetCmlnXHoulTEecJHFctopHrw0/NQjOkqon9CSRJXH6GvHXO8U4pvWPLXLO0BitiWAHw0zffD6/1zEC/fGNfx/HBE/SZMz4QwYvhDC8wX3wm5X1md2Xebdp+Q1zmI/CthUfaQMZo82j0kKs2y4zCLQFXpObCwufY9+2LEPT1fOULneCMV4ru4Z7y6uScW18uvqH/QPm2SsF+WyJtZZYUEOqJ+OfDrKhgwOR+Vr7c05BRDF6HzZu13VX2p65/ieNpU+lr+k6LoO7jkExZnORZBucoYNwDsWDxcrEtMbpY4o3V7KMSYU9V+WFI9pRTF/SQ6yzNLKt0A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(376002)(346002)(136003)(366004)(451199015)(83380400001)(33656002)(86362001)(54906003)(6916009)(9686003)(6506007)(7696005)(71200400001)(55016003)(38070700005)(38100700002)(122000001)(82960400001)(26005)(186003)(5660300002)(8936002)(52536014)(478600001)(8676002)(66446008)(66476007)(66946007)(64756008)(76116006)(66556008)(41300700001)(316002)(4326008)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FlOgZYeBF0PHBsdRxF/AKAILikQBNM3Bm6v7n5kTiYf4Il0nPK7S8o0aVUVS?=
 =?us-ascii?Q?L16PHlWZ125W3jvKM/2raGdKUICPHGxa7Saqpmf5uVaf0ke/lMIvVlxy8E+b?=
 =?us-ascii?Q?h5FahzwWipjtnxHDSOKTck/BQE3J4XtfF3HElH8fbeS0+7PfLKY6bEeMMdTw?=
 =?us-ascii?Q?MWKXjjj1mnO7mOIcVRFFajChcB64UCnkVDQB3ODWmVQVD5PveLlvdOJ1I5n3?=
 =?us-ascii?Q?l1n4CWfBs2NBoOrBcCugT0cUy9cE9sVRKNBrwOdToD9qI0iBX3OUMHgceQ26?=
 =?us-ascii?Q?gKzO5Xz1FsS9a8nHYWNoq/RyN76IQVufbD+C0hKUPq5+v8lS/CT5Bin9meUx?=
 =?us-ascii?Q?oKiU83qBJRosKC+mtH8DPLNOIRZg0vH9fHegiLvljCO52UgQwatH1jy4FJZt?=
 =?us-ascii?Q?RhPkXxbzAUWeKy+swhNMqIJ3B+KT6j1LjX5TGCSK60NuS+yTHkza1S0QEIOL?=
 =?us-ascii?Q?Gmw1fEBWdWtX0GnvjvFqNu79l0w8QBg1eA6S7wdK6OAVzY02akyUbg3NyF6Z?=
 =?us-ascii?Q?bzj01xGHFO91PRQ262dGyghqCGrJ8GCidH5/kB8m0+A0oo3eWC1NoknnIrJo?=
 =?us-ascii?Q?qq39r4Fv//wpwjoPc2PPU4ueKcZRPFc/g4leJvSf0CNJHCHXtif8vGC0gRf/?=
 =?us-ascii?Q?fQ1/CUqs1Tnb+gEZKbYlsDU1PUYqSiRa55FaRXQrXq739OVdwC2hWQxcV8Gu?=
 =?us-ascii?Q?qk43OgRCXXiq1zqDjMqqCPVYn2uPyCPbBf4vhp2xC6G4OK1mSOTi95t/aphi?=
 =?us-ascii?Q?FSw84hBXQUfWMUuv/d9BxmWtpvBzzR/WM/iMym8ofzk3//2mpYwNGv9cptVS?=
 =?us-ascii?Q?52B1sA4K0TO4ccckaFPMs//WboJc3rmwjsUtCeHd+wtKjrvJYoO21q3389tl?=
 =?us-ascii?Q?TLdIYwWqzAhnQJ6SwR5N2vSuAuF6nDO2POAEIgn3fIq/fONswVLAVkvdvc4W?=
 =?us-ascii?Q?mDqqVjFRlqI8VFCSPJ5OzAbNwKQYIVJSdUPA5WimgTM6budowD4mUBa4VQE+?=
 =?us-ascii?Q?+J83o0EV1IMj6YXK9X/1Gac/jXHcjc81AFwLXRbVrPDVMJ8OS2Nii6I2/ThP?=
 =?us-ascii?Q?fE5gelQ63JptSOLM/HPbAY54vZoFt0rDfn50Hx7dL1n4iSA7dJXaa++D3C6L?=
 =?us-ascii?Q?7duhzk02UhKG8EvB+EqfkQOksVdP/o2of6qbA3KKzVSZCU/Cmde7w2w54xQT?=
 =?us-ascii?Q?tmKrKoR7nxftebcSNsJDsOi8oNVH1qTNhUS7xrez5elXXpJP0zWZnljp1gS7?=
 =?us-ascii?Q?PnPBMvcOV776NHw9MCQx/HuznGcT8a7SFfsGjw/ycw5x41g067pFe6an/Fj9?=
 =?us-ascii?Q?g2ZZfZLnebLDThWOX3abTXcHsoP3atqSZozF0z81/t2dbcmoCJXm4QmsShkt?=
 =?us-ascii?Q?NjivRJiG28LU4UIiQencZ1Td+orxDI4MePp3JGwTWxkGWP4ez1U3lRseqIfz?=
 =?us-ascii?Q?ferW90NxFdMI4h3GzbUM1hZRDP+xV8ir5NMazifodV7TR33vnjQrN/npwzwT?=
 =?us-ascii?Q?/kCcG8hn3Qe6Y2WUPZiiPKL3AI36YPM4uMbnHvPDQp53HAsEp7i/kzsUvsvV?=
 =?us-ascii?Q?+XQFmDhKQSP/S2DWWswngUkzONS1H7X+3SKvL3g6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93e6558e-f606-401e-0afd-08dad10a200e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 06:31:04.3391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x/c81FS8esNJV0ABtK8c6xZlgSyRiCHCyqkTkX0XEB6lnNqBgIPtcxFxBQpRYjRFtgze4beAjnc8JpcSX2wcCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4859
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
> Sent: Thursday, November 24, 2022 8:59 PM
>=20
> On Thu, Nov 24, 2022 at 07:08:06AM +0000, Tian, Kevin wrote:
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Wednesday, November 23, 2022 9:49 PM
> > > +static void unmap_iova(struct ap_matrix_mdev *matrix_mdev, u64 iova,
> > > u64 length)
> > > +{
> > > +	struct ap_queue_table *qtable =3D &matrix_mdev->qtable;
> > > +	u64 iova_pfn_end =3D (iova + length - 1) >> PAGE_SHIFT;
> > > +	u64 iova_pfn_start =3D iova >> PAGE_SHIFT;
> > > +	struct vfio_ap_queue *q;
> > > +	int loop_cursor;
> > > +	u64 pfn;
> > > +
> > > +	hash_for_each(qtable->queues, loop_cursor, q, mdev_qnode) {
> > > +		pfn =3D q->saved_iova >> PAGE_SHIFT;
> > > +		if (pfn >=3D iova_pfn_start && pfn <=3D iova_pfn_end) {
> > > +			vfio_ap_irq_disable(q);
> > > +			break;
> >
> > does this need a WARN_ON if the length is more than one page?
>=20
> The iova and length are the range being invalidated, the driver has no
> control over them and length is probably multiple pages.

Yes. I'm misled by the 'break'. Presumably all queues covered by
the unmapped range should have interrupt disabled while above only
disables interrupt for the first covered queue.
