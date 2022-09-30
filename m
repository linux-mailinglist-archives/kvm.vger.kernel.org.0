Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231135F14AC
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 23:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiI3VVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 17:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbiI3VVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 17:21:36 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CFA1716D2
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 14:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664572895; x=1696108895;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=rOY9CbEB6rwqrutJJ95zaHAtpmG4o8Mp+yXLRJ8TkQg=;
  b=Xtczn9s4hFbmvAjtcpEjGk1lEZBoHvg4U0nhy9F95mJuAlwWP8xHQeDM
   ArL9wGhRp0XMPR28on9pZu1HEf5SnukbKTW75vW4LxumaKfCsghmmQyd0
   uu2l2pvhi0SDoCF2536bNDzPn3CXDt0Gyp8emny5eCLyKtwTVqrjkN5o+
   1VOC6ddh94Rp7p+cIbzpQ1/1JQBLrARvKn49+jnY8vIO3I6D7t4uahJXn
   MWn5ZrRCfL9ct7EwBEs02E1djEcww5bZpptUZhwp1Gz5uFh3vdN6ZdHQC
   L8cCI8D/B5VYfnRQC8L8WxhamLubYCMlQ9tKzDcm/kriUXOsrc7CRiNj/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="364138056"
X-IronPort-AV: E=Sophos;i="5.93,359,1654585200"; 
   d="scan'208";a="364138056"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 14:21:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="727015765"
X-IronPort-AV: E=Sophos;i="5.93,359,1654585200"; 
   d="scan'208";a="727015765"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 30 Sep 2022 14:21:34 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 14:21:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 30 Sep 2022 14:21:32 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 30 Sep 2022 14:20:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKoCkHA5zUyNKXhW2ujlr5TOPzUxZZwQseVyKmOzV9TZg6ouRUX4i8IMZeTCLFVxjSfcKV2KQz4WRSTvsfHvTPDc5PExlnYicBHppggCIA/8ZK9j3sOULnlqiA6zgbo1lRPlsWKpNMzam1JpEGntW2/xgrr/9BW9+e9vsAeBzFjhcYFs1AEEHT9KKvS+sTzW0t/zSfQplM2G4yHR/68VIqeEJS4HxIPkntCT2R74LjGuS02MtSKNQtdiP+UQM8CPc3R4gU3JlMSHOKmzjGmsGwWmW6gIJ6MaJWsxNfs5UEljmTsx4BB/6WIkE+sau8Mq1gTGLERnL+TFnVUue3zG5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rOY9CbEB6rwqrutJJ95zaHAtpmG4o8Mp+yXLRJ8TkQg=;
 b=mleR74pkh+qx9gRGbpQSM9Mt1DcKwlqFzHSX0KUnPrSv8iyhEfg7ZcXcFT/LQtT3S/Uo4xEJjBbkBy+C7trzgO+jn1iRUEGwmiMhrgt6imeI/DEscOqLasUY6Tzl1yjMmEvcUo82+NgDwLBhTtdV1dPLNApoq8Z9kSNUbGsLmnGDkhyTjmA0/EG6SH6nQL3+JnXyBvklwmWOvpd7Ho06PS/1REvaUihhyk6TjlODfNx0WjWT5HSOEByI+FNCAIwfSAdYKFktF74tNmx8iWOtuDD7W8g3VoieCtjUFxwFkQShXF07LNpOQK3nAVDGALSUiHGI6O+GRJswX8eHS7UUZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3042.namprd11.prod.outlook.com (2603:10b6:208:78::17)
 by SN7PR11MB6677.namprd11.prod.outlook.com (2603:10b6:806:26b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 21:20:56 +0000
Received: from BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::b52e:e73e:ac99:8a5]) by BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::b52e:e73e:ac99:8a5%3]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 21:20:55 +0000
From:   "Dong, Eddie" <eddie.dong@intel.com>
To:     Jim Mattson <jmattson@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: RE: [PATCH 2/6] KVM: x86: Mask off reserved bits in CPUID.80000006H
Thread-Topic: [PATCH 2/6] KVM: x86: Mask off reserved bits in CPUID.80000006H
Thread-Index: AQHY1FYuEs8BAKsu5UCBOzB/nmNIY634etfw
Date:   Fri, 30 Sep 2022 21:20:55 +0000
Message-ID: <BL0PR11MB304234A34209F12E03F746198A569@BL0PR11MB3042.namprd11.prod.outlook.com>
References: <20220929225203.2234702-1-jmattson@google.com>
 <20220929225203.2234702-2-jmattson@google.com>
In-Reply-To: <20220929225203.2234702-2-jmattson@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3042:EE_|SN7PR11MB6677:EE_
x-ms-office365-filtering-correlation-id: dc77beda-1a3b-41b8-6d0f-08daa329a957
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cdRSi/z0KA/v8r+IAjEWtaYHAFFhYrvrVttS/znQge0SftXEuGcEpI56tqyeLJPL2WIusdotuEnBd2sJeq/CVITp5B2oP3GERlAhqVYW41j3pL/CqbXLUGabQ3NDEjw0opOyCFyRrMZmGafBoX6R0EuG/MJXM0vMt44yU0EC/EKkCQEi20UWc6smdmGt1Efm2S07mwZs9FaiMXklj60IaWMe1nkAt1D6XQZqYXT9scFCMNidKBJe/MvGbaVTYJFlSFVcF53kwU7xvPaahCJ3cPqtvzaIS7121Ja/yPV1ar/xKeCoZGVLEMNVT25RJyB0P5az1jBxPyxsfgQWHRDn7PcbIyJgrdER6gxvQ0Rj3gH+B8ktLpJoS8BtY1KUkkJSl7LVfAfivGYC3q1UXl+lf93Q+jsV2MOJoSyvGRf6ZFwS9w1wbAtg7bGvLvHnk/mqMOYqTuVMwsQ5qs6TiEB7IyPu6SmQ9NIMl3A2WpcawPlfb6lzcMgAcZJsSwhE/+w450TiKVw0PuqbNumPwuwj+DjQITZ1ZFKsBky/XU651zGWjVnXCEfrWxgzCqN+gEGP41y5K5lriKs4ITBY+JMfcXY67G902MmqiAn8SiftvJpcogskrMnvkXICc6+Mr5hBhrnWXFbZ76F6RZkvEGZe8d0Lq4NCMtMMfWXMep3X6RD6iqSeIlc1CilacyJLT2GSynp+uX33trWFRTEm4sLio8tHcbEYtZAVdEzAMFPxtkWW/4XumN0hks5/RVFm55zW6leZzoSAGqNudPRpfJoBXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3042.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(366004)(346002)(396003)(451199015)(55016003)(122000001)(38070700005)(33656002)(38100700002)(82960400001)(86362001)(66556008)(76116006)(66476007)(64756008)(8676002)(66446008)(110136005)(316002)(41300700001)(2906002)(66946007)(52536014)(5660300002)(8936002)(186003)(83380400001)(26005)(478600001)(71200400001)(9686003)(53546011)(6506007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVBWVEhxZVZ5SDFDa2E5eWo2SWliWkM1SjJzc21HcTdOQ1V0UFJlc3VvNXd1?=
 =?utf-8?B?TFBxUGZMYkRPa0ZzcWErcjc3WWtraHowRHJaajBxMmFqZ0lTSm55Ynd1S2ov?=
 =?utf-8?B?VUVVRjF4cHE5ekNZamVHMmJzY1JON0xtK29yZ2dUU1dNZHpRNkpkd1JSbWJw?=
 =?utf-8?B?eUxoY0grYmREZXZCTU9wYXlKc2xjeEVEVVNPRlp0a1drb0MvSVBSNGVKbWlS?=
 =?utf-8?B?VDQ3NzB3L1pBZmZ0UTh6Nk1Zd1hLYXEzcFpGejhmT3RHbm9yaW5BSU9nUlRs?=
 =?utf-8?B?anJCVVZ3c3N0dzJXZmJGbzdleVRYMGgrVG1hZ2tKYzNFc1lJWWk3RjNwSWw3?=
 =?utf-8?B?UFFDVnhHakt6TEVoS0xsWmFiMTJqWWZXcHozYmlreXlLdDRZd0JIaGd1cmpt?=
 =?utf-8?B?RHQxaW50eTE3cG1pcE84SFI3SWNQM0xmTVhvVXNiUnArRENmK0l3dGczOSts?=
 =?utf-8?B?aEdYWVdtcTFURWxESm55ZEs1QmZXQXBKSzlrNHRINk9VWWJYSHNoOURXSk1j?=
 =?utf-8?B?WFc0SGhDMWcwRnpDVHNYdG9GN2lKS0M3NWZMME1XMjF3UTJaQ2ZwVmoxaDJW?=
 =?utf-8?B?dUVoNVZCbFJmSkhEMlZZZVU3cFliT3ZMdnRHeFdwL3ROQXQwMGR5Z1R0S205?=
 =?utf-8?B?d3V2SXpVclBNSWsxc1FMOEpKV3pQUnEvN1gxMGNmazE3TzdzLy9aaGx5N0Ux?=
 =?utf-8?B?Y3kxZ2htUzhEdXZ2dWJIY0MxQmlxVGZZUDJCaWxObk5GV3NLQnhMM3doaVJw?=
 =?utf-8?B?VCtsWlMzdFZvRUhFY3Z4ekdXSFVWdENpbmx2TnpRRXRUankwK1J0TXp4YW5t?=
 =?utf-8?B?SHBMMEFnWElUOHFzUjhOWXh3TytCQTZjQXpkVkwzUGlsb2pGSFlycVZmbnE0?=
 =?utf-8?B?cnhnVnBXbWpGYklVQjIvRGtnTGN2V29zYU54aDg3akkxTHZSRUlDUTB1dGdN?=
 =?utf-8?B?ZGsrVjhYUjZoVnBoSHFWakhpZzBpWXZnS1NTQkdCa3BWbUpYUDVDTzRaVmlS?=
 =?utf-8?B?YWdkbE9BSnkyOXpSV1ZQV1hya3lJa2g5NkFTb0o2QWgxbE53Z1dJQjRyaDdB?=
 =?utf-8?B?SEtwZTQrZlBWN3NQVVg0T0pYSkxqT3N0RDVTWkFRSmFyUzlVVW5LS3pSOXp6?=
 =?utf-8?B?cWx4VUJEalBBQVhLaFBNampuVFkvQllPSXFKRCtkYXdvL0RZWG51MDRQNmgr?=
 =?utf-8?B?eFhneE1iMnQxNHBTcmhSNUNMS2ExVTMvbGgyMlRNclRqbzBET0R3elg5N283?=
 =?utf-8?B?RmFlL2dxZDN1SG1ZM0NpWERlaWpTL2x3SDl1ZlYralpMVWFhY3dvMG02SnN4?=
 =?utf-8?B?c1JySVhaNnBOTjJ2OUsyL0I1bVJXelBHL0QzbFM3V0daak1RdHRzZ1NvQnpO?=
 =?utf-8?B?TDhFVXk1cktvSXNuR1BIR1FIaXdVdnFiUFhoU0k1TDVVQUlJR1B6aEtUV3J5?=
 =?utf-8?B?QjBPZXZHaFhCZ3JpazNJc3RKUzF4ZWE1aXdLMm5aOWQ3RTJsakdYNWkybWFI?=
 =?utf-8?B?K09qL2tNbWdKaGdlZ2tMdVlzcUVxYUpLTUMyRUNWOFM3SEg4S2tiMlJnK3pV?=
 =?utf-8?B?OEl5Y204T25XOHpzb2hUY2pDU3BuVU84d21ZOVFISDFMMExDN29xY0NXalBL?=
 =?utf-8?B?cGVJbUdtT2Q5VzdWRzBjc3N3K0ZpQ01hL3VMSERtci8rNzlmUHVTRklHVHJj?=
 =?utf-8?B?NkpCcTU1UmE3RkxwajRRZmhqbjVtRjRoOFd0bDBBV0F6WFJsZEtYQm5tTU80?=
 =?utf-8?B?TnJ0V3puM0VXcjk0MkdWYTVQRWwxZ2ZjRnFqcGxGdzljUHQ5MkNFSHhBQTE3?=
 =?utf-8?B?Z1QrL2ZaTENJSXJSa3pWRGZDaXd2SGhoZEhxeVVVeDcyNmNPZkg0MU51YTg0?=
 =?utf-8?B?a3l2dkgyUWlZWkh3Yy9nMjBXUjBNc3hCZTkvK0haYytTV1dDYUZ1QStNZUNX?=
 =?utf-8?B?cm9LcUlieFE2MHFXSnJSeGtEeHBDRnpzTWFNcUlyZkhVdXJabUF0enIyZmJ3?=
 =?utf-8?B?NDBSTWUzdkc5UDQ3UU1SWXJXc0pxMnpHVDBzNHdXSUxxVW0zV0VvcHh0SjBk?=
 =?utf-8?B?UTBvK1BDZTlpRWxRNlRONWkrZnNXYnY5WTcwTzE5VnNOemlRWVRld0c3MTNK?=
 =?utf-8?Q?PwuxJ6++8LE4HFPZTgDfJdAsP?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3042.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc77beda-1a3b-41b8-6d0f-08daa329a957
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2022 21:20:55.6255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V2S+6wGuSwQSZhPIzJOEIV+JV1gCZaIgDvEW8cjVc/yx7J7z4mjIn3ePcTOLOMA4c6ckCYGI7ItHutkokaH0SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6677
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmltIE1hdHRzb24gPGpt
YXR0c29uQGdvb2dsZS5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBTZXB0ZW1iZXIgMjksIDIwMjIg
Mzo1MiBQTQ0KPiBUbzoga3ZtQHZnZXIua2VybmVsLm9yZzsgcGJvbnppbmlAcmVkaGF0LmNvbTsg
Q2hyaXN0b3BoZXJzb24sLCBTZWFuDQo+IDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gQ2M6IEppbSBN
YXR0c29uIDxqbWF0dHNvbkBnb29nbGUuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggMi82XSBLVk06
IHg4NjogTWFzayBvZmYgcmVzZXJ2ZWQgYml0cyBpbiBDUFVJRC44MDAwMDAwNkgNCj4gDQo+IEtW
TV9HRVRfU1VQUE9SVEVEX0NQVUlEIHNob3VsZCBvbmx5IGVudW1lcmF0ZSBmZWF0dXJlcyB0aGF0
IEtWTQ0KPiBhY3R1YWxseSBzdXBwb3J0cy4gQ1BVSUQuODAwMDAwMDZIOkVEWFsxNzoxNl0gYXJl
IHJlc2VydmVkIGJpdHMgYW5kIHNob3VsZA0KPiBiZSBtYXNrZWQgb2ZmLg0KPiANCj4gRml4ZXM6
IDQzZDA1ZGUyYmVlNyAoIktWTTogcGFzcyB0aHJvdWdoIENQVUlEKDB4ODAwMDAwMDYpIikNCj4g
U2lnbmVkLW9mZi1ieTogSmltIE1hdHRzb24gPGptYXR0c29uQGdvb2dsZS5jb20+DQo+IC0tLQ0K
PiAgYXJjaC94ODYva3ZtL2NwdWlkLmMgfCAxICsNCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2Vy
dGlvbigrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9jcHVpZC5jIGIvYXJjaC94
ODYva3ZtL2NwdWlkLmMgaW5kZXgNCj4gZWE0ZTIxM2JjYmZiLi45MGY5YzI5NTgyNWQgMTAwNjQ0
DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9jcHVpZC5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS9jcHVp
ZC5jDQo+IEBAIC0xMTI1LDYgKzExMjUsNyBAQCBzdGF0aWMgaW5saW5lIGludCBfX2RvX2NwdWlk
X2Z1bmMoc3RydWN0DQo+IGt2bV9jcHVpZF9hcnJheSAqYXJyYXksIHUzMiBmdW5jdGlvbikNCj4g
IAkJYnJlYWs7DQo+ICAJY2FzZSAweDgwMDAwMDA2Og0KPiAgCQkvKiBMMiBjYWNoZSBhbmQgVExC
OiBwYXNzIHRocm91Z2ggaG9zdCBpbmZvLiAqLw0KPiArCQllbnRyeS0+ZWR4ICY9IH5HRU5NQVNL
KDE3LCAxNik7DQoNClNETSBvZiBJbnRlbCBDUFUgc2F5cyB0aGUgZWR4IGlzIHJlc2VydmVkPTAu
ICBJIG11c3QgbWlzcyBzb21ldGhpbmcuDQoNCkJUVywgZm9yIHRob3NlIHJlc2VydmVkIGJpdHMs
IHRoZWlyIG1lYW5pbmcgaXMgbm90IGRlZmluZWQsIGFuZCB0aGUgVk1NIHNob3VsZCBub3QgZGVw
ZW5kIG9uIHRoZW0gSU1PLg0KV2hhdCBpcyB0aGUgcHJvYmxlbSBpZiBoeXBlcnZpc29yIHJldHVy
bnMgbm9uZS16ZXJvIHZhbHVlPw0KDQpUaGFua3MgRWRkaWUNCg0KPiAgCQlicmVhazsNCj4gIAlj
YXNlIDB4ODAwMDAwMDc6IC8qIEFkdmFuY2VkIHBvd2VyIG1hbmFnZW1lbnQgKi8NCj4gIAkJLyog
aW52YXJpYW50IFRTQyBpcyBDUFVJRC44MDAwMDAwN0g6RURYWzhdICovDQo+IC0tDQo+IDIuMzgu
MC5yYzEuMzYyLmdlZDBkNDE5ZDNjLWdvb2cNCg0K
