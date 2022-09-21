Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7352C5E56CD
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 01:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiIUXn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 19:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiIUXn2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 19:43:28 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4B19A682
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 16:43:27 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso389389pjd.4
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 16:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=LrBRbTyBrqZcQW+ofOtU7F3zT9+W+QdXLzp4JaBlABw=;
        b=W+7P0xVxybwcC5cJTSoqKgT0yl4nThvi5Hc9BQvwW2BHDU//a3Y600wMmkmjopEWDf
         MFZ5MizyrDazGVGV/ZDK73jA08KP0myvdEDPvEB4ysPw9oeqZZh8hKHWLeBnMNxvWsOC
         E1OZl9fepkh9sGaP3SwFbM6J2lPNn4UhD6AtXge7y62O8MvyenvIqE1yDuGwq75e8xlD
         VF/JyInDB324sI+v5WCq3WlZfQZnpD1JlyRKBhzCiceyziILOPvv+L1Cx3eWC0nlFRL9
         xVGOuxLyRDbfog5w5DA6BdjFaIqKRC7cwYpD8AvIDAF7opZlCAwqxhUzUj0t+PKGuLT5
         E8sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=LrBRbTyBrqZcQW+ofOtU7F3zT9+W+QdXLzp4JaBlABw=;
        b=Q/hojzN7Bf7w/2B8979XUer9KUby0jTpTqUunKeGlyVact56twTVybCQL8eaHJ6xOX
         Dn2e4BmsQbO/+7bgnJcz5bFtgaWrnahZAewr7EsRubQAt4Ah5NygmH5w0GTUMdDWAYB9
         zvl8w4pJ/OPqmSOr1zwlHPurobkJAgkKIUl6jIVEfUgSwCI25s9bwKV2T9oae6hNCxpO
         aGH0sC+FcVF/sqEepy8Pa85zthhI3oZiDJVeturmHRx7KF7D64b7HxURv3t5N23WWllZ
         j9/WKRECPdOh9JE7gZVD6Wcxzysbr5DOFtUyLRkWkjt36XKWU/TtYxH+w10kYPmBcKgB
         XwEw==
X-Gm-Message-State: ACrzQf3MDF7rNo5+JhhEpO13D7fohjhf/9b/HiKg2pzS9nhg8CYm3em1
        O3u8dkykyHp6ySqYIQ/ZTIxgq7z0CCY=
X-Google-Smtp-Source: AMsMyM4GRDHt7ZqtY8OwJOCN3U9FG2tR9XfcgoAp5mvna1Z+arkaB5MLve27mxXjX9RNIWKyUAAWsg==
X-Received: by 2002:a17:90a:db8b:b0:203:1de7:eaaf with SMTP id h11-20020a17090adb8b00b002031de7eaafmr12431796pjv.168.1663803807272;
        Wed, 21 Sep 2022 16:43:27 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id i2-20020a17090a2a0200b001fd76f7a0d1sm2402807pjd.54.2022.09.21.16.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 16:43:26 -0700 (PDT)
Date:   Wed, 21 Sep 2022 16:43:25 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Kai Huang <kai.huang@intel.com>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v2 08/10] KVM: x86/mmu: Split out TDP MMU page fault
 handling
Message-ID: <20220921234325.GA1148853@ls.amr.corp.intel.com>
References: <20220826231227.4096391-1-dmatlack@google.com>
 <20220826231227.4096391-9-dmatlack@google.com>
 <20220830235708.GB2711697@ls.amr.corp.intel.com>
 <CALzav=fg8xonNUkbFcep6kcVcBGtsp2RRW0_NKUL8DhdbQbRPA@mail.gmail.com>
 <Yyot4L75h2ShPSaG@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yyot4L75h2ShPSaG@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 20, 2022 at 02:17:20PM -0700,
David Matlack <dmatlack@google.com> wrote:

> On Thu, Sep 01, 2022 at 09:50:10AM -0700, David Matlack wrote:
> > On Tue, Aug 30, 2022 at 4:57 PM Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
> > > On Fri, Aug 26, 2022 at 04:12:25PM -0700, David Matlack <dmatlack@google.com> wrote:
> > > >  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > > >  {
> > > >       /*
> > > > @@ -4355,6 +4384,11 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > > >               }
> > > >       }
> > > >
> > > > +#ifdef CONFIG_X86_64
> > > > +     if (tdp_mmu_enabled)
> > > > +             return kvm_tdp_mmu_page_fault(vcpu, fault);
> > > > +#endif
> > > > +
> > > >       return direct_page_fault(vcpu, fault);
> > > >  }
> > >
> > > Now we mostly duplicated page_fault method.  We can go one step further.
> > > kvm->arch.mmu.page_fault can be set for each case.  Maybe we can do it later
> > > if necessary.
> > 
> > Hm, interesting idea. We would have to refactor the MTRR max_level
> > code in kvm_tdp_page_fault() into a helper function, but otherwise
> > that idea would work. I will give it a try in the next version.
> 
> So I took a stab at this. Refactoring the max_level adjustment for MTRRs
> into a helper function is easy of course. But changing page_fault also
> requires changes in kvm_mmu_do_page_fault() for CONFIG_RETPOLINE and
> fault->is_tdp. I'm not saying it's not possible (it definitely is) but
> it's not trivial to do it in a clean way, so I suggest we table this for
> the time being.

Fair enough.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
