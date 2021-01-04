Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA092E961C
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 14:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbhADNem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 08:34:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17650 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725889AbhADNel (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Jan 2021 08:34:41 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 104DXVke021704;
        Mon, 4 Jan 2021 08:33:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=2/7fnsEgAa3Bx7IhJvShikXoL/iQo77CkKgegSZS0cs=;
 b=oynQnkiPzHF8kIhF8PsB8WhYmSZEIc4DAP4V7mJsubxz38I81OqVbyOxY/ckZm9KAo6N
 GGX/5gVmPNmgeDCeiFL4iClQH5ExIhrl/dZdv3pW6wdLEXDeHkYnrMMT02N15LoZrJ4j
 gu6o4lvcmNHADa2hj1r5v317VUzSPj4wgmEXTyt0eP89bmDwl97a/MO2kbZEQvWvewY7
 hHHojN0P1+6Yqx4mzPW3TY0sMJD3C+/geg3GaHY2uRbr8EXyKVvjN9srBPpBgkLJ48Wq
 S5F0PdDzqfBoS1naWwHHer3xCxFF2W5vfg2iE/3jm4wsEaGqV1NNYIjb58Kt2gzgRsOb tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35v2d2tqn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 08:33:51 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 104DXdlm022388;
        Mon, 4 Jan 2021 08:33:51 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35v2d2tqks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 08:33:50 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 104DXXHr003879;
        Mon, 4 Jan 2021 13:33:48 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 35u3pmh9de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 13:33:48 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 104DXkOa43516254
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jan 2021 13:33:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E395A42049;
        Mon,  4 Jan 2021 13:33:45 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E5F742042;
        Mon,  4 Jan 2021 13:33:45 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.0.177])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Jan 2021 13:33:45 +0000 (GMT)
Date:   Mon, 4 Jan 2021 14:27:39 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, pbonzini@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com, nadav.amit@gmail.com
Subject: Re: [kvm-unit-tests PATCH v1 03/12] lib/vmalloc: add some asserts
 and improvements
Message-ID: <20210104142739.6f05f0c1@ibm-vm>
In-Reply-To: <80b20b32-64e6-5e69-0b0f-5d72aefe8398@oracle.com>
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
        <20201216201200.255172-4-imbrenda@linux.ibm.com>
        <80b20b32-64e6-5e69-0b0f-5d72aefe8398@oracle.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-04_08:2021-01-04,2021-01-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 impostorscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101040087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Dec 2020 10:16:45 -0800
Krish Sadhukhan <krish.sadhukhan@oracle.com> wrote:

> On 12/16/20 12:11 PM, Claudio Imbrenda wrote:
> > Add some asserts to make sure the state is consistent.
> >
> > Simplify and improve the readability of vm_free.
> >
> > Fixes: 3f6fee0d4da4 ("lib/vmalloc: vmalloc support for handling
> > allocation metadata")
> >
> > Signed-off-by: Claudio Imbrenda<imbrenda@linux.ibm.com>
> > ---
> >   lib/vmalloc.c | 20 +++++++++++---------
> >   1 file changed, 11 insertions(+), 9 deletions(-)
> >
> > diff --git a/lib/vmalloc.c b/lib/vmalloc.c
> > index 986a34c..7a49adf 100644
> > --- a/lib/vmalloc.c
> > +++ b/lib/vmalloc.c
> > @@ -162,13 +162,14 @@ static void *vm_memalign(size_t alignment,
> > size_t size) static void vm_free(void *mem)
> >   {
> >   	struct metadata *m;
> > -	uintptr_t ptr, end;
> > +	uintptr_t ptr, page, i;
> >  =20
> >   	/* the pointer is not page-aligned, it was a single-page
> > allocation */ =20
>=20
>=20
> Do we need an assert() for 'mem' if it is NULL for some reason ?

I thought the NULL case was handled in alloc.c, but I was mistaken.
In any case, the metadata will probably not match and trigger the other
asserts.

I will still add assert(mem), though, as it looks cleaner

> >   	if (!IS_ALIGNED((uintptr_t)mem, PAGE_SIZE)) {
> >   		assert(GET_MAGIC(mem) =3D=3D VM_MAGIC);
> > -		ptr =3D virt_to_pte_phys(page_root, mem) & PAGE_MASK;
> > -		free_page(phys_to_virt(ptr));
> > +		page =3D virt_to_pte_phys(page_root, mem) &
> > PAGE_MASK;
> > +		assert(page);
> > +		free_page(phys_to_virt(page));
> >   		return;
> >   	}
> >  =20
> > @@ -176,13 +177,14 @@ static void vm_free(void *mem)
> >   	m =3D GET_METADATA(mem);
> >   	assert(m->magic =3D=3D VM_MAGIC);
> >   	assert(m->npages > 0);
> > +	assert(m->npages < BIT_ULL(BITS_PER_LONG - PAGE_SHIFT)); =20
>=20
>=20
> NIT:=C2=A0 Combine the two assert()s for 'npages' perhaps ?

no, when one assert is triggered, it will print a useful message; if
you combine the two asserts you don't know why exactly it failed.

it's functionally equivalent, but it has a better user experience.

> >   	/* free all the pages including the metadata page */
> > -	ptr =3D (uintptr_t)mem - PAGE_SIZE;
> > -	end =3D ptr + m->npages * PAGE_SIZE;
> > -	for ( ; ptr < end; ptr +=3D PAGE_SIZE)
> > -		free_page(phys_to_virt(virt_to_pte_phys(page_root,
> > (void *)ptr)));
> > -	/* free the last one separately to avoid overflow issues */
> > -	free_page(phys_to_virt(virt_to_pte_phys(page_root, (void
> > *)ptr)));
> > +	ptr =3D (uintptr_t)m & PAGE_MASK;
> > +	for (i =3D 0 ; i < m->npages + 1; i++, ptr +=3D PAGE_SIZE) {
> > +		page =3D virt_to_pte_phys(page_root, (void *)ptr) &
> > PAGE_MASK;
> > +		assert(page);
> > +		free_page(phys_to_virt(page));
> > +	}
> >   }
> >  =20
> >   static struct alloc_ops vmalloc_ops =3D { =20

