Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528A26784EE
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 19:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbjAWSbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 13:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbjAWSbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 13:31:18 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3E635267
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 10:30:55 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id 3so13907934vsq.7
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 10:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o+xUN6pqH4KWhpdAZZASKkpdwX1dWlxeGaeUlHQVMdw=;
        b=cV8GzTY0zBLyK2FJXATgkWVu401po27fDFp43ID0uM14l9ibUSQYqtncVhKy3qVOxD
         s4a4ta+I5XrPn6sRK/XvlAiIBk1UnMoLlbm1Hcun1gskbAstCGmVpaS2LwxxDH/NlA6+
         wU24POhe4aFZItoW1jW22klyPRhUJRHHatgOqF14b+v9JQ+7n4civ14F+6+zRLIw4Wtc
         SIf5i9igZXGzKSKOCD7kTW1TsuplIudF3/xsJR8iUhO6WtxTOUWKPQ80SE7gNEx1mVg0
         xyOQbSX9G+r8JCXUfX/xZlmqyY132/qX1FiWcg/749IJPRES7iWwafVer1HtNtqunHed
         j71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o+xUN6pqH4KWhpdAZZASKkpdwX1dWlxeGaeUlHQVMdw=;
        b=IGQs6nPJ8i/6elFYT4iIRYSz90/kuRGPATbKs6gvtWxOwSNUdzHcyPKvaphNg+uuHg
         wJEkFT8oTkoWvCaugYGnNbmqpcpu/GPzdoex/Cv1MrO1dlrcOTaz77BE7Kr7uwnHYhhb
         6WCVnPB7Tl8SJptRXjRr6wqH6WFGn1QQc0oefkPPHkOB3e/IqJw2rqAMSGPQ06zUAYVB
         AGMXJaM3c2lmtuLs99b7v2ZJ0A2KFbE2RQfjn3+bwebfKWLpysrZkgYcs+wQLzNTd8Sk
         DFDB2dJv7j3WXFzJgIz+m+cVQyQ+vfYj/zKQsL+Jo5W+EangkC5Jy6o+RxuPJRKjQrH0
         77Xw==
X-Gm-Message-State: AFqh2koa0YFsjFS/yxDBvIvt7ZdjoEkJ9I/jPkBje5XRdljGTWCKshoS
        eh8k+kDpwA7swX+gd2roxmxBu2OlIuaBXx3uDs6g5Q==
X-Google-Smtp-Source: AMrXdXtjMcYu45J9vgTNdZq5yrE/41r93upqkvNOfUCN6J0aGWd7SJJHXhoxYAbIpLuPTUF4sz+iXqmJwilen2GuONg=
X-Received: by 2002:a05:6102:4425:b0:3c8:c513:197 with SMTP id
 df37-20020a056102442500b003c8c5130197mr3309786vsb.9.1674498641262; Mon, 23
 Jan 2023 10:30:41 -0800 (PST)
MIME-Version: 1.0
References: <20230121001542.2472357-1-ackerleytng@google.com>
 <20230121001542.2472357-9-ackerleytng@google.com> <Y8sxjppvEnm4IBWG@google.com>
In-Reply-To: <Y8sxjppvEnm4IBWG@google.com>
From:   Erdem Aktas <erdemaktas@google.com>
Date:   Mon, 23 Jan 2023 10:30:30 -0800
Message-ID: <CAAYXXYy7=ZTCZ1LQ3_Sy39ju_xG5++dTrxi+DKGcbpJ5VJ3OuQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 08/31] KVM: selftests: Require GCC to realign
 stacks on function entry
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ackerley Tng <ackerleytng@google.com>,
        linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        isaku.yamahata@intel.com, sagis@google.com, afranji@google.com,
        runanwang@google.com, shuah@kernel.org, drjones@redhat.com,
        maz@kernel.org, bgardon@google.com, jmattson@google.com,
        dmatlack@google.com, peterx@redhat.com, oupton@google.com,
        ricarkol@google.com, yang.zhong@intel.com, wei.w.wang@intel.com,
        xiaoyao.li@intel.com, pgonda@google.com, marcorr@google.com,
        eesposit@redhat.com, borntraeger@de.ibm.com, eric.auger@redhat.com,
        wangyanan55@huawei.com, aaronlewis@google.com, vkuznets@redhat.com,
        pshier@google.com, axelrasmussen@google.com,
        zhenzhong.duan@intel.com, maciej.szmigiero@oracle.com,
        like.xu@linux.intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
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

On Fri, Jan 20, 2023 at 4:28 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Sat, Jan 21, 2023, Ackerley Tng wrote:
> > Some SSE instructions assume a 16-byte aligned stack, and GCC compiles
> > assuming the stack is aligned:
> > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=40838. This combination
> > results in a #GP in guests.
> >
> > Adding this compiler flag will generate an alternate prologue and
> > epilogue to realign the runtime stack, which makes selftest code
> > slower and bigger, but this is okay since we do not need selftest code
> > to be extremely performant.
>
> Huh, I had completely forgotten that this is why SSE is problematic.  I ran into
> this with the base UPM selftests and just disabled SSE.  /facepalm.
>
> We should figure out exactly what is causing a misaligned stack.  As you've noted,
> the x86-64 ABI requires a 16-byte aligned RSP.  Unless I'm misreading vm_arch_vcpu_add(),
> the starting stack should be page aligned, which means something is causing the
> stack to become unaligned at runtime.  I'd rather hunt down that something than
> paper over it by having the compiler force realignment.

Is not it due to the 32bit execution part of the guest code at boot
time. Any push/pop of 32bit registers might make it a 16-byte
unaligned stack.

>
> > Similar issue discussed at
> > https://lore.kernel.org/all/CAGtprH9yKvuaF5yruh3BupQe4BxDGiBQk3ExtY2m39yP-tppsg@mail.gmail.com/
> >
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 317927d9c55bd..5f9cc1e6ee67e 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -205,7 +205,7 @@ LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/x86/include
> >  else
> >  LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
> >  endif
> > -CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
> > +CFLAGS += -mstackrealign -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
> >       -fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
> >       -I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
> >       -I$(<D) -Iinclude/$(UNAME_M) -I ../rseq -I.. $(EXTRA_CFLAGS) \
> > --
> > 2.39.0.246.g2a6d74b583-goog
> >
