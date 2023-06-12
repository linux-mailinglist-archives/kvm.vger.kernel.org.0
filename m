Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E12A72B62A
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 05:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbjFLDlc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jun 2023 23:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbjFLDla (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jun 2023 23:41:30 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382DD114;
        Sun, 11 Jun 2023 20:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686541289; x=1718077289;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qKPTYXOGRdh6xV9OFBDZcWrUEvjCcQ/J6gmtVlzZ7KI=;
  b=SYRxnuJj4uPL0kmtQsvUj6gk7F6emyj115qlYxPjtFW3v5yWddORcngL
   z7YthbPwk0Q3Cuf5mw9pwcJo42+D6uefwEjeFH3pTss+PanxVKEtWHleu
   B8bFh9yP5CC3D92GvseqFWHEuItzf4HZkMeMXLXYb4mjX4JxDMqlqun5n
   q4BalRkqQ+MZDFzUnBYaatFEqEyva898gZ0NN0OXjUhIm08WxkSwq+B7T
   qTqG78EU1bYrj/Hdh1YG1AG5GoyHIg4N51yWyED1O3PgUaU9BRLpuHDF2
   vk7sfKn4A6xi490quwFlAjhyKe/PzNHKocF/zRdwfdvFU4jLkCD3K4ybD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="355432607"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="355432607"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2023 20:41:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="800868709"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="800868709"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Jun 2023 20:41:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 20:41:28 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 11 Jun 2023 20:41:28 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 11 Jun 2023 20:41:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m24BO2vvRr8hZsFlrXbijCMYnytf7W8UWUwWKRsam12ZEd0eyYJ+bqDchilO9QBE1ptGCjylgqP+zPJ4fXC11mrsUx1VRfWZ2HqZXmS+UccanfJxBZZW9Dz1PVqHMUyjMxETqFrJvJdXxrSboKFq8SIJ2eYWy0YP+ABK7ot2qb6VDJSIrYN4Nn3h73JBD3IFbHHkxZuN23SMOjNi9VsZ5mrFtoHxkeRboVDzRFqUK6GmmH8EqkoC4LW0HFkUEUNhdkOxjfdV7C29e8njdo+mYXVrMxz+fBVG4KdaANTor4bBa0p4vCFwyp0mV2331ZoaRQ5r/Ql8PlKKZ0iJdTqLtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qKPTYXOGRdh6xV9OFBDZcWrUEvjCcQ/J6gmtVlzZ7KI=;
 b=iOwaPeGjsYufx8ufWnXhfAXIQAfMGPqH/Qcx8l6dZwKD0li/O8MeerYszjYK+lCsyBZ3MVXk2v62mndXBm6XeIw+LYKXZuz2IdAshtNabnQUYjkk+0P3heq3nugiNv9Rmkukf+8YmsACmsmcoeBeJFmhdH1kp6aVtKQh29Bmm+lr/gfQkf9AWbcA3+B7b2AoR61tl3gQWF0REaekltMDAhHNzvtnHruX6ohTTCQUI6lqGR3OQ2GCBDNmf4kvsxOpuK6klHixrIQAIV7eUYpGrJd6mKcEVi/ZyohkK3jsh7pgaf+Z2YhMKi0A3LwKtqoXCCkd9xo/I3qOO+v6OJka4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW3PR11MB4524.namprd11.prod.outlook.com (2603:10b6:303:2c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 12 Jun
 2023 03:41:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 03:41:24 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 20/20] Documentation/x86: Add documentation for TDX
 host support
Thread-Topic: [PATCH v11 20/20] Documentation/x86: Add documentation for TDX
 host support
Thread-Index: AQHZlu+7HeozfQQExUabk5yG2r0Tc6+Bm+eAgAT1u4A=
Date:   Mon, 12 Jun 2023 03:41:24 +0000
Message-ID: <09612cd1d1db2fde2c6e064786409a5539ac8ee8.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <34853e0f8f38ec2fda66b0ba480d4df63b8aab43.1685887183.git.kai.huang@intel.com>
         <971f158b-f28a-6c1f-c37c-fe67134d737c@intel.com>
In-Reply-To: <971f158b-f28a-6c1f-c37c-fe67134d737c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW3PR11MB4524:EE_
x-ms-office365-filtering-correlation-id: 48b80054-83b3-47b1-9cf0-08db6af6e565
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AD25vsgxInVhq5NQ8GoiH1OmmXRzySYS/l9c9+NVZZRLNp5Ew5YvzxojJTxMb6pjDU5/vvo6iSr/sU5vKNSemriHX3tAuq8oTlurxVprA/G8c4hFc/33bDkIu3XpfZH/rDbPzbdflOz1gwOKJEMmtXMtUNCHpwcrppe2lG5mXQ8VoXsPJ8R+g15gV6LxuWwEhl7OQQH0e66AfjDtOTcDGifx+pDVXM/GV9ENd1FuM7ULHHxdW1sXnT9kVN0MGNYYBMZ+dpIVpiNXtu4pztBKU0z/cDlS2Np4nl0To03RfaIFHeBpThVathaJ4WB0sXRTVegDEWxhiJ+BNgr+2I7MkWkuRZajETlLBqJwhEVyHsTjfYnooKB047p2njucqpt7UOlxIbD8Twz76UjjDZSYU1HoUj17h58wj//Pd+OzM8FZVx8OQsaNklL1k21+qnAf7QgxnO3c722+PJOdXGLS6XaqMFxtVEPZjU8AFjVciLDaiAQei6P2/Vuz2bHerQGaM1Lt4Wljn6NCbtuo041uyYFiuUVZotTEdLU/Y9Eilwp+bPsr90YB1yYfyfKvQqRYywqfQkCUBf0PpQ0H5YDg5UGKVWcZMxRXSylR+/3OD5zHA/+aRYuRamvrNCgNJ02B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199021)(76116006)(26005)(186003)(6506007)(6512007)(53546011)(2616005)(6486002)(83380400001)(41300700001)(86362001)(7416002)(82960400001)(2906002)(71200400001)(8936002)(478600001)(36756003)(8676002)(316002)(110136005)(38070700005)(38100700002)(122000001)(5660300002)(66446008)(66476007)(4326008)(54906003)(66556008)(66946007)(91956017)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1ZWV2ZielNkSHl5ZHFTQndWVHJPeFAydnBHeis1OTVTV0NMWHVNRG16aXpD?=
 =?utf-8?B?YnpxM0ZON3IvUmN5K3ZqcGNlTXlLOU5SRDhhczhxa094WTNSS1hTaWhFNzNK?=
 =?utf-8?B?MzdHMWUybmtWSTlEa055ZzVaN09IZlVVVkxvVXNMbWU5blM2VHhtWm5FSTJv?=
 =?utf-8?B?dWxQeE1TamptSE5hM2I3UXBxSkI2RW90VnBJY05Xb1M3TTIzaHowZXNJU0tj?=
 =?utf-8?B?N0dPL1dCSTVDeWNWekVhb01qaGV2S0k4dmJNOWZTMGZObFNnSmNVYUllOE0v?=
 =?utf-8?B?czMwWmpPNDVlVGIwOUI4eGUyZm5KaFk0TkJzd1JOV0dSbHZDeHJ6RXFSZGRD?=
 =?utf-8?B?eUNkTFpTMFVROXlsNUNrVlNwVzZDOExlL1JDK2NpZlNnWE1sK0dmN0FDeURR?=
 =?utf-8?B?bTJUcW9HYXhEVnU5Um0yYjNwTVYvRmx1T2txWXRFcC9OLzdxSmFxUHBHdEdX?=
 =?utf-8?B?SFpkeElIQVdMTmxFc2dFRm5INk1sZStyM01LbEw5Z1poM2ZZUjVLbnJicEVT?=
 =?utf-8?B?VHY5OUFTR0pLY2lnZU1UV2hBL1lSSWp4VlJYWlJUOTR5R0FPRXpRTEZ1cVp4?=
 =?utf-8?B?dm8zTG50cFo3dlpCeE1NT0QxWlFwSDJIRUVyWmFyaFVhdmRKd1VZc2cyVFF2?=
 =?utf-8?B?Y052Z2pWUlg1Yy9DVVFJQUtzMHk3UmFDLzU1a1U1NmtTNTZiT3p0aDdac3pk?=
 =?utf-8?B?NHNNVE5XN2tSZFVwRzNZTGFWTkhhdDFxdWFOSnNFWEFmMDBWcWx4bkpOQlVj?=
 =?utf-8?B?UnozMTlMRjUyZGpOdXZYNVBDYkFHR2VDcDN6S3l5bUc1dWorM0RtS2dXT2kx?=
 =?utf-8?B?MlozMG40QkZtOTVBWW0wOE9uWWhNVEFNR29QSmZyZk5wWHd2bXF6SkczazhJ?=
 =?utf-8?B?dTFxSnhvb3E2Q0dsVzlzeHpGb0MyMkxscFE1S1N6b0ZrTDdEN1ZEb1JtbXpM?=
 =?utf-8?B?Ly9xUWFSdXVOMWFBQ05SWk9xMjhkaDlNR0JpbFJ4UmZ1ODhCQS9EbjBsZkh2?=
 =?utf-8?B?clRIWWU0amgvUnFvaFJmSzZLbWkweXlLbDUyeHVvaWkzd2FRTlhGaURpSzYr?=
 =?utf-8?B?Wlo1WmRwQVE2Y2szVXBTU09HT1BYRXdNR0NCV0xQa0FFaXlDSkZtQzNVbTNx?=
 =?utf-8?B?YUo0WlNBY0JYV2ZWb1VkUytYWTZTT3NVa2RKNGZnTHpqQUszNkxuNXRidXNr?=
 =?utf-8?B?dmdZL1MrRXRUSEVQSldHY3hNY3NJRytLYmxuTWRiSkdLQllNRWlQbkhjUjE4?=
 =?utf-8?B?c2hhMktEa1FTQW1lMC8xTk1pT2tWOFV0WXlYN0diTnBCTnBTeGJ0Q3RtbWNx?=
 =?utf-8?B?Rkp6alFJZnVLdnhOY3htZkpvMTR0Y2s0NkQ0Zjk5U2NQQUd0TGpOcUVhb2Uy?=
 =?utf-8?B?V1JvSDRpMXZLZmpzVHFhL2ViYWhwOEZtUER4U3pkMzc1OXhndVJkZ0RFRnJT?=
 =?utf-8?B?dTc5Q0M0aFczSllHWkZWcFZqT2U2Nzd6Z3pieVJWV21NSEhGbFd5MFNpZE5p?=
 =?utf-8?B?SUpmMG1DbUVtdXVGbU11V2RVYkdORUh1N1pIU2Q3OVBlcWVOcUVyWVQ1M2Uv?=
 =?utf-8?B?ckF3TVdlVmVzbmdaQm5jcE41K3lWb08xaStOSCt3WmJ4d2N0RHRWSzdrcENm?=
 =?utf-8?B?VmttSk5hOW1XTnZuRWVvaTU4R0FUSVhDVU9MamQvejhDOTJZUk8wOTB5aWJs?=
 =?utf-8?B?eDlCMVlHWGRnSWRnVWMzWWJTMUNTSkZBTnFsMjdkNWlyb1h5L1RlUHZweWJH?=
 =?utf-8?B?NUpIVk1WdXh6YXZiUHVueGxyWWkrSUw4OXhaQWF1VVA2cGRwd1RMODBNVm9u?=
 =?utf-8?B?Mmg4RzkwSlNPMjN1Z01GbCsyc1NJOHhQbVBJU2l3VG5YOGJBTk5teC9BODdI?=
 =?utf-8?B?NUVoNUd0MzJLRGNxWlVyWWtzalBHNVZKLzUvL1d0NCtFVHdqdmdzODZCRUNh?=
 =?utf-8?B?MHFoTU05eURpcDZVSlRlYUpYQTN1SDFVd2ZyWjVDb3JXVkZ0TzIvSkVnYllt?=
 =?utf-8?B?M2pvYTNWam5XbWo1Ull3THI4QmorUC9CN0VzK0VNUEg0Wi9LcGMzak8xUGVG?=
 =?utf-8?B?Um9lMDZIbThHQVhud1ZieXR3MG1pVFdLQUp2SXJRRC9ZYTA5VTlkWjJlNndZ?=
 =?utf-8?B?eHNEb0JaMDNRU3pvN2tlSllYMWt1QlhLbzM3bzNIeXdKNGtvWjk1UGk2ZXRF?=
 =?utf-8?B?SVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <91FFCF821F3A944AA045DB36657D12C2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48b80054-83b3-47b1-9cf0-08db6af6e565
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 03:41:24.5696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vmy8GQu0H/TpqDKvieziYxwDG3bI/eTLOA9z5q4cuSIjL8uPzvVYdvd5fsMHMDf89jr0zhvg9pxD4PgGtBuISw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4524
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

T24gVGh1LCAyMDIzLTA2LTA4IGF0IDE2OjU2IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNi80LzIzIDA3OjI3LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gK1RoZXJlIGlzIG5vIENQVUlE
IG9yIE1TUiB0byBkZXRlY3QgdGhlIFREWCBtb2R1bGUuICBUaGUga2VybmVsIGRldGVjdHMgaXQN
Cj4gPiArYnkgaW5pdGlhbGl6aW5nIGl0Lg0KPiANCj4gSXMgdGhpcyByZWFsbHkgd2hhdCB5b3Ug
d2FudCB0byBzYXk/DQo+IA0KPiBJZiB0aGUgbW9kdWxlIGlzIHRoZXJlLCBTRUFNQ0FMTCB3b3Jr
cy4gIElmIG5vdCwgaXQgZG9lc24ndC4gIFRoZSBtb2R1bGUNCj4gaXMgYXNzdW1lZCB0byBiZSB0
aGVyZSB3aGVuIFNFQU1DQUxMIHdvcmtzLiAgUmlnaHQ/DQo+IA0KPiBZZWFoLCB0aGF0IGZpcnN0
IFNFQU1DQUxMIGlzIHByb2JhYmx5IGFuIGluaXRpYWxpemF0aW9uIGNhbGwsIGJ1dCBmZWVsDQo+
IGxpa2UgdGhhdCdzIGJlc2lkZSB0aGUgcG9pbnQuDQoNClRoYW5rcyBmb3IgcmV2aWV3aW5nIHRo
ZSBkb2N1bWVudGF0aW9uLg0KDQpJIGd1ZXNzIEkgZG9uJ3QgbmVlZCB0byBtZW50aW9uIHRoZSAi
ZGV0ZWN0aW9uIiBwYXJ0IGF0IGFsbD8NCg0KDQotVERYIG1vZHVsZSBkZXRlY3Rpb24gYW5kIGlu
aXRpYWxpemF0aW9uDQorVERYIG1vZHVsZSBpbml0aWFsaXphdGlvbg0KIC0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KIA0KLVRoZXJlIGlzIG5vIENQVUlEIG9yIE1TUiB0
byBkZXRlY3QgdGhlIFREWCBtb2R1bGUuICBUaGUga2VybmVsIGRldGVjdHMgaXQNCi1ieSBpbml0
aWFsaXppbmcgaXQuDQotDQogVGhlIGtlcm5lbCB0YWxrcyB0byB0aGUgVERYIG1vZHVsZSB2aWEg
dGhlIG5ldyBTRUFNQ0FMTCBpbnN0cnVjdGlvbi4gIFRoZQ0KIFREWCBtb2R1bGUgaW1wbGVtZW50
cyBTRUFNQ0FMTCBsZWFmIGZ1bmN0aW9ucyB0byBhbGxvdyB0aGUga2VybmVsIHRvDQogaW5pdGlh
bGl6ZSBpdC4NCiANCitJZiB0aGUgVERYIG1vZHVsZSBpc24ndCBsb2FkZWQsIHRoZSBTRUFNQ0FM
TCBpbnN0cnVjdGlvbiBmYWlscyB3aXRoIGENCitzcGVjaWFsIGVycm9yLiAgSW4gdGhpcyBjYXNl
IHRoZSBrZXJuZWwgZmFpbHMgdGhlIG1vZHVsZSBpbml0aWFsaXphdGlvbg0KK2FuZCByZXBvcnRz
IHRoZSBtb2R1bGUgaXNuJ3QgbG9hZGVkOjoNCisNCisgIFsuLl0gdGR4OiBNb2R1bGUgaXNuJ3Qg
bG9hZGVkLg0KDQo=
