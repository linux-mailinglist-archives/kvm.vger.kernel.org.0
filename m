Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808E379BEF1
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbjIKUrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237341AbjIKMkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 08:40:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AA9CEB;
        Mon, 11 Sep 2023 05:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694435996; x=1725971996;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=y30oCahh0/54YQI13KJOuGKyIEIe1hs+apa1fiTRFQs=;
  b=PFUGDMq1Q+pgdUVMvyX2Z6AWa3EJNdSXWvliH63Hdg+H04TpZTeeRGpt
   +xXqizUUdP/u5CPBn+eSqbUmois/N4UEHSNeTcHVbzpXeqg2aTnFgSfvo
   DqqG7SeYPOEG6GUv33StU8zJKCCVg9rlMh+Mx4g7exFt2O7TsypqSUYOa
   ToK1iklgbKTdJDWRh4D22CfJ+vnZ3BMgoxyKObN3Pncb2VSqeFDA73eJb
   Z1jacY6c15RVmo99JxOBnfy0ptBfCauX3zj765Lz9yUzOf5Fx2Ryj6ebx
   RwbQWBVo+0J9Q9rnJP6zHg3MYj8zrcubR7ZoUMNnPAkaSHcVYEEBMOQqn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="358371929"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="358371929"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 05:39:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="778377428"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="778377428"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2023 05:39:56 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 05:39:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 05:39:55 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 11 Sep 2023 05:39:55 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 11 Sep 2023 05:39:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YqGW+MtT3z56BVL3FQwZJbQuZ4wVcmd5AdHU7l07YEaVzs3wr9dic33MNtfa50n2pt3kcQ6PBdDevJjXyr+7/Vtzm9U61P38vwL5x3qAK2jZucKEpDJ64NvIoWoPeGr0L34w+P2zFcXpHNxgOypq0YIcrwteSahDPa73teRj3Bva6mFLVHnnulaljuRU1SGHl6MZgOUL4sP92FXTzkgy/TnPNTxKwzCOl/djQhAEoorDi13Av3Pdtzxh/bHIZKFaLBSJZjGsXiLpwDpT47GHChi2MDAs/HN6JyefHTtIZIr8/3LI2CHy81QxJxGZvsSHFK74Ebce2fnXtLhkrYKPFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y30oCahh0/54YQI13KJOuGKyIEIe1hs+apa1fiTRFQs=;
 b=TH7ZQuJ9dlHlcdLVwRE4OCxxABRjP1kZxGWzJNywZjiCo18xyTtJusrSEoAaDkszmOhMXCGmYCgm7LZufzMWIUkpwODTC8O4sLuaCB7gBGGBf8kGH+eMZ+azn1BeOAuKav6I0T9qUDnkngeWuBKwtUtjZAo4kOSv4HNG2DTRYWfRLNHaq9Q8rsNENGg7284mscMKIsPGX/Z6u6ugN+UOqHK/qg7qbbdsdYJjda/z9Svi8Trzx/8+KmO9mx3mQLjQv7BqA9LI/5PL3UJm5yAP7jdob1oOhkfT3j59v/NnrbnbyNyVrNw7lorxS+8NEko3l6rL3Sq+mpws/Y8lxicnWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB6622.namprd11.prod.outlook.com (2603:10b6:a03:478::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.31; Mon, 11 Sep
 2023 12:39:52 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 12:39:52 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v13 04/22] x86/cpu: Detect TDX partial write machine check
 erratum
Thread-Topic: [PATCH v13 04/22] x86/cpu: Detect TDX partial write machine
 check erratum
Thread-Index: AQHZ101Dw7KcxpimLUO4ZIQM6b2X6LARIfoAgASJhoA=
Date:   Mon, 11 Sep 2023 12:39:52 +0000
Message-ID: <bca23eb5f604058c26045dc5dd09770f5da885b8.camel@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
         <b089f93223958c168b5abd8eef0f810d616adb99.1692962263.git.kai.huang@intel.com>
         <cbc3aabb-6a38-37f0-81aa-1cbfba445d95@intel.com>
In-Reply-To: <cbc3aabb-6a38-37f0-81aa-1cbfba445d95@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB6622:EE_
x-ms-office365-filtering-correlation-id: 39bb4a92-fa5a-4092-d930-08dbb2c431e0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NZmmKTiby5jWfftQYJYRXb9i/r8lS7CNSYZSNNRqpQBbfZhn6oOVeb1VeeqJEX2jl4JTbOacIAebvtxLA/i5y9biBb+YxiOAv549goyJqpD0MLSRRRmHEPY6vELOF5nQRxg1AUYTzeKZPNhxcb0FOFTKBCEV0GfBVCilJ9AxxmICeYy/O86C66KoztWY/zsaACU4SuYCp2dolb5qrVO6cXweHUETMstcKhBIs1M/t7petDTvOjwNMhisDowXEfOAtg7uei/QoFGBKYCesB1zMlKjevLsG2LQv6JYFxm9EYQ6Ot2YRMmhy2qj9bXdQL2Yp6tsqCJ+EpKMzWSczktu/2qChdHQLjjvhPwfrb+rwhuMraueHBMt2ny7chyEkit8Xd02SeJn1JdzM0Q7vfA4PRQnFqf+OpzC88UI7V1dy6F56AWaSexBBRTgS89zgltGsLrhfJXeD+pvX+/MAbVelvB/TBO4CHPJ4CUqtVU0C88j4FhehIyQTrkzNP8N/V4Qr5d9Zw+dtglhkaqyJPMXpSwhp/csF3s4Aos85i5s69vWG1gOcWvIRdaWxKDJSyfBUSUh0dTNo3qid2doB7S1kuUF9Guzv2nXYHw4iX/COjzbSusrEDW03ioUSWYSv68b
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(366004)(376002)(396003)(186009)(1800799009)(451199024)(6506007)(53546011)(6486002)(71200400001)(6512007)(478600001)(83380400001)(26005)(2616005)(7416002)(54906003)(76116006)(64756008)(66446008)(66476007)(66556008)(66946007)(4326008)(316002)(91956017)(2906002)(41300700001)(5660300002)(8676002)(8936002)(82960400001)(86362001)(36756003)(38070700005)(38100700002)(122000001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TEcxUW1oYXRPVk5NbGNmTTMxWklvdDR2bGxiR0tDZDhQVGZ4cm1nVTBMZDZx?=
 =?utf-8?B?bThxcHdJdlN4QzZ4WVpwMVVtNXo0aVhKZnFRcjNmMTc2ODhRdGdxMG5UNTJS?=
 =?utf-8?B?bW5DeTZjaG5heTV5NUR1SExmc08rTHRlS29rdXdOUEJueWZCNkp5OWNkWFhR?=
 =?utf-8?B?VmRwdG1jcDBJRlI5S1MxbC9Od3hoQVpUYU84dWVOK2tNZm9PTmFLUFlMMWYv?=
 =?utf-8?B?Tm94bWQwa09zNzRZWVpuaFlndTNEM2RkbVNtRHpxZzlLSXFUZTM3dWhJekFw?=
 =?utf-8?B?TDFzOXN6YWs1ZmlSUEU2R2ZGbVZ2WnRjbGZuOGYwWVhtR0o5aGZPTG1udTF0?=
 =?utf-8?B?WEVFNm1mMGNtcUpNRE9IWnE3ZXlZWFJHbzVTaDFZcElWbnRpd3VLeUlQTUsz?=
 =?utf-8?B?eDAwUzY2QXhsTTgvMFUyZXc0c1kxMzNRQ1B3cVp0eGxMMTllUWIxdnJVQTNu?=
 =?utf-8?B?cVNGM1hsRkZ6N3gxbC91Tk1vTXh3TXEya2g1d1UxKzZTTkRubkJ1dkZreFRP?=
 =?utf-8?B?b3NNRFZqRnkxN2hvRUc4enFkT3BwUE1mN0VXYldROUcwUHoxVUhjOGdFK1hW?=
 =?utf-8?B?RSs0azQrcUtkTkFIZXR3bjJSVEdnaVFLZ2l6dEE5LzFuTEFVZTRwYVJwbVZi?=
 =?utf-8?B?cFlKWlFaNWRwNmY4UW5aVVhraytBU01wSXJJSUdicGNpbUhiS3VZOTVQTHh4?=
 =?utf-8?B?b29UVzNvaGZxb05sdTk5KzRtRTFGYnI0cjZ3anJ3a00zRDhFVnhJUktCYWwv?=
 =?utf-8?B?akRxeGhYKzVXbXpNUlhZN2tCTlUzd3psTEl5VDdvNVRtUzRXbXVPd1lTTDMr?=
 =?utf-8?B?RWJDZncwdG5TUG91Q2lONUxpU2NIekpyZjMxbDlMVDZEaEFJaGJwdFIzSGVS?=
 =?utf-8?B?SHhPb3FXVFpSZ0xXbmg1cFNJNk1ZOG9KRnk5ZGROL0Jvdk93TlBZdDNjcnk4?=
 =?utf-8?B?bUFVR20wZ2JGeUJ6aE03MzN4djFtQkgycWlpZ1FMQ0dpaENMbFZEZW1Dbis3?=
 =?utf-8?B?R2E5M1hpV0xHTUwrUENqZkhKMHZzZ05qeURWZlRWUUppbldwYmd3cnV5V0l1?=
 =?utf-8?B?NTI4b1QwRlppK2ZqRENzVFhCMEVLZWNSdUhhenRiN2d5blo5NDhrWGYwZ3Rm?=
 =?utf-8?B?UktrZzd6NnZIc21RNXg3OVNIb0c4TGVBcEZnRGk5UWVRZkZiMVhSeEhsdThv?=
 =?utf-8?B?aWRkaC94MERkaExwTllPQy90M2dob1hNK09tOWdVUkZ5NDcvUTR5SHEvMkdt?=
 =?utf-8?B?U3htRHlpb2haQnNwY3R2UnlXbU5RdVhWc0ZvNTVhWTV3UHZTakxVdXRvNGo2?=
 =?utf-8?B?MHk4NHhnWlBNRE5iR29vSjhDZ1VpVHlRUjJqVnJZdnJjNkVyeHRoakdpNXZC?=
 =?utf-8?B?QkYzQ2U0YkdWaHB3clZNNFNWTXVCbUV5L3orcUR4UVJmRFFPZ2NXZ3ZUZ1gr?=
 =?utf-8?B?K3dML2dTNUVTdEEwWTFhaWtvTVEwVkJWTFNWTThnMjFvZlBXUkQrMmhtZVJm?=
 =?utf-8?B?RFFLRE91cFhKczdvem9VaEViaTF1OWZ4Wk53VGpjU1p0NGN5VlVIS2NBWWs0?=
 =?utf-8?B?a2xVK25xWG50SFVqVEdmcFdGSThyNERHZlFrZWNWa3ljRlJvbjFtK0t5ZWFs?=
 =?utf-8?B?eFJqNFYxWEwyeHRKdml2SW5CSjRKb09DT3VpYnVKQWlGOURjd0Y2K0FZWnU4?=
 =?utf-8?B?b0VGUjBRS205MEtGcWdPZi9jUE1qcHJUcFdkcU0yTWdOSElXK3pVK3E5N3c2?=
 =?utf-8?B?c1pkaDhCSjF6SUUxZ05PK3ZLbHZjd2dEN0NUVnJqSC81TkRiSEVzbkl3NElr?=
 =?utf-8?B?MGZpcE40Vm1pQSs3ZTQzbWRWTHdzdFBYeFJPNmwySE5uU2Y1ak4yZkZ5QlNs?=
 =?utf-8?B?ZnBjZ010WDBtdXlXNFptMTltVnkwK3BKTVBTNFRyVHlPM2hLSjRyWnhlU3g2?=
 =?utf-8?B?cDVvc3NiVVZ1R3kxb2V0MVVnTWZ5SjdTUVR5aFBEMkY5QkYrYjg0aDJ6VEVY?=
 =?utf-8?B?cXFsWkVCUEt3K2gxYjRVOUEwVDdib3BZWUYreVJqbldETGF1andhVDFJREdy?=
 =?utf-8?B?c3U4cUJBY1l3WTJJOW4zc1pnMGJCWEk3cEVvdDVKRUxuZXRPZ0Y1Y1N6Smhy?=
 =?utf-8?Q?Ru0A7+UTwMbQ6xfbyJBzHkDeS?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ADF466D987B8BC47BFB6D1CED3F5EC9B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39bb4a92-fa5a-4092-d930-08dbb2c431e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2023 12:39:52.3168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8iBB0doRoR0TdDEEPz9AOsYpz0CXrsutzTjj6gMwjxqqasw5z1g8in8UoeQxwzmza4BUvKhIQ/xdQoQFrTQrbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6622
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA5LTA4IGF0IDA4OjIyIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gOC8yNS8yMyAwNToxNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IFREWCBtZW1vcnkgaGFzIGlu
dGVncml0eSBhbmQgY29uZmlkZW50aWFsaXR5IHByb3RlY3Rpb25zLiAgVmlvbGF0aW9ucyBvZg0K
PiA+IHRoaXMgaW50ZWdyaXR5IHByb3RlY3Rpb24gYXJlIHN1cHBvc2VkIHRvIG9ubHkgYWZmZWN0
IFREWCBvcGVyYXRpb25zIGFuZA0KPiA+IGFyZSBuZXZlciBzdXBwb3NlZCB0byBhZmZlY3QgdGhl
IGhvc3Qga2VybmVsIGl0c2VsZi4gIEluIG90aGVyIHdvcmRzLA0KPiA+IHRoZSBob3N0IGtlcm5l
bCBzaG91bGQgbmV2ZXIsIGl0c2VsZiwgc2VlIG1hY2hpbmUgY2hlY2tzIGluZHVjZWQgYnkgdGhl
DQo+ID4gVERYIGludGVncml0eSBoYXJkd2FyZS4NCj4gDQo+IFRoaXMgaXMgbWlzc2luZyBvbmUg
dGhpbmc6IGFsbHVkaW5nIHRvIGhvdyB0aGlzIHdpbGwgYmUgdXNlZC4gIFdlIG1pZ2h0DQo+IGRv
IHRoYXQgYnkgc2F5aW5nOiAiVG8gcHJlcGFyZSBmb3IgX19fX18sIGFkZCBfX19fX18uIg0KPiAN
Cj4gQnV0IHRoYXQncyBhIG1pbm9yIG5pdC4NCg0KVGhhbmtzIGZvciBzdWdnZXN0aW9uLg0KDQpJ
IHRob3VnaHQgSSBzb21laG93IG1lbnRpb25lZCBhdCBsYXN0IGluIHRoZSBjaGFuZ2Vsb2c6DQoN
CglXaXRoIHRoaXMgZXJyYXR1bSwgdGhlcmUgYXJlIGFkZGl0aW9uYWwgdGhpbmdzIG5lZWQgdG8g
YmUgZG9uZS4gDQpTaW1pbGFyDQoJdG8gb3RoZXIgQ1BVIGJ1Z3MsIHVzZSBhIENQVSBidWcgYml0
IHRvIGluZGljYXRlIHRoaXMgZXJyYXR1bSAuLi4NCg0KUGVyaGFwcyBpdCdzIG5vdCBjbGVhci4g
IEhvdyBhYm91dCBiZWxvdz8NCg0KCVdpdGggdGhpcyBlcnJhdHVtLCB0aGVyZSBhcmUgYWRkaXRp
b25hbCB0aGluZ3MgbmVlZCB0byBiZSBkb25lIGFyb3VuZA0KCQlrZXhlYygpIGFuZCBtYWNoaW5l
IGNoZWNrIGhhbmRsZXIuICBUbyBwcmVwYXJlIGZvciB0aG9zZSBjaGFuZ2VzLCBhZGQgYSAJCUNQ
VSBidWdiaXR0b2luZGljYXRldGhpc2VycmF0dW0uTm90ZXRoaXNidWdyZWZsZWN0c3RoZQkJaGFy
ZHdhcmV0aHVzaXRpc2RldGVjdGVkcmVnYXJkbGVzc29md2hldGhlcnRoZWtlcm5lbGlzYnVpbHQN
Cgl3aXRoIFREWCBzdXBwb3J0IG9yIG5vdC4NCj4gDQo+IC4uLg0KPiA+IFNpZ25lZC1vZmYtYnk6
IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogS2lyaWxs
IEEuIFNodXRlbW92IDxraXJpbGwuc2h1dGVtb3ZAbGludXguaW50ZWwuY29tPg0KPiA+IFJldmll
d2VkLWJ5OiBEYXZpZCBIaWxkZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT4NCj4gDQo+IFJldmll
d2VkLWJ5OiBEYXZlIEhhbnNlbiA8ZGF2ZS5oYW5zZW5AbGludXguaW50ZWwuY29tPg0KDQpUaGFu
a3MhDQo=
