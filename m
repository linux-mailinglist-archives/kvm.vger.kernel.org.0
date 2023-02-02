Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7DE68860D
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbjBBSGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbjBBSGi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:06:38 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E411D470BF
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:06:34 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id a1so3253838ybj.9
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NXDH6ScKyBdH+mTM3V3vUdJt+9ozUBYrnmVSNczSmb4=;
        b=LZVVLu8EVdJrcmMGqLWqp6FsTHBH7bPQdppAWmFpJw6vjgoLtQywpO2BOuUpuQojv4
         y5IpvHZX2oBNQ2NaNo6lfDSYzDkOwK0+tGK4+uxw9nR6bBKjRpCN4xdPAbbumvlfD+eB
         nqUCfJ8vVjN/7KpX5nbCmpZHX7vILblqOf0tICU+GYt3me8jNxH7ni2wnZMOh9OYbKDC
         iFgpOAr3IH//UIePcbuu04Alh3gDJdjbqsU341PrfHDes6aLDCjXu3bICLtRRQP6tShT
         LR2s4+dD0LrWrZ98MMIIJyYy1jKlTE8T3TPdQlbmfMKu0CE+5yJ7P7z/VwnRiJU5N96G
         mXpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NXDH6ScKyBdH+mTM3V3vUdJt+9ozUBYrnmVSNczSmb4=;
        b=o1SoShKRqO4fj8wNomwSkY1nPsndwOpk95r2ZbduS7gNoXR+YuEmggIiFvgmO3OIQ2
         dKMf4wvM4liH4z2jDscB8zRceTJaXIc3PSss8CD1bcPpF9Ph72xwJKNQFm7t9J7b0eSU
         PUm1SH+ws0p7+tzPeKMR9oJ17W736yVOo1t7XKgLP5N8CK3FiRTwdtKLIJjs+hWyKJjR
         WjVmKYDJ9VrBKtjDJ3FclDzo5D05z5E4FBrbDiPiqiVoIc2rTURX/PgBUb7LF6+kqluR
         /j+48Dn7IY3HUDI3yWsEfopy8aHgJ2nWKKZ3fwKtkaiY2PsXqlmSAxtXRMufJQU03WXM
         HExg==
X-Gm-Message-State: AO0yUKUwW2gwKJjxBDMy5gRzV541JAyUKqr5UIMrgNSKcVrcGR3iw8a9
        dABh2+XHuavwH/LnYkrMuWUIxZBrQQwo9zV+J7K5NQ==
X-Google-Smtp-Source: AK7set/tmh51lo08KsdcoZQoNyHkzL0IP8N96GUiRbXJIJQ+ZZhRCwwe37H+aoeqebCQTVNtJJHISje5C8PMQgzH/UM=
X-Received: by 2002:a25:ae93:0:b0:7d1:5a92:eb5c with SMTP id
 b19-20020a25ae93000000b007d15a92eb5cmr843519ybj.166.1675361193915; Thu, 02
 Feb 2023 10:06:33 -0800 (PST)
MIME-Version: 1.0
References: <20230202025716.216323-1-shahuang@redhat.com> <20230202081057.nanfjavyy2l4pswc@orel>
In-Reply-To: <20230202081057.nanfjavyy2l4pswc@orel>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 2 Feb 2023 10:05:57 -0800
Message-ID: <CAHVum0cs8Q+DWAswsmUG6xSchVzuoUcpScCrb+a_gJ-QWDdf+g@mail.gmail.com>
Subject: Re: [PATCH v2] selftests: KVM: Replace optarg with arg in guest_modes_cmdline
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     shahuang@redhat.com, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 2, 2023 at 12:11 AM Andrew Jones <andrew.jones@linux.dev> wrote:
>
> On Thu, Feb 02, 2023 at 10:57:15AM +0800, shahuang@redhat.com wrote:
> > From: Shaoqin Huang <shahuang@redhat.com>
> >
> > The parameter arg in guest_modes_cmdline not being used now, and the
> > optarg should be replaced with arg in guest_modes_cmdline.
> >
> > And this is the chance to change strtoul() to atoi_non_negative(), since
> > guest mode ID will never be negative.
>
> Fixes: e42ac777d661 ("KVM: selftests: Factor out guest mode code")
>
> >
> > Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> >
> > ---
> > Changes from v1:
> >   - Change strtoul() to atoi_non_negative(). [Vipin]
> >
> > ---
> >  tools/testing/selftests/kvm/lib/guest_modes.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
> > index 99a575bbbc52..1df3ce4b16fd 100644
> > --- a/tools/testing/selftests/kvm/lib/guest_modes.c
> > +++ b/tools/testing/selftests/kvm/lib/guest_modes.c
> > @@ -127,7 +127,7 @@ void guest_modes_cmdline(const char *arg)
> >               mode_selected = true;
> >       }
> >
> > -     mode = strtoul(optarg, NULL, 10);
> > +     mode = atoi_non_negative("Guest mode ID", arg);
> >       TEST_ASSERT(mode < NUM_VM_MODES, "Guest mode ID %d too big", mode);
> >       guest_modes[mode].enabled = true;
> >  }
> > --
> > 2.39.0
> >
>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Vipin Sharma <vipinsh@google.com>
