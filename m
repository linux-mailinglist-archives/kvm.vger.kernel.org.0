Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8546C3FCDFE
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 22:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240969AbhHaTkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 15:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240866AbhHaTkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 15:40:04 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BD3C061575
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 12:39:09 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id u3so1363125ejz.1
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 12:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g1UU4kH9+euHC3pNHU0UQPGTZt7Cfey6XaHtF6H4fds=;
        b=QgGFwK3bfY3tDXhLy4sCEpJiXAbYswZx00/hrGtTvUQi/w8Jj3uUYqTRtO7CMavd0r
         Byj+AUIu1IinQbCKDN2MAdSvMj2Be+cbjGdvTia3QxZbylEyHrRQ4YqZV1uiYaW3EkUz
         EbCNSSViDnuGfT9gQ3JTjJO1Jdoo7sNdrqPVsjNAxndt5GjEYn4U8ung5wr0jL6PqVgS
         0CykNm1gD+VzXJ6HglUQSDHHz2PaYGVDrT5S9Cb1WLFN6E95Rf3SNL6QPtdFNNEheQLf
         5NLBG0qF/x1LxXthkwk/6lBemjAumJv6cQ3CtBVcGq35w27oVv/ISTjqUl1lfGS8oIXx
         utUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g1UU4kH9+euHC3pNHU0UQPGTZt7Cfey6XaHtF6H4fds=;
        b=PY6SJP7wqV6Sm/fVSv1EmLGjB6InLIawX1N+x4/nq/XK7pTQtvWAaQ6phYdtvw4yz5
         6kYP5BW8WgW5jTStUkvWFMJc9Da0ce27d7Rpy1/F2rAJFVGdU1SjeeWdcthOEC5qbpmX
         t+A/EHcX1lvomlL/izBYhS1lEDRE6j4ANr1y7eHW5rtlUjDCG1jE+FrlqGoZCgur3VPg
         H2ybzq7XLMOvFyHlVq5OAIlw1b0ZYe2CkiREr/1WMI74aB3ILVOlo4pMLhh3faNGSNvN
         NwYYUdHms96raPk6zfS2AXSPNvkbMM/aIVKTQKH+FCyPF8dOdgl4s3lHu+qA5c9gphT7
         fLyw==
X-Gm-Message-State: AOAM531GUMXcffnCCtUtqBk+Y0b/Kvi+0uHtybx0UMW5zhYD2J4FHhn3
        seo2JiJA1yy/ctYCC0xJ08rDD6arFU3HoKIOYbBy4NlWYoc=
X-Google-Smtp-Source: ABdhPJwGWj8KIV8xn+yfXJlcdMkoyYD7xCl1T0u4JIuV9rlyXfNmOtNhU5Wxh3TyytXTC7FGSOUXaIlFNCzvPJIzCUc=
X-Received: by 2002:a17:906:b094:: with SMTP id x20mr32522563ejy.257.1630438747442;
 Tue, 31 Aug 2021 12:39:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-14-zixuanwang@google.com> <ec4e6492-ec42-84d2-7ed9-f30d3bfd2543@amd.com>
In-Reply-To: <ec4e6492-ec42-84d2-7ed9-f30d3bfd2543@amd.com>
From:   Zixuan Wang <zixuanwang@google.com>
Date:   Tue, 31 Aug 2021 12:38:31 -0700
Message-ID: <CAFVYft3E+XVhu_B+gM=fkWuhqqbaV1t7rc1jf6NZRLYN-MGSuQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 13/17] x86 AMD SEV-ES: Check SEV-ES status
To:     Tom Lendacky <Thomas.Lendacky@amd.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 7:56 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 8/26/21 10:12 PM, Zixuan Wang wrote:
> > +bool amd_sev_es_enabled(void)
> > +{
> > +     static bool sev_es_enabled;
> > +     static bool initialized = false;
> > +
> > +     if (!initialized) {
> > +             sev_es_enabled = false;
> > +             initialized = true;
> > +
> > +             if (!amd_sev_enabled()) {
> > +                     return sev_es_enabled;
> > +             }
> > +
> > +             /* Test if SEV-ES is enabled */
> > +             if (!(rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK)) {
> > +                     return sev_es_enabled;
> > +             }
> > +
> > +             sev_es_enabled = true;
>
> Same comment here as previous for the amd_sev_enabled() function in
> regards to readability.
>
> Thanks,
> Tom

Got it, I will update it in the next version. Thank you for the suggestion!

Best regards,
Zixuan
