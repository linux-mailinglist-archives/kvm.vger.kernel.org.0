Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41D34F6F35
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 02:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbiDGAbt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 20:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiDGAbs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 20:31:48 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF454B8980
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 17:29:48 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id x33so474024lfu.1
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 17:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CkPzo2ifaguOVMtdfGmWjpPX50t8cnkSUjVSfWwnL5U=;
        b=d7u1jQejDO3MGWlEFFPrS0ZfLdOvD6yoN7+/gYdbw+id2HYXp4LQ4wwfVonA0Sf24j
         IjQIX6/cFi0Uqx1oTriEFV/fWwmeVol/5EftZaTMf52733M3X/n5xJVYbpXHnUV6Twr4
         UlAXEpyDIWkoZh6KTidFL/TI5YtdojFtHOuD7P2slWbwYdP+cm8ozfCLMC/9DQq1tkqI
         hOsj0kuepVydsOekFXYkvXDPcbcJbPgrTESvwnz/vB/qxn0RfrsMHFh6fh0NHmbHk6xd
         nJhXiqxEwr6PYESJbl2xBaL1jMBUwAxPMaZB9FbD5nmV4WO7cHCIfWY89A6cVm9g8kbU
         yQhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CkPzo2ifaguOVMtdfGmWjpPX50t8cnkSUjVSfWwnL5U=;
        b=lwcYxgf5e55cx1aRIFPW+/7JDnja2ZbTPA4gy+mPCJPmzVNIQySQ8qd9Cgry7N91RT
         6kUhQruYj7hExDv249Q4ZGlqDDMqMmgN0AobI3GoQCppeseVPBh0cGI4Uk+YFh/UB3C0
         k8MIeH+s5qrqkoXFhelbpZvgJJuIhZnL+eoHL4zjkWopGzXQspK7tgyr4Nzktoz7niyx
         yufVa7hy2N6iWjk8JcQAPd6XjKAOQBckWfOCpDwRTIe3jRkKzB+GwhDIKOUi+E76SzbE
         S0Sh79ZxEuF0pUJWmlsroH9pwPB1sTf8A0bLIF9RPAp8z6opKmiO4sIjDRKVjNctiKZ6
         5LyA==
X-Gm-Message-State: AOAM5311udGcWeCy07NZ2eXhbB37/KZ0DUudUriH+ZyuumkBZmlIatgD
        xqMUBBs1Gqt9zfQdm0bp3zt8uiiynO4va0QqIwuCRQ==
X-Google-Smtp-Source: ABdhPJziaT0sQxl7O9OEK6micuyEAuFS1gVAQdmL2dhRKzNsA9YqXZoZOCHjDriHIiChsgiKs81IBev1NtvoDPTXInE=
X-Received: by 2002:a05:6512:12c3:b0:44a:27ac:c7a4 with SMTP id
 p3-20020a05651212c300b0044a27acc7a4mr7515277lfg.150.1649291386841; Wed, 06
 Apr 2022 17:29:46 -0700 (PDT)
MIME-Version: 1.0
References: <b839fa78-c8ec-7996-dba7-685ea48ca33d@redhat.com>
 <Yh/Y3E4NTfSa4I/g@google.com> <4d4606f4-dbc9-d3a4-929e-0ea07182054c@redhat.com>
 <Yh/nlOXzIhaMLzdk@google.com> <YiAdU+pA/RNeyjRi@google.com>
 <78abcc19-0a79-4f8b-2eaf-c99b96efea42@redhat.com> <YiDps0lOKITPn4gv@google.com>
 <CALMp9eRGNfF0Sb6MTt2ueSmxMmHoF2EgT-0XR=ovteBMy6B2+Q@mail.gmail.com>
 <YiFS241NF6oXaHjf@google.com> <764d42ec-4658-f483-b6cb-03596fa6c819@redhat.com>
 <Yk4vqJ1nT+JxEpKo@google.com>
In-Reply-To: <Yk4vqJ1nT+JxEpKo@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 6 Apr 2022 17:29:35 -0700
Message-ID: <CAOQ_Qsj6KwV_OjDS-JwOkPs76Z9FiCBVBTGgp-_hZHQ6BAeExg@mail.gmail.com>
Subject: Re: [PATCH v4 1/8] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
Content-Type: text/plain; charset="UTF-8"
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

Hey Sean,

On Wed, Apr 6, 2022 at 5:26 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Mar 04, 2022, Paolo Bonzini wrote:
> > On 3/4/22 00:44, Sean Christopherson wrote:
> > >
> > > diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> > > index c92cea0b8ccc..46dd1967ec08 100644
> > > --- a/arch/x86/kvm/vmx/nested.h
> > > +++ b/arch/x86/kvm/vmx/nested.h
> > > @@ -285,8 +285,8 @@ static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
> > >  }
> > >
> > >  /* No difference in the restrictions on guest and host CR4 in VMX operation. */
> > > -#define nested_guest_cr4_valid nested_cr4_valid
> > > -#define nested_host_cr4_valid  nested_cr4_valid
> > > +#define nested_guest_cr4_valid kvm_is_valid_cr4
> > > +#define nested_host_cr4_valid  kvm_is_valid_cr4
> >
> > This doesn't allow the theoretically possible case of L0 setting some
> > CR4-fixed-0 bits for L1.  I'll send another one.
>
> Are you still planning on sending a proper patch for this?
>
> And more importantly, have we shifted your view on this patch/series?

Sorry, I should've followed up. If nobody else complains, let's just
leave everything as-is and avoid repeating the mistakes of the patches
to blame (hey, I authored one of those!)

--
Best,
Oliver
