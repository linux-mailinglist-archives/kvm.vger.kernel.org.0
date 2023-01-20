Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C0B674B9B
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 06:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjATFDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 00:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjATFDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 00:03:03 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903AFBFF49
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 20:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674190230; x=1705726230;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VcAMRIbFkUAjc6vDnnE/p6urW/ROmJ11A8oystQEg+E=;
  b=RbmJIWg9yZC/Rdt47krY3H7tniMlW6mskv2y06tha7pudYMIc3Nq2Zdi
   1e9fsT/sBGJhdMs0eC9rpQQ2beIDDzBlunhF8uIF2z03Xt5Mi9nhKWMpA
   KQ8sra1NjZspnF7GwjfdYj+tFDg5F09rEB13/8rVyRNB0wEQtSB1fcC86
   wTOMycbLWH6WzHCa/F4M2af0+n1GRtbCDSHj6VypjNrarCUmEbUEm/uZB
   +s8+raN2yxcdo8fvm3p2a3+d4Ttgg2YIemFFanQkKPe+SlmN1hlkJq9V1
   sjRDaY+E/Bxq2pTAPUoOHdfRaosjHTLdO4U0O2EVpkw83WfXRMZqsrcI7
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="309076839"
X-IronPort-AV: E=Sophos;i="5.97,231,1669104000"; 
   d="scan'208";a="309076839"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 19:52:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="728987303"
X-IronPort-AV: E=Sophos;i="5.97,231,1669104000"; 
   d="scan'208";a="728987303"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 19 Jan 2023 19:52:51 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 19:52:50 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 19:52:50 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 19:52:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lmf6vbqgTDhux5z23qV7zDBJh2Camf8gIMSf71YqxAaqYAa6ucZ8lTrP6l/2tpktfGHvBR+3EsHTO0v6NWJnElRnlviVQe9Rq0wFR8J6GDJGTHO7uHSAZOYVzKFjLf55xr5i3EbEVIgOb02Bf4yhZkeZtQtASZGCfajosMKmDU4wwY6Ey8iWVN4V4igsZ8A1Bcc3aToNZFaV5RAHprSdcCC5cYukJRJIPYylnFeY9ogGvDt9DTUr3C0JmYHO2u+x1+/Bxc0jDgJvf6EsYv0k6vxCRpzmlvq9DriJUGDGulka9amkmfeh3uCJsVq0ZE6KNH+bewTvrBPQ9byVbOJ1Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VcAMRIbFkUAjc6vDnnE/p6urW/ROmJ11A8oystQEg+E=;
 b=T6luvxB+xIFkaqJfqfbZ3RmkO+jrg6g1YcNbA6+jUPl1lfr1vvg8gqo/G8rT6jH1j1H6+CDAr/ZoRRgSJJGcks2Gq2m+mQPKWe8CqATZ3j+sLz7BfrQ87yBRj2W6CkD203UvuL2Qeg/niB/rSS4b6cmJGKI/zrJqKH/UpgdWW9L3059tMYBIYKxFQBKH4YHo5T5AzJIubp+TdUnOExHPrDEQgloHUvU9bQFOgP23G3n/3/Wpu9cqsi00xxD4sqPnNlEPvA7ehIRwFjTku4k2bU/+7e00YNaoL+BRrE1jp6JaVtqMQPbWAdJgH1jkpPFeY05y0jqm1WAMRwHreJQmhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA0PR11MB7863.namprd11.prod.outlook.com (2603:10b6:208:40c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Fri, 20 Jan
 2023 03:52:47 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6002.027; Fri, 20 Jan 2023
 03:52:47 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Subject: RE: [PATCH 05/13] kvm/vfio: Provide struct kvm_device_ops::release()
 insted of ::destroy()
Thread-Topic: [PATCH 05/13] kvm/vfio: Provide struct kvm_device_ops::release()
 insted of ::destroy()
Thread-Index: AQHZKnqZqWxc/vWNRUWu7aJW7tOztq6ld1sAgAAFAgCAATKF8A==
Date:   Fri, 20 Jan 2023 03:52:46 +0000
Message-ID: <DS0PR11MB7529D6A743D177A1EEA670B6C3C59@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-6-yi.l.liu@intel.com>
 <184d793d-8bef-c8e5-40fe-14491533f63b@redhat.com>
 <BN9PR11MB527688E2DD813CC92489EAA38CC49@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB527688E2DD813CC92489EAA38CC49@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA0PR11MB7863:EE_
x-ms-office365-filtering-correlation-id: f9de4312-c004-4302-9b25-08dafa99cb13
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vn5yQj+5KgF/gNLib8w4iWNA4Ogtt5S9811LppSnT+TBTQqBuo2r7ekIQisVky6IjPeZ6vecCLhwYfgLu3Tp6UK2tO+BaPHPwIjdfAjLQThmZEfb84pQlnp+1SLp6450CUZ2kzLcdYP5XCG6zqmwPTQkWpELt9yllan0F41BqGtoV9FfP6SukYgtnzVzXS1+U+M4ydJH/v0qNzb+oXIy4GtE3feokRKHHAZWSwm4iLXRaoG/t9tRurT1A7qEERoI6e2qtQH/3jlALMd8wuZpEcJooY7hvZQnBWURv/95SRljyAeL/wo/sSOB6z/XgrPFmgN48/P0lRQPZzD4THhWmc9l2Mzksbu5OmnpcmROjP3SbFgekFBnNgGAt+cqZL1c5x/DwaFeqy2hY+jobXUgFNBkwXwiz0C1H1bLx4IrkFNpQkppNkBvbIjq88dBbRyHCY5zPS6/hynSseGZFU6Fn4/UsqU1mNkoLUvXAPGiTpnsCZqqAHu88NMlCxCC+JvkohZMb+4ubVoD2VhXADIFjzd55RLVqr92gUxZSjaEFenBrIXZ2AhievIGMlS3XR2L+5oL13DlO7dzdz3UJ+5PTvd2nnPdgpceER94b8VxUxk/7HV3dd8+jkS2Xnvi5nxgsQURFClgSk4CTjV99hn088GzPjXN8IDUi1VBcpdquHSM38K7Gp9d0v5LIOHgqN7yZItsiFMZ7/k98lNsBkQ/wg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(136003)(346002)(39860400002)(366004)(451199015)(8936002)(316002)(122000001)(5660300002)(52536014)(71200400001)(33656002)(7696005)(86362001)(478600001)(53546011)(6506007)(2906002)(54906003)(110136005)(55016003)(83380400001)(38070700005)(7416002)(66556008)(66476007)(66946007)(66446008)(8676002)(64756008)(82960400001)(4326008)(26005)(38100700002)(186003)(9686003)(76116006)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0gyMWVjV1o3UWtrQmgrSXVOaEErS0NCQ2hRZzNSeXN0TGhxcU5LMlNUUTZJ?=
 =?utf-8?B?RjFlUDZLRG5MZW16NnRGSlY4TmJTa3BnRWhpUHhOdlB3QmdTY0tVOWJYblFi?=
 =?utf-8?B?NStRaG9qZlBGdHQ2ZDRlWW14TVRwZ1h4SVpoS1dUa1BsL1c2aFQ3Y2FVRUNw?=
 =?utf-8?B?L3BKTDNlTTRLWGxBaFVMMnNMbSs0b1dGM282TStKZFlhR3dJeWs1bCtwcWd6?=
 =?utf-8?B?OTFBcnZ6T0tiQXBDeEljRVVnb2Vlb1V6VWV1UVhxNC9MVjlUTVU3TERzMVlT?=
 =?utf-8?B?QU5JczM2WTlONlR4aWRDZE5mc3lKb2hCcERXV1ZXN3ZBNjRIdEhxd2FJeWk1?=
 =?utf-8?B?MzhvTWx3R1hyOUphRnZiZklydk82TTlDc01vZHBkN0ladTVMTCtvb1ByckNq?=
 =?utf-8?B?bS9BZ3E2dE9NM1QwVTZXK2VINjFxMkg2M0xXN2w0cDdXVmN2WThpdGJnd1Uz?=
 =?utf-8?B?TVJaaTNBK3hNeEhEdHRQcDg1VnExZzc5RG9rNjk1djBFbURIdnRpT3pvL21j?=
 =?utf-8?B?Mk1yK3VTSnNpK3U3aVRPMlJJZkppUlNiazRSY2ZrQ1kwNFlmc2Rwb09FNlNM?=
 =?utf-8?B?dHBqUGF4djRsVzBXZ3oyZ3JpVVN2RUhuaHNURDFNTjNPdERtTFlpdU9uY1hW?=
 =?utf-8?B?eFR0WEErbkJzc29mT2VIOXNCNkMyekgzQ1ZjeDJxaHFNd1dia1Y0U0I4bzdL?=
 =?utf-8?B?N3dJVnJpNExTVUZaQjdJK2VIWUtsR0FnTjJmbStkanR5c3Rnc3VraFRpcEl3?=
 =?utf-8?B?K1dhL1o5SGI1RGVMYkNoZGYrTHMyeDlHbEZtMkJFN3p3NHNVS2dJVVBWUVRm?=
 =?utf-8?B?OWZPaVdrbkFXUlgxbUpuVDcyQnhkTTRybmRrS2tHdlNtQVhBTjMzRDR6Skww?=
 =?utf-8?B?enpIdnphRk9pVzBIdTJCcitaM3NLSG1ONjZubFFrcDA5dVBla21TUlRGc3Ro?=
 =?utf-8?B?RjdoTWx0akRPdjR5SVVFOUJrOVZVenRJTnM2QVBOWDdZcXNIaHBKVWh6UGFJ?=
 =?utf-8?B?WktVYXVEWXZ6UnBIK2drckNPa2w0SDVmS3JtUzB2dk55WXZtR01HcVJjN1JB?=
 =?utf-8?B?SjZaU2JIQ0hJUENRNlEzYy85V0F4TWpUUWFDR2VNS3FVNkZGNVZIYlZRajk2?=
 =?utf-8?B?VllTVHpmRDMyZUlnT1hqeUdHNWdaSk1sK3djYmZyYy9qSm1velNjUW1wbjE3?=
 =?utf-8?B?Rk9wWjVUTzRhdnR4MEhvMmxpY3VHM0syRXlaRjNob3hxT2xCclpNVWlyVmE0?=
 =?utf-8?B?UlcrZFkySjlZWTMxVGdRWEk3WmNYM2pNR1o5YWhLM0FKZUMzSjY3cUl3MlpN?=
 =?utf-8?B?bVhQNHAzTFo4aWx0a0FBdmVTNVNVVnpBVlVMVDgrYTFqVzFiaUN5OTBXdDJy?=
 =?utf-8?B?WWhUSENEKzVJMDZzM28xcHQwSlhwTnNJbWhOMVQ0RUw3RGdlcDd5eG5hT3Rt?=
 =?utf-8?B?VmlYMXhNT3lzanBjS0ZlekFpK0xVTERkallXeng2djhRb2x1L2FoYXpXMVpL?=
 =?utf-8?B?Y3JiQ0tYejIrVEFUSjJpcFppMGJZT2dsRlBYdktzWHpCeGdINzBXL0dPdFQ5?=
 =?utf-8?B?V3lWbmhHUnh5WGpabDBUQzVtZlNCUUFhemNWYjEyaGdXa2dHajlwRWFJbHh6?=
 =?utf-8?B?STZMNnhyZ3R1WEhuaVJkNnFmS0doTmlJUjJTZTlIS1JhWlljREhDN0JNN3Q4?=
 =?utf-8?B?YnB4NEsyOU9IRk9LSDNHQkN5Rlg0L0QxTmF0cUJKb1V2a2RRTUtnclk5U0ht?=
 =?utf-8?B?alJNR2dLck40Q2U4YWVxVnI3SE1Kek9PNUM0REpoRTZBNVIwUUxVaFlLWUZL?=
 =?utf-8?B?cExaTDR0WmNJMWowTkdqamNLcTdpZEhmT0ZLSy9BRUJvS3FmZmd0eG9QSU8v?=
 =?utf-8?B?WDdoTEx0WWdhaERMYjZrdlBHeVgvY1hucVFhbHltN05rbkQ4dzFMUkd0SVdw?=
 =?utf-8?B?V0lMSFFSNUl5cm9BV050Tmdob1JIUGNXMURSMlRvaE9ZMW8vWFlaeVFiRGFh?=
 =?utf-8?B?M251ZnlUVlREVjR2WmdhOTJ4NkMzQWxWSS9WWWxMZTR3TlNSdVh0akdvMWZC?=
 =?utf-8?B?dk5DVnVXdHhjbUxoVTFHekZKd3I4bStBaWs2V0RycEc0VWpSNUxkV3ZqTVQ0?=
 =?utf-8?Q?JSQl5w7IDYHxRlr1sp8a/FOcA?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9de4312-c004-4302-9b25-08dafa99cb13
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 03:52:46.9721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YOGHaRRjYAbO1yi4QDQeSYqYE7ueM333qEk+4+wChcdPf8MU2r7SmG44mmk/6k552ANHMzPUzwcewcykmgYRjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7863
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IFRodXJz
ZGF5LCBKYW51YXJ5IDE5LCAyMDIzIDU6MzAgUE0NCj4gDQo+ID4gRnJvbTogRXJpYyBBdWdlciA8
ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiA+IFNlbnQ6IFRodXJzZGF5LCBKYW51YXJ5IDE5LCAy
MDIzIDU6MTMgUE0NCj4gPg0KPiA+IEhpIFlpLA0KPiA+DQo+ID4gT24gMS8xNy8yMyAxNDo0OSwg
WWkgTGl1IHdyb3RlOg0KPiA+ID4gVGhpcyBpcyB0byBhdm9pZCBhIGNpcmN1bGFyIHJlZmNvdW50
IHByb2JsZW0gYmV0d2VlbiB0aGUga3ZtIHN0cnVjdCBhbmQNCj4gPiA+IHRoZSBkZXZpY2UgZmls
ZS4gS1ZNIG1vZHVsZXMgaG9sZHMgZGV2aWNlL2dyb3VwIGZpbGUgcmVmZXJlbmNlIHdoZW4NCj4g
dGhlDQo+ID4gPiBkZXZpY2UvZ3JvdXAgaXMgYWRkZWQgYW5kIHJlbGVhc2VzIGl0IHBlciByZW1v
dmFsIG9yIHRoZSBsYXN0IGt2bQ0KPiByZWZlcmVuY2UNCj4gPiA+IGlzIHJlbGVhc2VkLiBUaGlz
IHJlZmVyZW5jZSBtb2RlbCBpcyBvayBmb3IgdGhlIGdyb3VwIHNpbmNlIHRoZXJlIGlzIG5vDQo+
ID4gPiBrdm0gcmVmZXJlbmNlIGluIHRoZSBncm91cCBwYXRocy4NCj4gPiA+DQo+ID4gPiBCdXQg
aXQgaXMgYSBwcm9ibGVtIGZvciBkZXZpY2UgZmlsZSBzaW5jZSB0aGUgdmZpbyBkZXZpY2VzIG1h
eSBnZXQga3ZtDQo+ID4gPiByZWZlcmVuY2UgaW4gdGhlIGRldmljZSBvcGVuIHBhdGggYW5kIHB1
dCBpdCBpbiB0aGUgZGV2aWNlIGZpbGUgcmVsZWFzZS4NCj4gPiA+IGUuZy4gSW50ZWwga3ZtZ3Qu
IFRoaXMgd291bGQgcmVzdWx0IGluIGEgY2lyY3VsYXIgaXNzdWUgc2luY2UgdGhlIGt2bQ0KPiA+
ID4gc2lkZSB3b24ndCBwdXQgdGhlIGRldmljZSBmaWxlIHJlZmVyZW5jZSBpZiBrdm0gcmVmZXJl
bmNlIGlzIG5vdCAwLCB3aGlsZQ0KPiA+ID4gdGhlIHZmaW8gZGV2aWNlIHNpZGUgbmVlZHMgdG8g
cHV0IGt2bSByZWZlcmVuY2UgaW4gdGhlIHJlbGVhc2UgY2FsbGJhY2suDQo+ID4gPg0KPiA+ID4g
VG8gc29sdmUgdGhpcyBwcm9ibGVtIGZvciBkZXZpY2UgZmlsZSwgbGV0IHZmaW8gcHJvdmlkZSBy
ZWxlYXNlKCkgd2hpY2gNCj4gPiA+IHdvdWxkIGJlIGNhbGxlZCBvbmNlIGt2bSBmaWxlIGlzIGNs
b3NlZCwgaXQgd29uJ3QgZGVwZW5kIG9uIHRoZSBsYXN0IGt2bQ0KPiA+ID4gcmVmZXJlbmNlLiBI
ZW5jZSBhdm9pZCBjaXJjdWxhciByZWZjb3VudCBwcm9ibGVtLg0KPiA+ID4NCj4gPiA+IFN1Z2dl
c3RlZC1ieTogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ID4gPiBTaWduZWQt
b2ZmLWJ5OiBZaSBMaXUgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIHZp
cnQva3ZtL3ZmaW8uYyB8IDIgKy0NCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KyksIDEgZGVsZXRpb24oLSkNCj4gPiA+DQo+ID4gPiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0vdmZp
by5jIGIvdmlydC9rdm0vdmZpby5jDQo+ID4gPiBpbmRleCAwZjU0YjlkMzA4ZDcuLjUyNWVmZTM3
YWI2ZCAxMDA2NDQNCj4gPiA+IC0tLSBhL3ZpcnQva3ZtL3ZmaW8uYw0KPiA+ID4gKysrIGIvdmly
dC9rdm0vdmZpby5jDQo+ID4gPiBAQCAtMzY0LDcgKzM2NCw3IEBAIHN0YXRpYyBpbnQga3ZtX3Zm
aW9fY3JlYXRlKHN0cnVjdCBrdm1fZGV2aWNlDQo+ICpkZXYsDQo+ID4gdTMyIHR5cGUpOw0KPiA+
ID4gIHN0YXRpYyBzdHJ1Y3Qga3ZtX2RldmljZV9vcHMga3ZtX3ZmaW9fb3BzID0gew0KPiA+ID4g
IAkubmFtZSA9ICJrdm0tdmZpbyIsDQo+ID4gPiAgCS5jcmVhdGUgPSBrdm1fdmZpb19jcmVhdGUs
DQo+ID4gPiAtCS5kZXN0cm95ID0ga3ZtX3ZmaW9fZGVzdHJveSwNCj4gPiBJcyBpdCBzYWZlIHRv
IHNpbXBseSByZW1vdmUgdGhlIGRlc3Ryb3kgY2IgYXMgaXQgaXMgY2FsbGVkIGZyb20NCj4gPiBr
dm1fZGVzdHJveV92bS9rdm1fZGVzdHJveV9kZXZpY2VzPw0KPiA+DQoNClBlcmhhcHMgYmV0dGVy
IHRvIGtlZXAgaXQuIGt2bV92ZmlvX2RldmljZSBpcyBvbmx5IG9uZSBraW5kIG9mIGt2bV9kZXZp
Y2VfdHlwZQ0KRm9yIGt2bV92ZmlvX2RldmljZSwgaXQgaXMgbm93IGNvbnNpZGVyZWQgdG8gYmV0
dGVyIHByb3ZpZGUgYSByZWxlYXNlIGNiLg0KV2hpbGUgb3RoZXIga3ZtX2RldmljZSBtYXkgYmV0
dGVyIHRvIGhhdmUgZGVzdHJveSBjYi4NCg0KPiANCj4gQWNjb3JkaW5nIHRvIHRoZSBkZWZpbml0
aW9uIC5yZWxlYXNlIGlzIGNvbnNpZGVyZWQgYXMgYW4gYWx0ZXJuYXRpdmUNCj4gbWV0aG9kIHRv
IGZyZWUgdGhlIGRldmljZToNCj4gDQo+IAkvKg0KPiAJICogRGVzdHJveSBpcyByZXNwb25zaWJs
ZSBmb3IgZnJlZWluZyBkZXYuDQo+IAkgKg0KPiAJICogRGVzdHJveSBtYXkgYmUgY2FsbGVkIGJl
Zm9yZSBvciBhZnRlciBkZXN0cnVjdG9ycyBhcmUgY2FsbGVkDQo+IAkgKiBvbiBlbXVsYXRlZCBJ
L08gcmVnaW9ucywgZGVwZW5kaW5nIG9uIHdoZXRoZXIgYSByZWZlcmVuY2UgaXMNCj4gCSAqIGhl
bGQgYnkgYSB2Y3B1IG9yIG90aGVyIGt2bSBjb21wb25lbnQgdGhhdCBnZXRzIGRlc3Ryb3llZA0K
PiAJICogYWZ0ZXIgdGhlIGVtdWxhdGVkIEkvTy4NCj4gCSAqLw0KPiAJdm9pZCAoKmRlc3Ryb3kp
KHN0cnVjdCBrdm1fZGV2aWNlICpkZXYpOw0KPiANCj4gCS8qDQo+IAkgKiBSZWxlYXNlIGlzIGFu
IGFsdGVybmF0aXZlIG1ldGhvZCB0byBmcmVlIHRoZSBkZXZpY2UuIEl0IGlzDQo+IAkgKiBjYWxs
ZWQgd2hlbiB0aGUgZGV2aWNlIGZpbGUgZGVzY3JpcHRvciBpcyBjbG9zZWQuIE9uY2UNCj4gCSAq
IHJlbGVhc2UgaXMgY2FsbGVkLCB0aGUgZGVzdHJveSBtZXRob2Qgd2lsbCBub3QgYmUgY2FsbGVk
DQo+IAkgKiBhbnltb3JlIGFzIHRoZSBkZXZpY2UgaXMgcmVtb3ZlZCBmcm9tIHRoZSBkZXZpY2Ug
bGlzdCBvZg0KPiAJICogdGhlIFZNLiBrdm0tPmxvY2sgaXMgaGVsZC4NCj4gCSAqLw0KPiAJdm9p
ZCAoKnJlbGVhc2UpKHN0cnVjdCBrdm1fZGV2aWNlICpkZXYpOw0KPiANCj4gRGlkIHlvdSBzZWUg
YW55IHNwZWNpZmljIHByb2JsZW0gb2YgbW92aW5nIHRoaXMgc3R1ZmYgdG8gcmVsZWFzZT8NCg0K
SXQgc2hvdWxkIG9ubHkgYWZmZWN0IGt2bV92ZmlvX2RldmljZSBpdHNlbGYuIPCfmIoNCg0KUmVn
YXJkcywNCllpIExpdQ0KDQo=
