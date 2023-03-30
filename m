Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D448C6D05BA
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 15:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbjC3NC3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 09:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbjC3NCW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 09:02:22 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B72AF0D;
        Thu, 30 Mar 2023 06:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680181338; x=1711717338;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NGuW5GwTrFwmM2ZlAApjvnCoBe3rObI/JyrybgQ6dpA=;
  b=EOEy32hkOYgBNjdtjsDZCJ7hO/zj5qrc1u1Bp/IWFpztKFU1yvayTVMc
   bHVK4TD6Tbgb1DMI0kHqjT+O1/9UJsAHjuabk1Y0o8qivl2Fpqx2bcu5L
   0Y4pFBkvjMY19ziDWYjCvPbjlscAlGf4E1ZJym1Bwy+hShOziwiNSnQdb
   UgN/ObbSo2kbOIui0IpfXITdGVqCf1eVYBgN2ETe36RWJYW26c0xskdrK
   ZG3RbMN+KG7ulPyH7lZnkOk9/CAByG+bT00Y0ggX6Y2MYfLyXf3yjs+ui
   lHlvcQEcjDigo5Idkmr0QaVaF3hUgfpX//rlgHkITZOJgDWhHoly4SD3S
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="406125409"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="406125409"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 06:02:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="858906658"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="858906658"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 30 Mar 2023 06:02:16 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 06:02:16 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 06:02:16 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 06:02:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXK199cpDjBR7Y4lGesX+S1i1M9sySloDppApGJfQzKywDjEwAKar8oXzv+bmJ3/CzpScLGqGtW/utmbT2vIX65HicF+BA/oOcFQMykuyE2qjwZh0m4Up+XGgjn3tMrSeJ5XDCXiPEt5eB41eNHkdpMGfYul6mlDR2BXSuFNyIpt/AClmhgY6jNbRJSrfs4i7F+3KyUf98VcDAxal+nPc5MzCKW7F6cudvmH8LPyUFsOuiLfFyAi7ARYRgeWuUYUEh5MbUtzGW0oyczpXVtYNOtP3+/qqdF7v7K4h+kmADg6HsbHsrL1U+JB1L7RiOX1FUdfOy8JI0Gxg6Ng4XnajA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NGuW5GwTrFwmM2ZlAApjvnCoBe3rObI/JyrybgQ6dpA=;
 b=YlBayaVGW1nNPUfu3XmNdLyWcMxya167SmIfieiVPtrcKBP0D/7+fhlB1EJYglAdPBsME/w88qgodHHizPCUZv+1BQlzqYKDJuye8I+3Zia/I6d3Zt9HtKFCVOh+q2Kg9nSqAaO1zCSfahGaxMQEomjlCBfOSlwobAqBLiAsEkASBz9vLoo0FQwjWvSADPBgC/OdxqPDFQ60BNcV81lPvmKQQKfiknKwqrHf8WEK/4Oo7VkwxgGoHszbqoSFvE1yQBQ3RqqpfJ0iqAFHjitadNWU6sfHtTV5Bx+PfwAtBTzL1saUMAvA+6u7LuHX4xuIkH9Gw2ACK0XS6t5kfvSRzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6516.namprd11.prod.outlook.com (2603:10b6:208:3a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 13:02:14 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%4]) with mapi id 15.20.6254.020; Thu, 30 Mar 2023
 13:02:14 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v8 22/24] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Thread-Topic: [PATCH v8 22/24] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Thread-Index: AQHZYJBFam6QJW0HHk69FSn0nNVRxq8SRwoAgAEGbhA=
Date:   Thu, 30 Mar 2023 13:02:13 +0000
Message-ID: <DS0PR11MB75292FE51723C1E1BE841608C38E9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
        <20230327094047.47215-23-yi.l.liu@intel.com>
 <20230329151902.453ed743.alex.williamson@redhat.com>
In-Reply-To: <20230329151902.453ed743.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA1PR11MB6516:EE_
x-ms-office365-filtering-correlation-id: 9b58f567-a4a5-4a42-bc61-08db311efb63
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dab069EmFJQWtiWm81CU+YOMimtIvNIj5g1LerrNUk2Oq62GoTW3WtC/y1ps5S0Cj0NwePvETQwqiNIKC/w1ElWWTisP4HgPLxLeg5OZxmy7uPuaw9vN/RlJUSW+Bmfhht+fO3fGsRfNXSLAnAvIaNiP1TcYpMd6DZ93xHwnmv+j6EwWGS3A3+Eo3Q+CMFPbD7ixG4h80Q2TH9HXseyQWnFN+RYBSRpNr/fVIR5AsRGMcOWU8kXU8tsM/DWTx78dCEMJpnKyZ7og8yLkiq/rvDTNmEuFFrc4WVb5hbcQ6RjjeUNu8ggmHwNxTKDnu2g39KbL6XUXhGJXWWVw7oz/fE5TsXSAwDQRv48sga3C/c2u29lmEprD3q1LP0h6CvpXW5plstwIMomroJ/Z+7SyiHkEXhGC+8P5EvNqKZbCGe9kJ85BiPs5In+RvyPMDAJYuou8k2uD+woBSa705tbXmdDqX9yoRgeOrMOq/ntX5B67ArrIbqPvnXQs+WU43qgvzstRlLjlItV1yP7fh+aa7WCyH7F8B6wWsbwWoM+qWVr3v0NnwT9gzZzso2MVd43fIWoyuxmkCs5IFX7vur+ExZdTFwmU8APpmZuFM29MWLmrNU1oeGbNOHvXvGrdzuF7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199021)(83380400001)(33656002)(186003)(9686003)(7696005)(71200400001)(478600001)(86362001)(6506007)(54906003)(316002)(26005)(6916009)(41300700001)(4326008)(55016003)(52536014)(82960400001)(66946007)(8676002)(66446008)(76116006)(66556008)(66476007)(64756008)(122000001)(8936002)(2906002)(38100700002)(38070700005)(7416002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MCtUVjQrVnNacjNZZEppUFJwUy9aQnFZbmZMZFJrdm5ORmZJU3VSKzRxZmNn?=
 =?utf-8?B?QUlNQlVFdGY3eEFJWlNFZ21OYlJqSmZQTGt4bjJJZWJWLzd0K2lHWEkxUjhC?=
 =?utf-8?B?UkxvTURZWkRTRGswcmNFOWxWM292aGJJVHdxME1ldXJwaHlvU01FcTh0OCth?=
 =?utf-8?B?NXVKS1F0SlAzQ3d3UkFoRjg1RGNRU1M5TENjYXJEKzM2NTNhbDZsVmhadlho?=
 =?utf-8?B?UlIxa1VDQUZ4OHk5cjhQMUd6V3J0eHBaOHRab1VPT1BreUZkTHZ6TDVhMGVm?=
 =?utf-8?B?aEsyNmNiYnY2cVUrK2V3WVdFd1d1QnJRU1ZFb1lVeFFQRXVUYmlnZUo5a01Z?=
 =?utf-8?B?R3EwRjhkNGpoVFZFb1pUKzJrQW5jRzVUcGFGckttYnJ0UUFhWSsyQ1pHYllG?=
 =?utf-8?B?VEFiTzZiOGlFUHFyQ2JTOFBUUk12NFFIa1dBMk1tdVJuT3lCd3o5OXNLUFZi?=
 =?utf-8?B?NkVKN3Q5K0JRanNBSWRzbmNHbFIxTlJtV2huZyt3aXNOY2JIdE1YRFJRUjZi?=
 =?utf-8?B?TDd4aGh3dklnYkcyd0Fvd3ROZ0lSc3IzZm5tM3BYaWNaV2RMZmN5QWpraWg5?=
 =?utf-8?B?cHpBSnY2UjlVTTNtVHVjUHdhcUNrTGRHTk1leXREZ2lrL0xtUTRGcnNYelZp?=
 =?utf-8?B?ZnhMVVQrQTdJd2lyUDhLRWJ3VmlabHhCRytEZ3BRYW5yYmk3UlZSRjN3TDhs?=
 =?utf-8?B?ZVFYeDRXNWJ0dGxtVTA3QTRxbUVYbU9iS1dIY1VicThsSmlsRjJYbCs4cENw?=
 =?utf-8?B?RGY0NFZDVkhGMzJhWDd5ckZiTWxjQW5ENlNoaStsbDlSbXhIWmFmeTF3QTdM?=
 =?utf-8?B?bitRbThJeHdveUNmcGpWREpvNjJhTHRCOE9lU1h0ZXRJYnVDcHlJOFl5blVo?=
 =?utf-8?B?dUhzc3pIemZPWFRHRStrcU1EV2hoK1NBVDdGenU5Vmk3c29jcnRGVDJWWGZp?=
 =?utf-8?B?QzJVTW52dHZEQ0FmRUI2UzJKaFRJTVpOeE5CYmVNUHJyQkJZV2UxWk02Q0ZD?=
 =?utf-8?B?c2RDeVNsYlRqMVlDVVRLaVgxUmRaSURWb0hmclpqd1kvamJtRm1sbllMajR6?=
 =?utf-8?B?eStNZm5yZ0Y1bS9WcjVNS0tTUU1tejJDMk9tV1FQZndlSzZkc2JkMUsxOGgv?=
 =?utf-8?B?Y2xlMThEREZIUFhzR3owSFFVeEVWZk41VXBSQ0Q2a3ZXem9KWFNMdHFkMWV1?=
 =?utf-8?B?bU9rMWh5ejVqZW1Vbmcxa2dKS2UxdUdUVzFTWVFjRmJXZ096QVdoNTN5RlVq?=
 =?utf-8?B?WEFuK2hCNVlwUUdsYzhwYk1MMHNnWGxLbUh0VjRHdXhtbDR2dDhDRVRuTXdM?=
 =?utf-8?B?N1orWGlvUm1XdUp5VkYwaTNGTVRCTzAzVGtBVERpQzdyNTZjdlUxeE03ZzRj?=
 =?utf-8?B?TnNsSUNNdkxtdXpEeWtHbTVGWFpFUUhEVHlBVGNaMzd5dHlrTTgrZS8xV25S?=
 =?utf-8?B?SGJyaktueHNJV0paNmtvRGRGamlOeTBZODYxcUVVUUUwa3hjN2FwVFJtNE9p?=
 =?utf-8?B?UGR1TGhmWlJHN3dtcnNhNU0weWY4R0xuTWxkdFFuVUtXQ2ZYNHNQaGZJUnJQ?=
 =?utf-8?B?cENhV1RYTVVRcVIxUElOZlVTdzY1QVVrQWR6cnVQTVIyc0ZCOXNtVkdNUGhD?=
 =?utf-8?B?dkpXWDBleWhnZENsK1VMZnVYQWFyeS9xZTNtK1VNMTVJRVRQR081OW0wNVZo?=
 =?utf-8?B?empub1lEbkpUcGVnQWVOUHJ1WXNkcVNTYWViVnY5SXlwZ2pXbHNLcnpoUUt6?=
 =?utf-8?B?amgvV2RZUkE4VWc2WlU2MjhoSTVEN3BkM1ZGQlR4eWttV3BSeXFzMEhqdmd5?=
 =?utf-8?B?RXBOQTVVT2JuWW5wOFlTNTN0a1YxSDEwNVo2dUozcGYzWHJhN2JmVkg4Yzcv?=
 =?utf-8?B?Mi9BTmQyay9vanZpSFNBVEx3WHJ4MnpjZDNzcWoxRlUwZGU0Y2NhVFZaa01J?=
 =?utf-8?B?eTh5RzBWSXJWQ05Iczl3amtBWE9iS01xMG9mc2RCL3BnSmJjblg1QzRJcVcv?=
 =?utf-8?B?ZHhianRLUnJEZkluRktYeHNpRm1uWFhxTFdHV0lib3E0bG13TzJlRXdZdXcx?=
 =?utf-8?B?b2Nrb3hXMHBVQlRSQk5xWkFrazlOUnd6UEdYenErbzd5WUwvU3BHNGF6aFZr?=
 =?utf-8?Q?j9n/QEnsxfh4v/QVs9+CyfKWd?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b58f567-a4a5-4a42-bc61-08db311efb63
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 13:02:13.9302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wQtMtm7DRvNNLNsG/ZJE1OB0AlqU90T91TBbZjsgfwLINJBmfKBgCkl9Y9X+2ZJfqOGuSlhnuHSEWdKJLg6QlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6516
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUaHVyc2RheSwgTWFyY2ggMzAsIDIwMjMgNToxOSBBTQ0KPiANCj4gDQo+IE5pdCwgQVRE
RVRBQ0g/ICBbQVR8REVdVEFDSD8NCg0KW0FUfERFXVRBQ0gg8J+Yig0KDQo+IE9uIE1vbiwgMjcg
TWFyIDIwMjMgMDI6NDA6NDUgLTA3MDANCj4gWWkgTGl1IDx5aS5sLmxpdUBpbnRlbC5jb20+IHdy
b3RlOg0KPiANCj4gPiBUaGlzIGFkZHMgaW9jdGwgZm9yIHVzZXJzcGFjZSB0byBhdHRhY2ggZGV2
aWNlIGNkZXYgZmQgdG8gYW5kIGRldGFjaA0KPiA+IGZyb20gSU9BUy9od19wYWdldGFibGUgbWFu
YWdlZCBieSBpb21tdWZkLg0KPiA+DQo+ID4gICAgIFZGSU9fREVWSUNFX0FUVEFDSF9JT01NVUZE
X1BUOiBhdHRhY2ggdmZpbyBkZXZpY2UgdG8gSU9BUywgaHdfcGFnZXRhYmxlDQo+ID4gCQkJCSAg
IG1hbmFnZWQgYnkgaW9tbXVmZC4gQXR0YWNoIGNhbiBiZQ0KPiA+IAkJCQkgICB1bmRvIGJ5IFZG
SU9fREVWSUNFX0RFVEFDSF9JT01NVUZEX1BUDQo+ID4gCQkJCSAgIG9yIGRldmljZSBmZCBjbG9z
ZS4NCj4gPiAgICAgVkZJT19ERVZJQ0VfREVUQUNIX0lPTU1VRkRfUFQ6IGRldGFjaCB2ZmlvIGRl
dmljZSBmcm9tIHRoZSBjdXJyZW50DQo+IGF0dGFjaGVkDQo+ID4gCQkJCSAgIElPQVMgb3IgaHdf
cGFnZXRhYmxlIG1hbmFnZWQgYnkgaW9tbXVmZC4NCj4gPg0KPiA+IFJldmlld2VkLWJ5OiBLZXZp
biBUaWFuIDxrZXZpbi50aWFuQGludGVsLmNvbT4NCj4gPiBUZXN0ZWQtYnk6IFRlcnJlbmNlIFh1
IDx0ZXJyZW5jZS54dUBpbnRlbC5jb20+DQo+ID4gVGVzdGVkLWJ5OiBOaWNvbGluIENoZW4gPG5p
Y29saW5jQG52aWRpYS5jb20+DQo+ID4gVGVzdGVkLWJ5OiBNYXR0aGV3IFJvc2F0byA8bWpyb3Nh
dG9AbGludXguaWJtLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBZaSBMaXUgPHlpLmwubGl1QGlu
dGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy92ZmlvL2RldmljZV9jZGV2LmMgfCA4NSAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICBkcml2ZXJzL3ZmaW8v
dmZpby5oICAgICAgICB8IDE2ICsrKysrKysNCj4gPiAgZHJpdmVycy92ZmlvL3ZmaW9fbWFpbi5j
ICAgfCAgOCArKysrDQo+ID4gIGluY2x1ZGUvdWFwaS9saW51eC92ZmlvLmggIHwgNTIgKysrKysr
KysrKysrKysrKysrKysrKysNCj4gPiAgNCBmaWxlcyBjaGFuZ2VkLCAxNjEgaW5zZXJ0aW9ucygr
KQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmZpby9kZXZpY2VfY2Rldi5jIGIvZHJp
dmVycy92ZmlvL2RldmljZV9jZGV2LmMNCj4gPiBpbmRleCAyYjU2M2JhYzUwYjkuLmI1ZGU5OTdi
ZmY2ZCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3ZmaW8vZGV2aWNlX2NkZXYuYw0KPiA+ICsr
KyBiL2RyaXZlcnMvdmZpby9kZXZpY2VfY2Rldi5jDQo+ID4gQEAgLTE5Nyw2ICsxOTcsOTEgQEAg
bG9uZyB2ZmlvX2RldmljZV9pb2N0bF9iaW5kX2lvbW11ZmQoc3RydWN0DQo+IHZmaW9fZGV2aWNl
X2ZpbGUgKmRmLA0KPiA+ICAJcmV0dXJuIHJldDsNCj4gPiAgfQ0KPiA+DQo+ID4gK2ludCB2Zmlv
X2lvY3RsX2RldmljZV9hdHRhY2goc3RydWN0IHZmaW9fZGV2aWNlX2ZpbGUgKmRmLA0KPiA+ICsJ
CQkgICAgIHN0cnVjdCB2ZmlvX2RldmljZV9hdHRhY2hfaW9tbXVmZF9wdCBfX3VzZXIgKmFyZykN
Cj4gPiArew0KPiA+ICsJc3RydWN0IHZmaW9fZGV2aWNlICpkZXZpY2UgPSBkZi0+ZGV2aWNlOw0K
PiA+ICsJc3RydWN0IHZmaW9fZGV2aWNlX2F0dGFjaF9pb21tdWZkX3B0IGF0dGFjaDsNCj4gPiAr
CXVuc2lnbmVkIGxvbmcgbWluc3o7DQo+ID4gKwlpbnQgcmV0Ow0KPiA+ICsNCj4gPiArCXN0YXRp
Y19hc3NlcnQoX19zYW1lX3R5cGUoYXJnLT5wdF9pZCwgYXR0YWNoLnB0X2lkKSk7DQo+IA0KPiBT
YW1lIGNvbW1lbnQgYXMgcHJldmlvdXMsIGdpdmVuIHRoZXNlIGFyZSB0aGUgc2FtZSBmaWVsZCBv
ZiB0aGUgc2FtZQ0KPiBzdHJ1Y3R1cmUsIEkgZG9uJ3QgdW5kZXJzdGFuZCBob3cgdGhpcyBjb3Vs
ZCBldmVyIGFzc2VydC4NCg0KeWVzLCB3aWxsIHJlbW92ZSBpdC4NCg0KPiANCj4gPiArDQo+ID4g
KwltaW5zeiA9IG9mZnNldG9mZW5kKHN0cnVjdCB2ZmlvX2RldmljZV9hdHRhY2hfaW9tbXVmZF9w
dCwgcHRfaWQpOw0KPiA+ICsNCj4gPiArCWlmIChjb3B5X2Zyb21fdXNlcigmYXR0YWNoLCBhcmcs
IG1pbnN6KSkNCj4gPiArCQlyZXR1cm4gLUVGQVVMVDsNCj4gPiArDQo+ID4gKwlpZiAoYXR0YWNo
LmFyZ3N6IDwgbWluc3ogfHwgYXR0YWNoLmZsYWdzKQ0KPiA+ICsJCXJldHVybiAtRUlOVkFMOw0K
PiA+ICsNCj4gPiArCWlmICghZGV2aWNlLT5vcHMtPmJpbmRfaW9tbXVmZCkNCj4gPiArCQlyZXR1
cm4gLUVOT0RFVjsNCj4gDQo+IFNhbWUgYXMgcHJldmlvdXMsIHdlIGFscmVhZHkgcmVxdWlyZSB0
aGlzIHRvIGVuYWJsZSBjZGV2IHN1cHBvcnQsIHNvDQo+IHRoaXMgc2VlbXMgdWx0cmEgcGFyYW5v
aWQuDQoNCndpbGwgcmVtb3ZlIGl0Lg0KDQo+IA0KPiA+ICsNCj4gPiArCS8qIEFUVEFDSCBvbmx5
IGFsbG93ZWQgZm9yIGNkZXYgZmRzICovDQo+ID4gKwlpZiAoZGYtPmdyb3VwKQ0KPiA+ICsJCXJl
dHVybiAtRUlOVkFMOw0KPiA+ICsNCj4gPiArCW11dGV4X2xvY2soJmRldmljZS0+ZGV2X3NldC0+
bG9jayk7DQo+ID4gKwkvKiBub2lvbW11ZmQgbW9kZSBkb2Vzbid0IGFsbG93IGF0dGFjaCAqLw0K
PiA+ICsJaWYgKCFkZi0+aW9tbXVmZCkgew0KPiA+ICsJCXJldCA9IC1FT1BOT1RTVVBQOw0KPiA+
ICsJCWdvdG8gb3V0X3VubG9jazsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwlyZXQgPSBkZXZpY2Ut
Pm9wcy0+YXR0YWNoX2lvYXMoZGV2aWNlLCAmYXR0YWNoLnB0X2lkKTsNCj4gPiArCWlmIChyZXQp
DQo+ID4gKwkJZ290byBvdXRfdW5sb2NrOw0KPiA+ICsNCj4gPiArCXJldCA9IGNvcHlfdG9fdXNl
cigmYXJnLT5wdF9pZCwgJmF0dGFjaC5wdF9pZCwNCj4gPiArCQkJICAgc2l6ZW9mKGF0dGFjaC5w
dF9pZCkpID8gLUVGQVVMVCA6IDA7DQo+ID4gKwlpZiAocmV0KQ0KPiA+ICsJCWdvdG8gb3V0X2Rl
dGFjaDsNCj4gPiArCW11dGV4X3VubG9jaygmZGV2aWNlLT5kZXZfc2V0LT5sb2NrKTsNCj4gPiAr
DQo+ID4gKwlyZXR1cm4gMDsNCj4gPiArDQo+ID4gK291dF9kZXRhY2g6DQo+ID4gKwlkZXZpY2Ut
Pm9wcy0+ZGV0YWNoX2lvYXMoZGV2aWNlKTsNCj4gPiArb3V0X3VubG9jazoNCj4gPiArCW11dGV4
X3VubG9jaygmZGV2aWNlLT5kZXZfc2V0LT5sb2NrKTsNCj4gPiArCXJldHVybiByZXQ7DQo+ID4g
K30NCj4gPiArDQo+ID4gK2ludCB2ZmlvX2lvY3RsX2RldmljZV9kZXRhY2goc3RydWN0IHZmaW9f
ZGV2aWNlX2ZpbGUgKmRmLA0KPiA+ICsJCQkgICAgIHN0cnVjdCB2ZmlvX2RldmljZV9kZXRhY2hf
aW9tbXVmZF9wdCBfX3VzZXIgKmFyZykNCj4gPiArew0KPiA+ICsJc3RydWN0IHZmaW9fZGV2aWNl
ICpkZXZpY2UgPSBkZi0+ZGV2aWNlOw0KPiA+ICsJc3RydWN0IHZmaW9fZGV2aWNlX2RldGFjaF9p
b21tdWZkX3B0IGRldGFjaDsNCj4gPiArCXVuc2lnbmVkIGxvbmcgbWluc3o7DQo+ID4gKw0KPiA+
ICsJbWluc3ogPSBvZmZzZXRvZmVuZChzdHJ1Y3QgdmZpb19kZXZpY2VfZGV0YWNoX2lvbW11ZmRf
cHQsIGZsYWdzKTsNCj4gPiArDQo+ID4gKwlpZiAoY29weV9mcm9tX3VzZXIoJmRldGFjaCwgYXJn
LCBtaW5zeikpDQo+ID4gKwkJcmV0dXJuIC1FRkFVTFQ7DQo+ID4gKw0KPiA+ICsJaWYgKGRldGFj
aC5hcmdzeiA8IG1pbnN6IHx8IGRldGFjaC5mbGFncykNCj4gPiArCQlyZXR1cm4gLUVJTlZBTDsN
Cj4gPiArDQo+ID4gKwlpZiAoIWRldmljZS0+b3BzLT5iaW5kX2lvbW11ZmQpDQo+ID4gKwkJcmV0
dXJuIC1FTk9ERVY7DQo+ID4gKw0KPiA+ICsJLyogREVUQUNIIG9ubHkgYWxsb3dlZCBmb3IgY2Rl
diBmZHMgKi8NCj4gPiArCWlmIChkZi0+Z3JvdXApDQo+ID4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+
ID4gKw0KPiA+ICsJbXV0ZXhfbG9jaygmZGV2aWNlLT5kZXZfc2V0LT5sb2NrKTsNCj4gPiArCS8q
IG5vaW9tbXVmZCBtb2RlIGRvZXNuJ3Qgc3VwcG9ydCBkZXRhY2ggKi8NCj4gPiArCWlmICghZGYt
PmlvbW11ZmQpIHsNCj4gPiArCQltdXRleF91bmxvY2soJmRldmljZS0+ZGV2X3NldC0+bG9jayk7
DQo+ID4gKwkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiA+ICsJfQ0KPiA+ICsJZGV2aWNlLT5vcHMt
PmRldGFjaF9pb2FzKGRldmljZSk7DQo+ID4gKwltdXRleF91bmxvY2soJmRldmljZS0+ZGV2X3Nl
dC0+bG9jayk7DQo+ID4gKw0KPiA+ICsJcmV0dXJuIDA7DQo+ID4gK30NCj4gDQo+IEZvciBib3Ro
IG9mIHRoZXNlLCBjYW4ndCBhIHVzZXIgdHJpZ2dlciB0aGUNCj4gV0FSTl9PTighdmRldi0+aW9t
bXVmZF9kZXZpY2UpIGlmIHRoZXkgY2FsbCBlaXRoZXIgb2YgdGhlc2UgYmVmb3JlDQo+IFZGSU9f
REVWSUNFX0JJTkRfSU9NTVVGRD8gIFRoYW5rcywNCg0KaWYgVkZJT19ERVZJQ0VfQklORF9JT01N
VUZEIGlzIG5vdCBkb25lLCB0aGUgQVRUQUNIL0RFVEFDSA0Kc2hhbGwgYmUgYmxvY2tlZCwgc28g
aXQgd29uJ3QgdHJpZ2dlciB0aGUgV0FSTl9PTiB3aGljaCBpcyBpbiB0aGUNCmF0dGFjaF9pb2Fz
IGFuZCBkZXRhY2hfaW9hcyBjYWxsYmFjay4NCg0KUmVnYXJkcywNCllpIExpdQ0KPiANCj4gPiAr
DQo+ID4gIHN0YXRpYyBjaGFyICp2ZmlvX2RldmljZV9kZXZub2RlKGNvbnN0IHN0cnVjdCBkZXZp
Y2UgKmRldiwgdW1vZGVfdCAqbW9kZSkNCj4gPiAgew0KPiA+ICAJcmV0dXJuIGthc3ByaW50ZihH
RlBfS0VSTkVMLCAidmZpby9kZXZpY2VzLyVzIiwgZGV2X25hbWUoZGV2KSk7DQo+ID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvdmZpby92ZmlvLmggYi9kcml2ZXJzL3ZmaW8vdmZpby5oDQo+ID4gaW5k
ZXggYWNlM2Q1MmIwOTI4Li5jMTk5ZTQxMGRiMTggMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy92
ZmlvL3ZmaW8uaA0KPiA+ICsrKyBiL2RyaXZlcnMvdmZpby92ZmlvLmgNCj4gPiBAQCAtMjg0LDYg
KzI4NCwxMCBAQCBpbnQgdmZpb19kZXZpY2VfZm9wc19jZGV2X29wZW4oc3RydWN0IGlub2RlICpp
bm9kZSwNCj4gc3RydWN0IGZpbGUgKmZpbGVwKTsNCj4gPiAgdm9pZCB2ZmlvX2RldmljZV9jZGV2
X2Nsb3NlKHN0cnVjdCB2ZmlvX2RldmljZV9maWxlICpkZik7DQo+ID4gIGxvbmcgdmZpb19kZXZp
Y2VfaW9jdGxfYmluZF9pb21tdWZkKHN0cnVjdCB2ZmlvX2RldmljZV9maWxlICpkZiwNCj4gPiAg
CQkJCSAgICBzdHJ1Y3QgdmZpb19kZXZpY2VfYmluZF9pb21tdWZkIF9fdXNlciAqYXJnKTsNCj4g
PiAraW50IHZmaW9faW9jdGxfZGV2aWNlX2F0dGFjaChzdHJ1Y3QgdmZpb19kZXZpY2VfZmlsZSAq
ZGYsDQo+ID4gKwkJCSAgICAgc3RydWN0IHZmaW9fZGV2aWNlX2F0dGFjaF9pb21tdWZkX3B0IF9f
dXNlciAqYXJnKTsNCj4gPiAraW50IHZmaW9faW9jdGxfZGV2aWNlX2RldGFjaChzdHJ1Y3QgdmZp
b19kZXZpY2VfZmlsZSAqZGYsDQo+ID4gKwkJCSAgICAgc3RydWN0IHZmaW9fZGV2aWNlX2RldGFj
aF9pb21tdWZkX3B0IF9fdXNlciAqYXJnKTsNCj4gPiAgaW50IHZmaW9fY2Rldl9pbml0KHN0cnVj
dCBjbGFzcyAqZGV2aWNlX2NsYXNzKTsNCj4gPiAgdm9pZCB2ZmlvX2NkZXZfY2xlYW51cCh2b2lk
KTsNCj4gPiAgI2Vsc2UNCj4gPiBAQCAtMzE3LDYgKzMyMSwxOCBAQCBzdGF0aWMgaW5saW5lIGxv
bmcgdmZpb19kZXZpY2VfaW9jdGxfYmluZF9pb21tdWZkKHN0cnVjdA0KPiB2ZmlvX2RldmljZV9m
aWxlICpkZiwNCj4gPiAgCXJldHVybiAtRU9QTk9UU1VQUDsNCj4gPiAgfQ0KPiA+DQo+ID4gK3N0
YXRpYyBpbmxpbmUgaW50IHZmaW9faW9jdGxfZGV2aWNlX2F0dGFjaChzdHJ1Y3QgdmZpb19kZXZp
Y2VfZmlsZSAqZGYsDQo+ID4gKwkJCQkJICAgc3RydWN0IHZmaW9fZGV2aWNlX2F0dGFjaF9pb21t
dWZkX3B0DQo+IF9fdXNlciAqYXJnKQ0KPiA+ICt7DQo+ID4gKwlyZXR1cm4gLUVPUE5PVFNVUFA7
DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyBpbmxpbmUgaW50IHZmaW9faW9jdGxfZGV2aWNl
X2RldGFjaChzdHJ1Y3QgdmZpb19kZXZpY2VfZmlsZSAqZGYsDQo+ID4gKwkJCQkJICAgc3RydWN0
IHZmaW9fZGV2aWNlX2RldGFjaF9pb21tdWZkX3B0DQo+IF9fdXNlciAqYXJnKQ0KPiA+ICt7DQo+
ID4gKwlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+ID4gK30NCj4gPiArDQo+ID4gIHN0YXRpYyBpbmxp
bmUgaW50IHZmaW9fY2Rldl9pbml0KHN0cnVjdCBjbGFzcyAqZGV2aWNlX2NsYXNzKQ0KPiA+ICB7
DQo+ID4gIAlyZXR1cm4gMDsNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL3ZmaW9fbWFp
bi5jIGIvZHJpdmVycy92ZmlvL3ZmaW9fbWFpbi5jDQo+ID4gaW5kZXggMzc1MDg2Yzg4MDNmLi44
OTZkOGJiNDk1ODUgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy92ZmlvL3ZmaW9fbWFpbi5jDQo+
ID4gKysrIGIvZHJpdmVycy92ZmlvL3ZmaW9fbWFpbi5jDQo+ID4gQEAgLTExNTAsNiArMTE1MCwx
NCBAQCBzdGF0aWMgbG9uZyB2ZmlvX2RldmljZV9mb3BzX3VubF9pb2N0bChzdHJ1Y3QgZmlsZSAq
ZmlsZXAsDQo+ID4gIAkJcmV0ID0gdmZpb19pb2N0bF9kZXZpY2VfZmVhdHVyZShkZXZpY2UsICh2
b2lkIF9fdXNlciAqKWFyZyk7DQo+ID4gIAkJYnJlYWs7DQo+ID4NCj4gPiArCWNhc2UgVkZJT19E
RVZJQ0VfQVRUQUNIX0lPTU1VRkRfUFQ6DQo+ID4gKwkJcmV0ID0gdmZpb19pb2N0bF9kZXZpY2Vf
YXR0YWNoKGRmLCAodm9pZCBfX3VzZXIgKilhcmcpOw0KPiA+ICsJCWJyZWFrOw0KPiA+ICsNCj4g
PiArCWNhc2UgVkZJT19ERVZJQ0VfREVUQUNIX0lPTU1VRkRfUFQ6DQo+ID4gKwkJcmV0ID0gdmZp
b19pb2N0bF9kZXZpY2VfZGV0YWNoKGRmLCAodm9pZCBfX3VzZXIgKilhcmcpOw0KPiA+ICsJCWJy
ZWFrOw0KPiA+ICsNCj4gPiAgCWRlZmF1bHQ6DQo+ID4gIAkJaWYgKHVubGlrZWx5KCFkZXZpY2Ut
Pm9wcy0+aW9jdGwpKQ0KPiA+ICAJCQlyZXQgPSAtRUlOVkFMOw0KPiA+IGRpZmYgLS1naXQgYS9p
bmNsdWRlL3VhcGkvbGludXgvdmZpby5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L3ZmaW8uaA0KPiA+
IGluZGV4IDYyYjJmMjQ5NzUyNS4uYmY2Yzk3ZTc1OWM3IDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1
ZGUvdWFwaS9saW51eC92ZmlvLmgNCj4gPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvdmZpby5o
DQo+ID4gQEAgLTIzMSw2ICsyMzEsNTggQEAgc3RydWN0IHZmaW9fZGV2aWNlX2JpbmRfaW9tbXVm
ZCB7DQo+ID4NCj4gPiAgI2RlZmluZSBWRklPX0RFVklDRV9CSU5EX0lPTU1VRkQJX0lPKFZGSU9f
VFlQRSwgVkZJT19CQVNFICsgMTkpDQo+ID4NCj4gPiArLyoNCj4gPiArICogVkZJT19ERVZJQ0Vf
QVRUQUNIX0lPTU1VRkRfUFQgLSBfSU9XKFZGSU9fVFlQRSwgVkZJT19CQVNFICsgMjAsDQo+ID4g
KyAqCQkJCQlzdHJ1Y3QgdmZpb19kZXZpY2VfYXR0YWNoX2lvbW11ZmRfcHQpDQo+ID4gKyAqDQo+
ID4gKyAqIEF0dGFjaCBhIHZmaW8gZGV2aWNlIHRvIGFuIGlvbW11ZmQgYWRkcmVzcyBzcGFjZSBz
cGVjaWZpZWQgYnkgSU9BUw0KPiA+ICsgKiBpZCBvciBod19wYWdldGFibGUgKGh3cHQpIGlkLg0K
PiA+ICsgKg0KPiA+ICsgKiBBdmFpbGFibGUgb25seSBhZnRlciBhIGRldmljZSBoYXMgYmVlbiBi
b3VuZCB0byBpb21tdWZkIHZpYQ0KPiA+ICsgKiBWRklPX0RFVklDRV9CSU5EX0lPTU1VRkQNCj4g
PiArICoNCj4gPiArICogVW5kbyBieSBWRklPX0RFVklDRV9ERVRBQ0hfSU9NTVVGRF9QVCBvciBk
ZXZpY2UgZmQgY2xvc2UuDQo+ID4gKyAqDQo+ID4gKyAqIEBhcmdzejoJdXNlciBmaWxsZWQgc2l6
ZSBvZiB0aGlzIGRhdGEuDQo+ID4gKyAqIEBmbGFnczoJbXVzdCBiZSAwLg0KPiA+ICsgKiBAcHRf
aWQ6CUlucHV0IHRoZSB0YXJnZXQgaWQgd2hpY2ggY2FuIHJlcHJlc2VudCBhbiBpb2FzIG9yIGEg
aHdwdA0KPiA+ICsgKgkJYWxsb2NhdGVkIHZpYSBpb21tdWZkIHN1YnN5c3RlbS4NCj4gPiArICoJ
CU91dHB1dCB0aGUgYXR0YWNoZWQgaHdwdCBpZCB3aGljaCBjb3VsZCBiZSB0aGUgc3BlY2lmaWVk
DQo+ID4gKyAqCQlod3B0IGl0c2VsZiBvciBhIGh3cHQgYXV0b21hdGljYWxseSBjcmVhdGVkIGZv
ciB0aGUNCj4gPiArICoJCXNwZWNpZmllZCBpb2FzIGJ5IGtlcm5lbCBkdXJpbmcgdGhlIGF0dGFj
aG1lbnQuDQo+ID4gKyAqDQo+ID4gKyAqIFJldHVybjogMCBvbiBzdWNjZXNzLCAtZXJybm8gb24g
ZmFpbHVyZS4NCj4gPiArICovDQo+ID4gK3N0cnVjdCB2ZmlvX2RldmljZV9hdHRhY2hfaW9tbXVm
ZF9wdCB7DQo+ID4gKwlfX3UzMglhcmdzejsNCj4gPiArCV9fdTMyCWZsYWdzOw0KPiA+ICsJX191
MzIJcHRfaWQ7DQo+ID4gK307DQo+ID4gKw0KPiA+ICsjZGVmaW5lIFZGSU9fREVWSUNFX0FUVEFD
SF9JT01NVUZEX1BUCQlfSU8oVkZJT19UWVBFLA0KPiBWRklPX0JBU0UgKyAyMCkNCj4gPiArDQo+
ID4gKy8qDQo+ID4gKyAqIFZGSU9fREVWSUNFX0RFVEFDSF9JT01NVUZEX1BUIC0gX0lPVyhWRklP
X1RZUEUsIFZGSU9fQkFTRSArIDIxLA0KPiA+ICsgKgkJCQkJc3RydWN0IHZmaW9fZGV2aWNlX2Rl
dGFjaF9pb21tdWZkX3B0KQ0KPiA+ICsgKg0KPiA+ICsgKiBEZXRhY2ggYSB2ZmlvIGRldmljZSBm
cm9tIHRoZSBpb21tdWZkIGFkZHJlc3Mgc3BhY2UgaXQgaGFzIGJlZW4NCj4gPiArICogYXR0YWNo
ZWQgdG8uIEFmdGVyIGl0LCBkZXZpY2Ugc2hvdWxkIGJlIGluIGEgYmxvY2tpbmcgRE1BIHN0YXRl
Lg0KPiA+ICsgKg0KPiA+ICsgKiBBdmFpbGFibGUgb25seSBhZnRlciBhIGRldmljZSBoYXMgYmVl
biBib3VuZCB0byBpb21tdWZkIHZpYQ0KPiA+ICsgKiBWRklPX0RFVklDRV9CSU5EX0lPTU1VRkQu
DQo+ID4gKyAqDQo+ID4gKyAqIEBhcmdzejoJdXNlciBmaWxsZWQgc2l6ZSBvZiB0aGlzIGRhdGEu
DQo+ID4gKyAqIEBmbGFnczoJbXVzdCBiZSAwLg0KPiA+ICsgKg0KPiA+ICsgKiBSZXR1cm46IDAg
b24gc3VjY2VzcywgLWVycm5vIG9uIGZhaWx1cmUuDQo+ID4gKyAqLw0KPiA+ICtzdHJ1Y3QgdmZp
b19kZXZpY2VfZGV0YWNoX2lvbW11ZmRfcHQgew0KPiA+ICsJX191MzIJYXJnc3o7DQo+ID4gKwlf
X3UzMglmbGFnczsNCj4gPiArfTsNCj4gPiArDQo+ID4gKyNkZWZpbmUgVkZJT19ERVZJQ0VfREVU
QUNIX0lPTU1VRkRfUFQJCV9JTyhWRklPX1RZUEUsDQo+IFZGSU9fQkFTRSArIDIxKQ0KPiA+ICsN
Cj4gPiAgLyoqDQo+ID4gICAqIFZGSU9fREVWSUNFX0dFVF9JTkZPIC0gX0lPUihWRklPX1RZUEUs
IFZGSU9fQkFTRSArIDcsDQo+ID4gICAqCQkJCQkJc3RydWN0IHZmaW9fZGV2aWNlX2luZm8pDQoN
Cg==
