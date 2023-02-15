Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B756977A3
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 08:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbjBOHyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 02:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjBOHyo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 02:54:44 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFF929E18;
        Tue, 14 Feb 2023 23:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676447681; x=1707983681;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mKYl/i8aCH8digmq1mpPV+lFU8CCI/o74PWSFCELbLA=;
  b=aM8+r++n8qRyZcL1ut13XIFFC8Lwfl7uwLZyLZOtul9hqdU4Ok/dLcot
   b/TmwceiBWLq+PcoOtHHzN97GgToKJbbobon/xRn4VdTWQS48PDW47x7u
   0rx0Twh1GJCBT5wt9fYdtPJIbPAA4xfmhc2h/b4sJnvsgMd4D3tuTcJoj
   7YA+01QtkmHoaDKVY2LxncGZdQTXQUASSjXXKQZbaRW7DTTom5F3aRQTM
   UjUzJ5mdujiQlHbCHanjJbn2o2AuhwGCnqxbtQRflMKkqpDcLH4oP69O/
   A27R2mNrfjp+mD7pHdNgeIb0JAhZ43dmGug25x19sutGH22P/omZZQKoh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="329087194"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="329087194"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 23:54:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="793407432"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="793407432"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 14 Feb 2023 23:54:40 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 23:54:40 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 23:54:40 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 23:54:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g443a49M/VKZvjzKPrKto6cQQ3ILgSX7kmTRpGMsGURqJ4TQOR/kKm0xyy8+jhR+8wvzTKRq7+5xclQ/31I3pqvdXji+6be7qCmXu+jb/mUO+g3amDOONordHc53VFRGEGEfRnCAJIJlat3m1Wg8vbhLbhGil1ZcPe1p+I0sSf5pUDSUiFfTZuqC0iA/oWVK2XBKnakpEF2s/j4mU3B3FQLMPIAXCla3h0svLsuGft5FRvLrS/hiDsV+fqgg3PfO1uBc35N/jZs0yCQJWST7LIPPWcZNVSrleHP3a+zWtC9O4OY0ZN/eYhXzK/enaXdCpo4bMqEO82uo1SRYhFZEJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKYl/i8aCH8digmq1mpPV+lFU8CCI/o74PWSFCELbLA=;
 b=Y6XEHFD8RF+ebUiWiSjSeAvP7cKKbpZfFulEoU59GTZ2uhvpWbFGteqH65BHX1R3dAeJypFD88Maaa5JiO4f4BvMnDN2T4BV/UCFkQg3J9V8BJtDk9PTqfY4jK/rWuPNtgiDYZ6mZROnYLsk1KAWPDW7kD0W0NStt6Rlp/m1NkQPRvCelr06dYUAC+ZyybZG19CoZpHUSwpq6Dfzzs137yJcSNASmAK2SVMWv5+QLC18bF46cwk+E7UfwXfMyhEmk/FSy3PqOi44EhRVwzzZLubmAulK7BnKRkC0jfjRIxPxQ17LypMNBLymg5e9oH4afLkxMkRb0WuGtUiFsp51Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BN9PR11MB5291.namprd11.prod.outlook.com (2603:10b6:408:118::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 07:54:32 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 07:54:32 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v3 00/15] Add vfio_device cdev for iommufd support
Thread-Topic: [PATCH v3 00/15] Add vfio_device cdev for iommufd support
Thread-Index: AQHZP73MTR3br74MlEe91B7qYhP/Qq7NSHqAgABiBDCAAO1EAIABCYRQ
Date:   Wed, 15 Feb 2023 07:54:31 +0000
Message-ID: <DS0PR11MB7529CFCE99E8A77AAC76DC7CC3A39@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
        <20230213124719.126eb828.alex.williamson@redhat.com>
        <DS0PR11MB75298788BCA03FD9513F991AC3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230214084720.74b3574e.alex.williamson@redhat.com>
In-Reply-To: <20230214084720.74b3574e.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BN9PR11MB5291:EE_
x-ms-office365-filtering-correlation-id: 6a0e4d67-717c-42b3-b37e-08db0f29df76
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J44Cfvkk0BLFeQY5YC4Tnzdpk0789mYfd2tojAoWt4hP0yTTFMqEq0drNlidowjDUaKupFMNKuiJDh61fpBzd74gQp5LFnwsL6aLvhmnz4Zn72flfDzSZEeU1InooU3JNK+IY46AwEhjr+ZNed6rv+s25kRJWP2VsapKd6QV7vCCXd+E42XbgDDWQXAmyz1jPSXH/1zpUU9wF4p7xaCZelmsQaZWvVkIREijSfaTZDdFL0Ik84DA6DiLk8afurcpU0pTLJFDV+NuDGujKJjtyiUZBwG90NKZNJSSG2/3+rzKJnQK3QkQMgExfHrFW6VBEaNsAZgBxqI5k25mXPNwlh+XHb5YQvsylkqqTgpbkogMvB/13WYPLLSct+Jc/o7V018XiZQlompzMJckKBHsUzl8tJ7D3Nx+GgPaKkkFvTp3SwIfXK5WpGn/7ASdp74MRz2zzZzNb/pn+jC/NurgGPhg3WVL+mqNNSRa2KYx+aO3PQqjz1O3IWFTLL2NH4U5yoF5xvhk9bpeA6Ffi5+Nkhvbrz/ZARF6X+TdD3ukP7CLuoc/zIXbBPq2aV5HwF/pwUkrM01pFT56xwY9w52N9BYzaM+q5xpt7Wwi1Of986EDbO1yanGICIhvTkadY+FD2kUYp20jnrSGcnnAyzErXspTZ5bsMd2EoO3qis2aXySS1Ol6JJUIpGNb9vXMJJ12Oq1B8GxFfm5dSuWcCPNrDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(39860400002)(376002)(396003)(136003)(451199018)(8936002)(7416002)(52536014)(41300700001)(5660300002)(2906002)(966005)(7696005)(66556008)(8676002)(4326008)(6916009)(64756008)(66446008)(66476007)(66946007)(316002)(76116006)(54906003)(478600001)(82960400001)(122000001)(55016003)(38100700002)(38070700005)(71200400001)(26005)(33656002)(9686003)(6506007)(186003)(86362001)(83380400001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bFl6R0RyMWhNQkk1dmxrWHd2bmY5NjZKMytIRmdxM1ZxbkRWQTRlVXdWTWJt?=
 =?utf-8?B?dkVmWHRHSVFZWGtucExTNDcrQjhnMnEySHB6WWNlc25wbS9sTDErVVljWjFo?=
 =?utf-8?B?alJUenhlcTI0RVFTM2h2d3VLVGtKMmtod2xNTVpiYWJPZ2VhRHNMOElYdEZs?=
 =?utf-8?B?SStDUTYxODhZVklab09xQmxQWHpmbGtyYUFmL0dCRkVvOUpQTkd4Y3VqZjRu?=
 =?utf-8?B?TXNOL2dqTzgzSzM2eDZoTmszWmhSYTBsL0NUNzBzY1FPTmx2Z1VWd0lRS3Nl?=
 =?utf-8?B?T0VKaWk1YjNiU256T1pZYzZPcWVQV1p3cmNGUklCZ0YvWGJaMXhWS2FDNUV2?=
 =?utf-8?B?WnlKSmMwejZYcVd3c2pBNk5nSnJsOVhZa0hoRldrMGtOY2p3RGIrMDk3eUpT?=
 =?utf-8?B?L1ZMSG5DSjd0Nm91TytRYWV5d1poY3ZvM3h6QWxsWjl1T1JlODhQUkU3R3NL?=
 =?utf-8?B?ZDNCMHFZamY2blZxYVJyeWVaOG9BaEhLdWlaeHBjZjhpbTJpTi9ZWVBFODhu?=
 =?utf-8?B?eFZCcHo5L3VjSFU1MTFoV1NIeGc3RlVmcG51cEpDZi9lNWhabUlKN0lyMkE1?=
 =?utf-8?B?MUFYOFlxL2pwMUxLKzQyaDVIempGM3NxTkNOdjNmQVQ0Uk9vYTVuQ2ZRNTFO?=
 =?utf-8?B?ei81SHFIQnF2cUtPL1IwdlFUYUN4OXQ4YThibzNjQ3VXYncyV3RLcXd0Y2E5?=
 =?utf-8?B?eVpyYXUrSWoweFZKWmExYnhlUFozRStaUENJZWl2MUdyN25nMzlMWHZabzUy?=
 =?utf-8?B?dVM1SkJHSWJ1NnFBTHJRb3V0ZnAveHcyc21OS01jR2VFbUdjQnVVeVUydWdz?=
 =?utf-8?B?TFVZem1SZlpkSUVPa0RnZmIxZVJYQVBnQmkzSURVK1d1cmNPR0crTG9JUHRU?=
 =?utf-8?B?amRCdlNjMnJPVXhXMmV4UHNzS2hrVGRiazZTNGZwTEY4T2MxQTVha2VmeWh4?=
 =?utf-8?B?VGh1YXlmKzhFMWFEYmx1bGR6WVhSdzBvd0YwVC9MRjNBUjB3WjdzcExZSVdO?=
 =?utf-8?B?dUlpdE5qcWY2S09rM1Q4QS9wbEFtcE1TVjh6a2phKy9aaitOZ2lGVklyd1Mr?=
 =?utf-8?B?V0MrcTlQM3J3ZTdmTlEzaUkxVkRBRDAyeDFmc3pLaDNpK2NMUWhoYlBMSndZ?=
 =?utf-8?B?cXNia09XWnZYeXU1bnhLME1sZHdLZERNb2kxVHkrbHUrR0w5RmROT3dlT3dr?=
 =?utf-8?B?M0tXdTdaSVp6Zm9KUTlHMDY1TjE0WExkNGxLanhGVlBJMnZORkJlT2JOOEhy?=
 =?utf-8?B?TkJhN2Flem92RDFnSUhXYU9aVEFLcC9wRlZoWG5aaGpPTzZ0WVFiRFhGTzhP?=
 =?utf-8?B?cUpCMTUzYS9SdkpQMWg2NGRpTjlPZG1mK1hTbEtGOC9VK2VGVGNHOUJZdHF5?=
 =?utf-8?B?T0pvVUhmWStlN1VEY2toa3NueTAzVUhOdkVJK0lDN2EycTZNUEJDcWoyNDJk?=
 =?utf-8?B?Rld0Sy9WSnpVdzJveVYxY29GZHZReVdmOWllTkhneStRemF6R3NJWWEyTDVD?=
 =?utf-8?B?eHR5WmVFMDJiS1YvWGxvdjI0a2ZVVWRyckJLOHp1WE5weW5lbTdUd3JIVU5z?=
 =?utf-8?B?aE4yV0ZQNHNvMERjazVXSlM2b2wyczlYeDM0YmZzL3hEdFM2SG8wOTdGNUFn?=
 =?utf-8?B?bnJQL050UnE2WnhwVHZDMDdtenFJRDVqeVd3dzJwOHM2cUJ3d1Z1Tnk4UE1n?=
 =?utf-8?B?ejNQbGE2NDdGb1NhZkg1RVVleEk1MjltSGNXUUhBRXc5TkRubldZaDhtYkNr?=
 =?utf-8?B?eDVvY2Y0M2xMUmhoS1VWSVFFOXFVM3N0V0plMW9XZmxjaVZwNXllRnVlVFFr?=
 =?utf-8?B?L3k5cCs5WHI3ejF0Tk5XNk03K3E3d09ZTUtSWGpqZFhUeWgwc2s5RHQ3bXpP?=
 =?utf-8?B?YjJtejIramx3NVV0Y0JqWUhBUW1laVdxTzlqOGo3Q1AwRmF5SWxpYWZzNHFt?=
 =?utf-8?B?akN0MHprVHg0bWoxUm9KVGVGRTVmNHRabWZZdld4MmVtaVJjQWlraTdOWGlL?=
 =?utf-8?B?T2NYQmoxMStiRmNaZ3hUMmlqLzAxanoxRlhXa0x5c2FjWUk4R1ZLV05oMWcv?=
 =?utf-8?B?bG5XRGpkTWg3amltbE5SS2daYnFqeGVKeDJmSkROTGtBSmtFZ29zclpZZkJP?=
 =?utf-8?Q?kC+9E0UHF3wwC/rIF+46Lo7Li?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a0e4d67-717c-42b3-b37e-08db0f29df76
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 07:54:31.9919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HOnJKXFwvDAyYkp7tFfGRQ16m6SXLU7zoBNNss1/GL0MyA5MNaarqYQCHP3exAVx+6ReNx2RzO1kqwfP/3emeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5291
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUdWVzZGF5LCBGZWJydWFyeSAxNCwgMjAyMyAxMTo0NyBQTQ0KPiANCj4gT24gVHVlLCAx
NCBGZWIgMjAyMyAwMTo1NToxNyArMDAwMA0KPiAiTGl1LCBZaSBMIiA8eWkubC5saXVAaW50ZWwu
Y29tPiB3cm90ZToNCj4gDQo+ID4gPiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlh
bXNvbkByZWRoYXQuY29tPg0KPiA+ID4gU2VudDogVHVlc2RheSwgRmVicnVhcnkgMTQsIDIwMjMg
Mzo0NyBBTQ0KPiA+ID4NCj4gPiA+IE9uIE1vbiwgMTMgRmViIDIwMjMgMDc6MTM6MzMgLTA4MDAN
Cj4gPiA+IFlpIExpdSA8eWkubC5saXVAaW50ZWwuY29tPiB3cm90ZToNCj4gPiA+DQo+ID4gPiA+
IEV4aXN0aW5nIFZGSU8gcHJvdmlkZXMgZ3JvdXAtY2VudHJpYyB1c2VyIEFQSXMgZm9yIHVzZXJz
cGFjZS4NCj4gVXNlcnNwYWNlDQo+ID4gPiA+IG9wZW5zIHRoZSAvZGV2L3ZmaW8vJGdyb3VwX2lk
IGZpcnN0IGJlZm9yZSBnZXR0aW5nIGRldmljZSBmZCBhbmQNCj4gaGVuY2UNCj4gPiA+ID4gZ2V0
dGluZyBhY2Nlc3MgdG8gZGV2aWNlLiBUaGlzIGlzIG5vdCB0aGUgZGVzaXJlZCBtb2RlbCBmb3Ig
aW9tbXVmZC4NCj4gUGVyDQo+ID4gPiA+IHRoZSBjb25jbHVzaW9uIG9mIGNvbW11bml0eSBkaXNj
dXNzaW9uWzFdLCBpb21tdWZkIHByb3ZpZGVzIGRldmljZS0NCj4gPiA+IGNlbnRyaWMNCj4gPiA+
ID4ga0FQSXMgYW5kIHJlcXVpcmVzIGl0cyBjb25zdW1lciAobGlrZSBWRklPKSB0byBiZSBkZXZp
Y2UtY2VudHJpYyB1c2VyDQo+ID4gPiA+IEFQSXMuIFN1Y2ggdXNlciBBUElzIGFyZSB1c2VkIHRv
IGFzc29jaWF0ZSBkZXZpY2Ugd2l0aCBpb21tdWZkIGFuZA0KPiBhbHNvDQo+ID4gPiA+IHRoZSBJ
L08gYWRkcmVzcyBzcGFjZXMgbWFuYWdlZCBieSB0aGUgaW9tbXVmZC4NCj4gPiA+ID4NCj4gPiA+
ID4gVGhpcyBzZXJpZXMgZmlyc3QgaW50cm9kdWNlcyBhIHBlciBkZXZpY2UgZmlsZSBzdHJ1Y3R1
cmUgdG8gYmUgcHJlcGFyZWQNCj4gPiA+ID4gZm9yIGZ1cnRoZXIgZW5oYW5jZW1lbnQgYW5kIHJl
ZmFjdG9ycyB0aGUga3ZtLXZmaW8gY29kZSB0byBiZQ0KPiBwcmVwYXJlZA0KPiA+ID4gPiBmb3Ig
YWNjZXB0aW5nIGRldmljZSBmaWxlIGZyb20gdXNlcnNwYWNlLiBUaGVuIHJlZmFjdG9ycyB0aGUg
dmZpbyB0byBiZQ0KPiA+ID4gPiBhYmxlIHRvIGhhbmRsZSBpb21tdWZkIGJpbmRpbmcuIFRoaXMg
cmVmYWN0b3IgaW5jbHVkZXMgdGhlIG1lY2hhbmlzbQ0KPiBvZg0KPiA+ID4gPiBibG9ja2luZyBk
ZXZpY2UgYWNjZXNzIGJlZm9yZSBpb21tdWZkIGJpbmQsIG1ha2luZw0KPiB2ZmlvX2RldmljZV9v
cGVuKCkNCj4gPiA+IGJlDQo+ID4gPiA+IGV4Y2x1c2l2ZSBiZXR3ZWVuIHRoZSBncm91cCBwYXRo
IGFuZCB0aGUgY2RldiBwYXRoLiBFdmVudHVhbGx5LCBhZGRzDQo+IHRoZQ0KPiA+ID4gPiBjZGV2
IHN1cHBvcnQgZm9yIHZmaW8gZGV2aWNlLCBhbmQgbWFrZXMgZ3JvdXAgaW5mcmFzdHJ1Y3R1cmUg
b3B0aW9uYWwNCj4gYXMNCj4gPiA+ID4gaXQgaXMgbm90IG5lZWRlZCB3aGVuIHZmaW8gZGV2aWNl
IGNkZXYgaXMgY29tcGlsZWQuDQo+ID4gPiA+DQo+ID4gPiA+IFRoaXMgaXMgYWxzbyBhIHByZXJl
cXVpc2l0ZSBmb3IgaW9tbXUgbmVzdGluZyBmb3IgdmZpbyBkZXZpY2VbMl0uDQo+ID4gPiA+DQo+
ID4gPiA+IFRoZSBjb21wbGV0ZSBjb2RlIGNhbiBiZSBmb3VuZCBpbiBiZWxvdyBicmFuY2gsIHNp
bXBsZSB0ZXN0IGRvbmUNCj4gd2l0aA0KPiA+ID4gdGhlDQo+ID4gPiA+IGxlZ2FjeSBncm91cCBw
YXRoIGFuZCB0aGUgY2RldiBwYXRoLiBEcmFmdCBRRU1VIGJyYW5jaCBjYW4gYmUgZm91bmQNCj4g
PiA+IGF0WzNdDQo+ID4gPiA+DQo+ID4gPiA+IGh0dHBzOi8vZ2l0aHViLmNvbS95aWxpdTE3NjUv
aW9tbXVmZC90cmVlL3ZmaW9fZGV2aWNlX2NkZXZfdjMNCj4gPiA+ID4gKGNvbmZpZyBDT05GSUdf
SU9NTVVGRD15IENPTkZJR19WRklPX0RFVklDRV9DREVWPXkpDQo+ID4gPg0KPiA+ID4gRXZlbiB1
c2luZyB5b3VyIGJyYW5jaFsxXSwgaXQgc2VlbXMgbGlrZSB0aGlzIGhhcyBub3QgYmVlbiB0ZXN0
ZWQNCj4gPiA+IGV4Y2VwdCB3aXRoIGNkZXYgc3VwcG9ydCBlbmFibGVkOg0KPiA+ID4NCj4gPiA+
IC9ob21lL2Fsd2lsbGlhL1dvcmsvbGludXguZ2l0L2RyaXZlcnMvdmZpby92ZmlvX21haW4uYzog
SW4gZnVuY3Rpb24NCj4gPiA+IOKAmHZmaW9fZGV2aWNlX2FkZOKAmToNCj4gPiA+IC9ob21lL2Fs
d2lsbGlhL1dvcmsvbGludXguZ2l0L2RyaXZlcnMvdmZpby92ZmlvX21haW4uYzoyNTM6NDg6IGVy
cm9yOg0KPiDigJhzdHJ1Y3QNCj4gPiA+IHZmaW9fZGV2aWNl4oCZIGhhcyBubyBtZW1iZXIgbmFt
ZWQg4oCYY2RlduKAmTsgZGlkIHlvdSBtZWFuIOKAmGRlduKAmT8NCj4gPiA+ICAgMjUzIHwgICAg
ICAgICAgICAgICAgIHJldCA9IGNkZXZfZGV2aWNlX2FkZCgmZGV2aWNlLT5jZGV2LCAmZGV2aWNl
LT5kZXZpY2UpOw0KPiA+ID4gICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIF5+fn4NCj4gPiA+ICAgICAgIHwgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBkZXYNCj4gPiA+IC9ob21lL2Fsd2lsbGlhL1dvcmsv
bGludXguZ2l0L2RyaXZlcnMvdmZpby92ZmlvX21haW4uYzogSW4gZnVuY3Rpb24NCj4gPiA+IOKA
mHZmaW9fZGV2aWNlX2RlbOKAmToNCj4gPiA+IC9ob21lL2Fsd2lsbGlhL1dvcmsvbGludXguZ2l0
L2RyaXZlcnMvdmZpby92ZmlvX21haW4uYzoyNjI6NDI6IGVycm9yOg0KPiDigJhzdHJ1Y3QNCj4g
PiA+IHZmaW9fZGV2aWNl4oCZIGhhcyBubyBtZW1iZXIgbmFtZWQg4oCYY2RlduKAmTsgZGlkIHlv
dSBtZWFuIOKAmGRlduKAmT8NCj4gPiA+ICAgMjYyIHwgICAgICAgICAgICAgICAgIGNkZXZfZGV2
aWNlX2RlbCgmZGV2aWNlLT5jZGV2LCAmZGV2aWNlLT5kZXZpY2UpOw0KPiA+ID4gICAgICAgfCAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+fn4NCj4gPiA+ICAgICAg
IHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkZXYNCj4gPg0KPiA+
IFNvcnJ5IGZvciBpdC4gSXQgaXMgZHVlIHRvIHRoZSBjZGV2IGRlZmluaXRpb24gaXMgdW5kZXIN
Cj4gPiAiI2lmIElTX0VOQUJMRUQoQ09ORklHX1ZGSU9fREVWSUNFX0NERVYpIi4gV2hpbGUsIGlu
IHRoZSBjb2RlIGl0DQo+ID4gdXNlcyAiaWYgKElTX0VOQUJMRUQoQ09ORklHX1ZGSU9fREVWSUNF
X0NERVYpKSIuICBJIHRoaW5rIGZvcg0KPiA+IHJlYWRhYmlsaXR5LCBpdCB3b3VsZCBiZSBiZXR0
ZXIgdG8gYWx3YXlzIGRlZmluZSBjZGV2IGluIHZmaW9fZGV2aWNlLA0KPiA+IGFuZCBrZWVwIHRo
ZSB1c2luZyBvZiBjZGV2IGluIGNvZGUuIEhvdyBhYm91dCB5b3VyIHRhc3RlPw0KPiANCj4gSXQg
c2VlbXMgbmVjZXNzYXJ5IHVubGVzcyB3ZSB3YW50IHRvIGxpdHRlciB0aGUgY29kZSB3aXRoICNp
ZmRlZnMuDQoNCkkndmUgbW92ZWQgaXQgdG8gdGhlIGhlYWRlciBmaWxlIGFuZCBjYWxsIGNkZXZf
ZGV2aWNlX2FkZCgpDQp1bmRlciAjaWYgKElTX0VOQUJMRUQoQ09ORklHX1ZGSU9fREVWSUNFX0NE
RVYpKSIuDQoNCj4gPiA+IEFkZGl0aW9uYWxseSB0aGUgVkZJT19FTkFCTEVfR1JPVVAgS2NvbmZp
ZyBvcHRpb24gZG9lc24ndCBtYWtlIG11Y2gNCj4gPiA+IHNlbnNlIHRvIG1lLCBpdCBzZWVtcyBl
bnRpcmVseSByZWR1bmRhbnQgdG8gVkZJT19HUk9VUC4NCj4gPg0KPiA+IFRoZSBpbnRlbnRpb24g
aXMgdG8gbWFrZSB0aGUgZ3JvdXAgY29kZSBjb21waWxpbmcgbWF0Y2ggZXhpc3RpbmcgY2FzZS4N
Cj4gPiBDdXJyZW50bHksIGlmIFZGSU8gaXMgY29uZmlndXJlZCwgZ3JvdXAgY29kZSBpcyBieSBk
ZWZhdWx0IGNvbXBpbGVkLg0KPiA+IFNvIFZGSU9fRU5BQkxFX0dST1VQIGEgaGlkZGVuIG9wdGlv
biwgYW5kIFZGSU9fR1JPVVAgYW4gb3B0aW9uDQo+ID4gZm9yIHVzZXIuICBVc2VyIG5lZWRzIHRv
IGV4cGxpY2l0bHkgY29uZmlnIFZGSU9fR1JPVVAgaWYgVkZJT19ERVZJQ0VfQ0RFVj09eS4NCj4g
PiBJZiBWRklPX0RFVklDRV9DREVWPT1uLCB0aGVuIG5vIG1hdHRlciB1c2VyIGNvbmZpZ2VkIFZG
SU9fR1JPVVAgb3INCj4gPiBub3QsIHRoZSBncm91cCBjb2RlIHNoYWxsIGJlIGNvbXBpbGVkLg0K
PiANCj4gSSB1bmRlcnN0YW5kIHRoZSBtZWNoYW5pY3MsIEkgc3RpbGwgZmluZCBWRklPX0VOQUJM
RV9HUk9VUCByZWR1bmRhbnQNCj4gYW5kIHVubmVjZXNzYXJ5LiAgQWxzbywgS2NvbmZpZyBzaG91
bGQgbm90IGFsbG93IGEgY29uZmlndXJhdGlvbg0KPiB3aXRob3V0IGVpdGhlciBWRklPX0dST1VQ
IG9yIFZGSU9fREVWSUNFX0NERVYgYXMgdGhpcyBpcyBub3QNCj4gZnVuY3Rpb25hbC4gIERlc2Vs
ZWN0aW5nIFZGSU9fR1JPVVAgc2hvdWxkIHNlbGVjdCBWRklPX0RFVklDRV9DREVWLA0KPiBidXQg
IFZGSU9fREVWSUNFX0NERVYgc2hvdWxkIGJlIGFuIG9wdGlvbmFsIGFkZGl0aW9uIHRvIFZGSU9f
R1JPVVAuDQoNCkhvdyBhYm91dCBiZWxvdz8gQXMgSmFzb24ncyByZW1hcmsgb24gcGF0Y2ggMDAw
MywgY2RldiBpcyBub3QgYXZhaWxhYmxlDQpmb3IgU1BBUFIuDQoNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3ZmaW8vS2NvbmZpZyBiL2RyaXZlcnMvdmZpby9LY29uZmlnDQppbmRleCAwNDc2YWJmMTU0
ZjIuLjk2NTM1YWRjMjMwMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdmZpby9LY29uZmlnDQorKysg
Yi9kcml2ZXJzL3ZmaW8vS2NvbmZpZw0KQEAgLTQsNiArNCw4IEBAIG1lbnVjb25maWcgVkZJTw0K
IAlzZWxlY3QgSU9NTVVfQVBJDQogCWRlcGVuZHMgb24gSU9NTVVGRCB8fCAhSU9NTVVGRA0KIAlz
ZWxlY3QgSU5URVJWQUxfVFJFRQ0KKwlzZWxlY3QgVkZJT19HUk9VUCBpZiBTUEFQUl9UQ0VfSU9N
TVUNCisJc2VsZWN0IFZGSU9fREVWSUNFX0NERVYgaWYgIVZGSU9fR1JPVVAgJiYgKFg4NiB8fCBT
MzkwIHx8IEFSTSB8fCBBUk02NCkNCiAJc2VsZWN0IFZGSU9fQ09OVEFJTkVSIGlmIElPTU1VRkQ9
bg0KIAloZWxwDQogCSAgVkZJTyBwcm92aWRlcyBhIGZyYW1ld29yayBmb3Igc2VjdXJlIHVzZXJz
cGFjZSBkZXZpY2UgZHJpdmVycy4NCkBAIC0xNCw3ICsxNiw4IEBAIG1lbnVjb25maWcgVkZJTw0K
IGlmIFZGSU8NCiBjb25maWcgVkZJT19ERVZJQ0VfQ0RFVg0KIAlib29sICJTdXBwb3J0IGZvciB0
aGUgVkZJTyBjZGV2IC9kZXYvdmZpby9kZXZpY2VzL3ZmaW9YIg0KIAlkZXBlbmRzIG9uIElPTU1V
RkQgJiYgKFg4NiB8fCBTMzkwIHx8IEFSTSB8fCBBUk02NCkNCisJZGVmYXVsdCAhVkZJT19HUk9V
UA0KIAloZWxwDQogCSAgVGhlIFZGSU8gZGV2aWNlIGNkZXYgaXMgYW5vdGhlciB3YXkgZm9yIHVz
ZXJzcGFjZSB0byBnZXQgZGV2aWNlDQogCSAgYWNjZXNzLiBVc2Vyc3BhY2UgZ2V0cyBkZXZpY2Ug
ZmQgYnkgb3BlbmluZyBkZXZpY2UgY2RldiB1bmRlcg0KQEAgLTIzLDkgKzI2LDIxIEBAIGNvbmZp
ZyBWRklPX0RFVklDRV9DREVWDQogDQogCSAgSWYgeW91IGRvbid0IGtub3cgd2hhdCB0byBkbyBo
ZXJlLCBzYXkgTi4NCiANCitjb25maWcgVkZJT19HUk9VUA0KKwlib29sICJTdXBwb3J0IGZvciB0
aGUgVkZJTyBncm91cCAvZGV2L3ZmaW8vJGdyb3VwX2lkIg0KKwlkZWZhdWx0IHkNCisJaGVscA0K
KwkgICBWRklPIGdyb3VwIGlzIGxlZ2FjeSBpbnRlcmZhY2UgZm9yIHVzZXJzcGFjZS4gQXMgdGhl
IGludHJvZHVjdGlvbg0KKwkgICBvZiBWRklPIGRldmljZSBjZGV2IGludGVyZmFjZSwgdGhpcyBj
YW4gYmUgTi4gRm9yIG5vdywgYmVmb3JlDQorCSAgIHVzZXJzcGFjZSBhcHBsaWNhdGlvbnMgYXJl
IGZ1bGx5IGNvbnZlcnRlZCB0byBuZXcgdmZpbyBkZXZpY2UgY2Rldg0KKwkgICBpbnRlcmZhY2Us
IHRoaXMgc2hvdWxkIGJlIFkuDQorDQorCSAgIElmIHlvdSBkb24ndCBrbm93IHdoYXQgdG8gZG8g
aGVyZSwgc2F5IFkuDQorDQogY29uZmlnIFZGSU9fQ09OVEFJTkVSDQogCWJvb2wgIlN1cHBvcnQg
Zm9yIHRoZSBWRklPIGNvbnRhaW5lciAvZGV2L3ZmaW8vdmZpbyINCiAJc2VsZWN0IFZGSU9fSU9N
TVVfVFlQRTEgaWYgTU1VICYmIChYODYgfHwgUzM5MCB8fCBBUk0gfHwgQVJNNjQpDQorCWRlcGVu
ZHMgb24gVkZJT19HUk9VUA0KIAlkZWZhdWx0IHkNCiAJaGVscA0KIAkgIFRoZSBWRklPIGNvbnRh
aW5lciBpcyB0aGUgY2xhc3NpYyBpbnRlcmZhY2UgdG8gVkZJTyBmb3IgZXN0YWJsaXNoaW5nDQoN
ClJlZ2FyZHMsDQpZaSBMaXUNCg==
