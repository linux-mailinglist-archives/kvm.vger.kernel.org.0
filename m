Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8084848DD7A
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 19:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237499AbiAMSLc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 13:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiAMSLb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 13:11:31 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AFAC061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 10:11:31 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id g205so8833335oif.5
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 10:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IfqHDINQ/xZU6VJxiL9fAKmI7gegsBATGLvNSh8LVMA=;
        b=Vdsl60lhIcN7wjVROLG2K0ShaIuyBVQmAmOnB6d9oMW19uk117hotmqDwneePBcEa2
         +BqBNJRi1IikswrmJY1tmCk4DvcfTg47h9uvzwg0uaTet5YjNt7nNxOBLx2caCNbOQpx
         fojKMrkk0WXBztyCLlW/PFyOlYsWvbqWGLr/ois0lXVFkYQOIvn4M/K/fdeAttAJGjFN
         joiWbDo0r05Rv0yWj8Ss2qQOm669nhrR8aFs+Bv8+wA02wFZUJ7Ijcq+XWGtFufEXw4f
         J/R2Xhlv0dtIU/WTHkV/muGkY74lsXOF4uRAa5n+/nfKEcVnODD2oFZbEWBA9QDrAk/W
         IJAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IfqHDINQ/xZU6VJxiL9fAKmI7gegsBATGLvNSh8LVMA=;
        b=wvGNUypeUxkzq8PdbYs+m31jENKeN5VEJ1eGU+DdzUVl5Yqxl0i9Y7uPuQ8tE4x2uP
         Xmsa0sDkZOcZarFBlute3NeCCXM+Lq7X3lxAXkDu4fdx4kuRWgcyMU6R+HYewZv6ee6K
         VtfsFXu4cMVMi+ctSa4F2LCXLhtwa8m+nqkMx7kackRALQJK4vs+ijwZFff5UbKqwOGm
         A8lZIjNiGXSsw+ixIi4Pb+JWAnKQlA/aHve9uJWrH18iSLf4C0QroFYY6Kv8LFYUaAOG
         qn18A9/taS7SLMBcd6ggrT5AARVt7Xbjz94jJekBYXcwJ/0HzKIv6AWzC/fEiXcutI8/
         vjUA==
X-Gm-Message-State: AOAM532ECJXck46v9rJJnOGT2LyP8VuWFs/fodCmE1Dtr1eKL/j0KxRm
        uqqOnv3Soa9p24XysH2cFyHGr/XOi1glyKBlTtoQiw==
X-Google-Smtp-Source: ABdhPJwe61dlX+A0NcpkQm2EjQJWCN/lrs8oDBG6E7dxZWNiCqA7aYhrJ5OMrZvhy5ANZEtPJpEMXrgph7hUFP3woaY=
X-Received: by 2002:a05:6808:14cd:: with SMTP id f13mr4425823oiw.76.1642097490247;
 Thu, 13 Jan 2022 10:11:30 -0800 (PST)
MIME-Version: 1.0
References: <20220113011453.3892612-1-jmattson@google.com> <20220113011453.3892612-4-jmattson@google.com>
 <CABOYuvbc=ik3OVSz4f2BaWvM57_k-KESk_fBdtzKwOh46YMBMA@mail.gmail.com>
In-Reply-To: <CABOYuvbc=ik3OVSz4f2BaWvM57_k-KESk_fBdtzKwOh46YMBMA@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 13 Jan 2022 10:11:19 -0800
Message-ID: <CALMp9eSeSUU1O=4b-58pckd=t3WLErUSrsQ3VJ6cYs4-nAgmEw@mail.gmail.com>
Subject: Re: [PATCH 3/6] selftests: kvm/x86: Introduce is_amd_cpu()
To:     David Dunn <daviddunn@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 13, 2022 at 8:51 AM David Dunn <daviddunn@google.com> wrote:
>
> Jim,
>
> On Wed, Jan 12, 2022 at 5:15 PM Jim Mattson <jmattson@google.com> wrote:
>
> > +bool is_amd_cpu(void)
> > +{
> > +       return cpu_vendor_string_is("AuthenticAMD") ||
> > +               cpu_vendor_string_is("AMDisbetter!");
> > +}
> > +
>
> The original code only checked for AuthenticAMD.  I don't think it is
> necessary or wise to add the check for early K5 samples.  Do we know
> whether they even need this KVM logic?

The original code should handle K5 CPUs in the next block:

        /* On parts with <40 physical address bits, the area is fully hidden */
       if (vm->pa_bits < 40)
                return max_gfn;

But, you're right. K5 predates AMD support for SVM, so we don't need
to test kvm functionality on early K5 samples.

I'll remove the second disjunct in v2.

Thanks!
