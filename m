Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CCB323520
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 02:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbhBXBRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 20:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234303AbhBXAnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 19:43:19 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17048C06178B
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 16:14:06 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id b8so491555oti.7
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 16:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sseUFd1M5hIi7lS5nl0dC8DPzkayojFtKjMg6ZLG1hs=;
        b=TCA5QIW3MRIB5WfSTn6/Ft4g2M8NMgkadQFr4xbLZTG8NpDshYj1nNHB3/oY+YLu8Q
         3janmITkuMGUcu5nGFWmU5P6hZ3932FmSmSumEhsG+ZwdF9hg0JXGstviaJHsJwyqUTs
         IBXOBJrRAVTD+B/SJTh01deEc6jhqYzlsO22XeI995COpjwuRC4dXc9g6kPYB2qG9BnW
         R6zQicvuJ40QoMxVrHz+3pMtclpp24caaRWdmSNiCH1XcHcAohtCX1kw9JEBpmW5wfJC
         PP4t2wacqHjXl74wVcS+5NK6lmQrASQsTS8eE7cnbVOBOZVnMys7RzLaLpqDvy1XZFS9
         XBiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sseUFd1M5hIi7lS5nl0dC8DPzkayojFtKjMg6ZLG1hs=;
        b=PcTE9mLeQqZfOqEyZ4Hm56JvTtuBr2JYW88jnxVrvke3qZIw+tZ5kQPWt04KEN9RX1
         u6UMRf0EIXCYiEvFwiF2UBfGUkW0wCrD5HTGA8d+WjIlJdJhKEJQo8vEPbtEcOEbosS5
         aHWfXlJzxASQ/+kCN7Oawnlkrf4yBCfEyJ4CKuZSdz9zRjYyy5hhJRnBPvR0YhoFLC02
         0T6mil5JKRumNR4A9lsp31oChbVwrzoKQXt5pNIpwg1u4hTexFfuJXdNflRW28Xm2n1F
         sNmMIJ8hVCJGxkBHqGn3JgpV31k5ntlMt4D1qNhrtNY27JPrvqgU431188tu2XeG1CKl
         PK+A==
X-Gm-Message-State: AOAM53209EsoDWBmakHxoV2ej9C+q/JNEMRfJBEzijfYW4CZH6gRDK8/
        1FEkd3a7CB7EMNrAyntChByA9TvRx0MD5EQbK1cxUQ==
X-Google-Smtp-Source: ABdhPJznDAjfwdLzjQBRIKI63AueRugLb1SlJ5dq1W1T+vQUWjHzDAefTWyM1fLugsoVvxOx/9xlhPAeyJK6abluXII=
X-Received: by 2002:a9d:a30:: with SMTP id 45mr17392282otg.241.1614125645751;
 Tue, 23 Feb 2021 16:14:05 -0800 (PST)
MIME-Version: 1.0
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
 <83a96ca9-0810-6c07-2e45-5aa2da9b1ab0@redhat.com> <5df9b517-448f-d631-2222-6e78d6395ed9@amd.com>
 <CALMp9eRDSW66+XvbHVF4ohL7XhThoPoT0BrB0TcS0cgk=dkcBg@mail.gmail.com>
 <bb2315e3-1c24-c5ae-3947-27c5169a9d47@amd.com> <CALMp9eQBY50kZT6WdM-D2gmUgDZmCYTn+kxcxk8EQTg=SygLKA@mail.gmail.com>
 <21ee28c6-f693-e7c0-6d83-92daa9a46880@amd.com> <01cf2fd7-626e-c084-5a6a-1a53d111d9fa@amd.com>
 <84f42bad-9fb0-8a76-7f9b-580898b634b9@amd.com> <032386c6-4b4c-2d3f-0f6a-3d6350363b3c@amd.com>
In-Reply-To: <032386c6-4b4c-2d3f-0f6a-3d6350363b3c@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 23 Feb 2021 16:13:54 -0800
Message-ID: <CALMp9eTTBcdADUYizO-ADXUfkydVGqRm0CSQUO92UHNnfQ-qFw@mail.gmail.com>
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Any updates? What should we be telling customers with Debian 9 guests? :-)

On Fri, Jan 22, 2021 at 5:52 PM Babu Moger <babu.moger@amd.com> wrote:
>
>
>
> On 1/21/21 5:51 PM, Babu Moger wrote:
> >
> >
> > On 1/20/21 9:10 PM, Babu Moger wrote:
> >>
> >>
> >> On 1/20/21 3:45 PM, Babu Moger wrote:
> >>>
> >>>
> >>> On 1/20/21 3:14 PM, Jim Mattson wrote:
> >>>> On Tue, Jan 19, 2021 at 3:45 PM Babu Moger <babu.moger@amd.com> wrot=
e:
> >>>>>
> >>>>>
> >>>>>
> >>>>> On 1/19/21 5:01 PM, Jim Mattson wrote:
> >>>>>> On Mon, Sep 14, 2020 at 11:33 AM Babu Moger <babu.moger@amd.com> w=
rote:
> >>>>>>
> >>>>>>> Thanks Paolo. Tested Guest/nested guest/kvm units tests. Everythi=
ng works
> >>>>>>> as expected.
> >>>>>>
> >>>>>> Debian 9 does not like this patch set. As a kvm guest, it panics o=
n a
> >>>>>> Milan CPU unless booted with 'nopcid'. Gmail mangles long lines, s=
o
> >>>>>> please see the attached kernel log snippet. Debian 10 is fine, so =
I
> >>>>>> assume this is a guest bug.
> >>>>>>
> >>>>>
> >>>>> We had an issue with PCID feature earlier. This was showing only wi=
th SEV
> >>>>> guests. It is resolved recently. Do you think it is not related tha=
t?
> >>>>> Here are the patch set.
> >>>>> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2=
Flore.kernel.org%2Fkvm%2F160521930597.32054.4906933314022910996.stgit%40bmo=
ger-ubuntu%2F&amp;data=3D04%7C01%7CBabu.Moger%40amd.com%7C3009e5f7f32b4dbd4=
aee08d8bdc045c9%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C63746798084137=
6327%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik=
1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3D%2Bva7em372XD7uaCrSy3UBH6a9n8xaTTXW=
CAlA3gJX78%3D&amp;reserved=3D0
> >>>>
> >>>> The Debian 9 release we tested is not an SEV guest.
> >>> ok. I have not tested Debian 9 before. I will try now. Will let you k=
now
> >>> how it goes. thanks
> >>>
> >>
> >> I have reproduced the issue locally. Will investigate. thanks
> >>
> > Few updates.
> > 1. Like Jim mentioned earlier, this appears to be guest kernel issue.
> > Debian 9 runs the base kernel 4.9.0-14. Problem can be seen consistentl=
y
> > with this kernel.
> >
> > 2. This guest kernel(4.9.0-14) does not like the new feature INVPCID.
> >
> > 3. System comes up fine when invpcid feature is disabled with the boot
> > parameter "noinvpcid" and also with "nopcid". nopcid disables both pcid
> > and invpcid.
> >
> > 4. Upgraded the guest kernel to v5.0 and system comes up fine.
> >
> > 5. Also system comes up fine with latest guest kernel 5.11.0-rc4.
> >
> > I did not bisect further yet.
> > Babu
> > Thanks
>
>
> Some more update:
>  System comes up fine with kernel v4.9(checked out on upstream tag v4.9).
> So, I am assuming this is something specific to Debian 4.9.0-14 kernel.
>
> Note: I couldn't go back prior versions(v4.8 or earlier) due to compile
> issues.
> Thanks
> Babu
>
