Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C928770EB68
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 04:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239142AbjEXCjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 22:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbjEXCjS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 22:39:18 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC93E6;
        Tue, 23 May 2023 19:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684895957; x=1716431957;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+SGuFcATHx2pv0AGY5E11C7QAV2dWMzI14iInmNMoGo=;
  b=cEtf5Np4wP1+X6G3/tIGLV0mDdcPDiS5gNA6sFhaKu3tPBPLCSwEaBzl
   zR5ih0pWQilZo6FDO7NlGCru+yYeLER1FwVBEb+d7dPw7hvrUbw4TtQ69
   vz8D+a1kJUAu5Peno+wEXcwG1KGVPGwV1k/bpaHz3Xc0hdsEB3+RQfFmL
   DdFg7xbnrb/bAhdGHHGLGwgZXtzD3DgDByCu1isK1D3BC3SQorLJBSQ4k
   0MnoChkcx9TWrEPOTR8/DzCg6+HPygd2U8zHcPuglBN7ybn0aONf38bAq
   LGXSbL2roGl7lo452fxW5v7D01RYjiT6BW/y4cms2l2WfH9oj+Qq2IQSu
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="352273099"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="352273099"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 19:39:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="878454240"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="878454240"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 23 May 2023 19:39:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 19:39:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 23 May 2023 19:39:16 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 23 May 2023 19:39:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jNLFQAxDi0tPVRMByoGzZBkTMpQWr4MDyObL371Y0W/mNS2GZzMKiIHJxlZmyyuUuTpAnR6zmqC8L7Vcbsg0kIplAIITLtrLz5ASh9lL6Vz01jwMvdbBcDsyBuU8Q05YYq45/wMvphltlZIsRpcHEvOb044+OSOxQw+TtS/EmwZPPHbZwqEopdk8Q5kqhWIImM95Fe/odSm4kxY86PEhbkzGiMVasQ2KFYCyLvUqrmOOzNz7r2SL5aB5IEichOEE1o6Nehr3YvNJYdMmxcKgmSdNXFrBe+R/4chdbzX4V7IALPmKLIq3zrJ7coHmUrv6xtH812zft+FLEHT9EIdpFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+SGuFcATHx2pv0AGY5E11C7QAV2dWMzI14iInmNMoGo=;
 b=VfOExsHtJx9ZOoXXuGUiwP7G/HsvODtg+aLz6AYC676CbBeWscjvU+heuyHAQiWgFDUivU6sRsnAR5Dy2tWryfI2iKH69BiF5uMZDH+XpIDYG9FsPCB26DhF1X4A8vgswUpJ50CPb2PDwmY3xLKP3WfBoa6iU5JgJgH5coy0jxANxCgrJ+r+WLD/iZBvoPg25f9o/fPRbIboXgdjG366XhIOy4xCmEHxNMFUj0X9z1oFItDs9zhgiXTVs+zZgtpghYbYI52PpkJtipPy75Klc+NgTwQhdAiP93DBb9H9QK2//Xf4eewKK5XoaWL1g6qll4LtQLp6ZphoMKqrWj6iJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4760.namprd11.prod.outlook.com (2603:10b6:208:266::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Wed, 24 May
 2023 02:39:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dd3:4277:e348:9e00]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dd3:4277:e348:9e00%3]) with mapi id 15.20.6433.015; Wed, 24 May 2023
 02:39:13 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v11 19/23] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v11 19/23] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZhZ7kMJLs0F3CSU2mt3eSVRWFy69m5qgAgAA9hgCAAO1qgIAAr9wAgAAEuoA=
Date:   Wed, 24 May 2023 02:39:12 +0000
Message-ID: <BN9PR11MB5276415D558B1BBA5C19A2AA8C419@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
        <20230513132827.39066-20-yi.l.liu@intel.com>
        <20230522160124.768430b4.alex.williamson@redhat.com>
        <DS0PR11MB752935BF70AC95B564685DC0C3409@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230523095121.1a7a255d.alex.williamson@redhat.com>
 <DS0PR11MB75292184D6938DF4193C318EC3419@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB75292184D6938DF4193C318EC3419@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN2PR11MB4760:EE_
x-ms-office365-filtering-correlation-id: 69134460-52bb-4dad-0d61-08db5c000ef7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2BDqdiWzu6cVrnUmDUhAEj67LkNn4Fk3wz8gCCdL46PKGkXtreZIhDnwR5yJrGeUYEYSvXtKr6YfzvL9/fK9VdN82IrWayrLNgx3/93xJiDCGq1B4rUrpfTl4kSVnffeG2bUF2vr0Hco1514CWvBAjQ7aPGdQSZXYOENGVeWJclESrVpBLifsfKR08uA75jInxgx9KJX/i/pyvE5xrRXP/0NGyLNuK1G9tg5WlFPO0Q/oDf9+VhCAb1wShgWCjhcz3uSZNJTAveU1VPgyYsyk7yFBVd3mfPfwXkH9PeoEgVC2PCKXHsXlGcg02HNeZNpPv8Yzo9krVN5fUnaM+D4V10abuv4MJRLOvO/PUrLAJ2ZSCUCkposul0PvuXIQcVtbmV5E4++171GAbXl3/d2bMgisS24IhpmvxGAYwOh73Zo69cuCFunjZPQbg3YxE4iiIfN3SnrDm/kuSYyasaIWkE72bFJC3mkN0r8Tx/JsE8dmf1xCqTlvMoTq3ltkeARpRZMU4nwgSkWLR6fvM5P5RX3k+XISt3LHcwBTA6NNZdI+HntylqisOCR1r+qUIpC3rFa6tLaNN9+ReomGbEG0wap+9Q3lxZ7E/2G0ZwuanoTikEm7+M/e6IlpQP+TjdX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(346002)(136003)(366004)(39860400002)(451199021)(71200400001)(110136005)(478600001)(33656002)(83380400001)(38100700002)(38070700005)(86362001)(55016003)(122000001)(82960400001)(7696005)(26005)(6506007)(9686003)(186003)(41300700001)(8936002)(316002)(7416002)(8676002)(5660300002)(52536014)(2906002)(4744005)(54906003)(66946007)(66556008)(66476007)(66446008)(76116006)(4326008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eFpZVzFZSkU2KzZHRXpaUGdzYXQ0S1BYaHdFazF6b1hIcHRqcWpMMjduRHlI?=
 =?utf-8?B?Mk5Ub0VQUzg4NG5QVzFudlpnWmZjQi9YRFkvdnhMTXdzT1A4NHJkTVI5RXhB?=
 =?utf-8?B?TlZHbUYybUxDejN1KzB0YXpXdzRuMzhZMlJ5TG5iM1NBakpIYlNKOGZYM3Iy?=
 =?utf-8?B?MEFUQVVZd25uS3p4R2Y5R0VXckxzUDZvVE5xRFpJSU9TdnMxR2o4cmgxNHZy?=
 =?utf-8?B?MmtMSUp4eE1KVlZGcUNWb0M2cXd2UUozdXdaNnZMU3F1ODRTSzNENW5INHZy?=
 =?utf-8?B?L2l4WE55TjhIZ003YUpZcHE1SFlhZFdIc1hGZUVnVXBRRGtaQUNIVlAwWjh4?=
 =?utf-8?B?VUxwRnk3d21vNlVucnNJSWlWMUFhMlJVbmM3TVVIQ1Ryb2pyVnZlZ3lUOHZF?=
 =?utf-8?B?c2lWN05INGRTVzdublJnSHJmK2VhNWZSRXRjeG5NNTRpZDdEdUFaMzhSbmsw?=
 =?utf-8?B?dEU0L0F1QXRhRlFDVS83SC9jdUxHRkhCclo3OHExWTRHYTNjS2FZcDVPMVpt?=
 =?utf-8?B?Z3hlNFdUY3FMWUlKandCdFFib2IyQnd1NGViT2xKa0ZKbzJBYWZuZ2JaWnpq?=
 =?utf-8?B?c2NrSlpUcGpFM2IvbU9Lb2RGNmNaRzQyTVlhRTRVRjdOTC9relAyclRJRzd5?=
 =?utf-8?B?eU1WWjhCdllGVG9tVjl1N3BZTHlITmZ3bHliWUJKZFBlUzZMZkZ6ZjFPTkdn?=
 =?utf-8?B?amRJZjJGUjREY3FRK0xPdnlHbk5HUk5kVUJRc04xRHpSNmYzRHgraXh3cE9O?=
 =?utf-8?B?MGcrd2VOTnR1U1I4aUdXK3NMbmxMeDVUTVRoRnZMK3JHL3FIeEVFdUJIVjhq?=
 =?utf-8?B?T0hMNnRGSlRKWDh6dld5RjhBdGhuUkxyeWFMR29mTDdGdFJQVjVmYjBjQXYv?=
 =?utf-8?B?c2NJR3didGxWcENiN0JYcDdVZG9TWlB6VENhOFdhck1Id3NGTGoyMmRjSitp?=
 =?utf-8?B?QXA4YXZFUzNQTEhNV1o1dm1vL2Z4R2lFQ28xMGxlYUR5Ui8xTEV4dGpVTnZJ?=
 =?utf-8?B?a2RqY1llRGY4dStPcWMySlpUUnJjWFJvcUtJdzZ5ZUs2WjRTVWQxclpRdGYw?=
 =?utf-8?B?dzVMUTV3SVNzSmJIM1dDdk1LT3hYMDZHL29EbmthajlJdFBLOW5SbW44MEtF?=
 =?utf-8?B?R0IxenZ2K2piM0U5RVQweW8xYTdlRFI3dlo2Mm1ndUNyOUs5T0FKb2tpaWhW?=
 =?utf-8?B?YmNKRWlXQ2lWYm5oaHdtMmVQUjdOMHRFS25sZ29JWFcrQUNGQnlkZ2xZWkhn?=
 =?utf-8?B?VE50R2lFUldkOGhhQ1p5TlJLSnRBd0lWYTlnL0JxczR0cTBMeGlBeDV5d05k?=
 =?utf-8?B?L1JGTHowanE0eE8wb0I2ME9vOUJUb0dVeisxdHpGMUJPVmIwSitBL2IwYXNH?=
 =?utf-8?B?WWpla1dVVEVmMC9lSVF1VDQ1ejZpNmhYQ2tEU01Bajg0VFZEbTBIUU9PNnFV?=
 =?utf-8?B?Z2pRZGozZXNaK1A1bUw5MUtJN25BdGxiS1FBVHdzM3RLNEdDV0NsT00yT01N?=
 =?utf-8?B?NzlHUHc0bEEwbDIrWVhJRDl6VTU3ei9hN1kraTg0VUtpUFQwYVdzMUU0K0pm?=
 =?utf-8?B?OUNNZC9oTnRTM1B1V3UyTUNVeW5TU3p3TWllVWd5RXZSZ01iU1B4bXZ3TDFN?=
 =?utf-8?B?dWp2VnZjSFFNV0p0UmpYenVJRUdJd2xhNTQvWk9nNlhmNlZKUDVVQ2M2aTky?=
 =?utf-8?B?Z0NzbGF5RVpzQndBS25taUpldTZ4Zy9nQmhpZFMrRnBiOUZoZGEyU3ZiQ2V3?=
 =?utf-8?B?cWhjMWJpZFR0VDVUVGlYRlpuR3RvWmp2VHVuUEYwb0JOaUtvNWcrSnVKN293?=
 =?utf-8?B?aXVZQXk4Q0dacEx4TTZkT3JoeFNWWTFHYWQwcjJCSHRYcnIyenhER1R2R05L?=
 =?utf-8?B?bTFhcnB2cjJpcmxCc01ocFl0dEo5aDFHMUV1amg1SFNnOGdRSmRqZ0xaR2VU?=
 =?utf-8?B?UVZOSnJPSU5lMzc4MVVGZ0RtS2YzTjJETjFjdW5OTU9leGMzNitPQkt1UUIv?=
 =?utf-8?B?L3ROM0x6SGRoYXdhQVVvTEpWU0VQNE9CSUNKeDJZNyt1UU1jK1lxVkN5WCtm?=
 =?utf-8?B?VTFLVTJzWUdZanpEcDEyS2tYcE1tY1A5RUgzMVdJaHUybmhMNTdHZC9WUGdx?=
 =?utf-8?Q?FV2tZzogP88Q8bPXIxPBjzrsq?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69134460-52bb-4dad-0d61-08db5c000ef7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 02:39:12.3495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cwwmma6h6nvCvDyS1OnDqS+2syXC+jvsJtRscbsVrSlWSs0DTyWoeuXbrOkX+raYVZ52RuVXcTZika2P42mVNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4760
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5
LCBNYXkgMjQsIDIwMjMgMTA6MjEgQU0NCj4gDQo+ID4gPg0KPiA+ID4gdmZpb19kZXZpY2Vfb3Bl
bl9maWxlKCkNCj4gPiA+IHsNCj4gPiA+IAlkZXZfd2FybihkZXZpY2UtPmRldiwgInZmaW8tbm9p
b21tdSBkZXZpY2Ugb3BlbmVkIGJ5IHVzZXIgIg0KPiA+ID4gCQkgICAiKCVzOiVkKVxuIiwgY3Vy
cmVudC0+Y29tbSwgdGFza19waWRfbnIoY3VycmVudCkpOw0KPiA+ID4gfQ0KPiA+DQo+ID4gVGhl
cmUgbmVlZHMgdG8gYmUgYSB0YWludCB3aGVuIFZGSU9fR1JPVVAgaXMgZGlzYWJsZWQuICBUaGFu
a3MsDQo+IEkgc2VlLiBJIG1pc3VuZGVyc3Rvb2QgeW91LiBZb3UgYXJlIGFza2luZyBmb3IgYSB0
YWludC4g8J+Yig0KPiANCj4gQWN0dWFsbHksIEkndmUgY29uc2lkZXJlZCBpdC4gQnV0IGl0IGFw
cGVhcnMgdG8gbWUgdGhlIHRhaW50IGluDQo+IHZmaW9fZ3JvdXBfZmluZF9vcl9hbGxvYygpIGlz
IGR1ZSB0byB2ZmlvIGFsbG9jYXRlcyBmYWtlIGlvbW11X2dyb3VwLg0KPiBUaGlzIHNlZW1zIHRv
IGJlIGEgdGFpbnQgdG8ga2VybmVsLiBCdXQgbm93LCB5b3UgYXJlIHN1Z2dlc3RpbmcgdG8gYWRk
DQo+IGEgdGFpbnQgYXMgbG9uZyBhcyBub2lvbW11IGRldmljZSBpcyByZWdpc3RlcmVkIHRvIHZm
aW8uIElzIGl0PyBJZiBzbywNCg0KdGFpbnQgaXMgcmVxdWlyZWQgYmVjYXVzZSB0aGUga2VybmVs
IGlzIGV4cG9zZWQgdG8gdXNlciBETUEgYXR0YWNrDQpkdWUgdG8gbGFja2luZyBvZiBJT01NVSBw
cm90ZWN0aW9uLg0KDQpmYWtlIGlvbW11X2dyb3VwIGlzIGp1c3QgdG8gbWVldCB2ZmlvX2dyb3Vw
IHJlcXVpcmVtZW50Lg0K
