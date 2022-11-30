Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A986463D7CA
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 15:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiK3OKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 09:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiK3OKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 09:10:13 -0500
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E7A91C3D;
        Wed, 30 Nov 2022 06:08:25 -0800 (PST)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AU9k080003021;
        Wed, 30 Nov 2022 06:08:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=R+uqNTDF/LgX34Rn7OSbEHb33Qwoy4ysKqOMe+lRj2I=;
 b=NnnCbAGS+Bv7CjT2Vzj0LhkN2u4aWzvqf3qdgO6lDPFBRD+nq0RHxKZjJ4CPlDmSfo9Q
 CLACwA4+9p0q4LslEzxtWCut6Qr45u6HQeTirnX85p5cEhLlmpHoZQcG3HwPO9qkgGnB
 aZpSTpuFmoApaMKZb6rgBfCEu0yM8yAPPuHdAI4K5ltHm8d3cmE+/MIaPASfCSqS9mS4
 CuNMulBx2RewJO8ioQsN16RFVp19b3A+uXs0WUP7yr/x9MN3aHQRgW+YsC0xfaLtW3GC
 5U/zz8mLnC6fuUsUVJ2D1fa1WQcPZtMHdjeaQ42Rv6ufN+0jTrZda9ENCAJQwKrW3M5e vA== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3m3hsqsw6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 06:08:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCom8j21R+0O18oYgnPLU+LoBzLPA9Hdk+mYJ3+j1mQKpdC2cCyfNCBFqypcAF+24JwSQqX6tINC5x/14OOk//ywxX1n5nWHvULdiiVrop1YuFLEPoaulij4KtcNqYT06Kirrh3cYnNZKoUo3JbbsfA9w6lzM45Q9T/HcgIZ3vquJ+qFaN0n2OHBAK5IYHD8QsxH5XUuEynPzb/IC2Ke5INBFpsC9HOpz/FhBltXXjd/cruJBn9wj5oJZsSdFEQkVN8NAmFrsh9L3loQlIAzZkpX9NuWDOIWQsV9LmwV2lfNfqRic7jjaEY58+Cuhiz8dUDItlu7NnEOuuYUSnmwtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R+uqNTDF/LgX34Rn7OSbEHb33Qwoy4ysKqOMe+lRj2I=;
 b=MbFEC5okXVHmw1zybSIOAlAUWBXQY0Yn1801LEGo+Yljjet+/OeMgk/8a+8FmIN910DxHEPGpXBQKPyestj061XOux9WewwuhI+wCD3pGEpOVLY4F1uAcpu0bATBeFrzi2Vxds3028pD6fvUArWBEJajq5KASxL//gOVg6i79X+sj3ghnawEO6qZ7PFLB14TW2LFAkOdqu+npQNVDtiGGgGQC78PTH12Sjus68ZXrLXcJkyA43iWlEkecfnJyBzZ4jGm6YNVVKdYbLq6ej5jS3pRpodkpu3UvINRIjWQQ88F2+S6oAC8tAuSotqq6ZOYN4qXWz75Ihrc1T91gSVaRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R+uqNTDF/LgX34Rn7OSbEHb33Qwoy4ysKqOMe+lRj2I=;
 b=u8NSFmbXqpopH/Fw5pw26nNghijbRhu0tJk+61hW1LjMi3zqubVCFnOi2VJHDXfQzHJIyEH9eKnbf0+CopnPe18VW3zS2wGrJ9SyRqjDyow4A560po28xCBfwEBsSVaRttjlJbV0WNgq3b9oOgYFJJ5Sjk4Jsz6ZTogrti5RpiZh89EzEB+wg7/ipDbpX/mkBk0CbGCSzZDzyPu5auKjKNhq4IWhnsLTWZXDMdQe1t7KsCQP3nyeDYgJ6NnxECvX3r1uw8wdRWQODhAJsE1H0jkl6YvQIj5TdOzbSfXP7rm3Lb/e56mdxpf+5y4EDmKYQVxwtmZDzILMzjICLV+DcA==
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by IA0PR02MB9124.namprd02.prod.outlook.com (2603:10b6:208:43c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 14:07:58 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::ea4d:10a4:a7a4:9567]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::ea4d:10a4:a7a4:9567%6]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 14:07:57 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Chao Gao <chao.gao@intel.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: X86: set EXITING_GUEST_MODE as soon as vCPU exits
Thread-Topic: [PATCH] KVM: X86: set EXITING_GUEST_MODE as soon as vCPU exits
Thread-Index: AQHZBB+UbwHM6Ykv6ESmts8I/MP46K5XAf2AgACAD4A=
Date:   Wed, 30 Nov 2022 14:07:57 +0000
Message-ID: <7248AC8C-FB3A-48D0-8DB2-F96CB6C15C17@nutanix.com>
References: <20221129182226.82087-1-jon@nutanix.com>
 <Y4b4UURccshroVV9@gao-cwp>
In-Reply-To: <Y4b4UURccshroVV9@gao-cwp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR02MB4579:EE_|IA0PR02MB9124:EE_
x-ms-office365-filtering-correlation-id: c962b578-f481-41f0-39a0-08dad2dc48a0
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1QJz2eydkqPLs06dwMY/WmfAkHnGxDjq/5j33EnSW15saxWVNu0gepGp7LEmNphK0SeNjOAoiUiOXGMbN96N2hJBhy4wVf9/lGtCvqd97dyJZm7+9FNGcl1+5fkhOqETy4m1OesbsSO/qxJwvLl1/+ytYYpMox8t57uhkKUFvjRj2c5Pm0hlfUeTgDCghW8y/9Rct+LaakMiznyBlStKhhV5EOQEX7ga2GFniweqVFdT1M1EOx+mYWs+7gOhhZUmS91IoS2GzRlOO7shUes5/X0f3pqBbawMWoSKNKeEOI/0PFbzJ/IjPer8x6nK3ORm8UHtgeNnqVmxpxvNO537uoWJPNEo/WRNPdkwNT1gJIck/ydWwC9FRcNgOQNItz7uazMaPg/A1xVDylBw5M6JmvwReDGZHbgBX+cBc99D/PVjNwSoDmPkXiCnbyOSV/H7SEZlznHBGvy5Rv36LMXcG0qlXVnjrzaM5IZ/yYa4UxMqKab6muY+cx4zDw3CXOVhsnUX0wS3pz4V2Ynq3/HRgbIto1B1VMPl8F2rm/Idc/k6fKSn8EsgRWHukVNl1VfKuCefWyx6rrTEtpwNTzRSZ/39rqbvnrEge1Y1Vz1wJn35uZcm9Vyq/M27VzjkeX5wHd6mKksyuNuLeRDc2s2grXaNR/gLuFjVolKUmd/jcnbircwtMz0vvuokI1f4c7vwGIekh3jJbUqw6H7WhGI0h/7bB5137GZoI2ixwCznrd8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(366004)(39860400002)(376002)(136003)(451199015)(71200400001)(8936002)(33656002)(316002)(5660300002)(66946007)(76116006)(66476007)(36756003)(8676002)(66556008)(41300700001)(54906003)(64756008)(7416002)(66446008)(6916009)(83380400001)(122000001)(86362001)(38100700002)(38070700005)(6486002)(478600001)(6512007)(2616005)(53546011)(186003)(6506007)(4326008)(2906002)(66899015)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?azFVcjcvY2ZQMFV0VE43YVdxZEUrNlJCeDNPVjZoTm1ROEhtZjRyY0xKMXNv?=
 =?utf-8?B?WEZlMHdHWnMveHZhclBjbVR5d0FzOTVvZGxOd2VjUllVOXJtNndDc29SRDY5?=
 =?utf-8?B?RTJsekRLZmtOemwyQ1QrR3NhUXpKYjdPS1ZIS0JRSHc1UHRWV0xqcFFFeEdF?=
 =?utf-8?B?VEUvdUdFNW0xNUtpOUY4Y05HMC9VV3A5USs2UE5CZU1qSDZHVFRRWUVsVDNV?=
 =?utf-8?B?M01tSmlqQkROb1JQMEM2MWlzdURNN2hCdFFVNU45VDc1UldUWXZNWnpmTmdJ?=
 =?utf-8?B?UEUyQktUWVl5RjVkd2VTQ1R6c2hHK1oxT0lZWU95bUY4d1pHRmxVYlY5RWpO?=
 =?utf-8?B?RkFmZGlNMjI0UkFuNS9EQ01xSFhMaHZKTi9RdVhqUUdpRU9OWEcwcEJtbUQr?=
 =?utf-8?B?ZUZtT1FoN1o3MU1BTFlVaTRqTktWVk9CbERYSDA4R2hkMGM4SFJPOHhsQnJX?=
 =?utf-8?B?UEY0dVpVcGhBOEQzdXFMVmNaN3IrNjBFaUsvbkpaU01GaUhBZmJmZnRuYndu?=
 =?utf-8?B?bzJ4ek44dzlSc2I2STMvd1dqeWNReFVKeU5NcEFzdis5YTRPZXZGNG12Y2Y5?=
 =?utf-8?B?a0xxT3ZzQWNLYlVmWUV1M2VCTWZhRm9HZW92Tnh5ZjRlVGhQSGVlb3UrM2Vp?=
 =?utf-8?B?aTZwZ3NLb3pvcFhzVFJDeEtsU0JkQ0syTWQxRWdCZlNxQmp2QU1RZkd4dUZj?=
 =?utf-8?B?SXR1YTEvRk93OTEwYXJJYlB5MjkyaTI5dk84SG5LMitFOGVOZlRHWVd1bzdL?=
 =?utf-8?B?ZnZ4UHlub3JQZFhQcHBaVHRHYXJhNXpxTk1WeWUwcm9vb3ZZeldBTHpMemJT?=
 =?utf-8?B?Z0Q2U3NaOG1UL3VmZXJEVHZyMktCODUwWXFEVlI2SEJpQ21HNEhNS3NJbDJ5?=
 =?utf-8?B?MmlWM2Q5czNneStzbk9UUDdCRDNhWVBaSnpBTmRBaDZWVHBiNlEwV3ViS3M1?=
 =?utf-8?B?STArRGxWOCt1dmZiZGx6aUN3YUFYc290azlkNlptN01icUw5VWlTYm5NdFVi?=
 =?utf-8?B?SFZuY0EwRzVBQUF2SUtHNVdaNHlBOUs1MUx6b0dmTk4veWJyT25zaHlUdW1z?=
 =?utf-8?B?WGZWc3RXTDk0YTZaQjd5NStNRUNlQkFRcFR0Y3orTDlJK04zWW9ISllSZU1p?=
 =?utf-8?B?anhqYTNvTytwR1d3N1VobXlkdE01VjZrOFduY1RrbnBQbWlnMWRxTVc5NnhO?=
 =?utf-8?B?RXI1R0JIRmFwZG9HZzRTRnJNRUlyR2RmQUZHN1p5dndlVFlMUU00eDVnYjIz?=
 =?utf-8?B?RzFyUXBjTGZPVHVTMjg5U2haMzk0M2d6SmFIMTNwYm0wL2U2eUc2Z3RYSFZy?=
 =?utf-8?B?TE1va01rMDErT01lZkVQeWp0cEU5TUVTTGtkZW13MnByUTRwZnNDQ3hQMHNl?=
 =?utf-8?B?UDZ6REErQ2xkT2ZkYjU0dzN4RVREMnpsVVN5ME9IeG1DQ3JYWG9sdE5BYWpP?=
 =?utf-8?B?eUlQZE1SOGxDZkJpYmFid0xaajNidHVCVFM4SnZBOXd4NnB6UXRSQTFpQ0xa?=
 =?utf-8?B?Y0dSS1ZCdWp1bmtkQ0locDRmV014KzBVVUdvN2lTVDV3REJsVkFoYWVNUm1m?=
 =?utf-8?B?eG9Ja2ozME5xZ0thaGVVWWo0cnVOaTFyQkhEZFlzc2hnR3MvdG9rTUZqdzdl?=
 =?utf-8?B?dXVZR25BYzI5ams3T3o5S3lvU0xHaDJEbnRZUFp5bGplVTFCM3hPZVZzN0ty?=
 =?utf-8?B?T2c4bXc0eUVaL1pOWmNVY3hrWkRXa0xSbWdiWEpzMjNXQlpkSjFBQ2lsUEZL?=
 =?utf-8?B?Zm9NZDFFY2FNbnlnWGNEbi8yOG5iTkgwR1VJV3Q2UUZMT0x5K0pBTk5PNy9F?=
 =?utf-8?B?b21NMk1Ocm5KU3hkTHYyVm45ZnZwa25uQlR5TWNZM0I3OTk2azMyajdsNExF?=
 =?utf-8?B?VVZIZS8xdDJQZ2dZdmN4UEMzREFKTkhtSFJMUWpuUEJSZVZxb2VuazlnSDVH?=
 =?utf-8?B?bjZxdUhyUUtseXI2dS9yQTlqbDNZRVkxNXNrdzFmenFaRmg0QkVteS9yYzJl?=
 =?utf-8?B?OWpCclVuQ3RvbVRST2ovZFllWTIwZDN4ZHRTZmV6ak1wY1hjd3JmcTd6SmNy?=
 =?utf-8?B?dk13ZXRIZXRCVEhpaFZIbVRvNFJ3Vi9Id21XWDhVNTE0T25pU1RHUFNvOERF?=
 =?utf-8?B?czBxSy9VWVBJWERHY005SFMvMkxWWHhHb1I3Y1BIQUdNekpQREVIMzJrVndv?=
 =?utf-8?B?dDAzdE5LMHlUalB2bzQ4Nm5aakRPaUxnbGdjc1Z5eUZMM3BTT2RtQVVERHBi?=
 =?utf-8?Q?Zz/yJfobYgUXPPDYPKsK4EyGLNtEIWg8YLFFgP+cqA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F3A74F1554EB34DAF4DEE8EB69CE057@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c962b578-f481-41f0-39a0-08dad2dc48a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 14:07:57.9288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5WRa1TF+ZQS3P91DLPCbE/EBATlb6KNaRfAHXhEd4BGUKimCfWsnKgKKz24UXdaalyP5nt2sKeSuj7QRguFDGayhauehQrRXckvyfMDkMFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR02MB9124
X-Proofpoint-ORIG-GUID: OWg8-tXOJ87CQeUcCf69749XrwnNse0J
X-Proofpoint-GUID: OWg8-tXOJ87CQeUcCf69749XrwnNse0J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTm92IDMwLCAyMDIyLCBhdCAxOjI5IEFNLCBDaGFvIEdhbyA8Y2hhby5nYW9AaW50
ZWwuY29tPiB3cm90ZToNCj4gDQoNCkNoYW8gd2hpbGUgSeKAmXZlIGdvdCB5b3UgaGVyZSwgSSB3
YXMgaW5zcGlyZWQgdG8gdHVuZSB1cCB0aGUgc29mdHdhcmUgc2lkZSBoZXJlIGJhc2VkDQpvbiB0
aGUgVlREIHN1cHByZXNzIG5vdGlmaWNhdGlvbnMgY2hhbmdlIHdlIGhhZCBiZWVuIHRhbGtpbmcg
YWJvdXQuIEFueSBjaGFuY2UNCndlIGNvdWxkIGdldCB0aGUgdjQgb2YgdGhhdD8gU2VlbWVkIGxp
a2UgaXQgd2FzIGFsbW9zdCBkb25lLCB5ZWE/IFdvdWxkIGxvdmUgdG8gDQpnZXQgb3VyIGhhbmRz
IG9uIHRoYXQgdG8gaGVscCBhY2NlbGVyYXRlIHRoZSBWVEQgcGF0aC4NCg0KDQo+IE9uIFR1ZSwg
Tm92IDI5LCAyMDIyIGF0IDAxOjIyOjI1UE0gLTA1MDAsIEpvbiBLb2hsZXIgd3JvdGU6DQo+PiBA
QCAtNzAzMSw2ICs3MDQyLDE4IEBAIHZvaWQgbm9pbnN0ciB2bXhfdXBkYXRlX2hvc3RfcnNwKHN0
cnVjdCB2Y3B1X3ZteCAqdm14LCB1bnNpZ25lZCBsb25nIGhvc3RfcnNwKQ0KPj4gdm9pZCBub2lu
c3RyIHZteF9zcGVjX2N0cmxfcmVzdG9yZV9ob3N0KHN0cnVjdCB2Y3B1X3ZteCAqdm14LA0KPj4g
CQkJCQl1bnNpZ25lZCBpbnQgZmxhZ3MpDQo+PiB7DQo+PiArCXN0cnVjdCBrdm1fdmNwdSAqdmNw
dSA9ICZ2bXgtPnZjcHU7DQo+PiArDQo+PiArCS8qIE9wdGltaXplIElQSSByZWR1Y3Rpb24gYnkg
c2V0dGluZyBtb2RlIGltbWVkaWF0ZWx5IGFmdGVyIHZtZXhpdA0KPj4gKwkgKiB3aXRob3V0IGEg
bWVtbW9yeSBiYXJyaWVyIGFzIHRoaXMgYXMgbm90IHBhaXJlZCBhbnl3aGVyZS4gdmNwdS0+bW9k
ZQ0KPj4gKwkgKiBpcyB3aWxsIGJlIHNldCB0byBPVVRTSURFX0dVRVNUX01PREUgaW4geDg2IGNv
bW1vbiBjb2RlIHdpdGggYSBtZW1vcnkNCj4+ICsJICogYmFycmllciwgYWZ0ZXIgdGhlIGhvc3Qg
aXMgZG9uZSBmdWxseSByZXN0b3JpbmcgdmFyaW91cyBob3N0IHN0YXRlcy4NCj4+ICsJICogU2lu
Y2UgdGhlIHJkbXNyIGFuZCB3cm1zciBiZWxvdyBhcmUgZXhwZW5zaXZlLCB0aGlzIG11c3QgYmUg
ZG9uZQ0KPj4gKwkgKiBmaXJzdCwgc28gdGhhdCB0aGUgSVBJIHN1cHByZXNzaW9uIHdpbmRvdyBj
b3ZlcnMgdGhlIHRpbWUgZGVhbGluZw0KPj4gKwkgKiB3aXRoIGZpeGluZyB1cCBTUEVDX0NUUkwu
DQo+PiArCSAqLw0KPj4gKwl2Y3B1LT5tb2RlID0gRVhJVElOR19HVUVTVF9NT0RFOw0KPiANCj4g
RG9lcyB0aGlzIGJyZWFrIGt2bV92Y3B1X2tpY2soKT8gSUlVQywga3ZtX3ZjcHVfa2ljaygpIGRv
ZXMgbm90aGluZyBpZg0KPiB2Y3B1LT5tb2RlIGlzIGFscmVhZHkgRVhJVElOR19HVUVTVF9NT0RF
LCBleHBlY3RpbmcgdGhlIHZDUFUgd2lsbCBleGl0DQo+IGd1ZXN0IG1vZGUuIEJ1dCAuLi4NCg0K
SUlSQyB0aGF04oCZZCBvbmx5IGJlIGEgcHJvYmxlbSBmb3IgZmFzdCBwYXRoIGV4aXRzIHRoYXQg
cmVlbnRlciBndWVzdCAobGlrZSBUU0MgRGVhZGxpbmUpDQpldmVyeXRoaW5nIGVsc2UgKndpbGwq
IGV2ZW50dWFsbHkgZXhpdCBvdXQgdG8ga2VybmVsIG1vZGUgdG8gcGlja3VwIHdoYXRldmVyIG90
aGVyDQpyZXF1ZXN0cyBtYXkgYmUgcGVuZGluZy4gSW4gdGhpcyBzZW5zZSwgdGhpcyBwYXRjaCBp
cyBhY3R1YWxseSBldmVuIGJldHRlciBmb3Iga2ljaw0KYmVjYXVzZSB3ZSB3aWxsIHNlbmQgaW5j
cmVtZW50YWxseSBsZXNzIHNwdXJpb3VzIGtpY2tzLg0KDQpFdmVuIHRoZW4sIGZvciBmYXN0IHBh
dGggcmVlbnRyeSBleGl0cywgYSBndWVzdCBpcyBsaWtlbHkgdG8gZXhpdCBhbGwgdGhlIHdheSBv
dXQgZXZlbnR1YWxseQ0KZm9yIHNvbWV0aGluZyBlbHNlIHNvb24gZW5vdWdoLCBzbyB3b3JzdCBj
YXNlIHNvbWV0aGluZyBnZXRzIGEgd2VlIGJpdCBtb3JlIGRlbGF5ZWQNCnRoYW4gaXQgc2hvdWxk
LiBTbWFsbCBwcmljZSB0byBwYXkgZm9yIGNsYXdpbmcgYmFjayBjeWNsZXMgb24gdGhlIElQSSBz
ZW5kIHNpZGUgSSB0aGluay4NCg0KPiANCj4+ICsNCj4+IAl1NjQgaG9zdHZhbCA9IHRoaXNfY3B1
X3JlYWQoeDg2X3NwZWNfY3RybF9jdXJyZW50KTsNCj4+IA0KPj4gCWlmICghY3B1X2ZlYXR1cmVf
ZW5hYmxlZChYODZfRkVBVFVSRV9NU1JfU1BFQ19DVFJMKSkNCj4+IGRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4+IGluZGV4IDI4MzViZDc5NjYz
OS4uMGUwZDIyOGYzZmE1IDEwMDY0NA0KPj4gLS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jDQo+PiAr
KysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4+IEBAIC0yMTYwLDYgKzIxNjAsMTQgQEAgZmFzdHBh
dGhfdCBoYW5kbGVfZmFzdHBhdGhfc2V0X21zcl9pcnFvZmYoc3RydWN0IGt2bV92Y3B1ICp2Y3B1
KQ0KPj4gCQlkYXRhID0ga3ZtX3JlYWRfZWR4X2VheCh2Y3B1KTsNCj4+IAkJaWYgKCFoYW5kbGVf
ZmFzdHBhdGhfc2V0X3RzY2RlYWRsaW5lKHZjcHUsIGRhdGEpKSB7DQo+PiAJCQlrdm1fc2tpcF9l
bXVsYXRlZF9pbnN0cnVjdGlvbih2Y3B1KTsNCj4+ICsJCQkvKiBSZXNldCBJTl9HVUVTVF9NT0RF
IHNpbmNlIHdlJ3JlIGdvaW5nIHRvIHJlZW50ZXINCj4+ICsJCQkgKiBndWVzdCBhcyBwYXJ0IG9m
IHRoaXMgZmFzdCBwYXRoLiBUaGlzIGlzIGRvbmUgYXMNCj4+ICsJCQkgKiBhbiBvcHRpbWl6YXRp
b24gd2l0aG91dCBhIG1lbW9yeSBiYXJyaWVyIHNpbmNlDQo+PiArCQkJICogRVhJVElOR19HVUVT
VF9NT0RFIGlzIGFsc28gc2V0IHdpdGhvdXQgYSBtZW1vcnkNCj4+ICsJCQkgKiBiYXJyaWVyLg0K
Pj4gKwkJCSAqLw0KPj4gKwkJCWlmICh2Y3B1LT5tb2RlID09IEVYSVRJTkdfR1VFU1RfTU9ERSkN
Cj4+ICsJCQkJdmNwdS0+bW9kZSA9IElOX0dVRVNUX01PREU7DQo+IA0KPiAuLi4gdGhlIHZDUFUg
ZW50ZXJzIGd1ZXN0IG1vZGUgYWdhaW4uDQo+IA0KPiBJIGJlbGlldmUgbW9kZSB0cmFuc2l0aW9u
IGZyb20gRVhJVElOR19HVUVTVF9NT0RFIHRvIElOX0dVRVNUX01PREUNCj4gZGlyZWN0bHkgaXNu
J3QgdmFsaWQgZm9yIGN1cnJlbnQgS1ZNLg0KDQpZb3XigJlyZSBjb3JyZWN0IHRoYXQgd2UgZG8g
bm90IGhhdmUgdGhpcyBwYXR0ZXJuIGluIEtWTSB0b2RheTsgaG93ZXZlciwgSSBjb3VsZG7igJl0
DQpGaW5kIGFueXRoaW5nIGluIHRoZSB2Y3B1LXJlcXVlc3RzIGRvY3VtZW50YXRpb24gdGhhdCBz
cGVjaWZpY2FsbHkgc2F5cyB0aGlzIGlzbuKAmXQNCkFsbG93ZWQuIEZ1cnRoZXJtb3JlLCB0aGlz
IHJlYWxseSBpcyB0aGUgc3Bpcml0IG9mIHdoYXQgd2XigJlyZSBkb2luZywgZS5nLjoNCg0KV2Ug
YXJlIGluZGVlZCBleGlzdGluZyBndWVzdCBtb2RlLCBidXQgYmVjYXVzZSB0aGVyZSBpcyBhIGZh
c3QgcGF0aCwgd2UgYXJlbuKAmXQNCmV4aXRpbmcgYW55bW9yZSwgc28gd2UgbmVlZCB0byBmbGlw
IHRoZSBzdGF0ZSBiYWNrIHRvIGluIGd1ZXN0IG1vZGUuDQoNClRoaXMgY29kZSBqdXN0IG1ha2Vz
IHRoYXQgc2VudGltZW50IGNsZWFyIGluIGNvZGUsIGFuZCBqdXN0IHNvIGhhcHBlbnMgdG8gYWxz
bw0KZnVydGhlciBzdXBwcmVzcyBJUEkgc2VuZHMgZHVyaW5nIHRoYXQgc21hbGwgd2luZG93Lg0K
DQo=
