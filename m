Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083B269876B
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 22:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjBOViI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 16:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBOViH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 16:38:07 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0C72B098;
        Wed, 15 Feb 2023 13:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676497086; x=1708033086;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=417W5DPIohQVkJurIXNGFC7oPmX+o0GP042SWApcbNA=;
  b=D1RlbiKylZ94WnN6ejXQD8RAmo6UrumiYPMPpSECxuJ0oYutBShRZTTp
   hayPOWZ3IiJkc8ctHVeS18xvKKvmZyktMLzw2G7TdYNaFl9IU0QrAXA/O
   rMlg8ERinkuc3BIdUX8kvBUEqFqBdaLtNzjHS7jgECkH/U01Afmc5YRM2
   y0/L/eyrqoq2zr9GKreuitHlbQaBzr/PVaFwijZHcLYq0Lxw0Fu59ZnSz
   /LfCdooXr22JoL6C21DrBv3SRBSqt3flW05457KJohBl4h9h3KxS/dPFo
   uwu+KudCXScVwgwwmezFqGpxkB7ygkts5tE2nR3nh/qzCeCeDh1FOND4O
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="332868258"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="332868258"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 13:38:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="779075182"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="779075182"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 15 Feb 2023 13:38:00 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 13:38:00 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 13:38:00 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 13:37:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUUmdnqbzcWH/XRHaVTRScsl5qdxQ4yWAD7m/u516X/Ymj+ww7JeKceAUo7Z+8NYIZRcgQr12W0VcprEzCskhyIEnGANv9SCvn4KtCpyy9UVYA9iCIB9koA9gtyCJrBYoUM+UH9R0XCo6fWDKWP8BrF0T7Xmt7nAutj37DCrc9BNQs+tdQDEnBJP4PzBxny1XgZGZCXeLNRNdaCYQxj+SMLtEnS7n6AjXcpQUQZKk/GG2o4XykRvvwfKETyIGDy9PmL4AMAwh5vmPdffSGPVHI9+rp1LRzB+q7KRmtEJN9NXaKSfDPpr89CnGg/yCFSDoM7W2tLlifWnlOMCJVW8RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=417W5DPIohQVkJurIXNGFC7oPmX+o0GP042SWApcbNA=;
 b=aM/W+Bn3KIIfXHD5ACZTymJW8w0vv1UfPLFRBe3FWqV9PW/G/Gy/IU8h+O8zOZqAP7na1//jJZvE+C8peKvoIA4uyaMerHSIacVnaQw21aD8vUYHxH2yckVSrFAtm/DIoSjzVswpL1GkZv+LznPlhFJ8L/N4Tn8eldNkEaM9GM13w3tNpgtkES+GqxJNiKRgtBpRE4YlIX5SP6mPbPqlCTTKIasbpYZaAVxFFtnpal8g2RTl+O/7rBHvTXsEx8wGjssr4UgmJZnALgkE5lWSu/U+T2q93OVK32gSiVC1P77t9sVk7chHCnLDPKQOVOPXUfrgt1E5QIhFcuTz0r63WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ1PR11MB6106.namprd11.prod.outlook.com (2603:10b6:a03:48b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Wed, 15 Feb
 2023 21:37:56 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%7]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 21:37:56 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Thread-Topic: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Thread-Index: AQHZP5uucDbGOLsVDEixmYuAvdZDZ67NKpCAgAA2qfCAABiqAIAAFhiAgADtdoCAAJGdgIAArgoAgAAIV4CAAD0ugIAAibCA
Date:   Wed, 15 Feb 2023 21:37:56 +0000
Message-ID: <f23b0da7099f0560d5c70e5ed5e0ea190e2c61cf.camel@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
         <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
         <86a8fe2f-566a-d0b9-7a22-9b41c91796f8@intel.com>
         <BL1PR11MB59789A024CFA9E9DE715C2F1F7DD9@BL1PR11MB5978.namprd11.prod.outlook.com>
         <af6034c3-98a3-239b-2c79-ff878f5d9673@intel.com>
         <43fec733ea5331c6de4592dbf44a62e0c61eecb1.camel@intel.com>
         <Y+uWu9hLMZ35JHlY@hirez.programming.kicks-ass.net>
         <0795f69fd0ff8ccdd40cc7a3d6cc32da47e6d929.camel@intel.com>
         <Y+yi4B+P9K2FXNqt@hirez.programming.kicks-ass.net>
         <24bd9d546d07b57387ecd990746061ae35ce5fa5.camel@intel.com>
         <Y+zdMZjApMWJ97GP@hirez.programming.kicks-ass.net>
In-Reply-To: <Y+zdMZjApMWJ97GP@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ1PR11MB6106:EE_
x-ms-office365-filtering-correlation-id: ffd0ad25-ebd2-475d-427b-08db0f9ce693
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4NJFW30vldYkIdJ5K15HL8kVER7wMYcwGEhCNX+8mWDtfPscxU37bRVdOSvSf8Ugp0EnMux2oVUTntd/OEud3f3clr3nwLyfoKSFyiWPmRluM5o/VmgltdClgBCcwpz7KGwZVCZiK1Wn+EtOyxcaGow+HIUmGixszVvnrSZvfPdjZSAJkXhKG9SxN3pWIWsx4xUyqI6JC15DBDGPSON8eIVuKRKr+Uh/q2KEt8yoXzg968Wtfr6pHVjl6U8y67fyE7KA53QfnAp2ghwL8x1f6eVPX+uL/NaP1xWrG07Uu00oCTyDE1tsSPx7MmtyPOq87qGeH/CynB57zUdFyRYmLGbZXhYgFV1htNQhC34D7NU0fYHJSEgbJSNbN21zftK9LjoR1EU+cGB0tT3yt5uHJXIIFxb0TdOkcDo9jzRhHMWqe7CL/HMlgeZ/EcAaL+3dWo0yXpEfh3wNzxtYFiuwEz/ZJpb2uq5NhV7SqZBkhwz044EPdotsW9j8WrQ2zA4lprr+9IPmoyBfB7g/d/AZQ+IdACnWxqMD9QJfkN03G/RSYNxcot0y3naGXAp4vqAd5MAsNRWQXuuv0v7pH1Nsv4cByGTvncnACU7/Kw4s89Aola5dHKtu7BQYIeWP7Gn6BHbF05zYOVbZBbW8eVTjY7M5ogfXHCoTGi/8XQN+r7MJwGSfmC/GOLldITlFTfbF0dNIDZvulptSaROTUozVQw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199018)(8936002)(2616005)(82960400001)(38100700002)(316002)(71200400001)(54906003)(86362001)(38070700005)(478600001)(6506007)(6486002)(41300700001)(2906002)(36756003)(26005)(186003)(66946007)(6512007)(122000001)(91956017)(4326008)(8676002)(76116006)(6916009)(66446008)(66476007)(66556008)(64756008)(4744005)(7416002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?akxlUHNndlZFTitLdEZZeS9mWEJsaTRqbGRPRmRNRHZMRXBDcUJtN1MzSWdB?=
 =?utf-8?B?Y3VuMEMxUjcwUFFaTndFdVRReUl6N21COXIwR3JnK01Md1ZuOTM2d2ljMDBz?=
 =?utf-8?B?Vi9tUEZYWDBFUTFMR2xONHJMU3FCdXFYNUY5cTc4akJFQnJ3M29pdENKN2l2?=
 =?utf-8?B?OGo1RnZnNWgrZFVPdFBobmhLa3A1SFJhcUkxMFNUSGpCNGRtYVZrd0IyRkY0?=
 =?utf-8?B?R2VxUzFoUEViWUhVVkd3d3B6dnVWOGpLV1dQOTJjWHNseUViRkhDcG9QWjNx?=
 =?utf-8?B?bVl2YS9ZWjVIUUZXaHpIOVl1YVdVM08yeFJQZWV4TVcyMW1RN1B5QWNOT2ZU?=
 =?utf-8?B?SXdXR1BIVEJyZ0RnSUhWTlhrdHZPYnpTbEFLY2xsUnZscWNhejJQNkNtTHA1?=
 =?utf-8?B?VUhZeG1hL2ZqUWJIVXVPZXhNL2RyQmJiaEpDcldvQktlVHpDRVcyUUxBZkxY?=
 =?utf-8?B?MWpqOW5SVmJUbkYyd2xadjd5c2FWTWhUMXJ6UzNuRUFIeXMzMHBWTGVFMk8x?=
 =?utf-8?B?ZjNEY3hROWZPYzFmZjNWcW0vRXpwbitGc096TTlLdFpXZlZqWVJEZmdMR3Br?=
 =?utf-8?B?OVdDYUpTTFVLbEIvUVdZeUFuQU5mdEVQMDExcnZncHBORFR4TThuaWpVNVF6?=
 =?utf-8?B?eC9OS05xZmRBdDhleGlIN2ZqcjI0YXhnRUtWMFhBS0pKYXEzcHNhTksya1R5?=
 =?utf-8?B?M2VRQ3N2VVl4Nnl0Rk9BNGIwaVBCdUNFMmhYbFpKZXFGTHlRSnhOMXZaTlFD?=
 =?utf-8?B?SXhWZnRDYXJLUVIxZ0FucGZ3RHQ5WTVxRVZMZUwweEtpZmRQMGRuM21pUWkr?=
 =?utf-8?B?Q04xQmZLdVZHMXBYSTFQczFIMVhRTG8xZ1dYUnJCWU5HWWVQd05TdnJxRHJl?=
 =?utf-8?B?aXljZTRoWnE2R1JzbVl5bjdpRlVPUFQzaW1tMGprTkFmakxLTTM0UFp1b25u?=
 =?utf-8?B?eVRyMXJuTU5wc2Nkd0pnVWxHcFoydlZHbTlhSmR1TjA2L2l6ZTVHUTNzUi9k?=
 =?utf-8?B?UE1MNlRLZ1hWRzhuYzNDMkNXRndrdTBhUW9uZzBDMVJ0RWtKMjYxRFRaRThJ?=
 =?utf-8?B?T2YrQmhZNk1jNWdHdkYwWWRCeDJCVHpEYkhJRk4rNi9xYTYxQkc5RVpEakto?=
 =?utf-8?B?SUVTcnl2ZXJOcUlmWlAvdTg2L2J3Tjh4d0I0OVF0cWlFM205VEtaMmtFSUVZ?=
 =?utf-8?B?ZmxKNDhXTHVlbnZvUXVWMW5LTjE4QlVDVmY4Ritrbm9nYVUzZGtCS2FDNzFN?=
 =?utf-8?B?cXprUTRRSkNFNHBpUThMZDc3bzFydHhPbHJKdGRGVWdvTWVJR3ZFUHRqNnRE?=
 =?utf-8?B?ZEdVSjJqeGZRTEtUWnpuQkZrR0tsNTdEYkVaQUdQUGZua04zQ0tuaHJGRkdU?=
 =?utf-8?B?QXVSM04vd3BRcWJHSXlwZkpBdCtNWVRXWVJhbGRuUS9GSWlzNk1IcVpWb1pR?=
 =?utf-8?B?TDRoS0pxTzBObDIxR29HVWRrcTNkSWdhU21NZ1pSbmM1MGhaZTVhbzhRUFZi?=
 =?utf-8?B?TURacmZkTVdRQVBjSmxCTnZ5VWoreHdMWmgwc05STThOemk5bWZJY0NsUm9X?=
 =?utf-8?B?ZWdDc3Q4eFRzMDNtTUJYMmN6OXdCN3hqZnI2bWVoSUpQVWdkTUVMQkNYUk9J?=
 =?utf-8?B?eEwyUS81Y2k4YnkveVBsMUh2cmltUStCZW9icmhpVlFMMHZ3bXk3T1FVa09Z?=
 =?utf-8?B?bmdOaFhUYlE1c2xjc0doc2Z4Y3J5UC9NdFk2WENmMy9aN2lmdW8vZDlTUkU2?=
 =?utf-8?B?WmVUZjFFbHRuUlA2bjBjb01yUzBWT1pISnpWdTBrUTFDODN5RW5Sa1ErMExK?=
 =?utf-8?B?enNwekkzTjJIakdMbG44b1B4ZlpTN016S3RCb2taOTNJRi9EMlZuSk1ST1Yy?=
 =?utf-8?B?eE5aTG5JeVQzMUM3eEdYdHRFUzFHTDNzdnlTNC9wWGovY2ZZK0ROTGdKZ0hC?=
 =?utf-8?B?WUdBWGJ3WUVuZmw0OXhEbjFrZjFIQzd0VnNaa2dkSldPMkxoblpwSTVGTWdG?=
 =?utf-8?B?dVVReGxwYkg1MEI5OXZhSVNqS2JsVnkzNlJsd2dieURJOVBPY1VyNnIzdHhY?=
 =?utf-8?B?N2J5VkR5aU4vcDBIdys5YW94WjdwNGZ4cnhUS2IrRjhSelpWQlVTWXJYWDBB?=
 =?utf-8?B?Z1hPNjBMR0ZCRGg5dGgvck81WHZSYlFBTEJGWWlnS0xZTkJ3TjBwY2F1Y09u?=
 =?utf-8?B?c2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <84A67FEEB997C543ABBDAD08FF053622@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffd0ad25-ebd2-475d-427b-08db0f9ce693
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 21:37:56.0626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UgP3gtQVfGJn0TgCRk7BIsw04tQg9qHP1pMPCOJR3FPTV2qN9ycF7BjbzwdEAHJIip9dFAZuCBrWTBl8W84mUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6106
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTAyLTE1IGF0IDE0OjI1ICswMTAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gV2VkLCBGZWIgMTUsIDIwMjMgYXQgMDk6NDY6MTBBTSArMDAwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gPiBZZXMgYWdyZWVkLiAgWW91ciBjb2RlIGJlbG93IGxvb2tzIGluZGVlZCBiZXR0
ZXIuICBUaGFua3MhDQo+ID4gDQo+ID4gV291bGQgeW91IG1pbmQgc2VuZCBtZSBhIHBhdGNoIHNv
IEkgY2FuIGluY2x1ZGUgdG8gdGhpcyBzZXJpZXMsIG9yIHdvdWxkIHlvdQ0KPiA+IG1pbmQgZ2V0
IGl0IG1lcmdlZCB0byB0aXAveDg2L3RkeCAob3Igb3RoZXIgYnJhbmNoIEkgYW0gbm90IHN1cmUp
IHNvIEkgY2FuDQo+ID4gcmViYXNlPw0KPiANCj4gSnVzdCB0YWtlIHRoZSBwYXRjaCwgYWRkIHlv
dXIgY29tbWVudHMgYW5kIHRlc3QgaXQuLiBlbmpveSEgOi0pDQoNClRoYW5rIHlvdSEgSSdsbCBh
dCBsZWFzdCBhZGQgeW91ciBTdWdnZXN0ZWQtYnkgOikNCg==
