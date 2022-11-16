Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3FDC62BD05
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 13:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiKPMGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 07:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiKPMFw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 07:05:52 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF4DDFDB;
        Wed, 16 Nov 2022 03:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668599931; x=1700135931;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vo+2uB3/svAjQ/bT00PbWtzlLnMivf1rMd7FLNv0bHw=;
  b=LKPEWGmySVYM6/gWjXgCkOkaNB7QA8m/apv6aJbFRPhRb4I07aHsquoL
   MR4bwUnGS3eWXJ3tLn7iYDcU6rPKVt8zxML6phhO7rkNhwvNDepga6n/1
   2qWxUTsBSlBH71bIQ6tYmRLDB240fdjpRBK7cX7wsPo6wqE3dqpDY+mLS
   RsPKdndouR0mxSQFw6oVDmmmF2P5HhFyCaIcBRoA0plXexX7D5vsGRoUC
   iCn6ub+iBBM+8NXGRt4Jykp6wXTYUEGQla7MIKRc1nbJXqv8QbUiKU0hZ
   8aaFVG3R9RUJCAVU7UpiFNYG+ClJXcBcCcUqj9En9EJKMEo2SP+Qw2xXz
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="398813077"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="398813077"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 03:58:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="590166834"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="590166834"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 16 Nov 2022 03:58:50 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 03:58:49 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 03:58:49 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 16 Nov 2022 03:58:49 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 16 Nov 2022 03:58:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQDA3H46kTr37EbWjGldRI94iqGmH5I1fFsQ5heYihuFIIqyVofGRhmvCd+ijDMiuZQ5U+F0xJR7sgtPc91fJ/1I8EmiMW5HK8gnk3jjVqjFLFzANLn2kTMZ/UsD8ELC635wmhZGauLW/CBn4VYetusP2ZZPLPDj2fTebUNt/g3HOAYSS3xztQMP1CUYLIATo+XmC/cKsrTlsUlVmlVKQQMzu2c8qz+Dc+5xNRys2oRAAgNXJV9NknjDXszk/3vjrJq9wB/uIrBX6L5OMxi1SRqsx0AX67ikl9YjTjssOEKfvSmW1Y+guVs08D39tnjzHIOZtFPBshVozDpjKqtfUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vo+2uB3/svAjQ/bT00PbWtzlLnMivf1rMd7FLNv0bHw=;
 b=H5EIuhjR+VlNNIoQu+wHycZDd8/kDHt2Npu1a+L3/z1Eh2EBkyetd1E/2QPTI1C8/gCSqOYJsJ0nU26ioBlCxvpfYy+l49v1ijcR4qY8h+RapDxdztu+bK0F0hYmxfeWH+Ls+FCmUskKoSQnic7DpSxVuJqE+t8iWfmJgLSNZCik5Gmnkrk6SCw4F2SjiZ4CbLwaWOQ//uetp+AjpY8PAMCE0do5QS0v8eU7JogAapQ5Kx8B7uQ4F/HjhXf6AeCOwcJLuWriE/mK+FDHaEnMSFprYrtHudpZ7xkdhegwBqoTMsBqS7j7PZJg9Bc5tjczzPj+pF4BlIqHxOLp+hv3aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB6295.namprd11.prod.outlook.com (2603:10b6:8:95::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 11:58:47 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%9]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 11:58:47 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 049/108] KVM: x86/tdp_mmu: Support TDX private mapping
 for TDP MMU
Thread-Topic: [PATCH v10 049/108] KVM: x86/tdp_mmu: Support TDX private
 mapping for TDP MMU
Thread-Index: AQHY7Cg5t16eHRMELkeDYtKxfEn37q5BjT6A
Date:   Wed, 16 Nov 2022 11:58:46 +0000
Message-ID: <26a3508e4f57f6104abecd90192f12375fe04ecc.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <9d5595dfe1b5ab77bcb5650bc4d940dd977b0a32.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <9d5595dfe1b5ab77bcb5650bc4d940dd977b0a32.1667110240.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB6295:EE_
x-ms-office365-filtering-correlation-id: 1c0231e2-c76d-4731-0dc4-08dac7c9eae1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qJA/Vbw2PhrlxB6xJA7MqrAM5NMvZCBePUvdFsEv6EWClHQkmfOlhCRLmsHmyLG3W986cJnM6lZW32ciPeFtRqMr/Wxohc705J06QqUuLg49+iHpI7TMQ0DgPYlbtlnI1Bz3lBfPU2NrSV1kwP+yRG9ICMSMEcwV6qpcY8VbtkZXP5VcxlSUnKaOUcoulhIX9r4XjX6CCKLkz2Q7abkepfMseDhl6+nHHd7CEMs9frdaO1TRaWIIhyUmb2bZoId+/6P6olUR8F52kqdRY8ylf4qUWGH2frtjsQk9/qzyktgEEdJbL5sqaQ4Q47qHkSOhNxfng0Cv+vzcIygqlBsIP2NdK35yE89+H9z1i8SA9O/TVPclv6dMBODOhvVIc2rsSbl7VJlpRaq6bDNWVZYfigriLW1Fs7a/A4QoVHgKd8zSSn56mI4Wcvxca8Fx81X3o6yvdaQ0nASwQZ0ISF9D5c4AoFLXF3+tTTo8dCMEFfr/E+sjHsauKPzEOvdk+jGH3BQHZeNst9mZbSYwg2Xt+IH+SQVVw/1cylKK7s1rWeUV40JnOt+YW2fRHXXpTxPcJlV5S+AZe9pvGE4SL81AIcFrmfkNq3Y6LqNFfB1DYDHg6wu9ngHwnWrsBK1jvnCGCarUh2tk+SPXPRShbX4ys2Yz3JNtsmd7TTAEg0YRg86hlzXkojtpLFQo42C7jNrKgTEyFzYB7hbtc18yyduEh10yFFNFnxvx4Tt23unprLMjDY9qy/4+X2h2mz4GNPotuiRZ+jPAaf3ZKBkTIJQX3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199015)(2906002)(122000001)(82960400001)(38070700005)(38100700002)(8936002)(5660300002)(6486002)(186003)(86362001)(2616005)(66946007)(71200400001)(66556008)(36756003)(4326008)(8676002)(64756008)(91956017)(66476007)(66446008)(76116006)(41300700001)(110136005)(478600001)(6636002)(316002)(54906003)(6506007)(6512007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3AybFoydzRCYWpuNTJSallUdVoybVNWSDhjLzl1QjlZbGJ4R1drc1lVVEU3?=
 =?utf-8?B?YWdFaFFNSW1oUzFIb1BERC9TRmVWS1pBODJCbXFvL3RUdXZ4d01oSHRQbGU1?=
 =?utf-8?B?cW8rV0xBaExMV09aMGRZYlhycUgxTWRHQkNROHlzOVFJcy9lRXdnTU1hbHJL?=
 =?utf-8?B?dEppK3hpUWNTa2pXWUtnMDBENURmSm1YWkJSUzNtQkpiZHFmRTMyb1p0LzIy?=
 =?utf-8?B?b1puVTJHYVZHTjdFWmVmNGdaSjZUeWVhRmFENTlEM3lVcUNBWmpmRzd4QmxC?=
 =?utf-8?B?R1cyK2k0TFltK0QxTE02RWFiYVFIdnAxbVVKMkR2bGpPZXlkQjVTcVJYVUx3?=
 =?utf-8?B?QW5xOFdpVDNrYmxvdTFkVUx0Vnh2azlSYkJsb0tBalZLaGRzYlptQ29FKy9Y?=
 =?utf-8?B?MnBOeHlXQ1VOdUkyTWNhV242OHpKaTIrcUJ6Z2I2ZmtXa096d0o2cTBlVjdz?=
 =?utf-8?B?ai9Fd1dXQmNJWTYrWk1Za1BXRUhWeWhORGg1RytPbkpNdTRpQXJEZzdHWWFa?=
 =?utf-8?B?UjdnbWpWeGFDVE1NLy9zbGpEWVVOY0lTUVIvZlhLNlc4ODNzamd6RklWRnl4?=
 =?utf-8?B?c2QybTRaalAzeUtKWEU4cmgwaklOWWxzY0o1dWhJQ0I3eWlQajBvSnRBcW1E?=
 =?utf-8?B?M3MwWml1MDFxL1pQRUJWcGpTQUdxUmJrMFFPVGJpL3FNMDFsdGVBcUFpelZt?=
 =?utf-8?B?SnljaGhSVDZUZXJUcUhrV3YxU1dRc25NT1k1RUU4VE1jRkdmRXJtYkpPRXBv?=
 =?utf-8?B?VnN0cGF0ZVhrbnUyTnRUMGZpRTVsQnRXaU5NeXREUHIxNHRxS2pmSjEraUxM?=
 =?utf-8?B?MzJVanRZUk5kMEgrL2NqOGRFZkFjd29wa3lkYmdVaHBJWWZVWll4SUE5UTRC?=
 =?utf-8?B?dlN1QzNGZHkvU3QxaFZzdnBkY3R3amVGbHoreW5wK2lQanZhSmNCcWphdTNl?=
 =?utf-8?B?M2FmT3BpL3pCOU5GNklVRU9kVFQzT2VBdW1yVXoxemFkb0NWaGlVWjZkMVpr?=
 =?utf-8?B?WmgvQVoraHNTcHN6TnJGcUxneWkxVE1yNk01NHFsd1BXaHpGU3QzMkJhYnZs?=
 =?utf-8?B?Sm1TYWpVUDdOWDZPTGk4RGNzRktPTVRTRlpJYjBFakMvY0pzT25BR00vSFRG?=
 =?utf-8?B?QmZwekJvY3NoU1UvbHBCdk5qVGJjOVE0TWxMTzUzQ2hGdHBoN3YvdTR5UVhS?=
 =?utf-8?B?NDBKeTlIV1NzbkNZRUVTR2Y1TEllbklrVlVNQ25GYUpVNGtOM29ZU3oranNz?=
 =?utf-8?B?ZGNGNUFOREVLTUh0dEliZ09QRjEzeC84QzZFeXBmWUJ3YnRxVjVkc21nTEtt?=
 =?utf-8?B?NEMzWU5taVJyWURSeFJPUFp1SnhGMnZKRDlCa0RhRFY5aXNjVWpPSjh2aFd6?=
 =?utf-8?B?K29TS3g5Yk9QZ1pXQ3c4YjBhcUhDdnc1Tk9HTDBWVHNlcmN0RDZhWXlEcy9y?=
 =?utf-8?B?VGhJVmo2VE9oRXpkNDRhZ0pOZHFMaWhKWUdPcGxsb0lNY3Z5S2tYazdtcDFY?=
 =?utf-8?B?MzNTWE9rL1JNVzBKelZXeTFvNndkS0xQa2w3VHNlN0laS0czZ0NtZG9wUnEw?=
 =?utf-8?B?Vytrc3IxVXhTY2VTSVlnc1I0TVFvRG9iZFlJOXhaaG1VTStwL0plRjFHZmRp?=
 =?utf-8?B?Q0dQeTNPUXlIMVpiM3pyVHdEalRWMU54d2RFaDNBMzJLSnVOcTRML3FJelM2?=
 =?utf-8?B?MWZSWmc5RG51SHh5ZlVqaWMzNWdEcDlDdXFTSmV6aW9zTzRNL0JTK2FKZTdu?=
 =?utf-8?B?eTkvSlR5bHlFL0ppblpPV1ZqTUt1YnNJbmF2OFFNZGsyUndHdk5PRHYxNXdu?=
 =?utf-8?B?a3hhdDRHb0tOTk9ZR2dvSm9NbUlTdm81cmtEU0hzK29mcEFkVUttdjNmRlpP?=
 =?utf-8?B?aEp1RGI3SEpjblhYOXZBd21KeUJIUHpZcEtXT1Q3SkZER0hkS2lRZkpWT1l0?=
 =?utf-8?B?NFJaNjdsUXg0OTBKVFlDdDkrOFRidExsRGkwdGFhS2xscFlIb1g4Q3pKTGEx?=
 =?utf-8?B?VlIxeXBMd21Jcnl3YTFqM2xQSDNIa3k3Z05pK3NHYW0wVENmdklPUGlzWUpJ?=
 =?utf-8?B?TC95a2N3andTanJ1ZG9XQ2Z1VEVTMUIvZHI2RHJ5NmxZQmtjMWI4Ly9mS1Fx?=
 =?utf-8?B?dGRRRkhhUUNoSXVyYzN6b2wrUUVkcHNibDI0UzdBWThFWlZFSWphZ1hFZWd0?=
 =?utf-8?B?dHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <28DD679F70B947479FBED323F74B31BD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c0231e2-c76d-4731-0dc4-08dac7c9eae1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2022 11:58:46.9161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ct5KCU0+/LgD/drkCNGraf3rFv8b0E1MqJTzUKk3aQck4jm0/UKPVn8PUjxCGXBYjcIypXbWRDDd7SsnWyiGdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6295
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ICANCj4gK3N0YXRpYyBpbmxpbmUgaW50IGt2bV9hbGxvY19wcml2YXRlX3NwdF9mb3Jfc3Bs
aXQoc3RydWN0IGt2bV9tbXVfcGFnZSAqc3AsIGdmcF90IGdmcCkNCj4gK3sNCj4gKwlnZnAgJj0g
fl9fR0ZQX1pFUk87DQo+ICsJc3AtPnByaXZhdGVfc3B0ID0gKHZvaWQgKilfX2dldF9mcmVlX3Bh
Z2UoZ2ZwKTsNCj4gKwlpZiAoIXNwLT5wcml2YXRlX3NwdCkNCj4gKwkJcmV0dXJuIC1FTk9NRU07
DQo+ICsJcmV0dXJuIDA7DQo+ICt9DQo+ICsNCj4gDQpbLi4uXQ0KDQo+IEBAIC0xMjM4LDYgKzE0
MDgsMTIgQEAgaW50IGt2bV90ZHBfbW11X21hcChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVj
dCBrdm1fcGFnZV9mYXVsdCAqZmF1bHQpDQo+ICAJCSAgICBpc19sYXJnZV9wdGUoaXRlci5vbGRf
c3B0ZSkpIHsNCj4gIAkJCWlmICh0ZHBfbW11X3phcF9zcHRlX2F0b21pYyh2Y3B1LT5rdm0sICZp
dGVyKSkNCj4gIAkJCQlicmVhazsNCj4gKwkJCS8qDQo+ICsJCQkgKiBUT0RPOiBsYXJnZSBwYWdl
IHN1cHBvcnQuDQo+ICsJCQkgKiBEb2Vzbid0IHN1cHBvcnQgbGFyZ2UgcGFnZSBmb3IgVERYIG5v
dw0KPiArCQkJICovDQo+ICsJCQlLVk1fQlVHX09OKGlzX3ByaXZhdGVfc3B0ZXAoaXRlci5zcHRl
cCksIHZjcHUtPmt2bSk7DQo+ICsNCj4gIA0KDQpTbyBsYXJnZSBwYWdlIGlzIG5vdCBzdXBwb3J0
ZWQgZm9yIHByaXZhdGUgcGFnZSwgLi4uDQoNCj4gIAkJCS8qDQo+ICAJCQkgKiBUaGUgaXRlciBt
dXN0IGV4cGxpY2l0bHkgcmUtcmVhZCB0aGUgc3B0ZSBoZXJlDQo+IEBAIC0xNDgwLDYgKzE2NTYs
MTIgQEAgc3RhdGljIHN0cnVjdCBrdm1fbW11X3BhZ2UgKl9fdGRwX21tdV9hbGxvY19zcF9mb3Jf
c3BsaXQoZ2ZwX3QgZ2ZwLCB1bmlvbiBrdm1fbW0NCj4gIA0KPiAgCXNwLT5yb2xlID0gcm9sZTsN
Cj4gIAlzcC0+c3B0ID0gKHZvaWQgKilfX2dldF9mcmVlX3BhZ2UoZ2ZwKTsNCj4gKwlpZiAoa3Zt
X21tdV9wYWdlX3JvbGVfaXNfcHJpdmF0ZShyb2xlKSkgew0KPiArCQlpZiAoa3ZtX2FsbG9jX3By
aXZhdGVfc3B0X2Zvcl9zcGxpdChzcCwgZ2ZwKSkgew0KPiArCQkJZnJlZV9wYWdlKCh1bnNpZ25l
ZCBsb25nKXNwLT5zcHQpOw0KPiArCQkJc3AtPnNwdCA9IE5VTEw7DQo+ICsJCX0NCj4gKwl9DQoN
Ci4uLiB0aGVuIEkgZG9uJ3QgdGhpbmsgZWFnZXIgc3BsaXR0aW5nIGNvdWxkIGhhcHBlbiBmb3Ig
cHJpdmF0ZSBtYXBwaW5nPw0KIA0KSWYgc28sIHNob3VsZCB3ZSBqdXN0IEtWTV9CVUdfT04oKSBp
ZiByb2xlIGlzIHByaXZhdGU/DQoNCg==
