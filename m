Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4DD4DCED8
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 20:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbiCQT3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 15:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238021AbiCQT3M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 15:29:12 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3248D2B19E
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 12:27:54 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id bt26so10703394lfb.3
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 12:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VTEYKKnD9Abk3StH02JFKUUVqoErrV7erm6YoKMXLDA=;
        b=oUf4ri+6Kq6udNPW1+NGRcJwzLguRtKv1W4Cavrl07UwNv6r4DgK4tO2BWiFMotHl5
         6oKWUXvzoktAGtM5Xs4od7R+RHfuhhCMr+XYMhq2N04ddwHGEuzD3q5xZz+w5DYfYEcy
         uSO8dBOa/09qaN/4yWnIbKt2Fk56+B0eQf4ckRPUdYkkGwhuOaU6SvBi2o45qF8jgg7D
         m5/AJEuQsE9a/lPUoQ9oxHOnKQ6P8P0FSP5jQjeNAbLZS0MQOwPX5HboOrn1W7aZ+Voz
         V6ANk0RqawRCpMtfHGbhatJh2jWZRx//rQIgkSlfVuKOKubWZSV6oBdPx4rOO8bBxMrH
         Q5aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VTEYKKnD9Abk3StH02JFKUUVqoErrV7erm6YoKMXLDA=;
        b=uc3M/I0bd+PUDEq93/nsGdg+xlHs5xOTkpb4P14y4JoDH22MUBDOIfnRBQRfm1R5JL
         NPL+l0JS8zJAO33eXEht0Q6Z1A1pY9gfX0rPLgtM4xksNGu9LwxYyZZSwXSKuq6SIOCM
         9nubEurSj0vjETi+NMMifYvo/CALx1eoKbSPGuJkfH7FTQFUnCV7hl90xbGRva9keYmO
         dDS5pN3SR6QwMJOt8IkbypHDskuujLySKx4NQY739rxwSqzDtDjpmvIPiXOBFebYQtF3
         OBio3b8G7LYw37luEcpNKf4WmHli+sVYq7eDzMSf0XSUapXAFaJsxBudPigEnrrLiYdj
         gLiQ==
X-Gm-Message-State: AOAM530UGs5zIBl9Zc7yee9mSCS7D9A2Onj4J2tdlW8ZAK0/ej+y27yc
        8fZT5sDhYa6r4oBeod9y1kYj1YLDDRe9N9dAy0ilYLVCWd03eg==
X-Google-Smtp-Source: ABdhPJylmPA/jLEu9uGgjwVB953BDHdljfCre7Fr9RZzZMrqeGCbcmEJwUZU6dkZV0rO1dDXGxtsm9lgwhOOzeoQj8g=
X-Received: by 2002:a05:6512:3f1d:b0:443:3c8b:58f5 with SMTP id
 y29-20020a0565123f1d00b004433c8b58f5mr3842118lfa.669.1647545272076; Thu, 17
 Mar 2022 12:27:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220317192707.59538-1-oupton@google.com>
In-Reply-To: <20220317192707.59538-1-oupton@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 17 Mar 2022 12:27:41 -0700
Message-ID: <CAOQ_QsgMkyeWzHA2Z3VEMuzb=tjog4einE3EVjoPvUppCmvLzQ@mail.gmail.com>
Subject: Re: [PATCH] x86/cpuid: Stop masking the CPU vendor
To:     kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
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

Argh. Sorry. Sent with the wrong prefix.

On Thu, Mar 17, 2022 at 12:27 PM Oliver Upton <oupton@google.com> wrote:
>
> commit bc0b99a ("kvm tools: Filter out CPU vendor string") replaced the
> processor's native vendor string with a synthetic one to hack around
> some interesting guest MSR accesses that were not handled in KVM. In
> particular, the MC4_CTL_MASK MSR was accessed for AMD VMs, which isn't
> supported by KVM. This MSR relates to masking MCEs originating from the
> northbridge on real hardware, but is of zero use in virtualization.
>
> Speaking more broadly, KVM does in fact do the right thing for such an
> MSR (#GP), and it is annoying but benign that KVM does a printk for the
> MSR. Masking the CPU vendor string is far from ideal, and gets in the
> way of testing vendor-specific CPU features. Stop the shenanigans and
> expose the vendor ID as returned by KVM_GET_SUPPORTED_CPUID.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  x86/cpuid.c | 8 --------
>  1 file changed, 8 deletions(-)
>
> diff --git a/x86/cpuid.c b/x86/cpuid.c
> index aa213d5..f4347a8 100644
> --- a/x86/cpuid.c
> +++ b/x86/cpuid.c
> @@ -10,7 +10,6 @@
>
>  static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid, int cpu_id)
>  {
> -       unsigned int signature[3];
>         unsigned int i;
>
>         /*
> @@ -20,13 +19,6 @@ static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid, int cpu_id)
>                 struct kvm_cpuid_entry2 *entry = &kvm_cpuid->entries[i];
>
>                 switch (entry->function) {
> -               case 0:
> -                       /* Vendor name */
> -                       memcpy(signature, "LKVMLKVMLKVM", 12);
> -                       entry->ebx = signature[0];
> -                       entry->ecx = signature[1];
> -                       entry->edx = signature[2];
> -                       break;
>                 case 1:
>                         entry->ebx &= ~(0xff << 24);
>                         entry->ebx |= cpu_id << 24;
> --
> 2.35.1.894.gb6a874cedc-goog
>
