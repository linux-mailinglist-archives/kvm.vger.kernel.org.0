Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6316405A9
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 12:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbiLBLUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 06:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbiLBLUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 06:20:04 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3971E1180C;
        Fri,  2 Dec 2022 03:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669980003; x=1701516003;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YDPdJjpR2s/H9LxmpO+QNeOuROk3h+wWiYuUr+isZf8=;
  b=bwigNU9TRmU7AatmcMihRx4Z3HkD/IWWUUCxHcOp8ki+6N6T+yjLJEoR
   yXEVC+4XRNLRRaPZj+sMAMZ/RprN2PMX063uj/KwQ91gnGqr05IIqNC7y
   3XIJLwVyE/iOGHsbXYYjT1qA/kvZr5Lm4cS8QqgrfB9Obw0uf8U2HpzAu
   4yVjMdoNIJ86BvNPAj+eQ+6boNoGyXfGd3PQQrNqkccoGlRBbnvVeNkkV
   2qEEoewTql/U2gwm1uO1YYtnW190wvUu5jVlnSZ+xa6/a1WOISSd7Zd/l
   AhlUCzUJkIXmQbABA5totBA3FDgWzPXy0d0WB4m/Fv9lsmqenlNhpjmI7
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317792973"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="317792973"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 03:19:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="638724312"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="638724312"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 02 Dec 2022 03:19:37 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 03:19:37 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 03:19:37 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 03:19:37 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 03:19:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eliQBZqqspaaaOi3rM6Od8n+B/OrM0Qvkfnb+wLkju6a/kIUrCyK7TsV2XiSfLcrvh6gu56MnOSv+5qhGcUABWCIzjNp83tOstvROyMwSuhA89NyCswUN9Y3CI14jsz5J8eomKBxMX4L3f+9aGU7tBVCH5HmZKYZGovMMbVqUtjJnfS3ngJ9yP7WQXZm0ixqY7Bv/QRV40lg/ks5xlxxvmjGEwip789GwllyAD1enbqjwp0WOkkeuRx14ycy3Rv2Z8sMtme/clhY/R+LEsCCkGNLjkUOySeAYn1GW+M90GvEu+qbXyZP5zpLETFc5l/UxN0dRpG0orPQ0/Z/2q9FFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDPdJjpR2s/H9LxmpO+QNeOuROk3h+wWiYuUr+isZf8=;
 b=RMN7aK1HdEJkHHMOLO1p18HjQyJtV6l+1dbuBUTnfIdxtI9svEtMQH2OXwVcr68eXxiNdpkljc1Q9LBfcd8UFuiX+mb/CtBpOH0abX7FgLa7N11InURXD61WuAUnAxHiPsTUMWL6wz6air0fs7FMxCT8jD6RGrIakriDoT/cKex83IfaGOAFr3HQSuh2mVIVT7jzZ0SGTDztKsKyY2VnFAv3CrdCLqi5mlEvtAUKFcZ67ADi2pRejRUaYtzLVH6XF1EKSJpM4Dknln1LE60oW/w43roTHzmrX5POIDmKHVxLA9ZZbkS1wE+Ap7Ow7rQgK50U9FBryQaGIEtygXjlTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN0PR11MB6112.namprd11.prod.outlook.com (2603:10b6:208:3cc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 11:19:33 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%9]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 11:19:33 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 09/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Topic: [PATCH v7 09/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Index: AQHY/T3BkERrb6yHxUStNPJD5vkcxK5LnNIAgADJbQCAAFT+AIAAZzMAgA1i+wA=
Date:   Fri, 2 Dec 2022 11:19:33 +0000
Message-ID: <7be59cd82bc3f3c26e835980eb74a8d92c6d67d6.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <cd23a9583edcfa85e11612d94ecfd2d5e862c1d5.1668988357.git.kai.huang@intel.com>
         <850e0899-d54e-6a49-851e-56f4d353905c@intel.com>
         <57af0b96f8a827828b1d64031774962972bfb060.camel@intel.com>
         <1c6580f7-3abb-03ba-dd98-367ddb9bf23b@intel.com>
         <a5e0f218e911a4ad207da55e21fdeb6d8035fed0.camel@intel.com>
In-Reply-To: <a5e0f218e911a4ad207da55e21fdeb6d8035fed0.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN0PR11MB6112:EE_
x-ms-office365-filtering-correlation-id: 1f512ea7-ac0f-41d0-6d76-08dad4571689
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iUpAgwSSQwdIkl99qhBbFn7CEXE5/KrQogOwL4GAF/GVCWwBbcijpNG4s5TzxNY1wiiv0+8PPpZrbRrnMdhw24cebS2qekxJCRmiVDuPBPRB8aWZXx1GSxxBP0bLfZlfUnT7aWHILg/qpy3hsoCYlGo6qvL3Z/U4w0b+Aybi4SEMRf9rx0cNfSgCxj6TzYICaL450EFvIhsrOdZz/nRdH/lshQo1Y04cbFpCsz1UzoRY2Fm69v/5HaJQ11m1mllzTJOqjQmiGSKi6AERTJW1JpNCpJFkFau7XP4O08KtJ/30dv0mmcVZoGzURuwRSj/oxg8rYpTg+wc1NW0lJbFkShSK3IFzBgUMWO7eOLQwHLCQV+qm0/tIfTytfrcU5TfqKOtGlhP5JOfltBcbvMODIvQY/nJHRCSzFuuwplHJmldCxSk6ZAqYNsFemM6UrrokcQIZ560V1emafh2Dh81n5UjhZZsBhvqrUf00OEJ0vxE5tnn4zhV/JiaQlwfZDwkqC1GiEsFoK1BU62IQNk+cvxJKTq0x16WhNMceFOWG4HhZVjP95cqNrJEMIDv+OqPp1l6QPfO/E+OyEZWhUWo5HFmsmsr7FRwtx9RI3QVY4IMrZbXzfuLd/eTP0Az4I07yl0bjFFamm5s5RM9prYd33VStwvQvSZYSet0/A2MdPXvZdtfYXGcmmG2kEgVFa0GU6pgy2VYh+VckiqHhO3s96A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199015)(7416002)(8936002)(26005)(54906003)(316002)(186003)(110136005)(66556008)(6512007)(66476007)(2616005)(4326008)(64756008)(8676002)(66446008)(66946007)(5660300002)(36756003)(41300700001)(76116006)(91956017)(122000001)(38100700002)(38070700005)(82960400001)(83380400001)(86362001)(2906002)(478600001)(6486002)(4001150100001)(71200400001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ek9nUDgwbjFqeXNIRXI2S2xLZzR1NUdqajN3S3hva3kwczJzeFJSVU9IUVJh?=
 =?utf-8?B?aU1aOUxNcEFjVXBwVk1wK1VReXJiRGticXhqQ05CdUMzSHlpc3VJR1RxSmh5?=
 =?utf-8?B?aE5DZkJCUkxEWHBvTGQybUxVVzZQMmsvRkxzTkp3M2JkUEhMQVAvSUdmUWo3?=
 =?utf-8?B?WnJmU1ZpMUNNMjlpK3NVNmh1Ulp0Nlo1MkZ2U0JEUS9WcUo3QnlDc1UyR1ZU?=
 =?utf-8?B?ZmVXZzA3bkp6VGFmVWFVQkN3OG9qTElBaGJmN1RLOFpZWUtDZDRTajQ1Zkcw?=
 =?utf-8?B?MlFWaFlWblNEVmNlWnQvWVRXUTBWWDU4TUVuTU9zVWRkWEtXVm53Qk15Zkha?=
 =?utf-8?B?N2ZhZlJkMWhYRnJ2YWlyRnlsZDBMRkhnNTZYL21MNlV4MG11MTR1NmZuaXJQ?=
 =?utf-8?B?cE1mYk5TRTh3cGh1N2RJTkJrOXpkZmhwQzRFMjRFbVNJWEpvS1ZhYmJYOHJC?=
 =?utf-8?B?ZEZMUFlMM3NscXZkQThYZDd6aG1CRk12cmRxVk5pUUZhSnJ5Q0d4SC9od29l?=
 =?utf-8?B?NzdnT2s3K0JWUUxSdWtXVGlMaWtRcUVCYzRxcnNFVU5ENjFLS1VQUHFjOWY2?=
 =?utf-8?B?K01wS040L3VaZW1kNTA1ZENmdXZXaXBMcVBJTXdaWXBSekpoUDV0ZlpJTHdV?=
 =?utf-8?B?MlhWSFNGV2NZQ2JWb1c1YUVLWWY0NnB0dWZ5elY2YW5RMXBaS0hXRjNUV3Np?=
 =?utf-8?B?cDNUQzlUY1g0Wkx4elRFY2VVTEo1NkxJajdRUnA5cDdLNnB1ZVp1NlhrTWZV?=
 =?utf-8?B?Szgxa3ArYUpLenZKbWJoRFMrR0ZTNDRIWmtXamhXeTRTMVh4cEdvUStQWHAy?=
 =?utf-8?B?eVhHeXdOaVRFZVZBMTJkQSsxenRQQTh5bXRBaXphVXp2cjN6bzVja0FyTW1O?=
 =?utf-8?B?V3VPd3VXRHdNY1B2QTlvZjlxZWZmNE5SV1FMdDhoTjRWSUwxK2UzYThwMXNn?=
 =?utf-8?B?SnVXZ2dkWjh0YmJKWmcrNDFUR3h4SGpWMHdtRThWM0JqY2twYWtodU9GbmdX?=
 =?utf-8?B?YjJtbFpVa0RiZW82Z0hlVk9nK1FHaGh6a2p6NGxJS2grNmFzVUdnWEFOMDU5?=
 =?utf-8?B?NG5YNVgzUWxyUnR6RFVEWXQrN3puOVZ3cGJvSXhMSXd2VlFTNFhDa25UQktB?=
 =?utf-8?B?ZFk5VWRnOTE3Sk13VEVHMGpXd1YwWFNYWmZjY1ViSno1U3ZRWW9HT0FnZUcx?=
 =?utf-8?B?RWRqZGJpT0o1cWNZWDZDTUt4U1ZTRk9zUnlSbFpTTTBnOVp4MXJKRWtsR0pG?=
 =?utf-8?B?RmR4d3hyWUpIcVk0RG1UMWR4Ykw0dElPYVJ0M0l5RlVVVHIwRlZsYWFHRDRM?=
 =?utf-8?B?bVJmVDN5d0tDVVppUjdhNVBFaDdBMmlWQzFUbFBRL3pPMnFQV21FTW9mbzhG?=
 =?utf-8?B?QzJnWWFhUGc2K01rS2NuOURtWFF5NEVCM09FZzk5TkZ4V21nRDZieUZYdG9T?=
 =?utf-8?B?bkZyNENtZFd3eVFzcDlHTklEb2dxaDRabmN0SGowSHVWR1EzdzNOZW9iVEF6?=
 =?utf-8?B?TnQ0WnZKeFBTMEdCSXd4MFhyS0RLSlBrd2htWjhHVjczYStTUVJpM2xoQ2g4?=
 =?utf-8?B?K2JoTlM3Rk5GaGZFTEtCVEMvM0FmNndicmhkM2FPbVRDOThtRk1CMWF3OWhx?=
 =?utf-8?B?aGJPbWRFQlp6QVFXUHgzTTJiL3V2YzBVRjFzOThydE12OGIyckZEQjNrRWgz?=
 =?utf-8?B?WFhSSUd3aWpLclZTdTVyb1hoeXVRR3VsZHIxTFZPeHByd0pQaW5xVWFrc2sw?=
 =?utf-8?B?eHd1eEJSN1gxNUZQWEJSV2dZSVJSeGJQWk5kZFk0NkRsQTF5MDVXbzZjVTJX?=
 =?utf-8?B?NXhNdWh5dmk2d1F0c1BzR0ZPZ29zOGhnMlNtcFNPS0N1eFdlbWdoZlE0SVN2?=
 =?utf-8?B?QWxCMTVNa0YwVUp1ZVdScVlJYVJJVVBJWmI4TkxYMm5ZSStzelRVUTVlR0N0?=
 =?utf-8?B?M1VUZCtxUEcraWU2OXhEZDhZbE40ZEFiRldNdm5NTDRrWE5VSmw3MmlyelNH?=
 =?utf-8?B?Z2hVcWYrbWxVbFk3TS9zdVRYSCtHaUQwanF4allXTTJpNVo1SzI4OXJNNjJo?=
 =?utf-8?B?K0JTYitvR0JXb2JYSnB3NWxad1BIbG5RelFFMnJ4WU9pYWxEaGYrUkJ6N3dE?=
 =?utf-8?B?d2dldjBQM0hvTnVqcE5wYTZzTHJQZ1l0dUlJUzBMYXFyd0tVZTdITGZneldH?=
 =?utf-8?B?RkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E68E19136DD741489524F433E973561A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f512ea7-ac0f-41d0-6d76-08dad4571689
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 11:19:33.1226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o9xR9PJn5wPKPWKHWVTxFrVgRzhu3fdNM4Cytq7b5BAFe//dstbbdJ84FhIzaI35wHSA2BJ+hZIOgH92VdeVzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6112
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTIzIGF0IDIyOjUzICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
ID4gPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gPiA+ID4gK8KgwqAgLyoNCj4gPiA+ID4gPiA+
ID4gPiA+ICvCoMKgwqAgKiB0cmltX2VtcHR5X2NtcnMoKSB1cGRhdGVzIHRoZSBhY3R1YWwgbnVt
YmVyIG9mIENNUnMgYnkNCj4gPiA+ID4gPiA+ID4gPiA+ICvCoMKgwqAgKiBkcm9wcGluZyBhbGwg
dGFpbCBlbXB0eSBDTVJzLg0KPiA+ID4gPiA+ID4gPiA+ID4gK8KgwqDCoCAqLw0KPiA+ID4gPiA+
ID4gPiA+ID4gK8KgwqAgcmV0dXJuIHRyaW1fZW1wdHlfY21ycyh0ZHhfY21yX2FycmF5LCAmdGR4
X2Ntcl9udW0pOw0KPiA+ID4gPiA+ID4gPiA+ID4gK30NCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+
ID4gPiA+IFdoeSBkb2VzIHRoaXMgYm90aCBuZWVkIHRvIHJlc3BlY3QgdGhlICJ0ZHhfY21yX251
bSA9IG91dC5yOSINCj4gPiA+ID4gPiA+ID4gdmFsdWUNCj4gPiA+ID4gPiA+ID4gKmFuZCogdHJp
bSB0aGUgZW1wdHkgb25lcz/CoCBDb3VsZG4ndCBpdCBqdXN0IGlnbm9yZSB0aGUNCj4gPiA+ID4g
PiA+ID4gInRkeF9jbXJfbnVtID0NCj4gPiA+ID4gPiA+ID4gb3V0LnI5IiB2YWx1ZSBhbmQganVz
dCB0cmltIHRoZSBlbXB0eSBvbmVzIGVpdGhlciB3YXk/wqAgSXQncyBub3QNCj4gPiA+ID4gPiA+
ID4gbGlrZQ0KPiA+ID4gPiA+ID4gPiB0aGVyZSBpcyBhIGJpbGxpb24gb2YgdGhlbS7CoCBJdCB3
b3VsZCBzaW1wbGlmeSB0aGUgY29kZSBmb3Igc3VyZS4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBP
Sy7CoCBTaW5jZSBzcGVjIHNheXMgTUFYX0NNUnMgaXMgMzIsIHNvIEkgY2FuIHVzZSAzMiBpbnN0
ZWFkIG9mDQo+ID4gPiA+ID4gcmVhZGluZyBvdXQgZnJvbQ0KPiA+ID4gPiA+IFI5Lg0KPiA+ID4g
DQo+ID4gPiBCdXQgdGhlbiB5b3Ugc3RpbGwgaGF2ZSB0aGUgInRyaW1taW5nIiBjb2RlLsKgIFdo
eSBub3QganVzdCB0cnVzdCAicjkiDQo+ID4gPiBhbmQgdGhlbiBheGUgYWxsIHRoZSB0cmltbWlu
ZyBjb2RlP8KgIEhlY2ssIGFuZCBtb3N0IG9mIHRoZSBzYW5pdHkgY2hlY2tzLg0KPiA+ID4gDQo+
ID4gPiBUaGlzIGNvZGUgY291bGQgYmUgYSAqbG90KiBzbWFsbGVyLg0KPiANCj4gQXMgSSBzYWlk
IHRoZSBvbmx5IHByb2JsZW0gaXMgdGhlcmUgbWlnaHQgYmUgZW1wdHkgQ01ScyBhdCB0aGUgdGFp
bCBvZiB0aGUNCj4gY21yX2FycmF5W10gZm9sbG93aW5nIG9uZSBvciBtb3JlIHZhbGlkIENNUnMu
IMKgDQoNCkhpIERhdmUsDQoNClByb2JhYmx5IEkgZm9yZ290IHRvIG1lbnRpb24gdGhlICJyOSIg
aW4gcHJhY3RpY2UgYWx3YXlzIHJldHVybnMgMzIsIHNvIHRoZXJlDQp3aWxsIGJlIGVtcHR5IENN
UnMgYXQgdGhlIHRhaWwgb2YgdGhlIGNtcl9hcnJheVtdLg0KDQo+IA0KPiBCdXQgd2UgY2FuIGFs
c28gZG8gbm90aGluZyBoZXJlLCBidXQganVzdCBza2lwIGVtcHR5IENNUnMgd2hlbiBjb21wYXJp
bmcgdGhlDQo+IG1lbW9yeSByZWdpb24gdG8gaXQgKGluIG5leHQgcGF0Y2gpLg0KPiANCj4gT3Is
IHdlIGRvbid0IGV2ZW4gbmVlZCB0byBleHBsaWNpdGx5IGNoZWNrIG1lbW9yeSByZWdpb24gYWdh
aW5zdCBDTVJzLiBJZiB0aGUNCj4gbWVtb3J5IHJlZ2lvbnMgdGhhdCB3ZSBwcm92aWRlZCBpbiB0
aGUgVERNUiBkb2Vzbid0IGZhbGwgaW50byBDTVIsIHRoZW4NCj4gVERILlNZUy5DT05GSUcgd2ls
bCBmYWlsLiBXZSBjYW4ganVzdCBkZXBlbmQgb24gdGhlIFNFQU1DQUxMIHRvIGRvIHRoYXQuDQoN
ClNvcnJ5IHRvIHBpbmcsIGJ1dCBkbyB5b3UgaGF2ZSBhbnkgY29tbWVudHMgaGVyZT8NCg0KSG93
IGFib3V0IHdlIGp1c3QgZG9uJ3QgZG8gYW55IGNoZWNrIG9mIFREWCBtZW1vcnkgcmVnaW9ucyBh
Z2FpbnN0IENNUnMsIGJ1dCANCmp1c3QgbGV0IHRoZSBUREguU1lTLkNPTkZJRyBTRUFNQ0FMTCB0
byBkZXRlcm1pbmU/DQo=
