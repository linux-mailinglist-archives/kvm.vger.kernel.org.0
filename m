Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143117050BE
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 16:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbjEPOaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 10:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233776AbjEPOaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 10:30:04 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD12410FE
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 07:30:03 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-561a148e524so5926097b3.0
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 07:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684247403; x=1686839403;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4YEPKrVR9zT024XK7Pjo91EG5vcxIVFCJtB9CTxRlDM=;
        b=hqHcxjQbJBGZla48WsupFSE1qX/Q50O/tDR9HRispcTqhozzhNaDapI1iUI+nV5Dqa
         +1YztNS7sMj7wiHDm0+uAOJXhAOMuPVrU6pHbFstZqhwb/IN4HRrOjpIO8eadjPxWAiv
         74ZKC4fPNkL7uHLKcrORbKVAL6lyxZVoThJRc2570yDONMDvXbttp+1WyG/KPEVI0Mbj
         /NITT/iX9eusiaFbGu44753OhtSEHfnh4iDWqcOdXFdq/GRuHbEd3f6wqf1Ezyk3tHWu
         lGLELXUKPIoHXEUyM1vl7ctdC6KLkFsE4Fe4uGvSVPO5JyNR6ut5eE1mOnGUTpwSdULf
         SuMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684247403; x=1686839403;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4YEPKrVR9zT024XK7Pjo91EG5vcxIVFCJtB9CTxRlDM=;
        b=EO6uOjQPwwP8o9ZspH5DdAtuwhJtFhjvZa+cE1nxhuhqN8nx9SlwbWb2f7GgTM5B3y
         G2pyinC2sLARi5yErHlN2pQwlmOPZkv6GGwyjxNh1QzvdH9dmobfddm8su0MtHJJGEsJ
         aXUcLfAXL6y6Bh3zaQ/LC5z3Da8q4LcCr7OWUSiuqIyCDU3baKUUKPZywgHWEQBeKK1b
         5oMPyQBbFP+0pAn1FFsiArhL/IjagATUOJHRHWVRNhG1nOXp9Doei4fFNssPnenXvdU3
         B8FrlCKTYRhFaVYyFJehulM1TQUdzs8rW2Hxd1axM+wyNlMSL3DHHAwcy6ggdnH8ZBtw
         07VA==
X-Gm-Message-State: AC+VfDyCQNwe4FqnjqKecHav0pKfJYmF7mu7Sheh4lv/6Nhs6gwqzd2l
        9BOLSdtSnBjXHMRKQYTqIVgoR+JoOAA=
X-Google-Smtp-Source: ACHHUZ6nLWUlEK0uTVg2ClJoaxJ9mV14xuwTnG5GvNICmdUhSrCvtGUgZ3UVfCgP00Yml5lYnHv0fvo+YTM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:c903:0:b0:556:cacc:1f1d with SMTP id
 o3-20020a81c903000000b00556cacc1f1dmr22415308ywi.8.1684247402987; Tue, 16 May
 2023 07:30:02 -0700 (PDT)
Date:   Tue, 16 May 2023 07:30:01 -0700
In-Reply-To: <b97e8c2a-b629-f597-d011-395071011f1b@redhat.com>
Mime-Version: 1.0
References: <cover.1684097001.git.lstoakes@gmail.com> <b61d5999a4fc6d50b7e073cc3c3efa8fe79bbd94.1684097002.git.lstoakes@gmail.com>
 <ZGKC9fHoE+kDs0ar@google.com> <b97e8c2a-b629-f597-d011-395071011f1b@redhat.com>
Message-ID: <ZGOTadDG/b0904YI@google.com>
Subject: Re: [PATCH v5 1/6] mm/gup: remove unused vmas parameter from get_user_pages()
From:   Sean Christopherson <seanjc@google.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, Xinhui Pan <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>,
        Christian Konig <christian.koenig@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 16, 2023, David Hildenbrand wrote:
> On 15.05.23 21:07, Sean Christopherson wrote:
> > On Sun, May 14, 2023, Lorenzo Stoakes wrote:
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index cb5c13eee193..eaa5bb8dbadc 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -2477,7 +2477,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
> > >   {
> > >   	int rc, flags = FOLL_HWPOISON | FOLL_WRITE;
> > > -	rc = get_user_pages(addr, 1, flags, NULL, NULL);
> > > +	rc = get_user_pages(addr, 1, flags, NULL);
> > >   	return rc == -EHWPOISON;
> > 
> > Unrelated to this patch, I think there's a pre-existing bug here.  If gup() returns
> > a valid page, KVM will leak the refcount and unintentionally pin the page.  That's
> 
> When passing NULL as "pages" to get_user_pages(), __get_user_pages_locked()
> won't set FOLL_GET. As FOLL_PIN is also not set, we won't be messing with
> the mapcount of the page.

Ah, that's what I'm missing.

> So even if get_user_pages() returns "1", we should be fine.
> 
> 
> Or am I misunderstanding your concern?

Nope, you covered everything.  I do think we can drop the extra gup() though,
AFAICT it's 100% redundant.  But it's not a bug.

Thanks!
