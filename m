Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9CB77B65F5
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 12:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239835AbjJCKAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 06:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239782AbjJCKAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 06:00:01 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A319A91;
        Tue,  3 Oct 2023 02:59:58 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1c3bd829b86so5451065ad.0;
        Tue, 03 Oct 2023 02:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696327198; x=1696931998; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7mfj166RZXa6+OGlC23mV90s8HoMj5oVIl7zgyFgTFU=;
        b=H5pXYzVKJ1cluuOdb6AzUVrEXCvkaWBzOpmca0uk5N55iZ4vdfEjt5Pqg3U4hUXfUh
         k0BE9clJEXJclFb6rs0iBJk3Lfm+mxF1wQYieUdwZNxaa/c7sF1p70UvDDOPCS4KeUbu
         mEhSLN6plucjtGDRvTRmRTpTKkFbq7fhkEXmXf9ios1Z/kS1iTy4G6/FPuIJRVDpJkIK
         3IgcFyyY3Vd/qgW9teFdF9q3SC2PPAFqZgWTxUTAt8Wg09/bG6RawnmlmOHQVlNVUq1t
         VUxEJrkvdfDXxW4zXcKKKq/z8+Qr0pWZt/q1ys0Yv0ndqdBP+BFDu09h7w/ZR8ddArqL
         4A8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696327198; x=1696931998;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7mfj166RZXa6+OGlC23mV90s8HoMj5oVIl7zgyFgTFU=;
        b=NXjpIHWUwIMVFX0NqvhwrNBbVHFjVwtzz6ijJcIvnt5K0dE7q7loW3vOTjhXFqnQKc
         zLP8y+W3fEPXKL7FUi1/hcHzUVJ482q6vMZaQqE7FJOwWDw0ZYerGAjWW9L2c842hIIj
         Nn7Wk/y4ZZy08h4HAmzOc/Dqu8buv26P24MKq2W0er+RI7G4sCvyCbbwgsoTDGmBFnWI
         d+/D07qZrlcmNelPEthdDnxjlntYgTu5Y50K2B7TsMy97+gP4sGSUmSiEqurfahbTqjx
         Gb9yhqC3LCsfrlguBHNFITzog2UnVg9wm0As9+BbqKQe9Gr6CACn9q3H7jgc8Gx4owVm
         Da5g==
X-Gm-Message-State: AOJu0YyKJuNf7c3avwY2A7GEHiUBRKvGWOVaMThIh9mSFJbsZM5q/+6v
        oNz69SvU3kju2P2hvd1F5GI=
X-Google-Smtp-Source: AGHT+IEcFB0/Nf7z2acAywtjf22FDYWrA9IDkrD58mbuzHGOwLkPwm0grCEuAMx9zkt09wQq3hfj/Q==
X-Received: by 2002:a17:902:d2cb:b0:1c4:fae:bf28 with SMTP id n11-20020a170902d2cb00b001c40faebf28mr14401254plc.32.1696327197979;
        Tue, 03 Oct 2023 02:59:57 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id u9-20020a17090341c900b001c1f161949fsm1088243ple.96.2023.10.03.02.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 02:59:57 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id CEF7581193F1; Tue,  3 Oct 2023 16:59:52 +0700 (WIB)
Date:   Tue, 3 Oct 2023 16:59:52 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Xin Li <xin3.li@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com, nik.borisov@suse.com
Subject: Re: [PATCH v12 06/37] Documentation/x86/64: Add a documentation for
 FRED
Message-ID: <ZRvmGNRZ4IvmguAY@debian.me>
References: <20231003062458.23552-1-xin3.li@intel.com>
 <20231003062458.23552-7-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="LN8xCBDRRuLQePIA"
Content-Disposition: inline
In-Reply-To: <20231003062458.23552-7-xin3.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--LN8xCBDRRuLQePIA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 02, 2023 at 11:24:27PM -0700, Xin Li wrote:
> diff --git a/Documentation/arch/x86/x86_64/fred.rst b/Documentation/arch/=
x86/x86_64/fred.rst
> new file mode 100644
> index 000000000000..9f57e7b91f7e
> --- /dev/null
> +++ b/Documentation/arch/x86/x86_64/fred.rst
> @@ -0,0 +1,96 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Flexible Return and Event Delivery (FRED)
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Overview
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The FRED architecture defines simple new transitions that change
> +privilege level (ring transitions). The FRED architecture was
> +designed with the following goals:
> +
> +1) Improve overall performance and response time by replacing event
> +   delivery through the interrupt descriptor table (IDT event
> +   delivery) and event return by the IRET instruction with lower
> +   latency transitions.
> +
> +2) Improve software robustness by ensuring that event delivery
> +   establishes the full supervisor context and that event return
> +   establishes the full user context.
> +
> +The new transitions defined by the FRED architecture are FRED event
> +delivery and, for returning from events, two FRED return instructions.
> +FRED event delivery can effect a transition from ring 3 to ring 0, but
> +it is used also to deliver events incident to ring 0. One FRED
> +instruction (ERETU) effects a return from ring 0 to ring 3, while the
> +other (ERETS) returns while remaining in ring 0. Collectively, FRED
> +event delivery and the FRED return instructions are FRED transitions.
> +
> +In addition to these transitions, the FRED architecture defines a new
> +instruction (LKGS) for managing the state of the GS segment register.
> +The LKGS instruction can be used by 64-bit operating systems that do
> +not use the new FRED transitions.
> +
> +Furthermore, the FRED architecture is easy to extend for future CPU
> +architectures.
> +
> +Software based event dispatching
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +FRED operates differently from IDT in terms of event handling. Instead
> +of directly dispatching an event to its handler based on the event
> +vector, FRED requires the software to dispatch an event to its handler
> +based on both the event's type and vector. Therefore, an event dispatch
> +framework must be implemented to facilitate the event-to-handler
> +dispatch process. The FRED event dispatch framework takes control
> +once an event is delivered, and employs a two-level dispatch.
> +
> +The first level dispatching is event type based, and the second level
> +dispatching is event vector based.
> +
> +Full supervisor/user context
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> +
> +FRED event delivery atomically save and restore full supervisor/user
> +context upon event delivery and return. Thus it avoids the problem of
> +transient states due to %cr2 and/or %dr6, and it is no longer needed
> +to handle all the ugly corner cases caused by half baked entry states.
> +
> +FRED allows explicit unblock of NMI with new event return instructions
> +ERETS/ERETU, avoiding the mess caused by IRET which unconditionally
> +unblocks NMI, e.g., when an exception happens during NMI handling.
> +
> +FRED always restores the full value of %rsp, thus ESPFIX is no longer
> +needed when FRED is enabled.
> +
> +LKGS
> +=3D=3D=3D=3D
> +
> +LKGS behaves like the MOV to GS instruction except that it loads the
> +base address into the IA32_KERNEL_GS_BASE MSR instead of the GS
> +segment=E2=80=99s descriptor cache. With LKGS, it ends up with avoiding
> +mucking with kernel GS, i.e., an operating system can always operate
> +with its own GS base address.
> +
> +Because FRED event delivery from ring 3 and ERETU both swap the value
> +of the GS base address and that of the IA32_KERNEL_GS_BASE MSR, plus
> +the introduction of LKGS instruction, the SWAPGS instruction is no
> +longer needed when FRED is enabled, thus is disallowed (#UD).
> +
> +Stack levels
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +4 stack levels 0~3 are introduced to replace the nonreentrant IST for
> +event handling, and each stack level should be configured to use a
> +dedicated stack.
> +
> +The current stack level could be unchanged or go higher upon FRED
> +event delivery. If unchanged, the CPU keeps using the current event
> +stack. If higher, the CPU switches to a new event stack specified by
> +the MSR of the new stack level, i.e., MSR_IA32_FRED_RSP[123].
> +
> +Only execution of a FRED return instruction ERET[US], could lower the
> +current stack level, causing the CPU to switch back to the stack it was
> +on before a previous event delivery that promoted the stack level.

LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--LN8xCBDRRuLQePIA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZRvmEwAKCRD2uYlJVVFO
o5qOAQDw8M+2297q5X5j+JlTjJmKURsOh0vN4+TkT6xGTw1/oAEA7lexKTaNoRJm
dwxTvxrQ6FWCfYMKDNZLsLpxSIwB3AQ=
=e3m/
-----END PGP SIGNATURE-----

--LN8xCBDRRuLQePIA--
