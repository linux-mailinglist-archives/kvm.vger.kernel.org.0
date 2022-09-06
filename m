Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855CB5AF56E
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 22:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiIFUHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 16:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbiIFUHC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 16:07:02 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83A7B9FBE
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 13:02:26 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id n17-20020a05600c501100b003a84bf9b68bso8084224wmr.3
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 13:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date;
        bh=O5EcAc3lvXGI4JQrr9YrLyEGo4R9/Yu+CBbQ8ensU3s=;
        b=OJjVDKh3fcI/VQtO8L3fMXmkefvnaZ2TPXs4g3bDwXhiEMKG2tIGFa9WR1Rh+3uUBR
         zdGGM9Rmc74vfA+iORlSEN0n6yp66wZtNXZv0fPfYCTohNw3OZcMD+6dfcpdnPYyiwnh
         QoNnAEdgtugwvr2kaVFYcJT6RkBCn/qtM199k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=O5EcAc3lvXGI4JQrr9YrLyEGo4R9/Yu+CBbQ8ensU3s=;
        b=8C/XAL+rYB1Y1nLeCCCpEFWoKPsvdSRf7mc3cJp244mUP/Ke9nLxYgo6nXQb/i9F/t
         yIxGc1mdXBVvkiJPuaUPi3EKxbO1Gz1tJ9QwOKSB8eFobGm2De1z67M2tGW7oaIpjSo5
         5/Ewc6pXRR0prV71cdSr0nSP+ph4ETdUId1bww2lzj+KXGbJ3h3o/fbYhzT+kT7G10UP
         xWPwYmo0fZFrErd477QR998xXtPNJ30nfXiHInBlU7+oE9IamR9hYsbNN4w7A5zCWzRP
         tzwa/r4MXElD/jB1lBABiLYnbdYUWfvSYwlF1Fb/Dgt9W2psxCUoH4rlYguknE8thHZL
         cx+A==
X-Gm-Message-State: ACgBeo2KFPwS1YBxM0ILABpJWnBcORc+yIES4YmANqFyS1fviSxLyWxB
        L1q6QGDsawRqt4O0Qg4ADrUZFg==
X-Google-Smtp-Source: AA6agR65s22H1tafLgmg1vAilgOCZbkdlz33Ij5qA3Rkmxo9dxUOa6iRjfhaDOHPYMF30Bz5WXKt1A==
X-Received: by 2002:a05:600c:34d2:b0:3a5:afe5:3eb5 with SMTP id d18-20020a05600c34d200b003a5afe53eb5mr14724108wmq.122.1662494510204;
        Tue, 06 Sep 2022 13:01:50 -0700 (PDT)
Received: from phenom.ffwll.local (212-51-149-33.fiber7.init7.net. [212.51.149.33])
        by smtp.gmail.com with ESMTPSA id y2-20020adfd082000000b0021d6924b777sm13896061wrh.115.2022.09.06.13.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 13:01:49 -0700 (PDT)
Date:   Tue, 6 Sep 2022 22:01:47 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc:     Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        David Airlie <airlied@linux.ie>, Huang Rui <ray.huang@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Trigger Huang <Trigger.Huang@gmail.com>,
        Gert Wollny <gert.wollny@collabora.com>,
        Antonio Caggiano <antonio.caggiano@collabora.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>, kvm@vger.kernel.org,
        kernel@collabora.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v1] drm/ttm: Refcount allocated tail pages
Message-ID: <YxenK8xZHC6Q4Eu4@phenom.ffwll.local>
Mail-Followup-To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        David Airlie <airlied@linux.ie>, Huang Rui <ray.huang@amd.com>,
        Trigger Huang <Trigger.Huang@gmail.com>,
        Gert Wollny <gert.wollny@collabora.com>,
        Antonio Caggiano <antonio.caggiano@collabora.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>, kvm@vger.kernel.org,
        kernel@collabora.com, virtualization@lists.linux-foundation.org
References: <20220815095423.11131-1-dmitry.osipenko@collabora.com>
 <8230a356-be38-f228-4a8e-95124e8e8db6@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8230a356-be38-f228-4a8e-95124e8e8db6@amd.com>
X-Operating-System: Linux phenom 5.18.0-4-amd64 
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_TEMPERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 15, 2022 at 12:05:19PM +0200, Christian König wrote:
> Am 15.08.22 um 11:54 schrieb Dmitry Osipenko:
> > Higher order pages allocated using alloc_pages() aren't refcounted and they
> > need to be refcounted, otherwise it's impossible to map them by KVM. This
> > patch sets the refcount of the tail pages and fixes the KVM memory mapping
> > faults.
> > 
> > Without this change guest virgl driver can't map host buffers into guest
> > and can't provide OpenGL 4.5 profile support to the guest. The host
> > mappings are also needed for enabling the Venus driver using host GPU
> > drivers that are utilizing TTM.
> > 
> > Based on a patch proposed by Trigger Huang.
> 
> Well I can't count how often I have repeated this: This is an absolutely
> clear NAK!
> 
> TTM pages are not reference counted in the first place and because of this
> giving them to virgl is illegal.
> 
> Please immediately stop this completely broken approach. We have discussed
> this multiple times now.

Yeah we need to get this stuff closed for real by tagging them all with
VM_IO or VM_PFNMAP asap.

It seems ot be a recurring amount of fun that people try to mmap dma-buf
and then call get_user_pages on them.

Which just doesn't work. I guess this is also why Rob Clark send out that
dma-buf patch to expos mapping information (i.e. wc vs wb vs uncached).

There seems to be some serious bonghits going on :-/
-Daniel

> 
> Regards,
> Christian.
> 
> > 
> > Cc: stable@vger.kernel.org
> > Cc: Trigger Huang <Trigger.Huang@gmail.com>
> > Link: https://www.collabora.com/news-and-blog/blog/2021/11/26/venus-on-qemu-enabling-new-virtual-vulkan-driver/#qcom1343
> > Tested-by: Dmitry Osipenko <dmitry.osipenko@collabora.com> # AMDGPU (Qemu and crosvm)
> > Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
> > ---
> >   drivers/gpu/drm/ttm/ttm_pool.c | 25 ++++++++++++++++++++++++-
> >   1 file changed, 24 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.c
> > index 21b61631f73a..11e92bb149c9 100644
> > --- a/drivers/gpu/drm/ttm/ttm_pool.c
> > +++ b/drivers/gpu/drm/ttm/ttm_pool.c
> > @@ -81,6 +81,7 @@ static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
> >   	unsigned long attr = DMA_ATTR_FORCE_CONTIGUOUS;
> >   	struct ttm_pool_dma *dma;
> >   	struct page *p;
> > +	unsigned int i;
> >   	void *vaddr;
> >   	/* Don't set the __GFP_COMP flag for higher order allocations.
> > @@ -93,8 +94,10 @@ static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
> >   	if (!pool->use_dma_alloc) {
> >   		p = alloc_pages(gfp_flags, order);
> > -		if (p)
> > +		if (p) {
> >   			p->private = order;
> > +			goto ref_tail_pages;
> > +		}
> >   		return p;
> >   	}
> > @@ -120,6 +123,23 @@ static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
> >   	dma->vaddr = (unsigned long)vaddr | order;
> >   	p->private = (unsigned long)dma;
> > +
> > +ref_tail_pages:
> > +	/*
> > +	 * KVM requires mapped tail pages to be refcounted because put_page()
> > +	 * is invoked on them in the end of the page fault handling, and thus,
> > +	 * tail pages need to be protected from the premature releasing.
> > +	 * In fact, KVM page fault handler refuses to map tail pages to guest
> > +	 * if they aren't refcounted because hva_to_pfn_remapped() checks the
> > +	 * refcount specifically for this case.
> > +	 *
> > +	 * In particular, unreferenced tail pages result in a KVM "Bad address"
> > +	 * failure for VMMs that use VirtIO-GPU when guest's Mesa VirGL driver
> > +	 * accesses mapped host TTM buffer that contains tail pages.
> > +	 */
> > +	for (i = 1; i < 1 << order; i++)
> > +		page_ref_inc(p + i);
> > +
> >   	return p;
> >   error_free:
> > @@ -133,6 +153,7 @@ static void ttm_pool_free_page(struct ttm_pool *pool, enum ttm_caching caching,
> >   {
> >   	unsigned long attr = DMA_ATTR_FORCE_CONTIGUOUS;
> >   	struct ttm_pool_dma *dma;
> > +	unsigned int i;
> >   	void *vaddr;
> >   #ifdef CONFIG_X86
> > @@ -142,6 +163,8 @@ static void ttm_pool_free_page(struct ttm_pool *pool, enum ttm_caching caching,
> >   	if (caching != ttm_cached && !PageHighMem(p))
> >   		set_pages_wb(p, 1 << order);
> >   #endif
> > +	for (i = 1; i < 1 << order; i++)
> > +		page_ref_dec(p + i);
> >   	if (!pool || !pool->use_dma_alloc) {
> >   		__free_pages(p, order);
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
