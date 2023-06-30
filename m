Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D87743EA5
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 17:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbjF3PW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 11:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232251AbjF3PWY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 11:22:24 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEF23C06;
        Fri, 30 Jun 2023 08:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688138537; x=1719674537;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GnkbfKGy9443/dpYiB9Gi9//HM3VC96EOWkMD8a1EYY=;
  b=m7nHIvbTDrGoaJynEpO6Obn8XFCPJtXQt9UoV09/AyMx6PXWt/p4UyIG
   N8lWGNbaZSUQkRK6nLG8uZoRpq/tg9tB7w+xadBj+6HRFALc6yP4jN480
   jj0jWlUdp4skCkc5iYTR2WMhTh/Nya0YFNixl5voqUgr+MroHPL58s7Wy
   IEdWM3FhSXVepziVlnyqYGrI7DVQIh29z214UHU7ZPBl36OSpYwEj0208
   WBz4cCJ7qpz3EqadPntTDXa2R2lsU6DfcShb4jsTcHcMkjHsOya1xY1Xu
   rStvl4xLrW/E1FtPSn3idwIe1Tcy0Smvh+SXeHPRF0fLOH7Td5j9jktJh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="361267283"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="361267283"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 08:22:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="720988783"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="720988783"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jun 2023 08:22:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 08:22:01 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 08:22:01 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 08:21:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBgEybIKlgV+UkDVT42Dz4gpiLsOQYPHajCfNMZHJ/5eZqNPhfASAsoZF/AUc4dpHV4UMXxYESuyz3F/vfIWlKzzKsPtG4olt5yrxTikqtYNjT8Xj+RCn9LXhHtClajbKEaUTHMkzcSpVR5HKEnKjAnHDZP21iKZ7qAwwLja3MXXDbj4s8mwCO89GfTkyJJkRV7F+M51j2MmC0CNVyx62ab+/XpV6x+SBPVziiI8jtJY+mvmvPm1RobpfFXAqpSXAn5f25dhhjy3esUFGcYHTke8k+y02wfPTe4G25i+MH5xo/HKnd3z+nQG6lk/40Z6p7+pJS83eb9hN/BTp5wLEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GnkbfKGy9443/dpYiB9Gi9//HM3VC96EOWkMD8a1EYY=;
 b=IOeeU0M5S/3lezWqKTMEzt4Ra6L7G1DW44aknX8bBE5PXkhzRr1i0bVwYMTP2chyogmJ4pey8Ohnfjt0efdGiA4qhEmijXkQNqPXH7ieNvCCXN+PuY9cbgL2E0Hw0X6q3Jy/bWUIMUQvy0VSmUHX4op2v8WMA5hmt/cmB/g8wH6sY4IQ5PpA4Gws5dJW5aoCBqb6L/y2Q/aTS/1GSkdJT0hKYUUdjY1l/LfPlhBPAhQZ3imKaQz++m+t1olzT9t7mprv8+Ax//LNBtznsU3YHO5v6HTepS9GXd9SOdQTkUyNX4DVtsQ8KoxCLNSdWSfoepX72D5xhPxV5xX1EL7ZlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5107.namprd11.prod.outlook.com (2603:10b6:303:97::6)
 by IA0PR11MB7186.namprd11.prod.outlook.com (2603:10b6:208:442::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.19; Fri, 30 Jun
 2023 15:21:54 +0000
Received: from CO1PR11MB5107.namprd11.prod.outlook.com
 ([fe80::a8a6:41b5:74ac:e2d5]) by CO1PR11MB5107.namprd11.prod.outlook.com
 ([fe80::a8a6:41b5:74ac:e2d5%4]) with mapi id 15.20.6544.019; Fri, 30 Jun 2023
 15:21:54 +0000
From:   "Neiger, Gil" <gil.neiger@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        "Yang, Weijiang" <weijiang.yang@intel.com>
CC:     "Gao, Chao" <chao.gao@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "john.allen@amd.com" <john.allen@amd.com>
Subject: RE: [PATCH v3 10/21] KVM:x86: Add #CP support in guest exception
 classification
Thread-Topic: [PATCH v3 10/21] KVM:x86: Add #CP support in guest exception
 classification
Thread-Index: AQHZqzYYqQglnvQawUuRS2Dzv6LIHq+jctsAgAADxNA=
Date:   Fri, 30 Jun 2023 15:21:54 +0000
Message-ID: <CO1PR11MB51073DF074056A344CC09FED912AA@CO1PR11MB5107.namprd11.prod.outlook.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-11-weijiang.yang@intel.com>
 <ZH73kDx6VCaBFiyh@chao-email>
 <21568052-eb0f-a8d6-5225-3b422e9470e9@intel.com>
 <ZIulniryqlj0hLnt@google.com>
 <dfdf6d93-a68c-bb07-e59e-8d888dd6ebb6@intel.com>
 <ZIywqx6xTAMFyDPT@google.com>
 <0a98683f-3e60-1f1b-55df-f2a781929fdf@intel.com>
 <ZJ7vyBw1nbTBOfuf@google.com>
In-Reply-To: <ZJ7vyBw1nbTBOfuf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5107:EE_|IA0PR11MB7186:EE_
x-ms-office365-filtering-correlation-id: 3f371219-21da-4025-cfb4-08db797dbcb9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zGZDtCfq7hwmViOHL5HBL36P4ir274VbsBZoIN7rrBrgllz3aiUPP7GUvXLvGt6PYpUsqB+qhbMhk8f+vZ0E7VvFOPNpDRtt0Z30UlIipPMpBLAzgr8sBuKUWPwq+/sILGuh55UOZz/OnewJarTFO9qx+vHa1RQthzVyExFrkYjO5NeKHYErS1opCfrSmXT2dipfQDH9Euf1S7ffMxcjzuQCUG8g/MppkTIWQdW465kY3A/sqMlfGxCIE3MPxXQrBrhPwwVjNpaaLbUVghp7uNerApntcycO2qd3Jh9OH5p0DJng9poBR4odF/zKHTE6FAXoL/I0HNeX1Idvzv5x8QXIdYHNBuEYM6R9k0xzwXdLEqqbk7iWA+JbhMsG7hBuWcvNwSBPgchLMutzG4wM014bIibF4pki0Ch+dsOmigPB5+xKHbLVHkPD1eesw3E/adEqcizgcMjXizmmTWvhGyDvCgDAdOeiDc0Xw/8NPXWqhfN4Neu6lIK723Q1D+myKYbKqHT4ass9K8XPaxvqhXuPDYcAlgNYq4oe3vHRt8qOC4ROnvdPImTUtnp1tRq5EwzC5GHDs94q82Ly3pz+vgsXv1GTc62Tgo2IH+auXVwjNcadwH05NFKMkE3eA4Kd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(366004)(136003)(39860400002)(451199021)(52536014)(86362001)(54906003)(71200400001)(8936002)(8676002)(5660300002)(110136005)(26005)(9686003)(6506007)(53546011)(33656002)(7696005)(478600001)(66946007)(66556008)(66476007)(66446008)(64756008)(6636002)(4326008)(41300700001)(76116006)(316002)(186003)(38070700005)(2906002)(83380400001)(55016003)(82960400001)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UW9MRFpIYnk1YllRWTVHbmlxb3hBdWFSSjFPd2lEZkRvV0Npa01hN0tGTU1C?=
 =?utf-8?B?WUVJS3NjcWFWY2YvVEg4WlpFWGdsREx5bWdjQWE0LysxMFhyYVNrQXAwVnpG?=
 =?utf-8?B?RG1VZ1pQbnllTy95UDkwdzhyNDBQL0wrUkZ0QlYzaDhDSUZhWlZYWThSKzhs?=
 =?utf-8?B?MlhxQVAwQ3JjZ1B2MDlTWDVaNWlnZXFsTjh5U2lRSXBXSncwYXloTXppaUJV?=
 =?utf-8?B?V2JxKys2SWFCZ0Z0SXhqeVZXMWUyMDNCdUJub051c1VMcVc0cWdUUnNEaDA5?=
 =?utf-8?B?NG42djhZa3czVXc3MmpKTEx4YjZJTUlyK3Z6SFRqNXVNRUhqaHU0RlFUZHZz?=
 =?utf-8?B?U1pQMER1Y2g4ZXZMNnAvbWduS2FwTzdoVm1Ic2c2a0MyUThuZllFQVhJRytQ?=
 =?utf-8?B?ZkloY0JHR3lQSmFiYXlWb0oydUg0M2Z2U05sZW1Ba2tjMnp6K2VGUTY0V3pt?=
 =?utf-8?B?cmZicVhzT2MxZDBqcDcwbUNQaWQzeXpSSDh5NVpxVW5oQU9SZHlFT3g3SU5j?=
 =?utf-8?B?Y1QveEZ0UTRKNjV6Tk9FR1FEQ01rYloyWm94NkJUU2lwNTZkT2JHRGdIaXNY?=
 =?utf-8?B?SERFQk1HNVk4UnJOTHA5d0R0MUFIK1d5cDQzNWF2cDJKVE1JcUdBS0h3V3JQ?=
 =?utf-8?B?WjNwNzc0S2RXT0VlZVIyRmxRQSt2OHR2ditsK0ROMVY1VjlYeFlPVEwwQTcz?=
 =?utf-8?B?SGxLamNLeVhTNDhoRkFQNWhKbFdGcWFQVDhqaDIvNXJiQVEyenZUVmZGQy95?=
 =?utf-8?B?aXZLc3dCcHNmL3NWSUhjcDFPNnpYVURLY2c4YlJITzJjN1BXQ3RWZWgwZVRt?=
 =?utf-8?B?TWlBL1hRbEFsOEtQNE80SnZvZGhhQ1BZSE9zTkZMUnpJQ3JURURmcE1wSUxT?=
 =?utf-8?B?YURTN1o0Uk5qbnVobFgwMzJRbDFaNEZUejNtRU9pRmNCRGduK1NFSkZLZlB1?=
 =?utf-8?B?dlA1K29ONmNzY1p0bEs3NWJlK2FoOExicTBvYndnZ0NXM1h2aVM3My9YQWgv?=
 =?utf-8?B?UmxSV0xZR0RZMWpYT09QbVFyNEJhLytZL2Z3Z3JXQnVWUFZPem1GTjhxMmRj?=
 =?utf-8?B?THQwK1lsZW92U3N4a3FVNEJhWHcwVDZlM0ZYQWQ0bzgxcGlMbkJGcjhOUHRI?=
 =?utf-8?B?NXZ2Q3doY0NhblhOZDFmVmFlaXBIZEpJdHFuYVFGMXIxVnJtU0N0Wi9aWlNP?=
 =?utf-8?B?UkNlZnhvTVk4dWo5MHlYRVlXWFNqRzRUcXZaM0hEdzdWdGtKSGRmQ1VDOUNn?=
 =?utf-8?B?Ungydndia0JSK1J5TWdpOG5xZEFySTBkeUdmTldIOGRKUERmUVlGbVU4WEFr?=
 =?utf-8?B?UUdtVWtmbTArTHU5YldNMk13THpKZDE5Q3kyU0pNWU1LRVIrQkx5ak02TWtR?=
 =?utf-8?B?a2ZOWHJ1WElKUng0c3l1aW5RbHhpenBsb09jOVkzL3A3VGJyL0l2SWJrbU1W?=
 =?utf-8?B?UWJNdVJrUS9SbUpISHNFMXVtcU14aDloRHJjc21NR2dGV0xEUzMvZVRIQStE?=
 =?utf-8?B?RUlSTFpHaURSNkVwelRybnRNTUtzcE4wZDRGWW8vMmljcVErRHNQbmRUQmZD?=
 =?utf-8?B?YmZ5RkJZVTZSNXZNQ2R2YlF5VjViUG9nSDEvWHlabHVtMjFONUltWGpCUERz?=
 =?utf-8?B?a3VGRlA3R2NYUjE0T2YzV1V2VEo5U0RFaktGbUg1Smo3YnpDVmxsKzNWek51?=
 =?utf-8?B?QVhIdzFWZ2FBclZMQTRkSStEZStQbTV1dmFlQlhvVWtsSUxzdythSnVHSU5m?=
 =?utf-8?B?ZUZZNmtXSmJaZVgvTTJ6MkhMQnZRR2Vvb28wYzZmMWlmNVU0UHJhSWFzaVFx?=
 =?utf-8?B?dlF2RjhpNnIrZ0IyUk80T2IvemttTTJOWGdyUFFiQUZTd2RRVFJrYjdvcks2?=
 =?utf-8?B?ZXBSZmZ2NzMycFhGY3Uyb2tQcWt1UlVWQ3FTZ2lxMnJXZEg4U3ZESnNaYXF0?=
 =?utf-8?B?MndXNFE2L0xlYlhIb0xoNEZZZW1DdmlYcW5hald3YUJVYmxIaGZ4US92bHI2?=
 =?utf-8?B?dHA0WEI0bm9ablY2bzlFL3YrdkxsYUVyeC9tTWo3OHpJcHFES2twZXFMS29M?=
 =?utf-8?B?T2x3anJoRnNMUCs0R1VTT0VUQk50emxlT3pHeHB4cWszS0t3anBxRXNTTGkv?=
 =?utf-8?Q?BP7JDVhdAPleC2trt/p5KTxiI?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f371219-21da-4025-cfb4-08db797dbcb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2023 15:21:54.7084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EwWAiB6RdcFEQZUhwObHO3xwd2u69y0F6C03CkF4emCh35VuwTa5tgnIM6si0jY6wVyRhnGKCjki1T8VltiM6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7186
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

SnVzdCBpbiBjYXNlIGl0IGlzIG5vdCBjbGVhcjogIGV2ZW50IGRlbGl2ZXJ5IGluIHJlYWwgbW9k
ZSBuZXZlciBpbmNsdWRlcyBhbiBlcnJvciBjb2RlLiAgVGhhdCBpcyB3aHkgdGhlIFBFIGJpdCBp
biBDUjAgaXMgY2hlY2tlZC4NCg0KCQkJLSBHaWwNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0t
LS0NCkZyb206IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPiANClNlbnQ6
IEZyaWRheSwgSnVuZSAzMCwgMjAyMyAwODowOA0KVG86IFlhbmcsIFdlaWppYW5nIDx3ZWlqaWFu
Zy55YW5nQGludGVsLmNvbT4NCkNjOiBHYW8sIENoYW8gPGNoYW8uZ2FvQGludGVsLmNvbT47IHBi
b256aW5pQHJlZGhhdC5jb207IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc7IHBldGVyekBpbmZyYWRlYWQub3JnOyBycHB0QGtlcm5lbC5vcmc7IGJpbmJp
bi53dUBsaW51eC5pbnRlbC5jb207IEVkZ2Vjb21iZSwgUmljayBQIDxyaWNrLnAuZWRnZWNvbWJl
QGludGVsLmNvbT47IGpvaG4uYWxsZW5AYW1kLmNvbTsgTmVpZ2VyLCBHaWwgPGdpbC5uZWlnZXJA
aW50ZWwuY29tPg0KU3ViamVjdDogUmU6IFtQQVRDSCB2MyAxMC8yMV0gS1ZNOng4NjogQWRkICND
UCBzdXBwb3J0IGluIGd1ZXN0IGV4Y2VwdGlvbiBjbGFzc2lmaWNhdGlvbg0KDQpPbiBGcmksIEp1
biAzMCwgMjAyMywgV2VpamlhbmcgWWFuZyB3cm90ZToNCj4gDQo+IE9uIDYvMTcvMjAyMyAyOjU3
IEFNLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPiA+ID4gRG8geW91IG1lYW4gZG9jdW1l
bnRhdGlvbiBmb3IgI0NQIGFzIGFuIGdlbmVyaWMgZXhjZXB0aW9uIG9yIHRoZSANCj4gPiA+IGJl
aGF2aW9yIGluIEtWTSBhcyB0aGlzIHBhdGNoIHNob3dzPw0KPiA+IEFzIEkgcG9pbnRlZCBvdXQg
dHdvICp5ZWFycyogYWdvLCB0aGlzIGVudHJ5IGluIHRoZSBTRE0NCj4gPiANCj4gPiAgICDigJQg
VGhlIGZpZWxkJ3MgZGVsaXZlci1lcnJvci1jb2RlIGJpdCAoYml0IDExKSBpcyAxIGlmIGVhY2gg
b2YgdGhlIGZvbGxvd2luZw0KPiA+ICAgICAgaG9sZHM6ICgxKSB0aGUgaW50ZXJydXB0aW9uIHR5
cGUgaXMgaGFyZHdhcmUgZXhjZXB0aW9uOyAoMikgYml0IDANCj4gPiAgICAgIChjb3JyZXNwb25k
aW5nIHRvIENSMC5QRSkgaXMgc2V0IGluIHRoZSBDUjAgZmllbGQgaW4gdGhlIGd1ZXN0LXN0YXRl
IGFyZWE7DQo+ID4gICAgICAoMykgSUEzMl9WTVhfQkFTSUNbNTZdIGlzIHJlYWQgYXMgMCAoc2Vl
IEFwcGVuZGl4IEEuMSk7IGFuZCAoNCkgdGhlIHZlY3Rvcg0KPiA+ICAgICAgaW5kaWNhdGVzIG9u
ZSBvZiB0aGUgZm9sbG93aW5nIGV4Y2VwdGlvbnM6ICNERiAodmVjdG9yIDgpLCAjVFMgKDEwKSwN
Cj4gPiAgICAgICNOUCAoMTEpLCAjU1MgKDEyKSwgI0dQICgxMyksICNQRiAoMTQpLCBvciAjQUMg
KDE3KS4NCj4gPiANCj4gPiBuZWVkcyB0byByZWFkIHNvbWV0aGluZyBsaWtlDQo+ID4gDQo+ID4g
ICAg4oCUIFRoZSBmaWVsZCdzIGRlbGl2ZXItZXJyb3ItY29kZSBiaXQgKGJpdCAxMSkgaXMgMSBp
ZiBlYWNoIG9mIHRoZSBmb2xsb3dpbmcNCj4gPiAgICAgIGhvbGRzOiAoMSkgdGhlIGludGVycnVw
dGlvbiB0eXBlIGlzIGhhcmR3YXJlIGV4Y2VwdGlvbjsgKDIpIGJpdCAwDQo+ID4gICAgICAoY29y
cmVzcG9uZGluZyB0byBDUjAuUEUpIGlzIHNldCBpbiB0aGUgQ1IwIGZpZWxkIGluIHRoZSBndWVz
dC1zdGF0ZSBhcmVhOw0KPiA+ICAgICAgKDMpIElBMzJfVk1YX0JBU0lDWzU2XSBpcyByZWFkIGFz
IDAgKHNlZSBBcHBlbmRpeCBBLjEpOyBhbmQgKDQpIHRoZSB2ZWN0b3INCj4gPiAgICAgIGluZGlj
YXRlcyBvbmUgb2YgdGhlIGZvbGxvd2luZyBleGNlcHRpb25zOiAjREYgKHZlY3RvciA4KSwgI1RT
ICgxMCksDQo+ID4gICAgICAjTlAgKDExKSwgI1NTICgxMiksICNHUCAoMTMpLCAjUEYgKDE0KSwg
I0FDICgxNyksIG9yICNDUCANCj4gPiAoMjEpWzFdDQo+ID4gDQo+ID4gICAgICBbMV0gI0NQIGhh
cyBhbiBlcnJvciBjb2RlIGlmIGFuZCBvbmx5IGlmIElBMzJfVk1YX0NSNF9GSVhFRDEgZW51bWVy
YXRlcw0KPiA+ICAgICAgICAgIHN1cHBvcnQgZm9yIHRoZSAxLXNldHRpbmcgb2YgQ1I0LkNFVC4N
Cj4gDQo+IEhpLCBTZWFuLA0KPiANCj4gSSBzZW50IGFib3ZlIGNoYW5nZSByZXF1ZXN0IHRvIEdp
bChhZGRlZCBpbiBjYyksIGJ1dCBoZSBzaGFyZWQgDQo+IGRpZmZlcmVudCBvcGluaW9uIG9uIHRo
aXMgaXNzdWU6DQoNCkhlaCwgIm9waW5pb24iLg0KDQo+IMKgSXQgbWF5IG1ha2UgdGhpbmdzIGNs
ZWFyZXIgaWYgd2UgZG9jdW1lbnQgdGhlIHN0YXRlbWVudCBhYm92ZSAoYWxsIA0KPiBDRVQtY2Fw
YWJsZSBwYXJ0cyBlbnVtZXJhdGUgSUEzMl9WTVhfQkFTSUNbNTZdIGFzIDEpLg0KPiANCj4gSSB3
aWxsIHNlZSBpZiB3ZSBjYW4gdXBkYXRlIGZ1dHVyZSByZXZpc2lvbnMgb2YgdGhlIFNETSB0byBj
bGFyaWZ5IHRoaXMuIg0KDQpUaGF0IHdvdWxkIGJlIGhlbHBmdWwuICBUaG91Z2ggdG8gYmUgcGVy
ZmVjdGx5IGhvbmVzdCwgSSBzaW1wbHkgb3Zlcmxvb2tlZCB0aGUgZXhpc3RlbmNlIG9mIElBMzJf
Vk1YX0JBU0lDWzU2XS4NCg0KVGhhbmtzIQ0KDQo+IFRoZW4gaWYgdGhpcyBpcyB0aGUgY2FzZSzC
oCBrdm0gbmVlZHMgdG8gY2hlY2sgSUEzMl9WTVhfQkFTSUNbNTZdIA0KPiBiZWZvcmUgaW5qZWN0
IGV4Y2VwdGlvbiB0byBuZXN0ZWQgVk0uDQo+IA0KPiBBbmQgdGhpcyBwYXRjaCBjb3VsZCBiZSBy
ZW1vdmVkLCBpbnN0ZWFkIG5lZWQgYW5vdGhlciBwYXRjaCBsaWtlIGJlbG93Og0KPiANCj4gZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL21zci1pbmRleC5oDQo+IGIvYXJjaC94ODYv
aW5jbHVkZS9hc20vbXNyLWluZGV4LmgNCj4gaW5kZXggYWQzNTM1NWVlNDNlLi42YjMzYWFjYzg1
ODcgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL21zci1pbmRleC5oDQo+ICsr
KyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL21zci1pbmRleC5oDQo+IEBAIC0xMDc2LDYgKzEwNzYs
NyBAQA0KPiDCoCNkZWZpbmUgVk1YX0JBU0lDX01FTV9UWVBFX01BU0vCoMKgwqAgMHgwMDNjMDAw
MDAwMDAwMDAwTExVDQo+IMKgI2RlZmluZSBWTVhfQkFTSUNfTUVNX1RZUEVfV0LCoMKgwqAgNkxM
VQ0KPiDCoCNkZWZpbmUgVk1YX0JBU0lDX0lOT1VUwqDCoMKgIMKgwqDCoCAweDAwNDAwMDAwMDAw
MDAwMDBMTFUNCj4gKyNkZWZpbmUgVk1YX0JBU0lDX0NIRUNLX0VSUkNPREXCoMKgwqAgMHgwMTQw
MDAwMDAwMDAwMDAwTExVDQoNCiJDaGVjayBFcnJvciBDb2RlIiBpc24ndCBhIGdyZWF0IGRlc2Ny
aXB0aW9uLiAgVGhlIGZsYWcgZW51bWVyYXRlcyB0aGF0IHRoZXJlIHRoZSBDUFUgZG9lcyAqbm90
KiBwZXJmb3JtIGNvbnNpc3RlbmN5IGNoZWNrcyBvbiB0aGUgZXJyb3IgY29kZSB3aGVuIGluamVj
dGluZyBoYXJkd2FyZSBleGNlcHRpb25zLg0KDQpTbyBzb21ldGhpbmcgbGlrZSB0aGlzPw0KDQog
IFZNWF9CQVNJQ19OT19IV19FUlJPUl9DT0RFX0NDDQoNCm9yIG1heWJlDQoNCiAgVk1YX0JBU0lD
X1BNX05PX0hXX0VSUk9SX0NPREVfQ0MNCg0KaWYgd2Ugd2FudCB0byBjYXB0dXJlIHRoYXQgb25s
eSBwcm90ZWN0ZWQgbW9kZSBpcyBleGVtcHQgKEkgcGVyc29uYWxseSBwcmVmZXIganVzdCBWTVhf
QkFTSUNfTk9fSFdfRVJST1JfQ09ERV9DQyBhcyAiUE0iIGlzIGEgYml0IGFtYmlndW91cykuDQoN
Cj4gQEAgLTI4NzMsNyArMjg3Myw4IEBAIHN0YXRpYyBpbnQgbmVzdGVkX2NoZWNrX3ZtX2VudHJ5
X2NvbnRyb2xzKHN0cnVjdA0KPiBrdm1fdmNwdSAqdmNwdSwNCj4gwqDCoMKgwqAgwqDCoMKgIHNo
b3VsZF9oYXZlX2Vycm9yX2NvZGUgPQ0KPiDCoMKgwqDCoCDCoMKgwqAgwqDCoMKgIGludHJfdHlw
ZSA9PSBJTlRSX1RZUEVfSEFSRF9FWENFUFRJT04gJiYgcHJvdF9tb2RlICYmDQo+IMKgwqDCoMKg
IMKgwqDCoCDCoMKgwqAgeDg2X2V4Y2VwdGlvbl9oYXNfZXJyb3JfY29kZSh2ZWN0b3IpOw0KPiAt
wqDCoMKgIMKgwqDCoCBpZiAoQ0MoaGFzX2Vycm9yX2NvZGUgIT0gc2hvdWxkX2hhdmVfZXJyb3Jf
Y29kZSkpDQo+ICvCoMKgwqAgwqDCoMKgIGlmICghY3B1X2hhc192bXhfYmFzaWNfY2hlY2tfZXJy
Y29kZSgpICYmDQo+ICvCoMKgwqAgwqDCoMKgIMKgwqDCoCBDQyhoYXNfZXJyb3JfY29kZSAhPSBz
aG91bGRfaGF2ZV9lcnJvcl9jb2RlKSkNCg0KVGhpcyBpcyB3cm9uZyBvbiBtdXRpcGxlIGZyb250
czoNCg0KICAxLiBUaGUgbmV3IGZlYXR1cmUgZmxhZyBvbmx5IGV4Y2VtcHRzIGhhcmR3YXJlIGV4
Y2VwdGlvbnMgZGVsaXZlcmVkIHRvIGd1ZXN0cw0KICAgICB3aXRoIENSMC5QRT0xLiAgVGhlIGFi
b3ZlIHdpbGwgc2tpcCB0aGUgY29uc2lzdGVuY3kgY2hlY2sgZm9yIGFsbCBldmVudCBpbmplY3Rp
b24uDQoNCiAgMi4gS1ZNIG5lZWRzIHRvIGNoZWNrIHRoZSBDUFUgbW9kZWwgdGhhdCBpcyBleHBv
c2VkIHRvIEwxLCBub3QgdGhlIGNhcGFiaWxpdGllcw0KICAgICBvZiB0aGUgaG9zdCBDUFUuDQoN
CkhpZ2hsaWdodGluZyB0aGUga2V5IHBocmFzZXMgaW4gdGhlIFNETToNCg0KICBUaGUgZmllbGQn
cyBkZWxpdmVyLWVycm9yLWNvZGUgYml0IChiaXQgMTEpIGlzIDEgaWYgZWFjaCBvZiB0aGUgZm9s
bG93aW5nIGhvbGRzOiAoMSkgdGhlIGludGVycnVwdGlvbiB0eXBlIGlzDQogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBeXl5eXl5eDQogIGhhcmR3
YXJlIGV4Y2VwdGlvbjsgKDIpIGJpdCAwIChjb3JyZXNwb25kaW5nIHRvIENSMC5QRSkgaXMgc2V0
IGluIHRoZSBDUjAgZmllbGQgaW4gdGhlIGd1ZXN0LXN0YXRlIGFyZWE7DQogICgzKSBJQTMyX1ZN
WF9CQVNJQ1s1Nl0gaXMgcmVhZCBhcyAwIChzZWUgQXBwZW5kaXggQS4xKTsgYW5kICg0KSB0aGUg
dmVjdG9yIGluZGljYXRlcyBvbmUgb2YgdGhlIGZvbGxvd2luZw0KICBleGNlcHRpb25zOiAjREYg
KHZlY3RvciA4KSwgI1RTICgxMCksICNOUCAoMTEpLCAjU1MgKDEyKSwgI0dQICgxMyksICNQRiAo
MTQpLCBvciAjQUMgKDE3KS4NCiAgDQogIFRoZSBmaWVsZCdzIGRlbGl2ZXItZXJyb3ItY29kZSBi
aXQgaXMgMCBpZiBhbnkgb2YgdGhlIGZvbGxvd2luZyBob2xkczogKDEpIHRoZSBpbnRlcnJ1cHRp
b24gdHlwZSBpcyBub3QgaGFyZHdhcmUNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIF5eXl5eXg0KICBleGNlcHRpb247ICgyKSBiaXQgMCBpcyBjbGVhciBpbiB0
aGUgQ1IwIGZpZWxkIGluIHRoZSBndWVzdC1zdGF0ZSBhcmVhOyBvciAoMykgSUEzMl9WTVhfQkFT
SUNbNTZdIGlzIHJlYWQgYXMNCiAgMCBhbmQgdGhlIHZlY3RvciBpcyBpbiBvbmUgb2YgdGhlIGZv
bGxvd2luZyByYW5nZXM6IDDigJM3LCA5LCAxNSwgMTYsIG9yIDE44oCTMzEuDQoNCkkgdGhpbmsg
d2hhdCB3ZSB3YW50IGlzOg0KDQoJCS8qIFZNLWVudHJ5IGludGVycnVwdGlvbi1pbmZvIGZpZWxk
OiBkZWxpdmVyIGVycm9yIGNvZGUgKi8NCgkJaWYgKCFwcm90X21vZGUgfHwgaW50cl90eXBlICE9
IElOVFJfVFlQRV9IQVJEX0VYQ0VQVElPTiB8fA0KCQkgICAgIW5lc3RlZF9jcHVfaGFzX25vX2h3
X2Vycm9yX2NvZGVfY2ModmNwdSkpIHsNCgkJCXNob3VsZF9oYXZlX2Vycm9yX2NvZGUgPQ0KCQkJ
CWludHJfdHlwZSA9PSBJTlRSX1RZUEVfSEFSRF9FWENFUFRJT04gJiYgcHJvdF9tb2RlICYmDQoJ
CQkJeDg2X2V4Y2VwdGlvbl9oYXNfZXJyb3JfY29kZSh2ZWN0b3IpOw0KCQkJaWYgKENDKGhhc19l
cnJvcl9jb2RlICE9IHNob3VsZF9oYXZlX2Vycm9yX2NvZGUpKQ0KCQkJCXJldHVybiAtRUlOVkFM
Ow0KCQl9DQo=
