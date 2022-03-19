Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1EE4DE6D1
	for <lists+kvm@lfdr.de>; Sat, 19 Mar 2022 08:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242421AbiCSHss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Mar 2022 03:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbiCSHsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Mar 2022 03:48:46 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E122E4177;
        Sat, 19 Mar 2022 00:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647676046; x=1679212046;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ueGWbsImG2opo67McsMcWatMTSy5Qk/7EZj4Pa7JO9Q=;
  b=fE3oDvkf2GVlfACG5Ug/KDQPNdDqtHu3Rn/nJ0ba/1J+JlPoVnCuvpNO
   QoWpP+zvKzjjS9/LpLzUKROrCq1LgvvJwYB1SQP4VmU9Lcuyis5amNivd
   BoUQl0PKOnDZkf0LWLgYlIYT2aN7EuHI6FD7wYah/NMW6J2uBrCMk0C+R
   Vny4tn+BcsSd+ChkI5BPLe8wsy2JRgJ4yb1YWEKMjuICkkmGza1yqz8/S
   Abcn2swCdYH90EVBnrfEukNVblBgeBEwbl3tWcjXervUzam4/PBNtNOPv
   IV6qVff32G+sPeKi7acmk0HvE2FjtmgZxTYM50teocs6L27XB5ETqvofy
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="237891904"
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; 
   d="scan'208";a="237891904"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2022 00:47:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; 
   d="scan'208";a="645881364"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 19 Mar 2022 00:47:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 19 Mar 2022 00:47:24 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Sat, 19 Mar 2022 00:47:24 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Sat, 19 Mar 2022 00:47:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfVoKHmR5lt3/J28JsaQaguUc9bnmieA3fx6JZujw/oY6fML5uexjEZk6r8IRT+OW7KTVD+Lp/8OblDGttJvux8b49Vf/Z85HbrNRBfyjg9uIVEFuExhlTFozwNnK6SMek3SG3Y/pYULou2uq9+0lNyKekGNdatWcePmu+wzoZFH4w0MMu9PWyxjYisfNbk/yTVajSxOADE8KFw5qiXbqbIm7GU4Xyhp9rVUQR/jkLWIEsMPjSbszvjhYOx2LGPOxX65/oBMpWMRa4GMwFr465oE0Vk282Jw3cs8SH1qAO1/fRKR7O6hUkvPZrx8Td96MvQdiDRq/SHd4OXTGJIsjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ueGWbsImG2opo67McsMcWatMTSy5Qk/7EZj4Pa7JO9Q=;
 b=QNgwJDoyFwD9vEoFSRqYzs6f0ucHaI09RejfySBsNY+/kC+nvKw7EDVYaDkasA85XCtpXAI3YTOviZKJt3gb134cEwrD5bTmQPhpAac9lJvkRfHtMXqza18lfSbM9J1WgH5xSC2NOcGSVO1o15B7xVyb37fEOTe9iwT8nwhkcHplqYMtRQQEkd2MGUEnozkSbYaZxqsCsndsOIDdyzi0DHtPYXHiQEBt8MVCtAPTo90BSvkEKSNphprj+0Z1hvzBUo5CPmepaB1TgcSC4Ya0tSyk8PJYLDNhK9F4fHwSoBS1xhSwt9G75PpIDpnxAjtXlwC7arShGJfRHgogCGqsXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR11MB1494.namprd11.prod.outlook.com (2603:10b6:910:6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sat, 19 Mar
 2022 07:47:23 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%8]) with mapi id 15.20.5081.019; Sat, 19 Mar 2022
 07:47:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "schnelle@linux.ibm.com" <schnelle@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "svens@linux.ibm.com" <svens@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "vneethv@linux.ibm.com" <vneethv@linux.ibm.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH v4 15/32] vfio: introduce KVM-owned IOMMU type
Thread-Topic: [PATCH v4 15/32] vfio: introduce KVM-owned IOMMU type
Thread-Index: AQHYN9xrQVYDc2PUskGgAyzdZ+WZ86y/fBmAgAAHrYCAAO/BAIAAFiEAgAQxgwCAAHI9gIABLEKA
Date:   Sat, 19 Mar 2022 07:47:22 +0000
Message-ID: <BN9PR11MB5276C1242BB4E770815D77968C149@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-16-mjrosato@linux.ibm.com>
 <20220314165033.6d2291a5.alex.williamson@redhat.com>
 <20220314231801.GN11336@nvidia.com>
 <9618afae-2a91-6e4e-e8c3-cb83e2f5c3d9@linux.ibm.com>
 <20220315145520.GZ11336@nvidia.com>
 <BN9PR11MB52762F1B395D27B1F82BBF0F8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220318134627.GJ11336@nvidia.com>
In-Reply-To: <20220318134627.GJ11336@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: abb333ab-dbe4-423c-b317-08da097cb458
x-ms-traffictypediagnostic: CY4PR11MB1494:EE_
x-microsoft-antispam-prvs: <CY4PR11MB1494B3745FD871DCF9073B2E8C149@CY4PR11MB1494.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b5JxOWDwwlYEh6siEzAjG1ufxNMWwVBOkJGjhVTE8T2U4L9V2vwlC/1rJ/M1wLWxetn/Ea6hUrLNYnKvNzGAcCxM+j1ek6OAop+blq+hfolycmtAtGo7i2y0EHk9f2bub0cmDWPaGlZ/nlLXzFyNvDZqqZz/NLVkv7jC5+j5PzbbD6fYL4SV2R26S6MgTrWlRe65oKVwsdjazuDO9n2EgAB6bb09ZFlgBWuZL7OREVYDeHmpLSANv1pahUp023x5E3EFMwwqdhD/u6esdm75Bql2UVYK07HJ0IrwCrMIXADnupYDruvTekjoYURiPQ0+ie+Xa9fXYrHFWoBEMQX2hfeW34ReHalVHc3JUzBKtFZvPmmrNxLPhsvZ9BAyZ0xPaB/8mHsCPosRKpTOlyGtJQ9pY8KeSYH1V1JvpA4K1lc/jcayFHrT7vvuy5nTEk0denjj8ShiSuC4UR0l1NjgxG/JHlkVxk/zVAv94HVA9sv7B+n5wOGFEANDPdBqMjVwykyGgjCAge4PEis3B1n4ZZFYiz2pva4Cb+4iobJ40zMa6rwPEUaFpUunWHYAsaXQ4OlqFm5lo99l/gPycd7h7L7wBaN1pYcG1C+2FJDEbQ0zl+ik0klFKtSgjFX3h+Dz2wUXgX5SnE2rFJsesZ9nGZbcWrR//zMF51RfgYSETYxawcyLOgKi8pweEMuu0nfiJ2gN/PXNRRbtnvvDJiamfQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(8676002)(66476007)(4326008)(66446008)(64756008)(76116006)(66946007)(86362001)(38100700002)(508600001)(9686003)(71200400001)(26005)(7696005)(186003)(55016003)(38070700005)(6506007)(33656002)(54906003)(8936002)(5660300002)(52536014)(7406005)(7416002)(122000001)(2906002)(6916009)(83380400001)(316002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QWlFa3JqSXZ5V05rNmR5WW1jZUorOXZ6OXQydW5Id3ZLcnVpalpkSkRiZjNG?=
 =?utf-8?B?aFIzSm5VbStEdCs0dGxUOFAwWHlVN2FoTXpnalhCdXhMcWxPWGNMZGUrZWNC?=
 =?utf-8?B?TVBnM0RtVXA3KzhpOFhvVjkyVFZCTmtpN3JaandpWkpCTEJDUXJjVnVpT2ZR?=
 =?utf-8?B?anIvTDZCUzZLalorR1pDYlJoQXJ3Q2w1MkxmVUl6Y0lUeUdGQWhUeVFuQ05P?=
 =?utf-8?B?QnFQWGxXM2dKVWUvNTI3QVlVNnF3di9wT0taNjRaT2xPZVB4eStuWkZ6QkNt?=
 =?utf-8?B?ZSt3VDJsdFZiYURPS1dOS1pWWTZhUXpDZ1lhdWRrV2VaalZGck5TK2ZsRFZ0?=
 =?utf-8?B?OFBSUy91NzlDZzh6YWVVeHpvWjhrUnlOd2JQREhxWmlTeWV2V1lNWDRjQlFT?=
 =?utf-8?B?dGw0SWcrUXA2MC91aElRV2R5NGlMUEhQZTJHRnpRbnBTWERSa2E0R0FDdElD?=
 =?utf-8?B?WXpNU0xCNVFwbDdCWXVuTk04Vm5USDBxZk5pcmJSM1dVZjZFLzQxM01oNWNl?=
 =?utf-8?B?eElNcVYvRWhIeGxVZkdBUThUUTJMN2FmSzRRMW5sL09oSldXOGdIL1JkUWQz?=
 =?utf-8?B?ZHBRT0Z1KzdXVDN4ckRGcll6NTZSOU1MQVMreERjMkF1cGNGSEI2bG9VOEdD?=
 =?utf-8?B?eVZwYm5JRHdFRDZ4S0oyRHM5Mk9xM1EzdmdIV2ZsRjZJTElEUWpPUHNoa0Q3?=
 =?utf-8?B?QTU5L3lyaW1rRWd3N01KRkVNMDVMTzBKc3FyU2d5SjJHbmkvV0drWWNwaWk0?=
 =?utf-8?B?VjVJd1dUMFdNREtaeFkzOENmNVBsb2xJZ0crTGF5OVJRUllTaDlHMmVXcncv?=
 =?utf-8?B?MktXdG1GZXhudlh1UmxlZTJhTVpqQ0RKcFJzTkxFNFI5REUvWXc1M2hDTTNy?=
 =?utf-8?B?Ulh6Nmo5K3BndzRyNFAxTkVmVUhiV0dWQVJreWh4Wi9GOVByT005LzltZjFF?=
 =?utf-8?B?Tmd3Z2pGUndFZ01VQldTTVJabjZVQW9CVVA3d0xjdU8zVjFITXZQZko1WmtT?=
 =?utf-8?B?QnpGS3V2aGx1YmZIbzkwUnczTmJYUnZvNktycng2NGhSUkhWVU9YWjdDODVo?=
 =?utf-8?B?SWQyR2lJUVRKbFcvRzh2UjBIYnUyZGpqdzBoaFIyWGhrRzNUdVdIQW5YZGdv?=
 =?utf-8?B?ZHdUc0ZwbmVYeDk2azZKY292YStjMmh2UnRWODVkczBMVzEzQTdMelBLZWRZ?=
 =?utf-8?B?ak16eC9XOEFxSEFzdk5leTBDN0xRZUg4Lzc4b0JiRWVpZkdFME9Sb1dkMHNu?=
 =?utf-8?B?aUxsRWxPWi95SSt5UklBWjJSa00rNzlCdjd5YVBrV1lQUHRpRUJHSmJXOVBR?=
 =?utf-8?B?Y1ZLRkxCWDM5UjNTNThwK2I2UWU3UVI0Sk9YZ2RNYW83RFFZUEhlRExwR010?=
 =?utf-8?B?d0ZYWmllZ1REQm9KRTN3VXhoMzcwcG5vanJvQVBSdTlFN2RZQkNZbm5KbVB6?=
 =?utf-8?B?alBYZ1JvZ0sreUVTeWJhYS9DZjRZSmY1enhaZ1RjUWw1TGYrOXU3Z3dyMUxq?=
 =?utf-8?B?S3Z0MWVMSDBKMmJBaEZkWWRjQ0RUR0dielRQRzJ0NkJicWtlWXQvMVlxQ0xI?=
 =?utf-8?B?Z3FOSGI4MCtxZWZBMWZ0ZWx6ZzIxUXd1UjRrd2ZDUW9hUExUWC9Udzd5Qm5W?=
 =?utf-8?B?RWdWeXJURGlXcVdwaXN1aE5pUWxIcnBTWCt3cnZSb0RsTmhzeXlLamE1eGg0?=
 =?utf-8?B?ak94UzZVZzZ0WjU4UWlGVU01K25rTEdaVElrWG1WYk9JbWI4Z0NmWDZOQXFx?=
 =?utf-8?B?M1VTbG10VGhsMlEzWHZaOGZwOUdQUExIZ3NabDZsdHFmcHZSaFFGYmU4RlN0?=
 =?utf-8?B?azh5WW8xcWo3U25XN09yb0tQSXRRelhhZEpoVGRpY2RoK1A1WEtnL2EzbDZP?=
 =?utf-8?B?ZDM0NVBtVWFjQVNXSG1DZEFiZEljRW9pbUs0SFA2NFVkR3hVc3ZxMVBhSnNn?=
 =?utf-8?Q?CTQSk3kQENe/j4r9PHEM7RA8xX+YqU3l?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abb333ab-dbe4-423c-b317-08da097cb458
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2022 07:47:22.9840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sIF3W7GmCbQA3Vb0r64lPDc7LExAczNcCptUzkbYXOQxGQDIkta4GjV3nd12pi8l7qnTlVqtXMAEOJF8rrbrVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1494
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBGcmlkYXks
IE1hcmNoIDE4LCAyMDIyIDk6NDYgUE0NCj4gDQo+IE9uIEZyaSwgTWFyIDE4LCAyMDIyIGF0IDA3
OjAxOjE5QU0gKzAwMDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+ID4gRnJvbTogSmFzb24gR3Vu
dGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4NCj4gPiA+IFNlbnQ6IFR1ZXNkYXksIE1hcmNoIDE1LCAy
MDIyIDEwOjU1IFBNDQo+ID4gPg0KPiA+ID4gVGhlIGZpcnN0IGxldmVsIGlvbW11X2RvbWFpbiBo
YXMgdGhlICd0eXBlMScgbWFwIGFuZCB1bm1hcCBhbmQgcGlucw0KPiA+ID4gdGhlIHBhZ2VzLiBU
aGlzIGlzIHRoZSAxOjEgbWFwIHdpdGggdGhlIEdQQSBhbmQgZW5kcyB1cCBwaW5uaW5nIGFsbA0K
PiA+ID4gZ3Vlc3QgbWVtb3J5IGJlY2F1c2UgdGhlIHBvaW50IGlzIHlvdSBkb24ndCB3YW50IHRv
IHRha2UgYSBtZW1vcnkgcGluDQo+ID4gPiBvbiB5b3VyIHBlcmZvcm1hbmNlIHBhdGgNCj4gPiA+
DQo+ID4gPiBUaGUgc2Vjb25kIGxldmVsIGlvbW11X2RvbWFpbiBwb2ludHMgdG8gYSBzaW5nbGUg
SU8gcGFnZSB0YWJsZSBpbiBHUEENCj4gPiA+IGFuZCBpcyBjcmVhdGVkL2Rlc3Ryb3llZCB3aGVu
ZXZlciB0aGUgZ3Vlc3QgdHJhcHMgdG8gdGhlIGh5cGVydmlzb3IgdG8NCj4gPiA+IG1hbmlwdWxh
dGUgdGhlIGFuY2hvciAoaWUgdGhlIEdQQSBvZiB0aGUgZ3Vlc3QgSU8gcGFnZSB0YWJsZSkuDQo+
ID4gPg0KPiA+DQo+ID4gQ2FuIHdlIHVzZSBjb25zaXN0ZW50IHRlcm1zIGFzIHVzZWQgaW4gaW9t
bXVmZCBhbmQgaGFyZHdhcmUsIGkuZS4NCj4gPiB3aXRoIGZpcnN0LWxldmVsL3N0YWdlLTEgcmVm
ZXJyaW5nIHRvIHRoZSBjaGlsZCAoR0lPVkEtPkdQQSkgd2hpY2ggaXMNCj4gPiBmdXJ0aGVyIG5l
c3RlZCBvbiBzZWNvbmQtbGV2ZWwvc3RhZ2UtMiBhcyB0aGUgcGFyZW50IChHUEEtPkhQQSk/DQo+
IA0KPiBIb25lc3RseSBJIGRvbid0IGxpa2UgaW5qZWN0aW5nIHRlcm1zIHRoYXQgb25seSBtYWtl
IHNlbnNlIGZvcg0KPiB2aXJ0dWFsaXphdGlvbiBpbnRvIGlvbW11L3ZmaW8gbGFuZC4NCg0KMXN0
LzJuZC1sZXZlbCBvciBzdGFnZS0xLzIgYXJlIGhhcmR3YXJlIHRlcm1zIG5vdCB0aWVkIHRvIHZp
cnR1YWxpemF0aW9uLg0KR0lPVkEvR1BBIGFyZSBqdXN0IGV4YW1wbGVzIGluIHRoaXMgc3Rvcnku
DQoNCj4gDQo+IFRoYXQgYXJlYSBpcyBpbnRlbmRlZCB0byBiZSBnZW5lcmFsLiBJZiB5b3UgdXNl
IHdoYXQgaXQgZXhwb3NlcyBmb3INCj4gdmlydHVhbGl6YXRpb24sIHRoZW4gZ3JlYXQuDQo+IA0K
PiBUaGlzIGlzIHdoeSBJIHByZWZlciB0byB1c2UgJ3VzZXIgcGFnZSB0YWJsZScgd2hlbiB0YWxr
aW5nIGFib3V0IHRoZQ0KPiBHSU9WQS0+R1BBIG9yIFN0YWdlIDEgbWFwIGJlY2F1c2UgaXQgaXMg
YSBwaHJhc2UgaW5kZXBlbmRlbnQgb2YNCj4gdmlydHVhbGl6YXRpb24gb3IgSFcgYW5kIGNsZWFy
bHkgY29udmV5cyB3aGF0IGl0IGlzIHRvIHRoZSBrZXJuZWwgYW5kDQo+IGl0cyBpbmhlcmVudCBv
cmRlciBpbiB0aGUgdHJhbnNsYXRpb24gc2NoZW1lLg0KDQpJIGZ1bGx5IGFncmVlIHdpdGggdGhp
cyBwb2ludC4gVGhlIGNvbmZ1c2lvbiBvbmx5IGNvbWVzIHdoZW4geW91DQpzdGFydCB0YWxraW5n
IGFib3V0IGZpcnN0L3NlY29uZCBsZXZlbCBpbiBhIHdheSBpbmNvbXBhdGlibGUgd2l0aA0Kd2hh
dCBpb21tdS92ZmlvIGd1eXMgdHlwaWNhbGx5IHVuZGVyc3RhbmQuIPCfmIoNCg0KPiANCj4gVGhl
IFMxL1MyIGlzIGdldHMgY29uZnVzaW5nIGJlY2F1c2UgdGhlIEhXIHBlb3BsZSBjaG9vc2UgdGhv
c2UgbmFtZXMNCj4gc28gdGhhdCBTMSBpcyB0aGUgZmlyc3QgdHJhbnNsYXRpb24gYSBUTFAgc2Vl
cyBhbmQgUzIgaXMgdGhlIHNlY29uZC4NCj4gDQo+IEJ1dCBmcm9tIGEgc29mdHdhcmUgbW9kZWws
IHRoZSBTMiBpcyB0aGUgZmlyc3QgZG9tYWluIGNyZWF0ZWQgYW5kIHRoZQ0KPiBmaXJzdCBsZXZl
bCBvZiB0aGUgdHJhbnNsYXRpb24gdHJlZSwgd2hpbGUgdGhlIFMxIGlzIHRoZSBzZWNvbmQgZG9t
YWluDQo+IGNyZWF0ZWQgYW5kIHRoZSBzZWNvbmQgbGV2ZWwgb2YgdGhlIHRyYW5zbGF0aW9uIHRy
ZWUuIGllIHRoZSBuYXR1cmFsDQo+IFNXIG51bWJlcnMgYXJlIGJhY2t3YXJkcy4NCg0KWWVzLCBJ
IGdvdCB0aGlzIHBvaW50Lg0KDQo+IA0KPiBBbmQgSSBrbm93IE1hdHRoZXcgaXNuJ3Qgd29ya2lu
ZyBvbiBIVyB0aGF0IGhhcyB0aGUgUzEvUzIgSFcgbmFtaW5nIDopDQo+IA0KPiBCdXQgeWVzLCBz
aG91bGQgdHJ5IGhhcmRlciB0byBoYXZlIGdvb2QgbmFtZXMuIE1heWJlIGl0IHdpbGwgYmUNCj4g
Y2xlYXJlciB3aXRoIGNvZGUuDQo+IA0KDQpZZXMuIGxldCdzIHRyeSB0byB1c2UgJ3VzZXIgcGFn
ZSB0YWJsZScgYXMgcG9zc2libGUuIEJ1dCBpZiB0aGUgbGV2ZWxzL3N0YWdlcw0KYXJlIGluZXZp
dGFibGUgaW4gZGVzY3JpcHRpb24gSSBwcmVmZXIgdG8gc3RheWluZyB3aXRoIHRoZSBoYXJkd2Fy
ZSB0ZXJtcw0KZ2l2ZW4gaW9tbXUgZHJpdmVyIGhhcyB0byBkZWFsIHdpdGggaGFyZHdhcmUgbmFt
aW5nIHRoaW5ncy4NCg0KVGhhbmtzDQpLZXZpbg0K
