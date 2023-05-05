Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B416F7E67
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 10:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjEEIKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 04:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjEEIKt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 04:10:49 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F472D48;
        Fri,  5 May 2023 01:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683274247; x=1714810247;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w7/7InIgJObcrnX5ECeSYcH6o+Z1T9G/fk1A0hCze60=;
  b=X1g5N264A8FT9T2tQzSgtxVv1DJ1y7eULFI8x9iznV5iPj7nZXzrkauH
   lhbBdAaTm7VwQ9oxEgpVCU4MPigjkNCWixt6LMzhk3kyUoXyvQ16l//s4
   UV8Q2f22en6C9as8zm2KcUbpPbYajLJ7b+X/cTjDJE+202fOIBJInNJEm
   kksS1hqB1C7V4HDG+QS7Y6NjqD7C6FIjZYwkzzzC5h5xpnvjlPAYyKPAE
   1B9aZf8ICod4GUlgpCGNPd4w8o4vcqcKMktxBgY2zBmICbpIFbhrAAu/X
   lYOiK39Tk9ZkUl0NhosNDliLeTSuw+TuHX7d2Ir1vDGRVWJmmfkvP+lQS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="328780265"
X-IronPort-AV: E=Sophos;i="5.99,251,1677571200"; 
   d="scan'208";a="328780265"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2023 01:10:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="674944555"
X-IronPort-AV: E=Sophos;i="5.99,251,1677571200"; 
   d="scan'208";a="674944555"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 05 May 2023 01:10:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 5 May 2023 01:10:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 5 May 2023 01:10:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 5 May 2023 01:10:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YpOUGD7rHS7GJlHihCV5GeZreMTIyljQVtiNbagjwn7GE9zQZcGEV8aK/bKG3rf88PYdn9cGn6VQNYV3FzC+Bm7YU9IYRnqqvJrHm6goMcnUbn7rs2P1q1C5NBOajKjtBsvoMkfz8KFOCxj4JtqvUhR8SDcwJnxdsFtunZH5NeNZBwyniQj/iMiDpSZ+B+l2chR/NuC2uLKD5yA6vT0mUiVK3F2+60gifpvLiY5xcGM/4emNrXS7gtmnpWv6DjyO0IvrEJ4hOhEqZKxMAFRJLh5v/lpHJvudMcJPTXBOzs4iiktDmMtNL/Qstpf3lveiBWVV9E2806C/PZXydBZ5Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w7/7InIgJObcrnX5ECeSYcH6o+Z1T9G/fk1A0hCze60=;
 b=jpO+S65OFR1ime14sH4NHI7q3WmJ9kwEggo9nRiX8LoyuCe6nPXJPCJAukuTOEdzzCIhm9z2GOIWjiF3RTzqCLt1RJgJKlcnyX2Rk8AqA6VfG9gus80UQ6Wge0eIeKh6HslBfwJNXN8/cKRMIcu9H8VxgYxrtkaLTfudZf7Uke8iVAmBPWWygIGfQyfFCm6oy5bY7e9eh6oUYBOCrTcp/u6GHJC66B3WE5pcMC7nhwqUs/AA+1pQRYwRUdv6KwnUM+ApFidAOTFTYDeR/pfrNs03MGYWR9cILZFROmV8NuknEVgnc4BIwJAZZ4/CuZ9yhrmpENZToQSsAMqvbQ0OHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6793.namprd11.prod.outlook.com (2603:10b6:510:1b7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Fri, 5 May
 2023 08:10:33 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%8]) with mapi id 15.20.6363.027; Fri, 5 May 2023
 08:10:33 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V4 10/11] vfio/pci: Support dynamic MSI-X
Thread-Topic: [PATCH V4 10/11] vfio/pci: Support dynamic MSI-X
Thread-Index: AQHZeS7NjeBSeWLT50GaZQKxGXZCA69ARxSQgADG4ICACkQGoA==
Date:   Fri, 5 May 2023 08:10:33 +0000
Message-ID: <BN9PR11MB5276ED7B47909222093E92438C729@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
 <c4c582970fbeaf4b6000845c400aa4c6b7bb2f13.1682615447.git.reinette.chatre@intel.com>
 <BN9PR11MB5276B67702AACB0B5BF1EC0A8C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <296ec21f-fc7d-eaf2-484c-27ae8815c5a8@intel.com>
In-Reply-To: <296ec21f-fc7d-eaf2-484c-27ae8815c5a8@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6793:EE_
x-ms-office365-filtering-correlation-id: 669141e9-7ba9-4783-1e83-08db4d403327
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XKdmGodVIOi8IRRW0GScfWjpHQbm18cs4CLz0mj8+I75Jv4w2IGaDeb33FlGVftu1Ha3GJOq7NGgcacA1Gv09bjAB4pW5Pz1Z3DBIr9q+yriSiO33l5fIWfEQtSIPNWt2cvJqabL2P2lS+VhNed4qOEBK9ln9Qq7gfK4wvb5jnqM97Gz3sa3H+EGq+5qloxGeCXAfXVljCFsq1jf6A2cM59GMZzc0EGtPtFMQM47mBoeZsGFrl4nrg1LzM7Vddg9IIBp6Qh11/mB/rcHFSUsHalxLzV+S9qSLyIpdiJN0vOzSnvYIsIdFbXdEWU+1mYh5h3+5IHA41BJMYJ65E73BFWumGmRNnjaPBP1o5gUw/l8hXEULSK/w2lVX2vV26QRU8q4vrYdJbzOI0A20epBA8UxwDAVEXNu9JGuNSsUceCDAmw6R0iVwF3IhZYqy39XeygVaEnGibzwCgYEMkL9E1xMkEErI5P7roOoSH6YAVjRRHJY+9As9cXFwrfFTHHLGZD1B9mKXgbZNL6lRVOeKDB/tTCdPePgbCi9Cy2ibbVIArisTPLlaIdovJqRcPRPB+zflkDLmvs5s+0AGvq08mMquFtaiXchAZFFg2Y9Zl/5ScaFUIL/nVAXZQxwzVRB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(396003)(39860400002)(376002)(346002)(451199021)(54906003)(110136005)(71200400001)(186003)(55016003)(33656002)(478600001)(86362001)(7696005)(41300700001)(122000001)(2906002)(82960400001)(38070700005)(316002)(8936002)(8676002)(38100700002)(83380400001)(52536014)(5660300002)(4326008)(66946007)(53546011)(66556008)(64756008)(66446008)(9686003)(66476007)(76116006)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VEFCaGd2d0FsMzh1M3lSWURRSFdhNlZoMmhnRmYyZmx5ejM0UDNIQ3dpTTg0?=
 =?utf-8?B?dGpJSGdkaXlJeG5DY3BRNGtSOXBRTVcya1pmeWI5UWRrTTYxZC9uM2Vqd2hR?=
 =?utf-8?B?RnVDYXY4MzBtdlYyd1Y0bnlGMUk0aFFqN0tHa25LVlpJaTBMblZyODBNWTNj?=
 =?utf-8?B?ZHFVTUZraERJZFhrVUNiSTlpWjZmd3VGNzA5MVdNY0F0SXpJYmlvL1lkQStG?=
 =?utf-8?B?bXlGMExERmpCWEo2dWhlc1hZN2hIemg4RlhsUzBpeUdoZDZadUlkamY5emhv?=
 =?utf-8?B?aXFUdHk3OG5Ob3pPaFVtQWxha1FpaUh4VGhaaThaM1luTHE4bGJDZzZ6cHZy?=
 =?utf-8?B?c0t1dERlVm95VTMxTHc3dXpNTk5UcmZiaDBiR3FoK0VYZ2NObmF2ZFNPbVVo?=
 =?utf-8?B?ZFowWnBzdnhjWG05cVZSQ0REOVVCVHB4ZE5QdURuVDNyV1lGanJyMGlvVC9X?=
 =?utf-8?B?Y1RGZk40S0tqdGtvMzloRGhkMzJLTzZTUGxVTUgxamUwRXp0N3ZYTlNhNGJP?=
 =?utf-8?B?WU9QamFIYVd1cHBmbjYrUW9HaklJNGVxYXJmMXUxcTdoQm4vZmFSbnU2VGdi?=
 =?utf-8?B?K3o5K01Ec2RNOGlDTVhvYnRWTDJYMEhLMFp6MzYwOG5ORlA1V3NkbG8zWFNu?=
 =?utf-8?B?cXRUU29WcVZRWksxZTdUeVZuVWY2cVJpb294R1NDS2lLZzdka1lqTDU1SjE3?=
 =?utf-8?B?U05UZWJSZFNhdy9jL0REYnZxM0FvS2t6ZFF6UXBEMWxqZXkzV2U0Y29SSTRZ?=
 =?utf-8?B?UmF5ZmdOVVhUTno5cW5qZmZVS1dhaFFLbklhYU1rdEZrRnRBOXRwanY5dStS?=
 =?utf-8?B?elE4ZHBIQzNlUnYrWU9JT1JtNTFNbTg2d1VhSm8wcnl6Z0VJc0UvS25pdVkz?=
 =?utf-8?B?U041L0lQZXRHOElCTjRpMzBieGs3TFFnM0x0U2FVcEloYVdEMFpSV2FBY0Nt?=
 =?utf-8?B?N1V6RXNwcGg1ZFhKUXltN0VSUmdqWHltT3dzTFE1TmFsVG9UU2NINFZydVFj?=
 =?utf-8?B?VzRnZmVrclJWY0lEcGx1SzJzWVhSalRRcjcxUzFqWTZTRDhsbjl1UzVoNlRL?=
 =?utf-8?B?WXZVRm5Tek9BakVWU3MzdFlod3BQeU80YXN1T2R4THRYc0ZJMmtBSWdtenA5?=
 =?utf-8?B?cHNpcmhWa3BiRnN4ZzlXYUtMeGJWSUxMdWdOamU4V2NMNFh0dDhhZVhxV0s4?=
 =?utf-8?B?Z01lNERmVmZ3bTdjaENUVXBFUitKRzJUSWpIaW9LU0lHYUU1bElXbXU2SlJQ?=
 =?utf-8?B?N2docmpzbFcrbTA0RVBjLzJjUk1CVGFjdlhVTFBGMTE3U2VtQzA0M1c2YW43?=
 =?utf-8?B?M2h3dlBQREdJaHlDOHM5c2orZDZ1Z1hsbUdLQjFla25YTC9hNkVWQS8vTUlE?=
 =?utf-8?B?eUFndFJGQUYzOVRmS3JWcjdNQWRFVHZnSklSbERHOGNrTUU0MTlHR01mdGlO?=
 =?utf-8?B?VjIvYXRUVVNqOHhyOU9XTDZHM0tKNGdvYjVHVlZReEhwZTRrZWF1TGkxNVFG?=
 =?utf-8?B?TnkwTnBmdDdHbGJOREIvL1kwRWZKY0VSbmNyK1lWbDhDcmZzM3RITjFVSUxr?=
 =?utf-8?B?bW1lTi9HQVpQcitSTzZteGdqTnlOZnIzZnppNklmUUc3UmNrSnUvaHVrR0ZW?=
 =?utf-8?B?MU0xM3BBb0hWcXBYRENjWDVSTVdNTHpBbHlnTFlJTzkrOHYwdXZscmdmRU41?=
 =?utf-8?B?dWdWRE1xaHYrVWVGMVpFdXRuWDQrWWs3K0dqZFZPeDlJK1UvaTRJMm4wYkM3?=
 =?utf-8?B?cHViOWdxREJLdjlnZlJ3alBJWE9EMllSS2NxcDJuN0pCYU9wUk56MGlMOEMv?=
 =?utf-8?B?L3JqUUgxRjA5bUs3VzF0ZVlPOE1DSHlUNWMzaXQrbXMxN08zMlYwTmtnY0o4?=
 =?utf-8?B?RHphVUhmeE4zTTVlL2Z4dVBzTlFXMjZHSEJZTW00WU5DNzNaNU5iZ0ZKRS9E?=
 =?utf-8?B?Wm1OZzVWQXk2VVFmM1hJN3lOWWNnc2RsWXh5cGt4elRnSndneHhGcE5LSXN4?=
 =?utf-8?B?MkFLQ280WmVOeFk3YjROcVJPOVZUMUhzWUgzRDlLRkNQM09Vcy8zVDlJMkhN?=
 =?utf-8?B?M1phK3FQK0tHUlR3Vmw4ZWN6aEVaUnNSNXlXdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 669141e9-7ba9-4783-1e83-08db4d403327
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2023 08:10:33.4420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z16C06KHjiDuzG/Xqqk2Y8nJNrj+P9GatsLkdLXhmJG1HudxoqgKfKfdgz+URUNXlczQjPivKgu5ZeGC3Eer7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6793
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBDaGF0cmUsIFJlaW5ldHRlIDxyZWluZXR0ZS5jaGF0cmVAaW50ZWwuY29tPg0KPiBT
ZW50OiBTYXR1cmRheSwgQXByaWwgMjksIDIwMjMgMjozNSBBTQ0KPiANCj4gSGkgS2V2aW4sDQo+
IA0KPiBPbiA0LzI3LzIwMjMgMTE6NTAgUE0sIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+PiBGcm9t
OiBDaGF0cmUsIFJlaW5ldHRlIDxyZWluZXR0ZS5jaGF0cmVAaW50ZWwuY29tPg0KPiA+PiBTZW50
OiBGcmlkYXksIEFwcmlsIDI4LCAyMDIzIDE6MzYgQU0NCj4gPj4NCj4gPj4gcGNpX21zaXhfYWxs
b2NfaXJxX2F0KCkgZW5hYmxlcyBhbiBpbmRpdmlkdWFsIE1TSS1YIGludGVycnVwdCB0byBiZQ0K
PiA+PiBhbGxvY2F0ZWQgYWZ0ZXIgTVNJLVggZW5hYmxpbmcuDQo+ID4+DQo+ID4+IFVzZSBkeW5h
bWljIE1TSS1YIChpZiBzdXBwb3J0ZWQgYnkgdGhlIGRldmljZSkgdG8gYWxsb2NhdGUgYW4gaW50
ZXJydXB0DQo+ID4+IGFmdGVyIE1TSS1YIGlzIGVuYWJsZWQuIEFuIE1TSS1YIGludGVycnVwdCBp
cyBkeW5hbWljYWxseSBhbGxvY2F0ZWQgYXQNCj4gPj4gdGhlIHRpbWUgYSB2YWxpZCBldmVudGZk
IGlzIGFzc2lnbmVkLiBUaGlzIGlzIGRpZmZlcmVudCBiZWhhdmlvciBmcm9tDQo+ID4+IGEgcmFu
Z2UgcHJvdmlkZWQgZHVyaW5nIE1TSS1YIGVuYWJsaW5nIHdoZXJlIGludGVycnVwdHMgYXJlIGFs
bG9jYXRlZA0KPiA+PiBmb3IgdGhlIGVudGlyZSByYW5nZSB3aGV0aGVyIGEgdmFsaWQgZXZlbnRm
ZCBpcyBwcm92aWRlZCBmb3IgZWFjaA0KPiA+PiBpbnRlcnJ1cHQgb3Igbm90Lg0KPiA+Pg0KPiA+
PiBUaGUgUENJLU1TSVggQVBJIHJlcXVpcmVzIHRoYXQgc29tZSBudW1iZXIgb2YgaXJxcyBhcmUg
YWxsb2NhdGVkIGZvcg0KPiA+PiBhbiBpbml0aWFsIHNldCBvZiB2ZWN0b3JzIHdoZW4gZW5hYmxp
bmcgTVNJLVggb24gdGhlIGRldmljZS4gV2hlbg0KPiA+PiBkeW5hbWljIE1TSVggYWxsb2NhdGlv
biBpcyBub3Qgc3VwcG9ydGVkLCB0aGUgdmVjdG9yIHRhYmxlLCBhbmQgdGh1cw0KPiA+PiB0aGUg
YWxsb2NhdGVkIGlycSBzZXQgY2FuIG9ubHkgYmUgcmVzaXplZCBieSBkaXNhYmxpbmcgYW5kIHJl
LWVuYWJsaW5nDQo+ID4+IE1TSS1YIHdpdGggYSBkaWZmZXJlbnQgcmFuZ2UuIEluIHRoYXQgY2Fz
ZSB0aGUgaXJxIGFsbG9jYXRpb24gaXMNCj4gPj4gZXNzZW50aWFsbHkgYSBjYWNoZSBmb3IgY29u
ZmlndXJpbmcgdmVjdG9ycyB3aXRoaW4gdGhlIHByZXZpb3VzbHkNCj4gPj4gYWxsb2NhdGVkIHZl
Y3RvciByYW5nZS4gV2hlbiBkeW5hbWljIE1TSS1YIGFsbG9jYXRpb24gaXMgc3VwcG9ydGVkLA0K
PiA+PiB0aGUgQVBJIHN0aWxsIHJlcXVpcmVzIHNvbWUgaW5pdGlhbCBzZXQgb2YgaXJxcyB0byBi
ZSBhbGxvY2F0ZWQsIGJ1dA0KPiA+PiBhbHNvIHN1cHBvcnRzIGFsbG9jYXRpbmcgYW5kIGZyZWVp
bmcgc3BlY2lmaWMgaXJxIHZlY3RvcnMgYm90aA0KPiA+PiB3aXRoaW4gYW5kIGJleW9uZCB0aGUg
aW5pdGlhbGx5IGFsbG9jYXRlZCByYW5nZS4NCj4gPj4NCj4gPj4gRm9yIGNvbnNpc3RlbmN5IGJl
dHdlZW4gbW9kZXMsIGFzIHdlbGwgYXMgdG8gcmVkdWNlIGxhdGVuY3kgYW5kIGltcHJvdmUNCj4g
Pj4gcmVsaWFiaWxpdHkgb2YgYWxsb2NhdGlvbnMsIGFuZCBhbHNvIHNpbXBsaWNpdHksIHRoaXMg
aW1wbGVtZW50YXRpb24NCj4gPj4gb25seSByZWxlYXNlcyBpcnFzIHZpYSBwY2lfZnJlZV9pcnFf
dmVjdG9ycygpIHdoZW4gZWl0aGVyIHRoZSBpbnRlcnJ1cHQNCj4gPj4gbW9kZSBjaGFuZ2VzIG9y
IHRoZSBkZXZpY2UgaXMgcmVsZWFzZWQuDQo+ID4NCj4gPiBJdCBpbXByb3ZlcyB0aGUgcmVsaWFi
aWxpdHkgb2YgYWxsb2NhdGlvbnMgZnJvbSB0aGUgY2FsbGluZyBkZXZpY2UgcC5vLnYuDQo+ID4N
Cj4gPiBCdXQgc3lzdGVtLXdpZGUgdGhpcyBpcyBub3QgZWZmaWNpZW50IHVzZSBvZiBpcnFzIGFu
ZCBub3QgcmVsZWFzaW5nIHRoZW0NCj4gPiB0aW1lbHkgbWF5IGFmZmVjdCB0aGUgcmVsaWFiaWxp
dHkgb2YgYWxsb2NhdGlvbnMgZm9yIG90aGVyIGRldmljZXMuDQo+IA0KPiBDb3VsZCB5b3UgcGxl
YXNlIGVsYWJvcmF0ZSBob3cgb3RoZXIgZGV2aWNlcyBtYXkgYmUgaW1wYWN0ZWQ/DQoNCnRoZSBt
b3JlIHRoaXMgZGV2aWNlcyByZXNlcnZlcyB0aGUgbGVzcyByZW1haW5zIGZvciBvdGhlcnMsIGUu
Zy4gaXJ0ZSBlbnRyaWVzLg0KDQo+IA0KPiA+IFNob3VsZCB0aGlzIGJlaGF2aW9yIGJlIHNvbWV0
aGluZyBjb25maWd1cmFibGU/DQo+IA0KPiBUaGlzIGlzIG5vdCBjbGVhciB0byBtZSBhbmQgSSBs
b29rIHRvIHlvdSBmb3IgZ3VpZGFuY2UgaGVyZS4gRnJvbSBwcmFjdGljYWwNCj4gc2lkZSBpdCBs
b29rcyBsaWtlIGNvbmZpZ3VyYXRpb24gdmlhIG1vZHVsZSBwYXJhbWV0ZXJzIGlzIHN1cHBvcnRl
ZCBidXQNCj4gd2hldGhlciBpdCBzaG91bGQgYmUgZG9uZSBpcyBub3QgY2xlYXIgdG8gbWUuDQo+
IA0KPiBXaGVuIGNvbnNpZGVyaW5nIHRoaXMgd2UgbmVlZCB0byB0aGluayBhYm91dCB3aGF0IHRo
ZSB1c2VyIG1heSBleHBlY3QNCj4gd2hlbg0KPiB0dXJuaW5nIG9uL29mZiB0aGUgY29uZmlndXJh
dGlvbi4gRm9yIGV4YW1wbGUsIE1TSS1YIGNvbnRpbnVlcyB0byBhbGxvY2F0ZSBhDQo+IHJhbmdl
IG9mIGludGVycnVwdHMgZHVyaW5nIGVuYWJsaW5nLiBUaGVzZSBoYXZlIGFsd2F5cyBiZWVuIHRy
ZWF0ZWQgYXMgYQ0KPiAiY2FjaGUiIChpbnRlcnJ1cHRzIHJlbWFpbiBhbGxvY2F0ZWQsIHdoZXRo
ZXIgdGhleSBoYXZlIGFuIGFzc29jaWF0ZWQNCj4gdHJpZ2dlcg0KPiBvciBub3QpLiBJZiB0aGVy
ZSBpcyBuZXcgY29uZmlndXJhYmxlIGJlaGF2aW9yLCBkbyB5b3UgZXhwZWN0IHRoYXQgdGhlDQo+
IGRyaXZlciBuZWVkcyB0byBkaXN0aW5ndWlzaCBiZXR3ZWVuIHRoZSBvcmlnaW5hbCAiY2FjaGUi
IHRoYXQgdGhlIHVzZXIgaXMNCj4gdXNlZCB0byBhbmQgdGhlIG5ldyBkeW5hbWljIGFsbG9jYXRp
b25zPyBUaGF0IGlzLCBzaG91bGQgYSBkeW5hbWljIE1TSS1YDQo+IGNhcGFibGUgZGV2aWNlIGFs
d2F5cyBmcmVlIGludGVycnVwdHMgd2hlbiB1c2VyIHNwYWNlIHJlbW92ZXMgYW4gZXZlbnRmZA0K
PiBvciBzaG91bGQgb25seSBpbnRlcnJ1cHRzIHRoYXQgd2VyZSBhbGxvY2F0ZWQgZHluYW1pY2Fs
bHkgYmUgZnJlZWQNCj4gZHluYW1pY2FsbHk/DQoNClRoYXQgbG9va3MgdHJpY2t5LiBQcm9iYWJs
eSB0aGF0IGlzIHdoeSBBbGV4IHN1Z2dlc3RlZCBkb2luZyB0aGlzIHNpbXBsZQ0Kc2NoZW1lIGFu
ZCBpdCBpcyBvbiBwYXIgd2l0aCB0aGUgb2xkIGxvZ2ljIGFueXdheS4gU28gSSdsbCB3aXRoZHJh
dyB0aGlzDQpjb21tZW50Lg0KDQo+IA0KPiA+PiArLyoNCj4gPj4gKyAqIFJldHVybiBMaW51eCBJ
UlEgbnVtYmVyIG9mIGFuIE1TSSBvciBNU0ktWCBkZXZpY2UgaW50ZXJydXB0IHZlY3Rvci4NCj4g
Pj4gKyAqIElmIGEgTGludXggSVJRIG51bWJlciBpcyBub3QgYXZhaWxhYmxlIHRoZW4gYSBuZXcg
aW50ZXJydXB0IHdpbGwgYmUNCj4gPj4gKyAqIGFsbG9jYXRlZCBpZiBkeW5hbWljIE1TSS1YIGlz
IHN1cHBvcnRlZC4NCj4gPj4gKyAqLw0KPiA+PiArc3RhdGljIGludCB2ZmlvX21zaV9hbGxvY19p
cnEoc3RydWN0IHZmaW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2LA0KPiA+PiArCQkJICAgICAgdW5z
aWduZWQgaW50IHZlY3RvciwgYm9vbCBtc2l4KQ0KPiA+PiArew0KPiA+PiArCXN0cnVjdCBwY2lf
ZGV2ICpwZGV2ID0gdmRldi0+cGRldjsNCj4gPj4gKwlzdHJ1Y3QgbXNpX21hcCBtYXA7DQo+ID4+
ICsJaW50IGlycTsNCj4gPj4gKwl1MTYgY21kOw0KPiA+PiArDQo+ID4+ICsJaXJxID0gcGNpX2ly
cV92ZWN0b3IocGRldiwgdmVjdG9yKTsNCj4gPj4gKwlpZiAoaXJxID4gMCB8fCAhbXNpeCB8fCAh
dmRldi0+aGFzX2R5bl9tc2l4KQ0KPiA+PiArCQlyZXR1cm4gaXJxOw0KPiA+DQo+ID4gaWYgKGly
cSA+PSAwIHx8IC4uLikNCj4gPg0KPiANCj4gSSBhbSBub3Qgc3VyZSBhYm91dCB0aGlzIHJlcXVl
c3QgYmVjYXVzZSBwY2lfaXJxX3ZlY3RvcigpIGNhbm5vdCByZXR1cm4gMC4NCj4gVGhlIExpbnV4
IGludGVycnVwdCBudW1iZXIgd2lsbCBiZSA+IDAgb24gc3VjY2Vzcy4gMCBtZWFucyAibm90IGZv
dW5kIg0KPiAoc2VlIG1zaV9nZXRfdmlycSgpKSwgd2hpY2ggaXMgdHJhbnNsYXRlZCB0byAtRUlO
VkFMIGJ5IHBjaV9pcnFfdmVjdG9yKCkuDQo+IA0KDQpUaGVyZSBpcyBhIHN1YnRsZSBkaWZmZXJl
bmNlIGJldHdlZW4gdGhlIGRlc2NyaXB0aW9uIGFuZCB0aGUgY29kZSBvZg0KcGNpX2lycV92ZWN0
b3IoKS4NCg0KLyoqDQogKiBwY2lfaXJxX3ZlY3RvcigpIC0gR2V0IExpbnV4IElSUSBudW1iZXIg
b2YgYSBkZXZpY2UgaW50ZXJydXB0IHZlY3Rvcg0KICogQGRldjogdGhlIFBDSSBkZXZpY2UgdG8g
b3BlcmF0ZSBvbg0KICogQG5yOiAgZGV2aWNlLXJlbGF0aXZlIGludGVycnVwdCB2ZWN0b3IgaW5k
ZXggKDAtYmFzZWQpOyBoYXMgZGlmZmVyZW50DQogKiAgICAgICBtZWFuaW5ncywgZGVwZW5kaW5n
IG9uIGludGVycnVwdCBtb2RlOg0KICoNCiAqICAgICAgICAgKiBNU0ktWCAgICAgdGhlIGluZGV4
IGluIHRoZSBNU0ktWCB2ZWN0b3IgdGFibGUNCiAqICAgICAgICAgKiBNU0kgICAgICAgdGhlIGlu
ZGV4IG9mIHRoZSBlbmFibGVkIE1TSSB2ZWN0b3JzDQogKiAgICAgICAgICogSU5UeCAgICAgIG11
c3QgYmUgMA0KICoNCiAqIFJldHVybjogdGhlIExpbnV4IElSUSBudW1iZXIsIG9yIC1FSU5WQUwg
aWYgQG5yIGlzIG91dCBvZiByYW5nZQ0KICovDQoNCkZyb20gYWJvdmUgJzAnIGlzIGEgdmFsaWQg
aXJxIG51bWJlci4NCg0KdGhlbiBpbiBmb2xsb3dpbmcgY29kZToNCg0KCWlycSA9IG1zaV9nZXRf
dmlycSgmZGV2LT5kZXYsIG5yKTsNCglyZXR1cm4gaXJxID8gaXJxIDogLUVJTlZBTDsNCg0KJzAn
IGlzIG9idmlvdXNseSBpbnZhbGlkIGZvciBtc2kuDQoNCkkgZGlkbid0IHJlYWxpemUgdGhlIG1z
aSBwYXJ0IHdoZW4gcmVhZGluZyB0aGUgcGF0Y2guIEl0IGxlZnQgbWUgaW4NCmNvbmZ1c2lvbiB0
aGF0ICcwJyBpcyB1bmhhbmRsZWQgYXMgaGVyZSB3ZSBvbmx5IGNoZWNrICI+MCIgd2hpbGUgaW4N
Cm90aGVyIHBsYWNlcyAiLUVJTlZBTCIgaXMgY2hlY2tlZC4NCg0KTm90IGJpZyBtYXR0ZXIgYnV0
IGl0IHNvdW5kcyBzbGlnaHRseSBjbGVhcmVyIHRvIG1lIHRvIGZvbGxvdyB0aGUNCmRlc2NyaXB0
aW9uIG9mIHBjaV9pcnFfdmVjdG9yKCkgaW5zdGVhZCBvZiBpdHMgaW50ZXJuYWwgZGV0YWlsLiAN
Cg==
