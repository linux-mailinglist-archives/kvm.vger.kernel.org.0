Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E4A3BE84B
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 14:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhGGMvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 08:51:51 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:16282 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231761AbhGGMvu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 08:51:50 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167CkFTh025253;
        Wed, 7 Jul 2021 12:49:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=q3lsnY3sI8PehS7m8HeRCFtJh3pYeSoVPJaoye/nOLM=;
 b=lQYnS4CZIWFL/r6FFr/BrVBBEbOT6Xa8RK1WU5VbRk16ZTnQMLlSboHGU2IQtZHVMP5U
 lAxbkuRjQhz2uA17iew83rDgx0ueQH62d66C0gWJpdbsdC6UaYkeV2oDll2GgBWwCB21
 FP3T4XX14N5eWF2RcrVSRq6Mo4AqPI7TMSi+NZdu9OHqqSSYGpG+AFt+ooMRuxrP9tno
 czgrBn9sayXEWhu1oy0WAmAiOWNP5ilNu9IJXX9YBIf5qFRu7Xzed2RTlKY4ShKnFIPQ
 mgRAfgOinEAvkztuS89xWq9syxYGhuPlhlcUcxjz4L/EZ9QnFqEdNR0uvCQhAhsy93aB 3g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39n4yd0tu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Jul 2021 12:49:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 167Ck7RR056972;
        Wed, 7 Jul 2021 12:48:58 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by userp3030.oracle.com with ESMTP id 39jd13bvt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Jul 2021 12:48:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DqnZwFimQ8Tc0dX5lcY2CwiOf/v+ddm6yHYg5PRm+Kb+OheAcl9BPz5eUXZfo+F4ESd27jw+7jPGTeRxALR4/Gy0jzWU21MVyWW0Od69+kDwHE5qrUUDKSnIFS5mi0f93Y2PoL8XiaFnODV6eLDCw3aUdko4X7wRecn4w0U0KnHYtfH1aBOVSKZslgFVyspWyZsjQo75V14IqdKxm3gT3wgZPrPAbkaIklZUUmU8bK8LLcqYRP5gdAPfGsMhnboLtn3LMFfXwPzHN/9+9JizuHYoj8DGCJ00TLIGaRYwKNicXadroLQU1Yl0UiQQD6v7YKqUe3+Py2H//9KHS48CPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3lsnY3sI8PehS7m8HeRCFtJh3pYeSoVPJaoye/nOLM=;
 b=AmsfQTo/rLlqr3qItzVzbdMDidXES5y4A5WE8gD6gPk/lfGy24TdoOGNuEgDhxy1HR4F7vqY1DJkc2uzHMCVhdFK/I3nu0ZbOx5plmjq7b8gqnWkEwHpdsckGUBlYYvAa6jcd5orXH6ffJML7r6dCELXp82CM0+IFtBmAlb4UrhAQzgE9M9kHJ9WqjIPr2Z71wc/26JpVftSbI+aCOKwKa2X4Ax96/FVLsPIyISm/WNYc0oUgpM/9lJF08hfKGN37NULdHrE1lyDBEHOPtrAmXfDCe58KGMPCfPSz4NQt8a8OKNWa7mBbx9tfmlc1RZViPdYo17Hx9KH0yJ6uLLPaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3lsnY3sI8PehS7m8HeRCFtJh3pYeSoVPJaoye/nOLM=;
 b=AbgI12hFFdUfQ9j8+QnfUxyBTUkTUNwlA7uHqcrYQDVT148SgNkwLBZMrsMRxCYAtD3/XVR6MCO4CdhqTVgaKIJ/BeawCw9C/3sats2hS64Pwg3TbVWEl6ZrV6tblrh5Z/scq22V8i4U1zP0gqnCkiHJv2/eYYbc4a/hLA1VAzM=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11)
 by CH0PR10MB5002.namprd10.prod.outlook.com (2603:10b6:610:c1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Wed, 7 Jul
 2021 12:48:56 +0000
Received: from CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::b895:ab48:fa35:3f15]) by CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::b895:ab48:fa35:3f15%4]) with mapi id 15.20.4308.021; Wed, 7 Jul 2021
 12:48:56 +0000
Subject: Re: [PATCH] KVM: arm64: Disabling disabled PMU counters wastes a lot
 of time
To:     Marc Zyngier <maz@kernel.org>
Cc:     will@kernel.org, catalin.marinas@arm.com, alexandru.elisei@arm.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, konrad.wilk@oracle.com
References: <20210628161925.401343-1-alexandre.chartre@oracle.com>
 <878s2tavks.wl-maz@kernel.org>
 <e3843c2c-e20a-ef58-c795-1ba8f1d91ff6@oracle.com>
 <ed86299d-c0d4-f73e-ff7d-86eefd2de650@oracle.com>
 <87y2aj7av5.wl-maz@kernel.org> <87wnq3739t.wl-maz@kernel.org>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Message-ID: <78f4827c-71fb-5c95-e700-d2f479f4d07f@oracle.com>
Date:   Wed, 7 Jul 2021 14:48:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <87wnq3739t.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0395.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::23) To CH2PR10MB4391.namprd10.prod.outlook.com
 (2603:10b6:610:7d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2.7.202.103) by LO2P265CA0395.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:f::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Wed, 7 Jul 2021 12:48:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5aa95db-9fc1-428d-9f66-08d94145957e
X-MS-TrafficTypeDiagnostic: CH0PR10MB5002:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH0PR10MB5002790F4A0437FD7963CD139A1A9@CH0PR10MB5002.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cypjeIOaggnE+/yMJU4s1QKQEpP9rqpbPWpNrPZU2+UlzPkpG5J2TP1yfd3UMD5qkMmrKoBQoIKlwKxeb02aIjI/wh1f20nZnL2jPlu8PvqbqYSt7spN7hSmXasKnR1BeECjLVmVX2hD/VvF/C1sZHbDfP0oenkYI2C5iKs4bH0Dyv1+ed/9l8swk1CIMs8ev5JYil3ijGyQIBQCK/JZD8pM2ZsXLNAqWiNkALd2ezq/8HrypksdtqYqe/SN8NP3H6voQ7GnEdhCtdWtgfgGnA2zUL/Vw/8+cg+mx+LVx/lLLx9L4m53yVyfaN41PIRULDtZrdw8BzhwkOENgMhXGus4ufscPhcndDuA+HCv/9CohjnVg/Z0oNo9dpVAWi2vc4pCy4m7ppGuIWMW5XhUHJ9lU9VNpqPuOW7rhUt6phteInzKmpcuInzpGXbOSd9fQx/L+yDKbUwcefMEg+8NXP5piIieZRNnsKgalbu7pDZv3n/7uG03yBHdjXutusHH+Va/itxtMNJSZCjz5mvelulCZQvDtG6TZV7CilgHbq84RZ8UKGlNaaGN360c/tuyL07789ZGtZHPjwI6CvIa+NPc9X8XzV2oEAh7/iyB9R9YyHsLBMulOGceQCQre06pKFRnJjujzhb+XxMfh7MY4SnWhhUKSuk09AvBgdUm4Uf+MSZmK2fJ8Z8ykoIR0JUL4JRIb4+xqepll5oUhZf8TqltqQBCgbIH7UGQVi9ZuwHpEiL4isYRiINvynen3o1FS5wyGvps+77/ytACvGPHXn36m55fFXI/tV8o3bHkY9/YA0308KOftgm8ZxdXb8U+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4391.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(346002)(136003)(39860400002)(66556008)(83380400001)(966005)(86362001)(36756003)(6486002)(107886003)(478600001)(186003)(4326008)(5660300002)(38100700002)(2616005)(956004)(66476007)(316002)(26005)(6512007)(6916009)(6666004)(8676002)(6506007)(66946007)(31686004)(8936002)(53546011)(2906002)(44832011)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UW84VmdkMmdMemhoU2FFbUp6YlpsbTlUcjRvMVl4cDFBMWxNbHlYSGNFcUtJ?=
 =?utf-8?B?S1hOaGlFYXViLy9YUG81aXJ2WmQ1bkIxV0JZV1NyMVpNZkxua01jZGxNUFRy?=
 =?utf-8?B?MldSemxZN293dmczRFk2R2FEeWpQcjY5K1FFKy9hZmRJNDhIQkZTR1JrR1g0?=
 =?utf-8?B?a2pCVjBzTXYvanVWN0h0bDZ1RTVMZ05MU010L3Y2blR0UXpQUUdVcE5BdEpS?=
 =?utf-8?B?dC9sdFlpSWhqZnhYcXVMeXpYTnhORVpZR3ZKblA3Q05XUXpSRmI1Q2dwZnVJ?=
 =?utf-8?B?aWtUaXpBL2IvN056VnVrVmJrSnFwNTB0aytsaTFkalppMUtaVERZZitmOW4y?=
 =?utf-8?B?blhHYU1GY1ZrNEE4dHJxZHBBbmtYa01lekhGM083YmlnK2czcDAyZ0RnamlJ?=
 =?utf-8?B?MlpDL2pjeEE0aDE1OUtNMmdkN2l2ejBldTZqaklVRnc5WWRPMGpjTGMrdVpL?=
 =?utf-8?B?RkNVY0dCZC9Tak5CSjJUMWlRTnZWSWJ6RGsvNFZabzJVR2xTeWpKNjVUMHF2?=
 =?utf-8?B?dnJBN1FlYjlvblpKRERiRWtlTXJJRnljZFp2d3psVEJ4Zis4WkhOSEtIeTdK?=
 =?utf-8?B?SXo0TWFYcXhYbHo5MXVOY3ZEQjFybEV2SzBuRnRLMklLZnVtZEovYUJrcTVy?=
 =?utf-8?B?UWZOaysyckNmSjNRSnA3ZythTm5jVmkzUXlCODRId3FQSjRoSDZTeU9OaUNu?=
 =?utf-8?B?WkVDZDNDa09iWHIrMmpuRXJaQ3NVeFppbE5NeVM5ZzA5Z2g1UDM4dnZVdnNP?=
 =?utf-8?B?b2VTMEJDOFZ4Sm82N3NvUEZCRUVHdDZrNStRL0xCVlR3elZ6MVpsWTdkUWlv?=
 =?utf-8?B?MTVBenBLSnEwOVIvc3VGa2RQalA3OHJuZm14ZGY1RUphNlBTUEhVYmlXbnQ3?=
 =?utf-8?B?bmgrWDdJSTRUM05nUTF1b0Z1dTZjRURpMzA3WTEvVzZYRkNUYnorU1R1dzRD?=
 =?utf-8?B?Y2w0UjAxZjlzS3p5clVvSWtvd2VPbjRPRUJFNm91T2RFVGFXY2hiZ2U3a05H?=
 =?utf-8?B?RW1hbVY4S291MU1mNFVWbmJ3VHVxd1F3QURrSFFTeU5uSE9HdW9adjVlbDlj?=
 =?utf-8?B?Z3hqVm5mN2xLZ2VMMGlLenF2MGYxUkNqa29Eb0gvczdjckpEVVJodHptN1Z4?=
 =?utf-8?B?SEpGZ1hSNmVuNjBsRG94MUdWVm1EZzR3M1NUallEWDU3aWFIV0FCYnBLeXNx?=
 =?utf-8?B?ZjhxdUNNNlUxdE5jTHRmQ0dCU2dZekp1SzJacGQ3UkFNVW1nNEhBaU5uaG83?=
 =?utf-8?B?TDZZazdZcGpFbU1FSE1HazlUQkRhSmVXam5Kekw4TXdpWmNzSkkwR1NqeTBX?=
 =?utf-8?B?Q3V2bTNPanFOWHRUMStRVTZuR3hvMVNpcERaT3R0emFtKzMxQjZKeGVvK1FQ?=
 =?utf-8?B?c3FiSTB4NkNVYlVTa2RKVytYQ2luU3BxVG9PN0lTVHVTOWdmaEpuOTdISDUz?=
 =?utf-8?B?UzVkQm9RdVBWMGRzU3lZRW9qcFA0RzVxempMdENxY1F2SVhBN3BNY2RINGps?=
 =?utf-8?B?anpER04ybEUzb0NMY2lFMWlGeGRUNENYSFNhUWRnRHgyNkExaFprMFdEUEdh?=
 =?utf-8?B?alRoeFk2L2t1cEUvU2JacmRLNHU5SWhqZVpzUHZSNHo2OFppcXVPVHM0bndw?=
 =?utf-8?B?ZHdpdXc5K2Y2ZnV5VVR4TVZSRXE1aG41ZnZtYTR2emIyVGliV0Y3M2RKZ3BE?=
 =?utf-8?B?N1VUTmFyVzN0eWd6NUtIeDdOcytQMW1yNHNNdHB1cWVzUTdhN2l2TzE0RUs5?=
 =?utf-8?Q?A2+cEHoI0GtR1UV+MGhIwTZPfu1YXcHjEuWeIO2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5aa95db-9fc1-428d-9f66-08d94145957e
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4391.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 12:48:56.7692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TmPNxUtnAbedcskEYVUrKTu5QGtw5RhAbvtmksaHJVO7Tj1vLu4RkPKkoxo/3VvRYa2WqQEsrQEb4kKB2LIp356SqVEMvrp32Vsvq/FAXr0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5002
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070077
X-Proofpoint-GUID: JmyJ3qRyl6pVv69ZV_z4sBzAE84143fu
X-Proofpoint-ORIG-GUID: JmyJ3qRyl6pVv69ZV_z4sBzAE84143fu
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/6/21 7:36 PM, Marc Zyngier wrote:
> On Tue, 06 Jul 2021 15:52:46 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
>>
>> On Tue, 06 Jul 2021 14:50:35 +0100,
>> Alexandre Chartre <alexandre.chartre@oracle.com> wrote:
>>>
>>>
>>> Hi Marc,
>>>
>>> On 6/29/21 3:16 PM, Alexandre Chartre wrote:
>>>> On 6/29/21 11:06 AM, Marc Zyngier wrote
>>>> [...]
>>>>> So the sysreg is the only thing we should consider, and I think we
>>>>> should drop the useless masking. There is at least another instance of
>>>>> this in the PMU code (kvm_pmu_overflow_status()), and apart from
>>>>> kvm_pmu_vcpu_reset(), only the sysreg accessors should care about the
>>>>> masking to sanitise accesses.
>>>>>
>>>>> What do you think?
>>>>>
>>>>
>>>> I think you are right. PMCNTENSET_EL0 is already masked with kvm_pmu_valid_counter_mask()
>>>> so there's effectively no need to mask it again when we use it. I will send an additional
>>>> patch (on top of this one) to remove useless masking. Basically, changes would be:
>>>
>>> I had a closer look and we can't remove the mask. The access
>>> functions (for pmcnten, pminten, pmovs), clear or set only the
>>> specified valid counter bits. This means that bits other than the
>>> valid counter bits never change in __vcpu_sys_reg(), and those bits
>>> are not necessarily zero because the initial value is
>>> 0x1de7ec7edbadc0deULL (set by reset_unknown()).
>>
>> That's a bug that should be fixed on its own. Bits that are RAZ/WI in
>> the architecture shouldn't be kept in the shadow registers the first
>> place. I'll have a look.
> 
> Please try this[1] for size, which is on top of Linus' tree as of this
> morning.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pmu/reset-values
> 

I have tried [1] and it works fine. Also tested with my patch on top (without
masking) and it also works fine.

Thanks,

alex.
