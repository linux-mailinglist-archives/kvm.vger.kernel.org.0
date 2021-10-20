Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33956435234
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 19:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhJTSBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 14:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbhJTSBs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 14:01:48 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B82C06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 10:59:33 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id o26so14033626ljj.2
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 10:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H55P3FKMQ/UIY653Lv+bO0WwQ9wyS/v5N4U0fVD6CIc=;
        b=dhEhJaww8DonZ4hyARaKR5OrR6HVJk2XwPBTVecClz9/CE9qfdpDeplMZFP+oeTZ1G
         +BPrmaTOtrk6r6/3zo+Lk5xZvvo9+/V9igCfdJJZCdrRCTZjbzkXTVGkqlriXV7ImNSY
         LUb88e4ay/bhf7P0oRia5lwAcexTvwpoUTD9K+54E8ktaGZg3CY02j/3FknZM9RobTEr
         Iz78DUUs2wHDVNd0UdFNBXPzub7IgzWxISArGsbSeXmHtKbNg6bpOQL/TxM/m9kEClc6
         JENc7090hFPGf8q2l1QVelgvkwJMIxWe10DThEJIaV/pwqrmKks0lwTCnWaA5Tasn00X
         sSbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H55P3FKMQ/UIY653Lv+bO0WwQ9wyS/v5N4U0fVD6CIc=;
        b=EwsGR+5Ov9esPLYWIgekYGzSfmWRDi2qYVz7GFQ+FJ58Pw8xO7g7QmB03XDysuE5L/
         ajMVGQ2Oal6OMld3uk0ZHciP4yBZFzIjkpztwA0Q71MaYVHEBIXzYU3QIbh+4Yp/z9iT
         Z07eiC/VerZ8fIjKLG9ZA9/vVfJ2I2cGZQHRSRGZHHTYyKx36HgBCQnwyQD4U+KxoGL4
         6dTLSUDzMpPKlfmdzDegyD9CpaaC8bhe1CxtdkVAuOUlY5IX77ZzUBn0SIfUrRiN/ZMS
         RRP4pv3jz+2SXX4wtt7gjRJ8iu82l3ei2rDfwsLTqF++GC1MpdglwepuT1JoOg3C/05K
         rwpA==
X-Gm-Message-State: AOAM533BtySXCN67EoBlvpPAD4i2osE/cAiCT/QcmGnwDivTHH504yBV
        mw5Ae/fI8xzO4RQa39pqp21An048dS9Ls8P69o7mQV5DAHQ=
X-Google-Smtp-Source: ABdhPJwMXvKwNtOgF34BUURCY3oeTUzcZKzfmJbyXDDBtB26Kg2SSDtzE/wy5mu99tvqZxBvcO/u85yGm4qNP/Liduo=
X-Received: by 2002:a2e:b8c3:: with SMTP id s3mr599203ljp.44.1634752771470;
 Wed, 20 Oct 2021 10:59:31 -0700 (PDT)
MIME-Version: 1.0
References: <20211004204931.1537823-1-zxwang42@gmail.com> <20211004204931.1537823-18-zxwang42@gmail.com>
 <6a5a16f7-c350-a48d-c5e7-352455b57c09@suse.com> <CAEDJ5ZQbXK=Gtf_QH2PMNEOBo++7vsa84zZ3G8rzM=TH+JUrQQ@mail.gmail.com>
 <CAA03e5HL0aiByPGiO5mescTHNM=DT69Kx=ep=cS-De8u+tvaMA@mail.gmail.com> <20211019153103.6bvrualmzksdaav5@gator.home>
In-Reply-To: <20211019153103.6bvrualmzksdaav5@gator.home>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Wed, 20 Oct 2021 10:59:00 -0700
Message-ID: <CAEDJ5ZRMTV6zPj2DZk1UVKPXZ8Zaqzmn6Yy295hXmjM4DsRRJw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 17/17] x86 AMD SEV-ES: Add test cases
To:     Andrew Jones <drjones@redhat.com>
Cc:     Marc Orr <marcorr@google.com>,
        Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
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

On Tue, Oct 19, 2021 at 8:31 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Tue, Oct 19, 2021 at 07:14:47AM -0700, Marc Orr wrote:
> > On Mon, Oct 18, 2021 at 9:38 PM Zixuan Wang <zxwang42@gmail.com> wrote:
> > >
> > > On Mon, Oct 18, 2021 at 4:47 AM Varad Gautam <varad.gautam@suse.com> wrote:
> > > >
> > > > Hi Zixuan,
> > > >
> > > > On 10/4/21 10:49 PM, Zixuan Wang wrote:
> > > > > From: Zixuan Wang <zixuanwang@google.com>
> > > > >  int main(void)
> > > > >  {
> > > > >       int rtn;
> > > > >       rtn = test_sev_activation();
> > > > >       report(rtn == EXIT_SUCCESS, "SEV activation test.");
> > > > > +     rtn = test_sev_es_activation();
> > > > > +     report(rtn == EXIT_SUCCESS, "SEV-ES activation test.");
> > > > > +     rtn = test_sev_es_msr();
> > > >
> > > > There is nothing SEV-ES specific about this function, it only wraps
> > > > rdmsr/wrmsr, which are supposed to generate #VC exceptions on SEV-ES.
> > > > Since the same scenario can be covered by running the msr testcase
> > > > as a SEV-ES guest and observing if it crashes, does testing
> > > > rdmsr/wrmsr one more time here gain us any new information?
> > > >
> > > > Also, the function gets called from main() even if
> > > > test_sev_es_activation() failed or SEV-ES was inactive.
> > > >
> > > > Note: More broadly, what are you looking to test for here?
> > > > 1. wrmsr/rdmsr correctness (rdmsr reads what wrmsr wrote)? or,
> > > > 2. A #VC exception not causing a guest crash on SEV-ES?
> > > >
> > > > If you are looking to test 1., I suggest letting it be covered by
> > > > the generic testcases for msr.
> > > >
> > > > If you are looking to test 2., perhaps a better test is to trigger
> > > > all scenarios that would cause a #VC exception (eg. test_sev_es_vc_exit)
> > > > and check that a SEV-ES guest survives.
> > > >
> > > > Regards,
> > > > Varad
> > > >
> > >
> > > Hi Varad,
> > >
> > > This test case does not bring any SEV-related functionality testing.
> > > Instead, it is provided for development, i.e., one can check if SEV is
> > > properly set up by monitoring if this test case runs fine without
> > > crashes.
> > >
> > > Since this test case is causing some confusion and does not bring any
> > > functionality testing, I can remove it from the next version. We can
> > > still verify the SEV setup process by checking if an existing test
> > > case (e.g., x86/msr.c) runs without crashes in a SEV guest.
> > >
> > > It's hard for me to develop a meaningful SEV test case, because I just
> > > finished my Google internship and thus lost access to SEV-enabled
> > > machines.
> >
> > Removing this test case is fine. Though, it is convenient. But I
> > agree, it's redundant. Maybe we can tag any tests that are good to run
> > under SEV and/or SEV-ES via the `groups` field in the
> > x86/unittests.cfg file. The name `groups` is plural. So I assume that
> > a test can be a member of multiple groups. But I see no examples.
> >
>
> Yes, groups is specified to accept more than one group with space
> separation (see the comment block at the top of the unittests file).
> I see a couple instances where groups are comma separated, but that
> should be changed, especially since commit b373304853a0 ("scripts:
> Fix the check whether testname is in the only_tests list") was merged.
> I'll send a patch for that.
>
> Thanks,
> drew
>

Great! Marc and I are working on labeling test cases as different
groups. We are now trying to label an 'efi' group for test cases that
can run under UEFI, and if necessary, a 'sev' group for those that can
run under SEV.

Best regards,
Zixuan
