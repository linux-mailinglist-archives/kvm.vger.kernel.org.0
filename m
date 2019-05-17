Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B562621CCA
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 19:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbfEQRsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 13:48:15 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:37564 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfEQRsP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 13:48:15 -0400
Received: by mail-it1-f194.google.com with SMTP id m140so13364888itg.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 10:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6b5WEJzWjojzN3ELA/9vFJA63IZyJZqOxvIv2wQUKE4=;
        b=KdgOrsFjsiZDyMw0KYS0I32yg6+Kvf9XeIskoWeJhVmszQo8t6q2kTE18C//Qeje52
         MOwTUZLfnYnoKau3iCkf0lkfvfSUGauDdtuKlOwAMEfywLvmJJhenU+PaWdqoXS7/qrx
         IMAlNB4+Ud+EWH8wECrvLjuWf1E+aWKLYaz60wMRopW0aGqfU0y3iHArCTcU+XZUiJOo
         4nMvlXV/0bE1jLCmeEgtz4+NL0cSybmdAuxmkiqOyCzHitEW62WLb8bdbfIdY5xIV00+
         zt0kuil23Kub0uXERg64okovRBz1h1UK1aWWAlOWZYocekNdTd+piMfUKxuJ1LZ6mwkf
         K6UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6b5WEJzWjojzN3ELA/9vFJA63IZyJZqOxvIv2wQUKE4=;
        b=IVVZ8xqjFdGRJSXFfI/xrTc8GoFlYh9hSSS8Q7DNb/eGTTDci0qsbvPDtW6HEmRFCZ
         0JNWu+vbDCNPlX2jCHuqQ+PH69HnHIS3zLN/s6L1KpF1ztWa7+buFXirnVSh0JMegOEk
         amP/BeaIyviha+xByFpRmTc0lkvYPup+/q+a4zspvgC6DwubcIMrCch3CDPNPHKkcbBm
         HZ6nVDFNw0MKxJ3syOJ93DH6cJIl41UAG4bv4bvTGnhdvNQ2eAdVUKHLs1NJJFA331lu
         yENM/pMCM/nDw0K4Kax2jqtM/5tJsWhs1pDdpCehPyKepAw2ebAGjJW6qlcjON82wjY8
         p6Vg==
X-Gm-Message-State: APjAAAU/2iZDHdbHJifax5cebZBVQOz0Cpb7vPmULewO3+OLf4MPMC/k
        KCQDrqXN2myO0Z0W0QsBpNFx5nIYN3ryxREjKcMWI1hxS/M=
X-Google-Smtp-Source: APXvYqyXEG4PYFy50O7fTZ5LNlqHdtUpzxc4qM5m39RgaTuKKbaElcvmrodCItg/uhZLvRKEVGos/pzbOx/LBr7yKEE=
X-Received: by 2002:a24:5255:: with SMTP id d82mr19710221itb.104.1558115294120;
 Fri, 17 May 2019 10:48:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190327201537.77350-1-jmattson@google.com> <20190327201537.77350-2-jmattson@google.com>
 <20190401171304.GD28514@zn.tnic>
In-Reply-To: <20190401171304.GD28514@zn.tnic>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 17 May 2019 10:48:03 -0700
Message-ID: <CALMp9eRbe8VWzhGcs_HB0gBT5EQN4PCtop5am9j+-WG5pK8r8w@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm: x86: Include CPUID leaf 0x8000001e in kvm's
 supported CPUID
To:     Borislav Petkov <bp@suse.de>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>, Jacob Xu <jacobhxu@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 1, 2019 at 10:13 AM Borislav Petkov <bp@suse.de> wrote:
>
> On Wed, Mar 27, 2019 at 01:15:37PM -0700, Jim Mattson wrote:
> > Kvm now supports extended CPUID functions through 0x8000001f.  CPUID
> > leaf 0x8000001e is AMD's Processor Topology Information leaf. This
> > contains similar information to CPUID leaf 0xb (Intel's Extended
> > Topology Enumeration leaf), and should be included in the output of
> > KVM_GET_SUPPORTED_CPUID, even though userspace is likely to override
> > some of this information based upon the configuration of the
> > particular VM.
> >
> > Cc: Brijesh Singh <brijesh.singh@amd.com>
> > Cc: Borislav Petkov <bp@suse.de>
> > Fixes: 8765d75329a38 ("KVM: X86: Extend CPUID range to include new leaf")
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Marc Orr <marcorr@google.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 1 +
> >  1 file changed, 1 insertion(+)
>
> Reviewed-by: Borislav Petkov <bp@suse.de>

Paolo?
