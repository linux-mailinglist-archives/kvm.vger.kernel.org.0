Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541C96B8784
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 02:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjCNBT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 21:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjCNBT6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 21:19:58 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EA51C7DB;
        Mon, 13 Mar 2023 18:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678756796; x=1710292796;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+ABiSX2qeJWhp33ce3cs+BwuX3FpKOrlJixhdvS5468=;
  b=VI6y7hnfgcfXI94Sn5bekb6stwYihxE8dbj7GOta0XB6tlU3lRsnkU9d
   DKzr7CM53g/9hGd6FbZR3BrzNPc2ClDfwi8PWXRiDuSH0bp7bfKWjsp5D
   JqowWXmtQLFgdfh7XrRBNnp94raqEyTKVrjkPRUQR1rPRkOF65/fJuMkm
   dZi1MjhDkUa9rClDg+byfkKdmIDfn1BqKlPTnCIikHlGR4w3OBfls5wKc
   2fwJemIkIMqVOegn7yzuSV4WqigU3IDpr2sDus+YBsUSTvDUy2sNjgq4E
   PbXzs31FWwMJD5J6CAkyIYOIzv37Hf66ltyWT3Q7viQysmtCDhi1CyEGO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="321152339"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="321152339"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 18:19:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="743105789"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="743105789"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 13 Mar 2023 18:19:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 18:19:54 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 18:19:54 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 18:19:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJ4NcwuPXyOySjOdpYs/nXziQzaw9od5f8dD30FHSqrsTqb6SAffD7m4z5kDD7hy1UjclxElaFzMl77rYXWGBR+7U5YKzVtqEUySrjvrM2YtdSIfZQGzWDVdfBZ6lFZheolaApSNj4/bU4L2RQfAmkxn6CsbD9FuoQcVtZ0mROsADu4gUKFLwCLcUtJqqTg8eNHQ9rmHq3Q2zAPuSXvlltawGAiMyIUY7KH6D8dtQONShZuPJ6lxTWAzDlyPiBcFPy12mR+/G/HFqBBYuwhzdXuAEBr6Bi9vTb+z7/6mSZCfwrteNHNIBH/k6+DpnStkNUYvkGkbrgBb1apvh3rb9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ABiSX2qeJWhp33ce3cs+BwuX3FpKOrlJixhdvS5468=;
 b=U1itAlr39qen7sTrWUZMzfN1EzzbLtVH1+E3tIlLyuv9mqBcKQq244DY+pfMrJMcxweKT1CzgnmUTPEDaE0eYlYd9fING9Rk4mE7TRrnWw2Ip7rkzTNtnu/VzmmUC+x4zDytU/j1dGGhLigBo7odUQnJHyV0fgQhOElns8+02wBeCZUyo46euaa73Mjp/eH7FE7gekrATOKEFU5J8T+BEQ0nggaQtOGCipFKEREFgMKyBNEqV+gLjbipXlhYWFGFRxR7BjmRJwchUrYzxcfed/z3GnrAYNdaUMru8P4qcAgclkmWBaoKaQiTtjQ19IDMKiZ1/l6TMlgtKb2ViplGAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB7698.namprd11.prod.outlook.com (2603:10b6:806:332::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 01:19:51 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 01:19:51 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "Gao, Chao" <chao.gao@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/18] x86/reboot: Expose VMCS crash hooks if and only
 if KVM_INTEL is enabled
Thread-Topic: [PATCH v2 02/18] x86/reboot: Expose VMCS crash hooks if and only
 if KVM_INTEL is enabled
Thread-Index: AQHZU5lISsWrsOG2RkqqMnGPjlbwcq733zCAgAEtigCAAHIzAA==
Date:   Tue, 14 Mar 2023 01:19:51 +0000
Message-ID: <a0c9ce4bbd625ede0b566990dc497000d6d303e7.camel@intel.com>
References: <20230310214232.806108-1-seanjc@google.com>
         <20230310214232.806108-3-seanjc@google.com>
         <a3e58e90a6b26019633afeef9162720ef39c5e03.camel@intel.com>
         <ZA9rl1sp0l9oPoBm@google.com>
In-Reply-To: <ZA9rl1sp0l9oPoBm@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB7698:EE_
x-ms-office365-filtering-correlation-id: 18888dba-1773-4539-d513-08db242a3609
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: elo6QduJj0h5zaWMO4QHZWgXJ6ibhYIEdZ457OfBSGTLyCN8HM95hySlyHcC6l95pAofI8ad94APG5YszDSXpRhVZeJCt8j2kcwVsEzDd50KsYGotT/pgqmJ5efwQ2VO2E9Rm7lgIevR1o7pLH1sNMgDETFvxbJiX0BO78J0aXqVLPKr2+j++HVVIi/BEEE7RRObtoKqZ0/C0nu4iRgk+8t6nUJZmtrjCeMI8d2kOUj3AkIrKTSVDM4Rw2XpBPuk0+th7SQNpHP+rXeZuH7IbQKtx7DGv//NIyv143Lu7Jpj2G7BPd8zIcv+0ah9pmBCUOFJ+cJge2UNu9iao1tlwButQdor9oCIl4OZex5P25O+6eI1vJFmAOUT4yBLzGzk//YXnMGFHdq0eaacarTp6LEBWcc1zP8FqX3u5LpCd00asf7xj6aI+PngQlIadMWvCVnEhmrhiU3HvTSgvF1GoXMURLz3vEvu2JInDeW18mFs/Cw56mNui0MKzVhS7pF2tDS0zUooA6sxHCDoe7v/KAiTRXM2b5uhb+T3bjzYFtmNdeOGbvqM97LNtJRfPJQiKxU79Raao1j7jtwMQdQscYQSCBnlfgkO8fyqYQGTZpHFmaw3tcVoOwF0cSgWfBKgL0eDKauAmEQl/dqbJxsoy7TZE8t4OST7EsbPqDohu2QwDnjbsv9WyrchJVMR1HGBlztQussGl9dZGxRYDyty/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(39860400002)(346002)(376002)(136003)(451199018)(82960400001)(2906002)(122000001)(83380400001)(5660300002)(36756003)(7416002)(8676002)(76116006)(66476007)(66946007)(186003)(86362001)(6916009)(41300700001)(8936002)(38070700005)(4326008)(66446008)(91956017)(38100700002)(316002)(64756008)(54906003)(478600001)(71200400001)(66556008)(2616005)(26005)(6512007)(6486002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aTNkSFNza29NdDZYazJGcy9zT0pjQnJKa1AzalE0SFpkQkJGc3phSHB1V1Y5?=
 =?utf-8?B?dnFkVkMzTGEwMWNKMmlsM2ZnQVhieGdIRkVCc25Pa2dVdVIwWC9tVnVNVmwx?=
 =?utf-8?B?OHhZcXZEMWtYOVA1SWNYMzJTWkVaeUdacjgvWTNGVE5ldFUrbkxpdmZmWEcy?=
 =?utf-8?B?RXRoRnFpYVFzazZjUkpJM3BESFJQR3hPNXBXVk5NQkhUSUhCUHkrSVVKdStV?=
 =?utf-8?B?SjFvUWJ0TytYUXI4NzFVQ1VheHZ2dkJ5K2o0cnloSnNJeDlCRmIrWE94WkJU?=
 =?utf-8?B?blNoSTZDZ3dyMlA4TDV6Q0UxWjZtbXZCQkRjN0o5NVVzQ0h2OEFDcW9kdHQy?=
 =?utf-8?B?UzRRNFdKNXJoQ3hlU1VpVjBNUkszbDIvdEwxaFQrb1FPZzh2eXFWNHYzRUZ3?=
 =?utf-8?B?UEozaDM2eFpvRFh0LzhkZUltWVljaHh5QklOZ05xMlVjdlAzVmtWK1dGdk43?=
 =?utf-8?B?c0FLL1cwRmZXbi9adzBPcTZPRTlMa0gwaDFWU2N3Nkw5YkR2U1RXc1JaQkZv?=
 =?utf-8?B?NWVoMXVWdXByUHh3RGRNVUZwOVBQTTVVZXpqTGFjYllaajJabDc1bGhvU0hw?=
 =?utf-8?B?YmNhL1AvSlJUOWthV0FoNW1lMW4vam9iRmFibTcxb1Y0UWs0NnVjeUhZMnZR?=
 =?utf-8?B?T1lZMzExcmgyRlVYV2VIeXRlZGRjRlMxZFA2a2NpSmV6eGcvSjBsanp4Qjlz?=
 =?utf-8?B?WTFSc2dFY1BMOFJ3YW5JK0w5Q2dwZ1pXSWtNdUxOVkZBWk5scHZWSko2VEw1?=
 =?utf-8?B?cGVJcW9jTndIM05GWTM0Y05iamdjb25senF1QThQR2JEb2FFUHlnaFpMalFT?=
 =?utf-8?B?ZXVNVlJZbTZHSnY3TzZVdkU0M3JNdTFKVS9Ed0NFS3NlMnBIMCtGemRlV3J0?=
 =?utf-8?B?RGxlQU1XWGQ2cFdMWEtKSG5DZng4eW14dTdGbXpiZVRsc1VHR1M5b3ZXTkZU?=
 =?utf-8?B?OUlrOTd0Tm13K1ROMmgrSXY3NXVrVDhWci8rZEdvU254c3hOQ1Bid01NeGdQ?=
 =?utf-8?B?NEF4Ti9TQjZvMnM0ci9JdzgzUGJjWGpVUVIvMzlaRTFpT0FRZVZ3NWtodmRt?=
 =?utf-8?B?UW1xaUNScFV2VitTaDgrNVoxZTVrOTNnSDZ6cUpCU1lXRVZhUWZSVTUvWEZY?=
 =?utf-8?B?V0tOdFhXcC9PeXpZbitGVEdZb1AzMDY3VXYvRDVDMXFKQ0lWVUs2WWlVbnBR?=
 =?utf-8?B?am5GWHRSZWoyaVlYOUtoK1NqL2dNSTFxVEsvRUs0eDFELzBtUDRRQXlNamFv?=
 =?utf-8?B?NC85U2xQTHhXVmFxc0FBZVR3UnNsWEZYeWFVOEJKTDJpd1FZeUhQaXBYcVBV?=
 =?utf-8?B?MmpGbmxhRi9pYzFFRkhHQ1pWWDJiTktxQVhUcnJVZmRxL1dPb3Bsc21kYWhy?=
 =?utf-8?B?V0Z2V3NFb2pVYjBRSENYcjlleVhqSHlaS2g2N0VldEZEYTJ6cnc1eTVEMWFH?=
 =?utf-8?B?THdFcTlpZTdlZnNYaWNUQlpXWktlNklZc0hYcENzbFRBZkZQNTBBdzNtT0pi?=
 =?utf-8?B?MHVTb0Y5bm1xRC9GbUdUZ2k2SndyMHVYdUE0d0YxSDA2Q0NwdEw3eU5FRXE5?=
 =?utf-8?B?ZFFnRHRoRk95T2szYmFKNmt0Y25VQnE2Z09CTmtJVEJsOVpqVHM2cW94M0pD?=
 =?utf-8?B?RnNIL3B0c1h3ajZEb2VybFVzNnJRdHhNZlRCZ3dtRm1tNCtUUkRiQkQyTnJz?=
 =?utf-8?B?V3paTDFtYzRLR2hoR0IwdTUxQlByZGRSNVB5UDc3VE44M01OVFFKbXQ0dm55?=
 =?utf-8?B?Sy9vMzJDUmM3UmMwbHhINk1QYk1JakZBVFY0TnlBMmkrNWRiSDJyaURRQllS?=
 =?utf-8?B?ME1EZjdjbTFxcVZMeVNKNzFpOW5CRGlTSWY4VTB0VEQvajBLdXRZNkpTZUZP?=
 =?utf-8?B?Vk1IWDdzUFN4N1FhQ3BXRG9pVVcxd3hOdWVIVExXWVJ0SEowaGF3UHRCT1pk?=
 =?utf-8?B?aW5aS0k2WGRnalJRWnY5RHpPT2lCR3JqeUtpckhWRlB4T0NDU1hYSWpxbTVB?=
 =?utf-8?B?MnU4LzdabmFmYkwzbFNicExKZHB0RElxSVc4Nlc4RjY5OXRWMWRyUlB3Zy9W?=
 =?utf-8?B?NkIrWWpwSmM2azFjUDVnWHNqczZGcDhXVXI2c0lMcFVRM2pqNCtwRmlPdE9y?=
 =?utf-8?B?TXNBT0FRRmdPMFdDTVF2RzR3K2xOczlhNWpvQU8rdnVUUUxNK3BjRFRycXVr?=
 =?utf-8?B?Z0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB45045BC1F5ED42A325167AFF6E8EA2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18888dba-1773-4539-d513-08db242a3609
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 01:19:51.6272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cfVFOqTUHI5Kvs4FeMNNyioKdO7cPhyTR3tpb+LaSBeUGTuM44MUp20WrY3Nf+TWZS1Oc2jllGRalBqxNbAgPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7698
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IA0KPiA+IEJ1dCBJIGFtIG5vdCBzdXJlIHdoZXRoZXIgd2Ugd2FudCB0byBkbyB0aGlzICho
YXZpbmcgQ09ORklHX0tWTV9JTlRFTCBhcm91bmQgdGhlDQo+ID4gcmVsZXZhbnQgY29kZSkuICBJ
biBsYXRlciBwYXRjaGVzLCB5b3UgbWVudGlvbmVkIHRoZSBjYXNlIG9mIG91dC1vZi10cmVlDQo+
ID4gaHlwZXJ2aXNvciwgZm9yIGluc3RhbmNlLCBiZWxvdyBpbiB0aGUgY2hhbmdlbG9nIG9mIHBh
dGNoIDA0Og0KPiA+IA0KPiA+IAlUaGVyZSdzIG5vIG5lZWQgdG8gYXR0ZW1wdCBWTVhPRkYgaWYg
S1ZNIChvciBzb21lIG90aGVyIG91dC1vZi10cmVlw6/Cv8K9DQo+ID4gCWh5cGVydmlzb3IpIGlz
bid0IGxvYWRlZC9hY3RpdmUuLi4NCj4gPiANCj4gPiBUaGlzIG1lYW5zIHdlIHdhbnQgdG8gZG8g
aGFuZGxlIFZNQ0xFQVIrVk1YT0ZGIGluIGNhc2Ugb2Ygb3V0LW9mLXRyZWUgaHlwZXJ2aXNvcg0K
PiA+IHRvby4gIFNvLCBzaG91bGRuJ3QgdGhlIGhvb2tzIGFsd2F5cyBleGlzdCBidXQgbm90IG9u
bHkgYXZhaWxhYmxlIHdoZW4gS1ZNX0lOVEVMDQo+ID4gb3IgS1ZNX0FNRCBpcyBvbiwgc28gdGhl
IG91dC1vZi10cmVlIGh5cGVydmlzb3IgY2FuIHJlZ2lzdGVyIHRoZWlyIGNhbGxiYWNrcz8NCj4g
DQo+IEFoLCBJIHNlZSBob3cgSSBjb25mdXNlZCB0aGluZ3Mgd2l0aCB0aGF0IHN0YXRlbWVudC4g
IE15IGludGVudCB3YXMgb25seSB0byBjYWxsDQo+IG91dCB0aGF0LCB0ZWNobmljYWxseSwgYSBu
b24tTlVMTCBjYWxsYmFjayBkb2Vzbid0IG1lYW4gS1ZNIGlzIGxvYWRlZC4gIEkgZGlkbid0DQo+
IGludGVuZCB0byBzaWduIHRoZSBrZXJuZWwgdXAgZm9yIGdvaW5nIG91dCBvZiBpdHMgd2F5IHRv
IHN1cHBvcnQgb3V0LW9mLXRyZWUgaHlwZXJ2aXNvcnMuDQoNCkkgaW50ZXJwcmV0IHRoaXMgYXM6
DQoNCktlcm5lbCBkb2Vzbid0IG9mZmljaWFsbHkgc3VwcG9ydCB0aGUgb3V0LW9mLXRyZWUgaHlw
ZXJ2aXNvciwgYnV0IGl0IHByb3ZpZGVzIGENCmNhbGxiYWNrIHdoaWNoIHRoZSBvdXQtb2YtdHJl
ZSBoeXBlcnZpc29yIGNhbiB1dGlsaXplIHRvIGhhbmRsZSBlbWVyZ2VuY3kgdmlydA0KZGlzYWJs
ZS4gIEJ1dCBzdWNoIGNhbGxiYWNrIGlzIG9ubHkgYXZhaWxhYmxlIHdoZW4gS1ZNIGlzIHR1cm5l
ZCBvbiBpbiB0aGUNCktjb25maWcuDQoNCj8NCg0KPiANCj4gRG9lcyBpdCByZWFkIGJldHRlciBp
ZiBJIGFkZCBhICJ0aGF0IHBpZ2d5YmFja2VkIHRoZSBjYWxsYmFjayIgcXVhbGlmaWVyPw0KPiAN
Cj4gICBUaGVyZSdzIG5vIG5lZWQgdG8gYXR0ZW1wdCBWTVhPRkYgaWYgS1ZNIChvciBzb21lIG90
aGVyIG91dC1vZi10cmVlIGh5cGVydmlzb3INCj4gICB0aGF0IHBpZ2d5YmFja2VkIHRoZSBjYWxs
YmFjaykgaXNuJ3QgbG9hZGVkL2FjdGl2ZSwgaS5lLiBpZiB0aGUgQ1BVIGNhbid0DQo+ICAgcG9z
c2libHkgYmUgcG9zdC1WTVhPTi4gDQoNCkkgdGhpbmsgc28/DQoNCkJ1dCBvdmVyYWxsIEkganVz
dCB0aGluayBoYXZpbmcgdG8gY29uc2lkZXIgb3V0LW9mLXRyZWUgaHlwZXJ2aXNvciAod2UgYXJl
DQp0YWxraW5nIGFib3V0IGEgbG9hZGFibGUgbW9kdWxlLCByaWdodCkgb25seSBtYWtlcyB0aGlu
ZyBtb3JlIGNvbmZ1c2luZy4gIEkNCmd1ZXNzIHdlIGNhbiBlaXRoZXI6DQoNCjEpIERvbid0IG1l
bnRpb24gb3V0LW9mLXRyZWUgaHlwZXJ2aXNvciBhdCBhbGwuICBUaGlzIG1lYW5zIGtlcm5lbCBk
b2Vzbid0DQpvZmZpY2lhbGx5IHByb3ZpZGUgbWVjaGFuaXNtcyB0byBzdXBwb3J0IG91dC1vZi10
cmVlIGh5cGVyaXZpc29yIChhIG1vZHVsZSkuICBJZg0Kc29tZW9uZSB3YW50cyB0byBkbyB0aGF0
LCB0aGVuIHNvbWVvbmUgdGFrZXMgdGhlIHJpc2suDQoNCjIpIFRoZSBrZXJuZWwgb2ZmaWNpYWxs
eSBwcm92aWRlIHRoZSBjYWxsYmFjayB0byBoYW5kbGUgZW1lcmdlbmN5IHZpcnQgZGlzYWJsZQ0K
Zm9yIG91dC1vZi10cmVlIGh5cGVydmlzb3IgKG1vZHVsZSkgdG8gdXNlLiAgQnV0IHRoaXMgY2Fs
bGJhY2sgc2hvdWxkIGJlDQphdmFpbGFibGUgd2hlbiBLVk0gaXMgb2ZmLg0KDQo/IA0K
