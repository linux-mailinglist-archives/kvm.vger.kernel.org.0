Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099B2665047
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 01:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbjAKAN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 19:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235550AbjAKANv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 19:13:51 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7025B4B3;
        Tue, 10 Jan 2023 16:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673396030; x=1704932030;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pi3zR+S169LFfu78prr7OsFtbbUKMEWI8mCByquURnw=;
  b=G7bK82GLuJmwnfG3dnpYqX4HENFzyptvk/zVTZl1/2XDJ2DF6VJs43b5
   BPfiQxh7c70maPiEu8pR5ZsbIRJdSKoNN7RwBZ7X3+9uPT0Yz3YBU0UNM
   PBrDafYc6PuNJB/VFydVFj8HWR66kwsTyZFvxOABrJk71UGAFlFWQyC1d
   tjIsqdTsOQWNT0wiNCqLFuE6BESjXqxhC2OwuLwkkDboBddf3KGeKY0US
   Zdn2tvSTuykbEBK6ev15D3PMmOWQmhaMfQxgImnPBjDIKmcCqNKPCYc0m
   5nkCQOj3qJ0mcaP+GD1QTxYEBs24v6hLPGhd9kP5/tgw+p4x05Ci1Q4z3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="306805378"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="306805378"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 16:13:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="689589670"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="689589670"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 10 Jan 2023 16:13:49 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 16:13:49 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 16:13:49 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 10 Jan 2023 16:13:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/nmg6NsFy+svngE/gL4YEpDb3Pswk57DUenZz8dcdqlfBbEZJzgAUQVlRKZjy2HyxHLYEQVY1UQxpT2PRjyJpjBeGPgDJv+GoOvVMZSm/LBpi2LkEMGv9jFRtskzHeTY/Ik6sfGUoVVxFQJqj+2fGuYkNzXcQhPu86VJeI9ZnG7PBOo7J+sBUt3bP3OnuQ5DV7yWscYDwzc+w4+vwMz+WzUEfWWvEXes58V/BwFYPaqNuv23EJUqi44queV9iJRCo1M7rg5fOc3q+Q5VapaZbEvIgUF7vdQ5Swn6SDYkVPrZIv/cDHHNuMxxP9Vqc+/hIx9qnmNeoLgEWnHVHfpdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pi3zR+S169LFfu78prr7OsFtbbUKMEWI8mCByquURnw=;
 b=d+JUKwsdMIoXZal03vntlOCDgJIYsI9fy+zFPhVp6kiViD/4U5J1amQPN1D7gBkJ8h/7HZvyVVVpgbYsGsMCuBY/a75jO7ynnwhVXbC6NuCfjsbxlvlE5juuuUTYo3Y2Fd7AEcPLHbZu2Yj2oVfyZZCv669ifINuTWs7bDBAD9e7pxJza0jZSXORNl0eby2NCGvXOQZVRYLYtt2w9QhvAZgJS6Sg9EPf0VMVVL/IEyyz6jQ5hsauQa9F912KU1CoAk1w93L1rlUta/DjvYl0JoigtgwPg7z+k0DW45DCg3mxUNxslUvuDMvYhJv40cieDPibTtNehZ9vXB24bpUNSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7363.namprd11.prod.outlook.com (2603:10b6:930:86::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 00:13:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 00:13:45 +0000
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
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 15/16] x86/virt/tdx: Flush cache in kexec() when TDX is
 enabled
Thread-Topic: [PATCH v8 15/16] x86/virt/tdx: Flush cache in kexec() when TDX
 is enabled
Thread-Index: AQHZC5gL930dln/hIEKzIGHp1lCBha6SSMqAgAVttoCAAEJpgIAAkweA
Date:   Wed, 11 Jan 2023 00:13:45 +0000
Message-ID: <b84232220d03889321248ffb82739c64204cc4af.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <ee5185e1727c3cd8bd51dbf9fcec95d432100d12.1670566861.git.kai.huang@intel.com>
         <ba0fdee9-148b-b0b9-ecde-2610eff02ba1@intel.com>
         <6f959f494f0fb3dedfa963c3d6a0ce7f395b745d.camel@intel.com>
         <944ffd4b-3090-e068-a649-b9a84add8395@intel.com>
In-Reply-To: <944ffd4b-3090-e068-a649-b9a84add8395@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB7363:EE_
x-ms-office365-filtering-correlation-id: c7328d78-2b67-47e2-8233-08daf368b437
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vgCeVifg0STd4R3URNEriveEeVu2sJOOhFwhEJXnMqFadTKhZyOB2wCIo3RWJ7OYwJ6u5bG3OwojBjs2QPY2MoRJLUTTDttMa2YA8o4Xurg9Tau33iA5DqaNTjpG0f+YNQQu+uygqztxtmUj61GU8EIpk/TcgS1ppqjTGyUk6JOvw8SnWG0C+2iKRJh+7HqpNVnc2hpWG9bsoVCa9Yv+WhZdOVbmQ5ifsGhNK7HpRovkl58n9E3FfSIb6Wekg/2HvNaaCaVU006ehAedmmNVrTD3/VIWAeCF4MnUAs0sP6W0XAVVUZLEAnbRmaeHo+LfGn+M3DZKPbit+JDa1f4Xk/6rMWm3B/Jy69SaW3dzETds2Sg8dLbN0jS5OI4V5ziCjMjGtsxEaN9wHefS0D9GjCGvlUhl5LCtu8G1XwmkenDnqfBdLiRS7BeoW5htiEX94cT+THrSoSai5HPiY8+3SwHMvbdzifvupu5VW03eIzmDdG5DN0RtvUdZkaCLZMjiTdOBAbVNunzNZ5eluf6QolKXP3Wo6o3PHtSxx0xm1PW7Xn7tPSb3+HTO1XLl5XwHNmAX1kRe3pTPpb7EhTC6h2zP+/sLXCgcHpuki93hQcVkE1gj2zRffVraj/jedoxTbfg1GSeiw1VRtTeNvlgjWB/k1C4jFlIi2/fprQrJGhhyRjTLUR8RfU34PwsRMX5iA/OIIJ5taVreYimQAYr0rw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199015)(66946007)(41300700001)(2906002)(8936002)(5660300002)(36756003)(7416002)(91956017)(8676002)(66476007)(66446008)(76116006)(6512007)(64756008)(66556008)(316002)(71200400001)(54906003)(110136005)(478600001)(6486002)(53546011)(6506007)(186003)(26005)(4326008)(2616005)(83380400001)(86362001)(38100700002)(82960400001)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dTY2NU5kc0dOZmVpK2t5QXBJWm9kUVNkaGNMc09OQnlvdjI3RnVFdHlpYXRj?=
 =?utf-8?B?Z0l4QzgyV2ZCdFByOU1yNFFuQ016Tk9pV3lYVldSN0RYRHI2TUVjVHlZV1RM?=
 =?utf-8?B?dkRHRWpEWUErWUw5TlZKdEx2cWVDNTNBem1vVnduQlR6T2xXeEtZQ3pWUlFF?=
 =?utf-8?B?bTVXOGp1bE9tOFEvZUdodE1iRmszYW5wcUhKYzhBcGVnWXpWMkxSaThEMGdr?=
 =?utf-8?B?VElCTkYzNGZWSENUZzI5cExBbC9oRW02cjVUcXpEUUIwSGwzNHFRam0rL0pr?=
 =?utf-8?B?Y0hsbzlqU2JWcHZzQnIvOXJXLzlJazBRTVpYVFRHSTRSdG5PMjZGaFdKNHl1?=
 =?utf-8?B?NHdSTDVjREd4MGFPMzA3SXUvbFVRNzNhQk5rc3daN3BEY0wySEZoMkErcStZ?=
 =?utf-8?B?SmlBRFhRTUhuRzdVdTlkRkdELzBMWGNNaWl0N25HL3dPNklvSWloeEhzMThC?=
 =?utf-8?B?c1R5L3IwR0x1RW9sR1I0RWN5NkIvWXpCbm5OcW11UFFZSnoydmJRZzQ0dExu?=
 =?utf-8?B?a3BSL0FNQzVUOWEwTm4yWFNtL1FqRXZQbjlJT0ZBMHcrcDRYNGV5aExJajg2?=
 =?utf-8?B?S0FpZ3dETlVrM21rZVozYmRmZUxKbDA0anJ0bUpoUjk0WEVMZHBucUZQUzdY?=
 =?utf-8?B?TDZmUEhuV0pjdVk0WmFuUDF6K2Y1d3FSWnF1TWJIOHZKTzhzT3p3U0xFZ05z?=
 =?utf-8?B?TW5TcGZPK0dKRUIvOFllaEJTa1hDcHZkRDhmYkhtbjNWakIvS29jbnVKaWpI?=
 =?utf-8?B?SDBZNElDU2NQV0pEVHdjYVNEOCtVVW12cWFkT2h1ekNsdzVFbnFiM2hVMUtI?=
 =?utf-8?B?cFJEY3VpRTJhMWhZZHRiMVdXdXNHMW5IMWNMNXBWQllCclBHaUpXTHh3WUZR?=
 =?utf-8?B?TGphNDl3cUYxQXNLcjVnMURDOVNXMnJRM0JzeXBDMXN1d0lmNmgyUHZWclVk?=
 =?utf-8?B?ekN4YlhYQjdHOFlxMzVEbjkxY0dFeHBmdldvRXo2VTMzM0ZXUVRjSTd5T0hY?=
 =?utf-8?B?UVBGNXZYN3hnV1poWjY1Q2JCdFpKL0FWa3pMQ1drUUFJZ09Ib2gvaURLRm9r?=
 =?utf-8?B?OEFRMlhTbUlPQWpBU1gwRFN5OCtWNkR4SUJGRWdBVEE5bmM2VDlsYk9vajRo?=
 =?utf-8?B?SlkyNitaZU1jOVA1NXFJeUdoUnVaU1Y0MFZQN1RIRXQ1aDg2MEg3REd1V2M2?=
 =?utf-8?B?Z0l4Vy82alpWR2JuMExxMXEvZTFST1FWQkhrc28waGZFK2NOZDgrQy9HL3Qv?=
 =?utf-8?B?cERxOTVRMUtzaS9XVFhZNDZDdStxRGcyQnh3NnBPVUE3R3VML1FPdW1IcmdK?=
 =?utf-8?B?bTdWRmp3VzYrdXRXTzlJSHQ2VGFyUzBsU3RDV2x2STkrZi9mVkt3K3RLd1pD?=
 =?utf-8?B?cmFneFhsMjdrK056cXJ3RTJWOHdmcnl0QUJveEJCSUxOZ0FVUDVWR3M3ZXNB?=
 =?utf-8?B?UXhWZUZ2bHBZYms2Tm1IcnVQRGx4R1lWeTBzZFlrdFI1Z3lzN1U5SGIrNzVJ?=
 =?utf-8?B?Lzl0TDZHQTl2VWxpQ016T2QzT243WDVOTEEzQzNhMnN6R01iR2g0ek81NVIw?=
 =?utf-8?B?YktQK3hodVRRczgwZ3Q1QWduSm1NR2l6QUMrODhmQXF5bWxOQTZ1a0YrZDZy?=
 =?utf-8?B?aUJYV2tvU2hUaVlzT3NyQ0ZoQk55ajVhcXRLdXJJcWFMN2dnQS9sdXVOUUpP?=
 =?utf-8?B?OTc0bzRURzRTazY5V21LaExwRmJuZFlSR2hvSkFiUkFIMmVVUXo1RVhDK242?=
 =?utf-8?B?L2hPaEpBVkJrNlZ2aEV0dTBHaVYxNVFTSTNSRjBVdTFBREhIWUZqWWRTRGw3?=
 =?utf-8?B?MjRnOTVZSkJRZGYvU2pBYlZoZEhWays4U2I4NkNnNlk1NVVIdDJRS1lFMzBD?=
 =?utf-8?B?SU41QzNnV21xRVRPNWZPNEt2RzVjYUhBUHBYdzNWRlJCNk1SNkllZFI4UVc3?=
 =?utf-8?B?RHluY1RqVTVRV1R4VUZLbjZHRHp4eHc5RkI4TkpyYnVDZ0xGRTBBcVpMcVIy?=
 =?utf-8?B?WktzWk5BeCs1WmUxMCtxWGwzOWh3Rk85eWZmZXBpcmh4bnIrN1RIdmVEQmpj?=
 =?utf-8?B?dWVzb1BvellJK3pZUUtjUWdVL3NNTk1Ua3BFemJZVHBVSzhmcklFTzdGcXRK?=
 =?utf-8?B?QW5LcEs5Qjcwd29uN3pPTVF3a0lQVlJoZm1QSU84emdHQnRhdzNHZ1dsZmcr?=
 =?utf-8?B?NkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7EF32A9037D74C4BA5203D1A318D7A02@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7328d78-2b67-47e2-8233-08daf368b437
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2023 00:13:45.1719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sR0I/kiWEaV5yLbcEAfd9gQSADWYp8own3pnyXHl0hHuBH9gerh9WL3le2/Sdc0dGVtHGFrhJ73gY8wu62sgIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7363
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAxLTEwIGF0IDA3OjI3IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMS8xMC8yMyAwMzoyOSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBGcmksIDIwMjMtMDEt
MDYgYXQgMTY6MzUgLTA4MDAsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiA+ID4gT24gMTIvOC8yMiAy
Mjo1MiwgS2FpIEh1YW5nIHdyb3RlOg0KPiAuLi4NCj4gPiA+ID4gSG93ZXZlciwgdGhpcyBpbXBs
ZW1lbnRhdGlvbiBkb2Vzbid0IGNvbnZlcnQgVERYIHByaXZhdGUgcGFnZXMgYmFjayB0bw0KPiA+
ID4gPiBub3JtYWwgaW4ga2V4ZWMoKSBiZWNhdXNlIG9mIGJlbG93IGNvbnNpZGVyYXRpb25zOg0K
PiA+ID4gPiANCj4gPiA+ID4gMSkgTmVpdGhlciB0aGUga2VybmVsIG5vciB0aGUgVERYIG1vZHVs
ZSBoYXMgZXhpc3RpbmcgaW5mcmFzdHJ1Y3R1cmUgdG8NCj4gPiA+ID4gICAgdHJhY2sgd2hpY2gg
cGFnZXMgYXJlIFREWCBwcml2YXRlIHBhZ2VzLg0KPiA+ID4gPiAyKSBUaGUgbnVtYmVyIG9mIFRE
WCBwcml2YXRlIHBhZ2VzIGNhbiBiZSBsYXJnZSwgYW5kIGNvbnZlcnRpbmcgYWxsIG9mDQo+ID4g
PiA+ICAgIHRoZW0gKGNhY2hlIGZsdXNoICsgdXNpbmcgTU9WRElSNjRCIHRvIGNsZWFyIHRoZSBw
YWdlKSBpbiBrZXhlYygpIGNhbg0KPiA+ID4gPiAgICBiZSB0aW1lIGNvbnN1bWluZy4NCj4gPiA+
ID4gMykgVGhlIG5ldyBrZXJuZWwgd2lsbCBhbG1vc3Qgb25seSB1c2UgS2V5SUQgMCB0byBhY2Nl
c3MgbWVtb3J5LiAgS2V5SUQNCj4gPiA+ID4gICAgMCBkb2Vzbid0IHN1cHBvcnQgaW50ZWdyaXR5
LWNoZWNrLCBzbyBpdCdzIE9LLg0KPiA+ID4gPiA0KSBUaGUga2VybmVsIGRvZXNuJ3QgKGFuZCBt
YXkgbmV2ZXIpIHN1cHBvcnQgTUtUTUUuICBJZiBhbnkgM3JkIHBhcnR5DQo+ID4gPiA+ICAgIGtl
cm5lbCBldmVyIHN1cHBvcnRzIE1LVE1FLCBpdCBjYW4vc2hvdWxkIGRvIE1PVkRJUjY0QiB0byBj
bGVhciB0aGUNCj4gPiA+ID4gICAgcGFnZSB3aXRoIHRoZSBuZXcgTUtUTUUgS2V5SUQgKGp1c3Qg
bGlrZSBURFggZG9lcykgYmVmb3JlIHVzaW5nIGl0Lg0KPiA+ID4gDQo+ID4gPiBZZWFoLCB3aHkg
YXJlIHdlIGdldHRpbmcgYWxsIHdvcmtlZCB1cCBhYm91dCBNS1RNRSB3aGVuIHRoZXJlIGlzIG5v
dA0KPiA+ID4gc3VwcG9ydD8NCj4gPiANCj4gPiBJIGFtIG5vdCBzdXJlIHdoZXRoZXIgd2UgbmVl
ZCB0byBjb25zaWRlciAzcmQgcGFydHkga2VybmVsIGNhc2U/DQo+IA0KPiBObywgd2UgZG9uJ3Qu
DQoNCkdvb2QgdG8ga25vdy4NCg0KPiANCj4gPiA+IFRoZSBvbmx5IHRoaW5nIHRoYXQgbWF0dGVy
cyBoZXJlIGlzIGRpcnR5IGNhY2hlbGluZSB3cml0ZWJhY2suICBUaGVyZQ0KPiA+ID4gYXJlIHR3
byB0aGluZ3MgdGhlIGtlcm5lbCBuZWVkcyB0byBkbyB0byBtaXRpZ2F0ZSB0aGF0Og0KPiA+ID4g
DQo+ID4gPiAgMS4gU3RvcCBhY2Nlc3NpbmcgVERYIHByaXZhdGUgbWVtb3J5IG1hcHBpbmdzDQo+
ID4gPiAgIDFhLiBTdG9wIG1ha2luZyBURFggbW9kdWxlIGNhbGxzICh1c2VzIGdsb2JhbCBwcml2
YXRlIEtleUlEKQ0KPiA+ID4gICAxYi4gU3RvcCBURFggZ3Vlc3RzIGZyb20gcnVubmluZyAodXNl
cyBwZXItZ3Vlc3QgS2V5SUQpDQo+ID4gPiAgMi4gRmx1c2ggYW55IGNhY2hlbGluZXMgZnJvbSBw
cmV2aW91cyBwcml2YXRlIEtleUlEIHdyaXRlcw0KPiA+ID4gDQo+ID4gPiBUaGVyZSBhcmUgYSBj
b3VwbGUgb2Ygd2F5cyB3ZSBjYW4gZG8gIzIuICBXZSBkbyAqTk9UKiBuZWVkIHRvIGNvbnZlcnQN
Cj4gPiA+ICpBTllUSElORyogYmFjayB0byBLZXlJRCAwLiAgUGFnZSBjb252ZXJzaW9uIGRvZXNu
J3QgZXZlbiBjb21lIGludG8gcGxheQ0KPiA+ID4gaW4gYW55IHdheSBhcyBmYXIgYXMgSSBjYW4g
dGVsbC4NCj4gPiANCj4gPiBNYXkgSSBhc2sgd2h5PyAgV2hlbiBJIHdhcyB3cml0aW5nIHRoaXMg
cGF0Y2ggSSB3YXMgbm90IHN1cmUgd2hldGhlciBrZXhlYygpDQo+ID4gc2hvdWxkIGdpdmUgdGhl
IG5ldyBrZXJuZWwgYSBjbGVhbiBzbGF0ZS4gIFNHWCBkcml2ZXIgZG9lc24ndCBFUkVNT1ZFIGFs
bCBFUEMNCj4gPiBkdXJpbmcga2V4ZWMoKSBidXQgZGVwZW5kcyBvbiB0aGUgbmV3IGtlcm5lbCB0
byBkbyB0aGF0IHRvbywgYnV0IEkgZG9uJ3Qga25vdw0KPiA+IHdoYXQncyB0aGUgZ2VuZXJhbCBn
dWlkZSBvZiBzdXBwb3J0aW5nIGtleGVjKCkuDQo+IA0KPiBUaGluayBhYm91dCBpdCB0aGlzIHdh
eToga2V4ZWMoKSBpcyBtb2RpZnlpbmcgcGVyc2lzdGVudCAoYWNyb3NzIGtleGVjKQ0KPiBzdGF0
ZSB0byBnZXQgdGhlIHN5c3RlbSByZWFkeSBmb3IgdGhlIG5ldyBrZXJuZWwuICBUaGUgY2FjaGVz
IGFyZQ0KPiBwZXJzaXN0ZW50IHN0YXRlLiAgRGV2aWNlcyBoYXZlIHBlcnNpc3RlbnQgc3RhdGUu
ICBNZW1vcnkgc3RhdGUgcGVyc2lzdHMNCj4gYWNyb3NzIGtleGVjKCkuICBUaGUgbWVtb3J5IGlu
dGVncml0eSBtZXRhZGF0YSBwZXJzaXN0cy4NCj4gDQo+IFdoYXQgcGVyc2lzdGVudCBzdGF0ZSBk
b2VzIGEgY29udmVyc2lvbiB0byBLZXlJRC0wIGFmZmVjdD8gIEl0IHJlc2V0cw0KPiB0aGUgaW50
ZWdyaXR5IG1ldGFkYXRhIGFuZCB0aGUgbWVtb3J5IGNvbnRlbnRzLg0KPiANCj4gS2V4ZWMgbGVh
dmVzIG1lbW9yeSBjb250ZW50cyBpbiBwbGFjZSBhbmQgZG9lc24ndCB6ZXJvIHRoZW0sIHNvIG1l
bW9yeQ0KPiBjb250ZW50cyBkb24ndCBtYXR0ZXIuICBUaGUgaW50ZWdyaXR5IG1ldGFkYXRhIGFs
c28gZG9lc24ndCBtYXR0ZXINCj4gYmVjYXVzZSB0aGUgbWVtb3J5IHdpbGwgYmUgdXNlZCBhcyBL
ZXlJRC0wIGFuZCB0aGF0IEtleUlEIGRvZXNuJ3QgcmVhZA0KPiB0aGUgaW50ZWdyaXR5IG1ldGFk
YXRhLg0KDQpSaWdodC4gIFNvIEkgZ3Vlc3Mgd2UganVzdCBuZWVkIHRvIGNhbGwgb3V0IHRoZSBu
ZXcga2VybmVsIHdpbGwgdXNlIG1lbW9yeSBhcw0KS2V5SUQtMD8NCg0KPiANCj4gV2hhdCBwcmFj
dGljYWwgaW1wYWN0IGRvZXMgYSBjb252ZXJzaW9uIGJhY2sgdG8gS2V5SUQtMCBzZXJ2ZT8gIFdo
YXQNCj4gcGVyc2lzdGVudCBzdGF0ZSBkb2VzIGl0IGFmZmVjdCB0aGF0IG1hdHRlcnM/DQoNCklm
IHdlIGNhbiBiZSBzdXJlIHRoZSBuZXcga2VybmVsIHdpbGwgdXNlIEtleUlELTAsIHRoZW4gd2Ug
ZG9uJ3QgbmVlZCB0bw0KY29udmVydC4gIEluIHRoZSAzKSBhbmQgNCkgaW4gbXkgY2hhbmdlbG9n
LCBJIGFjdHVhbGx5IHdhcyB0cnlpbmcgdG8gY29udmVyeQ0KdGhpcy4NCiAgDQo+IA0KPiA+ID4g
SSB0aGluayB5b3UncmUgYWxzbyBzYXlpbmcgdGhhdCBzaW5jZSBhbGwgQ1BVcyBnbyB0aHJvdWdo
IHRoaXMgcGF0aCBhbmQNCj4gPiA+IHRoZXJlIGlzIG5vIFREWCBhY3Rpdml0eSBiZXR3ZWVuIHRo
ZSBXQklOVkQgYW5kIHRoZSBuYXRpdmVfaGFsdCgpIHRoYXQNCj4gPiA+IDFhIGFuZCAxYiBiYXNp
Y2FsbHkgaGFwcGVuIGZvciAiZnJlZSIgd2l0aG91dCBuZWVkaW5nIHRvIGRvIHRoZW1lDQo+ID4g
PiBleHBsaWNpdGx5Lg0KPiA+IA0KPiA+IFllcy4gIFNob3VsZCB3ZSBtZW50aW9uIHRoaXMgcGFy
dCBpbiBjaGFuZ2Vsb2c/DQo+IA0KPiBUaGF0IHdvdWxkIGJlIG5pY2UuDQo+IA0KDQpXaWxsIGRv
Lg0K
