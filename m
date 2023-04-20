Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDB66E9149
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 12:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbjDTK6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 06:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235094AbjDTK5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 06:57:53 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04ADCA5EF;
        Thu, 20 Apr 2023 03:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681988127; x=1713524127;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gwNWdrtXr8D+nY+gGyBG4sdysKuaStQcU+yVgnkAQRQ=;
  b=M+8qhkFIyJV+yhhwTv1iwNNkqTvC135GIKaxEyfCVZxRcrXY5XI7KSFB
   1v9nnMQhCZHVyqq68dz4eyUSdiUb+r3QivSuFegCMI0iSa/yEmiEm4Plu
   EbkzDroAptfIG2WhN23WemfgpAJ5sY5YmMs4Y0ZDUIuFx/Mj4rjYdEQLm
   xIAtfxGyWDX15xNre27KH/IEd5y6JsyuD2b5YlfPFCwCdrMU785eNyrdb
   N8iCH/lCtRwd8D/VxCF4g8gYDmyGMFPURoladljfJmXhmvNZRuKx/daP+
   imsA27qzyV1wGRvaNWQfOwdr/yJo8CC5xOalpESR9DzrmUlJ1Y13EtJ9p
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="408614993"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="408614993"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 03:55:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="722331831"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="722331831"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 20 Apr 2023 03:55:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 03:55:26 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 03:55:26 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 03:55:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gTAvwg3YlAhHr4srB5pJW32pSUNe2nMe+FDUvty6cqY9aLHR/xcmU120pVSwN7NrmfpD3nvdacgRbcJwky5PoN3LnA/3XDmV32dxYtKyLXFc/W+cXHNU+s64MEtt4E2O4ZwQ7f/qg36y+RIR2SoRy+mYUv55AVeBM88/A03UttoP7cbROVGtL6d4jLOv2rm6WqN0rQ0j9xn8R/RIczO3LZIMq+dlWtRCYwq1pxhUvvzgyE6JGOIeqL8b+k/ya0dio/dgUEzG4bnMVjdzOYznivDs9gqRgeSCqF3WQQxDCdOjOcb0JFQb+9y4YHPsL0M3lbQW3DYgcUCKihBm66EH5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gwNWdrtXr8D+nY+gGyBG4sdysKuaStQcU+yVgnkAQRQ=;
 b=QY1aV8hNlTB47qK2HEfFYsA8OVwXPEDCPq79EiLUMA6zhyR5O2k+0A1SbMDNa0hPkhomhOg+NTjaaOEkIpJbl4EIPpsrBMeaK0d/LPUfpf0z+QbD+2Wi+/T/WaKNs0m5/n7oUrExJ0yXyV4ISSgUm6pRaSMluhwWgULCf154gIoodYe1YbisJd28tlPACa6Ram7ZGkBBLX0TjqFfxaIF6RWdoGYp6qy0dYYt/8FXtgg4jSfXnDMXw7MhOsOoHjs3+KilYVJbsNQtX0LZpQecWsTcN9ycm+/w5pm+2KR91CnWh2MfT+7usDAvsoHOm1m5LBtv0IWQR8J6lDJvST5rRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB5502.namprd11.prod.outlook.com (2603:10b6:5:39e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 10:55:23 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5%3]) with mapi id 15.20.6298.030; Thu, 20 Apr 2023
 10:55:23 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] KVM: VMX: Don't rely _only_ on CPUID to enforce XCR0
 restrictions for ECREATE
Thread-Topic: [PATCH 1/3] KVM: VMX: Don't rely _only_ on CPUID to enforce XCR0
 restrictions for ECREATE
Thread-Index: AQHZZ1neYlqkq4ONyEOC8NUatF9pta8cityAgAD5CACAABXYgIABDueAgAjXVQCADJ6GAA==
Date:   Thu, 20 Apr 2023 10:55:22 +0000
Message-ID: <f9eac75ac315070db68a76454e9430ed11398ccf.camel@intel.com>
References: <20230405005911.423699-1-seanjc@google.com>
         <20230405005911.423699-2-seanjc@google.com>
         <626179c54707297736158da89ee634705cd6d62f.camel@intel.com>
         <ZC4j37H2+2945xxb@google.com>
         <2cedc5ca5e1d126a0abf3b651c6fef1a8970fcfd.camel@intel.com>
         <ZC8J2J9Js7Z99k6/@google.com>
         <6f7611300b3d2dfacd1399ccf4a2fdc1dd50b20f.camel@intel.com>
In-Reply-To: <6f7611300b3d2dfacd1399ccf4a2fdc1dd50b20f.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB5502:EE_
x-ms-office365-filtering-correlation-id: cdcf6c57-169f-4091-3ac6-08db418dbd77
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mBDV/RncO5VjeA09qnMsU2DUHzF4f+MRSm/rSQggnXHhFQ58nwQwf4E39ZYlBwMf8JVJFBgd8t2svS1vIr2arm9QLsdxZfH3xV+YBG1gfV/7ozri8Wasa+sQm3Pz+BNlijM7JiFUO1exQc0uGTeISx1OVyXnq6foVAoYqGxW/tV4h3/eOEcgRVayrElGrmqePUIFS3yfYSQg2pISjA+MKmK/iz2AmQxYL+tjZmaBpIwLiHB4nR1O0kFUOQbCTNxB5ezbuszow83HcCRTZXy/QmuSWkxPGsU8Gy/X1FBjWZ289Jb0zkDgcCG//MLcgGnz7AEizszhQI9PhpK5dXGsSmOqYFqgjMTo8/OFwnuGHJdVPV7kNNpcO42QMzVZXjZ6AnVkriQhpUWG+46CwzL3FbK4aMRxXJPfzo6mq1eMh2ubMPnDSpJmkeUVpZFUYKs7D8I72wiqYQMCB9gkrOd0Jeqj15DPEDew4BhmXloAbV4XIxPWFvL+YS0FFdzEe5caFNDunNWcaG13hvZCXh1qfqvWkdKUnSwAGqJWGphrlXRUWs9rR2fexpU2uKW6Obx1NRY3Lx5XmV5BEkQ81Wb4Nm/iyMK85iJ6KFRnWPNHDPq2qvy8RBqycHkYt+UvPNMy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199021)(54906003)(4326008)(6916009)(316002)(91956017)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(478600001)(71200400001)(6486002)(8936002)(5660300002)(41300700001)(8676002)(82960400001)(4744005)(2906002)(38070700005)(86362001)(36756003)(38100700002)(2616005)(26005)(6506007)(186003)(6512007)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0NzQkNEb1QrWS93elNXKyt1Y3dzRkpXbGEyMWV0RWZ2cUtkZ3lJWUliUHBp?=
 =?utf-8?B?M1plM0pBNHpwa3R6NzArQXNZYlRSci9SVGZlT3ZQeDN3QVBTbXpNQlBNQlhw?=
 =?utf-8?B?YTBndFloSUdVTjVtTUFkRFNENjJTb0d1LzcwM1UwTU53Z1AyMytIKytOMmg0?=
 =?utf-8?B?c3prek0ycHZpdjFZK0JoQnU4bHZiOFV0Z1BjL0VlUk90QVowK1ZYR3IxVzZ5?=
 =?utf-8?B?MzBHYjJpK3BNM3k3bTlKWTlGK2lsejR6aGVKQ1ZkRXFqY2Ftd1hkaEVEdmRJ?=
 =?utf-8?B?MDVxM2dkcFdyTVFrOUxCYVhwa3p1RGdOTnk5aW51WnIrWDAzL3VidVkzcVFo?=
 =?utf-8?B?R1hIeDFkS293YmJCaVBuZEtaUXR5LzN0SmJ5eGliSk9HRzljOU5vZzNtZVBp?=
 =?utf-8?B?WW50Mkd4ZElaOHorS2JWSnBkRGFRY1pHcjZhK0tySHprcEJZU1pNcHhsZmtp?=
 =?utf-8?B?T3ovL0Q3VGJnZU5jWkxyVDJVd2t5dk9md1ZoOVNTdXJRc1c3MUV4dUpLYXNr?=
 =?utf-8?B?MHEzU1U1ZVR4WVhPUUMrSHFtR25USjhtVTRhNS9nMU9pem1YdWtIWkR0NzdM?=
 =?utf-8?B?Sy9reTdwR3gvM0NIMXphOS9QQmpxUVRQUmVlcDlSQTcwNUxxeVBiRlc4S3Rq?=
 =?utf-8?B?VElybnB4dXVZazZYVE96S25yOXlqQjlFV3BENHlNVUlyUWtDV2FKdVhDVnV5?=
 =?utf-8?B?QjB2RkxNKzUwckJ1TkNNZWoyUTAzZDVHOFVvcFQ4WXkySDc1RlV5OHdvdER0?=
 =?utf-8?B?aW5MaUFnam9VMjZTaWZqTkhqTzR6clh0bVd2d08vUmJjN1ZrenZZR0FvMDN1?=
 =?utf-8?B?NVRkK2ZzVkRoZXZyR0w0NWdkR25KdldPbStYTFJiblRWY1ROaG1rYytYMXh0?=
 =?utf-8?B?djFGZlh4Z1Zqamo0bythbVFOT21odWNhMmdjNEFTZnY4Vm52ZDZHcXpackla?=
 =?utf-8?B?a3VPa3YxYkJjTTZodE5pVGxtbSt3czBIQkFWWHJ6VFZLZkMzL0ljMHU0OWda?=
 =?utf-8?B?Y3h1Um9DS3paam83OHdHNE0vM2ZFdGdhcjZjd2hIZksvdkxHYWcrNmY3TEk5?=
 =?utf-8?B?cGlQRmcvM1hTV0pQbVlEQVhvSWY2elZRaXpiZkJUZFh3WWFCNmhvVnpPMlgr?=
 =?utf-8?B?aGUwSkQraFlBOG9uODM3MEVMU1U3YklFMGdQcEk2T201V3VtVytHdjJJbGpQ?=
 =?utf-8?B?V2NIZVpVMFBWYnhOQ1N4MmoybW1MWjMvNHhnOGRzK0I0eFdBQThEODJBenNT?=
 =?utf-8?B?amN2QmNUZDB1TXFqUmcvT2ZpekRreFZHUTI0WjBEcDl0QmRPR05QZ2k4NXFD?=
 =?utf-8?B?WUJUeTJwcFNHM1lTdGp0Yy9zSW82M0d1SHZZMjFMQlNmN3VQMVlRQzJ2R2Ru?=
 =?utf-8?B?OTR4bU0zejVqTkpLTmRCNi9IUkV2YmpQMGg3MFNybGJ4Ym5QWWRQOHdGZE54?=
 =?utf-8?B?RlRkQ3Z5Z09aYko5NnZINUFzQkJJRFVlTGFHQ0lST2RBMzBkZXRMYlFQa1Ix?=
 =?utf-8?B?eXVsNHczNGZnWlB5ZEFWVmlyUlNWY1RYeTlwd2VVczFmTmtkaDk5aTNHb0Ey?=
 =?utf-8?B?WTlBTFEzOWlxbDFzV3p4ZDdWeXprTzRnYldza2JsbFVNcUZENWgxd2Y4SHdH?=
 =?utf-8?B?Qi83WlVuSXpjeVRTUjFjL2hDVGJlQXJCekp2bXNQa3hlRnZVNHQ2YW93YWdq?=
 =?utf-8?B?L2dYNHI2SEhmblY2QnZXWlhsVU9rMUdyOHdkUEM3RmVHYytsMUlMKzdJUmlM?=
 =?utf-8?B?NEp5NmsrampWdHB3akVqcDM2Z1RXZVMrQmVEam9tTHhSVlNPcWNIZWRjTEpI?=
 =?utf-8?B?N09XRGhYUm9SajFkR2twUXV1cE9WQ2ZmK0VCMEs1MjVvLzgwcEk3ajNyaS9n?=
 =?utf-8?B?VGRDM0FabWxMY2pXTEhlV0FzbGdSSmg3dm1BQURhYzVMbk9rcFNueG4veGx0?=
 =?utf-8?B?cndjcUtGd2hRMHRWd3ErdnBqZHN0Zk5adGZoaWc0TExkMHNaTzZ3aFZhZmZN?=
 =?utf-8?B?TzluQ3FNRXNrNzVjQkhEcjFVT1Q5UFI3b2o2MWhqWG5xdWhuc0FYZlNTRGRK?=
 =?utf-8?B?OFRYUlNvMVRIbW5XYUpITTI3NmJPQVN4MVZvanpuUzVNeU9TQmJzQlhEeE1w?=
 =?utf-8?Q?Ya51/Xd0twOyLmn+KUNz3SO2G?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E488716D28A6744A8FD0E640FB00956D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdcf6c57-169f-4091-3ac6-08db418dbd77
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 10:55:22.7348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zGO06l07Hrx/R2dRHLxrVulemoTm3fQMSf3m1Rj7d/LlOtuBnCuUIvOcfewnH7pATe5rGTkJwE5odBXQDwFGng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5502
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

DQo+ID4gDQo+ID4gT29vaCwgcmlnaHQuICBJdCdzIG5vdCB0aGF0IEZQK1NTRSBhcmUgYWx3YXlz
IGFsbG93ZWQsIGl0J3MgdGhhdCBGUCtTU0UgbXVzdCBhbHdheXMNCj4gPiBiZSBfc2V0Xy4gIFNv
IHRoaXM/DQo+ID4gDQo+ID4gCQl4ZnJtICYgfih2Y3B1LT5hcmNoLmd1ZXN0X3N1cHBvcnRlZF94
Y3IwIHwgWEZFQVRVUkVfTUFTS19GUFNTRSkgfHwNCj4gPiAJCSh4ZnJtICYgWEZFQVRVUkVfTUFT
S19GUFNTRSkgIT0gWEZFQVRVUkVfTUFTS19GUFNTRQ0KPiANCj4gTG9va3MgZ29vZC4NCj4gDQo+
IEknbGwgdHJ5IHRvIGdldCBzb21lIHRlc3QgZG9uZSB3aXRoIHRoaXMgY29kZSBjaGFuZ2UuDQo+
IA0KDQpUZXN0ZWQgdGhpcyBzZXJpZXMgd2l0aCB5b3VyIGFib3ZlIGNvZGUgY2hhbmdlIGJ5IHJ1
bm5pbmcgc2ltcGxlIFNHWCBhcHAgaW4gdGhlDQpndWVzdC4NCg0KRm9yIHRoaXMgcGFydGljdWxh
ciBjYXNlLCB0ZXN0ZWQgd2l0aCBFQ1JFQVRFIHdpdGggeGZybSA9IDB4MSBpbiB0aGUgZ3Vlc3Qs
IGFuZA0KZ3Vlc3QgY2FuIHJlY2VpdmUgI0dQLiANCg0KU28gZm9yIHRoZSBlbnRpcmUgc2VyaWVz
Og0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KVGVzdGVk
LWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoNCg0KPiANCg0K
