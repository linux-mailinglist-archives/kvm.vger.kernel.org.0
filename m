Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE74D5228D3
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 03:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237487AbiEKBRO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 21:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbiEKBRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 21:17:10 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A01220D2
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 18:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652231829; x=1683767829;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/mYCx8UTEbxs35Z+Pv8f61s8YMOcZLYMmzzoYip4sMQ=;
  b=m5/4pcg1oS9NZgpXQtFcScTSt18jcmLlqHC39gnP+RC6vfTqKHkpu9Wd
   nUt4qcsw+JYAYqGnSsQ8KHPg8n9ltPR6W/c+raDYoJKUAUQAUdUiq7DIJ
   lMWXGzUwumBVwHDCSWRcgKUQMxykNPujMSTCaT3LmPmhGLl3e3GgYCL8v
   jKJOwBfzamgxb5etMEUAZilHahZD0wWG6x8ZPgCKzmvaH8vRzo+aFengX
   nrBSgR3SlgeCol3u7lCgaV0MBDO6q8UzsZ2y0Gtr1/TZlLwt5WIrTLMQh
   sXKDQ1FOkOb3hKwyV14Z8R2C4PRag+8ZgV5aFXnWwHlJEUTj5ccfau6I5
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="332583803"
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="332583803"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 18:17:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="571858269"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 10 May 2022 18:17:07 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 10 May 2022 18:17:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 10 May 2022 18:17:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 10 May 2022 18:17:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asovo7UsxJJDjKImPvG+gtPtw5AwxLm4JqVnvH8jZGdVclFJljjERFGtxknq3gQa1y8lsF8xZDLV+REpEL6EcDhgSoZ9UcXQwvVgQGryV3SPwc7aBLDZk77FzX9RYriO3ZabavpezCUPiADsM+yUeht5Qf+vFaJPGz5Q6J5AkJ2ULdhOGXhsJtBeblOwRi7Zw3SjFbVM7RvkwbGnZo7MCDzTYBMwrPgDDq6v2GXzmgZkv6wMWayYNFGm6ozT0DQJm7bewmPvei9PopRrnFIW3vB+RxK3ak24W0Ar8vFyEUMWIShS522/9nYN43PjLFDprWQWl3Ewv7mxxA7iFGI2mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/mYCx8UTEbxs35Z+Pv8f61s8YMOcZLYMmzzoYip4sMQ=;
 b=QsgfTabmdQi6T5Ai4cH4GLJfdPRfV6OzNtj7kTMw66cuImrzoDCggQBY46SD18opQUrBTwyKy6D63HLnE66Gu2/cAocl2T/tJa6vNaUCpu1Hs7fzSsAhYNMey+WcvjyhK3pdTxkhME91Ygh1nUlAC6w6y7IvxpJ9qdqc1+8Ovv8uMiEN55IW9gs6apfJO5gafI3MV/BCH85yfWX9dnRhKxoKRU/KHYBMWFqNZDkrkjIjYQsv1Jq8aBogDILUz21cDqb9dYtJQERqN0Cdy2fUHAXyir55WMvc1LY8t6oNPaU29GyB9wWJpP/xL+mOqkVDAAkndvobg9q2KJ+pHHY+0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH2PR11MB4261.namprd11.prod.outlook.com (2603:10b6:610:39::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Wed, 11 May
 2022 01:17:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 01:17:04 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Martins, Joao" <joao.m.martins@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: RE: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Thread-Topic: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Thread-Index: AQHYW0R/S6mfDid5yEe6M+QKFrUDn60GOWsggAB3owCAACSFgIAI+m3AgACMaACAANzWEIAAjfgAgAWZrqCAALDgAIAA34Jg
Date:   Wed, 11 May 2022 01:17:04 +0000
Message-ID: <BN9PR11MB52769A810D0C684F8F9FA52D8CC89@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <BN9PR11MB5276F104A27ACD5F20BABC7F8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f5d1a20c-df6e-36b9-c336-dc0d06af67f3@oracle.com>
 <20220429123841.GV8364@nvidia.com>
 <BN9PR11MB5276DFBF612789265199200C8CC29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220505140736.GQ49344@nvidia.com>
 <BN9PR11MB5276EACB65E108ECD4E206A38CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220506114608.GZ49344@nvidia.com>
 <BN9PR11MB5276AE3C44453F889B100D448CC99@BN9PR11MB5276.namprd11.prod.outlook.com>
 <c08528c7-a20a-0c38-0e7f-f51b8fade84f@oracle.com>
In-Reply-To: <c08528c7-a20a-0c38-0e7f-f51b8fade84f@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e99d87c-e5aa-4d4f-a635-08da32ebf57d
x-ms-traffictypediagnostic: CH2PR11MB4261:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <CH2PR11MB4261596C2955FA8EA8FECEB38CC89@CH2PR11MB4261.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a8IE+ZRZaoOR0hzgkf/ZHQkj/tfaqYiPnyo6dlOZ44uH7UdUEwZjMMzfPP2bEwsC7sSC+YZ3oFXyuVYtmCRLaNJgkcD6OOEof7a3ZmM0QB9YaAlkpWlFV5Jl6cPHXJfJf9pHG6AZaNRBaAl1QB48Ut6SEDYJzIWVEN6WzqRTdtaElLaWMlN4WolSNP3f657StQg09lCJksbtaPtR1OtcDFZQTA8EuJxRLVmTaahsQEXVy7rQjiJ2M4ZZkVKbeE0v5+rQTrRkI3P+QDCVBHWn8xiR159YwiQXmCg7zv6dpYVWG30atDFBuN/3fq0Y4JQKheVyx9ZoZM8auh0yELAuMzxRiwLJiPG225MqDueqKp+tvFzkhYpqxLY5xHOZ9LzAydrVDygxbfQq6EfsKkAY40+RDIhR2Tpg0wfdaca3vDpJwnjo5UsRkXXsKa79aPjUTIJSpobB7L2mVPQ3+vw4bain0pQ209Fs2Hl2PmrXVhTiZ4z0XunT19kpHqP3u0f5zJFWSYzv01sv9y+RrybT1fLXT27sJi0NctoUc2csc/bCjHjAxoBCASpezg6VFebQghKYQdQMaEx3P3kGbXZ9+uBLwtzjFPpO+aLxjwg2swaFFs2swps8KIqpwpsRInGVVZTtqWV0Gau9bZZd5j18Wtib8DgSwIiYVCskvq/P7g11SAcEY52Bye4fiEYCaV6lDX0jpBw2BoYvQdBWsxsAknhymIWTuptRaWkGXMb2UKw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7696005)(38100700002)(86362001)(53546011)(71200400001)(38070700005)(6506007)(508600001)(83380400001)(8936002)(82960400001)(122000001)(26005)(186003)(9686003)(55016003)(33656002)(5660300002)(52536014)(7416002)(54906003)(110136005)(2906002)(316002)(8676002)(76116006)(66476007)(66556008)(66946007)(64756008)(66446008)(4326008)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VktSWXh3SHdrYnMrb1JXeUIrV3RkK2EveGxaa21lMUlNRC91cnNVMUo1N1I3?=
 =?utf-8?B?QVRVNkN2Tk5DS1JWSXEzRHk0MU5ZbDhuK2kyRTR0dDN6R3NUcjROdk9Ea2I0?=
 =?utf-8?B?K2d3clhlc3AvY2hXQTFKSks1RmFtTStpMjFYeExuV1E4cXVPelFsMFF6TXox?=
 =?utf-8?B?RjBwbDBzK1dwbWtGODVKdEZYQVhBTUVEdmlKQlJLTEEwYmIyQ3h5dGJjUHMy?=
 =?utf-8?B?NW1lNXpiRG9PeVk3UDZaaXdvNEszMHprRzE3RnVQS3ppQlNKR0pJM0ZTOTNx?=
 =?utf-8?B?VytrclYzRFhsMlBubUJiYVdqallFemRzajRYcjhKejY1U2RIYWIrSW9mODgr?=
 =?utf-8?B?cU9yVVIxdlo2OW9tRThTSGhYb3VWRU1XdEhUZmlXSHVPcmtrU0V3eGovbFEz?=
 =?utf-8?B?RHcrQ21reWlKcS81alNSVmNOM096YmxUQzkxSzcrYlVGNkFja2l3aXJ4YzhP?=
 =?utf-8?B?OG5iWWNVdFoyeTlSTUpyVVNiVC9OUXBaQ2U1NkdCYjV2eDM1RXJjTWRyTUly?=
 =?utf-8?B?QmVxd3V1LzFtdm9vMTdMbUlNbERTRDZmbUhuK0lxeGUzc3dmQTN5Smh1UEJI?=
 =?utf-8?B?bENmeTRkQkJYTEdURzIyQXl6aWk2eXRGb1UrUHN2bGJNeFh3RWdnSTRaM3lv?=
 =?utf-8?B?TXB3WTY4Z1hKbTRLWGtpSERzbWloaHp1Zm9DTkI3cVI1UzQ1WklhRlhSL3dJ?=
 =?utf-8?B?SWF4ZnBLNUdJOVMxNUJ2aGhJK3NUL1d6L21WUk5hR3J0OGM3RXBRY2xFZG1Z?=
 =?utf-8?B?bUtKSURXUjUzdVJzK01XUDBVdEYzU3lEL1Qxa1dxWjMrZjYyV0UySFh0Sk9n?=
 =?utf-8?B?UGNwVTdZc29rSU5mYlFhd29QYWxKS1lDVkVqNFh0RDBiSTROTzBnbHIrNGhy?=
 =?utf-8?B?MVlXR0NKek1XdTRpVDFvdDd3THliUnl6YzZvZ01YM0tjNUQ3K1QxWWNqSGp5?=
 =?utf-8?B?MG1wSTVoOGhEb3h6aUZIb2YwV2Frc2hwZTFVNUNmeHd6TVNvKzN4VWlXeHVQ?=
 =?utf-8?B?KzBLZ3BHMHptMG8xZk83UVdNNUhXdUdYUVBvRjhPNm5wb21XcnFjMzJ4NGp2?=
 =?utf-8?B?bFFtS1ZPVDR3YW9QTVQ3b3NUb0RQN0NrcVozWEVFQ242OFFjYnhlZEZrNnV6?=
 =?utf-8?B?RjNMaFBZQnZjUlZhdkxWNWE0RlI3aTIxY2pMQ2RBSDZkYndQbjRsVTBtM1Bx?=
 =?utf-8?B?cE9qRkNTTGFSQW8wY1N6cEFjcHZqU3BLU1FCZWc1TUFqUFN0QktnWjdmVmZx?=
 =?utf-8?B?T0c2Y3VTM2U1K3dFaFBFQjlLZnBOTjdXRkVYNTR3MXEvenZSQlYrWkQvYmo4?=
 =?utf-8?B?Nno1aFh0RXNxdGs2YUw0RlJ4UHZSWjJRZmltUjdCVGxzWXM5UnhTRG9hYk5H?=
 =?utf-8?B?WWRydzhiYldHK3QzZGJMdTY4Uk9sM2hsLytDZ1JhUXB6Z0tnR09XeERNdTBh?=
 =?utf-8?B?RW9pMlBGSTNEYlVBWTRXQTM3U3NkVmg3ZG5WNC9ySjhiay8raVNPT3g5Qm1z?=
 =?utf-8?B?dTdNSXcwS29Lc3h4TEhHWTJZaVpiWVdOMTVuOU94MTdjeGFXblRpekREY3d1?=
 =?utf-8?B?RlRuRVlCdDIzc2Jib3QvNkZWSVdZV2FrQy8zQm91OTU2MHdLZ1N5OUJHV0pV?=
 =?utf-8?B?VWptVVdOa3FmRTFNR3l6aC9QSk5PMnh4ck5VRWxNRmwxcm56ZkpsdkN3cVdu?=
 =?utf-8?B?ZXR5NHdDV0pkWXF6MkdFYjlUYzFLZnZaeE1TT1htTVJ5N2Q4SDNES0t5bGRL?=
 =?utf-8?B?S2Z0YUpZb2hvZGtmR2YvSkdZc01PSTlTWGE1Sm8vM3liTFloQ1pSQmNKc0NR?=
 =?utf-8?B?emVKSjFmWHRiZVhTVG96bGdkazFmUXZkMmw5cGJCUGVHUGZYUEdONnJoR0gx?=
 =?utf-8?B?MU45T3ByZDdNeEVrL1NzWDRIU0pWbEhHY2RqeFFSMUR2YU00QTVIUkRLczdS?=
 =?utf-8?B?TEJCV205Y0lsWGlCUjN4NWJrVVluUEcvMi9EMkEwWVBKVjN6SGZnWG8yZDVN?=
 =?utf-8?B?U3F6c1I2TmYzVEIyNXozWU84UlpRbm9EQmtHZUM1ci8vSzY4YldLMGhhMWI5?=
 =?utf-8?B?TkdHYTJqZ0puRjFpVHZCZlAxTkIyZk9WQk5Lc1RhdHhVdmRHN2lvOExNTzJz?=
 =?utf-8?B?VTB6NndxblFCNG9VZmpzV092VGExd3cxdXdtclRFL2Z4TG5jMHZTVEpMaW1r?=
 =?utf-8?B?OG9XWmZBSzYva2ZrMDgraWRvSjZrWlVsRjJ2cmdjWkROZ3RzTng2Y1FlOVVl?=
 =?utf-8?B?Vlp6ZzBEcm82dnFHWmFZZHRxTyt4WHFaTkduSkpLaWtqTTd0Y1RXL0ttR1Bi?=
 =?utf-8?B?TkJUa3lFQTArRzN2Q3V5dmRSdXRRYTc4Y2hsOWVvNmVWLzJlYXJiZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e99d87c-e5aa-4d4f-a635-08da32ebf57d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 01:17:04.3077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FkSZ8lx5sCO7zwWFyNR7T21QhRrLmO/zPrIuW/eWCLKkljSSdiKctLbxx4qHQi/DMnfjc/ZP1HgkCAhDKoUCrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4261
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKb2FvIE1hcnRpbnMgPGpvYW8ubS5tYXJ0aW5zQG9yYWNsZS5jb20+DQo+IFNlbnQ6
IFR1ZXNkYXksIE1heSAxMCwgMjAyMiA3OjUxIFBNDQo+IA0KPiBPbiA1LzEwLzIyIDAyOjM4LCBU
aWFuLCBLZXZpbiB3cm90ZToNCj4gPj4gRnJvbTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbnZpZGlh
LmNvbT4NCj4gPj4gU2VudDogRnJpZGF5LCBNYXkgNiwgMjAyMiA3OjQ2IFBNDQo+ID4+DQo+ID4+
IE9uIEZyaSwgTWF5IDA2LCAyMDIyIGF0IDAzOjUxOjQwQU0gKzAwMDAsIFRpYW4sIEtldmluIHdy
b3RlOg0KPiA+Pj4+IEZyb206IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+DQo+ID4+
Pj4gU2VudDogVGh1cnNkYXksIE1heSA1LCAyMDIyIDEwOjA4IFBNDQo+ID4+Pj4NCj4gPj4+PiBP
biBUaHUsIE1heSAwNSwgMjAyMiBhdCAwNzo0MDozN0FNICswMDAwLCBUaWFuLCBLZXZpbiB3cm90
ZToNCj4gPj4+Pg0KPiA+Pj4+PiBJbiBjb25jZXB0IHRoaXMgaXMgYW4gaW9tbXUgcHJvcGVydHkg
aW5zdGVhZCBvZiBhIGRvbWFpbiBwcm9wZXJ0eS4NCj4gPj4+Pg0KPiA+Pj4+IE5vdCByZWFsbHks
IGRvbWFpbnMgc2hvdWxkbid0IGJlIGNoYW5naW5nIGJlaGF2aW9ycyBvbmNlIHRoZXkgYXJlDQo+
ID4+Pj4gY3JlYXRlZC4gSWYgYSBkb21haW4gc3VwcG9ydHMgZGlydHkgdHJhY2tpbmcgYW5kIEkg
YXR0YWNoIGEgbmV3IGRldmljZQ0KPiA+Pj4+IHRoZW4gaXQgc3RpbGwgbXVzdCBzdXBwb3J0IGRp
cnR5IHRyYWNraW5nLg0KPiA+Pj4NCj4gPj4+IFRoYXQgc29ydCBvZiBzdWdnZXN0cyB0aGF0IHVz
ZXJzcGFjZSBzaG91bGQgc3BlY2lmeSB3aGV0aGVyIGEgZG9tYWluDQo+ID4+PiBzdXBwb3J0cyBk
aXJ0eSB0cmFja2luZyB3aGVuIGl0J3MgY3JlYXRlZC4gQnV0IGhvdyBkb2VzIHVzZXJzcGFjZQ0K
PiA+Pj4ga25vdyB0aGF0IGl0IHNob3VsZCBjcmVhdGUgdGhlIGRvbWFpbiBpbiB0aGlzIHdheSBp
biB0aGUgZmlyc3QgcGxhY2U/DQo+ID4+PiBsaXZlIG1pZ3JhdGlvbiBpcyB0cmlnZ2VyZWQgb24g
ZGVtYW5kIGFuZCBpdCBtYXkgbm90IGhhcHBlbiBpbiB0aGUNCj4gPj4+IGxpZmV0aW1lIG9mIGEg
Vk0uDQo+ID4+DQo+ID4+IFRoZSBiZXN0IHlvdSBjb3VsZCBkbyBpcyB0byBsb29rIGF0IHRoZSBk
ZXZpY2VzIGJlaW5nIHBsdWdnZWQgaW4gYXQgVk0NCj4gPj4gc3RhcnR1cCwgYW5kIGlmIHRoZXkg
YWxsIHN1cHBvcnQgbGl2ZSBtaWdyYXRpb24gdGhlbiByZXF1ZXN0IGRpcnR5DQo+ID4+IHRyYWNr
aW5nLCBvdGhlcndpc2UgZG9uJ3QuDQo+ID4NCj4gPiBZZXMsIHRoaXMgaXMgaG93IGEgZGV2aWNl
IGNhcGFiaWxpdHkgY2FuIGhlbHAuDQo+ID4NCj4gPj4NCj4gPj4gSG93ZXZlciwgdHQgY29zdHMg
bm90aGluZyB0byBoYXZlIGRpcnR5IHRyYWNraW5nIGFzIGxvbmcgYXMgYWxsIGlvbW11cw0KPiA+
PiBzdXBwb3J0IGl0IGluIHRoZSBzeXN0ZW0gLSB3aGljaCBzZWVtcyB0byBiZSB0aGUgbm9ybWFs
IGNhc2UgdG9kYXkuDQo+ID4+DQo+ID4+IFdlIHNob3VsZCBqdXN0IGFsd2F5cyB0dXJuIGl0IG9u
IGF0IHRoaXMgcG9pbnQuDQo+ID4NCj4gPiBUaGVuIHN0aWxsIG5lZWQgYSB3YXkgdG8gcmVwb3J0
ICIgYWxsIGlvbW11cyBzdXBwb3J0IGl0IGluIHRoZSBzeXN0ZW0iDQo+ID4gdG8gdXNlcnNwYWNl
IHNpbmNlIG1hbnkgb2xkIHN5c3RlbXMgZG9uJ3Qgc3VwcG9ydCBpdCBhdCBhbGwuIElmIHdlIGFs
bA0KPiA+IGFncmVlIHRoYXQgYSBkZXZpY2UgY2FwYWJpbGl0eSBmbGFnIHdvdWxkIGJlIGhlbHBm
dWwgb24gdGhpcyBmcm9udCAobGlrZQ0KPiA+IHlvdSBhbHNvIHNhaWQgYmVsb3cpLCBwcm9iYWJs
eSBjYW4gc3RhcnQgYnVpbGRpbmcgdGhlIGluaXRpYWwgc2tlbGV0b24NCj4gPiB3aXRoIHRoYXQg
aW4gbWluZD8NCj4gPg0KPiANCj4gVGhpcyB3b3VsZCBjYXB0dXJlIGRldmljZS1zcGVjaWZpYyBh
bmQgbWF5YmUgaW9tbXUtaW5zdGFuY2UgZmVhdHVyZXMsIGJ1dA0KPiB0aGVyZSdzIHNvbWUgdGlu
eSBiaXQgb2RkIHNlbWFudGljIGhlcmUuIFRoZXJlJ3Mgbm90aGluZyB0aGF0DQo+IGRlcGVuZHMg
b24gdGhlIGRldmljZSB0byBzdXBwb3J0IGFueSBvZiB0aGlzLCBidXQgcmF0aGVyIHRoZSBJT01N
VSBpbnN0YW5jZQ0KPiB0aGF0IHNpdHMNCj4gYmVsb3cgdGhlIGRldmljZSB3aGljaCBpcyBpbmRl
cGVuZGVudCBvZiBkZXZpY2Utb3duIGNhcGFiaWxpdGllcyBlLmcuIFBSSSBvbg0KPiB0aGUgb3Ro
ZXINCj4gaGFuZCB3b3VsZCBiZSBhIHBlcmZlY3QgZml0IGZvciBhIGRldmljZSBjYXBhYmlsaXR5
ICg/KSwgYnV0IGRpcnR5IHRyYWNraW5nDQo+IGNvbnZleWluZyBvdmVyIGEgZGV2aWNlIGNhcGFi
aWxpdHkgd291bGQgYmUgYSBjb252ZW5pZW5jZSByYXRoZXIgdGhhbiBhbg0KPiBleGFjdA0KPiBo
dyByZXByZXNlbnRhdGlvbi4NCg0KaXQgaXMgc29ydCBvZiBnZXR0aW5nIGNlcnRhaW4gaW9tbXUg
Y2FwYWJpbGl0eSBmb3IgYSBnaXZlbiBkZXZpY2UsIGFzIGhvdw0KdGhlIGlvbW11IGtBUEkgaXMg
bW92aW5nIHRvd2FyZC4NCg0KPiANCj4gVGhpbmtpbmcgb3V0IGxvdWQgaWYgd2UgYXJlIGdvaW5n
IGFzIGEgZGV2aWNlL2lvbW11IGNhcGFiaWxpdHkgW3RvIHNlZSBpZiB0aGlzDQo+IG1hdGNoZXMN
Cj4gd2hhdCBwZW9wbGUgaGF2ZSBvciBub3QgaW4gbWluZF06IHdlIHdvdWxkIGFkZCBkaXJ0eS10
cmFja2luZyBmZWF0dXJlIGJpdCB2aWENCj4gdGhlIGV4aXN0ZW50DQo+IGtBUEkgZm9yIGlvbW11
IGRldmljZSBmZWF0dXJlcyAoZS5nLiBJT01NVV9ERVZfRkVBVF9BRCkgYW5kIG9uDQo+IGlvbW11
ZmQgd2Ugd291bGQgbWF5YmUgYWRkDQo+IGFuIElPTU1VRkRfQ01EX0RFVl9HRVRfSU9NTVVfRkVB
VFVSRVMgaW9jdGwgd2hpY2ggd291bGQgaGF2ZSBhbg0KPiB1NjQgZGV2X2lkIGFzIGlucHV0IChm
cm9tDQo+IHRoZSByZXR1cm5lZCB2ZmlvLXBjaSBCSU5EX0lPTU1VRkQgQG91dF9kZXZfaWQpIGFu
ZCB1NjQgZmVhdHVyZXMgYXMgYW4NCj4gb3V0cHV0IGJpdG1hcCBvZg0KPiBzeW50aGV0aWMgZmVh
dHVyZSBiaXRzLCBoYXZpbmcgSU9NTVVGRF9GRUFUVVJFX0FEIHRoZSBvbmx5IG9uZSB3ZSBxdWVy
eQ0KPiAoYW5kDQo+IElPTU1VRkRfRkVBVFVSRV97U1ZBLElPUEZ9IGFzIHBvdGVudGlhbGx5IGZ1
dHVyZSBjYW5kaWRhdGVzKS4gUWVtdQ0KPiB3b3VsZCB0aGVuIGF0IHN0YXJ0IG9mDQo+IGRheSB3
b3VsZCBjaGVjayBpZiAvYWxsIGRldmljZXMvIHN1cHBvcnQgaXQgYW5kIGl0IHdvdWxkIHRoZW4g
c3RpbGwgZG8gdGhlIGJsaW5kDQo+IHNldA0KPiB0cmFja2luZywgYnV0IGJhaWwgb3V0IHByZWVt
cHRpdmVseSBpZiBhbnkgb2YgZGV2aWNlLWlvbW11IGRvbid0IHN1cHBvcnQNCj4gZGlydHktdHJh
Y2tpbmcuIEkNCj4gZG9uJ3QgdGhpbmsgd2UgaGF2ZSBhbnkgY2FzZSB0b2RheSBmb3IgaGF2aW5n
IHRvIGRlYWwgd2l0aCBkaWZmZXJlbnQgSU9NTVUNCj4gaW5zdGFuY2VzIHRoYXQNCj4gaGF2ZSBk
aWZmZXJlbnQgZmVhdHVyZXMuDQoNClRoaXMgaGV0ZXJvZ2VuZWl0eSBhbHJlYWR5IGV4aXN0cyB0
b2RheS4gT24gSW50ZWwgcGxhdGZvcm0gbm90IGFsbCBJT01NVXMNCnN1cHBvcnQgZm9yY2Ugc25v
b3BpbmcuIEkgYmVsaWV2ZSBBUk0gaGFzIHNpbWlsYXIgc2l0dWF0aW9uIHdoaWNoIGlzIHdoeQ0K
Um9iaW4gaXMgcmVmYWN0b3JpbmcgYnVzLW9yaWVudGVkIGlvbW11X2NhcGFibGUoKSBldGMuIHRv
IGRldmljZS1vcmllbnRlZC4NCg0KSSdtIG5vdCBhd2FyZSBvZiBzdWNoIGhldGVyb2dlbmVpdHkg
cGFydGljdWxhcmx5IGZvciBkaXJ0eSB0cmFja2luZyB0b2RheS4gQnV0DQp3aG8ga25vd3MgaXQg
d29uJ3QgaGFwcGVuIGluIHRoZSBmdXR1cmU/IEkganVzdCBmZWVsIHRoYXQgYWxpZ25pbmcgaW9t
bXVmZA0KdUFQSSB0byBpb21tdSBrQVBJIGZvciBjYXBhYmlsaXR5IHJlcG9ydGluZyBtaWdodCBi
ZSBtb3JlIGZ1dHVyZSBwcm9vZiBoZXJlLg0KDQo+IA0KPiBFaXRoZXIgdGhhdCBvciBhcyBkaXNj
dXNzZWQgaW4gdGhlIGJlZ2lubmluZyBwZXJoYXBzIGFkZCBhbiBpb21tdWZkIChvcg0KPiBpb21t
dWZkIGh3cHQgb25lKQ0KPiBpb2N0bCAgY2FsbCAoZS5nLklPTU1VRkRfQ01EX0NBUCkgdmlhIGEg
aW5wdXQgdmFsdWUgKGUuZy4gc3Vib3ANCj4gSU9NTVVfRkVBVFVSRVMpIHdoaWNoDQo+IHdvdWxk
IGdpdmVzIHVzIGEgc3RydWN0dXJlIG9mIHRoaW5ncyAoZS5nLiBmb3IgdGhlIElPTU1VX0ZFQVRV
UkVTIHN1Ym9wDQo+IHRoZSBjb21tb24NCj4gZmVhdHVyZXNldCBiaXRtYXAgaW4gYWxsIGlvbW11
IGluc3RhbmNlcykuIFRoaXMgd291bGQgZ2l2ZSB0aGUgJ2FsbCBpb21tdXMNCj4gc3VwcG9ydCBp
dCBpbg0KPiB0aGUgc3lzdGVtJy4gQWxiZWl0IHRoZSBkZXZpY2Ugb25lIG1pZ2h0IGhhdmUgbW9y
ZSBjb25jcmV0ZSBsb25nZXZpdHkgaWYNCj4gdGhlcmUncyBmdXJ0aGVyDQo+IHBsYW5zIGFzaWRl
IGZyb20gZGlydHkgdHJhY2tpbmcuDQo+IA0KPiA+Pg0KPiA+Pj4gYW5kIGlmIHRoZSB1c2VyIGFs
d2F5cyBjcmVhdGVzIGRvbWFpbiB0byBhbGxvdyBkaXJ0eSB0cmFja2luZyBieSBkZWZhdWx0LA0K
PiA+Pj4gaG93IGRvZXMgaXQga25vdyBhIGZhaWxlZCBhdHRhY2ggaXMgZHVlIHRvIG1pc3Npbmcg
ZGlydHkgdHJhY2tpbmcgc3VwcG9ydA0KPiA+Pj4gYnkgdGhlIElPTU1VIGFuZCB0aGVuIGNyZWF0
ZXMgYW5vdGhlciBkb21haW4gd2hpY2ggZGlzYWJsZXMgZGlydHkNCj4gPj4+IHRyYWNraW5nIGFu
ZCByZXRyeS1hdHRhY2ggYWdhaW4/DQo+ID4+DQo+ID4+IFRoZSBhdXRvbWF0aWMgbG9naWMgaXMg
Y29tcGxpY2F0ZWQgZm9yIHN1cmUsIGlmIHlvdSBoYWQgYSBkZXZpY2UgZmxhZw0KPiA+PiBpdCB3
b3VsZCBoYXZlIHRvIGZpZ3VyZSBpdCBvdXQgdGhhdCB3YXkNCj4gPj4NCj4gPg0KPiA+IFllcy4g
VGhhdCBpcyB0aGUgbW9kZWwgaW4gbXkgbWluZC4NCj4gPg0KPiA+IFRoYW5rcw0KPiA+IEtldmlu
DQo=
