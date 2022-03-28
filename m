Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240D74E95C5
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 13:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbiC1LzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 07:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241960AbiC1Lyp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 07:54:45 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A8D21E0A;
        Mon, 28 Mar 2022 04:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648468067; x=1680004067;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sdjQJv75sK1aGz4Vc27aHfqAEkvxMFvqr6XfGzcGD/Q=;
  b=azBZEeWNc8XB/Q1NeNNEpoSU1gW1Tn7W1U9q0ufKLwDmr1l1OfBPJb5x
   2TzIxgq0EeJ652+Jfxxv4nPNzpz5tsHCRn3ZlTnmCAQr4Q0SlaLSS4LJb
   6yCNUzPizgaobBf86ItBdXg4hpJ82du6G4Vvr6s9eYtJBOcjwfEniQWwV
   Bp+R/jZ0+oQULp3gCPjSKdRR7IChfMkkdYkkKLnWKUeoohD9o61YWut/6
   QHbtTjAIQX4fNTec3s7TggM/NjjYoY7WdT8zfcaTI1MeRuafmd1Af2OlK
   mMGoXsINpJktAKRu+p+EOfK+keYTBbhRiDAkwAJdh09KwAa3JM4d4HJaA
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="238910928"
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="238910928"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 04:47:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="553883561"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga007.fm.intel.com with ESMTP; 28 Mar 2022 04:47:47 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 28 Mar 2022 04:47:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 28 Mar 2022 04:47:46 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Mon, 28 Mar 2022 04:47:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYvP5Nx5Q1QUj3KEj9H+l197NdumNRGmJQLFcYObqzyIMA1c4gRdyUWU9RjPktH2UFbbPZiBGctHE7zom8CopHDDpMqi1+mpwVK+MjW1sCAaFtaGiZ8+kTXAPNPirHhKcoxwxjXL6u9plwfWnqfuJk0tyXnJWTj1hAMc0CZHq+qGHRt8qFV0jP/p9p9aEFaliHXddobBPokdbWFUyz+MZeUiikV0GcPXYdrex1F5avxeGc4nkoK+iVeh5m3ZoElMSPnmbZb8OTA1UuU6UIxDbd1ai8P+fa/A1M3jFqKr2AYB1n3QXBFImfi5xnDaBN9ZRM8LfLA6wiHO/yT+/MddtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sdjQJv75sK1aGz4Vc27aHfqAEkvxMFvqr6XfGzcGD/Q=;
 b=h61lu8TqVZpWfwWv4nkplcihkKelLOBr03yIqbZdf/A1x6d5kawMQJ2OfODvOWPDP4bWnrvZZPZuBWn3eiOgSZYxTCxziemcaOiGLnuIWB091ny2cbNZR7Ot4zKMJA+wVMM9H0zoZxH5cMKg2Qv/WapP9//z58TZ8bI+qaZ/QPPea6S6TfW9V0/2xnsKDReIHUFSv/CuhvcQGEwfBSLVoHMkEmPB6w7qSlhjH8ZIeuQv5WV1b4ffx5CdxE1kssOGx1T9HgWn3UCyi7QmsnfDrRKyc6HQrq3e77rEY9SSxe3yjgrdBUBwV1YAcXZItCfAcRvhgrOAENRcVIQPGtLNwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.22; Mon, 28 Mar
 2022 11:47:43 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0%4]) with mapi id 15.20.5102.023; Mon, 28 Mar 2022
 11:47:43 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gleixner, Thomas" <thomas.gleixner@intel.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: RE: [PATCH v2 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
Thread-Topic: [PATCH v2 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
Thread-Index: AQHYNsgzm2oe8d+tekOJ9ppfgUsWm6zMfiBAgAeiz4CAAGozsIAAEnGAgAAOOPA=
Date:   Mon, 28 Mar 2022 11:47:42 +0000
Message-ID: <BN9PR11MB52761E8DE55DC8872EC093758C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1647167475.git.kai.huang@intel.com>
         <279af00f90a93491d5ec86672506146153909e5c.1647167475.git.kai.huang@intel.com>
         <BL1PR11MB52713CA82D52248B0905C91D8C189@BL1PR11MB5271.namprd11.prod.outlook.com>
         <a68b378a40310c38f731f4bc7f0a9cc0d89efe92.camel@intel.com>
         <BN9PR11MB52760B743E208684A098B61C8C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <b4d97c46c52dbbecc6061f743b172015a73ec189.camel@intel.com>
In-Reply-To: <b4d97c46c52dbbecc6061f743b172015a73ec189.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e9cd2a6-8f4c-4bdb-df0d-08da10b0c4ea
x-ms-traffictypediagnostic: DM6PR11MB3292:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <DM6PR11MB329222956E1B27128557B8A78C1D9@DM6PR11MB3292.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6su9WnWjTs98erWaDQ/W9s+g94TGnyIFYLmtx+w2/15hhtdVRmzcW/KPJjgpMUlUMCAVJDi8ac7d9aC+K86T8iGhKZ9J/F22pw1FnzkmAqgzbhnWd0qyN1CUWzTmuSGjTfr0JgTmIId2Pu681alSHmNTxVgQzfEWKDeRh1LMShikFv5R4YZnz1E+3r8+HuoRGHyIsqHoaILfEl9DoU642qi6U8IHGHi1jG3Bb3U2Sfn3T6mKOBIlo5oFpkn04IzZCj0+0Lf5o+Ut1V9A2LNM8pdEWByw3PoaSQbkDvISkinidh0FkezqM4eKODAFlAV2dqSjVwLMiwYCrawVVhR/f2uE08R2BO1SLq+ALBVkYqjjs3XQfhGgcHkHLPRvMKy0ZIwlWF2GKLKonoKiJdRPwGfAB9XWwAgxYqRuHcCjHhO0/T7MXjI7cBZRkYA/Y2Wbp3Yd38gTGEysYRGhfZkrDPJYUHV8d05i3gP1GkO27atO0gsRUfXK2Xwfq0EELluj2v7lVo8kTIjLNTF7Nncp2yBCZhC5froloAZIu4200AUHqWHJYItD4Egmv03VY9ouSA1rsZxI7UimD7jVFxL7rLW/D6JzSp1zUJ2eXUOI6Dpj1mfKLUcc91LONgqCqHtvp4+iFmMVp3sinbOLWsEB/+KRZ5nnLuqULmn/XvqEOAvQNTxTi6PaprLeZ6O8QWFLfrT/HbpGHSZ78HZHUdceQA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(186003)(38070700005)(316002)(5660300002)(110136005)(26005)(122000001)(83380400001)(38100700002)(6636002)(508600001)(33656002)(66476007)(66446008)(8676002)(76116006)(71200400001)(66556008)(82960400001)(7696005)(2906002)(64756008)(55016003)(6506007)(8936002)(66946007)(52536014)(4326008)(86362001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NHhveitiN3pLTGNMNUhoRWlMRFYvU3hLRDZVMkhGK1VzbnBkTElDdjFkbHRN?=
 =?utf-8?B?OXQ4ejMzVlR4aFI3T1VDUytjejR1TE9OeVBybWxWNG9aMG1yRWlON2Z5c1B6?=
 =?utf-8?B?SEpiSTVFS3lTanZuc2Q1cGtRV2VFUUsySnZoTzRkQmplSjNKSHMyUTZzYUVi?=
 =?utf-8?B?WWNRd0lQM2NNQjJOWkdzRnFHSVhUTFJadTFXUmlXVXQxeEUxbHF1U1ZHR2Yr?=
 =?utf-8?B?UjROVkxSbzRCT0Y2azhXcmxORFhoR2R0OWJTbmQ0c3J6a2VaWWdWUkpYTkpm?=
 =?utf-8?B?Y0tHR3BWNGNCdUIxRnhlNDJBb3oxUUFWc1dXVkc5ZVpNUE9nbjd1WkJXUmM0?=
 =?utf-8?B?RnpsZXVmaW93L1FrYUNQemZZR3BFOGtsR3YrOFI0eDRYNThUUnNnV0tCYzAr?=
 =?utf-8?B?RDM0V1FrS0hVZjBCQ21jMmVBbzNlYis1UGdTY2l1NVFnSDFaS1U5YVNYa0Er?=
 =?utf-8?B?dGR2Z01KeVpkK24zblJOQ202SHpiOEhJQko1MlVmZnd6SEtwZlFLR3pta2VN?=
 =?utf-8?B?bXltRlM2YnQvNEJvd2JKc1RtUVVFZ2c2LzFwRmJVdUpCbHRNcFF5QW5nT240?=
 =?utf-8?B?ZEliYkhUZ3A1MDlmK3BiRk9QcG4xcDFXSUJvRTRIV2dlbldxemtWMWZ4UU1I?=
 =?utf-8?B?Q0haVW1NMGVOU0ZVWHhrY24xWmVPbk1lR0RQVm5sRXFvMExzeDhYak9VM1J4?=
 =?utf-8?B?VTlvbk9veEdDelIwdTZ0eWk3Qk9XWElUT2VLekxzREVTRTU2cmE0OTJmOWZv?=
 =?utf-8?B?M056dFNKaC9zekI5QlB0bjFqK1NkQlpiYy9qWlQ4amdzblBtVGFDOHZKVGwz?=
 =?utf-8?B?Q0N1SWZoeVpoQlZwNUpyQmZkaW1STWJZUWxtTGhuaGVDUHFnN0FNSjlmdEZa?=
 =?utf-8?B?RnRRcVNOUlRiaXJjZXJnWjZGUnZKd1hpZXhjWnQ4RGtKeEFwaGV0UVRyTTBU?=
 =?utf-8?B?Z21yaVVBRmU5RHBLbmNBcE0yQ3B3KzJ6djhXQU5oQU1oWnhPZWxlcHhCL0Ry?=
 =?utf-8?B?M2RPUU9qaEF2dnlVUzRFcWdEc0RZZzlTbVpFclI4bXJneElCcEN0WTl3VG5o?=
 =?utf-8?B?MFhvZWZ6bFFkcGtsbnNGSy84dnJ4QzBucTFlanl2aFFVdk8xVkxiTE5mcmpV?=
 =?utf-8?B?SUt6TWd3cytRNWREcVlVV3NOQnVzamxWa0g1cTFMZ0I0SVl2VEZxdytyVis2?=
 =?utf-8?B?NHQ5VzZFK056TlFLS0lueDNHc1pUckpDRmJyZ2FlbFN6dzlTRStiVEVvK1NH?=
 =?utf-8?B?eDRnejVtZUZoYWpGWWVmZFZ6STJCNUJCK2VYV2tobzdsNVMyZjVReUc2Vm1F?=
 =?utf-8?B?RG8raWg0N3daQ0t5ZXZSRFhZRmNMdVBuZmVnek9pZFlmS0poc3hxS09qOUpD?=
 =?utf-8?B?dkxZRDMrempBU3NJaXpuL2VYUEE2VVNKbGdzeFZEZ0V3cW9ySEFjRUZuWUV1?=
 =?utf-8?B?TVRWb2JsRFlrQ3Z5WjJsakU5YUhJL0UyY1o2Mk5PRnF6K05qRkxveEc4YUVw?=
 =?utf-8?B?RUZOUWlDVVFJbWxld0pRczlNeXZPZmJKOWYrZ2luYWw2RjFIdWQ1ZmR5bmNV?=
 =?utf-8?B?QU1PWi91NVBHeFRwTTBYWWVwaGpMbDltaHZjOURrbEN1ZkNuUlM2WFJQNkN6?=
 =?utf-8?B?RWxGZ0NsSXpSV2UwTkU4QTBKc3lIOXAzMDVnUDlRZWM1MGllV2VlVnZkYWZh?=
 =?utf-8?B?K0t3UzQxSFZ4VllXVCtXWjVOVGx4MGRTcUJpVUNEYjN6bFBtUzFkZVhQcVRW?=
 =?utf-8?B?YWYwaXBFK0k3cSszQ21ScXdZTCtUK3QzNXY2bUg2Y0ljQzhxd3VpSlFrL1Az?=
 =?utf-8?B?NGlvYTN4VndkUnd5a1VQdzFCaC9WTTRMWWZkOFF4SUpzSGJPcityRCttNy9D?=
 =?utf-8?B?MUU1dzJSL1lacEthb3ZWRHg4YzJ3VVp6cTFTT282Y3FXRzhESks2VllERFJL?=
 =?utf-8?B?T0tSSDltLzNicWF3R3Y3U2VpOC9mWUYrYjUwN0Zad1kzNGw3LzlwZ09UdFpL?=
 =?utf-8?B?ckFzK2JsMHlXRWgrN1docGJoaXZnMGljNHhZTmN3Z095SnVaTm00d3Q4WnRB?=
 =?utf-8?B?a0gwTitDM1NVZk1YZDcxRUU5RHVSY1BaTGEvM1o4Q1lqUEZ5VTZiMkh1S0NP?=
 =?utf-8?B?VllmSFpKZmdqcG5GNnB6eGhKSFRBdG96Z3duWUx5T2JNUjdaYUpFdHZIYyti?=
 =?utf-8?B?U3ROVkFMNlhLcXBNQjE5TE9SZUF3dVQzTEExMHhoMTRqaWhaTVZxbStKS3JW?=
 =?utf-8?B?dkRvUHR0dlhDekQvV1VTd29rVlBTUWhTKzBlUUcvZGFtR1pUMmg2alNGQU9J?=
 =?utf-8?B?bTkxdDRhU3hqS0l6WjdmUFU0VTkyaTBQY1ArOEsxQ2RtWlNSdnZkQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e9cd2a6-8f4c-4bdb-df0d-08da10b0c4ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2022 11:47:42.8941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: anY+2ZGijjkXfg42fDyCEJoW7b9csdUk9a5s+YRMg7PwQOl+omwhToHE38xEvX/Z+9LlIlQFzepSceX1X8lklA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3292
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBIdWFuZywgS2FpIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiBTZW50OiBNb25kYXks
IE1hcmNoIDI4LCAyMDIyIDU6MjQgUE0NCj4gPg0KPiA+IGNwdV9wcmVzZW50X21hc2sgZG9lcyBu
b3QgYWx3YXlzIHJlcHJlc2VudCBCSU9TLWVuYWJsZWQgQ1BVcyBkdWUNCj4gPiB0byB0aG9zZSBi
b290IG9wdGlvbnMuIFRoZW4gd2h5IGRvIHdlIGNhcmUgd2hldGhlciBDUFVzIGluIHRoaXMgbWFz
aw0KPiA+IChpZiBvbmx5IHJlcHJlc2VudGluZyBhIHN1YnNldCBvZiBCSU9TLWVuYWJsZWQgQ1BV
cykgYXJlIGF0IGxlYXN0IGJyb3VnaHQNCj4gPiB1cCBvbmNlPyBJdCB3aWxsIGZhaWwgYXQgVERI
LlNZUy5DT05GSUcgYW55d2F5Lg0KPiANCj4gQXMgSSBzYWlkLCB0aGlzIGlzIHVzZWQgdG8gbWFr
ZSBzdXJlIFNFQU1SUiBoYXMgYmVlbiBkZXRlY3RlZCBvbiBhbGwgY3B1cywgc28NCj4gdGhhdCBh
bnkgQklPUyBtaXNjb25maWd1cmF0aW9uIG9uIFNFQU1SUiBoYXMgYmVlbiBkZXRlY3RlZC4gIE90
aGVyd2lzZSwNCj4gc2VhbXJyX2VuYWJsZWQoKSBtYXkgbm90IGJlIHJlbGlhYmxlICh0aGVvcmV0
aWNhbGx5KS4NCg0KKmFsbCBjcHVzKiBpcyBxdWVzdGlvbmFibGUuIA0KDQpTYXkgQklPUyBlbmFi
bGVkIDggQ1BVczogWzAgLSA3XQ0KDQpjcHVfcHJlc2VudF9tYXAgY292ZXJzIFswIC0gNV0sIGR1
ZSB0byBucl9jcHVzPTYNCg0KWW91IGNvbXBhcmVkIGNwdXNfYm9vdGVkX29uY2VfbWFzayB0byBj
cHVfcHJlc2VudF9tYXNrIHNvIGlmIG1heGNwdXMNCmlzIHNldCB0byBhIG51bWJlciA8IG5yX2Nw
dXMgU0VBTVJSIGlzIGNvbnNpZGVyZWQgZGlzYWJsZWQgYmVjYXVzZSB5b3UNCmNhbm5vdCB2ZXJp
ZnkgQ1BVcyBiZXR3ZWVuIFttYXhfY3B1cywgbnJfY3B1cykuIElmIGZvbGxvd2luZyB0aGUgc2Ft
ZQ0KcmF0aW9uYWxlIHRoZW4geW91IGFsc28gbmVlZCBhIHByb3BlciB3YXkgdG8gZGV0ZWN0IHRo
ZSBjYXNlIHdoZXJlIG5yX2NwdXMNCjwgQklPUyBlbmFibGVkIG51bWJlciBpLmUuIHdoZW4geW91
IGNhbm5vdCB2ZXJpZnkgU0VBTVJSIG9uIENQVXMNCmJldHdlZW4gW25yX2NwdXMsIDddLiBvdGhl
cndpc2UgdGhpcyBjaGVjayBpcyBqdXN0IGluY29tcGxldGUuDQoNCkJ1dCB0aGUgZW50aXJlIGNo
ZWNrIGlzIGFjdHVhbGx5IHVubmVjZXNzYXJ5LiBZb3UganVzdCBuZWVkIHRvIHZlcmlmeSBTRUFN
UlINCmFuZCBkbyBURFggY3B1IGluaXQgb24gb25saW5lIENQVXMuIEFueSBnYXAgYmV0d2VlbiBv
bmxpbmUgb25lcyBhbmQgQklPUw0KZW5hYmxlZCBvbmVzIHdpbGwgYmUgY2F1Z2h0IGJ5IHRoZSBU
RFggbW9kdWxlIGF0IFRESC5TWVMuQ09ORklHIHBvaW50Lg0KDQo+IA0KPiBBbHRlcm5hdGl2ZWx5
LCBJIHRoaW5rIHdlIGNhbiBhbHNvIGFkZCBjaGVjayB0byBkaXNhYmxlIFREWCB3aGVuICdtYXhj
cHVzJw0KPiBoYXMNCj4gYmVlbiBzcGVjaWZpZWQsIGJ1dCBJIHRoaW5rIHRoZSBjdXJyZW50IHdh
eSBpcyBiZXR0ZXIuDQo+IA0KPiA+DQo+ID4gYnR3IHlvdXIgY29tbWVudCBzYWlkIHRoYXQgJ21h
eGNwdXMnIGlzIGJhc2ljYWxseSBhbiBpbnZhbGlkIG1vZGUNCj4gPiBkdWUgdG8gTUNFIGJyb2Fk
Y2FzZSBwcm9ibGVtLiBJIGRpZG4ndCBmaW5kIGFueSBjb2RlIHRvIGJsb2NrIGl0IHdoZW4NCj4g
PiBNQ0UgaXMgZW5hYmxlZCwNCj4gDQo+IFBsZWFzZSBzZWUgYmVsb3cgY29tbWVudCBpbiBjcHVf
c210X2FsbG93ZWQoKToNCj4gDQo+IHN0YXRpYyBpbmxpbmUgYm9vbCBjcHVfc210X2FsbG93ZWQo
dW5zaWduZWQgaW50IGNwdSkNCj4gew0KPiAJLi4uDQo+ICAgICAgICAgLyoNCj4gICAgICAgICAg
KiBPbiB4ODYgaXQncyByZXF1aXJlZCB0byBib290IGFsbCBsb2dpY2FsIENQVXMgYXQgbGVhc3Qg
b25jZSBzbw0KPiAgICAgICAgICAqIHRoYXQgdGhlIGluaXQgY29kZSBjYW4gZ2V0IGEgY2hhbmNl
IHRvIHNldCBDUjQuTUNFIG9uIGVhY2gNCj4gICAgICAgICAgKiBDUFUuIE90aGVyd2lzZSwgYSBi
cm9hZGNhc3RlZCBNQ0Ugb2JzZXJ2aW5nIENSNC5NQ0U9MGIgb24gYW55DQo+ICAgICAgICAgICog
Y29yZSB3aWxsIHNodXRkb3duIHRoZSBtYWNoaW5lLg0KPiAgICAgICAgICAqLw0KPiAJIHJldHVy
biAhY3B1bWFza190ZXN0X2NwdShjcHUsICZjcHVzX2Jvb3RlZF9vbmNlX21hc2spOw0KPiB9DQoN
Ckkgc2F3IHRoYXQgY29kZS4gTXkgcG9pbnQgaXMgbW9yZSBhYm91dCB5b3VyIHN0YXRlbWVudCB0
aGF0IG1heGNwdXMNCmlzIGFsbW9zdCBpbnZhbGlkIGR1ZSB0byBhYm92ZSBzaXR1YXRpb24gdGhl
biB3aHkgZGlkbid0IHdlIGRvIGFueXRoaW5nDQp0byBkb2N1bWVudCBzdWNoIHJlc3RyaWN0aW9u
IG9yIHRocm93IG91dCBhIHdhcm5pbmcgd2hlbiBpdCdzDQptaXNjb25maWd1cmVkLi4uDQoNCj4g
DQo+ID4gdGh1cyB3b25kZXIgdGhlIHJhdGlvbmFsZSBiZWhpbmQgYW5kIHdoZXRoZXIgdGhhdA0K
PiA+IHJhdGlvbmFsZSBjYW4gYmUgYnJvdWdodCB0byB0aGlzIHNlcmllcyAoaS5lLiBubyBjaGVj
ayBhZ2FpbnN0IHRob3NlDQo+ID4gY29uZmxpY3RpbmcgYm9vdCBvcHRpb25zIGFuZCBqdXN0IGxl
dCBTRUFNQ0FMTCBpdHNlbGYgdG8gZGV0ZWN0IGFuZCBmYWlsKS4NCj4gPg0KPiA+IEBUaG9tYXMs
IGFueSBndWlkYW5jZSBoZXJlPw0KPiA+DQo+ID4gVGhhbmtzDQo+ID4gS2V2aW4NCg0K
