Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F103C73D88A
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 09:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjFZHbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 03:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjFZHbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 03:31:35 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CF5E0;
        Mon, 26 Jun 2023 00:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687764695; x=1719300695;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ruY20NAQ08oiR1PebyTz+Ma7La4SJPgiZxvT2aHjzFQ=;
  b=LeHws0mZ5/4f4YI9TOoK4nwsPqA3ULspIOvyC4e0IMKPp2d5nr5Ah6Kz
   iIvFVGaKbztZiGsdVfL7db0cweudDlGUsK8r+GYEdY6p4q8kxO/Pa3asm
   z6OdYuOMhBdp/oXosoPyDZJbGLA9t9yeGNaVa4LQfNDkR5OyoCR4B5vGx
   P293WN3cdCDMqQbWwo4plUWdVfpshbITop04fyduIyRJ1dUMhqcEvobsf
   M1Atrq5iWt9I80VG9Bk8rxdfstIMaAFQ866m1DZEj8PDG+Wr3roFI9B4P
   w989zVTLY5IakdtXk4bfD822o03Io1yVlmhzeIWXhaCt7K7XxYaBQgNiH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="427193406"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="427193406"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 00:31:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="745694975"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="745694975"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 26 Jun 2023 00:31:34 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 00:31:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 26 Jun 2023 00:31:34 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 26 Jun 2023 00:31:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ToqC73nc3jPweECAtoDoZqGiFCR0NGRQk4DwPT/vQLxUMxHGU4Xk3H9cqSmsy/qbSUhMHJWtQ/vl4XxFiPOG03J1y08NQ/UHNwkmpPqUnJrnJ3HSPmQdNHuTHdKfON4k4euaPaLTGCgv66QKdGdVRfVuvAGW+/Lkrdja5Wrh7i5PCak+8sd+j9lJc6oC1GOwQziDjEwoZxj5K+pZHF04MGKo0SO4pGTteYIaVk1SKLXBPvz3PDBgw4lGRTqqiD8qXrsOBu1nS0OdlJs7aP9Aga2IIlp3VvsnbV+HC5E/r4+Lo8Fp9eHCnVNi8kSH40PI8GtroQn+0BSfYBak++W2vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ruY20NAQ08oiR1PebyTz+Ma7La4SJPgiZxvT2aHjzFQ=;
 b=j5dcT2/HUAlwEuMDRMbCCTJdO+XVmKthHxTvWc4+aCdfzlKOwX7uFfI3HjYH5yu0I03EMmXABL3X6tdUdi6uALCAzNBGyRDTv1U06WTYhoCerUMOqthHGK8FKj2fYQtRR3FRDp9f/IJNNdZrbV0O1t063dHx8wNTRi0jg0KrclV4x6jtecGFxc1WnWrx7etOR7STbMe+QOtNn0wydOq5NZedc7NmwzjFa6y1iB34wyPAKM2PEgDOYXtUPI5a3gdjznyY3f0avR6IXMwTWtdi+UV5ezr8MWjVlp7RX6n48Z/R5aDw660TbHgPa/RBuAXSbFPlrxIFlS2bUm+107EzpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB7563.namprd11.prod.outlook.com (2603:10b6:510:286::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Mon, 26 Jun
 2023 07:31:32 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6521.026; Mon, 26 Jun 2023
 07:31:31 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v10 vfio 4/7] vfio/pds: Add VFIO live migration support
Thread-Topic: [PATCH v10 vfio 4/7] vfio/pds: Add VFIO live migration support
Thread-Index: AQHZlZ4kU3Fwl99xbECsoSBHo1JwW6+NFosQgAUWbwCAANnr4IAAtAcAgAEnoKCAAHp3AIAHb+Ew
Date:   Mon, 26 Jun 2023 07:31:31 +0000
Message-ID: <BN9PR11MB52762ECFCA869B97BDD2AA9D8C26A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-5-brett.creeley@amd.com>
 <BN9PR11MB5276511543775B852AD1C5A88C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZJBONrx5LOgpTr1U@nvidia.com>
 <BN9PR11MB5276DD9E2B791EE2C06046348C5CA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZJGcCF2hBGERGUBZ@nvidia.com>
 <BN9PR11MB52763F3D4F18DAB867D146458C5DA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZJL6wHiXHc1eBj/R@nvidia.com>
In-Reply-To: <ZJL6wHiXHc1eBj/R@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB7563:EE_
x-ms-office365-filtering-correlation-id: 77554316-389f-4452-320d-08db76175cca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2pDrDCh5P+2cX1+td7Nbqfnq1sdMX3caxhCHKPp8pIOgx0X84dLaUIz8gNzxCVL3jyfKYWR8vO2IsJXOeKVYxpS8mnUtJNizY8oW37acjWY7cfXCfludi5ZjFseMk5F3wZ3N0t2QuZgI2nUjLFCS4dEHpvM7oVjR+W5RkVhdl9vKTfWTUPALLss2/0fIODaextE5oRopnPdgDm6cOtWCmEFjt4yZYE1ZJYhO1Hl9kCD12Du4vU+LV+zmHTg0E6xu3ClSrSoBShiGIba8lffKcB+AvQPEWDHMF/JPgDzWoYQurBvOPy8835bhg8QfEl27SylvNAevmOAceNsaVLk9fyHxKgYAlb5Su1ajGARi8q3xfx9v8c1UBrpuUH1bh3Nh7brg26fGYS6YJPchmdMYPRqLeOtpLcZ4vqXq3995bbYxGde9gDM6JBr9uzyAQVYEd47rvGEJLlSSYEjB0o4kj5UYt/jiUYF3BU9RJpv/kfQk9ZMD+AJrNNB6nzKEohY86NXmYxyQUUfpdsn1/P/O7a7DwOFbZTG27wKFKRuB786K6oh9VOZEDlo49h7+2eN18bokqpIpklmYeZZhi5u9c63C3hegWPRBCVnnfOPq1i23DFJ0BTeu9o/x17cHGTGh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199021)(33656002)(52536014)(38100700002)(122000001)(55016003)(26005)(6506007)(83380400001)(9686003)(82960400001)(186003)(8936002)(2906002)(8676002)(5660300002)(41300700001)(71200400001)(478600001)(66476007)(38070700005)(6916009)(66446008)(76116006)(66556008)(4326008)(7696005)(64756008)(66946007)(86362001)(316002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MElkaUFlZndoUTErZ1dmTng3T0hSMTRUbWt1RCtlaU4weHZFaDd2ZG12RjBq?=
 =?utf-8?B?VkM4ZmxpaERUVFByalZxcEdaYVpleE9XOXhEUDdNWmkxNEhtNVF1amt3SDJ5?=
 =?utf-8?B?K21CMzUvZVUrSmpuTEZiUHdXaHRKdnFPYStQZXl5eWh2ZFN2WlczdThEaWxm?=
 =?utf-8?B?YzJvaDJxUU1wVlF5alk2emVtZmxoQW53Q2JpT0E3bXhXRDJkTnByZk12ZjV6?=
 =?utf-8?B?aU54ZDlHM1hCN3AzUWNRMjhISjUyS1VLaUF4cTFvellDYkdveUQyejUyYUJR?=
 =?utf-8?B?dWhGZlVUSVY2ak43MlU3L1pkWVhwQ3M2ZW1ScktIUDUvYVVqckJqNklHRTJu?=
 =?utf-8?B?WEhqTUtiN2hQMXhIcTQzVS81WVZBdEhYOUw0VmUvQlZTMHcwMGl3OVNOUkxD?=
 =?utf-8?B?d0FLR2dvdnFVTFh4NFdibXZhaUo2MGtjSE9GVDZZQUxNcW1Bc0dieUM0a2J3?=
 =?utf-8?B?ZGsrQmtDd21tTHVJY0s4VlBFWDJwSER0eHMrd3oycnR1RUlZUGVZMVdLbCtV?=
 =?utf-8?B?RzdFOFFBeVAzdmdNYmhLamdlbTV2YVJ1ZjY1QWhVZUQrZ1N1aXRTSVFCNUx1?=
 =?utf-8?B?NnptbS9rM1dma1FlQ0d2V2RJR21RN2J4em9XOUFneXdXTk03U1MxRndBZ2dK?=
 =?utf-8?B?WkFUVFdoUDF4TTA1OVdILy9Sak5lL0w2OXI4TVh6QW1yY0M0Q1RFNVlpQS9N?=
 =?utf-8?B?MEVnKzFtTWt5cHZQVzc1RGdWSEIrMURqY1k3eDFQcVFZNm1xVTNJMkZGOW9Z?=
 =?utf-8?B?aUJkVnlmOXgrekNQU0VBSDZUSlNJeWpvYVdPZDd3cE1YQTh5OE1UbDFSQjlS?=
 =?utf-8?B?Q1pCRUMvSlRadkRncy9MbXdUVDBsZERiYTdpN2MwZEFIM1FrdGNnMXJEVUN6?=
 =?utf-8?B?N0V4aTJmNmVlbmhPb2luOFdkdXhYN1BGOENDbi9QclIxQVE2MzUvVTB1ODNx?=
 =?utf-8?B?dEJPT1dPWnRJb21MUDN2MnA5OVhsbE5wWCs1cW41bm11dHdFQVVmWUFGV0JN?=
 =?utf-8?B?dWtvSG5SdjcvczAzTnZCeWxUSVhaMlh6R0JPRWg4YmVzTVlmR0ZyUm5wQ1Za?=
 =?utf-8?B?MjFpRXM3NGhBNXB6TDVKYmtUaXZrQ1l2ekE4eTJWaHpQOUFQc1AzZXpyYTJZ?=
 =?utf-8?B?WUVBKzQyOGlRM3U3K0FVZHVQMzhYMXo1UWdxRTFpRVlnM3c5Mm5maFZtb0pp?=
 =?utf-8?B?cmo5WEZvTjEwTldQLzBQRXFnbGEwam5uNmVQRUgrUFRpWC9sTW1vV2xSRzB2?=
 =?utf-8?B?U0RqSWRlSDJNbUlicldrYWhFeFlIUy9VQkIvdmgrZ2UzRU1KQmxMREV5ekJV?=
 =?utf-8?B?SnRvajlYWmhOUVBwUFJNbG5YWFo3SzY4cDlKaGxpWDI1Z0lOSG5JcE5oU0Qx?=
 =?utf-8?B?bXpEUXFmdnU3YjhsbXVRR2Q5MmZ1VXFiRDlXQUVhWkJDUndEWHdGdVB3eHFN?=
 =?utf-8?B?ZWxUNHBtN2JkNnNTWEpQWmNqWFNhdExGcmFucm9wSSs1Q0phU0FkUG9IT0Ra?=
 =?utf-8?B?SzVSY0FhNXRnOG8rKzBoc3hNeGxNM3BlWGFCVkJIOEZ5cWF5SHprNEF0TkYy?=
 =?utf-8?B?UEk0TTgwWFlMclQzVmdQeExFL0dPNDJMeTQ1ck9zTEFzOGNUazN1NXFTQkZH?=
 =?utf-8?B?NTB0QVljMHNTME5ZNlpLSzdxSzdJZHlUcHZIeUI0TmU0aWFSWnZkWEczWlR0?=
 =?utf-8?B?MjRiWFZ0TExUS2N3YnNZazY5SU9jeWJyU1pTSEZ4SGZSZnlYY2ZVblU3aVY5?=
 =?utf-8?B?ZGFnc213QjNXSWtHU2cxMVF6YWpXOWFvRC9ielRCRm5QRCtVclRwUWgwUUVl?=
 =?utf-8?B?TEpzV0g5eTBydjhVazdkdHpOUk5JOWI3SVczeVZBeStYL0N4cTh5NUYzRDdS?=
 =?utf-8?B?d0YvZ2M0MFR3VlNiUlJySTB5TzdDUGdzelpvOERqeGxRTVJQWDdsT3UxQUpV?=
 =?utf-8?B?VzVtRDZsOUNXa2lTVDBEMEg0MHgwUXpaU1ZFcXdudHdRbVl2SlZjdmFsKzVK?=
 =?utf-8?B?S2twMzU5UUludCtCOUN1RTM0M2djazI4Q0prVUZoKy82c2pMVy9BdzBleHpD?=
 =?utf-8?B?bkRLUXI2UUowVjRQaDVkS2poZ0lyMHZZMThQdnhweC9YeHRPY1VyRjJKZFUr?=
 =?utf-8?Q?52gBmFumzSStgHD9mpvOU02D/?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77554316-389f-4452-320d-08db76175cca
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2023 07:31:31.6043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ORvmD1s5AjSZfPXEipa9/laVXZgtaLp78AgNYs8YY+ilSdzeAQUQhpek37VGRjz3qVbCX6Gu9xNFDywG4kppEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7563
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIEp1bmUgMjEsIDIwMjMgOToyNyBQTQ0KPiANCj4gT24gV2VkLCBKdW4gMjEsIDIwMjMgYXQg
MDY6NDk6MTJBTSArMDAwMCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+IA0KPiA+IFdoYXQgaXMgdGhl
IGNyaXRlcmlhIGZvciAncmVhc29uYWJsZSc/IEhvdyBkb2VzIENTUHMganVkZ2UgdGhhdCBzdWNo
DQo+ID4gZGV2aWNlIGNhbiBndWFyYW50ZWUgYSAqcmVsaWFibGUqIHJlYXNvbmFibGUgd2luZG93
IHNvIGxpdmUgbWlncmF0aW9uDQo+ID4gY2FuIGJlIGVuYWJsZWQgaW4gdGhlIHByb2R1Y3Rpb24g
ZW52aXJvbm1lbnQ/DQo+IA0KPiBUaGUgQ1NQIG5lZWRzIHRvIHdvcmsgd2l0aCB0aGUgZGV2aWNl
IHZlbmRvciB0byB1bmRlcnN0YW5kIGhvdyBpdCBmaXRzDQo+IGludG8gdGhlaXIgc3lzdGVtLCBJ
IGRvbid0IHNlZSBob3cgd2UgY2FuIGV4dGVybmFsaXplIHRoaXMga2luZCBvZg0KPiBkZXRhaWwg
aW4gYSBnZW5lcmFsIHdheS4NCj4gDQo+ID4gSSdtIGFmcmFpZCB0aGF0IHdlIGFyZSBoaWRpbmcg
YSBub24tZGV0ZXJtaW5pc3RpYyBmYWN0b3IgaW4gY3VycmVudCBwcm90b2NvbC4NCj4gDQo+IFll
cw0KPiANCj4gPiBCdXQgc3RpbGwgSSBkb24ndCB0aGluayBpdCdzIGEgZ29vZCBzaXR1YXRpb24g
d2hlcmUgdGhlIHVzZXIgaGFzIFpFUk8NCj4gPiBrbm93bGVkZ2UgYWJvdXQgdGhlIG5vbi1uZWds
aWdpYmxlIHRpbWUgaW4gdGhlIHN0b3BwaW5nIHBhdGguLi4NCj4gDQo+IEluIGFueSBzYW5lIGRl
dmljZSBkZXNpZ24gdGhpcyB3aWxsIGJlIGEgc21hbGwgcGVyaW9kIG9mIHRpbWUuIFRoZXNlDQo+
IHRpbWVvdXRzIHNob3VsZCBiZSB0byBwcm90ZWN0IGFnYWluc3QgYSBkZXZpY2UgdGhhdCBoYXMg
Z29uZSB3aWxkLg0KPiANCg0KQW55IGV4YW1wbGUgaG93ICdzbWFsbCcgaXQgd2lsbCBiZSAoZS5n
LiA8MW1zKT8NCg0KU2hvdWxkIHdlIGRlZmluZSBhICpyZWFzb25hYmxlKiB0aHJlc2hvbGQgaW4g
VkZJTyBjb21tdW5pdHkgd2hpY2gNCmFueSBuZXcgdmFyaWFudCBkcml2ZXIgc2hvdWxkIHByb3Zp
ZGUgaW5mb3JtYXRpb24gdG8ganVkZ2UgYWdhaW5zdD8NCg0KSWYgdGhlIHdvcnN0LWNhc2Ugc3Rv
cCB0aW1lIChhc3N1bWluZyB0aGUgZGV2aWNlIGRvZXNuJ3QgZ28gd2lsZCkgbWF5DQpleGNlZWQg
dGhlIHRocmVzaG9sZCB0aGVuIGl0J3MgdGltZSB0byBjb25zaWRlciB3aGV0aGVyIGEgbmV3IGlu
dGVyZmFjZQ0KaXMgcmVxdWlyZWQgdG8gY29tbXVuaWNhdGUgc3VjaCBjb25zdHJhaW50IHRvIHVz
ZXJzcGFjZS4NCg0KVGhlIHJlYXNvbiB3aHkgSSBrZWVwIGRpc2N1c3NpbmcgaXQgaXMgdGhhdCBJ
TUhPIGFjaGlldmluZyBuZWdsaWdpYmxlDQpzdG9wIHRpbWUgaXMgYSB2ZXJ5IGNoYWxsZW5naW5n
IHRhc2sgZm9yIG1hbnkgYWNjZWxlcmF0b3JzLiBlLmcuIElEWEQNCmNhbiBiZSBzdG9wcGVkIG9u
bHkgYWZ0ZXIgY29tcGxldGluZyBhbGwgdGhlIHBlbmRpbmcgcmVxdWVzdHMuIFdoaWxlDQppdCBh
bGxvd3Mgc29mdHdhcmUgdG8gY29uZmlndXJlIHRoZSBtYXggcGVuZGluZyB3b3JrIHNpemUgKGFu
ZCBhDQpyZWFzb25hYmxlIHNldHRpbmcgY291bGQgbWVldCBib3RoIG1pZ3JhdGlvbiBTTEEgYW5k
IHBlcmZvcm1hbmNlDQpTTEEpIHRoZSB3b3JzdC1jYXNlIGRyYWluaW5nIGxhdGVuY3kgY291bGQg
YmUgaW4gMTAncyBtaWxsaXNlY29uZHMgd2hpY2gNCmNhbm5vdCBiZSBpZ25vcmVkIGJ5IHRoZSBW
TU0uDQoNCk9yIGRvIHlvdSB0aGluayBpdCdzIHN0aWxsIGJldHRlciBsZWZ0IHRvIENTUCB3b3Jr
aW5nIHdpdGggdGhlIGRldmljZSB2ZW5kb3INCmV2ZW4gaW4gdGhpcyBjYXNlLCBnaXZlbiB0aGUg
d29yc3QtY2FzZSBsYXRlbmN5IGNvdWxkIGJlIGFmZmVjdGVkIGJ5DQptYW55IGZhY3RvcnMgaGVu
Y2Ugbm90IHNvbWV0aGluZyB3aGljaCBhIGtlcm5lbCBkcml2ZXIgY2FuIGFjY3VyYXRlbHkNCmVz
dGltYXRlPw0KDQpUaGFua3MNCktldmluDQoNCg==
