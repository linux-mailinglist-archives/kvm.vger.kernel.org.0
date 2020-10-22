Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8FE2956D4
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 05:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895443AbgJVDcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 23:32:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57330 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2443991AbgJVDcV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Oct 2020 23:32:21 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09M32495004160;
        Wed, 21 Oct 2020 23:31:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=1xQi+7W2T2Fbkdb8+KC5oD8knUZ7IHDxT/Z8e4Qn+3w=;
 b=ailI8hnI8owHkREsCd4YRLsVO9iu/CHqO9F+SgxH2J33g2bDG9XOPF98kEWJIemsiMAq
 lhaRiFjGq52S+iF/bN/hBhBdFWKIfmiAnDHDC0JXHdDmVkLluyHybS125NYro9g8k8Db
 xU8NoIxk+rExi2tis3SOXI53MOeITHtup5O2qaUClMK+vvVS5K1p5YaIJJFkDhrWZGPe
 S8hQsK6fPtWyScAFUM8lcEQE9WRHwNc/aUj4Mhddj0Gz4cjF6rJyE7YGdBooOWWIFl63
 xMjaLuukrOtThJBcAWPl25AxX15ntrJ7YIDaEFB+Wmy6wlVsk2m+hgScUeWsh6OKYYmp 2w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34b00db2qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Oct 2020 23:31:26 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09M3QCQ6067016;
        Wed, 21 Oct 2020 23:31:26 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34b00db2ps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Oct 2020 23:31:26 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09M3TR5p000756;
        Thu, 22 Oct 2020 03:31:24 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 347r882jfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 03:31:24 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09M3VLhR20250884
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 03:31:21 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 849BC5206C;
        Thu, 22 Oct 2020 03:31:21 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.57.168])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 70A2452057;
        Thu, 22 Oct 2020 03:31:20 +0000 (GMT)
Date:   Thu, 22 Oct 2020 05:31:18 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFCv2 05/16] x86/kvm: Make VirtIO use DMA API in KVM guest
Message-ID: <20201022053118.76be12bb.pasic@linux.ibm.com>
In-Reply-To: <20201020061859.18385-6-kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
        <20201020061859.18385-6-kirill.shutemov@linux.intel.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_01:2020-10-20,2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 suspectscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010220015
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 20 Oct 2020 09:18:48 +0300
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> VirtIO for KVM is a primary way to provide IO. All memory that used for
> communication with the host has to be marked as shared.
> 
> The easiest way to archive that is to use DMA API that already knows how
> to deal with shared memory.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  drivers/virtio/virtio_ring.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index becc77697960..ace733845d5d 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -12,6 +12,7 @@
>  #include <linux/hrtimer.h>
>  #include <linux/dma-mapping.h>
>  #include <xen/xen.h>
> +#include <asm/kvm_para.h>
>  
>  #ifdef DEBUG
>  /* For development, we want to crash whenever the ring is screwed. */
> @@ -255,6 +256,9 @@ static bool vring_use_dma_api(struct virtio_device *vdev)
>  	if (xen_domain())
>  		return true;
>  
> +	if (kvm_mem_protected())
> +		return true;
> +

I guess it does not matter because Christophs comment, but this breaks
the build for s390, because there is no kvm_mem_protected() for s390.

Regards,
Halil

>  	return false;
>  }
>  

