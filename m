Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6941750F684
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 10:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244838AbiDZI4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 04:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347196AbiDZIvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 04:51:12 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336EF1759C6
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 01:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650962382; x=1682498382;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KHHg+nfB6P2ijKuQiljPBbLn6oMzUysVg47Lwlq6AuI=;
  b=InK1fmsMBiR8SZL8G4g/0ZKBSQbDt2RqhS5OujerU4hg+Pj8dncueYlK
   M2kUk/RXSnaGGCWh9NAAt9YAvryYE5Hj9GuOu7vs6Pc9dAJ7dgICsw16h
   dMKx+/ib4EYOg8pg7Ub2M8Kcw/OIKA4coiZwBiNfjMWWof+a/oOvBJ4Yn
   ktxll5+NEBaAzkz0seIasfJU3sXh09yiOAUrQ0YDJbeQJRtEKOwp/p+uk
   eLY/y0QN2D08m12B6YpSxM7jW+6L3c6zx6/bFyvTwQFL1uU3G2cUZJqmy
   1MyAfwAzS1Dhrvwn1ESMnuOXFvVnVMRa5A6KZXDp61djLgC312+ypN0Xr
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="247432869"
X-IronPort-AV: E=Sophos;i="5.90,290,1643702400"; 
   d="scan'208";a="247432869"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 01:39:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,290,1643702400"; 
   d="scan'208";a="579770101"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga008.jf.intel.com with ESMTP; 26 Apr 2022 01:39:41 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 26 Apr 2022 01:39:41 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 26 Apr 2022 01:39:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 26 Apr 2022 01:39:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BaaY9xftx5CvpbfPAQRRHGRoP2uMDCiY4hTuoY0cAmCS91zHOegKo9UyPdbhIkmPk8fb8ctDEKoJLRi5Ef5WP0AlwvuwXFSMpo9aprz59XofC+BSI4G0e36CzgrcXSc3maTxsZvUHpeE6/FhXD284mD7UJlvKXE/oQJbJc5AQuZEzzNP1QkCpnBfCT6z52Ey4mRUCwamqb8hAl4SVwF/eBRUUw3N87WZZJ9O5ptZf+e6BFSVYBPd6Ie3hYfejB45Fx4tSGiMxyFPpXeboHtz/1KTxMrRNvwxrAksMbg3jdI0+knDC+tExHSU2Y1jM8dqMql4E7RXEmyYIZjPaKLuMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KHHg+nfB6P2ijKuQiljPBbLn6oMzUysVg47Lwlq6AuI=;
 b=L+I3owdAkXSPueQPJHR8uNyH7FuUXTG5drI8mMhQhZQTDpylWqDT/4M+ZYWdHX8CKIS1ZD7gRC74vaNftkD87AzGuVcSxjIkvicTqtRLfCGqPUmcwlvjAUBWqJA93oMJk9m5hcn3NyAb9kPtdPeNOqESJjfpZwE5yKhopzR2iFOP/NKSnolOVL2p1iuX8UI8f5lC+Ya3anMoruprXz5PHCUzR6ofnaHGC4diwi81UhO0v+T2vkluqrr8DkKHkuHGg8f2xPog3kjS7dQDmh9/4IhOoPwDBAmLYOjGgSs8Lrenj9Jn+wjjK4ARMK5d3qsZ2W+0ssv6PmQ/RNMdax4krQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO6PR11MB5652.namprd11.prod.outlook.com (2603:10b6:5:35e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 26 Apr
 2022 08:39:34 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 08:39:34 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: RE: [RFC 00/18] vfio: Adopt iommufd
Thread-Topic: [RFC 00/18] vfio: Adopt iommufd
Thread-Index: AQHYT+0D1ejJho1As0eoIzmf/Uaf8qz1XItwgAvAYoCAANVegA==
Date:   Tue, 26 Apr 2022 08:39:34 +0000
Message-ID: <BN9PR11MB52762773249668EF0BC5BDA48CFB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <BN9PR11MB5276085CDF750807005A775B8CF39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d1c63ea2-7396-7020-7a45-88e3d1918fb1@redhat.com>
In-Reply-To: <d1c63ea2-7396-7020-7a45-88e3d1918fb1@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca4e0ac2-f677-4533-324c-08da27604a7b
x-ms-traffictypediagnostic: CO6PR11MB5652:EE_
x-microsoft-antispam-prvs: <CO6PR11MB56524BC63E2C721E6A6D85C18CFB9@CO6PR11MB5652.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5scBiAFBBiginjipY1lH/RGHRZrWBgrXyeb3lojz4zbyHEZxITVG0sMILQCMTd9fjCLD8/6XOZmMnkP1s9iMXoCg0dhs5vkbNFifB/k0KaOPzqhjRV3CyQ96WaR4s3L5GGCmYDVbc80SD4DxhnDxQ/gRvmZkYjnaXgknoP4nAA7H0cFw5NfqOt6nWeQbNZsAgdl+YMiajy6ZKhF/aIpaS2FU9bSeGrCVg5oOOmEtWRim4lV8gCJlZKOEdIzKHyZhuptP6S/mHm5CieYVWjiaQTHLpQtsx02mmVKiltcvJLgNtCgIVXkuHz5a/bXxbg/xvIX/Z2/d0CHQvvBCBjCAlqhkjWzPvhCgtUqPdTMt1XP2bmSgb637leRZdAst9T8Lp035WGp6w+oraqBZfGMrrRDcVyHjrRbodbWpczbwwu+opaEt/XvHrtkokbkyglOCAu5XMffVx1OHCJtRjqJRcH1aS8oI/WZxefnV/qgPMYKKxrH4JjBTLd2IF3b8YP1XMS99Cs3JShQwCmqL5sZGpvSqIpt0QQ3+pVobZRGTfYhvgHrx+HuhzMKWT45U/oCrQYKRfBgobOrt9SWZHOjOmXTUcSUaHSoipxlr8Sz23q2HOoU3WPT35ubnBpbRa6QiDVY7NzZq0Xxs2Sbjwd2MtEpH25VohOH2MzDE3OkLExgWLNlE3KqCOBUxYEKu+Kmo+gWlvnMC46a8c+hzpjDzXw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(9686003)(38070700005)(55016003)(53546011)(38100700002)(33656002)(7416002)(66446008)(4326008)(5660300002)(316002)(71200400001)(4744005)(2906002)(6506007)(7696005)(26005)(86362001)(186003)(82960400001)(122000001)(508600001)(8936002)(110136005)(54906003)(966005)(66946007)(52536014)(8676002)(64756008)(66476007)(76116006)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ME4yOHRxQlN1d2wzcGFFbG4wRkpZd21xVGVvVHYzYTdmeUthaWtUdDN2Q2Fz?=
 =?utf-8?B?cFJySU02TnFWbDYxSDUwYkJuZnhvY1hKOGsva1hRYVNXaUlqdmJDU1EvaEV1?=
 =?utf-8?B?SC9zeUtLYUM2VG1MTEc1RmJYbmNOdWlKcUlPZEVvUHBoRVBSNForNHJoeDlF?=
 =?utf-8?B?RC9QQUpWdmNmKzI0cldVVW1vTFVkblFReitUQWQ5K1Y1cHhiUDNRend2UTFH?=
 =?utf-8?B?L3JjbUdNZnExUVdFUTI0VlBYTXAzV21wZHFTayt3MHNrK1ZlQ1pkZVVEbi81?=
 =?utf-8?B?RjFtYmZyZnZXV0dEbFp5RDlwY1dCOTcwaFdQOFA4SmhTYzkrMmpWQnNod1k2?=
 =?utf-8?B?bnc4ekpxWlV1TWhYRGZteGMyRlpxdEJGbDRNK0luTXVGNGJLQTk3OEVTZUIy?=
 =?utf-8?B?VnQzZERjdkswRkdlYmJNYjFMU3JkRFJBMzUxWFFEYysxOWw5OVhWMXZ3QmIz?=
 =?utf-8?B?dU5leEJGMUMzVWRzSTNFZ200amlPSm5ZZnY0dWVPTXAzRW14OWhWenA3NFU1?=
 =?utf-8?B?S3ZseWlZT1pVbUgxaWJsakdtb0w3cWRFVDM1V0wyQW8vWXBFaXBDaHZ1bFNu?=
 =?utf-8?B?cXpNdVVYQi9hZ2VBUjdvZlNrUHhHUERUb0tDNnVETTdyMzdSUFBtSVcxUFc4?=
 =?utf-8?B?VG5QaU9SZ1JPTXNaNjI1THFUYzBwcUNJMUpkaWlFYmtId1poby9MblN4STZB?=
 =?utf-8?B?dTN6cmdHZk4vMTZBbGhVMWZZT0UvSVVHdXF5NkFSR01MUzRERnoyWkZnaTZU?=
 =?utf-8?B?dkFBVnJCb0FyN0FmcTNFRG1pWlBlVGZBMmEyamtSYXFKL2RxSUs5V1BYYkR3?=
 =?utf-8?B?RUh0emdnNkgxVWl4cWRhV1BETW84VjRKd2Z2WXo5NUQ1RnA5UURDV0NIR21J?=
 =?utf-8?B?b1lJaFNSdEk4dTIvSTN1YjJMWC95b3ZhODdzKy9ZQUJ1TlJ3cXpZaDV0ek41?=
 =?utf-8?B?d3loMWJPU2FNVldLRVNnN2JmYlRPR1BzbHNRbUliTE9hYi9oVUIzV0cvU0tJ?=
 =?utf-8?B?bUhLWFBrY0MxUHFTNEM5QkVRKzRPS2tNVzhFcFd4bFp1czJnNXRJNmNXaHRz?=
 =?utf-8?B?SiswcDdwMzR5NUhXS1MwdVBuM09OY0l4RHF6QlExTmlnaW9pZmszbHVncGp5?=
 =?utf-8?B?SVZYeFFLYVdjZm9pWFR3c2FhU0NYL3k4L0lwMVQ5UG9YK1VIMHJablRTM01n?=
 =?utf-8?B?SHRER1FJMCtJbDIzam1rTE9uMm5yY1JtRXNZQmdzWk9RMDFMVDErQ3dnaVBn?=
 =?utf-8?B?VmJncmE3NnlXazBVU2YydDlRbVdlU2tUNEdDWTA4aklvc1NQQU9kUm9ZcDVY?=
 =?utf-8?B?SW1CMWoxTERaSE1uR0J0VEQwcjltZTFjT2tobDFpa0gvM05DTHpzS05SMjlu?=
 =?utf-8?B?VU5MeUJQb3JLeG5EbGRZTGxsR0lFKzBRVlorOXRBVlVZSDB0dlRXL3g3NkRN?=
 =?utf-8?B?TDNYUVVwY2ZBWlpnYlQvUXdpNG51RTJYSlg2YlBFK2dUQUxpWU1qNW5acFdD?=
 =?utf-8?B?Q1N2TGhRVUR3ZC82bWFjMmU2TWMvcjViSlBseVNyUlRTVWlaRGxnYmRKcnhJ?=
 =?utf-8?B?WGl0b3k0UXhoVE9jOTFNOE5iT3J1aGhzVXVXTUNaZjhIYVBJN21sdTBrSTZK?=
 =?utf-8?B?N21mRDlZcXNkY1J0NzFBVzlab29WVUJmWkovdTFhV0YxeEM4eVRkWXpCTTBr?=
 =?utf-8?B?TEwzeVRKTFlEZHRtU3hvTXZqL1FOMHZ2KzA0a2dyZ0xJaGp3dmE1NUQ4eXRn?=
 =?utf-8?B?a2FXMWM3U0VpMTdpbVRxZTIyZDh4MGEwVlJhbm0xNDM2WVBnQWNxOS9CRWxT?=
 =?utf-8?B?UWsyb1RjZlIvZEU1NG9EbUdaWmFCaFhnNndYK2wvMmhlMmFJTEtrdllCbmN0?=
 =?utf-8?B?WFNiNkR5ZVhLalZLcWYzNzNKWUw0VFFuNkhpNGxZZGRjVFIvdDVZZlpRVDFu?=
 =?utf-8?B?MENlSDVBOVU5WXFOd0Zma0tvdmVSeEVKeWRQL295S3h3QUFuT21jakh5bEdo?=
 =?utf-8?B?QWpOaE44bDg0bU8yNnlVamlmNWlqSUFvVE40S09PQUxmS0FFRm0wQUhqamQ5?=
 =?utf-8?B?U3RWNCtDUGFqMXF3ZExPa1puaXpVeStLd0pqQmdJeldxK3oxMXdDQVI1OTJI?=
 =?utf-8?B?ZlIyVXk3bFRmd3BXV0IycHlCRjVRMDhXMHBhQ1U4NklGUFR0ZlI1TXFCZHZa?=
 =?utf-8?B?VVJxcVZnT0F2NllxbW9oYXZpT2VyaW5tZ1V0d0JmdXoxL1RvME1TdUpxSmtH?=
 =?utf-8?B?QVYxbHZqZUgzRmZFeThydjZZcEt6d3VlTXZCRThjUVR4a3EwYks3Nno4U3ZJ?=
 =?utf-8?B?Y2hCZzA3aENneWc3MW5vcDE1cVY0ZDFCT0xSdkVkbUxyQXkyWDE0Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca4e0ac2-f677-4533-324c-08da27604a7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2022 08:39:34.6122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oVdImOz1LywiOuuG5BxiT5QjmFO6OHE/cK2M4C2javxlxaf5lpQqW0HJG2BUVmBfTj68e8iQfNb0ZglHYqRZZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5652
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFR1ZXNk
YXksIEFwcmlsIDI2LCAyMDIyIDM6NTUgQU0NCj4gDQo+IEhpIEtldmluLA0KPiANCj4gT24gNC8x
OC8yMiAxMDo0OSBBTSwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4+IEZyb206IExpdSwgWWkgTCA8
eWkubC5saXVAaW50ZWwuY29tPg0KPiA+PiBTZW50OiBUaHVyc2RheSwgQXByaWwgMTQsIDIwMjIg
Njo0NyBQTQ0KPiA+Pg0KPiA+PiBUaGlzIHNlcmllcyBxb21pZmllcyB0aGUgVkZJT0NvbnRhaW5l
ciBvYmplY3Qgd2hpY2ggYWN0cyBhcyBhIGJhc2UgY2xhc3MNCj4gPiB3aGF0IGRvZXMgJ3FvbWlm
eScgbWVhbj8gSSBkaWRuJ3QgZmluZCB0aGlzIHdvcmQgZnJvbSBkaWN0aW9uYXJ5Li4uDQo+IHNv
cnJ5IHRoaXMgaXMgcHVyZSBRRU1VIHRlcm1pbm9sb2d5LiBUaGlzIHN0YW5kcyBmb3IgIlFFTVUg
T2JqZWN0IE1vZGVsIg0KPiBhZGRpdGlvbmFsIGluZm8gYXQ6DQo+IGh0dHBzOi8vcWVtdS5yZWFk
dGhlZG9jcy5pby9lbi9sYXRlc3QvZGV2ZWwvcW9tLmh0bWwNCj4gDQoNCk5pY2UgdG8ga25vdyEN
Cg==
