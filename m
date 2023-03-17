Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEEA46BDDD7
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 01:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjCQA5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 20:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCQA52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 20:57:28 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3837E7C9D8;
        Thu, 16 Mar 2023 17:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679014647; x=1710550647;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Nan00u0dk+3v1NsV+bakx1y1Ny4GH3b6j5rH25HZM/A=;
  b=eVjKUFjyWxeE6g32JpEzyjAmDEoiP7tyuKW2jz7wH3NAKAeMUzOl90Xu
   4bhrcSmgLR6/3k6RUOfhou+zpJVkg+BnWcrCKmNjFDKDSOIOYv2L9FESW
   e2ErCN1dXo7jhvSCs7eBbhbeQLY+98eVPSgxcg3gXvyoblylJHo3/axPh
   pF4g4TQzq0eVxZGKm5IrNHHFoinncpcQ1bsIjLnPemZHXlCLB01vv+7hm
   hRdCyqY/cuziDokiTygs0+avAR4IsnfWdOHsqT7/GI6LXIghDyBuznol1
   gMVJOdPtYXGrzcCZideQ1UPjO6kAJDGsbO+nb4pDbXTEU/muP7kVcZ66q
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="317805848"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="317805848"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 17:57:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="673375566"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="673375566"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 16 Mar 2023 17:57:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 17:57:26 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 17:57:26 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 17:57:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hb3JGXTQ7w/r4nl5QVx+1gJZ3+KUQavjk7PSi+6OV2Erpc2RpYtBJJf4M0kelamyFNCVghU+T+46kn+BJCXOwkhkavSrWuYFd1hC6bo59sE+RtxvWQGEVqCXCoi68fvtcCno4CrDyRnmoZk5dFjGjea0CTrXj2n8/nBYZjS5rnzxnHYGWHlgO4Y5NYQ2eZxmXbsnKztXLBhjrIrHKQmNYH8Q+RXzdGOHt/nuhVlwq7VFjr0ck4YtV5jHhRLd5aBu/0/lP5fY2P8vR0NmwxMjDvTlsKOFs+wplXanPO788rDj41RCixvY5B/VP+faKooZAfShIzC4rK/aY7hGlt6CDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nan00u0dk+3v1NsV+bakx1y1Ny4GH3b6j5rH25HZM/A=;
 b=SlVINf7Lo0RPGuZ6MkfXyuXjVL7C8gSfQCey5gBZfXV53h+EWQbJYEnniKCLrZ9fpuCEfw8TAJEib8H/cLfxRk/F4cNCKpPhpGqPh/0HI7YvgXyeEYKHTImnsUci3e7hdbD90STojlppnd+xFxxuIoTshYt2GrsqEKWoepQV3iRXeHvpKuDyche2sA3bN3tkzhoSPGFBscB4VIIL7x4UjqqCk5qYr3p1EwfXukxj3eInc5gWfuWKdqTt6pATjcq6WoyVC7iu1032FFsq9qxxUz4vGCQQx0a6XkzmzkqadJkxcvdjcdPt5fFRAPLCGje5YqKi+YE4APEQ9a+PnAWRog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB7954.namprd11.prod.outlook.com (2603:10b6:208:40e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.33; Fri, 17 Mar
 2023 00:57:24 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 00:57:24 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZUcIISo3Z1SbL8EmJASujVt/DZK78flGAgAAE67CAAUg5AIAATEkggAAR+wCAAAeXoA==
Date:   Fri, 17 Mar 2023 00:57:23 +0000
Message-ID: <BN9PR11MB5276D5A71E43EA4CDD1C960A8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-13-yi.l.liu@intel.com>
 <20230315165311.01f32bfe.alex.williamson@redhat.com>
 <BN9PR11MB5276300FCAAF8BF7B4E03BA48CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230316124532.30839a94.alex.williamson@redhat.com>
 <BN9PR11MB5276F7879E428080D2B214D98CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230316182256.6659bbbd.alex.williamson@redhat.com>
In-Reply-To: <20230316182256.6659bbbd.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB7954:EE_
x-ms-office365-filtering-correlation-id: 8d91ab62-9de7-4668-dae2-08db268291d6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B4ffFXWO0nZPIIzO0HjRtj9KhFlI4cRcCAFCIy44moHPtoAZvvzhrVTPlIjiqogl4jT5LGLpNlOuSpWitt2axNXFrvOKNbS8UgokzKbDMAlpHkwAEFmwhxD8o2p++1zr8mKVtLZvol5kNl9AKRok5Zi2pOSE/49/KCnQH1g75f2ZqBIvEhj3TjtZG+sMCTTH4pu1KWV9gYRy6u4SQTuoqMpGtmF34akojdnEKKcfyg4m1fIKxe2KmTdvwvy6vNqd+EsVaMFcjPScmNGxN/fH33w+Xx+d+e0GnHDL+PM2FuKFdq/SrPjl/93gEiFQiRaM+LtCemZKAfWUwdiEDLPWBJ86F7UNktsgJb3ikhDVy6vLoHoRHrKQGolyY/4qNy/EkZBV1UHvWbmbShYKRoLZMSbm5e+uSN5zJqIGS2/3doC0a9l3sjvuHWvhl5OhvBZuFWwMAB0nx8a7ysUDm6Ud3U3gyETeGvDlZBvw8KQXn1E0Eakom3RGL/BnkhKbSYehpZa02LEac95wjh7VptznDXGhKTT0GEGHoZS5peRD4fZxPb9VJZ6FH50yFVOOg/bfLVosha7Zhv45LZSufN6tw4H1p4i/ZN0PhiXjGqOUhAAFw3MnTibHtr07IofSOnm1pZrseeTs6FnG/xhQhgkg5vV+5twgYmSGI7c6H+ejbV6LgDlccZhB4VP3yOXm4kS5h/jJQXo3sfO3KNbFd1lcNQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(39860400002)(396003)(346002)(376002)(451199018)(33656002)(5660300002)(52536014)(41300700001)(7416002)(8936002)(2906002)(38070700005)(38100700002)(86362001)(122000001)(82960400001)(7696005)(71200400001)(478600001)(66556008)(8676002)(66446008)(66476007)(6916009)(76116006)(66946007)(64756008)(55016003)(26005)(83380400001)(54906003)(316002)(4326008)(186003)(9686003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bHR6VEZzV3VOaGVJVWtYREF0MG5EMk5VVU5VQit1bzJJV0xsOXJsRy9CN3k0?=
 =?utf-8?B?KzgvMEZCaE9CUFFYYUZmdFgzNUVQeFhwSjg1WmpQSytXbnprOHcrbmx5TGd0?=
 =?utf-8?B?L0ZvRTQ1eWVOUDJKZks3UENVZ2ZNWlUrYllVdFFvTUNyVXZGR3RtRkxjQlRp?=
 =?utf-8?B?NXplK2VSNk9sWG5kcExJZ1dhYUJiMzY4alVDZmpvWHk1c1R2RWdvc2F4L2NL?=
 =?utf-8?B?bld0SEpzUUpQWGJHRDl3YUxDSXpPZnR6MGFNNm9KaUdrMjk3TlNvL0NlNnhX?=
 =?utf-8?B?QmVwNWpNY0xMem4rQ3RKcEhWZkNuNW14WTM4cGMyQWhubTBXdkpZS3B0VGtU?=
 =?utf-8?B?RnlsSDR6VWJERnBuTHhVN0JzVmdpdHhHaGdNczhyeGlqalZhcE10dzZYdlNP?=
 =?utf-8?B?b2hpa1hubUtKei9mMTFNQzBObDlDUGpTZkltU1FSOEt1eGMwN2tPTWhPZ2R5?=
 =?utf-8?B?TlBBb3BFQjMrczBuU0psWlh5RmV0SzV2SUdVQTllM0dhS3lDZDBLS2cxTmFl?=
 =?utf-8?B?R1k5dzdSZndzSC9hblNBRXdkdXk1bGoxU3NCS2FmWW9rREh6RmsyRlAwdmdS?=
 =?utf-8?B?VWtabEFhQWlkeU9EbEN6dmRXZU41ZlFYNG54T0lyMThaMzZIL3ZYcFc3aVkw?=
 =?utf-8?B?VDlicFppQXhKY3NhSW5SS1RJdUpEVjgrZ0p4UmpNaEZkWXRORVl5ZEwwZ2p5?=
 =?utf-8?B?WmxzMFpVdzY3ZU5HZ3JXWkN4Zy9OV2NUQlVvaktwbUJibGsrUHdJTHlyWHRZ?=
 =?utf-8?B?dWlId0xpbTI2aG9yLzg4c0VITE04TEEwaDhLNkFhZ21rU0ZmVllyQ3FhL3ZL?=
 =?utf-8?B?aWRtbFhXNUtCVE5ZdktVTDRkdG05VGJMUkVKRFZteEcwRU5xVnU5QUFaM3Js?=
 =?utf-8?B?TWduV3o2ZWs1R0FPbkJvb0o2V0ZBNkloS1BJOGtCNGIxd3hpN2hyT3EyMnRM?=
 =?utf-8?B?MGdyZ1hBZFN2cXZlWnM1b3RFU2ZhWThqU3V5UGxBTTVwZzVWMnl1cEk0ek1q?=
 =?utf-8?B?YlFUNU1pd2gyazdsZVlKQlBvbW96T0c4NDVGSDZGdmpDdFdxUWptMmlqYWoy?=
 =?utf-8?B?RUZnOW9NdU4vSVRseEJpMWxSOURKS2xncVdvWWR3T2x3MkFiRTFrL0xZOTBZ?=
 =?utf-8?B?SHpvNFc1SXg3dTVNay9VZEc0OUhEVi9BWFd6T1luV3dvSTNTcWZsckVKL1la?=
 =?utf-8?B?cjYveitQN21PaS9NZHdnTHU5NGloSWZlMVBtTitBdFBmdEp4SmdmK1VScFlu?=
 =?utf-8?B?UzZoazFqYjJUNmhFV3lISWluVjVTS2xXSGZqRzRyOE5Mc0haQXNRaExyTXFP?=
 =?utf-8?B?aDZieng1RUxUckh5MktraWRqSUZvUTJkVWFVd2pFVzVqdWFaNGdVb29hQW52?=
 =?utf-8?B?UjlEbVkrMGpUa1MyeTcwbXI1MXhPMFIwNkJxajFMYVR4MjhuVXVOb1F1YXl0?=
 =?utf-8?B?eWVDZXcxM1k4OURpR1N5L29xZUw5OG5Lb2dBTHNGa2R2bHhOcVp1dkJuTGx6?=
 =?utf-8?B?ZnkzeG9YLzZIK2RtZS9ocWVOZENyOGdIdlVuL3lxVlFvL3RPYi9LQTRuYlp2?=
 =?utf-8?B?N0N4VW4xVHVqN1JJYlQ3UFRxS0pmaEErMU4rb2FDUWw5Z251bk9qT1dtTG1r?=
 =?utf-8?B?SjJLU2F3WGlRRC9VdlE4SGdVVWp4bjNCVFBSVCs2b2hjZmhOSk5Td1B2aWpj?=
 =?utf-8?B?Q1JlbEhXYVBvTndLenBHZGFWK2VkUERqQm1Xa3hFaWJzNFdKcEhhYWVCYnI3?=
 =?utf-8?B?WFp2U0plR2pWUnBhaWZiWDR5NU4wNWcwLzFFMi9GRjVwZFpMRFVsMlFmU1p6?=
 =?utf-8?B?M0MrRjJSRXMwRkpjVnA5SS92NWZraEdBSmdDWmFMaHFkbnFCQ0NyNFR1VDVt?=
 =?utf-8?B?SklDTE4rWUJIa2JtQUtXT2xTUmRxN09aZlpzOWdkTzB1dzBUa1E0WTdDSE5K?=
 =?utf-8?B?ZDY3cUtETDhQdXAxU3VucmFSTkVPYnVXT3lKSDRPSXJmZHI1M01QRjcxNElD?=
 =?utf-8?B?cHJBcVhYeHhZLyt5aWJ6NTAxOFNWZWExbkZwZ0ZObWhSMnlxOVZmeWl3ZEtY?=
 =?utf-8?B?QW9qRlBTNHlrNlNJb3p2c3V2czNGK1kybjh1TER5TGU5eW95T09NTmRyblZj?=
 =?utf-8?Q?V0T79GNL7KAN76V580lpNvMY8?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d91ab62-9de7-4668-dae2-08db268291d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 00:57:23.7282
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0DW1VbjJoCZGm3nL3rRl1bbDYgR6yeoNvFSyQ5e3MwqL6+XX7/fCOiLncjjHsdtynh9m2xN1WEBQLewa9+V5vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7954
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24NCj4gU2VudDogRnJpZGF5LCBNYXJjaCAxNywgMjAyMyA4
OjIzIEFNDQo+IA0KPiBPbiBUaHUsIDE2IE1hciAyMDIzIDIzOjI5OjIxICswMDAwDQo+ICJUaWFu
LCBLZXZpbiIgPGtldmluLnRpYW5AaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gPiBGcm9tOiBB
bGV4IFdpbGxpYW1zb24NCj4gPiA+IFNlbnQ6IEZyaWRheSwgTWFyY2ggMTcsIDIwMjMgMjo0NiBB
TQ0KPiA+ID4NCj4gPiA+IE9uIFdlZCwgMTUgTWFyIDIwMjMgMjM6MzE6MjMgKzAwMDANCj4gPiA+
ICJUaWFuLCBLZXZpbiIgPGtldmluLnRpYW5AaW50ZWwuY29tPiB3cm90ZToNCj4gPiA+DQo+ID4g
PiA+ID4gRnJvbTogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4N
Cj4gPiA+ID4gPiBTZW50OiBUaHVyc2RheSwgTWFyY2ggMTYsIDIwMjMgNjo1MyBBTQ0KPiA+ID4g
PiA+IEknbSBhZnJhaWQgdGhpcyBwcm9wb3NhbCByZWR1Y2VzIG9yIGVsaW1pbmF0ZXMgdGhlIGhh
bmRzaGFrZSB3ZSBoYXZlDQo+ID4gPiA+ID4gd2l0aCB1c2Vyc3BhY2UgYmV0d2VlbiBWRklPX0RF
VklDRV9HRVRfUENJX0hPVF9SRVNFVF9JTkZPDQo+IGFuZA0KPiA+ID4gPiA+IFZGSU9fREVWSUNF
X1BDSV9IT1RfUkVTRVQsIHdoaWNoIGNvdWxkIHByb21vdGUgdXNlcnNwYWNlIHRvDQo+IGlnbm9y
ZQ0KPiA+ID4gdGhlDQo+ID4gPiA+ID4gX0lORk8gaW9jdGwgYWx0b2dldGhlciwgcmVzdWx0aW5n
IGluIGRyaXZlcnMgdGhhdCBkb24ndCB1bmRlcnN0YW5kIHRoZQ0KPiA+ID4gPiA+IHNjb3BlIG9m
IHRoZSByZXNldC4gIElzIGl0IHdvcnRoIGl0PyAgV2hhdCBkbyB3ZSByZWFsbHkgZ2Fpbj8NCj4g
PiA+ID4NCj4gPiA+ID4gSmFzb24gcmFpc2VkIHRoZSBjb25jZXJuIHdoZXRoZXIgR0VUX1BDSV9I
T1RfUkVTRVRfSU5GTyBpcyBhY3R1YWxseQ0KPiA+ID4gPiB1c2VmdWwgdG9kYXkuDQo+ID4gPiA+
DQo+ID4gPiA+IEl0J3MgYW4gaW50ZXJmYWNlIG9uIG9wZW5lZCBkZXZpY2UuIFNvIHRoZSB0aW55
IGRpZmZlcmVuY2UgaXMgd2hldGhlciB0aGUNCj4gPiA+ID4gdXNlciBrbm93cyB0aGUgZGV2aWNl
IGlzIHJlc2V0dGFibGUgd2hlbiBjYWxsaW5nIEdFVF9JTkZPIG9yIGxhdGVyDQo+IHdoZW4NCj4g
PiA+ID4gYWN0dWFsbHkgY2FsbGluZyBQQ0lfSE9UX1JFU0VULg0KPiA+ID4NCj4gPiA+IE5vLCBH
RVRfUENJX0hPVF9SRVNFVF9JTkZPIGNvbnZleXMgbm90IG9ubHkgd2hldGhlciBhDQo+IFBDSV9I
T1RfUkVTRVQNCj4gPiA+IGNhbg0KPiA+ID4gYmUgcGVyZm9ybWVkLCBidXQgZXF1YWxseSBpbXBv
cnRhbnQgdGhlIHNjb3BlIG9mIHRoZSByZXNldCwgaWUuIHdoaWNoDQo+ID4gPiBkZXZpY2VzIGFy
ZSBhZmZlY3RlZCBieSB0aGUgcmVzZXQuICBJZiB3ZSBkZS1lbXBoYXNpemUgdGhlIElORk8NCj4g
PiA+IHBvcnRpb24sIHRoZW4gdGhpcyBlYXNpbHkgZ2V0cyBjb25mdXNlZCBhcyBqdXN0IGEgdmFy
aWFudCBvZg0KPiA+ID4gVkZJT19ERVZJQ0VfUkVTRVQsIHdoaWNoIGlzIGV4cGxpY2l0bHkgYSBk
ZXZpY2UtbGV2ZWwgY3Njb3BlIHJlc2V0LiAgSW4NCj4gPiA+IGZhY3QsIEknZCBzYXkgdGhlIGlu
dGVyZmFjZSBpcyBub3Qgb25seSB0cnlpbmcgdG8gdmFsaWRhdGUgdGhhdCB0aGUNCj4gPiA+IHVz
ZXIgaGFzIHN1ZmZpY2llbnQgcHJpdmlsZWdlcyBmb3IgdGhlIHJlc2V0LCBidXQgdGhhdCB0aGV5
IGV4cGxpY2l0bHkNCj4gPiA+IGFja25vd2xlZGdlIHRoZSBzY29wZSBvZiB0aGUgcmVzZXQuDQo+
ID4gPg0KPiA+DQo+ID4gSU1ITyB0aGUgdXNlZnVsbmVzcyBvZiBzY29wZSBpcyBpZiBpdCdzIGRp
c2NvdmVyYWJsZSBieSB0aGUgbWFuYWdlbWVudA0KPiA+IHN0YWNrIHdoaWNoIHRoZW4gY2FuIHRy
eSB0byBhc3NpZ24gZGV2aWNlcyB3aXRoIGFmZmVjdGVkIHJlc2V0IHRvIGEgc2FtZQ0KPiA+IHVz
ZXIuDQo+IA0KPiBEaXNhZ3JlZSwgdGhlIHVzZXIgbmVlZHMgdG8ga25vdyB0aGUgc2NvcGUgb2Yg
cmVzZXQuICBUYWtlIGZvciBpbnN0YW5jZQ0KPiB0d28gZnVuY3Rpb24gb2YgYSBkZXZpY2UgY29u
ZmlndXJlZCBvbnRvIHNlcGFyYXRlIGJ1c2VzIHdpdGhpbiBhIFZNLg0KPiBUaGUgVk1NIG5lZWRz
IHRvIGtub3cgdGhhdCBhIGhvdC1yZXNldCBvZiBvbmUgd2lsbCByZXNldCB0aGUgb3RoZXIuDQo+
IFRoYXQncyBub3Qgb2J2aW91cyB0byB0aGUgVk1NIHdpdGhvdXQgc29tZSB1bmRlcnN0YW5kaW5n
IG9mIFBDSS9lDQo+IHRvcG9sb2d5IGFuZCBhbmFseXNpcyBvZiB0aGUgaG9zdCBzeXN0ZW0uICBU
aGUgaW5mbyBpb2N0bCBzaW1wbGlmaWVzDQo+IHRoYXQgZGlzY292ZXJ5IGZvciB0aGUgVk1NIGFu
ZCB0aGUgaGFuZHNoYWtlIG9mIHBhc3NpbmcgdGhlIGFmZmVjdGVkDQo+IGdyb3VwcyBtYWtlcyBz
dXJlIHRoYXQgdGhlIGluZm8gaW9jdGwgcmVtYWlucyByZWxldmFudC4NCg0KSWYgdGhhdCBpcyB0
aGUgaW50ZW5kZWQgdXNhZ2UgdGhlbiBJIGRvbid0IHNlZSB3aHkgdGhpcyBwcm9wb3NhbCB3aWxs
DQpwcm9tb3RlIHVzZXJzcGFjZSB0byBpZ25vcmUgdGhlIF9JTkZPIGlvY3RsLiBJdCBzaG91bGQg
YmUgYWx3YXlzDQpxdWVyaWVkIG5vIG1hdHRlciBob3cgdGhlIHJlc2V0IGlvY3RsIGl0c2VsZiBp
cyBkZXNpZ25lZC4gVGhlIG1vdGl2YXRpb24NCm9mIGNhbGxpbmcgX0lORk8gaXMgbm90IGZyb20g
dGhlIHJlc2V0IGlvY3RsIGFza2luZyBmb3IgYW4gYXJyYXkgb2YgZmRzLg0KDQo+IA0KPiBPVE9I
LCBJIHJlYWxseSBoYXZlbid0IHNlZW4gYW55IGV2aWRlbmNlIHRoYXQgdGhlIG51bGwtYXJyYXkg
Y29uY2VwdA0KPiBwcm92aWRlcyBzaWduaWZpY2FudCBzaW1wbGlmaWNhdGlvbiBmb3IgdXNlcnNw
YWNlLCBlc3BlY2lhbGx5IHdpdGhvdXQNCj4gY29tcHJvbWlzaW5nIHRoZSB1c2VyJ3MgdW5kZXJz
dGFuZGluZyBvZiB0aGUgc2NvcGUgb2YgdGhlIHByb3ZpZGVkDQo+IHJlc2V0LiAgVGhhbmtzLA0K
PiANCg0KSSdsbCBsZXQgSmFzb24gdG8gZnVydGhlciBjb21tZW50IGFmdGVyIGhlIGlzIGJhY2su
DQoNClRoZSBib3R0b20gbGluZSwgaWYgdGhpcyBjYW5ub3QgYmUgY29udmVyZ2VkIGluIHNob3J0
IHRpbWUsIGlzIHRvIG1vdmUNCml0IG91dCBvZiB0aGUgcHJlcGFyYXRvcnkgc2VyaWVzIGZvciBj
ZGV2LiBUaGVyZSBpcyBubyByZWFzb24gdG8gYmxvY2sNCmNkZXYganVzdCBmb3IgdGhpcyBvcGVu
LiBBbnl3YXkgd2UnbGwgYWxsb3cgdXNpbmcgZGV2aWNlIGZkIGFycmF5DQpmb3IgY2RldiBzbyB0
aGVyZSBpcyBubyBmdW5jdGlvbiBnYXAuIPCfmIoNCg==
