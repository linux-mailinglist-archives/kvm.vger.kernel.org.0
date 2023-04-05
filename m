Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C416D77F4
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 11:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237105AbjDEJXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 05:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjDEJXs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 05:23:48 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34E1449C;
        Wed,  5 Apr 2023 02:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680686627; x=1712222627;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qlv2fCefgwMz+YfA41dBivrRIRFB1pKOfVT7DJYTu/I=;
  b=hy16tpvN3QtjzXQ50zkvgBnSi0Mlk64bRsKXGvr5ofMFQ7+3t68/Rx9Q
   y3ooIX9KEJriJRtaqAfc9ZxWUpEcWh0NAOdeDqFbeR0fY3jG0ZePuZoR3
   i1EXXMuJzwVOPaNfXHaP+QoTOKhIMDz3XBWZMiQtwpSqO0fU88sirkBrX
   nSjN9H5XKzTGjDt2mpQVU4CngMmKvjPtOCBh4bZw+sY9DLQeQTII7grB5
   DCZVUjO7jjH0eQsoCZOZT5iRqH58oNoy2/I9kevJADRf7qhJNKgPXjvyV
   VKtGKf64UqFAXmPV6sgpCG8kL0sO6UaMds8h6LwJtnfb7DC6tJ93BkuOx
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="370229395"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="370229395"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 02:23:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="719244556"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="719244556"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 05 Apr 2023 02:23:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 02:23:40 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 02:23:40 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 02:23:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J09XzdKNsqYmBQZ0kyUTRN9J/Z3PInDfb7Tz8CkyulYSMipDRbpcWmSAic+9f/QI9y3amT9YQ3k/p9FmNkqVWVdSooK6nObFt3TaVNuKhIdTmieGwaCsf1Mk5BUIgwvO8nMhY/l1+F278xVb+DmsrHEAIVyswY3HLyohwvGSV0QOuoq1D6+QCstuP/8vjCftwJQ0Bcc5RtP8jN5p20fkoaZI23BmtSO3bpLIwyEj6b4x9AJmZsOYl4782bmu+HyWmLXCJ7fL04FklA05Bl9chBDT1Kw2FRR4h9dpHrUj79AnYcwN4S4lBuKRljzrdnz8Fr/3ERjxkXMRhcDAieXVZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qlv2fCefgwMz+YfA41dBivrRIRFB1pKOfVT7DJYTu/I=;
 b=cfLNbejhKn0GGVptWHpK1R/cbYXP27Wcqd+AvecZG+a4xxPpVbEQ6XoV1Pm0nmRYKG2pD7okk1xyrk4Ztwz1WS0t/FaygoRBmQAA/vdFfVvYqUfhvePvVmPBPi6ec61ZVa+lhfXuGQTxkn9923ALq4NlD3j7VMqKIOGVmq4720uA279A711znzh9HeJqW9OzQQEQ2o9cL8RAh5uM6aq5MvU4uIAkAC+mBtdC4qsqlF2FFWGbUCPTQdAsGqBZh4oBOKyemqWn3R7GiHrzv3Xi8HwXalx0ED0fxoDavJROCmWHXxkcVUOoG+fD8oXAmUfwb3RBLgS93C3a/LUGVF8mWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ1PR11MB6179.namprd11.prod.outlook.com (2603:10b6:a03:45a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Wed, 5 Apr
 2023 09:23:33 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 09:23:32 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
Subject: RE: [PATCH v3 06/12] vfio: Refine vfio file kAPIs for vfio PCI hot
 reset
Thread-Topic: [PATCH v3 06/12] vfio: Refine vfio file kAPIs for vfio PCI hot
 reset
Thread-Index: AQHZZKh9BFtb1VSXZkyMzL+fxoNDgq8cZ6qAgAAPAVA=
Date:   Wed, 5 Apr 2023 09:23:32 +0000
Message-ID: <DS0PR11MB75296FF52F7B754A7962BAA6C3909@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-7-yi.l.liu@intel.com>
 <ca119bbd-f4b8-a0c7-5fae-0bea66542908@redhat.com>
In-Reply-To: <ca119bbd-f4b8-a0c7-5fae-0bea66542908@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SJ1PR11MB6179:EE_
x-ms-office365-filtering-correlation-id: d4a39867-cc32-4ae4-e2bb-08db35b76d09
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 13U1AWLrnYPVlanClg7caL0F7qi/s5N3Vy54/MyIUzn4djTQ6f6LX+8Wjqw48/yNTDRA9T/80YIZiFqERi9iw4YWMLCNzoNAl76KKY0t5BL62l2ixvhLwXry8U5tLLdRIR3cRqeM05UEkVlHVMBytpmpKRrf9NhB0b5A5YSLAvOFvLgZM6PVXlbclOQ5+xNZIFqVXucGW/MOXns/9aKE5y42db1F5VvoWbinHhJ0uDJhdSsT4piWLP4s+acV9jneF02MdUECNMWObVM0D2S6FQ97P9xCCOH472EaU+26NCN54D4M57/bpkHoTRKrs47QC0RKdqZtaLxMEPN9dpnVTUW3wa2DMHOYQseb14rds5RJJav1MDUkPdSCTPfcsxkO2Q0/vhWVSRRyNM/gmiqaVGbFT1JdkVFo+ptNaPGX7Qdeo8jqvbm2Ec/MHf/DYQvsNdGIOjnEpN+6bUnfoJpmt779MHtQuAwGgeYc60icUB5c0kHkCy+Y1i5AMaVVb87Qe3Iwdqsuosw4L1yITSN7J20Pi+/rTpnWnDMixC4JUQ+OYJJn2/mZzL0xIxe2uBZfyyCQ3eGBtmHWXsz5GosuB/Ri1GIfR4Bz5Awg6RImKHAJtSoi98x7pk4/nGnognW3lPhtko6rp1CoOGOupnyy1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39860400002)(346002)(376002)(136003)(451199021)(2906002)(33656002)(7696005)(82960400001)(110136005)(316002)(38100700002)(53546011)(9686003)(6506007)(38070700005)(478600001)(83380400001)(122000001)(86362001)(26005)(186003)(54906003)(55016003)(4326008)(71200400001)(8936002)(8676002)(66476007)(66446008)(66556008)(76116006)(64756008)(66946007)(5660300002)(7416002)(52536014)(6636002)(41300700001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RkkyQ2xVYnpSRTVGdFJLSWxVdzBOcUR3VEtpWW55Z2NJVkVZcXEvZm8vbWVi?=
 =?utf-8?B?R0ZEWGs5TGVQVnNNb3RHcVhKMkFTbjVtOXBTRFlFb2lYOGRIa3ZjOEh4Y1FS?=
 =?utf-8?B?em0zUitqQ0k1aUlOZGgwTzFMQ1dLbzBjV0pibDlrM09NeXRJUzNocGVyTHlV?=
 =?utf-8?B?TzBGYVJQUXNid1RqTjZDVzdHdnV1WXM5aHBDRkFSQjFrTDFIaHI0UDlLRDZK?=
 =?utf-8?B?Qi9nZlZYbDRXaStTMzBhekEvbHp2NngvdUFrNnBxS2FoQ3lUMStTL1ZvY2xk?=
 =?utf-8?B?c0R6MW1OVm1EREVndzVkanlQaUNtaGd1ZkVrQURjZDZOckJFbWcvV1FyZ0cx?=
 =?utf-8?B?a1dOOVdIMzN6aE1WSGtrTTJzeUwwdVNaZGlYd1BsVWJMcWpTMmtpSDIzY29r?=
 =?utf-8?B?MjhkNTlENEY1OFNZTnNyRG9xV0tGc1JTNkpyRHhnRCs0U0Z3QlV0UEpUNEw5?=
 =?utf-8?B?VlNod05pd1JPQlJpcUhvUnN2bFZ5ZmRFbFlrT2tLNjdkbXBLNzFhUDJaanRv?=
 =?utf-8?B?RjhNWElVMjlrWlBjdHZLV1dBcXQzdFlIYWxGdmk2V3VQejZZZThYekZWeUpu?=
 =?utf-8?B?bDBCbzZlL01vbGZkMUVKZXBtN3NseWVTaEpDajlldTIvZytIaFBIV1AzTHh6?=
 =?utf-8?B?amlwdXhqdDFzOXFsUDhML0pXaGc3WEdDOHd3YlRyRkF1OHNiVERzaGtwVDF5?=
 =?utf-8?B?OGhhOHBHNXNkWWhJeHNmeDZEaGk3bERXNTdUdTZNYnBzZXJnRmlGSFJZOVNh?=
 =?utf-8?B?NnBrdHFodFE3S01udVJHb3Y3bHdhQThUTVkrdlZMc3FuRmxGUHlrQklUUXlS?=
 =?utf-8?B?K2YxQ2FjQ2d6Mkd3dTBRcm1NT0xGaVY5RDh6NCt1eVN0cFplWWdSYzg4UHdt?=
 =?utf-8?B?dmRHTVQ4QVYrc0pLZWhPOXV4U29zdW1iVVRtYXl4V3I2Z0NXZzBkaWVWTG5s?=
 =?utf-8?B?b0x2MzdROTVrU0hxZWZsNElyV3I5MU93UU1yVjlFVEtKb1hUSTF2a1R4Qk81?=
 =?utf-8?B?aTRSNjU3UXhVMWZaVkNUUG83NlVlOWw2azRuc2RXb1h5TkIzSm80Tm9wV25F?=
 =?utf-8?B?c3QxSmZJQmJaM1hLNlh3ZWg3REMwRHVwN2tZMDk5bXQwWCtPNXFzWDlBTTVN?=
 =?utf-8?B?Y2NvNkZveFR4cTZJZ0tsSFNIZ2VxSEZKd2tIY3FPc0Y5OSsydkVRZVEzS2VJ?=
 =?utf-8?B?c04zd3VNQUFmY3EyaGY5RlRNbHh4aWdVWFhZa0p5VnhLdTJxQlRGS1c1cFdj?=
 =?utf-8?B?UnhQb250QXpCQ2cwY1krNVZ3VnUzQ1NsekNjVTdlVUZXZ2c1cW93UWNJbEJM?=
 =?utf-8?B?RHY4dHZEWi9FUU10aHhFRHZJOUt3VE4wbC9jaDFvYXVGMTNRWTd6R2UrNVN4?=
 =?utf-8?B?TlhwYXAvS3dlMWpLL1FWcGtYWEFxUVUxMGMrNHlQOXFDN2hmQkxSYVoxN3ls?=
 =?utf-8?B?aUhQSytlWjVpdGZVaWpCSlNVeWptQWFzQUxkcUpxa2J1ZEpiQzVYZFBVTVpz?=
 =?utf-8?B?T1JSKzAzcGJRWmF1QWZEOXVYaTRrNk9tOHR2Sno5ZW9YUVZqR0tZQUVPcnFM?=
 =?utf-8?B?RUhkK0lzd2lQd1p4TEtOTTRuVk9jd3pqWGNaR09LZXdybWlneEtNVWtwRC8v?=
 =?utf-8?B?aTZHRWVubTQ5L2w1QmNFL2xkMUJBRExrQTlEbFFRM2J6WjFiTERJbEM2bUhp?=
 =?utf-8?B?c0puQk1PeUtDRmNxVFJYZjA1Q3F3aFhteS9wT0FMMWV3MmZYK3d4L2UrV3Q3?=
 =?utf-8?B?bFBuWU1TeUd2T3UwNDFrWi9EKzgzeW1xTlVIUUtUVDlSblhjdThEYk9rMmUx?=
 =?utf-8?B?OUc0VXJlZ0FwakhQVnFZMmVnUkd6UVFRaE5xcURvWFM4b1I3MnZsWW5iSGN1?=
 =?utf-8?B?UThSQ28xQmtvMldCM1J2NEpscysydmtqbytZTHF5RW1lYTNrNENDTTNuTkNV?=
 =?utf-8?B?QUlHTFdFV3hOeW9mRUk0dkNBK3RNdjkzT01FdjIzejFJWG9UTDJrL016N1ZN?=
 =?utf-8?B?QVQ3ZWpYMWFXSThqRDdqdDJMNTFSQnpDdXFmTzVuRmxKTTNmUFRKd290WTkv?=
 =?utf-8?B?WUJYL1FmVmsxYXVCYXpDNlNOM1lMRXRGaXlocTdjbmU2S0hvVThsc3lYYTV2?=
 =?utf-8?Q?4mm1nVRgnONHkW+ql1ZpRp8/E?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4a39867-cc32-4ae4-e2bb-08db35b76d09
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 09:23:32.7674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4xqr/GFmvj8UkAOEKmcdLNS9IQ5vWyBeC3iuBSls5d9GGpX2P7AFVkHIkXQhBpJMgbKjDvf+DSBJnbt0DsFSug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6179
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgQXByaWwgNSwgMjAyMyA0OjI4IFBNDQo+IA0KPiBIaSBZaSwNCj4gT24gNC8xLzIzIDE2
OjQ0LCBZaSBMaXUgd3JvdGU6DQo+ID4gVGhpcyBwcmVwYXJlcyB2ZmlvIGNvcmUgdG8gYWNjZXB0
IHZmaW8gZGV2aWNlIGZpbGUgZnJvbSB0aGUgdmZpbyBQQ0kNCj4gPiBob3QgcmVzZXQgcGF0aC4g
dmZpb19maWxlX2lzX2dyb3VwKCkgaXMgc3RpbGwga2VwdCBmb3IgS1ZNIHVzYWdlLg0KPiA+DQo+
ID4gUmV2aWV3ZWQtYnk6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0KPiA+IFJl
dmlld2VkLWJ5OiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiA+IFRlc3RlZC1i
eTogWWFudGluZyBKaWFuZyA8eWFudGluZy5qaWFuZ0BpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9m
Zi1ieTogWWkgTGl1IDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMv
dmZpby9ncm91cC5jICAgICAgICAgICAgIHwgMzIgKysrKysrKysrKysrKystLS0tLS0tLS0tLS0t
LS0tLS0NCj4gPiAgZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9jb3JlLmMgfCAgNCArKy0tDQo+
ID4gIGRyaXZlcnMvdmZpby92ZmlvLmggICAgICAgICAgICAgIHwgIDIgKysNCj4gPiAgZHJpdmVy
cy92ZmlvL3ZmaW9fbWFpbi5jICAgICAgICAgfCAyOSArKysrKysrKysrKysrKysrKysrKysrKysr
KysrKw0KPiA+ICBpbmNsdWRlL2xpbnV4L3ZmaW8uaCAgICAgICAgICAgICB8ICAxICsNCj4gPiAg
NSBmaWxlcyBjaGFuZ2VkLCA0OCBpbnNlcnRpb25zKCspLCAyMCBkZWxldGlvbnMoLSkNCj4gPg0K
PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8vZ3JvdXAuYyBiL2RyaXZlcnMvdmZpby9ncm91
cC5jDQo+ID4gaW5kZXggMjdkNWJhN2NmOWRjLi5kMGM5NWQwMzM2MDUgMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy92ZmlvL2dyb3VwLmMNCj4gPiArKysgYi9kcml2ZXJzL3ZmaW8vZ3JvdXAuYw0K
PiA+IEBAIC03NDUsNiArNzQ1LDE1IEBAIGJvb2wgdmZpb19kZXZpY2VfaGFzX2NvbnRhaW5lcihz
dHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSkNCj4gPiAgCXJldHVybiBkZXZpY2UtPmdyb3VwLT5j
b250YWluZXI7DQo+ID4gIH0NCj4gPg0KPiA+ICtzdHJ1Y3QgdmZpb19ncm91cCAqdmZpb19ncm91
cF9mcm9tX2ZpbGUoc3RydWN0IGZpbGUgKmZpbGUpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCB2Zmlv
X2dyb3VwICpncm91cCA9IGZpbGUtPnByaXZhdGVfZGF0YTsNCj4gPiArDQo+ID4gKwlpZiAoZmls
ZS0+Zl9vcCAhPSAmdmZpb19ncm91cF9mb3BzKQ0KPiA+ICsJCXJldHVybiBOVUxMOw0KPiA+ICsJ
cmV0dXJuIGdyb3VwOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICAvKioNCj4gPiAgICogdmZpb19maWxl
X2lvbW11X2dyb3VwIC0gUmV0dXJuIHRoZSBzdHJ1Y3QgaW9tbXVfZ3JvdXAgZm9yIHRoZSB2Zmlv
IGdyb3VwIGZpbGUNCj4gPiAgICogQGZpbGU6IFZGSU8gZ3JvdXAgZmlsZQ0KPiA+IEBAIC03NTUs
MTMgKzc2NCwxMyBAQCBib29sIHZmaW9fZGV2aWNlX2hhc19jb250YWluZXIoc3RydWN0IHZmaW9f
ZGV2aWNlDQo+ICpkZXZpY2UpDQo+ID4gICAqLw0KPiA+ICBzdHJ1Y3QgaW9tbXVfZ3JvdXAgKnZm
aW9fZmlsZV9pb21tdV9ncm91cChzdHJ1Y3QgZmlsZSAqZmlsZSkNCj4gPiAgew0KPiA+IC0Jc3Ry
dWN0IHZmaW9fZ3JvdXAgKmdyb3VwID0gZmlsZS0+cHJpdmF0ZV9kYXRhOw0KPiA+ICsJc3RydWN0
IHZmaW9fZ3JvdXAgKmdyb3VwID0gdmZpb19ncm91cF9mcm9tX2ZpbGUoZmlsZSk7DQo+ID4gIAlz
dHJ1Y3QgaW9tbXVfZ3JvdXAgKmlvbW11X2dyb3VwID0gTlVMTDsNCj4gPg0KPiA+ICAJaWYgKCFJ
U19FTkFCTEVEKENPTkZJR19TUEFQUl9UQ0VfSU9NTVUpKQ0KPiA+ICAJCXJldHVybiBOVUxMOw0K
PiA+DQo+ID4gLQlpZiAoIXZmaW9fZmlsZV9pc19ncm91cChmaWxlKSkNCj4gPiArCWlmICghZ3Jv
dXApDQo+ID4gIAkJcmV0dXJuIE5VTEw7DQo+ID4NCj4gPiAgCW11dGV4X2xvY2soJmdyb3VwLT5n
cm91cF9sb2NrKTsNCj4gPiBAQCAtNzc1LDEyICs3ODQsMTIgQEAgc3RydWN0IGlvbW11X2dyb3Vw
ICp2ZmlvX2ZpbGVfaW9tbXVfZ3JvdXAoc3RydWN0IGZpbGUNCj4gKmZpbGUpDQo+ID4gIEVYUE9S
VF9TWU1CT0xfR1BMKHZmaW9fZmlsZV9pb21tdV9ncm91cCk7DQo+ID4NCj4gPiAgLyoqDQo+ID4g
LSAqIHZmaW9fZmlsZV9pc19ncm91cCAtIFRydWUgaWYgdGhlIGZpbGUgaXMgdXNhYmxlIHdpdGgg
VkZJTyBhUElTDQo+ID4gKyAqIHZmaW9fZmlsZV9pc19ncm91cCAtIFRydWUgaWYgdGhlIGZpbGUg
aXMgYSB2ZmlvIGdyb3VwIGZpbGUNCj4gPiAgICogQGZpbGU6IFZGSU8gZ3JvdXAgZmlsZQ0KPiA+
ICAgKi8NCj4gPiAgYm9vbCB2ZmlvX2ZpbGVfaXNfZ3JvdXAoc3RydWN0IGZpbGUgKmZpbGUpDQo+
ID4gIHsNCj4gPiAtCXJldHVybiBmaWxlLT5mX29wID09ICZ2ZmlvX2dyb3VwX2ZvcHM7DQo+ID4g
KwlyZXR1cm4gdmZpb19ncm91cF9mcm9tX2ZpbGUoZmlsZSk7DQo+ID4gIH0NCj4gPiAgRVhQT1JU
X1NZTUJPTF9HUEwodmZpb19maWxlX2lzX2dyb3VwKTsNCj4gPg0KPiA+IEBAIC04NDIsMjMgKzg1
MSwxMCBAQCB2b2lkIHZmaW9fZmlsZV9zZXRfa3ZtKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3Qg
a3ZtICprdm0pDQo+ID4gIH0NCj4gPiAgRVhQT1JUX1NZTUJPTF9HUEwodmZpb19maWxlX3NldF9r
dm0pOw0KPiA+DQo+ID4gLS8qKg0KPiA+IC0gKiB2ZmlvX2ZpbGVfaGFzX2RldiAtIFRydWUgaWYg
dGhlIFZGSU8gZmlsZSBpcyBhIGhhbmRsZSBmb3IgZGV2aWNlDQo+ID4gLSAqIEBmaWxlOiBWRklP
IGZpbGUgdG8gY2hlY2sNCj4gPiAtICogQGRldmljZTogRGV2aWNlIHRoYXQgbXVzdCBiZSBwYXJ0
IG9mIHRoZSBmaWxlDQo+ID4gLSAqDQo+ID4gLSAqIFJldHVybnMgdHJ1ZSBpZiBnaXZlbiBmaWxl
IGhhcyBwZXJtaXNzaW9uIHRvIG1hbmlwdWxhdGUgdGhlIGdpdmVuIGRldmljZS4NCj4gPiAtICov
DQo+ID4gLWJvb2wgdmZpb19maWxlX2hhc19kZXYoc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdCB2
ZmlvX2RldmljZSAqZGV2aWNlKQ0KPiA+ICtib29sIHZmaW9fZ3JvdXBfaGFzX2RldihzdHJ1Y3Qg
dmZpb19ncm91cCAqZ3JvdXAsIHN0cnVjdCB2ZmlvX2RldmljZSAqZGV2aWNlKQ0KPiA+ICB7DQo+
ID4gLQlzdHJ1Y3QgdmZpb19ncm91cCAqZ3JvdXAgPSBmaWxlLT5wcml2YXRlX2RhdGE7DQo+ID4g
LQ0KPiA+IC0JaWYgKCF2ZmlvX2ZpbGVfaXNfZ3JvdXAoZmlsZSkpDQo+ID4gLQkJcmV0dXJuIGZh
bHNlOw0KPiA+IC0NCj4gPiAgCXJldHVybiBncm91cCA9PSBkZXZpY2UtPmdyb3VwOw0KPiA+ICB9
DQo+ID4gLUVYUE9SVF9TWU1CT0xfR1BMKHZmaW9fZmlsZV9oYXNfZGV2KTsNCj4gPg0KPiA+ICBz
dGF0aWMgY2hhciAqdmZpb19kZXZub2RlKGNvbnN0IHN0cnVjdCBkZXZpY2UgKmRldiwgdW1vZGVf
dCAqbW9kZSkNCj4gPiAgew0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9f
cGNpX2NvcmUuYyBiL2RyaXZlcnMvdmZpby9wY2kvdmZpb19wY2lfY29yZS5jDQo+ID4gaW5kZXgg
YjY4ZmNiYTY3YTRiLi4yYTUxMGI3MWVkY2IgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy92Zmlv
L3BjaS92ZmlvX3BjaV9jb3JlLmMNCj4gPiArKysgYi9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNp
X2NvcmUuYw0KPiA+IEBAIC0xMzA4LDggKzEzMDgsOCBAQCB2ZmlvX3BjaV9pb2N0bF9wY2lfaG90
X3Jlc2V0X2dyb3VwcyhzdHJ1Y3QNCj4gdmZpb19wY2lfY29yZV9kZXZpY2UgKnZkZXYsDQo+ID4g
IAkJCWJyZWFrOw0KPiA+ICAJCX0NCj4gPg0KPiA+IC0JCS8qIEVuc3VyZSB0aGUgRkQgaXMgYSB2
ZmlvIGdyb3VwIEZELiovDQo+ID4gLQkJaWYgKCF2ZmlvX2ZpbGVfaXNfZ3JvdXAoZmlsZSkpIHsN
Cj4gPiArCQkvKiBFbnN1cmUgdGhlIEZEIGlzIGEgdmZpbyBGRC4gdmZpbyBncm91cCBvciB2Zmlv
IGRldmljZSAqLw0KPiBpdCBpcyBhIGJpdCBzdHJhbmdlIHRvIHVwZGF0ZSB0aGUgY29tbWVudCBo
ZXJlIGFuZCBpbiB0aGUgb3RoZXIgcGxhY2VzDQo+IGluIHRoaXMgcGF0Y2ggd2hlcmVhcyBmaWxl
X2lzX3ZhbGlkIHN0aWxsIHN0aWNrcyB0byBncm91cCBmaWxlIGNoZWNrDQo+IEJ5IHRoZSB3YXkg
SSB3b3VsZCBzaW1wbHkgcmVtb3ZlIHRoZSBjb21tZW50IHdoaWNoIGRvZXMgbm90IGJyaW5nIG11
Y2gNCg0Kb2suIHllYWgsIGF0IHRoaXMgbW9tZW50LCBpdCdzIHN0aWxsIGdyb3VwIGZpbGUuIG1h
eSBqdXN0IGRlbGV0ZSB0aGlzIGNvbW1lbnQuDQoNCj4gPiArCQlpZiAoIXZmaW9fZmlsZV9pc192
YWxpZChmaWxlKSkgew0KPiA+ICAJCQlmcHV0KGZpbGUpOw0KPiA+ICAJCQlyZXQgPSAtRUlOVkFM
Ow0KPiA+ICAJCQlicmVhazsNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL3ZmaW8uaCBi
L2RyaXZlcnMvdmZpby92ZmlvLmgNCj4gPiBpbmRleCA3YjE5YzYyMWUwZTYuLmMwYWVlYTI0ZmJk
NiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3ZmaW8vdmZpby5oDQo+ID4gKysrIGIvZHJpdmVy
cy92ZmlvL3ZmaW8uaA0KPiA+IEBAIC04NCw2ICs4NCw4IEBAIHZvaWQgdmZpb19kZXZpY2VfZ3Jv
dXBfdW5yZWdpc3RlcihzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSk7DQo+ID4gIGludCB2Zmlv
X2RldmljZV9ncm91cF91c2VfaW9tbXUoc3RydWN0IHZmaW9fZGV2aWNlICpkZXZpY2UpOw0KPiA+
ICB2b2lkIHZmaW9fZGV2aWNlX2dyb3VwX3VudXNlX2lvbW11KHN0cnVjdCB2ZmlvX2RldmljZSAq
ZGV2aWNlKTsNCj4gPiAgdm9pZCB2ZmlvX2RldmljZV9ncm91cF9jbG9zZShzdHJ1Y3QgdmZpb19k
ZXZpY2UgKmRldmljZSk7DQo+ID4gK3N0cnVjdCB2ZmlvX2dyb3VwICp2ZmlvX2dyb3VwX2Zyb21f
ZmlsZShzdHJ1Y3QgZmlsZSAqZmlsZSk7DQo+ID4gK2Jvb2wgdmZpb19ncm91cF9oYXNfZGV2KHN0
cnVjdCB2ZmlvX2dyb3VwICpncm91cCwgc3RydWN0IHZmaW9fZGV2aWNlICpkZXZpY2UpOw0KPiA+
ICBib29sIHZmaW9fZGV2aWNlX2hhc19jb250YWluZXIoc3RydWN0IHZmaW9fZGV2aWNlICpkZXZp
Y2UpOw0KPiA+ICBpbnQgX19pbml0IHZmaW9fZ3JvdXBfaW5pdCh2b2lkKTsNCj4gPiAgdm9pZCB2
ZmlvX2dyb3VwX2NsZWFudXAodm9pZCk7DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmZpby92
ZmlvX21haW4uYyBiL2RyaXZlcnMvdmZpby92ZmlvX21haW4uYw0KPiA+IGluZGV4IDg5NDk3Yzkz
MzQ5MC4uZmU3NDQ2ODA1YWZkIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvdmZpby92ZmlvX21h
aW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvdmZpby92ZmlvX21haW4uYw0KPiA+IEBAIC0xMTU0LDYg
KzExNTQsMzUgQEAgY29uc3Qgc3RydWN0IGZpbGVfb3BlcmF0aW9ucyB2ZmlvX2RldmljZV9mb3Bz
ID0gew0KPiA+ICAJLm1tYXAJCT0gdmZpb19kZXZpY2VfZm9wc19tbWFwLA0KPiA+ICB9Ow0KPiA+
DQo+ID4gKy8qKg0KPiA+ICsgKiB2ZmlvX2ZpbGVfaXNfdmFsaWQgLSBUcnVlIGlmIHRoZSBmaWxl
IGlzIHZhbGlkIHZmaW8gZmlsZQ0KPiA+ICsgKiBAZmlsZTogVkZJTyBncm91cCBmaWxlIG9yIFZG
SU8gZGV2aWNlIGZpbGUNCj4gSSB3b25kZXIgaWYgeW91IHNob3VsZG4ndCBzcXVhc2ggd2l0aCBu
ZXh0IHBhdGNoIHRiaC4NCg0KeWVzLiB0aGlzIGlzIHN0aWxsIGdyb3VwIGZpbGUsIG5vIGRldmlj
ZSBmaWxlIHlldC4NCg0KVGhhbmtzLA0KWWkgTGl1DQoNCj4gPiArICovDQo+ID4gK2Jvb2wgdmZp
b19maWxlX2lzX3ZhbGlkKHN0cnVjdCBmaWxlICpmaWxlKQ0KPiA+ICt7DQo+ID4gKwlyZXR1cm4g
dmZpb19ncm91cF9mcm9tX2ZpbGUoZmlsZSk7DQo+ID4gK30NCj4gPiArRVhQT1JUX1NZTUJPTF9H
UEwodmZpb19maWxlX2lzX3ZhbGlkKTsNCj4gPiArDQo+ID4gKy8qKg0KPiA+ICsgKiB2ZmlvX2Zp
bGVfaGFzX2RldiAtIFRydWUgaWYgdGhlIFZGSU8gZmlsZSBpcyBhIGhhbmRsZSBmb3IgZGV2aWNl
DQo+ID4gKyAqIEBmaWxlOiBWRklPIGZpbGUgdG8gY2hlY2sNCj4gPiArICogQGRldmljZTogRGV2
aWNlIHRoYXQgbXVzdCBiZSBwYXJ0IG9mIHRoZSBmaWxlDQo+ID4gKyAqDQo+ID4gKyAqIFJldHVy
bnMgdHJ1ZSBpZiBnaXZlbiBmaWxlIGhhcyBwZXJtaXNzaW9uIHRvIG1hbmlwdWxhdGUgdGhlIGdp
dmVuIGRldmljZS4NCj4gPiArICovDQo+ID4gK2Jvb2wgdmZpb19maWxlX2hhc19kZXYoc3RydWN0
IGZpbGUgKmZpbGUsIHN0cnVjdCB2ZmlvX2RldmljZSAqZGV2aWNlKQ0KPiA+ICt7DQo+ID4gKwlz
dHJ1Y3QgdmZpb19ncm91cCAqZ3JvdXA7DQo+ID4gKw0KPiA+ICsJZ3JvdXAgPSB2ZmlvX2dyb3Vw
X2Zyb21fZmlsZShmaWxlKTsNCj4gPiArCWlmICghZ3JvdXApDQo+ID4gKwkJcmV0dXJuIGZhbHNl
Ow0KPiA+ICsNCj4gPiArCXJldHVybiB2ZmlvX2dyb3VwX2hhc19kZXYoZ3JvdXAsIGRldmljZSk7
DQo+ID4gK30NCj4gPiArRVhQT1JUX1NZTUJPTF9HUEwodmZpb19maWxlX2hhc19kZXYpOw0KPiA+
ICsNCj4gPiAgLyoNCj4gPiAgICogU3ViLW1vZHVsZSBzdXBwb3J0DQo+ID4gICAqLw0KPiA+IGRp
ZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3ZmaW8uaCBiL2luY2x1ZGUvbGludXgvdmZpby5oDQo+
ID4gaW5kZXggOTdhMTE3NGI5MjJmLi5mOGZiOWFiMjUxODggMTAwNjQ0DQo+ID4gLS0tIGEvaW5j
bHVkZS9saW51eC92ZmlvLmgNCj4gPiArKysgYi9pbmNsdWRlL2xpbnV4L3ZmaW8uaA0KPiA+IEBA
IC0yNTgsNiArMjU4LDcgQEAgaW50IHZmaW9fbWlnX2dldF9uZXh0X3N0YXRlKHN0cnVjdCB2Zmlv
X2RldmljZSAqZGV2aWNlLA0KPiA+ICAgKi8NCj4gPiAgc3RydWN0IGlvbW11X2dyb3VwICp2Zmlv
X2ZpbGVfaW9tbXVfZ3JvdXAoc3RydWN0IGZpbGUgKmZpbGUpOw0KPiA+ICBib29sIHZmaW9fZmls
ZV9pc19ncm91cChzdHJ1Y3QgZmlsZSAqZmlsZSk7DQo+ID4gK2Jvb2wgdmZpb19maWxlX2lzX3Zh
bGlkKHN0cnVjdCBmaWxlICpmaWxlKTsNCj4gPiAgYm9vbCB2ZmlvX2ZpbGVfZW5mb3JjZWRfY29o
ZXJlbnQoc3RydWN0IGZpbGUgKmZpbGUpOw0KPiA+ICB2b2lkIHZmaW9fZmlsZV9zZXRfa3ZtKHN0
cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3Qga3ZtICprdm0pOw0KPiA+ICBib29sIHZmaW9fZmlsZV9o
YXNfZGV2KHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSk7DQo+
IEVyaWMNCg0K
