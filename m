Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4B347672F
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 02:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbhLPBAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 20:00:41 -0500
Received: from mga06.intel.com ([134.134.136.31]:17014 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhLPBAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 20:00:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639616440; x=1671152440;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MQMRLirXRSmA/zsEBfZgZSjY5Ci9G6QNi5QhvkXwuto=;
  b=A//OS1Fb1I8Q/diaJuLgTRDrVpgU/1i7J8ZNNteeKhCkNGqItpIH62Lw
   YIAa3tebnuK6c994PN58EWd0MZxpHySbz9wUZzwlh6MM1RDPNFWSwb5zF
   gq74/smcxWAViXQye9eS6WbjUNJ4aonVTtwyBZwVVyETruu5TjlVX/o5p
   C4HEc0Nwd8nUINtfdQwS8YCM/t08bfyDDTeZoM1lgw//pKo/ydxztZxqE
   u3bfKnmeO6mF9LSaGASoIuwcIpVV6X7MiuRxg41fqn9bnSJPVZmpGOExV
   Kb9RTNN15BopZanhqcly9N1YU0bhzSgweJl7cDNPxcaAOCZUZU9k8EeAX
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="300149071"
X-IronPort-AV: E=Sophos;i="5.88,210,1635231600"; 
   d="scan'208";a="300149071"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 17:00:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,210,1635231600"; 
   d="scan'208";a="584590154"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 15 Dec 2021 17:00:39 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 17:00:38 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 17:00:38 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 15 Dec 2021 17:00:38 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 15 Dec 2021 17:00:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKWiUTJLoIdbgDZq5ZT1WpiDYzOLhNTyoEIKa1LwUYhr8qGMnudNb5SrNUXH7W9QypxvC7xDa0g9NqIMzFVe4DHApgkQNPVY1wcY+4uzUhsCPPB8jSJYhjgLkc7ROQIzuZp0T9oRA3leBxkjbsY3G79h3vaksF+C+d8C6uSmczD7BhD4Dq+a7QP9utlgcJVjN8akBN/cdwfg9uSx7eTLX5yJVZgWuUCN8ZP72YCVWzYkzSIoa7eOG3Mx6PLpaBJ0biizvuhQE4c2kwPfKifuuipw4D5bUc/R6SBS31XVJUq+yLxJtOyPyvSt7Hh5NGMNrIJz58ShwfxSHEMTefbu8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQMRLirXRSmA/zsEBfZgZSjY5Ci9G6QNi5QhvkXwuto=;
 b=kegaVGTKU3pj8iDmvDgaR8lJGPuvX0Kig2TnFbB2EgMSj0RHhavoaW5Wp+gcKJem5oFAQmXvBWUtft7BAAKLxVhh5vdtgb3wQDRJ6qUgqnKo2v4ksdGsjvTS/SwPRG4hZMAqGjpsVZ+XqtuX+BoV/5Wj0SqCwJy23hTWNbzrznDEcLtJ/F8Lvrd2ZvrAft2X5956q0MWTnBq1KXE++ZcFzsQ6CyPxnpuWrNaAjNgvT+E/DbzVdxJjVJsUsgZ9jNrKJ1+lnIDE4aYMOu1URGXJzfbGgkboA9kPXaNIkW+P7Ws5hpPoocYZ3S4BKWzDLGX7Ko2/Z/UaGjG2dHadiKFSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5370.namprd11.prod.outlook.com (2603:10b6:408:11b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 01:00:33 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%3]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 01:00:33 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "quintela@redhat.com" <quintela@redhat.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
Subject: RE: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Topic: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Index: AQHX8JViV3rUbi5iYUCgo3JeBUJUo6wyGCEAgAAIi4CAAAi/gIAAH5YAgAAT0FyAABRSAIAAEuhSgABOroCAAIPaAIAABQ6AgAADz4CAAO8l0A==
Date:   Thu, 16 Dec 2021 01:00:33 +0000
Message-ID: <BN9PR11MB5276F84FA0C05F00E9A039D38C779@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de>
 <854480525e7f4f3baeba09ec6a864b80@intel.com> <87zgp3ry8i.ffs@tglx>
 <b3ac7ba45c984cf39783e33e0c25274d@intel.com> <87r1afrrjx.ffs@tglx>
 <87k0g7qa3t.fsf@secure.mitica> <87k0g7rkwj.ffs@tglx>
 <878rwm7tu8.fsf@secure.mitica> <afeba57f71f742b88aac3f01800086f9@intel.com>
 <878rwmrxgb.ffs@tglx> <a4fbf9f8-8876-f58c-d2b6-15add35bedd0@redhat.com>
 <8f37c8a3-1823-0e8f-dc24-6dbae5ce1535@redhat.com>
In-Reply-To: <8f37c8a3-1823-0e8f-dc24-6dbae5ce1535@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d3ba4b2-1fd8-4e05-5c76-08d9c02f7699
x-ms-traffictypediagnostic: BN9PR11MB5370:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN9PR11MB53701560682596C81DC783348C779@BN9PR11MB5370.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OGwKC2aE34h1YZR2GE1vL/EBzhhW/1Fs7giTWpD467Z2kDOK3oubshgypwlavdlX3LySDk8/I69Zxq/5C+lduPP7DoPNHCJDw8ANJmTnEVvpuKcKTkzwMqNV4WPB+MAm8QorqCL8aIBGFuWI25aGSFWdvjoJ6dxasNP79NvR2saS0O6WrhxvYdETPIuT/aqR0xXJlSQxGlhqn20ensRAGXPO2eYJ63xFSFWG1Edw6tfJYEIkSIqn6mSRj7bL+pj51BrH70ezfTe0kz0oNPO7CdwcYZtEFynYDfhs40WpO/IRnwApYbty/Ze8Dvufwf099zPGiW30IjDde1Yjm5vcIzXRModdNKL7F3uxBIM0QUHa5Cz85Yu6QlxE1ICIAbnLUjDv7WuWXdNHWAJfU/lVClxk6CD8YiV4LvsKCf3taGlgFd7sPhcfB0CfzBni/rB/LeiYayUazcK57zHbiGwATqrm0wdfWwelbvn7Sgf7VhaM5vSr6y44nHpbWi+5d+cqGwTbPDNHzUr+k4HFfy4IBPA9AikDk/1uVTKrFp4ra+E1RvTJ/Z/mYIwGmBdw1aKs5G8JHOtkuGpfeGDgMHg8wmMDSI8cauJxB+C80LiAKcdmdzKBehEfBDLtljdAk4UwomcAbh4rp9tFe3Eo351LZ1uJEga23wDNVCTFxSBtC33UOHbaF0RDwQHOzxCNlq9dJOlWdCjJmhDFyWCv0mb/6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(5660300002)(33656002)(110136005)(53546011)(7696005)(8676002)(86362001)(52536014)(83380400001)(55016003)(54906003)(64756008)(66446008)(82960400001)(66946007)(508600001)(186003)(2906002)(26005)(316002)(6506007)(38070700005)(38100700002)(71200400001)(122000001)(66476007)(4326008)(9686003)(76116006)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bWVRNlNmRjJLUHJpekxWSlIyVkVRM2ltOFNyZ1hCdEk4T3dJS1lBM0N0RE1X?=
 =?utf-8?B?cGQwNkRpaXVHalBaQ0xyV3hLbG5XcjNPQXdoSWpRNmpXN0haTUhMUHNyMWlz?=
 =?utf-8?B?ajRGdGJJMnRadHZWdzc5bE1sbHM5SE9rNzVRdkNINDdCODQzMFE2NHFKNmMy?=
 =?utf-8?B?SWs2REowOFpjUWFJaGdjR0duUVpJSTI4QkZkZ3BsZXMyQm1qZ2VsY25zVHEz?=
 =?utf-8?B?akt3Y1pVaWR4WGR3Q2M4TkN4TGdzdXRLTjJvN2ZUK1hJYTlyc04rUXVDVXo4?=
 =?utf-8?B?V1NDMEYxZTZJa29Oc1RVdGRpRERXOWxWNVIrOUg3OFZrY1ZYc2MxYnVpSkhk?=
 =?utf-8?B?V09Nb2dWbG5TamtycWlITDRMM3YxY3hVZDFhSVFrVE9SZVpuVHR4ZWwrbzZV?=
 =?utf-8?B?WWFzcTNqWjRFMkNzaUtjOWRwelNxUVZiZldKb2NXN3RYVkpWdUU4Q3lNcEpr?=
 =?utf-8?B?MVVvM2pQSXdudEI5dUgxdUdSaTdBR3V2RmNKdmYrTGJxQTg4M2JhZW1JTzcx?=
 =?utf-8?B?ZGZ1a0k3VVJzWDNsWTZHdi9CZEdhNkQwZTRkSG83VFp1WWhCUm9PWURNbWF4?=
 =?utf-8?B?c0NFaFV3bDFTZVVvY0wyRXdJaW5MR0cxc092SU1acThGMFYweUhwQXNYQXZK?=
 =?utf-8?B?aTlCZXNlNi9aRTZjZDRZVmpBTEZuZ2x1WTZ3TnJ2b1ViVzc3YkpFMXZyVkpI?=
 =?utf-8?B?QjNkZ1JBS0dYcDF2WENFM0F0SHplbkNVRXpKU2psSGYrRmMyb0lsbGU0UE9s?=
 =?utf-8?B?R3l0TlZNeERiVjdHV2ZXUitzREx6QjlHcmJpMDNFcFlUY0hvc25SVFFsTFhk?=
 =?utf-8?B?TE9aYlRkbFJYeFFPajQxUHBlbTV4QUZpRXJTTEkrM1BnbFVtN2VaRE1nckkz?=
 =?utf-8?B?K0tkcXRjT2hrMC9ZZ0pCWWpyUnN1WEdVMVJJY1dvN0xTM293b0ZOWXdVYUR4?=
 =?utf-8?B?NHlIYXRLOWRCL0tEQXpmcVVmQkFRYWlIV2FESm1DQVBQQnlqaEJDd3pEaU9Q?=
 =?utf-8?B?R1BQOUhWUW9tYnRSN2R5cTZITyswbENOd01sbmVabGI0UnI2SytQRFFCc1JY?=
 =?utf-8?B?MDhQaVFON013dnlJR041VStiTEV2SEl4Nk9Zc0I3SUZEUUFzeURoMjZQdGYr?=
 =?utf-8?B?d3pLZ2FHYVJBNTJiYzRRVjltUG9rdDh0MU5UU2hDbVhlUmQyek84bUhuaUlQ?=
 =?utf-8?B?eGFIaTBFTHJVZmhUaEdTSnBkY29IMHZmQjc3NmtRSjJmMmUyS3dnbGlNUVVI?=
 =?utf-8?B?dzBPUjh2SW5iTGJzc05aMllBd1hOMGt5Ly9OSHpkM3RrdFZUSzZKNHhnUE5z?=
 =?utf-8?B?NDE2a0NtOXJtN1l1S2hSV3ljVjAzcUN6UThnMG11cGVBeWI4V0F2bTVLMWVR?=
 =?utf-8?B?NUswZXowMi9hVzY4d1czL3BUY3N0ZnNrTjNYbzVyKytMV0laRWpXdWd3YWFB?=
 =?utf-8?B?VFE1NXJPdTNxQzVRSjBPK21xM3hJZkhkdU8yTTVjRXhmUFIrcUZ6V1lKd3pW?=
 =?utf-8?B?K1AyWFJ2UEpSTkNseFVLanV0YXBBTDlwNmwzS1laTmI4MXBma3NEbXpJc3JG?=
 =?utf-8?B?Y3FsWk5PeitocWNrTVZwaDZRZzJwY0Roc3FqS2kyZ3pyZHpvRzFkR0JJOFR4?=
 =?utf-8?B?QUpuV0NXTTJMclBueEVGQ085ei9xQWNpOUdlWVNKR3BwenVkS2JpR3dSL1hK?=
 =?utf-8?B?eitrZmE1UVg1dmptMEdZQ2RrTlR6VXFVTkZSQjI4Z2dZRlRkZ2FpVlZFOWtM?=
 =?utf-8?B?NTRPTGVmbnUybDVzRzZuQjVSbVFyLytHamx3NzNxdmpMRHhiMW9aaGYwSk5t?=
 =?utf-8?B?YXZpSU16b2pXaWYreEJIdUxpNTROQUgwd0xJVEVUblgyOHJXaWZwd0h1RjNW?=
 =?utf-8?B?aCszUlZIV29uSDBXZDUxc1VSNnVEY2drbTB0dWVCM0grdERjTnQrb3daMjJq?=
 =?utf-8?B?bmVaMWdVM3lwS1NtbEJXaEdjVHVla1RCMzg0Y1MvY2RTTXBiM1FZMjVRcHlU?=
 =?utf-8?B?cG5mdGh0a2VMWlh1L09Ua2hoNGhNalNUNXBkY1dES3JJcUJ6dHFmWjN0a2dW?=
 =?utf-8?B?dnNkZjlVNW5yWW9MSUJpSWdBcm5JSTZlelpWTEswWkxtMnBydmJBM1R5Qnlr?=
 =?utf-8?B?Vy9KbDJla1dDQktvN0JrNUw1QzlDUitSK3FIalJZc1N5eEhGYlliSzRPUWx6?=
 =?utf-8?Q?eEjNkXr4S8qz7fg1+jNtSp0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d3ba4b2-1fd8-4e05-5c76-08d9c02f7699
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 01:00:33.2755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7d2i0vhHUYtmFN2No2WkOOmGiBFwApSN6DTQ9mB3YFh1yBN70y4G0LHF3mFfjzJGOk9s2iJDG0DPYsk6y99zYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5370
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQYW9sbyBCb256aW5pDQo+IFNlbnQ6IFdlZG5lc2RheSwgRGVjZW1iZXIgMTUsIDIw
MjEgNjo0MSBQTQ0KPiANCj4gT24gMTIvMTUvMjEgMTE6MjcsIFBhb2xvIEJvbnppbmkgd3JvdGU6
DQo+ID4gT24gMTIvMTUvMjEgMTE6MDksIFRob21hcyBHbGVpeG5lciB3cm90ZToNCj4gPj4gTGV0
cyBhc3N1bWUgdGhlIHJlc3RvcmUgb3JkZXIgaXMgWFNUQVRFLCBYQ1IwLCBYRkQ6DQo+ID4+DQo+
ID4+IMKgwqDCoMKgwqAgWFNUQVRFIGhhcyBldmVyeXRoaW5nIGluIGluaXQgc3RhdGUsIHdoaWNo
IG1lYW5zIHRoZSBkZWZhdWx0DQo+ID4+IMKgwqDCoMKgwqAgYnVmZmVyIGlzIGdvb2QgZW5vdWdo
DQo+ID4+DQo+ID4+IMKgwqDCoMKgwqAgWENSMCBoYXMgZXZlcnl0aGluZyBlbmFibGVkIGluY2x1
ZGluZyBBTVgsIHNvIHRoZSBidWZmZXIgaXMNCj4gPj4gwqDCoMKgwqDCoCBleHBhbmRlZA0KPiA+
Pg0KPiA+PiDCoMKgwqDCoMKgIFhGRCBoYXMgQU1YIGRpc2FibGUgc2V0LCB3aGljaCBtZWFucyB0
aGUgYnVmZmVyIGV4cGFuc2lvbiB3YXMNCj4gPj4gwqDCoMKgwqDCoCBwb2ludGxlc3MNCj4gPj4N
Cj4gPj4gSWYgd2UgZ28gdGhlcmUsIHRoZW4gd2UgY2FuIGp1c3QgdXNlIGEgZnVsbCBleHBhbmRl
ZCBidWZmZXIgZm9yIEtWTQ0KPiA+PiB1bmNvbmRpdGlvbmFsbHkgYW5kIGJlIGRvbmUgd2l0aCBp
dC4gVGhhdCBzcGFyZXMgYSBsb3Qgb2YgY29kZS4NCj4gPg0KPiA+IElmIHdlIGRlY2lkZSB0byB1
c2UgYSBmdWxsIGV4cGFuZGVkIGJ1ZmZlciBhcyBzb29uIGFzIEtWTV9TRVRfQ1BVSUQyIGlzDQo+
ID4gZG9uZSwgdGhhdCB3b3VsZCB3b3JrIGZvciBtZS4NCj4gDQo+IE9mZi1saXN0LCBUaG9tYXMg
bWVudGlvbmVkIGRvaW5nIGl0IGV2ZW4gYXQgdkNQVSBjcmVhdGlvbiBhcyBsb25nIGFzIHRoZQ0K
PiBwcmN0bCBoYXMgYmVlbiBjYWxsZWQuICBUaGF0IGlzIGFsc28gb2theSBhbmQgZXZlbiBzaW1w
bGVyLg0KDQpNYWtlIHNlbnNlLiBJdCBhbHNvIGF2b2lkcyB0aGUgI0dQIHRoaW5nIGluIHRoZSBl
bXVsYXRpb24gcGF0aCBpZiBqdXN0IGR1ZQ0KdG8gcmVhbGxvY2F0aW9uIGVycm9yLg0KDQpXZSds
bCBmb2xsb3cgdGhpcyBkaXJlY3Rpb24gdG8gZG8gYSBxdWljayB1cGRhdGUvdGVzdC4gDQoNCj4g
DQo+IFRoZXJlJ3MgYWxzbyBhbm90aGVyIGltcG9ydGFudCB0aGluZyB0aGF0IGhhc24ndCBiZWVu
IG1lbnRpb25lZCBzbyBmYXI6DQo+IEtWTV9HRVRfU1VQUE9SVEVEX0NQVUlEIHNob3VsZCBfbm90
XyBpbmNsdWRlIHRoZSBkeW5hbWljIGJpdHMgaW4NCj4gQ1BVSURbMHhEXSBpZiB0aGV5IGhhdmUg
bm90IGJlZW4gcmVxdWVzdGVkIHdpdGggcHJjdGwuICBJdCdzIG9rYXkgdG8NCj4gcmV0dXJuIHRo
ZSBBTVggYml0LCBidXQgbm90IHRoZSBiaXQgaW4gQ1BVSURbMHhEXS4NCj4gDQoNCndpbGwgZG8u
DQoNClRoYW5rcw0KS2V2aW4NCg==
