Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A682167E809
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 15:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbjA0OUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 09:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbjA0OUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 09:20:07 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CCA7F333;
        Fri, 27 Jan 2023 06:20:06 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RDfmLf028778;
        Fri, 27 Jan 2023 14:20:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=mlc8bOGmiF+UCQlzByWHBk1Tm1LFws7GM4zIMlhHcBI=;
 b=HPjvo50bt7xCTPLidNiL6sxFsDbIyqbLNLxGBJmNWVuaOpBv331PVMa5x+3vPzZanS4u
 AcTBJLG6qmQdKRRahir0msWizqk3vvpiYbUy4cDWI0GkWcF5sIo/MoxLOjViOM+Xc8rM
 NGVx+t2dZ2bH8lzcEQMrGlk0QJ8M6sMeLbqpgJnuNCfPqX6Oip9ehsarJZXWa91YC2mS
 MRTdg4VNLb9QZlVZNYvP/KmmXVmdYa83dXz+XDUP1x7n9/X1FJ7lnOXINNOm+vVdZJJ7
 RpoqkI0MlqiwUSEbpS1Yn0abaTAKFEeloiizm5NM0XxW5cb8Xz9L10jOwOPCtd4JnOLz 6w== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ncfqk95hq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Jan 2023 14:20:05 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30RBJQnc031519;
        Fri, 27 Jan 2023 14:20:03 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3n87p6dg2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Jan 2023 14:20:03 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30REJxlH48038342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 14:19:59 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B80102004B;
        Fri, 27 Jan 2023 14:19:59 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2524B20043;
        Fri, 27 Jan 2023 14:19:59 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.87.61])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
        Fri, 27 Jan 2023 14:19:59 +0000 (GMT)
Date:   Fri, 27 Jan 2023 15:19:57 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v4 1/1] KVM: s390: disable migration mode when dirty
 tracking is disabled
Message-ID: <20230127151957.09a1c0bc@p-imbrenda>
In-Reply-To: <20230127140532.230651-2-nrb@linux.ibm.com>
References: <20230127140532.230651-1-nrb@linux.ibm.com>
        <20230127140532.230651-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: imnW-DO7fkIEdaLfakdOPFYr1jZtfqWu
X-Proofpoint-ORIG-GUID: imnW-DO7fkIEdaLfakdOPFYr1jZtfqWu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_08,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 spamscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301270133
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Jan 2023 15:05:32 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Migration mode is a VM attribute which enables tracking of changes in
> storage attributes (PGSTE). It assumes dirty tracking is enabled on all
> memslots to keep a dirty bitmap of pages with changed storage attributes.
> 
> When enabling migration mode, we currently check that dirty tracking is
> enabled for all memslots. However, userspace can disable dirty tracking
> without disabling migration mode.
> 
> Since migration mode is pointless with dirty tracking disabled, disable
> migration mode whenever userspace disables dirty tracking on any slot.
> 
> Also update the documentation to clarify that dirty tracking must be
> enabled when enabling migration mode, which is already enforced by the
> code in kvm_s390_vm_start_migration().
> 
> Also highlight in the documentation for KVM_S390_GET_CMMA_BITS that it
> can now fail with -EINVAL when dirty tracking is disabled while
> migration mode is on. Move all the error codes to a table to this stays
> readable.
> 
> To disable migration mode, slots_lock should be held, which is taken
> in kvm_set_memory_region() and thus held in
> kvm_arch_prepare_memory_region().
> 
> Restructure the prepare code a bit so all the sanity checking is done
> before disabling migration mode. This ensures migration mode isn't
> disabled when some sanity check fails.
> 
> Cc: stable@vger.kernel.org
> Fixes: 190df4a212a7 ("KVM: s390: CMMA tracking, ESSA emulation, migration mode")
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  Documentation/virt/kvm/api.rst        | 16 ++++++----
>  Documentation/virt/kvm/devices/vm.rst |  4 +++
>  arch/s390/kvm/kvm-s390.c              | 43 +++++++++++++++++++--------
>  3 files changed, 45 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 9807b05a1b57..2978acfcafc4 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4537,11 +4537,17 @@ mask is unused.
>  
>  values points to the userspace buffer where the result will be stored.
>  
> -This ioctl can fail with -ENOMEM if not enough memory can be allocated to
> -complete the task, with -ENXIO if CMMA is not enabled, with -EINVAL if
> -KVM_S390_CMMA_PEEK is not set but migration mode was not enabled, with
> --EFAULT if the userspace address is invalid or if no page table is
> -present for the addresses (e.g. when using hugepages).
> +Errors:
> +
> +  ======     =============================================================
> +  ENOMEM     not enough memory can be allocated to complete the task
> +  ENXIO      if CMMA is not enabled
> +  EINVAL     if KVM_S390_CMMA_PEEK is not set but migration mode was not enabled
> +  EINVAL     if KVM_S390_CMMA_PEEK is not set but dirty tracking has been
> +             disabled (and thus migration mode was automatically disabled)
> +  EFAULT     if the userspace address is invalid or if no page table is
> +             present for the addresses (e.g. when using hugepages).
> +  ======     =============================================================
>  
>  4.108 KVM_S390_SET_CMMA_BITS
>  ----------------------------
> diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
> index 60acc39e0e93..147efec626e5 100644
> --- a/Documentation/virt/kvm/devices/vm.rst
> +++ b/Documentation/virt/kvm/devices/vm.rst
> @@ -302,6 +302,10 @@ Allows userspace to start migration mode, needed for PGSTE migration.
>  Setting this attribute when migration mode is already active will have
>  no effects.
>  
> +Dirty tracking must be enabled on all memslots, else -EINVAL is returned. When
> +dirty tracking is disabled on any memslot, migration mode is automatically
> +stopped.
> +
>  :Parameters: none
>  :Returns:   -ENOMEM if there is not enough free memory to start migration mode;
>  	    -EINVAL if the state of the VM is invalid (e.g. no memory defined);
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index e4890e04b210..cb72f9a09fb3 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -5633,23 +5633,40 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  	if (kvm_s390_pv_get_handle(kvm))
>  		return -EINVAL;
>  
> -	if (change == KVM_MR_DELETE || change == KVM_MR_FLAGS_ONLY)
> -		return 0;
> +	if (change != KVM_MR_DELETE && change != KVM_MR_FLAGS_ONLY) {
> +		/*
> +		 * A few sanity checks. We can have memory slots which have to be
> +		 * located/ended at a segment boundary (1MB). The memory in userland is
> +		 * ok to be fragmented into various different vmas. It is okay to mmap()
> +		 * and munmap() stuff in this slot after doing this call at any time
> +		 */
>  
> -	/* A few sanity checks. We can have memory slots which have to be
> -	   located/ended at a segment boundary (1MB). The memory in userland is
> -	   ok to be fragmented into various different vmas. It is okay to mmap()
> -	   and munmap() stuff in this slot after doing this call at any time */
> +		if (new->userspace_addr & 0xffffful)
> +			return -EINVAL;
>  
> -	if (new->userspace_addr & 0xffffful)
> -		return -EINVAL;
> +		size = new->npages * PAGE_SIZE;
> +		if (size & 0xffffful)
> +			return -EINVAL;
>  
> -	size = new->npages * PAGE_SIZE;
> -	if (size & 0xffffful)
> -		return -EINVAL;
> +		if ((new->base_gfn * PAGE_SIZE) + size > kvm->arch.mem_limit)
> +			return -EINVAL;
> +	}
>  
> -	if ((new->base_gfn * PAGE_SIZE) + size > kvm->arch.mem_limit)
> -		return -EINVAL;
> +	if (!kvm->arch.migration_mode)
> +		return 0;
> +
> +	/*
> +	 * Turn off migration mode when:
> +	 * - userspace creates a new memslot with dirty logging off,
> +	 * - userspace modifies an existing memslot (MOVE or FLAGS_ONLY) and
> +	 *   dirty logging is turned off.
> +	 * Migration mode expects dirty page logging being enabled to store
> +	 * its dirty bitmap.
> +	 */
> +	if (change != KVM_MR_DELETE &&
> +	    !(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
> +		WARN(kvm_s390_vm_stop_migration(kvm),
> +		     "Failed to stop migration mode");
>  
>  	return 0;
>  }

