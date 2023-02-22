Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FBE69EF2C
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 08:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjBVHQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 02:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjBVHQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 02:16:32 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95F5366BC;
        Tue, 21 Feb 2023 23:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677050155; x=1708586155;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FVQVy7m5iNhA5fyeIT61Q9KZ0irJmndKTe1Z/dse91Q=;
  b=J3i2CvaDeEoMczt8EoNBvORVXGslDOPqxzDzJD6Y0abZwrltsUyDGZp+
   vWLKzmm5HJpZGG4q7HoxllwTS6ljx0PEsszMniG9+DqGpBGzT/KoAThyf
   8F4rdkdfcyxwwnEG3d05j2tBIqWQ7DILUVx5CpUA8GfsGcfdAJdoYDsVI
   RXe5u4wIDDHy4s08oK+WG647k9dx5Xtmoi3Iiq9ZbDfelcYCMWFO5+oSO
   mdlP1RlckDF9S8Qi1w8hiKsNi3w3srSItwiYKFOZYmxIJ943UL8g4MyfH
   9sT4CTRSqqf1MTrLpcI7A+gi9pAuOJHD+/4noyR5qu3GdSsFM86C22EQF
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="335050786"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="335050786"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 23:15:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="760848009"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="760848009"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Feb 2023 23:15:53 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 23:15:52 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 23:15:52 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 23:15:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ay/OGJRZqjslgaF5Bs2DT5VL/8oWy4g2KpGJjdo22I+nZ4uKMcsybbYCuD/n9pFL2n1cy2j24WoyI2Rqu+bduC7q+AZsd3DYsFwZqwLYsIIHIS9oPjTZrBDnMjpR4arQXh1PeNkZlRNJUgZzEmOCjgDpZ1owasxX97J9AjVWI8wqNutbFp251xfWFeE0tQtz8ZMSqg9RE74k3Jmh6TxeWX6jjq24atrtiVE+42lmlHrvhIR91LuDX/3jM/ItQKyBLTAMu+saFxeqy9eRA3KlltZyozIxQYlTjoZzZhC96AYWe4SvNba5f5Ko3sRXe7GloLNkvsBVrTfCiJxujPcapA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ds/GPdzGOGLBx4CkF5PQuL4kjIJ+6fV0a3r1RYlnI6A=;
 b=ePXs2QRHg/18041Wxpzi8ImVBCGaEPg1dEt/gB46UbxxZaDgKC3tNSJ/txniQWXUPT98RZPQOO+bmBNmnjxLmW4UcYjt82HQg80mgFeWeG1Yuu1fDI6/4BfUwNOixWFcfcz+EyjZ2MBaDUoPuC9LjMkbTczX4kv+RcWqSQrM+Z1ZCjz+uUiwjn7+ujvgxSYlJ7RnU9JjY+LsKftwq1RipRPd14qRW4sWp2pIs0mK+Q5+Ft089DeC7yS4zO9veghEQUZG5GBKR+dPCozcGdXcrrFPPl2XFhSFaLjL5jnXYhkheQabbmHxYSc8ytzzDKQo8EZ8lZdrbHHObCtQ/kig/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by CO1PR11MB4884.namprd11.prod.outlook.com (2603:10b6:303:6c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Wed, 22 Feb
 2023 07:15:43 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f%8]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 07:15:43 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v4 03/19] vfio: Accept vfio device file in the driver
 facing kAPI
Thread-Topic: [PATCH v4 03/19] vfio: Accept vfio device file in the driver
 facing kAPI
Thread-Index: AQHZRadeo5SMFKfVKkC10jMgRO27xq7ajn4g
Date:   Wed, 22 Feb 2023 07:15:43 +0000
Message-ID: <BL1PR11MB52717F02174B24EFE1674B238CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-4-yi.l.liu@intel.com>
In-Reply-To: <20230221034812.138051-4-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|CO1PR11MB4884:EE_
x-ms-office365-filtering-correlation-id: 0d451349-358b-4623-f288-08db14a49c6c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nqHIfNU3cLWNkK5kmH+ROjqHwQINudo2j72ESUI+hNy0UZ1bhfbIeejCWe8hz9fvBpVo503w94/sqrckQFoSwjmcyGScIEpu+NRcqHIIGud+4ku5TLoNr6i0A9kFa8cDjfhgymBUe1kazqZ1zwz9KVYaJVCJB4ziPgG7GLtza/YM4WwvMxEwAXaaCNW589ZRoLMbWXSULwEkQColuBJFmbJlgvT9MdeYKAypi162a+JI7eEGjROBwikK0QCzRSYLuJito7GwubG68mAKtIR4J/dDLBxIUgJUoirDA/BBHzTyaMWfXyFuH1HIrW2IVs8SZfBrm3tN4Ghac9VGsCHRd+SrvbjLw8G3qZwgR7vRJ9poXyq6oMI7Z3zk55jF4Q86iKI/vPvnt2trSi4uc1T+oZI64tw1z21s73qBHAEHW5caiqvdY1eG+ZVmdlox0YvfK4eKmAY7A2hbUON5aK3YoEOqYIsEspXeG/vUWvNFKyiJWP/rFpBAssp//TEUGjfnWLbunps12nfePGO9rM2+ut6uGowNcJhtlcfzW+/B0rWpv64Ko6wBKF5R6pmBVHyUfKVY6WLVBHbc+zzWxW1mG1cempDNoJFI4TFMscJRAwjeWcgDJHDHnLeFcD6SwiGkz+kdrt+L9mPb0KgZEljEVcvy7j95qZNdJfE8BWRhbSMPYoBQ7IMAecZT8jn0cWBhy6xfQsVT43IZYw9dx2YGtg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199018)(41300700001)(52536014)(76116006)(7696005)(9686003)(66476007)(55016003)(66946007)(66446008)(66556008)(8936002)(64756008)(6506007)(8676002)(186003)(26005)(4326008)(33656002)(86362001)(5660300002)(4744005)(7416002)(122000001)(478600001)(54906003)(316002)(71200400001)(82960400001)(110136005)(38100700002)(2906002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ANk7cxQAHWvO+aaEm4k7hK2oRJcEJkd9hib/XM3e7kEnYSqrDFzeYuKZqrAy?=
 =?us-ascii?Q?UzhBPWsGbDhzZCAlAHT59EHPVLtNYZDBLN5ynj/mgG6wsTTIOzex7s8GyBz2?=
 =?us-ascii?Q?JwhDNf5xNYJQlqQ0B3gs8bzCv3RqslwbeVTmZqfShNXjpms4+BkTGuTODHHm?=
 =?us-ascii?Q?dsvQzDxod7ni0bWrVrCOIGTK/mxX0SK9r7zFKjK5NDUCy02Orff08dblJxBP?=
 =?us-ascii?Q?3bEgvuzZzOWg0/wpjW0+A5xt27U4q0jcKtHGNdUF6ke7sl+8pPWRvmkwABk+?=
 =?us-ascii?Q?FEbmwe68fIm7vBQT80qjwoxruEP1sazW6Yrziyd+aX8ZsUNrYaoLksct/cOk?=
 =?us-ascii?Q?F+wlERcp4ma75kkhiFdZdwfucQZEM3Pm7CdRjU+lcaeHnxKoTu3EfEcfD6NA?=
 =?us-ascii?Q?5oF6bkVmu6dFi16DwJWmjDCQEMcF785ZyoFpXv+yHZFebXsggr0EzagHwRZM?=
 =?us-ascii?Q?Ve40vqIuT/9LUYpIlz5jV0uMmMDXR8MXWMSErgqo0OFxNDYt4umu0Oux5Mhw?=
 =?us-ascii?Q?2biePB+8wnWUXVVoKIIvjrTq055NbrXCEKmC6L4zBeuqSoJB9zFqzN/Ft9BR?=
 =?us-ascii?Q?SY3apjGSRxVjuPoyZWa6BH887m58o4Ke6iQNnzLgXwL2hPB3pz4r6NWBmo3d?=
 =?us-ascii?Q?o0rGCTjW6zMG+ilFcnyVnmQr2y4WMD090pGrBTvSAHlAYQt+CV0pILc8Rz9Z?=
 =?us-ascii?Q?qwuTpx2vt7BRvRI5aotRGuf87CNnTJGvAHLuF5/PnmflpROYyNurZxhAdrQ5?=
 =?us-ascii?Q?UnJuLvq+MMOU3V7S5RI5FfDm0CedyhAAqnvWOHhRGcYDo9fK44tMnkdxsjQ7?=
 =?us-ascii?Q?nIfvr6e0Y2VBdnO2vR2T5TaEoWGiHFcqu55k/QrQRLY7YqdCIwTP6gEHr6xm?=
 =?us-ascii?Q?TfYcZ81qcEozxLZHRugnRbxka986dZBve7Ht/5dQ72aRHcoKDXGWGN1FJulW?=
 =?us-ascii?Q?68A7R29IduGJXjsYliHtf6e/d03mmOHnKHyyS1rZ6jHiKEU7DbKw9QIGQRQ6?=
 =?us-ascii?Q?0gIslwAMVhOpgF0q0aIsbpJANR7QDFtElBW+Y6g4BhXdofW44yEYr2YTp6OV?=
 =?us-ascii?Q?BvP6eDH6LJt0YOZJKuOubgNuYA+pwmadFs3kvIs14egSP16ctaj52FKSXdWF?=
 =?us-ascii?Q?TlVjPe7dMU9zAs3tN9e2BljT0QYayaCqWXKg5nuof6FfXAkmZN3YoabFICOZ?=
 =?us-ascii?Q?tn3CRSKh3xzokRd48aQKiDha/KmUJDH3vG7N7lBNwqU9sJm2bcdHoGs082kt?=
 =?us-ascii?Q?lzVI3Xw/XmXTwE6YcK2OK5tyEpQzoCUCZOQjxUL5ASQbQi5aw1VKdiD0cqHN?=
 =?us-ascii?Q?BkwiY3b+hRNnmX5E4Mh6R5ejv3kZNdmvWVe3FjXyLgY599OkEJDB4kigsPJW?=
 =?us-ascii?Q?ul3hWPi83IPFULzXIBdF8gr0oNKbW3aPyDA1HfGNGRwHsQ3fZseuuRksKN9R?=
 =?us-ascii?Q?gdOg5Ez28UDQ+nYXtgFqJk9tzNvr+jxXKaJPmrx6I34+FIdEkFFOJMrkuqm8?=
 =?us-ascii?Q?gn1ZjxS5qbybhOgwFRPMg7C7yQxSLtc4JubGCK70j/+5TLLtKgFpc7625k7W?=
 =?us-ascii?Q?NTc8iYnZWUAIQRgoGu1o51kZMQQ6+Sf5FzJRWRbW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d451349-358b-4623-f288-08db14a49c6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 07:15:43.3997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TGS5aU5fKz5sLYyKsMeXpT5siBV7bzzt7oTxE2lrhNFzW/kiV0PXW0CsmUb+O2f6N+EORKu0ngKM907hJDcoBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4884
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, February 21, 2023 11:48 AM
>=20
>  /**
>   * vfio_file_is_valid - True if the file is valid vfio file
>   * @file: VFIO group file or VFIO device file
>   */
>  bool vfio_file_is_valid(struct file *file)
>  {
> -	return vfio_group_from_file(file);
> +	return vfio_group_from_file(file) ||
> +	       vfio_device_from_file(file);
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_is_valid);

Following previous Alex's comment I'd leave pci hot reset path
to continue calling vfio_file_is_group() at this point so the uAPI
semantics is not changed here before patch 9 comes to properly
handle device fd in that path.
