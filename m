Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE36F312278
	for <lists+kvm@lfdr.de>; Sun,  7 Feb 2021 09:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhBGIVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Feb 2021 03:21:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:47808 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229693AbhBGIUu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Feb 2021 03:20:50 -0500
IronPort-SDR: GA/wlMb8QpMsCx3dgcEg2I/eQsZVyyozopFD5KZsQCbQEHchXhwrkjSKyWD+r4sEeKkzK8ZD+i
 5D/0b1IDgdDQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9887"; a="178084895"
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="178084895"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2021 00:20:09 -0800
IronPort-SDR: Xym7UOfOcihzzzfcmoYRDVWb4nBX3HYCVrAo+GHDsAFYv3C+JMVPT2zYOyR+a2an7Zx5SG1imS
 5SlDDa0jh31A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="394637679"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga008.jf.intel.com with ESMTP; 07 Feb 2021 00:20:09 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Sun, 7 Feb 2021 00:20:08 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Sun, 7 Feb 2021 00:20:08 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Sun, 7 Feb 2021 00:20:08 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sun, 7 Feb 2021 00:20:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e9FwQ58hYXjf7UX/qtWdvtBppH8EUdHW5meW2f8a7dRhBwKzLURWLDGNFmu5HMJ3PLR/2ZOmugPiQPgxH8vGzPyqvZPSrQxhFKFGSJ0oEiGM816she5MybSnyHj/b7MqtOQU8j6lAHh2HhTMbVfLPs/oxpWoFYMSALwvOQ/fl0MLBzolShZz7FLbXqbHCdjQEe7Vbe/j2e/61O9t0OYN45f7Fl9gpbaHi9RmYgC3YOHcI75kzeL6DoWeTe1VtoGPqqbpJoLyI7uMFb1p01S+WpHzupUjTWDUUshxPw2DFvrKeOeS5rCz1dqHgwaYCg9KEmqeI111kZxVghHzQm2Big==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8qAwMRqJYJAIt2UlDamHZWRSsbRsWDs/vmPjSR3nm4=;
 b=SAYtoH5cPLjv/Hce+THlqKmAhs8++TkHZiP06LgESh5Balcnzm+wR2dIwO/+QrcYgqAzkaBnDF7juNxmx15rXcSEWUpLn4FLrLaby1EFsQxuSnClwgQpQxw7q8/F/6GbnzMHNJonS7fYWHOd3gjGEkTWW0irNC15uPecClOQHovEKRFgbx42FhxGlD/ENEGdadeCfPgFXQxVwGwoDGnOQ75cPzZ9ReGYU8fQCtCBQfdStDQ3/gXVyG05vcffWQ/MHxND2WZATH3FKJM0uzv3/j75kE1TFgqrJtaSitRtCJMhSnyauYjauxsm+cf2lIHsc9PdAM+ws2SFlaZ2RaoLbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8qAwMRqJYJAIt2UlDamHZWRSsbRsWDs/vmPjSR3nm4=;
 b=mQIG+jQ6w/AnTtbF3YHA1PH+RhqGbzB2O+L4eQf//eimGJ76vAICITJ/WmPM8RQ4o0w3bgMy3lSSiM9wJd5A9H5yiRLq3U2o5DqNTfMfHFyKxv8LbqxXXBps/OEZ8M58W0CpGVFfmDLw/CBcCYRPTbuSNwR+aj6C+L9bFG0El5o=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB2016.namprd11.prod.outlook.com (2603:10b6:300:26::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.27; Sun, 7 Feb
 2021 08:20:06 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::f1b4:bace:1e44:4a46]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::f1b4:bace:1e44:4a46%6]) with mapi id 15.20.3825.029; Sun, 7 Feb 2021
 08:20:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     Shenming Lu <lushenming@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [RFC PATCH v1 0/4] vfio: Add IOPF support for VFIO passthrough
Thread-Topic: [RFC PATCH v1 0/4] vfio: Add IOPF support for VFIO passthrough
Thread-Index: AQHW8vkytb+JKYXDyUeYG8HWtmg34ao/PksAgAOljRCAAZMegIADINTAgAHYDICAAupCcA==
Date:   Sun, 7 Feb 2021 08:20:06 +0000
Message-ID: <MWHPR11MB1886D07D927A77DCB2FF74D48CB09@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210125090402.1429-1-lushenming@huawei.com>
 <20210129155730.3a1d49c5@omen.home.shazbot.org>
 <MWHPR11MB188684B42632FD0B9B5CA1C08CB69@MWHPR11MB1886.namprd11.prod.outlook.com>
 <47bf7612-4fb0-c0bb-fa19-24c4e3d01d3f@huawei.com>
 <MWHPR11MB1886C71A751B48EF626CAC938CB39@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YB0f5Yno9frihQq4@myrica>
In-Reply-To: <YB0f5Yno9frihQq4@myrica>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.88.226.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90703fa0-0a97-44da-cd2f-08d8cb412d0f
x-ms-traffictypediagnostic: MWHPR11MB2016:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB20162285C9D094CD573A06328CB09@MWHPR11MB2016.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qdRQoSgjoLTqJ27saBXfpSgvYltvXTRDGKmML49E2p3kuZoxAgRJk+9QkhLD3Kj6TQbWwcjiOOE05RWUS61C3IJOEpYPv8vTCnNQ5MLIc2eh7VaFLqUgl0n3+c0mPaTSf6Aoo+rUXTZzoMqtQu/WrvhA+tdBrQKCfKkI2cj3FyE6mGfauduunPIs3klz0lRDFgT3wrkDMlhUK+R9RSkRIVYON5PnvwhB2ik2F2rUhqTtvHpL0R6/8V/L/Q5Nuf3+QzH6+02V5y+Xi7aSAPKGzrzigebS788/4cvv1yUz3FeFmgzfh8SHjRK0yfR+DmU1IwoUmhDrwMxvh3dO3r5/lJNqtNwjGM7nnz+Eu7NHz3EvAvGnVYIxIfyjYigm09b8W+JvDTx0vo5pXeqKe5ROU4DRptg16oNSpEd3MC08ZGKheJPRUZaf42VmwcWknVEG+I4pM22Xz0CApA8AJvoRkJ1/aYggFs4NUg/afD7w+tvAuQX5DIl0/iUPw4vvm9YtBfC+ISzGRHo2iMi8tGoSK4u5Qx4LdwCjfqbSlUrP62eb0g6Bv6qhr9R9D/wLVx+9Ds9EmYLCIBtRaHh9NVXtsML9DD86juROVFk+NO19HYo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(136003)(396003)(376002)(83380400001)(66476007)(66946007)(55016002)(26005)(66446008)(66556008)(86362001)(76116006)(2906002)(478600001)(316002)(966005)(4326008)(6506007)(54906003)(5660300002)(52536014)(8676002)(7696005)(64756008)(8936002)(6916009)(186003)(33656002)(71200400001)(9686003)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bWxhaUJ6L3ZPTW9GRHN5YUNPWnh4aysza3dBWS9rMmpicE9MdTRSbElwaVlX?=
 =?utf-8?B?TnJjbTBkcnpDbkVnWlMvYzlYanRFVDRJYmViandQOFU4ZUplb1N4Z3dwOHhL?=
 =?utf-8?B?VjBxakZJdjlidWlPMkFDNUVaZG5mVEVhZk4rMS85c0JjZlQ0QXpOTzNJMEdq?=
 =?utf-8?B?MHMweGMza3lQRU44ckIzTk5LUmdrNVlUU2J2M0M2YlB2TzA4MTNtRjdBYzR2?=
 =?utf-8?B?VVZWQ1VaMzZpc0NFdFAraHFKZkNPVkQvb2pQcE1COFlDcXB3TFJCQUlpR3JD?=
 =?utf-8?B?eGNqUlozVU5DRmQyR0cyL2VuZE56dk1PbHE0NWg2c0VFL2FBZm44S09zakIr?=
 =?utf-8?B?YWN2d2IyUTFDSUJKOVFIb2dWUElXWDd4cWR6T2k2d3VneWhlaXVldGFHZnBv?=
 =?utf-8?B?emZxTTVvZVhUTWpUUXVYVjk0UWdmbEJpdG56YmErZnRma3M5S05YQ000cElH?=
 =?utf-8?B?dkd3MG9BR2NwUG5xZHlURlEzZ3JMdUNMMHBIOXJiWHJDRnh2VzM3OEhnbEdy?=
 =?utf-8?B?Y1JrMHQ5cG54UGVqeTVkL2ZEb1QzRXMwckRKVlJJNTdXeVdGcHV4MkFZVzUr?=
 =?utf-8?B?a3M0Q3lTbU05eHFvRVR0bkt2L2xIYTBQZFNFVWM1Qi92RzlPTlhSZkE4bHlI?=
 =?utf-8?B?Tnl1TUpGc2FtazErQW16R0pTbHo2Y0x3VURLVXoyNWlTMnh3NnBiZnhtTURI?=
 =?utf-8?B?aXplQThMYTZzSElGd2swSTFoVGFyL1hXM0x4cGJSU2lNcDZLbk96dFNEOVVo?=
 =?utf-8?B?ckNWN3hPZklIWlUyQ25jcWJJVjdHQkVJbWZXRDBuZnEyNnU3bFk5RVozQ2Rs?=
 =?utf-8?B?WkIraTF4bGNzaThwWDVMZnNLKzFrMFJXQjJNb0k3QUhQT0VYeEhFc0hXZ0FT?=
 =?utf-8?B?UmRCZW9oQ3Q5d01qQ0xkaGtNTWFNMCtCakpXVFJZdEtpS09lMzNCWUVkVVNO?=
 =?utf-8?B?UktsaXorS1dWQjBwVG5adUV6d2xMSXZlN2RJbVJ1eWs5QXU1eUVpOVZjbldK?=
 =?utf-8?B?d0dTT0VwN0JiajU2ck5ibFRUKzNjTVRWMURoaEpTQnp2SVZPRnZEak12UmFn?=
 =?utf-8?B?eEsxWGR0eGlYamxQQXBtQS8reW40eHoySWJnSkZwR0JvVlRXUW1VNUVES1NB?=
 =?utf-8?B?Q3MxOU5vTS9wdkxNTnZKWFlWVWdYbDN0SGNVTDlxQVc3RmVNUGxOdUk2WWxQ?=
 =?utf-8?B?b3Avai85SFBobXZldXRHVnIrWGp2U0dBQ1g4bGFyd2g0Ky9rcDVvZXoxcXNJ?=
 =?utf-8?B?RGxlRXBtSmFCYmQ5SlRBcEZGUGkyRWJhRHA2aFBWS1RmMUlCdW50TGdZOTZh?=
 =?utf-8?B?MTdMRGtZbHN6bDNWaG5IamRRbnJ1U2tpNjFHNjJ1VUM0ZTJGTUVCVytnL3BD?=
 =?utf-8?B?MExCYWs0VmhkSXVKbUZqcVR1ajZFaWdaU2tTS3o3QTdsbUl2N29JK0pQeFFJ?=
 =?utf-8?B?a0FHRkJwMW9kRlFwVFlFdzZ0dW9GUWdKS2tmUkRLQ1E0YW1Lc2dRbUtEdGhu?=
 =?utf-8?B?UnZRKzg2aGVOL3E1OUVtMk03Wmd3OUR3alNWa3Z5b043M3g2Tm1rY3N6bXRu?=
 =?utf-8?B?dTFWQWJjZ0hTTG13emF2dklqOFBjM0QzaHF0b0xIb0g2QTVHRG40OElPSzlQ?=
 =?utf-8?B?OGlKNW54ZG9RUUhzWjluelVZQXFzeTFEb2JmUnh5cUlmREVBZldqdXZSTWRs?=
 =?utf-8?B?ckdzWjNrcTN5QStFWkk5YTM2V1BrN1RVYzVuOXFVRjNra1Z0cTI0bFVWbUZi?=
 =?utf-8?Q?XqUMF4oqLw/M/jioGJmxlS+1XZnRkyAMwOdMKwY?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90703fa0-0a97-44da-cd2f-08d8cb412d0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2021 08:20:06.0898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sI4KRRXdBrU+qHFt0enrL8Vvrj36ro4cp7CICaxzvVPaAbn+xNDgZJI5OoMsHLt9Icp8k4CR/QbCT9nkoc6EiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2016
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKZWFuLVBoaWxpcHBlIEJydWNrZXIgPGplYW4tcGhpbGlwcGVAbGluYXJvLm9yZz4N
Cj4gU2VudDogRnJpZGF5LCBGZWJydWFyeSA1LCAyMDIxIDY6MzcgUE0NCj4gDQo+IEhpLA0KPiAN
Cj4gT24gVGh1LCBGZWIgMDQsIDIwMjEgYXQgMDY6NTI6MTBBTSArMDAwMCwgVGlhbiwgS2V2aW4g
d3JvdGU6DQo+ID4gPiA+Pj4gVGhlIHN0YXRpYyBwaW5uaW5nIGFuZCBtYXBwaW5nIHByb2JsZW0g
aW4gVkZJTyBhbmQgcG9zc2libGUNCj4gc29sdXRpb25zDQo+ID4gPiA+Pj4gaGF2ZSBiZWVuIGRp
c2N1c3NlZCBhIGxvdCBbMSwgMl0uIE9uZSBvZiB0aGUgc29sdXRpb25zIGlzIHRvIGFkZCBJL08N
Cj4gPiA+ID4+PiBwYWdlIGZhdWx0IHN1cHBvcnQgZm9yIFZGSU8gZGV2aWNlcy4gRGlmZmVyZW50
IGZyb20gdGhvc2UgcmVsYXRpdmVseQ0KPiA+ID4gPj4+IGNvbXBsaWNhdGVkIHNvZnR3YXJlIGFw
cHJvYWNoZXMgc3VjaCBhcyBwcmVzZW50aW5nIGEgdklPTU1VIHRoYXQNCj4gPiA+ID4+IHByb3Zp
ZGVzDQo+ID4gPiA+Pj4gdGhlIERNQSBidWZmZXIgaW5mb3JtYXRpb24gKG1pZ2h0IGluY2x1ZGUg
cGFyYS12aXJ0dWFsaXplZA0KPiA+ID4gb3B0aW1pemF0aW9ucyksDQo+IA0KPiBJJ20gY3VyaW91
cyBhYm91dCB0aGUgcGVyZm9ybWFuY2UgZGlmZmVyZW5jZSBiZXR3ZWVuIHRoaXMgYW5kIHRoZQ0K
PiBtYXAvdW5tYXAgdklPTU1VLCBhcyB3ZWxsIGFzIHRoZSBjb0lPTU1VLiBUaGlzIGlzIHByb2Jh
Ymx5IGEgbG90IGZhc3Rlcg0KPiBidXQgdGhvc2UgZG9uJ3QgZGVwZW5kIG9uIElPUEYgd2hpY2gg
aXMgYSBwcmV0dHkgcmFyZSBmZWF0dXJlIGF0IHRoZQ0KPiBtb21lbnQuDQo+IA0KPiBbLi4uXQ0K
PiA+ID4gPiBJbiByZWFsaXR5LCBtYW55DQo+ID4gPiA+IGRldmljZXMgYWxsb3cgSS9PIGZhdWx0
aW5nIG9ubHkgaW4gc2VsZWN0aXZlIGNvbnRleHRzLiBIb3dldmVyLCB0aGVyZQ0KPiA+ID4gPiBp
cyBubyBzdGFuZGFyZCB3YXkgKGUuZy4gUENJU0lHKSBmb3IgdGhlIGRldmljZSB0byByZXBvcnQg
d2hldGhlcg0KPiA+ID4gPiBhcmJpdHJhcnkgSS9PIGZhdWx0IGlzIGFsbG93ZWQuIFRoZW4gd2Ug
bWF5IGhhdmUgdG8gbWFpbnRhaW4gZGV2aWNlDQo+ID4gPiA+IHNwZWNpZmljIGtub3dsZWRnZSBp
biBzb2Z0d2FyZSwgZS5nLiBpbiBhbiBvcHQtaW4gdGFibGUgdG8gbGlzdCBkZXZpY2VzDQo+ID4g
PiA+IHdoaWNoIGFsbG93cyBhcmJpdHJhcnkgZmF1bHRzLiBGb3IgZGV2aWNlcyB3aGljaCBvbmx5
IHN1cHBvcnQgc2VsZWN0aXZlDQo+ID4gPiA+IGZhdWx0aW5nLCBhIG1lZGlhdG9yIChlaXRoZXIg
dGhyb3VnaCB2ZW5kb3IgZXh0ZW5zaW9ucyBvbiB2ZmlvLXBjaS1jb3JlDQo+ID4gPiA+IG9yIGEg
bWRldiB3cmFwcGVyKSBtaWdodCBiZSBuZWNlc3NhcnkgdG8gaGVscCBsb2NrIGRvd24gbm9uLQ0K
PiBmYXVsdGFibGUNCj4gPiA+ID4gbWFwcGluZ3MgYW5kIHRoZW4gZW5hYmxlIGZhdWx0aW5nIG9u
IHRoZSByZXN0IG1hcHBpbmdzLg0KPiA+ID4NCj4gPiA+IEZvciBkZXZpY2VzIHdoaWNoIG9ubHkg
c3VwcG9ydCBzZWxlY3RpdmUgZmF1bHRpbmcsIHRoZXkgY291bGQgdGVsbCBpdCB0byB0aGUNCj4g
PiA+IElPTU1VIGRyaXZlciBhbmQgbGV0IGl0IGZpbHRlciBvdXQgbm9uLWZhdWx0YWJsZSBmYXVs
dHM/IERvIEkgZ2V0IGl0IHdyb25nPw0KPiA+DQo+ID4gTm90IGV4YWN0bHkgdG8gSU9NTVUgZHJp
dmVyLiBUaGVyZSBpcyBhbHJlYWR5IGEgdmZpb19waW5fcGFnZXMoKSBmb3INCj4gPiBzZWxlY3Rp
dmVseSBwYWdlLXBpbm5pbmcuIFRoZSBtYXR0ZXIgaXMgdGhhdCAndGhleScgaW1wbHkgc29tZSBk
ZXZpY2UNCj4gPiBzcGVjaWZpYyBsb2dpYyB0byBkZWNpZGUgd2hpY2ggcGFnZXMgbXVzdCBiZSBw
aW5uZWQgYW5kIHN1Y2gga25vd2xlZGdlDQo+ID4gaXMgb3V0c2lkZSBvZiBWRklPLg0KPiA+DQo+
ID4gRnJvbSBlbmFibGluZyBwLm8udiB3ZSBjb3VsZCBwb3NzaWJseSBkbyBpdCBpbiBwaGFzZWQg
YXBwcm9hY2guIEZpcnN0DQo+ID4gaGFuZGxlcyBkZXZpY2VzIHdoaWNoIHRvbGVyYXRlIGFyYml0
cmFyeSBETUEgZmF1bHRzLCBhbmQgdGhlbiBleHRlbmRzDQo+ID4gdG8gZGV2aWNlcyB3aXRoIHNl
bGVjdGl2ZS1mYXVsdGluZy4gVGhlIGZvcm1lciBpcyBzaW1wbGVyLCBidXQgd2l0aCBvbmUNCj4g
PiBtYWluIG9wZW4gd2hldGhlciB3ZSB3YW50IHRvIG1haW50YWluIHN1Y2ggZGV2aWNlIElEcyBp
biBhIHN0YXRpYw0KPiA+IHRhYmxlIGluIFZGSU8gb3IgcmVseSBvbiBzb21lIGhpbnRzIGZyb20g
b3RoZXIgY29tcG9uZW50cyAoZS5nLiBQRg0KPiA+IGRyaXZlciBpbiBWRiBhc3NpZ25tZW50IGNh
c2UpLiBMZXQncyBzZWUgaG93IEFsZXggdGhpbmtzIGFib3V0IGl0Lg0KPiANCj4gRG8geW91IHRo
aW5rIHNlbGVjdGl2ZS1mYXVsdGluZyB3aWxsIGJlIHRoZSBub3JtLCBvciBvbmx5IGEgcHJvYmxl
bSBmb3INCj4gaW5pdGlhbCBJT1BGIGltcGxlbWVudGF0aW9ucz8gIFRvIG1lIGl0J3MgdGhlIHNl
bGVjdGl2ZS1mYXVsdGluZyBraW5kIG9mDQo+IGRldmljZSB0aGF0IHdpbGwgYmUgdGhlIG9kZCBv
bmUgb3V0LCBidXQgdGhhdCdzIHB1cmUgc3BlY3VsYXRpb24uIEVpdGhlcg0KPiB3YXkgbWFpbnRh
aW5pbmcgYSBkZXZpY2UgbGlzdCBzZWVtcyBsaWtlIGEgcGFpbi4NCg0KSSB3b3VsZCB0aGluayBp
dCdzIG5vcm0gZm9yIHF1aXRlIHNvbWUgdGltZSAoZS5nLiBtdWx0aXBsZSB5ZWFycyksIGFzIGZy
b20NCndoYXQgSSBsZWFybmVkIHR1cm5pbmcgYSBjb21wbGV4IGFjY2VsZXJhdG9yIHRvIGFuIGlt
cGxlbWVudGF0aW9uIA0KdG9sZXJhdGluZyBhcmJpdHJhcnkgRE1BIGZhdWx0IGlzIHdheSBjb21w
bGV4IChpbiBldmVyeSBjcml0aWNhbCBwYXRoKSBhbmQNCm5vdCBjb3N0IGVmZmVjdGl2ZSAodHJh
Y2tpbmcgaW4tZmx5IHJlcXVlc3RzKS4gSXQgbWlnaHQgYmUgT0sgZm9yIHNvbWUgDQpwdXJwb3Nl
bHktYnVpbHQgZGV2aWNlcyBpbiBzcGVjaWZpYyB1c2FnZSBidXQgZm9yIG1vc3QgaXQgaGFzIHRv
IGJlIGFuIA0KZXZvbHZpbmcgcGF0aCB0b3dhcmQgdGhlIDEwMCUtZmF1bHRhYmxlIGdvYWwuLi4N
Cg0KPiANCj4gWy4uLl0NCj4gPiBZZXMsIGl0J3MgaW4gcGxhbiBidXQganVzdCBub3QgaGFwcGVu
ZWQgeWV0LiBXZSBhcmUgc3RpbGwgZm9jdXNpbmcgb24gZ3Vlc3QNCj4gPiBTVkEgcGFydCB0aHVz
IG9ubHkgdGhlIDFzdC1sZXZlbCBwYWdlIGZhdWx0ICgrWWkvSmFjb2IpLiBJdCdzIGFsd2F5cw0K
PiB3ZWxjb21lZA0KPiA+IHRvIGNvbGxhYm9yYXRlL2hlbHAgaWYgeW91IGhhdmUgdGltZS4g8J+Y
ig0KPiANCj4gQnkgdGhlIHdheSB0aGUgY3VycmVudCBmYXVsdCByZXBvcnQgQVBJIGlzIG1pc3Np
bmcgYSB3YXkgdG8gaW52YWxpZGF0ZQ0KPiBwYXJ0aWFsIGZhdWx0czogd2hlbiB0aGUgSU9NTVUg
ZGV2aWNlJ3MgUFJJIHF1ZXVlIG92ZXJmbG93cywgaXQgbWF5DQo+IGF1dG8tcmVzcG9uZCB0byBw
YWdlIHJlcXVlc3QgZ3JvdXBzIHRoYXQgd2VyZSBhbHJlYWR5IHBhcnRpYWxseSByZXBvcnRlZA0K
PiBieSB0aGUgSU9NTVUgZHJpdmVyLiBVcG9uIGRldGVjdGluZyBhbiBvdmVyZmxvdywgdGhlIElP
TU1VIGRyaXZlciBuZWVkcw0KPiB0bw0KPiB0ZWxsIGFsbCBmYXVsdCBjb25zdW1lcnMgdG8gZGlz
Y2FyZCB0aGVpciBwYXJ0aWFsIGdyb3Vwcy4NCj4gaW9wZl9xdWV1ZV9kaXNjYXJkX3BhcnRpYWwo
KSBbMV0gZG9lcyB0aGlzIGZvciB0aGUgaW50ZXJuYWwgSU9QRiBoYW5kbGVyDQo+IGJ1dCB3ZSBo
YXZlIG5vdGhpbmcgZm9yIHRoZSBsb3dlci1sZXZlbCBmYXVsdCBoYW5kbGVyIGF0IHRoZSBtb21l
bnQuIEFuZA0KPiBpdCBnZXRzIG1vcmUgY29tcGxpY2F0ZWQgd2hlbiBpbmplY3RpbmcgSU9QRnMg
dG8gZ3Vlc3RzLCB3ZSdkIG5lZWQgYQ0KPiBtZWNoYW5pc20gdG8gcmVjYWxsIHBhcnRpYWwgZ3Jv
dXBzIGFsbCB0aGUgd2F5IHRocm91Z2gga2VybmVsLT51c2Vyc3BhY2UNCj4gYW5kIHVzZXJzcGFj
ZS0+Z3Vlc3QuDQoNCkkgZGlkbid0IGtub3cgaG93IHRvIHJlY2FsbCBwYXJ0aWFsIGdyb3VwcyB0
aHJvdWdoIGVtdWxhdGVkIHZJT01NVXMNCihhdCBsZWFzdCBmb3IgdmlydHVhbCBWVC1kKS4gUG9z
c2libHkgaXQgY291bGQgYmUgc3VwcG9ydGVkIGJ5IHZpcnRpby1pb21tdS4NCkJ1dCBpbiBhbnkg
Y2FzZSBJIGNvbnNpZGVyIGl0IG1vcmUgbGlrZSBhbiBvcHRpbWl6YXRpb24gaW5zdGVhZCBvZiBh
IGZ1bmN0aW9uYWwNCnJlcXVpcmVtZW50IChhbmQgY291bGQgYmUgYXZvaWRlZCBpbiBiZWxvdyBT
aGVubWluZydzIHN1Z2dlc3Rpb24pLg0KDQo+IA0KPiBTaGVubWluZyBzdWdnZXN0cyBbMl0gdG8g
YWxzbyB1c2UgdGhlIElPUEYgaGFuZGxlciBmb3IgSU9QRnMgbWFuYWdlZCBieQ0KPiBkZXZpY2Ug
ZHJpdmVycy4gSXQncyB3b3J0aCBjb25zaWRlcmluZyBpbiBteSBvcGluaW9uIGJlY2F1c2Ugd2Ug
Y291bGQgaG9sZA0KPiBwYXJ0aWFsIGdyb3VwcyB3aXRoaW4gdGhlIGtlcm5lbCBhbmQgb25seSBy
ZXBvcnQgZnVsbCBncm91cHMgdG8gZGV2aWNlDQo+IGRyaXZlcnMgKGFuZCBndWVzdHMpLiBJbiBh
ZGRpdGlvbiB3ZSdkIGNvbnNvbGlkYXRlIHRyYWNraW5nIG9mIElPUEZzLA0KPiBzaW5jZSB0aGV5
J3JlIGRvbmUgYm90aCBieSBpb21tdV9yZXBvcnRfZGV2aWNlX2ZhdWx0KCkgYW5kIHRoZSBJT1BG
DQo+IGhhbmRsZXIgYXQgdGhlIG1vbWVudC4NCg0KSSBhbHNvIHRoaW5rIGl0J3MgdGhlIHJpZ2h0
IHRoaW5nIHRvIGRvLiBJbiBjb25jZXB0IHcvIG9yIHcvbyBERVZfRkVBVF9JT1BGDQpqdXN0IHJl
ZmxlY3RzIGhvdyBJT1BGcyBhcmUgZGVsaXZlcmVkIHRvIHRoZSBzeXN0ZW0gc29mdHdhcmUuIElu
IHRoZSBlbmQgDQpJT1BGcyBhcmUgYWxsIGFib3V0IHBlcm1pc3Npb24gdmlvbGF0aW9ucyBpbiB0
aGUgSU9NTVUgcGFnZSB0YWJsZXMgdGh1cw0Kd2Ugc2hvdWxkIHRyeSB0byByZXVzZS9jb25zb2xp
ZGF0ZSB0aGUgSU9NTVUgZmF1bHQgcmVwb3J0aW5nIHN0YWNrIGFzIA0KbXVjaCBhcyBwb3NzaWJs
ZS4NCg0KPiANCj4gTm90ZSB0aGF0IEkgcGxhbiB0byB1cHN0cmVhbSB0aGUgSU9QRiBwYXRjaCBb
MV0gYXMgaXMgYmVjYXVzZSBpdCB3YXMNCj4gYWxyZWFkeSBpbiBnb29kIHNoYXBlIGZvciA1LjEy
LCBhbmQgY29uc29saWRhdGluZyB0aGUgZmF1bHQgaGFuZGxlciB3aWxsDQo+IHJlcXVpcmUgc29t
ZSB0aGlua2luZy4NCg0KVGhpcyBwbGFuIG1ha2VzIHNlbnNlLg0KDQo+IA0KPiBUaGFua3MsDQo+
IEplYW4NCj4gDQo+IA0KPiBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtaW9tbXUv
MjAyMTAxMjcxNTQzMjIuMzk1OTE5Ni03LWplYW4tDQo+IHBoaWxpcHBlQGxpbmFyby5vcmcvDQo+
IFsyXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1pb21tdS9mNzlmMDZiZS1lNDZiLWE2
NWEtMzk1MS0NCj4gM2U3ZGJmYTY2YjRhQGh1YXdlaS5jb20vDQoNClRoYW5rcw0KS2V2aW4NCg==
