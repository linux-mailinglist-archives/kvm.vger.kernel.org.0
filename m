Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B688672EFDE
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 01:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239404AbjFMXSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 19:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjFMXSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 19:18:08 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F5B199A;
        Tue, 13 Jun 2023 16:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686698287; x=1718234287;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kcNAwptKSy1mOl71rdPyGErHaiXg7DvH5JzXr8B/Yxc=;
  b=HR9ydCtnYPtLcLmsWCh/g/LyrTLcda5fWHE0BpZITHDTWFF+jeLF5Qwu
   IOe+vdhdsI2ejZMTIEiSzSvCeecxn6CufUTXYDxffj9d0e5pMXEBuHLek
   vz/ekZVpNHVP+HHJkmNZJsAnhEgIJ8QMi2dJvfpBmewxQhZpTq+RWkTH9
   MvPnEfSJeZPdbYa3p62CHpttjxDbMdg8dnzXLMdyofPm3XbUfEMcbBYxi
   hi9V/venkhuBwInpaR0SgMROFss0f4mreJ0ItZi4jiczA6eLUJQj6FZMb
   FDKsLGIppuxKofvcO4GRvzeBsm+bZ54a1OMNBmI+J0DGeYGuQd7G0xQCN
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="338105815"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="338105815"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 16:18:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="1041945807"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="1041945807"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 13 Jun 2023 16:18:06 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 16:18:05 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 16:18:05 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 16:18:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gcf5igZ7+sAlj8LNFbB1sMvqdCdg4tBAtNiR9KTJy9U0ETbH1tRqoqf3dYaegPwk7hDuNGpgpQW2aDtH5L14XZo6NpNDSB3HQgHj0BfaN2Utyt4AJWOLMKHeCIDV1FF0rOa9tFKz1zlUdPc0XfbLdYzkZkSbXyW4tyaRC46vSJ4oBCTRFjQI6AQzlqAQ12o/pqSokTnp3tGbN83DiLHH2Oc8NIHDjjmoi3T4UHBBsHq1t+E9+FjW1WiTvh1lQsLYPs5eEFDHAwEiao7kgxFjeYXnFQceCOwOprshKpDDCElpNKb+mlcE9ZQptCJNlF9zBvIKL6l26Fs77B5W9RU9aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kcNAwptKSy1mOl71rdPyGErHaiXg7DvH5JzXr8B/Yxc=;
 b=Bv2MPgacpBQLa8R44zuyWMoAOmBkMFb4cYi3wKvCDck3MGDD53CZt/Xayd7U5giL49yk1vC9ZiHTNapiRuaZoo2WPGg86rQc5sH3aKSQHzv8gVgHB4biZy/TfP5i/Z3Lri5yo3NYc+sgyboobdh+r4dMjEPNsAM936sXCV0NHfoQXOmFQpaw3o1vYuIl8jmrQdVrHy/VQkdJpOR80wqO2B/xrRvtXC4ZdCOuKeqlUPIHXTyBo8sGJ62r+jSDOcjUQ0A0R9YfoYSQLB7wPqustm5cCW6pk0PF4Eb39+fV+gOkhy0dAux/xczfjH7QtmaJtpPL0J2mSykg4pvTpsVa+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6683.namprd11.prod.outlook.com (2603:10b6:510:1c6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 13 Jun
 2023 23:18:03 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Tue, 13 Jun 2023
 23:18:03 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Topic: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Index: AQHZlu+7CCb5RYnzE0SLr6ZWSpg4cK+CfSeAgAQK0ICAAFGDAIAAKbAAgAA3uQCAALmTAIAA45EAgACUsYA=
Date:   Tue, 13 Jun 2023 23:18:03 +0000
Message-ID: <1542a26c0501cb9f7fc330d8aa27e565c81b969c.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
         <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
         <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
         <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
         <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
         <48d5a29a-878c-665d-6ac2-6f0563bf6f3c@intel.com>
         <3bbb6b384ba89dfaa13be01654ad27e41d779fba.camel@intel.com>
         <6fb1ec2f-8713-8191-fd31-751b1a663b0b@intel.com>
In-Reply-To: <6fb1ec2f-8713-8191-fd31-751b1a663b0b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB6683:EE_
x-ms-office365-filtering-correlation-id: 3c053dd0-01b7-4b23-c204-08db6c646ffb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AzH+RKNrRcKrTgT1LOhN+ralKWkYdTuh6CCMAEZwT5cvY3dAqicUUwjcE9O92QW8z1Xw7+bRzRAZIMv9DKE0EhFm0SUAmuwep5y2/idy5SYPFMoKbGYn4OHiBQtMENIt1fzVpCmh6I3P6B2frcK5LLJzxNBHXpW7Ka1eHi4lodYW0F1ODLgmIwm5t6Q4oqxqqK5In1qIpFmnsx7qG2p9BAi13uxuHqrm4icwKUzuYbG0um3ErdP/HNu4Nj+F+pXVYJrdagALSLAM4SvaoBsVYlWkjNAsaGzx6hEC7MlT0akuNxAUdrfJMzUDxMj3bfXzZr5aAPwMob94sgVIX/qWdqPnymlQRHwrL8Ra+rmVmWMM4QPxUcGSPP76R9z+hJpCQHMcIKZMXYDlwItkOyG2TB5xWIvg2SRwA2eeeVgqcvKq5ujR1gQ32WxpM8iyu1UwXd0pd7mlNnchA9Qsdr/CtgkjsSNcrkzLs/30qGDGSYcT0j98AFkNV9DHuaM0aTz0vA0O8wOPqw1Xn4cI/fXxU1K0+ZJmRH7HCEK+FjTJnwwMIq9QglnBltRE5TBraOyNm0jTiUzei9ESEIX4/ZYgOunaW65pT4/DUWcFwDO50U8PDxblPEQ/FGofipyw8jxX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199021)(38070700005)(83380400001)(122000001)(38100700002)(86362001)(82960400001)(478600001)(110136005)(6486002)(54906003)(71200400001)(5660300002)(64756008)(8676002)(91956017)(2906002)(66446008)(66556008)(41300700001)(8936002)(6636002)(66476007)(4326008)(7416002)(76116006)(316002)(66946007)(4744005)(2616005)(6506007)(6512007)(53546011)(26005)(36756003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R3VsdWlVRDNnbDRabGRMY2pvRm5ZR290SHh6NGdLSlZ4VCtIV2JKeXViS1N6?=
 =?utf-8?B?SGcrbzZscnRQc0JZUDJxbW9BU3ZXbkFIeCtVbXFpSHdTVW5kVXc2RnI0Yi9o?=
 =?utf-8?B?SHVNRU8vOXZRYklIRUo1d3BYeUIvTElqOUVCdVlUUHIxd3dDOXJNMUN1VlRk?=
 =?utf-8?B?VzJ4RVgxRkZGbTV0OTdnbVJtZHhDNWxpVER4TFhPQVdoQU9YQm4yamRSRkg4?=
 =?utf-8?B?d2kwMlAyMGtpcXY5UkxoMGYwbzZmV3ZBUHk2MmFSais2bkloRXNPZFc2OTdI?=
 =?utf-8?B?ZjQxQW5USDhNTGNyU1hZOGltbStzb3E4R25MT3pHbE82YzZtZUJZOE9qMldC?=
 =?utf-8?B?SUU3ZHhpUDJZY3FOK0NIekZHUDVSK053b1ZMT2tLVmlqQ1QzM21SWFp2N25U?=
 =?utf-8?B?a3BkQThUQ2Q4VXpPZHpHdS81ZWgwY0E3Z1MrbFBUdnpwSU1KV0dnK1I3UlVL?=
 =?utf-8?B?dUh1QTVtTHplZElVU2tXYUFGcEd2cEFIUWVnZm9SRGVSampuRThEemZZRW5Q?=
 =?utf-8?B?ZkhGLzAyZm1ZQ3hQK2QrNkFhQ1Z3SjM3YTk5TFl5c3kvL2J2b1ErS2wzaCtu?=
 =?utf-8?B?R2FnR3VGRXJLWFQ5MUhBb2paVDRubjd0ODlBSmFoa1FGdDFwSHptcjRVTEND?=
 =?utf-8?B?eVM2aVdwenNrMXovb3llckd6WVJVa0RNV3g2b1cxZmJWcW9PYjBVeTQzRnhK?=
 =?utf-8?B?aUNiUDdlRHgxRFljY0VLV012ODBXNEh3NllHbkd6eGo2cHI4Sjh3Vm5XNG9y?=
 =?utf-8?B?V0JNYUNCb251NFJydm1mWDZNYUVZemV6K25BV3diclpia2VsK2d3UnVFYWIr?=
 =?utf-8?B?T21XOW0vOGc3QWpiZXpKb2FtWUxubm4rOXRXbXI5akpPdW5zWkEreDRDRjVG?=
 =?utf-8?B?VnQ4dU5DYlkvaThORU5NanBSNU5zMm1HOFRNWHR5eDVjTHYzTEpua0o5ZDZZ?=
 =?utf-8?B?T1lKYm0yWmY2cGdNbEsrUWhJUmNUUDN4QVpGWDdhdWtTZll1cC9ya3IwcmlC?=
 =?utf-8?B?K1FkSm5kS05OalU1YzdqQ3dOR2xvdTd1R3ZxRmU5ZXF4YktPWWZKWDhyWVRY?=
 =?utf-8?B?bjBZSzRkLzBaYWdSTFdPNXc5YVNFR083UzN5am9jVENVa2phbDArR01jZkxS?=
 =?utf-8?B?RXlsQ0xTS1Z1cTFwOEdkZlVVS1BxUXd1Q0JZVFN1OFRVRnA1USsyNTNNS2I5?=
 =?utf-8?B?aHh4UHh6TTRYdmFIc2VEclRUaG0vdHhzN1doTlVJZlV2a1lNMGtSZ3V2b2k2?=
 =?utf-8?B?akN5clVjdTVJRVZPZG03VEtva3o1NFBud0JMM0YvcFZVRHRHUE5LQnNyN0l3?=
 =?utf-8?B?VkZlV1IwU0kxZHVXN3dSOW85R09xRTVoYXhwMHl3bWRscXBsNGx0WVJ0M05i?=
 =?utf-8?B?VXR5YWh6T3dmSXRMTHdScDhHeGthbGx6NlVGNnhwL3lDdDRsTkVNRVh6WG5v?=
 =?utf-8?B?TlVORDB3Q28vNGRxUzNMd1g0WkxQOGQrTGVyZ3BTcDM0dyt1ZTJMbnhRODNV?=
 =?utf-8?B?VUl6WkNySEJvVHhoMmhaZ05lb1FKamlRWDZzQS9oMUhJN1RGaUZWZjZXWHQy?=
 =?utf-8?B?aENmOE1qcFpYVFVpVGozWDEvRys1MTZBNXJzRENhQ3RqeTFjVDAzQzVWR1ln?=
 =?utf-8?B?ZTBSNG1JL3JhbEh4aHJ5OHhjN291a2FWSDV3dW02S2xJTWNPU2lJYkZIS24y?=
 =?utf-8?B?UWdLWkJhQ0duYUJLRGNCcWFlU3o4TUo2ckJzcDN0VXZLd1lCcWhZTDhoQitM?=
 =?utf-8?B?TC9TR3FpQXhTanJuampxejFVRDFiYnRJTFFzZ3p2R2UwakZXdzdpQmFqV0k1?=
 =?utf-8?B?MHNDelV0c2VHV0QzL2hkVHBZYXppcndlT0tRcXdHa3gyMTlOVHhPcEtHNmZU?=
 =?utf-8?B?dXpWek51dGFMSmt5YWhMYXZOamNsQjIyRjZOeDA0U1FQa1ZNY3RuZ01veXNM?=
 =?utf-8?B?T0d3bmlSNkFQdTBlV0hlaHJtbU9jbHNJaXBQeksxTko5TzRtRzNQYlFROGNT?=
 =?utf-8?B?R0xEOXc1cm9QTFhicXVWeVE1cVZMZUlWN1lVTk85bXdydkVwbkJnRlZnQlRn?=
 =?utf-8?B?THk4azU3MTlYbER4dlovQkpTSjlocCtFN256TDZFc2lDdkpKMUpCZGdDK251?=
 =?utf-8?Q?c5CgpGws0wOxxwWiPLOVGvnlz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7CE956304B227F4784CDD08DA41719CF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c053dd0-01b7-4b23-c204-08db6c646ffb
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 23:18:03.4390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2b80RFdfvaDc8aqWoImtiNg0IJwkdf/+Eh8bEV8rnetkou+fsdmkuZ2UoIYCm8rKZ/jTaLojAgYDc+v3rcDGWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6683
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA2LTEzIGF0IDA3OjI1IC0wNzAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDYvMTIvMjMgMTc6NTEsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gSWYgd2UgaW50cm9kdWNl
IGEgaGVscGVyIHRvIG1hcmsgYSBwYWdlIGFzIFREWCBwcml2YXRlIHBhZ2UsIA0KPiANCj4gTGV0
IG1lIGdldCB0aGlzIHJpZ2h0OiB5b3UgaGF2ZSB3b3JraW5nLCBmdW5jdGlvbmFsIGNvZGUgZm9y
IGENCj4gaGlnaGx5LXVubGlrZWx5IHNjZW5hcmlvIChrZXJuZWwgYnVncyBvciBldmVuIG1vcmUg
cmFyZSBoYXJkd2FyZQ0KPiBlcnJvcnMpLiAgQnV0LCB5b3Ugd2FudCB0byBvcHRpbWl6ZSB0aGlz
IHN1cGVyLXJhcmUgY2FzZT8gIEl0J3Mgbm90IGZhc3QNCj4gZW5vdWdoPw0KPiANCj4gSXMgdGhl
cmUgYW55IG90aGVyIG1vdGl2YXRpb24gaGVyZSB0aGF0IEknbSBtaXNzaW5nPw0KPiANCg0KTm8g
aXQncyBub3QgYWJvdXQgc3BlZWQuICBUaGUgbW90aXZhdGlvbiBpcyB0byBoYXZlIGEgY29tbW9u
IGNvZGUgdG8geWllbGQgbGVzcw0KbGluZSBvZiBjb2RlLCB0aG91Z2ggSSBkb24ndCBoYXZlIGNs
ZWFyIG51bWJlciBvZiBob3cgbWFueSBMb0MgY2FuIGJlIHJlZHVjZWQuDQo=
