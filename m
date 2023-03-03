Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852306A9121
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 07:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjCCGhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 01:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjCCGh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 01:37:28 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEE15652F;
        Thu,  2 Mar 2023 22:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677825427; x=1709361427;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=67S/EkkdiYVjX/OmqVeQOH/vFzdYyBoN5o85sT/kHr4=;
  b=LFmO2Q84lW+rAS/GSCAG8X6RFXMhvDwWsWa45a2LQVsj03tGcjjGOZ5w
   rrNou/XetYnDyltROHw+f+GU92eJvvoxWKwkwJMkqaPzVT5E4tzrIpNjc
   3GDJwLK1UkMygacCS9/IhYLRHAUeQFUQn6rcL/LgvvR536dGCkQ6f1Lci
   /vH2Hx69j6ctIKTbKVGqqtRSJYxkL+ONbEljBs/R0u9b2yUsYufOrXGnj
   TXony6D5AJ7xwEu8hVm6ywUjiBtlWGO0iRZlaO0JfniYu0yyyFnM5p2Ab
   Aa0OFajhk1zJDSXtRmulVxQ2QFmNUArvlyhhgFhYOX+IxJi+c5m5/VTkX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="362564433"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="362564433"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 22:37:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="785161920"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="785161920"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 02 Mar 2023 22:36:45 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 2 Mar 2023 22:36:43 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 2 Mar 2023 22:36:43 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 2 Mar 2023 22:36:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jX5GJU0u76VJq14yuQiTD6Fm9IWo7UbEFBjBw5zgJ1t1S2j0YT97JZyzNYWRJo0OQino37fObIsPJXUT6pCwqOjrfr+KtpANNavbm2BAwpm4WRFw1/iOiV11SL8alU8p2UWYAO8ICJXs/xCXOAizh8QWmxuGWn2M34+J+ilyhfOjbko19dDrX5YxJppLid4pDE3SojYEBKgkFfEQvp5Ps8MDXsX7son0vomtZ+cnQBGHPwLSJWL4mfJy0KqGcnYTfJvTFFdClpMTOsj66cQAnW/9ptIh/LqH6ZaiIqRQRRP+vPAuz5NSmtvPENiOFdyDMP3BB9jXivVEUTnPAw1gjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=67S/EkkdiYVjX/OmqVeQOH/vFzdYyBoN5o85sT/kHr4=;
 b=li66HI7WqH0mx6q79mn1Imnlt+us6q4OmQ/SOBduerg++XZ9fLF5L5/+ETbQWlzRLrLPzc2dPD0k4eNr+c7x3T7EZn9va/DKCSqb2OoeuUmELqESqbwEaXtkmqio/zh/AriwVGmPAtFtf8/MRxYATwiKnKSilMOLUM4D0KxWGM2HQmey9qK9ZeCrAgqsmSSWpflp9Caj0VcUZQIAK9Y4nR7Vy5t8sx1YZEo511azFAue86QjrhYR6Oq+fv6sqFugaPmZgqvcE/SE3HF1w9DCVz1e7z6Ik0eBLVxZUwPGQM4RPLbtuQLy5/0hAJ8NpeM9TIXLxd1mDXnj6e4BitR49Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Fri, 3 Mar
 2023 06:36:35 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6156.019; Fri, 3 Mar 2023
 06:36:35 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZSpxNc+z5kvMhjUKJQeU3VasOx67nBTMAgAA+rbCAAC27AIAAHWOAgAECO4A=
Date:   Fri, 3 Mar 2023 06:36:35 +0000
Message-ID: <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-10-yi.l.liu@intel.com>
 <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZACX+Np/IY7ygqL5@nvidia.com>
 <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB5095:EE_
x-ms-office365-filtering-correlation-id: 37bcb05b-2457-4ac0-a46e-08db1bb1a2c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eI3Tke/qQ9mE5h2SpzDWSEE7neBenBxgukjXDj3RNlmvPZGUlIZdFcEnp3sRIATEjVuHJpqq3mGBVppFYpd5weR+9gZ16/bhusrEje0oCCA5y+5CiSyohoBywybwm14s0ynk1YuXsVCLY0a5UXLqBDJkZn4bFa6ZVgXa6/QPxOZGNP54oDHEL1UC6H1NLCtEfiFPknnP6UY/Jkxf7nrkNTmHIF1kiN9xfysn2egNdn60vA0ghd5kgU0v04VafXmEwmRlr1IOSwtIT9awMVc8qbM4xGo1duilkPVHCYR4696VGhNd/ig5YPh64YpmUWthRn9aDSgMzK5D7TNXOkV+Ekb4ul8XlhRd2cKZjt9/R2SVEEsmItVKssciWEPr8iJc1tCvCCDVRUm2i+Ny22i2rQsE957xuAudVXpiWai6CGPWth2nR6kxqpIPcSPZJEPZN8ae5f031tH/g4dguK6bZ68hyRblAUddZb55Y1KVzo+S68MolIpBNvu8ucKNdWrSWORWQMknoiaDulBbcr4c3TvNoO0tUdD8dN0bFqXmr1geXo4xfEcOK+KiFCN4upTTIbPJaz/MZ0eWXfv5wUZ5FdIN+1JyMIkZK7cHmj5H9LGs58iiaIiYLWxCM0hFx133SEOS+rsLvMikBV7uedRnY1Hr75JyGmTI0Hj3ZZ6DVBwmc6+uV3ZCCRO1WjNQkVHo81cxlNQSzuSIe76t8EG9Ww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(396003)(136003)(39860400002)(376002)(451199018)(66899018)(41300700001)(8936002)(52536014)(55016003)(54906003)(4326008)(66556008)(64756008)(66476007)(66446008)(66946007)(9686003)(76116006)(186003)(33656002)(86362001)(8676002)(2906002)(83380400001)(7416002)(316002)(6506007)(26005)(5660300002)(110136005)(122000001)(478600001)(7696005)(71200400001)(38070700005)(38100700002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YWVaNXM2djZiVXRRK09vd0lIMjN4TzBQWWlFaU9mekN2VS9XMU04b3pCUG9U?=
 =?utf-8?B?YytPa3orR0c2WUdqWTJMSmtJaCtkNEMxOGJHcUZFTVIvdThMRFkrMjNNenRE?=
 =?utf-8?B?YTFnbVBXNVNFalVRZHY3M0EvNXNOQU9lM3JnSHdrcTQ5L0hwVm5Vb2RHWm1D?=
 =?utf-8?B?ZjhnY2hmSnZtbHR2MUNhVHh5ZHVVMUd2dlNDV2dXQ2I2STAvU0FsbkRmcFY4?=
 =?utf-8?B?ZlltbW5OaklqdTh6ZjN1Sk9qVGxxUXZlZll1Mjg0Y0Z3V0R2d2dNZmhjVXJ4?=
 =?utf-8?B?eFZLWndrVjdxOHMzUFNEbFpnL2NoQVZBNG8vTnBSVEVZM25kUjBHSFVQZlNY?=
 =?utf-8?B?dWdTWFlOU2hPYVJWWWJ6VWVsbHQ3aEJwMnNlZjFMQUM5SVNFcDdkNEZLOEdy?=
 =?utf-8?B?STJEaGJjTThBMTBJbzhQQ0tqbk9JcTVNbWo5S0lKeVB4SVI2bm96bGpkM1E3?=
 =?utf-8?B?SlZDU3hkUzlHWWpHSmdaemZpZlFUdW5tSGZ4THZVVDRWZmRSTDdxVmlaaHZY?=
 =?utf-8?B?NHlFZVdOamJlRDYzQTg4bmo1alFpNjVnRnhjd3A3d2hncVBqY0k4SW03Z3Fv?=
 =?utf-8?B?d2czMkovOSthQmFNK29JSHAybzNrODFiUjhOeWRlWEI4K2tWWitmUDNrWVVC?=
 =?utf-8?B?MmkxM1JBS0xFbWowOEFHVkg3VVpZZDNMQW53cTFETWRTTW9yNmNROUNyT3Na?=
 =?utf-8?B?aFBQSnBDLzRkN1RIbWJUMFBVU0UxNyt2dVRiQ05pMENqOENCczYxQ0xNTTQv?=
 =?utf-8?B?VXZMVE9iZGlGM1VicEtrSnhHWjBwWFVDMVVGTTgxa3loT21oQksvYmMyZzVz?=
 =?utf-8?B?a2xqY29oS3FhMklZMjVMNnZOWEVTZmRVQy83Z3dlMi9RMm81Z3hncnZmeFAx?=
 =?utf-8?B?UUhJd1lYWldWb3JpYWNLRmNLeHdENmR6OURYemFpeklPc1QvTWFZSkNGRlNW?=
 =?utf-8?B?b2ZMQ1kvRGljNExZeThmWXNKQkdxbWVlTDhHYTRkWGdYZndOaGdtMGJMSzJT?=
 =?utf-8?B?bzhDT2ZDT0ZGRkFTb0tOMzV3bmhBdGZ6S3Z3dUprREJzdFpKNUFqeTk3OXNt?=
 =?utf-8?B?L0U4SHZmcnlUdG9CSytFbDl0RVdQVzdEM1N3cHI3NFZ5MjM3Qnd2UTFmd1Jn?=
 =?utf-8?B?ZWFUSzhUSSswSkpZY1BKKzR5aXF2M0lybmc2cnRKRzNNM2p0U1MvNmlRV0Ey?=
 =?utf-8?B?d2xWTW1DbDJSTWtsTS9PS0p4cExacCtoTWdOZ0I3S3diY0FSSERkNkJtM3A1?=
 =?utf-8?B?WFR2WnIya2lFdTUxelhhRzJ5dDhHbTlzeXdheGhzaG9XOXF2TzU0bUdpbWNR?=
 =?utf-8?B?WExXV2NYdGxsZWVrZnBkZjk2SEthWDJlbUVXbVdoOWs4OU9KcnByQk1Rc1h3?=
 =?utf-8?B?eUl2L3RTVFNDblpqTG9JNTVCRmJEcFNQL3VKNjBPS01EemxwU3ZJWmVTVFdj?=
 =?utf-8?B?ckVGQ1dtaFY1Q0sxUTB1MnIzTUpqSEZsTzFrcVRZZ1BySXAxRXJtTi85dks5?=
 =?utf-8?B?Y1U3UlZyekp5SFBITnZLVXZBK3pVMllJWHEvSjZyNWMvZXFTTjF0ZWpJbVlR?=
 =?utf-8?B?bE1uNU03YlNmenY5VWJJZGp2RHY0a0FzR2VnTGJvLzA0SjMva1NxcW00SFpK?=
 =?utf-8?B?ajhBek1GQkNkM3dEaFNwU1U0ekdqeG1pYkxpREtwdHhLd2ZmcnBianplaE5n?=
 =?utf-8?B?eEtia1lrV3h0b1pySUlLS1gyelBwb2x4RkJHdE9RUGhxYktDd2NWanFZSU5r?=
 =?utf-8?B?SmtGZnpqY3ZjVWY3aXRkQVFiRU90V2NzQ0piclpnUGthZTJSaWhpa3lDR29V?=
 =?utf-8?B?VUYwZVZBTEMreFR4V1dTd2kxTHZya2ZIRHpYWGhKNDV0OGZybVlIVHA5UjI4?=
 =?utf-8?B?dW5kWnlybXI5eHllRUsyU2hobUF3UmgxQi80ZlQwbnoweHYxSkhRQXdvL2dD?=
 =?utf-8?B?NHN3TExsckhRNTRhaWhtVmZpTW1wUzVUWUpFek9GRzZycnlIQ2ZZVEhLMTdV?=
 =?utf-8?B?WHg5UEF4WTBOQTE0S0VsRUIzUURHeTdLSHRyYjh0YW5mVlRsMEdlazRYVEJa?=
 =?utf-8?B?ei82ZWFzNi9GU1BnODNuVGhaUTFsdVQ4ek5PWU9OVEJRRHlxSWZvNFdUdkpG?=
 =?utf-8?Q?Cu3sBRbMe833PEklbOqte20v/?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37bcb05b-2457-4ac0-a46e-08db1bb1a2c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2023 06:36:35.6717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7y9w5XLJyJ480DfZjSMO9JVg+T/8YEvEp0fhZKxJ1dMlvLSialJ9rdW8yWlKS1yqSqlQUvIjoiOZMfJhxOOYhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5095
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogVGh1cnNkYXks
IE1hcmNoIDIsIDIwMjMgMTA6MjAgUE0NCj4gDQo+ID4gRnJvbTogSmFzb24gR3VudGhvcnBlIDxq
Z2dAbnZpZGlhLmNvbT4NCj4gPiBTZW50OiBUaHVyc2RheSwgTWFyY2ggMiwgMjAyMyA4OjM1IFBN
DQo+ID4NCj4gPiBPbiBUaHUsIE1hciAwMiwgMjAyMyBhdCAwOTo1NTo0NkFNICswMDAwLCBUaWFu
LCBLZXZpbiB3cm90ZToNCj4gPiA+ID4gRnJvbTogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRlbC5j
b20+DQo+ID4gPiA+IFNlbnQ6IFRodXJzZGF5LCBNYXJjaCAyLCAyMDIzIDI6MDcgUE0NCj4gPiA+
ID4NCj4gPiA+ID4gPiAtCQlpZiAoIXZmaW9fZGV2X2luX2dyb3VwcyhjdXJfdm1hLCBncm91cHMp
KSB7DQo+ID4gPiA+ID4gKwkJaWYgKGN1cl92bWEtPnZkZXYub3Blbl9jb3VudCAmJg0KPiA+ID4g
PiA+ICsJCSAgICAhdmZpb19kZXZfaW5fZ3JvdXBzKGN1cl92bWEsIGdyb3VwcykgJiYNCj4gPiA+
ID4gPiArCQkgICAgIXZmaW9fZGV2X2luX2lvbW11ZmRfY3R4KGN1cl92bWEsDQo+IGlvbW11ZmRf
Y3R4KSkgew0KPiA+ID4gPg0KPiA+ID4gPiBIaSBBbGV4LCBKYXNvbiwNCj4gPiA+ID4NCj4gPiA+
ID4gVGhlcmUgaXMgb25lIGNvbmNlcm4gb24gdGhpcyBhcHByb2FjaCB3aGljaCBpcyByZWxhdGVk
IHRvIHRoZQ0KPiA+ID4gPiBjZGV2IG5vaW9tbXUgbW9kZS4gQXMgcGF0Y2ggMTYgb2YgdGhpcyBz
ZXJpZXMsIGNkZXYgcGF0aA0KPiA+ID4gPiBzdXBwb3J0cyBub2lvbW11IG1vZGUgYnkgcGFzc2lu
ZyBhIG5lZ2F0aXZlIGlvbW11ZmQgdG8NCj4gPiA+ID4ga2VybmVsLiBJbiBzdWNoIGNhc2UsIHRo
ZSB2ZmlvX2RldmljZSBpcyBub3QgYm91bmQgdG8gYSB2YWxpZA0KPiA+ID4gPiBpb21tdWZkLiBU
aGVuIHRoZSBjaGVjayBpbiB2ZmlvX2Rldl9pbl9pb21tdWZkX2N0eCgpIGlzDQo+ID4gPiA+IHRv
IGJlIGJyb2tlbi4NCj4gPiA+ID4NCj4gPiA+ID4gQW4gaWRlYSBpcyB0byBhZGQgYSBjZGV2X25v
aW9tbXUgZmxhZyBpbiB2ZmlvX2RldmljZSwgd2hlbg0KPiA+ID4gPiBjaGVja2luZyB0aGUgaW9t
bXVmZF9pY3R4LCBhbHNvIGNoZWNrIHRoaXMgZmxhZy4gSWYgYWxsIHRoZSBvcGVuZWQNCj4gPiA+
ID4gZGV2aWNlcyBpbiB0aGUgZGV2X3NldCBoYXZlIHZmaW9fZGV2aWNlLT5jZGV2X25vaW9tbXU9
PXRydWUsDQo+ID4gPiA+IHRoZW4gdGhlIHJlc2V0IGlzIGNvbnNpZGVyZWQgdG8gYmUgZG9hYmxl
LiBCdXQgdGhlcmUgaXMgYSBzcGVjaWFsDQo+ID4gPiA+IGNhc2UuIElmIGRldmljZXMgaW4gdGhp
cyBkZXZfc2V0IGFyZSBvcGVuZWQgYnkgdHdvIGFwcGxpY2F0aW9ucw0KPiA+ID4gPiB0aGF0IG9w
ZXJhdGVzIGluIGNkZXYgbm9pb21tdSBtb2RlLCB0aGVuIHRoaXMgbG9naWMgaXMgbm90IGFibGUN
Cj4gPiA+ID4gdG8gZGlmZmVyZW50aWF0ZSB0aGVtLiBJbiB0aGF0IGNhc2UsIHNob3VsZCB3ZSBh
bGxvdyB0aGUgcmVzZXQ/DQo+ID4gPiA+IEl0IHNlZW1zIHRvIG9rIHRvIGFsbG93IHJlc2V0IHNp
bmNlIG5vaW9tbXUgbW9kZSBpdHNlbGYgbWVhbnMNCj4gPiA+ID4gbm8gc2VjdXJpdHkgYmV0d2Vl
biB0aGUgYXBwbGljYXRpb25zIHRoYXQgdXNlIGl0LiB0aG91Z2h0cz8NCj4gPiA+ID4NCj4gPiA+
DQo+ID4gPiBQcm9iYWJseSB3ZSBuZWVkIHN0aWxsIHBhc3MgaW4gYSB2YWxpZCBpb21tdWZkIChp
bnN0ZWFkIG9mIHVzaW5nDQo+ID4gPiBhIG5lZ2F0aXZlIHZhbHVlKSBpbiBub2lvbW11IGNhc2Ug
dG8gbWFyayB0aGUgb3duZXJzaGlwIHNvIHRoZQ0KPiA+ID4gY2hlY2sgaW4gdGhlIHJlc2V0IHBh
dGggY2FuIGNvcnJlY3RseSBjYXRjaCB3aGV0aGVyIGFuIG9wZW5lZA0KPiA+ID4gZGV2aWNlIGJl
bG9uZ3MgdG8gdGhpcyB1c2VyLg0KPiA+DQo+ID4gVGhlcmUgc2hvdWxkIGJlIG5vIGlvbW11ZmQg
YXQgYWxsIGluIG5vLWlvbW11IG1vZGUNCj4gPg0KPiA+IEFkZGluZyBvbmUganVzdCB0byBkZWFs
IHdpdGggbm9pb21tdSByZXNldCBzZWVtcyBwcmV0dHkgc2FkIDpcDQo+ID4NCj4gPiBuby1pb21t
dSBpcyBvbmx5IHJlYWxseSB1c2VkIGJ5IGRwZGssIGFuZCBpdCBkb2Vzbid0IGludm9rZQ0KPiA+
IFZGSU9fREVWSUNFX1BDSV9IT1RfUkVTRVQgYXQgYWxsLg0KPiANCj4gRG9lcyBpdCBoYXBwZW4g
dG8gYmUgb3IgYnkgZGVzaWduLCB0aGlzIGlvY3RsIGlzIG5vdCBuZWVkZWQgYnkgZHBkaz8NCg0K
dXNlIG9mIG5vaW9tbXUgc2hvdWxkIGJlIGRpc2NvdXJhZ2VkLg0KDQppZiBvbmx5IGtub3duIG5v
aW9tbXUgdXNlciBkb2Vzbid0IHVzZSBpdCB0aGVuIGhhdmluZyBjZXJ0YWluDQpuZXcgcmVzdHJp
Y3Rpb24gZm9yIG5vaW9tbXUgaW4gdGhlIGhvdCByZXNldCBwYXRoIG1pZ2h0IGJlIGFuDQphY2Nl
cHRhYmxlIHRyYWRlb2ZmLg0KDQpidXQgYWdhaW4gbmVlZHMgQWxleCdzIGlucHV0IGFzIGhlIGtu
b3dzIGFsbCB0aGUgaGlzdG9yeSBhYm91dA0Kbm9pb21tdS4g8J+Yig0KDQo+IA0KPiA+IEknZCBz
YXkgYXMgbG9uZyBhcyBWRklPX0RFVklDRV9QQ0lfSE9UX1JFU0VUIHdvcmtzIGlmIG9ubHkgb25l
IHZmaW8NCj4gPiBkZXZpY2UgaXMgb3BlbiB1c2luZyBhIGVtcHR5IGxpc3QgKGVnIHdlIHNob3Vs
ZCBlbnN1cmUgdGhhdCB0aGUNCj4gPiBpbnZva2luZyBjZGV2IGl0c2VsZiBpcyBhbGxvd2VkKSB0
aGVuIEkgdGhpbmsgaXQgaXMgT0suDQo+IA0KPiBTb3JyeSwgd2hpY2ggZW1wdHkgbGlzdCBhcmUg
eW91ciByZWZlcnJpbmc/DQo+IA0KDQpJIGd1ZXNzIGl0IHJlZmVycyB0byB6ZXJvLWxlbmd0aCBm
ZCBhcnJheS4NCg0KQnV0IElNSE8gdGhpcyByZXN0cmljdGlvbiBiZXR0ZXIgb25seSBhcHBsaWVz
IHRvIHRoZSBjYXNlIHdoZXJlDQpub2lvbW11IGRldmljZSAoaW9tbXVmZF9jdHg9TlVMTCkgZXhp
c3RzIGluIHRoZSBkZXZpY2Ugc2V0Lg0KDQpvdGhlcndpc2Ugd2Ugc3RpbGwgY29tcGFyZSBpb21t
dWZkX2N0eCB3aGVuIG11bHRpcGxlIGRldmljZXMNCmFyZSBvcGVuZWQuDQoNClRoZW4gdGhlIGlt
cGFjdCB0byBub2lvbW11IGNhc2UgaXMganVzdCB0aGF0IHVzZXIgY2Fubm90IGRvDQpob3QgcmVz
ZXQgd2hlbiBpdCBvcGVucyBtdWx0aXBsZSBkZXZpY2VzIGluIGEgc2FtZSBzZXQuDQoNCg==
