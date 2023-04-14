Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9556E247B
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 15:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjDNNmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 09:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDNNmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 09:42:19 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC68E4;
        Fri, 14 Apr 2023 06:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681479738; x=1713015738;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2z1/Z0MRQ1KdWKnKHdp1AwhmaqWmPilSzXmnK2PTU+A=;
  b=iLfpoX3a3SAeZFXv206n8aH5JFPspgNF7Cap2AG8CtBlFCpnCK6vNTAO
   78NwJDcjPLM7qtYjtvyb/XtrjeerSX6ZIK2+vJ8ruH7KoTyyXGD248+Lh
   ooe+9MPQPCVOmQWmeqLl9rR6iEFzoo2NcCveIzx8g7MyqKGLMgg6c//zG
   JyMu6nTQoEnUV1o5F8FoibJ0/dOIM0O7gbZ5aq1XJCABCAvrsEC/ag8Y1
   4SCGshUpQdEMUmpsyrkFV4rzsfhl3MP2Kck+moWJvJXfu5MpM4gnYR8t7
   gJXocGb19c+rgvuc72Dlce+EcVImA4fLP6D06PxYtYVm0C3dSdbVJJ2Yn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="341962916"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="341962916"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 06:42:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="936012903"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="936012903"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 14 Apr 2023 06:42:15 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 06:42:15 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 14 Apr 2023 06:42:15 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 14 Apr 2023 06:42:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SLMHLG8fKNnL0LZ4nU6RtvWvhHimTbcK+aSw00LBb47EO0Of0fkzmmRbfXp06PcNQV6/LzsOo15xn1CaV+6sIKmz1C+aYC3KK80QcnLJ3VxUn1yqAuRSMBppSuwBDE1yXUVBo0Vh88Q7ebuyZM+haehDTHEFk4+em/Vs/7jkRLz6yGB7kM8c2j7sAC0phB1aWJ9z4CBeA/oO00yWOnvwa09CibEs5lmBn2P113lpe3NjKBMKB1Lf0oMeLVAr3tYWl1ELMAwPOYNMZf4nw+LwGCGYln80H77RgN6Y3CAzUb1cMKNLANK8OvIXNmZFfi+VPhe7IPPinVm+YO2/wu8YWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2z1/Z0MRQ1KdWKnKHdp1AwhmaqWmPilSzXmnK2PTU+A=;
 b=WXF+6+clvD64vIj2E5t/ck9qeurue4/p2Fu+lo4ghya24bnQiUtgHkHk+TpOuluI37e33JYYqLulnEo35Gj4SLBjiig2cYNi6X5zOhljqRSROYWnedwQdl57jTTJ1hHwkdsOF9jNCo7X2uWaQI0tHS998dC+Ys0rpQThZ37WQyG1ZxPrihOyhNDMtvKRSx156hyGp/Neq2zsJlKCLJHbnr315f7EJHxD4WHRnMBhgtiMcJ0NDwjNPK0MkXPsTT2AaxVc7MipCmJRABw82w/5h27DjXFg8kKt/8T/UvlRJ2+Lr8t3xXM5rQo8RPrYYlApSfJceCy60jo1G47d9UT28Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB6913.namprd11.prod.outlook.com (2603:10b6:930:5b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Fri, 14 Apr
 2023 13:42:11 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5%3]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 13:42:11 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] KVM: x86: SGX vs. XCR0 cleanups
Thread-Topic: [PATCH 0/3] KVM: x86: SGX vs. XCR0 cleanups
Thread-Index: AQHZZ1neAPY41R6lzkG8Mkf04T1Dpq8cd6WAgAETnwCAAIN/gIAJkScAgAA2l4CAAJZTgIABeHsAgAD5zQA=
Date:   Fri, 14 Apr 2023 13:42:11 +0000
Message-ID: <23aa3eb68362648f1fab41954728a47dfadd9c61.camel@intel.com>
References: <20230405005911.423699-1-seanjc@google.com>
         <d0af618169ebc17722e7019ca620ec22ee0b49c3.camel@intel.com>
         <ZC4qF90l77m3X1Ir@google.com>
         <20230406130119.000011fe.zhi.wang.linux@gmail.com>
         <e1e7a37a29c2c7ad22cd14181f24b06088eca451.camel@intel.com>
         <ZDbMuZKhAUbrkrc7@google.com>
         <ae28ce9b0c78a926c38a8c8b9694aa34b140b467.camel@intel.com>
         <ZDiGpCkXOcCm074O@google.com>
In-Reply-To: <ZDiGpCkXOcCm074O@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB6913:EE_
x-ms-office365-filtering-correlation-id: c1035f10-9f0f-4f2c-1bd3-08db3cee0c86
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ofowSbitDJNrigtoETczlHlWgIG4m4MetDbCl9GR/0AQE/xFUMzKX7TJZXs5IIiHZZJO0p7vefiZWhadefnJQAh+VulSA0zcf6A0Zt4L/3QBse/Co4lnJc/i2SBhxbt7huXyi8SEfuiBF4FVd+/giUJVMLUhzh/NMsd5OKrSWzWgPNxjdPsNH6XOGAq0xAd5k35aTlMaDn8qHE9/qmgoFvHYvc/V7a+1Oye2i7GjnU2Cwbw1p/TMcjayZ9KlR9w+EcpiKqcUi9n5fXoU8rcXZQ1y0CqQQOzJ1ecTq5z2wkbtI4XJDr5NcIDRNgEhxlMZVKOISL1eV5v8wf/8GcANuurw1rnTFAKu6pHJzuetn6SGUsP29TvjCwfwEmkIWo/xmsxGjLcrYrk1SeWEJk5u1uVZe99j6ebcv99TxotA65GW7vEa2QDqDBXsOfcoYw5iVkGvCBR5r+Fz2p50yogGnz9wBspL/0/kUtehgVnrBQd+s6pbJMCNM91YTZdK5UOmcFD+d9e1Mpim5ObqrGFt9oq7+QklZhreWLZACR0pNRjE1WnAK0+hHpmGIUgI/6K7iLlJ/D3/oSF1KL6sPMyKaVFzs6Pq7B9iqUe63DkHtzY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(366004)(346002)(136003)(451199021)(6916009)(316002)(26005)(38070700005)(122000001)(38100700002)(6512007)(82960400001)(6506007)(71200400001)(966005)(83380400001)(6486002)(2616005)(186003)(8936002)(5660300002)(36756003)(2906002)(8676002)(41300700001)(86362001)(91956017)(478600001)(54906003)(66556008)(4326008)(66946007)(66476007)(64756008)(66446008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UEpqYUdRRHAzMEdMTVVyWUl1WWptOXBJMC9xcFk1MStzMkt1c25NY3lDTDd3?=
 =?utf-8?B?QURFODBnbmh3UjVBREYzYWdnZ0p1M0N2ZXlNM3FQWDJwdC9sc3lvN3FPZUc3?=
 =?utf-8?B?SjQzWGpXeExWN2o0TTNIamZBUDBWSGJpUEVqZVEvM1ZLYkg2ZkxuWk1wMWtW?=
 =?utf-8?B?UVB1UUp2Zm1UQ3plMmNJcVlSMUJiV05Jb1BLaWp5cTNhTzB6NUp5QUgxVDFV?=
 =?utf-8?B?dGZyQ29kUTBiTDlzdUxvZENXMEQ4Yml0MS9CcERpMVZFM1N4d3dHUXkxYkxx?=
 =?utf-8?B?amFSK2ZpdnhETzVod1h0eVlkTXNCVTRjRWxlWjh4U1hORnNSeGQ0emM3Z3l0?=
 =?utf-8?B?Yjl1N0svL2VWQTlmekZrWEhkS1NxaDlKZFhDMm9HQTRRc1d4VkpsYWU1clNt?=
 =?utf-8?B?dFZaeHN4T21iL1BDWU1DT1lTeG9vRGY5eXRBYmwxanZYUXhoUHpDUkI5dGFa?=
 =?utf-8?B?akp4d0EyRlJTb2xFZk5zZVB1ZW9hVDdDd1NzaXkvQzZoMFp3MWgrYUd0RWhR?=
 =?utf-8?B?d2JhUzlNODVQbm5yS2EvRXB1QUZOeFduZmJUSUVyUzFkbWJGZUJnS0EwaHRZ?=
 =?utf-8?B?Y0xKTFJBSzE2YWx4TnFMNmpTRjYrVGMrZERReDVjdjVISU5yUk1wVXJrNFV3?=
 =?utf-8?B?NEVyR3VwOFhpYmY4SkZiSmNkdzQyREQvSlhDc3BaWjJyT25iMG9NajYzakdM?=
 =?utf-8?B?b3hobmhnYTBCQThYZStsckNWNkY3eEcwTjgveDNEKzVJc0FNdW92WHo0L0NU?=
 =?utf-8?B?MldoTm9nQkxzeGxQNFhwS3l2UVFSYWd6b01xQlJIckk0bVhUdlNQM2dZNkxl?=
 =?utf-8?B?NDA3SlljWm5hNzhqM3MyYTFQbk1aUXN0YjRPMFdsNUZmT2d5YVZNcTI4SUQ5?=
 =?utf-8?B?VG1nWjlxL2pjdGg0Y2pIK0VMU1Yvb1BneFlPSk1vTUtLa0tDbjI5SHJ4QVI2?=
 =?utf-8?B?RDM3TnJrMDZxcEc1K1QvczNSZnZmb2lXY2RFZGl2b0QySHJRNDFWM2xiQmli?=
 =?utf-8?B?cnc3UERFVkZzZ3FyeGlDei9RVXRYb0ExYm53TmFraU5zMTBBK28rTVZtaG8w?=
 =?utf-8?B?OWpnamlZUmp3QkxEMXNkMm8yR0VTQmFqZjgxQmU0NW1WZGJVTlZkVDY5dDRj?=
 =?utf-8?B?aVkxNWorYlVINitnZFk0VmVHd0VJTm8rcDRoaUxaYldQUGdNL3M2TXR3RG8x?=
 =?utf-8?B?cTNOVm5ZUXJ4WVJDLzNKNitadDFHOWZZS2ZoTHIvOHdDN01oWmovQ2JFNDRs?=
 =?utf-8?B?RWk3MWhrSGxVWFRtdUM0VDZPL2xURnIzcUlDRVZhRDJiYTN3NEZvcGp3aVp2?=
 =?utf-8?B?RGh4UFgwU2Fra1VTYVBHQUNyUER5c3VNcmJVWVZZb2xiNkxBWlFmQmhQRUhX?=
 =?utf-8?B?WjJ0Y2xudW9TaWs0WmRDU3FtSGtrdDRSMHNNYkVyak9HU0cvR2g5dVBuTmEy?=
 =?utf-8?B?TjFBaWFKRDUwOEpGQ0ZQNmpoWEY3dzg2V20xK1BWUWVGcFJHR1BrRXBpcncw?=
 =?utf-8?B?L1VSZjVnZm1TWGtiTm94c0FzWkdkWE92QlUvRnBBRytKYitKZytKeDZoVi9l?=
 =?utf-8?B?NWV5NFZsTWdNTFZQMDNjTXNZR014VXR4WUJ4R0JtTFNnc29LNzBSMGt2K1ds?=
 =?utf-8?B?SEpEdUg2dGFyOHM5MU4rQm1QQmJFTncyaExhaUFiZ0M1MENZcHZaOUxiQlE2?=
 =?utf-8?B?MzdxdGNvVDh6NEF1cSsyYkkvVE9wRklYVWJaOHc3Ujd6TVdtdVRoU1RKNFpY?=
 =?utf-8?B?RXZBcm1OK2pDd3lFM3pZako2Sjc2R1lPL1NpcDBhYXY3NlIzNXgzenFPN2JD?=
 =?utf-8?B?dUZpNTUxNFVGL0FWZXJCaHJ1Wi9MM1RyeFNvRGRZTWVMMlF1NmV6eWQwTXJV?=
 =?utf-8?B?dnUvUytTV05BcGQvR09nc1RCcTJmU2Z2bW1BdWg0QjlaMFdwVmhLTENPOHow?=
 =?utf-8?B?ZHJSejlxenR0NmNNL0NFS3NnL0VHYkpUaDhkNkZ3RjFVeC9tU1h0c3hXOGFy?=
 =?utf-8?B?WHZIcnl1aHRkUlNHekNadHBNWWtXVlNXMGRkN2g1YnlLZ0EzZ0Q5YVlTTFN1?=
 =?utf-8?B?dWI0bXNXSnpndmt2VUdBZlBjemVhUEhhZzNvTkhZV0w3am84OGNxYVZnZUhE?=
 =?utf-8?Q?K69Bb/1x8VaJsuT1b9yogEq5W?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E728FE13E982334DA877B9F7294201F1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1035f10-9f0f-4f2c-1bd3-08db3cee0c86
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 13:42:11.2504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fGMibIHxRM3xfmcguPTchAWxVbA0YBFJToCjENoilZ0VCbJ3MCkrnC87WrLWMVnfXmq14UjV98L3hNPnWvNOKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6913
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

T24gVGh1LCAyMDIzLTA0LTEzIGF0IDE1OjQ4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEFwciAxMywgMjAyMywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFdl
ZCwgMjAyMy0wNC0xMiBhdCAwODoyMiAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IEtWTSdzIHVBUEkgZm9yIGluaXRpYXRpbmcgVERILk1ORy5JTklUIGNvdWxkIG9idmlv
dXNseSBmaWx0ZXIgb3V0DQo+ID4gPiB1bnN1cHBvcnRlZCBsZWFmcywgYnV0IGRvaW5nIHNvIHdv
dWxkIGxlYWQgdG8gcG90ZW50aWFsIEFCSSBicmVha3MsIGUuZy4gaWYgYSBsZWFmDQo+ID4gPiB0
aGF0IEtWTSBmaWx0ZXJzIG91dCBiZWNvbWVzIGtub3duIHRvIHRoZSBURFggTW9kdWxlLCB0aGVu
IHVwZ3JhZGluZyB0aGUgVERYIE1vZHVsZQ0KPiA+ID4gY291bGQgcmVzdWx0IGluIHByZXZpb3Vz
bHkgYWxsb3dlZCBpbnB1dCBiZWNvbWluZyBpbnZhbGlkLg0KPiA+IA0KPiA+IEhvdyBhYm91dCBv
bmx5IGZpbHRlcmluZyBvdXQgUFYgcmVsYXRlZCBDUFVJRHMgd2hlbiBhcHBseWluZyBDUFVJRHMg
dG8NCj4gPiBUREguTU5HLklOSVQ/ICBJIHRoaW5rIHdlIGNhbiBhc3N1bWUgdGhleSBhcmUgbm90
IGdvbm5hIGJlIGtub3duIHRvIFREWCBtb2R1bGUNCj4gPiBhbnl3YXkuDQo+IA0KPiBOb3BlLCBu
b3QgZ29pbmcgZG93biB0aGF0IHJvYWQuICBGb29sIG1lIG9uY2VbKl0sIHNoYW1lIG9uIHlvdS4g
IEZvb2wgbWUgdHdpY2UsDQo+IHNoYW1lIG9uIG1lIDotKQ0KDQpBaCBPSyA6KQ0KDQo+IA0KPiBP
YmplY3Rpb25zIHRvIGhhcmR3YXJlIHZlbmRvcnMgZGVmaW5pbmcgUFYgaW50ZXJmYWNlcyBhc2lk
ZSwgdGhlcmUgZXhpc3QgbGVhZnMNCj4gdGhhdCBhcmUgbmVpdGhlciBQViByZWxhdGVkIG5vciBr
bm93biB0byB0aGUgVERYIG1vZHVsZSwgZS5nLiBDZW50YXVyIGxlYWZzLiAgSQ0KPiB0aGluayBp
dCdzIGV4dHJlbWVseSB1bmxpa2VseSAodW5kZXJzdGF0ZW1lbnQpIHRoYXQgYW55b25lIHdpbGwg
d2FudCB0byBleHBvc2UNCj4gQ2VudGF1ciBsZWFmcyB0byBhIFREWCBndWVzdCwgYnV0IGFnYWlu
IEkgd2FudCB0byBzYXkgb3V0IG9mIHRoZSBidXNpbmVzcyBvZg0KPiB0ZWxsaW5nIHVzZXJzcGFj
ZSB3aGF0IGlzIGFuZCBpc24ndCBzYW5lIENQVUlEIG1vZGVscy4NCg0KUmlnaHQuICBUaGVyZSBt
aWdodCBiZSB1c2UgY2FzZSB0aGF0IFREWCBndWVzdCB3YW50cyB0byB1c2Ugc29tZSBDUFVJRCB3
aGljaA0KaXNuJ3QgaGFuZGxlZCBieSB0aGUgVERYIG1vZHVsZSBidXQgcHVyZWx5IGJ5IEtWTS4g
IFdlIGRvbid0IHdhbnQgdG8gbGltaXQgdGhlDQpwb3NzaWJpbGl0eS4gIFRvdGFsbHkgYWdyZWUu
DQoNCj4gDQo+IFsqXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMjEyMTAxNjAwNDYu
MjYwODc2Mi02LWNoZW4uemhhbmdAaW50ZWwuY29tDQo+IA0KPiA+ID4gRXZlbiBpZiB0aGF0IHdl
cmVuJ3QgdGhlIGNhc2UsIGlnbm9yaW5nIEtWTV9TRVRfQ1BVSUR7Mn0gd291bGQgYmUgYSBiYWQg
b3B0aW9uDQo+ID4gPiBiZWN1YXNlIGl0IGRvZXNuJ3QgYWxsb3cgS1ZNIHRvIG9wZW4gYmVoYXZp
b3IgaW4gdGhlIGZ1dHVyZSwgaS5lLiBpZ25vcmluZyB0aGUNCj4gPiA+IGxlYWYgd291bGQgZWZm
ZWN0aXZlbHkgbWFrZSBfZXZlcnl0aGluZ18gdmFsaWQgaW5wdXQuICBJZiBLVk0gd2VyZSB0byBy
ZWx5IHNvbGVseQ0KPiA+ID4gb24gVERILk1ORy5JTklULCB0aGVuIEtWTSB3b3VsZCB3YW50IHRv
IGNvbXBsZXRlbHkgZGlzYWxsb3cgS1ZNX1NFVF9DUFVJRHsyfS4NCj4gPiANCj4gPiBSaWdodC4g
IERpc2FsbG93aW5nIFNFVF9DUFVJRHsyfSBwcm9iYWJseSBpcyBiZXR0ZXIsIGFzIGl0IGdpdmVz
IHVzZXJzcGFjZSBhDQo+ID4gbW9yZSBjb25jcmV0ZSByZXN1bHQuICANCj4gPiANCj4gPiA+IA0K
PiA+ID4gQmFjayB0byBaaGkncyBxdWVzdGlvbiwgdGhlIGJlc3QgdGhpbmcgdG8gZG8gZm9yIFRE
WCBhbmQgU05QIGlzIGxpa2VseSB0byByZXF1aXJlDQo+ID4gPiB0aGF0IG92ZXJsYXAgYmV0d2Vl
biBLVk1fU0VUX0NQVUlEezJ9IGFuZCB0aGUgInRydXN0ZWQiIENQVUlEIGJlIGNvbnNpc3RlbnQu
ICBUaGUNCj4gPiA+IGtleSBkaWZmZXJlbmNlIGlzIHRoYXQgS1ZNIHdvdWxkIGJlIGVuZm9yY2lu
ZyBjb25zaXN0ZW5jeSwgbm90IHNhbml0eS4gIEkuZS4gS1ZNDQo+ID4gPiBpc24ndCBtYWtpbmcg
YXJiaXRyYXJ5IGRlY2lzaW9ucyBvbiB3aGF0IGlzL2lzbid0IHNhbmUsIEtWTSBpcyBzaW1wbHkg
cmVxdWlyaW5nDQo+ID4gPiB0aGF0IHVzZXJzcGFjZSBwcm92aWRlIGEgQ1BVSUQgbW9kZWwgdGhh
dCdzIGNvbnNpc3RlbnQgd2l0aCB3aGF0IHVzZXJzcGFjZSBwcm92aWRlZA0KPiA+ID4gZWFybGll
ci4NCj4gPiANCj4gPiBTbyBJSVVDLCB5b3UgcHJlZmVyIHRvIHZlcmlmeWluZyB0aGUgQ1BVSURz
IGluIFNFVF9DUFVJRHsyfSBhcmUgYSBzdXBlciBzZXQgb2YNCj4gPiB0aGUgQ1BVSURzIHByb3Zp
ZGVkIGluIFRESC5NTkcuSU5JVD8gIEFuZCBLVk0gbWFudWFsbHkgdmVyaWZpZXMgYWxsIENQVUlE
cyBmb3INCj4gPiBhbGwgdmNwdXMgYXJlIGNvbnNpc3RlbnQgKHRoZSBzYW1lKSBpbiBTRVRfQ1BV
SUR7Mn0/DQo+IA0KPiBZZXMsIGV4Y2VwdCBLVk0gZG9lc24ndCBuZWVkIHRvIHZlcmlmeSB2Q1BV
cyBhcmUgY29uc2lzdGVudCB3aXRoIHJlc3BlY3QgdG8gZWFjaA0KPiBvdGhlciwganVzdCB0aGF0
IGVhY2ggdkNQVSBpcyBjb25zaXN0ZW50IHdpdGggcmVzcGVjdCB0byB3aGF0IHdhcyByZXBvcnRl
ZCB0byB0aGUNCj4gVERYIE1vZHVsZS4NCg0KT0suICBGaW5lIHRvIG1lLg0KDQo+IA0KPiA+IExv
b2tzIHRoaXMgaXMgb3Zlci1jb21wbGljYXRlZCwgX2lmXyB0aGUgIm9ubHkgZmlsdGVyaW5nIG91
dCBQViByZWxhdGVkIENQVUlEcw0KPiA+IHdoZW4gYXBwbHlpbmcgQ1BVSURzIHRvIFRESC5NTkcu
SU5JVCIgYXBwcm9hY2ggd29ya3MuIA0KPiANCj4gSXQncyBub3QgY29tcGxpY2F0ZWQgYXQgYWxs
LiAgV2FsayB0aHJvdWdoIHRoZSBsZWFmcyBkZWZpbmVkIGR1cmluZyBUREguTU5HLklOSVQsDQo+
IHJlamVjdCBLVk1fU0VUX0NQVUlEIGlmIGEgbGVhZiBpc24ndCBwcmVzZW50IG9yIGRvZXNuJ3Qg
bWF0Y2ggZXhhY3RseS4gIE9yIGhhcw0KPiB0aGUgVERYIHNwZWMgY2hhbmdlZCBhbmQgaXQncyBu
byBsb25nZXIgdGhhdCBzaW1wbGU/DQoNCk5vIHRoZSBtb2R1bGUgaGFzbid0IGJlZW4gY2hhbmdl
ZCwgYW5kIHllcyBpdCBzaG91bGQgYmUgYXMgc2ltcGxlIGFzIHlvdSBzYWlkLiANCkkganVzdCBo
YWQgc29tZSBmaXJzdCBpbXByZXNzaW9uIHRoYXQgaGFuZGxpbmcgQ1BVSUQgaW4gb25lIElPQ1RM
IChUREguTU5HLklOSVQpDQpzaG91bGQgYmUgc2ltcGxlciB0aGFuIGhhbmRsaW5nIENQVUlEIGlu
IHR3byBJT0NUTHMsIGJ1dCBJIGd1ZXNzIHRoaXMgbWlnaHQgbm90DQpiZSB0cnVlIDopDQoNCkFu
eXdheSBJIGFncmVlIHdpdGggeW91ciBzdWdnZXN0aW9uLiAgVGhhbmtzLg0KDQo=
