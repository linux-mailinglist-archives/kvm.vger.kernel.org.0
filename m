Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E574E901A
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 10:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239320AbiC1I2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 04:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239389AbiC1I2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 04:28:16 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33261BF5B;
        Mon, 28 Mar 2022 01:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648455996; x=1679991996;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rEO/Sq9QxxWIT7cv/z1lHYiDv7n8Z1wCayYYBSX03QM=;
  b=nu8GeB8qKEkhactFZO9026PSHiFJb00k9FlUf0aRmTKkSUFNM2+Om3vD
   Ptqzu01jsS4CFfJ/+ItuoyTb7JSTOKMQbt2BkM9jbNMDtUpHsjXeZl5zC
   2+z7f2/TlF8o074GAaWeLj5mlJ92PbJmbspo12Kv1PpfZRnWCyuOzOU1U
   BRLDnQ+wneuuPbHN9RDyT5vnnK/v6sQslPzlHq4N9tXx5febr0FyAVAgE
   BseQmTdTDqhyKd/62/3X29ABlfSO9HtYtl0It4M3A0fexsYV/0aAlnoIP
   kEYe27kNJcZ1YMZIa14b6v6awqK6iJrS3mOf5JIOS6fhi1d1H9iOsQYQj
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="345381644"
X-IronPort-AV: E=Sophos;i="5.90,216,1643702400"; 
   d="scan'208";a="345381644"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 01:26:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,216,1643702400"; 
   d="scan'208";a="651828374"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 28 Mar 2022 01:26:34 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 28 Mar 2022 01:26:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 28 Mar 2022 01:26:34 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Mon, 28 Mar 2022 01:26:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXyK9mR/s5F1JZcONrFemo1ONBk4f9EO73He8pFHxQo0nn6ms/WKL6k3Hkft9pieqFzzxy4uNr+lAP7GMiShsD1Y6scrihvQQXo4Cblpqa6FDns3e4zq1ZcO4d7amq/7NtwOyhxgCtzKWNpW5ZazXPl2oydYITFtk4pDkKtI70sf/QfzBrdPDK5ZmX5oHVZoX5fAszYecT0bjKMi+B65zXuMJpz4Mcgk24gYcfr2eG1dBo6n5lunnzr8L+uHu36mLlOTlZyMEHia+jlztpL8UZJ+CNpc4rNCCe6LvMzJ/asDihar5lYDVPosDbAnOrMIIWUPlFGUYAYlSTqLVMQ/CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rEO/Sq9QxxWIT7cv/z1lHYiDv7n8Z1wCayYYBSX03QM=;
 b=SH482ZSaiP6Tc9aBk/ksahmj7h3HinQ3yXZXKkj/aKvADFtHVAIbdmyxpVW5HiKdx91qJQlv9509Jlg+qsMm2zQFZul0Dn/9FM/ctuJgdxBf8McbtafJ4TQd79AKCHR/OtOnm4tnE2PolCZxfx2VuVCU7NUMYDEh9K3tuZbLoH3cXxw+JZELycHUn/mI9dXQYcIbyYZYtelEJVf5LxuXKjBl+zByE5IULxwTzf+SnUD/1OsKH9oN/y8bvHaUXTmlBLp53HsuRSjMm1XLIdV9LvEIRJ0ouFtLEVar+Kw6uJmWYkz/gFp04BOWQXbV8enSdTYnKPDBu/Db5t5+Etitgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB3194.namprd11.prod.outlook.com (2603:10b6:5:5c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Mon, 28 Mar
 2022 08:26:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0%4]) with mapi id 15.20.5102.022; Mon, 28 Mar 2022
 08:26:31 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gleixner, Thomas" <thomas.gleixner@intel.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: RE: [PATCH v2 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
Thread-Topic: [PATCH v2 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
Thread-Index: AQHYNsgzm2oe8d+tekOJ9ppfgUsWm6zMfiBAgAeiz4CAAGozsA==
Date:   Mon, 28 Mar 2022 08:26:31 +0000
Message-ID: <BN9PR11MB52760B743E208684A098B61C8C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1647167475.git.kai.huang@intel.com>
         <279af00f90a93491d5ec86672506146153909e5c.1647167475.git.kai.huang@intel.com>
         <BL1PR11MB52713CA82D52248B0905C91D8C189@BL1PR11MB5271.namprd11.prod.outlook.com>
 <a68b378a40310c38f731f4bc7f0a9cc0d89efe92.camel@intel.com>
In-Reply-To: <a68b378a40310c38f731f4bc7f0a9cc0d89efe92.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82ea691d-d4b1-41f4-9353-08da1094a98f
x-ms-traffictypediagnostic: DM6PR11MB3194:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <DM6PR11MB31941A46E74140BD87AD83FD8C1D9@DM6PR11MB3194.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6/RkCml37e0NibQWQqQPxFnGMsbAnA6FV/MKcxhBrRnyB/wGkke7O3RIn39uCnBbAb58pGat+wn3ar7lcT3W++QrbHwED6qtJ3HYS1ZiLkX+ySVZs17INZrCMTyJD2nysBdk5WI9tr7fqWgAvjj1ORFBWdKIH3PDpnpQyn2ViuyOnebQxjU9XyLRTOIN+6SDYyZL2Njs5cuktoQe8Ibh/G6KWCbqDS9XvAxeesFxgKLe8hSR5bJYbuWJAWyrp0tZEYIrarBcudCcXWIp8UKvTgdcNDbAkwc6pZXUczw98JdV4Ey/GVHh+CL9Z7iJbsY5v8xW7ETLssV9vqY0xQcAN5CzBXKrU7L3JFELVSVdj3Hnd1qwLBWAAbGs51Ilt8PIEjc5eyyp94woU3b6L9u0LuMkIUfehDKXWHGMsedc2xHseDGAWq37ox58AWeHc9giwukqxuafkFfjySorHxm9H3fRqaYovKQQb4EX7+IU1LlJhOCZEnd/I8bqXTsE+4bc1MZ+QM6VjtKMSXN/rXhbOWNIPr3BTyxzammCy3grUi1/435+8bOREaFJqAHMJW69eNDr4zI8wgX0Yv3HcRrRv+0p59YFLi1EYTHH1F9Bg2jOT/xwgtHRels2aLHNwdjFzcKBPsSm7ZI67cB49M94UxQ8hLPfxnUakrIYO70aPpx/iEOAxZ2hukNu8Y4Xyiic7Xg4kB5Hp5CT71bgRKmsQqzytO3lzYKTgqvz72nmReIRuk7yS5HY7bIcNzBQr7aJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(110136005)(6636002)(82960400001)(38100700002)(71200400001)(54906003)(83380400001)(55016003)(66556008)(76116006)(52536014)(8936002)(2906002)(5660300002)(316002)(38070700005)(66946007)(4326008)(64756008)(66446008)(66476007)(122000001)(86362001)(8676002)(7696005)(9686003)(6506007)(33656002)(186003)(508600001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGc3aTJNb0V5L2JjWERFWDJISVpyOWpmcmE3dEc3V01aYXRyalZjY25CM0Qr?=
 =?utf-8?B?anV0bUNLS3kxUjc3V2h1ZWkwTGRIbm9Sa3FQeDRiSFJMUGFKZHg1TzM3ZEEz?=
 =?utf-8?B?MnBobW1JN2ZaUFBWMFNUVUJhbFpoajVGMXMydXZuV2R6N2VJakhyY250elRp?=
 =?utf-8?B?aUpoTEtvRys2SmMrOWtISnNFMnlDTVJsWFU2QTFYV2FuZDZYZFpvc2xqS1F0?=
 =?utf-8?B?QUJOd255NUVpeGo2eCtRZk5pMmlLck9nSEZwcmZMZE45WTNKVjlXZVBtbmZy?=
 =?utf-8?B?R1pZK2o0OGF2T2NsOVhvK0JkdTduTnpBb3IyMEVrL2R4RjluTk81MHV5emYv?=
 =?utf-8?B?cGdmVE9kSmlCNUl4L1AyYmp2MXZjOUVaV1JmS1NvYS9rSXF3U1pmS1RzQXJX?=
 =?utf-8?B?ellmaWI3YVRIQ3MzMlJVeGsxUk9VbVRBOVBJRHFLSlEzR0JnUHZINEhHejY5?=
 =?utf-8?B?VEVXcC92K3FlK3htbzVWRXFYdDhFNW5QMHRyQWhSUGdtQjJpajRudFJsdmlE?=
 =?utf-8?B?MXpERDlYTlRaVUJCOXRCQmp6ZDBFeHpYVUE2Lzlpa1RjVXdnajE4ZXZDUUhp?=
 =?utf-8?B?ZmMyZW1VR0NzMVBHc0dDY1dQVTRqNmFkbysvUGhEVW91QmZNQzZvUS9Kci9y?=
 =?utf-8?B?dHZPV2pBRGhieXorTllPZmZtRWdsZDJmck9CcjFLV1g0QWQva2c1cnVrV1gy?=
 =?utf-8?B?Q2I4TTNFYm9qMEtmcjBzNWIyNnhvckhFMUhyOUZjREJrcHY1bU55SW5saDVT?=
 =?utf-8?B?YVNmcEIyV2lTbWhsMkxEYUFnQk9qZFJ0U1BNQXlWdkNrUGJXR0RzSzl1alVT?=
 =?utf-8?B?cjZ5WXJYVTVZMDFGNzgzREMxOFpEemVyaHMyTkV0TGVBZjV4amtFYmdmY0RL?=
 =?utf-8?B?TUhLYmpBb0VqVFN6bHpadVBvS1lCNVRYckxhYlpyV2dQOUg1ekdrZWRzMzNT?=
 =?utf-8?B?ZUR6ZVV6UmRqYkZtTFFoRlhqSVN4Qkdpa2YyUlBUNko2Nk9Ua2hHd3FpcklL?=
 =?utf-8?B?T1lHeURuRjFuRytDYW96ZWg4YWk2OTE4OXlyQlRicUJCTUdpa255WUtlVHJk?=
 =?utf-8?B?YjRXQkVHMXc4eDY2MmhmRE0xSDlYeHNxZUoyRENMQXRoOS94blBJYXJ0a3Zh?=
 =?utf-8?B?K05sRGNGL1BYdkUrUThCNTBlWk5WZ0QzYjNyNVJpZTVzNFpHZFlVOTRMTVFM?=
 =?utf-8?B?cVgyYTdJNkxaZDZhMW9GQ3N5eG9ZU0J0Z1FDejQ0VVF4RmlNYzl0aEtKNHZL?=
 =?utf-8?B?UXZtWnh4UTdEelhWT0VhSTFkSURFVm1UODd5dVU0NWJkR293cjhTcU1YMVZp?=
 =?utf-8?B?OXRzWmtvS0tObmY3ZDlQdXNnSWZQaFJ3NW5jRU0vWjJTeUZVV3orUHBXdE1j?=
 =?utf-8?B?aENNa0JJby9oZTFXMzVlVFFKU3JQNEJycEtReGdkQXU0M0JVSi9uUWRBWG9l?=
 =?utf-8?B?bjFGQ1d2cURBaXpsUlRpeXFMenBsekZSSW5mbWl6UzkyNHRHbnMvMmViUUdJ?=
 =?utf-8?B?MEVDU0VVMzJIMFVmU0tMS3hvd05aTVp5TTZXWE1FaDFQeVpOU0RLR2hCa2xs?=
 =?utf-8?B?Q09ZMElkQldaeHRML0pSbjh5UFlvK0pvdHV4VStQeUpqMXliQUxMejlpb01L?=
 =?utf-8?B?cEE2T1RsWEtwSWF0R2xvbHhKUHJ3Tk1nTnp6eCtzNzZsWllOd3F3ckFGU04r?=
 =?utf-8?B?U3E3VTdhZm5ReUJhWHhtWXNMcHhUL2lpQnlJcHBUM0MwbEk2QUdEdzNiVWVo?=
 =?utf-8?B?eGYxRXFsQmJ0Q0VtODBHMU83SzJBYXpucE0wUVo0My9vRU5vZFdwMk1QR3Jz?=
 =?utf-8?B?Zy83WFBqUHdCRVRQUjhZdWh6Z2tRTnh4aXA3WWxnY0NIR3BXcVl2KzdZbmdl?=
 =?utf-8?B?ZXJuYlRqTlR6Qmdia2FDL0QwM3JBb2R2L1M3Q1FzR29yRlRhNkFieUNnalB1?=
 =?utf-8?B?WGpndFplYUh2U0NaWXJzSTdlNlQ3U2QyeWJGZjV3VTJaSzNXMDV5QW95Q2ov?=
 =?utf-8?B?bUZ3VlUzb1B4VHByRUdpZkVYSXN3OVM5SHVrL2FMMmk2eGwzTi9ZUXZwZHEz?=
 =?utf-8?B?a1g4WU9hbjZhUEdiSXpiUk13dkwySW5aUDBFS2Y4cXZnd1lJSDZnUU03bGZY?=
 =?utf-8?B?OGN3dGx5dlI1T25oRVF0MEcvZThpOTlQZlhnQjB0WFRUVWJOakNxNUxxbGtm?=
 =?utf-8?B?aVQ4eUwwOFovQ29rRXZtRGRTTkVXbElxMVlDU0NqM1Uvejl3OW1Ta0svZnpV?=
 =?utf-8?B?QS8xeWJIWkhBM0ExV1NOa1lQaTlRbWZoOVE3cHAwRkpwU3FBdFFBVkYxRWNa?=
 =?utf-8?B?VVdId1RzamVhYWtpRXgyUWEzeTFvL1Jkd2x0aXQ3YVBzNGtBVis0UT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82ea691d-d4b1-41f4-9353-08da1094a98f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2022 08:26:31.0903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sTSEpI4FHlIFDDPvcDoaEkYKBxUSQ4FaGpmTiAgvSotkII/drHtFtxNEeJAnYFjiSiYYCEkAXloJj6zOa638Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3194
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

PiBGcm9tOiBIdWFuZywgS2FpIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiBTZW50OiBNb25kYXks
IE1hcmNoIDI4LCAyMDIyIDk6NTggQU0NCj4gDQo+IE9uIFdlZCwgMjAyMi0wMy0yMyBhdCAxOTo0
OSArMTMwMCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4gPiBGcm9tOiBLYWkgSHVhbmcgPGthaS5o
dWFuZ0BpbnRlbC5jb20+DQo+ID4gPiBTZW50OiBTdW5kYXksIE1hcmNoIDEzLCAyMDIyIDY6NTAg
UE0NCj4gPiA+ICtzdGF0aWMgYm9vbCBzZWFtcnJfZW5hYmxlZCh2b2lkKQ0KPiA+ID4gK3sNCj4g
PiA+ICsgICAgIC8qDQo+ID4gPiArICAgICAgKiBUbyBkZXRlY3QgYW55IEJJT1MgbWlzY29uZmln
dXJhdGlvbiBhbW9uZyBjb3JlcywgYWxsIGxvZ2ljYWwNCj4gPiA+ICsgICAgICAqIGNwdXMgbXVz
dCBoYXZlIGJlZW4gYnJvdWdodCB1cCBhdCBsZWFzdCBvbmNlLiAgVGhpcyBpcyB0cnVlDQo+ID4g
PiArICAgICAgKiB1bmxlc3MgJ21heGNwdXMnIGtlcm5lbCBjb21tYW5kIGxpbmUgaXMgdXNlZCB0
byBsaW1pdCB0aGUNCj4gPiA+ICsgICAgICAqIG51bWJlciBvZiBjcHVzIHRvIGJlIGJyb3VnaHQg
dXAgZHVyaW5nIGJvb3QgdGltZS4gIEhvd2V2ZXINCj4gPiA+ICsgICAgICAqICdtYXhjcHVzJyBp
cyBiYXNpY2FsbHkgYW4gaW52YWxpZCBvcGVyYXRpb24gbW9kZSBkdWUgdG8gdGhlDQo+ID4gPiAr
ICAgICAgKiBNQ0UgYnJvYWRjYXN0IHByb2JsZW0sIGFuZCBpdCBzaG91bGQgbm90IGJlIHVzZWQg
b24gYSBURFgNCj4gPiA+ICsgICAgICAqIGNhcGFibGUgbWFjaGluZS4gIEp1c3QgZG8gcGFyYW5v
aWQgY2hlY2sgaGVyZSBhbmQgV0FSTigpDQo+ID4gPiArICAgICAgKiBpZiBub3QgdGhlIGNhc2Uu
DQo+ID4gPiArICAgICAgKi8NCj4gPiA+ICsgICAgIGlmIChXQVJOX09OX09OQ0UoIWNwdW1hc2tf
ZXF1YWwoJmNwdXNfYm9vdGVkX29uY2VfbWFzaywNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgY3B1X3ByZXNlbnRfbWFzaykpKQ0KPiA+ID4gKyAgICAgICAgICAg
ICByZXR1cm4gZmFsc2U7DQo+ID4gPiArDQo+ID4NCj4gPiBjcHVfcHJlc2VudF9tYXNrIGRvZXNu
J3QgYWx3YXlzIHJlcHJlc2VudCBCSU9TLWVuYWJsZWQgQ1BVcyBhcyBpdA0KPiA+IGNhbiBiZSBm
dXJ0aGVyIHJlc3RyaWN0ZWQgYnkgJ25yX2NwdXMnIGFuZCAncG9zc2libGVfY3B1cycuIEZyb20g
dGhpcw0KPiA+IGFuZ2xlIGFib3ZlIGNoZWNrIGRvZXNuJ3QgY2FwdHVyZSBhbGwgbWlzY29uZmln
dXJlZCBib290IG9wdGlvbnMNCj4gPiB3aGljaCBpcyBpbmNvbXBhdGlibGUgd2l0aCBURFguIFRo
ZW4gaXMgc3VjaCBwYXJ0aWFsIGNoZWNrIHN0aWxsIHVzZWZ1bA0KPiA+IG9yIGJldHRlciB0byBq
dXN0IGRvY3VtZW50IHRob3NlIHJlc3RyaWN0aW9ucyBhbmQgbGV0IFREWCBtb2R1bGUNCj4gPiBj
YXB0dXJlIGFueSB2aW9sYXRpb24gbGF0ZXIgYXMgd2hhdCB5b3UgZXhwbGFpbmVkIGluIF9faW5p
dF90ZHgoKT8NCj4gPg0KPiA+IFRoYW5rcw0KPiA+IEtldmluDQo+IA0KPiBUaGUgcHVycG9zZSBv
ZiBjaGVja2luZyBjcHVzX2Jvb3RlZF9vbmNlX21hc2sgYWdhbmlzdA0KPiBjcHVfcHJlc2VudF9t
YXNrIGlzIE5PVCB0bw0KPiBjaGVjayB3aGV0aGVyIGFsbCBCSU9TLWVuYWJsZWQgQ1BVcyBhcmUg
YnJvdWdodCB1cCBhdCBsZWFzdCBvbmNlLiAgSW5zdGVhZCwNCj4gdGhlDQo+IHB1cnBvc2UgaXMg
dG8gY2hlY2sgd2hldGhlciBhbGwgY3B1cyB0aGF0IGtlcm5lbCBjYW4gdXNlIGFyZSBicm91Z2h0
IHVwIGF0DQo+IGxlYXN0DQo+IG9uY2UgKFREWC1jYXBhYmxlIG1hY2hpbmUgZG9lc24ndCBzdXBw
b3J0IEFDUEkgQ1BVIGhvdHBsdWcgYW5kIGFsbCBjcHVzDQo+IGFyZQ0KPiBtYXJrZWQgYXMgZW5h
YmxlZCBpbiBNQURUIHRhYmxlLCB0aGVyZWZvcmUgY3B1X3ByZXNlbnRfbWFzayBpcyB1c2VkDQo+
IGluc3RlYWQgb2YNCj4gY3B1X3Bvc3NpYmxlX21hc2spLiAgVGhpcyBpcyB1c2VkIHRvIG1ha2Ug
c3VyZSBTRUFNUlIgaGFzIGJlZW4gZGV0ZWN0ZWQNCj4gb24gYWxsDQo+IGNwdXMgdGhhdCBrZXJu
ZWwgY2FuIHVzZS4NCj4gDQo+IENoZWNraW5nIHdoZXRoZXIgImFsbCBCSU9TLWVuYWJsZWQgY3B1
cyBhcmUgdXAiIGlzIG5vdCBkb25lIGhlcmUgKG5laXRoZXIgaW4NCj4gdGhpcyBzZXJpZXMgYXMg
d2UgZGlzY3Vzc2VkIGl0IHNlZW1zIHRoZXJlJ3Mgbm8gYXBwcm9wcmlhdGUgdmFyaWFibGUgdG8N
Cj4gcmVwcmVzZW50IGl0KS4gIEFuZCB3ZSBqdXN0IGxldCBUREguU1lTLkNPTkZJRyB0byBmYWls
IGlmIFRESC5TWVMuTFAuSU5JVCBpcyBub3QNCj4gZG9uZSBvbiBhbGwgQklPUy1lbmFibGVkIENQ
VXMuDQo+IA0KDQpURFggcmVxdWlyZXMgYWxsIEJJT1MtZW5hYmxlZCBDUFVzIHRvIGV4ZWN1dGUg
Y2VydGFpbiBTRUFNQ0FMTHMgZm9yIFREWA0KaW5pdGlhbGl6YXRpb24uIA0KDQpjcHVfcHJlc2Vu
dF9tYXNrIGRvZXMgbm90IGFsd2F5cyByZXByZXNlbnQgQklPUy1lbmFibGVkIENQVXMgZHVlDQp0
byB0aG9zZSBib290IG9wdGlvbnMuIFRoZW4gd2h5IGRvIHdlIGNhcmUgd2hldGhlciBDUFVzIGlu
IHRoaXMgbWFzaw0KKGlmIG9ubHkgcmVwcmVzZW50aW5nIGEgc3Vic2V0IG9mIEJJT1MtZW5hYmxl
ZCBDUFVzKSBhcmUgYXQgbGVhc3QgYnJvdWdodA0KdXAgb25jZT8gSXQgd2lsbCBmYWlsIGF0IFRE
SC5TWVMuQ09ORklHIGFueXdheS4NCg0KYnR3IHlvdXIgY29tbWVudCBzYWlkIHRoYXQgJ21heGNw
dXMnIGlzIGJhc2ljYWxseSBhbiBpbnZhbGlkIG1vZGUNCmR1ZSB0byBNQ0UgYnJvYWRjYXNlIHBy
b2JsZW0uIEkgZGlkbid0IGZpbmQgYW55IGNvZGUgdG8gYmxvY2sgaXQgd2hlbg0KTUNFIGlzIGVu
YWJsZWQsIHRodXMgd29uZGVyIHRoZSByYXRpb25hbGUgYmVoaW5kIGFuZCB3aGV0aGVyIHRoYXQN
CnJhdGlvbmFsZSBjYW4gYmUgYnJvdWdodCB0byB0aGlzIHNlcmllcyAoaS5lLiBubyBjaGVjayBh
Z2FpbnN0IHRob3NlDQpjb25mbGljdGluZyBib290IG9wdGlvbnMgYW5kIGp1c3QgbGV0IFNFQU1D
QUxMIGl0c2VsZiB0byBkZXRlY3QgYW5kIGZhaWwpLg0KDQpAVGhvbWFzLCBhbnkgZ3VpZGFuY2Ug
aGVyZT8NCg0KVGhhbmtzDQpLZXZpbg0K
