Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F133668AAA7
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 15:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbjBDOnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 09:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbjBDOnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 09:43:15 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA94CC1A
        for <kvm@vger.kernel.org>; Sat,  4 Feb 2023 06:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675521790; x=1707057790;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T0TAtfoRSO41hMQ6M2ITJ4ZCNMGd+5FrKooyNUA6KTU=;
  b=j4PbaxUerzwLPnS3rARR6M12VQjjl7ppsNGJ79dUpTezX2lexJWXQ/O7
   dhhPcHUp1pVgNp7qqyd+I2C5vEKvYjSaSU5Iy/y6SWDqGr3Ww4G/3TAca
   AA5CnPD0g2DVRCigFPDsuUdYCfUXCMTCe5yYVr0adeMOcLTHomMyF+wJl
   2/hr3I9OnRc6ycVQkjn1B4aVDe2EQNtf5uZHnIC762oXPdf3i/Qmqfse8
   9YOitV8MGeOEeoQo74dGCd8BcMmTuhD/cwF4OtdjxCzs+WnwSH8jCKXtp
   Dst5BdK/LNEhmKd3e2y8rhOv34mYO2ntHlozJawGnikUB4d06gQu+gVN6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="331077363"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="331077363"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2023 06:43:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="734669174"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="734669174"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 04 Feb 2023 06:43:09 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 4 Feb 2023 06:43:09 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 4 Feb 2023 06:43:09 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 4 Feb 2023 06:43:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1k27Hj+EbR2eSWc23xMMA+ct3GS4GkQCASULodrfT9yex1eiQCLjbXs5RBWTbxe+Agjaye/Zl9PaQ0WT1wMpkpwVyrsH+U2BjhBNMS17y7LLJodUsukVZ9T5O2nFxHQDFiURLCgMW48v/21nGPUTf/JLFjHut4gzhfPv8wK+ZYlF6XLWPfqMcE1ojNP/HpKI1nDUWefDrdb59kLmBYcPoXbXpz61aGBDShXn9TGxFOCDpOb0o+4esk/ZXrhbREaGo/pqFBkA00ZTICgiN7ZJdVNbSmtuuI7C/lki2bYuqYg+CCSvDVhbT8sB4WF/eUmHeWNp2OHP/FlgRwNdaex/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T0TAtfoRSO41hMQ6M2ITJ4ZCNMGd+5FrKooyNUA6KTU=;
 b=RUhyZ6E9oMAZdOajKYQ37vUPV8F0B71YTC67CtSnnJLIU1MqhwoPez4aZMWzTd0pH8ipImsu9wdMi+RUYHd53PKKtq07A0F6WdjVCNHIImVrGHZR6gcOLclZDKzCTa5qlZG0gV1HFNxBH0oVTehNVDQSOVrrZbYf7JkqIZkl0x1mPXIhSixqNPuj/X/NA4OrkfEj/UIEAhsORp5eXA07CKyNh/JkMGE2a0hR0YZ9OUZhGyy2hTl/JNfrg+wKl1b1nobRN0nbpZG4H1YjTxH5i9g0xM2VYFkf8SR7hu4rofGzzTSd0+70AENAmE2kI10O62jNg3eS04qvHzPW9snw1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by BL1PR11MB5528.namprd11.prod.outlook.com (2603:10b6:208:314::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 14:43:00 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::df5b:7a63:f34b:d301]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::df5b:7a63:f34b:d301%9]) with mapi id 15.20.6064.031; Sat, 4 Feb 2023
 14:43:00 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     lkp <lkp@intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
        "oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] docs: vfio: Update vfio.rst per latest interfaces
Thread-Topic: [PATCH v2 2/2] docs: vfio: Update vfio.rst per latest interfaces
Thread-Index: AQHZN6pAgxMUZr7czEyeNEv3R/udlK6+fcIAgAA8qDCAAB+7AIAABEVg
Date:   Sat, 4 Feb 2023 14:42:59 +0000
Message-ID: <SN7PR11MB75404FC7D5AC7FBA2A0A9FD4C3D49@SN7PR11MB7540.namprd11.prod.outlook.com>
References: <20230203083345.711443-3-yi.l.liu@intel.com>
        <202302041603.N8YkuJks-lkp@intel.com>
        <DS0PR11MB75299A027633FE16852599CCC3D49@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230204072658.0790485c.alex.williamson@redhat.com>
In-Reply-To: <20230204072658.0790485c.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR11MB7540:EE_|BL1PR11MB5528:EE_
x-ms-office365-filtering-correlation-id: fcf12df6-3b31-45e0-bc07-08db06be1c7b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OZ+DXL1bMr+WA0CSc9XMrK1FrgBsRhYmcKxV7lE9rtyPt5IC7RN/W4IPHN/M5tyOGQOFn+xw92vIBh9b0H88VfrhLGZB1+DDfDK315422RVrNX5/H2EblWUn0PgNAEP+aHgcvMTggFWCIHwz1AwUWO4i0IFSFifroBFCGOzje+yvKvuo163YMOdq7ca/v2bP41Qeo52rwhS5esmYZuxH3bL+tpxoWvFvDGxwqEcN2almy10JNv4nQc5lTPNhGsfLWmtc6TkWk+j+61+bTY0LfZ6i/uzOKPS16LGKlNbzTnxfsc+DE/Swk6S1c4yXvUw/w8y8Z1MAhWX0oP7iMp8nRRyMXMleuaXr9YFx10iK1G9WGDNk5vP0bKIUyD6dShIAmHSpNDKNUKmb8EbqfX0VjFAAyeHLrN1tx2yL9n1fLrDS5m4+OSw55LYq6TXyAihkWM0qNn3RC96/LVBHw5RFkD253QboG4Xx28OzK6YvhAMT8a52r9nB2R3Ayzhi7qthZ3IIMYEF2Uhxq4nikf0Bg37wpSJ0hprLgArPyCrUZqxh0rOFCMkxOaSdvyrb9j4Rlgp/W7pVf+uOh4FSFkVyWJdMTOWz6relB1Wd2tib/T3m9QHHQm6Nl2QrqNY9/mq++k4HgykImYPWJPbVBeUgRWwouE4C+ldOSY1dpYQg0tsKLU5vh7cDktHoLjfjW8kxUL08JqLns16vCUIx9TmSYcMCscatrW0MHCcIGhfq7dGzMJIM9+uNY2ztgR7mpgBrWltnMZXtPdzEI/fOxRYubQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199018)(15650500001)(2906002)(5660300002)(55016003)(83380400001)(122000001)(186003)(38070700005)(38100700002)(86362001)(82960400001)(76116006)(6916009)(8676002)(54906003)(316002)(8936002)(41300700001)(66556008)(52536014)(4326008)(66446008)(66476007)(64756008)(26005)(478600001)(6506007)(71200400001)(7696005)(966005)(9686003)(33656002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?akJOV05DVVNtZXlJTlROSERwYjV3Sko4TGNXUUcyeTFEaGVIZVNrVlVtVnlx?=
 =?utf-8?B?STlrWkdyUVp5NWpPbVpkcks0b0M3cWVKdUlTZVlWVEszUzhTaVE4cDliVDN6?=
 =?utf-8?B?NHBzRE00T21NUW5uTTZuTkJzOWZFZXFDY1lPenk4V0Y1WEF3M2lpUE5ZckFP?=
 =?utf-8?B?bWRuMDVBeVNWaGl3WGlLM0dydnVMMExhS0NoQnVmUVVPcmNVUHVEZTdWNFlY?=
 =?utf-8?B?cVNUMVFYeWV3WlorcHd5ZGw2aWY4bVhJT3ZVd0svTWp1ZGtwdmNoUVZuMFhN?=
 =?utf-8?B?NlpyQWY0dnpzOXBVTkUrSmFWWTBDTXZQZGJ2aHZsZlhzelZUeHRtMGpYbFJ4?=
 =?utf-8?B?RzJ6dnhjQ3pEclR5SzhkenhFWmFJczlQeXAvdVU4YTJVZXVlY2VGUzI0T2Jw?=
 =?utf-8?B?SVQ4VEljbFVaWVJLOE9zaGhYYVV0WW53RWhiTHVkMFBYcjRLaVZSanVqVjdO?=
 =?utf-8?B?cEdNSGtnM0VzdWRtUE5IdzhiNmNSNlY4cnNrSHpoQ1czQndCcFFoMys5WEtN?=
 =?utf-8?B?M2x2dWxuaDNPcmV6Tld4K0FmN21XalkwdnNKYVJ4WndPa05QQ2RUMXB1NzZ4?=
 =?utf-8?B?aldrWXhsWERjOGRBWGZQcTIrMXVreVA0N0lYY0ROOWZ1MlFxeFFIM0k0L3FP?=
 =?utf-8?B?a1l4S1grVk9CVVl2WlJrcnU1R3J1cE1sZFl4VlJaZ2piMlJxancrbHlRV3Na?=
 =?utf-8?B?TkZnRDIzMzVYRElRVlMxOWZOdTdVM1ZOMVBtV3FrM0ZFVG1HRVkxNnVQRitk?=
 =?utf-8?B?OXBFOTkzQkZaOUtoSGZ6U1N2WDJkcTc3NXlsNnM2czIrTmRhVCtGc1hRMHpj?=
 =?utf-8?B?c3RBYzBQU3QzVlVIWkFlNVJnL1Rub2lzT1NpazNXd3Z3RDhXQ0NyTHQwRExn?=
 =?utf-8?B?RHhDRnVVMk5zYzQrYW90cVk3R3ZmZ1ZRdDlDemlyN1ppam03QWpDUXJuemM5?=
 =?utf-8?B?eElKNVZhRUlQbHZSZ2x3QTJTeWJUZ2c5VjN6bkc3eERCSTIzaDR2NUcyeSs0?=
 =?utf-8?B?bGxJVXRCd0R4clJiWHE4S1BldkZzRGxVR0JtR1hOb3UzWlZuRzhhZHN5bGgw?=
 =?utf-8?B?NUNjenYzaWROVGxPaHlGaks2N1U2OGFZVHlZTk9aZ2s3ZVdOLzVJWE5sQkFL?=
 =?utf-8?B?VDd2TjMyei9wZGZ2OHhiVWNad3VNYTMwWDdVV3NOdjgyZHVXSlZBZFZtYm5o?=
 =?utf-8?B?dlNreWtHWjBwWFViVkRVL2swcGpwek9OWGJuY1dxZEM5K1dYRzMxRmFLeldy?=
 =?utf-8?B?VXVOeGZSNyszakx4YUhaTFdMNVlCa2ljQVpmcEU0bXhyMWF3VU5PbUNzYld4?=
 =?utf-8?B?dlMwcmFCYU5lY0pEN2lyUll6VE5YdnBIOGFPK1lNckJEaHpjcnB4aXg5N29L?=
 =?utf-8?B?VllpY3BZMVZhcE5LRktzQzdOd0hBRWkwU3lnOENiaUJJbmJYNTJjTE56YU9I?=
 =?utf-8?B?US9aZ1c0YWJSQlZGamtxbElrdzhmcVZhLzI3ODBQN2lXa042T2RPR1B5ZTBh?=
 =?utf-8?B?WWtvZXVHVWswYTRkNGJXdUFQUHVjY21JWXZKMENBSFhwY0QxRUlhZGxPMCs0?=
 =?utf-8?B?QjNhNStFM3hlSGpUT05MU2ZrZmJtRlF6ajlybzJOcUZBa2NBYWdtK3YrS1ZR?=
 =?utf-8?B?d2gzdzkzdmV6cWN4cUg0UnpLSHRDWEFsbGxCeHNlbGxuYWdqdG12Nm9OeE05?=
 =?utf-8?B?bVNCYmlkV0o2TE9Ddm5PNW1VRk5DV2YzQndXb0JBMUthaDl1MU5DbGZPWm0r?=
 =?utf-8?B?ZEhrRmJrSDVQZ2x5WUNTTXlOR0NpaDdHZDRkVlM3K0N5WmI0dk40aysxaXJD?=
 =?utf-8?B?LzFwdDhqcERLYmJMbWdnay9NaTZUUm1uRlQxczV2cVh1QjFmanU1cTd0SjNx?=
 =?utf-8?B?UyszQzNUK2IyVk8ydi9JUE9iZmN1VkFyK2ZaV21TcWwzTWliSy83aE44elVo?=
 =?utf-8?B?ZnRpdXdkcThKNWFqOS90QnIxYkdSTElzQlpaVnlwK25VZUlvblozdU5uai8w?=
 =?utf-8?B?WlFWRldYY1puWnNpS3FMcXdaa3ZlUU9ZMzFxMTVuR0RmRTNZOU1MWW52dGQ5?=
 =?utf-8?B?cnZQa2RtUGE0Q1NWYlhyWGprQmVhQU80ZjVBWDhhb0tCbkZqbkNYUDhpREEx?=
 =?utf-8?Q?FZ3n/y3Kw0GvEQnREUYZnrKKt?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcf12df6-3b31-45e0-bc07-08db06be1c7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2023 14:42:59.4168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B7OpjEK6LTEODd0oxKFms3d1lSl1oKh1i+K4rinwILC4CWzje1HX5RAshwpW5nQ4UU69PiVke+Kx28Ge7iQBSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5528
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBTYXR1cmRheSwgRmVicnVhcnkgNCwgMjAyMyAxMDoyNyBQTQ0KPiANCj4gT24gU2F0LCA0
IEZlYiAyMDIzIDEzOjA5OjI1ICswMDAwDQo+ICJMaXUsIFlpIEwiIDx5aS5sLmxpdUBpbnRlbC5j
b20+IHdyb3RlOg0KPiANCj4gPiA+IEZyb206IGxrcCA8bGtwQGludGVsLmNvbT4NCj4gPiA+IFNl
bnQ6IFNhdHVyZGF5LCBGZWJydWFyeSA0LCAyMDIzIDQ6NTYgUE0NCj4gPiA+DQo+ID4gPiBIaSBZ
aSwNCj4gPiA+DQo+ID4gPiBUaGFuayB5b3UgZm9yIHRoZSBwYXRjaCEgUGVyaGFwcyBzb21ldGhp
bmcgdG8gaW1wcm92ZToNCj4gPiA+DQo+ID4gPiBbYXV0byBidWlsZCB0ZXN0IFdBUk5JTkcgb24g
YXdpbGxpYW0tdmZpby9mb3ItbGludXNdDQo+ID4gPiBbYWxzbyBidWlsZCB0ZXN0IFdBUk5JTkcg
b24gbGludXMvbWFzdGVyIHY2LjItcmM2IG5leHQtMjAyMzAyMDNdDQo+ID4gPiBbY2Fubm90IGFw
cGx5IHRvIGF3aWxsaWFtLXZmaW8vbmV4dF0NCj4gPiA+IFtJZiB5b3VyIHBhdGNoIGlzIGFwcGxp
ZWQgdG8gdGhlIHdyb25nIGdpdCB0cmVlLCBraW5kbHkgZHJvcCB1cyBhIG5vdGUuDQo+ID4gPiBB
bmQgd2hlbiBzdWJtaXR0aW5nIHBhdGNoLCB3ZSBzdWdnZXN0IHRvIHVzZSAnLS1iYXNlJyBhcyBk
b2N1bWVudGVkDQo+IGluDQo+ID4gPiBodHRwczovL2dpdC1zY20uY29tL2RvY3MvZ2l0LWZvcm1h
dC1wYXRjaCNfYmFzZV90cmVlX2luZm9ybWF0aW9uXQ0KPiA+ID4NCj4gPiA+IHVybDogICAgaHR0
cHM6Ly9naXRodWIuY29tL2ludGVsLWxhYi1sa3AvbGludXgvY29tbWl0cy9ZaS1MaXUvdmZpby0N
Cj4gVXBkYXRlLQ0KPiA+ID4gdGhlLWtkb2MtZm9yLXZmaW9fZGV2aWNlX29wcy8yMDIzMDIwMy0x
NjM2MTINCj4gPiA+IGJhc2U6ICAgaHR0cHM6Ly9naXRodWIuY29tL2F3aWxsaWFtL2xpbnV4LXZm
aW8uZ2l0IGZvci1saW51cw0KPiA+ID4gcGF0Y2ggbGluazogICAgaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvci8yMDIzMDIwMzA4MzM0NS43MTE0NDMtMy0NCj4gPiA+IHlpLmwubGl1JTQwaW50ZWwu
Y29tDQo+ID4gPiBwYXRjaCBzdWJqZWN0OiBbUEFUQ0ggdjIgMi8yXSBkb2NzOiB2ZmlvOiBVcGRh
dGUgdmZpby5yc3QgcGVyIGxhdGVzdA0KPiA+ID4gaW50ZXJmYWNlcw0KPiA+ID4gcmVwcm9kdWNl
Og0KPiA+ID4gICAgICAgICAjIGh0dHBzOi8vZ2l0aHViLmNvbS9pbnRlbC1sYWItDQo+ID4gPiBs
a3AvbGludXgvY29tbWl0LzhkYjJjMGQzNDE0Mzg3NTAyYTZjNzQzZDZmYTM4M2NlYzk2MGUzYmEN
Cj4gPiA+ICAgICAgICAgZ2l0IHJlbW90ZSBhZGQgbGludXgtcmV2aWV3IGh0dHBzOi8vZ2l0aHVi
LmNvbS9pbnRlbC1sYWItbGtwL2xpbnV4DQo+ID4gPiAgICAgICAgIGdpdCBmZXRjaCAtLW5vLXRh
Z3MgbGludXgtcmV2aWV3IFlpLUxpdS92ZmlvLVVwZGF0ZS10aGUta2RvYy1mb3ItDQo+ID4gPiB2
ZmlvX2RldmljZV9vcHMvMjAyMzAyMDMtMTYzNjEyDQo+ID4gPiAgICAgICAgIGdpdCBjaGVja291
dCA4ZGIyYzBkMzQxNDM4NzUwMmE2Yzc0M2Q2ZmEzODNjZWM5NjBlM2JhDQo+ID4gPiAgICAgICAg
IG1ha2UgbWVudWNvbmZpZw0KPiA+ID4gICAgICAgICAjIGVuYWJsZSBDT05GSUdfQ09NUElMRV9U
RVNULA0KPiA+ID4gQ09ORklHX1dBUk5fTUlTU0lOR19ET0NVTUVOVFMsIENPTkZJR19XQVJOX0FC
SV9FUlJPUlMNCj4gPiA+ICAgICAgICAgbWFrZSBodG1sZG9jcw0KPiA+ID4NCj4gPiA+IElmIHlv
dSBmaXggdGhlIGlzc3VlLCBraW5kbHkgYWRkIGZvbGxvd2luZyB0YWcgd2hlcmUgYXBwbGljYWJs
ZQ0KPiA+ID4gfCBSZXBvcnRlZC1ieToga2VybmVsIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+
DQo+ID4gPg0KPiA+ID4gQWxsIHdhcm5pbmdzIChuZXcgb25lcyBwcmVmaXhlZCBieSA+Pik6DQo+
ID4gPg0KPiA+ID4gPj4gRG9jdW1lbnRhdGlvbi9kcml2ZXItYXBpL3ZmaW8ucnN0OjI2NDogV0FS
TklORzogSW5saW5lIGVtcGhhc2lzDQo+IHN0YXJ0LQ0KPiA+ID4gc3RyaW5nIHdpdGhvdXQgZW5k
LXN0cmluZy4NCj4gPiA+ID4+IERvY3VtZW50YXRpb24vZHJpdmVyLWFwaS92ZmlvLnJzdDoyOTY6
IFdBUk5JTkc6IExpdGVyYWwgYmxvY2sgZW5kcw0KPiA+ID4gd2l0aG91dCBhIGJsYW5rIGxpbmU7
IHVuZXhwZWN0ZWQgdW5pbmRlbnQuDQo+ID4gPiA+PiBEb2N1bWVudGF0aW9uL2RyaXZlci1hcGkv
dmZpby5yc3Q6MzA1OiBXQVJOSU5HOiBVbmV4cGVjdGVkDQo+ID4gPiBpbmRlbnRhdGlvbi4NCj4g
PiA+ID4+IERvY3VtZW50YXRpb24vZHJpdmVyLWFwaS92ZmlvLnJzdDozMDY6IFdBUk5JTkc6IEJs
b2NrIHF1b3RlIGVuZHMNCj4gPiA+IHdpdGhvdXQgYSBibGFuayBsaW5lOyB1bmV4cGVjdGVkIHVu
aW5kZW50Lg0KPiA+ID4NCj4gPg0KPiA+IEhpIEFsZXgsDQo+ID4NCj4gPiBBbiB1cGRhdGVkIHZl
cnNpb24gdG8gYWRkcmVzcyBjb21tZW50cyBpbiB0aGlzIG1haWwuDQo+IA0KPiBQbGVhc2Ugc2Vu
ZCBhIHYzIHNlcmllcy4gIFRoYW5rcywNCg0KZG9uZS4g8J+Yig0KDQpSZWdhcmRzLA0KWWkgTGl1
DQo=
