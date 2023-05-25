Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC946711749
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 21:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242793AbjEYTWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 15:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243677AbjEYTV5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 15:21:57 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0C51AC;
        Thu, 25 May 2023 12:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685042297; x=1716578297;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=g5JJbQpzk9KTIUfEMKg72HvNldEktM/APqNazebbZT0=;
  b=f7ozccymKm7n0mN0l6rtvuhGApAqXVoB/KRazwtbugm81mnXrHldiuDL
   7IkLjIQxn2z7ojLq5+n62JylOJrDavS+mgGsQYmkXbTJSV3i19R1yy4jD
   4ZWdZPuY3ayCgugcqT3uW0UV98BPr7y3LAofmtVOoBH8d+noLjYpT5j8T
   PDyKVnZWZMcco5f52gX176+TuEN1HBLyVzfkqIwDeyWS0Av6D68eRPnZ/
   lt9bBcElV4o83hBuU+e1dhtePnNTeXMLGi/1mwkvOvZVKsXc/6LrK+kDx
   XpNXQJnORvcG3VJJzu2OpnbCLIID+5WKdGUSjnggN0UJCe4QXOuaHR7Xa
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="356377138"
X-IronPort-AV: E=Sophos;i="6.00,192,1681196400"; 
   d="scan'208";a="356377138"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 12:16:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="794776668"
X-IronPort-AV: E=Sophos;i="6.00,192,1681196400"; 
   d="scan'208";a="794776668"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 25 May 2023 12:16:47 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 12:16:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 25 May 2023 12:16:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 25 May 2023 12:16:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKU6aNgj0C6xM8XHCUStPmJZ+KZnb6hqWomyDUvkB6Y3x7z5WeFKyxIx75ib7tsbKFOYcbG58nkP8YveicRNwKXwe028iqdXfOdK+U25qnkEbbcUgwRwrh470Zpkl+mzBUbLhzPBJyiWv2nfba277YGvgaIErGUanT38FI0TJWUllYk+QeChMzRjvFLTmSLW18fXWCZnZxFCLW4mQFt1D3+E8mlnlkGF8kTM5x7t1YnK3dZeIP57kigf44gYzOdA4xK1CA556HEkvXKMgJspwvsMmjKB9QIlRpmK+34P6wUM8DzE4t8p73cap3RqUiEKJUFVbpNr7cKxVtLbNRyuwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5JJbQpzk9KTIUfEMKg72HvNldEktM/APqNazebbZT0=;
 b=UoittoKY3opRk4VKtyWXy/jq0C9+o3Grakzg1R4wSXfb2Ukc+9AMzVILcRZX8qTuRZzSN81jFphHbkfbUY5dZdLb9piXp7FVSgQ7ald/Js1hqMnMA4mMC3mQiu1KERLif+9B+Dn1GBzzDjNqLhvwnoMKcKd9dUW8CaefHplHz0WMrVTR6T79ZZTyJqI9A888LCttX8DAWQwcPbgTBv+vcRtvKqG3WcjlRLYBIn4AEpB+xW4F9X/2eahhBFYD/7daO2kZ5jdw72Je/iMOT4ro85Nr2rFepNvHB65C2q7eFNrZiy/GY0yyZNUNxVPHNuonbLEE2flRK4ThXXoQTR+KOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB7911.namprd11.prod.outlook.com (2603:10b6:208:40e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Thu, 25 May
 2023 19:16:44 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec%6]) with mapi id 15.20.6433.016; Thu, 25 May 2023
 19:16:44 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "ssicleru@bitdefender.com" <ssicleru@bitdefender.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mic@digikod.net" <mic@digikod.net>,
        "marian.c.rotariu@gmail.com" <marian.c.rotariu@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "tgopinath@microsoft.com" <tgopinath@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "ztarkhani@microsoft.com" <ztarkhani@microsoft.com>,
        "mdontu@bitdefender.com" <mdontu@bitdefender.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "jamorris@linux.microsoft.com" <jamorris@linux.microsoft.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Andersen, John S" <john.s.andersen@intel.com>,
        "nicu.citu@icloud.com" <nicu.citu@icloud.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "Graf, Alexander" <graf@amazon.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "dev@lists.cloudhypervisor.org" <dev@lists.cloudhypervisor.org>,
        "madvenka@linux.microsoft.com" <madvenka@linux.microsoft.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "yuanyu@google.com" <yuanyu@google.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v1 0/9] Hypervisor-Enforced Kernel Integrity
Thread-Topic: [RFC PATCH v1 0/9] Hypervisor-Enforced Kernel Integrity
Thread-Index: AQHZf2Ve5xw6RDm4tUGLnlOpizAoCa9qHQcAgAEGdICAAB9/gIAABBoAgAA1AQA=
Date:   Thu, 25 May 2023 19:16:43 +0000
Message-ID: <99bea6ec8b3091986008a3a9f2e7c74f0abaea92.camel@intel.com>
References: <20230505152046.6575-1-mic@digikod.net>
         <93726a7b9498ec66db21c5792079996d5fed5453.camel@intel.com>
         <facfd178-3157-80b4-243b-a5c8dabadbfb@digikod.net>
         <7cb6c4c28c077bb9f866c2d795e918610e77d49f.camel@intel.com>
         <ZG+HpFjIuSWvyo+B@google.com>
In-Reply-To: <ZG+HpFjIuSWvyo+B@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB7911:EE_
x-ms-office365-filtering-correlation-id: f220390b-43ad-4962-0944-08db5d5493a7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HN7MBKegHsRwUSnjSRFp+3MlHU73niuACJd8ACjfbzqldL0YwJvRQXrZdYK/5/8yG/76ZAa9ouZGC2tmEHLbPWuvgAmTAJ1aYTujovthpMBqV927urR3Fg/dLGJnlJIyqyp1Y4e4t+5y4YWhooNim8XrlfGxvGvbgUzoElZHs92mCK5LEkDt+rtdYpb2DD/wzpxoFFgq1CjPKpK1rENUlt65ZTTXKXClDFnNxNRZdoWTGGO76aOQfZdX2q+badj/u4edfA5LVAJA/YJlbdcKvoErJsbJ4wS/kZzRv4Mikg8bmFIrLGSgwS2UHjNtxlS350Ltb/z1LR7HGLWow6WQPTS24OpQK4lf6Sq/2SY7laWaoIp/u5QU4icmUSSRsbpHvFr8eAizKfJf/sLeJABjwwerJ60ps/MmZu+uizgIdQjEwTIQ7BcJv7femS1sH0au6J4PWeBV0NLRzQkX1BAjXs0PEERV56PWdE1Xqqhq8DwEu3Upv9QA93EUEnYb2+AH6O4wjpcQUJAehlZcKTvEeHQil2pAFRaFNnYJyU0j0IMsTsZHaUmrOgJh/AAtd4gwzJiRmPWBiiegChnqfU8sHq0nS0y0ekBMOovMD0zpvug=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199021)(86362001)(36756003)(64756008)(966005)(6486002)(41300700001)(38070700005)(71200400001)(316002)(4326008)(6916009)(66446008)(66946007)(76116006)(66556008)(91956017)(66476007)(478600001)(54906003)(7416002)(7406005)(5660300002)(186003)(83380400001)(122000001)(2906002)(38100700002)(82960400001)(26005)(8936002)(2616005)(8676002)(6506007)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eHRCUFlUdU0zVFdVTW44enR2WUdZcDhqdE0wVjNkamRZNDBFSWZMa1J6MHpm?=
 =?utf-8?B?ZW00WExWekJ3RG5xTXA3SnhGWXVrbHNldTJwREIyZm8vakJYUzRMS3dGVWNT?=
 =?utf-8?B?TEpqMmtPYUNEVXhPMEFVa0w1cHJpQXJybDFQeGFucUl1U0lic0RkVjNGcFZy?=
 =?utf-8?B?dklGWmNzS1RTMUVzbFkwcmRBVE15MFVoZ3RmTm14Tk5KRVhLY1dpMm5NaTho?=
 =?utf-8?B?MTVqOHpFOTVhY3V6c1c2cERUVkp3SVNzQkNxcVRNN3VGNWZLNmh6THhHQU1U?=
 =?utf-8?B?cnNuRFdacWJsa0hNZFlqSDVBL0kvMkxWSm9wYU1pMFJmZlhtVkZhL2tDOVUy?=
 =?utf-8?B?R2MyV1AwdXEzd05kVXIxMWRLK1JHZ3ZuMnZBWmVCRk1NdzdlSDVBbmxJSXIr?=
 =?utf-8?B?RTBQcWRvUnpGa3d5QTBZcVA3Z2krZ09WTWZxbGd4NSsySW4zRVZvNCtFdkhO?=
 =?utf-8?B?RGttQXJlT2hNRXYwbUhHRjd4STZYMnJZeWw1bVpJekNGVDEwaUlUTnRRSHFy?=
 =?utf-8?B?d3U4dUhHeXcrUnIwL2VwSlcvdmczQ1Yzais1NXp1Yzh4S2k3WW56UWFhYjRP?=
 =?utf-8?B?ZFhSNmhLNE9xVG9qWFd2OC80SWxhditEZFZLd2orSU5MWHkrTmdUSkp4bDVi?=
 =?utf-8?B?cENiaEh1QkVEalAxT2lBaW5UaWxWWDNnVmpCbExoQmlqUlUxTjlpUFhKMFl2?=
 =?utf-8?B?YVBXTVRWTGNTMmRBSWEzbmNyUXk1YVgzMmhsOGhnK3NmLzl0OVlib2VkZTdZ?=
 =?utf-8?B?c3pTR0ppQVgwODR1RE10RmVqVEJYSURwcDQrbm9DK3ZrMWdmQWVVaC8wdjEy?=
 =?utf-8?B?TkI3akx1a3c4YlBzbFBHY05iUnh2ZDlncThpcG5BZHhtMWdqQVVSOEJ6QjRl?=
 =?utf-8?B?bEVOaTkyQnkzQjM4SkdLSy9yR3AvSFpBSmdwUGV2ZkcxWnQxMmR2Q2UrWWgw?=
 =?utf-8?B?V2dBMTh4bzJ0ZFFaWEhyTUs5VDFPZXVvelZ0eVpKcXhhcUo2My8wUG5wWDc2?=
 =?utf-8?B?N1k5VHJHSDV1cHgwY3pPUVJCS25PZm45bVR6YnpoSzRqZVZoRXluOW5LM0Zh?=
 =?utf-8?B?bHMwa3lMaEp0S0lSYWFZeU11dkxib1c3TGxJNjFock02Q1VkR3lwbEFUM1Iy?=
 =?utf-8?B?SmxYOVhJUkJIZ2ZndkRkaVliWllRVWpDS0orVlZDeWdWa0x5L1pLSlVVMzVh?=
 =?utf-8?B?elpFVmNSLzBOQjlMT3ZVUEFYTnF6OWRKNVRrbTErMklRZURuSWlVcStVYi9S?=
 =?utf-8?B?TTg1bk9CaVJVcm5iT3VydktBQ0Zra0xlSDBXd21FTmFWTmZsaG1NMmNVaGF5?=
 =?utf-8?B?eEp5Qi8xa21xTmIzTDJXb04rM3N6ejZ2eFpqUzRVc1U4WTU1WFZZZGtXS2Fq?=
 =?utf-8?B?aFN0Sm5GTXZ3c0ZSSGVSNWllYWp2OUpxR3JobVhyL1Bxc0pvMXhUcWtoaGxX?=
 =?utf-8?B?cGxVcGpUdjlrKzE3cmZNd1k2QUl1Ky9WaTUzeURDRVhEVzNTVHlrZXZHZjF1?=
 =?utf-8?B?NllsMWkyYVh1clQ1TCt5WkJyYkNKZmZQVlJGZFJ2RnhXVFB5S0hZSHJkdytJ?=
 =?utf-8?B?SU14a0svK1VtWXRFeXBMclRsVnhtaUVlVFlQeVZFUzcrTnRScWsrQmZEdm9Z?=
 =?utf-8?B?SVFtMkNTc0cxR1plWFFydnBwd3RZZkxQbWgxVXRPMVFDZStaY25nTXNvZm1T?=
 =?utf-8?B?NXVSS2ZkbCt3eXNjMDB6WG5qNGorYzUrNkVhL3NIQUp3V0FNd1g1aUNpTFVm?=
 =?utf-8?B?RngwQURacHlxZWlkN1QvUVd1OGlvNWFsYXlYZmpnYmUyRDVHOWRMdHR1Y3FO?=
 =?utf-8?B?VEpZaXRrd1l3ZEVSWkNQUndVbGFmOHhyYkhiVkp5MTB2N1k4cy9PZElVNlZ1?=
 =?utf-8?B?NjVnZWZwbXlMdll0WDkrT0dUMkpsMFpyVEhGRlhPc1lmYlZ5WjQzcXN4RER4?=
 =?utf-8?B?ZEFYZ1VaYmlETjZydWRiTGtTcDJDNmw3SXVNYzdxcHl6M0Rxa2Z2QnFnUnh6?=
 =?utf-8?B?QWI2Z1JIK3BHMVBJdTd5UjQ3dVlOTWxramFtTU55WjkwT0w5MmdwS0VzRkR3?=
 =?utf-8?B?NVkvUDBWRkFHR090YWM4cVE5Mld3Z2ZEVU53R0I4VjI2OW0xViswcTR2WWh4?=
 =?utf-8?B?cC9vZVo4L1VnenYxenF6MDA2ZnYya3podWtaZ0FIRGJaN0ZqZHJ5NXlJb2VS?=
 =?utf-8?B?YXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA10C771A476A6418E0A8249E035B02D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f220390b-43ad-4962-0944-08db5d5493a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2023 19:16:43.8644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rn1A9kFAXkIu3a7t4A4AqbkVZiy6ABK0S/SBBG78xekDWKioiJzLwMOrIWI8edU6XMR4N+zsyMxTdaGNDDotV0DqA/fMVH6Dz7hmT7eIn8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7911
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA1LTI1IGF0IDA5OjA3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIE1heSAyNSwgMjAyMywgUmljayBQIEVkZ2Vjb21iZSB3cm90ZToNCj4g
PiBJIHdvbmRlciBpZiBpdCBtaWdodCBiZSBhIGdvb2QgaWRlYSB0byBQT0MgdGhlIGd1ZXN0IHNp
ZGUgYmVmb3JlDQo+ID4gc2V0dGxpbmcgb24gdGhlIEtWTSBpbnRlcmZhY2UuIFRoZW4geW91IGNh
biBhbHNvIGxvb2sgYXQgdGhlIHdob2xlDQo+ID4gdGhpbmcgYW5kIGp1ZGdlIGhvdyBtdWNoIHVz
YWdlIGl0IHdvdWxkIGdldCBmb3IgdGhlIGRpZmZlcmVudA0KPiA+IG9wdGlvbnMNCj4gPiBvZiBy
ZXN0cmljdGlvbnMuDQo+IA0KPiBBcyBJIHNhaWQgZWFybGllclsqXSwgSU1PIHRoZSBjb250cm9s
IHBsYW5lIGxvZ2ljIG5lZWRzIHRvIGxpdmUgaW4NCj4gaG9zdCB1c2Vyc3BhY2UuDQo+IEkgdGhp
bmsgYW55IGF0dGVtcHQgdG8gaGF2ZSBLVk0gcHJvdmlkZW4gYW55dGhpbmcgYnV0IHRoZSBsb3cg
bGV2ZWwNCj4gcGx1bWJpbmcgd2lsbA0KPiBzdWZmZXIgdGhlIHNhbWUgZmF0ZSBhcyBDUjQgcGlu
bmluZyBhbmQgWE8gbWVtb3J5LsKgIEl0ZXJhdGluZyBvbiBhbg0KPiBpbXBlcmZlY3QNCj4gc29s
dXRpb24gdG8gaW5jcmVtZW50bHkgaW1wcm92ZSBzZWN1cml0eSBpcyBmYXIsIGZhciBlYXNpZXIg
dG8gZG8gaW4NCj4gdXNlcnNwYWNlLA0KPiBhbmQgZmFyIG1vcmUgbGlrZWx5IHRvIGdldCBtZXJn
ZWQuDQo+IA0KPiBbKl0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL1pGVXloUHVodE1iWWRK
NzZAZ29vZ2xlLmNvbQ0KDQpTdXJlLCBJIHNob3VsZCBoYXZlIHB1dCBpdCBtb3JlIGdlbmVyYWxs
eS4gSSBqdXN0IG1lYW50IHBlb3BsZSBhcmUgbm90DQpnb2luZyB0byB3YW50IHRvIG1haW50YWlu
IGhvc3QtYmFzZWQgZmVhdHVyZXMgdGhhdCBndWVzdHMgY2FuJ3QNCmVmZmVjdGl2ZWx5IHVzZS4N
Cg0KTXkgdGFrZWF3YXkgZnJvbSB0aGUgQ1IgcGlubmluZyB3YXMgdGhhdCB0aGUgZ3Vlc3Qga2Vy
bmVsIGludGVncmF0aW9uDQp3YXMgc3VycHJpc2luZ2x5IHRyaWNreSBkdWUgdG8gdGhlIG9uZS13
YXkgbmF0dXJlIG9mIHRoZSBpbnRlcmZhY2UuIFhPDQp3YXMgbW9yZSBmbGV4aWJsZSB0aGFuIENS
IHBpbm5pbmcgaW4gdGhhdCByZXNwZWN0LCBiZWNhdXNlIHRoZSBndWVzdA0KY291bGQgdHVybiBp
dCBvZmYgKGFuZCBpbmRlZWQsIGluIHRoZSBYTyBrZXJuZWwgdGV4dCBwYXRjaGVzIGl0IGhhZCB0
bw0KZG8gdGhpcyBhIGxvdCkuDQoNCg==
