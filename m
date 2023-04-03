Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0EFA6D4BB5
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 17:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbjDCPWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 11:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjDCPWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 11:22:08 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC0B26B6;
        Mon,  3 Apr 2023 08:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680535327; x=1712071327;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/K+Fk4uY3jZ6Rf68ry6F3D8R/FPBsyZXqmLxyq18JOU=;
  b=OS5vSIS92VpEVkP4VQgEj/ybIvaEQ33Va0WA6gwIFyRCAEB6TxeUvLaA
   ODOmwwbBWoI7CnyXjmfgyuVD7zQ/jXNBZJBy5Gn4bDVmcB+w26HM1jDWc
   nXOIff/XcxBlYv/GkZadNk8DbRoHlfD7pnaM0XEup/+/PrGCj2ib/5EZq
   Gm2kXp4NOHCrGzOnI7zuGPy4UzPJtqEUBK4wFhhvpFtyFGfmBX9eW87U7
   bijCjFyud+EBtVHodf/9XLLiLbAf+Ym/+E3filcwNSXF3IrCY8zlIlRNj
   Vc8n/jnf0Rmv0H0SP7XVstq7KwvVCQEAQhsvEZ0VyTbu+6slkJc4IGD3B
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="339422544"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="339422544"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 08:22:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="636155571"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="636155571"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 03 Apr 2023 08:22:06 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 08:22:06 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 08:22:05 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 3 Apr 2023 08:22:05 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 3 Apr 2023 08:22:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhQltanh8qdh/w1vP4YgXsi4+0EohK01wwg6ZiETwY5qZVcVxjc83nEA6dqXSeVesNdXaHPo5tBp2kTvkG+9uW7fe3QozuDaSMBaoWmf6ff2rrRLM69JXt6Qj2OnXsf2p2EXXk2bqexXULUIsanWiXmZje058kk+xvtJjot8BmPHC+qFySxghfTKoQDsVVLlDgZDm6BzirT1jsz7Myy3yKZK/z+hF6ufAIkqekwGIBGXjsH2g2RpOhIz3VJms5X6NN0/aThekvcS2nx6yVH9NJgEQPPTwa7S1shEdCxH7fBlpcY9/ETJKPETgD0qs5W17L4ge0tImeajxDeuH3pPSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/K+Fk4uY3jZ6Rf68ry6F3D8R/FPBsyZXqmLxyq18JOU=;
 b=ZY8AP0dScdGpuJDWQhBKqDk3/xPYKkecJw8NsVqD36uwpoW6HfKRtdZTk86SEgtJ69ypyi5qPO5KDo9EnkGGlp1/bVEXoMA8e384VjR9HbiNu/R2wowbdskBJJKlAP7mUZ6EiRCz4p10EhjTb5S6EH1C6E6IFOT0YX6K2Vpasn6AIRh3cD+0siwfWKQRsCAZlRQmDXFTZXF2cYtFMoF/loFTqmmQwZbtISUI/IwVer5Qp+O8AzXfZSwadAJYl4GaEaZmQ7cQoenenftUsOXGjaGIo2M+sNI0W0uBBAuI4u8AjKSfPEkQcDzGZp3p3LhbZ8W1qjhYJEdW1MzuYSphHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW4PR11MB7162.namprd11.prod.outlook.com (2603:10b6:303:212::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Mon, 3 Apr
 2023 15:22:03 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.028; Mon, 3 Apr 2023
 15:22:03 +0000
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
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8ZTcVQgABjWoCAAAOE8A==
Date:   Mon, 3 Apr 2023 15:22:03 +0000
Message-ID: <DS0PR11MB7529A380EF7E3F33C5DCEE3EC3929@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-13-yi.l.liu@intel.com>
        <DS0PR11MB752996A6E6B3263BAD01DAC2C3929@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230403090151.4cb2158c.alex.williamson@redhat.com>
In-Reply-To: <20230403090151.4cb2158c.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MW4PR11MB7162:EE_
x-ms-office365-filtering-correlation-id: 8e12d068-5271-4fed-b839-08db34572d63
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pw71QSfQZEtWPt6lcv2+7eqlXoTlKuETJK1Me1pr8qOOIycSrmXyKAEq2BvmHU7RgUk5AhlC91nbJImyHANF7W/Q4IJzTctzGzKu55vAVE37qxs1gcQ1uLYSSGIVYFzNOWm6AD/0Iuk/i8idBetvkaUz5S8/0cKKuL/mM/S/VVKrZeL7iN9TFJOeqfJXuKjtDXvDxyfJb5N+JskzjW5XcV3pmyvO5OP4MEo1n1IwXnSV6yL23UPIPf8Sc6VhHoGIypV7PiRiYZnJBs1E3IUKyObV/MQFpW2/NJfKqdvlyrrGQMKFRGVBO45corcm9pAwwgfxWF/s62FiCrR0eQitC85TGETj4nRFS32qAEDtlENazbkUnpic7bopIr6pNqtEEDkOKX3EtnUrKDnE+InhCcOkKyTx2cVG/blSo0drYLfLKQF3GvkSfB8O7o9B2HPRYerlmWy88q9Z3GqDxFp69lVJTgMzOLB+hBwfZVUUB3JfJf5qEs1VSZeMn0psfRhgytAj3aoIQgw9klAlAeHf6mUixqXPI/fHe33RONaFRH7SliEKLRFcp5529+sgzCts/HpfQP7ObvFeY6YaKlHxiUy12PlvVKK619oT9xGT+kODf2Zy2CMttd+rWd080q6DrDX2oo83pVysRZ1laQOtoA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199021)(55016003)(6916009)(8676002)(66476007)(4326008)(66556008)(64756008)(66946007)(76116006)(66446008)(478600001)(316002)(54906003)(8936002)(52536014)(122000001)(41300700001)(7416002)(82960400001)(38100700002)(5660300002)(186003)(83380400001)(966005)(71200400001)(26005)(6506007)(9686003)(86362001)(33656002)(2906002)(38070700005)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NnpIdlRjdDBDMXNEOWs2WEF2RVBBUHdFc0FjVXFUZFprQ1ZJSCtlTjVxdkRN?=
 =?utf-8?B?QVNiM1NRSlh0U01JUUdMMlc3bEdncXhwOXpGWWZwR1loV3Z5L3FIbGQrVHVP?=
 =?utf-8?B?V1RUK1R5QWdEaUVhY0FrdThuaGc2eHF0QU5ZT3ZJeklYMkViU1hONU0yRkpD?=
 =?utf-8?B?dCs2Uk0yMFh4QXgyUGlhTksxRXRpNEhpRHFLblJIZzNUZ0xRZWZzRjVJUVBx?=
 =?utf-8?B?cFoxWDhocDlPWVYwRnhvVDJWbnE4TWR0S3VDQXNNbUoyOEVPcFlCMW9nWUpR?=
 =?utf-8?B?S0ljZk8zdTdWd3B1aEhQdFpPMGZ5SkM1eUdaMmF6aXNEMHRYVnhmUVdIZCtN?=
 =?utf-8?B?R1FJUGNqNjVoR096QUpyT1FGY3BnMVZpUmRsWXZJOXBTWHdZZXNOTEdyQmJq?=
 =?utf-8?B?cDNqYXRMakVnNTFVSzN3VnkxaXZSYys3NVlXRlNnclhVb1dKd2pBZEQwRVNq?=
 =?utf-8?B?NVZpdGxLL0ZFR0JrNGJTTVo4L3NWcnNISVMzclR1dlJpbWRDdElpZ2dwZVhL?=
 =?utf-8?B?VHY3YnZzNU1CTWVvdmdCLy91RWpwQTlqbFJZV1JGWmh0bW85S0ZoaWdvaGwr?=
 =?utf-8?B?UEhlQnM5YnhuMTY2ZTBXYWowZy94VzM2QUxHbXdMemd6bzlaM3VUMEdJc0ow?=
 =?utf-8?B?MUMveHdtN093UVlvU2JaVU10VVlybmFpOTN2eHd5K0U2REFJUGdUcTgxeUdD?=
 =?utf-8?B?VlM5WE5paTFkc282VW1KbjU2UEVoazJKRHJFRUorQ2pSSDRGVlp1N0w1RWNB?=
 =?utf-8?B?ektYL3AwYk5ObzVOQmFPYkJmb200eDZSaU1zUUdpT1Z4bTFUTHBtN3ZydGU4?=
 =?utf-8?B?N2VMQjBtQ09WdjlEeFREZlNPb2FqeU1CWldObEJTcS8vWWMwMUdDT0pWYXFV?=
 =?utf-8?B?Mk5uWEp4NTdWZ0pKNmNHU1QrV1FjSjZ4aGZwQS8yQkZ4d0o3bEJ5bTU5ZGF2?=
 =?utf-8?B?NHpNdi9SaDdvTzFHQnd6a25kQ2lMcDFMV0tCV2w0RklDVmdNeUUyU0lDZ2NN?=
 =?utf-8?B?WVRaTTRUTHNhUzUzSXA1T2hRYnZ4M0s1bnhVeXRwNzNTQVI5N0Z1eTVqNkZu?=
 =?utf-8?B?T2lUbzl6d3BVQ0VqVHBob3p0MHl0bHdVekE1ZHlZZXBCbEVHam02SWptTWd3?=
 =?utf-8?B?QmhMNWd6eE9ySU5XL0E2Z3pmcW1oN1dzVlN3RmdEWHRWcjFudVJzZVpPS3M2?=
 =?utf-8?B?NEVtOGdSaVk5U1hYU2MwVithU1hxdU83bTY4OGdNN2FrUVdhdTVpaG5RZVhw?=
 =?utf-8?B?RmR2WllkWDlIVmY0N1h1NmtZalhwb3FGMFVCbjkxaGFXQSs3WWwxZGxjNTQw?=
 =?utf-8?B?N3k5UXRrbEdHS1NhK3A1elpZOW96S3IwSEFZb0hqUzVVVnJNTEg0RDAyOWIx?=
 =?utf-8?B?THc1aWk3MU8xSjRoWDRzQjhjL1BXYm5yNXluTHBwYTk4OXlHMkVSV3o3K0hw?=
 =?utf-8?B?WWR0amV1L05jMS9MRURHK2tIVFQxNVp4bEQ1UW82bXlKSldOSzV3cWlIZUZE?=
 =?utf-8?B?N29ETXVtL05pWFNTVmpXd3VXMS95RDJ5ODYycFlpd3ppUG5pTXh3VzRWeWVG?=
 =?utf-8?B?enJIeEorQSsxMFI5cHN5Wi9RTGhxL1V1bmNReXV0cEZITVZ2eGN4L0RkckJI?=
 =?utf-8?B?MGNxRkFkYzBPT2lMT2UrTUVMOFVKRE11ZEZjcUg4ci9UUm52WWFUcFA1cjc3?=
 =?utf-8?B?TVdtellDaFdrOEh4V1BzQkkyZFBXTUI1RXl3NnIvZ05aeWo2aVdrU0RuMjBm?=
 =?utf-8?B?Sm16cmZPanFDYjhib2J6SDVwWFJoOEJoclNpTEFCTDh1eHEzckROWWZ2bXgv?=
 =?utf-8?B?eUpXVkZrVnBLckFIZlBKZnNUa2VSSG05OWFrWkE3d1BZMFR4bDBPdUtJK0lX?=
 =?utf-8?B?SC9EbTRrcUlXWVB0QVZ6bGdMY2Z2MStqNnBuZkdLUHNRN1labWU2Szh3c0Zs?=
 =?utf-8?B?NmhHV3paYVlZWkNPdFROSXMwYWlVU2NybEd4b3QvQWZwQkc2cTRoTm10aXdv?=
 =?utf-8?B?MVVac2dOekI3VWRBcXNMdFY3OC8wRHFXMlBuUVpIUUViR2hYRGhITVpVU1lC?=
 =?utf-8?B?bTJQUU41YUlOQmpHdmhpZTl3MklMQktPa3JZZHdFS2d2ZGtDdHFqK1lrSnRR?=
 =?utf-8?Q?KfNKac1N0FfXkDdUr1MRS/Xv/?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e12d068-5271-4fed-b839-08db34572d63
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2023 15:22:03.0800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BUcMrVHe49U7uBKvESyiO+fLUXjgdcmlg3vT1WGFRWkMN6GdnIlBIbQ7PEcjn9XdvNxqMVrlARr4hig1qIsLig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7162
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBNb25kYXksIEFwcmlsIDMsIDIwMjMgMTE6MDIgUE0NCj4gDQo+IE9uIE1vbiwgMyBBcHIg
MjAyMyAwOToyNTowNiArMDAwMA0KPiAiTGl1LCBZaSBMIiA8eWkubC5saXVAaW50ZWwuY29tPiB3
cm90ZToNCj4gDQo+ID4gPiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4g
PiA+IFNlbnQ6IFNhdHVyZGF5LCBBcHJpbCAxLCAyMDIzIDEwOjQ0IFBNDQo+ID4NCj4gPiA+IEBA
IC03OTEsNyArODEzLDIxIEBAIHN0YXRpYyBpbnQgdmZpb19wY2lfZmlsbF9kZXZzKHN0cnVjdCBw
Y2lfZGV2ICpwZGV2LCB2b2lkDQo+ICpkYXRhKQ0KPiA+ID4gIAlpZiAoIWlvbW11X2dyb3VwKQ0K
PiA+ID4gIAkJcmV0dXJuIC1FUEVSTTsgLyogQ2Fubm90IHJlc2V0IG5vbi1pc29sYXRlZCBkZXZp
Y2VzICovDQo+ID4NCj4gPiBIaSBBbGV4LA0KPiA+DQo+ID4gSXMgZGlzYWJsaW5nIGlvbW11IGEg
c2FuZSB3YXkgdG8gdGVzdCB2ZmlvIG5vaW9tbXUgbW9kZT8NCj4gDQo+IFllcw0KPiANCj4gPiBJ
IGFkZGVkIGludGVsX2lvbW11PW9mZiB0byBkaXNhYmxlIGludGVsIGlvbW11IGFuZCBiaW5kIGEg
ZGV2aWNlIHRvIHZmaW8tcGNpLg0KPiA+IEkgY2FuIHNlZSB0aGUgL2Rldi92ZmlvL25vaW9tbXUt
MCBhbmQgL2Rldi92ZmlvL2RldmljZXMvbm9pb21tdS12ZmlvMC4gQmluZA0KPiA+IGlvbW11ZmQ9
PS0xIGNhbiBzdWNjZWVkLCBidXQgZmFpbGVkIHRvIGdldCBob3QgcmVzZXQgaW5mbyBkdWUgdG8g
dGhlIGFib3ZlDQo+ID4gZ3JvdXAgY2hlY2suIFJlYXNvbiBpcyB0aGF0IHRoaXMgaGFwcGVucyB0
byBoYXZlIHNvbWUgYWZmZWN0ZWQgZGV2aWNlcywgYW5kDQo+ID4gdGhlc2UgZGV2aWNlcyBoYXZl
IG5vIHZhbGlkIGlvbW11X2dyb3VwIChiZWNhdXNlIHRoZXkgYXJlIG5vdCBib3VuZCB0byB2Zmlv
LXBjaQ0KPiA+IGhlbmNlIG5vYm9keSBhbGxvY2F0ZXMgbm9pb21tdSBncm91cCBmb3IgdGhlbSku
IFNvIHdoZW4gaG90IHJlc2V0IGluZm8gbG9vcHMNCj4gPiBzdWNoIGRldmljZXMsIGl0IGZhaWxl
ZCB3aXRoIC1FUEVSTS4gSXMgdGhpcyBleHBlY3RlZD8NCj4gDQo+IEhtbSwgSSBkaWRuJ3QgcmVj
YWxsIHRoYXQgd2UgcHV0IGluIHN1Y2ggYSBsaW1pdGF0aW9uLCBidXQgZ2l2ZW4gdGhlDQo+IG1p
bmltYWxseSBpbnRydXNpdmUgYXBwcm9hY2ggdG8gbm8taW9tbXUgYW5kIHRoZSBmYWN0IHRoYXQg
d2UgbmV2ZXINCj4gZGVmaW5lZCBhbiBpbnZhbGlkIGdyb3VwIElEIHRvIHJldHVybiB0byB0aGUg
dXNlciwgaXQgbWFrZXMgc2Vuc2UgdGhhdA0KPiB3ZSBqdXN0IGJsb2NrZWQgdGhlIGlvY3RsIGZv
ciBuby1pb21tdSB1c2UuICBJIGd1ZXNzIHdlIGNhbiBkbyB0aGUgc2FtZQ0KPiBmb3Igbm8taW9t
bXUgY2Rldi4NCg0Kc3VyZS4NCg0KPiANCj4gQlRXLCB3aGF0IGRvZXMgdGhpcyBzZXJpZXMgYXBw
bHkgb24/ICBJJ20gYXNzdW1pbmdbMV0sIGJ1dCBJIGRvbid0IHNlZQ0KPiBhIGJyYW5jaCBmcm9t
IEphc29uIHlldC4gIFRoYW5rcywNCg0KeWVzLCB0aGlzIHNlcmllcyBpcyBhcHBsaWVkIG9uIFsx
XS4gSSBwdXQgdGhlIFsxXSwgdGhpcyBzZXJpZXMgYW5kIGNkZXYgc2VyaWVzDQppbiBodHRwczov
L2dpdGh1Yi5jb20veWlsaXUxNzY1L2lvbW11ZmQvY29tbWl0cy92ZmlvX2RldmljZV9jZGV2X3Y5
Lg0KDQpKYXNvbiBoYXMgdGFrZW4gWzFdIGluIHRoZSBiZWxvdyBicmFuY2guIEl0IGlzIGJhc2Vk
IG9uIHJjMS4gU28gSSBoZXNpdGF0ZWQNCnRvIGFwcGx5IHRoaXMgc2VyaWVzIGFuZCBjZGV2IHNl
cmllcyBvbiB0b3Agb2YgaXQuIE1heWJlIEkgc2hvdWxkIGhhdmUgZG9uZQ0KaXQgdG8gbWFrZSBs
aWZlIGVhc2llci4g8J+Yig0KDQpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC9qZ2cvaW9tbXVmZC5naXQvbG9nLz9oPWZvci1uZXh0DQoNCj4gQWxleA0KPiAN
Cj4gWzFdaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjMwMzI3MDkzMzUxLjQ0NTA1LTEt
eWkubC5saXVAaW50ZWwuY29tLw0KDQpSZWdhcmRzLA0KWWkgTGl1DQo=
