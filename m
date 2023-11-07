Return-Path: <kvm+bounces-831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9C747E3513
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 07:10:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E95571C20AF4
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 06:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18FF8B653;
	Tue,  7 Nov 2023 06:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DwFY0WqD"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284FC8C19
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 06:10:48 +0000 (UTC)
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345DB110
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 22:10:43 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-50931d0bb04so2288e87.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 22:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699337441; x=1699942241; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7w492P8EaMyzzBXQGsoWoq23LSvZpwaYh30vR46ByNc=;
        b=DwFY0WqDuzVuffzxYZHFksTXVBuK1aS5KiCy8Q0dqtZpO8bevK45K0z21+f+wHCdJz
         1eW9964gvfut+B6xfrx6kggJV5eKkRZMfU/hoYvkWhsic19ZSK5dwgs7aoYtH7btgwhq
         mrHAErE4fuR1EE5HRZplc6+JePEpC1dxcE2mijhqr3loxFCVqtaViyVlpYCAus5MOYFJ
         G1sitE59nihM5Qc/e8mdl8/kv+yrnOxeMlPUcg7DL0lSj/745tuolmP409IQ1h1ucK4G
         xcdZWcS8sECTnsBYNtPTxEVzSHOANqZcluUSZsgaKz6a9YjXWBmAWFYJjFy9scrdQcNP
         0AUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699337441; x=1699942241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7w492P8EaMyzzBXQGsoWoq23LSvZpwaYh30vR46ByNc=;
        b=TisaKWB9kAKXRDeRLLwJtxmyjBGjm/3aeJ3tM7HLDaebVDFfz7CZvVKKoCVNHH1NKY
         qNjeW6aCCIBdQDMAg1sUXNtQNiaInT81e0rGoX7dRDCRY+MtiMHtrOTvNcexmQkxGRCH
         sFEcw2af4Ql8VewbYAieKKHELqaO7yDiJuR4FYLhYNal/Uri28/guBLycjHKi6yD1OzB
         YH9NIb3ElhH3jtsZQr1Y2LQqf2b515vI74qMQzT+hN1KTKjvX6oApIKfn81EvGov4xbm
         Pk6mX04kNQU5tKFjVEy2AvkdFqyda6e303GVXcRtADb5+ZKn7Uo9AXu718ZLk2eBccEf
         PX2A==
X-Gm-Message-State: AOJu0Yz8h2aLaLXHKXAKKb1dtzeBt8xECSOsfmVfOFeIhxkw/HsBf/fx
	R8tBsexZNMJn6mWXYEqgsfZleODP+LbFOYN2D7/sMA==
X-Google-Smtp-Source: AGHT+IEQvtxnLlB7F29eRu/cA7awY+Kxexhgv1i34AQJasD2LNOF96/NDCw5kXIBvzx84FiV23+2NcPPv0JH3c6k38Q=
X-Received: by 2002:a05:6512:108c:b0:501:a2b9:6046 with SMTP id
 j12-20020a056512108c00b00501a2b96046mr38300lfg.7.1699337441012; Mon, 06 Nov
 2023 22:10:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-3-oliver.upton@linux.dev> <CAM9d7cjxkAmEc=g0jWBPQ9d6GYmfdZSKjqi5v0UsoPvkQy-fSw@mail.gmail.com>
 <ZS/n5dqo6dZE40HE@kernel.org>
In-Reply-To: <ZS/n5dqo6dZE40HE@kernel.org>
From: Ian Rogers <irogers@google.com>
Date: Mon, 6 Nov 2023 22:10:29 -0800
Message-ID: <CAP-5=fWcrQqZz5vTEd_YHBcZ8rGF4Shj=QpZ9mTLDnXbwwLZmw@mail.gmail.com>
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

On Wed, Oct 18, 2023 at 7:12=E2=80=AFAM Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
> Em Tue, Oct 17, 2023 at 03:23:40PM -0700, Namhyung Kim escreveu:
> > Hello,
> >
> > On Wed, Oct 11, 2023 at 12:58=E2=80=AFPM Oliver Upton <oliver.upton@lin=
ux.dev> wrote:
> > >
> > > Start generating sysreg-defs.h in anticipation of updating sysreg.h t=
o a
> > > version that needs the generated output.
> > >
> > > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> >
> > It seems we also need this on non-ARM archs to process ARM SPE data.
> >
> > Acked-by: Namhyung Kim <namhyung@kernel.org>
>
> When building with CORESIGHT=3D1, yes.
>
> I have it in my tests and:
>
> =E2=AC=A2[acme@toolbox perf-tools-next]$ ls -la /tmp/build/perf-tools-nex=
t/util/arm-spe.o
> -rw-r--r--. 1 acme acme 135432 Oct 17 16:49 /tmp/build/perf-tools-next/ut=
il/arm-spe.o
> =E2=AC=A2[acme@toolbox perf-tools-next]$ ldd /tmp/build/perf-tools-next/p=
erf | grep csd
>         libopencsd_c_api.so.1 =3D> /lib64/libopencsd_c_api.so.1 (0x00007f=
36bfca5000)
>         libopencsd.so.1 =3D> /lib64/libopencsd.so.1 (0x00007f36be2e0000)
> =E2=AC=A2[acme@toolbox perf-tools-next]$ rpm -qf /lib64/libopencsd.so.1
> opencsd-1.3.3-1.fc38.x86_64
> =E2=AC=A2[acme@toolbox perf-tools-next]$ rpm -q --qf "%{summary}\n" openc=
sd
> An open source CoreSight(tm) Trace Decode library
> =E2=AC=A2[acme@toolbox perf-tools-next]$
>
> Well, double checked and arm-spe.o is built by default, only way to
> disable it is using NO_AUXTRACE=3D1 in the make command line, but then
> IIRC one needs linking with opencsd to decode all those traces, right?
>
> Anyway:
>
> Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> - Arnaldo
>
> > Thanks,
> > Namhyung
> >
> >
> > > ---
> > >  tools/perf/Makefile.perf | 15 +++++++++++++--
> > >  tools/perf/util/Build    |  2 +-
> > >  2 files changed, 14 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> > > index 37af6df7b978..14dedd11a1f5 100644
> > > --- a/tools/perf/Makefile.perf
> > > +++ b/tools/perf/Makefile.perf
> > > @@ -443,6 +443,15 @@ drm_ioctl_tbl :=3D $(srctree)/tools/perf/trace/b=
eauty/drm_ioctl.sh
> > >  # Create output directory if not already present
> > >  _dummy :=3D $(shell [ -d '$(beauty_ioctl_outdir)' ] || mkdir -p '$(b=
eauty_ioctl_outdir)')
> > >
> > > +arm64_gen_sysreg_dir :=3D $(srctree)/tools/arch/arm64/tools
> > > +
> > > +arm64-sysreg-defs: FORCE
> > > +       $(Q)$(MAKE) -C $(arm64_gen_sysreg_dir)

Should this not build an install_headers target? The generated code is
going into the source tree as is, ignoring O=3D options to make.

Thanks,
Ian

> > > +
> > > +arm64-sysreg-defs-clean:
> > > +       $(call QUIET_CLEAN,arm64-sysreg-defs)
> > > +       $(Q)$(MAKE) -C $(arm64_gen_sysreg_dir) clean > /dev/null
> > > +
> > >  $(drm_ioctl_array): $(drm_hdr_dir)/drm.h $(drm_hdr_dir)/i915_drm.h $=
(drm_ioctl_tbl)
> > >         $(Q)$(SHELL) '$(drm_ioctl_tbl)' $(drm_hdr_dir) > $@
> > >
> > > @@ -716,7 +725,9 @@ endif
> > >  __build-dir =3D $(subst $(OUTPUT),,$(dir $@))
> > >  build-dir   =3D $(or $(__build-dir),.)
> > >
> > > -prepare: $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h archheade=
rs $(drm_ioctl_array) \
> > > +prepare: $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h archheade=
rs \
> > > +       arm64-sysreg-defs \
> > > +       $(drm_ioctl_array) \
> > >         $(fadvise_advice_array) \
> > >         $(fsconfig_arrays) \
> > >         $(fsmount_arrays) \
> > > @@ -1125,7 +1136,7 @@ endif # BUILD_BPF_SKEL
> > >  bpf-skel-clean:
> > >         $(call QUIET_CLEAN, bpf-skel) $(RM) -r $(SKEL_TMP_OUT) $(SKEL=
ETONS)
> > >
> > > -clean:: $(LIBAPI)-clean $(LIBBPF)-clean $(LIBSUBCMD)-clean $(LIBSYMB=
OL)-clean $(LIBPERF)-clean fixdep-clean python-clean bpf-skel-clean tests-c=
oresight-targets-clean
> > > +clean:: $(LIBAPI)-clean $(LIBBPF)-clean $(LIBSUBCMD)-clean $(LIBSYMB=
OL)-clean $(LIBPERF)-clean arm64-sysreg-defs-clean fixdep-clean python-clea=
n bpf-skel-clean tests-coresight-targets-clean
> > >         $(call QUIET_CLEAN, core-objs)  $(RM) $(LIBPERF_A) $(OUTPUT)p=
erf-archive $(OUTPUT)perf-iostat $(LANG_BINDINGS)
> > >         $(Q)find $(or $(OUTPUT),.) -name '*.o' -delete -o -name '\.*.=
cmd' -delete -o -name '\.*.d' -delete
> > >         $(Q)$(RM) $(OUTPUT).config-detected
> > > diff --git a/tools/perf/util/Build b/tools/perf/util/Build
> > > index 6d657c9927f7..2f76230958ad 100644
> > > --- a/tools/perf/util/Build
> > > +++ b/tools/perf/util/Build
> > > @@ -345,7 +345,7 @@ CFLAGS_rbtree.o        +=3D -Wno-unused-parameter=
 -DETC_PERFCONFIG=3D"BUILD_STR($(ET
> > >  CFLAGS_libstring.o     +=3D -Wno-unused-parameter -DETC_PERFCONFIG=
=3D"BUILD_STR($(ETC_PERFCONFIG_SQ))"
> > >  CFLAGS_hweight.o       +=3D -Wno-unused-parameter -DETC_PERFCONFIG=
=3D"BUILD_STR($(ETC_PERFCONFIG_SQ))"
> > >  CFLAGS_header.o        +=3D -include $(OUTPUT)PERF-VERSION-FILE
> > > -CFLAGS_arm-spe.o       +=3D -I$(srctree)/tools/arch/arm64/include/
> > > +CFLAGS_arm-spe.o       +=3D -I$(srctree)/tools/arch/arm64/include/ -=
I$(srctree)/tools/arch/arm64/include/generated/
> > >
> > >  $(OUTPUT)util/argv_split.o: ../lib/argv_split.c FORCE
> > >         $(call rule_mkdir)
> > > --
> > > 2.42.0.609.gbb76f46606-goog
> > >
>
> --
>
> - Arnaldo

