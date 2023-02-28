Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22CA6A534E
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 07:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjB1G7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 01:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjB1G6v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 01:58:51 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4FA298E2;
        Mon, 27 Feb 2023 22:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677567523; x=1709103523;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V9ATX6fImnfXz/FUsByfntsCY5wB7qmVhuDhTRctzwo=;
  b=mlLp+/NKs9vTWKbDLWETeAypTpfC25lL0MBjZIJBh6CpKaMcC9xPaO+0
   lkaI0DBVVQMgzdaJ2qvCfqNN5yMlcI3LxGEqgzbLnuUOIdyF4Z7DAexkD
   B741DCvklGv9lE0xYoGOyRlRf2l6QhBfcn/kZnGVb2B/ufSMbzu0Ok1w5
   nDQmIxKXel3seds1flRIueejkZdtBq2lSWYB3EoMzAaWFBLjLHWakR241
   RF7AopUaZDAG8y4f6HlegwSGeN8redNkLKOPffiosKaxsaZoeqac1rwbs
   yEtJeNRBDKGYPq76ov4AqY1VDiYLD7JzbXNqqSr9QV43WmPR2z02SmApi
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="396629694"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="396629694"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 22:58:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="848151556"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="848151556"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 27 Feb 2023 22:58:41 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 22:58:41 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 27 Feb 2023 22:58:41 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 27 Feb 2023 22:58:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DgBt12EMTEMS3Cor2pHnVotLW4UE3ZtmHNSwnuSdAupnna0Gx7Xu2n1Jo5BWiO7Op9RK1eeOyEVGMbgHivYomenioEGrveRvE7VxA9LP4WuqZ37b6pH0iM8Lj2lKPtNQpmIE2ZcmPxy8MZv/8zI3Cr/aCHTizQHmKkCf48M2I24mUOSQVzID1fzjmNoM/yz28VAgYnw9HHSXhIPmLFlONTPbOHf+458F/Za0rBmDAdkPAM4c3FnblS5mwztRQMdMBmF4ffBu7InRt2F8R2dKmkvd7P7tk44MTZ5aMRYdZRrzkmo1uj7ESG8NFbqYeoPXyQEZrffjpHlusxRx1v1ejw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V9ATX6fImnfXz/FUsByfntsCY5wB7qmVhuDhTRctzwo=;
 b=NY5c0fojg/8alF+aV/3U8CmcVeGxeqPVZUBB7Th1Uz+H2mgdwi2WFSUY7tsVVbvBMRtAl5e+KaFPrQtKqLMp09S5BqIiE2XU2UInU7K0p7g0ZUX8HTP6nA80bIIiJ4Zjlgz9S2SQeJy4iWAoGZkzGvF6jtcpKPXjpn8WODwFQTDLAzWS8NpsacvWiGPaagxVQmaJlDI19NzYbpqQdoDZhEYoLnGpcW1q7521KAWzjD4lREYwJXAlAvbazEH2pKfLu1l/hRAshIPjcJbQHWy1hGu0/RadMgRifUM2RpCPM+UC0cWkWkeuNnN2IwVPKLZ2NAlnfy8PpJmaaGjShJz8PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7768.namprd11.prod.outlook.com (2603:10b6:8:138::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Tue, 28 Feb
 2023 06:58:39 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%9]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 06:58:38 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 10/19] vfio: Add infrastructure for bind_iommufd from
 userspace
Thread-Topic: [PATCH v5 10/19] vfio: Add infrastructure for bind_iommufd from
 userspace
Thread-Index: AQHZSpxK4wL3BAz2vkuMw78Q2DEYMa7jHbWAgACHOBCAAERLMA==
Date:   Tue, 28 Feb 2023 06:58:38 +0000
Message-ID: <DS0PR11MB75298144318DBA9690DC756FC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-11-yi.l.liu@intel.com> <Y/z2mY97uPsCs6Ix@nvidia.com>
 <DS0PR11MB75292E7DCC6FFEBF5B5DF66AC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB75292E7DCC6FFEBF5B5DF66AC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS0PR11MB7768:EE_
x-ms-office365-filtering-correlation-id: 3dd4c553-ee03-4f03-a5de-08db195937d2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e6TZUG4K16PBUTlOF4GnLWCAOqo1nxAD4EYqLZPU+gRFdesCpj9jI1vBz7+Q5RYw1RtXhoz7qi3uopWolsGmUMMyCmkYcaOJ1VaAkrcRV49iaVLzL7pzPbJZY8YK8dsPgS6piI7VzjAwMBG1psCyrKd1LAQDBQJGx0z371XE1vxjiAVdxAm4rP5JANEC3hRhgq+ipaPuz4gQnk29PuBGf5PRnlC6dow6edw30GwVWAFy093wRf7Q0l7TC8iUMKwgWfgryyVj+VnQYzqlPWS3QPo2B4kbNTUczKOBup1l1p++H/G74HB2pdsbe+tgbz0Pp1B9/J+7H6/y3aJdXqMVKO9Qyjo7BjtQOsq3kHAuXH7EGmdoVsZ1Uatl83ymn5xnZmcNACWyw5OriomzJOiEJGy9THSpwdJqQFSiZJZ5pDJ1oc6juC6YY+5bGfO8a/75QNHfY+7iyXR9S9R7XV3lIFbPClQBYLofqKH2tstUACLxD3lCw+Y3tynYb+FO2n+NI81DUXxSd2MIooLJBguuSS1t1dLBBgbHq4BvsndVyYfWSaWnV9D3msBZ69BhfXSqyMTmSlGD5cc5uJHm/VykUwE3ipvdgmIubybvMD8d5T9yzbmD3k/i2seJBixoxOKatV38UnePp7RAE589xK59SYVBht33vVbOTcTM6hqmqHuP1TPnPIicZ6iBGmbz5YAIdZ+KfVcA75x3LbQeLF7nZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199018)(33656002)(54906003)(316002)(83380400001)(71200400001)(66476007)(7696005)(6506007)(2940100002)(26005)(9686003)(5660300002)(478600001)(186003)(52536014)(8936002)(41300700001)(38070700005)(2906002)(86362001)(7416002)(66946007)(66556008)(76116006)(64756008)(38100700002)(8676002)(4326008)(6916009)(82960400001)(122000001)(55016003)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WFR5Y2RWYkM4SldZYTFVTWQ4TnRHU3dZVEZPeWFadzhFQUkvRTBrYjQvYWNh?=
 =?utf-8?B?K3NvUHpueVdMQWs5WldtV2t4VlN4NWFmUlpWb3pLWmhIVzlPRUtUdVJnd3ZL?=
 =?utf-8?B?dy9mdjd5Q2hJMnFXTkdxRUJVQTJ2TlcwUlFWbVd3YzNuZlBMbUlnOUJjcHZK?=
 =?utf-8?B?ZjYzN3lBTU1FZXhldTFiVUpsNWEraElOcUVENE9xQktRd0RIMjFvQXRMWFBq?=
 =?utf-8?B?d1dtQkRvU0oxUHYxMXd3MDI1aXhGWlBiYUxkZEdTTTFFVzM3dnBJZVpMV0FN?=
 =?utf-8?B?L2dydGdLb2FocWJURGsxeTk1dHppSXdoRnNObWp1dVk2eEVucENwSFVjUmVQ?=
 =?utf-8?B?UElYWVUzdStMYUttMUUrbU1nejBSQXZaVzhCZHlmVk45aXVxdVIzcWZXV2Q2?=
 =?utf-8?B?WFNmL09MbGdKUUx4STRLdHoxMnlKRGFPVmllNG0zaEtIZS9kSFdlMDRYckxF?=
 =?utf-8?B?ekI5S28vR2xiL1EyYjZtekEvL1Fvc2FOTit2RGVTMXgyYVhyZmFPMWgrdFZW?=
 =?utf-8?B?TzlVUVR3RWppcHpvbGd3dysrK2xFa2R2a1M1ZHJ4MVJsa2wzRk41dFM1VHU4?=
 =?utf-8?B?WUpmaXpoeFZBWlViNFBmMVBIejZJMkRBeXIrOTJ0bVFKN2xtY0I2UWc1WkdD?=
 =?utf-8?B?MnNUalV6RHoxeU9aSW9sNHYyUXU4MzNoL1daaVBXNW1YUlF2SXJ3aUpXdEZo?=
 =?utf-8?B?NzJVTFd6SG5nSGVKVTRDd3ovNHIwdEYzWi81ak56SG1zZ2NMekd4Q0s0eE9V?=
 =?utf-8?B?WUhjNzI4QUo5US85dEFyeDdSamFsRlZ1MGxxQnFUMTk4Q1dvMmkyRi85NEdN?=
 =?utf-8?B?OWZlMXhkcW1Hanc1dFBjOXdSNmY0dlJ3eWhkck5kRHFPMXQ0Z3RFQUlIaUFm?=
 =?utf-8?B?a3QxZU5oVXpFVDRUUjZlN0x1azIyd1ZjOEorMHFOSjFhcmtoY3V3a3d4Qm1L?=
 =?utf-8?B?b1FDeUpDZ3dxaUJYeVBMbjJMME0xenlaQWh4UG9LR1Eyd1NHV0Q5WkpEdmMr?=
 =?utf-8?B?aStGYUp3Zk85eW9XdThOTDJxb3ZNMXNRbGdXVWM3c1VhL3FZWWlRdTFLazQ2?=
 =?utf-8?B?VHQ3ejJCamxMNmtRN1ZLZGdnbk0xaVVhcHZGL2h1TWd4UFJQb1lGMVArTXZt?=
 =?utf-8?B?NUV3WFU0Y0UyMENGV0l0OGF6K2IveWJiSm9aNVZzcFQwWEQrVG5HRWJoMVZi?=
 =?utf-8?B?WUUyVXhhY0VDcDMyRVNmc1BUZUt2dUJFdUhxaTE0RnVKMDZqbTBYRXp6Q09t?=
 =?utf-8?B?T3NuNW9tcERNNFhyTDl2Sy96VGZQcGFZKzFKOUZnbUpIZTNxT3ppRHIrZUFX?=
 =?utf-8?B?bGtUTjBFNUYyMnQvaVZnRzQzS1R5M2l3VWRKaG84WERzaFpiUXE1K1ZHbnhq?=
 =?utf-8?B?Y2RTenVDVk4ybnBiMTZNMTl4WjBycUZLTDd1U3BsdDg3QjUxaXUwdjZlNFdo?=
 =?utf-8?B?NHJqRWVIeUZvbHVXQjdhMm1CTG8zQUxld2lIeFhtTkZmeFhkQStoMTQyQlRp?=
 =?utf-8?B?VGQxL1MwQUdmTXh4RjJWbWVLYjZ5bC96aHd1OEUwOW5hRFVRYmZiS3pyTzE3?=
 =?utf-8?B?WXpucERMUGVhUGZ5V0FlbHVpVFo2aEFZZEhudzNEUXdjdFVqVm1xS282cnRL?=
 =?utf-8?B?dHdJTTM2UlJoV3ZqaTFSRytjWDFWY2thR0JOdldOVlBDUW9vNGhMQ25IL1pR?=
 =?utf-8?B?QUVqWDk1d0REcFFIWTZqeDRmekc5OHhpYnZrTGNBb2JJN0FTSmYrVEpwbU80?=
 =?utf-8?B?Smo5VUNUNmgwWDVZMlpvdDJJaDduVWdnbGlnbi9kTkg4S3dDU2dHTHRQelpQ?=
 =?utf-8?B?SjExbERiU0cyTC9OZlR5NUN4RkIrRGphb1JLZDZTbkhMZGdhbHZCM2lrNkVy?=
 =?utf-8?B?NGVKLzQ2d0lNSHVlT2VEWTNFM1Y5S25yaVE1WVY3OWdrQVdETURCOGc1Rk14?=
 =?utf-8?B?Y1dBYlk0STVUSU51VUxUME9WYnIzZWhlM3ZnTkZMMmZ5VUZpdHZxa3NEcU9q?=
 =?utf-8?B?eGtmODVNZTNNVmlXb3FxRG1GWTdzQU12RjVwVW5kaEJ5Nm1zd2dCdnh3clJV?=
 =?utf-8?B?cHB0a0t6eEFNeDdDSVN3V2RZSnU2SFZyakpuSEVQYWtWL2J3ZDFMVXlaeUY5?=
 =?utf-8?Q?n+duw9ZTRJka10s2sW8M1rFJX?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dd4c553-ee03-4f03-a5de-08db195937d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 06:58:38.2236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oOStA15jmQlZzmyBjI86nuZmII17HHDkc1eQTdAOHxYBGyFILtpsDFaE5SQk8Xe+g4Dn1oPQ0t6umD79vRLNOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7768
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogVHVlc2RheSwg
RmVicnVhcnkgMjgsIDIwMjMgMTA6MzUgQU0NCj4gDQo+ID4gRnJvbTogSmFzb24gR3VudGhvcnBl
IDxqZ2dAbnZpZGlhLmNvbT4NCj4gPiBTZW50OiBUdWVzZGF5LCBGZWJydWFyeSAyOCwgMjAyMyAy
OjMwIEFNDQo+ID4NCj4gPiBPbiBNb24sIEZlYiAyNywgMjAyMyBhdCAwMzoxMToyNkFNIC0wODAw
LCBZaSBMaXUgd3JvdGU6DQo+ID4gPiBGb3IgdGhlIGRldmljZSBmZCBvcGVuZWQgZnJvbSBjZGV2
LCB1c2Vyc3BhY2UgbmVlZHMgdG8gYmluZCBpdCB0byBhbg0KPiA+ID4gaW9tbXVmZCBhbmQgYXR0
YWNoIGl0IHRvIElPQVMgbWFuYWdlZCBieSBpb21tdWZkLiBXaXRoIHN1Y2gNCj4gPiBvcGVyYXRp
b25zLA0KPiA+ID4gdXNlcnNwYWNlIGNhbiBzZXQgdXAgYSBzZWN1cmUgRE1BIGNvbnRleHQgYW5k
IGhlbmNlIGFjY2VzcyBkZXZpY2UuDQo+ID4gPg0KPiA+ID4gVGhpcyBjaGFuZ2VzIHRoZSBleGlz
dGluZyB2ZmlvX2lvbW11ZmRfYmluZCgpIHRvIGFjY2VwdCBhIHB0X2lkIHBvaW50ZXINCj4gPiA+
IGFzIGFuIG9wdGlvbmFsIGlucHV0LCBhbmQgYWxzbyBhbiBkZXZfaWQgcG9pbnRlciB0byBzZWxl
Y3RpdmVseSByZXR1cm4NCj4gPiA+IHRoZSBkZXZfaWQgdG8gcHJlcGFyZSBmb3IgYWRkaW5nIGJp
bmRfaW9tbXVmZCBpb2N0bCwgd2hpY2ggZG9lcyB0aGUNCj4gYmluZA0KPiA+ID4gZmlyc3QgYW5k
IHRoZW4gYXR0YWNoIElPQVMuDQo+ID4gPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogWWkgTGl1IDx5
aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gPiBSZXZpZXdlZC1ieTogS2V2aW4gVGlhbiA8a2V2aW4u
dGlhbkBpbnRlbC5jb20+DQo+ID4gPiAtLS0NCj4gPiA+ICBkcml2ZXJzL3ZmaW8vZ3JvdXAuYyAg
ICAgfCAxNyArKysrKysrKysrKysrKy0tLQ0KPiA+ID4gIGRyaXZlcnMvdmZpby9pb21tdWZkLmMg
ICB8IDIxICsrKysrKysrKy0tLS0tLS0tLS0tLQ0KPiA+ID4gIGRyaXZlcnMvdmZpby92ZmlvLmgg
ICAgICB8ICA5ICsrKysrKy0tLQ0KPiA+ID4gIGRyaXZlcnMvdmZpby92ZmlvX21haW4uYyB8IDEw
ICsrKysrKy0tLS0NCj4gPiA+ICA0IGZpbGVzIGNoYW5nZWQsIDM1IGluc2VydGlvbnMoKyksIDIy
IGRlbGV0aW9ucygtKQ0KPiA+ID4NCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8vZ3Jv
dXAuYyBiL2RyaXZlcnMvdmZpby9ncm91cC5jDQo+ID4gPiBpbmRleCBkODc3MWQ1ODVjYjEuLmU0
NDIzMjU1MTQ0OCAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvdmZpby9ncm91cC5jDQo+ID4g
PiArKysgYi9kcml2ZXJzL3ZmaW8vZ3JvdXAuYw0KPiA+ID4gQEAgLTE2OSw2ICsxNjksNyBAQCBz
dGF0aWMgdm9pZA0KPiA+IHZmaW9fZGV2aWNlX2dyb3VwX2dldF9rdm1fc2FmZShzdHJ1Y3QgdmZp
b19kZXZpY2UgKmRldmljZSkNCj4gPiA+ICBzdGF0aWMgaW50IHZmaW9fZGV2aWNlX2dyb3VwX29w
ZW4oc3RydWN0IHZmaW9fZGV2aWNlX2ZpbGUgKmRmKQ0KPiA+ID4gIHsNCj4gPiA+ICAJc3RydWN0
IHZmaW9fZGV2aWNlICpkZXZpY2UgPSBkZi0+ZGV2aWNlOw0KPiA+ID4gKwl1MzIgaW9hc19pZDsN
Cj4gPiA+ICAJaW50IHJldDsNCj4gPiA+DQo+ID4gPiAgCW11dGV4X2xvY2soJmRldmljZS0+Z3Jv
dXAtPmdyb3VwX2xvY2spOw0KPiA+ID4gQEAgLTE3Nyw2ICsxNzgsMTMgQEAgc3RhdGljIGludCB2
ZmlvX2RldmljZV9ncm91cF9vcGVuKHN0cnVjdA0KPiA+IHZmaW9fZGV2aWNlX2ZpbGUgKmRmKQ0K
PiA+ID4gIAkJZ290byBvdXRfdW5sb2NrOw0KPiA+ID4gIAl9DQo+ID4gPg0KPiA+ID4gKwlpZiAo
ZGV2aWNlLT5ncm91cC0+aW9tbXVmZCkgew0KPiA+ID4gKwkJcmV0ID0gaW9tbXVmZF92ZmlvX2Nv
bXBhdF9pb2FzX2lkKGRldmljZS0+Z3JvdXAtDQo+ID4gPmlvbW11ZmQsDQo+ID4gPiArCQkJCQkJ
ICAmaW9hc19pZCk7DQo+ID4gPiArCQlpZiAocmV0KQ0KPiA+ID4gKwkJCWdvdG8gb3V0X3VubG9j
azsNCj4gPiA+ICsJfQ0KPiA+DQo+ID4gSSBkb24ndCByZWFsbHkgbGlrZSB0aGlzIGJlaW5nIG1v
dmVkIG91dCBvZiBpb21tdWZkLmMNCj4gPg0KPiA+IFBhc3MgaW4gYSBOVUxMIHB0X2lkIGFuZCB0
aGUgZG8gc29tZQ0KPiA+DQo+ID4gPiAtaW50IHZmaW9faW9tbXVmZF9iaW5kKHN0cnVjdCB2Zmlv
X2RldmljZSAqdmRldiwgc3RydWN0IGlvbW11ZmRfY3R4DQo+ID4gKmljdHgpDQo+ID4gPiAraW50
IHZmaW9faW9tbXVmZF9iaW5kKHN0cnVjdCB2ZmlvX2RldmljZSAqdmRldiwgc3RydWN0IGlvbW11
ZmRfY3R4DQo+ID4gKmljdHgsDQo+ID4gPiArCQkgICAgICB1MzIgKmRldl9pZCwgdTMyICpwdF9p
ZCkNCj4gPiA+ICB7DQo+ID4gPiAtCXUzMiBpb2FzX2lkOw0KPiA+ID4gIAl1MzIgZGV2aWNlX2lk
Ow0KPiA+ID4gIAlpbnQgcmV0Ow0KPiA+ID4NCj4gPiA+IEBAIC0yOSwxNyArMjksMTQgQEAgaW50
IHZmaW9faW9tbXVmZF9iaW5kKHN0cnVjdCB2ZmlvX2RldmljZSAqdmRldiwNCj4gPiBzdHJ1Y3Qg
aW9tbXVmZF9jdHggKmljdHgpDQo+ID4gPiAgCWlmIChyZXQpDQo+ID4gPiAgCQlyZXR1cm4gcmV0
Ow0KPiA+ID4NCj4gPiA+IC0JcmV0ID0gaW9tbXVmZF92ZmlvX2NvbXBhdF9pb2FzX2lkKGljdHgs
ICZpb2FzX2lkKTsNCj4gPiA+IC0JaWYgKHJldCkNCj4gPiA+IC0JCWdvdG8gZXJyX3VuYmluZDsN
Cj4gPg0KPiA+ICAgaW9faW9tbXVmZF9iaW5kKHN0cnVjdCB2ZmlvX2RldmljZSAqdmRldiwgc3Ry
dWN0IGlvbW11ZmRfY3R4ICppY3R4LA0KPiA+IAkJICAgICAgdTMyICpkZXZfaWQsIHUzMiAqcHRf
aWQpDQo+ID4gew0KPiA+ICAgIHUzMiB0bXBfcHRfaWQ7DQo+ID4gICAgaWYgKCFwdF9pZCkgew0K
PiA+ICAgICAgICBwdF9pZCA9ICZ0bXBfcHRfaWQ7DQo+ID4gICAgICAgIHJldCA9IGlvbW11ZmRf
dmZpb19jb21wYXRfaW9hc19pZChpY3R4LCBwdF9pZCk7DQo+ID4gICAgICAgIGlmIChyZXQpDQo+
ID4gCQlnb3RvIGVycl91bmJpbmQ7DQo+ID4NCj4gPiAgICB9DQo+ID4NCj4gPiBUbyBoYW5kbGUg
aXQNCj4gPg0KPiA+IEFuZCB0aGUgY29tbWl0IG1lc3NhZ2UgaXMgc29ydCBvZiBvdXQgb2Ygc3lu
YyB3aXRoIHRoZSBwYXRjaCwgbW9yZSBsaWtlOg0KPiA+DQo+ID4gdmZpbzogUGFzcyB0aGUgcHRf
aWQgYXMgYW4gYXJndW1lbnQgdG8gdmZpb19pb21tdWZkX2JpbmQoKQ0KPiA+DQo+ID4gVG8gc3Vw
cG9ydCBiaW5kaW5nIHRoZSBjZGV2IHRoZSBwdF9pZCBtdXN0IGNvbWUgZnJvbSB1c2Vyc3BhY2Ug
aW5zdGVhZA0KPiA+IG9mIGJlaW5nIGZvcmNlZCB0byB0aGUgY29tcGF0X2lvYXNfaWQuDQo+ID4N
Cg0KU2VlbXMgbGlrZSBwdF9pZCBpcyBubyBtb3JlIG5lZWRlZCBpbiB0aGUgdmZpb19pb21tdWZk
X2JpbmQoKQ0Kc2luY2UgaXQgY2FuIGdldCBjb21wYXRfaW9hc19pZCBpbiB0aGUgZnVuY3Rpb24g
aXRzZWxmLiBDZGV2IHBhdGgNCm5ldmVyIHBhc3NlcyBhIHB0X2lkIHRvIHZmaW9faW9tbXVmZF9i
aW5kKCkgYXMgaXRzIGF0dGFjaCBpcyBkb25lDQpieSBzZXBhcmF0ZSBBVFRBQ0ggaW9jdGwuIENh
biB3ZSB1c2UgdGhlIGRldl9pZCBwb2ludGVyIHRvIGluZGljYXRlDQppZiBpdCBuZWVkcyB0byBn
ZXQgdGhlIGNvbXBhdCBpb2FzIGFuZCBhdHRhY2ggaXQ/DQoNCnZmaW9faW9tbXVmZF9iaW5kKHN0
cnVjdCB2ZmlvX2RldmljZSAqdmRldiwgc3RydWN0IGlvbW11ZmRfY3R4ICppY3R4LA0KCQkgICAg
ICB1MzIgKmRldl9pZCkNCnsNCi4uLg0KICAgICAgICBpZiAoIWRldl9pZCkgew0KICAgICAgICAg
ICAgIHUzMiBpb2FzX2lkOw0KDQogICAgICAgICAgICAgcmV0ID0gaW9tbXVmZF92ZmlvX2NvbXBh
dF9pb2FzX2lkKGljdHgsICZpb2FzX2lkKTsNCiAgICAgICAgICAgICBpZiAocmV0KQ0KCQlnb3Rv
IGVycl91bmJpbmQ7DQoNCiAgICAgICAgICAgICByZXQgPSB2ZGV2LT5vcHMtPmF0dGFjaF9pb2Fz
KHZkZXYsICZpb2FzX2lkKTsNCiAgICAgICAgICAgICBpZiAocmV0KQ0KCQlnb3RvIGVycl91bmJp
bmQ7DQogICAgICAgfQ0KLi4uDQp9DQoNClJlZ2FyZHMsDQpZaSBMaXUNCg==
