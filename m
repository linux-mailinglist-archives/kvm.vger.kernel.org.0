Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2A1221845
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 01:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgGOXNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 19:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbgGOXNE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 19:13:04 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D13C061755
        for <kvm@vger.kernel.org>; Wed, 15 Jul 2020 16:13:04 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id a11so3511930ilk.0
        for <kvm@vger.kernel.org>; Wed, 15 Jul 2020 16:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tOz1jJkVML1mQdocE25sKsIyj+RbAb/2bw/59L7mnd0=;
        b=S+l3EQOQN3PJrwVwEodMRcihRZ553OPkfTycoYBwGrjlvpy4QEFqWmpyUCdyW8paOu
         dcuoTXG/MGogW9IgH9NHx65sn6mAlcR84YTCLIJOXuNRenR2GvMzPWziw8sWr9H3UwHj
         KpjF2M/tMHkFTyz7myZwYocfNCqSM4IzxSorZHfqWEJhtob3qh5pa5egl0beyZjpXP40
         Tznu2v8CNNBM+VNXMvfxSQ+lgJn6O9yRKpsEWxqTxkSyhNZ7CQfyzdjklo4oJqV1NhfX
         FV5X8mdVYPe65Jq4iu6kDN2aMLClLt//+RDwqc2RYM4kipwXLOLfyArsWGYrp2Vv5CAa
         ewPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tOz1jJkVML1mQdocE25sKsIyj+RbAb/2bw/59L7mnd0=;
        b=cINPB5LmkNVYtmJEYa1Kx0KetNMbysxJI1chCNXzU/OHaz3NvHNZxI7blXLSpyVj4H
         I4y0qdV3TNMbDk0baedTKO9fHB+Go//gDsoH+7BO4i2LcoS8G7n2OUxwMFihvPcstEJ1
         53VLcK8/H4IyRZ3oOkoFQh+o4/TKetUUa6tjYzFDB+rzQUxZtu32tuEvUF6IzPaOfrtg
         Vrrbz/RZdrZGQn/bba8cFm/weZzn0g9jU1qwUNgiX+3zmhrn4etzOaI29NDqIsvLMnIx
         2utJtZYVylHDBH5Z61P4uHS324R4GdmyhfTTx5QjU0zEY2UqcwJC35Thu8RF7ARDqgt4
         IImQ==
X-Gm-Message-State: AOAM531OEZggd4c0+RdypgnV76qXKeyWf2d2wd2OfPEXr9K3kJsEeCbw
        3OoNG/LvPCZxilhkyf8ZY0HqI+fd6twknZT/upMwZg==
X-Google-Smtp-Source: ABdhPJxZtMeeNY8c7127DSlP7S7p+oXctQ1tCisQyulPVEAnDj0rBASLdsjp2Po0sArtmgrBiaQ09BPLGzPebfaSBpA=
X-Received: by 2002:a92:b685:: with SMTP id m5mr1853432ill.118.1594854783053;
 Wed, 15 Jul 2020 16:13:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200713043908.39605-1-namit@vmware.com> <ce87fd51-8e27-e5ff-3a90-06cddbf47636@oracle.com>
 <CCEF21D4-57C3-4843-9443-BE46501FFE8C@vmware.com> <abe9138a-6c61-22e1-f0a6-fcd5d06ef3f1@oracle.com>
 <6CD095D7-EF7F-49C2-98EF-F72D019817B2@vmware.com> <fe76d847-5106-bc09-e4cf-498fb51e5255@oracle.com>
 <9DC37B0B-597A-4B31-8397-B6E4764EEA37@vmware.com> <ab9f1669-a295-1022-a62a-8b64c90f6dcb@oracle.com>
In-Reply-To: <ab9f1669-a295-1022-a62a-8b64c90f6dcb@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 15 Jul 2020 16:12:51 -0700
Message-ID: <CALMp9eSoRSKBvNwjm5fpPG2XDJnnC1b-tm68P-K_Jnyab4aPMg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: svm: low CR3 bits are not MBZ
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Nadav Amit <namit@vmware.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 15, 2020 at 3:40 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 7/15/20 3:27 PM, Nadav Amit wrote:
> >> On Jul 15, 2020, at 3:21 PM, Krish Sadhukhan <krish.sadhukhan@oracle.c=
om> wrote:
> >>
> >>
> >> On 7/13/20 4:30 PM, Nadav Amit wrote:
> >>>> On Jul 13, 2020, at 4:17 PM, Krish Sadhukhan <krish.sadhukhan@oracle=
.com> wrote:
> >>>>
> >>>>
> > [snip]
> >
> >>>> I am just saying that the APM language "should be cleared to 0" is m=
isleading if the processor doesn't enforce it.
> >>> Just to ensure I am clear - I am not blaming you in any way. I also f=
ound
> >>> the phrasing confusing.
> >>>
> >>> Having said that, if you (or anyone else) reintroduces =E2=80=9Cposit=
ive=E2=80=9D tests, in
> >>> which the VM CR3 is modified to ensure VM-entry succeeds when the res=
erved
> >>> non-MBZ bits are set, please ensure the tests fails gracefully. The
> >>> non-long-mode CR3 tests crashed since the VM page-tables were incompa=
tible
> >>> with the paging mode.
> >>>
> >>> In other words, instead of setting a VMMCALL instruction in the VM to=
 trap
> >>> immediately after entry, consider clearing the present-bits in the hi=
gh
> >>> levels of the NPT; or injecting some exception that would trigger exi=
t
> >>> during vectoring or something like that.
> >>>
> >>> P.S.: If it wasn=E2=80=99t clear, I am not going to fix KVM itself fo=
r some obvious
> >>> reasons.
> >> I think since the APM is not clear, re-adding any test that tests thos=
e bits, is like adding a test with "undefined behavior" to me.
> >>
> >>
> >> Paolo, Should I send a KVM patch to remove checks for those non-MBZ re=
served bits ?
> > Which non-MBZ reserved bits (other than those that I addressed) do you =
refer
> > to?
> >
> I am referring to,
>
>      "[PATCH 2/3 v4] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are
> not set on vmrun of nested guests"
>
> in which I added the following:
>
>
> +#define MSR_CR3_LEGACY_RESERVED_MASK        0xfe7U
> +#define MSR_CR3_LEGACY_PAE_RESERVED_MASK    0x7U
> +#define MSR_CR3_LONG_RESERVED_MASK        0xfff0000000000fe7U

In my experience, the APM generally distinguishes between "reserved"
and "reserved, MBZ." The low bits you have indicated for CR3 are
marked only as "reserved" in Figures 3-4, 3-5, and 3-6 of the APM,
volume 2. Only bits 63:52 are marked as "reserved, MBZ." (In fact,
Figure 3-6 of the May 2020 version of the APM, revision 3.35, also
calls out bits 11:0 as the PCID when CR4.PCIDE is set.)

Of course, you could always test the behavior. :-)
