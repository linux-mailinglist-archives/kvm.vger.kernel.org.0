Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED45516BBFF
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 09:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbgBYIlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 03:41:15 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:42176 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgBYIlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 03:41:15 -0500
Received: by mail-ot1-f65.google.com with SMTP id 66so11357640otd.9;
        Tue, 25 Feb 2020 00:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Q0vy786giS+lfp9bUB7XCIUFz0pQEN7EOGsmAN4eRm4=;
        b=nKhOPmQ12wJJY6QSzkKm4CK+u010U9hKN8hfKFhUBkr97meisT8QguznR33/Z4Kl7z
         Ub8spInGXBKTZE5yO2/VfS1vd4WJR/Xbf/TthA/OP/McjtwnLL2Av2EeM4VrrRjGaYwI
         pI3xKVxC6wqvftu25MA08OL3HhAfyJhxCJbwDl+0T7LN7u5ckm0QfkuLmfxv1K6AVNkd
         lLv5o4VeZBvi0BBtF6Fb4l+ppbV4hs994DBkXPaY/dq76RkBvW335kqEZH60kswOPAiL
         u3YETeq6nnY6U3lt5CL6ACiqoQFZllNSrxS8eJnlCkhbNH/gwMGfR14B1mybcHBVckEa
         eaxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q0vy786giS+lfp9bUB7XCIUFz0pQEN7EOGsmAN4eRm4=;
        b=Hiq8lOr7j2o3kt3zma0UU2V70bF1zzYvuiNbWVy/ZAUt5LqcvI90OM4OuCdDp+LOWQ
         ynfdLdveMeuKvgNOeFdv/+ORcnbBYm/rfeNsFLfFNGkkV34MRo0g6sr7YMOXiXT5azmM
         0wovHjTgxCq2v+/zDuja/HYKpqa9hky76dN3ZwYXeGuwX9SZdz9iJRZqL+SFlthsdp6V
         09IqMALS/VxNGO+21bJxfRI0UV9y5k8LP1rXuQev9kWxuZ9xgIAdUsuAbUdS8h8GEOFS
         pQajJ918eBjsZzkTFYWANbtYIU+lEzjeyUTJvMbUBkeyQ7FcOdoQQM52d6F1RjSTMkrP
         v+lw==
X-Gm-Message-State: APjAAAVwNO/xcFWt5Tq3wub1N2eGwp8aKnOlD8QlYUC/AKWBWYMOiu2O
        BsOflYVPlbSv9DMFMN/mzvxBWqJkWCUJ9rfV9+M=
X-Google-Smtp-Source: APXvYqzA2EItrptKtNT16zTMptHEmpZx46ZO+RBh1Rcrb41daUqfBQ8kLLZi82Lj75DFkuBbEx1awmuMPp2y/3v4QUM=
X-Received: by 2002:a9d:7ccd:: with SMTP id r13mr42256692otn.56.1582620074234;
 Tue, 25 Feb 2020 00:41:14 -0800 (PST)
MIME-Version: 1.0
References: <07348bb2-c8a5-41d0-afca-26c1056570a5.bangcai.hrg@alibaba-inc.com>
 <CANRm+CwZq=FbCwRcyO=C7YinLevmMuVVu9auwPqyho3o-4Y-wQ@mail.gmail.com> <660daad7-afb0-496d-9f40-a1162d5451e2.bangcai.hrg@alibaba-inc.com>
In-Reply-To: <660daad7-afb0-496d-9f40-a1162d5451e2.bangcai.hrg@alibaba-inc.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 25 Feb 2020 16:41:02 +0800
Message-ID: <CANRm+Cw08uxwW8iUi96CJjmvfbtSd6ePXpAPPScByhoNLCrAWQ@mail.gmail.com>
Subject: Re: [RFC] Question about async TLB flush and KVM pv tlb improvements
To:     =?UTF-8?B?5L2V5a655YWJKOmCpumHhyk=?= <bangcai.hrg@alibaba-inc.com>
Cc:     namit <namit@vmware.com>, peterz <peterz@infradead.org>,
        pbonzini <pbonzini@redhat.com>,
        "dave.hansen" <dave.hansen@intel.com>, mingo <mingo@redhat.com>,
        tglx <tglx@linutronix.de>, x86 <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "dave.hansen" <dave.hansen@linux.intel.com>, bp <bp@alien8.de>,
        luto <luto@kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?5p6X5rC45ZCsKOa1t+aeqyk=?= <yongting.lyt@alibaba-inc.com>,
        =?UTF-8?B?5ZC05ZCv57++KOWQr+e/vik=?= <qixuan.wqx@alibaba-inc.com>,
        herongguang <herongguang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Feb 2020 at 15:53, =E4=BD=95=E5=AE=B9=E5=85=89(=E9=82=A6=E9=87=
=87) <bangcai.hrg@alibaba-inc.com> wrote:
>
> > On Tue, 25 Feb 2020 at 12:12, =E4=BD=95=E5=AE=B9=E5=85=89(=E9=82=A6=E9=
=87=87) <bangcai.hrg@alibaba-inc.com> wrote:
> >>
> >> Hi there,
> >>
> >> I saw this async TLB flush patch at https://lore.kernel.org/patchwork/=
patch/1082481/ , and I am wondering after one year, do you think if this pa=
tch is practical or there are functional flaws?
> >> From my POV, Nadav's patch seems has no obvious flaw. But I am not fam=
iliar about the relationship between CPU's speculation exec and stale TLB, =
since it's usually transparent from programing. In which condition would ma=
chine check occurs? Is there some reference I can learn?
> >> BTW, I am trying to improve kvm pv tlb flush that if a vCPU is preempt=
ed, as initiating CPU is not sending IPI to and waiting for the preempted v=
CPU, when the preempted vCPU is resuming, I want the VMM to inject an inter=
rupt, perhaps NMI, to the vCPU and letting vCPU flush TLB instead of flush =
TLB for the vCPU, in case the vCPU is not in kernel mode or disabled interr=
upt, otherwise stick to VMM flush. Since VMM flush using INVVPID would flus=
h all TLB of all PCID thus has some negative performance impacting on the p=
reempted vCPU. So is there same problem as the async TLB flush patch?
>
> > PV TLB Shootdown is disabled in dedicated scenario, I believe there
> > are already heavy tlb misses in overcommit scenarios before this
> > feature, so flush all TLB associated with one specific VPID will not
> > worse that much.
>
> If vcpus running on one pcpu is limited to a few, from my test, there
> can still be some beneficial. Especially if we can move all the logic to

Unless the vCPU is preempted.

> VMM eliminating waiting of IPI, however correctness of functionally
> is a concern. This is also why I found Nadav's patch, do you have
> any advice on this?
