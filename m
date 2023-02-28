Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E52D6A5965
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 13:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbjB1Msa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 07:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjB1Ms2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 07:48:28 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EC210260;
        Tue, 28 Feb 2023 04:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677588507; x=1709124507;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a3G14omDXDE03IlHKsZSkgpch5bgEcdEsIFfqf41V1c=;
  b=WsCJcmAnp78r/ad0d/uBhXvhK4Nn39Jczm/nwiH/Mt2B3elTZu5T4rEr
   xRvM8bQ9EmUWIHqfGfl+L/2O1dKpxQLFE4Tkxf6rZpJItVe0rkvYXL6FT
   aMjsVE3olDfE1Kmtw+bKX62vZFlH7WTwT6R/TkTHRDr+VT5dSB0ZnZZqL
   MJ9XNtOdg+zCDGAM53OpMzJedT5S7dhZaUvgfMsvweDtju0i9zS+5/woB
   buHASLdMMnP2zHsM5zbnnYkuCilfthOP0jZYlwPc8Boude0JFiTU9h3s5
   rpaQcQzBPywmB9AQlu2NfYHKdhciATx7xisbSIlHMGRhrKU9ibCz/7Nms
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="396694181"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="396694181"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 04:48:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="1003224836"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="1003224836"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 28 Feb 2023 04:48:26 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 04:48:25 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 28 Feb 2023 04:48:25 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 04:48:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f47rsmwOFcNeLKgq3o08DEKRwvCPmsf9U2EDvBZbEEGj0wRzy/TDhbTPMkM30pEi3zki8+Z7zHx8X0F34/IdWe0zGRwx1+nzs+24oEPbfMHM525W8BdgW1iAMNkcqULOdhrsBSEL6xEcx2+crihYt7zAYNPx+99PzcrdgPEgeCmS03zz1rFfiFLASJTPTs4qeOJ7aWz2LQGD0wRQx0I/TsWVeB053eszv0Mk/zF+F9IKyh9S5SqHSf112WNyd4IZGBmaJ8JW49Muv9u9kF5M7Jbad6m8DrTnQdWNVkybClPTgwJxucZUhmhpaHkr8chp2yqWsGTEqwtWp7YKfggRbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a3G14omDXDE03IlHKsZSkgpch5bgEcdEsIFfqf41V1c=;
 b=IbRi0looopgatF/gihVeiAQqy3sEVmfGw1GtCuzqS3AzmhDSElq/Q7bSWVAoorwWuLkxJP3Xq7+soR35tdCNFzX2jYmsTZOrHmZE0Lbrf4M1KG+lTeTURYoC+m1+icsFtzaaKB4owPxYHP7gwX7Mos3sh9TgZqFjg+sD0HESbGNcpikGfDM4HZAQ+4IH2WowNmL0GGCHVUZ9c2JPSw9LNy2DI8tmwtGYE19AC3GKqs5Vn5ltWqNdgKmcvQ1Inw8CWPFGR7f3mmVUe9Lv0gnwoo64HcNsW/DwC6HgQosDq8DGSw4OHcf6Ly8J6r3ZFur2M4LJOUV/oktOsWrrocvQuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB6552.namprd11.prod.outlook.com (2603:10b6:8:8f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.29; Tue, 28 Feb 2023 12:48:24 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 12:48:23 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 10/19] vfio: Add infrastructure for bind_iommufd from
 userspace
Thread-Topic: [PATCH v5 10/19] vfio: Add infrastructure for bind_iommufd from
 userspace
Thread-Index: AQHZSpxK4wL3BAz2vkuMw78Q2DEYMa7jHbWAgACHOBCAAKaUgIAABHXw
Date:   Tue, 28 Feb 2023 12:48:23 +0000
Message-ID: <DS0PR11MB75296F3B01E872C5E13763BEC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-11-yi.l.liu@intel.com> <Y/z2mY97uPsCs6Ix@nvidia.com>
 <DS0PR11MB75292E7DCC6FFEBF5B5DF66AC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/3zw/F0AN74CYs0@nvidia.com>
In-Reply-To: <Y/3zw/F0AN74CYs0@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM4PR11MB6552:EE_
x-ms-office365-filtering-correlation-id: 45084130-8eaf-4d8e-15de-08db198a1439
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yjPTB+mVK2SflAKnONeTh8hOI+0cvoIpCM6BNFVe7m74cO1RCN4Dlq9fIwNwi+kqPDIIBlgOAc4BsM0wciASmuYABjErpGPOXGyk+oNPQJrm+uY6sU21jshV/SGFQRFc2H3CSR+2pHT446D+pkqb1IL+vCiGtKn7i6wFNPjoWcvjki09nk+NHuDJexr+tYs3qCEMGW1UhAjf8NDZ+8qIFYw+kKHwwci7MBq13dwqCUcEhyY++LWwOajXD3bkMfX6VGH/o3ZZIIvts7MJ10h2orCLpfpHfTfsHLhIpj3fc8oJak4sB2aqoio15S8Yi54AjzsV00Nqstyu6rmk/wSYEuu+XbVw0AU+Z2bbVMELATj+rDSgBJmq9eJ0Fx89Y00ffJ/p7iud1efa1L+63yTsCHJULArZFtvnZoQ9YM9zfwIzwe5ZGRKwl0NKSToAUj5cNQ4MiPoMiDlw2UFLA1H2IVcwlyUU6IMD/FxsIrNM9K+5MLf/EN9kVtVJJ5lXO6ieoZDvNlT4BWMKaJXLF9wOFeaSMnrLudXNqAzigcrxHn6V//NxW1g61RFsOlnAMb/Y4koASbQDboq1NvwqEPp6X3mA4wia0zzuD7jVdunenq4l75leL+kE9SPansNPCimGs3BmBi/iEFSMTsicnrLMZ8E3ubp+McO+isqjw8yHqHKMQLMpneo0FORhDcxWUVb7WhCkM5tOJHihpX1rBNOIIg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(39860400002)(366004)(346002)(451199018)(9686003)(186003)(38100700002)(82960400001)(122000001)(38070700005)(83380400001)(52536014)(8936002)(4326008)(66446008)(66476007)(2906002)(66946007)(5660300002)(7416002)(76116006)(41300700001)(4744005)(55016003)(66556008)(7696005)(71200400001)(6506007)(6916009)(478600001)(64756008)(26005)(316002)(33656002)(54906003)(8676002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NTdlNlAzeUVFMTlnUHhQb3RmRUtJdVk3Q0UyaG5waGZqRGtLZ2R1WmZ3K1BG?=
 =?utf-8?B?STg2WVFqUTJHUkltOUtaazFaN1hYNnp1R0p6Q2dXREJrTzIyREZWUXJ6SGNq?=
 =?utf-8?B?UXE2ZTB5dC9HNzZNN1BubTZSdUIxOE9sK1FjcGF5bkRvNHNwTWZPZDNvUm4z?=
 =?utf-8?B?SGJzTFl3RVMyNXM3Ym9rTDBBbEQrYnFuckNjQjlFRmY1K3ZyQ0xDRjU4OHRJ?=
 =?utf-8?B?SlpJSUhoOC9VbTRmN3dqOEQ5azlBZ2pDV3VIc3F4M3N0Uk03eGtCcnZUcnB6?=
 =?utf-8?B?SjBSQzdaMllXSHlJZm5ySVVhVXplM0dlL2hVTXRKbS96SmVRKzJzZksxTUx0?=
 =?utf-8?B?T0U5akI2OU80T1hZL0NIY0l2eXpNVUpRaFZ3ZTlxYkhJM1VnVmVNV1paTTEy?=
 =?utf-8?B?N1ZYeGhXTFcwSDA2bFJWNW45cStsUFJ0YU1jK09xZUJBUHg0UE9OMGpRRXZ0?=
 =?utf-8?B?amZkQnNSMTJJU0lBdGIyQXNLMVJIaSt5b3lxa2V4T1ZxRUVqRWFYZDVUVVh6?=
 =?utf-8?B?a0xWeGhnQ1BoVE5WYmhRSGxBV2l2K25UR21ydUNybzRpUEdOeG5pcmk0Zi9o?=
 =?utf-8?B?aEllYjJHRXNOeU9vR05RWlpibTNTM3hkTGxSNE5EODUrSG5QR25rZUwzQ0tO?=
 =?utf-8?B?d3U1Nm5BZStRTUZyQmtuY0MveUFsb0xFRTRjMDZ2RUhDa2ZhK09LcHR3ZFVD?=
 =?utf-8?B?Vi91ZXUxUFQ0YXhGc3lETThva1JqTDgvQUN6azRONzdHY3VWdTNOd0dyVHVL?=
 =?utf-8?B?Ui9YVkZGUTlYa3N6aE0wZ2IzTUQvQytZcWdGNk1wN29tdG5WL0ZRdkNxNzV2?=
 =?utf-8?B?cU5uNVlFOWVmcVZzSVB5a3FaMHhXMUQ5a20wU2UyM2NIeE9KR0tpTlZSNHpz?=
 =?utf-8?B?ZzQyemhPTklXTkRrTVZrdmprbnBKUDZ0SFRGUGt0WnB5cGxIVnVHVnpEdjNH?=
 =?utf-8?B?cGZEcFFiWU5jTENtQ3luNVpkbEdZcGtWZEQzMjRhYWhOZHhMREVZV21mNnZK?=
 =?utf-8?B?bUpKbDJQdnBUSnBNcnBtZk1CcVZ4b01LRVlpVFowaXg5VFhkUnN6VG42T1lv?=
 =?utf-8?B?OXdBR0wvNjRPNDBmWWgrWExyY3pFZ0lWVWJraDlHTlFOaElYYWZRTmJNWitx?=
 =?utf-8?B?aHJVNTExSHU5cFlmZXJOL2JSS1g5OHlQYWVDS1gvbktMTGVQOVFuQktmQ1gr?=
 =?utf-8?B?SldhN0xuM29sT1owWmVUYjBoZWZiUTBkNExDYmlIZlF1bGZFYnExMEZ5ZXdE?=
 =?utf-8?B?REdoaGlsRzhTL2RwK3BpT2FteFBlRVdCbWJPYXg4RkNMbXB0aFdkR1BvNjFB?=
 =?utf-8?B?YkVoZnNJbGJGTHF3cnNWVnYvRnpsTjIvUmZwUE44TzVza2VFMjdIenFZaGQw?=
 =?utf-8?B?cGpIa3FYYmhwMnlLWWs0UkVlOENrTDd2Yk84OUNUTUFmcWJ3dFYxRjVhdkFB?=
 =?utf-8?B?dFNuS1h4MmowWnZyVy9ENmR0Vk92eUIrWldlMlBUS2ZqbXExZU05OVdITDcv?=
 =?utf-8?B?d3luSUU2b0ppQldabWJBMWtSNFVveFZ2YSt2WFZlL1lCMGVPSnVacG1BVEt6?=
 =?utf-8?B?cXR1cllRTGlRUWl3YzdVNkZ0ck5mR0hOWFpIeVNadjhUQnFUbzlkbDFKazZN?=
 =?utf-8?B?RHJoTDNraGxOSlJkUnA4clJRd1haSnlSbTZISTlOMEh0RURNWFA2TE5pQUtM?=
 =?utf-8?B?NmFySUxiNThERGhrc0RSNERSTlZoSUVkQlVSS3pkSHdHaWV3dWpMTGJZOUt3?=
 =?utf-8?B?Z1RNU09SVW1VTlpLUUhrL3cvbS9oOHEzK1Q3L09TR1M5ZlJEYmZEQ1hWenJz?=
 =?utf-8?B?cEhQWVJGTGJzMnR4S2VkMmg3bGhKK2huekdZdEdhRkg1UWU3eml6Y3FIbmc0?=
 =?utf-8?B?MXRhbmhEemwvdy9xZzdxQU5ibzdFU2QzdkdhZjVmRGJWSGhYZ2poT2tRME1a?=
 =?utf-8?B?YXJIU0JyOGdQOUd2NEt6ZXpGV3FGam5ERFlxc2JNVUs5V0RZM0hpeVU3cTlQ?=
 =?utf-8?B?Nm5TRVNoSU5zcUZtbWFVN3ZOL1lLR1FGUTZVZjU3T0VJcVM3Q0lBUWV1TW5R?=
 =?utf-8?B?NUR1eE93WWsydEFnOTB2c3dYZS9wbm96Mld3SnhubnhuK1h3RkJrN3dCdWdJ?=
 =?utf-8?Q?x9gTqN62ePZdS+j/tS7s8rJQZ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45084130-8eaf-4d8e-15de-08db198a1439
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 12:48:23.8055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u4trL4bo39N8FJH/hSz8hxz3sa2JRVkR+TkrMhtZtztYEfCi8xYF0L9uvn/TbtHIIGEUPimRtu1lLkNeVHHl6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6552
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBUdWVzZGF5
LCBGZWJydWFyeSAyOCwgMjAyMyA4OjMwIFBNDQo+IA0KPiBPbiBUdWUsIEZlYiAyOCwgMjAyMyBh
dCAwMjozNToyNUFNICswMDAwLCBMaXUsIFlpIEwgd3JvdGU6DQo+IA0KPiA+ID4gQW5kIHRoZSBj
b21taXQgbWVzc2FnZSBpcyBzb3J0IG9mIG91dCBvZiBzeW5jIHdpdGggdGhlIHBhdGNoLCBtb3Jl
IGxpa2U6DQo+ID4gPg0KPiA+ID4gdmZpbzogUGFzcyB0aGUgcHRfaWQgYXMgYW4gYXJndW1lbnQg
dG8gdmZpb19pb21tdWZkX2JpbmQoKQ0KPiA+ID4NCj4gPiA+IFRvIHN1cHBvcnQgYmluZGluZyB0
aGUgY2RldiB0aGUgcHRfaWQgbXVzdCBjb21lIGZyb20gdXNlcnNwYWNlDQo+IGluc3RlYWQNCj4g
PiA+IG9mIGJlaW5nIGZvcmNlZCB0byB0aGUgY29tcGF0X2lvYXNfaWQuDQo+ID4gPg0KPiA+DQo+
ID4gR290IGl0LiBub3Qgb25seSBwdF9pZCwgYWxzbyBkZXZfaWQuIPCfmIoNCj4gDQo+IE1heWJl
IGRldl9pZCBzaG91bGQgYmUgcmVhZCBiYWNrIGZyb20gdGhlIGlvbW11ZmRfZGV2aWNlIHBvaW50
ZXIgaW4NCj4gdGhlIHZmaW9fZGV2aWNlLiBJdCBpcyB0cml2aWFsbHkgc3RvcmVkIGluIHRoYXQg
bWVtb3J5IGFscmVhZHkNCg0KWWVzLiB0aGlzIHNvbWVob3cgZ2l2ZXMgbWUgYSBkb3VidC4gV2h5
IGlvbW11ZmRfZGV2aWNlX2JpbmQoKSByZXR1cm5zDQpib3RoIGlvbW11ZmRfZGV2aWNlIHBvaW50
ZXIgYW5kIHRoZSBpZCBiYWNrIGFzIGlkIGlzIGFscmVhZHkgc3RvcmVkIGluIHRoZQ0KaW9tbXVm
ZF9kZXZpY2UuIElzIGl0Pw0KDQpSZWdhcmRzLA0KWWkgTGl1DQo=
