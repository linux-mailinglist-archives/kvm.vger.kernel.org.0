Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E7B6AD4B2
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 03:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjCGCcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 21:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjCGCcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 21:32:08 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A502457C0;
        Mon,  6 Mar 2023 18:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678156327; x=1709692327;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BDw/i5DwDOZRNqeBcdNMsVOvgy84MQuKrOf8ZB2N2lo=;
  b=ngf8G6Pzqbn5BrKAAgv3sS3xqF4VnvNuubdtMwtDVgPv01rXO3gO7hDE
   noI9HQqyaYhH3LJhY5jEriT3kt6D4X0oija8HlezyjQbeYuIrx2AFi8V7
   jlOq85lfo0TJxU4iOMmVGy9FcYk2qM7+FV8lOXndef4Z2KVx+6TJkP3Fk
   HFF4ATNOrS/HP7+TjClA0VqiNW3EBa1Y+CqBUO6Pq4VCg6zcxp6peizF4
   tHStb+ivwnzXXSgpGZSKaVXablpi2cWIuW3ewNfn+FM2+oa+h7gLrHaBw
   v03SJgomcHTBcjLTDWN3u1bkvLvnpnYixbrmluHU7+HQC4hTdM16Mrz/r
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="398326060"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="398326060"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 18:32:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="786510345"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="786510345"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 06 Mar 2023 18:31:14 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 18:31:13 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 6 Mar 2023 18:31:13 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 6 Mar 2023 18:31:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Brj1WcsDnjUhFYyurriPeeiUanWzknUUOStkGjwUXQE4uziZILThCvPRYhHRh4O/ugN5rjvCoDpekADD4U0g61LKcgtgSwZ0fPxKJLJHJouNdn7QvOCEnA36E/o8SxtXiE/VHYYvRHBTj/sAEePy2WvQa5mE30W/4nYT6PIq6VtMBQ713562De3xYxND5Ys+H9JgO+oqjdDBoq97FW8gu7XCkb1UhVoWm3IA7MTMQBThnDJ1iKIuS8aquKtYrd4sa1e0ZeQaPNXmS3hb+eO/1LoJi4Yo348cj06/x2xUVfU36cc499uRrx5F9Z+kGn6OUCFoMEjijeT/MaD876GHJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BDw/i5DwDOZRNqeBcdNMsVOvgy84MQuKrOf8ZB2N2lo=;
 b=O+gyO2eUH17Rd5ZgjbYz7qpVsPq5aVequRzs1nhRQvfiloHDrKdtGgOgWwL0Q9UL6GSkxa1Wm1o5MG0mzYxpNPqwTJxVNVn/XgAFYWxLQHrTCdIF34mS6YtwEsv2Sr11jGBY/CwcIYSiZ/Z91mhJehLUPquEwT9T/p7qJcN5Od0fQGWJla6BoFifxGFt/Zm64aAwLiexzsRNME53S+8r4jJi45ucI8DNGy0d+mUvT5lStcGkQy4ulXVa/D6BTxgHlnzh/PZm2ylTKJH5EfzFGSKCxcZQ1LQP5SsA1TKZut/Ef8omXFfh6QQJxx5EXecWfjH18qqtP+wG4d7WP68n2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO6PR11MB5620.namprd11.prod.outlook.com (2603:10b6:303:13e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Tue, 7 Mar
 2023 02:31:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 02:31:11 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
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
Subject: RE: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZSpxNc+z5kvMhjUKJQeU3VasOx67nBTMAgAA+rbCAAC27AIAAHWOAgAECO4CAALuIAIAEeeOAgADblcA=
Date:   Tue, 7 Mar 2023 02:31:11 +0000
Message-ID: <BN9PR11MB52760ABC93BCE7FB53A131038CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-10-yi.l.liu@intel.com>
 <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZACX+Np/IY7ygqL5@nvidia.com>
 <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230303095542.2bfce5c2.alex.williamson@redhat.com>
 <ZAXny4NDDq42NUxE@nvidia.com>
In-Reply-To: <ZAXny4NDDq42NUxE@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO6PR11MB5620:EE_
x-ms-office365-filtering-correlation-id: 1973e3e8-2850-4b7a-6fea-08db1eb403f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PAR19WqdecqDaVWtLJx71zJa5zJqyuWv6DGacaP8W/5+NcKjqBaFxk2FZGPEthjCqvF4H0zPSPlWAdMvOHAZsjP2Mb0ZcrpH+WmkWspqOGoqvJiUtcP4QA8L7fG3oG7c9lsCA61Z9Ez6yAdcqbtrCaw84D/qYaAFb8krbBQfak5WnHnPfZ8Qc8wS3II0dgt4ULnmm1UrUubGdavh87KxtOFQyx9oFrd0WZqrjQtQFB5hHbzibRg3VxG2CgYITboSYL62MT/JvjbDsPDqqbSjRNujf9X6hKdo4Wwryg7yO0iGXRNXMEPHd09TuA3FfZF+GnxGGYQJtOHnkYgG68XTJjLYzCheZGz/X9zsVbiikH06WQCvTtnYEWshzHhAps37fw74LKpdN1z9bpq5R0igyn8unG9AcE1bzs68dHrJDj4DszQKO66S3Y+krjyNmmHmrPYN5folWyml3WjBdwzwvLJjSIGDNSsSqJVOKXdSoA3sZ7pG8iDrTCt/tnwfxqvKLiQxkRMaMDWOHZ0CLaagGwUBVX5rUXMW4rgUmhyQ5pwzvS7vJIoIYylEmNdg11DGb189wlYr+cqUGlk6jZTv+tdgg/izyXmljTjpeKQC81b/vAt/Edhbt2NuufYaiEc+SZfhwQpveme+yk2lCSDOe1HUvbGqnKDc6gzwFFLRUvfbjVomR3IXW0IVaCXlhJctjh9slPsDPvc5ZeE9vHSulA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199018)(33656002)(7696005)(316002)(83380400001)(478600001)(71200400001)(186003)(26005)(38100700002)(5660300002)(52536014)(9686003)(6506007)(66556008)(76116006)(66476007)(4326008)(66946007)(41300700001)(2906002)(64756008)(66446008)(8936002)(7416002)(8676002)(86362001)(122000001)(54906003)(38070700005)(110136005)(82960400001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OEFuT1RkTlhnT0dSZ3Z3M1cvQlEzUFBxVk9Sc05OQTRmVGkvY2VFc0xqMXAv?=
 =?utf-8?B?NEp4djlNNEdVK0NYNURMNUcveDY4c2dleDd1Z1pTUFZEclZ1WDE5MGhKVFBP?=
 =?utf-8?B?dW5MUDdlaDlIVlFrWE91TUdzOXA5UzBLRWRhK1lEd2xaRG5ZV2hqbGxhaGhL?=
 =?utf-8?B?SnRtZ2JjK0NURDBlZjZBdFlScVZ4MlFFcXk4cHNwQ1dRRmRER3Z4Vmc4bHdE?=
 =?utf-8?B?RndGOWNtNDBVN25vbWN3elF1OXFGWGF6NnI3WUFqM3NwNkt1YzAybGV6dzUz?=
 =?utf-8?B?MU9UcCtFODNqanBOK1VTRExCbVJDK0FMTWM3TElkeUdjTFliSEJRdG5lNkZQ?=
 =?utf-8?B?WnN2SUczOWNKZlBqeFVHc0J1OCtoOCtMcE1pMS9tYURLYVR0dFBwRHJnL2hI?=
 =?utf-8?B?SENBWGZqMHF2Q2dESTkyTFhEVzVzS1kreDZWYnA4ZGVHdE40ellYdHN5U1ZY?=
 =?utf-8?B?YW8yTjVoUnBqRVRPeGNLN253QnRxbU1LcVhCbmZ2Z1l6OWUxQWxqbXg0WFJ4?=
 =?utf-8?B?YUh1di9GWUZySFh2UlVnWnFMcmNlV3c5cnA0TVpyckRMZFhod2lTbE5OekFV?=
 =?utf-8?B?ZGZxRkJsVy9PbXc5QmFBaXVsUXRFaHFlK0ZFQXpaZEpWY1NhTzJHeHJ4Z24x?=
 =?utf-8?B?eFlGd1pkeEE0QVVSaVd1V2labzF1T3hlOE1LYkdsNlgrMGY1U2htRUVrZ1lY?=
 =?utf-8?B?c3dQRXphVlhhdkgxQWlQQ05FdE85Z2tlR3YvTjJsb2Y0MWx3WFpuWFZrQ1lv?=
 =?utf-8?B?T29nWjFrNksyL2UrRzNlNDZLK2VoYlRISk81UUtCcnV1T3o5VVBkZGprQmNM?=
 =?utf-8?B?L0NpWmdSS3VsN24rTGw2YmtaQndvN2dPNWVXSXdzaUJxNzNIN2NXQlhWVlU5?=
 =?utf-8?B?S3ZoQzBYWE85MXlsbGRvS2VnZlhnRDdIUzBDamhFR1Vsd1N1Yy81eFRZa1VT?=
 =?utf-8?B?TFR0MDRPaEl4Z2Z1ZXpqSGFHVGNKdnVOQkJDYSt5QUZVUHAxTG1CblZMLzJG?=
 =?utf-8?B?NTZyamNrZXFpaCtMeG1jK3kzNFFBcWxRNWYyM3lMUkRxM1N3aVVKaW43RjlU?=
 =?utf-8?B?bk1Vc1NKbmw5RDdESkFkMlQyUmt5UkUwaFVVam15aUQ3M2xrcmUwaXF0eXBE?=
 =?utf-8?B?c2RYNzZUbzlackRhRWU0aU5OTE02dHQ0Tlg2QVdEYms4T0lFaUJGZ0UxaHRK?=
 =?utf-8?B?ZUFqbGJrMVM4bWl5eFJOQzhEbnhNMmV6SHllQzBRMG5jdHdiT1d2K3V2cFpI?=
 =?utf-8?B?RUwwYURoc1YzRU1xTk5vVGc1U2YwZGJFMGVaQ1ZBOStheUp2WVVUUEVpZi9s?=
 =?utf-8?B?QW42blFkZU52eUMzUnVkTmRibDl0RHVNS09SQ3lWanJZeWZUeUpmUHk1OTZB?=
 =?utf-8?B?UkVtRE8xR2N2MTk4NVBlLzVTWjFjZWNJQ2o4aVRXQ1oyZVJob0VNNDQxWW5J?=
 =?utf-8?B?MUZacEhyMnpiREdpNVQxWDh0VVQ4dDFzWWM2UnlNWEdmVFpHaG9JUmJJYjUy?=
 =?utf-8?B?ZEx2RGFwNGlFd2RHWFF3cWc5d085N00zWERnUmJUemZDVWFkM2RsbGRXb3Ro?=
 =?utf-8?B?ZGxDanA3VjY0MU8wd3RsOTdyYVd5YlZXVkhFR1ZiVnBxU1VEL1RXbGFkdHRK?=
 =?utf-8?B?TUhSS09oMHFML1dIRWwvUExmcnlnYkxjUi9pQy9Jek80aXFmdjZQSm9IWjU2?=
 =?utf-8?B?UWJCeXYrYnNMK2xpN20xblFsMWpHUDRIREFpRFRFR0k1Y1E2RGlIdGFQaVpR?=
 =?utf-8?B?T1hFaHJwaG5hTnJtYmUwVDMvbExud1M0S2lOREtZbm0zUUExTEhFOGdyOUhJ?=
 =?utf-8?B?NTU5dVBXek5GdDJGNDJpb1F2aE9VY0JIbVRrSjJLVlgraVJQQllWQjU3UDF2?=
 =?utf-8?B?Q294bXBoZHdLWGRBVFhMTDFXdlZXMFJOaWx6Vm5hbGNOVGswSStzTWdIRlpx?=
 =?utf-8?B?WjV5TDF1NzNHbG5tdU1VNWRZTTlwbDYvQXp1Y0s0SllERkpOcDRycHRLblRU?=
 =?utf-8?B?OEhGSm0wcGoyM2tyejBWSFVvOFVYT1lCRHNOZnBpOGoxd1AyaVJjb1JUaG1y?=
 =?utf-8?B?WnM5akhDU2RIUVdpeFpDRVkxUkNrTno3cFE1dE1jNWFWT0ZHTDhneFdqWWhu?=
 =?utf-8?Q?N1YwAgQc9/ZUPatBb297+ExbY?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1973e3e8-2850-4b7a-6fea-08db1eb403f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2023 02:31:11.1729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ig3+axl/pnHw9NS65ze7fkmEzze4SRoNKmCUVO32UtMHKzC7uB11r/8soP1FLP2LaxJ9GqHwaY8EVfWbXOX0HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5620
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBNb25kYXks
IE1hcmNoIDYsIDIwMjMgOToxNyBQTQ0KPiANCj4gT24gRnJpLCBNYXIgMDMsIDIwMjMgYXQgMDk6
NTU6NDJBTSAtMDcwMCwgQWxleCBXaWxsaWFtc29uIHdyb3RlOg0KPiANCj4gPiBJIGNhbid0IHRo
aW5rIG9mIGEgcmVhc29uIERQREsgY291bGRuJ3QgdXNlIGhvdC1yZXNldC4gIElmIHdlIHdhbnQg
dG8NCj4gPiBtYWtlIGl0IGEgcG9saWN5LCBpdCBzaG91bGQgYmUgZW5mb3JjZWQgYnkgY29kZSwg
YnV0IGNyZWF0aW5nIHRoYXQNCj4gPiBwb2xpY3kgYmFzZWQgb24gYSBkaWZmaWN1bHR5IGluIHN1
cHBvcnRpbmcgdGhhdCBtb2RlIHdpdGggaW9tbXVmZCBpc24ndA0KPiA+IGdyZWF0Lg0KPiANCj4g
T24gdGhlIG90aGVyIGhhbmQgYWRkaW5nIGNvZGUgdG8gYWxsb3cgZGV2aWNlIEZEcyBpbiB0aGUg
aG90IHJlc2V0DQo+IHBhdGggdGhhdCBpcyBuZXZlciB1c2VkIGFuZCBuZXZlciB0ZXN0ZWQgaXNu
J3QgZ3JlYXQgZWl0aGVyLi4NCj4gDQo+IGhvdC1yZXNldCBkb2VzIHdvcmsgZm9yIERQREssIGl0
IGp1c3QgZG9lc24ndCB3b3JrIGluIHRoZSBjYXNlIHdoZXJlDQo+IERQREsgd291bGQgaGF2ZSBt
YW55IFZGSU8gZGV2aWNlcyBvcGVuIGFuZCB0aGV5IGhhdmUgb3ZlcmxhcHBpbmcNCj4gZGV2aWNl
IHNldHMuIFdoaWNoLCBhZ2FpbiwgaXMgc29tZXRoaW5nIGl0IGRvZXNuJ3QgZG8uDQo+IA0KPiBJ
TUhPIHdlIHNob3VsZCBsZWF2ZSBpdCBvdXQgb2YgdGhlIGtlcm5lbCBhbmQgd2FpdCBmb3IgYSBu
by1pb21tdSB1c2VyDQo+IHRvIGNvbWUgZm9yd2FyZCB0aGF0IHdhbnRzIGhvdC1yZXNldCBvZiBt
YW55IGRldmljZXMuIFRoZW4gd2UgY2FuIGFkZA0KPiBhbmQgdGVzdCB0aGUgZGV2aWNlIEZEIHBh
cnQuIE1vc3QgbGlrZWx5IHN1Y2ggYSB0aGluZyB3aWxsIG5ldmVyIGNvbWUNCj4gYXQgdGhpcyBw
b2ludC4NCj4gDQoNCkkgdGhpbmsgd2UgZG9uJ3QgbmVlZCB0byBoYXZlIHRoaXMgdHJhZGVvZmYg
aWYgZm9sbG93aW5nIFlpJ3MgbGFzdCBwcm9wb3NhbA0Kd2hpY2ggcmVxdWlyZXMgZXZlcnkgb3Bl
bmVkIGRldmljZSBpbiB0aGUgc2V0IHRvIGJlIGNvdmVyZWQgYnkgdGhlDQpkZXZpY2UgZmQgYXJy
YXkuIHdpdGggZGV2X3NldC0+bG9jayBoZWxkIGluIHRoZSByZXNldC9vcGVuIHBhdGggdGhpcyBp
cw0KYSBzYWZlIG1lYXN1cmUgYW5kIGZ1bGx5IGNvbnRhaW5lZCBpbiB2ZmlvLXBjaSB3L28gbmVl
ZCBvZiBmdXJ0aGVyDQpjaGVja2luZyBub2lvbW11IG9yIGlvbW11ZmQuDQoNCkluIHRoZSBlbmQg
c2FtZSByZXNldCB1QVBJIGV4Y2VwdCB0aGUgZmQgYXJyYXkgY2FuIGJlIGRldmljZSBmZCBub3cu
IPCfmIoNCg0KYnR3IFlpLCBzaW5jZSB0aGlzIGFsc28gYWZmZWN0cyB0aGUgZ3JvdXAgcGF0aCAo
dGhvdWdoIHBvc2l0aXZlKSBpdCdzIGNsZWFyZXINCnRvIGZpcnN0IGFkZCBvcGVuX2NvdW50IGNo
ZWNrIGluIGV4aXN0aW5nIGdyb3VwIHBhdGggaW4gYSBzZXBhcmF0ZSBwYXRjaA0KYW5kIHRoZW4g
YWRkIHRoZSBkZXZpY2UgZmQgc3VwcG9ydC4NCg==
