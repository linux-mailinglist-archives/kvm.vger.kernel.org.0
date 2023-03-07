Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E836AD4C3
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 03:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjCGCgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 21:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjCGCgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 21:36:20 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F376237732;
        Mon,  6 Mar 2023 18:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678156568; x=1709692568;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6yUs+xSEU5oY6HNnvDeeR+kepREMVKGp5+arj+OhuNU=;
  b=B+euCXU4dN9zdYkooVdjBHkxKIouLqVnXfSphv+iQwp37ibtF7tFTNKm
   N/f0wGI1k0AyIOmwjLL17AcexK43U5UwNWswJUIaosi9fqex0IyquyPnf
   0qsuvx/pwGr4kBwulIEJ0cxGcIhbaQql4NXDDXuG3MZ5wVKDESm1EovEz
   cAcSHZUvujpYlirewEIOKV1zVvr5xMWm7SKO/2bNTjN3fK9XJDEflje6X
   g666mVEssHCZyDjMcTstPJPEiZoj59lB42lsbIZO/kGu31lmPz+aDjLwq
   3JPZgyKjWoTgiFCzQ9S6sHYDiKbiA+uyN3zNLi+YpPimbMX6UU+9d4/NG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="398327567"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="398327567"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 18:35:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="922170694"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="922170694"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 06 Mar 2023 18:35:57 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 18:35:57 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 6 Mar 2023 18:35:57 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 6 Mar 2023 18:35:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LkxxPUk8GzsYYwisNXd3z/GVRAfhRmmqOE0Nnfd79Kb2DDut6LFh4FYjAeoRkBvB5zU2NFChD/acj+lvt9HtrBxWBGHGt211vD1x+6qiLQP5+BpGrTyUxox4LGtX8MkWCpaMRCS220vALizk3WLXDiwRXaq0LbtkRtVKvpWSuP8UgM227ka5jyqW/3IDCjixmZ+4KRq+Pc16eip8wBC4rJskOBeYDV79BvIp6Kry4CJmdmEugtIxHMJMgYXBPEFKt14KOs0mQVMsSDJ3nWCx6h+0EDiIdVRcAzAJorvCTGoURQVYM7flj7YaByINPpQrZrrltbqyM5iQk5eY3Zb20A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6yUs+xSEU5oY6HNnvDeeR+kepREMVKGp5+arj+OhuNU=;
 b=PKOC9mRLNTHCPuJzRd0onWdFE9B/fxdK+o5jVtuNZ28uRtqHZSXr1F8LGXDr15haiQ2zu1aL+TAS2XVXQJXKKXebOFtKvqDOwIZsXByUS3yROSRF3qCOGW7KHFJKT68boNlgohCvYNgn6JSbp0GKSoIAUOlEAwZCEQDmVd1yg4w+dW7yQojirnbMntEx2BaaxhMEEpJp8DLKOcFKoE8xkfubpjrL7jIyw+ooOPV/n58F2VcRHvoh3yd9AnNk675LYylriQBRFqZeL36GcF7g/gQiseUBTFGkV88dGBQHWh/Deez1XHyiAGDW0wA4kq2gs39dXECIIkGPZ7WhiTGRrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH8PR11MB6564.namprd11.prod.outlook.com (2603:10b6:510:1c3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Tue, 7 Mar
 2023 02:35:55 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 02:35:55 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZSpxNz0d7VXviIEytrFhyB5GUvK7m/3jggABFoQCAACyCAIAAGw8ggAETHYCAAKz6AIAEeeOAgADd5oCAAABxoA==
Date:   Tue, 7 Mar 2023 02:35:54 +0000
Message-ID: <DS0PR11MB75298A2C01893A38B3289264C3B79@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-10-yi.l.liu@intel.com>
 <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZACX+Np/IY7ygqL5@nvidia.com>
 <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230303095542.2bfce5c2.alex.williamson@redhat.com>
 <ZAXny4NDDq42NUxE@nvidia.com>
 <BN9PR11MB52760ABC93BCE7FB53A131038CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52760ABC93BCE7FB53A131038CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH8PR11MB6564:EE_
x-ms-office365-filtering-correlation-id: 7f104628-310d-4eb2-25a8-08db1eb4acdf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oHTQXKhgOlwEWBTaGatm2oW1Lhy2RjupEzdIeq+6yVkrRozsPapdBKQYbCqnJISKNlPpSR+UvjQQ+y0zUIZOvrQrSNbFVwnNuOJ1SnCYk4vqZopVC2ay2hBhuGJU5jZjRUHy/FzZOAYBm+6Xrsuq/QvAuZ/bImonWKfjegxUe3XjH8DuAiv1UqwLJezS/ml3POZcCO534HcFKQLaAmxmpx8FQjVz7ZB4tCMDxYSH9XoewLgfuQBf9z8LmUhKST0xlEGf+ATY04ng/Bgs0LEeg9Wx5mnNBmkcQblVJZsI6+EB6tz8ktxG9HHfXOHagaOGE/FW2YmqKQ0dYbpV/Dfmf5t3fKh6Wd+PGvoCzVefboGQKWpXc4LYb2aouPYAGJFY9wSFOrQZLnRAA2L8tEXVbs88SDRmYa7eOFSYUW7jAxPFkbSWmHJ1g/iiewcCaHcPoeTQwUAk9g0oHZMYpdpvN+XiL7k/jjX+RQBxDDQupT0wireqL7CxKWkhoPUfxgMfQtVdhIQRxfrrmQ7OGyrJWw0chW7dELirQdcfuKL8xqNz11bkA7+CQVv9vpA0oY3ViHnOl+nW0oxqqWyCskU5+wnGAnL36Sb6/PN52WyhgQbqAoPyYrH/BhGkgZ753CrDw1jyceEtgDpq91K+IxkUv7KQ7LhZY8LVZ27FwXXdKRinotjZZib8wMwisCIKJCf4787b/86Wl49Kt5tAD6o+gipSGsgTjfiqLpQ5DXUBH+ii9XSgG6N5yijgRqbHYcC2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(136003)(376002)(39860400002)(451199018)(33656002)(7696005)(316002)(83380400001)(478600001)(966005)(186003)(52536014)(6506007)(26005)(71200400001)(86362001)(9686003)(8936002)(66446008)(4326008)(76116006)(8676002)(66476007)(64756008)(66556008)(5660300002)(7416002)(2906002)(41300700001)(122000001)(66946007)(38100700002)(110136005)(54906003)(82960400001)(38070700005)(55016003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3FOQXd6WmEvWHNvdGsrbGJ0OVVYVUZIUFBNUjI1UFFhcEJiTnFSaFZSRWVx?=
 =?utf-8?B?TzVwS0pPTXUvSUhyOHJCVGJxYkhhWXY2djl4N1pQRUNRL3FDVVRhN2IrdGNH?=
 =?utf-8?B?UlJoR2RyclVOZ1psN0daMURKRkhCRWNWN3lXUUpsbExyaGsrZ0ExT05TUUlV?=
 =?utf-8?B?QVFjMjg0MkhKUnpZUVl3dnhNbDlSNkJHNVZBVVhTY2JoM3k5ZWZQUW0ra0pS?=
 =?utf-8?B?N2JhRk9rTlh4akp4MkNBa3ZpUUtwZURlNmprYm02RWlKV1kwSGJSL3JHZGMz?=
 =?utf-8?B?Z3ExcWdKVU1MbGJOc1RCVldHSGtDUXFVWjE2YjhxbDd6cXI4dVQ4a2t4bWtJ?=
 =?utf-8?B?RDFYSWNMWWwwdXIvcFIxNWw1OTYzMGRzVUlGangyczB0MmZHb2xvMTJLWFU0?=
 =?utf-8?B?MEx6dVdIQTFqR2Q0TVo4MStCOGZsY0ROODlkaG9rYXRsb09zK1NPY1R5Y1lQ?=
 =?utf-8?B?Tml5SG56YXk3SEM3L1ZGcExSV0V6VUQvMmVVVGQ1WFNnQzY3WW5ZejAwSDFk?=
 =?utf-8?B?QUtKRHpxTFF3SUNuR2xhUElqWTBOVGhZYThGWGV5ZXZVM09jMXpZWWtaRTI2?=
 =?utf-8?B?SmxLc3dqcnBnVnI1L1dkU1Y2T1BzSVl0a0dwK1paaVZldjN0ajVlWVd3UDZM?=
 =?utf-8?B?N1VoUEF2d2cxa3g5WlAxM1pOSnBOSVVYNDNWdFNmbzRpWE5ESE54Y0pIODBv?=
 =?utf-8?B?LzJmNHJTSDgrSFFGN3d2b3lhZU53eFRVRlpuMXp6eUlVd1RZVWF2c1Fsa1RQ?=
 =?utf-8?B?SktzcUlhMnl1UTQzNDRUcFZOemY1dzkxVThPZkFlRk9jWi82ZFNXWi9JSDc3?=
 =?utf-8?B?MmdQYUFVVndsS1k0WEZZbDA1QmI1Y1pIbzhtVEptTWtSTzBPRS9McitsVjVR?=
 =?utf-8?B?dUY5U0t4K3FKUytSam44V1ZIRjdNbFVNaHVQejhGd2NFTG5pOWdxSDM1Z29G?=
 =?utf-8?B?RW15b0Z6L1pYTnVacnp3d1JjYVZLdWZFM2wxNXAyYktHTU5MWEJ4NWtTRDFG?=
 =?utf-8?B?enJpSVU3TjhVQUJJNk1kdS9ZMjVFYlBpdG9RaCt0YjFOZFZqY21ZSm1pRmkv?=
 =?utf-8?B?WnhoVU5UQkJkYlVKcHNRWnpOcEVzUmZ5cVRoTjVZR0tsZ1V4UXp2eHJtOUxF?=
 =?utf-8?B?L0FyY2g0ZmtzL29icEQ4V05ZTmpiYUx5cjBsL1NLM3JVcExKSk51ZUNoN2xR?=
 =?utf-8?B?K0xISGFQRDY1WmRybkpPYkgwaTRQbE9MT1FGN0tXMy91YmZRQVpYUlpDWTZi?=
 =?utf-8?B?M0dZV2NTYnJIMHgrdWdCcmh3NzNQMER4dDJlOEltb3lvalV4SzJTVmNXRDNq?=
 =?utf-8?B?SjJJTWduT2tPdjQ2aXIwUlFqd2s3U0Rzb2d4WVFlWWRlZkxLSHJTWnpOc2Vl?=
 =?utf-8?B?TlFUYWlFeXVaUVJ5V3RBMlRuV2Q5cTlMQTJEYkgwNmdLVk5WMzNDZFFScmJI?=
 =?utf-8?B?SlhZcUdBWEl4UzVGRXNjdVE2K1UyNWdyc25RVit3Q08xSDk2NUtRL0JFdnpC?=
 =?utf-8?B?cWwvUnE5Z2xIOGVwVk5ORjZDVVk4MVNRcUwvM1c0ZkZJeEUzUEkzbFFuY1ds?=
 =?utf-8?B?M3V5bS9Yd0M3NEVSTVhxZGVnN2FMQjh3VHpYQmN5Qi9LUDBSL09Bb0Z2R0Nw?=
 =?utf-8?B?MGFBTDRIWXVPcWc5dk5mSGwvQzNxbUJ1NTd5SWcyVXpDYVY3dmQ4SXhONi8z?=
 =?utf-8?B?MnMwMUpDekNCSmdjbHFVcmhGR0tJUzFJZ25RWkJ0SFFHZnVPdjdGVHpCMFFV?=
 =?utf-8?B?YWxVekZxVDJTVWpoWG5Sek15aDZ1WFJ5MjlTSzZVRzZhRkwyMFFjQWxSWE16?=
 =?utf-8?B?NXRxcExYbU5LSkZlT1liZE1mNUVvNTR4NWNMQTRrQmVCWEJzdTNPZ2dMZDha?=
 =?utf-8?B?ZlN5dHU4RUY0QlIzbXdWZmxwSDJKU2p1MkJQSGR3Zmd6Q3hwc2lpQ3g0d2t4?=
 =?utf-8?B?eFBkQ2JPQ0Z0NFF3N2d4ZW16VVlDRWV5dVYvSTlzSGZIdkR0ZmZJVnJaOGlT?=
 =?utf-8?B?eFU0QUY2c0xpcTVHU3A0S1I2VC9ZSnpXRHFNZlBVbm1PRy8zMFlwMGU0YWRK?=
 =?utf-8?B?eEhXSnoyTXBxcTAwNjZnSGJITmNRTTdwZnlSTnl6N0ZWeDZnMmZnL1NMTDZo?=
 =?utf-8?Q?BaSMlPxRKbltuR0nysHv+slJI?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f104628-310d-4eb2-25a8-08db1eb4acdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2023 02:35:54.6152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ICX8yuywn9bb+SHivz/4tBKU56Hc8Y7AXH60TymJ7X6f7NqKkkMLl8KeOoKd75fP7z5Q6Skhh3+dYd07ijdvmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6564
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IFR1ZXNk
YXksIE1hcmNoIDcsIDIwMjMgMTA6MzEgQU0NCj4gDQo+ID4gRnJvbTogSmFzb24gR3VudGhvcnBl
IDxqZ2dAbnZpZGlhLmNvbT4NCj4gPiBTZW50OiBNb25kYXksIE1hcmNoIDYsIDIwMjMgOToxNyBQ
TQ0KPiA+DQo+ID4gT24gRnJpLCBNYXIgMDMsIDIwMjMgYXQgMDk6NTU6NDJBTSAtMDcwMCwgQWxl
eCBXaWxsaWFtc29uIHdyb3RlOg0KPiA+DQo+ID4gPiBJIGNhbid0IHRoaW5rIG9mIGEgcmVhc29u
IERQREsgY291bGRuJ3QgdXNlIGhvdC1yZXNldC4gIElmIHdlIHdhbnQgdG8NCj4gPiA+IG1ha2Ug
aXQgYSBwb2xpY3ksIGl0IHNob3VsZCBiZSBlbmZvcmNlZCBieSBjb2RlLCBidXQgY3JlYXRpbmcg
dGhhdA0KPiA+ID4gcG9saWN5IGJhc2VkIG9uIGEgZGlmZmljdWx0eSBpbiBzdXBwb3J0aW5nIHRo
YXQgbW9kZSB3aXRoIGlvbW11ZmQgaXNuJ3QNCj4gPiA+IGdyZWF0Lg0KPiA+DQo+ID4gT24gdGhl
IG90aGVyIGhhbmQgYWRkaW5nIGNvZGUgdG8gYWxsb3cgZGV2aWNlIEZEcyBpbiB0aGUgaG90IHJl
c2V0DQo+ID4gcGF0aCB0aGF0IGlzIG5ldmVyIHVzZWQgYW5kIG5ldmVyIHRlc3RlZCBpc24ndCBn
cmVhdCBlaXRoZXIuLg0KPiA+DQo+ID4gaG90LXJlc2V0IGRvZXMgd29yayBmb3IgRFBESywgaXQg
anVzdCBkb2Vzbid0IHdvcmsgaW4gdGhlIGNhc2Ugd2hlcmUNCj4gPiBEUERLIHdvdWxkIGhhdmUg
bWFueSBWRklPIGRldmljZXMgb3BlbiBhbmQgdGhleSBoYXZlIG92ZXJsYXBwaW5nDQo+ID4gZGV2
aWNlIHNldHMuIFdoaWNoLCBhZ2FpbiwgaXMgc29tZXRoaW5nIGl0IGRvZXNuJ3QgZG8uDQo+ID4N
Cj4gPiBJTUhPIHdlIHNob3VsZCBsZWF2ZSBpdCBvdXQgb2YgdGhlIGtlcm5lbCBhbmQgd2FpdCBm
b3IgYSBuby1pb21tdSB1c2VyDQo+ID4gdG8gY29tZSBmb3J3YXJkIHRoYXQgd2FudHMgaG90LXJl
c2V0IG9mIG1hbnkgZGV2aWNlcy4gVGhlbiB3ZSBjYW4gYWRkDQo+ID4gYW5kIHRlc3QgdGhlIGRl
dmljZSBGRCBwYXJ0LiBNb3N0IGxpa2VseSBzdWNoIGEgdGhpbmcgd2lsbCBuZXZlciBjb21lDQo+
ID4gYXQgdGhpcyBwb2ludC4NCj4gPg0KPiANCj4gSSB0aGluayB3ZSBkb24ndCBuZWVkIHRvIGhh
dmUgdGhpcyB0cmFkZW9mZiBpZiBmb2xsb3dpbmcgWWkncyBsYXN0IHByb3Bvc2FsDQo+IHdoaWNo
IHJlcXVpcmVzIGV2ZXJ5IG9wZW5lZCBkZXZpY2UgaW4gdGhlIHNldCB0byBiZSBjb3ZlcmVkIGJ5
IHRoZQ0KPiBkZXZpY2UgZmQgYXJyYXkuIHdpdGggZGV2X3NldC0+bG9jayBoZWxkIGluIHRoZSBy
ZXNldC9vcGVuIHBhdGggdGhpcyBpcw0KPiBhIHNhZmUgbWVhc3VyZSBhbmQgZnVsbHkgY29udGFp
bmVkIGluIHZmaW8tcGNpIHcvbyBuZWVkIG9mIGZ1cnRoZXINCj4gY2hlY2tpbmcgbm9pb21tdSBv
ciBpb21tdWZkLg0KPiANCj4gSW4gdGhlIGVuZCBzYW1lIHJlc2V0IHVBUEkgZXhjZXB0IHRoZSBm
ZCBhcnJheSBjYW4gYmUgZGV2aWNlIGZkIG5vdy4g8J+Yig0KPiANCj4gYnR3IFlpLCBzaW5jZSB0
aGlzIGFsc28gYWZmZWN0cyB0aGUgZ3JvdXAgcGF0aCAodGhvdWdoIHBvc2l0aXZlKSBpdCdzIGNs
ZWFyZXINCj4gdG8gZmlyc3QgYWRkIG9wZW5fY291bnQgY2hlY2sgaW4gZXhpc3RpbmcgZ3JvdXAg
cGF0aCBpbiBhIHNlcGFyYXRlIHBhdGNoDQo+IGFuZCB0aGVuIGFkZCB0aGUgZGV2aWNlIGZkIHN1
cHBvcnQuDQoNClllcy4gSSd2ZSBtYWRlIHRoZW0gaW4gdGhlIGJlbG93IGJyYW5jaC4gSSBwbGFu
IHRvIHNlbmQgdjYgb3V0IHdpdGggdGhlDQppb21tdWZkX2FjY2VzcyBjcmVhdGVkIGluIGJpbmQg
KG5vdCBpbiB0aGUgYmVsb3cgYnJhbmNoIHlldCkuDQoNCmh0dHBzOi8vZ2l0aHViLmNvbS95aWxp
dTE3NjUvaW9tbXVmZC90cmVlL3ZmaW9fZGV2aWNlX2NkZXZfdjYNCg0KdmZpby9wY2k6IEFjY2Vw
dCBkZXZpY2UgZmQgZm9yIFZGSU9fREVWSUNFX1BDSV9IT1RfUkVTRVQNCihodHRwczovL2dpdGh1
Yi5jb20veWlsaXUxNzY1L2lvbW11ZmQvY29tbWl0L2RjZWZiOGNhNWQxMzM4OGFiOWI5ODYyOTky
ZmQ3N2NmZmNiYWRjMzApDQp2ZmlvL3BjaTogT25seSBuZWVkIHRvIGNoZWNrIG9wZW5lZCBkZXZp
Y2VzIGluIHRoZSBkZXZfc2V0IGZvciBob3QgcmVzZXQNCihodHRwczovL2dpdGh1Yi5jb20veWls
aXUxNzY1L2lvbW11ZmQvY29tbWl0L2Y3MjU3ZjJkYjk1OGQ5ZDk2MWE2ZTQ1YWIwZTMwMWVlMDM5
N2EyNDMpDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg==
