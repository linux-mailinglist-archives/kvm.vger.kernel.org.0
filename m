Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1CA6016E7
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 21:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbiJQTFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 15:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiJQTFv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 15:05:51 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA69458529
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 12:05:48 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id a6so15146817ljq.5
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 12:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tpLbF7MUjfgdwKeolFrKwUGGJvkFHEynVfhNRIRYzO0=;
        b=cTXJI0UBOdBxXG2IHW1rqIDOvBkglMHN1TS3v9u/Mg6E19sNCf3CHq90Ltlb8bjRuV
         uwZxsI3QP9DlzIDrz8Ff7f9zknZmBhB2m3pkIj381yHasQYOvkpoqdJncN9JKC2twFC8
         ShVufGPOkpE2dB+4eCyihCzXtxWBY+X/y95BOpw7uAHWW2nmY6ScgSdvp0Pxz6khfbyi
         YxhW1XKkSTezSkUawIx5/j0VpvJshXk6TJGUrtcsbKTwNFF6pKmyHcosQZh7T9atBa+E
         fdb7oqoR8tN6oS+MAKpeLCi//GJfCoW515YxPGh6OzLSq2gny6eetjefpyJ4o3QbBEiq
         9V6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tpLbF7MUjfgdwKeolFrKwUGGJvkFHEynVfhNRIRYzO0=;
        b=68G3MTf/S7DQktyZRqp+M+RslSAIyV0MAhAcsP0RNXgA7/tgJuAbCBb7uZFHxnlcMM
         493CFWE3CgW+9/kQRqOQUcAW7bQdBAfLTmaNOwyptcWahuypaUt+Dx49zudcJlwsIJxt
         LJIjB+gCmio7V0cUuCaVb4hIKT1/dlj/H9aCKysXkq5kyXaYsgkT+G1uZPaePVTLZV+0
         6g3ltOhrlc8CWNchK54KAfmByxCgjD8+tMZpdqnY5A9zWkd4g6Zmx+sJZ348qEwxmFvf
         nHlhdFhSUP4cBA4ZttqDDD6k2ekE1K/o5Ih8S9+Z9gD8CdTwoj0D6Qhp9pfGcQ6+PEDp
         uJtw==
X-Gm-Message-State: ACrzQf00z7Ty+hf3kvUd8yCITWDihjxYdnKTVdZYQD5HDxKTUxRP5gan
        1Jnshir81vTvbF+ejSv51NBtBGW62fi+7+0824DlrQ==
X-Google-Smtp-Source: AMsMyM4AkQi9c7U3RtdWYwjcZCizC5KFrocAewLyWt0H2WuNks4/hroyUpSgGTZ2Szy1PxqSxcVc8+OpiywAfS+j4K8=
X-Received: by 2002:a05:651c:20d:b0:26f:bc4c:f957 with SMTP id
 y13-20020a05651c020d00b0026fbc4cf957mr4763341ljn.199.1666033547017; Mon, 17
 Oct 2022 12:05:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220915142913.2213336-2-chao.p.peng@linux.intel.com>
 <d16284f5-3493-2892-38e6-f1fa5c10bdbb@redhat.com> <Yyi+l3+p9lbBAC4M@google.com>
 <CA+EHjTzy4iOxLF=5UX=s5v6HSB3Nb1LkwmGqoKhp_PAnFeVPSQ@mail.gmail.com>
 <20220926142330.GC2658254@chaop.bj.intel.com> <CA+EHjTz5yGhsxUug+wqa9hrBO60Be0dzWeWzX00YtNxin2eYHg@mail.gmail.com>
 <YzN9gYn1uwHopthW@google.com> <CA+EHjTw3din891hMUeRW-cn46ktyMWSdoB31pL+zWpXo_=3UVg@mail.gmail.com>
 <20221013133457.GA3263142@chaop.bj.intel.com> <CA+EHjTzZ2zsm7Ru_OKCZg9FCYESgZsmB=7ScKRh6ZN4=4OZ3gw@mail.gmail.com>
 <20221017145856.GB3417432@chaop.bj.intel.com>
In-Reply-To: <20221017145856.GB3417432@chaop.bj.intel.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 17 Oct 2022 20:05:10 +0100
Message-ID: <CA+EHjTyiU230am0cuWc7xBBirGocPWGmyqCskhTytA10xpigYQ@mail.gmail.com>
Subject: Re: [PATCH v8 1/8] mm/memfd: Introduce userspace inaccessible memfd
To:     Chao Peng <chao.p.peng@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Steven Price <steven.price@arm.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        luto@kernel.org, jun.nakajima@intel.com, dave.hansen@intel.com,
        ak@linux.intel.com, aarcange@redhat.com, ddutile@redhat.com,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>, mhocko@suse.com,
        Muchun Song <songmuchun@bytedance.com>, wei.w.wang@intel.com,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

> > > Using both private_fd and userspace_addr is only needed in TDX and other
> > > confidential computing scenarios, pKVM may only use private_fd if the fd
> > > can also be mmaped as a whole to userspace as Sean suggested.
> >
> > That does work in practice, for now at least, and is what I do in my
> > current port. However, the naming and how the API is defined as
> > implied by the name and the documentation. By calling the field
> > private_fd, it does imply that it should not be mapped, which is also
> > what api.rst says in PATCH v8 5/8. My worry is that in that case pKVM
> > would be mis/ab-using this interface, and that future changes could
> > cause unforeseen issues for pKVM.
>
> That is fairly enough. We can change the naming and the documents.
>
> >
> > Maybe renaming this to something like "guest_fp", and specifying in
> > the documentation that it can be restricted, e.g., instead of "the
> > content of the private memory is invisible to userspace" something
> > along the lines of  "the content of the guest memory may be restricted
> > to userspace".
>
> Some other candidates in my mind:
> - restricted_fd: to pair with the mm side restricted_memfd
> - protected_fd: as Sean suggested before
> - fd: how it's explained relies on the memslot.flag.

All these sound good, since they all capture the potential use cases.
Restricted might be the most logical choice if that's going to also
become the name for the mem_fd.

Thanks,
/fuad

> Thanks,
> Chao
> >
> > What do you think?
> >
> > Cheers,
> > /fuad
> >
> > >
> > > Thanks,
> > > Chao
> > > >
> > > > Cheers,
> > > > /fuad
