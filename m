Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C1B66DD5D
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 13:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236739AbjAQMTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 07:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236199AbjAQMTV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 07:19:21 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD5A360A0;
        Tue, 17 Jan 2023 04:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673957960; x=1705493960;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2E9mI182B10zATUPK1u8w2DzLhkeQHVCzHe6TuIichM=;
  b=IqVmEObT0oLA9A4ITBZlCwjDZqpIueMRjJTRMs42iuU1C5sG/GTTiujL
   dgbzB/bZQ0iqAN+8nnT52dDL4YGA+PqzUbN9lgd4t+XmpX2VS3hpKRXDx
   zqPpKiXDL9cxxN2NYUCKoNjCBjad24ZIdcAcVWibxMJMUHqed6OQzQEkz
   tOok1nQxAdZi0q66yxYTKw21v6qnHQo0QXYm4NsdN82BJyzgEzBFZzHOl
   F3zCCz7Uph2WehdcWAaNlkcsJ8RZ4AfT4QnePkPnHKmX21MMCbcPFGwNZ
   TSu/gsetMH1gehHQx+UBiJrAt0datplp2Ho50b+AOHhK7LCsCH+LYgPgc
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="305055605"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="305055605"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 04:19:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="722635511"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="722635511"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jan 2023 04:19:19 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 04:19:19 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 04:19:19 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 04:19:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n04Hln8CRszPQvUvyui92sT18X1jbN9p4LG6VBjLc7LzKrQV+VatKCkkUvk72Tmx4MuVhCjyQdPkn49zylLhSCcPbdnsk0dNPn3WU/Z1j4QvV0ruvyBNuG14qR4iORqyLNmccHZ8nmSQfmWdgVCqCNAZfoie4IiLM/NTgwWtebMxNGNb0yYSrzKdvyUXkAd8eHw6GqdzvBrekZvt8zwL6n7O1uXBjb1UD7vF1+TSCx13XAXzXIJ4/neUN58IWHyMIvKg+MmMT2fQcKQJyqOrKuunwzeBFbAvarraB3R1AUwrSoUHuWqoXKkTPhyUyWikzTnvy7LVsEl8S5dy6bo44A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2E9mI182B10zATUPK1u8w2DzLhkeQHVCzHe6TuIichM=;
 b=U9xUKuMCmW4ajabecDefMWZOFOnFXOkmVWokGJohqDJ/CKi4WIuQFy37hXce8YSXmPCwe/mnKm65B/PqFXo0FUBx9kdFu+K3pRJbxEhvDPAjQPUlmmweUwywTiNUTdIL/qS9ot49xG/XFNM3wj0Ej0mduz8Ksl1q+ee/6N1ygcpvg7iRePmFLF2kY1OlB76gFk+NWce4RqJXMqs6h7yZ1UprnUwmaHA4EgUsmcZOy1T/mWD3/Xbp+Y/uuvqsGyrkDzKUPW43Xv0JgsP8TUmsg/Wpb1TxYrsf/DelAv+bb28ABc2IQ92BPRv05/jxzpjeJbenUkMPEKpUMsVdaaDByA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6453.namprd11.prod.outlook.com (2603:10b6:8:b6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 12:19:16 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%6]) with mapi id 15.20.5986.019; Tue, 17 Jan 2023
 12:19:16 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 019/113] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Topic: [PATCH v11 019/113] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Index: AQHZJqT1ezRBV5wttUugNmYVfUxfG66ijoYA
Date:   Tue, 17 Jan 2023 12:19:15 +0000
Message-ID: <0c59400e6a2420b669b22972633d7b1563ccbbfb.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <a0b5c459cce27c83a1275a3108f810299635d217.1673539699.git.isaku.yamahata@intel.com>
In-Reply-To: <a0b5c459cce27c83a1275a3108f810299635d217.1673539699.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB6453:EE_
x-ms-office365-filtering-correlation-id: ab49026e-91ff-404b-1eac-08daf8850ced
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jeogzJE02tlsyxIWAxKa94PYhkFRYoCSSCqJurJ2Zrk8Sqkyk7uqvuF7Sb5arxmM08EPjVPoI7eh6Vy/Cls+PCdzW2PngvsNevL4yiYBqHvTxBsjl4jyYIpxsiO0KeyXa316uCadg471Qqvoe0EEtyMeRbvVt77Fvj7ejFQDIoI582skqHMwYLkaYKIjlZdPNfygqhhoTZPs2r2emUThBDwWDrufO+G5v5H6ZZzQmr3GL4ndNzlfAFOS4X9t3lVHx4PyXnM9yoBAiHBemgpx3ugIHPyHWdHwXzocswYC07GXJedavdSoqZWcOt697DF6hBpoWHA8eBLFR1LdolcCw9G2AbVT0MzNhHsPdWgEF740AN04rTqxTLUTBHHivTri7IO/1rgV6b1bqKpVSbF4Y2/9UwQFmr8JCsIbxezg/xLnUC2ujBbECJ47Ko25g3yk0AOPY+hda5Rfwv9ko84CEiPCUpBV0P8VPWxAERGmPulSZHOqUC+EttpOmFGyojfzVEwmm8bv20MdrT1SR9P5UaySwmoA7etbeT+MAg+0sUSVQ4xImoO/B8QnvERdKOng0EH9wITevYBfyXUHgc2yL0pR/qSF7rcSgydEim/WSGag63bADSzQLz1dZ8FFZjYHwvWj2EO5nn5+8S6fAqFnADo3uS2MIo4TqrE96ZOyeHFSZ+toqI+D8UZuMGkUuSZrHqNryM5/Ec4pzfY+i/pHlA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(396003)(39860400002)(366004)(451199015)(82960400001)(83380400001)(38100700002)(122000001)(38070700005)(4326008)(64756008)(2906002)(5660300002)(8676002)(66446008)(8936002)(66946007)(66556008)(66476007)(76116006)(91956017)(41300700001)(26005)(6506007)(186003)(2616005)(6512007)(316002)(110136005)(6486002)(71200400001)(54906003)(86362001)(478600001)(6636002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dkNqa2FoVGJmR1IxczMwSUFsTkgvV3dyc0NpUHZreEM1K0d2cG5VNHRmdG9V?=
 =?utf-8?B?UUpYaTVFQmsyOG5rNTdHYm12aFhyYzBmR1c3VDhqdUpvS1BXN2hYdUxPeWlt?=
 =?utf-8?B?WGdGK2t1eC9GSTBhU0c2dVErWGVncFc5U1RpTW5DSnRjaGE2SjdJK0Y4Szhs?=
 =?utf-8?B?KzEzY29WMXJMVndncVFKczV1NXZmZ1lkNjdoRThDQnZ3cklaU0gxczBwWFdx?=
 =?utf-8?B?c0hwVTZoUkIrUytXTy9aQTUzM0lOVFlVV0w2SUxTSWRVbDlZSHlyVWdlZUVQ?=
 =?utf-8?B?TEQzMWRyMWd1Y2tEV0VDclB5RW1Fc0Nzem1yVSt6NVVIeHBTald3TEt5cWpm?=
 =?utf-8?B?ckJuY1JaUkVSYjh5S0NOVmN5WXd6bHlDSHBXNmU5Nk15dEZYNStjb3Fwa09a?=
 =?utf-8?B?bGd3RVNyWXpxa1JRK1k0WGdDUG5RQlBzdHA5ZmNRWTk1QnFrdVg0bE9ENHo0?=
 =?utf-8?B?YWRCU2hrd29wQ2Q4THJ0dDdIc09xekxaOFBpN0txRTJvckJnbzViNUplNmNV?=
 =?utf-8?B?dXNPZzRTNS9MTjk2QkViZVBLQzR4UURBOXo2S3docGpFdjZDeWtubXQvWks1?=
 =?utf-8?B?SXlkYmorZFllU2NwbCtnODM5cktlSjJySEtTNzJiYTU0V3NQaVVHMGxRYUE4?=
 =?utf-8?B?ZkNQcDlDTG81eksxSlBWMXVMQkpSbXlVTHd1MmZhbXUyVThGRFZKbE5JbDYr?=
 =?utf-8?B?dWsvOEU5WWFGWTMraDBYTTk0R0EvMUZMNUZJanp5bVlKSHdNNGF6dDFXUm1D?=
 =?utf-8?B?KzFDcEtxUXMzT2d4eSt6ZHFkaHB3WHNoVmlFL0ljZjBlNXpqaStZTXJqU3du?=
 =?utf-8?B?aWF0VW5HYUFLZW54dkNzSHNxN2FCdVRUWnkzazVoV01ucVVLcXNTNDFXWUdQ?=
 =?utf-8?B?SEtCcjRVejdOZ1RjamtVUVBXRmRpNFFqeWZrSGlnUk9zNUxSdlRIVTJoV2Np?=
 =?utf-8?B?MVloY0ozRVFza09pd2llUnR6VGlmMUJMOVVqTGFCYXZ4WTJ5a09Bd0ZKZlJH?=
 =?utf-8?B?S2llaVRKcWM3UngzaWxZaVNhVTlKWi9JdnlwcG9iZFZITjdEOHUvMkY3Q3BD?=
 =?utf-8?B?N00xeXp2bXdPdkhpUGpRMFhXYTI5ZEIwTVo0UTZPaXlQb3pCQldlS0tOQTdB?=
 =?utf-8?B?dEhWK1FyREVyakhrTDZTdFVTTHV6OFNPazlsSERVbnpuZENVbnpYcmZLTEQ4?=
 =?utf-8?B?eUxxaHBMV0xSaXBiQ0lJZGQvOXNmR0FtYzZ4cTBCT2dobEwvdVVYb3hFQjQw?=
 =?utf-8?B?N3R5S1FpWUJIa3Rvemt4ZERGamx1anpRb3NQdUJNL29Nam1CdDMxZDRzeXpB?=
 =?utf-8?B?RVhtNk9JSXh1Y3QzbjB4am1pOXBFWEF5Z2ZHYk5DSEdXTHVGQStVcEExcDFP?=
 =?utf-8?B?ZStpR1FKSnNDZS9hczgyaDF6U3p6MzRpSlYxcGZFbE8wUit4Ty8yUFVTaE5C?=
 =?utf-8?B?OVN6N3RCQllFOEw1WHlPWHJ0dFQ0QUNZM01qV2dSSWRiRHFRMGkyaUxxMDZu?=
 =?utf-8?B?bFB2TjhPeDFOQjhlQUNUZVZ2dFNZQm05QXh2SVRpd2dBVEhSQlNyOEVjRjli?=
 =?utf-8?B?OWpBci93SHJ4WEJDNnhSdUc3NXdldTlmaWJwYlpaR3lCZ3dEa3M2VzlWdnZp?=
 =?utf-8?B?Ymh3amxBamhRdnFySkFGMk1BTnVzSXZ1Y3VVbzlZTEtkT0cvOTRqdCtPWFFG?=
 =?utf-8?B?T0FnQVhHZlRGUW1jZStQMlBUYWdPcHpYNVNEWTRiMXIrWnJVanlSZU15M05z?=
 =?utf-8?B?VTNjR2RiYUZjeHU5MUlWMjhRYWNhYitKRVNPUTRzYW5GaHVvTHhraEhoYW11?=
 =?utf-8?B?YzFVdnBUTG9pelQ1ak01UFZWK3g0V05iQldPL29INjh5NURtU0QwaUk3azJh?=
 =?utf-8?B?a3N2QWFMbkdpMHE2dDVXamxHMGJMbitVVEZhaTNBNW96S1phZnBVZkcyQXFP?=
 =?utf-8?B?SVUyaEN3N2NES3hSbHRQL2lVSlZuY1ZnUmhFeHRKTlZHZ2dpZUlpMUIxaGdX?=
 =?utf-8?B?RU1KRUgyeVptcUhMWXdKeHFIMktxV1FaeTNkMFFhaWFnb1VNZEhjWGtVMHZY?=
 =?utf-8?B?anhMWVQxam9SN3ZKTXU1bHlyMGhwQ3NjekRtSW9vb0xLNmx1L2FNdmF4eTdQ?=
 =?utf-8?B?emJZcFhsN04yMVlvQVpKempXWFFPNTRwYUIraEhTMHpmZTRIU0U5czU1QmVS?=
 =?utf-8?B?VEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <39078952870BDB4B9782CA4DFEB9AE52@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab49026e-91ff-404b-1eac-08daf8850ced
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2023 12:19:15.7083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5iyExPoRdcJY70GO7I+5x6hXGshtXzcOdiFkywgOG/mvhkMo+l9Grz03bRa1aAQC2bpTb0TYWkZTdiGyDJ7sHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6453
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQpbc25pcF0NCg0KPiArLyoNCj4gKyAqIGNwdWlkIGVudHJ5IGxvb2t1cCBpbiBURFggY3B1aWQg
Y29uZmlnIHdheS4NCj4gKyAqIFRoZSBkaWZmZXJlbmNlIGlzIGhvdyB0byBzcGVjaWZ5IGluZGV4
KHN1YmxlYXZlcykuDQoNCkFGQUlDVCB5b3Ugb25seSBoYXZlIG9uZSBjYWxsZXIgaGVyZS4gIElm
IHRoaXMgaXMgdGhlIG9ubHkgZGlmZmVyZW5jZSwgd2lsbCBpdA0KYmUgc2ltcGxlciB0byBhc2sg
Y2FsbGVyIHRvIHNpbXBseSBjb252ZXJ0IFREWF9DUFVJRF9OT19TVUJMRUFGIHRvIDAsIHNvIHRo
aXMNCmZ1bmN0aW9uIGNhbiBwZXJoYXBzIGJlIHJlbW92ZWQ/DQoNCj4gKyAqIFNwZWNpZnkgaW5k
ZXggdG8gVERYX0NQVUlEX05PX1NVQkxFQUYgZm9yIENQVUlEIGxlYWYgd2l0aCBuby1zdWJsZWF2
ZXMuDQo+ICsgKi8NCj4gK3N0YXRpYyBjb25zdCBzdHJ1Y3Qga3ZtX2NwdWlkX2VudHJ5MiAqdGR4
X2ZpbmRfY3B1aWRfZW50cnkoY29uc3Qgc3RydWN0IGt2bV9jcHVpZDIgKmNwdWlkLA0KPiArCQkJ
CQkJCSAgIHUzMiBmdW5jdGlvbiwgdTMyIGluZGV4KQ0KPiArew0KPiArCWludCBpOw0KPiArDQo+
ICsJLyogSW4gVERYIENQVSBDT05GSUcsIFREWF9DUFVJRF9OT19TVUJMRUFGIG1lYW5zIGluZGV4
ID0gMC4gKi8NCgkJICBeDQoJCSAgQ1BVSURfQ09ORklHIHBsZWFzZS4NCg0KPiArCWlmIChpbmRl
eCA9PSBURFhfQ1BVSURfTk9fU1VCTEVBRikNCj4gKwkJaW5kZXggPSAwOw0KPiArDQo+ICsJZm9y
IChpID0gMDsgaSA8IGNwdWlkLT5uZW50OyBpKyspIHsNCj4gKwkJY29uc3Qgc3RydWN0IGt2bV9j
cHVpZF9lbnRyeTIgKmUgPSAmY3B1aWQtPmVudHJpZXNbaV07DQo+ICsNCj4gKwkJaWYgKGUtPmZ1
bmN0aW9uID09IGZ1bmN0aW9uICYmDQo+ICsJCSAgICAoZS0+aW5kZXggPT0gaW5kZXggfHwNCj4g
KwkJICAgICAhKGUtPmZsYWdzICYgS1ZNX0NQVUlEX0ZMQUdfU0lHTklGQ0FOVF9JTkRFWCkpKQ0K
PiArCQkJcmV0dXJuIGU7DQo+ICsJfQ0KPiArCXJldHVybiBOVUxMOw0KPiArfQ0KPiArDQo+ICtz
dGF0aWMgaW50IHNldHVwX3RkcGFyYW1zKHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IHRkX3BhcmFt
cyAqdGRfcGFyYW1zLA0KPiArCQkJc3RydWN0IGt2bV90ZHhfaW5pdF92bSAqaW5pdF92bSkNCj4g
K3sNCj4gKwljb25zdCBzdHJ1Y3Qga3ZtX2NwdWlkMiAqY3B1aWQgPSAmaW5pdF92bS0+Y3B1aWQ7
DQo+ICsJY29uc3Qgc3RydWN0IGt2bV9jcHVpZF9lbnRyeTIgKmVudHJ5Ow0KPiArCXU2NCBndWVz
dF9zdXBwb3J0ZWRfeGNyMDsNCj4gKwl1NjQgZ3Vlc3Rfc3VwcG9ydGVkX3hzczsNCj4gKwlpbnQg
bWF4X3BhOw0KPiArCWludCBpOw0KPiArDQo+ICsJaWYgKGt2bS0+Y3JlYXRlZF92Y3B1cykNCj4g
KwkJcmV0dXJuIC1FQlVTWTsNCj4gKwl0ZF9wYXJhbXMtPm1heF92Y3B1cyA9IGt2bS0+bWF4X3Zj
cHVzOw0KPiArCXRkX3BhcmFtcy0+YXR0cmlidXRlcyA9IGluaXRfdm0tPmF0dHJpYnV0ZXM7DQo+
ICsJaWYgKHRkX3BhcmFtcy0+YXR0cmlidXRlcyAmIFREWF9URF9BVFRSSUJVVEVfUEVSRk1PTikg
ew0KPiArCQkvKg0KPiArCQkgKiBUT0RPOiBzYXZlL3Jlc3RvcmUgUE1VIHJlbGF0ZWQgcmVnaXN0
ZXJzIGFyb3VuZCBUREVOVEVSLg0KPiArCQkgKiBPbmNlIGl0J3MgZG9uZSwgcmVtb3ZlIHRoaXMg
Z3VhcmQuDQo+ICsJCSAqLw0KPiArCQlwcl93YXJuKCJURCBkb2Vzbid0IHN1cHBvcnQgcGVyZm1v
biB5ZXQuIEtWTSBuZWVkcyB0byBzYXZlL3Jlc3RvcmUgIg0KPiArCQkJImhvc3QgcGVyZiByZWdp
c3RlcnMgcHJvcGVybHkuXG4iKTsNCj4gKwkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiArCX0NCj4g
Kw0KPiArCWZvciAoaSA9IDA7IGkgPCB0ZHhfY2Fwcy5ucl9jcHVpZF9jb25maWdzOyBpKyspIHsN
Cj4gKwkJY29uc3Qgc3RydWN0IHRkeF9jcHVpZF9jb25maWcgKmNvbmZpZyA9ICZ0ZHhfY2Fwcy5j
cHVpZF9jb25maWdzW2ldOw0KPiArCQljb25zdCBzdHJ1Y3Qga3ZtX2NwdWlkX2VudHJ5MiAqZW50
cnkgPQ0KPiArCQkJdGR4X2ZpbmRfY3B1aWRfZW50cnkoY3B1aWQsIGNvbmZpZy0+bGVhZiwgY29u
ZmlnLT5zdWJfbGVhZik7DQo+ICsJCXN0cnVjdCB0ZHhfY3B1aWRfdmFsdWUgKnZhbHVlID0gJnRk
X3BhcmFtcy0+Y3B1aWRfdmFsdWVzW2ldOw0KPiArDQo+ICsJCWlmICghZW50cnkpDQo+ICsJCQlj
b250aW51ZTsNCj4gKw0KPiArCQl2YWx1ZS0+ZWF4ID0gZW50cnktPmVheCAmIGNvbmZpZy0+ZWF4
Ow0KPiArCQl2YWx1ZS0+ZWJ4ID0gZW50cnktPmVieCAmIGNvbmZpZy0+ZWJ4Ow0KPiArCQl2YWx1
ZS0+ZWN4ID0gZW50cnktPmVjeCAmIGNvbmZpZy0+ZWN4Ow0KPiArCQl2YWx1ZS0+ZWR4ID0gZW50
cnktPmVkeCAmIGNvbmZpZy0+ZWR4Ow0KPiArCX0NCg0KQSBjb21tZW50IHRvIGV4cGxhaW4gYWJv
dmUgd291bGQgYmUgaGVscGZ1bCwgaS5lIFREWCByZXF1aXJlcyB0aGUgbnVtYmVyIGFuZCB0aGUN
Cm9yZGVyIG9mIHRob3NlIGVudHJpZXMgaW4gVERfUEFSQU1TJ3MgY3B1aWRfdmFsdWVzW10gbXVz
dCBiZSBpbiB0aGUgc2FtZSBudW1iZXINCmFuZCBvcmRlciB3aXRoIFREU1lTSU5GTydzIENQVUlE
X0NPTkZJRy4NCg0KQWxzbywgdGhpcyBjb2RlIGRlcGVuZHMgb24gQHRkX3BhcmFtcyBhbHJlYWR5
IGJlaW5nIHplcm9lZC4gIFBlcmhhcHMgYWxzbyBwb2ludA0KaXQgb3V0Lg0KIA0KDQpbc25pcF0N
Cg0KPiArc3RhdGljIGludCB0ZHhfdGRfaW5pdChzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1f
dGR4X2NtZCAqY21kKQ0KPiArew0KPiANCltzbmlwXQ0KDQo+ICsNCj4gKwlyZXQgPSBzZXR1cF90
ZHBhcmFtcyhrdm0sIHRkX3BhcmFtcywgaW5pdF92bSk7DQo+ICsJaWYgKHJldCkNCj4gKwkJZ290
byBvdXQ7DQo+ICsNCj4gKwlyZXQgPSBfX3RkeF90ZF9pbml0KGt2bSwgdGRfcGFyYW1zKTsNCj4g
KwlpZiAocmV0KQ0KPiArCQlnb3RvIG91dDsNCj4gKw0KPiArCWt2bV90ZHgtPnRzY19vZmZzZXQg
PSB0ZF90ZGNzX2V4ZWNfcmVhZDY0KGt2bV90ZHgsIFREX1REQ1NfRVhFQ19UU0NfT0ZGU0VUKTsN
Cj4gKwlrdm1fdGR4LT5hdHRyaWJ1dGVzID0gdGRfcGFyYW1zLT5hdHRyaWJ1dGVzOw0KPiArCWt2
bV90ZHgtPnhmYW0gPSB0ZF9wYXJhbXMtPnhmYW07DQo+ICsNCj4gK291dDoNCj4gKwkvKiBrZnJl
ZSgpIGFjY2VwdHMgTlVMTC4gKi8NCj4gKwlrZnJlZShpbml0X3ZtKTsNCj4gKwlrZnJlZSh0ZF9w
YXJhbXMpOw0KDQpTbyBsb29rcyBLVk0gZG9lc24ndCBDUFVJRCBjb25maWd1cmF0aW9ucyB0aGF0
IGFyZSBwYXNzZWQgdG8gdGhlIFREWCBtb2R1bGUuIMKgDQoNCklJVUMsIEtWTSBzdGlsbCBkZXBl
bmRzIG9uIHVzZXJzcGFjZSB0byBsYXRlciB1c2UgS1ZNX1NFVF9DUFVJRDIgdG8gZmlsbCB0aGUN
Cl9zYW1lXyBDUFVJRCBlbnRyaWVzIGZvciBlYWNoIHZjcHU/ICBJZiBzbywgd2hhdCBpZiB1c2Vy
c3BhY2UgZGlkbid0IHByb3ZpZGUNCmNvbnNpc3RlbnQgQ1BVSURzIGluIEtWTV9TRVRfQ1BVSUQy
PyAgU2hvdWxkIHdlIHZlcmlmeSBpbiBLVk1fU0VUX0NQVUlEMiB0aGF0DQpDUFVJRHMgYXJlIGNv
bnNpc3RlbnQ/DQoNCkkgYW0gdGhpbmtpbmcgaWYgc29tZSAjVkUgaGFuZGxpbmcgcmVxdWlyZXMg
Q1BVSUQgdG8gbWFrZSBzb21lIGRlY2lzaW9uLCB0aGVuDQppbmNvbnNpc3RlbnQgQ1BVSURzIHdp
bGwgY2F1c2UgdHJvdWJsZSwgYnV0IEkgZG9uJ3QgaGF2ZSBhbiBleGFtcGxlIG5vdy4NCg0KPiAr
CXJldHVybiByZXQ7DQo+ICt9DQo+ICsNCj4gDQoNCltzbmlwXQ0K
