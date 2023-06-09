Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F95728C48
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 02:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236982AbjFIAOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 20:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234340AbjFIAOE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 20:14:04 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD872D71;
        Thu,  8 Jun 2023 17:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686269642; x=1717805642;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=u+Cc6cBQVjbm+DoEwToiGtgbHATFLYeo9MmhnG5+oD4=;
  b=lZ/5v32x52havGPdH6Nvro+6cRy/NFQvghOwMIvSNb/SespQWenlmq8A
   Jz29KpOZtOkxbU8tzRr4mEsJlxJOxXcf31U3ojF211d2Jtep5lrbtA46S
   vH1sfwpbMxaHlIt1HbYWwcKpZShxlr3A+Cvp2UqiOPyL3mrJP7oj0fHxa
   wFyz1Te/Y9PiOr6Cu8Tw4vJaY9LekmvbR09qY/n9HOW4tJah0jB2Ak6c3
   d6WvJTInVHMzsKJQl9cvcCSJiekSPBoNpnXrdmUeA+X+PtIW9b2HuAXcU
   +otBirtgCUIIHxw46S6p/7BtWzfzGEjt5pedwgJc2NnfDRPySBrTVla9l
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="359955952"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="359955952"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 17:14:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="775291192"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="775291192"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 08 Jun 2023 17:14:00 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 17:14:00 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 8 Jun 2023 17:14:00 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 8 Jun 2023 17:13:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2HvQcJpoSHgi3q943J4AS5SN3NhTGWLgRuqRHnInSJqDaGn2WGGArwcj9UjKsn5EcbufKPLoVO5Gur+wlvMsqSegvfnCG7/OFotsBTiciajpQkGJ8QzCRvGlEvubzeyJ3I8FunmAtnvEhSjAE2V8VBfH+lI+IcbmQKJhUSKpmikihOwNSzworZWHV5bElYO0r18Wg/AwMdGv4CDduMJ71ZM/Fj6Oevy4rmmLP2niyd2TqxEtvJTAwzrvghpkbc9DQ6kEADdSPRszKxuGy+QRMaOf4U0kazogxRFLCeNhQHMtVffpaIBz/EW74QARrHV13JIUKWzrFo2TKnti6lAew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u+Cc6cBQVjbm+DoEwToiGtgbHATFLYeo9MmhnG5+oD4=;
 b=cOv4c17/RDl+McxKirTxTtjb8HzgIME5vkktNL9MXetMVENEo7GKupU1xsySM4WuGpL70wvlgEYWXpnsxyqt8xCKvtUfJ06O4RgtOqqwb/VB3sYA1DbrjbLnKSf+m2qNVWnS9wPvDNYgOcnQumITZtpIyu6TflhMgT9hZx2d6TZGZg2LDev/bZfQfGDOvgxWe9CpQnrXYOk/ndaxV04ulN/5Gd+u9spFDM45d8ZLi93r5Jn4Sb3hJd0iJdw7dwFL2VSxJ2oBA9C2OR/qC6mWEGzoJmuI/07PbcY2QIIbKYNzEbMMSk4xP15FDEXhETaDFcJ70bjl5vSE9+qcNFxlFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS7PR11MB5967.namprd11.prod.outlook.com (2603:10b6:8:72::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 00:13:59 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 00:13:59 +0000
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
Subject: RE: [PATCH v7 9/9] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v7 9/9] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZlUvyHcxp7V+3vUOxOxg7tfrcA6+BhwMAgAAcT6A=
Date:   Fri, 9 Jun 2023 00:13:58 +0000
Message-ID: <DS0PR11MB7529919796EF251B6D65D26BC351A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
        <20230602121515.79374-10-yi.l.liu@intel.com>
 <20230608163018.70bf3345.alex.williamson@redhat.com>
In-Reply-To: <20230608163018.70bf3345.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS7PR11MB5967:EE_
x-ms-office365-filtering-correlation-id: 159b816f-5a28-4ee6-0a9a-08db687e6bb3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kHCmO5LswC56PMIewpZ6i4mrTvXr9bhd/afP/tKdxRmuM5nZcBhqPDjo8We1UIMyZqfcpga3t36xtIlWruoU+clVEfbcYP3WWtPCGzYpNXJlVMiT/c7Se8nkmMv+gD/3mjkNKubsMgcUv5jmr13OLs6HuTg89HjlN90YxEZm/tXO61WlIqcGRdRknFGnGpgzkZ7G4iETFpQUFpeeffb3cHbYCQ3K4axlMUGnj6EYRgpylLvBDnURF5OrE3viHL0E5FNN+S9kXpnz45YQHWaXCv21Umjn0ftUlMdHQoc1BsPRBCEClkrvvUkAUyeg34enBIBOvaL7Z7aHZhTIzZC9pkGYjmtAdiE90AxKs+8BpfIGoLOnFqSeU5iNgz/o+DA5Er63O9YPY38JSwAEC35zCcl/Qu+azsXX4s0pd3l9Fhfa9ve41121J5SWFqaFl4AERMW/nvFooFoCJ8f8CRzC8n0iIwox+2tzaOBv5ZTmf6bDHLsKfa59UZwbDAaedaGvJFbXRYXWnDXBIf8fPfPafR93SpSwF3k+GVebXgXa1QZZj5PBBXj+FwJU3fjORIFpKy2K28aTBD28v7Z5ogF9m9GLiXywT0T5M2mqzRWWO+BmZy7n0IzIhZ3YVB7xzsmG+tRKMKk+8WWXxBxNxc6SOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(136003)(376002)(396003)(366004)(451199021)(26005)(9686003)(6506007)(186003)(83380400001)(41300700001)(86362001)(7416002)(82960400001)(7696005)(71200400001)(2906002)(8676002)(8936002)(478600001)(55016003)(33656002)(316002)(38100700002)(5660300002)(76116006)(122000001)(6916009)(66446008)(4326008)(64756008)(38070700005)(66476007)(66946007)(52536014)(66556008)(54906003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emhteEtrQzZKWERaMUh2cWhuRVZYMHdaanYxSk9pQ25sSGg3QzV0QkxVbzdQ?=
 =?utf-8?B?VXZldjRuSndjQWhvbjhzS28rd0JiRmhPUkVoR0p5WkIxUTkzUVBYZHRvVjN1?=
 =?utf-8?B?NEFzak9FU2RER2NWdnRqU0N6STRoVnlJMXNmcmlNNDdieUl0NXdWdlUvd0Vs?=
 =?utf-8?B?SDJkUkNhRHh2VVRzYzFXdElrZnorVmoxRzZYVnZxRXc0VVExV0dOSVRkNjJ1?=
 =?utf-8?B?RGZPbUFiS09FWFZMTEVRM2xaSkx4UjVQYUF5RGRWenJxeCs3N2RqK0QwQnNM?=
 =?utf-8?B?TFJtdE11VHNFSldQZzc0YVh0aUpyOXN2NkllTmpSVWlMS0dlb3cvOWJqZ0hO?=
 =?utf-8?B?VEtsTHpQWFRmRzhVUXJtY0hsc250ZEk1ZHNPUlI5MHAzQjNwbnpEc1RvUVBh?=
 =?utf-8?B?aXFsb0VWTmVwM3JpbS9JcmZGczI2NkxIblNmMjJOUEc1RzdGSmJ0am1oMkVp?=
 =?utf-8?B?d085OEk4OVRNZlRiaDAycjdlcWE5SStWLytGcGtLK0o4ZUJpaVY3WEZSVDZh?=
 =?utf-8?B?andCMjczeE1HakU3QmRqZXoxQTBMOFdLeEdSK00wTW5Sc1NtZEUySjlYL2sw?=
 =?utf-8?B?b3g4dkdkVVZDSFdaSmlITnlJbzdxVHQ1ZzZyeEtCSC9ZZmpqWDBWSStnMHRp?=
 =?utf-8?B?aXhZcEdqeFRyRGJqaG9wN2dZSWhoNTFkT0RmekdTazJLbDZ1TGtyamFJOGdw?=
 =?utf-8?B?dnFrZHk3b1VPUmdPVDlJT29UZWM2QlNKUjBhSDdTMkJYUkgrbi96MGRPTVMw?=
 =?utf-8?B?cFRQbC9YTWVNeHd3OW14eXZVbmpXdnI3L0UyQUYwZXErTnRIV04zUmZzRGxP?=
 =?utf-8?B?d25KSTNaMUhIMkxtTElzMGZlakNIMXFYMTI0K2c5TzdyV0g1M1lmYk5ESjNo?=
 =?utf-8?B?VTB5WWhYNmdYUGt0SC9NRjJzS0lOeGpqbUl3Sk9PVncvQklxLzNDbDdKelBr?=
 =?utf-8?B?eldIQVc5RDB3Y3VKblgvTDIzS29Oak9SZ3V5RVNFZ3VWbHhhejB5QnlXOHB3?=
 =?utf-8?B?MWZnTjQweGVDUFFnWjNTQnBLcFdkNS85YTBxZG44cmwyTVJkdUlQdWd1RDNv?=
 =?utf-8?B?MHpNblE0Ukt3RXN2M2M1YXlLVE9odUpubEVDM25NYzFEWHU4S2srYjErUzZo?=
 =?utf-8?B?M1Erb2p5ZmRudDByaDl1ME55SUtKdmF4V05Ma21FS0k5U1VXTjl4STdCcWY0?=
 =?utf-8?B?amNxOHZ1b2M2ZlJFdGhEbEFZZ1V0czFBN3g4cllzeWFQdG15Zkt6MXhJcG9X?=
 =?utf-8?B?RWtGNmZKYm15RWZBbUs3R1Q3SlZ4L1VXVlJIY2lSa2RaaVRGaHlmZEtXSGZw?=
 =?utf-8?B?VGNvdkFnQWh6WFp6ZkM3NEtGdSsxLy80RlV4TElCWlk5RGZyS083cVdwUmxa?=
 =?utf-8?B?MStxVkoyUk9PSVBzY1hFSWtyNFVJRkpjUGlzS0lOamRScjZyZ1F3aC9NdEZ1?=
 =?utf-8?B?U2N4VHNCVHRyOHROZVZPZ1JoOUg1TTlzM2NhS0czd0J5L3FJMThHRVBWY2R2?=
 =?utf-8?B?UXY3V3hIVjc1cjNRSmdoWlZTMGx1ampDemJESjdPMFFmZFNvVWM5T3UyWEJr?=
 =?utf-8?B?aklUUDlYZkJPcU4zN0R4akV5QmxkdHJEUkw3dUVaUFNvZDE2YW5VbmdZODBm?=
 =?utf-8?B?dWdpSHF5TGxTc2hkOXVHbGJHelZhMGxIRnlKcFdnUysyOHpsZXRrdkttblI5?=
 =?utf-8?B?UmFTV2I1ZlhSTm41c1JRRklmcENucS81L1BuZ1UzU1Q3QWFHZDRSUmVWaWJz?=
 =?utf-8?B?RFNHOTZtSlJKQ1NIbUFjRUNMd2Q5WHIvcGRrVTVpUWdqKy96Rk5LdmFZT2xh?=
 =?utf-8?B?bVJNNy94RnpNQlFDby80aEZPdTdEcFFJdFRMS0lNQmliUzFRVDF5RE4xYlgz?=
 =?utf-8?B?MW56Uys3bjdoaTJTVzdiUGRsc0s5eFEwb2RUUzhTd1V1YVNQWFZSWFRQYUlF?=
 =?utf-8?B?M2w1Qi9idWZXTnpYRFBPOXcwT0hvdU5YOEVENkxJeUhjYXlBc3VHREIzTDcr?=
 =?utf-8?B?a1Avc2RjTnRWU2hIMEFqeWJIZldzN1prcmtrNUJPdjB1YkFEaU9UNUVEQkZR?=
 =?utf-8?B?b0ZsYTByS01PRUFLMFMzQlYwVW1xY09MNWlqcXdqQVlyeFFKQlFWcHBJRjJF?=
 =?utf-8?Q?cjYhTlTBGY50IxGaH8Rk0zR8c?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 159b816f-5a28-4ee6-0a9a-08db687e6bb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2023 00:13:58.4785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nEXXNG/YuNbSJA/vmvY+T7py5E/GjfEN3G+UtdkbnlJiSwD+6t8yJAr7wGE4+8xQ7tznxuwu1ETg++IxVIAhCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5967
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBGcmlkYXksIEp1bmUgOSwgMjAyMyA2OjMwIEFNDQo+IA0KPiBPbiBGcmksICAyIEp1biAy
MDIzIDA1OjE1OjE1IC0wNzAwDQo+IFlpIExpdSA8eWkubC5saXVAaW50ZWwuY29tPiB3cm90ZToN
Cj4gDQo+ID4gVGhpcyBpcyB0aGUgd2F5IHVzZXIgdG8gaW52b2tlIGhvdC1yZXNldCBmb3IgdGhl
IGRldmljZXMgb3BlbmVkIGJ5IGNkZXYNCj4gPiBpbnRlcmZhY2UuIFVzZXIgc2hvdWxkIGNoZWNr
IHRoZSBmbGFnIFZGSU9fUENJX0hPVF9SRVNFVF9GTEFHX0RFVl9JRF9PV05FRA0KPiA+IGluIHRo
ZSBvdXRwdXQgb2YgVkZJT19ERVZJQ0VfR0VUX1BDSV9IT1RfUkVTRVRfSU5GTyBpb2N0bCBiZWZv
cmUgZG9pbmcNCj4gPiBob3QtcmVzZXQgZm9yIGNkZXYgZGV2aWNlcy4NCj4gPg0KPiA+IFN1Z2dl
c3RlZC1ieTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4NCj4gPiBTaWduZWQtb2Zm
LWJ5OiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBK
YXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiA+IFRlc3RlZC1ieTogWWFudGluZyBK
aWFuZyA8eWFudGluZy5qaWFuZ0BpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogWWkgTGl1
IDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvdmZpby9wY2kvdmZp
b19wY2lfY29yZS5jIHwgNjEgKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0NCj4gPiAg
aW5jbHVkZS91YXBpL2xpbnV4L3ZmaW8uaCAgICAgICAgfCAxNCArKysrKysrKw0KPiA+ICAyIGZp
bGVzIGNoYW5nZWQsIDY0IGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmZpby9wY2kvdmZpb19wY2lfY29yZS5jIGIvZHJpdmVycy92
ZmlvL3BjaS92ZmlvX3BjaV9jb3JlLmMNCj4gPiBpbmRleCBhNjE1YTIyM2NkZWYuLmIwZWFkYWZj
YmNmNSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2NvcmUuYw0K
PiA+ICsrKyBiL2RyaXZlcnMvdmZpby9wY2kvdmZpb19wY2lfY29yZS5jDQo+ID4gQEAgLTE4MSw3
ICsxODEsOCBAQCBzdGF0aWMgdm9pZCB2ZmlvX3BjaV9wcm9iZV9tbWFwcyhzdHJ1Y3QgdmZpb19w
Y2lfY29yZV9kZXZpY2UNCj4gKnZkZXYpDQo+ID4gIHN0cnVjdCB2ZmlvX3BjaV9ncm91cF9pbmZv
Ow0KPiA+ICBzdGF0aWMgdm9pZCB2ZmlvX3BjaV9kZXZfc2V0X3RyeV9yZXNldChzdHJ1Y3QgdmZp
b19kZXZpY2Vfc2V0ICpkZXZfc2V0KTsNCj4gPiAgc3RhdGljIGludCB2ZmlvX3BjaV9kZXZfc2V0
X2hvdF9yZXNldChzdHJ1Y3QgdmZpb19kZXZpY2Vfc2V0ICpkZXZfc2V0LA0KPiA+IC0JCQkJICAg
ICAgc3RydWN0IHZmaW9fcGNpX2dyb3VwX2luZm8gKmdyb3Vwcyk7DQo+ID4gKwkJCQkgICAgICBz
dHJ1Y3QgdmZpb19wY2lfZ3JvdXBfaW5mbyAqZ3JvdXBzLA0KPiA+ICsJCQkJICAgICAgc3RydWN0
IGlvbW11ZmRfY3R4ICppb21tdWZkX2N0eCk7DQo+ID4NCj4gPiAgLyoNCj4gPiAgICogSU5UeCBt
YXNraW5nIHJlcXVpcmVzIHRoZSBhYmlsaXR5IHRvIGRpc2FibGUgSU5UeCBzaWduYWxpbmcgdmlh
IFBDSV9DT01NQU5EDQo+ID4gQEAgLTEzMDgsOCArMTMwOSw3IEBAIHZmaW9fcGNpX2lvY3RsX3Bj
aV9ob3RfcmVzZXRfZ3JvdXBzKHN0cnVjdA0KPiB2ZmlvX3BjaV9jb3JlX2RldmljZSAqdmRldiwN
Cj4gPiAgCWlmIChyZXQpDQo+ID4gIAkJcmV0dXJuIHJldDsNCj4gPg0KPiA+IC0JLyogU29tZXdo
ZXJlIGJldHdlZW4gMSBhbmQgY291bnQgaXMgT0sgKi8NCj4gPiAtCWlmICghYXJyYXlfY291bnQg
fHwgYXJyYXlfY291bnQgPiBjb3VudCkNCj4gPiArCWlmIChhcnJheV9jb3VudCA+IGNvdW50KQ0K
PiA+ICAJCXJldHVybiAtRUlOVkFMOw0KPiA+DQo+ID4gIAlncm91cF9mZHMgPSBrY2FsbG9jKGFy
cmF5X2NvdW50LCBzaXplb2YoKmdyb3VwX2ZkcyksIEdGUF9LRVJORUwpOw0KPiA+IEBAIC0xMzU4
LDcgKzEzNTgsNyBAQCB2ZmlvX3BjaV9pb2N0bF9wY2lfaG90X3Jlc2V0X2dyb3VwcyhzdHJ1Y3QN
Cj4gdmZpb19wY2lfY29yZV9kZXZpY2UgKnZkZXYsDQo+ID4gIAlpbmZvLmNvdW50ID0gYXJyYXlf
Y291bnQ7DQo+ID4gIAlpbmZvLmZpbGVzID0gZmlsZXM7DQo+ID4NCj4gPiAtCXJldCA9IHZmaW9f
cGNpX2Rldl9zZXRfaG90X3Jlc2V0KHZkZXYtPnZkZXYuZGV2X3NldCwgJmluZm8pOw0KPiA+ICsJ
cmV0ID0gdmZpb19wY2lfZGV2X3NldF9ob3RfcmVzZXQodmRldi0+dmRldi5kZXZfc2V0LCAmaW5m
bywgTlVMTCk7DQo+ID4NCj4gPiAgaG90X3Jlc2V0X3JlbGVhc2U6DQo+ID4gIAlmb3IgKGZpbGVf
aWR4LS07IGZpbGVfaWR4ID49IDA7IGZpbGVfaWR4LS0pDQo+ID4gQEAgLTEzODEsMTMgKzEzODEs
MjEgQEAgc3RhdGljIGludCB2ZmlvX3BjaV9pb2N0bF9wY2lfaG90X3Jlc2V0KHN0cnVjdA0KPiB2
ZmlvX3BjaV9jb3JlX2RldmljZSAqdmRldiwNCj4gPiAgCWlmIChoZHIuYXJnc3ogPCBtaW5zeiB8
fCBoZHIuZmxhZ3MpDQo+ID4gIAkJcmV0dXJuIC1FSU5WQUw7DQo+ID4NCj4gPiArCS8qIHplcm8t
bGVuZ3RoIGFycmF5IGlzIG9ubHkgZm9yIGNkZXYgb3BlbmVkIGRldmljZXMgKi8NCj4gPiArCWlm
ICghIWhkci5jb3VudCA9PSB2ZmlvX2RldmljZV9jZGV2X29wZW5lZCgmdmRldi0+dmRldikpDQo+
ID4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ID4gKw0KPiA+ICAJLyogQ2FuIHdlIGRvIGEgc2xvdCBv
ciBidXMgcmVzZXQgb3IgbmVpdGhlcj8gKi8NCj4gPiAgCWlmICghcGNpX3Byb2JlX3Jlc2V0X3Ns
b3QodmRldi0+cGRldi0+c2xvdCkpDQo+ID4gIAkJc2xvdCA9IHRydWU7DQo+ID4gIAllbHNlIGlm
IChwY2lfcHJvYmVfcmVzZXRfYnVzKHZkZXYtPnBkZXYtPmJ1cykpDQo+ID4gIAkJcmV0dXJuIC1F
Tk9ERVY7DQo+ID4NCj4gPiAtCXJldHVybiB2ZmlvX3BjaV9pb2N0bF9wY2lfaG90X3Jlc2V0X2dy
b3Vwcyh2ZGV2LCBoZHIuY291bnQsIHNsb3QsIGFyZyk7DQo+ID4gKwlpZiAoaGRyLmNvdW50KQ0K
PiA+ICsJCXJldHVybiB2ZmlvX3BjaV9pb2N0bF9wY2lfaG90X3Jlc2V0X2dyb3Vwcyh2ZGV2LCBo
ZHIuY291bnQsIHNsb3QsIGFyZyk7DQo+ID4gKw0KPiA+ICsJcmV0dXJuIHZmaW9fcGNpX2Rldl9z
ZXRfaG90X3Jlc2V0KHZkZXYtPnZkZXYuZGV2X3NldCwgTlVMTCwNCj4gPiArCQkJCQkgIHZmaW9f
aW9tbXVmZF9kZXZpY2VfaWN0eCgmdmRldi0+dmRldikpOw0KPiA+ICB9DQo+ID4NCj4gPiAgc3Rh
dGljIGludCB2ZmlvX3BjaV9pb2N0bF9pb2V2ZW50ZmQoc3RydWN0IHZmaW9fcGNpX2NvcmVfZGV2
aWNlICp2ZGV2LA0KPiA+IEBAIC0yMzU0LDEzICsyMzYyLDE2IEBAIGNvbnN0IHN0cnVjdCBwY2lf
ZXJyb3JfaGFuZGxlcnMNCj4gdmZpb19wY2lfY29yZV9lcnJfaGFuZGxlcnMgPSB7DQo+ID4gIH07
DQo+ID4gIEVYUE9SVF9TWU1CT0xfR1BMKHZmaW9fcGNpX2NvcmVfZXJyX2hhbmRsZXJzKTsNCj4g
Pg0KPiA+IC1zdGF0aWMgYm9vbCB2ZmlvX2Rldl9pbl9ncm91cHMoc3RydWN0IHZmaW9fcGNpX2Nv
cmVfZGV2aWNlICp2ZGV2LA0KPiA+ICtzdGF0aWMgYm9vbCB2ZmlvX2Rldl9pbl9ncm91cHMoc3Ry
dWN0IHZmaW9fZGV2aWNlICp2ZGV2LA0KPiA+ICAJCQkgICAgICAgc3RydWN0IHZmaW9fcGNpX2dy
b3VwX2luZm8gKmdyb3VwcykNCj4gPiAgew0KPiA+ICAJdW5zaWduZWQgaW50IGk7DQo+ID4NCj4g
PiArCWlmICghZ3JvdXBzKQ0KPiA+ICsJCXJldHVybiBmYWxzZTsNCj4gPiArDQo+ID4gIAlmb3Ig
KGkgPSAwOyBpIDwgZ3JvdXBzLT5jb3VudDsgaSsrKQ0KPiA+IC0JCWlmICh2ZmlvX2ZpbGVfaGFz
X2Rldihncm91cHMtPmZpbGVzW2ldLCAmdmRldi0+dmRldikpDQo+ID4gKwkJaWYgKHZmaW9fZmls
ZV9oYXNfZGV2KGdyb3Vwcy0+ZmlsZXNbaV0sIHZkZXYpKQ0KPiA+ICAJCQlyZXR1cm4gdHJ1ZTsN
Cj4gPiAgCXJldHVybiBmYWxzZTsNCj4gPiAgfQ0KPiA+IEBAIC0yNDM2LDcgKzI0NDcsOCBAQCBz
dGF0aWMgaW50IHZmaW9fcGNpX2Rldl9zZXRfcG1fcnVudGltZV9nZXQoc3RydWN0DQo+IHZmaW9f
ZGV2aWNlX3NldCAqZGV2X3NldCkNCj4gPiAgICogZ2V0IGVhY2ggbWVtb3J5X2xvY2suDQo+ID4g
ICAqLw0KPiA+ICBzdGF0aWMgaW50IHZmaW9fcGNpX2Rldl9zZXRfaG90X3Jlc2V0KHN0cnVjdCB2
ZmlvX2RldmljZV9zZXQgKmRldl9zZXQsDQo+ID4gLQkJCQkgICAgICBzdHJ1Y3QgdmZpb19wY2lf
Z3JvdXBfaW5mbyAqZ3JvdXBzKQ0KPiA+ICsJCQkJICAgICAgc3RydWN0IHZmaW9fcGNpX2dyb3Vw
X2luZm8gKmdyb3VwcywNCj4gPiArCQkJCSAgICAgIHN0cnVjdCBpb21tdWZkX2N0eCAqaW9tbXVm
ZF9jdHgpDQo+ID4gIHsNCj4gPiAgCXN0cnVjdCB2ZmlvX3BjaV9jb3JlX2RldmljZSAqY3VyX21l
bTsNCj4gPiAgCXN0cnVjdCB2ZmlvX3BjaV9jb3JlX2RldmljZSAqY3VyX3ZtYTsNCj4gPiBAQCAt
MjQ2NiwxMSArMjQ3OCwzOCBAQCBzdGF0aWMgaW50IHZmaW9fcGNpX2Rldl9zZXRfaG90X3Jlc2V0
KHN0cnVjdA0KPiB2ZmlvX2RldmljZV9zZXQgKmRldl9zZXQsDQo+ID4gIAkJZ290byBlcnJfdW5s
b2NrOw0KPiA+DQo+ID4gIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KGN1cl92bWEsICZkZXZfc2V0LT5k
ZXZpY2VfbGlzdCwgdmRldi5kZXZfc2V0X2xpc3QpIHsNCj4gPiArCQlib29sIG93bmVkOw0KPiA+
ICsNCj4gPiAgCQkvKg0KPiA+IC0JCSAqIFRlc3Qgd2hldGhlciBhbGwgdGhlIGFmZmVjdGVkIGRl
dmljZXMgYXJlIGNvbnRhaW5lZCBieSB0aGUNCj4gPiAtCQkgKiBzZXQgb2YgZ3JvdXBzIHByb3Zp
ZGVkIGJ5IHRoZSB1c2VyLg0KPiA+ICsJCSAqIFRlc3Qgd2hldGhlciBhbGwgdGhlIGFmZmVjdGVk
IGRldmljZXMgY2FuIGJlIHJlc2V0IGJ5IHRoZQ0KPiA+ICsJCSAqIHVzZXIuDQo+ID4gKwkJICoN
Cj4gPiArCQkgKiBJZiBjYWxsZWQgZnJvbSBhIGdyb3VwIG9wZW5lZCBkZXZpY2UgYW5kIHRoZSB1
c2VyIHByb3ZpZGVzDQo+ID4gKwkJICogYSBzZXQgb2YgZ3JvdXBzLCBhbGwgdGhlIGRldmljZXMg
aW4gdGhlIGRldl9zZXQgc2hvdWxkIGJlDQo+ID4gKwkJICogY29udGFpbmVkIGJ5IHRoZSBzZXQg
b2YgZ3JvdXBzIHByb3ZpZGVkIGJ5IHRoZSB1c2VyLg0KPiA+ICsJCSAqDQo+ID4gKwkJICogSWYg
Y2FsbGVkIGZyb20gYSBjZGV2IG9wZW5lZCBkZXZpY2UgYW5kIHRoZSB1c2VyIHByb3ZpZGVzDQo+
ID4gKwkJICogYSB6ZXJvLWxlbmd0aCBhcnJheSwgYWxsIHRoZSBkZXZpY2VzIGluIHRoZSBkZXZf
c2V0IG11c3QNCj4gPiArCQkgKiBiZSBib3VuZCB0byB0aGUgc2FtZSBpb21tdWZkX2N0eCBhcyB0
aGUgaW5wdXQgaW9tbXVmZF9jdHguDQo+ID4gKwkJICogSWYgdGhlcmUgaXMgYW55IGRldmljZSB0
aGF0IGhhcyBub3QgYmVlbiBib3VuZCB0byBhbnkNCj4gPiArCQkgKiBpb21tdWZkX2N0eCB5ZXQs
IGNoZWNrIGlmIGl0cyBpb21tdV9ncm91cCBoYXMgYW55IGRldmljZQ0KPiA+ICsJCSAqIGJvdW5k
IHRvIHRoZSBpbnB1dCBpb21tdWZkX2N0eC4gIFN1Y2ggZGV2aWNlcyBjYW4gYmUNCj4gPiArCQkg
KiBjb25zaWRlcmVkIG93bmVkIGJ5IHRoZSBpbnB1dCBpb21tdWZkX2N0eCBhcyB0aGUgZGV2aWNl
DQo+ID4gKwkJICogY2Fubm90IGJlIG93bmVkIGJ5IGFub3RoZXIgaW9tbXVmZF9jdHggd2hlbiBp
dHMgaW9tbXVfZ3JvdXANCj4gPiArCQkgKiBpcyBvd25lZC4NCj4gPiArCQkgKg0KPiA+ICsJCSAq
IE90aGVyd2lzZSwgcmVzZXQgaXMgbm90IGFsbG93ZWQuDQo+ID4gIAkJICovDQo+ID4gLQkJaWYg
KCF2ZmlvX2Rldl9pbl9ncm91cHMoY3VyX3ZtYSwgZ3JvdXBzKSkgew0KPiA+ICsJCWlmIChpb21t
dWZkX2N0eCkgew0KPiA+ICsJCQlpbnQgZGV2aWQgPSB2ZmlvX2lvbW11ZmRfZGV2aWNlX2hvdF9y
ZXNldF9kZXZpZCgmY3VyX3ZtYS0NCj4gPnZkZXYsDQo+ID4gKwkJCQkJCQkJCWlvbW11ZmRfY3R4
KTsNCj4gPiArDQo+ID4gKwkJCW93bmVkID0gKGRldmlkICE9IFZGSU9fUENJX0RFVklEX05PVF9P
V05FRCk7DQo+ID4gKwkJfSBlbHNlIHsNCj4gPiArCQkJb3duZWQgPSB2ZmlvX2Rldl9pbl9ncm91
cHMoJmN1cl92bWEtPnZkZXYsIGdyb3Vwcyk7DQo+ID4gKwkJfQ0KPiA+ICsNCj4gPiArCQlpZiAo
IW93bmVkKSB7DQo+ID4gIAkJCXJldCA9IC1FSU5WQUw7DQo+ID4gIAkJCWdvdG8gZXJyX3VuZG87
DQo+ID4gIAkJfQ0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvdmZpby5oIGIv
aW5jbHVkZS91YXBpL2xpbnV4L3ZmaW8uaA0KPiA+IGluZGV4IDcwY2MzMWU2YjFjZS4uZjc1MzEy
NGUxYzgyIDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC92ZmlvLmgNCj4gPiAr
KysgYi9pbmNsdWRlL3VhcGkvbGludXgvdmZpby5oDQo+ID4gQEAgLTY5MCw2ICs2OTAsOSBAQCBl
bnVtIHsNCj4gPiAgICoJICBhZmZlY3RlZCBkZXZpY2VzIGFyZSByZXByZXNlbnRlZCBpbiB0aGUg
ZGV2X3NldCBhbmQgYWxzbyBvd25lZCBieQ0KPiA+ICAgKgkgIHRoZSB1c2VyLiAgVGhpcyBmbGFn
IGlzIGF2YWlsYWJsZSBvbmx5IHdoZW4NCj4gPiAgICoJICBmbGFnIFZGSU9fUENJX0hPVF9SRVNF
VF9GTEFHX0RFVl9JRCBpcyBzZXQsIG90aGVyd2lzZSByZXNlcnZlZC4NCj4gPiArICoJICBXaGVu
IHNldCwgdXNlciBjb3VsZCBpbnZva2UgVkZJT19ERVZJQ0VfUENJX0hPVF9SRVNFVCB3aXRoIGEg
emVybw0KPiA+ICsgKgkgIGxlbmd0aCBmZCBhcnJheSBvbiB0aGUgY2FsbGluZyBkZXZpY2UgYXMg
dGhlIG93bmVyc2hpcCBpcyB2YWxpZGF0ZWQNCj4gPiArICoJICBieSBpb21tdWZkX2N0eC4NCj4g
PiAgICoNCj4gPiAgICogUmV0dXJuOiAwIG9uIHN1Y2Nlc3MsIC1lcnJubyBvbiBmYWlsdXJlOg0K
PiA+ICAgKgktZW5vc3BjID0gaW5zdWZmaWNpZW50IGJ1ZmZlciwgLWVub2RldiA9IHVuc3VwcG9y
dGVkIGZvciBkZXZpY2UuDQo+ID4gQEAgLTcyMSw2ICs3MjQsMTcgQEAgc3RydWN0IHZmaW9fcGNp
X2hvdF9yZXNldF9pbmZvIHsNCj4gPiAgICogVkZJT19ERVZJQ0VfUENJX0hPVF9SRVNFVCAtIF9J
T1coVkZJT19UWVBFLCBWRklPX0JBU0UgKyAxMywNCj4gPiAgICoJCQkJICAgIHN0cnVjdCB2Zmlv
X3BjaV9ob3RfcmVzZXQpDQo+ID4gICAqDQo+ID4gKyAqIFVzZXJzcGFjZSByZXF1ZXN0cyBob3Qg
cmVzZXQgZm9yIHRoZSBkZXZpY2VzIGl0IG9wZXJhdGVzLiAgRHVlIHRvIHRoZQ0KPiA+ICsgKiB1
bmRlcmx5aW5nIHRvcG9sb2d5LCBtdWx0aXBsZSBkZXZpY2VzIGNhbiBiZSBhZmZlY3RlZCBpbiB0
aGUgcmVzZXQNCj4gPiArICogd2hpbGUgc29tZSBtaWdodCBiZSBvcGVuZWQgYnkgYW5vdGhlciB1
c2VyLiAgVG8gYXZvaWQgaW50ZXJmZXJlbmNlDQo+ID4gKyAqIHRoZSBjYWxsaW5nIHVzZXIgbXVz
dCBlbnN1cmUgYWxsIGFmZmVjdGVkIGRldmljZXMgYXJlIG93bmVkIGJ5IGl0c2VsZi4NCj4gDQo+
IFRoaXMgcGhyYXNpbmcgc3VnZ2VzdCB0byBtZSB0aGF0IHdlJ3JlIHBsYWNpbmcgdGhlIHJlc3Bv
bnNpYmlsaXR5IG9uDQo+IHRoZSB1c2VyIHRvIGF2b2lkIHJlc2V0dGluZyBhbm90aGVyIHVzZXIn
cyBkZXZpY2VzLg0KDQpUaGlzIHJlc3BvbnNpYmlsaXR5IGlzIG5vdCBuZXcuIElzIGl0PyDwn5iK
DQoNCj4gUGVyaGFwcyB0aGVzZQ0KPiBwYXJhZ3JhcGhzIGNvdWxkIGJlIHJlcGxhY2VkIHdpdGg6
DQo+IA0KPiAgIEEgUENJIGhvdCByZXNldCByZXN1bHRzIGluIGVpdGhlciBhIGJ1cyBvciBzbG90
IHJlc2V0IHdoaWNoIG1heSBhZmZlY3QNCj4gICBvdGhlciBkZXZpY2VzIHNoYXJpbmcgdGhlIGJ1
cy9zbG90LiAgVGhlIGNhbGxpbmcgdXNlciBtdXN0IGhhdmUNCj4gICBvd25lcnNoaXAgb2YgdGhl
IGZ1bGwgc2V0IG9mIGFmZmVjdGVkIGRldmljZXMgYXMgZGV0ZXJtaW5lZCBieSB0aGUNCj4gICBW
RklPX0RFVklDRV9HRVRfUENJX0hPVF9SRVNFVF9JTkZPIGlvY3RsLg0KPiANCj4gICBXaGVuIGNh
bGxlZCBvbiBhIGRldmljZSBmaWxlIGRlc2NyaXB0b3IgYWNxdWlyZWQgdGhyb3VnaCB0aGUgdmZp
bw0KPiAgIGdyb3VwIGludGVyZmFjZSwgdGhlIHVzZXIgaXMgcmVxdWlyZWQgdG8gcHJvdmlkZSBw
cm9vZiBvZiBvd25lcnNoaXANCj4gICBvZiB0aG9zZSBhZmZlY3RlZCBkZXZpY2VzIHZpYSB0aGUg
Z3JvdXBfZmRzIGFycmF5IGluIHN0cnVjdA0KPiAgIHZmaW9fcGNpX2hvdF9yZXNldC4NCj4gDQo+
ICAgV2hlbiBjYWxsZWQgb24gYSBkaXJlY3QgY2RldiBvcGVuZWQgdmZpbyBkZXZpY2UsIHRoZSBm
bGFncyBmaWVsZCBvZg0KPiAgIHN0cnVjdCB2ZmlvX3BjaV9ob3RfcmVzZXRfaW5mbyByZXBvcnRz
IHRoZSBvd25lcnNoaXAgc3RhdHVzIG9mIHRoZQ0KPiAgIGFmZmVjdGVkIGRldmljZXMgYW5kIHRo
aXMgaW9jdGwgbXVzdCBiZSBjYWxsZWQgd2l0aCBhbiBlbXB0eSBncm91cF9mZHMNCj4gICBhcnJh
eS4gIFNlZSBhYm92ZSBJTkZPIGlvY3RsIGRlZmluaXRpb24gZm9yIG93bmVyc2hpcCByZXF1aXJl
bWVudHMuDQo+IA0KPiAgIE1peGVkIHVzYWdlIG9mIGxlZ2FjeSBncm91cHMgYW5kIGNkZXZzIGFj
cm9zcyB0aGUgc2V0IG9mIGFmZmVjdGVkDQo+ICAgZGV2aWNlcyBpcyBub3Qgc3VwcG9ydGVkLg0K
DQpBYm92ZSBpcyBiZXR0ZXIuIA0KDQo+IE90aGVyIHRoYW4gdGhpcyBhbmQgdGhlIGNvdXBsZSBv
dGhlciBjb21tZW50cywgdGhlIHNlcmllcyBsb29rcyBvayB0bw0KPiBtZS4gIFdlIHN0aWxsIG5l
ZWQgYWNrcyBmcm9tIEphc29uIGZvciBpb21tdWZkIG9uIDMtNS4gIFRoYW5rcywNCg0KVGhhbmtz
LCBwZXJoYXBzIG9uZSBtb3JlIHZlcnNpb24gYWZ0ZXIgZ2V0dGluZyBmZWVkYmFjayBmcm9tIEph
c29uLg0KDQpSZWdhcmRzLA0KWWkgTGl1DQoNCj4gQWxleA0KPiANCj4gPiArICoNCj4gPiArICog
QXMgdGhlIG93bmVyc2hpcCBkZXNjcmliZWQgYnkgVkZJT19ERVZJQ0VfR0VUX1BDSV9IT1RfUkVT
RVRfSU5GTywgdGhlDQo+ID4gKyAqIGNkZXYgb3BlbmVkIGRldmljZXMgbXVzdCBleGNsdXNpdmVs
eSBwcm92aWRlIGEgemVyby1sZW5ndGggZmQgYXJyYXkgYW5kDQo+ID4gKyAqIHRoZSBncm91cCBv
cGVuZWQgZGV2aWNlcyBtdXN0IGV4Y2x1c2l2ZWx5IHVzZSBhbiBhcnJheSBvZiBncm91cCBmZHMg
Zm9yDQo+ID4gKyAqIHByb29mIG9mIG93bmVyc2hpcC4gIE1peGVkIGFjY2VzcyB0byBkZXZpY2Vz
IGJldHdlZW4gY2RldiBhbmQgbGVnYWN5DQo+ID4gKyAqIGdyb3VwcyBhcmUgbm90IHN1cHBvcnRl
ZCBieSB0aGlzIGludGVyZmFjZS4NCj4gPiArICoNCj4gPiAgICogUmV0dXJuOiAwIG9uIHN1Y2Nl
c3MsIC1lcnJubyBvbiBmYWlsdXJlLg0KPiA+ICAgKi8NCj4gPiAgc3RydWN0IHZmaW9fcGNpX2hv
dF9yZXNldCB7DQoNCg==
