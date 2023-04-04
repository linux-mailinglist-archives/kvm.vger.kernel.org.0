Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A566D674E
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 17:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbjDDP3e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 11:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjDDP3c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 11:29:32 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20796129;
        Tue,  4 Apr 2023 08:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680622171; x=1712158171;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8/mfTu7HT74yz5/HGTc85zj7rntzw9qcrKuXDIoXPK0=;
  b=jAqS1WH74B4ldtXyB/L3wS8Wzee7g48XUCsAQ9LrVEdnPi8k05DmkjHA
   JVqGd/NMlyH30LGYZkBFRtSoVrhc5qUyhNuByctrlr1PVLeD3TCa86BrB
   jLbJ1Z7EzXmhyB53VOgTdRtJDMzWiD37MqSVT05HLrnp11hAER5tOrGLs
   8Uh7H3RV7IZr4IWrclefu96btA7t4Ien+du/QIyhcEHy9tlQjkGBW+API
   I3FhSkNqsEcf0IcCo0gscscOfzcoj3etoQ8LbdBSeSS2So0USob6T3SAD
   QbbokVtaL2P8H/M5ObscXaoq05pwwVmLESAjawEH6LQUZoQujBRvnPUFb
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="407287546"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="407287546"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 08:29:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="679927646"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="679927646"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 04 Apr 2023 08:29:18 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 08:29:17 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 4 Apr 2023 08:29:17 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 4 Apr 2023 08:29:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PeIcvScghyI/aTCmwdIxbkHDOeDe2yjOq9wU2uccM2CX7opn5jpfpo4Scq0jlfopihyyyPctwVwP+FnPMBgp3TpvmTdS0hEk6WVaQcosF2p0Sqi6lCgfX5obItCCXufPhnz+GDKeL/vQvSBa0QZPqPkNHNKu8Z8RAIGeiM40AAO1QffDTMjjvt1PVskneTn/FwjsRmPHIcxQeON/okg22Ao9GrRc5vdE/Uu3BYIce6WOq4nc7bIoLs60UTYzukyEUkUYdYSXFPry4zcoFwHvL4fGeNSd8PTQ4TqmjjV8gs95zDuF5CEjZ5CydMDtraPUpzM0LmMaU0hmZqx+Ge1Gig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8/mfTu7HT74yz5/HGTc85zj7rntzw9qcrKuXDIoXPK0=;
 b=O/a5t4346w27cmAlpyjo6wgH6/ogsRR6Z6q2UPhLmiNp9JZbuh1Fyy+nahY+Kttyot3ewMrWhkDRfynDMbO4uFKUjUpdV2yQxVjpUFhLtS2Fzsgjq3H6E3/qdV3yc8Q6GtrJPa1Uok/bet+PAtd704Fc/BBirJsEU5+J8zVVGKDo//UnCaij+DbVm/BhQoayJeHa0L7pfQZGp8LpWH41+VuyeLLvCAJd4zeh7BySkpz7MIXBLmqCA9rEMI/GJtNWtRJiWdJunuzuKpkazhT2UUlAfSWhs4B/r79dPPuXp24eOTkUD06LXhorOjElDz7AXoc09jjugSQqABIjU04oOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BN9PR11MB5403.namprd11.prod.outlook.com (2603:10b6:408:11c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 15:29:15 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 15:29:15 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v3 02/12] vfio/pci: Only check ownership of opened devices
 in hot reset
Thread-Topic: [PATCH v3 02/12] vfio/pci: Only check ownership of opened
 devices in hot reset
Thread-Index: AQHZZKh8/nKgsyDFPUuOsexCLs7iSK8bMgyAgAAHEvCAAA8XAIAAAT/w
Date:   Tue, 4 Apr 2023 15:29:15 +0000
Message-ID: <DS0PR11MB7529441450FE32DC9578C6B8C3939@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-3-yi.l.liu@intel.com>
 <844faa5c-2968-2a4f-8a70-900f359be1a0@redhat.com>
 <DS0PR11MB75290339DD0FD467146D4655C3939@DS0PR11MB7529.namprd11.prod.outlook.com>
 <fc87191d-2e79-83c3-b5ba-7f8b1083988a@redhat.com>
In-Reply-To: <fc87191d-2e79-83c3-b5ba-7f8b1083988a@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BN9PR11MB5403:EE_
x-ms-office365-filtering-correlation-id: 108ef59b-6b27-41d4-40f6-08db3521596f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fxQ08OM3v23FFjUQJ9OwcpD8gXGuQcVheejUxPuCxvFWj9zHz+whHTKCYlCI+Fs9p3f965LFVn00Y8YlfngspQk+OZBP88kp56wyVHW5C/mxANbzPir2uxZsAQShyB/TkSRY9OElV1TOcvl2Y7eyYx2S+95GYS87hgu5/4U4vqbxgtmN33sMc3skucx/kgMkiMSCIh2a1nalHGw/ihn6AokhQ0/ULx6lzNDFBZCA2egXehFE5ZbMtb8KfqcDsXr3fJHPHxeNMBw/BskixsVi2Ub4zANSMs4rnzwvEwrT8gwhMIhKHhjRVec+MmorcwAVIW/oZ37mnVSE7cRG3YuZetu0CWPRPro1eLx5wTRWLkJ7ncMOdOLBbW6gBOOP5MQ3ry/JnbLp68ZdxNjz7RaanxrLJRjWnq6jBVXiaLKpRyKlpqeIwmBcMp2THZKxZzYrFkmCDc1LUKfvK1qZQltzUZCzW/YeqC/0oWiFzxqtlg10PZenpiGJR1BHXuuXUFYjTRtbWE0P/lN5T0YhvhOms1He9kFHA1vKrfM2x2tFFmrj9NEIBwxABdpIYD5jPJU3TyPpNhY/lp/ZuI4vpSs/8nV5j5yKa14jwK/qmFL/8vlwxf213958n3XFRSugTHuoVtwVZmucNdXk6P1X9UPYhA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(376002)(366004)(396003)(451199021)(55016003)(186003)(26005)(53546011)(8936002)(2906002)(5660300002)(33656002)(38070700005)(7416002)(86362001)(66946007)(478600001)(54906003)(6636002)(76116006)(316002)(4326008)(110136005)(6506007)(83380400001)(52536014)(41300700001)(9686003)(8676002)(82960400001)(38100700002)(122000001)(7696005)(66476007)(71200400001)(66556008)(64756008)(66446008)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHU3NGp0VytBZkE4ZC9Yc1lvZzlqOUM5TThSL0VjcjUvdmcwcnZuQUFqdUlK?=
 =?utf-8?B?NTlxQVNENGc2ditDdkFwNjJPMlZ2R2NLaW90UC83WGJuZjFrVEgwcXd1eTlD?=
 =?utf-8?B?NGZyeDV5QjNuUVdFVUdYR0FqOWw2OHh2WU5BTW1Damd5V285WDVHY3ZFM0VH?=
 =?utf-8?B?ZnJDdkhrTWpLMXQ5OTNKQTVPaFhuQUFmSm51VkdRdkt4Z1VORWFCSlAzSDRj?=
 =?utf-8?B?WEhKZU9SSEM3VkFrS0dPZ0pRaDcya2tCVnJ4WDR6czFKZ1QwSUVXRmQwOG5D?=
 =?utf-8?B?ckV3SmdzUkNpV1FNbWJBaG40UXp3cE02amgxclRYRlZEMnZBWllMamJqY2V0?=
 =?utf-8?B?RG9la0o0TDAzYllwOG5maHlrR3NzVVVjZmZVVzZ0NWFXN3pMc3RuKzlzakRm?=
 =?utf-8?B?TVdLUjgxVG50S0hLdjB4dkFYd0lEc2lheUxQUVNhWHNYVUpnU3lhaGlsV2VU?=
 =?utf-8?B?YlA5RktEOUhacklaM29RQ1V1bmNRV0JYbkFsYkNtZ3NDbVdmT2ZwbVduQnB4?=
 =?utf-8?B?ejZXZkpaZUtCSzA4QnNJWUV4OTZqNTYyV2s0ZFN0eW9VUzRoaCtZZVh6cDhi?=
 =?utf-8?B?akd5eEdwMVJ4V05JaE5NV0kzaHpidHJiNkRzQkNOMlVPWEFnR0x5bXFRemtt?=
 =?utf-8?B?cjRndy96Mm9ibzNMTVJvWkJtYXNtZDVZV0p4ckU3TTJ3aEZSQkQxNGY2U0ZF?=
 =?utf-8?B?dTlsSW1IMVF1cGNYdWJaZjhhSWV5QkQ2SndhcVUvMlcvMnpScWJPYmdMVWtN?=
 =?utf-8?B?VVBvcGl0c0tWdXBaYW8yakhXVkhFbGE5YWNsRkg0dlNSTFd2QUdURHoxVWsv?=
 =?utf-8?B?TWRHRHpReko5eUhma0J4VjF5dmlyTXo1OFVWc1QySWIrWXpPQlpnemZzb1hK?=
 =?utf-8?B?U0J1Z3NzNmZteFY2Ly9JWFYzSGdMNURZWU8zTHFsTytKbUd0ZDgzUFlWbnkx?=
 =?utf-8?B?WUJBQ29POGQ1VUZ5SlpKU1hYeEVvb0dkZ1lmSjV6SnFXSjl6cWQ1TllSNHV1?=
 =?utf-8?B?V204MkpNcE9XVVJ4RkZiTCt5cVlQN1psOVVtU0FRek1zT0tkS3FsK0E0RnhG?=
 =?utf-8?B?VDdwMVRUMjR3OGFCaVJ6cE9oZTArK0oxbWtudVNyVjBzdWt4U0pxa0lOL0JQ?=
 =?utf-8?B?RW44WU9teUxPdUZzc3J4dUN1MVpXR1IzcU9heS9xVVl0ZHhwTnBJbytRd2Rn?=
 =?utf-8?B?c0x6WFpSQzFkZkpRVE5oQjNJNHZpa0p2Znd3Y3BZa3l6RytKNmxZeE51dlo0?=
 =?utf-8?B?dFRrZTI1ZUhScTcxMjVxWkU0eVlSalVBMU1GYStaekRGSEhSZUMwL0htMEZp?=
 =?utf-8?B?b29MUFFodGVyM25obUdUdGFIUjJRUFVxQ3ExbW1GOG9wUERhdkVFMnBla1E5?=
 =?utf-8?B?dC9ubkxWWUN6ZUg4Ni8xRk03ZHVVYWJmdFVyZXZQc0gxV1NsZDdrOE0xTUFx?=
 =?utf-8?B?emhjM2dmTWI1YUJOdWMxVkFmODU1SjluY1JlTFJaMS9ZcU0xOG9JU3BGNWhs?=
 =?utf-8?B?STI3R1VzdnpvL0wrZ1U3cUkrYzJsb2FMRFJVSFZWbFlPRDlZbkZpL2tWNmxW?=
 =?utf-8?B?ZE8wVUVSU3pFMDUvTmExdjFDWVVwRGlRWEhnS1lGL0NOODRTSFRlMTRzYU1K?=
 =?utf-8?B?L3h2cFVOamw1V0ViV3hwLzgxbWp4RGpVTWZWY2VSWEhzWmUzQktYYkFrR1lU?=
 =?utf-8?B?L2dHTUgwRTNsN0pYTnYrdVp5MWhFQ05oSU8xcjYvcG1UczY0bmFuQmxvQnpj?=
 =?utf-8?B?WENaREdtNEJUV1h4NFdLUXcvSGl3bG1TM0dBTXpyUWhoRXMyYWFsMWhUREZs?=
 =?utf-8?B?Y2p5aFlxUXBlWmhEK1Ywc3VxdW9pT0ZtT2RkdXRpdHg2V1Y3eXk5UDBxOHgy?=
 =?utf-8?B?RkxUaUFlbnFYZlVLVUtEeEZKU3hwajZtdk9UOFo0TlB6SkNTSkVpcTl5T2g0?=
 =?utf-8?B?ZEgyb1BSai9MbWp4ZWY0Mm1ycEFaaG9ydCt6L1RWM3g5ZEM2V0d5M0Q2MDIy?=
 =?utf-8?B?S2dDMUIxcTVYNGdHYlE3OVdvSjNJWHdjUEVXQmQ2VWNibEtyYy9hNnpwVW1v?=
 =?utf-8?B?eEVJOXR0RnZiZkZmbUwvb3NOK2V1NUk1VEVoRDg2eEhBelk1NDE1VjV3UkFE?=
 =?utf-8?Q?NFz0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 108ef59b-6b27-41d4-40f6-08db3521596f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 15:29:15.3629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X0Sg3yzA4iD/lbYNhdpXXyqUks0ZaaVuKGNiKf/7lhsh1VrzkAg1121Hx4PeSaDC154u3i3hI2XQtE68wNKa6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5403
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFR1ZXNk
YXksIEFwcmlsIDQsIDIwMjMgMTE6MTkgUE0NCj4gDQo+IEhpIFlpLA0KPiANCj4gT24gNC80LzIz
IDE2OjM3LCBMaXUsIFlpIEwgd3JvdGU6DQo+ID4gSGkgRXJpYywNCj4gPg0KPiA+PiBGcm9tOiBF
cmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+ID4+IFNlbnQ6IFR1ZXNkYXksIEFw
cmlsIDQsIDIwMjMgMTA6MDAgUE0NCj4gPj4NCj4gPj4gSGkgWUksDQo+ID4+DQo+ID4+IE9uIDQv
MS8yMyAxNjo0NCwgWWkgTGl1IHdyb3RlOg0KPiA+Pj4gSWYgdGhlIGFmZmVjdGVkIGRldmljZSBp
cyBub3Qgb3BlbmVkIGJ5IGFueSB1c2VyLCBpdCdzIHNhZmUgdG8gcmVzZXQgaXQNCj4gPj4+IGdp
dmVuIGl0J3Mgbm90IGluIHVzZS4NCj4gPj4+DQo+ID4+PiBSZXZpZXdlZC1ieTogS2V2aW4gVGlh
biA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ID4+PiBSZXZpZXdlZC1ieTogSmFzb24gR3VudGhv
cnBlIDxqZ2dAbnZpZGlhLmNvbT4NCj4gPj4+IFRlc3RlZC1ieTogWWFudGluZyBKaWFuZyA8eWFu
dGluZy5qaWFuZ0BpbnRlbC5jb20+DQo+ID4+PiBTaWduZWQtb2ZmLWJ5OiBZaSBMaXUgPHlpLmwu
bGl1QGludGVsLmNvbT4NCj4gPj4+IC0tLQ0KPiA+Pj4gIGRyaXZlcnMvdmZpby9wY2kvdmZpb19w
Y2lfY29yZS5jIHwgMTQgKysrKysrKysrKystLS0NCj4gPj4+ICBpbmNsdWRlL3VhcGkvbGludXgv
dmZpby5oICAgICAgICB8ICA4ICsrKysrKysrDQo+ID4+PiAgMiBmaWxlcyBjaGFuZ2VkLCAxOSBp
bnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiA+Pj4NCj4gPj4+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2NvcmUuYyBiL2RyaXZlcnMvdmZpby9wY2kvdmZpb19w
Y2lfY29yZS5jDQo+ID4+PiBpbmRleCA2NWJiZWY1NjIyNjguLjVkNzQ1YzlhYmYwNSAxMDA2NDQN
Cj4gPj4+IC0tLSBhL2RyaXZlcnMvdmZpby9wY2kvdmZpb19wY2lfY29yZS5jDQo+ID4+PiArKysg
Yi9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2NvcmUuYw0KPiA+Pj4gQEAgLTI0MjksMTAgKzI0
MjksMTggQEAgc3RhdGljIGludCB2ZmlvX3BjaV9kZXZfc2V0X2hvdF9yZXNldChzdHJ1Y3QNCj4g
Pj4gdmZpb19kZXZpY2Vfc2V0ICpkZXZfc2V0LA0KPiA+Pj4gIAlsaXN0X2Zvcl9lYWNoX2VudHJ5
KGN1cl92bWEsICZkZXZfc2V0LT5kZXZpY2VfbGlzdCwgdmRldi5kZXZfc2V0X2xpc3QpIHsNCj4g
Pj4+ICAJCS8qDQo+ID4+PiAtCQkgKiBUZXN0IHdoZXRoZXIgYWxsIHRoZSBhZmZlY3RlZCBkZXZp
Y2VzIGFyZSBjb250YWluZWQgYnkgdGhlDQo+ID4+PiAtCQkgKiBzZXQgb2YgZ3JvdXBzIHByb3Zp
ZGVkIGJ5IHRoZSB1c2VyLg0KPiA+Pj4gKwkJICogVGVzdCB3aGV0aGVyIGFsbCB0aGUgYWZmZWN0
ZWQgZGV2aWNlcyBjYW4gYmUgcmVzZXQgYnkgdGhlDQo+ID4+PiArCQkgKiB1c2VyLg0KPiA+Pj4g
KwkJICoNCj4gPj4+ICsJCSAqIFJlc2V0dGluZyBhbiB1bnVzZWQgZGV2aWNlIChub3Qgb3BlbmVk
KSBpcyBzYWZlLCBiZWNhdXNlDQo+ID4+PiArCQkgKiBkZXZfc2V0LT5sb2NrIGlzIGhlbGQgaW4g
aG90IHJlc2V0IHBhdGggc28gdGhpcyBkZXZpY2UNCj4gPj4+ICsJCSAqIGNhbm5vdCByYWNlIGJl
aW5nIG9wZW5lZCBieSBhbm90aGVyIHVzZXIgc2ltdWx0YW5lb3VzbHkuDQo+ID4+PiArCQkgKg0K
PiA+Pj4gKwkJICogT3RoZXJ3aXNlIGFsbCBvcGVuZWQgZGV2aWNlcyBpbiB0aGUgZGV2X3NldCBt
dXN0IGJlDQo+ID4+PiArCQkgKiBjb250YWluZWQgYnkgdGhlIHNldCBvZiBncm91cHMgcHJvdmlk
ZWQgYnkgdGhlIHVzZXIuDQo+ID4+PiAgCQkgKi8NCj4gPj4+IC0JCWlmICghdmZpb19kZXZfaW5f
Z3JvdXBzKGN1cl92bWEsIGdyb3VwcykpIHsNCj4gPj4+ICsJCWlmIChjdXJfdm1hLT52ZGV2Lm9w
ZW5fY291bnQgJiYNCj4gPj4+ICsJCSAgICAhdmZpb19kZXZfaW5fZ3JvdXBzKGN1cl92bWEsIGdy
b3VwcykpIHsNCj4gPj4+ICAJCQlyZXQgPSAtRUlOVkFMOw0KPiA+Pj4gIAkJCWdvdG8gZXJyX3Vu
ZG87DQo+ID4+PiAgCQl9DQo+ID4+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L3Zm
aW8uaCBiL2luY2x1ZGUvdWFwaS9saW51eC92ZmlvLmgNCj4gPj4+IGluZGV4IDA1NTJlOGRjZjBj
Yi4uZjk2ZTU2ODljZmZjIDEwMDY0NA0KPiA+Pj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L3Zm
aW8uaA0KPiA+Pj4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L3ZmaW8uaA0KPiA+Pj4gQEAgLTY3
Myw2ICs2NzMsMTQgQEAgc3RydWN0IHZmaW9fcGNpX2hvdF9yZXNldF9pbmZvIHsNCj4gPj4+ICAg
KiBWRklPX0RFVklDRV9QQ0lfSE9UX1JFU0VUIC0gX0lPVyhWRklPX1RZUEUsIFZGSU9fQkFTRSAr
IDEzLA0KPiA+Pj4gICAqCQkJCSAgICBzdHJ1Y3QgdmZpb19wY2lfaG90X3Jlc2V0KQ0KPiA+Pj4g
ICAqDQo+ID4+PiArICogVXNlcnNwYWNlIHJlcXVlc3RzIGhvdCByZXNldCBmb3IgdGhlIGRldmlj
ZXMgaXQgdXNlcy4gIER1ZSB0byB0aGUNCj4gPj4+ICsgKiB1bmRlcmx5aW5nIHRvcG9sb2d5LCBt
dWx0aXBsZSBkZXZpY2VzIGNhbiBiZSBhZmZlY3RlZCBpbiB0aGUgcmVzZXQNCj4gPj4gYnkgdGhl
IHJlc2V0DQo+ID4+PiArICogd2hpbGUgc29tZSBtaWdodCBiZSBvcGVuZWQgYnkgYW5vdGhlciB1
c2VyLiAgVG8gYXZvaWQgaW50ZXJmZXJlbmNlDQo+ID4+IHMvaW50ZXJmZXJlbmNlL2hvdCByZXNl
dCBmYWlsdXJlPw0KPiA+IEkgZG9u4oCZdCB0aGluayB1c2VyIGNhbiByZWFsbHkgYXZvaWQgaG90
IHJlc2V0IGZhaWx1cmUgc2luY2UgdGhlcmUgbWF5DQo+ID4gYmUgbmV3IGRldmljZXMgcGx1Z2dl
ZCBpbnRvIHRoZSBhZmZlY3RlZCBzbG90LiBFdmVuIHVzZXIgaGFzIG9wZW5lZA0KPiBJIGRvbid0
IGtub3cgdGhlIGxlZ2FjeSB3cnQgdGhhdCBpc3N1ZSBidXQgdGhpcyBzb3VuZHMgYSBzZXJpb3Vz
IGlzc3VlLA0KPiBtZWFuaW5nIHRoZSByZXNldCBvZiBhbiBhc3NpZ25lZCBkZXZpY2UgY291bGQg
aW1wYWN0IGFub3RoZXIgZGV2aWNlDQo+IGJlbG9uZ2luZyB0byBhbm90aGVyIGdyb3VwIG5vdCBu
b3Qgb3duZWQgYnkgdGhlIHVzZXI/DQoNCmJ1dCB0aGUgaG90IHJlc2V0IHNoYWxsIGZhaWwgYXMg
dGhlIGdyb3VwIGlzIG5vdCBvd25lZCBieSB0aGUgdXNlci4NCg0KPiA+IGFsbCB0aGUgZ3JvdXBz
L2RldmljZXMgcmVwb3J0ZWQgYnkgVkZJT19ERVZJQ0VfR0VUX1BDSV9IT1RfUkVTRVRfSU5GTywN
Cj4gPiB0aGUgaG90IHJlc2V0IGNhbiBmYWlsIGlmIG5ldyBkZXZpY2UgaXMgcGx1Z2dlZCBpbiBh
bmQgaGFzIG5vdCBiZWVuDQo+ID4gYm91bmQgdG8gdmZpbyBvciBvcGVuZWQgYnkgYW5vdGhlciB1
c2VyIGR1cmluZyB0aGUgd2luZG93IG9mDQo+ID4gX0lORk8gYW5kIEhPVF9SRVNFVC4NCj4gd2l0
aCByZXNwZWN0IHRvIHRoZSBsYXR0ZXIgaXNuJ3QgdGhlIGRldl9zZXQgbG9jayBoZWxkIGR1cmlu
ZyB0aGUgaG90DQo+IHJlc2V0IGFuZCBzdWZmaWNpZW50IHRvIHByZXZlbnQgYW55IG5ldyBvcGVu
aW5nIHRvIG9jY3VyPw0KDQp5ZXMuIG5ldyBvcGVuIG5lZWRzIHRvIGFjcXVpcmUgdGhlIGRldl9z
ZXQgbG9jay4gU28gd2hlbiBob3QgcmVzZXQNCmFjcXVpcmVzIHRoZSBkZXZfc2V0IGxvY2ssIHRo
ZW4gbm8gbmV3IG9wZW4gY2FuIG9jY3VyLiANCg0KUmVnYXJkcywNCllpIExpdQ0KDQo+ID4NCj4g
PiBtYXliZSB0aGUgd2hvbGUgc3RhdGVtZW50IHNob3VsZCBiZSBhcyBiZWxvdzoNCj4gPg0KPiA+
IFRvIGF2b2lkIGludGVyZmVyZW5jZSwgdGhlIGhvdCByZXNldCBjYW4gb25seSBiZSBjb25kdWN0
ZWQgd2hlbiBhbGwNCj4gPiB0aGUgYWZmZWN0ZWQgZGV2aWNlcyBhcmUgZWl0aGVyIG9wZW5lZCBi
eSB0aGUgY2FsbGluZyB1c2VyIG9yIG5vdA0KPiA+IG9wZW5lZCB5ZXQgYXQgdGhlIG1vbWVudCBv
ZiB0aGUgaG90IHJlc2V0IGF0dGVtcHQuDQo+IA0KPiBPSw0KPiANCj4gRXJpYw0KPiA+DQo+ID4+
PiArICogdGhlIGNhbGxpbmcgdXNlciBtdXN0IGVuc3VyZSBhbGwgYWZmZWN0ZWQgZGV2aWNlcywg
aWYgb3BlbmVkLCBhcmUNCj4gPj4+ICsgKiBvd25lZCBieSBpdHNlbGYuDQo+ID4+PiArICoNCj4g
Pj4+ICsgKiBUaGUgb3duZXJzaGlwIGlzIHByb3ZlZCBieSBhbiBhcnJheSBvZiBncm91cCBmZHMu
DQo+ID4+PiArICoNCj4gPj4+ICAgKiBSZXR1cm46IDAgb24gc3VjY2VzcywgLWVycm5vIG9uIGZh
aWx1cmUuDQo+ID4+PiAgICovDQo+ID4+PiAgc3RydWN0IHZmaW9fcGNpX2hvdF9yZXNldCB7DQo+
ID4gUmVnYXJkcywNCj4gPiBZaSBMaXUNCg0K
