Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243046C9B5A
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 08:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbjC0G1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 02:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjC0G1X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 02:27:23 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2574498
        for <kvm@vger.kernel.org>; Sun, 26 Mar 2023 23:27:22 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so10775569pjp.1
        for <kvm@vger.kernel.org>; Sun, 26 Mar 2023 23:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679898442;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/1MPkrc59nj7/vRx3EUgh/9Oxiv8gB+0mC5l8+wxrpQ=;
        b=GHu6JKpdfvBlZ5CaysvaaW5cDtdLeomhMMlCptnKmPowtDEYcaguwfh+0jqmk9xQFI
         1FN9tK8wUYX1MiEUyhUEzIyyvJi85fqIMXXcfMZAGG87+qhQk1EtSh6rpkl3aT5qR3Ll
         3/HeuOx+/zHKRPf6Jd27te9wX66gWCKXPJuo1G6HV8ESD1jJy0Pve+e7KW/c+mHm8LoD
         fuRgZckZJeVd+/zsPLpxTPJTgTJ5TVBuXhnOI1tJG6gGxA+BR/OWXf1TE3RXdQfVhIKC
         KqxD0D8Bc4rKkURenEJ71V/cOYjgf3i8yGn4wCO/6WlVrZ4Bfu53kBp/ZodcL1ZzWPkh
         SSOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679898442;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/1MPkrc59nj7/vRx3EUgh/9Oxiv8gB+0mC5l8+wxrpQ=;
        b=o+fixN2XUqhJuY0TehsDwrMQy8iR/yfqIXvy/icf08ed+GQw/Xosae8A2zhnNtqUwh
         QmipBnuWQrXSTDUPIB5ttjQ9oROcyxEB6JCOny/QsfqMSUT0lUEf/T3efMCZMbiCaDBs
         8szCyQ8uvrE6mQVhaQSb0ee7u7P7q8JL7m94nJTzPKbnc8f6evS2DeGnJlTWTvgIi8vG
         Jr8v55A1V2zw0zkkCABUMrbGLEB4jjY1aBNARuw/qPRoawwt6jQiOv0zfbWGGj6r4pcw
         GRHwtEQXukDeXjaYKJOfrkyM+kp5vS+iRiQlItI0giJcMRbuILZJ4MF/9fWyRPIgFeSw
         getw==
X-Gm-Message-State: AO0yUKWHC97I0NR48KQXLjYMCu9FO+bryuv350NYxeZv2VuLyLSgevKg
        KYCG3KbvI76gey4YXUqthuw=
X-Google-Smtp-Source: AK7set/TTGUxgm141UWAXtsIwKXBDw657LJuDBKM8Ifljbg4ZknXfANlv+qDL8wsWDLevPkDyRMfxQ==
X-Received: by 2002:a05:6a20:4ca7:b0:d4:fcb2:7966 with SMTP id fq39-20020a056a204ca700b000d4fcb27966mr9926508pzb.11.1679898441933;
        Sun, 26 Mar 2023 23:27:21 -0700 (PDT)
Received: from localhost ([203.221.180.225])
        by smtp.gmail.com with ESMTPSA id j26-20020aa7929a000000b0062c0c3da6b8sm4253357pfa.13.2023.03.26.23.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Mar 2023 23:27:21 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 27 Mar 2023 16:27:17 +1000
Message-Id: <CRGYAO7K51SR.1XV9XYPSYFFEY@bobo>
Cc:     <linuxppc-dev@lists.ozlabs.org>,
        "Laurent Vivier" <lvivier@redhat.com>
Subject: Re: [kvm-unit-tests v2 07/10] powerpc/spapr_vpa: Add basic VPA
 tests
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.13.0
References: <20230320070339.915172-1-npiggin@gmail.com>
 <20230320070339.915172-8-npiggin@gmail.com>
 <e10767db-95c2-18a2-aa9a-a055844570ac@redhat.com>
In-Reply-To: <e10767db-95c2-18a2-aa9a-a055844570ac@redhat.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri Mar 24, 2023 at 12:07 AM AEST, Thomas Huth wrote:
> On 20/03/2023 08.03, Nicholas Piggin wrote:
> > The VPA is a(n optional) memory structure shared between the hypervisor
> > and operating system, defined by PAPR. This test defines the structure
> > and adds registration, deregistration, and a few simple sanity tests.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   lib/linux/compiler.h    |  2 +
> >   lib/powerpc/asm/hcall.h |  1 +
> >   lib/ppc64/asm/vpa.h     | 62 ++++++++++++++++++++++++++++
> >   powerpc/Makefile.ppc64  |  2 +-
> >   powerpc/spapr_vpa.c     | 90 ++++++++++++++++++++++++++++++++++++++++=
+
>
> Please add the new test to powerpc/unittests.cfg, otherwise it won't get=
=20
> picked up by the run_tests.sh script.

Ah good point.

> > diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
> > index 6f565e4..c9d205e 100644
> > --- a/lib/linux/compiler.h
> > +++ b/lib/linux/compiler.h
> > @@ -45,7 +45,9 @@
> >  =20
> >   #define barrier()	asm volatile("" : : : "memory")
> >  =20
> > +#ifndef __always_inline
> >   #define __always_inline	inline __attribute__((always_inline))
> > +#endif
>
> What's this change good for? ... it doesn't seem to be related to this pa=
tch?

Some header ordering issue I forgot about, thanks for reminding. I think it
should be split it out. See /usr/include/<arch>/sys/cdefs.h:

/* Forces a function to be always inlined.  */
#if __GNUC_PREREQ (3,2) || __glibc_has_attribute (__always_inline__)
/* The Linux kernel defines __always_inline in stddef.h (283d7573), and
   it conflicts with this definition.  Therefore undefine it first to
   allow either header to be included first.  */
# undef __always_inline
# define __always_inline __inline __attribute__ ((__always_inline__))
#else
# undef __always_inline
# define __always_inline __inline
#endif

> > diff --git a/lib/ppc64/asm/vpa.h b/lib/ppc64/asm/vpa.h
> > new file mode 100644
> > index 0000000..11dde01
> > --- /dev/null
> > +++ b/lib/ppc64/asm/vpa.h
> > @@ -0,0 +1,62 @@
> > +#ifndef _ASMPOWERPC_VPA_H_
> > +#define _ASMPOWERPC_VPA_H_
> > +/*
> > + * This work is licensed under the terms of the GNU LGPL, version 2.
> > + */
> > +
> > +#ifndef __ASSEMBLY__
> > +
> > +struct vpa {
> > +	uint32_t	descriptor;
> > +	uint16_t	size;
> > +	uint8_t		reserved1[3];
> > +	uint8_t		status;
>
> Where does this status field come from? ... My LoPAPR only says that ther=
e=20
> are 18 "reserved" bytes in total here.

Hmm, I'm not sure why that was left out of LoPAPR, Linux has been using
it for a long time. It basically just tells you if you are on a
dedicated or shared partition (hard partitioned or timesliced CPUs).
Possibly an oversight.

>
> > +	uint8_t		reserved2[14];
> > +	uint32_t	fru_node_id;
> > +	uint32_t	fru_proc_id;
> > +	uint8_t		reserved3[56];
> > +	uint8_t		vhpn_change_counters[8];
> > +	uint8_t		reserved4[80];
> > +	uint8_t		cede_latency;
> > +	uint8_t		maintain_ebb;
> > +	uint8_t		reserved5[6];
> > +	uint8_t		dtl_enable_mask;
> > +	uint8_t		dedicated_cpu_donate;
> > +	uint8_t		maintain_fpr;
> > +	uint8_t		maintain_pmc;
> > +	uint8_t		reserved6[28];
> > +	uint64_t	idle_estimate_purr;
> > +	uint8_t		reserved7[28];
> > +	uint16_t	maintain_nr_slb;
> > +	uint8_t		idle;
> > +	uint8_t		maintain_vmx;
> > +	uint32_t	vp_dispatch_count;
> > +	uint32_t	vp_dispatch_dispersion;
> > +	uint64_t	vp_fault_count;
> > +	uint64_t	vp_fault_tb;
> > +	uint64_t	purr_exprop_idle;
> > +	uint64_t	spurr_exprop_idle;
> > +	uint64_t	purr_exprop_busy;
> > +	uint64_t	spurr_exprop_busy;
> > +	uint64_t	purr_donate_idle;
> > +	uint64_t	spurr_donate_idle;
> > +	uint64_t	purr_donate_busy;
> > +	uint64_t	spurr_donate_busy;
> > +	uint64_t	vp_wait3_tb;
> > +	uint64_t	vp_wait2_tb;
> > +	uint64_t	vp_wait1_tb;
> > +	uint64_t	purr_exprop_adjunct_busy;
> > +	uint64_t	spurr_exprop_adjunct_busy;
>
> The above two fields are also marked as "reserved" in my LoPAPR ... which=
=20
> version did you use?
>
> > +	uint32_t	supervisor_pagein_count;
> > +	uint8_t		reserved8[4];
> > +	uint64_t	purr_exprop_adjunct_idle;
> > +	uint64_t	spurr_exprop_adjunct_idle;
> > +	uint64_t	adjunct_insns_executed;
>
> dito for the above three lines... I guess my LoPAPR is too old...

Ah, I'm guessing the "adjunct" option isn't relevant to Linux/KVM so it
was probably left out (it's much older than LoPAPR).

Generally LoPAPR is still pretty up to date, but we should do better at
keeping it current IMO. I've made some more noises about that, but
can't make any promises here.

> > +	uint8_t		reserved9[120];
> > +	uint64_t	dtl_index;
> > +	uint8_t		reserved10[96];
> > +};
> > +
> > +#endif /* __ASSEMBLY__ */
> > +
> > +#endif /* _ASMPOWERPC_VPA_H_ */
> > diff --git a/powerpc/Makefile.ppc64 b/powerpc/Makefile.ppc64
> > index ea68447..b0ed2b1 100644
> > --- a/powerpc/Makefile.ppc64
> > +++ b/powerpc/Makefile.ppc64
> > @@ -19,7 +19,7 @@ reloc.o  =3D $(TEST_DIR)/reloc64.o
> >   OBJDIRS +=3D lib/ppc64
> >  =20
> >   # ppc64 specific tests
> > -tests =3D
> > +tests =3D $(TEST_DIR)/spapr_vpa.elf
> >  =20
> >   include $(SRCDIR)/$(TEST_DIR)/Makefile.common
> >  =20
> > diff --git a/powerpc/spapr_vpa.c b/powerpc/spapr_vpa.c
> > new file mode 100644
> > index 0000000..45688fe
> > --- /dev/null
> > +++ b/powerpc/spapr_vpa.c
> > @@ -0,0 +1,90 @@
> > +/*
> > + * Test sPAPR hypervisor calls (aka. h-calls)
>
> Adjust to "Test sPAPR H_REGISTER_VPA hypervisor call" ?

Yes.

> > +	rc =3D hcall(H_REGISTER_VPA, 5ULL << 45, cpuid, vpa);
> > +	report(rc =3D=3D H_SUCCESS, "VPA deregistered");
> > +
> > +	disp_count1 =3D be32_to_cpu(vpa->vp_dispatch_count);
> > +	report(disp_count1 % 2 =3D=3D 1, "Dispatch count is odd after deregis=
ter");
> > +}
>
> Now that was a very tame amount of tests ;-)

Yeah it was just a start. I was going to add a few more scheduling
type ones if I can improve SMP support as well.

> I'd suggest to add some more:
>
> - Check hcall(H_REGISTER_VPA, 0, ...);
> - Check hcall(H_REGISTER_VPA, ..., bad-cpu-id, ...)
> - Check hcall(H_REGISTER_VPA, ..., ..., unaligned-address)
> - Check hcall(H_REGISTER_VPA, ..., ..., illegal-address)
> - Check registration with vpa->size being too small
> - Check registration where the vpa crosses the 4k boundary
>
> What do you think?

Good idea.

> > +int main(int argc, char **argv)
> > +{
> > +	struct vpa *vpa;
> > +
> > +	vpa =3D memalign(4096, sizeof(*vpa));
> > +
> > +	memset(vpa, 0, sizeof(*vpa));
> > +
> > +	vpa->size =3D cpu_to_be16(sizeof(*vpa));
> > +
> > +	report_prefix_push("vpa");
>
> This lacks the corresponding report_prefix_pop() later.

Got it.

Thanks,
Nick
