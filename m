Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9D86CD7F
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 13:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390080AbfGRLkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 07:40:14 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46294 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbfGRLkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 07:40:14 -0400
Received: by mail-ot1-f67.google.com with SMTP id z23so318758ote.13;
        Thu, 18 Jul 2019 04:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0wT5Tj/n2RBfQhJG08mVc86LI5QLyQMdXu4Aow//MCg=;
        b=Z7xXDV/4TY1dg6KBkMskZBDH3w92Xls9x8KPY9aIyeqdukEOhimPJD/+5aFOdB+zlk
         UO10r/49CLzHyeb4CgO06m5s/qPl7+MhGOP4AJq5SLVjIj8jPBYROtT5OX3RltkAvPDn
         mN3ombIS7+3MdpXh9/Z58mAvk40Jkjqa2qKqmayuD+DPoldj5z9QJKD/PJPW7CpvIdPh
         fqJgrcLYzNsbUTVKz7j197z0/k4LMhb9D+ChPFPbXSLshlmThLpUtmk2pJCVPDtzzwma
         e7wdUNUjOP1XNPz6mf9rTm1DkkOJcIFMOXC0f0GpP6XDS5WS56P1XTPEpuwxe34INHoN
         pcTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0wT5Tj/n2RBfQhJG08mVc86LI5QLyQMdXu4Aow//MCg=;
        b=GJL2SlPdZVQyh5PKVs1vwRQxK4Wjbm2NrvDwkont3LlKmNOHANzvrMOVyv9SGw/BsA
         GdWx404cZJf1vyHfmo7xX2h+NNnTRSVxCyf2ILZ/bfdlUApvw4Sc2VADPy+iCc0BiQ+s
         8LvXqiYNNla+3TeKCfjcB27BmVqSs+1aF8ujmAhUVD0cxe9HP4ZCCthBZzRmHRXA5wRd
         yB/d4+KArCCoQ4l8HUnhKuPhFpkcyl+cBoEhNzNkATthPBfWAIPby/ScAiboqz9RCl8t
         e44593pgCCzyjKDWxVTGF80FbEUiq6EC5f+Bzph6Ul/MbqN8Yctn2BkdZf63WsowXcDp
         Osow==
X-Gm-Message-State: APjAAAX3L4BqscPwuFG0klP9SEQ6T1Q0LQwBOZxjq7YinGV0m3zrfTwL
        frY/lO5bj3bRscnHtxvPSbfbyRS3iseSJxvdxR8=
X-Google-Smtp-Source: APXvYqxhC2R1XSP9OMlLkXamvscGo+GlECN3WFHF9e8PPObst5TaewmXC2qc4Qh5ZxmXZITEg8SeryCqElJgBnFkRwI=
X-Received: by 2002:a9d:1b02:: with SMTP id l2mr14808131otl.45.1563450013270;
 Thu, 18 Jul 2019 04:40:13 -0700 (PDT)
MIME-Version: 1.0
References: <1562915730-9490-1-git-send-email-wanpengli@tencent.com>
 <f95fbf72-090f-fb34-3c20-64508979f251@redhat.com> <db74a3a8-290e-edff-10ad-f861c60fbf8e@de.ibm.com>
 <e31024e4-f437-becd-a9e3-e1ea8cd2e0c7@redhat.com> <CANRm+Cw43DKqD17U+7-OPX3BmeNBThSe9-uWP2Atob+A0ApzLA@mail.gmail.com>
 <bc210153-fbae-25d4-bf6b-e31ceef36aa5@redhat.com> <CANRm+CxV0c3RSidV_GQtVuQ5fUUCT8vM=5LpodgDg+dFWhkH3w@mail.gmail.com>
 <f6f9c2ca-6fea-d7b5-9797-d180e42f50d5@redhat.com>
In-Reply-To: <f6f9c2ca-6fea-d7b5-9797-d180e42f50d5@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 18 Jul 2019 19:40:04 +0800
Message-ID: <CANRm+CzJtSeCtuNHqGc588FMLzFvjFAcBhhipORsJSisk_KdRw@mail.gmail.com>
Subject: Re: [PATCH RESEND] KVM: Boosting vCPUs that are delivering interrupts
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Jul 2019 at 17:39, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 18/07/19 11:29, Wanpeng Li wrote:
> > On Thu, 18 Jul 2019 at 17:07, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 18/07/19 10:43, Wanpeng Li wrote:
> >>>>> Isnt that done by the sched_in handler?
> >>>>
> >>>> I am a bit confused because, if it is done by the sched_in later, I
> >>>> don't understand why the sched_out handler hasn't set vcpu->preempted
> >>>> already.
> >>>>
> >>>> The s390 commit message is not very clear, but it talks about "a former
> >>>> sleeping cpu" that "gave up the cpu voluntarily".  Does "voluntarily"
> >>>> that mean it is in kvm_vcpu_block?  But then at least for x86 it would
> >>>
> >>> see the prepare_to_swait_exlusive() in kvm_vcpu_block(), the task will
> >>> be set in TASK_INTERRUPTIBLE state, kvm_sched_out will set
> >>> vcpu->preempted to true iff current->state == TASK_RUNNING.
> >>
> >> Ok, I was totally blind to that "if" around vcpu->preempted = true, it's
> >> obvious now.
> >>
> >> I think we need two flags then, for example vcpu->preempted and vcpu->ready:
> >>
> >> - kvm_sched_out sets both of them to true iff current->state == TASK_RUNNING
> >>
> >> - kvm_vcpu_kick sets vcpu->ready to true
> >>
> >> - kvm_sched_in clears both of them
>
> ... and also kvm_vcpu_on_spin should check vcpu->ready.  vcpu->preempted
> remains only for use by vmx_vcpu_pi_put.

Done in v2, please have a look. :)

Regards,
Wanpeng Li
