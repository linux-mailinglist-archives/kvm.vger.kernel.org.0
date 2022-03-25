Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CA94E7804
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 16:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354638AbiCYPgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 11:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377356AbiCYPdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 11:33:25 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63402D1E5
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 08:29:00 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id t25so13969976lfg.7
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 08:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QPocrmqkuGYHnUVRsDZ/TbHe19zETFDOn27Vxny6QCI=;
        b=NoKTAx+GgAdqOfHToR+2NJ4UdtSN0mm4Tiu7cxkqcQZtXSOtizFo+YQNtguTvNiTmP
         9APy8PjqvWRslGk9feJMbBLaUCDojNH9pMCZI57GUJ//r4APse05WQqFon6BG8iThpUo
         g8Ci2br9eGFDcFOLMRmzAyw/hWsqw7ecyDZXnilV1Ko9h1OtIZhgMZPZRRMEFRYwiWFr
         8r2KQXyeDlTh6eqiVYp9AZpgjZB5Fnjs3hYtMrokYSLBaYCVoJiE00zqnakqCQ5N7zXi
         oG1I/OCrDfwt8EoRs99vAdJU+hjtm59SrJNSZ4uHdN5AVtdOUrVIvE5UCittHYJeQF0s
         NhLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QPocrmqkuGYHnUVRsDZ/TbHe19zETFDOn27Vxny6QCI=;
        b=WhkdQaZ8F+Wz50xuFeor6vuotHW1L917uLvqrWJekBij46KxGJvbkbxslmu5/8wjcS
         zRhM8LtGs3YKRIpAy3KEhAWs6aRrEyJxOsahom/Xb9D5RJIgrR2YskjDGzp+7NWOeIEc
         ult9s7gjiNk9f0K7NfRzXqOo0ztixPvuCHjoZEmmBouIV2b8T3Rw4jt2iRN3H9h/ImOm
         MR9lXRI1bSIZaNkQvYGHfIogiib8RYYizdHC6WxM59iDVWwKfKZjyW1DSxVDXh8TV3MZ
         7K3je/13Crl45jm/X6snCDpkM0JsswxtEuFNLDZ1glwxA7J6uN8KTRJtsRknMSFTtiKX
         yRmQ==
X-Gm-Message-State: AOAM530MdI+UTeBV99aMQWXXs6GFQ2lg5H5+ToV/MnBrXZi8XFb+m3UL
        P3N9tglIidFzHTGENMSM0Mtr5UJURFtMo4Ofm2FVcQ==
X-Google-Smtp-Source: ABdhPJwajANP/u7dvP2rPWqqB9wMD9F7TC7XMC4AiQxoD4/abx/UvRQZWo382ah99ciAEHJzTMSSX94FSkDjdVNzRRU=
X-Received: by 2002:a05:6512:15a3:b0:44a:54eb:937e with SMTP id
 bp35-20020a05651215a300b0044a54eb937emr8040694lfb.456.1648222138745; Fri, 25
 Mar 2022 08:28:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220321150214.1895231-1-pgonda@google.com> <CAA03e5HEKPxfGZ57r=intg_ogTp_JPAio36QJXqviMZM_KmvEg@mail.gmail.com>
 <CAMkAt6qbauEn1jGUYLQc6QURhCHLu7eDmzJhfHZZXN9FGbQOMA@mail.gmail.com> <CAA03e5GDyM1O6aEYcpUnTY4JLBvOqQugWzpXefD9YGEkSuALVA@mail.gmail.com>
In-Reply-To: <CAA03e5GDyM1O6aEYcpUnTY4JLBvOqQugWzpXefD9YGEkSuALVA@mail.gmail.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 25 Mar 2022 09:28:47 -0600
Message-ID: <CAMkAt6qB8GXhu0h+k1pbP_KkhvW+Edk-=zyo3zo2WdOe_qq8PA@mail.gmail.com>
Subject: Re: [PATCH] Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
To:     Marc Orr <marcorr@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 21, 2022 at 1:45 PM Marc Orr <marcorr@google.com> wrote:
>
> On Mon, Mar 21, 2022 at 11:08 AM Peter Gonda <pgonda@google.com> wrote:
> >
> > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > index 75fa6dd268f0..5f9d37dd3f6f 100644
> > > > --- a/arch/x86/kvm/svm/sev.c
> > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > @@ -2735,8 +2735,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
> > > >                 pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
> > > >                         reason_set, reason_code);
> > > >
> > > > -               ret = -EINVAL;
> > > > -               break;
> > > > +               vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
> > > > +               vcpu->run->shutdown.reason = KVM_SHUTDOWN_SEV_TERM;
> > > > +               vcpu->run->shutdown.ndata = 2;
> > > > +               vcpu->run->shutdown.data[0] = reason_set;
> > > > +               vcpu->run->shutdown.data[1] = reason_code;
> > > > +
> > > > +               return 0;
> > >
> > > Maybe I'm missing something, but don't we want to keep returning an error?
> > >
> > > rationale: Current behavior: return -EINVAL to userpsace, but
> > > userpsace cannot infer where the -EINVAL came from. After this patch:
> > > We should still return -EINVAL to userspace, but now userspace can
> > > parse this new info in the KVM run struct to properly terminate.
> > >
> >
> > I removed the error return code here since an SEV guest may request a
> > termination due to no fault of the host at all. This is now inline
> > with any other shutdown requested by the guest. I don't have a strong
> > preference here but EINVAL doesn't seem correct in all cases, do
> > others have any thoughts on this?
>
> Makes sense. Yeah, let's see if others have an opinion. Otherwise, I'm
> fine either way. Now that you mention it, returning an error to
> userspace when the guest triggered the self-termination, and could've
> done so for reasons outside the host's control, is a little odd. But
> at the same time, it's just as likely that the guest is
> self-terminating due to a host-side error. So I guess it's not clear
> whether returning an error here is "right" or "wrong".

Since no one has expressed a strong opinion have have left this part
of the patch unchanged in the V2. Happy to revise again if people
prefer something else.
