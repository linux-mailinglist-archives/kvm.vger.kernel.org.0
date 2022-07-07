Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54155697DB
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 04:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbiGGCSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 22:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiGGCSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 22:18:53 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B258F2CE37;
        Wed,  6 Jul 2022 19:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657160332; x=1688696332;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wRf5HHViihY5OJxA8zOe7qJAlaZwJ8amNpuj1uFi3NM=;
  b=NI5d0E2v3GTbfpKrcWzxosG6CgyoIbFnKm3FFrqEtq076VCQ+DwJ3TgF
   zXj3MGPlmDt2e7hyrjdAm3GiVzE9ZACn1BvTzy3JBsC9k5r3MIU4n66AJ
   5DTr8poklHt4cz+A01QtwASSeHria9Lw76bBB2x3+c7PB0iSYTKZyGLQy
   A5XOwLIGytpQ4drserPNeFQL+CahQo3Szhl4aBpnyKNz3LzC8d2DA9qdj
   BGrzBdARuzl8qcYbcg/275sryBlAayTzfFdan8/aIgd8Ds9GdT3BrTQ+d
   2kdJ1NeN3azawl2KcBkbZWVDjaMXBAUzwgGiB0Z8XXDy6R3L12+E0HWj7
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="347896040"
X-IronPort-AV: E=Sophos;i="5.92,251,1650956400"; 
   d="scan'208";a="347896040"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 19:18:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,251,1650956400"; 
   d="scan'208";a="696340211"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jul 2022 19:18:50 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 6 Jul 2022 19:18:49 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 6 Jul 2022 19:18:49 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 6 Jul 2022 19:18:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPItBu5cfv6xgGkBpyLVKJ4HQhtBH925wS24uEHfm49E8SkCTePg/vZ7gylFweKiJetUlpJTgW5y0jmJBKkVQ/iagTEfD8pzUdfBb8aev7bZQ2BGI6a0MAFZWoLkpYTuuyd7VZyipCp2uF+8tBpk7mF0UL6l71fp41zIzaB6pAfmn0KwHcnXcFIHDyq+13y3EMXxL9xhTtnpK0oq0s4VQWNtpleoRzQcBXZMsqzowZjd0QCgIn4ahMMJDWfAXkMFZ6XX9V6J1tHUVIuk53VKQk1LE4C64C4m7/g7Uu/oBxQ3IoLdL9JyksDak/tzuUxI5hY/+DalzsKg6aNtMgRwjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wRf5HHViihY5OJxA8zOe7qJAlaZwJ8amNpuj1uFi3NM=;
 b=R90G7tXNI/fq3ryGG7bKENOHqe5FQK4BR3uRBweqcVEVFwj7qKM5D/1eV9PdA+NVokBxNOpMjRLnSB07K6Xw8IoGrBxQzrPD4hHS6USs7Uzdh58EUjJyztOiQQFkGfCYhDiRageuHnwiH/O6EwOF1Be3l71g7Xz1GCNaM4ufgvJCIoj1aVxYeZmeGN6wi4ldg319sMKUfH/S6uzN88eOP2pCq05bTVP4s1rLhySwR8HHNtwqiASo1hkk85WFV6PtTaxcqX2oYBX4J0ysJiVvcGr/6jIrdhtIqDrhmZsQDtvakhVWpoydKMFH+iW//bsM9KYOLXIafWSfUNwi0DemTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB5325.namprd11.prod.outlook.com (2603:10b6:5:390::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 7 Jul
 2022 02:18:48 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5395.021; Thu, 7 Jul 2022
 02:18:48 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH 02/15] drm/i915/gvt: simplify vgpu configuration
 management
Thread-Topic: [PATCH 02/15] drm/i915/gvt: simplify vgpu configuration
 management
Thread-Index: AQHYkQv6clwefJwWfEC3io0iEkXc761yLZLg
Date:   Thu, 7 Jul 2022 02:18:48 +0000
Message-ID: <BN9PR11MB527630AA9318183CFF05F9E08C839@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220706074219.3614-1-hch@lst.de>
 <20220706074219.3614-3-hch@lst.de>
In-Reply-To: <20220706074219.3614-3-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52cc841a-8869-4139-9ea8-08da5fbf06e6
x-ms-traffictypediagnostic: DM4PR11MB5325:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JrJgaPRsirdP3aF7p/2ZZbNIC+H1bXpBZyOXGI92c0DSer2mXC0NRGjQ0iyYmjFvcr8Mj9f6l4rR345XpFKUidgDnw8bNtdYt2sexCD7Mq+k2UZ3pL2TXN1vqz8DYFk7URmw3UlOX487tqJ9o/5k0Au96UYtcrUMbp9IQX35cLPBCUV9szgDJnNahCnW76n3K8SIViHjc5UZgMZ8QQLwLeGFAojxCwgEB2q6MN8/pS03C7YfxDC7SBHsnaZGuFGXjK2Uh0YYCNoorAoUM8JzdAXGGsJztv18jc34DiAFjDgldXSvV3SJ7nDuqA8IW/gOMpvqsDAWF4hUNqOwYHFXySGUHVqPvVbTi6m/+SBcYduYldH/LmtS9xXGTy5fF9hZ2ao1hqhcoxvmUCbrJQuJDj6tC7BPx87xbu/SZc7XUU70yxbw+qJT9eE9XIxNSLRtFHoJdDrgCn5atuhLACKtNAxa2Q+cibrcC2QMpZdcHEw9hC0K5TiMg8Bi63cub3tAb7S0Ks5iGvrZdIW3N9/zFdiiMbXkthg2H3XUhPFvG8YPW/LDp1bCmOp4mfL/40dYNl/cjSevaduBbI8dGNaa4QHqfmaI8Ht5oXKH7Y4j6ltLY5K1nWcaeqw8oAsmEI2WHjJrqnS76DZQliv++5DVpljR8LewfBJ5tYJkSsGHLog0eIA6YObcz2k4sPmQ5CcIXHVvGtLQ0+4WO76VD8v8zcd8hJgTEEdb8+aYxbGxOUVXCrqG6USxuVZG5ECvECTuveGYJiKcsQj2TNwkCiX92cSukK4TWsLS8XHXzse7X1yvd3ByjIkwFOBOp+hFPbgWYcmOIVJIpWgTn3vURvEvtA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(346002)(366004)(396003)(136003)(2906002)(55016003)(41300700001)(54906003)(8936002)(38100700002)(316002)(6506007)(7696005)(110136005)(71200400001)(66476007)(33656002)(66446008)(86362001)(478600001)(52536014)(64756008)(186003)(8676002)(26005)(4326008)(38070700005)(921005)(9686003)(122000001)(82960400001)(5660300002)(66556008)(7416002)(66946007)(4744005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WwNko3fFatUePRaERVxb5ysZCKwwb1qCSPGU1q7a07o4WAxprlt3sT2Y4CQ2?=
 =?us-ascii?Q?OGt88MPcY+BpqjgQ98Ykz97QIa9BhtRJMOW6iHhLLAkHa/mkinHe3nN7Sovt?=
 =?us-ascii?Q?sFf+qesotTQ2iAcSZWkEh/3IfRCdyPPtxeKPJvUh0YXskuqIVFQ0tQZQ4n42?=
 =?us-ascii?Q?Q4dAgDCGkhlu6SmsqLpmwziMXc1h7r0VYeTDx9aBgE3ZubM8eyssY1bW9NVJ?=
 =?us-ascii?Q?LPEi8TWxMPFQrsM7oDjREm1Y9t1wICLv9hM4HXeZhtOe+v4QIXU8uUe/e9z9?=
 =?us-ascii?Q?SJOQKASUuTxAjHSs6xzvEql0ZlGL7kHW886/p2y5QVBunbRJzyw25deFlxn7?=
 =?us-ascii?Q?KUno1oWkYNjXbHYnpVcvCN8EP7UJ/GVT2BpM+2wdcTokvZxDUgR74QBrsxfi?=
 =?us-ascii?Q?bv9CZXgXvXTr7aDhd8Td0TQHE/bLNw6KWgDe8kjnQmF2qcPszI6l5TmlWdpR?=
 =?us-ascii?Q?aC6G1/MBRb9DvuNNMuQxduPWFp+7o6g1dKaqiSyb7v2f5gHhj6379j4npuuT?=
 =?us-ascii?Q?AICDvSZLLzKPHTwo2h/fM/maGLLwBIWVnyOSw+D35f+CF0jumdxeTwnt535c?=
 =?us-ascii?Q?UEr/qzIcNPuAp7gyDNNf0MqqIW9GjpMmxOaOf4Y7unU2/6cCX7UHSHijj+2e?=
 =?us-ascii?Q?6bbBHbKey/qmw7tYEE8MuMdXAt/YhJGxKY3sStHzKlmqn9mwUYJrVgNHjxcd?=
 =?us-ascii?Q?MXpfTmpDu4beJFSv8N4T5bSEsQxEr2bQxEjmZ3qPEbZxKOeMOFmHPZBgRDDB?=
 =?us-ascii?Q?/WGiRfQXUabIbVRyCZy840zssKhUx3lwpK4xOwupleOa0bLca5Qy95XHU/ut?=
 =?us-ascii?Q?g4MOw0x4nwaTC5/6+lm47xKQ1FI8ndXmOn5uUJBc+9F+89XTNRG7EGvBEiL7?=
 =?us-ascii?Q?ZMwYohlDSyNXpTIiv3dclJgY0ZRr4YNftcR+yYeZc9j5O5moOXiRQGfwdpku?=
 =?us-ascii?Q?2hzqJA88elPuExs7Dlpj1aUmltY+y9xFgS86UWsfQ84zNg772adIUKdUNtGG?=
 =?us-ascii?Q?Bsl1h0JMzstBmWP829gzV9h9BpWD3y+7VWo0CwTVKKdDm/vXtXxVjsx7iC7l?=
 =?us-ascii?Q?Cd8z7aKrZah3aY31N2xDF0C8fTtw0zAszRzsta42dlKwZRN46Wr944kz0JxX?=
 =?us-ascii?Q?+HCISiZgxeMxj+Fb5ZO+d5GhOdcBF7QNTbVybSKWo/91alUYWGYyvESMoHp9?=
 =?us-ascii?Q?y88pefUofY+FhQCNPPh4ckBXKEcmqzvWgiUy+u+rpfSf41mAqXWTqVFDBTZe?=
 =?us-ascii?Q?MmevPEIoqkw5QtvB41n+spC8ISi3yJGmTZnC+9WJEF/SXjKVBzYjcwhFga1U?=
 =?us-ascii?Q?VinGxIAdFwRnHyBeeUcK6SppfWC62Krw8jYpeiWRJ4QKxFfuVz5WyrEThpKD?=
 =?us-ascii?Q?rLV8//OPCuAa3OXCGv2HXAzNimJM9oLxl/WTajC9gGx0Dc+ZwvN5h8RKIzjx?=
 =?us-ascii?Q?4WgWzbKx01c5Pbj/+JenBDcJQesy/M3RZ/H9/ozfK4wrzLrB6N2aSJg0Lb5Y?=
 =?us-ascii?Q?hThJ2iky+aMO+u1NO+4zAswoLGg+1MnJ4B8Pv1Z3IX9ewEswSNQrDyu5bt/j?=
 =?us-ascii?Q?a7E9ZZCCcHR47Q0NcHNkK/lILc0M1vpFJxPYjGFR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52cc841a-8869-4139-9ea8-08da5fbf06e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 02:18:48.5047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gPtIow/fEjnioR4r+AUV0QKLcmRmNirb2GtEnCqORs5ZhLus12aaV3Ev0JP9VfvyVygPWaym3QiXLXMDoAtyEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5325
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig
> Sent: Wednesday, July 6, 2022 3:42 PM
>=20
> Instead of copying the information from the vgpu_types arrays into each
> intel_vgpu_type structure, just reference this constant information
> with a pointer to the already existing data structure, and pass it into
> the low-level VGPU creation helpers intead of copying the data into yet
> anothe params data structure.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
