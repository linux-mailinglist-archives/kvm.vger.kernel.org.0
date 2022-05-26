Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76527535465
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 22:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347514AbiEZU1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 16:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbiEZU1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 16:27:08 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AE5F5A3
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 13:27:07 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id h186so2219696pgc.3
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 13:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hK3ULfxu4d3bVNXhOv+N4/y59AUq5R7yu3MMv9k/2+w=;
        b=rLcLmqKbwp35p4AGCIm1BGwOrP2oLLcybaOH1Zq3/w9p2VR9DsW3uFdyGG2uiAcYyd
         zDM9obr9y7aPhXr1vH+xbOrE7kCAvOJ/ldMBFZakTuwmBuoGD8JA9+nzZio+cVl7gdmn
         9Oz3LeJk35Yj1vPhqtF+OsMqbMP7M8OQGyyyXmqqlAvIugAbjEzGQAUxf1oIHa6bpKTc
         iNAcMxy1emu9Cy9yd+u4RnfT4kqGEqOQ+78N1EiVXK+5qBTx7JnOuqCY/Bc3VsSrgLp8
         /haJm3eCrPxTo9GDFB3a+oDALWpNaj8r/k+jAq8wEkpbFYRGYA+9zFLH5KgXOgLYN25N
         BuAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hK3ULfxu4d3bVNXhOv+N4/y59AUq5R7yu3MMv9k/2+w=;
        b=5rB/gCX+LNLlXKCSuOXU5QFHFKBx2X68ls8ouRZJJWQXJSpLzgSJ3vDcTi0Y7cKyJY
         0x/YjjsD1YD9bvaRStHWvp4wGkaw3uO7qRRKEmVfh5lfAyy8fAkvDA3/VzY1rlo5pTAk
         SRQrlvcP77h/DOAU/h+VxxLGtqyHXbt+QwtxxRoXdMKvoUqTe28yqDeYDPI3clGXpwSA
         4KQD+eYjf5u468gQFtzi1zQfg4fgTFKr0bUH47BwYaXNjt9aU6PlMQPOnoBnbSCLWTDJ
         sZWSdI9mX+qnA0UzYlQbKAenrD0yi/aXGcLtjqtrTZvh6OFqBjFbEtSWTsmla7WmLDVV
         x2xA==
X-Gm-Message-State: AOAM5310xZvK72DTkkNEL12bbfj2h8FNE8MwEuoFCnpZfCMIAsJg4LF7
        Q85mSoWt7JSFvU8ZzaWXQQoP5A==
X-Google-Smtp-Source: ABdhPJyQm2DYkfwZWeQ8c2SXCttADzogmheycQw8zr+/gyBz2OPcFNDoNYn3v2ZRTwFxmpbS6JMcWA==
X-Received: by 2002:a63:8aca:0:b0:3f9:f9ed:7426 with SMTP id y193-20020a638aca000000b003f9f9ed7426mr23416520pgd.176.1653596827205;
        Thu, 26 May 2022 13:27:07 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id l24-20020a17090aaa9800b001e0c1044ceasm55740pjq.43.2022.05.26.13.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 13:27:06 -0700 (PDT)
Date:   Thu, 26 May 2022 20:27:02 +0000
From:   David Matlack <dmatlack@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH V3 00/12] KVM: X86/MMU: Use one-off local shadow page for
 special roots
Message-ID: <Yo/ilj2ll5HJqP+O@google.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
 <CAJhGHyDSxN5haa6bx+44jRXw3PBad6DcmZNc115g5Vfve=xLEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyDSxN5haa6bx+44jRXw3PBad6DcmZNc115g5Vfve=xLEA@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 04:49:09PM +0800, Lai Jiangshan wrote:
> On Sat, May 21, 2022 at 9:16 PM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
> >
> > From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> >
> > Current code uses mmu->pae_root, mmu->pml4_root, and mmu->pml5_root to
> > setup special roots.  The initialization code is complex and the roots
> > are not associated with struct kvm_mmu_page which causes the code more
> > complex.
> >
> > So add new local shadow pages to simplify it.
> >
> > The local shadow pages are associated with struct kvm_mmu_page and
> > VCPU-local.
> >
> > The local shadow pages are created and freed when the roots are
> > changed (or one-off) which can be optimized but not in the patchset
> > since the re-creating is light way (in normal case only the struct
> > kvm_mmu_page needs to be re-allocated and sp->spt doens't, because
> > it is likely to be mmu->pae_root)
> >
> > The patchset also fixes a possible bug described in:
> > https://lore.kernel.org/lkml/20220415103414.86555-1-jiangshanlai@gmail.com/
> > as patch1.
> >
> 
> Ping and please ignore patch1 and patch9. It would not cause any conflict
> without patch1 and patch9 if both are ignored together.
> 
> The fix is wrong (see new discussion in the above link).  So the possible
> correct fix will not have any conflict with this patchset of one-off
> local shadow page.  I don't want to add extra stuff in this patchset
> anymore.

Yeah I agree with splitting this fix out to a separate patchset, and
ordered after this cleanup so it can be done in one patch.

When you get around to it, can you also implement a kvm-unit-test to
demonstrate the bug? It would be good to have a regression test.

> 
> Thanks
> Lai
