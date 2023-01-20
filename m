Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8545675531
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 14:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjATNDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 08:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjATNDY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 08:03:24 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590B82D5E
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 05:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674219803; x=1705755803;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZscdwvHsXBOqT0TGubDkkSOYlR3bQYM7I96gUDabtXA=;
  b=EnH/70gkAwL9xDZM8+e12RPlNFJ/tYKR5WIBIzVkSRUhGwxvuLJMGlS6
   X6hrYDe0vWHL6flxD+lEt/UBEZoQu+poq4ZXMLsbpsk13jvQWEBIJXV1u
   HCMc0n1AjqB+W3kDDUEJoHNuUmzwqsQ5Ci3cmcQkN05jEhqCjG/fM08l3
   LITjt7KyQaREDcJZIErNicwkLoPYjs5bOwaeY4eyqJYOMeKYMq9eegbWN
   DNMSpiDTUbEgTz1gVj9WTSAYVm3gpQFfEnTA27HAh8bo7awFzlFbIVfXK
   hJAOwTP75LhFyC0GOHlkFOC0Zs5UYKHHeA4oKQep2YbB4nekpmiLZD/so
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="305245129"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="305245129"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 05:03:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="768687716"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="768687716"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 20 Jan 2023 05:03:16 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 05:03:15 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 05:03:15 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 20 Jan 2023 05:03:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0/zj3Vb3zYARbhn478RG4atybltL1b2dOZp/tkExquDv/2HQnjUO3CO46B/A3agln3X1Cobrkw2XuKwyZE1IUIfkVhzmfembqX+dW4xmZeSPDDF6C2qzelWSPHljAxssPhnshtUoM04iM0JQjSA57ywjpV4kKDeP7tE0Xus7uoG9UeWKVYuLYW7hErmA33FuB6kXrJKkZlZPItSmHvqpcwotrtN8Hz7+9HJfSiW0gs2sAn6oEkZsRLel2aJL4PDJRIsvIpcVpzy2UXV5HD+Kf5StF6B9YEgQR2w2XVA/SpsyiaZf8Sg9BGNKanGBDtNkvLoCqI9xClyQvGZ+LD1hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZscdwvHsXBOqT0TGubDkkSOYlR3bQYM7I96gUDabtXA=;
 b=TCgRHZRc5ex8PsYITkBJDZg7LROsvM4yi0dCDz2SPH0htmTHH3u8cBtAiQZ0OeS+mocuwGGSPPdOfOBUAftKh1ZkibuhG09z9FH1LWfMKSMy2BiXDpo5SWw3c40FETThY6byfsm8529DF94mA4adyQLdFxXbeB2wSLJCk4PEvXJbENxfJxHq7koENkF9YwQqgbnE7KJSq3z28m28AyijC8R69UxDKS25rdcC261hGfYgM2dx4NqaECB9mjCy0yjGxJPpCMxqiYzmlxYR8iINxGmdH8HbS432gV6RMjftCLdBGcFsuQvdSNM6aovebz3QKgd/tzwpg1YeQ2yDKT5eNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH0PR11MB5491.namprd11.prod.outlook.com (2603:10b6:610:d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Fri, 20 Jan
 2023 13:03:14 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6002.027; Fri, 20 Jan 2023
 13:03:14 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 05/13] kvm/vfio: Provide struct kvm_device_ops::release()
 insted of ::destroy()
Thread-Topic: [PATCH 05/13] kvm/vfio: Provide struct kvm_device_ops::release()
 insted of ::destroy()
Thread-Index: AQHZKnqZqWxc/vWNRUWu7aJW7tOztq6mHXaAgAEsdyA=
Date:   Fri, 20 Jan 2023 13:03:13 +0000
Message-ID: <DS0PR11MB75297A3B142BC4D68C5CBE9AC3C59@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-6-yi.l.liu@intel.com> <Y8mU1R0lPl1T5koj@nvidia.com>
In-Reply-To: <Y8mU1R0lPl1T5koj@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CH0PR11MB5491:EE_
x-ms-office365-filtering-correlation-id: 65d186cf-303f-4151-4e54-08dafae6b0b3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hnNEE6HcU0xeSl2jiy0d/pugT1W6cEyw5YySslqgvlCKc/sqtiPj/wvHCeoSavuzqY1VHDGmCgKhxVCd0QmUny9FL8J7i9w2XuzZfh4wg4oOA0kJr1CA9KT31ELOJciaWctQ5tOV6FSU0ELFQfOM7fD5b7yTWxxxZr5g9TfJMvzrnGaykMi1TE3RkDV7ECqm+J7X4H3uwbJ6SRBk+9bVqI42GN4hs1zi8p2XrooekK4hvmAJOiqsUc6DUbb5FEExkH8cWkfyKDN09uJ/2uXfymBe1/Qt0jxOpQd9nwU5TQZgNnlqddJ8RohUlHLKtmupAphkh3wqstjUmKrgQCX+5Q8gByx/BI9SxnJbFGyayGOpZlmXC1T1h0FTKoHpLl2EKOoaY/BakogS/TvBXwA1IwhtHNmnuai96V8puTL4CeQNbY+grcJoGvYDaqhZwd6kjIXjLsCkodMy8tbkhOrrb4qRO8/Azza8z/NPoNbNzOyP7TKOvi93XCJ/XkGVFbGLicJI5wP9CZsJNoWIAwMHHATrP+5aEHboVAU3vlGEistGrEp9/2TigPdjbT49iGV7MEx3bsnC0ePrBTWQbprq1G+EVOahsnE4HkuUJfP3tRMhE+9+/jX6p4TjPNuLICgy3UDtFw95sY1XrxtbvglzAsGYu3edZg9xvo1MW2qjWG73dFgReYQazP//ntB01TeEJjx8EbGXdWWv73OAGQfv+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(376002)(396003)(39860400002)(136003)(451199015)(186003)(26005)(83380400001)(38100700002)(55016003)(9686003)(2906002)(86362001)(478600001)(66946007)(7416002)(76116006)(66446008)(64756008)(66556008)(316002)(5660300002)(4326008)(66476007)(6916009)(8676002)(82960400001)(7696005)(8936002)(54906003)(71200400001)(41300700001)(38070700005)(122000001)(33656002)(6506007)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0JiUUsreHVYc0FOdW5CUkxWa3lHSCtFOXI3dHRCUzVKaWJRZWl2VWEzUjlM?=
 =?utf-8?B?R0xPeTJOSjFKbFhEMGQydHNxY1AzdkNscFJoaHAreXdxUmhnd0ZNbXNGZC9o?=
 =?utf-8?B?MTh0cEhBVmRFdzVmNU5EdjlvNnZZa2hVZnh0c3ZJZ3Q2RTR4YnNTSmQrWUNo?=
 =?utf-8?B?UENKaFkwR2tkWW51MzBTMG54amJvTDJDRDkyM1ZrYTdRS0pXbkZpSmQzZG4y?=
 =?utf-8?B?dzIrQ1h6RTViMEZFVnRVa3hGSkYxL1dpTXpiZVljeC9HRnB0UmVvVzhUbE84?=
 =?utf-8?B?RzIxNjZxcVIyaklOeFQ4Vll5MFE0T1AvYk82bU5jZHpLYXVpRzJOQ3BBUFFW?=
 =?utf-8?B?K3BwUkhyU2hiMlp2ZW4ybWd6Yy8raWExMXFZMUQxUno1Z3ZuMzFzTFNuWTQv?=
 =?utf-8?B?cm9JcWZXZEdUOEc4SEw2Y1ZZejVJZnM3ek9SZVlkY2NXaGhUZXRtZ2RROWZr?=
 =?utf-8?B?VUNmRkt4UDdoSnpDNE5jZ1VoWW1mSm0yTTVxYStnTmV0WWVML29NVlZvUmJB?=
 =?utf-8?B?YmF6Y3ZtZlh2Zm1JNmdaMWJuUHlVMnVzaU5lbFhjamFHeWZ3bHhBcXc3bSt4?=
 =?utf-8?B?SmVNV0RROHc0UHN2WlY2ejREZlZ1aVRkQmxtNUZ4SVpkQUJUUVNUUlRMenRv?=
 =?utf-8?B?L2E5Z1R4a1R1WjB0cXhzclhpTit4MEYva0poTE91Z1VjanFROHpINUhkakkv?=
 =?utf-8?B?WC9aMUJhWUFzT0o2bFJlZHRpZE51ZURJbGZqWDh4a2FzTlBWbWJBaDlTRnNS?=
 =?utf-8?B?V0JqVFZWQ0dQcFJ6NTZmdEdVMFJOMnlxcmIwRG4xYlZ3aDJ6am5TWXF5eXJC?=
 =?utf-8?B?U3FqU0Z3VC8vVmRYSG5Lc3FYSUxIaDBROUtibnhPVXRWNnk1Q2VETTMrQmdp?=
 =?utf-8?B?R2tLTEdKRTZZOCtQSVJ4OHEzdnZjV1NmaXhRVTVYT2xOTTN5eFFDY2k2TDhp?=
 =?utf-8?B?L09CUGZjaDBiVTlJcXR2US9ydkg4VnRyR1hheWFPNExOTE1ucXRqOTl3N0Y1?=
 =?utf-8?B?UWJJLzkxTzhNdnAzOXo0SkVOZ3g3OHhHOUExM3Z6V3kxc0N2cVhVQVNtRUZ1?=
 =?utf-8?B?QnV0TXRsOGJxMnF3c0UwWDBGb1YyRy9YNEprOFNTSEg0ZHVMeEhsd2RxU3o0?=
 =?utf-8?B?R1VPQXZlMnpUalNRcndIbzVZdVpIdS9wNFBncStER3NiQVFoemJ5MWxPU0Zs?=
 =?utf-8?B?WXRLV0VDb0pTcFJWUkdMM2NnSmRCTWZ1VEFScHUrWTByUFQ0S21pUDd6VmYz?=
 =?utf-8?B?MW5BUmZhRndIeDZFRTcrNVBZdWJLUUJmQ0lSckNpdTBTSEVON2tRcFgydTRC?=
 =?utf-8?B?SDdRZlZ3SG1NeVh5M0VuazVCZzY5VmJjaXBlMFhVUHl3dGFHb0RwNERxZWJk?=
 =?utf-8?B?MXh1NU1SbkF2WE5HMXBPTzdHY1FJUHNpTUNvM2U0aEF2Y3FVcmNQeFYrWDZx?=
 =?utf-8?B?ZWdtRndIajN3cDl1UW9ycHU2MjBuSVROTkFRWDdmQzFpM0k1QStadkpDeGI0?=
 =?utf-8?B?Z1NIQStZMFdiNEpFSGU4bTgxRnF0OFhQcjZDMWphUzc1ZytZUnR3TFk5SFFz?=
 =?utf-8?B?bURSZGpEajhTRWRYeDlNUEFqZTVzSkp0TUw1RzNucytsejNGMlN3dUhqNEpP?=
 =?utf-8?B?SVRKb1BYV1ZFUlBNcUVDU2NHOWIwTmtIN201T05yV0xIZmlNK1lucXRSeExo?=
 =?utf-8?B?eFNDcElWNUoxeHhpTmd5Z21PUFRkdHpWNDhJcERKNFdieGYwZGE3THZIWnNH?=
 =?utf-8?B?WGJtRU1QQmJycnZCT3dncExBTmNQSjVmMEdhMGJ5RjVUWnlZQWdEWUN3RXdv?=
 =?utf-8?B?TGtVZURMekllRjZvVGtUc1RtKzJnQUdSdEZ0SUxJckVRT0xGeDZoM0xpY0dR?=
 =?utf-8?B?VG42cHdxeXh4R1BLUVpnT2d3WGZLVHFZcmFGbUJUVWV4YzYrSXlhVDdsUjlx?=
 =?utf-8?B?YUtXUlNsWmJ0NFlZU2NKRUxrWllqYzJPaWJqN29vSU5PUEdJY0ROb00yeitl?=
 =?utf-8?B?cmJwRjFrSnJJVjhzUlh1SE5zNHFJRzFyQ0pBbXEzY2M3VjdTVDNxeEpmTEl4?=
 =?utf-8?B?VDN4TGdCbmxYVGpxcUpWWW5NTEE1bFJrT1ZtMTBHU1E4MnBrWFVwTllJai9L?=
 =?utf-8?Q?x2D6kxHHb5IRlSipBDR4lx++A?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65d186cf-303f-4151-4e54-08dafae6b0b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 13:03:13.9840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tFd1BY+7nAGC/9F9IkkSTonBOPhKEHNsuMKEQScrzQ1t/yZ+xKdjs262L1r0JitU24L2XC7JcNbq+2/mJXwc9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5491
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBGcmlkYXks
IEphbnVhcnkgMjAsIDIwMjMgMzowNyBBTQ0KPiANCj4gT24gVHVlLCBKYW4gMTcsIDIwMjMgYXQg
MDU6NDk6MzRBTSAtMDgwMCwgWWkgTGl1IHdyb3RlOg0KPiA+IFRoaXMgaXMgdG8gYXZvaWQgYSBj
aXJjdWxhciByZWZjb3VudCBwcm9ibGVtIGJldHdlZW4gdGhlIGt2bSBzdHJ1Y3QgYW5kDQo+ID4g
dGhlIGRldmljZSBmaWxlLiBLVk0gbW9kdWxlcyBob2xkcyBkZXZpY2UvZ3JvdXAgZmlsZSByZWZl
cmVuY2Ugd2hlbiB0aGUNCj4gPiBkZXZpY2UvZ3JvdXAgaXMgYWRkZWQgYW5kIHJlbGVhc2VzIGl0
IHBlciByZW1vdmFsIG9yIHRoZSBsYXN0IGt2bQ0KPiByZWZlcmVuY2UNCj4gPiBpcyByZWxlYXNl
ZC4gVGhpcyByZWZlcmVuY2UgbW9kZWwgaXMgb2sgZm9yIHRoZSBncm91cCBzaW5jZSB0aGVyZSBp
cyBubw0KPiA+IGt2bSByZWZlcmVuY2UgaW4gdGhlIGdyb3VwIHBhdGhzLg0KPiA+DQo+ID4gQnV0
IGl0IGlzIGEgcHJvYmxlbSBmb3IgZGV2aWNlIGZpbGUgc2luY2UgdGhlIHZmaW8gZGV2aWNlcyBt
YXkgZ2V0IGt2bQ0KPiA+IHJlZmVyZW5jZSBpbiB0aGUgZGV2aWNlIG9wZW4gcGF0aCBhbmQgcHV0
IGl0IGluIHRoZSBkZXZpY2UgZmlsZSByZWxlYXNlLg0KPiA+IGUuZy4gSW50ZWwga3ZtZ3QuIFRo
aXMgd291bGQgcmVzdWx0IGluIGEgY2lyY3VsYXIgaXNzdWUgc2luY2UgdGhlIGt2bQ0KPiA+IHNp
ZGUgd29uJ3QgcHV0IHRoZSBkZXZpY2UgZmlsZSByZWZlcmVuY2UgaWYga3ZtIHJlZmVyZW5jZSBp
cyBub3QgMCwgd2hpbGUNCj4gPiB0aGUgdmZpbyBkZXZpY2Ugc2lkZSBuZWVkcyB0byBwdXQga3Zt
IHJlZmVyZW5jZSBpbiB0aGUgcmVsZWFzZSBjYWxsYmFjay4NCj4gPg0KPiA+IFRvIHNvbHZlIHRo
aXMgcHJvYmxlbSBmb3IgZGV2aWNlIGZpbGUsIGxldCB2ZmlvIHByb3ZpZGUgcmVsZWFzZSgpIHdo
aWNoDQo+ID4gd291bGQgYmUgY2FsbGVkIG9uY2Uga3ZtIGZpbGUgaXMgY2xvc2VkLCBpdCB3b24n
dCBkZXBlbmQgb24gdGhlIGxhc3Qga3ZtDQo+ID4gcmVmZXJlbmNlLiBIZW5jZSBhdm9pZCBjaXJj
dWxhciByZWZjb3VudCBwcm9ibGVtLg0KPiA+DQo+ID4gU3VnZ2VzdGVkLWJ5OiBLZXZpbiBUaWFu
IDxrZXZpbi50aWFuQGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBZaSBMaXUgPHlpLmwu
bGl1QGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgdmlydC9rdm0vdmZpby5jIHwgMiArLQ0KPiA+
ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IFJl
dmlld2VkLWJ5OiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiANCj4gRnJvbSBB
bGV4J3MgcmVtYXJrcyBwbGVhc2UgcmV2aXNlIHRoZSBjb21taXQgbWVzc2FnZSBhbmQgYWRkIGEg
Rml4ZXMNCj4gbGluZSBvZiBzb21lIGtpbmQgdGhhdCB0aGlzIHNvbHZlcyB0aGUgZGVhZGxvY2sg
TWF0dGhldyB3YXMgd29ya2luZw0KPiBvbiwgYW5kIHNlbmQgaXQgc3RhbmQgYWxvbmUgcmlnaHQg
YXdheQ0KDQpTdXJlLiDwn5iKIEknbGwgcmVuYW1lIHRoZSBwYXRjaCBzdWJqZWN0IGFuZCBjb21t
aXQgbWVzc2FnZS4NCg0KUmVnYXJkcywNCllpIExpdQ0K
