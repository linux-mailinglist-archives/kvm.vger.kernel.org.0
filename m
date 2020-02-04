Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68FA2151AFC
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 14:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgBDNNO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 08:13:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21854 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727170AbgBDNNN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 08:13:13 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 014DBOf3046738
        for <kvm@vger.kernel.org>; Tue, 4 Feb 2020 08:13:12 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xy6r8xnpk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 08:13:11 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Tue, 4 Feb 2020 13:08:08 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 4 Feb 2020 13:08:05 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 014D842d51118152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Feb 2020 13:08:04 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD87242045;
        Tue,  4 Feb 2020 13:08:03 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 958EC4204D;
        Tue,  4 Feb 2020 13:08:03 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.108])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Feb 2020 13:08:03 +0000 (GMT)
Date:   Tue, 4 Feb 2020 14:08:02 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 06/37] s390: add (non)secure page access exceptions
 handlers
In-Reply-To: <2362357d-f2b5-62f2-8cb1-b7e281ea66e2@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-7-borntraeger@de.ibm.com>
        <dd3d333d-d141-5a22-9b1d-161232b37cfb@redhat.com>
        <20200204124123.183ef25b@p-imbrenda>
        <2362357d-f2b5-62f2-8cb1-b7e281ea66e2@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20020413-0016-0000-0000-000002E392C2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020413-0017-0000-0000-000033466E79
Message-Id: <20200204140802.412605a4@p-imbrenda>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-04_04:2020-02-04,2020-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxlogscore=993
 mlxscore=0 impostorscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002040092
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Feb 2020 13:48:47 +0100
Thomas Huth <thuth@redhat.com> wrote:

> On 04/02/2020 12.41, Claudio Imbrenda wrote:
> > On Tue, 4 Feb 2020 11:37:42 +0100
> > Thomas Huth <thuth@redhat.com> wrote:
> > 
> > [...]
> >   
> >>> ---
> >>>  arch/s390/kernel/pgm_check.S |  4 +-
> >>>  arch/s390/mm/fault.c         | 87
> >>> ++++++++++++++++++++++++++++++++++++ 2 files changed, 89
> >>> insertions(+), 2 deletions(-)    
> >> [...]  
> >>> +void do_non_secure_storage_access(struct pt_regs *regs)
> >>> +{
> >>> +	unsigned long gaddr = regs->int_parm_long &
> >>> __FAIL_ADDR_MASK;
> >>> +	struct gmap *gmap = (struct gmap *)S390_lowcore.gmap;
> >>> +	struct uv_cb_cts uvcb = {
> >>> +		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
> >>> +		.header.len = sizeof(uvcb),
> >>> +		.guest_handle = gmap->se_handle,
> >>> +		.gaddr = gaddr,
> >>> +	};
> >>> +	int rc;
> >>> +
> >>> +	if (get_fault_type(regs) != GMAP_FAULT) {
> >>> +		do_fault_error(regs, VM_READ | VM_WRITE,
> >>> VM_FAULT_BADMAP);
> >>> +		WARN_ON_ONCE(1);
> >>> +		return;
> >>> +	}
> >>> +
> >>> +	rc = uv_make_secure(gmap, gaddr, &uvcb, 0);
> >>> +	if (rc == -EINVAL && uvcb.header.rc != 0x104)
> >>> +		send_sig(SIGSEGV, current, 0);
> >>> +}    
> >>
> >> What about the other rc beside 0x104 that could happen here? They
> >> go unnoticed?  
> > 
> > no, they are handled in the uv_make_secure, and return an
> > appropriate error code.   
> Hmm, in patch 05/37, I basically see:
> 
> +static int make_secure_pte(pte_t *ptep, unsigned long addr, void
> *data) +{
> [...]
> +	rc = uv_call(0, (u64)params->uvcb);
> +	page_ref_unfreeze(page, expected);
> +	if (rc)
> +		rc = (params->uvcb->rc == 0x10a) ? -ENXIO : -EINVAL;
> +	return rc;
> +}
> 
> +int uv_make_secure(struct gmap *gmap, unsigned long gaddr, void
> *uvcb, int pins)
> +{
> [...]
> +	lock_page(params.page);
> +	rc = apply_to_page_range(gmap->mm, uaddr, PAGE_SIZE,
> make_secure_pte, &params);
> +	unlock_page(params.page);
> +out:
> +	up_read(&gmap->mm->mmap_sem);
> +
> +	if (rc == -EBUSY) {
> +		if (local_drain) {
> +			lru_add_drain_all();
> +			return -EAGAIN;
> +		}
> +		lru_add_drain();
> +		local_drain = 1;
> +		goto again;
> +	} else if (rc == -ENXIO) {
> +		if (gmap_fault(gmap, gaddr, FAULT_FLAG_WRITE))
> +			return -EFAULT;
> +		return -EAGAIN;
> +	}
> +	return rc;
> +}
> 
> So 0x10a result in -ENXIO and is handled ==> OK.
> And 0x104 is handled in do_non_secure_storage_access ==> OK.
> 
> But what about the other possible error codes? make_secure_pte()
> returns -EINVAL in that case, but uv_make_secure() does not care
> about that error code, and do_non_secure_storage_access() only cares
> if uvcb.header.rc was 0x104 ... what did I miss?

basically, any error value that is not handled by uv_make_secure is
passed as-is from make_secure_pte directly to the caller of
uv_make_secure .
any RC value that is not explicitly handled here will
result in -EINVAL. The caller has then to check for -EINVAL and check
the RC value, like do_non_secure_storage_access does.

so anything else that goes wrong is passed as-is to the caller.
for some things, like interrupt handlers, we simply don't care; if we
need to try again, we will try again, if we notice we can't continue,
the VM will get killed.



