Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD5E525A60
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 05:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376813AbiEMDvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 23:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376758AbiEMDuy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 23:50:54 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA6B5F84
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 20:50:49 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id f6-20020a4ace86000000b0035f083d2216so2520924oos.4
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 20:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mPYVRQJ3KtRd/5hxYP29jNpNRSc6Jp59FqIYzhOqd1M=;
        b=K4s3gtmiKAy6Wr3Hi7/dyuWMLJQ68rvmjcX+TiIHR5UrAl0xw99fjetBgRnTod5Ggv
         +o1WIV2fdnYlnTPmvG7x3GB3WtU0V3a2jul/mAwsYZNK4XligHFDze3EzOEdk9z+pG5y
         XzNVkL1ojJb1ROdHxH73QjcV6N7ZT3A30nRRPlPsNRvHEfCL/mu5eJCryNvLRsFA8APp
         6UUVtz/7Xy/zoYJSasRJAZCVkQfk0t+i+SmnURivBrQ5MSUUlKBa2pYaNp186yuCFBM5
         vrJozt6+Ks2AvyJV2Mfap3sW3o21n0DMIp11+GoWZ5Vb64TDgahD1DzeewknvUHxyIm+
         v8VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mPYVRQJ3KtRd/5hxYP29jNpNRSc6Jp59FqIYzhOqd1M=;
        b=OLrn/GkjctFdRZXErjCXiKh0N+mzAzwRS2ZfdXGeb+1tN+R7EpNnLTfK816RZq8zau
         q2KuwyPkoVO/jSjkI9xZN+STHtyNFUOe6NFDp+l4jD0GxvsHToWqfItOQ8ClRz1nZdqb
         pS8dMlpSJSDCpx38cFwzetO2hJprBJwxuPerJxLVyFFUiGryRYWMPZJBF21ioC89uqoR
         y+uYc/EKTqSUWBy/si+G8dmOTZ/q7uJDb+AwwAGB1pStMJ1ueoVjpwUA8nY6Z01rQUiM
         6cuskVxzzRSjcPoklTDHB8zDHmkjhpzGu0b602aqxjWcuQ9UA/jFcA6ypAbQ2ZWgVuzO
         nYMg==
X-Gm-Message-State: AOAM531O0ldX+AmKch4Xfz2qmfVjR3cgMO9MEMJuBP/KLtAn5lNF/bcJ
        5ntrU99RogIPSWfKD6PlzPYkd7DcqxpT8BLYY767Bw==
X-Google-Smtp-Source: ABdhPJwICkMlcUIyQFOuifhC0oD51/apqELrYwGehKJg/6ZjGNhvWlasNEJ4mHhProIjJV5t5Z0u2vNXx1zaJapzcbc=
X-Received: by 2002:a4a:d40d:0:b0:33a:33be:9c1e with SMTP id
 n13-20020a4ad40d000000b0033a33be9c1emr1198631oos.96.1652413847699; Thu, 12
 May 2022 20:50:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220512184514.15742-1-jon@nutanix.com> <Yn1fjAqFoszWz500@google.com>
 <Yn1hdHgMVuni/GEx@google.com> <07BEC8B1-469C-4E36-AE92-90BFDF93B2C4@nutanix.com>
 <Yn1o9ZfsQutXXdQS@google.com> <CALMp9eRQv6owjfyf+UO=96Q1dkeSrJWy0i4O-=RPSaQwz0bjTQ@mail.gmail.com>
 <C39CD5E4-3705-4D1A-A67D-43CBB7D1950B@nutanix.com> <CALMp9eRXmWvrQ1i0V3G738ndZOZ4YezQ=BqXe-BF2b4GNo1m3Q@mail.gmail.com>
 <DEF8066B-E691-4C85-A19A-9F5222D1683D@nutanix.com> <CALMp9eTwH9WVD=EuTXeu1KYAkAUuXdnmA+k9dti7OM+u=kLKHQ@mail.gmail.com>
 <CD2EB6FA-E17F-45BA-AC70-92CCB12A16C4@nutanix.com>
In-Reply-To: <CD2EB6FA-E17F-45BA-AC70-92CCB12A16C4@nutanix.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 12 May 2022 20:50:36 -0700
Message-ID: <CALMp9eQAFz_wzC_SMiWD5KqP3=m+VceP=+6=RWEFbN2m7P7d+w@mail.gmail.com>
Subject: Re: [PATCH v4] x86/speculation, KVM: remove IBPB on vCPU load
To:     Jon Kohler <jon@nutanix.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ashok Raj <ashok.raj@intel.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        Waiman Long <longman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022 at 8:19 PM Jon Kohler <jon@nutanix.com> wrote:
>
>
>
> > On May 12, 2022, at 11:06 PM, Jim Mattson <jmattson@google.com> wrote:
> >
> > On Thu, May 12, 2022 at 5:50 PM Jon Kohler <jon@nutanix.com> wrote:
> >
> >> You mentioned if someone was concerned about performance, are you
> >> saying they also critically care about performance, such that they are
> >> willing to *not* use IBPB at all, and instead just use taskset and hop=
e
> >> nothing ever gets scheduled on there, and then hope that the hyperviso=
r
> >> does the job for them?
> >
> > I am saying that IBPB is not the only viable mitigation for
> > cross-process indirect branch steering. Proper scheduling can also
> > solve the problem, without the overhead of IBPB. Say that you have two
> > security domains: trusted and untrusted. If you have a two-socket
> > system, and you always run trusted workloads on socket#0 and untrusted
> > workloads on socket#1, IBPB is completely superfluous. However, if the
> > hypervisor chooses to schedule a vCPU thread from virtual socket#0
> > after a vCPU thread from virtual socket#1 on the same logical
> > processor, then it *must* execute an IBPB between those two vCPU
> > threads. Otherwise, it has introduced a non-architectural
> > vulnerability that the guest can't possibly be aware of.
> >
> > If you can't trust your OS to schedule tasks where you tell it to
> > schedule them, can you really trust it to provide you with any kind of
> > inter-process security?
>
> Fair enough, so going forward:
> Should this be mandatory in all cases? How this whole effort came
> was that a user could configure their KVM host with conditional
> IBPB, but this particular mitigation is now always on no matter what.
>
> In our previous patch review threads, Sean and I mostly settled on making
> this particular avenue active only when a user configures always_ibpb, su=
ch
> that for cases like the one you describe (and others like it that come up=
 in
> the future) can be covered easily, but for cond_ibpb, we can document
> that it doesn=E2=80=99t cover this case.
>
> Would that be acceptable here?

That would make me unhappy. We use cond_ibpb, and I don't want to
switch to always_ibpb, yet I do want this barrier.

> >
> >> Would this be the expectation of just KVM? Or all hypervisors on the
> >> market?
> >
> > Any hypervisor that doesn't do this is broken, but that won't keep it
> > off the market. :-)
>
> Very true :)
>
