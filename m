Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2427D07C1
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 07:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346637AbjJTFpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 01:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235599AbjJTFpt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 01:45:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C251A4
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 22:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697780747; x=1729316747;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SO31XkeQwU5ykCowOgUNDF1NJPiPPxQdDikX5dgB5OU=;
  b=NA9S5gD/01m3KTKYm8Qjxk8zWxwjUfNH55e0+nKS/a4Xe2Mgur/Zj1Cu
   Wwyazyuvl2bMyKOePC476iRWRw4GynNuQEXSSzQGsfHjyvaY8r2ojBRH+
   G82qJhk/aD3e2kwL69qTXxyqE8jHRs4mE8/xNk4Z8Od7Nx23f+36S0zBl
   W35zOytoCVhZba3ePuP0E9ye83JyNS0AWkFFaGLPrfl5eUDG5ZeG7VAEM
   g0kXVpr8FMLQYAkviV+9YqcIZuILWmEGTQGw0hORly+g6BPLJMAsHDb15
   7OhtGxvqQdc54GZrqVs3QzW5KQI+l2kTUE9ZGxAzOXIY2U05zwj5O2xZj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="371505732"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="371505732"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 22:45:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="757336161"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="757336161"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Oct 2023 22:45:47 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 19 Oct 2023 22:45:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 19 Oct 2023 22:45:47 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 19 Oct 2023 22:45:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mh1em/WbPtRCyl3x/5HeZPKWRWNKDmn2wLmC4B3ArUdy25ydVi+hAbLP+jB21TWutUiEzffa7fv1rDYZBTfOhw3PfL7hG8VfOTg3oCN5AEOjqAlEOyFN0U9qn+7tPLzYCzr0z67vs9+Pskyzd565LLfNOahrdAMkvLkatkDVx1Yb2Fjua+6FoYNM+T5uAaccTqKlJJJaEieJTtBNkPibGipUKrnwbccyYx82N3+8VO3JHcQSENaxV11Ap7QmwPsMp9GceBTM6a+ig8fmb5dLcyNqIXOAGl9kxMkSKGr+CI6dhGht2Pe7uasMgdzD6yBqRhYVHna0shDFZVaXfxxd9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=duPoPwhmbnAOQHDCfVxVGGe28VYowNXrFo/fXkjzOVk=;
 b=byRHCzGTTt9IQpj2rW5rg89orZ3D8+O6iOdtInYp8VhlRpzVLaNb/escOyVomTT8VzGszgRbKG9JPJs/dxV8XhxxmVc7q8jtO9k0j/Q2jgVFwKIyNpIKdVgVq0ogkaSjKYh4tW1ggKDyi1NMrvP5hYSgbL1QoF0SlKtHeLXEGTK3bRSHMKWVLdqJqXRz30g/invapl1rN80Znpjoj7/UQ6uGLsBjxAbs1OwpEoGhQ5g8xKv/gpEvtPQAenHF6yrStUc5Q5lmhtKeIJeu1+e7RHrlrsmGWn94iLWr9b0rBb3JmO16uySQQUOBjW6+4ij9FTJHSG2Jfdclr88U4fFT1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7902.namprd11.prod.outlook.com (2603:10b6:8:f6::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.26; Fri, 20 Oct 2023 05:45:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4%3]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 05:45:44 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Martins, Joao" <joao.m.martins@oracle.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>
Subject: RE: [PATCH v4 01/18] vfio/iova_bitmap: Export more API symbols
Thread-Topic: [PATCH v4 01/18] vfio/iova_bitmap: Export more API symbols
Thread-Index: AQHaAgGbtp/aIBx9h0iJ8q+jUwB+f7BSLTFQ
Date:   Fri, 20 Oct 2023 05:45:43 +0000
Message-ID: <BN9PR11MB52760736BB0BA53BE27BF7B78CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-2-joao.m.martins@oracle.com>
In-Reply-To: <20231018202715.69734-2-joao.m.martins@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7902:EE_
x-ms-office365-filtering-correlation-id: 9eeee4df-4c4a-4b97-c8bc-08dbd12fcd41
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nkqJ0OrkOtcRp/gcIHydCjzpZVRtT9/Hi1WnfiWFwq1NKmsRrTBz3eIxVZvhUv75YLMgloo13VCxyd1TTphL+U4N6hHQLyB5ZAZD8247dRb4XvOMvEl74Psj5GHYn8AaqxtGhwJLp3vjpw+ScDByYiSXojd9A8PNDhpvwj4afTzjdz/fnlmg0IcOp+EEalVdbMLelgi3T9uVtoe0sJZO1ITyZckxQ1B66G7Wblk7SiY8JVBNTiDpo9XAYk5Z6Da29zNXFVcKa1OwA8O9d425VhlkMYofIncTSnlxVN80YxfVK/juDsx1haB7vEBmOySE3eG+v3RT8ZRbtsgEc5NEdsUngfJOqTAMTp7xML/2By1CoBZQcxN8f45spLHC4u0cr0W8KQ7bSSOn63ObRWl6qvooQ+5DType00UbJQ3i+TKK7ikz+fVqGya3cluJBDfShj7K3aSdp1ku8FYQAMPNzry7PuHim+5llYwg3oewteeU7gVWPNCvgE1MAHtKS0GZfzxxZt9intpVEFgRwpNdaiYsG279viDucKA33D3Sd4/AP/oh6YhDoWwzjxKPspUc9gyP5lznWG0U9xL3da+xWAM1SK5KqW+oIBKOGQEvI9IrOr/pLe3GnhR4OVGAuluz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(346002)(396003)(376002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(38070700009)(55016003)(7416002)(4326008)(4744005)(8936002)(8676002)(52536014)(5660300002)(41300700001)(2906002)(26005)(9686003)(6506007)(7696005)(38100700002)(71200400001)(110136005)(86362001)(33656002)(54906003)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(478600001)(82960400001)(316002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Fw5qgGdyRe8ffZwLHg5VLHsqT1/zFiToT7MbgXDf5ZcvcbW49dZ3frMiklO+?=
 =?us-ascii?Q?f75lS3cjm58VZBF9zOONU8Gok6SidCdacB2QqndNXv7EYh/oz9NFbS1ZR/aI?=
 =?us-ascii?Q?cabNUxEXcnq9Osbon/4C1KbMLkC/0QX4n90sLGiMNwxuzc4GMDVT56akYwby?=
 =?us-ascii?Q?L+DqOfq0X8ZqbkkdAsUB7tebKaeFXQNqB0bY4x4SQOCAUcTVKl9zaByonDsY?=
 =?us-ascii?Q?IO+FqtYibaEDx02zMo6OZykvGOr1Z9L4WQN0g7r7VtbgcplCAVHudqJH8wXf?=
 =?us-ascii?Q?yDxA5yWJhDY/UH7STMH23b7C4TCBwUhLHJZqE/bos4YEQ906j/5olSjVZhMg?=
 =?us-ascii?Q?Csa7Vp5pW0pWqGytRhVIBH2Ppq6RK99l3SB0j2ED4jUAAdiwFH5iAPyftA1U?=
 =?us-ascii?Q?CLP+S5Zb+vnRAW+DOXu4QgVUW8dWR7SrX7KaLbNkKwkHy+dVVqglJRFe6G2N?=
 =?us-ascii?Q?rNVg8+o7ZLG/hHsG4hi+BmcJ8sEkDmyfRFxjN+tk+WcNK791BOHGeeZTydEO?=
 =?us-ascii?Q?G3OU0Cmsb1ASC8PFhkuhDV9YIh6yqqTub5p3WQNHp8gNG7juz/w6zuAYwek9?=
 =?us-ascii?Q?RelaUWNOw+BifaXukgFrqc6SLD5WKDUELWD5pilnckyg5XEAiS1rDkpinCqS?=
 =?us-ascii?Q?TQ5VVuMV7es3jQ/eNUYWahk9CIMeQ5vGdVKxJNz6XKjzT92o/L8C6dUdITvi?=
 =?us-ascii?Q?AmbOcAhO/yoTw7FTzwsgH6RQaix42hak2XQO4Gc0v8/Br6dnyFCmncXV1Heq?=
 =?us-ascii?Q?MQd8GrKvQNdOQd8TUWzPRvYW6dZYurZx/tnk/XCjnEvHKWjCytNjFR+QZ2e5?=
 =?us-ascii?Q?ks4HojYG08twWHAz4HIKVWw0RPUQfEszoP2BS0K6U4vC4jvXL9vXY1CxFR4N?=
 =?us-ascii?Q?nS2uXZKVroBNv3diNX/059pmkVVFrCJiHmnOJpnqKJKaGQWnaZJ/9W8YOQ9j?=
 =?us-ascii?Q?kdRh9jzO5NsJp0ElNXR2A95sl7eSA5aa19BUQQ3mgFdTHJe5GI26PNP7u7p+?=
 =?us-ascii?Q?aFFlUxdyW2zjMB57KBE77BooOWG9plnk52bfUfX7gYfqT4/shrAv84uNfqA3?=
 =?us-ascii?Q?be0dAwSP8oIVvz6lE2n6fm+nTvEDgYU+rht3BInOJl7k1k4UYSf+75KvXWGW?=
 =?us-ascii?Q?aZwgmOWfOGFS/IiS91dOL1VT5V6NcT1xeGPboOxPAq+hxuFnonwvc/H4syqb?=
 =?us-ascii?Q?lZ8zPoMnjAQiQ0nFMOTsNZA5a5B2p7XRSxBTIeQubqj7BfKQoeYj1t6ky75r?=
 =?us-ascii?Q?aZIkAZWKreCcpI0JJTpxQIct6Ua2l8LJkIq6RClsq2Sj5kJPcEN1Bl2EhavE?=
 =?us-ascii?Q?GMmjncvTXvfI6nEUKGvDOsPIi1/C07X9A/QM9AnEU9i8VhFPjcfi7olpvXMm?=
 =?us-ascii?Q?P60gusISoSbwXQF3te5doQPP/21/TKF9dPNCLitDCkV7LxE08FCTxEYVm3NP?=
 =?us-ascii?Q?btHoGO5G5k1sAu+YWa4spYwIu239HBoNBjsr0Uir/JM+wYBhoocm3gDtJR7S?=
 =?us-ascii?Q?LXYd410rv1FngQf4i1a3lpC7Mlh4I88OWSTdHyRRgOLGV+5UoX663sUq8jaG?=
 =?us-ascii?Q?s3lQCsPeFNGTB2QENaFRCsadoDvEJoezja3cfZWX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eeee4df-4c4a-4b97-c8bc-08dbd12fcd41
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2023 05:45:44.0230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vC0YGwImFPJ5Ua+5icCz1++ASA8gknfaLSdqSIx6XACX7awOKYfFycFu05PAmWWfhkJ6NUCV3bfPwJsFTeXysw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7902
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Joao Martins <joao.m.martins@oracle.com>
> Sent: Thursday, October 19, 2023 4:27 AM
>=20
> In preparation to move iova_bitmap into iommufd, export the rest of API
> symbols that will be used in what could be used by modules, namely:
>=20
> 	iova_bitmap_alloc
> 	iova_bitmap_free
> 	iova_bitmap_for_each
>=20
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
