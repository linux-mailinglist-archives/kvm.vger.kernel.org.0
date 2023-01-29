Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E93767FF60
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 14:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbjA2Ncp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 08:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2Nco (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 08:32:44 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B35C15546
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 05:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674999163; x=1706535163;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ej2bVpIh2eXHjRKuX637WkI6u/wx0Rgec00AFZxRNrc=;
  b=K1VnOthkMzyH3Gofyq3u3rTiujNi7MvOWqsR8zImO+/DXr0jbYWg8cY4
   cCy4/NdcsvLuR5+cQNxK84ex+hVuk7XbfEhPC+xFXVy/0kLQElxUEE1Xk
   5/THMjYDVuUeqzAvIAfdgnDnzZhkveXYimZj0919IHYgCWXsonoLsfLqC
   1jMc2QMSR3rpDEzNmO9X4l4cGPNq7OWRE5ppyKVpc6MaQH2a6jKJPVqDZ
   u8gLRJqKNitky54lCN3PnjpBa3MWpRqzICNW4yVEv0VuPe9HGP19oGdSv
   m6sAIhtCkU/0WBF7vGqimHF1Kz7MkG9BBSx34hwzyvCVS0za7OchMWYrQ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="307044601"
X-IronPort-AV: E=Sophos;i="5.97,256,1669104000"; 
   d="scan'208";a="307044601"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2023 05:32:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="613743252"
X-IronPort-AV: E=Sophos;i="5.97,256,1669104000"; 
   d="scan'208";a="613743252"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 29 Jan 2023 05:32:42 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 29 Jan 2023 05:32:42 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 29 Jan 2023 05:32:42 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 29 Jan 2023 05:32:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yrodtn4f/mKZ91EMluFYOqiYyqaA6/YKGkdkPVNdBWDYITkyklxr6CsgIuogaEgs79xLu0CyMu9ZxaLNdaQwiUQ/5wTLQOSQLdxrVaQ7xx4F2l95heOgiVsl8Y3JjgVEgbxNhAygw+1KR8vzF9ISrF9LUX2TXZsmG71qZtKK1M7pX5x15aAepnAf+AFGmHPoLM79GP2F0TSUtfKroQEF6fqrrszdk2KuGgq/iJW2mMX6nj0cOpz+xCy+xqNUcyoY30+vwKkSkqkZdLDSjD+b+rvoRn1LvmwNx30IHNMK8Wqay9hRL1D5NKIF1R3odHUS2IyBbkO+8egdWw3or8gm/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ej2bVpIh2eXHjRKuX637WkI6u/wx0Rgec00AFZxRNrc=;
 b=CKrx8e8FK0SHPgEDI1s6WYyKSQCKnwDd+DCjWdl0mcL9vnKNcXBACKcKbehKn1ztTT5wJrXozdeTD6+knoS3OIKHO76wwjPq3CrM1muznwMRso+9IELnfyY/Ca48aF1p1Jf4QoL1+bfIZ8Ok38JsMpupw8jUJav2jmm9IkectSvunytwgk/Y0D+6gPcOhmDOKeWfb7LUep4H3j1RYrCTVRhswwrMAZDtQnUmbdr1F5b3+14Xu9KIgTFiaKniI1/rHQ35lKtpNso21HKs72FL1DsbYov35ISsJLOhojo0JAj2AWtPpW8y1UyGCjlVMUwK1c21i/s5AscsR5ZynLonRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA0PR11MB4751.namprd11.prod.outlook.com (2603:10b6:806:73::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.30; Sun, 29 Jan
 2023 13:32:40 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6043.030; Sun, 29 Jan 2023
 13:32:40 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 02/13] vfio: Refine vfio file kAPIs
Thread-Topic: [PATCH 02/13] vfio: Refine vfio file kAPIs
Thread-Index: AQHZKnqV2uhk3jz+X0eyylG0hfkNaa6kP8aAgBE2gtA=
Date:   Sun, 29 Jan 2023 13:32:39 +0000
Message-ID: <DS0PR11MB7529CA3007F75231620940BCC3D29@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-3-yi.l.liu@intel.com>
 <97a22ba3-72d4-7e3a-1b6d-469d5816860d@redhat.com>
In-Reply-To: <97a22ba3-72d4-7e3a-1b6d-469d5816860d@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA0PR11MB4751:EE_
x-ms-office365-filtering-correlation-id: 8f086183-9f17-49ec-895c-08db01fd4ac1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TL/LRikJTS3PR6wUgBLiMR1Tb0b/Fy3UgvHw9wRniK9r4Z7iHYl66mkylAvLdMHaZ8BZh0nAgkJ9qpqkUKanoOFn8rVDm059A/TS2M4Pg4kl8T29jV7N05PpqAxDsKecjbziEz0cjMYZMZV+6nRNUHLPnW48YucuRykwG4DNpOQA5giMw2va8JBuhYapbRx8WiXXtJlM12fvAvxL8abDUoJ10FuknKAYADasBzcxAGUuPKjNvoFTdgW4IfGxR9vEmuvCmXZI8OKOz+lYETnK9mz+cGlcLO9NtPfMS4wGqjL6nKS43SpcCpxD7ZNRK/7Lunlsr+xrxyPRVvDR5kpLc1W0DhBgsT+8ogCI8p0C537/7ToEvdmq72VmHj7bnuYME81sGsZEvMrNqnpze8gs/pNJ0GJjLKo6gSIvhaRt3uvRxT+2auuuYce1f/SIwQD5S1uTYfKf3miC7LlEoCBZOzDWX35avqfemawVo4xNdibVjLj1m933Xxx7d+EMlBLfCqjTmZnpr0h40pGIlEKzF1M1DotTZTairnmztgKD0THHvzm48uiu6DawCUcdJj6utQ5X6coQGoTKk1IFfZXt7N4Rq3ink/DHgtZ8wh5orKy5RZAvMQyD+HSEaJnRppespCbd9UKdrOCVMIUuCxnElI7l1djtDbPF19j9faGsdrTQqoDjse2VFr67tghFD6LmPHM97glDDj783wLyjKGOZ0Kdvar0nJbhHIByPEn7RTw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(346002)(396003)(39850400004)(366004)(451199018)(52536014)(82960400001)(7416002)(6506007)(4744005)(186003)(9686003)(26005)(55016003)(33656002)(38070700005)(71200400001)(7696005)(478600001)(86362001)(2906002)(38100700002)(316002)(110136005)(54906003)(122000001)(5660300002)(66446008)(66946007)(66476007)(64756008)(41300700001)(66556008)(76116006)(4326008)(8676002)(8936002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WExaSnBFN1BUYjl0eW5qcGVneitQSUpPSSs0ZlAxVUJIb3dIckVKdWltR1hX?=
 =?utf-8?B?YllPZnREYmgzMTU3Z2NQdDIydzlnTUV5cDVad0EzU2owSm03Q0JCa09aaVJV?=
 =?utf-8?B?ME1zbW5aMWFNaUhwalZ1N3hYWmZadHhtK1dEUGR6NWZJaU8vVUpLZ0drck5T?=
 =?utf-8?B?aG5aSWdMODRJL1JVRjB1T0pzZ2xVaEJZTmxRUWtXV0k1bFJzRGJsTE1hNVFO?=
 =?utf-8?B?RU1QSUJIN0lLNTFwSVFSOFdMZklNd3MwdTBwS05xd2lnK3ZhRHpGSlFSSHVI?=
 =?utf-8?B?SGVEaUQ2eUYrTk9TTXdUT0lNakpSRkp5cld0OFg0dE1uaWtHaWhRY1Mwaitw?=
 =?utf-8?B?b0lxKzJlKy92WEtYWjhBZ3BqVWpmTXQzM29NVGZyR1dPZHVEdnVTUmRHaUZS?=
 =?utf-8?B?dnZjcUh6MWJzclVTakVaUFlzM0NCcXV0cnc1bjk4VURKVEZLK0JGTXptRHh0?=
 =?utf-8?B?S2RBYWVRdVdPRjZkcENITzdSc3RyZVpiVkZreTN1MlcrQjlOQXU4M3hROG1W?=
 =?utf-8?B?a1lQd3lJL0JBbFZUdFczcHd4dzJFMFZORjNSNVhGcy8vTUJzVjdBcjBNWUc3?=
 =?utf-8?B?ZUJvWUlob2ZpbG5VeDg4YzllVGFXaVZ0ZWhXY1RhclpsTTBZUW5IOWZyVnFl?=
 =?utf-8?B?MW9lc2VaVEN3S3F2bEtJUGMrVjRGRXRmSW1qZmRNd05yRk5IdklOblJRSEdq?=
 =?utf-8?B?NzAySklCTU10Z2tWT2dudTZabnZkelNRUkpSZVpXTU9lenUyamdHa1plNHd0?=
 =?utf-8?B?bzVodk50aWIzQ01udFk2MzdZaFhxNzBDUkNMRWVXcmZXY3VRbU0vaXQzUzJp?=
 =?utf-8?B?VzJJUnlqQjBkTEMraGxHZXlZZ3dCRWtUcVkxM0tmellocFlIQkFrMk1vT0hw?=
 =?utf-8?B?N0RNTTZqR3QzSHdwWFlKS0Ywdm5hc1JuTEFCelRCS3Zid3RRUVVBQWJWZHNk?=
 =?utf-8?B?YlJ1Q3J6Ynh1ZGxIZk9QR05rWkF2aVh6RDkyRWJ1dDUzMnhER3pSWFI0MlVO?=
 =?utf-8?B?VFBUMkVxdVRpRU9OMVd2RHJCMEtBZkJXbFl3b0tod2tzUHZVanJOSFJFOXJs?=
 =?utf-8?B?MXpLYkRpZ2t5OEs5T2NPRVJON2RLc1dYZ3ZhNDBrTjJic0k2OVp4UTNpOTRV?=
 =?utf-8?B?VWRtaFhUbU1JSW0rUnJnTVhUYml4NW8wd0VrNGs0dEZBVWR6czBnNVV0R3Ft?=
 =?utf-8?B?eXZ1dXNkT010LzI0eEplbzhqZndHNG1FWEJDQXJtMlovd01BRStGZXhNSGE5?=
 =?utf-8?B?TWZjTE1Vbmh5TUtIWGlxOEZaa2J6QXdjbkI4S0VYc0dBam1tUjdOV0VhQUZS?=
 =?utf-8?B?bkVwMTVDeldyL3EwYTlSOTUyeStKSDArL2t6MU1mSkdadlZmM3cwSHRsQy8r?=
 =?utf-8?B?MThtbkdLUDl5ZWU3ZnJIOU5RTldnVnl0TVJOTDdQVW0yeU53WXFmdnBUbjQ2?=
 =?utf-8?B?RCtWYmdZQzcrMDEyRi9HK0JoNXc0Y2pFRzVlVG1RNnpVK1NVQXpESS9kUnlw?=
 =?utf-8?B?NTY1Mlk4M0VzYzN2UThKdVVWZG1MMThNVXVHeU5ZMTRUVWh1SHFJcXVMR2pH?=
 =?utf-8?B?MW8zeVZIcGd6c3hqSGJmclVoMWJkNy9wa25xYmZkL3ArN3lrREdSLzVoMlR3?=
 =?utf-8?B?cEFrSU9pb1JpckoyV0xscW0wdFBaWEZZVENYV0dYYjJUUkpuRkdONG9OR2lP?=
 =?utf-8?B?eStOSE43cFYwL093bHhXV09Ec0Y4enoraElPUHFaS1dCM1ZzMmp1UDdKMkp4?=
 =?utf-8?B?TFluRC9DL09WRU1JTS9WT0NuYjZyZiswc1U3NjJ5bkM3RTkwRFkwT2ppaGdQ?=
 =?utf-8?B?MFZmelFWdEx4ZGRUSXVBZzZzYkk5TkUvSTBoL09weWJweG9EWDlLdmYvWlM5?=
 =?utf-8?B?bVFaR1RuQ25nWnB0RC8rS3ZPN2RrVmJ3MVozOFJGbnVpY3ErUXNnZDdXQkdU?=
 =?utf-8?B?STMzdjB4RkRkb0NQWnhwbDRJUnZhWUc5b0FIczU3MjJDUURjMDR6eDlXL0c4?=
 =?utf-8?B?UkNobENnM09IVHNhUUdTOXVKU2FSQkNSL0szS0tjWXNuMm5rVlg1V3J1eXB1?=
 =?utf-8?B?bU9mVFFhc0E4aHh2THhKVEZ0S0JtSkZ5Y1NYcUo3SmJFMUV1WWNUNXNpQTla?=
 =?utf-8?Q?RipYAgkvq37sjiMUlnze0MFJ/?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f086183-9f17-49ec-895c-08db01fd4ac1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2023 13:32:39.5295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L0h95b8h8cPugxHiNJz/wus6N4pHhiRfhSku5sdBzHTwT290Y2DOOMLCwqVqSP2ULWTtzoEPCfgqS3nySCX9HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4751
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFdlZG5lc2RheSwgSmFudWFyeSAxOCwgMjAyMyAxMDozNyBQTQ0KDQo+ID4gKy8qKg0K
PiA+ICsgKiB2ZmlvX2ZpbGVfaGFzX2RldiAtIFRydWUgaWYgdGhlIFZGSU8gZmlsZSBpcyBhIGhh
bmRsZSBmb3IgZGV2aWNlDQo+IFRoaXMgb3JpZ2luYWwgZGVzY3JpcHRpb24gc291bmRzIHdlaXJk
IGJlY2F1c2Ugb3JpZ2luYWxseSBpdCBhaW1lZA0KPiBhdCBmaWd1cmluZyB3aGV0aGVyIHRoZSBk
ZXZpY2UgYmVsb25nZWQgdG8gdGhhdCB2ZmlvIGdyb3VwIGZkLCBubz8NCj4gQW5kIHNpbmNlIGl0
IHdpbGwgaGFuZGxlIGJvdGggZ3JvdXAgZmQgYW5kIGRldmljZSBmZCBpdCBzdGlsbCBzb3VuZHMN
Cj4gd2VpcmQgdG8gbWUuDQoNClllcy4gSXQgaXMgdG8gY2hlY2sgaWYgYSBkZXZpY2UgYmVsb25n
cyB0byB0aGUgaW5wdXQgdmZpbyBncm91cCBzcGVjaWZpZWQNCmJ5IHRoZSBncm91cCBmZC4gQW5k
IGFmdGVyIHRoaXMgY29tbWl0LCBpdCBtZWFucyBpZiB0aGUgaW5wdXQgZmlsZSBpcw0KY29tcGV0
ZW50IHRvIGJlIGhhbmRsZSBmb3IgdGhlIGRldmljZSBlaXRoZXIgZHVlIHRvIGJlbG9uZyB0byBn
cm91cA0Kb3IgaXQgaXMganVzdCBhIGRldmljZSBmZCBmb3IgdGhlIGRldmljZS4gSSBkb27igJl0
IGhhdmUgYSBiZXR0ZXIgbmFtaW5nIHNvDQpmYXIuIEhvdyBhYm91dCB5b3U/DQoNClJlZ2FyZHMs
DQpZaSBMaXUNCg==
