Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC85A52C120
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240817AbiERRS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 13:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240806AbiERRS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 13:18:56 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A743820D4FE
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:18:55 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id p22so4766812lfo.10
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PvLMOafpFWueHNghY/35HDJcyXRvgnUf+BvHO3GruXs=;
        b=gp1vjOlcYuo+tcvUZcEV3+a8c6kLoVbz5ui6B19Ndey58Hq7YD0y5rQo7FE4xjY2dK
         n9b9xHgQ4OUQYOuWk0UzKbnblKDmPb3w7ZFxE1SW68zn/GbLT7pjJNllDz1JQMVsv5kY
         YqGWEo82EfZTpP8ks+TGjzzilgFjtEgdhzg55zgJgoanca5RqZKLUo2zUwwaK1XixIF4
         Ghewl0CcYPyO+WmruwDzrAnVRiv4oBsl7uFOLZ+N2U60FoOpjBAVKc6IVp9lhz+quXnn
         8o/kSBoDYtToZKhcjUJ3ru4qkREYaHQ7TuoGIWxdMFza+AK8uNcKoCBZLoTBqfdyXrjI
         7oPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PvLMOafpFWueHNghY/35HDJcyXRvgnUf+BvHO3GruXs=;
        b=5R8OjxfGbZ2T/s17+yklYBOESAPwyD1r/C57b0eE8V6nIZ9KZ1B3oN2Pec1Knd3FYQ
         ENgOiGuwqcF+6zxYHfcryfcFOsC5mHhZCjhKEz0fTFt2G5UTnL7afX5zsu23Wh8IO3um
         5TGdI1L/RkGkmML1Y8cIULlaWl/3EadIiyX4O3tuhu4IdKq9yCDBfiTPsrh4EQfUAYfM
         sybuL1xnOkxVfwO0iYSnmTdnruRWGP4AKGv1arpdj5cBzWfG6iEChpEQCNwWpIxukE15
         VvHcESogFCUHVZsQcT/zycl9zBErdPApxH0OpXWnu7wCVpsxIJIP57FndrRl6DBPHF+N
         yplg==
X-Gm-Message-State: AOAM532VUqTJQpVOPKTwr+IjtXts+ske/pH9vHopuAlpslTr5XUqh6I3
        XBQjRN2D+xdHOgJKqXkVLGBx8ytPa6/fdAqZcgTTUg==
X-Google-Smtp-Source: ABdhPJw8+JK6ro2/RXZcq5g5nqrB3ZZOOE004+kTbc09e3cYdP4yQkS0VR2Z+G9RWn/q3tx7Y1pTiR0p1BFUK7gOTsY=
X-Received: by 2002:a05:6512:1291:b0:473:b522:ef58 with SMTP id
 u17-20020a056512129100b00473b522ef58mr375721lfs.190.1652894333475; Wed, 18
 May 2022 10:18:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220517190524.2202762-1-dmatlack@google.com> <20220517190524.2202762-9-dmatlack@google.com>
 <YoQD0EDDeW+P3rSh@xz-m1.local>
In-Reply-To: <YoQD0EDDeW+P3rSh@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 18 May 2022 10:18:27 -0700
Message-ID: <CALzav=eET=9bS5O5bSs3YYc+1BuJBw6NDmPO6YLWL1V_MhBJag@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] KVM: selftests: Drop unnecessary rule for $(LIBKVM_OBJS)
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
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

On Tue, May 17, 2022 at 1:21 PM Peter Xu <peterx@redhat.com> wrote:
>
> On Tue, May 17, 2022 at 07:05:22PM +0000, David Matlack wrote:
> > Drop the "all: $(LIBKVM_OBJS)" rule. The KVM selftests already depend
> > on $(LIBKVM_OBJS), so there is no reason to have this rule.
> >
> > Suggested-by: Peter Xu <peterx@redhat.com>
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> Since previous patch touched the same line, normally for such a trivial
> change I'll just squash into it.  Or at least it should be before the
> previous patch then that one contains one less LOC change.  Anyway:

The previous patch does touch this line but this is a logically
distinct change so I think it makes sense to split out.

You're right though that it'd probably make sense to re-order this
before the previous patch. i.e. Drop the line "all: $(STATIC_LIBS)".



>
> Reviewed-by: Peter Xu <peterx@redhat.com>
>
> Thanks,
>
> > ---
> >  tools/testing/selftests/kvm/Makefile | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index cd7a9df4ad6d..0889fc17baa5 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -189,7 +189,6 @@ $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
> >       $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
> >
> >  x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
> > -all: $(LIBKVM_OBJS)
> >  $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
> >
> >  cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
> > --
> > 2.36.0.550.gb090851708-goog
> >
>
> --
> Peter Xu
>
