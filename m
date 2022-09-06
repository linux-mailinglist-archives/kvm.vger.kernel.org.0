Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD1C5AF581
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 22:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbiIFULR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 16:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiIFUK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 16:10:56 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E646C0BE0
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 13:05:43 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id k6-20020a05600c1c8600b003a54ecc62f6so8097045wms.5
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 13:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:to:from
         :date:from:to:cc:subject:date;
        bh=c/UsxweYx46AtL1DrAVsnOTkZkntK4Jt2WwuEBuVBzE=;
        b=BIZ0Q/ukdR5e8iBKd7CK7xTCph8PA4xDeCDAuT0ilInjv6/CXXpk2vswtwj06vQTut
         jSztYj68KfnrEQ1l+jMYYFIp1TaZ9AHjui7bxO2qIXvmXnfIT6zdQzp36XPDWemNsC1E
         yz6w1C0iA2azNn9h4SAmSijOrJiZ0W178kjP8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:to:from
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=c/UsxweYx46AtL1DrAVsnOTkZkntK4Jt2WwuEBuVBzE=;
        b=cBNS9u2vnjNaNggr3QZ0PbO/32CI3NA73ea84tHTLo3w6x9kLHu20hLDqOfsA1+4zP
         vQJg7aV2ZixJbDv86Y2Pg1OnBlnfWhC7s8UEPi+v5u7z2mJCAjWIUGvveCG+0IF0VsvA
         mC5Tp6IeFgudMGmZv8yC8u68z7IBvAGq8KMASFkJRnoTJGyC3ota7OtETQMN3qyjw0RE
         6uHk+TUYb4WljyGYCpMZcGmW3z7Kn7s5l4JHsn+67R1dMfL9q0cC2Ir98uHNDiRry9Rd
         w4Y134fOPasAPsaG1jnoXqj6rgUArf6bQ2aId/UDQOjTEl4lVyBNercrTqBeb2qrXauP
         A1Sw==
X-Gm-Message-State: ACgBeo2zZLw3DoqV5pq4gvLJ6kZbLR/g7ttFRZ61jrNI1WuTzjHiC3iA
        XREaWCPtoYL8JVizZlYf2qiv7w==
X-Google-Smtp-Source: AA6agR52xlQCRWj/b3iUB8MkVLnvM+veWz5+Ya5VF/kMkQLeItZ5yTKo+e9fQ+u56AttgY9ZLonVMQ==
X-Received: by 2002:a05:600c:19cb:b0:3a8:4622:ad3d with SMTP id u11-20020a05600c19cb00b003a84622ad3dmr14508871wmq.37.1662494740716;
        Tue, 06 Sep 2022 13:05:40 -0700 (PDT)
Received: from phenom.ffwll.local (212-51-149-33.fiber7.init7.net. [212.51.149.33])
        by smtp.gmail.com with ESMTPSA id o12-20020a05600c378c00b003a5f4fccd4asm21521437wmr.35.2022.09.06.13.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 13:05:40 -0700 (PDT)
Date:   Tue, 6 Sep 2022 22:05:38 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        David Airlie <airlied@linux.ie>, Huang Rui <ray.huang@amd.com>,
        Trigger Huang <Trigger.Huang@gmail.com>,
        Gert Wollny <gert.wollny@collabora.com>,
        Antonio Caggiano <antonio.caggiano@collabora.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>, kvm@vger.kernel.org,
        kernel@collabora.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v1] drm/ttm: Refcount allocated tail pages
Message-ID: <YxeoEr6xAtlZ+IrU@phenom.ffwll.local>
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
 <YxenK8xZHC6Q4Eu4@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YxenK8xZHC6Q4Eu4@phenom.ffwll.local>
X-Operating-System: Linux phenom 5.18.0-4-amd64 
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_TEMPERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 06, 2022 at 10:01:47PM +0200, Daniel Vetter wrote:
> On Mon, Aug 15, 2022 at 12:05:19PM +0200, Christian König wrote:
> > Am 15.08.22 um 11:54 schrieb Dmitry Osipenko:
> > > Higher order pages allocated using alloc_pages() aren't refcounted and they
> > > need to be refcounted, otherwise it's impossible to map them by KVM. This
> > > patch sets the refcount of the tail pages and fixes the KVM memory mapping
> > > faults.
> > > 
> > > Without this change guest virgl driver can't map host buffers into guest
> > > and can't provide OpenGL 4.5 profile support to the guest. The host
> > > mappings are also needed for enabling the Venus driver using host GPU
> > > drivers that are utilizing TTM.
> > > 
> > > Based on a patch proposed by Trigger Huang.
> > 
> > Well I can't count how often I have repeated this: This is an absolutely
> > clear NAK!
> > 
> > TTM pages are not reference counted in the first place and because of this
> > giving them to virgl is illegal.
> > 
> > Please immediately stop this completely broken approach. We have discussed
> > this multiple times now.
> 
> Yeah we need to get this stuff closed for real by tagging them all with
> VM_IO or VM_PFNMAP asap.

For a bit more context: Anything mapping a bo should be VM_SPECIAL. And I
think we should add the checks to the gem and dma-buf mmap functions to
validate for that, and fix all the fallout.

Otherwise this dragon keeps resurrecting ...

VM_SPECIAL _will_ block get_user_pages, which will block everyone from
even trying to refcount this stuff.

Minimally we need to fix this for all ttm drivers, and it sounds like
that's still not yet the case :-( Iirc last time around some funky amdkfd
userspace was the hold-up because regressions?
-Daniel

> 
> It seems ot be a recurring amount of fun that people try to mmap dma-buf
> and then call get_user_pages on them.
> 
> Which just doesn't work. I guess this is also why Rob Clark send out that
> dma-buf patch to expos mapping information (i.e. wc vs wb vs uncached).
> 
> There seems to be some serious bonghits going on :-/
> -Daniel
> 
> > 
> > Regards,
> > Christian.
> > 
> > > 
> > > Cc: stable@vger.kernel.org
> > > Cc: Trigger Huang <Trigger.Huang@gmail.com>
> > > Link: https://www.collabora.com/news-and-blog/blog/2021/11/26/venus-on-qemu-enabling-new-virtual-vulkan-driver/#qcom1343
> > > Tested-by: Dmitry Osipenko <dmitry.osipenko@collabora.com> # AMDGPU (Qemu and crosvm)
> > > Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
> > > ---
> > >   drivers/gpu/drm/ttm/ttm_pool.c | 25 ++++++++++++++++++++++++-
> > >   1 file changed, 24 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.c
> > > index 21b61631f73a..11e92bb149c9 100644
> > > --- a/drivers/gpu/drm/ttm/ttm_pool.c
> > > +++ b/drivers/gpu/drm/ttm/ttm_pool.c
> > > @@ -81,6 +81,7 @@ static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
> > >   	unsigned long attr = DMA_ATTR_FORCE_CONTIGUOUS;
> > >   	struct ttm_pool_dma *dma;
> > >   	struct page *p;
> > > +	unsigned int i;
> > >   	void *vaddr;
> > >   	/* Don't set the __GFP_COMP flag for higher order allocations.
> > > @@ -93,8 +94,10 @@ static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
> > >   	if (!pool->use_dma_alloc) {
> > >   		p = alloc_pages(gfp_flags, order);
> > > -		if (p)
> > > +		if (p) {
> > >   			p->private = order;
> > > +			goto ref_tail_pages;
> > > +		}
> > >   		return p;
> > >   	}
> > > @@ -120,6 +123,23 @@ static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
> > >   	dma->vaddr = (unsigned long)vaddr | order;
> > >   	p->private = (unsigned long)dma;
> > > +
> > > +ref_tail_pages:
> > > +	/*
> > > +	 * KVM requires mapped tail pages to be refcounted because put_page()
> > > +	 * is invoked on them in the end of the page fault handling, and thus,
> > > +	 * tail pages need to be protected from the premature releasing.
> > > +	 * In fact, KVM page fault handler refuses to map tail pages to guest
> > > +	 * if they aren't refcounted because hva_to_pfn_remapped() checks the
> > > +	 * refcount specifically for this case.
> > > +	 *
> > > +	 * In particular, unreferenced tail pages result in a KVM "Bad address"
> > > +	 * failure for VMMs that use VirtIO-GPU when guest's Mesa VirGL driver
> > > +	 * accesses mapped host TTM buffer that contains tail pages.
> > > +	 */
> > > +	for (i = 1; i < 1 << order; i++)
> > > +		page_ref_inc(p + i);
> > > +
> > >   	return p;
> > >   error_free:
> > > @@ -133,6 +153,7 @@ static void ttm_pool_free_page(struct ttm_pool *pool, enum ttm_caching caching,
> > >   {
> > >   	unsigned long attr = DMA_ATTR_FORCE_CONTIGUOUS;
> > >   	struct ttm_pool_dma *dma;
> > > +	unsigned int i;
> > >   	void *vaddr;
> > >   #ifdef CONFIG_X86
> > > @@ -142,6 +163,8 @@ static void ttm_pool_free_page(struct ttm_pool *pool, enum ttm_caching caching,
> > >   	if (caching != ttm_cached && !PageHighMem(p))
> > >   		set_pages_wb(p, 1 << order);
> > >   #endif
> > > +	for (i = 1; i < 1 << order; i++)
> > > +		page_ref_dec(p + i);
> > >   	if (!pool || !pool->use_dma_alloc) {
> > >   		__free_pages(p, order);
> > 
> 
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
