Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208B26A4DA6
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 23:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjB0WAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 17:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjB0WAJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 17:00:09 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEE5CDFE;
        Mon, 27 Feb 2023 14:00:08 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id fd25so4513956pfb.1;
        Mon, 27 Feb 2023 14:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5qhpjZfNdRtjVel0I/yXwtako5kEQeDvzo0q9rOV9RQ=;
        b=K7eBsLuVSwHtNne0XIEwVi8XEFwiXla4t006Y7i67MTAuu79N9f1tVx8OmPnLmfYjF
         HQqFQ3xU1lp+oGzRT8GDuUWfD+wiogFUo4U6ZtCZ6VtcHsqXp3/VzZCOlfeYmibMQRMl
         fFL6YLvbiQJ7EG4D7ePX6QY8FF0C9huTMXcFUvdLs8o9UfUldd1UbPUL59jvCl1E23xh
         H+snKeHVZbVsC50Iwa5G2svhzqVI6NCMmWe78XkVMjHGWHfdTUZK+CzVxbiFyhA5qsHx
         8UIj0+i32m1rFDvxQ36954r9Xv9QyWXGkhtl1314xu70U0alxjbyIGK9FXUXtgBNlOdS
         2vEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5qhpjZfNdRtjVel0I/yXwtako5kEQeDvzo0q9rOV9RQ=;
        b=IgHZZuL+ZOOqufRvQ0pN1DdXXbLWrTbQgeS9T2X3xgtub4wTAYKwPpvI0Ac/2vhrSd
         F7oNLN5ZXvlsFlRNaUcXM3q1dSYqetsFlxKDMF/+/nPZoDanZKB277aB4CDwoZJPbdq1
         o8OrG499yKUPvcIgN74T/spDiRs5t0zr1wtQgOgye5wNO3dYI8LuR1H1jrhVBdfCAxkC
         230gqZLz7UKAOkSPn3JItqN6aqFF+b92a4UorY6Ex2ZIv2E+AyLZrhez5HZpWQwEmhsn
         MrgEAd0guIETCI/Vh3W8WRFg1boHqkGD7jWhO+3x0JAnF2AGxKLMfxtPKu7jrSr5oipl
         T9Ww==
X-Gm-Message-State: AO0yUKUGFZQvIeVshfU1HkQRHE+hrJsii55R/5/mQ2MV5h+cB9PgY0+G
        LXePJYQwBhG1gyWOFXeitXU=
X-Google-Smtp-Source: AK7set+IFQpMN7UgHAV4uGi/YU9FwUb2MzB4RbHeeI4yYgRMqlYu9H71M7FcEvKYtvCWzRyf7Ek6qw==
X-Received: by 2002:a62:5e05:0:b0:5e8:6839:1f13 with SMTP id s5-20020a625e05000000b005e868391f13mr466460pfb.10.1677535207592;
        Mon, 27 Feb 2023 14:00:07 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id k4-20020aa790c4000000b005cdf83e4513sm4808758pfk.145.2023.02.27.14.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 14:00:07 -0800 (PST)
Date:   Mon, 27 Feb 2023 14:00:05 -0800
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
Subject: Re: [PATCH v11 050/113] KVM: x86/tdp_mmu: Ignore unsupported mmu
 operation on private GFNs
Message-ID: <20230227220005.GO4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <7a0fb2a0dddc87fb8d34d5af8fc73b288dbcc63c.1673539699.git.isaku.yamahata@intel.com>
 <945d4ad2b415776a642f4f1f934d1a780a7423f2.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <945d4ad2b415776a642f4f1f934d1a780a7423f2.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 17, 2023 at 02:40:46AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Thu, 2023-01-12 at 08:31 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Some KVM MMU operations (dirty page logging, page migration, aging page)
> > aren't supported for private GFNs (yet) with the first generation of TDX.
> > Silently return on unsupported TDX KVM MMU operations.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> 
> You already have previous patches to do similar things:
> 
> [PATCH v11 034/113] KVM: x86/mmu: Disallow fast page fault on private GPA
> [PATCH v11 043/113] KVM: x86/tdp_mmu: Don't zap private pages for unsupported
> cases
> [PATCH v11 048/113] KVM: x86/mmu: Disallow dirty logging for x86 TDX
> [PATCH v11 049/113] KVM: x86/mmu: TDX: Do not enable page track for TD guest
> 
> Now you have this patch:
> 
> [PATCH v11 050/113] KVM: x86/tdp_mmu: Ignore unsupported mmu operation on
> private GFNs
> 
> They are very confusing to me.  Those previous patches are all "unsupported
> operations", correct? 
> 
> For instance, this patch says "dirty page logging isn't supported for private
> GFNs" (and why there's a 'yet' after it?), so based on the patch title my
> understanding is you are going to _ignore_ "dirty page logging".  But you
> already have a previous patch to "Disallow dirty logging for x86 TDX".  
> 
> Shouldn't the two be in the same patch?  Or you were trying to highlight the
> different between "x86/mmu" and "x86/tdp_mmu"?
> 
> Please try to make the whole thing more clear.  My first glance is, if it was
> me, I would probably have _ONE_ dedicated patch for _EACH_ unsupported
> operation, and make it very clear in the patch title.  But you may have your own
> way to make things more clearer.

Agreed, merged this patch into [PATCH v11 048/113] KVM: x86/mmu: Disallow dirty
logging for x86 TDX.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
