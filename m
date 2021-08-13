Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9116C3EAF6E
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 06:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhHMEzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 00:55:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7368 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229468AbhHMEzU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 00:55:20 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D4bXUO019616;
        Fri, 13 Aug 2021 00:54:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : in-reply-to; s=pp1; bh=X2H3cSxTkK96kB6K5c2zXcyJlMFtpj/jSNRl5K8+vr0=;
 b=UBurvOKKO2B6jucTPAB3U/TU0iqSSL7UjrfOgR5e5ZdS+8HHExUvT4ZbPgLhRO+MhjJf
 ICNOEJRj7BIxLn1lVFrLHQ02+JgIpPHazPg9AQrBr9ScEZ74Jzih4NbQUrcflh+4YLtB
 lkWsngBY77pDPZTXh8yDIwK7/lqzA8UE4UZAGnBzSW7qQQtdNnYADOs8XZ3sK46Gho6b
 dbFIlneR6BhMDanbd1lAX5Jgq8B0N3cRAX7Grfz2o1n7JcURgE7ydZA2HrRHcQtsIo8F
 3D5Kgh5RbOEjpvUU9eKEF8lRplzK+3RAvhzli49CQH27FMg5xGcS/SPb77VB18S+6oHg pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ad4hy44du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 00:54:48 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17D4bq7c021646;
        Fri, 13 Aug 2021 00:54:47 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ad4hy44de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 00:54:47 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17D4skZe023085;
        Fri, 13 Aug 2021 04:54:46 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3acfpgaqu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 04:54:46 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17D4pPSa56295880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 04:51:25 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C676642047;
        Fri, 13 Aug 2021 04:54:43 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E0BA42041;
        Fri, 13 Aug 2021 04:54:42 +0000 (GMT)
Received: from in.ibm.com (unknown [9.102.2.89])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 13 Aug 2021 04:54:42 +0000 (GMT)
Date:   Fri, 13 Aug 2021 10:24:39 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        aneesh.kumar@linux.ibm.com, bharata.rao@gmail.com,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v0 5/5] pseries: Asynchronous page fault support
Message-ID: <YRX7DyCz1xp34xfK@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <20210805072439.501481-1-bharata@linux.ibm.com>
 <20210805072439.501481-6-bharata@linux.ibm.com>
 <1628825941.uhcogyrzjc.astroid@bobo.none>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628825941.uhcogyrzjc.astroid@bobo.none>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HKKLaq-gc61MbdtQx-nckLCMc1Cv0I-w
X-Proofpoint-GUID: 9ljl69I8TDnMIS-D8d9ZVZ6KuIXEIH7I
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_01:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130027
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 13, 2021 at 02:06:40PM +1000, Nicholas Piggin wrote:
> Excerpts from Bharata B Rao's message of August 5, 2021 5:24 pm:
> > Add asynchronous page fault support for pseries guests.
> > 
> > 1. Setup the guest to handle async-pf
> >    - Issue H_REG_SNS hcall to register the SNS region.
> >    - Setup the subvention interrupt irq.
> >    - Enable async-pf by updating the byte_b9 of VPA for each
> >      CPU.
> > 2. Check if the page fault is an expropriation notification
> >    (SRR1_PROGTRAP set in SRR1) and if so put the task on
> >    wait queue based on the expropriation correlation number
> >    read from the VPA.
> > 3. Handle subvention interrupt to wake any waiting tasks.
> >    The wait and wakeup mechanism from x86 async-pf implementation
> >    is being reused here.
> 
> I don't know too much about the background of this.
> 
> How much benefit does this give? What situations?

I haven't yet gotten into measuring the benefit of this. Once
the patches are bit more stable than what they are currently,
we need to measure and evaluate the benefits.

> Does PowerVM implement it?

I suppose so, need to check though.

> Do other architectures KVM have something similar?

Yes, x86 and s390 KVM have had this feature for a while now
and generic KVM interfaces exist to support it.

> 
> The SRR1 setting for the DSI is in PAPR? In that case it should be okay,
> it might be good to add a small comment in exceptions-64s.S.

Yes, SRR1 setting is part of PAPR.

> 
> [...]
> 
> > @@ -395,6 +395,11 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
> >  	vm_fault_t fault, major = 0;
> >  	bool kprobe_fault = kprobe_page_fault(regs, 11);
> >  
> > +#ifdef CONFIG_PPC_PSERIES
> > +	if (handle_async_page_fault(regs, address))
> > +		return 0;
> > +#endif
> > +
> >  	if (unlikely(debugger_fault_handler(regs) || kprobe_fault))
> >  		return 0;
> 
> [...]
> 
> > +int handle_async_page_fault(struct pt_regs *regs, unsigned long addr)
> > +{
> > +	struct async_pf_sleep_node n;
> > +	DECLARE_SWAITQUEUE(wait);
> > +	unsigned long exp_corr_nr;
> > +
> > +	/* Is this Expropriation notification? */
> > +	if (!(mfspr(SPRN_SRR1) & SRR1_PROGTRAP))
> > +		return 0;
> 
> Yep this should be an inline that is guarded by a static key, and then 
> probably have an inline check for SRR1_PROGTRAP. You shouldn't need to
> mfspr here, but just use regs->msr.

Right.

> 
> > +
> > +	if (unlikely(!user_mode(regs)))
> > +		panic("Host injected async PF in kernel mode\n");
> 
> Hmm. Is there anything in the PAPR interface that specifies that the
> OS can only deal with problem state access faults here? Or is that
> inherent in the expropriation feature?

Didn't see anything specific to that effect in PAPR. However since
this puts the faulting guest process to sleep until the page
becomes ready in the host, I have limited it to guest user space
faults.

Regards,
Bharata.
