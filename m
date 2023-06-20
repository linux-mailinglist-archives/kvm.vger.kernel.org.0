Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3CB973696F
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 12:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbjFTKhZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 06:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjFTKhX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 06:37:23 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB84A0;
        Tue, 20 Jun 2023 03:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687257442; x=1718793442;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZQk5TLGR+mwHeNaJ1jjuTN63DZreLkdjbBbPrPzb7d8=;
  b=Cofh0uvwU5uv1vYl1qB8yYMqGIopYNZwnqDt3R2lm559T2a1VULtoclD
   Xuks+Z3Xqcv0/CjS9000Iz25xEUxKzH1xAdJ5DFLulUy8v79PGnptCP9A
   6wq3QDXxowwQSZf07hDVN9Q/U1PsAw6FfVTiBxQJudzn4PwlBVJQm8BOG
   Uhxuy/xnymgk9505Rn5FDcbN8otZEQz3UN0SUKGBZeVdFqHH0ElliVY8B
   vrEpkoos5pmWMXT7dn5Scd1v0wIn/aUnIBvDGS4QVdoVxpasd0saUWhJX
   lAW5apjk0C+PSPwMbLiT7Uyynd0CuNiND2omEot+GjwhMEtQrnAda1QWn
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="363247094"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="363247094"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 03:37:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="960734420"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="960734420"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 20 Jun 2023 03:37:21 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 03:37:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 20 Jun 2023 03:37:20 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 20 Jun 2023 03:37:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lECYmQ8K51uwFqVehGYaVPHfgoWcZVEJQOW1deCc15MFZVSCbI8Tm47SfKoOP0pGmyjmJfa4fFB9mrLlNX9focaUujpkL+TK8acwytC5bZMXqE2EXwfE/TzpI3hO/BRF3tjuAAlDedkzLm4NoEVj+HbOslspIEF8FHKz8TnzvbjBrEM5IvzsC8kpY/1QsK4Jjez6I6bkyToOmcWK2g+YGCG/2jYRlLQwOADfg1SvGtYYibVMIvuEMYZlX0JTOI4nSO/i/D/svXKv1OEXKG4kYxgyYRDerPy6DXUGWF2VQPtDONixtlaTFqXL206SCy7GRMJxnWt6nF9mHqm0jWkNLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZQk5TLGR+mwHeNaJ1jjuTN63DZreLkdjbBbPrPzb7d8=;
 b=ORauC5PGwPRYpqYG9dAMuP+1vz4t95aBjSDTnSsfLUdKelTXIarbpibdbcjgSBZHoxwJKIPfxANh23j2Jt2NK6VeNh9hQoEwg+uyQ6WFpUVTyk5ToH9SlBiXp2OYKPsfimZxxT3d9JTQerxuiFYKaQOZo8XKh/OPqDqkanlO4K4UN+fE9cslT/XQ0nu5okbsgr6gE9SMuD9FAfnpw7eGGBZqUdii97toGHLhFTOqmtpjI37dFziIzqq6IJ1VlvNEXYwZCIDQmSW/c5kDc+CgIhYdUyDYDwUyBVMLbWK1sVrx4ChqZWdAIB/zlcB33AKzaM6GlQWCB1Zx3wcZxQk0hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6650.namprd11.prod.outlook.com (2603:10b6:510:1a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Tue, 20 Jun
 2023 10:37:17 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 10:37:17 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
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
Subject: Re: [PATCH v11 05/20] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Topic: [PATCH v11 05/20] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Index: AQHZlu+qoC4MN/glPkShb4EFlRb+MK+SK9IAgAFsqQA=
Date:   Tue, 20 Jun 2023 10:37:16 +0000
Message-ID: <8e7d6b83347688bb013d7ebb660d0a74a1949d52.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <ec640452a4385d61bec97f8b761ed1ff38898504.1685887183.git.kai.huang@intel.com>
         <759e3af5-6aec-7e50-c432-c5e0a0c3cf36@redhat.com>
In-Reply-To: <759e3af5-6aec-7e50-c432-c5e0a0c3cf36@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6650:EE_
x-ms-office365-filtering-correlation-id: 6719d163-a47a-469d-6363-08db717a516c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E2Iy5T4sfj9KQ1jq8S+kp1NjTgM6MiqOgg6ZunekGqTyDDs99qIRPOHGp6OXTvNKIbzOH8SLlJYXwYa17ZESjlHK+4HhyKhO8vkwpKW71fco7DELqYcwBFavSLIulllUqOnJN+FfsrkGRaViZePQvXELgxYwsn5qN2Vc1yuL8TgOBYc3Eujt96MbsHE/5INzEpCJNbSDLhEi45BtK5aAZrFU7HN8ETlis4KxTjuiN3knd6D9hmk+5Q5xwB5jDDHSm2wU8gJ2ibyZqyJ1/QPnQar3BjwHOmC/58maqovD3p/cmqHFOXHim855liJdW4Yayf5eND5XbLm5sHVXa0/nVhEyuzmncewwj56TZFzpuMY0bLi3V1QCpt5YISWhs8gGWKoUBWMOYDmZZ7ODMVAeJNrtrbtA8sL377kB0UfLizwbTPa6WZZkRcngM3bg/qfArr66afoXkxmfcauI1GoBE/mD0LgDeo/Gj57bPl4fPCo+thgtzmvYcLzMdwFG/gddYdgOl35MvpjSm4irCs2UEJ7kr7pjLoq5K069bu4DAkCdnXycZ7PaLa6lJkX8zGJfQZK1qHGsHg14w0aNr9YxqWnBBw4njviQoWwVj6QEuSPZ4Afett7xe6edBdTTfzrI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(366004)(39860400002)(376002)(451199021)(71200400001)(6486002)(478600001)(83380400001)(186003)(6512007)(6506007)(53546011)(26005)(2616005)(36756003)(38100700002)(38070700005)(86362001)(122000001)(82960400001)(8676002)(5660300002)(8936002)(316002)(2906002)(41300700001)(91956017)(4326008)(76116006)(64756008)(66446008)(66476007)(66556008)(66946007)(7416002)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NjFxWncyU2NTbFdzRDVUZmZxbjBhaGRRZjRNUWQrL1N6bE9xblRPeWVZS0RZ?=
 =?utf-8?B?UEtzcmtMakpxSXRoTGZkUndqTytYdGFnRFhLWFBTWFZrVzBKWGg0ZUpGckRD?=
 =?utf-8?B?NTAzdTZCV2dXUWpDSUVNSEhxdWtIbmp1NGt2TXpMYldIbTVtMUpqaUNQZzZ2?=
 =?utf-8?B?d3ZlTHEyMlhvYWhxTkx2WGNET0R0N3FHZjd4Q1JIN3A0cDVtM2tIeHJKdkZj?=
 =?utf-8?B?MTNyYnNlN3ZsbnB1ZStRcEIySVd0UVRWeDE5MEFVNWljcjFiajVmRyttUjR2?=
 =?utf-8?B?bFFsMUU1OUtFWjU5RmF6WE50dWxOOG9DNEs1dnZWSjUzU1F4dkZGQjN5T1BK?=
 =?utf-8?B?MGcvNCtDN1liclYwZ2dUU0lPWnpDVHM3cmw5dktVbzAxTU5SSkp4cEk3YTQx?=
 =?utf-8?B?RkxuRkpvakFkY1hSNHcwVEVPRHFaNUF6ckl1ZXd3K0s2MmZRTEE1SFcvVm93?=
 =?utf-8?B?aElnSkdsc3c2MHlaODF4Q3QrOXlWTmFucXAybE9waHNBYlZXQ2tYbzlaQXlS?=
 =?utf-8?B?NkxVYjZLSWdBeDZhb3V6MysyUlJIZ2tudmR1TEFKaWlNdHljMUp0RWd5bnpL?=
 =?utf-8?B?ajVUM21vQTFVbzFsMUhyVGl3elQrb0NWTXdOTTVrcDNRUFcyenQxRS9pdnUz?=
 =?utf-8?B?REFZaStsN3NLYjJBMVQ1WHpVcFdIN3ZmcVI0cFNEdmE0OGZmVTNLd3puY0Vs?=
 =?utf-8?B?OTRBRVFKWVFuNkQ3YXNQa3g2eW5NQm93YVl3ZlhzYTFMM1NKQVVERjE1VW9m?=
 =?utf-8?B?bURHWXVyNndqZUk1SUNZbWdsZTA1dHZlWVNSdHhSMFI4NUFjRUlwb29WZ2hI?=
 =?utf-8?B?MFhXdk1GU3NFR3VKQzF1dGRYVmdjUG1oa2hlL3pPZ1kzTldxako1NlB5aTBQ?=
 =?utf-8?B?aHYrRTBMc3YrOGdXY0FuNGRnVmxOanBEeXloK2ZzZFNKQi9wZVA3ekpXdndS?=
 =?utf-8?B?TCtYNHBRbzVpeVdUZlJyM2dwL29pNmZFaUFqWFBDWTNDa2VXNjdnWnJIelh3?=
 =?utf-8?B?QmFsSWorUHdVK0RUV1djU1dIL0s3b21tK0ladWtOclNxOWRtT0VrV3Z2WHo2?=
 =?utf-8?B?eG1GaWh6UmFsV1pHWllTOFpMcHovcEVyT1IyS2owRm1vMm1oTGx0Z1ZOYWM1?=
 =?utf-8?B?T1lrT1pLTkhyUHkxSy81ZmwwZ1g2aUhVWDVXLzFXUDNhU3l6Mnk0SU4xZlFW?=
 =?utf-8?B?R29HdTRoSmw5OG1aVUVkTjU2QWtqaHVieWgxSGNXNWpOTnpyemIwaEozbWRn?=
 =?utf-8?B?TmNmMHJIMVhwSVJsV1g3ZENGMTNWMFNQWHNXRy8vZUE1Y0dFVWt5OTVIUm9I?=
 =?utf-8?B?RUVmQ1VTdDNhdlVkMk1KdXVualJKcWZxRWpCZzNQMnJBbXp2UlhmRE44VHlS?=
 =?utf-8?B?OFZBVDE3bS9WaTdXQ1NGbTV0aUoxc3EvZnhHSEVMakxHVWxNNXp4bm9GUDVY?=
 =?utf-8?B?Nms5RDkwOFI4SGxhbmFGRTgrTkc0MERMT2R6aVNHVWx4UlZ2bXpWTDRzL0Zv?=
 =?utf-8?B?T2lFVGJjNXJrYnlZZVRWa2pyRjRWdkQ2YXVhSEZKS25kUUxNVkh2dFJQUnNZ?=
 =?utf-8?B?SFBhbEp0ZXNnMmRpSnJmTU9RYzR0a0pYeWRUT1dBTnZVYUNnc0MraEl1Q1Qv?=
 =?utf-8?B?Sml6T3ZMMTNYb3U0SlFCaGt6cXpHQk1GemZ3NjZVV3ZUM3RBRy9JZTJsbHls?=
 =?utf-8?B?OUk0OFNETEhucVRFZmhQRjJMYysyOFhKc0twcWR6Y1FrTDQybXhwMm5mSjdt?=
 =?utf-8?B?Njl1NnEzZ0NzZjgxbnJaUWx4RXBYT3BUeTh1QzhkU1ZYaUFOTXFaSFUvRmFs?=
 =?utf-8?B?TWxiQ2puNlBtdXd4V0gxZTBZeU9FYkNaNzRVWHVNeHVrcHhONThqenlFSlBB?=
 =?utf-8?B?WU1ZZUZwRVArZWpscXpNWXo3dmFiUit6WThMWE9QUm1UaUhwT0puUnhzWS9R?=
 =?utf-8?B?dzF6SmErU2h0Tk54bDNyZzh1ZHJrSHd1K1h6Q3VOS3BMMnVUY2NMN2F0dXpN?=
 =?utf-8?B?cW9zSFBxT0RVcG5hQTlLOEhYUFBpaDlaQzc0QmIvbW5NSDRzRXljcUcvY0dX?=
 =?utf-8?B?Z1pOSGdJdnBjT3p2alhhanBtRnZzcjJndDdWaUMvY3h3eHE4bjUxRXp1cENk?=
 =?utf-8?B?VGJSM0FibW9RQS9idWp0Y2E0Tk1hMUgyNlcxUnNwRTFNK1dHLy9WRmNhRXpr?=
 =?utf-8?B?dFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <97E3E2825B299C4BB6C51125114B6F48@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6719d163-a47a-469d-6363-08db717a516c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2023 10:37:16.8816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UEZ5kzfVWTwvO3S+f2CooiXDlAoygPtMhIqoRq6ApcQ/6Zszg/6f9v0xunh7zpc/QmsaMJlEmhJmRjJZxPEIAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6650
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

T24gTW9uLCAyMDIzLTA2LTE5IGF0IDE0OjUyICswMjAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90
ZToNCj4gT24gMDQuMDYuMjMgMTY6MjcsIEthaSBIdWFuZyB3cm90ZToNCj4gPiBURFggaW50cm9k
dWNlcyBhIG5ldyBDUFUgbW9kZTogU2VjdXJlIEFyYml0cmF0aW9uIE1vZGUgKFNFQU0pLiAgVGhp
cw0KPiA+IG1vZGUgcnVucyBvbmx5IHRoZSBURFggbW9kdWxlIGl0c2VsZiBvciBvdGhlciBjb2Rl
IHRvIGxvYWQgdGhlIFREWA0KPiA+IG1vZHVsZS4NCj4gPiANCj4gPiBUaGUgaG9zdCBrZXJuZWwg
Y29tbXVuaWNhdGVzIHdpdGggU0VBTSBzb2Z0d2FyZSB2aWEgYSBuZXcgU0VBTUNBTEwNCj4gPiBp
bnN0cnVjdGlvbi4gIFRoaXMgaXMgY29uY2VwdHVhbGx5IHNpbWlsYXIgdG8gYSBndWVzdC0+aG9z
dCBoeXBlcmNhbGwsDQo+ID4gZXhjZXB0IGl0IGlzIG1hZGUgZnJvbSB0aGUgaG9zdCB0byBTRUFN
IHNvZnR3YXJlIGluc3RlYWQuICBUaGUgVERYDQo+ID4gbW9kdWxlIGVzdGFibGlzaGVzIGEgbmV3
IFNFQU1DQUxMIEFCSSB3aGljaCBhbGxvd3MgdGhlIGhvc3QgdG8NCj4gPiBpbml0aWFsaXplIHRo
ZSBtb2R1bGUgYW5kIHRvIG1hbmFnZSBWTXMuDQo+ID4gDQo+ID4gQWRkIGluZnJhc3RydWN0dXJl
IHRvIG1ha2UgU0VBTUNBTExzLiAgVGhlIFNFQU1DQUxMIEFCSSBpcyB2ZXJ5IHNpbWlsYXINCj4g
PiB0byB0aGUgVERDQUxMIEFCSSBhbmQgbGV2ZXJhZ2VzIG11Y2ggVERDQUxMIGluZnJhc3RydWN0
dXJlLg0KPiA+IA0KPiA+IFNFQU1DQUxMIGluc3RydWN0aW9uIGNhdXNlcyAjR1Agd2hlbiBURFgg
aXNuJ3QgQklPUyBlbmFibGVkLCBhbmQgI1VEDQo+ID4gd2hlbiBDUFUgaXMgbm90IGluIFZNWCBv
cGVyYXRpb24uICBDdXJyZW50bHksIG9ubHkgS1ZNIGNvZGUgbW9ja3Mgd2l0aA0KPiA+IFZNWCBl
bmFibGluZywgYW5kIEtWTSBpcyB0aGUgb25seSB1c2VyIG9mIFREWC4gIFRoaXMgaW1wbGVtZW50
YXRpb24NCj4gPiBjaG9vc2VzIHRvIG1ha2UgS1ZNIGl0c2VsZiByZXNwb25zaWJsZSBmb3IgZW5h
YmxpbmcgVk1YIGJlZm9yZSB1c2luZw0KPiA+IFREWCBhbmQgbGV0IHRoZSByZXN0IG9mIHRoZSBr
ZXJuZWwgc3RheSBibGlzc2Z1bGx5IHVuYXdhcmUgb2YgVk1YLg0KPiA+IA0KPiA+IFRoZSBjdXJy
ZW50IFREWF9NT0RVTEVfQ0FMTCBtYWNybyBoYW5kbGVzIG5laXRoZXIgI0dQIG5vciAjVUQuICBU
aGUNCj4gPiBrZXJuZWwgd291bGQgaGl0IE9vcHMgaWYgU0VBTUNBTEwgd2VyZSBtaXN0YWtlbmx5
IG1hZGUgdy9vIGVuYWJsaW5nIFZNWA0KPiA+IGZpcnN0LiAgQXJjaGl0ZWN0dXJhbGx5LCB0aGVy
ZSBpcyBubyBDUFUgZmxhZyB0byBjaGVjayB3aGV0aGVyIHRoZSBDUFUNCj4gPiBpcyBpbiBWTVgg
b3BlcmF0aW9uLiAgQWxzbywgaWYgYSBCSU9TIHdlcmUgYnVnZ3ksIGl0IGNvdWxkIHN0aWxsIHJl
cG9ydA0KPiA+IHZhbGlkIFREWCBwcml2YXRlIEtleUlEcyB3aGVuIFREWCBhY3R1YWxseSBjb3Vs
ZG4ndCBiZSBlbmFibGVkLg0KPiA+IA0KPiA+IEV4dGVuZCB0aGUgVERYX01PRFVMRV9DQUxMIG1h
Y3JvIHRvIGhhbmRsZSAjVUQgYW5kICNHUCB0byByZXR1cm4gZXJyb3INCj4gPiBjb2Rlcy4gIElu
dHJvZHVjZSB0d28gbmV3IFREWCBlcnJvciBjb2RlcyBmb3IgdGhlbSByZXNwZWN0aXZlbHkgc28g
dGhlDQo+ID4gY2FsbGVyIGNhbiBkaXN0aW5ndWlzaC4NCj4gPiANCj4gPiBBbHNvIGFkZCBhIHdy
YXBwZXIgZnVuY3Rpb24gb2YgU0VBTUNBTEwgdG8gY29udmVydCBTRUFNQ0FMTCBlcnJvciBjb2Rl
DQo+ID4gdG8gdGhlIGtlcm5lbCBlcnJvciBjb2RlLCBhbmQgcHJpbnQgb3V0IFNFQU1DQUxMIGVy
cm9yIGNvZGUgdG8gaGVscCB0aGUNCj4gPiB1c2VyIHRvIHVuZGVyc3RhbmQgd2hhdCB3ZW50IHdy
b25nLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVs
LmNvbT4NCj4gPiAtLS0NCj4gDQo+IEkgYWdyZWUgd2l0aCBEYXZlIHRoYXQgYSBidWdneSBiaW9z
IGlzIG5vdCBhIGdvb2QgbW90aXZhdGlvbiBmb3IgdGhpcyANCj4gcGF0Y2guIFRoZSByZWFsIHN0
cmVuZ3RoIG9mIHRoaXMgaW5mcmFzdHJ1Y3R1cmUgSU1ITyBpcyBjZW50cmFsIGVycm9yIA0KPiBo
YW5kbGluZyBhbmQgZXhwcmVzc2l2ZSBlcnJvciBtZXNzYWdlcy4gTWF5YmUgaXQgbWFrZXMgc29t
ZSBjb3JuZXIgY2FzZXMgDQo+IChyZWJvb3QgLWYpIGVhc2llciB0byBoYW5kbGUuIFRoYXQgd291
bGQgbWFrZSBhIGJldHRlciBqdXN0aWZpY2F0aW9uIA0KPiB0aGFuIGJ1Z2d5IGJpb3MgLS0gYW5k
IHNob3VsZCBiZSBzcGVsbGVkIG91dCBpbiB0aGUgcGF0Y2ggZGVzY3JpcHRpb24uDQoNCkFncmVl
ZC4gIFdpbGwgZG8uICBUaGFua3MhDQoNCj4gDQo+IFsuLi5dDQo+IA0KPiANCj4gPiArLyoNCj4g
PiArICogV3JhcHBlciBvZiBfX3NlYW1jYWxsKCkgdG8gY29udmVydCBTRUFNQ0FMTCBsZWFmIGZ1
bmN0aW9uIGVycm9yIGNvZGUNCj4gPiArICogdG8ga2VybmVsIGVycm9yIGNvZGUuICBAc2VhbWNh
bGxfcmV0IGFuZCBAb3V0IGNvbnRhaW4gdGhlIFNFQU1DQUxMDQo+ID4gKyAqIGxlYWYgZnVuY3Rp
b24gcmV0dXJuIGNvZGUgYW5kIHRoZSBhZGRpdGlvbmFsIG91dHB1dCByZXNwZWN0aXZlbHkgaWYN
Cj4gPiArICogbm90IE5VTEwuDQo+ID4gKyAqLw0KPiA+ICtzdGF0aWMgaW50IF9fYWx3YXlzX3Vu
dXNlZCBzZWFtY2FsbCh1NjQgZm4sIHU2NCByY3gsIHU2NCByZHgsIHU2NCByOCwgdTY0IHI5LA0K
PiA+ICsJCQkJICAgIHU2NCAqc2VhbWNhbGxfcmV0LA0KPiA+ICsJCQkJICAgIHN0cnVjdCB0ZHhf
bW9kdWxlX291dHB1dCAqb3V0KQ0KPiA+ICt7DQo+ID4gKwlpbnQgY3B1LCByZXQgPSAwOw0KPiA+
ICsJdTY0IHNyZXQ7DQo+ID4gKw0KPiA+ICsJLyogTmVlZCBhIHN0YWJsZSBDUFUgaWQgZm9yIHBy
aW50aW5nIGVycm9yIG1lc3NhZ2UgKi8NCj4gPiArCWNwdSA9IGdldF9jcHUoKTsNCj4gPiArDQo+
ID4gKwlzcmV0ID0gX19zZWFtY2FsbChmbiwgcmN4LCByZHgsIHI4LCByOSwgb3V0KTsNCj4gPiAr
DQo+IA0KPiANCj4gV2h5IG5vdA0KPiANCj4gY3B1ID0gZ2V0X2NwdSgpOw0KPiBzcmV0ID0gX19z
ZWFtY2FsbChmbiwgcmN4LCByZHgsIHI4LCByOSwgb3V0KTsNCj4gcHV0X2NwdSgpOw0KDQpIbW0u
LiBJIHRoaW5rIHRoaXMgaXMgYWxzbyBPSy4gVGhlIHdvcnN0IGNhc2UgaXMgdGhlIGVycm9yIG1l
c3NhZ2Ugd2lsbCBiZQ0KcHJpbnRlZCBvbiByZW1vdGUgY3B1IGJ1dCB0aGUgbWVzc2FnZSBzdGls
bCBoYXZlIHRoZSBjb3JyZWN0ICJjcHUgaWQiIHByaW50ZWQuDQoNCkknbGwgY2hhbmdlIHRvIGFi
b3ZlLg0KDQo+IA0KPiANCj4gPiArCS8qIFNhdmUgU0VBTUNBTEwgcmV0dXJuIGNvZGUgaWYgdGhl
IGNhbGxlciB3YW50cyBpdCAqLw0KPiA+ICsJaWYgKHNlYW1jYWxsX3JldCkNCj4gPiArCQkqc2Vh
bWNhbGxfcmV0ID0gc3JldDsNCj4gPiArDQo+ID4gKwkvKiBTRUFNQ0FMTCB3YXMgc3VjY2Vzc2Z1
bCAqLw0KPiA+ICsJaWYgKCFzcmV0KQ0KPiA+ICsJCWdvdG8gb3V0Ow0KPiANCj4gV2h5IG5vdCBt
b3ZlIHRoYXQgaW50byB0aGUgc3dpdGNoIHN0YXRlbWVudCBiZWxvdyB0byBhdm9pZCB0aCBnb3Rv
Pw0KPiBJZiB5b3UgZG8gdGhlIHB1dF9jcHUoKSBlYXJseSwgeW91IGNhbiBhdm9pZCAicmV0IiBh
cyB3ZWxsLg0KDQpZZWFoIGNhbiBkby4NCg0KPiANCj4gc3dpdGNoIChzcmV0KSB7DQo+IGNhc2Ug
MDoNCj4gCS8qIFNFQU1DQUxMIHdhcyBzdWNjZXNzZnVsICovDQo+IAlyZXR1cm4gMDsNCj4gY2Fz
ZSBURFhfU0VBTUNBTExfR1A6DQo+IAlwcl9lcnJfb25jZSgiW2Zpcm13YXJlIGJ1Z106IFREWCBp
cyBub3QgZW5hYmxlZCBieSBCSU9TLlxuIik7DQo+IAlyZXR1cm4gLUVOT0RFVjsNCj4gLi4uDQo+
IH0NCj4gDQoNClsuLi5dDQoNCg0KPiA+ICsJLyoNCj4gPiArCSAqIFNFQU1DQUxMIGNhdXNlZCAj
R1Agb3IgI1VELiAgQnkgcmVhY2hpbmcgaGVyZSAlZWF4IGNvbnRhaW5zDQo+ID4gKwkgKiB0aGUg
dHJhcCBudW1iZXIuICBDb252ZXJ0IHRoZSB0cmFwIG51bWJlciB0byB0aGUgVERYIGVycm9yDQo+
ID4gKwkgKiBjb2RlIGJ5IHNldHRpbmcgVERYX1NXX0VSUk9SIHRvIHRoZSBoaWdoIDMyLWJpdHMg
b2YgJXJheC4NCj4gPiArCSAqDQo+ID4gKwkgKiBOb3RlIGNhbm5vdCBPUiBURFhfU1dfRVJST1Ig
ZGlyZWN0bHkgdG8gJXJheCBhcyBPUiBpbnN0cnVjdGlvbg0KPiA+ICsJICogb25seSBhY2NlcHRz
IDMyLWJpdCBpbW1lZGlhdGUgYXQgbW9zdC4NCj4gDQo+IE5vdCBzdXJlIGlmIHRoYXQgY29tbWVu
dCBpcyByZWFsbHkgaGVscGZ1bCBoZXJlLiBJdCdzIGEgY29tbW9uIHBhdHRlcm4gDQo+IGZvciBs
YXJnZSBpbW1lZGlhdGVzLCBubz8NCg0KSSBhbSBub3Qgc3VyZS4gIEkgZ3Vlc3MgSSBhbSBub3Qg
ZXhwZXJ0IG9mIHg4NiBhc3NlbWJseSBidXQgb25seSBjYXN1YWwgd3JpdGVyLg0KDQpIaSBEYXZl
LCBLaXJpbGwsDQoNCkFyZSB5b3UgT0sgdG8gcmVtb3ZlIGl0Pw0KDQo+IA0KPiA+ICsJICovDQo+
ID4gKwltb3YgJFREWF9TV19FUlJPUiwgJXIxMg0KPiA+ICsJb3JxICVyMTIsICVyYXgNCj4gPiAg
IA0KPiA+ICsJX0FTTV9FWFRBQkxFX0ZBVUxUKDFiLCAyYikNCj4gPiArLkxzZWFtY2FsbF9vdXQ6
DQo+ID4gICAJLmVsc2UNCj4gPiAgIAl0ZGNhbGwNCj4gPiAgIAkuZW5kaWYNCj4gDQoNCg==
