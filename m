Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1333C432CD8
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 06:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbhJSEk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 00:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhJSEkz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 00:40:55 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40953C06161C
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 21:38:42 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id q16so3745201ljg.3
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 21:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iggwi4yG3yf67zEPdNhBZkWJtF+HNifGTjGtXUy1F7I=;
        b=peStbausGMdL7eLQviF6p1goxo122NP8El9gp1IZ6Y5qi3012Q9yZqjQecM9+RnoG1
         4rmUTIM+d+IG+d5Y/Mu5Fy60PYyNvTzucLAtHGkM6GNgZG37o8KIgTm2f+VdcpWyGGnb
         nwM1OBH6dELS3TGDsFSnVlZS7B/SMFPdaswSkxArcHhgChSt07ldMhoOgWod2uqUwIH7
         NnPrsm8auEgl3IDeTU0wBqIVms4oXPrmb9HZUk4/5Lc28HDjS5A+f5IWZGm5uL2+Vb7L
         /S+Dkw6AqkW4i+zh8IvlrdT4A3qwfiJHskFHgiiW7eP/ICgNRXHIinO9Y0wED/LrOli0
         hiFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iggwi4yG3yf67zEPdNhBZkWJtF+HNifGTjGtXUy1F7I=;
        b=U4/lPCZMvneD5OLo07xw8qxr1lOBlFQD1QfAT4sM6JxMgjrcI23ejIBOM9C+8QlA2a
         SYnx+onI3KwAgsajERXDMfWsVLM+5Y+fPevU8DJ5eyIK11QP+SlCOErDwjUk4HysGKZG
         iPc27ZGrvmvn0/V2qfzZ0AHJQhUbbQMf94V6jYATZLACJ7I6DP2iKLhsF3VjRhS4cNsm
         /S0Gmu01Qyy09rujx19zh9/yw1K6GbgTXT3nf1ExQYSGH7kbIrxn4h5AeY6T0OzOwljh
         r3tQ0tt28w6bo73IfkYCgOkQGe5jfUf0Nv3ty/FZfXi4xr1lhGSCEhZgroU/0ob1DFdf
         WtfA==
X-Gm-Message-State: AOAM531fJnjXVWeHiLqQCXWeLnNc9lIL0LmzN1w9SlQhQ7ojYBV4676M
        3yRUzs5525vXvcDT5RmKmx39BGgQQtAnZUVIdy4=
X-Google-Smtp-Source: ABdhPJzH8wUAzQ2lq8GqNL1MMr/q+tlBIKnGSo/3LqYA4Q22xJyEezB69Pvs9cYdGxP1L9aARC/pHek1qW2HoPda9fg=
X-Received: by 2002:a2e:a5c8:: with SMTP id n8mr4206215ljp.307.1634618320558;
 Mon, 18 Oct 2021 21:38:40 -0700 (PDT)
MIME-Version: 1.0
References: <20211004204931.1537823-1-zxwang42@gmail.com> <20211004204931.1537823-18-zxwang42@gmail.com>
 <6a5a16f7-c350-a48d-c5e7-352455b57c09@suse.com>
In-Reply-To: <6a5a16f7-c350-a48d-c5e7-352455b57c09@suse.com>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Mon, 18 Oct 2021 21:38:00 -0700
Message-ID: <CAEDJ5ZQbXK=Gtf_QH2PMNEOBo++7vsa84zZ3G8rzM=TH+JUrQQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 17/17] x86 AMD SEV-ES: Add test cases
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Orr <marcorr@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Tom Roeder <tmroeder@google.com>, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com,
        "Singh, Brijesh" <brijesh.singh@amd.com>, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 18, 2021 at 4:47 AM Varad Gautam <varad.gautam@suse.com> wrote:
>
> Hi Zixuan,
>
> On 10/4/21 10:49 PM, Zixuan Wang wrote:
> > From: Zixuan Wang <zixuanwang@google.com>
> > +static int test_sev_es_msr(void)
> > +{
> > +     /*
> > +      * With SEV-ES, rdmsr/wrmsr trigger #VC exception. If #VC is handled
> > +      * correctly, rdmsr/wrmsr should work like without SEV-ES and not crash
> > +      * the guest VM.
> > +      */
> > +     u64 val = 0x1234;
> > +     wrmsr(MSR_TSC_AUX, val);
> > +     if(val != rdmsr(MSR_TSC_AUX)) {
> > +             return EXIT_FAILURE;
>
> See note below.
>
> > +     }
> > +
> > +     return EXIT_SUCCESS;
> > +}
> > +
> >  int main(void)
> >  {
> >       int rtn;
> >       rtn = test_sev_activation();
> >       report(rtn == EXIT_SUCCESS, "SEV activation test.");
> > +     rtn = test_sev_es_activation();
> > +     report(rtn == EXIT_SUCCESS, "SEV-ES activation test.");
> > +     rtn = test_sev_es_msr();
>
> There is nothing SEV-ES specific about this function, it only wraps
> rdmsr/wrmsr, which are supposed to generate #VC exceptions on SEV-ES.
> Since the same scenario can be covered by running the msr testcase
> as a SEV-ES guest and observing if it crashes, does testing
> rdmsr/wrmsr one more time here gain us any new information?
>
> Also, the function gets called from main() even if
> test_sev_es_activation() failed or SEV-ES was inactive.
>
> Note: More broadly, what are you looking to test for here?
> 1. wrmsr/rdmsr correctness (rdmsr reads what wrmsr wrote)? or,
> 2. A #VC exception not causing a guest crash on SEV-ES?
>
> If you are looking to test 1., I suggest letting it be covered by
> the generic testcases for msr.
>
> If you are looking to test 2., perhaps a better test is to trigger
> all scenarios that would cause a #VC exception (eg. test_sev_es_vc_exit)
> and check that a SEV-ES guest survives.
>
> Regards,
> Varad
>

Hi Varad,

This test case does not bring any SEV-related functionality testing.
Instead, it is provided for development, i.e., one can check if SEV is
properly set up by monitoring if this test case runs fine without
crashes.

Since this test case is causing some confusion and does not bring any
functionality testing, I can remove it from the next version. We can
still verify the SEV setup process by checking if an existing test
case (e.g., x86/msr.c) runs without crashes in a SEV guest.

It's hard for me to develop a meaningful SEV test case, because I just
finished my Google internship and thus lost access to SEV-enabled
machines.

Best regards,
Zixuan
