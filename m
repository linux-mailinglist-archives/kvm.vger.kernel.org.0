Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A676A59F2
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 14:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjB1NZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 08:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjB1NZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 08:25:04 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8A12A14F;
        Tue, 28 Feb 2023 05:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677590703; x=1709126703;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cc7Clws9tf4goZxOII2BBUyyuFGb48lfamTqGpkbcXk=;
  b=ECfyzz+RUOe5G3Lv5moBdYqGKw6OOrOPXk3/3BY84SBAO23B7Gh/mGBW
   lcAUGsezNImPLIDw3HREcfzG8QCtxFx6dqmjTJDc+IRoTNS0zQHpwRkgS
   x6l8vJTomh4E4a35jmZkvr4n4DSnqhbtmvlFDZHySzMNzFNCcGEbqQTP2
   RjCwWw7te8Zbmk7MOEmPD1xCmV7RC9A2d0nhIKxCge5sZPV/uqvTtYQck
   m+nd3s5qOz87BC3k9OPc+45Hn0IAweDYQ9BDNb4+mukn7Mbxu7yqkEfQl
   XumPZnfEoftWiTJJ7CVC+AtidBSBjFcthnb7k+aOuRMTBlQoKSx30cUhq
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="314554777"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="314554777"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 05:25:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="674127584"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="674127584"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 28 Feb 2023 05:25:02 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 05:25:01 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Feb 2023 05:25:01 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 05:25:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cfSrnEFRNucSxY5a03w7V2k8KrqX5uq6EAk+AhaptPXlE32AeudLTfrhHcAnMrJ4zL6DxotErVojcr67gFJwg9Z++IZe0q2muXqN3raRG8ottigN4Dz1LsQPYPGOi4VoZJSMiA7Un/vgWv1o2eJCpDYH4fJCLcrAtHRADoVfRVAyi13Vspbp8r7kWzs4P43mglDUEQ2tSi3KbvOCyhojXjIjav1Su2EgdElT7LoOhsC0oVTiIsmA1eMpkZA4u5YeAbG7dBB7yyo1ASi8SPxKy2Xrey9n7roIu5gJWptFp/6DIEuu2HF5QlU4IkGNPa4Ex95vAmoGYXSYKDYCWFyHvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cc7Clws9tf4goZxOII2BBUyyuFGb48lfamTqGpkbcXk=;
 b=C2v0eCIgj1Ci26Di+ml2Ih9e64foVzSs+37yxEdrFyj6MvAhU35bxxjVzWoigmB3OWPekfpnPlUBO7UYRWS9+rg5Ml7phfFmzifyAGG5FduO8MQb5zG/WGs5AcxWRTplC6jNaqTb4SeV6yYF0rvjwR1SAYeLWP3GUuS3Z9QWnTZRu455041MuljKhsK1HxzkzKxl4Wl0P6zcFpItxkeFxh7yzvk7nlNSw8nK/dhnJgXWWM4GP1XdlX+d+q6N0Qsz7O5FlVeB19sDRtv9Uuxh6Bf80urWSFjOjQMvKhzzRK3OHkW7vSKb9cdtqT83POw99lAJwl+MYFsFQgFwTyYifw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH8PR11MB6708.namprd11.prod.outlook.com (2603:10b6:510:1c7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 13:24:59 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 13:24:59 +0000
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
Thread-Index: AQHZSpxK4wL3BAz2vkuMw78Q2DEYMa7jHbWAgACHOBCAAKaUgIAABHXwgAAB8gCAAADy8A==
Date:   Tue, 28 Feb 2023 13:24:59 +0000
Message-ID: <DS0PR11MB752903E3E0E7A0FB59591CC7C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-11-yi.l.liu@intel.com> <Y/z2mY97uPsCs6Ix@nvidia.com>
 <DS0PR11MB75292E7DCC6FFEBF5B5DF66AC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/3zw/F0AN74CYs0@nvidia.com>
 <DS0PR11MB75296F3B01E872C5E13763BEC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/35ItebTPdaXQdU@nvidia.com>
In-Reply-To: <Y/35ItebTPdaXQdU@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH8PR11MB6708:EE_
x-ms-office365-filtering-correlation-id: c5e41bbc-38d7-4410-e132-08db198f30da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2G5pwMKyX3FMxtg+VFaLJBPofp3LpZvDcKbtedEGXtObcZqYFnhtkQ217zwuKfZC/voNxWDLsYxujPpXXuVr1Sb2rxnLh0MAnrtYFW0770aLZX2sSbqVPHBzkixBxTipND/o8ymMbAALbIgcm2Dckz/0efy1OGquFA6Gkkz12hh+dDb2jC7BzTx7Lg0senleBV/YxSg2JnT02rlOVS+ITZpry4EGL3Q06RPFMBTI36Kb3eP1Haaup7QPL+V+ABdAMRHc0ebWDSw91oD0HI3X5pv4tt5z2qRQuoqBbZ4+l7w5eaA+S/P/HX+5Go2zNTzmSDmvJtlH5JAJ1gxXMZ3WNFHSsATUPlKVDFrgUILd0EIVtJLN1WW1n1x5pbtVOk9EWr4dgQg/IjTfwPP2zlyIVyGAPsgiiGeuEcX3qJ+4ZxokY7Lsz/tBbnQFt+N3YriK/hLsyT5UNEShVdKDEoaC8iNuj3vVkoMoe43/BJi41SPjH+PBIOfTHhwZH9z3WktV510aGn8iEI/pORgI7HEXFccAn/+wUG+R6Rw7mG6lkjnWA64JrRKU52npD+nkjk9r8WIr9PHu97Sli8uEUWqo1KCZgI+Kr0i7jt6EV3MbJiFwo0oO14cutfi/CO5yRbIjFYxcQ9OXaeWR8XrLE5hFkOWbOh4c602qk2NEtDX4XRu7uR4roGlPleEPI1ug9S/1LcKS2lkGz5gFZiX/k5bzxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(396003)(346002)(136003)(366004)(451199018)(82960400001)(38070700005)(38100700002)(122000001)(83380400001)(54906003)(33656002)(55016003)(7696005)(2906002)(9686003)(6506007)(478600001)(186003)(26005)(71200400001)(5660300002)(52536014)(316002)(86362001)(8936002)(7416002)(41300700001)(4326008)(6916009)(8676002)(66446008)(66476007)(66556008)(76116006)(64756008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWQrV1BBTGhSbENUbmpKOEFLRkVWZU5ka2owRVZ5WW82Mys4SGFwdDY0SnA1?=
 =?utf-8?B?ZzFRK3RaL1AxQVdPb2x2c0pYY1lwWXFtNGVBaUZWc3l1QkgvS1YveEZ3b01W?=
 =?utf-8?B?ZGZseXdxMWZ3OTdPN1NHYnNvVGhzVW9odEtDSVlsQ2hXL0xjMlFpbm8xd2hk?=
 =?utf-8?B?dm90SXMwT0hYYUQzTjBPcEw2SWUwNlZlQloxUjZLM294MkJmMkdGUEVoNlg0?=
 =?utf-8?B?ZDl1WmYwcTJUTWQ0REF4WDEzSk1pSW9VZnEvM2dQOXo4d1FuUXRPZGN6bFhK?=
 =?utf-8?B?TCtWYUMrNFpQeisvR2NVZklKZ0NxKzBCSytUdTBlMlZ0ejJtS0JoVWVPeW9l?=
 =?utf-8?B?eHVyb3FzeVJXYjkzQU5VeHNZRG1ING43ODdLNnQ2UjVWRzJYK0NLaVBvVVJC?=
 =?utf-8?B?Y3BMSGUrb0xkVXM0dkt4aDB3WS9LbUFwVTlpd2NHYTFhTzQ5bFlwM3czYkJF?=
 =?utf-8?B?Z0NPUHVvUkRabWx2R2xRUjdZcEV3NzlxR1R0dlZaczlKQld4UldRRHpIOElQ?=
 =?utf-8?B?eWQ3QVB5MFNqVDgyRXExMEhxVkt5K3ZKTTRMTktLaG1nN280ZjFoMVFhZy9w?=
 =?utf-8?B?bFhwb29sYjdTRzJUNlZwZXpsV2F0Nkd2ZVhtKzdMcENsVkRuaFZhT3FqejJn?=
 =?utf-8?B?R3NKcUY3Ny9pWHhTOVJhRUd5a1Z3eDRlUVhtbUEwOEVwaUVqVWVJV0w1UzB0?=
 =?utf-8?B?dmFzUmk4Z2xhNjlTdkt1S21nMW9za21leXR5WUs3a3lFeWVUL1l6bDNqb0h1?=
 =?utf-8?B?bW9DQ2ZscStJSkIrNWszWjY0MnN2ZVk2eVVJSWQzc2MrTngvZVBvVFk1WkhN?=
 =?utf-8?B?WXBKL3p1anBueHJwNkQ5cXdCMm5CbWdMZ3FXREJPaHlwYXNvVEM2dGF3RVZW?=
 =?utf-8?B?U2dPNktXMmlRc3hUOU12T3hlUGdJZ3Nxd01xSEozY2JaRVRRYkNGY2ZMQUln?=
 =?utf-8?B?RU1yVFNjSVQ3UC9LdlkrUGV3VEVIQ1IrWVVTS094Vk1ERy9XcWRMZWcvc2po?=
 =?utf-8?B?UVRmT1YveGZDZWRoVFFmcGxrd1IwbzY2d2p1Sk1BaEdybHptNG4yd3hsQS9U?=
 =?utf-8?B?a3F0blo4UU1ZZ1hhT2JhMS9lRHJxVWxGZ0s2MUw2Q3FNTnRiYXhLUnZZVU1r?=
 =?utf-8?B?QmMzaHJoWlZhYVIrMnlrb3ZYdCtlbU1HbzRKekF2RWk1ejVvR3pOWjB6b1dr?=
 =?utf-8?B?MlltUnFxcmlVQjd1OGxIMmx0V0MwMkJFWmkxZldvYzdvd3p0ci9JM0pLaUt2?=
 =?utf-8?B?Um5HVFhvSkFHcGRoUUJLNGh1VjRWbUZRQmRiRWoxSFFzaXF6S05lY2xGY1Ew?=
 =?utf-8?B?LzZuSXkvVllmR3R4SWV2dmlKam9BUnd3UWh0VHpsUXFvSjRxT2xFRWxBNjNP?=
 =?utf-8?B?NGp6cjZzLy92MVZXeit0SXZabHloTGE4MTdpdXZKUUdjbDNUaWtSZGM3cVhr?=
 =?utf-8?B?eWtTaE1CWG5pT3hCOWhnSThkZ25ZdDUzemlEb0RMdzZjbVI5ekY0NlJOWDdX?=
 =?utf-8?B?Tmp0UG1NSWJpazRObDEwWU5yZW1IMWI5T0RUWUZ5ZDh5WHpyZHVpWStzN25G?=
 =?utf-8?B?NnQ5NGg3amtZR2FueDNMd2o1c3BXZVN5MXJwUmJYckJDREM5ekJzekx2WnRn?=
 =?utf-8?B?c2YzZHRqYWg2ZWhmT3dqT2RzWjdlMjdpUDFwRHRYU2VaZjhuUmpTZ2lEeUVC?=
 =?utf-8?B?R2hXU2ZhMEJYZ045dHBJUXBsM1hGSVMvbGJlL0o2bUFrTHFUVWx2UnljK2Q4?=
 =?utf-8?B?Y2ppZ3NYaXArOWp1OSswVjNrKzJQVllTelFoR0RJNmVEeFVPZ3V5OEhPVUVy?=
 =?utf-8?B?amNLcGZqaS84MlhVcGlaNW51eE9XWUJjYjdGS2wrUDRrWmwyTFlOaWJYaHdU?=
 =?utf-8?B?Z1ZIRlhRNW05SnNXMU8zMzJ6SzE2MTJzQ0N6cWpLdFdZUFh1eDN1dUxWSGl2?=
 =?utf-8?B?clhTOWxFVExDZEE0M0VzWENybEg4NTcrTytZdDFjeDNLK3cxbVRKUm1oR2VW?=
 =?utf-8?B?d1p2VEQvZnkzaEpqcGlOSWlrbTFaSHVZeUlhV3k4d0tWbTQ5UEt3RGM3R09I?=
 =?utf-8?B?WW1lMlFhUzBqUFpIRmFKSlZ0OVB5bUhEM0lrSm1CcFczM1pBTk5QQ1VGTFJu?=
 =?utf-8?Q?CZ9+bGnL4ulMQDQc340MvCG4o?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5e41bbc-38d7-4410-e132-08db198f30da
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 13:24:59.3569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3jANGCwqY9C6YB/gaerW0Ry7rASK6gWok+THMrBATXJMGN4Scl/PVMAubzP5FOXwS6P4ptCfvNSFIiK8weAqaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6708
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
LCBGZWJydWFyeSAyOCwgMjAyMyA4OjUzIFBNDQo+IA0KPiBPbiBUdWUsIEZlYiAyOCwgMjAyMyBh
dCAxMjo0ODoyM1BNICswMDAwLCBMaXUsIFlpIEwgd3JvdGU6DQo+ID4gPiBGcm9tOiBKYXNvbiBH
dW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiA+ID4gU2VudDogVHVlc2RheSwgRmVicnVhcnkg
MjgsIDIwMjMgODozMCBQTQ0KPiA+ID4NCj4gPiA+IE9uIFR1ZSwgRmViIDI4LCAyMDIzIGF0IDAy
OjM1OjI1QU0gKzAwMDAsIExpdSwgWWkgTCB3cm90ZToNCj4gPiA+DQo+ID4gPiA+ID4gQW5kIHRo
ZSBjb21taXQgbWVzc2FnZSBpcyBzb3J0IG9mIG91dCBvZiBzeW5jIHdpdGggdGhlIHBhdGNoLCBt
b3JlDQo+IGxpa2U6DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiB2ZmlvOiBQYXNzIHRoZSBwdF9pZCBh
cyBhbiBhcmd1bWVudCB0byB2ZmlvX2lvbW11ZmRfYmluZCgpDQo+ID4gPiA+ID4NCj4gPiA+ID4g
PiBUbyBzdXBwb3J0IGJpbmRpbmcgdGhlIGNkZXYgdGhlIHB0X2lkIG11c3QgY29tZSBmcm9tIHVz
ZXJzcGFjZQ0KPiA+ID4gaW5zdGVhZA0KPiA+ID4gPiA+IG9mIGJlaW5nIGZvcmNlZCB0byB0aGUg
Y29tcGF0X2lvYXNfaWQuDQo+ID4gPiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4gR290IGl0LiBub3Qg
b25seSBwdF9pZCwgYWxzbyBkZXZfaWQuIPCfmIoNCj4gPiA+DQo+ID4gPiBNYXliZSBkZXZfaWQg
c2hvdWxkIGJlIHJlYWQgYmFjayBmcm9tIHRoZSBpb21tdWZkX2RldmljZSBwb2ludGVyIGluDQo+
ID4gPiB0aGUgdmZpb19kZXZpY2UuIEl0IGlzIHRyaXZpYWxseSBzdG9yZWQgaW4gdGhhdCBtZW1v
cnkgYWxyZWFkeQ0KPiA+DQo+ID4gWWVzLiB0aGlzIHNvbWVob3cgZ2l2ZXMgbWUgYSBkb3VidC4g
V2h5IGlvbW11ZmRfZGV2aWNlX2JpbmQoKQ0KPiByZXR1cm5zDQo+ID4gYm90aCBpb21tdWZkX2Rl
dmljZSBwb2ludGVyIGFuZCB0aGUgaWQgYmFjayBhcyBpZCBpcyBhbHJlYWR5IHN0b3JlZCBpbiB0
aGUNCj4gPiBpb21tdWZkX2RldmljZS4gSXMgaXQ/DQo+IA0KPiBZZXMsIGl0IHdhcyBkb25lIHRo
aXMgd2F5IHRvIGF2b2lkIGFub3RoZXIgQVBJIHRvIGdldCB0aGUgSUQsIGJ1dA0KPiBwZXJoYXBz
IHRoYXQgaXMgbW9yZSBjb252ZWllbnQgZm9yIHZmaW8gYW55aG93LiBXZSBjb3VsZCBnZXQgcmlk
IG9mDQo+IHRoZSBpZCByZXR1cm4gcG9pbnRlciBhcyB3ZWxsDQoNCk9rLCBtYXliZSBJIGNhbiBo
YXZlIGEgc21hbGwgcGF0Y2ggdG8gYWRkIEFQSSBsaWtlIGlvbW11ZmRfZGV2aWNlX2lkKCkNCnRv
IGdldCBkZXZpZCwgYW5kIGdldCByaWQgb2YgdGhlIGlkIHJldHVybiBwb2ludGVyIGFzIHBhcnQg
b2YgdGhpcyBzZXJpZXMgb3INCmFuIGluZGVwZW5kZW50IHByZXJlcXVpc2l0ZSBwYXRjaCBmb3Ig
dGhpcyBzZXJpZXMuDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg==
