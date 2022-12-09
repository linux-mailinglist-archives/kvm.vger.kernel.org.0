Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31550647BD7
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 03:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiLICFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 21:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiLICFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 21:05:31 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9E37D082;
        Thu,  8 Dec 2022 18:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670551531; x=1702087531;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DjYUwTTcyhPte/SqWtNZLnV1ttkO/biGnTCETddjXBA=;
  b=eyazK2Ud/fakk6SCgwtiXLZjrVP9337gTGvZ0Yyvnl2PHNcwyc2Lk/nj
   T7zatc1d3NdmKOi00uNvQ/uks9E7GchPxPrIrODp/OqxuuoGndjZrvpDd
   IZsRpdjINvuud/9yrSVh2nKuzbsMU196uQ5KHrmY1Dkc6Eay+bv03yJoz
   rD9tGd5OkeTmBv02vuFBKXYJG52jO4F7QKX8SOvjAhv6BSIyCYbAg+vLa
   jNL1ZtpHUTjGJVRjMbCVFnBY3isWAwcNOQ+06wu5lvJDfy5EKcjUWXb7c
   Fkh5ojze2DcyU/y6LtGpFe5BUGq/jnIAcZrA6T31pz7XSi3UYfKWZhaLK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="316066616"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="316066616"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 18:05:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="710727523"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="710727523"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 08 Dec 2022 18:05:30 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 18:05:26 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 18:05:26 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 18:05:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSQ9P+aP/F6DuqYXt4hJ5Z111d/YxWJdqB0IfbFtgVCy0rYMGlXgDQbn+tE0egzhqXB7qEYBClxVohtnEwtCxv4y65zaUb/p66fe+LE3sDVmxN8z+7b/CVa1rvOpbwW/MxHQLKqy4KJRrLx1G6GJGU3aI+Xrmoaqlc0qMfhn9UPThQNwM/b3q8wN73lKZj/R2SrYD9fNHFJODqSrsHknWvHXOOO6mzC3sQNrNINWO/GmCWqNHKYHMRx8kI4TuODNF/x1llFCwylemLKqEawZ2vmROsTOTM1aJ9Zraj4sGIIlUzQvq9Bi3dpD6DPtowaEGzjwBedI2k12QMU9lfiLfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DjYUwTTcyhPte/SqWtNZLnV1ttkO/biGnTCETddjXBA=;
 b=YaP2V1P7QxHHmRBQAShiF8PZC2CdNEctTQJywDOaBPV5TM6tZYnab/5up9P77bEkr/R66feo/iDYqkYTCZBrORYr0n9HGdOqq+ySr9WX6H5udAgGgJDeLy/37LZCcx+dJJRNM4VHMKAkDpIF1pMxpaCD4J8FX3Djp7Fn7DQDZj2vORNL9vhEZ6SPnhnaR7SVskk1vl+E9OSDVlpZMZl2gOomZtZ7qbb3sC+bI5brPXfYRiNq5KoZK+wwx8n0fohI1U/ZGKeaDAeeMHhRHb7gMNT+sweXAsnk5fYL9hOPsry7MfsbVLKLRLmhNsXqeTdj593z09SC1ycNIC97IfKEvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW5PR11MB5908.namprd11.prod.outlook.com (2603:10b6:303:194::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 02:05:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb%5]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 02:05:21 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>
CC:     "Rao, Lei" <lei.rao@intel.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>, "kch@nvidia.com" <kch@nvidia.com>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "Li, Yadong" <yadong.li@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Wilk, Konrad" <konrad.wilk@oracle.com>,
        "stephen@eideticom.com" <stephen@eideticom.com>,
        "Yuan, Hang" <hang.yuan@intel.com>
Subject: RE: [RFC PATCH 5/5] nvme-vfio: Add a document for the NVMe device
Thread-Topic: [RFC PATCH 5/5] nvme-vfio: Add a document for the NVMe device
Thread-Index: AQHZCTfYyny4e3N+rkKvPkqEmu3jSa5gZMsAgABvfICAAAEagIAD/L5A
Date:   Fri, 9 Dec 2022 02:05:21 +0000
Message-ID: <BN9PR11MB5276EBF06791EF7B39648FA48C1C9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221206055816.292304-1-lei.rao@intel.com>
 <20221206055816.292304-6-lei.rao@intel.com> <20221206062604.GB6595@lst.de>
 <Y48+AaG5rSCviIhl@ziepe.ca> <20221206130901.GB24358@lst.de>
In-Reply-To: <20221206130901.GB24358@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW5PR11MB5908:EE_
x-ms-office365-filtering-correlation-id: e7ef241e-86c2-431a-8042-08dad989d3bd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IJzbpPGUbtqKz5q7eYr2Cn4aitWUGImL2+cKRrJ5tZ4eow4MmwyIWMkNTGG1S5sdvO/0579I6ig6bFIASU/QLcnNq2MgiPcf5q7ENQcoxNxddRPzpG5OVeR+/9zuxRyNu6X6guoyE/iAwTGVWyE4tRNGyAoyjxLzpR6wIlpKlY7lZxN7TiANv9//3Qn7NljODav2UUWzpKZc5O/5nAQ3g8El12pHraFBktJti44rSaL+j1tiWd+Oi/MUOA/tn1we91yhsP+pFTM498gL/YSx7nRhRLReQSEOOAMTkwKGCXLK2aGdTEB7eVmi7O1exdzylgUbBKZX3d3SDw3a8HzNhqu3t0a/szgO5onIOanF5faPo6pJNpWgEYMiZMNZu1kJZdYe/MDJbhc2qq4jw5Ab2rtxv5gdurtxumZXAaKJQ49ETnbZbeJvGwbhmm7vFMINpzHIzzo2trHzhGv0nEhCrDuD/eJMgxVlIWlLBxcIUK7ZKFtdK9nR5WTz+QAdDgOqauvn/GW2jZ/WI9OB4VKnDJcmYM6nKl7+L4PaoJl11KRutBErj4S71E9oiyQ6Eb7pp5F5DWFf96E4rnd8X/3bW4qg71zJyDczdhNppEOqNK79jV7uv/6Vzq8a8pwDM4xP69gripOJPS7uP+EdxS/gb4cpBGuX35JVV/pVQBbplTo0fRvHJ8YVnPSpUnQiytMU2mV7EgJoHNi8ne0r9oyTlg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(346002)(396003)(136003)(366004)(451199015)(316002)(54906003)(52536014)(107886003)(110136005)(8676002)(71200400001)(86362001)(478600001)(41300700001)(66946007)(38100700002)(76116006)(4326008)(82960400001)(66446008)(64756008)(7416002)(33656002)(66556008)(4744005)(66476007)(8936002)(5660300002)(2906002)(122000001)(9686003)(7696005)(6506007)(38070700005)(26005)(186003)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kyDbP2W+3Vo8BqxmCNyNYViXzIF4ECaa1yt+du5cOknQ3Lv9Kev7y2z0SpU+?=
 =?us-ascii?Q?AIWsVuMUpB83i/VmMIblEk5PcsNYyPDTDwGNCWLXhl1OidLVxSLUcuEedaf2?=
 =?us-ascii?Q?OK+ZULKYhpUg76G/P4kcVub+x/3ywoXEe3QfIMYgGnl36/QeHkSyMSu6kHX6?=
 =?us-ascii?Q?4nyvSmrPNbNBiwVHhBzHF8v/yGaZFffHnEI77yMyJZHdVcnbDBCbZJTprQCd?=
 =?us-ascii?Q?7E7adNP5DsnE+wCFdPJGNFA4FXycsDPtGlT6d2A5A02GP2VFWYO+6fkECiJ+?=
 =?us-ascii?Q?6Cm0PzOLv/3VvfJejUE2vPji0q6S/kX3VXDWs2m8QaJOtzSAY5XtgrIc7m65?=
 =?us-ascii?Q?BDAcuFho4HICyDcsaIG1y/LUQ1wYFWEnlG4QG/L9lFdMiRBP3wTtmGXDuLHE?=
 =?us-ascii?Q?Ckfin+OP1Z2MCJnrAnv6iJ4plxxfLi2hbUtf6Qap7komK0M0kiGAgBRuVX+p?=
 =?us-ascii?Q?coqcsP1wvNewBu8Hncpqp6XCxSJMzmVVEjMA0SsaQMNMr2KNlLqKNt901euS?=
 =?us-ascii?Q?DwRPyX21hJ6UPKBdmA8mS3x3hE8s5Ig9fnb65qYvKoNyuhqIbQqsrp5ov1gl?=
 =?us-ascii?Q?Dl2+7UsC5I2f19cx3a/setxVH6t1dlOaW4Nzc0yelfw+gmrAOcv4BHKV7yOj?=
 =?us-ascii?Q?ggMNGRmiOguy71NTx3KGRGh0kihnPNLjPKcC+PMoS4YnuR1zL75edbzBruhg?=
 =?us-ascii?Q?7m4Gpw9LzhBROVr4xnPHgDdJZvsORVNS2/jAXSfPfTntAQlW8BffqUHS/Tq9?=
 =?us-ascii?Q?kvTl8ZYimF9er0e85a1fmGZN0vfJiz4UpuATnH/ifBay0ajJIrCu9iWHU7a3?=
 =?us-ascii?Q?6Il/xMbAZr8CTIzBDpHuVpoFqZeRIjFD1f2zUPnBZBIkFGh1/i37y/9ZAvoD?=
 =?us-ascii?Q?jITI2CKoNWvz8OTA/AiA4per15yABPxwG+jtNtgqwX9nLEpGCKNM8Q5ScL2z?=
 =?us-ascii?Q?o3CM5YrTPjPCS3hgPDtFgjZ8kddzcVlNMuvlMY4fDUlzUDwthPisU9kc8BIg?=
 =?us-ascii?Q?pOcsL+UrYa8GsOZvE4Wp2/SOtRzn4lZpDFqu1dY6hUXauh2s5M3WEklc+rvU?=
 =?us-ascii?Q?iKk+PEZaPCtjplYHPkhbAKvvpxVAOnXY7ym+9ZnGbC7XQomJj5ffEqUOMAo8?=
 =?us-ascii?Q?M5cmzrO7CrRxbWRkIpDmwd9zLuAPgS3uB+x7bl1yEtgfkMt/B8bHCnz2pD7h?=
 =?us-ascii?Q?9obqW3IbmXFqCdnRFZ2Ec+mw06PRUe+GSIcKiQT+0QdpgkVoWyaRvTX7KjHw?=
 =?us-ascii?Q?H5QvaB9QVEE/p1efmOpMVXKGFKsitaP2IEa67p76nRFwKd3HUx7s0a0yQjKz?=
 =?us-ascii?Q?c5BSLe0RnAsDUX3nnuvN//1rG1QwBF0vwgndZaKHra2t6d4+YsIRuckkpba4?=
 =?us-ascii?Q?TQXuxdARfZGa+3WT7o8efX5Nj2BMj4U3ZyIJtzDAITzQPsqszWJWeA9hSO46?=
 =?us-ascii?Q?OjYduNHhWdjn6phNhTfixIiT0usmL0y5VgJHGCMbqyUbPZzCdGwSiZ+e4N5p?=
 =?us-ascii?Q?g6jM30RTR9a2rY9QGtI8CSLO1JsXW4WI5gmBBFlbOJ/yg9CRetkjIee+6wly?=
 =?us-ascii?Q?lq2INdw6gYMvdU0YPoyix0ttzfRwFpovthrzDjaW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7ef241e-86c2-431a-8042-08dad989d3bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2022 02:05:21.1879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f57J5OgO1P00yX9vbq1jJu6WRX4UnTtX8VBm74OpgAVo1oawU1Vfwq/Z83+75hLkuLUqlBItl77pN7MNT4aMrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5908
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Tuesday, December 6, 2022 9:09 PM
>=20
>=20
> > I don't think we know enough about this space at the moment to fix a
> > specification to one path or the other, so I hope the TPAR will settle
> > on something that can support both models in SW and people can try
> > things out.
>=20
> I've not seen anyone from Intel actually contributing to the live
> migration TPAR, which is almost two month old by now.

Not a NVMe guy but obviously Intel should join. I have forwarded this
to internal folks to check the actual status.

And I also asked them to prepare a document explaining how this
opaque cmd actually works to address your concerns.
