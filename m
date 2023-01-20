Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98AB9675837
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 16:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbjATPLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 10:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbjATPLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 10:11:38 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87EF0DA8D6
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 07:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674227497; x=1705763497;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ERG7N7ed8T5wlMJqFP/WJnokUQn5qnTK826V2J5E2x4=;
  b=PqDOs4sZt9WiPd94ZIk79ELQ2Sh1SOQck12OxgKHOyZgU06W8YG6vlnr
   YL0YZAXpELmwo9J3zF6iaZ7iF7id3cuj/lPZCpcfSTbUGXDC2F6PryGYh
   klrry3FZsQI08Tj7Dt5qTRIta7ZwmaQlt1tPZqiPmaCJGDq6LuSB6bwB5
   9r6D4E5UVhDm7nXRfYY/+gahQvdfz4Za3kvy8JdfhvPjNKMu6zDGKtyff
   WAKhcdH7i0z7KVl+JmxCmnOKui5qzyWjpA/KdD+6RnqYASAsmK0NNaLva
   raZ+huorZN/cbgdM+lBTfs6oaBGyFhAtY8YmguOLwTAE7qJCKoLDtd3gB
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="390108077"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="390108077"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 07:11:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="660607426"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="660607426"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 20 Jan 2023 07:11:36 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 07:11:36 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 07:11:36 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 20 Jan 2023 07:11:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b4Lia0ncq3VdrFqsMU4YE1rZ/e5mA0G+x3QcCvCg6PB/2mM0a8oRCvZNx1tNtoXupQMMPaAm1/zahAkdnZGHl7QuyyA9Js7S/t4RKcSizNZ9Ee2aC+17QCKUZBTyWeHb+jCXbcJch/wB2yCyvFDNhiEkG0Sp5MLpgF441CVMlT0eAagGyG8pGFvBZuiQClEquq+06fKbkeaazma1L2IMu1LPO57VBaBnbuur6MKBq+lyVi1lhzKckPlC35Z0WHpoBoy72SaaCP3ttejiqVJDodXopLefqAdsNtg7uGmVdjvfip6emhh+Rhxt869uvzzuENyd62qUWahelcUKJj+Bqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ERG7N7ed8T5wlMJqFP/WJnokUQn5qnTK826V2J5E2x4=;
 b=LQjRdDn365pm+WCBkfXvmwhfs+XblOUt7J2olhYh3ZG9Q5D6qW5c/2uHet0X3AejhY6CXmfUXs6cTQQU2AJl2YbJW3p4Ap3uzlCg6xDOyKO99tARF/uOJRvEK7YXmUwl1lqBwo19qXOJx8Ti3HySkU6gCtVqSiJAjg9js+Nb5fXTIKzxFndMO2onUyo0R+keIkr6EaUY9Ac9Zk/0HYNsT7JE8mC+4Nn3RUI9oYS+5ej3S2y9GJ2F+75fW4qhXK6/gHY9uPQVK1viqfG6DqZtmnmzipZ+BqVibGyrtsjBInJi75wOTTQlPY3hHjfrn59lGaYTXMJHBWO7IoWxZXNWcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Fri, 20 Jan
 2023 15:11:34 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6002.027; Fri, 20 Jan 2023
 15:11:33 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
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
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: RE: [PATCH 05/13] kvm/vfio: Provide struct kvm_device_ops::release()
 insted of ::destroy()
Thread-Topic: [PATCH 05/13] kvm/vfio: Provide struct kvm_device_ops::release()
 insted of ::destroy()
Thread-Index: AQHZKnqZqWxc/vWNRUWu7aJW7tOztq6mHXaAgAE2HMCAAA/pgIAABu7wgAADYmA=
Date:   Fri, 20 Jan 2023 15:11:33 +0000
Message-ID: <DS0PR11MB752926DA7FFDD7E4F3C30C43C3C59@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-6-yi.l.liu@intel.com> <Y8mU1R0lPl1T5koj@nvidia.com>
 <DS0PR11MB752914C92FEFC0DB5278D8D1C3C59@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y8qmUa5RORED9Wd/@nvidia.com>
 <DS0PR11MB752955307C6C30D92938C914C3C59@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB752955307C6C30D92938C914C3C59@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH0PR11MB5832:EE_
x-ms-office365-filtering-correlation-id: 492849c6-8238-4379-77c1-08dafaf89e1d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SRu7hP9KZAWdm31HEQSk4P6hICfztDCyNyyO2ZIvybUSOvVWvM5My/4tjU/uUHVHt9vsSmb0KljJVvCSXibXrs65Ce9IjoHhYU5blbtBlVdxnIjeMKgl/myh6ZG+aC965xTBdyQoGhFm05664Quy3XqR/qrsxHvp9v5UEZ4N0ZjMvkwMDPp4NgZE1uR1583Q2JaXGw0PZI2kMj+6i473mULrxWCKnjDEVq8Jwj5LlVD1iqupigR0yNY5meI0NpbgeRc+Unlg4pGfhktyT34K+693c7y2fsu/0h5vB2h1CT988gXIOSnwd7HGCRYWtiMPNxLaJZaJEmHY4tSiDwIDAzvzFmx5wsuRJvvImzTvqWTvwT3h9ZFRta6I5wDhDpGdWsO3+aAV7Z6SW7co8oxfW/VcJwUppaWnlpZosaxcCTYF+KI9FA1zZuGEiHfOhZeC+unsxHsq665KhqrxqDuGaWbg3Sc7UyUBDaLy+uwKJAoH8ZNE0mE+cFBDXfjaK2b14z7GQv/ierffMtyRT5+NuwonqczkRiwyldLz0yRevZUg64El4Hih7h8KphVLPTDAoOHwr6sCBK/5CkNk8BjpHzRRWlaOFUT5RmFPpxjbz05LWaexf5nfbh8rQ/dcME8b3xbR5y7gpRTh1ggUrTO9UbjvJt8IeuLT5yPY6JDs4b81X/JjitQpf1SCBDPgzq/3+8RjdQoBTqz6CQ25fVieCPKh8uXxTE0Lhh8EyHGr2Ni+wMHAyeCbliS5czzA53qNKNCDqEOycC0cUonfR9/sCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199015)(38100700002)(122000001)(38070700005)(33656002)(55016003)(86362001)(82960400001)(7696005)(71200400001)(9686003)(186003)(6506007)(2940100002)(26005)(478600001)(966005)(4744005)(5660300002)(7416002)(2906002)(66446008)(52536014)(66556008)(66946007)(8676002)(64756008)(4326008)(8936002)(76116006)(66476007)(41300700001)(110136005)(316002)(54906003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QTNWczEza0hFR1lVZXJLRmJ3SkFPcm1JSkFIQUd4bUZheVVNRlZHZnZ0aG9i?=
 =?utf-8?B?TjF1RzJ2KzVTTlBJa1RTdmcrL2lSRzhaTlF5a0NHdTNrQUZ6OUMvekZFWmQr?=
 =?utf-8?B?RjlMbVRDTmkwbFpLaUxhQk8rRXRyTG5ScWR6Tm1ZaWFkSTJIeDgrcnU5R2dG?=
 =?utf-8?B?T0FLY2phQmFtaEtpdFpvV0NBcnpITThmalkvQWozNHEvWld0Rkl1MzRPZzFY?=
 =?utf-8?B?ZVNEbEpjZjNGYTVaMzFHbk4wOFhqbHRtR2tTcVI1YUpueUNBbngyREJGUGw2?=
 =?utf-8?B?Vkh6MDRKSmkvRUJtaGZuQ2NVMWZYNkpESmNzTnVpTjZ5KzJNNmlsZkVPdmUv?=
 =?utf-8?B?SzNyaGJsaGVpMmNGeEhTWHU0NXFsQ3J0RFN0dWpuR3IydTJoOGNMdmYxRjlx?=
 =?utf-8?B?bXZhVGZqY21zakdHdzh4OW1ERFZ3TjFuSHU2MkJETFBBU3cyOWpqM3hYaWtR?=
 =?utf-8?B?a2xUTW55WmR4WkxjZ0FVOXA4VFZaSEtSWiswMitZdWwySGU0MnR6RkhjRmxL?=
 =?utf-8?B?Qm9WNzdhWVVoN3p6dDRFYU1EOEgzS3ZjVzdiUXJSK1ZsTEJYWEJMTlN4ZU5P?=
 =?utf-8?B?eUoyUnp5czA3MlI0a0R3ZWY2cTdacE9YRklvSlRGOEF0SXIrR2RJblJFZjBZ?=
 =?utf-8?B?a2t6MEQ1UjNCUjlJTStIbGFRNW4xK0J4ZWcybkVUait1Y2lFeW9Edml1RlBT?=
 =?utf-8?B?bkx0anBIOGR4Z2JFYURJWkw0TXdFaFluVTcrbGdlZERzbVEzcUExNXJ4by9I?=
 =?utf-8?B?UzkxNWJPeGdITU8vUzlQR0VNcmh6a25jN1kvZ3Q1TE9GN1kyYTh3d0NhWnN4?=
 =?utf-8?B?WU5pc0VlSFo2VlZ6NWJhSGh4ZVFZMWJ1VW1YL2JxUUR6ckd4Rzk5RFhJS2hT?=
 =?utf-8?B?ZXVOdUUxcFRRd1ZyRUdoTk1yUGJnUGh3NUlyYUY2aFVsN1ZKR016aTZTd3NQ?=
 =?utf-8?B?UUkrUkVaK3lRaUZtSUM2cjh3ckM2WloyTEpWaFdmNldLVXdLbzZ0bVZIdUF3?=
 =?utf-8?B?c2plUDFNZHVRNFVDd016cVpMNFlQY2lidHovSzVucXVTcVB4WWFJZXRBZGg0?=
 =?utf-8?B?N2ZmQlpXVVl4Mjlzdk5mTUZvZnpqSkhNaTlFNHRBSUNvdmJocHlJNEtOYXdW?=
 =?utf-8?B?ZThkS0NHM0dDSThacUVvK3VPdHJSZ1d3S2JVZlFDQUh5dnUrZzNiaHNpYzdH?=
 =?utf-8?B?ZnJoT1VNZFI3QmJKTktzWjhkVDR3QjN2bDBTNmpHbGNRRm9WbEZvaUNDRUVY?=
 =?utf-8?B?ckl2MFBHQTN4WG5hUjlZS3ljZ0RhN3l1enU4OEprZjIvRnh4c3pkajJtL2ZZ?=
 =?utf-8?B?UHI2N05FM3VtdkNKZTEwUWxNc2hPc3UrOVVDU1FxQUR6UGVNczlzMlJSMXMx?=
 =?utf-8?B?K0c4SStBV1NYWEpTMTBIb0ROL2JCTkt6UFIydllOSSt5OXJBTTlvY1J0NHZq?=
 =?utf-8?B?RjcwUDcxeklGQVAwU0tXQXdud3doOXRKcFdyU0s0RkNzV2ErYUpaLy96ekEx?=
 =?utf-8?B?b1hWdTAvWFNxc3VsMWN5SkhZNlNidC9JQlBOU3o3VHJ0MzBiMFN0MzY5Q1BS?=
 =?utf-8?B?aVhnaUcwVGtKNWRlWDVaSUlLU29jeEJaeGc3QVExZ3VybVdJdDFBRldmeXV5?=
 =?utf-8?B?ZGRsckhIOTlUb1ZVeFZPS1RROVQ5VE9Cd2ZYZEdOcHpvOHNtVkZXZVc1L09k?=
 =?utf-8?B?WTJtZmJOQXdQNEZUeE5WRmhTS2pCRzZLMC9ldi9MOEd6UmViS25ZaW0xTkt2?=
 =?utf-8?B?VEdWN3UyREhTRUgxRUhkajFkanRrWkQ0RnRzWjk4TndKTjVzazB5WnBvN09W?=
 =?utf-8?B?cHVGOFBBajNoLzdqL1UxMXFmaURVS3R1dkVWdktuSGRpTzJwRlI2ZjZFKzFW?=
 =?utf-8?B?d3YybjZFc2diTWNqWXRzYnhuc243cTVUdENGMkJITW9YZEdma29oVi84WUYz?=
 =?utf-8?B?YmwwNVU3eUM3VmR1eUtkOTBoWjYyTTkvWEtia1ZmMGhuU0JqUFNhV1ZnRGF1?=
 =?utf-8?B?OWdBQ3NjMWI0RVlRWmNjWW5rdmpreVlTd0gxcnl5L1NHNDk1WG5MUExidlRp?=
 =?utf-8?B?VkxDbnZxNkdET2Q1Ryt4eTVkZ3dqY3BPL3IrSkJRY0x4aGxNWUpMUld5K0Rr?=
 =?utf-8?Q?J0ywDpVqmUZRiZ9lJpwC7gaDE?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 492849c6-8238-4379-77c1-08dafaf89e1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 15:11:33.7286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HPE93b+hUTNcxR58m29Ux3FnVu2r7j6ZGmjY5l8G+8XzxweBFKmJTWakDhe68bLu+h8qYqeXCCWOnEBVrWD+LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5832
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBK
YW51YXJ5IDIwLCAyMDIzIDExOjEwIFBNDQo+IA0KPiA+IEZyb206IEphc29uIEd1bnRob3JwZSA8
amdnQG52aWRpYS5jb20+DQo+ID4gU2VudDogRnJpZGF5LCBKYW51YXJ5IDIwLCAyMDIzIDEwOjM0
IFBNDQo+ID4NCj4gPiBPbiBGcmksIEphbiAyMCwgMjAyMyBhdCAwMjowMDoyNlBNICswMDAwLCBM
aXUsIFlpIEwgd3JvdGU6DQo+ID4gPiBTYXkgaW4gdGhlIHNhbWUgdGltZSwgd2UgaGF2ZSB0aHJl
YWQgQiBjbG9zZXMgZGV2aWNlLCBpdCB3aWxsIGhvbGQNCj4gPiA+IGdyb3VwX2xvY2sgZmlyc3Qg
YW5kIHRoZW4gY2FsbHMga3ZtX3B1dF9rdm0oKSB3aGljaCBpcyB0aGUgbGFzdA0KPiA+ID4gcmVm
ZXJlbmNlLCB0aGVuIGl0IHdvdWxkIGxvb3AgdGhlIGt2bS1kZXZpY2UgbGlzdC4gQ3VycmVudGx5
LCBpdCBpcw0KPiA+ID4gbm90IGhvbGRpbmcga3ZtX2xvY2suIEJ1dCBpdCBhbHNvIG1hbmlwdWxh
dGluZyB0aGUga3ZtLWRldmljZSBsaXN0LA0KPiA+ID4gc2hvdWxkIGl0IGhvbGQga3ZtX2xvY2s/
DQo+ID4NCj4gPiBOby4gV2hlbiB1c2luZyByZWZjb3VudHMgaWYgdGhlIHJlZmNvdW50IGlzIDAg
aXQgZ3VhcmFudGVlcyB0aGVyZSBhcmUNCj4gPiBubyBvdGhlciB0aHJlYWRzIHRoYXQgY2FuIHBv
c3NpYmx5IHRvdWNoIHRoaXMgbWVtb3J5LCBzbyBhbnkgbG9ja3MNCj4gPiBpbnRlcm5hbCB0byB0
aGUgbWVtb3J5IGFyZSBub3QgcmVxdWlyZWQuDQo+IA0KPiBPay4gVGhlIHBhdGNoIGhhcyBiZWVu
IHNlbnQgb3V0IHN0YW5kYWxvbmUuDQo+IA0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0v
MjAyMzAxMTQwMDAzNTEuMTE1NDQ0LTEtDQo+IG1qcm9zYXRvQGxpbnV4LmlibS5jb20vVC8jdQ0K
DQpXcm9uZyBsaW5rLiBCZWxvdyBpcyB0aGUgY29ycmVjdCBvbmUuIPCfmIoNCg0KaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcva3ZtLzIwMjMwMTIwMTUwNTI4LjQ3MTc1Mi0xLXlpLmwubGl1QGludGVs
LmNvbS9ULyN1DQoNClJlZ2FyZHMsDQpZaSBMaXUNCg==
