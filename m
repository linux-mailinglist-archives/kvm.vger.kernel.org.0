Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6479170EB47
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 04:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239111AbjEXCU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 22:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239097AbjEXCU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 22:20:56 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B747C1;
        Tue, 23 May 2023 19:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684894855; x=1716430855;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t1RxgXtTe/p1f9KaNnUY0tUiIwDZzkwbEFjm1VG4J1E=;
  b=hRN03KN5eiQ1XRsNOATj24hpv6GH66obAd4e6LQYQPQ8Cp1Tc7y5zGRf
   7VQFM0WYGvg8rmafT30oVrc2WpOoViHx6hwvl5u2eBP0J23ablBPfoLYj
   NhO6GTmc0qBqqBuQw85wZivyH0nY3S6scLqgMplCHxUfu+oSQzDXX3/YG
   k2s9KTItXbK/d6uLi7WU0ADmWVfDMAMTbqPxzuNfytj5Tbk9UtralrfO7
   L8ZFfxTEx9L5JIjAXabnuqJ+M0HJo2ejsVP2EFh/fX3xrZUCMukwcUW99
   nSBoM9XsZpSNFETTdlWIK1lcLNmfyDA4yZjZm7mDH4Jmgq86MvlXAUJ3N
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="350937049"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="350937049"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 19:20:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="737119094"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="737119094"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 23 May 2023 19:20:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 19:20:49 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 23 May 2023 19:20:49 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 23 May 2023 19:20:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8kXcoziWMQ0kVQNNC44NXvMLN4Ny/0WmETnwI6Ct89m/rxy5Utg8eO91HmgAy4++seCPfRM4KFGvFXnj3APrunkxAsYRYVR/CaCQddaXnRmwG9JfG6tuHm5LZIMSWOePxN7Ed+98eziwI8eXCfwY/rCVwoed0w04ZA3KzeCC92se70mJjEdhTU3OljnwcKnz7t2biL+aoiZLx9t+j4qEI5tBj3W2/4mkoEld2lWWPLgWg9qfylBGIdxhYheyp6SE3gKzN+E/VBo7AcK60OB+A5/ZLLiw1xYXGm6K/ukAZSf3u2pTUUbwXrGk/0sWxWFqjIQwgz5s4Cr5K2cRRoPBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t1RxgXtTe/p1f9KaNnUY0tUiIwDZzkwbEFjm1VG4J1E=;
 b=RImhiPlCQcP53WoM6Oan2xsrV2vShL8u2EB93uWqlDUXE4GoFyPfDELlEG4mLxWwteIqK1rxXKXargO2A47mmsVNQtAHyM5SL/jtm+a7gFpgMNJYbrjSUQJvp+Syt2BFzzVXZyulXRBa+mHIvGR0MzUAcHWNTebnS9h37ACC7ea3DdbmQJRaXwdc2T5aMeWXKEAUlEK2Ee2LT5aWcN3JKJdJnAckE2k4DmV36EE/vrAaqusWF+/7E/TijCQ7SqZMANuSZnCak1pXdqzdcN1fex6IdjeaMUqE+XcIHribMg+/nXKp0/Ll4y9OVO2EqG5d5svfAEugwCrvadi8Vogvvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 02:20:47 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 02:20:47 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v11 19/23] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v11 19/23] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZhZ7k65TFikm5KUKI3FkaFFDbUK9m5qgAgAA8RCCAAO6sgIAArYHQ
Date:   Wed, 24 May 2023 02:20:46 +0000
Message-ID: <DS0PR11MB75292184D6938DF4193C318EC3419@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
        <20230513132827.39066-20-yi.l.liu@intel.com>
        <20230522160124.768430b4.alex.williamson@redhat.com>
        <DS0PR11MB752935BF70AC95B564685DC0C3409@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230523095121.1a7a255d.alex.williamson@redhat.com>
In-Reply-To: <20230523095121.1a7a255d.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MW3PR11MB4764:EE_
x-ms-office365-filtering-correlation-id: e5560128-b29b-4814-f69d-08db5bfd7c04
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zNhsujn/xLDWm8kr/mK09Qo/xOp8pLxos5rY+eAybUScwVia4yZ0ag/g6sYVsqCo64y/qY4+ZP3h/z3Sm8VfT72eWpC41+VPpRccUDmrX/mw86xVMh0nMAL/WyZVrLAX8/B/LjdCuL8mefB+eV07eGlal/PdQSm+KmlRtQj6mTtjpMBR1wF88h+IM2eI1xNR/1t1FaSNkskXkQtV0qI9QejWq1Q8GSs0xk8svClhIojuJ4HZcoubLb9Hm+iYv2EAJIGKtWsU5l32SWMwUzQ7mq0Xlhj7gI+y3GJAiSEstMU3z2by2EfWsM21uh0OQQ8DC6MwLEApdaRBLF+HSk9n/B/DLnSVxS16lpx0fYAzlgOMk/bIJH00kjFqgzQ8EReu+xLm/b0L1D6h4n9DDzB8WJVN4sGVwZyJ2HpVO9Ty7+Bg6DzYQVLgb323aXZ/OgDNvUdkZUePZsqo7Tc7NFu12kfWqXsd4p93pkZEf27V56CNNgCnr2qd+/fcDbG875Qxz3hnBfMUV2KIWqp+JXF84SdE8I8qLxdHsvL+YkUe3pFCU6Q2n8CMq+e897Pty3kJprEAviMj0VDLgfkt6O5EkNpxqNMc5OWHrocjUuSqhY6uDSqBAEDYPgVVbkoYanxw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(366004)(346002)(396003)(136003)(451199021)(76116006)(82960400001)(966005)(478600001)(38070700005)(83380400001)(4326008)(6916009)(66556008)(66446008)(66946007)(66476007)(64756008)(38100700002)(122000001)(54906003)(71200400001)(316002)(7696005)(41300700001)(86362001)(5660300002)(2906002)(55016003)(8676002)(8936002)(26005)(6506007)(9686003)(7416002)(186003)(52536014)(33656002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkRmODZnd3BxZWdBQTI4M1R0OHd4V3FpWVFnVmt5bUFLdHgvaHdKV2N2SUti?=
 =?utf-8?B?T09nOVpoaVNscFpVZUZSV0pVWXlKSHBFRVR3TkVwcUdrUU9UemtjM2NuZE5T?=
 =?utf-8?B?bzlXWkZPVXk5dXdQeG5haHBhRkE4RHhNTFdKeFQzdWVoSUFlSDdwa3MzSDA4?=
 =?utf-8?B?eWZGTTdEaXdBeGxWbVVXSy9ubkd1dkZLK0h2eW9ZSThKeklINVhGblFFa0lN?=
 =?utf-8?B?eUhyWWt2dUxrV1VBOXVIb09oMVNsTmNIbWE5UWNMank3V2NFY1VHcUUraE9j?=
 =?utf-8?B?N0QxN1ByVzZ2L21obG5uS3dxcWM1M0hMODU3QTJRb3lOdXdJWVVPMlJ4L3Vo?=
 =?utf-8?B?MGNOcVZtWmdZOHBDSnFMN08wa0oxZ3E3aDRnU3hQc1ZwYmNPM0VlNUUvbTNM?=
 =?utf-8?B?U2pLTzNKaE9WSlZ6VmNMQUZ5WEdFWUFMUmNaMWt5ZlBQYnFRWXBBMzJwZktW?=
 =?utf-8?B?eFlPaWxzZ0J1ZjV6azFoRlc2cGtnc2Q4S2RxWFJqbjY1TEVua3gzczBaR3I5?=
 =?utf-8?B?SEVQUmpzQW0velp4SWs5WnA1K0FYMjBwTmpwTXpjUllwVStBU2dNNWliV1Ba?=
 =?utf-8?B?TnhmOUI0QWNLYmRCMldIb3A0R2RJL2FZTEQ4NTZUZ0JRVXVTdHNCQ1lzcWtv?=
 =?utf-8?B?RWxPVGQ5MHVjays2V2U1UnM4bXY2U1JzYzBsbnVwM3lzbXRNZTYwdFpoaG9N?=
 =?utf-8?B?emZJMTh6RTFvalZZKzFNVExWNDVOYmpKUEMrcHBrRkZTdXlSY2NtZHhVZE9m?=
 =?utf-8?B?ODM5RVRzZGpzZk81WFlWSW1zZTdudFBFT2hCOVkrVDBRTkhLaG8wM1Z6d2Fu?=
 =?utf-8?B?bUJUbFAzbFdseWFEZnhTTWYzaGMxaFF3MHlEc3U3SVNRNFV5NXRrRmxid0ly?=
 =?utf-8?B?TElhOWdYVUxNT1hpYzJyYU5MWHRrWCtCMVQ2cW56SFBiWUd5WTIvLzZVSXda?=
 =?utf-8?B?elVCY00ydnhpaFpzdVJsdnladG1tbXViQTVESHVUdVJ0VVJpV2NIMEJLNU5h?=
 =?utf-8?B?MUtDWC9oeDkrcVp5TzVMU2JwNTFtWlI1Y3ROZTIwVDh4SnVaQWZHQ0R5bW96?=
 =?utf-8?B?UmlsNFQxWTFiSFBlY25SQ3hRWVhlQUpHRm1DUE9nU0lhU2JLR3Y5dUN3Nndh?=
 =?utf-8?B?M05aZ3N6Yitpc2lDcFJKMDRYQlpMdFpMRmpnSjRIVFRoVEEyZnBpZWRNcFJR?=
 =?utf-8?B?ZEZERnhNNGkxL3Z1a2dqY0RWa3VhcjVKTGJ3dlNjRzl6UU90YUlNbEluK1Fy?=
 =?utf-8?B?cWVvdWxjQjhKZ09pOG5PWGk4cVQ3dmtOUk1vQlRjTW4yOXBudEFzalZPbytx?=
 =?utf-8?B?T2tVSkJ6OHZJVnVlZFlqZ01kaldqbzVQYTI4eE4zQm01WWxvQ0lHU1dYSDFM?=
 =?utf-8?B?cFBYTnpsWlgzY0podjhDdSthcUtvWnFUWWpPaXlicHFIQTZ0NnZ4d3Y0T2Rk?=
 =?utf-8?B?OTJSTmNXK2g4ZHlkL2FxcGpGWExjOFpJSEwxdVZHNk1JS2ZDVlNsQ0E3dGtS?=
 =?utf-8?B?MVVTQ2RpTFAyZzMzY2htMSs5anNpalIzLzlyejN4WEVZNCtlYXp0d3oyK3pB?=
 =?utf-8?B?V1VHOFF1bG1Eckc0VFBKL1BFY2dDaWFNbW1ZU2dwVlY1WFdyWXdpNGJray9L?=
 =?utf-8?B?UkViekNFWEw5Y3JhaXVnYTVXR0dCaHd6Y1JvdzZpb1ZsNHQ0OStYQXBxNEtD?=
 =?utf-8?B?N0gzdmUyand5RU5Na2NycGpXYVZDNjdoZkp5aHBMSHI5N082WHFUcGNzNm0w?=
 =?utf-8?B?WlRXSmczYi9jWkdNY0NHSzJCaXBqdGppUy8wVTNZdlpXbG1ZVnhvc2J6Rnkx?=
 =?utf-8?B?WHVscFA2UElOeTVoRk9jQnYwQTVSVTFGK3A2MmhhL3RaWE1KWDd6bk5DN0hY?=
 =?utf-8?B?NWFkNmNVM2VTdGh6SVFFY3pCSVprVzdYaTdLblBXdFhxWmhSallSR2Urektm?=
 =?utf-8?B?WTFWd1hIV24yVndMTjBKYVk3M1Q0Y3RnbXIzOE9PQ2hQYWF6QkI3ZUFJQ0gy?=
 =?utf-8?B?d3lKTTROcHQweENuc2cyNndyczU3VmhJUUw4Zk83ckwxTENYVGk4ekF3KzQx?=
 =?utf-8?B?YlpqM3VaTlVwU0pUNG1OQVFGRVZ1djZMeldzb0QySUplU2dJenY2WEZLc1lO?=
 =?utf-8?Q?SOnR0fPv6IE11aP3zaF+He5pU?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5560128-b29b-4814-f69d-08db5bfd7c04
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 02:20:46.8028
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mVXljdGjbq88s0FtEebRs04gub3HaQMuiag6T3pzGns6RMLCdZNdMZYKdFBYTjiFcbDlJrLX/o5JtASTGOaAJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4764
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUdWVzZGF5LCBNYXkgMjMsIDIwMjMgMTE6NTEgUE0NCj4gDQo+IE9uIFR1ZSwgMjMgTWF5
IDIwMjMgMDE6NDE6MzYgKzAwMDANCj4gIkxpdSwgWWkgTCIgPHlpLmwubGl1QGludGVsLmNvbT4g
d3JvdGU6DQo+IA0KPiA+ID4gRnJvbTogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25A
cmVkaGF0LmNvbT4NCj4gPiA+IFNlbnQ6IFR1ZXNkYXksIE1heSAyMywgMjAyMyA2OjAxIEFNDQo+
ID4gPg0KPiA+ID4gT24gU2F0LCAxMyBNYXkgMjAyMyAwNjoyODoyMyAtMDcwMA0KPiA+ID4gWWkg
TGl1IDx5aS5sLmxpdUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+ID4NCj4gPiA+ID4gVGhpcyBhZGRz
IGlvY3RsIGZvciB1c2Vyc3BhY2UgdG8gYmluZCBkZXZpY2UgY2RldiBmZCB0byBpb21tdWZkLg0K
PiA+ID4gPg0KPiA+ID4gPiAgICAgVkZJT19ERVZJQ0VfQklORF9JT01NVUZEOiBiaW5kIGRldmlj
ZSB0byBhbiBpb21tdWZkLCBoZW5jZSBnYWluIERNQQ0KPiA+ID4gPiAJCQkgICAgICBjb250cm9s
IHByb3ZpZGVkIGJ5IHRoZSBpb21tdWZkLiBvcGVuX2RldmljZQ0KPiA+ID4gPiAJCQkgICAgICBv
cCBpcyBjYWxsZWQgYWZ0ZXIgYmluZF9pb21tdWZkIG9wLg0KPiA+ID4gPg0KPiA+ID4gPiBUZXN0
ZWQtYnk6IFlhbnRpbmcgSmlhbmcgPHlhbnRpbmcuamlhbmdAaW50ZWwuY29tPg0KPiA+ID4gPiBU
ZXN0ZWQtYnk6IFNoYW1lZXIgS29sb3RodW0gPHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlAaHVh
d2VpLmNvbT4NCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogWWkgTGl1IDx5aS5sLmxpdUBpbnRlbC5j
b20+DQo+ID4gPiA+IC0tLQ0KPiA+ID4gPiAgZHJpdmVycy92ZmlvL2RldmljZV9jZGV2LmMgfCAx
MzAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ID4gPiAgZHJpdmVy
cy92ZmlvL3ZmaW8uaCAgICAgICAgfCAgMTMgKysrKw0KPiA+ID4gPiAgZHJpdmVycy92ZmlvL3Zm
aW9fbWFpbi5jICAgfCAgIDUgKysNCj4gPiA+ID4gIGluY2x1ZGUvbGludXgvdmZpby5oICAgICAg
IHwgICAzICstDQo+ID4gPiA+ICBpbmNsdWRlL3VhcGkvbGludXgvdmZpby5oICB8ICAyOCArKysr
KysrKw0KPiA+ID4gPiAgNSBmaWxlcyBjaGFuZ2VkLCAxNzggaW5zZXJ0aW9ucygrKSwgMSBkZWxl
dGlvbigtKQ0KPiA+ID4gPg0KPiA+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL2Rldmlj
ZV9jZGV2LmMgYi9kcml2ZXJzL3ZmaW8vZGV2aWNlX2NkZXYuYw0KPiA+ID4gPiBpbmRleCAxYzY0
MDAxNmE4MjQuLjI5MWNjNjc4YTE4YiAxMDA2NDQNCj4gPiA+ID4gLS0tIGEvZHJpdmVycy92Zmlv
L2RldmljZV9jZGV2LmMNCj4gPiA+ID4gKysrIGIvZHJpdmVycy92ZmlvL2RldmljZV9jZGV2LmMN
Cj4gPiA+ID4gQEAgLTMsNiArMyw3IEBADQo+ID4gPiA+ICAgKiBDb3B5cmlnaHQgKGMpIDIwMjMg
SW50ZWwgQ29ycG9yYXRpb24uDQo+ID4gPiA+ICAgKi8NCj4gPiA+ID4gICNpbmNsdWRlIDxsaW51
eC92ZmlvLmg+DQo+ID4gPiA+ICsjaW5jbHVkZSA8bGludXgvaW9tbXVmZC5oPg0KPiA+ID4gPg0K
PiA+ID4gPiAgI2luY2x1ZGUgInZmaW8uaCINCj4gPiA+ID4NCj4gPiA+ID4gQEAgLTQ0LDYgKzQ1
LDEzNSBAQCBpbnQgdmZpb19kZXZpY2VfZm9wc19jZGV2X29wZW4oc3RydWN0IGlub2RlICppbm9k
ZSwgc3RydWN0DQo+ID4gPiBmaWxlICpmaWxlcCkNCj4gPiA+ID4gIAlyZXR1cm4gcmV0Ow0KPiA+
ID4gPiAgfQ0KPiA+ID4gPg0KPiA+ID4gPiArc3RhdGljIHZvaWQgdmZpb19kZXZpY2VfZ2V0X2t2
bV9zYWZlKHN0cnVjdCB2ZmlvX2RldmljZV9maWxlICpkZikNCj4gPiA+ID4gK3sNCj4gPiA+ID4g
KwlzcGluX2xvY2soJmRmLT5rdm1fcmVmX2xvY2spOw0KPiA+ID4gPiArCWlmIChkZi0+a3ZtKQ0K
PiA+ID4gPiArCQlfdmZpb19kZXZpY2VfZ2V0X2t2bV9zYWZlKGRmLT5kZXZpY2UsIGRmLT5rdm0p
Ow0KPiA+ID4gPiArCXNwaW5fdW5sb2NrKCZkZi0+a3ZtX3JlZl9sb2NrKTsNCj4gPiA+ID4gK30N
Cj4gPiA+ID4gKw0KPiA+ID4gPiArdm9pZCB2ZmlvX2RldmljZV9jZGV2X2Nsb3NlKHN0cnVjdCB2
ZmlvX2RldmljZV9maWxlICpkZikNCj4gPiA+ID4gK3sNCj4gPiA+ID4gKwlzdHJ1Y3QgdmZpb19k
ZXZpY2UgKmRldmljZSA9IGRmLT5kZXZpY2U7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwkvKg0KPiA+
ID4gPiArCSAqIEluIHRoZSB0aW1lIG9mIGNsb3NlLCB0aGVyZSBpcyBubyBjb250ZW50aW9uIHdp
dGggYW5vdGhlciBvbmUNCj4gPiA+ID4gKwkgKiBjaGFuZ2luZyB0aGlzIGZsYWcuICBTbyByZWFk
IGRmLT5hY2Nlc3NfZ3JhbnRlZCB3aXRob3V0IGxvY2sNCj4gPiA+ID4gKwkgKiBhbmQgbm8gc21w
X2xvYWRfYWNxdWlyZSgpIGlzIG9rLg0KPiA+ID4gPiArCSAqLw0KPiA+ID4gPiArCWlmICghZGYt
PmFjY2Vzc19ncmFudGVkKQ0KPiA+ID4gPiArCQlyZXR1cm47DQo+ID4gPiA+ICsNCj4gPiA+ID4g
KwltdXRleF9sb2NrKCZkZXZpY2UtPmRldl9zZXQtPmxvY2spOw0KPiA+ID4gPiArCXZmaW9fZGV2
aWNlX2Nsb3NlKGRmKTsNCj4gPiA+ID4gKwl2ZmlvX2RldmljZV9wdXRfa3ZtKGRldmljZSk7DQo+
ID4gPiA+ICsJaW9tbXVmZF9jdHhfcHV0KGRmLT5pb21tdWZkKTsNCj4gPiA+ID4gKwlkZXZpY2Ut
PmNkZXZfb3BlbmVkID0gZmFsc2U7DQo+ID4gPiA+ICsJbXV0ZXhfdW5sb2NrKCZkZXZpY2UtPmRl
dl9zZXQtPmxvY2spOw0KPiA+ID4gPiArCXZmaW9fZGV2aWNlX3VuYmxvY2tfZ3JvdXAoZGV2aWNl
KTsNCj4gPiA+ID4gK30NCj4gPiA+ID4gKw0KPiA+ID4gPiArc3RhdGljIHN0cnVjdCBpb21tdWZk
X2N0eCAqdmZpb19nZXRfaW9tbXVmZF9mcm9tX2ZkKGludCBmZCkNCj4gPiA+ID4gK3sNCj4gPiA+
ID4gKwlzdHJ1Y3QgaW9tbXVmZF9jdHggKmlvbW11ZmQ7DQo+ID4gPiA+ICsJc3RydWN0IGZkIGY7
DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwlmID0gZmRnZXQoZmQpOw0KPiA+ID4gPiArCWlmICghZi5m
aWxlKQ0KPiA+ID4gPiArCQlyZXR1cm4gRVJSX1BUUigtRUJBREYpOw0KPiA+ID4gPiArDQo+ID4g
PiA+ICsJaW9tbXVmZCA9IGlvbW11ZmRfY3R4X2Zyb21fZmlsZShmLmZpbGUpOw0KPiA+ID4gPiAr
DQo+ID4gPiA+ICsJZmRwdXQoZik7DQo+ID4gPiA+ICsJcmV0dXJuIGlvbW11ZmQ7DQo+ID4gPiA+
ICt9DQo+ID4gPiA+ICsNCj4gPiA+ID4gK2xvbmcgdmZpb19kZXZpY2VfaW9jdGxfYmluZF9pb21t
dWZkKHN0cnVjdCB2ZmlvX2RldmljZV9maWxlICpkZiwNCj4gPiA+ID4gKwkJCQkgICAgc3RydWN0
IHZmaW9fZGV2aWNlX2JpbmRfaW9tbXVmZCBfX3VzZXIgKmFyZykNCj4gPiA+ID4gK3sNCj4gPiA+
ID4gKwlzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSA9IGRmLT5kZXZpY2U7DQo+ID4gPiA+ICsJ
c3RydWN0IHZmaW9fZGV2aWNlX2JpbmRfaW9tbXVmZCBiaW5kOw0KPiA+ID4gPiArCXVuc2lnbmVk
IGxvbmcgbWluc3o7DQo+ID4gPiA+ICsJaW50IHJldDsNCj4gPiA+ID4gKw0KPiA+ID4gPiArCXN0
YXRpY19hc3NlcnQoX19zYW1lX3R5cGUoYXJnLT5vdXRfZGV2aWQsIGRmLT5kZXZpZCkpOw0KPiA+
ID4gPiArDQo+ID4gPiA+ICsJbWluc3ogPSBvZmZzZXRvZmVuZChzdHJ1Y3QgdmZpb19kZXZpY2Vf
YmluZF9pb21tdWZkLCBvdXRfZGV2aWQpOw0KPiA+ID4gPiArDQo+ID4gPiA+ICsJaWYgKGNvcHlf
ZnJvbV91c2VyKCZiaW5kLCBhcmcsIG1pbnN6KSkNCj4gPiA+ID4gKwkJcmV0dXJuIC1FRkFVTFQ7
DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwlpZiAoYmluZC5hcmdzeiA8IG1pbnN6IHx8IGJpbmQuZmxh
Z3MgfHwgYmluZC5pb21tdWZkIDwgMCkNCj4gPiA+ID4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ID4g
PiA+ICsNCj4gPiA+ID4gKwkvKiBCSU5EX0lPTU1VRkQgb25seSBhbGxvd2VkIGZvciBjZGV2IGZk
cyAqLw0KPiA+ID4gPiArCWlmIChkZi0+Z3JvdXApDQo+ID4gPiA+ICsJCXJldHVybiAtRUlOVkFM
Ow0KPiA+ID4gPiArDQo+ID4gPiA+ICsJaWYgKHZmaW9fZGV2aWNlX2lzX25vaW9tbXUoZGV2aWNl
KSAmJiAhY2FwYWJsZShDQVBfU1lTX1JBV0lPKSkNCj4gPiA+ID4gKwkJcmV0dXJuIC1FUEVSTTsN
Cj4gPiA+ID4gKw0KPiA+ID4gPiArCXJldCA9IHZmaW9fZGV2aWNlX2Jsb2NrX2dyb3VwKGRldmlj
ZSk7DQo+ID4gPiA+ICsJaWYgKHJldCkNCj4gPiA+ID4gKwkJcmV0dXJuIHJldDsNCj4gPiA+ID4g
Kw0KPiA+ID4gPiArCW11dGV4X2xvY2soJmRldmljZS0+ZGV2X3NldC0+bG9jayk7DQo+ID4gPiA+
ICsJLyogb25lIGRldmljZSBjYW5ub3QgYmUgYm91bmQgdHdpY2UgKi8NCj4gPiA+ID4gKwlpZiAo
ZGYtPmFjY2Vzc19ncmFudGVkKSB7DQo+ID4gPiA+ICsJCXJldCA9IC1FSU5WQUw7DQo+ID4gPiA+
ICsJCWdvdG8gb3V0X3VubG9jazsNCj4gPiA+ID4gKwl9DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwlk
Zi0+aW9tbXVmZCA9IHZmaW9fZ2V0X2lvbW11ZmRfZnJvbV9mZChiaW5kLmlvbW11ZmQpOw0KPiA+
ID4gPiArCWlmIChJU19FUlIoZGYtPmlvbW11ZmQpKSB7DQo+ID4gPiA+ICsJCXJldCA9IFBUUl9F
UlIoZGYtPmlvbW11ZmQpOw0KPiA+ID4gPiArCQlkZi0+aW9tbXVmZCA9IE5VTEw7DQo+ID4gPiA+
ICsJCWdvdG8gb3V0X3VubG9jazsNCj4gPiA+ID4gKwl9DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwkv
Kg0KPiA+ID4gPiArCSAqIEJlZm9yZSB0aGUgZGV2aWNlIG9wZW4sIGdldCB0aGUgS1ZNIHBvaW50
ZXIgY3VycmVudGx5DQo+ID4gPiA+ICsJICogYXNzb2NpYXRlZCB3aXRoIHRoZSBkZXZpY2UgZmls
ZSAoaWYgdGhlcmUgaXMpIGFuZCBvYnRhaW4NCj4gPiA+ID4gKwkgKiBhIHJlZmVyZW5jZS4gIFRo
aXMgcmVmZXJlbmNlIGlzIGhlbGQgdW50aWwgZGV2aWNlIGNsb3NlZC4NCj4gPiA+ID4gKwkgKiBT
YXZlIHRoZSBwb2ludGVyIGluIHRoZSBkZXZpY2UgZm9yIHVzZSBieSBkcml2ZXJzLg0KPiA+ID4g
PiArCSAqLw0KPiA+ID4gPiArCXZmaW9fZGV2aWNlX2dldF9rdm1fc2FmZShkZik7DQo+ID4gPiA+
ICsNCj4gPiA+ID4gKwlyZXQgPSB2ZmlvX2RldmljZV9vcGVuKGRmKTsNCj4gPiA+ID4gKwlpZiAo
cmV0KQ0KPiA+ID4gPiArCQlnb3RvIG91dF9wdXRfa3ZtOw0KPiA+ID4gPiArDQo+ID4gPiA+ICsJ
cmV0ID0gY29weV90b191c2VyKCZhcmctPm91dF9kZXZpZCwgJmRmLT5kZXZpZCwNCj4gPiA+ID4g
KwkJCSAgIHNpemVvZihkZi0+ZGV2aWQpKSA/IC1FRkFVTFQgOiAwOw0KPiA+ID4gPiArCWlmIChy
ZXQpDQo+ID4gPiA+ICsJCWdvdG8gb3V0X2Nsb3NlX2RldmljZTsNCj4gPiA+ID4gKw0KPiA+ID4g
PiArCS8qDQo+ID4gPiA+ICsJICogUGFpcmVkIHdpdGggc21wX2xvYWRfYWNxdWlyZSgpIGluIHZm
aW9fZGV2aWNlX2ZvcHM6OmlvY3RsLw0KPiA+ID4gPiArCSAqIHJlYWQvd3JpdGUvbW1hcA0KPiA+
ID4gPiArCSAqLw0KPiA+ID4gPiArCXNtcF9zdG9yZV9yZWxlYXNlKCZkZi0+YWNjZXNzX2dyYW50
ZWQsIHRydWUpOw0KPiA+ID4gPiArCWRldmljZS0+Y2Rldl9vcGVuZWQgPSB0cnVlOw0KPiA+ID4g
PiArCW11dGV4X3VubG9jaygmZGV2aWNlLT5kZXZfc2V0LT5sb2NrKTsNCj4gPiA+ID4gKw0KPiA+
ID4gPiArCWlmICh2ZmlvX2RldmljZV9pc19ub2lvbW11KGRldmljZSkpDQo+ID4gPiA+ICsJCWRl
dl93YXJuKGRldmljZS0+ZGV2LCAibm9pb21tdSBkZXZpY2UgaXMgYm91bmQgdG8gaW9tbXVmZCBi
eSB1c2VyDQo+ID4gPiAiDQo+ID4gPiA+ICsJCQkgIiglczolZClcbiIsIGN1cnJlbnQtPmNvbW0s
IHRhc2tfcGlkX25yKGN1cnJlbnQpKTsNCj4gPiA+DQo+ID4gPiBUaGUgbm9pb21tdSBrZXJuZWwg
dGFpbnQgb25seSBoYXBwZW5zIGluIHZmaW9fZ3JvdXBfZmluZF9vcl9hbGxvYygpLCBzbw0KPiA+
ID4gaG93IGRvZXMgbm9pb21tdSB0YWludCB0aGUga2VybmVsIHdoZW4gIUNPTkZJR19WRklPX0dS
T1VQPw0KPiA+DQo+ID4gWWVhaCwgaW4gdGhlIGNkZXYgcGF0aCwgbm8gdGFpbnQuIEkgYWRkIHRo
aXMganVzdCBpbiBvcmRlciB0byBwYXIgd2l0aCB0aGUgYmVsb3cNCj4gPiBtZXNzYWdlIGluIHRo
ZSBncm91cCBwYXRoLg0KPiA+DQo+ID4gdmZpb19kZXZpY2Vfb3Blbl9maWxlKCkNCj4gPiB7DQo+
ID4gCWRldl93YXJuKGRldmljZS0+ZGV2LCAidmZpby1ub2lvbW11IGRldmljZSBvcGVuZWQgYnkg
dXNlciAiDQo+ID4gCQkgICAiKCVzOiVkKVxuIiwgY3VycmVudC0+Y29tbSwgdGFza19waWRfbnIo
Y3VycmVudCkpOw0KPiA+IH0NCj4gDQo+IFRoZXJlIG5lZWRzIHRvIGJlIGEgdGFpbnQgd2hlbiBW
RklPX0dST1VQIGlzIGRpc2FibGVkLiAgVGhhbmtzLA0KSSBzZWUuIEkgbWlzdW5kZXJzdG9vZCB5
b3UuIFlvdSBhcmUgYXNraW5nIGZvciBhIHRhaW50LiDwn5iKDQoNCkFjdHVhbGx5LCBJJ3ZlIGNv
bnNpZGVyZWQgaXQuIEJ1dCBpdCBhcHBlYXJzIHRvIG1lIHRoZSB0YWludCBpbg0KdmZpb19ncm91
cF9maW5kX29yX2FsbG9jKCkgaXMgZHVlIHRvIHZmaW8gYWxsb2NhdGVzIGZha2UgaW9tbXVfZ3Jv
dXAuDQpUaGlzIHNlZW1zIHRvIGJlIGEgdGFpbnQgdG8ga2VybmVsLiBCdXQgbm93LCB5b3UgYXJl
IHN1Z2dlc3RpbmcgdG8gYWRkDQphIHRhaW50IGFzIGxvbmcgYXMgbm9pb21tdSBkZXZpY2UgaXMg
cmVnaXN0ZXJlZCB0byB2ZmlvLiBJcyBpdD8gSWYgc28sDQp0aGUgdGFpbnQgbWF5IGJlIGFkZGVk
IHRvIHRoZSBuZXcgaGVscGVyIHRoYXQgd2UgYXJlIGRpc2N1c3NpbmcgaW4NCnBhdGNoIDIxIG9m
IHRoaXMgc2VyaWVzLiBbMV0gPyANCg0KWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS8y
MDIzMDUyMjE3MDQyOS4yZDVjYTI3NC5hbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbS8NCg0KDQpS
ZWdhcmRzLA0KWWkgTGl1DQoNCg==
