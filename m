Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF82D73AD7A
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 01:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjFVXxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 19:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjFVXxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 19:53:03 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C002128;
        Thu, 22 Jun 2023 16:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687477982; x=1719013982;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=V7HNqAk4uZmoSu1pAChAeSOb/8VeZ54x4hPZBYAZp24=;
  b=QOFiK4uP4auSu06F1tQaps+hLjMrl2NvcTJnGmDA2bRGa0x2dPJ9nYae
   /fh65jU3biUkWXG2DMFYqSpOkjLiMKHZmcuYhVoqoKcG/95USVwfoRA3K
   mXE5xEYpgLhnUWbH2fkLYcRs5q9qjY09paiLBUiUj87MyQDEbova036Dk
   TejxL8n9x9ebga+R4xC3ILckGsw7EIx9BoT0ZH3u77wNLY2AbefNkjXkp
   IWNJDk9kKtRwzeiPGmhXybRouamVe/3bPzcfjjkRuS38aTpcMeb6E0ah3
   x7FVZWUEzxPDfFpSx8NshjjgaoT4+PEZ7T9PstnOmLxj/N0iAmNyKNopL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="390517711"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="390517711"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 16:53:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="715125054"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="715125054"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 22 Jun 2023 16:53:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 22 Jun 2023 16:52:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 22 Jun 2023 16:52:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 22 Jun 2023 16:52:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndJSjhLmN0bMgDjZuf+jHlO4YbuYYHgIqPZp61inKJCKv4ODQXvxrIesY/DFxYVrZj+JwhkRWpx4BJbLIrdz4RIDj88S2HMbZPwYUKUfUXbGjN1R38LIUfC8GEA5dfM3Il5G0Kv/pQANB6g2kURwoH6wmCjGfm0xvKvKPIHGlQosYdkrLJmSM4ut4tSL5yzMvbsCNiN8A2pO+bgA4rTWmKdKg6DgqYAwJowV+uhlDH9yJQBBAjK5Kaqpg1qGxJ1C2Qhpk4SpDFaZ3d8sh0Xki+xMouwIrpuHzm+KWoHIVi/uR9VDmE4cd+INH9O1t6XlmYVWw6Z9tdoxur3uftY1RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V7HNqAk4uZmoSu1pAChAeSOb/8VeZ54x4hPZBYAZp24=;
 b=S89pn2HYKcGUTq76g7ZFtKNdpJxiPBKNxNtYo5tdUbNgro9xglNWm8ASXzNdU8iFUCeROglweGlASJcht2/0e6LHBHyopiKI7N7bWDMeMVekuAOzVd760kVblLHfFMMIaJSUpb5dzvw8CK8qKw4UpMCpyC+lYHVXyZ3g2akik8FT5NerxIslWQ7cLi4xvGKk9mwoiOoRtGxfj20PKXclut4/m8r8zIGrA/h55G36RQNawaT+ML6dZ59lareUJ7vRU+6uESzGOrUmxes4FWyxFTfX2j2I178LBFbB0APGgaWPyNvC9CHd6S/6WtTdNJT8NBP3zZi1XAOGWa3J5mynbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7856.namprd11.prod.outlook.com (2603:10b6:208:3f5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Thu, 22 Jun
 2023 23:52:56 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 22 Jun 2023
 23:52:56 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "liam.merwick@oracle.com" <liam.merwick@oracle.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pgonda@google.com" <pgonda@google.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "Annapurve, Vishal" <vannapurve@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "nikunj.dadhania@amd.com" <nikunj.dadhania@amd.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH RFC v9 04/51] KVM: x86: Determine shared/private faults
 using a configurable mask
Thread-Topic: [PATCH RFC v9 04/51] KVM: x86: Determine shared/private faults
 using a configurable mask
Thread-Index: AQHZnOphA4hNJcIpGkeiRJNqOV8fuK+KheOAgAmr4oCAAA39gIABrsSAgAC28gCAAF41gIAAdPYAgAAS/wCAAAPagA==
Date:   Thu, 22 Jun 2023 23:52:56 +0000
Message-ID: <5ec0664fe81df54019ef5934f2dc6dfadf1d649c.camel@intel.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
         <20230612042559.375660-5-michael.roth@amd.com>
         <20230614164709.GT2244082@ls.amr.corp.intel.com>
         <20230620202841.7qizls3u3kcck45g@amd.com>
         <20230620211845.GV2244082@ls.amr.corp.intel.com>
         <20230621230031.37hdnymbjzwjgbo2@amd.com>
         <c116b7ab8ca02116f2b8d19a8214161c3b30576c.camel@intel.com>
         <20230622153229.vjkrzi6rgiolstns@amd.com>
         <25037dfe969698dd109daee8c6dbe0d08a874a08.camel@intel.com>
         <20230622233906.GA3436214@ls.amr.corp.intel.com>
In-Reply-To: <20230622233906.GA3436214@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB7856:EE_
x-ms-office365-filtering-correlation-id: 82c51b43-22fa-48ab-433d-08db737bcd36
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WwCIoVNsRFobf3A0E27oaQT35u3xuFdhRtNGC8ptzxeorQEPTHEZ4agave58Iaf+8OhsjxncoY+Y4OJ1YcDoycvgFiXl3Pv5ngjmQX4I0fduWn6AtNYqASNiShTxlIGfTDpBJz685ctAbOOkdI//0Q3LNXlDGz7s/qmkvcZDQyeq/3z+ChXdNyvgZzYzQ69xOa+LclwqsUulBQzPnDdVqUqrcK8d3jgBc8gEK12wxr85PTUAPDN9lLi0zQx0hjZy1Y4Uri6QxQgiLDnoIVgR+f+RYyBS0NkPOdLguvc6V6MUMlRxeYYbQNLzhtO+hR2v6aqOoKGE9K5DuJBjkpITn6BMR/88+LQ9qbJ6VbOzbt3VdRLocD3pX5nALUhsfwR8ZoUwGxhnkinWOkA/A6az5sRBeBBP8z7ln5g1mldOpxb2yas+4xXIX7zzi8PPG/TLzr1Ua2od/ia2TDsQlxL2y4EO94+c4AdtA6LwNVtyjyc24FuZ73w7luDPZEOI5IO/bmeKCt5ijs4iUG34QkehGFxaxV/dFcDMGolR3llCQMp4uIwVb6SOAnysRBZFtjp+xeUYALOaGMyQ5ccRV+jv8xZ1COo2FVVWUvIWRFsCSGD17lveZH0QHs8XQXR0GE3l
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199021)(6486002)(38100700002)(186003)(6506007)(36756003)(6512007)(71200400001)(2616005)(122000001)(91956017)(66446008)(66476007)(76116006)(316002)(6916009)(4326008)(64756008)(38070700005)(66556008)(66946007)(2906002)(7416002)(26005)(8676002)(8936002)(86362001)(5660300002)(54906003)(41300700001)(7406005)(82960400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eVRMZk9ERjk0cVgvZFV6TXl2UnI4b3NXVTBQQ1hzQ0RMbU9WWHpWMXAxb3Zx?=
 =?utf-8?B?QnRzOFlEdWR2a2ZlYTlZT05uKzRWdklFSFJlbTJlaDgrcUVpVm5VN2tCYjNC?=
 =?utf-8?B?QVBOcFVCdytnQ2NoTHlVcTB3R1hqRGFyYWVZeVpaeVVFSHdjSFNZaVZPSFU2?=
 =?utf-8?B?a2lZSHVaL1B6QTRmUkYwdlVrSEU2TnlkMUdTSGpoczlNUHAvZXlvbjlOWHcr?=
 =?utf-8?B?VjFvOU1WQ1plYUR6UWJPVStvRDlPamRkdHJ0Nm9wVlVCMjZuRUVYaGZNMVRp?=
 =?utf-8?B?ZHJaUkpTVkFkUzBMK2VTVFZndWtJN2FFNUxZNjJJL21lUEVpakZHczZsWGxS?=
 =?utf-8?B?UitFY3Q1UHd2d0tEYkZ6QVNkcklST09LQUtTRU90bEhkSTllWEYzVzNQRnhH?=
 =?utf-8?B?TXNMSGhyRmptS0lRR0F2aiswS05lRnNha2c1UDhlVks1ZjhQNTJkTTM0K2FF?=
 =?utf-8?B?VG9RUlRHN3FpMDZMbWVQaExBWWpaR1AzUGVjZ3F6a0JnZ2FOVkZHak5nN21Q?=
 =?utf-8?B?cXdOb25vVisvTUtWOFpiTEdCZVJUVTZ1dFg5OE9nbUpVMHlWSE5UTnhRaU1j?=
 =?utf-8?B?ai80MjhvY0VtL0dCNi9JZGkyWEhxWno4NThaSlFtY3Z5MUxTT2xZOUhXeGVu?=
 =?utf-8?B?bWlsMU82OWJBbDJhN05PT2JGWFlJcnBQZ2VqQzhyeUVBbjB1R2RqODlNMm4r?=
 =?utf-8?B?dENnYnJIZGZHbVI4bzdTT24wZy9EY1Z5NjNtUTF0QmtjSkRTNnlGQ2hhT3pP?=
 =?utf-8?B?NzhlWFJNQlFVc0NtZ0xsSGRDYmdXVUtqbjhpL3UrUy9jeXhoSWNpcDBBZlNS?=
 =?utf-8?B?Y0VpeUdpSnM1a1ZZZnZSSnpWNEI1dk5RTW5IU1gxUTNtcTlmR1ZOQUIybzE3?=
 =?utf-8?B?T05oQ1BEU0FmamdDYjRCTkV3cXNidDBXbDlyMGpPY09hY0xMeDJ6aTZsb1l2?=
 =?utf-8?B?QkRsUDZzZnRWbVIvblFmU2Rkb0NHU2tzNzNCMVV5UFlGY0lxRTZQY1BnR0ph?=
 =?utf-8?B?aXBDd1dyM0liZ01aS1loNHVkam50V0xMN1dkZFB4ZzMrQ3o2VUdCMUVZcU10?=
 =?utf-8?B?cmUxNjdOKzR5dE5WMGNiMjFXTS9pQml6VDBEUHV4YXVIeDdCWU5pczk2Z05z?=
 =?utf-8?B?ZDBFTlM1b05BcVlNU0F0NjVZYnVETTMvMnE2SmlQcmU2clFVTkRlTnpIK3Rk?=
 =?utf-8?B?SzgydDFld1lRUm5NZXB1QWVidTVPUkhKYmRtN1NzYzZvVkhqTjNKMEJ4Tm9E?=
 =?utf-8?B?M09COUxoeVVKZ3l5VzkwY1ZTSmpkdkZHWVhLMkd4ajJxOEVJbUdpNkZ5eW4v?=
 =?utf-8?B?eHhoYTZqWjNEV01JZ2k1blBXWjBDK1FWLzRHLzJlNzY2UER5TEREWDNDUDBl?=
 =?utf-8?B?ajEzMklwbzh0WmsxbC9JSitEZzlQcjhqSCttOFpoZkpxNmpHTERLVm1NNzBo?=
 =?utf-8?B?YnlCUnVDQlBoSzdXNHMyYXZRc2ZGNGhaMGdkN2FLU3dIbWJnZHplK0ZtWFVN?=
 =?utf-8?B?Y0VERWNPMldZakc1UWxVZXk3SHhRZlpmaVZ6YlZnUWlyNm5oc0QvaFBGeVVM?=
 =?utf-8?B?NVFTUVFqSHZ1ZVFYMVkyMlpHOE8zYlVnd0Uvamh0NVJTSTA3NFRUUlZHbmRK?=
 =?utf-8?B?Vi83czN4SEo1Vk82akdGYitlaUN0Z0FGa0lJdDQxY0U1WHBYdWhhY3E0eG5N?=
 =?utf-8?B?dlFjajUvOUlCeTBWNUYvV1cvVHFMTVE1Q2lkZHlaa1VwSWIwL2QvV2tyZ012?=
 =?utf-8?B?UmlNSlZlM2wySE5QdGc1UG1tTDk4SE1Edno2czZRZGlDak92bUNGL0lWVnh6?=
 =?utf-8?B?MmQrQk1GRjEwU001YVdBUkdYeFg1SFd6RHNBelRtRjVIblZJOEtsWTRsTjJ4?=
 =?utf-8?B?YmZuOHp5UFFGdHMwV2Q1a09VRFRqcHNxRENzem9oU1J0NEdFb0lPZGxRbStY?=
 =?utf-8?B?Q3g2T2Q1azVsVzY4M0N1ZE9uM2hTbmV6WVhZcDlFOU5NT0lZTTg3SFNlRzkw?=
 =?utf-8?B?L1o0ZHRkUWtKSFh4aGJpQ0thcVk4R1hlWnQxblJZSXY5YUo4d0wwc09KM1Fv?=
 =?utf-8?B?eVZraHFtUllzc3dEdld5UTg4dml1MHpnOTNGYm5EMmtKdmE5Wmo2MmcxcTRC?=
 =?utf-8?B?bjBDS01ZcEJVVUV2bXl1OXhLV2YyK0JZRjZncDVUdzN6c1ErbzJ0Y1Z0UTA2?=
 =?utf-8?B?OWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C7D4A702FC6F24FBD9AF607D28A8459@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82c51b43-22fa-48ab-433d-08db737bcd36
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2023 23:52:56.4043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SxkcGMZcBuseacTJBiveMueEwaIccN0BF+SovdIDwYqSAbPIoypfJQMdGTQeSogZUYEtw2BC1/x61t2OBExFoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7856
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA2LTIyIGF0IDE2OjM5IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gVGh1LCBKdW4gMjIsIDIwMjMgYXQgMTA6MzE6MDhQTSArMDAwMCwNCj4gIkh1YW5nLCBL
YWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gPiBJZiB0aGVyZSBhcmUg
YmV0dGVyIHdheXMgdG8gaGFuZGxlICpob3cqDQo+ID4gPiB0aGF0J3MgZG9uZSBJIGRvbid0IGhh
dmUgYW55IGNvbXBsYWludHMgdGhlcmUsIGJ1dCBtb3ZpbmcvYWRkaW5nIGJpdHMNCj4gPiA+IHRv
IEdQQS9lcnJvcl9mbGFncyBhZnRlciBmYXVsdCB0aW1lIGp1c3Qgc2VlbXMgdW5lY2Vzc2FyeSB0
byBtZSB3aGVuDQo+ID4gPiBmYXVsdC0+aXNfcHJpdmF0ZSBmaWVsZCBjYW4gc2VydmUgdGhhdCBw
dXJwb3NlIGp1c3QgYXMgd2VsbC4NCj4gPiANCj4gPiBQZXJoYXBzIHlvdSBtaXNzZWQgbXkgcG9p
bnQuICBNeSBwb2ludCBpcyBhcmNoLm1tdV9wcml2YXRlX2ZhdWx0X21hc2sgYW5kDQo+ID4gYXJj
aC5nZm5fc2hhcmVkX21hc2sgc2VlbSByZWR1bmRhbnQgYmVjYXVzZSB0aGUgbG9naWMgYXJvdW5k
IHRoZW0gYXJlIGV4YWN0bHkNCj4gPiB0aGUgc2FtZS4gIEkgZG8gYmVsaWV2ZSB3ZSBzaG91bGQg
aGF2ZSBmYXVsdC0+aXNfcHJpdmF0ZSBwYXNzaW5nIHRvIHRoZSBjb21tb24NCj4gPiBNTVUgY29k
ZS4NCj4gPiANCj4gPiBJbiBmYWN0LCBub3cgSSBhbSB3b25kZXJpbmcgd2h5IHdlIG5lZWQgdG8g
aGF2ZSAibW11X3ByaXZhdGVfZmF1bHRfbWFzayIgYW5kDQo+ID4gImdmbl9zaGFyZWRfbWFzayIg
aW4gX2NvbW1vbl8gS1ZNIE1NVSBjb2RlLiAgV2UgYWxyZWFkeSBoYXZlIGVub3VnaCBtZWNoYW5p
c20gaW4NCj4gPiBLVk0gY29tbW9uIGNvZGU6DQo+ID4gDQo+ID4gICAxKSBmYXVsdC0+aXNfcHJp
dmF0ZQ0KPiA+ICAgMikga3ZtX21tdV9wYWdlX3JvbGUucHJpdmF0ZQ0KPiA+ICAgMykgYW4gWGFy
cmF5IHRvIHRlbGwgd2hldGhlciBhIEdGTiBpcyBwcml2YXRlIG9yIHNoYXJlZA0KPiA+IA0KPiA+
IEkgYW0gbm90IGNvbnZpbmNlZCB0aGF0IHdlIG5lZWQgdG8gaGF2ZSAibW11X3ByaXZhdGVfZmF1
bHRfbWFzayIgYW5kDQo+ID4gImdmbl9zaGFyZWRfbWFzayIgaW4gY29tbW9uIEtWTSBNTVUgY29k
ZS4gIEluc3RlYWQsIHRoZXkgY2FuIGJlIGluIEFNRCBhbmQNCj4gPiBJbnRlbCdzIHZlbmRvciBj
b2RlLg0KPiA+IA0KPiA+IE1heWJlIGl0IG1ha2VzIHNlbnNlIHRvIGhhdmUgImdmbl9zaGFyZWRf
bWFzayIgaW4gdGhlIEtWTSBjb21tb24gY29kZSBzbyB0aGF0DQo+ID4gdGhlIGZhdWx0IGhhbmRs
ZXIgY2FuIGp1c3Qgc3RyaXAgYXdheSB0aGUgInNoYXJlZCBiaXQiIGF0IHRoZSB2ZXJ5IGJlZ2lu
bmluZyAoYXQNCj4gPiBsZWFzdCBmb3IgVERYKSwgYnV0IGZvciB0aGUgcmVzdCBvZiB0aGUgdGlt
ZSBJIHRoaW5rIHdlIHNob3VsZCBhbHJlYWR5IGhhdmUNCj4gPiBlbm91Z2ggaW5mcmFzdHJ1Y3R1
cmUgdG8gaGFuZGxlIHByaXZhdGUvc2hhcmVkIG1hcHBpbmcuDQo+ID4gDQo+ID4gQnR3LCBvbmUg
bWlub3IgaXNzdWUgaXMsIGlmIEkgcmVjYWxsIGNvcnJlY3RseSwgZm9yIFREWCB0aGUgc2hhcmVk
IGJpdCBtdXN0IGJlDQo+ID4gYXBwbGllZCB0byB0aGUgR0ZOIGZvciBzaGFyZWQgbWFwcGluZyBp
biBub3JtYWwgRVBULiAgSSBndWVzcyBBTUQgZG9lc24ndCBuZWVkDQo+ID4gdGhhdCBmb3Igc2hh
cmVkIG1hcHBpbmcuICBTbyAiZ2ZuX3NoYXJlZF9tYXNrIiBtYXliZSB1c2VmdWwgaW4gdGhpcyBj
YXNlLCBidXQNCj4gPiB3L28gaXQgSSBiZWxpZXZlIHdlIGNhbiBhbHNvIGFjaGlldmUgaW4gYW5v
dGhlciB3YXkgdmlhIHZlbmRvciBjYWxsYmFjay4NCj4gDQo+IA0KPiAiMikga3ZtX21tdV9wYWdl
X3JvbGUucHJpdmF0ZSIgYWJvdmUgaGFzIGRpZmZlcmVudCBtZWFuaW5nLg0KPiANCj4gYSkuIFRo
ZSBmYXVsdCBpcyBwcml2YXRlIG9yIG5vdC4NCj4gYikuIHBhZ2UgdGFibGUgdGhlIGZhdWx0IGhh
bmRsZXIgaXMgd2Fsa2luZyBpcyBwcml2YXRlIG9yIGNvbnZlbnRpb25hbC4NCj4gDQo+IGEuKSBp
cyBjb21tb24gZm9yIFNOUCwgVERYIGFuZCBQUk9URUNURURfVk0uIEl0IG1ha2VzIHNlbnNlIGlu
DQo+IGt2bV9tbXVfZG9fcGFnZV9mYXVsdCgpIGFuZCBfX2t2bV9mYXVsdGluX3BmbigpLiBBZnRl
ciBrdm1fZmF1bHRpbl9wZm4oKSwgdGhlDQo+IGZhdWx0IGhhbmRsZXIgY2FuIG1vc3RseSBmb3Jn
ZXQgaXQgZm9yIFNOUCBhbmQgUFJPVEVDVEVEX1ZNLiAobGFyZ2UgcGFnZQ0KPiBhZGp1c3RtZW50
IG5lZWRzIGl0LCB0aG91Z2guKSBUaGlzIGlzIHdoYXQgd2UncmUgZGlzY3Vzc2luZyBpbiB0aGlz
IHRocmVhZC4NCj4gDQo+IGIuKSBpcyBzcGVjaWZpYyB0byBURFguIFREWCBLVk0gTU1VIGludHJv
ZHVjZXMgb25lIG1vcmUgcGFnZSB0YWJsZS4NCj4gDQo+IA0KDQpJIGRvbid0IGJ1eSB0aGUgbGFz
dCBzZW50ZW5jZS4gIEV2ZW4gaXQncyBub3QgbmVjZXNzYXJpbHkgZm9yIEFNRCBmcm9tDQpoYXJk
d2FyZSdzIHBlcnNwZWN0aXZlLCBidXQgdGhlIGNvbmNlcHQgcmVtYWlucyB0cnVlIGZvciBBTUQg
dG9vLiAgU28gd2h5IGNhbm5vdA0Kd2UgdXNlIGl0IGZvciBBTUQ/DQoNCk5vdGUgInNoYXJlZF9n
Zm5fbWFzayIgYW5kIGt2bV9tbXVfcGFnZV9yb2xlLnByaXZhdGUgaXMga2luZGEgcmVkdW5kYW50
IHRvbywgSQ0KZG8gYmVsaWV2ZSB3ZSBzaG91bGQgYXZvaWQgaW50cm9kdWNpbmcgYSBsb3QgZmll
bGRzIHRvIEtWTSAqY29tbW9uKiBjb2RlIGR1ZSB0bw0KdmVuZG9yIGRpZmZlcmVuY2VzIChpLmUu
LCBpbiB0aGlzIGNhc2UsICJnZm5fc2hhcmVkX21hc2siIGFuZA0KIm1tdV9wcml2YXRlX2ZhdWx0
X21hc2siKS4NCg==
