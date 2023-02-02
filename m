Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51F86873AB
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 04:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbjBBDJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 22:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjBBDJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 22:09:04 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316301EBDD;
        Wed,  1 Feb 2023 19:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675307343; x=1706843343;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cMzybbSOw9x0qlF8rd5qPN4goU9/bAw4xdRCtG7pFEc=;
  b=DkIQ6/sf5aoUVNXkOKuKapBrpFqtbs3e18r4MKc7jIgiCFW8E2GtvdKU
   yM4ZnfNYmmR2fHZNK2E7fd2FK3b4+/AJEzh0BAKW658FhqrlGCwXv6qXL
   5wZ0b2NPm9SPB74MRwJdr6fN5Eo3zUNVIYdLl4wr7dFz3kmtELjvo0HpK
   4C/fiUJyFYkVV5TgJcHfTaGEUgzOgh7aql11I4NWF7mvo2/LVdQwW9QQS
   38nZwbC5t374/bXU9At00rfsiXDd2GdiU5/H1OYdsa1hQ7Q4o4ZfpxXzX
   yZs59lYjV6ev7FYvwjpcmw4VgnQ+/7+oMjwIS2rddjsT9bF3iulOSNOrA
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="326038217"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="326038217"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 19:09:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="667139101"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="667139101"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 01 Feb 2023 19:09:01 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 19:09:01 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 1 Feb 2023 19:09:01 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Feb 2023 19:09:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGD6uNsakNq2Wqt+jc4NtK4DqNIRzK96xjWQbuFPs5N8gVMawbQk/vSK+pQ/QdXdyuYyrcZk5HTyKUYuP0aB6dcPHgQVNPheyVxUoVfP3jAkSWEcygaidPAAFSvw0qMgBvOuR8D/k9nfA1CuG2BpxMUG9Czuen2QMZEur5yAWjuAWOVAz06NaSRCzsEmbdbStsBi7DIN3PMNEHgWlJKS/ipuPM4lpiZHAz4+yda9S9KqFFh8LE3ykSn0uxj+Da/kIACgGC/rkwG8R/GV2hocpf7bPl1Y/cxLrZQV/zO66z2HNSI0WP2u19js7ob6/uzEh+jHZe6gJhadhzAuQYpIkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cMzybbSOw9x0qlF8rd5qPN4goU9/bAw4xdRCtG7pFEc=;
 b=GBreky83frf9UyPh6LPq3WnH482hqRiZaZlOn2eF5IgfYqjEUOWaFztEw9k6V+xytND7acFx3coDWIRsPXQP9kP8MBP7vSMjtsr+6HB+2Ni6ugthnGFB7xBsJU4MRIU7ECal/gb4B6cL52tP5TzXMLMAn2xLtLeht52DaZMJ+IOApWzvPqxlQNZ1oaDQ02uPP0FT6kv4Jy4jFh9dTq2MAo38dEv+830H4ySQDjNWY4b+IdaINoZknuPYLw5yMUS5JR/dNK006LAUnZB7NV5TQzzZRF1otlhF/LO4wzItTjlm0la/vsTXKNc+NM3x+RuPqe1xty7Na4zCM+JJfbzvQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SN7PR11MB6994.namprd11.prod.outlook.com (2603:10b6:806:2ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 03:08:52 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6064.024; Thu, 2 Feb 2023
 03:08:52 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio: fix deadlock between group lock and kvm lock
Thread-Topic: [PATCH] vfio: fix deadlock between group lock and kvm lock
Thread-Index: AQHZNa+RvE0EhcYo6EGu/ai3XoxXDK64+PMAgAERCqCAACGMgIAA0A1A
Date:   Thu, 2 Feb 2023 03:08:51 +0000
Message-ID: <DS0PR11MB7529AB85290B910D910BB15BC3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230131200635.44227-1-mjrosato@linux.ibm.com>
 <Y9l5OmCRGYZM2nPy@nvidia.com>
 <DS0PR11MB7529D62614A5DFC56920EE96C3D19@DS0PR11MB7529.namprd11.prod.outlook.com>
 <3b52ffdb-c18c-f3d4-559d-9838419e2bc7@linux.ibm.com>
In-Reply-To: <3b52ffdb-c18c-f3d4-559d-9838419e2bc7@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SN7PR11MB6994:EE_
x-ms-office365-filtering-correlation-id: 7a330b0e-618a-4338-bacb-08db04cacfd2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: joFZQ4fjXkfuhPjIobi737KX8B5hTfAo31SFa8ChxPZrAAKm6P48rMgXelX/cRICIM1bLMsWrthHCmyfjig+xOAEVcRVhu14wMz0FrHOIl2RnGu3ZwlzQX6+Y1Q4B4M4NAFp4CgIZa4fyaR0lAlxcYAACdrRGHTbW7NCaUYk8GY73Km4AV7bRea+oyHVlhQuktS8iRYQk6+IbL2gCCERxcXTjYeOYdrWBZv7Q44xj38o5q+kcmEBl4yuN1yyGBeQlZn0poxYQZGwFjsbDm9xuS50Y1GNb7ZuzSEKe+nvaLGckZYj8mo8Wi1wZZpJKhOeRzaCeijrr3ILM6Wmlp9KW99kKtjE5VYDsZ4pUbaAUoZLtxNbYwhWuJ43gACc5C5ittJ3tAVvZl1n/73Nwd3/aW1kSU+aRub/FUuJd+0FF2svsaZcpZzcblNOhPiaINWS3yFpTgnURr39aEQilOrPLF69h0FwYfHP7W85za+Ww4K+c1+vbBZG+2p/+Ps54El6OFHRAgn15DGBLG8tB2gv2WpKVWU8QQC5RwaLyviZbAMXaoriHT7FQTq/2EKfajyfm7W8EYM+I3OTpZCSmTN3GbySakOPcffYnxfNbFNaoP91tVG1m0CCWUkNskzBJycr3fkDOLqvCbeXLlCzUZf6e+QdMI9FRygfyKJRRqgmphWA/RdB2KqZXdgVMSbc75IMNAeNuoHUrflWgnc4LEQYw1iqLF9Z72vFRTJIJo+tQ9w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(136003)(396003)(346002)(451199018)(9686003)(6506007)(86362001)(186003)(26005)(38070700005)(122000001)(82960400001)(7696005)(33656002)(478600001)(53546011)(71200400001)(38100700002)(66946007)(66556008)(66476007)(66446008)(64756008)(54906003)(2906002)(110136005)(316002)(52536014)(7416002)(8676002)(55016003)(5660300002)(8936002)(4326008)(83380400001)(76116006)(41300700001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODQ4eWpJakowdnlwd013UTJVa2MwZkd3L05DQklaTEorRS9RQ3paTUNiU0Yz?=
 =?utf-8?B?QnFPMERMUmVrSDdqZjlRTjJrZjFhZWlaU052c0JPSUhpeDZPQjdCM2lHS0Zl?=
 =?utf-8?B?L25wVjlEcE1sS0puK00vbEluc1Y1WElXTDQ2ZmdWZUFTUk9oSExmS2FmS2tG?=
 =?utf-8?B?WmR3ZlYrLzZ5byt3NURlL3U4U2VnaUYrbjRkQ09lajBoelN3ZXlPTldyYitO?=
 =?utf-8?B?cVE5a2ZHR0ZrS0pya1BHVnBMTHVGSjFub2h1QVk5MXp4U2FqVHJndEo1UjJ6?=
 =?utf-8?B?SDZTdWlPNjBReE9ra0taMmhzSnhPVldsNWlPcU1uK0lwYm9qbmJGNVV4eDdy?=
 =?utf-8?B?ZmoveUVOTGoxTWxoSVZ1OWZYZ2k3SVQxMy9iaXh4Q1dzYStBTVF3TEZnMjV2?=
 =?utf-8?B?dWJzeHhtVDVGeWVaZFc2YTdYSEg0MEpTeUJ1QWhwMlN2LzUrejREUXl3UXg2?=
 =?utf-8?B?Ykd4WTZLRzFxbmo0L0QrZ0M3elcvMjFsZVNmYTEwR0FtWkJTQnc4NzZtdnpp?=
 =?utf-8?B?ZldUd0VxWmExaXFpeDRjMXJIUStkbm5UYjRVbS9SZjBQZ1lLSVRmVXRRaFZy?=
 =?utf-8?B?amZtMi83L1EvTy9icndmNlU1SDdWRFUvYTl0K29ML3pONjZOK2ZFUkRIR0VU?=
 =?utf-8?B?QUl2eHp5NGlwSStkc3MxN3JGSUdsOTlKZE5nd1J6aldlQS9KTTA1V2J2WHZ4?=
 =?utf-8?B?eXRZNkNXdjlPUGpxRzNQU1pPRmhDM1FCYW15M3RjeS9sVDNCaEZLSUExdGhj?=
 =?utf-8?B?amNxVmptZW1yUjlTSll2Ri9ncFFpVzQwR1ZodC9HMDZvelBkU3QrRFFYbWhT?=
 =?utf-8?B?ZlhjWmEvQ0k5QzYyc0FrSTdkbXM4MmIrUHpMUzl5Z3paLzN2YTllQWxrcFc4?=
 =?utf-8?B?U09WUjdvRDFBMHhMbkJ2QlNZMXBGdlRBUEV2dXFaSk1GeGprdXBKS2twU2lW?=
 =?utf-8?B?cmZqcllyNVZzNUR1UFpOc1UzT2NsS1lDVWZRaXFyR3VDcCtlRW9pbkI3SmFl?=
 =?utf-8?B?VUhPYmxvb1Q0dWV3RzBuMmVneTNiY0djeE10SDJYb0t3aWxXUEdMZmF2aEE3?=
 =?utf-8?B?SFJWSTRydXpMdzQrbFpIRVlYa0tMNVdQWTdFNGVXNWJkMkltdksvWERsdjlV?=
 =?utf-8?B?ZjkwWjBoSUFQR0xKd2dDaTF0THhZUFQvaGoxblphUXdQMDJ4dHQ1VjhQVGNH?=
 =?utf-8?B?S3RRVGo1SHJLQ3FIREF4Q2ZYM0xyVWpxZmdqUCtIblJSM3hIR0xVVk8xREk5?=
 =?utf-8?B?cGU5Q1JsT2hSamVCV295eWZhZENqd3pGK3MyYnVGelRIYyt0aEo1d3g5S2do?=
 =?utf-8?B?SDJNcUU3ejhJSW5ZVlQ2ZTZlRDJPWU8zdmNBSi9rdVgrNE9mMUYzNG9uTUpX?=
 =?utf-8?B?Y1BibkZiVkpJU0d2dFh0TFh0czRwNmduT3o1NzlLU1VGVE85c21PTFFWOUZJ?=
 =?utf-8?B?MTVHT1BRUU5RMmZJSS85YU91NzRYbm1WeUZFTmM2WWhZZFFrOUIzczBQa3dq?=
 =?utf-8?B?OGJPSGFSZDhUUThKaGNncEZrY0hkNXJ6eVliREx4OEh4ZGRuYWYxbllEZlRD?=
 =?utf-8?B?ZHMyL21yQ2xSSzlJL1NraERvcG9LeXNpZDFLTWtPRklUV3dPSkdKNDZBVk16?=
 =?utf-8?B?OE1nYkY3ZDdoWG5rbGxLSkN6YnZoaTdieEZPSXVhNkNHeG1IcmFydWhsRFRz?=
 =?utf-8?B?SXdTTWUyUlJwRWFnNUYweElXd01YeC9GNkErQlhPdUhKRExVNzZaOEUwTzlt?=
 =?utf-8?B?K3B6MEo4MUx6YU1zLy9uQ2RPakhBWXBwT2pDOE9kNnliMkpJVUt4QnhkTWpz?=
 =?utf-8?B?Tm9XRFV0L3FmVTBUYjF6QTU0dVIxNk1nMzhDWnF2QjZEK2pDTS9OaWZWZ21U?=
 =?utf-8?B?SkpJc205aVdEcDFmc0pycEJNNFE4SjVkcysyTTJILzBRYUFqTVdGSVpmN3FY?=
 =?utf-8?B?MmhET1VNOUxMOEJQTFFnVnZOd2V0cGVqZ1VvQlpScUFTZ0Q1WkdHdXFwWVNN?=
 =?utf-8?B?bkRlMkJ0UXlpZG8yN3puNUZTdFNHWDUvMjNKQVA4TGx5dDlwNTVWb2d1czV1?=
 =?utf-8?B?ZEhGZnRTaVlQMmk1STVTTjM2QlpVZ3l6azRNTjBHUStnK3VtbW1Oa3k4VGRN?=
 =?utf-8?Q?AHgppQNlWhNBOvEunjLgsk/Nd?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a330b0e-618a-4338-bacb-08db04cacfd2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 03:08:51.9031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0lE7txsD9DoOV7HCQI7GM/Qhnj8yFHF4rx7XN5EtUa/TCZGavOjyIUUJx9gmnwk+FWrOeOkqkuc9YzoCI0UrEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6994
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBNYXR0aGV3IFJvc2F0byA8bWpyb3NhdG9AbGludXguaWJtLmNvbT4NCj4gU2VudDog
V2VkbmVzZGF5LCBGZWJydWFyeSAxLCAyMDIzIDEwOjQzIFBNDQo+IA0KPiBPbiAyLzEvMjMgNzo0
MyBBTSwgTGl1LCBZaSBMIHdyb3RlOg0KPiA+PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0Bu
dmlkaWEuY29tPg0KPiA+PiBTZW50OiBXZWRuZXNkYXksIEZlYnJ1YXJ5IDEsIDIwMjMgNDoyNiBB
TQ0KPiA+Pg0KPiA+PiBPbiBUdWUsIEphbiAzMSwgMjAyMyBhdCAwMzowNjozNVBNIC0wNTAwLCBN
YXR0aGV3IFJvc2F0byB3cm90ZToNCj4gPj4+IEBAIC03OTksMTMgKzc5NCwxNCBAQA0KPiA+PiBF
WFBPUlRfU1lNQk9MX0dQTCh2ZmlvX2ZpbGVfZW5mb3JjZWRfY29oZXJlbnQpOw0KPiA+Pj4gIHZv
aWQgdmZpb19maWxlX3NldF9rdm0oc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdCBrdm0gKmt2bSkN
Cj4gPj4+ICB7DQo+ID4+PiAgCXN0cnVjdCB2ZmlvX2dyb3VwICpncm91cCA9IGZpbGUtPnByaXZh
dGVfZGF0YTsNCj4gPj4+ICsJdW5zaWduZWQgbG9uZyBmbGFnczsNCj4gPj4+DQo+ID4+PiAgCWlm
ICghdmZpb19maWxlX2lzX2dyb3VwKGZpbGUpKQ0KPiA+Pj4gIAkJcmV0dXJuOw0KPiA+Pj4NCj4g
Pj4+IC0JbXV0ZXhfbG9jaygmZ3JvdXAtPmdyb3VwX2xvY2spOw0KPiA+Pj4gKwlzcGluX2xvY2tf
aXJxc2F2ZSgmZ3JvdXAtPmt2bV9yZWZfbG9jaywgZmxhZ3MpOw0KPiA+Pj4gIAlncm91cC0+a3Zt
ID0ga3ZtOw0KPiA+Pj4gLQltdXRleF91bmxvY2soJmdyb3VwLT5ncm91cF9sb2NrKTsNCj4gPj4+
ICsJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZ3JvdXAtPmt2bV9yZWZfbG9jaywgZmxhZ3MpOw0K
PiA+Pg0KPiA+PiBXZSBrbm93IHdlIGFyZSBpbiBhIHNsZWVwaW5nIGNvbnRleHQgaGVyZSBzbyB0
aGVzZSBhcmUganVzdA0KPiA+PiAnc3Bpbl9sb2NrKCknLCBzYW1lIHdpdGggdGhlIG90aGVyIG9u
ZQ0KPiA+DQo+ID4gYSBkdW1iIHF1ZXN0aW9uLiBXaHkgc3BpbmxvY2sgaXMgcmVxdWlyZWQgaGVy
ZT8g8J+Yig0KPiA+DQo+IA0KPiBZb3UgbWVhbiBhcyBvcHBvc2VkIHRvIGFub3RoZXIgbXV0ZXg/
ICBJIGRvbid0IHRoaW5rIGl0J3MgcmVxdWlyZWQgcGVyIHNlDQo+ICh3ZSBhcmUgcmVwbGFjaW5n
IGEgbXV0ZXggc28gd2UgY291bGQgaGF2ZSBhZ2FpbiB1c2VkIGFub3RoZXIgbXV0ZXgNCj4gaGVy
ZSksIGJ1dCBhbGwgY3VycmVudCB1c2VycyBvZiB0aGlzIG5ldyBsb2NrIGhvbGQgaXQgb3ZlciBh
IHZlcnkgc2hvcnQgd2luZG93DQo+IChlLmcuIHNldCBhIHBvaW50ZXIgYXMgYWJvdmUsIG9yIHJl
ZmNvdW50KysgYW5kIGNvcHkgdGhlIHBvaW50ZXIgYXMgaW4gdGhlDQo+IGZpcnN0IGRldmljZV9v
cGVuKQ0KDQpJIHNlZS4gSnVzdCBub3Qgc3VyZSBpZiBzcGlubG9jayBpcyByZXF1aXJlZCBmb3Ig
YSBzcGVjaWFsIHJlYXNvbi4NCg0KUmVnYXJkcywNCllpIExpdQ0K
