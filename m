Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BED663790
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 03:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjAJC5o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 21:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjAJC5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 21:57:43 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643AE2DF4
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 18:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673319462; x=1704855462;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jwu8RS38LT6UMade8EYSXwTy+ipCND4BT6SxdZ6OtPk=;
  b=GlOEjeW+SiFZZk4hTTQbkm/xmPMs7iOnGGMW/WrbQg1zkCH9CmfM+OFM
   OrIB2W662f387+W6C0Ka660d3sV3tps1cTtjgzzZFGDlj5wb27GCt8xXo
   LRwafezJqAVdrTD7MFR8rZrAXhsV+mwNDDOuHX20VbbnkEFC25kLdzRHK
   ZC3JH5eYNrdWroji1dUy8hB78RjgSSZ+OCQizhC/D017ce6M08/N2Dq68
   yc84lDcgltSyz8eOES5bVjsS5EAHgDD8rfSF9vnzKn6Vlxrc81TwwDMGR
   7kbGzmDSnV0+9X4+nD0tusjWF7k4ILOC/75ZXwMLUealjyvM82P7mDrJ4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="302743818"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="302743818"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 18:57:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="634442507"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="634442507"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 09 Jan 2023 18:57:40 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 18:57:39 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 18:57:39 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 18:57:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUjhLQN2xqf77QVgREtswoxJTBtLXRQZy/HGx31Y6+wnVQSzszFVm2Sox9LZKU3CmL/xk67H7Dnq/xhBIdACZOhgTwl/byyjNNCrlG4z8BxOBD5DFQqSjcGzfIGda/ViNk1qKBy6Y+3AG7fX99MFaDwVgPQD596nt4BlkzvRoey+MimUzvripETsaTst2EeujlnfVnVLgFFpLGkrqSlcXgAkoI1N65uzXn4W26BSFBopf6pn0Go58s6LB3KgSzIDtJKWNVvFH4I/XF5XyW2/zJHZhgmTfqxnyCljCPi17XNXhpYyctWj/ufSe4OcV1ZOSMsmgPzZW79zyLmROMZ2iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jwu8RS38LT6UMade8EYSXwTy+ipCND4BT6SxdZ6OtPk=;
 b=VkOXxQrKMwIQSNPgk4rQA1Xx+hIIAvfqkGO+LsOPJ9ktLsjVUwI9SAn8U3KO5xyDGZIi0oFSKPwHrUhqwRAzfEBYYz8JhWpKgaEnQk3vbq1pC2hn5A1y+R0/J+YXTyIrJkDnmRO8ftR5A0hU0JwgRehs6fJPsLZyafSnNZg4DmkG8YVxtyfS+Er+8HtWjtaNvw5HpWYr4mRbgWOnb7OatrZ5sYY6tPmwywwTQQh+tRcHbW+FccLG9tF0glFnF5gwFvRaNyp9E1Oxc0QPn/A/okrCjTmeMXMxEYlXTkiZZtgqzCfITUhBCqudFZ/ouxRnG2tHKEE4pRARPtbqtQkBaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 02:57:37 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%7]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 02:57:37 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [RFC 11/12] vfio: Add ioctls for device cdev iommufd
Thread-Topic: [RFC 11/12] vfio: Add ioctls for device cdev iommufd
Thread-Index: AQHZE4aW3uMKS3SxukmckGIex8c1c66VzEJwgACBhICAAMkrMA==
Date:   Tue, 10 Jan 2023 02:57:37 +0000
Message-ID: <BN9PR11MB527695ABCDD846C00B04AEBE8CFF9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-12-yi.l.liu@intel.com>
 <BN9PR11MB5276E47BF63C4553DD4C0F4C8CFE9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aca8f7dc-4360-9ee7-09ca-b534bbb63d35@intel.com>
In-Reply-To: <aca8f7dc-4360-9ee7-09ca-b534bbb63d35@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH0PR11MB5332:EE_
x-ms-office365-filtering-correlation-id: dad99fd7-c240-4f14-5b66-08daf2b66e81
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +x6nTh/qZ1bFb+PoSz9DavP+zuMeHuexzGE5CUgqUIaR9wTfAJ47PzXxhK9E19a7w7cFK3Zdh9bULj3dfHFChcFzSQCCxtMF3MCfbRHJ83y4jnfLCLAzCdTUmlWzAh9p+od7otHfNJuPz0RlRTp3p+iPgkAb//aOtpNu7iAEd0GinIQdO6dxP4+5olXIWF8SKjYRc+hjODJJr/HXR+hfw0hbVwWvPuvwjRsk8dSXAnLnnAC+W6zN8I/CDa9+W8MWyxPscfOuup437woL2i/H0ByqHtRSamDg08Erby9T1bvGGtpJW+icJaZs3jcGO3hgwIRz3oQZDEvmgFtLpXZBgnAauVKWPIyihy8aHSwxRSVBzYodAkovDPQmBEm7fUvT7NddJD7NpY/Qt7wSiu1foY3IRHg3xzfTzdt/JVpC2Ut9YE5jmu19JiXcnfKJQORYVVf/s+4a2EdILlMvbZH/TnOriU/Bm3rRIKABBrJCNMy5Tfpc3/wpmrETECMBU6YHfXjfsBjTRD9Wpx/jKS7v9ltzvLkk2O7UqER68lBXfVRkuVT6kL0ygr4sRqF5B+dpSYwqLmjNf4D8kMMUaNA1N/qdUoShN2x3Nrk0PBmblqOt60PumKcXjuIcYJeB96jtTna1982Q0WwFZrHmQ9Zo6YqA3cVjQOw+at/VmCEXjP1hXE/xXQFTwxPhSKE0W++m
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(39860400002)(346002)(396003)(451199015)(8676002)(7416002)(33656002)(316002)(71200400001)(5660300002)(9686003)(26005)(7696005)(478600001)(186003)(41300700001)(66946007)(76116006)(4326008)(110136005)(66556008)(66476007)(64756008)(54906003)(66446008)(8936002)(83380400001)(38070700005)(86362001)(55016003)(52536014)(6506007)(122000001)(82960400001)(38100700002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L09nVkUrRVJXcFgyQnZEbDBXRkduNzFnSWsycTBiR2FKMFNWL09pWnE1Zk9X?=
 =?utf-8?B?dmUxbjF5ckhZUGVpQ3c1ZnFEYThrTWdyd0pRLzMrYUhyalBITk8xWGF6UWx3?=
 =?utf-8?B?VTR2L0lTb1ZITjc1Q0xuOUJ6WHJVR00zZUNsRnpublNsVE0rMElaZ3hXbXg1?=
 =?utf-8?B?M0k3SitKZm0xaWxrTjA1bWpPYnpFSFhRQ2ZqeWtreUJLMktoaFR3eUNrVUth?=
 =?utf-8?B?UEQ5TUVZczZRam5YbEN0YW9pQzh0bTRXamd6SnE1eU9YRlJJWUNTa1JQbkln?=
 =?utf-8?B?Z3RVdHFiSWFTR3BzU0JLbkFjWFFSZzFGRFdiZ2FqQ0JDR0lEMzluUFJCT1BY?=
 =?utf-8?B?MUZoK0lFMkl2eGpWeDBIakNSWXhWMElSeW1xQ2ZTV2owemVPbVpacDBBWFFQ?=
 =?utf-8?B?Si9wWHhyMzlyNW1mcDg0WVJ2bDJadmxhR3UyMHhaeUNRZ09CZ0RUOFlMR2Yw?=
 =?utf-8?B?VXdSL0Z0T3BwVjJNYUZHZm56R1IxWmo2ZStWRjBnbC9nUkJYNmIyU0llNzk0?=
 =?utf-8?B?ZmxiRHpmOWNXSk5xdVF4bUlLM0p2S3JOb050aWxtR3RJWXBJMUlLUm9hTFhs?=
 =?utf-8?B?N0YyODExYnNUWkhBOFpEWlh2eUtKR0dxdkg2K0F6bWR5YnlUKzVnWkVUV3FL?=
 =?utf-8?B?VFVsbGM5QjFoVFA3c1hoRmMrZVA4bCt5d0NCemVmejRwZ2hQYnNhNzNKKzdr?=
 =?utf-8?B?c3JIRDVuc0VOd01ISTZIMFBoWkFuTXhkb01Eejc2Uno0cTZodHZLNFN1Q28z?=
 =?utf-8?B?MFZzVmZXWlZKSVdJbnNacXAyc2ZzaWg2WWdKZkZzSkdVVncxOE00ZlZhamRY?=
 =?utf-8?B?Q1gvTVp3cTVhU05PTTFHMkd6WmpXR1V4OHB6QXljWitLNFhkSUlGVkxCZHRw?=
 =?utf-8?B?SVNtakVUaEdyZklwNlNiSnFoRURxeWZtQU5Xd0Y0amhjUDZVTDlIN3VjK3VW?=
 =?utf-8?B?TmZGajZ6Tnczc2wxNzVEMlhBcDVpeE1jWkhRM2J2ZGxnR2hYN1lrS1UrbEFs?=
 =?utf-8?B?cEl6REl2SUdiUmZSdDdIcFpqenNkaWV2cFVyYTRxNW9oQXB6Q3hkdXkyekd3?=
 =?utf-8?B?WkdyTFlXdmV6WW1GVnlUR1VXUUxjZzJGaHFWT2NjZStsNDNNRXY4M05KWWtO?=
 =?utf-8?B?YXo0eTVkeGgrVXlSWDhYR2VhZjNPbkRPZkR6U0JNUGRGenA5VjB1OWN2NFpW?=
 =?utf-8?B?S3duc2RlUFQwdHRycDlnanMrZkMrdld0a0dnMFZlQlVyTjdtYlJ2TWljTmcx?=
 =?utf-8?B?VThYTHV1SWV6aHg2Z1kzM2xFRldhRGFIRHB4R2wxVm51SUhtZWdGd211NGVV?=
 =?utf-8?B?RXVoSFF2QmFtSFY1R05DRmQrZStSVDVtZTMrd2VXdzloeWNac2lycWM2dGcy?=
 =?utf-8?B?Zzcvck5vM1U4ZjJlcGFYelc5R01RVUlaUGRmMDdRVHJTRExQUERGWGFHbFRJ?=
 =?utf-8?B?MkovQUtSdzkzVG9GcW5ZZHpKYlBTcUpBWVQ1LzhoOFlHZmV4c3hpY3d3cmN3?=
 =?utf-8?B?Yi9zOVhZanEyZXlTbU4wemhyLzZ0SHJjRkNKZmsxOFpqWGt1YXB4VCt3czI0?=
 =?utf-8?B?UHM0ZHE5UTJ5R29oYnI3bC9veTVSMlVlUy9MODlBeDBkOUhjdmJVall5Y1pm?=
 =?utf-8?B?U3BKMzUxN0xqa3cxcFVxSFlXVUUwYlFncEpUS3pBeExLWHlFalAzVEhObGli?=
 =?utf-8?B?YU9DUDJieE03RUJmdHVPRFpmejl0d2tMZ251Q0xVWHJyMmIzUVRmNkQwOGI1?=
 =?utf-8?B?dTh1ZGJMZ21RMEhBZ3FNUmdINzFhSGQvL3NQV2FPbEZqZUFKMEJhZWZ3OUpS?=
 =?utf-8?B?b1pKSFZtcDQwaE9JY3pOci9oM05iamMreFZGVUx2RURqeENQUXNvbFpLeXBB?=
 =?utf-8?B?dGl6NzdiNVJRSThZY254Qi95Tk5pWjU4c0ZlbnNNTFlLTVFIemhDWW9xZVpC?=
 =?utf-8?B?STdsWmY2ZlpoNE1tdGhGSThGSFJhWVdOS2VrZ3Q4TWpQbGg3aHAyOGZydktt?=
 =?utf-8?B?dytYaWg2bUxhekZPZnprRUxkUm1kVE1ZcXcwWVErY0pVbmo3QWNwRUg1WTBk?=
 =?utf-8?B?RHdMbm9ubUd4dVB2YlpVRDlXOWtHaWQwaHVtV0JTUlhkL3gybktSRGQxeUhY?=
 =?utf-8?Q?HfNPMuE+n51Nq4wld5+GJ6sc6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dad99fd7-c240-4f14-5b66-08daf2b66e81
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 02:57:37.7819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YW3ukC+L7yQnCbmQbk46SS6THjfTwhkiIKf5KBEUe1lqoH7w0JJQWBuRhB8XONf0QLOZFSKFzsVI4d3zp/tHFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5332
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogTW9uZGF5LCBK
YW51YXJ5IDksIDIwMjMgMTA6NTUgUE0NCj4gDQo+ID4+ICsJbXV0ZXhfbG9jaygmZGV2aWNlLT5k
ZXZfc2V0LT5sb2NrKTsNCj4gPj4gKwlwdF9pZCA9IGF0dGFjaC5wdF9pZDsNCj4gPj4gKwlyZXQg
PSB2ZmlvX2lvbW11ZmRfYXR0YWNoKGRldmljZSwNCj4gPj4gKwkJCQkgIHB0X2lkICE9IElPTU1V
RkRfSU5WQUxJRF9JRCA/ICZwdF9pZCA6DQo+ID4+IE5VTEwpOw0KPiA+PiArCWlmIChyZXQpDQo+
ID4+ICsJCWdvdG8gb3V0X3VubG9jazsNCj4gPj4gKw0KPiA+PiArCWlmIChwdF9pZCAhPSBJT01N
VUZEX0lOVkFMSURfSUQpIHsNCj4gPg0KPiA+IGl0J3MgY2xlYXJlciB0byB1c2UgYW4gJ2F0dGFj
aCcgbG9jYWwgdmFyaWFibGUNCj4gDQo+IG5vdCBxdWl0IGdldC4gV2UgYWxyZWFkeSBoYXZlICdh
dHRhY2gnIGluIGFib3ZlIGxpbmVzLjotKQ0KDQpQcm9iYWJseSBhIGRpZmZlcmVudCBuYW1lLiBJ
IGp1c3QgbWVhbnQgYSB2YXJpYWJsZSB3aGljaCBpcw0KbW9yZSBkZXNjcmlwdGl2ZSB0aGFuIGFi
b3ZlIGNvbmRpdGlvbiBjaGVjayAoYW5kIGR1cGxpY2F0ZWQNCmluIHR3byBwbGFjZXMpDQoNCj4g
DQo+ID4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvaW9tbXVmZC5oDQo+IGIvaW5j
bHVkZS91YXBpL2xpbnV4L2lvbW11ZmQuaA0KPiA+PiBpbmRleCA5OGViYmE4MGNmYTEuLjg3Njgw
Mjc0YzAxYiAxMDA2NDQNCj4gPj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L2lvbW11ZmQuaA0K
PiA+PiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvaW9tbXVmZC5oDQo+ID4+IEBAIC05LDYgKzks
OCBAQA0KPiA+Pg0KPiA+PiAgICNkZWZpbmUgSU9NTVVGRF9UWVBFICgnOycpDQo+ID4+DQo+ID4+
ICsjZGVmaW5lIElPTU1VRkRfSU5WQUxJRF9JRCAwICAvKiB2YWxpZCBJRCBzdGFydHMgZnJvbSAx
ICovDQo+ID4NCj4gPiBDYW4geW91IHBvaW50IG91dCB3aGVyZSB2YWxpZCBJRHMgYXJlIGd1YXJh
bnRlZWQgdG8gc3RhcnQNCj4gPiBmcm9tIDE/DQo+ID4NCj4gPiBBY2NvcmRpbmcgdG8gX2lvbW11
ZmRfb2JqZWN0X2FsbG9jKCkgaXQgdXNlcyB4YV9saW1pdF8zMmIgYXMNCj4gPiBsaW1pdCB3aGlj
aCBpbmNsdWRlcyAnMCcgYXMgdGhlIGxvd2VzdCBJRA0KPiANCj4geGFfaW5pdF9mbGFncygmaWN0
eC0+b2JqZWN0cywgWEFfRkxBR1NfQUxMT0MxIHwgWEFfRkxBR1NfQUNDT1VOVCk7DQo+IA0KPiB5
ZXMsIGJ1dCB0aGUgeGFycmF5IGluaXQgdXNlcyBYQV9GTEFHU19BTExPQzEsIGFuZCBpdCBtZWFu
cyB0byBhbGxvY2F0ZQ0KPiBJRCBmcm9tIDEuDQo+IA0KPiAvKiBBTExPQyBpcyBmb3IgYSBub3Jt
YWwgMC1iYXNlZCBhbGxvYy4gIEFMTE9DMSBpcyBmb3IgYW4gMS1iYXNlZCBhbGxvYyAqLw0KDQpZ
b3UgYXJlIHJpZ2h0LiBJIG92ZXJsb29rZWQgdGhhdCBmbGFnLg0KDQo=
