Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1A72830A0
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 09:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgJEHK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 03:10:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17686 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbgJEHK2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 03:10:28 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09574oI7013125
        for <kvm@vger.kernel.org>; Mon, 5 Oct 2020 03:10:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=SKYv+5RVGrvNgayQmYUQVLVZafIPXsR0VlcaA2y/KxE=;
 b=h2aAav7pYO2mwglAD1Ov1qgL/ryxvQWYdCVNhBFtvgPF3NX5WA4CpzMpSRvYPtZkDlsC
 0o/eZiT83Wdz7QyQF5Mr97ap9wG41eyIh4y9Ww0mfoK4K89iTn7ANHYwTLOpc4409+79
 adFrGM91+8cwhJwKGURbseDEWfnU5kMMZ9kc6PpMMrBxWBvotA9sOJ/5tsPkaNO9p0zb
 w85RqgRLr6S5mHFglObvt3aCb53g8JoUm7YsdLcSQ5EYJ5rDxTnafQDJVUKuEPR9lmL7
 GiAwNKJMJO+WQzI3XMY7G1jmDMhDkMQnUzK39faU2aErrCFmyj8aagtjo4ryfoLP8BcA KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33yx5u147d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 05 Oct 2020 03:10:27 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09575T7q015740
        for <kvm@vger.kernel.org>; Mon, 5 Oct 2020 03:10:27 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33yx5u146f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 03:10:27 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09577AEr005576;
        Mon, 5 Oct 2020 07:10:24 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 33xgx81vqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 07:10:24 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0957AMeG31195440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Oct 2020 07:10:22 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 524F35204F;
        Mon,  5 Oct 2020 07:10:22 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.2.175])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A31B452054;
        Mon,  5 Oct 2020 07:10:21 +0000 (GMT)
Date:   Mon, 5 Oct 2020 09:00:01 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 2/7] lib/vmalloc: vmalloc support for
 handling allocation metadata
Message-ID: <20201005090001.5ec709e9@ibm-vm>
In-Reply-To: <20201003084639.s36ngidcfqtehygh@kamzik.brq.redhat.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
        <20201002154420.292134-3-imbrenda@linux.ibm.com>
        <20201003084639.s36ngidcfqtehygh@kamzik.brq.redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-05_04:2020-10-02,2020-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 suspectscore=2 adultscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050051
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 3 Oct 2020 10:46:39 +0200
Andrew Jones <drjones@redhat.com> wrote:

[...]

> > +	/* the pointer is page-aligned, it was a multi-page
> > allocation */
> > +	m = GET_METADATA(mem);
> > +	assert(m->magic == VM_MAGIC);
> > +	assert(m->npages > 0);
> > +	/* free all the pages including the metadata page */
> > +	ptr = (uintptr_t)mem - PAGE_SIZE;
> > +	end = ptr + m->npages * PAGE_SIZE;
> > +	for ( ; ptr < end; ptr += PAGE_SIZE)
> > +		free_page(phys_to_virt(virt_to_pte_phys(page_root,
> > (void *)ptr)));
> > +	/* free the last one separately to avoid overflow issues */
> > +	free_page(phys_to_virt(virt_to_pte_phys(page_root, (void
> > *)ptr)));  
> 
> I don't get this. How is
> 
>  for (p = start; p < end; p += step)
>    process(p);
>  process(p)
> 
> different from
> 
>  for (p = start; p <= end; p += step)
>    process(p);

there was a reason at some point, I think the code evolved past it and
these lines stayed there as is

> To avoid overflow issues we should simple ensure start and end are
> computed correctly. Also, I'd prefer 'end' point to the actual end,
> not the last included page, e.g. start=0x1000, end=0x1fff. Then we
> have
> 
>  start = get_start();
>  assert(PAGE_ALIGN(start) == start);
>  end = start + nr_pages * PAGE_SIZE - 1;
>  assert(start < end);
>  for (p = start; start < end; p += PAGE_SIZE)
>    process(p);
> 
> Thanks,
> drew

yeah I'll definitely fix it
