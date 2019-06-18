Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAC94A39C
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 16:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbfFROOo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 10:14:44 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38937 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729267AbfFROOo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 10:14:44 -0400
Received: by mail-lf1-f66.google.com with SMTP id p24so9421112lfo.6
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 07:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=sPc1dpmWqFUYVgR6EigPApmW22OsRmPOukemQFKbvU4=;
        b=dBOPtjh1hv6z5i8svne5xrg7Gct8hyYowrZNZkrG/mDC2L0iN5K+jh7Wl/W9VgzYBM
         jT4lz1t9Vy7bIfoW2Z+tIczA+9W0wRTQ91Hu7DJPFDyO3SNjgUf14JrdwqvryH7q6XKC
         gGWxmO052okjzldDNmypbhk7B6ZLhW4PjhofAvfZeTycPmvRJ4NoD3RqILxwjM2k7gFW
         ixlzyjZW4L+5JylXO4sWBYf0Qhq/bAdBagDZCsYk2PmaUvZIYL/oTBePBwOxnth3e9F3
         9WNCJAu9hhQMNBs2F3RKx89q8k+9slg+uCccKfT/3dQAIvrkzWMITFiTUsHRVLJhmEk4
         vq9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=sPc1dpmWqFUYVgR6EigPApmW22OsRmPOukemQFKbvU4=;
        b=EGRWSNwnl58qupvC7loOsGwxzi+KWY2rGW9bc1rh7RDlSv1H201iu1rSUiH97HqkNp
         dv4hKEL8F+VK4sRPy4pTDW9Hy5rbbAPg9Xxo4xgJr45JL0bpwhO8p7uesudZWIhQilM6
         S8ixX6JkmEkSe+9rntBgZILTvJNrT8EAC+0aegXRdmhptnbWo1V3J+eFzAc8NJd2e+y+
         rWyiAXbqPNedYkrsER2CIF2ODVsl89KLjzvm1CFhxyWWGwGPZ+Tbx4j4epDQ6wR9G/58
         jwMiy/H33r4co+ACF47bSF/mrFzzcX/zY4h+SAWbNNxOVwzO6vCg6d/rPkaIytJ3pIoH
         b6Lg==
X-Gm-Message-State: APjAAAUbhhrgdbMmoXcaWzRlaoLnIHZ6D7qI4mvlZMmBZRasyo9AAKSM
        td6P86OcfnzHd8hlzse3zyZUQ4bdiwazCEBwDuLAKg==
X-Google-Smtp-Source: APXvYqwha4Z7Gqt55lXEtnL68eRmUYSF5hV0hyLMFAn1Au8cSl/jvRBPpsXE21t17k7cp3fcM5cBUEtSD45QS104dHQ=
X-Received: by 2002:ac2:48a5:: with SMTP id u5mr53273486lfg.62.1560867281866;
 Tue, 18 Jun 2019 07:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190521171358.158429-1-aaronlewis@google.com> <CAAAPnDH1eiZf-HkT2T8aDBBU_TKV7Md=EBQymq9FDMZ7e4__6g@mail.gmail.com>
In-Reply-To: <CAAAPnDH1eiZf-HkT2T8aDBBU_TKV7Md=EBQymq9FDMZ7e4__6g@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Tue, 18 Jun 2019 07:14:30 -0700
Message-ID: <CAAAPnDHg6Qmwwuh3wGNdTXQ3C4hpSJo9D5bvZG4yX9s48DeSLQ@mail.gmail.com>
Subject: Re: [PATCH] kvm: tests: Sort tests in the Makefile alphabetically
To:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Marc Orr <marcorr@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 31, 2019 at 9:37 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> On Tue, May 21, 2019 at 10:14 AM Aaron Lewis <aaronlewis@google.com> wrote:
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile | 20 ++++++++++----------
> >  1 file changed, 10 insertions(+), 10 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 79c524395ebe..234f679fa5ad 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -10,23 +10,23 @@ LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/ucall.c lib/sparsebi
> >  LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c
> >  LIBKVM_aarch64 = lib/aarch64/processor.c
> >
> > -TEST_GEN_PROGS_x86_64 = x86_64/platform_info_test
> > -TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
> > -TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
> > -TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
> > -TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
> > -TEST_GEN_PROGS_x86_64 += x86_64/state_test
> > +TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
> > -TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
> > -TEST_GEN_PROGS_x86_64 += x86_64/smm_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/kvm_create_max_vcpus
> > +TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
> > +TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
> > +TEST_GEN_PROGS_x86_64 += x86_64/smm_test
> > +TEST_GEN_PROGS_x86_64 += x86_64/state_test
> > +TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
> > +TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
> > -TEST_GEN_PROGS_x86_64 += dirty_log_test
> > +TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
> >  TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
> > +TEST_GEN_PROGS_x86_64 += dirty_log_test
> >
> > -TEST_GEN_PROGS_aarch64 += dirty_log_test
> >  TEST_GEN_PROGS_aarch64 += clear_dirty_log_test
> > +TEST_GEN_PROGS_aarch64 += dirty_log_test
> >
> >  TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
> >  LIBKVM += $(LIBKVM_$(UNAME_M))
> > --
> > 2.21.0.1020.gf2820cf01a-goog
> >
>
> Does this look okay?  It's just a simple reordering of the list.  It
> helps when adding new tests.

ping
