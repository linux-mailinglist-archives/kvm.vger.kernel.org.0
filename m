Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1E76DAB71
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 12:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240542AbjDGKXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 06:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233426AbjDGKXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 06:23:35 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4714C05;
        Fri,  7 Apr 2023 03:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680863014; x=1712399014;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WExVIseUscfGzi0DgdmVJZ5++2stfHSWEDOYY5FIVu4=;
  b=G4Rw2KMOqWoyTgGqxzWRnp+S9nMfjjRQajP+CPXVM584u8uJkdHq1wKs
   x7FSehaN2pg7hW/N15ZDV5VyVskv/tOBdRkWu2EDVwTUhooOcQ2epn3tB
   qdz4m2IwhsUUqmtW5Mbrcke4LzcA7qx2C+nMe1meAiHZdIlGQa7rQl/xf
   C21ErxYpEUb0gGgiez65zdvobJf5YmsHlssyol51c1JGzvpVQtUhvySBC
   rPIpNloq2enoWrlKcJa+DkIMF8617P/GFMQkYAtogTpXU4qt2uRpt4Txr
   4Gis1nrCxWdgbrtxyWcePeicXVEtcKyi4pZC5n8Io8IwNiqeOlsUkZBpf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="340455366"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="340455366"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 03:23:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="776802976"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="776802976"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Apr 2023 03:23:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 03:23:33 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 7 Apr 2023 03:23:33 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 7 Apr 2023 03:23:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwMezbzYst5kojvhvPJXcxDxvvxhSggFU2pdejv4la/t05Qe3IR/NHEnOK0gLLQA1BvFB0KD67Pd4PPV9gVM7LzW8zhXYRZOYuYPEVNgaRkprXsB6taSkUh4zElQZ2Yf9pr1hlGJd+0NHpfjBLAwvY3+dcZWR7Ry0ev5zVM0Ke9S5B03hfvOu1YPJ1bMzeu/JJ+hFDoBOCbJU8GY4Mf245veWYozpH8D6w2YgMux3SPSS3pxQefgBwCZGe1xDnoffLJAxnA6zNkP8yqJTZv7cJPqJeJ/Nb7Z6sctIgglGshZY8kib1BR56Rxq0gSx6PC8DEwLWEX5ka+iQ45hTSkMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WExVIseUscfGzi0DgdmVJZ5++2stfHSWEDOYY5FIVu4=;
 b=efZFgRGxdXnkfdVTXDdbV6BOyLQM8YFWLG+RCQKo5nNCPwqfARxiU8oloPrbZeiCdDM7pMDoXZ10YwXIRdZITUL7PeF1OL3FIPIXcwbenSLUROwp8XF75kNOvIhXxnj/cMdeJjxlfGyJln+HA0WFE6CxfWxwx/3J5+GXEfJbeIjHya08wZ4OmacL1C65UcMLvAjA7d1pKrmTaPK/RAEdgeQSOOwRC9O6VDu1qL9FEgsP8Wv6CTd/TFxw1SLnOHn4uTnwCoaX5UXrJKtLGrn8E3Q6fKCnXekxynZ15g3DbOgpv4+w8UQUgru6h4cX1IKssDU81C8/V5g2Gzfm4sbGFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BN9PR11MB5323.namprd11.prod.outlook.com (2603:10b6:408:118::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Fri, 7 Apr
 2023 10:23:30 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Fri, 7 Apr 2023
 10:23:30 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v9 06/25] kvm/vfio: Accept vfio device file from userspace
Thread-Topic: [PATCH v9 06/25] kvm/vfio: Accept vfio device file from
 userspace
Thread-Index: AQHZZK1APogyMqqusU2pI1gZ8bbduq8eEBeAgAAP8iCAAIniAIAAjJ1wgABd3YCAABcvcA==
Date:   Fri, 7 Apr 2023 10:23:30 +0000
Message-ID: <DS0PR11MB75295D9030BEF466A1F90F62C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401151833.124749-1-yi.l.liu@intel.com>
 <20230401151833.124749-7-yi.l.liu@intel.com>
 <8fb5a0b3-39c6-e924-847d-6545fcc44c08@redhat.com>
 <DS0PR11MB7529B8DC835A6EADDB815C04C3919@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230406125730.55bfa666.alex.williamson@redhat.com>
 <DS0PR11MB752903283C1E02708EC13848C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
 <5f8d9e23-8a4c-3f97-8f22-01eaa4eddfbb@redhat.com>
In-Reply-To: <5f8d9e23-8a4c-3f97-8f22-01eaa4eddfbb@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BN9PR11MB5323:EE_
x-ms-office365-filtering-correlation-id: 0dbff8d6-76a7-4ab1-f67a-08db37522246
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9q8YdXWI7T+u4o0NX4GrVMWwCf7KgD+JmkQNK3m5v6CBUhXLH5I4wMvtBq7ZTpj40WsAYFqL0Qu/W8pVM8BMmLKUBKaLio7Zunw/15Rb3MFOX6VoeodEdG5Z1npNHzSjM4BLaFqUv9miMozQGAQxP2Y+DXUyMqG3KIUW65Iyzuz8XEL/c5+LIUxBTcwpry6DQIk3QBWhnpCkJvAQt6DhfS0OJDr39gnMC83sajntVXkBUEhQul1VJV277+baYSrzj1i+YSbPyw20Ptqm4Pi9H1m06HUf3yuujFgr5s640GHuMvxMh64Ct8ipFAHxtZ6rT7maogixkuk/C99DQ8WCihwC0h/0piG6kuZ+NmATpJtMkvs4j5EmWvqJLMKoyurGJ4R7WTtGFEydQPjeuFdWhhfvVYmpg8G/A1XE1gFxI5HzpYtKHU4xJIqNNcN3+9yInQe/WBEtIBjEDxuqZq2i17SX3+sbMRtxcbsfBV2gMYZ4mqKF0Z7a45vFkNilMMk2Fmd8YMRXAtnju+t1SqZjfwlVbMMoMcMEAS5CAuSqTjPgPpjJdyBce0akRHAPOMtLyczpWdGjIm57MMAJX/Qz78gp86zO5XqRgofhA23xWfc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(136003)(39860400002)(376002)(346002)(451199021)(38100700002)(54906003)(110136005)(82960400001)(122000001)(316002)(38070700005)(83380400001)(478600001)(186003)(86362001)(66946007)(66556008)(66476007)(7416002)(33656002)(4326008)(8676002)(26005)(66446008)(53546011)(64756008)(76116006)(9686003)(6506007)(2906002)(5660300002)(966005)(8936002)(41300700001)(55016003)(52536014)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VHhmWGdYQ1pSKzNodHhNbzJBdVBDbHNJTXFDeWhhUzIyRGdscUlGeUtLSWt3?=
 =?utf-8?B?WEFRaTJwMzlXTlJJNnpFRXVWY1pjMzg5ZDJqQjBOb1VMQUlvUWV1T05kNjZK?=
 =?utf-8?B?dlZJck5MK0wvVlVoV1pnMEVuclluazhsMmV0cDZNelBkdkJUVHVFcDlEb3dW?=
 =?utf-8?B?d0JSbG1DZ0Q1SnMzOEkyVEtGRU5sOTI2NVdsck5mMFBMdVppOTdza3ByVy9M?=
 =?utf-8?B?QVRnU3psdUloSGUrOFhPNnd6dHFYVU14cytIVlozdFJEYzA1QytYdVowZm84?=
 =?utf-8?B?SlRxSm9NQjJEckRVWnl4clYrTE0wU0l3dE1RL3JibzJvN21CVWphZnVvUmdn?=
 =?utf-8?B?TEs5VklhdkYxSEpDTmo1V0xBdGpWdnVybVhQNmVzaGZrOWl0dHBoL0swTFlG?=
 =?utf-8?B?eWxSd0Q4VVB0eU9TRlNNRFVseC9EMnlXVExGWjVQS0hFQ0ZxTlYwL0JkUHEx?=
 =?utf-8?B?OE1sOEl3VTBuSTJUeTBMZTY0VGs4eFM2YXFkSGkwV0lpRW5JRko5MnhmeGd3?=
 =?utf-8?B?M2JGL0RFdHMyRjh6OXV5a1NVK2NCcVhjN2RMZWh0bHNSUVgybHBpbE56UU8w?=
 =?utf-8?B?eWhRNXJ2Mklrc044Z0dzYUNPblZhaDY5M3d6eFF0a215NFNBbkZtbXBlNTN4?=
 =?utf-8?B?U0doN1BEVzFkYUdvNXY2eWFvZVJZcnlBTVg3SkFXazYrTnM2SjVIOFA2a1Qw?=
 =?utf-8?B?dUp0NElMUzB6ekp4cFZuVGlLM1AwbjJNY2IyY0YwQ29acFBreHFBK3QrM2Yy?=
 =?utf-8?B?ODVsWmg4TXUxZURtRUJZSEU2ZDFsK0taR2RzU0UxVGJxbG9CNVhOWVBpNCs4?=
 =?utf-8?B?ZW1DbzNGZEdJK1pnZS9BWUcrR0JxMXdmeTk1bW5XR1d6RzJWMnM1OFRGKzhP?=
 =?utf-8?B?bjJSN2NINzBDUjVJbFdvMmVucm1XRHYya0szOXY0c3h6NGlmTlpDa0p3ZFJa?=
 =?utf-8?B?NWFUeDhTeDVhS0greGw0NHRpZDFld3dDcElUNDVmYldYczRYTmdRTWZ2SVBF?=
 =?utf-8?B?cFFUUTVReUxHWHNXak9QOUNrdEdCT2VsUTRKYTZzVEFrd3dFTWU2WDMzTSt6?=
 =?utf-8?B?VE1ybE9ORkIrNE5iWXk5UFRSZnhGblozQXlHVkMzUHpRVkQzT0VRS0VwUWpo?=
 =?utf-8?B?RnhuRmEyRXl6alBNYlNHWHM4NnMxRDdvRjVVak8xU3VMZmV2RVl5ZVRUcE1k?=
 =?utf-8?B?bGpMMGF5V1hNQlVpaWxaQ001N1JISEMybGZkRG5LVE85Nkd6K0JrWVhaVnd5?=
 =?utf-8?B?ZHY3T2FXSDJXcXRBOEx6WTBGak1DYkh2aHVrSWhWNEhSS0pES0hrUS9DS1kz?=
 =?utf-8?B?OFUvVlVuVTlwT2RGZ2ozVWFzcWpMZ1Q3Yk9EbmtYYnRUcTNsV1hSRHZYb1M5?=
 =?utf-8?B?K1d3Q3BLL2s4eUxhd3VnQlV0WnJkVUxmKzM3bGF5ajMxWUN0SnZEMmVyVlZU?=
 =?utf-8?B?S0RFd29yY1hUOTRscFlyRFFTZVAxUFRtUmpOdlJldzFoN1ZPVjh1MFI1OE9t?=
 =?utf-8?B?MytCTWppSVNqSzBvYk44dFk0WmNaanVJUXRsUU00STV6ZXczMVhTNmxiN3Rh?=
 =?utf-8?B?dmJSZHZWY3pwKzY4QUQwWGZiVVUva3dWWHVVdUkzbWtDT3pXY1ZTdmlSaHM4?=
 =?utf-8?B?V3l2aW5zMXFkYnNWaVBsNFZDQUdSMmcrM0QvaGhXbkI4cFN2Y2ZLNHREZ3RB?=
 =?utf-8?B?U2RwRktEY0FDTkpMNE1aM1ZGNFNNQ3BWc0JEOUw5TkphY2RlbzJQZi9uZThX?=
 =?utf-8?B?dEpydjdrNW5HaHlZTElGdUFiZ1BJQlZkc3VPOVhROXN4V0Nybnh0NFVvVi81?=
 =?utf-8?B?clVzZGx3alkwenpleHVaRnRQem1FRndGTFJyTUJVYXFaUzZNcVQ1d25WRFIw?=
 =?utf-8?B?UXJ0Tmp0N3R2cmFqNVZFSXN0TjFUT2tVWTA5elVwdFVkSVBaMUZCQ1FQQnlJ?=
 =?utf-8?B?SHczVVE3UEZPWmxnbzZSNDJ6WFhDYStFY0JFcEdiS3gxZ3ZrR1dqZFVrWXAy?=
 =?utf-8?B?bGxMV3ZJaFVBWnV5TUpNeFU1QjA5Mkc1Qm8vTU1TWGpGcisvZWNPM0VVZ2Jh?=
 =?utf-8?B?YXVpNG8wVHFhS3o2N1JxWjlsOUV5d2pIQTB4eEc2cUJUQzJqam1HRXU3YWtw?=
 =?utf-8?Q?6Ylw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dbff8d6-76a7-4ab1-f67a-08db37522246
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 10:23:30.4842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tKB1SDU4LHNFhdN4rxgR8gQL+IySQ+s7HLP2zsDioITqAZ2dOpOfo2HCYgYTKwMTO4FMMt6qNWYi5JG5A1DWQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5323
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IEZyaWRheSwgQXByaWwgNywgMjAyMyA0OjU3IFBNDQo+IA0KPiBIaSBZaSwNCj4gDQo+
IE9uIDQvNy8yMyAwNTo0MiwgTGl1LCBZaSBMIHdyb3RlOg0KPiA+PiBGcm9tOiBBbGV4IFdpbGxp
YW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiA+PiBTZW50OiBGcmlkYXksIEFw
cmlsIDcsIDIwMjMgMjo1OCBBTQ0KPiA+Pj4+IFlvdSBkb24ndCBzYXkgYW55dGhpbmcgYWJvdXQg
cG90ZW50aWFsIHJlc3RyaWN0aW9uLCBpZS4gd2hhdCBpZiB0aGUgdXNlciBjYWxscw0KPiA+Pj4+
IEtWTV9ERVZfVkZJT19GSUxFIHdpdGggZGV2aWNlIGZkcyB3aGlsZSBpdCBoYXMgYmVlbiB1c2lu
ZyBsZWdhY3kNCj4gPj4gY29udGFpbmVyL2dyb3VwDQo+ID4+Pj4gQVBJPw0KPiA+Pj4gbGVnYWN5
IGNvbnRhaW5lci9ncm91cCBwYXRoIGNhbm5vdCBkbyBpdCBhcyB0aGUgYmVsb3cgZW5oYW5jZW1l
bnQuDQo+ID4+PiBVc2VyIG5lZWRzIHRvIGNhbGwgS1ZNX0RFVl9WRklPX0ZJTEUgYmVmb3JlIG9w
ZW4gZGV2aWNlcywgc28gdGhpcw0KPiA+Pj4gc2hvdWxkIGhhcHBlbiBiZWZvcmUgX0dFVF9ERVZJ
Q0VfRkQuIFNvIHRoZSBsZWdhY3kgcGF0aCBjYW4gbmV2ZXINCj4gPj4+IHBhc3MgZGV2aWNlIGZk
cyBpbiBLVk1fREVWX1ZGSU9fRklMRS4NCj4gPj4+DQo+ID4+Pg0KPiA+Pg0KPiBodHRwczovL2xv
cmUua2VybmVsLm9yZy9rdm0vMjAyMzAzMjcxMDIwNTkuMzMzZDY5NzYuYWxleC53aWxsaWFtc29u
QHJlZGhhdC5jb20NCj4gPj4gLyN0DQo+ID4+DQo+ID4+IFdhaXQsIGFyZSB5b3Ugc3VnZ2VzdGlu
ZyB0aGF0IGEgY29tbWVudCBpbiB0aGUgZG9jdW1lbnRhdGlvbiBzdWdnZXN0aW5nDQo+ID4+IGEg
dXNhZ2UgcG9saWN5IHNvbWVob3cgcHJvdmlkZXMgZW5mb3JjZW1lbnQgb2YgdGhhdCBvcmRlcmlu
Zz8/ICBUaGF0J3MNCj4gPj4gbm90IGhvdyB0aGlzIHdvcmtzLiAgVGhhbmtzLA0KPiA+IEkgZG9u
J3Qga25vdyBpZiB0aGVyZSBpcyBhIGdvb2Qgd2F5IHRvIGVuZm9yY2UgdGhpcyBvcmRlciBpbiB0
aGUgY29kZS4gVGhlDQo+ID4gdmZpb19kZXZpY2UtPmt2bSBwb2ludGVyIGlzIG9wdGlvbmFsLiBJ
ZiBpdCBpcyBOVUxMLCB2ZmlvIGp1c3QgaWdub3JlcyBpdC4NCj4gPiBTbyB2ZmlvIGRvZXNuJ3Qg
aGF2ZSBhIGdvb2Qgd2F5IHRvIHRlbGwgaWYgdGhlIG9yZGVyIHJlcXVpcmVtZW50IGlzIG1ldCBv
cg0KPiA+IG5vdC4gUGVyaGFwcyBqdXN0IHRyaWdnZXIgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNl
IHdoZW4ga3ZtIHBvaW50ZXIgaXMgdXNlZA0KPiA+IGluIHRoZSBkZXZpY2UgZHJpdmVycyBsaWtl
IGt2bWd0IGlmIHRoaXMgb3JkZXIgaXMgbm90IG1ldC4NCj4gPg0KPiA+IFNvIHRoYXQncyB3aHkg
SSBjb21lIHVwIHRvIGRvY3VtZW50IGl0IGhlcmUuIFRoZSBhcHBsaWNhdGlvbnMgdXNlcyBrdm0N
Cj4gPiBzaG91bGQga25vdyB0aGlzIGFuZCBmb2xsb3cgdGhpcyBvdGhlcndpc2UgaXQgbWF5IGVu
Y291bnRlciBlcnJvci4NCj4gPg0KPiA+IERvIHlvdSBoYXZlIG90aGVyIHN1Z2dlc3Rpb25zIGZv
ciBpdD8gVGhpcyBvcmRlciBzaG91bGQgYmUgYSBnZW5lcmljDQo+ID4gcmVxdWlyZW1lbnQuIGlz
IGl0PyBncm91cCBwYXRoIGFsc28gbmVlZHMgdG8gZm9sbG93IGl0IHRvIG1ha2UgdGhlIG1kZXYN
Cj4gPiBkcml2ZXIgdGhhdCByZWZlcnMga3ZtIHBvaW50ZXIgdG8gYmUgd29ya2FibGUuDQo+IA0K
PiBJbiB0aGUgc2FtZSB3YXkgYXMga3ZtX3ZmaW9fZmlsZV9pc192YWxpZCgpIGNhbGxlZCBpbiBr
dm1fdmZpb19maWxlX2FkZCgpDQo+IGNhbid0IHlvdSBoYXZlIGEga2VybmVsIEFQSSB0aGF0IGNo
ZWNrcyB0aGUgZmQgY29uc2lzdGVuY2U/DQoNCkkgdGhpbmsgd2UgYXJlIHRhbGtpbmcgYWJvdXQg
aG93IHRvIGNoZWNrIGlmIHRoZSBvcmRlciBiZXR3ZWVuDQpLVk1fREVWX1ZGSU9fRklMRV9BREQg
YW5kIHRoZSBkZXZpY2Ugb3BlbiAoZS5nLiBpbnZva2VkIGJ5DQpWRklPX0dST1VQX0dFVF9ERVZJ
Q0VfRkQpIGlzIG1ldCBpbiB0aGUgY29kZSByYXRoZXIgdGhhbiBkb2N1bWVudA0KaXQgaGVyZS4g
QW0gSSBtaXNzaW5nIGFueXRoaW5nIGhlcmU/IE1heWJlIEkndmUgbWlzdW5kZXJzdG9vZCBBbGV4
J3MNCnF1ZXN0aW9uLiDimLkNCg0KUmVnYXJkcywNCllpIExpdQ0KDQo+IFRoYW5rcw0KPiANCj4g
RXJpYw0KPiA+DQo+ID4gVGhhbmtzLA0KPiA+IFlpIExpdQ0KPiA+DQo+ID4+Pj4+IC1UaGUgR1JP
VVBfQUREIG9wZXJhdGlvbiBhYm92ZSBzaG91bGQgYmUgaW52b2tlZCBwcmlvciB0byBhY2Nlc3Np
bmcgdGhlDQo+ID4+Pj4+ICtUaGUgRklMRS9HUk9VUF9BREQgb3BlcmF0aW9uIGFib3ZlIHNob3Vs
ZCBiZSBpbnZva2VkIHByaW9yIHRvIGFjY2Vzc2luZw0KPiB0aGUNCj4gPj4+Pj4gIGRldmljZSBm
aWxlIGRlc2NyaXB0b3IgdmlhIFZGSU9fR1JPVVBfR0VUX0RFVklDRV9GRCBpbiBvcmRlciB0byBz
dXBwb3J0DQo+ID4+Pj4+ICBkcml2ZXJzIHdoaWNoIHJlcXVpcmUgYSBrdm0gcG9pbnRlciB0byBi
ZSBzZXQgaW4gdGhlaXIgLm9wZW5fZGV2aWNlKCkNCj4gPj4+Pj4gLWNhbGxiYWNrLg0KPiA+Pj4+
PiArY2FsbGJhY2suICBJdCBpcyB0aGUgc2FtZSBmb3IgZGV2aWNlIGZpbGUgZGVzY3JpcHRvciB2
aWEgY2hhcmFjdGVyIGRldmljZQ0KPiA+Pj4+PiArb3BlbiB3aGljaCBnZXRzIGRldmljZSBhY2Nl
c3MgdmlhIFZGSU9fREVWSUNFX0JJTkRfSU9NTVVGRC4gIEZvciBzdWNoDQo+IGZpbGUNCj4gPj4+
Pj4gK2Rlc2NyaXB0b3JzLCBGSUxFX0FERCBzaG91bGQgYmUgaW52b2tlZCBiZWZvcmUNCj4gPj4g
VkZJT19ERVZJQ0VfQklORF9JT01NVUZEDQo+ID4+Pj4+ICt0byBzdXBwb3J0IHRoZSBkcml2ZXJz
IG1lbnRpb25lZCBpbiBwcmlvciBzZW50ZW5jZSBhcyB3ZWxsLg0KPiA+Pj4ganVzdCBhcyBoZXJl
LiBUaGlzIG1lYW5zIGRldmljZSBmZHMgY2FuIG9ubHkgYmUgcGFzc2VkIHdpdGggS1ZNX0RFVl9W
RklPX0ZJTEUNCj4gPj4+IGluIHRoZSBjZGV2IHBhdGguDQo+ID4+Pg0KPiA+Pj4gUmVnYXJkcywN
Cj4gPj4+IFlpIExpdQ0KDQo=
