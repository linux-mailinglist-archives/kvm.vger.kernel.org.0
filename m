Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9FEE7574
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2019 16:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389930AbfJ1PtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Oct 2019 11:49:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43972 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726097AbfJ1PtA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Oct 2019 11:49:00 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9SFmBnC109442
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2019 11:48:59 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vx2xm8v86-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2019 11:48:59 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <gor@linux.ibm.com>;
        Mon, 28 Oct 2019 15:48:57 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 28 Oct 2019 15:48:54 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9SFmq8A26476626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 15:48:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82989A4065;
        Mon, 28 Oct 2019 15:48:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35934A4067;
        Mon, 28 Oct 2019 15:48:52 +0000 (GMT)
Received: from localhost (unknown [9.152.212.73])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 28 Oct 2019 15:48:52 +0000 (GMT)
Date:   Mon, 28 Oct 2019 16:48:50 +0100
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com
Subject: Re: [RFC 03/37] s390/protvirt: add ultravisor initialization
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-4-frankja@linux.ibm.com>
 <d0bc545a-fdbb-2aa9-4f0a-2e0ea1abce5b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d0bc545a-fdbb-2aa9-4f0a-2e0ea1abce5b@redhat.com>
X-TM-AS-GCONF: 00
x-cbid: 19102815-0028-0000-0000-000003B06BD3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102815-0029-0000-0000-00002472A97D
Message-Id: <your-ad-here.call-01572277730-ext-9266@work.hours>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-28_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=5 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=838 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910280159
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 25, 2019 at 11:21:05AM +0200, David Hildenbrand wrote:
> On 24.10.19 13:40, Janosch Frank wrote:
> > From: Vasily Gorbik <gor@linux.ibm.com>
> > 
> > Before being able to host protected virtual machines, donate some of
> > the memory to the ultravisor. Besides that the ultravisor might impose
> > addressing limitations for memory used to back protected VM storage. Treat
> > that limit as protected virtualization host's virtual memory limit.
> > 
> > Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> > ---
> >   arch/s390/include/asm/uv.h | 16 ++++++++++++
> >   arch/s390/kernel/setup.c   |  3 +++
> >   arch/s390/kernel/uv.c      | 53 ++++++++++++++++++++++++++++++++++++++
> >   3 files changed, 72 insertions(+)
> > 
> > --- a/arch/s390/kernel/setup.c
> > +++ b/arch/s390/kernel/setup.c
> > @@ -567,6 +567,8 @@ static void __init setup_memory_end(void)
> >   			vmax = _REGION1_SIZE; /* 4-level kernel page table */
> >   	}
> > +	adjust_to_uv_max(&vmax);
> 
> I do wonder what would happen if vmax < max_physmem_end. Not sure if that is
> relevant at all.

Then identity mapping would be shorter then actual physical memory available
and everything above would be lost. But in reality "max_sec_stor_addr"
is big enough to not worry about it in the foreseeable future at all.

> > +void __init setup_uv(void)
> > +{
> > +	unsigned long uv_stor_base;
> > +
> > +	if (!prot_virt_host)
> > +		return;
> > +
> > +	uv_stor_base = (unsigned long)memblock_alloc_try_nid(
> > +		uv_info.uv_base_stor_len, SZ_1M, SZ_2G,
> > +		MEMBLOCK_ALLOC_ACCESSIBLE, NUMA_NO_NODE);
> > +	if (!uv_stor_base) {
> > +		pr_info("Failed to reserve %lu bytes for ultravisor base storage\n",
> > +			uv_info.uv_base_stor_len);
> > +		goto fail;
> > +	}
> 
> If I'm not wrong, we could setup/reserve a CMA area here and defer the
> actual allocation. Then, any MOVABLE data can end up on this CMA area until
> needed.
> 
> But I am neither an expert on CMA nor on UV, so most probably what I say is
> wrong ;)

From pure memory management this sounds like a good idea. And I tried
it and cma_declare_contiguous fulfills our needs, just had to export
cma_alloc/cma_release symbols. Nevertheless, delaying ultravisor init means we
would be potentially left with vmax == max_sec_stor_addr even if we wouldn't
be able to run protected VMs after all (currently setup_uv() is called
before kernel address space layout setup). Another much more fundamental
reason is that ultravisor init has to be called with a single cpu running,
which means it's easy to do before bringing other cpus up and we currently
don't have api to stop cpus at a later point (stop_machine won't cut it).

> > +
> > +	if (uv_init(uv_stor_base, uv_info.uv_base_stor_len)) {
> > +		memblock_free(uv_stor_base, uv_info.uv_base_stor_len);
> > +		goto fail;
> > +	}
> > +
> > +	pr_info("Reserving %luMB as ultravisor base storage\n",
> > +		uv_info.uv_base_stor_len >> 20);
> > +	return;
> > +fail:
> > +	prot_virt_host = 0;
> > +}
> > +
> > +void adjust_to_uv_max(unsigned long *vmax)
> > +{
> > +	if (prot_virt_host && *vmax > uv_info.max_sec_stor_addr)
> > +		*vmax = uv_info.max_sec_stor_addr;
> > +}
> >   #endif
> > 
> 
> Looks good to me from what I can tell.
> 
> -- 
> 
> Thanks,
> 
> David / dhildenb
> 

