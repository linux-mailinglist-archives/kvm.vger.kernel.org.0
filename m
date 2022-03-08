Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819F94D112E
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 08:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344657AbiCHHmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 02:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237222AbiCHHmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 02:42:38 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1D939838;
        Mon,  7 Mar 2022 23:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646725302; x=1678261302;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nzmFco0w+B8rOvUyZZ1LlKU2GnxYjpUQa5qA0YxlTE8=;
  b=Rpn+P95z2LUVWDmKhItLgYpOd7zbccqMBttgE5BjcsVEBSGzIoOwBKGo
   /ZMuZQm/mEHmyrEBw5WUVz9JgudHQ0bmx3yZEyMvwLF7mWuQHYjceiaxB
   wqUv0EZeGiwBqipYrOTGg2/xEgznFWF2o/3qrvJP0IBwyhwLZWxDZPmoa
   Zk7VtmX3dftg+S/As7Y5kHcvqWX7NE7M3B9J4627zou/yrkw5HpnO5DcM
   lF0S0fI1O/cgtzaCCBkmd/MzNTOqP3eK3vA2q82neQ+Bb4LShT0akorSd
   Iz5OPxAgcrj4vnjkBD8RoSVLeVa4iLk391udnT2rqTv/5iRqvJjXrl9AU
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="234572097"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="234572097"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 23:41:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="632146610"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Mar 2022 23:41:42 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 23:41:41 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 23:41:41 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Mon, 7 Mar 2022 23:41:41 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Mon, 7 Mar 2022 23:41:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxWm9AOlpcAyoB6FTJ57VmltgocbAfcBYE3qa+3YzwCeW5yzR7j0FTmtAPRtI9mpyskwA01TzCzwBapqS7lezagDb00d0Ys5OqEV1Og2N+FdF7kyP7qIoay+/KcpWWD0GDenLO/ZPLiKVDykP8zstGlUfqUkvO+LFCWwh0Sek1Sm7/5LFg/WbbSx2git1zE2Jp9OoyS6dI+nkbFKxO2WYy8tW9R9gNThhmfR9YlFOAncBJOEKfnyVevL9vdypDWXVk5zjYKsGwhKtu27i3eFmlFz66opCrh2e/bPOLNTa6+SbQ4Ng6aurtYxcPX7y9BK+aLvpK9sIkaI5JECfZPjHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nzmFco0w+B8rOvUyZZ1LlKU2GnxYjpUQa5qA0YxlTE8=;
 b=XWXm2cRqv62653y8ngGulof4Y3k3Ta7C5hyTfM3Urf83RvIKkx8o8Gep9zgPqf3qUp3yRaSaxxHRvO1NkesLuFW7Mf57XX8+UR4IHvWDPHONd6Lq/1vP6BRaflblgGqx98vPNB03vZzKo4NGTYlxfGgKh02NZ9qRaHZkpSKMiWMxMRx4A9yTx1+2R7gmhknOlrCJCbBUVlMyZpSqE/0OP7KyxgSksdVO4ENKJmAqy0Gbsrx7PmX6b+dNDfG7IdjuCkNuU+HE+Ys1o5QLoDaJXGyHeVdWwdgGaciks9ESdZFC1afpTJ8v8qbKz0vFtZLrVl6ZUbwtJr8BRdKS08nHNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR1101MB2211.namprd11.prod.outlook.com (2603:10b6:405:51::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.26; Tue, 8 Mar
 2022 07:41:39 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%6]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 07:41:39 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "liulongfang@huawei.com" <liulongfang@huawei.com>,
        "prime.zeng@hisilicon.com" <prime.zeng@hisilicon.com>,
        "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
        "wangzhou1@hisilicon.com" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Topic: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Index: AQHYL1L4gR02rU84FUWBTBG9yRMgBqy1GrEQ
Date:   Tue, 8 Mar 2022 07:41:39 +0000
Message-ID: <BN9PR11MB527661103A2CFE13E4F3EC528C099@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-9-shameerali.kolothum.thodi@huawei.com>
In-Reply-To: <20220303230131.2103-9-shameerali.kolothum.thodi@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8dbcaf4-5c4b-47df-c7f7-08da00d714bb
x-ms-traffictypediagnostic: BN6PR1101MB2211:EE_
x-microsoft-antispam-prvs: <BN6PR1101MB22114D78A1B7F72B082886208C099@BN6PR1101MB2211.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pEVROEwvvd+Q5L2angRJAb7Hf5GxSxwVzBoiNJzAzL9XDsjgHYr1vUrRBmuKtUZGaqNvpuP7YbRnT5LN1fEdtF/rD+gjgH+o55vBPfW9qoDJqgHO7kVWqX8tpKwKWOPec0qTy3FCuFp8sZxqR4og2GHKRf5vP4Ci+4KW6kgglg8c6fwG+RPQu+d2RtqvMeRgGzz1gmOSfTNCMmRT8xK0zuuPD9NTqAknHApJGBWJwLUxaTABTKeP+uFM56u2kYuYJ+ZfwI2SHIMX5Mm8U22sDKtDa6rnML8sAlcX62QsQ8YLg0W5IOgUXh137EvG0yH7ychiQ/md0k73AvIOHiO4/ZD5XgB/mMgS1KRMcoUlaKeQB3mnp3HPxJIqumsoGWIDrvmvlOwXrfT6NHJVnJWAo6r6nedmHMsP7MkQ/6qYre5+25HgcZTjjs5w5Uwb5EUeE2cXZp6AXPNIkdj9AMLjW1U+bThFRf8ZckAsSq3qzRqkkLUdXja5jKhrkt+h/YJY150A3sBmF5zPTXDqmFMisaeCbTLhDHys/tDS5yLSIEfNzKHDAhTIEGpvSP5xX1PCVbIqDpOUFU3f8gzoBTOxr5Of0dmEiarmSlJHNXbReSF+3BRyoOqXqryCFDLrzTxxvFPaANiILI0RiderxGNRKBF0oGsQT9PCXUj5eOHadxn6tlnaM18+CDhRNh9D4bsOuohxLM5RwDfUuVT8BI9WKg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(6506007)(7696005)(66476007)(2906002)(9686003)(52536014)(33656002)(7416002)(8936002)(82960400001)(186003)(26005)(86362001)(83380400001)(55016003)(4326008)(64756008)(38070700005)(110136005)(38100700002)(8676002)(122000001)(66946007)(316002)(508600001)(76116006)(66446008)(54906003)(71200400001)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RDdsYWRPSXlvb2dDZS9FT2c4QmhaUGlVNE95ekUvL1YrTUZVTE1vdEg1eDlC?=
 =?utf-8?B?RFh0NWxEZWNwZ1Y3dnVucy9RVTVzYzZDTVp0cGM4WEd1bEExR200YXEzMlBY?=
 =?utf-8?B?a21wbUVSRzE4ZUQwQ04zK2pXMEVKSU9vb1pwRnVxdEowemZ1bWFQTFZqUEZj?=
 =?utf-8?B?R0NjdUgzanRHMTNVMmo4NDdLMzROS2VrMTB3Rm83b3k4ZWM2dWZLTTJQRkRW?=
 =?utf-8?B?SFlZb1R3VmE3a3BJNWxSVEQyUTdIRW5tRWFvbjZrdGdRMjZtVEpkQW54ZnZI?=
 =?utf-8?B?aGJOL3FwUVUxT3N2bHNnTXVVZ21hbmR1a2Q0Q29mN05QZVNuQlI2RGt4ZTVu?=
 =?utf-8?B?WGsweGxjL01SQXovM1lrYTNRbE9DV0taZlhDd0t5bDNtd2lIRkw3K2NleGpk?=
 =?utf-8?B?TStnVjBSckFtMUMrelJSNWNvRG5GaVZDVjdjR3lOWStoUEdIeGx2dXpLK0Nq?=
 =?utf-8?B?M2JMRnRsUHE4NjhNc2U0U3U5ZHdETGh2US8vaUVPTVBNVHZST2REZjJhWVo5?=
 =?utf-8?B?dGZtM1hJeE1RUitEK0xSei9HSjdVY2ZnbHpWUDN6T0NrdXEzakpMZ1NTbHdz?=
 =?utf-8?B?NGdBeG5oYUdsQlZZUWFlYlhnazdIZCtxQ2FvR1QrdndRSDVEd2xqYW5DNlc3?=
 =?utf-8?B?M0Z5bS9iV2NKMkxUcXhmV1hnaHplRnRYQy81d2l0a2hHZ2gvQU53bXJhUThq?=
 =?utf-8?B?K1BxbG1tSFJXOHcvOFNtSEEvdG56OXRXUjlEcitQc0k4WUliT0JhbDV6QXZQ?=
 =?utf-8?B?di9kZkNjR1lETnZGTTN0MkpkWmhjd0dTWlVRK0JINFBiQ2s2MndHdTVITGxT?=
 =?utf-8?B?VUlQQkFUZWI4MDJ6d3A0ODJOVXpHMUthQlZOdU9hSTZqanZWZzkvN1AzUnVs?=
 =?utf-8?B?UzFYUVQ0aSt2cnc0ZUNTaEdsQ3JmNDZEYnN5OCtJalhrRG9ycGVreUtXV3Vx?=
 =?utf-8?B?aWhlQW1JTGxsY0hvNkdiUzZaTVFPVTBUS0tITk9sSlpjZm5namNnRUYzcXJl?=
 =?utf-8?B?MjFzRWVCdjUxMXZzQzhPZGpzc2YxVjdiSThpR1lPSWxSQUFZZlE5b3hDN1ox?=
 =?utf-8?B?aVpaNGNqbHErdnVJdjBZb0cxTlFXYm1UTm55MkxXOVJqK2JwUlJCUDkyc0hD?=
 =?utf-8?B?bnBnWGVyUTZiVFdhclF6RFFnMmcrQ09YSVRwdkFiVE0rd2NrSHljUVhrOENI?=
 =?utf-8?B?ekRPMEsvdWFtZ09zTW1DOEVFSi85NjRNL1ExNzFwaElmczF6cXY5eXRTaXFy?=
 =?utf-8?B?TVMwTmh2TWJFbTJmWjRseTZCSUFlZ1IxeEJYbStVTjRMaTgvRFc4ZXE3cnhR?=
 =?utf-8?B?bForZ2h5NHBmamswajNRd0QwMlhoVlYwelR0c0JTQlBiN1gvUHNXZW1XeHpO?=
 =?utf-8?B?WFR0aXpWeHp6Um9iNndsZmF4bkhqczl5TFRhb2lzUThsS2RRV2EyN3lmWGJI?=
 =?utf-8?B?VE5vRUIwSmFrVVgrS08wK05tSWFJSElPSVl4dTVTTURJRUQ5emVoZWNjaHhQ?=
 =?utf-8?B?TS9IWnpEeTh6NG5WRDcvcitnR1FDbFRPUFFMMmxXblBQRXgxdm5xMFRNRHIr?=
 =?utf-8?B?ZnhEc08wN3c2dm9BSGViNFBNSnF5Zloxa3FyaDdFUnhjOXJicEFKZ2pJa1o5?=
 =?utf-8?B?SFVFakx6UmtmcDZ4SnpWRk9kMHIxbkd0Y2RkaWY1aXBHTVl1bTErbzhlclZ1?=
 =?utf-8?B?VmtUUXpTM0JHR2p5M2swaENsVkhvK0NsU0d2MWNjZHAvVzBnMTdGMTJvcSt4?=
 =?utf-8?B?RDg3emR2ZHZtQ3V0MTczQm44MWNCQ0lINld4VVFXdzFUeUR5aUhGSkZJYzFR?=
 =?utf-8?B?MW1pTFFuSEVScm5Fa3kyUXFybXZRSjB2VGRSMG93T29YcU96OGxkRFpzVFpt?=
 =?utf-8?B?QldVMGZNbEZXYm1zNStQb1FSdGV3ak9zVmVxNDBmWHpteFJ3cUk1azdKaXNS?=
 =?utf-8?B?WVBqMlVacDhXc1ZqMktRTEc5Sjc1RS8vMDZ5QVpPUVZMUzJGVGlibHpVOUlF?=
 =?utf-8?B?QURYQUJmU3ZaSUREUHRiajFxQzlqMEhER01BeURKR0ZPeW5rbHBQWVVoaXBK?=
 =?utf-8?B?K1NsN21Lak9FaENrbUkwZjJjZWhPdjZjWVNmWXRUSnk0TTNSYjhjZDVxb2FX?=
 =?utf-8?B?UzJBVm1tN1l2cGFUU1Q2eFJPV3VhZ3FhTE95SDdTZVVWN1pNWVIzL0piL083?=
 =?utf-8?Q?a9AU6BW31PPxjb1cTPYBBaQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8dbcaf4-5c4b-47df-c7f7-08da00d714bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 07:41:39.1697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wXec+i6CpDPw+MyHjqCY1XmzxN9MwrDMTcZrdF/Kkc8KnGY/H7apNq3tmG8ad8+oCpvKd30t2SacL8RLDxLhZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2211
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBTaGFtZWVyIEtvbG90aHVtIDxzaGFtZWVyYWxpLmtvbG90aHVtLnRob2RpQGh1YXdl
aS5jb20+DQo+IFNlbnQ6IEZyaWRheSwgTWFyY2ggNCwgMjAyMiA3OjAyIEFNDQo+ICsvKg0KPiAr
ICogRWFjaCBzdGF0ZSBSZWcgaXMgY2hlY2tlZCAxMDAgdGltZXMsDQo+ICsgKiB3aXRoIGEgZGVs
YXkgb2YgMTAwIG1pY3Jvc2Vjb25kcyBhZnRlciBlYWNoIGNoZWNrDQo+ICsgKi8NCj4gK3N0YXRp
YyB1MzIgYWNjX2NoZWNrX3JlZ19zdGF0ZShzdHJ1Y3QgaGlzaV9xbSAqcW0sIHUzMiByZWdzKQ0K
DQpxbV9jaGVja19yZWdfc3RhdGUoKSBnaXZlbiB0aGUgMXN0IGFyZ3VtZW50IGlzIHFtDQoNCj4g
Ky8qIENoZWNrIHRoZSBQRidzIFJBUyBzdGF0ZSBhbmQgRnVuY3Rpb24gSU5UIHN0YXRlICovDQo+
ICtzdGF0aWMgaW50IHFtX2NoZWNrX2ludF9zdGF0ZShzdHJ1Y3QgaGlzaV9hY2NfdmZfY29yZV9k
ZXZpY2UgKmhpc2lfYWNjX3ZkZXYpDQoNCnRoZW4gdGhpcyBzaG91bGQgYmUgYWNjX2NoZWNrX2lu
dF9zdGF0ZSgpIGdpdmVuIHRoZSBpbnB1dCBpcyBhbiBhY2MgZGV2aWNlPw0KDQphbnl3YXkgcGxl
YXNlIGhhdmUgYSBjb25zaXN0ZW50IG5hbWluZyBjb252ZW50aW9uIGhlcmUuDQoNCj4gK3N0YXRp
YyBpbnQgcW1fcmVhZF9yZWcoc3RydWN0IGhpc2lfcW0gKnFtLCB1MzIgcmVnX2FkZHIsDQo+ICsJ
CSAgICAgICB1MzIgKmRhdGEsIHU4IG51bXMpDQoNCnFtX3JlYWRfcmVncygpIHRvIHJlZmxlY3Qg
dGhhdCBtdWx0aXBsZSByZWdpc3RlcnMgYXJlIHByb2Nlc3NlZC4NCg0KPiArDQo+ICtzdGF0aWMg
aW50IHFtX3dyaXRlX3JlZyhzdHJ1Y3QgaGlzaV9xbSAqcW0sIHUzMiByZWcsDQo+ICsJCQl1MzIg
KmRhdGEsIHU4IG51bXMpDQoNCnFtX3dyaXRlX3JlZ3MoKQ0KDQo+ICsNCj4gK3N0YXRpYyBpbnQg
cW1fcndfcmVnc19yZWFkKHN0cnVjdCBoaXNpX3FtICpxbSwgc3RydWN0IGFjY192Zl9kYXRhICp2
Zl9kYXRhKQ0KDQpxbV9sb2FkX3JlZ3MoKS4gSXQncyBjb25mdXNpbmcgdG8gaGF2ZSBib3RoICdy
dycgYW5kICdyZWFkJy4NCg0KPiArDQo+ICtzdGF0aWMgaW50IHFtX3J3X3JlZ3Nfd3JpdGUoc3Ry
dWN0IGhpc2lfcW0gKnFtLCBzdHJ1Y3QgYWNjX3ZmX2RhdGENCj4gKnZmX2RhdGEpDQoNCnFtX3Nh
dmVfcmVncygpDQoNCj4gK3N0YXRpYyBpbnQgaGlzaV9hY2NfdmZfcW1faW5pdChzdHJ1Y3QgaGlz
aV9hY2NfdmZfY29yZV9kZXZpY2UgKmhpc2lfYWNjX3ZkZXYpDQo+ICt7DQo+ICsJc3RydWN0IHZm
aW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2ID0gJmhpc2lfYWNjX3ZkZXYtPmNvcmVfZGV2aWNlOw0K
PiArCXN0cnVjdCBoaXNpX3FtICp2Zl9xbSA9ICZoaXNpX2FjY192ZGV2LT52Zl9xbTsNCj4gKwlz
dHJ1Y3QgcGNpX2RldiAqdmZfZGV2ID0gdmRldi0+cGRldjsNCj4gKw0KPiArCS8qDQo+ICsJICog
QUNDIFZGIGRldiBCQVIyIHJlZ2lvbiBjb25zaXN0cyBvZiBib3RoIGZ1bmN0aW9uYWwgcmVnaXN0
ZXIgc3BhY2UNCj4gKwkgKiBhbmQgbWlncmF0aW9uIGNvbnRyb2wgcmVnaXN0ZXIgc3BhY2UuIEZv
ciBtaWdyYXRpb24gdG8gd29yaywgd2UNCj4gKwkgKiBuZWVkIGFjY2VzcyB0byBib3RoLiBIZW5j
ZSwgd2UgbWFwIHRoZSBlbnRpcmUgQkFSMiByZWdpb24gaGVyZS4NCj4gKwkgKiBCdXQgZnJvbSBh
IHNlY3VyaXR5IHBvaW50IG9mIHZpZXcsIHdlIHJlc3RyaWN0IGFjY2VzcyB0byB0aGUNCj4gKwkg
KiBtaWdyYXRpb24gY29udHJvbCBzcGFjZSBmcm9tIEd1ZXN0KFBsZWFzZSBzZWUNCj4gbW1hcC9p
b2N0bC9yZWFkL3dyaXRlDQo+ICsJICogb3ZlcnJpZGUgZnVuY3Rpb25zKS4NCg0KKFBsZWFzZSBz
ZWUgaGlzaV9hY2NfdmZpb19wY2lfbWlncm5fb3BzKQ0KDQo+ICsJICoNCj4gKwkgKiBBbHNvIHRo
ZSBIaVNpbGljb24gQUNDIFZGIGRldmljZXMgc3VwcG9ydGVkIGJ5IHRoaXMgZHJpdmVyIG9uDQo+
ICsJICogSGlTaWxpY29uIGhhcmR3YXJlIHBsYXRmb3JtcyBhcmUgaW50ZWdyYXRlZCBlbmQgcG9p
bnQgZGV2aWNlcw0KPiArCSAqIGFuZCBoYXMgbm8gY2FwYWJpbGl0eSB0byBwZXJmb3JtIFBDSWUg
UDJQLg0KDQpBY2NvcmRpbmcgdG8gdjUgZGlzY3Vzc2lvbiBJIHRoaW5rIGl0IGlzIHRoZSBwbGF0
Zm9ybSB3aGljaCBsYWNrcyBvZiB0aGUNClAyUCBjYXBhYmlsaXR5IGluc3RlYWQgb2YgdGhlIGRl
dmljZS4gQ3VycmVudCB3cml0aW5nIGlzIHJlYWQgdG8gdGhlIGxhdHRlci4NCg0KYmV0dGVyIGNs
YXJpZnkgaXQgYWNjdXJhdGVseS4g8J+Yig0KDQo+ICBzdGF0aWMgaW50IGhpc2lfYWNjX3ZmaW9f
cGNpX3Byb2JlKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBjb25zdCBzdHJ1Y3QNCj4gcGNpX2Rldmlj
ZV9pZCAqaWQpDQo+ICB7DQo+IC0Jc3RydWN0IHZmaW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2Ow0K
PiArCXN0cnVjdCBoaXNpX2FjY192Zl9jb3JlX2RldmljZSAqaGlzaV9hY2NfdmRldjsNCj4gKwlz
dHJ1Y3QgaGlzaV9xbSAqcGZfcW07DQo+ICAJaW50IHJldDsNCj4gDQo+IC0JdmRldiA9IGt6YWxs
b2Moc2l6ZW9mKCp2ZGV2KSwgR0ZQX0tFUk5FTCk7DQo+IC0JaWYgKCF2ZGV2KQ0KPiArCWhpc2lf
YWNjX3ZkZXYgPSBremFsbG9jKHNpemVvZigqaGlzaV9hY2NfdmRldiksIEdGUF9LRVJORUwpOw0K
PiArCWlmICghaGlzaV9hY2NfdmRldikNCj4gIAkJcmV0dXJuIC1FTk9NRU07DQo+IA0KPiAtCXZm
aW9fcGNpX2NvcmVfaW5pdF9kZXZpY2UodmRldiwgcGRldiwgJmhpc2lfYWNjX3ZmaW9fcGNpX29w
cyk7DQo+ICsJcGZfcW0gPSBoaXNpX2FjY19nZXRfcGZfcW0ocGRldik7DQo+ICsJaWYgKHBmX3Ft
ICYmIHBmX3FtLT52ZXIgPj0gUU1fSFdfVjMpIHsNCj4gKwkJcmV0ID0gaGlzaV9hY2NfdmZpb19w
Y2lfbWlncm5faW5pdChoaXNpX2FjY192ZGV2LCBwZGV2LA0KPiBwZl9xbSk7DQo+ICsJCWlmICgh
cmV0KSB7DQo+ICsJCQl2ZmlvX3BjaV9jb3JlX2luaXRfZGV2aWNlKCZoaXNpX2FjY192ZGV2LQ0K
PiA+Y29yZV9kZXZpY2UsIHBkZXYsDQo+ICsNCj4gJmhpc2lfYWNjX3ZmaW9fcGNpX21pZ3JuX29w
cyk7DQo+ICsJCX0gZWxzZSB7DQo+ICsJCQlwY2lfd2FybihwZGV2LCAibWlncmF0aW9uIHN1cHBv
cnQgZmFpbGVkLCBjb250aW51ZQ0KPiB3aXRoIGdlbmVyaWMgaW50ZXJmYWNlXG4iKTsNCj4gKwkJ
CXZmaW9fcGNpX2NvcmVfaW5pdF9kZXZpY2UoJmhpc2lfYWNjX3ZkZXYtDQo+ID5jb3JlX2Rldmlj
ZSwgcGRldiwNCj4gKwkJCQkJCSAgJmhpc2lfYWNjX3ZmaW9fcGNpX29wcyk7DQo+ICsJCX0NCg0K
VGhpcyBsb2dpYyBsb29rcyB3ZWlyZC4gRWFybGllciB5b3Ugc3RhdGUgdGhhdCB0aGUgbWlncmF0
aW9uIGNvbnRyb2wgDQpyZWdpb24gbXVzdCBiZSBoaWRkZW4gZnJvbSB0aGUgdXNlcnNwYWNlIGFz
IGEgc2VjdXJpdHkgcmVxdWlyZW1lbnQsDQpidXQgYWJvdmUgbG9naWMgcmVhZHMgbGlrZSBpZiB0
aGUgZHJpdmVyIGZhaWxzIHRvIGluaXRpYWxpemUgbWlncmF0aW9uIA0Kc3VwcG9ydCB0aGVuIHdl
IGp1c3QgZmFsbCBiYWNrIHRvIHRoZSBkZWZhdWx0IG9wcyB3aGljaCBncmFudHMgdGhlDQp1c2Vy
IHRoZSBmdWxsIGFjY2VzcyB0byB0aGUgZW50aXJlIE1NSU8gYmFyLg0KDQo+ICsJfSBlbHNlIHsN
Cj4gKwkJdmZpb19wY2lfY29yZV9pbml0X2RldmljZSgmaGlzaV9hY2NfdmRldi0+Y29yZV9kZXZp
Y2UsIHBkZXYsDQo+ICsJCQkJCSAgJmhpc2lfYWNjX3ZmaW9fcGNpX29wcyk7DQo+ICsJfQ0KDQpJ
ZiB0aGUgaGFyZHdhcmUgaXRzZWxmIGRvZXNuJ3Qgc3VwcG9ydCB0aGUgbWlncmF0aW9uIGNhcGFi
aWxpdHksIGNhbiB3ZQ0KanVzdCBtb3ZlIGl0IG91dCBvZiB0aGUgaWQgdGFibGUgYW5kIGxldCB2
ZmlvLXBjaSB0byBkcml2ZSBpdD8NCg0KVGhhbmtzDQpLZXZpbg0K
