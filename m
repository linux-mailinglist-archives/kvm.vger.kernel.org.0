Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79120D709C
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 09:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbfJOH6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 03:58:02 -0400
Received: from mail-vk1-f193.google.com ([209.85.221.193]:42527 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728236AbfJOH6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 03:58:02 -0400
Received: by mail-vk1-f193.google.com with SMTP id f1so4107299vkh.9
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 00:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4TFlLXf2oa2YuPV9trYjkUU2fLJQIVAVHD1yw34tNbE=;
        b=XhOzRvpN7P1Wn25TDCJTtyOqNQX4nil+7/S1CY52sxyT1WIiQpo5S/lv1uE2XNlI78
         8dmTMm4DOgbHNZcJI5EOWTFDtgJX7YlxFC0NyU8mMCaxCAbOTuYZB+cM8WAmP4yNkIqp
         e4ocwoatujZU6c+OquU1Y/zFem1dH8qv1WdHthNdY332yQkGfui9DS5vriq5wHmJz5pg
         IyrxllEvkt/NAb475d6Vgro5lGdiXGDZffNsYI9NJvbg1QooinaIeW4qtqiM25r9OWAe
         8Yw1BYNlueliqVzm12yG9J5rNnTSWtxaFwcUzj9N6rIlmstGqE2NaqkzUVm8Kd220Qqs
         Yyag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4TFlLXf2oa2YuPV9trYjkUU2fLJQIVAVHD1yw34tNbE=;
        b=ojB3lcKJ2mrrKikvPLlPboT0jWyi8DBduJUTKelDjv5CQkLIodfVgMVkZobtrcaQY6
         EZVz3OPX8YCz4zFB4PJCFf/iX7R02T8GIBokCVKaBhGy3OmHJXh27COCoRIHIV/eA3d3
         tf63FvOm5P45VbhlAmv5/mvb5EOsU3epIkYeasb7sR8+RZ4yu7bLRE4IBeflGA987d4F
         /3IPxbjtrDy++tcYzX0M0y/zNV4isdMQaj2DeG7UD1zGe9oKt36gdDIa6ttfCPj30UFy
         /yKrrS8yJo86BzHr0Mjo+nDb25NdxQZeiSeN3lJg5WQAiM+KIalMbT6RVcoxr91UzPGp
         GYtw==
X-Gm-Message-State: APjAAAWmmCNYvKWkc5py1eRgEiAzD/FwLQeiecP8+WFCcbgwqCmaBFKb
        cQPvwbU08ldzTlQSWEOMpdwNQiRSN8S4Iv7cn1KT
X-Google-Smtp-Source: APXvYqySOfAAstrFVCN3TRQJKEvtCxCaxD2U1OMeqFtLp3yOZ67ppSXQHKB9rZ0D3r9rEx4BZ9+DVcFkWf/KNd+1qWk=
X-Received: by 2002:a1f:7f14:: with SMTP id o20mr18410451vki.100.1571126280707;
 Tue, 15 Oct 2019 00:58:00 -0700 (PDT)
MIME-Version: 1.0
References: <20191010183506.129921-1-morbo@google.com> <20191010183506.129921-4-morbo@google.com>
 <67d3c72f-1537-7765-4b8c-d631859a3204@redhat.com>
In-Reply-To: <67d3c72f-1537-7765-4b8c-d631859a3204@redhat.com>
From:   Bill Wendling <morbo@google.com>
Date:   Tue, 15 Oct 2019 00:57:49 -0700
Message-ID: <CAGG=3QUCRO3YjTFyTt6x2K9Cxi0oz=F1H3H41YYU0n-zc=_Xbw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 3/3] Makefile: use "-Werror" in cc-option
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 15, 2019 at 12:29 AM Thomas Huth <thuth@redhat.com> wrote:
>
> On 10/10/2019 20.35, Bill Wendling wrote:
> > The "cc-option" macro should use "-Werror" to determine if a flag is
> > supported. Otherwise the test may not return a nonzero result. Also
> > conditionalize some of the warning flags which aren't supported by
> > clang.
> >
> > Signed-off-by: Bill Wendling <morbo@google.com>
> > ---
> >  Makefile | 19 +++++++++++--------
> >  1 file changed, 11 insertions(+), 8 deletions(-)
> >
> > diff --git a/Makefile b/Makefile
> > index 32414dc..3ec0458 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -46,30 +46,33 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
> >  # cc-option
> >  # Usage: OP_CFLAGS+=$(call cc-option, -falign-functions=0, -malign-functions=0)
> >
> > -cc-option = $(shell if $(CC) $(1) -S -o /dev/null -xc /dev/null \
> > +cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
> >                > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
> >
> >  COMMON_CFLAGS += -g $(autodepend-flags)
> > -COMMON_CFLAGS += -Wall -Wwrite-strings -Wclobbered -Wempty-body -Wuninitialized
> > -COMMON_CFLAGS += -Wignored-qualifiers -Wunused-but-set-parameter
> > -COMMON_CFLAGS += -Werror
> > +COMMON_CFLAGS += -Wall -Wwrite-strings -Wempty-body -Wuninitialized
> > +COMMON_CFLAGS += -Wignored-qualifiers -Werror
> > +
> >  frame-pointer-flag=-f$(if $(KEEP_FRAME_POINTER),no-,)omit-frame-pointer
> >  fomit_frame_pointer := $(call cc-option, $(frame-pointer-flag), "")
> >  fnostack_protector := $(call cc-option, -fno-stack-protector, "")
> >  fnostack_protector_all := $(call cc-option, -fno-stack-protector-all, "")
> > -wno_frame_address := $(call cc-option, -Wno-frame-address, "")
> >  fno_pic := $(call cc-option, -fno-pic, "")
> >  no_pie := $(call cc-option, -no-pie, "")
> >  COMMON_CFLAGS += $(fomit_frame_pointer)
> >  COMMON_CFLAGS += $(fno_stack_protector)
> >  COMMON_CFLAGS += $(fno_stack_protector_all)
> > -COMMON_CFLAGS += $(wno_frame_address)
> >  COMMON_CFLAGS += $(if $(U32_LONG_FMT),-D__U32_LONG_FMT__,)
> >  COMMON_CFLAGS += $(fno_pic) $(no_pie)
> >
> > +COMMON_CFLAGS += $(call cc-option, -Wno-frame-address, "")
>
> I think the old code used ":=" on purpose, so that the test is only done
> once. With your new code, the test is now done each time COMMON_CFLAGS
> gets evaluated, i.e. for each compiled object.
>
> Could you please rewrite this test to use the ":=" detour for all lines
> that call cc-option?
>
Does it rerun the "cc-option" call if the COMMON_CFLAGS is initially
defined with ":="? I ask because the kernel calls its version of
cc-option in the way I have it above, but the original definition of
the variable uses ":=".

-bw
