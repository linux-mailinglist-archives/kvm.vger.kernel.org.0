Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38073F6B94
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 00:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238781AbhHXWLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 18:11:54 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:54134 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237178AbhHXWLx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Aug 2021 18:11:53 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OKuw4H021207;
        Tue, 24 Aug 2021 22:10:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=mYkvt2+J+gH4k8TSOFzOVUfRAPjRFIAhh3uqeq46kiE=;
 b=gIPfytDIh0P/Zgoe6bsmaruO2ndwHd2RyQSoFWqiTGOSXWrcggpqe3rGXt+CXX1dWPlC
 J9vIUVGamvXEyjnrkEc9mFTSY9Je2yyVbnmhRdcR6/cvvqPlj03U0wau49R06dUxtJ7C
 JBUHfe9pE1MXBP1dwRkcjnuR80Mafy/ZGVXZZDngMqg6rNjtHVSSg0HxsA/i2S+M59m7
 NqwbhElvoBBAlRfI20TVtkvn9cZdj75Fyin6vVo5Y/4H7qp6rjKebD34KiYkj13Jl2QD
 03+POFV9KgqFvDEcTamPkwKsdaz48ubiAk0IO2UuItBU01UK1c+SVcSLziMiLcZ2xsAa EA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=mYkvt2+J+gH4k8TSOFzOVUfRAPjRFIAhh3uqeq46kiE=;
 b=VCGllmka28OvbTtwJA8ERAGrr+G/F9en98jHqTGIATOTOOMq6s5yoaZyeJYdINUP5NoW
 G8MlopZFEUCSI0259XyEh7a1bxzMmiBWBokojyZPlgkp63Q7QF4Deqw1E5GHLYGivmVv
 K1G1oNTODPIooYVQ9Dhhzj0N3bNKeBX7A0YCA0FuK62JzPRObU4hdvieFLjavIYCXeFW
 UJObb3KxPu6uQSzekn63ORtsHI/H6Le6t9xKKLdd5+vWc9sa2u/gkhjEaOad1y/9OHXC
 v5T2CaKDiqeJ4XN8WuDl5S18uocWnB0+rqRK7kkPEy6Dk0jfQguCdZYMZZzfBEXQGKq3 0g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amwmv9xp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 22:10:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17OM5Ful134874;
        Tue, 24 Aug 2021 22:10:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by aserp3020.oracle.com with ESMTP id 3ajsa62h3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 22:10:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XBHH1UKt67w80k+DDM26YSJabAjcAOTJWlq0ryISACYnYaSaHaifyGx7GZ0GIkOB5rn5631xqItxrbTT02tK5bXhC9vgQP8DHX1eRb4Ut+jXUWwr5mdthHfVq/+9x9WjfsvdSNbEbu9eFdG4Z9qNdxzVXdGkSHyyvDscyRAUFqFqYuN7T2A5WnmVzrZpPcbkyeTNeh2xeYm/LFiHBps4sskU1WfgA2ClnPi3wxswWVGrJzU1PgJh7WUdd9MchvF+cPmzvfXEyCM4HyRA2kM4AWwerH+Iumy3epYgIYgHlfFYNR74z8ZgPnbyXywxkNA/q8i27jHJo+DVy+cfEpch7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mYkvt2+J+gH4k8TSOFzOVUfRAPjRFIAhh3uqeq46kiE=;
 b=X2T8haYvAPr20bKzgwuPBuH248gyGSdiHJcI8LrqV8752zaIojTLLRtWjvGVx6pcwff9fWJLuC/YFYUrfk/g94mm5SczdJSHi8m+i0f44hDMXiZvy0PcpeTsD1Un2b/hahYbnv15FNnSQL3aAR+Mvi4r+sz7ueD/c4HaR1yzdPWQf6KvBpQn4ApUTJ+z4A1G/kTiOjheHPaUg3he8W+jIpODhUtqYMpSGKuOX4aOzKJRuDUTBJA+4HiimceGw7vVtg7CCmhzZeNJFGjD9xvEl5DJbUiMF5K3l94SicQEkzuihfSUk06+h1sNc7s5kBxMRLzgVaLkr1ZmT/RZ3pRefA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mYkvt2+J+gH4k8TSOFzOVUfRAPjRFIAhh3uqeq46kiE=;
 b=tDp2thghraVYxgMb8Wa538vsYHIGRD0Mc+53n92vEHpz9YCSzOeSlGFHpSOJR/gE/3CayWe/1lKvhRP9S2wXR42xjVjk8I6UrqkMP3Q/Rr8VYqQHf6JUG+9MbfLJCcv8caPhEXQjhyDve6NQRJWzLTK/Q9NyqTRtbIN2Nx8UoeY=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3019.namprd10.prod.outlook.com (2603:10b6:5:6f::23) by
 DM8PR10MB5400.namprd10.prod.outlook.com (2603:10b6:8:27::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.19; Tue, 24 Aug 2021 22:10:53 +0000
Received: from DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::f9b8:94dd:1c44:cb2b]) by DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::f9b8:94dd:1c44:cb2b%7]) with mapi id 15.20.4415.023; Tue, 24 Aug 2021
 22:10:53 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [kvm-unit-tests PATCH v2 4/6] x86: efi_main: Self-relocate ELF
 .dynamic addresses
To:     Varad Gautam <varadgautam@gmail.com>,
        Zixuan Wang <zixuanwang@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>, bp@suse.de,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        Hyunwook Baek <baekhw@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Roeder <tmroeder@google.com>
Cc:     Varad Gautam <varad.gautam@suse.com>
References: <20210819113400.26516-1-varad.gautam@suse.com>
 <20210819113400.26516-5-varad.gautam@suse.com>
Message-ID: <430f4a8a-4eff-5f32-3dd9-103e8e5b354c@oracle.com>
Date:   Tue, 24 Aug 2021 15:10:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210819113400.26516-5-varad.gautam@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SA0PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:806:d3::15) To DM6PR10MB3019.namprd10.prod.outlook.com
 (2603:10b6:5:6f::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by SA0PR11CA0010.namprd11.prod.outlook.com (2603:10b6:806:d3::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 22:10:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19ede1b8-c7ac-4086-ddd7-08d9674c0a24
X-MS-TrafficTypeDiagnostic: DM8PR10MB5400:
X-Microsoft-Antispam-PRVS: <DM8PR10MB5400B5303C56F293B49E138681C59@DM8PR10MB5400.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wm1tvXzjPUC1HO8+hDYiiH3nh2YXhQhEmB2ZX4W7Gv7J+J1ZCwITzIM2vcDPRcgm8T/NRSskzdPvaFLn5zgm2QLojvI9/TSLGIE/70pEey08C7zbFbVQnrIdn4xv4HVbI4oElFfdK3eHsNSmCjrT5TXAmkOKArNsliXuGmU5cU+Cip5nP5nJh0PO792FeAs7T9xVIWuGPuiZon8HSNUCoRN2Vqy+zOqDboik5VqNeze9SLlx5zGNI7n0vbuBO8Osk/EHEZpPL+9nt1vsePM6U7gIzQvj0A6e8IAMhobPP5vXpGXxyRAoYxtlEta9I+ABCvxwfrH7WI8kpiTioXyXBWv86sfyD5BHjwKW493aQZb+x3e/X091FKOehHOFLVGBQ60E9s03hk54TJ0nP3tsFsWuldFHupMCPmnddr6ZZIYxry4X4EsJ5ujaC5wVq/CwT7LOZ6MasjhchEPuxy/5fLPUaXt6ffjlPC0NU4BOqcnB12zKK29A7YzbUOqeC7u2r+Snw9KGYcjRKOfp0GubF/jJNhpatambLmiJtEiRCyRYUrXOvwQ7LIDMkYIisELJTVJkuT7+8+vsoSN/hBZLBhzMfHDi4OyL11fUto+dcAO6IPZ1FtoCxMQO0QM6xgaOPi01ANfmo0IgDxBpepeqncXDaOnvORwWmEtL8UO58iUQCHNJU/lgko9Gmm4HmMZm5LdGoMPRps27mjuFhm/2La3lumGB4/9R8TMA0rPn9VHwQqo3o6JulXFQ5Oy86K6Ev9FYi6fBBLAttRcohxUk/vhwp/iVYYAJPUB6P8pbCLY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3019.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(346002)(39860400002)(136003)(478600001)(2906002)(921005)(5660300002)(86362001)(2616005)(8676002)(31686004)(8936002)(316002)(31696002)(4326008)(6506007)(36756003)(110136005)(53546011)(6486002)(66556008)(66476007)(66946007)(44832011)(6512007)(7416002)(186003)(38100700002)(142923001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2MwMFNhckwrRHdiL29vTW1kZDlIV0RNYlpGYXA1Y0UxRGxEd2hTdUJhMHJS?=
 =?utf-8?B?bktwRzZwWFpuYjF3VmYxRXVtSGlhaXA5UGFVMHc4MllIYUlCY01oNzZHVWlQ?=
 =?utf-8?B?eXBOMFd5a25JNm53THAyVEk0YzYzTHNJajZlVEUyRXNHSmlsNHVHbFl3SHhz?=
 =?utf-8?B?UENiR0VFQ2FoTVBUdGtNZHFxZ2d1b0FidHBGTGpFWmd5dnNwRVZwUFkzMlRG?=
 =?utf-8?B?MXA2ZFo5cUpDYnZBZlN5c3BRcmgreUZqWm5Rdmg2bkkwdlFSWTVnUjZHeHFL?=
 =?utf-8?B?dXZtZDBqdE9YQzZCS2dNcE1NSUhIRmMxbDJFRWI4NmVkWmNFRFNOa04xZ3dY?=
 =?utf-8?B?ejFVRmRXRmFXc2JKdDFyWkVjZE1DcnlWdkNHcEV5cWRGbXZQVDRaSkpObjNO?=
 =?utf-8?B?Z09RcFI3VW9ZVmZUY09VeTBxazVUbC82dlZyLzNtdExaR3pUR2x1T01rcUI5?=
 =?utf-8?B?a3JJMkt3SWF6blpISEZaOU0yZ3JKL09td1dvYlRwTGNWUWRCV3VycjZNSGd5?=
 =?utf-8?B?dzZIRkI3NWorRWh2MmxkZUp5NHBhSjJNYTBvUkxPMFlXU1RMQzJnVkVaVzBB?=
 =?utf-8?B?N1U2UVZSd2hHS1BoMmxHUWkyZFFYd0NrUithak1tS0s4eXpUZTRXTEQ4T1dF?=
 =?utf-8?B?ZWdBNWszUlJQVUFyVGNja0FkeCtPYXJDY2w5WXNYWHlFamhYbitnOU42dUtP?=
 =?utf-8?B?WmNwWm9QNjEvVTdWRkNmcUNleTNuTmJKVmY2MjJwM2M3UVNob2F6YTlXWXdY?=
 =?utf-8?B?WkVaYW16OHpLYkttVEMza093YTVNcE1RNUZTMFliazVPRS84b2N6cWVVWWli?=
 =?utf-8?B?YWhoYlZORmhPTGlja3BWYzNMNVpxdXZyZlNJbXRIM1dZc1BwQ2s2ZFp4Rm41?=
 =?utf-8?B?T1NGdzlXMWxwdG9aR21TeFd6Nk50KzQwR3BYM3FDUXV6ZFExVllnMDFWbjl0?=
 =?utf-8?B?SGZaeStlcm1NdGFjUi9sbUcyQ0VEUXhzTXA0WW95L0EwT1BwUnI1V1Q1WlM3?=
 =?utf-8?B?blN0bk9Iam56WVZ3NnNQbHhiaWNNTXR3NnhrMUc4amYxL3M2bUlFSjhJNGV0?=
 =?utf-8?B?OFREd09LTlBTNWo0YUlkdUdIcVpxamw3MzNTRWg3cDJwMDIzZU0yVGgrMkNO?=
 =?utf-8?B?R3cyTkdRaHZRdllBUTgzZjdzRjg3SFpqRXlFNDNHcVUyODh4YXNVV2ltcWE2?=
 =?utf-8?B?WmRNSGlNS2VaUWMwK1pkTkZSVFVQdW5aVHlWUmRJRGRKRGxXUXkrdGtmYWQ3?=
 =?utf-8?B?bXpZM2Y0VS9Mc00vVnhCM0hwR213ejNtTnNpOEJmWWlZNTIzL2ZVbEZOUVVp?=
 =?utf-8?B?QVZEalN4d01DT2ZpVThTWGRYdnRJVXVCYUVXYU9aUm40ZVJPUkxIdGtXeEww?=
 =?utf-8?B?dFpXVXN0M1MzZFk2N3FraStKQ1Vzb1VndGtyL2lDRVcrZDBTSGVMUjZCUzha?=
 =?utf-8?B?OVlUaTg0eFJnNzU4cGJSUjRaVXVGZzZqSEw1bEtQL3lpaTAzeEpRQVJCQlRv?=
 =?utf-8?B?bmFaYWFNOFRhVkZxanlzSDROUDgxREp5RFFqOFdXQlZ4eUFLNHkzM2o1TFNY?=
 =?utf-8?B?S2s0OTg4MjJQOHJXV0t4czJBMXk0WXFqRFZSaFpHN0ozb3hBSVBieTlyMmxT?=
 =?utf-8?B?MllJRWVzejc3VUMrdDhwTGwrTUxMUFc2bEdjT2x3WlJzL2lwZzIxQWJnaVdi?=
 =?utf-8?B?SVQxUW9qbTNVVVl3eVhkbUhMNTdsT1YwUDRXR2Rwd1hMYk4wQWJmd2tZQTd3?=
 =?utf-8?B?aW92NXJEOUJxRmFqeEkzSVlJUkFqdVZiMUNGbHo0U2x3Wms3bHY2U3llMUVn?=
 =?utf-8?B?YzVwZDFNMkRaOUNFZDlwQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19ede1b8-c7ac-4086-ddd7-08d9674c0a24
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3019.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 22:10:53.6208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: czyzT0JWdEQ/5JKZ5/XYY5bzTFXGqCwsFHjhpcVt+BUq7jXVNhwsBuuPoHKxXYMyw0Jz/DowBOXumY3fL2vl9svxK67TnmhTosu45Hz7XMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR10MB5400
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108240138
X-Proofpoint-GUID: Utroc6I27v45uUq-sJxpqv7vsBlajgiP
X-Proofpoint-ORIG-GUID: Utroc6I27v45uUq-sJxpqv7vsBlajgiP
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/19/21 4:33 AM, Varad Gautam wrote:
> EFI expects a relocatable PE, and the loader will patch in the
> relocations from the COFF.
>
> Since we are wrapping an ELF into a PE here, the EFI loader will
> not handle ELF relocations, and we need to patch the ELF .dynamic
> section manually on early boot.
>
> Signed-off-by: Varad Gautam<varad.gautam@suse.com>
> ---
>   x86/efi_main.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 63 insertions(+)
>
> diff --git a/x86/efi_main.c b/x86/efi_main.c
> index 237d4e7..be3f9ab 100644
> --- a/x86/efi_main.c
> +++ b/x86/efi_main.c
> @@ -1,9 +1,13 @@
>   #include <alloc_phys.h>
>   #include <linux/uefi.h>
> +#include <elf.h>
>   
>   unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab);
>   efi_system_table_t *efi_system_table = NULL;
>   
> +extern char ImageBase;
> +extern char _DYNAMIC;
> +
>   static void efi_free_pool(void *ptr)
>   {
>   	efi_bs_call(free_pool, ptr);
> @@ -93,11 +97,70 @@ static efi_status_t exit_efi(void *handle)
>   	return EFI_SUCCESS;
>   }
>   
> +static efi_status_t elf_reloc(unsigned long image_base, unsigned long dynamic)


Since this function is only relocating the dynamic section, we should 
probably name it something like elf_reloc_dyn().

> +{
> +	long relsz = 0, relent = 0;
> +	Elf64_Rel *rel = 0;
> +	Elf64_Dyn *dyn = (Elf64_Dyn *) dynamic;
> +	unsigned long *addr;
> +	int i;
> +
> +	for (i = 0; dyn[i].d_tag != DT_NULL; i++) {
> +		switch (dyn[i].d_tag) {
> +		case DT_RELA:
> +			rel = (Elf64_Rel *)
> +				((unsigned long) dyn[i].d_un.d_ptr + image_base);
> +			break;
> +		case DT_RELASZ:
> +			relsz = dyn[i].d_un.d_val;
> +			break;
> +		case DT_RELAENT:
> +			relent = dyn[i].d_un.d_val;
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +
> +	if (!rel && relent == 0)
> +		return EFI_SUCCESS;
> +
> +	if (!rel || relent == 0)
> +		return EFI_LOAD_ERROR;
> +
> +	while (relsz > 0) {
> +		/* apply the relocs */
> +		switch (ELF64_R_TYPE (rel->r_info)) {
> +		case R_X86_64_NONE:
> +			break;
> +		case R_X86_64_RELATIVE:
> +			addr = (unsigned long *) (image_base + rel->r_offset);
> +			*addr += image_base;
> +			break;
> +		default:
> +			break;
> +		}
> +		rel = (Elf64_Rel *) ((char *) rel + relent);
> +		relsz -= relent;
> +	}
> +	return EFI_SUCCESS;
> +}
> +
>   unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>   {
> +	unsigned long image_base, dyn;
>   	efi_system_table = sys_tab;
>   
>   	exit_efi(handle);
>   
> +	image_base = (unsigned long) &ImageBase;
> +	dyn = image_base + (unsigned long) &_DYNAMIC;
> +
> +	/* The EFI loader does not handle ELF relocations, so fixup
> +	 * .dynamic addresses before proceeding any further. */
> +	elf_reloc(image_base, dyn);
> +
> +	start64();


Should this call to start64() be moved to your next patch because the 
function needs to be fixed and you are fixing it in there ?

> +
>   	return 0;
>   }
