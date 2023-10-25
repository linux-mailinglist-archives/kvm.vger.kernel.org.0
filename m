Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B9C7D6534
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 10:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbjJYIe1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 04:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbjJYIeZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 04:34:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BD2123
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 01:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698222864; x=1729758864;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Uq11bmcThq1XyWLosARadt0UYzcf5971MX5I9zGRyG8=;
  b=kKquQarZ91JgAWTtF2uQzrp6hGYdbpBZYUcNLi4rRgrTHEYnFh2Sioud
   LRrQk3oSYi5UVBIfFcuvBDuGqxYiUqcmcmkcOdmXnNPNclzp2xZJSiuVu
   ztT1ufA2aUp1QXh4WixN99zHeVBjp1lWySdVdLSOKfMI0hqaP49qO3A+w
   NgQHW7RAUs/KLQQPv2CPl7o8lX9Kmg0GVbiKcqtImBT5AxGiXI4X3mRea
   qkdngCfzZ/qUxboXjy3a9ulsEyGXto5Mr8t7DcaNpU5L2irPe7jaH88Ju
   Zi+qs7s+u6CQbB+oJIPPPLYj+4xoKGrj+E2I76XsHCyZThB/N8ffM1B92
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="8820783"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="8820783"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 01:34:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="762380948"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="762380948"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Oct 2023 01:34:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 25 Oct 2023 01:34:19 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 25 Oct 2023 01:34:19 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 25 Oct 2023 01:34:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ge3IK7GmQqHmrzHDZf2PK8+71SeQ80m4eLZZ8PMfWv2AD78xwe0yOi5b/B3Mw/6hFFvNlOibIdCR7SmgX1P5qb0oVUeGrjU2ovV7Evu8QGPgRrkYL6kRoHkkyWv2CtPfPaHK09L5xSOQcaUfhxVsfhaXtx0ftJVDMWZZEaXOF1Eu7MEnxZ3GvpokgPiXtKenydU5T+v/PDMVbNGbt3RdRpfy6rKw81gzxOka/Lh7iO8IDf3BLbxIyYQsj9FDSfkPl8mtzR5KHo7f/TmVng96tmiKeXgH5cEX/mle41ukjzdnptsNwBCaYuMcTToJqI9EREhdEg4dUDCZepDG67CPyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uq11bmcThq1XyWLosARadt0UYzcf5971MX5I9zGRyG8=;
 b=TlKrnJKeVSeGZfJojcs/OY7zR/elbXHOm+6JOduImMZndF3sxj5nCQ0zgLDcwb1hgRJxC0Nxd08vJsqRK7jvy1rmkEJsrq6IaNsMPmuXFvt7aeMNhJsCvmLpB7pwOE/sUdqAlIjsSTOe7SOzq5EXbmON4qnMGUjv21NXk/FvboBSqNRUAw5Y+nbsD7/obw1es4kp4rh+3McoTg6V9wQcrfpDP61hIi/615qfH7sKM6UVlXDCc1hYfItLKsxG2oZ71UfH2ap1WOVB1cSexrMr5Ppyd/NbzY6Y6F/xNxBfh+le4CtsMQZEsR0bvpkN8cOw7dnGuBbMOhzO5HTjN6z3CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB6446.namprd11.prod.outlook.com (2603:10b6:8:c5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.31; Wed, 25 Oct
 2023 08:34:15 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.6907.032; Wed, 25 Oct 2023
 08:34:15 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Yishai Hadas <yishaih@nvidia.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "parav@nvidia.com" <parav@nvidia.com>,
        "feliu@nvidia.com" <feliu@nvidia.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V1 vfio 0/9] Introduce a vfio driver over virtio devices
Thread-Topic: [PATCH V1 vfio 0/9] Introduce a vfio driver over virtio devices
Thread-Index: AQHaAP/aqeMydLXUyEuBP7gjjoDG97BVfz6AgAILRoCAAAKsgIACq3uQ
Date:   Wed, 25 Oct 2023 08:34:15 +0000
Message-ID: <BN9PR11MB5276EEC8D9ED00AE97E515B08CDEA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <6e2c79c2-5d1d-3f3b-163b-29403c669049@nvidia.com>
 <20231023093323.2a20b67c.alex.williamson@redhat.com>
 <20231023154257.GZ3952@nvidia.com>
In-Reply-To: <20231023154257.GZ3952@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB6446:EE_
x-ms-office365-filtering-correlation-id: c89fc008-b13b-4232-fd11-08dbd5352c45
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qDFhPnwVVMEW8+/guE2OHq+2mH/RAvN/HXA+mreSJjkfXbmokPPvtSe8zeTZf8d6+1Kivkq784C3C8wx2bg2HiO8ar0seLG3fxoLByZJka1ZG8GKvHZZOVNgvrmXFz8+rGZNTyqizgMIcEHfBCxVSZqbJpCJV8FKIyFcruIQaN6TpkKLecrIH2Z5/875FA3ToSNZmFNvITvUSn9rSMkehTtnZcDaLp/s/GVCh1KwCGuS4lHBW5G6I9IlfMqnWnGdvzBZ4sSJJdFltvrhGDrJxfMKtg3dSrtIA9EZJwYjWzIKEXzhdvw6KbC2+8/JDZw/N5OcijtdocDcMoBQUEROh9KwZPqDWV+EbBYhCQPWzXNvZpJMcJYMrfSGNTV3qvILszlEvUcxJBo+FuoalSjtBG2C0wFKAH9ZZ7Fwc3ydJmLq2TrdWSJ2pfpL6Cefd9LMssrXyrMG2/ak2nmRc+JsofeMen6vgh3T093gC5oA8NgCVyMMM55Bp+YHCkHctyNNtCEUBn3pyaxMd7v7JyxtOdBilYv9WmxdfU//Fy/NQbplk/7D1Mm4vThDyqYCbIEfnj5akL8aMeHXvHd9th0SMDtfWEplOLyTx7Cgwex0AKjii7gS1PFqQXwLnmLSt9QA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(136003)(376002)(346002)(396003)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(55016003)(66476007)(316002)(86362001)(2906002)(38100700002)(122000001)(110136005)(66446008)(76116006)(66946007)(66556008)(7696005)(71200400001)(478600001)(6506007)(82960400001)(9686003)(54906003)(4326008)(52536014)(7416002)(5660300002)(33656002)(41300700001)(64756008)(8676002)(8936002)(26005)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O6mnftOhJwnUtyG/0i2dY5yIcz3PFZIjdec/0pmhUriXbw7+5HvKTB91xXnG?=
 =?us-ascii?Q?wZzVYBThsiT8Jnz6bwBlywtTVpHIdyKo7BWqtKfLXVmnv0GuqJEZaINRxSeW?=
 =?us-ascii?Q?HFIhHu4f50cYwd9KmVU2MkiD5ZeHtZAOjU065RBgBC45ld7i8tf5KJFRXmqU?=
 =?us-ascii?Q?SvipcU91TxS4zft69EXB1d6AnB0K9xIceOtuCJn4JmfHZWr72ZxHDA7T6JNk?=
 =?us-ascii?Q?0ZxoUsAQ3yP3jAZGFYMASIj6V7hew/2VnbPhAV6bhYu0f6krstPINnFdDPHb?=
 =?us-ascii?Q?sWRrwNYXYMiHQ8DNPxMLwSzi4Y+9XMdLU0PCQYMyqHz/7g/AizRFWVnQdy0p?=
 =?us-ascii?Q?eKuNNI4znAjL59gOgFK/WOaAvrktQgNmWqFNzBLnOLkxew2IKLPdiH+Zk5Es?=
 =?us-ascii?Q?Xpa7Gcvfu9p63iIggHULAYc50rAb5B19S0hcEH4AQpvwHZD96iYVKRFke+74?=
 =?us-ascii?Q?VpdIz0WoereXvvNI3YhAY7jFQXWEU4v1gXH7yHRBVJDgG3Z2/9XU1hbOqvdi?=
 =?us-ascii?Q?0T12a2z7GFsR3mZ8gon+aCSvqq4zUx8UMt1D9G7UCkVOrif7uf3VwGpUwqTT?=
 =?us-ascii?Q?+Ievkxx3QvjzkRRnbuNyKAoFQDq/1gcveOlJsKDBY2YTNN09iCFDuPGNK6a7?=
 =?us-ascii?Q?Bj9vwRZTvVd+hfpy6JqXPs/5d+TA6fk+0IceUONui8X0FzAyU4czwHcyjAj9?=
 =?us-ascii?Q?sfIw/Lk9qZOGk2Lkifh3eIHoTuUGersxtdz7qK0hkDQSgNS8nkBx1ysMXGwK?=
 =?us-ascii?Q?g9RW0YR8wbxSTaozpLjA7fs+k+8xoDLQCYXp4+MwFedTdCLBxDBLmFKAlKWU?=
 =?us-ascii?Q?nxqeVlYbQWmNloYddUBc8eEKznuZgnmMVjxw6sieiT5XVrSb4BliJ2GamGm7?=
 =?us-ascii?Q?R/9DUfSFC6QhKAYgrkLGZ7K2KvtV3EfEq1IOarRvrU5npm8kOlxNqtNC3l8j?=
 =?us-ascii?Q?SD0p1Mx3BGeslFpmaOtw9UZ/lGr5aNJSqBia5cQ2kUTMVfpP2uREh18Vb/TV?=
 =?us-ascii?Q?EgOEFGDQjx0uc5C479SNC/QPCtv9YiX8V2EH/JA56tQ9eXvFXay8PsTl66OC?=
 =?us-ascii?Q?NBY5qyZfHPTgaQWKDfyG9/T8b9CsBJlxMgnI+5b2vNaf/BQ25q9yJK0PFRn4?=
 =?us-ascii?Q?4LSisjyxAfBMp9iNS4MOlM33HR9cs5e48Np6BtSOs1l2ExBPDcP+rpPHDKSq?=
 =?us-ascii?Q?gRdSd8WvSBrWb78MGBXLB0NJIBZmG0HkDdL3yW23PxbfWama4sZJ6bX2+q6s?=
 =?us-ascii?Q?i6jM+C3TinldRxBX3ZGOD6FB6Xa05wCpFy8qWFWt4SJU9vUnwHS1/flACbl0?=
 =?us-ascii?Q?LC/Ff4M0i9kMXrfEJkwqYC/ZRNlyTxaAho/WXTbpCognCLoZx+BxrMXoBfB1?=
 =?us-ascii?Q?WXBV1pCuFuF3oalnVtikAgrJDCdQ13EA4fYMLFTDvbQL3DquxxbCMgZTtn32?=
 =?us-ascii?Q?J8BTBBK7PNAoR526MYC9WRL9Vu40OZURJLHsJc2wzDvouT2Po84u3dd4pKvT?=
 =?us-ascii?Q?hGs4ceNR6HYAC0nynTx4spXV+r1v+6ZT33EKTFptzTw9bR5JVv8rT4ki9Sw/?=
 =?us-ascii?Q?PmMCgsG7q81pCzf1mfiRW80sUlv5RxIzbc9Gp/qM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c89fc008-b13b-4232-fd11-08dbd5352c45
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2023 08:34:15.5225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lJvS8yWJBfMkIGmbHXz+7Duk70rhucoIf+9M4XmN8HfwhMa/SsTYugnswvDpYHiWT952l1FGkAdg0C9ZugjC+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6446
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, October 23, 2023 11:43 PM
>=20
> On Mon, Oct 23, 2023 at 09:33:23AM -0600, Alex Williamson wrote:
>=20
> > > Alex,
> > > Are you fine to leave the provisioning of the VF including the contro=
l
> > > of its transitional capability in the device hands as was suggested b=
y
> > > Jason ?
> >
> > If this is the standard we're going to follow, ie. profiling of a
> > device is expected to occur prior to the probe of the vfio-pci variant
> > driver, then we should get the out-of-tree NVIDIA vGPU driver on board
> > with this too.
>=20
> Those GPU drivers are using mdev not vfio-pci..
>=20
> mdev doesn't have a way in its uapi to configure the mdev before it is
> created.
>=20
> I'm hopeful that the SIOV work will develop something better because
> we clearly need it for the general use cases of SIOV beyond VFIO.
>=20

The internal idxd driver version which I looked at last time leaves
provisioning via idxd's own config interface. sure let's brainstorm
what'd be (if possible) a general provisioning framework after it's
sent out for review.
