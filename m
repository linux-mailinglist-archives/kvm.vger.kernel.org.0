Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4059242C55D
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 17:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhJMP4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 11:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhJMP4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 11:56:42 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237D6C061570
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 08:54:39 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id i12so9932105wrb.7
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 08:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=IvDHoUY9BhQi17U9WJUxDlLZ06cpo7RQiFC67gyrf3I=;
        b=T669phQQTQBH1RJdj0YpseAIcFoqIw0PY4zI8V6Ys2ncFxIxeqRv9MGnrLumVV3/OD
         lK9jxwVDBusbhu/aecEkF2SfqZ8P0vCfMdN+1d1W23jXAhvUSSmkBiFweQns4ldsJPVZ
         9W8VjCOkVoB4Kmsk/yj4R6F2dvuvl0JFMhT+q92f+dadDiizqYSc9DToUIjhWUKMac75
         vJUT35FIi5EmzFhclzxCBtbILEPGzzpScxsv9i2DGQqyQWDJCp/smc0HF9PQj7/aBt3b
         MNTScr65hOfyZrBbsbKGPEMwfcpdASPXribp/1vW2coXdiKcJWMSmwmakhTbA55vMCK/
         5xaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=IvDHoUY9BhQi17U9WJUxDlLZ06cpo7RQiFC67gyrf3I=;
        b=Zr8X3EaqDdRHJ0T3dYFdPx/SOYsM+bNgci87FhA3zS/2dKXsSVWiwTorOilIwCNvXg
         33UbRFnRmv2GfqtHTWidQX95qKuPP7D9hGuULn23aTwTpWpbjs86qEQJBOkGk8+WPuwS
         CYSnj6HORRrrDzNWbwZbWT1X3bb/yf8xaUcaT2GZamj8Rg6q6jgYkIi2UtmWcXJXQ0L5
         9pfFmhFe6q04f1ER8DnA1UcwtKBRKAQ86nLjNqrM/woS85GPrPNSXXOuoebKQt1FT4rK
         NsUv4rsXYAfChj6FQKXIcbYEhRDDkfghbMEQYCNLVDyXXcM7oJh7tcIYuoU7EyGer1QZ
         /o4A==
X-Gm-Message-State: AOAM532vSvwR+SSbwNhzKNb5NlTi9Q5VoQray0MSYpvLFMjIfvZi3257
        A9kYm2+iTfE4OFdx6QjUi9l1Jg==
X-Google-Smtp-Source: ABdhPJyCDBkH+27Z3bSZRNojps5faKc3fRCQiqD1B/nADTxMyAINih0lJ3CWCGAwX7XTNLM5Vh3rYQ==
X-Received: by 2002:adf:a152:: with SMTP id r18mr41747437wrr.317.1634140477645;
        Wed, 13 Oct 2021 08:54:37 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id u5sm5462093wmm.39.2021.10.13.08.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 08:54:36 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 1FBF61FF96;
        Wed, 13 Oct 2021 16:54:36 +0100 (BST)
References: <20210914155214.105415-1-mlevitsk@redhat.com>
 <20210914155214.105415-3-mlevitsk@redhat.com>
User-agent: mu4e 1.7.0; emacs 28.0.60
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     qemu-devel@nongnu.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] gdbstub: implement NOIRQ support for single step on
 KVM
Date:   Wed, 13 Oct 2021 16:50:39 +0100
In-reply-to: <20210914155214.105415-3-mlevitsk@redhat.com>
Message-ID: <87v920vs1v.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Maxim Levitsky <mlevitsk@redhat.com> writes:

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  accel/kvm/kvm-all.c  | 25 ++++++++++++++++++
>  gdbstub.c            | 60 ++++++++++++++++++++++++++++++++++++--------
>  include/sysemu/kvm.h | 13 ++++++++++
>  3 files changed, 88 insertions(+), 10 deletions(-)
>
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 6b187e9c96..e141260796 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -169,6 +169,8 @@ bool kvm_vm_attributes_allowed;
>  bool kvm_direct_msi_allowed;
>  bool kvm_ioeventfd_any_length_allowed;
>  bool kvm_msi_use_devid;
> +bool kvm_has_guest_debug;
> +int kvm_sstep_flags;
>  static bool kvm_immediate_exit;
>  static hwaddr kvm_max_slot_size =3D ~0;
>=20=20
> @@ -2559,6 +2561,25 @@ static int kvm_init(MachineState *ms)
>      kvm_sregs2 =3D
>          (kvm_check_extension(s, KVM_CAP_SREGS2) > 0);
>=20=20
> +    kvm_has_guest_debug =3D
> +        (kvm_check_extension(s, KVM_CAP_SET_GUEST_DEBUG) > 0);
> +
> +    kvm_sstep_flags =3D 0;
> +
> +    if (kvm_has_guest_debug) {
> +        /* Assume that single stepping is supported */
> +        kvm_sstep_flags =3D SSTEP_ENABLE;
> +
> +        int guest_debug_flags =3D
> +            kvm_check_extension(s, KVM_CAP_SET_GUEST_DEBUG2);
> +
> +        if (guest_debug_flags > 0) {
> +            if (guest_debug_flags & KVM_GUESTDBG_BLOCKIRQ) {
> +                kvm_sstep_flags |=3D SSTEP_NOIRQ;
> +            }
> +        }
> +    }
> +
>      kvm_state =3D s;
>=20=20
>      ret =3D kvm_arch_init(ms, s);
> @@ -3188,6 +3209,10 @@ int kvm_update_guest_debug(CPUState *cpu, unsigned=
 long reinject_trap)
>=20=20
>      if (cpu->singlestep_enabled) {
>          data.dbg.control |=3D KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_SINGLES=
TEP;
> +
> +        if (cpu->singlestep_enabled & SSTEP_NOIRQ) {
> +            data.dbg.control |=3D KVM_GUESTDBG_BLOCKIRQ;
> +        }
>      }
>      kvm_arch_update_guest_debug(cpu, &data.dbg);
>=20=20
> diff --git a/gdbstub.c b/gdbstub.c
> index 5d8e6ae3cd..48bb803bae 100644
> --- a/gdbstub.c
> +++ b/gdbstub.c
> @@ -368,12 +368,11 @@ typedef struct GDBState {
>      gdb_syscall_complete_cb current_syscall_cb;
>      GString *str_buf;
>      GByteArray *mem_buf;
> +    int sstep_flags;
> +    int supported_sstep_flags;
>  } GDBState;
>=20=20
> -/* By default use no IRQs and no timers while single stepping so as to
> - * make single stepping like an ICE HW step.
> - */
> -static int sstep_flags =3D SSTEP_ENABLE|SSTEP_NOIRQ|SSTEP_NOTIMER;
> +static GDBState gdbserver_state;
>=20=20
>  /* Retrieves flags for single step mode. */
>  static int get_sstep_flags(void)
> @@ -385,11 +384,10 @@ static int get_sstep_flags(void)
>      if (replay_mode !=3D REPLAY_MODE_NONE) {
>          return SSTEP_ENABLE;
>      } else {
> -        return sstep_flags;
> +        return gdbserver_state.sstep_flags;
>      }
>  }
>=20=20
> -static GDBState gdbserver_state;
>=20=20
>  static void init_gdbserver_state(void)
>  {
> @@ -399,6 +397,23 @@ static void init_gdbserver_state(void)
>      gdbserver_state.str_buf =3D g_string_new(NULL);
>      gdbserver_state.mem_buf =3D g_byte_array_sized_new(MAX_PACKET_LENGTH=
);
>      gdbserver_state.last_packet =3D g_byte_array_sized_new(MAX_PACKET_LE=
NGTH + 4);
> +
> +
> +    if (kvm_enabled()) {
> +        gdbserver_state.supported_sstep_flags =3D kvm_get_supported_sste=
p_flags();
> +    } else {
> +        gdbserver_state.supported_sstep_flags =3D
> +            SSTEP_ENABLE | SSTEP_NOIRQ | SSTEP_NOTIMER;
> +    }

This fails to build:

o -c ../../gdbstub.c
../../gdbstub.c: In function =E2=80=98init_gdbserver_state=E2=80=99:
../../gdbstub.c:403:49: error: implicit declaration of function =E2=80=98kv=
m_get_supported_sstep_flags=E2=80=99 [-Werror=3Dimplicit-function-declarati=
on]
  403 |         gdbserver_state.supported_sstep_flags =3D kvm_get_supported=
_sstep_flags();
      |                                                 ^~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~
../../gdbstub.c:403:49: error: nested extern declaration of =E2=80=98kvm_ge=
t_supported_sstep_flags=E2=80=99 [-Werror=3Dnested-externs]
../../gdbstub.c: In function =E2=80=98gdbserver_start=E2=80=99:
../../gdbstub.c:3531:27: error: implicit declaration of function =E2=80=98k=
vm_supports_guest_debug=E2=80=99; did you mean =E2=80=98kvm_update_guest_de=
bug=E2=80=99? [-Werror=3Dimplicit-function-declaration]
 3531 |     if (kvm_enabled() && !kvm_supports_guest_debug()) {
      |                           ^~~~~~~~~~~~~~~~~~~~~~~~
      |                           kvm_update_guest_debug
../../gdbstub.c:3531:27: error: nested extern declaration of =E2=80=98kvm_s=
upports_guest_debug=E2=80=99 [-Werror=3Dnested-externs]
cc1: all warnings being treated as errors

In fact looking back I can see I mentioned this last time:

  Subject: Re: [PATCH 2/2] gdbstub: implement NOIRQ support for single step=
 on
   KVM, when kvm's KVM_GUESTDBG_BLOCKIRQ debug flag is supported.
  Date: Mon, 19 Apr 2021 17:29:25 +0100
  In-reply-to: <20210401144152.1031282-3-mlevitsk@redhat.com>
  Message-ID: <871rb69qqk.fsf@linaro.org>

Please in future could you include a revision number for your spin and
mention bellow the --- what changes have been made since the last
posting.


--=20
Alex Benn=C3=A9e
