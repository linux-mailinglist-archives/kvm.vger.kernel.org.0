Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14CEF72B5BC
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 05:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234235AbjFLDKh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jun 2023 23:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbjFLDJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jun 2023 23:09:51 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920A9E64;
        Sun, 11 Jun 2023 20:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686539344; x=1718075344;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AaY3rEwcTWBg4RYwvfBc35Easjh7Y2frli+aZsI/wrw=;
  b=QVguKpYogavIjeY/8S2uGqHj+usUJJZbqm+sPqrjX9ntJvG53kwOLZD2
   FqFu8+R/rskfwKAVc96cSCaeZ6C9nwAGGbTDLTemjDChlk7taCpB/Ok0t
   lncz2TIAJsEsqVRgCLIbqm5AK6+VtfZG0B0Nrh7xYLpwvjU4wfDIpCHCH
   zKovlr1jpsmLMU2XtfC5rTYox8Q0YwNiSwzRwUyrokjg6ZvJFGhVlv5M3
   c/Qtm+Jq5pLZ8UWdUsEv7WLLNW6vm/8+Lko8w4gf++aiHvX746YbWMi3K
   D7k58SoAjl3ScfJXJl6T0QFRn2P1IMl58q1YP8N6ZaT2Lcef1+dPdz9Ia
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="361296048"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="361296048"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2023 20:08:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="957838988"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="957838988"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 11 Jun 2023 20:08:46 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 20:08:44 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 11 Jun 2023 20:08:44 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 11 Jun 2023 20:08:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i096xas1J0Sm1NZ+XB+Uu3v/TuZe/8cZugpTRG3IQB8BGAz4PjDFNXmcZxLeStIsIlkOh3IhWykE9n5kIMS7qbx9+WQ9TE9HwaVm4YcuHtyV6c5E92ApzPYQVazvYprhXJ2JjjpDVEgpR3y6/CWR3LBMq3lxZL0Vszm5G0sdmr/m4vVw9Yt2tE1sQO/cgEmTun1ZmOeaUclBucYpp5e8WmNxtzgUXIaGXuNR5T8KFr4R2ieIsMl77qJRukRlbEbJBEQi8wxBHsQd3ragQbYrvYLmiOJiXzJQkwNpsY7IihXhV4TDVRhOdEEZzA35Gh3andVbDOZ3u/g1CBZfw5fdXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AaY3rEwcTWBg4RYwvfBc35Easjh7Y2frli+aZsI/wrw=;
 b=CY9xySewgErfUA7CJXhUaFQaOUheFtyhJCz0oxdqEMdz2lu7dLLrs4q1WmFcIq1qIRBnVSZZZqrhggJ8O6xK8iP1a6AqNYCude7cbXiozOE4CtJZ1wU4J+PfwTMgN/35u29VZdi7N/Yqv3bUayLm6JX9fba5n1DvIfoX02A4Wu5thzNAhXR/jai5MFVhZCzy8TbfKPPtnYATzfmDBri1sHF/oyH8hhsKPVp2nUYq2+NTTm1eJ/oW2z5Q1D2KGMTdDgeE4ltCODWUcPfb1fPq49Gh5hiwqkTuHsgt54VGGpKogGKUUVUiTIwAcwObSZ+QCCExJoY2VGgL3i8e/CSeaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB8131.namprd11.prod.outlook.com (2603:10b6:8:190::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 12 Jun
 2023 03:08:41 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 03:08:40 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 19/20] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Topic: [PATCH v11 19/20] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Index: AQHZlu+6CL+cHWwyoE2KpZjKTZv14K+Ce7kAgAQMw4A=
Date:   Mon, 12 Jun 2023 03:08:40 +0000
Message-ID: <90aefcfd663c654197c5878e410f55cc4473eb79.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <116cafb15625ac0bcda7b47143921d0c42061b69.1685887183.git.kai.huang@intel.com>
         <20230609131754.dhii5ctfwtzx667o@box.shutemov.name>
In-Reply-To: <20230609131754.dhii5ctfwtzx667o@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB8131:EE_
x-ms-office365-filtering-correlation-id: 7885d431-9955-481f-7aa9-08db6af252ba
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hrkSV6awUtGSVKL6mSNlc9CcxqW/KWvqzuz9SEiGju4i7qfvNcUss3R0sY5uSyxO415eSkoJEKufEsIHejd8tIoK8RX6QUJcncXIJ8FspPpc3BvFMGXIIpp0prFA0caYnfpN13J4yY9OHuMIZ4tapXcJgdQlHo1PRx3XWevF1oq4v/rdVmJBzru5o3gAlv4uf/Qk5hLY8MiqJm+87iSeRsHmotBEQTSj3kguVOH9vqFfSmB2Yu8dBye4MtDgHuGhTzR4kRhwlBjfOplneDXq2WRjGfqPJXZ+gVO7tkzr5Q4g+f10lcpte7sAOjNhcRbnzXGaExdIdhfpdYXhWqFpsJlOdEhIUcWFCJ5MJgwNTt4nFKGrtbW9efBmxsMHJiJDFVqd/xWBTq/K/eFezhmGX4mgGnbiuBCp+8J3/F2bIUcMumfzD5X4XrtF5QkG5KkBnjRfy1mZ6z7c+kO79fe4OFRDbBnW0zPzZdB5sWHkGftnU0kP6Zs8JsDLyEwG/Smcu2yEZJtIH4tVF9BLGfQdopXFZLeVgAcAAhSUttpJsM5xdS6cpJUv1FPVeJokkWY4C0ndkB1kGVBa88DMHNRKGVd0i2Nh7NA0rirn/tR4Wx/7jNB2KuDIWO/9+qOZFJB0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199021)(8936002)(8676002)(91956017)(5660300002)(7416002)(6916009)(4326008)(64756008)(76116006)(66946007)(66446008)(66476007)(66556008)(316002)(54906003)(66899021)(2906002)(41300700001)(71200400001)(478600001)(6486002)(122000001)(26005)(6506007)(6512007)(36756003)(83380400001)(186003)(2616005)(82960400001)(38070700005)(86362001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGlnSzZLUmQ3VWZnTXFycXE3ZklnVkszOWdJdjhHY0hHM0crSndGWjhDOGNE?=
 =?utf-8?B?bVZ3dnpXT2dFM3k5T0lXNTJnMThlelJhbkxGUVc5SnV6cVNYNm1IbngzTXMv?=
 =?utf-8?B?VXQ1NTZnVnVIYUZweTNnNVZ0U3VZTzUwUUVLKzNnMGhEZVJjTDB1S29teEh2?=
 =?utf-8?B?YUZmbWk2NjZ4VkluYU9BcU5XV200OVlQSmRrWUVSaTdqdFZzQzhDMlRyV3Br?=
 =?utf-8?B?YXFDZ0pwNzEya0h3YXptY2d5NHZldmVLemdVK3I3T1FDV3Q2VTREYks3Q2xW?=
 =?utf-8?B?SU42UzlOZlJ3dlRNNkMwZnRIeExpNUNYS2d3MGx1TFYzNksrMXBSenF1aVFL?=
 =?utf-8?B?SzJnaDkwYmVBYVBsSDNtUEFBRkF1R2tsTlIrbzRiQ0lIRFhEanRrUFFZVzVm?=
 =?utf-8?B?OEdUVVY3UmdpSEo1c01HdXQyUGxDdFYzNlhyMEpnVmtyMnZza2U0RDRDQVhZ?=
 =?utf-8?B?YzI5WHNIdTJRV2Z4QVZJZFZGOGViNVAxRXR1VTZDbXp1N2J4K0dwR2dhRjQ5?=
 =?utf-8?B?MGFXbGNXS3VpZzVpUXVtU3RZcDdmazZkbll1c040QXlzUXVSQkZjTTI2VEJp?=
 =?utf-8?B?d3IwdndET3pZN2pyaUc2bWJuVjNLUG9wUit4eE9IWDhoc2VTTHRkZ3JXKzgv?=
 =?utf-8?B?dWJjdnRvSGlPUnpLNm9sUXFQMzFVeEVaTTRNamo4QU14bnZnZWdMbGpUT3Nt?=
 =?utf-8?B?NHJ6RXE1dXFIWFozVkc3aW4xWm9DenUzWENQTnFVcFYyR0xnUXVWVDlGOS9s?=
 =?utf-8?B?M2Z2OXUwMTd6TzRqclNmbzhtVTBQTlJTVnU2QTJQOFlhQURDMU5NM09KSGsz?=
 =?utf-8?B?b3VILzFoSjUzVzVXdUdTZHJLSDdyck5TQzM2STdSa1ppSzBxTENkN0RaWHZw?=
 =?utf-8?B?bTZhTkxUeWIwRGlXOE04TkNvY2xaRzdTVlhrUS8rbzBXUldSVjIzSXY2cldw?=
 =?utf-8?B?NEtxYk5OS3QzUjlVbTEvNmlvS1JJQ25vZjU0ZFRVem9SelA0RFltaS8zODAv?=
 =?utf-8?B?ajU0WmZDQVVuR0RCT01nUGNxUTByY056K1E0RGdMeHkvalJjTzE2bXRKVUZR?=
 =?utf-8?B?bmp0eFJ3RG5lZG9VM2hLdGhQNkxrZW9IODdkUXhBOVZNVFFraCswcVhtVVRz?=
 =?utf-8?B?a1BkOWFCUU9FWlEwSWlxcHB4MXdYdWhWQnFjQjNPVTdOQWJ6Zm9aODdpemIr?=
 =?utf-8?B?NXFkc2NhWUFLLzQxakdWUjlhWjRyOENlOXowZ2o4bWJtVUZZOVRmTmEyNzdE?=
 =?utf-8?B?ZW04L3BsYitSUGp1UzRzcUgwRG0yNlJmem5rZnJ6RUpTbldtZitaN3BsVWtX?=
 =?utf-8?B?MkcrMUlJZTBzUzJVTEV1dU1OaXp5Ym05eEFVd1VQTGhFZzYyd05wVjJPRTR2?=
 =?utf-8?B?L1J4VUxOY2Vsb2x6SXlaWUw2QVV6dmtFSEhVdDkxOGxzcmhJTEt3WEthcnNR?=
 =?utf-8?B?ZUdDSy9QMTFXdnZDTnAwcmhNdmRHR2hGOHUwOEZpRFhmZStSMDBVSW1wNkYr?=
 =?utf-8?B?RmRXZXY3Q3l1R2JYaDhFam5sMWNFNVdkdHV6VU1yRWdXOW5TRGVuTkVuczRY?=
 =?utf-8?B?YlhNbzJ4NWQwbzhyNGEwNzNvQnk4SW1jN3hjZHg2NEh3ZW5NOTB5WUVpRDBR?=
 =?utf-8?B?cGt2aEFWb2NFdVpScWs5blZuUGM5U1BTRUpWWW00dWJFMXpHRjhXR0t6SUlK?=
 =?utf-8?B?YXlkU054UmN3MGF1VmdCMWd4SExUWEJIcHRnN2hoK1JBcW1aTnI0OGRMS1Fl?=
 =?utf-8?B?c0VBOXkxWjZXR2hyeDdIK21GRmRiUkpHNWd1N0xJVFpPdndnWEF5OU0wMzVR?=
 =?utf-8?B?S2FaSEFTNHgvME1uRkVVbmRkRHNGNW9HaHV6eGlDNkY0dWV1ZUQrZVVpdU1o?=
 =?utf-8?B?bWErU014OUQxck1LZy9DbjlUTERZZGpQVHpjVHNXWWdxNXQ3MFF2VjZmUnBK?=
 =?utf-8?B?UFRqTUtxNmI2c05MUzlZMUdicDlwWmZETHhGZURmRFNmdkQrYWlYdmpqM3RF?=
 =?utf-8?B?ZXJjUUNyZkRjeXYwMXpNa3RWQzZ0cVRDaC9PNGoyTkc3bzl5L2FtemVOWktN?=
 =?utf-8?B?WC9BTzNseEJCZ25HeE1RWmJwbHV3WUVQZ3FYam9iSzcvSTJNSUd4NjIzalVL?=
 =?utf-8?Q?Dm9P9QHUtns4eLqf2tsJi6bJx?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B74C2FEEDA78804EB610543C80D99AF7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7885d431-9955-481f-7aa9-08db6af252ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 03:08:40.5384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y6OkbQil2z5KoIHGQ7c6dkVQFxPzOeF6/8qNFbV/F7Ae/yvpgLs/pnNhgkgTYPrmOZMilPOFVWbQ7vr1B+ouFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8131
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

T24gRnJpLCAyMDIzLTA2LTA5IGF0IDE2OjE3ICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBNb24sIEp1biAwNSwgMjAyMyBhdCAwMjoyNzozMkFNICsx
MjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gVGhlIGZpcnN0IGZldyBnZW5lcmF0aW9ucyBvZiBU
RFggaGFyZHdhcmUgaGF2ZSBhbiBlcnJhdHVtLiAgVHJpZ2dlcmluZw0KPiA+IGl0IGluIExpbnV4
IHJlcXVpcmVzIHNvbWUga2luZCBvZiBrZXJuZWwgYnVnIGludm9sdmluZyByZWxhdGl2ZWx5IGV4
b3RpYw0KPiA+IG1lbW9yeSB3cml0ZXMgdG8gVERYIHByaXZhdGUgbWVtb3J5IGFuZCB3aWxsIG1h
bmlmZXN0IHZpYQ0KPiA+IHNwdXJpb3VzLWxvb2tpbmcgbWFjaGluZSBjaGVja3Mgd2hlbiByZWFk
aW5nIHRoZSBhZmZlY3RlZCBtZW1vcnkuDQo+ID4gDQo+ID4gPT0gQmFja2dyb3VuZCA9PQ0KPiA+
IA0KPiA+IFZpcnR1YWxseSBhbGwga2VybmVsIG1lbW9yeSBhY2Nlc3NlcyBvcGVyYXRpb25zIGhh
cHBlbiBpbiBmdWxsDQo+ID4gY2FjaGVsaW5lcy4gIEluIHByYWN0aWNlLCB3cml0aW5nIGEgImJ5
dGUiIG9mIG1lbW9yeSB1c3VhbGx5IHJlYWRzIGEgNjQNCj4gPiBieXRlIGNhY2hlbGluZSBvZiBt
ZW1vcnksIG1vZGlmaWVzIGl0LCB0aGVuIHdyaXRlcyB0aGUgd2hvbGUgbGluZSBiYWNrLg0KPiA+
IFRob3NlIG9wZXJhdGlvbnMgZG8gbm90IHRyaWdnZXIgdGhpcyBwcm9ibGVtLg0KPiA+IA0KPiA+
IFRoaXMgcHJvYmxlbSBpcyB0cmlnZ2VyZWQgYnkgInBhcnRpYWwiIHdyaXRlcyB3aGVyZSBhIHdy
aXRlIHRyYW5zYWN0aW9uDQo+ID4gb2YgbGVzcyB0aGFuIGNhY2hlbGluZSBsYW5kcyBhdCB0aGUg
bWVtb3J5IGNvbnRyb2xsZXIuICBUaGUgQ1BVIGRvZXMNCj4gPiB0aGVzZSB2aWEgbm9uLXRlbXBv
cmFsIHdyaXRlIGluc3RydWN0aW9ucyAobGlrZSBNT1ZOVEkpLCBvciB0aHJvdWdoDQo+ID4gVUMv
V0MgbWVtb3J5IG1hcHBpbmdzLiAgVGhlIGlzc3VlIGNhbiBhbHNvIGJlIHRyaWdnZXJlZCBhd2F5
IGZyb20gdGhlDQo+ID4gQ1BVIGJ5IGRldmljZXMgZG9pbmcgcGFydGlhbCB3cml0ZXMgdmlhIERN
QS4NCj4gPiANCj4gPiA9PSBQcm9ibGVtID09DQo+ID4gDQo+ID4gQSBwYXJ0aWFsIHdyaXRlIHRv
IGEgVERYIHByaXZhdGUgbWVtb3J5IGNhY2hlbGluZSB3aWxsIHNpbGVudGx5ICJwb2lzb24iDQo+
ID4gdGhlIGxpbmUuICBTdWJzZXF1ZW50IHJlYWRzIHdpbGwgY29uc3VtZSB0aGUgcG9pc29uIGFu
ZCBnZW5lcmF0ZSBhDQo+ID4gbWFjaGluZSBjaGVjay4gIEFjY29yZGluZyB0byB0aGUgVERYIGhh
cmR3YXJlIHNwZWMsIG5laXRoZXIgb2YgdGhlc2UNCj4gPiB0aGluZ3Mgc2hvdWxkIGhhdmUgaGFw
cGVuZWQuDQo+ID4gDQo+ID4gVG8gYWRkIGluc3VsdCB0byBpbmp1cnksIHRoZSBMaW51eCBtYWNo
aW5lIGNvZGUgd2lsbCBwcmVzZW50IHRoZXNlIGFzIGENCj4gPiBsaXRlcmFsICJIYXJkd2FyZSBl
cnJvciIgd2hlbiB0aGV5IHdlcmUsIGluIGZhY3QsIGEgc29mdHdhcmUtdHJpZ2dlcmVkDQo+ID4g
aXNzdWUuDQo+ID4gDQo+ID4gPT0gU29sdXRpb24gPT0NCj4gPiANCj4gPiBJbiB0aGUgZW5kLCB0
aGlzIGlzc3VlIGlzIGhhcmQgdG8gdHJpZ2dlci4gIFJhdGhlciB0aGFuIGRvIHNvbWV0aGluZw0K
PiA+IHJhc2ggKGFuZCBpbmNvbXBsZXRlKSBsaWtlIHVubWFwIFREWCBwcml2YXRlIG1lbW9yeSBm
cm9tIHRoZSBkaXJlY3QgbWFwLA0KPiA+IGltcHJvdmUgdGhlIG1hY2hpbmUgY2hlY2sgaGFuZGxl
ci4NCj4gPiANCj4gPiBDdXJyZW50bHksIHRoZSAjTUMgaGFuZGxlciBkb2Vzbid0IGRpc3Rpbmd1
aXNoIHdoZXRoZXIgdGhlIG1lbW9yeSBpcw0KPiA+IFREWCBwcml2YXRlIG1lbW9yeSBvciBub3Qg
YnV0IGp1c3QgZHVtcCwgZm9yIGluc3RhbmNlLCBiZWxvdyBtZXNzYWdlOg0KPiA+IA0KPiA+ICBb
Li4uXSBtY2U6IFtIYXJkd2FyZSBFcnJvcl06IENQVSAxNDc6IE1hY2hpbmUgQ2hlY2sgRXhjZXB0
aW9uOiBmIEJhbmsgMTogYmQ4MDAwMDAwMDEwMDEzNA0KPiA+ICBbLi4uXSBtY2U6IFtIYXJkd2Fy
ZSBFcnJvcl06IFJJUCAxMDo8ZmZmZmZmZmZhZGI2OTg3MD4ge19fdGxiX3JlbW92ZV9wYWdlX3Np
emUrMHgxMC8weGEwfQ0KPiA+ICAJLi4uDQo+ID4gIFsuLi5dIG1jZTogW0hhcmR3YXJlIEVycm9y
XTogUnVuIHRoZSBhYm92ZSB0aHJvdWdoICdtY2Vsb2cgLS1hc2NpaScNCj4gPiAgWy4uLl0gbWNl
OiBbSGFyZHdhcmUgRXJyb3JdOiBNYWNoaW5lIGNoZWNrOiBEYXRhIGxvYWQgaW4gdW5yZWNvdmVy
YWJsZSBhcmVhIG9mIGtlcm5lbA0KPiA+ICBbLi4uXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2lu
ZzogRmF0YWwgbG9jYWwgbWFjaGluZSBjaGVjaw0KPiA+IA0KPiA+IFdoaWNoIHNheXMgIkhhcmR3
YXJlIEVycm9yIiBhbmQgIkRhdGEgbG9hZCBpbiB1bnJlY292ZXJhYmxlIGFyZWEgb2YNCj4gPiBr
ZXJuZWwiLg0KPiA+IA0KPiA+IElkZWFsbHksIGl0J3MgYmV0dGVyIGZvciB0aGUgbG9nIHRvIHNh
eSAic29mdHdhcmUgYnVnIGFyb3VuZCBURFggcHJpdmF0ZQ0KPiA+IG1lbW9yeSIgaW5zdGVhZCBv
ZiAiSGFyZHdhcmUgRXJyb3IiLiAgQnV0IGluIHJlYWxpdHkgdGhlIHJlYWwgaGFyZHdhcmUNCj4g
PiBtZW1vcnkgZXJyb3IgY2FuIGhhcHBlbiwgYW5kIHNhZGx5IHN1Y2ggc29mdHdhcmUtdHJpZ2dl
cmVkICNNQyBjYW5ub3QgYmUNCj4gPiBkaXN0aW5ndWlzaGVkIGZyb20gdGhlIHJlYWwgaGFyZHdh
cmUgZXJyb3IuICBBbHNvLCB0aGUgZXJyb3IgbWVzc2FnZSBpcw0KPiA+IHVzZWQgYnkgdXNlcnNw
YWNlIHRvb2wgJ21jZWxvZycgdG8gcGFyc2UsIHNvIGNoYW5naW5nIHRoZSBvdXRwdXQgbWF5DQo+
ID4gYnJlYWsgdXNlcnNwYWNlLg0KPiA+IA0KPiA+IFNvIGtlZXAgdGhlICJIYXJkd2FyZSBFcnJv
ciIuICBUaGUgIkRhdGEgbG9hZCBpbiB1bnJlY292ZXJhYmxlIGFyZWEgb2YNCj4gPiBrZXJuZWwi
IGlzIGFsc28gaGVscGZ1bCwgc28ga2VlcCBpdCB0b28uDQo+ID4gDQo+ID4gSW5zdGVhZCBvZiBt
b2RpZnlpbmcgYWJvdmUgZXJyb3IgbG9nLCBpbXByb3ZlIHRoZSBlcnJvciBsb2cgYnkgcHJpbnRp
bmcNCj4gPiBhZGRpdGlvbmFsIFREWCByZWxhdGVkIG1lc3NhZ2UgdG8gbWFrZSB0aGUgbG9nIGxp
a2U6DQo+ID4gDQo+ID4gICAuLi4NCj4gPiAgWy4uLl0gbWNlOiBbSGFyZHdhcmUgRXJyb3JdOiBN
YWNoaW5lIGNoZWNrOiBEYXRhIGxvYWQgaW4gdW5yZWNvdmVyYWJsZSBhcmVhIG9mIGtlcm5lbA0K
PiA+ICBbLi4uXSBtY2U6IFtIYXJkd2FyZSBFcnJvcl06IE1hY2hpbmUgQ2hlY2s6IE1lbW9yeSBl
cnJvciBmcm9tIFREWCBwcml2YXRlIG1lbW9yeS4gTWF5IGJlIHJlc3VsdCBvZiBDUFUgZXJyYXR1
bS4NCj4gDQo+IFRoZSBtZXNzYWdlIG1lbnRpb25zIG9uZSBwYXJ0IG9mIGlzc3VlIC0tIENQVSBl
cnJhdHVtIC0tIGJ1dCBtaXNzZXMgdGhlDQo+IG90aGVyIHJlcXVpcmVkIHBhcnQgLS0ga2VybmVs
IGJ1ZyB0aGF0IG1ha2VzIGtlcm5lbCBhY2Nlc3MgdGhlIG1lbW9yeSBpdA0KPiBub3Qgc3VwcG9z
ZSB0by4NCj4gDQoNCkhvdyBhYm91dCBiZWxvdz8NCg0KIk1lbW9yeSBlcnJvciBmcm9tIFREWCBw
cml2YXRlIG1lbW9yeS4gTWF5IGJlIHJlc3VsdCBvZiBDUFUgZXJyYXR1bSBjYXVzZWQgYnkNCmtl
cm5lbCBidWcuIg0KDQoNCg0K
