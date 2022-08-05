Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9455758A40C
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 02:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237353AbiHEAED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 20:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiHEAEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 20:04:01 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248E26E8B7;
        Thu,  4 Aug 2022 17:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659657840; x=1691193840;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aYGMrJhMG7VwH6G8GGglk7gFn5B7F4FWtQOqfyNd9WQ=;
  b=iO7PjO6O3SMOf9pEmkwyHVQ+I+u59sMAxdQVYvsq5xVRbjuUUaLXmsPp
   DGNVG7Vtvae4pfKflmDXBfUQsTV5IrJuaPwSEPkCvwkXKRxpx5mxLKp3N
   gtWzVzNFAHGi7H2s3lmfwTvMOum4sP1gO1grAZzabp0t5i0nazoIbotSr
   VO4Vvz4KFugQClklJZmeRrlYxW9DcHk9YmTtS1veCX8vAq3KzFmOJXWss
   2C5aI/urVgZgNFZ6SWtCslFb0xO1zciOxLXAcVEOAoifycFQn0z3zKqb3
   P9aIA+HYhWHB/KeEtc61vnUPfvzBOOKI4dIadbgnVKARah6a8vs2n54nH
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10429"; a="287645409"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="287645409"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 17:03:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="745672187"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 04 Aug 2022 17:03:59 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 4 Aug 2022 17:03:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 4 Aug 2022 17:03:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 4 Aug 2022 17:03:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gq26JXB4wuolJjA+r6eYjx6nBbmiD7RA+2gs8/h2houWN4y9GUMy/a5jR8HoCW6iaLkqGqzEDnYu/gEE5wAWlZ5tityLIPpIG26spFgRH1JYGxE2XMz/Y/rd38L56p9c21HJsciJUMt/JFEIDx2z/2CKnP5Rd3PbXz5gXNXsDY94s9+1GlNO0uBP6lkrd6vN3ZhAjJxbQP+RuJGRNsCRSTtXCyEujnoemDk8Zg6ErFxj8Aljsp8ztRPtsGqbOD/v08+9xGwSQbSdUw9prpVsiprTBau18kmpoVUOTrZt7+LnhNlGJfptdHWhu+46iWJtUkCOF50aM62SFZXG7p3BcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aYGMrJhMG7VwH6G8GGglk7gFn5B7F4FWtQOqfyNd9WQ=;
 b=E3lv02xOGwIDC/LKP7rx4x9Wbzkj6ZfqXbcjYCf76tUIGqUea+uleog+Iz0S1gTueSsVvuKA61341N5HNBWuwsOKokUp1nv37lNzPfhXk3aMR+ez/3zS69GEJlvRJslx+FUcQsvXMRkJ9F7buvV8xOnm8ayH15xkcfm3LniCzX3I1LSGns5NU/+gLdaSMNRfrWo2IlcLSMSHhObp2lXiN0b1HV4TArfLGhX7gKSlTewMTI7UsTGqgSHcEmTohBKzvQaeHZsbH3tNg0aGHjJANtyfXs19FuoUhp6EWEwPOld+2D0kJ93gjdse1bGF8D+a/y7OiulLODn16AcNr0bwJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL0PR11MB3204.namprd11.prod.outlook.com (2603:10b6:208:60::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Fri, 5 Aug
 2022 00:03:57 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fd67:814c:7bf7:7ddb]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fd67:814c:7bf7:7ddb%9]) with mapi id 15.20.5504.014; Fri, 5 Aug 2022
 00:03:57 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     David Matlack <dmatlack@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>
Subject: RE: [RFC PATCH v6 037/104] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE
Thread-Topic: [RFC PATCH v6 037/104] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE
Thread-Index: AQHYYKy8zPILIEnT00ajAOEUUOd8O62f6OoAgAAG0wCAAApGoA==
Date:   Fri, 5 Aug 2022 00:03:57 +0000
Message-ID: <BL1PR11MB5978DB988E482B8329339881F79E9@BL1PR11MB5978.namprd11.prod.outlook.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <bfa4f7415a1d059bd3a4c6d14105f2baf2d03ba6.1651774250.git.isaku.yamahata@intel.com>
 <YuxOHPpkhKnnstqw@google.com>
 <CALzav=cf_2dz8vMD+D_Xo1zBJZndJmtMBxbnYpQKP_mci1np=A@mail.gmail.com>
In-Reply-To: <CALzav=cf_2dz8vMD+D_Xo1zBJZndJmtMBxbnYpQKP_mci1np=A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 614318fc-2004-47d9-8064-08da7675fe1f
x-ms-traffictypediagnostic: BL0PR11MB3204:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5VLXJS6jIdKIFHwQnTTNPaA7K6SZrc9m8U2il0dPVonza3OLeAfz6M01qKR59deLvYiJCG68PgFsr2ILpMr/w9ozIKpGVTeFyTCNvmfRbAIS0HjURacYEB79HObx+9FQ/6y2VrTOiRzLeYgKpGGG3MIl7aDP/o33T6KsyQWpKkcaW9i2TMjHj95QB0643SoYhnAPcKi2kZgXelGn6y20JtRBWFf4djJKOR/BHkpp32vrKuB70c/64BtTW+hYsMCh1OaaXE7LnBGm+CzlPCx/nEb4I3S0Eu34hszJjg5avZ0sLSHmD3Ov8RLoomU+r6MiNj2vqtbcpLSxY7USfzNKvTk918Wr0gNnybqrf7NW4qoxRgGpWY3KPMJydvsVBSGMM3DCvgeBGV77E7vHhxecEM3SCqAXWxuw1c8ZcswUFSewLgUUyaX/wJxy1LvhNs6bMkZ2M0hCL8aRmTItcFzdThZz1+GQa1nH+dQO6kmy+7tMPLN0ebK7bk6EmuJn8LoULv0ZiQSbQHbIo/kw/2CqIS1+R9hE/giSLU7YfjFA/mQ6h5Rgc38bVcyJboai5o1WD3rn3e8F//r2KP4nrg9RNFvgqZKTQoUYyNvfye2FzdaraXHRMg6jeB0+cPN7xsGd2HvX+AUhcMFyxudShdTt6UGSPzyPWVjykRQzuVCaZfbWasMCuI4DX7sV87CeBv+iLVdNlge3rAj8CLfwcK9zGI+inddLNV+3NZQKRKX5k5nauzE3Gi5XHeVAmBldmw8Imh7bTKS6NI453ul4s2FQj9BWW/gzO4VrgNVITp54D5M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(376002)(39860400002)(366004)(396003)(41300700001)(4744005)(316002)(478600001)(71200400001)(110136005)(54906003)(8676002)(2906002)(76116006)(55016003)(66476007)(66556008)(64756008)(66446008)(8936002)(4326008)(52536014)(66946007)(5660300002)(82960400001)(6636002)(38100700002)(122000001)(38070700005)(86362001)(7696005)(186003)(33656002)(6506007)(26005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Uy9WclorWm1FZ1l0ZWphTkZ4VjMzTjh2TDlXTzdoMGVOamFPNTJmU1o2YlRU?=
 =?utf-8?B?bC91QWNxbUk2cHRGbmVXWTBlREl5MWZGYTAxZE9tUTNPR0d3OVh5NElBZ3lD?=
 =?utf-8?B?Sm5uaVBhUFVySXhlR1dnSHZwOWo3cllVVGpDWlBFYkgyVnpsWkxqcnc2MlZN?=
 =?utf-8?B?UjYrdE9QYWV0WFBDVys2S3Npay9nOUNEa2VNUklLdDZvWTYyVmlCLzZkWTJE?=
 =?utf-8?B?cmVoWDE4d0VrNTBqWFVsZ2J4ZjIvd0Jlczl3eThmQXYxcG94WkxybkZsWkJp?=
 =?utf-8?B?VjdiNFpFYVNtZ0JxMXJtZHBQcHNodE9qU0R2dUhTdFN4UVdUWTgrSlgzaHFQ?=
 =?utf-8?B?a2VvRVUwUG5sbE5OSmRmQ3hRcGsyRUpUOEM3UzBxMTUyUnRIVE5kRy9KdWN5?=
 =?utf-8?B?TTIvSHJzdzA2Rzl0UzdNdFdlQWFoLzA0WTd5QzVILzlZVnZwYmZHQ3JDalc2?=
 =?utf-8?B?RTI3N3dxWFUrc25ISW1JOUFRSnVSMVBweEw2SW5hRy8wdEcySXpBVlZmbVhp?=
 =?utf-8?B?cW16cWxUTFNXNUdRSkVVNHVWOGp1UWtkWTJXTnNheEVvNzQ1a2xHdDBXaThl?=
 =?utf-8?B?RFNQUDFGZUVZN2JiRHZSOUM2aytaUWhpc2lyOTAxdy83QXdBV1YzQUhPRzBE?=
 =?utf-8?B?b2ZYaEUxVDM3TEpScU5TUVlKMk1GemdhOG81ZVZSNk9VVkRueUZWL2Vld3Nw?=
 =?utf-8?B?RjQvN2J5c1JSVDFvZjY3TWlqeUN3Ymg4WWdqNExqZWo4YzMzWVpQS2lVdUZz?=
 =?utf-8?B?bzdlOWtsakNWNTM3Q2ZNcys0SThicW1HTEFEMElRQzVva1hWWFVlNWNyQTVo?=
 =?utf-8?B?TnV4TEhGeG1EcjBHS1llbFRZNnE3RHdQWGhya2tHVmM4aUplalNxMDR0ODkx?=
 =?utf-8?B?Z0kzUlNHdGc1cnFEaEs4Z1d5N0Q2YXQyUFR0ejlGbFAwdDNiTUFKWmFKQWNY?=
 =?utf-8?B?K3JTZGNhTEFTRHc0bG9UQ2pjRFY4a1ZQUktUNDhyNTBydG54UTRpU1R4V0I2?=
 =?utf-8?B?UkpwUWNuTjUwcFp3cVgrODJMOGRJTGdrK1g2R0dUY1p0WlplK2JDbW5hTjJT?=
 =?utf-8?B?cG14WW1DUHFSM0NJZFVZeXpPR2xDTWNRRTJ2ZEcvSFdtaEs2RHhJajFNNDV5?=
 =?utf-8?B?ZXZuMHAyZTRnalNvRjVBY0JDa1ptWG9xSFR1VnUrdHR2R21sY2l5bysvN0Mv?=
 =?utf-8?B?R1lBRWw4eDQraXRXNlIxVkI1aWp5V2dSSjZicHlCZ3JJTi8xOURGQStGMndq?=
 =?utf-8?B?VnR1bkVnakR0MEQwOTJUMUllYVhLcHRyOTJDN0VSMnFOVDBmU0hvU1pSaE8w?=
 =?utf-8?B?b2lqRFY1UnZocGxFNVdvRCszdWdjTjcrbXE1YlVGWkcvNld2YXM4VDBDZ2VS?=
 =?utf-8?B?a2NYZTRrbDZHUkpsWHg1RHM2elYrYWZGTVlzWFl3R294VEcrWVQ3M1NJQ3NP?=
 =?utf-8?B?VDFndU1xZjJseGR6OEg1VVZJMDhNaHRVbVFyRGhOV3pNVXFCNHhjcjc2VmpH?=
 =?utf-8?B?UzJOYlR3TlViSnFSUlNIS1F0eHFCdVBWOUYxNVNLYlRoaFUyZU9mQmlKMmtj?=
 =?utf-8?B?TURjSDN2TWtNVkNiZFJ6Njh5eXdoVGNkZHpZZGtUNHgrOWpJaHVSY1hRQmdK?=
 =?utf-8?B?Vi9MY1FYZ0pKRTd0NjNHU2s0cFkxbW9pRkdOMUtIWU9LNFhQY05HN29ZOXdo?=
 =?utf-8?B?WGkzakVXdCtORjROWXUxYWlKK0ZlOW1JK3lHc2VVWG14SlllTWt2Y0N0b3hO?=
 =?utf-8?B?Ykd2RytLcVhXL0tEODhiWU81NXFaYmhBanFURHcvMXg3SURtTU5VS09sc0pP?=
 =?utf-8?B?M2VPaDdpN3ppcGpRcndBN0RqN2hnbnhpZkkvcVh2UTRvNmt6WmM5OXVzdDBw?=
 =?utf-8?B?TWhZY1JDamRVbFJGSEtwVUtUOW1CL1VvWU9Wd0phdlJUWU51eUhiL2d0VmIz?=
 =?utf-8?B?Qk5BcGIyNi9KN05uNStRVGRmbjVXTlJzaHRhMFc4VzRIdmtOYnM4cjBmcmFu?=
 =?utf-8?B?ZnNLZmNUU2Y1U1paQmJaKzBaQWlDSjZWc0lLeWNlMTVnaTdad3NZWlpNbGND?=
 =?utf-8?B?QkVlbU91MHlEb2tMbWNPSUNaUzU2a2dXSEhONWJsZExldWxiQ3d0bDZMeEFz?=
 =?utf-8?Q?7cgk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 614318fc-2004-47d9-8064-08da7675fe1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2022 00:03:57.1357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZCsrlMwsPGUVseyGjauRPjJDQjg4IT7u0jqHeOn9OtZgB2Y/oFg0nu44/4Uwdv2VLSr53beHppHY15SF7kZH9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3204
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+IEluIGFkZGl0aW9uIHRvIHRoZSBzdWdnZXN0aW9ucyBhYm92ZSwgSSdkIHN1Z2dlc3QgYnJl
YWtpbmcgdGhpcyBwYXRjaA0KPiA+IHVwLCBzaW5jZSBpdCBpcyBkb2luZyBtdWx0aXBsZSB0aGlu
Z3M6DQo+ID4NCj4gPiAxLiBQYXRjaCBpbml0aWFsaXplIHNoYWRvdyBwYWdlIHRhYmxlcyB0byBF
TVBUWV9TUFRFICgwKSBhbmQNCj4gPiAgICByZXBsYWNlIFREUCBNTVUgaGFyZC1jb2RlZCAwIHdp
dGggRU1QVFlfU1BURS4NCj4gPiAyLiBQYXRjaCB0byBjaGFuZ2UgRk5BTUUoc3luY19wYWdlKSB0
byBub3QgYXNzdW1lIEVNUFRZX1NQVEUgaXMgMC4NCj4gPiAzLiBQYXRjaCB0byBzZXQgYml0IDYz
IGluIEVNUFRZX1NQVEUuDQo+ID4gNC4gUGF0Y2ggdG8gc2V0IGJpdCA2MyBpbiBSRU1PVkVEX1NQ
VEUuDQoNCkkgdGhpbmsgMS8yIGNhbiBiZSBzZXBhcmF0ZSBwYXRjaGVzLCBidXQgMy80IHNob3Vs
ZCBiZSBkb25lIHRvZ2V0aGVyLg0KDQpQYXRjaCAzIGFsb25lIGlzIGJyb2tlbiBhcyB3aGVuIFRE
UCBNTVUgemFwcyBTUFRFIGFuZCByZXBsYWNlcyBpdCB3aXRoIFJFTU9WRURfU1BURSwgaXQgbG9z
ZXMgYml0IDYzLiAgVGhpcyBpcyBub3Qgd2hhdCB3ZSB3YW50LiAgV2UgYWx3YXlzIHdhbnQgYml0
IDYzIHNldCBpZiBpdCBpcyBzdXBwb3NlZCB0byBiZSAgc2V0IHRvIGEgbm9uLXByZXNlbnQgU1BU
RS4gDQoNCkJ1dCBJIGFsc28gZG9uJ3Qgc2VlIHNwbGl0dGluZyB0byAzICBwYXRjaGVzIGlzIGFi
c29sdXRlbHkgd29ydGggdG8gZG8gYXMgZG9pbmcgYWJvdmUgaW4gb25lIHBhdGNoIGlzIGFsc28g
ZmluZSB0byBtZS4NCg0K
