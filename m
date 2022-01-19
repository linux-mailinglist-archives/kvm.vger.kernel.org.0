Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6007F493EAD
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 17:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356257AbiASQ6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 11:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346701AbiASQ6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 11:58:02 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E221C061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 08:58:02 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id v186so9384710ybg.1
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 08:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G8Etyj0cDehLQxOdGo9bhC3mChBu+Y3r0eXmFrlqHZ0=;
        b=kwgBuQpERbZkOwm2IQOtx/6mMjJuf8SzLB45HdOsJvBMxwNJCoX/OiT1gaaKhHSfiJ
         gP6VFFDOEutqAZetiOvAI5UE6t90QnYY8wm6/UWSEO1MM7yOE6pe0x3ez1ZvjeOj8Kb7
         5wfKCFm8LINoMaQbIaFWJVdLc2Ryf27o+ao3F8TKKptlXopQ4J4FV1L78ozJ4c/kme5j
         35czCQuGpzLdqbMgc3Mp8lkpYKmL/eTkcVBTpTF1ZzwOnPB7K0upUA0AjiSVMISXXrZ5
         RR69OieRZskmrebZatm4zYiVbbWXpsj2VVh870svWZTI2Ev9Z3+wfKEwu3u1fejJZxYI
         +ikw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G8Etyj0cDehLQxOdGo9bhC3mChBu+Y3r0eXmFrlqHZ0=;
        b=tm/OKq9SAZdak+XcCdZkLEJ5TaL/oG7ANCXI4haw4mewIiXpei1ocx9biymjdZG1F/
         vN/ibclnqepYhJ3kLRPzu+Dd2TnSDwCWR7uasKOfr+jrhesqP4RT1o0jpmoYGlj3LZ7W
         qBcE7PtAeUY9z+vn6WWQHRtAV5dz5G5pHmsIwxKvV1YjgoCsigMbmi9Mmkyok1gOIYkV
         p1uHqM7aLhxfslYjxZzfkp+7w0a0wgtRRUYWvRWV8Nft3CHJl9Rub7fm4q8bUoWW7cE2
         P1UdFudt70X5qPIaslLwj0EoYV3EN16m3HhxXOCEDDB2BQ909eysL+LIfBZS6yyJCcJx
         IfOQ==
X-Gm-Message-State: AOAM530RnQEa6LU2CcYct14+O8YO3gGumDMCjkcJURFMFkVVIlqSteKG
        Y0D9avcRdwzSBIEXHSYNzoUWQ4BK43hRDNXfz4oUew==
X-Google-Smtp-Source: ABdhPJz6JN0h9K+6er6WuR/4o4VYrBTYbQjoFXcx45Uy8Nh+15e+F57Lec0Ec1+KvQ/7xVFoPusZCCep5JqYDi2Nwdc=
X-Received: by 2002:a25:1e0b:: with SMTP id e11mr40971689ybe.272.1642611481430;
 Wed, 19 Jan 2022 08:58:01 -0800 (PST)
MIME-Version: 1.0
References: <20211214011823.3277011-1-aaronlewis@google.com>
 <20211214011823.3277011-4-aaronlewis@google.com> <Yd8+n+/2GCZtIhaB@google.com>
In-Reply-To: <Yd8+n+/2GCZtIhaB@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 19 Jan 2022 16:57:50 +0000
Message-ID: <CAAAPnDG+eoE42se67ZFaeBG7H6QeAwx2LpZuVqKuXL_eY4eq=g@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/4] x86: Add a test framework for
 nested_vmx_reflect_vmexit() testing
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>
> > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> > index 9fcdcae..0353b69 100644
> > --- a/x86/unittests.cfg
> > +++ b/x86/unittests.cfg
> > @@ -368,6 +368,13 @@ arch = x86_64
> >  groups = vmx nested_exception
> >  check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
> >
> > +[vmx_exception_test]
> > +file = vmx.flat
> > +extra_params = -cpu max,+vmx -append vmx_exception_test
> > +arch = x86_64
> > +groups = vmx nested_exception
> > +timeout = 10
>
> Why add a new test case instead of folding this into "vmx"?  It's quite speedy.
> The "vmx" bucket definitely needs some cleanup, but I don't thinking adding a bunch
> of one-off tests is the way forward.
>

I'm not sure I follow.  The test does run in the "vmx" bucket
AFAICT... Oh, do you mean it should be added to the extra_params here
along with the other tests?

[vmx]
file = vmx.flat
extra_params = -cpu max,+vmx -append "-exit_monitor_from_l2_test
-ept_access* -vmx_smp* -vmx_vmcs_shadow_test
-atomic_switch_overflow_msrs_test -vmx_init_signal_test
-vmx_apic_passthrough_tpr_threshold_test -apic_reg_virt_test
-virt_x2apic_mode_test -vmx_pf_exception_test -vmx_pf_no_vpid_test
-vmx_pf_invvpid_test -vmx_pf_vpid_test"
arch = x86_64
groups = vmx

>
> > +
> >  [debug]
> >  file = debug.flat
> >  arch = x86_64
> > diff --git a/x86/vmx.c b/x86/vmx.c
> > index f4fbb94..9908746 100644
> > --- a/x86/vmx.c
> > +++ b/x86/vmx.c
> > @@ -1895,6 +1895,23 @@ void test_set_guest(test_guest_func func)
>
