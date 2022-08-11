Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96A35908C2
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 00:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236327AbiHKWlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 18:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiHKWlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 18:41:01 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899E69C207;
        Thu, 11 Aug 2022 15:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660257660; x=1691793660;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xgGMD5YfB6U7s9ircanrdkOEg6xE9qMqsOSG84GF0Zg=;
  b=b0pjOXCeMtpSayihYY+3HELR3xue4uBlXhqLeuXXNGD1RVeQoLcAR48B
   UB3LXNHEkHpOD9d64T/T3EebLYicNFlvCJTsT8NkcFPhEVLtPdKzPSROS
   Sk/3qjPRlxXdZ0fRpwZ/bqHtKS1rHbVNlLoxow2xviTzTcEv6Em5TvhyX
   ysgl0RjzQ4/CqzHgoMdN/h2ddgQ/y116j5demEj6K0+m81mMOsCb82fXl
   4xZbO3q2sohaHob++iEcurup8gH6A3Hlm+RxIdkCON81yhoxNXwey/SnZ
   a8kTBrIDFGd0gqnukVjjKUyMtFwKWVI3QAk7Bm/YtM5DLMoGxf/aPt9WI
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="292270911"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="292270911"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 15:41:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="638695456"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 11 Aug 2022 15:40:59 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 15:40:55 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 11 Aug 2022 15:40:55 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 11 Aug 2022 15:40:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=COyqlvw/1gz5ZtuKxgCwZZf24ZPlbVm7y/+gG0/DI0GZ8kgsSu+CppP7h3B2xClSaDo0jVP8/zvyOIaZ3tH/j83bhUg32ID1/qagE+YL0m5LCjvEKD9vK09uGzYVI8lqfp2P48b4xDMCSyWVixZy1r0WQtcIUKDzDVOziwnaUYL0w4VZdm+OCQOqYypp6EEYkF8ra0hHJX0Kr0YX174+xe2xxl6skyiwbR0l4DJglnQJhs4HNEAG6gSyzBOBHvuYJB4rsrAYp4c43YjNYSLxn02nT85XJUHMVJGRGmrgG1KprruQu4j0NhDLGCkWimHvcKEVSTm39dvlyvj7ANeNiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xgGMD5YfB6U7s9ircanrdkOEg6xE9qMqsOSG84GF0Zg=;
 b=bjuF0eXAeoaAE6CkgLadcTJJbh5L+gOqwOR1V3oUYr3orJDDNYGcXCWyj0Hy2iGinci6rr7WhbGMuneK1TLosaQ7TV1JUlZBgkgVGVaiasLudDC80GV/1lxaOhc/4dhr8++wavJ7GIzFZ43td57Zd+uGVXhqVVkreVhtQjBL64WSvkOWC0ADUVnDHDEu+8SG9qu2raNnFZpO17hRWyBnwmIFJG7omqlx4fS2byWi7b6AJgU6Vdcr8fHBZO0Mj9k1UU04KdXcP8JM577x8wab5RB9GqkLJbqFyJfeYFxedNIHq0qcDgRMtsB1Zqg6Sq3hBALeH6lV8+ToTSMr0TcLPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by DM5PR11MB2058.namprd11.prod.outlook.com (2603:10b6:3:12::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 11 Aug
 2022 22:40:48 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::1c1b:6692:5ac6:9390]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::1c1b:6692:5ac6:9390%6]) with mapi id 15.20.5504.025; Thu, 11 Aug 2022
 22:40:48 +0000
From:   "Liu, Rong L" <rong.l.liu@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dmytro Maluka <dmy@semihalf.com>,
        Marc Zyngier <maz@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>
CC:     "Dong, Eddie" <eddie.dong@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Borislav Petkov" <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        "Grzegorz Jaszczyk" <jaz@semihalf.com>,
        "upstream@semihalf.com" <upstream@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
Subject: RE: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
Thread-Topic: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
Thread-Index: AQHYqQNH7JI28I5GTUeFXNDOzILO6q2lqp6AgACFeQCAANN3gIAAOnCAgAB7MQCAABabAIAAUN+AgABDQoCAAOa/gIABAnug
Date:   Thu, 11 Aug 2022 22:40:47 +0000
Message-ID: <MW3PR11MB4554AAFB43FA6B0B612150D9C7649@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20220805193919.1470653-1-dmy@semihalf.com>
 <BL0PR11MB30429034B6D59253AF22BCE08A639@BL0PR11MB3042.namprd11.prod.outlook.com>
 <c5d8f537-5695-42f0-88a9-de80e21f5f4c@semihalf.com>
 <BL0PR11MB304213273FA9FAC4EBC70FF88A629@BL0PR11MB3042.namprd11.prod.outlook.com>
 <ef9ffbde-445e-f00f-23c1-27e23b6cca4f@semihalf.com>
 <87o7wsbngz.wl-maz@kernel.org>
 <8ff76b5e-ae28-70c8-2ec5-01662874fb15@redhat.com>
 <87r11ouu9y.wl-maz@kernel.org>
 <72e40c17-e5cd-1ffd-9a38-00b47e1cbd8e@semihalf.com>
 <d8704ffa-8d9e-2261-1bcf-1b402f955fad@redhat.com>
In-Reply-To: <d8704ffa-8d9e-2261-1bcf-1b402f955fad@redhat.com>
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
x-ms-office365-filtering-correlation-id: 3ec80ca8-8723-43b5-47f2-08da7bea8929
x-ms-traffictypediagnostic: DM5PR11MB2058:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AbRbCYgYG1OjP5coXn9KD3uCT+qG4Mzj/QLi1jzgeM6tJYpHFZexShOKn/tKyqjueAr6OqILAT8iQircLUS1Tfgaro5Ugmm7TpJyBshe2L6hXlITsI4GjwI0EIe2jHnBY4Hc1EEWRb1dyCNu833idw8MiWm+GKvwUr61EWpMhyoVP/gbaGvn+Hv971tZsJtQG7R0svW9r4E4HjNLwew731G/XKGF/5e9n/kQ5uG8TSQujoAxVHEX2PLJLaC3Gh4Ljwr1OS/9XnbVLC3SEHGHgLttDdFHL8vEdNSuyRaeup+Fqt+gQVerhA2X54VqvCKQzUpuRwQA1F/VCwgjtA90gmMbJBMX5nE7GPAKqGsvmWJJhbCVWgoOqT1O8Q4fInMzexoXPtfEl+If5j9cyfC/PLePNmTJ1/Tfd1gVe7e9PP0jb2EUdXUMCs4/6yE3hOtu/u9336+Mn4eF+lC/UKDb2dpdFjPfhnYouNHfEABg/f7RiWyMLRsqvcrPId9Sa153aMSuvPJS5Vl7xgIQDHXt5avhY6RzCuWRiBfzsHdEU3Xvt+KGLAEHNFJNoAJZAl5EyLlC0sqKluVg6QB5GVXThIt0iqb/ijwUCi9LXP4DnoBxzuDxUlS9J/oLEFR6Y3Vr0k9xMUjvj+AN3TiQqxyOAcpxlCpmeIc2JbLzLLqPkrPCRsHHO0aR8wZFP5gJQ5p5sWEhHXXM3aN0tqMy/zgDwrsGn3P/SIraywQLomDRBKmT11X3BaWPpNV8iuhIWYFJJwX1cZ7HPwtGhRKS/NudGr0H5yS2FDqmyn8h4dF59yDH0zYUgiAB+OwakRfKu/2C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(376002)(366004)(346002)(39860400002)(33656002)(26005)(38100700002)(122000001)(82960400001)(9686003)(53546011)(83380400001)(6506007)(38070700005)(186003)(86362001)(7696005)(7416002)(110136005)(54906003)(316002)(71200400001)(478600001)(41300700001)(8676002)(66946007)(66556008)(5660300002)(66446008)(66476007)(64756008)(76116006)(4326008)(8936002)(52536014)(2906002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NnprT0VEb3k2UG9rUHRkY1pDTGd5SENKVlk5Q3VpUWYrU1dxckNJbUYyY2tm?=
 =?utf-8?B?VXlxa1d4SjVJNU0zcDBEdDJScG5OVHY2c2pacDlkbm81aGZGRklhdjd5Wmg1?=
 =?utf-8?B?cEFLbllpZTFxWGpRTXFpTHliTzNKVWdVQXU5QSs4WlBmWEY0UWNtVlVTNmxK?=
 =?utf-8?B?TFhyUGZSYkJjRi9BQ2QxVGhGOXR3Rjhtdm1nc3I2SUFqbGkwRSsxQlRsVm5q?=
 =?utf-8?B?M0ErTjlRVUJtZzBQbjVlNHk0RWxURVpwWkRnNnVHZmRZakJyK1RtdGd4STln?=
 =?utf-8?B?WGxqaytEc29rNy83Rk1nSW9qN01jMHlTSDRmMnFkQ1ZvSzBob0hSSWFzZzVE?=
 =?utf-8?B?MUI1eTBsblZZYStZRU5rRnhaakRyRTBuQXlQcGxkK2FSZmw5bWRKTWNLRmNz?=
 =?utf-8?B?ZkNIS0l5YWwrbTVKeW0zUmNwTW9lUWUydFpMQTU0Z1g2bjFaR1dZdWF1bGpu?=
 =?utf-8?B?ZU9QNE5PWkpidUxXdlJ3MDV0RGduZUFiZENsRDJMNkF2eXIybEJ4UXVJSDly?=
 =?utf-8?B?eTlMcjZXc2luK0ZCUFYvOWUya2RWUnIwSWM5Um1rbVpDeGhuUFd4Rm10eFdT?=
 =?utf-8?B?L2k1dmU3WElrMmw1VXJWQStaUzJxU0ZEcWZiZHF6OTFCYjdBSXhWKzZCTDNs?=
 =?utf-8?B?cVpkeTVlcW1zV0ExcWhCUWNraHN4akdTVWZ0aGpuckNNd2E1V1dEVlQ0NXpr?=
 =?utf-8?B?bUw2am12RTFycmdSRDRqdEVpR280ZXM1ZTdwYkdTMTl1VnFKb0ZEZjFDSm1w?=
 =?utf-8?B?enNHZzR1ejdidGsxbmc1UnBWTzM3V2g4NzVWQk9ROUdyaFNmV3dTVmw0VW9Q?=
 =?utf-8?B?WW1wcjZCb3dvblRyb053cElub0xkbjIrTG5wMXV3VzYwTmE5akU2bVBxZEpD?=
 =?utf-8?B?OUZjM0F2amphWElRNll3Q2JtNjF6WXpFMFVtWGdoUDNmMXhaL2VOZHVBRG5F?=
 =?utf-8?B?WTUrWUtoaXIvTWVaSWs1NjExcWJwa3RaTVBKaUhGUE11eVNjeTE3dEViTlVu?=
 =?utf-8?B?ZFlEMHRRY2FVUTJETUVOeDZXRE9ob3V4aHZaWUVVNmpneTFVVk9zazNvOEl5?=
 =?utf-8?B?WUZUbkZsZlFDcnJkNEMxamF4TFF6NWNuTEVYN3IrY2kwVDBYNTEzUWRWa0M3?=
 =?utf-8?B?UU1ZNjYxZkJibzVITXRFRkg3OUg2cDZVY3c2UEJCUDVGM0xRaCtodnFwVk5L?=
 =?utf-8?B?S0gya013bWRtMDRXcG5yRjBHYS9HOXJZemN2OEwzNEJqQXU1VFFIUHpPVEZI?=
 =?utf-8?B?dDlsU3BCVHBhbDZCdzZSOHpsaENERlhEeWNneGFkblRZYnIyTnRBWXltVEU5?=
 =?utf-8?B?a0h3bXFBNzZuUjRpM0pqU0hTUkRoNC9DbTRlZGoveHdjaXp6VFdtcHdiYXNv?=
 =?utf-8?B?czRrMmF3bm1LY3VaSTIvN3dEWmRRaGFnUnc3S1o1V2M1V0FvTjNuWGhnTVc5?=
 =?utf-8?B?bEVHZzBkbWtlVWs0ektTTFAwczcvYWNWRHZSVWhwcHpnSzNUOHM1TzVpSXFP?=
 =?utf-8?B?djBjRC9Ud1dtYnBuZm5mUCt2U1YrNFh6cnArK0xSWmxFL2xlYVEzbk96K1Rl?=
 =?utf-8?B?L0dlckNPd2R2YW9LS1UvNGFSYy9GV3VVNmlzU2R5dkZxZG9TME44cXQzQUhZ?=
 =?utf-8?B?VElGenUzMGF2OHdzem5sRUVGL3psYmthSWwyYVpSYTJHemQwNmdwUUI0NkRJ?=
 =?utf-8?B?WGJNeVVNRzQ1V0NIQUY5TEc4V0JDZUk2bFp6S24vTXM4MTQvYWU3OGJhanJF?=
 =?utf-8?B?ZitCMEhrS1ZtRW9sZDVuMW9NMStTRVFPNkY1cjBrMlIrSUhDK0lPUzY1TWRE?=
 =?utf-8?B?VXMzRWZuWitNRzBNVWtHVm9RZVpqeWZuNUpoVXEwcXN3dVJieFhWbWkraE9D?=
 =?utf-8?B?LzRveEp0U21uMjRqdTU1bjJBMzk3N0NxM2Z0QSt4U2lxMmNmcHdrc2pRek5u?=
 =?utf-8?B?Y2EzTEY4S2FqZm5iNHd2eFZ3SXE0bktNTUc3R0J1bGtNazZBa0Z4Q0FUWWNj?=
 =?utf-8?B?UHdoM2ZuNnRkVE4xdUhrTnNjckcwQzJ2b2lXNlF4cGF3V254TGJiVGl1eHU0?=
 =?utf-8?B?aXZEazhnMTdwV0Z3dnZ1N0JCWDJvNWZMeTVKQnVRRUxLcndTR2I0T1UwcnMx?=
 =?utf-8?Q?SfjGtdVJSW6kS55xx8EHVqcgV?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ec80ca8-8723-43b5-47f2-08da7bea8929
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2022 22:40:47.9781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lvM/U6TOGaCgjchDT8/VkyT6F5XMMEzgp0g3sDfZ0HKExMyUlth0X0ehXEqMM+Xg5b4tpxtoMeILKtetuTwjqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB2058
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

SGkgUGFvbG8gYW5kIERteXRybywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBG
cm9tOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIEF1Z3VzdCAxMCwgMjAyMiAxMTo0OCBQTQ0KPiBUbzogRG15dHJvIE1hbHVrYSA8ZG15QHNl
bWloYWxmLmNvbT47IE1hcmMgWnluZ2llcg0KPiA8bWF6QGtlcm5lbC5vcmc+OyBlcmljLmF1Z2Vy
QHJlZGhhdC5jb20NCj4gQ2M6IERvbmcsIEVkZGllIDxlZGRpZS5kb25nQGludGVsLmNvbT47IENo
cmlzdG9waGVyc29uLCwgU2Vhbg0KPiA8c2VhbmpjQGdvb2dsZS5jb20+OyBrdm1Admdlci5rZXJu
ZWwub3JnOyBUaG9tYXMgR2xlaXhuZXINCj4gPHRnbHhAbGludXRyb25peC5kZT47IEluZ28gTW9s
bmFyIDxtaW5nb0ByZWRoYXQuY29tPjsgQm9yaXNsYXYNCj4gUGV0a292IDxicEBhbGllbjguZGU+
OyBEYXZlIEhhbnNlbiA8ZGF2ZS5oYW5zZW5AbGludXguaW50ZWwuY29tPjsNCj4geDg2QGtlcm5l
bC5vcmc7IEguIFBldGVyIEFudmluIDxocGFAenl0b3IuY29tPjsgbGludXgtDQo+IGtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc7IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5j
b20+Ow0KPiBMaXUsIFJvbmcgTCA8cm9uZy5sLmxpdUBpbnRlbC5jb20+OyBaaGVueXUgV2FuZw0K
PiA8emhlbnl1d0BsaW51eC5pbnRlbC5jb20+OyBUb21hc3ogTm93aWNraSA8dG5Ac2VtaWhhbGYu
Y29tPjsNCj4gR3J6ZWdvcnogSmFzemN6eWsgPGphekBzZW1paGFsZi5jb20+OyB1cHN0cmVhbUBz
ZW1paGFsZi5jb207DQo+IERtaXRyeSBUb3Jva2hvdiA8ZHRvckBnb29nbGUuY29tPg0KPiBTdWJq
ZWN0OiBSZTogW1BBVENIIHYyIDAvNV0gS1ZNOiBGaXggb25lc2hvdCBpbnRlcnJ1cHRzIGZvcndh
cmRpbmcNCj4gDQo+IE9uIDgvMTAvMjIgMTk6MDIsIERteXRybyBNYWx1a2Egd3JvdGU6DQo+ID4g
ICAgICAxLiBJZiB2RU9JIGhhcHBlbnMgZm9yIGEgbWFza2VkIHZJUlEsIG5vdGlmeSByZXNhbXBs
ZWZkIGFzIHVzdWFsLA0KPiA+ICAgICAgICAgYnV0IGFsc28gcmVtZW1iZXIgdGhpcyB2SVJRIGFz
LCBsZXQncyBjYWxsIGl0LCAicGVuZGluZyBvbmVzaG90Ii4NCj4gPg0KDQpUaGlzIGlzIHRoZSBw
YXJ0IGFsd2F5cyBjb25mdXNlcyBtZS4gICBJbiB4ODYgY2FzZSwgZm9yIGxldmVsIHRyaWdnZXJl
ZA0KaW50ZXJydXB0LCBldmVuIGlmIGl0IGlzIG5vdCBvbmVzaG90LCB0aGVyZSBpcyBzdGlsbCAi
dW5tYXNrIiBhbmQgdGhlIHVubWFzaw0KaGFwcGVucyBpbiB0aGUgc2FtZSBzZXF1ZW5jZSBhcyBp
biBvbmVzaG90IGludGVycnVwdCwganVzdCB0aW1pbmcgaXMgZGlmZmVyZW50LiANCiBTbyBhcmUg
eW91IGdvaW5nIHRvIGRpZmZlcmVudGlhdGUgb25lc2hvdCBmcm9tICJub3JtYWwiIGxldmVsIHRy
aWdnZXJlZA0KaW50ZXJydXB0IG9yIG5vdD8gICBBbmQgdGhlcmUgaXMgYW55IHNpdHVhdGlvbiB0
aGF0IHZFT0kgaGFwcGVucyBmb3IgYW4gdW5tYXNrZWQNCnZJUlE/DQoNCiA+ID4gICAgICAyLiBB
IG5ldyBwaHlzaWNhbCBJUlEgaXMgaW1tZWRpYXRlbHkgZ2VuZXJhdGVkLCBzbyB0aGUgdklSUSBp
cw0KPiA+ICAgICAgICAgcHJvcGVybHkgc2V0IGFzIHBlbmRpbmcuDQo+ID4NCg0KSSBhbSBub3Qg
c3VyZSB0aGlzIGlzIGFsd2F5cyB0aGUgY2FzZS4gIEZvciBleGFtcGxlLCBhIGRldmljZSBtYXkg
bm90IHJhaXNlIGENCm5ldyBpbnRlcnJ1cHQgdW50aWwgaXQgaXMgbm90aWZpZWQgdGhhdCAiZG9u
ZSByZWFkaW5nIiAtIGJ5IGRldmljZSBkcml2ZXINCndyaXRpbmcgdG8gYSByZWdpc3RlciBvciBz
b21ldGhpbmcgd2hlbiBkZXZpY2UgZHJpdmVyIGZpbmlzaGVzIHJlYWRpbmcgZGF0YS4gIFNvDQpo
b3cgZG8geW91IGhhbmRsZSB0aGlzIHNpdHVhdGlvbj8NCg0KPiA+ICAgICAgMy4gQWZ0ZXIgdGhl
IHZJUlEgaXMgdW5tYXNrZWQgYnkgdGhlIGd1ZXN0LCBjaGVjayBhbmQgZmluZCBvdXQgdGhhdA0K
PiA+ICAgICAgICAgaXQgaXMgbm90IGp1c3QgcGVuZGluZyBidXQgYWxzbyAicGVuZGluZyBvbmVz
aG90Iiwgc28gZG9uJ3QNCj4gPiAgICAgICAgIGRlbGl2ZXIgaXQgdG8gYSB2Q1BVLiBJbnN0ZWFk
LCBpbW1lZGlhdGVseSBub3RpZnkgcmVzYW1wbGVmZCBvbmNlDQo+ID4gICAgICAgICBhZ2Fpbi4N
Cj4gPg0KDQpEb2VzIHRoaXMgbWVhbiB0aGUgY2hhbmdlIG9mIHZmaW8gY29kZSBhbHNvPyAgVGhh
dCBzZWVtcyB0aGUgY2FzZTogdmZpbyBzZWVtcw0Ka2VlcGluZyBpdHMgb3duIGludGVybmFsICJz
dGF0ZSIgd2hldGhlciB0aGUgaXJxIGlzIGVuYWJsZWQgb3Igbm90Lg0KDQpUaGFua3MsDQoNClJv
bmcNCj4gPiBJbiBvdGhlciB3b3JkcywgZG9uJ3QgYXZvaWQgZXh0cmEgcGh5c2ljYWwgaW50ZXJy
dXB0cyBpbiB0aGUgaG9zdA0KPiA+IChyYXRoZXIsIHVzZSB0aG9zZSBleHRyYSBpbnRlcnJ1cHRz
IGZvciBwcm9wZXJseSB1cGRhdGluZyB0aGUgcGVuZGluZw0KPiA+IHN0YXRlIG9mIHRoZSB2SVJR
KSBidXQgYXZvaWQgcHJvcGFnYXRpbmcgdGhvc2UgZXh0cmEgaW50ZXJydXB0cyB0byB0aGUNCj4g
PiBndWVzdC4NCj4gPg0KPiA+IERvZXMgdGhpcyBzb3VuZCByZWFzb25hYmxlIHRvIHlvdT8NCj4g
DQo+IFllYWgsIHRoaXMgbWFrZXMgc2Vuc2UgYW5kIGl0IGxldHMgdGhlIHJlc2FtcGxlZmQgc2V0
IHRoZSAicGVuZGluZyINCj4gc3RhdHVzIGluIHRoZSB2R0lDLiAgSXQgc3RpbGwgaGFzIHRoZSBp
c3N1ZSB0aGF0IHRoZSBpbnRlcnJ1cHQgY2FuDQo+IHJlbWFpbiBwZW5kaW5nIGluIHRoZSBndWVz
dCBmb3IgbG9uZ2VyIHRoYW4gaXQncyBwZW5kaW5nIG9uIHRoZSBob3N0LA0KPiBidXQgdGhhdCBj
YW4ndCBiZSBmaXhlZD8NCj4gDQo+IFBhb2xvDQoNCg==
