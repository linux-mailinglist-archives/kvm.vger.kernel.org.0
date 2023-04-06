Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1CA6D9872
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 15:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238678AbjDFNkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 09:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238249AbjDFNkg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 09:40:36 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF76A9
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 06:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680788435; x=1712324435;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8s9knQCPgOk3+GP6SVbCURza+lJ0HvzvFgQSK1fBERg=;
  b=fCtraHjsj5UcAQv9yAYvd3EpDTXpF4kj4M3TGtKmgTs6Vh9koqLiT2cs
   PVk7K9AtmhXKq/S+IdJ4R0tofs2a3qp+6yGV4cxIUidxBNzRGJ7RyxUCE
   86TDv9SC8HY2DQXmyCom6w7wQzctvHEczIsXZLYH7BH5RIGvEUFyWRo7m
   Qo/DpaHfvyOdr1vXKegxKJPQwTRJ+AWOTt+XyoSNWkE5lhiHQ9ji5uw1Q
   wV+RRa7SFlCpSAXZpDw8uvFU778cBxWZb+QDCFJBcuuz80sSRUnhefesL
   6K3VP4g3AzE6wuNMFG7Z39jsM6zAwX5KphmvEL+ZvBCBNige+9awSdkLF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="405542044"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="405542044"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 06:20:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="680666954"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="680666954"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 06 Apr 2023 06:20:53 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 06:20:52 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 6 Apr 2023 06:20:52 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 6 Apr 2023 06:20:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PEk6ymkQa1HE5Pgfh9OfXozKvkpIry9ohF0tK5AYJOcb5POqgFjQ6qVAf9NxYao75o6NSwM5dTsBP1Wh4W5jExt2Nfp2SS5NHyC076MKVxnEYUZSNXA3DBJVusjgHGN7zkX4OdS9axqd1uOJw0N0IzMa+RRFYzK9b4xEVjYY/iNI6mUsTB4lLYGoUBdw9SEwHyAdBA6Q0Fdtf//h0RVtcjG9UpHpw4V/9VJeDAPxSOr12g93bPzL1XST69Ryw6vXtZM7GYn2dr1Jqihapp7r9gnbuvfbWZAOS5yjpCsX/ObozVoy0Pok1satwws1fkshkuesXc9iCQepcd9ACyf9RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8s9knQCPgOk3+GP6SVbCURza+lJ0HvzvFgQSK1fBERg=;
 b=PfD1aPWM512jxpWaj0LDGUM36mOouVjw1aOefPCcTghABwHUPW+6WFyi8woklelAF0q0Hnnbh/PUwcyKS6WatI1XOYU15CPLqVyQ4PiVSiKnLz6HpxrAlFfbXVpMf8mBNjE70QLGDjEZNQH8IBwusSL3Kat5kwItgu40UM9yKkB7MpXy0oeRDRvOEgrrBYt4bedUxl/KOgi0nDIEXlO5TBSytFCzuK566RjdRheFgU1LUoGd4DlH/MYpx3TnOtJATR9Ztq7mlShaj7egLNYcpNpQ76Wgp+0ZwNmPJxhehV1gahnKFDLrMZhUsFcu2dGERqGM8aviRPNDl0Fpbxfdgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW6PR11MB8339.namprd11.prod.outlook.com (2603:10b6:303:24b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Thu, 6 Apr
 2023 13:20:44 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6254.033; Thu, 6 Apr 2023
 13:20:44 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "Guo, Xuelian" <xuelian.guo@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v7 4/5] KVM: x86: Untag address when LAM applicable
Thread-Topic: [PATCH v7 4/5] KVM: x86: Untag address when LAM applicable
Thread-Index: AQHZZva7ZC3iqXypLkSBwIVadqBqra8eRz2A
Date:   Thu, 6 Apr 2023 13:20:43 +0000
Message-ID: <9a19392e64f504e81a5adb32b8095815aeca82b8.camel@intel.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
         <20230404130923.27749-5-binbin.wu@linux.intel.com>
In-Reply-To: <20230404130923.27749-5-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW6PR11MB8339:EE_
x-ms-office365-filtering-correlation-id: 5249b3e3-b03d-41c5-e974-08db36a1b9f0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lR064s5lPDkJKUdvFw6e4b/4xjNuWhwBY22wNAoFXb0uydMjGP7YK8TC/86biF9WaTkQT9saeHMVllqOh8aimTnPsKuUW3Ze0VdsGHsDwJs5wI8LK4+K58PkMTYRMtTrqMo8oY8CnDgiZsT1unpHa/YigHRGHLdKdor4K2f/7DmA37IaZcOFGBc0qVAn38bIwWSsIxZyeVaojDDAy9VgQTz6quWepgTS/wtzVyJ/T7WvvHxDT9ij6w+bk3e2x0LADG4r+ffO4JY4pgpUfSJoWi9n1d1XL0q6O4HLJWQFI4MJ2jgm64ZOVXHWLhH7aqS2/gfhSWZQt9Ittr0l8FxNmJY8RS30VPFxxWH57LF93PT+qQc+N9G9R5BwwZUcDWNNUVR6vdTne0LPCGoHmJqadhLqv8EqKiyoMZUyUy9cqGgy1exzbN8B0S0frv0wegdtEWQ/0M+oM+pW4rAXJHdqw/h7+bxEPaFduiL/hL32QAsKobjLwSG53JK9Qz1SWkFN1659BkQDQrpAFeZMNBBssOPUoRKAQnkDBRkazcq/t0SmVYuw9BKOihbdrjy/G6YWv/IVJ2GD1NROmAQyKA+sa1BYBH/Okcj7S5NEo14AvubiFo8MG8DxR5qY9dcsoLV6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199021)(6486002)(110136005)(316002)(478600001)(64756008)(91956017)(66556008)(66946007)(66476007)(76116006)(66446008)(4326008)(54906003)(41300700001)(82960400001)(122000001)(8676002)(38100700002)(5660300002)(71200400001)(38070700005)(8936002)(2616005)(4744005)(2906002)(36756003)(86362001)(26005)(83380400001)(186003)(6512007)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2FNZWdzSWtFTE5ycVVyR1VteXQyRFF4RVlsTTVKMWhhZkdmRkNtaTVjS2U1?=
 =?utf-8?B?TVJ2NlJiMDBBUEQ3eGVuRDI5NE80T1Nwd2FyVEZ1S0Nnc3NoRmk4SDRvYXpq?=
 =?utf-8?B?K2ltUnFZclJWWTd6Y2Rza1Z4SGN4Z3NGRU85LzNudTVrcjhZWk9CajhLWFRn?=
 =?utf-8?B?MGFmQWc3NGpxWDNpUjE0VlJWdGQ5bEVJTzdROTl1a2FZeTMxaHJBU1ZZQjNV?=
 =?utf-8?B?eTc4ekZpYndST0J3cVExR3JmK0NDVmVXMExQM1czZy9ORnhIZzdhckZWQ2lG?=
 =?utf-8?B?MU5pVWhMcFdVeDVrbnN2a29TekhRWmJFdlFoN1R6aTJjWmNqb3ZFR2dIZzZH?=
 =?utf-8?B?ZXFmMS9zQUpvVDhkM3BUc1pTMSt2U1lWcm9ISEU2Vit2T2pjK1JTRktGQnRp?=
 =?utf-8?B?cUdrcndZRDh6WFZMSE1JOTRkRTc4MGtnWDVnWms1L1BSWS9haWhhYWY4Y1JK?=
 =?utf-8?B?cFhMUXJUZ0R0NGI4SmxlNGo3VkRmR2hGV0FkRmRRQXpOS0FUN3ZoUjdHL1dX?=
 =?utf-8?B?Nm1jQmUxMGg1L29wb2xCQ0pJUWEzU0l1SmtjQ1hqTzZWTlZUUStRY0FQNWMv?=
 =?utf-8?B?MXhiMENCT1RSYjJIUExYMHZxWmxtaEFyYTVPN1l3L2xrZHc2ekpKN0F4RmlU?=
 =?utf-8?B?VjF3eUc3cGQ2Z1JDTStTT0ZoU3BMSkgzVS9IbDNkTm83UW1GZm5FSW1xM0E2?=
 =?utf-8?B?V3JoWURtb2VSSlo2czdnUUpPc3ozaExWUmV5UGNsbWxIaEpQY3RpTzFJd3dh?=
 =?utf-8?B?d1hEKzRHUmdzRzd6WElHRXErdnBGR0NyYXJMbnVOeFVqU1dpZGQxam1JcFo5?=
 =?utf-8?B?eDA2aU84UXRGR2VPQkhURDBEcUtXcTI1QmIyWE1rSDJnTC91UEtYYUtrUXhm?=
 =?utf-8?B?K3IzZ3NWb3BzMEwyZm1ibGNuakhZNnpld09aeFRhYTJqMC9ZYUxYWGdmOGZU?=
 =?utf-8?B?K1R0R1UvbDhjaDhyRUNZb21iYVdGdUs0bHZQV3JzTFRyT2liZVFWR0tPY2Fy?=
 =?utf-8?B?NFd5QWdiTEN1VnR1Lys0bm5RZUFIMGtmZmQ4SVRxWUx2cFdmcE5veXVPeVVJ?=
 =?utf-8?B?dUMxa0UzSVhZLzk3bTN3bjNmaFF6bDVIUTRjSW5RdllodHhUVDRodnhRSFNL?=
 =?utf-8?B?Y1VLUkVSYlM0eEZqcjVwUVlUUUJ1NFZLVU1QZnhTYzNTVUsxejc2enh0dFAx?=
 =?utf-8?B?bXJWWnVwYXZXWkJCSEk3aTRYeElmdHRsY2xTa2hiWkdkY2s0UVdodDlySUtm?=
 =?utf-8?B?dE1VYmk1T0ZrR0tHNkhJdC9vMDFLWXBBU0l1R3UveTB1WERWZkNQd29zZzNw?=
 =?utf-8?B?YXNHelNWM1F6eGtyNytNMDNDbjlEc3AxV3NhOTJQajJheGJhTVY4U2IySTVH?=
 =?utf-8?B?RklpNndsUjNBbEl4K1U1L2lzaGFzaVVVM1FMUlFEM2xxKzFPb0htdUc3Mktm?=
 =?utf-8?B?MnIzUG9iNVZ0eUM2citzK09NclF6NU5ucStYWllqK2Q3czViVWRLSU9oTjZh?=
 =?utf-8?B?SW5YbEE1eFZxeU1ucld6TTRlWWdqT1o1cVZZQ3BGNDhPWXdma0hOL2JPaCt4?=
 =?utf-8?B?ei9JcVM2enRFVk9JdEFWcXZYRmZrdTFmM3dkM3dlOTZNNVBMWU1tZ1NHTEFT?=
 =?utf-8?B?TVJmNDNQUE51bHFsNlNsVXhyL05JakMrOXU5MjBHcndHMEJvOGhpbWtQWk50?=
 =?utf-8?B?S0UybWc5Z1paVUx5Y1ZNQU9xNU9Hdk5VdGRQSm84K1dyMXIrM0hpSkFDSjQz?=
 =?utf-8?B?cEV5dU9sM1cvZGU1a0MyekU2MWM4SDFRSFVVOW5GcFBmQWI4bjJWUTNxY1Yr?=
 =?utf-8?B?T0kxZTNJTnNFR1ljVkVWTGZnQjVNMk40dW1tM2JLaWpZdEFSS1lJeTJhM1NV?=
 =?utf-8?B?b2k2c0xjbFI4Y0d4RlZ2NkZiYjc0OVFwb1lGeTVNc3MrZ0pKMUVTQWMzalQ5?=
 =?utf-8?B?RG9wZ1ZuNjZhWVp3TUJIdW1NaGdCaEFsWFlnVmVib1dVbjBvUHFzcDRDR0p3?=
 =?utf-8?B?TThPS1pyWEM3eXR3UTZucFdVWUpXdVZ4UTlNYmlhRzRsWDBreXpDcUEyNjFO?=
 =?utf-8?B?Zzd4Y0xNTjhRLzZrUEFjYVpEY0VtZDA1bjZZeitFSGVaSDJpT1JieEROeFpM?=
 =?utf-8?B?NVZ0cVhzeTZ1QU9zSEZMQXBFb0x6bXM0UFl1SldmVXpLNGtPZVdEV2RvTlB1?=
 =?utf-8?B?cFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <240CCDD44EB0154EB055CEAF0AA337C1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5249b3e3-b03d-41c5-e974-08db36a1b9f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2023 13:20:44.0099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JYPbFzQlN07dHJXSbvuTL5SBkxbg9+JHIhPDu2XXtat3UKCFKHG84R2U8ePMlw3uELvjau3uBSvMeD5TXwImig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8339
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA0LTA0IGF0IDIxOjA5ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IMKg
CWNhc2UgVk1YX1ZQSURfRVhURU5UX0lORElWSURVQUxfQUREUjoNCj4gKwkJLyogaW52dnBpZCBp
cyBub3QgdmFsaWQgaW4gY29tcGF0aWJpbGl0eSBtb2RlICovDQo+ICsJCWlmIChpc19sb25nX21v
ZGUodmNwdSkpDQo+ICsJCQlvcGVyYW5kLmdsYSA9IHZteF91bnRhZ19hZGRyKHZjcHUsIG9wZXJh
bmQuZ2xhLCAwKTsNCg0KVGhpcyBjb21tZW50IGRvZXNuJ3QgbWFrZSBzZW5zZS4gIFRoZSBjb2Rl
IGRvZXMgbm90aGluZyB0byBkaXN0aW5ndWlzaCB0aGUNCmNvbXBhdGliaWxpdHkgbW9kZSBhbmQg
dGhlIDY0LWJpdCBtb2RlLg0KDQpOb3cgYWx0aG91Z2ggd2UgYXJlIGFsbCBjbGVhciB0aGF0IGhl
cmUgaXNfbG9uZ19tb2RlKCkgYmFzaWNhbGx5IGVxdWFscyB0bw0KaXNfNjRfYml0X21vZGUoKSwg
YnV0IEkgZG8gdGhpbmsgd2UgbmVlZCBhIGNvbW1lbnQgb3IgV0FSTigpIF9TT01FV0hFUkVfIHRv
DQppbmRpY2F0ZSB0aGF0IGNvbXBhdGliaWxpdHkgbW9kZSBpcyBub3QgcG9zc2libGUgd2hlbiBo
YW5kbGluZyBWTUVYSVQgZm9yIFZNWA0KaW5zdHJ1Y3Rpb25zIChleGNlcHQgVk1DQUxMKS4gIE5v
dCBldmVyeW9uZSB3aWxsIGJlIGFibGUgdG8gbm90aWNlIHRoaXMgc21hbGwNCnRoaW5nIGluIHRo
ZSBTRE0uDQoNClRoZW4geW91IGNhbiBqdXN0IGRlbGV0ZSB0aGlzIGNvbW1lbnQgaGVyZS4NCg0K
QWx0ZXJuYXRpdmVseSwgZm9yIGJldHRlciByZWFkYWJpbGl0eSBhY3R1YWxseSBJIGFtIHRoaW5r
aW5nIG1heWJlIHdlIHNob3VsZA0KanVzdCB1c2UgaXNfNjRfYml0X21vZGUoKSwgYmVjYXVzZSB0
aG9zZSBzZWdtZW50cyBhcmUgY2FjaGVkIGJ5IEtWTSBhbnl3YXkgc28gSQ0KZG9uJ3QgdGhpbmsg
dGhlcmUncyBtZWFzdXJhYmxlIHBlcmZvcm1hbmNlIGRpZmZlcmVuY2UgYmV0d2VlbiBpc19sb25n
X21vZGUoKSBhbmQNCmlzXzY0X2JpdF9tb2RlKCkuDQoNClNlYW4sIGFueSBjb21tZW50cz8NCg==
