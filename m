Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A870A58A36
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 20:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfF0Swf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 14:52:35 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33794 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbfF0Swf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 14:52:35 -0400
Received: by mail-wr1-f67.google.com with SMTP id k11so3732731wrl.1
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2019 11:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hd3Spk/P7VWQnCphu6aJi1EWnlma1ycX1TNYRdNKZhs=;
        b=pR6NQ9Ay9gPL8DjEd8OKx4+AkV1ZRU/w1k9xXU0pwi/UN3SSCg3QjeeHUYlXilbT0h
         QDMf5ggA3Cn8ED+C9DE4S8EcCPZMSLzBfcD3xw1ZBn661n2h9MgEW8GvHK+nnPQYLHZY
         3FY+tl4FrSv6Ker2l8EPcfZe9SGqmvWujy4wfeu7iCfD0Es3N52hLb5jC3jasvpI4CSq
         vZlY0b6ssCLwMcsJazcB3lAaopKp4GP+iKGzzUqjoIjJEA/KJslAsrPj71UoQwwk6GpV
         0KBtDfuXAoxdgS7pkn8K1kof3O/qUDenEwMSTCOu6dBUWFjcNtd1rpmRxqLBUEyK+z6n
         bh9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hd3Spk/P7VWQnCphu6aJi1EWnlma1ycX1TNYRdNKZhs=;
        b=dcWlFQ972NX+bO7zq3eapOXYT+IscLIAy0fNlgJK0joOWTwp2tMU8/FW0v5hqsE/Vc
         ubv/xYBS1yM1DAmrhCxjujpR1CyG/xvNtnp1pfAZwijZTlpHGBqRcuBpmylOOEWyy/Cb
         lOCbuboTXc7ZmkdNCe58ndedeXL+47+GG6rfU2VxTtV5HLdS+25bM0cKcbTEbt/pLR/9
         5OZmNjBEStfLArjDGgqZmRCeP8BZ3OuAPr8McLbRp8aliyS4bJ+nOzoE4bI+14QwOFBF
         MpEfpUmVdt3UrJ3AyeImBaT297vc72MVyegCOA1I0BLV3uCdk+2YGhneRAX0OfY7Fnsy
         0cBQ==
X-Gm-Message-State: APjAAAU3wpZoo+7zkEkhIpfMqWRzgBjZbsC4hAqZm6Jg7WBW/a3ZKsrI
        CgDTtjlWvyS0pT5w+zEi2moQlXyHiTp8kcY2B/2zWw==
X-Google-Smtp-Source: APXvYqxF6c/DcihWiLaMHDSig+V2e6X5lRPmRO22lLnN8SRW2CsElaYe99U953Ep7HYH59YSkQcWvrJH2dAe3ywr5Ug=
X-Received: by 2002:adf:c614:: with SMTP id n20mr4658901wrg.17.1561661552513;
 Thu, 27 Jun 2019 11:52:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190627183651.130922-1-jmattson@google.com>
In-Reply-To: <20190627183651.130922-1-jmattson@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 27 Jun 2019 11:52:21 -0700
Message-ID: <CAA03e5FQs5GT5R3nwkON+zvNEm8fqUpwTgm6tcv1CS+ohsJAzQ@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Pass through AMD_STIBP_ALWAYS_ON in GET_SUPPORTED_CPUID
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 27, 2019 at 11:37 AM Jim Mattson <jmattson@google.com> wrote:
>
> This bit is purely advisory. Passing it through to the guest indicates
> that the virtual processor, like the physical processor, prefers that
> STIBP is only set once during boot and not changed.
>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 4992e7c99588..e52f0b20d2f0 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -377,7 +377,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>         /* cpuid 0x80000008.ebx */
>         const u32 kvm_cpuid_8000_0008_ebx_x86_features =
>                 F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
> -               F(AMD_SSB_NO) | F(AMD_STIBP);
> +               F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON);
>
>         /* cpuid 0xC0000001.edx */
>         const u32 kvm_cpuid_C000_0001_edx_x86_features =
> --
> 2.22.0.410.gd8fdbe21b5-goog
>

Reviewed-by: Marc Orr <marcorr@google.com>
