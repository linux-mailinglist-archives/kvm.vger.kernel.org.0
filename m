Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6892F4E67
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 16:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbhAMPVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 10:21:09 -0500
Received: from mail-dm6nam12on2088.outbound.protection.outlook.com ([40.107.243.88]:8352
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725747AbhAMPVI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 10:21:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUsO8ADi/ir2UoNOPrjNS7yLS99n1U7r4HUEjpIBu4M/wN/ZtB5bbgjfgaq1029Jwox836zWDMiuSXqcX1DOSYSj/U7wJaD6tPolXw2FC15UOj1REtwGI/ejgVBiYmNUm3rgJKbWmUf9xM+GiC1yWXwWpJ4LCoKw5biBkgnCaXWCYhspMXPbjA46lHGDh489J7oFabKmayp314myBFxIcfD2btIiQOzmC5FEeHawD29UDHHZiX4jn/UGfkKLcopj08ISqpOoTXsWRcN86APdwQRxac1kvO2Zv7k+XrclI+oLfMxvgpfkAy4lcV4Q5LArAFiQtKEVGmLTJSAKkCRfxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMoxrL5C0kqIz5rsM4/sKogAsnCuRprf9Jz5pbnF5Xo=;
 b=QLTMF5VAFjNvChlyVqDYaOxH480W17n3U9fWqBKKGRQSw+AeaVLb0OEisz2UezTloHeNsuB/j7ed1Pt+01RT6rNa+NCgItQ1bsPfGwYX9sJpj4hbptVhbOcdo9WyF0KEcLB5RCCJ6s+2GvUkK0kfrXFUEQAuVQJ7MTmKwGZ6TVMhokMIJbEKhEI49xsVqHc+HrgR7HeuWOp0G7KyrfgMX6nhnnriJvJ4CIFNM2Q4fRgHG6bVmHbVFdmIf4BMPVpYTRMVh2KHGsaMBJV9nC8CvthxbUYlsfDWErUj02o5/pqQWBJoLjxXVjAz69O053WPCuEHGwtEVvoiBm6sMPKP4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMoxrL5C0kqIz5rsM4/sKogAsnCuRprf9Jz5pbnF5Xo=;
 b=QAN8o2ejbAdq309aiAidXAVP1qfG2BIoL8RSNH+wYlSej3JpoUURIe3+AdZH6pIJ+iKVx1EVCyumXE+zYTQQh7dP59jJiw7nqsXvaMiK7y5BbLfxBEXSm4VRKyhtAr54KnrREU06R9LC9MSGUXavz+RPfzPa2A1wrTwtjcgaa8Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2510.namprd12.prod.outlook.com (2603:10b6:802:28::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 13 Jan
 2021 15:20:10 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3742.012; Wed, 13 Jan 2021
 15:20:10 +0000
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
To:     Vipin Sharma <vipinsh@google.com>, thomas.lendacky@amd.com,
        jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com,
        seanjc@google.com, tj@kernel.org, lizefan@huawei.com,
        hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        corbet@lwn.net
Cc:     joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <18edfd09-37b0-d185-fb0e-6f502ae4951d@amd.com>
Date:   Wed, 13 Jan 2021 09:19:56 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
In-Reply-To: <20210108012846.4134815-2-vipinsh@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0201CA0020.namprd02.prod.outlook.com
 (2603:10b6:803:2b::30) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.0.0.4] (70.112.153.56) by SN4PR0201CA0020.namprd02.prod.outlook.com (2603:10b6:803:2b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Wed, 13 Jan 2021 15:20:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 05f90986-7909-44e2-bed6-08d8b7d6b77e
X-MS-TrafficTypeDiagnostic: SN1PR12MB2510:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25102C80EDE4C25ED5C74D0DE5A90@SN1PR12MB2510.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:580;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PVn0otyBX/tgGgn5shd2Zy2B20RBRriNOOzkPouuXCBVeDFHBwZm8QMsxVSNRTpBcbDA4xQYSbeB+vbtEXQ7r8tca7iOuZsOXsvuzb2Rr6cghjfA/YvvPaVlS/4pysDBsb5Fvw7DJlhA5PW6XExhP9KrO/Qhn//kaIU14ZfRUVQBNvpwRrAlPCEb76cwHaMBZ14NVyc9RQLiy21L2kdOFbQ82LA9vwM8HE+F073PhkzAFHsb+qHN6sf5H0u+2EnkJ4F6FIHsAOg2jpGxojje6hO5mNp29+MzTI2/fK4kjQh9b+AMDNEiOlXL8jwi2vWmXYjVrd/hcWt/G4sEPyIv2G7CHDpvBIgwzHCyFLMaNQoKnVpG2H2/IPNBAXFlyd9aBbRtUowOKzSY6XoTos7Nc8o1XE0Rwk10mpGG7cEHiW/TQ2/iIQuJJWPle7MSRlYFUY1wB0ML7HVx7+ZpJZdcG6n48jm5yuOdowAn1/WQo4NX57vaa87M0DPlruhlBAng
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(44832011)(2616005)(478600001)(956004)(66946007)(66476007)(16576012)(26005)(921005)(66556008)(4326008)(5660300002)(53546011)(6486002)(7416002)(8936002)(8676002)(83380400001)(31696002)(86362001)(16526019)(316002)(36756003)(186003)(6666004)(30864003)(31686004)(2906002)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q2RxZDhSUDcvYWpob3FsNFRkOE1aUjJFM0lCSDFSK0Z3Y1hWRkVoQlNNN0Rw?=
 =?utf-8?B?V3Q0dUhIQ0pXd1pXUFpwS01XQWN2RlRyS0xIQmxxckhMdWtDQnVYQ1ViOFRD?=
 =?utf-8?B?cUgvc09QWjVXdGlrRTBwaExOOFBGcmR3MThkSlg0Ui8ralRERlJxUVJnOVRi?=
 =?utf-8?B?T0VTbWVSWUkybVBzKzZFZWJaWFArSEZtU2xQTjFFSml2Sy9UbjFSUVJPYnNM?=
 =?utf-8?B?Q3JidENacHozYnoxYzdiMzN3SVE2TVFrUEJTenhrc3NGb2crOFhMV2Jpb0xD?=
 =?utf-8?B?cGE0dEVlRUlxMFYxd3dmblR2N1I5ZUthdlZhMldjcDlQcndJenc2MncxV084?=
 =?utf-8?B?aFhiekxaQ2tJS2wySVhCb3JGaTB3d2ZJVzBCeFkrL2dOM0plNy9rV0xaNURU?=
 =?utf-8?B?Y01uQ1NJTGM1UEV1RjI1NWZuT2NCbVh1Y0ZlUEU1OWN5aFhyZFpKdzRVZC9E?=
 =?utf-8?B?V3hsS2FSdXpzYWZlKzBkL0U3MVJLZm9UVUIwejJ3NTNGazh3OFBKU1YwRG0y?=
 =?utf-8?B?dnE4WkJtbEZ6MFVPMUNXTS94VTR4QUJYVXJzMndRWlErbm5GdmhRZHZpY1Fq?=
 =?utf-8?B?OHVERzl2aHRMNGNqRjlpWmM3VXhBckRIU0M5TWJ1U3pOQVNYT2h2SFAwcmw1?=
 =?utf-8?B?azUrSkVrVnZPM3BKUG8vd0pzNy9qeWZ3ckd3NlhTS3dORmZZaHlkS01LSEZp?=
 =?utf-8?B?c3ZFcWxZdjl0TzVhTkRUaDJNd0hoNU0xaEhocThUOGJTTTZoQmxTejFidDdJ?=
 =?utf-8?B?OXhJdDNHN0NOUG5jY2lsZzBMSWJGV3o4bEF2MVhKMFU4Smd5ZTF6QzRpWExv?=
 =?utf-8?B?clhHRUh6UmRoTldObCszODNOcDN5d3JFYXozNTZwbDZqVlBGbVhMM1RiTmVv?=
 =?utf-8?B?RUhQTXFsSVFZNTUybmVlNkNwbkZhWXF1R1hweGtxNVdqRWtOTk1RRHdkMjVK?=
 =?utf-8?B?NWd3MTFYSjlmZ003U1hkTXl3bGtSbnMrYmxmVkJjMVFUOEg3WHdiUC9HMytt?=
 =?utf-8?B?aW5yUHM4TmMvQkVsdTFsYmZhOTc5c0RpbFp6ejhtZTVDdW5tQVo5VEhNWEtm?=
 =?utf-8?B?TFRPYjZnemVOTmRaVkY2RkYwa0ltWWtRczJqQ2hNUHhhRW10eWxhNzVqYTNK?=
 =?utf-8?B?am15YlpUUVZQSEZSOTdtOW5TbG1FdDBhTnRNeFl1TUR2WExOSWYwaEFURlZK?=
 =?utf-8?B?NDFTTG5qNi9keDNNaGNJb3F2REpSVmxHNldCRDEwa0g3b0hIOG5YR3d4cklI?=
 =?utf-8?B?VXRuUlJSUEd6WXVCUDBSUjBHN1pxc2M0Q1hOcDhPaGQ3anJWd2JEMnVYZlRl?=
 =?utf-8?Q?O6Nk37GjeQxK+cNNGMni9FQt4MCS3O1ifx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 15:20:10.1466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 05f90986-7909-44e2-bed6-08d8b7d6b77e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TIy2f6BEBpRaVxnDUVjBY6054IfMsSs5r0zf4CMq51DPNnCVRYjj2jg4oZTzA+0DEEAjiCzbIdubQYEn+T+sMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2510
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/7/2021 7:28 PM, Vipin Sharma wrote:
> Hardware memory encryption is available on multiple generic CPUs. For
> example AMD has Secure Encrypted Virtualization (SEV) and SEV -
> Encrypted State (SEV-ES).
>
> These memory encryptions are useful in creating encrypted virtual
> machines (VMs) and user space programs.
>
> There are limited number of encryption IDs that can be used
> simultaneously on a machine for encryption. This generates a need for
> the system admin to track, limit, allocate resources, and optimally
> schedule VMs and user workloads in the cloud infrastructure. Some
> malicious programs can exhaust all of these resources on a host causing
> starvation of other workloads.
>
> Encryption ID controller allows control of these resources using
> Cgroups.
>
> Controller is enabled by CGROUP_ENCRYPTION_IDS config option.
> Encryption controller provide 3 interface files for each encryption ID
> type. For example, in SEV:
>
> 1. encrpytion_ids.sev.max
> 	Sets the maximum usage of SEV IDs in the cgroup.
> 2. encryption_ids.sev.current
> 	Current usage of SEV IDs in the cgroup and its children.
> 3. encryption_ids.sev.stat
> 	Shown only at the root cgroup. Displays total SEV IDs available
> 	on the platform and current usage count.
>
> Other ID types can be easily added in the controller in the same way.
>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Reviewed-by: David Rientjes <rientjes@google.com>
> Reviewed-by: Dionna Glaze <dionnaglaze@google.com>


Acked-by: Brijesh Singh <brijesh.singh@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c                |  52 +++-
>   include/linux/cgroup_subsys.h         |   4 +
>   include/linux/encryption_ids_cgroup.h |  72 +++++
>   include/linux/kvm_host.h              |   4 +
>   init/Kconfig                          |  14 +
>   kernel/cgroup/Makefile                |   1 +
>   kernel/cgroup/encryption_ids.c        | 422 ++++++++++++++++++++++++++
>   7 files changed, 557 insertions(+), 12 deletions(-)
>   create mode 100644 include/linux/encryption_ids_cgroup.h
>   create mode 100644 kernel/cgroup/encryption_ids.c
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 9858d5ae9ddd..1924ab2eaf11 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -14,6 +14,7 @@
>   #include <linux/psp-sev.h>
>   #include <linux/pagemap.h>
>   #include <linux/swap.h>
> +#include <linux/encryption_ids_cgroup.h>
>   #include <linux/processor.h>
>   #include <linux/trace_events.h>
>   #include <asm/fpu/internal.h>
> @@ -86,10 +87,18 @@ static bool __sev_recycle_asids(int min_asid, int max_asid)
>   	return true;
>   }
>   
> -static int sev_asid_new(struct kvm_sev_info *sev)
> +static int sev_asid_new(struct kvm *kvm)
>   {
> -	int pos, min_asid, max_asid;
> +	int pos, min_asid, max_asid, ret;
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	bool retry = true;
> +	enum encryption_id_type type;
> +
> +	type = sev->es_active ? ENCRYPTION_ID_SEV_ES : ENCRYPTION_ID_SEV;
> +
> +	ret = enc_id_cg_try_charge(kvm, type, 1);
> +	if (ret)
> +		return ret;
>   
>   	mutex_lock(&sev_bitmap_lock);
>   
> @@ -107,7 +116,8 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>   			goto again;
>   		}
>   		mutex_unlock(&sev_bitmap_lock);
> -		return -EBUSY;
> +		ret = -EBUSY;
> +		goto e_uncharge;
>   	}
>   
>   	__set_bit(pos, sev_asid_bitmap);
> @@ -115,6 +125,9 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>   	mutex_unlock(&sev_bitmap_lock);
>   
>   	return pos + 1;
> +e_uncharge:
> +	enc_id_cg_uncharge(kvm, type, 1);
> +	return ret;
>   }
>   
>   static int sev_get_asid(struct kvm *kvm)
> @@ -124,14 +137,16 @@ static int sev_get_asid(struct kvm *kvm)
>   	return sev->asid;
>   }
>   
> -static void sev_asid_free(int asid)
> +static void sev_asid_free(struct kvm *kvm)
>   {
>   	struct svm_cpu_data *sd;
>   	int cpu, pos;
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	enum encryption_id_type type;
>   
>   	mutex_lock(&sev_bitmap_lock);
>   
> -	pos = asid - 1;
> +	pos = sev->asid - 1;
>   	__set_bit(pos, sev_reclaim_asid_bitmap);
>   
>   	for_each_possible_cpu(cpu) {
> @@ -140,6 +155,9 @@ static void sev_asid_free(int asid)
>   	}
>   
>   	mutex_unlock(&sev_bitmap_lock);
> +
> +	type = sev->es_active ? ENCRYPTION_ID_SEV_ES : ENCRYPTION_ID_SEV;
> +	enc_id_cg_uncharge(kvm, type, 1);
>   }
>   
>   static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
> @@ -184,22 +202,22 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	if (unlikely(sev->active))
>   		return ret;
>   
> -	asid = sev_asid_new(sev);
> +	asid = sev_asid_new(kvm);
>   	if (asid < 0)
>   		return ret;
> +	sev->asid = asid;
>   
>   	ret = sev_platform_init(&argp->error);
>   	if (ret)
>   		goto e_free;
>   
>   	sev->active = true;
> -	sev->asid = asid;
>   	INIT_LIST_HEAD(&sev->regions_list);
>   
>   	return 0;
>   
>   e_free:
> -	sev_asid_free(asid);
> +	sev_asid_free(kvm);
>   	return ret;
>   }
>   
> @@ -1240,12 +1258,12 @@ void sev_vm_destroy(struct kvm *kvm)
>   	mutex_unlock(&kvm->lock);
>   
>   	sev_unbind_asid(kvm, sev->handle);
> -	sev_asid_free(sev->asid);
> +	sev_asid_free(kvm);
>   }
>   
>   void __init sev_hardware_setup(void)
>   {
> -	unsigned int eax, ebx, ecx, edx;
> +	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
>   	bool sev_es_supported = false;
>   	bool sev_supported = false;
>   
> @@ -1277,7 +1295,11 @@ void __init sev_hardware_setup(void)
>   	if (!sev_reclaim_asid_bitmap)
>   		goto out;
>   
> -	pr_info("SEV supported: %u ASIDs\n", max_sev_asid - min_sev_asid + 1);
> +	sev_asid_count = max_sev_asid - min_sev_asid + 1;
> +	if (enc_id_cg_set_capacity(ENCRYPTION_ID_SEV, sev_asid_count))
> +		goto out;
> +
> +	pr_info("SEV supported: %u ASIDs\n", sev_asid_count);
>   	sev_supported = true;
>   
>   	/* SEV-ES support requested? */
> @@ -1292,7 +1314,11 @@ void __init sev_hardware_setup(void)
>   	if (min_sev_asid == 1)
>   		goto out;
>   
> -	pr_info("SEV-ES supported: %u ASIDs\n", min_sev_asid - 1);
> +	sev_es_asid_count = min_sev_asid - 1;
> +	if (enc_id_cg_set_capacity(ENCRYPTION_ID_SEV_ES, sev_es_asid_count))
> +		goto out;
> +
> +	pr_info("SEV-ES supported: %u ASIDs\n", sev_es_asid_count);
>   	sev_es_supported = true;
>   
>   out:
> @@ -1307,6 +1333,8 @@ void sev_hardware_teardown(void)
>   
>   	bitmap_free(sev_asid_bitmap);
>   	bitmap_free(sev_reclaim_asid_bitmap);
> +	enc_id_cg_set_capacity(ENCRYPTION_ID_SEV, 0);
> +	enc_id_cg_set_capacity(ENCRYPTION_ID_SEV_ES, 0);
>   
>   	sev_flush_asids();
>   }
> diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
> index acb77dcff3b4..83754f58c05e 100644
> --- a/include/linux/cgroup_subsys.h
> +++ b/include/linux/cgroup_subsys.h
> @@ -61,6 +61,10 @@ SUBSYS(pids)
>   SUBSYS(rdma)
>   #endif
>   
> +#if IS_ENABLED(CONFIG_CGROUP_ENCRYPTION_IDS)
> +SUBSYS(encryption_ids)
> +#endif
> +
>   /*
>    * The following subsystems are not supported on the default hierarchy.
>    */
> diff --git a/include/linux/encryption_ids_cgroup.h b/include/linux/encryption_ids_cgroup.h
> new file mode 100644
> index 000000000000..af428a4beb28
> --- /dev/null
> +++ b/include/linux/encryption_ids_cgroup.h
> @@ -0,0 +1,72 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Encryption IDs cgroup controller.
> + *
> + * Copyright 2020 Google LLC
> + * Author: Vipin Sharma <vipinsh@google.com>
> + */
> +#ifndef _ENCRYPTION_IDS_CGROUP_H_
> +#define _ENCRYPTION_IDS_CGROUP_H_
> +
> +#include <linux/cgroup-defs.h>
> +#include <linux/kvm_types.h>
> +
> +/**
> + * Types of encryption IDs supported by the host.
> + */
> +enum encryption_id_type {
> +#ifdef CONFIG_KVM_AMD_SEV
> +	ENCRYPTION_ID_SEV,
> +	ENCRYPTION_ID_SEV_ES,
> +#endif
> +	ENCRYPTION_ID_TYPES
> +};
> +
> +#ifdef CONFIG_CGROUP_ENCRYPTION_IDS
> +
> +/**
> + * struct encryption_id_res: Per cgroup per encryption ID resource
> + * @max: Maximum count of encryption ID that can be used.
> + * @usage: Current usage of encryption ID in the cgroup.
> + */
> +struct encryption_id_res {
> +	unsigned int max;
> +	unsigned int usage;
> +};
> +
> +/**
> + * struct encryption_id_cgroup - Encryption IDs controller's cgroup structure.
> + * @css: cgroup subsys state object.
> + * @ids: Array of encryption IDs resource usage in the cgroup.
> + */
> +struct encryption_id_cgroup {
> +	struct cgroup_subsys_state css;
> +	struct encryption_id_res res[ENCRYPTION_ID_TYPES];
> +};
> +
> +int enc_id_cg_set_capacity(enum encryption_id_type type, unsigned int capacity);
> +int enc_id_cg_try_charge(struct kvm *kvm, enum encryption_id_type type,
> +			 unsigned int amount);
> +void enc_id_cg_uncharge(struct kvm *kvm, enum encryption_id_type type,
> +			unsigned int amount);
> +#else
> +static inline int enc_id_cg_set_capacity(enum encryption_id_type type,
> +					 unsigned int capacity)
> +{
> +	return 0;
> +}
> +
> +static inline int enc_id_cg_try_charge(struct kvm *kvm,
> +				       enum encryption_id_type type,
> +				       unsigned int amount)
> +{
> +	return 0;
> +}
> +
> +static inline void enc_id_cg_uncharge(struct kvm *kvm,
> +				      enum encryption_id_type type,
> +				      unsigned int amount)
> +{
> +}
> +#endif /* CONFIG_CGROUP_ENCRYPTION_IDS */
> +#endif /* _ENCRYPTION_CGROUP_H_ */
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f3b1013fb22c..ae9fde0d4267 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -27,6 +27,7 @@
>   #include <linux/refcount.h>
>   #include <linux/nospec.h>
>   #include <asm/signal.h>
> +#include <linux/encryption_ids_cgroup.h>
>   
>   #include <linux/kvm.h>
>   #include <linux/kvm_para.h>
> @@ -513,6 +514,9 @@ struct kvm {
>   	pid_t userspace_pid;
>   	unsigned int max_halt_poll_ns;
>   	u32 dirty_ring_size;
> +#ifdef CONFIG_CGROUP_ENCRYPTION_IDS
> +	struct encryption_id_cgroup *enc_id_cg;
> +#endif
>   };
>   
>   #define kvm_err(fmt, ...) \
> diff --git a/init/Kconfig b/init/Kconfig
> index b77c60f8b963..6c0bd0e7c08d 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1106,6 +1106,20 @@ config CGROUP_BPF
>   	  BPF_CGROUP_INET_INGRESS will be executed on the ingress path of
>   	  inet sockets.
>   
> +config CGROUP_ENCRYPTION_IDS
> +	bool "Encryption IDs controller"
> +	depends on KVM_AMD_SEV
> +	default n
> +	help
> +	  Provides a controller for CPU encryption IDs on a host.
> +
> +	  Some platforms have limited number of encryption IDs which can be
> +	  used simultaneously, e.g., AMD's Secure Encrypted Virtualization
> +	  (SEV). This controller tracks and limits the total number of IDs used
> +	  by processes attached to a cgroup hierarchy. For more information,
> +	  please check Encryption IDs section in
> +	  /Documentation/admin-guide/cgroup-v2.rst.
> +
>   config CGROUP_DEBUG
>   	bool "Debug controller"
>   	default n
> diff --git a/kernel/cgroup/Makefile b/kernel/cgroup/Makefile
> index 5d7a76bfbbb7..6c19208dfb7f 100644
> --- a/kernel/cgroup/Makefile
> +++ b/kernel/cgroup/Makefile
> @@ -5,4 +5,5 @@ obj-$(CONFIG_CGROUP_FREEZER) += legacy_freezer.o
>   obj-$(CONFIG_CGROUP_PIDS) += pids.o
>   obj-$(CONFIG_CGROUP_RDMA) += rdma.o
>   obj-$(CONFIG_CPUSETS) += cpuset.o
> +obj-$(CONFIG_CGROUP_ENCRYPTION_IDS) += encryption_ids.o
>   obj-$(CONFIG_CGROUP_DEBUG) += debug.o
> diff --git a/kernel/cgroup/encryption_ids.c b/kernel/cgroup/encryption_ids.c
> new file mode 100644
> index 000000000000..7cd7d3951bb9
> --- /dev/null
> +++ b/kernel/cgroup/encryption_ids.c
> @@ -0,0 +1,422 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Encryption IDs cgroup controller
> + *
> + * Copyright 2020 Google LLC
> + * Author: Vipin Sharma <vipinsh@google.com>
> + */
> +
> +#include <linux/limits.h>
> +#include <linux/cgroup.h>
> +#include <linux/errno.h>
> +#include <linux/spinlock.h>
> +#include <linux/lockdep.h>
> +#include <linux/slab.h>
> +#include <linux/kvm_host.h>
> +#include <linux/encryption_ids_cgroup.h>
> +
> +#define MAX_STR "max"
> +#define MAX_NUM UINT_MAX
> +
> +/* Root Encryption ID cgroup */
> +static struct encryption_id_cgroup root_cg;
> +
> +/* Lock for tracking and updating encryption ID resources. */
> +static DEFINE_SPINLOCK(enc_id_cg_lock);
> +
> +/* Encryption ID types capacity. */
> +static unsigned int enc_id_capacity[ENCRYPTION_ID_TYPES];
> +
> +/**
> + * css_enc() - Get encryption ID cgroup from the css.
> + * @css: cgroup subsys state object.
> + *
> + * Context: Any context.
> + * Return:
> + * * %NULL - If @css is null.
> + * * struct encryption_id_cgroup* - Encryption ID cgroup pointer of the passed
> + *				    css.
> + */
> +static struct encryption_id_cgroup *css_enc(struct cgroup_subsys_state *css)
> +{
> +	return css ? container_of(css, struct encryption_id_cgroup, css) : NULL;
> +}
> +
> +/**
> + * parent_enc() - Get the parent of the passed encryption ID cgroup.
> + * @cgroup: cgroup whose parent needs to be fetched.
> + *
> + * Context: Any context.
> + * Return:
> + * * struct encryption_id_cgroup* - Parent of the @cgroup.
> + * * %NULL - If @cgroup is null or the passed cgroup does not have a parent.
> + */
> +static struct encryption_id_cgroup *
> +parent_enc(struct encryption_id_cgroup *cgroup)
> +{
> +	return cgroup ? css_enc(cgroup->css.parent) : NULL;
> +}
> +
> +/**
> + * valid_type() - Check if @type is valid or not.
> + * @type: encryption ID type.
> + *
> + * Context: Any context.
> + * Return:
> + * * true - If valid type.
> + * * false - If not valid type.
> + */
> +static inline bool valid_type(enum encryption_id_type type)
> +{
> +	return type >= 0 && type < ENCRYPTION_ID_TYPES;
> +}
> +
> +/**
> + * enc_id_cg_uncharge_hierarchy() - Uncharge the enryption ID cgroup hierarchy.
> + * @start_cg: Starting cgroup.
> + * @stop_cg: cgroup at which uncharge stops.
> + * @type: type of encryption ID to uncharge.
> + * @amount: Charge amount.
> + *
> + * Uncharge the cgroup tree from the given start cgroup to the stop cgroup.
> + *
> + * Context: Any context. Expects enc_id_cg_lock to be held by the caller.
> + */
> +static void enc_id_cg_uncharge_hierarchy(struct encryption_id_cgroup *start_cg,
> +					 struct encryption_id_cgroup *stop_cg,
> +					 enum encryption_id_type type,
> +					 unsigned int amount)
> +{
> +	struct encryption_id_cgroup *i;
> +
> +	lockdep_assert_held(&enc_id_cg_lock);
> +
> +	for (i = start_cg; i != stop_cg; i = parent_enc(i)) {
> +		WARN_ON_ONCE(i->res[type].usage < amount);
> +		i->res[type].usage -= amount;
> +	}
> +	css_put(&start_cg->css);
> +}
> +
> +/**
> + * enc_id_cg_set_capacity() - Set the capacity of the encryption ID.
> + * @type: Type of the encryption ID.
> + * @capacity: Supported capacity of the encryption ID on the host.
> + *
> + * If capacity is 0 then the charging a cgroup fails for the encryption ID.
> + *
> + * Context: Any context. Takes and releases enc_id_cg_lock.
> + * Return:
> + * * %0 - Successfully registered the capacity.
> + * * %-EINVAL - If @type is invalid.
> + * * %-EBUSY - If current usage is more than the capacity.
> + */
> +int enc_id_cg_set_capacity(enum encryption_id_type type, unsigned int capacity)
> +{
> +	int ret = 0;
> +	unsigned long flags;
> +
> +	if (!valid_type(type))
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&enc_id_cg_lock, flags);
> +
> +	if (WARN_ON_ONCE(root_cg.res[type].usage > capacity))
> +		ret = -EBUSY;
> +	else
> +		enc_id_capacity[type] = capacity;
> +
> +	spin_unlock_irqrestore(&enc_id_cg_lock, flags);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(enc_id_cg_set_capacity);
> +
> +/**
> + * enc_id_cg_try_charge() - Try charging encryption ID cgroup.
> + * @kvm: kvm to store charged cgroup.
> + * @type: Encryption ID type to charge.
> + * @amount: Amount to charge.
> + *
> + * Charge @amount to the cgroup to which the current task belongs to. Charged
> + * cgroup will be pointed by @cg. Caller must use the same cgroup during
> + * uncharge call.
> + *
> + * Context: Any context. Takes and releases enc_id_cg_lock.
> + * Return:
> + * * %0 - If successfully charged.
> + * * -EINVAL - If @type is invalid or encryption ID has 0 capacity.
> + * * -EBUSY - If max limit will be crossed or total usage will be more than the
> + *	      capacity.
> + */
> +int enc_id_cg_try_charge(struct kvm *kvm, enum encryption_id_type type,
> +			 unsigned int amount)
> +{
> +	struct encryption_id_cgroup *task_cg, *i;
> +	struct encryption_id_res *id_res;
> +	int ret;
> +	unsigned int new_usage;
> +	unsigned long flags;
> +
> +	if (!valid_type(type) || !kvm)
> +		return -EINVAL;
> +
> +	if (!amount)
> +		return 0;
> +
> +	spin_lock_irqsave(&enc_id_cg_lock, flags);
> +
> +	if (!enc_id_capacity[type]) {
> +		ret = -EINVAL;
> +		goto err_capacity;
> +	}
> +
> +	task_cg = css_enc(task_get_css(current, encryption_ids_cgrp_id));
> +
> +	for (i = task_cg; i; i = parent_enc(i)) {
> +		id_res = &i->res[type];
> +
> +		new_usage = id_res->usage + amount;
> +		WARN_ON_ONCE(new_usage < id_res->usage);
> +
> +		if (new_usage > id_res->max ||
> +		    new_usage > enc_id_capacity[type]) {
> +			ret = -EBUSY;
> +			goto err_charge;
> +		}
> +
> +		id_res->usage = new_usage;
> +	}
> +
> +	kvm->enc_id_cg = task_cg;
> +	spin_unlock_irqrestore(&enc_id_cg_lock, flags);
> +	return 0;
> +
> +err_charge:
> +	enc_id_cg_uncharge_hierarchy(task_cg, i, type, amount);
> +err_capacity:
> +	spin_unlock_irqrestore(&enc_id_cg_lock, flags);
> +	return ret;
> +}
> +EXPORT_SYMBOL(enc_id_cg_try_charge);
> +
> +/**
> + * enc_id_cg_uncharge() - Uncharge the encryption ID cgroup.
> + * @kvm: kvm containing the corresponding encryption ID cgroup.
> + * @type: Encryption ID which was charged.
> + * @amount: Charged amount.
> + *
> + * Context: Any context. Takes and releases enc_id_cg_lock.
> + */
> +void enc_id_cg_uncharge(struct kvm *kvm, enum encryption_id_type type,
> +			unsigned int amount)
> +{
> +	unsigned long flags;
> +
> +	if (!amount)
> +		return;
> +	if (!valid_type(type))
> +		return;
> +	if (!kvm || WARN_ON_ONCE(!(kvm->enc_id_cg)))
> +		return;
> +
> +	spin_lock_irqsave(&enc_id_cg_lock, flags);
> +	enc_id_cg_uncharge_hierarchy(kvm->enc_id_cg, NULL, type, amount);
> +	spin_unlock_irqrestore(&enc_id_cg_lock, flags);
> +
> +	kvm->enc_id_cg = NULL;
> +}
> +EXPORT_SYMBOL(enc_id_cg_uncharge);
> +
> +/**
> + * enc_id_cg_max_show() - Show encryption ID cgroup max limit.
> + * @sf: Interface file
> + * @v: Arguments passed
> + *
> + * Uses cft->private value to determine for which enryption ID type results be
> + * shown.
> + *
> + * Context: Any context.
> + * Return: 0 to denote successful print.
> + */
> +static int enc_id_cg_max_show(struct seq_file *sf, void *v)
> +{
> +	struct encryption_id_cgroup *cg = css_enc(seq_css(sf));
> +	enum encryption_id_type type = seq_cft(sf)->private;
> +
> +	if (cg->res[type].max == MAX_NUM)
> +		seq_printf(sf, "%s\n", MAX_STR);
> +	else
> +		seq_printf(sf, "%u\n", cg->res[type].max);
> +
> +	return 0;
> +}
> +
> +/**
> + * enc_id_cg_max_write() - Update the maximum limit of the cgroup.
> + * @of: Handler for the file.
> + * @buf: Data from the user. It should be either "max", 0, or a positive
> + *	 integer.
> + * @nbytes: Number of bytes of the data.
> + * @off: Offset in the file.
> + *
> + * Uses cft->private value to determine for which enryption ID type results be
> + * shown.
> + *
> + * Context: Any context. Takes and releases enc_id_cg_lock.
> + * Return:
> + * * >= 0 - Number of bytes processed in the input.
> + * * -EINVAL - If buf is not valid.
> + * * -ERANGE - If number is bigger than unsigned int capacity.
> + * * -EBUSY - If usage can become more than max limit.
> + */
> +static ssize_t enc_id_cg_max_write(struct kernfs_open_file *of, char *buf,
> +				   size_t nbytes, loff_t off)
> +{
> +	struct encryption_id_cgroup *cg;
> +	unsigned int max;
> +	int ret = 0;
> +	enum encryption_id_type type;
> +
> +	buf = strstrip(buf);
> +	if (!strcmp(MAX_STR, buf)) {
> +		max = UINT_MAX;
> +	} else {
> +		ret = kstrtouint(buf, 0, &max);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	cg = css_enc(of_css(of));
> +	type = of_cft(of)->private;
> +	cg->res[type].max = max;
> +
> +	return nbytes;
> +}
> +
> +/**
> + * enc_id_cg_current_read() - Show current usage of the encryption ID.
> + * @css: css pointer of the cgroup.
> + * @cft: cft pointer of the cgroup.
> + *
> + * Uses cft->private value to determine for which enryption ID type results be
> + * shown.
> + *
> + * Context: Any context.
> + * Return: 0 to denote successful print.
> + */
> +static u64 enc_id_cg_current_read(struct cgroup_subsys_state *css,
> +				  struct cftype *cft)
> +{
> +	struct encryption_id_cgroup *cg = css_enc(css);
> +	enum encryption_id_type type = cft->private;
> +
> +	return cg->res[type].usage;
> +}
> +
> +/**
> + * enc_id_cg_stat_show() - Show the current stat of the cgroup.
> + * @sf: Interface file
> + * @v: Arguments passed
> + *
> + * Shows the total capacity of the encryption ID and its current usage.
> + * Only shows in root cgroup directory.
> + *
> + * Uses cft->private value to determine for which enryption ID type results be
> + * shown.
> + *
> + * Context: Any context. Takes and releases enc_id_cg_lock.
> + * Return: 0 to denote successful print.
> + */
> +static int enc_id_cg_stat_show(struct seq_file *sf, void *v)
> +{
> +	unsigned long flags;
> +	enum encryption_id_type type = seq_cft(sf)->private;
> +
> +	spin_lock_irqsave(&enc_id_cg_lock, flags);
> +
> +	seq_printf(sf, "total %u\n", enc_id_capacity[type]);
> +	seq_printf(sf, "used %u\n", root_cg.res[type].usage);
> +
> +	spin_unlock_irqrestore(&enc_id_cg_lock, flags);
> +	return 0;
> +}
> +
> +/* Each encryption ID type has these cgroup files. */
> +#define ENC_ID_CGROUP_FILES(id_name, id_type)		\
> +	[(id_type) * 3] = {				\
> +		.name = id_name ".max",			\
> +		.write = enc_id_cg_max_write,		\
> +		.seq_show = enc_id_cg_max_show,		\
> +		.flags = CFTYPE_NOT_ON_ROOT,		\
> +		.private = id_type,			\
> +	},						\
> +	[((id_type) * 3) + 1] = {			\
> +		.name = id_name ".current",		\
> +		.read_u64 = enc_id_cg_current_read,	\
> +		.flags = CFTYPE_NOT_ON_ROOT,		\
> +		.private = id_type,			\
> +	},						\
> +	[((id_type) * 3) + 2] = {			\
> +		.name = id_name ".stat",		\
> +		.seq_show = enc_id_cg_stat_show,	\
> +		.flags = CFTYPE_ONLY_ON_ROOT,		\
> +		.private = id_type,			\
> +	}
> +
> +/* Encryption ID cgroup interface files */
> +static struct cftype enc_id_cg_files[] = {
> +#ifdef CONFIG_KVM_AMD_SEV
> +	ENC_ID_CGROUP_FILES("sev", ENCRYPTION_ID_SEV),
> +	ENC_ID_CGROUP_FILES("sev_es", ENCRYPTION_ID_SEV_ES),
> +#endif
> +	{}
> +};
> +
> +/**
> + * enc_id_cg_alloc() - Allocate encryption ID cgroup.
> + * @parent_css: Parent cgroup.
> + *
> + * Context: Process context.
> + * Return:
> + * * struct cgroup_subsys_state* - css of the allocated cgroup.
> + * * ERR_PTR(-ENOMEM) - No memory available to allocate.
> + */
> +static struct cgroup_subsys_state *
> +enc_id_cg_alloc(struct cgroup_subsys_state *parent_css)
> +{
> +	enum encryption_id_type i;
> +	struct encryption_id_cgroup *cg;
> +
> +	if (!parent_css) {
> +		cg = &root_cg;
> +	} else {
> +		cg = kzalloc(sizeof(*cg), GFP_KERNEL);
> +		if (!cg)
> +			return ERR_PTR(-ENOMEM);
> +	}
> +
> +	for (i = 0; i < ENCRYPTION_ID_TYPES; i++)
> +		cg->res[i].max = MAX_NUM;
> +
> +	return &cg->css;
> +}
> +
> +/**
> + * enc_id_cg_free() - Free the encryption ID cgroup.
> + * @css: cgroup subsys object.
> + *
> + * Context: Any context.
> + */
> +static void enc_id_cg_free(struct cgroup_subsys_state *css)
> +{
> +	kfree(css_enc(css));
> +}
> +
> +/* Cgroup controller callbacks */
> +struct cgroup_subsys encryption_ids_cgrp_subsys = {
> +	.css_alloc = enc_id_cg_alloc,
> +	.css_free = enc_id_cg_free,
> +	.legacy_cftypes = enc_id_cg_files,
> +	.dfl_cftypes = enc_id_cg_files,
> +};
