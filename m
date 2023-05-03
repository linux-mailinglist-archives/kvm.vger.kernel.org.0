Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00656F5538
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 11:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjECJto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 05:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjECJtH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 05:49:07 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B810B8;
        Wed,  3 May 2023 02:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683107327; x=1714643327;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HV4YD8LeAccFsw+FztSyqskG9NiFVEj0cwBggHOHnFA=;
  b=J4LUcl0b99jAuvwZIyRwSyB5NQrPTVVB5EIpFjnMA8WFYkdLBBkAxS0E
   7fIjoqOSsReY5r17GyKl1GPdVklaHMsXN1w02Etd/VYFPNCNZh9r7ViNa
   HdqTXGG5kJVj5zyko/ghYc8gA3AOZxgV6rP9nMLRYXjaaJWWNQxEWe1N7
   oYJiHg5jiSwSv/6jiP3+NN+qS9HuyHLEcsmQTsWpSwFhQ8xhvT6fgJFgC
   1famvIG3h8+z15bdpD/ds+6hWG2sM+c8i8g3TZxB4P8Qdtf4o3eOe/mRY
   S8AF7dEoruEwum9P/Jl8Xi4hmA9PTTfREi6FS8EQg35RifExyNvAzxmps
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10698"; a="332976354"
X-IronPort-AV: E=Sophos;i="5.99,246,1677571200"; 
   d="scan'208";a="332976354"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 02:48:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10698"; a="727076897"
X-IronPort-AV: E=Sophos;i="5.99,246,1677571200"; 
   d="scan'208";a="727076897"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 03 May 2023 02:48:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 02:48:39 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 02:48:39 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 02:48:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6AqaZDYQWUwr+PkpAJBkPcQb0EfIdFgR6sYrM/0uBSpiWcfJtywvoBsqx3gHIVF/6esRys1s0o6pquVx9BXEEBvW6/d6fQcGDGJkPUK56GcnVJMEI+GeKtv0hSoM5EyejUkiHPrH+T6cc7Gf+0x4XtTX4FvdPtLY6bEzYexcshr8iUUyWW1mJ/ZaASTE7mGbMcGDlXIoMaIgY9o12Ly2SuMGbzgOqZd+f0c0EVe8PIrS6VrIENhPCrccySlhgmzaBPDajnAJafNy74N+eaUQPW63PrXY4tbrcLVnNQG8WfxpWMd44lv5bdRUsXc3VtfZWVG1zI6eNvJmtIISZgtTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HV4YD8LeAccFsw+FztSyqskG9NiFVEj0cwBggHOHnFA=;
 b=B3DiS2ARPXE+8+fFVza83GC/qV80tiv4sOnQaXonvdBQNoCHq0wrtYJkYMYLLmvBqCasLyDUZay3iylF/OwMaH0l9DI4r69tDH2nO8sizc6h+pVxRPAk3uX2Kq7JVHxOLFarIqLkNfmk0Yi/xCN23hp4hQUpZHA04pplfaohYPXwHGhNoURDUaIaS5JoEwfo4XGzzNDND5VQACNXXZREu7qgU0RNMygR+/ZL/XIA4hnXasWPMohIrNNBIW0eSTO+Y49LaZJjoFjdUcFwDN/oQlxgXVqez1mbrRRNrNtmV83kRC0q8eTL2y0VkurWzYfGqroJGNIrg+71FLGJ4WiPyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB5952.namprd11.prod.outlook.com (2603:10b6:510:147::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Wed, 3 May
 2023 09:48:37 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6363.022; Wed, 3 May 2023
 09:48:36 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Thread-Topic: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Thread-Index: AQHZeE8IlpbqU+0d80ea2xcAM3D0DK8+tVeAgAAAlECAAMaWgIAAxjMAgABgzICAAELrAIAGbDOAgAD/bEA=
Date:   Wed, 3 May 2023 09:48:36 +0000
Message-ID: <DS0PR11MB7529DCEF617AD24D62E33C2DC36C9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-3-yi.l.liu@intel.com>
 <BN9PR11MB52768AF474FAB2AF36AC00508C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752972AC1A6030CB442ACF3FC36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230427123203.22307c4f.alex.williamson@redhat.com>
 <a6b77884-1678-b17c-f6a4-28d56e6c366b@intel.com>
 <ZEu3Ga9cIQAykBGf@nvidia.com>
 <3b83d829-048b-174f-a21d-b28ad0b7b49e@intel.com>
 <ZFFSff0cV/eC7IZ2@nvidia.com>
In-Reply-To: <ZFFSff0cV/eC7IZ2@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH0PR11MB5952:EE_
x-ms-office365-filtering-correlation-id: 2fd338c9-5f82-4562-4836-08db4bbb90ac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nHInaiB4tHcgk7+1AKw7pqANyChHjFAH9Ltv48PY3U8zyArt9u9vdcEAk5QyKZxs4ZOGBbRtTIMXeGTMRvFHh1fb9kbv40X61BP5tu1GyndiYY1NAZbWXCq9AdmdSPmQHTG09up73dNfQKrMF2IcdcieeCMmhswB26udS3mWxhewcproJyUqJLq+ufBg9yjgHQ/1Y2kwDtelfNzZ7MKBd2ABcV2ZSqijfTu7wv0xe4EYbAmarPVu0/FYzcN5datEEJrtBhwUMQcSrzqYxVDCaTsphXYoS3FtCtus19zGszyh5CustMsP/nsJCfaFpF9nPLtt40g9HVRA56p/k13erFP2TL7AzZVI23MwCQi+a7+LJ8QP7Pql2Cf95/h6PllYOqw/GIuWcnmAegnUOI5GTUXsxOmQrt+CcNViMamUgfz6fZAeEeRvR5+6vYrlZnIIWDRaWJimEQU9gl1pChiSHVeTqsdvU6Y4ufgCVKGZvBeGWIpr0PRhkiNlbwI6Q4LeZxyi1sTp3bMK82bWnWg8EsSCi/H0njbwryS6+bf5Gxf40dcKDZzTXP7TOOjQHwMF/S9Q/uYQsxnsGkBZHf/B15K6XnZO6GN+CJufgs4y7T1iCx0yFrfjCTsfErVPIGjf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(39860400002)(376002)(136003)(366004)(451199021)(6916009)(66946007)(76116006)(66556008)(66476007)(64756008)(316002)(82960400001)(4326008)(478600001)(7696005)(33656002)(54906003)(71200400001)(86362001)(55016003)(186003)(66446008)(6506007)(9686003)(26005)(2906002)(38070700005)(7416002)(83380400001)(38100700002)(52536014)(5660300002)(8676002)(8936002)(41300700001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUoycXBXOCtlN1pDT0RSeVB4dVlsbzlUUVFFVzdndmNPaGFxYXczOEdPTFo2?=
 =?utf-8?B?NjlFYUlhT1BTNzV5MVFiZitMc3FHWUkwdkU0bUF4QUhlVEVLakJCNGdvSFRh?=
 =?utf-8?B?MjFPNmN1UW9SYkx0NVB1aEFSckFPMGM3RFV3THM5OHlrN3pjRitEdVBKVVEx?=
 =?utf-8?B?Uk5zUGRSQXZpMmR5SC9lbm1aTDV4dk0wSmdWMVdKL0ZPTjZiajdJUGNMZkl3?=
 =?utf-8?B?bDc5Wk9NM0Y0NkdONndQbGxMMktVNGpyM0hWZkhES2R4ZmxnNE9LNEVsTDZL?=
 =?utf-8?B?c3pIVjNXa0twZnpDTTNNWmZISkpLRFBVdFNRZU83Y0VlNFFZNVdZZUJPSUhx?=
 =?utf-8?B?VVAzVjhOcFBEaDYzd2M4M3FsY3UyWjBMdk5lZnZHR0NIMzBIdU40OFVVYVNB?=
 =?utf-8?B?SHBVazdwU3hlTFBlNmZ6dVhmSjhYN2xaM3RCalRJRWFsdHlZSUQ0WnBROXVH?=
 =?utf-8?B?NmxaUUlRVTNNUXVxeVR0cWpscE5NUE9WTVpJaW94c0x6ODJpQ29BZnhPTlBN?=
 =?utf-8?B?TlVidDVURjRVQ3NCSHVadllyWkU2eGpubGFPMGNmNDB5L0I4NjgwWmRFcHNW?=
 =?utf-8?B?Nmc0NnlLR1BOd2pwTlFLT25TSTZKNWRVaDZwVS8xMER0UWxSWGZMK1FCVXI0?=
 =?utf-8?B?K0tnelZrbFc4eTQyUEM5OU5CK2lGamNFSVlyMG1Pb0VXWnJ6UEdjUU5kbjVK?=
 =?utf-8?B?NGNTTGp6WG0vWERzV21mTGhBbGQrZURYNldaVUVNSitsajlZRkM1U1dmM1ds?=
 =?utf-8?B?SktwZnE4bGp1clZMR3dUbFhpMjNJYnJvczh5NEo4L0lPdjlIMTk0NisxNmt0?=
 =?utf-8?B?SVp5cVZEZldhU3dmaFg0Wk1LOE4xN2JyeWNNWHpJclpPaGhlWUprbmNrR1l5?=
 =?utf-8?B?MXkzWE5aVWtMUlFyd08wM0h5b3NrR2gxUDRrMHdadlVxSDVLUTJ2bkRyb09s?=
 =?utf-8?B?RkQ4NnEwRXNDYnR2amh5TUI0SjdlUnUzK0JvYmFHVEsxYXBZMFgyeFY1ZlFO?=
 =?utf-8?B?UUozRVA4MkwvYkh2Rmo4SUhhSjlWWnBnUW5PU0FIeVBPWU9DNEpHYUxUSDFp?=
 =?utf-8?B?UFJjVlZVODVqdStmRzgzRVpHMGlJenk1WGtzS3NORThPNFh6MWxhT0hWeVZz?=
 =?utf-8?B?aGdiM1BNaWhQQ0JObXpaRnM2QXIyc09BREN2bGtNZ1RBcnNqRzdjaWxCOHVq?=
 =?utf-8?B?bUQyVUZzZExtY283Sm8ydkFRbkxMcGlBZXFFamdGREQ4RUdRWWV5OHFPS0ln?=
 =?utf-8?B?Uk05OUJLcjVIWDNXM011NlBoK3hNUmdLNWdoL3RHNk9HcGVLbGh1S3F6c1VU?=
 =?utf-8?B?YUlkS2YxTUVBRHBTaHVzU3JqTFVQL2ptK2l6eUt1Vkl6T3hPZ2VLMVplTzM4?=
 =?utf-8?B?NlRYZVV6MzR3U1E3NjlWaGJ2bEtOZ3MvTDZkZlFrYkZkNWx2dWZMQUNlVW13?=
 =?utf-8?B?VmRvUlZndGlnZHUwSHIrT0hqeHJjeThxWmo0WHlPOUhWeWlKMktqTkNQVzJt?=
 =?utf-8?B?WjBDNDFuV083MnJSeGE4ZnE3TUx3VUZvRFNMODJuUmlwaXhCc21qd2V0dmFh?=
 =?utf-8?B?QlcyU1ZrL01mWkJlQVdiVDFMdWRmYzhTTTVMb2dnUHpkVzJqRUdZZHVZTUk1?=
 =?utf-8?B?QmQyVU10THZSUm82OVNGaHpLeDNEY1B1WSsxeVBRWDk0OSs4eXgvR1B2b01W?=
 =?utf-8?B?NW5tREt6QjdvTkduclE5TG1Eb2JXS3V6N2Z4VTUzV2krVVQyYmN2Z2owV0hM?=
 =?utf-8?B?a2g5UVVQRStvOUZmY0RrZXExN3VyQ3pLVFdVQXRKVHY2WTBOVU5tWXVTRzJV?=
 =?utf-8?B?Ykxrd0Z5MjdxdGlKaTVMaE9uczM1cnZpNXRpbTZ4K1pxcmg0aG01RHZ4enNY?=
 =?utf-8?B?NVlwV0pHaHZxam1XWVJsMlJ2cUtzaytQMFpQL3cxYkxacE5lcVNRcFBLdmdH?=
 =?utf-8?B?cFBWeW8vM3ZXd1F2ZWVqTEp5VnFGbW5rTFZEcWZOSlpmRGFZZkx5U21GOUsx?=
 =?utf-8?B?OUc1YUJ5dkMrdmVwMVJoSHcrOFk3R3UzUXl1Ukt4NDNlMDlZL0IzREVjUk5Z?=
 =?utf-8?B?NzVld0dsejdEblJUclhsanhtM2FBTW1TK2s0SkFqRE8weVpQTzdTaVFaL1Nu?=
 =?utf-8?Q?y28k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fd338c9-5f82-4562-4836-08db4bbb90ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 09:48:36.0851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YcvLIJyspv4SzfDtwRLMGG9Cl01qRlvfYh61HRRZfI0uzC/NO80G01DoJXZsKdiBBBp/bz80q7vArNN0QZepBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5952
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIE1heSAzLCAyMDIzIDI6MTIgQU0NCj4gDQo+IE9uIFNhdCwgQXByIDI5LCAyMDIzIGF0IDEy
OjA3OjI0QU0gKzA4MDAsIFlpIExpdSB3cm90ZToNCj4gPiA+IFRoZSBlbXVsYXRlZCBzdHVmZiBp
cyBmb3IgbWRldiBvbmx5LCBpdCBzaG91bGQgbm90IGJlIGNvbmZ1c2VkIHdpdGgNCj4gPiA+IG5v
LWlvbW11DQo+ID4NCj4gPiBobW1tLiBJIGd1ZXNzIHRoZSBjb25mdXNpb24gaXMgZHVlIHRvIHRo
ZSByZXVzZSBvZg0KPiA+IHZmaW9faW9tbXVmZF9lbXVsYXRlZF9iaW5kKCkuDQo+IA0KPiBUaGlz
IGlzIHByb2JhYmwgeSBub3QgYSBnb29kIGRpcmVjdGlvbg0KDQpJIHNlZS4gQnV0IGlmIG5vdCBy
ZXVzaW5nLCB0aGVuIHRoZXJlIG1heSBiZSBhIGZldyBjb2RlIGR1cGxpY2F0aW9ucy4NCkknbSBm
aW5lIHRvIGFkZCBzZXBhcmF0ZSBfYmluZC91bmJpbmQoKSBmdW5jdGlvbnMgZm9yIG5vaW9tbXUg
ZGV2aWNlcw0KaWYgQWxleCBhbmQgeW91IHByZWZlciBpdC4NCg0KPiA+ID4gRWcgaWYgeW91IGhh
ZCBhIG5vX2lvbW11X2FjY2VzcyB2YWx1ZSB0byBzdG9yZSB0aGUgYWNjZXNzIGl0IHdvdWxkIGJl
DQo+ID4gPiBmaW5lIGFuZCBjb3VsZCBzZXJ2ZSBhcyB0aGUgJ3RoaXMgaXMgbm9faW9tbXUnIGZs
YWcNCj4gPg0KPiA+IFNvIHRoaXMgbm9faW9tbXVfYWNjZXNzIHNoYWxsIGJlIGNyZWF0ZWQgcGVy
IGlvbW11ZmQgYmluZCwgYW5kIGNhbGwgdGhlDQo+ID4gaW9tbXVmZF9hY2Nlc3NfY3JlYXRlKCkg
d2l0aCBpb21tdWZkX2FjY2Vzc19vcHMuIGlzIGl0PyBJZiBzbywgdGhpcyBpcw0KPiA+IG5vdCAx
MDAlIHRoZSBzYW1lIHdpdGggbm9faW9tbXUgZmxhZyBhcyB0aGlzIGZsYWcgaXMgc3RhdGljIGFm
dGVyIGRldmljZQ0KPiA+IHJlZ2lzdHJhdGlvbi4NCj4gDQo+IFNvbWV0aGluZyBsaWtlIHRoYXQs
IHllcw0KPiANCj4gSSBkb24ndCB0aGluayBpdCBpcyBhbnkgcmVhbCBkaWZmZXJlbmNlIHdpdGgg
dGhlIGN1cnJlbnQgZmxhZywgYm90aA0KPiBhcmUgZGV0ZXJtaW5lZCBhdCB0aGUgZmlyc3QgaW9j
dGwgd2hlbiB0aGUgaW9tbXVmZCBpcyBwcmVzZW50ZWQgYW5kDQo+IGJvdGggd291bGQgc3RhdGUg
cGVybWFuZW50bHkgdW50aWwgdGhlIGZkIGNsb3NlDQoNCldlbGwsIG5vaW9tbXUgZmxhZyB3b3Vs
ZCBiZSBzdGF0aWMgZnJvbSByZWdpc3RyYXRpb24gdGlsbCB1bnJlZ2lzdHJhdGlvbi46LSkNCldo
aWxlIG5vX2lvbW11X2FjY2VzcydzIGxpZmUgY2lyY2xlIGlzIGJldHdlZW4gdGhlIGJpbmQgYW5k
IGZkIGNsb3NlLiBCdXQNCmdpdmVuIHRoYXQgdGhlIG1ham9yIHVzYWdlIG9mIGl0IGlzIGR1cmlu
ZyB0aGUgZHVyYXRpb24gYmV0d2VlbiBmZCBpcyBib3VuZA0KdG8gaW9tbXVmZCBhbmQgY2xvc2Vk
LCBzbyBpdCdzIHN0aWxsIHBvc3NpYmxlIHRvIGxldCBub19pb21tdV9hY2Nlc3Mgc2VydmUNCmFz
IG5vaW9tbXUgZmxhZy4g8J+Yig0KDQpSZWdhcmRzLA0KWWkgTGl1DQoNCg==
