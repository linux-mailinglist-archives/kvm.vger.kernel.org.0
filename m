Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36D35F47F7
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 18:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiJDQ4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 12:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiJDQ4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 12:56:47 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCEA4F18E;
        Tue,  4 Oct 2022 09:56:46 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 294Ff6XC032508;
        Tue, 4 Oct 2022 16:56:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=LkwrrBcdblhxFyd7y6h+xKEQA6QuoUrdGopnZa0rDDs=;
 b=e7aqOJGSMITS1nqDZITLjAu/0C7MKxk9esYgCT20o6vvtJhejYyvwXnbG3tRVUaSJYaI
 lCNjkhuhxDihTwZchcgJeW6sPkxwRWEWmIyBudNz3eOjb9oWouNwChgG8aT3150sljP1
 1+HIxx35RxhbcVHeqBr4WknYLB5cBYFArAmPTwIuNCAlArYaNkpZSthfrTm9lQPNCrmm
 UcTErVomnbaSSePSI3xJRgbGSX80SsLjo7Fke66FiyLQBzZ38kz2dMPbVswwJ/7FWB+a
 cn0Rel3e/bG37JPLmqT/KxEi1Kz+hOcTPxmOf82Emz+uEo5nbYRoY1J52Sf2vNC50aVL Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0gu2q5kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 16:56:44 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 294DvrPD001276;
        Tue, 4 Oct 2022 16:56:43 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0gu2q5ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 16:56:43 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 294GqSrq006264;
        Tue, 4 Oct 2022 16:56:42 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3jxd68u930-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 16:56:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 294GuXrl66781572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Oct 2022 16:56:33 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CA8E42042;
        Tue,  4 Oct 2022 16:56:33 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA0074203F;
        Tue,  4 Oct 2022 16:56:32 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.134])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Oct 2022 16:56:32 +0000 (GMT)
Date:   Tue, 4 Oct 2022 18:56:30 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Steffen Eiden <seiden@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v14 1/6] KVM: s390: pv: asynchronous destroy for reboot
Message-ID: <20221004185630.6d9dd164@p-imbrenda>
In-Reply-To: <0cd04469-d840-0cc7-8faf-8f07aa2dd876@linux.ibm.com>
References: <20220930140150.37463-1-imbrenda@linux.ibm.com>
        <20220930140150.37463-2-imbrenda@linux.ibm.com>
        <0cd04469-d840-0cc7-8faf-8f07aa2dd876@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UA7uXzYRf6cug5Cir-vHWFEcdXsNJP4w
X-Proofpoint-GUID: ITDYFgL-IXqFJAMBZ8V32Y6v3DlGWBlg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_06,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 malwarescore=0 clxscore=1015
 adultscore=0 priorityscore=1501 suspectscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210040107
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Oct 2022 15:43:29 +0200
Steffen Eiden <seiden@linux.ibm.com> wrote:

> Hi Claudio,
> 
> LGTM, but I have some nits.

[...]

> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index b7ef0b71014d..d0027964a6f5 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -209,6 +209,8 @@ unsigned int diag9c_forwarding_hz;
> >   module_param(diag9c_forwarding_hz, uint, 0644);
> >   MODULE_PARM_DESC(diag9c_forwarding_hz, "Maximum diag9c forwarding per second, 0 to turn off");
> >  
> 
> IMO it would be better to initialize this variable explicitly here.

and that's how it was a few versions ago, but

> You do this later in patch [6/6].
> Whats the reason to do this not at this point.

Janosch asked to split it this way :)

> 
> 
> > +static int async_destroy;
> > +
> >   /*
> >    * For now we handle at most 16 double words as this is what the s390 base
> >    * kernel handles and stores in the prefix page. If we ever need to go beyond
> > @@ -2504,9 +2506,13 @@ static int kvm_s390_pv_dmp(struct kvm *kvm, struct kvm_pv_cmd *cmd,
> >   
> >   static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
> >   {
> > +	const bool needslock = (cmd->cmd != KVM_PV_ASYNC_CLEANUP_PERFORM);  
> `need_lock` ? or just `lock` ?

hmm, maybe need_lock 

> > +	void __user *argp = (void __user *)cmd->data;
> >   	int r = 0;
> >   	u16 dummy;
> > -	void __user *argp = (void __user *)cmd->data;
> > +
> > +	if (needslock)
> > +		mutex_lock(&kvm->lock);
> >   
> >   	switch (cmd->cmd) {
> >   	case KVM_PV_ENABLE: {
> > @@ -2540,6 +2546,31 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
> >   		set_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
> >   		break;
> >   	}

[...]

> > -/* this should not fail, but if it does, we must not free the donated memory */
> > -int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
> > +/**
> > + * kvm_s390_pv_dispose_one_leftover - Clean up one leftover protected VM.
> > + * @kvm: the KVM that was associated with this leftover protected VM
> > + * @leftover: details about the leftover protected VM that needs a clean up
> > + * @rc: the RC code of the Destroy Secure Configuration UVC
> > + * @rrc: the RRC code of the Destroy Secure Configuration UVC
> > + *
> > + * Destroy one leftover protected VM.
> > + * On success, kvm->mm->context.protected_count will be decremented atomically
> > + * and all other resources used by the VM will be freed.
> > + *
> > + * Return: 0 in case of success, otherwise 1
> > + */
> > +static int kvm_s390_pv_dispose_one_leftover(struct kvm *kvm,
> > +					    struct pv_vm_to_be_destroyed *leftover,
> > +					    u16 *rc, u16 *rrc)
> >   {
> >   	int cc;
> >   
> > -	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
> > -			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
> > -	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
> > +	cc = uv_cmd_nodata(leftover->handle, UVC_CMD_DESTROY_SEC_CONF, rc, rrc); > +	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY LEFTOVER VM: rc %x rrc %x",   
> *rc, *rrc);
> > +	WARN_ONCE(cc, "protvirt destroy leftover vm failed rc %x rrc %x", *rc, *rrc);
> > +	if (cc)
> > +		return cc;  
> maybe set the handle to zero here to be extra sure.
> `leftover` will get free'd directly after this function,
> but that might change and I assume we do not want to end up with

I don't see a reason why it should change.

> invalid handles hanging arround.
> >   	/*
> > -	 * if the mm still has a mapping, make all its pages accessible
> > -	 * before destroying the guest
> > +	 * Intentionally leak unusable memory. If the UVC fails, the memory
> > +	 * used for the VM and its metadata is permanently unusable.
> > +	 * This can only happen in case of a serious KVM or hardware bug; it
> > +	 * is not expected to happen in normal operation.
> >   	 */
> > -	if (mmget_not_zero(kvm->mm)) {
> > -		s390_uv_destroy_range(kvm->mm, 0, TASK_SIZE);
> > -		mmput(kvm->mm);
> > +	free_pages(leftover->stor_base, get_order(uv_info.guest_base_stor_len));
> > +	free_pages(leftover->old_gmap_table, CRST_ALLOC_ORDER);
> > +	vfree(leftover->stor_var);
> > +	atomic_dec(&kvm->mm->context.protected_count);
> > +	return 0;
> > +}

[...]

> > +	/* Cleanup all protected VMs in the need_cleanup list */
> > +	while (!list_empty(&kvm->arch.pv.need_cleanup)) {
> > +		cur = list_first_entry(&kvm->arch.pv.need_cleanup, typeof(*cur), list);
> > +		need_zap = true;
> > +		if (kvm_s390_pv_dispose_one_leftover(kvm, cur, &_rc, &_rrc)) {
> > +			cc = 1;
> > +			/* do not overwrite a previous error code */  
> use UVC_RC_EXECUTED

will fix

> > +			if (*rc == 1) {
> > +				*rc = _rc;
> > +				*rrc = _rrc;
> > +			}
> > +		}
> > +		list_del(&cur->list);
> > +		kfree(cur);
> > +	}
> > +
> > +	/*
> > +	 * If the mm still has a mapping, try to mark all its pages as
> > +	 * accessible. The counter should not reach zero before this
> > +	 * cleanup has been performed.
> > +	 */
> > +	if (need_zap && mmget_not_zero(kvm->mm)) {
> > +		s390_uv_destroy_range(kvm->mm, 0, TASK_SIZE);
> > +		mmput(kvm->mm);
> > +	}
> > +
> > +	/* Now the counter can safely reach 0 */
> > +	atomic_dec(&kvm->mm->context.protected_count);
> > +	return cc ? -EIO : 0;
> > +}
> > +
> > +/**
> > + * kvm_s390_pv_deinit_aside_vm - Teardown a previously set aside protected VM.
> > + * @kvm the VM previously associated with the protected VM
> > + * @rc return value for the RC field of the UVCB
> > + * @rrc return value for the RRC field of the UVCB
> > + *
> > + * Tear down the protected VM that had been previously prepared for teardown
> > + * using kvm_s390_pv_set_aside_vm. Ideally this should be called by
> > + * userspace asynchronously from a separate thread.
> > + *
> > + * Context: kvm->lock must not be held.
> > + *
> > + * Return: 0 in case of success, -EINVAL if no protected VM had been
> > + * prepared for asynchronous teardowm, -EIO in case of other errors.
> > + */
> > +int kvm_s390_pv_deinit_aside_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
> > +{
> > +	struct pv_vm_to_be_destroyed *p;
> > +	int ret = 0;
> > +
> > +	lockdep_assert_not_held(&kvm->lock);
> > +	mutex_lock(&kvm->lock);
> > +	p = kvm->arch.pv.set_aside;
> > +	kvm->arch.pv.set_aside = NULL;
> > +	mutex_unlock(&kvm->lock);
> > +	if (!p)
> > +		return -EINVAL;
> > +
> > +	/* When a fatal signal is received, stop immediately */
> > +	if (s390_uv_destroy_range_interruptible(kvm->mm, 0, TASK_SIZE_MAX))
> > +		goto done;
> > +	if (kvm_s390_pv_dispose_one_leftover(kvm, p, rc, rrc))
> > +		ret = -EIO;
> > +	kfree(p);
> > +	p = NULL;
> > +done:
> > +	/*
> > +	 * p is not NULL if we aborted because of a fatal signal, in which
> > +	 * case queue the leftover for later cleanup.
> > +	 */
> > +	if (p) {
> > +		mutex_lock(&kvm->lock);
> > +		list_add(&p->list, &kvm->arch.pv.need_cleanup);
> > +		mutex_unlock(&kvm->lock);
> > +		/* Did not finish, but pretend things went well */  
> use UVC_RC_EXECUTED

will fix as well

> > +		*rc = 1;
> > +		*rrc = 42;
> > +	}
> > +	return ret;
> > +}
> > +
> >   static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
> >   					     struct mm_struct *mm)
> >   {
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index eed0315a77a6..02602c5c1975 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1739,6 +1739,8 @@ enum pv_cmd_id {
> >   	KVM_PV_UNSHARE_ALL,
> >   	KVM_PV_INFO,
> >   	KVM_PV_DUMP,
> > +	KVM_PV_ASYNC_CLEANUP_PREPARE,
> > +	KVM_PV_ASYNC_CLEANUP_PERFORM,
> >   };
> >   
> >   struct kvm_pv_cmd {  

