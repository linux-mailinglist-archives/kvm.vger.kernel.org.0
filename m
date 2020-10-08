Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1B7287A50
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 18:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbgJHQsv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 12:48:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59134 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728218AbgJHQsu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Oct 2020 12:48:50 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 098GWc25119610;
        Thu, 8 Oct 2020 12:44:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=DOjfJtmqn0RgphxiIiG0Kv2UKoYLCpYcT9ErIqcce6E=;
 b=Wg15T8U9KQDXgs4QwB8A79tlx7vkXl3sj9pFh/1cOPLlDjrtMPxkA1D6agqTMMOzRLf7
 NUnasH/5LgKXjRmsfdo8cPf3xCzwhbuxs2Z8DTZRnSWg8WMLVLxLDsVASnHBlnfZGWD5
 nrHVw4Mrev3JAPk1tZjw4hdG2ZoVozDpaXbDoW6prAYwvRRF53bIbj4IQ+PJoDUQZgJ/
 f6GjUgeB+MO2nhKeRhvObJsiHly0uBtE1AQCa31NxixXKdyjB9iU/pTGQ4Mz3rer6W96
 eRSBZOyfkkXDhLNgYJTHugguwBIeLDnByF/lWwzsCaKdh5SLKVgxMPNkdzNTGJCVQ2v3 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34263q8xd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Oct 2020 12:44:48 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 098GgIad150220;
        Thu, 8 Oct 2020 12:44:47 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34263q8xbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Oct 2020 12:44:47 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 098Gclfr009991;
        Thu, 8 Oct 2020 16:44:45 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 33xgx7tw34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Oct 2020 16:44:45 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 098GigqX33817070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Oct 2020 16:44:42 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9995A405F;
        Thu,  8 Oct 2020 16:44:42 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23192A4065;
        Thu,  8 Oct 2020 16:44:42 +0000 (GMT)
Received: from thinkpad (unknown [9.171.64.67])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu,  8 Oct 2020 16:44:42 +0000 (GMT)
Date:   Thu, 8 Oct 2020 18:44:40 +0200
From:   Gerald Schaefer <gerald.schaefer@linux.ibm.com>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dan Williams <dan.j.williams@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Niklas Schnelle <schnelle@linux.ibm.com>
Subject: Re: [PATCH 08/13] s390/pci: Remove races against pte updates
Message-ID: <20201008184440.4c3bebed@thinkpad>
In-Reply-To: <20201007164426.1812530-9-daniel.vetter@ffwll.ch>
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
        <20201007164426.1812530-9-daniel.vetter@ffwll.ch>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-08_11:2020-10-08,2020-10-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 suspectscore=2 mlxscore=0 impostorscore=0
 clxscore=1011 phishscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  7 Oct 2020 18:44:21 +0200
Daniel Vetter <daniel.vetter@ffwll.ch> wrote:

> Way back it was a reasonable assumptions that iomem mappings never
> change the pfn range they point at. But this has changed:
>=20
> - gpu drivers dynamically manage their memory nowadays, invalidating
> ptes with unmap_mapping_range when buffers get moved
>=20
> - contiguous dma allocations have moved from dedicated carvetouts to
> cma regions. This means if we miss the unmap the pfn might contain
> pagecache or anon memory (well anything allocated with GFP_MOVEABLE)
>=20
> - even /dev/mem now invalidates mappings when the kernel requests that
> iomem region when CONFIG_IO_STRICT_DEVMEM is set, see 3234ac664a87
> ("/dev/mem: Revoke mappings when a driver claims the region")
>=20
> Accessing pfns obtained from ptes without holding all the locks is
> therefore no longer a good idea. Fix this.
>=20
> Since zpci_memcpy_from|toio seems to not do anything nefarious with
> locks we just need to open code get_pfn and follow_pfn and make sure
> we drop the locks only after we've done. The write function also needs
> the copy_from_user move, since we can't take userspace faults while
> holding the mmap sem.
>=20
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-mm@kvack.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: Niklas Schnelle <schnelle@linux.ibm.com>
> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> Cc: linux-s390@vger.kernel.org
> ---
>  arch/s390/pci/pci_mmio.c | 98 +++++++++++++++++++++++-----------------
>  1 file changed, 57 insertions(+), 41 deletions(-)

Looks good, thanks. Also survived some basic function test. Only some
minor nitpick, see below.

Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

>=20
> diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
> index 401cf670a243..4d194cb09372 100644
> --- a/arch/s390/pci/pci_mmio.c
> +++ b/arch/s390/pci/pci_mmio.c
> @@ -119,33 +119,15 @@ static inline int __memcpy_toio_inuser(void __iomem=
 *dst,
>  	return rc;
>  }
> =20
> -static long get_pfn(unsigned long user_addr, unsigned long access,
> -		    unsigned long *pfn)
> -{
> -	struct vm_area_struct *vma;
> -	long ret;
> -
> -	mmap_read_lock(current->mm);
> -	ret =3D -EINVAL;
> -	vma =3D find_vma(current->mm, user_addr);
> -	if (!vma)
> -		goto out;
> -	ret =3D -EACCES;
> -	if (!(vma->vm_flags & access))
> -		goto out;
> -	ret =3D follow_pfn(vma, user_addr, pfn);
> -out:
> -	mmap_read_unlock(current->mm);
> -	return ret;
> -}
> -
>  SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
>  		const void __user *, user_buffer, size_t, length)
>  {
>  	u8 local_buf[64];
>  	void __iomem *io_addr;
>  	void *buf;
> -	unsigned long pfn;
> +	struct vm_area_struct *vma;
> +	pte_t *ptep;
> +	spinlock_t *ptl;
>  	long ret;
> =20
>  	if (!zpci_is_enabled())
> @@ -158,7 +140,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, m=
mio_addr,
>  	 * We only support write access to MIO capable devices if we are on
>  	 * a MIO enabled system. Otherwise we would have to check for every
>  	 * address if it is a special ZPCI_ADDR and would have to do
> -	 * a get_pfn() which we don't need for MIO capable devices.  Currently
> +	 * a pfn lookup which we don't need for MIO capable devices.  Currently
>  	 * ISM devices are the only devices without MIO support and there is no
>  	 * known need for accessing these from userspace.
>  	 */
> @@ -176,21 +158,37 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long,=
 mmio_addr,
>  	} else
>  		buf =3D local_buf;
> =20
> -	ret =3D get_pfn(mmio_addr, VM_WRITE, &pfn);
> +	ret =3D -EFAULT;
> +	if (copy_from_user(buf, user_buffer, length))
> +		goto out_free;
> +
> +	mmap_read_lock(current->mm);
> +	ret =3D -EINVAL;
> +	vma =3D find_vma(current->mm, mmio_addr);
> +	if (!vma)
> +		goto out_unlock_mmap;
> +	ret =3D -EACCES;
> +	if (!(vma->vm_flags & VM_WRITE))
> +		goto out_unlock_mmap;
> +	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> +		goto out_unlock_mmap;

That check for VM_IO | VM_PFNMAP was previously hidden inside follow_pfn(),
and that would have returned -EINVAL in this case. With your change, we
now return -EACCES. Not sure how important that is, but it feels wrong.
Maybe move the VM_IO | VM_PFNMAP check up, before the ret =3D -EACCES?

[...]
> @@ -306,22 +306,38 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, =
mmio_addr,
>  		buf =3D local_buf;
>  	}
> =20
> -	ret =3D get_pfn(mmio_addr, VM_READ, &pfn);
> +	mmap_read_lock(current->mm);
> +	ret =3D -EINVAL;
> +	vma =3D find_vma(current->mm, mmio_addr);
> +	if (!vma)
> +		goto out_unlock_mmap;
> +	ret =3D -EACCES;
> +	if (!(vma->vm_flags & VM_WRITE))
> +		goto out_unlock_mmap;
> +	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> +		goto out_unlock_mmap;

Same here with VM_IO | VM_PFNMAP and -EINVAL.
