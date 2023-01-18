Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD37D671767
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 10:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjARJW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 04:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjARJVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 04:21:15 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D6E5141B
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 00:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674031365; x=1705567365;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Q5jVG4TLZK0/Pk0PHKhq5eDwyi/ePUfR18NG4Sk8bKY=;
  b=NU009fIUx2K2GB9yCo4xz6g41pEywqV3oP+tiQA2uMgder7icCQ0bulZ
   KxDTh/VIFIAPZKQHpkhdvupeeFCEkBJ52ZFwyLl9LBz3oJZnxtc8zTS/n
   uClYo871huv5yeMmxX3xV6ukTLHEb1YQnBAAra+9oeqe0BGZb1MEUwt7+
   l2mG2wDlFfkurtNPWXzEbPBujvR8IvgYGZnyL5UiWT4grACnAvY1sJJYK
   wqjhMw200D2yuHYRgg0h+oZnfAgQ0xys/mhizShZRaEEoMW5HBfDTDhTc
   yXL3deFmNqG6NM0hF17Z9hsj8G9qeNhv8B+aqKQPk/+HsjVc6c7/oh6X6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="352179428"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="352179428"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 00:42:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="748381905"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="748381905"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Jan 2023 00:42:37 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 00:42:37 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 00:42:37 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 00:42:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbMNrovUAI/drbt2TMR+8hhpXFBeeQRXZOWBF7kSZ7UbpzIOaC5FGsNR1XP94u7DFa0uFYuHB8FaA8WOYv4D84kgQt+lMCTnaLf6JwZh3u7YNqBtjrlgVZU8I8+OhQIDlaG56YDnVBMIk0g5Yf1vn5uOnqCSyLSij+wikI+cO2AEc5EabePd5rnEPBxUhCloVi6ql28DH6xFbhDhGzF+OJ5UA98ach5rBZ8fPgE67m1RNHw+fnQ5muA2+6GNaU0wCzin91cTr3LKpUm1K5pV6UUDraSGQg9I14V0yTianZTBJJo0AmCIrGw7SN9QUpxWgnj7Iy2qI/TDnS0+luyTZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WM3H+YJTiRpagBOc56bvzE+KEoBaO6pprid3cUlmBIg=;
 b=LwyIZyfLSdBtrrmdbz2EZWv2y7/q0sELRBgOH6KpA3Zzr7IlNHObav7RxkOgv7jsoJDX3C23q4d96YEK9AeFobRInRDeLlsow+bXI7DmOn8zeC4aiAh4kXPJR0p1ZGIqY0XcFs1Dc2M5bkyK5ZybiP0cInFEtsdIBkmKUS5u+BNxz+ILlBIBHjsDUfb+BGlCA22n8VZII7Ehr0f9nHQwND1PklXdqdZJ3xhfXd0xuURQ0mAo09We7bZ52CYwesfhhucLbG3QyZKbd0el4U8s3P1M8nodIYBE3irNWXseW7ocJe20bnQayiAIj5BZsAeVsaZ5k2yPG2gc6PQPsGbnAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB6051.namprd11.prod.outlook.com (2603:10b6:208:393::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Wed, 18 Jan
 2023 08:42:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 08:42:30 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 02/13] vfio: Refine vfio file kAPIs
Thread-Topic: [PATCH 02/13] vfio: Refine vfio file kAPIs
Thread-Index: AQHZKnqVcuDbjk5LK02ROYyu+2x7K66j263A
Date:   Wed, 18 Jan 2023 08:42:30 +0000
Message-ID: <BN9PR11MB5276A97ADCD38313882F1E788CC79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-3-yi.l.liu@intel.com>
In-Reply-To: <20230117134942.101112-3-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB6051:EE_
x-ms-office365-filtering-correlation-id: d7f07fb8-8ce5-4608-6e99-08daf92fef81
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZM9B/p61u4wy+0V1mlvpaqNYHWj1XxGwQ49vXe8MDmVENkxg65vWs3TJ3jBIflblG7HVG0DmAw1o05ipi2z80mxRWCrcIQmdtSAoAmUPZLsEsv7PpdpSbCCPvnMXlsYhyCZq8cuiE58nWmyQR7AiSTAOm0YNaVioqh9nEeygE1XE3EXRsZgabMCB5t6wV0o0axNYei/ZKlTxj3XfR0Lsm0fDyZ5HBINwhDIN9DGI5OmwcLqj+VsSbZeyMyBh9vBEMxqYqVua7MJvIz/bO9dYCT5fNrEpH0bDHZM9H2IdHoNJfYKVXAvxAMDClKf4EHDbap0IlksHhDamFDTVnD0oKMMUTtbM0KuoNqKHv1lDe3plyeSgY6N+5rWCZTYCHZls9VzytZsGlKdXdha8PWyBTN0KB+B/1PuvmslYJNZBbQp5vBGA4qsHR++zAKiZJsE/Q+mux1IGK7A3F0p+FlPtdBXf3yGu7BIaui0IBb03+zYyUVoPdN4sIL9gaABBUnnOsrzYc900iocstlaylvoDSecmo24nMK1KAm9FlbPYZ/0Jxp9I6hNErgql6xWBWvf4Xz0mZAAQ/v+Qk/WL+t9X+Vrvo4zrNPncR1CpX/4/mHxH7rQo21CW1IkdXOFKk6OYk538gOSNILtAHQ6PSOkXUVGB2wqKRqXh5mQq6mhwTR4HDcEBGll+6R5TDwPG+8EjAkPC1nlaiWmTySbu1MxkcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199015)(55016003)(122000001)(86362001)(33656002)(82960400001)(38070700005)(38100700002)(316002)(76116006)(54906003)(66446008)(8676002)(66946007)(110136005)(66476007)(41300700001)(64756008)(4326008)(66556008)(8936002)(4744005)(5660300002)(7416002)(6506007)(9686003)(186003)(26005)(2906002)(52536014)(478600001)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DJ1N8uF6++ikIb6beohSNuLbOtZ44HPuKQth0oEhn47z5bk0zUa2V71/aOUN?=
 =?us-ascii?Q?ibA5INuEpNNTwMSUfRazxa5Gab4YlZBrGQ+wVw290L7/bS2ZU8qgLzZsdV6w?=
 =?us-ascii?Q?7cSJpVomIWfB8axClWPSh4x5C3Q3o3KJX0kPx58BP12wxzM6lWTTWCN8GBpB?=
 =?us-ascii?Q?UHboh3WNjJNCjwZl4817rXYhqVNFa37X5HB5g5lagG6jOFAv7d//QISJxzwV?=
 =?us-ascii?Q?9dW2yuWwmiK4/U4NBM3SqwpMeA7C2e+IG5fgCz73fhaBBfzjCKMN4aojKLyE?=
 =?us-ascii?Q?Hg43TQyfOP92lsZc8hBzyDjIDe9jgyrbNUlb93/iIelu8E+NMEYv2qG/MAvq?=
 =?us-ascii?Q?GGXhiolhH/UkCoTYtP5ereDphoIolHhRdxjH319MzNCVO0bE/XWkzxLUx73t?=
 =?us-ascii?Q?mt0eb8zTxsnR390yQ5MofapbYwgnD84QQ2lmv6jVrsrzWpvF/17BFkPRMOhz?=
 =?us-ascii?Q?HWyRi2pti4nKXvKK3w4++lwCYD1rfc2B2TcKkqqJTS+1WftcfPiHLKhFQsHt?=
 =?us-ascii?Q?1io0hl+QWwhefADzDO/St0bZ7avLICmrl5BAwseBSJO63SqzTQcrz3+0vtJi?=
 =?us-ascii?Q?c9A6kYsqZ5mYp8KYsm7N7ObPiE2kvxEoZpUV+5zoYy4tSWUEnF4ORrUnihnE?=
 =?us-ascii?Q?TKvhZcUJeSozBm9ULW/fA81ZNeEv5f1kJSAF0+g19ZSdWd2fef56JeNZSs6O?=
 =?us-ascii?Q?Nad94zQMyyta9Mpg8153kYbqZaIP3qjzYFmobNwRyiig8Q16S7y73w7DKVHR?=
 =?us-ascii?Q?34Er64gTKDl3n0smuoTZPRJYuyknEWsRXOQ5Ije+2xvuTOAOcOy/wtGLd/Jz?=
 =?us-ascii?Q?RA/F/lO8H2jVRclkPfdnge28H+K+8tZrxEMJa15IBChDwZL1EI0+HBePySli?=
 =?us-ascii?Q?CaOjPg6+hGeZyng4py5Nwqq0NuksE5q4QKaAQabEpPtjBwMG8zeLwCEvGWZZ?=
 =?us-ascii?Q?e3YWvKKU1S0nxpyXwZu00G8JS3ag9YNXPWJrK9dhIIpntItuCr1G1WCxtY2l?=
 =?us-ascii?Q?bJXiWpjMlWz4jLGE3NXtG7qInMQcsesUKQV0/5SbicCC/CBys/UQDnpyTqFj?=
 =?us-ascii?Q?WiVusBtcy1DUbJnxjxknZ6gtdcS9Hm4aW2WllFFfnLm4oZctxpwaw6Oba6AU?=
 =?us-ascii?Q?H9L1tbPVAcIRxaQd2ZK7dy/arx462IPR/OXHQF02r7EZ18FlIEXL79CfXlDj?=
 =?us-ascii?Q?oGPPdNelL/OhhekVA9nTak0equE2Gvto2ibpdzYI26RV23HWjQIz7ayhgJxi?=
 =?us-ascii?Q?bTu/6ZXrgdjksmnfBAHucoQZqhImS7R30R//gE1kqJd8supYDeF6bcS2b7LR?=
 =?us-ascii?Q?hLZz5Ij7xGMFjtXePFTSevrjPu+Ff+RYT+IED2TaEu90BiVzPQHeDZUntjyE?=
 =?us-ascii?Q?7/HAAYEXLe0gWj+vFgXFjKcyuh94f0R/pJdJXXMvyR6oLEobSxUF7w+Cv8OL?=
 =?us-ascii?Q?UJC/1VlG/QRwU8Dgcd/uKwOT1uPwVtNxWxlDPbyK9seLiF4kYqMoTvrVM6E/?=
 =?us-ascii?Q?tOyrToEz4qRvUCsfJWzAGb0ZHljNGXCcXnJsBTN54f37UgCi+6waq2XCooQI?=
 =?us-ascii?Q?FyQrIsl9bS5yXFjCYBj4THQQdokVMIqtxlIrZRPN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7f07fb8-8ce5-4608-6e99-08daf92fef81
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 08:42:30.3050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pq2q4CQWq30NgZHAyW7Py9PEj37N5jiySYX+V2TfBeNZDt+2Yuv1GVC1qXwLRIM2v795LyTMqnoXdovoIakgdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6051
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, January 17, 2023 9:50 PM
>=20
> +/**
> + * vfio_file_is_valid - True if the file is usable with VFIO aPIS

s/aPIS/API/

> +
> +/**
> + * vfio_file_enforced_coherent - True if the DMA associated with the VFI=
O
> file
> + *        is always CPU cache coherent
> + * @file: VFIO group or device file

to on par with other places, "VFIO group file or device file"

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
