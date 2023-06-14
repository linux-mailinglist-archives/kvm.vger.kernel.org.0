Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5A272F10F
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 02:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240551AbjFNAio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 20:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjFNAim (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 20:38:42 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A401732;
        Tue, 13 Jun 2023 17:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686703121; x=1718239121;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8x/T/ycyKLkogc+LIKE3xM/YLC+F3NHqMavkRnvwcWY=;
  b=fVu5t9xRkuFjVJtIeifXhrozBsTfMkVFBFfL6eBO3lJfobX+geDm7x5Z
   sl+GKcBWI8dTlTdNVUn3uRte7vbwYAwtulP9DX3s48NTTtZMiwbIl9t9V
   0xOqAXdmZMXZoxitOGz1nYldLCKvyyumjug9AUqtUtfQVkMeg1dyczWKj
   XUhXkKXnm+bBouZOJx0xIyjvjndU9fHb5o4bDrHYEIIqomlsj+HJOrDwB
   dm/ErMyy/bF6dmmaUdwqL5X1ycWQ2wDPHH10ZSNehWzGc+8ARa9kcJgf5
   1rhqquB48ObNSbx1tqO+f6W4vZdEx3scKoqo78+hnsjm4eircZ7Viy5lF
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="424367470"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="424367470"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 17:38:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="781898696"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="781898696"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 13 Jun 2023 17:38:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 17:38:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 17:38:39 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 17:38:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fr5DQAjU5kdVmhzXJE5SyLu9lOu2WcubTL/5F2H8kBGg2OtpYL/+CTC0osqHtn0wQOlDGbm32Lc1woirncXhaffNyBz4zJFP6xF7Yoyup+45o72tB3f3+w6HpmP+3OP1tSJljbkxgu6i6cZj6EAYi+EHtpYGkapUhHpZ164/+IPYORG54li0soIP5Xk/0eO8iKW6icWftGcIGb+i6Se85SWIanKMzCNIJKNhk80tvG8uB6IKg0yu46oqlLIew2ZYDYt4SEpcysXTF2aq79/Vgs2JD+EP5gTR/LuvqiJup0yZrTEaylZr15Ia6EL0ft48yhM5nRgTq9IvJyrIHFrwAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8x/T/ycyKLkogc+LIKE3xM/YLC+F3NHqMavkRnvwcWY=;
 b=Rwoz9V7AGYtxQb7f8OalmB8nvRGiu8uPUN4hwPcRoQ1YVDw5iss8Xq4UIaYS0RQ2DXoPDxZIJqE+PJtEDJ7aR2N/14yEKrHHCRGxyAsV1L6JUt7ekBfV3dFE8ftyQZGPxdrME72s8wnpTrWdz9wZNIG3ordcJm5cTlgsjYqbam+wydX3Y3SORdR5/ZgDDVYcDoG526A7LWNFQpzPTbkEy24wfNmAwW5N9yvqRMHZfi7NQ3hjmLU31ocRMJuIDCgZzH8fun2xT+m1ExRo45qUyb3npMc6zLO5AveUvhrpKy7YjD+bVG527uEHDLTpPcU2xS4nJbUjMtdjDZ7pLTIasg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7285.namprd11.prod.outlook.com (2603:10b6:8:13d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 14 Jun
 2023 00:38:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Wed, 14 Jun 2023
 00:38:36 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
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
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Topic: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Index: AQHZlu+7CCb5RYnzE0SLr6ZWSpg4cK+CfSeAgAQK0ICAAFGDAIAAKbAAgAA3uQCAALmTAIAA45EAgACUsYCAABKwAIAAA9CA
Date:   Wed, 14 Jun 2023 00:38:36 +0000
Message-ID: <2ddb8858ad995904654379ee57a5949dee3f696b.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
         <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
         <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
         <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
         <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
         <48d5a29a-878c-665d-6ac2-6f0563bf6f3c@intel.com>
         <3bbb6b384ba89dfaa13be01654ad27e41d779fba.camel@intel.com>
         <6fb1ec2f-8713-8191-fd31-751b1a663b0b@intel.com>
         <1542a26c0501cb9f7fc330d8aa27e565c81b969c.camel@intel.com>
         <6e3ae1bd-c6e4-b7cb-ab4c-50849ffbc237@intel.com>
In-Reply-To: <6e3ae1bd-c6e4-b7cb-ab4c-50849ffbc237@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7285:EE_
x-ms-office365-filtering-correlation-id: 0bcd7172-0270-4618-65ef-08db6c6fb08c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 31HQCkAWDyn2fUBDGtMOyu7H1Z7p1vmgdbagInfSKxUaJaaiYYWeD6XKDETDgSyI8PIy6c6iFuSQCdHvl36gOvkJynoUbohDRilyNnBQIHPbynuZ7Ba8fyWgXcS79uV3SWqzw1YhdkYjViwL/FIhlx6RWjDepxOGMqzy1f9b1QOvEwKuQpPCdJb4nSscgiPKgP47DHmakSAHnaozCOiNdmhxMiAQ5Pv7nRfDT3FkM08VlXpZHAYVZC3VyUpVUEIs82RkmAzbt9dW738VXvl4p6cJ9TXDJeu/bbNscSWWLu3ucU/e6FnRJkzaQTTSKGWzFQBfc0++wCr2fsyXfnRtK0aibAx2KS6Knj5UB0uyP2ZTC4cjdLwz1sdQj9kx+D+4X2OEt5S1ARH6f90xUAEnumqC/VWF7JWAr8mEJGxkoH7LjfbwfVVELKhY5UVi7+m+nDnJgZ7uQAlsdS50NxAJ7t3j+WTT+L9/55Q4mGyU8rZiRKpMwG2SnNfqMe4wdzfEAIXXGo4AfHWLPKXzwgciAHKDLppJufuK0hKhxgWnSd6P9Jomu0q5OFVWBEKKkDrJN+wjx/cGaIqoydBLB2ywwe9t/sPYKf2B6eGMmMkB2isCxVCxCeAX9YC88ANptLdc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(396003)(136003)(376002)(451199021)(41300700001)(83380400001)(7416002)(82960400001)(6486002)(110136005)(4326008)(38070700005)(478600001)(8936002)(8676002)(86362001)(66476007)(38100700002)(66946007)(76116006)(66446008)(66556008)(91956017)(6636002)(64756008)(316002)(5660300002)(122000001)(36756003)(71200400001)(54906003)(2906002)(6512007)(26005)(6506007)(186003)(2616005)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ky9vZ2ZMVm9ZSGhMYUVUNjNjdTlyeFB6S1B1T1NpSHlvK2p0V1pPOXlxQXlx?=
 =?utf-8?B?VVlGM0RJM2N3eHhCSENQa2JTS3RUMWQvbzVsQlJNT2laSFBSUjdjTlFNRjRn?=
 =?utf-8?B?STlURmJiU0E4UWJvQVBsWmVQS28wTUdDOVBhQnRWeWVybG9EUk9sY3dvUUxH?=
 =?utf-8?B?Y1lPT1NTY083SFQxT3dobm1XWlNOMGRVVy9ERDJ6a1o5TXFJWTFnWG5MYWVo?=
 =?utf-8?B?c0tXLzRQSHV6ZFZlYThrRE1VZDBkTGswMXNxeDVuTWxqakIyM2s2K05XN2ZY?=
 =?utf-8?B?ZzBPV29QcDRGb08wNTJhY1gyOU5MaDJiZTlCSnRwQUZOaFZIcjhIbncxK2tq?=
 =?utf-8?B?SCs4WWdEblNtUHJORXpyRDBLQ084SHlYaTMrL1FjTnRRaEtrOHJhTWJucGhG?=
 =?utf-8?B?Zk1NS2FxVENtL2xCVmpzcW5OSUtDVHpSS2FmUzlWV0JlbzRMZlIwQjBaYXor?=
 =?utf-8?B?ZnR6Z3FLbDBYTnhNVmNFTkVmK3grN0UvQy91bzNZb3h2c2k5ZWwwM1FBaHZl?=
 =?utf-8?B?S2Rwek1JeFpSUk1UQlRPdXREdUdUMU9EQjVUMVVjMmYvelBKdlNnRVZmNWJi?=
 =?utf-8?B?RGhjYkpqczEvc3NZRXhEbktqb29POUhQaENHaGN5OEFkelo5aEN0YW1sYjVS?=
 =?utf-8?B?RlE3RVUrM2JUU3o5NTlMSm8xQ2hFYVRsSGo0S0FlMGk1Zm1yZ3ZuTk5XZm9W?=
 =?utf-8?B?Mk9aT0J3TFk1b1paQ1ZFMGVOV1VzcXk3OVJ0RXlGbDVhazl0S2lVZDhWaUZ6?=
 =?utf-8?B?OTUybDQ0OU15Y1FjRTE0WUVld3BoY1pFSHNyT2UzQ3lrYTFUNkJOY2hBSUhI?=
 =?utf-8?B?dGVCZkVDekZwYUFoOVJjcld6d3hpYWgyVFFZd29xT2lMN2p5UnlOT2pDbzRq?=
 =?utf-8?B?WnhXdlEyQ1FPZE45akV4bzFIRVRUV2gwdUh6MDB3elpJb3lKbFRURjk3MU8v?=
 =?utf-8?B?dFN4MVo1aXViVG11YUhTYVpPTnA5OUZod1hDMHlVUnBuYTlmcVhWQmhIQnU1?=
 =?utf-8?B?cTV1QlFuZjE2Q0ZTMGdUL0ptdXBlcXg0U1gyUHpkdDQ0OGQyUkdScUV2NUNo?=
 =?utf-8?B?M1FrY2FZM3V0UmdwRG9RdUpWNU9jejZZVFBKWmlvckF4SzhqRGY0YXU4RGtw?=
 =?utf-8?B?MWg1ZVVtRXhwdlVqWVhkVWlIamRya1J2K1VEMWhrS0ZsVkRHRmQxSnlPQ1Q3?=
 =?utf-8?B?VmFWOEQ1STZ4RzE0MGxVTlczYXlPeXBzN2hldlEvSVpiVVIzTk1xZ1haVlVQ?=
 =?utf-8?B?Y1N5ekFxWG5YVDBXeXoydGZWb3hHZ2UyUVBuVGVwb1FBdVE2eldnQU03RHFG?=
 =?utf-8?B?cEpEazVmQVVzZG5MRURiN0Z2M2VIQWo4RUxXN3lUQUR1dFRlU3dVZjg3Q2JD?=
 =?utf-8?B?VmRHU3J5RXlyK1k2dFYyZkFjSEFNV2RkS3owSFYzVVJ5cis5ZzNkZWhLOVFQ?=
 =?utf-8?B?a2p3R0JjYnVJMldwQUFUSVljQU1oTitBQitta3E4Kzd3NUxkdlN0c2lmYmN0?=
 =?utf-8?B?V2gwUm1RNDU0SzFBTWZYYTdSSFpiSEo1aUxLWFdUMXZNMFgwSjMyKzhoRHdn?=
 =?utf-8?B?bW41YXFGcnY4UEFiV29IZU13RVY3Sm5kWUQwdEpnNmN2RzRjeTJsV05UVm1a?=
 =?utf-8?B?YkFTNWFJT3Q3c0tOemMreGM5VkMwYmgreDRSS2dQRVJZcW9RaGZHQURuck1s?=
 =?utf-8?B?RWZERWhCd2NXVTlndSs4elpUTWFBd3Ara216REYweGFJSHVobkpGclo0dXl4?=
 =?utf-8?B?cVFtWE1mNmFLTHN2RDgxVjF0Y3ExYnRFQnhiR055ZkFDQUhObE8zWHRkTEw1?=
 =?utf-8?B?dGYrRWhRNUE4Yy9vSHdDREhPUmltZ2JUSXkxdzlSWERrWUJRaGdnemZnNUg0?=
 =?utf-8?B?RlRyTE5GSjczcDZEMHF4NDlMQ2NBczVDMXlEZGpiLzJldGRoemRVL0l1NFFv?=
 =?utf-8?B?enVmUm1zdFNQMXBEa2IzZ2JnTXUwb1JxOUE1QXpJbEdHbThWZWtMSzJqOTdT?=
 =?utf-8?B?RjFDN0dSQ2FFSmxxcjBDQnlZNkJLQms1K2YraWoxU2J0blV0RzlCdktlbDVD?=
 =?utf-8?B?N1haRjZtOHo5Q0VUeFBBZ2t5WVgxQlRDNFJiS1lBRGdhOXI3S2pIaDF4MERN?=
 =?utf-8?Q?QjhMABvpN3zhyt17fPnjn7WrW?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <48F07C52D4D8C145A75EC79D765B3D1F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bcd7172-0270-4618-65ef-08db6c6fb08c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 00:38:36.1826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EAEOQ15lyCo7flYkjXSGewg9VC5nD+wZX96sSemRwaT7fKMtL1AG8eJB/0ZUArNydWOrremGoTL+A+rneqED+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7285
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA2LTEzIGF0IDE3OjI0IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNi8xMy8yMyAxNjoxOCwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBUdWUsIDIwMjMtMDYt
MTMgYXQgMDc6MjUgLTA3MDAsIEhhbnNlbiwgRGF2ZSB3cm90ZToNCj4gPiA+IE9uIDYvMTIvMjMg
MTc6NTEsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiA+IElmIHdlIGludHJvZHVjZSBhIGhlbHBl
ciB0byBtYXJrIGEgcGFnZSBhcyBURFggcHJpdmF0ZSBwYWdlLA0KPiA+ID4gTGV0IG1lIGdldCB0
aGlzIHJpZ2h0OiB5b3UgaGF2ZSB3b3JraW5nLCBmdW5jdGlvbmFsIGNvZGUgZm9yIGENCj4gPiA+
IGhpZ2hseS11bmxpa2VseSBzY2VuYXJpbyAoa2VybmVsIGJ1Z3Mgb3IgZXZlbiBtb3JlIHJhcmUg
aGFyZHdhcmUNCj4gPiA+IGVycm9ycykuICBCdXQsIHlvdSB3YW50IHRvIG9wdGltaXplIHRoaXMg
c3VwZXItcmFyZSBjYXNlPyAgSXQncyBub3QgZmFzdA0KPiA+ID4gZW5vdWdoPw0KPiA+ID4gDQo+
ID4gPiBJcyB0aGVyZSBhbnkgb3RoZXIgbW90aXZhdGlvbiBoZXJlIHRoYXQgSSdtIG1pc3Npbmc/
DQo+ID4gPiANCj4gPiBObyBpdCdzIG5vdCBhYm91dCBzcGVlZC4gIFRoZSBtb3RpdmF0aW9uIGlz
IHRvIGhhdmUgYSBjb21tb24gY29kZSB0byB5aWVsZCBsZXNzDQo+ID4gbGluZSBvZiBjb2RlLCB0
aG91Z2ggSSBkb24ndCBoYXZlIGNsZWFyIG51bWJlciBvZiBob3cgbWFueSBMb0MgY2FuIGJlIHJl
ZHVjZWQuDQo+IA0KPiBPSywgc28gLi4uIGJhbGxwYXJrLiAgSG93IG1hbnkgbGluZXMgb2YgY29k
ZSBhcmUgd2UgZ29pbmcgdG8gX3NhdmVfIGZvcg0KPiB0aGlzIHN1cGVyLXJhcmUgY2FzZT8gIDEw
PyAgMTAwPyAgMTAwMD8NCg0KfjUwIExvQyBJIGd1ZXNzLCBjZXJ0YWlubHkgPCAxMDAuDQoNCj4g
DQo+IFRoZSB1cHNpZGUgaXMgc2F2aW5nIFggbGluZXMgb2YgY29kZSAuLi4gc29tZXdoZXJlLiAg
VGhlIGRvd25zaWRlIGlzDQo+IGFkZGluZyBZIGxpbmVzIG9mIGNvZGUgLi4uIHNvbWV3aGVyZSBl
bHNlIGFuZCBtYXliZSBicmVha2luZyB0aGluZ3MgaW4NCj4gdGhlIHByb2Nlc3MuDQo+IA0KPiBZ
b3UndmUgZXZpZGVudGx5IGRvbmUgX3NvbWVfIGtpbmQgb2YgY2FsY3VsdXMgaW4geW91ciBoZWFk
IHRvIG1ha2UgdGhpcw0KPiB0cmFkZW9mZiB3b3J0aHdoaWxlLiAgSSdkIGxvdmUgdG8gaGVhciB3
aGF0IHlvdXIgY2FsY3VsdXMgaXMsIGV2ZW4gaWYNCj4gaXQncyBqdXN0IGEgZ3V0IGZlZWwuDQo+
IA0KPiBDb3VsZCB5b3Ugc2hhcmUgeW91ciBsb2dpYyBoZXJlLCBwbGVhc2U/DQoNClRoZSBsb2dp
YyBpcyB0aGUgd2hvbGUgdGR4X2lzX3ByaXZhdGVfbWVtKCkgZnVuY3Rpb24gaW4gdGhlIG5leHQg
cGF0Y2ggKCNNQw0KaGFuZGxpbmcgb25lKSBjYW4gYmUgc2lnbmlmaWNhbnRseSByZWR1Y2VkIGZy
b20gMTAwIC0+IH4xMCwgYW5kIHdlIHJvdWdobHkgbmVlZHMNCnNvbWUgbW9yZSBjb2RlICg8NTAg
TG9DKSB0byBtYXJrIFBBTVQgYXMgcHJpdmF0ZS4NCg0K
