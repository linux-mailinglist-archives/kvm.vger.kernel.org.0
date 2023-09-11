Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C8779A428
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 09:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbjIKHJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 03:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjIKHJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 03:09:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB6118D;
        Mon, 11 Sep 2023 00:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694416137; x=1725952137;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Nph2KZGwv5Z92smgl6xz6jOdrNmHa9gls9hmlGuXc7g=;
  b=fvPEvL6WJeFbWghNgElYz0cd0Vyg4A9YQxGPcMBcXFvmE/Mej2sbq5Vq
   Jygyjqrhyekx+rysDW386km5agibneP796byhTAt2Q2dLfee8NG6WckVh
   TCPI1IK0C59zrjxVhdFfIKVtpAR9OZXJD1t5PYXFEee3/bBh2Ihl5lJ5V
   YBg0z1zk5o/MXovu+e7IOIBZ5neobVQOhQDTXZOvVCcp9dpGM6fzX/v6R
   yppXgXnlbtjPsPAOw0p4vUiywAwjmxO/wlfHu0/LgoJ4SL7WUas858jps
   CAnRPsVyXKZCxSHufdqe2aFrRQz7IW6tn77D/7Cb0Vq2vnK0ehPLfFWNk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="375368119"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="375368119"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 00:08:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="743230249"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="743230249"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2023 00:08:55 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 00:08:54 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 11 Sep 2023 00:08:54 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 11 Sep 2023 00:08:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TMF3nILoOn0F4x09Qty34Wk/aEzprHoF2eIwxpGrY6xLJAMvIExwsx0+C5GwvvMi1AeuGb2L0VWHbbGMqADHo7tmhH6CBIt/1uXuK6ZYUOrnZfVn3212Tbu/H9IVkgGnA1TAq8Ld47a+V1cKlb1x+yw5ny1mlI7Smume5PJwibEe++9sPagKP5ecm+D/m8Nvbi7+9ORdZnaE4rGRRfvw9q+1mzc/G8ZPbjEzw10yKAOoqWEv8jux01y0byagk+WsTtovro+Jz3A4AmIwgI3twbRW50b8q1+rwrYUj7dO5aSmEdZs1Ax2EuBuUCjubls+C6PH1n5t+HrfL+jhvGt0VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nph2KZGwv5Z92smgl6xz6jOdrNmHa9gls9hmlGuXc7g=;
 b=FnLMOaVDozbkFy9R+mmC8ijA4dY10q/r7ZxOqBWjcvpsD9MrAcVC6SRMt+Gsz0+EInyhIRya8UN0WaxQKvgqq/3R/k4zozURdFTRPgZkGvLIZ7pTXQNzGsrEsYdNtdIiBei2Kw3I0rTFQELbrbM3kx0kj28OWCdJBS9A98v58kxsipzvrNY+FSev5KvIHjIEumtjXQHhDWXzQI4f8QmEV+Ev72Papwo1vKSZPCj9QGB2AKrODRl43PqbffAmgJuIJXBkPplQQJG6I9u9uaOMm0m1kP54kKifd2y5/W+yJFl+SgggYfXGQv1aFT1ZlEQ5cc5bs8WBinKIMbSIeUS0vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6500.namprd11.prod.outlook.com (2603:10b6:510:213::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Mon, 11 Sep
 2023 07:08:48 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323%7]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 07:08:48 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     oushixiong <oushixiong@kylinos.cn>, Jason Gunthorpe <jgg@ziepe.ca>
CC:     Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Brett Creeley <brett.creeley@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio/pds: Add missing PCI_IOV depends
Thread-Topic: [PATCH] vfio/pds: Add missing PCI_IOV depends
Thread-Index: AQHZ4GSD3a39WYyEG0a5I73Pu4JeRrAVPCHw
Date:   Mon, 11 Sep 2023 07:08:47 +0000
Message-ID: <BN9PR11MB5276258474C8E3EA70164E368CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230906014942.1658769-1-oushixiong@kylinos.cn>
In-Reply-To: <20230906014942.1658769-1-oushixiong@kylinos.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6500:EE_
x-ms-office365-filtering-correlation-id: e00afb25-1dd0-4127-a3f9-08dbb295f1ba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QX0+wZJWHNiXXdlSlJ0/3dR/vqEIVt+V0n5SKwVgdaeQVWUh9HhDlysPrPuD2oCO4NU7V1UipBX195QG5qGu5iavxSNqWymRq31FYBT9FDlazvKw2Nnf+kwUIWy/6lHyaoU6fvq2urCCSDmKq2StmsHD57deYs3CuDdCx9JdgE+voSo5nBO46nKa46kR/Rceg6S0ZAzk/B6tggRgrScvfhOXj2ywNgbeZTPvrlnJyLhbhwrx7z3uU9faYvrNGSbPLGSWqvlzISRFuf1pnVfdu4OmJ9eG0LYftrYn/tLtyV+9ICjKL9q90XeVWB+//l6A2xpFbiR2q56USJIaK6kjNHIE4MODw70LsRkGQTuBVOqWi7VTk30BoV1byH/DKGdgvPI2rv275QUoAw1ZJu3/fh2zQ7SuFeIfsergdH/LTdYi3s/SOeEwpXZIlda3fETNY0wryrB+y26uGRzkZ0Q9UL2VH+MkxTeH/Rh8G7G+bt+vHhBLGSSnMh/bOF27RIFiFRRUWGmqrFu6SMF1nzGuOooQrrhcoVIF6NhmvP9qxBcJXym8ZgCwLGKzdnAWxo8YYekSJfG8xceVkQX94ehem1yOKIEuo/ZyoE74TDQQMmsHF9kj9RVpDtH8LqvzWhcB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(376002)(346002)(366004)(451199024)(1800799009)(186009)(82960400001)(122000001)(71200400001)(7696005)(6506007)(9686003)(33656002)(86362001)(55016003)(38100700002)(38070700005)(4744005)(26005)(41300700001)(2906002)(4326008)(478600001)(76116006)(110136005)(52536014)(66556008)(8676002)(8936002)(5660300002)(66476007)(64756008)(54906003)(66946007)(316002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWlBYmRWR1Z1M0I4WlhUUVMzRWtTWWN4bjZKUTVnWHIwb29MUEJGbGFDWjc4?=
 =?utf-8?B?d3V5U1RRUzluc1RPaGFJNGE3cnJyQVIxL0xIYklXbkx6OFdkZGw1cGRGaXdJ?=
 =?utf-8?B?WGpISC9LVXI4T1FVV1ZGWUJGR3lFQ2ZwTnk3UWZTTEduSnZVMzNLYUxla3BE?=
 =?utf-8?B?YWJHVDBOYzB1aXUyU0llSy9UMGZRYTJOZHFrV29IVnpuS3ZSKzRwZWNVczZ4?=
 =?utf-8?B?blJSTlo3WnBJb2NwbzRwSW5BeG9MS1JsTzY5dUhBa3Y1b09FVWdRaVBYMDB2?=
 =?utf-8?B?aW4rUTBJaWU5blU1UkVrQ29YMS9HeDA3OU1tZzByeHhIL01LL2srRVlCbGlG?=
 =?utf-8?B?R04xR0djdTVRa1hOYk5wcG4zd0UvWVFEdjdqUlpEUnBva1dDa3JRd0VUYWFW?=
 =?utf-8?B?NnpaaEZTQldSRXBqWHpseWluOTVEUHNaMTI0blByakh4djdtblY2Qm4zY0pi?=
 =?utf-8?B?aEt0ZTVHS0VUQXJGQzgrcElFVFhHSHArVUlFMmgzeTd6Ylh6eGR6ODRuOE9L?=
 =?utf-8?B?VkVUa05nUUU4WThHYmhOMGpRZDl5VzRIczBjRzZnRkx0UEdFeHJkUC9YQU9v?=
 =?utf-8?B?WFZGZnVUVDZEcHVHM2hVT1hHNnRPb3l3RklUQW5TdzBJR3RmbVhIRjgyVUww?=
 =?utf-8?B?WmU1WXBVWEhwQnBEZ0JNSE9xOFNlR3NoeTREcFMxSFBzbTl5d1dFQmRxdGdC?=
 =?utf-8?B?K1pIcmtkZkVDeGJxVWhxVENJRkJzbCt6MVZSNlFiVlYydVpJNjI3TS80Ujkx?=
 =?utf-8?B?TjJmRzhGbG9nM1FKZVVLUTVLYUtBTWgvSnFlWHZFMVpvQkF2R05EUGlJWkpH?=
 =?utf-8?B?MVM3dDl3SGZyQzJ0dk1xcHhoMGZISkRUbFJsZk1vYlU5YVJ0b2dtK200ZkNm?=
 =?utf-8?B?WUZIR2lSYlRKTGlpT2pGLzFxVHhtckhDaVFpUlA1bnVOMFhCRUxKNnk0aWM2?=
 =?utf-8?B?SkdHZHhWU0hxM0tLYklqL3drV0k0UW1SSS9iWWJZRGE2K0ZTSnY3MGVUQ3pX?=
 =?utf-8?B?azJYU0NrdFcyK3Q1UFRoY0Qwck0ydmVPWFduUnNyNkVQMkhhU2Q5cndEQWxx?=
 =?utf-8?B?VjJVZElNdFpNbHBDZTRsWW11MGxXSHlRb3JTc3dOT3VoZjhzRnBDdHJ2M0NH?=
 =?utf-8?B?WlBGNHpxTmsyUlZnTEQvM3Z1Nmxyb2VHU0prOWtNV0dRb3UwMHZBNG55b0F0?=
 =?utf-8?B?eUMrNWZ3ejFzckJkYmV2U0JrK2NOTzlmcW82djY2eVFrc0M5cktzWG9ERmJ0?=
 =?utf-8?B?Tm1wRXN4Ylp3QUttcW4wMzM3U0hSZFkxMk10bWdrRDEwUjFGeVFZd1ptRWl5?=
 =?utf-8?B?bUFIUkdIOE9kUERpbS9uSkpvSnBUWjVXcC9VbDlPTTlERERpMVZFSjdTV2dy?=
 =?utf-8?B?NHZIZEVOZXZpY1RVVE90bzUxbE53VCtuby9zQkE4R0lVRkdEUGs4emJXWDBv?=
 =?utf-8?B?NWtxUE9HVHF2UDZ3N3JQWlUvYmo0eGdXNk53VFVjM2NIa2ZQZXhWSG9sVzVs?=
 =?utf-8?B?eGRVY1M1c29YQXZvcStUQVFxVytWUGN6UHBCcXI3THdhbHh2VVRiV09KdVFn?=
 =?utf-8?B?d1R0eE00ZGh2TkE3MkVqbTJ5ekNpVmRsWmsvTTB0OUhEODlrRktkVldOMGE4?=
 =?utf-8?B?b1ZhMytaY0k4ck9lRGE0SWduckgrdTZLVFErclhvL2RVRGV4UTZTRFJ3R1Y5?=
 =?utf-8?B?elVYSEpHNytRbi8xaFk1dzk0UEhNTGNnS0hwa3A5eUE0bFZsOWRidzREbWRl?=
 =?utf-8?B?VmtPRUNpV2pNUDd1K2VZdEFucUE4cEJ4OUNqNmpxWkFoN1ZiWllURHVXT3Na?=
 =?utf-8?B?cyt4T2IyQkJZNkNZaW1zOUVKMmx1bXJpcmF3Uk12VXQxYU1GbkxKVlY2UmU4?=
 =?utf-8?B?TEdOUFEzbzRJUWtlNFdaVFVTVUMxR2Z3QUtxWmR3K2xDTVJaSkcrb1JvWGNL?=
 =?utf-8?B?RTFCaWE2V1ZrRkliNHh3N1NaYi92RWduMkhHWEo2a3BsUEdYRXN4cHJmVFVC?=
 =?utf-8?B?Z3FHc0RqcnhLMk0yOW9JVmhnK0NBaVB0UGlmT0YrTWZtUlZYUWpSVGxDZHBC?=
 =?utf-8?B?WnRQNnk4c1dzN0lMaVhyQk15VXhiRWRxUFdVeStRbEVLeVJEZEd4aFYzOEhz?=
 =?utf-8?Q?L2oBdqGA2yQvjsC0Cp1IiTtbP?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e00afb25-1dd0-4127-a3f9-08dbb295f1ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2023 07:08:47.7899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Rk+2+9VrZsX5ienHQZZRefInMSpqVJSWxGBkh/ISjSUwvo6dZj1F1SfHqjt+cL4A7wa9BWvxPxamvHsqPnBHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6500
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

PiBGcm9tOiBvdXNoaXhpb25nIDxvdXNoaXhpb25nQGt5bGlub3MuY24+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgU2VwdGVtYmVyIDYsIDIwMjMgOTo1MCBBTQ0KPiANCj4gRnJvbTogU2hpeGlvbmcgT3Ug
PG91c2hpeGlvbmdAa3lsaW5vcy5jbj4NCj4gDQo+IElmIFBDSV9BVFMgaXNuJ3Qgc2V0LCB0aGVu
IHBkZXYtPnBoeXNmbiBpcyBub3QgZGVmaW5lZC4NCj4gaXQgY2F1c2VzIGEgY29tcGlsYXRpb24g
aXNzdWU6DQo+IA0KPiAuLi9kcml2ZXJzL3ZmaW8vcGNpL3Bkcy92ZmlvX2Rldi5jOjE2NTozMDog
ZXJyb3I6IOKAmHN0cnVjdCBwY2lfZGV24oCZIGhhcyBubw0KPiBtZW1iZXIgbmFtZWQg4oCYcGh5
c2Zu4oCZOyBkaWQgeW91IG1lYW4g4oCYaXNfcGh5c2Zu4oCZPw0KPiAgIDE2NSB8ICAgX19mdW5j
X18sIHBjaV9kZXZfaWQocGRldi0+cGh5c2ZuKSwgcGNpX2lkLCB2Zl9pZCwNCj4gICAgICAgfCAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+fn5+fg0KPiANCg0KVXNlIHBjaV9waHlzZm4o
KQ0K
