Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB086222AB
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 04:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiKIDha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 22:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiKIDh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 22:37:28 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FB61DF32
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 19:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667965047; x=1699501047;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o8MLbEJNcGu93eEcTNseO0hoF1Npr5Bhyn4KI/R9NRA=;
  b=jyS2BWgdAsKl7bqUCsI1gTRgGyDz2qtloM+zWPtpZE6Pmra4QiHl3jen
   FGrlEEZB12rXZOe4djcg8dfJxtB/hExa00O7S9choSUnIoaBS2n3UR9ho
   14440tF7DEnR/Bwg0aFQk913qkph4Tbdw8TJId2Wx128si/HGdZ72b2FY
   knWRRIfi0QU1xcF7aJMuKriJEElhK3UjZ8zzC5Y4sG2NFgabTuJJLTps7
   mJBr3oHPyZLySezjnRj/9PNaHZrJoqz31XIMULcbphXFFHlXbFhK4JJja
   78rbvKLN5ww7OW9qmP1pgptjhVMX8ZpoYdriSYYB33XaAeEDDc2Ht/2dj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="310874422"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="310874422"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 19:37:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="631105446"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="631105446"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 08 Nov 2022 19:37:27 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 19:37:27 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 19:37:27 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 19:37:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgsoHorI9DtmyLGF7tvgn7CIo6p3CQzpFtKofQXWDPob2/mzTIklv9UxFfNDJjMpsAwtvE5gwB2aRj2OJhIdxJeYzALQmAxKxaI7hpawpYRWvWuvlJcquYQQrooO5jBG+Edk3jFIZnphDzwLRfmc6af/prpcnS6/5nDpZKVMlNCpagEgIrjXE7iuwZr0DjF/KJS6Cd8pUj7zdUz0OUycjAGbgeQar6Goz8TgrB/P4KhG/X7S3GUNnfovE7dQpVNx+Lku2utozHGE+QarxNXprRor3AaR/1MRvkwbnNtWQ8wXdZoZkO7ClgiXtR0vq9/eqVshQDpQ4tCzLaC4vZAtpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o8MLbEJNcGu93eEcTNseO0hoF1Npr5Bhyn4KI/R9NRA=;
 b=Z06aXH1B4BETL9gX3eyNdqdATYIwAH7J0w+U/u8jyNeJMj6x9tRLYgnXJ0trrGa+7gOIVOgKf/pO8Om7aR2DjF2RDsNLO4KRi3sbJsACUy9w9GE04vwCj5MJu08OhsiOsXh5cl8wnu9WdJ/N7j3rO4fBDqoxlfYPt4t1AE9jCpiIVTI+jOgaaScrIeGFdu7SSPFKdQ/yOcAo40awwXxpYegGVrGQRqFemwpMgA4SP9XtOPtt2EkAIllRqm3TB3yZUzxdshUL5XcOwGz2PjD+B9UNfJ36E2paPnzUdwNp25szAn5ZZQo7JofAAWyIOhpZfRAhF8jBRVIWBQ9MDzXZYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY5PR11MB6487.namprd11.prod.outlook.com (2603:10b6:930:31::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Wed, 9 Nov
 2022 03:37:25 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::737e:211a:bb53:4cd7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::737e:211a:bb53:4cd7%4]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 03:37:25 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Anthony DeRossi <ajderossi@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "abhsahu@nvidia.com" <abhsahu@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>
Subject: RE: [PATCH v5 2/3] vfio: Export the device set open count
Thread-Topic: [PATCH v5 2/3] vfio: Export the device set open count
Thread-Index: AQHY8WjxSL0WP46Vq0Ojoqzt9TZtY6419iQg
Date:   Wed, 9 Nov 2022 03:37:25 +0000
Message-ID: <BN9PR11MB5276FBE954A04B3A2970AFE98C3E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221105224458.8180-1-ajderossi@gmail.com>
 <20221105224458.8180-3-ajderossi@gmail.com>
In-Reply-To: <20221105224458.8180-3-ajderossi@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY5PR11MB6487:EE_
x-ms-office365-filtering-correlation-id: 8345aa78-f78f-4e00-adb6-08dac203b82b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nmwddUfjxPv7vHd83m3gpUhjQgMWCs5LTFk4aqgsjhUR5brUHvagDLGVUFnJNEzpHvmNKAO3pn2lZHi+e+7QQJdcddriYaYkeAlxEcO+HBTq1pQ/+nAWD8l4kMJaxkOqLXfMVyx4ZiUnkcsJqLwoI9l3UtI2Ka9AqhxQ+peOICGO18Xq9ZRe8ZLLLzJbqq19P86Y4xcGpqg5rFUZLnyPu+krjlV/tQgJTNoUCIZqpQB3tw9e8HpA7nXdIZGIAnNharotzEM4xm7nOtyD8XJ/mh8ZbgcSivJ3i3BFjrkaHObuhNFW1m4IlxpKbYWMxmmmC7E9b+x4kny0feT7meNRksiKHveJncncfJwb1ynf+JyOIn1VaDmoFz6eUluq4vB4eoLXNXtQSpnLMB9WYDUF+IX4tO1AI3PwuRG2KTXUauJ35aNxSq3/R/rA+FN7fr6/tskwKgtvkDIXvANgoELqP3QX6QfMbXKvSv4dW577IOsdbH2uZ7o+Kq3BDwyXKZUl9KRQg3zErVPNvE4m8pr3ZgfdoSWAK2LgVfmK21CyGu2ik5v2Bai2dMP3aYONtCHc/bwQ2FA3NaypEDyOrskjRhTTKO7YlegMv0KvNuLl+isO0W5rNiu1XKLNJop42UGxlmlbGdOslpU8pDaTCJpwaXNdsp9gBy3AEs8ye6WLeQk24giSAuLfX+q9DY4Vr8469aB70j8jv7MhhXr0qvuqV3IhIWNiVn1r3XP//tIktr6dLur8uGWw9q5gkqdRz4Tx3IEJi1n+6KxhCZvoiC9rxg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(376002)(346002)(39860400002)(451199015)(2906002)(33656002)(110136005)(316002)(76116006)(83380400001)(6506007)(38070700005)(71200400001)(4326008)(41300700001)(478600001)(4744005)(55016003)(64756008)(5660300002)(52536014)(8936002)(66946007)(38100700002)(8676002)(66476007)(66446008)(66556008)(26005)(7696005)(186003)(9686003)(122000001)(54906003)(82960400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aMW5MBMIn4myRQeEj4VfXtiNThPC/+6plBRok6ZDysIKhgx2bgF7y770+qtW?=
 =?us-ascii?Q?/b4gWGKdBsGQQMq/ZAqt9oHHKvVrn9vIyBQliyZnh+O3SHoZCuzmswAY6PvA?=
 =?us-ascii?Q?6tQEHlwiX0NwU9t9AlPfIsq7pVNPy7BwJkNy/bjQGUQg0X9sXAPxTKwwIBFx?=
 =?us-ascii?Q?0RdVg4e7oUuFBuuWs5LkCmoyYvNn6YFz80Z3sevooWJCwGpFbjVWlgp/aj74?=
 =?us-ascii?Q?h4NDxkblCml92JgxyaQXRxsB48KPjRt09fO2Kmk3D1+oWJQrCLre29jy6Tpd?=
 =?us-ascii?Q?5WnWebDWA1ktlYLC9vQKTHfPz+EDv3DtVDKIhAL1XL6xfgPJoOlBwxucvCp7?=
 =?us-ascii?Q?Or4v6By2ZtwK+bU4LqW+P12BEFdV5P+PdsZ5WMx9eGFhh7Ta1rsZKbEsM/9z?=
 =?us-ascii?Q?HoxGd0UBplqFGSQgYarP7SHLajBPUDyf/fUW754JMG7Pz6u3mhqPbez6uCvJ?=
 =?us-ascii?Q?MGJWhCfRmbNY1O5N9cmCxM73D54bGX/Q/AXKl5oZXIPzPv4G/b8MunUHtJKn?=
 =?us-ascii?Q?aFwgVVPD6OYnwWecNelcsRX5qb032mCnY50l/9nQbSCJX87dFGDgxT0VcGKS?=
 =?us-ascii?Q?6jwrGjuMbq9juJDbjyNjDUPV3OrWqBrdCV+IaptS9nJ/k0s5XnACXp6MYvID?=
 =?us-ascii?Q?x3M3UneqmKVjFkBiMer6jeQ1mWHv+XF7iuKnrfoiJg19RyaSUuhJGMgoE43P?=
 =?us-ascii?Q?ePtYiTPaR763KOsrrsCD2VaZe3iUXAaSIieVErKkoL5WS8NC3HiCA4n+BDsx?=
 =?us-ascii?Q?VaD4NFlvil3WLootj9HtHq0VBFUNSOfV/Q1quwHfqraMzxeyOQJAq4dj1h3z?=
 =?us-ascii?Q?eZ1uAEqcgKotNoTrNRshk92QeeIAjmIItuuO4QYNc4ob9ktZaF5YAO5mX8id?=
 =?us-ascii?Q?RlGt227qT0E0qcQhY8tp/aSo5Br9noH8mNePAilwRkdxMI3e3tPgQ+h/CMiH?=
 =?us-ascii?Q?DCgFWGOqLTofe+6ThfQZ8GIhXnoZpPrZS0iGyEK5UIa41NOo1MGH9/LFteLB?=
 =?us-ascii?Q?2j6t7CSBlAZ/MZGYL8nSRvMhkrKrpbiW2sXsS0ITLtylQd2NKJq8QYKN5lIi?=
 =?us-ascii?Q?LhNn/HE4aavtuq5EwedR+xdyW3xy2xPIlRuLmh9z0/eoNCD6L2IuKG5032Ki?=
 =?us-ascii?Q?agrfQpRAWLRBLXf0/sT0Rb3URN6n/0WxLChh5qR8Q4WPFLVQ8WFa6lbQxfuj?=
 =?us-ascii?Q?+1Cmez962EcytOGFxoCfLxid/dh9eEQprkIOTnecWNmafFcC7EqQPofN3d5v?=
 =?us-ascii?Q?ce3ACdyKmDaL30wWx0+BmR59pRl6EDb+duBJ7QmaShqoNAJWohMb+ZFFLKhA?=
 =?us-ascii?Q?K7sFkZS/zoVCeqtZkQ6xUhy+giy3pfkUCxK8tFrTasxbfjYiZHgAZ3k0C9LO?=
 =?us-ascii?Q?jAaHbO9Np58/26tJM9j1GIbbPbwa3/4ay4rITfzeFB0pPXd26txBZUjIqIyR?=
 =?us-ascii?Q?XD/BP1AXqrQChHZIocAZNgu9IT8Gi0Obp5d3PJUwliqJO1Fpe/pLkrUQDg1U?=
 =?us-ascii?Q?iZkXrSh/9gKtow4d5dbBGvB+ndNgN5/5EBl79RxMkTOndypikvqGgO/GDaWd?=
 =?us-ascii?Q?jSl1nvBhJqmGuJk/PdAYZ/586U2ndVECIayMSl/b?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8345aa78-f78f-4e00-adb6-08dac203b82b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 03:37:25.6282
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hrgKecMl5u3buU3ttejAyWd/YjPPz4t35rTyBKnWbtAziWpZ6tAmLxxt9XS/xWZpc0HaojJOad3Bnc1X7Xn0UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6487
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Anthony DeRossi <ajderossi@gmail.com>
> Sent: Sunday, November 6, 2022 6:45 AM
>=20
> The open count of a device set is the sum of the open counts of all
> devices in the set. Drivers can use this value to determine whether
> shared resources are in use without tracking them manually or accessing
> the private open_count in vfio_device.
>=20
> Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>

Apart from remarks from Alex/Jason, good to me:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
