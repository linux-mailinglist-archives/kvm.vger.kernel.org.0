Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4337360E2
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 02:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjFTA4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 20:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjFTA4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 20:56:51 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0C7FA;
        Mon, 19 Jun 2023 17:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687222609; x=1718758609;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vw0sCruOt+sZXy+OWV1gJkqItVtFm3Zoq2PxjYtKlbk=;
  b=bhwgDpXHLPI37q9DKR9AXQzi+WZ80ls8Axu3yHdAn1SsNZIgWZo8u81o
   MZiaEjXkkLwlPRk3v2G1nMLulMcBPXtEvDM6jVKuzWtlMTm9oQZUG8I/3
   a/TVb0Ohq1I/I5AmSTQ35gL0SASTUmbHcEjbHG8XLMr26B47J7Nc/KPxJ
   ywYMhTKpjbYz59hV76xA1AZuhSoODvH3WJgI62/QXp7mrpoeUIJ33ur7W
   l9kU6ueRDkkhNS6rMBmQqeg5vqei+8sNYdFhzPmyZ1LNIv4JjVm79iCfG
   ASrwYgmW89kS8KVlkezZtl4NJN2PyBUBNTgLKmHBT+yRzgvfG61qcthce
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="349464275"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="349464275"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 17:56:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="783869318"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="783869318"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 19 Jun 2023 17:56:48 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 17:56:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 17:56:47 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 17:56:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lgBqxPRDdwvcIixlCVBEQiCKS7yo/ctmxNdDl4rCQb958gowUeW+rwhu4+JBt014265v6eTYTvAxIKmrVjAdMTM+7BWzLW3EuSxQT2X2WzKwrEExkKDhdiBYxsFqBajbsoD0XXnw52LI+6bqT2KC9claQdQo4EvfvCogZF7O7F+lG/kOx7WeC7aDSGkOM/8+Yg/SkPznV6uW0OIIb+dy4xfgLfU4fklAwaqQypeUAIFui37Y9b991lenRVOAUrW87rePYYnaml4jDxfoQXZrm9juAGBKwr7aamUUhs7MaAYWDhyI4y2ZIMkVFh74EDK+d3ZfiFEsUcnHruJ8W/i40w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vw0sCruOt+sZXy+OWV1gJkqItVtFm3Zoq2PxjYtKlbk=;
 b=eLzCxIafG3Ux34Hl6/VAZ1aYn35vCceB9FMByQQzsmxleimX5B9TMGW6FFR7NUOt+Jp8DLuQR0Qr5llQOeEl0NpXF/u6ybhFmTb4EaA1W6NF6euFlqqaogct/tkIUNU18TvBqimdebaVxC/60w93QKYjTrClEOXD6ojwUFNu1ryeI4GssxBDZTwpWZ/9Ng6OKjXbEHOCghbDaCnHKoel5O8okc5X+tNKe9B3yBuEEDI7z9WLo5QFe27OV61ILxFyWUx9mOvX8p9geuMiblbGjnR7xBraQe1Elix8hu4XqJV9GQPmu8wHZAJdSicz6cHEjS68pvMl/O2aSGg3ak7GFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB4851.namprd11.prod.outlook.com (2603:10b6:303:9b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 00:56:43 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 00:56:43 +0000
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
Thread-Index: AQHZlu+7CCb5RYnzE0SLr6ZWSpg4cK+CfSeAgAQK0ICAAFGDAIAAKbAAgAA3uQCACt3UgIAALtiAgAAEVYCAAJVNgIAAFRQA
Date:   Tue, 20 Jun 2023 00:56:42 +0000
Message-ID: <0be5634f390015ee6badb3f2b2154ad90eb70434.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
         <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
         <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
         <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
         <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
         <48d5a29a-878c-665d-6ac2-6f0563bf6f3c@intel.com>
         <5782c8c2bb3e76a802e4a81c553a21edbaee7c47.camel@intel.com>
         <be258af9-a329-6f03-fcf9-9dafad42c97f@intel.com>
         <20230619144651.kvmscndienyfr3my@box.shutemov.name>
         <63477d22-26ef-dd08-a3b0-93931b7d1d16@intel.com>
In-Reply-To: <63477d22-26ef-dd08-a3b0-93931b7d1d16@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB4851:EE_
x-ms-office365-filtering-correlation-id: 23e415a9-d357-4938-fd1f-08db71293682
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6VPS2rY7+D5/usg/rD7PiqAHP3e3wEEgkI0rNgxLVes0XZactNCvzO/BWbQsuuicgXlEMO7LuhMz+6+xRx+2svhDRewAzlCCGyeO1/Z8WCg/7AcoQc8/XuOz1yKgyC60Xh6EOKuiCPwPmMt0Q5zJIDvjYC1XjpUMJ1FNnO62kguwiDq8M/1xRmqgKxpV3hL/7SL9gPAFd35qw5aZqjHuOJZkuJXVQsCHX7ZYPliHneSKvEmM6tPNXW/kiDTACAyVEXxOX9lmzUeV095z1s5oQ/L6iVB1oaeujRdJDfDZcvholckxnn3RyHeFM0eZyC0BBAyvg/P8IQIFA/pqGBfgCVXay3/GGdmpMTYcWAEXWd+PBTqHzm1rLlgSe/T9J5VVM4gT2vHg5AKfqF/CMdhN2HM6Exub0z4RfDb3uMsh9iNac7W7ELAYCom2QnEE+fmQN3Mu5YlIMDJqDpZl6z9SIqy+8VQnxtdKMLRGove5lIaOR6tHxP6P7B93COTbqDCKL2/VHck49M96Sp4fGiWtsHtoeGiHn3tsU4vcqSyNNjrHITofbGa9IUFzNWQfKLehYp6kSmad8oOXwSeEY8wRuttZD5aybR5YWJPB2r+ncVm0CIEpza5zrjseUPRVZydF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(366004)(136003)(376002)(39860400002)(451199021)(5660300002)(66946007)(6636002)(4326008)(91956017)(76116006)(66476007)(66556008)(64756008)(66446008)(316002)(36756003)(7416002)(2906002)(8676002)(8936002)(41300700001)(6486002)(54906003)(38070700005)(110136005)(86362001)(478600001)(38100700002)(122000001)(6506007)(186003)(6512007)(26005)(53546011)(82960400001)(71200400001)(83380400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a2VHRDBTbXJFb0F0UHVUU2FXbmNZM1JJTkJSQzBTamZ3Q2p2ZDgwZUI3QUJo?=
 =?utf-8?B?WTE5eVlKMmJaZ2Z4cytNOEh3NmN6RU51dUVtSVBYU0VMOGU0S3ViY1VMWXgw?=
 =?utf-8?B?ektYaVFpTnlWa0tlRG4yODRsZFZXMHJHdjIyckZnYnhZbEx3ZE1kdStFUHhq?=
 =?utf-8?B?dnptTnVoM2gzYVR5SEl2dU1GZHo5dHhselZ3cll0NGdEaCtiSWQ0NlNOdlF0?=
 =?utf-8?B?UDFja3hEVmVQTTNFTEIxUW5ETDVsNWMzV1hsdkZlYUVMUFg0MVZpZGRxUVh2?=
 =?utf-8?B?cFRoVHEzdHNSdGUxUDhYanY2WEkrc0JpeU9hNnlsZ2IvelNyeDhodEgzYUZw?=
 =?utf-8?B?UmRVUk9lT3hWa1ZicGY4UkdMalFyVDY3SWRGalp0bGhiR0F2SE9tY3pIMkRx?=
 =?utf-8?B?WHdCQ3dFK2MvWjRmaUdBRDVyZlV2MlNrQy82Smp0TS9aVFJoVi9tQ29KVUdj?=
 =?utf-8?B?dmtWVlJob1NBdWdjekVWZUVHSC85eGZ5Q3U1VnFIQm10TDEvVnhlQk9zT2dU?=
 =?utf-8?B?TmlSZ2ZCSnc3dVB5cFB1YUp3U3BHMVFJSWw2bDNpd2MvalNRRVNmZStUaW94?=
 =?utf-8?B?T3hPQXNLMU03a1RpdEZJQjZoUHRYdURBcnRKVG4va2dSeURMbFZUM0ZmdUZQ?=
 =?utf-8?B?T2tFVm9QaExCTncwSTM1cWdNSWdFek9uaWMxQVFTc0hGbUpWQ1VXalYxV1I0?=
 =?utf-8?B?aEpORXdJRmFYelltRU9yRGNRTDFLS1RiU1JpSktXcDJGWk1pdzdrSnRNd2VL?=
 =?utf-8?B?cTF5ZFJWOUJrNU9zY0VkQ2FFR3IwanhST3l6OWNySG1RU3VMbVJ4czNLb2ZN?=
 =?utf-8?B?aFEranhGWVBkMk9wdkxBYVVKUFlkNm9KblQ3blVaUGo3dGVYZWRyWE5nZWJt?=
 =?utf-8?B?K2ZsbE9scXVIb0Q3ZXdid3pjS3VGVzdZQ1M3RGhCM3V4UENaSGtFT3hPUVB2?=
 =?utf-8?B?Y0dNZVVuVVRzK2NnTVZOTVR6bmpaUk1mY20vcnR2bGUyaEZJeithTHo0Tkpw?=
 =?utf-8?B?VnBQMnZoTjlCZTdhdkRoTktwalFCajBlZElZYnlLN3ZZOW0vMFQ3MTZMUzly?=
 =?utf-8?B?N1RmckRDZFoyZU96U3ZSMWN4MTMxbm94S0prdW9LR3FUdUYxS2sxNGFKcTJv?=
 =?utf-8?B?WHkzUzJwNjlvc2VmSlFtK3B2WUF4RVlqMEx2YzlrenJHeHdCdld4Z3QvVFRW?=
 =?utf-8?B?OTZzZGQzZVhGMDNNQWJWeUdZODhZVW43Z3ZwazRNcks4dTR0b1FJNXJRR3px?=
 =?utf-8?B?VWRHclJPMWw4R2diYXFLejZrckZrMDRHSTY1cW5KTnl3MlZaZWhDa0VpOFpV?=
 =?utf-8?B?blBxSW5XZE9BbEttaE4xbmhTc24wL3liNzM1VHFrRmtaNjhsNGpoanZFZjVT?=
 =?utf-8?B?d25XVENNaE5aK3NYdWJaME1pRnJZdWxVSUVWa2N2T0tFSjVwdzBpeGNKL1Ix?=
 =?utf-8?B?NzRvSVphZGkzYi9BSWhMclExeDlmRkpMMHBhRTJMZGZLTVNKaGFKNGk1RFJy?=
 =?utf-8?B?M044MXI5aHdDUUNJaGFsL0JSUWFYRWt4SE5BemJOeVFObm9qSlpzdVNieXVx?=
 =?utf-8?B?clRVN3ZqZ0JkQjNVdGZTTHBpWTJIMGsxc1BiMGhZZmlKZlAvbHFnWWZ6Q1ls?=
 =?utf-8?B?NXdwOHRJTVNxSTY1VUhzbXU4UmZ6M1FTM0lDek02UXhmNi9HZXZjNEY1MzFE?=
 =?utf-8?B?NWVGUk5rM2FnY2xLQzI4QVI2WEdvRnZoUUZzdDJjMlBPdGVleG5zV0FhVGZ6?=
 =?utf-8?B?cEt0YWR4YmRJcitkaXZqVmt3U3BhMUJibXE4anI1b3ZRNFpCV09QZkZiRmpw?=
 =?utf-8?B?cGM3b1pzZHBvVnprU0ZvTXBPQ0VHVFpsc2taWFp5R0lTbDA1aWhWRFZLUS9i?=
 =?utf-8?B?VE1Gb0xYSDFDQUpGaXRLNzcwN0hQRWZnL24wamY1TVkraW1vMzVmc0xRNDFV?=
 =?utf-8?B?MXBHcjlPY1JaaU1IMURGTEtZVXo4UWpGS2lXdEsyREJ2cGNjcW9rVVRrZHhZ?=
 =?utf-8?B?Nzl3R2diQUdXNW0yeWhpQXBCWE1FN3ljb2tjYjc5ZnIyYlZBazRnSW9NMWdv?=
 =?utf-8?B?VzRKV1ZEU3lCMUJ6VXBocS8ydUJMNTFYU1N0ZDlzK3V2RWxLVi9QTmVsaFhR?=
 =?utf-8?B?emJVc0Z3eHNHZzZiaWN1L013TzdsNWZsVzdOM1NCZFhEek9tOHErbWV5Vmh4?=
 =?utf-8?B?WVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D6FCA18E962B1A40BB355D0A07F4DCFD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e415a9-d357-4938-fd1f-08db71293682
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2023 00:56:42.5174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8QFWu0RjudPx789L+Ggjja4KY8w/cAI576wtv+3YRC8v6yqkg5BpJYbPL181G8lzUkjRKE77oDHg6VjrtystJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4851
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

T24gTW9uLCAyMDIzLTA2LTE5IGF0IDE2OjQxIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNi8xOS8yMyAwNzo0Niwga2lyaWxsLnNodXRlbW92QGxpbnV4LmludGVsLmNvbSB3cm90ZToN
Cj4gPiA+ID4gDQo+ID4gPiA+IFVzaW5nIGF0b21pY19zZXQoKSByZXF1aXJlcyBjaGFuZ2luZyB0
ZG1yLT5wYW10XzRrX2Jhc2UgdG8gYXRvbWljX3QsIHdoaWNoIGlzIGENCj4gPiA+ID4gbGl0dGxl
IGJpdCBzaWxseSBvciBvdmVya2lsbCBJTUhPLiAgTG9va2luZyBhdCB0aGUgY29kZSwgaXQgc2Vl
bXMNCj4gPiA+ID4gYXJjaF9hdG9taWNfc2V0KCkgc2ltcGx5IHVzZXMgX19XUklURV9PTkNFKCk6
DQo+ID4gPiBIb3cgYWJvdXQgX2FkZGluZ18gYSB2YXJpYWJsZSB0aGF0IHByb3RlY3RzIHRkbXIt
PnBhbXRfNGtfYmFzZT8NCj4gPiA+IFdvdWxkbid0IHRoYXQgYmUgbW9yZSBzdHJhaWdodGZvcndh
cmQgdGhhbiBtdWNraW5nIGFyb3VuZCB3aXRoIGV4aXN0aW5nDQo+ID4gPiB0eXBlcz8NCj4gPiBX
aGF0J3Mgd3Jvbmcgd2l0aCBzaW1wbGUgZ2xvYmFsIHNwaW5sb2NrIHRoYXQgcHJvdGVjdHMgYWxs
IHRkbXItPnBhbXRfKj8NCj4gPiBJdCBpcyBtdWNoIGVhc2llciB0byBmb2xsb3cgdGhhbiBhIGN1
c3RvbSBzZXJpYWxpemF0aW9uIHNjaGVtZS4NCj4gDQo+IFF1aWNrLCB3aGF0IHByZXZlbnRzIGE6
DQo+IA0KPiAJc3Bpbl9sb2NrKCkgPT4gI01DID0+IHNwaW5fbG9jaygpDQo+IA0KPiBkZWFkbG9j
az8NCj4gDQo+IFBsYWluIG9sZCB0ZXN0L3NldHMgZG9uJ3QgZGVhZGxvY2sgZXZlci4NCg0KQWdy
ZWVkLiAgU28gSSB0aGluayBoYXZpbmcgYW55IGxvY2tpbmcgaW4gI01DIGhhbmRsZSBpcyBraW5k
YSBkYW5nZXJvdXMuIA0KDQpBZGRpbmcgImEiIHZhcmlhYmxlIGhhcyBhbm90aGVyIGFkdmFudGFn
ZTogIFdlIGNhbiBoYXZlIGEgbW9yZSBwcmVjaXNlIHJlc3VsdCBvZg0Kd2hldGhlciB3ZSBuZWVk
IHRvIHJlc2V0IFBBTVQgcGFnZXMsIGV2ZW4gdGhvc2UgUEFNVHMgYXJlIGFscmVhZHkgYWxsb2Nh
dGVkIGFuZA0Kc2V0IHRvIHRoZSBURE1ScywgYmVjYXVzZSB0aGUgVERYIG1vZHVsZSBvbmx5IHN0
YXJ0cyB0byB3cml0ZSBQQU1UcyB1c2luZyBnbG9iYWwNCktleUlEIHVudGlsIHNvbWUgU0VBTUNB
TEwuDQoNCkFueSBjb21tZW50cyB0byBiZWxvdz8NCg0KK3N0YXRpYyBib29sIHRkeF9wcml2YXRl
X21lbV9iZWdpbjsNCisNCiAvKg0KICAqIFdyYXBwZXIgb2YgX19zZWFtY2FsbCgpIHRvIGNvbnZl
cnQgU0VBTUNBTEwgbGVhZiBmdW5jdGlvbiBlcnJvciBjb2RlDQogICogdG8ga2VybmVsIGVycm9y
IGNvZGUuICBAc2VhbWNhbGxfcmV0IGFuZCBAb3V0IGNvbnRhaW4gdGhlIFNFQU1DQUxMDQpAQCAt
MTE0MSw2ICsxMTQzLDggQEAgc3RhdGljIGludCBpbml0X3RkeF9tb2R1bGUodm9pZCkNCiAgICAg
ICAgICovDQogICAgICAgIHdiaW52ZF9vbl9hbGxfY3B1cygpOw0KIA0KKyAgICAgICBXUklURV9P
TkNFKHRkeF9wcml2YXRlX21lbV9iZWdpbiwgdHJ1ZSk7DQorDQogICAgICAgIC8qIENvbmZpZyB0
aGUga2V5IG9mIGdsb2JhbCBLZXlJRCBvbiBhbGwgcGFja2FnZXMgKi8NCiAgICAgICAgcmV0ID0g
Y29uZmlnX2dsb2JhbF9rZXlpZCgpOw0KICAgICAgICBpZiAocmV0KQ0KQEAgLTE0NjMsNiArMTQ2
NywxNCBAQCBzdGF0aWMgdm9pZCB0ZHhfbWVtb3J5X3NodXRkb3duKHZvaWQpDQogICAgICAgICAq
Lw0KICAgICAgICBXQVJOX09OX09OQ0UobnVtX29ubGluZV9jcHVzKCkgIT0gMSk7DQogDQorICAg
ICAgIC8qDQorICAgICAgICAqIEl0J3Mgbm90IHBvc3NpYmxlIHRvIGhhdmUgYW55IFREWCBwcml2
YXRlIHBhZ2VzIGlmIHRoZSBURFgNCisgICAgICAgICogbW9kdWxlIGhhc24ndCBzdGFydGVkIHRv
IHdyaXRlIGFueSBtZW1vcnkgdXNpbmcgdGhlIGdsb2JhbA0KKyAgICAgICAgKiBLZXlJRC4NCisg
ICAgICAgICovDQorICAgICAgIGlmICghUkVBRF9PTkNFKHRkeF9wcml2YXRlX21lbV9iZWdpbikp
DQorICAgICAgICAgICAgICAgcmV0dXJuOw0KKw0KICAgICAgICB0ZG1yc19yZXNldF9wYW10X2Fs
bCgmdGR4X3RkbXJfbGlzdCk7DQoNCg0KDQo=
