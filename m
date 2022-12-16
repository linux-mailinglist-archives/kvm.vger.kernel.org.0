Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8FD64E530
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 01:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiLPAbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 19:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLPAbI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 19:31:08 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4DC15A38;
        Thu, 15 Dec 2022 16:31:02 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id t2so744219ply.2;
        Thu, 15 Dec 2022 16:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yKbmC/BUWe2Skgy24gEB88WIVLdWS5iSoZaJ20Drb+A=;
        b=LrwqSBhSEETpyjkngjzIkOIJE5n7hi+noNtVTBb3gvuhDPsJ+Lwo5Z6rvuu3PZsTcR
         yeLb4ocrvVDNU75YEf97WC7CCPkAiksCFtmfGU3StGPPy0RFdrPEhh0kIM83xO1VU6VL
         ugx2ZL34wF9NTf8LtYbe+IC5gaKabXTN2fA5CfJ3RJkXdmFZI6011fu/zYFkvpYtUKyO
         ONaRyPEm4vT50xWNFz1u99mVwSIuofipRTMbU26XUDChd/awkfIkriP4Wlx1lnuJHbpo
         GQ8jsD72AGWuoXuDXTclN52ZsyZyXHck2v78WqeH4X5tN9WtnsHLb1B3oB1fgTYU1FLl
         UAHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yKbmC/BUWe2Skgy24gEB88WIVLdWS5iSoZaJ20Drb+A=;
        b=3PMqdJD5DFyGE3kgM7VPMc5WXucjzkD57r6rcw2XiTEgkcyH+2uIKz8kvzJt7vdAFW
         KA+fbPW7Xe5CuLsaVCDadqjQtJRMCTeYiaM/Nrzryw9zC4m7kg6mjtdc5HK9eJynhbMT
         qRjazA2k6Yd7Xfo7ZquONvqGtvEMO2uNKt8E7VCDbihCeIkV27bsNqi3wEHsCyafPe6N
         IqnetZ0Nbd3ObcxfL+wwhbJXnDslrSR7fb2/v+dH8copBOOPrTjMtmS3EMbE16naJcrz
         XQQS9i2OYoZ3rbCdlVU+/h6tGPBSnk0ACLSRnsEdNY7JmlfKP2hAPd7io/zUaZ96i7AB
         EUJA==
X-Gm-Message-State: ANoB5pmMpDeUq80KqFmHTyz1LZkFyktxOw1sjyIB5ObJFScz/VGdRYdb
        GG/u0hWuTqRbuQHNIHCtPuM=
X-Google-Smtp-Source: AA0mqf4khg0fh4poeCJoVDuNU5EdjIx8lsemv3eKHCj8Fv1wOEPnZb14yI88x8hIa1SloNUrkVYY0w==
X-Received: by 2002:a05:6a21:9187:b0:a7:8919:3312 with SMTP id tp7-20020a056a21918700b000a789193312mr34624940pzb.29.1671150662434;
        Thu, 15 Dec 2022 16:31:02 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id r6-20020a635146000000b0046ae5cfc3d5sm282339pgl.61.2022.12.15.16.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 16:31:02 -0800 (PST)
Date:   Thu, 15 Dec 2022 16:31:00 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Vishal Annapurve <vannapurve@google.com>
Cc:     binbin.wu@linux.intel.com, dmatlack@google.com,
        erdemaktas@google.com, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        sagis@google.com, seanjc@google.com
Subject: Re: [PATCH v10 062/108] KVM: x86/tdp_mmu: implement MapGPA hypercall
 for TDX
Message-ID: <20221216003100.GM3632095@ls.amr.corp.intel.com>
References: <b49d953a-61f0-e466-90d2-713e25dff770@linux.intel.com>
 <20221209000130.1380904-1-vannapurve@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221209000130.1380904-1-vannapurve@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022 at 12:01:30AM +0000,
Vishal Annapurve <vannapurve@google.com> wrote:

> > +int __kvm_mmu_map_gpa(struct kvm *kvm, gfn_t *startp, gfn_t end,
> > +		      bool map_private)
> > +{
> > +	gfn_t start = *startp;
> > +	int attr;
> > +	int ret;
> > +
> > +	if (!kvm_gfn_shared_mask(kvm))
> > +		return -EOPNOTSUPP;
> > +
> > +	attr = map_private ? KVM_MEM_ATTR_PRIVATE : KVM_MEM_ATTR_SHARED;
> > +	start = start & ~kvm_gfn_shared_mask(kvm);
> > +	end = end & ~kvm_gfn_shared_mask(kvm);
> > +
> > +	/*
> > +	 * To make the following kvm_vm_set_mem_attr() success within spinlock
> > +	 * without memory allocation.
> > +	 */
> > +	ret = kvm_vm_reserve_mem_attr(kvm, start, end);
> > +	if (ret)
> > +		return ret;
> > +
> > +	write_lock(&kvm-> mmu_lock);
> > +	if (is_tdp_mmu_enabled(kvm)) {
> > +		gfn_t s = start;
> > +
> > +		ret = kvm_tdp_mmu_map_gpa(kvm, &s, end, map_private);
> > +		if (!ret) {
> > +			KVM_BUG_ON(kvm_vm_set_mem_attr(kvm, attr, start, end), kvm);
> 
> This will result in no exits to userspace during memory conversion requests from
> guests. And as a result, userspace will not be able to explicitly back/unback
> shared/private memory during conversions leading to double allocation of memory.
> 
> Is this an intended behavior for memory conversion with TDX VMs as per earlier
> discussion?

It was because UPM ioctl interface was not stable yet. With v10, it seems mostly
stable, I'll change the patch of "[PATCH v10 101/108] KVM: TDX: Handle TDX PV
map_gpa hypercall" to exit to user space.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
