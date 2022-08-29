Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C025A4073
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 02:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiH2Apz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 20:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiH2Apx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 20:45:53 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F176E11A2D;
        Sun, 28 Aug 2022 17:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661733953; x=1693269953;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=cS0Bih/LnP+jmOda1iElJ9kqC8dKNf8zFzRHkfIj8bQ=;
  b=VhIVmnmx+g21hS6nW56joFxOvfcrWuJ0mCzybYenEENRW04UF1gednh7
   0lGsot/pMFaDv0COnuQsOMzrQm0ga/bdQsfj+YaY7bWGTlpCioreRwuGl
   IG+W0cd2NrS+dP3e75fVQTvtYxJY368gtIiGHkpvNBVjoCxTGjHoevhsL
   PJ0qk9xJa1PMVqXQ/uHnKmSft8uhn6JvZ3lbikVNTuh6rVnqmZV1NVE/e
   MSZm4RHGOXeQqDbwtZBji+IzJvNB6FRTaolyaoSNaBcy7yEbw8wlnvb9A
   ByOsHgJT7VYtrm/VGNEBF1tfUxDjG1cYjIl1psJHN9Cm4II6rnKGKPuhi
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="296055816"
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="296055816"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2022 17:45:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="644244336"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 28 Aug 2022 17:45:52 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 17:45:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 28 Aug 2022 17:45:52 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 28 Aug 2022 17:45:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hI/BrEX0B+PCj75TVfssipzy+c9Nx/luE6UGL8OlhDEi4m71O1aVDXJlY5FB/GgiyAYkiM4YFR+b2f0u6HQNjEcj8XeDQXgEuAhmreb3MVW78dpKiwu8dndq5z6DOntsYf7wSEImx4nQBbDjfyXhZn85MrrIF1aK4/PCiOeHNuNh9ycl6ieCIPCX4OFAZ1cMKC//Hor9i2y+7p24DU1ZlSkb/cUDCkohoeGzQGEMtdcpGwXf3LhZNfxKFMkxz8RxQGG0h928V8oXXpQAdbskW085Oc7eR+k5P4Sape8rjnELgkwUpgD6uUCueGZc7VZmkO+1kpZETz1lMHwMFelg2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cS0Bih/LnP+jmOda1iElJ9kqC8dKNf8zFzRHkfIj8bQ=;
 b=BeFGnFgW11VoniIdA/c/GJ7Dgt+5JPQY8LRnbnihfULSGUbspTjNpAEhZJaishqlCJDrl1vNOIBv40qnuzl9r1FyCNAPzd91nNwSkBFZ9aKxve0x9Y7B1mCeELXhLexFgk3yGV7St6S5vl8UIioeFdYHNIe++T5QUDYYNTfbSHs2mGC0i6UaykhuXtSyweqsXi/14erDTBN+zh0kR2A5d2you0R3oczQCLJc2EU0qDLbioOC+PduDOzjHIeaydQvhIshV+zoHLkLAiifs1RpAZAfjQmawqgGMLX139oGYHRkkdP2DqiK0P8dGiteJhy7BoW9hZt7QfL2i8mFqvvSVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA2PR11MB4875.namprd11.prod.outlook.com (2603:10b6:806:11a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 00:45:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6%4]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 00:45:44 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: RE: [PATCH v2 2/3] vfio/pci: Rename vfio_pci_register_dev_region()
Thread-Topic: [PATCH v2 2/3] vfio/pci: Rename vfio_pci_register_dev_region()
Thread-Index: AQHYuYLaGp98sAyi5kiw/fyt46IJXK3FDkMQ
Date:   Mon, 29 Aug 2022 00:45:43 +0000
Message-ID: <BN9PR11MB52766E47567B02FFE98F72388C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com>
 <2-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com>
In-Reply-To: <2-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db45b416-6afb-45fd-874a-08da8957ce23
x-ms-traffictypediagnostic: SA2PR11MB4875:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FmPcTDYjCDwtSpU4gtFjVdW4pTkLuV1ehwjRV3aunLo2blKtcwuRx0RmnyfqNdkIIkIO0FYrtt92gnBPwU2y1elWO2t4ibHsxQLkT5dgpGjl1hHeu6n2vGxKOjGtrkrVgZwHjsr096raGh1f4gPCnvXwiNWYN9Jj47M7v7Iqp0XAtKndueXmuhx1KzX2VUT8kWCMYAH48cK4qo9ZVuMj4ZZ/ZzvIZ7zdvmIBfBFGkHsEq9hCtkAuu/hAXuMt0KvlC6icM2VB4J2jIk+RL9VNad/TLX+kHWkTKRNO2RSa22kpj8JOSssoQxhQSqmihMmYQF0jdPV9hs9JmxNgo/EMhSAa1S9NLLEaiSHQf3ovLG3V2b9pGGpoz7Gus6jtiZIQlJ+rfyRNAfVyOiQDgNSkSHpl0cmpiPrPc/02dJkUk9aKH6qbu/i1gGvJzbNxADDTl9u1UqCSJDLa9FeFb6ame6dusHUO0OszsRkmfFl+3RWemMVNNnBqiG+/RTlb/s3GIU5JntrQpWZcMerpN++33BG4oVdhAoqdf9P61GAzVhV55T1Y8fI0v61jUj+9BNfdfAU9dajd7sCRnW8ukP0/9ue9ktuYQgqphjdbMqLANPOz/nJd724YWdNyb1mKhmY7atC9n4Gbk4VsiE7k0AcRSqk2QHmzcRby/IJKiWnLdlxZtEWhJ6MQy1WisdNadc204mwoc6xLUKulOm8C4SjsFBsfDORLGBWjlXqR9Q03oWv4LZLFX4UmyLzwGrfCte+u
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(346002)(39860400002)(376002)(396003)(64756008)(66476007)(110136005)(66446008)(52536014)(66556008)(5660300002)(66946007)(8676002)(8936002)(4744005)(33656002)(76116006)(316002)(2906002)(478600001)(41300700001)(6506007)(7696005)(26005)(9686003)(86362001)(71200400001)(38070700005)(82960400001)(55016003)(186003)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?F9kLmzlGwrCMNfzxj6OXSwZyYFP9whDr4vmyqUWX1FMR7YFTi2WtMEhnhqXK?=
 =?us-ascii?Q?w+OJpNzpZVuLj+sQ5YUL9pbFyGCdfGaJqcfzDD8iOegBhY6h+QbK1SL7yiwb?=
 =?us-ascii?Q?UJ1qzq0FwNu/9mCIyT+XvMwmAWbPrhTIvoQmVCYBqOZGTt/6tIyOVQLyRAzA?=
 =?us-ascii?Q?1dLuBevHYDieoBJMlqmQb+tnFq3EIJkYkQ9bAzWvl95N0MJ5DAA2Pd274/Kx?=
 =?us-ascii?Q?DtDrNALxudDKsVsQgxJupWiQOOzPDyX/ne4a5+r+OnXNP4gBglO8a6rvyX5h?=
 =?us-ascii?Q?epdtv/7zRMYRXJmwIGJ4LgtHhNXMHf//76bhbWKX0KUG0gee+yBYFkOt2KAg?=
 =?us-ascii?Q?5BNCIhQdgqX44v0Z+pRNmCOf2B5WO6fe4WpS6s5t1RZUMWuBysTTZzOvu5md?=
 =?us-ascii?Q?4tIV8xXc56EXVNkz9rJQF1RvQy/mphXPsS9lihYWjKtTvOC9HVS5XnZvjwbD?=
 =?us-ascii?Q?j8UF4mR1Scw5FfnofBS69fTHRBgLuXgMk6lG2h3xi5piUB3xOONLvtdUbD0i?=
 =?us-ascii?Q?H6D3bbECYiK33R/LGC0qcc2SJbcIktYyx8PtrghsuphTfVRqIQmSYaPoxle0?=
 =?us-ascii?Q?QOjoZo/DQg5PAevR5vet2aqT4BSf/nM0Ycoq8FhSmdDj1qBbSkIeWYQObkAB?=
 =?us-ascii?Q?gEth6n0m5kymYebS09Lvz46zVDR8mlpS6p50tbYXeEhTc8ger7oymHmEIqbO?=
 =?us-ascii?Q?bgjXZD5NXF30Dgtr8pVVH0DAMuTlq1M8juh7JnZIvPxPxv3kyLoZpZ2OqqO3?=
 =?us-ascii?Q?RkkWjAhSBYTnZKepsAEiEzHHBJdr8iCLa8T2JfDocV3i89XrPPQmX9Tfb/Ug?=
 =?us-ascii?Q?Z4lFqqd+UQASyhJV14ZrIrviQeXyTAd4epqS+xak6EoMzUL/I9aouef7Zzke?=
 =?us-ascii?Q?ILHqBFlMmk2l/5ayHTfD3JxgwsuUNa9BsD00Mj1BRhLYdUXhB0lJf/vO9nK4?=
 =?us-ascii?Q?9mo1/GN+8hr59eebbj/0HDLnf8xjjNNLNJDe7Vuq6TSvoTjpGnwqXAoEnbr6?=
 =?us-ascii?Q?ByhKOMaYm5FsDo+oK8UgXgPch6IdV9waVjkU+TDum/EOSCSYx1UWS4O0tPYE?=
 =?us-ascii?Q?+VMt9QbvRpi3FXgplJ6tSzsHbNvSFmTO5UftEw36w6z3zG/UZfRuwScMldUm?=
 =?us-ascii?Q?yumynCHlu88YGjqLyIMcQbu/NP3R18JavIagWoTsRVcZUj2OIDXNpew9+klX?=
 =?us-ascii?Q?ZH/BE6gZhC9ugaRMhhAyKwdhuzkUMOcPRIHWw8MXTyo2MvqvpJ7PEp7DAmjj?=
 =?us-ascii?Q?EpMZshBcfxXuMAtbg1Kidu0hPGS75ZWqBSEOiQV0w+E1hO6Lqws54vcZQw8m?=
 =?us-ascii?Q?oBZZ/noNFFPy9A0/BuTyWD7ZPnPFgS0s/RQCmQQ1FrCfBSqxun2GC04XFv98?=
 =?us-ascii?Q?FEH44PbpFypv35J8oCSKpbjhueu505lmMJmEbUQ4cH/gvODQfGfva4yt7ISG?=
 =?us-ascii?Q?Fb6b2W1SkAKedq+GE1oO1ka69rHh0xpbQvnQRpJJl+GFElQ7NwYLjKnsoJjb?=
 =?us-ascii?Q?VmQtPRBl4RU2TJz2IrIk76WglihRD7LcG2emaUvfRv+di8axUjAWQD5SMwmn?=
 =?us-ascii?Q?aZC1bDvLjply5SdsgRoujJnYitjsm/O46E2KlPLu?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db45b416-6afb-45fd-874a-08da8957ce23
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 00:45:43.9316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kdvs0SfTTzPCzNchl0UAk0NEkOF6CQeHZwfsuGRp+OjyoiqnP8feZKXdO5nHVwSDCPX4DfLxRWy7utH+4R0+lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4875
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, August 27, 2022 3:34 AM
>=20
> As this is part of the vfio_pci_core component it should be called
> vfio_pci_core_register_dev_region() like everything else exported from
> this module.
>=20
> Suggested-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
