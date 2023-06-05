Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A0C7228CC
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 16:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbjFEO3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 10:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjFEO3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 10:29:46 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C546399;
        Mon,  5 Jun 2023 07:29:45 -0700 (PDT)
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3558tbJf000515;
        Mon, 5 Jun 2023 07:29:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=QAin/skqzYvEJt38/UjSd4F4jzkJmfarEIGEyTWl7V0=;
 b=22XWmSXMdlj0IhwnaK3xv33CppSAXVRwSb1j245TUzRn09yYCvK36RCRUuggo8AeiOrW
 TN1KlD+uR3OdWb+aegGiu5F74EmCeeP2oNlKbIe//ZU0pwSyZ1IkAiUcXsBlfyO2qs+n
 eGClDR9WMNvVERUxiEDaNweUfP8Ihwe3KCJBStqYYDR4C7tPvegOdMFTi5cvfmiDn2js
 3v9uAAzYqMW4jk6mqEAkomjbJSgrauI8Cdn2KLSq94j+WwkspZQcb5gRMj0OtDSUgRSc
 u5+affkxtuKwzWPdwTEuPHfwdtYuBJZsA3dOebmJ4T499sa6fwPiwJ49gpAZgsFSZNdL MQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3r051y39sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 07:29:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/0dnccNdjanaCB2oWcEJI2/1xwoZqfxpR6pthOx2NPI/fTlauP+V5iMHOZ3RHPbRT8WclhZDRcoAGnlvMVlhhCuJ8Gn3yojLYfQfWnGghEV5vR80f23Bp7gIlLposW0X1PH8Kka2xrShxfABKloCutoa2aZ7qIzVw4JGwTIDvoIdp3OvPcAxtZ4eOOiglilBtCQjUUiM/iiwmsP0V0QYHYCWkjX20FDoh7HVkQ4YV/JlCfEXVHGYW7/yQsAZD5p/XbnM2AS5Cng6/VSdp3ZFQpcpwk0G0NypzCoqmPO94sHTctlE03S49AuHVMB9fmyK8mZwSvg4eejcr4uoblgIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QAin/skqzYvEJt38/UjSd4F4jzkJmfarEIGEyTWl7V0=;
 b=k/rx7iLHqJ3ugh6l7rBotTT/ayhZ1kV5Ny6UtyRtaffvKpIRUu6qIKPLSwz3BEqrN8Plo8C4/qKZHttd7Eaab46hWRFvqP3lIk9vh8jHK43g7TyoiSlI3cxSn0V1u/3/nJiEDQdYCeQVgiUWxObtRNVqBWwPQ1KqVvwOKF/9PbI7+1FFOYMxAT0GXE9Ex016ng3Q428L8ndomsQV/dlm9qK8fu7LxeT9RHxwUfFylTZCbUZVFckOd0yud/QdNouvYIYgS+CbzvlCYKoFY4Jlg+UZdTn581ErrZON7OAyURZh779q8V3B5N9onvyhCoWyp/uBugX9KYXrgn+/P4Skkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAin/skqzYvEJt38/UjSd4F4jzkJmfarEIGEyTWl7V0=;
 b=vLDN2BLJCJyb0Igc1fo/m9vMdgZCu6m5Oz96tcxW2b4YE6yjhFmH7h1j/Ng1Ipl3pMiKyeTsKmBzIezZ4pIgxl89cASJ/BfnAkwQ1O1H92ItJv5URxAZQHvdqu43TN+ThAAHGDIC/1N/6Kg1LvPi2XXSBymD9zbtazLANi06k9zpGuuXe4zAKHa1i5BdgMHjBWRwV35NnF+WJgqzggYqyOndSrkMwjdjGgBfSar9cJeJKmBNS/OlXS9eaM50D6bapKy0J42Fdg7pNGBQHQ1mj/0Sfz4W+xov5AmnHT+2SmDRbk9MZLTD95FmLehn4S9GJy7cYdbSZk65tV5TVAVrnw==
Received: from DM6PR02MB4585.namprd02.prod.outlook.com (2603:10b6:5:28::17) by
 MN2PR02MB6653.namprd02.prod.outlook.com (2603:10b6:208:1dd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 14:29:05 +0000
Received: from DM6PR02MB4585.namprd02.prod.outlook.com
 ([fe80::e48f:7318:a1cf:dbf1]) by DM6PR02MB4585.namprd02.prod.outlook.com
 ([fe80::e48f:7318:a1cf:dbf1%4]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 14:29:05 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
CC:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Thread-Topic: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Thread-Index: AQHZk9DFtRNtW0r2UU2DHIN38zEv2a91BL4AgAALIICAAAxDAIAAAnMAgAAJaYCAADIWgIAG8nEA
Date:   Mon, 5 Jun 2023 14:29:02 +0000
Message-ID: <21D1D290-7DE9-4864-A05B-A36779D9DC26@nutanix.com>
References: <20230531150112.76156-1-jon@nutanix.com>
 <20230531231820.trrs2uugc24gegj4@treble>
 <F4BEBCAF-CBFC-4C3E-8B01-2ED84CF2E13A@nutanix.com>
 <20230601004202.63yulqs73kuh3ep6@treble>
 <846dd0c5-d431-e20e-fdb3-a4a26b6a22ca@citrix.com>
 <20230601012323.36te7hfv366danpf@desk>
 <20230601042345.52s5337uz62p6aow@treble>
In-Reply-To: <20230601042345.52s5337uz62p6aow@treble>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR02MB4585:EE_|MN2PR02MB6653:EE_
x-ms-office365-filtering-correlation-id: dbab39fe-592b-4e11-c573-08db65d135e4
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jMgX1Qgz/4CQC/rHmdWb/hDcTMlO/aa/5RdJnCNFEArr//i2kqHHsvknyijIVMJQ/M0hCzhrrnA9NCTOcvWFbFe1LnhDnFpyE1MZhQIbP/YB6XhB0e/jIv5aBVV+ZMOT/vA8ayoI71FrK2CCJP+/gqWDfOkldxscm1K5+dlY7h4XPQthuuEdMxnLxeP6oB+tIlwRnSPwa02lx/L2NnXpOg7kyJryi4LLNRXOh/eSxjEBwd7LHhLidqnHqzkkap5sNV6Tyc5XrefDVdshMN4WwNKZRAMHNcEidw5LwstOEkO678BYdTjsDlzhVOucOej7fmoy1Ksd8tlrOsM8ep1quHr2pZScLTGysiwrDlaNjQrtytmUWiCH2ex8jeFoskqSC7IThFrqapmPBX5g5m+8cMlwRQBUW/cpfQuPiXUspCBZn+XcWpHVnHIcBMJLD4Tg811vBIuuCxqWWjctHb+bkkRFwsoozszvNa6tZxjHWm8Vfhc3l5WvPlZsgJLKpPtLtlgv3XGdRCTE9Tc8abERXT/8Of7k4gE0QfYM7ALeaWFS95GykiCOuzvmSJ1/z3q9XPlVD+pxB5A1ZeixGvu8bscE0xP+fLS/gB/rHnuu5+k5dMJSa3wxWWrcxXI+QUNAS3Nc3hxx1VAQGvcsNvEm0Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR02MB4585.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199021)(122000001)(83380400001)(54906003)(4326008)(6916009)(91956017)(64756008)(66446008)(66556008)(76116006)(66946007)(66476007)(38100700002)(6666004)(6486002)(478600001)(71200400001)(186003)(2906002)(36756003)(2616005)(38070700005)(8936002)(8676002)(41300700001)(316002)(33656002)(5660300002)(86362001)(7416002)(53546011)(6512007)(6506007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1lwTVJvWHBWc28vZ3pyWEFMSHdLcnZQRm55cjJTUDBpTVM4dGxuMjVJZEZS?=
 =?utf-8?B?aklxUi9rZlFTTFJ6aTRuNEwxaFhUbjVRdGhQNmFBNm02U2ttZTNGZlEzaHdS?=
 =?utf-8?B?MDZXd2g1V056VkJKbmtieEp3MTREb2dhb04wUjNaenJPYVNQODR0a1VBM3Ey?=
 =?utf-8?B?d1JMczUvWERUbnM0MzlwZzlHSitzd2JPVnptWUJHVHZ3VS9CeDlmV1JVaUFn?=
 =?utf-8?B?MXNhT0Z5TmpqL2xkTmhNUmNCbU53dlI5eFBRWG4reWw2dUM1QWE5cWxWUDdJ?=
 =?utf-8?B?T3RqUTA3RWVmUFU1dTVLU3oxU2FuN1FOQm1kRys5eFJwZjhqZkJlaDU1ZFBD?=
 =?utf-8?B?bEczeGhBWEZHODdPSUhvMnp6ZlBoMnVFRUQ0ck5hNGhFNnFHaklyeE5HYkxR?=
 =?utf-8?B?VHRHZ2FkMUh3OVA4VzZCVGozL0xzajJNbklLZ0NVcjBTdElPUnQwMng1R1gx?=
 =?utf-8?B?M1QzcXJDQmlWd3hLR0RmNUtOaVpxRVVHR2NOQnpVZmVIY0FEYTgyTDliMVdt?=
 =?utf-8?B?RzBrcHBJM3J6M2p1Umk5MmN4VE85MkRBbHRzSmNTMTluTWhraEJYZnMrQ3h2?=
 =?utf-8?B?WlRiTzhOUkJjUFREWmg0VTh2UHZvV0d2bHVQemkrWG41bFhBZ3hQT05KMktK?=
 =?utf-8?B?UmlhcnFFUUNCTUJaamlISGxMR0Z1QjdnVFZ2Mm12OFVENDk2bVNVRlBaTDZI?=
 =?utf-8?B?dklFWEVibzlqQ1A2TEd0ZDdUeTY1UjdrS2lNWmVVekRpUlZlY1V5di9XeUJv?=
 =?utf-8?B?WUR4ZmJmdlcrL1BwTUI5cjFRUmJKWlg0MUgrK1dHeSt2dURTWlVZeHNlN0ZV?=
 =?utf-8?B?L0d3WG9ZTzZwMm5HODhHWTdHcDlqQS9WZVpkYmRMZ1NTRXB3Mm95MWM0bGUv?=
 =?utf-8?B?YWRkbnRYYkRxb1QzMDFMR0EyME9hbmJQWlArTmVsSHQ4WHFVcUc0c0hLaU9h?=
 =?utf-8?B?UDlNbWM1cWdkZkhXMmVlMHVqNVRGQWRUOWFSNzdnVFB6SndCdUFXZWp2M2tp?=
 =?utf-8?B?OFFYUDFlWHk3VkNGYlUvYTRtWmoyeW1iS0pCdUtPcjZBQU84ODYyMWlyQkJM?=
 =?utf-8?B?eC9pTUdOanFhV2VVbmNEMWVVcFhibUxVdldXaEpyeCt5VTJDWFBaYnJGTEIz?=
 =?utf-8?B?N0xycmsrcmo2alFaWkRNZ1hpNk9lc21EYXVXL1NUajN4U0txQUVySzBHS3NM?=
 =?utf-8?B?cGI3MnZROEhrZjFnVXdIRnZBNmVEZkRXK3BlVDZzOVppSSsrQXh5K1lzUU9K?=
 =?utf-8?B?dlMrTityR251TXVueFV1MDUyRklQcFg1YmtzQ3pIZWZxU2o4TVpOSXFQQy92?=
 =?utf-8?B?Q2JoWE5tdlhLOXE2K2hlK3F0VDQ5VmJ0Nmx1SSt2bFJ2Mmx3Q2JyVlhRdlVh?=
 =?utf-8?B?VlhOWE5ZOWZzMEF3SUlOY2l2SHM5bjI3cEFNUHF4cGFaWmhncDY1QmN4alYy?=
 =?utf-8?B?NXc0YXJKd1p6bWFqSDRyOFcya0d1OTMyUjZvbzVzckRFZE9VT3lvRkRMNG5Z?=
 =?utf-8?B?cVJvZkxaMEd1MjFsMG1vNUdiNWZycTNGTWZjRTZLNU1sbFhsQXFJTEZKQTBj?=
 =?utf-8?B?K1NoWHN0Um8zd1lKRmozQlVMZ0xDbnNGanJ2VU9uOVBYRGRhK1pZd3haWTZ0?=
 =?utf-8?B?K3NYTkZqK1YzYm5zNjlnaEVPeUVVUWNLc3FIQ3Y1QWk4ZGQ5NDBDR2RrYUtn?=
 =?utf-8?B?blQrdzh5dlY4bHVNUXJNOHVjWTZUbkJrOCtOdUlwRytjQnd3eTNwUlVtQjdp?=
 =?utf-8?B?M3ZPSHY5TnpKRVZTeitlZ3ZHNnZKRXZOZ0dsK1Z5dFFMVXE1MmtxVysyY1Bv?=
 =?utf-8?B?emIxUmZFWWxhdnQya1Zxa3liVW9JRHFSdHh1UEQvRVhiZEZPR0hpMWgrVzZr?=
 =?utf-8?B?NHg5VDhqWjVHUWRkWXNmajFRRDRESVo4MVlFbkU2ME5sSFlhcnVTSFY3OXUx?=
 =?utf-8?B?T205R3U1eTNGajk3M2lHRlBUYlRjVTJmM1o3VXBrZkRlTFp2ODA5WWVLdE9w?=
 =?utf-8?B?U3owVHRnaWFjRkZobVlXWEk2SlVPWDRyQXhVNU15WHp2ZUYxNWxKY1JiZldK?=
 =?utf-8?B?eHJEUnBRbzZLSXV4L3N3clA4aVRwSU5hWUloYW9uL0RXVEQ0dzRIZXJWZW8r?=
 =?utf-8?B?ZXd4bkpnZk50V1FZNU5SRTFMUlNGbUE1em1KUi9wdUtxcWxnQzY5b05qanZF?=
 =?utf-8?B?MnlYYjljZnd1OFJJRllhcktva3daaFlGelROVWJNRDJpT3czQ000RGp3QzVQ?=
 =?utf-8?B?RzlKcmVCRFdNdEMyQ0w0ZTQvS1F3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <18A3F065335AE246819FFD5C3ED5E48E@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR02MB4585.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbab39fe-592b-4e11-c573-08db65d135e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 14:29:02.9493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e80yi6X6ELO4NLH8VTEPiCGpXr0VQoBb2X+qXWN9BJrRKz2RpsvT8wLlLo5FdmUXGqjt08F4QRr/A1436F3GOzSLuU0KS0QMpvbYzIkxBvE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6653
X-Proofpoint-ORIG-GUID: ciVxZbVs2GoOBw38lopXl0Q-Zn-cC6A3
X-Proofpoint-GUID: ciVxZbVs2GoOBw38lopXl0Q-Zn-cC6A3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-05_28,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gSnVuIDEsIDIwMjMsIGF0IDEyOjIzIEFNLCBKb3NoIFBvaW1ib2V1ZiA8anBvaW1i
b2VAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBXZWQsIE1heSAzMSwgMjAyMyBhdCAwNjoy
NDoyOVBNIC0wNzAwLCBQYXdhbiBHdXB0YSB3cm90ZToNCj4gDQo+ICMjIDIwMjMtMDUtMzENCj4+
IE9uIFRodSwgSnVuIDAxLCAyMDIzIGF0IDAxOjUwOjQ4QU0gKzAxMDAsIEFuZHJldyBDb29wZXIg
d3JvdGU6DQo+Pj4gT24gMDEvMDYvMjAyMyAxOjQyIGFtLCBKb3NoIFBvaW1ib2V1ZiB3cm90ZToN
Cj4+Pj4gU28gZWFjaCBMRkVOQ0UgaGFzIGEgZGlzdGluY3QgcHVycG9zZS4gIFRoYXQgc2FpZCwg
dGhlcmUgYXJlIG5vIGluZGlyZWN0DQo+Pj4+IGJyYW5jaGVzIG9yIHVuYmFsYW5jZWQgUkVUcyBi
ZXR3ZWVuIHRoZW0uDQo+Pj4gDQo+Pj4gSG93IGx1Y2t5IGFyZSB5b3UgZmVlbGluZz8NCj4+PiAN
Cj4+PiBZb3UncmUgaW4gQyBhdCB0aGlzIHBvaW50LCB3aGljaCBtZWFucyB0aGUgY29tcGlsZXIg
Y291bGQgaGF2ZSBlbWl0dGVkIGENCj4+PiBjYWxsIHRvIG1lbXtjcHksY21wfSgpIGluIHBsYWNl
IG9mIGEgc2ltcGxlIGFzc2lnbm1lbnQvY29tcGFyaXNvbi4NCj4+IA0KPj4gTW92aW5nIHRoZSBz
ZWNvbmQgTEZFTkNFIHRvIHRoZSBlbHNlIHBhcnQgb2YgV1JNU1Igc2hvdWxkIGJlIHBvc3NpYmxl
Pw0KPj4gU28gdGhhdCB0aGUgc2VyaWFsaXphdGlvbiBjYW4gYmUgYWNoaXZlZCBlaXRoZXIgYnkg
V1JNU1Igb3IgTEZFTkNFLiBUaGlzDQo+PiBzYXZlcyBhbiBMRkVOQ0Ugd2hlbiBob3N0IGFuZCBn
dWVzdCB2YWx1ZSBvZiBNU1JfU1BFQ19DVFJMIGRpZmZlci4NCj4gDQo+IFllcy4gIFRob3VnaCBp
biBwcmFjdGljZSBpdCBtaWdodCBub3QgbWFrZSBtdWNoIG9mIGEgZGlmZmVyZW5jZS4gIFdpdGgN
Cj4gd3Jtc3IrbGZlbmNlLCB0aGUgbGZlbmNlIGhhcyBub3RoaW5nIHRvIGRvIHNvIGl0IG1pZ2h0
IGJlIGFsbW9zdA0KPiBpbnN0YW50YW5lb3VzIGFueXdheS4NCj4gDQo+IC0tIA0KPiBKb3NoDQoN
CkNvbWluZyBiYWNrIHRvIHRoaXMsIHdoYXQgaWYgd2UgaG9pc3RlZCBjYWxsIHZteF9zcGVjX2N0
cmxfcmVzdG9yZV9ob3N0IGFib3ZlDQpGSUxMX1JFVFVSTl9CVUZGRVIsIGFuZCBkcm9wcGVkIHRo
aXMgTEZFTkNFIGFzIEkgZGlkIGhlcmU/DQoNClRoYXQgd2F5LCB3ZSB3b3VsZG7igJl0IGhhdmUg
dG8gbWVzcyB3aXRoIHRoZSBpbnRlcm5hbCBMRkVOQ0UgaW4gbm9zcGVjLWJyYW5jaC5oLA0KYW5k
IHRoYXQgd291bGQgYWN0IGFzIHRoZSDigJxmaW5hbCBsaW5lIG9mIGRlZmVuc2XigJ0gTEZFTkNF
Lg0KDQpXb3VsZCB0aGF0IGJlIGFjY2VwdGFibGU/IE9yIGRvZXMgRklMTF9SRVRVUk5fQlVGRkVS
ICpuZWVkKiB0byBvY2N1cg0KYmVmb3JlIGFueSBzb3J0IG9mIGNhbGxzIG5vIG1hdHRlciB3aGF0
Pw0KDQpUaGFua3MsDQpKb24=
