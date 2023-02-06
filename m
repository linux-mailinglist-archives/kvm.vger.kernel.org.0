Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489E368B4A9
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 04:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjBFDwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Feb 2023 22:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjBFDwg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Feb 2023 22:52:36 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5AE17CE8;
        Sun,  5 Feb 2023 19:52:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mazkdNVQiBu3Y7tSL5vJC5by0TgJmn1mDz8ejOEst05VivkfkmgTUXvLZRzBxCteuK3b7J3HPTLVyMGmp8vxMzN7TVfIlkRggNmxrq5oVEgyNjZ+6m6grew5Z3cq5C1JZcJq0Eo4q26GaxTTI1KsvA8+Pg0qcx2VgBZN0VDN8sI8FU76Vx9Xp5BingTYJ8oYAxqya31r63RVg+zAt2EuXsmF78lLxg+UGB8+ziBdhbgJquAgwzRDrS7427hjUbU2P5xHWymL0QWkHopU5MuTxyTTOEZm6qg2dG952zg+x3EIW0FyYnkxHbZ/QMHHMM+QucAnr/w08DFEo7vol4eh8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V0ZdHvFGAF5ZsnBrL+WYn0OvyL4oE63oY+2y2oW54jk=;
 b=COSppa0vIl6eVTgPgGupRz7j3Kljik/gK8fM5yhoUhLfD4+re6zaHygN4uQVt0X6qvRJZVz4wLHVx5gpCeG9JyDFGnMmO1qHIXGk+D4yqWvhiAxkDozXn/gtuxhtXnB43SZ3JJBh/GdJtz60u6SXcU5f/3BmdlPUf+JSxKrgvZ9cNJu6xqndFKKjf9XTf9GTMGdbEHbdd19X/j3Zuvqh76UFV1/jJzlT6wQBxBGNiT8mudHzAV7gtwrp1rpHA5GbwpkGsLgUMoukS88zs5JIWbwY8N7SDHONsUWzTmjbO2Lh2eysSyt5CLsl8nJsPjyImtQKJsUYrZ2H0Gaz9VXELQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V0ZdHvFGAF5ZsnBrL+WYn0OvyL4oE63oY+2y2oW54jk=;
 b=Y7N6mKdhTMezuksGgPsyzM5vmCgWlnAm3OkuXWbEqhWI6sUJk33O8EIUnLnObKiCCV29LWB0D1W9hdj7fRaNfTFUNnnCeRjLWmk6j+x5tPHgWm4nivkwu2rdUSo+9fw4DnO65vAI+0bpxbcSo77k4aacTsfh179gUsp+U5xppJ0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 PH8PR12MB7028.namprd12.prod.outlook.com (2603:10b6:510:1bf::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 03:52:33 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c4fa:4cd7:4538:e54b]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c4fa:4cd7:4538:e54b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 03:52:32 +0000
Message-ID: <d5eeb8c0-3083-89f4-415c-f30a2c4cde39@amd.com>
Date:   Mon, 6 Feb 2023 10:52:22 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] KVM: SVM: Modify AVIC GATag to support max number of 512
 vCPUs
Content-Language: en-US
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, alejandro.j.jimenez@oracle.com,
        mlevitsk@redhat.com, pbonzini@redhat.com, jon.grimm@amd.com,
        vasant.hegde@amd.com, kishon.vijayabraham@amd.com
References: <20230117100821.10116-1-suravee.suthikulpanit@amd.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20230117100821.10116-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0011.apcprd04.prod.outlook.com
 (2603:1096:4:197::10) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|PH8PR12MB7028:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f12def6-1332-4fcd-2755-08db07f5931d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pWHabXZS8KsTcVzTn7BWZqK6SK2R7qiJXp0RM5xE0GHwk+A2CX+6TiJsVIYQhVxAZOMTBERPMFPtD9tCUlFzN/s/o4uDarTLYwXLwGpUH23kDS3Xy/L/0FxjJwbagsQU9JCTff539EojbrIMNvCAk3GpBEOTrp/2ZCRQpWDA8Xcp3KsbmSFZxk/PNkYF+OFmeiraO4Ey21E+zNNYgW+ZXNCZ+64KPj1ddF8MurL6WK5xjsZkbLreHnStvOwc+dujGzd+njG81tVP4iXzis0BSCQ0EvVlGZx+FAt1yrz8YWhe6AVZU6hM6PQMx/oE+XyfLC822l+wvEeKw0wEbJtuHZNLb1sB+VeRIEUpBbWBotrn/6xkeC9EknTdP5LysYML9oIFUeQrXQJHhFCdlrSQRooXasFkjjXiUUgbvJwqjDz7aTvYa4KZnGpJ8Cj+oHP5JazPcrj5tIDEbyn4V2XLfomqNNvCJNqxgf4UJydm/rs/w/pPDTpeIdjGwRewpHGk3yj+L07khqgXFyfRf/2yt8ZQ7QUujAXxiNE6GrRbWjortLLrL7EX8U7T0eGGoctvPkMx0C/C5MM6WN2cUND7tH4O4zx5MdzWtaOF1VdGsIeTlANejv2Zi2yKYkxjAUsD1elky7FE6ZSexoD2Oqe+nPnW43IZJS7Q2UC++v7YV3seusJXxdUv39Jivn+/2Q5xSvL6hx9bVPPkg9rd3jHVNvorZ+9MRFIaUWwaa7riMY4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199018)(6512007)(36756003)(6506007)(186003)(6666004)(53546011)(26005)(38100700002)(316002)(8936002)(41300700001)(5660300002)(2906002)(2616005)(66556008)(4326008)(83380400001)(66476007)(66946007)(31696002)(8676002)(86362001)(6486002)(478600001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGN5aG1LVm9BakN5WkZFek8vRXBEc09VQWhUQ3Fib3cvaXNxdmQyM096QkFz?=
 =?utf-8?B?S0NwdDl6VTRMcXVFcmxxeEk4WmxoKzN0MXVrbEtiTnhwQXFmUUk5SDRHcmxZ?=
 =?utf-8?B?M2NVQklvMG1Nc3RDQitjM0JUZDF1endlMG9DeVI3QWhGVlFNQ01Fejk4YUdY?=
 =?utf-8?B?bWY2REVHbE1odnN5dlhNRk5Yanp1QXVSblRQY05BN3AwSnM2SG1Rd2EyQVMz?=
 =?utf-8?B?OU51ZnNzamxIa2dYY1J3NWNxVVM1cjk5U2hVcFA2T3VUUUxCYTFFYm5uRGFz?=
 =?utf-8?B?Nm9qYVZPY3VWWnBOMFgvUi9MRW4xQ3UwSkJZb1lpelV4VWhwQUFhRnZvUjNF?=
 =?utf-8?B?SWcwdjFLMUZBY3g3K3VqT3l6QjlRdWZLNkI1TDM2VDk3bTFBa1l5QmxNYkE2?=
 =?utf-8?B?V09FbmdxZk9PNFRqWC9FNVZ6ZkdpM1ZXc2loQ09JTEFFejFFam5BNy9xdUt4?=
 =?utf-8?B?MzJtMks4OFNpUlFmR1hlQUhtR2IwbCt0VURCc09ra0k0N2hodTByb01DOFB4?=
 =?utf-8?B?VXlicERMUmF2OU9sRVg0bnk2VWN5ejNscHZNdHBzUzBWZTFIZ2dWeFFGVFZj?=
 =?utf-8?B?dVNvM1NBQzFiWkNnYSsxcy8vQlBxaHlnVERWTzZ4eUgwZ0VOSUEvVWpiMFFS?=
 =?utf-8?B?Y1FQakozZ0ZKT3lhSGlmelJYamVIaFZqQkRHRitOS0UyM0t4OVJsNDAzTmlv?=
 =?utf-8?B?VEI2Q1BVd0pvTW9UZVR0Zk1XL0R0czZReHZqcWo3RGNIMHBabkVBczNMS2ty?=
 =?utf-8?B?SXZBZm9LTGJoUjRtNlV2V3liNWF1NEk5RW9PaFJHZDdmdkNNM1pQUkdKeUxY?=
 =?utf-8?B?QkJLOHhUaVk2SnJ2TXZGdlFJNVN2NXJGRUtXK25PdEZQMmo5Mjc3Qzgzc2lB?=
 =?utf-8?B?L3daS3h6OEZVUENPT0NCK3BPVWs0bytjc3ZYV3RyVGVad0JoZGZJdzdWalhS?=
 =?utf-8?B?WmpWSThNVFBQeGVFTWhWZ1l0WmQrZEJOL2syTG50dFNIeXd1VVZXclpxYmRn?=
 =?utf-8?B?UzFOK0lUMEFFeVFNODd2eVlpNXNNSVIwN3hJMFlENC8rM01RQ3Q0MTJnNkFH?=
 =?utf-8?B?VklIWFErckluT2hIcWlIMWUxNklKUDdWQ0pUZTNEeGZad1pRUG5XK055Qlha?=
 =?utf-8?B?VEFJU05aUmtnb0prdk9NaFBDVmZkL2Juc1ZLTGwzaWtDT09oZ2c1MDZyZk84?=
 =?utf-8?B?anBNdnBYNFNFVzNlbXo4KytqeXcyMW1nSld5SERZMzJsbExjS3pBQlhRTGVm?=
 =?utf-8?B?UEYyUStnRXQrZld3VmZaekpoVk8vT2VXRVRsc1lpQVBCK1VncHJLVGVyTlR3?=
 =?utf-8?B?ZHJuK0dROGlpdWtMc0pWSXBZc3lkeFpvMGRmU1htTldmVlVuVzl4czFHOUp2?=
 =?utf-8?B?MFNwWHZkR3EyQXBTcEZPdkNBdFhJYm9QTzdOR1pvRzdHL0hFNCtFbDg4eUgz?=
 =?utf-8?B?Qm1qanZyU21WTlRxd3ZtRTdVSTJ0akR1VEJwQ082Mk5ka2tabGdUNVY3aFF4?=
 =?utf-8?B?VGd3cGFsYXRuSm1nMTNheHMybUpEYTFXOHUycVlLV3orcFlkLzlmSHpnWCtG?=
 =?utf-8?B?SlkrMUVSWktsKzVzRTErckpRNkJPZFY5SWt0OW9hL3duYmhNVCtwc0pxQUpk?=
 =?utf-8?B?SHA2WVQ2MmpENGRtMWl5emx2NytYWkRYK3NIZWRCSDc2T0ZyZUJKeEJ1WWZU?=
 =?utf-8?B?Y0daajU0RXdva0ZIVkl4NURob0ZYSitVWU5DbHF0ZUliKy91UjA0TW9mWVpz?=
 =?utf-8?B?QzJVNGxvKzJzWHhOb1ZqeThXdzRhNi9yeUhTb25BdmZhUVhKOERUUDd5RW1j?=
 =?utf-8?B?QW1WWUQxaVhoOGM1MG1zek44Q200TDZtZzVyMXFFSjJKWldqMGZKV3pCNTlt?=
 =?utf-8?B?T2Yzc1RoVGJUak9abFlaRDIxWGhjZCttNk1xaW9QcTFwem5xSnlDWlJaNk1G?=
 =?utf-8?B?aThvaWZWL0hmTXZKSlgyWGcyMGpOUnJwM3BzZHlQM3RYbHE4ZEFhU3h4Q3A1?=
 =?utf-8?B?NjFpcHRhallCdmxUcDZiQnlNU3doMlhWK09ydlV2dUluYVFRY1QvbE95N3Rx?=
 =?utf-8?B?V2RjQnlQNzhxNlJBTkVIM3E0NzhqVjF1MHRpTWw1TWd3aTFqejk3NXR3UXE2?=
 =?utf-8?Q?CqzU2zWX1jwVGVeiXmpKiloMx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f12def6-1332-4fcd-2755-08db07f5931d
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 03:52:32.5704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SpGAFWJKk8wOEM/APksmA8ZvZO/BTWfH1ExhqndBkiiUdJmT6GxV4KjQptdhE/BaQBUHndFfuwshgSt0RRb5jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7028
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean / Paolo,

Do you have any concerns or questions regarding this patch?

Thanks,
Suravee

On 1/17/2023 5:08 PM, Suravee Suthikulpanit wrote:
> AVIC GATag is managed by the SVM driver, and is used by the IOMMU driver
> to program the AMD IOMMU IRTE to provide reference back to SVM in case
> the IOMMU cannot inject interrupt to the non-running vCPU. In such case,
> the IOMMU hardware notify the IOMMU driver by creating GALog entry with
> the corresponded GATag. The IOMMU driver processes the GALog entry and
> notifies SVM to schedule in the target vCPU.
> 
> Currently, SVM uses 8-bit vCPU ID and 24-bit VM ID to encode 32-bit GATag.
> Since x2AVIC supports upto 512 vCPUs, it requires to use at least 9-bit
> vCPU ID.
> 
> Therefore, modify the GATag enconding to use the number of bits required
> to support the maximum vCPUs.
> 
> Reported-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   arch/x86/include/asm/svm.h | 3 ++-
>   arch/x86/kvm/svm/avic.c    | 9 ++++-----
>   2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 0361626841bc..6738faf155e4 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -256,7 +256,8 @@ enum avic_ipi_failure_cause {
>   	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
>   };
>   
> -#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(9, 0)
> +#define AVIC_PHYSICAL_MAX_INDEX_BITS	9
> +#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(AVIC_PHYSICAL_MAX_INDEX_BITS, 0)
>   
>   /*
>    * For AVIC, the max index allowed for physical APIC ID
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index dd0e41d454a7..b1f8f51bbbd9 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -28,16 +28,15 @@
>   #include "svm.h"
>   
>   /* AVIC GATAG is encoded using VM and VCPU IDs */
> -#define AVIC_VCPU_ID_BITS		8
> -#define AVIC_VCPU_ID_MASK		((1 << AVIC_VCPU_ID_BITS) - 1)
> +#define AVIC_VCPU_ID_MASK		((1 << AVIC_PHYSICAL_MAX_INDEX_BITS) - 1)
>   
> -#define AVIC_VM_ID_BITS			24
> +#define AVIC_VM_ID_BITS			(32 - AVIC_PHYSICAL_MAX_INDEX_BITS)
>   #define AVIC_VM_ID_NR			(1 << AVIC_VM_ID_BITS)
>   #define AVIC_VM_ID_MASK			((1 << AVIC_VM_ID_BITS) - 1)
>   
> -#define AVIC_GATAG(x, y)		(((x & AVIC_VM_ID_MASK) << AVIC_VCPU_ID_BITS) | \
> +#define AVIC_GATAG(x, y)		(((x & AVIC_VM_ID_MASK) << AVIC_PHYSICAL_MAX_INDEX_BITS) | \
>   						(y & AVIC_VCPU_ID_MASK))
> -#define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
> +#define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_PHYSICAL_MAX_INDEX_BITS) & AVIC_VM_ID_MASK)
>   #define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
>   
>   static bool force_avic;
