Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D5F5721A8
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 19:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbiGLRWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 13:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiGLRWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 13:22:54 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E6A7FE71;
        Tue, 12 Jul 2022 10:22:53 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o15so8406442pjh.1;
        Tue, 12 Jul 2022 10:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wn44vmZF7ZCsPiLqV7Yl4fs8sVOrgYJYOCwEWGHZPts=;
        b=O0aDBxAxZu9L3eRQ8FAC63FmGRfZyGx6gwPpk7RBdvQV2DExJSgMY9dWoLvG9Y9UGG
         QMHo66Y6rseSS6qMeFCfW2elkCeyML3hgus3rAQmoLmX4qvgCBEsG4jxfulgAqdLodKV
         qlZVej+ub0vqHMWC6vlyTI3sFxoy7fCfy9u5qUgariNxVh73r376fqPP4LXV8EXLWsEt
         SprMEBOmQhyuAjnCZdLlflwX7o+jyeTQXAwNQEcM6hyJiLNmz1UHSzcYUGAsbhxZU/bh
         HwOGH8volOEj9rqHc8oBz6i3ArjFtFCt+K9uPmPWc0oD1fxO/oShlqHgbtJ9KAUuIt1S
         RTNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wn44vmZF7ZCsPiLqV7Yl4fs8sVOrgYJYOCwEWGHZPts=;
        b=k2keG4xaGy9TPsvxPs1CAl/xCvJF2e8F4qhrGr1cPNGfkMlf57I5FWRY++ddt6CZP0
         E8/8XwBRQHRtsA/npLxhQu9HzWhl1kyh8SlROQlEe4UlAy7IGER+XR9pUHZ2TRNFfTJM
         tjI3FqHLFrKGK1kHwYuHPwLAugchrPv2bFTwaVLBYhv58CaOPso9sK80mfe0duF5wwdK
         /aOByE8fSxbwzgI/0vbsd4bAHMWC/qEwkWd6voKaqT49f+XBOtMTzX4U6NgcZb+1EjFy
         vvIHXC0AoHTsbVpwugX3XilqCFZRXj3IzKj/PCQZem5VCoe67uLXVl6GPlvAmLjZ0Frr
         EjqA==
X-Gm-Message-State: AJIora/c8t2pJsg/4xaPvGnfZfFOsfxpbDTdplWG/u6jUlgWiqtAfEDi
        51UriEnQRCLCl8lKrodpYPnfJ6RKvuA=
X-Google-Smtp-Source: AGRyM1tEPokrF+nMxiPARKUgDBDQTPHDmjWtprRbWD60JdcasBSdEgQwUmi3SYv2oJmO4j4D5Q9k0g==
X-Received: by 2002:a17:90b:1488:b0:1ef:82bb:5f08 with SMTP id js8-20020a17090b148800b001ef82bb5f08mr5573929pjb.214.1657646572881;
        Tue, 12 Jul 2022 10:22:52 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id t6-20020a632246000000b0041296135280sm1926788pgm.88.2022.07.12.10.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 10:22:51 -0700 (PDT)
Date:   Tue, 12 Jul 2022 10:22:50 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Chao Peng <chao.p.peng@linux.intel.com>
Cc:     Chao Gao <chao.gao@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        chao.p.peng@intel.com
Subject: Re: [PATCH v7 000/102] KVM TDX basic feature support
Message-ID: <20220712172250.GJ1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <20220711151701.GA1375147@ls.amr.corp.intel.com>
 <20220712050714.GA26573@gao-cwp>
 <20220712105419.GB2805143@chaop.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220712105419.GB2805143@chaop.bj.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022 at 06:54:19PM +0800,
Chao Peng <chao.p.peng@linux.intel.com> wrote:

> On Tue, Jul 12, 2022 at 01:07:20PM +0800, Chao Gao wrote:
> > On Mon, Jul 11, 2022 at 08:17:01AM -0700, Isaku Yamahata wrote:
> > >Hi. Because my description on large page support was terse, I wrote up more
> > >detailed one.  Any feedback/thoughts on large page support?
> > >
> > >TDP MMU large page support design
> > >
> > >Two main discussion points
> > >* how to track page status. private vs shared, no-largepage vs can-be-largepage
> > 
> > ...
> > 
> > >
> > >Tracking private/shared and large page mappable
> > >-----------------------------------------------
> > >VMM needs to track that page is mapped as private or shared at 4KB granularity.
> > >For efficiency of EPT violation path (****), at 2MB and 1GB level, VMM should
> > >track the page can be mapped as a large page (regarding private/shared).  VMM
> > >updates it on MapGPA and references it on the EPT violation path. (****)
> > 
> > Isaku,
> > 
> > + Peng Chao
> > 
> > Doesn't UPM guarantee that 2MB/1GB large page in CR3 should be either all
> > private or all shared?
> > 
> > KVM always retrieves the mapping level in CR3 and enforces that EPT's
> > page level is not greater than that in CR3. My point is if UPM already enforces
> > no mixed pages in a large page, then KVM needn't do that again (UPM can
> > be trusted).
> 
> The backing store in the UMP can tell KVM which page level it can
> support for a given private gpa, similar to host_pfn_mapping_level() for
> shared address.
>
> However, this solely represents the backing store's capability, KVM
> still needs additional info to decide whether that can be safely mapped
> as 2M/1G, e.g. all the following pages in the 2M/1G range should be all
> private, currently this is not something backing store can tell.

This argument applies to shared GPA.  The shared pages is backed by normal file
mapping with UPM.  When KVM is mapping shared GPA, the same check is needed.  So
I think KVM has to track all private or all shared or no-largepage at 2MB/1GB
level.  If UPM tracks shared-or-private at 4KB level, probably KVM may not need to
track it at 4KB level.


> Actually, in UPM v7 we let KVM record this info so one possible solution
> is making use of it.
> 
>   https://lkml.org/lkml/2022/7/6/259
> 
> Then to map a page as 2M, KVM needs to check:
>   - Memory backing store support that level
>   - All pages in 2M range are private as we recorded through
>     KVM_MEMORY_ENCRYPT_{UN,}REG_REGION
>   - No existing partial 4K map(s) in 2M range
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
