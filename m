Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78BB7695DBB
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 09:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbjBNI6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 03:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjBNI6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 03:58:35 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962ED30C1;
        Tue, 14 Feb 2023 00:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676365113; x=1707901113;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2yUjkjpfbPPCNwuM+osNCxRoId6dUtlvDg9tiVtuIUs=;
  b=RX+kUI4VA9ePIUeleSk19EMrm8QrLC7s2nKDrpxLStF2Z+P4HCTXYlDR
   xJ0OVcJYZavWOiMG/CzmjYjx2TwUNZEWlqgqyNi9zklDO8HGyaq2EJjPB
   MGQEfPS1RvU6asH1xBjWIWwAr1NxWcEiYfmaUZkLISHEg72rsVY6Gh6xs
   dKAG2dlo+VXlFCrtuvMqHw65k7MMgQIU9iISR6escOZUorucmA4fhE35j
   kmHtQeCoytSyokQPP7llhhF48U11zF4SNorqGerEZRCSpOQEOksmXctC4
   AYCZJBIn9/14ootJx0jr4PSleKAym+KzEjeiPF2XEZNJyun9uVb4A1VQB
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="393516551"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="393516551"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 00:58:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="646689705"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="646689705"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 14 Feb 2023 00:58:09 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 00:58:08 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 00:58:08 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 00:58:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVjqS/bZ3Qe39lkdJhUKaQUoi9rmDT8Yw8y5xENwe8lh1IUfFo2alSULOWlyv92YXDdUEp6NXKP/sa4TvSnwVFCkbk+VBoJt2W5aJEUCPldv0iljfGEx6cRbZTWS0Igv4xf+yGLtPw6fgEOPgizafcRQ0Nd+1XSLO37UUJ1K4GWt7IN/mThuBJBE60pGuswVBKoSkEOCxaFWDTwtxUC1oTwIazNS7C5HGPnZlXFMkQyS5OvO034mMwZPZVjJJ7/JywAUKOYGuwlihs/Dafx6rDmoMbFX3e3s6wct+hll+7ZMztfTWaAYC9QERqQ5xaWiVUetVDqtS3zGsMzSCuQrcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2yUjkjpfbPPCNwuM+osNCxRoId6dUtlvDg9tiVtuIUs=;
 b=if+EiaBIDWLO/HRVy3DW9LwoBxEEs2ua/HRbb0hDJD9WfaMK2EjtNyi8WWozelZyKNLSkcWa0IIrMq5kEgqVwl9Oq8IV0yUOfekLnjFxrQeemtJMYbW6O7j/UvAtq3JL26XVWPQ5H5NkJ+XWzpXyaOqmc3ALCwMmG1EoQliFgMwgUlQhss1Z7MhCHfK+UcY++JAoa87vxdZ1cmcXjb9ZEwIMrckUoRrbO5ry1Hc8uSPxpHlSWCJcz5+FejumPAI5Jtr4LBsWAMGMXLOxL6JCRmIki+Wb3LP+y8OYnME05EBjzcDzqcnNHcctUx1jDWmLUApG9/WlVgYgReN5rxo4Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7347.namprd11.prod.outlook.com (2603:10b6:610:14f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Tue, 14 Feb
 2023 08:57:58 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%7]) with mapi id 15.20.6086.026; Tue, 14 Feb 2023
 08:57:58 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v9 05/18] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Topic: [PATCH v9 05/18] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Index: AQHZP5usrWInYEMBIEu01+xNPQ5Ox67NeMUAgAAMHICAAKC7gA==
Date:   Tue, 14 Feb 2023 08:57:57 +0000
Message-ID: <16470ac19325d99947bad3d4b16f6982b0facafc.camel@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
         <dd18d6b42768e0107d212fdebedae92cfd72cfe1.1676286526.git.kai.huang@intel.com>
         <37d5736e-93b1-aed1-c21c-07fe1044f2d0@intel.com>
         <f834ed91cba9fb7b14810fcc8ba0ae68b9b0e2d0.camel@intel.com>
In-Reply-To: <f834ed91cba9fb7b14810fcc8ba0ae68b9b0e2d0.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7347:EE_
x-ms-office365-filtering-correlation-id: ed1c6f5e-8974-48e2-e519-08db0e69918f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LiBEQ9JVsrRntpHx42qD19X1SgbQdvHe3MnVfuYVES1NIRi+RzHeod9YrxCrfuGrM/U4B+Swv8d/YzeqKg21Jx0TPjLClxB7jcgRl9BSA+6HajtY7XRT8VshxwoZwg7l+dqwabEsYRhWZ7s+ypf7TKEQK5KLAwFC6gHjfnCbOIIFrVsVrHYXAAfmoH7SZnI9IweOyBKkGfWUjCZAbYnEXSQYvQ2fslHiOjrOog079qp5wdecZ+AQbOpzj19snw6N2rY6hOr11OVP72iIkyuROmXb0GJlI5YjemM+3F8+e1IW/LHwHUInKktA74T4Gf8WDDG7EIg7PdcLox5myE/fDVtb726ZjLQtlGcYc0qcPjVFdiaL/ElEDxE6oKKt579OsME8VtLTHWTKiBr62B+kzd+naQTxYXjSiuR8s1OIGzmR/eTLNZU/eAmsRPqEL7bG/HDgzyOm8E4/7ZWiEMdZBVr2QluF41j/YBFRismRh99UcHY1lPXvgYOCKsfATVyU2cKCgR5oLWbYBklKDM7Kxpq4fDUoN3jy3WtLxkLtlw+Woex99vXSBIGXuOrHe6AlVShRIH0qo0LySsomD/KHrDGY4Os3lTh0lSUJKYkZJWbnWHoPtdMS+wQ2C7SPrfGR1M01UYtHE9iYQAS/kNdeBJqyNNqGwsoNRl8yDpBDduX79Ee+3ddsxQ4/d0UAwzht
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199018)(54906003)(5660300002)(53546011)(41300700001)(71200400001)(6506007)(6512007)(26005)(8936002)(2906002)(186003)(38100700002)(4326008)(7416002)(38070700005)(478600001)(110136005)(6486002)(316002)(86362001)(966005)(66556008)(66946007)(66446008)(66476007)(91956017)(76116006)(64756008)(2616005)(8676002)(83380400001)(36756003)(122000001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NndjSXRuWjFoM3NxM2hjdXd2MUwzb2hCd0g2TWRWa0t5dU5UcVdCMVp1Mm1W?=
 =?utf-8?B?dnZ3TDNXZ2lKS01nZWZWeXRmSTA3ZENBdS95cEdqUUNSVEVjWUVNNTZRS2ti?=
 =?utf-8?B?VlFUWFVUSVF4b3E2ZmROOG1QNWNrdEphaDZ3eVN1VmRpM0NDMHpWaE40OFF0?=
 =?utf-8?B?K3FSdDV1L2lHVmVZL2tNQUFZSW5nNEp1ZHlxZGpYQ0VaRXNOb0tHN0hVRzZy?=
 =?utf-8?B?Y1dMQS85dGYwd2FtR1UyQ1lhQ2JVR0h4WHVXN1p1a0tpT3VBTmJhMnUrSW8v?=
 =?utf-8?B?WDhhQ05yU080Y3Y1UWVvS3p2ZjB6MGlEbitiZGh6TXF2SzU3bjdsTmgxQlhm?=
 =?utf-8?B?bDdJeW4zTFlTSkJya1R6WlE4MjJqYWdQaFZEUWxoYVBKUjE4dEpRUnFwS0dx?=
 =?utf-8?B?KzE4Ky8xQW5GRUFjcU1CdENvcUZNUUJUM1dKZzMvcVpvdVdpTXh1eUZ0RGJI?=
 =?utf-8?B?QWtKcG1RZENic0F3dGZhT1phL3VYd3Q2clYrUm5HbW52ZWNtL1RTdVZEaXRD?=
 =?utf-8?B?eXU3S21mZ3ZLTG9xNGlvaVZ1WUZaQzhpYU1aZFJDVDIyYVQrci9zKzhYdG9D?=
 =?utf-8?B?YlFBUGhCcW1NWUMzRWZSd2o4eTEvZjBQTGhQeTlBNjBZazlKOHJvbWQrZ1BJ?=
 =?utf-8?B?NW1EQkJmeWxvdFRMVVdFQzIvSGJreTZZYkErL0d6R0c5S1NFd2xyc0xUeWZX?=
 =?utf-8?B?YXEyK0xrRlJkMDJoSTdJeUFDK3R3SHZsaHdHU2ZYN1Uvd0IzMnRSckZtWkgz?=
 =?utf-8?B?elliNElQR2p6WENNa0NJaVRsQzE2YU9ValpVajRpZ0k3WTczWkM1NDF0WXp5?=
 =?utf-8?B?VUZMZ1dSWjcyN3JmWGRlQmFGQTRwblZtREJvNEcxWE4rcHoxeENQN0lGdjFj?=
 =?utf-8?B?ZW52VjEybmR0aFcxVDFrWVBlZS9ZNkxhdThsUEIvTm01UENiditWWGJvd1hM?=
 =?utf-8?B?MjZrOWk3NnNIT1pMOG9NYTZQKzVBRHJJMW41Y08yb1BXeml0S0xxWUJUZ3po?=
 =?utf-8?B?NVlaRFZmMk9MVWpHZktKdWM1OFdaaWpmUUtmWHNRcTYrZi9vNE1zN05YSnhM?=
 =?utf-8?B?VzRLT2hiT2FKZzJ2NXAzdlpwbWxwUWxaTDFJRGcrTDlFSU5ZNTBvcFFHL1BX?=
 =?utf-8?B?T2EyR3NWd2NubUZwT0UzczJOMjZGNkdJcTNnejlpOVYvVFlJTG43UmFZNVRW?=
 =?utf-8?B?a0M4S0ZXY0UzaGFXRHZXNHRXaGtkNGQ4R3h1Y3JOWm5HOHlOb0FsRmw1OHVE?=
 =?utf-8?B?cXVrb2VWUHVMa0tDSEFDWWRwQ1VYdVJSb2YyMU9wWE5BajN3bWp5d1FoakJN?=
 =?utf-8?B?QXVOaTJmOTA4UEFTSW1vVVZSV3BiL2tDTUJyVFJKcEh2a3ozdklFQmdYakRM?=
 =?utf-8?B?ZFAzdHNqYVlEV2RZWTdHU3ZTd1FPMEJGMXgrZFJvdEhSTVMxNy9qZDM5Z2VH?=
 =?utf-8?B?bitIdEMyUXdsUnJyelNsTTJKa3QwdUxTNWVuc3ZjVldmWjM5RE1Gdm85bUtM?=
 =?utf-8?B?M2taZ1dWSjh1b2Uxei9uOXRrNGVNNllwd1lNcWtFYWNwSWdEamM4bDN4aVl6?=
 =?utf-8?B?a2UrTUZEc0IwOSsrNHpIc3JnWll2dURaQ0xWNWhtY1RPN0k2R1NrbGh2bG9z?=
 =?utf-8?B?VmVlaGpYd21ucnB2Rm9uWXZwVG9rN2R5Q0l6bW53QjNSL21MSVYvaDUzM29t?=
 =?utf-8?B?azJXUkdRcm9iUWJXWEg2T0FlODVpaFFqL1ZGelJ2R2RvMkNVa2ZsZ0pYaXI5?=
 =?utf-8?B?MjJmL2FrNUNuY3p5cy9UK2R0ck1ERHVEMXN3Qm5UdkJDNUVodGZzMGJTZlhC?=
 =?utf-8?B?UWdDbUtrVnBFbkhvaXB2OWFsTUprc2hMWmJQU0s4MGE0TUtEdWk3N1E4NGhK?=
 =?utf-8?B?Nm1xVldJYXZMcFZzN2wyU09ONlZYaXJCemhNQ01VODZTbnRWWEZMZU1GUFJU?=
 =?utf-8?B?VW1pcUYxY0F4bnlMcXpOcnNrNXdhODVyUVFxcFV4cmY2eXVETTd6a1VSN2RV?=
 =?utf-8?B?a3VPT0Q3OVpHOEhrOVZLRzV6eXZ5UXdodkVNaTVMT0hLdzJmamV4U3c1R3Rh?=
 =?utf-8?B?eU5yWmtETzZwUG5USVlsSWVZNVJ3Z1ZQcVh5NXI1MVdkRi9iS2lBSy94aENu?=
 =?utf-8?B?Y2tVUzh6OHk1ZThxUzJsK3VlSk12ZXZLbXpBczlBV2FjU0JmYURUQ2lEV1JR?=
 =?utf-8?B?Ync9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <27643D78FEB41149B8058448710D14FE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed1c6f5e-8974-48e2-e519-08db0e69918f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 08:57:57.8913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OmlgqFR60KuQ7ADbO6cK9hOzq3Ht8tO6Bf4ZDPjSJPgN+vux9XtyKQ6josAu+uLVprenHSWOyzitF0p3KKOq+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7347
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTAyLTEzIGF0IDIzOjIyICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBNb24sIDIwMjMtMDItMTMgYXQgMTQ6MzkgLTA4MDAsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiA+
IE9uIDIvMTMvMjMgMDM6NTksIEthaSBIdWFuZyB3cm90ZToNCj4gPiA+IFNFQU1DQUxMIGluc3Ry
dWN0aW9uIGNhdXNlcyAjR1Agd2hlbiBURFggaXNuJ3QgQklPUyBlbmFibGVkLCBhbmQgI1VEDQo+
ID4gPiB3aGVuIENQVSBpcyBub3QgaW4gVk1YIG9wZXJhdGlvbi4gIFRoZSBjdXJyZW50IFREWF9N
T0RVTEVfQ0FMTCBtYWNybw0KPiA+ID4gZG9lc24ndCBoYW5kbGUgYW55IG9mIHRoZW0uICBUaGVy
ZSdzIG5vIHdheSB0byBjaGVjayB3aGV0aGVyIHRoZSBDUFUgaXMNCj4gPiA+IGluIFZNWCBvcGVy
YXRpb24gb3Igbm90Lg0KPiA+IA0KPiA+IFJlYWxseT8gIC4uLiAqUkVBTExZKj8NCj4gPiANCj4g
PiBMaWtlLCB0aGVyZSdzIG5vIHBvc3NpYmxlIHdheSBmb3IgdGhlIGtlcm5lbCB0byByZWNvcmQg
d2hldGhlciBpdCBoYXMNCj4gPiBleGVjdXRlZCBWTVhPTiBvciBub3Q/DQo+ID4gDQo+ID4gSSB0
aGluayB3aGF0IHlvdSdyZSBzYXlpbmcgaGVyZSBpcyB0aGF0IHRoZXJlJ3Mgbm8gYXJjaGl0ZWN0
dXJhbGx5DQo+ID4gdmlzaWJsZSBmbGFnIHRoYXQgdGVsbHMgeW91IHdoZXRoZXIgaW4gc3BvdCAj
MSBvciAjMiBpbiB0aGUgZm9sbG93aW5nIGNvZGU6DQo+ID4gDQo+ID4gc3RhdGljIGludCBrdm1f
Y3B1X3ZteG9uKHU2NCB2bXhvbl9wb2ludGVyKQ0KPiA+IHsNCj4gPiAgICAgICAgIHU2NCBtc3I7
DQo+ID4gDQo+ID4gICAgICAgICBjcjRfc2V0X2JpdHMoWDg2X0NSNF9WTVhFKTsNCj4gPiAvLyBz
cG90ICMxDQo+ID4gICAgICAgICBhc21fdm9sYXRpbGVfZ290bygiMTogdm14b24gJVt2bXhvbl9w
b2ludGVyXVxuXHQiDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICBfQVNNX0VYVEFCTEUo
MWIsICVsW2ZhdWx0XSkNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgIDogOiBbdm14b25f
cG9pbnRlcl0gIm0iKHZteG9uX3BvaW50ZXIpDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAg
ICA6IDogZmF1bHQpOw0KPiA+IC8vIHNwb3QgIzINCj4gPiANCj4gDQo+IFllcyBJIHdhcyB0YWxr
aW5nIGFib3V0IGFyY2hpdGVjdHVyYWwgZmxhZyByYXRoZXIgdGhhbiBrZXJuZWwgZGVmaW5lZCBz
b2Z0d2FyZQ0KPiB0cmFja2luZyBtZWNoYW5pc20uDQo+IA0KPiA+IFRoYXQncyBfbWF5YmVfIHRl
Y2huaWNhbGx5IGNvcnJlY3QgKEkgZG9uJ3Qga25vdyBlbm91Z2ggYWJvdXQgVk1YDQo+ID4gZW5h
YmxpbmcgdG8gdGVsbCB5b3UpLiAgQnV0LCB3aGF0IEkgKkRPKiBrbm93IGlzIHRoYXQgaXQncyBu
b25zZW5zZSB0bw0KPiA+IHNheSB0aGF0IGl0J3MgaW1wb3NzaWJsZSBpbiB0aGUgKmtlcm5lbCog
dG8gdGVsbCB3aGV0aGVyIHdlJ3JlIG9uIGEgQ1BVDQo+ID4gdGhhdCdzIHN1Y2Nlc3NmdWxseSBl
eGVjdXRlZCBWTVhPTiBvciBub3QuDQo+ID4gDQo+ID4ga3ZtX2NwdV92bXhvbigpIGhhcyB0d28g
cGF0aHMgdGhyb3VnaCBpdDoNCj4gPiANCj4gPiAgIDEuIFN1Y2Nlc3NmdWxseSBleGVjdXRlcyBW
TVhPTiBhbmQgbGVhdmVzIHdpdGggWDg2X0NSNF9WTVhFPTENCj4gPiAgIDIuIEZhaWxzIFZNWE9O
IGFuZCBsZWF2ZXMgd2l0aCBYODZfQ1I0X1ZNWEU9MA0KPiA+IA0KPiA+IEd1ZXNzIHdoYXQ/ICBD
UjQgaXMgcmF0aGVyIGFyY2hpdGVjdHVyYWxseSB2aXNpYmxlLiAgRnJvbSB3aGF0IEkgY2FuDQo+
ID4gdGVsbCwgaXQncyAqRU5USVJFTFkqIHBsYXVzaWJsZSB0byBhc3N1bWUgdGhhdCBYODZfQ1I0
X1ZNWEU9PTEgbWVhbnMNCj4gPiB0aGF0IFZNWE9OIGhhcyBiZWVuIGRvbmUuIMKgDQo+ID4gDQo+
IA0KPiBZZXMgQ1I0LlZNWEUgYml0IGNhbiBiZSB1c2VkIHRvIGNoZWNrLiAgVGhpcyBpcyB3aGF0
IEtWTSBkb2VzLg0KPiANCj4gQXJjaGl0ZWN0dXJhbGx5IENSNC5WTVhFIGJpdCBvbmx5IGNoZWNr
cyB3aGV0aGVyIFZNWCBpcyBlbmFibGVkLCBidXQgbm90ICBWTVhPTg0KPiBoYXMgYmVlbiBkb25l
LCBidXQgaW4gY3VycmVudCBrZXJuZWwgaW1wbGVtZW50IHRoZXkgYXJlIGFsd2F5cyBkb25lIHRv
Z2V0aGVyLsKgDQo+IA0KPiBTbyBjaGVja2luZyBDUjQgaXMgZmluZS4NCj4gDQo+ID4gRXZlbiBp
ZiB0aGF0J3Mgd3JvbmcsIGl0J3Mgb25seSBhIGNwdW1hc2sgYW5kDQo+ID4gYSBjcHVtYXNrX3Nl
dCgpIGF3YXkgZnJvbSBiZWNvbWluZyBwbGF1c2libGUuICBMaWtlIHNvOg0KPiA+IA0KPiA+IHN0
YXRpYyBpbnQga3ZtX2NwdV92bXhvbih1NjQgdm14b25fcG9pbnRlcikNCj4gPiB7DQo+ID4gICAg
ICAgICB1NjQgbXNyOw0KPiA+IA0KPiA+ICAgICAgICAgY3I0X3NldF9iaXRzKFg4Nl9DUjRfVk1Y
RSk7DQo+ID4gDQo+ID4gICAgICAgICBhc21fdm9sYXRpbGVfZ290bygiMTogdm14b24gJVt2bXhv
bl9wb2ludGVyXVxuXHQiDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICBfQVNNX0VYVEFC
TEUoMWIsICVsW2ZhdWx0XSkNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgIDogOiBbdm14
b25fcG9pbnRlcl0gIm0iKHZteG9uX3BvaW50ZXIpDQo+ID4gICAgICAgICAgICAgICAgICAgICAg
ICAgICA6IDogZmF1bHQpOw0KPiA+IAkvLyBzZXQgY3B1bWFzayBiaXQgaGVyZQ0KPiA+ICAgICAg
ICAgcmV0dXJuIDA7DQo+ID4gDQo+ID4gZmF1bHQ6DQo+ID4gCS8vIGNsZWFyIGNwdSBiaXQgaGVy
ZQ0KPiA+ICAgICAgICAgY3I0X2NsZWFyX2JpdHMoWDg2X0NSNF9WTVhFKTsNCj4gPiANCj4gPiAg
ICAgICAgIHJldHVybiAtRUZBVUxUOw0KPiA+IH0NCj4gPiANCj4gPiBIb3cgbWFueSBkZXNpZ24g
ZGVjaXNpb25zIGRvd24gdGhlIGxpbmUgaW4gdGhpcyBzZXJpZXMgd2VyZSBwcmVkaWNhdGVkDQo+
ID4gb24gdGhlIGlkZWEgdGhhdDoNCj4gPiANCj4gPiAJVGhlcmUncyBubyB3YXkgdG8gY2hlY2sg
d2hldGhlciB0aGUgQ1BVIGlzDQo+ID4gCWluIFZNWCBvcGVyYXRpb24gb3Igbm90Lg0KPiA+IA0K
PiA+ID8NCj4gDQo+IE9ubHkgdGhlIGFzc2VtYmx5IGNvZGUgdG8gaGFuZGxlIFREWF9TRUFNQ0FM
TF9VRCBpbiB0aGlzIHBhdGNoIGlzLsKgwqANCj4gDQo+IFdoZXRoZXIgd2UgaGF2ZSBkZWZpbml0
aXZlIHdheSB0byBfY2hlY2tfIHdoZXRoZXIgVk1YT04gaGFzIGJlZW4gZG9uZSBkb2Vzbid0DQo+
IG1hdHRlci4gIFdoYXQgaW1wYWN0cyB0aGUgZGVzaWduIGRlY2lzaW9ucyBpcyAobm9uLUtWTSkg
a2VybmVsIGRvZXNuJ3Qgc3VwcG9ydA0KPiBkb2luZyBWTVhPTiBhbmQgd2UgZGVwZW5kIG9uIEtW
TSB0byBkbyB0aGF0ICh3aGljaCBpcyBhbHNvIGEgZGVzaWduIGRlY2lzaW9uKS4NCj4gDQo+IFdl
IGNhbiByZW1vdmUgdGhlIGFzc2VtYmx5IGNvZGUgd2hpY2ggcmV0dXJucyBURFhfU0VBTUNBTExf
e1VEfEdQfSBhbmQgcmVwbGFjZQ0KPiBpdCB3aXRoIGEgYmVsb3cgY2hlY2sgaW4gc2VhbWNhbGwo
KToNCj4gDQo+IAlzdGF0aWMgaW50IHNlYW1jYWxsKC4uLikNCj4gCXsNCj4gCQljcHUgPSBnZXRf
Y3B1KCk7DQo+IA0KPiAJCWlmIChjcjRfcmVhZF9zaGFkb3coKSAmIFg4Nl9DUjRfVk1YRSkgew0K
PiAJCQlXQVJOX09OQ0UoIlZNWE9OIGlzbid0IGRvbmUgZm9yIGNwdSAuLi5cbiIpOw0KPiAJCQly
ZXQgPSAtRUlOVkFMOw0KPiAJCX0NCj4gCQ0KPiAJCS4uLg0KPiANCj4gCW91dDoNCj4gCQlwdXRf
Y3B1KCk7DQo+IAkJcmV0dXJuIHJldDsNCj4gCX0NCj4gDQo+IEJ1dCB0aGlzIHdhcyBhY3R1YWxs
eSBkaXNjdXNzZWQgaW4gdGhlIHY1LCBpbiB3aGljaCBJSVVDIHlvdSBwcmVmZXIgdG8gaGF2aW5n
DQo+IHRoZSBhc3NlbWJseSBjb2RlIHRvIHJldHVybiBhZGRpdGlvbmFsIFREWF9TRUFNQ0FMTF9V
RCByYXRoZXIgdGhhbiBoYXZpbmcgYWJvdmUNCj4gQ1I0IGNoZWNrOg0KPiANCj4gaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvYWxsLzc3YzkwMDc1LTc5ZDQtN2NjNy1mMjY2LTFiNjdlNTg2NTEzYkBp
bnRlbC5jb20vDQo+IA0KPiANCg0KSG1tIEkgcmVwbGllZCB0b28gcXVpY2tseS4gIElmIHdlIG5l
ZWQgdG8gY29uc2lkZXIgb3RoZXIgbm9uLUtWTSBrZXJuZWwNCmNvbXBvbmVudHMgbWlzdGFrZW5s
eSBjYWxsIHRkeF9lbmFibGUoKSB3L28gZG9pbmcgVk1YT04gb24gYWxsIG9ubGluZSBjcHVzDQpm
aXJzdCwgdGhlcmUncyBvbmUgaXNzdWUgd2hlbiB1c2luZyBDUjQuVk1YRSB0byBjaGVjayB3aGV0
aGVyIFZNWE9OIGhhcyBiZWVuDQpkb25lIChvciBldmVuIHdoZXRoZXIgVk1YIGhhcyBiZWVuIGVu
YWJsZWQpIGluIG15IGFib3ZlIHBzZXVkbyBzZWFtY2FsbCgpDQppbXBsZW1lbnRhdGlvbi4NCg0K
VGhlIHByb2JsZW0gaXMgYWJvdmUgc2VhbWNhbGwoKSBjb2RlIGlzbid0IElSUSBzYWZlIGJldHdl
ZW4gQ1I0LlZNWEUgY2hlY2sgYW5kDQp0aGUgYWN0dWFsIFNFQU1DQUxMLg0KDQpLVk0gZG9lcyBW
TVhPTi9WTVhPRkYgZm9yIGFsbCBvbmxpbmUgY3B1cyB2aWEgSVBJOg0KDQoJLy8gd2hlbiBmaXJz
dCBWTSBpcyBjcmVhdGVkDQoJb25fZWFjaF9jcHUoaGFyZHdhcmVfZW5hYmxlLCBOVUxMLCAxKTsN
Cg0KCS8vIHdoZW4gbGFzdCAgVk0gaXMgZGVzdHJveWVkDQoJb25fZWFjaF9jcHUoaGFyZHdhcmVf
ZGlzYWJsZSwgTlVMTCwgMSk7DQoNCkNvbnNpZGVyIHRoaXMgY2FzZToNCg0KCTEpIEtWTSBkb2Vz
IFZNWE9OIGZvciBhbGwgb25saW5lIGNwdXMgKGEgVk0gY3JlYXRlZCkNCgkyKSBBbm90aGVyIGtl
cm5lbCBjb21wb25lbnQgaXMgY2FsbGluZyB0ZHhfZW5hYmxlKCkNCgkzKSBLVk0gZG9lcyBWTVhP
RkYgZm9yIGFsbCBvbmxpbmUgY3B1cyAobGFzdCBWTSBpcyBkZXN0cm95ZWQpDQoNCldoZW4gMikg
YW5kIDMpIGhhcHBlbiBpbiBwYXJhbGxlbCBvbiBkaWZmZXJlbnQgY3B1cywgYmVsb3cgcmFjZSBj
YW4gaGFwcGVuOg0KDQoJQ1BVIDAgKENSNC5WTVhFIGVuYWJsZWQpCQlDUFUgMSAoQ1I0LlZNWEUg
ZW5hYmxlZCkNCg0KCW5vbi1LVk0gdGhyZWFkIGNhbGxpbmcgc2VhbWNhbGwoKQlLVk0gdGhyZWFk
IGRvaW5nIFZNWE9GRiB2aWEgSVBJDQoNCglDaGVjayBDUjQuVk1YRQk8LSBwYXNzCQkJDQoJCQkJ
CQlvbl9lYWNoX2NwdShoYXJkd2FyZV9kaXNhYmxlKQ0KDQoJCQkJCQlzZW5kIElQSSB0byBDUFUg
MCB0byBkbyBWTVhPRkYNCgkJCQkJCTwtLS0tLS0tDQoJCS8vIEludGVycnVwdGVkDQoJCS8vIElS
USBoYW5kbGVyIHRvIGRvIFZNWE9GRg0KCQkNCgkJVk1YT0ZGwqANCgkJY2xlYXIgQ1I0LlZNWEUN
Cg0KCQkvLyBJUlEgZG9uZS4NCgkJLy8gUmVzdW1lIHRvIHNlYW1jYWxsKCkNCgkNCglTRUFNQ0FM
TCA8LS0gI1VEDQoJDQpTbyB3ZSBkbyBuZWVkIHRvIGhhbmRsZSAjVUQgaW4gdGhlIGFzc2VtYmx5
IGlmIHdlIHdhbnQgdGR4X2VuYWJsZSgpIHRvIGJlIHNhZmUNCmluIGdlbmVyYWwgKGRvZXNuJ3Qg
Y2F1c2UgT29wcyBldmVuIG1pc3Rha2VubHkgdXNlZCBvdXQgb2YgS1ZNKS4NCg0KSG93ZXZlciwg
aW4gVERYIENQVSBvbmxpbmUgY2FsbGJhY2ssIGNoZWNraW5nIENSNC5WTVhFIHRvIGtub3cgd2hl
dGhlciBWTVhPTiBoYXMNCmJlZW4gZG9uZSBpcyBmaW5lLCBzaW5jZSBLVk0gd2lsbCBuZXZlciBz
ZW5kIElQSSB0byB0aG9zZSAidG8tYmUtb25saW5lIiBjcHVzLg0K
