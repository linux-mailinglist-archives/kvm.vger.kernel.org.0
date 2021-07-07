Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2423BECD2
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 19:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhGGRL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 13:11:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31495 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230417AbhGGRL1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 13:11:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625677726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZKokQ6HlP8zCRHXKsabsyD7PFz88tRZ5vWzOFOKcnus=;
        b=FfHLnEX3izBdfFMwxSSipR4/UeMuEOkx2gfa3B4JveO2TmkD+bg0NMLrXIYVASHUiw+V61
        E6FMj9QrQIHGjNoTMqx0CHXfpoYZMKcitifDzTFayIiKzg7H4+EWqiih9BUsrXaBm5r2F7
        F8BnQngy0MywnmLukr6oT00iZsp5eJk=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73--VGYUvwFNHm6UAuQqpwNww-1; Wed, 07 Jul 2021 13:08:45 -0400
X-MC-Unique: -VGYUvwFNHm6UAuQqpwNww-1
Received: by mail-lf1-f71.google.com with SMTP id y19-20020a1964130000b029035a3f9d08cdso1393050lfb.21
        for <kvm@vger.kernel.org>; Wed, 07 Jul 2021 10:08:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZKokQ6HlP8zCRHXKsabsyD7PFz88tRZ5vWzOFOKcnus=;
        b=EOmAXdZtrzVeNset6cCAPE+j+ufe8OOvRPC/0v4lrYuZeh/NOChzjpukyN8vSX+HYE
         ywL4vHl01sJRvCyhnKe4cOPQXlVrn+5LweUsEv6Ker9sk0vnWrh0PpTgPXrpwaKX9/cA
         h1EsgkSXEvDtL6XXa+MC0WjyE2oTF7MBW7ZhKg8x5EL0Vy9JsF5RlQ0mZUF2nfFLsh55
         hEHcDE8pkXBIDyQOKz6+mdiexo8FfFHl0h+dx/0r40Oth6NtfdVaQ6ZR5f9qIKUIjCse
         Ld6hlLdubsz5IHa8kSB0hpPksnMyrf2bkUrjpY++SDyCKPCo1dqhlYJowRIRugumKbpk
         eWJw==
X-Gm-Message-State: AOAM531PqCHNgk95axdqSQYRD+mOeHVJv318uXU1CFJwzpf+OT9P4/Nc
        Z9O58aAoLpvEL/XiuzyWXzf1GwP7Y/Mvukom7yEwQ9kme2XWR1qtRycP/u2VEa82c8AMq7i3I6m
        TAXl1VuvENY6EGpSw/9jPtObPVclE
X-Received: by 2002:a19:6d06:: with SMTP id i6mr13400987lfc.295.1625677723037;
        Wed, 07 Jul 2021 10:08:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIVbMaYKmhK4voQf0eRNSJP0bDqNGYvkVM74ION1H4OiOMDQQFrRwSGJ2qM5HSbBwHujP+BJ9y3biXkOhSbn8=
X-Received: by 2002:a19:6d06:: with SMTP id i6mr13400912lfc.295.1625677722393;
 Wed, 07 Jul 2021 10:08:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.2d906c322f72ec1420955136ebaa7a4c5073917c.1623272033.git-series.pawan.kumar.gupta@linux.intel.com>
 <de6b97a567e273adff1f5268998692bad548aa10.1623272033.git-series.pawan.kumar.gupta@linux.intel.com>
 <20210706195233.h6w4cm73oktfqpgz@habkost.net> <4cc2c5fe-2153-05c5-dedd-8cb650753740@redhat.com>
 <CAOpTY_qdbbnauTkbjkz+cZmo8=Hz6qqLNY6i6uamqhcty=Q1sw@mail.gmail.com>
 <671be35f-220a-f583-aa31-3a2da7dae93a@redhat.com> <CAOpTY_paTO=xqfGXPCC2Paty5ptJ6Dqpo4Tzb4C2hrO_t=vS8w@mail.gmail.com>
 <CALMp9eSJyvU1=FndZyR+hZMtKPWwgibKisBqp0Xcx4jxjrWn2w@mail.gmail.com>
In-Reply-To: <CALMp9eSJyvU1=FndZyR+hZMtKPWwgibKisBqp0Xcx4jxjrWn2w@mail.gmail.com>
From:   Eduardo Habkost <ehabkost@redhat.com>
Date:   Wed, 7 Jul 2021 13:08:26 -0400
Message-ID: <CAOpTY_pefOmJ0zJjUzitgTGxqgX6XxwTP0fMKoiyuBCHrh+AWg@mail.gmail.com>
Subject: Re: [PATCH 4/4] x86/tsx: Add cmdline tsx=fake to not clear CPUID bits
 RTM and HLE
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tony Luck <tony.luck@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Kyung Min Park <kyung.min.park@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Victor Ding <victording@google.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Mike Rapoport <rppt@kernel.org>,
        Anthony Steinhauser <asteinhauser@google.com>,
        Anand K Mistry <amistry@google.com>,
        Andi Kleen <ak@linux.intel.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Perches <joe@perches.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org, Jiri Denemark <jdenemar@redhat.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Michal Privoznik <mprivozn@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 7, 2021 at 12:42 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Wed, Jul 7, 2021 at 8:09 AM Eduardo Habkost <ehabkost@redhat.com> wrote:
> >
> > CCing libvir-list, Jiri Denemark, Michal Privoznik, so they are aware
> > that the definition of "supported CPU features" will probably become a
> > bit more complex in the future.
>
> Has there ever been a clear definition? Family, model, and stepping,
> for instance: are these the only values supported? That would make
> cross-platform migration impossible. What about the vendor string? Is
> that the only value supported? That would make cross-vendor migration
> impossible. For the maximum input value for basic CPUID information
> (CPUID.0H:EAX), is that the only value supported, or is it the maximum
> value supported? On the various individual feature bits, does a '1'
> imply that '0' is also supported, or is '1' the only value supported?
> What about the feature bits with reversed polarity (e.g.
> CPUID.(EAX=07H,ECX=0):EBX.FDP_EXCPTN_ONLY[bit 6])?
>
> This API has never made sense to me. I have no idea how to interpret
> what it is telling me.

Is this about GET_SUPPORTED_CPUID, QEMU's query-cpu-model-expansion &
related commands, or the libvirt CPU APIs?

-- 
Eduardo

