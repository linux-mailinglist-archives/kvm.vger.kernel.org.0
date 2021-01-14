Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D612F6EAA
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 23:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbhANWx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 17:53:56 -0500
Received: from mail-mw2nam12on2072.outbound.protection.outlook.com ([40.107.244.72]:32992
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726825AbhANWx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 17:53:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+l9uPEsjF4L5cEwqG2aFqy424Zo3yhR8V35J3KHSYmqwOc2YrzEwyrviDX64PMd/MrqSZGPpb9E5QGGs5LmUE8Jc97NHVYkZtU2fxh0c4OiqjSr7AUG1byhQukkjbkq/MQHtpbez5vR33yrha+oXDjS+HoJC28nXCAaQMKvKVFi0tJsaJxFJ7tMWRjMF7SmPJinmofklesRpD+s46+LjvrzOV6rWD/ReKphWWiRUCsXrQsxWJAWvylcd42zF+1s6n5VBzZaQuwUXDV25on8/UK2OsIWcuzlR7B81sxwWm4/eREBaijXMT4W/YMEBWEVmStP5N2o9QOV6mr6Qe05Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MxbwiXFMi3dyThBxYWoDvQ+452lyu4rvwPS1YiGz4U8=;
 b=iTvj3EVhq08KD7LAEmx5Jt6W+SEllP29+kjDTrbSBIF8rSu0BmbkyPbhJSZKJvfHxdy2D9/mkcfOdceBkQtDs81LRBqSwvVozx5829fPXUXgWtZE6ssMQGagVFZwJwUR/xDwieoGrXu8zHmHg21bYgyEtQdj2NVoVZZuWIJ3f7n+VW1FplenvqClaOSXkgAgw1dGVorCIm2MKlu/QAQOpQUGNHlfUcyHOXfKGJu5liDsIbdzUSrIGXQ55fTADeGdHtmSLD9/x95Z3f0XvdOe/JAyMERPlMZdxnGf05mk2bOdGXTsqlIKBTYiLjCqlBaS9CJQLtLf69VddNym5evW9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MxbwiXFMi3dyThBxYWoDvQ+452lyu4rvwPS1YiGz4U8=;
 b=jUTpPxqoUm7ms5LMunOXZU9Q5Fez32weYMBldpDXpE8hlWqWrhA0hMg91etCEDC/b7SNBCk3xi+mB+MeOE4PwrAsHdyS9K9Gh9k5l7myYgixA5pWabJwBoOTKWeVOTU8WCQZten65U6lniZt3h5oAzElsmcRotOq2GUgH/aHwrM=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4220.namprd12.prod.outlook.com (2603:10b6:5:21d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.10; Thu, 14 Jan 2021 22:53:04 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 22:53:04 +0000
Subject: Re: [PATCH v2 13/14] KVM: SVM: Remove an unnecessary prototype
 declaration of sev_flush_asids()
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-14-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <da50a750-d005-643a-b950-b204884dc660@amd.com>
Date:   Thu, 14 Jan 2021 16:53:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210114003708.3798992-14-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0047.namprd11.prod.outlook.com
 (2603:10b6:806:d0::22) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0047.namprd11.prod.outlook.com (2603:10b6:806:d0::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Thu, 14 Jan 2021 22:53:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 17622c4c-ee69-49b6-25e5-08d8b8df2710
X-MS-TrafficTypeDiagnostic: DM6PR12MB4220:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB422043F48C833D4748B76BF5ECA80@DM6PR12MB4220.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IcyfKX4gTvLiTx1FpvkThc0hOU0QQ0bPgkiO1Yqvk2Cg14Bzl8KmXwXjAfAwVPcjGMfOICPFN+bawjxxcDEp19f7XkCLBYCvIeT1P8I1PmSEDySayARJDYFsCvxs9T+WvXd2dU7IU+5+N5bHrXKWiMcEW4OHHWHNLLZXeYAcVsLcVkICww/nE2aapAdKCnUhPtDmZvQd3+OTEGGHHbQqFR1v/ue4EFAbxCtse36RqLK1HhksF90Mz3iqao8ke8QqNBsf9/tuG+OrtO5BazT3RekKyE99bTwFsUUeUkk6lTdyH4EqpxzMgPi+GHUqQqSih40guGWFKESkopGjPm9b/eI3RrsqViPw/8F+YpKZa5tPhFlk+2uNfqlPELRC0Nb//1b3bYW6THM+3LHvyR849fkPnI+dQP1dYUQ7XSl8ILf/RY7JVLvwI3tYIhtJLWKsWtfSarRUb6dHNxyttMirarmOB+vByQrykWsEQnlgdRo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(366004)(136003)(316002)(36756003)(110136005)(6506007)(86362001)(478600001)(53546011)(4326008)(8676002)(52116002)(54906003)(26005)(186003)(31686004)(6512007)(66476007)(7416002)(66946007)(66556008)(16526019)(2906002)(2616005)(4744005)(956004)(5660300002)(31696002)(8936002)(6486002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TU1adm9iMFhCSk9CT2I3SzNybDZySy9iWkFaa1lEbmhYUlNTVks1dk1VaTlU?=
 =?utf-8?B?TFJnZ2xsNzVWdnlDMllvT2tKRnBRN0twcldRczhKMis5L0tDK3pWZUxUYVQ0?=
 =?utf-8?B?bzRaUkZXaTV4eTF0WllrTnFMY24xRlZjb1ZVZkxwVEtkUjBIVDJPZHh0Z2d3?=
 =?utf-8?B?VnYrU1NlbWJpNjExNnFFTm5FSllvUW9KTExLVE8wTUxuNEI0Lzd6S3NRRWtM?=
 =?utf-8?B?SlRjM3dqSjhMTDhnai9lSmR5ajl5ZTlxSHAyV2JSU3EyRFBtbnoxdjlHek91?=
 =?utf-8?B?OUlpbjZNWWFrUGd2bXovbDBoNXpXNGQvTE1QYWlaYnJDbExiR0xiVUZQS0xx?=
 =?utf-8?B?QnFXRHVaUWp0eXBzUmR0REpDM2hkVk9adWw4NW1peWRJY3NmODNRbkJreEth?=
 =?utf-8?B?dHVyUUJNTjVmUWEwUWdFUE9ocTRQQXVnQklRWjUydnAvUzdpUlhKTlVkSk0r?=
 =?utf-8?B?bGtYNENCSnRWa3hYa2FvWVBhbTF6UldrenA0M0lqWUJaSjk3Y3lnYkJkSEtm?=
 =?utf-8?B?QTFmM3ZQVTFXbGRKa2o4cjNFRlRLT05vZm5mOUlGeXE3THM2MEVqa0pFSG9Z?=
 =?utf-8?B?d1JlbWJJTkt6WWdmUHo4T0ErSDcvNFhTUHlZbGNQZ3U0RGsyUTRvRi8rM3JJ?=
 =?utf-8?B?a2YrS0Z0aEVJYmxVMC93UityRi90R3RZQlV6ZTNUR0VKdmVyZEkzY052eG4x?=
 =?utf-8?B?VktmOGM0RDJtNWtnWUx3a2JxRHphbGw5RnhISDdZczlsMWZpWDUrRmhIdnV1?=
 =?utf-8?B?aUk4U1o1a29BeEZWdnI5SGRtMkRUREZGV3RPbGVnUWhYU3Avb0tVeHI0bit3?=
 =?utf-8?B?N3hVRjBDWDI5RnBKYlRzdkVSdzNFOEZaUzZYRlpEM2ZLSUdkVGpLajRCU3Bu?=
 =?utf-8?B?SWd3UURZZlZFYTF2MWE1d1pYd2tMTzkzWlpQVUZmeFRsaW1iMkVGeS94YTlP?=
 =?utf-8?B?S2JURHRRUy8zcEZsZzAyeDlBRnhQeXdDQyt0L3pqUlRLZDZ5dno1NXNSenNp?=
 =?utf-8?B?bjViZi8rLysyWDB1MEc0Zm5ONzhjQkw2Wjd5akp1cEQ4WWRkYys3UTdPTVBt?=
 =?utf-8?B?REliRkFDWjYyc0pYMnNlWWtMSDZ4dnlTRkNISUczd0dwSUlsTkF5NGV2TUhr?=
 =?utf-8?B?ODM3bW5CSzJUSmN0SURTSWREdHhlQnFvVzdSY2gzWk14MmxzSG9yRHdKK25Q?=
 =?utf-8?B?UG1BNzdMdW9PbUk3T3QyVTVsUVJTamlqYzFFOG13WXViWVpBWXd1TG50aXJ5?=
 =?utf-8?B?T2dFcG5WSHF0MzFWQ2orQTRLRzJFSGdhNkowNEo5Rkd5VDMrOXRnMFpjUW5I?=
 =?utf-8?Q?+uUUedUXUo3xIjqJ599J70f2KMcL27blWa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 22:53:04.4543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 17622c4c-ee69-49b6-25e5-08d8b8df2710
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4G/1SY+UGx6LxqycBBraD4q60nxVHIFsDSUjQRqWsNAE0VcQ2mLM2H3UNG5XigJbhSZLg2iTYy29pHlATU6UoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4220
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/21 6:37 PM, Sean Christopherson wrote:
> Remove the forward declaration of sev_flush_asids(), which is only a few
> lines above the function itself.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7e14514dd083..23a4bead4a82 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -41,7 +41,6 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
>   #endif /* CONFIG_KVM_AMD_SEV */
>   
>   static u8 sev_enc_bit;
> -static int sev_flush_asids(void);
>   static DECLARE_RWSEM(sev_deactivate_lock);
>   static DEFINE_MUTEX(sev_bitmap_lock);
>   unsigned int max_sev_asid;
> 
