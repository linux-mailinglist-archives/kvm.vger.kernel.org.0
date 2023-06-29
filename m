Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7277741D77
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 03:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbjF2BDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 21:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjF2BDe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 21:03:34 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36B62689;
        Wed, 28 Jun 2023 18:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688000613; x=1719536613;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8mka07HEVq7hssEufeHSQN38RtMWWuo9yPmomgJ4NSc=;
  b=Ta3+QOPYWmywGWuMglE+bbBv63Rd0cVNERhZOExN20AbSYnYx/CkJtpt
   FfUTxTnXHjiILrSiVbTJOeLJyWdtK5y18YuOtsR7U7t9UdnI8oHceTwdK
   GQlszA8+Ulda0SINZ4PikxAlqWSrKUlKTJMfaY+M/do10SjkZpyPgxf06
   frcfAllOfdpTs38Axkx7Yk2hBAhLEDUu7tEQf/A8jLP1AOIb6n4kiNdeA
   lvviqj7bJKKSBm0hhySMeU/3oBmB7ymhDWsIFXJDCq6bHpRECOjVNuVUQ
   isKI/rRe/07T/pd+XGsRRW8wXRYqCfFoPYAk24V0e359AwObUKyHUDua2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="448382442"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="448382442"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 18:03:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="807134280"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="807134280"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jun 2023 18:03:32 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 18:03:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 18:03:32 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 18:03:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WLKDcmgBllZwwqAqyatscVeABsclkBmMKtA6siQctWZnv0sbdn59WF7DvyKsIQwRZi9iA+fxTrV4DrdeCfQU8sS6XQroRHS89lzKReg7VZCZr9Fb4XI1U6gIn70sJcU5C2djurkGmpZIymCtmURxjODOa07c/qQRNugS2MzyoidTjVtAv4aiErS5ijr7QypA93BQCSKH4ZTCSC4rcPcRfDsAoeVtXlgojni54v1GwAt3EU5fkRlU8lV6NX7lcaghf9UP87u9ETno5FUBsssBsT7QKeH7ftxQnI+egHRwdsZ21+3oKUmoorwpmWp245lPELBeGieQ6xFi7C+e+JJzFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mka07HEVq7hssEufeHSQN38RtMWWuo9yPmomgJ4NSc=;
 b=YQQDJk7jdj6HQ7lS5oeP65BrNw7TnfQsT4W3Gd+kDV9YJMgp6ToGzNxwhC78L4J3L+t6k4uMbyjUw7PndnEfr6/JdYsaza89KSBXvwQ3ctpvxs4PSSiUvgEUQ9kMxuue/2IEbyzv5NvfQ7rO0QU4GfraV5u1T/Jewm8t8RRHLPjefMHmctwyoGJNjDl+Igchw2GfBuVGe+2sB1/oJCr66gwWvI70ZBh/er3HKYw46ubiexD0xL7x9g1KhQ2qdQQ1sOmqPTxZOm2cqb1Ob3ONxzjmusis3ca35mFds6QvZL1ZSdZQfrRbVhHvokZTlv8ILH1Cq1KW8XirSr6c5cshcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BN9PR11MB5257.namprd11.prod.outlook.com (2603:10b6:408:132::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Thu, 29 Jun
 2023 01:03:29 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 01:03:29 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v12 18/22] x86/virt/tdx: Keep TDMRs when module
 initialization is successful
Thread-Topic: [PATCH v12 18/22] x86/virt/tdx: Keep TDMRs when module
 initialization is successful
Thread-Index: AQHZqDW14KDLrEh31k6JezuLROG/lq+f7ryAgAELuoA=
Date:   Thu, 29 Jun 2023 01:03:29 +0000
Message-ID: <1473d34591bafdebb7a4736ac08a83f6c447acf6.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <7d06fe5fda0e330895c1c9043b881f3c2a2d4f3f.1687784645.git.kai.huang@intel.com>
         <b8ba66c0-ea3c-24ec-9966-e8438d7c5626@suse.com>
In-Reply-To: <b8ba66c0-ea3c-24ec-9966-e8438d7c5626@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BN9PR11MB5257:EE_
x-ms-office365-filtering-correlation-id: 10e51d75-084c-404d-0a80-08db783ca696
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mlMCCbkM6ZMtqKQS/txALbAM6wQgJzo9aCmAU32OGveGLgtaj+X8VoecB4oRxhbJNxC7AWP2KYcX5Y26y3dKbxZglfagh/YicdmFTZXUW2FzojaCF6Q0f9dGZRXC7Q33JGXbtPZ6uvbDOF19EyAH3yh0QVfsthWkLZ7ha7dE1EMIBaN3r9kR+O+ifetOBCDUaRyN/tMD6H7ZBLQKNIGI+RQdEziJDEq1qPJfOfXR4NWh8KentXoJAARrblkUL8c5alOuMMeNh8ZKpdd0XNhcWefr3ubtTlggvNTftIQs4SL/S9+2rO3Wl1o4qihwI8OYUslmMPX7tbIslsGwaciFK0+ziYts+qR262APcjLfHkTRU7nTZG4gxvoOgTLKnZeCM9E0jsEYYYPvlKQzg7V34mbMRqtayZQfksbhJZxswnUKjAKkiOpaLq+99s66hqq/uu3XNx295+LBJTeQgONGmE8bSeLeeRIPJtr9C0HVYrDQl8MAhkU1rlhNGHysVcYdp+IFhTyzj4HSwomj3YhHbzskv3yax/OcssLOKlPCKnC3huX+f5imKwZiXXHuAXph91d3g///+9FJWiQMlHlwHtNXcvCm/tW13B1zABSkLDkGLAEF19QnydzZOArM/Irn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(376002)(346002)(136003)(366004)(451199021)(5660300002)(66476007)(26005)(2906002)(186003)(71200400001)(38070700005)(38100700002)(122000001)(2616005)(6506007)(6512007)(8936002)(83380400001)(66446008)(41300700001)(66946007)(91956017)(64756008)(66556008)(7416002)(36756003)(82960400001)(8676002)(6486002)(54906003)(86362001)(478600001)(4326008)(110136005)(316002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cENkQU9JdHh2UXhFZ1FjWDRQYmNkeW52WDV3bklodHMxc0NaV2s3N3k3OFgv?=
 =?utf-8?B?TnJhRGxneUl2V0VhcXgzRDU1S3VlenBpTUM0VUJOWms2Si9GcU5VcU81UHFx?=
 =?utf-8?B?eUxCME14RW41RWNRZVFMWnQxd1cvM1RCWG0wU3BFTVhGNmVuUE1SYURjbHVv?=
 =?utf-8?B?alBYQ0N3N3RyQ1FDeklETW5DWTZ4Smp0VmJOTWx0a3BobFd6MlZrRW5Uc0pz?=
 =?utf-8?B?WDJ5YVZET3RNeHJlUWpLRHdwTlNoZ3k2dVVpZkhKR1hzVUErbDlIUVRZcHRo?=
 =?utf-8?B?cCtWOHR1M3lUS1pmd2cvS1lnSlU5aDdMRHM2QkEzZEhtUjloQ05lUFhXSlJa?=
 =?utf-8?B?eXRlOXBUazQ3eDVjekc2NWswbGZ3bVBycTdsT0gzZ2Y1SHlMcUhjclBVK2RV?=
 =?utf-8?B?a1BIM1Rndis3TEpSc2FTbDNKUFp1SkVxMnRFbUg3VTEwdnNUS3F2eGNkbGo3?=
 =?utf-8?B?Ym10eVVYNnYyTk5Oa1IzbDdBM0xkcGl1dkpzc29TNUR2ck9QRk01cWx4TERy?=
 =?utf-8?B?dVhmQisvNktpVy9WbjNkRm53alNIcXBjTjJRS25qU0FXa2gwZ2l4M053dGJ4?=
 =?utf-8?B?RmIyZUhzekV3Tk4yeDlsRHl2OTdFamxIUGI2U24zeVQ4eFdzSm56Vkg5NGdr?=
 =?utf-8?B?c05INng3akFRR1VoYitKb01lVTBjMmZCSUR3YjZsTWRKSU93aG8zbHFrVDNI?=
 =?utf-8?B?b0puY3FQZVZiSnM4Mkxtay9xTk1jbGVvd2hhMmt2cVhyQWg3Vmc0VzNhSzIw?=
 =?utf-8?B?NXdDbm9IT1hXOGFNS3NzN3pVSGhMMnhvcVkxRk1nZEowdjRNbFdGek5JVjhQ?=
 =?utf-8?B?VzZsamxudjN6Y1M3dnpqYWhpSWdpM3g0RHNIeXhrNktYeTVtaENhY1crakh0?=
 =?utf-8?B?UXlTeWcxc3NEVHhXTkE0bzVRMUdCaUpXSVFXZTVtdGNVU1BSb2xHSkZmaTF4?=
 =?utf-8?B?b3BwMlpDMGVwYmNEMmc5a3VSRUVmSnRsdldkeHprY2FyR1k2bDNHanFCU0Rh?=
 =?utf-8?B?VWN0eFBKenhhczhyUHo0Wkg4SmN5WkdZVTROcXN1ek1rQ1J2ZTVMZ0VxT1gv?=
 =?utf-8?B?STg3YkY5UG1qMkk2c2xlZmNMWU96dmJYb0psT1pBNXpTQlQzSUgybjJqSWc1?=
 =?utf-8?B?cEk1WFpoVjdJd1BlYWZBVXZZWDU2YlFUY3hnR1ExeTl5QjQxcDZZYzIwVnk5?=
 =?utf-8?B?bkYwV1VGYTlxYUd3b2FEaFJMZTh1VGFzd0E3TCtHUTVjTkVLZmxvUG9ocWJn?=
 =?utf-8?B?bXgwZjVZbjRhenFSakNDK1RsZHJxRklwdE8wdGdYWG5kZDB3ZVZ1cytYSFJW?=
 =?utf-8?B?eXhBRkJERHFpeGlSMkZRb21xTVR0cW9VVVdqeHVneVNzU3gwdUl3UXZkVlNX?=
 =?utf-8?B?RWk2Wi9HZG5UNVFIVGRzKzRnNWc3TkVDS0pXcEVBK2ZhN1cxdFhyalJNSjVt?=
 =?utf-8?B?L1h1ZWZOQXZmclFnaXZzdDMxYWptb2loL2xkQ0xtQi9RVkJiQzFrUGMwaVo4?=
 =?utf-8?B?RkZjTXhhUDFoanVIWE1oRGJKQTJsZDBNTWJFb2ttT3N2eWU1Q3gyUU1UaXF4?=
 =?utf-8?B?L0F5cklFR3B5THZsV09GRXAwSlBVNnRycVBBS0pMNmtnQllNVFJPMzBwZ2ZU?=
 =?utf-8?B?Z3FZZ1FwcEVFWVVoSXJFdmw0SGRoV3NSN2Q4T0tGOEkrcndHVkhlWnl3akMv?=
 =?utf-8?B?WC94M0FHUTQ1UGo4aDNWUERSMjcvRVlHeS9TcWNSbGU0WURySk9XOUZ6aVp4?=
 =?utf-8?B?TS83V1VEUExZdlR6TStFUlpveHNqRi8zUzA5aUVKcVpRR1RxaC9xWTRlK0NT?=
 =?utf-8?B?SU16UlBrSDZCOVY3Wmh6ODUrbEYrVnNTSzNhMzFLYUlxYmFRajlaZXRKZVdB?=
 =?utf-8?B?TVAwZ1J1NytCVzRJZ1BIWTZBaXVYaGZETjRuQUdpZVM1SHRuaS8xZUtFdktx?=
 =?utf-8?B?aTFlV01pUUdZWU52WWJSdStEMzZ6TmNpT2I0NjNFK3BCZVkra3VwZU1GTFdI?=
 =?utf-8?B?aHVlNDdKa3ZUT2wzbUU2cXNKWE1GcFE2RFlFNWUwYmtxSGtsZnlCOThZT0ZZ?=
 =?utf-8?B?TitmVTh1UEU5VmxHWGxsWDJzSGtROWcxS1RpTWlrTWVNTkF4dVMvWnM2d1BN?=
 =?utf-8?B?YisyVDRybzM3TFBjVHNlRzI3dUQzUEFWMHFTbTVlb0JMdnJGcCs0M3hncjVG?=
 =?utf-8?B?ZkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CF88955D8E83A540A520AC4559148F24@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10e51d75-084c-404d-0a80-08db783ca696
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 01:03:29.1251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 79wcBmw/DsnK3srz0WTf6Whg/RlTjpRFBp1LJ2A8vrIQzgd8hgoFSqtUGfHOaT/lPsjr4kklydLpQqFlF5PFog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5257
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDEyOjA0ICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IA0KPiBPbiAyNi4wNi4yMyDQsy4gMTc6MTIg0YcuLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4g
T24gdGhlIHBsYXRmb3JtcyB3aXRoIHRoZSAicGFydGlhbCB3cml0ZSBtYWNoaW5lIGNoZWNrIiBl
cnJhdHVtLCB0aGUNCj4gPiBrZXhlYygpIG5lZWRzIHRvIGNvbnZlcnQgYWxsIFREWCBwcml2YXRl
IHBhZ2VzIGJhY2sgdG8gbm9ybWFsIGJlZm9yZQ0KPiA+IGJvb3RpbmcgdG8gdGhlIG5ldyBrZXJu
ZWwuICBPdGhlcndpc2UsIHRoZSBuZXcga2VybmVsIG1heSBnZXQgdW5leHBlY3RlZA0KPiA+IG1h
Y2hpbmUgY2hlY2suDQo+ID4gDQo+ID4gVGhlcmUncyBubyBleGlzdGluZyBpbmZyYXN0cnVjdHVy
ZSB0byB0cmFjayBURFggcHJpdmF0ZSBwYWdlcy4gIENoYW5nZQ0KPiA+IHRvIGtlZXAgVERNUnMg
d2hlbiBtb2R1bGUgaW5pdGlhbGl6YXRpb24gaXMgc3VjY2Vzc2Z1bCBzbyB0aGF0IHRoZXkgY2Fu
DQo+ID4gYmUgdXNlZCB0byBmaW5kIFBBTVRzLg0KPiA+IA0KPiA+IFdpdGggdGhpcyBjaGFuZ2Us
IG9ubHkgcHV0X29ubGluZV9tZW1zKCkgYW5kIGZyZWVpbmcgdGhlIGJ1ZmZlciBvZiB0aGUNCj4g
PiBURFNZU0lORk9fU1RSVUNUIGFuZCBDTVIgYXJyYXkgc3RpbGwgbmVlZCB0byBiZSBkb25lIGV2
ZW4gd2hlbiBtb2R1bGUNCj4gPiBpbml0aWFsaXphdGlvbiBpcyBzdWNjZXNzZnVsLiAgQWRqdXN0
IHRoZSBlcnJvciBoYW5kbGluZyB0byBleHBsaWNpdGx5DQo+ID4gZG8gdGhlbSB3aGVuIG1vZHVs
ZSBpbml0aWFsaXphdGlvbiBpcyBzdWNjZXNzZnVsIGFuZCB1bmNvbmRpdGlvbmFsbHkNCj4gPiBj
bGVhbiB1cCB0aGUgcmVzdCB3aGVuIGluaXRpYWxpemF0aW9uIGZhaWxzLg0KPiA+IA0KPiA+IFNp
Z25lZC1vZmYtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gPiAtLS0NCj4g
PiANCj4gPiB2MTEgLT4gdjEyIChuZXcgcGF0Y2gpOg0KPiA+ICAgIC0gRGVmZXIga2VlcGluZyBU
RE1ScyBsb2dpYyB0byB0aGlzIHBhdGNoIGZvciBiZXR0ZXIgcmV2aWV3DQo+ID4gICAgLSBJbXBy
b3ZlZCBlcnJvciBoYW5kbGluZyBsb2dpYyAoTmlrb2xheS9LaXJpbGwgaW4gcGF0Y2ggMTUpDQo+
ID4gDQo+ID4gLS0tDQo+ID4gICBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgfCA4NCArKysr
KysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gICAxIGZpbGUgY2hhbmdlZCwg
NDIgaW5zZXJ0aW9ucygrKSwgNDIgZGVsZXRpb25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHgu
Yw0KPiA+IGluZGV4IDUyYjcyNjdlYTIyNi4uODViMjRiMmU5NDE3IDEwMDY0NA0KPiA+IC0tLSBh
L2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHguYw0KPiA+IEBAIC00OSw2ICs0OSw4IEBAIHN0YXRpYyBERUZJTkVfTVVURVgodGR4
X21vZHVsZV9sb2NrKTsNCj4gPiAgIC8qIEFsbCBURFgtdXNhYmxlIG1lbW9yeSByZWdpb25zLiAg
UHJvdGVjdGVkIGJ5IG1lbV9ob3RwbHVnX2xvY2suICovDQo+ID4gICBzdGF0aWMgTElTVF9IRUFE
KHRkeF9tZW1saXN0KTsNCj4gPiAgIA0KPiA+ICtzdGF0aWMgc3RydWN0IHRkbXJfaW5mb19saXN0
IHRkeF90ZG1yX2xpc3Q7DQo+ID4gKw0KPiA+ICAgLyoNCj4gPiAgICAqIFdyYXBwZXIgb2YgX19z
ZWFtY2FsbCgpIHRvIGNvbnZlcnQgU0VBTUNBTEwgbGVhZiBmdW5jdGlvbiBlcnJvciBjb2RlDQo+
ID4gICAgKiB0byBrZXJuZWwgZXJyb3IgY29kZS4gIEBzZWFtY2FsbF9yZXQgYW5kIEBvdXQgY29u
dGFpbiB0aGUgU0VBTUNBTEwNCj4gPiBAQCAtMTA0Nyw3ICsxMDQ5LDYgQEAgc3RhdGljIGludCBp
bml0X3RkbXJzKHN0cnVjdCB0ZG1yX2luZm9fbGlzdCAqdGRtcl9saXN0KQ0KPiA+ICAgc3RhdGlj
IGludCBpbml0X3RkeF9tb2R1bGUodm9pZCkNCj4gPiAgIHsNCj4gPiAgIAlzdHJ1Y3QgdGRzeXNp
bmZvX3N0cnVjdCAqc3lzaW5mbzsNCj4gPiAtCXN0cnVjdCB0ZG1yX2luZm9fbGlzdCB0ZG1yX2xp
c3Q7DQo+ID4gICAJc3RydWN0IGNtcl9pbmZvICpjbXJfYXJyYXk7DQo+ID4gICAJaW50IHJldDsN
Cj4gPiAgIA0KPiA+IEBAIC0xMDg4LDE3ICsxMDg5LDE3IEBAIHN0YXRpYyBpbnQgaW5pdF90ZHhf
bW9kdWxlKHZvaWQpDQo+ID4gICAJCWdvdG8gb3V0X3B1dF90ZHhtZW07DQo+ID4gICANCj4gPiAg
IAkvKiBBbGxvY2F0ZSBlbm91Z2ggc3BhY2UgZm9yIGNvbnN0cnVjdGluZyBURE1ScyAqLw0KPiA+
IC0JcmV0ID0gYWxsb2NfdGRtcl9saXN0KCZ0ZG1yX2xpc3QsIHN5c2luZm8pOw0KPiA+ICsJcmV0
ID0gYWxsb2NfdGRtcl9saXN0KCZ0ZHhfdGRtcl9saXN0LCBzeXNpbmZvKTsNCj4gPiAgIAlpZiAo
cmV0KQ0KPiA+ICAgCQlnb3RvIG91dF9mcmVlX3RkeG1lbTsNCj4gPiAgIA0KPiA+ICAgCS8qIENv
dmVyIGFsbCBURFgtdXNhYmxlIG1lbW9yeSByZWdpb25zIGluIFRETVJzICovDQo+ID4gLQlyZXQg
PSBjb25zdHJ1Y3RfdGRtcnMoJnRkeF9tZW1saXN0LCAmdGRtcl9saXN0LCBzeXNpbmZvKTsNCj4g
PiArCXJldCA9IGNvbnN0cnVjdF90ZG1ycygmdGR4X21lbWxpc3QsICZ0ZHhfdGRtcl9saXN0LCBz
eXNpbmZvKTsNCj4gDQo+IG5pdDogRG9lcyBpdCBtYWtlIHNlbnNlIHRvIGtlZXAgcGFzc2luZyB0
aG9zZSBnbG9iYWwgdmFyaWFibGVzIGFyZSANCj4gZnVuY3Rpb24gcGFyYW1ldGVycz8gU2luY2Ug
dGhvc2UgZnVuY3Rpb25zIGFyZSBzdGF0aWMgaXQncyB1bmxpa2VseSB0aGF0IA0KPiB0aGV5IGFy
ZSBnb2luZyB0byBiZSB1c2VkIHdpdGggYW55IG90aGVyIHBhcmFtZXRlciBzbyBtaWdodCBhcyB3
ZWxsIHVzZSANCj4gdGhlIHBhcmFtZXRlciBkaXJlY3RseS4gSXQgbWFrZXMgdGhlIGNvZGUgc29t
ZXdoYXQgZWFzaWVyIHRvIGZvbGxvdy4NCj4gDQoNCkkgZGlzYWdyZWUuICBUbyBtZSBwYXNzaW5n
ICdzdHJ1Y3QgdGR4X3RkbXJfaW5mbyAqdGRtcl9saXN0JyB0bw0KY29uc3RydWN0X3RkbXJzKCkg
YXMgcGFyYW1ldGVyIG1ha2VzIHRoaXMgZnVuY3Rpb24gY2xlYXJlcjoNCg0KSXQgdGFrZXMgYWxs
IFREWCBtZW1vcnkgYmxvY2tzIGFuZCBzeXNpbmZvLCBnZW5lcmF0ZXMgdGhlIFRETVJzLCBhbmQg
c3RvcmVzIHRoZW0NCnRvIHRoZSBidWZmZXIgc3BlY2lmaWVkIGluIHRoZSB0ZG1yX2xpc3QuICBU
aGUgaW50ZXJuYWwgbG9naWMgZG9lc24ndCBuZWVkIHRvDQpjYXJlIHdoZXRoZXIgYW55IG9mIG9m
IHRob3NlIHBhcmFtZXRlcnMgYXJlIHN0YXRpYyBvciBub3QuIA0K
