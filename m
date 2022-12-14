Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27AA64CC07
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 15:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238646AbiLNOU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 09:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238371AbiLNOUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 09:20:14 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1500A275FF
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 06:20:13 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id h7so19461233wrs.6
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 06:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u1P70EdD+qBRmVwgXdO5YigM5hOFFdXEeoos/dpjT0Q=;
        b=MJAeytxdObkVdms2wupotqC9KaYOWnzwIjqiL5ZVYJiUZ7xHp/a96oHh47hLZXgoHP
         YDzpSu23VwKKT/i8SNdsUrmrCg12qewG7NJnOPKLB6XaJJRTVD7mi0aV3un33mwVvjFN
         dpgTAsRtAg2UQksrTLObVgrmtbBcylEmFhGl2QvmiC0D8igPc8tWDVKxhOF88jqtzNFN
         wvNeiUyVlEiybgNt+mIxjaBqyjxD01dndki/pJfb8o+WyRJ9641dBlwx8vUHszUhQisW
         6Lb/UccO1v/qZZMn6ZRxZ9Y3FvnZCiYCaXh/yduu5Bj7ZxfZ0DqTtZgyAaLjgVQhXKaH
         U9aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u1P70EdD+qBRmVwgXdO5YigM5hOFFdXEeoos/dpjT0Q=;
        b=06WTPq937tfuNifi/+Bg5cJ1uegHNv2hMS/81mnLnm1k08AfwOC4DJOzQ84SzuwfNk
         hz3PeKq4WkWglNkr6OgqlZCl4BsJ3q4jcEwVYGzPZb/dgQF2FBbJT90LVCSdkDn4cdRx
         aDMrERNQbxgTlpGAJne0ZoMy6VVEuKGJs0IlL27F3sHdYcLhmuBbLGy9yufsFO3N7vFe
         4AxDurQjlIDVY404QqmH9gHJrNu0weDHtQ5d80fivRO8q1xtEFVkGNRrFqCMBrLBrG72
         KBoUZOmf85hvU7FrE4716A9cRzFhZ8rEKA4oMquzP89pXj4YggSduAs5ncGZLeDxWash
         rPMQ==
X-Gm-Message-State: ANoB5pk3Wtklrk7e0wcpe7DAOL2T0XQ9O/wyvzhqQyBnSPIQxTAJxCz0
        sLOx0oNMkvK2fzecnQUKto2cUg==
X-Google-Smtp-Source: AA0mqf55diIFDr3LDTdokwnLeeU3Z/OEdqKNnnolAVjaTrRRhIrqqyq3QoUrlb5NPKAiW2b0x8yliw==
X-Received: by 2002:a05:6000:910:b0:236:61bb:c79b with SMTP id bz16-20020a056000091000b0023661bbc79bmr17549749wrb.3.1671027611562;
        Wed, 14 Dec 2022 06:20:11 -0800 (PST)
Received: from zen.linaroharston ([185.81.254.11])
        by smtp.gmail.com with ESMTPSA id k16-20020a5d6290000000b00241cbb7f15csm2910958wru.106.2022.12.14.06.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 06:20:11 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 8F6431FFB7;
        Wed, 14 Dec 2022 14:20:10 +0000 (GMT)
References: <20221123121712.72817-1-mads@ynddal.dk>
 <af92080f-e708-f593-7ff5-81b7b264d587@linaro.org>
 <C8BC6E24-F98D-428D-80F8-98BDA40C7B15@ynddal.dk>
User-agent: mu4e 1.9.6; emacs 29.0.60
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Mads Ynddal <mads@ynddal.dk>
Cc:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH] gdbstub: move update guest debug to accel ops
Date:   Wed, 14 Dec 2022 14:16:47 +0000
In-reply-to: <C8BC6E24-F98D-428D-80F8-98BDA40C7B15@ynddal.dk>
Message-ID: <87h6xyjcdh.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Mads Ynddal <mads@ynddal.dk> writes:

>> Isn't this '0' flag here accelerator-specific? ...
>
>> ... if so the prototype should be:
>>=20
>>       int (*update_guest_debug)(CPUState *cpu);
>>=20
>> and the '0' value set within kvm-accel-ops.c handler implementation.
>>=20
>
> You're right, we can avoid the additional variable. We'll then have to wr=
ap
> `kvm_update_guest_debug`. Would the following be ok?
>
> diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
> index 6ebf9a644f..5e0fb42408 100644
> --- a/accel/kvm/kvm-accel-ops.c
> +++ b/accel/kvm/kvm-accel-ops.c
> @@ -86,6 +86,10 @@ static bool kvm_cpus_are_resettable(void)
>      return !kvm_enabled() || kvm_cpu_check_are_resettable();
>  }
>=20=20
> +static int kvm_update_guest_debug_ops(CPUState *cpu) {
> +    return kvm_update_guest_debug(cpu, 0);
> +}
> +
>  static void kvm_accel_ops_class_init(ObjectClass *oc, void *data)
>  {
>      AccelOpsClass *ops =3D ACCEL_OPS_CLASS(oc);
> @@ -99,7 +103,7 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, =
void *data)
>      ops->synchronize_pre_loadvm =3D kvm_cpu_synchronize_pre_loadvm;
>=20=20
>  #ifdef KVM_CAP_SET_GUEST_DEBUG
> -    ops->update_guest_debug =3D kvm_update_guest_debug;
> +    ops->update_guest_debug =3D kvm_update_guest_debug_ops;
>      ops->supports_guest_debug =3D kvm_supports_guest_debug;
>      ops->insert_breakpoint =3D kvm_insert_breakpoint;
>      ops->remove_breakpoint =3D kvm_remove_breakpoint;
> diff --git a/cpu.c b/cpu.c
> index ef433a79e3..b2ade96caa 100644
> --- a/cpu.c
> +++ b/cpu.c
> @@ -383,7 +383,7 @@ void cpu_single_step(CPUState *cpu, int enabled)
>          cpu->singlestep_enabled =3D enabled;
>=20=20
>          if (ops->update_guest_debug) {
> -            ops->update_guest_debug(cpu, 0);
> +            ops->update_guest_debug(cpu);
>          }
>=20=20
>          trace_breakpoint_singlestep(cpu->cpu_index, enabled);
> diff --git a/include/sysemu/accel-ops.h b/include/sysemu/accel-ops.h
> index 0a47a2f00c..cd6a4ef7a5 100644
> --- a/include/sysemu/accel-ops.h
> +++ b/include/sysemu/accel-ops.h
> @@ -48,7 +48,7 @@ struct AccelOpsClass {
>=20=20
>      /* gdbstub hooks */
>      bool (*supports_guest_debug)(void);
> -    int (*update_guest_debug)(CPUState *cpu, unsigned long flags);
> +    int (*update_guest_debug)(CPUState *cpu);
>      int (*insert_breakpoint)(CPUState *cpu, int type, hwaddr addr, hwadd=
r len);
>      int (*remove_breakpoint)(CPUState *cpu, int type, hwaddr addr, hwadd=
r len);
>      void (*remove_all_breakpoints)(CPUState *cpu);
>
>
> If you have a better name for `kvm_update_guest_debug_ops`, I'm open for
> suggestions.

It will do. You could just call it update_guest_debug as it is an
internal static function although I guess that makes grepping a bit of a
pain.

> On a side note. When compiling for an arch that isn't the same as the sys=
tem
> (i.e. aarch64 on x86_64), I'm getting a linker-error for cpu.c that
> `cpus_get_accel` isn't defined. Do I need to move `cpus_get_accel` or som=
ehow
> #ifdef its use?

Is something being accidentally linked with linux-user and softmmu?

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
