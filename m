Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF092F6D73
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 22:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbhANVpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 16:45:54 -0500
Received: from mail-mw2nam12on2053.outbound.protection.outlook.com ([40.107.244.53]:13348
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729214AbhANVpx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 16:45:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZUP1aQIfpjo3sp0owp2iRsdOnbpvziC/ZFbuLO2YraW1zkDO5itzHLsmlef6WmwL6e7BJcbNC7T+pQL0h/9gtql7Px+J0TwsAl80OdFAvBhWLURxQaUMtcHv8ufP4OSBtHh4tnvWaD27aQEG8xXLTiRNkXcCcDrMofBRnrarcWUqCCCScANMqTnd//u7Nn7d7k4yXMwZ3anLnfkkmUbTFvjKDE/d5ollYxKP/DBey4tb6bED3vbM5SLrhDv7DdL6ZjlLxyx5SKTSb0dmjhc/1mvsyKlzcyh5Vn4w0QmE+i0mZKKBZHtWK0ya4cC28uc2UxtiJI9jHnLwtYOZ3LwQnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIqvf+SLcFrfMSsrG9lrC91rdlubElElCUcNyHEyzec=;
 b=goY7GvKPXt1B76JFJNa+kWOX4yj0CFQGcyCB7LYFu6na6Pu6K49+uD41FLfnxICgJ1y+05N4CxA7LbXzc6qsWC7et9PWJE3t6KEScPa10fN45se3rsLtwXOTldL51T/hoRm8K+dSguiw+f6U6DDMWf0VE0cCsebA90UT7NG72hPeLwBjKcIoUEc9rFGda6LStjfQcpaehxccF2rsawEkyMGepy0w0bjRy2uZChaEQhd3wANQ0g5GvBFwyDcDWMDtV1cmXzgx1RUOAS8cdKAUD2/e0090LCshtu4aIU74bxJl4JlHM7ZDMUFmxdUFuc8ALMeMsH01ahYwPCke4z5jQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIqvf+SLcFrfMSsrG9lrC91rdlubElElCUcNyHEyzec=;
 b=bzbkwrYtRX2NOq0cx5/FcmJdrwBUfrq8yK23G8JEF1/ZEJLeuPGDn0q3+9/V3ozRaRTk9P0FIXl5yf3DBu7wEEeHm6ucevllr1mFz3m4AIPMKLJenq6RrVdOaHXwmMK/OaM8cwHtPz0pG8sM/5TujxwNxEY8Wwi2VBfuDFMK0SY=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Thu, 14 Jan
 2021 21:45:15 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 21:45:15 +0000
Cc:     brijesh.singh@amd.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 13/14] KVM: SVM: Remove an unnecessary prototype
 declaration of sev_flush_asids()
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-14-seanjc@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <c62ea940-5eac-0e8d-dd7f-1085e85bfcc9@amd.com>
Date:   Thu, 14 Jan 2021 15:45:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210114003708.3798992-14-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN6PR01CA0002.prod.exchangelabs.com (2603:10b6:805:b6::15)
 To SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN6PR01CA0002.prod.exchangelabs.com (2603:10b6:805:b6::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Thu, 14 Jan 2021 21:45:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 21f0f4f1-6437-4234-c4fa-08d8b8d5adc8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4432:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB443217E9D3A884BFD694866FE5A80@SA0PR12MB4432.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EY4RhZNIPxYrgA3LSEtb+B6CcvB30Exaf6HRDAUoJEQLvl8wuL2ZNKl3+UEvPpOrItpUjEgKelLuZj9PIOHif9SmaXDzCiB4c9nbEnZwA03Zn+GJBQ2eVdL5U71pgtCN0ZQ922tYt1I28102SQRAYiayCaaXxFCaE/XmvjB997KYeBxCdNTN/P9f3FBs3QU5hVJptqkroKfKKmBxN2ZkCQO2UNX6DFywhFD1WkXPBjZMAQ6Jjtcg1lyXylmhjpxMAGJoqVZi0SFE91/aDKedX0LxBIdk+zJTIOYCvO9gO8OrgmWeu8HAHxfFEuF+5FHh8KgFXmkH8NL2DLffWSoci7qTLSLJPykloZCmmCp8khVLdLfa6JAQ24TqmWZstqZJN2YVaACn3OKCcI3Xa4iUtCJMwmMnOTAiGuzr3Jjo2ehK5EihygQCWad+v5CSuORs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(4744005)(31686004)(2906002)(86362001)(4326008)(16526019)(52116002)(110136005)(66476007)(478600001)(6506007)(31696002)(53546011)(5660300002)(316002)(6486002)(26005)(6512007)(83380400001)(44832011)(8936002)(7416002)(66556008)(186003)(8676002)(66946007)(54906003)(2616005)(956004)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UU1DRzIzRGFuREwzN2MvUnRJMWVRdnFjVFNKWEx5K1pwcDlNMDJsd2lKdGlp?=
 =?utf-8?B?MnZQdzFGNXhkdDhod1VKTEt1eXprdWwrbmFjT3o1T3EySTRKSGY1SmlKVWYy?=
 =?utf-8?B?SjV6UkJSYTF0YThHZVByNXpJR3V3Y0FidjVyM1VGTlMzWnRUbHB1UG9pZVlu?=
 =?utf-8?B?QllWcUZTYzJUSzdNdDRNSzNtQ0dUcUxzd3NTd3dYQ1I3SFNwMU9YcUM5aDBN?=
 =?utf-8?B?U3ptUjM4QkNPMURReW9YdFFFaGhMK2FHb2RCYkFqMmZMUFVVYktlbzBkUVky?=
 =?utf-8?B?dEpadVIrWXJNd1hOZGxGMHRFRWhvTHlZdDVHOFBTdnZISHgvYWJ4a0JCM3NJ?=
 =?utf-8?B?KyszcTBrbWp1eXB3QllvTnNPS2d3bXlYZmRlMFRvdDdQcThUQ0RxNW5Sb0tR?=
 =?utf-8?B?dnFwN1hqU3F0dXZFTDQ2RnVIVlFCaU9tL0k4U2RBMG5sY3BaM0sxbDZiamph?=
 =?utf-8?B?cjdKM0tVNXFzVE9ycXcvN29NMkgwTmZScVlMcm1PY3p1VmNzZEhqNGgzWXpX?=
 =?utf-8?B?STBhTTNoRTBRbGhtVGU4TTdGRThYS2lvNHlwMjcxSG0rVUFjWTFudFhCRW9W?=
 =?utf-8?B?TFVwZlhCTXBZNlI0TVVvUlcybCs5d1J5Rkl6NldLSUxlUHRhSDJuRmpQb0dt?=
 =?utf-8?B?clNmV200T1ZyeSsrVkt5QkxBRUFrRXdyQUdJYVl6cVF3WEd5NS9VRnBHZUdW?=
 =?utf-8?B?TVZmcTROVFJBdU5nRmxWamFrVm54OHQvR1laSU91djJETzBLUDdvYmI3dVdz?=
 =?utf-8?B?TWs3Y09vZ1pZbGlzV3dZODVPTjlweS91R0E1anNDTHMydlZWZTJweENWTW83?=
 =?utf-8?B?WmR5aTlZbFpBL1Zkd3VLUE56dkQyT3I3clFOMkVhaUtBcDlBN1ZOTHB6TzhC?=
 =?utf-8?B?UFRXd2Q1ZU5CeUUyZGgrSnpVMEhQdjNRblh2cjZzMlNjSjVHUXJwZ1FZeDBz?=
 =?utf-8?B?ZzMzd2JiNnVlb01sbGd0elh6Q2c2ajVaRjhDWUxuenVKQVYvcWZ6cXpVMEl1?=
 =?utf-8?B?TU1hUmFYRisycXZTcUx3NzNiMTgrbVFmb2ZrVWtpc2Rma2g4c294bGFZK0tQ?=
 =?utf-8?B?UEFVQU9IMGNheUo4eEdIa2U3Ukp0dVBnVmtwRUtUa1RrZFpTNW85OC9acXNu?=
 =?utf-8?B?LzJpd0hqTXB4L0w0ZEhaL2M0dHhtdFJGNVdGcnd2QWxHKzRxWVZwQko5SDd2?=
 =?utf-8?B?Q1RCampkZyt2T3J5clZWM1FxcUM2WTFGcXZ5L1VidWcvcWdodVd6ZWtUL3gv?=
 =?utf-8?B?dWNZai9IdDlqRk1YTFY5VTdldnBMTUNRRWtuanVKTnc1anVja1ljZzRob2tl?=
 =?utf-8?Q?azPh07lqgxu+BxntVJedvy738OakpSK9lC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 21:45:15.4496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 21f0f4f1-6437-4234-c4fa-08d8b8d5adc8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bqCek3rPxw3C+wPxmjM+sI0dd9wBtJT/3WTx5pKyLYLvrzycJQ7hwKYbfHALWmBlCoT6Yvs0BMiY9axPEZxTQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432
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
> ---
>  arch/x86/kvm/svm/sev.c | 1 -
>  1 file changed, 1 deletion(-)


Thanks

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>


> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7e14514dd083..23a4bead4a82 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -41,7 +41,6 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
>  #endif /* CONFIG_KVM_AMD_SEV */
>  
>  static u8 sev_enc_bit;
> -static int sev_flush_asids(void);
>  static DECLARE_RWSEM(sev_deactivate_lock);
>  static DEFINE_MUTEX(sev_bitmap_lock);
>  unsigned int max_sev_asid;
