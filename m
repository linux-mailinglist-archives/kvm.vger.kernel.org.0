Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F567A1D9D
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 13:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbjIOLnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 07:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbjIOLnG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 07:43:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5296F1FE5;
        Fri, 15 Sep 2023 04:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694778181; x=1726314181;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xTFaWKnp021eHG2aknmj6ap+QX2TB4L9lOxjBLlYKa4=;
  b=emPIxtqjRF8iw7ZYI4Q4wBS1FqbT8Z3F8oPBqQDQRk2hH5mr0sNwBc8t
   nIpcxWAWt/uGnVVFQn/9E6cePFMYUQU14We2zi5mwxMkt2rXIVUvHkGzO
   /QEhkhDtRcGpWq/y5XBjPAnXSRUP6652OabW4nMa+6tVAmd5qICZwCyfF
   ukrnz9rcORYNsu2/ckDj7uKw1atLVbGlR8VB3ZF1RGKsqfwsZJJs7oLqh
   SRC8uqUmup8VUs7JsnJq2Ygx8ppC+Lw4BBajCC/HRlmigiWfZXdTochxX
   EaSrMSjO41EtBjOfukozAvISzxT2bA7MTQEPqR8qV4+o4Mb+QAmoKUu7n
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="358643347"
X-IronPort-AV: E=Sophos;i="6.02,149,1688454000"; 
   d="scan'208";a="358643347"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2023 04:43:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="868678624"
X-IronPort-AV: E=Sophos;i="6.02,149,1688454000"; 
   d="scan'208";a="868678624"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Sep 2023 04:43:00 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 15 Sep 2023 04:43:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 15 Sep 2023 04:42:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 15 Sep 2023 04:42:59 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 15 Sep 2023 04:42:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B6doLkJyiPhg942Us7bLJJb8wSzMmy6OmzgxcOp2G2hbvyKd3y19VbcwIhyeI/DReMFMLOPioJ6QuQpRrPP96Y/VWq5r2zP9HV4QfGrWuueEk8K3VOkkH3C/eZhBzf9vVjaDCJfLR+xhKUXuIZYKmIfsHVcR0y3R+vYPR4SR32G7j7fid5tll2zJtEZ0Sel8PFII59tkNoivugWZd3TpWCHDz9gOpdgxaDdNoRCEaRsCI0/yDNrdYO/OJzbIQ8l4+7MuaAf0Ext6wPP+lNMciWclcR4FDegHoLlu5sEYAkZWlcBSR5PjowENnZ6to5iLU8hlftrplKtILpr9+WNn2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xTFaWKnp021eHG2aknmj6ap+QX2TB4L9lOxjBLlYKa4=;
 b=YJP5cXM9zIERzo6bXRLbJclVdxlt5l5n2OhP4rIbeHZZ8JUlDRsrExRGT8tc660A9l3LW74MAioseeOkP//WFt8UBG2WALyqo26ywX0HOFvtDQH/5+sPR+wTeNs4B6MIE48gJ5X9sWfeoItAHxN/+Sf9wlucYkWfqUp5iwU8K4z/O8tf/xbBA5tzarDRcopIKbHAOZkJi2n73ge00rSr5nlflkFQF3edmvT8i5TOPljO947diRsFUwCBri8psYTTs1pSHeqdL1oZOodzVW1tnq/XAtjLIbS7+CvWslmzc1cX6JHSxMmKy2K93NZSPXvRVrdwPcGwNC/2qG34igk5fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7081.namprd11.prod.outlook.com (2603:10b6:930:53::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21; Fri, 15 Sep
 2023 11:42:52 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6768.036; Fri, 15 Sep 2023
 11:42:52 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v13 20/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Thread-Topic: [PATCH v13 20/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Thread-Index: AQHZ101Okhxwq9ktjkOz/F9rFTzkybAa+E0AgADsmYA=
Date:   Fri, 15 Sep 2023 11:42:52 +0000
Message-ID: <c33f7c61a1a24c283294075862cae4452d7dec3d.camel@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
         <12c249371edcbad8fbb15af558715fb8ea1f1e05.1692962263.git.kai.huang@intel.com>
         <87497f25d91c5f633939c1cb87001dde656bd220.camel@intel.com>
In-Reply-To: <87497f25d91c5f633939c1cb87001dde656bd220.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB7081:EE_
x-ms-office365-filtering-correlation-id: 3251fd1d-711a-4d39-3074-08dbb5e0e4fa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z7jOdAeJz9EElHkR5q7JXTfVVNoonXxS/rrATex1ZXScj7F7z4uy8xOqzZPn3chtwZq65eRdRswopiECSmo0e7OPAD/BtMFLT45atyLgVYYCtcoNIEbtsqSBZMWgkwEaKwtn1lMPRHst137hQft8mdjO7XeySXn5+o2r+4QkU9U3UmTrYS/KI81SKN1KHrRddcttbdc8yAAarjHzGs4HUpybfwqsAWjvy8eHTGaq+gNZ8FmJG4HjPMKq7tIrkVmhND+x8QfUvvaMZZx06IDnDBHyOjPmGeljOb4itGahQ1puhiIWnY2kosHyfKIJu9uffUxwg5XF+vVzvc6oUKHX3hoM6hLxaXh+F9rB0GcYmp7yO0AtIYhe36KP9EkOoL4pbQw2pOB8+HQHKKVVvJiNQciWVBd1kkgCX1H9vtI1EbL+eoQJobDV1PWnMwWoPivqsnfcB05OT9sRRCju2cG0kmTqrFYpGKCQiSBEK6+tQ1UEqPV5LeRjeV/ZoSR0Ev2ojG3ceK20aIk0MOKfWv36N5onP7d/hhaH2MKpzxfWtUcmdSIr+mG4Wd/3SmuMFMjot3LTewGnOYmHHUFfbatV/ONT7d3Dn4vzUPenHrUySYq95mAfAqJBf2zwmtykirSS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(346002)(396003)(39860400002)(376002)(1800799009)(186009)(451199024)(41300700001)(110136005)(86362001)(316002)(91956017)(66946007)(76116006)(6636002)(64756008)(66556008)(66446008)(66476007)(54906003)(7416002)(71200400001)(122000001)(478600001)(38100700002)(38070700005)(82960400001)(36756003)(2906002)(5660300002)(4326008)(8936002)(8676002)(26005)(2616005)(6486002)(6506007)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0VvNjc0TlFLaWx6UENtRkd4WERuSTA5S2ZibUVPbmNGK0g0a2xKK2Jyb1BL?=
 =?utf-8?B?RHRPZUFLNERVNis1TmcydzJXUmxYZEFLZ0luYWo4THdCcmNadHo5NTVWK05Q?=
 =?utf-8?B?czBEM1p3ckY5andmN1A4SVpQK0d3eStwdTJxSTdYcDVPOEpwSnl1MFQwejV4?=
 =?utf-8?B?VFVlcXhGZ2tVVUwzSFNRbEZrT2syZDNDNVl3QUp0V05aZU1BMERXdEk1K2hy?=
 =?utf-8?B?VkoyQjRJbnpHT1VkbkVaZlFqbk00L3B1YjIzdW82NmtHeEdkMVdocGFBMWZ4?=
 =?utf-8?B?RW9rTVVhcm9tUnhTTDRHWDZQSlpLbjBtNWtkbUNVVGlQQjJNNUJJMHJ6S0Ey?=
 =?utf-8?B?MUNYaEd2M1RxaHNuUXVYc3ZZUkY0OVBEZjEwRmxRalB2ZnZrUTFBczc4cEVP?=
 =?utf-8?B?c3gvcDk3OG1BM2dRdWMvWFY0d0Q3QUNBb0NEUFRnNG1xN2VjMzJHZmUvMU03?=
 =?utf-8?B?QW50K29sYlM1SVNFbW11dWk4b0hvV2ZNWkx4SnBoS1hEQjY5ZEtiaDhzMG00?=
 =?utf-8?B?OEliZllVdnRTMjVRWGdKazdrQTQ0ZkNHNGVML1YrSE9qaXZtUmRKYklhQ0k3?=
 =?utf-8?B?UmFHeWMwaTllTmZtZURwVW9LZWpRMHk4ZDd3dmxMd1lEWTlTaUdZTE8xT1Fj?=
 =?utf-8?B?SVFMUUNFK0tqSEFOalB5cFA0Y3lFcWRrMHdJaVdiTFJPTG1tVDFtb1NocmJJ?=
 =?utf-8?B?bTJFNXQ0RkFtL3FObTFzSkRtUlhZL2dYK1YxRkdvTjlyWmhYc0g4S2hhMzVQ?=
 =?utf-8?B?eVBaZDVDYllhVld6VEYyd3ZDVmR6QkhrbDR5UVFFQ2hieDdXblVBb2ZYUytz?=
 =?utf-8?B?R0RTUkpweTE5YzgzNnlSVnlmZkJFbmJHd2tnZ3dLNlVpUTBPSDFERTlPK3pS?=
 =?utf-8?B?czJLYUd4SXZ3VHduS2xNd0EyQVJXTUNwVnp4YVY0bmE5Q0JLQ0tkSVpoZVND?=
 =?utf-8?B?OStDRE90UVFhenZocVR6cndlSnZVUkhob2R2K0FrMytMMXFzdGp4aENQODRY?=
 =?utf-8?B?dVJ6cWtOem9kV3FhcW9yMDlHRFBYelNBOGR5SzBLSUNXcXV6ZHpSbnoxV3A5?=
 =?utf-8?B?TlhTRENQNnN5Tzk2STUvb29iVWs4K3BkbG01cjhoNndueXFuZXBKME5panRO?=
 =?utf-8?B?SjdRV3VpUEVUaDRSOTJ1bXY5SkNYa21QWVNvZW1zSHBtTWhXMXpnWVdSSW54?=
 =?utf-8?B?TytubTJvdEhXeUFEMVUyaGNQMXhySnljZ2ZSQmJuWm5Icmt1VSt0WjBFQ01n?=
 =?utf-8?B?bTVPcDVhamVRcUNndHpBUkRBaG41endkYTVTUGhtM2p5NnllbHVMYXdiRlhn?=
 =?utf-8?B?UXJLNHN5cm9ERkttSURyOXVCTTF0V010Z1M4UDBNeG93OFJyK3lpSmlzTFhs?=
 =?utf-8?B?MWk3eWJPMU5tUGdmTjB4ZDJ2clhMZVFid1VkOXQ5RXVKU3pUS01WOUdmQlFC?=
 =?utf-8?B?dHd2Y3VNdzRuU0NxY1hDOEFHVm0vWGt0TWRIZTNEa2Y4MFRkVFdJN1JnT0hs?=
 =?utf-8?B?ZFgwYjFhSVJmWXFlUEtWTmZMUC91clpUbUpxemRjR3lLalhUMzhnYktCMmtw?=
 =?utf-8?B?U0hDMEN6WGk1NFIxRUJnWmxsZEJ6cDcwYzhaUVlxYnJEdHVqb0dXSlZBaEJC?=
 =?utf-8?B?YXF2WnBNZjZ3b3FGY1dqZlpWemVxdWtoMnV0bnRqRm43ZjlDdkhiZWxtK2l1?=
 =?utf-8?B?b2Z0ejgvTXZkdXFXMVdZRDQxa2ZjRlZ6Y3BjSHFpaXBwdWJ2UjRldnZuSlBI?=
 =?utf-8?B?MlMvTnV5WjV4WUgwSTdxMUpoV0ZpSU9KQTBUemVLalk1QWpTU25xbURDdVUw?=
 =?utf-8?B?LzR0TTI0YmJVNGE4ZG51K0luLzBMOVJsWUVwd0dtTWVpS2xVZ3hGN3JBa1pY?=
 =?utf-8?B?bEY0bVB3dVZ0YkNsdmlCY0xxenMvVjFKMUQyclVQYVFrMjZpeUNJU3I1VVBW?=
 =?utf-8?B?Ym9YSzVzWXRsV0IwcTdUQ2tYS3pJazJJVmJSRGUybUJNU215cVpsbEtvd1FF?=
 =?utf-8?B?UmhiZ1Zkb2dVUmI3Qm1RM1Q4Tm1TQUo3eXV1Snd5Y3lLSkJGQ3NNOW9QYUMx?=
 =?utf-8?B?T1pVVmJtRnJkN1NCMkZaL05nMWFCUWxzVmwyMXFxdWJ0aEY2Lzdib2Z0QlRj?=
 =?utf-8?B?Sm1GVEl0NTZsMjZPZXJIWURURlVsVVVuVWlKc2xGQ1dYVENhOG9IanN1MEI4?=
 =?utf-8?B?V3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5EA937CF09DCAC4192599CA2B195E791@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3251fd1d-711a-4d39-3074-08dbb5e0e4fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2023 11:42:52.1743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EAsYOc+h9prGa+VfQePyyXmV4SUVvEfq4A6XfVQvCgDE/zQg6O6Z1CToify8KCVYGo1njtIG3Y7W862cTMPSAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7081
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA5LTE0IGF0IDIxOjM2ICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gU2F0LCAyMDIzLTA4LTI2IGF0IDAwOjE0ICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6
DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9tYWNoaW5lX2tleGVjXzY0LmMNCj4g
PiBiL2FyY2gveDg2L2tlcm5lbC9tYWNoaW5lX2tleGVjXzY0LmMNCj4gPiBpbmRleCAxYTNlMmMw
NWE4YTUuLjAzZDk2ODllZjgwOCAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvbWFj
aGluZV9rZXhlY182NC5jDQo+ID4gKysrIGIvYXJjaC94ODYva2VybmVsL21hY2hpbmVfa2V4ZWNf
NjQuYw0KPiA+IEBAIC0yOCw2ICsyOCw3IEBADQo+ID4gwqAjaW5jbHVkZSA8YXNtL3NldHVwLmg+
DQo+ID4gwqAjaW5jbHVkZSA8YXNtL3NldF9tZW1vcnkuaD4NCj4gPiDCoCNpbmNsdWRlIDxhc20v
Y3B1Lmg+DQo+ID4gKyNpbmNsdWRlIDxhc20vdGR4Lmg+DQo+ID4gwqANCj4gPiDCoCNpZmRlZiBD
T05GSUdfQUNQSQ0KPiA+IMKgLyoNCj4gPiBAQCAtMzAxLDYgKzMwMiwxNCBAQCB2b2lkIG1hY2hp
bmVfa2V4ZWMoc3RydWN0IGtpbWFnZSAqaW1hZ2UpDQo+ID4gwqDCoMKgwqDCoMKgwqDCoHZvaWQg
KmNvbnRyb2xfcGFnZTsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgaW50IHNhdmVfZnRyYWNlX2VuYWJs
ZWQ7DQo+ID4gwqANCj4gPiArwqDCoMKgwqDCoMKgwqAvKg0KPiA+ICvCoMKgwqDCoMKgwqDCoCAq
IEZvciBwbGF0Zm9ybXMgd2l0aCBURFggInBhcnRpYWwgd3JpdGUgbWFjaGluZSBjaGVjayINCj4g
PiBlcnJhdHVtLA0KPiA+ICvCoMKgwqDCoMKgwqDCoCAqIGFsbCBURFggcHJpdmF0ZSBwYWdlcyBu
ZWVkIHRvIGJlIGNvbnZlcnRlZCBiYWNrIHRvIG5vcm1hbA0KPiA+ICvCoMKgwqDCoMKgwqDCoCAq
IGJlZm9yZSBib290aW5nIHRvIHRoZSBuZXcga2VybmVsLCBvdGhlcndpc2UgdGhlIG5ldyBrZXJu
ZWwNCj4gPiArwqDCoMKgwqDCoMKgwqAgKiBtYXkgZ2V0IHVuZXhwZWN0ZWQgbWFjaGluZSBjaGVj
ay4NCj4gPiArwqDCoMKgwqDCoMKgwqAgKi8NCj4gPiArwqDCoMKgwqDCoMKgwqB0ZHhfcmVzZXRf
bWVtb3J5KCk7DQo+ID4gKw0KPiA+IMKgI2lmZGVmIENPTkZJR19LRVhFQ19KVU1QDQo+ID4gwqDC
oMKgwqDCoMKgwqDCoGlmIChpbWFnZS0+cHJlc2VydmVfY29udGV4dCkNCj4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHNhdmVfcHJvY2Vzc29yX3N0YXRlKCk7DQo+IA0KPiBXaXRo
b3V0IGEgdG9uIG9mIGtub3dsZWRnZSBvbiBURFggYXJjaCBzdHVmZiwgSSdtIG1vc3RseSBsb29r
ZWQgYXQgdGhlDQo+IGtleGVjIGZsb3cgd2l0aCByZXNwZWN0IHRvIGFueXRoaW5nIHRoYXQgbWln
aHQgYmUgdGlua2VyaW5nIHdpdGggdGhlDQo+IFBBTVQuIEV2ZXJ5dGhpbmcgdGhlcmUgbG9va2Vk
IGdvb2QgdG8gbWUuDQo+IA0KPiBCdXQgSSdtIHdvbmRlcmluZyBpZiB5b3Ugd2FudCB0byBza2lw
IHRoZSB0ZHhfcmVzZXRfbWVtb3J5KCkgaW4gdGhlDQo+IEtFWEVDX0pVTVAvcHJlc2VydmVfY29u
dGV4dCBjYXNlLiBTb21laG93IChJJ20gbm90IGNsZWFyIG9uIGFsbCB0aGUNCj4gZGV0YWlscyks
IGtleGVjIGNhbiBiZSBjb25maWd1cmVkIHRvIGhhdmUgdGhlIG5ldyBrZXJuZWwganVtcCBiYWNr
IHRvDQo+IHRoZSBvbGQga2VybmVsIGFuZCByZXN1bWUgZXhlY3V0aW9uIGFzIGlmIG5vdGhpbmcg
aGFwcGVuZWQuIFRoZW4gSQ0KPiB0aGluayB5b3Ugd291bGQgd2FudCB0byBrZWVwIHRoZSBURFgg
ZGF0YSBhcm91bmQuIERvZXMgdGhhdCBtYWtlIGFueQ0KPiBzZW5zZT8NCj4gDQoNCkdvb2QgcG9p
bnQuICBUaGFua3MhDQoNCkJhc2VkIG9uIG15IHVuZGVyc3RhbmRpbmcsIGl0IHNob3VsZCBiZSBP
SyB0byBza2lwIHRkeF9yZXNldF9tZW1vcnkoKSAob3IgYmV0dGVyDQp0bykgd2hlbiBwcmVzZXJ2
ZV9jb250ZXh0IGlzIG9uLiAgVGhlIHNlY29uZCBrZXJuZWwgc2hvdWxkbid0IHRvdWNoIGZpcnN0
DQprZXJuZWwncyBtZW1vcnkgYW55d2F5IG90aGVyd2lzZSBpdCBtYXkgY29ycnVwdCB0aGUgZmly
c3Qga2VybmVsIHN0YXRlIChpZiBpdA0KZG9lcyB0aGlzIG1hbGljaW91c2x5IG9yIGFjY2lkZW50
YWxseSwgdGhlbiB0aGUgZmlyc3Qga2VybmVsIGlzbid0IGd1YXJhbnRlZWQgdG8NCndvcmsgYW55
d2F5KS4gwqANCg0KSW4gZmFjdCwgaWYgd2UgZG8gdGR4X3Jlc2V0X21lbW9yeSgpIHdoZW4gcHJl
c2VydmVfbWVtb3J5IGlzIG9uLCB3ZSB3aWxsIG5lZWQgdG8NCmRvIGFkZGl0aW9uYWwgdGhpbmdz
IHRvIG1hcmsgVERYIGFzIGRlYWQgb3RoZXJ3aXNlIGFmdGVyIGp1bXBpbmcgYmFjayBvdGhlcg0K
a2VybmVsIGNvZGUgd2lsbCBzdGlsbCBiZWxpZXZlIFREWCBpcyBhbGl2ZSBhbmQgY29udGludWUg
dG8gdXNlIFREWC4NCg0KSSdsbCBkbyB0aGlzIGlmIEkgZG9uJ3QgaGVhciBvYmplY3Rpb24gZnJv
bSBvdGhlciBwZW9wbGUuIMKgDQoNClNvbWV0aGluZyBsaWtlIGJlbG93Pw0KDQpkaWZmIC0tZ2l0
IGEvYXJjaC94ODYva2VybmVsL21hY2hpbmVfa2V4ZWNfNjQuYw0KYi9hcmNoL3g4Ni9rZXJuZWwv
bWFjaGluZV9rZXhlY182NC5jDQppbmRleCAwM2Q5Njg5ZWY4MDguLjczZWQwMTM2MDQwOCAxMDA2
NDQNCi0tLSBhL2FyY2gveDg2L2tlcm5lbC9tYWNoaW5lX2tleGVjXzY0LmMNCisrKyBiL2FyY2gv
eDg2L2tlcm5lbC9tYWNoaW5lX2tleGVjXzY0LmMNCkBAIC0zMDcsMTIgKzMwNywxOCBAQCB2b2lk
IG1hY2hpbmVfa2V4ZWMoc3RydWN0IGtpbWFnZSAqaW1hZ2UpDQogICAgICAgICAqIGFsbCBURFgg
cHJpdmF0ZSBwYWdlcyBuZWVkIHRvIGJlIGNvbnZlcnRlZCBiYWNrIHRvIG5vcm1hbA0KICAgICAg
ICAgKiBiZWZvcmUgYm9vdGluZyB0byB0aGUgbmV3IGtlcm5lbCwgb3RoZXJ3aXNlIHRoZSBuZXcg
a2VybmVsDQogICAgICAgICAqIG1heSBnZXQgdW5leHBlY3RlZCBtYWNoaW5lIGNoZWNrLg0KKyAg
ICAgICAgKg0KKyAgICAgICAgKiBCdXQgc2tpcCB0aGlzIHdoZW4gcHJlc2VydmVfY29udGV4dCBp
cyBvbi4gIFRoZSBzZWNvbmQga2VybmVsDQorICAgICAgICAqIHNob3VsZG4ndCB0b3VjaCB0aGUg
Zmlyc3Qga2VybmVsJ3MgbWVtb3J5IGFueXdheS4gIFNraXBwaW5nDQorICAgICAgICAqIHRoaXMg
YWxzbyBhdm9pZHMga2lsbGluZyBURFggaW4gdGhlIGZpcnN0IGtlcm5lbCwgd2hpY2ggd291bGQN
CisgICAgICAgICogcmVxdWlyZSBtb3JlIGNvbXBsaWNhdGVkIGhhbmRsaW5nLg0KICAgICAgICAg
Ki8NCi0gICAgICAgdGR4X3Jlc2V0X21lbW9yeSgpOw0KLQ0KICNpZmRlZiBDT05GSUdfS0VYRUNf
SlVNUA0KICAgICAgICBpZiAoaW1hZ2UtPnByZXNlcnZlX2NvbnRleHQpDQogICAgICAgICAgICAg
ICAgc2F2ZV9wcm9jZXNzb3Jfc3RhdGUoKTsNCisgICAgICAgZWxzZQ0KKyNlbHNlDQorICAgICAg
IHRkeF9yZXNldF9tZW1vcnkoKTsNCiAjZW5kaWYNCg0KDQo=
