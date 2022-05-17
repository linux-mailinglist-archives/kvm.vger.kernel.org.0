Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC90A52A10E
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 14:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345744AbiEQMBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 08:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346327AbiEQMBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 08:01:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8A93FBD3;
        Tue, 17 May 2022 05:01:13 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HBgN25015231;
        Tue, 17 May 2022 12:01:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=8tKu96eV7gkYdRtal6CZsdy9L/PGLnBnCjiKVQiWxr0=;
 b=omKlmnw8L59buMZ/vtr4T+iEHI/NmjvpSsSsNcWgUBfygqQJhEuHUz7cD1tllH6hvU45
 tJjHTK+LyN72EcchDReDIPpesHvT7Lrwdfx8+hAckGCS8RJeAnWpgOkpEfp2Iea5nwMT
 zioIBOS6SjY/2N5sVhO/ABwQ7owsHQcQtJ4F701rjGDJD0XToYGHSKv6f/FFPiPSDl1/
 GjhHvVOjlVNjba8wH2n5toadSz1RqEgPLhDcP80GgCr3zKB8d4bFlMdgKRqUbK3EBLWB
 n3SOYmN4RDxVjXEqEQcyF1GydKrO6NHuzzn5VakaPTsUBOn8GmfeB3s+HaEHUekPv7b3 jg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4b2jrbxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 12:01:12 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HBIJMO025053;
        Tue, 17 May 2022 11:37:16 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3g2429c4ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:37:16 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HBbDq521365078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 11:37:13 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44463A405B;
        Tue, 17 May 2022 11:37:13 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 144E9A4054;
        Tue, 17 May 2022 11:37:13 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 11:37:13 +0000 (GMT)
Date:   Tue, 17 May 2022 13:13:31 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH v5 10/10] Documentation/virt/kvm/api.rst: Add protvirt
 dump/info api descriptions
Message-ID: <20220517131331.42e18ed5@p-imbrenda>
In-Reply-To: <20220516090817.1110090-11-frankja@linux.ibm.com>
References: <20220516090817.1110090-1-frankja@linux.ibm.com>
        <20220516090817.1110090-11-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 837cRDG7-6l958ImpH9JiYXBoXgonp12
X-Proofpoint-GUID: 837cRDG7-6l958ImpH9JiYXBoXgonp12
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_02,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 May 2022 09:08:17 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Time to add the dump API changes to the api documentation file.
> Also some minor cleanup.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  Documentation/virt/kvm/api.rst | 153 ++++++++++++++++++++++++++++++++-
>  1 file changed, 151 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 4a900cdbc62e..c7c964887f5f 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5061,7 +5061,7 @@ into ESA mode. This reset is a superset of the initial reset.
>  	__u32 reserved[3];
>    };
>  
> -cmd values:
> +**cmd values:**
>  
>  KVM_PV_ENABLE
>    Allocate memory and register the VM with the Ultravisor, thereby
> @@ -5077,7 +5077,6 @@ KVM_PV_ENABLE
>    =====      =============================
>  
>  KVM_PV_DISABLE
> -
>    Deregister the VM from the Ultravisor and reclaim the memory that
>    had been donated to the Ultravisor, making it usable by the kernel
>    again.  All registered VCPUs are converted back to non-protected
> @@ -5094,6 +5093,115 @@ KVM_PV_VM_VERIFY
>    Verify the integrity of the unpacked image. Only if this succeeds,
>    KVM is allowed to start protected VCPUs.
>  
> +KVM_PV_INFO
> +  :Capability: KVM_CAP_S390_PROTECTED_DUMP
> +
> +  Presents an API that provides Ultravisor related data to userspace
> +  via subcommands. len_max is the size of the user space buffer,
> +  len_written is KVM's indication of how much bytes of that buffer
> +  were actually written to. len_written can be used to determine the
> +  valid fields if more response fields are added in the future.
> +
> +  ::
> +
> +     enum pv_cmd_info_id {
> +        KVM_PV_INFO_VM,
> +        KVM_PV_INFO_DUMP,
> +     };
> +
> +     struct kvm_s390_pv_info_header {
> +        __u32 id;
> +        __u32 len_max;
> +        __u32 len_written;
> +        __u32 reserved;
> +     };
> +
> +     struct kvm_s390_pv_info {
> +        struct kvm_s390_pv_info_header header;
> +        struct kvm_s390_pv_info_dump dump;
> +	struct kvm_s390_pv_info_vm vm;
> +     };
> +
> +**subcommands:**
> +
> +  KVM_PV_INFO_VM
> +    This subcommand provides basic Ultravisor information for PV
> +    hosts. These values are likely also exported as files in the sysfs
> +    firmware UV query interface but they are more easily available to
> +    programs in this API.
> +
> +    The installed calls and feature_indication members provide the
> +    installed UV calls and the UV's other feature indications.
> +
> +    The max_* members provide information about the maximum number of PV
> +    vcpus, PV guests and PV guest memory size.
> +
> +    ::
> +
> +      struct kvm_s390_pv_info_vm {
> +        __u64 inst_calls_list[4];
> +        __u64 max_cpus;
> +        __u64 max_guests;
> +        __u64 max_guest_addr;
> +        __u64 feature_indication;
> +      };
> +
> +
> +  KVM_PV_INFO_DUMP
> +    This subcommand provides information related to dumping PV guests.
> +
> +    ::
> +
> +      struct kvm_s390_pv_info_dump {
> +        __u64 dump_cpu_buffer_len;
> +        __u64 dump_config_mem_buffer_per_1m;
> +        __u64 dump_config_finalize_len;
> +      };
> +
> +KVM_PV_DUMP
> +  :Capability: KVM_CAP_S390_PROTECTED_DUMP
> +
> +  Presents an API that provides calls which facilitate dumping a
> +  protected VM.
> +
> +  ::
> +
> +    struct kvm_s390_pv_dmp {
> +      __u64 subcmd;
> +      __u64 buff_addr;
> +      __u64 buff_len;
> +      __u64 gaddr;		/* For dump storage state */
> +    };
> +
> +  **subcommands:**
> +
> +  KVM_PV_DUMP_INIT
> +    Initializes the dump process of a protected VM. If this call does
> +    not succeed all other subcommands will fail with -EINVAL. This
> +    subcommand will return -EINVAL if a dump process has not yet been
> +    completed.
> +
> +    Not all PV vms can be dumped, the owner needs to set `dump
> +    allowed` PCF bit 34 in the SE header to allow dumping.
> +
> +  KVM_PV_DUMP_CONFIG_STOR_STATE
> +    Stores `buff_len` bytes of tweak component values starting with
> +    the 1MB block specified by the absolute guest address
> +    (`gaddr`). `buff_len` needs to be `conf_dump_storage_state_len`
> +    aligned and at least >= the `conf_dump_storage_state_len` value
> +    provided by the dump uv_info data.

please explain that the output buffer might be written to (even
partially) even when the IOCTL fails

> +
> +  KVM_PV_DUMP_COMPLETE
> +    If the subcommand succeeds it completes the dump process and lets
> +    KVM_PV_DUMP_INIT be called again.
> +
> +    On success `conf_dump_finalize_len` bytes of completion data will be
> +    stored to the `buff_addr`. The completion data contains a key
> +    derivation seed, IV, tweak nonce and encryption keys as well as an
> +    authentication tag all of which are needed to decrypt the dump at a
> +    later time.
> +
> +
>  4.126 KVM_X86_SET_MSR_FILTER
>  ----------------------------
>  
> @@ -5646,6 +5754,32 @@ The offsets of the state save areas in struct kvm_xsave follow the contents
>  of CPUID leaf 0xD on the host.
>  
>  
> +4.135 KVM_S390_PV_CPU_COMMAND
> +-----------------------------
> +
> +:Capability: KVM_CAP_S390_PROTECTED_DUMP
> +:Architectures: s390
> +:Type: vcpu ioctl
> +:Parameters: none
> +:Returns: 0 on success, < 0 on error
> +
> +This ioctl closely mirrors `KVM_S390_PV_COMMAND` but handles requests
> +for vcpus. It re-uses the kvm_s390_pv_dmp struct and hence also shares
> +the command ids.
> +
> +**command:**
> +
> +KVM_PV_DUMP
> +  Presents an API that provides calls which facilitate dumping a vcpu
> +  of a protected VM.
> +
> +**subcommand:**
> +
> +KVM_PV_DUMP_CPU
> +  Provides encrypted dump data like register values.
> +  The length of the returned data is provided by uv_info.guest_cpu_stor_len.
> +
> +
>  5. The kvm_run structure
>  ========================
>  
> @@ -7734,6 +7868,21 @@ At this time, KVM_PMU_CAP_DISABLE is the only capability.  Setting
>  this capability will disable PMU virtualization for that VM.  Usermode
>  should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
>  
> +
> +8.36 KVM_CAP_S390_PROTECTED_DUMP
> +--------------------------------
> +
> +:Capability: KVM_CAP_S390_PROTECTED_DUMP
> +:Architectures: s390
> +:Type: vm
> +
> +This capability indicates that KVM and the Ultravisor support dumping
> +PV guests. The `KVM_PV_DUMP` command is available for the
> +`KVM_S390_PV_COMMAND` ioctl and the `KVM_PV_INFO` command provides
> +dump related UV data. Also the vcpu ioctl `KVM_S390_PV_CPU_COMMAND` is
> +available and supports the `KVM_PV_DUMP_CPU` subcommand.
> +
> +
>  9. Known KVM API problems
>  =========================
>  

