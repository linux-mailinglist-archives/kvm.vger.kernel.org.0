Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A289FCEBF
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 20:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfKNT1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 14:27:51 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:40621 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbfKNT1u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 14:27:50 -0500
Received: by mail-io1-f66.google.com with SMTP id p6so8109576iod.7
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 11:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=REvJGBqtN17t/Kpi8Drm01nVRUzEJ8Px9ug31PYdiig=;
        b=bkTP4tD0KoFK5EgiU/VRa4wtv5URuKzQYq/mSCkaNkwZRGNrlBTY4nexeB3QjYsjC+
         +DrqwgaRpf2MRrIb7uYqqkBS/uNsISF5wamKF3c/JLjW60AYHfZBMJgvfKTNbPwU9RlI
         7i35g0V9NQwaK0uKoaxzkEKWpxXhjhSoe/0C0QQv7VqiDsRJKzYn4GzgV3Wd9ufDAim9
         8rEeU0Ew93wfJ32ZkgoUuXAhA3X/Db41Ag3gp58sM0xEPizKgv6Q9i7BwhjUPwr0fWHv
         UpSnBhXjQnmLsO06mTSI3zF9GRbclW8AWNWjV2EHNh8Xf0TaqL7UpgGbwH+OK0PetAi0
         jyhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=REvJGBqtN17t/Kpi8Drm01nVRUzEJ8Px9ug31PYdiig=;
        b=kzVdPe2SVYh+zptNFVO3hys39XEfgqCypOlEaZPJB196tDB8uiDYNrHlYRjFO2B1Fw
         dATnTVI7ijili9+N8furOkYY8QEr6R7KMGo7Pb37prPrG/zbeTC+ZVc5PAegwNpEjmXJ
         DK0vsQt7E9VSxxLLL9glPx0JBOVj7NltOu5PKtJm7ZEtcEfaeKyZfEz5uDbxVuLpQZET
         Mil26xmlu3FDwWrNDCk+gD1T8pqfoWTz7YLazhOzPm7D26Y+2wkkKSy7iYbcf0W23cW2
         fDxBfli9f4AX5ihb6lb+tpETu2wbOtW5a4OdAFuMA+5FM8ZItqFu9LwYDniZ9+48gIwb
         qFRg==
X-Gm-Message-State: APjAAAVhUNoM9btpkH60v+Q7fXxcUjlb9XwfpxF/KKJ3kvCk7rZzpiTe
        C4P6vSwLyjNr44mmOf91hVpjcagjxP0kigtl8LQvdUDGsC8=
X-Google-Smtp-Source: APXvYqyRnFZszxqERekTTfb9VacIRa+G5RpC59jH+JXd4EJy8Rt6mj6evr+Y29HBgmxCSNBJDvoLO8uq125KAQD14h4=
X-Received: by 2002:a6b:6a17:: with SMTP id x23mr9873142iog.193.1573759669802;
 Thu, 14 Nov 2019 11:27:49 -0800 (PST)
MIME-Version: 1.0
References: <20190710201244.25195-1-brijesh.singh@amd.com> <20190710201244.25195-2-brijesh.singh@amd.com>
 <CAMkAt6pzXrZw1TZgcX-G0wDNZBjf=1bQdErAJTxfzYQ2MJDZvw@mail.gmail.com> <4f509f43-a576-144d-efd4-ab0362f1d667@amd.com>
In-Reply-To: <4f509f43-a576-144d-efd4-ab0362f1d667@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 14 Nov 2019 11:27:38 -0800
Message-ID: <CAMkAt6qfPyqGuNv9gKirote=zj6Vha=9Vu1HSFkxx334s-GV1g@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] KVM: SVM: Add KVM_SEV SEND_START command
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 12, 2019 at 2:27 PM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
>
> On 11/12/19 12:35 PM, Peter Gonda wrote:
> > On Wed, Jul 10, 2019 at 1:13 PM Singh, Brijesh <brijesh.singh@amd.com> wrote:
> >> +static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >> +{
> >> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> >> +       void *amd_cert = NULL, *session_data = NULL;
> >> +       void *pdh_cert = NULL, *plat_cert = NULL;
> >> +       struct sev_data_send_start *data = NULL;
> >> +       struct kvm_sev_send_start params;
> >> +       int ret;
> >> +
> >> +       if (!sev_guest(kvm))
> >> +               return -ENOTTY;
> >> +
> >> +       if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> >> +                               sizeof(struct kvm_sev_send_start)))
> >> +               return -EFAULT;
> >> +
> >> +       data = kzalloc(sizeof(*data), GFP_KERNEL);
> >> +       if (!data)
> >> +               return -ENOMEM;
> >> +
> >> +       /* userspace wants to query the session length */
> >> +       if (!params.session_len)
> >> +               goto cmd;
> >> +
> >> +       if (!params.pdh_cert_uaddr || !params.pdh_cert_len ||
> >> +           !params.session_uaddr)
> >> +               return -EINVAL;
> > I think pdh_cert is only required if the guest policy SEV bit is set.
> > Can pdh_cert be optional?
>
>
> We don't cache the policy information in kernel, having said so we can
> try caching it during the LAUNCH_START to optimize this case. I have to
> check with FW folks but I believe all those fields are required. IIRC,
> When I passed NULL then SEND_START failed for me. But I double check it
> and update you on this.


I must have misinterpreted the this line of the spec:
"If GCTX.POLICY.SEV is 1, the PDH, PEK, CEK, ASK, and ARK certificates
are validated."
I thought that since they were not validated they were not needed.
