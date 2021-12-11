Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36878471156
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 04:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbhLKEBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 23:01:25 -0500
Received: from mga17.intel.com ([192.55.52.151]:40876 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236641AbhLKEBY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 23:01:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639195068; x=1670731068;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=px5ryPaPbSU/HCJY1QyMrBygmKfJeZENoNDDZuqBQ28=;
  b=Tsj1eVso093YGv6ncL4T8e//dJJC+dM8evzVQeBwWtCWd8dq+8d0BC0J
   vJjxlXJJb1TRznrABM6WYSyY4z4qwxIuIavi19I3o3Xz25zMqlzjzrT/M
   t3Obh78huatKKHPlax+2G7jgQIXsOvbtpFl3Kcy0BKHxul+4qAuUklkS7
   7nOXj93YRX/ABzV5NRJQf+hSzlVf+I2frdEpPVenSlhPmhWps9gb3y62j
   HIPhS4et6iozuliDcejyW55lOdVvBx7Vzpf3A1BaH4wuuqyolTGeEUKbL
   fNbInZ7dGQ8LTkQSaxr4WeSbSvgBh95b2Dcn4ZV1TvIMxy1IE9d3/myyE
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="219191281"
X-IronPort-AV: E=Sophos;i="5.88,197,1635231600"; 
   d="scan'208";a="219191281"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 19:57:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,197,1635231600"; 
   d="scan'208";a="565576679"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 10 Dec 2021 19:57:48 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 19:57:48 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 19:57:47 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 10 Dec 2021 19:57:47 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 10 Dec 2021 19:57:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyIEgTO2fhlSlU81MMUTNmkqKtvKhfIPs4e9egB+aTDiG/nGFrGmifkQXPr/Lm0ucigmwYOPgY7XKPpNlRphihXOB9/TUGsUsaAXZ0IuPSUz07AK1KMSlH3dAR/Y5x0bsaih7Ywlnx+VkV1trCJDcDMZE0bSRvHUrj5W1nUTVfPCXsHySPkd5in5C9aX+jyEIZP0EIjYqy6FmxJrupFhCMXL2bbswAhhIa54Fndky/bGxIyHuZfE5Rf3LEXbwLGxy19O9c04uQ3EHnWDWp68kPtAQwVVN8A52sCUlMJoxgLi/LAcfkvm9UxCHzS+LGC7No3LlxASUIiO/wZDRt+k6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=px5ryPaPbSU/HCJY1QyMrBygmKfJeZENoNDDZuqBQ28=;
 b=IQnxaYTvp9JvfCuXbqA/M9o3Z7OU3x4tGtvomddHJNm0Y6KvnIdTQ/E403/0R/otgPFBSL8JLggfoxq2e8bR33GyjI6cpb8gXEkrRPEk+0r1j/KGFa2XFNOvBgme0LxAXOl9T0nutiwmOK6BLr4nfpFq0DQGhC4o0wzYGcONm6jrcvR6pKc1iA4e5V5DFxP8S0Rs/43cNIKoGJr3JRTlNWsJ1vwj5Uo0RQ5ab0GBDVZn/tR2iKVGodP2NmS7rfFCTkWRzZvSRvGoN8kXGXt2V0eMHwShcMYkYgHDp2ikBvtOkJFlMSbPDHo6nt9rJqE7qny13EhGLnhVQyidrpAQcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=px5ryPaPbSU/HCJY1QyMrBygmKfJeZENoNDDZuqBQ28=;
 b=wGmCBDXD+6dU+EgxAxwRVh5GoVP7Wjc3ruN9WZHts4S9VDm5dEtQtneWkM7ObD0pjAcwxCMVfbIm0CF8CfgR0S+TeFJ8TNb9aUo4X6xYo/XbSQ3fEin1zdj2NP7ohj5ORNO+FrwOqZ+IbRcskBi5Os6ypsT+kBlzqiTVvCO2+4U=
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR1101MB2196.namprd11.prod.outlook.com (2603:10b6:405:52::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Sat, 11 Dec
 2021 03:57:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4755.016; Sat, 11 Dec 2021
 03:57:45 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vsethi@nvidia.com" <vsethi@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "wangxingang5@huawei.com" <wangxingang5@huawei.com>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Subject: RE: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Thread-Topic: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Thread-Index: AQHXyx+9zoVf6ec36EaoAw6mFm2RjKwlh1WAgAGLFwCAARJNAIAAUNaAgABaKgCAAEnegIAAE6oAgACHsjCAABVZoIAAzVeAgAED4rCAAGBlgIAA7M0A
Date:   Sat, 11 Dec 2021 03:57:45 +0000
Message-ID: <BN9PR11MB527694446B401EF9761529738C729@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
 <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
 <20211208125616.GN6385@nvidia.com> <YbDpZ0pf7XeZcc7z@myrica>
 <20211208183102.GD6385@nvidia.com>
 <BN9PR11MB527624080CB9302481B74C7A8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
 <BN9PR11MB5276D3B4B181F73A1D62361C8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20211209160803.GR6385@nvidia.com>
 <BN9PR11MB527612D1B4E0DC85A442D87D8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20211210132313.GG6385@nvidia.com>
In-Reply-To: <20211210132313.GG6385@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71de2ba9-90ff-4a10-703b-08d9bc5a63d8
x-ms-traffictypediagnostic: BN6PR1101MB2196:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR1101MB2196B63421418CF8230D657A8C729@BN6PR1101MB2196.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EKRiUMbXd/MvaJEAquGMJG9kWxSHsMoSI+6S09rmVUjugUX6fb32qxn5zYBCGYSQpj65dN7Q7DgMr1iAvhohHpryIZZDAsnodrGCpLfSw68OGZWFDgycdRH7020Uv0hJmquyJfgSi3tT5ngs9uxy8siy/fjI6HkAgPch1n4+MOBnHrNeDgBQ10wrCClTeRA9Sneh4qGZgpSV+biE8i8FYntXFSi/UVs878PuugORjVu0Rk9KHa9hH5r5iZkR303mzd2i4HmNKYLTDo42vtTjmhMzAmcnHqIWZiOt8s2I/8MTBovCgz5m/3Xr1b0KP3+c8W2tz79fQNT7VVgvZwEa++H95nTTZUsI59ouhNyGG+NIJNpKfsVhwi/BT6SIFp0YrkJ4I8R63cFz4494bTbrQsnmg4M/GnPtqvKcvMhYcnxGn2m44G6yxaMYM+Xv6h3Rb4u2NX8hK2Q7eY1cxEaqPO6s/XDZJ60Am1Wmejsbq1MwT+9WeTSScFIxpP4YxFF3kAEl+UQwaPPaXOJHv32pFEqQWN7EeUUitIty4QpxzJzN6zN2iy8KqE9uVHEIgMFM4CxUJGpUB4NzpNpizyETS6UGNXiFouGcLr7bZKs+pWlLxYAS9tdqbK4UQZdZF8LAxe4x9RDJRhs6w2kP8VvjtBSrQSGVQ3/uWS+Zpa15Ms62ljTE/Hj7Lw1CzsLlOJJpAgy1s3Fu4CloUXBtBGAOCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(64756008)(66446008)(82960400001)(66476007)(66556008)(6916009)(5660300002)(186003)(66946007)(76116006)(38070700005)(52536014)(83380400001)(508600001)(6506007)(7416002)(71200400001)(26005)(7696005)(316002)(8676002)(9686003)(33656002)(38100700002)(122000001)(55016003)(4326008)(86362001)(8936002)(2906002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjNnbkZadGxJWFU4SWhtNk9yMTBBQ3U1S2tWcUEyWE51MjNqeENQS2dXN2du?=
 =?utf-8?B?c3J1ZitTRlJxVTlzazd4SGd4NTBCNUdreFZNQVZvWVpGaE9xT25ZTnRNdEFP?=
 =?utf-8?B?Qm8rVTV2WXMvaDM3MHlma0U1elNkNWlDUm9wNyt0OCs1QVJLNnNsTldlbXBP?=
 =?utf-8?B?Mmprdi9zWWk2dTh6TDBzWFo4bG14STkrakRtQ3k4ZEJkTFhYWWU1eHY0UnZh?=
 =?utf-8?B?bHBVOWVJd0xKVnN2TlZGMTVXZmI1YjhhOER6UU1tM1VSYlJvY3ZRZGtPM1hq?=
 =?utf-8?B?bll5c2E1S3phR05hVEQwSWw4NTVrTGU5azR5N0J0RXpNTVQ1a0J1azA1YlVT?=
 =?utf-8?B?bUJQR0tSMzZjSmZwYWFsdDBlZFVzZnRWdzBBZm55c3RjNi9nV01Qd05sUlZH?=
 =?utf-8?B?cmhWQmU2WXZFSlpNT0VxNEYzYS8ydHNEclh6dlBHWHZMK3NrS1pBV2YraUVo?=
 =?utf-8?B?anM4QUgyY1YrQ1o3TllqNEdFcVNJRzBmVWNHSkJBR3UvU3pJaElpWndzcW90?=
 =?utf-8?B?QldiVm5LR0lKeElpWmM4KytlbFRCL0ZQTko2cXdJTk9rU3phcEM0NWdOVThl?=
 =?utf-8?B?NHU2dHRlZHBRbGl3RTBPcm9zdmdoUjBBWk1NZnBLWlF3T0M5WkVoZ2cvTU1T?=
 =?utf-8?B?ZXY5Uy9RemlCZ1V6dWpaL0J2ZEZQM1FhODU4OVN2ZEFxTGtvNHNXeVRSNTRp?=
 =?utf-8?B?WFdKRE94NXI5d0VlcEZib3BTdmllSnlmaE5xNjRzYnJOeGdQSE9PVDhsZWhY?=
 =?utf-8?B?VHk4amtraVErMU1ieHRPZGpVeGZveXRmUXlOS2dmS2tuMTd5U2dWVVJRVWg1?=
 =?utf-8?B?M1RkVWRvNGRuTU5MVkpFMHk4alNLRG03czVISnlJYkJIY3V0Q3Zidno1TUJl?=
 =?utf-8?B?NktLbmRmRXl5VTZoTnNqbTR1YVlER0xhQjQ3L2dWQlFwekxwajlKaUx6R3Q2?=
 =?utf-8?B?Qmx0aC9kQlRCUnd6cFNlVmhoVHFIOGp0aFZWdEZTYTFwVmN3Y0pRc05heW84?=
 =?utf-8?B?ZGdCNXNqbHkxVk9oTDNYcFRCdWVxTER1TWZiYm9GVTA2MFY0TGJpTXBqVEhR?=
 =?utf-8?B?TEViVmVHS1EycDJjbitaUlNrY0V3bmRJakx0UmFmQ2Q4dUJmRmRqKzdWQk1Y?=
 =?utf-8?B?QzhDTWVlZVlCaGtxdUNJLzd2VStGSUR5K1JKMmJiRCtHSFZISzRYU3d2MFFE?=
 =?utf-8?B?QVRBV3A4YkVKVEk1Q2V4VXk4alhaTTBXY0h6b0QwUGl3VXdvSXN0MmhucW5X?=
 =?utf-8?B?UzYyZVluRVFUSDk2b1pZQzJXZkZXeUhpSGI4b0RmeUo3RFRZUVduaG9pVzc0?=
 =?utf-8?B?VURSK1p3WGJNVENDTG1lYS91VUZ5MjZ4aGdGcXBFOE8vYXNDR2YyTnVWVndy?=
 =?utf-8?B?MTdUd1RxNTB5VDF6ckhIU1UwVDY3STVIejhrNU13NnpLUDlWME9LSkgxZk5J?=
 =?utf-8?B?RmdzUnd2U1VRTHJXd2RJS1dHdzVhUjdHVEE5YlZ0TXFtd0FsWm1Oclgxb1NG?=
 =?utf-8?B?enU5aTVUZ1U1ajk5V0lmY05FVVpUcHFGMUZDdEQ4K1FWZDY2Q3lkbWltUEVC?=
 =?utf-8?B?Nm1za3pFWVFnOXY0UXdJU3hTV3ZkOEUvRlArY1RWTXFBQ3l5WVpFekZ2aDJH?=
 =?utf-8?B?bkhqbllXSE9BbWZMV3Mwd2pyVzk2c2MwZnFUYUx0WmFjQXVIak53Q1lHQXZP?=
 =?utf-8?B?R1Z5T0FBMyt3QURFV2cyZE9kOVErYTZJTDlSYnZDSERBcytZVmFtUDBtU1h6?=
 =?utf-8?B?V3RMcGZNaGJMSGNJTXZyOXl6K2xScWVldzBDNWFrZER5TEVIUXhEMTQ2WE9a?=
 =?utf-8?B?NjlmMGMyQm5NclN3U1FWc2J3eEtGd0piWXdaYWlPQnZhMlJwYUNmTXc5UDhy?=
 =?utf-8?B?VW1Kd1pLT1ZybDVFTktxV01aTHdGQ1F0N2xYT3hLdTZOTkdONytRVWc3dm9p?=
 =?utf-8?B?TUNBNjBSWmdlaFhSSzJqVlZGMms0RHlFTEo5Tlk4UURPeE5tcDQ4KzF2Z3lX?=
 =?utf-8?B?b3BSazRoa2U3b25aQXZDMUZpbnAyU2xZaW13NjNXa2dHelNHWnV2M2JiYWZG?=
 =?utf-8?B?K3kwWThKemF3UVdYU0V0dzJKZ1lEazdxdzZBOGZuMXMzRXRsU2NLUy94dkJs?=
 =?utf-8?B?OTFtOUZGVng5bENHMEh5YnNmVXMyL1p1aFJja1hNU1YwYWgvT2YyYWJydW5C?=
 =?utf-8?B?eUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71de2ba9-90ff-4a10-703b-08d9bc5a63d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2021 03:57:45.6329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CyZc+gZjECU70DT++jWDyxxMu+979zQn5bORhQPxBsMubKLGClha4NZAd/eZ+HhSU0/2tzmVo8DvSQqOD9ZE9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2196
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBGcmlkYXks
IERlY2VtYmVyIDEwLCAyMDIxIDk6MjMgUE0NCj4gDQo+IE9uIEZyaSwgRGVjIDEwLCAyMDIxIGF0
IDA4OjU2OjU2QU0gKzAwMDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+ID4gU28sIHNvbWV0aGlu
ZyBsaWtlIHZmaW8gcGNpIHdvdWxkIGltcGxlbWVudCB0aHJlZSB1QVBJIG9wZXJhdGlvbnM6DQo+
ID4gPiAgLSBBdHRhY2ggcGFnZSB0YWJsZSB0byBSSUQNCj4gPiA+ICAtIEF0dGFjaCBwYWdlIHRh
YmxlIHRvIFBBU0lEDQo+ID4gPiAgLSBBdHRhY2ggcGFnZSB0YWJsZSB0byBSSUQgYW5kIGFsbCBQ
QVNJRHMNCj4gPiA+ICAgIEFuZCBoZXJlICdwYWdlIHRhYmxlJyBpcyBldmVyeXRoaW5nIGJlbG93
IHRoZSBTVEUgaW4gU01NVXYzDQo+ID4gPg0KPiA+ID4gV2hpbGUgbWRldiBjYW4gb25seSBzdXBw
b3J0Og0KPiA+ID4gIC0gQWNjZXNzIGVtdWxhdGVkIHBhZ2UgdGFibGUNCj4gPiA+ICAtIEF0dGFj
aCBwYWdlIHRhYmxlIHRvIFBBU0lEDQo+ID4NCj4gPiBtZGV2IGlzIGEgcGNpIGRldmljZSBmcm9t
IHVzZXIgcC5vLnYsIGhhdmluZyBpdHMgdlJJRCBhbmQgdlBBU0lELiBGcm9tDQo+ID4gdGhpcyBh
bmdsZSB0aGUgdUFQSSBpcyBubyBkaWZmZXJlbnQgZnJvbSB2ZmlvLXBjaSAoZXhjZXB0IHRoZSBB
Uk0gb25lKToNCj4gDQo+IE5vLCBpdCBpc24ndC4gVGhlIGludGVybmFsIG9wZXJhdGlvbiBpcyBj
b21wbGV0ZWx5IGRpZmZlcmVudCwgYW5kIGl0DQo+IG11c3QgY2FsbCBkaWZmZXJlbnQgaW9tbXVm
ZCBBUElzIHRoYW4gdmZpby1wY2kgZG9lcy4NCg0KV2VsbCwgeW91IG1lbnRpb25lZCAidUFQSSBv
cGVyYXRpb25zIiB0aHVzIG15IGVhcmxpZXIgY29tbWVudCANCmlzIHB1cmVseSBmcm9tIHVBUEkg
cC5vLnYgaW5zdGVhZCBvZiBpbnRlcm5hbCBpb21tdWZkIEFQSXMgKG5vdCBtZWFudA0KSSBkaWRu
J3QgdGhpbmsgb2YgdGhlbSkuIEkgdGhpbmsgdGhpcyBpcyB0aGUgbWFpbiBkaXZlcmdlbmNlIGlu
IHRoaXMgDQpkaXNjdXNzaW9uIGFzIHdoZW4gSSBzYXcgeW91IHNhaWQgIndoaWxlIG1kZXYgY2Fu
IG9ubHkgc3VwcG9ydCIgDQpJIGFzc3VtZSBpdCdzIHN0aWxsIGFib3V0IHVBUEkgKG1vcmUgc3Bl
Y2lmaWNhbGx5IFZGSU8gdUFQSSBhcyBpdCBjYXJyaWVzIA0KdGhlIGF0dGFjaCBjYWxsIHRvIGlv
bW11ZmQpLg0KDQo+IA0KPiBUaGlzIGlzIHVzZXIgdmlzaWJsZSAtIG1kZXYgY2FuIG5ldmVyIGJl
IGF0dGFjaGVkIHRvIGFuIEFSTSB1c2VyIHBhZ2UNCj4gdGFibGUsIGZvciBpbnN0YW5jZS4NCg0K
c3VyZS4gdGhlIGlvbW11IGRyaXZlciB3aWxsIGZhaWwgdGhlIGF0dGFjaCByZXF1ZXN0IHdoZW4g
c2VlaW5nDQppbmNvbXBhdGlibGUgd2F5IGlzIHVzZWQuDQoNCj4gDQo+IEZvciBpb21tdWZkIHRo
ZXJlIGlzIG5vIHZSSUQsIHZQQVNJRCBvciBhbnkgY29uZnVzaW5nIHN0dWZmIGxpa2UNCj4gdGhh
dC4gWW91J2xsIGhhdmUgYW4gZWFzaWVyIHRpbWUgaWYgeW91IHN0b3AgdGhpbmtpbmcgaW4gdGhl
c2UgdGVybXMuDQoNCkkgZG9uJ3QgaGF2ZSBhIGRpZmZpY3VsdHkgaGVyZSBhcyBmcm9tIHZmaW8g
dUFQSSBwLm8udiBpdCdzIGFib3V0DQp2UklEIGFuZCB2UEFTSUQuIEJ1dCB0aGVyZSBpcyBOTyBh
bnkgY29uZnVzaW9uIG9uIGlvbW11ZmQgd2hpY2gNCnNob3VsZCBvbmx5IGRlYWwgd2l0aCBwaHlz
aWNhbCB0aGluZy4gVGhpcyBoYXMgYmVlbiBzZXR0bGVkIGRvd24NCmxvbmcgdGltZSBhZ28gaW4g
aGlnaCBsZXZlbCBkZXNpZ24gZGlzY3Vzc2lvbi4g8J+Yig0KDQo+IA0KPiBXZSBwcm9iYWJseSBl
bmQgdXAgd2l0aCB0aHJlZSBpb21tdWZkIGNhbGxzOg0KPiAgaW50IGlvbW11ZmRfZGV2aWNlX2F0
dGFjaChzdHJ1Y3QgaW9tbXVmZF9kZXZpY2UgKmlkZXYsIHUzMiAqcHRfaWQsDQo+IHVuc2lnbmVk
IGludCBmbGFncykNCj4gIGludCBpb21tdWZkX2RldmljZV9hdHRhY2hfcGFzaWQoc3RydWN0IGlv
bW11ZmRfZGV2aWNlICppZGV2LCB1MzIgKnB0X2lkLA0KPiB1bnNpZ25lZCBpbnQgZmxhZ3MsIGlv
YXNpZF90ICpwYXNpZCkNCj4gIGludCBpb21tdWZkX2RldmljZV9hdHRhY2hfc3dfaW9tbXUoc3Ry
dWN0IGlvbW11ZmRfZGV2aWNlICppZGV2LCB1MzINCj4gcHRfaWQpOw0KDQp0aGlzIGlzIGFsaWdu
ZWQgd2l0aCBwcmV2aW91cyBkZXNpZ24uDQoNCj4gDQo+IEFuZCB0aGUgdUFQSSBmcm9tIFZGSU8g
bXVzdCBtYXAgb250byB0aGVtLg0KPiANCj4gdmZpby1wY2k6DQo+ICAgLSAnVkZJT19TRVRfQ09O
VEFJTkVSJyBkb2VzDQo+ICAgICBpb21tdWZkX2RldmljZV9hdHRhY2goaWRldiwgJnB0X2lkLCBJ
T01NVUZEX0ZVTExfREVWSUNFKTsNCj4gICAgICMgSU9NTVUgc3BlY2lmaWMgaWYgdGhpcyBjYXB0
dXJlcyBQQVNJRHMgb3IgY2F1c2UgdGhlbSB0byBmYWlsLA0KPiAgICAgIyBidXQgSU9NTVVGRF9G
VUxMX0RFVklDRSB3aWxsIHByZXZlbnQgYXR0YWNoaW5nIGFueSBQQVNJRA0KPiAgICAgIyBsYXRl
ciBvbiBhbGwgaW9tbXUncy4NCj4gDQo+IHZmaW8tbWRldjoNCj4gICAtICdWRklPX1NFVF9DT05U
QUlORVInIGRvZXMgb25lIG9mOg0KPiAgICAgaW9tbXVmZF9kZXZpY2VfYXR0YWNoX3Bhc2lkKGlk
ZXYsICZwdF9pZCwgSU9NTVVGRF9BU1NJR05fUEFTSUQsDQo+ICZwYXNpZCk7DQo+ICAgICBpb21t
dWZkX2RldmljZV9hdHRhY2hfc3dfaW9tbXUoaWRldiwgcHRfaWQpOw0KPiANCj4gVGhhdCBpcyB0
aHJlZSBvZiB0aGUgY2FzZXMuDQo+IA0KPiBUaGVuIHdlIGhhdmUgbmV3IGlvY3RscyBmb3IgdGhl
IG90aGVyIGNhc2VzOg0KPiANCj4gdmZpby1wY2k6DQo+ICAgLSAnYmluZCBvbmx5IHRoZSBSSUQs
IHNvIHdlIGNhbiB1c2UgUEFTSUQnDQo+ICAgICBpb21tdWZkX2RldmljZV9hdHRhY2goaWRldiwg
JnB0X2lkLCAwKTsNCj4gICAtICdiaW5kIHRvIGEgc3BlY2lmaWMgUEFTSUQnDQo+ICAgICBpb21t
dWZkX2RldmljZV9hdHRhY2hfcGFzaWQoaWRldiwgJnB0X2lkLCAwLCAmcGFzaWQpOw0KPiANCj4g
dmZpby1tZGV2Og0KPiAgIC0gJ2xpa2UgVkZJT19TRVRfQ09OVEFJTkVSIGJ1dCBiaW5kIHRvIGEg
c3BlY2lmaWMgUEFTSUQnDQo+ICAgICBpb21tdWZkX2RldmljZV9hdHRhY2hfcGFzaWQoaWRldiwg
JnB0X2lkLCAwLCAmcGFzaWQpOw0KPiANCj4gVGhlIGlvbW11IGRyaXZlciB3aWxsIGJsb2NrIGF0
dGFjaG1lbnRzIHRoYXQgYXJlIGluY29tcGF0aWJsZSwgaWUgQVJNDQo+IHVzZXIgcGFnZSB0YWJs
ZXMgb25seSB3b3JrIHdpdGg6DQo+ICBpb21tdWZkX2RldmljZV9hdHRhY2goaWRldiwgJnB0X2lk
LCBJT01NVUZEX0ZVTExfREVWSUNFKQ0KPiBhbGwgb3RoZXIgY2FsbHMgZmFpbC4NCg0KQWJvdmUg
YXJlIGFsbCBnb29kIGV4Y2VwdCB0aGUgRlVMTF9ERVZJQ0UgdGhpbmcuDQoNClRoaXMgbWlnaHQg
YmUgdGhlIG9ubHkgb3BlbiBhcyBJIHN0aWxsIGRpZG4ndCBzZWUgd2h5IHdlIG5lZWQgYW4NCmV4
cGxpY2l0IGZsYWcgdG8gY2xhaW0gYSAnZnVsbCBkZXZpY2UnIHRoaW5nLiBGcm9tIGtlcm5lbCBw
Lm8udiB0aGUNCkFSTSBjYXNlIGlzIG5vIGRpZmZlcmVudCBmcm9tIEludGVsIHRoYXQgYm90aCBh
bGxvd3MgYW4gdXNlcg0KcGFnZSB0YWJsZSBhdHRhY2hlZCB0byB2UklELCBqdXN0IHdpdGggZGlm
ZmVyZW50IGZvcm1hdCBhbmQNCmFkZHIgd2lkdGggKEludGVsIGlzIDY0Yml0LCBBUk0gaXMgODRi
aXQgd2hlcmUgUEFTSUQgY2FuIGJlDQpjb25zaWRlcmVkIGEgc3ViLWhhbmRsZSBpbiB0aGUgODRi
aXQgYWRkcmVzcyBzcGFjZSBhbmQgbm90DQp0aGUga2VybmVsJ3MgYnVzaW5lc3MpLg0KDQphbmQg
QVJNIGRvZXNuJ3Qgc3VwcG9ydCBleHBsaWNpdCBQQVNJRCBhdHRhY2ggdGhlbiB0aG9zZSBjYWxs
cw0Kd2lsbCBmYWlsIGZvciBzdXJlLg0KDQo+IA0KPiBIb3cgZXhhY3RseSB3ZSBwdXQgYWxsIG9m
IHRoaXMgaW50byBuZXcgaW9jdGxzLCBJJ20gbm90IHN1cmUsIGJ1dCBpdA0KPiBkb2VzIHNlZW0g
cHJldHR5IGNsZWFyIHRoaXMgaXMgd2hhdCB0aGUgaW9tbXVmZCBrQVBJIHdpbGwgbmVlZCB0byBs
b29rDQo+IGxpa2UgdG8gY292ZXIgdGhlIGNhc2VzIHdlIGtub3cgYWJvdXQgYWxyZWFkeS4NCj4g
DQo+IEFzIHlvdSBjYW4gc2VlLCB1c2VycGFjZSBuZWVkcyB0byB1bmRlcnN0YW5kIHdoYXQgbW9k
ZSBpdCBpcyBvcGVyYXRpbmcNCj4gaW4uIElmIGl0IGRvZXMgSU9NTVVGRF9GVUxMX0RFVklDRSBh
bmQgbWFuYWdlcyBQQVNJRCBzb21laG93IGluDQo+IHVzZXJzcGFjZSwgb3IgaXQgZG9lc24ndCBh
bmQgY2FuIHVzZSB0aGUgaW9tbXVmZF9kZXZpY2VfYXR0YWNoX3Bhc2lkKCkNCj4gcGF0aHMuDQo+
IA0KPiA+IElzIG1vZGVsaW5nIGxpa2UgYWJvdmUgY29uc2lkZXJlZCBhbWJpZ3VvdXM/DQo+IA0K
PiBZb3UndmUgc2tpcHBlZCBzdHJhaWdodCB0byB0aGUgaW9jdGxzIHdpdGhvdXQgZGVzaWduaW5n
IHRoZSBrZXJuZWwgQVBJDQo+IHRvIG1lZXQgYWxsIHRoZSByZXF1aXJlbWVudHMgIDopDQo+IA0K
DQpObyBwcm9ibGVtIG9uIHRoaXMuIEp1c3Qgd2UgZm9jdXMgb24gZGlmZmVyZW50IG1hdHRlciBp
biB0aGlzIGRpc2N1c3Npb24uDQpBcyBJIHJlcGxpZWQgSSB0aGluayB0aGUgb25seSBvcGVuIGlz
IHdoZXRoZXIgQVJNIHRoaW5nIG5lZWRzIHRvIGJlDQpzcGVjaWFsaXplZCB2aWEgYSBuZXcgaW9j
dGwgb3IgZmxhZy4gT3RoZXJ3aXNlIGFsbCBvdGhlciB0aGluZ3MgYXJlIGFsaWduZWQuIA0KDQpU
aGFua3MNCktldmluDQo=
