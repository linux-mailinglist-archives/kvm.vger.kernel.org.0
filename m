Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41DF058E093
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 22:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344536AbiHIUDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 16:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346465AbiHIUBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 16:01:31 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5617923145;
        Tue,  9 Aug 2022 13:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660075286; x=1691611286;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xqElYosDqhV/50LXeNEoZo1BDBJLLDpv5zYPbCtMk70=;
  b=L/L6QpsSVnqMEpm+800/tnCVPbAoZRgDD/8tbQ/h45FfNwhaDv3YfzjX
   zMaAxr1w+THIOy6Kl9Cw6qC7r8mI4528t83zsK8t7aAX/u6ZGXxoZ5HMW
   dunr/fDfoSr7m/Yv5ys5nMD5b5MOnpYeSglYSVas1plp0Dc3jOxic6frI
   w6bmHs7Ju2uX4/wFxVx8vHNqZc1pvNk4+0a9icRHfNFeiOBkCrBBPzZVp
   Vp1I9sJ3qxqlp6UaMRRhNB5WPzNAnnjrqWUlM2uS/+az8MREdn02X7WS2
   oh2xoCIHTDxk74fOS1FESBN9lEq6uskepDHSM/SxInoVZrziq2/yfrHdx
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10434"; a="291711274"
X-IronPort-AV: E=Sophos;i="5.93,225,1654585200"; 
   d="scan'208";a="291711274"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 13:01:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,225,1654585200"; 
   d="scan'208";a="747167028"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 09 Aug 2022 13:01:24 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 9 Aug 2022 13:01:23 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 9 Aug 2022 13:01:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 9 Aug 2022 13:01:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 9 Aug 2022 13:01:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yi6UfPoFFKG3ILyEyKPWIZdbCA+Q03amZ5sHoQL3S5w2KedxKmX/fMYd2aNUEidPz+m9sN7jt+33vZDAYiwKY1V84qVP6TVXYKmS5J+MgPGbs2tw9YGYPkeSNIulOAtOfzfXmEwRuP4GRSxyQUyUA6lD01j4VnNHSE+KmdjmOvAQSHK65nA9MV0sU1PgTnoh8Zwh7nkYDLgJksEqkHO3dyy3sj+pWRdQ5ubhRJ206YPUhnggriLq6iq8i0g43O0S+raVOEcDUW7oPWNN/BzsPZTDSf40XsbOZ2UE5p4l6s2MZeNJFrjEqyRFtIe4L/oVI29efSDspZrXpUNQF4HeYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xqElYosDqhV/50LXeNEoZo1BDBJLLDpv5zYPbCtMk70=;
 b=kGPEwqMn+oIWfa/eUSAmN9Z40mXUcCOtrae9b70aKaVYcuKqbdP7eVgylkEr+zz2LXzsnYzd8KXorQIbtEG15OR1nqqF/aiZq7J+fca1jyz0ZNgwX3OrJob/q6RA5Va2b8vKXjhInuG1f1woRrubAchuLzxnbvmc9buZsAbIUZq/01sGHC7S6DS5fPVy4CBESdy7e+dQsOmOEjpLa7Eb2hRQEJPtiz9xXzw5At9CgMBT2WrbJrMHwDNbGXJ7hR+hOZkXy/i9pO1wLJ9+J9exvraQsT9tjjW95XzmrynjVnhQItzyGwTq1J8JrsQOAFj89PCcvU5DhJ4/ViCjc3O2kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3042.namprd11.prod.outlook.com (2603:10b6:208:78::17)
 by SN7PR11MB6750.namprd11.prod.outlook.com (2603:10b6:806:266::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Tue, 9 Aug
 2022 20:01:20 +0000
Received: from BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::e849:56d0:f131:8efe]) by BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::e849:56d0:f131:8efe%7]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 20:01:19 +0000
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
        Dmitry Torokhov <dtor@google.com>
Subject: RE: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
Thread-Topic: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
Thread-Index: AQHYqQNV5DxKJST9sEC1NUps5Q8SMK2lqmdAgACFsACAANA2YA==
Date:   Tue, 9 Aug 2022 20:01:19 +0000
Message-ID: <BL0PR11MB304213273FA9FAC4EBC70FF88A629@BL0PR11MB3042.namprd11.prod.outlook.com>
References: <20220805193919.1470653-1-dmy@semihalf.com>
 <BL0PR11MB30429034B6D59253AF22BCE08A639@BL0PR11MB3042.namprd11.prod.outlook.com>
 <c5d8f537-5695-42f0-88a9-de80e21f5f4c@semihalf.com>
In-Reply-To: <c5d8f537-5695-42f0-88a9-de80e21f5f4c@semihalf.com>
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
x-ms-office365-filtering-correlation-id: 5429582a-c4fb-41a6-e7f0-08da7a41ed50
x-ms-traffictypediagnostic: SN7PR11MB6750:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LOSH2NlrB5wliHTAEkZuabmSkALFmbEhxC+hP2/3ITUxh33WDKgkbzzagW8blE2iQgPlwro9JLfPju5Od3O+5gOi4OW1vsTIWjTbPlhrFzATHFv3nLAFGJLJQpJ4t0Wx9G5I68YPE7bU0kalFFEd5LbRcECk1OjGhYVDXy6TROyUvVzLy6CwySzRD0j7B/iKgEvXAvt4tgD3EMIdI9PkHu/WpBA4g1UhIrkYxzXRjxhSkr/+4l7NTqSJUe38ASbDFj3upPJqJlZUVzh+xmNjootzPZYrUWB0Nli1Gt8vhks6Sm1cv+eGO56t22PXOcnMUualkDTXVJxHcspWKB5Dq2CyzCkZDVG9XenLzsShIb7YO/TAbiV1GUOcqmyY/PJX9XvizQhiDQBZ3xfFLLc7nM4/47ZdZSOs3CCWMWhcX4lYT7bJlHHcrvHxNeqwPKQDoFMPitCpr6bIVdXoVxC6IMswVwF/sOfDdWKIsStBlaUoCDaGkOEts3iA2ZESDWUAqWmmMFteNDtu+9CkZW6JMjFrbv0uQCmc97jZBpKpdcBQ3tW+XB6xke0elOS8bJziAZrLSg/+Ew/vncHvRTTrKvZUpfy3isyJCXR8IKaUVj75uENP+FannvsvY5CYGGb4I8WtsfBZyULXFSWp/B0LUr8P2XRpLPZxAs8G0WoKAdzi9eVzEtr0v9+ZnU9FMg/jhUDtzDRRSEr3k83MCVSouyNhgZxk4Zh9FsHhDN7L0OChbkKyjp2XEbl0Lt9is6EHk6qfEb2pMPO8aZkgzIQkmXlhJVga6EYJ+qbP6uyzSCpaEnoG2LIpKGt/AJHOe5V3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3042.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(39860400002)(366004)(136003)(346002)(316002)(54906003)(38100700002)(7416002)(52536014)(110136005)(5660300002)(33656002)(64756008)(4326008)(8936002)(66946007)(66556008)(66446008)(76116006)(8676002)(66476007)(53546011)(478600001)(6506007)(2906002)(9686003)(71200400001)(38070700005)(55016003)(41300700001)(82960400001)(7696005)(26005)(186003)(122000001)(86362001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NVIwZ1I1ZG9zbDZkbE5RWVZtaDBESlROK0dJNTNWZWkvaUsrcGNNNnpoUU1w?=
 =?utf-8?B?Y0J5ckh3UHVQRXp1NlpWUGJBL09wRWNNQXN5UWlUNjkwSUx2WlFQcGt5UnBW?=
 =?utf-8?B?M3ZVWnllaDdVcnVDdzBYVE9IVGxKNjlmblRNWUdDeStGVnRoOUY5Y01Ydno2?=
 =?utf-8?B?VnVkbTVxdUczUHBwek56bm5TcFErNTlQQ3BvV2tHS05BZGdmbGl5VnlwYkpH?=
 =?utf-8?B?WXNWRjFLQTV1WHk4R2U1MmRlQkFwTlYyblNiWGlxNkFCQnJGMUhHTGFzZ1E4?=
 =?utf-8?B?TXF6emtMWDdYWEx5UWV5RnJBMlYybzBUb0pZM1U2bGdnVDl0MWRIenVSWkM5?=
 =?utf-8?B?N1NsaUhXdFQxaFI3cHNpRWZDSGUwTWt2MjJyUGl2YS9ZMUNVWXlEUEJqSEhy?=
 =?utf-8?B?ZHlXdGd5Qm55Wm95MlRMeE1CTFdra2kwM3FvZzU2MGJ4djB0d0IrK0JiNUoy?=
 =?utf-8?B?RW5ZZDdLajJWdXg2NTFMM01tK1pqYWhMUG5oUXhINGEzTFI1eXY4T0ZwdCt1?=
 =?utf-8?B?TXA2aDg2WXVtUXUzMG1jOXNIRm5LdXZBSUxmNVVZYzY3amV0czlnMXVQdmlO?=
 =?utf-8?B?VVJzcndaTzc2NTdKODJzTVU5dFk3Tjd4UkhWelI5QzJKZGJZcGhZK2xBVkc1?=
 =?utf-8?B?cTFwNHA3WVc0aGYyVnRWRWpNOTg0L1FxTXVsNnFMRG9Ld090OGNJNWYzUDAy?=
 =?utf-8?B?UE9IbGhHM0NXSDIyOWNjWDB0QWJIQ0dYbFU3d1I4eCtFV1ozaEk5L2p5aW5u?=
 =?utf-8?B?YmhCeTZLZDgvRUxULzJ4T3ZtMU1udTJCdjNmKzl5NkduUUgyM2h2MXBKbEUr?=
 =?utf-8?B?TXRSUHBsd1ljYms0TDlqSzlPQktrSmZtVnowdEl6RnBvazFMMEIwMTZndnhI?=
 =?utf-8?B?eHhaNExQTlNENjNJenA0dGNlc0lXMCtNejcxaWVSd3hSTzA4QXl0bVM5KzZI?=
 =?utf-8?B?NjV0QWR3eDdZNmZicFBNYVZiZDFRTEhXSG1tNGJtbjNDZGtkZXpxUm9JKzk2?=
 =?utf-8?B?QVpyOFU5U0pRV2dnUnVaNkhGWHR1cmhnVVIwelBxZWk5Nmo1eG16djdUN2xq?=
 =?utf-8?B?ekxoQ21uTE9nVVBqNmpHMDJGOVpBVkhCWWtOTGM4dWRWYWtheDVjQ0N4RG5V?=
 =?utf-8?B?VzEzOXR0LzFLUCtCMGJQK2syWmwycE82eENkMGh5bTc2UFNUdll2S0UzK1A0?=
 =?utf-8?B?MU5LWmJzVkNNb3pSWE9laUg1aHdRdERqOEp3WDEvOU93OVVsVlJ4L0ZPNW9z?=
 =?utf-8?B?Mm9DWnU3bFdzY2NBK3FQR3hBRDlDTXdla2ZweitzR2pFdVBia0xac1RnV3Z5?=
 =?utf-8?B?bXU0YWZheDBJdWE2UGtEVWtueDJWM2RKclBCeEpIN3E0R1dDZ3hFYndvUTBQ?=
 =?utf-8?B?U0FjbnBqVXlwTHkvdHpJNmloTTRoa25aR2Job0Y3MGFZU3FFNXhBalFqOWZF?=
 =?utf-8?B?dmlYNlpxaHlyektRWDJ6Q0d6emVVcnBXSkIwbjc2bUZyZ3VrdW9pR09pNGFT?=
 =?utf-8?B?OGdlRVQ1VUFQQTdXVHh5bW4zQm5wU0kwU1ppUXdFaytuZ3lTb2o2aVZidEti?=
 =?utf-8?B?SU9LNFpXakc0SzhoMmxDNDNEYVhnR2NDK0VNb05SY3hxSXpPL29FQUFaYVNT?=
 =?utf-8?B?RjAzMmxuTkV6M3k1VUNZNndZWDErSklkMTdpVXhNcXgwVkJXcjlDUmdYQkpj?=
 =?utf-8?B?OGlOYzlhMnBCYU5HOXg0MW9Mdm14SWp3YkkxalJtYXNZUW9aY2hXNXE0aDd6?=
 =?utf-8?B?ZHNtT1czcDhCOTVKV3FSTGdEdWNhSE9hRWYrQWlEbm5FZ2t5ZXEzUTVYaEIw?=
 =?utf-8?B?WXdVYkY4UGdKVmtVVGI1aVUwQ1hVNDVDem95VnJzY1dhRUtyenZCb2NKR1ZB?=
 =?utf-8?B?S2VBcTFLMi9sYW82SlQyalIvWXlnaGZ3ODhQUnVZdUR5NXkzK1ZWMjhZME5L?=
 =?utf-8?B?bTZsOXNOSmcvYTRaK29vVjlDbmpCNG1MNDJhSkNzK2NkY3hWMjFMaFYrZG5G?=
 =?utf-8?B?dkVqMUxlcHh6ZktyMG5HMnA4Sjk5U0FHVGVkdGRDWCtIMlBXSjE5OWx0elVz?=
 =?utf-8?B?by9uVkhJN0RyTVgyeEQwSk0yWlFDTVliU21kTE81Q2tJRmNFbW8wOVJSS0xC?=
 =?utf-8?Q?Gntrhep8i8g8mRy0MhA7x7lQT?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3042.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5429582a-c4fb-41a6-e7f0-08da7a41ed50
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2022 20:01:19.8686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VINiRxkoCWs/xbh0Wj/XN6ehJbsWKZ8e7FQbrD1QRqPO4EvtgIC2ZLM5VjrG+Nx5+P1+m3Bi43uL5s5kSJ6YCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6750
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRG15dHJvIE1hbHVrYSA8
ZG15QHNlbWloYWxmLmNvbT4NCj4gU2VudDogVHVlc2RheSwgQXVndXN0IDksIDIwMjIgMTI6MjQg
QU0NCj4gVG86IERvbmcsIEVkZGllIDxlZGRpZS5kb25nQGludGVsLmNvbT47IENocmlzdG9waGVy
c29uLCwgU2Vhbg0KPiA8c2VhbmpjQGdvb2dsZS5jb20+OyBQYW9sbyBCb256aW5pIDxwYm9uemlu
aUByZWRoYXQuY29tPjsNCj4ga3ZtQHZnZXIua2VybmVsLm9yZw0KPiBDYzogVGhvbWFzIEdsZWl4
bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+OyBJbmdvIE1vbG5hciA8bWluZ29AcmVkaGF0LmNvbT47
DQo+IEJvcmlzbGF2IFBldGtvdiA8YnBAYWxpZW44LmRlPjsgRGF2ZSBIYW5zZW4gPGRhdmUuaGFu
c2VuQGxpbnV4LmludGVsLmNvbT47DQo+IHg4NkBrZXJuZWwub3JnOyBILiBQZXRlciBBbnZpbiA8
aHBhQHp5dG9yLmNvbT47IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyBFcmljIEF1
Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+OyBBbGV4DQo+IFdpbGxpYW1zb24gPGFsZXgud2ls
bGlhbXNvbkByZWRoYXQuY29tPjsgTGl1LCBSb25nIEwgPHJvbmcubC5saXVAaW50ZWwuY29tPjsN
Cj4gWmhlbnl1IFdhbmcgPHpoZW55dXdAbGludXguaW50ZWwuY29tPjsgVG9tYXN6IE5vd2lja2kN
Cj4gPHRuQHNlbWloYWxmLmNvbT47IEdyemVnb3J6IEphc3pjenlrIDxqYXpAc2VtaWhhbGYuY29t
PjsNCj4gdXBzdHJlYW1Ac2VtaWhhbGYuY29tOyBEbWl0cnkgVG9yb2tob3YgPGR0b3JAZ29vZ2xl
LmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiAwLzVdIEtWTTogRml4IG9uZXNob3QgaW50
ZXJydXB0cyBmb3J3YXJkaW5nDQo+IA0KPiBPbiA4LzkvMjIgMToyNiBBTSwgRG9uZywgRWRkaWUg
d3JvdGU6DQo+ID4+DQo+ID4+IFRoZSBleGlzdGluZyBLVk0gbWVjaGFuaXNtIGZvciBmb3J3YXJk
aW5nIG9mIGxldmVsLXRyaWdnZXJlZA0KPiA+PiBpbnRlcnJ1cHRzIHVzaW5nIHJlc2FtcGxlIGV2
ZW50ZmQgZG9lc24ndCB3b3JrIHF1aXRlIGNvcnJlY3RseSBpbiB0aGUNCj4gPj4gY2FzZSBvZiBp
bnRlcnJ1cHRzIHRoYXQgYXJlIGhhbmRsZWQgaW4gYSBMaW51eCBndWVzdCBhcyBvbmVzaG90DQo+
ID4+IGludGVycnVwdHMgKElSUUZfT05FU0hPVCkuIFN1Y2ggYW4gaW50ZXJydXB0IGlzIGFja2Vk
IHRvIHRoZSBkZXZpY2UNCj4gPj4gaW4gaXRzIHRocmVhZGVkIGlycSBoYW5kbGVyLCBpLmUuIGxh
dGVyIHRoYW4gaXQgaXMgYWNrZWQgdG8gdGhlDQo+ID4+IGludGVycnVwdCBjb250cm9sbGVyIChF
T0kgYXQgdGhlIGVuZCBvZiBoYXJkaXJxKSwgbm90IGVhcmxpZXIuIFRoZQ0KPiA+PiBleGlzdGlu
ZyBLVk0gY29kZSBkb2Vzbid0IHRha2UgdGhhdCBpbnRvIGFjY291bnQsIHdoaWNoIHJlc3VsdHMg
aW4NCj4gPj4gZXJyb25lb3VzIGV4dHJhIGludGVycnVwdHMgaW4gdGhlIGd1ZXN0IGNhdXNlZCBi
eSBwcmVtYXR1cmUgcmUtYXNzZXJ0IG9mIGFuDQo+IHVuYWNrbm93bGVkZ2VkIElSUSBieSB0aGUg
aG9zdC4NCj4gPg0KPiA+IEludGVyZXN0aW5nLi4uICBIb3cgaXQgYmVoYXZpb3JzIGluIG5hdGl2
ZSBzaWRlPw0KPiANCj4gSW4gbmF0aXZlIGl0IGJlaGF2ZXMgY29ycmVjdGx5LCBzaW5jZSBMaW51
eCBtYXNrcyBzdWNoIGEgb25lc2hvdCBpbnRlcnJ1cHQgYXQgdGhlDQo+IGJlZ2lubmluZyBvZiBo
YXJkaXJxLCBzbyB0aGF0IHRoZSBFT0kgYXQgdGhlIGVuZCBvZiBoYXJkaXJxIGRvZXNuJ3QgcmVz
dWx0IGluIGl0cw0KPiBpbW1lZGlhdGUgcmUtYXNzZXJ0LCBhbmQgdGhlbiB1bm1hc2tzIGl0IGxh
dGVyLCBhZnRlciBpdHMgdGhyZWFkZWQgaXJxIGhhbmRsZXINCj4gY29tcGxldGVzLg0KPiANCj4g
SW4gaGFuZGxlX2Zhc3Rlb2lfaXJxKCk6DQo+IA0KPiAJaWYgKGRlc2MtPmlzdGF0ZSAmIElSUVNf
T05FU0hPVCkNCj4gCQltYXNrX2lycShkZXNjKTsNCj4gDQo+IAloYW5kbGVfaXJxX2V2ZW50KGRl
c2MpOw0KPiANCj4gCWNvbmRfdW5tYXNrX2VvaV9pcnEoZGVzYywgY2hpcCk7DQo+IA0KPiANCj4g
YW5kIGxhdGVyIGluIHVubWFza190aHJlYWRlZF9pcnEoKToNCj4gDQo+IAl1bm1hc2tfaXJxKGRl
c2MpOw0KPiANCj4gSSBhbHNvIG1lbnRpb25lZCB0aGF0IGluIHBhdGNoICMzIGRlc2NyaXB0aW9u
Og0KPiAiTGludXgga2VlcHMgc3VjaCBpbnRlcnJ1cHQgbWFza2VkIHVudGlsIGl0cyB0aHJlYWRl
ZCBoYW5kbGVyIGZpbmlzaGVzLCB0bw0KPiBwcmV2ZW50IHRoZSBFT0kgZnJvbSByZS1hc3NlcnRp
bmcgYW4gdW5hY2tub3dsZWRnZWQgaW50ZXJydXB0Lg0KDQpUaGF0IG1ha2VzIHNlbnNlLiBDYW4g
eW91IGluY2x1ZGUgdGhlIGZ1bGwgc3RvcnkgaW4gY292ZXIgbGV0dGVyIHRvbz8NCg0KDQo+IEhv
d2V2ZXIsIHdpdGggS1ZNICsgdmZpbyAob3Igd2hhdGV2ZXIgaXMgbGlzdGVuaW5nIG9uIHRoZSBy
ZXNhbXBsZWZkKSB3ZSBkb24ndA0KPiBjaGVjayB0aGF0IHRoZSBpbnRlcnJ1cHQgaXMgc3RpbGwg
bWFza2VkIGluIHRoZSBndWVzdCBhdCB0aGUgbW9tZW50IG9mIEVPSS4NCj4gUmVzYW1wbGVmZCBp
cyBub3RpZmllZCByZWdhcmRsZXNzLCBzbyB2ZmlvIHByZW1hdHVyZWx5IHVubWFza3MgdGhlIGhv
c3QNCj4gcGh5c2ljYWwgSVJRLCB0aHVzIGEgbmV3ICh1bndhbnRlZCkgcGh5c2ljYWwgaW50ZXJy
dXB0IGlzIGdlbmVyYXRlZCBpbiB0aGUgaG9zdA0KPiBhbmQgcXVldWVkIGZvciBpbmplY3Rpb24g
dG8gdGhlIGd1ZXN0LiINCj4gDQoNCkVtdWxhdGlvbiBvZiBsZXZlbCB0cmlnZ2VyZWQgSVJRIGlz
IGEgcGFpbiBwb2ludCDimLkNCkkgcmVhZCB3ZSBuZWVkIHRvIGVtdWxhdGUgdGhlICJsZXZlbCIg
b2YgdGhlIElSUSBwaW4gKGNvbm5lY3RpbmcgZnJvbSBkZXZpY2UgdG8gSVJRY2hpcCwgaS5lLiBp
b2FwaWMgaGVyZSkuDQpUZWNobmljYWxseSwgdGhlIGd1ZXN0IGNhbiBjaGFuZ2UgdGhlIHBvbGFy
aXR5IG9mIHZJT0FQSUMsIHdoaWNoIHdpbGwgbGVhZCB0byBhIG5ldyAgdmlydHVhbCBJUlEgDQpl
dmVuIHcvbyBob3N0IHNpZGUgaW50ZXJydXB0LiAgDQoicGVuZGluZyIgZmllbGQgb2Yga3ZtX2tl
cm5lbF9pcnFmZF9yZXNhbXBsZXIgaW4gcGF0Y2ggMyBtZWFucyBtb3JlIGFuIGV2ZW50IHJhdGhl
ciB0aGFuIGFuIGludGVycnVwdCBsZXZlbC4NCg0KDQo+ID4NCj4gPj4NCj4gPj4gVGhpcyBwYXRj
aCBzZXJpZXMgZml4ZXMgdGhpcyBpc3N1ZSAoZm9yIG5vdyBvbiB4ODYgb25seSkgYnkgY2hlY2tp
bmcNCj4gPj4gaWYgdGhlIGludGVycnVwdCBpcyB1bm1hc2tlZCB3aGVuIHdlIHJlY2VpdmUgaXJx
IGFjayAoRU9JKSBhbmQsIGluDQo+ID4+IGNhc2UgaWYgaXQncyBtYXNrZWQsIHBvc3Rwb25pbmcg
cmVzYW1wbGVmZCBub3RpZnkgdW50aWwgdGhlIGd1ZXN0IHVubWFza3MgaXQuDQo+ID4+DQo+ID4+
IFBhdGNoZXMgMSBhbmQgMiBleHRlbmQgdGhlIGV4aXN0aW5nIHN1cHBvcnQgZm9yIGlycSBtYXNr
IG5vdGlmaWVycyBpbg0KPiA+PiBLVk0sIHdoaWNoIGlzIGEgcHJlcmVxdWlzaXRlIG5lZWRlZCBm
b3IgS1ZNIGlycWZkIHRvIHVzZSBtYXNrDQo+ID4+IG5vdGlmaWVycyB0byBrbm93IHdoZW4gYW4g
aW50ZXJydXB0IGlzIG1hc2tlZCBvciB1bm1hc2tlZC4NCj4gPj4NCj4gPj4gUGF0Y2ggMyBpbXBs
ZW1lbnRzIHRoZSBhY3R1YWwgZml4OiBwb3N0cG9uaW5nIHJlc2FtcGxlZmQgbm90aWZ5IGluDQo+
ID4+IGlycWZkIHVudGlsIHRoZSBpcnEgaXMgdW5tYXNrZWQuDQo+ID4+DQo+ID4+IFBhdGNoZXMg
NCBhbmQgNSBqdXN0IGRvIHNvbWUgb3B0aW9uYWwgcmVuYW1pbmcgZm9yIGNvbnNpc3RlbmN5LCBh
cyB3ZQ0KPiA+PiBhcmUgbm93IHVzaW5nIGlycSBtYXNrIG5vdGlmaWVycyBpbiBpcnFmZCBhbG9u
ZyB3aXRoIGlycSBhY2sgbm90aWZpZXJzLg0KPiA+Pg0KPiA+PiBQbGVhc2Ugc2VlIGluZGl2aWR1
YWwgcGF0Y2hlcyBmb3IgbW9yZSBkZXRhaWxzLg0KPiA+Pg0KPiA+PiB2MjoNCj4gPj4gICAtIEZp
eGVkIGNvbXBpbGF0aW9uIGZhaWx1cmUgb24gbm9uLXg4NjogbWFza19ub3RpZmllcl9saXN0IG1v
dmVkIGZyb20NCj4gPj4gICAgIHg4NiAic3RydWN0IGt2bV9hcmNoIiB0byBnZW5lcmljICJzdHJ1
Y3Qga3ZtIi4NCj4gPj4gICAtIGt2bV9maXJlX21hc2tfbm90aWZpZXJzKCkgYWxzbyBtb3ZlZCBm
cm9tIHg4NiB0byBnZW5lcmljIGNvZGUsIGV2ZW4NCj4gPj4gICAgIHRob3VnaCBpdCBpcyBub3Qg
Y2FsbGVkIG9uIG90aGVyIGFyY2hpdGVjdHVyZXMgZm9yIG5vdy4NCj4gPj4gICAtIEluc3RlYWQg
b2Yga3ZtX2lycV9pc19tYXNrZWQoKSBpbXBsZW1lbnRlZA0KPiA+PiAgICAga3ZtX3JlZ2lzdGVy
X2FuZF9maXJlX2lycV9tYXNrX25vdGlmaWVyKCkgdG8gZml4IHBvdGVudGlhbCByYWNlDQo+ID4+
ICAgICB3aGVuIHJlYWRpbmcgdGhlIGluaXRpYWwgSVJRIG1hc2sgc3RhdGUuDQo+ID4+ICAgLSBS
ZW5hbWVkIGZvciBjbGFyaXR5Og0KPiA+PiAgICAgICAtIGlycWZkX3Jlc2FtcGxlcl9tYXNrKCkg
LT4gaXJxZmRfcmVzYW1wbGVyX21hc2tfbm90aWZ5KCkNCj4gPj4gICAgICAgLSBrdm1faXJxX2hh
c19ub3RpZmllcigpIC0+IGt2bV9pcnFfaGFzX2Fja19ub3RpZmllcigpDQo+ID4+ICAgICAgIC0g
cmVzYW1wbGVyLT5ub3RpZmllciAtPiByZXNhbXBsZXItPmFja19ub3RpZmllcg0KPiA+PiAgIC0g
UmVvcmdhbml6ZWQgY29kZSBpbiBpcnFmZF9yZXNhbXBsZXJfYWNrKCkgYW5kDQo+ID4+ICAgICBp
cnFmZF9yZXNhbXBsZXJfbWFza19ub3RpZnkoKSB0byBtYWtlIGl0IGVhc2llciB0byBmb2xsb3cu
DQo+ID4+ICAgLSBEb24ndCBmb2xsb3cgdW53YW50ZWQgInJldHVybiB0eXBlIG9uIHNlcGFyYXRl
IGxpbmUiIHN0eWxlIGZvcg0KPiA+PiAgICAgaXJxZmRfcmVzYW1wbGVyX21hc2tfbm90aWZ5KCku
DQo+ID4+DQo+ID4+IERteXRybyBNYWx1a2EgKDUpOg0KPiA+PiAgIEtWTTogeDg2OiBNb3ZlIGly
cSBtYXNrIG5vdGlmaWVycyBmcm9tIHg4NiB0byBnZW5lcmljIEtWTQ0KPiA+PiAgIEtWTTogeDg2
OiBBZGQga3ZtX3JlZ2lzdGVyX2FuZF9maXJlX2lycV9tYXNrX25vdGlmaWVyKCkNCj4gPj4gICBL
Vk06IGlycWZkOiBQb3N0cG9uZSByZXNhbXBsZWZkIG5vdGlmeSBmb3Igb25lc2hvdCBpbnRlcnJ1
cHRzDQo+ID4+ICAgS1ZNOiBpcnFmZDogUmVuYW1lIHJlc2FtcGxlci0+bm90aWZpZXINCj4gPj4g
ICBLVk06IFJlbmFtZSBrdm1faXJxX2hhc19ub3RpZmllcigpDQo+ID4+DQo+ID4+ICBhcmNoL3g4
Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIHwgIDE3ICstLS0NCj4gPj4gIGFyY2gveDg2L2t2bS9p
ODI1OS5jICAgICAgICAgICAgfCAgIDYgKysNCj4gPj4gIGFyY2gveDg2L2t2bS9pb2FwaWMuYyAg
ICAgICAgICAgfCAgIDggKy0NCj4gPj4gIGFyY2gveDg2L2t2bS9pb2FwaWMuaCAgICAgICAgICAg
fCAgIDEgKw0KPiA+PiAgYXJjaC94ODYva3ZtL2lycV9jb21tLmMgICAgICAgICB8ICA3NCArKysr
KysrKysrKy0tLS0tLQ0KPiA+PiAgYXJjaC94ODYva3ZtL3g4Ni5jICAgICAgICAgICAgICB8ICAg
MSAtDQo+ID4+ICBpbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmggICAgICAgIHwgIDIxICsrKystDQo+
ID4+ICBpbmNsdWRlL2xpbnV4L2t2bV9pcnFmZC5oICAgICAgIHwgIDE2ICsrKy0NCj4gPj4gIHZp
cnQva3ZtL2V2ZW50ZmQuYyAgICAgICAgICAgICAgfCAxMzYgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKy0tLS0NCj4gPj4gIHZpcnQva3ZtL2t2bV9tYWluLmMgICAgICAgICAgICAgfCAgIDEg
Kw0KPiA+PiAgMTAgZmlsZXMgY2hhbmdlZCwgMjIxIGluc2VydGlvbnMoKyksIDYwIGRlbGV0aW9u
cygtKQ0KPiA+Pg0KPiA+PiAtLQ0KPiA+PiAyLjM3LjEuNTU5Lmc3ODczMWYwZmRiLWdvb2cNCj4g
Pg0K
