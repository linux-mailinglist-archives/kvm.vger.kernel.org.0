Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB00702B0F
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 13:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241116AbjEOLH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 07:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240137AbjEOLH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 07:07:26 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DCC172B;
        Mon, 15 May 2023 04:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684148845; x=1715684845;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iyrDT1zIzoxmuoJV4p7A444/YdJymYaIccieS7MNVY4=;
  b=FW2fK8jdUJWDCdj3JyL0dqIs1SY8JjgPfPb1uxdWXRPJSOy5BI7Md5Z9
   YK5Ihv2gSBWjnETaSAWzK8gjdG7qKZ0Q+0PcIRbsBF+P/q8zCRs2nOY/F
   znjps1pacQxjt5JyFkRl0CkdFYhw52Gkl3gcOj7ZhLMtMpDTNyD0Vczkx
   fN4bwKeJvsWf5yyZ7E1xI9VfTlzdAHTEO0w9lim+l+UnRPngvemFWLsve
   IRSLJZIDPMtJ+WkFMZW4yjoecWNU1Z0EIwH7Ekk9aHJfB959c5e3gI2m8
   3KWbquRdiYhMvBb0vAdWWkVfU5Et1CahIXuKzU0Kp2NpbUsLWBgIPoxdj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="335713539"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="335713539"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 04:07:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="1030871831"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="1030871831"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 15 May 2023 04:07:24 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 04:07:24 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 04:07:24 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 04:07:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGiG6BUGE7GYGo+7C7oXn4FEg2pAKhJOAQLZvZsyB3GBLcejpPGZwMULzV/3OpSMoiad4s8HDkPpZQnT/XYcFmrUzVAfsU9IAlgrlaQpbTfDvPJncDsGjjKfY7sKpmXaM5Rn0UHoztYLpaWRxevV5mU5MSPOj3xqugMfPBup4Oa70KiWKVmg/T7okaU9bXNLzP9ARQrSr9tz+hX5/NrK9L+0oBwVOdx5o4TR8yEbuDO+RF9sctzgVMUDCz8q7H/7zDEnhWco8i3RM9Ig8+tzIyLBZycKRdigtS7B/N0BRt0sCVhjKYCoNfUSzZOUifMzIH94LgV8+NKXZjx+SQjjOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iyrDT1zIzoxmuoJV4p7A444/YdJymYaIccieS7MNVY4=;
 b=g9tUjDOoyThgXbNXYwgQv1dftV499gE2rivUsvKI0U7ukXcew7h2oaomL7qHyW8hVeBP4pQX0mwEWpv3KL6pTNYpTJTXFYqRURPsmLPGlWT4U6KZ40gqAWMafHYHqi5bIOS6KNNhLd2LgBksaDHw2fu0ocVITdcWhUnMq1j47ySVvfFKbmwEgHco4N+JfLtiAEFlldFSSb64EtfZHLtTr2gDGDjAwx4nURVi6WhBXjka2SjNKfkfU60ygiJHLjfN/4QocZtZCTuS58vE9wh5i28rF0aIgJB1R7dgHCswOjzEZEQTLNlCXoUd3bac865CKGo66kFzd6qHEz45uyx4PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) by
 BL3PR11MB5697.namprd11.prod.outlook.com (2603:10b6:208:33c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 11:07:20 +0000
Received: from DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::f381:7ce8:7d26:503d]) by DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::f381:7ce8:7d26:503d%4]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 11:07:20 +0000
From:   "Wang, Zhi A" <zhi.a.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 02/28] drm/i915/gvt: remove interface
 intel_gvt_is_valid_gfn
Thread-Topic: [PATCH v3 02/28] drm/i915/gvt: remove interface
 intel_gvt_is_valid_gfn
Thread-Index: AQHZhTLvbw9XASVvHUuPAZMfLjda3q9bMG8A
Date:   Mon, 15 May 2023 11:07:20 +0000
Message-ID: <ef5d75eb-cdc7-e91d-85fb-922ca3bdab3a@intel.com>
References: <20230513003600.818142-1-seanjc@google.com>
 <20230513003600.818142-3-seanjc@google.com>
In-Reply-To: <20230513003600.818142-3-seanjc@google.com>
Accept-Language: en-FI, en-US
Content-Language: aa
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5549:EE_|BL3PR11MB5697:EE_
x-ms-office365-filtering-correlation-id: 40365b0d-5f0e-45c3-a1aa-08db55348daf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kuvvyXLxDcuDNTDn64BGBBZbsHy7sayqLqEPrTtt1NiXOuNbku3Ie0JIWL7fPmUnOkz0sAR1pwcQAC+A1XwSW9aHHYc3JGMcZFYCVtA72S3eMZ1e1Db7ILqqcF7EncC3HexcsOLDDdOXbYWn5AKNvFo1PPdv9jqOkkLtWQnfLd/7VFMjo/1dGoB+DcvBL40xeEfgR2yK9e3HehcpJWdCj/WDzGUCE5E68NFmVYl0/WzA3IaAYvoh1Jbb4zGJuDsb3rOTYySMu+zOe1PZcr5KBxgegto2sAEMyAtz1v4mKNI9wVeuEvhYIH1M+mva5IZMKr+6vYbLsHFRto16ZZB28Xy25awL39OeS0tFsnvQdJ7cVVqijhcGLf8xC5KDnbqFT2bx7C+FUoP7x4LR1wjKI1tiBpY1iU+ak5YkhH/3M3vQkhYFAAqoe1PgPdbqvtSaRpW6YfWX/lYBx/7UQinspejto+aaq2NPoODfPQUmt37WiUCb3gaLqTwqrQCrCWsaBkgvuM91MwiPNHtOjedS3yI2TKYv7n1SzdwAYYbsp5bGeRhhuwlGhe4uXJyVCYBys9Br/BY4DMqliwBnrnwqg1FjGlQXWCD+YwH6HekaW2IeZs2/YDBBSPB6PH6XpTgHaXe0/s1Nk3rTssi8IPhzPH7174PIoK7FBRIRbWdm7U5ig71mIk5ms06Zreatl6CU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5549.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(136003)(346002)(39860400002)(451199021)(71200400001)(82960400001)(122000001)(38100700002)(2616005)(186003)(26005)(53546011)(83380400001)(6506007)(6512007)(2906002)(41300700001)(5660300002)(8936002)(8676002)(6486002)(36756003)(478600001)(31696002)(110136005)(38070700005)(66446008)(66476007)(66556008)(66946007)(76116006)(64756008)(316002)(4326008)(86362001)(91956017)(54906003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVN6TFpod2NGUDBCaVNHZUpsSURpUEx2R3J6bms3V2NDZFVMMzJ0UWxiSzZi?=
 =?utf-8?B?WktGdWlvSUk2cUU2QVFjMER4RHhkYWJOL0RjRUxES003RW8xdGFsOGdhMzN2?=
 =?utf-8?B?NjZOUkRObVNQSk9lcjJZQjluWjN3TkJXVk12TCtoOXJBOHFQanIyRFVOS1BL?=
 =?utf-8?B?NnVyNXZpamZ0aDk3YndxRnJXbDhkZ3FZbVRUVDJZUnVySjVOUFpqU0FIaDZ0?=
 =?utf-8?B?L3dqSFFtL045UENMdVBiSjF5SThmZ2wyNzk1b1d0V2VoN2UxZHA5TUxmckNp?=
 =?utf-8?B?elNoMHJ2MlpKc0dOak85U2dJTGp1Y2E5aktVWDhoSGo5NjZrYXdXZ0JCY1Ns?=
 =?utf-8?B?ZEFFc3hndEJUQVB2bDhya1B6dFgrNXJ5UzdvVkJveXAyTGZJenNrVE82c251?=
 =?utf-8?B?U2pENWRZOTE3dnhHRTkwR1dPWWxrRTVpKzZueFg3QUZUMkYxbEpZa0FMZWor?=
 =?utf-8?B?cUswMWQ2MGhna1lWc1ZSSGhSUWliekoyYjdrUnF6bE5FZTBVWnNiVTFlbU1I?=
 =?utf-8?B?K1NKNmtac0tnMVpOK214TzNJSDJCenoxUVZGVGVFVkUyQU1BNFljYmRnb2ZP?=
 =?utf-8?B?RWkyZC91TjNHTDhsQk9DcFJ1bDc0eDdQY0JRWVZIZXdHNVJSRExaTlJFRStn?=
 =?utf-8?B?UElqSzJja1JoSGdhQlIyNWRSZy85ZDl6TWxUQ0ZxbDloR2VTeHN1d2gzbWx2?=
 =?utf-8?B?Z20xSzNNZ1lVZHRVODkyTVFrOEhHN0RpeHJNNE85ZkpZVDNUam1HcjJTL0hC?=
 =?utf-8?B?Z1ZQK2swUDdkQzJEWDlzUVpNOWhHL0pjMENJUVZjcGRrZ3NpcXVDbEwwVzAr?=
 =?utf-8?B?bWYraWNMRnRuVktnUUEyY3Rvd3BDZDZuT0grdGpyYnRBN1FtYnRxbkpIZllN?=
 =?utf-8?B?QlRvYk9VMk82elcwRHluSWhrUGZRVWwzQ0w3cWhwSG5QcHFXVklqOTducmdl?=
 =?utf-8?B?d3MwWmR0U2xPdExNcUFvQ2Zkcnl1SW9DeFQ4azVtMTlCbTdlZ3FRRUQzRTlm?=
 =?utf-8?B?RHR1L0paZWZTckNrQ0pHblhPQmFoN2RuZ1NoSzhMNHlwVFJwZ0krS285eGNK?=
 =?utf-8?B?NTllMlo2ZkdoQUtzRDlxaEgzaFpNeTRTeUFoaS9mTmpYSzMxdStzcUtjVCt1?=
 =?utf-8?B?eUphSEhkRWs0REMyalZXSUdjSHU5ZzBlS3EvWHN6U0s1V25ua1Vsd2d6c2tK?=
 =?utf-8?B?V2gyVEVPL2swMGFZcWlEQVBodGFQblZFT0tGYmduZUs5TDBta0NRY29pWU5t?=
 =?utf-8?B?RnF2VGJJRVlzQlU2aGh5MmhmNFM5UFdPRElHcWU0aGtUUkdjQk14UU1CQlRa?=
 =?utf-8?B?akhKNGVRTzBwSjVOczF0Wnd2c2Fad1lvL3lGZjdCWU9GbFJwaHJpbE15QXdD?=
 =?utf-8?B?TTBiSjZLaHJEV01jbTgweWJaTjdOUkVxT3V3UzNSbzJOYkwyZHM3WUdBUEJD?=
 =?utf-8?B?WFRLRCtaKzNjdjZpbGxkbDRqd2VCTGM2YmgyNm5WSHFwOEwzN3RtKzAwbjlQ?=
 =?utf-8?B?TTZVemtjRktKRmRCaTE2S1NZcVE4d0doMy9VVGF1VlNLVGtqSmZTUUtZMEpy?=
 =?utf-8?B?NDBaYzZXWGRvM0hRVGVEME85NmZMU1lGRnFtQis1YjJWSFZPM0hRc1VxVm5V?=
 =?utf-8?B?NmVWM2pPZlMwdlMzMzJlOTdkSWQ1bkpuQVJZa1BLQ0dCVjJ2UGVnRG5HNTVD?=
 =?utf-8?B?QmZQNGt5VmpBTGFWRWgxdllzTkNzcnV6Mk4vdnhKeEFmMU5KM0FRbVl6ajNK?=
 =?utf-8?B?OFdoRllmMFlYL3p3Y0d1YlF5MnV6ZmNSb1RnQm1WMjR0UllzYzloQ1B1TlY1?=
 =?utf-8?B?VUR2Q0kxNEJGbTdONzdhbjJqbERUenpLSVRHNkVad284SVo0YmtQN3ZFY3JN?=
 =?utf-8?B?VCt2YUkva0ExeTdXbHJGalpYU3g2djN1THpDWGRubE93UWRaSUJmN3JWRk5j?=
 =?utf-8?B?dWF3S0wzLzRXZW1NYkFzL0dKNWJaYjU1S21FdlRwaEJidGdLM0VrM1BVL21n?=
 =?utf-8?B?bWcwTHJXLys4YzdqUGxJK2RRcVBqZHg2VTNSRVl1ZlljclRJSVVKQ3NVREIw?=
 =?utf-8?B?TnFWQmF6cjliNUFBd0FmbitXL0pvTXpXbENIbkFkeGp6cVdBTU94UnVXWU40?=
 =?utf-8?Q?vGI21PP6C19sJZ4glvXnIeSAq?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E6364EE87BF1543AD75075969803E3C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5549.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40365b0d-5f0e-45c3-a1aa-08db55348daf
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2023 11:07:20.6799
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sUtaJ1qZaHb/yP7IZxQw76XWcLMfO36lf2qTJ5JsHZYxPlQD+SC3bPC05JHrGAur6DuhYjdaaIGsBrlQX75IjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB5697
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gNS8xMy8yMDIzIDg6MzUgQU0sIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+IEZyb206
IFlhbiBaaGFvIDx5YW4ueS56aGFvQGludGVsLmNvbT4NCj4gDQoNCkFja2VkLWJ5OiBaaGkgV2Fu
ZyA8emhpLmEud2FuZ0BpbnRlbC5jb20+DQoNClRoaXMgd2FzIHByZXZpb3VzbHkgdG8gYXZvaWQg
c3RlcHBpbmcgZG93biB0byB0aGUgbG93ZXIgbGV2ZWwgQVNBUA0Kd2hlbiBhIGd1ZXN0IHBhZ2Ug
aXMgbm90IHVzZWQgYnV0IHN0aWxsIHN0YXlzIGluIHRoZSBHUFUgcGFnZSB0YWJsZS4NCihtb3N0
bHkgaW4gd2luZG93cyBWTSwgYXMgdGhpcyBpcyBhIGJlaGF2aW9yIG9mIFdERE0gR1BVIE1NKS4g
QnV0DQppdCBkb2Vzbid0IHRvdGFsbHkgc29sdmUgdGhlIHRoZSB0cmFwcGluZyBmbG9vZCBpbiBw
cmFjdGljZS4gSSBhbQ0KdG90YWxseSBmaW5lIHRoYXQgaXQgaXMgcmVtb3ZlZC4gUG9zdCBzaGFk
b3cgaW4gdGhlIHRyYXBwaW5nDQpwYXRoIG1pZ2h0IGJlIGV4dGVuZGVkIHRvIGhhbmRsZSB0aGlz
IHByb2JsZW0uDQoNCj4gQ3VycmVudGx5IGludGVsX2d2dF9pc192YWxpZF9nZm4oKSBpcyBjYWxs
ZWQgaW4gdHdvIHBsYWNlczoNCj4gKDEpIHNoYWRvd2luZyBndWVzdCBHR1RUIGVudHJ5DQo+ICgy
KSBzaGFkb3dpbmcgZ3Vlc3QgUFBHVFQgbGVhZiBlbnRyeSwNCj4gd2hpY2ggd2FzIGludHJvZHVj
ZWQgaW4gY29tbWl0IGNjNzUzZmJlMWFjNA0KPiAoImRybS9pOTE1L2d2dDogdmFsaWRhdGUgZ2Zu
IGJlZm9yZSBzZXQgc2hhZG93IHBhZ2UgZW50cnkiKS4NCj4gDQo+IEhvd2V2ZXIsIG5vdyBpdCdz
IG5vdCBuZWNlc3NhcnkgdG8gY2FsbCB0aGlzIGludGVyZmFjZSBhbnkgbW9yZSwgYmVjYXVzZQ0K
PiBhLiBHR1RUIHBhcnRpYWwgd3JpdGUgaXNzdWUgaGFzIGJlZW4gZml4ZWQgYnkNCj4gICAgIGNv
bW1pdCBiYzA2ODZmZjVmYWQNCj4gICAgICgiZHJtL2k5MTUvZ3Z0OiBzdXBwb3J0IGluY29uc2Vj
dXRpdmUgcGFydGlhbCBndHQgZW50cnkgd3JpdGUiKQ0KPiAgICAgY29tbWl0IDUxMGZlMTBiNjE4
MA0KPiAgICAgKCJkcm0vaTkxNS9ndnQ6IGZpeCBhIGJ1ZyBvZiBwYXJ0aWFsbHkgd3JpdGUgZ2d0
dCBlbnRpZXMiKQ0KPiBiLiBQUEdUVCByZXNpZGVzIGluIG5vcm1hbCBndWVzdCBSQU0gYW5kIHdl
IG9ubHkgdHJlYXQgOC1ieXRlIHdyaXRlcw0KPiAgICAgYXMgdmFsaWQgcGFnZSB0YWJsZSB3cml0
ZXMuIEFueSBpbnZhbGlkIEdQQSBmb3VuZCBpcyByZWdhcmRlZCBhcw0KPiAgICAgYW4gZXJyb3Is
IGVpdGhlciBkdWUgdG8gZ3Vlc3QgbWlzYmVoYXZpb3IvYXR0YWNrIG9yIGJ1ZyBpbiBob3N0DQo+
ICAgICBzaGFkb3cgY29kZS4NCj4gICAgIFNvLHJhdGhlciB0aGFuIGRvIEdGTiBwcmUtY2hlY2tp
bmcgYW5kIHJlcGxhY2UgaW52YWxpZCBHRk5zIHdpdGgNCj4gICAgIHNjcmF0Y2ggR0ZOIGFuZCBj
b250aW51ZSBzaWxlbnRseSwganVzdCByZW1vdmUgdGhlIHByZS1jaGVja2luZyBhbmQNCj4gICAg
IGFib3J0IFBQR1RUIHNoYWRvd2luZyBvbiBlcnJvciBkZXRlY3RlZC4NCj4gYy4gR0ZOIHZhbGlk
aXR5IGNoZWNrIGlzIHN0aWxsIHBlcmZvcm1lZCBpbg0KPiAgICAgaW50ZWxfZ3Z0X2RtYV9tYXBf
Z3Vlc3RfcGFnZSgpIC0tPiBndnRfcGluX2d1ZXN0X3BhZ2UoKS4NCj4gICAgIEl0J3MgbW9yZSBk
ZXNpcmFibGUgdG8gY2FsbCBWRklPIGludGVyZmFjZSB0byBkbyBib3RoIHZhbGlkaXR5IGNoZWNr
DQo+ICAgICBhbmQgbWFwcGluZy4NCj4gICAgIENhbGxpbmcgaW50ZWxfZ3Z0X2lzX3ZhbGlkX2dm
bigpIHRvIGRvIEdGTiB2YWxpZGl0eSBjaGVjayBmcm9tIEtWTSBzaWRlDQo+ICAgICB3aGlsZSBs
YXRlciBtYXBwaW5nIHRoZSBHRk4gdGhyb3VnaCBWRklPIGludGVyZmFjZSBpcyB1bm5lY2Vzc2Fy
aWx5DQo+ICAgICBmcmFnaWxlIGFuZCBjb25mdXNpbmcgZm9yIHVuYXdhcmUgcmVhZGVycy4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IFlhbiBaaGFvIDx5YW4ueS56aGFvQGludGVsLmNvbT4NCj4gW3Nl
YW46IHJlbW92ZSBub3ctdW51c2VkIGxvY2FsIHZhcmlhYmxlc10NCj4gU2lnbmVkLW9mZi1ieTog
U2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IC0tLQ0KPiAgIGRyaXZl
cnMvZ3B1L2RybS9pOTE1L2d2dC9ndHQuYyB8IDM2ICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDM1IGRlbGV0aW9u
cygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2d2dC9ndHQuYyBi
L2RyaXZlcnMvZ3B1L2RybS9pOTE1L2d2dC9ndHQuYw0KPiBpbmRleCA1OGI5YjMxNmFlNDYuLmYz
MDkyMmM1NWEwYyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvZ3Z0L2d0dC5j
DQo+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2d2dC9ndHQuYw0KPiBAQCAtNDksMjIgKzQ5
LDYgQEANCj4gICBzdGF0aWMgYm9vbCBlbmFibGVfb3V0X29mX3N5bmMgPSBmYWxzZTsNCj4gICBz
dGF0aWMgaW50IHByZWFsbG9jYXRlZF9vb3NfcGFnZXMgPSA4MTkyOw0KPiAgIA0KPiAtc3RhdGlj
IGJvb2wgaW50ZWxfZ3Z0X2lzX3ZhbGlkX2dmbihzdHJ1Y3QgaW50ZWxfdmdwdSAqdmdwdSwgdW5z
aWduZWQgbG9uZyBnZm4pDQo+IC17DQo+IC0Jc3RydWN0IGt2bSAqa3ZtID0gdmdwdS0+dmZpb19k
ZXZpY2Uua3ZtOw0KPiAtCWludCBpZHg7DQo+IC0JYm9vbCByZXQ7DQo+IC0NCj4gLQlpZiAoIXRl
c3RfYml0KElOVEVMX1ZHUFVfU1RBVFVTX0FUVEFDSEVELCB2Z3B1LT5zdGF0dXMpKQ0KPiAtCQly
ZXR1cm4gZmFsc2U7DQo+IC0NCj4gLQlpZHggPSBzcmN1X3JlYWRfbG9jaygma3ZtLT5zcmN1KTsN
Cj4gLQlyZXQgPSBrdm1faXNfdmlzaWJsZV9nZm4oa3ZtLCBnZm4pOw0KPiAtCXNyY3VfcmVhZF91
bmxvY2soJmt2bS0+c3JjdSwgaWR4KTsNCj4gLQ0KPiAtCXJldHVybiByZXQ7DQo+IC19DQo+IC0N
Cj4gICAvKg0KPiAgICAqIHZhbGlkYXRlIGEgZ20gYWRkcmVzcyBhbmQgcmVsYXRlZCByYW5nZSBz
aXplLA0KPiAgICAqIHRyYW5zbGF0ZSBpdCB0byBob3N0IGdtIGFkZHJlc3MNCj4gQEAgLTEzMzMs
MTEgKzEzMTcsOSBAQCBzdGF0aWMgaW50IHBwZ3R0X3BvcHVsYXRlX3NoYWRvd19lbnRyeShzdHJ1
Y3QgaW50ZWxfdmdwdSAqdmdwdSwNCj4gICBzdGF0aWMgaW50IHBwZ3R0X3BvcHVsYXRlX3NwdChz
dHJ1Y3QgaW50ZWxfdmdwdV9wcGd0dF9zcHQgKnNwdCkNCj4gICB7DQo+ICAgCXN0cnVjdCBpbnRl
bF92Z3B1ICp2Z3B1ID0gc3B0LT52Z3B1Ow0KPiAtCXN0cnVjdCBpbnRlbF9ndnQgKmd2dCA9IHZn
cHUtPmd2dDsNCj4gLQljb25zdCBzdHJ1Y3QgaW50ZWxfZ3Z0X2d0dF9wdGVfb3BzICpvcHMgPSBn
dnQtPmd0dC5wdGVfb3BzOw0KPiAgIAlzdHJ1Y3QgaW50ZWxfdmdwdV9wcGd0dF9zcHQgKnM7DQo+
ICAgCXN0cnVjdCBpbnRlbF9ndnRfZ3R0X2VudHJ5IHNlLCBnZTsNCj4gLQl1bnNpZ25lZCBsb25n
IGdmbiwgaTsNCj4gKwl1bnNpZ25lZCBsb25nIGk7DQo+ICAgCWludCByZXQ7DQo+ICAgDQo+ICAg
CXRyYWNlX3NwdF9jaGFuZ2Uoc3B0LT52Z3B1LT5pZCwgImJvcm4iLCBzcHQsDQo+IEBAIC0xMzU0
LDEzICsxMzM2LDYgQEAgc3RhdGljIGludCBwcGd0dF9wb3B1bGF0ZV9zcHQoc3RydWN0IGludGVs
X3ZncHVfcHBndHRfc3B0ICpzcHQpDQo+ICAgCQkJcHBndHRfZ2VuZXJhdGVfc2hhZG93X2VudHJ5
KCZzZSwgcywgJmdlKTsNCj4gICAJCQlwcGd0dF9zZXRfc2hhZG93X2VudHJ5KHNwdCwgJnNlLCBp
KTsNCj4gICAJCX0gZWxzZSB7DQo+IC0JCQlnZm4gPSBvcHMtPmdldF9wZm4oJmdlKTsNCj4gLQkJ
CWlmICghaW50ZWxfZ3Z0X2lzX3ZhbGlkX2dmbih2Z3B1LCBnZm4pKSB7DQo+IC0JCQkJb3BzLT5z
ZXRfcGZuKCZzZSwgZ3Z0LT5ndHQuc2NyYXRjaF9tZm4pOw0KPiAtCQkJCXBwZ3R0X3NldF9zaGFk
b3dfZW50cnkoc3B0LCAmc2UsIGkpOw0KPiAtCQkJCWNvbnRpbnVlOw0KPiAtCQkJfQ0KPiAtDQo+
ICAgCQkJcmV0ID0gcHBndHRfcG9wdWxhdGVfc2hhZG93X2VudHJ5KHZncHUsIHNwdCwgaSwgJmdl
KTsNCj4gICAJCQlpZiAocmV0KQ0KPiAgIAkJCQlnb3RvIGZhaWw7DQo+IEBAIC0yMzM1LDE0ICsy
MzEwLDYgQEAgc3RhdGljIGludCBlbXVsYXRlX2dndHRfbW1pb193cml0ZShzdHJ1Y3QgaW50ZWxf
dmdwdSAqdmdwdSwgdW5zaWduZWQgaW50IG9mZiwNCj4gICAJCW0udmFsNjQgPSBlLnZhbDY0Ow0K
PiAgIAkJbS50eXBlID0gZS50eXBlOw0KPiAgIA0KPiAtCQkvKiBvbmUgUFRFIHVwZGF0ZSBtYXkg
YmUgaXNzdWVkIGluIG11bHRpcGxlIHdyaXRlcyBhbmQgdGhlDQo+IC0JCSAqIGZpcnN0IHdyaXRl
IG1heSBub3QgY29uc3RydWN0IGEgdmFsaWQgZ2ZuDQo+IC0JCSAqLw0KPiAtCQlpZiAoIWludGVs
X2d2dF9pc192YWxpZF9nZm4odmdwdSwgZ2ZuKSkgew0KPiAtCQkJb3BzLT5zZXRfcGZuKCZtLCBn
dnQtPmd0dC5zY3JhdGNoX21mbik7DQo+IC0JCQlnb3RvIG91dDsNCj4gLQkJfQ0KPiAtDQo+ICAg
CQlyZXQgPSBpbnRlbF9ndnRfZG1hX21hcF9ndWVzdF9wYWdlKHZncHUsIGdmbiwgUEFHRV9TSVpF
LA0KPiAgIAkJCQkJCSAgICZkbWFfYWRkcik7DQo+ICAgCQlpZiAocmV0KSB7DQo+IEBAIC0yMzU5
LDcgKzIzMjYsNiBAQCBzdGF0aWMgaW50IGVtdWxhdGVfZ2d0dF9tbWlvX3dyaXRlKHN0cnVjdCBp
bnRlbF92Z3B1ICp2Z3B1LCB1bnNpZ25lZCBpbnQgb2ZmLA0KPiAgIAkJb3BzLT5jbGVhcl9wcmVz
ZW50KCZtKTsNCj4gICAJfQ0KPiAgIA0KPiAtb3V0Og0KPiAgIAlnZ3R0X3NldF9ndWVzdF9lbnRy
eShnZ3R0X21tLCAmZSwgZ19ndHRfaW5kZXgpOw0KPiAgIA0KPiAgIAlnZ3R0X2dldF9ob3N0X2Vu
dHJ5KGdndHRfbW0sICZlLCBnX2d0dF9pbmRleCk7DQoNCg==
