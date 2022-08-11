Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4457658FA57
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 11:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbiHKJ7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 05:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiHKJ7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 05:59:44 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CFD91098;
        Thu, 11 Aug 2022 02:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660211983; x=1691747983;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Gv61OZzolzLnpab2sSXkmej5Y3qmjVqSAapMQ21hGpY=;
  b=n7L4o9T8kEm02qFmYPWennW2Vzup1FnT/mrrMEAKmLfFL5uLldeeAkgU
   kSfEYzqafEbhBnDm4758JC0aApRn67mBnUvBqNJEBIWCEs0fXhu4FlCCc
   NKWm99u+tqqBPnTt1ag1dclc4nDtlrtjpBNvwAB0HMHY2jPoV8Vb50Sfp
   y0LHlEoeMvrAk5q1+Rr/EU566Cf7xr1TEhCmohxBrUfTWOTM5qIufvdK8
   Zrdeb3XN4w7rO1MqcfvGUw/gOcW/oBSd/ffMMVM5GA8lm1QNBMe//SV4u
   uJzK3o7KZB4c5RKIIuSOpVCcIaC1HjyyzjUOLur0Ao5s0ZMMWs8DbnlRu
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="317270028"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="317270028"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 02:59:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="851152031"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 11 Aug 2022 02:59:42 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 02:59:41 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 02:59:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 11 Aug 2022 02:59:41 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 11 Aug 2022 02:59:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6nfj24p/4y5VhHZB8aclP6cmdU1RUug66RpcgBpLAeJSPmYy/BeyID7jigQsOVHe5u05ofwT4Yk3qtEzXmGQqPnsi1SZ3MDl8U1IyIcA6wswRQeYiaBX9qV38RchsmJqf+ORlSvb9Ne+T2DQA2FjFSFgqqQx95ySLit5X/G9BA1qCydmMoT/NxcFUcuc2/uVeZLgT8kXNH37atW2PbZ5krkMEmuUI+TU0ivNdHJ6ss11lyuhDw0xF2PZMHJ18qMFOs1y16G9eJgUTVSJioWiTwgLND/Jp79NFBMFiNcXznRXjaU5iyMcPRJd6nA3pfCJMx76OuOID3LzoN9W2/gog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gv61OZzolzLnpab2sSXkmej5Y3qmjVqSAapMQ21hGpY=;
 b=gO1T6AVr77Fvi+FliR4YoQXCtyyfly/sxQSY4cufPj3cC8MphQCuNMhaa8WuyvU/ciQ/OyZQ/WafkdX4EYNDocE/J2qhLl9S5flvQ6/fWc62HlZspki2oBuxIndkE2fnYs7l6zClB9/KwG3peIg1LEVgPkABCCkqmaDZhy4049ApzFeZ9bG3dCSBL9eSwnQYhjzrDL/Knmr8GqF0x8+i6kITrfhBqSOmUWKnQiop/c8cDoTn8OOTQJQ/DqRmrK/utB54vEh1JV17jsq16lolt/Um5ou00Mg1eZ2qXhi7dkP1jWSwnLsfTKxsX/5HbPukU8my2Bh7Ez1n40uZ26qpsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL0PR11MB3489.namprd11.prod.outlook.com (2603:10b6:208:75::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Thu, 11 Aug
 2022 09:59:34 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::1d3c:4dc0:6155:2aee]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::1d3c:4dc0:6155:2aee%4]) with mapi id 15.20.5525.010; Thu, 11 Aug 2022
 09:59:34 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v8 002/103] Partially revert "KVM: Pass kvm_init()'s
 opaque param to additional arch funcs"
Thread-Topic: [PATCH v8 002/103] Partially revert "KVM: Pass kvm_init()'s
 opaque param to additional arch funcs"
Thread-Index: AQHYqqltAL+hwNvkbk6t2QHjbAxA9a2pfMgA
Date:   Thu, 11 Aug 2022 09:59:34 +0000
Message-ID: <c2e61778ca549e8ee4cb44194df367455a20f645.camel@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
         <3af25cc7502769b98755920807bc8a1010de1d45.1659854790.git.isaku.yamahata@intel.com>
In-Reply-To: <3af25cc7502769b98755920807bc8a1010de1d45.1659854790.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.3 (3.44.3-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0290a59-0792-4e39-4721-08da7b80316f
x-ms-traffictypediagnostic: BL0PR11MB3489:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9DNqCoFmzE9bShFi/wkT46otw5C0i+AzHCd1rLB9UbVgSwEs0WyIkQNXmXmh79KPOnxOYg5C3PUXuwgYdQdIs6M0pNYNf2zsu9mEscBRMxTA/lfcUaCTd7HfseL0QJYnC9oktdKC75rMO56y5+ItRrw4BjyM9PilWWEOk88TIgKdH+v/EqAcfsP1kOnWS7OHpzhukXF3UuEjNxCF7Ha2dwVb70utlgRQMAycmZQAq5WAGgKJ89As6/osQ9x2E4dQIReWuxTS7OU3t85ujSRylrPNhU3xz0RHGEv1JnDYgANpbYqJyNXyQ0vQ6AKNArWLxiaSkWO0veg6DwZZdri6Zxr6ndYpJLeXGy/fH88qKGEMVIUNSQWDdBj7QgVp+tw7UKFAIfJbMifslnKLJ4jcd2yncsrMHs79sGrdKxfpzYajTdkh19W9nj993NmqguNPzcVCu/M05kG1rMHTpe6eiw7hGsE9sbiqQGAZ3hOQNmST3N1yNys2ruKC9r5YgRZQCv16OKsWJUVqz2RkMbUTQFKvJlXEP+JLgFHXSTgLjKt0a1tp13XfOukz+AMRImcSnIWe9nIHgqZ1QgWaVRgafW6RfgN/aMkr1uF0TH5WTzeIjQ4S3LPj3Cn+CAAUuLeBMNNxr/fKZMWp5LoGMpfpqjeQPhD40r2IXgfRKqb3de7Ws2F6cfhJzmySYispJYUzeLEUNFhCVlt6ugIHSSGbbrdJJrVlf4fBUKyoogF3L+a8sCbADfYo2MpgDbT8XNPRhnL7KfNN7I3D0Lfw++mWIbWx4ttB31556qmT1wpnezFuGm5x1HZ6EGsescmL/uEXcXNQrX3jbGIQFQmwGLz2Jg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(376002)(346002)(366004)(39860400002)(86362001)(2906002)(71200400001)(64756008)(66446008)(66476007)(76116006)(66946007)(8676002)(66556008)(122000001)(4326008)(38100700002)(91956017)(8936002)(316002)(82960400001)(110136005)(38070700005)(54906003)(6636002)(5660300002)(41300700001)(186003)(36756003)(6506007)(2616005)(6486002)(6512007)(26005)(478600001)(966005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZnRUa0dRWlVIalh2bXA5UTg0ZHVDVjlwRnZXT1JnQjZpVFlWK2ptVml1RHZx?=
 =?utf-8?B?QXBSOEhqdnBXWW1KY0psREphNUhWNzFsU01kU1lVRTFEdnU4Y2h6RUFXM0Za?=
 =?utf-8?B?eUZ5M2QxOEQwdHhEYXZHbWtKWEdlYkVaWEV0MmVxSzd4ZkFma3VaTXJMSFBH?=
 =?utf-8?B?aERNdWxkTlJiMllJdDdCWEFXU0ZZNzlKbjExRytjcVNaMnNEWTFMVjh5ZWFV?=
 =?utf-8?B?WFB4ODJWcGxSQUE4RTA2NnRaYmJ4ckpTWVNEZXY4VTIvNTZiVVRmditwVGUx?=
 =?utf-8?B?Q1dUQUNxaG8zOVN2WU9JRjlZQVpDaDArR3VaSURERnZ6T0xlZ2luNmtmN3Iz?=
 =?utf-8?B?Z1cxc3VGOWwwNzBxNHpUTEZSL2FDRjV2SFdmQit4Q05xK3JPWFVvUWtsK1Rh?=
 =?utf-8?B?djZYUDFEbHhoMmFHd2dsQ00wM1dpZFVoaE4rMkQ5NlhuaXRkcVE2K3UxVXlp?=
 =?utf-8?B?NXBtSTBUTVI5cDJjd2RnREtoRVJiVkVSQTZieUZNUFloazgwUDlEUkFuQjFV?=
 =?utf-8?B?RW1IQkNFZnkvTlRpdTBlb2xaSjlvZUhITy8zLy81d0VJcFNNTDliNVVRVHF3?=
 =?utf-8?B?OVhaMzE1SWRoQlFNVkZ1OUV4ZXpYV1htMG1naWZxeDU0ZlN1QTUwT0I2dVBi?=
 =?utf-8?B?bHllMEw2Ti9VckRIVC9JMjFnQnBLcFlJVW1Kd1hRMUZ2SEQ2anFJQjVhMW9J?=
 =?utf-8?B?eGpLbE5YUjFLUFlSMWVOc3hjdVJveUFDQ0ZTMG5JMTcwVTNPVFk2elVYSDZI?=
 =?utf-8?B?dlA4UkJnWFQrd1FGUEJjSGtNU2xJekY1K1lIUHhNWndhdTBlZVAyRlRaZ0Fh?=
 =?utf-8?B?NFlOTzFUWlk0THVYZDBlejlHNXFWNzkxNVpKV0x5ZFY0Z2gyRlp0akVvdmRO?=
 =?utf-8?B?SlRwYnUyZjR0R1NMd1JVaDR2bXhOL3pIa0VCMlhLTVFIZE9ZMkIyUkRWT1Z0?=
 =?utf-8?B?US9NT2JjckNVb3pRSnNINWx2WEFWbmJTbW9kYXFzbWsyc0VPTk8wV1N6YmZE?=
 =?utf-8?B?VldzNkJ1cUlrTlJyeGkvQ0ltcCtBTXd0ZDVCUGZRblZaV3o4UDY2UHlYbXdq?=
 =?utf-8?B?SzdvRVNvWUpHTE1HZGR1NjlDeTVETVAwY2I2WmpiTVNlY3lRZjJWeVA3cjkx?=
 =?utf-8?B?MkppMU9iQ2cyVytPTVRqS2t6RFlnSVBqWng0bllHbEkrSG1nc3hOMWhDNjNI?=
 =?utf-8?B?Ymg5MjRjV3g3RHdCdFJnMU4yL0hzeE8rT1hFUWRSUGRhSTVWdGlIRnpJYlRj?=
 =?utf-8?B?ZG0yMGk4cmY3cmthTDNGaFZENnN2S1g3Y1V1cW9RTDhwS0tpUWxJNGV0cUlD?=
 =?utf-8?B?eUdwYU9WOFh3dkhVZURaSTAxOVF1ckZ1NVlUK2xZMTZXb0c3ek1VOXBOQ2p1?=
 =?utf-8?B?R2dkSVpBaWZKUnJIai8wdzhpbWsyOWk2V2JQV1lRcG9KR3ZDck1OUU5RTVhy?=
 =?utf-8?B?dUpxQVgrMXZQYmxLUTF6eUo0NSs5dWZVUU5BbEx2RWpLbTZhYTA5dmpqbm41?=
 =?utf-8?B?Q0k4R1MwTFNUQmMxOEFTSU04UEx5UUxHTTNqN1JNaEhPOGtVNEw4bUpjdHF3?=
 =?utf-8?B?MDZ0bllkZjI5dXduN2F1REFvZWd3dGdxQlVZVCt5T25CQktocTVvR3A5VlRv?=
 =?utf-8?B?TGRXeTBPUElNejhka0tEQ3BWaUVVY1M0SEJoQjhhTlZCQXQ1cFM0YnhZRG9P?=
 =?utf-8?B?bWFmMFFRU2IxamtSdHBZSHFDMjRoUHpjTko3Z1l0dHV4eW5hby9PNFJjL0JK?=
 =?utf-8?B?NjlRWG9wNUxSa0JqUldpenkwdXhuK2FSeUJCUW1tZTMrcWRDZy9NSytRL1Jv?=
 =?utf-8?B?aXpkd2h4VENKMzA4LzRLWE9kODYwTndqZ3FIUjJTaGt5Z2RCY1A2TnJsRXV2?=
 =?utf-8?B?SGVxbzNaMzV6OTdraG5RTTNDYWZYdTZJbEpxQ3hTK3hzMGRDMDllQkRoTi9n?=
 =?utf-8?B?TmNZOFBVWW1LY2tpbTdRSy9RWitwbi8vK2hoYXVhTTlGSGFVbWJCbVFaOXJN?=
 =?utf-8?B?MVJueDVDdytCR0hHMUo3SWRiR3NRbjIrL0Q3SS9OdU0zZXBmdk5lTHFUVDhy?=
 =?utf-8?B?SkVvTHJQMmhnWC9mUloydENseXhuUUQ0RlFIU0RqaWoxenJIZGc3YnFJbU9V?=
 =?utf-8?B?RU85d3FiUnp5ZVVaQ0RRNDRLTGFyeGFFam9uYTNjK2k4ZlNpZGl4NlhuOEw2?=
 =?utf-8?B?MFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <35BD30D8F903174F89525C8942A2C70C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0290a59-0792-4e39-4721-08da7b80316f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2022 09:59:34.1284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +A8/VbVVeXoMFlVpE1+/6YXpkBC7VZJNqJ29nGkNLbmirw2qML0BfkN3TTH2HfIhsJgsX1o5IIJQOWAsaQznRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3489
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU3VuLCAyMDIyLTA4LTA3IGF0IDE1OjAwIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IENoYW8gR2FvIDxjaGFvLmdhb0BpbnRlbC5jb20+DQo+IA0KPiBU
aGlzIHBhcnRpYWxseSByZXZlcnRzIGNvbW1pdCBiOTkwNDA4NTM3MzggKCJLVk06IFBhc3Mga3Zt
X2luaXQoKSdzIG9wYXF1ZQ0KPiBwYXJhbSB0byBhZGRpdGlvbmFsIGFyY2ggZnVuY3MiKSByZW1v
dmUgb3BhcXVlIGZyb20NCj4ga3ZtX2FyY2hfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdCBiZWNhdXNl
IG5vIG9uZSB1c2VzIHRoaXMgb3BhcXVlIG5vdy4NCj4gQWRkcmVzcyBjb25mbGljdHMgZm9yIEFS
TSAoZHVlIHRvIGZpbGUgbW92ZW1lbnQpIGFuZCBtYW51YWxseSBoYW5kbGUgUklTQy1WDQo+IHdo
aWNoIGNvbWVzIGFmdGVyIHRoZSBjb21taXQuICBUaGUgY2hhbmdlIGFib3V0IGt2bV9hcmNoX2hh
cmR3YXJlX3NldHVwKCkNCj4gaW4gb3JpZ2luYWwgY29tbWl0IGFyZSBzdGlsbCBuZWVkZWQgc28g
dGhleSBhcmUgbm90IHJldmVydGVkLg0KPiANCj4gVGhlIGN1cnJlbnQgaW1wbGVtZW50YXRpb24g
ZW5hYmxlcyBoYXJkd2FyZSAoZS5nLiBlbmFibGUgVk1YIG9uIGFsbCBDUFVzKSwNCj4gYXJjaC1z
cGVjaWZpYyBpbml0aWFsaXphdGlvbiBmb3IgVk0gY3JlYXRpb24swqANCj4gDQoNCkkgZ3Vlc3Mg
eW91IG5lZWQgdG8gcG9pbnQgb3V0IF9maXJzdF8gVk0/DQoNCj4gYW5kIGRpc2FibGVzIGhhcmR3
YXJlIChpbg0KPiB4ODYsIGRpc2FibGUgVk1YIG9uIGFsbCBDUFVzKSBmb3IgbGFzdCBWTSBkZXN0
cnVjdGlvbi4NCj4gDQo+IFREWCByZXF1aXJlcyBpdHMgaW5pdGlhbGl6YXRpb24gb24gbG9hZGlu
ZyBLVk0gbW9kdWxlIHdpdGggVk1YIGVuYWJsZWQgb24NCj4gYWxsIGF2YWlsYWJsZSBDUFVzLiBJ
dCBuZWVkcyB0byBlbmFibGUvZGlzYWJsZSBoYXJkd2FyZSBvbiBtb2R1bGUNCj4gaW5pdGlhbGl6
YXRpb24uICBUbyByZXVzZSB0aGUgc2FtZSBsb2dpYywgb25lIHdheSBpcyB0byBwYXNzIGFyb3Vu
ZCB0aGUNCg0KVG8gcmV1c2UgdGhlIHNhbWUgbG9naWMgZm9yIHdoYXQ/ICBJIHRoaW5rIHlvdSBu
ZWVkIHRvIGJlIHNwZWNpZmljIChhbmQgZm9jdXMpDQpvbiB3aHkgd2UgbmVlZCB0aGlzIHBhdGNo
OiAgd2Ugd2lsbCBvcHBvcnR1bmlzdGljYWxseSBtb3ZlIENQVSBjb21wYXRpYmlsaXR5DQpjaGVj
ayB0byBoYXJkd2FyZV9lbmFibGVfbm9sb2NrKCksIHdoaWNoIGRvZXNuJ3QgdGFrZSBhbnkgYXJn
dW1lbnQsIGFuZCB0aGlzDQpwYXRjaCBpcyBhIHByZXBhcmF0aW9uIHRvIGRvIHRoYXQuDQoNCg0K
PiB1bnVzZWQgb3BhcXVlIGFyZ3VtZW50LCBhbm90aGVyIHdheSBpcyB0byByZW1vdmUgdGhlIHVu
dXNlZCBvcGFxdWUNCj4gYXJndW1lbnQuICBUaGlzIHBhdGNoIGlzIGEgcHJlcGFyYXRpb24gZm9y
IHRoZSBsYXR0ZXIgYnkgcmVtb3ZpbmcgdGhlDQo+IGFyZ3VtZW50DQoNClNvIGhvdyBhYm91dCBy
ZXBsYWNpbmcgdGhlIGxhc3QgdHdvIHBhcmFncmFwaHMgd2l0aDoNCg0KIg0KSW5pdGlhbGl6aW5n
IFREWCB3aWxsIGJlIGRvbmUgZHVyaW5nIG1vZHVsZSBsb2FkaW5nIHRpbWUsIGFuZCBpbiBvcmRl
ciB0byBkbw0KdGhhdCBoYXJkd2FyZV9lbmFibGVfYWxsKCkgd2lsbCBiZSBkb25lIGR1cmluZyBt
b2R1bGUgbG9hZGluZyB0aW1lIHRvbywgYXMNCmluaXRpYWxpemluZyBURFggcmVxdWlyZXMgYWxs
IGNwdXMgYmVpbmcgaW4gVk1YIG9wZXJhdGlvbi4gIEFzIGEgcmVzdWx0LCBDUFUNCmNvbXBhdGli
aWxpdHkgY2hlY2sgd2lsbCBiZSBvcHBvcnR1bmlzdGljYWxseSBtb3ZlZCB0byBoYXJkd2FyZV9l
bmFibGVfbm9sb2NrKCksDQp3aGljaCBkb2Vzbid0IHRha2UgYW55IGFyZ3VtZW50LiAgSW5zdGVh
ZCBvZiBwYXNzaW5nICdvcGFxdWUnIGFyb3VuZCB0bw0KaGFyZHdhcmVfZW5hYmxlX25vbG9jaygp
IGFuZCBoYXJkd2FyZV9lbmFibGVfYWxsKCksIGp1c3QgcmVtb3ZlIHRoZSB1bnVzZWQNCidvcGFx
dWUnIGFyZ3VtZW50IGZyb20ga3ZtX2FyY2hfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdCgpLg0KIg0K
DQpPciBldmVuIHNpbXBsZXI6DQoNCiINClRvIHN1cHBvcnQgVERYLCBoYXJkd2FyZV9lbmFibGVf
YWxsKCkgd2lsbCBiZSBkb25lIGR1cmluZyBtb2R1bGUgbG9hZGluZyB0aW1lLiANCkFzIGEgcmVz
dWx0LCBDUFUgY29tcGF0aWJpbGl0eSBjaGVjayB3aWxsIGJlIG9wcG9ydHVuaXN0aWNhbGx5IG1v
dmVkIHRvDQpoYXJkd2FyZV9lbmFibGVfbm9sb2NrKCksIHdoaWNoIGRvZXNuJ3QgdGFrZSBhbnkg
YXJndW1lbnQuICBJbnN0ZWFkIG9mIHBhc3NpbmcNCidvcGFxdWUnIGFyb3VuZCB0byBoYXJkd2Fy
ZV9lbmFibGVfbm9sb2NrKCkgYW5kIGhhcmR3YXJlX2VuYWJsZV9hbGwoKSwganVzdA0KcmVtb3Zl
IHRoZSB1bnVzZWQgJ29wYXF1ZScgYXJndW1lbnQgZnJvbSBrdm1fYXJjaF9jaGVja19wcm9jZXNz
b3JfY29tcGF0KCkuDQoiDQoNCldpdGggY2hhbmdlbG9nIHVwZGF0ZWQ6DQoNClJldmlld2VkLWJ5
OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IENoYW8gR2FvIDxjaGFvLmdhb0BpbnRlbC5jb20+DQo+IFJldmlld2VkLWJ5OiBTZWFuIENocmlz
dG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFN1enVraSBLIFBv
dWxvc2UgPHN1enVraS5wb3Vsb3NlQGFybS5jb20+DQo+IEFja2VkLWJ5OiBBbnVwIFBhdGVsIDxh
bnVwQGJyYWluZmF1bHQub3JnPg0KPiBBY2tlZC1ieTogQ2xhdWRpbyBJbWJyZW5kYSA8aW1icmVu
ZGFAbGludXguaWJtLmNvbT4NCj4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDIy
MDIxNjAzMTUyOC45MjU1OC0zLWNoYW8uZ2FvQGludGVsLmNvbQ0KPiBTaWduZWQtb2ZmLWJ5OiBJ
c2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiAtLS0NCj4gIGFyY2gv
YXJtNjQva3ZtL2FybS5jICAgICAgIHwgIDIgKy0NCj4gIGFyY2gvbWlwcy9rdm0vbWlwcy5jICAg
ICAgIHwgIDIgKy0NCj4gIGFyY2gvcG93ZXJwYy9rdm0vcG93ZXJwYy5jIHwgIDIgKy0NCj4gIGFy
Y2gvcmlzY3Yva3ZtL21haW4uYyAgICAgIHwgIDIgKy0NCj4gIGFyY2gvczM5MC9rdm0va3ZtLXMz
OTAuYyAgIHwgIDIgKy0NCj4gIGFyY2gveDg2L2t2bS94ODYuYyAgICAgICAgIHwgIDIgKy0NCj4g
IGluY2x1ZGUvbGludXgva3ZtX2hvc3QuaCAgIHwgIDIgKy0NCj4gIHZpcnQva3ZtL2t2bV9tYWlu
LmMgICAgICAgIHwgMTYgKysrLS0tLS0tLS0tLS0tLQ0KPiAgOCBmaWxlcyBjaGFuZ2VkLCAxMCBp
bnNlcnRpb25zKCspLCAyMCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL2Fy
bTY0L2t2bS9hcm0uYyBiL2FyY2gvYXJtNjQva3ZtL2FybS5jDQo+IGluZGV4IDgzYTdmNjEzNTRk
My4uYzU1MWNhNTg3ZjE2IDEwMDY0NA0KPiAtLS0gYS9hcmNoL2FybTY0L2t2bS9hcm0uYw0KPiAr
KysgYi9hcmNoL2FybTY0L2t2bS9hcm0uYw0KPiBAQCAtNjgsNyArNjgsNyBAQCBpbnQga3ZtX2Fy
Y2hfaGFyZHdhcmVfc2V0dXAodm9pZCAqb3BhcXVlKQ0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiAg
DQo+IC1pbnQga3ZtX2FyY2hfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdCh2b2lkICpvcGFxdWUpDQo+
ICtpbnQga3ZtX2FyY2hfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdCh2b2lkKQ0KPiAgew0KPiAgCXJl
dHVybiAwOw0KPiAgfQ0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9taXBzL2t2bS9taXBzLmMgYi9hcmNo
L21pcHMva3ZtL21pcHMuYw0KPiBpbmRleCBhMjVlMGI3M2VlNzAuLjA5MmQwOWZiNmE3ZSAxMDA2
NDQNCj4gLS0tIGEvYXJjaC9taXBzL2t2bS9taXBzLmMNCj4gKysrIGIvYXJjaC9taXBzL2t2bS9t
aXBzLmMNCj4gQEAgLTE0MCw3ICsxNDAsNyBAQCBpbnQga3ZtX2FyY2hfaGFyZHdhcmVfc2V0dXAo
dm9pZCAqb3BhcXVlKQ0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiAgDQo+IC1pbnQga3ZtX2FyY2hf
Y2hlY2tfcHJvY2Vzc29yX2NvbXBhdCh2b2lkICpvcGFxdWUpDQo+ICtpbnQga3ZtX2FyY2hfY2hl
Y2tfcHJvY2Vzc29yX2NvbXBhdCh2b2lkKQ0KPiAgew0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiBk
aWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2t2bS9wb3dlcnBjLmMgYi9hcmNoL3Bvd2VycGMva3Zt
L3Bvd2VycGMuYw0KPiBpbmRleCAxOTE5OTJmY2IyYzIuLmNhOGVmNTEwOTJjNiAxMDA2NDQNCj4g
LS0tIGEvYXJjaC9wb3dlcnBjL2t2bS9wb3dlcnBjLmMNCj4gKysrIGIvYXJjaC9wb3dlcnBjL2t2
bS9wb3dlcnBjLmMNCj4gQEAgLTQ0Niw3ICs0NDYsNyBAQCBpbnQga3ZtX2FyY2hfaGFyZHdhcmVf
c2V0dXAodm9pZCAqb3BhcXVlKQ0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiAgDQo+IC1pbnQga3Zt
X2FyY2hfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdCh2b2lkICpvcGFxdWUpDQo+ICtpbnQga3ZtX2Fy
Y2hfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdCh2b2lkKQ0KPiAgew0KPiAgCXJldHVybiBrdm1wcGNf
Y29yZV9jaGVja19wcm9jZXNzb3JfY29tcGF0KCk7DQo+ICB9DQo+IGRpZmYgLS1naXQgYS9hcmNo
L3Jpc2N2L2t2bS9tYWluLmMgYi9hcmNoL3Jpc2N2L2t2bS9tYWluLmMNCj4gaW5kZXggMTU0OTIw
NWZlNWZlLi5mOGQ2MzcyZDIwOGYgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvcmlzY3Yva3ZtL21haW4u
Yw0KPiArKysgYi9hcmNoL3Jpc2N2L2t2bS9tYWluLmMNCj4gQEAgLTIwLDcgKzIwLDcgQEAgbG9u
ZyBrdm1fYXJjaF9kZXZfaW9jdGwoc3RydWN0IGZpbGUgKmZpbHAsDQo+ICAJcmV0dXJuIC1FSU5W
QUw7DQo+ICB9DQo+ICANCj4gLWludCBrdm1fYXJjaF9jaGVja19wcm9jZXNzb3JfY29tcGF0KHZv
aWQgKm9wYXF1ZSkNCj4gK2ludCBrdm1fYXJjaF9jaGVja19wcm9jZXNzb3JfY29tcGF0KHZvaWQp
DQo+ICB7DQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+IGRpZmYgLS1naXQgYS9hcmNoL3MzOTAva3Zt
L2t2bS1zMzkwLmMgYi9hcmNoL3MzOTAva3ZtL2t2bS1zMzkwLmMNCj4gaW5kZXggZWRmZDRiYmQw
Y2JhLi5lMjZkNGRkODU2NjggMTAwNjQ0DQo+IC0tLSBhL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAu
Yw0KPiArKysgYi9hcmNoL3MzOTAva3ZtL2t2bS1zMzkwLmMNCj4gQEAgLTI1NCw3ICsyNTQsNyBA
QCBpbnQga3ZtX2FyY2hfaGFyZHdhcmVfZW5hYmxlKHZvaWQpDQo+ICAJcmV0dXJuIDA7DQo+ICB9
DQo+ICANCj4gLWludCBrdm1fYXJjaF9jaGVja19wcm9jZXNzb3JfY29tcGF0KHZvaWQgKm9wYXF1
ZSkNCj4gK2ludCBrdm1fYXJjaF9jaGVja19wcm9jZXNzb3JfY29tcGF0KHZvaWQpDQo+ICB7DQo+
ICAJcmV0dXJuIDA7DQo+ICB9DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9h
cmNoL3g4Ni9rdm0veDg2LmMNCj4gaW5kZXggZjVmZjliMjhlMTE5Li5lNTMzY2NlN2E3MGIgMTAw
NjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS94ODYuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2
LmMNCj4gQEAgLTExOTkwLDcgKzExOTkwLDcgQEAgdm9pZCBrdm1fYXJjaF9oYXJkd2FyZV91bnNl
dHVwKHZvaWQpDQo+ICAJc3RhdGljX2NhbGwoa3ZtX3g4Nl9oYXJkd2FyZV91bnNldHVwKSgpOw0K
PiAgfQ0KPiAgDQo+IC1pbnQga3ZtX2FyY2hfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdCh2b2lkICpv
cGFxdWUpDQo+ICtpbnQga3ZtX2FyY2hfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdCh2b2lkKQ0KPiAg
ew0KPiAgCXN0cnVjdCBjcHVpbmZvX3g4NiAqYyA9ICZjcHVfZGF0YShzbXBfcHJvY2Vzc29yX2lk
KCkpOw0KPiAgDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmggYi9pbmNs
dWRlL2xpbnV4L2t2bV9ob3N0LmgNCj4gaW5kZXggMWM0ODBiMTgyMWUxLi45NjQzYjhlYWRlZmUg
MTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaA0KPiArKysgYi9pbmNsdWRl
L2xpbnV4L2t2bV9ob3N0LmgNCj4gQEAgLTE0MzgsNyArMTQzOCw3IEBAIGludCBrdm1fYXJjaF9o
YXJkd2FyZV9lbmFibGUodm9pZCk7DQo+ICB2b2lkIGt2bV9hcmNoX2hhcmR3YXJlX2Rpc2FibGUo
dm9pZCk7DQo+ICBpbnQga3ZtX2FyY2hfaGFyZHdhcmVfc2V0dXAodm9pZCAqb3BhcXVlKTsNCj4g
IHZvaWQga3ZtX2FyY2hfaGFyZHdhcmVfdW5zZXR1cCh2b2lkKTsNCj4gLWludCBrdm1fYXJjaF9j
aGVja19wcm9jZXNzb3JfY29tcGF0KHZvaWQgKm9wYXF1ZSk7DQo+ICtpbnQga3ZtX2FyY2hfY2hl
Y2tfcHJvY2Vzc29yX2NvbXBhdCh2b2lkKTsNCj4gIGludCBrdm1fYXJjaF92Y3B1X3J1bm5hYmxl
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+ICBib29sIGt2bV9hcmNoX3ZjcHVfaW5fa2VybmVs
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+ICBpbnQga3ZtX2FyY2hfdmNwdV9zaG91bGRfa2lj
ayhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOw0KPiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0va3ZtX21h
aW4uYyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMNCj4gaW5kZXggZGEyNjNjMzcwZDAwLi4wZjU3Njdl
NWFlNDUgMTAwNjQ0DQo+IC0tLSBhL3ZpcnQva3ZtL2t2bV9tYWluLmMNCj4gKysrIGIvdmlydC9r
dm0va3ZtX21haW4uYw0KPiBAQCAtNTc5MywyMiArNTc5MywxNCBAQCB2b2lkIGt2bV91bnJlZ2lz
dGVyX3BlcmZfY2FsbGJhY2tzKHZvaWQpDQo+ICB9DQo+ICAjZW5kaWYNCj4gIA0KPiAtc3RydWN0
IGt2bV9jcHVfY29tcGF0X2NoZWNrIHsNCj4gLQl2b2lkICpvcGFxdWU7DQo+IC0JaW50ICpyZXQ7
DQo+IC19Ow0KPiAtDQo+IC1zdGF0aWMgdm9pZCBjaGVja19wcm9jZXNzb3JfY29tcGF0KHZvaWQg
KmRhdGEpDQo+ICtzdGF0aWMgdm9pZCBjaGVja19wcm9jZXNzb3JfY29tcGF0KHZvaWQgKnJ0bikN
Cj4gIHsNCj4gLQlzdHJ1Y3Qga3ZtX2NwdV9jb21wYXRfY2hlY2sgKmMgPSBkYXRhOw0KPiAtDQo+
IC0JKmMtPnJldCA9IGt2bV9hcmNoX2NoZWNrX3Byb2Nlc3Nvcl9jb21wYXQoYy0+b3BhcXVlKTsN
Cj4gKwkqKGludCAqKXJ0biA9IGt2bV9hcmNoX2NoZWNrX3Byb2Nlc3Nvcl9jb21wYXQoKTsNCj4g
IH0NCj4gIA0KPiAgaW50IGt2bV9pbml0KHZvaWQgKm9wYXF1ZSwgdW5zaWduZWQgdmNwdV9zaXpl
LCB1bnNpZ25lZCB2Y3B1X2FsaWduLA0KPiAgCQkgIHN0cnVjdCBtb2R1bGUgKm1vZHVsZSkNCj4g
IHsNCj4gLQlzdHJ1Y3Qga3ZtX2NwdV9jb21wYXRfY2hlY2sgYzsNCj4gIAlpbnQgcjsNCj4gIAlp
bnQgY3B1Ow0KPiAgDQo+IEBAIC01ODM2LDEwICs1ODI4LDggQEAgaW50IGt2bV9pbml0KHZvaWQg
Km9wYXF1ZSwgdW5zaWduZWQgdmNwdV9zaXplLCB1bnNpZ25lZCB2Y3B1X2FsaWduLA0KPiAgCWlm
IChyIDwgMCkNCj4gIAkJZ290byBvdXRfZnJlZV8xOw0KPiAgDQo+IC0JYy5yZXQgPSAmcjsNCj4g
LQljLm9wYXF1ZSA9IG9wYXF1ZTsNCj4gIAlmb3JfZWFjaF9vbmxpbmVfY3B1KGNwdSkgew0KPiAt
CQlzbXBfY2FsbF9mdW5jdGlvbl9zaW5nbGUoY3B1LCBjaGVja19wcm9jZXNzb3JfY29tcGF0LCAm
YywgMSk7DQo+ICsJCXNtcF9jYWxsX2Z1bmN0aW9uX3NpbmdsZShjcHUsIGNoZWNrX3Byb2Nlc3Nv
cl9jb21wYXQsICZyLCAxKTsNCj4gIAkJaWYgKHIgPCAwKQ0KPiAgCQkJZ290byBvdXRfZnJlZV8y
Ow0KPiAgCX0NCg0K
