Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284047277EF
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 08:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbjFHG7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 02:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233910AbjFHG7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 02:59:07 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87DBE43;
        Wed,  7 Jun 2023 23:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686207546; x=1717743546;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=52Bw0V6wE0PNQU6f3iBoVKi1j1VxJz52TU/5oC1/S18=;
  b=P+jSRCxLrfrDdEtrvDzoC+C1elVPCWyYxjQINwHBOuGIwmcW6BTphYwb
   GiH3rmppmkjpER6wVTC2GeVJzzliWJH+9o5Vz2V/vZ08Qe4JtuD9e5vNv
   J6ts6V9PQvTC8U8RBk73EREgQ6Sc9E09XRGLg/d7rqfvNc2ZNRC8a0l4K
   yjYCJTlMES6vW9dBPssXarSaMYUCgZTUmBVyvMmf3WpryfS+WzsNAnDzP
   04I698Oh7XTgktPkuj4xQGj20MbEO+wM7h/3oOjd8Xx+wmbQ+QctBFlME
   e2bwcT8Ch2xLdLz/Q66Bm/1Rd1JGhn/Q3VJGPBzyO/jvAxj9JcjSkeeY+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="360562802"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="360562802"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 23:59:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="799707235"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="799707235"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Jun 2023 23:59:05 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 23:59:04 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 23:59:04 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 23:59:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIe/Cv1xjQexv0InvcG8GnTpImLdLGUjMqvStBYy/ApzF3tu3JYTtco3pkWofBfABBg0X+kSzvvGBwjiRT8sOgFVXS/nTKRPS0IZoK7l/39jEhA0y/ZE+8H+lf4qoI16hfAAF1P8WxiePZ60xLC2CInjqN7p0C4tojqwjhy1n7G9piBW7YDDt0Tt8pC5McfL8hANrBkdWtEUb2WoPIXKK24zIQD5t8w5vyBMD/j/Sm+WMgI5Ci/48aNYJ6WBoyg4M03LBDlH6vQxgoLXnTTvwQuyE1iczkGyYm9pFu1LXG+u449lSBQJMS5jFueXRrgJs3CWbTu6iZrBqRNqqtD66Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=52Bw0V6wE0PNQU6f3iBoVKi1j1VxJz52TU/5oC1/S18=;
 b=XcXwIYOm/krNi6WfopPPw21JLhwR+CpI48B5n41kXFju8HXUzIqXFf/kAhPU7dhl1n6kfOFnMIe8vygJTxlzX61B8RN6aBUUKMB0CdN0PSnmDa5Yrc2yC7w5KR4IvaD2gVZn7qV+5me4E9ZF0gGWGyRuuOwgtVJJAqqP5tCoBsgLsszyMe9JxNHcI1dyPS+AmhYRiLog2djizHrWKYEujtYoZNj8bFRB1Ts/SPnzp7MPXs4vW5CVcWIJz55zS6E5zcNPZKFUj7NCdK8ie7+TrV/+biHmvM/k7bbIctoUzA9kFg3GXbCgQqm50gv8l1yJ0sSKI0GxH/jTlAYpG7JQKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6763.namprd11.prod.outlook.com (2603:10b6:303:20b::7)
 by DS0PR11MB7410.namprd11.prod.outlook.com (2603:10b6:8:151::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 06:58:57 +0000
Received: from MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::ea27:a8a0:3e6:db89]) by MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::ea27:a8a0:3e6:db89%7]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 06:58:57 +0000
From:   "Jiang, Yanting" <yanting.jiang@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v12 00/24] Add vfio_device cdev for iommufd support
Thread-Topic: [PATCH v12 00/24] Add vfio_device cdev for iommufd support
Thread-Index: AQHZlUwkWtZUtk6Uz06mYlaw52cUZK+Ago7Q
Date:   Thu, 8 Jun 2023 06:58:57 +0000
Message-ID: <MW4PR11MB6763E2ACDE1A93F61E33E243E850A@MW4PR11MB6763.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
In-Reply-To: <20230602121653.80017-1-yi.l.liu@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6763:EE_|DS0PR11MB7410:EE_
x-ms-office365-filtering-correlation-id: 60dbad91-cd00-4373-cf08-08db67edd46f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7NCQ1ShgQo6e0DqXW6OAGhy4M1r0PZcQbkuBky6B6vJUOZVLZafD0nru1exdyTfN7WhX+BXKzbY77fLSIDP6E4uGh1sdRwy4Q0V1+4L2QwZ9B1uAnM/p53Qh57xM+Jo2H9QqthTcaYyhROjOJj6Hw226u6JKSkpL30vKD39sLAqdHhfcO2hKX63/43vgyQllnj5Mhn+GSdr76S83gUA9fypED8/CoQ3CQk7fuQrv4DbxRJeROQ5A9+J/cH3diZU/3G/xOEyGpiAV2QHdRUJk0WEPSb/Y1oC8HaPeD2ZmN1OzUCKduQR5Dkhm9uiQyFs1gMKGN/qkslNOOlvbveT2wufl86xjvYHcSTDc2IrPni4sq+OMnJ/rXr7fy7G5f3pX8D89zm6SinaCwd7/n+aI4Vz1vdyQhFYaNguaCyN9xzeLlEWhCK/xL+FRD6ofeOHbnuolzTs4QZ3EuhbInlKDmDFfhApy0HXDgVw7R2VTjnPlhn7dOp3Rl7unuGMQYC6bXhsVJRDwhxxSuFvTrre+PbQXQaiYjYROGo50VHOutsPSgCnbsP0oLWVE5pi5mUolg7jLbx9xQZZlHT5Oc6sjx5mFHGvMrNoUU/4LCmcJUD4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6763.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(396003)(136003)(376002)(346002)(451199021)(76116006)(26005)(9686003)(66446008)(6506007)(316002)(83380400001)(6636002)(64756008)(66556008)(4326008)(122000001)(66476007)(66946007)(966005)(7696005)(186003)(478600001)(33656002)(71200400001)(110136005)(54906003)(38070700005)(2906002)(5660300002)(8676002)(8936002)(82960400001)(55016003)(52536014)(86362001)(7416002)(41300700001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K20yaWNRb1diTGN2elViWXk0VjlqcEdqL08wWjNyaWl2UTUxcm13MHBEUzRk?=
 =?utf-8?B?ZW42TFo5M09VS25KL0lpZXNrK0g4T2o4MmpuT0psdmpCUC83em54R01hVGt6?=
 =?utf-8?B?L2twUFRlaVBvK2QrQTJxZllqTGtsOUQzMFFKdDM1eXloT3pvVWVzZDdEcGJs?=
 =?utf-8?B?UENaYTBNYngxSENRNUFhZXNwazh1WjQybW53MTc0MDl0eGRkRm5kYmtwTTQx?=
 =?utf-8?B?djhaeFZ4aHF1S1ZzVE5NMEhVazREcHB0a0t2T1FnT2tuRnU1UXBlNGNKNUo0?=
 =?utf-8?B?V1pZSHVVVGloWG9KYVFvODhxWUpDaXpQSGFrOFd2WmRJU0szbk1kMWZaRWZm?=
 =?utf-8?B?djlySVRMcTdJMXhQaUZZR1dPWWUwSmYrQjdiaDJHOElHL0JUU3YrN3Y3eHE5?=
 =?utf-8?B?SU9UTUxVQWdlOFhJSDhmeTVyUFlVVmljTHFmbjFaeTJMenVFd1VaL2FXRmpJ?=
 =?utf-8?B?aVhkRkhhamVGRGtTbTdzVTE2c3drRDJaZEtqK3VVdm1uM1hOMDFwQ0J6Y1RY?=
 =?utf-8?B?ZGFGTFFGbmpJUmhaYXg0R1k3ZFRIOSsrUkRzS3cxb1BzL2IwTkxPSDNFTDll?=
 =?utf-8?B?Rjc5dnFEeGNBQlR2c1NPSm40STE1V1FtZVFsZ3BjbDVHWWFPWm51eWdCT25l?=
 =?utf-8?B?aUJRN0VDa0cyYjZrSzdBMTd5dWVlQU1lemZ0NFI4dHZWVXM1K29wRnlyVjBS?=
 =?utf-8?B?QnZxZG53RTl2UVZLYWlPYVBtNU03cmdoa0dlOTJ2bnphQnFMQSs2QnlaU1Jv?=
 =?utf-8?B?YjNRNXI0V2NkczgxTStQRFdnbU9rY3MvWTVFampJb3VydXBVSFNVYSswZmR3?=
 =?utf-8?B?Ty9uRzB0NDVOL21Gb2NIUjV3b3owUUI2d2xQR3JSRGxJRTVHTUVsY2twSERH?=
 =?utf-8?B?bkxyTi8xZjdlRUxEaWFTZEtPdXZKYWNjTVdDaUNoNFdJUnR6UFQ5alNRbTF4?=
 =?utf-8?B?NWVoQnZyVmgzVHJxVEZJVDRQQlhHMDBHc2swZVB3R2ZHY3lpSW5DYU9YZHMx?=
 =?utf-8?B?ZEpvK1pmdHd0b1ZHM3RZVS85bTBXWS9iSkh4TWNZeC9zVzRUQXJjQmJMdjRN?=
 =?utf-8?B?UEU1bXNUaVcxemNYbHg3ejZSOTNkR0VjN1hiWWgzanJLZ0oyV1RHUm56cGRr?=
 =?utf-8?B?aXNqeWRnek02clRlRkxWVXhIOGxPTENhdWp4a0pybFNDbzZsa2U2UzdFdHVH?=
 =?utf-8?B?MVVrRTRWaHE5UWxDYVFCQlJDcFZia3ZsTHVmelVqTGdkanpxUGZNbWJFUUFO?=
 =?utf-8?B?V0VGMEtnSm9ucmlFVWZ3V0tUKzFWUk94dDdJVlZrcm1OMjlhMysxc0EwNTBK?=
 =?utf-8?B?WWdEdzNRZVRsMm1tTkJ3aWh4NnM2M2kwUzBqL2pJNkJsK1JoT1VpUjV6d2V3?=
 =?utf-8?B?akt0Q0ZlUDdBZWlucnFrSGtFRFRPa0tSeEhDdXZ4cHhpN2hxRkZVSXEycnhz?=
 =?utf-8?B?Z0dGanh3VWhZWTB3MjYzMVowZHV4ak84bFppalA3d29ULzhFYUZ4Q2IzMDdn?=
 =?utf-8?B?OFFBR29WV21vRFptMWczZzdOOGN6cFBiTi9WYkpOblNzam9CL3dESm1FemFM?=
 =?utf-8?B?dU5FMXFOc0liUkxnQTVPSlZEMURaOHByWTdtTTBqZFl1VXVaRmhSUE1lVUFz?=
 =?utf-8?B?SWNMUk9LRW9qMWtqaHo5VldOb3BpRWEwRzYvODN0Q1V1QTd5bHZSbVhDaEdY?=
 =?utf-8?B?S1cyRVdYTGhud01iRk9jcUF4WDNnOFZJTVMwUjZKMGR5WGgwZ0NJbnIxUUN1?=
 =?utf-8?B?VWg2Uy9KYXJwZWU5M2hLcDkyZXNtY0k5Q3ZlV2RlS0FwSGR2Wm5kc01pS1l3?=
 =?utf-8?B?bmIrZHBOTjVaY2VjS0tUMzlrSmRWRjE0azNuQjcxWGZyR2lqajlYbUFhYVYy?=
 =?utf-8?B?WEJNOXprUCs5ZjNEcE5nT2JWSHJkbHBVRU9HZHpocVhETEZ5czFDbjZjbjRk?=
 =?utf-8?B?aTJmWTFlVDFOMTN6bXlpUTl2d0lLZVhNRnFnbG1NR0RDMEN1bWFvTG82dTlS?=
 =?utf-8?B?Mm9RdEtJUFJtc2M3ZFpsS21SRCtHYVVqVVNDZmd3TDlqZm9SbnF0ZEhuanJ6?=
 =?utf-8?B?OFBKL01WTjhXN3hjbFFSUXZxS0h0djk1d3VBTGpCMktTZlhiOTMyblBpUHov?=
 =?utf-8?Q?g2cdvSfwEZGy7qYXdank3hXbR?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6763.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60dbad91-cd00-4373-cf08-08db67edd46f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 06:58:57.1562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pv/xDxqWmYfZytMp62vm01onDWALF4KHBv+aDZSJeeseKMQBFaHjwYXaO/ywcwdt8qousTYKHnYZSI1O2XdL4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7410
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

PiBTdWJqZWN0OiBbUEFUQ0ggdjEyIDAwLzI0XSBBZGQgdmZpb19kZXZpY2UgY2RldiBmb3IgaW9t
bXVmZCBzdXBwb3J0DQo+IA0KPiBFeGlzdGluZyBWRklPIHByb3ZpZGVzIGdyb3VwLWNlbnRyaWMg
dXNlciBBUElzIGZvciB1c2Vyc3BhY2UuIFVzZXJzcGFjZSBvcGVucw0KPiB0aGUgL2Rldi92Zmlv
LyRncm91cF9pZCBmaXJzdCBiZWZvcmUgZ2V0dGluZyBkZXZpY2UgZmQgYW5kIGhlbmNlIGdldHRp
bmcgYWNjZXNzDQo+IHRvIGRldmljZS4gVGhpcyBpcyBub3QgdGhlIGRlc2lyZWQgbW9kZWwgZm9y
IGlvbW11ZmQuIFBlciB0aGUgY29uY2x1c2lvbiBvZg0KPiBjb21tdW5pdHkgZGlzY3Vzc2lvblsx
XSwgaW9tbXVmZCBwcm92aWRlcyBkZXZpY2UtY2VudHJpYyBrQVBJcyBhbmQgcmVxdWlyZXMgaXRz
DQo+IGNvbnN1bWVyIChsaWtlIFZGSU8pIHRvIGJlIGRldmljZS1jZW50cmljIHVzZXIgQVBJcy4g
U3VjaCB1c2VyIEFQSXMgYXJlIHVzZWQgdG8NCj4gYXNzb2NpYXRlIGRldmljZSB3aXRoIGlvbW11
ZmQgYW5kIGFsc28gdGhlIEkvTyBhZGRyZXNzIHNwYWNlcyBtYW5hZ2VkIGJ5IHRoZQ0KPiBpb21t
dWZkLg0KPiANCj4gVGhpcyBzZXJpZXMgZmlyc3QgaW50cm9kdWNlcyBhIHBlciBkZXZpY2UgZmls
ZSBzdHJ1Y3R1cmUgdG8gYmUgcHJlcGFyZWQgZm9yIGZ1cnRoZXINCj4gZW5oYW5jZW1lbnQgYW5k
IHJlZmFjdG9ycyB0aGUga3ZtLXZmaW8gY29kZSB0byBiZSBwcmVwYXJlZCBmb3IgYWNjZXB0aW5n
DQo+IGRldmljZSBmaWxlIGZyb20gdXNlcnNwYWNlLiBBZnRlciB0aGlzLCBhZGRzIGEgbWVjaGFu
aXNtIGZvciBibG9ja2luZyBkZXZpY2UNCj4gYWNjZXNzIGJlZm9yZSBpb21tdWZkIGJpbmQuIFRo
ZW4gcmVmYWN0b3JzIHRoZSB2ZmlvIHRvIGJlIGFibGUgdG8gaGFuZGxlIGNkZXYNCj4gcGF0aCAo
ZS5nLiBpb21tdWZkIGJpbmRpbmcsIG5vLWlvbW11ZmQsIFtkZV1hdHRhY2ggaW9hcykuDQo+IFRo
aXMgcmVmYWN0b3IgaW5jbHVkZXMgbWFraW5nIHRoZSBkZXZpY2Vfb3BlbiBleGNsdXNpdmUgYmV0
d2VlbiB0aGUgZ3JvdXAgYW5kDQo+IHRoZSBjZGV2IHBhdGgsIG9ubHkgYWxsb3cgc2luZ2xlIGRl
dmljZSBvcGVuIGluIGNkZXYgcGF0aDsgdmZpby1pb21tdWZkIGNvZGUgaXMNCj4gYWxzbyByZWZh
Y3RvcmVkIHRvIHN1cHBvcnQgY2Rldi4gZS5nLiBzcGxpdCB0aGUgdmZpb19pb21tdWZkX2JpbmQo
KSBpbnRvIHR3bw0KPiBzdGVwcy4gRXZlbnR1YWxseSwgYWRkcyB0aGUgY2RldiBzdXBwb3J0IGZv
ciB2ZmlvIGRldmljZSBhbmQgdGhlIG5ldyBpb2N0bHMsIHRoZW4NCj4gbWFrZXMgZ3JvdXAgaW5m
cmFzdHJ1Y3R1cmUgb3B0aW9uYWwgYXMgaXQgaXMgbm90IG5lZWRlZCB3aGVuIHZmaW8gZGV2aWNl
IGNkZXYgaXMNCj4gY29tcGlsZWQuDQo+IA0KPiBUaGlzIHNlcmllcyBpcyBiYXNlZCBvbiBzb21l
IHByZXBhcmF0aW9uIHdvcmtzIGRvbmUgdG8gdmZpbyBlbXVsYXRlZCBkZXZpY2VzWzJdDQo+IGFu
ZCB2ZmlvIHBjaSBob3QgcmVzZXQgZW5oYW5jZW1lbnRzWzNdLg0KPiANCj4gVGhpcyBzZXJpZXMg
aXMgYSBwcmVyZXF1aXNpdGUgZm9yIGlvbW11IG5lc3RpbmcgZm9yIHZmaW8gZGV2aWNlWzRdIFs1
XS4NCj4gDQo+IFRoZSBjb21wbGV0ZSBjb2RlIGNhbiBiZSBmb3VuZCBpbiBiZWxvdyBicmFuY2gs
IHNpbXBsZSB0ZXN0cyBkb25lIHRvIHRoZQ0KPiBsZWdhY3kgZ3JvdXAgcGF0aCBhbmQgdGhlIGNk
ZXYgcGF0aC4gRHJhZnQgUUVNVSBicmFuY2ggY2FuIGJlIGZvdW5kIGF0WzZdDQo+IEhvd2V2ZXIs
IHRoZSBub2lvbW11IG1vZGUgdGVzdCBpcyBvbmx5IGRvbmUgd2l0aCBzb21lIGhhY2tzIGluIGtl
cm5lbCBhbmQNCj4gcWVtdSB0byBjaGVjayBpZiBxZW11IGNhbiBib290IHdpdGggbm9pb21tdSBk
ZXZpY2VzLg0KPiANCj4gaHR0cHM6Ly9naXRodWIuY29tL3lpbGl1MTc2NS9pb21tdWZkL3RyZWUv
dmZpb19kZXZpY2VfY2Rldl92MTINCj4gKGNvbmZpZyBDT05GSUdfSU9NTVVGRD15IENPTkZJR19W
RklPX0RFVklDRV9DREVWPXkpDQo+IA0KPiBiYXNlLWNvbW1pdDogMDk0OGZhMjlkNjJlY2E2Mjdh
MTlkNWIxNTM0MjYyYTZkOTNkNDE4MQ0KPiANCg0KVGVzdGVkIE5JQyBwYXNzdGhyb3VnaCBvbiBJ
bnRlbCBwbGF0Zm9ybS4NClJlc3VsdCBsb29rcyBnb29kIGhlbmNlLA0KVGVzdGVkLWJ5OiBZYW50
aW5nIEppYW5nIDx5YW50aW5nLmppYW5nQGludGVsLmNvbT4NCg0KVGhhbmtzLA0KWWFudGluZw0K
DQo=
