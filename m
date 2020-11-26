Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB8B2C4F46
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 08:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388411AbgKZHVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 02:21:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:64925 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726357AbgKZHVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Nov 2020 02:21:54 -0500
IronPort-SDR: aPD21QF13y98zWKI4IC1dYeroM//67YY6mn5tkAGDIzf/ftzJrrzHqoVTUxy+59Rz/fo+Bp11K
 PYHrwQsiyHQw==
X-IronPort-AV: E=McAfee;i="6000,8403,9816"; a="190399908"
X-IronPort-AV: E=Sophos;i="5.78,371,1599548400"; 
   d="scan'208";a="190399908"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2020 23:21:53 -0800
IronPort-SDR: ABYMLQHiLnNZJ3jI1zGeNsezNTj7njNs+bSk0wD+q/qFIFE65iX1n5oyKIVIrEmmeNur4SlqGQ
 SwIUFpiHUd8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,371,1599548400"; 
   d="scan'208";a="479248530"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga004.jf.intel.com with ESMTP; 25 Nov 2020 23:21:52 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 25 Nov 2020 23:21:52 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 25 Nov 2020 23:21:51 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 25 Nov 2020 23:21:51 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 25 Nov 2020 23:21:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdweIBmNMi0Tn5dnVWZL+pGk+2p3HwCf5hLgDA70lRefuDOZ7FadeZpASjV9B2VxTZTaVtYi1Xkm+DsoJqf218JX9Cpa62/sAd8h5CMRw8KYuzmWTlE/yEKAATWtzXyNpTt7Rdm6fkiSDHkLv/VplKImjUPgmeHntGKkKFuWe5zEmjJmjMZDiyBQBC6TKwZdwwOCdDxRq4T+rAR2HN9cOGvb99eVqNtJZmc32JE2MXlYzDb5Pni1Enm2ZHFxWKQKk/To1D7oVh9HSUjLEJSPifO5/YQhB7F5ybIsHeTptyWFPL5CsObyjkfW7PGxckMIgMOXXImRWIWrr4ET9F3SjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eVsYE1B93aecnIzA+RN4kwcFNOPDASJ0qh9F0WUGc5Q=;
 b=BQ+1GsjfoHC7zHRuGQhRbMpFgrEQjhfsSGq23SL/n4pchrBtasdLAU0XejHrHGQn+242/urEiUHlRRLrfzrI2i+p8W1b8lv0EMkuNsGrKFAVgEF1TYC9GgSt3AJw0HDfQPLVLZKmGh6v8I13XVc4d+iY/ShVpYj5Mn6dgJyICbhbqxQfgiiq62b9MZJmexUKLa+Tw+YMLXu3GdQbAK5CBSNPr9dmSrR9Jhe2nKkIWPC5V2TSoa3aXMb5rV5D8emvl9ZT8ZoFBjBAiNwqRD0uYMDcN6tVk+dGcDPmVL1HGRM4YBexiylxWmxCoOEAQO4PhUYbpFmcvseixIEazBMpDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eVsYE1B93aecnIzA+RN4kwcFNOPDASJ0qh9F0WUGc5Q=;
 b=wcEFRF7PHsHGc/brmXrwJolCQy8dztr76E23Zm8Pq9WzTN20gaorZJLJV3ZbsRUj8ZCK4ebDF1FXAwKODiXpr0kVA4lfqwj7b+6/Grry2qs5tJM8qUCCXkR2QJEPXIVgG+ap5Mwt3TEunXJZ3P41+x67ucm3wnQTKshSBa9Di6A=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB4075.namprd11.prod.outlook.com (2603:10b6:5:198::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20; Thu, 26 Nov 2020 07:21:50 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::a1ec:ba6b:5057:be2f]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::a1ec:ba6b:5057:be2f%11]) with mapi id 15.20.3589.030; Thu, 26 Nov
 2020 07:21:50 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Zeng, Xin" <xin.zeng@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v2 1/1] vfio/type1: Add vfio_group_domain()
Thread-Topic: [PATCH v2 1/1] vfio/type1: Add vfio_group_domain()
Thread-Index: AQHWw5ReQyBL40n+Qkqaex+H7WDSEanZ9uKg
Date:   Thu, 26 Nov 2020 07:21:50 +0000
Message-ID: <DM5PR11MB143560E51C84BAF83AE54AC0C3F90@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <20201126012726.1185171-1-baolu.lu@linux.intel.com>
In-Reply-To: <20201126012726.1185171-1-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.46.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58cdb67a-8652-4efb-16b1-08d891dbf135
x-ms-traffictypediagnostic: DM6PR11MB4075:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4075834DDB57B2F5329EAAAAC3F90@DM6PR11MB4075.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fNvJnB+eDoY8cAxbMwwAyvjVDx1WWOL3fFxusXt1m3EK9qZ8rb0wGAC+e2EjXt3nZYXB8cYTvFnAqqiWtoMIUem5yWe5ExhSV3VAoo3dpT1JyWoVPJokEp9AoKOY5W1z6pdNFD7L6Acz/VLy2yXY5qN5CNS2B0HIR/Y22aFf9wgkqV2sNdul/TE3OGxk8AWasd7V43GHrW5x71A+usxi8Llfw01IPPHmWxfyUzLyn9RSV86JQs31bGtPPTY+JywOjl52rbDCn5g8d6LdiUhJc6ogv8gIio/LFn76iwUCHaxRKa1iQoG39E/u7YiAHo9+U1fOGUVE42K1kGj3yDq9ZydCxieCSKS4H9rzA0/xB8MrsEolakHpsVHJntWr4I/enMRTAvAYEzdLVB3ODUBbdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(478600001)(8936002)(33656002)(55016002)(316002)(71200400001)(4326008)(86362001)(7416002)(110136005)(66946007)(54906003)(76116006)(66476007)(52536014)(9686003)(64756008)(66446008)(83380400001)(6506007)(2906002)(966005)(8676002)(5660300002)(186003)(26005)(66556008)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?QThrRG42U3AyNXBKM1dvODZlZjJRL1FGM1U5Yy9vc2VkRURLRkhrSWVORklU?=
 =?utf-8?B?TWRFSTcrSENpbnhBMy9qZG9aK210NkhnU1oySjVoK3FVM1JPN3FpWGVjcDhV?=
 =?utf-8?B?NkF2MlFySzJzaGg4L1MyenljTlAxcG9YUEY5eEFlSURabm5INHByQ3BhbG0v?=
 =?utf-8?B?SFpZcVhtRWc1VHZjYVZmQ2ZWOVlwcVJkdW1yQ3RvOUFWaHBNd3dCVWFhRyti?=
 =?utf-8?B?cTQwaEd4a2pGdXc3WU9uZE1wTUVMODczY2hwd2FhSTJOMWZsR09JSDN3SjZ4?=
 =?utf-8?B?M1RVZHd5c1VqRjJqdlhjd2Rod1Z6OE5GdVY1SU5DNnU2WFpMNVFNbUR1dTM1?=
 =?utf-8?B?L0dpOGNhaTZKb0RnL1lhNFBuTEVlT0dCTUlXd1BUTjBNQWZteHErbjFZVWhV?=
 =?utf-8?B?L1FmR3RyM1BORTYzV3Y1VUdZdGw4ZGhtRWJIZ0NwaTJqWFlzY3pndmpVYXVq?=
 =?utf-8?B?N3RWWkVLeUxWZjZwS1p2WDRMbXA4bEU5Q0hpQ0p4d0xscWJLTHVnVno3REwz?=
 =?utf-8?B?VDJRVHQ0UkNMdGZTTTN6ZXBNR2tKS1FlK3hhcmhBNUdmcEEvMWZMaGsvbUoz?=
 =?utf-8?B?VGF4QU9TYmRzYkZNYXcxY0FqYWlmUUNxeldsNVJIa3BmS1pOcjZycHJDdnNm?=
 =?utf-8?B?ZzMrSHBTLzNSNHdwQlg3SC9qRUtCa1dsZ3ErYm1yRlAxWDRHeUVmQ055amVW?=
 =?utf-8?B?S3lkN29YVWJsNlNESzlVOHU3ejFTcGl6bTV1QU5FNUh3eS8rc1RyblNxMGZz?=
 =?utf-8?B?UUZwMnBQWUdWU01Nc2xBNjVTQUVvVmVncEpFM1FtVTRidzYybUd5dkNXVVZN?=
 =?utf-8?B?SFB0Y2huNTNRdGd6QjAxNk1yWDJwTnNnZWR4a1Q5eTNGektBenVRNUVZN2xN?=
 =?utf-8?B?UTJLMXJWS1Q5WHdlYjZFa011SERhVWpPUExnWmQ0cldKSkg5ZGhoN1RGVW96?=
 =?utf-8?B?cFR1MEVtVzRPN0tvUmY2RjBoeVlwbGNqL3RQZFVIQm1VZk1kMWFTSitwSnNT?=
 =?utf-8?B?QmtVMFN6RGxvQ3dRTnEvQ3laL1lwcmxQMlNsWE5OdkUyYnF2OGhNWHVqV2ha?=
 =?utf-8?B?QVVIYUxYdkx2azNodC9kd1Rzb01DcGxJKzRoMDUzakphVHZDa2EzdFJ0RmNz?=
 =?utf-8?B?VFZTbWVlZ24xSmY1UWJuZ0ZEZW4wZ0c2UU01elQvcDJDb0JqbkcrSzFpaUIv?=
 =?utf-8?B?ZWpJTmtOVVduNmtZbUs0ZVRPS3prNG14cTFBODRnRnVUSFkvakFLKy9UazM1?=
 =?utf-8?B?Zjl1dVdFQ2NaS2JrRE1WS2pGR3o0VHNkaG5TUmUrU0R2dk50VEJEVU1NSFFs?=
 =?utf-8?Q?n5QYLsDhf7V/U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58cdb67a-8652-4efb-16b1-08d891dbf135
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2020 07:21:50.1909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FC6uoVN8SSTMzpO8u2znNXo9zwwuodTVt3t/fa/q6R2XGdUQGPN7jcMqEU0rpCUYsiH+xz3AkbFPBQejcrzcrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4075
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1cnMsIE5vdiAyNiwgMjAyMCwgYXQgOToyNyBBTSwgTHUgQmFvbHUgd3JvdGU6DQo+IEFk
ZCB0aGUgQVBJIGZvciBnZXR0aW5nIHRoZSBkb21haW4gZnJvbSBhIHZmaW8gZ3JvdXAuIFRoaXMg
Y291bGQgYmUgdXNlZA0KPiBieSB0aGUgcGh5c2ljYWwgZGV2aWNlIGRyaXZlcnMgd2hpY2ggcmVs
eSBvbiB0aGUgdmZpby9tZGV2IGZyYW1ld29yayBmb3INCj4gbWVkaWF0ZWQgZGV2aWNlIHVzZXIg
bGV2ZWwgYWNjZXNzLiBUaGUgdHlwaWNhbCB1c2UgY2FzZSBsaWtlIGJlbG93Og0KPiANCj4gCXVu
c2lnbmVkIGludCBwYXNpZDsNCj4gCXN0cnVjdCB2ZmlvX2dyb3VwICp2ZmlvX2dyb3VwOw0KPiAJ
c3RydWN0IGlvbW11X2RvbWFpbiAqaW9tbXVfZG9tYWluOw0KPiAJc3RydWN0IGRldmljZSAqZGV2
ID0gbWRldl9kZXYobWRldik7DQo+IAlzdHJ1Y3QgZGV2aWNlICppb21tdV9kZXZpY2UgPSBtZGV2
X2dldF9pb21tdV9kZXZpY2UoZGV2KTsNCj4gDQo+IAlpZiAoIWlvbW11X2RldmljZSB8fA0KPiAJ
ICAgICFpb21tdV9kZXZfZmVhdHVyZV9lbmFibGVkKGlvbW11X2RldmljZSwgSU9NTVVfREVWX0ZF
QVRfQVVYKSkNCj4gCQlyZXR1cm4gLUVJTlZBTDsNCj4gDQo+IAl2ZmlvX2dyb3VwID0gdmZpb19n
cm91cF9nZXRfZXh0ZXJuYWxfdXNlcl9mcm9tX2RldihkZXYpOyhkZXYpOw0KDQpkdXBsaWNhdGUg
KGRldik7IPCfmIpvdGhlciBwYXJ0cyBsb29rcyBnb29kIHRvIG1lLiBwZXJoYXBzLCB5b3UgY2Fu
IGFsc28NCmRlc2NyaWJlIHRoYXQgdGhlIHJlbGVhc2UgZnVuY3Rpb24gb2YgYSBzdWItZGV2aWNl
IGZkIHNob3VsZCBhbHNvIGNhbGwNCnZmaW9fZ3JvdXBfcHV0X2V4dGVybmFsX3VzZXIoKSB0byBy
ZWxlYXNlIGl0cyByZWZlcmVuY2Ugb24gdGhlIHZmaW9fZ3JvdXAuDQoNClJlZ2FyZHMsDQpZaSBM
aXUgDQoNCj4gCWlmIChJU19FUlJfT1JfTlVMTCh2ZmlvX2dyb3VwKSkNCj4gCQlyZXR1cm4gLUVG
QVVMVDsNCj4gDQo+IAlpb21tdV9kb21haW4gPSB2ZmlvX2dyb3VwX2RvbWFpbih2ZmlvX2dyb3Vw
KTsNCj4gCWlmIChJU19FUlJfT1JfTlVMTChpb21tdV9kb21haW4pKSB7DQo+IAkJdmZpb19ncm91
cF9wdXRfZXh0ZXJuYWxfdXNlcih2ZmlvX2dyb3VwKTsNCj4gCQlyZXR1cm4gLUVGQVVMVDsNCj4g
CX0NCj4gDQo+IAlwYXNpZCA9IGlvbW11X2F1eF9nZXRfcGFzaWQoaW9tbXVfZG9tYWluLCBpb21t
dV9kZXZpY2UpOw0KPiAJaWYgKHBhc2lkIDwgMCkgew0KPiAJCXZmaW9fZ3JvdXBfcHV0X2V4dGVy
bmFsX3VzZXIodmZpb19ncm91cCk7DQo+IAkJcmV0dXJuIC1FRkFVTFQ7DQo+IAl9DQo+IA0KPiAJ
LyogUHJvZ3JhbSBkZXZpY2UgY29udGV4dCB3aXRoIHBhc2lkIHZhbHVlLiAqLw0KPiAJLi4uDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBMdSBCYW9sdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0K
PiAtLS0NCj4gIGRyaXZlcnMvdmZpby92ZmlvLmMgICAgICAgICAgICAgfCAxOCArKysrKysrKysr
KysrKysrKysNCj4gIGRyaXZlcnMvdmZpby92ZmlvX2lvbW11X3R5cGUxLmMgfCAyMyArKysrKysr
KysrKysrKysrKysrKysrKw0KPiAgaW5jbHVkZS9saW51eC92ZmlvLmggICAgICAgICAgICB8ICAz
ICsrKw0KPiAgMyBmaWxlcyBjaGFuZ2VkLCA0NCBpbnNlcnRpb25zKCspDQo+IA0KPiBDaGFuZ2Ug
bG9nOg0KPiAgLSB2MTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtaW9tbXUvMjAyMDEx
MTIwMjI0MDcuMjA2Mzg5Ni0xLWJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbS8NCj4gIC0gQ2hhbmdl
ZCBhY2NvcmRpbmcgdG8gY29tbWVudHMgQCBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1p
b21tdS8yMDIwMTExNjEyNTYzMS4yZDA0M2ZjZEB3NTIwLmhvbWUvDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy92ZmlvL3ZmaW8uYyBiL2RyaXZlcnMvdmZpby92ZmlvLmMNCj4gaW5kZXggMjE1
MWJjN2Y4N2FiLi42MmM2NTIxMTFjODggMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdmZpby92Zmlv
LmMNCj4gKysrIGIvZHJpdmVycy92ZmlvL3ZmaW8uYw0KPiBAQCAtMjMzMSw2ICsyMzMxLDI0IEBA
IGludCB2ZmlvX3VucmVnaXN0ZXJfbm90aWZpZXIoc3RydWN0IGRldmljZSAqZGV2LA0KPiBlbnVt
IHZmaW9fbm90aWZ5X3R5cGUgdHlwZSwNCj4gIH0NCj4gIEVYUE9SVF9TWU1CT0wodmZpb191bnJl
Z2lzdGVyX25vdGlmaWVyKTsNCj4gDQo+ICtzdHJ1Y3QgaW9tbXVfZG9tYWluICp2ZmlvX2dyb3Vw
X2RvbWFpbihzdHJ1Y3QgdmZpb19ncm91cCAqZ3JvdXApDQo+ICt7DQo+ICsJc3RydWN0IHZmaW9f
Y29udGFpbmVyICpjb250YWluZXI7DQo+ICsJc3RydWN0IHZmaW9faW9tbXVfZHJpdmVyICpkcml2
ZXI7DQo+ICsNCj4gKwlpZiAoIWdyb3VwKQ0KPiArCQlyZXR1cm4gRVJSX1BUUigtRUlOVkFMKTsN
Cj4gKw0KPiArCWNvbnRhaW5lciA9IGdyb3VwLT5jb250YWluZXI7DQo+ICsJZHJpdmVyID0gY29u
dGFpbmVyLT5pb21tdV9kcml2ZXI7DQo+ICsJaWYgKGxpa2VseShkcml2ZXIgJiYgZHJpdmVyLT5v
cHMtPmdyb3VwX2RvbWFpbikpDQo+ICsJCXJldHVybiBkcml2ZXItPm9wcy0+Z3JvdXBfZG9tYWlu
KGNvbnRhaW5lci0+aW9tbXVfZGF0YSwNCj4gKwkJCQkJCSBncm91cC0+aW9tbXVfZ3JvdXApOw0K
PiArCWVsc2UNCj4gKwkJcmV0dXJuIEVSUl9QVFIoLUVOT1RUWSk7DQo+ICt9DQo+ICtFWFBPUlRf
U1lNQk9MKHZmaW9fZ3JvdXBfZG9tYWluKTsNCj4gKw0KPiAgLyoqDQo+ICAgKiBNb2R1bGUvY2xh
c3Mgc3VwcG9ydA0KPiAgICovDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8vdmZpb19pb21t
dV90eXBlMS5jIGIvZHJpdmVycy92ZmlvL3ZmaW9faW9tbXVfdHlwZTEuYw0KPiBpbmRleCA2N2U4
Mjc2Mzg5OTUuLjc4M2YxOGYyMWI5NSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy92ZmlvL3ZmaW9f
aW9tbXVfdHlwZTEuYw0KPiArKysgYi9kcml2ZXJzL3ZmaW8vdmZpb19pb21tdV90eXBlMS5jDQo+
IEBAIC0yOTgwLDYgKzI5ODAsMjggQEAgc3RhdGljIGludCB2ZmlvX2lvbW11X3R5cGUxX2RtYV9y
dyh2b2lkICppb21tdV9kYXRhLA0KPiBkbWFfYWRkcl90IHVzZXJfaW92YSwNCj4gIAlyZXR1cm4g
cmV0Ow0KPiAgfQ0KPiANCj4gK3N0YXRpYyB2b2lkICp2ZmlvX2lvbW11X3R5cGUxX2dyb3VwX2Rv
bWFpbih2b2lkICppb21tdV9kYXRhLA0KPiArCQkJCQkgICBzdHJ1Y3QgaW9tbXVfZ3JvdXAgKmlv
bW11X2dyb3VwKQ0KPiArew0KPiArCXN0cnVjdCB2ZmlvX2lvbW11ICppb21tdSA9IGlvbW11X2Rh
dGE7DQo+ICsJc3RydWN0IGlvbW11X2RvbWFpbiAqZG9tYWluID0gTlVMTDsNCj4gKwlzdHJ1Y3Qg
dmZpb19kb21haW4gKmQ7DQo+ICsNCj4gKwlpZiAoIWlvbW11IHx8ICFpb21tdV9ncm91cCkNCj4g
KwkJcmV0dXJuIEVSUl9QVFIoLUVJTlZBTCk7DQo+ICsNCj4gKwltdXRleF9sb2NrKCZpb21tdS0+
bG9jayk7DQo+ICsJbGlzdF9mb3JfZWFjaF9lbnRyeShkLCAmaW9tbXUtPmRvbWFpbl9saXN0LCBu
ZXh0KSB7DQo+ICsJCWlmIChmaW5kX2lvbW11X2dyb3VwKGQsIGlvbW11X2dyb3VwKSkgew0KPiAr
CQkJZG9tYWluID0gZC0+ZG9tYWluOw0KPiArCQkJYnJlYWs7DQo+ICsJCX0NCj4gKwl9DQo+ICsJ
bXV0ZXhfdW5sb2NrKCZpb21tdS0+bG9jayk7DQo+ICsNCj4gKwlyZXR1cm4gZG9tYWluOw0KPiAr
fQ0KPiArDQo+ICBzdGF0aWMgY29uc3Qgc3RydWN0IHZmaW9faW9tbXVfZHJpdmVyX29wcyB2Zmlv
X2lvbW11X2RyaXZlcl9vcHNfdHlwZTEgPSB7DQo+ICAJLm5hbWUJCQk9ICJ2ZmlvLWlvbW11LXR5
cGUxIiwNCj4gIAkub3duZXIJCQk9IFRISVNfTU9EVUxFLA0KPiBAQCAtMjk5Myw2ICszMDE1LDcg
QEAgc3RhdGljIGNvbnN0IHN0cnVjdCB2ZmlvX2lvbW11X2RyaXZlcl9vcHMgdmZpb19pb21tdV9k
cml2ZXJfb3BzX3R5cGUxID0gew0KPiAgCS5yZWdpc3Rlcl9ub3RpZmllcgk9IHZmaW9faW9tbXVf
dHlwZTFfcmVnaXN0ZXJfbm90aWZpZXIsDQo+ICAJLnVucmVnaXN0ZXJfbm90aWZpZXIJPSB2Zmlv
X2lvbW11X3R5cGUxX3VucmVnaXN0ZXJfbm90aWZpZXIsDQo+ICAJLmRtYV9ydwkJCT0gdmZpb19p
b21tdV90eXBlMV9kbWFfcncsDQo+ICsJLmdyb3VwX2RvbWFpbgkJPSB2ZmlvX2lvbW11X3R5cGUx
X2dyb3VwX2RvbWFpbiwNCj4gIH07DQo+IA0KPiAgc3RhdGljIGludCBfX2luaXQgdmZpb19pb21t
dV90eXBlMV9pbml0KHZvaWQpDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3ZmaW8uaCBi
L2luY2x1ZGUvbGludXgvdmZpby5oDQo+IGluZGV4IDM4ZDNjNmE4ZGM3ZS4uYTA2MTNhNmYyMWNj
IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4L3ZmaW8uaA0KPiArKysgYi9pbmNsdWRlL2xp
bnV4L3ZmaW8uaA0KPiBAQCAtOTAsNiArOTAsNyBAQCBzdHJ1Y3QgdmZpb19pb21tdV9kcml2ZXJf
b3BzIHsNCj4gIAkJCQkJICAgICAgIHN0cnVjdCBub3RpZmllcl9ibG9jayAqbmIpOw0KPiAgCWlu
dAkJKCpkbWFfcncpKHZvaWQgKmlvbW11X2RhdGEsIGRtYV9hZGRyX3QgdXNlcl9pb3ZhLA0KPiAg
CQkJCSAgdm9pZCAqZGF0YSwgc2l6ZV90IGNvdW50LCBib29sIHdyaXRlKTsNCj4gKwl2b2lkCQkq
KCpncm91cF9kb21haW4pKHZvaWQgKmlvbW11X2RhdGEsIHN0cnVjdCBpb21tdV9ncm91cCAqZ3Jv
dXApOw0KPiAgfTsNCj4gDQo+ICBleHRlcm4gaW50IHZmaW9fcmVnaXN0ZXJfaW9tbXVfZHJpdmVy
KGNvbnN0IHN0cnVjdCB2ZmlvX2lvbW11X2RyaXZlcl9vcHMgKm9wcyk7DQo+IEBAIC0xMjYsNiAr
MTI3LDggQEAgZXh0ZXJuIGludCB2ZmlvX2dyb3VwX3VucGluX3BhZ2VzKHN0cnVjdCB2ZmlvX2dy
b3VwICpncm91cCwNCj4gIGV4dGVybiBpbnQgdmZpb19kbWFfcncoc3RydWN0IHZmaW9fZ3JvdXAg
Kmdyb3VwLCBkbWFfYWRkcl90IHVzZXJfaW92YSwNCj4gIAkJICAgICAgIHZvaWQgKmRhdGEsIHNp
emVfdCBsZW4sIGJvb2wgd3JpdGUpOw0KPiANCj4gK2V4dGVybiBzdHJ1Y3QgaW9tbXVfZG9tYWlu
ICp2ZmlvX2dyb3VwX2RvbWFpbihzdHJ1Y3QgdmZpb19ncm91cCAqZ3JvdXApOw0KPiArDQo+ICAv
KiBlYWNoIHR5cGUgaGFzIGluZGVwZW5kZW50IGV2ZW50cyAqLw0KPiAgZW51bSB2ZmlvX25vdGlm
eV90eXBlIHsNCj4gIAlWRklPX0lPTU1VX05PVElGWSA9IDAsDQo+IC0tDQo+IDIuMjUuMQ0KDQo=
