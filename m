Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BBB54EFE5
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 05:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379634AbiFQD7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 23:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379582AbiFQD7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 23:59:07 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458946668D
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 20:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655438346; x=1686974346;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d+1pzyqjdAUbxtysDHZo08AObCWXrHmSMEpCPQ+btMo=;
  b=ALpFjVdzs1kXvBO4RqRJqNSdILZtfQ0uOJ8l9xP6UjvNgXTp4upu1okH
   Zv+EupuZvua/ciOfe3gtnmQZrl4r4HmWvgc7w5WG7pVY6Mfip6CA+qjvT
   zOLD2rHDFCvi6IW/WIIbW1UthA/UqxSXJI0J+Huo+KfnAAcnah1cWKotP
   pIAVj06bL5vIYuhihmVtqV/oFY054AGh1F/oKE8OZfSjpO46WSXMbrY3T
   oEqb9iGikZbjoeFiOvXMSDuspr1trqWUCiIWyCLS3jvGj8Dwx0g42QuTJ
   2ZnKEBoobNzjcGu7R+Xj9MfgYR0ClB3ActQB60wcLJcs4DJb9Fd3Amooz
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="341067254"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="341067254"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 20:58:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="613408560"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga008.jf.intel.com with ESMTP; 16 Jun 2022 20:58:55 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 16 Jun 2022 20:58:55 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 16 Jun 2022 20:58:55 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 16 Jun 2022 20:58:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KeSvfpgpf08LqnumTZ6ZqjBpEyYHtD/qBfiR/lhcsVERa17M5X1B9OsSH30mIG41NFmM+Oi/wY87l97H+QE7kJP+GswLgoqrthzyqyMw6mxOy1SvdQlEUbg24qgVOb0giruL7Sj755wt6o2EE+9eHm2co41/MremsvAxbjmzhGeBbfPv48YBZ4yVgsoyEznj7zzpjDKDqipjLOZFE+OFBKHsrMcN3zl5GxiO1pD4mrqT+/Pcbl7Bx9khioy0s4FXw9AGc2KGngTQs55xoAxPQD/ayet6XVIog0jc1Sbu9+E5Y6mXL+vj21cRLiDwgx9ymwk4k7vy9TrDP8siQJDkbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d+1pzyqjdAUbxtysDHZo08AObCWXrHmSMEpCPQ+btMo=;
 b=iipgYgOesk2d7FCOcytHyBprwnDHe8qy5nfvs3ZASgPBhI2CBTUqevRlW2+Ad5UO8Z6PC6stim7yApck6UgbrdzGJtyGGo6OPBXl7Gw8R/emg/+yiqdDILhdemF+kAXB0Vb9EwEie5PIBagXldjkgVX7DBT6qbUhuUkZfh8/SQ0zXiFpes9snCgJ+hR6zH26+FzSFtIxqKVxVfWs1zDiEwljhxGA+b7mR/ko7sgfnNxCzzO9sBMr2ceHnV5j2yn6hpTI2QIj9leXw1njyEPTNu+lmGLGCdYRr08OD2FqGySJEzSPoDB09XHjkmbo5xilcJDXgJhAE2kUDqiCWboVRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM5PR11MB1387.namprd11.prod.outlook.com (2603:10b6:3:7::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.16; Fri, 17 Jun 2022 03:58:53 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 03:58:53 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
CC:     "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "liulongfang@huawei.com" <liulongfang@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>
Subject: RE: [PATCH vfio 2/2] vfio: Split migration ops from main device ops
Thread-Topic: [PATCH vfio 2/2] vfio: Split migration ops from main device ops
Thread-Index: AQHYeYOPTfntv5YgX0aKO1lwAOJE4K1IAOQggAT2HYCABS3PAIAAkiIAgABMO8A=
Date:   Fri, 17 Jun 2022 03:58:52 +0000
Message-ID: <BN9PR11MB5276660F04EEF1762BFDC2288CAF9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220606085619.7757-1-yishaih@nvidia.com>
        <20220606085619.7757-3-yishaih@nvidia.com>
        <BN9PR11MB5276F5548A4448B506A8F66A8CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
        <2c917ec1-6d4f-50a4-a391-8029c3a3228b@nvidia.com>
        <5d54c7dc-0c80-5125-9336-c672e0f29cd1@nvidia.com>
 <20220616170118.497620ba.alex.williamson@redhat.com>
In-Reply-To: <20220616170118.497620ba.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae42a659-9777-4f67-56e0-08da5015b18c
x-ms-traffictypediagnostic: DM5PR11MB1387:EE_
x-microsoft-antispam-prvs: <DM5PR11MB138762CE03ABC876DFECD9668CAF9@DM5PR11MB1387.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +kWWO3SfOK3LdU0Nf9Mnphbf13kGQceDv/a7KjKgC1mtu2zL7Y6nW97o4sLydMgAbsWz1Z8T42F/Pm3AVFteEjdufp2H6enIx0zGScqS/oyyrKLoTtGDocJnZ4JiGXGLOjs7qyWMATT/dvRlRMxukIx14KbSszSh3oROBrnyLG4vgYDvIJXmXIAC8EcyiMU0b9+yVQo3KVvgmMTIGAX6F/WxXkZmtet6173au/yMq3lxVdNG46kHZQGhByfVHkTNkpva5koOyhLEDldAzHit6zpuQm2p8y800yp+RYQWUqU+ZlpwYc2NrF1C5qK+x1qTocC5x+SjDxXGfdIqgt/s5R47nE/vQDa6g9z62VVCK35FUZTpIBsMQhw+XmVgpzIYfWVx9V9G1hXjfH1PAv9NQtsI1rjHugK2j0r2Ga8MwzfNoGGFRLCYMgwYQRrJTK4as6ixh7yPzoz/FBIiFCHwK4j2Z4Mpx1g+Kbsciy3tywA9VnzdutD56TrMikZZ9XURLoDAOpkETqeGcIvj9ebOTNU8ttPRziaEtNR763ILwSeNkcyBoDNDTYJEQPBJJPYtf8CxtFIYGOfgp6iCmutFug/NkLfOmreFnsDPq50O3rxFWYjeUJwQWsERERbVbn11jBeHbVmVq2jP3CJOklc2fDEvr2ua/+Mrs79g/vXw1boTMeEHZVg3rXENNV9An+YUQjAMmI05/LxssOWKSW+scg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(122000001)(64756008)(4326008)(4744005)(6506007)(82960400001)(8676002)(26005)(33656002)(55016003)(86362001)(66446008)(66946007)(76116006)(2906002)(52536014)(8936002)(66556008)(498600001)(71200400001)(316002)(110136005)(5660300002)(38100700002)(7696005)(186003)(66476007)(9686003)(38070700005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c2FHRFhaRDhtRHZXSUx0bzQ2MmlHRVZZTnYyNmZ6cTV1c1pVU3BhUnFSQ1k0?=
 =?utf-8?B?R2J3d1NLaDVlbnVYTXNOMStMOHEzcUovTFZlS1BYcVBMb3ovWWxVbGp0c3gx?=
 =?utf-8?B?Z3FuWU1rcHh3c0xQaytnT00vdi9IdnF4bXJiekt5VkdEamEreGhScWFDNlAz?=
 =?utf-8?B?RVJpMDVySlA2cU1UL2MwQmhSSHVORk53WjhLRUdISzBpWUpmS0J6cXdWbkVo?=
 =?utf-8?B?akxWU00xaU43Sy9rU0lFRGVJRFpzWG96cVhCa3FZK3NMNDRUTDBWS014R3lm?=
 =?utf-8?B?UWd2RkJBK3dWZ3JiNWlna1laNXk5clFlSktTVThISEhPS1RBemR2RGxTK2t0?=
 =?utf-8?B?cEFWS3NwdWN6QVNXbStMSTZRNGZVYlhPUjcxRjdZY3I1OVhXNDFWV0h1bkZt?=
 =?utf-8?B?SWdZRWpnenR2NXcvNWpzSTdVL01PTlRpREMrOEJIQjRyY0E1bmVIdEhjcjVE?=
 =?utf-8?B?KzlHaHd3eThMVElzVG1SeS85WWJBVC9zM2N6c3hhVmdLTEtpemJWKzlXclNW?=
 =?utf-8?B?NUNyRXBGM0QvcjBNM2tVdmczdmRhV2VaN2NiMDB1dTRYSXBsZU1UWkY3dkhY?=
 =?utf-8?B?WU1YQXpJdnh4cUhlMjFKQ1pCSEdTdzdTQ05kR1VsbnkydkVlVHZPY1FGSWhZ?=
 =?utf-8?B?VEJsMGtMdWhPRk9xUVg4N0Q1L1k4YmxDM2FlUWx1TjBBN001S2w5aU9YaW0v?=
 =?utf-8?B?S0x0cGY5VDNlTTRXVUFqbkExUzJVYzhyUnM2dTRhWXArMHRXckVwSFd5MWMr?=
 =?utf-8?B?SXlVSldsOGhhREJxZEx5Z2MrY2VkblhldlRuOGFGdGt0MUcxVmx3VmRoSUhK?=
 =?utf-8?B?bmtqK3hGT01rWmpWQTNONFgyaCtIRmZUU29yMjRqRzlJMTVTMUVQWDhLTmx0?=
 =?utf-8?B?WjRuSTZMYjVNRnFoUU5jV3VuRnhxNVhsWUJINmFudFh1dGUxMXNqSHJUQURm?=
 =?utf-8?B?aHN0cytwU0Urc0tNSzZ5RnVsbWhPUG1nT2p4Z1VkUGdyRGQyVUhkS3BPMVVK?=
 =?utf-8?B?bzhxNzd3SHZ0K1ZLQy9vMVFWMzl2TEZOL2NJekd4QkdBTmNDU2ZFZndlRkFK?=
 =?utf-8?B?VnY4am1rMDZYRXJRUU9BamVRRk5YVzU3TFcwQXIyMGFTZmhCcG9uMlVtaVlZ?=
 =?utf-8?B?L1FuVFZqbFM5UERJdFN3TXVMNURCWmVWZEY5Vzcvbm9GTWFTd2FvVG5qbnZq?=
 =?utf-8?B?MnIwSTlRTWwxZTBsV0x4eHI2S00rOUVuelZ3V3V5WkdKLzVzVEdSUlpSbHNN?=
 =?utf-8?B?VnRaaWFYL1JoWTd2bncyK0pPTGFLSWlTY0twVDhETkt2eWE3UnROcjNkcGpW?=
 =?utf-8?B?YnMzRmtjVjdXN2FtaWRxM3lOQUFQWnpMVTRmR0pyUE9SYWx0R1M4T0Rnc2d5?=
 =?utf-8?B?bVlCZzlBdElOb0JMc2FCWjc5UStwRTFtZDlFV3luYzMrU0pkcEFyTVBsZGRm?=
 =?utf-8?B?RndSQnZibXVReCtuSlhLS2xZQUIyQ3U5aHMwaFg0STRET2hNQ0c3L1UxaGUr?=
 =?utf-8?B?bCtLSXpKUllINjMxZTFFUmhnSjlBUlRzNE9SelN2UHFHM0R0SjRDTVIwS3Ja?=
 =?utf-8?B?ZW5Lek9KSmIyNnAxWEk0c1VhLzVDYWhXTXRmT2k1WGdOSmJyU3NhZ1dZQkhl?=
 =?utf-8?B?b0VUaHJkUDBPZ0lxNEhmYkJkbEpBK0pqeXlIbXJORzZyck0vZzVFMW9EZ0hE?=
 =?utf-8?B?MEI3QmVIbHMrQU5Ta0xRc3E1MTlhaXIwTkJRczM1T0t3SHR0VGt3QzJpRkFk?=
 =?utf-8?B?Slk2Y25aNVRNY3FWWis0cXRwaXowVk91QWRTSEd3M04rODErNlpLU2F5WS9F?=
 =?utf-8?B?UHZKNUFsemdoaDc4K0picWVYeWExajluS05rRDVCMy9pTDZuYXRqcmpRd1Zj?=
 =?utf-8?B?TmZiSUF4eno4Q0pmd1BZRVl5cFRURURicFYvNUd0WTlFNkZVMTdKT2F0aVU4?=
 =?utf-8?B?ZEhCUi9VckJ5aEd1bmJ3U2xRRVpzR2sybkFxdzlqRDRiYjJ1RGdLdXV2dCtB?=
 =?utf-8?B?eWQyVXcxd0hMYkdUZVNOdys0RFBaZlA5dmNxOFZ3N250S2VZdk9rT0RvSjJq?=
 =?utf-8?B?YnJka2o1TWJlN3BFYWhRK0huamdNMFR2ckRINFBWV0RNcy9vVmszT3A5U21C?=
 =?utf-8?B?V2l5QkFUWk9VRmh4YnQ1ODZyMFoxdTNZenN5VzVuQ1VxVHRPZW9NdlJoSmx1?=
 =?utf-8?B?ZDdXMjBObmpTQXRCaXp1Q21IbHVlcXlPWFQra09tUVBDZ01rc0lWeHlDUGRW?=
 =?utf-8?B?c2NuZTBHTk00enExZ2M3c3RwYUVQZC9UOHNmL1hISFVtSkNXc1JPTEJCT2Zh?=
 =?utf-8?B?V1JaUFJWM2NPb3NvSVlYWk14QlNvajhEanpoWnZPMk5FeHBNcGNWZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae42a659-9777-4f67-56e0-08da5015b18c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2022 03:58:52.9177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: atzr1mZNxGr9z3MWw1F2g9xDyu4hqzUOKBqQyimrcluLCgt5h/HPxAmZtETAl7m7qmbzXCzdGka8WE2va6knEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1387
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBGcmlkYXksIEp1bmUgMTcsIDIwMjIgNzowMSBBTQ0KPiANCj4gVGhlIHdob2xlIG1pZ19v
cHMgaGFuZGxpbmcgc2VlbXMgcmF0aGVyIGFkLWhvYyB0byBtZS4gIFdoYXQgdGVsbHMgYQ0KPiBk
ZXZlbG9wZXIgd2hlbiBtaWdfb3BzIGNhbiBiZSBzZXQ/ICBDYW4gdGhleSBiZSB1bnNldD8gIERv
ZXMgdGhpcw0KPiBlbmFibGUgYSBkZXZpY2UgZmVhdHVyZSBjYWxsb3V0IHRvIGR5bmFtaWNhbGx5
IGVuYWJsZSBtaWdyYXRpb24/ICBXaHkgZG8NCj4gd2UgaW5pdCB0aGUgZGV2aWNlIHdpdGggdmZp
b19kZXZpY2Vfb3BzLCBidXQgdGhlbiBvcGVuIGNvZGUgcGVyIGRyaXZlcg0KPiBzZXR0aW5nIHZm
aW9fbWlncmF0aW9uX29wcz8NCj4gDQoNCkEgc2ltcGxlciBmaXggY291bGQgYmUgdHJlYXRpbmcg
ZGV2aWNlLT5taWdyYXRpb25fZmxhZ3M9PTAgYXMgaW5kaWNhdG9yDQpvZiBubyBzdXBwb3J0IG9m
IG1pZ3JhdGlvbi4gdy9vIGFkZGl0aW9uYWwgZmxhZ3Mgb25seSBSVU5OSU5HIGFuZA0KRVJST1Ig
c3RhdGVzIGFyZSBzdXBwb3J0ZWQgd2hpY2ggY2Fubm90IHN1cHBvcnQgbWlncmF0aW9uLiBGYWls
aW5nDQp0aGUgcmVsYXRlZCBkZXZpY2UgZmVhdHVyZSBvcHMgaW4gc3VjaCBjYXNlIHNvdW5kcyBj
bGVhcmVyIHRvIG1lLiANCg==
