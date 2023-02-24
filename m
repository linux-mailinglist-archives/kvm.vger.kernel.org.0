Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680816A2403
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 23:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjBXWD0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 17:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBXWDZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 17:03:25 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A2818ABB;
        Fri, 24 Feb 2023 14:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677276204; x=1708812204;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tHYnFrgaUpX5R1tfhbhsbkh0dVyzj/uP1sbPLioseLU=;
  b=UAiS+CeHVSzuPMNysFSxJVcsLEiYPYb/Csvg1/YNwcSHUouI+QNk0VP5
   ZQ1KG5+/OH5K9s+zcWZewfedBap3I5x8v/WiecPANNadrDVNt9TatMNrX
   QTeZpHn8Y6JEsUmhqI0oOcVByljbJtXrEy6C12cs/ZlSjTAOtgdON1KIg
   QlZNJcEbElVvlTHfnZh/2uIlegLJWyf7Zi0A6WAoGwA26Wao7h6Sz+1O+
   YMlLN1ImbtLRmF07jboXsnp5OQazVy7S6DIDr9xxOSTkUr6aig6ODkKF5
   wAt4vH6XW6eguwFMfiMHiunTIQ4Ikv1BwNk5temOWCYh4Ec/a+HTyP0JU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="317348066"
X-IronPort-AV: E=Sophos;i="5.97,326,1669104000"; 
   d="scan'208";a="317348066"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 14:03:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="918559360"
X-IronPort-AV: E=Sophos;i="5.97,326,1669104000"; 
   d="scan'208";a="918559360"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 24 Feb 2023 14:03:22 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 24 Feb 2023 14:03:21 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 24 Feb 2023 14:03:21 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 24 Feb 2023 14:03:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1yt+NhD+iLWxsH+eFMevMGpTNXMRcg968L0CAE+6XigTxc70zU+DcUl7c0Y0c7OX2sG5Wdzze2pC8V7IebsF+YAE8FBsrjHcYWF2QqfxmdnUQ7sPWd2G04D3G3xr/pCTxJAdfNvEkAgPd9F7xEtMmpAjl2OLthry6nzdF3aH4F4cMij15xMuc/9VjEc+yzFkC55gcvEaQok4MqrioZbcCLRqN3m24KYG24oWamciH3vZYNRTn89bkh+xgLzXc7LLeHEw0JLEm23O3W6k3pTOuaSysqnAs396IEhhOZaoTVjQOl8Z+Yi6HGhy8xobUgmlpS4aWsxCxSjUnlcdmJBRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tHYnFrgaUpX5R1tfhbhsbkh0dVyzj/uP1sbPLioseLU=;
 b=emsm87l4i6ZtA6ASLPitRm7LhPSnget5F8f/rblEesdbnI3sNnKiXHB4zYKkNJOa61/SqQwKW5Cb1Uqp0qeuOeSUCUnckDir+x1RF3iM9U52FIy3zfRPIabCdZnpMOLMuHoKmST+C/Muo9A7uQx+57fvXMj4qrX2n5bvZLdfGfS0mX3O2e5/o4fNC3PY6ccrO9cIjFXlE4PPnbwSMRa+xyYoCS1fx7qk9qvkZBqObCG8IbiMthXLjC4xDXN5NbFTefpfEaQ9Ny6AwgVaa4yGVQSmzkmjRTB1J1Qwr+cuXNwLC6cR1WOjKIYmcc799p5RXh8oKthStJZgAem4xkuBnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 22:03:17 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::ee6a:b9b2:6f37:86a1]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::ee6a:b9b2:6f37:86a1%9]) with mapi id 15.20.6134.021; Fri, 24 Feb 2023
 22:03:17 +0000
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Borislav Petkov <bp@alien8.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "pawan.kumar.gupta@linux.intel.com" 
        <pawan.kumar.gupta@linux.intel.com>
CC:     Kim Phillips <kim.phillips@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Ostrovsky, Boris" <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Wilk, Konrad" <konrad.wilk@oracle.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v9 7/8] x86/cpu: Support AMD Automatic IBRS
Thread-Topic: [PATCH v9 7/8] x86/cpu: Support AMD Automatic IBRS
Thread-Index: AQHZMBHrCh+R2Wn7lEufQJMkJLt2Hq7eokeAgAAl4QCAAAeAAIAABqWAgAAALfA=
Date:   Fri, 24 Feb 2023 22:03:16 +0000
Message-ID: <SJ1PR11MB60834960ECAC976C1D328A86FCA89@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20230124163319.2277355-1-kim.phillips@amd.com>
 <20230124163319.2277355-8-kim.phillips@amd.com>
 <20230224185257.o3mcmloei5zqu7wa@treble> <Y/knUC0s+rg6ef2r@zn.tnic>
 <20230224213522.nofavod2jzhn22wp@treble> <Y/kzGEqafzQkbU4T@zn.tnic>
In-Reply-To: <Y/kzGEqafzQkbU4T@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|MW3PR11MB4522:EE_
x-ms-office365-filtering-correlation-id: fc961033-1869-461b-dc5e-08db16b2eecf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +Z9caEVLib8AMWoIP9+6mAc5RSG9ICdOC3H4LvEGj+3kV4+2rt78qF2+HOULUEznIsIZUGN+WG/WCc0XXCJmO0xbh2RpNtU9zo9fRR0Uu0qXm1lNrImzwAT4zZXV7RPaxCb6D2Eo6wa2ehaE/FYG0pe8TWUeWlh1nVQ7GBgx24EHOT0umWsIm8kZnOynMr9riSLIl0dsg/sAXA0EEEFtrx/L8PIEibVfmU6ZhNsw9TCSq8CLp4gCP7ShQ+jNa2GwKVA6eVLal6Qif8eAUNoqLZuTgkyGBgLOS1cGqTf5q4CzzPcJYngn+lsLZv3EYKN4x2itca2dRvd6WpCaRJcwbUVgZm+t+JjEEPMA1lWv2xuD4RXS18gFtX44pgT2YcqlFhQrpEYHnuLwCeTx8sJ54BPGYi6V861v9Q9f0raESZm6Yar3jwqw/tTs3FPYU+zv4FhvjYRJmk1BzmES23S6kQUU6rlg+BWM+sEXpDw00Kqqj9uxoEZ6LkExy6DO822yDVdf8VnUSO+fSlAXYQi9Iv9tzEAo6G3ojfCDzbW1oAix1P2sbzb9BregL0iub1GFnzHEdu44CXI9sfC5XLxFjCWwlmGYRWjaiwg+lQl8Rf9ul+XsQ3CQJREVj9YFJv2UMLNvMtqEygBkWnccWNHHmlRm9qJ1IX95H7ZWHRrS+TM64HAtE/GtpBel+d51eoa0wZ9cMsKk2LDc3AlYOQmUqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(366004)(376002)(136003)(39860400002)(451199018)(316002)(33656002)(86362001)(110136005)(54906003)(66946007)(9686003)(186003)(66556008)(2906002)(4744005)(66476007)(66446008)(4326008)(7416002)(8676002)(41300700001)(6506007)(478600001)(26005)(71200400001)(7696005)(55016003)(76116006)(38100700002)(82960400001)(5660300002)(64756008)(52536014)(8936002)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TjN3b3VkTGJzQWdSOGxJNlVkSjhZNkZNMUt5THhlalVxV2EyNW43MjVJbHFi?=
 =?utf-8?B?K0xINURmTDFuRkZoR2o3M2VzTm15MklxL0Yranp4YjVFYnk1bUVneGZST29X?=
 =?utf-8?B?NWo5NVBCQlNmODZWYnJFQWFDS2dQY1JROGs5NnhOc3BHOVN1WExRYzFwb2Mv?=
 =?utf-8?B?bDI2bG8rdWVreW9tbmR1WGxmZ0VjampmWGpqbkM5VUxTK1FQS28vc0FVN042?=
 =?utf-8?B?SlBJakRKSkJSUWNOU1FrOGVVTXV3aVMxQ0ZYSmk2NXZVY3JZQTNHNTEvaXdO?=
 =?utf-8?B?V3dxOUNBVzdGU3lkNGppazFHbWRLOHRKNEJXV3FuQmJzNU1wTzRiRnh5S1Y3?=
 =?utf-8?B?RTRuYTdUWlkrY2VWMUM3TlcwSGZveldIaW5aK1p1ZWEwcEljQVZCRGpONzlt?=
 =?utf-8?B?Q0wxNFRULzI4cW1rMDFBTGxlTmNrVS9mZ0E0SXhQbHprSExSbmNZSGx5a3or?=
 =?utf-8?B?aEZLVjZ1M3FhWUNQOXhMbUtwU2ZnbEh5TTl3M0RocHgxK3Zzc2NqQXY5cVNM?=
 =?utf-8?B?aktQQm5mWFB5cnV4b1U0ZkYxcU9MallwK1p5bVVjVjN4QlRJcGVHSnFKNDFw?=
 =?utf-8?B?Z2hxR1lYMTl5Mi9DaWgwSWxydDhLN3BNaFJzNmtoTWIyVGJ5SmVLOXVMbjF3?=
 =?utf-8?B?T1VUdW04YU1RaWIwU3lDa0lXRWR3N2RMNURJUWEzdE5rWXEzZkVWK21oMXFC?=
 =?utf-8?B?ZWNpdWtqL1RsM3JXaTVkNmVaVzhGZHE4emxlU2l4WEVoY0tuVHpOcmlyeWV1?=
 =?utf-8?B?K09ZNUxZQ3VxT2JDTVZsS2FwYWR5QmNIeU1SbU5aSEtmZmJvU2NWMDhjNGVi?=
 =?utf-8?B?T3dkb0U0eXFRQWdLRWRSWGxsS0YzMEtObUFXNllVdTg3Ni9ONGhZQVJxMUhY?=
 =?utf-8?B?R2pzeTk2RThqZzY3bUh3enI0akhoeHpNRDZJa1JyV1ZKRHBzK0tzeVc1R1RE?=
 =?utf-8?B?MmNWZS9PVVhpSktRMVBUUXRiUytKaDNzMzluN3E1M3lFcmRMK3N1aWlVbG5u?=
 =?utf-8?B?TFh3dlF5VC95MjUzeGN2V25CaUZ2bkZaVnlHMjNVVERHYlpnWXNmeE1iNjY2?=
 =?utf-8?B?cVc0Zkk5VnFjamF5S3dkQ3pWOGM3cWpIMEoyOGEyNU9zKzgvL1hkZkJLREp3?=
 =?utf-8?B?N1o4aHo4aW9mYWswQlAxWEcyNGxPYVVvQTBpZlc2ZXBzRmtQN2lGM1NYQndP?=
 =?utf-8?B?cEoycE5vSlg1TytkbU16Q2xpL1c4OEpiQ2VQNUw3MENKbk5jVStLUGJmUEJv?=
 =?utf-8?B?TmNudE5BM0gwU0t6dThWOVpXWXpuckdqVlBiZnRYSW44aVptWWJiMUhEMFRl?=
 =?utf-8?B?SjZ3ZzFJN3V3K2szNUtya3ZKbUJWblRNUDNCY0s2MUNQSU11STZQMTdscFFP?=
 =?utf-8?B?eDRZYjBFcTdOMVo0VHZ3SXNtTXZETFFDYWM5aGtDOTQxaFhUb00vS21BOFQx?=
 =?utf-8?B?ejR3OFVJR3k0aUJHTkRObldsRUxYWDFTM3lQMWVHMG5pQlRLK2RkRjFwbmdi?=
 =?utf-8?B?bGpkbEdLY1g5eENYeWh6MytkVWhudEJoZXdBOTdHRXNlTnRmUElNek9VVVNE?=
 =?utf-8?B?QklKK0dQdTkzaWxyY0l6QTIvRm8ySlN5N0dleXBFVFQ3MmpGTzFFZ1I0ZXRh?=
 =?utf-8?B?Ykl5NVhUdytweUlGQ2IvQk1LQkM3Q09idmtJcC9jMTI3VjNyb29uN2JDOHgz?=
 =?utf-8?B?M0grQVJSN1M2bEhhSlpFeEQyYTI5UEVSYS9ZTURaeldEbHNXNzFCQ1ZpNnR5?=
 =?utf-8?B?ZGNFNHQ1SnF0cVhqZm83NDgweGxmRmhuMUFsaVJVRkxQN3VzOGNYbzU0SmtM?=
 =?utf-8?B?SXk2bWU5cUR5ZGJTdm1kTW5NcUwwOHhjMEEyNkhwZnNEQ2QwZEdiaElka2V1?=
 =?utf-8?B?N3JhVUEyUTBVUHJ1bWVkdXowSzJpbGJDd2poUUI4ZW9FdGY1ZXM5ek1sSlI0?=
 =?utf-8?B?ZkZucUNmZ2p2bkpLY2hYRUFKK3lLSU83Vm94YjAyd091eDl6a3JmaE5tN0VU?=
 =?utf-8?B?WklXa3pXYUJsMUNicUtNNThqVk5kQk1mSU5GaVYxNDBxV3J4dkkyVG1MNlFI?=
 =?utf-8?B?RFNRdDFhWlhnU2Rlb2xKSkJjZzQyeFNBL1BLNFQ5dXBWemZtcnVTQlJZdy9E?=
 =?utf-8?Q?CstM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc961033-1869-461b-dc5e-08db16b2eecf
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2023 22:03:16.9178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GPg0/Mqv5JaDH9iClw9VFL46nJeI7TIUg20MkXg4R8sE32Owms1wMhj9I1+dzDOafo8bjnmGfWNM1RsXu/O4Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4522
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pj4gQ2FuIHdlIGFkZCBidWdzLmMgYW5kIGZyaWVuZHMgdG8gTUFJTlRBSU5FUlM/DQo+DQo+IFN1
cmUsIG1pZ2h0IGFzIHdlbGwuDQo+DQo+IEFja2VkLWJ5OiBCb3Jpc2xhdiBQZXRrb3YgKEFNRCkg
PGJwQGFsaWVuOC5kZT4NCj4NCj4gSSdsbCBxdWV1ZSBpdCBhZnRlciB0aGUgTVcgaXMgb3Zlci4N
Cg0KU2hvdWxkIGFsc28gaW5jbHVkZSBQYXdhbiBhcyBhbm90aGVyIHVuZm9ydHVuYXRlIHNvdWwg
c3Vja2VkDQppbnRvIGtlZXBpbmcgdGhhdCBmaWxlIHVwIHRvIGRhdGUgd2l0aCB0aGUgbGF0ZXN0
IHdyZWNrYWdlLiBJZiBub3QNCmFzICJNIiwgYXQgbGVhc3QgYXMgIlIiOg0KDQpSOiBQYXdhbiBH
dXB0YSA8cGF3YW4ua3VtYXIuZ3VwdGFAbGludXguaW50ZWwuY29tPg0KDQotVG9ueQ0KDQoNCg==
