Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E4D741CDF
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 02:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjF2AYU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 20:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjF2AYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 20:24:18 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27421BC8;
        Wed, 28 Jun 2023 17:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687998257; x=1719534257;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Oeu3tgYHsSKbkE8rUHHZTUBJHrQrl02uk3yxkr6CLzI=;
  b=nCMag781FItTeGuct2Lb1dVG/8/jis7oy4n4uvXDLN6gcvad9uLhEgmn
   qG57Z4MYBZiExn5oAsuXM9JCk4RI1+1Ay1MhMqhydfUJjKzNnwfUeMTwv
   39CHgNnDmdcwcB9eHaYn0i4QkGek3NskEIOzqBqf7NDm7UOWzR2x0DAGo
   7Htj0SE9wKVzU9IA75gj17LPuuGxKJZ3tILoehwqXtqq7KHuWHCBJ5Uc1
   txlvMlFUHCwll8gQAmYP7zTNxcZ7IsyHsuLbJgxY9Nv5auxWPsZ0Z8o1N
   E3ZFZprSZOf/dbYwhYHWjjyzerBld8CbXXtxQt6rF2cUaE2SghTvtwQwe
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="428008963"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="428008963"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 17:24:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="1047593021"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="1047593021"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jun 2023 17:24:16 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 17:24:15 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 17:24:15 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 17:24:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LPjqlw8vOKd3yzu1ggdD9Evxy+QN5sqWUhFeY/MLXlP8bQkNEPQvejha/v62gdJO1SEYCw8NeBwXEZjcDw7wOKlb80XStqRdfwyg73WqeyrDWfl+jSvugo3jNh3mruNYc0z+881ErF9RwGSCMZInPPoJNSe2iLrd99LRaIkMq42uHBH5kxr6sUaip4PniiFOlVMxRvLi2vytBIVAcUUOWIx9ExMJbGXH0RtR8D5vjm8jA26vZDzxOqfdKa3AovEprlkdgUDlaBjOMfmttv1hbhwfTCVHa7KhckoDqtMkOgDm2pWShseHCVRtH/SKH6y0tKXndP5rU/LcizntnYHLXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oeu3tgYHsSKbkE8rUHHZTUBJHrQrl02uk3yxkr6CLzI=;
 b=Ke72SUhVVsnTOdlP+kI3WxehGBRRszLJ1luPX+xRrfEqVQ4YYhpeUftzLWZxUTGsrVVHfl8neBafgXGq/mDfeOGL+yep1ZrGYJfXRUDOULFRHQZcm6A3pQnXBXxJFM0oixzSfl0/jEbLKBrhKMKZDFzubCdFCyXSqaV3D/VkkxH6EPGukbuQnDDGCh3c9pZZs1mkA24u4X98zeY5Z9L3lYSxBTwPt1CNVR+7DbtPQPOj/3+tRP+y3VdbTfLrIBbUZEca2nyC4mi0GPZVRVhkvzgmMX+yRbve9XMDrg+wp4uRyvWa/BTHh8R/0+DTkxKacWxdFy1gdcP14sFATdjYFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6806.namprd11.prod.outlook.com (2603:10b6:806:24d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Thu, 29 Jun
 2023 00:24:13 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 00:24:13 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Thread-Index: AQHZqDW14KDLrEh31k6JezuLROG/lq+gJlQAgAAG3ICAAMJuAA==
Date:   Thu, 29 Jun 2023 00:24:12 +0000
Message-ID: <d62ebdf971ef52fe38cfb0a5edb7566e9f6d7e14.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <7d06fe5fda0e330895c1c9043b881f3c2a2d4f3f.1687784645.git.kai.huang@intel.com>
         <20230628122342.zdnqsgnugalqj6ix@box.shutemov.name>
         <fd7e5b2b-57ca-efcb-9295-29dfb41cc061@suse.com>
In-Reply-To: <fd7e5b2b-57ca-efcb-9295-29dfb41cc061@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6806:EE_
x-ms-office365-filtering-correlation-id: ef77c47d-0aaf-42f7-0b78-08db783729cf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q7TPUxMlu0+muZ8JyCr9q2QkEJlDNOwj7p1wFzgvfrcLkXjknWcXjO3Bv/4bfnLHL8r3WumfMamLpHgrSa3oOXW68gZXUvXvDUDRe6ClCEyHbrcauVCEeR6BK4pjiKzw4m/V5qqsIf6sLHAV6I7ZMjBHUY48CzGZ9iuIhp0YEDoF5l0c8U15aD3B6/qexGVd9ZIEAR1W8hvCWbY0ds2jlw+eiCCgB8rFKPkikdsB5xOJqKpJTmkKTAMjCAIPxaNdnW75l6C/v1CNSbd/jU9j9c5u4a7UkJxjX+9zrtt6isU0XQ2+fXO7SLXODK+1mi+MS8fI9VGv+ySE1iXR4lSQlJst1zOgXLfueMxVmC3PAsfomhhVIfiEP8QqzzYChWwYtiSHPk4pwhfSBQ0FgX25JPwwFlAC7K9Q9rED2wGBIAWBXrs8h0/uF/EaujGKrIr+7RL5xVzovUFbvr3VfeHB/ccVKLzgDQ+8WMi13Aj7oKp6hvDFBwvzlSfC+V2MZxoOVgDlnpFUdX7p6bDuLBBaWPcnsomGsTWrO7VzJe2ycps7T43VXo1GRZpoY/CRH9lZcX8SFzFcjNVuctTtiItQSJQ6ft6SLubWTxBun/h9Y7VGFMco3I9nFPE/123zLQePigngtnEY+HrJ77pKnxg69g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(396003)(376002)(39860400002)(366004)(451199021)(66446008)(6512007)(38070700005)(4326008)(26005)(66556008)(66476007)(36756003)(122000001)(7416002)(66946007)(86362001)(41300700001)(8936002)(316002)(8676002)(82960400001)(5660300002)(91956017)(64756008)(38100700002)(76116006)(110136005)(6506007)(6486002)(186003)(2906002)(83380400001)(71200400001)(54906003)(478600001)(2616005)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ajkvTGp4c1dwKytNeTdBdDBVUU45dUE1b0hQcVovYktXQitINm9JVktURTRm?=
 =?utf-8?B?TVhrMlpqczFhWlBFSmZaNThJTnE3K0NLNlBYT3pQalRBbGkwREFaYzZxWllH?=
 =?utf-8?B?Z0hCUzBJVEtvb1phUTd4OFlET3NjVEZxcDVpS1NvWEIvRXQ4NDh1U3hVbFph?=
 =?utf-8?B?dXBhcE13YWRSUVcvWUhRMjRRbFp0M2lldmRjZUxZWGU1Q2hYWEVjU2FSamUv?=
 =?utf-8?B?Q2VBL3FhLzYxUERzL25lZ2xrWHgwb3MrZEVqN1pJbE9HOG91ZmdxdmRIOVZk?=
 =?utf-8?B?K0RWd1pEY3d2QXI0ckNjekZXTGFBaytBbWdVcUxwTjFRcTg0TmJFVFlaakx5?=
 =?utf-8?B?OHJCYkM5cHpVeUI0REpFZjdMVGJvdEx5dnhjaFZIWFdIMVdJS2txajBuVWFy?=
 =?utf-8?B?VmxZaVlQeEtyQ1o5QTgrdEp1cFBYbmw3WnBGVlNuMU83WnZEc0JBVkVGQXky?=
 =?utf-8?B?UGpuelcyUDFxWlJwdTdvK09FanArNTFXUU1XL3dOV0kyaFlEK1k3c25aajRE?=
 =?utf-8?B?b3ZIM3V6N2tLcnYrZFJGcWpFTHc2d3B5cjVRTlk1NXc0S2p2ZVNCNEkxNVVC?=
 =?utf-8?B?c0RLM3NXZ1FkYmZoM1U2TVJPbDRIcGV5WFJTdUhFUTgvRXlZZ0drQ01ISUhw?=
 =?utf-8?B?NVpYem1LK21pMlRtMzZNQU9Sakh4RkMwQTdBdVNXQy9vMGFLdTFMbUFzckgw?=
 =?utf-8?B?VDZNUjVmYTFvdXE5b2JqTGhUeFk0c3dEaldZeWMvaEdnN1ZrdjZFdG1WOURu?=
 =?utf-8?B?bHp3MDd2Z1JWVTNBWTFXUDd2UmIvZmpiMjhsY3hJandUR2loaVM3SVBvTWVQ?=
 =?utf-8?B?V1BoR211YjluY0Z5Mld0NGlweElXWllwTmUrRFMxVjVkUWVZbE00QVFXdlhQ?=
 =?utf-8?B?NGdmNG9EM2prbUcxeTY3eExJUHZlZngydTE5bXlKZStxZEVBWXN2cjRjdDJh?=
 =?utf-8?B?WXU2R2ZJTm1wTy9lUkFHUTNyZThCa3QxVnhpdVRTbjM1Q1lXbjBoU0c2Mktr?=
 =?utf-8?B?S2V4MCtRZGIyMnFZNDBsU2x4Ky8xZFAvY1lPVDRKcE02U21GYzBreFpwUTc4?=
 =?utf-8?B?Z2JCSE5tYUhzYWpLZ3p6YS9MWXU5TFpPQVc5WVJURklMRms3R2lWeUJtUTIz?=
 =?utf-8?B?dmEvWFFqMFZDMklValMxWW1OTExOb0FzU2JsRTFlUEVSYU1BSEk3ZDcvVW5w?=
 =?utf-8?B?b2pPRHFqbVFvMDhRZlc1alByUlpYS0g2R3R6QXFMbjF1RUs5RUgrQTdMNGFN?=
 =?utf-8?B?ZS9zVDNFSno4V0ZNazFUOTdEaFNpaU9HUHlCU3d6bk5iakVrWkFnS1lwL2d1?=
 =?utf-8?B?V3VySFlMWWxEdmhRRU9PMlFuWmdML2Y5MWZ2Wno1TUM5bjdNNnN0dGlHeENH?=
 =?utf-8?B?cXhPK3YwMFFERXNlUWZWNmJzSWo1SXpIRG0yYkZnRlI1d3ViYzVwRU9CMUh1?=
 =?utf-8?B?c0JsL3pXclMxNGhXTXJDdDE1TnFNNlhwMG0wbkVNTE15MlM1ZVhpbEVTa1FZ?=
 =?utf-8?B?RDA5UmZ2NlBFUUJKeTNHVVZTUW1Mb3BtMG1OOHBrZGZDeWQ5VnlmQk81dlJG?=
 =?utf-8?B?ZkpVd2xNUlB5ZWREQkhWRzlhZjN6T1F3aVNuWjE0V1Z4RHBnZktoYUc4RXk1?=
 =?utf-8?B?aFRyeVhFeVYvY2VHSGZnQ2pNYzl6elNETkNJUk8raWxvVHdjNUp0OWFNRVF6?=
 =?utf-8?B?VlpGNWdzUkpscXNLbWo4WnJjQW01L3ZtekR6YnJlMWc3QVlCdHhRWHdUV3B1?=
 =?utf-8?B?bk9lTnJ5KytmalN5LzA4bzJkcXdsY2pWOGpmMW1vOHBsUDNRUUU2Z1NMRTZQ?=
 =?utf-8?B?VmRucGJVQks0WlYwUmh4Qmk0L3ZDZElvMkJTSVI2bHFQZVRwL3NFdklkRFBX?=
 =?utf-8?B?WTgvaVVHRlZHVUVHOEF1cWt5ZHYvNTl5cU5OaElUUGQ5Y2RQZEwwVlFCV2hp?=
 =?utf-8?B?SjhVcnJnS2UzWDlEMFlVV2QvNG5DWFJaUUFicDVkUnN2SENxWHBKTmFpL3Zn?=
 =?utf-8?B?MUdhMHVRNnA0YVZ3MkxiU1NsVjBjQ1lybTBvdllVYTVhKzkya1d5TjV2ckVn?=
 =?utf-8?B?TVN1MXJKbitQT1Z4K0RFZmJvdk84OFMvY2xaNzhVcmtSRHhORHdQelpvRFhz?=
 =?utf-8?B?cTRJR00wTVBsRW9TcFRYbXF5VFJMK0MwUVZtNmNhbmY1NmJ5a3hrTzlEQzMy?=
 =?utf-8?B?VHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0BEDFCA80E0F14FABE3A024DCA3ACE7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef77c47d-0aaf-42f7-0b78-08db783729cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 00:24:12.2852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xq6vfxg1viesaMzLV/4k6dt1mMPUXw4bbbsOVrrIxX+hzOhjtfYULBNj+Y+5jcSrGS+/Rq+v0BQO+y3ZFv8qSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6806
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDE1OjQ4ICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+ID4gVGhpcyBkaWZmIGlzIGV4dHJlbWVseSBoYXJkIHRvIGZvbGxvdywgYnV0IEkgdGhpbmsg
dGhlIGNoYW5nZSB0byBlcnJvcg0KPiA+IGhhbmRsaW5nIE5pa29sYXkgcHJvcG9zZWQgaGFzIHRv
IGJlIGFwcGxpZWQgdG8gdGhlIGZ1bmN0aW9uIGZyb20gdGhlDQo+ID4gYmVnaW5uaW5nLCBub3Qg
Y2hhbmdlZCBkcmFzdGljYWxseSBpbiB0aGlzIHBhdGNoLg0KPiA+IA0KPiANCj4gDQo+IEkgYWdy
ZWUuIFRoYXQgY2hhbmdlIHNob3VsZCBiZSBicm9rZW4gYWNyb3NzIHRoZSB2YXJpb3VzIHBhdGNo
ZXMgDQo+IGludHJvZHVjaW5nIGVhY2ggcGllY2Ugb2YgZXJyb3IgaGFuZGxpbmcuDQoNCk5vIEkg
ZG9uJ3Qgd2FudCB0byBkbyB0aGlzLiAgVGhlIFRETVJzIGFyZSBvbmx5IG5lZWRlZCB0byBiZSBz
YXZlZCBpZiB3ZSB3YW50IHRvDQpkbyB0aGUgbmV4dCBwYXRjaCAocmVzZXQgVERYIG1lbW9yeSku
ICBUaGV5IGFyZSBhbHdheXMgZnJlZWQgaW4gcHJldmlvdXMgcGF0Y2guDQpXZSBjYW4gYWRkIGp1
c3RpZmljYXRpb24gdG8ga2VlcCBpbiBwcmV2aW91cyBwYXRjaCBidXQgSSBub3cgd2FudCB0byBh
dm9pZCBzdWNoDQpwYXR0ZXJuIGJlY2F1c2UgSSBub3cgYmVsaWV2ZSBpdCdzIG5vdCB0aGUgcmln
aHQgd2F5IHRvIG9yZ2FuaXplIHBhdGNoZXM6DQoNCk9idmlvdXNseSBzdWNoIGp1c3RpZmljYXRp
b24gZGVwZW5kcyBvbiB0aGUgbGF0ZXIgcGF0Y2guICBJbiBjYXNlIHRoZSBsYXRlcg0KcGF0Y2gg
aGFzIHNvbWV0aGluZyB3cm9uZyBhbmQgbmVlZHMgdG8gYmUgdXBkYXRlZCwgdGhlIGp1c3RpZmlj
YXRpb24gY2FuIGJlDQppbnZhbGlkLCBhbmQgd2UgbmVlZCB0byBhZGp1c3QgdGhlIHByZXZpb3Vz
IHBhdGNoZXMgYWNjb3JkaW5nbHkuICBUaGlzIGNvdWxkDQpyZXN1bHQgaW4gY29kZSByZXZpZXcg
ZnJ1c3RyYXRpb24uDQoNClNwZWNpZmljYWxseSBmb3IgdGhpcyBpc3N1ZSwgaWYgd2UgYWx3YXlz
IGZyZWUgVERNUnMgaW4gcHJldmlvdXMgcGF0Y2hlcywgdGhlbiANCml0J3MganVzdCBub3Qgcmln
aHQgdG8gZG8gd2hhdCB5b3Ugc3VnZ2VzdGVkIHRoZXJlLiAgQWxzbywgbm93IHdpdGggZHluYW1p
Yw0KYWxsb2NhdGlvbiBvZiBURFNZU0lORk9fU1RSVUNUIGFuZCBDTVIgYXJyYXksIHdlIG5lZWQg
dG8gZG8gMyB0aGluZ3Mgd2hlbiBtb2R1bGUNCmluaXRpYWxpemF0aW9uIGlzIHN1Y2Nlc3NmdWw6
DQoNCglwdXRfb25saW5lX21lbXMoKTsNCglrZnJlZShzeXNpbmZvKTsNCglrZnJlZShjbXJfYXJy
YXkpOw0KCXJldHVybiAwOw0Kb3V0X3h4eDoNCgkuLi4uDQoJcHV0X29ubGluZV9tZW1zKCk7DQoJ
a2ZyZWUoc3lzaW5mbyk7DQoJa2ZyZWUoY21yX2FycmF5KTsNCglyZXR1cm4gcmV0Ow0KDQpJIGNh
biBoYXJkbHkgc2F5IHdoaWNoIGlzIGJldHRlci4gIEkgYW0gd2lsbGluZyB0byBkbyB0aGUgYWJv
dmUgcGF0dGVybiBpZiB5b3UNCmd1eXMgcHJlZmVyIGJ1dCBJIGNlcnRhaW5seSBkb24ndCB3YW50
IHRvIG1peCB0aGlzIGxvZ2ljIHRvIHByZXZpb3VzIHBhdGNoZXMuDQo=
