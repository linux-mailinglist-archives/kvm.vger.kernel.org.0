Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C333C5FD8
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 17:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbhGLP7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 11:59:05 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:6356 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233638AbhGLP7C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Jul 2021 11:59:02 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16CFfCNA016257;
        Mon, 12 Jul 2021 15:56:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7hms17+ywCyyULtIV0EsVEoAPUsUW9fgiAzK4WWV0/I=;
 b=vcnwxp7u+7asuKnkGezOFUnNMu2gZuSrPdCChf22cORJjOr+yIyQdcImX/iJu19jpW+T
 I73LvQ1m7WjpOF7MS+x/H/sGatR1+DwcGuf9VXX3ltDM+Q2nRyAQAw5JlqIFUi4W6YWv
 XvlEQXWwYdMdsB9PDYBuLoMsqXsxYl8dvbXHoSe0gMj0mV3xClR/n4XDSXftOkwxlrkW
 /jsXhNB/Wc8+c5tnB1UGUFWbVE49l2cxrFc8jR4S9CmABQ+VA8sBa5R/ePJTgP7Prwm0
 mai9jWWmzblC6WO8b8/V+ie8Ce4vvuAZD9mnINOEjt8Aob6Vs+eTmb119cCWKOpzdome Wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rnxdgffh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Jul 2021 15:56:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16CFenis089948;
        Mon, 12 Jul 2021 15:56:04 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3030.oracle.com with ESMTP id 39qycs55ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Jul 2021 15:56:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IGc8x8uUGgfuX+JXf0InIGpSgmywoFy2yvRA63Bk4VjBThJTUvO0TzkAWcyx9AHVCIMqu2ZtYChKDZbwsPtwP25AndeUiVZsQLinygzd48mWes8/H2sAQvizXCZIYUENRs+n+aGQXq7gtblSeuNGasfaTsDTuM2HMqk8nYXjc0Dzo4EM35lVk+3V28NxbZkM2i9PqXgcCOtlyXhvy6mhYGM4BZO/jb73YsnbvLShXXyP4yekwu5j+Kpd6hjMkP3duI1Hcs6ek/ez2RXMH6kmiPRgdT71SjRshRrjJZUy4YllOn+mDDJ3jtmhp5eZcHP57YpbTR73oC6xiZsAdXhF0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hms17+ywCyyULtIV0EsVEoAPUsUW9fgiAzK4WWV0/I=;
 b=EneB0lmosuNXuOAQRTIMVqBR34tuMN8HmQVJxXB78g0xPODCATBRjazg2LLCiJzZ0MhKq5CEiT1nRZMbUN2SWIM6Q1AZmZXJe0REOvKPKpLomnuYGLpFV+U0G5Zc6lKkx8shyVAB6lH8ZtnQI2yu0iRM9ClhCu7Y13uYLFQlE79ozlszdBsB7VeN0e1sXc2AnRbkS4kP6Aojq02fB67ylaQd3cKsymCbR+33ni58GJv+IECN+HFNteXrHURA9DQfdJzZMhb1W66bfXUIJ7CRdoftkTAsmNgYI3K+Sned8bJ/J5N31ruUwtQgTOvJKTLM9tScHy2WRIVuqeUwni3UvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hms17+ywCyyULtIV0EsVEoAPUsUW9fgiAzK4WWV0/I=;
 b=w0hZ60ajCFxv0//06k0FiaXx4ZDJ6ZRkIaKjTqwcbND1j6stnoC90oTkHIKaRWcyUG7tNGl2BcPA2H5TdQLeIU/memqcoKifrx4mFvFLL5HYbPKeGOMDfg1/Tih1R1+EPT/qZ65Dzc3RqIAs/X9svy9YJ63fZB/dm1a5Tz/WveY=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11)
 by CH2PR10MB4165.namprd10.prod.outlook.com (2603:10b6:610:a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:55:53 +0000
Received: from CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::b895:ab48:fa35:3f15]) by CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::b895:ab48:fa35:3f15%4]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:55:53 +0000
Subject: Re: [PATCH v2] KVM: arm64: Disabling disabled PMU counters wastes a
 lot of time
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Robin Murphy <robin.murphy@arm.com>, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
        suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     konrad.wilk@oracle.com
References: <20210712151700.654819-1-alexandre.chartre@oracle.com>
 <d4646297-da3a-c629-d0b2-b830cce6a656@arm.com>
 <90b0b99b-505c-c46c-6c2c-a45192135f5a@arm.com>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Message-ID: <a7663dbe-4ff9-0b1b-29ca-aab16d896217@oracle.com>
Date:   Mon, 12 Jul 2021 17:55:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <90b0b99b-505c-c46c-6c2c-a45192135f5a@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO3P265CA0003.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::8) To CH2PR10MB4391.namprd10.prod.outlook.com
 (2603:10b6:610:7d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2.7.202.103) by LO3P265CA0003.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:bb::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21 via Frontend Transport; Mon, 12 Jul 2021 15:55:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 499af761-1ea7-4eda-de6f-08d9454d873d
X-MS-TrafficTypeDiagnostic: CH2PR10MB4165:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR10MB416549F0BE5777427D5A84759A159@CH2PR10MB4165.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VqjIdHjkU/Nl2ObSjWBp6g6lLFXx+d2+xGlPDZEAj0N1hOTpR7XhjW2MZe1q29ukFKvnGj1ZqVo/iIFuE/m/7UbLd+uz+A4uv7bB24Nk3/Nr5uLz4uKRdoh0Ve+ySzU05fJXe/ksPWTBXFkF6IDcJdRYeSrdk3SzHEFuI0gdiFiRCT3S1MGJ4QUlOgM3nA/gCjC03q8rc+exS7Rn4cwEvOvEepMJRm8xI1G4hqrwNXnA4qjQ3Vm+MVHvDclTsGMFpH3i8Y1L8ifS21Q7y7+q028xaPo2IoXvpGYIyDppR5/zeSsPdOUBOIPS8ym4MKudUfNBBOKYw30kG1wHXETLbdoFQE29yl9Vkw5G1UYSECV+EZ9mPUalyeCkNxhrmOdE1wfoVNASg2W1Dx9fjufKawQ3h1GXG43XonnJE+JwLUg97LQK0hOWs00kQ6SH7yQ5n0sWgkOoOOu9FhzmS0pbsGJ4UTR2txNWtI80IQ0eVw9ePo8JbfFb9aRdY8Uastf7pdGF8PIXWvACpwiAsciXeXtaXgBcQ8eFx1lJGmEBTzzO/6Fbj6Vhyss/a9uCkoc8v3ll1H177JWXj5xAWF1Ugmx1BjhyRFLxUoMDSqHDV4XmNoliS8DD9fUrF9BNJ3+LshOBtQkujI5EXTJyhgmrOfRpfarZejhGCBHT1WMxdxbjrW1ogpzdOCV0/fj9aTfXE4bKbosdZfAU2JzvNR+DMazlyRsCuyla6V5+0RE0bYLWPXLEzts11SGbxPfYZnE0T3cUlDOgGHJEO511ZwcpgX75cIQ94f8dnik6UwUMfG/1xsJKjFAuHpvclH6uuVydi+MkeEecnEMrKPO1S9dx2hy5wm3m6+HHS55hNs7RiqiVFNs0iYAx1CRg+LLboBdP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4391.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(376002)(346002)(136003)(36756003)(86362001)(31686004)(2906002)(966005)(6666004)(31696002)(6512007)(4326008)(316002)(107886003)(6486002)(921005)(44832011)(7416002)(956004)(2616005)(186003)(53546011)(6506007)(110136005)(5660300002)(26005)(478600001)(38100700002)(66476007)(66946007)(8936002)(66556008)(83380400001)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWorOExvL2hRKzRoOURsb2g4amtITjFwWUZKb1dkdnMybit0THNJK3IwcFV0?=
 =?utf-8?B?cFNTRUZkVjBZa3lidm51a2lQem9yV3lodmRsM2ZpMDd1WnU2MjQvbHNlcUlz?=
 =?utf-8?B?S3lvQ2VUaUEvalRBaEY2OUdudHI5VEFYSHc2R256cS9xMkgzQjZCWkQwTjFx?=
 =?utf-8?B?Wm1QN3NrOWg4M2dmMzZ5bjBPbUNqTEhkUllrME1ORExHakV3SXMwa0JVSnJn?=
 =?utf-8?B?YjRjcE5Dd2pwSk5ZWVNuQ1dUWHl1UGlBMndBeGwvNFFOS3BMOS9JUGtKeWxN?=
 =?utf-8?B?SktxQlg2QzJpWHpoMzlGaFJncHNPRmJXOElRNHVrNFBuQngyV1VDcnB1TjV3?=
 =?utf-8?B?elBQbWhvTklSVFNNbGoybUpCaTltNkJBMCtoTXp0bUVmWDhlN1JLSkhnaDVP?=
 =?utf-8?B?bkowblNYek94Vk5rTGZTbWZUN1FFZC94VFp1Z0lVY05PaFVkY1d4cHE4N2FX?=
 =?utf-8?B?eEllRTEzcVhmdCt2WmlYRVhTVnlRMVcwMytPdWtTWFprVytoR2x2QWQram9a?=
 =?utf-8?B?R2hMN1BnbUxWekZDeUl2ZHJzc3owZmttWlNiRmRaSkcyNVpDcXBRYll1c0RZ?=
 =?utf-8?B?SzVDUUZJbkNia2hQV3ppVWdzbVJ2a0xYU1FQY1U5T2xhdGloQVk4bytUQXo5?=
 =?utf-8?B?dGtOcEJBbXZabG5ySHFSd0xPZEFJOVpWZDVxOWMyb0JxdWpxSndzWDVrdWtT?=
 =?utf-8?B?WjFQUWlhZGFMUjJQdkpDRmJvaC93S25TNXU3WlBCYkFrb0ZQaWs5RXdLcnBy?=
 =?utf-8?B?RTMzNWR5Nm5Wb2dWSDRocnNmaGFYWS9MVFQyNHNZalpPcHM4c3RVTlh0Y1Nt?=
 =?utf-8?B?aWx6Rk12MFExK3ZvbjFGelg3Y3pGdEJIREZQQVhuQm5MdVNDbVIzUW9kOWJJ?=
 =?utf-8?B?bndya3RmNHhaaUc1LzRlNkp0STZZY1VBaXloa3dvQkxQakZKcWhXOFN4aEx6?=
 =?utf-8?B?UFJGQWxCdzEvSW9aeVJPSlVsM3hoanZkb3M2amkralMxYjhhYzR3NmFNbW1R?=
 =?utf-8?B?ZFBQU0VHYXNEZDVaWkpTZHJRMUlFTVpjL2lyWjR0OVlYVnprR1M2UUFzTEM5?=
 =?utf-8?B?aEJBT1NIRWRxR3k0SWIxemRRVGdDZ2g3enAvRzA1SktuSHc3NXdsaVJUMzc5?=
 =?utf-8?B?bGtJSE1KOWxDQWZmaXRZa0tSMmFoa0xlQ0hJcG5HSVo0bk4vMEkrOGpmYWlo?=
 =?utf-8?B?RHA3bktrS0RUUTBZVlg3ZnBncGhodFgwUlovcG5ZNGEyTVRBUDkvQjlIYmFk?=
 =?utf-8?B?YVVqby9WdzcwZ0x4dmNGN0VyWVErcUVxbjBrYVRmN0FGQklGWGFTdm82d1Av?=
 =?utf-8?B?Z2NYUzl2UXE5SFZXUEdBQURRaHhzYzM1eHhwenBaSkpubjc2TmR4b1h0cnJH?=
 =?utf-8?B?RUc3aUw2S3ExSVc5aGduU2RUb1RnNThYRENkVVM4STRraWpRaXEyVGtNb0Np?=
 =?utf-8?B?aC9yQXAwKzlrYmh2dnMrc0ttRmpBTW1tRkl5ZDgvcHJzY3ptNHo1WGVNc0Qx?=
 =?utf-8?B?T2NCMVhZbk9lam1yQ0hpaURWbjlzVk8wckZVSkFhRGM0eDR3L0E3K1RXNDh1?=
 =?utf-8?B?a21YZVJJOXlrUVFBS2M0UXorLzUzaWJTbjRmRXRmWjNaNkg0RHJRNVNWR1Q3?=
 =?utf-8?B?WG5HQlYwTjIrSnhYSnF4SXRsc2FhVGQrSWZLRTZGUTBDenIxS083NHVhbmJi?=
 =?utf-8?B?a1pyNDBoNlRGYndsNmxqRXdzZU5zSnE3dGJMclhvREVubitiRWovcmx5MG9v?=
 =?utf-8?Q?IcJ9sjyV1MvN3MxEZKAKM+I9O1rNVdSpWBQkACg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 499af761-1ea7-4eda-de6f-08d9454d873d
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4391.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:55:53.4328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bLpsbrI7BHUcF2dFWwzXQjJzCsCZvI4L0W6tSGMoF1SXyZzreC+DCzV1NCI0UczuWf+xWFu7dWDK1sxzfOc56ia8ogWkQzukfhSJStWapuM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4165
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107120121
X-Proofpoint-GUID: 2ijBziU_6z06QF6himcroU2tlbXvq9J8
X-Proofpoint-ORIG-GUID: 2ijBziU_6z06QF6himcroU2tlbXvq9J8
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/12/21 5:51 PM, Alexandru Elisei wrote:
> Hi Robin,
> 
> On 7/12/21 4:44 PM, Robin Murphy wrote:
>> On 2021-07-12 16:17, Alexandre Chartre wrote:
>>> In a KVM guest on arm64, performance counters interrupts have an
>>> unnecessary overhead which slows down execution when using the "perf
>>> record" command and limits the "perf record" sampling period.
>>>
>>> The problem is that when a guest VM disables counters by clearing the
>>> PMCR_EL0.E bit (bit 0), KVM will disable all counters defined in
>>> PMCR_EL0 even if they are not enabled in PMCNTENSET_EL0.
>>>
>>> KVM disables a counter by calling into the perf framework, in particular
>>> by calling perf_event_create_kernel_counter() which is a time consuming
>>> operation. So, for example, with a Neoverse N1 CPU core which has 6 event
>>> counters and one cycle counter, KVM will always disable all 7 counters
>>> even if only one is enabled.
>>>
>>> This typically happens when using the "perf record" command in a guest
>>> VM: perf will disable all event counters with PMCNTENTSET_EL0 and only
>>> uses the cycle counter. And when using the "perf record" -F option with
>>> a high profiling frequency, the overhead of KVM disabling all counters
>>> instead of one on every counter interrupt becomes very noticeable.
>>>
>>> The problem is fixed by having KVM disable only counters which are
>>> enabled in PMCNTENSET_EL0. If a counter is not enabled in PMCNTENSET_EL0
>>> then KVM will not enable it when setting PMCR_EL0.E and it will remain
>>> disabled as long as it is not enabled in PMCNTENSET_EL0. So there is
>>> effectively no need to disable a counter when clearing PMCR_EL0.E if it
>>> is not enabled PMCNTENSET_EL0.
>>>
>>> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
>>> ---
>>> The patch is based on
>>> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pmu/reset-values
>>>
>>>    arch/arm64/kvm/pmu-emul.c | 8 +++++---
>>>    1 file changed, 5 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>>> index fae4e95b586c..1f317c3dac61 100644
>>> --- a/arch/arm64/kvm/pmu-emul.c
>>> +++ b/arch/arm64/kvm/pmu-emul.c
>>> @@ -563,21 +563,23 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu,
>>> u64 val)
>>>     */
>>>    void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
>>>    {
>>> -    unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
>>> +    unsigned long mask;
>>>        int i;
>>>          if (val & ARMV8_PMU_PMCR_E) {
>>>            kvm_pmu_enable_counter_mask(vcpu,
>>>                   __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
>>>        } else {
>>> -        kvm_pmu_disable_counter_mask(vcpu, mask);
>>> +        kvm_pmu_disable_counter_mask(vcpu,
>>> +               __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
>>>        }
>>>          if (val & ARMV8_PMU_PMCR_C)
>>>            kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
>>>          if (val & ARMV8_PMU_PMCR_P) {
>>> -        mask &= ~BIT(ARMV8_PMU_CYCLE_IDX);
>>> +        mask = kvm_pmu_valid_counter_mask(vcpu)
>>> +            & BIT(ARMV8_PMU_CYCLE_IDX);
>>
>> This looks suspiciously opposite of what it replaces;
> 
> It always sets the bit, which goes against the architecture and the code it was
> replacing, yes.
> 

My bad, I screw up and I dropped the ~. I will resend.

Sorry,

alex.

>> however did we even need to do a bitwise operation here in the first place?
>> Couldn't we skip the cycle counter by just limiting the for_each_set_bit
>> iteration below to 31 bits?
> 
> To quote myself [1]:
> 
> "Entertained the idea of restricting the number of bits in for_each_set_bit() to
> 31 since Linux (and the architecture, to some degree) treats the cycle count
> register as the 32nd event counter. Settled on this approach because I think it's
> clearer."
> 
> To expand on that, incorrectly resetting the cycle counter was introduced by a
> refactoring, so I preferred making it very clear that PMCR_EL0.P is not supposed
> to clear the cycle counter.
> 
> [1] https://lore.kernel.org/kvmarm/20210618105139.83795-1-alexandru.elisei@arm.com/
> 
> Thanks,
> 
> Alex
> 
>>
>> Robin.
>>
>>>            for_each_set_bit(i, &mask, 32)
>>>                kvm_pmu_set_counter_value(vcpu, i, 0);
>>>        }
>>>
>>> base-commit: 83f870a663592797c576846db3611e0a1664eda2
>>>
