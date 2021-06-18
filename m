Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5764A3AD21B
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 20:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbhFRSav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 14:30:51 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:54784 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229475AbhFRSav (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 14:30:51 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15IIG7UZ014033;
        Fri, 18 Jun 2021 18:28:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=aa7nPtFXzHD8z49qoPtjqz8GmYyMhT4iA75g4EWPpf8=;
 b=UTd4z7KiHrqLSnxSesVByAxSur8nOH3kiFZ7Am5x4hjAop9iMF6dUs8bpqB6hPD6NPYR
 dghyKfpxMxwdDPkKaio0WHDctOLuYkMFmfSp7N4XaUzeC5QmM//sbC7smWd8+kAYfwoj
 ZCDLyyBMJ3tZK9U2QcfKmBABeUZ20rpElIII9WVxCbmgSebh4T6tkqiAR9j1XnxM33V+
 Gbus7zDivFoGom/trpT1w5e30Vnw/nis03wOlkT1BTrmzeHfzrVwX5PY7E2EWIi4CkOF
 x+95AxxEV2Ar0pTwzHtyxrmfVCU1WUVJ6bauB6hSL3HbK3Otx+iFJmWf1kisiZSZB+wZ BQ== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 398xmp07v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 18:28:40 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15IISdNZ048605;
        Fri, 18 Jun 2021 18:28:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by aserp3020.oracle.com with ESMTP id 396waye9wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 18:28:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6s1HC/HI/4Fwaf3s84JSKHxioSgNPYI8I9FiOgnGVZA/Ra+5yRqeWaz1SdBdANUQvd0E3Dmn54+YfVU3oZ6yly6UAFHZ4SbZV3o4LIyDkgzYZv3ifXr4eHuWxYDQAVc6E1XZ18HQyCMRe3PaxCOIu0ZIxApfJfV4cw6cD7JFEzwYy3K2YkfVKtau3jDC72gp4AQkH3fRF9WXe998dFfAJigWXwfRA6H4c1Go5RDnVEknaWl8tVxjIIYk30my/y4fdEz+th8f+iPaiRPFqBNn0jB+NCScxev3DuROQnd8A6GkK7gqNiV11Ndox5EPG7ofecrGM8HCgw7yIt8Nhi+kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aa7nPtFXzHD8z49qoPtjqz8GmYyMhT4iA75g4EWPpf8=;
 b=Hv70f1NLiRzwR5cnaDHglFdnZVRjRHJXepK3JiTELOSs1GyDp1VdYLNDe2HR+UNttlHuXtFDZO6d8Ux0lZ9bKY7XwyRwJ2c4XUP/sZZ1O1Qfeb7ZlHI7rdnp9HA0CWwyIBvv+fVvTKgEMlgYb3TrEo5NM5yHqoF72IjcmdTObZQWECgX45Aw/g3qH02Yk1PHZpILoM8XAZwQSLYUylilgC1EZjLARbW6Nbd7HHjXeDVWGblcmXtGW+OUCFpdEku9BGvrc2Y7sZyfJjtmjxLhPiMKpvN7IvNsRVSSNWNWKxlac9hMPSjfYdVEVdwNOU8r1Za4iBfPAfB0RCcjZ0wOnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aa7nPtFXzHD8z49qoPtjqz8GmYyMhT4iA75g4EWPpf8=;
 b=ybUf+38pz1HYUh6LLBAoTauRcd9o6ENDfMJyvHh1ZE8NS6n4VzYB1CL1etGtVJ+WxsLOp4RFX8EvQ6yReLGEPpKT5Fz6hIOfayWZM0iLSce9GWXpY0hq2lNVy1FTEuGLc8rqzK0kPl8+uiqlfqN99xVw+GWhs2dTD17GAExGKhg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3019.namprd10.prod.outlook.com (2603:10b6:5:6f::23) by
 DM6PR10MB4281.namprd10.prod.outlook.com (2603:10b6:5:216::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.16; Fri, 18 Jun 2021 18:28:38 +0000
Received: from DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::7456:d3e1:308d:b7e6]) by DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::7456:d3e1:308d:b7e6%5]) with mapi id 15.20.4242.021; Fri, 18 Jun 2021
 18:28:38 +0000
Subject: Re: [PATCH kvm-unit-tests] svm: Updated cr4 in test_efer to fix
 report msg
To:     Lara Lazier <laramglazier@gmail.com>, kvm@vger.kernel.org
References: <20210618113118.70621-1-laramglazier@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <ca3ca9a0-f6be-be85-b2a1-5f80dd9dd693@oracle.com>
Date:   Fri, 18 Jun 2021 11:28:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210618113118.70621-1-laramglazier@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: SN7PR04CA0190.namprd04.prod.outlook.com
 (2603:10b6:806:126::15) To DM6PR10MB3019.namprd10.prod.outlook.com
 (2603:10b6:5:6f::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by SN7PR04CA0190.namprd04.prod.outlook.com (2603:10b6:806:126::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend Transport; Fri, 18 Jun 2021 18:28:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecf8eb6b-c53f-497f-e84c-08d93286e3de
X-MS-TrafficTypeDiagnostic: DM6PR10MB4281:
X-Microsoft-Antispam-PRVS: <DM6PR10MB42818CB460AAD2E357EC7AD7810D9@DM6PR10MB4281.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:635;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: INCjHWg0LTi0h4ZU0u6BZz5X2dyWrRvzhIY+sILUcgrlRxzbage4kg8UaH8B4vUfJ4okTCn9fve6499oXKnPxbZOFIKurAaYs9vM4zyUo4mt4sHPj8LCKo4nQwP5o+FJQWH64Bgz/wd7tCO7OcueldvZ1PMHVNjfI+mOHsVeYkkmhxJllavUo/SNJ5+nP5qILvgxeoXc77bDY1UzW40hC0+kb57b51XglN1UtUuFzSH3Ax/utaHogdx0oaJZ9cwURsbFbVsaPOlvE59z2yTR0yEcphT9Y/1XJyd1o8xzqD9Nl23AQRpQ87lzehUITcghnAb/7yMTaheZfne6bpPLlI5z1dGPujvTM9NAlGSg1GdZnUtm+dWo9BJ/yXvabavGraRrwC3lSAn4defWaqSQVUFd8YwYUPo1jI+uhvoh8TLR/yhAkzhOosillyFznvtDR/jbKBItTgicE/+fLsNBOrMRyemrTdryPwVSlgqOout42o1UtR317H64Xt7tb+ya4IEDd1vhTVNTsyq3wwLYa5NLGYwBzjh//rw2QDycr9WJQoGw1DIyObJZeQT9P5WhjrSwDDVuYxEwDt+Ag/skPq5ndSvknsRdkpvxELdu/Dc7E4mlNWLBEhXae7cG6CflZAxG9MDSp5JAFb+9J8SP+y2Pk91EPF0GJqbLqUWxyLjTNjP8ZoCYb7c3+xziYHL3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3019.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(396003)(39860400002)(136003)(16526019)(38100700002)(6512007)(36756003)(15650500001)(186003)(66556008)(6486002)(478600001)(8936002)(5660300002)(53546011)(6506007)(2616005)(86362001)(83380400001)(316002)(66946007)(6666004)(66476007)(31686004)(8676002)(2906002)(31696002)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2NRbWtjZGNPdEZJRSt2ODVCUWhvb0JqVWlxQ3hIa2xXOW83TjB3Vk1DV0cr?=
 =?utf-8?B?aXZYd1NuS0F0dC9TVU41bmxIQ3lUMW00RE1iajhqeEFiMC9RWEhSaHY3YUZw?=
 =?utf-8?B?MlZnNHpGT2xsQXhOdDl4Z3Zzdk1teWhGYjJOc3F6ZExRQi9Rb1VhbVF3b1Rt?=
 =?utf-8?B?a3BXNkh5NnFhL2xWRFFnclVGWGZUSFJWcVVSKzBSZzNzRXlYS1VVZVI1V1k1?=
 =?utf-8?B?djRjamN4aEppaGNCckc0L2NLMzgxeVlUUUtsSkxQcGZkR09uVW1XdW9aZEov?=
 =?utf-8?B?QThYTWpXWEJCZlNlVlAzSTZYWGQ4OGdsZ3dhZ1BENXVNMVZoVnEyblN1K2Np?=
 =?utf-8?B?TU1VSDhjNzFGNmFyb3FQaUFJejc2SUYzSkVwUGlVQzd6MWxLb1N2WXp4blk1?=
 =?utf-8?B?U1VUbHhSQ3BwYzZnLzNaUTlrNCt1QTNCMWcvWVpPMUFNa3Z5WC8zTDZ3STk5?=
 =?utf-8?B?WHNYbzg3Vy9iVlZvNS8yY2JKdGd3OUQ0NVpBbWFVRC95MGxDU2hnK3BTb1U2?=
 =?utf-8?B?ZVVMbHhheHdyR1gvMDBIY2RSbnAyOFR0cnR1NzBXQzkzOEtvQmdGVytkN0hP?=
 =?utf-8?B?Lzl3NnJmRXNIZ25MT1N1N2tSeVBBK3FxcEs0UnN4YVpkRzVzZHVxV1RZMUtz?=
 =?utf-8?B?ZTJTcFM0dEo5RnluWXJKc1g1VEhpaGdURjZOZVhQanhaM2ZLbll0YXUvcWJQ?=
 =?utf-8?B?RSsxaVpFQ1BXVVgvSWw3cGN6MC9RdmRkSFQ4L0xTVU5BV2hXQ0FyN21nUExR?=
 =?utf-8?B?SXNDK045VFUyZHYvbHlCMXUxTFlJRUdwb0Iya2RrdGZpd0QrMW1uOEZLbWhB?=
 =?utf-8?B?ZFlpT0htNjFYR3BORkxkTitiWGdlZUp3bFk4dy9NRXZqbFpFUWtrQTFXemdP?=
 =?utf-8?B?NUI1S3NkY1YrcXVoeVlBUGtJYlhLR3FjYjVNeU5zS3BvUE1zeHl2eU10d0NS?=
 =?utf-8?B?aE9ub3U1ajEwd0o3T0dLdHcvdUx6Skw2cDkveVNqMHpGcFJtSllWVDdQQU5v?=
 =?utf-8?B?NmdGRW8vbk01Ykl3TVZsWG5nOU13TFdHTWttYUR6RWcwdlhuSy9aTTdFWUJV?=
 =?utf-8?B?VVE3amRmRGNLUm5HcTd4ek9hYk1uZUZSQWtkZ3dzVjNEenVLY0x2am1pVXBv?=
 =?utf-8?B?YXZnVXo4NEtVM1NGeXZZRzBZaGFTck9JUW9qcm1nT3V5NzZreGpQbWhLQzNE?=
 =?utf-8?B?MFBnZTNSV3UxUXl5akNRMy9JR0g4MGx1alY3eWxVejNXbm9yNUxNdFdwRmlB?=
 =?utf-8?B?NTk0NG1GK2FZdlJZM0oybWR0Tjc4cXVQZ29ESllnUk5uTDlwUDR3MDhLOHZZ?=
 =?utf-8?B?c2lIMmd0M1BjVmxwZDY5NENlOWhqMlVyNTlKLzdHSmVmVlBUVHJkd2RvU1M2?=
 =?utf-8?B?MzBYSGltOHJtaHlWK0JJK1JzRHFsZ0RjTnNHY2lqc1MvMnFxSWRURmMyQWY1?=
 =?utf-8?B?WFptOWloeDA1YkQzV0VFM1grRHlYS1RCSFRVN0p2bk5ON2RSSlpSUGpkNEor?=
 =?utf-8?B?R0hObUl0S3o1Y2tBMkFiSEdxOHp6VkFpZFdGblhJSmE2cUxKdGhFZjZqRlFn?=
 =?utf-8?B?NUdnSCs4TDZFNldlTEkvL0RuamZna1U5bHpFbUZmK0g5MUJreFpCMWlWZDYv?=
 =?utf-8?B?U1EyVkY1UFgxQnozbnRsYVEzUTQ1dEZyZ213dHJ4dEc4eHBYemxWbnFzZGVl?=
 =?utf-8?B?UUxZNnlscTZ1MHg1bGJtSkp3QUU4SGJGV3R1SkNkdThaejFjZXo0eDA4cndH?=
 =?utf-8?B?REI1UDNIb0YvbXFPL0VsZlJ2Lyt5RUZGaUpPQmtxckQ0dzFIWjFHU2dmR3dz?=
 =?utf-8?B?NFRVN1lrb0paUDF5dXZ0Zz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecf8eb6b-c53f-497f-e84c-08d93286e3de
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3019.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2021 18:28:38.1307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UTPYgJhD4J07gE9FhM8ZxerqvX3YmQNG8cvO/24mTbqqhwKBAVlOAkQQCKvuEqqY5pP9N7GezDmU3YINMaPRG+oBC7dFONym4EsKN5fDwZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4281
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106180106
X-Proofpoint-ORIG-GUID: rTeAtdPOu1qA-OpzFFErb8_t1Y5mrDfq
X-Proofpoint-GUID: rTeAtdPOu1qA-OpzFFErb8_t1Y5mrDfq
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/18/21 4:31 AM, Lara Lazier wrote:
> Updated cr4 so that cr4 and vmcb->save.cr4 are the same
> and the report statement prints out the correct cr4.
> Moved it to the correct test.
>
> Signed-off-by: Lara Lazier <laramglazier@gmail.com>
> ---
>   x86/svm_tests.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 8387bea..080a1a8 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -2252,7 +2252,6 @@ static void test_efer(void)
>   	/*
>   	 * EFER.LME and CR0.PG are both set and CR0.PE is zero.
>   	 */
> -	vmcb->save.cr4 = cr4_saved | X86_CR4_PAE;


This test requires CR4.PAE to be set. The preceding test required it to 
be unset.

Did I miss something ?

>   	cr0 &= ~X86_CR0_PE;
>   	vmcb->save.cr0 = cr0;
>   	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
> @@ -2266,6 +2265,8 @@ static void test_efer(void)
>   
>   	cr0 |= X86_CR0_PE;
>   	vmcb->save.cr0 = cr0;
> +    cr4 = cr4_saved | X86_CR4_PAE;
> +    vmcb->save.cr4 = cr4;
>   	cs_attrib = cs_attrib_saved | SVM_SELECTOR_L_MASK |
>   	    SVM_SELECTOR_DB_MASK;
>   	vmcb->save.cs.attrib = cs_attrib;
