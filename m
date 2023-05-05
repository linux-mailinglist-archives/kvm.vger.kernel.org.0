Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2AD6F7DAC
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 09:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjEEHVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 03:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjEEHVX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 03:21:23 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020B816360;
        Fri,  5 May 2023 00:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683271282; x=1714807282;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/iBI4LR+bifJFVuXRIU4k5nXj5y7SeaLHmqQyyLINq0=;
  b=AmAxLGC/8jMjMOqu5Ynj+r/pH4ou9GzhkuiYEp6q3LaHnS72NoD6Z4Gi
   4oUmjh89hhvXU+R8AWH4SEk9v1NbPvrkp4/dUZkzHpS/q7zVyRcKuvAk/
   8vZ6IxynSKTVT92C6bTUV7oLnCk78WjllKpjZ0a+MKtnd1FvAt35AXXnO
   iVNGbtD0eJ6TpkwBE7HAVBShvOrniX96hKEbF9PhXWXK0Zk63mQnTq6aZ
   cm5zM1zF9kRx+kLY6uXQIpcose2Hfpe6X2DfXFKgrhwZ4oYdWIYR1QlL1
   gQHhx7qQ48MG8AjPDLscE5tHZ8NVYZafhfAwn49BO7AaHLmMg2VFUz4nv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="329510563"
X-IronPort-AV: E=Sophos;i="5.99,251,1677571200"; 
   d="scan'208";a="329510563"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2023 00:21:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="700275888"
X-IronPort-AV: E=Sophos;i="5.99,251,1677571200"; 
   d="scan'208";a="700275888"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 05 May 2023 00:21:22 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 5 May 2023 00:21:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 5 May 2023 00:21:22 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 5 May 2023 00:21:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1ufHyiUzywpWdD/G274oqW4bnTIOWx8oPBv1sFj0jVJiyICVJjZc+8KXgWtihCQo8dpbvfgP6iGiDXDu8oDhf5ZiI9gTL2CHMIvT4UAsg89JmDte3LPJWQv8BbqDvEYmf3g0GgBKlwfcFVb286lCUHX1yd0wNcQkGImVD3JDN/95+pXOfAPPos/a1ZkxablhJD4NkxyUBLkq8Y6R4omoYWDShtIRxm7iqC9eby850oG3Yfvl3n+o/FZiOWFHWdSwRUvswJR9l0YWDeHbGoW5aoIsnny/D4xCDODZU7n7+F8huGOGRI/D2Qk/Y73SNfAlfwdW4UuTfbW6aGFBuvcDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/iBI4LR+bifJFVuXRIU4k5nXj5y7SeaLHmqQyyLINq0=;
 b=Ist62HTUxj0GaKtyEhP3dDrGCd0VPPWep/t1s0S6ROIRLlrf8mWpHKbwFxJjxuatDLSlyYp2/utK7X2iKb+HioXeL+/JMAu8pXYs36B1NPy/tHZn3Vb8R3rinRrU1oAIwra/IGVF4yicz5cCc6V2hSyzX2cNqKSBojb88XdwnpEod76003rkNR/N+mX6NeWoaB2ayf8Dp4bZq1L6Zo1nEp7j70lqWKxdp48MC+XM67YWu2LWcV45HmeeaFWx65crbLNednZ/QKWKST2hpiJ823T+oApaDnWIhDQDt4lpvLR00FcXvXMgGj7nAEzcUocNkt6y5BOOr7yfisUYKzxrWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7478.namprd11.prod.outlook.com (2603:10b6:510:269::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.27; Fri, 5 May
 2023 07:21:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%8]) with mapi id 15.20.6363.027; Fri, 5 May 2023
 07:21:11 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V4 03/11] vfio/pci: Prepare for dynamic interrupt context
 storage
Thread-Topic: [PATCH V4 03/11] vfio/pci: Prepare for dynamic interrupt context
 storage
Thread-Index: AQHZeS7LM0WEo3lFJUe4AxtjXzq3+a9AQzGwgADHqYCACkb+0A==
Date:   Fri, 5 May 2023 07:21:10 +0000
Message-ID: <BN9PR11MB52764DFBE5C3FFA8BEC9E2AA8C729@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
 <6fcd4019e22931a97d962b6e657e74d6fd1049ba.1682615447.git.reinette.chatre@intel.com>
 <BN9PR11MB5276242E8D9F4C082E6D2CB68C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <07a693e9-b926-6c25-ea55-8465410e214c@intel.com>
In-Reply-To: <07a693e9-b926-6c25-ea55-8465410e214c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7478:EE_
x-ms-office365-filtering-correlation-id: 5f76decd-4bd7-42f2-8d11-08db4d394d4d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ACFb5sWjJZgyiZOFSknFMfh4vtVkzD7r83awjhQwX8Rnp7uFEJgDncYn+B9A6DA5TyadN8FL2LPMtu4F1CEMNvPGKZyuiBHTNfDHoDn3K8ydDyZHlDJ/0bLGFEpXdywKr5yjYgQQL+WeMike6xxunCPaKlEnUoKkNMLV6lKzojRhxKktU/42dKizDkNd3mDk9vQqP3K5UW1uMW+Wf4dKH9Z+ycNC3bWqMaTixhPA3kPmgCQNDNx3sD08PbzlOkZAvWm34txZDAS5tNJ165WC6b2WYjs6P+/cQlPcv2BCJlhaoQ9NeeESLpkTD/j6/dOlUGVbz7VwySK8fWOVD26UtC1lVaCo423qfkcOZCYbr98m6tV+EfoGc05d8uhBSCrKZMa6HotR4Z+NzTf/nT7m11r0WesgDrnFMj1dBXbzzBkABZ1xngIBVTS7a3Tt3UwL4xGSPls+nyUci5w0jMqsbssnRnGqutU2/bCIRETGk4HOkCnoiY4lpzukEP2UhjL1hdqRFXZJoA+w3clCMGszE2+nY+U5Ecv2tvDNc2M1wZsqlBD0YOPAKPrIffB67bcOm2s95Le7UBJ4k4N04wDdAk20IgI8KQlMAyIoutgyOejuOlveqRnvWMTY1a2eDzB0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(39860400002)(136003)(396003)(346002)(451199021)(7696005)(71200400001)(186003)(55016003)(83380400001)(6506007)(53546011)(9686003)(33656002)(38070700005)(82960400001)(110136005)(122000001)(86362001)(54906003)(316002)(76116006)(41300700001)(52536014)(8676002)(8936002)(38100700002)(64756008)(66446008)(66476007)(66556008)(5660300002)(4326008)(66946007)(2906002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YThCR2JHVHlCZXVFZlNwcFphYWJnZ2NibUhrWTFCVEtPV1NDMEJMSHpqc0hD?=
 =?utf-8?B?WUYrZk9ZcWU1TWIyeEFCOFI4RVhzMW1yTjhZa0l2M2czbHFMTlJFVDBBMGM3?=
 =?utf-8?B?RFo1ckhCQ1BwdVVZY1UwcFNtc1hBVFZHdWROTGZyV0JKWlVuUE9leWlpc2Fl?=
 =?utf-8?B?ZzVaaHpzRUs2Vmw5czZBVnlxS24rU1lmVU83MnkzcUtmbU5zWXB0Q1JxL0ZT?=
 =?utf-8?B?Z2Q4QzZvTHhnY0J3Yy9PMFEwKys2TEo4RUVubDdzSWFmOVJiaFpTUS93WFBq?=
 =?utf-8?B?ck5oaGt3TUxaT1FHSjRPakl0TVVwS3FlTVZheVNFOXZhQ2QvNytCQkJrSk9F?=
 =?utf-8?B?cE56aFIvbEc3TzYxSmFyUTVoSXZ4L3M3YmppNGsxZzdGQU01R01TL0k3YUt5?=
 =?utf-8?B?NVBRKzRTWU13VUdSQXcvRzMvRnlscStLSXh5ZUxSYjlLeGZwQXlqRlE4cHNI?=
 =?utf-8?B?Z3k5OWRDaVJTZzhXajRCOUd1NjU5MWxDWVlaQjl5Z3VCOHRReVVCT1pPbzdT?=
 =?utf-8?B?U1ZUWnd4N0hPZ1NFV01KeUZiMHRzbUhaUkR2WGs4aXcxcnVDU2xjUHk2WHFF?=
 =?utf-8?B?ZTAySjV4QnNWVWtlRnVuYldNQ2FHY1JpTFRpUnRneFNpZUJjUlordGhaK2R4?=
 =?utf-8?B?TmtoREpxNElqbkJRRWRuVDg0aSs1ZnBuQVl6Yy9IVzNiN3MwQ0FiWkZOdFlJ?=
 =?utf-8?B?TlRFVnZ1cmtLY1R2NnBEcnJHVVNJdDhvbXJjZXhyWHRuZHRQOENlVHczanhv?=
 =?utf-8?B?dWdXajcxSmg4MWRKcHZjc0hxNjVXRXUwTUFrakF2OHV3UUhCazNQczU3NWFH?=
 =?utf-8?B?SWk1SXdJMzFJd0Y5aFp3Rzd5UFJRTjVKRzRxdFZFNHFVa3Z3aFNpNXNQZGdt?=
 =?utf-8?B?Y3dYN05ma1cxYjl5UUFyQktYT1NKcGVmTmxrbWtqeEd4UjE3L0RBWEFFUmVK?=
 =?utf-8?B?a3BaQThiUStudjZIdkozeVpialdyVHYwQVdqMGE2KzlpU21VdDU2ZzhKQyta?=
 =?utf-8?B?eU01SjBreWNjL08wQWxtaHExV0x1VkhFVGduZ0RjSExXUTArQTQwNUgxM2c0?=
 =?utf-8?B?OUlORlhmZDJEenp0V2Fmalh1MDRqL0xwZThnK1dSbHdYZlkzU3RxdURDNUNt?=
 =?utf-8?B?SHdPRnNhaEdKdERrQ3NLMEpDRmNQb2VyV0FEMnFFTGVrc285bzFseGgzUUFF?=
 =?utf-8?B?RGJ5UjFpSEk5ang3dG9zUnJnT0xLb0pXalFnU2lhQ2N2Y0dBS2p3Z05HTXlB?=
 =?utf-8?B?YWIrVE9weFZCeHlsdTBuRGVQVFF3UzJxTmtTM1hpaFZIUkV4cWdNVW1BSmJF?=
 =?utf-8?B?eXh0b0thdXZaR0thckVtRVRQenJNaEt1b0xmWHFEeEk4a2FOYld0M3BaVW1p?=
 =?utf-8?B?cXVNcjB0eEhKY2YwbW4xbTJZOU44bnhucXFyQVdVS2hMbnlmQ1VZaEl6N2Nt?=
 =?utf-8?B?cGh4NjU5VzZMMGdESkJtdzZSWUZQZWtFUHlkSzJ0Y256UmhHSzduejRibVli?=
 =?utf-8?B?OGQyYmtibUFFSkRLWFowbE0vT3M1N05SVE4xOEpvUm1JS3VraHpqWnZkenZz?=
 =?utf-8?B?VWxUeFB5V3F4aStLaGlLaEpVeGk5OHZMUGNmZkQ0V0djY3k1bThneVg2R05t?=
 =?utf-8?B?SWtNQkp0bzZUMEJ0TmdqM21YYkFaVUo5aUZhUmdhZGdmbWRnL1dNeENQNFZN?=
 =?utf-8?B?MEFHWldCd2hpclJhckhDaWlhUW5EZENDanVIWTBJM3pUOHd1MStoRGNaZUFB?=
 =?utf-8?B?TFlLQUJvYnZ3SjMxMzhsZEtQaHM0Z0NBRGhNaDRFeWcwalI2MlJZL1JjOG93?=
 =?utf-8?B?SFpjMDBpVEdhVG9tMjM1TlFobHc5bWZkTWpBaGg1NW5PNFM0a2lUQnBPd1Nu?=
 =?utf-8?B?K3dpMHRHb0pXRWNFTEFqNzdLWTJvT3dMSVVoQzFyeHFLa0drREJYUkJHamZC?=
 =?utf-8?B?eE9aeVpHMkVERWZZS2x4aDE1ZzY1WG9naTZGaG9BemM5OEtEa1l4Y051TWJH?=
 =?utf-8?B?NFpIczhBT0xjemg3eXY3c0VzdmZCcmFqWEovTGNlZW5UY2NIYzFaaVVZQzRO?=
 =?utf-8?B?V2p3UTVJUGRIZVd6NzNrbzZia0tocnJnZ3MvUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f76decd-4bd7-42f2-8d11-08db4d394d4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2023 07:21:10.8069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4FvsyQ1DcMnhjysy5OmvKx9jo1OvE1BHKdZDBWUbJkm1+AYROoCMLTQQTYvQcqTh8cWry/ml9HSkRF/QonHa9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7478
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBDaGF0cmUsIFJlaW5ldHRlIDxyZWluZXR0ZS5jaGF0cmVAaW50ZWwuY29tPg0KPiBT
ZW50OiBTYXR1cmRheSwgQXByaWwgMjksIDIwMjMgMjoyNCBBTQ0KPiANCj4gSGkgS2V2aW4sDQo+
IA0KPiBPbiA0LzI3LzIwMjMgMTE6MzMgUE0sIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+PiBGcm9t
OiBDaGF0cmUsIFJlaW5ldHRlIDxyZWluZXR0ZS5jaGF0cmVAaW50ZWwuY29tPg0KPiA+PiBTZW50
OiBGcmlkYXksIEFwcmlsIDI4LCAyMDIzIDE6MzYgQU0NCj4gPj4NCj4gPj4gQEAgLTU1LDE3ICs4
MCwyOCBAQCBzdGF0aWMgdm9pZCB2ZmlvX3NlbmRfaW50eF9ldmVudGZkKHZvaWQgKm9wYXF1ZSwN
Cj4gPj4gdm9pZCAqdW51c2VkKQ0KPiA+PiAgew0KPiA+PiAgCXN0cnVjdCB2ZmlvX3BjaV9jb3Jl
X2RldmljZSAqdmRldiA9IG9wYXF1ZTsNCj4gPj4NCj4gPj4gLQlpZiAobGlrZWx5KGlzX2ludHgo
dmRldikgJiYgIXZkZXYtPnZpcnFfZGlzYWJsZWQpKQ0KPiA+PiAtCQlldmVudGZkX3NpZ25hbCh2
ZGV2LT5jdHhbMF0udHJpZ2dlciwgMSk7DQo+ID4+ICsJaWYgKGxpa2VseShpc19pbnR4KHZkZXYp
ICYmICF2ZGV2LT52aXJxX2Rpc2FibGVkKSkgew0KPiA+PiArCQlzdHJ1Y3QgdmZpb19wY2lfaXJx
X2N0eCAqY3R4Ow0KPiA+PiArDQo+ID4+ICsJCWN0eCA9IHZmaW9faXJxX2N0eF9nZXQodmRldiwg
MCk7DQo+ID4+ICsJCWlmICghY3R4KQ0KPiA+PiArCQkJcmV0dXJuOw0KPiA+DQo+ID4gaWYgdGhp
cyBlcnJvciBoYXBwZW5zIGl0IGltcGxpZXMgYSBrZXJuZWwgYnVnIHNpbmNlIHRoZSBzYW1lIGNo
ZWNrDQo+ID4gaGFzIGJlZW4gZG9uZSBpbiB2ZmlvX2ludHhfZW5hYmxlKCkuIFRoZW4gc2hvdWxk
IGJlIGEgV0FSTl9PTigpLg0KPiANCj4gU3VyZS4gQ29uc2lkZXJpbmcgdGhhdCBpZiB0aGVzZSBh
cmUgdHJpZ2dlcmVkIGl0IG1heSByZXN1bHQNCj4gaW4gbWFueSBpbnN0YW5jZXMsIHNvIHBlcmhh
cHMgV0FSTl9PTl9PTkNFKCk/DQoNCnllcy4NCg0KPiANCj4gPiBkaXR0byBmb3Igb3RoZXIgaW50
eCBmdW5jdGlvbnMgd2hpY2ggY2FuIGJlIGNhbGxlZCBvbmx5IGFmdGVyIGludHgNCj4gPiBpcyBl
bmFibGVkLg0KPiANCj4gSXQgc2VlbXMgdGhlIGluc3RhbmNlcyBpbiB0aGlzIGNhdGVnb3J5IGNh
biBiZSBpZGVudGlmaWVkIGFzIHRoZSBwbGFjZXMNCj4gd2hlcmUgdGhlIGFycmF5IGNvbnRlbnRz
IGlzIGN1cnJlbnRseSB1c2VkIHdpdGhvdXQgYW55IGNoZWNrcy4NCj4gDQo+IEkgYW0gcGxhbm5p
bmcgb24gdGhlIGZvbGxvd2luZyBjaGFuZ2VzOg0KPiANCg0KdGhhdCBsb29rcyBnb29kIHRvIG1l
DQo=
