Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A5378D945
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 20:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236721AbjH3Scn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 14:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242261AbjH3HoI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 03:44:08 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5622CD8;
        Wed, 30 Aug 2023 00:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693381445; x=1724917445;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WXXGbIf95MwX+NiLY1uXP0AXo0aKUx59s1i72kGAnQg=;
  b=lNkhfyBhM6cQ5fsxgcjNy+S7zmKVjoZQdQXvsjDC61wM9J+Z/doj/U32
   2Yvc1qM3Mu+W09Q6ly3r6rstpRFqtoPYHoQvItCtrZBzGQY8XNMgoGjxC
   /gH6tBhPmlVKb4r7lQeWVpcvvt6gHNq6eVoM1Hh1WANGu8ruu8eZAo/J6
   2+K4umoq5G0TKBG9vZYSN4JTq6dk4J/Yo122tR/uMmoTs8ruRXWmdfzvW
   24kS8ZFhFw0dI4t0W/z3L9VCgkTBcPGe25Oe0Kf/sxMYdK458w7w201b0
   UnR9XgC353I4RWfmDlpIBJTuLxLU1uIMid28/Xa6SeKEvThyVa2t+2mDG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="441935215"
X-IronPort-AV: E=Sophos;i="6.02,212,1688454000"; 
   d="scan'208";a="441935215"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2023 00:44:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="804413983"
X-IronPort-AV: E=Sophos;i="6.02,212,1688454000"; 
   d="scan'208";a="804413983"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 30 Aug 2023 00:43:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 30 Aug 2023 00:43:59 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 30 Aug 2023 00:43:59 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 30 Aug 2023 00:43:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MT7+NZjXrw/Hpq0z0Cf/i/2qEvnBl/zBmRjj6KcWwxy3nF3ZAOGRTz67KUNj0to9p6gsztmgRs0d2QQOcJ9yOMaGFIQXkNJqcgr9igkYB6+u+yrq6yGQ6OpgIK7ZV2ux/WGZF09sbk590aO1/oybd/bDywI4j/sIYd1nHJplu5FFly4pycQGsUKaTSX9W28U/xMs3Ew0BC+5NyVv/dlW+Q3mcloJZCGaM6QanTXpS3rvO+U6V+Ond6pPO4EwcxOUDm2D5j3khoKT2gI4hWPsuCcy92mDhyFwY50A7dltl5/5T3NR2guxz/KGz+U2fF34tV79zePVJQd0Q3C8lhk3gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WXXGbIf95MwX+NiLY1uXP0AXo0aKUx59s1i72kGAnQg=;
 b=B/NUsBe+fzqm4Z8OSCnmJ2fnOouwGl1LX0SBvvetX2gsC9EO0HgKJNHGbfpeB2Yqx38k2ZCtcf0YdIhws9Maz7+e89dNMkkWcJFjMuxrF8Q5kV9KFPSjblgwYvSrs8kaNsqvD73yKyPzJoRb6UbOQlfIAAEfBVpc8PXGhycch73nF3EW7E2F98fSRQnNRjWojzZeTmmfYt3nPoBuZCghRPXZgo+yxm6G3itJu7OBH9o1iPsbx1T6LAP0meweapDa+90D6iVjymeSxJxu94yTZUzNKEci7fgYtA2jUhQ6dYpl4gDKp/MugsySo29UAEquThptxx2x86kr3twhOkBspw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB8090.namprd11.prod.outlook.com (2603:10b6:8:188::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.35; Wed, 30 Aug
 2023 07:43:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6745.020; Wed, 30 Aug 2023
 07:43:57 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Thread-Topic: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Thread-Index: AQHZ1vydYVSBpw8DUkS1M41ymLRuMK/6p/jwgAGRCACABkHzwA==
Date:   Wed, 30 Aug 2023 07:43:57 +0000
Message-ID: <BN9PR11MB52768891BC89107AD291E45C8CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-10-baolu.lu@linux.intel.com>
 <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <cbfbe969-1a92-52bf-f00c-3fb89feefd66@linux.intel.com>
In-Reply-To: <cbfbe969-1a92-52bf-f00c-3fb89feefd66@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB8090:EE_
x-ms-office365-filtering-correlation-id: 3cec951f-63c2-4691-e31f-08dba92cddf4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3F/5i7eG9k3/Ll1+Ru/64XRpbqyV/QIIjozsFA2LT+gOLVyk2Vln2BXSVkVPqNel3NonqBjySvMki3qiwm431LjtlNnfhtdnZEoNP328e9FyRUNEc6J0I1vKOz/bqdny+o1+EleD8sPq0SfVSLKeHsQKQvebkHGCmUC+pKVjKRicy/gQ8OwFvDcVbOJiTetapMSG5tUUyZg0v1aubfFVnGzJiDB47SJirVzBQ6klUOGQf6+XryKWkaXUj+7hP3krv1sdQ3xmzTbZ6rBbYYLmLoYJm/h7C5CZ+zQasHw9C7yGGXpkWbr/bgiXrM/ANeDkRtb4HWAIePWN4wVoQTlXmrKE0Hp+gkE4T/qFvjeQ9a69q2tRRj8buYBvt21WiTsFAlYDGERMll4jKZx9UNgpf+hty16qASOgGFuG7sLSHmWnkEmlkT19rOxwhZYOnIg+3RBCo+H4+K2gYWwpH9f/ILhvsjHn1YarIG1e4DJRzTpwgdYL9wfV9GqR8SJWi8SIbVZx7fHcz+lNZ0rbTzqrF5hAmFDDRjFsh84j+ScwETM5/8CebV+LT+NL6AXrQF+nFHeGXyvn8Xxo4bNG6LWIZs3j4zqXugvoQ+Yh/me9fImc+OQ/ci8U2trIh8Kpf/I4WP5af5pyNYvn0i8nKZX2Bg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(366004)(376002)(396003)(39860400002)(1800799009)(186009)(451199024)(8936002)(110136005)(53546011)(478600001)(76116006)(122000001)(7696005)(66556008)(6506007)(66946007)(71200400001)(66476007)(64756008)(54906003)(66446008)(38070700005)(316002)(38100700002)(41300700001)(82960400001)(9686003)(26005)(5660300002)(8676002)(83380400001)(2906002)(55016003)(86362001)(52536014)(7416002)(33656002)(4326008)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YVFuWXhQWE9UM2ZMVmxOK3RPTUp2VmcvQzQraCtBQ2ZpMzg5Z2d4K3NQVzFX?=
 =?utf-8?B?SVh6SnpyaWFxVkNuSGU5RTg2QWZocWF3WndtMkZOYXhNU2o0Mld4elVZQ0RR?=
 =?utf-8?B?Q1lmRkVjQ1kzeGFYbk5TS3F1L2FDeVZVbGtVU1FUNDMwcFg1YTZoVVFCemNx?=
 =?utf-8?B?YkJxWVdNMGJGaFpJaDdZbEpLelBKRjdEY294VzNCZkNWUmFWZnRBaDhQazVt?=
 =?utf-8?B?THZiRUdwQ2lTbVVJZUhObEgyZ0ZldEp3cVcwamNnOG9YSWFTZkZtQzY4d3lI?=
 =?utf-8?B?SEptSlJOK0dBeWpKdThVVDZUMzBVWkM5dythVnpVeStjb2ZaaE5FSjdRUEM5?=
 =?utf-8?B?VXhtSXY4eHIreXhVRzBqYjUyblhuL3JKeXdNVWRHdW1qbWltMVVWbW1JWFlD?=
 =?utf-8?B?aFdpTTMzNXJLNVI5QTRzVzdvOHhZcWVMSmZlREhvYXlsd2czcFlEUDZhZDNy?=
 =?utf-8?B?VnBuRDVMcXNUTkN4T0RNTDA0a3Q2eG40K3pPMTBUY3A0T0c4ajAraDlFRUdn?=
 =?utf-8?B?Smo3cDc1REd0bUNyVW9SUkNtdyt2TjRpZVNCRDdYSUp6ZGJ1aGkxb3IyQVVl?=
 =?utf-8?B?MVBTbWNPYlpKK01WUjVVT3p4V1hiUnJVSmhBdnYvUkFtUUEwZzl0N2Y5VEEw?=
 =?utf-8?B?QUMxSG82WDg5eXQ3VFJodGVOUnZ2WnppSWJlSkFFYUFiYW1HbUNxSFowd0JK?=
 =?utf-8?B?MDd5d3NWMVRNWXNmNmdYa29uRERwMUM2YTc4VTZDZjV3N1lTdWJkM21URzdH?=
 =?utf-8?B?Nndhck9UNlB2Z1kwWjZpR0xCazlZTi9vVlFjQ0RvcTg0YVJYVGsyTkZRR1E2?=
 =?utf-8?B?aFFnSm1DcnI5UVVMMTR3YURYL29Sck9HN1Z6R3l6VHpvS2tMcUFEbXBqTUVk?=
 =?utf-8?B?bEtkWVU0YXBqdU45ODlzNms3RzZEcGMxSVlZM2ducFROcExTbTIrVkIvMEJw?=
 =?utf-8?B?THp1UVRBa1BxWk42MmpiWkVZSGNMKzl1SHEvZUxlWkR0cVpDSmFKRERYazJl?=
 =?utf-8?B?bjhhbVJLVDBPOWl4bHlUVTdrRGRhV1NmWmcwb0RiNlBodThxcVhBcDRiL0xw?=
 =?utf-8?B?Mmp4b2g2QnlXa2ZCZ2UwZENyL3RsOWgxVUdlbFRoOFZYUHdGS243dFp4b0Mx?=
 =?utf-8?B?eU5WS1oxdWl3bkNXeW9BTWxERGNzaDZtSWMrYWNzbVRBT3hHRjNaU2hkbE9D?=
 =?utf-8?B?UnBhc0FxVzZGZ3Rsc2RseVlpdUJXZksyVGdIcjNta1MybHBQRHExc0FRZDhE?=
 =?utf-8?B?MGFSaXF6ZnpzVzk5UkQzREZpVHBZeFVacVR1WEF3T3VTOXJVV1JCb2trcTlR?=
 =?utf-8?B?bkVuZTQzOTlONGtIOVV6NnljSnh1ZkhweGdMNlVXTktPdWtvNFpPWndwb1BK?=
 =?utf-8?B?MHZNUE5CUk5rNnNYNWZvdXZmWjlvYUhOaHpvTSt6WHliNXdKazRtWWR0VnIx?=
 =?utf-8?B?T1FVRjFyVHNSZUFQeFFjRGJNUnk3aXY2b2RQR0c5QmExdFJ6WlppbXFaQk9T?=
 =?utf-8?B?dE1LR2FNNmJ4azJHUlJsWWZSVjB1bkN6LzFvdWJWVyt1Qk5MTHFFV2h2ekhY?=
 =?utf-8?B?NTlQMnR6Qkc3V1N6Q2R6Sk5DdGNPWXg1R3J3bGcxR2tCSkFmNHlzZnNPdUdO?=
 =?utf-8?B?YVZYNHlDRVJZMkVyOFlQanV5R3ZBenZBR3hHWEl3aldOYkhXbG1KRVRrQ2la?=
 =?utf-8?B?VTNRcUhUYUdDQXhESDZZR3FseFA3RkhxQ2pPWGcwcGRzQUFCa1hFdWRGTk04?=
 =?utf-8?B?bWJVd2ttcDBDeDVPc2s5YWhXbUF2ODhOL0lBTkJRelVJcGc3Z2FrWlVHNW1n?=
 =?utf-8?B?UnUxVzdzK2hNbWwrbVFMLzRybzdOSG9XTWc0Slkwajl6NGdudTFRQy9WdWUr?=
 =?utf-8?B?UlNyMjhGdTQvUXByejkwZUtKK3RGNWxXSHNrM1NGcGxlN0xSL3pVQldiZCtG?=
 =?utf-8?B?dCt4WENYWDdVbnoycEF0dWFqV3lPUEx3T3Y3OGo3eEQwZ3JrOEkwQ2VtT3Y0?=
 =?utf-8?B?QmRZaiswbmdUZ1dpbnhKMXdtUklrNmpCT3o0SnBLTm9BbE5XRExuZCtHbHRv?=
 =?utf-8?B?aEVscmpWUGk5RUl0NDhiRUFoS3RYQW1tMWxGbklzZmtMRXZrNXh1QmhBRnZW?=
 =?utf-8?Q?C8RlWG+9FgnHHYiwMKMEkTCOC?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cec951f-63c2-4691-e31f-08dba92cddf4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2023 07:43:57.0415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UwiPBt+RLYya4YZw2cST7SMGHGMivXSJ7twbT3KGWb7/s8E9ppzU1E5vZLoVIkt/KTSj1CYqiKSgG6tZTBAT1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8090
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBTYXR1
cmRheSwgQXVndXN0IDI2LCAyMDIzIDQ6MDEgUE0NCj4gDQo+IE9uIDgvMjUvMjMgNDoxNyBQTSwg
VGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4+ICsNCj4gPj4gICAvKioNCj4gPj4gICAgKiBpb3BmX3F1
ZXVlX2ZsdXNoX2RldiAtIEVuc3VyZSB0aGF0IGFsbCBxdWV1ZWQgZmF1bHRzIGhhdmUgYmVlbg0K
PiA+PiBwcm9jZXNzZWQNCj4gPj4gICAgKiBAZGV2OiB0aGUgZW5kcG9pbnQgd2hvc2UgZmF1bHRz
IG5lZWQgdG8gYmUgZmx1c2hlZC4NCj4gPiBQcmVzdW1hYmx5IHdlIGFsc28gbmVlZCBhIGZsdXNo
IGNhbGxiYWNrIHBlciBkb21haW4gZ2l2ZW4gbm93DQo+ID4gdGhlIHVzZSBvZiB3b3JrcXVldWUg
aXMgb3B0aW9uYWwgdGhlbiBmbHVzaF93b3JrcXVldWUoKSBtaWdodA0KPiA+IG5vdCBiZSBzdWZm
aWNpZW50Lg0KPiA+DQo+IA0KPiBUaGUgaW9wZl9xdWV1ZV9mbHVzaF9kZXYoKSBmdW5jdGlvbiBm
bHVzaGVzIGFsbCBwZW5kaW5nIGZhdWx0cyBmcm9tIHRoZQ0KPiBJT01NVSBxdWV1ZSBmb3IgYSBz
cGVjaWZpYyBkZXZpY2UuIEl0IGhhcyBubyBtZWFucyB0byBmbHVzaCBmYXVsdCBxdWV1ZXMNCj4g
b3V0IG9mIGlvbW11IGNvcmUuDQo+IA0KPiBUaGUgaW9wZl9xdWV1ZV9mbHVzaF9kZXYoKSBmdW5j
dGlvbiBpcyB0eXBpY2FsbHkgY2FsbGVkIHdoZW4gYSBkb21haW4gaXMNCj4gZGV0YWNoaW5nIGZy
b20gYSBQQVNJRC4gSGVuY2UgaXQncyBuZWNlc3NhcnkgdG8gZmx1c2ggdGhlIHBlbmRpbmcgZmF1
bHRzDQo+IGZyb20gdG9wIHRvIGJvdHRvbS4gRm9yIGV4YW1wbGUsIGlvbW11ZmQgc2hvdWxkIGZs
dXNoIHBlbmRpbmcgZmF1bHRzIGluDQo+IGl0cyBmYXVsdCBxdWV1ZXMgYWZ0ZXIgZGV0YWNoaW5n
IHRoZSBkb21haW4gZnJvbSB0aGUgcGFzaWQuDQo+IA0KDQpJcyB0aGVyZSBhbiBvcmRlcmluZyBw
cm9ibGVtPyBUaGUgbGFzdCBzdGVwIG9mIGludGVsX3N2bV9kcmFpbl9wcnEoKQ0KaW4gdGhlIGRl
dGFjaGluZyBwYXRoIGlzc3VlcyBhIHNldCBvZiBkZXNjcmlwdG9ycyB0byBkcmFpbiBwYWdlIHJl
cXVlc3RzDQphbmQgcmVzcG9uc2VzIGluIGhhcmR3YXJlLiBJdCBjYW5ub3QgY29tcGxldGUgaWYg
bm90IGFsbCBzb2Z0d2FyZSBxdWV1ZXMNCmFyZSBkcmFpbmVkIGFuZCBpdCdzIGNvdW50ZXItaW50
dWl0aXZlIHRvIGRyYWluIGEgc29mdHdhcmUgcXVldWUgYWZ0ZXIgDQp0aGUgaGFyZHdhcmUgZHJh
aW5pbmcgaGFzIGFscmVhZHkgYmVlbiBjb21wbGV0ZWQuDQoNCmJ0dyBqdXN0IGZsdXNoaW5nIHJl
cXVlc3RzIGlzIHByb2JhYmx5IGluc3VmZmljaWVudCBpbiBpb21tdWZkIGNhc2Ugc2luY2UNCnRo
ZSByZXNwb25zZXMgYXJlIHJlY2VpdmVkIGFzeW5jaHJvbm91c2x5LiBJdCByZXF1aXJlcyBhbiBp
bnRlcmZhY2UgdG8NCmRyYWluIGJvdGggcmVxdWVzdHMgYW5kIHJlc3BvbnNlcyAocHJlc3VtYWJs
eSB3aXRoIHRpbWVvdXRzIGluIGNhc2UNCm9mIGEgbWFsaWNpb3VzIGd1ZXN0IHdoaWNoIG5ldmVy
IHJlc3BvbmRzKSBpbiB0aGUgZGV0YWNoIHBhdGguDQoNCml0J3Mgbm90IGEgcHJvYmxlbSBmb3Ig
c3ZhIGFzIHJlc3BvbnNlcyBhcmUgc3luY2hyb3Vuc2x5IGRlbGl2ZXJlZCBhZnRlcg0KaGFuZGxp
bmcgbW0gZmF1bHQuIFNvIGZpbmUgdG8gbm90IHRvdWNoIGl0IGluIHRoaXMgc2VyaWVzIGJ1dCBj
ZXJ0YWlubHkNCnRoaXMgYXJlYSBuZWVkcyBtb3JlIHdvcmsgd2hlbiBtb3ZpbmcgdG8gc3VwcG9y
dCBpb21tdWZkLiDwn5iKDQoNCmJ0dyB3aHkgaXMgaW9wZl9xdWV1ZV9mbHVzaF9kZXYoKSBjYWxs
ZWQgb25seSBpbiBpbnRlbC1pb21tdSBkcml2ZXI/DQpJc24ndCBpdCBhIGNvbW1vbiByZXF1aXJl
bWVudCBmb3IgYWxsIHN2YS1jYXBhYmxlIGRyaXZlcnM/DQo=
