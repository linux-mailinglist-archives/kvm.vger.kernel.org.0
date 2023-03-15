Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8AF6BAE0C
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 11:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbjCOKqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 06:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbjCOKqU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 06:46:20 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3055988D97;
        Wed, 15 Mar 2023 03:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678877129; x=1710413129;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Ve7ODDDlE2KQC/vD8x7VJXALnf/lfT+PPF2NDmFcCAY=;
  b=Y9zhgk9c2XMJRONU1K4g7KDc1vzJ0NHDpzUH0ZQpm4Fo9C5zcq4p4uzr
   /JRzqQgn1AOlMUZSIalJJwDsVPh7XrELq3wCf3co+ZFWBkV9w3OWItnXa
   ubhhhk32hf0vnj23vuuwsRb8/5N5zUEZgWRAQBa80JjYOXlFnN0hzyE33
   0Nk2ocsdbIqJjeiVTM6wDTjedm7VMN8pdTjQ/AzOVqD55d+ZRFRpr7LIw
   1JohRhA01fTqy5qt473wPZNlVvSVfXhh8ov+shVx122Ew67DfpVCp2k/T
   fvdmFAmWw/P1FYoUvHMohU9iNSYBUMLABDGLK630XSGeO+zFNFfYH13mI
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="400250512"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="400250512"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 03:45:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="822735125"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="822735125"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 15 Mar 2023 03:45:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 03:45:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 03:45:02 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 03:45:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NnGKmz6vFAMvBzKPVwDF9JVXAPcd5qr6lidyiVBRIVw8T436fVMyYWMbStVGjwRAZOsmsCyFcc5IcyWS2UDLpEOMbNotYNQy9sa1f2b2cyyEoOTjqFL8jy4g4/sOfwrj9u68FthlrvPo3PUMqL9tSGV54Ab8x1YAX6JpKSwIrC6WlkeRle6zejgAeTR4PMjVcwQJ201QHBvCS8afqGa0k3n0X9ljk5E8n67WXH5YDiz4hsA9+J7OagmzIdxlLZu9QpN7PuLixVuTYKgyECceoSMq5WUz2auQXBz/iXgzucOElIPIDSar9r/pN14ir+73x2Rtfv5kNg4HzC0UigXnmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ve7ODDDlE2KQC/vD8x7VJXALnf/lfT+PPF2NDmFcCAY=;
 b=mphY9EvrPJlc+EpTOyJstKC6L8mWbL0tblngKgg/LInOMFjRbu3WnWcexqziUm0fkQrBSU3UI+rAdwOsJijbIxi5GPCagMmTrS9pmbFlzaMzuV/3HX0whdPWvjeZIBbYQ5sEdeX51XLp4UZVUvqEWCmnDvQTdxsUQopH6f3p5npkRd4vxTrAn88Go0+MPNlKVqPWfusS0feTZOPYilGDCu3hrm+mngjDBVaWGgkDj0DvguJI9NITvkK7VA67AFBQAh4zm95inFaQqCYdzonM7ho3yxsSaFhphZXA9Jk2/NcNZR5Gyj6e7AcOOznnO4J10fdpVQMajxoZ5by8P3UJrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6991.namprd11.prod.outlook.com (2603:10b6:806:2b8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.23; Wed, 15 Mar
 2023 10:44:58 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 10:44:57 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH v13 006/113] KVM: x86: Introduce vm_type to differentiate
 default VMs from confidential VMs
Thread-Topic: [PATCH v13 006/113] KVM: x86: Introduce vm_type to differentiate
 default VMs from confidential VMs
Thread-Index: AQHZVQwx8IKpV4rtKU6cPaQJA8JT4q77rEIA
Date:   Wed, 15 Mar 2023 10:44:57 +0000
Message-ID: <c3bc88055c6610c2d0102fd3e70ade61fb4e1a32.camel@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
         <78dac4d2133a7c48b2da21a8f9e0922ad38c3f7b.1678643052.git.isaku.yamahata@intel.com>
In-Reply-To: <78dac4d2133a7c48b2da21a8f9e0922ad38c3f7b.1678643052.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6991:EE_
x-ms-office365-filtering-correlation-id: b4125cf5-2517-44fb-9275-08db254251ce
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vg5dmMHmfOuhB0XZX7wkzPDB6hEY9lbnEfNhPBMf7ednS8Q14aLUjV5m6CSpCpjqe4spoCC3LUrfFNILgrMACTdMuQFjiDCfejCoFzdrlNsVgm7tSwhbP3I2A2q+v4iPU66sNCuhuEswoDWEOQMlFi6VfDQIAG99kjfHOr+774JfYV2nhnwoPqkyC5yrmBrRXodZgLm7nypiN3e9Gf4t5Cv+C6x/wnslMoMBJd+IZsGe1yXxh7VdtPUDKtqps6MszytEf6e04zbRU9WjUl64Z9Hfw7DMxaPmtoKECJmDKkXBk2HCl7dC2C9ilWYAHQx7/TxHdJUbmTj40vulsjCFs42DMLW2YpeKA6mo5J0fo6HWVUrU9Jkmr9UZHuoSwZ47bDOBES9rPz/J41YJsFNjVKk+a6n9gEk0/6yrajEQ9QtbjsE4IK36eS0x0KjT6HjfHEhNnMWfGHmn6gJONg+ffsk9QdzzUEzAgMC4X2FpUCJGYNebz4Ev5hY/qNTUAG6DC/ZxIwHW1B8hyaMyNowtPVRE5CD8Tj4/ZHMrS3Fhf0XOGCH7MuhUbLOt2rd1KWWLgiOm4x+uc/vq7MIGMZv4nRrvG+K3QoCqLMhIpmFewXeNm3QmuVow+Dze9Cb7UiF8hb5e2b4rh3j7KintDqvTlv6w1KQy/g1WuXfP+rdgVzfIxM7Heb7fMuC5be7unPepwW+BxMgUuduBZX2FYVOAvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(39860400002)(376002)(396003)(136003)(451199018)(6486002)(41300700001)(8936002)(64756008)(76116006)(66476007)(66556008)(5660300002)(4744005)(4326008)(66946007)(2906002)(38070700005)(122000001)(38100700002)(8676002)(66446008)(36756003)(82960400001)(110136005)(6512007)(54906003)(6636002)(316002)(6506007)(478600001)(86362001)(71200400001)(2616005)(26005)(91956017)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dHhRU1dmbGxpQ21CSk9UTUhTcXluQzQ0bmg2NEMraXArYldEaHBmdVloZGhH?=
 =?utf-8?B?clprRkZ1azRwVGc3T2NybWhxbHFsUks2d2U1d0JlVittS1ZpaTNUZU44NzZE?=
 =?utf-8?B?bEdhc2JUMHgreHltTHVqUkNGbldSaUlncW1kZXEyS1RidFZha0gvdFZtWlM5?=
 =?utf-8?B?RGlsNVczbHUvUW1kVXVCSmg0NnJpcE9FZ1d6OVlZMkh0eWxzY3hCSkxtVnht?=
 =?utf-8?B?aDdQaU85ejdGMnlHNDFRL295T29jWWVuZGNjYTM3TEtpZTlxZHJhRWtHcGpT?=
 =?utf-8?B?YmtmalZNQ3RLNld1clJDLzBhZ1JQdUdxcWNOQUVmcXF5WWg4TU1vUU1BU0F0?=
 =?utf-8?B?a3FHR21neUdnKzhnYkpKTGc3QklYRTNtSzRWem1VMFMrNDNLSnArckRyeTN5?=
 =?utf-8?B?Ujk0UGkrUzh0MnFpTmZFaUVPRGN6NEltZmpPOFA3YzFzYUZCVUZ1Z2RVZElQ?=
 =?utf-8?B?STJXZURoRmZsNEYyQllIckxZdXVhdit5OG1yLzZ2b25YaCs1TzdhYkJUdWdr?=
 =?utf-8?B?WTl5NEdCZDBhUHhsclpaOTd1cVRLZjlSakJBWitNZGE1M1lWRHp5UXdtVG5P?=
 =?utf-8?B?YSsxc2Z0MjMvb2VFbmFEaU03OHpQUW5CMDhETTBhU3A0eGZGUVROd3JtMnRD?=
 =?utf-8?B?bzZhZTlFSldhYmNpMzhnQzI2MXVRZSsySEdYZCtCdjdhMXhPSFhnZjdaV2dm?=
 =?utf-8?B?b1RIaTlRUFAzNEI2SlNOL0w3ZlNiUTRYVzVmVGcxZnMwTVYyM2FLa3l4ays3?=
 =?utf-8?B?OHIxV1VTZzh5R2RqQ001MEFCM3V0WlB2Q2I1blJHWUMvcWNFTFpEUmpYQVcr?=
 =?utf-8?B?bnd3cFdaaEczYS80YURJSDl4L1hwVEhHd1dEWU9acnBiWjNsdjRsVTQvZDhy?=
 =?utf-8?B?UEMxYzRoeGtMdmxFMWU3aW1iUk85a1FwWkZvTENLdjNCYkZjT3pKREtmcS9P?=
 =?utf-8?B?MU03SUVIQzN3bWJObFRWYjRJbm4wYTRqbGpFTzBPcXBDcGhQNlpLb09Gd2NQ?=
 =?utf-8?B?WEFtZGxDM29KK0JuNE1iM1hvWFltU0wyUWZVWDYwYTRhWXNqTjNXaDJPWUoz?=
 =?utf-8?B?SXlraks5Wm5uSEs1Y1RDWDJzQzcvRXZ5OENZVUpVRCs5cDJPU3RTT1dZclVz?=
 =?utf-8?B?VklUa3NEdjNxY0pRVXYxOGlqcnpMSVgwOUZrcmRxejFrcjgxS24xZXNZOVVp?=
 =?utf-8?B?ZWw0Z2JIcXgxa1BVYUV4eDZPeldNd29rdHo3WFBib2htR001K2hSNmx4Qysw?=
 =?utf-8?B?a1VFN3AySkdQVkU0RGZKYjRRcUsyM2FkWnRnWUtFZ2xRSGNSK2NDS1FKRWxR?=
 =?utf-8?B?NmVkQ0dkSi84U3BkSWVxTVlBSUMzanB6TVoveXc5YWNDSjNvSThaZmE0bkVF?=
 =?utf-8?B?ODkxSG1HQ082aE1qR1haeGUzazdmVTRXaUFjZityNC9lTlFrTGE0MlJEQWpZ?=
 =?utf-8?B?K3MwLytpbXhEN3EzTFI3NDU4c0RqdDZ1eG5TWDFzbDRsMHZ6VWxibzBBNS9S?=
 =?utf-8?B?cVIyUzBMak1Yb01XOFUrdE9DRnpuUmVVOVNMQWIyUmV0dHdFVzdmV1VyaWZx?=
 =?utf-8?B?V2hybHhPbEM2RjJob2Y0dVFXeEprSllFSUoxczd1QTVkUnpUamRNRE1pazNz?=
 =?utf-8?B?T2hWZmxsMzc5RWxTNy8vRWk2Si9DOG9wSEhlbi8xT0tSZ2F1NFV3dnhGaVBj?=
 =?utf-8?B?UXgzV2R1aUZKVGZUYVZiYmhxNUFqZ25yRHdUQXpFbDhteS9GdXRpQVU3TUJt?=
 =?utf-8?B?Y1BRTytPWmltUGJyNUg1NlVCUmxiOXA5TG9Oa3N1OG1TeW9uQlI4SkFPN0Ey?=
 =?utf-8?B?WUJxWlJQano5NTZzOXRKQ1I5elVJb01XbytMMzB6YS8wTlZ5cG11enFwZSto?=
 =?utf-8?B?MXpoKzRKQUVxZnhqelJxazRKaXc5am04VlNvemc1bkp4Z1A5aC9yQWoweERN?=
 =?utf-8?B?TkJBbWJidXQrY3FaWkx6L2FETkZpL1E4WjhNbW10ZEQvZTFJbks2bG15aHJn?=
 =?utf-8?B?dWNRUFJXaG5UbEt1T1dFSHp6WkF3cks0SXh6aTFZdzRadnQ5WE9sNS8vMmpK?=
 =?utf-8?B?NWdiaFJEUmZ3TjRaMEswZjlyNGpXM29KTkVqajJ3OXFZL0J6K01VYU5CQXUz?=
 =?utf-8?B?OHVvM0hMV1Y1U1EzVXdHQlZNeXVpYTI3VWtEajA2NUV2a01nVEEyUVV0TDZk?=
 =?utf-8?B?cHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E2BF12F01D003C40BC7BEA7BC041C50F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4125cf5-2517-44fb-9275-08db254251ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 10:44:57.3150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NQQSaL8Axjph2H4tTQ0SoVwMJFbYLYqWhCaYinM+G7qKikN+yWJPRoQWJn5xOunIl2btp5Vb4XjSs8hb92A6Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6991
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU3VuLCAyMDIzLTAzLTEyIGF0IDEwOjU1IC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IMKgDQo+IC1zdGF0aWMgYm9vbCBrdm1faXNfdm1fdHlwZV9zdXBwb3J0ZWQo
dW5zaWduZWQgbG9uZyB0eXBlKQ0KPiArYm9vbCBfX2t2bV9pc192bV90eXBlX3N1cHBvcnRlZCh1
bnNpZ25lZCBsb25nIHR5cGUpDQo+IMKgew0KPiDCoAlyZXR1cm4gdHlwZSA9PSBLVk1fWDg2X0RF
RkFVTFRfVk0gfHwNCj4gwqAJwqDCoMKgwqDCoMKgICh0eXBlID09IEtWTV9YODZfUFJPVEVDVEVE
X1ZNICYmDQo+IMKgCcKgwqDCoMKgwqDCoMKgIElTX0VOQUJMRUQoQ09ORklHX0tWTV9QUk9URUNU
RURfVk0pICYmIHRkcF9lbmFibGVkKTsNCj4gwqB9DQo+ICtFWFBPUlRfU1lNQk9MX0dQTChfX2t2
bV9pc192bV90eXBlX3N1cHBvcnRlZCk7DQoNCldoZXJlIGlzIENPTkZJR19LVk1fUFJPVEVDVEVE
X1ZNIGludHJvZHVjZWQ/DQo=
