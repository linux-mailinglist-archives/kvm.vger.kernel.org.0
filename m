Return-Path: <kvm+bounces-1981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B1A7EFAFD
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 22:43:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E6901C20B20
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 21:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD7F4314E;
	Fri, 17 Nov 2023 21:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oU3TfKiS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02151D5C
	for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 13:43:03 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-545557de8e6so4063a12.0
        for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 13:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700257381; x=1700862181; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ujYjA2fMuJosPo3loLcixIlShBqonBBw0jOYoqTUEbI=;
        b=oU3TfKiSwWbfOYyiJNvxCkq5Fn4dZaXrjA1C8kA6kZRODOgjFfezNVV6cmNwD2O63E
         eh/67HuO7MEfcXZP5SLKyiDt6asqpkDawd3eLgUQy1XPuZSI/7nl/Vt1vhpxb7ZLkef2
         OsFXU/pamJFq1D+vMK7rFSWcP9gc0reIGGcUmU6tWr9RNQgG0E4LKbPStpGQl1J0gUDk
         kFiqL2EeIM6JBYbodtzYhYYH0XYfW3PJJyNzqO0qWHI83N3t0U7PO9Cq11nel79g2SF/
         q/CIynBsA2/d9TBVA68YhNaPxqYK1LrNLG1YlNojikgSYWFC43CJGgXQDpjblpXsopg+
         EQ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700257381; x=1700862181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ujYjA2fMuJosPo3loLcixIlShBqonBBw0jOYoqTUEbI=;
        b=dIEsZOMolDNrIzDzDpdXBnVSK3jFIzDz97ucg27Wu8h+fb7/HO0bolKdrv8+GtlnGg
         C/IG0dNRA3nHErsffHEOAJnQnaXVWLQ3iQ5Zn+X8QA+zZYyW+C3Fl1hbhgkBy7HevE67
         r8dB5D9ffxVgotaDcqGhKGanKXGf0yALtkNNNkx3dMmiGem4CGkJgfooA3xS6fL+kyBP
         S1mFiqB6awJ4xF+13V2ioF8qsiiRBA0kFwHNLshxJlPlrxloc7jGc4s4jrTCKvwxd/X0
         7YObFc14YiDMghZ9zYWQw/fgsZ0Lti+hFfgWJL9FGPyAAqbaK+yTsW0cwJNcsNSqrMC7
         Un8Q==
X-Gm-Message-State: AOJu0Yybbzglvu3GO9NVt0DSiLvBAz+jyJUxtCApVx4Y6sbabpwlzW2D
	VP1p5Ojl++jELOhwHJczyyWgY4zd2JLRrGGsK+y7fw==
X-Google-Smtp-Source: AGHT+IFzo4owGzdKo8rsXvYDeRW/CQLhY7R8K7FADyBpLoJaOtqZgCWDwniibGxYqIp45hkQ1/AU39ZCwnDLjjBxymM=
X-Received: by 2002:a05:6402:1492:b0:547:9b49:f221 with SMTP id
 e18-20020a056402149200b005479b49f221mr225727edv.6.1700257381255; Fri, 17 Nov
 2023 13:43:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-3-oliver.upton@linux.dev> <CAM9d7cjxkAmEc=g0jWBPQ9d6GYmfdZSKjqi5v0UsoPvkQy-fSw@mail.gmail.com>
 <ZS/n5dqo6dZE40HE@kernel.org> <CAP-5=fWcrQqZz5vTEd_YHBcZ8rGF4Shj=QpZ9mTLDnXbwwLZmw@mail.gmail.com>
In-Reply-To: <CAP-5=fWcrQqZz5vTEd_YHBcZ8rGF4Shj=QpZ9mTLDnXbwwLZmw@mail.gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Fri, 17 Nov 2023 13:42:49 -0800
Message-ID: <CAP-5=fXxiOJMVqaH1JPU_K6+1GhaEgVeR7YyN+F0r7qTE8DGEw@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] perf build: Generate arm64's sysreg-defs.h and add
 to include path
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-perf-users@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
	Jing Zhang <jingzhangos@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse <james.morse@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 6, 2023 at 10:10=E2=80=AFPM Ian Rogers <irogers@google.com> wro=
te:
>
> On Wed, Oct 18, 2023 at 7:12=E2=80=AFAM Arnaldo Carvalho de Melo
> <acme@kernel.org> wrote:
> >
> > Em Tue, Oct 17, 2023 at 03:23:40PM -0700, Namhyung Kim escreveu:
> > > Hello,
> > >
> > > On Wed, Oct 11, 2023 at 12:58=E2=80=AFPM Oliver Upton <oliver.upton@l=
inux.dev> wrote:
> > > >
> > > > Start generating sysreg-defs.h in anticipation of updating sysreg.h=
 to a
> > > > version that needs the generated output.
> > > >
> > > > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > >
> > > It seems we also need this on non-ARM archs to process ARM SPE data.
> > >
> > > Acked-by: Namhyung Kim <namhyung@kernel.org>
> >
> > When building with CORESIGHT=3D1, yes.
> >
> > I have it in my tests and:
> >
> > =E2=AC=A2[acme@toolbox perf-tools-next]$ ls -la /tmp/build/perf-tools-n=
ext/util/arm-spe.o
> > -rw-r--r--. 1 acme acme 135432 Oct 17 16:49 /tmp/build/perf-tools-next/=
util/arm-spe.o
> > =E2=AC=A2[acme@toolbox perf-tools-next]$ ldd /tmp/build/perf-tools-next=
/perf | grep csd
> >         libopencsd_c_api.so.1 =3D> /lib64/libopencsd_c_api.so.1 (0x0000=
7f36bfca5000)
> >         libopencsd.so.1 =3D> /lib64/libopencsd.so.1 (0x00007f36be2e0000=
)
> > =E2=AC=A2[acme@toolbox perf-tools-next]$ rpm -qf /lib64/libopencsd.so.1
> > opencsd-1.3.3-1.fc38.x86_64
> > =E2=AC=A2[acme@toolbox perf-tools-next]$ rpm -q --qf "%{summary}\n" ope=
ncsd
> > An open source CoreSight(tm) Trace Decode library
> > =E2=AC=A2[acme@toolbox perf-tools-next]$
> >
> > Well, double checked and arm-spe.o is built by default, only way to
> > disable it is using NO_AUXTRACE=3D1 in the make command line, but then
> > IIRC one needs linking with opencsd to decode all those traces, right?
> >
> > Anyway:
> >
> > Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> >
> > - Arnaldo
> >
> > > Thanks,
> > > Namhyung
> > >
> > >
> > > > ---
> > > >  tools/perf/Makefile.perf | 15 +++++++++++++--
> > > >  tools/perf/util/Build    |  2 +-
> > > >  2 files changed, 14 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> > > > index 37af6df7b978..14dedd11a1f5 100644
> > > > --- a/tools/perf/Makefile.perf
> > > > +++ b/tools/perf/Makefile.perf
> > > > @@ -443,6 +443,15 @@ drm_ioctl_tbl :=3D $(srctree)/tools/perf/trace=
/beauty/drm_ioctl.sh
> > > >  # Create output directory if not already present
> > > >  _dummy :=3D $(shell [ -d '$(beauty_ioctl_outdir)' ] || mkdir -p '$=
(beauty_ioctl_outdir)')
> > > >
> > > > +arm64_gen_sysreg_dir :=3D $(srctree)/tools/arch/arm64/tools
> > > > +
> > > > +arm64-sysreg-defs: FORCE
> > > > +       $(Q)$(MAKE) -C $(arm64_gen_sysreg_dir)
>
> Should this not build an install_headers target? The generated code is
> going into the source tree as is, ignoring O=3D options to make.

I think on top of this, tools/perf/MANIFEST needs to have:
arch/arm64/tools/gen-sysreg.awk
arch/arm64/tools/sysreg
This will add these files to the release tar balls, it already
contains things like scripts/bpf_doc.py.
tools/arch/arm64/tools/Makefile is picked up by tools/arch being in
the MANIFEST.

Thanks,
Ian

