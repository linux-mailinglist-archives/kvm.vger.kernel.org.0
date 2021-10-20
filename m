Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5489D43523C
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 20:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhJTSCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 14:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbhJTSCi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 14:02:38 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E05C06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 11:00:23 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 145so14022710ljj.1
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 11:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uaajOdBb5o8GpJ5LszUoXImIH2hMWTsxvF1LpqVJ5wI=;
        b=FL3zGsqGGGcSPxBpLLim2N19Dw7ix6ft2DMBMa/qJmXFXXXBFYeu4JJz8xE21yw/x8
         MFkxdUZZVlskcpymml0yumXHglfUUHm8yNA6glZoqNjUa48ePxFsbJ24ZcGtj67yn2WE
         QPaCZFF5VizJDFufnbJuVFCmJGCpd25nRrdlaWiwcvnilcOhgBQ4eJ41nqhMFFMuaf5R
         zjFmLsWi5HVdn+eqMa2lLaZ2eDQ5kDkPc3WM1owk1b86txx1mPB/3kY3NSFP3TAKvPx/
         HTHiVA6Ok64CuyFHLKIrkr7DlSrNQi27txeZaeKWGTw+tK98OrC3VSnHZnHKoAsdy4nf
         1/fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uaajOdBb5o8GpJ5LszUoXImIH2hMWTsxvF1LpqVJ5wI=;
        b=KCBgrlZqTu5UWbzGGriifecbMyNGhgwazd+opVv5GkBl6n1m9R0nLjftGZiH+MW3+b
         P2xWebb8+eORlCb2sC2wXQLRuRmIylbiCN1aCoIHSSVw652H9k/VVmRuKObdRT8J2CJQ
         mVL3cE2W9S19P/EsLcdj0aTWoauTKnE+sZE27eH80K9gvmawV94+aQMSm2ZuW1NdFWnt
         ugmwynq0kVHdaVlKpRadp9ixro9OhV4i1mqsIfI90DnMrgMborS76jUNObMguD72bbOe
         DsyCEkkIEu6BnRdXn7X29eZbsi7GjWzrDJpEhyECc1H09o+RlerTxuiKC5lyFUIvD13c
         5evQ==
X-Gm-Message-State: AOAM5300lhG7zo7PWFUMFuMQQiGH0zj1Q5cq3Tmit9GNVfUr2fLCIpDY
        jHHQUcocmdz7/VPhnne3WctsAhJOoyu7wJY+BkA=
X-Google-Smtp-Source: ABdhPJzqzRnhyAb5QSJ4tStu5d9VpPDPAO83af3DxfwLBze+gowerGVQUGaIUAfRyT+XYcNS+OlkOp4gtAbtNPUaKdk=
X-Received: by 2002:a2e:a5c8:: with SMTP id n8mr528519ljp.307.1634752821985;
 Wed, 20 Oct 2021 11:00:21 -0700 (PDT)
MIME-Version: 1.0
References: <20211004204931.1537823-1-zxwang42@gmail.com> <20211004204931.1537823-18-zxwang42@gmail.com>
 <6a5a16f7-c350-a48d-c5e7-352455b57c09@suse.com> <CAEDJ5ZQbXK=Gtf_QH2PMNEOBo++7vsa84zZ3G8rzM=TH+JUrQQ@mail.gmail.com>
 <CAA03e5HL0aiByPGiO5mescTHNM=DT69Kx=ep=cS-De8u+tvaMA@mail.gmail.com> <32dba144-e0d4-6d91-5f79-6ed47fea6421@suse.com>
In-Reply-To: <32dba144-e0d4-6d91-5f79-6ed47fea6421@suse.com>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Wed, 20 Oct 2021 10:59:00 -0700
Message-ID: <CAEDJ5ZSioZmtvdijTgZTsVAv0QpFwUzawYqF31ELLKZc0WXGPg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 17/17] x86 AMD SEV-ES: Add test cases
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     Marc Orr <marcorr@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Tom Roeder <tmroeder@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 19, 2021 at 9:44 AM Varad Gautam <varad.gautam@suse.com> wrote:
>
> On 10/19/21 4:14 PM, Marc Orr wrote:
> > On Mon, Oct 18, 2021 at 9:38 PM Zixuan Wang <zxwang42@gmail.com> wrote:
> >>
> >> On Mon, Oct 18, 2021 at 4:47 AM Varad Gautam <varad.gautam@suse.com> wrote:
> >>>
> >>> Hi Zixuan,
> >>>
> >>> On 10/4/21 10:49 PM, Zixuan Wang wrote:
> >>>> From: Zixuan Wang <zixuanwang@google.com>
> >>>>  int main(void)
> >>>>  {
> >>>>       int rtn;
> >>>>       rtn = test_sev_activation();
> >>>>       report(rtn == EXIT_SUCCESS, "SEV activation test.");
> >>>> +     rtn = test_sev_es_activation();
> >>>> +     report(rtn == EXIT_SUCCESS, "SEV-ES activation test.");
> >>>> +     rtn = test_sev_es_msr();
> >>>
> >>> There is nothing SEV-ES specific about this function, it only wraps
> >>> rdmsr/wrmsr, which are supposed to generate #VC exceptions on SEV-ES.
> >>> Since the same scenario can be covered by running the msr testcase
> >>> as a SEV-ES guest and observing if it crashes, does testing
> >>> rdmsr/wrmsr one more time here gain us any new information?
> >>>
> >>> Also, the function gets called from main() even if
> >>> test_sev_es_activation() failed or SEV-ES was inactive.
> >>>
> >>> Note: More broadly, what are you looking to test for here?
> >>> 1. wrmsr/rdmsr correctness (rdmsr reads what wrmsr wrote)? or,
> >>> 2. A #VC exception not causing a guest crash on SEV-ES?
> >>>
> >>> If you are looking to test 1., I suggest letting it be covered by
> >>> the generic testcases for msr.
> >>>
> >>> If you are looking to test 2., perhaps a better test is to trigger
> >>> all scenarios that would cause a #VC exception (eg. test_sev_es_vc_exit)
> >>> and check that a SEV-ES guest survives.
> >>>
> >>> Regards,
> >>> Varad
> >>>
> >>
> >> Hi Varad,
> >>
> >> This test case does not bring any SEV-related functionality testing.
> >> Instead, it is provided for development, i.e., one can check if SEV is
> >> properly set up by monitoring if this test case runs fine without
> >> crashes.
> >>
> >> Since this test case is causing some confusion and does not bring any
> >> functionality testing, I can remove it from the next version. We can
> >> still verify the SEV setup process by checking if an existing test
> >> case (e.g., x86/msr.c) runs without crashes in a SEV guest.
> >>
> >> It's hard for me to develop a meaningful SEV test case, because I just
> >> finished my Google internship and thus lost access to SEV-enabled
> >> machines.
> >
> > Removing this test case is fine. Though, it is convenient. But I
> > agree, it's redundant. Maybe we can tag any tests that are good to run
> > under SEV and/or SEV-ES via the `groups` field in the
> > x86/unittests.cfg file. The name `groups` is plural. So I assume that
> > a test can be a member of multiple groups. But I see no examples.
> >
>
> Right, from a fleet owner perspective I can imagine the following scenarios
> being relevant to test for a SEV* offering (and I guess hence make sense to
> have a special test in kvm-unit-tests for):
> - CPUID shows the right SEV level
> - C-bit discovery
> - GHCB validity (protocol version etc.)
>
> Generic kvm behavior is better tested via the other dedicated tests, which,
> after the EFI-fication should be no problem to fit into a test plan. The
> SEV* implementation can then go through the whole battery of kvm-unit-tests
> plus the SEV* ones.
>
> Regards,
> Varad
>

Thank you for the summary! I will put a brief description in the V4
patchset about the future test cases, and a link to this discussion.

Best regards,
ZIxuan
