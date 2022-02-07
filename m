Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1664AC22A
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 15:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348003AbiBGO6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 09:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238673AbiBGOwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 09:52:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB9FC0401C1;
        Mon,  7 Feb 2022 06:52:44 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217EjPuT004111;
        Mon, 7 Feb 2022 14:52:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nSJRveDTKIUQUv2s4+BCEj7qNNSbeUEMunEcVn9C5jE=;
 b=evYVyMHZRKNzdJEEdz/SiJ/qBt79O9BNFRO+HEONURQG7uQ8EjaDAdqRjUKSnrop/zsE
 3O40L4KHfOwWt3Gub7FnfhA4Inh0XRixKgIi+hQVanDix/Px4ci6DyNWYbddiSfWVmfP
 WiuvRlpCLKyug+YMRjlFZWNNaADvv9RaqdbGHi2+CK0pEymyodDWcsBEERFPMfvW4iAK
 aDExKmp+7fj45xFZhdyaBBjz9RZm9LDnyaTaK7jsCvOqLvnwFtiIiwyTb481XNQk1rxd
 JgqexNpoId8HGuRTG/SF5CgitTiZRezIdsVm1IdDO1FvojucoT0E2TRzWqnaU5egBSdd 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e1hux9mbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 14:52:43 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217EjaOJ005493;
        Mon, 7 Feb 2022 14:52:43 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e1hux9maw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 14:52:42 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217Elx1J016384;
        Mon, 7 Feb 2022 14:52:41 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3e1ggjnw4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 14:52:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217EqbJn45875668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 14:52:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0B224204C;
        Mon,  7 Feb 2022 14:52:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70D534204B;
        Mon,  7 Feb 2022 14:52:37 +0000 (GMT)
Received: from [9.145.9.42] (unknown [9.145.9.42])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 14:52:37 +0000 (GMT)
Message-ID: <99296cad-5f74-d9ab-544c-b2d1a557b226@linux.ibm.com>
Date:   Mon, 7 Feb 2022 15:52:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v7 15/17] KVM: s390: pv: api documentation for
 asynchronous destroy
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
 <20220204155349.63238-16-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220204155349.63238-16-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cjmHCR0RFcQrOz_yfzusQWe8kMgjPWdz
X-Proofpoint-GUID: ZrwNAgYQPUCXLFQTasoH-UqwAL_mFLz4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_05,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/22 16:53, Claudio Imbrenda wrote:
> Add documentation for the new commands added to the KVM_S390_PV_COMMAND
> ioctl.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   Documentation/virt/kvm/api.rst | 21 ++++++++++++++++++---
>   1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index a4267104db50..3b9068aceead 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5010,11 +5010,13 @@ KVM_PV_ENABLE
>     =====      =============================
>   
>   KVM_PV_DISABLE
> -
>     Deregister the VM from the Ultravisor and reclaim the memory that
>     had been donated to the Ultravisor, making it usable by the kernel
> -  again.  All registered VCPUs are converted back to non-protected
> -  ones.
> +  again. All registered VCPUs are converted back to non-protected
> +  ones. If a previous VM had been prepared for asynchonous teardown
> +  with KVM_PV_ASYNC_DISABLE_PREPARE and not actually torn down with
> +  KVM_PV_ASYNC_DISABLE, it will be torn down in this call together with
> +  the current VM.
>   
>   KVM_PV_VM_SET_SEC_PARMS
>     Pass the image header from VM memory to the Ultravisor in
> @@ -5027,6 +5029,19 @@ KVM_PV_VM_VERIFY
>     Verify the integrity of the unpacked image. Only if this succeeds,
>     KVM is allowed to start protected VCPUs.
>   
> +KVM_PV_ASYNC_DISABLE_PREPARE
> +  Prepare the current protected VM for asynchronous teardown. The current

I think the first sentence needs a few more examples of what we do so 
the second sentence makes more sense.

...by setting aside the pointers to the donated storage, replacing the 
top most page table, destroying the first 2GB of memory and zeroing the 
KVM PV structs.


Or something which sounds a bit nicer.

> +  VM will then continue immediately as non-protected. If a protected VM had
> +  already been set aside without starting the teardown process, this call
> +  will fail. In this case the userspace process should issue a normal
> +  KVM_PV_DISABLE.
> +
> +KVM_PV_ASYNC_DISABLE
> +  Tear down the protected VM previously set aside for asynchronous teardown.
> +  This PV command should ideally be issued by userspace from a separate
> +  thread. If a fatal signal is received (or the process terminates
> +  naturally), the command will terminate immediately without completing.
> +
>   4.126 KVM_X86_SET_MSR_FILTER
>   ----------------------------
>   
> 

