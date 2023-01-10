Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43187664FF9
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 00:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234892AbjAJXeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 18:34:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbjAJXeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 18:34:05 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C9157939;
        Tue, 10 Jan 2023 15:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673393644; x=1704929644;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3Im2pHD+ZFYIl0/K2al+zYf1XSeoweYX7S7OVEESyq8=;
  b=KpIQl7aKK+1LvEgEGJliCoibCAQHg2rH3xsUZgUyOr1ZwKP7p/9R19Gq
   /YryZiifa2seaVPpKqOO8ctLu5P0KXk8uuogo06mae+CE4ADGyEWZaNBz
   gEqfc4YmHiZnf3oTJSzoRfnvzzjEXguQo7MBsKLo8v+An6uHaj9kCR5WI
   FDeRLQC2TGTreTmWM5CmIK1XOUU0xV4RBQXmN0NbXk5FUH39U2JkLmRRX
   SgjCTSjbXDkWUByiw9rMYPg9aEvLfjD4Jt4qA/Q+iOVp5gIkhYQymZP/2
   eJfM4ocWWj8ZGnUBcpDcym3cz5z+H8jVvwOHc3vTTnsPblgXfBpmaulS1
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="325292643"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="325292643"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 15:34:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="764939084"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="764939084"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 10 Jan 2023 15:34:00 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 15:33:59 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 15:33:59 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 10 Jan 2023 15:33:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9lkW5AXNitJ+rHZyEhbqbn6YaceI3gzfxi0uq2kYDD1JpRSweUwTtCSb7G9P1jUvH7Qu1E/13cSipLsJto7Hf2qcezOzViYAZPf3Djq8rtejBtM0nmf1ciG9s6Vm2ilLlLbAq/x26tAQX9jdsVxaWEfVDddvxpd6SSyNYFyTZJKxdaFlKTku3xlXWdTyVdiOibKjRqKY5TO/6etxuiLayidGXxTTfNxpleoae9l9zTDhI+0aDir/x5CDhzY3dwQe15KSLScopemZTVkp5d++nU2EI9JVcqgPhaMPy1K27ScnVnXFZ+yaEHyRDciSi0ZVOM6KMOGAN4hOUgpIf7RWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Im2pHD+ZFYIl0/K2al+zYf1XSeoweYX7S7OVEESyq8=;
 b=Jfl0izIBP7iQ0nmCB6PWLddZLlvQjkRtqgaWdFFS6dKrs7w8Vq5LM8v6QxNWngItBd4C00hbixrRvs642eCXkRu2ccxF+V1OLjC9wSrRHukdjucjhjw3+SbyxPC9Hblcd9KYdWJPoTOF79te5q4QSH8/4t+IZIiLFPn6IckD38NgY811SJ2VD1RSIHXmvSJwhq6wHfOij/MBsxGmG/3x1/reYPSIea7b+aOw7/VfIDieAZtCGmojG/HwTLZxfQUot9EAX2l7ONHixSZlTk8OJv+MGiIxoP2pUvembPDuOLBHGjBQgpEXcYpdEdreXScXFYvQZqaoB1lBZDNNeu8UMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB5890.namprd11.prod.outlook.com (2603:10b6:303:188::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 23:33:48 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 23:33:47 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 12/16] x86/virt/tdx: Designate the global KeyID and
 configure the TDX module
Thread-Topic: [PATCH v8 12/16] x86/virt/tdx: Designate the global KeyID and
 configure the TDX module
Thread-Index: AQHZC5gREJAXmgz0iUOlZePgAM3Era6SIyCAgAWH0ACAAF49AIAAd5mA
Date:   Tue, 10 Jan 2023 23:33:47 +0000
Message-ID: <c4e5eadae12c72e7b6d97c1802773694ee04ba86.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <d7b01f396908da796644e58298a34c1f8a140be7.1670566861.git.kai.huang@intel.com>
         <e1a55f50-efc0-5098-1a2d-f0eaa0b51a82@intel.com>
         <748adb0e8df5f804371f0587ed8fef1184177484.camel@intel.com>
         <755f94aa-a0cc-b7d6-ce8a-a81ff4f598da@intel.com>
In-Reply-To: <755f94aa-a0cc-b7d6-ce8a-a81ff4f598da@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB5890:EE_
x-ms-office365-filtering-correlation-id: 19c80d74-56ce-49d8-2be2-08daf3631f3e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vL7a/v7rGpRBSZpG2gqLiKLU3MdPu2DVgm+1JDLbjpM4eglUuSnhmVOPTYxLc0K0I3vQ5TOdg7oiK1q163BOOADVvNXtFoe+vx3z0R25g65ZvFc7tlWFuO5UHNIXzSzsNOD9C024cyGFXqgzUnV5YuEtjJFggZKK94KHHIKGo0XuRJp/fpCGcnFAGW+WSYlFcHcMAjXT7l0dfb5ycQMG4Hl/tUpzb6777rqjLZ/KaHFz6Xxo6Lxj7EUh8aoPQSRH36L5v/MTIVYjkLiiNQcFhUwSDNUipcQ2w4wFQUwVf3La76cX5wytwBVy6FSunna1XDzaiJTR4y40LO7ZvoTqLaJhXQ9fL9gbg2XGHlHdo04TtAmxj0a2Uixqu0OaIPrWpjVBXkVUWtIjfHjTGJshOZhHuktOb/zrAm5n/7q5mNfgH2yBcd97pM5niowySN5fSV2norFq0gObCZw75np0TMepOkjBQOwRo/rHYcrJS++3buSkABkq6LcFL9WomDPyeS33EtSUis1PvVInkwXsadGsmAaAEU4xgmoBL0/pNtNfpFXe110A6atzuuUQXApQDxbkgTtDdjpXZWujgMg09TmuYmixlXNErgmDw60kSSDxOOmA9RvXDFK0edIHDfNVmkt5dmAQq5w4K2l6zkiG/iY2Y7/6x8gSs2K/wRaHXWKk/hk5ER7yKc2jQHfjPUhFsmMEgYLya09p/kq7PKZ0a4lV3iCgxiBJ3/tln4Yo/iE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199015)(6512007)(38100700002)(122000001)(82960400001)(36756003)(38070700005)(86362001)(110136005)(2616005)(91956017)(53546011)(54906003)(316002)(26005)(186003)(478600001)(966005)(6486002)(71200400001)(5660300002)(8936002)(7416002)(83380400001)(2906002)(6506007)(4326008)(66446008)(66476007)(66556008)(66946007)(64756008)(41300700001)(8676002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eC8wUGFsTTE0L1R0eHd1WTZ1Q3VPakYzbStwTFZTUEZqK3RYUG40TGxCT29q?=
 =?utf-8?B?T3QwMVhYYndzSjJESFlybFRRMm1wWHg2Z0U0Z2lIVVF1dmRjenlreTBrWWRD?=
 =?utf-8?B?bUN0ZkhuRVVvMzludysyWldMQ3l2cVNwc1pnUFhvdnNyWGM0ekNiM0taa2dp?=
 =?utf-8?B?MjdsbHArL0NpSW1vTnFiVGg5dXpLeXNicVI5UFQrMHZBNVdoVXM2UkpuSGNu?=
 =?utf-8?B?ZDRrRzROdUwwTmFPVWE5R0psREVRUnBNNjZ4UmVnQzFYUzI1VEthblRyQ0hi?=
 =?utf-8?B?NVVHdlVDV3l4RTA3WGZRT204V0NQZW9UZmp4YStaamdmNWpJQmRlS3dmUVJT?=
 =?utf-8?B?RytJUExmN2gxVUFCZnFVT2lkQWpMNGxOWkZ0eHd0Ly9WM3FrdmJ4ejVvcnpr?=
 =?utf-8?B?cXdCcDlxdGpWaDZCRUVWNXE4Y042b3VOWFEyakFxa3ROSnFRc3JSSmRidVpr?=
 =?utf-8?B?aFdFRUxEUEJicVZyOUFCTFlHMzFQeSt6RENQK0JUOTF3UmllMTM4OU1vQUgv?=
 =?utf-8?B?aFlwK0hJWTViYjJHUk1Na3NXNjd6M2xIN25EU3FJT0d4TkVscXAxL2Nvc2l6?=
 =?utf-8?B?R2pRTEErc1dzdElNTlhMYlNqc0FJdGRweE9EV09uaUN3clQ3WmI4YUVWQUdJ?=
 =?utf-8?B?M0R2aFB0QUdQTUIrK3ZESEdNcENOSzNUU1RoQWd3MFBsZVF3U3JUemF3UjAy?=
 =?utf-8?B?eDE5WEFLQ0hJenJDUTJ5RHJJWTBsM0Rpay9taGZoQkkrVGdpS2RYTjRFZTlo?=
 =?utf-8?B?OUJKVVY0bFlaU1NqNGZJVmliMzNKRmZNVXlTdkxxOE9FaDZSQ1dsaXBnWlB3?=
 =?utf-8?B?Vy9UYmhEaWNlakNwSUhDVThmVVg4U3RYTTBhMnlJYUh2enlqbTBvMzlUY1lv?=
 =?utf-8?B?dU1wU3B1ZU13WnBxOEp2Q3ZNa2RyNHpPajZPa0JOa084WUNuc1ZKdlBINUhO?=
 =?utf-8?B?d1NXdHFLQTZSeThVaVp6WmdHM1NpR1lJUm5sWWc1OXB1Y082OTkxbllPK2FF?=
 =?utf-8?B?NzJBTVN0WU1GNk42WTVFZ0YzYmRZcWQ3TDhkMW9rMURqUkQ2K0pFNXA3Y2RU?=
 =?utf-8?B?T0trbFo0clFYNWIxTGUwbEhGVHRScUZyYnJOdThyRkVFYlBXTld1VEhPUDRx?=
 =?utf-8?B?VVRiTE5JZ1h5VEFHc3VIb2c3dmVPMld3dHpFMU14WUNPMkYyZGZFamJqbGlH?=
 =?utf-8?B?UXJ1YURzVmFCbHpOVzNrMm1FQTZBSE5IMXdKdWp0Wjl6azVNNDhDZFFnZTZI?=
 =?utf-8?B?ekp1czg0bFR2MitGdTl6VGY0aWFuTVlKaGJBeEJEV3NPWkhsVHRlcXA2eU02?=
 =?utf-8?B?Sy9MSFc2VERsb0gxSEhUSndmTC85UWRHc0I2SE40SXoxNkM5UGNiclkxRWhS?=
 =?utf-8?B?ZTd0SjhDWDVsOTJuQnFORURlQnZJNTdCcE8xbkZGVG9GZWRQVFl5UHhQZjJ0?=
 =?utf-8?B?d1pGTnBFRE94Q3hXcHFWREpnM1phL0t4MWhCMVBUWks4V1pLakFMckxHZnhF?=
 =?utf-8?B?SlhldzBseEF5N3VLcG4vSEJMbWNCYmZwUGNZd1dLZUZEQjVpNHJ0amk4TCtY?=
 =?utf-8?B?QXZwNjBjMXJTVEhOQ2IyT0RaNzNKa29pcndiTDVjbnpNZ1JNcng5WEpYV0Nt?=
 =?utf-8?B?anBsK1RYWitVWG1VWUxSQ3BhMEhQQUZ1eUpBdmthbldWbmdmS2FCci9INWxH?=
 =?utf-8?B?WkhtUDNSa3pQRUZkR3B3ak5RSkFZOU9xNmVndUJNVzQvTjd0RU9wNGNNNHhO?=
 =?utf-8?B?ckRLbzZ1RWRTRVhrQ091aU5DeXA3MG84M3kzYjVOYmlJdEdDdkRHRVpDODZP?=
 =?utf-8?B?SmhYekRaVkl2U2ttVXVUZm9kSExjeUtReVZsZXZhamt0WHd3cEFkNE1Jbzg3?=
 =?utf-8?B?SjlVVS84aS9jcUh2Y0owOEg1MGpMT09yUEpSWTF4Y3U0bytmRXlnamhvTDVQ?=
 =?utf-8?B?UHRmWXNBRTZlRm5reEsrSFZwd1F2cFVMQ2J6TkllR3R3eUJyVng2VllnSW15?=
 =?utf-8?B?UjBTSmdoR1JvU0hwZVU3MVk3MEVoelMwaDBtL2NhRWFzSkxKbnFmeXh2eElX?=
 =?utf-8?B?ZGNZQ0Y1djJrYXZFczZyTzA2ZXYzWnVOT2NvQldYbzJIZkhlNk9rVzJLRUNL?=
 =?utf-8?B?TGpXWDk3d1kyblRZNHVBVmF1dWc3VTM0SEhmY0NLTTJkWWRvK2V4ZWNaZVNa?=
 =?utf-8?B?bGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0846B22B526F8647A5D73E5F33D0EDEC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19c80d74-56ce-49d8-2be2-08daf3631f3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 23:33:47.7670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dNQx+ac8n/hJCPNHvVSxHV6rGedCE9uH8lj52n4vdd3rKG0TWj/VUufnOQXQ6HpSn+H/FE+bH/zXmkdXwKXnjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5890
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAxLTEwIGF0IDA4OjI1IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMS8xMC8yMyAwMjo0OCwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+ID4gDQo+ID4gPiA+ICsg
ICAvKg0KPiA+ID4gPiArICAgICogVXNlIHRoZSBmaXJzdCBwcml2YXRlIEtleUlEIGFzIHRoZSBn
bG9iYWwgS2V5SUQsIGFuZCBwYXNzDQo+ID4gPiA+ICsgICAgKiBpdCBhbG9uZyB3aXRoIHRoZSBU
RE1ScyB0byB0aGUgVERYIG1vZHVsZS4NCj4gPiA+ID4gKyAgICAqLw0KPiA+ID4gPiArICAgcmV0
ID0gY29uZmlnX3RkeF9tb2R1bGUoJnRkbXJfbGlzdCwgdGR4X2tleWlkX3N0YXJ0KTsNCj4gPiA+
ID4gKyAgIGlmIChyZXQpDQo+ID4gPiA+ICsgICAgICAgICAgIGdvdG8gb3V0X2ZyZWVfcGFtdHM7
DQo+ID4gPiBUaGlzIGlzICJjb25zdW1pbmciIHRkeF9rZXlpZF9zdGFydC4gIERvZXMgaXQgbmVl
ZCB0byBnZXQgaW5jcmVtZW50ZWQNCj4gPiA+IHNpbmNlIHRoZSBmaXJzdCBndWVzdCBjYW4ndCB1
c2UgdGhpcyBLZXlJRCBub3c/DQo+ID4gDQo+ID4gSXQgZGVwZW5kcyBvbiBob3cgd2UgdHJlYXQg
J3RkeF9rZXlpZF9zdGFydCcuICBJZiBpdCBtZWFucyB0aGUgZmlyc3QgX3VzYWJsZV8NCj4gPiBL
ZXlJRCBmb3IgS1ZNLCB0aGVuIHdlIHNob3VsZCBpbmNyZWFzZSBpdDsgYnV0IGlmIGl0IG9ubHkg
dXNlZCBmb3IgdGhlIGhhcmR3YXJlLQ0KPiA+IGVuYWJsZWQgVERYIEtleUlEIHJhbmdlLCB0aGVu
IHdlIGRvbid0IG5lZWQgdG8gaW5jcmVhc2UgaXQuDQo+ID4gDQo+ID4gQ3VycmVudGx5IGl0IGlz
IG1hcmtlZCBhcyBfX3JvX2FmdGVyX2luaXQgc28gbXkgaW50ZW50aW9uIGlzIHRoZSBsYXR0ZXIg
KGFsc28gaW4NCj4gPiB0aGUgc3Bpcml0IG9mIGtlZXBpbmcgdGhpcyBzZXJpZXMgbWluaW1hbCku
DQo+ID4gDQo+ID4gRXZlbnR1YWxseSB3ZSB3aWxsIG5lZWQgdG8gaGF2ZSBmdW5jdGlvbnMgdG8g
YWxsb2NhdGUvZnJlZSBURFggS2V5SURzIGFueXdheSBmb3INCj4gPiBLVk0sIGJ1dCBpbiB0aGF0
IHdlIGNhbiBqdXN0IHRyZWF0ICd0ZHhfa2V5aWRfc3RhcnQgKyAxJyBhcyB0aGUgZmlyc3QgdXNh
YmxlDQo+ID4gS2V5SUQuDQo+IA0KPiBTbywgYmFzaWNhbGx5LCB5b3UncmUgZ29pbmcgdG8gZGVw
ZW5kIG9uIHRoZSBLVk0gY29kZSAod2hpY2ggaXNuJ3QgaW4NCj4gdGhpcyBzZXJpZXMpIHRvIG1h
Z2ljYWxseSBrbm93IGV4YWN0bHkgd2hhdCB0aGlzIHNlcmllcyBkaWQ/ICBUaGVuLA0KPiB5b3Un
cmUgZXhwZWN0aW5nIHRoYXQgdGhpcyBjb2RlIHdpbGwgbmV2ZXIgY2hhbmdlIGluIGEgd2F5IHRo
YXQgYnJlYWtzDQo+IHRoaXMgcmFuZG9tIEtWTSBjb2RlPw0KPiANCj4gVGhhdCdzIGZyYW5rbHkg
YXdmdWwuDQoNClNvcnJ5IEkgc2hvdWxkIGhhdmUgc2FpZCB0aGlzIGluIG15IHByZXZpb3VzIHJl
cGx5OiAgVGhlIHR3byBmdW5jdGlvbnMgd2lsbCBiZQ0KaW1wbGVtZW50ZWQgaW4gaGVyZSB0b2dl
dGhlciB3aXRoICd0ZHhfa2V5aWRfc3RhcnQnIGFuZCAnbnJfdGR4X2tleWlkcycNCnZhcmlhYmxl
cywgc28gdGhleSBhcmUgbm90IEtWTSBjb2RlLCBhbHRob3VnaCB0aGV5IHdpbGwgb25seSBiZSB1
c2VkIGJ5IEtWTSBmb3INCm5vdzoNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9ZMTlO
emxRY3doViUyRjJ3bDNAZGViaWFuLm1lL1QvI20wNzM1ZGU5ZTYwMTM4ZGE4ZmE2OTgyOGI3NTVm
MTM4N2UwMzFkMDhkDQoNCkFub3RoZXIgYmVuZWZpdCBvZiBwdXR0aW5nIGhlcmUgKG5vdCBpbiBL
Vk0pIGlzIGp1c3QgaW4gY2FzZSBpbiB0aGUgZnV0dXJlIG90aGVyDQprZXJuZWwgY29tcG9uZW50
cyBtaWdodCBuZWVkIHRvIGFsbG9jYXRlIFREWCBLZXlJRCB0b28uDQoNCkJ0dyB0aGlzIHNlcmll
cyBpdHNlbGYgaXMgbm90IGVub3VnaCBmb3IgS1ZNIHRvIHN1cHBvcnQgVERYLiAgVGhlcmUgd2ls
bCBiZSBzb21lDQptaW5vciB4ODYgcGF0Y2hlcyBiYXNlZCBvbiB0aGlzIHNlcmllcyBmb3IgdGhh
dCAoZXhwb3NpbmcgdGRzeXNpbmZvX3N0cnVjdCB0bw0KS1ZNLCBhbmQgdGhpcyBLZXlJRCBhbGxv
Y2F0aW9uLCBldGMpLiANCg0KKE9yIHNob3VsZCBJIGp1c3QgaW5jbHVkZSB0aGVtIGluIHRoaXMg
c2VyaWVzPykNCg0KPiANCj4gTWFrZSB0aGUgdmFyaWFibGUgcmVhZC93cml0ZS4gIENhbGwgaXQg
dGR4X2d1ZXN0X2tleWlkX3N0YXJ0LCBhbmQNCj4gaW5jcmVtZW50IGl0IHdoZW4geW91IG1ha2Ug
YSBrZXlpZCB1bmF2YWlsYWJsZSBmb3IgZ3Vlc3QgdXNlLg0KPiANCg0KWWVzIEkgY2FuIGRvIGlm
IHlvdSBwcmVmZXIuDQoNCk9uZSBtaW5vciB0aGluZyBpcyAndGR4X2tleWlkX3N0YXJ0JyBpcyBp
bnRyb2R1Y2VkIGluIHRoZSBzZWNvbmQgcGF0Y2ggaW4gdGhpcw0Kc2VyaWVzICgieDg2L3ZpcnQv
dGR4OiBEZXRlY3QgVERYIGR1cmluZyBrZXJuZWwgYm9vdCIpLiAgSU1ITyBpdCB3b3VsZCBiZSBh
DQpsaXR0bGUgd2VpcmQgdG8gY2FsbCBpdCAndGR4X2d1ZXN0X2tleWlkX3N0YXJ0JyBpbiB0aGF0
IHBhdGNoLg0K
