Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148DE433F64
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 21:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbhJSTqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 15:46:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:27921 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230147AbhJSTqD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 15:46:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="252092195"
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="252092195"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2021 12:43:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="494262511"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 19 Oct 2021 12:43:50 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 19 Oct 2021 12:43:49 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 19 Oct 2021 12:43:49 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 19 Oct 2021 12:43:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/9Ud32iNMnsm7NJukq+aEBeNewvfpNe2BS7nQK87saYX5Jqf/9l2vLWfAiMQZnwpCVaMtud/hzeLqjgu1psd4wwKwZubYvcWk5O/asDrgv01McJ33LwZXGqw2ehf+xgRkuuEpKUReGUP7Hv3hWWguYc+12aZ/iyTV7sSfpdzWe1+hHcSouySD3lkdSfHLZAoRPWKimj9lNNnoMx0kjyPmu2jZUFVC9gXvzLkWtid4dc9/oorNxY9h/T4uUvFsu0zHe9DaN9AHDbq+uPir5UjIaI2XKcvHWTPnqyKKpzrwu8cUXxzsq89O22IP+pyXKgyhAeWXCo65T1+nrIzr8rZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sdyf1b2jNljHs2qP7f41kq4esPHRNqEq3YerTdBLKFE=;
 b=fFhPLOGKdCW5klfd4YjRl5Nh2V1f9NVcdPt2cwOmZndtZZGk+0ci0+vUWQhjMTUqmVBoFm9JaBo8LdjiDQ8UovhLuhoEExRWraIaU5MM5yjIaHTqQ/6wYOsMql4jAp78ZC+STInRz4rodVfCNQ8QhUHoFR0wvsXehTurq6PMy835BZqeB90ekdAg7+KVL4mmH658OIsC2lzGOFyGxPypdYQAWx3AHI0wl5TOCHaWk7VtSeYyOY8GPMhDV0hOVmm+zu9Yoj1/cJQ73IaSvkdegFsGc3Pl/HaOEtV+7uwu7c3C3z/+KkZkhy11KIqUi5Lhi1zeVlBtScpAOKwYOWg5ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sdyf1b2jNljHs2qP7f41kq4esPHRNqEq3YerTdBLKFE=;
 b=JPolmi+J10asto6Arzf3TKLL0cghRc0qop9ccknJlVrs6Sjv+mZjHzP1d1WoL1gCP4x00MS81+J5bTHJCVYgrrBQF+EC5HrmhVqJoQ6Qt0iGYvCvEBNBZ6yCKiM+z2lfsQUFppLkMNVkKN/jWVA7U1f+uHN7HEq7wNNDMPNNQ+c=
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH0PR11MB4981.namprd11.prod.outlook.com (2603:10b6:510:39::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Tue, 19 Oct
 2021 19:43:49 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::11ef:b2be:5019:6749]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::11ef:b2be:5019:6749%5]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 19:43:49 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [patch 0/4] x86/fpu/kvm: Sanitize the FPU guest/user handling
Thread-Topic: [patch 0/4] x86/fpu/kvm: Sanitize the FPU guest/user handling
Thread-Index: AQHXw3jlbzl39rZWD0qAbnrCbyF6yKvavFAA
Date:   Tue, 19 Oct 2021 19:43:49 +0000
Message-ID: <841ACA86-CE97-4707-BF6E-AC932F1E056D@intel.com>
References: <20211017151447.829495362@linutronix.de>
In-Reply-To: <20211017151447.829495362@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7f09dd7-7adb-4b6d-0275-08d99338c594
x-ms-traffictypediagnostic: PH0PR11MB4981:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB49818395BB404ED3B86263A6D8BD9@PH0PR11MB4981.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q7ZB/b49xN8mYUBt2S4k+lNPNKDGhvK2QqmPTH3u215YDpl7/FxWAdN//t2QGtQyBrSGUJmKxRRrvsHLahfbYAWP7O91sENjfYhwzmt8E+64XaWeOZ1gmixuO0EgrN3lMqxkJVLZ/43H7Nuj1DNWNh9L5x0MbIgEQL4M2VP6fHUFpW6NTVE/HfNPZUPsPrQPIjSi90KHfHRJY3/yYY+keDcYUlNLWOiIZc4Zis6KRBZ3dyi6BO3B36j1I+6ugUc4LR4ShNEETv6RfNgmrM05WnjMgEHfXltNyU3KNAO3D+IolA3oDzKGHFxDg/KDCNlMmxtGMuGB7f2LczULhM0W90KDPJAHNWSeJ1WEF+gcDC8tbo6dT7yTFJjh+69CUC6NdN5iEFOZiqS4sENMY1KfeMCt9a4FAPDa07Zi0zYoz1CILq1MLLAoprdfRADxNQ3fH5y7b5xbWPWZGByIYvrWWALfVYt3Lxr60wxWgq7YyIdDBS+H/PXGbZBJFD1BpuiiX77GT0RF5pr/H21nshjCztAeaYj145VEkfOvIzfqVskwgyHZEOcp+qW2RmHl/+auSf1aWAHYjly6DuDZLJWkqQOF4Y9evKT5arJ0pOk5rBdkEHQCIb6M9WmUwX8jJrPne6afvbDPCpPwtZg7ejv6ARFSTk4l5kiOex4F2oKImOXbOth2pCRpayh7htSnDa0uzUL183WNld9jA6tzjRlE8nhNgAHIoi1z3+jlC02+qJA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(8676002)(38100700002)(2906002)(4326008)(66946007)(66446008)(66556008)(33656002)(6512007)(38070700005)(6506007)(122000001)(64756008)(66476007)(8936002)(76116006)(5660300002)(186003)(316002)(6486002)(26005)(53546011)(86362001)(82960400001)(6916009)(36756003)(71200400001)(2616005)(4744005)(54906003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n7RXI8fDH41VmYLpxbAnRaMNffEDG6i47D6m5V0puVLt/b5xknyE9+Tr7PdN?=
 =?us-ascii?Q?TFX5Am68F+wpu472VXGu2SQ6fliHZTy91i6vqbSITO64l/+Bnqluq/5FH2N0?=
 =?us-ascii?Q?+gt3icuX1T3qt2kMtVFyZG7kvAI0LZCdkEarcpx7fWhHF0Sz+o0njACuGbsQ?=
 =?us-ascii?Q?JCRVoWD3Kme3MVhRf136i6lr9K0GNdTrPyarp9uiSZYqTfyYonFOP8ru0rn/?=
 =?us-ascii?Q?PSzUQijR6ryS8k/RwWHyh8RjloD3bFm6EQfOEc5r9m5FnxoQQ0QUddB18fLJ?=
 =?us-ascii?Q?AECTzNvNiNlK5zuD9twdyV7wm3Dk+cqK9erPmrRSAoWs80xl0b9uL7CWWWl2?=
 =?us-ascii?Q?6CNQaHzij21kKNhbZTaR1PtMJEckoyt6rKe7AX1cvxy0AVSmxPZNSKftT+eL?=
 =?us-ascii?Q?PfnZq/85r042bHLNvRWmWaqjUoR2VXD7Q+GIC7+0ro/BSs72ifFvAmYHHirP?=
 =?us-ascii?Q?S7bKhAHkeNAuQqb7b27MFih+raEPNlQ4HYa7e6bePRkvn/pl5Df2T0Z/sqi3?=
 =?us-ascii?Q?MiJirokSpT66VlIAXj3RI96uMJwS3muvVBRV7nygTwCxj9c4uBYx+GqiKQ8O?=
 =?us-ascii?Q?TLtxjMiCnNqi4ItGl2klVpGEJVqi/n0PJxiDK/wDsCl8EqSGUbnGMNyIOxzT?=
 =?us-ascii?Q?6jCGLnN0ayJp0d8GHHQdTsyUE2JMf0x63YoyMqKCD/zVZypsde/2Cbc5aTu0?=
 =?us-ascii?Q?d3qWpgA9kk7F2oAlwZSQyqg8UgMzt3g9L1pHqp37fy2yd9gHlfTxUIfR9Y+O?=
 =?us-ascii?Q?fl/nPRsXP3BFkxvp5e9xSFn/0Q8ytBGK71E9LZY5BHGKzAFTNA51zq04kb4i?=
 =?us-ascii?Q?2/p0KCD5odHyqs3EJSMabShxPl2v/4EO7PPvIP0eil7jc5rTcts0IGgF85/g?=
 =?us-ascii?Q?ac379UxleTWcBuj00F4/K4kRUnt/bH1NH7mx59d1XSqkwOlUiXzMQ+1j1lxE?=
 =?us-ascii?Q?/avFjumHw2xrz6XDxcfcEPXZSrx9GCm6f9dDxD7ybPagNq/2R/29lDO71eIA?=
 =?us-ascii?Q?HyFUlKVS4HnB94Y/bf/RGc03w3g6v2adoYRRNPG5LQpOlxVf+xN3aCw/fHHa?=
 =?us-ascii?Q?utv9SudGMy4ZlFYUPEazzlxZrI3j84ycciOgZ0DJasS9k+BOW3U+koNLaUka?=
 =?us-ascii?Q?1n3SDo1iDKSEiWcrKZIKHLSiRqv3eUWNbdX1K1cvDuYu7XTCfG+dFNX8/7u+?=
 =?us-ascii?Q?jUPYLPO73957HUDbTnQc7Bda9TzeD3LUL1xO4FgOd3i3QBIET8T0yhEouDNe?=
 =?us-ascii?Q?1MEE5BMdVNxG1yH9NtjLBUjZzxcv2veDFE2TvGa9j2faDPdngIUOsjIXBJek?=
 =?us-ascii?Q?Sus1fAmCvNSzANbU/WdrHAyb?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BD25BFAA2B369D48B398593F59F15767@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7f09dd7-7adb-4b6d-0275-08d99338c594
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2021 19:43:49.1231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xEk3UVeMtxyeuxYH0yhdzyyXloOZGQtjnW7pj8mpMOQEshg2FtUtxzmC1HE6pnRIUUpkwVu2An4RStKr+x1mBPJ81b43tkszQ6pWBsTtAkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4981
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Oct 17, 2021, at 10:03, Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
> The latter builds, boots and runs KVM guests, but that reallocation
> functionality is obviously completely untested.=20

Compiled and booted on bare-metal and KVM (guest with the same kernel).
No dmesg regression. No selftest regression.

Tested-by Chang S. Bae <chang.seok.bae@intel.com>

Thanks,
Chang
