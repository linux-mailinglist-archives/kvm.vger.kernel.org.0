Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059103BD9D3
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 17:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhGFPPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 11:15:39 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:6912 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232068AbhGFPPh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 11:15:37 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 166Da7wN014775;
        Tue, 6 Jul 2021 13:50:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Ka55Eu7DcSSyIcQKxZONX1VZBy8IyX5QIcCRR600jWY=;
 b=oijLQtGJRlPC8QVatcrEaKU5gy7r8luywdr/ieO+lWj7F6v0y0CJK1FAuaueimyb/baY
 MLBRl6wfAJHVB7IGCnhiFEyONny9jgIjuFB8tgQuWzTcrxQtHB7Vy/+il/ctaY1UOCGc
 caYEPtz+ZdtyoregO28Q5ZtOCndQQeD52ejcRHNK4xsCflLXg6XYrsJdXnxklGJ+V9k/
 HbgOWmRenls9Vr2wmX4Pa0N0+4t3yJz4OyRigXUxi2fPi00q+Q+C+vLBUrfegDw0fH+t
 n8exkcbfGy3l443xpNwOcqJMlmqauuGtJ+GuMU8Jr4EYFzJreykaKYSuCKp2ZiQ87RD1 wQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39kq8eawur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jul 2021 13:50:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 166DajR6105068;
        Tue, 6 Jul 2021 13:50:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by aserp3030.oracle.com with ESMTP id 39jdxh79pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jul 2021 13:50:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ieLhU1M8Od6mfs9fI+PZowr8OHgIac/8pH9zdlrXV/kczAV7ngLKT2CPOit7YTyuxWuVsNKsRrIft0YQ4evx1CS8HOgdY6YAJVznAcOHaDkkgDr92RtyJBwPWpxkzrLVxHz1yDS/nJQNAJVaeNHqblwA78bEb7oQX50pOOeSfEVI9tgRA7fZyR/GbIG469PaFCNQoM7AA/hcmf+9WRHkVT32J1bwSABLKWxbFMJDZ/P4s8c0a4j2a71NZXyVAaulI5gPmUVBcSEGNtt8bozavW4J56r9ndrrIwqeOyk3Wvp3NLMuLt2ut9TsTS5P+iDwuvj8419FzhOqCJ39LyrksQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ka55Eu7DcSSyIcQKxZONX1VZBy8IyX5QIcCRR600jWY=;
 b=WI5Jtiwdn0GiLQMUA3ENdMTySeV29f2fH6jJjyePTTVkcLYR8h4YmxDKxAQbINXtMa60jPDujEDG8wCC8cZdHmodcMsxB5Hn72a9j0T+l4KgxRD38ub7D4qyUOR+a4sRlzKJ0+u7Gw4xp7Kmuwc6gdr9lXSB0qBWvmoICqHVJSlnP1RnfU1cOg4RmAoj8rtZ4R1vtVLxlQfur1BJVs/5KHSHpSci3lWpiBycI3UTLnS3HG398s76GXsQiR4cdIDX5j/4IJs4aamsiMtweW9J3L6FdVLIz8zIrsyK0PIOWTvJ3PsXsSt86sBU8iBIBCzF4S5n+N6cG6xN/JlDMoBPdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ka55Eu7DcSSyIcQKxZONX1VZBy8IyX5QIcCRR600jWY=;
 b=XVoLCv7iW+3Aox62GxTvzYdRlqKbsw5MMeRZONL8hcE6Tyjin/3Y5IVIGMkpuzNjEf4cDmNf7wtNLNe9Nz690SEr3tvb8sZnD6cCoMAOf//d1sSB1KaRgvl9EDk8CAHWegMNqQGf27oJBEQRPFZ0p4hefQzndf6ZGF9A8B2IlIU=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11)
 by CH2PR10MB3815.namprd10.prod.outlook.com (2603:10b6:610:e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.31; Tue, 6 Jul
 2021 13:50:40 +0000
Received: from CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::b895:ab48:fa35:3f15]) by CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::b895:ab48:fa35:3f15%4]) with mapi id 15.20.4287.033; Tue, 6 Jul 2021
 13:50:40 +0000
Subject: Re: [PATCH] KVM: arm64: Disabling disabled PMU counters wastes a lot
 of time
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     will@kernel.org, catalin.marinas@arm.com, alexandru.elisei@arm.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, konrad.wilk@oracle.com,
        alexandre.chartre@oracle.com
References: <20210628161925.401343-1-alexandre.chartre@oracle.com>
 <878s2tavks.wl-maz@kernel.org>
 <e3843c2c-e20a-ef58-c795-1ba8f1d91ff6@oracle.com>
Message-ID: <ed86299d-c0d4-f73e-ff7d-86eefd2de650@oracle.com>
Date:   Tue, 6 Jul 2021 15:50:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <e3843c2c-e20a-ef58-c795-1ba8f1d91ff6@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0231.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::20) To CH2PR10MB4391.namprd10.prod.outlook.com
 (2603:10b6:610:7d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2.7.202.103) by LO4P123CA0231.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a6::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23 via Frontend Transport; Tue, 6 Jul 2021 13:50:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 183d7b95-6f7f-45b4-94ef-08d940850a65
X-MS-TrafficTypeDiagnostic: CH2PR10MB3815:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR10MB38157E36C051DDD3EBE425A89A1B9@CH2PR10MB3815.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KubrMIeQJDsJUibSHB0im/4C4esy5hXKZZXdYdXJfqSVPNIUJjWseHlW3T/mo0y1snHfDmZrfc3pOz4Ebcba1ng1pjCROkx+BqLpfJbF5NFJPyTQ1CT3TMLwmW+zIRz5ff+yGNLPi/bHSUmsT6amyCU+fNTmBAIYid4p78n4UzD1Q6KowY9WrFBa5m5eASa5nTRxb1NIImTJRAZkMH8PgogiyvCPhNRAUwxJaDFgZ7IvEkVROCQIniIslN7TtryyJ6TJ21H1/VjANaluU2EiG8gFdXj81g17Gd55AdCvn19vVP1dxWP3A3qsoLLqTf7j5NUnk6bGCQ5Gw/fBbmZ5qTXNmh9mq/j8/TtXEiHUEWW41+PH0cEs5qgEh0opPlccXemUgiqwspXxCK3ksiPrRizwTSwUiQrtmFp2TMq0H2jaDgnfoPc9nGpYabXPJEGL1DGYvNNxGoCV4dmclwSyJW65l2LIGmTXCG76UcQMkSdVHdbZA64NXBA9btTRPOWBHWk6Csax1na8fboeCMCV/KXod+XDjcz6tXavrpuHPP9+w3ECDj5nJ+F9WEVVpIGSEWQsAuqsg8LpASbraTxPqUj7OGVslu3ZC+iTVIDnVnG8T/cmaPMrR/6M660U4nSa4W1kGU/QwhGZEmQSgtwQkbyCv7XWMrPCgweEQHEnhLCFJLkmznbNYyKjLoMmhvy+UpsdIbRJIJbu2/15Qf+aPysAhXBsB94Q4Ypa7ILnwW8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4391.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(136003)(346002)(39860400002)(6916009)(6666004)(478600001)(53546011)(6486002)(316002)(186003)(83380400001)(8936002)(956004)(6512007)(2616005)(107886003)(8676002)(26005)(31696002)(66556008)(6506007)(66946007)(66476007)(38100700002)(5660300002)(86362001)(2906002)(44832011)(36756003)(4326008)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2lCSGxadWQ4Q1hpY2p6QUpUUzQrbEgxYnA0Q3FoU1pPY0h3bmwxS1NRL0FY?=
 =?utf-8?B?Tm4xdDVwK3pMZHJFcWx0K0grSUU0OTdRVDRrYXFUMzVCRzhzdGZKZXcrY0lM?=
 =?utf-8?B?L0IraGJOLytiazV3M3RFck94dUorbkw3YjZac01KRGU2THFyNjJHQkZkQXZH?=
 =?utf-8?B?UjBucndnQVhOMCtydUdvZ2VFZVhsZWFrUUFBd01wS0tpV3d5TG82WXo0VjRJ?=
 =?utf-8?B?SUtYbHBCOUROOVUrKzlIejRYMnd6akxKdngxemJqUC9WczIwT1JFNGtvZ1ZL?=
 =?utf-8?B?SUhMSERXSVBFeTZsK29nVW5yVW0wbWxsamE1U2ZsbXNrR1V2ZkhFaC8wTy9H?=
 =?utf-8?B?b1o2NmNIeCsrbGwzWlpLMEt6cWxoWEVFR2lNOTV6Y3o5ZThrU2VlMHdxQi92?=
 =?utf-8?B?bi9lbFJIbXA4eEY3bWcyS2pjMklkSGlYZWJ3ZWV4Tm1yaG11YkxGYktxa3lM?=
 =?utf-8?B?M3l0QlQxU0YzYjloRHVwUG1ESnFXNHVjblMwRVlnVWZQRGJuTlZyRUNTZGdU?=
 =?utf-8?B?SC9XR1RxL0ZVZElKcjl6aWFXbk01TDlDRUw2c2dZcjFtYkVmSklzbjdzbUI5?=
 =?utf-8?B?MFBNWW4rZW44SExkOUE5YWk1VGM2eFIvTzNjc01ZRWVsVklOL0ZnZXdLRGY0?=
 =?utf-8?B?T0NYNUU2QU9sa0lPOEFPeVBnT1h2cVdqdTBKMTJsWjl6OVVFS2dJV3p5OVhl?=
 =?utf-8?B?aDZ5bzVFeFdnTW9EVWVBeWxOelhLczFDKzBPZ3poLzFzNXN1c0ZtZmR2OTNE?=
 =?utf-8?B?WTA1SHEvTUZHQVV4U3FUMTZKd1pMUnBxY1pIalBZVU8vbXB5SDBmZkw5LzFK?=
 =?utf-8?B?QllVc2tUL0VONmpSMXlLU1ZQVkdpaHYwV2xoSVhUYmtEQ2haMlNXVzhHZlpN?=
 =?utf-8?B?bTFWTnBwQ0NRckdaWDViV0VxK1lOeTdnRk5iOXhQZVpnTy9PZk56VGQwSjFk?=
 =?utf-8?B?a09PYW1OT2c2ZnN3VVhPbHVhRi9malhCdTlrc3h5bWdxNTYwUWR0czZ4K3FL?=
 =?utf-8?B?bk5yQXVxQUxvZXZjRC9EMmVxcGNRUXcrWWdOQ0R5cmdCVmdoeWU1YktkVWsz?=
 =?utf-8?B?WTgyUWJod3NZQ215a1J3QnhRazRRUWEvMXhiYmxoSWd0QVdITUl3LzdaKzZW?=
 =?utf-8?B?RWZYVXdsZGd3WVpsSXNBODlYa1ZpKzhiY1dsNXhwMUpSWG5jVjhKeUI3SHZD?=
 =?utf-8?B?UzdpSGxqNnZHVGJWanFyWWhxV0lWSzIwcjVGUnRxQW8rSS81czhCanFxKzdL?=
 =?utf-8?B?YTZPTThxY3g0RnI2M24vb3hhcHIvN3h4cEFXTGRzWGdXajdyU2JsV3hsWHJI?=
 =?utf-8?B?aFhIdmlNdzl4dnN0dW9lS0xkTVV1WVB6czNZR2F5L0ZnazFpUzFPMVViRWVS?=
 =?utf-8?B?WWMxS2pwRXdkTUl6TFJhRlNYY1Ywblg0bnVHQkZQNWhIV0daVHBHZWJoVGNN?=
 =?utf-8?B?dXVRelJHL0RDSWgvdm9TcUR5WlMrKzR5UHZDOS9OaDc3T3Z0VXlRaFp3S0d3?=
 =?utf-8?B?TmlSQnVUaE8vakRtY2ZuU3RzSEFMaGtUWExFQk1WN3ZFTVV3TWVqLzdPTzdi?=
 =?utf-8?B?YlJzSTFnR2g4ci8xeDJ4MWllUVQ0b0xJVmw2eG9Va0VYTUF1dGt4SHEwUDQz?=
 =?utf-8?B?bTlPcHdqSkVKanRwb1c2QjEvaUVkeXdLTlVrNTdYM3hTWm9OM1BkQVpua0NN?=
 =?utf-8?B?bmlRV1hqcFNWTlpqOEhZd0YxQk1sUU9tRE5uYkE5dWswKzBzZGhnNGdpZFBa?=
 =?utf-8?Q?zu1MKsfxRTTXidVRYwif5yZbDkreib3lyr/tDrQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 183d7b95-6f7f-45b4-94ef-08d940850a65
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4391.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2021 13:50:40.0406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E79HvP3PSFrTm/PiEH9f0v89Ztq/zrAtt4CKT44htbAGceRBL61nHLVuAOYGpBRViBMc00XP9iOK3uD9hM1HnnNzGE1s0iFBFouSPMMtgRs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3815
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10036 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060064
X-Proofpoint-GUID: jsZE1Io6eNSkl8e0dPbdG0uCnSNLK-eL
X-Proofpoint-ORIG-GUID: jsZE1Io6eNSkl8e0dPbdG0uCnSNLK-eL
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Marc,

On 6/29/21 3:16 PM, Alexandre Chartre wrote:
> On 6/29/21 11:06 AM, Marc Zyngier wrote
> [...]
>> So the sysreg is the only thing we should consider, and I think we
>> should drop the useless masking. There is at least another instance of
>> this in the PMU code (kvm_pmu_overflow_status()), and apart from
>> kvm_pmu_vcpu_reset(), only the sysreg accessors should care about the
>> masking to sanitise accesses.
>>
>> What do you think?
>>
> 
> I think you are right. PMCNTENSET_EL0 is already masked with kvm_pmu_valid_counter_mask()
> so there's effectively no need to mask it again when we use it. I will send an additional
> patch (on top of this one) to remove useless masking. Basically, changes would be:

I had a closer look and we can't remove the mask. The access functions (for pmcnten, pminten,
pmovs), clear or set only the specified valid counter bits. This means that bits other than
the valid counter bits never change in __vcpu_sys_reg(), and those bits are not necessarily
zero because the initial value is 0x1de7ec7edbadc0deULL (set by reset_unknown()).

So I will resubmit initial patch, with just the commit message changes.

Thanks,

alex.
