Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7146BAC7E
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 10:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbjCOJsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 05:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjCOJrx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 05:47:53 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C7725E37;
        Wed, 15 Mar 2023 02:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678873617; x=1710409617;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Cwl0mY8WmILENga07vjabl8btFhUU/xjyMN13sZklWg=;
  b=kgTTtM3eLsVYxWQGUJhWakk3fFYKeVpQaK5Wlg3BqQnSsoO2D3SqDLt8
   I1G94G2yeVN9LnJg7cxBVxETSLVU8uopnt8Dn9ceUjMXEz9M9lbh4j9Nt
   p6hpEQ1XYKyRJS3u/a9q5GZKJ7O0NNbOQ7IlWQjecoLlmmjLwbNVn6/1U
   QgYLTpNr6aG1tfcMUgduBl8bJmAAqP6PdPztqUwIICudSclooXBpQ13tL
   GO0Uokrm9SufOLvkoe0mOGcditRU1bX+hIp1ihKhfd2puVznhJ1pF9I/k
   zYgytdp4lgYk4QCqcH1vXVNsAv6yBk7h6Kf7O8RM4a3YDicSgG1PXjsoG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="339199999"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="339199999"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 02:46:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="672672567"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="672672567"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 15 Mar 2023 02:46:03 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 02:46:03 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 02:46:03 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 02:46:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdb90H1ewaARJEApsh0j8m2iq1Xdo+RCng5leTHkJS1KcTuRkVSR80x/Aiycd04F+SklJRJ+7HOCQyMX1PpS3s6To1X28Py8chtUuA5d0TKmieSAbk/SuAeMZKoqujyvhFINcyykyQ/jp2GMd5QPsUCDvtf+Jb8zTkxk8ygS1x5o5hJACGbYsBw9jhrLje/QyGJhJDx7d+jNA1ZzB6qGxzgGpHPIur7Vtmhno+/85TLKOJeCb9IuXPnBJGilu/IPMjOdWxB/L96IwV0N/AgNMD2ba7iOfUQdpVuIBRePVfs/L/afs8BHHeTA26ASQDAGP1F6EhGcAP5yieR6wShzIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cwl0mY8WmILENga07vjabl8btFhUU/xjyMN13sZklWg=;
 b=E8p45UjKCGf12G+ZVCZr3AnTbo+RG8aapDBOZQlIhpmvuyHHdHBqBVZ5esu6UEz82MrgdZuKQJw2IVAzRp4Neiya0ohpnVfX2qt2ZhVx+IgnV6FAf1luh+WPE3SiDvkH5HaTZ9sJthjgpvHQ7fyIHNhgwREgf/0QhwmZf7KNhb26R3hUVflbcBl0c/lkdBRdcDBpgPj9BGUWHZP3eUUvNhQ2EzFEVwdUrtyfNMy2+XLk+GLdyKCln5y35fot4rhsaDM9hwvHkD5XL2t4ngEguZCR9ZxyB3Onj33M8YqTLDN+ninFOnCmCa/fNTEB9xEO3fCOETmsUCh76DCmQe6PXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB5186.namprd11.prod.outlook.com (2603:10b6:303:9b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 09:46:00 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 09:46:00 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v13 003/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v13 003/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHZVQwsPOGReWj5Uka2uRq42SaKMa75keeAgAHjHYCAACbFgA==
Date:   Wed, 15 Mar 2023 09:46:00 +0000
Message-ID: <8ee89a1376babf0a5dbc2feb614890b7e2ccf2f8.camel@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
         <44f7fe9f235e29f2193eaac5890a4dede22c324c.1678643052.git.isaku.yamahata@intel.com>
         <20ebae70fd625f8a0fe87f98c25613a2d4dc5792.camel@intel.com>
         <20230315072711.GF3922605@ls.amr.corp.intel.com>
In-Reply-To: <20230315072711.GF3922605@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB5186:EE_
x-ms-office365-filtering-correlation-id: 57739521-b8d2-4b7f-7549-08db253a157b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cyPlhdYynoqdXvW8+NsrPuDqXuU/73iaCF/yAoBxd88SaLpoVq4o61ThVuiedi0Nrce8DAkJC78c0/xkmkOusJ8PeNAwDRo9ZJnxl9sYvXCbmw6vDcmatZNo28v7T6b5fcZsUisHOPXXcHgiOd8YSY9wR1s6WYQsuxREJ4t/axUlgHs/joirg0L4r2UHmN3s8RYIK/3B3kbHRIGQY9LIwUi7Z+WTEQfqXnV47UHrCGOcuqbw4c8hRltxI5OB5/iJfL/X0RRHpoKXbswDIGxJ/IL9KKagKtucCG6tRSXyRlmrPHpYKw/gMRv+rkWK9ueQdOsfCh0FGy8eVnHYC7MsRol6uI98OLxle6iwiDRho85+yV5tnT3EaJZHoKzL/6UB25QIOrPHa61GIlaml79eCbcABgF8nJOBID/G0xoO5f5p8bmjcZCf+458CZN/QbxekceVZsEct7LrJ42/e1hhqGAXtMX3PIVvf0JUPi0sHEm0UsddYRQooQDABhtjL62QkQnTxBItvjTRz33M/E9nbvjo4nSKxy2Op46cDKiIuYB3zPTzR/RR7p8VaRK00OANcw8SaVbVTL6A5iPQ6sOtPjwjHpLvAg583ttN+uPAoKC43UnmMcYdjByDrz8ZIMeRzrw4OAVdn0lredwLp/p/6S0D+t3pHrVPWelgycelFwYeoXt7Brg45Asovou6fkBactik6il96tS0Vl9H4Dq9jg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(346002)(376002)(136003)(366004)(451199018)(4326008)(8676002)(66556008)(66476007)(66946007)(76116006)(6916009)(41300700001)(91956017)(5660300002)(8936002)(64756008)(66446008)(316002)(38100700002)(122000001)(54906003)(82960400001)(38070700005)(83380400001)(478600001)(6486002)(186003)(71200400001)(26005)(36756003)(86362001)(2616005)(107886003)(2906002)(6512007)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGFUTHAyREpMRWFjV044REVEdUg3aW5XWkxvTm9TN3RBWUdaNXpkK21VSSth?=
 =?utf-8?B?eVcwbFUrK0h0bFBBQWtBY0xRRjJ3ME96N08zRVpNa1U4N3NSeU82bC9ubjNw?=
 =?utf-8?B?QWZTenhaTDB5QThKSW5CYXArOXRGTXdnZkZIWUdHQXB4RGhqamtvODNJc3J0?=
 =?utf-8?B?TUpEdjB3Vnh4Njhzb2pxblhZUzZEWDNwdVIrSXdMbVk4S0ZOQVNwaSs4QlBW?=
 =?utf-8?B?TXNUQjZxVjlMVDVkeUNyVFFsbW1KeGNUbkVBam9VdVMyMGJqYmpRZms1dXFL?=
 =?utf-8?B?TGRqWitqaytTKzBzZk1vcEtsRi8zM2RIeG8xRytSVzNuMS9rajhXSHR5WGhE?=
 =?utf-8?B?NXRzU0J6NkxWbitBUUtzdlQraU5LZlVMYWtZWmdqTTFtRjdmMUVlRTVFdVVu?=
 =?utf-8?B?RFFMQkxYSEFMcjA0ZS9NcHdLKzYrQmI4OUxUS2V4VUtESWhSdDBEcFA1VnBR?=
 =?utf-8?B?bExBaHBLQ3lPdkNQZXVlMm14Q2lWZTZTTHFIQ2FzUUZYd2gveUZ4MTN5Zmx3?=
 =?utf-8?B?WWNhVExKdkFaZ0xZZ1BtMDk3UWlxTm56dkVOZWVvK21mcGNMNmxFeU1rTDFu?=
 =?utf-8?B?c3NIZS9XR1lNeDhkOFM0NHE4Sis3NzVxVmxIcG1JWnl6amx4bWwvTTVHaFdG?=
 =?utf-8?B?cEM2WmJ5bHZXdVRQTXJkTnZZZi9jeC8zd0tDeFlZTHlLV3pwZnVrQTJXRHh1?=
 =?utf-8?B?Mi9EdnRlSUFaY01VUXJMSHFHNk5UK1BKam5lOFJ0VFhZeTF1SVpDcXZtRWxq?=
 =?utf-8?B?Y0czL2xVUXJjWDc4NXk0K0RTNWZ2dGwwbTdGNGdZRHVDdDNSRU5lMkV4TSsr?=
 =?utf-8?B?U1BDSU51VTFFUk0xczB5WUZGTWZ3L2dqZ1dKWkdnZHRJMUxkZHVPWmlNV2ha?=
 =?utf-8?B?TXo5STA3dmpZY2laNWFmTzdxckc0Tk5BaDJUT3ZSOEJnTUMzZEFwckR3Rlg2?=
 =?utf-8?B?UW82SSt2c2VxQldCT01CTlkvL0ZtMW1Kc3NZbnk2MFF1ZDZoczViMVRpd0h4?=
 =?utf-8?B?UnB5ckVGeGEyVldNS3k1WkVrODZ4blJ3RkhLRUp3MmxpYzBkRHFxNUJYUkdL?=
 =?utf-8?B?WjR6OUhRUEVrRlVacTJQMkVjZVRObmREVUJkeDJST0tmUE9McGJlQ1B5M1ZW?=
 =?utf-8?B?WTRwV2JaSHUvME5SZ1FvditqQ2lXZEl1U3JnbE1yczBvVXBERXJucTQ0bmNj?=
 =?utf-8?B?THl4ZDRzdExDMU1DOFVxRE1UMHBLaEEzVTAzSWpLMnB1cEwvaUlkOUNzMHhS?=
 =?utf-8?B?djFUaDR6eW8xRnJpS3lBdExoYWZISDJFa3dvaW4xWVFwWW9ON3RJK2VlT0JL?=
 =?utf-8?B?bXZpd0svTDBPRjF6cTlPeHNuaW5sdEVISndDUEV3L2srei9aLzU5Vzk2dWRF?=
 =?utf-8?B?UGUwMXg1UitRdkJ5bVBXbm1ybmVMbXFUcTZEbUVud3orclRiZWlyY1dkWWxO?=
 =?utf-8?B?SnAvTGJFNjJ6QU1Yc3NIWGtYRlJXbU83amlsTVBKSy9VTndTaVZGS2Y0Umxw?=
 =?utf-8?B?Ulg5RHIyQTVJYUZOK3pUK3VMSy9YaTQyOVVnSENsQVJkcU1lcERVVGpJRFhm?=
 =?utf-8?B?aGxQQXREejN2TVc3NjNxdkdKVEZ6endZdXlnZHBJeEk1aDI2Nk9majVsYldy?=
 =?utf-8?B?TUtaZHlFTmdGK041UnRJQzh6RFltd2Nnb1dLblozQVZ2YmN5YUMxMXF2WThl?=
 =?utf-8?B?d2dSQlVZRUhEdk5pQ0ZndVNQelF5Qk4rRmJ6MlhCUzBrelNkQWJkdGlzd3o4?=
 =?utf-8?B?NUxQUW9pb2QweHBHa1oxY2ExQ2hvSDhKMExjWUh0OW5nMzJ3OVl0VVIyRlNk?=
 =?utf-8?B?ZUR1TFNPd21GVXIxRnlrTU45clVhMWVIVGRVZkVPcUd2WUJLNUhvekVZRXVR?=
 =?utf-8?B?Q08wd1BrUHpCbDRTLzhsR1A1Q2RxS1N5VkNNOCthUlZ0WkE0emFXc0FaNEtj?=
 =?utf-8?B?a29aYy8zU2ZMeEJON3IzRnAxYzRtcGVBbWNOTkgvM0k2VTV3cWpncU5ZVzhS?=
 =?utf-8?B?T2tNNWJKbXA5L01Rd2JVT2JLQ0hCMGx1NmpLU0psTjVxS1FCNm9zVURsc1dC?=
 =?utf-8?B?YmwxcHc1UWJFaVUwYjFMWWVrcGhhck82VlpLc1l6eGdTR2Q3M1ZqVW80QlhY?=
 =?utf-8?B?UW5SdDJpSVdJQjcxR2VYNGVsNkRwZFhOZDBNV0svNnpFTDVheUpLQUpnbGVK?=
 =?utf-8?B?SHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <98454FF1A2BE1349ABA6B8CE11507F21@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57739521-b8d2-4b7f-7549-08db253a157b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 09:46:00.1644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YjjPAggOIhik0Er0a8LdZYFyHM5x5gjUG044TCFZFCpj3vym3wZMbkQLj9Tn7tNJJX6DcYYKrGFehy59uFCErA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5186
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ID4gDQo+ID4gSSB0aGluayB5b3Ugc2hvdWxkIHVzZSBoYXJkd2FyZV9lbmFibGVfYWxsKCks
IGFuZCBqdXN0IGRvIHNvbWV0aGluZyBzaW1pbGFyIHRvDQo+ID4gYmVsb3cgaW4gdm14X2hhcmR3
YXJlX2VuYWJsZSgpOg0KPiANCj4gVGhlIHVzZSBvZiBoYXJkd2FyZV9lbmFibGVfYWxsKCkgbWFr
ZSB1cyBjaXJjbGUgYmFjayB0byByZWZhY3RvcmluZyBLVk0NCj4gaGFyZHdhcmUgaW5pdGlhbGl6
YXRpb24gdG9waWMuICBJJ2QgbGlrZSB0byBzdGF5IGF3YXkgZnJvbSBpdCBmb3Igbm93IGZvciBU
RFguDQoNClNlYW4ncyBzZXJpZXMgdG8gaW1wcm92ZSBoYXJkd2FyZSBlbmFibGUgaGFzIGJlZW4g
bWVyZ2VkIHRvIHVwc3RyZWFtIGFscmVhZHkuICANCg0KQ2FuIHlvdSBlbGFib3JhdGUgd2hhdCdz
IHRoZSBpc3N1ZSBoZXJlPw0KDQpbLi4uXQ0KDQo+ICtzdGF0aWMgYm9vbCBlbmFibGVfdGR4IF9f
cm9fYWZ0ZXJfaW5pdDsNCj4gK21vZHVsZV9wYXJhbV9uYW1lZCh0ZHgsIGVuYWJsZV90ZHgsIGJv
b2wsIDA0NDQpOw0KPiArDQo+ICtzdGF0aWMgX19pbml0IGludCB2dF9oYXJkd2FyZV9zZXR1cCh2
b2lkKQ0KPiArew0KPiArCWludCByZXQ7DQo+ICsNCj4gKwlyZXQgPSB2bXhfaGFyZHdhcmVfc2V0
dXAoKTsNCj4gKwlpZiAocmV0KQ0KPiArCQlyZXR1cm4gcmV0Ow0KPiArDQo+ICsJZW5hYmxlX3Rk
eCA9IGVuYWJsZV90ZHggJiYgIXRkeF9oYXJkd2FyZV9zZXR1cCgmdnRfeDg2X29wcyk7DQoNClVu
Zm9ydHVuYXRlbHksIHRoZSBlbmFibGVfdGR4IHNob3VsZCBhbHNvIGJlIHByb3RlY3RlZCBieSB0
aGUgY3B1c19yZWFkX2xvY2soKSwNCmJlY2F1c2UgQ1BVIGhvdHBsdWcgY29kZSBwYXRoIGNoZWNr
cyBpdCB0b28gKGFzIHNlZW4gaW4geW91ciBuZXh0IHBhdGNoKS4NCg0KPiArDQo+ICsJcmV0dXJu
IDA7DQo+ICt9DQo+ICsNCj4gICNkZWZpbmUgVk1YX1JFUVVJUkVEX0FQSUNWX0lOSElCSVRTCQkg
ICAgICAgXA0KPiAgKAkJCQkJCSAgICAgICBcDQo+ICAgICAgICAgQklUKEFQSUNWX0lOSElCSVRf
UkVBU09OX0RJU0FCTEUpfAkgICAgICAgXA0KPiBAQCAtMTU5LDcgKzE3NSw3IEBAIHN0cnVjdCBr
dm1feDg2X29wcyB2dF94ODZfb3BzIF9faW5pdGRhdGEgPSB7DQo+ICB9Ow0KPiAgDQo+ICBzdHJ1
Y3Qga3ZtX3g4Nl9pbml0X29wcyB2dF9pbml0X29wcyBfX2luaXRkYXRhID0gew0KPiAtCS5oYXJk
d2FyZV9zZXR1cCA9IHZteF9oYXJkd2FyZV9zZXR1cCwNCj4gKwkuaGFyZHdhcmVfc2V0dXAgPSB2
dF9oYXJkd2FyZV9zZXR1cCwNCj4gIAkuaGFuZGxlX2ludGVsX3B0X2ludHIgPSBOVUxMLA0KPiAg
DQo+ICAJLnJ1bnRpbWVfb3BzID0gJnZ0X3g4Nl9vcHMsDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9rdm0vdm14L3RkeC5jIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiBuZXcgZmlsZSBtb2Rl
IDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwMDAwMDAuLjhkMjY1ZDdhZTZmYg0KPiAtLS0gL2Rldi9u
dWxsDQo+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gQEAgLTAsMCArMSw3NCBAQA0K
PiArLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjANCj4gKyNpbmNsdWRlIDxsaW51
eC9jcHUuaD4NCj4gKw0KPiArI2luY2x1ZGUgPGFzbS90ZHguaD4NCj4gKw0KPiArI2luY2x1ZGUg
ImNhcGFiaWxpdGllcy5oIg0KPiArI2luY2x1ZGUgIng4Nl9vcHMuaCINCj4gKyNpbmNsdWRlICJ4
ODYuaCINCj4gKw0KPiArI3VuZGVmIHByX2ZtdA0KPiArI2RlZmluZSBwcl9mbXQoZm10KSBLQlVJ
TERfTU9ETkFNRSAiOiAiIGZtdA0KPiArDQo+ICtzdGF0aWMgaW50IF9faW5pdCB0ZHhfbW9kdWxl
X3NldHVwKHZvaWQpDQo+ICt7DQo+ICsJaW50IHJldDsNCj4gKw0KPiArCXJldCA9IHRkeF9lbmFi
bGUoKTsNCj4gKwlpZiAocmV0KSB7DQo+ICsJCXByX2luZm8oIkZhaWxlZCB0byBpbml0aWFsaXpl
IFREWCBtb2R1bGUuXG4iKTsNCj4gKwkJcmV0dXJuIHJldDsNCj4gKwl9DQo+ICsNCj4gKwlwcl9p
bmZvKCJURFggaXMgc3VwcG9ydGVkLlxuIik7DQo+ICsJcmV0dXJuIDA7DQo+ICt9DQo+ICsNCj4g
K3N0YXRpYyBpbnQgX19pbml0IHRkeF9jcHVfZW5hYmxlX2NwdSh2b2lkICp1bnVzZWQpDQo+ICt7
DQo+ICsJaW50IHI7DQo+ICsNCj4gKwkvKg0KPiArCSAqIFREWCByZXF1aXJlcyBWTVguIEJlY2F1
c2UgdGhyZWFkIGNhbiBiZSBtaWdyYXRlZCwga2VlcCBWTVhPTiBvbg0KPiArCSAqIGFsbCBvbmxp
bmUgY3B1cyB1bnRpbCBhbGwgVERYIG1vZHVsZSBpbml0aWFsaXphdGlvbiBpcyBkb25lLg0KPiAr
CSAqLw0KDQpUaGUgc2Vjb25kIHNlbnRlbmNlIGluIHRoaXMgY29tbWVudCBzaG91bGQgYmUgc29t
ZXdoZXJlIGVsc2UsIGJ1dCBub3QgaGVyZS4NCg0KPiArCXIgPSB2bXhvbigpOw0KPiArCWlmIChy
KQ0KPiArCQlyZXR1cm4gcjsNCj4gKwlyZXR1cm4gdGR4X2NwdV9lbmFibGUoKTsNCj4gK30NCj4g
Kw0KPiArc3RhdGljIHZvaWQgX19pbml0IHRkeF92bXhvZmZfY3B1KHZvaWQgKnVudXNlZCkNCj4g
K3sNCj4gKwlXQVJOX09OX09OQ0UoY3B1X3ZteG9mZigpKTsNCj4gK30NCj4gKw0KPiAraW50IF9f
aW5pdCB0ZHhfaGFyZHdhcmVfc2V0dXAoc3RydWN0IGt2bV94ODZfb3BzICp4ODZfb3BzKQ0KPiAr
ew0KPiArCWludCBjcHU7DQo+ICsJaW50IHIgPSAwOw0KPiArDQo+ICsJaWYgKCFlbmFibGVfZXB0
KSB7DQo+ICsJCXByX3dhcm4oIkNhbm5vdCBlbmFibGUgVERYIHdpdGggRVBUIGRpc2FibGVkXG4i
KTsNCj4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ICsJfQ0KPiArDQo+ICsJLyogdGR4X2VuYWJsZSgp
IGluIHRkeF9tb2R1bGVfc2V0dXAoKSByZXF1aXJlcyBjcHVzIGxvY2suICovDQo+ICsJY3B1c19y
ZWFkX2xvY2soKTsNCj4gKwkvKg0KPiArCSAqIEJlY2F1c2UgdGR4X2NwdV9lbmFibGUoKSBhY3F1
aXJlcyBzcGluIGxvY2tzLCBvbl9lYWNoX2NwdSgpDQo+ICsJICogY2FuJ3QgYmUgdXNlZC4NCj4g
KwkgKi8NCg0KSGVyZSB5b3UgaGF2ZSBjcHVzX3JlYWRfbG9jaygpIHByb3RlY3Rpb24sIHNvIHRk
eF9jcHVfZW5hYmxlKCkgY2Fubm90IGJlIGNhbGxlZA0KZnJvbSBDUFUgaG90cGx1ZyBjb2RlIHBh
dGggd2hlbiB5b3UgYXJlIGRvaW5nIGhlcmUuDQoNClNvLCB1c2luZyBvbl9lYWNoX2NwdSgpIHRv
IGRvIHRkeF9jcHVfZW5hYmxlKCkgaXMgT0sgaGVyZSwgYmVjYXVzZSBvbiBvbmUNCnBhcnRpY3Vs
YXIgY3B1LCB3aGVuIGl0IGFscmVhZHkgaGFzIHRha2VuIHRoZSBzcGlubG9jaywgaXQgY2Fubm90
IHJlY2VpdmUgSVBJDQphbnltb3JlIHdoaWNoIGNhbiB0cnkgdG8gdGFrZSB0aGUgc3BpbmxvY2sg
YWdhaW4uDQoNCj4gKwlmb3JfZWFjaF9vbmxpbmVfY3B1KGNwdSkgew0KPiArCQlpZiAoc21wX2Nh
bGxfb25fY3B1KGNwdSwgdGR4X2NwdV9lbmFibGVfY3B1LCBOVUxMLCBmYWxzZSkpIHsNCj4gKwkJ
CXIgPSAtRUlPOw0KPiArCQkJYnJlYWs7DQo+ICsJCX0NCj4gKwl9DQo+ICsJaWYgKCFyKQ0KPiAr
CQlyID0gdGR4X21vZHVsZV9zZXR1cCgpOw0KPiArCW9uX2VhY2hfY3B1KHRkeF92bXhvZmZfY3B1
LCBOVUxMLCAxKTsNCj4gKwljcHVzX3JlYWRfdW5sb2NrKCk7DQo+ICsNCj4gKwlyZXR1cm4gcjsN
Cj4gK30NCg0KSSB0aGluayB5b3UgY2FuIG1lcmdlIG5leHQgcGF0Y2ggd2l0aCB0aGlzIG9uZSBi
ZWNhdXNlIHRoZXkgYXJlIGtpbmRhIHJlbGF0ZWQuIMKgDQoNClB1dHRpbmcgdGhlbSB0b2dldGhl
ciBhbGxvd3MgcGVvcGxlIHRvIHJldmlldyBtb3JlIGVhc2lseS4NCg==
