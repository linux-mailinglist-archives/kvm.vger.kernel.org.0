Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B853C9ABA
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 10:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240269AbhGOIhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 04:37:14 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:14554 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229620AbhGOIhN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Jul 2021 04:37:13 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16F8Vd5p011485;
        Thu, 15 Jul 2021 08:34:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Sk5rTtku/2/YhTdY9tEm1o1apS4dtVXLqJahNgseff0=;
 b=z5uluAASIlif5CEz23sEHeaqYQV0chR+6WDjL1/xNuPzkIu/o6RvE7DjgsXx+ysNol/l
 ZmgXpcTFqBZ+DAAT4gMzqRvxqkF0Vb9YcRBAYlgk1/lYEb4c6/3uVmzZYpkAnApotLHM
 Pj7CavdAz9UlqRjnlYEc1Pt0Zoi6Yzuyuc1hVvErFj4RaukkNrOASI78WiBgAskr14/U
 0g7JB19xfQ/9KWMG+olBOVUQ2FbjNdGfl15Tily0G4kZD07VQnfylSKkAZNYpLXEK1vf
 YxSUHPMTtIjdAuSvAqfqWKzle50bC/9GOC4Sgjuxcrv/xB12MoyxlTpRPCwUcjjkNVsy lA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Sk5rTtku/2/YhTdY9tEm1o1apS4dtVXLqJahNgseff0=;
 b=euHkVduov8Dy0ZaRkqw/qsfeCUdz20wmUOm9BPN1yufYHxkkEZhFwc1lz4ZfkSY5oFrx
 +Uc0aFHdWLRABM5jhm0o9J+1zOTWQEbHx4yVIoMQgNZgH4iL7z34TlhqYBb6wxtDTwS9
 YaMOeSzAr4wh0IWr1TPRtl0Qm2v/g8wxVlnyni0G0F/HSbOWz/ExERlrINXXNpX8jkJ4
 rbl/EUKhzfe0+rfykyMeceFWeMUHRNmKbk3NCsyMpfqVJzMmV2jVAedFsxskPLECKg6I
 GXLW/7iVZWkGOId+xSXEmJnDDQ6fMo+saxFPhMQg8rS87l654CEfoNO9S/ESHo4I+0L0 cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39suk8td48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 08:34:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16F8Ucs6032746;
        Thu, 15 Jul 2021 08:34:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by userp3030.oracle.com with ESMTP id 39q0pachrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 08:34:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dS14rsueBJM4/naouDerCMJaUvi6TxVaeDu0Im+ObxbWhbzgJSQ+F5JHKJLiJ80O56hJvLaN0l5p6mE+v84uZTno4/ZU/+PdKXjQI26Can593SLYv2KSVtZlmvSr5UUFzQ5D1cVwv+i18gn45oIVNu4pj66omd5WEUJO3I5TQiFK0TcUXYXvFwKoXHGH/ZCjU6ncEZf5/sVto51Nzm9eWrerUJdJecPakKmOosFfb5Q4fPZOEoh8baXfbZ9x0cS/HKmmmzr4t7qJ1xCe+eKiM86vLIBIgDR4InL0CKkuCrvchh4g7z3oyx36oNvveg7tyYC8V1oIZH/+Gq+2Hhq0Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sk5rTtku/2/YhTdY9tEm1o1apS4dtVXLqJahNgseff0=;
 b=bUmNB6cN62r4x3eBPsNWKOKuzSWaFQvlKBvapQRHf/nlY6T6smfcI93hh8q1Xl8A8TCLgchmm8hL1BdPAQdqPgX5fCYpr/PaMXtJEfPHCjHKJ34c1/VUff0W8n2d5T4ECqSSo9I+qMpeIiiK74W7QJjeLsSU3B4Ig3JKCRMNQc8jztKB17FtEAmtanXx0Zrhfa2k2hXLZDOtHMV4/D/7qVESVoVK4RqNgbLXnfHelpOSbGmXKTlf8HdBCgUD0Ewgq4V95QLm8TgFWkOSpxvR9FfPXNF4iV2DcmoSckU+fSsoa9OLSoTScZjCLR2AQxYEJKHy2Eb6rmlW8MRH5D5Khw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sk5rTtku/2/YhTdY9tEm1o1apS4dtVXLqJahNgseff0=;
 b=GwUdkP8+ei2mKu/fLWUTTI257TX2bdE/6NzU0LISb+r7GjCNXvIfXwi2Lf7GaCtzbib6VDduJJqqnMkwyan97iy76OVX2Lno3eMOoDCjBT9MWaqFLE+ekyFKJ8s1lhsapX8yb09l71NFajOsWN50gW3YTFLNNxTsx2ak/Y5BjJs=
Authentication-Results: android.com; dkim=none (message not signed)
 header.d=none;android.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11)
 by CH0PR10MB5322.namprd10.prod.outlook.com (2603:10b6:610:c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Thu, 15 Jul
 2021 08:34:09 +0000
Received: from CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::b895:ab48:fa35:3f15]) by CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::b895:ab48:fa35:3f15%4]) with mapi id 15.20.4331.022; Thu, 15 Jul 2021
 08:34:09 +0000
Subject: Re: [PATCH 0/3] kvm-arm64: Fix PMU reset values (and more)
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Robin Murphy <robin.murphy@arm.com>, kernel-team@android.com
References: <20210713135900.1473057-1-maz@kernel.org>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Message-ID: <54e98237-263c-1154-6223-88bbee6bdad8@oracle.com>
Date:   Thu, 15 Jul 2021 10:34:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210713135900.1473057-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MR2P264CA0039.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500::27)
 To CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2.7.202.103) by MR2P264CA0039.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Thu, 15 Jul 2021 08:34:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed671e2d-5d19-4b85-ce19-08d9476b50d9
X-MS-TrafficTypeDiagnostic: CH0PR10MB5322:
X-Microsoft-Antispam-PRVS: <CH0PR10MB53222C9DA82966548C9E62089A129@CH0PR10MB5322.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CKIEvX070mfdLWkqSVWUUy28ItdUS/NAzI96+Q+y0a5vRbqThLaVvhnhIrgzkyACTmm6ijmIxNhwR+gTSDBmuiViPbpZVdYEsabmtYOGu8hwYuutJVxSkF/tPGusiVkDXRmJKwvkDIQHHRy0j07l6NrsS3AwbbAE56Ib4f7+kTtCmXQBNWL3W20TIzSmY9RZ2nynDjEen8ntCD4QX0DWhEpa7JmAEVVmg8dyjc0Nh7xNWKnXWwTWXEtGyvNgoXnISm7DFNdZe8FVn+DE5ejRduyalboDBMSWJJ15n2Ccu6+I2KzSFy88Lt/GhYfJ2Mv/nebdbWPtU0993NzX9lpd+gIJSv3ExIws+Qm2Zi0+H38veYilT5O47Pbkm8qcm8UViVVItF83mQe6QIgx9SRdjJRPCvZMU6KJXkW9+3HUrXXiot3ZQ/Eyqr6nAPrZu/HherNYlCaywbx6tZ2cHGFlz3pmMiFdtjVGTm71vRDWx/TM/mu5mrrbcmbt3TfWssCyaM1t7DhFRhqkk7tD0uQTiKLLU42UYUlIFYwiQZRjuEj9C7OfEAFRab10biQvr0CuIekDWuHKpExT4xLsVihZ6lxIFhsuZtBz7S2ooevGunyTzP2bh6lB7nijcXGIXh+kmrnMbtGkC27bwwaf7mao/wKEz4ipqVNe5BL6bV0+49gA2foK+t2b2gL8NFavbKQePchYeNUPHq5c3kO2acYGUdkmkpWTH1iAgwaKJpAbIlA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4391.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(376002)(136003)(366004)(346002)(396003)(2616005)(956004)(44832011)(316002)(54906003)(26005)(5660300002)(53546011)(38100700002)(8676002)(66556008)(66476007)(66946007)(2906002)(6666004)(186003)(6506007)(8936002)(4326008)(6512007)(83380400001)(31686004)(36756003)(6486002)(478600001)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUVxai8yWUVhWTViVkdHYTVKekVuY0dpVHFocXR5ZXNUdHVYdFFlRkFhdWha?=
 =?utf-8?B?S3liaVhBOVM0SzFzdUZOL1FWQk9razQwa2IrZlh4Wit0Mzl5bFdHZS81Q2VS?=
 =?utf-8?B?RzlQdExCR1hsVWZzdGVOTzNzVDJWWmRaWGIzVWwraFhnMVltT3BEdUdxYnMr?=
 =?utf-8?B?ZzhpOFhvRlJQSS81QWgrTDEyRy9pTktkaW1nejZrWUt0UGN2cWNjOGtGQ3V0?=
 =?utf-8?B?ZGthdm9sbVVFOGdYU0s4YmVwYXpnYVB5cm1Fc3VjYStiRzB4OVBQaVYrdnR4?=
 =?utf-8?B?ZjQwOU1MOWlyN1lYcXd1RVVsQWhETnh0QUlEYy82OVFxM2FDcDMyMXJTUm1N?=
 =?utf-8?B?aGhVZHZuYzVZM3ZmZFVrSlVCZENtb3pnOVpqdzJXSTJaTjBlMWFLS0R5ZldH?=
 =?utf-8?B?Z2xDWDRmQUZWTXVURGsrbXRyNGtPdVdEMmdYUTJIRFh5RlZ0Mzh1SWFuaWc0?=
 =?utf-8?B?bDh5V0ZUc0dOSmRYTHVvQ3VrMWxvVTIxVThYZ3BWZkh3NVRKZFFtNUhSNFR0?=
 =?utf-8?B?OTdwYnBrU29NbExySVF3OU5OOUJmdndCR01sL0Z2RE1CUG5Ja0lXRUhpa0Fa?=
 =?utf-8?B?VkJ6b0EvbjNqdldPMGJ0cDIxNmdCMTdLRUJ6bmI0SkREQUNDWEorVVA3UCtL?=
 =?utf-8?B?ZE0yWTNwTVNPdklxNlhIckFweFBNdVNiSjJtVnAxa2xoVjFKRHREUVdlNnFp?=
 =?utf-8?B?YU92djNyN29ZM25adVpRZ3k2TUlLWGZ4QzI3aDEzeGZaN2MzdEhyZzJUU1dP?=
 =?utf-8?B?a2pZMTNqZDBLcG5jeXo5cUh1YzlZNU5LOTgrcllSbE5zNzAyT3NYbHlrZGwv?=
 =?utf-8?B?VktRZ0h2d1hZalZTS0FPYmlLaDZhVnE5Z2xzT2FkbnNOZGpqQ01EbU96aStH?=
 =?utf-8?B?Nm9iUklPcGlGRDhTY0o3OTRrdzkwa2tnQkdLRkthLzJUdXl1U29WWXhxZVox?=
 =?utf-8?B?Zk9tRnltekd4VkZyZzV4d08wWk9ENUNCYVc4c21xSVdtWFNzWU5KR2VQQ3lL?=
 =?utf-8?B?N0VPeE9XWnBpTi9JN1BwM1FTeXUya2hmVm84RkRROHhpdXVIcEVzYkJkdWF3?=
 =?utf-8?B?U1ZxZVNoVnpzTEdsU2Z4cjd3Mm5semUvUGhCZHBJeGFYamZjbDhRd2lDZitW?=
 =?utf-8?B?eVcydS9hZTBiZi9tUFRhSm1Gd3ZodS9NeXZnWGhHeFpaWEIzK0gyeGZicUdX?=
 =?utf-8?B?dHN1ejRjM0R1SjQ1SER3Q210dVlFM0UrZjdzKzdoQ0FyZFlTTE1TM0JUOHFE?=
 =?utf-8?B?NTdZaEorQm5nZnpZYkVTY3JXWmR2djI5Mk1ycHpFazRQTWhXM3duMDlUSmtm?=
 =?utf-8?B?WTIxYjVHS2xiQ2pyYXBxSVE4Q1hndW9Cb095ckdvYS9PR2Z4dlhZOVljVldt?=
 =?utf-8?B?NHphT3poa0FDR29IRnpEWDRSbkxxMVZ4SVVnUzY0eUh3NXEzaExuM3pKa0pi?=
 =?utf-8?B?cnI3NnRuVk5ENnoweXRqblp5bjRZVFVwY21sRitPeDRtSmlITEhUZThGbUh2?=
 =?utf-8?B?Ti93RU81dzA2eG15WTM0ZWt3WFdsWGFmQk1IRmkvM0ZyMmw4eGJNdFg5NGw0?=
 =?utf-8?B?YXNwQ2s5d0ZONlJmVzQ5bnhEcE8wYWtSV0tRV1pDVVBnVzRHa1p3SjVySFdz?=
 =?utf-8?B?NnpwTnBLUzVWVDdSN0ZNblEzcCt2eWpCdjV6dkFpTzYwdnJzZVJGY3JnalNI?=
 =?utf-8?B?Z1ZSVHY1aGdoRWdUKy9oMTZrSWFqalY5cjJHeklEaEY0eWhpZVNHbHZvU0h0?=
 =?utf-8?Q?cbBaI9zLjGBi9d2syyeeaxtcmlwKpCD8sQSZ/LY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed671e2d-5d19-4b85-ce19-08d9476b50d9
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4391.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 08:34:09.4902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MkkwXVqZS6+FKsKSgK8SEz+C0lpKGWTAf2+FZvJAgFxUtsBtjWGCJdPtMnqoTgY4S+JQGJ2SLwP7DxbyBb8aStgzsyDJiE/HTdUUlueQ3NI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5322
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107150064
X-Proofpoint-ORIG-GUID: fw8KqnOfZFOwZ-RzFsoW2zgbPIhJxBAL
X-Proofpoint-GUID: fw8KqnOfZFOwZ-RzFsoW2zgbPIhJxBAL
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/13/21 3:58 PM, Marc Zyngier wrote:
> Hi all,
> 
> After some back and forth with Alexandre about patch #3 of this
> series, it became apparent that some of the PMU code paths perform
> some unnecessary masking, only to hide the fact that some of the PMU
> register reset values are not architecturally compliant (RES0 bits get
> set, among other things).
> 
> The first patch of this series addresses the reset value problem, the
> second one rids us of the pointless masking, and Alexandre's patch
> (which depends on the first two) is slapped on top, with a small
> cosmetic change.
> 

Thanks Marc.

You can add my Reviewed-by to patch 1 and 2:

Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>

alex.

> 
> Alexandre Chartre (1):
>    KVM: arm64: Disabling disabled PMU counters wastes a lot of time
> 
> Marc Zyngier (2):
>    KVM: arm64: Narrow PMU sysreg reset values to architectural
>      requirements
>    KVM: arm64: Drop unnecessary masking of PMU registers
> 
>   arch/arm64/kvm/pmu-emul.c |  8 +++---
>   arch/arm64/kvm/sys_regs.c | 52 ++++++++++++++++++++++++++++++++++-----
>   2 files changed, 50 insertions(+), 10 deletions(-)
> 
