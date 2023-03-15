Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EC06BAEFB
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 12:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbjCOLOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 07:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbjCOLNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 07:13:40 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAFC87D87;
        Wed, 15 Mar 2023 04:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678878718; x=1710414718;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Lmd27cf0aOTpd3JU2Te1/IOCUs9uarvwjNPa9aL8T9o=;
  b=io6mcgmaAW39834RWO6owJwtvl8xHjvbhqPhQGYZue2ftPkU3xU6hfeP
   GVjpP4sz79X9wSiLO3+PrVbih1s1c4rHq9JKgYJxq+iBPamh1koLjPH1O
   NnfUNXk26/lVDWcOans0V6rTNVir/EcQiurOcsy7/4RZIzyP9mF8Cw8tk
   IA1PZRO0gppGm+SvMS1wxunLulGnhF1tf4/gXRTs/LhV1IHUlFnuWddKu
   IH0f+GWWZGVLjsHkK6Cljo7L/jCtCWiR7u74SiaUbx0ET2GagFQBT8Q0V
   m1iWIkb3BJJhJcLUDtE17zL72uslZBcMUfXZLgVSbZqpvEUe9TfffhZKl
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="326032149"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="326032149"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 04:10:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="681803684"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="681803684"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 15 Mar 2023 04:10:15 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 04:10:15 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 04:10:15 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 04:10:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aMcBdJ84s6PgWxt1/XyedRIpdf7E/Ll3N4a41yAzGnbvhj12/0+DCmax8PDUHCmjGBUrU1EUHNjbjXPSqGlp5HftMDInrHmkZn0OyIerDc4oaKxBB+2bZM/gd59CtEG6ZuGDS1Yc060SARV5ZMKdVbNdUMBk2Bb9rHlasuc75dWKUwGweR7TM3sLGj5TBCLchw2SboY9Qtu9fXuqs9GaAV76rtucjYZ8zO1R8JlhYA2/MsCZ6LdOc6gjJRF4LRrhX/rDoCFFu36XXi9jdMloir/7FmpEk5zBoZ908ZvjitYL1oOhsGTdiKXBoes5MfC+0f2o2iwvcAhjh1avnfuHhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lmd27cf0aOTpd3JU2Te1/IOCUs9uarvwjNPa9aL8T9o=;
 b=mmp0HTjlniFQf3lx8Eub6ariI5mobNnoGVNHG/H6hGfKtZrCE5rPbGEIOWCXXGMtE5rSwMzcbR3GN3pmSLqeYvI7E7neJ4DNzyDAgEm1bWoGX8hSRHd+/rkLKbtjakEcih6GIeU085vsTsXWHC++MNHhLoDiwwTM7gYL5g7YwCad0SosCS3R/Od8x2fGCs9nfJ+mPE5VKdmGyPkTDxweWLIojjtKSZKNEVCq1LNGvkvUnDXw6W1fuEtpWsfJpPR1cSxddPm76pphpDeAZopgESTAqzn0HRSfyIghIZ2GhNr1t0RfCGexEhM76uO7IJW4oKAWqoOWAf0/3PenuVqgKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB7563.namprd11.prod.outlook.com (2603:10b6:510:286::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20; Wed, 15 Mar
 2023 11:10:11 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 11:10:11 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZUDU50M/RwoyayES+lzw7MeI2g67xefUAgAZUzQCAAZ2qAIAAIeiAgADqJACAAUSFAA==
Date:   Wed, 15 Mar 2023 11:10:11 +0000
Message-ID: <a02f304ea0e62180e07e2eb63eaf2411b702c672.camel@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
         <f150316b975b5ca22c6c4016ffd90db79d657bbf.1678111292.git.kai.huang@intel.com>
         <20230308222738.GA3419702@ls.amr.corp.intel.com>
         <96b56c5b8a5876aaf6d5ccbb81bab334b10983eb.camel@intel.com>
         <20230313234916.GC3922605@ls.amr.corp.intel.com>
         <a62497059fc3f31706a532b822d6c966bd981468.camel@intel.com>
         <5c4a28c8-f17d-7395-cc63-3cbd9b31befb@intel.com>
In-Reply-To: <5c4a28c8-f17d-7395-cc63-3cbd9b31befb@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB7563:EE_
x-ms-office365-filtering-correlation-id: 8172567c-58cc-45b8-7a15-08db2545d85e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MU4o7EKaYK8fZ79dBDBd/kUWJaCl8/JbfBsfe8hr7zH0dbkZG0Q7KxQw/4sGOXsAqbaPFFC21bIMomRKHT5O+rxL6tYhaQVfxKDZvfpQZxeip0Car+0Bjc8XPrZJjB4TUsr+EN409Y/wT3KWB2AgU5UsMqU+wWxWAtQxe8aZSunaj7Rb2am5gfqBV45+pCrU14ArEsDy+7E4mFktTRmoVkxLYgY3MsAn7i90w1pDsdCeKvG4Pg8As4nUqstsq6EIOPlP87ac3LEXRPESkvX4sP8F/dKDFJXNqDCKviis3gZ/On1hmf4atgpfhtyV27zcEJjSqp9KpYTpDX5ouxxkrvhHLn74a3FnGV5stpISC/bqtrS0rBclquAyUl8ru+t5OVRZIZy5JdfACucm1NKs8bIv7gc0FLrXLuVqLPGfoUlV44PNsCiSFNd48M+KHT7ksFxameyS2ij6yrYJZxN79bhMArskvnsjFQlBHzd4iZWXMcGpgzjB3aTYahMYv4Kd/xtDgEfZTRdp2tUr65FbuOp+nkFmPXXsOYLVQ3j0NXv29cS8PFsc72eQamWW44ESYEBj+jjGpoVZzk2y91/s6hVobh21uCx7CwfvRgRrjJFKB2CSChDNkcPGsj4I36q8pMaRZ8oaX9owLW0C3K1/YX5N16gouVHqxcUYC5MFEpkN/HrnOk2DjWy4yjEnW5vUBWGatJiEjcjxxmdSljhaNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199018)(82960400001)(5660300002)(7416002)(36756003)(86362001)(66476007)(83380400001)(186003)(66946007)(478600001)(6512007)(26005)(6506007)(53546011)(2616005)(6486002)(71200400001)(66556008)(91956017)(316002)(110136005)(76116006)(66446008)(38070700005)(64756008)(41300700001)(54906003)(38100700002)(8676002)(8936002)(4326008)(2906002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXJFUTdYR2RDVVVCYTY1aVdWNWpJMUtUOEpmNFNDRWt5d1pSTjRNSmJaU25h?=
 =?utf-8?B?V2tCR0lFUllBWmw3dWgzaXFvWk52YXl5S0UwNGJGMGhDV3pFalpqT3RvbStZ?=
 =?utf-8?B?bktPK0RLU2czbDNXYVgwbXFSWHlRVlh3YUo3U3R0NlM0eURrbU5xY0g5YllR?=
 =?utf-8?B?eVFXeHBUOWpDR3QzMk0vSTk0cllib0RnMDFpZTV4cmVPSzdDZDEwL0dZMFZz?=
 =?utf-8?B?aW1KTEdXYjA4YVFGSGQwaWFmN0U2MWN2TzBoQW9XbCtFQWpXV1B5TXVPMmkz?=
 =?utf-8?B?WTdBMHZtNkVidGZZczFVQ1NRUjdNTnZOSEpVaDFBL2tiMjVuczBENnBOQVdB?=
 =?utf-8?B?ZDJrczFCbnJSSzBhbjFHWTJZcnJLOW0yeUVyMGpUZExYTml2NG90N3pLQjJX?=
 =?utf-8?B?NXVZcHhGTWxPaTdwQ0k1SWNleFlCMEtxT2tFTXNGdFNQd2I2TllrQ3JMOUJr?=
 =?utf-8?B?T05aSmgvbUtTaVdUTGpuL1dvUldJZmJhSHdEUVpXYXRQOXlVSjNwWndidStw?=
 =?utf-8?B?VndKZEo2Z0hGRjEyWjFnOURpZDNpa1RRdlUrOUQ0QUNyd0pOdFFsNFVnWllR?=
 =?utf-8?B?OWZPOEV4cURZT1pwTC9CR3BrSmtRaDMwSVVjS1pHbWdlekU1U2FuUXdQNm93?=
 =?utf-8?B?SXdMRVh6Z2s1YmtGNDlQelM1dkJzd3NmZThDcmJtamJrMjRIaGtBSlJHZ0pK?=
 =?utf-8?B?SzlUdWFNdllMZkQ1SjM3cVVVRjdFM21mOTFBelU1ZWdnSDVYZHFVcjhEcCtR?=
 =?utf-8?B?N0cydmxKZitCT25KZ3k2VHNlNGJJNHhKcFA4azZLTlppdUExdWw1RllPZlJS?=
 =?utf-8?B?eHVPaHRQY1phNlFWeWpuSDBTdkhWNmlyd0loWG1EN1h6TEw2MitjS0tVYmJO?=
 =?utf-8?B?QmVsQXVVUFRFOGxDV2hYTVYyQVVUZmZzQ3QwUStQZVdNaWlqbTJFb1E2TlFa?=
 =?utf-8?B?QnRCVGpsTGNOMXRmMkZjclhLK2lnV0Fzc01NUXVFMnloVDBnR3RSUEpWYU9H?=
 =?utf-8?B?dENaTU0rU1daOVBFMkpHL0tpaDJKaTF4NUhFMmJiM0NEZUMyeXd4c0RmSUh1?=
 =?utf-8?B?THo0a2RtZVBlcU82YUdBRXJwdFE2WnB2N3ZVTW5IbzRKQWZsamplamZmMjgy?=
 =?utf-8?B?Rmt5NnR6ajBJSlZiUFY0WTl0c2NnbmxOZTZSS0d5d2N6S0RINGpOdmIrdlVI?=
 =?utf-8?B?UDVCVVpxSWdCVVJQcUg1RHZVRjErNlNwTkZCdEY3RGtINEFpZnhtUUxOY1NZ?=
 =?utf-8?B?SlJ0VlNENUttTGx0SThFN2hxazhINks3Q0lqc1Y5YXBvRjVQR0FPM0xJRnN5?=
 =?utf-8?B?WklzMmhZbnVyM25PWWl6eW5VY3RXaW1ISStuWlhERVRMSDFKa0RHQWR1dlEw?=
 =?utf-8?B?UGpoK1pjWTM4WFlUczdCbytLeCtzU01FcEYvWksyeWtFVVpyTmdCd3B3c1FD?=
 =?utf-8?B?VTVmNDdzeFlsOVoxZjc5TjBZVE01b3pEWGM2bG9XN2pWeFArbG9MTUQ2UVZw?=
 =?utf-8?B?T3dpd1MvdHFCRWlYZWxaYzdXeHZFUFNpQytFckxyT0hFZWQ1SzMvdmUyYnEy?=
 =?utf-8?B?ZjRkZ2hQZmh0cWplKy9sTFlmZ2JFVno3bG92MzMzRnRZUVZmUmUrQnZxc1VZ?=
 =?utf-8?B?YmZmZUNxeVV0b25BbmNmMUo3Sk5LaCtaNnhjbi9EUzNpQWNPWnlielJvQzZz?=
 =?utf-8?B?aVhCK2tUdXJyNFVqNGx3aUNWUzdNcytTaFR2RUwrUDRpYkg1cHVoN3pwaDBo?=
 =?utf-8?B?dGdyOTdva0dkZEQrOTV1bWVLeGhIcFo0eEFwcDZkZjJnN3QwUFVnSVRtRlZm?=
 =?utf-8?B?dWs1WGdRRHhiOVFiL1FkYlBETWxSdm9KV0tIaVU2SmZIK1RyM28xZ0pHTkdn?=
 =?utf-8?B?QWg5SVBGMzlob08wUEFlaFFLY2JnN3ZjVjN3ZUZMZHJpcHE5YVJZZkJVQVBK?=
 =?utf-8?B?Sk8wVEVDZ2NWcUhnQmpGbFc4ZmdWNlM0Zk5tSVVWaGQrZjh6Tnl6N0h5K2pF?=
 =?utf-8?B?SjlrdENIa1FPczRiMWVubVNQNmViN3FrTUl2RTRYM0hQUGJ3WW5xUUtFWjNy?=
 =?utf-8?B?VGNBZ2YvUFowc1llcm5WNDQ0dzc5K0JlSlU2SVB2NE1wNDBNS1pWQjJvcmxO?=
 =?utf-8?B?dnRqVTYxMExmNENXQ2ZnMkxTRUtZdDczSnBJOVR3eGNQZWRTZXlKcGo4c0Jv?=
 =?utf-8?B?dnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <364173ADEE4EB541851302EE6646845E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8172567c-58cc-45b8-7a15-08db2545d85e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 11:10:11.5629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DF7ax4BeLqJ4hW19IkV1IU1Qxw5Y9gjpEKzy3zBlcTbiNsc862BT//BQnE6BK/ISU3+bWWOBxP+37zeeYoDR/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7563
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAzLTE0IGF0IDA4OjQ4IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMy8xMy8yMyAxODo1MCwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBNb24sIDIwMjMtMDMt
MTMgYXQgMTY6NDkgLTA3MDAsIElzYWt1IFlhbWFoYXRhIHdyb3RlOg0KPiA+ID4gT24gU3VuLCBN
YXIgMTIsIDIwMjMgYXQgMTE6MDg6NDRQTSArMDAwMCwNCj4gPiA+ICJIdWFuZywgS2FpIiA8a2Fp
Lmh1YW5nQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPiANCj4gPiA+ID4gT24gV2VkLCAyMDIzLTAz
LTA4IGF0IDE0OjI3IC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToNCj4gPiA+ID4gPiA+ICsN
Cj4gPiA+ID4gPiA+ICtzdGF0aWMgaW50IHRyeV9pbml0X21vZHVsZV9nbG9iYWwodm9pZCkNCj4g
PiA+ID4gPiA+ICt7DQo+ID4gPiA+ID4gPiArICAgICAgIGludCByZXQ7DQo+ID4gPiA+ID4gPiAr
DQo+ID4gPiA+ID4gPiArICAgICAgIC8qDQo+ID4gPiA+ID4gPiArICAgICAgICAqIFRoZSBURFgg
bW9kdWxlIGdsb2JhbCBpbml0aWFsaXphdGlvbiBvbmx5IG5lZWRzIHRvIGJlIGRvbmUNCj4gPiA+
ID4gPiA+ICsgICAgICAgICogb25jZSBvbiBhbnkgY3B1Lg0KPiA+ID4gPiA+ID4gKyAgICAgICAg
Ki8NCj4gPiA+ID4gPiA+ICsgICAgICAgc3Bpbl9sb2NrKCZ0ZHhfZ2xvYmFsX2luaXRfbG9jayk7
DQo+ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiArICAgICAgIGlmICh0ZHhfZ2xvYmFsX2luaXRf
c3RhdHVzICYgVERYX0dMT0JBTF9JTklUX0RPTkUpIHsNCj4gPiA+ID4gPiA+ICsgICAgICAgICAg
ICAgICByZXQgPSB0ZHhfZ2xvYmFsX2luaXRfc3RhdHVzICYgVERYX0dMT0JBTF9JTklUX0ZBSUxF
RCA/DQo+ID4gPiA+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAtRUlOVkFMIDogMDsNCj4g
PiA+ID4gPiA+ICsgICAgICAgICAgICAgICBnb3RvIG91dDsNCj4gPiA+ID4gPiA+ICsgICAgICAg
fQ0KPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gKyAgICAgICAvKiBBbGwgJzAncyBhcmUganVz
dCB1bnVzZWQgcGFyYW1ldGVycy4gKi8NCj4gPiA+ID4gPiA+ICsgICAgICAgcmV0ID0gc2VhbWNh
bGwoVERIX1NZU19JTklULCAwLCAwLCAwLCAwLCBOVUxMLCBOVUxMKTsNCj4gPiA+ID4gPiA+ICsN
Cj4gPiA+ID4gPiA+ICsgICAgICAgdGR4X2dsb2JhbF9pbml0X3N0YXR1cyA9IFREWF9HTE9CQUxf
SU5JVF9ET05FOw0KPiA+ID4gPiA+ID4gKyAgICAgICBpZiAocmV0KQ0KPiA+ID4gPiA+ID4gKyAg
ICAgICAgICAgICAgIHRkeF9nbG9iYWxfaW5pdF9zdGF0dXMgfD0gVERYX0dMT0JBTF9JTklUX0ZB
SUxFRDsNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBJZiBlbnRyb3B5IGlzIGxhY2tpbmcgKHJkcmFu
ZCBmYWlsdXJlKSwgVERIX1NZU19JTklUIGNhbiByZXR1cm4gVERYX1NZU19CVVNZLg0KPiA+ID4g
PiA+IEluIHN1Y2ggY2FzZSwgd2Ugc2hvdWxkIGFsbG93IHRoZSBjYWxsZXIgdG8gcmV0cnkgb3Ig
bWFrZSB0aGlzIGZ1bmN0aW9uIHJldHJ5DQo+ID4gPiA+ID4gaW5zdGVhZCBvZiBtYXJraW5nIGVy
cm9yIHN0aWNraWx5Lg0KPiA+ID4gPiANCj4gPiA+ID4gVGhlIHNwZWMgc2F5czoNCj4gPiA+ID4g
DQo+ID4gPiA+IFREWF9TWVNfQlVTWSAgICAgICAgVGhlIG9wZXJhdGlvbiB3YXMgaW52b2tlZCB3
aGVuIGFub3RoZXIgVERYIG1vZHVsZQ0KPiA+ID4gPiAgICAgICAgICAgICBvcGVyYXRpb24gd2Fz
IGluIHByb2dyZXNzLiBUaGUgb3BlcmF0aW9uIG1heSBiZSByZXRyaWVkLg0KPiA+ID4gPiANCj4g
PiA+ID4gU28gSSBkb24ndCBzZWUgaG93IGVudHJvcHkgaXMgbGFja2luZyBpcyByZWxhdGVkIHRv
IHRoaXMgZXJyb3IuICBQZXJoYXBzIHlvdQ0KPiA+ID4gPiB3ZXJlIG1peGluZyB1cCB3aXRoIEtF
WS5DT05GSUc/DQo+ID4gPiANCj4gPiA+IFRESC5TWVMuSU5JVCgpIGluaXRpYWxpemVzIGdsb2Jh
bCBjYW5hcnkgdmFsdWUuICBURFggbW9kdWxlIGlzIGNvbXBpbGVkIHdpdGgNCj4gPiA+IHN0cm9u
ZyBzdGFjayBwcm90ZWN0b3IgZW5hYmxlZCBieSBjbGFuZyBhbmQgY2FuYXJ5IHZhbHVlIG5lZWRz
IHRvIGJlDQo+ID4gPiBpbml0aWFsaXplZC4gIEJ5IGRlZmF1bHQsIHRoZSBjYW5hcnkgdmFsdWUg
aXMgc3RvcmVkIGF0DQo+ID4gPiAlZnNiYXNlOjxTVEFDS19DQU5BUllfT0ZGU0VUIDB4Mjg+DQo+
ID4gPiANCj4gPiA+IEFsdGhvdWdoIHRoaXMgaXMgYSBqb2IgZm9yIGxpYmMgb3IgbGFuZ3VhZ2Ug
cnVudGltZSwgVERYIG1vZHVsZXMgaGFzIHRvIGRvIGl0DQo+ID4gPiBpdHNlbGYgYmVjYXVzZSBp
dCdzIHN0YW5kIGFsb25lLg0KPiA+ID4gDQo+ID4gPiBGcm9tIHRkaF9zeXNfaW5pdC5jDQo+ID4g
PiBfU1RBVElDX0lOTElORV8gYXBpX2Vycm9yX3R5cGUgdGR4X2luaXRfc3RhY2tfY2FuYXJ5KHZv
aWQpDQo+ID4gPiB7DQo+ID4gPiAgICAgaWEzMl9yZmxhZ3NfdCByZmxhZ3MgPSB7LnJhdyA9IDB9
Ow0KPiA+ID4gICAgIHVpbnQ2NF90IGNhbmFyeTsNCj4gPiA+ICAgICBpZiAoIWlhMzJfcmRyYW5k
KCZyZmxhZ3MsICZjYW5hcnkpKQ0KPiA+ID4gICAgIHsNCj4gPiA+ICAgICAgICAgcmV0dXJuIFRE
WF9TWVNfQlVTWTsNCj4gPiA+ICAgICB9DQo+ID4gPiAuLi4NCj4gPiA+ICAgICBsYXN0X3BhZ2Vf
cHRyLT5zdGFja19jYW5hcnkuY2FuYXJ5ID0gY2FuYXJ5Ow0KPiA+ID4gDQo+ID4gPiANCj4gPiAN
Cj4gPiBUaGVuIGl0IGlzIGEgaGlkZGVuIGJlaGF2aW91ciBvZiB0aGUgVERYIG1vZHVsZSB0aGF0
IGlzIG5vdCByZWZsZWN0ZWQgaW4gdGhlDQo+ID4gc3BlYy4NCj4gDQo+IFRoaXMgaXMgdHJ1ZS4g
IENvdWxkIHlvdSBwbGVhc2UgZ28gYXNrIHRoZSBURFggbW9kdWxlIGZvbGtzIHRvIGZpeCB0aGlz
IHVwPw0KDQpTdXJlIHdpbGwgZG8uDQoNClRvIG1ha2Ugc3VyZSwgeW91IG1lYW4gd2Ugc2hvdWxk
IGFzayBURFggbW9kdWxlIGd1eXMgdG8gYWRkIHRoZSBuZXcNClREWF9STkRfTk9fRU5UUk9QWSBl
cnJvciBjb2RlIHRvIFREWCBtb2R1bGUgMS4wPw0KDQoiYW5vdGhlciBURFggbW9kdWxlIG9wZXJh
dGlvbiB3YXMgaW4gcHJvZ3Jlc3MiIGFuZCAicnVubmluZyBvdXQgb2YgZW50cm9weSIgYXJlDQpk
aWZmZXJlbnQgdGhpbmcgYW5kIHNob3VsZCBub3QgYmUgbWl4ZWQgdG9nZXRoZXIgSU1ITy4NCg0K
PiANCj4gPiBJIGFtIG5vdCBzdXJlIHdoZXRoZXIgd2Ugc2hvdWxkIGhhbmRsZSBiZWNhdXNlOg0K
PiA+IA0KPiA+IDEpIFRoaXMgaXMgYW4gZXh0cmVtZWx5IHJhcmUgY2FzZS4gIEtlcm5lbCB3b3Vs
ZCBiZSBiYXNpY2FsbHkgdW5kZXIgYXR0YWNrIGlmDQo+ID4gc3VjaCBlcnJvciBoYXBwZW5lZC4g
IEluIHRoZSBjdXJyZW50IHNlcmllcyB3ZSBkb24ndCBoYW5kbGUgc3VjaCBjYXNlIGluDQo+ID4g
S0VZLkNPTkZJRyBlaXRoZXIgYnV0IGp1c3QgbGVhdmUgYSBjb21tZW50IChzZWUgcGF0Y2ggMTMp
Lg0KPiANCj4gUmFyZSwgeWVzLiAgVW5kZXIgYXR0YWNrPyAgSSdtIG5vdCBzdXJlIHdoZXJlIHlv
dSBnZXQgdGhhdCBmcm9tLiAgTG9vaw0KPiBhdCB0aGUgU0RNOg0KPiANCj4gPiBVbmRlciBoZWF2
eSBsb2FkLCB3aXRoIG11bHRpcGxlIGNvcmVzIGV4ZWN1dGluZyBSRFJBTkQgaW4gcGFyYWxsZWws
IGl0IGlzIHBvc3NpYmxlLCB0aG91Z2ggdW5saWtlbHksIGZvciB0aGUgZGVtYW5kDQo+ID4gb2Yg
cmFuZG9tIG51bWJlcnMgYnkgc29mdHdhcmUgcHJvY2Vzc2VzL3RocmVhZHMgdG8gZXhjZWVkIHRo
ZSByYXRlIGF0IHdoaWNoIHRoZSByYW5kb20gbnVtYmVyIGdlbmVyYXRvcg0KPiA+IGhhcmR3YXJl
IGNhbiBzdXBwbHkgdGhlbS4gVGhpcyB3aWxsIGxlYWQgdG8gdGhlIFJEUkFORCBpbnN0cnVjdGlv
biByZXR1cm5pbmcgbm8gZGF0YSB0cmFuc2l0b3JpbHkuIFRoZSBSRFJBTkQNCj4gPiBpbnN0cnVj
dGlvbiBpbmRpY2F0ZXMgdGhlIG9jY3VycmVuY2Ugb2YgdGhpcyByYXJlIHNpdHVhdGlvbiBieSBj
bGVhcmluZyB0aGUgQ0YgZmxhZy4NCj4gDQo+IFRoYXQgZG9lc24ndCB0YWxrIGFib3V0IGF0dGFj
a3MuDQoNClRoYW5rcyBmb3IgY2l0aW5nIHRoZSBkb2N1bWVudGF0aW9uLiAgSSBjaGVja2VkIHRo
ZSBrZXJuZWwgY29kZSBiZWZvcmUgYW5kIGl0DQpzZWVtcyBjdXJyZW50bHkgdGhlcmUncyBubyBj
b2RlIHRvIGNhbGwgUkRSQU5EIHZlcnkgZnJlcXVlbnRseS4gIEJ1dCB5ZXMgd2UNCnNob3VsZCBu
b3Qgc2F5ICJ1bmRlciBhdHRhY2siLiAgSSBoYXZlIHNvbWUgb2xkIG1lbW9yeSB0aGF0IHNvbWVv
bmUgc2FpZCBzbw0KKG1heWJlIG1lPykuDQoNCj4gDQo+ID4gMikgTm90IHN1cmUgd2hldGhlciB0
aGlzIHdpbGwgYmUgY2hhbmdlZCBpbiB0aGUgZnV0dXJlLg0KPiA+IA0KPiA+IFNvIEkgdGhpbmsg
d2Ugc2hvdWxkIGtlZXAgYXMgaXMuDQo+IA0KPiBURFhfU1lTX0JVU1kgcmVhbGx5IGlzIG1pc3Np
bmcgc29tZSBudWFuY2UuICBZb3UgKlJFQUxMWSogd2FudCB0byByZXRyeQ0KPiBSRFJBTkQgZmFp
bHVyZXMuIMKgDQo+IA0KDQpPSy4gIEFncmVlZC4gIFRoZW4gSSB0aGluayB0aGUgVERILlNZUy5L
RVkuQ09ORklHIHNob3VsZCByZXRyeSB3aGVuIHJ1bm5pbmcgb3V0DQpvZiBlbnRyb3B5IHRvby4N
Cg0KPiBCdXQsIGlmIHlvdSBoYXZlIFZNTSBsb2NraW5nIGFuZCBkb24ndCBleHBlY3QgdHdvDQo+
IHVzZXJzIGNhbGxpbmcgaW50byB0aGUgVERYIG1vZHVsZSB0aGVuIFREWF9TWVNfQlVTWSBmcm9t
IGEgYnVzeSAqbW9kdWxlKg0KPiBpcyBhIGJhZCAoYW5kIHByb2JhYmx5IGZhdGFsKSBzaWduYWwu
DQoNClllcyB3ZSBoYXZlIGEgbG9jayB0byBwcm90ZWN0IFRESC5TWVMuSU5JVCBmcm9tIGJlaW5n
IGNhbGxlZCBpbiBwYXJhbGxlbC4gIFcvbw0KdGhpcyBlbnRyb3B5IHRoaW5nIFREWF9TWVNfQlVT
WSBzaG91bGQgbmV2ZXIgaGFwcGVuLg0KDQo+IA0KPiBJIHN1c3BlY3Qgd2Ugc2hvdWxkIGp1c3Qg
dGhyb3cgYSBmZXcgcmV0cmllcyBpbiB0aGUgc2VhbWNhbGwoKQ0KPiBpbmZyYXN0cnVjdHVyZSB0
byByZXRyeSBpbiB0aGUgY2FzZSBvZiBURFhfU1lTX0JVU1kuICBJdCdsbCB0YWtlIGNhcmUgb2YN
Cj4gUkRSQU5EIGZhaWx1cmVzLiAgSWYgYSByZXRyeSBsb29wIGZhaWxzIHRvIHJlc29sdmUgaXQs
IHRoZW4gd2Ugc2hvdWxkDQo+IHByb2JhYmx5IGR1bXAgYSB3YXJuaW5nIGFuZCByZXR1cm4gYW4g
ZXJyb3IuDQo+IA0KPiBKdXN0IGRvIHRoaXMgb25jZSwgaW4gY29tbW9uIGNvZGUuDQoNCkkgY2Fu
IGRvLiAgSnVzdCB3YW50IHRvIG1ha2Ugc3VyZSBkbyB5b3Ugd2FudCB0byByZXRyeSBURFhfU1lT
X0JVU1ksIG9yIHJldHJ5DQpURFhfUk5EX05PX0VOVFJPUFkgKGlmIHdlIHdhbnQgdG8gYXNrIFRE
WCBtb2R1bGUgZ3V5cyB0byBjaGFuZ2UgdG8gcmV0dXJuIHRoaXMNCnZhbHVlKT8NCg0KQWxzbywg
ZXZlbiB3ZSByZXRyeSBlaXRoZXIgVERYX1NZU19CVVNZIG9yIFREWF9STkRfTk9fRU5UUk9QWSBp
biBjb21tb24gDQpzZWFtY2FsbCgpIGNvZGUsIGl0IGRvZXNuJ3QgaGFuZGxlIHRoZSBUREguU1lT
LktFWS5DT05GSUcsIGJlY2F1c2Ugc2FkbHkgdGhpcw0KU0VBTUNBTEwgcmV0dXJucyBhIGRpZmZl
cmVudCBlcnJvciBjb2RlOg0KDQpURFhfS0VZX0dFTkVSQVRJT05fRkFJTEVECUZhaWxlZCB0byBn
ZW5lcmF0ZSBhIHJhbmRvbSBrZXkuIFRoaXMgaXPCoA0KCQkJCXR5cGljYWxseSBjYXVzZWQgYnkg
YW4gZW50cm9weSBlcnJvciBvZiB0aGUNCgkJCQlDUFUncyByYW5kb20gbnVtYmVyIGdlbmVyYXRv
ciwgYW5kIG1heQ0KCQkJCWJlIGltcGFjdGVkIGJ5IFJEU0VFRCwgUkRSQU5EIG9yIFBDT05GSUcN
CgkJCQlleGVjdXRpbmcgb24gb3RoZXIgTFBzLiBUaGUgb3BlcmF0aW9uIHNob3VsZCBiZQ0KCQkJ
CXJldHJpZWQuDQoNCg==
