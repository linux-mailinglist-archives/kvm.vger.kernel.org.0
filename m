Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A94358695F
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 14:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbiHAMCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 08:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbiHAMBA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 08:01:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF8F422FC;
        Mon,  1 Aug 2022 04:53:19 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271AU9kp014383;
        Mon, 1 Aug 2022 11:53:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=npf87nrRLauTXOjE1KjwTqYrLIz29i8Z9iga6c6Re8c=;
 b=ZtPjeuzcdjjE7uZTuKwlRQ8jOy7gfZEdMvRdlNFotqVSNmd1IaIUW+3jnGYde4lK0tDC
 I8qn9o/SYyIhCO6UFHGo85Wkoppy2aSvStvRF7VZfilvtZptVXn+XxJIZWX23cfSkYYF
 tDDlYKJpjlSSYHg8pJ1Hd0ODqZytmmiu5rOg9ZC/iFKWsc102foQSqmtLOszKkLqf8lK
 p7QKTpziRU5tighyZdM4cLGrpO+Sedr/9Ovg5qtmJmnqbJITNsM8+caADq/U3ZNkGLLp
 dJqkSOBaHtyX2AwNpaHEQEgw9bqKKHL8o+HA4sz/N3jihFEZ6eh33QCBE0uHgOTxxofA vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hpb60wq5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Aug 2022 11:53:18 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 271BmlHo007318;
        Mon, 1 Aug 2022 11:53:17 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hpb60wq51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Aug 2022 11:53:17 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 271Bpg0q011696;
        Mon, 1 Aug 2022 11:53:15 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3hmv98hkgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Aug 2022 11:53:15 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 271BrCjY22806990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Aug 2022 11:53:12 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 371A0AE04D;
        Mon,  1 Aug 2022 11:53:12 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6D14AE045;
        Mon,  1 Aug 2022 11:53:11 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.152.224.212])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  1 Aug 2022 11:53:11 +0000 (GMT)
Date:   Mon, 1 Aug 2022 13:53:10 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Anthony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com, pbonzini@redhat.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [RFC] kvm: reverse call order of kvm_arch_destroy_vm() and
 kvm_destroy_devices()
Message-ID: <20220801135310.62c34c63.pasic@linux.ibm.com>
In-Reply-To: <647bfead-5d7c-1cb1-3bf2-235ae0205310@linux.ibm.com>
References: <20220705185430.499688-1-akrowiak@linux.ibm.com>
 <647bfead-5d7c-1cb1-3bf2-235ae0205310@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qOwdElEJdp6JAbGJRM3WGOWAK0HxzWF1
X-Proofpoint-GUID: mFCTaeSN8DF3RBCg-C_YQgAvFOzGUFJu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_05,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 impostorscore=0 phishscore=0 clxscore=1011 suspectscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208010057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Jul 2022 15:00:02 -0400
Anthony Krowiak <akrowiak@linux.ibm.com> wrote:

> Any Takers??????
> 
> On 7/5/22 2:54 PM, Tony Krowiak wrote:
> > There is a new requirement for s390 secure execution guests that the
> > hypervisor ensures all AP queues are reset and disassociated from the
> > KVM guest before the secure configuration is torn down. It is the
> > responsibility of the vfio_ap device driver to handle this.
> >
> > Prior to commit ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM"),
> > the driver reset all AP queues passed through to a KVM guest when notified
> > that the KVM pointer was being set to NULL. Subsequently, the AP queues
> > are only reset when the fd for the mediated device used to pass the queues
> > through to the guest is closed (the vfio_ap_mdev_close_device() callback).
> > This is not a problem when userspace is well-behaved and uses the
> > KVM_DEV_VFIO_GROUP_DEL attribute to remove the VFIO group; however, if
> > userspace for some reason does not close the mdev fd, a secure execution
> > guest will tear down its configuration before the AP queues are
> > reset because the teardown is done in the kvm_arch_destroy_vm function
> > which is invoked prior to kvm_destroy_devices.

As Matt has pointed out: we did not have the guarantee we need prior
that commit. Please for the next version drop the digression about
the old behavior.

> >
> > This patch proposes a simple solution; rather than introducing a new
> > notifier into vfio or callback into KVM, what aoubt reversing the order
> > in which the kvm_arch_destroy_vm and kvm_destroy_devices are called. In
> > some very limited testing (i.e., the automated regression tests for
> > the vfio_ap device driver) this did not seem to cause any problems.
> >
> > The question remains, is there a good technical reason why the VM
> > is destroyed before the devices it is using? This is not intuitive, so
> > this is a request for comments on this proposed patch. The assumption
> > here is that the medev fd will get closed when the devices are destroyed.

I did some digging! The function and the corresponding mechanism was
introduced by  07f0a7bdec5c ("kvm: destroy emulated devices on VM
exit"). Before that patch we used to have ref-counting, and the refcound
got decremented in kvmppc_mpic_disconnect_vcpu() which in turn was
called by kvm_arch_vcpu_free(). So this was basically arch specific
stuff. For power (the patch came form power) the refcount was decremented
before calling kvmppc_core_vcpu_free(). So I conclude the old scheme
would have worked for us.

Since the patch does not state any technical reasons, my guess is, that
the choice was made somewhat arbitrarily under the assumption, that
there is no requirements or dependency with regards to the destruction
of devices or with regards towards severing the connection between
the devices and the VM. Under these assumptions the placement of
the invocation of kvm_destroy_devices after kvm_arch_destroy_vm()
did made sense, because if something that is destroyed in destroy_vm()
did hold a live reference to the device, this reference will be cleaned
up before kvm_destroy_devices() is invoked. So basically unless the
devices hold references to each other, things look good. If the
positions of  kvm_arch_destroy_vm() and kvm_destroy_devices() are
changed, then we basically need to assume that nothing that is destroyed
in kvm_arch_destoy_vm() may logically hold a live reference (remember
the refcount is gone, but pointers may still exist) to a kvm device.
Does that hold? @Antony, maybe you can answer this question for us...
Otherwise I will continue the digging from here, eventually.

Also I have concerns about the following comments:

static void kvm_destroy_devices(struct kvm *kvm)                                
{                                                                               
        struct kvm_device *dev, *tmp;                                           
                                                                                
        /*                                                                      
         * We do not need to take the kvm->lock here, because nobody else       
         * has a reference to the struct kvm at this point and therefore        
         * cannot access the devices list anyhow.  
[..]

Would this till hold when the order is changed?

struct kvm_device_ops { 
[..]
        /*                                                                      
         * Destroy is responsible for freeing dev.                              
         *                                                                      
         * Destroy may be called before or after destructors are called         
         * on emulated I/O regions, depending on whether a reference is         
         * held by a vcpu or other kvm component that gets destroyed            
         * after the emulated I/O.                                              
         */                                                                     
        void (*destroy)(struct kvm_device *dev);  

This seems to document the order of things as is.

Btw I would like to understand more about the lifecycle of these
emulated I/O regions....

@Paolo: I believe this is ultimately your truff. I'm just digging
through the code, and the history to try to help along with this. We
definitely need a solution for our problem. We would very much appreciate
having your opinion!

Regards,
Halil

> >
> > Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> > ---
> >   virt/kvm/kvm_main.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index a49df8988cd6..edaf2918be9b 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1248,8 +1248,8 @@ static void kvm_destroy_vm(struct kvm *kvm)
> >   #else
> >   	kvm_flush_shadow_all(kvm);
> >   #endif
> > -	kvm_arch_destroy_vm(kvm);
> >   	kvm_destroy_devices(kvm);
> > +	kvm_arch_destroy_vm(kvm);
> >   	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> >   		kvm_free_memslots(kvm, &kvm->__memslots[i][0]);
> >   		kvm_free_memslots(kvm, &kvm->__memslots[i][1]);  

