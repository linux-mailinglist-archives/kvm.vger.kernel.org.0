Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2345998FC
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 11:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348177AbiHSJjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 05:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348169AbiHSJi7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 05:38:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26765072F;
        Fri, 19 Aug 2022 02:38:49 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27J9VXAf018880;
        Fri, 19 Aug 2022 09:38:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=k0s98wbwykj1h/+dscgayMBTy/dgtVTdsqH1ZecErf4=;
 b=PD2WQD4HGKMjkndoiaPMdkkkwu61TgmMuMftS1rZCTqZIOybi9v1IGNKJq+uSOw9Ow9F
 nWJ9bPerhqkVc6iT4YCOg3IwU7lBnFquNiFSeEoKjNrgLiwajmY9SWPaXYAjgkqhU7vW
 41lqRGi4/ORclKnREg3eTdNz+NVOpsCk8WG62gUtoJWY8aK0GwoCflW+Jf+l6gIBDDfD
 4KvIzfblAWmqpRDh8sZPRPv08YiM/Kg7qPYJ3cOEeruIKYph5Is29DNevDrqNQqtgN/s
 xmvAYasOi6Cl9/PWqfhklmSWH9KDS3tGCqi1NKFEPby60uPsXlVNlqbKaLyyP5XswDKF ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j27ycg55y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 09:38:49 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27J9VYOf018941;
        Fri, 19 Aug 2022 09:38:48 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j27ycg54h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 09:38:48 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27J9LD5F013229;
        Fri, 19 Aug 2022 09:33:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3hx37jf2ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 09:33:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27J9XhZQ31654398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 09:33:43 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF2FF52052;
        Fri, 19 Aug 2022 09:33:42 +0000 (GMT)
Received: from [9.145.49.220] (unknown [9.145.49.220])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 74BA95204F;
        Fri, 19 Aug 2022 09:33:42 +0000 (GMT)
Message-ID: <721557f7-93eb-a26b-76a6-f207d05a5d0d@linux.ibm.com>
Date:   Fri, 19 Aug 2022 11:33:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220810125625.45295-1-imbrenda@linux.ibm.com>
 <20220810125625.45295-3-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v13 2/6] KVM: s390: pv: api documentation for asynchronous
 destroy
In-Reply-To: <20220810125625.45295-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RuVUvDs38Fq8BFcgQ-JqIRUjwzI73qQf
X-Proofpoint-ORIG-GUID: 81wAyy220UPC_7vbqRFC6ffzl5-0VOMk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_04,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 phishscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208190037
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/22 14:56, Claudio Imbrenda wrote:
> Add documentation for the new commands added to the KVM_S390_PV_COMMAND
> ioctl.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   Documentation/virt/kvm/api.rst | 30 ++++++++++++++++++++++++++++--
>   1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 9788b19f9ff7..5bd151b601b4 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5163,8 +5163,11 @@ KVM_PV_ENABLE
>   KVM_PV_DISABLE
>     Deregister the VM from the Ultravisor and reclaim the memory that
>     had been donated to the Ultravisor, making it usable by the kernel
> -  again.  All registered VCPUs are converted back to non-protected
> -  ones.
> +  again. All registered VCPUs are converted back to non-protected
> +  ones. If a previous VM had been set aside for asynchonous teardown
> +  with KVM_PV_ASYNC_CLEANUP_PREPARE and not actually torn down with

...and hasn't yet been torn down with...

> +  KVM_PV_ASYNC_CLEANUP_PERFORM, it will be torn down in this call
> +  together with the current VM.

current PV VM? or protected VM
I know it's missing in the unchanged paragraph above too but such is life.

>   
>   KVM_PV_VM_SET_SEC_PARMS
>     Pass the image header from VM memory to the Ultravisor in
> @@ -5287,6 +5290,29 @@ KVM_PV_DUMP
>       authentication tag all of which are needed to decrypt the dump at a
>       later time.
>   
> +KVM_PV_ASYNC_CLEANUP_PREPARE
> +  Prepare the current protected VM for asynchronous teardown. Most
> +  resources used by the current protected VM will be set aside for a
> +  subsequent asynchronous teardown. The current protected VM will then
> +  resume execution immediately as non-protected. There can be at most
> +  one protected VM set aside at any time. If a protected VM had
> +  already been set aside without starting the asynchronous teardown
> +  process, this call will fail. In that case, the userspace process

If KVM_PV_ASYNC_CLEANUP_PREPARE has already been called without a 
successful KVM_PV_ASYNC_CLEANUP_PERFORM this call will fail. I.e. only 
be one PV VM can be set aside.

Do we need to finish the cleanup or is it enough to start the cleanup 
like you describe here?

> +  should issue a normal KVM_PV_DISABLE. The resources set aside with
> +  this call will need to be cleaned up with a subsequent call to
> +  KVM_PV_ASYNC_CLEANUP_PERFORM or KVM_PV_DISABLE, otherwise they will
> +  be cleaned up when KVM terminates.
> +
> +KVM_PV_ASYNC_CLEANUP_PERFORM
> +  Tear down the protected VM previously set aside with
> +  KVM_PV_ASYNC_CLEANUP_PREPARE. The resources that had been set aside
> +  will be freed during the execution of this command. This PV command
> +  should ideally be issued by userspace from a separate thread. If a
> +  fatal signal is received (or the process terminates naturally), the
> +  command will terminate immediately without completing, and the normal
> +  KVM shutdown procedure will take care of cleaning up all remaining
> +  protected VMs.
> +
>   
>   4.126 KVM_X86_SET_MSR_FILTER
>   ----------------------------

