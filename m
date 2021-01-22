Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDC9301153
	for <lists+kvm@lfdr.de>; Sat, 23 Jan 2021 01:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbhAWAAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 19:00:38 -0500
Received: from mail-dm6nam11on2072.outbound.protection.outlook.com ([40.107.223.72]:15713
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726439AbhAVX7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 18:59:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WxIdwMOT8AwL4qfjxR8nlp1oseUovpinU+7vIN9SAedsJ3Z+Z/Q8y0mr810KIOysVnlr0O273c/GdHnR+RDh/CpFYGsaaeJnPYcP/u4JQbxdCwBK5zc4r5jC1N4wCFiJrmcCcoys2jlaahzhgUAyVNHpGlRfiNjxrXBeYISBK6UbNeiOZNhg1JGiDCJaOY9r0iqwOR8UAHW0P4FqCOHEhxSI3SCWc7FXHh/7bzodicnPj8lrYCZVbohKjRfzxTCK4ARH69AP8O/viQTtTV8wlFdEF6YjdEaPYyGTFclfmdnR+XE0AjqFppSeaTxO8eQ4BY8yWZW4o44JbQS05wQiOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpHt5CjFOY6t1xhqGDWxkN6SfKP6mvUSF9GNrdbJBnE=;
 b=Pb2lSfF5ZsbnHLr8JcLNN1Uuvlk75FJiw0NqaY4c02z1CNksrhBKwcFqx48DcQafZyYZX2+O8w8jIExieTwOTQcgNvXGMA6ZD2X2mEsIA8gV3B1H9UdgGnEb8B3VYXXco3mv+cW/kXiPurr6+mJDBmBkKa+++k60jlUtICHQ3fXM5N88riCxUgyL3Lb3KQlssbAwzqH2KVjoKj6CgLi+tLaIRiP/5mM1O5zczKC3+olm9jnlF8VE2LPilxNhZoqwEwAlFjZcxUuoCvB4es9XscLUfZGK/3bV7jXkXGwGr8SYuFFKcRwulfiinYYtYqQvNfcIA7YnCKEjOUXvu/msbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpHt5CjFOY6t1xhqGDWxkN6SfKP6mvUSF9GNrdbJBnE=;
 b=1MDljDffdB70C2sjD4ghkRvlAdTPFrywXX0TTFJ5PnuPSqcQKNpshInh1O4aFSFu/HBQG3O8XPt5vvDiMPNWvnmnKQ5PmtEOs0vhLLDqachZm2e8oDUEYH1KZovwnHwJ3tS7hKLiUcXYYRnFueFLw9yTA4VIPeIle7fM7bK34G0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (52.135.103.22) by
 SA0PR12MB4365.namprd12.prod.outlook.com (20.181.61.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.15; Fri, 22 Jan 2021 23:58:38 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a466:5841:df95:1eb8]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a466:5841:df95:1eb8%5]) with mapi id 15.20.3763.014; Fri, 22 Jan 2021
 23:58:38 +0000
Cc:     brijesh.singh@amd.com, James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] KVM/SVM: add support for SEV attestation command
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210104151749.30248-1-brijesh.singh@amd.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <33f61434-ab55-c30b-6da0-8119a96e0d1c@amd.com>
Date:   Fri, 22 Jan 2021 17:58:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210104151749.30248-1-brijesh.singh@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0501CA0156.namprd05.prod.outlook.com
 (2603:10b6:803:2c::34) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.7 via Frontend Transport; Fri, 22 Jan 2021 23:58:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d5206fd4-62cf-45b6-696d-08d8bf31a2ef
X-MS-TrafficTypeDiagnostic: SA0PR12MB4365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4365E2321C39CAD79A6D7B62E5A09@SA0PR12MB4365.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dZiNUdSHNF8HWFZCBhTdPMywyYPOcypuPBmrv5BSpf6Nnh2oScRy/D1/RJDtKyDVPktdtV/9g0oabdv6wgILqcBYMHc9nDn17ySUWj/VCMrlweOuMxtOe6mOsfBkYPPAtGEs6PNNP0Y1VyMqslXTyGn2IOgkAW/nE6vsiLOpNzxKTv7PdoG3XcVn/0Fdz9uY8qB4cZY9OwBSIfsRcZGiC58UteX1Sjo6jUrJLOvNhe0AXKgXYIYlESfbp/KZJ+Gtu8ED/nfpSzEbYpVE9eKaFFZNYvdnFnn0Y2Ec0PwwNudN8V2TuIZZFBYZrsKedtrZUuPW9BOjiZNf3XEC3XbiN7DQE9gZ+DZvx86Atin0GuD6+LiI2Fqhiq1VNgenNdXwqlL11BRHJK8mCVt+PbHRQ4yaA/x750c/GcaJ6BSrrEHSlL7q4rrd7jvXsy+Lnle5HTnjixM66o3hCOQZLxQomIF2Rj4M3yyynGeroow2aaE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(376002)(396003)(39860400002)(66556008)(36756003)(2906002)(83380400001)(66476007)(5660300002)(66946007)(6486002)(316002)(54906003)(186003)(956004)(44832011)(2616005)(53546011)(6506007)(478600001)(8676002)(31686004)(6512007)(26005)(8936002)(4326008)(31696002)(52116002)(86362001)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?N2x4ek05WlI3Vkl6STFmV2xhcm12VCtKdE5DbFZXR2VXcVpRSnQ3OU05NW02?=
 =?utf-8?B?ZXVuRHlnVjA1RDFucVc4WTViNU5NdThZVHFZNUxXTTl6SzlhTG9QaUVkVjRC?=
 =?utf-8?B?cnFyWHd3WnZLQm9TOUIzR2YxTUw0RGZ3MFpOZ0NYWlVObjBUZGRqLy95akVI?=
 =?utf-8?B?dDVLc1N0SS9LNkYzT09aVjFpT3JyNkdZTThqaGpWb25JbjVxUVhjWFlsNDRu?=
 =?utf-8?B?Z3djT0NMTjQ5dWZKNlY2eWFzb2c3OS9WeWJ4b3pvTFBtK2FEclM5RHhOTldH?=
 =?utf-8?B?M1BmUTZqWUpiNC96aWExYTJuZk9uT3dmdzgvVTJXRkNDSkl5U0h0aWU4K2V3?=
 =?utf-8?B?ZDI4bXFMc1BURGZ0dlRjVTYwbll1NlcwQnplS1ZFaTJJMlJxYjhYZERnQVdn?=
 =?utf-8?B?Z1c1NU1zTE9GVXovbmRuc09BNEdDdjViTXR6ZktwWjVyZ09DTTV5ajFRNHNN?=
 =?utf-8?B?UFZsVU5qZnRFcFdtY0M2ZmpvbWJyd0p6NER5dm5SMXFyNWlvUEVVYVIwVnB6?=
 =?utf-8?B?RmYvVlhWK00zKzFGak9YQjV1aDBIUGwvU3YzVXArQS81R0oxMGVkbzl0bFkx?=
 =?utf-8?B?d3BEUmFORHlmQUt4MjRSb1J0Mlh6cDFrRUxKRXBPR05keEFxSzZtWk1Gbisy?=
 =?utf-8?B?cVYva2NuMmxDSTVZanAvQ3pZM0RPakI1MTlqRytRanVDUkc5ekdub2ovWU9h?=
 =?utf-8?B?QndwaUh5aDlkd0Q5MGd4Si9xR0lIWVBYL1NVZUc1SjJmek4waDFDTXY3alMz?=
 =?utf-8?B?ZG01czgxYTBJV2RTZUd3MFYvMEp1bUZISDloMWxIOUxPdUJFYXZ5SnkrcE5y?=
 =?utf-8?B?dGhQWFpTaTFuZlM1c3I3MmtVNStFMTVTUjRYTnFPK1RTMTRTSmlJWjFZVnk3?=
 =?utf-8?B?NnRhS09hVmJRanZZWEF1MnBhWG90TzU2WkNQelNGLzZaZkc4cDRuS3JKN0FR?=
 =?utf-8?B?QnUrcG04OGxJYitXaEVXWXRRTk03bXhnaGxSbTAzWUdCNStEMXkyWmNyVzVw?=
 =?utf-8?B?YlMwYUZYVSs4cDgrS0VETE5NNDRrcXFZbm9iVTFDVDNoR0duQ05iaGhDL1Qx?=
 =?utf-8?B?bmFDVG95M3l1b1RjK0xyK2YzT2Z1bHZuWUpadXhmVHM0V0NzZTFIK1BqOE02?=
 =?utf-8?B?M1FqcndPcjFSc1dGR0ZydFBiQk0xeTJQeCtBWmlIVTdBUXlzZWlFQ3V4bzM4?=
 =?utf-8?B?RWdoQ2VGbmxVclcwVWRGL1hTNTJJTC9GWmxPZlYyK3VHdXRueUtQUVNVbGpx?=
 =?utf-8?B?cGNnaENIc1NXVVJTVStpY1hwOXROUVF3QitSbXJmZk1ZRzJLOTUydXV4YUR4?=
 =?utf-8?Q?UMf4fHtdbVmOAdLVVT+hJoNxkx3kGz/4QA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5206fd4-62cf-45b6-696d-08d8bf31a2ef
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 23:58:38.4035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S2U3LZv8FHPrtrsWH7UpJwIrG9q9NFDEqKDpceVh2qktunUpzr46D02n2Ft+GLYOiARhpZ9mZ5hlCQgbMj3UMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4365
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Do you have any feedback on this ? It will be great if we can queue this
for 5.11.

-Brijesh

On 1/4/21 9:17 AM, Brijesh Singh wrote:
> The SEV FW version >= 0.23 added a new command that can be used to query
> the attestation report containing the SHA-256 digest of the guest memory
> encrypted through the KVM_SEV_LAUNCH_UPDATE_{DATA, VMSA} commands and
> sign the report with the Platform Endorsement Key (PEK).
>
> See the SEV FW API spec section 6.8 for more details.
>
> Note there already exist a command (KVM_SEV_LAUNCH_MEASURE) that can be
> used to get the SHA-256 digest. The main difference between the
> KVM_SEV_LAUNCH_MEASURE and KVM_SEV_ATTESTATION_REPORT is that the latter
> can be called while the guest is running and the measurement value is
> signed with PEK.
>
> Cc: James Bottomley <jejb@linux.ibm.com>
> Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: John Allen <john.allen@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-crypto@vger.kernel.org
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Tested-by: James Bottomley <jejb@linux.ibm.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
> v2:
>   * Fix documentation typo
>
>  .../virt/kvm/amd-memory-encryption.rst        | 21 ++++++
>  arch/x86/kvm/svm/sev.c                        | 71 +++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.c                  |  1 +
>  include/linux/psp-sev.h                       | 17 +++++
>  include/uapi/linux/kvm.h                      |  8 +++
>  5 files changed, 118 insertions(+)
>
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index 09a8f2a34e39..469a6308765b 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -263,6 +263,27 @@ Returns: 0 on success, -negative on error
>                  __u32 trans_len;
>          };
>  
> +10. KVM_SEV_GET_ATTESTATION_REPORT
> +----------------------------------
> +
> +The KVM_SEV_GET_ATTESTATION_REPORT command can be used by the hypervisor to query the attestation
> +report containing the SHA-256 digest of the guest memory and VMSA passed through the KVM_SEV_LAUNCH
> +commands and signed with the PEK. The digest returned by the command should match the digest
> +used by the guest owner with the KVM_SEV_LAUNCH_MEASURE.
> +
> +Parameters (in): struct kvm_sev_attestation
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_attestation_report {
> +                __u8 mnonce[16];        /* A random mnonce that will be placed in the report */
> +
> +                __u64 uaddr;            /* userspace address where the report should be copied */
> +                __u32 len;
> +        };
> +
>  References
>  ==========
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 566f4d18185b..c4d3ee6be362 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -927,6 +927,74 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
>  
> +static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	void __user *report = (void __user *)(uintptr_t)argp->data;
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_attestation_report *data;
> +	struct kvm_sev_attestation_report params;
> +	void __user *p;
> +	void *blob = NULL;
> +	int ret;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
> +		return -EFAULT;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	/* User wants to query the blob length */
> +	if (!params.len)
> +		goto cmd;
> +
> +	p = (void __user *)(uintptr_t)params.uaddr;
> +	if (p) {
> +		if (params.len > SEV_FW_BLOB_MAX_SIZE) {
> +			ret = -EINVAL;
> +			goto e_free;
> +		}
> +
> +		ret = -ENOMEM;
> +		blob = kmalloc(params.len, GFP_KERNEL);
> +		if (!blob)
> +			goto e_free;
> +
> +		data->address = __psp_pa(blob);
> +		data->len = params.len;
> +		memcpy(data->mnonce, params.mnonce, sizeof(params.mnonce));
> +	}
> +cmd:
> +	data->handle = sev->handle;
> +	ret = sev_issue_cmd(kvm, SEV_CMD_ATTESTATION_REPORT, data, &argp->error);
> +	/*
> +	 * If we query the session length, FW responded with expected data.
> +	 */
> +	if (!params.len)
> +		goto done;
> +
> +	if (ret)
> +		goto e_free_blob;
> +
> +	if (blob) {
> +		if (copy_to_user(p, blob, params.len))
> +			ret = -EFAULT;
> +	}
> +
> +done:
> +	params.len = data->len;
> +	if (copy_to_user(report, &params, sizeof(params)))
> +		ret = -EFAULT;
> +e_free_blob:
> +	kfree(blob);
> +e_free:
> +	kfree(data);
> +	return ret;
> +}
> +
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_sev_cmd sev_cmd;
> @@ -971,6 +1039,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_LAUNCH_SECRET:
>  		r = sev_launch_secret(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_GET_ATTESTATION_REPORT:
> +		r = sev_get_attestation_report(kvm, &sev_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 476113e12489..cb9b4c4e371e 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -128,6 +128,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_LAUNCH_UPDATE_SECRET:	return sizeof(struct sev_data_launch_secret);
>  	case SEV_CMD_DOWNLOAD_FIRMWARE:		return sizeof(struct sev_data_download_firmware);
>  	case SEV_CMD_GET_ID:			return sizeof(struct sev_data_get_id);
> +	case SEV_CMD_ATTESTATION_REPORT:	return sizeof(struct sev_data_attestation_report);
>  	default:				return 0;
>  	}
>  
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 49d155cd2dfe..b801ead1e2bb 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -66,6 +66,7 @@ enum sev_cmd {
>  	SEV_CMD_LAUNCH_MEASURE		= 0x033,
>  	SEV_CMD_LAUNCH_UPDATE_SECRET	= 0x034,
>  	SEV_CMD_LAUNCH_FINISH		= 0x035,
> +	SEV_CMD_ATTESTATION_REPORT	= 0x036,
>  
>  	/* Guest migration commands (outgoing) */
>  	SEV_CMD_SEND_START		= 0x040,
> @@ -483,6 +484,22 @@ struct sev_data_dbg {
>  	u32 len;				/* In */
>  } __packed;
>  
> +/**
> + * struct sev_data_attestation_report - SEV_ATTESTATION_REPORT command parameters
> + *
> + * @handle: handle of the VM
> + * @mnonce: a random nonce that will be included in the report.
> + * @address: physical address where the report will be copied.
> + * @len: length of the physical buffer.
> + */
> +struct sev_data_attestation_report {
> +	u32 handle;				/* In */
> +	u32 reserved;
> +	u64 address;				/* In */
> +	u8 mnonce[16];				/* In */
> +	u32 len;				/* In/Out */
> +} __packed;
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  
>  /**
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ca41220b40b8..d3385f7f08a2 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1585,6 +1585,8 @@ enum sev_cmd_id {
>  	KVM_SEV_DBG_ENCRYPT,
>  	/* Guest certificates commands */
>  	KVM_SEV_CERT_EXPORT,
> +	/* Attestation report */
> +	KVM_SEV_GET_ATTESTATION_REPORT,
>  
>  	KVM_SEV_NR_MAX,
>  };
> @@ -1637,6 +1639,12 @@ struct kvm_sev_dbg {
>  	__u32 len;
>  };
>  
> +struct kvm_sev_attestation_report {
> +	__u8 mnonce[16];
> +	__u64 uaddr;
> +	__u32 len;
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
