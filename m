Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF6EE94CF5
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 20:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbfHSSai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 14:30:38 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45244 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbfHSSah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 14:30:37 -0400
Received: by mail-io1-f66.google.com with SMTP id t3so6420559ioj.12
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 11:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gXEsTOBJnzR8V+Y9Uq0cMUIxlbNrOE1nK5VfshXw+oA=;
        b=agDss8fdWoE+/7dTtIvtt0v7iNwRZWwbhMX87eSnL3GvmSPNS9dcVy/RSOPqbemdkD
         Nf/MeqE3RdJUnGIi2gBGTeJViK3jXdlvBDlxNQPiirLBC57rvTQkMDtjz6ZCI6UFNciQ
         0sAo97GIZ1uK6GDzq5qTNpPLLwzvDcY/TsYkLfnb3pVdMs2xyGznufaWf91YAZal84tS
         X63WQUez/ijOstMdliJfpmuI4vmpgNeqrCQvl0ITMlGxvQvM/BYn60hdI6VK5O+7xEg3
         7ryw2nlY+NPPCGQMJrAN2w+FWmQ446AkNy/QaF4QZgRpNW/4i3Ns2In77KUMs+PlLm8+
         jo5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gXEsTOBJnzR8V+Y9Uq0cMUIxlbNrOE1nK5VfshXw+oA=;
        b=MOzg3ztIF5obw8Fpcfbi4nKHkpGiYWlThDGGfmcErRGqGves1GE3MoyDsa8u5+5rOP
         X81YYZJtWIXFUMPNN3kDIeXt22DM+2DShO40jL9vqdz3CvUTcaOzs1qLsvw3M8eQMcFR
         CBpJWvz438DKlvUCoZpfQNF7coLiurbKa8U2jRLuTozb1cDraMWt9ZjoXe4nT/pRURr5
         klK66iRPdqWkAZ88RUrFFZGNEZ0m9ulb2Qog6PzwWKL14suO0hgLcO9uYCwZeGA7GqXb
         HFu4rrIwDhTciXbmzqN4gGCoSFSVN8UbeVc2MPjl9IlhYiN8QIXAYuJlf/2ndI2z8uzL
         Fmqw==
X-Gm-Message-State: APjAAAX63QYyyhfseouSoQz3kg5W+l5xIGR+Z1r1AxgPlILs+j1o/ijr
        QbSERW6lkgrglczV6Zg4qOYoh2NpO1DIOvoNM6lVLnWW6dM=
X-Google-Smtp-Source: APXvYqx1QYR7L9bAE7CbApiSe8V70bIgNZHt/NR58+gfJ9Vsp7y97IhF6AI4P/vWhRBRCH30OMWGlCIzp2yZWfx97Xo=
X-Received: by 2002:a02:8794:: with SMTP id t20mr7728050jai.24.1566239436695;
 Mon, 19 Aug 2019 11:30:36 -0700 (PDT)
MIME-Version: 1.0
References: <1565854883-27019-1-git-send-email-pbonzini@redhat.com>
 <1565854883-27019-2-git-send-email-pbonzini@redhat.com> <CALMp9eQcRbMjQ_=jQ=qaYmh1Lavc3PYvm4Qcf3zY+N8j3zZe-w@mail.gmail.com>
 <0e29f624-10f5-7ab5-1823-280f32732b68@redhat.com>
In-Reply-To: <0e29f624-10f5-7ab5-1823-280f32732b68@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 19 Aug 2019 11:30:25 -0700
Message-ID: <CALMp9eT2uo+_tbV=Z3-pyzjU76kaEU-BNvVriEHU6yGMsiy5Dw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: fix reporting of AMD speculation bug CPUID leaf
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 19, 2019 at 8:18 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 16/08/19 23:45, Jim Mattson wrote:
> > On Thu, Aug 15, 2019 at 12:41 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> The AMD_* bits have to be set from the vendor-independent
> >> feature and bug flags, because KVM_GET_SUPPORTED_CPUID does not care
> >> about the vendor and they should be set on Intel processors as well.
> >> On top of this, SSBD, STIBP and AMD_SSB_NO bit were not set, and
> >> VIRT_SSBD does not have to be added manually because it is a
> >> cpufeature that comes directly from the host's CPUID bit.
> >>
> >> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> >
> > On AMD systems, aren't AMD_SSBD, AMD_STIBP, and AMD_SSB_NO set by
> > inheritance from the host:
> >
> > /* cpuid 0x80000008.ebx */
> > const u32 kvm_cpuid_8000_0008_ebx_x86_features =
> >         F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
> >         F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON);
> >
> > I am curious why the cross-vendor settings go only one way. For
> > example, you set AMD_STIBP on Intel processors that have STIBP, but
> > you do not set INTEL_STIBP on AMD processors that have STIBP?
> > Similarly, you set AMD_SSB_NO for Intel processors that are immune to
> > SSB, but you do not set IA32_ARCH_CAPABILITIES.SSB_NO for AMD
> > processors that are immune to SSB?
> >
> > Perhaps there is another patch coming for reporting Intel bits on AMD?
>
> I wasn't going to work on it but yes, they should be.  This patch just
> fixed what was half-implemented.

I'm not sure that the original intent was to enumerate the AMD
features on Intel hosts, but it seems reasonable to do so.

Should we also populate the AMD cache topology leaf (0x8000001d) on
Intel hosts? And so on? :-)

Reviewed-by: Jim Mattson <jmattson@google.com>
