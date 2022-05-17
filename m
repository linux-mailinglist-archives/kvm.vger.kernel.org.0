Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064E752A418
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 16:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348220AbiEQOCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 10:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243926AbiEQOCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 10:02:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D785535846;
        Tue, 17 May 2022 07:02:11 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HDs3D0027686;
        Tue, 17 May 2022 14:02:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=VHxeDu7C4s1ScjOUw2ak878irClVRvC9FAs7n2oF/0s=;
 b=emTB6f7p7XHqwkYos8gwaVeEMEK3bIW4Ck4zVtwakgCqzjmmx2pKW+4diVIXRkhzVVsn
 u/zhrDiRuAnhOK0yf4tCto4m+FzjFDGvxbEgqyS8MGE/+Ef6Ox+plH57XkiPkGYwTzlE
 sGamZa1Gb4h5QxIIbqw/sBYSCTnPB5z3yXxHEC/BiEASFxAw/I1CaNVP6ZznSZpbAeH9
 17jUMeP+UGOOTx2Kkqg9Jt9n2sS0dnM+NFnYnluNGCQ6rqQ4cz35oTmwumqkiyCMu/FB
 xp3VnHRs/7njpgum3UEq6JVUQhKEep1jK/t2uxW/y3siB/C45a9NO5gAEA2TqQ27nwDH Bg== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4d0e869e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 14:02:10 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HDwiKv023143;
        Tue, 17 May 2022 14:02:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3g24293epa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 14:02:08 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HE258W58130810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 14:02:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85ED911C052;
        Tue, 17 May 2022 14:02:05 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5717E11C058;
        Tue, 17 May 2022 14:02:05 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 14:02:05 +0000 (GMT)
Date:   Tue, 17 May 2022 16:02:03 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH v5 06/10] kvm: s390: Add configuration dump
 functionality
Message-ID: <20220517160203.1b907246@p-imbrenda>
In-Reply-To: <f8132cf7-9249-75b8-059d-fa1031973beb@linux.ibm.com>
References: <20220516090817.1110090-1-frankja@linux.ibm.com>
        <20220516090817.1110090-7-frankja@linux.ibm.com>
        <20220517125907.685ffe44@p-imbrenda>
        <f8132cf7-9249-75b8-059d-fa1031973beb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YIxAMWgiagAkdqJslgjyYVvrnTkg6gL-
X-Proofpoint-ORIG-GUID: YIxAMWgiagAkdqJslgjyYVvrnTkg6gL-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 May 2022 15:39:14 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 5/17/22 12:59, Claudio Imbrenda wrote:
> > On Mon, 16 May 2022 09:08:13 +0000
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >   
> >> Sometimes dumping inside of a VM fails, is unavailable or doesn't
> >> yield the required data. For these occasions we dump the VM from the
> >> outside, writing memory and cpu data to a file.
> >>
> >> Up to now PV guests only supported dumping from the inside of the
> >> guest through dumpers like KDUMP. A PV guest can be dumped from the
> >> hypervisor but the data will be stale and / or encrypted.
> >>
> >> To get the actual state of the PV VM we need the help of the
> >> Ultravisor who safeguards the VM state. New UV calls have been added
> >> to initialize the dump, dump storage state data, dump cpu data and
> >> complete the dump process. We expose these calls in this patch via a
> >> new UV ioctl command.
> >>
> >> The sensitive parts of the dump data are encrypted, the dump key is
> >> derived from the Customer Communication Key (CCK). This ensures that
> >> only the owner of the VM who has the CCK can decrypt the dump data.
> >>
> >> The memory is dumped / read via a normal export call and a re-import
> >> after the dump initialization is not needed (no re-encryption with a
> >> dump key).
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>  
> 
> The cut code will be fixed according to your requests.
> 
> [...]
> >> +/*

/**

> >> + * kvm_s390_pv_dump_stor_state
> >> + *
> >> + * @kvm: pointer to the guest's KVM struct
> >> + * @buff_user: Userspace pointer where we will write the results to
> >> + * @gaddr: Starting absolute guest address for which the storage state
> >> + *         is requested. This value will be updated with the last
> >> + *         address for which data was written when returning to
> >> + *         userspace.
> >> + * @buff_user_len: Length of the buff_user buffer
> >> + * @rc: Pointer to where the uvcb return code is stored
> >> + * @rrc: Pointer to where the uvcb return reason code is stored
> >> + *  
> > 
> > please add:
> > 	Context: kvm->lock needs to be held  
> 
> Sure
> 
> > 
> > also explain that part of the user buffer might be written to even in
> > case of failure (this also needs to go in the documentation)  
> 
> Ok
> 
> >   
> >> + * Return:
> >> + *  0 on success  
> > 
> > rc and rrc will also be set in case of success  
> 
> But that's different from the return code of this function and would 
> belong to the function description above, no?

yes

> 
> >   
> >> + *  -ENOMEM if allocating the cache fails
> >> + *  -EINVAL if gaddr is not aligned to 1MB
> >> + *  -EINVAL if buff_user_len is not aligned to uv_info.conf_dump_storage_state_len
> >> + *  -EINVAL if the UV call fails, rc and rrc will be set in this case  
> > 
> > have you considered a different code for UVC failure?
> > so the caller can know that rc and rrc are meaningful
> > 
> > or just explain that rc and rrc will always be set; if the UVC is not
> > performed, rc and rrc will be 0  
> 
> If the UVC is not performed the rcs will not be *changed*, so it's 
> advisable to set them to 0 to recognize a change.

ah, right, you jump to out only for errors after the allocation

> 
> 
> Also:
> While I generally like commenting as much as possible, this is starting 
> to get out of hand, the comment header is now taking up a lot of space. 
> I'll put the rc/rrc comment into the api documentation and I'm 
> considering putting the partial write comment into there too.

I don't know, the comments are also used to generate documentation
automatically, so I think they should contain all the information in
one way or the other.

I don't see issues with huge comments, if the function is complex and
has lots of parameters and possible return values.

as much as it bothers you, the whole comment block has 0 lines of actual
description of what the function does, so I don't think this is getting
out of hand :)

> 
> >   
> >> + *  -EFAULT if copying the result to buff_user failed
> >> + */
> >> +int kvm_s390_pv_dump_stor_state(struct kvm *kvm, void __user *buff_user,
> >> +				u64 *gaddr, u64 buff_user_len, u16 *rc, u16 *rrc)
> >> +{
> >> +	struct uv_cb_dump_stor_state uvcb = {
> >> +		.header.cmd = UVC_CMD_DUMP_CONF_STOR_STATE,
> >> +		.header.len = sizeof(uvcb),
> >> +		.config_handle = kvm->arch.pv.handle,
> >> +		.gaddr = *gaddr,
> >> +		.dump_area_origin = 0,
> >> +	};
> >> +	size_t buff_kvm_size;
> >> +	size_t size_done = 0;
> >> +	u8 *buff_kvm = NULL;
> >> +	int cc, ret;
> >> +
> >> +	ret = -EINVAL;
> >> +	/* UV call processes 1MB guest storage chunks at a time */
> >> +	if (!IS_ALIGNED(*gaddr, HPAGE_SIZE))
> >> +		goto out;
> >> +
> >> +	/*
> >> +	 * We provide the storage state for 1MB chunks of guest
> >> +	 * storage. The buffer will need to be aligned to
> >> +	 * conf_dump_storage_state_len so we don't end on a partial
> >> +	 * chunk.
> >> +	 */
> >> +	if (!buff_user_len ||
> >> +	    !IS_ALIGNED(buff_user_len, uv_info.conf_dump_storage_state_len))
> >> +		goto out;
> >> +
> >> +	/*
> >> +	 * Allocate a buffer from which we will later copy to the user
> >> +	 * process. We don't want userspace to dictate our buffer size
> >> +	 * so we limit it to DUMP_BUFF_LEN.
> >> +	 */
> >> +	ret = -ENOMEM;
> >> +	buff_kvm_size = min_t(u64, buff_user_len, DUMP_BUFF_LEN);
> >> +	buff_kvm = vzalloc(buff_kvm_size);
> >> +	if (!buff_kvm)
> >> +		goto out;
> >> +
> >> +	ret = 0;
> >> +	uvcb.dump_area_origin = (u64)buff_kvm;
> >> +	/* We will loop until the user buffer is filled or an error occurs */
> >> +	do {
> >> +		/* Get 1MB worth of guest storage state data */
> >> +		cc = uv_call_sched(0, (u64)&uvcb);
> >> +
> >> +		/* All or nothing */
> >> +		if (cc) {
> >> +			ret = -EINVAL;
> >> +			break;
> >> +		}
> >> +
> >> +		size_done += uv_info.conf_dump_storage_state_len;  
> > 
> > maybe save this in a local const variable with a shorter name? would be
> > more readable? const u64 dump_len = uv_info.conf_dump_storage_state_len;
> >   

did you see this one ^ ?

> >> +		uvcb.dump_area_origin += uv_info.conf_dump_storage_state_len;
> >> +		buff_user_len -= uv_info.conf_dump_storage_state_len;
> >> +		uvcb.gaddr += HPAGE_SIZE;
> >> +
> >> +		/* KVM Buffer full, time to copy to the process */
> >> +		if (!buff_user_len || size_done == DUMP_BUFF_LEN) {
> >> +			if (copy_to_user(buff_user, buff_kvm, size_done)) {
> >> +				ret = -EFAULT;
> >> +				break;
> >> +			}
> >> +
> >> +			buff_user += size_done;
> >> +			size_done = 0;
> >> +			uvcb.dump_area_origin = (u64)buff_kvm;
> >> +		}
> >> +	} while (buff_user_len);
> >> +
> >> +	/* Report back where we ended dumping */
> >> +	*gaddr = uvcb.gaddr;
> >> +
> >> +	/* Lets only log errors, we don't want to spam */
> >> +out:
> >> +	if (ret)
> >> +		KVM_UV_EVENT(kvm, 3,
> >> +			     "PROTVIRT DUMP STORAGE STATE: addr %llx ret %d, uvcb rc %x rrc %x",
> >> +			     uvcb.gaddr, ret, uvcb.header.rc, uvcb.header.rrc);
> >> +	*rc = uvcb.header.rc;
> >> +	*rrc = uvcb.header.rrc;
> >> +	vfree(buff_kvm);
> >> +
> >> +	return ret;
> >> +}
> >> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> >> index bb2f91bc2305..1c60c2d314ba 100644
> >> --- a/include/uapi/linux/kvm.h
> >> +++ b/include/uapi/linux/kvm.h
> >> @@ -1653,6 +1653,20 @@ struct kvm_s390_pv_unp {
> >>   	__u64 tweak;
> >>   };
> >>   
> >> +enum pv_cmd_dmp_id {
> >> +	KVM_PV_DUMP_INIT,
> >> +	KVM_PV_DUMP_CONFIG_STOR_STATE,
> >> +	KVM_PV_DUMP_COMPLETE,
> >> +};
> >> +
> >> +struct kvm_s390_pv_dmp {
> >> +	__u64 subcmd;
> >> +	__u64 buff_addr;
> >> +	__u64 buff_len;
> >> +	__u64 gaddr;		/* For dump storage state */
> >> +	__u64 reserved[4];
> >> +};
> >> +
> >>   enum pv_cmd_info_id {
> >>   	KVM_PV_INFO_VM,
> >>   	KVM_PV_INFO_DUMP,
> >> @@ -1696,6 +1710,7 @@ enum pv_cmd_id {
> >>   	KVM_PV_PREP_RESET,
> >>   	KVM_PV_UNSHARE_ALL,
> >>   	KVM_PV_INFO,
> >> +	KVM_PV_DUMP,
> >>   };
> >>   
> >>   struct kvm_pv_cmd {  
> >   
> 

