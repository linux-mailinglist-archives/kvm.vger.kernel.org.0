Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49EFD760360
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 01:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjGXX5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 19:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjGXX5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 19:57:51 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCF7171B;
        Mon, 24 Jul 2023 16:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690243071; x=1721779071;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3nIuXglcTwimtb9I4Z31PORlmiDdBKfL9jwQTFjSzQQ=;
  b=HhtV9bjtjsc7uYNX17upUiT61MnhwDBKmrk5pR6f3yFIemelQYofSL1T
   VhPTX7klQjn67SwGpxELosu6mIWNPg0HbX+0vdE0vkKcEFUZ2z81ZwWxk
   pyW3eM5B/3UaAm3EUWfIRJzi/iZFCZPbYolIqPtA1YNdkZGDYySsYULJZ
   uWsu1wHd+MKVRV7O+Ts81op7FijiSn2Lt8epKUpZqi1msSAvlOW3L05zY
   72GHeR8krG+oHgBfQLCHhzTuOhduhb8gx8alg82rF9XqaqY1o2B5dD05G
   cLxCwhYxx17VTWL7iC67CSvvuRLgfutFqPhhwl15gnnT/AUvfToo5yyXf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="352475154"
X-IronPort-AV: E=Sophos;i="6.01,229,1684825200"; 
   d="scan'208";a="352475154"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 16:57:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="795939267"
X-IronPort-AV: E=Sophos;i="6.01,229,1684825200"; 
   d="scan'208";a="795939267"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 24 Jul 2023 16:57:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 24 Jul 2023 16:57:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 24 Jul 2023 16:57:49 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 24 Jul 2023 16:57:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OwrpMJJXHofSMy399NQjZk2NLq0mDkFayh8omGfsrLde6LgRNxw7CE5CyidrDG/WE0hv/39FNB/xB8V9wbk8jMyUheO4lyDRBbQkgWxJT0dmZXQ7vzhehamyYuJw8kyvlp1vKcIL+ZEyDxYRMGjbDIh7ijRCIg8lrNuZUSJFSla/v3PlQZB5wk4D1HIHY4xcTy/kKufaiOLJUo2ACb9Ni6Ado1A1wMltfTr2K4KNMgvyRYqm4VaOw3qTlUFo91z5717PViVFCo5yav9SASn+9feKAvElt04pedC5HMH9RZsWx+65wJiVWO3RudrnXvmZsdcAXHyEnp83QZsdzXBapA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3nIuXglcTwimtb9I4Z31PORlmiDdBKfL9jwQTFjSzQQ=;
 b=Hi7Gr4jmO2N1cxeL063lkFaYKEhEEQziPKs5aqKsWxzZfVNx4yp+sKM2suV8vujy92SXG49LRbEPvOqwlMHw0bcdex1ayKnRFOHp3rlBfSNaK9L2hkQ7WQDKsEcN4oousNmgWm7ldgazFHgUEZt+8bbojgzHkFXEHHSZXh7DFow0amEbq04+oL5PS8oLiqqK1rQcsIxI7XejLvhkp3ZyHN1QBkLPb2Wa0mw/7G78bGVEDYiCSXEG99vWhHhoG4iSFaA95ZjfbDidb3wkjyQxoIP2SIIfVe82eaE8CIB3iFEyvlOKTudvkDlvphC+sgy6fIliedfeNiKD5MxKHfq0hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7439.namprd11.prod.outlook.com (2603:10b6:806:343::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.31; Mon, 24 Jul
 2023 23:57:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3729:308d:4f:81c8]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3729:308d:4f:81c8%3]) with mapi id 15.20.6609.032; Mon, 24 Jul 2023
 23:57:46 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v4 07/19] x86/reboot: Disable virtualization during reboot
 iff callback is registered
Thread-Topic: [PATCH v4 07/19] x86/reboot: Disable virtualization during
 reboot iff callback is registered
Thread-Index: AQHZvBCn8jr6ShriWke6l4TMUeBQTa/JnSUA
Date:   Mon, 24 Jul 2023 23:57:46 +0000
Message-ID: <7fcc0a4b3b653bfc9c031a3ca060e4cd14119228.camel@intel.com>
References: <20230721201859.2307736-1-seanjc@google.com>
         <20230721201859.2307736-8-seanjc@google.com>
In-Reply-To: <20230721201859.2307736-8-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7439:EE_
x-ms-office365-filtering-correlation-id: 576d8810-fce3-481c-f279-08db8ca1c781
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xdqt9Djr8E1WG79BYlAANmrHo8O8OIDbZwB8qj4dCN7F585oiB4lnv9nWLCoKEduJEfIqJk6PKpcu/yU7kMq+sIU7ZYmdBn2t6dxXpKXBW2dM3D6ODwfAvprh2Btpj7gyJulKcjMsHgqDP0/jzsiu0t5EHi1JlinY0HWos/e/MlxMOXa9/ZTX+sSCwG3Qs7iwL3Yj6p7l/tijk1eeVbk7U7N7VBhv2WrvGq/ALH3Zve7NSKWAriEV05UItTCa3wT5OZVp4RY6sUNNW0Sb9d5++K24zOR094OfujGbsKxmp2kzWnsQnzk+abYJc0lQPmhM+ObkQCHmzIKemschty1DEh5legxeFVPFxuCgK2+B1Mm5Rb3Nr0cyFDvDV8ZiNtjH8oRS9amy9hJL6wyQ9+DkRLwqbBYyu1iIGYiR7R6gq7lnD7XxlgPuvaabmXAv8+A1BdT1qq5GBFYi8U/gwhYFwk5q09ti5iVdB36tg7p06d4ls49RyYcOgM2bzy/SYVHERTSt+/4x9C+fo1l9vroVyrpooCQKeo7csHJVk79zZBMyx9OHwpK8mv/odPDyqk02H3FsI6MIlVxcB/FAd/Y3FDIl9Wx7MTHR+fZEy9deXuC46VutP8xldZnebEfrVrI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(396003)(376002)(39860400002)(136003)(451199021)(82960400001)(86362001)(38100700002)(122000001)(71200400001)(6486002)(6512007)(4744005)(2906002)(2616005)(6506007)(66476007)(186003)(26005)(38070700005)(36756003)(110136005)(5660300002)(66556008)(41300700001)(76116006)(66946007)(91956017)(64756008)(66446008)(316002)(4326008)(478600001)(7416002)(8936002)(54906003)(83380400001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YU4wSnh2TmszMERXNkxORVJwUlA5YnBtU25uZmg1cGROZGZPRDFQeHZzL2tZ?=
 =?utf-8?B?TkZnNGw2VFRIY3poYzZGdktKRDEyQ3lSMU5wbXJDbCtac3RaTUtPR0t6d29J?=
 =?utf-8?B?empvZnZiMkxJbHhGa0xUTkZQZWFwQStITXloMDlkREpVRm5GQWd4K0crQmxn?=
 =?utf-8?B?S2xuTVp6MjB2VEJtYmpBSEJua2U0Z3UzM1hyL2p6YjJweXYvcWtMNm1keGx6?=
 =?utf-8?B?M3huSG90eFdndFZlOUZadXpmRG5aelpZY0VEWWkwUC9obGg0RlY0QXE4OFVW?=
 =?utf-8?B?YWUzZlNWV0R5N24xWSthVStWTmZnc2tEdHV3UmQzSTdzZFN3Ym5tYzFwRlFC?=
 =?utf-8?B?WmtQUVBFOHdveHgyUk1VeHU2S3pibHR1eFFCTlZ5a0ltNWRIVjlLamI5N3BH?=
 =?utf-8?B?dFE5ai9hb1B3T3J3WFc4aG5wTjgwdFB4RC9kcVZUSTQ2UmJxVXJFM3JJWFNG?=
 =?utf-8?B?RFhjYWs2SEdNOGVPeS9pdElHaDdQVk5QUjQvc1FkdEVXZEZjMW9QdkF6SVN1?=
 =?utf-8?B?MXdwc0d3MXVoQnYvcGZBNVRwU0d5M3VoeTV4eFRQNTh6b091SlBBMGFUK25s?=
 =?utf-8?B?eXQrVStLdVNac016NVQ0S0c0MGI1azVMK29IaG12TkxwUmFVRENES2w2OU5v?=
 =?utf-8?B?NEh2MThLTDhqOFYyNEw0SDc0bUx6NEtmZERBTVRkSlNtZjllQVhjcElFMGxR?=
 =?utf-8?B?OHphb1ZXdGlqQTZCZXIwVkxEdGh2alJ2eWZzNHhzSm9ZcE1yeDZpUU1PYmxy?=
 =?utf-8?B?VHI5cFpMV2t3cHdKTFNQb2F1V2FVS0grWC9RbThxdnU2Y2RBTzVIaFJNNVJZ?=
 =?utf-8?B?OVFUaTNDck53YzhlaUc0dXVHMEl0MDBKbko4UjNDWjNHelZPaWdXQzQvN1Y1?=
 =?utf-8?B?YTR1L0piZUxjMml4NkRpUTJ2QmtPQzFnRlpSTHFrWEZyVW5md3ZkY1pSeFJH?=
 =?utf-8?B?VGVIR0w3V2ZteEJCM1ZDTnhFTjcxdktGVytaNyt6MXJWQTFUUWkxNXRkRUdT?=
 =?utf-8?B?TnNDeFhSRWovbXlRc1hVYkhRVnlENHZqTy9FNGF1aEgrTmNQejJZd1I4VUY0?=
 =?utf-8?B?T3JEYnp3NWhVOVNpM1dkUi9VZlRnK2dUSlN3TFp5YVJWUElkL1dnOFI2bk1G?=
 =?utf-8?B?V1M2a1pIL2htV1BvcDIzNEZqQnRsd3hGeWpXYmJudnpsb2lLTmQzcVRIdTlF?=
 =?utf-8?B?OEFrajRzRmJRNmN4VlhuckRNUUVpYjJkTlN2M3ZRRWVrU01Yb2xrakhqdG1R?=
 =?utf-8?B?WEVoV2FZbzluRkFQQ0IvaFJSSmJ3OEZwWDFpTWZ2cEdlTllLSGErU2trYkdF?=
 =?utf-8?B?RWtuQk5QUkJ4T2dPV0VHbUFNTmNNdUNKUGFKakJCUFZlVjZzVkIveFNNQmRK?=
 =?utf-8?B?eTR2elgyclc0Q0E1QllFZjNrOEVqdFA1ZFVYTUQ0QzN6WllBdXJNUDU3QjVa?=
 =?utf-8?B?c0NyeTNPM3RwYWJORUZ0aHBKa0N1SXBDdzZkczJWclh4Vyttc0orSitieFRt?=
 =?utf-8?B?ZU1rbmFmV3JnWDlyL3NQenZNMW1tVnBHWXJud2JLdkg0Z2NFYVV0R1NSY0hG?=
 =?utf-8?B?V0ZvTUkzdGNMWlIrM01yUmUrcTQzTG9hWjF1VG1JcTNsR2ZNRDU1L1Q0a2FL?=
 =?utf-8?B?cE1jOUY2NWlCT3BJWXI4T2N0RUpYYmg5T1ByNlphQnlCLzVjZ0tjSHk0Q3RT?=
 =?utf-8?B?c2JuQUorckVwZUFsRzBMOW9TZzMwWHBFek5TZkh0bnAxb05OeDRNL2duR2lh?=
 =?utf-8?B?ZFhFYXpmeDFOQXdDTUZ4ektvTW9leHhwRW9oa28wbXAvdjNQMWRyN0s3N25o?=
 =?utf-8?B?WG01Q05NUlNGNm4xejljNXkyUTd4R1czUEh0OStaWldoVzZ5eFVMY2xQdkh0?=
 =?utf-8?B?a0RpOUpHY0ZQaXpldHV6VmdTTjM5N0toMnYzeXUrU2RFTDBTL2hUZi80L2hl?=
 =?utf-8?B?MCs5enJoM0pNc2g2SHUxL0w4bGd0MDhLclJ4UGplN2M2U2puMlNVRy9xNWpS?=
 =?utf-8?B?ekRyakJnTDRrTlN1ejc5TitwcDVrSTZmTHNnbnZnNWE2OXoyNmlUeHRpY3ly?=
 =?utf-8?B?dFRyeUhWM1NtcmR0ZFlscml3TTFoZjRpNlhQb2xYQVpwQldaNjI2Y09HeW9W?=
 =?utf-8?Q?8D3EfP2fXhAZYgLzG6KdYOz49?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C87D7AA28014CD4FB903ECD456B1C059@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 576d8810-fce3-481c-f279-08db8ca1c781
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2023 23:57:46.7522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3bEhbopvUwBjmqmigJezYYihzH+gqW8qWe5u53ptEx6PRN1vEK8rGh1yeMdYx7EoIuT2Dx4Mo1XmA+dgiCiLAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7439
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA3LTIxIGF0IDEzOjE4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBdHRlbXB0IHRvIGRpc2FibGUgdmlydHVhbGl6YXRpb24gZHVyaW5nIGFuIGVtZXJn
ZW5jeSByZWJvb3QgaWYgYW5kIG9ubHkNCj4gaWYgdGhlcmUgaXMgYSByZWdpc3RlcmVkIHZpcnQg
Y2FsbGJhY2ssIGkuZS4gaWZmIGEgaHlwZXJ2aXNvciAoS1ZNKSBpcw0KPiBhY3RpdmUuICBJZiB0
aGVyZSdzIG5vIGFjdGl2ZSBoeXBlcnZpc29yLCB0aGVuIHRoZSBDUFUgY2FuJ3QgYmUgb3BlcmF0
aW5nDQo+IHdpdGggVk1YIG9yIFNWTSBlbmFibGVkIChiYXJyaW5nIGFuIGVncmVnaW91cyBidWcp
Lg0KPiANCj4gQ2hlY2tpbmcgZm9yIGEgdmFsaWQgY2FsbGJhY2sgaW5zdGVhZCBvZiBzaW1wbHkg
Zm9yIFNWTSBvciBWTVggc3VwcG9ydA0KPiBjYW4gYWxzbyBlbGltaW5hdGVzIHNwdXJpb3VzIE5N
SXMgYnkgYXZvaWRpbmcgdGhlIHVuZWNlc3NhcnkgY2FsbCB0bw0KPiBubWlfc2hvb3Rkb3duX2Nw
dXNfb25fcmVzdGFydCgpLg0KPiANCj4gTm90ZSwgSVJRcyBhcmUgZGlzYWJsZWQsIHdoaWNoIHBy
ZXZlbnRzIEtWTSBmcm9tIGNvbWluZyBhbG9uZyBhbmQNCj4gZW5hYmxpbmcgdmlydHVhbGl6YXRp
b24gYWZ0ZXIgdGhlIGZhY3QuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVy
c29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gDQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGth
aS5odWFuZ0BpbnRlbC5jb20+DQoNCg==
