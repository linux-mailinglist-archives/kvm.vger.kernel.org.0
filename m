Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13CC2BA46B
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 09:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgKTIOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 03:14:19 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:43327 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725818AbgKTIOT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 03:14:19 -0500
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2020 03:14:17 EST
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud7.xs4all.net with ESMTPA
        id g1RVk0X9Olmd2g1RYkPQEf; Fri, 20 Nov 2020 09:07:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1605859628; bh=5ef7lI42EJC0jhODZv8aRbqRC0kxVqZ7bUU3H8kTkJ0=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=sCz/nqjJKBqA3Iy+hXRhoPwJZL4RSnoEtFxis6hkV75LW75H+8Mmf4xAFrJVrm+pe
         8hj9fY43X0dqeh5hcaBFUdzWOJyUGVN+kLdzF+HYD2GMKZ191HzrbBTSABtTsVzA60
         CvFYS7ezfnr1FTaFjba06AEAIGK1cPKBvJnU0bV//E1AUEPH/j9aY3U67vZ93V4hF3
         6I2h2Od2vKJaEqVVhdF9KG8FIUuOZ8CG53hsXtNKL1Ch1fABIwEX5ve+bjxpFXGSyB
         aulCIunjrg9nl2+Y0ytv3CWHuxLF8HC5EnBBERF6rxbWpTScSnwiEMYNWkAwQXYMxf
         cBr7jUjdLWeiw==
Subject: Re: [PATCH v6 09/17] media/videbuf1|2: Mark follow_pfn usage as
 unsafe
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Tomasz Figa <tfiga@chromium.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Michel Lespinasse <walken@google.com>
References: <20201119144146.1045202-1-daniel.vetter@ffwll.ch>
 <20201119144146.1045202-10-daniel.vetter@ffwll.ch>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f1f3a1d8-d62a-6e93-afc1-87a8e51081e9@xs4all.nl>
Date:   Fri, 20 Nov 2020 09:06:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201119144146.1045202-10-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfFkC2JJwDijdDHxk6QLdzYl86sxkzUvUR2rXQtLzS7Z3VCur8Sec0yc9/yj+teseucfM5Id3FSotdLzmsmr0WrYFYFXWblZvd586PxVzp7yalD+lMMTn
 /GP83mNKzjc5heCNLfvA46owaFZXBn0xPi+CrgcCTXCH+zCXDT/AugYk6WH31S/1fbilR/Bbn3VeP/VhTIjFK4ZkC7eOo9LJEqJWAP4kRBAdILmunjJmxXCT
 T9pw+MuwA6aQValWt8fR+2+Lohjgd26Kp3nsob/wGjkR2luEcNWBtmlzFVNrH+o+PP5aQAr4PDD+Z3dwOYMFNf76JTi6TFmlFZu78KxaX22EGz/bSPQghfFt
 yr7PTAmX010Y9mMvI/xJ8+OsZxM4+7H5b5EdPvoogEg/pCMQmvIqXLrivqredG5EOF57yPgwvUWyST9kqoBQZ0Y5vkkhX1LEjhptReds6BhrXH1RbB7N/mgZ
 ZNy1MjlvK64zXtOJ8uXaMBuHmzQtKNk3YzD5aJoakoowrkbNlF3olnS6jqrDz84rGP635GzH4xQ2JVz/bYDGw6/RyYu6BwKwqJsYho1oIn5pWJtwG6eL4Sys
 WJAb+ARL9Ka4wQ5SjbYr73z0jlMszhtNG0g91E+gV/ngoX+TfzOw3D4uv9zhis07qCCrZd9mZ+HYWRB2t95Ix5qwHZnN7P6GbcP06CUCv3W3u8KpUPI+dEI0
 b7vGOZDkWvFsE1dmLjD9sCa6x/ZGIgVOw626FWzt8bTHFsqPP2Z98RzxcN50nCJkPPI4P7rtQrMlsZmhmzigHBYPfh6cR7KNLyviHXr0Ek3rvsLoxjZOhR9P
 ZAaqSLxwNMHu8kbI+D4pvREzqEx2gbSD1KX/g26bCR0cSsz8hqf0mItBK2Ua6ADVuO/ZaLWD+DrKIUrbYZn3vfZdKI8Mrv3xJUieHzHB/b6gDHFWvMdfKJii
 mpsBubC9N+hw7++PiHs0zH7FLmEY2rO4oZf0kE/dqwF7EyrF
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/2020 15:41, Daniel Vetter wrote:
> The media model assumes that buffers are all preallocated, so that
> when a media pipeline is running we never miss a deadline because the
> buffers aren't allocated or available.
> 
> This means we cannot fix the v4l follow_pfn usage through
> mmu_notifier, without breaking how this all works. The only real fix
> is to deprecate userptr support for VM_IO | VM_PFNMAP mappings and
> tell everyone to cut over to dma-buf memory sharing for zerocopy.
> 
> userptr for normal memory will keep working as-is, this only affects
> the zerocopy userptr usage enabled in 50ac952d2263 ("[media]
> videobuf2-dma-sg: Support io userptr operations on io memory").
> 
> Acked-by: Tomasz Figa <tfiga@chromium.org>

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Thanks!

	Hans

> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Jérôme Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-mm@kvack.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: Pawel Osciak <pawel@osciak.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Tomasz Figa <tfiga@chromium.org>
> Cc: Laurent Dufour <ldufour@linux.ibm.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> Cc: Michel Lespinasse <walken@google.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> --
> v3:
> - Reference the commit that enabled the zerocopy userptr use case to
>   make it abundandtly clear that this patch only affects that, and not
>   normal memory userptr. The old commit message already explained that
>   normal memory userptr is unaffected, but I guess that was not clear
>   enough.
> ---
>  drivers/media/common/videobuf2/frame_vector.c | 2 +-
>  drivers/media/v4l2-core/videobuf-dma-contig.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/common/videobuf2/frame_vector.c b/drivers/media/common/videobuf2/frame_vector.c
> index a0e65481a201..1a82ec13ea00 100644
> --- a/drivers/media/common/videobuf2/frame_vector.c
> +++ b/drivers/media/common/videobuf2/frame_vector.c
> @@ -70,7 +70,7 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
>  			break;
>  
>  		while (ret < nr_frames && start + PAGE_SIZE <= vma->vm_end) {
> -			err = follow_pfn(vma, start, &nums[ret]);
> +			err = unsafe_follow_pfn(vma, start, &nums[ret]);
>  			if (err) {
>  				if (ret == 0)
>  					ret = err;
> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
> index 52312ce2ba05..821c4a76ab96 100644
> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
> @@ -183,7 +183,7 @@ static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
>  	user_address = untagged_baddr;
>  
>  	while (pages_done < (mem->size >> PAGE_SHIFT)) {
> -		ret = follow_pfn(vma, user_address, &this_pfn);
> +		ret = unsafe_follow_pfn(vma, user_address, &this_pfn);
>  		if (ret)
>  			break;
>  
> 

