Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53A33669E7
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 13:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbhDUL3w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 07:29:52 -0400
Received: from mail-db8eur05on2065.outbound.protection.outlook.com ([40.107.20.65]:65217
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233959AbhDUL3t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 07:29:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/JkPs7n3ANCVaro2zObfywa+L35m8Vvz4fCFOZs+aN8=;
 b=gQISjukU+7w6nNXeku77Lr1oVVuPnhCR9hQQIWSglefTX6f56H+D1s1rl2hW5LhhQ5BAj1st/+xImeQphFKAW3syF3LhyuwM3KN1Xe2WmO0z6fcsfZLlQhgwHPTpIRYmzc9NFQNZ0w2+s5P3Rqhm4sBNhqP137387j9MDZQzkgQ=
Received: from DB6PR07CA0165.eurprd07.prod.outlook.com (2603:10a6:6:43::19) by
 PAXPR08MB6430.eurprd08.prod.outlook.com (2603:10a6:102:156::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Wed, 21 Apr
 2021 11:29:13 +0000
Received: from DB5EUR03FT015.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:6:43:cafe::10) by DB6PR07CA0165.outlook.office365.com
 (2603:10a6:6:43::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.8 via Frontend
 Transport; Wed, 21 Apr 2021 11:29:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT015.mail.protection.outlook.com (10.152.20.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 11:29:12 +0000
Received: ("Tessian outbound 47ca92dabae7:v90"); Wed, 21 Apr 2021 11:29:12 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 73a7eb35e3f44aed
X-CR-MTA-TID: 64aa7808
Received: from 774844412faa.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id D972EEA4-5C2B-467C-B0E0-6CB2E512D171.1;
        Wed, 21 Apr 2021 11:29:04 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 774844412faa.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 21 Apr 2021 11:29:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ci3yIpCB6rIg6mUO6Oq79Hp5wcffIHobHxFaHf6ilbSx9e0a9WnyAhtlVBg9m5d5RihjsgTg9zfhBetagwHt2D2HCj3JU1rS4uhEPRSU5yBY09ykyDcyQw5wpmiQDc2yz0bWU2mVSRKtvdpOwJd3MGtCAJ8V2R+fjhXPHuNzhY48A06lp5vTMzCbhtHXJYqI7PUKE5weqm0UOUf4IuyCRkRo/SQE/QpU+I5arNPf6DKE1GVjBixoPfWMsloftYtf5KrxLizMNVlhBkGmVNp1HJEW101aaDOP5S1kgHIJKrnaQbRBwdXdefKWrqer2XFIbsCCs17/MBkxcDaspc76lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/JkPs7n3ANCVaro2zObfywa+L35m8Vvz4fCFOZs+aN8=;
 b=Yn4UyRimtBWfZk4bzUm7gkmucCWxLa/hzNYyAK9K5On//3Ax6zWuLGw5LM4zhU5OUzQQE4/wm+fotSaaN7+NAnqrblkSlWa8ec5RfOu9yA3us/nR0PMDDFofBQ6GVl9KnPrGsgd9kcbsLtSJ0YRrbYDNWNZrcWQ/wmd6pVCPQq7XCkdFXRxWZeiIcsFamWH/jIFN1bBlmMpxtrMHNJByDkZuGBISl1gPd9wApuC5RaTx2Pas2xufLeB7by+F/eXaFxJ7S35Di48mEvRUTbTfWsl/wAExCy78mJNXxXYkHXE4IWdluMBu+e48WBPBZPR8M+bZWXzymtDuqPiGeWLe0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/JkPs7n3ANCVaro2zObfywa+L35m8Vvz4fCFOZs+aN8=;
 b=gQISjukU+7w6nNXeku77Lr1oVVuPnhCR9hQQIWSglefTX6f56H+D1s1rl2hW5LhhQ5BAj1st/+xImeQphFKAW3syF3LhyuwM3KN1Xe2WmO0z6fcsfZLlQhgwHPTpIRYmzc9NFQNZ0w2+s5P3Rqhm4sBNhqP137387j9MDZQzkgQ=
Authentication-Results-Original: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=arm.com;
Received: from DB6PR08MB2645.eurprd08.prod.outlook.com (2603:10a6:6:24::25) by
 DB8PR08MB5242.eurprd08.prod.outlook.com (2603:10a6:10:e8::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.20; Wed, 21 Apr 2021 11:28:59 +0000
Received: from DB6PR08MB2645.eurprd08.prod.outlook.com
 ([fe80::c0b9:9af:f4ab:768c]) by DB6PR08MB2645.eurprd08.prod.outlook.com
 ([fe80::c0b9:9af:f4ab:768c%6]) with mapi id 15.20.4065.021; Wed, 21 Apr 2021
 11:28:59 +0000
Subject: Re: [PATCH v15 00/12] SMMUv3 Nested Stage Setup (IOMMU part)
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        maz@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
        alex.williamson@redhat.com, tn@semihalf.com, zhukeqian1@huawei.com
Cc:     jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        wangxingang5@huawei.com, jean-philippe@linaro.org,
        zhangfei.gao@linaro.org, zhangfei.gao@gmail.com,
        shameerali.kolothum.thodi@huawei.com, yuzenghui@huawei.com,
        nicoleotsuka@gmail.com, lushenming@huawei.com, vsethi@nvidia.com,
        chenxiang66@hisilicon.com, vdumpa@nvidia.com,
        jiangkunkun@huawei.com
References: <20210411111228.14386-1-eric.auger@redhat.com>
From:   Vivek Kumar Gautam <vivek.gautam@arm.com>
Message-ID: <1d5d1c0e-9b2f-cf47-96df-9970aa3ec58c@arm.com>
Date:   Wed, 21 Apr 2021 16:58:48 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210411111228.14386-1-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [217.140.105.56]
X-ClientProxiedBy: PN1PR0101CA0044.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:c::30) To DB6PR08MB2645.eurprd08.prod.outlook.com
 (2603:10a6:6:24::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.162.16.71] (217.140.105.56) by PN1PR0101CA0044.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:c::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 11:28:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce8b1281-86f0-4f34-f321-08d904b8b069
X-MS-TrafficTypeDiagnostic: DB8PR08MB5242:|PAXPR08MB6430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PAXPR08MB6430E00A1A49C6E13846E6D689479@PAXPR08MB6430.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: buZjrO4Qcn4/wCul0HHuODFGQunDZWAIggVyX0HdpI0V7b+yvFFXVFHCUU7fGQwL6tJ+DOhipr6TYp0nSRQi6ngee9FuKsvXqWgVuHfoGCuqO39qBA1iJzH+KQ0DyuU8ylC1yoBgjsr7NESOKVCAW5jFC3+HHtRpbElrNJ8inONqvzad4v1x128yIz1aeS7WWvB5r9EXJuOQSqJCe08Y7p/6pcyPQNz0wnH5eD048bXmYHHxcHDZm2MnqweU3BBo9jNx3HSvG16Sa37uxiwpOBSBjGn87nCc3Yuhw73G9V9nv9GSqU9M+8i7JOadgirZeVVx3SpgTft+cmYvdleKI26BH69RqbhzSygYLdDEHuhnHHVcr2wb3PF3rj4igdDFEzdCUVuLdsjVp2yNze18eyRRr9sNiE9tFPnNXd2yGWVQ/XQDKX4FhE+jcTF4OKd8JnxjNZVzrs5oQh5UW9BzMhWUOfw+D+SPo7/qtRr4esU1OTqQfp4wC7cimEDzOobsq4gyiIrOooFiNz0wYriIirxs367fu9YagUTgzUzKVxpaeQp4mHMhkU0QB7FNTXX/m8mKEwjAIcKty7Hff8pMrFIrpc8jM5rxTY38sR2Pnw5wM82xN1BJ2anBtRVphBNdhzYe8Ty75LzjEAjCzmOwm7avgy1MdT4ojPfhPqmmkUKpKRv49prEIR5UpNv+RgQkZVyPqboyGnPwsCXebZkU3DUAaNFEt0td9HC9qlSIdB/6XfkEo5wl7m5E0NR20abKwXmliAu/ro4b7BeVNnJ4TmCXoYkFXJumT7GbzGfDzPhbJvSr6Eo2040K/gcabChm
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR08MB2645.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(396003)(136003)(376002)(346002)(26005)(52116002)(316002)(53546011)(36756003)(4326008)(16526019)(6486002)(8676002)(7416002)(921005)(478600001)(86362001)(38350700002)(6666004)(2616005)(16576012)(8936002)(2906002)(956004)(31686004)(31696002)(186003)(66556008)(66476007)(5660300002)(966005)(83380400001)(66946007)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?U3ZTbnlwZ3lhYm8rM2czeXBoSTFCNGh2eUY0K1V4aDFpYk93cEVzZnRGTkxz?=
 =?utf-8?B?eVpwZlRhU3l6N3p5b2NwZVJXa1RDbDh2VE5tYU5GajVXN0xjRTMxaDdlc09w?=
 =?utf-8?B?dVFRQVZYeTV3NEdJMnY5YkdhTXFDcWd1MVl6cmVodTVvcXRNUmhnY1htVkpW?=
 =?utf-8?B?V0d4cWdFRGkranNTM2ZkNndKMVBZTU8xQmkrYnBqc3pJNjh5dGhGZHVDYlBP?=
 =?utf-8?B?Q0ZjNExlUUQyRkNNMm5mWUphamRsdU1HY3ExRFF0bVhzUkJnekFwQmtQZVI2?=
 =?utf-8?B?cE1maGZ4cnpzNmZuM05Pd0s4NXJZQ2xUZHpkWEl6cDNEd1pLRy85SGlPQTRz?=
 =?utf-8?B?QVpOeXR6MmFwQ1FKRGl0VEVrQS8vU1BRZFJCNUtkYzRqVjJ0QjRxQWxrNEFa?=
 =?utf-8?B?MGtmYmVtVjVDc2VncXdiYzZ0Rk10N1E4Zy90VHBkTUQwR1hpU1hEWEp6cmJ6?=
 =?utf-8?B?UUdRYWhkQ2Ftc29zY0VCNFQzRzBGRzZsR2hPaWJ3WDRwQzdRVGVrZVpzdWxW?=
 =?utf-8?B?b2ZCSnNaeXVwNXlrNSsvV05ndHJoZTRjb3hPZFVGWVMySkZaQTlTOWZxL2F2?=
 =?utf-8?B?bGlhbWRXVDFlUUREaVZQMkp2dmt0VGoyQWlpSWFlY1NJaUo3UGxOUzhEbkNo?=
 =?utf-8?B?K2NhcXAxNGc3VlRvckIxRGgwazFjMDFpRFZ4bU5BNDkvSEtKZHJPOGhnMlhu?=
 =?utf-8?B?RFJ6SnAxZlJpcjR3aHZXZGt4RkJaZStTQ2l1ZEwrc3dUMFFWL0NOMEczUUxh?=
 =?utf-8?B?d2hYYWRpcGM2V3dMekZ5UVlpWm00WmVuazBFNUhxZmhQbXRVckVmVks1dE55?=
 =?utf-8?B?anZVbzZmYlNrNnF6UERZVXphSGNKcnNoeVNjU0p0VC96WUdFelRybWpRbDRq?=
 =?utf-8?B?NGpWZGhqZEg4KzcrY0pOTm5SUlZNdDczSTJjdDR0b09aY1daZXp1ZVJiTlgw?=
 =?utf-8?B?WlljUTkzMlZmMmZoc2xXV0ZtZm9JS2NHN2tGcXJ2M3I5OFBNRStqOEFlNnkr?=
 =?utf-8?B?a2g5cHVwbzB5d0p3T0ZDMW1PQmQxaTVwdXY5bUlEZ2Z2OGdGZWU0cDZJVFV1?=
 =?utf-8?B?WFJpVlBxZTc3d2dmcUUxYStiT3MyTGNwMlNXc1dlTXA0NS9ob3pPVmRpR1da?=
 =?utf-8?B?WnJzTEVQNWN0UDEvdHhVMmNwdmFUY2MzTmFMdVh1K2RzNHlPMW1OY3ZKeFVI?=
 =?utf-8?B?M1UwTVYyZVpFNHhuR1dTRHMyakRWZk9tRTFRazJ5UWxKSktteDJ2SWlZcDRz?=
 =?utf-8?B?SzFRWWw2ZXV4NlVrWThoa01HWUFSL1ZYeHMyM3pERG5aZlpwUUtKMU9URmR0?=
 =?utf-8?B?eGRFUFNOK1RHalFBNDArK1V6UmtabWVrSEw3dU92Q2JFak5NWmdVTkgyeEhm?=
 =?utf-8?B?dnN5aFRrTEdQZGpDb2ltVzFRS05tYy9XV0pIcHAvUU1uYUVwVmwzT1pmMTZi?=
 =?utf-8?B?RVBSOFB0RTdPazNRcHRTY2l0SE01RGttdExMZ1dRbjMyN2hhM29yYlhsemRr?=
 =?utf-8?B?WEpuK1RkNDhDbnUxaFRDaVZqSTF0T1VYYUVIQ0VvVEFuZzdFSXAvTXR0YnMy?=
 =?utf-8?B?Z2FiQmN1cFZrNHdpKzZpK0l3VVJycXh4WmZ4MXV0STExVnZwVlUyNEdUeG9v?=
 =?utf-8?B?M0ViVDRFdEcxSEFSN2RaRENEdXoxcG5MUkIxVTFjWSs3VTVQSkgwNDhNdjV3?=
 =?utf-8?B?WStSR1dob2w5Y3lCM2Y2N2dmUkQ3U1dHSDI1TkVLanpTeHY0WWtSa2s1NWta?=
 =?utf-8?Q?4EbMecTHCe+IDYKJJrrbwUwxVGNpJ2rWtFRLj8X?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5242
Original-Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT015.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: e9688cee-98e3-4580-3e76-08d904b8a800
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ucjP4F6w8GVZSWEHuFbK01qMZGlj/hCEeqGHNWLgKx6pGomGTA7aBFxftZmNnDnZ6Z+VGVSyLWuL/EcVlXV7zeJbxOYiUeE+PUfmqjvswBrAdDEAVAHP/BMfbcXGp7n9jyqmCKv1D2Uj/1VfH1UxyBWh41jexSdeQppgm6eozdT50jVtGwiPlSUMTXKnpKzZchcBOBC7BrZH/mI54l1ThEMDDn895Hy05fYAtU/dolpkC6FSQlta94RmPmeWVJPgDiI4xns65RJcDckT9sIYxYXeGCrfmC7+AA6rHk5ZOLY8eGPIkjh1msYQXOVGtFm0xMuqwTbLsr8rk3GN7fABnxZZQJKksOLg5scGVXPpaa9CDE6iSm1ZLa2ae12/d+sisf4eYh1TJXzWrB62bDde63Q8DqYMwW7UXAeaf/Bvfye6A8RatxLzvsrJK8ULkF4ak7ln0kdRspVJX4Qajp2+xHvohg1z3cNIrV7Qsh6hTbu16xyCHfKYjD8pUirERtXGb3lIQqisq0nr+o5R9Lnse4bxef6XW2tIG05AM3eEMfuEcVH+Y40NtXwxRisW18pI9Bad0quegKIXmXBoDFaNib9DtlDmdygFjOmf9QcrhodFA+SzvAhOuCXI6sWP9Q4ckPuK2xY098ZaomE+Nt+JiYNWcSJlOP2OCKo8ACKA/bZfWWVeB9nI6yZsIJD/Svv7AA8EIT17nK0Mfbf6Jqxn98yzlzub4J+GhG/PbPDxcbKpRwRZZq/AzDUjDK3cb53OL9iFxmfVtMfyes86CTcJIQ==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39850400004)(36840700001)(46966006)(966005)(82740400003)(70206006)(336012)(356005)(6486002)(47076005)(26005)(70586007)(107886003)(8936002)(53546011)(921005)(8676002)(82310400003)(36756003)(478600001)(956004)(6666004)(2616005)(81166007)(31696002)(186003)(16576012)(16526019)(4326008)(450100002)(2906002)(5660300002)(86362001)(316002)(83380400001)(36860700001)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 11:29:12.9743
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce8b1281-86f0-4f34-f321-08d904b8b069
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT015.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6430
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 4/11/21 4:42 PM, Eric Auger wrote:
> SMMUv3 Nested Stage Setup (IOMMU part)
>

[snip]

>
> Eric Auger (12):
>    iommu: Introduce attach/detach_pasid_table API
>    iommu: Introduce bind/unbind_guest_msi
>    iommu/smmuv3: Allow s1 and s2 configs to coexist
>    iommu/smmuv3: Get prepared for nested stage support
>    iommu/smmuv3: Implement attach/detach_pasid_table
>    iommu/smmuv3: Allow stage 1 invalidation with unmanaged ASIDs
>    iommu/smmuv3: Implement cache_invalidate
>    dma-iommu: Implement NESTED_MSI cookie
>    iommu/smmuv3: Nested mode single MSI doorbell per domain enforcement
>    iommu/smmuv3: Enforce incompatibility between nested mode and HW MSI
>      regions
>    iommu/smmuv3: Implement bind/unbind_guest_msi
>    iommu/smmuv3: report additional recoverable faults

[snip]

I noticed that the patch[1]:
[PATCH v13 15/15] iommu/smmuv3: Add PASID cache invalidation per PASID
has been dropped in the v14 and v15 of
  this series.

Is this planned to be part of any future series, or did I miss a
discussion about dropping the patch? :-)


[1]
https://patchwork.kernel.org/project/kvm/patch/20201118112151.25412-16-eric=
.auger@redhat.com/


Best regards
Vivek
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
