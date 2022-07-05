Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC315677D8
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 21:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbiGETad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 15:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiGETab (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 15:30:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A8212A8A;
        Tue,  5 Jul 2022 12:30:31 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265IiE1B017093;
        Tue, 5 Jul 2022 19:30:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=PIM1WwhuN8aRe8qVHyfkVJIUf5IhuZEm+i9ituMjnlg=;
 b=Sjiov9q+Re4FsbRcqZVEbMXb/NuxVy16E2VmKyuvib88syPapaIEEo2Ng4P+RFCeJl83
 0C9m9wDcMYpLd78Ot6aXdrP5VwmSTHAALDLtIVel9I+Lwf02dxk2ct67JDlai8FqjISx
 C+0aQHOY+DgcUwDcpFmCErMSaIGXyFRNJ5HdtVxfSFp9CeNe4x/GmjJ+igNB9PebwQvS
 OV+5lAVEUh5O9fWjmkphu2/i2ASmgFNXSFceFduOWxkmhXUMGxCB5hvSV/jezzSy23zB
 Wj7TwO9msCQ3dAYUsFXNlmCRIxO1kWVGeD6iy6nWtAgcUu3Ctkoc/6BLTA8BNtfXWn+m FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4rpa4nhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 19:30:30 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 265IjYWp027479;
        Tue, 5 Jul 2022 19:30:30 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4rpa4ngs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 19:30:30 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 265JKOgY022142;
        Tue, 5 Jul 2022 19:30:28 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma05wdc.us.ibm.com with ESMTP id 3h2dn9ckm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 19:30:28 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 265JURGr38338936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Jul 2022 19:30:27 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE899BE054;
        Tue,  5 Jul 2022 19:30:27 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD173BE04F;
        Tue,  5 Jul 2022 19:30:26 +0000 (GMT)
Received: from [9.211.36.1] (unknown [9.211.36.1])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  5 Jul 2022 19:30:26 +0000 (GMT)
Message-ID: <c4062e02-4b35-e130-b653-e467bef2eb4f@linux.ibm.com>
Date:   Tue, 5 Jul 2022 15:30:26 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RFC] kvm: reverse call order of kvm_arch_destroy_vm() and
 kvm_destroy_devices()
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <20220705185430.499688-1-akrowiak@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220705185430.499688-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sepcYs-uNqTNyTxQGRHlNh-P4nbGts0p
X-Proofpoint-ORIG-GUID: j46Grk16PlPR28LzG4Zi-E46Xq_rJScR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_16,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 clxscore=1015 adultscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207050083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/5/22 2:54 PM, Tony Krowiak wrote:
> There is a new requirement for s390 secure execution guests that the
> hypervisor ensures all AP queues are reset and disassociated from the
> KVM guest before the secure configuration is torn down. It is the
> responsibility of the vfio_ap device driver to handle this.
> 
> Prior to commit ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM"),
> the driver reset all AP queues passed through to a KVM guest when notified
> that the KVM pointer was being set to NULL. Subsequently, the AP queues
> are only reset when the fd for the mediated device used to pass the queues
> through to the guest is closed (the vfio_ap_mdev_close_device() callback).
> This is not a problem when userspace is well-behaved and uses the
> KVM_DEV_VFIO_GROUP_DEL attribute to remove the VFIO group; however, if
> userspace for some reason does not close the mdev fd, a secure execution
> guest will tear down its configuration before the AP queues are
> reset because the teardown is done in the kvm_arch_destroy_vm function
> which is invoked prior to vm_destroy_devices.

To clarify, even before "vfio: remove VFIO_GROUP_NOTIFY_SET_KVM" if 
userspace did not delete the group via KVM_DEV_VFIO_GROUP_DEL then the 
old callback would also not have been triggered until 
kvm_destroy_devices() anyway (the callback would have been triggered 
with a NULL kvm pointer via a call from kvm_vfio_destroy(), triggered 
from kvm_destroy_devices()).

My point being: this behavior did not start with "vfio: remove 
VFIO_GROUP_NOTIFY_SET_KVM", that patch just removed the notifier since 
both actions always took place at device open/close time anyway.  So if 
destroying the devices before the vm isn't doable, a new 
notifier/whatever that sets the KVM assocation to NULL would also have 
to happen at an earlier point in time than VFIO_GROUP_NOTIFY_SET_KVM did 
(and should maybe be something that is optional/opt-in and used only by 
vfio drivers that need it to cleanup a KVM association at a point prior 
to the device being destroyed).  There should still be no need for any 
sort of notifier to set the (non-NULL) KVM association as it's already 
associated with the vfio group before device_open.

But let's first see if anyone can shed some understanding on the 
ordering between kvm_arch_destroy_vm and kvm_destroy_devices...

> 
> This patch proposes a simple solution; rather than introducing a new
> notifier into vfio or callback into KVM, what aoubt reversing the order
> in which the kvm_arch_destroy_vm and kvm_destroy_devices are called. In
> some very limited testing (i.e., the automated regression tests for
> the vfio_ap device driver) this did not seem to cause any problems.
> 
> The question remains, is there a good technical reason why the VM
> is destroyed before the devices it is using? This is not intuitive, so
> this is a request for comments on this proposed patch. The assumption
> here is that the medev fd will get closed when the devices are destroyed.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   virt/kvm/kvm_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a49df8988cd6..edaf2918be9b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1248,8 +1248,8 @@ static void kvm_destroy_vm(struct kvm *kvm)
>   #else
>   	kvm_flush_shadow_all(kvm);
>   #endif
> -	kvm_arch_destroy_vm(kvm);
>   	kvm_destroy_devices(kvm);
> +	kvm_arch_destroy_vm(kvm);
>   	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
>   		kvm_free_memslots(kvm, &kvm->__memslots[i][0]);
>   		kvm_free_memslots(kvm, &kvm->__memslots[i][1]);

