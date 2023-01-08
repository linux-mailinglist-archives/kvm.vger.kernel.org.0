Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD87661A6F
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 23:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbjAHWZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 17:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbjAHWZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 17:25:43 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8971A656F;
        Sun,  8 Jan 2023 14:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673216741; x=1704752741;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wO7Yo/uXi6d/CnGTdHtTkFS/aheDm0tBp8lQaWCyETc=;
  b=CGKBluAdpxBRBPMWZeUIYOkasIMljsQAiXxbLc04H9+4ojpjgEolF2is
   8cYsCc4ksv+vWV3wF2HAK11LifVe+QV8xAswWKa8mVkBtZMgEygXdDw9E
   ldXTNWaXtvRg4+tqgQG6i+jn+N1I4nFGkWB0s6zQTtRZEdZCy4LLBI+ol
   HEw0a6tL2+6ATAkKHnuOl9CCrh76AIRk309PJXHLBqrmJCl6kAO1Eeq5W
   A3B7m/WyCE7KlzgnAD0PF3GcjkqglC33JeTRlA4TZb8xDNqIim4E3/M4H
   242vV7I05Rj6sRYoAY0kynp27XZ59Jhq/ltOmu1acyLTilpi0gQYJtseF
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="322832572"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="322832572"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 14:25:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="764109753"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="764109753"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jan 2023 14:25:41 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 8 Jan 2023 14:25:40 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 8 Jan 2023 14:25:40 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 8 Jan 2023 14:25:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6Z7xE+c/VLq9tQ9qa3S06LY4ioN2X+TJe2auHE6CrHaKTVv5lNTJTQJC9tvhk2YcIDTlELxyh++VoJ0lRO8P5m2wiUAJVbmbfIJlC9hSmRAmDBCdYqiQs6WfWY719Ny2B3WBP3qNy2kodWesqcTXUFxTnMNut/dujaAAl1iLziEHGyZE9Kzhv78uT9fX9QR50cwqgKYB664fnbNRhyyWJ0rDO9rxUsnTZn+1Pp5Dvt/WvGJXUX4rteuXvu0PHWmjYhl3mnWTLkFO/zct36xpClzbL7WzJBx4d9eJY3ROBxi+ayVybZcSID/D+SI2cYt2hrrmFXoOChT479Q6LbHog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wO7Yo/uXi6d/CnGTdHtTkFS/aheDm0tBp8lQaWCyETc=;
 b=Zmejkhtnr+8xPkCunD2aF9jAlIbJWpH03PGHNHig1mRpGLKbEdfBfReKz3g8Jr9QpAuETYNg4L2sBpwZ11XaZEO+IWuXjjmOlg+JR2MlY15D0JZZm47jxVo0LQYWb/qpYRhlwdS5uN8MjKx01FEmozd3e+rWVv4+ys5xOIhQb8bS77WTIeOAKiyMp9ThNkmJSwhRb3vqxBJqcq9TV9Rrdm0iGGFNM6zaQkBAjinxXHnYhHakSl9ewR/KS5H4jlP/ePXx+CNw9q1OvxCCVjAwDGtt64jMNu1h4m0hr8CJaf0jEASiWXom6PytSbn7BSxpQ7lQg3TXAjGq7+HmFFuJKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN0PR11MB6183.namprd11.prod.outlook.com (2603:10b6:208:3c5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Sun, 8 Jan
 2023 22:25:29 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Sun, 8 Jan 2023
 22:25:29 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 02/16] x86/virt/tdx: Detect TDX during kernel boot
Thread-Topic: [PATCH v8 02/16] x86/virt/tdx: Detect TDX during kernel boot
Thread-Index: AQHZC5gGPy9Ecc5190yot3zZZ1H0f66RzCwAgAN83AA=
Date:   Sun, 8 Jan 2023 22:25:29 +0000
Message-ID: <c7becf27810a6a94e341be7c825923ba56280b55.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <75317b5b6f29e77b98455b0401bd903964f50814.1670566861.git.kai.huang@intel.com>
         <426c6483-d10a-27f4-abc1-55de1f3b1356@intel.com>
In-Reply-To: <426c6483-d10a-27f4-abc1-55de1f3b1356@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN0PR11MB6183:EE_
x-ms-office365-filtering-correlation-id: f6c7899b-58f1-4096-0484-08daf1c73f95
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e5WwFMA6lj4qw4bfGff+kralcQSbmYcziNOUsSSdiAKsIlw8k8M3zIKCeMBNzIL/T74b8HTF8dn0rJ9KB6zUNo6ASM+kPsfWJ1QtBQ5hCwp1f23I12l+F+8RNeykYWIkpGPTVoAWb+G9yuWVyQsbw0lk+fuF56cOqZGDDcrw8FPnZVT/zQarSxsY55+WDLJ4fULRB7UYeUP75lpO9OlJVuxlL0/GWSzwn7vbR8DvjTGCVf0kQ8+J6MyW25ux+Mwli+EZbAOvesi37aZrTGvTVn8spG/WgViPktNPVQdEyZjpJTK5RUvAq9W2fh6K0+QrCr+aQvBSQuKy+jGVjzJ4DM3jOEYAvlorDACDjox2kXg05JYlasKOxhZFuXMyjwNCAFVTWT5P1vRDbMSToXlpTap3OYX62651INjC1pmPZTreFr/9XDR4bHAjUaP9HEUFVBAQU4LvuhD7R50p8hYXa32AHsBsbuqj1oce2sAgI3XDvOo5rgfDDqfkWKKG89CguGL0mfKZo/eVwN///RWBOVG+aFPduYZQbMJaQN3Ozn3wjEe8lt30UF84Px8y2Ruznk8mEY7ezoPiLiNr4zUmxuvcEnuxgzZW/BF8J6/QskIJOSyTpBDcoikowT0J9RdG/E2I4GAG1v79bjB5aOecrKmrjmQtJ02wiSojl6q425GgIHoUvfL3GHK2oag9RDEFXRxCAeFcb+6BErcwrIet6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(366004)(376002)(346002)(451199015)(41300700001)(8936002)(5660300002)(36756003)(7416002)(2906002)(8676002)(76116006)(66476007)(91956017)(64756008)(66556008)(66446008)(66946007)(316002)(71200400001)(110136005)(54906003)(6486002)(6506007)(53546011)(478600001)(6512007)(26005)(4326008)(186003)(2616005)(86362001)(38100700002)(82960400001)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?azZJN1JQckxUQ3FyTVo5WXA5b3hwLzZ4UGpVRUZ0VW9DMHhNdXc4SnNFYUQ4?=
 =?utf-8?B?SFUxM0Y0S2Z2OXJ2TG40dDNWZ3ZaeXl4a2NSK2JRc09VN3dyMDBLTWdPOFFW?=
 =?utf-8?B?dFU1ZHJ4OWpVMXczTG0rbGt1dG1Rb0xaQVhwZG85WDNxTnJqWlQ0TDNNOTBy?=
 =?utf-8?B?R0FtUHFvRGxqT09NZWtOc1ZrUzJHMmhRcW9vb1RhUlpFeUw0d0d5ek1FYVdX?=
 =?utf-8?B?U2ZjMnlXRXBhaGZxZnVSTHlGVWxTeTNaNi9yYlVmcWJUbWVhNXhqVVYxc21Z?=
 =?utf-8?B?WHhlbVRqbEFFT3dPV0xYdk9iY3B6a3pQU0l4a2hNRXRNMGV1dFRzcVNXSUxD?=
 =?utf-8?B?MDlTOU1KcDhVY2d6ZE5qWDFrQXJKbFgvT1Iwc0RrV2QySmpaQVNNR1dsYmpq?=
 =?utf-8?B?MFJRNDQ5c05weWpueUdGSGJ0YUs4WnlXeVdLdmFja0R5eXVleFFwWVNjS3FK?=
 =?utf-8?B?eUxmVHVIZlZpQmhFMzhlN1JqenhNc25aZFUrMUFlVVNpYWFGUldWbHNrcGQ0?=
 =?utf-8?B?N1NsbzNsWjJBVVZIV0JaT1Z4NjVGMDdIODh5OUNPcGdsTWl2RVZqblBmMkts?=
 =?utf-8?B?SG5CcXIwdzBNZmI4aVBmTHVBNTkwajdtUnZIMUtlY2lLajUxNVdVSEp2ZzdF?=
 =?utf-8?B?YUl2ZVpjN09NQnBTRWh4dHowbk9XTFdjK05tZG9qVCtwVVFOVU5QZHRpcmtq?=
 =?utf-8?B?dW1hT2t2cHF2MS9aazFYcGloenpKdXhRN3h3bnpaQUs1TDNWK0NJTXVUclVH?=
 =?utf-8?B?SzFBOWxGUWM4WkgzRC9HUVNDYVhzMWxsZWRScEs2S3loNlVyWFBCNVdvS2VH?=
 =?utf-8?B?K09YSlVtY0ErSHQwSDZ6YXgwbnhOOWY5OTRFSUhEYnJGcUlIWlF6WVR1Qkhj?=
 =?utf-8?B?WmdCNkU5MFQwM0hpUlNrS0t2bXl3NnBBS1I1Z3BKSE5VaEI2Wnh6MUwxRVJ4?=
 =?utf-8?B?QjkwS1pUNjZWNzAwMVdlU0VOZENDWU41cytlYlpNRlE2SkJZSXpITk5GYzBo?=
 =?utf-8?B?eER2NCtvZTBnbmpKYys5VGVDQU9Ma3ZSMGUyZUlWZ3RaT2p3Nm9sU3ozdlRS?=
 =?utf-8?B?ZDBFQmk1d2kwcHFTd1o0alpQOEZTdmxONHdrWDg0MHVzc1hUYkhWZ0xxSTl1?=
 =?utf-8?B?VkJWbXFzMjdIMC9CU2NPK2l6VzFSYTZrQ0paNFljdEowd3g5MUt5U1NlOVBr?=
 =?utf-8?B?RVdGWkNLWU9GNzB6UlF5eEhjZE5RMUtyVDExSXg1WU92VmhWZml5Sko5M0pX?=
 =?utf-8?B?OHMxd2lmaDFIYzR3Z3AzLzhER1N2Y0xFVGF0RU5wcndqSFYwWmxwVWxHU1g2?=
 =?utf-8?B?UzgxOWRGMGQ2eElqVEdIWkJxb2F5L3E4bHVJQlRCMXY1MUxvaVIxUTVuVGRo?=
 =?utf-8?B?UE9NaXVuMkRTemZHWCs0eVJlYnpMOFY5ek1vLzlJQ2Q1YjBkRzllM2UreGxs?=
 =?utf-8?B?U1hTMS96T2tKNmI5Q3NDWWJmNjA5bXRGOVVRNUlyYjEwNlcyNStVVHhaSDVh?=
 =?utf-8?B?SkNoTzVncTd0WVJVeW9IOGdrTFhqanlBTWR0ajcwZkt2dWlLdlptaFhwNXJV?=
 =?utf-8?B?TnpGdTcxTG5NR1hxT2YwendKNXBCcW56cTBST1lBWDRQeTZRSGFHT1RBVitn?=
 =?utf-8?B?cndOVC9tZTh2RXFmTk01cnZmTktDOWlNZEIrRU9DZlVicnBnNzJEMWVIVWI2?=
 =?utf-8?B?elNGcXpLbmtrbFhyMXZMZzgzMGUwTHl3K0NhK0VXaU1KU0Z4eDZVZkJkVVli?=
 =?utf-8?B?Mm1yZ2FSU2xMai9YbHJkbkNTSmlrUmJScklFcnJMUmNyTzl5aEc4Z1FCVTNB?=
 =?utf-8?B?UDFUR00rMVZBU2c0R0FMU09CcHFHMkhDZFY0bERIaE4yRy8yKy9MWnd4Y1Bk?=
 =?utf-8?B?VHNLelQ4RmxOM3FHbFMvS0s5cXA0L0lDbkVpWmVHTVZHL1o4NEJ0SFk3aUR4?=
 =?utf-8?B?MnJjYUNFRTRPSEpaNXg0WWp5aWwwTDA0TzMzOUVVbVhRVldBTTZTbTAxTUFC?=
 =?utf-8?B?b2psOHYwNlhMWTF0R2h6MjRUK2d3aXpQL1FRZWY4dzcxYTJnU1B6SFpOdU0w?=
 =?utf-8?B?dUdiU0x4MzMyWkpNT3dvZFpyK1E4UUZJczAzNEt3K2lMNVo1bzRnOCtQNkZ4?=
 =?utf-8?Q?N5HSBz6xnqDGESJ+DkV6AqQF4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0CB69004BACFFA4FAA6BA27C379C0AC2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c7899b-58f1-4096-0484-08daf1c73f95
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2023 22:25:29.3705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VN7ycylZIO44dVuUga8x5PtgZLLg+wPGMm1OzhGgBomYt57y9SDEfmWwEjdy96mUwYv4PqWLcItOyrCb1ptcFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6183
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTAxLTA2IGF0IDA5OjA5IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTIvOC8yMiAyMjo1MiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ICsrKyBiL2FyY2gveDg2L3Zp
cnQvdm14L3RkeC90ZHguaA0KPiA+IEBAIC0wLDAgKzEsMTUgQEANCj4gPiArLyogU1BEWC1MaWNl
bnNlLUlkZW50aWZpZXI6IEdQTC0yLjAgKi8NCj4gPiArI2lmbmRlZiBfWDg2X1ZJUlRfVERYX0gN
Cj4gPiArI2RlZmluZSBfWDg2X1ZJUlRfVERYX0gNCj4gPiArDQo+ID4gKy8qDQo+ID4gKyAqIFRo
aXMgZmlsZSBjb250YWlucyBib3RoIG1hY3JvcyBhbmQgZGF0YSBzdHJ1Y3R1cmVzIGRlZmluZWQg
YnkgdGhlIFREWA0KPiA+ICsgKiBhcmNoaXRlY3R1cmUgYW5kIExpbnV4IGRlZmluZWQgc29mdHdh
cmUgZGF0YSBzdHJ1Y3R1cmVzIGFuZCBmdW5jdGlvbnMuDQo+ID4gKyAqIFRoZSB0d28gc2hvdWxk
IG5vdCBiZSBtaXhlZCB0b2dldGhlciBmb3IgYmV0dGVyIHJlYWRhYmlsaXR5LiAgVGhlDQo+ID4g
KyAqIGFyY2hpdGVjdHVyYWwgZGVmaW5pdGlvbnMgY29tZSBmaXJzdC4NCj4gPiArICovDQo+ID4g
Kw0KPiA+ICsvKiBNU1IgdG8gcmVwb3J0IEtleUlEIHBhcnRpdGlvbmluZyBiZXR3ZWVuIE1LVE1F
IGFuZCBURFggKi8NCj4gPiArI2RlZmluZSBNU1JfSUEzMl9NS1RNRV9LRVlJRF9QQVJUSVRJT05J
TkcJMHgwMDAwMDA4Nw0KPiANCj4gVGhlICpWQVNUKiBtYWpvcml0eSBvZiBNU1IgZGVmaW5pdGlv
bnMgYXJlIGluIG1zci1pbmRleC5oLg0KPiANCj4gV2h5IGlzIHRoaXMgb25lIGRpZmZlcmVudCBm
cm9tIHRoZSBub3JtPw0KDQpJIGhhZCBtZW1vcnkgdGhhdCBvbmx5IHdoZW4gb25lIE1TUiBpcyBz
aGFyZWQgYnkgbXVsdGlwbGUgc291cmNlIGZpbGVzIHRoZQ0KZGVmaW5pdGlvbiBvZiB0aGF0IE1T
UiBzaG91bGQgZ28gaW50byBtc3ItaW5kZXguaCwgYnV0IHRoaXMgaGFzIGNoYW5nZWQgc2luY2UN
CmNvbW1pdCA5N2ZhMjFmNjVjM2UgKCJ4ODYvcmVzY3RybDogTW92ZSBNU1IgZGVmaW5lcyBpbnRv
IG1zci1pbmRleC5oIikuDQoNCkknbGwgbW92ZSBpdCB0byBtc3ItaW5kZXguaA0K
