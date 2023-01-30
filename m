Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC776809F4
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 10:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbjA3Jxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 04:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjA3Jxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 04:53:40 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8613A8A;
        Mon, 30 Jan 2023 01:53:31 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30U7noDN016627;
        Mon, 30 Jan 2023 09:53:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Q6SDjkiCSCiwdHSFsmnoXdWBpQuwnV3B246Iw9YeFcQ=;
 b=DACaR3O0ADWBNyILxH+FTmN0ZCSzOrqHLZ1cwD5PNCpj3is2FrLZduJIGS7bz4AQmS1m
 KlYqu9Fo1qJjCRhdcAYwuEGwun+mpnxxMsUHS5d9tUEp6Q/mh6p21jfKxjdEsLyabikt
 DKrrnoUMWXzd3pJCjf49bpkxn5Vh9QtPCGSvXjcsVYSpy39StkBLDZzwO51vu0HZ0G9K
 fc8vww2xO5DUr2qPqojDMTM2/7hQgSLYjaFErh5/ttUUGbP8j7NCj8/jK8nCLDeD5L1d
 F8xh3YXQAJAgtleJQ+QdQp9pqIB8xiigdwR46etjov8JJP0xTJujA92+mH6sfJFRNZdK cQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ne9uhjv90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Jan 2023 09:53:30 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30U517xv014735;
        Mon, 30 Jan 2023 09:53:28 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ncvttt1uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Jan 2023 09:53:27 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30U9rOPc21824220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Jan 2023 09:53:24 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 584F22004B;
        Mon, 30 Jan 2023 09:53:24 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 115BA20040;
        Mon, 30 Jan 2023 09:53:24 +0000 (GMT)
Received: from [9.171.8.15] (unknown [9.171.8.15])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 30 Jan 2023 09:53:23 +0000 (GMT)
Message-ID: <6e37979d-45f2-0714-d1ab-673f64cdd872@linux.ibm.com>
Date:   Mon, 30 Jan 2023 10:53:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230127140532.230651-1-nrb@linux.ibm.com>
 <20230127140532.230651-2-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v4 1/1] KVM: s390: disable migration mode when dirty
 tracking is disabled
In-Reply-To: <20230127140532.230651-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XNN6Kdlq3qhLK8ZkJ8C-I9rpaIM-EF_1
X-Proofpoint-ORIG-GUID: XNN6Kdlq3qhLK8ZkJ8C-I9rpaIM-EF_1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-30_07,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 malwarescore=0 mlxscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301300091
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/27/23 15:05, Nico Boehr wrote:
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

s/to/so/

I'll fix that up when picking.

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

Good find:
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   Documentation/virt/kvm/api.rst        | 16 ++++++----
>   Documentation/virt/kvm/devices/vm.rst |  4 +++
>   arch/s390/kvm/kvm-s390.c              | 43 +++++++++++++++++++--------
>   3 files changed, 45 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 9807b05a1b57..2978acfcafc4 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4537,11 +4537,17 @@ mask is unused.
>   
>   values points to the userspace buffer where the result will be stored.
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

May I move this to the top?

