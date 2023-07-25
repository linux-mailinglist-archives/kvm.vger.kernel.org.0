Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84FD476095E
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 07:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbjGYFhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 01:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjGYFhT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 01:37:19 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64861737;
        Mon, 24 Jul 2023 22:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690263437; x=1721799437;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pm/0IYkyiift7BhqvoaMSVvoEeuaaVV5xEl9dBUSrmw=;
  b=jJgRSMlM3FOriCv9qiDoK48Olx7dbcThZ8q6n98s5XBq+5PUqnnD13pv
   U7rLyPayUI59hqVujD8DKDdgbLjUSej6ncHPeVO3Kx/wBiQqyqkb0wESo
   tBnKL5Opdi0JWqXuRpJrkYD88AGt6avndpAYnKnJkTXWXE/JCw903J3QB
   SszqlIKZgtaZR8MzZqTg4jWWi2AYbLOyOnQvKIl2DqipLF6p+2LhZYUG5
   J4dA0OQaKGvQhgcSlc6EmMN3NMpQHHAqtAuNemlGXLY+h5k3pyUrn4k4K
   OOYE+qvsrO46dMKa/NaH9CbLkd2hvsvb/0qthvtaUSGaG5HYdQhV4b6wS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="347895672"
X-IronPort-AV: E=Sophos;i="6.01,229,1684825200"; 
   d="scan'208";a="347895672"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 22:37:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="729204409"
X-IronPort-AV: E=Sophos;i="6.01,229,1684825200"; 
   d="scan'208";a="729204409"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 24 Jul 2023 22:37:16 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 24 Jul 2023 22:37:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 24 Jul 2023 22:37:16 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 24 Jul 2023 22:37:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eMsA7msRdeVwJ9Jdo0qVIRyS4uNbJkvVTq4jqZcbnvJGLL3VY8V0b5ByOv2/PfrkUoDEpsLEDGHt7mhCGEkmNU82tb698DDvilrDkFsZ9lr+OuTQPbQ7D4GE9FQE3hd3kCcFLLRhutVzLcDrdiBWwDavPh7I3jUwTrDZT9G8axuCAUakVIz/QKnV6tTwFlF/apde9NiGB2IgDomMrzVICOUFUdCt+Ya5bdvuw78zew+KNh/g6TthBkWZePucvhIMThqoI3yhkPjR/Y1XIyzzz0FQQSSgU8cZpr2w5O1hjSQkHrcNg6xNBDTBz4LrqAmf8jGvlp/Qtu0JL1kZKfhIhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pm/0IYkyiift7BhqvoaMSVvoEeuaaVV5xEl9dBUSrmw=;
 b=KeWdp+XcgfjvKvyPoFrjkiwYOPU27vlvCQtx3qKI4pFYL0ei2U9uJqKcS0YFb4m4kElVj9u8Qj7Nw6RHogLKclqGVFKA4gG+xt3GXX60NdRmCuqFbNPRroWL0yNvRTDvybeU4L6rA/pVNHFVKt84TKZVRnNR9LdxI0lG77SzqqgGS8bAvvW+YsYBXPXcGWcx2T54nGKh0KnQWGPw0YB4FPTnU7cjfKia+hpyUP6iH8uFEBOJjEiTV4lEmAhdxRcj4nTJ0nnuLWE9mkkzKemKRv6V+QroqSLJhbNho0EAmtkRoQyI2sKi/3FgN5u+YoxVYMpKEDL3UGgVBcwpckjsEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4SPRMB0075.namprd11.prod.outlook.com (2603:10b6:303:20d::13)
 by MN2PR11MB4646.namprd11.prod.outlook.com (2603:10b6:208:264::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 05:37:14 +0000
Received: from MW4SPRMB0075.namprd11.prod.outlook.com
 ([fe80::98e5:837d:71bb:d61f]) by MW4SPRMB0075.namprd11.prod.outlook.com
 ([fe80::98e5:837d:71bb:d61f%4]) with mapi id 15.20.6609.032; Tue, 25 Jul 2023
 05:37:13 +0000
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
Subject: RE: [PATCH v14 00/26] Add vfio_device cdev for iommufd support
Thread-Topic: [PATCH v14 00/26] Add vfio_device cdev for iommufd support
Thread-Index: AQHZs6O3QpbNRSG4YE6K+c8ZY6cMlq/KDK9w
Date:   Tue, 25 Jul 2023 05:37:13 +0000
Message-ID: <MW4SPRMB0075558C522428EA5A40F43EE803A@MW4SPRMB0075.namprd11.prod.outlook.com>
References: <20230711025928.6438-1-yi.l.liu@intel.com>
In-Reply-To: <20230711025928.6438-1-yi.l.liu@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4SPRMB0075:EE_|MN2PR11MB4646:EE_
x-ms-office365-filtering-correlation-id: 997774a4-f076-4e6d-f59e-08db8cd1331c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8JCHTbZoD/NqLQx/NnadoW95LY9Bpdw9DqH7rKCDNj5+cV+hxOdU35XOO3G0MQIq+55YMOXMhbQ3LK9oJQfL7olhso5tkZt1wdP3nPQFziyW26c9aVO/NUPlAtGzgTEY+gp6nmjffuD1CDNa8gsyrPu4CkKLkHZeuYIFmB1TK1o87jRrstF/6EFKxWXlOQ5hzNJ9dEoZkB2QBoqPKTVmCoxDX/ktd/P7/aJilrpYQlJ+J7T02yTOiXZQUJ8z31G0bvAZzLihLO3mHZt/+WKkqm5YjuO6GWZUb8Av9m8vJQWelnwTO9Q9OXt+0dyDYvpak1sadSCnDpn9JPwpUpGZ1ViBBx6hMbkTAse9L4I/EnU0crx8G02z2iwNJhI0nTk/yOlJzqqc7zqxbv6iYg+lsoCoDK6v1h1yOH+HtW7g8zWirpmDpMx2rc2eD4Dfi9fIdOPZYFVDJcN69OCOTaccwWY9ogZux0vg6q9YwqHD/pxfQyjPI1bG7Zdytxu/HGvEY5SXIRlUElLUtmjWGsbZ7CgbNmClANfFpdnK9HAHWtVks99JKwkhRwK0r+snYMB/euwdJz/q1IhrL2N6TRV8hUz8Wyb8KuM9GZfGOCJtXXY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4SPRMB0075.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199021)(55016003)(186003)(26005)(71200400001)(6506007)(64756008)(83380400001)(66946007)(66556008)(316002)(6636002)(76116006)(66476007)(4326008)(66446008)(7416002)(52536014)(41300700001)(7696005)(8676002)(8936002)(966005)(5660300002)(9686003)(2906002)(110136005)(54906003)(478600001)(38100700002)(82960400001)(122000001)(33656002)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OUpxTVpPb2tYSW9WSlRUekhzSG95UUsxYkE0Z2NGaWVNUnlRV3drZlBuYzZL?=
 =?utf-8?B?N2hwYis0NmVSRDdWa0F6bGRLdE1TTTBFMEpvVnJPZFJUSXN4SDUzS2s3UnNL?=
 =?utf-8?B?NFI3UXpQdVk4WVJLZkdrQUkwdFpFTnpUZUxQb2NSREpHMUFTSGFUeDBOemh3?=
 =?utf-8?B?MUVmeTVWQmRUOXQzdDJmYUoycVc3WXdvS0VTU0RoaHdLRHMrQTFFZWptOEx4?=
 =?utf-8?B?RVRaVDZ6djNtaU9lUDUzcWZHaGlVbFJTTGt6MDlkZlJCWmVxVDZYQ0dsREdr?=
 =?utf-8?B?N1E5RytJOW5TeEVzUXg1V0lPNWxWS2xaSlBZL0Y2ZXkzZWpyNHI3ZG9la21O?=
 =?utf-8?B?UmRoWlFIdStLemxoWEZwUXZ6Q28zd245Wit4eEg0TG5ieXFhWitrYkprMVhk?=
 =?utf-8?B?aWlvbUhwaUJrL2ZhR2NEYWYxVHROZWo3U0Z5dmxFLzVhblJSVTFkb3dqenN2?=
 =?utf-8?B?QUZUR3VidVVtenB3cVZZWDZmbXRWNkkrNmlaekwzdDBQY1luREtJODE0bmRJ?=
 =?utf-8?B?SmFUNWNlMG5uN3dhL0tEZk1LY0tTTUMzdGo1SVpDT0pDTHFBY1RYQnpXMXB0?=
 =?utf-8?B?ZjhkaktnNWF3NTdkenZuU3RNNEVNaGVnQjQ1aVU2TlZsK0t6d3JYMlpHUnNy?=
 =?utf-8?B?VHZCQ2pJQ2RNM3gvWVdOclhnQTgvZGpjdGR2L2xWdm1DR0IvUnZPN2hMWjdD?=
 =?utf-8?B?d3djcUw3YWVXN1ZrUUJBZVViMHhUaEc4dW9zbFUxOTZkdEtJZjc3RTFCWTFJ?=
 =?utf-8?B?eFd4YkpISTJadHZxY0dRejArbkN2Znd4RGVTK2JSbG9FWnNIcWlkZFpMNVNM?=
 =?utf-8?B?SFRxL0FBVUtFU0NTbnZRTURIUGFvRHllVjZWcE5NUWt4eHJZa1QvRks3UnhZ?=
 =?utf-8?B?R2FsYzhhTzRNRFgzU05nUW5CN1lzUkZ3aWM5T3p0ZkM1ZlBqL05pSjJnN3Ru?=
 =?utf-8?B?YUJCYVNaSDl4NTdNajlMaEZqWkZLRjZjTnhJTXBENUJtdnRVWi9QRnpDdWRJ?=
 =?utf-8?B?QlNlY3NxTzd3SDM1NTM2bDJ1YW5DaE4zTVAvSjdHaFQrVlQxOTV2WmJUTkpj?=
 =?utf-8?B?bDVRMVFEdEdUOSt2akMxVmFwMHREOGlGenNkQ2VMeWpwN09PQWQ2TThpTlpo?=
 =?utf-8?B?TjN0MDdEbUFIajArNkdpTm1uQ1hjQkI3bzR2NHNNeXhzWVF2Y2lac3RLVzla?=
 =?utf-8?B?VVJ3ME9obER4NFlsN0FWZmRtSnZuV0M3MmFFSUxRY2sveDQzOHpDMnVycnhH?=
 =?utf-8?B?N2dBd1R0TmJacGJYWFUyc2VTWVl5UERFaGI4UUY2SncyYzQwMVBZc1ZlR1FG?=
 =?utf-8?B?czF2V3JNM2N0L3RuZFJMdjd4QStQZzhsNWZpMkpOUE4rb1FyTE5FTm1NOVV4?=
 =?utf-8?B?WDY4REdmcFZNR25TNU5ISjBzbldqWkU1STdEbnp6Wng0OCtxeG9UWENmSll4?=
 =?utf-8?B?R25sRGFwZkRFZ0ZKcGZjRkdleDl0MXBsbTZoUXdSUStldDY4K0plbW9EeEdS?=
 =?utf-8?B?OWxpME5raWZxMTM5QTFxTHgraUtqM3BtTThPZW9oUnJUZkNUdnhqS3U5MTIx?=
 =?utf-8?B?eEhQYTBTSGRVa2NMY01SbEk4S1dSRGxoeVBQWHdCS1NrR3N3L2NQWVNRenpa?=
 =?utf-8?B?UFBnSFR1eGtGSk1wWHFJRXFUKzE3NzdJT3pxb0pYZ3laOU1hVEdibEU1TFIx?=
 =?utf-8?B?MFNjL2RveUdEc282UjRlRm9UNUM4ckhJNjJnL3BZWXMvZTE2ckhUUFlrVEJq?=
 =?utf-8?B?ZnNIelVSb3QrVU8zTkdxMHd5dFVmZGRzWmMrWHZoUjBLOGJ0aHhzSEtUdldV?=
 =?utf-8?B?N0pWdGVnVnBDUnRXdXZoRWlSYVJZOWNqelV0MmFHZUN4WDFSZERFOHJ5cUtL?=
 =?utf-8?B?Mk9lcnZWa2NwOERZKzBxTVk3Y1pLdVVNb3p6bnAwSFJuY0JBU2FYOC9jdDdq?=
 =?utf-8?B?ZkZHdmFMN2VpRUZucjRsQVBleUxaakNkSXJpVEwrRlEwanFBOGxLK1FtTGVJ?=
 =?utf-8?B?YU1IUjFLd1hFWENzNk9vNWlReHQvQnVjanNFTTZiY0VIRlBRQ3k2aXNoWHJq?=
 =?utf-8?B?ejZ6UVIrM2s3dXJ6Y0dwQSs1c0ZUU0FjSkVteXFTcHNoQWxUMVVvb2t4Ymk4?=
 =?utf-8?Q?mXjWy2zFpI3jxIMs/5ULXSLa7?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4SPRMB0075.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 997774a4-f076-4e6d-f59e-08db8cd1331c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2023 05:37:13.6050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rlVYmm57Sk9P8Gx+UbKVpHCWc/o1CmOezxbCBhUmPGJk8dzdLz4dr0ELddoOwF6gvAlKmcY136v3FzT0JGXaNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4646
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBTdWJqZWN0OiBbUEFUQ0ggdjE0IDAwLzI2XSBBZGQgdmZpb19kZXZpY2UgY2RldiBmb3IgaW9t
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
ZXYgcGF0aC4gRHJhZnQgUUVNVSBicmFuY2ggY2FuIGJlIGZvdW5kIGF0WzZdDQo+IA0KPiBodHRw
czovL2dpdGh1Yi5jb20veWlsaXUxNzY1L2lvbW11ZmQvdHJlZS92ZmlvX2RldmljZV9jZGV2X3Yx
NA0KPiAoY29uZmlnIENPTkZJR19JT01NVUZEPXkgQ09ORklHX1ZGSU9fREVWSUNFX0NERVY9eSkN
Cj4gDQo+IGJhc2UtY29tbWl0OiAwNmMyYWZiODYyZjlkYThkYzVlZmE0YjYwNzZhMGU0OGMzZmJh
YWE1DQo+IA0KDQpUZXN0ZWQgTklDIHBhc3N0aHJvdWdoIG9uIEludGVsIHBsYXRmb3JtLg0KUmVz
dWx0IGxvb2tzIGdvb2QgaGVuY2UsDQpUZXN0ZWQtYnk6IFlhbnRpbmcgSmlhbmcgPHlhbnRpbmcu
amlhbmdAaW50ZWwuY29tPg0K
