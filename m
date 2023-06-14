Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB5A72FC34
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 13:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243876AbjFNLR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 07:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235834AbjFNLRQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 07:17:16 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CAC2110;
        Wed, 14 Jun 2023 04:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686741432; x=1718277432;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gsiU9zyNwuDI85N+iJFGsqOb5yuJlqj3VbOoTZTRgBY=;
  b=DLVE4PfAbAoyGr/IQYAy5JgDiqcTyiuLSG7OnVGjUPQfvRhC30gJebD2
   TSejiIW6cHmdCoUnK53s0P8D9vU6QfwR6HoTyd5OW6sK1FXDvUgXYCGTA
   F6LQwnxaDiCuxe0LnHzQdVcly/7VEaH+NDu3Eie/W4ITHeCUdHE36RF7g
   IGceNxN9EAJ9xypt3TdF24st05NHu5n9givvS8aM1gPU2/JW/hDCwvXxT
   E2ageKmXjGM1uH3YlN9SM/jvoCTAiz7hEMWishIjHP0vfhrjpJsUjz2KL
   AU/nv6eFjExfPRuST9KgCcsVrw42SH6sGR3jf4yAaANjBnM8OmzIaWL3c
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="361065721"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="361065721"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 04:17:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="745042573"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="745042573"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 14 Jun 2023 04:17:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 04:17:07 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 04:17:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 04:17:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/Hs8w5N86ZxC/hUZqBLES5tRiPpilDj10QlW+xlPu6M1b4OHyvsh6bBBr77AVaU8Q+z4qLFjbNwpnBFJXTwMUmJCU0ok0vzgL92fSaA8D5zj1S5KF0IrxXUh2waBCs49CMznrkHeSoS2Qa6/n1IyOotMUTaAWOgArWarhxWeZTGiFUT/tbTi8oEIY+Gj91wU4IVhvbpbWSmRUA5t+1e9b+0lN95WLnNz82yMxpyHZZgGXQO785QipHmtuGHqN7xOLSPhzr3GtJmoGU6c05HR59+vt89tTmpjT7O0A3/rX/VS8JzNyHSCmqg78gtOaEjWvdKzwH8iyBkYZHO16VUFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gsiU9zyNwuDI85N+iJFGsqOb5yuJlqj3VbOoTZTRgBY=;
 b=nFOxvEJbMMN9ZqpK8+8f4xgvT0vyr17/clhoq60OAywWXymill1tp+g4XlHwWySyA5NklgDfHIKXOYQrqENZZ3gXNtdm64CPjPulgbhjWQlg0Ya3gDimcgF8ifcUpOxEfz0UMaSAug/xG4/truvokX1znIMMIm1FaQQ6JjouY0na7O4asTPgYbBQNysvR+F8G9gdUQnnAgmOY0RjP3+pOZaCI3XAG3NgPFGlrmP72+oQIAp6Jab23YhSHeWaiFUpj/Qz9IGiJXYmtY6fuw8NmZ2wxB+39gQKAZhCq1w7j9K4Yl7O/mk1Vp7GwjAmHAO39WIuXk5o5d+78QWNAuNf2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB5992.namprd11.prod.outlook.com (2603:10b6:8:73::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 11:17:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 11:17:04 +0000
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
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Topic: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Index: AQHZlu+7CCb5RYnzE0SLr6ZWSpg4cK+KGL6AgAAIHYCAAA98AIAAAtiAgAACaoA=
Date:   Wed, 14 Jun 2023 11:17:04 +0000
Message-ID: <a83411773ba3a8d6dd2c8b874a74b030e12401da.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
         <d3df3a9fa3075066558dd3bc84ef76ab3747185b.camel@intel.com>
         <20230614100245.3vehux365zou3ze6@box>
         <84dcc5ff896f487c95dc1602b627abef8d48432f.camel@intel.com>
         <20230614110821.pf35kxd4vcwjjpb5@box>
In-Reply-To: <20230614110821.pf35kxd4vcwjjpb5@box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB5992:EE_
x-ms-office365-filtering-correlation-id: 067f4aa2-82ec-4cf5-eafe-08db6cc8e1f2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: znVaoxScW9BWde6OThT1WL0epmGHAf4qzL04H6UHlJT3Ak9kq3NAk2lwAY6dTBc+y9+h5buc84v8+GLhzlSBdWRdeuLTMMVftNs/SpxVgnt8Eu0WlpgSSstz8RuUsEm1ZaovyurJNqcGzuKNC1wUhdaDD+0lS4x5NgbVB3lfKX1jIUn76OAMsFHoeg4mBxsI/t9gy4oEZ3bFzzjrOB4PgUsim8MeN/Sn5sc/NXX+3uMiln8/t+67/Ncp5Ru5/iMHcltXR3v2ZtK9lGShDB78ZbAPgFOAXc8Xw/NQlA5MpFlSDZz+Ikh7TXmbJ+GNGBeDnRtoc1TbOyH4c+GD2IYurTWLRcbjmxOjN2OW+XD7vRs+3LQJktkYmtGI4Ggwb4JX8EOTi0bm8WnMWoN/8kE2qUUxNA8HHd2EtY5YAVdgWnSP+Z/Pu3xCaIo1QqhJJlfbq+icml9tC3owD4zTYkFvKKrcbZUU2Cj5vdC1cn8qvEnZ/0P0CZEyxfzH6zqB93BZvIzP9fqcHcbs+HYnL3c2bB/312n6pG3MVHeA2mqlLrbp38BMPk+SSVtIdI6gYXSBBpNiYXyfrFC0hwI7pNdWQLy0TtPG5khR9Hy+O4bAp8i4gYZxzgsxfBcBEY1rW9sW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(366004)(346002)(376002)(451199021)(8936002)(8676002)(2906002)(38100700002)(82960400001)(5660300002)(76116006)(66446008)(66476007)(66556008)(66946007)(64756008)(316002)(122000001)(4326008)(6916009)(91956017)(54906003)(41300700001)(2616005)(36756003)(478600001)(186003)(6512007)(6506007)(26005)(71200400001)(7416002)(6486002)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGg4WkFsV0FEV0RNaXAxNDdGTitYaERBK1hkVTAzNWdvSXRyOHhPMDRwckJM?=
 =?utf-8?B?VkcrUXdXVFAwUVVoWUxGeDRvWG51b3BJSFZtZHFJRHFOOG9lMTNJQTFuZ2xj?=
 =?utf-8?B?RHQ4VFBPTGMycVgvWmduT1NtN2NpNjV3T1AwdEpnRmg1V3dWWUxHdWJJZWVs?=
 =?utf-8?B?ZVdvNUVYUnFoaFNXR0c1WE5pT0JkMm9jdUhiZk9lajdzNjRXbjhnZ09yQnpZ?=
 =?utf-8?B?azBqWE5ORmZQWGJmeklCanVtN0NHVnZXaTgreEd0RFZKYTg3NnhUa2s1TW55?=
 =?utf-8?B?SFZPa3JOL3VJdmgybE5aK1VVdEt6MUVUcDhKYXNuT2ZPV3FLNzlOZzQyZ2Nu?=
 =?utf-8?B?ZHV1Mmh1VU5FaHFvQW9yMDhFVlFRT25DdHhKOGYwVytaNngxbnBvMW5mRVJY?=
 =?utf-8?B?ZklMZW43b2FJUXhFTGJuMy84eE5nREFTcGtSbnJudUxBc0gvbGpIU1p1cG1R?=
 =?utf-8?B?NEd0dWNzWFNSYlMvZkpPV2t6WEUrYVF6ZytrQlc4WHVUZjZOMTEyV29TSGww?=
 =?utf-8?B?UWszd2tpMEhsczN4dmZzN1BSaEJDR05GS0xycExhY0s0ZUE3THprT0RZS0d1?=
 =?utf-8?B?YnhiYm9EV2RpL21QREt5RUxvY0FnMnJweW1KdXdyL0JBQm02eGJQYXlCZVVO?=
 =?utf-8?B?aERvcTZmeTN3U1cyVTlXU3VyUkM3WEtucU9DeENVYnU2bHYzdG8wOEwvSElx?=
 =?utf-8?B?bjBYRU5RNnQweXd6aXN0ZFBsMUdvM0NyWGhGN1BxUmZrSnNPcXQrNVhsSXZp?=
 =?utf-8?B?aGRKNGJRek93eUo5VkJWVyt6NUNPbTJCaUhJek10K1lraTNBN28wa2VFalUx?=
 =?utf-8?B?eEZyNDUzNmdjUDFCSTMxS3hKeUl6c0hOZnRzcThzQktqdlhIbFNQQVJRSW1x?=
 =?utf-8?B?dE50UFlWNnR4QWFzSGZ6YzlRVjhiYkhaTGRPc0lSbGFLdU5MbDg2Q3Q2MTRB?=
 =?utf-8?B?QWtGUXlUZm9KQkk1ZlRvVzVLbU8xNStGOU85M2ZRbSswbjl2YzhiaGNOZk9X?=
 =?utf-8?B?SkU5WUFCUG83UmIyWjRqTzlXUk9LODhsNTlhYkJvMUNxU3hkeFRiRnJ2cXJW?=
 =?utf-8?B?bzFuencwbWlBbVpjZUpSZnZsM0VqcFZYM1ZjQ0VNa0NtUlpYRjRuM0w3SHlB?=
 =?utf-8?B?a0RBSG5CQWpiU090N2lBeDRmcUJxblVOeUNWZ1lDVWQrcEhHR3hrVHRLQzRM?=
 =?utf-8?B?a0ZHakU2ajk1VDVvQ2ZOOFQ5a2pGNjNEbUU2MmYrb0ZtRlBtOVJLMTFEYnB0?=
 =?utf-8?B?VG5ncE9oZDBEd2NMeDhDNGJRcm92Skx2ZlljdnZYM3dFZUlNaGtXd252Y05o?=
 =?utf-8?B?L0RPbDF1RW5qWFpMSTdVZkVnU05TKzlITWVHeEdDeGd2eUdITDhGWEx1THIx?=
 =?utf-8?B?L0lSL1EyYTJIYit0YW9CK0owQ1JqODVhbHYyakpDUFBnU2F5cUFYODlTeUVD?=
 =?utf-8?B?Nm9QNG9JSW5vUDF0S0J3SGFkRHBUT3dHakVQZUFlQW5wS21KYmNzdjhnakxS?=
 =?utf-8?B?RG9VTTd6Wm1lUEIwZnVNRmVlakZvSkVFVjI3MElWdnYyY2RKcmxIS01ZUld4?=
 =?utf-8?B?UEpMOEN6cHA1R0NwbHYxdmNDb1g2emxTalZnYXY1SjFxVTRZMTRLM1Y4Uisx?=
 =?utf-8?B?K05SOU5mUVdKSEp6b1dkd0RtQXNJa1NVQ2Q0N283RDFXdmM1YlN0M1g3aDM5?=
 =?utf-8?B?dkh6RkxZSzlEdHB1WTNJL01aMExZVExKblZZc3EwcFBXaG96ZXV5dTVKQ28y?=
 =?utf-8?B?RFNSdjVZeGJ0MDNIc2ZLL2hnSzVUUzdUQ2hPRGtwQ05jYmthQ2U1WDRrcU5X?=
 =?utf-8?B?d1ZqVjlqcDJBZlpNaW0xWkxpelZwOFJlUEJmZGZIY09VajZ5akg4ZTZxNnB1?=
 =?utf-8?B?NFREcDVYcHcvLzFaOUg1emhjVTNsSml6TjhKT0FLcUUwTi9tODgzQkJGVUxY?=
 =?utf-8?B?V09EdjdSZlQxSEw5clhBVmJTTzBkcHc1ZkEvNEUwSHRUY2xEYlN5M0NyQXdY?=
 =?utf-8?B?Q2dvTktFNXJWUkQxZWoxVEc0cHQrM0xXZW42YS9WcEUwNzFoWWQ1cTFmeHlO?=
 =?utf-8?B?U2U4VU1BUHJCbmROb0lralNLODE1T01GcXdKMDRDU0xkdnJiWDhRRUJocVJW?=
 =?utf-8?Q?8AAxOMWsp4BkfzgiikiNsYayF?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5761793F5351054F8AE217A6E217CE22@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 067f4aa2-82ec-4cf5-eafe-08db6cc8e1f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 11:17:04.2851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J41awYAnlhNcVdI3IIQnayM5/o8yesvTrGlp4fahLH7ZwpUSiBvVOsOWtdkzUBjp7JonRzmDHr0eW+9IjZROFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5992
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTE0IGF0IDE0OjA4ICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBXZWQsIEp1biAxNCwgMjAyMyBhdCAxMDo1ODoxM0FNICsw
MDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gQW5kIHRoZSBwbGF0Zm9ybSBoYXMgdG8NCj4g
PiA+IGhhbmRsZSBlcnJhdHVtIGluIEJJT1MgdG8gcmVzZXQgbWVtb3J5IHN0YXR1cyBvbiByZWJv
b3QgYW55d2F5Lg0KPiA+IA0KPiA+IFNvICJoYW5kbGUgZXJyYXR1bSBpbiBCSU9TIiBJIHRoaW5r
IHlvdSBtZWFuICJ3YXJtIHJlc2V0IiBkb2Vzbid0IHJlc2V0IFREWA0KPiA+IHByaXZhdGUgcGFn
ZXMsIGFuZCB0aGUgQklPUyBuZWVkcyB0byBkaXNhYmxlICJ3YXJtIHJlc2V0Ii4NCj4gPiANCj4g
PiBJSVVDIHRoaXMgbWVhbnMgdGhlIGtlcm5lbCBuZWVkcyB0byBkZXBlbmQgb24gc3BlY2lmaWMg
QklPUyBzZXR0aW5nIHRvIHdvcmsNCj4gPiBub3JtYWxseSwgYW5kIElJVUMgdGhlIGtlcm5lbCBl
dmVuIGNhbm5vdCBiZSBhd2FyZSBvZiB0aGlzIHNldHRpbmc/DQo+ID4gDQo+ID4gU2hvdWxkIHRo
ZSBrZXJuZWwganVzdCByZXNldCBhbGwgVERYIHByaXZhdGUgcGFnZXMgd2hlbiBlcnJhdHVtIGlz
IHByZXNlbnQNCj4gPiBkdXJpbmcgcmVib290IHNvIHRoZSBrZXJuZWwgZG9lc24ndCBkZXBlbmQg
b24gQklPUz8NCj4gDQo+IEtlcm5lbCBjYW5ub3QgcmVhbGx5IGZ1bmN0aW9uIGlmIHdlIGRvbid0
IHRydXN0IEJJT1MgdG8gZG8gaXRzIGpvYi4gS2VybmVsDQo+IGRlcGVuZHMgb24gQklPUyBzZXJ2
aWNlcyBhbnl3YXkuIFdlIGNhbm5vdCB0cnkgdG8gaGFuZGxlIGV2ZXJ5dGhpbmcgaW4NCj4ga2Vy
bmVsIGp1c3QgaW4gY2FzZSBCSU9TIGRyb3BzIHRoZSBiYWxsLg0KPiANCg0KSW4gb3RoZXIgd29y
ZHMsIEkgYXNzdW1lIHdlIGp1c3QgbmVlZCB0byB0YWtlIGNhcmUgb2Yga2V4ZWMoKS4NCg0KVGhl
IGN1cnJlbnQgcGF0Y2ggdHJpZXMgdG8gaGFuZGxlIHJlYm9vdCB0b28sIHNvIEknbGwgY2hhbmdl
IHRvIG9ubHkgY292ZXINCmtleGVjKCksIGFzc3VtaW5nIHRoZSBCSU9TIHdpbGwgYWx3YXlzIGRp
c2FibGUgd2FybSByZXNldCByZWJvb3QgZm9yIHBsYXRmb3Jtcw0Kd2l0aCB0aGlzIGVycmF0dW0u
DQoNClRoYW5rcy4NCg==
