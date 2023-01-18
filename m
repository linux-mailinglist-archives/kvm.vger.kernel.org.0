Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4260E671B37
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 12:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjARLtD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 06:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjARLqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 06:46:32 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B2D3253A;
        Wed, 18 Jan 2023 03:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674040139; x=1705576139;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QVZWgxFriouIWNTLxO45/giirV3e8oKDiAfznWtuip4=;
  b=jmg9rs7wGds0k14hQMd6aQnPx3RynRTLytdZ83FIH5MYvm1q/7qdukHb
   v5UiO8+qhwbTSXPYA8Luesie7pPtpHp1aLltrqX38mQ1SH3nGpWfOOTsc
   s5vlfJcnxJfPzSeBAzHZUAetORF2OdhB5t+37dme9mys72nDh4dhCt/sx
   my/4/Us17/nnF7XKakwzdGKGWao263sNbFsKlJK2qnBozs1Tvh3P+SbIu
   c7PbLHqs3rRdiedq6s0rgr/GGj2gD1N8j/WzciaoW+p3cXbBehakeoKFT
   1KhIvVYf+Nn6GxrmqLzljOP4yujJayiDqsau0WxBZk+S5fMDF6IOc3A3q
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="411196774"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="411196774"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 03:08:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="637241794"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="637241794"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 18 Jan 2023 03:08:58 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 03:08:58 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 03:08:58 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 03:08:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGgHc+Z9O7757Q12gYTtMeTa82JarTrG5pY/L4MwMuzrdxBEul134YEHvNotw6p3E5/ZQzclROLk52ai3cH9dDVnfaNTB+LVEcuVk35HqXv9r15hMlr93GTyJyI3TmIvgou1ojyH0szcVg/47bCUWR3qW1YUMb1s9sNXkabNSbP9NCbp8C2wUwTdIuig0HccLL4F7m098qtoKtMtDi28sWTXZZ/6AAYgA21JPt42y1aNrb1BCRbS565hq6GCDY1efnZoPoncVePaPt2JnkAAYww5oS4YCNORyN2IxwOoikjRXuJpy1ipSQEpGHV67FDpDjToHxp8dSGgnfil8ZFbHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QVZWgxFriouIWNTLxO45/giirV3e8oKDiAfznWtuip4=;
 b=gK3DM0fg7iHXY3wpsYrNAprasnEoJhsYGJ7cKgeTJJlVXTftjrDayR1i8tUwB1RiAWNiqCzSSJyYTBMCkCRZ5a1quTN0b5Zwlo58KZNwIEN/3v82qPJdRkyNjNV6mCtFkI4gfQSq4VR2UAapj0Xeov5c1eNodQFqjJKJyxVNDMSbrqYB7+CPo5uxBOT8xCS5vbTwFYS30r2kRLA7cjMpHa16VpzCT+BcXB34ttH6D397jjNpaOoCAQn67CVOjEDaRpO08ZsPkaRkHBHkRELFAXTTfaqBaDXppMvPYtvL6hnFwLUoSKRGzMhWLdREgQYzRpIqSA5dM1iMA1s6NMkTqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW3PR11MB4761.namprd11.prod.outlook.com (2603:10b6:303:53::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 11:08:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 11:08:53 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 07/16] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v8 07/16] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHZC5gLiOnJQQKFB0CM7X30zcZDS66kQ0wA
Date:   Wed, 18 Jan 2023 11:08:52 +0000
Message-ID: <7cdc03500a6affccac189164636427b348af2811.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <8aab33a7db7a408beb403950e21f693b0b0f1f2b.1670566861.git.kai.huang@intel.com>
In-Reply-To: <8aab33a7db7a408beb403950e21f693b0b0f1f2b.1670566861.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW3PR11MB4761:EE_
x-ms-office365-filtering-correlation-id: 32dd93fb-cf9b-456a-5300-08daf9446265
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A0q9OjfVy4osjQHVjO1mpzDpvUhPTnmY9zl+Na3JheXNZgZAmv52l4LDLoIKbMv/7D6zSFKFSdq300AP0Ku/5qOx1FHpVU0/usZAjBdjnW3zzPzXP/shJWHWudnjImE/NNbPtdFTHFMdVUTAl/EpryZ4UeKeM62yiXEYxIcKVsf45MCij7amq4vm8eZ2/VYTq59jSiEaBOQPb0ouyzynywplVNg0Qu1vJBW3OMZU5TquB+eKicxF9gQo9C2A2YWepJXK8UxPQXCO6GqPnz/HHc+LNZoBKyLcQ47I4hUZjwEV/XTMbzMApFfdOpjbXR2frDEN2xFjKa8Iyw0di+UAAP8KEQHNqDVjS+Lle+B+VGcMX7B3eeAH3TVnqZj8rBME6j2cIN88rPLgHGFP3vU1FP3pyiMqy3Px2F9fQrGdgGKF49+cf87w6mYrEATY8SpzSJaK0eag2bJoseO8u8Ag2+lj0A+veANttBwZoX7tP9s/io7QXFaIKxQ3rCZSPdx2bNNK8s3KddlV5vERQ+LIUo+5LWef2VofgP85xhWqmXnDqhcz/R9R3hetGU8lur6HinzEO22EgOogUyEf/LZ4Inmqrsm82HyIBHM2licuOrXTTmhMa2dhOvc8plYsY1FREIEnZcG1CeJkFRd6x+15RNPd7SdB3qUULxm6N7+st2jaklq+FSD+sR2c053E34kDLaf1hgmONAKUhVwUE9gzbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199015)(5660300002)(8936002)(41300700001)(91956017)(76116006)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(4326008)(36756003)(2906002)(7416002)(478600001)(71200400001)(6486002)(82960400001)(86362001)(2616005)(26005)(186003)(6512007)(6506007)(38070700005)(316002)(54906003)(110136005)(122000001)(38100700002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TzZmNnNNTDJqazVzSkZ1aGkveUx3c25VVUJOSDdvbmtNMUlwbG9KR3N0WXZp?=
 =?utf-8?B?dG9iM0JmRXJLMys0ajJCQVNXY3p3V0NjOFZEamJwcU5ibXJ3TGNKM0QvbmVV?=
 =?utf-8?B?b1RDZFV3MjNEaTlBZmYwTTZ1elc5WDM2M0p0RDNPVzlneURKWVhmSWdZdWxG?=
 =?utf-8?B?V1dSWDU1V1R4bEZLemQxVUZITjE1NFJPWGcweDJzQXVFUVRFeUo1RUhFcVJs?=
 =?utf-8?B?SXFCRG41ODlhdXBSVzUzT2w5OHdKcnZMcTBYZ2k5SXZTZ2xySmsyc3NqYnpT?=
 =?utf-8?B?RmpYV1VkOVVJT2xhQmk0cWVsUUh1cTVkcFdNY1NMaFR4ejRCbTJKMndCQWxp?=
 =?utf-8?B?VDE1N3FKREJ6Szh3T1BjUlpnVXA2dXY5TjlJTmhVUVQra0crMVFJVU5YUjJM?=
 =?utf-8?B?V0ZpVWh4RnE5V0EvTHhENVozSXAwK1laNkl0cGJKZVczcTlZeEdGVERTdHhE?=
 =?utf-8?B?Q2MzcFl2ek1vNWZnUTV2KzNOWllEV1l4S1c0QkV1SDBabG01S3k0TjEwMTFV?=
 =?utf-8?B?QzNxYjgzMUoyZ1FDbjVpbEw0WEJrd1lmOXBMcVBiVU1aRXVVTVRoOEYreWFH?=
 =?utf-8?B?WXVTQjFpVFRuREt4NXozZGlTZlNFVjNWVVNPNjRXM3pCZnNIT2dCM3RpaUxz?=
 =?utf-8?B?K0g2bU5sOERGTmtNNHJzeWFKM1VhcXVxcDluUTFIMytPYzkxRkdITlFZMStZ?=
 =?utf-8?B?MkVyWXRqeFlNaW8xL0duVTBiQUxkeU92UW8vSTM2OTc1NjJ5R1FESUF1UTRN?=
 =?utf-8?B?VloxaDBYRkdjMlBwOHBHRkZvU25weEhrK0YycTVpaDVzMkl6bEcxdXNTemtW?=
 =?utf-8?B?Wk11S1gzZXg3TzRhMnh2R0xnUEs4RVpOY0c2Zk1aVFYwelNHVjBPY3BxVDJq?=
 =?utf-8?B?dnNUcFdCVjBKZ2Y3K3F5QWZWMzRyZVhvVzRDMERWVllMN1ovbVg4MzRDMnVL?=
 =?utf-8?B?RUpuUjU4cTZRcSt0dThmOFJRenhKNDlBRkdGNVlsVEhWa00wM2xoeU5wYzBk?=
 =?utf-8?B?NW50ZWRiZmVCd1RkeGJENFdyZWlJbWFDR1FjL0F6d3lRVDNoRTF3UkNMVXln?=
 =?utf-8?B?emlzNXRSQzVqU1lZWXdkeTRzbzJ1Z3pob1hHWlRnOE5qdDBueDNCVW1idmVQ?=
 =?utf-8?B?SGt4TGxxb0s4YmsyZnQvYTV3ZWdmU2dvVnN2bUpWblY4RnBXd2RsamhnUkUy?=
 =?utf-8?B?TmNnVzU5MTVUa1hnZFc0OGJUa3lHSGkzTktwNVFKeXNoZWJPblI5UHBxQVVS?=
 =?utf-8?B?VkNNU2lVMjhybXNQMWxwcE4zc2VsaFJHZGh2ckkxbGFzL09ObUxFbHBFS0Za?=
 =?utf-8?B?RFdnYUtkTzZZNE1pbkJqWm8weXJIYXhuelQ2UEFaSnA3RkdrRHJ5SmNmNmhY?=
 =?utf-8?B?SytIRXphRXJFaWQrbWM2U1A1NllDeDhST1BKekhvR2d1U1pibU5IQXkvTjBC?=
 =?utf-8?B?R3E1aUZ1eldWcWZLZ2ltUjRiNDN2S2lRejNiQmR0d1lsdnM4REVyQjhhakJw?=
 =?utf-8?B?QXVhc2hQcWRBTkpsVW13UHc3NmR2MVNlaXFjdnlCYmpGdXFweXNKZUdsV0RJ?=
 =?utf-8?B?VGxBMndDQWt1TmdLalZmRDFGMVBiOEVqVnF2UC9CUW5PWWtNUGJXR2JtUjVh?=
 =?utf-8?B?ZmRRUGF5OGhaZm5tanFVT0FjL1dLQWVpZkZhYUEyYkZ6VzYwdGkvNUpTMWFz?=
 =?utf-8?B?anAvU1NlcmVIeXE4aUYycmdTdTVtLzN3NGpNcVlwL1lKTGtxU2E0SnhlVzA0?=
 =?utf-8?B?U3FLbTQzc3JPdUFZR3lrUEIvU28vb3ArT0kyaFZWN2IwYmdVSUI4NUNTeUp4?=
 =?utf-8?B?bXQ1QkRNQlBFb09ZWlpPd3NRdHN3aVRMcEkyZmRxMXpwQ2hBck1INWhZbmtY?=
 =?utf-8?B?Mkhvd3NGa2RlQlJBdmRXa1gyR3d5TFhOK09PdHpsVytBZW5CY1MrWFJxeTIr?=
 =?utf-8?B?S2RZNkZ5S2lsOStNZjZ6UUdyODNRMlJuTnNTSmtFNjUxV0Q3N3N6bDRDNS9M?=
 =?utf-8?B?MVVPNEFIRGNFdUcyV3JHaXJpaEVvMCs5YlozTVlJZmErcUlWdWtzVXhjZ0p2?=
 =?utf-8?B?R3B5WXo5KytiTUpQREpFY3pFRlFjWGU4SnMxUDh6YnNpeHJrVjE3SlBtMGpn?=
 =?utf-8?B?OVJkei80SEw2UmQzTUVLeVZmRE96THVaaHAyeXFKdzVGWFVOQ2RTOVBUOHRD?=
 =?utf-8?B?WlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B4C025DFD99C54D987A81E14042ED20@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32dd93fb-cf9b-456a-5300-08daf9446265
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 11:08:52.9777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xdd2tIoeFct0UQ3H5Na/mwJ3LO1M4RroVaxNNEwQz5kiKizTXOi9XgJuboxdu58ifldaaMSb8IJbnL5SiuozFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4761
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

K0RhdmUsIE9zY2FyIGFuZCBBbmRyZXcuDQoNCkhpIE1lbW9yeSBob3RwbHVnIG1haW50YWluZXJz
LA0KDQpTb3JyeSB0byBDQywgYnV0IGNvdWxkIHlvdSBoZWxwIHRvIHJldmlldyB0aGlzIEludGVs
IFREWCAoVHJ1c3RlZCBEb21haW4NCkV4dGVuc2lvbnMpIHBhdGNoLCBzaW5jZSBpdCBpcyByZWxh
dGVkIHRvIG1lbW9yeSBob3RwbHVnIChub3QgbW9kaWZ5aW5nIGFueQ0KY29tbW9uIG1lbW9yeSBo
b3RwbHVnIGRpcmVjdGx5LCB0aG91Z2gpPyAgRGF2ZSBzdWdnZXN0ZWQgaXQncyBiZXR0ZXIgdG8g
Z2V0DQptZW1vcnkgaG90cGx1ZyBndXlzIHRvIGhlbHAgdG8gcmV2aWV3IHNvb25lciB0aGFuIGxh
dGVyLg0KDQpUaGlzIHdob2xlIHNlcmllcyBhbHJlYWR5IGhhcyBsaW51eC1tbUBrdmFjay5vcmcg
aW4gdGhlIENDIGxpc3QuICBUaGFua3MgZm9yDQp5b3VyIHRpbWUuDQoNCk9uIEZyaSwgMjAyMi0x
Mi0wOSBhdCAxOTo1MiArMTMwMCwgS2FpIEh1YW5nIHdyb3RlOg0KPiBBcyBhIHN0ZXAgb2YgaW5p
dGlhbGl6aW5nIHRoZSBURFggbW9kdWxlLCB0aGUga2VybmVsIG5lZWRzIHRvIHRlbGwgdGhlDQo+
IFREWCBtb2R1bGUgd2hpY2ggbWVtb3J5IHJlZ2lvbnMgY2FuIGJlIHVzZWQgYnkgdGhlIFREWCBt
b2R1bGUgYXMgVERYDQo+IGd1ZXN0IG1lbW9yeS4NCj4gDQo+IFREWCByZXBvcnRzIGEgbGlzdCBv
ZiAiQ29udmVydGlibGUgTWVtb3J5IFJlZ2lvbiIgKENNUikgdG8gdGVsbCB0aGUNCj4ga2VybmVs
IHdoaWNoIG1lbW9yeSBpcyBURFggY29tcGF0aWJsZS4gIFRoZSBrZXJuZWwgbmVlZHMgdG8gYnVp
bGQgYSBsaXN0DQo+IG9mIG1lbW9yeSByZWdpb25zIChvdXQgb2YgQ01ScykgYXMgIlREWC11c2Fi
bGUiIG1lbW9yeSBhbmQgcGFzcyB0aGVtIHRvDQo+IHRoZSBURFggbW9kdWxlLiAgT25jZSB0aGlz
IGlzIGRvbmUsIHRob3NlICJURFgtdXNhYmxlIiBtZW1vcnkgcmVnaW9ucw0KPiBhcmUgZml4ZWQg
ZHVyaW5nIG1vZHVsZSdzIGxpZmV0aW1lLg0KPiANCj4gVGhlIGluaXRpYWwgc3VwcG9ydCBvZiBU
RFggZ3Vlc3RzIHdpbGwgb25seSBhbGxvY2F0ZSBURFggZ3Vlc3QgbWVtb3J5DQo+IGZyb20gdGhl
IGdsb2JhbCBwYWdlIGFsbG9jYXRvci4gIFRvIGtlZXAgdGhpbmdzIHNpbXBsZSwganVzdCBtYWtl
IHN1cmUNCj4gYWxsIHBhZ2VzIGluIHRoZSBwYWdlIGFsbG9jYXRvciBhcmUgVERYIG1lbW9yeS4N
Cj4gDQo+IFRvIGd1YXJhbnRlZSB0aGF0LCBzdGFzaCBvZmYgdGhlIG1lbWJsb2NrIG1lbW9yeSBy
ZWdpb25zIGF0IHRoZSB0aW1lIG9mDQo+IGluaXRpYWxpemluZyB0aGUgVERYIG1vZHVsZSBhcyBU
RFgncyBvd24gdXNhYmxlIG1lbW9yeSByZWdpb25zLCBhbmQgaW4NCj4gdGhlIG1lYW50aW1lLCBy
ZWdpc3RlciBhIFREWCBtZW1vcnkgbm90aWZpZXIgdG8gcmVqZWN0IHRvIG9ubGluZSBhbnkgbmV3
DQo+IG1lbW9yeSBpbiBtZW1vcnkgaG90cGx1Zy4NCj4gDQo+IFRoaXMgYXBwcm9hY2ggd29ya3Mg
YXMgaW4gcHJhY3RpY2UgYWxsIGJvb3QtdGltZSBwcmVzZW50IERJTU1zIGFyZSBURFgNCj4gY29u
dmVydGlibGUgbWVtb3J5LiAgSG93ZXZlciwgaWYgYW55IG5vbi1URFgtY29udmVydGlibGUgbWVt
b3J5IGhhcyBiZWVuDQo+IGhvdC1hZGRlZCAoaS5lLiBDWEwgbWVtb3J5IHZpYSBrbWVtIGRyaXZl
cikgYmVmb3JlIGluaXRpYWxpemluZyB0aGUgVERYDQo+IG1vZHVsZSwgdGhlIG1vZHVsZSBpbml0
aWFsaXphdGlvbiB3aWxsIGZhaWwuDQo+IA0KPiBUaGlzIGNhbiBhbHNvIGJlIGVuaGFuY2VkIGlu
IHRoZSBmdXR1cmUsIGkuZS4gYnkgYWxsb3dpbmcgYWRkaW5nIG5vbi1URFgNCj4gbWVtb3J5IHRv
IGEgc2VwYXJhdGUgTlVNQSBub2RlLiAgSW4gdGhpcyBjYXNlLCB0aGUgIlREWC1jYXBhYmxlIiBu
b2Rlcw0KPiBhbmQgdGhlICJub24tVERYLWNhcGFibGUiIG5vZGVzIGNhbiBjby1leGlzdCwgYnV0
IHRoZSBrZXJuZWwvdXNlcnNwYWNlDQo+IG5lZWRzIHRvIGd1YXJhbnRlZSBtZW1vcnkgcGFnZXMg
Zm9yIFREWCBndWVzdHMgYXJlIGFsd2F5cyBhbGxvY2F0ZWQgZnJvbQ0KPiB0aGUgIlREWC1jYXBh
YmxlIiBub2Rlcy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGlu
dGVsLmNvbT4NCj4gLS0tDQo+IA0KPiB2NyAtPiB2ODoNCj4gIC0gVHJpbWVkIGRvd24gY2hhbmdl
bG9nIChEYXZlKS4NCj4gIC0gQ2hhbmdlZCB0byB1c2UgUEhZU19QRk4oKSBhbmQgUEZOX1BIWVMo
KSB0aHJvdWdob3V0IHRoaXMgc2VyaWVzDQo+ICAgIChZaW5nKS4NCj4gIC0gTW92ZWQgbWVtb3J5
IGhvdHBsdWcgaGFuZGxpbmcgZnJvbSBhZGRfYXJjaF9tZW1vcnkoKSB0bw0KPiAgICBtZW1vcnlf
bm90aWZpZXIgKERhbi9EYXZpZCkuDQo+ICAtIFJlbW92ZWQgJ25pZCcgZnJvbSAnc3RydWN0IHRk
eF9tZW1ibG9jaycgdG8gbGF0ZXIgcGF0Y2ggKERhdmUpLg0KPiAgLSB7YnVpbGR8ZnJlZX1fdGR4
X21lbW9yeSgpIC0+IHtidWlsZHx9ZnJlZV90ZHhfbWVtbGlzdCgpIChEYXZlKS4NCj4gIC0gUmVt
b3ZlZCBwZm5fY292ZXJlZF9ieV9jbXIoKSBjaGVjayBhcyBubyBjb2RlIHRvIHRyaW0gQ01ScyBu
b3cuDQo+ICAtIEltcHJvdmUgdGhlIGNvbW1lbnQgYXJvdW5kIGZpcnN0IDFNQiAoRGF2ZSkuDQo+
ICAtIEFkZGVkIGEgY29tbWVudCBhcm91bmQgcmVzZXJ2ZV9yZWFsX21vZGUoKSB0byBwb2ludCBv
dXQgVERYIGNvZGUNCj4gICAgcmVsaWVzIG9uIGZpcnN0IDFNQiBiZWluZyByZXNlcnZlZCAoWWlu
ZykuDQo+ICAtIEFkZGVkIGNvbW1lbnQgdG8gZXhwbGFpbiB3aHkgdGhlIG5ldyBvbmxpbmUgbWVt
b3J5IHJhbmdlIGNhbm5vdA0KPiAgICBjcm9zcyBtdWx0aXBsZSBURFggbWVtb3J5IGJsb2NrcyAo
RGF2ZSkuDQo+ICAtIEltcHJvdmVkIG90aGVyIGNvbW1lbnRzIChEYXZlKS4NCj4gDQo+IC0tLQ0K
PiAgYXJjaC94ODYvS2NvbmZpZyAgICAgICAgICAgIHwgICAxICsNCj4gIGFyY2gveDg2L2tlcm5l
bC9zZXR1cC5jICAgICB8ICAgMiArDQo+ICBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgfCAx
NjAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystDQo+ICAzIGZpbGVzIGNoYW5n
ZWQsIDE2MiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
YXJjaC94ODYvS2NvbmZpZyBiL2FyY2gveDg2L0tjb25maWcNCj4gaW5kZXggZGQzMzNiNDZmYWZi
Li5iMzYxMjkxODMwMzUgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L0tjb25maWcNCj4gKysrIGIv
YXJjaC94ODYvS2NvbmZpZw0KPiBAQCAtMTk1OSw2ICsxOTU5LDcgQEAgY29uZmlnIElOVEVMX1RE
WF9IT1NUDQo+ICAJZGVwZW5kcyBvbiBYODZfNjQNCj4gIAlkZXBlbmRzIG9uIEtWTV9JTlRFTA0K
PiAgCWRlcGVuZHMgb24gWDg2X1gyQVBJQw0KPiArCXNlbGVjdCBBUkNIX0tFRVBfTUVNQkxPQ0sN
Cj4gIAloZWxwDQo+ICAJICBJbnRlbCBUcnVzdCBEb21haW4gRXh0ZW5zaW9ucyAoVERYKSBwcm90
ZWN0cyBndWVzdCBWTXMgZnJvbSBtYWxpY2lvdXMNCj4gIAkgIGhvc3QgYW5kIGNlcnRhaW4gcGh5
c2ljYWwgYXR0YWNrcy4gIFRoaXMgb3B0aW9uIGVuYWJsZXMgbmVjZXNzYXJ5IFREWA0KPiBkaWZm
IC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL3NldHVwLmMgYi9hcmNoL3g4Ni9rZXJuZWwvc2V0dXAu
Yw0KPiBpbmRleCAyMTZmZWU3MTQ0ZWUuLjNhODQxYTc3ZmRhNCAxMDA2NDQNCj4gLS0tIGEvYXJj
aC94ODYva2VybmVsL3NldHVwLmMNCj4gKysrIGIvYXJjaC94ODYva2VybmVsL3NldHVwLmMNCj4g
QEAgLTExNzQsNiArMTE3NCw4IEBAIHZvaWQgX19pbml0IHNldHVwX2FyY2goY2hhciAqKmNtZGxp
bmVfcCkNCj4gIAkgKg0KPiAgCSAqIE1vcmVvdmVyLCBvbiBtYWNoaW5lcyB3aXRoIFNhbmR5QnJp
ZGdlIGdyYXBoaWNzIG9yIGluIHNldHVwcyB0aGF0IHVzZQ0KPiAgCSAqIGNyYXNoa2VybmVsIHRo
ZSBlbnRpcmUgMU0gaXMgcmVzZXJ2ZWQgYW55d2F5Lg0KPiArCSAqDQo+ICsJICogTm90ZSB0aGUg
aG9zdCBrZXJuZWwgVERYIGFsc28gcmVxdWlyZXMgdGhlIGZpcnN0IDFNQiBiZWluZyByZXNlcnZl
ZC4NCj4gIAkgKi8NCj4gIAlyZXNlcnZlX3JlYWxfbW9kZSgpOw0KPiAgDQo+IGRpZmYgLS1naXQg
YS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4
LmMNCj4gaW5kZXggNmZlNTA1YzMyNTk5Li5mMDEwNDAyZjQ0M2QgMTAwNjQ0DQo+IC0tLSBhL2Fy
Y2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiArKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgv
dGR4LmMNCj4gQEAgLTEzLDYgKzEzLDEzIEBADQo+ICAjaW5jbHVkZSA8bGludXgvZXJybm8uaD4N
Cj4gICNpbmNsdWRlIDxsaW51eC9wcmludGsuaD4NCj4gICNpbmNsdWRlIDxsaW51eC9tdXRleC5o
Pg0KPiArI2luY2x1ZGUgPGxpbnV4L2xpc3QuaD4NCj4gKyNpbmNsdWRlIDxsaW51eC9zbGFiLmg+
DQo+ICsjaW5jbHVkZSA8bGludXgvbWVtYmxvY2suaD4NCj4gKyNpbmNsdWRlIDxsaW51eC9tZW1v
cnkuaD4NCj4gKyNpbmNsdWRlIDxsaW51eC9taW5tYXguaD4NCj4gKyNpbmNsdWRlIDxsaW51eC9z
aXplcy5oPg0KPiArI2luY2x1ZGUgPGxpbnV4L3Bmbi5oPg0KPiAgI2luY2x1ZGUgPGFzbS9wZ3Rh
YmxlX3R5cGVzLmg+DQo+ICAjaW5jbHVkZSA8YXNtL21zci5oPg0KPiAgI2luY2x1ZGUgPGFzbS90
ZHguaD4NCj4gQEAgLTI1LDYgKzMyLDEyIEBAIGVudW0gdGR4X21vZHVsZV9zdGF0dXNfdCB7DQo+
ICAJVERYX01PRFVMRV9FUlJPUg0KPiAgfTsNCj4gIA0KPiArc3RydWN0IHRkeF9tZW1ibG9jayB7
DQo+ICsJc3RydWN0IGxpc3RfaGVhZCBsaXN0Ow0KPiArCXVuc2lnbmVkIGxvbmcgc3RhcnRfcGZu
Ow0KPiArCXVuc2lnbmVkIGxvbmcgZW5kX3BmbjsNCj4gK307DQo+ICsNCj4gIHN0YXRpYyB1MzIg
dGR4X2tleWlkX3N0YXJ0IF9fcm9fYWZ0ZXJfaW5pdDsNCj4gIHN0YXRpYyB1MzIgbnJfdGR4X2tl
eWlkcyBfX3JvX2FmdGVyX2luaXQ7DQo+ICANCj4gQEAgLTMyLDYgKzQ1LDkgQEAgc3RhdGljIGVu
dW0gdGR4X21vZHVsZV9zdGF0dXNfdCB0ZHhfbW9kdWxlX3N0YXR1czsNCj4gIC8qIFByZXZlbnQg
Y29uY3VycmVudCBhdHRlbXB0cyBvbiBURFggZGV0ZWN0aW9uIGFuZCBpbml0aWFsaXphdGlvbiAq
Lw0KPiAgc3RhdGljIERFRklORV9NVVRFWCh0ZHhfbW9kdWxlX2xvY2spOw0KPiAgDQo+ICsvKiBB
bGwgVERYLXVzYWJsZSBtZW1vcnkgcmVnaW9ucyAqLw0KPiArc3RhdGljIExJU1RfSEVBRCh0ZHhf
bWVtbGlzdCk7DQo+ICsNCj4gIC8qDQo+ICAgKiB0ZHhfa2V5aWRfc3RhcnQgYW5kIG5yX3RkeF9r
ZXlpZHMgaW5kaWNhdGUgdGhhdCBURFggaXMgdW5pbml0aWFsaXplZC4NCj4gICAqIFRoaXMgaXMg
dXNlZCBpbiBURFggaW5pdGlhbGl6YXRpb24gZXJyb3IgcGF0aHMgdG8gdGFrZSBpdCBmcm9tDQo+
IEBAIC02OSw2ICs4NSw1MCBAQCBzdGF0aWMgaW50IF9faW5pdCByZWNvcmRfa2V5aWRfcGFydGl0
aW9uaW5nKHZvaWQpDQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+ICANCj4gK3N0YXRpYyBib29sIGlz
X3RkeF9tZW1vcnkodW5zaWduZWQgbG9uZyBzdGFydF9wZm4sIHVuc2lnbmVkIGxvbmcgZW5kX3Bm
bikNCj4gK3sNCj4gKwlzdHJ1Y3QgdGR4X21lbWJsb2NrICp0bWI7DQo+ICsNCj4gKwkvKiBFbXB0
eSBsaXN0IG1lYW5zIFREWCBpc24ndCBlbmFibGVkLiAqLw0KPiArCWlmIChsaXN0X2VtcHR5KCZ0
ZHhfbWVtbGlzdCkpDQo+ICsJCXJldHVybiB0cnVlOw0KPiArDQo+ICsJbGlzdF9mb3JfZWFjaF9l
bnRyeSh0bWIsICZ0ZHhfbWVtbGlzdCwgbGlzdCkgew0KPiArCQkvKg0KPiArCQkgKiBUaGUgbmV3
IHJhbmdlIGlzIFREWCBtZW1vcnkgaWYgaXQgaXMgZnVsbHkgY292ZXJlZCBieQ0KPiArCQkgKiBh
bnkgVERYIG1lbW9yeSBibG9jay4NCj4gKwkJICoNCj4gKwkJICogTm90ZSBURFggbWVtb3J5IGJs
b2NrcyBhcmUgb3JpZ2luYXRlZCBmcm9tIG1lbWJsb2NrDQo+ICsJCSAqIG1lbW9yeSByZWdpb25z
LCB3aGljaCBjYW4gb25seSBiZSBjb250aWd1b3VzIHdoZW4gdHdvDQo+ICsJCSAqIHJlZ2lvbnMg
aGF2ZSBkaWZmZXJlbnQgTlVNQSBub2RlcyBvciBmbGFncy4gIFRoZXJlZm9yZQ0KPiArCQkgKiB0
aGUgbmV3IHJhbmdlIGNhbm5vdCBjcm9zcyBtdWx0aXBsZSBURFggbWVtb3J5IGJsb2Nrcy4NCj4g
KwkJICovDQo+ICsJCWlmIChzdGFydF9wZm4gPj0gdG1iLT5zdGFydF9wZm4gJiYgZW5kX3BmbiA8
PSB0bWItPmVuZF9wZm4pDQo+ICsJCQlyZXR1cm4gdHJ1ZTsNCj4gKwl9DQo+ICsJcmV0dXJuIGZh
bHNlOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMgaW50IHRkeF9tZW1vcnlfbm90aWZpZXIoc3RydWN0
IG5vdGlmaWVyX2Jsb2NrICpuYiwgdW5zaWduZWQgbG9uZyBhY3Rpb24sDQo+ICsJCQkgICAgICAg
dm9pZCAqdikNCj4gK3sNCj4gKwlzdHJ1Y3QgbWVtb3J5X25vdGlmeSAqbW4gPSB2Ow0KPiArDQo+
ICsJaWYgKGFjdGlvbiAhPSBNRU1fR09JTkdfT05MSU5FKQ0KPiArCQlyZXR1cm4gTk9USUZZX09L
Ow0KPiArDQo+ICsJLyoNCj4gKwkgKiBOb3QgYWxsIG1lbW9yeSBpcyBjb21wYXRpYmxlIHdpdGgg
VERYLiAgUmVqZWN0DQo+ICsJICogdG8gb25saW5lIGFueSBpbmNvbXBhdGlibGUgbWVtb3J5Lg0K
PiArCSAqLw0KPiArCXJldHVybiBpc190ZHhfbWVtb3J5KG1uLT5zdGFydF9wZm4sIG1uLT5zdGFy
dF9wZm4gKyBtbi0+bnJfcGFnZXMpID8NCj4gKwkJTk9USUZZX09LIDogTk9USUZZX0JBRDsNCj4g
K30NCj4gKw0KPiArc3RhdGljIHN0cnVjdCBub3RpZmllcl9ibG9jayB0ZHhfbWVtb3J5X25iID0g
ew0KPiArCS5ub3RpZmllcl9jYWxsID0gdGR4X21lbW9yeV9ub3RpZmllciwNCj4gK307DQo+ICsN
Cj4gIHN0YXRpYyBpbnQgX19pbml0IHRkeF9pbml0KHZvaWQpDQo+ICB7DQo+ICAJaW50IGVycjsN
Cj4gQEAgLTg5LDYgKzE0OSwxMyBAQCBzdGF0aWMgaW50IF9faW5pdCB0ZHhfaW5pdCh2b2lkKQ0K
PiAgCQlnb3RvIG5vX3RkeDsNCj4gIAl9DQo+ICANCj4gKwllcnIgPSByZWdpc3Rlcl9tZW1vcnlf
bm90aWZpZXIoJnRkeF9tZW1vcnlfbmIpOw0KPiArCWlmIChlcnIpIHsNCj4gKwkJcHJfaW5mbygi
aW5pdGlhbGl6YXRpb24gZmFpbGVkOiByZWdpc3Rlcl9tZW1vcnlfbm90aWZpZXIoKSBmYWlsZWQg
KCVkKVxuIiwNCj4gKwkJCQllcnIpOw0KPiArCQlnb3RvIG5vX3RkeDsNCj4gKwl9DQo+ICsNCj4g
IAlyZXR1cm4gMDsNCj4gIG5vX3RkeDoNCj4gIAljbGVhcl90ZHgoKTsNCj4gQEAgLTIwOSw2ICsy
NzYsNzcgQEAgc3RhdGljIGludCB0ZHhfZ2V0X3N5c2luZm8oc3RydWN0IHRkc3lzaW5mb19zdHJ1
Y3QgKnN5c2luZm8sDQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+ICANCj4gKy8qDQo+ICsgKiBBZGQg
YSBtZW1vcnkgcmVnaW9uIGFzIGEgVERYIG1lbW9yeSBibG9jay4gIFRoZSBjYWxsZXIgbXVzdCBt
YWtlIHN1cmUNCj4gKyAqIGFsbCBtZW1vcnkgcmVnaW9ucyBhcmUgYWRkZWQgaW4gYWRkcmVzcyBh
c2NlbmRpbmcgb3JkZXIgYW5kIGRvbid0DQo+ICsgKiBvdmVybGFwLg0KPiArICovDQo+ICtzdGF0
aWMgaW50IGFkZF90ZHhfbWVtYmxvY2soc3RydWN0IGxpc3RfaGVhZCAqdG1iX2xpc3QsIHVuc2ln
bmVkIGxvbmcgc3RhcnRfcGZuLA0KPiArCQkJICAgIHVuc2lnbmVkIGxvbmcgZW5kX3BmbikNCj4g
K3sNCj4gKwlzdHJ1Y3QgdGR4X21lbWJsb2NrICp0bWI7DQo+ICsNCj4gKwl0bWIgPSBrbWFsbG9j
KHNpemVvZigqdG1iKSwgR0ZQX0tFUk5FTCk7DQo+ICsJaWYgKCF0bWIpDQo+ICsJCXJldHVybiAt
RU5PTUVNOw0KPiArDQo+ICsJSU5JVF9MSVNUX0hFQUQoJnRtYi0+bGlzdCk7DQo+ICsJdG1iLT5z
dGFydF9wZm4gPSBzdGFydF9wZm47DQo+ICsJdG1iLT5lbmRfcGZuID0gZW5kX3BmbjsNCj4gKw0K
PiArCWxpc3RfYWRkX3RhaWwoJnRtYi0+bGlzdCwgdG1iX2xpc3QpOw0KPiArCXJldHVybiAwOw0K
PiArfQ0KPiArDQo+ICtzdGF0aWMgdm9pZCBmcmVlX3RkeF9tZW1saXN0KHN0cnVjdCBsaXN0X2hl
YWQgKnRtYl9saXN0KQ0KPiArew0KPiArCXdoaWxlICghbGlzdF9lbXB0eSh0bWJfbGlzdCkpIHsN
Cj4gKwkJc3RydWN0IHRkeF9tZW1ibG9jayAqdG1iID0gbGlzdF9maXJzdF9lbnRyeSh0bWJfbGlz
dCwNCj4gKwkJCQlzdHJ1Y3QgdGR4X21lbWJsb2NrLCBsaXN0KTsNCj4gKw0KPiArCQlsaXN0X2Rl
bCgmdG1iLT5saXN0KTsNCj4gKwkJa2ZyZWUodG1iKTsNCj4gKwl9DQo+ICt9DQo+ICsNCj4gKy8q
DQo+ICsgKiBFbnN1cmUgdGhhdCBhbGwgbWVtYmxvY2sgbWVtb3J5IHJlZ2lvbnMgYXJlIGNvbnZl
cnRpYmxlIHRvIFREWA0KPiArICogbWVtb3J5LiAgT25jZSB0aGlzIGhhcyBiZWVuIGVzdGFibGlz
aGVkLCBzdGFzaCB0aGUgbWVtYmxvY2sNCj4gKyAqIHJhbmdlcyBvZmYgaW4gYSBzZWNvbmRhcnkg
c3RydWN0dXJlIGJlY2F1c2UgbWVtYmxvY2sgaXMgbW9kaWZpZWQNCj4gKyAqIGluIG1lbW9yeSBo
b3RwbHVnIHdoaWxlIFREWCBtZW1vcnkgcmVnaW9ucyBhcmUgZml4ZWQuDQo+ICsgKi8NCj4gK3N0
YXRpYyBpbnQgYnVpbGRfdGR4X21lbWxpc3Qoc3RydWN0IGxpc3RfaGVhZCAqdG1iX2xpc3QpDQo+
ICt7DQo+ICsJdW5zaWduZWQgbG9uZyBzdGFydF9wZm4sIGVuZF9wZm47DQo+ICsJaW50IGksIHJl
dDsNCj4gKw0KPiArCWZvcl9lYWNoX21lbV9wZm5fcmFuZ2UoaSwgTUFYX05VTU5PREVTLCAmc3Rh
cnRfcGZuLCAmZW5kX3BmbiwgTlVMTCkgew0KPiArCQkvKg0KPiArCQkgKiBUaGUgZmlyc3QgMU1C
IGlzIG5vdCByZXBvcnRlZCBhcyBURFggY29udmVydGlibGUgbWVtb3J5Lg0KPiArCQkgKiBBbHRo
b3VnaCB0aGUgZmlyc3QgMU1CIGlzIGFsd2F5cyByZXNlcnZlZCBhbmQgd29uJ3QgZW5kIHVwDQo+
ICsJCSAqIHRvIHRoZSBwYWdlIGFsbG9jYXRvciwgaXQgaXMgc3RpbGwgaW4gbWVtYmxvY2sncyBt
ZW1vcnkNCj4gKwkJICogcmVnaW9ucy4gIFNraXAgdGhlbSBtYW51YWxseSB0byBleGNsdWRlIHRo
ZW0gYXMgVERYIG1lbW9yeS4NCj4gKwkJICovDQo+ICsJCXN0YXJ0X3BmbiA9IG1heChzdGFydF9w
Zm4sIFBIWVNfUEZOKFNaXzFNKSk7DQo+ICsJCWlmIChzdGFydF9wZm4gPj0gZW5kX3BmbikNCj4g
KwkJCWNvbnRpbnVlOw0KPiArDQo+ICsJCS8qDQo+ICsJCSAqIEFkZCB0aGUgbWVtb3J5IHJlZ2lv
bnMgYXMgVERYIG1lbW9yeS4gIFRoZSByZWdpb25zIGluDQo+ICsJCSAqIG1lbWJsb2NrIGhhcyBh
bHJlYWR5IGd1YXJhbnRlZWQgdGhleSBhcmUgaW4gYWRkcmVzcw0KPiArCQkgKiBhc2NlbmRpbmcg
b3JkZXIgYW5kIGRvbid0IG92ZXJsYXAuDQo+ICsJCSAqLw0KPiArCQlyZXQgPSBhZGRfdGR4X21l
bWJsb2NrKHRtYl9saXN0LCBzdGFydF9wZm4sIGVuZF9wZm4pOw0KPiArCQlpZiAocmV0KQ0KPiAr
CQkJZ290byBlcnI7DQo+ICsJfQ0KPiArDQo+ICsJcmV0dXJuIDA7DQo+ICtlcnI6DQo+ICsJZnJl
ZV90ZHhfbWVtbGlzdCh0bWJfbGlzdCk7DQo+ICsJcmV0dXJuIHJldDsNCj4gK30NCj4gKw0KPiAg
c3RhdGljIGludCBpbml0X3RkeF9tb2R1bGUodm9pZCkNCj4gIHsNCj4gIAkvKg0KPiBAQCAtMjI2
LDEwICszNjQsMjUgQEAgc3RhdGljIGludCBpbml0X3RkeF9tb2R1bGUodm9pZCkNCj4gIAlpZiAo
cmV0KQ0KPiAgCQlnb3RvIG91dDsNCj4gIA0KPiArCS8qDQo+ICsJICogVGhlIGluaXRpYWwgc3Vw
cG9ydCBvZiBURFggZ3Vlc3RzIG9ubHkgYWxsb2NhdGVzIG1lbW9yeSBmcm9tDQo+ICsJICogdGhl
IGdsb2JhbCBwYWdlIGFsbG9jYXRvci4gIFRvIGtlZXAgdGhpbmdzIHNpbXBsZSwganVzdCBtYWtl
DQo+ICsJICogc3VyZSBhbGwgcGFnZXMgaW4gdGhlIHBhZ2UgYWxsb2NhdG9yIGFyZSBURFggbWVt
b3J5Lg0KPiArCSAqDQo+ICsJICogQnVpbGQgdGhlIGxpc3Qgb2YgIlREWC11c2FibGUiIG1lbW9y
eSByZWdpb25zIHdoaWNoIGNvdmVyIGFsbA0KPiArCSAqIHBhZ2VzIGluIHRoZSBwYWdlIGFsbG9j
YXRvciB0byBndWFyYW50ZWUgdGhhdC4gIERvIGl0IHdoaWxlDQo+ICsJICogaG9sZGluZyBtZW1f
aG90cGx1Z19sb2NrIHJlYWQtbG9jayBhcyB0aGUgbWVtb3J5IGhvdHBsdWcgY29kZQ0KPiArCSAq
IHBhdGggcmVhZHMgdGhlIEB0ZHhfbWVtbGlzdCB0byByZWplY3QgYW55IG5ldyBtZW1vcnkuDQo+
ICsJICovDQo+ICsJZ2V0X29ubGluZV9tZW1zKCk7DQo+ICsNCj4gKwlyZXQgPSBidWlsZF90ZHhf
bWVtbGlzdCgmdGR4X21lbWxpc3QpOw0KPiArCWlmIChyZXQpDQo+ICsJCWdvdG8gb3V0Ow0KPiAr
DQo+ICAJLyoNCj4gIAkgKiBUT0RPOg0KPiAgCSAqDQo+IC0JICogIC0gQnVpbGQgdGhlIGxpc3Qg
b2YgVERYLXVzYWJsZSBtZW1vcnkgcmVnaW9ucy4NCj4gIAkgKiAgLSBDb25zdHJ1Y3QgYSBsaXN0
IG9mIFRETVJzIHRvIGNvdmVyIGFsbCBURFgtdXNhYmxlIG1lbW9yeQ0KPiAgCSAqICAgIHJlZ2lv
bnMuDQo+ICAJICogIC0gUGljayB1cCBvbmUgVERYIHByaXZhdGUgS2V5SUQgYXMgdGhlIGdsb2Jh
bCBLZXlJRC4NCj4gQEAgLTI0MSw2ICszOTQsMTEgQEAgc3RhdGljIGludCBpbml0X3RkeF9tb2R1
bGUodm9pZCkNCj4gIAkgKi8NCj4gIAlyZXQgPSAtRUlOVkFMOw0KPiAgb3V0Og0KPiArCS8qDQo+
ICsJICogQHRkeF9tZW1saXN0IGlzIHdyaXR0ZW4gaGVyZSBhbmQgcmVhZCBhdCBtZW1vcnkgaG90
cGx1ZyB0aW1lLg0KPiArCSAqIExvY2sgb3V0IG1lbW9yeSBob3RwbHVnIGNvZGUgd2hpbGUgYnVp
bGRpbmcgaXQuDQo+ICsJICovDQo+ICsJcHV0X29ubGluZV9tZW1zKCk7DQo+ICAJcmV0dXJuIHJl
dDsNCj4gIH0NCj4gIA0KDQo=
