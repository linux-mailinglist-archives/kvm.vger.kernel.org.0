Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76FD7730DD0
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 05:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240402AbjFOD7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 23:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241688AbjFOD7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 23:59:13 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5272707
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 20:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686801551; x=1718337551;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=whtsuHTPDT68bXgYZ5ymb0xcqPn9O20lgLMJDzQj5ZA=;
  b=b/v/lLIRDPNy8t6GCXSV0Mo2QGurHbgufBrJzGBdocC0IISgoolya0o/
   B+z98QebX8HVqwxoUDXu20uvlM45ssEKWV21LKkcClEJpC6AOkWSVcaNS
   w/qyTkYmb+Cg0zZqHq3gFz0ne5g2rcCIXVb76FNMm8pBcwKQegDIkMfgP
   IkOUgqtLNX74cWlwEW4gpU1qmORghU5i7/rxjRAaRlWMg5sJlggmdmqNG
   2r1jgbe8P1p5sYdfcQV6Ljm8VWkGM/pvIPSm+587AtiIkdMw7Z7b4LMB6
   1biQ/0Au8CFQftSng9SHO5yNjmYqSWqHkff7cSALKoH+6xh0hHdPf14S/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="362185037"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="362185037"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 20:59:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="662628594"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="662628594"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 14 Jun 2023 20:59:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 20:59:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 20:59:10 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 20:59:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h27Wb0XOpH1TYxirNyWKukpEi+EIEtGJpvZKrMQ3rkMu1xhYC/BS6jZfW0sqERQHPoc8NjgYBxgUVulr9MljNjKna5xajoXz9Fdo0zVR8l9mjQX2oXQQNa2CmUHoTVo8bXc4eOgZ/+qQWu+pudbcWQk4NFKaXIBiXARj+kwk0gd7ORCwaPHFTZ5ruHnbr9u6wwVs3XOQRqt/baTkIY8L+jTcVmtWDk0hl6onEi0GhRWN2GLWvgslVVQeL5Os1HSL7yb3m3uX3BTiBHnjPHQ+c8B5gcB0qb+TP0KwRc/zbL7FKdOTYwuLjYBPNomBp4EYzGjd9Fgow/Bbnl9omfEtPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=whtsuHTPDT68bXgYZ5ymb0xcqPn9O20lgLMJDzQj5ZA=;
 b=hbgw1BKztIWpGIcAg9YgluDC/hAK/NKbeoHhResFdAf8V+rWbdTSMtSxkz8USXX3Et3ut+R3onzlGydipIfL2elkCoKc6HiXCGt3toQM1So7o5tI3AIXJzoCVdzj6UCcsUXnsS3Pr2AmLQ8QTxh6Q+XZYnUxcACxSHC3N9U7Md4iCmn7uuatiCrpCbW2Sj6Rh/fY8j6y7fuRjZalx816KiK3u1W2LR526QUZZVso7biBKizTQWsiKa5+/oQsUXyI1Y/WVs3GQmN7N9erjf9AfaM7ziqT/MHZt/IGW7voAlRSE5VI5/jBS8VOngTH7smMZ1NI2Fsu+SWmHP1qbf82Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB5923.namprd11.prod.outlook.com (2603:10b6:806:23a::17)
 by LV3PR11MB8506.namprd11.prod.outlook.com (2603:10b6:408:1bb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Thu, 15 Jun
 2023 03:59:07 +0000
Received: from SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::a86d:e44f:380f:86c6]) by SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::a86d:e44f:380f:86c6%5]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 03:59:07 +0000
From:   "Chen, Jason CJ" <jason.cj.chen@intel.com>
To:     Dmytro Maluka <dmy@semihalf.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "android-kvm@google.com" <android-kvm@google.com>,
        Dmitry Torokhov <dtor@chromium.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Keir Fraser <keirf@google.com>,
        "Chen, Jason CJ" <jason.cj.chen@intel.com>
Subject: RE: [RFC PATCH part-5 00/22] VMX emulation
Thread-Topic: [RFC PATCH part-5 00/22] VMX emulation
Thread-Index: AQHZVMjjkIJAGzww10G2XmdQMAuYo6748H2AgAGKPYCAh36zgIAAQRjggAB2bYCACR8P4A==
Date:   Thu, 15 Jun 2023 03:59:07 +0000
Message-ID: <SA1PR11MB59239A8DC6A0B38B0C70CFD8BF5BA@SA1PR11MB5923.namprd11.prod.outlook.com>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
 <ZA9WM3xA6Qu5Q43K@google.com> <ZBCg6Ql1/hdclfDd@jiechen-ubuntu-dev>
 <75a6b0b3-156b-9648-582b-27a9aaf92ef1@semihalf.com>
 <SA1PR11MB59230DB019B11C89C334F8F2BF51A@SA1PR11MB5923.namprd11.prod.outlook.com>
 <309da807-2fdb-69ea-3b1b-ff36fc1d67ec@semihalf.com>
In-Reply-To: <309da807-2fdb-69ea-3b1b-ff36fc1d67ec@semihalf.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB5923:EE_|LV3PR11MB8506:EE_
x-ms-office365-filtering-correlation-id: ad1b6e8a-a242-40cb-9aad-08db6d54de15
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0h+UhuLhiZPklXKLx3XhWtF6ssDjwvxfakBJQrggALmfXiE/5BagXTr2JcVf6LqCxnsN5n7gpO+fBLjbNtgwMwVwNkJxYKtIkVhgPClcVWA+psoDCMfXfkfhZha4XGJ7I92fSm5Ugj0LGMXRoVlmMLi4bcbzekBqO8vwG5SMEEw4Iphiw07Hwv93vG4TBGlIPp2c60YlRQS+wMBOV+UvL7U1I7PIBlpMTq9LuCYY7QbmX4kNuVAkVpSO+sRm1yysIJUYWXnHdNf/9WM2RV7PqG4TxkZQscCEJoEELK/kmknuuFT/GMvy3yTEZ3kQJfWeVuhUXq2IIvONFRpdsrXTtfK1rpE8ngsfYASwGiR7yYhHCKPholtZda3m0lJcnrahL886/YYH57oqO2LH3FxgN2TUscIXQvF4MFJwTd64MEhBx75eV+TJw6vVo1CR11chbRlv99/V2SgwqdkbJK0yoxYIfXdacduftiwhb9BchOFBNg5YOF62I3Ep+mOpQsokTJ+EC/yvWsMnT8bfeQa8r4TPTZZR7Soaz6BOgXbEKWEAcoCTw2sZkTMwNtH4ju7snabUvS7nu38FzMZvG+taaZB4xif5jXc+Uhex5J7k89psnVrOEXuCH1OI03jlE4Zr/eOII/kuzxQ9QAhPKzaEsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5923.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199021)(9686003)(6506007)(107886003)(478600001)(26005)(53546011)(186003)(55016003)(71200400001)(7696005)(2906002)(8936002)(316002)(33656002)(41300700001)(8676002)(38070700005)(86362001)(122000001)(52536014)(5660300002)(82960400001)(38100700002)(110136005)(54906003)(83380400001)(4326008)(64756008)(66946007)(66446008)(66476007)(66556008)(76116006)(399854003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZnZCa2xCZkpsL1lFTWRxZk1HNEx4U2o0MzRDZmI5Yi85bEZFWUtvQUJlK3d2?=
 =?utf-8?B?dk53aXVnK1B6bGFQU3ByYUpaNHNkSVljV3kxcDUydmZOTUorZm90UFFNbjhO?=
 =?utf-8?B?cWFidE1xR1preVpHMlpDU0YxRmVkYllUWEU4LzI0OUpmdVMxdzBOcFZ3NjVO?=
 =?utf-8?B?d1oralh5b1A0K2VvQXR4T0V4RGQ5UnRjcmFEVkZHMVBqd20rZzBLemtDYVVn?=
 =?utf-8?B?djZzT1dSbTRpdmoxdlpBSnJLZ0xLY0lwYWcwTTJCSEZXRktIZStkR3Awd0Vy?=
 =?utf-8?B?Q1VCZXdhQVdzTkk5SEs4NU9ZRGNMNFJMZkhoWDJrdHY5M2hGeDVyV3oyWnZo?=
 =?utf-8?B?SzJTanhsdmFpdytxeE4ySXZwNmdzbXhrRWUrVzBkR3o3NTZqUldxYWY1V2JI?=
 =?utf-8?B?UHJHbVl2aENicG5yYVdiS2lEY3I5UVhZUCt5V0hCOVIwSnVlNkZySDFxU2ZK?=
 =?utf-8?B?eTFvZDNYbkxsYjFOdnBnWG8yYkdQMFNHUWFQMkhnZEhEbEJxUjRIR2FxcGhY?=
 =?utf-8?B?UktESU9PVXVXSTAxMjYwYXZFTkhuemVCck5RdkYrcklTckdKNm51VWJ2cUwr?=
 =?utf-8?B?U2xXR0NrL0RENXdYZG9reXllRUdJcGZtMWFVL2pQcVVITnQxbGNtTjdGeksw?=
 =?utf-8?B?dkZhWUhSVU4xL2lMTHR1U2t0VGxROTRWbUR2bHAwQW1YNWxDekZiUi9DN1Y0?=
 =?utf-8?B?a0Jud2pkaXJyZkhSM0FCZ2tyY1dUa1JuVVR6OGFiSnNaeHB6ZFRYVGZKWU9V?=
 =?utf-8?B?enloRlZDRFA2RTlBZkFobU85M2JvWHFSYUNtMGZmTDFib01kVS9UMVZtNXJp?=
 =?utf-8?B?RVJlcUVmais5Si9PeWVycWo1ejZBZ21EZnNyZm5iLzdScmkrcG9sRmRpTFdu?=
 =?utf-8?B?UXhaSTFhdHpHY1I5c3NwWEwxVTVFSVpCZ1VjdTMwNnRtUXFpSkthVWhxK2dU?=
 =?utf-8?B?Sjk3Y1NETFZ2dHdoYTFTNE5LYW1lMGpoRHdsVDV3RmdueDRlS3N4Z1VJQUo3?=
 =?utf-8?B?WFBRVEd2b2JZQWxMTExGYUJvZXBTdGQwQnYralJWbUwrYWVpd0JVMEhhUjVj?=
 =?utf-8?B?RnZoK1ZHa3ZreDZNK0RlRUprNFpmdWFVTE9nSXY3Q1RSZWRhYjVIbjQvSHMy?=
 =?utf-8?B?TjVlb09TSHpRRXQ4cnllMGE2dUpuSklJcmh0RmwrTk1aZ3E2NWJKODJabHky?=
 =?utf-8?B?L2djOG1sa1NzZ0hZL2lpa2ZVYloydFgvMDdVK3oxdkhsbWNlWFJYbjdDYmVV?=
 =?utf-8?B?amoyVkdWODZTekFLaUFiaW04SEtkaG9LVk9nOWI4TXdJZWh5elFvNWpDSzh3?=
 =?utf-8?B?UUE1aTFTenlSNUNjK0RkZVJoZjdyR2tiYzRLeGM4MXdaOHBwbHpnSjNDREFL?=
 =?utf-8?B?Mnhic3dMdkxFTTJNYkZVZysxWFgrVGNtdEsvVEh4dm0ydXZXb3pscHZpMWtP?=
 =?utf-8?B?RmgxaldGSmZIaWJqTlJ1UStzSWVSVmdxRit0UnMwbkJNcU9pemduejN5aTUr?=
 =?utf-8?B?RUZ1aFFleitDeHdONEdjQmxVbGU1d2VHUVNtaWJEMkd6RS8rMncwY2dKKzVa?=
 =?utf-8?B?YXUya2liekluOHhHWDdSRkx5ei9rTWMyc1FZYlBsREl5clI4WmRNUUhieUYx?=
 =?utf-8?B?UGgwdjIvMVV5V3pTSVViUnMzS2JYYk5CRUlwZEd2RXJCa3ZMOGRmU0NBUWYz?=
 =?utf-8?B?YnpYREViWldUVmdycGE3T0lRNmFSSGJvNjl4OXJjUTZERysrUGwxVldIUUUz?=
 =?utf-8?B?RHJ2Y0tzcytPR1Z4NmxZeHBPWnpZak1DUHpXZnltNTR6VmRUY3kwTVpYaGly?=
 =?utf-8?B?MFo5eGMzbyszMnpNbmJzSXhxNkpidkVxQkhiY05LcmQrMVU2Tk5JLzdYUnRt?=
 =?utf-8?B?TjNDRndUaDZCS1pWd0ROclpVWWV3cDZwQXhCeU5TdTZNdVFkc0RBR3FMWEtF?=
 =?utf-8?B?VzB4NFp2aEZvcWI3QUNBSVlFc29MRzRTOG50cFQvNTVtNkljYWJmbkgzd0o0?=
 =?utf-8?B?YzRMejBvWk50aWYyTEYrb3hQNHZ4U2QxcTlGZ1YrUDRwUHFnekFXbFkrRVpK?=
 =?utf-8?B?UElRNzFTT2hsSVNsVlc1MGNQYXJleGRwWjd5OTZUNldBRjBxenc0OGV5ekln?=
 =?utf-8?Q?4nhCbtHVqhlPsmdvepJpV4FvR?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5923.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad1b6e8a-a242-40cb-9aad-08db6d54de15
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 03:59:07.3532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6M5s/bZoWZgO6TA4KuppVqoeJto9bC8UikLvVrf3p61pANralM/80DG3neR8VamtB16Z8wlyZnWIg9giIdoyFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8506
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEbXl0cm8gTWFsdWthIDxkbXlA
c2VtaWhhbGYuY29tPg0KPiBTZW50OiBGcmlkYXksIEp1bmUgOSwgMjAyMyA0OjM1IFBNDQo+IFRv
OiBDaGVuLCBKYXNvbiBDSiA8amFzb24uY2ouY2hlbkBpbnRlbC5jb20+OyBDaHJpc3RvcGhlcnNv
biwsIFNlYW4NCj4gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiBDYzoga3ZtQHZnZXIua2VybmVsLm9y
ZzsgYW5kcm9pZC1rdm1AZ29vZ2xlLmNvbTsgRG1pdHJ5IFRvcm9raG92DQo+IDxkdG9yQGNocm9t
aXVtLm9yZz47IFRvbWFzeiBOb3dpY2tpIDx0bkBzZW1paGFsZi5jb20+OyBHcnplZ29yeiBKYXN6
Y3p5aw0KPiA8amF6QHNlbWloYWxmLmNvbT47IEtlaXIgRnJhc2VyIDxrZWlyZkBnb29nbGUuY29t
Pg0KPiBTdWJqZWN0OiBSZTogW1JGQyBQQVRDSCBwYXJ0LTUgMDAvMjJdIFZNWCBlbXVsYXRpb24N
Cj4gDQo+IE9uIDYvOS8yMyAwNDowNywgQ2hlbiwgSmFzb24gQ0ogd3JvdGU6DQo+ID4+IC0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IERteXRybyBNYWx1a2EgPGRteUBzZW1p
aGFsZi5jb20+DQo+ID4+IFNlbnQ6IEZyaWRheSwgSnVuZSA5LCAyMDIzIDU6MzggQU0NCj4gPj4g
VG86IENoZW4sIEphc29uIENKIDxqYXNvbi5jai5jaGVuQGludGVsLmNvbT47IENocmlzdG9waGVy
c29uLCwgU2Vhbg0KPiA+PiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+ID4+IENjOiBrdm1Admdlci5r
ZXJuZWwub3JnOyBhbmRyb2lkLWt2bUBnb29nbGUuY29tOyBEbWl0cnkgVG9yb2tob3YNCj4gPj4g
PGR0b3JAY2hyb21pdW0ub3JnPjsgVG9tYXN6IE5vd2lja2kgPHRuQHNlbWloYWxmLmNvbT47IEdy
emVnb3J6DQo+ID4+IEphc3pjenlrIDxqYXpAc2VtaWhhbGYuY29tPjsgS2VpciBGcmFzZXIgPGtl
aXJmQGdvb2dsZS5jb20+DQo+ID4+IFN1YmplY3Q6IFJlOiBbUkZDIFBBVENIIHBhcnQtNSAwMC8y
Ml0gVk1YIGVtdWxhdGlvbg0KPiA+Pg0KPiA+PiBPbiAzLzE0LzIzIDE3OjI5LCBKYXNvbiBDaGVu
IENKIHdyb3RlOg0KPiA+Pj4gT24gTW9uLCBNYXIgMTMsIDIwMjMgYXQgMDk6NTg6MjdBTSAtMDcw
MCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPj4+PiBPbiBNb24sIE1hciAxMywgMjAy
MywgSmFzb24gQ2hlbiBDSiB3cm90ZToNCj4gPj4+Pj4gVGhpcyBwYXRjaCBzZXQgaXMgcGFydC01
IG9mIHRoaXMgUkZDIHBhdGNoZXMuIEl0IGludHJvZHVjZXMgVk1YDQo+ID4+Pj4+IGVtdWxhdGlv
biBmb3IgcEtWTSBvbiBJbnRlbCBwbGF0Zm9ybS4NCj4gPj4+Pj4NCj4gPj4+Pj4gSG9zdCBWTSB3
YW50cyB0aGUgY2FwYWJpbGl0eSB0byBydW4gaXRzIGd1ZXN0LCBpdCBuZWVkcyBWTVggc3VwcG9y
dC4NCj4gPj4+Pg0KPiA+Pj4+IE5vLCB0aGUgaG9zdCBWTSBvbmx5IG5lZWRzIGEgd2F5IHRvIHJl
cXVlc3QgcEtWTSB0byBydW4gYSBWTS4gIElmDQo+ID4+Pj4gd2UgZ28gZG93biB0aGUgcmFiYml0
IGhvbGUgb2YgcEtWTSBvbiB4ODYsIEkgdGhpbmsgd2Ugc2hvdWxkIHRha2UNCj4gPj4+PiB0aGUg
cmVkIHBpbGxbKl0gYW5kIGdvIGFsbCB0aGUgd2F5IGRvd24gc2FpZCByYWJiaXQgaG9sZSBieSBo
ZWF2aWx5DQo+ID4+Pj4gcGFyYXZpcnR1YWxpemluZw0KPiA+PiB0aGUgS1ZNPT5wS1ZNIGludGVy
ZmFjZS4NCj4gPj4+DQo+ID4+PiBoaSwgU2VhbiwNCj4gPj4+DQo+ID4+PiBMaWtlIEkgbWVudGlv
bmVkIGluIHRoZSByZXBseSBmb3IgIltSRkMgUEFUQ0ggcGFydC0xIDAvNV0gcEtWTSBvbg0KPiA+
Pj4gSW50ZWwgUGxhdGZvcm0gSW50cm9kdWN0aW9uIiwgd2UgaG9wZSBWTVggZW11bGF0aW9uIGNh
biBiZSB0aGVyZSBhdA0KPiA+Pj4gbGVhc3QgZm9yIG5vcm1hbCBWTSBzdXBwb3J0Lg0KPiA+Pj4N
Cj4gPj4+Pg0KPiA+Pj4+IEV4Y2VwdCBmb3IgVk1DQUxMIHZzLiBWTU1DQUxMLCBpdCBzaG91bGQg
YmUgcG9zc2libGUgdG8gZWxpbWluYXRlDQo+ID4+Pj4gYWxsIHRyYWNlcyBvZiBWTVggYW5kIFNW
TSBmcm9tIHRoZSBpbnRlcmZhY2UuICBUaGF0IG1lYW5zIG5vIFZNQ1MNCj4gPj4+PiBlbXVsYXRp
b24sIG5vIEVQVCBzaGFkb3dpbmcsIGV0Yy4gIEFzIGEgYm9udXMsIGFueSBwYXJhdmlydCBzdHVm
Zg0KPiA+Pj4+IHdlIGRvIGZvciBwS1ZNIHg4NiB3b3VsZCBhbHNvIGJlIHVzYWJsZSBmb3IgS1ZN
LW9uLUtWTSBuZXN0ZWQNCj4gdmlydHVhbGl6YXRpb24uDQo+ID4+Pj4NCj4gPj4+PiBFLmcuIGFu
IGlkZWEgZmxvYXRpbmcgYXJvdW5kIG15IGhlYWQgaXMgdG8gYWRkIGEgcGFyYXZpcnQgcGFnaW5n
DQo+ID4+Pj4gaW50ZXJmYWNlIGZvciBLVk0tb24tS1ZNIHNvIHRoYXQgTDEncyAoS1ZNLWhpZ2gg
aW4gdGhpcyBSRkMpDQo+ID4+Pj4gZG9lc24ndCBuZWVkIHRvIG1haW50YWluIGl0cyBvd24gVERQ
IHBhZ2UgdGFibGVzLiAgSSBoYXZlbid0DQo+ID4+Pj4gcHVyc3VlZCB0aGF0IGlkZWEgaW4gYW55
IHJlYWwgY2FwYWNpdHkgc2luY2UgbW9zdCBuZXN0ZWQNCj4gPj4+PiB2aXJ0dWFsaXphdGlvbiB1
c2UgY2FzZXMgZm9yIEtWTSBpbnZvbHZlIHJ1bm5pbmcgYW4gb2xkZXIgTDEga2VybmVsDQo+ID4+
Pj4gYW5kL29yIGEgbm9uLUtWTSBMMSBoeXBlcnZpc29yLCBpLmUuIHRoZXJlJ3Mgbm8gY29uY3Jl
dGUgdXNlIGNhc2UNCj4gPj4+PiB0byBqdXN0aWZ5IHRoZSBkZXZlbG9wbWVudCBhbmQNCj4gPj4g
bWFpbnRlbmFuY2UgY29zdC4gIEJ1dCBpZiB0aGUgUFYgY29kZSBpcyAibmVlZGVkIiBieSBwS1ZN
IGFueXdheXMuLi4NCj4gPj4+DQo+ID4+PiBZZXMsIEkgYWdyZWUsIHdlIGNvdWxkIGhhdmUgcGVy
Zm9ybWFuY2UgJiBtZW0gY29zdCBiZW5lZml0IGJ5IHVzaW5nDQo+ID4+PiBwYXJhdmlydCBzdHVm
ZiBmb3IgS1ZNLW9uLUtWTSBuZXN0ZWQgdmlydHVhbGl6YXRpb24uIE1heSBJIGtub3cgZG8gSQ0K
PiA+Pj4gbWlzcyBvdGhlciBiZW5lZml0IHlvdSBzYXc/DQo+ID4+DQo+ID4+IEFzIEkgc2VlIGl0
LCB0aGUgYWR2YW50YWdlcyBvZiBhIFBWIGRlc2lnbiBmb3IgcEtWTSBhcmU6DQo+ID4+DQo+ID4+
IC0gcGVyZm9ybWFuY2UNCj4gPj4gLSBtZW1vcnkgY29zdA0KPiA+PiAtIGNvZGUgc2ltcGxpY2l0
eSAob2YgdGhlIHBLVk0gaHlwZXJ2aXNvciwgZmlyc3Qgb2YgYWxsKQ0KPiA+PiAtIGJldHRlciBh
bGlnbm1lbnQgd2l0aCB0aGUgcEtWTSBvbiBBUk0NCj4gPj4NCj4gPj4gUmVnYXJkaW5nIHBlcmZv
cm1hbmNlLCBJIGFjdHVhbGx5IHN1c3BlY3QgaXQgbWF5IGV2ZW4gYmUgdGhlIGxlYXN0DQo+ID4+
IHNpZ25pZmljYW50IG9mIHRoZSBhYm92ZS4gSSBndWVzcyB3aXRoIGEgUFYgZGVzaWduIHdlJ2Qg
aGF2ZSByb3VnaGx5DQo+ID4+IGFzIG1hbnkgZXh0cmEgdm1leGl0cyBhcyB3ZSBoYXZlIG5vdyAo
anVzdCBkdWUgdG8gaHlwZXJjYWxscyBpbnN0ZWFkDQo+ID4+IG9mIHRyYXBzIG9uIGVtdWxhdGVk
IFZNWCBpbnN0cnVjdGlvbnMgZXRjKSwgc28gcGVyaGFwcyB0aGUNCj4gPj4gcGVyZm9ybWFuY2Ug
aW1wcm92ZW1lbnQgd291bGQgYmUgbm90IGFzIGJpZyBhcyB3ZSBtaWdodCBleHBlY3QgKGFtIEkN
Cj4gd3Jvbmc/KS4NCj4gPg0KPiA+IEkgdGhpbmsgd2l0aCBQViBkZXNpZ24sIHdlIGNhbiBiZW5l
Zml0IGZyb20gc2tpcCBzaGFkb3dpbmcuIEZvcg0KPiA+IGV4YW1wbGUsIGEgVExCIGZsdXNoIGNv
dWxkIGJlIGRvbmUgaW4gaHlwZXJ2aXNvciBkaXJlY3RseSwgd2hpbGUNCj4gPiBzaGFkb3dpbmcg
RVBUIG5lZWQgZW11bGF0ZSBpdCBieSBkZXN0cm95IHNoYWRvdyBFUFQgcGFnZSB0YWJsZSBlbnRy
aWVzIHRoZW4NCj4gZG8gbmV4dCBzaGFkb3dpbmcgdXBvbiBlcHQgdmlvbGF0aW9uLg0KPiANCj4g
WWVhaCBpbmRlZWQsIGdvb2QgcG9pbnQuDQo+IA0KPiBJcyBteSB1bmRlcnN0YW5kaW5nIGNvcnJl
Y3Q6IFRMQiBmbHVzaCBpcyBzdGlsbCBnb25uYSBiZSByZXF1ZXN0ZWQgYnkgdGhlIGhvc3QgVk0N
Cj4gdmlhIGEgaHlwZXJjYWxsLCBidXQgdGhlIGJlbmVmaXQgaXMgdGhhdCB0aGUgaHlwZXJ2aXNv
ciBtZXJlbHkgbmVlZHMgdG8gZG8gSU5WRVBUPw0KDQpTb3JyeSBmb3IgbGF0ZXIgcmVzcG9uc2Us
IGluIG15IFAuTy5WLCB3ZSBzaG91bGQgbGV0IEVQVCB0b3RhbGx5IG93bmVkIGJ5IHRoZSBoeXBl
cnZpc29yLA0Kc28gaG9zdCBWTSB3aWxsIG5vdCB0cmlnZ2VyIFRMQiBmbHVzaCBhcyBpdCBkb2Vz
IG5vdCBtYW5hZ2UgRVBUIGRpcmVjdGx5Lg0KDQo+IA0KPiA+DQo+ID4gQmFzZWQgb24gUFYsIHdp
dGggd2VsbC1kZXNpZ25lZCBpbnRlcmZhY2VzLCBJIHN1cHBvc2Ugd2UgY2FuIGFsc28gbWFrZQ0K
PiA+IHNvbWUgZ2VuZXJhbCBkZXNpZ24gZm9yIG5lc3RlZCBzdXBwb3J0IG9uIEtWTS1vbi1oeXBl
cnZpc29yIChlLmcuLCB3ZQ0KPiA+IGNhbiBkbyBmaXJzdCBmb3IgS1ZNLW9uLUtWTSB0aGVuIGV4
dGVuZCB0byBzdXBwb3J0IEtWTS1vbi1wS1ZNIGFuZA0KPiA+IG90aGVycykNCj4gDQo+IFllcCwg
YXMgU2VhbiBzdWdnZXN0ZWQuIEZvcmdvdCB0byBtZW50aW9uIHRoaXMgdG9vLg0KPiANCj4gPg0K
PiA+Pg0KPiA+PiBCdXQgdGhlIG1lbW9yeSBjb3N0IGFkdmFudGFnZSBzZWVtcyB0byBiZSB2ZXJ5
IGF0dHJhY3RpdmUuIFdpdGggdGhlDQo+ID4+IGVtdWxhdGVkIGRlc2lnbiBwS1ZNIG5lZWRzIHRv
IG1haW50YWluIHNoYWRvdyBwYWdlIHRhYmxlcyAoYW5kIG90aGVyDQo+ID4+IHNoYWRvdyBzdHJ1
Y3R1cmVzIHRvbywgYnV0IHBhZ2UgdGFibGVzIGFyZSB0aGUgbW9zdCBtZW1vcnkNCj4gPj4gZGVt
YW5kaW5nKS4gTW9yZW92ZXIsIHRoZSBudW1iZXIgb2Ygc2hhZG93IHBhZ2UgdGFibGVzIGlzIG9i
dmlvdXNseQ0KPiA+PiBwcm9wb3J0aW9uYWwgdG8gdGhlIG51bWJlciBvZiBWTXMgcnVubmluZywg
YW5kIHNpbmNlIHBLVk0gcmVzZXJ2ZXMNCj4gPj4gYWxsIGl0cyBtZW1vcnkgdXBmcm9udCBwcmVw
YXJpbmcgZm9yIHRoZSB3b3JzdCBjYXNlLCB3ZSBoYXZlIHByZXR0eQ0KPiA+PiByZXN0cmljdGl2
ZSBsaW1pdHMgb24gdGhlIG1heGltdW0gbnVtYmVyIG9mIFZNcyBbKl0gKGFuZCBpZiB3ZSBydW4g
ZmV3ZXINCj4gVk1zIHRoYW4gdGhpcyBsaW1pdCwgd2Ugd2FzdGUgbWVtb3J5KS4NCj4gPj4NCj4g
Pj4gVG8gZ2l2ZSBzb21lIG51bWJlcnMsIG9uIGEgbWFjaGluZSB3aXRoIDhHQiBvZiBSQU0sIG9u
IENocm9tZU9TIHdpdGgNCj4gPj4gdGhpcw0KPiA+PiBwS1ZNLW9uLXg4NiBQb0MgY3VycmVudGx5
IHdlIGhhdmUgcEtWTSBtZW1vcnkgY29zdCBvZiAyMjlNQiAoYW5kIGl0DQo+ID4+IG9ubHkgYWxs
b3dzIHVwIHRvIDEwIFZNcyBydW5uaW5nIHNpbXVsdGFuZW91c2x5KSwgd2hpbGUgb24gQW5kcm9p
ZA0KPiA+PiAoQVJNKSBpdCBpcyBhZmFpayBvbmx5IDQ0TUIuIEFjY29yZGluZyB0byBteSBhbmFs
eXNpcywgaWYgd2UgZ2V0IHJpZA0KPiA+PiBvZiBhbGwgdGhlIHNoYWRvdyB0YWJsZXMgaW4gcEtW
TSwgd2Ugc2hvdWxkIGhhdmUgNDRNQiBvbiB4ODYgdG9vDQo+ID4+IChyZWdhcmRsZXNzIG9mIHRo
ZSBtYXhpbXVtIG51bWJlciBvZiBWTXMpLg0KPiA+Pg0KPiA+PiBbKl0gQW5kIHNvbWUgb3RoZXIg
bGltaXRzIHRvbywgZS5nLiBvbiB0aGUgbWF4aW11bSBudW1iZXIgb2YNCj4gPj4gRE1BLWNhcGFi
bGUgZGV2aWNlcywgc2luY2UgcEtWTSBhbHNvIG5lZWRzIHNoYWRvdyBJT01NVSBwYWdlIHRhYmxl
cw0KPiA+PiBpZiB3ZSBoYXZlIG9ubHkgMS0gc3RhZ2UgSU9NTVUuDQo+ID4NCj4gPiBJIG1heSBu
b3QgY2FwdHVyZSB5b3VyIG1lYW5pbmcuIERvIHlvdSBtZWFuIGRldmljZSB3YW50IDItc3RhZ2Ug
d2hpbGUNCj4gPiB3ZSBvbmx5IGhhdmUgMS1zdGFnZSBJT01NVT8gSWYgc28sIG5vdCBzdXJlIGlm
IHRoZXJlIGlzIHJlYWwgdXNlIGNhc2UuDQo+ID4NCj4gPiBQZXIgbXkgdW5kZXJzdGFuZGluZywg
aWYgZm9yIFBWIElPTU1VLCB0aGUgc2ltcGxlc3QgaW1wbGVtZW50YXRpb24gaXMNCj4gPiBqdXN0
IG1haW50YWluIDEtc3RhZ2UgRE1BIG1hcHBpbmcgaW4gdGhlIGh5cGVydmlzb3IgYXMgZ3Vlc3Qg
bW9zdA0KPiA+IGxpa2VseSBqdXN0IHdhbnQgMS1zdGFnZSBETUEgbWFwcGluZyBmb3IgaXRzIGRl
dmljZSwgIHNvIGlmIGZvciBJT01NVQ0KPiA+IHcvIG5lc3RlZCBjYXBhYmlsaXR5IG1lYW50aW1l
IGd1ZXN0IHdhbnQgdXNlIGl0cyBuZXN0ZWQgY2FwYWJpbGl0eQ0KPiA+IChlLmcuLCBmb3IgdlNW
QSksIHdlIGNhbiBmdXJ0aGVyIGV4dGVuZCB0aGUgUFYgSU9NTVUgaW50ZXJmYWNlcy4NCj4gDQo+
IFNvcnJ5LCBJIHdhc24ndCBjbGVhciBlbm91Z2guIEkgbWVhbiwgb24gdGhlIGhvc3Qgb3IgZ3Vl
c3Qgc2lkZSB3ZSBuZWVkIGp1c3QgMS0NCj4gc3RhZ2UgSU9NTVUsIGJ1dCBwS1ZNIG5lZWRzIHRv
IGVuc3VyZSBtZW1vcnkgcHJvdGVjdGlvbi4gU28gaWYgMi1zdGFnZSBpcw0KPiBhdmFpbGFibGUs
IHBLVk0gY2FuIGp1c3QgdXNlIGl0LCBidXQgaWYgbm90LCBjdXJyZW50bHkgaW4gcEtWTSBvbiBJ
bnRlbCB3ZSB1c2UNCj4gc2hhZG93IHBhZ2UgdGFibGVzIGZvciB0aGF0IChqdXN0IGFzIGEgY29u
c2VxdWVuY2Ugb2YgdGhlIG92ZXJhbGwgIm1vc3RseQ0KPiBlbXVsYXRlZCIgZGVzaWduKS4gKFNv
IGFzIGEgcmVzdWx0LCBpbiBwYXJ0aWN1bGFyLCBwS1ZNIG1lbW9yeSBmb290cHJpbnQNCj4gZGVw
ZW5kcyBvbiB0aGUgbWF4IG51bWJlciBvZiBQQ0kgZGV2aWNlcyBhbGxvd2VkIGJ5IHBLVk0uKSBB
bmQgeWVhaCwgd2l0aCBhDQo+IFBWIElPTU1VIHdlIGNhbiBhdm9pZCB0aGUgbmVlZCBmb3Igc2hh
ZG93IHBhZ2UgdGFibGVzIHdoaWxlIHN0aWxsIGhhdmluZyBvbmx5DQo+IDEtc3RhZ2UgSU9NTVUs
IHRoYXQncyBleGFjdGx5IG15IHBvaW50Lg0KPiANCj4gPg0KPiA+Pg0KPiA+Pj4NCj4gPj4+Pg0K
PiA+Pj4+IFsqXSBZb3UgdGFrZSB0aGUgYmx1ZSBwaWxsLCB0aGUgc3RvcnkgZW5kcywgeW91IHdh
a2UgdXAgaW4geW91ciBiZWQgYW5kDQo+IGJlbGlldmUNCj4gPj4+PiAgICAgd2hhdGV2ZXIgeW91
IHdhbnQgdG8gYmVsaWV2ZS4gWW91IHRha2UgdGhlIHJlZCBwaWxsLCB5b3Ugc3RheSBpbg0KPiB3
b25kZXJsYW5kLA0KPiA+Pj4+ICAgICBhbmQgSSBzaG93IHlvdSBob3cgZGVlcCB0aGUgcmFiYml0
IGhvbGUgZ29lcy4NCj4gPj4+Pg0KPiA+Pj4+ICAgICAtTW9ycGhldXMNCj4gPj4+DQo=
