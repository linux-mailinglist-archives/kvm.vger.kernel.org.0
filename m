Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63967AD078
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 08:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbjIYGrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 02:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbjIYGrr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 02:47:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0768A2;
        Sun, 24 Sep 2023 23:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695624460; x=1727160460;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=me/yVjYsiJlJql2Kh4Y/4qeRExx2LF0U4kLF32f6eYw=;
  b=cgkiUky9Tv94ZketXZcSJTt9FzVjjqxOYUxlmkehwlyaKSPonDilRKAg
   /4gdsKyqWl+KzswVL/dVve94jje4vp2FTIEuRATxWt1VAfeOdMt4CWPDA
   JS+hHCs8Z8IuYDW5oIEcG9p5RhSQkiU8veyM39NUBTXpvioBq4HzvDAEN
   r1cHo6lxZxfb7ddgit/36lNETn7MFVznMufy1B3fm943MnxcI6G+amXEw
   A0qa89/s4aOW9jeIdHgHyYyxCe3p/BDqaMB6xnV3f82d48HIIeE02CbMc
   wgtzFQCvQLFHOk0UykByEDctWufkyhcL/y+XmZhi2THl3rhY/N8K72zDB
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="383939757"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="383939757"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2023 23:47:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="921873228"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="921873228"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Sep 2023 23:47:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 24 Sep 2023 23:47:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Sun, 24 Sep 2023 23:47:38 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Sun, 24 Sep 2023 23:47:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yzu22R+IlNdAvDgZCOpvXT9lELpXmZ4Fovi9kykCBL9P5L6cto28xjHWK+TZ3QxNvRzkmoeZd3CWDHIRyPurlJWa9ru/AEoSMXgoQDrYluptbP+MSvf/BknvGKdiT3JodZiEku2AUQo7aEHL9CmG2t2pmGBAcxpZOS/Ew9SA8jIZ7+vMzVk15B3WvlatBC3YpuDy3YgGEJxjueZAwkjOiusmXka/wyyF7tb6kK7dOhyA5KQ2kGqF6tpyWaUMWQsEY1u48b372kV9kRE3ksJrevT27wZJQiXbV9NqtVigjzE/xvJR/C5UNHji+gQPm+QR9+P8Yx3JbQJguJt4katPbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=me/yVjYsiJlJql2Kh4Y/4qeRExx2LF0U4kLF32f6eYw=;
 b=YqH7RuAGqfugPaDAKMNc0zqdsnmaVss+W0+pLcNAvGOGdRryMRUqCYqWtpX9ql4Io4EoD7xq4fm9KxznCvy9rS55Ur/aihi1+WWs6HhG2WlDxPVJ24mimNbKGVOOi5FLENDUgFsDWVbg/FrP13H/OCtOJ/y4b+bqtoNlEc6GeuX0n9hyeamCeG3uzDRXw+kWgP2T/ja56AKc0ArcP6DkBYq5UJavQGyjmIwRD2OeYjX1uNEPtGZVxmwYrghHXT3MHLK+9Q01aGTUwlNHCAhJKXIaUqYx9j38ADaLOtIFHJRPgqDPKkpNZu4EAcAd9SI7UTjU941L+Aia9EHuPkvrqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5556.namprd11.prod.outlook.com (2603:10b6:208:314::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Mon, 25 Sep
 2023 06:47:35 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1bfc:7af0:dc68:839d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1bfc:7af0:dc68:839d%4]) with mapi id 15.20.6813.017; Mon, 25 Sep 2023
 06:47:35 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 07/12] iommu: Merge iommu_fault_event and iopf_fault
Thread-Topic: [PATCH v5 07/12] iommu: Merge iommu_fault_event and iopf_fault
Thread-Index: AQHZ5unwKRre2VYr0Emw/gboMrl9krArKlHg
Date:   Mon, 25 Sep 2023 06:47:35 +0000
Message-ID: <BN9PR11MB527658F9886B8C80B253F5118CFCA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230914085638.17307-1-baolu.lu@linux.intel.com>
 <20230914085638.17307-8-baolu.lu@linux.intel.com>
In-Reply-To: <20230914085638.17307-8-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB5556:EE_
x-ms-office365-filtering-correlation-id: d5faf3c8-929b-437a-67a7-08dbbd934ce7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 23Gh7RfyomN5LhHaMdVcO1mmFk6FVIFVNYq0Xcv4yE4MxCtUrpdjWAV1R124Rz5EHeMdNEkb3aR88OVgXayZbNLFzTqDG4HFLlehhXBRoaSVMF7tqnBbALxO59EAPyrgQ8kEMTL59rup4zGP9M3rDC3DPtgJFaCUgcbfy4RTF9eVtNZvC6H7iWRFqpKlUr5bWpgguTaAolFRGd27aEOWBLTsMaYGWS7m7RqYQas8TN8eba675J4vxVErRuAtUtkDmAbz7/gVq6YgEGZ2JLLoupPuxyOGzY/tutTyz4OsbbQ+quLYsPAHF9nkrSvxMhfCSibHh8IKtHJr9mbCeQ4w/TdUZ85VFrOjBuEQB5Uxz8rQiVqOQEMRf+SdBXAX4tud5DgOEUeQh8/WJlCmdEMhzqeDSmxenQiK7lXZKG7NIQjnc1gDrd7A0DUKyZjsUiY+JXARcSN41HCxsTxpZFuHlxTeBuMvk+UIT2rkStty8epF9nOtNwk9qeY936Ukz1JxxNtPTtHtfhJ+iv/QOMfjjkKqv1NFjnI5JrEc+mR0gN+m1k6R7xM/GwFU8BZXHg3DUQMMWepbanFYQ7AopICg/PvNKd02YP4qrMmN367HU1M2o08O3J2bpk1rOZXFSJPJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(346002)(376002)(136003)(230922051799003)(1800799009)(186009)(451199024)(9686003)(7696005)(6506007)(71200400001)(82960400001)(122000001)(33656002)(86362001)(38100700002)(38070700005)(26005)(55016003)(4744005)(52536014)(2906002)(110136005)(8936002)(8676002)(4326008)(41300700001)(7416002)(66556008)(66446008)(64756008)(54906003)(66946007)(76116006)(316002)(66476007)(5660300002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uRsqOtyw04MxY6u4Gdh/M8nZnMaSwEmJmcZ9PoIKosTB/6wN5hJIilHJw/AI?=
 =?us-ascii?Q?b/8cKB4lXTruuEyw5qfreBVFQgsbfbzEuCr908syPcPU279rGfjvBlmsornB?=
 =?us-ascii?Q?hQnMXVJWgNHsCzQz/hwE+R0TkB3Iq76OzdE7t6xQxiZpkjtD3dyt6UOYbGCP?=
 =?us-ascii?Q?LJUk3d9F+I7ZA6jh9nn8fyClCBYKzv8g0xJAxY1yCHtXdUSZ/2Gw/2gwIx9e?=
 =?us-ascii?Q?XsfolrEYIgGRRszeQTdW6x5C69YlnWQiQQCvK0oiE/gqnW5RpUX9q21/cdUV?=
 =?us-ascii?Q?QqoGwEYHU5uSF45XQIM9SNchY0E+wpqIp2vTXDabVSQvpgcja5M3PoiESsT4?=
 =?us-ascii?Q?XR9QnX3ebyoHQrjFD/lPIoErQfP8JhkvLxwQWjCQjK9oPIXhxJEDFuGWa3YP?=
 =?us-ascii?Q?FcX9u1SPqypfp3ziyGxKVgCc53iqWjLamsO1IT1ErjWJXo0YJvHX0hSyk2Er?=
 =?us-ascii?Q?twVBcApevRJJ2IKkrBAzWSsDs0mE0IznB0UyBJ/IeLUp2C5FJJi/vTB1RRnu?=
 =?us-ascii?Q?Z0jNNsPj8lk5WSer1UK779aM/hQIqqhaO7j19cu0Dnfj5MQsR1VJYCruU9Bp?=
 =?us-ascii?Q?LQWwoQ1czp5CvsEYVGeONQr988ctKdT6A+lfnf6oC/oPE/718gKt/4iJV+H0?=
 =?us-ascii?Q?mYn14A1yhv4YamAqxjC5oY1D207CsIqnMRKdwzg2pF+J3Z2BuGP0qrXfQ9tq?=
 =?us-ascii?Q?mXG5wUDhwNgFAxHvJEjMR3i4T9yUPghBbIRTwh8Arc9TxPT3LgqLn2niCyt9?=
 =?us-ascii?Q?gmwCA1VhbkSr8mjAbZzW0EAMlRWtMB2I3fCfKDwoIH0BItDj96bo5ThYVga4?=
 =?us-ascii?Q?5zy5IFW+KyMdajp3oGGXeuN3mXiLd621bHSdX4xcNBs550C3HwEnLekXEKiK?=
 =?us-ascii?Q?AFfeVwqTuHm+I48NDwCEn2JOzVGdrlCiH15/CoV6gxzMIBkvE1FhjRDlEVVn?=
 =?us-ascii?Q?4mNeRB+FRkLQooTTk2DoHHVIiSKtVsaWzQyzrk8ibv76lk5lJjXYU0eWdurc?=
 =?us-ascii?Q?FKcQaIm0ib0mLxTODgw6OnvbCK3jEsJnBJdHW+mLgMxKm1HkBjcZqW/JWREO?=
 =?us-ascii?Q?Htg0osf8RLay2zQzq4wmZzjMNptChRp4S+RcrYNvxznKpg9E3ldniVero5WE?=
 =?us-ascii?Q?qZs5jJtiC0pJ1fWPTnDQRlxpicIOezzgBJcRix6DTbgJEO0lmH2vsYuEc3ea?=
 =?us-ascii?Q?mh9tTllMBofc9ZRioRBfyB/+VvG7lz7PyJqc2WJ2UegkKuRETMZCp71Sv2He?=
 =?us-ascii?Q?bMsKINFXVZcpkh69muLxi8Tbu5dj52/Sq7b89gEI6CuwSjm/+kY06fp51T/x?=
 =?us-ascii?Q?j1+mj2kPnO4ZZebfw/HEraev1iB/JbfwhAuXws53hJtQNz3dZ6gyDS9/SRS2?=
 =?us-ascii?Q?eCsvt3gjlCeW/E9V9Is7lD8i4aq/V2anYnrT8HqOdXMTM+pntsPThYGnhZSS?=
 =?us-ascii?Q?XUousxv1yGKX5nT8pKB60SZKsD5ZODOlv7SwCQM57W9++n70gVEgkqROZMm7?=
 =?us-ascii?Q?AwbQHfmRzDhpalbnL0Uu0NFbi53cG78WwZfZjl6fqUJL4GYZ5JvdiPURNnb8?=
 =?us-ascii?Q?+wVDxLO44XWwC1wbjlwezFExJ5odNLRY+v41OeVz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5faf3c8-929b-437a-67a7-08dbbd934ce7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2023 06:47:35.0996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IHxUjMWh7eqjVATXAL+f3hYlGCUpzhkn3Dzqtu0M5ob7QEXBClAiSm6wy6N556IM+CU/qAONarMGtQk5p+qG1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5556
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Thursday, September 14, 2023 4:57 PM
>=20
> The iommu_fault_event and iopf_fault data structures store the same
> information about an iopf fault. They are also used in the same way.
> Merge these two data structures into a single one to make the code
> more concise and easier to maintain.
>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
