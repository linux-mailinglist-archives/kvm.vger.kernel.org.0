Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974B96DF4AB
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 14:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbjDLMHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 08:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjDLMHS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 08:07:18 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8859E;
        Wed, 12 Apr 2023 05:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681301237; x=1712837237;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mt6cvSfE5clW8Djc8FOi8Qs5k0lhshCRy+PmwyCQx10=;
  b=jp2R+QGNDhlwl7c/7k5DIgdREzPf12zzsSiEh3JbTPJ0ejwS1tJiKRoO
   N1IaZP1CijYsDAUC5LDneMlZYywiI7ihvLZBxsE4W3wzP74VC4m2nD5qg
   q3ZRosYw1G11/BAZFkYq2tv7AdnnYiuyR47nVR9j69dYgvAzZGXUV+7Uc
   uPoT9rT7GtAW4XI173+lOwZTSW/FnwTX/PCDMaynSJ0RFLGbJBTN0216e
   z5rfVL/bO3J+hUS7ONUsJl5MMm7MIdyANwJZAXDBDthP8fKIJGLamQjw8
   3iaqhi7hcXmlOAOfOU9g/fY9kdonxGmG7LJ6pbM4jXYrBcfYJdYzmUPkg
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="409012441"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="409012441"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 05:07:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="863276293"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="863276293"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 12 Apr 2023 05:07:16 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 05:07:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 05:07:16 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 05:07:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQP6XKOEsF8ByowBClS/ifg1fLAabKdy3bMJbkxlYbZoUoYKxa0SEr6HmiEYZKKwM4lDMLRHauFRhjoCwtk0UPG8UQZ6kq4Ee30yBg7BBFh2VGDlDabJyCPwDWG9Lcp5cQ4Ge46ZSvUK9yxS6lxsujyFDsi1cpT1mLOdsnGV9M3irqj7nofFZfomNV4oV1L47Rau5JBLTgjSmRd1yITopmI/Sg1roLAiUDUA2Ar7ypjapedKtyP0oeb/jyaKhU75T8NpqXhRAzVJd4Q1AxM06JmAt27HkRCfiRRiyeSuobQ5Exo9BMDkBDbkNubYpOYCNl0ioS6nHsQE3U5bucjbLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mt6cvSfE5clW8Djc8FOi8Qs5k0lhshCRy+PmwyCQx10=;
 b=GtxeGRPyqQoUmXj6OenjVGLAP4jkClkbMjSf39g/WSkAaLgxTiVBK8DarvsKZ7SlB1a3Tj2OON1iwyuBAgIHdl+do7SRCUBhv9OQ3IXhUuo+Ke4CufQAsdRBLDqYmcccIQWhFnVleOEyMHVzH9sNjkVlkywIhE4jfsAxPNJbt6pK8/QNHAq5CBh5Quv0UWQs+rIaaIBLm7iLpsCGqOccjPzArnvkzonogegJLId/ToGhcbd1rx08E3bSNay0m2i29bo7cZDiG/zNr7j4jJ5rRrUhMrjot+uexeRT28fm91tCrfo8agu+zhWOZg0Awr+h5rVGT9UbPpB1HjEwmr5g2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6675.namprd11.prod.outlook.com (2603:10b6:510:1ad::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 12 Apr
 2023 12:07:13 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5%3]) with mapi id 15.20.6277.034; Wed, 12 Apr 2023
 12:07:13 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] KVM: x86: SGX vs. XCR0 cleanups
Thread-Topic: [PATCH 0/3] KVM: x86: SGX vs. XCR0 cleanups
Thread-Index: AQHZZ1neAPY41R6lzkG8Mkf04T1Dpq8cd6WAgAETnwCAAIN/gIAJkScA
Date:   Wed, 12 Apr 2023 12:07:13 +0000
Message-ID: <e1e7a37a29c2c7ad22cd14181f24b06088eca451.camel@intel.com>
References: <20230405005911.423699-1-seanjc@google.com>
         <d0af618169ebc17722e7019ca620ec22ee0b49c3.camel@intel.com>
         <ZC4qF90l77m3X1Ir@google.com>
         <20230406130119.000011fe.zhi.wang.linux@gmail.com>
In-Reply-To: <20230406130119.000011fe.zhi.wang.linux@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6675:EE_
x-ms-office365-filtering-correlation-id: 60212562-4b3b-4698-d2e6-08db3b4e7392
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gQRe+OMsM3dpB8nSH5Na2WTWzeYTpUjM9bSwCAq5inlzg7yvCfGXCqK358l1EQHhQSxHXYQPowuFooZ3RrQ8zR7zkFq2egAT7xw52scHsslkngWVJ3ZMn1I7RBHteMuAldZ0oQu/A7stUVYM8u/r2TWcVpDo9+uTgBxkmXvLGauKeVk+ePcleJs1dQOQsDDOJYEgC72XuY/qee5rEb2g7MFwcJUzgNT19Vz+Q9x/mXvBMdGUVsQEtSdQerLolS6JUFvLwf+wbTFJ8IiSUQivX5LZJWrc2ShlAyj+haS/VbvHXJieyDCwTNSZYZg+dkiV63yej0NOexzeuKAqDjJEnTYmzfN5pDQGWybZW2psNVw3fJ7csuG4Hs0i1RXF4dDjZ8diXX/yKXsnVE9DJ4Gn+aeHIvqOhYTFQl0XJi3qjk2WohJXDbY114KoLQ2V6hItwIfXA4Kk294X8ZScmHRINKOWyw/rcuF+DG5cZYwzj8IMHqCyPy/rZGTB5uJ98i9ylvIBQW95vZB/WxCo8Rlm7gvAdQy2rmeV7dy4TMhTmj5gvR1jdVvYDgDQ/0ig0Moj+YsVdgvovjTADxqaU2bSIlZcY0jpaXQNZCmioKVcEVG7xgAxzd1PaBgK5W1d0zgg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(366004)(136003)(39860400002)(346002)(451199021)(6506007)(6512007)(66946007)(86362001)(66899021)(66556008)(26005)(186003)(91956017)(66446008)(316002)(478600001)(54906003)(110136005)(71200400001)(6486002)(8936002)(5660300002)(66476007)(82960400001)(38070700005)(36756003)(38100700002)(64756008)(2906002)(4326008)(41300700001)(122000001)(76116006)(8676002)(83380400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UlFXR3Z6d3dZUlRpTEJwYldDMGxYRGE2QTZ6b2YvMnVSMXE2UVpkblBFK1RM?=
 =?utf-8?B?TDVncm5paWh2SU9pK3AveTlKdStUd0VKUDZJMytxaHdNeWV3RG1VRnR1ZWxj?=
 =?utf-8?B?UzJlbm9xaWFzL3p2b0FFcVdwK0poWTg3NlR4Z1c3ZzdUa01tcGpTVXg2K1Er?=
 =?utf-8?B?YUQ2SEZaY3Nhd09kS0loT0NrSlJ3aktPdEsvaTBwN0lEYkFSZ29xU3Y5NkUx?=
 =?utf-8?B?WVNRTmdNSmZWUklIeW5ZY05vNmVOSkxEcmV3ZmJnZDBEZjdDY1ROZU44QUNi?=
 =?utf-8?B?azNPMTNBQVJEVzU2b3B0bVRFaFRXbU5KSTRocURPL2VHaUZtME53NXVyTFNQ?=
 =?utf-8?B?bEFUWjFSUEpkZWg5UnRod1lXMnZ0dEpNRHVzNzN3L2Rpc3R6b3czdnh1ZHlQ?=
 =?utf-8?B?ZjB1S213MDRya2VnYzZzR0RhQW9qWlFwa1Y3V0c1MGJ4bkJGeUNKWG1PUGR5?=
 =?utf-8?B?R2grYURwVXBSZUNBRGRpOTFJeUpXTHRXOGhUU0FNbUdpVkdreXZrMkdUU0dF?=
 =?utf-8?B?K3pGdDh6YlpTWkhDaUtiZUpOckgvdWpzRmpSL2xhSlhBZCt5a1ZEWUZHdDBV?=
 =?utf-8?B?NGtBdlgzTzZxNTRjVHBMM1RSNjFLeW94V1h6T0tsaXlTSEJDTnZvdWkzMU9a?=
 =?utf-8?B?YnhROGxIaVFoczdpeE4reXJ0djEwblZyMzlMd2Fic0FUWVRWMFAzL2JqQ2NG?=
 =?utf-8?B?bkNEV1B5QVgweWFUWGNnM2k3YjdrbDZmWWRlMzdpbGcxaXBMTU92UURpLzkw?=
 =?utf-8?B?RDlFcDJiVUVYcEExR1k3WGoydTgycXJuNlRzdmthWm1nV0lBaE5QNlpYUVNa?=
 =?utf-8?B?V2owVkVXcjJvRjZtOCtpSGhGNEhkTlJvVFFZTW1oYTEwMGVKU0hmc1RUaDho?=
 =?utf-8?B?eEVaWDFGQlhIK0lkNEVKcVNUSk5MMzNaVGdQWTQ3b3RUc1RPTEdPVEMxTzJN?=
 =?utf-8?B?aVczSysySUJ3OHAwWUgySVJJdHgycVJJck45dTF1OEVQVVRGTzVic3RSSnZM?=
 =?utf-8?B?ZkpCVVU0V0xPY0xwK0hvWFhGNUgrMTlEVXBuR1B4ZVRPKzRxSjBER2VHeFRK?=
 =?utf-8?B?YkNNMk9TMHpnL2Z2amZHM3VMSGxlNGRhVk1Udmc1dnVjTkZiVDdPUVRoWjEv?=
 =?utf-8?B?cXQyNU82TlVrVVN2OEpaaXNuNHZKRVFjRXpmUGQvMGdEMTRVK2hodHFrTURE?=
 =?utf-8?B?Tk8vTyswbFg1TlljYzI5ZEl5ZDlRZVVzWTRTMDNrUVI3a0IreFo4WkUzd1RD?=
 =?utf-8?B?dm1McmxBbllUaGlTdjBiSXJFNm1WN0dNY1dpcmtodldJcUxsQkhxUzR5TWZR?=
 =?utf-8?B?bmpiYzlFOW5YOTUxcjhZM1YvbWxZMWhsOVdQeGlteTZuczhHekpFUk5OLzRi?=
 =?utf-8?B?V29IRDJ3VmMvOU1ldUVEbnE0MjVaZVF3S2wrdWsrb0o5NWhlVVZ1bmdIU0cw?=
 =?utf-8?B?VzFDa0ErVnUwYkcvQWFabFFzSlhyVGJ6M05PcVd5djRNd01wbmJWQkc1UXBQ?=
 =?utf-8?B?L2pVUDVKOWFGVWpCREE2NW5BcDlWeHZVSVlGZE8ydVJwQTJjQWR1eWtyK1Rt?=
 =?utf-8?B?UThxYUFkRmpLUXdqVnA2cWl5UUhLTDZMQ0JRcFo1YzlZU0swZ1o3eFd1NVhQ?=
 =?utf-8?B?Rlk5L1ZUK2VJQkUyRHFySVJ6anZOU1VDUzFWNi9jcmt4L05HQ2UvOHdOdk9n?=
 =?utf-8?B?SlRlcDBGTExZVUhZSDRVWnI5N1lodC9FSksrOUl6U3ZJZnlxR294bUVkR1dQ?=
 =?utf-8?B?cStTVHhML1h0VTkyb1BoSGY2eDVQVzRjcTRHT3FtMHl0R1YrdlZ2SW9hZmlr?=
 =?utf-8?B?eTNiM1RLVEZGNkVQRkhzVWN0YU5wcWZRNVNCdFIxdEx2aFBqamZPSFJ4Ulc2?=
 =?utf-8?B?LzNsa2NWbWh3aUFCSFB4MG9BMkpYazRvNnd3eHFDTFNlYXZCaFRVcmhPTkhh?=
 =?utf-8?B?SDFpcTBBaGFYZVYzMERnYy9FaE9qOUxQeFRDQkUzckY3aiswdTF0emZxOGtF?=
 =?utf-8?B?bDJ4YTdCZHVJeUoxM3Y0b21MNzRabHIwdUI4UURRWGJyOGozdUhCa3ErY1Rh?=
 =?utf-8?B?aEtxSVBUNHhySzZiUzV5bHdYSThLbEtpY3Y3S0xMVnJzSlFISmNGK2VwV2I2?=
 =?utf-8?Q?JzQOlOmQVr9GicfwykDPyMUoT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1EA24BB41E5C384BB42B17DECAE48FAE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60212562-4b3b-4698-d2e6-08db3b4e7392
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 12:07:13.5272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rCG58yqIoSNhL/u0woZrBRLaj+bz3ohgr0YYCByeun4mbMbsee+wKmjnN1MbGYmo4pB6TeHOPn9+nWBGh0QosA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6675
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA0LTA2IGF0IDEzOjAxICswMzAwLCBaaGkgV2FuZyB3cm90ZToNCj4gT24g
V2VkLCA1IEFwciAyMDIzIDE5OjEwOjQwIC0wNzAwDQo+IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNl
YW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gV2VkLCBBcHIgMDUsIDIwMjMsIEh1
YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiBPbiBUdWUsIDIwMjMtMDQtMDQgYXQgMTc6NTkgLTA3MDAs
IFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+ID4gPiA+ICoqKiBXQVJOSU5HICoqKiBBQkkg
YnJlYWthZ2UuDQo+ID4gPiA+IA0KPiA+ID4gPiBTdG9wIGFkanVzdGluZyB0aGUgZ3Vlc3QncyBD
UFVJRCBpbmZvIGZvciB0aGUgYWxsb3dlZCBYRlJNIChhLmsuYS4gWENSMCkNCj4gPiA+ID4gZm9y
IFNHWCBlbmNsYXZlcy4gIFBhc3QgbWUgZGlkbid0IHVuZGVyc3RhbmQgdGhlIHJvbGVzIGFuZCBy
ZXNwb25zaWJpbGl0aWVzDQo+ID4gPiA+IGJldHdlZW4gdXNlcnNwYWNlIGFuZCBLVk0gd2l0aCBy
ZXNwZWN0IHRvIENQVUlEIGxlYWZzLCBpLmUuIEkgdGhvdWdodCBJIHdhcw0KPiA+ID4gPiBiZWlu
ZyBoZWxwZnVsIGJ5IGhhdmluZyBLVk0gYWRqdXN0IHRoZSBlbnRyaWVzLg0KPiA+ID4gDQo+ID4g
PiBBY3R1YWxseSBJIGFtIG5vdCBjbGVhciBhYm91dCB0aGlzIHRvcGljLg0KPiA+ID4gDQo+ID4g
PiBTbyB0aGUgcnVsZSBpcyBLVk0gc2hvdWxkIG5ldmVyIGFkanVzdCBDUFVJRCBlbnRyaWVzIHBh
c3NlZCBmcm9tIHVzZXJzcGFjZT8NCj4gPiANCj4gPiBZZXMsIGV4Y2VwdCBmb3IgdHJ1ZSBydW50
aW1lIGVudHJpZXMgd2hlcmUgYSBDUFVJRCBsZWFmIGlzIGR5bmFtaWMgYmFzZWQgb24gb3RoZXIN
Cj4gPiBDUFUgc3RhdGUsIGUuZy4gQ1I0IGJpdHMsIE1JU0NfRU5BQkxFUyBpbiB0aGUgTU9OSVRP
Ui9NV0FJVCBjYXNlLCBldGMuDQo+ID4gDQo+ID4gPiBXaGF0IGlmIHRoZSB1c2Vyc3BhY2UgcGFz
c2VkIHRoZSBpbmNvcnJlY3QgQ1BVSUQgZW50cmllcz8gIFNob3VsZCBLVk0gc2FuaXRpemUNCj4g
PiA+IHRob3NlIENQVUlEIGVudHJpZXMgdG8gZW5zdXJlIHRoZXJlJ3Mgbm8gaW5zYW5lIGNvbmZp
Z3VyYXRpb24/ICBNeSBjb25jZXJuIGlzIGlmDQo+ID4gPiB3ZSBhbGxvdyBndWVzdCB0byBiZSBj
cmVhdGVkIHdpdGggaW5zYW5lIENQVUlEIGNvbmZpZ3VyYXRpb25zLCB0aGUgZ3Vlc3QgY2FuIGJl
DQo+ID4gPiBjb25mdXNlZCBhbmQgYmVoYXZpb3VyIHVuZXhwZWN0ZWRseS4NCj4gPiANCj4gPiBJ
dCBpcyB1c2Vyc3BhY2UncyByZXNwb25zaWJpbGl0eSB0byBwcm92aWRlIGEgc2FuZSwgY29ycmVj
dCBzZXR1cC4gIFRoZSBvbmUNCj4gPiBleGNlcHRpb24gaXMgdGhhdCBLVk0gcmVqZWN0cyBLVk1f
U0VUX0NQVUlEezJ9IGlmIHVzZXJzcGFjZSBhdHRlbXB0cyB0byBkZWZpbmUgYW4NCj4gPiB1bnN1
cHBvcnRlZCB2aXJ0dWFsIGFkZHJlc3Mgd2lkdGgsIHRoZSBhcmd1bWVudCBiZWluZyB0aGF0IGEg
bWFsaWNpb3VzIHVzZXJzcGFjZQ0KPiA+IGNvdWxkIGF0dGFjayBLVk0gYnkgY29lcmNpbmcgS1ZN
IGludG8gc3R1ZmYgYSBub24tY2Fub25pY2FsIGFkZHJlc3MgaW50byBlLmcuIGENCj4gPiBWTUNT
IGZpZWxkLg0KPiA+IA0KPiA+IFRoZSByZWFzb24gZm9yIEtWTSBwdW50aW5nIHRvIHVzZXJzcGFj
ZSBpcyB0aGF0IGl0J3MgYWxsIGJ1dCBpbXBvc3NpYmxlIHRvIGRlZmluZQ0KPiA+IHdoYXQgaXMv
aXNuJ3Qgc2FuZS4gIEEgcmVhbGx5IGdvb2QgZXhhbXBsZSB3b3VsZCBiZSBhbiBhbHRlcm5hdGl2
ZSB3ZSAoR29vZ2xlKQ0KPiA+IGNvbnNpZGVyZWQgZm9yIHRoZSAic21hbGxlciBNQVhQSFlBRERS
IiBmaWFzY28sIHRoZSB1bmRlcmx5aW5nIHByb2JsZW0gYmVpbmcgdGhhdA0KPiA+IG1pZ3JhdGlu
ZyBhIHZDUFUgd2l0aCBNQVhQSFlBRERSPTQ2IHRvIGEgc3lzdGVtIHdpdGggTUFYUEhZQUREUj01
MiB3aWxsIGluY29ycmVjdGx5DQo+ID4gbWlzcyByZXNlcnZlZCBiaXQgI1BGcy4NCj4gPiANCj4g
PiBSYXRoZXIgdGhhbiB0ZWFjaCBLVk0gdG8gdHJ5IGFuZCBkZWFsIHdpdGggc21hbGxlciBNQVhQ
SFlBRERScywgYW4gaWRlYSB3ZSBjb25zaWRlcmVkDQo+ID4gd2FzIHRvIGluc3RlYWQgZW51bWVy
YXRlIGd1ZXN0Lk1BWFBIWUFERFI9NTIgb24gcGxhdGZvcm1zIHdpdGggaG9zdC5NQVhQSFlBRERS
PTQ2IGluDQo+ID4gYW50aWNpcGF0aW9uIG9mIGV2ZW50dWFsIG1pZ3JhdGlvbi4gIFNvIGxvbmcg
YXMgdXNlcnNwYWNlIGRvZXNuJ3QgYWN0dWFsbHkgZW51bWVyYXRlDQo+ID4gbWVtc2xvdHMgaW4g
dGhlIGlsbGVnYWwgYWRkcmVzcyBzcGFjZSwgS1ZNIHdvdWxkIGJlIGFibGUgdG8gdHJlYXQgc3Vj
aCBhY2Nlc3NlcyBhcw0KPiA+IGVtdWxhdGVkIE1NSU8sIGFuZCB3b3VsZCBvbmx5IG5lZWQgdG8g
aW50ZXJjZXB0ICNQRihSU1ZEKS4NCj4gPiANCj4gPiBDaXJjbGluZyBiYWNrIHRvICJ3aGF0J3Mg
c2FuZSIsIGVudW1lcmF0aW5nIGd1ZXN0Lk1BWFBIWUFERFIgPiBob3N0Lk1BWFBIWUFERFINCj4g
PiBkZWZpbml0ZWx5IHF1YWxpZmllcyBhcyBpbnNhbmUgc2luY2UgaXQgcmVhbGx5IGNhbid0IHdv
cmsgY29ycmVjdGx5LCBidXQgaW4gb3VyDQo+ID4gb3BpbmlvbiBpdCB3YXMgZmFyIHN1cGVyaW9y
IHRvIHJ1bm5pbmcgd2l0aCBhbGxvd19zbWFsbGVyX21heHBoeWFkZHI9dHJ1ZS4NCj4gPiANCj4g
PiBBbmQgc2FuZSBpcyBub3QgdGhlIHNhbWUgdGhpbmcgYXMgYXJjaGl0ZWN0dXJhbGx5IGxlZ2Fs
LiAgQU1YIGlzIGEgZ29vZCBleGFtcGxlDQo+ID4gb2YgdGhpcy4gIEl0J3MgX3RlY2huaWNhbGx5
XyBsZWdhbCB0byBlbnVtZXJhdGUgc3VwcG9ydCBmb3IgWEZFQVRVUkVfVElMRV9DRkcgYnV0DQo+
ID4gbm90IFhGRUFUVVJFX1RJTEVfREFUQSBpbiBDUFVJRCwgYnV0IGlsbGVnYWwgdG8gYWN0dWFs
bHkgdHJ5IHRvIGVuYWJsZSBUSUxFX0NGRw0KPiA+IGluIFhDUjAgd2l0aG91dCBhbHNvIGVuYWJs
aW5nIFRJTEVfREFUQS4gIEtWTSBzaG91bGQgYXJndWFibHkgcmVqZWN0IENQVUlEIGNvbmZpZ3MN
Cj4gPiB3aXRoIFRJTEVfQ0ZHIGJ1dCBub3QgVElMRV9EQVRBLCBhbmQgdmljZSB2ZXJzYSwgYnV0
IHRoZW4gS1ZNIGlzIHJlamVjdGluZyBhIDEwMCUNCj4gPiBhcmNoaXRlY3R1cmFsbHkgdmFsaWQs
IGlmIGluc2FuZSwgQ1BVSUQgY29uZmlndXJhdGlvbi4gIERpdHRvIGZvciBuZWFybHkgYWxsIG9m
DQo+ID4gdGhlIFZNWCBjb250cm9sIGJpdHMgdmVyc3VzIHRoZWlyIENQVUlEIGNvdW50ZXJwYXJ0
cy4NCj4gPiANCj4gPiBBbmQgc29tZXRpbWVzIHRoZXJlIGFyZSBnb29kIHJlYXNvbnMgdG8gcnVu
IGEgVk0gd2l0aCBhIHRydWx5IGluc2FuZSBjb25maWd1cmF0aW9uLA0KPiA+IGUuZy4gZm9yIHRl
c3RpbmcgcHVycG9zZXMuDQo+ID4gDQo+ID4gVEw7RFI6IHRyeWluZyB0byBlbmZvcmNlICJzYW5l
IiBDUFVJRC9mZWF0dXJlIGNvbmZpZ3VyYXRpb24gaXMgYSBnaWdhbnRpYyBjYW4gb2Ygd29ybXMu
DQo+IA0KPiBJbnRlcmVzdGluZyBwb2ludC4gSSB3YXMgZGlnZ2luZyB0aGUgQ1BVSUQgdmlydHVh
bGl6YXRpb24gT0YgVERYL1NOUC4NCj4gSXQgd291bGQgYmUgbmljZSB0byBoYXZlIGEgY29uY2x1
c2lvbiBvZiB3aGF0IGlzICJzYW5lIiBhbmQgd2hhdCBpcyB0aGUNCj4gcHJvcGVyIHJvbGUgZm9y
IEtWTSwgYXMgZmlybXdhcmUvVERYIG1vZHVsZSBpcyBnb2luZyB0byB2YWxpZGF0ZSB0aGUgInNh
bmUiDQo+IENQVUlELg0KPiANCj4gVERYL1NOUCByZXF1aXJlcyB0aGUgQ1BVSUQgdG8gYmUgcHJl
LWNvbmZpZ3VyZWQgYW5kIHZhbGlkYXRlZCBiZWZvcmUgY3JlYXRpbmcNCj4gYSBDQyBndWVzdC4g
KEl0IGlzIGRvbmUgdmlhIFRESC5NTkcuSU5JVCBpbiBURFggYW5kIGluc2VydGluZyBhIENQVUlE
IHBhZ2UgaW4NCj4gU05QX0xBVU5DSF9VUERBVEUgaW4gU05QKS4NCj4gDQo+IElJVUMgYWNjb3Jk
aW5nIHRvIHdoYXQgeW91IG1lbnRpb25lZCwgS1ZNIHNob3VsZCBiZSB0cmVhdGVkIGxpa2UgIkNQ
VUlEIGJveCINCj4gZm9yIFFFTVUgYW5kIHRoZSBjaGVja3MgaW4gS1ZNIGlzIG9ubHkgdG8gZW5z
dXJlIHRoZSByZXF1aXJlbWVudHMgb2YgYSBjaG9zZW4NCj4gb25lIGlzIGxpdGVyYWxseSBwb3Nz
aWJsZSBhbmQgY29ycmVjdC4gS1ZNIHNob3VsZCBub3QgY2FyZSBpZiB0aGUgY29tYmluYXRpb24s
IHRoZSB1c2FnZSBvZiB0aGUgY2hvc2VuIG9uZXMgaXMgaW5zYW5lIG9yIG5vdCwgd2hpY2ggZ2l2
ZXMgUUVNVSBmbGV4aWJpbGl0eS4NCj4gDQo+IEFzIHRoZSB2YWxpZCBDUFVJRHMgaGF2ZSBiZWVu
IGRlY2lkZWQgd2hlbiBjcmVhdGluZyBhIENDIGd1ZXN0LCB3aGF0IHNob3VsZCBiZQ0KPiB0aGUg
cHJvcGVyIGJlaGF2aW9yIChiYXNpY2FsbHkgYW55IG5ldyBjaGVja3M/KSBvZiBLVk0gZm9yIHRo
ZSBsYXRlcg0KPiBTRVRfQ1BVSUQyPyBNeSBndXQgZmVlbGluZyBpcyBLVk0gc2hvdWxkIGtub3cg
dGhlICJDUFVJRCBib3giIGlzIHJlZHVjZWQNCj4gYXQgbGVhc3QsIGJlY2F1c2Ugc29tZSBLVk0g
Y29kZSBwYXRocyByZWx5IG9uIGd1ZXN0IENQVUlEIGNvbmZpZ3VyYXRpb24uDQoNCkZvciBURFgg
Z3Vlc3QgbXkgcHJlZmVyZW5jZSBpcyBLVk0gdG8gc2F2ZSBhbGwgQ1BVSUQgZW50cmllcyBpbiBU
REguTU5HLklOSVQgYW5kDQptYW51YWxseSBtYWtlIHZjcHUncyBDUFVJRCBwb2ludCB0byB0aGUg
c2F2ZWQgQ1BVSURzLiAgQW5kIHRoZW4gS1ZNIGp1c3QgaWdub3JlDQp0aGUgU0VUX0NQVUlEMiBm
b3IgVERYIGd1ZXN0Lg0KDQpOb3Qgc3VyZSB3aGV0aGVyIEFNRCBjb3VudGVycGFydCBjYW4gYmUg
ZG9uZSBpbiBzaW1pbGFyIHdheSB0aG91Z2guIA0K
