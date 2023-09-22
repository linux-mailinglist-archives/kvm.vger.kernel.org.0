Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA77C7AAC51
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 10:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbjIVIRB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 04:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbjIVIQt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 04:16:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AE81A3;
        Fri, 22 Sep 2023 01:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695370603; x=1726906603;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EQvJLeXzZr7g3gTBMq6MexQopd1VQr21aioxU5Il9bw=;
  b=RLEJrGlZ3G5IchtvZ2FO4kqVNDDQl6Lq4LG5v9E2KZCXz3yF08AMu6wn
   bwUuhzhTot3UsVLWdyQ1yW9PV9Ghv115SaFD87VZ5+l21da2vhL8TvxsS
   upIWFa8bS/oY161tI3p5VRYeMQVJUBmLf5K61bvjQdJtk2WyLbMRIWLiA
   wDzqqypo5KUMVCzKc/qg/Ivj/5zb7/f771zuUmx1Ex2sm/MCpZFZA9svo
   Tx6g/YKzzE3V7t4Y2rIv7ZHaJQIo1xTCwLxpwvxC7ZtskhEG+pj0TEToz
   vb7dlJB+msrX15LUYS5Lvp6Rnyiffans9zVQhF8hM1WLIxkNRcYKXpGAN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="447253091"
X-IronPort-AV: E=Sophos;i="6.03,167,1694761200"; 
   d="scan'208";a="447253091"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 01:16:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="782555259"
X-IronPort-AV: E=Sophos;i="6.03,167,1694761200"; 
   d="scan'208";a="782555259"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Sep 2023 01:16:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 22 Sep 2023 01:16:36 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 22 Sep 2023 01:16:36 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 22 Sep 2023 01:16:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEXu+PWgHbkIxu1yI9iKS3QnpuVMRZTczQaOPLRZXjrNYUh+vzUGQNuNC7miXGBUXv2W5h9PpZC3dG28TL+JbDlJ5h0DMNAgE8D6ulf008b8omZCOWDsdejCdbWOTWa+uaNcj3cA0yWAi5FDFnQgC2uMDivzQG0Ov7PvFBoyi2H2FhDBaJq4GblcnycbblWRAyRvVLepKcmowg521z7ibmERdwruVN7pGZ36tTv7OW408vdRdC+pSnomlef/B0fPwIhVxPi8zQL7GMxjZW28ZBKS2ymG3perayuKCl8rjQoEAfC8aylFOtR7ltsY4soFfcPFpgkSjFoV9cYasFei2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EQvJLeXzZr7g3gTBMq6MexQopd1VQr21aioxU5Il9bw=;
 b=RYBHEdROst8Adp2LMw3YrvkQyqIpsHul5Ws2AGCA52ndeofNQIuleYktVm8oBgme2IkGFHLnmTqpOBt+qLVoImgd++wwxHanKYEcYuskPZcnFbq2lJzJWZ2Mp7CK+8B1LfsTyplcRR9EOdNqHMdy1QndZjtLpljB385lwSS/UVH9B50ARTliHZM7g71TVvrqtlkjgM0mEm5Qs1z5sgEdIR/rR5aL8jWcmPOy2wTRnvi11SU3Zi/Y1TjgJHhQuOCQrnhyGg+7msRmpWCe6iJe1YqoE7usyL+wptztJ7SqEL8lvYd8Pp1MLRh+JKLfDSpR4HOHxjxjzXbccLOco1OjkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CY8PR11MB7289.namprd11.prod.outlook.com (2603:10b6:930:99::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21; Fri, 22 Sep
 2023 08:16:34 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61%6]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 08:16:34 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Li, Xin3" <xin3.li@intel.com>,
        Nikolay Borisov <nik.borisov@suse.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>
Subject: RE: [PATCH v10 03/38] x86/msr: Add the WRMSRNS instruction support
Thread-Topic: [PATCH v10 03/38] x86/msr: Add the WRMSRNS instruction support
Thread-Index: AQHZ5ssSXb894LHEBkqZUWtDh9samLAjYtKAgAADDuCAAyUhEA==
Date:   Fri, 22 Sep 2023 08:16:33 +0000
Message-ID: <SA1PR11MB6734445986E951E686172419A8FFA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-4-xin3.li@intel.com>
 <dda01248-f456-d8d7-5021-ef6b2e7ade2c@suse.com>
 <SA1PR11MB6734F205C2171425415E4F00A8F9A@SA1PR11MB6734.namprd11.prod.outlook.com>
In-Reply-To: <SA1PR11MB6734F205C2171425415E4F00A8F9A@SA1PR11MB6734.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CY8PR11MB7289:EE_
x-ms-office365-filtering-correlation-id: 01d258a4-f9d0-4f4f-e6c9-08dbbb443bd7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sVsAIWzSOIGRKL42t9nQfGYanbD7ys5YrvTcg52dRxB5cJFOhDMrFMM5ixf7JVbnhbhojAsAu7xnb4hCJhRhQPmFOwpGksOANfOmPPT2V08CtqDRPttFH6HYXXnSnHJ2r+yI0YCslzALYnkmCdkc39f49C+L0vpNcIPOOz02t3M7mJalvg8Tz709DPGIeU+hJGY8j2/v0dspN95OCIxf0JgItQi0kV+nBaNBM07vttpNdkzrdklAaGVWUzu7mSBUUzyeTpXSm+6knLSLAY9POOMaPsFqE46kH26l+UOfUosYsGFoXpB+P762JNnSHWYzhBAupATDCX30LedR/dBdYW90LtGWCnThm1BPk9wQnMN2TsltgLM7vhfcWnVJ9jZbMJQ+M2qAiTESW/U3C2GAd3lTW/asNgsRurtVl4uuXt4Il9h+TKrdNAk2w7oI+6BNW8qsNZ2FgP0ZCHSI66TWhmYFGyhq5iOrtj3CoGYvV3dE6TbI1k3U7jv5yZEMqLhfFht9WBHykjtC60T3BCXkDtNSoXM1EVXTKSspCNGqn/awwMKPMTu3RBSKeZSAYXK0ee/VitksaKphuFlhZahTjqNWDPIZt/6MKWURgT8Q+RAo+j2idGgFhLoxyTNSDIcFEzVLY01j5TAjoui7WMGHYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(376002)(366004)(346002)(186009)(1800799009)(451199024)(83380400001)(5660300002)(71200400001)(7696005)(478600001)(6506007)(82960400001)(55016003)(33656002)(38100700002)(8676002)(122000001)(86362001)(38070700005)(26005)(110136005)(2906002)(66556008)(9686003)(4744005)(52536014)(7416002)(8936002)(64756008)(4326008)(66476007)(66946007)(76116006)(41300700001)(316002)(66446008)(54906003)(133343001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGt5TmRlRTZzaTgwOUhTVVZacDZqQms3UjF5NHV3R3J3TXpQTmlWMTU3MzA0?=
 =?utf-8?B?U1ZGdEczQlBua0xZdTV1c3dmOVlQWGE3dWI1T0pIdXVJR3p3cmROMUU4RUVG?=
 =?utf-8?B?NW9STXM2STdMVnZYcnNFUlpJV2JnUFQwN1JjQmxKVDA0ODRlT3d5UURObXFP?=
 =?utf-8?B?d25JRHNoN0RPQS9xYXhZczk1cTU3VlN1eXVuTDYwbXhjZ2ZIUjdkUkJ1ZEJo?=
 =?utf-8?B?azlKUzc5azVDb25UMVFoVjFJSW9FN1lmV01JWi9tU2czaGhmRHcyTTBMWVdu?=
 =?utf-8?B?QnA1NDFXcDhUZVhrWXdPRklDcXRvQlBwNmZ1OVFkSjh0eXFDM211YUkzUldT?=
 =?utf-8?B?bkdQTFB0QWV2ZHFTQTg3Y2VPNkgxZ0szZ2VvbWtLRDhQM1dOd3NPeTRQeStt?=
 =?utf-8?B?K3ppa0U2WTdJSXFBaUZ0cU1FeCtRcUQzb3NGcGxiaXU2T0FseUdFNktXNVpS?=
 =?utf-8?B?S05LQzdxczdIQ25pZlRYMVVEY0V6bjd4bnVHMFY4c2dyRE5JdE9Ha3FIeStY?=
 =?utf-8?B?UE5XUllFeWI3WXBrVFFmOHZIN2NHYnFsY2NHRkluRSs3RVlPa1BwMFUzakp5?=
 =?utf-8?B?TGZ2YVU0SXlYaFpaNVdaVmF2STlwSEUwZWdhaFZlRWZoNEVJMkM3QkREYUZV?=
 =?utf-8?B?ZDB3dVRrWUU2L2pmYlQxNE55NlNFK2JSc1NEaUNnUUtjMHZNT3p4aVlDOUJz?=
 =?utf-8?B?ZXEyMFpjbzk2VGJjdjUyUjg3cTRyRmdDd0J0VC9hdjFqVDdPWFpHN0d4bUJu?=
 =?utf-8?B?S3k0MFRhUEJnU0J2WWtvekVjZnV2RzBIaXdZRXI5Qkhpdi8xaGNCUW1rZjhl?=
 =?utf-8?B?UjRoNTJNamJwZm9aakF2UUFHd2dGN0VnRHlJOEdKeGQ3V3hxVHU0ci9ibThR?=
 =?utf-8?B?dENsQVJXY0ZYTVBhYWpISE5yeHpHcFE3NXVHb3RFNlVPSVZveDdWNk9nc1lT?=
 =?utf-8?B?RWRIRWJhQkM1d1oySXUwUDVkMjRYV2M4a1NrNDFpOHJsQ0p3RkpwWmZyOTlT?=
 =?utf-8?B?RFNlUVM1SWNFZ0l6SjBNcDh3eVYyZXU2dFFLZ05kaGxTN3IyVExEUS9XZTFa?=
 =?utf-8?B?RGUrVGswTDVHNkRxTm1GK2NmRCt1TXZrVVNrNVZaeDNxa0xSR1IyQ1liNVQ2?=
 =?utf-8?B?MEVzUGN2MGVCUTA1M1VOTUZoMWIwRGMvOVl6eTY3cTM3VlJKaVZyNmdvYmE0?=
 =?utf-8?B?RTc0NkpUSVVRd2duUnB0d25xcS9md0NrTXlYNThFWFgxMk53MmJGLzNWZVRw?=
 =?utf-8?B?a05WeHZoVGNFUTFrQmxZeTFHczVubXhocStNUlBEbmlNRXNRTDE0eUJDU3Ez?=
 =?utf-8?B?RWx3UlM5T2YrUndYb0JaUWsxUFRUbld5ZkZQZE41NmxSMWdhamtibUlVU1g5?=
 =?utf-8?B?SW9PSkhZdmxVeTUxNkpZVkZ0UzZYRTMzMVNVRHdhdTcwTnhxblF1NElMWmJH?=
 =?utf-8?B?VDkxZGNpL0IyQ25IOXFnaG14cmhxZEE4V1ZBUktBaTNQSzJsNW5ld0h5b0tD?=
 =?utf-8?B?ZWE1cmJ0R1hBSmdOWVJVc2dNUVBLc1Avbms1U1ZCdEZzSDR3a0RtTEI4ZlpL?=
 =?utf-8?B?UTVFTXJ5U2hJSm5tY01WcktuMEhpU3R0Q0Fwc1NRdEFHRjFrVVJpWUVlV0JM?=
 =?utf-8?B?dWxoNGpsZ1QxR2ROekRPN0w3UXlIc2Z6V2tRT2E3c0xjaDhBQU9Ldm5Qd09z?=
 =?utf-8?B?aHpYdjdLREhnb1RsYVd4UTRXeUcxSlo3TmdDVWZpd0dyRWhDODFlWGhuQUpX?=
 =?utf-8?B?VkUzZVI2UWRQV1hxWGJaUFVPVjk5bHVGRlFWYkxibE9POWJSZnMrU0JQUFpr?=
 =?utf-8?B?ZW5XUVFUajgvL0NoWTZ4Z052T1JkblVuN2U4U05YL05HdW1zeEVPSFlkQ1RK?=
 =?utf-8?B?S2xqV2ZJdjUrNCtaZjNUNXJwZ1NjZWQ0YnRzbGZJUmxMZ2V1M0lRZ2NRS1V1?=
 =?utf-8?B?d3RZNnFvcTBqUUFYYitrOGl0Qk5kaTVhV01RV3hxd05zM2hWbjNrYUJEUlZh?=
 =?utf-8?B?REhLRy9UMjhXV3gzZ3BXc295amU2d2FlcWFBZFBGNkJvdWpMMDUwV1c2cFA0?=
 =?utf-8?B?T1N2ZjRtRnBTS0RXUkNWWk1EakE2SGQ3dXZNc0xPcEFlbFViN0RyN21CcXd4?=
 =?utf-8?Q?Yn0k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01d258a4-f9d0-4f4f-e6c9-08dbbb443bd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2023 08:16:33.9069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DBejkWqeoxtJew6Y/pQWKRqTA/q/KF220mlU6GJdn5DpgR3sjTSx5+nsXtNty24vF5haxAEoz7QafA0XiTufkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7289
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+ID4gK3N0YXRpYyBfX2Fsd2F5c19pbmxpbmUgdm9pZCBfX3dybXNybnModTMyIG1zciwgdTMy
IGxvdywgdTMyIGhpZ2gpDQo+ID4NCj4gPiBTaG91bGRuJ3QgdGhpcyBiZSBuYW1lZCB3cm1zcm5z
X3NhZmUgc2luY2UgaXQgaGFzIGV4Y2VwdGlvbiBoYW5kbGluZywgc2ltaWxhcg0KPiB0bw0KPiA+
IHRoZSBjdXJyZW50IHdybXNybF9zYWZlLg0KPiA+DQo+IA0KPiBCb3RoIHNhZmUgYW5kIHVuc2Fm
ZSB2ZXJzaW9ucyBoYXZlIGV4Y2VwdGlvbiBoYW5kbGluZywgd2hpbGUgdGhlIHNhZmUNCj4gdmVy
c2lvbiByZXR1cm5zIGFuIGludGVnZXIgdG8gaXRzIGNhbGxlciB0byBpbmRpY2F0ZSBhbiBleGNl
cHRpb24gZGlkDQo+IGhhcHBlbiBvciBub3QuDQoNCkkgbm90aWNlIHRoZXJlIGFyZSBzZXZlcmFs
IGNhbGwgc2l0ZXMgdXNpbmcgdGhlIHNhZmUgdmVyc2lvbiB3L28NCmNoZWNraW5nIHRoZSByZXR1
cm4gdmFsdWUsIHNob3VsZCB0aGUgdW5zYWZlIHZlcnNpb24gYmUgYSBiZXR0ZXINCmNob2ljZSBp
biBzdWNoIGNhc2VzPw0K
