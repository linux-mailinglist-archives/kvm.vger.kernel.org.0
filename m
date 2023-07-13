Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96EE752396
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 15:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234998AbjGMNXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 09:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235287AbjGMNW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 09:22:59 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD1835A4;
        Thu, 13 Jul 2023 06:21:55 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id 5614622812f47-3a3373211a1so599566b6e.0;
        Thu, 13 Jul 2023 06:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689254505; x=1691846505;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nMl5dn5Xz12gXOMX3oC+kNdFlWhzCPfH45LFdGwDg+c=;
        b=eshePJRxBGfoEbxv/HATy/LbMrzsCDpyAiPdPWKP2+7M1zJL3N5KwDGRakUw3RzP4p
         q0Cnwz0fdaQ+HyxVhl+a/PdVIYgV40UvVYeo6oku2ew3IT0bTt6UYAHjOIS6Vb6t9Mla
         Zj8EL/FlPFPvHB5g71aE7gFP3zFqlG9d7Fbu8m/nhV/T9INJD8alH0sgU2iXPleyzim5
         lINS3JcD7J0TOIOFW4pf/x8/SEpIIASy3dTyyqXfKshxdSJS0TlF/u7bPTHA+oWf2AYl
         SPCY6gZL7ykEOqi+bfIKlTKf4FRPiV/L6IcHOgev/4QAZK/gwKYWQ5RBFTfBsMThGpXg
         EmsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689254505; x=1691846505;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nMl5dn5Xz12gXOMX3oC+kNdFlWhzCPfH45LFdGwDg+c=;
        b=j83XsvWDS/59ZRtQNCcRAswIv16C/Ap9bYQ7j7wfNDDqZJGj+9X6PN0myKyTn4wU/i
         y8lUrBbzN0IGkqFJIGn14itdBwejbJyGcz7lXonJZl1nmaadHFNEFCxwjdSooeEFarSt
         I0VBTBUo3tKSKckSLv4oAgiPmUDwXMDtg0SWsjnciMEDu6D9tSVCAaimjZYd8ygMiWVn
         MECXv/JlFjPyRMpIHomXKdSTxE+LEqSJsjSoGQhSW5+qEP9eCn97FpERdTAePvRLc7eQ
         AIBcHvlK4CXCfHch8yENA+eInOM8R3OhlYuomglfXxtPR4OnRIBf1XICkzYjiANUcfZq
         lfrQ==
X-Gm-Message-State: ABy/qLYY6JcJ8DGyhX42Jaab91F5v99cEz0v9EICy2Nf3tor+kPCGGR2
        URdZJuZIpI2Xxk5dU5zAEHUPOtkhGiETLimmigA=
X-Google-Smtp-Source: APBJJlG+0WtfiM+r2sXZzO6HNFK4R91MA9ooy29hXDBdzlOr5q/1lWHuWptQzwph8RqHPwzWZYnIoYS2ozC9kDF6TM8=
X-Received: by 2002:a05:6358:428e:b0:135:5934:2bba with SMTP id
 s14-20020a056358428e00b0013559342bbamr2356344rwc.8.1689254505432; Thu, 13 Jul
 2023 06:21:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230713130338.31086-1-tzimmermann@suse.de> <20230713130338.31086-19-tzimmermann@suse.de>
In-Reply-To: <20230713130338.31086-19-tzimmermann@suse.de>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Thu, 13 Jul 2023 15:21:34 +0200
Message-ID: <CANiq72mbLmMKph8aiz4apNF9n3MtVO-nhM9rEWYApZbSVAO9Qw@mail.gmail.com>
Subject: Re: [PATCH v2 18/18] fbdev: Document that framebuffer_alloc() returns
 zero'ed data
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     deller@gmx.de, javierm@redhat.com, linux-sh@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-nvidia@lists.surfsouth.com,
        linux-hyperv@vger.kernel.org, linux-omap@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        Miguel Ojeda <ojeda@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 13, 2023 at 3:03=E2=80=AFPM Thomas Zimmermann <tzimmermann@suse=
.de> wrote:
>
> Most fbdev drivers depend on framebuffer_alloc() to initialize the
> allocated memory to 0. Document this guarantee.
>
> Suggested-by: Miguel Ojeda <ojeda@kernel.org>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Helge Deller <deller@gmx.de>

Thanks for sending this! Maybe this would be best earlier in the
series, so that later patches make more sense (since they use the
guarantee), but it is not a big deal.

> + * aligned to sizeof(long). Both, the instance of struct fb_info and
> + * the driver private data, are cleared to zero.

I think both commas may be best omitted (but I am not a native speaker).

Reviewed-by: Miguel Ojeda <ojeda@kernel.org>

Cheers,
Miguel
