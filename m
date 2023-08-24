Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6EB78685C
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 09:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240323AbjHXHbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 03:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234225AbjHXHbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 03:31:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D0D10C8;
        Thu, 24 Aug 2023 00:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692862297; x=1724398297;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cyCS25uRpj9HV+el41L28q4oyqPJdS1m1nu3ds2F6Fg=;
  b=SSWeFRLZQebvjjXY6Yim9+8VnI9SnIMZN1mGoC7VLmCjlSwE15Ycbg6X
   pBN/IBo5b0xTyHOLYd5vMGlrHbbxIBsEVyqdcLFYiy9cZqczSQ9NiMOEr
   rRxbDxsxG9VtDCox2sQnTkI3/r4hLo0rVjxKAaSXP5wTZhHvMcqIT15wH
   1JG1eDZAQuBdbbBByE2UinMc1jAbn8OhHCjUnd7niF07s+3JVBsRJ4xtH
   2wUMX/9oS7Hzi36fCI+FitmnkDkvW4e7Z7ZbE1qd62U1+nSv0WKRYNOJx
   QuVvO7aZ3Mn1/baNfOCbzXXw34sTLEt036z0pPCRdQXGf+hfkMG//kzC0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="460726278"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="460726278"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 00:31:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="766437435"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="766437435"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 24 Aug 2023 00:31:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 24 Aug 2023 00:31:32 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 24 Aug 2023 00:31:32 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 24 Aug 2023 00:31:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DeXYnqcdDJ3QtfweYYui7wGN1hYYvfUukQLDXlIvMCjcXpbgDhydjTlbF4ljoKhrezxGFPZ+46Zx6JKo94GEuonwPhldXQAbOTRy8tlMxRnJUq8rpDHQZNqc1FPb1+qCdmoIDf2jIt129NsO0+akBnG2FxYueaaj7zs7/x4V5HN4mOHA/KzZuOIYJ4POFw/yXPGToD4IE87FsFts2pIUNHfKaoV2Uf8/Xcdkkrhgo1VCBkg0YagIh0aQbZxmU0Tp6uI8CXmlodMcOelzC75u/u0uMzsAOt8rgXeNyZVq8x+Tq4OyuGyBpYbQH3iXwJhIsXuyqOTHzAzXRjQx9YjXGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cyCS25uRpj9HV+el41L28q4oyqPJdS1m1nu3ds2F6Fg=;
 b=mLSPojcc4dr9rIVnDj+RSL0yAxbrs7nSW49UEnSqm2AsjGZEbgGhgdd0+ACHebSmNSuViivVI0Gza8qd4ppobPfxfQ6Cm3B1my4iCvAHnp8LwBrjodyWXHdXWFtye4SaSgcMAUVwYp8fFMk0b05jExhj3acKA6toBUvASu0pfLWRBJcBYpcEW/gGXWuoXlVX7Id7pfyi8KGGdeuGsNEik4dQzXIzV/HqKxKlXqOJDfORvQUERBnBCA+CiHMuRFiysK2tAPgVI37DSokGXAbcBCgwAGYl4X9oK5ULnjdVU2jcsGkVReV9V9Bi8/wnEmyFncAoZirCusuX+KiBnwLQKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5502.namprd11.prod.outlook.com (2603:10b6:5:39e::23)
 by DS0PR11MB6376.namprd11.prod.outlook.com (2603:10b6:8:c8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Thu, 24 Aug
 2023 07:31:26 +0000
Received: from DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::889e:2c90:67be:2005]) by DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::889e:2c90:67be:2005%4]) with mapi id 15.20.6699.026; Thu, 24 Aug 2023
 07:31:26 +0000
From:   "Zeng, Xin" <xin.zeng@intel.com>
To:     Brett Creeley <bcreeley@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Cao, Yahui" <yahui.cao@intel.com>
Subject: RE: [RFC 5/5] vfio/qat: Add vfio_pci driver for Intel QAT VF devices
Thread-Topic: [RFC 5/5] vfio/qat: Add vfio_pci driver for Intel QAT VF devices
Thread-Index: AQHZq1VcBEuBLxaWQUiMZlgj/qpcxK/tZF+AgAk2naA=
Date:   Thu, 24 Aug 2023 07:31:26 +0000
Message-ID: <DM4PR11MB55021A7ECD9DAB45C246A9DC881DA@DM4PR11MB5502.namprd11.prod.outlook.com>
References: <20230630131304.64243-1-xin.zeng@intel.com>
 <20230630131304.64243-6-xin.zeng@intel.com>
 <10f3159d-62ae-0e4c-8ba4-6f7819a47ecb@amd.com>
In-Reply-To: <10f3159d-62ae-0e4c-8ba4-6f7819a47ecb@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5502:EE_|DS0PR11MB6376:EE_
x-ms-office365-filtering-correlation-id: d966e6fd-1445-4999-7f4a-08dba4742024
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +eNVvj76AZ8Mm9hYRY8Lvxsibv1n78CWfQKNlm0mqisXbkPRPLO0uZlnt4l01yW6lqVXyOGPQIf3ZoDnSTLgjMExGxA/c1MVZ0uYKmH5JdpjTOF3rmsnPPqfnqnc+RwA6STnOUyJJ9SW2BL3T93/LTBZxaxfN/MQgD/NVVNx04wrgwIs2malZqFfQpO2QB2NI93lWGrXTnfkUKoSPeNi091BWWC4lEx74Wk41Nkv57C+JzHVtI6jjMhiGDfJXdDoJCfYCXol82nwGpHDRP1oRqZxMXdua/JrxA+RdPJ0I+EX95LwZ79lIZ1uxdxlGKNZal48EonB8J76ymYDRQp1yK4hpaBX9+wRxhvdfYQ/PA/Vp60rNTAdIkk1Uyh6RDO6waa/HCR2DYGeQ6qYH3VCDu/8+TSDfREb2OBl1wbJdHq3SjgtrftpdgYyil8Tm6o/pZ9vGFc2PGT2fMieGgRtrT483rMK/0do+eAV19b3p+RBsrkFxspE3kZor52iOGQikJrZvmWLgKD4cHSKVdF9fgQOGs608lizI/4roD1GjVqkMuEcHhum7Hux87jErfcO+awAK+acKuGE3On8E5Q/ljChHiQ3HL0PVInpcgIX8CPtFDj124akbwf/CGSuijaK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5502.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(376002)(346002)(136003)(396003)(186009)(1800799009)(451199024)(52536014)(5660300002)(4326008)(8676002)(8936002)(33656002)(55016003)(26005)(71200400001)(38100700002)(38070700005)(82960400001)(122000001)(66946007)(76116006)(66556008)(66476007)(54906003)(64756008)(66446008)(316002)(110136005)(478600001)(53546011)(41300700001)(7696005)(9686003)(2906002)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzkrV1NlMzZsN1ZORmVIa01WVHlmbXpYTCtIZVNUUHlpdTRSMDZaRUhJN2pn?=
 =?utf-8?B?QVpxbzQ3Y3VGdm5jN1RpZ3ZSWlYyVmpvb3ROOUZldUFFTE81Vm9mYmJRL29O?=
 =?utf-8?B?UktTVktVaTFPT0xUdzJydnZ5Tm9EUGg5MExaUXUrYVBObmRVOTdRM1VBdEZ0?=
 =?utf-8?B?SjRIU01UdFVBb1FwekZBcmU0QVVWUjgrSGFzc3JpK2FmL3ppMEVoTlZSdUtT?=
 =?utf-8?B?ZmVaNU13dElzYlpXZHR5Z1k3ekk3emVCanVudGJlLyttemZ3c3cycDF0UFFM?=
 =?utf-8?B?QW1EWUdHNzhLZGxaa3piei9RZXo3aW9CUlp4VmFZVnNJZjhEWW95cHMxSlRx?=
 =?utf-8?B?QmM2emdEUHZDcDB0SG0zbkxQdmx5emlaQlI1Z1JQY2FJOGZZZ3FMVVAyVTY5?=
 =?utf-8?B?MGFxWjJmcmZoSDJCNHNta2JhTDhlR1dkblozWlRtbUROM05hd0diWnJXemgz?=
 =?utf-8?B?VTljYW4wK05wV3NVeDE2c2x1NEM1TXQ4WXNxL2pCcmRwbGMyeHVLaDkwRitw?=
 =?utf-8?B?OG5VS1dxeFVXR05iWlNGeTNMUjFFNHhJalo2c1FRSGY0RjNXK2F2anB6U21k?=
 =?utf-8?B?a1J5djlQbTF1OWFja0JKVi82U09qeTUrREZTS29WcldHMSsxdG1hU2hnQjls?=
 =?utf-8?B?czAremlpS05BNzJVU0tDQXlMTXp3Sk5tczZJcGVYNURmN1djS1llMDN1aUFk?=
 =?utf-8?B?VkgwNG1sNDVmemtONkpra29ITVhaRWorUmNjVFhUbjViZ00vajhuRzU2Q1dQ?=
 =?utf-8?B?cHhDdHYzQXptbVJoc3hOL2x6Zis0MkZkQm9Td2t6b0ljcjZjMm1SREpOR1dW?=
 =?utf-8?B?UFFmaDlEbDFHK0JzNisxN3VuanNNeERzT0F5YWhmd3R6NG0zdjI0MmZFc0t2?=
 =?utf-8?B?K0tveEczWkJidlp1b3I0OG9nQ01yZnNBTDlMcEVSWVAwYWdNQnltTXdKdVB5?=
 =?utf-8?B?UHdna2xTVXF1WjM5TXI3TklQbVRZRWsrQzY3cXdwSGt4ajNVekNJWnJ2UkVx?=
 =?utf-8?B?aFJZYmpvWVovbXhNb29XMUFEb0Y1Wm5VNndhVUt3ekhwSi9sOWdzWmhFcFpR?=
 =?utf-8?B?NkFyV1N4YVMzZm40Vk1nRVo0OTllYzRHdE1kMHZ0Vmx5S1laT2lnaElzL1RQ?=
 =?utf-8?B?dVROenJQaTQ0YUZMaVNEdkJjN2dKRzZSRjZzRXBHeWs2QUVjc1NqV0V0UDha?=
 =?utf-8?B?am5Qa3ZpejBpZHQybkwvL3ZVR041SUFySGN2Y1pwSGg0U2N6N0VJczREZkFw?=
 =?utf-8?B?OW8yTWNxRnF6Z3p5Ukhlb3VNMFRDRmZpL0JwTys4MmRCZW9XVGxDZVAybzRx?=
 =?utf-8?B?TENFZlFHUy91UGRKNlJsUVYxN29HbzBsd1RFOHhzdlU4ZzBPdWpJWFdxcjlT?=
 =?utf-8?B?Kyt2YmUzdGt2c0ZybjlYN0Jua05EUm1ndjZkM1ZUN1U1YXE0czRTbzdqMFZB?=
 =?utf-8?B?UlJaOHVFN3RjUU9WdTd3MDZKTjZaZWNwYSsvTGtmVmYwZVJic3FnbzRmZmZJ?=
 =?utf-8?B?aldqOE04bUliSUY2WGJhSGxUU1kyRG9NbmgwSE5WWW55SnR6Y2N6STdVWjZx?=
 =?utf-8?B?ZWxMbTFHYVN0TnhzY0pFdkRRSUpta3hOSVRuUWRZODA0Y2g5ZFBnRE1BcUFj?=
 =?utf-8?B?N1BWamp6Q2RoQVg4eFNLRUJFTmlVTlFqODlCZElzY0taT00zK2w3UXVMbklN?=
 =?utf-8?B?V2xPMzAxK3BDY3NtUy9yRFIvK2hnWTV4NkNTWEFmODlnNllNTGlIUnNadHZ2?=
 =?utf-8?B?aDMxQVBzV3hDbXcwK0dPWlhqUWk4L3BrR3NCR0tuWWcxMUlFUlJsR1l0NFdz?=
 =?utf-8?B?WWRHV1RUWnJMd2JRcktZRzNBM2YzbEVvTDdyUlZzQVVscjdIWWYxTDB3SFhK?=
 =?utf-8?B?VE85TDVycm5Qd3llWjFzL2xZelRpL09GU2lzdHUzRVFDTXBhSEN4dVN3aEJD?=
 =?utf-8?B?MHkrVVlrY3JkcmN2MURsTDRObVY2UzJta0Zqa0hZbmt1dmI1NUc1MDhpRy9o?=
 =?utf-8?B?dGFUV0l3YnUzSzlTaWdMNGZiTFArWnQrY0ZRSWl4M0dLSFk5Z3ZmWUlJeC9i?=
 =?utf-8?B?RE5tZzIzYW5TTzBacUl0UlN2WHB2WklxaXdRUHFFY2pDUy9qd3JHSndMOWpH?=
 =?utf-8?Q?hy+Wajox5CtWXBiA467tJMI44?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5502.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d966e6fd-1445-4999-7f4a-08dba4742024
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2023 07:31:26.4996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gLeI9sfJ7LnHy8HjHe8Xv6YzZpNAO5DRmMdZK1qIiEnVLPrLuB69TqM9ge181/vegaToiYyxCro3qOaBu3BeMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6376
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1cnNkYXksIEF1Z3VzdCAxNywgMjAyMyAxMjoyMCBBTSwgQnJldHQgQ3JlZWxleSA8YmNy
ZWVsZXlAYW1kLmNvbT4gd3JvdGU6DQo+ID4gK3sNCj4gPiArICAgICAgIHN0cnVjdCBkZXZpY2Ug
KmRldiA9ICZwZGV2LT5kZXY7DQo+ID4gKyAgICAgICBzdHJ1Y3QgcWF0X3ZmX2NvcmVfZGV2aWNl
ICpxYXRfdmRldjsNCj4gPiArICAgICAgIGludCByZXQ7DQo+ID4gKw0KPiA+ICsgICAgICAgcWF0
X3ZkZXYgPSB2ZmlvX2FsbG9jX2RldmljZShxYXRfdmZfY29yZV9kZXZpY2UsIGNvcmVfZGV2aWNl
LnZkZXYsDQo+IGRldiwgJnFhdF92Zl9wY2lfb3BzKTsNCj4gPiArICAgICAgIGlmIChJU19FUlIo
cWF0X3ZkZXYpKQ0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gUFRSX0VSUihxYXRfdmRldik7
DQo+ID4gKw0KPiA+ICsgICAgICAgcWF0X3ZkZXYtPnZmX2lkID0gcGNpX2lvdl92Zl9pZChwZGV2
KTsNCj4gPiArICAgICAgIHFhdF92ZGV2LT5wYXJlbnQgPSBwZGV2LT5waHlzZm47DQo+ID4gKyAg
ICAgICBpZiAoIXFhdF92ZGV2LT5wYXJlbnQgfHwgcWF0X3ZkZXYtPnZmX2lkIDwgMCkNCj4gPiAr
ICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+IA0KPiBTaW5jZSB2ZmlvX2FsbG9jX2Rl
dmljZSgpIHdhcyBzdWNjZXNzZnVsIHlvdSBuZWVkIHRvIGNhbGwNCj4gdmZpb19wdXRfZGV2aWNl
KCkgaW4gdGhpcyBlcnJvciBjYXNlIGFzIHdlbGwuDQoNCkdvb2QgY2F0Y2gsIHdpbGwgZml4IGl0
LiANClRoYW5rcyBmb3IgdGhlIGNvbW1lbnQsIEJyZXR0Lg0KDQo+ID4gKw0KPiA+ICsgICAgICAg
cGNpX3NldF9kcnZkYXRhKHBkZXYsICZxYXRfdmRldi0+Y29yZV9kZXZpY2UpOw0KPiA+ICsgICAg
ICAgcmV0ID0gdmZpb19wY2lfY29yZV9yZWdpc3Rlcl9kZXZpY2UoJnFhdF92ZGV2LT5jb3JlX2Rl
dmljZSk7DQo+ID4gKyAgICAgICBpZiAocmV0KQ0KPiA+ICsgICAgICAgICAgICAgICBnb3RvIG91
dF9wdXRfZGV2aWNlOw0KPiA+ICsNCj4gPiArICAgICAgIHJldHVybiAwOw0KPiA+ICsNCj4gPiAr
b3V0X3B1dF9kZXZpY2U6DQo+ID4gKyAgICAgICB2ZmlvX3B1dF9kZXZpY2UoJnFhdF92ZGV2LT5j
b3JlX2RldmljZS52ZGV2KTsNCj4gPiArICAgICAgIHJldHVybiByZXQ7DQo+ID4gK30NCj4gPiAr
DQo+ID4gK3N0YXRpYyBzdHJ1Y3QgcWF0X3ZmX2NvcmVfZGV2aWNlICpxYXRfdmZfZHJ2ZGF0YShz
dHJ1Y3QgcGNpX2RldiAqcGRldikNCj4gPiArew0KPiA+ICsgICAgICAgc3RydWN0IHZmaW9fcGNp
X2NvcmVfZGV2aWNlICpjb3JlX2RldmljZSA9IHBjaV9nZXRfZHJ2ZGF0YShwZGV2KTsNCj4gPiAr
DQo+ID4gKyAgICAgICByZXR1cm4gY29udGFpbmVyX29mKGNvcmVfZGV2aWNlLCBzdHJ1Y3QgcWF0
X3ZmX2NvcmVfZGV2aWNlLA0KPiBjb3JlX2RldmljZSk7DQo+ID4gK30NCj4gPiArDQo+ID4gKw0K
DQo+ID4gK01PRFVMRV9MSUNFTlNFKCJHUEwiKTsNCj4gPiArTU9EVUxFX0FVVEhPUigiSW50ZWwg
Q29ycG9yYXRpb24iKTsNCj4gPiArTU9EVUxFX0RFU0NSSVBUSU9OKCJRQVQgVkZJTyBQQ0kgLSBW
RklPIFBDSSBkcml2ZXIgd2l0aCBsaXZlDQo+IG1pZ3JhdGlvbiBzdXBwb3J0IGZvciBJbnRlbChS
KSBRQVQgZGV2aWNlIGZhbWlseSIpOw0KPiA+IC0tDQo+ID4gMi4xOC4yDQo+ID4NCg==
