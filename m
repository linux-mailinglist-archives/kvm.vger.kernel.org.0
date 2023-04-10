Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA3D6DCB72
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 21:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjDJTQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 15:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjDJTQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 15:16:41 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB53198D;
        Mon, 10 Apr 2023 12:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681154197; x=1712690197;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mNQYfcvRUHI8ddDj25leQfCb2iplPuuzi1nYnQXFkeg=;
  b=hK47GDBovTM8x//h++0UBVSdXXNn65vmtvGAY3mj/HNt987jObf8L5Vw
   hLWsjcT04QX3CCRsDBrZ05aifIZYIHyLoSDdnVyyFCOy4jYILUg36pYLe
   LujyqtFfiUeP3HUrgpjG4A9RDr1vLxljUCkQyxMvhjyVbBSgv1ZdEeyBb
   +cIkx+3GrpynJB+lZujDXJU8UqsW4OXi9XuSbge5yNip4bVfeuKSgp20c
   l7jyw1TJtUDbo1rmoaE4KiUhBSfFndv3VwlhPM0+VWI/VhlzjM9C9FEOf
   9/gSPwaUkuL8g+B5xbpps4Ik6mxQ8GB79FaXoYnQXQnEJNW7KLcj0xsbv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="323069681"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="323069681"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 12:16:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="690887074"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="690887074"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 10 Apr 2023 12:16:35 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 12:16:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 10 Apr 2023 12:16:35 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 10 Apr 2023 12:16:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d5SeXiEUdAbN4LV69CtEQkCjkDZ40DsP9xDlv4FUYoO9uxkh9Q0o/+rR9qjFKW/4Jm3palV227RGvQZUhvOq0IQOHg1QQh2vsoxyT2Ab7VCa+O68I17smnRv9dZRo/zDNtl2HRpdJ5fjN8QIt/1Cn4oMy6f+WzZXLwGIu0qIexoR+WFCantvyRHyH4fbMtZ92wmam5ykXLXLGHXnIrnE9cpH9fQGiEo5bAqR9kFUXPO8ms8+Mr5YkYeMi4IkW8w43MOsLBBlmKWu9B0D18zqN9+koTWynBP6UaF1RHPJto5O36w0zwNt8WT51tJZutI0uoxu+nFK0ITXoC39wT4FXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNQYfcvRUHI8ddDj25leQfCb2iplPuuzi1nYnQXFkeg=;
 b=RbOG9AUS6jmg1PNYZxjl9XwhgbluSivv/iAk+StJzDmQWNcNCIttSDfdbQyaelCVSApSqY1v72d3JGmehtCiy2NoTvWB/Yeqo3YdJPqeQfDiftrW4bcRJAv0pG6RFi4UqoNSR4acYb2cVrsNMcdermV02bJzPwaGGF+It9aG4SM5snxTtFVQiufa3FEiQmXFTQ3QicyvUCy9RPNBk4DvP++5w+An/WyV54CZJ2yXHioQt68nvc79vHHcB6qa/Cjl8jG3BV01DTa3jUS/81Spt28BaOHd3KvMt/i9RzquI2ZyAxvTK5nSPePRDYFvPpRyqhQH5QEtkvnnTZShZyTRyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by SJ2PR11MB7575.namprd11.prod.outlook.com (2603:10b6:a03:4ce::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Mon, 10 Apr
 2023 19:16:31 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948%5]) with mapi id 15.20.6277.034; Mon, 10 Apr 2023
 19:16:30 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>,
        "Lutomirski, Andy" <luto@kernel.org>
Subject: RE: [PATCH v8 00/33] x86: enable FRED for x86-64
Thread-Topic: [PATCH v8 00/33] x86: enable FRED for x86-64
Thread-Index: AQHZa4g5E/QemdFnfket3mQeyiRQG68k410AgAAHDpA=
Date:   Mon, 10 Apr 2023 19:16:30 +0000
Message-ID: <SA1PR11MB6734AF471CED746AA998A2ACA8959@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <f4967a86-d575-7e82-3e60-183cfd7adf0a@intel.com>
In-Reply-To: <f4967a86-d575-7e82-3e60-183cfd7adf0a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|SJ2PR11MB7575:EE_
x-ms-office365-filtering-correlation-id: d6edc8ef-7f15-45a4-32d4-08db39f8173b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /GT+OwL19SnpEBMyTN6y4x7uBmv4HVB+f78BA26WeGDxixswmAiHjm2/wbGEkmypkpCFQig2HttaFwMnb3Cx9zegdk383WICLdqjiCezU28Ka+bqri0yLvZApUNM2Ci+9VcuHUTe+wkuFFiiatt7kBzBltETdDtSsacG3zIGWr+6E8IdsoVXmgYzNsCmTgOyDcwkF1kX7k1oZD9zoBj2Gt/PlIAB2e8lZUmaK+zNROTxx5j3uimcSN86+eZ8K3sM3zrgJDujo1eZFZZ84mM7X/sN4g/+oun2v9r+YdCH4g8I6ojDkDXxU295s92Pg0or2GAbtO5PD2t1JEdxywLwDsDQM68BWStIQ3J2vOj5oUB86WiPcAly+4ftq/tgkQYTTKQtD0sPx/TDZg4WzduaATKIknq+/bIrYhcoif39Ix1gAPD7LQ+NfT4GLooEb81t3xFjNuYlhQ3IUr+krlbZ85Xkx98ANnRWWptm/zT8oJ+mhMdy+IurwbXNLajDCnJF2JFrnCRefuw8cVgn3Toygg5MW6qmlWycszBCBizSudbIWlLY+tjqYgkZUUxk67YjTxcta9MCWIG3Q3v8F/nGzSlWjh+AF4bjr4PFiQv8HxcO0SD3nyOk/87ht4+tcS3Y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(136003)(376002)(396003)(451199021)(7416002)(5660300002)(186003)(9686003)(82960400001)(86362001)(6506007)(26005)(122000001)(38100700002)(38070700005)(8936002)(4326008)(52536014)(478600001)(33656002)(110136005)(54906003)(8676002)(66476007)(41300700001)(71200400001)(66446008)(7696005)(64756008)(66556008)(55016003)(66946007)(316002)(76116006)(4744005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MnF3U2psdnppbkpiUXcvM3ZyZUsxZ1VaRE5QM3p3aWplRW1kQTV3U09xK29E?=
 =?utf-8?B?Yi9SeElWeHNKOGZRR2tpQm55QmtDL1MyeWtFalczTTZrbXBlMndLQUlseWZZ?=
 =?utf-8?B?cjFjWW9Rc2NUeEVDdWt3R3pSZmhPVlB0ZHIyR0JmRFRDaitHM1RjUUV5d25D?=
 =?utf-8?B?MnI1MWZORDhGUmFySlZGbUJpWXViZnZNTWdYOHpLb2MzcU5lNVNxb3dhdlB4?=
 =?utf-8?B?b2VqclUxekJyZm5TSHJoTHpXNmhkUVZUZlQ5NFA5ZnlBUHdLYlpVdUFEaTdk?=
 =?utf-8?B?bjVGNHhBcndzeFJEcG12cFhKRncyTW1La0VyZmFBVTczaERCQjR4N0d4MjJq?=
 =?utf-8?B?dTB2U0RzMnh0RkhyUWE4eTNaMlFkOWZXVjFMSmo2WmMvdERuUVZjcEdDYklx?=
 =?utf-8?B?ZHBZRTcveHpJNTFWdmFTT09pMVJZbGt4d3BGOENJYXVJbkVGMkd2aHpIRXNv?=
 =?utf-8?B?NGRYUkxnZnlEeGZQRENZS2g4TS8yVzhZbHJnU2VlTnpaaThYVmw3am1oNkJY?=
 =?utf-8?B?UTN6UDV4NDhjZmo3UXdaUkhOOUlIUS9tenZSRG93Nk13L0tYRE9UczdmU0tz?=
 =?utf-8?B?cll3OTlOQ1VOTHdMMWRXak8xYnNzV2ZweU5lQmJSaDJiUnlsNG9NSm9IUVhG?=
 =?utf-8?B?bS9PQ3UwRlNRZGpxQVFUMTM1WVFtZGVpMnliQ2hEZ3VHVy8xT1JjeGtwbk9t?=
 =?utf-8?B?TitVMEpCcDEyMDNqbnBRQXFwdDhtNnY1bWMrS3kzcm1KUG84Qjl4R2VOUzZ6?=
 =?utf-8?B?ODUxRG4zTXR0TlRhbWw5OVBjWUd1SkhBUUo0aERxVkpvdytJeVZlNUxvbFQ0?=
 =?utf-8?B?TXJwTVpHTUxYWS8wYm5LdVA4OERNVmo1ZDg1d29HOUo0NEY1YU5GdDI1eGsw?=
 =?utf-8?B?cXRkODNkcjhhWFFhR3A1SG9SbDFPbEZPS3FUbUFwUVIrczhHckZQSi9aK2ZE?=
 =?utf-8?B?eXZHMmtSR2FDWmplZWJLSzhFNlR5bzk0SjRoYkdMeFFIMjkwcUlmVTkvRFFU?=
 =?utf-8?B?R0Y1VE1uOWVxRXExYW8zV0dLSm10Q2ZvaCt6N1VHQWNzSUwrM1FmaWxxSWFO?=
 =?utf-8?B?M1NKNGRRTVVTdjlDUjloVjVUUzdHMVQwTFBpa0tyT1F5RlVicitCL0tzdmht?=
 =?utf-8?B?dG1wd2R4d0RLdjV4d2Jic05lY3I3aG1hUTZTMGVNT21UZWN1V1pzeXl6ZzNT?=
 =?utf-8?B?WUV2VDV5TGUxeWRJUU05Tkl2S09Fd2lCbEFJTnBHVlBlSnRvUWgyTUxubE04?=
 =?utf-8?B?eDUwUzBIOGUxVHYzdFNtZ3BNUUJUMXpwbDRvQlhOYVVWRm1pTzBqTnlNUGNH?=
 =?utf-8?B?OG50aG9LUTU4K3E3VWZtQmhGSjdSMlArTTVNb0JibVRGekJDUFhOdyt0L0lL?=
 =?utf-8?B?QlZ2Q0FMK1FmeHFRUW5kUTdaYUpET2RTNTRtYUN3NmMrTHZib0xINHNIS2h0?=
 =?utf-8?B?RVF5RFJMaDBGMWZGMEV3SE1TZVBGZXJXZG9TQWlFSTBHZ0ZJYmFtM2s3TzNB?=
 =?utf-8?B?YW02L3BZWlN2MXRWcllDWmF0cVhpaGRUbkszWXJFSFZPaW9RT3F6REtsaVNs?=
 =?utf-8?B?bENhWVFPeWtVV3RxdFYrYWF4WGlnZGppS09WaEhheEZROHRRMW5qYXRDUWx2?=
 =?utf-8?B?WUtSNkl2VWRLZ1R2a0VUQmI2aUc4UVh0TWJTeCtvSWtHa3VBZWlzck1wZUM4?=
 =?utf-8?B?aklvQ3NwRU5RWUx5UmVQc0w5V2gxbnBVWHFiWFRQNlB5VEdVMm5rRktsL1hM?=
 =?utf-8?B?YXEyMjd6K0ZFb1ByWmtKT2ppNGg5S1NlRU44Slc3aEszdEp3TXRrWGluNXl0?=
 =?utf-8?B?WmFMWDZ6VEtUaXN6bHpCdHM2YUlySmNyWWxCMUlpN3lobzByU284Mk9yUlBn?=
 =?utf-8?B?ZU1VNVAzeUxMSlU1Yll6SUsybGZyMkxNK2F2MnorRGllVnpxb0dBZkZvWmkw?=
 =?utf-8?B?dXhYZnFMZmNNYzQwMDVPMnN6aytuV2d2Qkh3UXZwT042eHEvMncxRnNBdnhn?=
 =?utf-8?B?VndjOEpERjArNzgzN2lHQStSQys2MndkSFdnZys3T1EzZjc5bjZZdmdCMzI2?=
 =?utf-8?B?ZmZkWmhBSlJKQUlSdDY2MkpVZms1Nm05NklnaFREallFTFA3and5QmQvUElv?=
 =?utf-8?Q?+/Nk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6edc8ef-7f15-45a4-32d4-08db39f8173b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2023 19:16:30.6902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UCUcFLdCHy27I+Y5sP8Jr/+GBtyRpgdlszq5b+gq0lF2icMmM91EDU0cpLJBcxfBaXk8arhX5bweXFckyfndXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7575
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPaCwgYW5kIG9uZSBvdGhlciBuaXQuICBXZSBkbyBoYXZlIGEgc3BlY2lmaWMgbWFpbnRhaW5l
ciBmb3IgdGhlIGVudHJ5IGNvZGU6DQo+IA0KPiA+IFg4NiBFTlRSWSBDT0RFDQo+ID4gTTogICAg
ICBBbmR5IEx1dG9taXJza2kgPGx1dG9Aa2VybmVsLm9yZz4NCj4gPiBMOiAgICAgIGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gPiBTOiAgICAgIE1haW50YWluZWQNCj4gPiBUOiAgICAg
IGdpdCBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3Rp
cC5naXQgeDg2L2FzbQ0KPiA+IEY6ICAgICAgYXJjaC94ODYvZW50cnkvDQo+IA0KPiBQbGVhc2Ug
bWFrZSBzdXJlIHRvIGNjIEFuZHkgb24gRlJFRCBnb2luZyBmb3J3YXJkLg0KPiANCj4gVGhpcyBp
cyBwcm9iYWJseSBhbHNvIGEgZ29vZCBjdWUgdG8gZ28gYW5kIG1ha2Ugc3VyZSB5b3UgZGlkbid0
IG1pc3MgYW55IG90aGVyDQo+IGZvbGtzIHRoYXQgbmVlZCB0byBzZWUgdGhpcyBzZXJpZXMuDQoN
Ck15IGJhZCwgYW5kIHN1cmVseSB3aWxsIGFkZCBBbmR5Lg0KDQo=
