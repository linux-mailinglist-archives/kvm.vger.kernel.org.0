Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16052673474
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 10:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjASJbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 04:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjASJan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 04:30:43 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC8E6B985
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 01:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674120629; x=1705656629;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xA86yOvFxrx1Y1be4ahPcBnatO3E9DEqwhLG5SE1N9g=;
  b=fxbliU3w7ptO4UOwfGDI8URQpV/Ww5ol97GefjfnsLajwvyaTOw7+oD9
   PySPyjUGwYZyc14c6FRIKLlPIedGESze1AmWldJgPlREctrnKbNLW1Hty
   XA0a3ePijmBV14OBW5P9rGUAW7FCeUhdQwU9LHjMFyBIR8qeCNyaY8OgJ
   kw1hy8M8X+mE2qwnEWj7Oc+WWNdWM5J4AJXyzktck4mkMV/SlNGdjQtO3
   +SbMNMAEgpgYue+4u1crWw16M5P759dGWwAakRyvafsSooppj53rsY4lu
   IDt7+gd22AOQF2gqKVu4HEkFjZOKyc/NY5WF0een45Uvl2+mk8gMYFuTh
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="304923493"
X-IronPort-AV: E=Sophos;i="5.97,228,1669104000"; 
   d="scan'208";a="304923493"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 01:30:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="653295314"
X-IronPort-AV: E=Sophos;i="5.97,228,1669104000"; 
   d="scan'208";a="653295314"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 19 Jan 2023 01:30:28 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 01:30:28 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 01:30:28 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 01:30:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyg5AQmaWbjqnU59QhfKSAJl72ocd7/RaJ8ZZvqroCs6+XNzE2qNiOZh98vnM6RAImD8424SEXgh6BSw8ZzMQ16FIsd+XtWmwEm6kmuXnta4IKvxeWxOgRitrvtKEwNWdhTQmHzEWyjG3wd+TtY01LXLRJpA2y2v6gKhloDunMeB87jCOye9HdgyUYDTG1dZYLzmf8n/6QTeGkvcHTKIxPsicOj4sN0QvUhVk69Fcls9frmpxdshWTMfn343Fn5SvVeyYyhLCn5n6TqKOav61CWkYRbu4lx6km6TNVSfyS2anYaECRKMTkqCix+9nqOf83fgsQGaxDQkD6rg/BloRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xA86yOvFxrx1Y1be4ahPcBnatO3E9DEqwhLG5SE1N9g=;
 b=BnnD10TYBTDOC6VeeVVihTNB2n7y+QLdRWcwuLvE+NZmOm/zR1r3GzN/teNSfV+Mhvx7MP638Moy45YYQZJzNdF+nq2K/Lpv6Xs4s0z/9DSxbtdNOzt/vZuOuWnUX9Isl6ixJtXdMUgApc4YDtfFBr+32RK2qJvaEbhoUR56qZcG2/cMSU19aKWvGWV4aZqNtmVi/0i5zyY1XyHh5xUGaJIzmJL3Ozph0htXaQ3SN88e8OcqiOEjLgo+4ztnQkhXEA0sH6HACKCtnYyveSZ3G7kaLSRawCZTJWD72ARsS2dc6MA14yFr1tR7FztgiKJ2ITmcm3svynyjdgNLrbBo3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5581.namprd11.prod.outlook.com (2603:10b6:a03:305::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 09:30:26 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6002.025; Thu, 19 Jan 2023
 09:30:26 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
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
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 05/13] kvm/vfio: Provide struct kvm_device_ops::release()
 insted of ::destroy()
Thread-Topic: [PATCH 05/13] kvm/vfio: Provide struct kvm_device_ops::release()
 insted of ::destroy()
Thread-Index: AQHZKnqZYiHu50d0v0+W2V8FfMRkea6ld1sAgAAD3cA=
Date:   Thu, 19 Jan 2023 09:30:26 +0000
Message-ID: <BN9PR11MB527688E2DD813CC92489EAA38CC49@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-6-yi.l.liu@intel.com>
 <184d793d-8bef-c8e5-40fe-14491533f63b@redhat.com>
In-Reply-To: <184d793d-8bef-c8e5-40fe-14491533f63b@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5581:EE_
x-ms-office365-filtering-correlation-id: 7cc6cc29-224f-4359-f433-08daf9ffcc48
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wxWEkMjtjL7aYE0GxKs8nhzlPYSG08fLTuxwyFusRAUcEl9qFym5fRRbZTfw95tyj5UFKmJM2ls84GQFGdTXKpROJ6qZ2qyH9L+pXi3o7gej5B4YDiwVGicQzzTOXGh7E6aVojqj1Lq5gaYGq4S9DS5Jqbk0/yaxz+hNStHjam6FtEF1XLo24sI/RTuRqgn4oMXd0fEqXuiwOMtu8PCijf4/YO1fwxx3Tw1CQxMYStNVBT5iP1K/Z2CUUHgiDPW+uUmWgof33D8OWqcF/7hTYhJRLTTDE2Hsz8WaAXWFratYu36whu06SIITJYycXi8KTXMsPFwLlBquGCAGkFTrk2KYqyYGZS092Vl7qklh94hwXPs7Oqwbj0nRbREqiYB68YX1IfgiqOdV/gCX8guDIOI28YOS000WfGew6hg/bnFRt/CZL6Nz4DA2HQKlwodx+DhA/OrEtcmlsoaNBCizBLph7xZrRja9KaUPJd1rq+0LfqsC6K2um93jY/H468Xx/eSvLYYA57Ur8DTtkXURiJ4QUjVEGkwJKZSrPoiNbh1rE9tPf8+dAlrW9Dqqy+mJGn+mxRgxvl76nbAjPU/x6sFrT2mJkU3rjSjT76vVYLBjSZdlbLBwhRMybE1d9kYTsVIWb8hu9CiQ5aQgOWytPmBO4QRm4ZvYej34Xe8MVA55MBzlHWXPqplMrj7db3bxWa+QVhLd6gZ9adi80Zdy6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199015)(110136005)(316002)(41300700001)(54906003)(64756008)(66446008)(71200400001)(66476007)(33656002)(76116006)(8676002)(86362001)(83380400001)(66946007)(66556008)(38100700002)(82960400001)(38070700005)(55016003)(122000001)(478600001)(7696005)(9686003)(26005)(6506007)(53546011)(186003)(2906002)(4326008)(52536014)(5660300002)(8936002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RjBoaDBPRXNlQ254TFNCWTFsSnBVbndiUW94VnUvNE1wb2pCWUxJaXI0YzJN?=
 =?utf-8?B?bUsvZ0RnN3FhSXBXazBvOUcyWDRVbkNMeXdhS2FFK1V2MnBDaXU4TUpmQ01B?=
 =?utf-8?B?UGRjQ1ovaEhUeWlucnZNVGJralU2eHRZUi84QmNySkh3SW9LdklBZ3lESzB3?=
 =?utf-8?B?Wjllc1pnR0VhWGdPQUVBVWxzWkJqZExFR1Q0bGNieHNBSHdtbEZPZDNmbnln?=
 =?utf-8?B?N1ByanU1Mms5MEFIZFZEMGhmU1RkT3JTZTdrVnJsRjJKemJHUHRKZ3BOd21V?=
 =?utf-8?B?ZDNZR3lQQVBFOWxnbG50aGpteFpQaW5XcWl4bzJIdFdhakNYK2JDSlFmVkpO?=
 =?utf-8?B?ZFQ2bHROQTB5YTZGSWh4Skt5REYya1J5NXJ4Zng5ckdRYnQ5OVRUL0VrMWVq?=
 =?utf-8?B?b24xSS9KSnFabFM4d3FvYjh0SmR1ODVNdTZaeWh6eVNMT3YwRmc2RkV1OUdF?=
 =?utf-8?B?R1QrYUZVU0dqdlpESFd2QXE1dlhXb2RwMG5aY2JCZi8zYmU4Y2tKelF1NzNM?=
 =?utf-8?B?eWlTTFA1alF0YUw2d09VV3ZRc2dJMnRmQkxnK3pJUFI5Ym5xTGZBN2IrSnlO?=
 =?utf-8?B?VGVpSGFLbDBHSUk5Um5yKzdhcmpJSGNTOHBmdXN5WmV4c1o0Q2t5MzU3RHVq?=
 =?utf-8?B?ejRlbkljLy9iUWNzZ3F3YklPU3hyR2xsRWtGY3lldEtFU250bEpXY2Q1VnVX?=
 =?utf-8?B?NWRPdko0ZUtYTmU3NWJ0aUZWa0s5UTR0Rm43czdycXEvZjNrUVl1ZEVtN2tG?=
 =?utf-8?B?Rmo5RHR3b05wUTJBOWNPaWVGSE9XQkM3c0ZGZkFxc2pudHVPbXZDOVpOdUNZ?=
 =?utf-8?B?RFdZSXU0alhxUnQ5VndQZlByS3FtQUdWMkpiVFZZNFozTlhjYnFJaGVNcVZ0?=
 =?utf-8?B?eitFWUpqZ1NWdkNYc29YZHltQUhiVlk0dEU4YXUreVh5OEh0ZHlQZXBYRko3?=
 =?utf-8?B?ajZOTzdCMkdhOXY0NVdqQlFRaFJLNVRCN1hJV3VLbC83U2FHMHc0QWkyMWh6?=
 =?utf-8?B?QnIrZEVKUWg1UlpiL28wMkplc0VuZE42NTZiSmlzdVNObFEvd2NFUnd6emFo?=
 =?utf-8?B?ZlA1WVc1MFBBS3hxYmxxVXQwdnpNWTdIaUNqY2hqS09WUkNmTHZFR0JyWDRq?=
 =?utf-8?B?cnljdEdGS1c4UmdIZDh2Zmh2V01INmRoOFFIa1ZSWGJ4UWsvWWRWU2puSFFY?=
 =?utf-8?B?eUE4am5hTVAzOENFT2VDc0MrWWZ4TW1VMEpPRndYbTZzOFdWUFJ6V0pVanl2?=
 =?utf-8?B?cW5EcTZnU0JJb29zWStTM0FiQjkzbkdzdXorbXZkandabWhBL0VlZENGTUZJ?=
 =?utf-8?B?V3BSemJ4S05HWVR0YThDSlNhVmtUREZXN0krZ1Fpb0tka1g1S1hwekhjWXNY?=
 =?utf-8?B?Z0FKVS9SRkVmcTVzSEhNSGZVT2F5NGdHenF1WjVIa1lRNzhVQjZKZ0s3djFB?=
 =?utf-8?B?Q3dhY1I4TUYrQzJ2L0ZSUDJrekZRckV6SWthbVQ2amQyYlJxTlpVeS9VL1hP?=
 =?utf-8?B?cEhzUU1IQTBiOW5PRURnUE9OTFpaYkwxbWJwMGdpY3Rqd1AyZVR5Qm1sVGtG?=
 =?utf-8?B?QlByWTlpVFlsaGtXbUwzRVAwWWhYSGEwZUo3MjRiajkvYzdQL09iZ1ZLeGlr?=
 =?utf-8?B?R05pYm9RcW5yVzZseTVVMUhmbzdQWmttUTFyRS9vSmhPRjlRWS9iUG1TYWFw?=
 =?utf-8?B?SXlvWG9zYjU1U21uZFJxNno1OXg4d2tiVXRXOWc3VjJra2NlaWlialVIZVg3?=
 =?utf-8?B?U1h3WDJPb1dJYzJhNktid0Yrc3o4OEM2Wi95SU9haHdrTFBlU0JwQWgxRk9q?=
 =?utf-8?B?K3d0S1h4TFB2UktkNGJsRTdOS0hlUWliNThTWW1leDMweHQ0Nk9WbHc1VHVR?=
 =?utf-8?B?QXZKY3JvNEprZ1loeFBBQXg5Yzc5anVSL3NJZXNVL0lzUFU4YzFaQThvZjQv?=
 =?utf-8?B?bzY4bmlnN2V6WERkcm9tUkplUlBWazNETzdZSkJuN0ZKMkFid2FoNncxWndw?=
 =?utf-8?B?eFBvR3dPajY3aFNCS0dyMkhvVk00b2FDc0RCMG1WTDZmd1ZURFJHUXNGQkxV?=
 =?utf-8?B?UFJFbkxMaGpZQ09uSFRiZ215U3VFbDRvS0pqNlZqNzUrVU1GT1g5bGNCSGdh?=
 =?utf-8?Q?cM3rqdYG7Vv9Q/zDvjn9VGUwf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cc6cc29-224f-4359-f433-08daf9ffcc48
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 09:30:26.5031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8nmD4HtSuND9EehDJMVZITm9pgy/3Q84U+Oh+GIi9gRhzcEk28uZV+QMuVv9JH/eoQyvyBMNzpNEuUv0DNqlew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5581
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFRodXJz
ZGF5LCBKYW51YXJ5IDE5LCAyMDIzIDU6MTMgUE0NCj4gDQo+IEhpIFlpLA0KPiANCj4gT24gMS8x
Ny8yMyAxNDo0OSwgWWkgTGl1IHdyb3RlOg0KPiA+IFRoaXMgaXMgdG8gYXZvaWQgYSBjaXJjdWxh
ciByZWZjb3VudCBwcm9ibGVtIGJldHdlZW4gdGhlIGt2bSBzdHJ1Y3QgYW5kDQo+ID4gdGhlIGRl
dmljZSBmaWxlLiBLVk0gbW9kdWxlcyBob2xkcyBkZXZpY2UvZ3JvdXAgZmlsZSByZWZlcmVuY2Ug
d2hlbiB0aGUNCj4gPiBkZXZpY2UvZ3JvdXAgaXMgYWRkZWQgYW5kIHJlbGVhc2VzIGl0IHBlciBy
ZW1vdmFsIG9yIHRoZSBsYXN0IGt2bSByZWZlcmVuY2UNCj4gPiBpcyByZWxlYXNlZC4gVGhpcyBy
ZWZlcmVuY2UgbW9kZWwgaXMgb2sgZm9yIHRoZSBncm91cCBzaW5jZSB0aGVyZSBpcyBubw0KPiA+
IGt2bSByZWZlcmVuY2UgaW4gdGhlIGdyb3VwIHBhdGhzLg0KPiA+DQo+ID4gQnV0IGl0IGlzIGEg
cHJvYmxlbSBmb3IgZGV2aWNlIGZpbGUgc2luY2UgdGhlIHZmaW8gZGV2aWNlcyBtYXkgZ2V0IGt2
bQ0KPiA+IHJlZmVyZW5jZSBpbiB0aGUgZGV2aWNlIG9wZW4gcGF0aCBhbmQgcHV0IGl0IGluIHRo
ZSBkZXZpY2UgZmlsZSByZWxlYXNlLg0KPiA+IGUuZy4gSW50ZWwga3ZtZ3QuIFRoaXMgd291bGQg
cmVzdWx0IGluIGEgY2lyY3VsYXIgaXNzdWUgc2luY2UgdGhlIGt2bQ0KPiA+IHNpZGUgd29uJ3Qg
cHV0IHRoZSBkZXZpY2UgZmlsZSByZWZlcmVuY2UgaWYga3ZtIHJlZmVyZW5jZSBpcyBub3QgMCwg
d2hpbGUNCj4gPiB0aGUgdmZpbyBkZXZpY2Ugc2lkZSBuZWVkcyB0byBwdXQga3ZtIHJlZmVyZW5j
ZSBpbiB0aGUgcmVsZWFzZSBjYWxsYmFjay4NCj4gPg0KPiA+IFRvIHNvbHZlIHRoaXMgcHJvYmxl
bSBmb3IgZGV2aWNlIGZpbGUsIGxldCB2ZmlvIHByb3ZpZGUgcmVsZWFzZSgpIHdoaWNoDQo+ID4g
d291bGQgYmUgY2FsbGVkIG9uY2Uga3ZtIGZpbGUgaXMgY2xvc2VkLCBpdCB3b24ndCBkZXBlbmQg
b24gdGhlIGxhc3Qga3ZtDQo+ID4gcmVmZXJlbmNlLiBIZW5jZSBhdm9pZCBjaXJjdWxhciByZWZj
b3VudCBwcm9ibGVtLg0KPiA+DQo+ID4gU3VnZ2VzdGVkLWJ5OiBLZXZpbiBUaWFuIDxrZXZpbi50
aWFuQGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBZaSBMaXUgPHlpLmwubGl1QGludGVs
LmNvbT4NCj4gPiAtLS0NCj4gPiAgdmlydC9rdm0vdmZpby5jIHwgMiArLQ0KPiA+ICAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1n
aXQgYS92aXJ0L2t2bS92ZmlvLmMgYi92aXJ0L2t2bS92ZmlvLmMNCj4gPiBpbmRleCAwZjU0Yjlk
MzA4ZDcuLjUyNWVmZTM3YWI2ZCAxMDA2NDQNCj4gPiAtLS0gYS92aXJ0L2t2bS92ZmlvLmMNCj4g
PiArKysgYi92aXJ0L2t2bS92ZmlvLmMNCj4gPiBAQCAtMzY0LDcgKzM2NCw3IEBAIHN0YXRpYyBp
bnQga3ZtX3ZmaW9fY3JlYXRlKHN0cnVjdCBrdm1fZGV2aWNlICpkZXYsDQo+IHUzMiB0eXBlKTsN
Cj4gPiAgc3RhdGljIHN0cnVjdCBrdm1fZGV2aWNlX29wcyBrdm1fdmZpb19vcHMgPSB7DQo+ID4g
IAkubmFtZSA9ICJrdm0tdmZpbyIsDQo+ID4gIAkuY3JlYXRlID0ga3ZtX3ZmaW9fY3JlYXRlLA0K
PiA+IC0JLmRlc3Ryb3kgPSBrdm1fdmZpb19kZXN0cm95LA0KPiBJcyBpdCBzYWZlIHRvIHNpbXBs
eSByZW1vdmUgdGhlIGRlc3Ryb3kgY2IgYXMgaXQgaXMgY2FsbGVkIGZyb20NCj4ga3ZtX2Rlc3Ry
b3lfdm0va3ZtX2Rlc3Ryb3lfZGV2aWNlcz8NCj4gDQoNCkFjY29yZGluZyB0byB0aGUgZGVmaW5p
dGlvbiAucmVsZWFzZSBpcyBjb25zaWRlcmVkIGFzIGFuIGFsdGVybmF0aXZlDQptZXRob2QgdG8g
ZnJlZSB0aGUgZGV2aWNlOg0KDQoJLyoNCgkgKiBEZXN0cm95IGlzIHJlc3BvbnNpYmxlIGZvciBm
cmVlaW5nIGRldi4NCgkgKg0KCSAqIERlc3Ryb3kgbWF5IGJlIGNhbGxlZCBiZWZvcmUgb3IgYWZ0
ZXIgZGVzdHJ1Y3RvcnMgYXJlIGNhbGxlZA0KCSAqIG9uIGVtdWxhdGVkIEkvTyByZWdpb25zLCBk
ZXBlbmRpbmcgb24gd2hldGhlciBhIHJlZmVyZW5jZSBpcw0KCSAqIGhlbGQgYnkgYSB2Y3B1IG9y
IG90aGVyIGt2bSBjb21wb25lbnQgdGhhdCBnZXRzIGRlc3Ryb3llZA0KCSAqIGFmdGVyIHRoZSBl
bXVsYXRlZCBJL08uDQoJICovDQoJdm9pZCAoKmRlc3Ryb3kpKHN0cnVjdCBrdm1fZGV2aWNlICpk
ZXYpOw0KDQoJLyoNCgkgKiBSZWxlYXNlIGlzIGFuIGFsdGVybmF0aXZlIG1ldGhvZCB0byBmcmVl
IHRoZSBkZXZpY2UuIEl0IGlzDQoJICogY2FsbGVkIHdoZW4gdGhlIGRldmljZSBmaWxlIGRlc2Ny
aXB0b3IgaXMgY2xvc2VkLiBPbmNlDQoJICogcmVsZWFzZSBpcyBjYWxsZWQsIHRoZSBkZXN0cm95
IG1ldGhvZCB3aWxsIG5vdCBiZSBjYWxsZWQNCgkgKiBhbnltb3JlIGFzIHRoZSBkZXZpY2UgaXMg
cmVtb3ZlZCBmcm9tIHRoZSBkZXZpY2UgbGlzdCBvZg0KCSAqIHRoZSBWTS4ga3ZtLT5sb2NrIGlz
IGhlbGQuDQoJICovDQoJdm9pZCAoKnJlbGVhc2UpKHN0cnVjdCBrdm1fZGV2aWNlICpkZXYpOw0K
DQpEaWQgeW91IHNlZSBhbnkgc3BlY2lmaWMgcHJvYmxlbSBvZiBtb3ZpbmcgdGhpcyBzdHVmZiB0
byByZWxlYXNlPw0KDQo=
