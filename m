Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD74B7D3F98
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 20:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjJWSzx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 14:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjJWSzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 14:55:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD1BB6
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 11:55:48 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39NHxqac027875;
        Mon, 23 Oct 2023 18:55:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=OI9/vIBHdF0OirXgElKcz7Jstc0lIRXMRB30GucHYYI=;
 b=JK0xPhw5J4qMxvhVlKzq0ChgIvrX9Ul2q1Ve1MaJygNVxg0LdDvMCGfimLCvpXERjIKe
 jeIv/S04YHH4e349e9vgvEhsVXfJLgHybkZpoD/uyFNOVZEErb3WQrv4Korc0ig9ao8p
 XezeIWLh+OFr9m+LS0YhBmCuK3m0ihcRHtkoLi+ddKEhT1lJxA+GebxbaRX2v6mA6HQx
 rDjtH0JXs/A7PYlkg/+/Ko2DZMdK+qUJwFmerahfpYu90j1+Ln7eM7yonlA0s3bywHql
 kC7pCf7nz+ddMvxLF8vy7l/Y0nwBbeyk9TkhxpSx5e+iAC5mNOc/u41S00u6KO5J66x5 wA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv76u3sry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 18:55:19 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39NHRBLp034651;
        Mon, 23 Oct 2023 18:55:13 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv534bwa1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 18:55:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ntseNiQQilCn2YZw18Cbs63GxU3PyFQzC+SuIts0ySF0IE34MAK6XBEfgCBflNSfoRL0XdT1pya6eayE/fQJ0I70fgMfHa8iE52NmIos1gboLdjL4L2l2POlLXDuin3lYKfPn4FAiac/QDe+9/yGJeGWFOsxskv/zY3kpB05SDEeNv+AzRdql+1PwKxhW2rxBGJCHmEXRB2r2w7I2tVzaUzwhgrKWEyp5biSGQAcwjMs/zh8dZsYNZaeAbaqqYnaJttqp2g17pkB8O+FikIjY+zKxuymyNK9OiQY01FxVlMWainb7sHmXhKAAeCtXMjuA0bX2VIuuQl/hdRyAupDOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OI9/vIBHdF0OirXgElKcz7Jstc0lIRXMRB30GucHYYI=;
 b=IEHhvWadZwHMqMvMpbzrQh8ZA0On7BUmL7yL+vE9n4YyHHnLwVJgHi4yjGA3QkUJrWIFamos/Wc+tu9Ri9LlfJTqWsUESHLyJ7a1jFe014YTvxQHYJm/DnMTE4WfJ7BEfvnWiZdeM3q24L4S/21RkWDuda1asZ+/TOgD2uz9UFPMEyrONmr0bAN2O3ZCgm7odQgHSlroAx/0Ay71oJn8BNqeIYmTUwBzkV2jdk4mb4FAKzEVQGqjUiHdhgvfZf/XNDfBPRq3p+8sCjB7aabDYCq6d63x1yf3UPn3OQRpL9QPAW1r8EelS1OrgZx74WDu6bRqiaNREEnKIWQQvOZiPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OI9/vIBHdF0OirXgElKcz7Jstc0lIRXMRB30GucHYYI=;
 b=XV4Jpuk9PMfWBplX1xLWi/a533tPuaR0CnyLsaoBmAnMa2m7/vcNqhkr96ZyLjNVi8HGkCNiGzzSNlwmVzrxqySysYh4u3hRZHXNs/0KGaIhfx7dvTZIFzF1vDkfBbtnUkFbhBtGTtyCILG5hGyEOiMalPpuKE+I7tgNrPRasXA=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by SN7PR10MB7104.namprd10.prod.outlook.com (2603:10b6:806:343::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Mon, 23 Oct
 2023 18:55:11 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::a39e:b72:a65a:a518]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::a39e:b72:a65a:a518%4]) with mapi id 15.20.6907.032; Mon, 23 Oct 2023
 18:55:10 +0000
From:   Miguel Luis <miguel.luis@oracle.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Eric Auger <eric.auger@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 5/5] KVM: arm64: Handle AArch32 SPSR_{irq,abt,und,fiq} as
 RAZ/WI
Thread-Topic: [PATCH 5/5] KVM: arm64: Handle AArch32 SPSR_{irq,abt,und,fiq} as
 RAZ/WI
Thread-Index: AQHaBZb73GL7k0M5w0WXQj3tQ9Z//7BXuamA
Date:   Mon, 23 Oct 2023 18:55:10 +0000
Message-ID: <7DD05DC0-164E-440F-BEB1-E5040C512008@oracle.com>
References: <20231023095444.1587322-1-maz@kernel.org>
 <20231023095444.1587322-6-maz@kernel.org>
In-Reply-To: <20231023095444.1587322-6-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|SN7PR10MB7104:EE_
x-ms-office365-filtering-correlation-id: 9bc78906-1c40-41cd-ec90-08dbd3f9955a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hpkzQz/c/d9jQ8l3gTCJUWFUA8Y2YB5TKNDEs38tgjA94tK14T7XXlwNZ/ZDHAXaF5XTw725AMGbh4E/eJfhLquMjVREZOSNpx3y1Ejft0yu9ROXnirw4g1KmrxWoeyZjhAFifa4H01PO+XY1SOg16xohhJNQxg73CwiTF8Sdh3H/yL9J8g3552jRRznWleBrT3gQnBsiYHeR/JVinSym2j6ZpQdiAI93ZMmOZfb8Ui1DdtP8A4EkRUKH0CeQF8ExXd0wKZmAPFE2nTOFRBO8YHD+qbqzS9b5+PhWx7nnaHMZc5T2rPzLY7a+uc/iNE9LINTmgiCKEgDi3Gt/2f/0IrXbccKTO3oOJLaamOvFt+ELARJkcJ/ZGRElLH4ljSh5Erc+LGD7o8EUpRC3VeQFLm7vAX9zZcr7v9G8wZTOQZ3fxORG0e04unN3e5ctNC1/TBZyk04TNdfWZwv2jAkD++xwNqAC+aJBfulvKWLh5egd6+XtYj4JWPcrz1CUFFoIK7w2wkNzHaqToNpdrfTTsL/lxYzMj/q2wrYh+iZDWtyLosKmHP1q7aQP2gLhpTyBG0ccyTlhbzlK2C1lw4XkJk/Q4zRGILUai2yE80E6zAiyh9SUSqbI4D42Uje1TBpSWD1NSnhzgQFSnq0jslkjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(376002)(396003)(366004)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(38070700009)(8676002)(38100700002)(478600001)(316002)(66446008)(66946007)(6916009)(91956017)(76116006)(54906003)(66476007)(71200400001)(66556008)(64756008)(8936002)(33656002)(6486002)(86362001)(5660300002)(44832011)(83380400001)(2906002)(4326008)(41300700001)(6506007)(53546011)(2616005)(36756003)(6512007)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZTFsUnlIRldwVW02TUs2TDJCQ2xsQ3ZESEU1SUxRSnlpZVozYnJENXgyYjFP?=
 =?utf-8?B?K05sK29BclF3dlRJc1Q1aFZOZXlKNzBJNDMxaU1ielp0R2xnbzNDWUt4aEZG?=
 =?utf-8?B?UzFnY0k0L2x4UjRFU3VEY0d1TDUxVU14MFVnaFhtRUxBbFV4VFVmV0daa0RJ?=
 =?utf-8?B?WXMxclVZNm0yU0RMNkZ3ZGM3ZFFoZlAvMWlxYjUvalpJenZkaWVrMkkyN1ln?=
 =?utf-8?B?NTNia21mZmxsa0hZRHRiMzFLd2M3bFpHQ0V3S0wyS25UR0FjVnh1a00xeERG?=
 =?utf-8?B?eUtCVGVPY1JOaUVUR0pJeG85OXRsaVZJWTFRMi9XTGVzbHFEQ1BuZDQ0UGVP?=
 =?utf-8?B?bFIzNCtyb0NyOERGYy9KNTRtTzFUL3gzclVVQ0M3dWF2MExyVmpuYUlPRVpB?=
 =?utf-8?B?akhOb1JHeXNhUWNmQWl5ZUlqM01pcUloSk1uRUdPZ1JPR3BtcWUvUURndjhR?=
 =?utf-8?B?ek5lY1l0Q0FQWFluNmV6MlNJN2dFQWJiUUVmd296LzJpRVMzbEFEM0p3Vk9H?=
 =?utf-8?B?Y0dYaG9iUnQ5L09uaDRYVzNINEFkZ2R5THhkV0tJNWt1QVN1QWI3bzlOcHVl?=
 =?utf-8?B?TmEyTnFEU2lxUm5UMzgvSkZCOTBxRjFBTWpJdVUrRUdVVTdaK1hLWU1TV2ZG?=
 =?utf-8?B?US9MZTNLS3JYOS9wSDEzdEJ4UkRqYmZ1OXdVQ0JycmN5N0VPa1BZRU0rSlpt?=
 =?utf-8?B?elNqQmcyc2pJVEE3ZkRldWpOeU1RazRsVUN3WXA3dDRZQlV0cmxsaTN2VXhD?=
 =?utf-8?B?MG5xZDRTOHFaTzhNWHRNUForN0xpcVdWUjZZT3JLbWNFQWNzZnZ2RklVN016?=
 =?utf-8?B?eGdkenErM1BLd2lpUUg2cjBaQlljM0ZsS25iWDZLL20zSXlqa29CcElPb0VT?=
 =?utf-8?B?Y3RXZFNCeElpeW9xVjlUYUQ0T1NGd3Z5UjB6Z29GS0U5Vk1xVFdGeHFxd0Fo?=
 =?utf-8?B?TjlRc29PMi80ZWpwSFJ6RTJDclZFRzNWYkRUbEZSMTV6dVpEdzQ2eFAvNmg4?=
 =?utf-8?B?OWNWNUxWVWN5U296SHVBNi9JSmFmd1hBanZmenFLeWNpbFlvNUtWUVhOcnVw?=
 =?utf-8?B?V2Q0WkZEaWRRcGNrMFh4S1RkZlpJNHJrdnVKYU9SMHFab0M1WVZxL3NrdDRi?=
 =?utf-8?B?ck1JbEtwQjl4U256ZGdPT1hmUTB6YUYxMG9tZm5EUHJJeGI3RHZxUHVEczZV?=
 =?utf-8?B?SHAvMnNFc0dhVUU4Uy91aVE4YnhEUmlIWkFnSGltbkJrOFJncHQvNEdrZ2Z0?=
 =?utf-8?B?VWhIM0hPcnNtUHcrZ1d4RU1yQlFrY1ordWw5ZUdvbHFFbWxOZUNZYVlibE9W?=
 =?utf-8?B?RjA5Um9OUEFaV09YVHZaRUhFaXlmNUJGSnVXV1AwTFNBZEhnTDZGdDE3c1h0?=
 =?utf-8?B?WktFT2ZHeHl1VDR1VlBXVGtNL2xIdkVKMmxTK0JZaW9qdjZKTnNFeC9zVk1F?=
 =?utf-8?B?alM4ZkpuRHR1a3Z0dmxjSncrdU5OeERRVEIyUlVIWVVYL1FrT05FZGpKaGVP?=
 =?utf-8?B?NUVEYVNIVENTZ1V6NFBzWmpia0tXS3B6Z0dxTVRpRUE4Y0lGNGV0TG5GWkpz?=
 =?utf-8?B?YmdRYXlMQWZGTzZseElxaVhSdFh1YkJlbmZCWlJ1amxrYzVNNUJKaVNZbWFo?=
 =?utf-8?B?U1hEQm5RWlRNOUlocWlsR1JhM09id1BvY1NtNmN0OFRFZi9HU0ZBaDFtR3pL?=
 =?utf-8?B?MGdBc2JYVGtGRm5WTGxPUHdyRGRNUE15MHNhemh3SmtqbFNVMjQ5OWV0UnUr?=
 =?utf-8?B?WUl0bEE5b04wVTFwT21WTk1KTFUxN09UK0xUZDF3eEwrOTdFYjZZRzIwdExO?=
 =?utf-8?B?bHZoK2NPWHlFS2Y0c3VSclJ3OGRuZ0N2Y2QvbjJBbktyZ2lkcmNuYVNYbVB6?=
 =?utf-8?B?QVlGcjg4N291VnpzakdCbmZGU3M4eWhOV283b0R3WVlpRGVEYWlEa1pmZUVr?=
 =?utf-8?B?TitzNGoxZW4xYmllVW1VQTRmMEFueGRFN3A1Y1M3MVdZekdOQWlzSUVLeUw3?=
 =?utf-8?B?MHFkRXFvaGFoVjFvdnNjaWdueXNxeHpNNlh5NEpWa0NIUHZKRU9jNWZQUjR1?=
 =?utf-8?B?Ty9pU01rMlJ1UklaWFRtQVdRdmhWZXFyWG05eFp5YXE5YkJrYzFObWc2c3I0?=
 =?utf-8?B?c2hvbXRkbDhUb2IxTVg3Z2FDNjdWc1hBLytkV0trR2J3dXNOMVd5czEwTnM0?=
 =?utf-8?Q?7ok10B7NeBcBrURLmzVme4o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAE7E2C285F14E42B12974FA2F8782BC@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?WmgzMnZhL1RySjRSRVBuS3h2K0NQSlQ0eVNROEt2Q1NjVjVYQUFqeHNqemlh?=
 =?utf-8?B?M1ZQd1laRWs1b3dZaHQ5S3E1aXhpUm5mWmNKdmhOY3pJN1hHczFZcUZVK0dU?=
 =?utf-8?B?TDdKTWluU1IxdVlsZlBKUVE1dTI3R2VtaHdXRElqRlo2dU9qSnBIYkFMaGVL?=
 =?utf-8?B?TENzalJGZnN5OFY5UGU5elBRL3M4SVdjcGlTS2lIWTlCaEhqVnRaZkxMKzFE?=
 =?utf-8?B?d3JIVlJpMklEMTFvb1hTdU8xd1phemNRNEE0L0xhNWxUQmllYXJtSFVMRGFq?=
 =?utf-8?B?MDJ1cDJrK1JRZWJVdVhEbVphcGNPUVFHd1p3dGJ4YnJCRkxpVk5WT3VWejVR?=
 =?utf-8?B?UzlVOTdzUENRVTFYd0srNlR6cDBFeVRvL3FDUytYQ09RRFFtT2FVQlVLK3FF?=
 =?utf-8?B?bTJpUmNaUkwycm9MOFh1TU5FK2drd083UW5EeHQwaWExOWpCWkYrVHVyempO?=
 =?utf-8?B?YVgzenpiSzdwanhGaGR4RTk5TWx5ODlOZllmMnFFVmpOclQ5T1FzR2xidjdn?=
 =?utf-8?B?WWYxaHhDSERsb2FaQ0VsdW0rU0xlS2RZYmJlcDBhc0RiR0p3MjVqaHphQWNt?=
 =?utf-8?B?ZUtKcWxPZXNrblFkRDRTZEE5c1BQcUxEZjRUdUFqTXR3VTVnRnlUeFk5QmZs?=
 =?utf-8?B?VWlLQXBDV2grM2J1MStBTllGcEFsdEtuZytTNG5rNDRVUCtITTltWXZDTFJo?=
 =?utf-8?B?RE94QVVtaGV3WjlMVUYzbnEvelhFUGNoT3Q5bmlyK2dSVVQrYVlrU3FVS3NY?=
 =?utf-8?B?R1JJYkd4a2JnaTlNWTYwT2ZxRE9XUHNHbVRMZGpiMXlzRWN0dzByTVhReXlW?=
 =?utf-8?B?ZnAydUZFSkEvRnIrc2VGTXZENU1XK1gvQTBQdU00ZVFYbEtMWktMVk1Xc1NX?=
 =?utf-8?B?S3d5a3Y0cG41eEVuNXplUTkrRHUvUUY4VC8rZ21ZOEMyKzdtYTgrUmp1N0c2?=
 =?utf-8?B?c2U5VTEvZVVrcnIzYVNzaTBuWlMwWEV2K243QnJJdjRZMmNWVWU1NVpuSzlN?=
 =?utf-8?B?MkhVQlI2NXFtTmx5ZUY4aS9WUWFKeGt5U0M4ME54bDJJamRsNmJ1MThPNGdV?=
 =?utf-8?B?RzlZV1huWFJIUWtuUWNINWg5M3VvV2ovdnhTdG1nUkp0R3RZOVdlVHdLTi9j?=
 =?utf-8?B?Zyt3akt6Y0wyZzdBOUIralRrWkhXRDhvMHlxNGY0Tkl1Sk12THJpc3h0WWRu?=
 =?utf-8?B?anhsOWZ6VnFuallLMFV1OVRtKzJWWGR4ZFRoVXhMWHFZYThUM0tzTHl6Mitx?=
 =?utf-8?B?VVh5V1VQNy91VlU2MjlYOVJFenpQV2dtd0NieXNBaS9yMTMrS0MyWENoYytl?=
 =?utf-8?Q?5PhNTquBcGhUNy5xho9+85ik75rWr7dExJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bc78906-1c40-41cd-ec90-08dbd3f9955a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2023 18:55:10.8802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U5hxLWlyk6Qc0LxO4ycWCXZmlAFMaRyXqpXZWg75M+9Sg6efmkq+S3zO2cUkzMFuF1rOUaS7+uNxHRbbCFl7uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7104
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-23_18,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310230165
X-Proofpoint-GUID: ivUWnst4_np-E4QFSQCX7ewmkVRuX-n5
X-Proofpoint-ORIG-GUID: ivUWnst4_np-E4QFSQCX7ewmkVRuX-n5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgTWFyYywNCg0KPiBPbiAyMyBPY3QgMjAyMywgYXQgMDk6NTQsIE1hcmMgWnluZ2llciA8bWF6
QGtlcm5lbC5vcmc+IHdyb3RlOg0KPiANCj4gV2hlbiB0cmFwcGluZyBhY2Nlc3NlcyBmcm9tIGEg
TlYgZ3Vlc3QgdGhhdCB0cmllcyB0byBhY2Nlc3MNCj4gU1BTUl97aXJxLGFidCx1bmQsZmlxfSwg
bWFrZSBzdXJlIHdlIGhhbmRsZSB0aGVtIGFzIFJBWi9XSSwNCj4gYXMgaWYgQUFyY2gzMiB3YXNu
J3QgaW1wbGVtZW50ZWQuDQo+IA0KPiBUaGlzIGludm9sdmVzIGEgYml0IG9mIHJlcGFpbnRpbmcg
dG8gbWFrZSB0aGUgdmlzaWJpbGl0eQ0KPiBoYW5kbGVyIG1vcmUgZ2VuZXJpYy4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+DQo+IC0tLQ0KPiBhcmNo
L2FybTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5oIHwgIDQgKysrKw0KPiBhcmNoL2FybTY0L2t2bS9z
eXNfcmVncy5jICAgICAgIHwgMTYgKysrKysrKysrKysrKy0tLQ0KPiAyIGZpbGVzIGNoYW5nZWQs
IDE3IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJj
aC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaCBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vc3lz
cmVnLmgNCj4gaW5kZXggNGEyMGE3ZGM1YmM0Li41ZTY1ZjUxYzEwZDIgMTAwNjQ0DQo+IC0tLSBh
L2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vc3lzcmVnLmgNCj4gKysrIGIvYXJjaC9hcm02NC9pbmNs
dWRlL2FzbS9zeXNyZWcuaA0KPiBAQCAtNTA1LDYgKzUwNSwxMCBAQA0KPiAjZGVmaW5lIFNZU19T
UFNSX0VMMiBzeXNfcmVnKDMsIDQsIDQsIDAsIDApDQo+ICNkZWZpbmUgU1lTX0VMUl9FTDIgc3lz
X3JlZygzLCA0LCA0LCAwLCAxKQ0KPiAjZGVmaW5lIFNZU19TUF9FTDEgc3lzX3JlZygzLCA0LCA0
LCAxLCAwKQ0KPiArI2RlZmluZSBTWVNfU1BTUl9pcnEgc3lzX3JlZygzLCA0LCA0LCAzLCAwKQ0K
PiArI2RlZmluZSBTWVNfU1BTUl9hYnQgc3lzX3JlZygzLCA0LCA0LCAzLCAxKQ0KPiArI2RlZmlu
ZSBTWVNfU1BTUl91bmQgc3lzX3JlZygzLCA0LCA0LCAzLCAyKQ0KPiArI2RlZmluZSBTWVNfU1BT
Ul9maXEgc3lzX3JlZygzLCA0LCA0LCAzLCAzKQ0KPiAjZGVmaW5lIFNZU19JRlNSMzJfRUwyIHN5
c19yZWcoMywgNCwgNSwgMCwgMSkNCj4gI2RlZmluZSBTWVNfQUZTUjBfRUwyIHN5c19yZWcoMywg
NCwgNSwgMSwgMCkNCj4gI2RlZmluZSBTWVNfQUZTUjFfRUwyIHN5c19yZWcoMywgNCwgNSwgMSwg
MSkNCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMgYi9hcmNoL2FybTY0
L2t2bS9zeXNfcmVncy5jDQo+IGluZGV4IDAwNzFjY2NjYWYwMC4uYmUxZWJkMmM1YmEwIDEwMDY0
NA0KPiAtLS0gYS9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jDQo+ICsrKyBiL2FyY2gvYXJtNjQv
a3ZtL3N5c19yZWdzLmMNCj4gQEAgLTE3OTEsOCArMTc5MSw4IEBAIHN0YXRpYyB1bnNpZ25lZCBp
bnQgZWwyX3Zpc2liaWxpdHkoY29uc3Qgc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiAgKiBIQ1Jf
RUwyLkUySD09MSwgYW5kIG9ubHkgaW4gdGhlIHN5c3JlZyB0YWJsZSBmb3IgY29udmVuaWVuY2Ug
b2YNCj4gICogaGFuZGxpbmcgdHJhcHMuIEdpdmVuIHRoYXQsIHRoZXkgYXJlIGFsd2F5cyBoaWRk
ZW4gZnJvbSB1c2Vyc3BhY2UuDQo+ICAqLw0KPiAtc3RhdGljIHVuc2lnbmVkIGludCBlbHgyX3Zp
c2liaWxpdHkoY29uc3Qgc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiAtICAgIGNvbnN0IHN0cnVj
dCBzeXNfcmVnX2Rlc2MgKnJkKQ0KPiArc3RhdGljIHVuc2lnbmVkIGludCBoaWRkZW5fdXNlcl92
aXNpYmlsaXR5KGNvbnN0IHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gKyAgIGNvbnN0IHN0cnVj
dCBzeXNfcmVnX2Rlc2MgKnJkKQ0KPiB7DQo+IHJldHVybiBSRUdfSElEREVOX1VTRVI7DQo+IH0N
Cj4gQEAgLTE4MDMsNyArMTgwMyw3IEBAIHN0YXRpYyB1bnNpZ25lZCBpbnQgZWx4Ml92aXNpYmls
aXR5KGNvbnN0IHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gLnJlc2V0ID0gcnN0LCBcDQo+IC5y
ZWcgPSBuYW1lIyNfRUwxLCBcDQo+IC52YWwgPSB2LCBcDQo+IC0gLnZpc2liaWxpdHkgPSBlbHgy
X3Zpc2liaWxpdHksIFwNCj4gKyAudmlzaWJpbGl0eSA9IGhpZGRlbl91c2VyX3Zpc2liaWxpdHks
IFwNCj4gfQ0KPiANCj4gLyoNCj4gQEAgLTIzODcsNiArMjM4NywxNiBAQCBzdGF0aWMgY29uc3Qg
c3RydWN0IHN5c19yZWdfZGVzYyBzeXNfcmVnX2Rlc2NzW10gPSB7DQo+IEVMMl9SRUcoRUxSX0VM
MiwgYWNjZXNzX3J3LCByZXNldF92YWwsIDApLA0KPiB7IFNZU19ERVNDKFNZU19TUF9FTDEpLCBh
Y2Nlc3Nfc3BfZWwxfSwNCj4gDQo+ICsgLyogQUFyY2gzMiBTUFNSXyogYXJlIFJFUzAgaWYgdHJh
cHBlZCBmcm9tIGEgTlYgZ3Vlc3QgKi8NCj4gKyB7IFNZU19ERVNDKFNZU19TUFNSX2lycSksIC5h
Y2Nlc3MgPSB0cmFwX3Jhel93aSwNCj4gKyAgLnZpc2liaWxpdHkgPSBoaWRkZW5fdXNlcl92aXNp
YmlsaXR5IH0sDQo+ICsgeyBTWVNfREVTQyhTWVNfU1BTUl9hYnQpLCAuYWNjZXNzID0gdHJhcF9y
YXpfd2ksDQo+ICsgIC52aXNpYmlsaXR5ID0gaGlkZGVuX3VzZXJfdmlzaWJpbGl0eSB9LA0KPiAr
IHsgU1lTX0RFU0MoU1lTX1NQU1JfdW5kKSwgLmFjY2VzcyA9IHRyYXBfcmF6X3dpLA0KPiArICAu
dmlzaWJpbGl0eSA9IGhpZGRlbl91c2VyX3Zpc2liaWxpdHkgfSwNCj4gKyB7IFNZU19ERVNDKFNZ
U19TUFNSX2ZpcSksIC5hY2Nlc3MgPSB0cmFwX3Jhel93aSwNCj4gKyAgLnZpc2liaWxpdHkgPSBo
aWRkZW5fdXNlcl92aXNpYmlsaXR5IH0sDQo+ICsNCg0KSeKAmW0gdHJ5aW5nIHRvIHVuZGVyc3Rh
bmQgdGhpcyBwYXRjaCBhbmQgaXRzIHN1cnJvdW5kaW5ncy4NCg0KVGhvc2UgU1BTUl8qIHJlZ2lz
dGVycyBVTkRFRiBhdCBFTDAuIEkgZG8gbm90IHVuZGVyc3RhbmQNCndoeSB1c2UgUkVHX0hJRERF
Tl9VU0VSIGluc3RlYWQgb2YgUkVHX0hJRERFTi4NCg0KQWxzbywgY291bGQgeW91IHBsZWFzZSBl
eHBsYWluIHdoYXQgaXMgaGFwcGVuaW5nIGF0IFBTVEFURS5FTCA9PSBFTDENCmFuZCBpZiBFTDJF
bmFibGVkKCkgJiYgSENSX0VMMi5OViA9PSDigJgx4oCZICA/DQoNCkZvciBteSBlZHVjYXRpb24g
b24gdGhpcyBzdWJqZWN0LCBJIHdvdWxkIGJlIHZlcnkgZ3JhdGVmdWwgaWYgeW91IGNvdWxkDQpo
ZWxwIG1lIHVuZGVyc3RhbmQgdGhpcy4NCg0KVGhhbmsgeW91DQoNCk1pZ3VlbA0KDQoNCj4geyBT
WVNfREVTQyhTWVNfSUZTUjMyX0VMMiksIHRyYXBfdW5kZWYsIHJlc2V0X3Vua25vd24sIElGU1Iz
Ml9FTDIgfSwNCj4gRUwyX1JFRyhBRlNSMF9FTDIsIGFjY2Vzc19ydywgcmVzZXRfdmFsLCAwKSwN
Cj4gRUwyX1JFRyhBRlNSMV9FTDIsIGFjY2Vzc19ydywgcmVzZXRfdmFsLCAwKSwNCj4gLS0gDQo+
IDIuMzkuMg0KPiANCg0K
