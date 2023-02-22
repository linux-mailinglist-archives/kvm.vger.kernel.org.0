Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32C069F030
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 09:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbjBVI3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 03:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbjBVI3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 03:29:05 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE6F7A96;
        Wed, 22 Feb 2023 00:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677054531; x=1708590531;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fUxJ5qyWPJbdy+utXONJFTwLRRcX/b1wYb96TNI1vUU=;
  b=ELMY+1nZLRVrr9RgxQTG8Vs4qdP8MHZY/wfHXAN3tlBizkMx/EfFIlzn
   9FrW+baM1AxUnaeaeRURaxQWH5wJ3PMMqWwPHTY75OlnBnYfXhuW8Hv+L
   kLTIWwPHIIU4R847/If8fYgqBU85hd2ms4xfkrEV6jO1+VwGERcO8+8tz
   nTmB+ERvU2vTzzIav+W+Y4rgl7WxyYYoH/Kb9LPjCrLFdWfTAEbUPvZGD
   09BAx/l36gUxqvErA5jZhQqNYvDPBziO9sfsPIQ3z4CJjHibn+wxcTCpm
   S0JxGb11VkfYYMF8C7SL5MWf7GTWeJuh9odvL3kaH8L2cu4vdb9d+X6Y+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="321008193"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="321008193"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 00:28:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="814842628"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="814842628"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 22 Feb 2023 00:28:50 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 22 Feb 2023 00:28:50 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 22 Feb 2023 00:28:50 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 22 Feb 2023 00:28:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQOgPSQGKRrTZZUXNpns71S+AzCZasT5bFiX8w3v0lSMONIGZVWfjZvoM6JgslKp8uD43hncqH9WnAxM8eY6OXd8vnsA/JN6BzoF5Zed5TWvdWeHkWqTl17ATLu7iRGx9dHU3msfFxO0VTfEEYzuFfGwBl4CTrHDgc0tzw0RofUoGxEEL37TChI/gydPKDGSvZHZ1nnQDd8VLut1dxBie0X11Eq3xlwmitaiVAlV1VcEYWE+w7e6RQ9KTTH0JJOIgDZlw3MUezhWQhjhQND2gKIt7DrM2geP868UNoFZcEEx7mylm5XRwhKsJi2XwEONd1C7LoChQ+XhXXnfn8OBYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fUxJ5qyWPJbdy+utXONJFTwLRRcX/b1wYb96TNI1vUU=;
 b=YJiszCXjJcx4wgDPKsWAao2/c9ocAfVf3Bp0o0YoHinKGfVNl4JPGSzs3Gk9I06EqlwPjbDmp8cTEJK1Qt0YzvWh1otyGdO1RvPoQ2g1Zbu47tGFGikpUkrD0Bhq1EZy4VLLZq0PC+8bJVljzirqDozf8MJ99lhVuKgzT+hqf//ejyvu3ucWYBWQ+nlsRmg8CM7TPKDGvQUlzt6duENsmVWUz4GKQzJi+k3Q/aRinkIzFgZESEF5NyZ9ZUOYx/6UAfNGDFtBf5Vru+Y5SlIOSd2vH5ituwJxNoGvmO345OSvqayUZ5xA51D3ej8vGrseQZyyCQpSYynrZ+CvBowovQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA3PR11MB7583.namprd11.prod.outlook.com (2603:10b6:806:306::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Wed, 22 Feb
 2023 08:28:42 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%6]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 08:28:42 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v4 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v4 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZRadlPoyJ97Lj9Ei0xbUhG/v/kK7amhqAgAAH1lA=
Date:   Wed, 22 Feb 2023 08:28:42 +0000
Message-ID: <DS0PR11MB7529514D80EFAAF026610E8AC3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-17-yi.l.liu@intel.com>
 <Y/XJ5RsH+uivVUlH@yzhao56-desk.sh.intel.com>
In-Reply-To: <Y/XJ5RsH+uivVUlH@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA3PR11MB7583:EE_
x-ms-office365-filtering-correlation-id: 266f3c08-96b2-4917-9240-08db14aece5a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: loeeACOJuNv5wpjS/bhTG7kT++chJz35OuVCWgCpCAeT1CSLl/g+qRkOCYG/kBLLut40dLl6xUzy2yMhpvCoEY7bm+uywpyl1Y6Uvp/Yll3ThllgCwzlrNkKG6Yx276XVvy0PvdQ17VJNgZ+8vOUEXkGA3KswnHvXgzbk1at5n0CqVxkwMyLrMhfnBMSaioxJyE+ca8PbN/fLWWvr9u7AE5JnGB5PC9W4pnBm71Hflfey8pQ7wYYicC2G/mFd7NaQ4UpY50mtezXJu22W7E6qki9StDLT+rjIjSGlOe8BtxcafzHuTw7+k6TR8/k6Mhh5qgAQuVRdGsZPu97L0TEekyY4CmtZLJVY6AaLMqmNK4kQayml67205ZK0ff88/kH7LAgNQiXAwvPKJyVth5aBFIZ+b5Yjh5ApKTaIUaa9/EowDHg71Tet1q/XZU9hSA0ypH5kUdYpSzAb8O4OLPNPZmPF5fELRF/cBmutJ20MkZTxaHm6qKz/qJRKz69ffnjgK+VtwzxPv3c8BNMIzzeXyaJrvdX7GS+N58dTs6fzWxldUU/j5H0qD8eUTf9mOUppfC8xW9v+LDfyZLPH6BNEj4pVY4VxvflTFMcQlGpYpqfPB2sWH6leNVfvl1899ySRBgo91RqwylRybyZJtD+tPhn/4yRB6AgkqbqZuG1+XA1HuQhU96HN00OzNjgigwsQAdCLGGtGzr/a9W3OxiH/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199018)(9686003)(54906003)(6636002)(6862004)(82960400001)(8936002)(186003)(478600001)(71200400001)(316002)(33656002)(7696005)(66446008)(122000001)(66556008)(86362001)(64756008)(6506007)(4326008)(66476007)(66946007)(8676002)(83380400001)(38100700002)(41300700001)(7416002)(5660300002)(2906002)(52536014)(26005)(38070700005)(76116006)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXkxa0V2RzhmYmZWRjROZjI4WFhKejR1R0pSR25mbTJ6ZlJBbk5kcS9sNUhh?=
 =?utf-8?B?alhFd1ZLdU9SSms1NXFEWHJlWDV0SFNRMDZDNHMvZHJ4QW52VE5CYk55cEFs?=
 =?utf-8?B?SUdTWlViT3lET3NUUzBxRXM0SEgrUFQyOHpLVVNldVM0MDVYL2R3amh0bGJo?=
 =?utf-8?B?Tk5oaFVJZ1FHdENXVDh0RmQxS0pjemNST2EvR2lRWnI0N2hHLy9Fek9pS3ND?=
 =?utf-8?B?VzQzaW9yb0M2V3ZydURjVDhEU3lPbE50eHdMMVd0SXVEMnZOMEpnblB6RjBL?=
 =?utf-8?B?bDZ6U204a2IzK20wRk5EUWYxRW42YnVqVG01T3ZtNGFjQVIwb3dnZ05XWjFX?=
 =?utf-8?B?MnJWVDdZY3lKYVgxeHBhYVcwM0JUbnBid0F3US94dXhVMC9nSFQzUzRoSlpv?=
 =?utf-8?B?NFNxQU85UjBvamorcy93YWtjZi9YNHRwWXBLbnFMaVhNaGdaZk0zUkN1Y3NN?=
 =?utf-8?B?ODVScnB6WWNuTXllVXVJUWhkbll4aThGOEpyZXlSa0RtMTVlRWtYRC9EeWI4?=
 =?utf-8?B?OVFXN0JUQktRZ2ZPR3Rnblh3eEVMVzBWTjRFeG9BUTB5ZTgra2ZPZDlsanl3?=
 =?utf-8?B?VFFoSUYyc2xMWnhnNSsraUlQLzhIcFRrem16QzZMSitDcENPcWhTTzdZL2RO?=
 =?utf-8?B?bkZOVnk3blp4eTdxZW1IcmhDUllKQ01wcGxnUVR3bVFVSzlwZHZ3cXlWa1k5?=
 =?utf-8?B?YVJ1dnFDVmhjWlJ5SVU5aTl3eDRhUXJaUkQrdDNVcWM4aHZKcmROeGRxU0Q5?=
 =?utf-8?B?K3plMTU3MEhXejlQbDNkZlFqcnBCbDRCUHY2TWNEcTVnWDZxNjJsSkcwWDZi?=
 =?utf-8?B?Qmk3VitueWVrSjhZZUUzWndsNjhncm11OWM2VlhUNnVvdERtdnhCNUJ0Nncx?=
 =?utf-8?B?WjkyOU1TRDQzenRwL1VFczN6QlQzTzJIa0Y0WkFSQ2hIbHBaNTZhL0lwb1cv?=
 =?utf-8?B?UVlVOEladyt2M2JvWDZWakVIeE5nS3d2N3ZnMWtkSGljdWQ5WE82bmYrQmF6?=
 =?utf-8?B?djdXSHBVejU4QzdQMmJ4T2xpZVk5eWhza2NRbmlkQ1NVMzYwa0JZVWtkWFZ2?=
 =?utf-8?B?WUNmVTgxY05PK3lScitVdG5rRFpGM0J6a2ZzaEFDT01XVXdmOUc1VFZhSjVJ?=
 =?utf-8?B?d2d0eFRCZy8xcFN5Q3J4MFhCVDZad285SzdtOHdQSldwelZGVERvUndsbGZY?=
 =?utf-8?B?VWY1V242VnB2eGZsQVNreWpBdjdUVTJkMGE2RFpMWGNIM2JoWlo0Qk5aVTUr?=
 =?utf-8?B?SmZhOUlVTFV0eTZ6SzJ1aWJoUWoxTFppU1lvWkY2MC9peG0vTktzeW1sV01O?=
 =?utf-8?B?dU1aRmVLZzZBajlEdWtPS2RhL25ucWNtd25RbThoZDMvdmpDTXNJd2R6MjF5?=
 =?utf-8?B?ODBZakI5aExGN0VWYW9vZUd3VTNha0xPL2xNU0hqV1E2RkdscHkwNVVHMmdH?=
 =?utf-8?B?VkZlWjMxalVoQVFVcFZXdVNUZlBVVUZZT25BNnZQZHdkK3JlVjVjVUZpcGxu?=
 =?utf-8?B?TnR4cGwrNHp1YUtCNU9YSmFyY2JNaG91RHNHUXJJRDN4YWI4cVIwazdvdWRm?=
 =?utf-8?B?eEZUV1BmOFdMa29LRG55TEY2aE1JWXo3TWZDclF4VDh4T0N4RkJza0cvN1V4?=
 =?utf-8?B?NjlPeGwzSTBKTENmcWRWK3JHREE3RHBBdTNxaGNHS3JCekV2ajJMSE5LRnZH?=
 =?utf-8?B?cEkrVW1xS25INmpUbFN3V2lzV1h2SUxMc29VcGJYWjNIVUFDM29xQk8yT0ZX?=
 =?utf-8?B?OGdDZFdkS1BtcjVCbEpqMHJXanowd3VZelppdkhCR0NHZlpISmlSd0xLTTJu?=
 =?utf-8?B?U1lUK2dQSzJvb2RBZHp2OHNINkZRcHBJcUp2NTBteWJzeDRqQVZRaFNCazdH?=
 =?utf-8?B?VkdsWXBkOGZGUU44STZKTm1lK09Cc0VBQ2RaektVWDliWC9PeXRxTW8ySHho?=
 =?utf-8?B?K3BTVFR6RkhuQzNXcVlwRmlTOG82ZmxTUFE3RVhtMll2V0ttQ1V1dFdSTEhl?=
 =?utf-8?B?WGZQSkFrQW1tU0pMeDB6NlY1YUN0cS81TDFjV3hjSHVWUEFsUTllOGQ1d3c3?=
 =?utf-8?B?VE9zZWJBQzVkL2hUejZpMHBkdzZyZGdvV3g2WmtaTWtyUHlCdDNPaGNYRk1R?=
 =?utf-8?Q?uAg9Sp9+sK9ktuFgFXFOp6+92?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 266f3c08-96b2-4917-9240-08db14aece5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 08:28:42.1340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 08qa2eTprl/LWY2hg6BSqhiTM1hRm7fJEN0Qa4OcB6nEU7HRqsarbNoD4nIWToff+3BMHsRV+mf03a4rmWqSxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7583
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBaaGFvLCBZYW4gWSA8eWFuLnkuemhhb0BpbnRlbC5jb20+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgRmVicnVhcnkgMjIsIDIwMjMgMzo1MyBQTQ0KPiANCj4gT24gTW9uLCBGZWIgMjAsIDIw
MjMgYXQgMDc6NDg6MDlQTSAtMDgwMCwgWWkgTGl1IHdyb3RlOg0KPiA+IFRoaXMgYWRkcyBpb2N0
bCBmb3IgdXNlcnNwYWNlIHRvIGJpbmQgZGV2aWNlIGNkZXYgZmQgdG8gaW9tbXVmZC4NCj4gPg0K
PiA+ICAgICBWRklPX0RFVklDRV9CSU5EX0lPTU1VRkQ6IGJpbmQgZGV2aWNlIHRvIGFuIGlvbW11
ZmQsIGhlbmNlIGdhaW4NCj4gRE1BDQo+ID4gCQkJICAgICAgY29udHJvbCBwcm92aWRlZCBieSB0
aGUgaW9tbXVmZC4gb3Blbl9kZXZpY2UNCj4gPiAJCQkgICAgICBvcCBpcyBjYWxsZWQgYWZ0ZXIg
YmluZF9pb21tdWZkIG9wLg0KPiA+IAkJCSAgICAgIFZGSU8gbm8gaW9tbXUgbW9kZSBpcyBpbmRp
Y2F0ZWQgYnkgcGFzc2luZw0KPiA+IAkJCSAgICAgIGEgbmVnYXRpdmUgaW9tbXVmZCB2YWx1ZS4N
Cj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFlpIExpdSA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+
IC0tLQ0KPiA+ICBkcml2ZXJzL3ZmaW8vZGV2aWNlX2NkZXYuYyB8IDEzNw0KPiArKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIGRyaXZlcnMvdmZpby92ZmlvLmggICAg
ICAgIHwgIDE3ICsrKystDQo+ID4gIGRyaXZlcnMvdmZpby92ZmlvX21haW4uYyAgIHwgIDMwICsr
KysrKy0tDQo+ID4gIGluY2x1ZGUvbGludXgvaW9tbXVmZC5oICAgIHwgICA2ICsrDQo+ID4gIGlu
Y2x1ZGUvdWFwaS9saW51eC92ZmlvLmggIHwgIDM0ICsrKysrKysrKw0KPiA+ICA1IGZpbGVzIGNo
YW5nZWQsIDIxOSBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvdmZpby9kZXZpY2VfY2Rldi5jIGIvZHJpdmVycy92ZmlvL2RldmljZV9j
ZGV2LmMNCj4gPiBpbmRleCA5ZTJjMWVjYWFmNGYuLmJlNjJmMGE1Njg3ZSAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL3ZmaW8vZGV2aWNlX2NkZXYuYw0KPiA+ICsrKyBiL2RyaXZlcnMvdmZpby9k
ZXZpY2VfY2Rldi5jDQo+ID4gQEAgLTMsNiArMyw3IEBADQo+ID4gICAqIENvcHlyaWdodCAoYykg
MjAyMyBJbnRlbCBDb3Jwb3JhdGlvbi4NCj4gPiAgICovDQo+ID4gICNpbmNsdWRlIDxsaW51eC92
ZmlvLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9pb21tdWZkLmg+DQo+ID4NCj4gPiAgI2luY2x1
ZGUgInZmaW8uaCINCj4gPg0KPiA+IEBAIC00NSw2ICs0NiwxNDIgQEAgaW50IHZmaW9fZGV2aWNl
X2ZvcHNfY2Rldl9vcGVuKHN0cnVjdCBpbm9kZQ0KPiAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxl
cCkNCj4gPiAgCXJldHVybiByZXQ7DQo+ID4gIH0NCj4gPg0KPiA+ICtzdGF0aWMgdm9pZCB2Zmlv
X2RldmljZV9nZXRfa3ZtX3NhZmUoc3RydWN0IHZmaW9fZGV2aWNlX2ZpbGUgKmRmKQ0KPiA+ICt7
DQo+ID4gKwlzcGluX2xvY2soJmRmLT5rdm1fcmVmX2xvY2spOw0KPiA+ICsJaWYgKCFkZi0+a3Zt
KQ0KPiA+ICsJCWdvdG8gdW5sb2NrOw0KPiA+ICsNCj4gPiArCV92ZmlvX2RldmljZV9nZXRfa3Zt
X3NhZmUoZGYtPmRldmljZSwgZGYtPmt2bSk7DQo+ID4gKw0KPiA+ICt1bmxvY2s6DQo+ID4gKwlz
cGluX3VubG9jaygmZGYtPmt2bV9yZWZfbG9jayk7DQo+ID4gK30NCj4gPiArDQo+ID4gK3ZvaWQg
dmZpb19kZXZpY2VfY2Rldl9jbG9zZShzdHJ1Y3QgdmZpb19kZXZpY2VfZmlsZSAqZGYpDQo+ID4g
K3sNCj4gPiArCXN0cnVjdCB2ZmlvX2RldmljZSAqZGV2aWNlID0gZGYtPmRldmljZTsNCj4gPiAr
DQo+ID4gKwltdXRleF9sb2NrKCZkZXZpY2UtPmRldl9zZXQtPmxvY2spOw0KPiA+ICsJaWYgKCFz
bXBfbG9hZF9hY3F1aXJlKCZkZi0+YWNjZXNzX2dyYW50ZWQpKSB7DQo+ID4gKwkJbXV0ZXhfdW5s
b2NrKCZkZXZpY2UtPmRldl9zZXQtPmxvY2spOw0KPiA+ICsJCXJldHVybjsNCj4gPiArCX0NCj4g
PiArCXZmaW9fZGV2aWNlX2Nsb3NlKGRmKTsNCj4gPiArCXZmaW9fZGV2aWNlX3B1dF9rdm0oZGV2
aWNlKTsNCj4gPiArCWlmIChkZi0+aW9tbXVmZCkNCj4gPiArCQlpb21tdWZkX2N0eF9wdXQoZGYt
PmlvbW11ZmQpOw0KPiA+ICsJbXV0ZXhfdW5sb2NrKCZkZXZpY2UtPmRldl9zZXQtPmxvY2spOw0K
PiA+ICsJdmZpb19kZXZpY2VfdW5ibG9ja19ncm91cChkZXZpY2UpOw0KPiA+ICt9DQo+ID4gKw0K
PiA+ICtsb25nIHZmaW9fZGV2aWNlX2lvY3RsX2JpbmRfaW9tbXVmZChzdHJ1Y3QgdmZpb19kZXZp
Y2VfZmlsZSAqZGYsDQo+ID4gKwkJCQkgICAgdW5zaWduZWQgbG9uZyBhcmcpDQo+ID4gK3sNCj4g
PiArCXN0cnVjdCB2ZmlvX2RldmljZSAqZGV2aWNlID0gZGYtPmRldmljZTsNCj4gPiArCXN0cnVj
dCB2ZmlvX2RldmljZV9iaW5kX2lvbW11ZmQgYmluZDsNCj4gPiArCXN0cnVjdCBpb21tdWZkX2N0
eCAqaW9tbXVmZCA9IE5VTEw7DQo+ID4gKwlzdHJ1Y3QgZmQgZjsNCj4gPiArCXVuc2lnbmVkIGxv
bmcgbWluc3o7DQo+ID4gKwlpbnQgcmV0Ow0KPiA+ICsNCj4gPiArCW1pbnN6ID0gb2Zmc2V0b2Zl
bmQoc3RydWN0IHZmaW9fZGV2aWNlX2JpbmRfaW9tbXVmZCwgb3V0X2RldmlkKTsNCj4gPiArDQo+
ID4gKwlpZiAoY29weV9mcm9tX3VzZXIoJmJpbmQsICh2b2lkIF9fdXNlciAqKWFyZywgbWluc3op
KQ0KPiA+ICsJCXJldHVybiAtRUZBVUxUOw0KPiA+ICsNCj4gPiArCWlmIChiaW5kLmFyZ3N6IDwg
bWluc3ogfHwgYmluZC5mbGFncykNCj4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiArDQo+ID4g
KwlpZiAoIWRldmljZS0+b3BzLT5iaW5kX2lvbW11ZmQpDQo+ID4gKwkJcmV0dXJuIC1FTk9ERVY7
DQo+ID4gKw0KPiA+ICsJcmV0ID0gdmZpb19kZXZpY2VfYmxvY2tfZ3JvdXAoZGV2aWNlKTsNCj4g
PiArCWlmIChyZXQpDQo+ID4gKwkJcmV0dXJuIHJldDsNCj4gPiArDQo+ID4gKwltdXRleF9sb2Nr
KCZkZXZpY2UtPmRldl9zZXQtPmxvY2spOw0KPiA+ICsJLyoNCj4gPiArCSAqIElmIGFscmVhZHkg
YmVlbiBib3VuZCB0byBhbiBpb21tdWZkLCBvciBhbHJlYWR5IHNldCBub2lvbW11DQo+ID4gKwkg
KiB0aGVuIGZhaWwgaXQuDQo+ID4gKwkgKi8NCj4gPiArCWlmIChkZi0+aW9tbXVmZCB8fCBkZi0+
bm9pb21tdSkgew0KPiA+ICsJCXJldCA9IC1FSU5WQUw7DQo+ID4gKwkJZ290byBvdXRfdW5sb2Nr
Ow0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCS8qIGlvbW11ZmQgPCAwIG1lYW5zIG5vaW9tbXUgbW9k
ZSAqLw0KPiA+ICsJaWYgKGJpbmQuaW9tbXVmZCA8IDApIHsNCj4gPiArCQlpZiAoIWNhcGFibGUo
Q0FQX1NZU19SQVdJTykpIHsNCj4gPiArCQkJcmV0ID0gLUVQRVJNOw0KPiA+ICsJCQlnb3RvIG91
dF91bmxvY2s7DQo+ID4gKwkJfQ0KPiA+ICsJCWRmLT5ub2lvbW11ID0gdHJ1ZTsNCj4gPiArCX0g
ZWxzZSB7DQo+ID4gKwkJZiA9IGZkZ2V0KGJpbmQuaW9tbXVmZCk7DQo+ID4gKwkJaWYgKCFmLmZp
bGUpIHsNCj4gPiArCQkJcmV0ID0gLUVCQURGOw0KPiA+ICsJCQlnb3RvIG91dF91bmxvY2s7DQo+
ID4gKwkJfQ0KPiA+ICsJCWlvbW11ZmQgPSBpb21tdWZkX2N0eF9mcm9tX2ZpbGUoZi5maWxlKTsN
Cj4gPiArCQlpZiAoSVNfRVJSKGlvbW11ZmQpKSB7DQo+ID4gKwkJCXJldCA9IFBUUl9FUlIoaW9t
bXVmZCk7DQo+ID4gKwkJCWdvdG8gb3V0X3B1dF9maWxlOw0KPiA+ICsJCX0NCj4gPiArCX0NCj4g
PiArDQo+ID4gKwkvKg0KPiA+ICsJICogQmVmb3JlIHRoZSBkZXZpY2Ugb3BlbiwgZ2V0IHRoZSBL
Vk0gcG9pbnRlciBjdXJyZW50bHkNCj4gPiArCSAqIGFzc29jaWF0ZWQgd2l0aCB0aGUgZGV2aWNl
IGZpbGUgKGlmIHRoZXJlIGlzKSBhbmQgb2J0YWluIGENCj4gPiArCSAqIHJlZmVyZW5jZS4gVGhp
cyByZWZlcmVuY2UgaXMgaGVsZCB1bnRpbCBkZXZpY2UgY2xvc2VkLiBTYXZlDQo+ID4gKwkgKiB0
aGUgcG9pbnRlciBpbiB0aGUgZGV2aWNlIGZvciB1c2UgYnkgZHJpdmVycy4NCj4gPiArCSAqLw0K
PiA+ICsJdmZpb19kZXZpY2VfZ2V0X2t2bV9zYWZlKGRmKTsNCj4gPiArDQo+ID4gKwlkZi0+aW9t
bXVmZCA9IGlvbW11ZmQ7DQo+ID4gKwlyZXQgPSB2ZmlvX2RldmljZV9vcGVuKGRmLCAmYmluZC5v
dXRfZGV2aWQsIE5VTEwpOw0KPiA+ICsJaWYgKHJldCkNCj4gPiArCQlnb3RvIG91dF9wdXRfa3Zt
Ow0KPiA+ICsNCj4gPiArCXJldCA9IGNvcHlfdG9fdXNlcigodm9pZCBfX3VzZXIgKilhcmcgKw0K
PiA+ICsJCQkgICBvZmZzZXRvZmVuZChzdHJ1Y3QgdmZpb19kZXZpY2VfYmluZF9pb21tdWZkLA0K
PiBpb21tdWZkKSwNCj4gPiArCQkJICAgJmJpbmQub3V0X2RldmlkLA0KPiA+ICsJCQkgICBzaXpl
b2YoYmluZC5vdXRfZGV2aWQpKSA/IC1FRkFVTFQgOiAwOw0KPiA+ICsJaWYgKHJldCkNCj4gPiAr
CQlnb3RvIG91dF9jbG9zZV9kZXZpY2U7DQo+ID4gKw0KPiA+ICsJaWYgKGlvbW11ZmQpDQo+ID4g
KwkJZmRwdXQoZik7DQoNCkhlcmUgY2hlY2sgZi5maWxlDQoNCj4gPiArCWVsc2UgaWYgKGRmLT5u
b2lvbW11KQ0KPiA+ICsJCWRldl93YXJuKGRldmljZS0+ZGV2LCAidmZpby1ub2lvbW11IGRldmlj
ZSB1c2VkIGJ5IHVzZXINCj4gIg0KPiA+ICsJCQkgIiglczolZClcbiIsIGN1cnJlbnQtPmNvbW0s
DQo+IHRhc2tfcGlkX25yKGN1cnJlbnQpKTsNCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogUGFp
cmVkIHdpdGggc21wX2xvYWRfYWNxdWlyZSgpIGluIHZmaW9fZGV2aWNlX2ZvcHM6OmlvY3RsLw0K
PiA+ICsJICogcmVhZC93cml0ZS9tbWFwDQo+ID4gKwkgKi8NCj4gPiArCXNtcF9zdG9yZV9yZWxl
YXNlKCZkZi0+YWNjZXNzX2dyYW50ZWQsIHRydWUpOw0KPiA+ICsJbXV0ZXhfdW5sb2NrKCZkZXZp
Y2UtPmRldl9zZXQtPmxvY2spOw0KPiA+ICsNCj4gPiArCXJldHVybiAwOw0KPiA+ICsNCj4gPiAr
b3V0X2Nsb3NlX2RldmljZToNCj4gPiArCXZmaW9fZGV2aWNlX2Nsb3NlKGRmKTsNCj4gPiArb3V0
X3B1dF9rdm06DQo+ID4gKwlkZi0+aW9tbXVmZCA9IE5VTEw7DQo+ID4gKwlkZi0+bm9pb21tdSA9
IGZhbHNlOw0KPiA+ICsJdmZpb19kZXZpY2VfcHV0X2t2bShkZXZpY2UpOw0KPiA+ICtvdXRfcHV0
X2ZpbGU6DQo+ID4gKwlpZiAoaW9tbXVmZCkgew0KPiA+ICsJCWlvbW11ZmRfY3R4X3B1dChpb21t
dWZkKTsNCj4gPiArCQlmZHB1dChmKTsNCj4gZXZlbiBpZiBpb21tdWZkIGlzIE5VTEwsIHN0aWxs
IG5lZWQgdG8gZmRwdXQoZikgaWYgZi5maWxlIGlzIHRydWUsIHJpZ2h0Pw0KDQpZZXMuIGl0IGlz
LiBBbmQgYWxzbyBhbm90aGVyIGxpbmUgaW4gYWJvdmUuIPCfmIogbWF5IG5lZWQgdG8gd3JhcCB0
aGUNCmZkZ2V0KCkgYW5kIGlvbW11ZmRfY3R4X2Zyb21fZmlsZSgpIGludG8gYSBoZWxwZXIuIFNv
IGZkcHV0IGlzIGNhbGxlZA0KaW4gdGhlIGhlbHBlci4NCg0KPiA+ICsJfQ0KPiA+ICtvdXRfdW5s
b2NrOg0KPiA+ICsJbXV0ZXhfdW5sb2NrKCZkZXZpY2UtPmRldl9zZXQtPmxvY2spOw0KPiA+ICsJ
dmZpb19kZXZpY2VfdW5ibG9ja19ncm91cChkZXZpY2UpOw0KPiA+ICsJcmV0dXJuIHJldDsNCj4g
PiArfQ0KPiA+ICsNCg==
