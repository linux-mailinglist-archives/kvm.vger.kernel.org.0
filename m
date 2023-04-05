Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 561246D767C
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 10:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237436AbjDEIK5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 04:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237404AbjDEIKv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 04:10:51 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D845256;
        Wed,  5 Apr 2023 01:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680682233; x=1712218233;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fK9Te7Pr/jjQPAcO9wVT5iJgrR3AjVs+rWUG0smd/7A=;
  b=dZ8BYddbWnZKTjzzuP2ECyCHHPV9zG2+ACrfv6Wf4gDw4rPmjNaEDRj+
   dLHnoUv6l8rB8WBI1z464D6w+sJVjaTRn7nXV3SXs96ODdkq549TApTVD
   aBSmyd6W3RzjC32Gm2gnthB6P9NvRP/zwOolL2UNQXA3COk2l2oirrDjr
   N8Jeqs4rqq2ryaNQdGg8yEMLQh8/KvFQPSHfX+qMJTcyqTGgYUC1i3B00
   aW4tu9yCQBl39t7fP2T6X3nzjpSqIW/1gwzm4NxAUOYX9rnXdgIVXV/cT
   HuasIo65bVbTAtgoPNgo+lZoRlgxe4u2obh/ppA7+TklF+WyH3XR8qCn6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="428681499"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="428681499"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 01:10:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="830277824"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="830277824"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 05 Apr 2023 01:10:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 01:10:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 01:10:09 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 01:09:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=POVbd98TtvvZiY/B+1vVfulGVgK8zHj9I845issgVugCHXHl0pmYn7B2KBK731qgzGcs7Qc+N1sCgjlbTXleVWky1lAUZ2xsPC0DJxgDNRruRSay6u26TRbX6/5MTMgOcPdVzUaeeogLxv30p+qFSJMZ2/8PgVUPk5r97bAcFx1LRh8XeO3dSd+H+gU+XNx3rTFAqtz3Hlc8dloa9ZHP4m+09pqm6sEXqClDK/8UGVMPuMQkAnDIiBZ1JcFBNnhJZfJh1nuO6KEJU59jUdptTwQ7Yt8M9w2MOnR8wYN6+gD/7NGvD+Hupa0dj90obc+0KdBBZkx4+rF8WjgDCQ+qqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fK9Te7Pr/jjQPAcO9wVT5iJgrR3AjVs+rWUG0smd/7A=;
 b=GRo05LTFgVWnbXrYwtulaFIi76b3WCSyOLwTDU7NeVEzBSF18kTqfSx4x3ucCXYGvF+l8SOqwq6cBFtfcDtrI59EthPaHbRUdsyh+UMhJvGzc5tYvcbDkQ4gZYpdJ6Q+YPPgX0HxgxSk4dgCTI5Adw5ypRm3kXW8gzLlwl0cp5rroweK7B9BzJ0BixMjo8svmDEwh19AaUAkcDK3QPkl2uSU0bIO9s837TSoK7YwCmihmwPh0rs8rg9pzSf6Tt+n5M/Eq7zI0zucM9qruTd6gdbM4JG/VNO1Yt0ZAz8evuWVlKvXBtGLLN0lwP4YIX0evf4iQ9ADYypn+zviWaghHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB7711.namprd11.prod.outlook.com (2603:10b6:510:291::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Wed, 5 Apr
 2023 08:09:46 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 08:09:46 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v3 05/12] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v3 05/12] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZZKh/F8Y4f47WR0u72nj77BeY3q8bm/YAgADElYCAAACGgA==
Date:   Wed, 5 Apr 2023 08:09:46 +0000
Message-ID: <DS0PR11MB7529164152B72471F9A93C55C3909@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-6-yi.l.liu@intel.com>
 <20230404141838.6a4efdd4.alex.williamson@redhat.com>
 <ee82cf0c-d208-ddac-5e00-ab34ca840c49@redhat.com>
In-Reply-To: <ee82cf0c-d208-ddac-5e00-ab34ca840c49@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH0PR11MB7711:EE_
x-ms-office365-filtering-correlation-id: 7ea9ec87-f701-4760-379b-08db35ad1e8f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hfvqx0fEpEj65tppnq92xAceHMbUOE/rUWILG7xab0KbFbpBSIk/iIkJNst44hfHQAc2TjzCVOmq4mQovIugulzkmC8XOnmFPJbAtGPix0i/o/4ypUP0vUbdUpP7u87ifJNyv91gzhK3BdwHLYDdBlMze4qGdPt2P6y4Llu4xnQoBhZei43295Cio8Zz6HjsrHWunEJrpRQuRcMyq1pjRjc44hWFpeBIyaVJcCj76t86azdFe4d+huJx0ihL0/aoqowbSKqr1dVrDFxLslfjSElPfVX5enQ+saNVJPVM5oGPUYxpxHaUpdWaAHCdimGgZVqckkam1LLJs6Fcefl/FmrnFvfBrxTZ6vRGuit2aH1NXB0ZndTwUELlffE+thLGCyUOhTGtejlC2wCo3Vyqo9xxMY+//8EIoVQX+qx5b753sdupF8xTJBYaUM6Ubv0NVXuInNMJXAqii7vYbGyxIFxDXe/Z774xoYZx0FXUGtMbXpshJWK19nr5StrKdzEImsysPtLl0IgzZ9Jvc42DpcTxZtqeJphtFzYy2I0qGL+NcHse0hf2CbrfNLfXhmVN6PSgB4aGA2qBqcNn+EzVXzurl4FF2oCwcNGLURlm26kOVEndMxcpomCs+nnVb7tI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(376002)(39860400002)(396003)(451199021)(8676002)(64756008)(66476007)(54906003)(66946007)(110136005)(66446008)(966005)(76116006)(4326008)(66556008)(316002)(33656002)(26005)(83380400001)(53546011)(122000001)(6506007)(186003)(9686003)(7416002)(71200400001)(8936002)(478600001)(55016003)(38100700002)(5660300002)(7696005)(41300700001)(2906002)(38070700005)(86362001)(52536014)(82960400001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R2UrK0FiRzhnMXlmUnovdjA3bGdDTzhwMllwcklNamhVVmV0dFFlUlFDZlAw?=
 =?utf-8?B?YXcxSk9lTExEczZTSURNamhhemswWGlzR1BWd1hSVlRZaGdtdVA2KzgzN1kw?=
 =?utf-8?B?eXVrK2Y0eXZweGJRcFlpRHpsb1krY1IzRjZiTXVVMTMvMzZWOWIzREttNExG?=
 =?utf-8?B?M2V1SkNMVEcxcmRDWHZPYTFSL2hTM0UvK1VVK1Q2RzBqRXpTYW9jKytrY25Z?=
 =?utf-8?B?SG56dlJHMVpNK3hqeG4vQmJHNFY0NGhweml3NEtzWUJMVmxPUll0UHFQUm9K?=
 =?utf-8?B?eFcra1dMVVN4cWNIVis4L09LUkRhQlFuZEJuNVpzTFA5UTNWSy9ta1A3dG9l?=
 =?utf-8?B?NmZMRzRCZC9rakVmSTdLMGlIMlVGalhyYWo5cW44anBmWkVUSENnaG9ROWVs?=
 =?utf-8?B?MDJOd2xIenExRTBBU0JVandwOEdldWdBdEg3d2p6OHZ5WU91U3B6WElveWk5?=
 =?utf-8?B?N011WDM4NHU5N0xMRm1naDlnZnh2cExncGp4MzRBUUF6enA2cldqV2RhS3gr?=
 =?utf-8?B?QTdGNEVYajF2bFBvTnVDajN5bWR5OHN6ajVSaHlxYmt1WXlCc1Z5UE9sUXh2?=
 =?utf-8?B?Uno4SnhpN1NCaUlycW5WT3plWkczSVFzUEJrSHBhWTlVV3I1YVBQOUFDdkli?=
 =?utf-8?B?T00xVGVyeFFhZnZjODc1b3FUQkxkVzlEcDVlQkdHNndoQmZCT2lSckgyWm1S?=
 =?utf-8?B?aWZZdU5HTmtQcFdTT01HaHB4WDZvZ0hmN0dvMHIwaWhKeWJ2R2t5b0daRTU4?=
 =?utf-8?B?YWpMalFnaCtYRXBpZEdQK08zMzdzYmR3anpHbkRTd2JjaHoxTnBIMytYWkJK?=
 =?utf-8?B?czZ2bmxacUQ4eG1KR1VBL3Z3bVVZaGgwWnFyWFpzdUozSUpRRXl6UHg1TmZQ?=
 =?utf-8?B?WWpoMkFYUTZhb3FoRGlXTzMwaENDMmZjbUNObTEva2MydU1ITEZnSUltNlRC?=
 =?utf-8?B?bVlyVHdHWXJPbTR4ZkNSTnUxTVJVcWlxekd5RlRnOUtGSEJhMmtGTjV1ejdR?=
 =?utf-8?B?czJNMzBlb2VESlR5K0hwTzJMTktXcElvUG1xNVJzRlViUEVpNVJGbXMreDZZ?=
 =?utf-8?B?RkdXTXRtNTY0TWU2TFdib0FuRE5WcHZaRHY3LzZYSTROeFFaVy8ySFdvUUg2?=
 =?utf-8?B?UXZ2WnRrdE82ZUQrVGdJMDVhOGgzclN1cGRtREJQWWdlWXJMNlpaRU4yMUFS?=
 =?utf-8?B?VVpSTWVOUFY5cEo0TzNaQVpNU1V3clZaODdrVndlVTludDY3a3RlV3FKMDdB?=
 =?utf-8?B?Y3A2L0pqTG1CZitIOTllanJUNytLU0htOVJTbExETWxzTlhPQmxHeUc0a2k4?=
 =?utf-8?B?V2ZIR21tUjRndXlWQ1MzR1BzQThMTGM1WEx4Q244QnprRGIvME5Fckg0ajlY?=
 =?utf-8?B?cEhzSFVVLzNZY1ZZRGdXdU9TY3BrRXlzOXo4MFY4UU5FaVMwTml3YTZ1WGxS?=
 =?utf-8?B?MEplRTBlRkhBZGJNK2tJdzVTZnVSRGRvUklJY2ZUWFFJTXZoQWlvRDRkaStO?=
 =?utf-8?B?V0E4VUoyOGFvVnkyNDM1dEJ2R0xHN3gyYnREQjZNdHJiTFNiOVBpaXFmd3ZG?=
 =?utf-8?B?WHpVMSszSWxiWTVURlFMcExqMnBZNWt4ZGhYd08wUWxnMExPL3pMdG5mZ3BE?=
 =?utf-8?B?M0g1VU5wemZSa3VKd096SGJDUFlHRjZobnBtS1lvSXBqMklDa3lpejROWndO?=
 =?utf-8?B?aGczV1ZsWVh0bDZHdnREa04xOVN2Wm5MemRISDlhYnlhSytVVEFPUWVkN2Vt?=
 =?utf-8?B?SXBCNXN2NDg3RlRJdkhxNjRrWFZzWE8rNlhBU1NIRXhyb0FXQ1Z1WGREWEZ5?=
 =?utf-8?B?Zm5CTnYxcUw5NUo3SyszZ0dhYnhoN1Z2Wm5PeUtLeWZ6K0NhNFk0dGJpbmQ4?=
 =?utf-8?B?c2R1Nk1zZVE2NWRXcmMyNUFac1V5WkU3cUNQVXFtOUZINUg1SXpJUGk1WXlD?=
 =?utf-8?B?QUhJTkxIdVFqR0tBdVN4Z0p3bzFJa2VKNXUyTFlMWUVXa2FmaEVOdDgwdEE2?=
 =?utf-8?B?QitpMGZPVXc0ZitMRzZKQjM1OEwxemVpL1FwM1E4RGhVL3NZVUtxWDVaSGpv?=
 =?utf-8?B?a3g2QWZBY1VYY28zcU9zSURtR0N1Q1dhNW8rRUlia3Y0MWVVazhWdnlaelNl?=
 =?utf-8?Q?rz4qpQy1xk0KaYD51JkIPtgSt?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ea9ec87-f701-4760-379b-08db35ad1e8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 08:09:46.1205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F8/xYONHWWraAnrEeBwDLTP4HRp0i6nDlhdspE9iy67DNKCv1UC9qGGGjX/EqcSZZnXjyIjohLOS280jsGstlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7711
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFdlZG5lc2RheSwgQXByaWwgNSwgMjAyMyA0OjAyIFBNIA0KPiANCj4gT24gNC80LzIz
IDIyOjE4LCBBbGV4IFdpbGxpYW1zb24gd3JvdGU6DQo+ID4gT24gU2F0LCAgMSBBcHIgMjAyMyAw
Nzo0NDoyMiAtMDcwMA0KPiA+IFlpIExpdSA8eWkubC5saXVAaW50ZWwuY29tPiB3cm90ZToNCj4g
Pg0KPiA+PiBhcyBhbiBhbHRlcm5hdGl2ZSBtZXRob2QgZm9yIG93bmVyc2hpcCBjaGVjayB3aGVu
IGlvbW11ZmQgaXMgdXNlZC4gSW4NCj4gPj4gdGhpcyBjYXNlIGFsbCBvcGVuZWQgZGV2aWNlcyBp
biB0aGUgYWZmZWN0ZWQgZGV2X3NldCBhcmUgdmVyaWZpZWQgdG8NCj4gPj4gYmUgYm91bmQgdG8g
YSBzYW1lIHZhbGlkIGlvbW11ZmQgdmFsdWUgdG8gYWxsb3cgcmVzZXQuIEl0J3Mgc2ltcGxlcg0K
PiA+PiBhbmQgZmFzdGVyIGFzIHVzZXIgZG9lcyBub3QgbmVlZCB0byBwYXNzIGEgc2V0IG9mIGZk
cyBhbmQga2VybmVsIG5vDQo+ID4+IG5lZWQgdG8gc2VhcmNoIHRoZSBkZXZpY2Ugd2l0aGluIHRo
ZSBnaXZlbiBmZHMuDQo+ID4+DQo+ID4+IGEgZGV2aWNlIGluIG5vaW9tbXUgbW9kZSBkb2Vzbid0
IGhhdmUgYSB2YWxpZCBpb21tdWZkLCBzbyB0aGlzIG1ldGhvZA0KPiA+PiBzaG91bGQgbm90IGJl
IHVzZWQgaW4gYSBkZXZfc2V0IHdoaWNoIGNvbnRhaW5zIG11bHRpcGxlIGRldmljZXMgYW5kIG9u
ZQ0KPiA+PiBvZiB0aGVtIGlzIGluIG5vaW9tbXUuIFRoZSBvbmx5IGFsbG93ZWQgbm9pb21tdSBz
Y2VuYXJpbyBpcyB0aGF0IHRoZQ0KPiA+PiBjYWxsaW5nIGRldmljZSBpcyBub2lvbW11IGFuZCBp
dCdzIGluIGEgc2luZ2xldG9uIGRldl9zZXQuDQo+ID4+DQo+ID4+IFN1Z2dlc3RlZC1ieTogSmFz
b24gR3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4NCj4gPj4gU2lnbmVkLW9mZi1ieTogSmFzb24g
R3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4NCj4gPj4gUmV2aWV3ZWQtYnk6IEphc29uIEd1bnRo
b3JwZSA8amdnQG52aWRpYS5jb20+DQo+ID4+IFRlc3RlZC1ieTogWWFudGluZyBKaWFuZyA8eWFu
dGluZy5qaWFuZ0BpbnRlbC5jb20+DQo+ID4+IFNpZ25lZC1vZmYtYnk6IFlpIExpdSA8eWkubC5s
aXVAaW50ZWwuY29tPg0KPiA+PiAtLS0NCj4gPj4gIGRyaXZlcnMvdmZpby9wY2kvdmZpb19wY2lf
Y29yZS5jIHwgNDIgKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0NCj4gPj4gIGluY2x1
ZGUvdWFwaS9saW51eC92ZmlvLmggICAgICAgIHwgIDkgKysrKysrLQ0KPiA+PiAgMiBmaWxlcyBj
aGFuZ2VkLCA0NCBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0KPiA+Pg0KPiA+PiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9jb3JlLmMgYi9kcml2ZXJzL3ZmaW8v
cGNpL3ZmaW9fcGNpX2NvcmUuYw0KPiA+PiBpbmRleCAzNjk2YjhlNTg0NDUuLmI2OGZjYmE2N2E0
YiAxMDA2NDQNCj4gPj4gLS0tIGEvZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9jb3JlLmMNCj4g
Pj4gKysrIGIvZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9jb3JlLmMNCj4gPj4gQEAgLTE4MCw3
ICsxODAsOCBAQCBzdGF0aWMgdm9pZCB2ZmlvX3BjaV9wcm9iZV9tbWFwcyhzdHJ1Y3QNCj4gdmZp
b19wY2lfY29yZV9kZXZpY2UgKnZkZXYpDQo+ID4+ICBzdHJ1Y3QgdmZpb19wY2lfZ3JvdXBfaW5m
bzsNCj4gPj4gIHN0YXRpYyB2b2lkIHZmaW9fcGNpX2Rldl9zZXRfdHJ5X3Jlc2V0KHN0cnVjdCB2
ZmlvX2RldmljZV9zZXQgKmRldl9zZXQpOw0KPiA+PiAgc3RhdGljIGludCB2ZmlvX3BjaV9kZXZf
c2V0X2hvdF9yZXNldChzdHJ1Y3QgdmZpb19kZXZpY2Vfc2V0ICpkZXZfc2V0LA0KPiA+PiAtCQkJ
CSAgICAgIHN0cnVjdCB2ZmlvX3BjaV9ncm91cF9pbmZvICpncm91cHMpOw0KPiA+PiArCQkJCSAg
ICAgIHN0cnVjdCB2ZmlvX3BjaV9ncm91cF9pbmZvICpncm91cHMsDQo+ID4+ICsJCQkJICAgICAg
c3RydWN0IGlvbW11ZmRfY3R4ICppb21tdWZkX2N0eCk7DQo+ID4+DQo+ID4+ICAvKg0KPiA+PiAg
ICogSU5UeCBtYXNraW5nIHJlcXVpcmVzIHRoZSBhYmlsaXR5IHRvIGRpc2FibGUgSU5UeCBzaWdu
YWxpbmcgdmlhIFBDSV9DT01NQU5EDQo+ID4+IEBAIC0xMjc3LDcgKzEyNzgsNyBAQCB2ZmlvX3Bj
aV9pb2N0bF9wY2lfaG90X3Jlc2V0X2dyb3VwcyhzdHJ1Y3QNCj4gdmZpb19wY2lfY29yZV9kZXZp
Y2UgKnZkZXYsDQo+ID4+ICAJCXJldHVybiByZXQ7DQo+ID4+DQo+ID4+ICAJLyogU29tZXdoZXJl
IGJldHdlZW4gMSBhbmQgY291bnQgaXMgT0sgKi8NCj4gPj4gLQlpZiAoIWhkci0+Y291bnQgfHwg
aGRyLT5jb3VudCA+IGNvdW50KQ0KPiA+PiArCWlmIChoZHItPmNvdW50ID4gY291bnQpDQo+ID4+
ICAJCXJldHVybiAtRUlOVkFMOw0KPiA+Pg0KPiA+PiAgCWdyb3VwX2ZkcyA9IGtjYWxsb2MoaGRy
LT5jb3VudCwgc2l6ZW9mKCpncm91cF9mZHMpLCBHRlBfS0VSTkVMKTsNCj4gPj4gQEAgLTEzMjYs
NyArMTMyNyw3IEBAIHZmaW9fcGNpX2lvY3RsX3BjaV9ob3RfcmVzZXRfZ3JvdXBzKHN0cnVjdA0K
PiB2ZmlvX3BjaV9jb3JlX2RldmljZSAqdmRldiwNCj4gPj4gIAlpbmZvLmNvdW50ID0gaGRyLT5j
b3VudDsNCj4gPj4gIAlpbmZvLmZpbGVzID0gZmlsZXM7DQo+ID4+DQo+ID4+IC0JcmV0ID0gdmZp
b19wY2lfZGV2X3NldF9ob3RfcmVzZXQodmRldi0+dmRldi5kZXZfc2V0LCAmaW5mbyk7DQo+ID4+
ICsJcmV0ID0gdmZpb19wY2lfZGV2X3NldF9ob3RfcmVzZXQodmRldi0+dmRldi5kZXZfc2V0LCAm
aW5mbywgTlVMTCk7DQo+ID4+DQo+ID4+ICBob3RfcmVzZXRfcmVsZWFzZToNCj4gPj4gIAlmb3Ig
KGZpbGVfaWR4LS07IGZpbGVfaWR4ID49IDA7IGZpbGVfaWR4LS0pDQo+ID4+IEBAIC0xMzQxLDYg
KzEzNDIsNyBAQCBzdGF0aWMgaW50IHZmaW9fcGNpX2lvY3RsX3BjaV9ob3RfcmVzZXQoc3RydWN0
DQo+IHZmaW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2LA0KPiA+PiAgew0KPiA+PiAgCXVuc2lnbmVk
IGxvbmcgbWluc3ogPSBvZmZzZXRvZmVuZChzdHJ1Y3QgdmZpb19wY2lfaG90X3Jlc2V0LCBjb3Vu
dCk7DQo+ID4+ICAJc3RydWN0IHZmaW9fcGNpX2hvdF9yZXNldCBoZHI7DQo+ID4+ICsJc3RydWN0
IGlvbW11ZmRfY3R4ICppb21tdWZkOw0KPiA+PiAgCWJvb2wgc2xvdCA9IGZhbHNlOw0KPiA+Pg0K
PiA+PiAgCWlmIChjb3B5X2Zyb21fdXNlcigmaGRyLCBhcmcsIG1pbnN6KSkNCj4gPj4gQEAgLTEz
NTUsNyArMTM1NywxMiBAQCBzdGF0aWMgaW50IHZmaW9fcGNpX2lvY3RsX3BjaV9ob3RfcmVzZXQo
c3RydWN0DQo+IHZmaW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2LA0KPiA+PiAgCWVsc2UgaWYgKHBj
aV9wcm9iZV9yZXNldF9idXModmRldi0+cGRldi0+YnVzKSkNCj4gPj4gIAkJcmV0dXJuIC1FTk9E
RVY7DQo+ID4+DQo+ID4+IC0JcmV0dXJuIHZmaW9fcGNpX2lvY3RsX3BjaV9ob3RfcmVzZXRfZ3Jv
dXBzKHZkZXYsICZoZHIsIHNsb3QsIGFyZyk7DQo+ID4+ICsJaWYgKGhkci5jb3VudCkNCj4gPj4g
KwkJcmV0dXJuIHZmaW9fcGNpX2lvY3RsX3BjaV9ob3RfcmVzZXRfZ3JvdXBzKHZkZXYsICZoZHIs
IHNsb3QsIGFyZyk7DQo+ID4+ICsNCj4gPj4gKwlpb21tdWZkID0gdmZpb19pb21tdWZkX3BoeXNp
Y2FsX2ljdHgoJnZkZXYtPnZkZXYpOw0KPiA+PiArDQo+ID4+ICsJcmV0dXJuIHZmaW9fcGNpX2Rl
dl9zZXRfaG90X3Jlc2V0KHZkZXYtPnZkZXYuZGV2X3NldCwgTlVMTCwgaW9tbXVmZCk7DQo+ID4+
ICB9DQo+ID4+DQo+ID4+ICBzdGF0aWMgaW50IHZmaW9fcGNpX2lvY3RsX2lvZXZlbnRmZChzdHJ1
Y3QgdmZpb19wY2lfY29yZV9kZXZpY2UgKnZkZXYsDQo+ID4+IEBAIC0yMzI3LDYgKzIzMzQsOSBA
QCBzdGF0aWMgYm9vbCB2ZmlvX2Rldl9pbl9ncm91cHMoc3RydWN0DQo+IHZmaW9fcGNpX2NvcmVf
ZGV2aWNlICp2ZGV2LA0KPiA+PiAgew0KPiA+PiAgCXVuc2lnbmVkIGludCBpOw0KPiA+Pg0KPiA+
PiArCWlmICghZ3JvdXBzKQ0KPiA+PiArCQlyZXR1cm4gZmFsc2U7DQo+ID4+ICsNCj4gPj4gIAlm
b3IgKGkgPSAwOyBpIDwgZ3JvdXBzLT5jb3VudDsgaSsrKQ0KPiA+PiAgCQlpZiAodmZpb19maWxl
X2hhc19kZXYoZ3JvdXBzLT5maWxlc1tpXSwgJnZkZXYtPnZkZXYpKQ0KPiA+PiAgCQkJcmV0dXJu
IHRydWU7DQo+ID4+IEBAIC0yNDAyLDEzICsyNDEyLDI1IEBAIHN0YXRpYyBpbnQgdmZpb19wY2lf
ZGV2X3NldF9wbV9ydW50aW1lX2dldChzdHJ1Y3QNCj4gdmZpb19kZXZpY2Vfc2V0ICpkZXZfc2V0
KQ0KPiA+PiAgCXJldHVybiByZXQ7DQo+ID4+ICB9DQo+ID4+DQo+ID4+ICtzdGF0aWMgYm9vbCB2
ZmlvX2Rldl9pbl9pb21tdWZkX2N0eChzdHJ1Y3QgdmZpb19wY2lfY29yZV9kZXZpY2UgKnZkZXYs
DQo+ID4+ICsJCQkJICAgIHN0cnVjdCBpb21tdWZkX2N0eCAqaW9tbXVmZF9jdHgpDQo+ID4+ICt7
DQo+ID4+ICsJc3RydWN0IGlvbW11ZmRfY3R4ICppb21tdWZkID0gdmZpb19pb21tdWZkX3BoeXNp
Y2FsX2ljdHgoJnZkZXYtPnZkZXYpOw0KPiA+PiArDQo+ID4+ICsJaWYgKCFpb21tdWZkKQ0KPiA+
PiArCQlyZXR1cm4gZmFsc2U7DQo+ID4+ICsNCj4gPj4gKwlyZXR1cm4gaW9tbXVmZCA9PSBpb21t
dWZkX2N0eDsNCj4gPj4gK30NCj4gPj4gKw0KPiA+PiAgLyoNCj4gPj4gICAqIFdlIG5lZWQgdG8g
Z2V0IG1lbW9yeV9sb2NrIGZvciBlYWNoIGRldmljZSwgYnV0IGRldmljZXMgY2FuIHNoYXJlIG1t
YXBfbG9jaywNCj4gPj4gICAqIHRoZXJlZm9yZSB3ZSBuZWVkIHRvIHphcCBhbmQgaG9sZCB0aGUg
dm1hX2xvY2sgZm9yIGVhY2ggZGV2aWNlLCBhbmQgb25seSB0aGVuDQo+ID4+ICAgKiBnZXQgZWFj
aCBtZW1vcnlfbG9jay4NCj4gPj4gICAqLw0KPiA+PiAgc3RhdGljIGludCB2ZmlvX3BjaV9kZXZf
c2V0X2hvdF9yZXNldChzdHJ1Y3QgdmZpb19kZXZpY2Vfc2V0ICpkZXZfc2V0LA0KPiA+PiAtCQkJ
CSAgICAgIHN0cnVjdCB2ZmlvX3BjaV9ncm91cF9pbmZvICpncm91cHMpDQo+ID4+ICsJCQkJICAg
ICAgc3RydWN0IHZmaW9fcGNpX2dyb3VwX2luZm8gKmdyb3VwcywNCj4gPj4gKwkJCQkgICAgICBz
dHJ1Y3QgaW9tbXVmZF9jdHggKmlvbW11ZmRfY3R4KQ0KPiA+PiAgew0KPiA+PiAgCXN0cnVjdCB2
ZmlvX3BjaV9jb3JlX2RldmljZSAqY3VyX21lbTsNCj4gPj4gIAlzdHJ1Y3QgdmZpb19wY2lfY29y
ZV9kZXZpY2UgKmN1cl92bWE7DQo+ID4+IEBAIC0yNDQ4LDkgKzI0NzAsMTcgQEAgc3RhdGljIGlu
dCB2ZmlvX3BjaV9kZXZfc2V0X2hvdF9yZXNldChzdHJ1Y3QNCj4gdmZpb19kZXZpY2Vfc2V0ICpk
ZXZfc2V0LA0KPiA+PiAgCQkgKg0KPiA+PiAgCQkgKiBPdGhlcndpc2UgYWxsIG9wZW5lZCBkZXZp
Y2VzIGluIHRoZSBkZXZfc2V0IG11c3QgYmUNCj4gPj4gIAkJICogY29udGFpbmVkIGJ5IHRoZSBz
ZXQgb2YgZ3JvdXBzIHByb3ZpZGVkIGJ5IHRoZSB1c2VyLg0KPiA+PiArCQkgKg0KPiA+PiArCQkg
KiBJZiB1c2VyIHByb3ZpZGVzIGEgemVyby1sZW5ndGggYXJyYXksIHRoZW4gYWxsIHRoZQ0KPiA+
PiArCQkgKiBvcGVuZWQgZGV2aWNlcyBtdXN0IGJlIGJvdW5kIHRvIGEgc2FtZSBpb21tdWZkX2N0
eC4NCj4gPj4gKwkJICoNCj4gPj4gKwkJICogSWYgYWxsIGFib3ZlIGNoZWNrcyBhcmUgZmFpbGVk
LCByZXNldCBpcyBhbGxvd2VkIG9ubHkgaWYNCj4gPj4gKwkJICogdGhlIGNhbGxpbmcgZGV2aWNl
IGlzIGluIGEgc2luZ2xldG9uIGRldl9zZXQuDQo+ID4+ICAJCSAqLw0KPiA+PiAgCQlpZiAoY3Vy
X3ZtYS0+dmRldi5vcGVuX2NvdW50ICYmDQo+ID4+IC0JCSAgICAhdmZpb19kZXZfaW5fZ3JvdXBz
KGN1cl92bWEsIGdyb3VwcykpIHsNCj4gPj4gKwkJICAgICF2ZmlvX2Rldl9pbl9ncm91cHMoY3Vy
X3ZtYSwgZ3JvdXBzKSAmJg0KPiA+PiArCQkgICAgIXZmaW9fZGV2X2luX2lvbW11ZmRfY3R4KGN1
cl92bWEsIGlvbW11ZmRfY3R4KSAmJg0KPiA+PiArCQkgICAgKGRldl9zZXQtPmRldmljZV9jb3Vu
dCA+IDEpKSB7DQo+ID4gVGhpcyBsYXN0IGNvbmRpdGlvbiBsb29rcyBidWdneSB0byBtZSwgd2Ug
bmVlZCBhbGwgY29uZGl0aW9ucyB0byBiZQ0KPiA+IHRydWUgdG8gZ2VuZXJhdGUgYW4gZXJyb3Ig
aGVyZSwgd2hpY2ggbWVhbnMgdGhhdCBmb3IgYSBzaW5nbGV0b24NCj4gPiBkZXZfc2V0LCBpdCBk
b2Vzbid0IG1hdHRlciB3aGF0IGdyb3VwIGZkcyBhcmUgcGFzc2VkLCBpZiBhbnksIG9yIHdoZXRo
ZXINCj4gPiB0aGUgaW9tbXVmZCBjb250ZXh0IG1hdGNoZXMuICBJIHRoaW5rIGluIGZhY3QgdGhp
cyBtZWFucyB0aGF0IHRoZSBlbXB0eQ0KPiA+IGFycmF5IHBhdGggaXMgZXF1YWxseSBhdmFpbGFi
bGUgZm9yIGdyb3VwIHVzZSBjYXNlcyB3aXRoIGEgc2luZ2xldG9uDQo+ID4gZGV2X3NldCwgYnV0
IHdlIGRvbid0IGVuYWJsZSBpdCBmb3IgbXVsdGlwbGUgZGV2aWNlIGRldl9zZXRzIGxpa2Ugd2Ug
ZG8NCj4gPiBpb21tdWZkLg0KPiA+DQo+ID4gWW91IHBvaW50ZWQgb3V0IGEgcHJldmlvdXMgaXNz
dWUgd2l0aCBob3QtcmVzZXQgaW5mbyBhbmQgbm8taW9tbXUgd2hlcmUNCj4gPiBpZiBvdGhlciBh
ZmZlY3RlZCBkZXZpY2VzIGFyZSBub3QgYm91bmQgdG8gdmZpby1wY2kgdGhlIGluZm8gaW9jdGwN
Cj4gPiByZXR1cm5zIGVycm9yLiAgVGhhdCdzIGhhbmRsZWQgaW4gdGhlIGhvdC1yZXNldCBpb2N0
bCBieSB0aGUgZmFjdCB0aGF0DQo+ID4gYWxsIGFmZmVjdGVkIGRldmljZXMgbXVzdCBiZSBpbiB0
aGUgZGV2X3NldCBhbmQgdGhlcmVmb3JlIGJvdW5kIHRvDQo+ID4gdmZpby1wY2kgZHJpdmVycy4g
IFNvIGl0IHNlZW1zIHRvIG1lIHRoYXQgYXNpZGUgZnJvbSB0aGUgc3B1cmlvdXMgZXJyb3INCj4g
PiBiZWNhdXNlIHdlIGNhbid0IHJlcG9ydCBhbiBpb21tdSBncm91cCB3aGVuIG5vbmUgZXhpc3Rz
LCBhbmQgZGlkbid0DQo+ID4gc3BvdCBpdCB0byBpbnZlbnQgYW4gaW52YWxpZCBncm91cCBmb3Ig
ZGVidWdnaW5nLCBob3QtcmVzZXQgb3RoZXJ3aXNlDQo+ID4gd29ya3Mgd2l0aCBuby1pb21tdSBq
dXN0IGxpa2UgaXQgZG9lcyBmb3IgaW9tbXUgYmFja2VkIGRldmljZXMuICBXZQ0KPiA+IGRvbid0
IGN1cnJlbnRseSByZXF1aXJlIHNpbmdsZXRvbiBuby1pb21tdSBkZXZfc2V0cyBhZmFpY3QuDQo+
ID4NCj4gPiBJJ2xsIGFsc28gbm90ZSB0aGF0IGlmIHRoZSBkZXZfc2V0IGlzIHNpbmdsZXRvbiwg
dGhpcyBzdWdnZXN0cyB0aGF0DQo+ID4gcGNpX3Jlc2V0X2Z1bmN0aW9uKCkgY2FuIG1ha2UgdXNl
IG9mIGJ1cyByZXNldCwgc28gYSBob3QtcmVzZXQgaXMNCj4gPiBhY2Nlc3NpYmxlIHZpYSBWRklP
X0RFVklDRV9SRVNFVCBpZiB0aGUgYXBwcm9wcmlhdGUgcmVzZXQgbWV0aG9kIGlzDQo+ID4gc2Vs
ZWN0ZWQuDQo+ID4NCj4gPiBUaGVyZWZvcmUsIEkgdGhpbmsgYXMgd3JpdHRlbiwgdGhlIHNpbmds
ZXRvbiBkZXZfc2V0IGhvdC1yZXNldCBpcw0KPiA+IGVuYWJsZWQgZm9yIGlvbW11ZmQgYW5kICh1
bmludGVudGlvbmFsbHk/KSBmb3IgdGhlIGdyb3VwIHBhdGgsIHdoaWxlDQo+ID4gYWxzbyBuZWdh
dGluZyBhIHJlcXVpcmVtZW50IGZvciBhIGdyb3VwIGZkIG9yIHRoYXQgYSBwcm92aWRlZCBncm91
cCBmZA0KPiA+IGFjdHVhbGx5IG1hdGNoZXMgdGhlIGRldmljZSBpbiB0aGlzIGxhdHRlciBjYXNl
LiAgVGhlIG51bGwtYXJyYXkNCj4gPiBhcHByb2FjaCBpcyBub3QgaG93ZXZlciBleHRlbmRlZCB0
byBncm91cHMgZm9yIG1vcmUgZ2VuZXJhbCB1c2UuDQo+ID4gQWRkaXRpb25hbGx5LCBsaW1pdGlu
ZyBuby1pb21tdSBob3QtcmVzZXQgdG8gc2luZ2xldG9uIGRldl9zZXRzDQo+ID4gcHJvdmlkZXMg
b25seSBhIG1hcmdpbmFsIGZ1bmN0aW9uYWwgZGlmZmVyZW5jZSB2cyBWRklPX0RFVklDRV9SRVNF
VC4NCj4gPiBUaGFua3MsDQo+ID4NCj4gPiBBbGV4DQo+IFdoYXQgYm91dCBpbnRyb2R1Y2luZyBh
IGhlbHBlcg0KPiBzdGF0aWMgYm9vbCBpc19yZXNldF9vayhwZGV2LCBncm91cHMsIGN0eCkgew0K
PiDCoMKgwqAgaWYgKCFwZGV2LT52ZGV2Lm9wZW5fY291bnQpDQo+IMKgwqDCoCDCoMKgwqAgcmV0
dXJuIHRydWU7DQo+IMKgwqDCoCBpZiAoZ3JvdXBzICYmIHZmaW9fZGV2X2luX2dyb3VwcyhwZGV2
LCBncm91cHMpKQ0KPiDCoMKgwqAgwqDCoMKgIHJldHVybiB0cnVlOw0KPiDCoMKgwqAgaWYgKGN0
eCAmJiB2ZmlvX2Rldl9pbl9pb21tdWZkX2N0eChwZGV2LCBjdHgpDQo+IMKgwqAgwqDCoMKgwqAg
cmV0dXJuIHRydWU7DQo+IMKgwqDCoCByZXR1cm4gZmFsc2U7DQo+IH0NCj4gDQo+IEFzc3VtaW5n
IHRoZSBhYm92ZSBsb2dpYyBpcyBjb3JyZWN0IEkgdGhpbmsgdGhpcyB3b3VsZCBtYWtlIHRoZSBj
b2RlDQo+IG1vcmUgcmVhZGFibGUNCg0KdGhpcyBsb2dpYyBtYXkgZmFpbCB0aGUgbm9pb21tdSBk
ZXZpY2VzIGluIHRoZSBjZGV2IHBhdGggYXMgdGhlDQpjZGV2IHBhdGggYmluZHMgdGhlIGRldmlj
ZXMgdG8gaW9tbXVmZD09LTEuIFRoZSBjdHggd291bGQgYmUNCk5VTEwuIFNvIHdlIGFncmVlZCB0
byBhbGxvdyB0aGUgcmVzZXQgaWYgdGhlIGRldl9zZXQgaXMgc2lnbGV0aW9uLg0KRGV0YWlsIGNh
biBiZSBmb3VuZCBpbiBiZWxvdyBwYXJhZ3JhcGguIEFzIEkgcmVwbGllZCBpbiBhbm90aGVyDQpl
bWFpbC4gTWF5YmUgdGhpcyBzaW5nbGV0b24gc3VwcG9ydCBjYW4gYmUgZHJvcHBlZCBzaW5jZSBz
aW5nbGV0b24NCmRldl9zZXQgbWF5IGp1c3QgZG8gcmVzZXQgd2l0aCBWRklPX0RFVklDRV9SRVNF
VC4gQWxleCBtYXkNCmNvcnJlY3QgbWUgaWYgdXNlcnNwYWNlIGlzIG5vdCBzbyBpbnRlbGxpZ2Vu
dC4NCg0KIkhvd2V2ZXIgdGhlIGlvbW11ZmQgbWV0aG9kIGhhcyBkaWZmaWN1bHR5IHdvcmtpbmcg
d2l0aCBub2lvbW11IGRldmljZXMNCnNpbmNlIHRob3NlIGRldmljZXMgZG9uJ3QgaGF2ZSBhIHZh
bGlkIGlvbW11ZmQsIHVubGVzcyB0aGUgbm9pb21tdSBkZXZpY2UNCmlzIGluIGEgc2luZ2xldG9u
IGRldl9zZXQgaGVuY2Ugbm8gb3duZXJzaGlwIGNoZWNrIGlzIHJlcXVpcmVkLiBbM10NCg0KWzNd
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS9aQUNYK05wJTJGSVk3eWdxTDVAbnZpZGlhLmNv
bS8iDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg0KPiBUaGFua3MNCj4gDQo+IEVyaWMNCj4gPj4gIAkJ
CXJldCA9IC1FSU5WQUw7DQo+ID4+ICAJCQlnb3RvIGVycl91bmRvOw0KPiA+PiAgCQl9DQo+ID4+
IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvdmZpby5oIGIvaW5jbHVkZS91YXBpL2xp
bnV4L3ZmaW8uaA0KPiA+PiBpbmRleCBmOTZlNTY4OWNmZmMuLjE3YWE1ZDA5ZGI0MSAxMDA2NDQN
Cj4gPj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L3ZmaW8uaA0KPiA+PiArKysgYi9pbmNsdWRl
L3VhcGkvbGludXgvdmZpby5oDQo+ID4+IEBAIC02NzksNyArNjc5LDE0IEBAIHN0cnVjdCB2Zmlv
X3BjaV9ob3RfcmVzZXRfaW5mbyB7DQo+ID4+ICAgKiB0aGUgY2FsbGluZyB1c2VyIG11c3QgZW5z
dXJlIGFsbCBhZmZlY3RlZCBkZXZpY2VzLCBpZiBvcGVuZWQsIGFyZQ0KPiA+PiAgICogb3duZWQg
YnkgaXRzZWxmLg0KPiA+PiAgICoNCj4gPj4gLSAqIFRoZSBvd25lcnNoaXAgaXMgcHJvdmVkIGJ5
IGFuIGFycmF5IG9mIGdyb3VwIGZkcy4NCj4gPj4gKyAqIFRoZSBvd25lcnNoaXAgY2FuIGJlIHBy
b3ZlZCBieToNCj4gPj4gKyAqICAgLSBBbiBhcnJheSBvZiBncm91cCBmZHMNCj4gPj4gKyAqICAg
LSBBIHplcm8tbGVuZ3RoIGFycmF5DQo+ID4+ICsgKg0KPiA+PiArICogSW4gdGhlIGxhc3QgY2Fz
ZSBhbGwgYWZmZWN0ZWQgZGV2aWNlcyB3aGljaCBhcmUgb3BlbmVkIGJ5IHRoaXMgdXNlcg0KPiA+
PiArICogbXVzdCBoYXZlIGJlZW4gYm91bmQgdG8gYSBzYW1lIGlvbW11ZmQuIElmIHRoZSBjYWxs
aW5nIGRldmljZSBpcyBpbg0KPiA+PiArICogbm9pb21tdSBtb2RlIChubyB2YWxpZCBpb21tdWZk
KSB0aGVuIGl0IGNhbiBiZSByZXNldCBvbmx5IGlmIHRoZSByZXNldA0KPiA+PiArICogZG9lc24n
dCBhZmZlY3Qgb3RoZXIgZGV2aWNlcy4NCj4gPj4gICAqDQo+ID4+ICAgKiBSZXR1cm46IDAgb24g
c3VjY2VzcywgLWVycm5vIG9uIGZhaWx1cmUuDQo+ID4+ICAgKi8NCg0K
