Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8034E5DD7
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 05:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242148AbiCXEav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 00:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242070AbiCXEat (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 00:30:49 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907A91D32D
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 21:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648096157; x=1679632157;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T602Qy6Yi6mg7Y/J2BhGCl9WOE2nWUHY55jMRCZzQJA=;
  b=fL5LfeWU9NpoUFhBuLr97olFDY8VxchWou0hX7r3sd6zYLrc9+c3sv92
   KLd5Ivrd8XPzuibp5pmTkfQwDwaGIxJsozA9lCwJUOsWqAj1OJ9XyWVab
   hWsh7uAGUESuX7hPKT+MScas516PyNR+tUGgmgKrj7868+BlkTTou1xeQ
   +ZRQEbf84XYnWQO1T49linLsSXtUk4P4CgkYNUOa6wz8N7goG/K+rJCXg
   DMotc5Dscu6yyGAKzMRc7MlPpqtH102zrxdopBH70tmWykvFDnUpBV82x
   SBvqJHusn/OF8fXYC+Ydrbm915psMokCorOorFGtNUcDrrK6N+rQ8zFBg
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="257112491"
X-IronPort-AV: E=Sophos;i="5.90,206,1643702400"; 
   d="scan'208";a="257112491"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 21:29:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,206,1643702400"; 
   d="scan'208";a="647726843"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 23 Mar 2022 21:29:17 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 23 Mar 2022 21:29:16 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Wed, 23 Mar 2022 21:29:16 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 23 Mar 2022 21:29:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jsNpsIyUV4ttKPuY1HmsHrWE80HjAo78EOcn01/0rSQOCGgp9TVUXsVbZ9vhFlt4rfuGdSoHTmlPruOPmUS8dgd9EKUobBTunOiv/jkQKp/ooSZffdo+j9PGNCGZTXuTuK3u561Hz2JXYGSKxMgxu1HTwGeYlTKLm7w2Qbswg8JIrLMKhxNX7YKRlk5DKKpe3ilzjU8CQugzLEdq3N9K9NsqusY2yK6aVh4/OsBtZuHsN01/AnacvVHsdPB442cifrkG4B/KD40HD8vttmSeCpO48iqXFUoA3+UcvXMVJewYeUwNE1tWKjWGHjSF9x2hiUvs9mP/aRk2yDKu0Lxaqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T602Qy6Yi6mg7Y/J2BhGCl9WOE2nWUHY55jMRCZzQJA=;
 b=dqq70pjETYu4YghVS+EdYOIx0ovl8vMgghgw8ADhlUg4e5Wnv1esbKGXGHeNbYdFOXpJCzBZdLV+sutzhb+taSh7H3BihLJIF5Gi6z7wn1c/np9vL9Lcf9Q7ran1/NXyCuLefxdvnsZ5uCMbqLmyKANnYerfLjbj93Iqtduh9CuUBagNRO76CyyPHKeN/XbZKN8CzG0a7kFRc5vBMtZI/c1KDk8ZDfSYIzxN4bSyM6/B4BQBizc871IFA0Vc8SLrMVbRi8g4teQZstrQqnJTTrpVpIGh2fhytBpf+qLLYGPEoAjLbgjh6p7gx6K21PqIoyRHD5WDRdQXP1InbYxoaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR11MB1845.namprd11.prod.outlook.com (2603:10b6:903:128::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Thu, 24 Mar
 2022 04:29:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0%4]) with mapi id 15.20.5102.018; Thu, 24 Mar 2022
 04:29:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: RE: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be usable
 for iommufd
Thread-Topic: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be
 usable for iommufd
Thread-Index: AQHYOu2DSsSjQi9eMEu6J1ns8GLP6azLfE8AgAAIMYCAAAjbgIAADNiAgAI1J0CAAAhSgIAAAkLwgAAF7YCAAAOIEIAAC3KAgAAIBoA=
Date:   Thu, 24 Mar 2022 04:29:14 +0000
Message-ID: <BN9PR11MB5276FB52D63497FC67CB7ABE8C199@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <4-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <808a871b3918dc067031085de3e8af6b49c6ef89.camel@linux.ibm.com>
 <20220322145741.GH11336@nvidia.com>
 <20220322092923.5bc79861.alex.williamson@redhat.com>
 <20220322161521.GJ11336@nvidia.com>
 <BN9PR11MB5276BED72D82280C0A4C6F0C8C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEutpbOc_+5n3SDuNDyHn19jSH4ukSM9i0SUgWmXDydxnA@mail.gmail.com>
 <BN9PR11MB5276E3566D633CEE245004D08C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEvTmCFqAsc4z=2OXOdr7X--0BSDpH06kCiAP5MHBjaZtg@mail.gmail.com>
 <BN9PR11MB5276ECF1F1C7D0A80DA086D18C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEtpWemw6tj=suxNjvSHuixyzhMJBYmqdbhQkinuWNADCQ@mail.gmail.com>
In-Reply-To: <CACGkMEtpWemw6tj=suxNjvSHuixyzhMJBYmqdbhQkinuWNADCQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f889dec-217a-4a10-8a66-08da0d4ed9f4
x-ms-traffictypediagnostic: CY4PR11MB1845:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <CY4PR11MB184508798FFF84EA5B1B8E7F8C199@CY4PR11MB1845.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: abc8y0WtKnz3VMRor3Sv32lHyihFGg7QOh6/isqPXxLwSo5K3eTHeqq2DCrr5ittWDxgHrxfNbAf0Ae1wRjOHeNyXcXfeomIAHBATSlEJjvwN78MQv1UfPPIB1LfyTAwyAaM5UcpVjgx+eehXMlQ/DH7X1DvLAM3P1E5eAr7P1kfglUOkF5RZZ8dj/bW4ov4JWlHUYsj41xiDhSdx17uh0CLF0ynHk3RUQFVZtqftZeRQVbooQXH7AxpZqifrNS7QchLfQy7uK6GJlK+kPHmN7ZBzedegTyNhUzG0OTSuvHuygdZdYzBFfPvVVv9d5yDaaVO877Skai7lHDRIy6wqQLAXjIMGC+aEeDsDFAEdvoWa+SF+fyhUh9FNzUPwVY35/g0Ed4QSZEqm+r/nHj3JBjjZr92BsjpdT0FXJuwCGNab1xJ1x09cj9/x79y7+mDPz2Az8fem+uKXsC9FO1k+biOCvMmRyibC6QN833dIKBJxHu4q+HLh5fz45MaKiumpCSKWB1oF5nZ1N/qSzVnKfWyarutoJNvkJLYuTg/F0G3fhOanWloEdokXLYOLZqkEEwwk0vg5nVyPicodIloVx2mGeuAuJfh0Pp4LHi2Rk2O6e3iXiNdUmPZjdSGBJ0uwfnCtiBJ9Xk988bhjnxmP+iZ6LMSKndZ8xoNziKsFT71fOnJ6kCMqyzY7geLekwCM40N/QHiSqA9D6ZIF7E+GAUfYsErg/egzljoI+2vz3MO/oK5GtBRtw6S77bgpUm6pkBztlcqIhRdYI8xV2g42j53BgkpcQ8VJhZKSd5vowg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(8676002)(64756008)(6506007)(966005)(7696005)(66446008)(2906002)(6916009)(186003)(71200400001)(508600001)(26005)(33656002)(55016003)(66476007)(5660300002)(76116006)(316002)(66946007)(8936002)(7416002)(52536014)(4326008)(82960400001)(54906003)(38100700002)(9686003)(122000001)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UEMzaWlENkh0cWVOZkIwM0U1R2FTUnlNd21sN2o5OTFrTUxyc3lrM25RMjRQ?=
 =?utf-8?B?M3RISnFxWlRQQ1JuR2xwYW5teVcyYkhGSnpIQnFIbTBQeW5nMU9PdTBCR1lv?=
 =?utf-8?B?N3hBRHBWcVBIemdYWVVzd29McFhKK1JnWlpQbGZTQlJaODl4N0ZHamlma3da?=
 =?utf-8?B?Q1ZzQXBlMkljSEFkWkNwQlFjRWZhOVRuSjFFQmR6R2NSOUtyOXVqU251WEp3?=
 =?utf-8?B?NnI3SzlmT0ZiS0dxdFl6aDdKWDAzSUxOc1hIbUUzL0l2am5XQUtJY3F0enB6?=
 =?utf-8?B?UkhPVVZIMjBVUkhvbzhNaFhNc1M2a2lJQVFTbXUrUG8vWjZmdHhweE5zKzdT?=
 =?utf-8?B?MlFwZDU4SjdHTWdtNmcyendaU0dwS0laN21XQkZLellCVEVUTDZkcXFqSEtx?=
 =?utf-8?B?V05FS0M5STVPMi9YY2NOVmdHRWdydE45RDZpUWF1Z04wdXBTeEN4WW1nclpr?=
 =?utf-8?B?R1EyMWd1SWZyUWZjOHMrNUxRbU8rZTUwV05XbXNPS0hUSmV5RFkwcWJRekxq?=
 =?utf-8?B?YXJ3MXdnS0ZKZVFxQzY4RXltWkR0citDT1Y0U2V6Y0Fkei9nRkVBVy8zRUVC?=
 =?utf-8?B?amh6N0R0dXFUM3dMOTVNQ2t5UDVTZmVHV0EzRW9yTktlbm51N2xJRERQL0c3?=
 =?utf-8?B?ajREK21GRHhnL3RUVmlsNDRaTjJQSHhtekZFRWpxdTExMHZZeWVPZlFtb3da?=
 =?utf-8?B?aGpqTC8yTTZuVWtOd09FaWs0U3RBdFlaQUJvQVNMb1RuTFNCMGxMTzl1b0pj?=
 =?utf-8?B?QWwwUFJIampvVWFPaVA4a01VU1crRDg5YklsM3R5dXFjdVlZbk1wN3BoRlAz?=
 =?utf-8?B?ZU4rL3I0bldsa2pqWURxL2p5U3lQWTJuTU1kMDZLTE5PdUZYdWFlRDM4M2ZS?=
 =?utf-8?B?NTJHSGNQRng5ZjhZQlVzZ0xVMC80Rll0VC94Zm55QWdUYTV1SndBTjNJL0pG?=
 =?utf-8?B?b2M5L0xCRnovWm5ZdWp3eVRjZy9PZDhaR0luV3A3aE5kblBpVDRmcVhwKzZO?=
 =?utf-8?B?VUcrRW05TVpweUhIN0ZKNHNGejFORi9EMXJBVVRmMGw2N0pSWGQ1T1VKVUl6?=
 =?utf-8?B?N3I4WFYrMXZFMDVUdEtnbk9wd2NHSnFzUy9vVDh4VW5yTXRlSk1aVG9xZGIw?=
 =?utf-8?B?TVd1NDczY2w0dFNmQzdBRmVKN0hsaXJKWTY1MjVaWklHUGZ0SWowaGNZVHVo?=
 =?utf-8?B?dFdRYkFsNGJKd0YyMEhJVmJPeklIM2ZIclVpek5TdklUL2pkalp6VStYTlIx?=
 =?utf-8?B?MzZSM2QySXZKa056MUlsRStnU2tnU3QwSEZtem5oZkJneU1rd25XS3RhVGF1?=
 =?utf-8?B?QmRrTDczOFY5NXo0WkJxb2treGsrbE14L2lhNWVSSzF6TzRIS20zRlB4RkRw?=
 =?utf-8?B?RW1aQk5ONWFyRGZFOU5YTThBekJ4OHVIQlJUV3c4OGk3NVBxdXBTQUVUUkpa?=
 =?utf-8?B?eHlzQ000U0V0RFE2cUVLR1QrUlRWeHJXb296V0h4ZHlYODBERmRVdWdUQ3A2?=
 =?utf-8?B?VEFOcDhDeXFZeE45SHNUSmIyQWdGL2xQZGhCRWFzQnpnQS9jTzJ5K010Ym5q?=
 =?utf-8?B?dWFEeUxtOXpTTmllOS82MGN2alVrQzlwOVZ4UjhpcHZsQXFUWFJOcHYxY0Ur?=
 =?utf-8?B?NDlmR2hEZC9zOHRDWFVkODI2L0pHNXJXdDVsL1A2SjRVRW51NUVJU1RoYzBX?=
 =?utf-8?B?Yzl4U01lSEtkSVBwQTZTdHBaOUZGb0JlSnlQOUVIeVcvMVFmNElQS3FuQ0Uy?=
 =?utf-8?B?ME9Sa2EvU284NVBPamNmWDBpODRqSFN1UGRTN0NIYStTcVRaMmJ3MFBGbUNq?=
 =?utf-8?B?ckNBNnRxNUJGL0JSRjcyZVgrMGE1SmVtK3ZXVTBDRysyMkVVSGZoeDhXRWo0?=
 =?utf-8?B?azZTOEp4MkNJOUx4bFVlb0VCVjVxeGg1cWNpM0FVQkRHdkFYa1FURGJoMzFr?=
 =?utf-8?Q?35vi6WIKGHoKXKgzeWE6m44j78V6eBtf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f889dec-217a-4a10-8a66-08da0d4ed9f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2022 04:29:14.0232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z/1Rv9IthQBQs7KaG6Iogfv5CqDTUC9+89nWNVpAi4Q5pxn7r2Uj9PMpQ+HYo8GcOwzFyYzKtMEpL03yWt2mbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1845
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPg0KPiBTZW50OiBUaHVyc2Rh
eSwgTWFyY2ggMjQsIDIwMjIgMTE6NTEgQU0NCj4gDQo+ID4gPg0KPiA+DQo+ID4gSW4gdGhlIGVu
ZCB2ZmlvIHR5cGUxIHdpbGwgYmUgcmVwbGFjZWQgYnkgaW9tbXVmZCBjb21wYXQgbGF5ZXIuIFdp
dGgNCj4gPiB0aGF0IGdvYWwgaW4gbWluZCBpb21tdWZkIGhhcyB0byBpbmhlcml0IHR5cGUxIGJl
aGF2aW9ycy4NCj4gDQo+IFNvIHRoZSBjb21wYXRpYmlsaXR5IHNob3VsZCBiZSBwcm92aWRlZCBi
eSB0aGUgY29tcGF0IGxheWVyIGluc3RlYWQgb2YNCj4gdGhlIGNvcmUgaW9tbXVmZC4NCj4gDQo+
IEFuZCBJIHdvbmRlciB3aGF0IGhhcHBlbnMgaWYgaW9tbXVmZCBpcyB1c2VkIGJ5IG90aGVyIHN1
YnN5c3RlbXMgbGlrZQ0KPiB2RFBBLiBEb2VzIGl0IG1lYW4gdkRQQSBuZWVkcyB0byBpbmhlcml0
IHR5cGUxIGJlaGF2aW91cnM/IElmIHllcywgZG8NCj4gd2UgbmVlZCBhIHBlciBzdWJzeXN0ZW0g
bmV3IHVBUEkgdG8gZXhwb3NlIHRoaXMgY2FwYWJpbGl0eT8gSWYgeWVzLA0KPiB3aHkgY2FuJ3Qg
VkZJTyBoYXZlIHN1Y2ggYW4gQVBJIHRoZW4gd2UgZG9uJ3QgZXZlbiBuZWVkIHRoZSBjb21wYXQN
Cj4gbGF5ZXIgYXQgYWxsPw0KPiANCg0KTm8sIGNvbXBhdCBsYXllciBpcyBqdXN0IGZvciB2Zmlv
LiBvdGhlciBzdWJzeXN0ZW1zIGluY2x1ZGluZyB2ZHBhIGlzDQpleHBlY3RlZCB0byB1c2UgaW9t
bXUgdUFQSSBkaXJlY3RseSwgZXhjZXB0IGhhdmluZyB0aGVpciBvd24NCmJpbmRfaW9tbXVmZCBh
bmQgYXR0YWNoX2lvYXMgdUFQSXMgdG8gYnVpbGQgdGhlIGNvbm5lY3Rpb24gYmV0d2Vlbg0KZGV2
aWNlIGFuZCBpb21tdWZkL2lvYXMuDQoNCkFuZCBoYXZpbmcgYSBjb21wYXQgbGF5ZXIgZm9yIHZm
aW8gaXMganVzdCBmb3IgdHJhbnNpdGlvbiBwdXJwb3NlLiBZaSBoYXMNCmRlbW9uc3RyYXRlZCBo
b3cgdmZpbyBjYW4gZm9sbG93IHdoYXQgb3RoZXIgc3Vic3lzdGVtcyBhcmUNCmV4cGVjdGVkIHRv
IGRvIGhlcmU6DQoNCmh0dHBzOi8vZ2l0aHViLmNvbS9sdXhpczE5OTkvaW9tbXVmZC9jb21taXRz
L2lvbW11ZmQtdjUuMTctcmM2DQooc3BlY2lmaWNhbGx5IGNvbW1pdHMgcmVsYXRlZCB0byAiY292
ZXItbGV0dGVyOiBBZGFwdGluZyB2ZmlvLXBjaSB0byBpb21tdWZkIikNCg0KVGhhbmtzDQpLZXZp
bg0K
