Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36FD966233A
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 11:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbjAIKal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 05:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234135AbjAIKaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 05:30:39 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDFF1A0;
        Mon,  9 Jan 2023 02:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673260238; x=1704796238;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DGRqP9WiHpEhwpWC2BJUlwJ8/w2lI+1XEaDMuTcyevA=;
  b=Md31xzCWlJOb+QoFvLa0MyCBBqRdjMASLcteXbtuxxqRjocoUE14Qv96
   UTDktTudDdG78hDq/dbLXplrjtUMcFsEqMA0DzcuwExKfcm/beYa4On5e
   XT/l59jCxv8gmAcUxzr7VeoAobjKFBSA1fF3eF4VrfXADL5RRJQLzfjl/
   UsduzaLOwmwc7sFT+6jduZYvmoXZgsqgBubjzlh+g1QMWBXB9GFk0Zpe6
   Spn0WSAqCLwiZDq4ZkUQaT3tyDpYOfM7q5AJtHO14Wgq7zyuYys2aN/2C
   /LFfQqOKpjrHWm0Hw2Tn2wlHgzR912IPLZjbK6SFdcJVB3eGWzAd5C4ma
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="409087451"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="409087451"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 02:30:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="780639839"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="780639839"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 09 Jan 2023 02:30:37 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 02:30:37 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 02:30:37 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 02:30:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LS5mJ5eK/dfD5+8vAj19nacCaijOeJTPXYAQWIOcJZyucgQFK7cVc7A70qDW9suRJ9IulfpIZQ1IWlpWQHyAGhNHv9uIm7pWWUllubH0Z4SnSXmxdXD5hUUlgChK1/1jDEF7naMsUmj1N1FzIWmxwadLX2OFDNHIYrUTjnzLz5fIgms6GnE1Bs0pB7DY540/Mbku+PJgHS3wdFiAAQgIzt95Vq6jrg81wrF0/P4an5EAu/5RPCu0cfhnba4wagRUEq7oA5CmdPyh+nVXzylNEY/uDTA0dRc5ePkFrv4GnXr6Esqx5S4MWOjMTROhbrkMkOkhf/JiGWiSx2h+2stn9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DGRqP9WiHpEhwpWC2BJUlwJ8/w2lI+1XEaDMuTcyevA=;
 b=DSu2Goo0/Q3Aj0nxaWuZe87bVlzmqeLXXYGFni8YtGi+ypPBUYxvnuNXn1nAwZVghsOPfaffSHiejnfQbJCjcRuMkD8NmEs37UeusRAjhuQ8prtbxH/ynELfc+SUE66LGaKz2oOBs4dfDdh4ALdA90P5pPcgtCn3YQ1Qn5AFOS+XsxMx3uN/xHhsYijzmWcTIQ880A0wIoPSmVLQI5dwX0CUhyIBDSWPV7sMue6lSk4s/NDRP5yZLpdLJXDn6GNUFziACieX0B4Kj/qJd6kIA3WwLgMvNWXCXulLjvUaPVnUeDfSBLkxKaM6cwiVX0Bsr6MHf2snSKQkT0Zj980TBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6740.namprd11.prod.outlook.com (2603:10b6:303:209::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Mon, 9 Jan
 2023 10:30:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 10:30:31 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 05/16] x86/virt/tdx: Implement functions to make
 SEAMCALL
Thread-Topic: [PATCH v8 05/16] x86/virt/tdx: Implement functions to make
 SEAMCALL
Thread-Index: AQHZC5gBhP4MskCMgUamnF7j/XSss66R0bGAgARB6QA=
Date:   Mon, 9 Jan 2023 10:30:31 +0000
Message-ID: <e6296f511bb4fae4696ec19d5777103044f3aad9.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <d74565e3f71b6e5e5183f3b736222ec42b6e0b81.1670566861.git.kai.huang@intel.com>
         <61b9cc00-d514-df77-0a31-88ec35d73456@intel.com>
In-Reply-To: <61b9cc00-d514-df77-0a31-88ec35d73456@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB6740:EE_
x-ms-office365-filtering-correlation-id: 3516fd96-13e1-4be3-71a8-08daf22c8908
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BXUyoInG6iQjJg+MhpjSYXVNo+V1md/kDbq/InhL4AJMe0Wauy4XP7fQzgEHTattELZT9JrKEJueXbsdw5f3XGRGWwsxRwYp5GgPFfDmzcAYoc7G2/8EBjcMHxZ1PYgx/GZshbOwyd6k/c5aL97OiFuLOTYnHfnMcUTHKBt/2u2Nos2eQgXeerJ3KPyMvZW425XBdHJHEH5x5n7F2/X2rwETKP7B/I1cPk8aYazbnW+2AW99Mf2YvFes5nP9ktlvGPmRlI3hr3oEX7gcFpCkZZHdhe/Zb5oVWuckwZfvhlJxWGdHIJ/q+oX+R70NzIg5DlGNwrpIl/16aOkOi+Jux+pyjjOgcIRE8f7nxiU2Siy8zlGYdCfNHDMtORjzl4zFZCNlC4X5JdDX9RDAYqiuFoQ1oSKa37Qj+xqAKuxm2Op/xQzYgKHWoGksB42TAN4zXsQ9A9BDu9VD2bjzRRrC6cEBXhGsRXMKKfrCnRJ7/3MxtqlWgCwA8gz7W7eoV1ub0zsUMHR1o/wAzpn+rWXP212axB/YjbBOBn1Pa9khaSlMvjQq51UUw3eTVPZC2ggjX/L6m9e+aMkNrXTKeRZsvrBijOT2yk6sHkXDdZgU/ji2N8hYyg/XML4a1+wR+jgqm4e14g7uTjHlqmgvPLd33VLyXO61mz3SuBGeu78/qVWi3vSU/PAvIqO2YfAgWtwThV/jlgXz9QcBRYF0kNgSAw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199015)(41300700001)(66946007)(8936002)(76116006)(316002)(8676002)(91956017)(110136005)(7416002)(54906003)(2906002)(64756008)(4326008)(5660300002)(71200400001)(6506007)(66476007)(478600001)(66446008)(6486002)(66556008)(86362001)(26005)(186003)(2616005)(38100700002)(36756003)(38070700005)(122000001)(82960400001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aEJTNGVldjdBa1luYlVubTFQT09mTUFUMkpFbzRCM1hCZmdYcGppRGM0YTZI?=
 =?utf-8?B?bm5xa2lWSDd3U1JVOVZRdE5aS21sOUM0cUVkR3J6UEFST0ZFaWVGSGEvaE1F?=
 =?utf-8?B?Tjc4dE1qQ1FmK0Rya2hENU1MZkxIZ25ZdlYwNk1hVGpmU29HMHp0NStPdGZs?=
 =?utf-8?B?R2dHa1NORnBZZ2hkSitnclJHeTNKaTFXaGcyTGZUVE0zcnRMZDV5clVzUE92?=
 =?utf-8?B?ZTVjRnF1SVU5TTR4N3dyK29YZ1kyVXNUeU1tZE54bUVXZTg0R0VwR0FQUFJE?=
 =?utf-8?B?cThDTUZtYlNER2VoRDc2amNzLzJwMnRLc3BRdXV0dnZPWEprRDlNOWdPMjI0?=
 =?utf-8?B?NEpHTVltSG1oVGcwRHY0d0J4b3hkdjBTZndKSVhqU1RZclI4Tmk4MU0zZm9P?=
 =?utf-8?B?SVpWQjQ3QzVpc0VGdFZGMng1MDZCMkN6cGFrbjFKTW5xRC9iOEhVZ1A1M05U?=
 =?utf-8?B?eVFPZy9EVzUyNktibXJCcStJUUY3c21JcGJOUmpMallXeFVxU2g0SENqZDlj?=
 =?utf-8?B?QVY1T1loa3Nubm1XcExnT2p6dVF3WmIxcFdOcE8wUmZYWmJ4Q2FPMGlYaW4x?=
 =?utf-8?B?RFAwUnczZWc2RDNSMnYzVUgyOWtqaGpUMnBoRzFiWld5czJkMUk0UUhPTEdB?=
 =?utf-8?B?ZHJDVXBWYUVENFh3eUE1WHhwQjdJU0d6Q0VraDkvYy9LNnF5SHlPT2ZkNFJM?=
 =?utf-8?B?azNPN0pWdW9GUHl3NjFXUHQvcWRCZ1pNcjlzazdESmdCMmZwdjhqMkxNVDJR?=
 =?utf-8?B?RW5HREJiTysrMHVQbUhKTXFCZ1U4dzZUS2duYzlSUFgrZlNMUVp5VzQ3aVFG?=
 =?utf-8?B?VndaU1RPTmh3S3hyWk9Wank2eGt6VTBMTUdyWW9Gc0luOXo2NG9xVHdzRWpG?=
 =?utf-8?B?YnpnWGRhZkRDcHUzdlByNUxzNVl3cjBRTkgrZ3cvNnZwNkZzSUhIMU1VWjlH?=
 =?utf-8?B?Zk1oaHJjWHIxbGNMdnM4dHRKeDR6ZTlvNFZqWEtNOGlxZlk0dGk0eUovUzZp?=
 =?utf-8?B?NUp4Mml5L25YNCtEYytDL2JObHVYS2dXaDNVOTlEc0NtRVZzWGdPOGFSOU1Z?=
 =?utf-8?B?ZVJKSGZWK2EzRXJhY1VCK0NrbnlWK0VzN2x1NitRT2laUC8vRWltaFVDVERk?=
 =?utf-8?B?SWpjQ2FUV2ZLSGNDcURFcTF5YVdGalQvb3ZBN0tzUnU0Q1Q0Z1VJWHZTVnha?=
 =?utf-8?B?OXJqekU2dEtYdnBaWDJNM0phdWRRZ2ZqaFFqV0psMDI0dEdKeDVSeFRqZm5t?=
 =?utf-8?B?S3lxRlFJYnlkNWRmaTlGcnJzdlRDS01jdTU5Sk96VHlLSEhXdFZ0VkJsbHlq?=
 =?utf-8?B?QjZ3NDY5NDVUKzd0TitFeGozMXFMZ0NDN0RRQkh5RHNScVR4QitXUTFTdGIr?=
 =?utf-8?B?YjBTcHVQR2d6d0xDNkN0djJ3R1NpbEZ6QjVqWTFDQ3NlMWNOY3dlMFZmZHhz?=
 =?utf-8?B?VjlzUHBWaUJVbmxxb1RaRWt4MFVZdkpVajM5Zkx6aXBDQWZjSEJodGF2dWxx?=
 =?utf-8?B?bUcyVXpuT05IeVQxOUdMR2dNUzlTb1FrSzRYZUZYNWxpYTZDTUswdjloR2th?=
 =?utf-8?B?emxSN2RqQTJvVW1qS2MxSWVCVWtZVXBMQVpHWVFyOW0zYytielZEMEVXWHll?=
 =?utf-8?B?WFBCeC9taXptZnF5UmZzTTBRaEF2dEh4WHhIaWthM0VkQ29pVXZjZ1N2YmZj?=
 =?utf-8?B?c3VQVTlaRVZDMW1neVRJTUZoQUVXSUFtNGZ0U3VmVkhjQUE1YzcrSUZoYTBn?=
 =?utf-8?B?UHZ0TGVHakRUSlNFUFh6Z1l4bTUzV1V2aHpiSk9HTFhWVGZZQnY1Z0E2Z2pC?=
 =?utf-8?B?S0grK3ZFY0xYVlNyMDQzbVhQU0ZvbmVwR2JCanoyQng2NUt4L0RvSUVZMHNJ?=
 =?utf-8?B?YkRsK0JaOE42cGFEdXEwdHhwdFg4MFd5RXpVM2dYOHJVMU5UWnYyazAwTXRQ?=
 =?utf-8?B?TUpvZWF1dGZYK0NXblNMVUF3RERoZDNaQTNiNko4dS8wYnJQdlhMQ2FEWDls?=
 =?utf-8?B?bGFZVUFiRHlTeGZRdDcwYkNsM1RWdkxENUZGaU9hRmVUWEsvUXhYMFNMVGM5?=
 =?utf-8?B?QjRjNXVnVlB0Z2daM0ZyS3Q4Z0pua1pySUMvdFVMb0s4VFR6SExjNFNEams2?=
 =?utf-8?B?Vm9CNUZMR0pvdjJiR1cyRmpkaHF5RytwRERybldveSswbE1HWWJ5RkdEQXpl?=
 =?utf-8?B?dVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E56BCA3D53F08940BEB9A7A327E80674@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3516fd96-13e1-4be3-71a8-08daf22c8908
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 10:30:31.7548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6d/KFqWNQlJa2yTgyKNPL2BEje1YyPQ1MpYeLnRc91ss7DjiNf4UVFquPMR7nV1j8uKaGRwOTWqqXeLZaf+bAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6740
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTAxLTA2IGF0IDA5OjI5IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
VGhlIHN1YmplY3QgaGVyZSBpcyBhIGJpdCB0b28gc3BlY2lmaWMuICBUaGlzIHBhdGNoIGlzbid0
IGp1c3QNCj4gImltcGxlbWVudGluZyBmdW5jdGlvbnMiLiAgVGhlcmUgYXJlIG1vcmUgdGhhbiBq
dXN0IGZ1bmN0aW9ucyBoZXJlLiAgVGhlDQo+IGJlc3Qgc3ViamVjdCBpcyBwcm9iYWJseToNCj4g
DQo+IAlBZGQgU0VBTUNBTEwgaW5mcmFzdHJ1Y3R1cmUNCg0KWWVzIHRoaXMgaXMgYmV0dGVyLiAg
VGhhbmtzLg0KDQo+IA0KPiBCdXQgdGhhdCdzIHJhdGhlciBnZW5lcmljIGJ5IG5lY2Vzc2l0eSBi
ZWNhdXNlIHRoaXMgcGF0Y2ggZG9lcyBzZXZlcmFsDQo+IF9kaWZmZXJlbnRfIGxvZ2ljYWwgdGhp
bmdzOg0KPiANCj4gICogV3JhcCBURFhfTU9EVUxFX0NBTEwgc28gaXQgY2FuIGJlIHVzZWQgZm9y
IFNFQU1DQUxMcyB3aXRoIGhvc3Q9MQ0KPiAgKiBBZGQgaGFuZGxpbmcgdG8gVERYX01PRFVMRV9D
QUxMIHRvIGFsbG93IGl0IHRvIGhhbmRsZSBzcGVjaWZpY2FsbHkNCj4gICAgaG9zdC1zaWRlIGVy
cm9yIGNvbmRpdGlvbnMNCj4gICogQWRkIGhpZ2gtbGV2ZWwgc2VhbWNhbGwoKSBmdW5jdGlvbiB3
aXRoIGFjdHVhbCBlcnJvciBoYW5kbGluZw0KPiANCj4gSXQncyBwcm9iYWJseSBhbHNvIHdvcnRo
IG5vdGluZyB0aGF0IHRoZSBjb2RlIHRoYXQgYWxsb3dzICJob3N0PTEiIHRvIGJlDQo+IHBhc3Nl
ZCB0byBURFhfTU9EVUxFX0NBTEwgaXMgZGVhZCBjb2RlIGluIG1haW5saW5lIHJpZ2h0IG5vdy4g
IEl0DQo+IHByb2JhYmx5IHNob3VsZG4ndCBoYXZlIGJlZW4gbWVyZ2VkIHRoaXMgd2F5LCBidXQg
b2ggd2VsbC4NCj4gDQo+IEkgZG9uJ3Qga25vdyB0aGF0IHlvdSByZWFsbHkgX25lZWRfIHRvIHNw
bGl0IHRoaXMgdXAsIGJ1dCBJJ20ganVzdA0KPiBwb2ludGluZyBvdXQgdGhhdCBtYXNoaW5nIHRo
cmVlIGRpZmZlcmVudCBsb2dpY2FsIHRoaW5ncyB0b2dldGhlciBtYWtlcw0KPiBpdCBoYXJkIHRv
IHdyaXRlIGEgY29oZXJlbnQgU3ViamVjdC4gIEJ1dCwgSSd2ZSBzZWVuIHdvcnNlLg0KDQpBZ3Jl
ZWQuDQoNClRvIG1lIHNlZW1zICJBZGQgU0VBTUNBTEwgaW5mcmFzdHJ1Y3R1cmUiIGlzIGdvb2Qg
ZW5vdWdoLCBidXQgSSBjYW4gc3BsaXQgdXAgaWYNCnlvdSB3YW50IG1lIHRvLg0K
