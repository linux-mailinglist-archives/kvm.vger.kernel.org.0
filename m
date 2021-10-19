Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18AA1433830
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 16:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhJSORN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 10:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbhJSORM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 10:17:12 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F06CC06161C
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 07:15:00 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id r6so5138958oiw.2
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 07:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7iTaKErvHrhgu3OZoCmI7E/XLRy71vcm0vkVqTmS1EU=;
        b=D8+/YFEVxwCWT1+AoXBIpx3jIjJ3uBZCtiL+moksqZz5hi87BoDr/dxS6Y+g98w7xu
         p+ao1I+ua5xlu2MSzj6a9EMsmsLFpythqbwxgKjwU8IliqtpStPTCOWqj8pUj7CVFSdT
         sq7wMRwlQQAy27i0cgIIInRmfz9k8Gp5ENHqZr2U+Bck09WQvtNLjIm5oWIaIs+YiXe3
         Iy3j92GSpUrn2ZURrDLwNV/voT2yQEJazEwN5iCWidF+jqI6v96/URk0mBh1V5b5HLRP
         +gYxk0/yTd2P3c4szjkrIGAqClZkwHYHCCNf8o4+IEGEFOgW1fgoKWvBh9MFdwzR63Od
         iGPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7iTaKErvHrhgu3OZoCmI7E/XLRy71vcm0vkVqTmS1EU=;
        b=vvuFypXuNOuPtueD2AoZhlgMBOiSXEji3m1GOMxGfIQSP16Gzhgl31OgcW57j9dIo7
         NBZbNVKNXQznc9k/l3PFayNXmXUQXXRuJd7vc4Q6jjLQ/Rz2xyc13/7x+/z7nVrbcJ2H
         4/vpnSCueG6yAxUEU/O/kEHItoQ6AnL5AAi5uklytEgZme3i2235WHId60l9eDD6JoS7
         Ktg2vopVi8gLBK8HGgHoY7otF6rd55wCAiPD/ALvZvG0veHioeRDSZe8dqSjbFvx6CRj
         WuhiECknaPeXvbTLJ3wAsamWk2Hq8ENDqCRsV3FnxXzXtAAWfmcDXeZWIaJ/ux8LgxKi
         UsLA==
X-Gm-Message-State: AOAM531vQZmztmYEkZduLSQQe3iaDbjEXt0nGgZR+2Zrgxh/QVGQ/4YM
        xvQR1VqjSJzRromdTXKUByxIJ+odu2oPDX4fNrcvRQ==
X-Google-Smtp-Source: ABdhPJyYqfLYfuAhvKJzYwE/REIMUlHbuIcAm4xnp59DmMoqpRNVmrCRF0Pr/m0nLsDS0G+S/URRSaf9xFC/wlyAgKs=
X-Received: by 2002:a05:6808:57:: with SMTP id v23mr4356600oic.172.1634652898717;
 Tue, 19 Oct 2021 07:14:58 -0700 (PDT)
MIME-Version: 1.0
References: <20211004204931.1537823-1-zxwang42@gmail.com> <20211004204931.1537823-18-zxwang42@gmail.com>
 <6a5a16f7-c350-a48d-c5e7-352455b57c09@suse.com> <CAEDJ5ZQbXK=Gtf_QH2PMNEOBo++7vsa84zZ3G8rzM=TH+JUrQQ@mail.gmail.com>
In-Reply-To: <CAEDJ5ZQbXK=Gtf_QH2PMNEOBo++7vsa84zZ3G8rzM=TH+JUrQQ@mail.gmail.com>
From:   Marc Orr <marcorr@google.com>
Date:   Tue, 19 Oct 2021 07:14:47 -0700
Message-ID: <CAA03e5HL0aiByPGiO5mescTHNM=DT69Kx=ep=cS-De8u+tvaMA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 17/17] x86 AMD SEV-ES: Add test cases
To:     Zixuan Wang <zxwang42@gmail.com>
Cc:     Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>,
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

On Mon, Oct 18, 2021 at 9:38 PM Zixuan Wang <zxwang42@gmail.com> wrote:
>
> On Mon, Oct 18, 2021 at 4:47 AM Varad Gautam <varad.gautam@suse.com> wrote:
> >
> > Hi Zixuan,
> >
> > On 10/4/21 10:49 PM, Zixuan Wang wrote:
> > > From: Zixuan Wang <zixuanwang@google.com>
> > > +static int test_sev_es_msr(void)
> > > +{
> > > +     /*
> > > +      * With SEV-ES, rdmsr/wrmsr trigger #VC exception. If #VC is handled
> > > +      * correctly, rdmsr/wrmsr should work like without SEV-ES and not crash
> > > +      * the guest VM.
> > > +      */
> > > +     u64 val = 0x1234;
> > > +     wrmsr(MSR_TSC_AUX, val);
> > > +     if(val != rdmsr(MSR_TSC_AUX)) {
> > > +             return EXIT_FAILURE;
> >
> > See note below.
> >
> > > +     }
> > > +
> > > +     return EXIT_SUCCESS;
> > > +}
> > > +
> > >  int main(void)
> > >  {
> > >       int rtn;
> > >       rtn = test_sev_activation();
> > >       report(rtn == EXIT_SUCCESS, "SEV activation test.");
> > > +     rtn = test_sev_es_activation();
> > > +     report(rtn == EXIT_SUCCESS, "SEV-ES activation test.");
> > > +     rtn = test_sev_es_msr();
> >
> > There is nothing SEV-ES specific about this function, it only wraps
> > rdmsr/wrmsr, which are supposed to generate #VC exceptions on SEV-ES.
> > Since the same scenario can be covered by running the msr testcase
> > as a SEV-ES guest and observing if it crashes, does testing
> > rdmsr/wrmsr one more time here gain us any new information?
> >
> > Also, the function gets called from main() even if
> > test_sev_es_activation() failed or SEV-ES was inactive.
> >
> > Note: More broadly, what are you looking to test for here?
> > 1. wrmsr/rdmsr correctness (rdmsr reads what wrmsr wrote)? or,
> > 2. A #VC exception not causing a guest crash on SEV-ES?
> >
> > If you are looking to test 1., I suggest letting it be covered by
> > the generic testcases for msr.
> >
> > If you are looking to test 2., perhaps a better test is to trigger
> > all scenarios that would cause a #VC exception (eg. test_sev_es_vc_exit)
> > and check that a SEV-ES guest survives.
> >
> > Regards,
> > Varad
> >
>
> Hi Varad,
>
> This test case does not bring any SEV-related functionality testing.
> Instead, it is provided for development, i.e., one can check if SEV is
> properly set up by monitoring if this test case runs fine without
> crashes.
>
> Since this test case is causing some confusion and does not bring any
> functionality testing, I can remove it from the next version. We can
> still verify the SEV setup process by checking if an existing test
> case (e.g., x86/msr.c) runs without crashes in a SEV guest.
>
> It's hard for me to develop a meaningful SEV test case, because I just
> finished my Google internship and thus lost access to SEV-enabled
> machines.

Removing this test case is fine. Though, it is convenient. But I
agree, it's redundant. Maybe we can tag any tests that are good to run
under SEV and/or SEV-ES via the `groups` field in the
x86/unittests.cfg file. The name `groups` is plural. So I assume that
a test can be a member of multiple groups. But I see no examples.
