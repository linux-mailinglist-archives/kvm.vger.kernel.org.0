Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E06A5259EF
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 05:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376677AbiEMDHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 23:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376669AbiEMDHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 23:07:03 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2220146B22
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 20:07:02 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 31-20020a9d0822000000b00605f1807664so4082452oty.3
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 20:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=297SZhnbfakt9y0BHFgnqzkCZLJUke1XogmQGvDK8R4=;
        b=m9HMjtn3t15regA8x1GltDY08DyPBuI2H0RawHwVfEekwc56tea1CeNnXrDCzfMSsr
         T6LDfkOGVAxHlFZ5blEteba7l8cHTjFwQsUqaL6bexFl3C14r2qGMsjZsHwnYnSgSU/l
         YMC1c6z2iZHeQDptFxo+AJbSFYLWexKpQLb0QbGWGws60uTswZkLayRv4fx9VDHM4LoT
         jpWYlcF+Lkq6g3rCH49AYvRHONXLVW/9OnDDxHw0N461nY+PU4Bdzg+F+HJEETHXBI+V
         jpXhR7PTGYzYIxiM6kBPMM2W64m5Uh6TgfeVIPR8WRv0Rsk9kpCzIIgej+KltjAUZptZ
         N/kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=297SZhnbfakt9y0BHFgnqzkCZLJUke1XogmQGvDK8R4=;
        b=xzWqxU0brbsXsjsH3OECH6d3l+yUKD3zcsOCFbiCtZBcSMNxSVxyyPporyRIs8+nwR
         UyYUWvHNagovqygZMYQK1uHr+iXm4I23FCYlhCLPe3edF7cXVQbCtGcLHgjfYDlnX1Hg
         xD09nGJTegPxhsUozka8HKyvnEXMnjHn+Rn8+Px5PDvCgHMJXJ9R1Z+WHVUF9n16J4lQ
         uGAbgd2+JzWISBVvK2rJyCM0tcQ2/X80ruXuULWMr1+dwz2/EBsl+KIVy8hFV3A9uwW/
         KpLU4SGi6Y53qdDVIp1q1yFHhOpJsCUDFQuPsNlotJBtcF/D8lwNnK9Bd8TU4vdJncRj
         ttuQ==
X-Gm-Message-State: AOAM5309JvmoG5YrrJ2mkgIWHJstC6nKZY7DdjG52zcwJomx2JpVIAXZ
        eHJyELRH70jpbQTUNc7JzP9hK9yMFUGe7E7bU8oy4Q==
X-Google-Smtp-Source: ABdhPJyAHsbwyCL+EjpEVDEWDEyvsYMPlp0+rwoKbTCFj5OxYrQ77Dt4TinjMnxcKF4zxhJZi4KxoVhSgYkgN+dsYak=
X-Received: by 2002:a05:6830:280e:b0:606:ae45:6110 with SMTP id
 w14-20020a056830280e00b00606ae456110mr1143445otu.14.1652411221187; Thu, 12
 May 2022 20:07:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220512184514.15742-1-jon@nutanix.com> <Yn1fjAqFoszWz500@google.com>
 <Yn1hdHgMVuni/GEx@google.com> <07BEC8B1-469C-4E36-AE92-90BFDF93B2C4@nutanix.com>
 <Yn1o9ZfsQutXXdQS@google.com> <CALMp9eRQv6owjfyf+UO=96Q1dkeSrJWy0i4O-=RPSaQwz0bjTQ@mail.gmail.com>
 <C39CD5E4-3705-4D1A-A67D-43CBB7D1950B@nutanix.com> <CALMp9eRXmWvrQ1i0V3G738ndZOZ4YezQ=BqXe-BF2b4GNo1m3Q@mail.gmail.com>
 <DEF8066B-E691-4C85-A19A-9F5222D1683D@nutanix.com>
In-Reply-To: <DEF8066B-E691-4C85-A19A-9F5222D1683D@nutanix.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 12 May 2022 20:06:49 -0700
Message-ID: <CALMp9eTwH9WVD=EuTXeu1KYAkAUuXdnmA+k9dti7OM+u=kLKHQ@mail.gmail.com>
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

On Thu, May 12, 2022 at 5:50 PM Jon Kohler <jon@nutanix.com> wrote:

> You mentioned if someone was concerned about performance, are you
> saying they also critically care about performance, such that they are
> willing to *not* use IBPB at all, and instead just use taskset and hope
> nothing ever gets scheduled on there, and then hope that the hypervisor
> does the job for them?

I am saying that IBPB is not the only viable mitigation for
cross-process indirect branch steering. Proper scheduling can also
solve the problem, without the overhead of IBPB. Say that you have two
security domains: trusted and untrusted. If you have a two-socket
system, and you always run trusted workloads on socket#0 and untrusted
workloads on socket#1, IBPB is completely superfluous. However, if the
hypervisor chooses to schedule a vCPU thread from virtual socket#0
after a vCPU thread from virtual socket#1 on the same logical
processor, then it *must* execute an IBPB between those two vCPU
threads. Otherwise, it has introduced a non-architectural
vulnerability that the guest can't possibly be aware of.

If you can't trust your OS to schedule tasks where you tell it to
schedule them, can you really trust it to provide you with any kind of
inter-process security?

> Would this be the expectation of just KVM? Or all hypervisors on the
> market?

Any hypervisor that doesn't do this is broken, but that won't keep it
off the market. :-)
