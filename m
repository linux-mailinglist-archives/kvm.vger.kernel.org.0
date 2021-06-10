Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C743A315B
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 18:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhFJQw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 12:52:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34644 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230166AbhFJQwZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 12:52:25 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15AGXC5t023308;
        Thu, 10 Jun 2021 12:50:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=27Mi0+Md+EuWMwIKLJmLnnlXiz4k7R+ONup19CRSC7M=;
 b=PZastsUYwpKNLfCVvM/GVWw4ocUPrnyC5pGBXvJkyNxoIpX4uXgxThA1ievbRg5gdsux
 wdD2OXUfxo9MRGb9zqt98LUBI9OF2Kd7Vs+e5KpZs19iZKewTCG/32BOvUxwSyanQ8XA
 W99ztlV7p0Y1pIovad7VACaJKHBpdpBJeQEUPCSuvy1KCFQeAdHj7XaXuz4otNhi6wEY
 oniWdoG3DpRDlvRyzpzjrswQF0aTZnSOGQ39cSDPu36FtW+l3l4Sg3Yb9olgNoRSDkeI
 ZQ5HpaINtwEhQtuyT4UIMql4Rf/7UNANU3HRnzOZEad847C+g6Ep5Wx84Ziv64+i+mL/ gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 393macnb4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 12:50:02 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15AGXBSB023206;
        Thu, 10 Jun 2021 12:50:01 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 393macnb3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 12:50:01 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15AGlhYI026305;
        Thu, 10 Jun 2021 16:49:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3936ns094n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 16:49:59 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15AGnufJ34078990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 16:49:56 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE80811C052;
        Thu, 10 Jun 2021 16:49:55 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4518811C04C;
        Thu, 10 Jun 2021 16:49:55 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.5.240])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Jun 2021 16:49:55 +0000 (GMT)
Date:   Thu, 10 Jun 2021 18:49:53 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        cohuck@redhat.com, david@redhat.com, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/2] KVM: s390: fix for hugepage vmalloc
Message-ID: <20210610184953.19bed6b4@ibm-vm>
In-Reply-To: <368cfb74-fdc2-00a7-d452-696e375c2ff7@de.ibm.com>
References: <20210610154220.529122-1-imbrenda@linux.ibm.com>
        <20210610154220.529122-3-imbrenda@linux.ibm.com>
        <368cfb74-fdc2-00a7-d452-696e375c2ff7@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iC2QAseRmfXSA0wLSjDo59zNrqf0MWXJ
X-Proofpoint-GUID: _OlaA-jqjeH7DLk3y5Z-fGqCXuEKPrF_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_11:2021-06-10,2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 impostorscore=0 suspectscore=0 phishscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=906 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Jun 2021 17:56:58 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 10.06.21 17:42, Claudio Imbrenda wrote:
> > The Create Secure Configuration Ultravisor Call does not support
> > using large pages for the virtual memory area. This is a hardware
> > limitation.
> > 
> > This patch replaces the vzalloc call with an almost equivalent call
> > to the newly introduced vmalloc_no_huge function, which guarantees
> > that only small pages will be used for the backing.
> > 
> > The new call will not clear the allocated memory, but that has never
> > been an actual requirement.

^ here

> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Nicholas Piggin <npiggin@gmail.com>
> > Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Christoph Hellwig <hch@infradead.org>
> > ---
> >   arch/s390/kvm/pv.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> > index 813b6e93dc83..ad7c6d7cc90b 100644
> > --- a/arch/s390/kvm/pv.c
> > +++ b/arch/s390/kvm/pv.c
> > @@ -140,7 +140,7 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
> >   	/* Allocate variable storage */
> >   	vlen = ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE),
> > PAGE_SIZE); vlen += uv_info.guest_virt_base_stor_len;
> > -	kvm->arch.pv.stor_var = vzalloc(vlen);
> > +	kvm->arch.pv.stor_var = vmalloc_no_huge(vlen);  
> 
> dont we need a memset now?

no, as explained above

> >   	if (!kvm->arch.pv.stor_var)
> >   		goto out_err;
> >   	return 0;
> >   

