Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC21163D0CA
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 09:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbiK3Ifm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 03:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235410AbiK3IfH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 03:35:07 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D092165A3;
        Wed, 30 Nov 2022 00:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669797296; x=1701333296;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wMK5tiNWlfczCRDKGXn81e3baM+qCpIcINMUaPNG9v4=;
  b=B3Yz3fvdthGVMdlY4DvfO/bLpIeISfO7uo+0Ir1Xvt3ydjifOfMsvFEY
   IDgGUURIy93mqHq6bu4Gmxcebps2mcSX8udwZ2SzTo94ECzIK0RgeAFyB
   f160dPEqSeHG/W01KIGKjQ4WDGN5+Ta/8BfNlkvoUt6n1nFADsS/ux06P
   PjQ9/tqiV4OYrUsZ8fJsOYvdfAO6J5pgekWp/d48u/X7hBh4PoK/3Agwl
   yBdY+ZXM0TYe6iemWxw9HJQveX4loRWKHGQW6cTvsioNamYJhma48wy7Y
   J9Df8XSzJ4mqGj9loasYirhnAM9ClnFilZABW2g5O8ErQvhIo+sLSEdvZ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="312957704"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="312957704"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 00:34:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="646246197"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="646246197"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 30 Nov 2022 00:34:54 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 00:34:54 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 00:34:54 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 00:34:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUBPv5uWIPGJWsjttwXN9lXilsc7l5s2jp8kpBkUbvGkER1oluZohpBjg9rKOgqbXimnG/ObFvCrJxYA8u3ZjidDmWttxVhwrq8IqKhSwS+nCnCenyii8PNbqiJ2+mPqLoaz30mbNDSyGcL4QGOxD1Iaa0cNOcDSlYaIbNtn6E566yYQWSyRvxSL533h70T2bs3xeu+hil0NrCI46TqUqb7QNQMZWZb8sn/9/00w4I5E2SqBR91o+GhFLCnpbIAGg5C+8SFM4OGCcE9KRQlOO6L0P4keKjdvnOHOzz0cVWMkiR8JRiBppCnl5TRk3rJk3Y2NRd0ePpIR+NCyEALh1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMK5tiNWlfczCRDKGXn81e3baM+qCpIcINMUaPNG9v4=;
 b=TuRsMxv7As8Mp2NP1UlIa1RKYNmgrARXWMX1frKpRyKstqjKCi7LKDWPjFbSM6fgQBAhReYaX2Y2HD6a0PoZbjGRLb2cKazXbuK82ELXUivsUwxf8COIZP9xscw9PdZC3GtTDT2ZPKvtXYlUfplD+XZNsk2xpfq0bre0m8O45WZlzMrye+fnAalmc/8+k5M50eBUg9YQUZy0D/ElENIXio9g8tEXQyMu2E0kSj5pHHp/jjtEzXtAaXPefsPz3dgMoFWUROouEAmisKDu481AqOdZJxw1dgPbhDHn7hKrf2zLej2X7MRZFW1wWIYLxUWO+iK1ygJQPU70RwogVXlkgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6941.namprd11.prod.outlook.com (2603:10b6:806:2bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 08:34:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%9]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 08:34:46 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
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
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 17/20] x86/virt/tdx: Configure global KeyID on all
 packages
Thread-Topic: [PATCH v7 17/20] x86/virt/tdx: Configure global KeyID on all
 packages
Thread-Index: AQHY/T3LiMVg2HYmLEKsa3j9uYLXLa5W3zSAgABTgIA=
Date:   Wed, 30 Nov 2022 08:34:46 +0000
Message-ID: <3d19683cdc13b7a3884f1e9e75743e922d4630f3.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <8d8285cc5efa6302cf42a3fe2c9153d1a9dbcdac.1668988357.git.kai.huang@intel.com>
         <a537b97b-0bdc-5bcc-9ce7-470f8fc1245b@linux.intel.com>
In-Reply-To: <a537b97b-0bdc-5bcc-9ce7-470f8fc1245b@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6941:EE_
x-ms-office365-filtering-correlation-id: e47d515d-ba8d-4362-e587-08dad2adbc97
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E5TYTf527tQ4C6x3uSRi0vxyy189AaNzax1Oc0GuTRfz9DAOFbXwFTPEPpiocrphVGuvtKcVnja+0ITwdk6RPlVAxXKHs+JlSPYYm5i7X+aN1/XJAhzJbgRXDsIVkFCQXCP7gHgM+GR9N/xbn2t0miXa/We4XxSQw3R0E/Heu4BQf2OPExFMZllppQ0l2xujoSipGErGIlDPEn5PoQc8trgZjGn8Jy2JnpcouUBJtSdgMzSeNMMfK0NHuFRRhXxPFJe+vP2C2Z2lv5Vq0pQBBeN7txUe3thQB6d+v5E6Qj6qUao6jszPs59oJWrDXGZA2Ga3DbyzscKwdbnEXBLmRxqjW8M2y2r7/SAkNqjICJLxmSVGXcA2NT4n1ulrA00+41hkYt0K1wT2EazE9Zdit1Tqu8eXQ7AJhgfTiKVvPnLyhqTtrZ2kxjqOPM6K8ClyKDGi79oFUzIi21ZXcGTTD+W+csYh1XJOWbHJQChq5hkYCaCSj/qRayy7QhiMYxZVK8CJRVRVKezM/FDx9WU1v61qmOBwl6W1m3b//PAb3JBpR0uRX9Zb6VUyRA26KH3XPeSmE96NpeR1eaTSINE+0sEzg2P7QOe6s7bWvcduqa8UgJF0GZ7LsijitZiPBagN4VdmNsIzF7bPshRDNhXXxkBtGzjp2Jfslf6uIHIUBTyMDWrD1FNXQXl8vMXv3tpPsEXVzLk6l86OV2j7Dggogg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(366004)(396003)(376002)(39860400002)(451199015)(8936002)(7416002)(4001150100001)(54906003)(478600001)(66946007)(316002)(38100700002)(91956017)(76116006)(83380400001)(66476007)(4326008)(82960400001)(110136005)(36756003)(8676002)(5660300002)(41300700001)(66446008)(186003)(2616005)(6506007)(6512007)(53546011)(64756008)(66556008)(86362001)(2906002)(26005)(6486002)(38070700005)(122000001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?REtrcVpFUld4c2N0THAxNXkxUXNzbU53eG1zVlFrRTFmRnh2U01Jc0QwY0Nh?=
 =?utf-8?B?ZVdZclMxcUNEQmNqeXpTU2NFckdqUzBuVUJXc01LRHlVL2ZjYVp3N2EyNmFn?=
 =?utf-8?B?Vm9KQlU0cmZiMVA3OWFBbFBmeGZNZmFzUHlCTnIzdWxJc0dqWkl5ZTk2N0Uy?=
 =?utf-8?B?RWFIcU0rY0cyNDE4a3NQbVBDOHprRERBM21CVit6VXhsZ01yWDVMbHZNY0lq?=
 =?utf-8?B?cm9SbUR2emRjR1dhaWNGUGxvbVZHVDNDRmVrSFFkZ3M5L0llT214MFliMEwy?=
 =?utf-8?B?RzhrTGRZTDlhN3VkYUNLRnE4ZkFOd2JtN21Ld1N0cW16RXFjM2RqNDgreDdt?=
 =?utf-8?B?UnQwbjlDbFJMQzNsSUsraXlCOHBWVGRKa3JQcGFtM3NTUDJUeFVDYzA0MzQv?=
 =?utf-8?B?a1YycENOL0hkOHg4YjFYQkIrdFZMQm1SdjJRZHRSalRad3Ywcm9RdHgzNGl4?=
 =?utf-8?B?T29OL0pDbVIrK0g2NVdmbHlGSjFiZUdwbU1ncjYvSGpSOXUzV3lRU2dLNllU?=
 =?utf-8?B?NVIyOWc1YlI5ZFNLNE1JSlA0QUY1UnNpbHB4eHpMTndveXhLWVh2ZEpvWEg0?=
 =?utf-8?B?NE1Cc0lEbW5rYXZwR0pHTXZGbGFuYVVsTmV0MlZKNkZOb0FGZlZXcnRjbWU5?=
 =?utf-8?B?bnZCRG02REZ6Tnh1TEpVN2lJczNSazVDL20waUlvemZTU1d3dE12Vk41QWxl?=
 =?utf-8?B?djhZc0RrWWNjOTlreW85VVVldFk5ZlBNbXdEcGpXM3BtRGZVcWZ6Mk5ZNFpj?=
 =?utf-8?B?TnVZLzhEZ3laVEFscUNPclJxOW5XV3Y1YmhWMjdOYjkwWC82WFRNWXB0MnBt?=
 =?utf-8?B?bFdndlJyd1p4L0NlaWRDS1d2bFJZRHVydy9XWTVES1dQSDhhQ1I1ODdITDFY?=
 =?utf-8?B?Q1ZIZ25EZW1pKzFCbGVkWjUrSUh4Zy9CLzlUY1pHTC9kTG83V0RaVndKQklS?=
 =?utf-8?B?U0k0cUtkZU5saDlMaDg2T0dGUUtyck5Td2hTQ2dQWWJ6eWp5ZkhwTmxaVzlz?=
 =?utf-8?B?a2NTOHBhSFNSK3F3akY4VHJBVitzR0dzeGxtbWp2QTU0ZkN0WHBrYURWS3BM?=
 =?utf-8?B?MWNmbTR6eVFvOFl3YlRrejdJb1pMc29DV3NZQXBFcEtWUnozY09SdjQ5MFl6?=
 =?utf-8?B?UFBBRkIrNjhBNElLRi9Gam5rYXMyR2Eyc2l4V0NqQmdsQXNWQk5WeEUwVkw4?=
 =?utf-8?B?TGxQWi9wdmJRWEl2YWtIR2s1bWs3ZGw0T0lEeVFVbk1tK1Jjc3R6ZEIzd1dN?=
 =?utf-8?B?V3N1cmFxZi9oRXdxU01oajRDdVBqQVZhMjExQnhMZGZpQVg4di9ORE5Zcitu?=
 =?utf-8?B?dHdqQXlTamIwdXVONjNJT0F2cWVRWU1zVisyazdVK2kySHNCTlB1UjZMb3h4?=
 =?utf-8?B?N0JhM3QxM09nTEVIOC9uWEhDNkU0Uy8yUCt5OGVCQ3NPN1AzRk1rMGFnbWl1?=
 =?utf-8?B?Q2tSemwwaHQxZUVodjFVQ2JWTnliRHJmQzRPM2xVSEtqWGJkMDRRVWJQQnBv?=
 =?utf-8?B?ZHc1cEdoRzE3NSt6MlZqUmN1elVkRnVFSCt2ODNVdkdYMGtDRGsvVVhxWVhm?=
 =?utf-8?B?VVhpMlZTelczVGlQY2RrRjhOYUVPdzlhRkxhSmFhcy9QbkY1RmlkdTViU0tU?=
 =?utf-8?B?dGpOSXRQbExvNzdFbW1zSldQRTB1QVNDeTBFTld2Z3oyZlJKZjBLOUgyNGJJ?=
 =?utf-8?B?eG9uVzRreklLeDc0a0p5NFRtNmp6aHZvRWV6eG1ldlNOU1BHMURMZ3pkMzFw?=
 =?utf-8?B?QlRJRFltS3NqRzkwaHlHTFhOMHpHcjZIazU4M2VYOWZVU0czRjdGZ0ZPd1Bi?=
 =?utf-8?B?QTlCMGpFa2k5bXEvV0FlNmp4K2JRaUoySG80aVRBVC9UVmlzNUg4U0hSQit2?=
 =?utf-8?B?YTU3QTZQTm5VN3NTYTVQNE1RSTlBYzFXOEw4ZHhLS2g2dHlZdzVhUHAyV1NT?=
 =?utf-8?B?bGlKWk1IaXUvbCtHaTZQNVh1amFiWExOY1ZFTWh4V3V3MjhMVHdzMFhVVUdv?=
 =?utf-8?B?UWJKelJrTjlsMVZtOGNKai9YdlBVbXY4WWhXUTM1ZXFER2U2NUxTZGJOK09z?=
 =?utf-8?B?RlZIczl2N2VQcDNDejlKN3orQVBKMWk4SDVsTDIyWmNUS29rT2JsU2pYZ2pK?=
 =?utf-8?B?YnVvSEhod1dleGtoL3N6ZkNZZ1JBeHBNMzBqNjB6Wk9NOTJicmM1aTJaZ0tl?=
 =?utf-8?B?UXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D4870BA2CC14D42A3AE7876BF319CEA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e47d515d-ba8d-4362-e587-08dad2adbc97
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 08:34:46.1125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cxNzWMkVsxj9t5klJXYro1MUdeiz9XCGawVtuz8BvD+lx9yVGUhfyHQemWmSNiDvQzq/OYZxZUHU23ACN7VGkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6941
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTMwIGF0IDExOjM1ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IE9u
IDExLzIxLzIwMjIgODoyNiBBTSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IEFmdGVyIHRoZSBhcnJh
eSBvZiBURE1ScyBhbmQgdGhlIGdsb2JhbCBLZXlJRCBhcmUgY29uZmlndXJlZCB0byB0aGUgVERY
DQo+ID4gbW9kdWxlLCB1c2UgVERILlNZUy5LRVkuQ09ORklHIHRvIGNvbmZpZ3VyZSB0aGUga2V5
IG9mIHRoZSBnbG9iYWwgS2V5SUQNCj4gPiBvbiBhbGwgcGFja2FnZXMuDQo+ID4gDQo+ID4gVERI
LlNZUy5LRVkuQ09ORklHIG11c3QgYmUgZG9uZSBvbiBvbmUgKGFueSkgY3B1IGZvciBlYWNoIHBh
Y2thZ2UuICBBbmQNCj4gPiBpdCBjYW5ub3QgcnVuIGNvbmN1cnJlbnRseSBvbiBkaWZmZXJlbnQg
Q1BVcy4gIEltcGxlbWVudCBhIGhlbHBlciB0bw0KPiA+IHJ1biBTRUFNQ0FMTCBvbiBvbmUgY3B1
IGZvciBlYWNoIHBhY2thZ2Ugb25lIGJ5IG9uZSwgYW5kIHVzZSBpdCB0bw0KPiA+IGNvbmZpZ3Vy
ZSB0aGUgZ2xvYmFsIEtleUlEIG9uIGFsbCBwYWNrYWdlcy4NCj4gPiANCj4gPiBJbnRlbCBoYXJk
d2FyZSBkb2Vzbid0IGd1YXJhbnRlZSBjYWNoZSBjb2hlcmVuY3kgYWNyb3NzIGRpZmZlcmVudA0K
PiA+IEtleUlEcy4gIFRoZSBrZXJuZWwgbmVlZHMgdG8gZmx1c2ggUEFNVCdzIGRpcnR5IGNhY2hl
bGluZXMgKGFzc29jaWF0ZWQNCj4gPiB3aXRoIEtleUlEIDApIGJlZm9yZSB0aGUgVERYIG1vZHVs
ZSB1c2VzIHRoZSBnbG9iYWwgS2V5SUQgdG8gYWNjZXNzIHRoZQ0KPiA+IFBBTVQuICBGb2xsb3dp
bmcgdGhlIFREWCBtb2R1bGUgc3BlY2lmaWNhdGlvbiwgZmx1c2ggY2FjaGUgYmVmb3JlDQo+ID4g
Y29uZmlndXJpbmcgdGhlIGdsb2JhbCBLZXlJRCBvbiBhbGwgcGFja2FnZXMuDQo+ID4gDQo+ID4g
R2l2ZW4gdGhlIFBBTVQgc2l6ZSBjYW4gYmUgbGFyZ2UgKH4xLzI1NnRoIG9mIHN5c3RlbSBSQU0p
LCBqdXN0IHVzZQ0KPiA+IFdCSU5WRCBvbiBhbGwgQ1BVcyB0byBmbHVzaC4NCj4gPiANCj4gPiBO
b3RlIGlmIGFueSBUREguU1lTLktFWS5DT05GSUcgZmFpbHMsIHRoZSBURFggbW9kdWxlIG1heSBh
bHJlYWR5IGhhdmUNCj4gPiB1c2VkIHRoZSBnbG9iYWwgS2V5SUQgdG8gd3JpdGUgYW55IFBBTVQu
ICBUaGVyZWZvcmUsIG5lZWQgdG8gdXNlIFdCSU5WRA0KPiA+IHRvIGZsdXNoIGNhY2hlIGJlZm9y
ZSBmcmVlaW5nIHRoZSBQQU1UcyBiYWNrIHRvIHRoZSBrZXJuZWwuICBOb3RlIHVzaW5nDQo+ID4g
TU9WRElSNjRCICh3aGljaCBjaGFuZ2VzIHRoZSBwYWdlJ3MgYXNzb2NpYXRlZCBLZXlJRCBmcm9t
IHRoZSBvbGQgVERYDQo+ID4gcHJpdmF0ZSBLZXlJRCBiYWNrIHRvIEtleUlEIDAsIHdoaWNoIGlz
IHVzZWQgYnkgdGhlIGtlcm5lbCkNCj4gDQo+IEl0IHNlZW1zIG5vdCBhY2N1cmF0ZSB0byBzYXkg
TU9WRElSNjRCIGNoYW5nZXMgdGhlIHBhZ2UncyBhc3NvY2lhdGVkIEtleUlELg0KPiBJdCBqdXN0
IHVzZXMgdGhlIGN1cnJlbnQgS2V5SUQgZm9yIG1lbW9yeSBvcGVyYXRpb25zLg0KDQpUaGUgIndy
aXRlIiB0byB0aGUgbWVtb3J5IGNoYW5nZXMgdGhlIHBhZ2UncyBhc3NvY2lhdGVkIEtleUlEIHRv
IHRoZSBLZXlJRCB0aGF0DQpkb2VzIHRoZSAid3JpdGUiLiAgQSBtb3JlIGFjY3VyYXRlIGV4cHJl
c3Npb24gcGVyaGFwcyBzaG91bGQgYmUgTU9WRElSNjRCICsNCk1GRU5TRSwgYnV0IEkgdGhpbmsg
aXQgZG9lc24ndCBtYXR0ZXIgaW4gY2hhbmdlbG9nLg0KDQo+IA0KPiANCj4gPiB0byBjbGVhcg0K
PiA+IFBNQVRzIGlzbid0IG5lZWRlZCwgYXMgdGhlIEtleUlEIDAgZG9lc24ndCBzdXBwb3J0IGlu
dGVncml0eSBjaGVjay4NCj4gDQo+IEZvciBpbnRlZ3JpdHkgY2hlY2ssIGlzIEtleUlEIDAgc3Bl
Y2lhbCBvciBpdCBqdXN0IGhhcyB0aGUgc2FtZSBiZWhhdmlvciANCj4gYXMgbm9uLXplcm8gc2hh
cmVkIEtleUlEIChpZiBhbnkpPw0KDQpLZXlJRCAwIGlzIFRNRSBLZXlJRC4gIEl0IGlzIHNwZWNp
YWwuIEhhcmR3YXJlIHRyZWF0cyB0aGUgS2V5SUQgMCBkaWZmZXJlbnRseS4NCg0KPiANCj4gQnkg
c2F5aW5nICJLZXlJRCAwIGRvZXNuJ3Qgc3VwcG9ydCBpbnRlZ3JpdHkgY2hlY2siLCBpcyBpdCBi
ZWNhdXNlIG9mwqAgDQo+IHRoZSBpbXBsZW1lbnRhdGlvbiBvZiB0aGlzIHBhdGNoIHNldCBvciBo
YXJkd2FyZSBiZWhhdmlvcj8NCg0KSXQncyBoYXJkd2FyZSBiZWhhdmlvdXIuDQoNCj4gDQo+IEFj
Y29yZGluZyB0byBBcmNoaXRlY3VyZSBTcGVjaWZpY2F0aW9uIDEuMCBvZiBURFggTW9kdWxlICgz
NDQ0MjUtMDA0VVMpLCANCj4gc2hhcmVkIEtleUlEIGNvdWxkIGFsc28gZW5hYmxlIGludGVncml0
eSBjaGVjay4NCj4gDQoNCktleUlEIDAgaXMgZGlmZmVyZW50IGZyb20gbm9uLTAgTUtUTUUgc2hh
cmVkIEtleUlELiAgRm9yIGV4YW1wbGUsIHlvdSBjYW5ub3QgZG8NClBDT05GSUcgb24gS2V5SUQg
MC4NCg==
