Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC216DA956
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 09:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239531AbjDGHWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 03:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjDGHWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 03:22:06 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CA086B9;
        Fri,  7 Apr 2023 00:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680852124; x=1712388124;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C65XzT+SOeY4aDgORdBkp5jciG6lPuIMSmPk8kKhmVo=;
  b=QCcs3pIcV6UEp/5xferOMIkvh9rgCAMjppAc91H36B0UjaPnKPll8lUs
   wLOcRU0tW6yrGVlI4cesl1/qv+jXv8xsKlB7quNLSWuVnA3rcYjUi2Ptb
   HAnRp6RhGeehzrsNVYkVklqZ7GxDqlGJEViU6/5dl3/E7SYOB85ok08IE
   gG0pQYfKexdm5ZXcTqKfHBXlyNiof1WbAWxCzjCPc73QJvm3wLQo2iwZ2
   5BMeZvn2VYTsAdZakMjStWkdq5Pzp8cZAUkXDXNlr8XTnK+hNNLd0Zhqr
   gf12VO3Wg5K+SHLkrcXrT/mW9zX4tRkpccwiy+KyKL/7/dVGQBqi/vgTG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="370775902"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="370775902"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 00:22:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="776765844"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="776765844"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Apr 2023 00:21:59 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 00:21:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 7 Apr 2023 00:21:59 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 7 Apr 2023 00:21:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9lDgTxREM7iXZ11+DUpxCipldNI1TVJUQgEcpacbQMl3GJjmgNUVbuHFfBYEhNkEq+kkvJxkECsdODQc5iXPsKg8xn6oDXC/+C3uBts5OP5kR1f9kcUO/Rp4caVhqzbVPuvldKiWX9smWmTl4fL+KJ+WBZbvp/KkbbsExucdGcQWoQHzO1DunTHFJ2FuZWT6R5KpqD3IoTaCh5Me+1/0qYq57AT0z72FffcTGp2H8xDMLvQsg4WD+S84nVHP3GdbgKN21sn/n4DNCEcPHjfYvwXBzRjlykjZEexZZbbgAy+pDyztmVS1/NBkwOdRP/T6EIfw853nA6fRK15RoN5Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C65XzT+SOeY4aDgORdBkp5jciG6lPuIMSmPk8kKhmVo=;
 b=PlyyAN2vhBSTcpkoONcAL4Gl9dq+zAdhuf+sGAC5+UGFMog5GB3Eh0ffYZ+vqEY2ZeS/H1OisYlEP6VQCVxCCZPNsxysKGaPKLgK4xx3I9Kr+9LgAw1oVn8C+ZKGS+5ISqZyBUnGSYVC6K/uaduVGh+fXbLWxleyqZxDs8bc0kafcy6j/dTfouZVHxevjI5zAm3qXZrhoblGL5yI5nIATc6gqD9u/KXW9kAYO5sDQ87ltbTfnuNVCoXI901WoYfoY4P6jUWUuhJOR8XQdFBquFecHN1BUPbdWShGoW7Y31wnHEP+7J9yUnpdcl+iY5Yv7YPi2W/M0DlgxJxJK2ghxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY4PR11MB1238.namprd11.prod.outlook.com (2603:10b6:903:2f::17)
 by BN9PR11MB5434.namprd11.prod.outlook.com (2603:10b6:408:11f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Fri, 7 Apr
 2023 07:21:49 +0000
Received: from CY4PR11MB1238.namprd11.prod.outlook.com
 ([fe80::d753:5f87:f63b:3a56]) by CY4PR11MB1238.namprd11.prod.outlook.com
 ([fe80::d753:5f87:f63b:3a56%11]) with mapi id 15.20.6277.030; Fri, 7 Apr 2023
 07:21:47 +0000
From:   "Liu, Jing2" <jing2.liu@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Jing2" <jing2.liu@intel.com>
Subject: RE: [PATCH V2 4/8] vfio/pci: Use xarray for interrupt context storage
Thread-Topic: [PATCH V2 4/8] vfio/pci: Use xarray for interrupt context
 storage
Thread-Index: AQHZYb/K+8m1AljiBkCGu+scZ7O8L68fd1rA
Date:   Fri, 7 Apr 2023 07:21:46 +0000
Message-ID: <CY4PR11MB1238E93B038C09DD38269BD2A9969@CY4PR11MB1238.namprd11.prod.outlook.com>
References: <cover.1680038771.git.reinette.chatre@intel.com>
 <8e9aaee36eac32c4b22f6a2c334721ca84132d61.1680038771.git.reinette.chatre@intel.com>
In-Reply-To: <8e9aaee36eac32c4b22f6a2c334721ca84132d61.1680038771.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY4PR11MB1238:EE_|BN9PR11MB5434:EE_
x-ms-office365-filtering-correlation-id: 27a8bb95-1890-46c3-8647-08db3738bf1f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w55WP3uUYcb81uC3pFuAnK1NEnqNH6Dm3R+vkCDXAd6YeP5nLy16djIo1tVFzkybs21xL0sUJZ0lJj64me4TP0gGnXm+gTgMmhmkWSZ3QugD86cVmG5VOIU8QLWmh4rxBdGb1/lP9spGz3N5/883Jf8LYDluR7d5rJbMe0HC3GX48FBjMom7x197qZkuPAsYe5o7YVlnCOmdzUyvaXg+B8gjrIrNK/9gObo2an+1sPaRXz1R4jZAewgPV5YkHBlKxt793LC15n9tnbnHfWHhQg7C1l1GW1i90striLRENxvezunwoBeTmcIHIMjiDxCNAcovObBboglSKMu7tOVUN+8v3FFF2U6Xoc9GBbCJagwvs8HQwTKyOwBl6/pmrX6G8UxV2+Eu78v5tPIZYxX4ebU9W7Plbg3FOePA9APJsZp4uJWS3P0b0sBUJeKGHaSprHGweuj8Fs+7GsbrBFdY3uLIkXp8PMReKPdCrFjwg0ddxGhl/6TJDQ0xltyDVNS+zCByQgk3jP8ArUo+InyxTiOEBQ/fPseMazT1nSIymOZCS0XGoHYo9jR7uVSRJLGJH5c8TPXNBNUpl0rB4DYL4SDxc7ikNTVdDhVjKl05ijz6o0dHdhebR0rk7TbARVRu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1238.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(136003)(39860400002)(396003)(376002)(451199021)(316002)(83380400001)(9686003)(7696005)(478600001)(71200400001)(110136005)(186003)(54906003)(6506007)(122000001)(64756008)(66446008)(5660300002)(2906002)(38100700002)(4326008)(33656002)(41300700001)(66476007)(86362001)(52536014)(76116006)(55016003)(82960400001)(8936002)(66946007)(66556008)(38070700005)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZkFwYjhIWTYvWlhDK0V4Z1pkMVdpVEZwRko1RitRNzZpdGVsZkFsNGEyK1pI?=
 =?utf-8?B?Ty8vdk1xcFg0cG4yZHVxZ0xtcDNKZXgrRm1WUkdTZXV5blBRcEV0L2l3Z3BD?=
 =?utf-8?B?NlF4WlI3enB4SjhjNUJaOWlLUURaWklheFVqaTVjcmg1RGdqd2pHV2NKaFZm?=
 =?utf-8?B?bCtoanhwbUFhZ2ZQajZNV1NkWXozd1lWaTBRZDQrTVcrUllJQnFYaWcvYUIw?=
 =?utf-8?B?bW10WURXKy81dEVDMkRlWFJHWDBDTnFHb042bk54T1FROXc0U01EMTFwdEgx?=
 =?utf-8?B?QjN1YWc1U2l3aE5INlRtL2V1MXRLZTU2YnpmTTFDTzcySURkbndBUjgweGlK?=
 =?utf-8?B?Smkwa1F0MnJDN0thWXAvK2syUHpZdWdLSHh2a200bEczTkxncHFkSmFJTmxD?=
 =?utf-8?B?L2N4TEFFUHpvQnZ5NDI5eFhnYWNXTWhqeHZ3Y051alFzNFhaV1pZazZCeDlD?=
 =?utf-8?B?NGR1dm9abU5VL2xML3ZCamhKTDN0R2NvVnQwdFk0ck1jNnpUTnMyOUI4aUsy?=
 =?utf-8?B?ak1sY2NyczRIYnMyVE9NOHYrVGw3S0tGNmxWb3JqNkVqVlk1UThvb1dnQitU?=
 =?utf-8?B?TVhSaG52SC9ZVjhnay92anBaK1NMcFJKcXJSYTllaVF5YklDbERpOE1welcv?=
 =?utf-8?B?VDN2SGtRdFJaaG9pa3ZRcmo1ZkN0dE9xdWs1cE90WHNDMkFvVG9xanFSM1ho?=
 =?utf-8?B?OUFBOHRiS3d6NmpLMi81K0hlS1hnVnFwR2hOMlRXTkZSajRPeWM0NkMyQ25t?=
 =?utf-8?B?SW1zY0tyU2liRGd3TjYrV1hEVDB0eFZMQjA4eXorNmFkakMwaG9qbURSNWtY?=
 =?utf-8?B?aGtIN1N6TysrM01rVHZTNGgybXR0TWdQZDdjNTBQV2tNZVhLa2c5ODc3aXRk?=
 =?utf-8?B?MWZOaEU4SnBTV2R0VURyZ3VHUytDRnRod0JlNWgyL0RTdDNEU2RXeW42bUVC?=
 =?utf-8?B?VFZTNVFuanFCbEIvdXowWFZabTFkYVlBQzE3WWZvTWtONS9hNHR6b1ZPLzNH?=
 =?utf-8?B?VUpmZUNSRlhGNjJmSHkxVW4zVWVCeFFPTVA3VWFIK1ZQbzEzaEZranRrajd6?=
 =?utf-8?B?Nk1sM3J6KzQrbjNZUXdoNEtmcDlmalI2dUtOdDIzdGFSMnpTNytpSXlKbldT?=
 =?utf-8?B?Qlp5Z3JEdlF4dnVSd1pFOHl0cTJQWmtMK1ViMEo1a2o3U3hxblpOaDhOWDc1?=
 =?utf-8?B?YjlCZFBWVVRWTTR2MHJRc0dNOXpEeVVTRUJEUHBmdzJXNWdhUGM3bTgySEV1?=
 =?utf-8?B?bTRVRFFjNDBoNnpZV3k2ZFFRWGlWTi83SFc0V3IyUGxGUjdkYWVySFh4OFM2?=
 =?utf-8?B?SmxNTE5jYlNZamtiaURhQjh4VEVDdXBaTzBsL2VRZkl0YWZoTllLZzA4WWk0?=
 =?utf-8?B?a2ZSa0w5QmIvRmF5VlBWT1htVktmSjZCK2QvZVJRQm1JeVpLUDhlNmFscXFO?=
 =?utf-8?B?djBVTjR1V213S1FvbHo4cFV6OGFkMzAxd3ExZ2hzODgrQytFTkZEdlYrSGpW?=
 =?utf-8?B?d3NrTDU2aDBKNTViMExaNFZhdjdvVm53M0VlRWhMVTcvS3dSckhaMTIzc2dk?=
 =?utf-8?B?UndPY0JLZEZzaW11NkxNWG9EMm9XazRUS3E0emFxRVhYSzIya3V3VU1yMEV3?=
 =?utf-8?B?RThRL1JaNUxmbVM0aWJCazkya09iK1Z2NERUR1NaTGhESnlSYnhZSksvZ25V?=
 =?utf-8?B?TFVUQUthL1VXNDhYYTZtOGNXWm5uMDJ5dDRpUE10MnRRUkhjZi9NRG9hTXF3?=
 =?utf-8?B?UmFRT292UFRGSDVaUXJFUnhVWFo4MEp2S2pVN1IzS0RLTDFDQUdJdHdWaEJG?=
 =?utf-8?B?bk9MV1lxdDdnS1Q4Z3gwZGNJL0YwcVdvOWVTUDlmbDZycTlTZGlqUCtIM0Fq?=
 =?utf-8?B?QUxmR1JxWkhvc1E1ZXV6OFNmTTFkUkJFS1hNdy8xS2ZqUkZNbi81bnE5L2ZG?=
 =?utf-8?B?dXdLa2djclBrRWJHa2tZT3NTNWRLN0FQa0xnV1phekwwZEpoanNMUHFGZEo5?=
 =?utf-8?B?UU5mbFJKSUdkU0s0R0dnVHVvRWdRNVRFNmVTMXJuVVFDMXVMMnNqaTFoUm5i?=
 =?utf-8?B?dWE3U1FMc3M3ODZQYmU4UW8rU1VScktTMWNpQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1238.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27a8bb95-1890-46c3-8647-08db3738bf1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 07:21:46.6924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J/+FRRVU2bOQBdUeMQCQV5r/ZZZ8w30B3AGAGdPmZemlbvgV8Y17ZANrC5oN5ANeQ/zj2qM+xMsge7tiPmzyug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5434
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgUmVpbmV0dGUsDQoNCj4gRnJvbTogQ2hhdHJlLCBSZWluZXR0ZSA8cmVpbmV0dGUuY2hhdHJl
QGludGVsLmNvbT4NCj4gU3ViamVjdDogW1BBVENIIFYyIDQvOF0gdmZpby9wY2k6IFVzZSB4YXJy
YXkgZm9yIGludGVycnVwdCBjb250ZXh0IHN0b3JhZ2UNCj4gDQo+IEludGVycnVwdCBjb250ZXh0
IGlzIHN0YXRpY2FsbHkgYWxsb2NhdGVkIGF0IHRoZSB0aW1lIGludGVycnVwdHMgYXJlIGFsbG9j
YXRlZC4NCj4gRm9sbG93aW5nIGFsbG9jYXRpb24sIHRoZSBjb250ZXh0IGlzIG1hbmFnZWQgYnkg
ZGlyZWN0bHkgYWNjZXNzaW5nIHRoZQ0KZWxlbWVudHMgb2YgdGhlIGFycmF5IHVzaW5nIHRoZSB2
ZWN0b3IgYXMgaW5kZXguIFRoZSBzdG9yYWdlIGlzIHJlbGVhc2UNCndoZW4gaW50ZXJydXB0cyBh
cmUgZGlzYWJsZWQuDQo+IA0KDQpMb29raW5nIGF0IHRoZSBkeW5hbWljIGFsbG9jYXRpb24gY2hh
bmdlIGZvciB0aGUgdGltZSBhZnRlciBNU0kteCBpcw0KZW5hYmxlZCBpbiB2ZmlvX21zaV9zZXRf
dmVjdG9yX3NpZ25hbCgpLCBkbyB3ZSBuZWVkIHRvIGNvbnNpZGVyIGNoYW5naW5nIA0KdGhlIGFs
bG9jYXRpb24gb2YgY29udGV4dC9pbnRlcnJ1cHQgaW4gdmZpb19tc2lfZW5hYmxlKCkgZm9yIE1T
SS14IHRvIHRoZSANCnNhbWUgd2F5LCB3aGljaCBvbmx5IGFsbG9jYXRlcyBmb3IgdmVjdG9ycyB3
aXRoIGEgdmFsaWQgc2lnbmFsIGZkIHdoZW4gDQpkeW5hbWljIE1TSS14IGlzIHN1cHBvcnRlZD8N
Cg0KQmVjYXVzZSBpbiBkeW5hbWljIGxvZ2ljLCBJIHRoaW5rIHdoZW4gZW5hYmxpbmcgTVNJLXgs
IG5vdCBhbGwgdmVjdG9ycyBmcm9tIA0KemVybyB0byBudmVjIHNob3VsZCBiZSBhbGxvY2F0ZWQs
IGFuZCB0aGV5IHdvdWxkIGJlIGRvbmUgdW50aWwgdGhleSBhcmUgcmVhbGx5DQp1c2VkIHdpdGgg
c2V0dGluZyB0aGUgc2luZ2FsIGZkLg0KDQpOb3Qgc3VyZSBpZiB0aGlzIGNvbW1lbnQgYmVpbmcg
cmVwbGllZCBoZXJlIGlzIHRoZSBnb29kIHBsYWNlIHNpbmNlDQp2ZmlvX21zaV9lbmFibGUoKSBz
ZWVtcyBubyBjaGFuZ2UgaW4gdGhpcyBzZXJpZXMuIPCfmIogDQoNCg0KVGhhbmtzLA0KSmluZw0K
DQoNCj4gDQo+IFVzZSB0aGUgbmV3IGRhdGEgc3RvcmFnZSB0byBhbGxvY2F0ZSBhbGwgZWxlbWVu
dHMgb25jZSBhbmQgZnJlZSBhbGwgZWxlbWVudHMNCj4gdG9nZXRoZXIuIER5bmFtaWMgdXNhZ2Ug
Zm9sbG93cy4NCj4gDQo+IENyZWF0ZSBoZWxwZXJzIHdpdGggdW5kZXJzdGFuZGluZyB0aGF0IGl0
IGlzIG9ubHkgcG9zc2libGUgdG8gKGFmdGVyIGluaXRpYWwgTVNJLVgNCj4gZW5hYmxpbmcpIGFs
bG9jYXRlIGEgc2luZ2xlIE1TSS1YIGluZGV4IGF0IGEgdGltZS4gVGhlIG9ubHkgdGltZSBtdWx0
aXBsZSBNU0ktWA0KPiBhcmUgYWxsb2NhdGVkIGlzIGR1cmluZyBpbml0aWFsIE1TSS1YIGVuYWJs
aW5nIHdoZXJlIGZhaWx1cmUgcmVzdWx0cyBpbiBubw0KPiBhbGxvY2F0aW9ucy4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IFJlaW5ldHRlIENoYXRyZSA8cmVpbmV0dGUuY2hhdHJlQGludGVsLmNvbT4N
Cj4gLS0tDQo+IENoYW5nZXMgc2luY2UgUkZDIFYxOg0KPiAtIExldCB2ZmlvX2lycV9jdHhfYWxs
b2Nfc2luZ2xlKCkgcmV0dXJuIHBvaW50ZXIgdG8gYWxsb2NhdGVkDQo+ICAgY29udGV4dC4gKEFs
ZXgpDQo+IC0gVHJhbnNpdGlvbiBJTlR4IGFsbG9jYXRpb24gdG8gc2ltcGxpZmllZCB2ZmlvX2ly
cV9jdHhfYWxsb2Nfc2luZ2xlKCkuDQo+IC0gSW1wcm92ZSBhY2N1cmFjeSBvZiBjaGFuZ2Vsb2cu
DQo+IA0KPiAgZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9jb3JlLmMgIHwgIDEgKyAgZHJpdmVy
cy92ZmlvL3BjaS92ZmlvX3BjaV9pbnRycy5jIHwgNzcNCj4gKysrKysrKysrKysrKysrKysrKyst
LS0tLS0tLS0tLQ0KPiAgaW5jbHVkZS9saW51eC92ZmlvX3BjaV9jb3JlLmggICAgIHwgIDIgKy0N
Cj4gIDMgZmlsZXMgY2hhbmdlZCwgNTMgaW5zZXJ0aW9ucygrKSwgMjcgZGVsZXRpb25zKC0pDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9jb3JlLmMgYi9kcml2
ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2NvcmUuYw0KPiBpbmRleCBhNWFiNDE2Y2Y0NzYuLmFlMGUx
NjFjN2ZjOSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9jb3JlLmMN
Cj4gKysrIGIvZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9jb3JlLmMNCj4gQEAgLTIxMDIsNiAr
MjEwMiw3IEBAIGludCB2ZmlvX3BjaV9jb3JlX2luaXRfZGV2KHN0cnVjdCB2ZmlvX2RldmljZQ0K
PiAqY29yZV92ZGV2KQ0KPiAgCUlOSVRfTElTVF9IRUFEKCZ2ZGV2LT52bWFfbGlzdCk7DQo+ICAJ
SU5JVF9MSVNUX0hFQUQoJnZkZXYtPnNyaW92X3Bmc19pdGVtKTsNCj4gIAlpbml0X3J3c2VtKCZ2
ZGV2LT5tZW1vcnlfbG9jayk7DQo+ICsJeGFfaW5pdCgmdmRldi0+Y3R4KTsNCj4gDQo+ICAJcmV0
dXJuIDA7DQo+ICB9DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2lu
dHJzLmMgYi9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2ludHJzLmMNCj4gaW5kZXggZWNlMzcx
ZWJlYTAwLi4wMDExOTY0MWFhMTkgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdmZpby9wY2kvdmZp
b19wY2lfaW50cnMuYw0KPiArKysgYi9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2ludHJzLmMN
Cj4gQEAgLTUyLDI1ICs1Miw2MCBAQCBzdGF0aWMNCj4gIHN0cnVjdCB2ZmlvX3BjaV9pcnFfY3R4
ICp2ZmlvX2lycV9jdHhfZ2V0KHN0cnVjdCB2ZmlvX3BjaV9jb3JlX2RldmljZSAqdmRldiwNCj4g
IAkJCQkJICB1bnNpZ25lZCBsb25nIGluZGV4KQ0KPiAgew0KPiAtCWlmIChpbmRleCA+PSB2ZGV2
LT5udW1fY3R4KQ0KPiAtCQlyZXR1cm4gTlVMTDsNCj4gLQlyZXR1cm4gJnZkZXYtPmN0eFtpbmRl
eF07DQo+ICsJcmV0dXJuIHhhX2xvYWQoJnZkZXYtPmN0eCwgaW5kZXgpOw0KPiAgfQ0KPiANCj4g
IHN0YXRpYyB2b2lkIHZmaW9faXJxX2N0eF9mcmVlX2FsbChzdHJ1Y3QgdmZpb19wY2lfY29yZV9k
ZXZpY2UgKnZkZXYpICB7DQo+IC0Ja2ZyZWUodmRldi0+Y3R4KTsNCj4gKwlzdHJ1Y3QgdmZpb19w
Y2lfaXJxX2N0eCAqY3R4Ow0KPiArCXVuc2lnbmVkIGxvbmcgaW5kZXg7DQo+ICsNCj4gKwl4YV9m
b3JfZWFjaCgmdmRldi0+Y3R4LCBpbmRleCwgY3R4KSB7DQo+ICsJCXhhX2VyYXNlKCZ2ZGV2LT5j
dHgsIGluZGV4KTsNCj4gKwkJa2ZyZWUoY3R4KTsNCj4gKwl9DQo+ICt9DQo+ICsNCj4gK3N0YXRp
YyBzdHJ1Y3QgdmZpb19wY2lfaXJxX2N0eCAqDQo+ICt2ZmlvX2lycV9jdHhfYWxsb2Nfc2luZ2xl
KHN0cnVjdCB2ZmlvX3BjaV9jb3JlX2RldmljZSAqdmRldiwNCj4gKwkJCSAgdW5zaWduZWQgbG9u
ZyBpbmRleCkNCj4gK3sNCj4gKwlzdHJ1Y3QgdmZpb19wY2lfaXJxX2N0eCAqY3R4Ow0KPiArCWlu
dCByZXQ7DQo+ICsNCj4gKwljdHggPSBremFsbG9jKHNpemVvZigqY3R4KSwgR0ZQX0tFUk5FTF9B
Q0NPVU5UKTsNCj4gKwlpZiAoIWN0eCkNCj4gKwkJcmV0dXJuIE5VTEw7DQo+ICsNCj4gKwlyZXQg
PSB4YV9pbnNlcnQoJnZkZXYtPmN0eCwgaW5kZXgsIGN0eCwgR0ZQX0tFUk5FTF9BQ0NPVU5UKTsN
Cj4gKwlpZiAocmV0KSB7DQo+ICsJCWtmcmVlKGN0eCk7DQo+ICsJCXJldHVybiBOVUxMOw0KPiAr
CX0NCj4gKw0KPiArCXJldHVybiBjdHg7DQo+ICB9DQo+IA0KPiArLyogT25seSBjYWxsZWQgZHVy
aW5nIGluaXRpYWwgaW50ZXJydXB0IGVuYWJsaW5nLiBOZXZlciBhZnRlci4gICovDQo+ICBzdGF0
aWMgaW50IHZmaW9faXJxX2N0eF9hbGxvY19udW0oc3RydWN0IHZmaW9fcGNpX2NvcmVfZGV2aWNl
ICp2ZGV2LA0KPiAgCQkJCSAgdW5zaWduZWQgbG9uZyBudW0pDQo+ICB7DQo+IC0JdmRldi0+Y3R4
ID0ga2NhbGxvYyhudW0sIHNpemVvZihzdHJ1Y3QgdmZpb19wY2lfaXJxX2N0eCksDQo+IC0JCQkg
ICAgR0ZQX0tFUk5FTF9BQ0NPVU5UKTsNCj4gLQlpZiAoIXZkZXYtPmN0eCkNCj4gLQkJcmV0dXJu
IC1FTk9NRU07DQo+ICsJc3RydWN0IHZmaW9fcGNpX2lycV9jdHggKmN0eDsNCj4gKwl1bnNpZ25l
ZCBsb25nIGluZGV4Ow0KPiArDQo+ICsJV0FSTl9PTigheGFfZW1wdHkoJnZkZXYtPmN0eCkpOw0K
PiArDQo+ICsJZm9yIChpbmRleCA9IDA7IGluZGV4IDwgbnVtOyBpbmRleCsrKSB7DQo+ICsJCWN0
eCA9IHZmaW9faXJxX2N0eF9hbGxvY19zaW5nbGUodmRldiwgaW5kZXgpOw0KPiArCQlpZiAoIWN0
eCkNCj4gKwkJCWdvdG8gZXJyOw0KPiArCX0NCj4gDQo+ICAJcmV0dXJuIDA7DQo+ICsNCj4gK2Vy
cjoNCj4gKwl2ZmlvX2lycV9jdHhfZnJlZV9hbGwodmRldik7DQo+ICsJcmV0dXJuIC1FTk9NRU07
DQo+ICB9DQo+IA0KPiAgLyoNCj4gQEAgLTIxOCw3ICsyNTMsNiBAQCBzdGF0aWMgaXJxcmV0dXJu
X3QgdmZpb19pbnR4X2hhbmRsZXIoaW50IGlycSwgdm9pZCAqZGV2X2lkKQ0KPiBzdGF0aWMgaW50
IHZmaW9faW50eF9lbmFibGUoc3RydWN0IHZmaW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2KSAgew0K
PiAgCXN0cnVjdCB2ZmlvX3BjaV9pcnFfY3R4ICpjdHg7DQo+IC0JaW50IHJldDsNCj4gDQo+ICAJ
aWYgKCFpc19pcnFfbm9uZSh2ZGV2KSkNCj4gIAkJcmV0dXJuIC1FSU5WQUw7DQo+IEBAIC0yMjYs
MTUgKzI2MCw5IEBAIHN0YXRpYyBpbnQgdmZpb19pbnR4X2VuYWJsZShzdHJ1Y3QgdmZpb19wY2lf
Y29yZV9kZXZpY2UNCj4gKnZkZXYpDQo+ICAJaWYgKCF2ZGV2LT5wZGV2LT5pcnEpDQo+ICAJCXJl
dHVybiAtRU5PREVWOw0KPiANCj4gLQlyZXQgPSB2ZmlvX2lycV9jdHhfYWxsb2NfbnVtKHZkZXYs
IDEpOw0KPiAtCWlmIChyZXQpDQo+IC0JCXJldHVybiByZXQ7DQo+IC0NCj4gLQljdHggPSB2Zmlv
X2lycV9jdHhfZ2V0KHZkZXYsIDApOw0KPiAtCWlmICghY3R4KSB7DQo+IC0JCXZmaW9faXJxX2N0
eF9mcmVlX2FsbCh2ZGV2KTsNCj4gLQkJcmV0dXJuIC1FSU5WQUw7DQo+IC0JfQ0KPiArCWN0eCA9
IHZmaW9faXJxX2N0eF9hbGxvY19zaW5nbGUodmRldiwgMCk7DQo+ICsJaWYgKCFjdHgpDQo+ICsJ
CXJldHVybiAtRU5PTUVNOw0KPiANCj4gIAl2ZGV2LT5udW1fY3R4ID0gMTsNCj4gDQo+IEBAIC00
ODYsMTYgKzUxNCwxMyBAQCBzdGF0aWMgdm9pZCB2ZmlvX21zaV9kaXNhYmxlKHN0cnVjdA0KPiB2
ZmlvX3BjaV9jb3JlX2RldmljZSAqdmRldiwgYm9vbCBtc2l4KSAgew0KPiAgCXN0cnVjdCBwY2lf
ZGV2ICpwZGV2ID0gdmRldi0+cGRldjsNCj4gIAlzdHJ1Y3QgdmZpb19wY2lfaXJxX2N0eCAqY3R4
Ow0KPiAtCXVuc2lnbmVkIGludCBpOw0KPiArCXVuc2lnbmVkIGxvbmcgaTsNCj4gIAl1MTYgY21k
Ow0KPiANCj4gLQlmb3IgKGkgPSAwOyBpIDwgdmRldi0+bnVtX2N0eDsgaSsrKSB7DQo+IC0JCWN0
eCA9IHZmaW9faXJxX2N0eF9nZXQodmRldiwgaSk7DQo+IC0JCWlmIChjdHgpIHsNCj4gLQkJCXZm
aW9fdmlycWZkX2Rpc2FibGUoJmN0eC0+dW5tYXNrKTsNCj4gLQkJCXZmaW9fdmlycWZkX2Rpc2Fi
bGUoJmN0eC0+bWFzayk7DQo+IC0JCQl2ZmlvX21zaV9zZXRfdmVjdG9yX3NpZ25hbCh2ZGV2LCBp
LCAtMSwgbXNpeCk7DQo+IC0JCX0NCj4gKwl4YV9mb3JfZWFjaCgmdmRldi0+Y3R4LCBpLCBjdHgp
IHsNCj4gKwkJdmZpb192aXJxZmRfZGlzYWJsZSgmY3R4LT51bm1hc2spOw0KPiArCQl2ZmlvX3Zp
cnFmZF9kaXNhYmxlKCZjdHgtPm1hc2spOw0KPiArCQl2ZmlvX21zaV9zZXRfdmVjdG9yX3NpZ25h
bCh2ZGV2LCBpLCAtMSwgbXNpeCk7DQo+ICAJfQ0KPiANCj4gIAljbWQgPSB2ZmlvX3BjaV9tZW1v
cnlfbG9ja19hbmRfZW5hYmxlKHZkZXYpOw0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC92
ZmlvX3BjaV9jb3JlLmggYi9pbmNsdWRlL2xpbnV4L3ZmaW9fcGNpX2NvcmUuaCBpbmRleA0KPiAz
NjdmZDc5MjI2YTMuLjYxZDc4NzNhMzk3MyAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC92
ZmlvX3BjaV9jb3JlLmgNCj4gKysrIGIvaW5jbHVkZS9saW51eC92ZmlvX3BjaV9jb3JlLmgNCj4g
QEAgLTU5LDcgKzU5LDcgQEAgc3RydWN0IHZmaW9fcGNpX2NvcmVfZGV2aWNlIHsNCj4gIAlzdHJ1
Y3QgcGVybV9iaXRzCSptc2lfcGVybTsNCj4gIAlzcGlubG9ja190CQlpcnFsb2NrOw0KPiAgCXN0
cnVjdCBtdXRleAkJaWdhdGU7DQo+IC0Jc3RydWN0IHZmaW9fcGNpX2lycV9jdHgJKmN0eDsNCj4g
KwlzdHJ1Y3QgeGFycmF5CQljdHg7DQo+ICAJaW50CQkJbnVtX2N0eDsNCj4gIAlpbnQJCQlpcnFf
dHlwZTsNCj4gIAlpbnQJCQludW1fcmVnaW9uczsNCj4gLS0NCj4gMi4zNC4xDQoNCg==
