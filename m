Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C997BA664
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 18:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbjJEQdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 12:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232905AbjJEQck (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 12:32:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEC428108;
        Thu,  5 Oct 2023 06:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696513493; x=1728049493;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZyImFdJkizIIm14WJg2Ixo/pYCP+RotrDcVrOKM9Tvs=;
  b=Idqv1ZOTfqW0zqVg6akZjPHszoK2dzWHYhB/5F87VJUP9FRAGbkeGiFD
   8izjsDN+1abRNGAbAMJaEtip3snKnn3fzLTHh28sR8tM0ucrsMqlUEUtm
   B64Av3/1BSGgcoZf7rj2QATQYqJ1fv4KeMY+7gOtUCzCpCkBXDxJf5tAv
   adqMMU9X41amWo6YHZcZmJDwBvk3g6U6Ob3bgVheuszyzrStqtLTg7QEx
   Pe8AM82ES7bV4RJFec7LfU058TQKfIWbg9rA/vIaJxoBIPpg1ebO40ZZx
   94pOIb1v/hd03nkfZ+XsU5byr/AnhUeIq+NlaYwePtERpHi8UerMI82Jd
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10853"; a="447616789"
X-IronPort-AV: E=Sophos;i="6.03,202,1694761200"; 
   d="scan'208";a="447616789"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 01:04:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10853"; a="701554854"
X-IronPort-AV: E=Sophos;i="6.03,202,1694761200"; 
   d="scan'208";a="701554854"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Oct 2023 01:04:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 5 Oct 2023 01:04:39 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 5 Oct 2023 01:04:39 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 5 Oct 2023 01:04:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQcoxKp+3OhwfkWxMNLGEph19OuWgCl0j7R8sGFSPfMOT4zqLZNEQCf4v9G2OTla6mPtNceL46EBlfhJT10pF7FJbCp5E1voRz+blJKrJioCqSUgoMwi+LnSDwpMtUrPt8T29Z8XZ/t13WRvKnNR3TebPxCrLl/XC321+/7w3S3GumCBhWtcp58caJVlZEAtihawTwiDnPUmJdtfuKWVvGh/HgwXsGMUisW2kemRfoeS3Wh0CrD8zq2AXIdM4V0qUQEFIP4zss84Ejxqk53jWLyQ1kPRrlC8IFruY8+HSNPKbDjOk5aIFbEdHi5pf8mDVllIZMRkxACUvfpLxYQ6+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZyImFdJkizIIm14WJg2Ixo/pYCP+RotrDcVrOKM9Tvs=;
 b=Ch6x537W9Ylo5uybToxwAq+mvFzPgj4c2kRK80MAIbaUXTwyTqngbYCgPNOK2CsKME4nyJDKlyXSncocny6zb59yEa74VcWClwlP9c4l7o1MiYaeMR3AMgbv+HzXrI85+ZrbdmfHyuiWi7z/76MGVWdJ4p5Fs2x409grOjGQ8MYwnrLXy0g8PGfH6ursXackwtYSLae7pdk9skcy2ZbfgqqIZjXYQTdBiRfiBvQDheReSERNQx+fLf6Dwl5gWH15QX7Pxyg7Kc79QNMyfUCpv29lDtBnRUO1NYFHq/zN4ESiTA2jh+1EJIRdV2ZNg0gWFu71DP1+ANYisbVBKpwSPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6737.namprd11.prod.outlook.com (2603:10b6:303:20d::15)
 by CO1PR11MB5075.namprd11.prod.outlook.com (2603:10b6:303:9e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.29; Thu, 5 Oct
 2023 08:04:36 +0000
Received: from MW4PR11MB6737.namprd11.prod.outlook.com
 ([fe80::1691:ce61:f017:88ae]) by MW4PR11MB6737.namprd11.prod.outlook.com
 ([fe80::1691:ce61:f017:88ae%5]) with mapi id 15.20.6813.017; Thu, 5 Oct 2023
 08:04:36 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>,
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
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: RE: [PATCH v12 06/37] Documentation/x86/64: Add a documentation for
 FRED
Thread-Topic: [PATCH v12 06/37] Documentation/x86/64: Add a documentation for
 FRED
Thread-Index: AQHZ9ca25hed7BrCjUK5e91MqRkFIrA31ScAgAMEFqA=
Date:   Thu, 5 Oct 2023 08:04:35 +0000
Message-ID: <MW4PR11MB6737F8C5FEF0291B691F4963A8CAA@MW4PR11MB6737.namprd11.prod.outlook.com>
References: <20231003062458.23552-1-xin3.li@intel.com>
 <20231003062458.23552-7-xin3.li@intel.com> <ZRvmGNRZ4IvmguAY@debian.me>
In-Reply-To: <ZRvmGNRZ4IvmguAY@debian.me>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6737:EE_|CO1PR11MB5075:EE_
x-ms-office365-filtering-correlation-id: f17cc11c-148f-440e-84b0-08dbc579b74e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3d3sXIrwdiGtUsRbglGyoMawkSvYCW9r5uoi7E3LrCJJrsATCwwHm4MvejA9G0o03CB4cjIxeblI/yOq8LH5PMeynVK9uRczJnmEDv/m84UenPMvY1Wk/hc9gzpdaaj3shzzxPc+CK6IdoOlFFWEhiE90VnR6so+pOZYzBhryRm6QxuiOoi7RtPY4l9IHxL8774L9kS73czeza538HUzGUxGq98Btf2g4mZ+yINzXLrprdHH5DEXibSRzj0VfpzK42HJQDZsschEqKWz2+DrcE4xhUGUSlEcfk01KkCsa1tDNDQqRmaG2pddITZRk/M9Triv0SCsHmRUdKDBhC1iyyRWWnfq1Ic7ga4910K/GJcHcE0pbQ7g/klTKBWHTWHQLS5U/sBXZQhik46xNG5nQTz3H2iJQN1gcZCV3tcihNScx+p3dKlQs51h09ghowMu71YCaBBeQMvKuiDJ058wgw4eQkjfXlhjQ/JJXZUfn4gCAG4PUQhm+m3aT5nDK4yKTEFL2z5rCpNCwImnKNgyeX3D/maPH3Hqp+7CfKmQOSgP75Dc29MmHiE6O2MJoruWbkCU/HdZJVqYs4wa4DjS05VhXoUdVNeYlmC0/txz56qWbmtno5immPAxDTLGV/y+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6737.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(346002)(39860400002)(366004)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(66446008)(64756008)(54906003)(66946007)(66556008)(66476007)(316002)(41300700001)(6506007)(9686003)(33656002)(26005)(71200400001)(7696005)(478600001)(38100700002)(38070700005)(86362001)(82960400001)(122000001)(110136005)(76116006)(55016003)(7416002)(2906002)(4744005)(4326008)(8936002)(5660300002)(8676002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Sks2Q1JncXY4eGUzeTRVWXN6VzFBNE1tdU1BSTYvaTFmYnRHNS9qQjBKdTJW?=
 =?utf-8?B?WUlPdFZPUHFBQ0hnTkdnMlhUSmREQzNwZmNwbDhZdGZiR3JsMHQyd05lREtU?=
 =?utf-8?B?UVVMbnRLY29Ydlh1SEZ4U2pXZmtBWk51L2RxalovWkVrSVA0NE5SZ1BpY2w3?=
 =?utf-8?B?dnhBWjB5bjJpbzVodnVNcjdMMmdvSFcxcVZvb0pLOXJYOVdhTGEvSUlhQlAw?=
 =?utf-8?B?S0oxNTRWK3F2S2I4UmM2akZHUWlmL2hDVEs0SEpTMkdRaTAwY3pZWm1pVStq?=
 =?utf-8?B?aG1VUEZ3ZGlyOWgyWUFZMXYzNldXZ2NtYlFwMHdiT2RlNmI2UXhTeHRuaFpY?=
 =?utf-8?B?OHFvVkVRUndUNHlHV0k2R0VEUzNoTFlMbWN3bFVVdDNFVjdpYjB3RXRaOWVQ?=
 =?utf-8?B?TVQ1dElEZTFtQ2R0bW14dGF3TjdSMDdCUThYcE9aVGZtMk4rbm5zaUl3MkF3?=
 =?utf-8?B?cHplb3pxZGZTYnBGNEFObnAxSU1vWVhEMitTcFI3UDFjaHQ5SThOZkpYNTFx?=
 =?utf-8?B?ZDU2N1BGemwvNm9vYlU2dlFDaVhtMnpUTGc1c1pOdW8zc3BLODFNcTd2Y283?=
 =?utf-8?B?RE9Jd0pXLzViUklIKysyTzJuZ0RoN3pyVW5VZkVESkJXNkZucmxPMm9qckwz?=
 =?utf-8?B?Y1lnSVd2K2FwTjlwa25HLzh3YVl6Ri8vMjZHRVJhd29JdXkydDVuV0RCcGk1?=
 =?utf-8?B?TEk2N1U1ckZLYW5rR3BNWFRDMU8rU3l3YWlnNGt5SGJBNXRPVm9aRDltNFNn?=
 =?utf-8?B?ejlWZHM2eHZvRmhTQnVUczFZVWZkVG5IQWIyZmxvenRzanBkVTZ4UUFIS3lW?=
 =?utf-8?B?TXMvQVBsamVqb3F0U2xTNTVxWEpydTJYSnBONCsxV3NCR2FrTzR0bHF2UkRU?=
 =?utf-8?B?citUaCtkRTBpelhqcjVBeG5Ob204TlN1bVhVR21FYTY2VzRpUzdLSU0vODJX?=
 =?utf-8?B?WStWQzFBWUV1eWdnSUZDMm5vaU1vZXhOR1lvK0YvTmxDc08yU2FyY0traXkw?=
 =?utf-8?B?RitmMGFTSk1pTzFPSVZERG1qM09MRVNrYllDUFl5a2dWM1BvaDdQdllGUmZh?=
 =?utf-8?B?ZUJ5N2N4eldZODROVHJrWEs1Uyt2SmVyLzdtR2hQcmdlUzdaOUxnT2xLeDBy?=
 =?utf-8?B?VmhhWmJQT1lPdDVHL2Q0WEVWSktVUXIxb2xsR0Q5d1NrRUI3aHdoREJEMWVq?=
 =?utf-8?B?cGxjR0JRT0o1eFYrVjFtb0t6VCtvbFBNMmxRa2dwM1FlNldPTzhaZVV5L0tx?=
 =?utf-8?B?UlkvR3EzbVAzbVlKTG5TaXpSdmlHZ3BKV1RTRk1wdE9ISFFVZmw2blN1ODJY?=
 =?utf-8?B?RUIwa0hkdnhSRlg5cXdVT2dObmhMNDk5bWlzOGpCV1ZDN25BNHBPSVU3Smcw?=
 =?utf-8?B?bUthei9JZzdvdkwvdzM1K0FablVYbWF3a0R4VVRxZ1FPdWhzY1N0L0l1cVly?=
 =?utf-8?B?bmhwbWUxUDFya1BHNm5HZTR1aTVMQWVXRkZVbFNOQklxZk03MUZTRGk2bjBN?=
 =?utf-8?B?YTBFRGFwWGIybHdpOFFsNXZXSG5KM044T3ZBZTZ2S2d2c2JNbGNEY0VabVBW?=
 =?utf-8?B?S01pbS9qeVVTVGcwa1NMVW83YlFZN28valBRUi9jQlhXSFFOVzltVURsc29U?=
 =?utf-8?B?Z1J5TmNRb0ZZK3ltZFBpTE04bXJFUzJPNktsSmNwQVQrenlYWjBGRk1mZ29v?=
 =?utf-8?B?bjY5L2F1eXdsajZPeE96dmttWXRuTlhJeXhMYlU2K3lGK0VQVVVxYWJRY0VB?=
 =?utf-8?B?TGxtalg5UjJhVS9nL1NselluR0Vsa09NYnRDSnRYaEl2OUdMd1cwWStvOWhY?=
 =?utf-8?B?TTBCQ2JFYmtuQ2tmUlpzVnRqY1B2TExBVHZhZXVyU2VFZWgxUCtHeEFJSzlm?=
 =?utf-8?B?eFd4TWUvL2lqNXVHVVdTdzVoeU93RkxydjZ6UmQxcW5mak9LZ2NpOStyUkRP?=
 =?utf-8?B?aFExUkFzdmcxWGh5dTBjR3dmMFBndE1GaEpWazVFUTJieWt5cysvdWs3eFNq?=
 =?utf-8?B?RGQrb3R3QlE1d2cwRzMvN3BRUkNzRkN2aEh5Y0lEV2xYQVc2Z0NYaStaeXIw?=
 =?utf-8?B?OFVPK1dPNDdtelIvMjhLL2FFdms1YnBQMUJyWkk4aUhTdHFYUFlUcUNtWEgr?=
 =?utf-8?Q?TESY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6737.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f17cc11c-148f-440e-84b0-08dbc579b74e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2023 08:04:35.9914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BSUl0krpto5KpJocefkoJSEcnRV2YXUIxMUvbfa3fmcalT2XKNUH9u91JsV4RoXzIPZsYtZ8p9fzBswT8Lc7Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5075
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

PiA+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2FyY2gveDg2L3g4Nl82NC9mcmVkLnJzdA0K
PiA+IGIvRG9jdW1lbnRhdGlvbi9hcmNoL3g4Ni94ODZfNjQvZnJlZC5yc3QNCj4gPiBuZXcgZmls
ZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4IDAwMDAwMDAwMDAwMC4uOWY1N2U3YjkxZjdlDQo+ID4g
LS0tIC9kZXYvbnVsbA0KPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vYXJjaC94ODYveDg2XzY0L2Zy
ZWQucnN0DQo+ID4gQEAgLTAsMCArMSw5NiBAQA0KPiA+ICsuLiBTUERYLUxpY2Vuc2UtSWRlbnRp
ZmllcjogR1BMLTIuMA0KPiA+ICsNCj4gPiArPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT0NCj4gPiArRmxleGlibGUgUmV0dXJuIGFuZCBFdmVudCBEZWxpdmVyeSAoRlJF
RCkNCj4gPiArPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCg0KPiBM
R1RNLCB0aGFua3MhDQo+IA0KPiBSZXZpZXdlZC1ieTogQmFnYXMgU2FuamF5YSA8YmFnYXNkb3Rt
ZUBnbWFpbC5jb20+DQoNClRoYW5rcyBhIGxvdCBmb3IgcmV2aWV3aW5nIGl0IQ0KICAgIFhpbg0K
