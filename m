Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD0D62E392
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 18:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240032AbiKQRz4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 12:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240291AbiKQRzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 12:55:48 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6EF7FF2E;
        Thu, 17 Nov 2022 09:55:48 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id h193so2615344pgc.10;
        Thu, 17 Nov 2022 09:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1GKnYydXCYqxqW9dR7aXjYaf7V42K6rqe1svrcwQLNA=;
        b=SsPhA+/zwr2soeEEaWB0iEXVlj2pRXy3T+5MRNkg3gA5bYnDEY76LeiMkjnH6Gtuek
         VQBK8qn5HlwgpU7JZk31s67cl0oqPFk3/+E+STN+mOv1n0rSuGKwz4ufNl96yyvb+ehm
         aR16ZhBgByLcqtxYalWYt3DhzqpWD1xk7B/ERhHy5UROjXSA2O4WT484NF1gnxYt2zLo
         VhlagvXdWvqrnTC1Vpr/nXSDV94IDRsmmPKjuIzbKfxVwlbZ700ttpYm5thGIaufzUrk
         HWDdterCqcq4ySav4311fVhhOLzfuYpSaYvQzNRfmNvAt+J1fYmNxyHxf+meEu+3PzVd
         YRFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1GKnYydXCYqxqW9dR7aXjYaf7V42K6rqe1svrcwQLNA=;
        b=TkOn/q0TYypgvcItYVwdYw9qRENVqNoMzOyCXJV/l1sjxWsfcAhYbafpwg3gwEyEuX
         I94sNPdmxKAJQ8P0+6ww9LuTpeJ+o0mzwOOpmmF4pIql8cjSEYYkbSYUWVuK0iT9x3A+
         dtFSAgArJE6z8YtbuG0C6n45vmrv7m2Et/fbjI5/8GIMoDLp5jFgv6aaCAMQHysevL8I
         5gnVxqD5t0hEWjSUCXnPdOVyfxjsKtSaOBJC33ZIzgAXbfALIFYF76k8F6bo09ynwqw5
         fwbUo3jJ5/HdNVkV9MA8SEqCOjTj6P2aJJWfjyN+zZ5P+cjKGnuTyMN8+dGKZu4Ty0xU
         X71g==
X-Gm-Message-State: ANoB5pmldrGwdlerUPJA8ojU7sBUF+DxMpT1LwYQkhxoDiTsVxMIhWTA
        feqrtWaqwKTsF9uzONXaZBVVoN4Tsy4=
X-Google-Smtp-Source: AA0mqf6iXN48y71fjRlt9NKrGMiWHTqJP3NlCcBrojVNFQ5F8Uz85fLyhe10Tsd6646K6iiHVBVGYw==
X-Received: by 2002:a63:165d:0:b0:473:f7cd:6603 with SMTP id 29-20020a63165d000000b00473f7cd6603mr3055977pgw.336.1668707747710;
        Thu, 17 Nov 2022 09:55:47 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id h4-20020a170902680400b001870dc3b4c0sm1705264plk.74.2022.11.17.09.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 09:55:47 -0800 (PST)
Date:   Thu, 17 Nov 2022 09:55:46 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 032/108] KVM: x86/mmu: Make sync_page not use
 hard-coded 0 as the initial SPTE value
Message-ID: <20221117175546.GH2350331@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <adcc3484605cb460a0c00ee5673c83f32a88e6ca.1667110240.git.isaku.yamahata@intel.com>
 <3f805b540780494c4a5b068287c37e40d71d7ba4.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3f805b540780494c4a5b068287c37e40d71d7ba4.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022 at 11:24:44AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Sat, 2022-10-29 at 23:22 -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > FNAME(sync_page) in arch/x86/kvm/mmu/paging_tmpl.h assumes that the initial
> > shadow page table entry (SPTE) is zero.  Remove the assumption by using
> > SHADOW_NONPRESENT_VALUE that will be updated from 0 to non-zero value.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/mmu/paging_tmpl.h | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> > index 5ab5f94dcb6f..6db3f2b5563a 100644
> > --- a/arch/x86/kvm/mmu/paging_tmpl.h
> > +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> > @@ -1036,7 +1036,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
> >  		gpa_t pte_gpa;
> >  		gfn_t gfn;
> >  
> > -		if (!sp->spt[i])
> > +		/* spt[i] has initial value of shadow page table allocation */
> > +		if (sp->spt[i] == SHADOW_NONPRESENT_VALUE)
> >  			continue;
> >  
> >  		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
> 
> I think this patch can be merged to previous one?  Looks there's no good reason
> to keep it as standalone.

Yes, will squash it.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
