Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CF258F16C
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 19:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbiHJRSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 13:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbiHJRSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 13:18:01 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58DA5A880;
        Wed, 10 Aug 2022 10:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660151880; x=1691687880;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=voIPTenHzP6inzFtp23CUxhQ36GBM/U2Qytc/KTHGmQ=;
  b=IkRYPxXglZruH1wjAbSfmjBeKmSmHXrYWlOLGGdk1jUr0lSDHoPhbfUM
   DSO1XOSbUP2V2ux9Z0KsAFZIfPjO0Nwt9xMvYDB9PMgoO5hnt2+uYxh2d
   zCeL/7aCkg+46RysT5u8lAbH85G6ZMXARvv479hqx6AoP8PJd0O2WaOGo
   ZO+BFDdwgHz4baPdsR/+ljWNq7VMNj8xtMD69uSMPqIyEvtEyab4zmCI8
   0sGoBe5IhKKATRqc8X8E3cli8JVPT6a74vXfVqeMECYIg48fGOFlASTSs
   pfdwdbn/iK4DWsvje209QD/fFYpVGgTI57hrYDKJlKumtJ8jB81CqmP9D
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="317098514"
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="317098514"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 10:17:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="932971871"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 10 Aug 2022 10:17:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 10 Aug 2022 10:17:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 10 Aug 2022 10:17:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 10 Aug 2022 10:17:56 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 10 Aug 2022 10:17:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ma2mZF7m7JbOpGLpl7i3Uz7rP1s5X5/V2lsKSdVLUH54l62GpzeF1Jurm5wyp6y1tL+EfQsdJNlrjL1lxkazuQIm9MoltU9a+D5/I/EJIw3mvrsFhZKg+fMsi0SWs5QdveI6UCDR0PlUmS553RhvGNAdXxVIWpJMiRQeApilZ7eGsRbp148TlyKRb7FIetJj9ulrPe8r8WG2LKpGIU1iGe/45jnzTw5zr7hAD13uSY4QfMEKHfWtN922AxffCYfsU7L+T4NAkO0K4NA6Ce/0Q37KFJWvWEPIFEd8i8T3HoxE5Z170b35FJf55iyGHyyMxvQEhiRMEGjwwwlH1wQStg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=voIPTenHzP6inzFtp23CUxhQ36GBM/U2Qytc/KTHGmQ=;
 b=HJhrxjVwgC7zpCOi37XIBa5ifQGsjsdflCH5WCgrpXgkoN5E1r0FheHMe2sNDG0Wdj0H+AC6hmd8kO7s7DQre8B+7OAjH4lX/fweF9Kvz+U9SLoQr2EhkVtXz+9BpEiSxoian9ZtZGGniHcOFPlnZUuvEQm/Lls3mNy6xtqbbI5LlLE6BahzfBZP0dIqDtGR4gkTvR+ohmG/dQFqLGjjniUdCLFeaD9lusQ5l7vQqIIIxF2QCwww/NepfHG+3XEG7lIoKHNaMR55Squt/kPB5wevDltZS6FGyumzWOVof2GzoNARsjfRc9UjBu46gvUziGq7JN4dKFjJdCg6WvAoag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3042.namprd11.prod.outlook.com (2603:10b6:208:78::17)
 by MN2PR11MB4693.namprd11.prod.outlook.com (2603:10b6:208:261::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 10 Aug
 2022 17:17:48 +0000
Received: from BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::e849:56d0:f131:8efe]) by BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::e849:56d0:f131:8efe%7]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 17:17:48 +0000
From:   "Dong, Eddie" <eddie.dong@intel.com>
To:     Dmytro Maluka <dmy@semihalf.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Rong L" <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Tomasz Nowicki" <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        "upstream@semihalf.com" <upstream@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>,
        Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
Thread-Topic: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
Thread-Index: AQHYqQNV5DxKJST9sEC1NUps5Q8SMK2lqmdAgACFsACAANA2YIAAPbGAgAEmcOA=
Date:   Wed, 10 Aug 2022 17:17:48 +0000
Message-ID: <BL0PR11MB304290D4AACC3C1E2661C9668A659@BL0PR11MB3042.namprd11.prod.outlook.com>
References: <20220805193919.1470653-1-dmy@semihalf.com>
 <BL0PR11MB30429034B6D59253AF22BCE08A639@BL0PR11MB3042.namprd11.prod.outlook.com>
 <c5d8f537-5695-42f0-88a9-de80e21f5f4c@semihalf.com>
 <BL0PR11MB304213273FA9FAC4EBC70FF88A629@BL0PR11MB3042.namprd11.prod.outlook.com>
 <ef9ffbde-445e-f00f-23c1-27e23b6cca4f@semihalf.com>
In-Reply-To: <ef9ffbde-445e-f00f-23c1-27e23b6cca4f@semihalf.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d439f1b-4ef4-4feb-0abb-08da7af43f7f
x-ms-traffictypediagnostic: MN2PR11MB4693:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HMkXB5xZRL3wx86iJsxl6PkO45dw/Ddp+3ZHCZQiQ2zo0J/0p3a5GamjvB7oSJTYLnSyje/PB7Itwe/CRKpFUTj0aXnddVsypPb0S5B29KUhl20ONKGoPIgJGDHb//pTyxIbn7vXsT4k0ljYpXLyH96fh+KKZi0BNwrF8YteN8wrS80vS8gVMVEDbY0tKCaoZIEtzwFrM3m9TLzQoH+6/f8BWFVOPWSjaTTWr2Ibo5XeGDcrmkiUXdzkPh/zcwa/6kImq2LhYuJH2MUhC9ftJsOW5TjQ7ySD0rTJc2HMOcjDWCGwc7xSG4sJkNo3PipepsYSbWhwetwYvAHO2docgpCxZhifyg13SK3ecZRjX/ZvCTbAdHAqP+0Ybq2JHh4AegMPitmDgIaOlEQp5MuonYWTYZv+16bv+g+QOoRKzf4U7/QlOuYm2FLh5FWX0jSOn84LO9favCULGJDR9FMTtM11SPqmKRWq2BPx1MJXBmCbWyT+x4MDZGsaPFbdcij7UTaRuLMyZwEZVp/zDTHM3zHrGCzXgrwUqwZVn6OSsUepUBQsfBbYe8MYpPyPbC5Oy2XarumxuSiZocebC6t5Ui9Ye1w7nTOiNEnmEgeAqYdhTGa3MhuKKZAA9nFMsKmuzv8xYUYnFFEsVQfRIKp01mco/fgqOnbYgBx5/okrGXOMs/49DbOSLPKODJYzT44z5Co8vw7EXr3TmFYdxH/FSYn14Lsn2Ov448O/K9YgxlKjUr05+nj/XJU/DNwdnytxUwaSxQ/+g7dYRFjWM7YW6ULPvm6d/ZTlX+pRdjN3J/gkL+3fLW83XSqt09nC2zmf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3042.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(396003)(39860400002)(136003)(346002)(7416002)(7696005)(6506007)(5660300002)(71200400001)(4326008)(316002)(8676002)(8936002)(52536014)(66946007)(66556008)(66476007)(64756008)(41300700001)(66446008)(54906003)(110136005)(26005)(9686003)(76116006)(82960400001)(33656002)(86362001)(186003)(55016003)(83380400001)(478600001)(38100700002)(2906002)(38070700005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZCtKbHBaVUpKSDJxTXhBTW5yMkNWUGptaThJTzdIUUJKY0xUdU8wQWdCWGFQ?=
 =?utf-8?B?VVlVS29Xd3o5dkNjMlloejhCeDlCZDhUanh3N000ZW1vMGlrUW9XS3pjVXpH?=
 =?utf-8?B?SVFxRGFoUndNalpmTlFTeEFySkYwcnR3MFl5WVpCaTdoNElGRHczT3lOK0Fq?=
 =?utf-8?B?RXJ5TFZXeTIzc0tEUGFoT29xSm0yLzhocUNHbWZIZmdJREJ4TWNQV1Vsbmhl?=
 =?utf-8?B?MTl4bTEzQWE2a0IzUitKdDdzaDhZNjVzcGdmZ2RPTXUvTVRqTU5VaWMrL1BP?=
 =?utf-8?B?c2NSaUFJWW5kRW9YNVZmRkx3a3lJblp0TlZndDdTb0pvOEN6ZEk3Y1AvakJY?=
 =?utf-8?B?OUhha1JyY0RWSzRWZzlVcEVJbFZqYWtQaTZCWTY5bjJVTGtISXJVOGtzSXQy?=
 =?utf-8?B?SWVUVXRDanFoWUlET0lYbm9yQVNMRVgzVklOMjFmRUlXV0g3S2NCNXhXRWc2?=
 =?utf-8?B?MU1PRFYweFRKSzN1aFVxQVlMeXV0T0RvVWNEMExGZnN1Y0N1emNneGh1WXV2?=
 =?utf-8?B?NnVDYmZRMGxUM2pUR24zTkdRMnNORjdsNWk2YThqWUVWSHRTbnEyOW1na21R?=
 =?utf-8?B?eDhpZmJiL2ZUU09QN1hYWFlvdXZHQ2Z0cGVIYzFUUVgwWWpoejFvZ3ZJaXN3?=
 =?utf-8?B?di9pRGh1c0hJVFRONlp3WnRFd24xNklnc1RXWWROcndnYVA4MUh0c1o2dU9B?=
 =?utf-8?B?WDN0d0xKODgzQW1STHI0Y0diZS82bGlNYW5vWldnMG5zRW1ESXZlNWRuZ1FJ?=
 =?utf-8?B?eUdMR3Y5UzZjblZqYm1vWnFydFVZYjR1Q0ZnYSs5cmtXN2djeDFodUR5enIy?=
 =?utf-8?B?TTRrMzhPNFhPeEc4RHo1MXI0ZFV6WjV4SE9aVzYrbkVXeDJzVksxdjBuVUFt?=
 =?utf-8?B?NysxVDNSdkpNOXozck44VFFNckg4cCs1cWpOeUoySm5WWm5Rdy9ad3ltSitK?=
 =?utf-8?B?TE9IOERWaGRQYWRYVUlDYnlWUTRSbHgwQVo4VWtyRkloa0owN09Xb3VSQ3BY?=
 =?utf-8?B?a1BUN3lSZDJhWk5ldTk2RXcxdHpZSklPRC9vWU1rNitBRWcva0FlckV6WlZL?=
 =?utf-8?B?ZC82NUEwZk1jRWdPOXNNekorSUpJOGRtTmVzTk9HZFdXaWhVcktVWk1FREJ0?=
 =?utf-8?B?T2ZIVVhiT1NhaXQvMUJtR080V0lESkJjUy9NZVp6Q3dMZkFMSjVmeVlydzdq?=
 =?utf-8?B?SGsxZGJUYUhjZHF6K1JMa2lBNm53dVphcVNPekU0ekQ5UUEvZ0lVQU9RZ0tv?=
 =?utf-8?B?OTczUWNhMDdHbG5UOStDQk9tWjJtUlNuQk9YWE5uTCtsc0pkUzJuTVh3eDlF?=
 =?utf-8?B?dDRHMktWMUpRcU5VTDJnamV3Y0lYQlkvT2NScFFOeDVWZE1KWFg4T1hIeHRm?=
 =?utf-8?B?SDZQMFhDY0lHYnk5bStka3BMQXhBWFZzaExQaHZFNlBhSDFrcElqVzYyMG5h?=
 =?utf-8?B?SUhzRE8zTERiN3RxaUZ4a0xEQXJSY0sxRDljOTFMclhEVDlPcUdNKzJET0tl?=
 =?utf-8?B?MVdVUGdyYUo0bjlNamFrdFM1alkwdDkxdUE0RGRNVGVWd05QNm5iVFhWM0M0?=
 =?utf-8?B?ZDNmNWpiQ0o5MmcyTDdQeTVVY096R3hxeFpzOFZzd0FPQU9WdFpmU1cvQm4r?=
 =?utf-8?B?ZXJYdGxUTFJHeTBVSStEUDlNTkRWWjhHWUZJeEwxcU50TExVMVRDek9uYTRq?=
 =?utf-8?B?V05MeFA1dXhWVEEwRlJNbWtJTkUyL0dUVjNVbEc5d3U5bTFZcVA1cEg4T2Z6?=
 =?utf-8?B?citjYUwvR0VDeXI4VlFTREtPU0RwR3FmQ1NZcXd0WlZrMkhZYldkRzFuMC95?=
 =?utf-8?B?SkZOOXZjVW1PQVh5bXdqSGFsSlRsMTNIRkp2ZkJDeENRQnp2S3FONEJ5cWdG?=
 =?utf-8?B?aG0xSExiQzhJWFhDaGM3RUprMk9zSms5SGYrcTZCcXNvU2ptQ0xpUWkrN0xo?=
 =?utf-8?B?UXpJbWtLMmRJWmF5ZmdqQ0lsc2gwWTlyay9yQUE2NjZSM1hoZGEyZmhkU0xz?=
 =?utf-8?B?ckVqOVlnTkNtVzFJV2p3WHQ1OXpTZmhNWStNcnFBZ3FZT2hCZTFDVVFsNVhD?=
 =?utf-8?B?akNuY1lPcHRKR0psd0NWaGZWYkRVK250cGd6MGZSUUlOTXA0a0JXTnlST3ZH?=
 =?utf-8?Q?BI9QAdNXZ/T3aHBUAeDnyAnE8?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3042.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d439f1b-4ef4-4feb-0abb-08da7af43f7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2022 17:17:48.1933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: udmjipW52S9QFvym2LYCDfiGh664eOq5hMMwNLX1wZEurd9NwfyMgZvAro8gArTYZK9LvC3Pac16TqpCaTRGZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4693
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

PiA+DQo+ID4NCj4gPj4gSG93ZXZlciwgd2l0aCBLVk0gKyB2ZmlvIChvciB3aGF0ZXZlciBpcyBs
aXN0ZW5pbmcgb24gdGhlIHJlc2FtcGxlZmQpDQo+ID4+IHdlIGRvbid0IGNoZWNrIHRoYXQgdGhl
IGludGVycnVwdCBpcyBzdGlsbCBtYXNrZWQgaW4gdGhlIGd1ZXN0IGF0IHRoZSBtb21lbnQNCj4g
b2YgRU9JLg0KPiA+PiBSZXNhbXBsZWZkIGlzIG5vdGlmaWVkIHJlZ2FyZGxlc3MsIHNvIHZmaW8g
cHJlbWF0dXJlbHkgdW5tYXNrcyB0aGUNCj4gPj4gaG9zdCBwaHlzaWNhbCBJUlEsIHRodXMgYSBu
ZXcgKHVud2FudGVkKSBwaHlzaWNhbCBpbnRlcnJ1cHQgaXMNCj4gPj4gZ2VuZXJhdGVkIGluIHRo
ZSBob3N0IGFuZCBxdWV1ZWQgZm9yIGluamVjdGlvbiB0byB0aGUgZ3Vlc3QuIg0KPiA+Pg0KPiA+
DQo+ID4gRW11bGF0aW9uIG9mIGxldmVsIHRyaWdnZXJlZCBJUlEgaXMgYSBwYWluIHBvaW50IOKY
uSBJIHJlYWQgd2UgbmVlZCB0bw0KPiA+IGVtdWxhdGUgdGhlICJsZXZlbCIgb2YgdGhlIElSUSBw
aW4gKGNvbm5lY3RpbmcgZnJvbSBkZXZpY2UgdG8gSVJRY2hpcCwgaS5lLg0KPiBpb2FwaWMgaGVy
ZSkuDQo+ID4gVGVjaG5pY2FsbHksIHRoZSBndWVzdCBjYW4gY2hhbmdlIHRoZSBwb2xhcml0eSBv
ZiB2SU9BUElDLCB3aGljaCB3aWxsDQo+ID4gbGVhZCB0byBhIG5ldyAgdmlydHVhbCBJUlEgZXZl
biB3L28gaG9zdCBzaWRlIGludGVycnVwdC4NCj4gDQo+IFRoYW5rcywgaW50ZXJlc3RpbmcgcG9p
bnQuIERvIHlvdSBtZWFuIHRoYXQgdGhpcyBiZWhhdmlvciAoYSBuZXcgdklSUSBhcyBhDQo+IHJl
c3VsdCBvZiBwb2xhcml0eSBjaGFuZ2UpIG1heSBhbHJlYWR5IGhhcHBlbiB3aXRoIHRoZSBleGlz
dGluZyBLVk0gY29kZT8NCj4gDQo+IEl0IGRvZXNuJ3Qgc2VlbSBzbyB0byBtZS4gQUZBSUNULCBL
Vk0gY29tcGxldGVseSBpZ25vcmVzIHRoZSB2SU9BUElDIHBvbGFyaXR5DQo+IGJpdCwgaW4gcGFy
dGljdWxhciBpdCBkb2Vzbid0IGhhbmRsZSBjaGFuZ2Ugb2YgdGhlIHBvbGFyaXR5IGJ5IHRoZSBn
dWVzdCAoaS5lLg0KPiBkb2Vzbid0IHVwZGF0ZSB0aGUgdmlydHVhbCBJUlIgcmVnaXN0ZXIsIGFu
ZCBzbyBvbiksIHNvIGl0IHNob3VsZG4ndCByZXN1bHQgaW4gYQ0KPiBuZXcgaW50ZXJydXB0Lg0K
DQpDb3JyZWN0LCBLVk0gZG9lc24ndCBoYW5kbGUgcG9sYXJpdHkgbm93LiBQcm9iYWJseSBiZWNh
dXNlIHVubGlrZWx5IHRoZSBjb21tZXJjaWFsIE9TZXMgDQp3aWxsIGNoYW5nZSBwb2xhcml0eS4N
Cg0KPiANCj4gU2luY2UgY29tbWl0IDEwMDk0M2M1NGUwOSAoImt2bTogeDg2OiBpZ25vcmUgaW9h
cGljIHBvbGFyaXR5IikgdGhlcmUgc2VlbXMgdG8NCj4gYmUgYW4gYXNzdW1wdGlvbiB0aGF0IEtW
TSBpbnRlcnByZXRlcyB0aGUgSVJRIGxldmVsIHZhbHVlIGFzIGFjdGl2ZSAoYXNzZXJ0ZWQpDQo+
IHZzIGluYWN0aXZlIChkZWFzc2VydGVkKSByYXRoZXIgdGhhbiBoaWdoIHZzIGxvdywgaS5lLg0K
DQpBc3NlcnRlZC9kZWFzc2VydGVkIHZzLiBoaWdoL2xvdyBpcyBzYW1lIHRvIG1lLCB0aG91Z2gg
YXNzZXJ0ZWQvZGVhc3NlcnRlZCBoaW50cyBtb3JlIGZvciBldmVudCByYXRoZXIgdGhhbiBzdGF0
ZS4NCg0KPiB0aGUgcG9sYXJpdHkgZG9lc24ndCBtYXR0ZXIgdG8gS1ZNLg0KPiANCj4gU28sIHNp
bmNlIGJvdGggc2lkZXMgKEtWTSBlbXVsYXRpbmcgdGhlIElPQVBJQywgYW5kIHZmaW8vd2hhdGV2
ZXIgZW11bGF0aW5nDQo+IGFuIGV4dGVybmFsIGludGVycnVwdCBzb3VyY2UpIHNlZW0gdG8gb3Bl
cmF0ZSBvbiBhIGxldmVsIG9mIGFic3RyYWN0aW9uIG9mDQo+ICJhc3NlcnRlZCIgdnMgImRlLWFz
c2VydGVkIiBpbnRlcnJ1cHQgc3RhdGUgcmVnYXJkbGVzcyBvZiB0aGUgcG9sYXJpdHksIGFuZCB0
aGF0DQo+IHNlZW1zIG5vdCBhIGJ1ZyBidXQgYSBmZWF0dXJlLCBpdCBzZWVtcyB0aGF0IHdlIGRv
bid0IG5lZWQgdG8gZW11bGF0ZSB0aGUgSVJRDQo+IGxldmVsIGFzIHN1Y2guIE9yIGFtIEkgbWlz
c2luZyBzb21ldGhpbmc/DQoNCllFUywgSSBrbm93IGN1cnJlbnQgS1ZNIGRvZXNuJ3QgaGFuZGxl
IGl0LiAgV2hldGhlciB3ZSBzaG91bGQgc3VwcG9ydCBpdCBpcyBhbm90aGVyIHN0b3J5IHdoaWNo
IEkgY2Fubm90IHNwZWFrIGZvci4NClBhb2xvIGFuZCBBbGV4IGFyZSB0aGUgcmlnaHQgcGVyc29u
IPCfmIoNClRoZSByZWFzb24gSSBtZW50aW9uIHRoaXMgaXMgYmVjYXVzZSB0aGUgY29tcGxleGl0
eSB0byBhZGRpbmcgYSBwZW5kaW5nIGV2ZW50IHZzLiBzdXBwb3J0aW5nIGEgaW50ZXJydXB0IHBp
biBzdGF0ZSBpcyBzYW1lLg0KSSBhbSB3b25kZXJpbmcgaWYgd2UgbmVlZCB0byByZXZpc2l0IGl0
IG9yIG5vdC4gIEJlaGF2aW9yIGNsb3NpbmcgdG8gcmVhbCBoYXJkd2FyZSBoZWxwcyB1cyB0byBh
dm9pZCBwb3RlbnRpYWwgaXNzdWVzIElNTywgYnV0IEkgYW0gZmluZSB0byBlaXRoZXIgY2hvaWNl
Lg0KDQo+IA0KPiBPVE9ILCBJIGd1ZXNzIHRoaXMgbWVhbnMgdGhhdCB0aGUgZXhpc3RpbmcgS1ZN
J3MgZW11bGF0aW9uIG9mIGxldmVsLXRyaWdnZXJlZA0KPiBpbnRlcnJ1cHRzIGlzIHNvbWV3aGF0
IGxpbWl0ZWQgKGEgZ3Vlc3QgbWF5IGxlZ2l0aW1hdGVseSBleHBlY3QgYW4gaW50ZXJydXB0DQo+
IGZpcmVkIGFzIGEgcmVzdWx0IG9mIHBvbGFyaXR5IGNoYW5nZSwgYW5kIHRoYXQgY2FzZSBpcyBu
b3Qgc3VwcG9ydGVkIGJ5IEtWTSkuIEJ1dA0KPiB0aGF0IGlzIHJhdGhlciBvdXQgb2Ygc2NvcGUg
b2YgdGhlIG9uZXNob3QgaW50ZXJydXB0cyBpc3N1ZSBhZGRyZXNzZWQgYnkgdGhpcw0KPiBwYXRj
aHNldC4NCg0KQWdyZWUuDQpJIGRpZG4ndCBrbm93IGFueSBjb21tZXJjaWFsIE9TZXMgY2hhbmdl
IHBvbGFyaXR5IGVpdGhlci4gQnV0IEkga25vdyBYZW4gaHlwZXJ2aXNvciB1c2VzIHBvbGFyaXR5
IHVuZGVyIGNlcnRhaW4gY29uZGl0aW9uLg0KT25lIGRheSwgd2UgbWF5IHNlZSB0aGUgaXNzdWUg
d2hlbiBydW5uaW5nIFhlbiBhcyBhIEwxIGh5cGVydmlzb3IuICBCdXQgdGhpcyBpcyBub3QgdGhl
IGN1cnJlbnQgd29ycnkuDQoNCg0KPiANCj4gPiAicGVuZGluZyIgZmllbGQgb2Yga3ZtX2tlcm5l
bF9pcnFmZF9yZXNhbXBsZXIgaW4gcGF0Y2ggMyBtZWFucyBtb3JlIGFuDQo+IGV2ZW50IHJhdGhl
ciB0aGFuIGFuIGludGVycnVwdCBsZXZlbC4NCg0KSSBrbm93LiAgSSBhbSBmaW5lIGVpdGhlci4N
Cg0KVGhhbmtzIEVkZGllDQoNCj4gPg0KPiA+DQo=
