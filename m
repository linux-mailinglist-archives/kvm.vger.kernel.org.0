Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCBFF4A6BBD
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 07:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244818AbiBBGwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 01:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244729AbiBBGwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 01:52:37 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::60d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6874C061768;
        Tue,  1 Feb 2022 22:26:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7ht65lPVhMF7ujFgGN5xtwxDuCPlXcLpEsUuqpkMnWwd6VcVn259ts8gMaKC7h7oD82DwIxLwWnYpvt2bZWIs3pH2DTZ1MOAUyQcSAiO9ZOsacIOltNpgWZiabCaBd4PU85vGwDz+tfbO7Uuz5A7y8M1fjxvOVAqFB9rc+9A4+0/y1C8fSY3jPv6Fj44VPUyeJhTy+LtKjurzEaciIbh41fcB3K0NFbJPATosr0/v+X3hI49iPRtdnkqIUO9O509u+CfOHM3DSLgRgkGIqAK7Klo0wCSGYzswyVCdhAFbAA9sRmaYn26G/nND7KYo8PiWZPzfe+cGY2zPDHUzFtmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rW9s+wRmZowy98tNZI0OPLCBhLOr+wAj04QBurTzQOU=;
 b=GirAW7p/IukjwFz5m+3RVk1+YR7wvLYoomkwCjIZWbScmjPBIEHt1i+kjpLIJwkHRJlMUzGx9Tt49OA4miJNPViLWfSQEL4bER68uU1GfH/wZ2UGUZDKyqd9M3Z80N6sWvltBiOIiJ4pmFaxi3O1K1Hy67nZQl4km3Y6mZmWoGT/cUg0l8izQoSuW8WxfflbqihA+VFCkc04C+PwNCDXmbv5KpdnHWAN0yPSHy9mJ1GEIWHiy1OoFEV5F3EJiDav7ygDA2MajfZ5a10Sm9qfOM7fqoQIu7acCTr23FaF4JBuB23elRFpoC/b38otap8uE+NbcmKQSWlNRVPQYV9g3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rW9s+wRmZowy98tNZI0OPLCBhLOr+wAj04QBurTzQOU=;
 b=qyiuANVzH4BlAc3jNjWgaxNWsTQ6clAmCb7W09JwOUTYdYfMxZMyJ3G/e1ZHBX1SNBCzF2uLCv3KlqMZ8oazlKSarrTd6JHNvEzKbtjMY01n8y0WfMb63xwEDjICDJ8UAoF0UlRi9IKdC+GhNlpWgptu2fNI9j/wLj9oob4ua5k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM6PR12MB3595.namprd12.prod.outlook.com (2603:10b6:5:118::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.19; Wed, 2 Feb 2022 06:26:22 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::389b:4009:8efc:8643]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::389b:4009:8efc:8643%8]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 06:26:21 +0000
Message-ID: <b9fc1081-98b8-64e8-b4a6-fdd5809c1255@amd.com>
Date:   Wed, 2 Feb 2022 13:26:08 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v4 1/3] KVM: SVM: Only call vcpu_(un)blocking when AVIC is
 enabled.
Content-Language: en-US
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, mlevitsk@redhat.com, pbonzini@redhat.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, peterz@infradead.org, hpa@zytor.com,
        jon.grimm@amd.com
References: <20220202041112.273017-1-suravee.suthikulpanit@amd.com>
 <20220202041112.273017-2-suravee.suthikulpanit@amd.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20220202041112.273017-2-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:4:197::18) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb98694d-c550-408d-1607-08d9e614edf8
X-MS-TrafficTypeDiagnostic: DM6PR12MB3595:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB35952D61B8DEB06B45102647F3279@DM6PR12MB3595.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2V8B8q0zETeXWO424PLws6uAz0+52JbzhDytKhMGW897+GcYlZRCc5Vq8Yd+GabN8xt+jtdVaHBu+SJpnVTt438SO/WkIRI5e6D8NH7uvUYQsZDYLLXj1ot8ITtabFxjV8Uo31V+6PEHXFzPN9A6I+6dJynoQXVzQMwhl92foKL7fZU91Cpz5Khqgzn+acbh1dYS6HKtvnmakMMnaT7tXZBoNYPsKduywo9hCCrzlA3MimnffP9VdJar2yFTc/FKUZZF+/qgaGI6HEyjbq8/57E/JsAOspsr6E3MXzZmLeWEwnEQqSMNWlzRBJW/kPXFDUN2ETOHCXINIp5ysXa2qyJtBY5xnZz8h3c7UmeKZjPjBlBbVXVxAJimgETwYcQw20RD+0G8Cdkpf7CxROkYY4fW6TIdWW1mjktCW9xXUvqRafrfCS93l+Iu3AGJaJeUrMjjSqMFrHDKjVREVV1D8XKkaNKu3TDzkVt6mcimMtmS3Hbqko6W5nRN3grdLGEO4c9BPD6gLHAYeJLv2MPxwA1FDt0DTJ67mc5GST44/2/k5xDXxhNWPiXDRnPrgkGpScXNSgparR6tPDZPXtwgD+Jhtt2iaeH+k7AbI8kOOH29G2RvewePXQKPK81HaHmuG2Pq9em9RDAWoYBOe0VaPE4IHGDm3L5nQyqNy36j3Xdb0ojepOzAmYAAtLRrycPI/1RKekZ1gSag8/9CcIn5fQ5kwJihg4sYhBAQzKw8iIfkpSirXWf81MZEQ7j+rZd2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(66946007)(2906002)(7416002)(38100700002)(5660300002)(66476007)(6506007)(6512007)(6666004)(26005)(8936002)(316002)(31696002)(8676002)(4326008)(86362001)(31686004)(508600001)(6486002)(83380400001)(2616005)(186003)(53546011)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SW04NXkzS01ZazVVZ1dxRm9NNnh5bHlyU0FBNXZlRW5kTWhNQlVTeE9Zb1Vp?=
 =?utf-8?B?VkFudFVsNFBDd1l1SkFmaTFLc2kvTnl2eXRGMWs1cGhRRVRBaEFXYzVHSndL?=
 =?utf-8?B?b3Zzc1o1SytmeHZ4M3cvc2VWZnNCU0VBSURTc3psT01CbDhHcG9QQmU5ekVI?=
 =?utf-8?B?OGNHMm5yTXY1YU5XV3A3WEZDUVkwY0dZRzUraEJEaTlUOUVNRjY3QVorNjEw?=
 =?utf-8?B?MXpuTlo2dG5SN2FvV3pMazRwZWdTUDZKWXJFR3plblNQeUdWNXdRSFE1M0NR?=
 =?utf-8?B?Q1M2aWk5MDI5UWtPb2txMENiK1dsUnVYRXRmZGNuSkxIZGtmeEJ5bmZacEpy?=
 =?utf-8?B?QTFua2VDbzlVWWduS0JaMmZOZmIvRnh4VDRGVW9zMHIzRHF3WS9IaXhOd1Y5?=
 =?utf-8?B?QldJN1BiTmtFd1R5OWdHbk5EOUlwZjFYLzFEUW43WTNrSDdvNGM0RXVjY3FW?=
 =?utf-8?B?MCttM0ZoUDl1SDh6QlN1WlY0ZW9qenplV2VVVnpUWHhRdmJ6SndzaGxLK0NF?=
 =?utf-8?B?Y0toSjd6QWZqZnJOUytyeUc0dXFYNkxHN2JYMERFSGQ4dFptLzRDZ0J3cmRM?=
 =?utf-8?B?Q1FONFdWUCtjaFA2T2tGZEdwRmtEZmVpTUdIR0xMZ3JhOWZkVDhpa0JFWVlI?=
 =?utf-8?B?Z0FxN29xREszUFZxNzcyRmM3eVM5ZElyS2JFTHJtWHZIdkw2cFZNcTk3T3hY?=
 =?utf-8?B?ZHd5TmdkRlYyTTFTR2pKVTMzVThjeTNWQ0NiQnp3OEt2N1VvRzQxcmhVcjhJ?=
 =?utf-8?B?OEthODNSbFd4MFZMbjJac1BjaVVzU3pjelFZRGRDTjYrZmRBY0NTajYxcTh3?=
 =?utf-8?B?QjN1VzZ0NU40cC9Lb3oyN0RPc1puN3p3d3k4ZzN4cDBxcUxUdXVUR09yYVRR?=
 =?utf-8?B?dFlveFMzYjB4QTUzTTBBUFhTUjVLeTl2M2VRMU4wTXdYSGhXWVFHZnYzKzhG?=
 =?utf-8?B?TDFGQlpRWC9KRmpKSUNJMStVNWkwbW9ENU1Ka2phZFA1MkY4L3NkeHlyZGVa?=
 =?utf-8?B?R25lUUFQeUNRTHNHblh5b2Z5c0xDY1BNdWlhNmV1MGluMUI0SDFTVUJtNERV?=
 =?utf-8?B?Y1cyZGZCQUNuZUJtSHM3cDREM0NXcEkxWS9JNDR3UC95K2owZlcxSVkvSFFk?=
 =?utf-8?B?NjhXUFBYWkZqUWQzZ1lZWklRaS8xRllDam1pMjJmYkR1OWpkU1pjRkpBTVZN?=
 =?utf-8?B?NVF1MFVrREdaWlZzSWpYM3JKdUF5UFcvR1l4TFhmVmwxNTJzVjV5WUEvdU1U?=
 =?utf-8?B?RXZoNjNWdnV4T25SanNBOHJyeHBxMU0ySTRIb0Z1aHY5a3NFL3pkMWNOYS9U?=
 =?utf-8?B?UDgwSkZWU2R5TDVlNWpWMXp2NGJFOXhEekg2Qkh6T1N6YkpPZ080M0Vyc3BU?=
 =?utf-8?B?RmxqSGV4NFppUjh1U1lmMllHeGVBdXl4NWtSZmd5Y3lOa3ZGZUlLdGpNWW9o?=
 =?utf-8?B?Ry81Q29KVHJEYzZJQTdhb3FtM0RKS21pbUNjNWlJN25wM3JaUlY4SFkwcTNI?=
 =?utf-8?B?L3J5TTVPMFNoK1dmenNuNDd1OC9YT2JuNkVUM3hHblVmZVJvMngwT3c3SUo3?=
 =?utf-8?B?VFZxd1JzbFJadXgxZytsRTFWMGJmMzNvQlRtc0JMajhYcVdlcXlzdUtXNWpv?=
 =?utf-8?B?S0Q3NjJhczhZUkZQMjdWMmZZbVp1M2RMN09JV0l6Q21VenVOdWJMUHhjY1pQ?=
 =?utf-8?B?TzNwTHhTMjNVd2kzcXJzSTlkUHpNZ1Z2TGpWZkN3Smg2aFoybkg0VU5HeS9V?=
 =?utf-8?B?UFBmZjYrN3hNM3BmWFU0d0ZqU3drVVhwQUtGUVUrNElnUSsrVkxBUFF2WXR2?=
 =?utf-8?B?ejJFS2lCSVNLU1pRTlFoNXdsRlRVbG5xbE04TTdDZ2QzQ1lUUW91ZmV2d0xz?=
 =?utf-8?B?V2VSeU5IVUJXeWJyRHZacHIvLzZKeVNySEduQVZCM2lqRUpEdm0xZG9uNU00?=
 =?utf-8?B?YllxVTByODVMbUpGYks1eFVBU2lpZjZ5SnJ1Vk9Sc2RFRjNlVWsyT0o5NDZM?=
 =?utf-8?B?aEt1a3FhZ0pqVjhhRDFacXozYmg2cGp0ZmNCUjJVZC8zcVJoRnJnNGd0aktR?=
 =?utf-8?B?aUVKTVBTaWhiNnorYkdDamFONXpPTkI1ZlM5T3c2dlpaQ2t1YUtYUlZ1dGNu?=
 =?utf-8?B?R3JuamhITy9Sc2liREFNVDBvT0pJS1FIa0NYOWdmV1pyVXZOWkVMUlp5ODRC?=
 =?utf-8?Q?g7fZtGyktv8nrK+jyfRuiVA=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb98694d-c550-408d-1607-08d9e614edf8
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 06:26:21.8953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9vQtn33QHk5cRftKyUVum5PoC0Iw644q0NZtaCjSJx6RhePdWvNSLUDX6SW7uLgkCUv4TYEfkKKEnc7XpafrFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3595
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/2/2022 11:11 AM, Suravee Suthikulpanit wrote:
> The kvm_x86_ops.vcpu_(un)blocking are needed by AVIC only.
> Therefore, set the ops only when AVIC is enabled.
> 
> Also, refactor AVIC hardware setup logic into helper function
> To prepare for upcoming AVIC changes.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   arch/x86/kvm/svm/avic.c | 17 +++++++++++++++--
>   arch/x86/kvm/svm/svm.c  | 10 ++--------
>   arch/x86/kvm/svm/svm.h  |  3 +--
>   3 files changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 90364d02f22a..f5c6cab42d74 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -1027,7 +1027,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
>   	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
>   }
>   
> -void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
> +static void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
>   {
>   	if (!kvm_vcpu_apicv_active(vcpu))
>   		return;
> @@ -1052,7 +1052,7 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
>   	preempt_enable();
>   }
>   
> -void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
> +static void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
>   {
>   	int cpu;
>   
> @@ -1066,3 +1066,16 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
>   
>   	put_cpu();
>   }
> +
> +bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
> +{
> +	if (!npt_enabled || !boot_cpu_has(X86_FEATURE_AVIC))
> +		return false;
> +
> +	x86_ops->vcpu_blocking = avic_vcpu_blocking,
> +	x86_ops->vcpu_unblocking = avic_vcpu_unblocking,

Sorry for confusion, I made a mistake during patch re basing. I'll send out V5.

Suravee
