Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 341CCD7BD8
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388102AbfJOQhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:37:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41008 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388021AbfJOQhp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:37:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571157464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=1jEbQ5iqOThUFULFTyIFEug52/ZAJJCm7u+tNv/e0Pk=;
        b=eAy7IcvHZyJZgNteHAkya8+rdSXPrC4gFj0wpf9kWa5zrm1CjPK+zzAIruK9G7UVZ/F12o
        DPKGqr8kmnRbdmT147jvloYoExZ+n7p1f/P8/r9YOfDcrgKxNnq2i+OJjJ45jt/e+h2tin
        4ITMZ+kTQJGya8Zw5srolvIWmN11C3Q=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-FFRe9v7EMJ-LFJZXKCUazQ-1; Tue, 15 Oct 2019 12:37:40 -0400
Received: by mail-wm1-f72.google.com with SMTP id j125so8904250wmj.6
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 09:37:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/afoUvKJ/G8ziRnWqBlZqbL4cc1xk25yfAVgZZ9J6P4=;
        b=Veekrd/Z8OqClcDvHQdvuifSrtHo1EQdFE7er5bp2aitOyu1wj1u/rwod3bhTp/tRr
         riTOg1DL5GQwzBmLgRDpCqEg8rYS1wOLplPgCWHgYTKx3kYVpmwAb2L+XOh8GZsOA39A
         H3bOwbdRbhOjXLe7mFdZbVjSyRPSRKd1FM598OM09uuKQdkrFN7Ww0o7S2gVvCpd/dus
         FhYGh2wZdLPtmSr0MtUjso7qkS1IDGfLxq8Tt2hHrqVhDCRqIh1+L1QpnAIyM0btXarO
         jUqB9BTiBTtksBzxKfsEtYM3E6yR9hZWPfyGMbMvXKlZffn45/UVzk2Bp0523XuWE9fK
         eO3w==
X-Gm-Message-State: APjAAAWGsIfxfchHhc0H9/+XwvQt5D2aHA9Uf+5yI6GSqhtzMKJTfG7D
        XTirpHH5Cpk2jhljAR7t6x6MPUGKTojMeaOMBzCn3smqY+zlq5ahZ83YISGbSJOil2QUDWYDB/z
        dt7059bDcdXX4
X-Received: by 2002:a5d:4108:: with SMTP id l8mr30326077wrp.391.1571157459639;
        Tue, 15 Oct 2019 09:37:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxipARbWgSrbXCwl1TEPdWRJHBQlN9VqVPvaKOq4EkdjYSYjz5KQDey2GKDwlfZaBSNuv9Oqg==
X-Received: by 2002:a5d:4108:: with SMTP id l8mr30326034wrp.391.1571157459287;
        Tue, 15 Oct 2019 09:37:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d001:591b:c73b:6c41? ([2001:b07:6468:f312:d001:591b:c73b:6c41])
        by smtp.gmail.com with ESMTPSA id r65sm26602863wmr.9.2019.10.15.09.37.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2019 09:37:38 -0700 (PDT)
Subject: Re: [PATCH v5 3/6] timekeeping: Add clocksource to
 system_time_snapshot
To:     Jianyong Wu <jianyong.wu@arm.com>, netdev@vger.kernel.org,
        yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        nd@arm.com
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-4-jianyong.wu@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9274d21c-2c43-2e0d-f086-6aaba3863603@redhat.com>
Date:   Tue, 15 Oct 2019 18:37:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015104822.13890-4-jianyong.wu@arm.com>
Content-Language: en-US
X-MC-Unique: FFRe9v7EMJ-LFJZXKCUazQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/19 12:48, Jianyong Wu wrote:
> Sometimes, we need check current clocksource outside of
> timekeeping area. Add clocksource to system_time_snapshot then
> we can get clocksource as well as system time.
>=20
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  include/linux/timekeeping.h | 35 ++++++++++++++++++-----------------
>  kernel/time/timekeeping.c   |  7 ++++---
>  2 files changed, 22 insertions(+), 20 deletions(-)
>=20
> diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
> index a8ab0f143ac4..964c14fbbf69 100644
> --- a/include/linux/timekeeping.h
> +++ b/include/linux/timekeeping.h
> @@ -194,23 +194,6 @@ extern bool timekeeping_rtc_skipresume(void);
> =20
>  extern void timekeeping_inject_sleeptime64(const struct timespec64 *delt=
a);
> =20
> -/*
> - * struct system_time_snapshot - simultaneous raw/real time capture with
> - *=09counter value
> - * @cycles:=09Clocksource counter value to produce the system times
> - * @real:=09Realtime system time
> - * @raw:=09Monotonic raw system time
> - * @clock_was_set_seq:=09The sequence number of clock was set events
> - * @cs_was_changed_seq:=09The sequence number of clocksource change even=
ts
> - */
> -struct system_time_snapshot {
> -=09u64=09=09cycles;
> -=09ktime_t=09=09real;
> -=09ktime_t=09=09raw;
> -=09unsigned int=09clock_was_set_seq;
> -=09u8=09=09cs_was_changed_seq;
> -};
> -
>  /*
>   * struct system_device_crosststamp - system/device cross-timestamp
>   *=09(syncronized capture)
> @@ -236,6 +219,24 @@ struct system_counterval_t {
>  =09struct clocksource=09*cs;
>  };
> =20
> +/*
> + * struct system_time_snapshot - simultaneous raw/real time capture with
> + *=09counter value
> + * @sc:=09=09Contains clocksource and clocksource counter value to produ=
ce
> + * =09the system times
> + * @real:=09Realtime system time
> + * @raw:=09Monotonic raw system time
> + * @clock_was_set_seq:=09The sequence number of clock was set events
> + * @cs_was_changed_seq:=09The sequence number of clocksource change even=
ts
> + */
> +struct system_time_snapshot {
> +=09struct system_counterval_t sc;
> +=09ktime_t=09=09real;
> +=09ktime_t=09=09raw;
> +=09unsigned int=09clock_was_set_seq;
> +=09u8=09=09cs_was_changed_seq;
> +};
> +
>  /*
>   * Get cross timestamp between system clock and device clock
>   */
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 44b726bab4bd..66ff089605b3 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -983,7 +983,8 @@ void ktime_get_snapshot(struct system_time_snapshot *=
systime_snapshot)
>  =09=09nsec_raw  =3D timekeeping_cycles_to_ns(&tk->tkr_raw, now);
>  =09} while (read_seqcount_retry(&tk_core.seq, seq));
> =20
> -=09systime_snapshot->cycles =3D now;
> +=09systime_snapshot->sc.cycles =3D now;
> +=09systime_snapshot->sc.cs =3D tk->tkr_mono.clock;
>  =09systime_snapshot->real =3D ktime_add_ns(base_real, nsec_real);
>  =09systime_snapshot->raw =3D ktime_add_ns(base_raw, nsec_raw);
>  }
> @@ -1189,12 +1190,12 @@ int get_device_system_crosststamp(int (*get_time_=
fn)
>  =09=09 * clocksource change
>  =09=09 */
>  =09=09if (!history_begin ||
> -=09=09    !cycle_between(history_begin->cycles,
> +=09=09    !cycle_between(history_begin->sc.cycles,
>  =09=09=09=09   system_counterval.cycles, cycles) ||
>  =09=09    history_begin->cs_was_changed_seq !=3D cs_was_changed_seq)
>  =09=09=09return -EINVAL;
>  =09=09partial_history_cycles =3D cycles - system_counterval.cycles;
> -=09=09total_history_cycles =3D cycles - history_begin->cycles;
> +=09=09total_history_cycles =3D cycles - history_begin->sc.cycles;
>  =09=09discontinuity =3D
>  =09=09=09history_begin->clock_was_set_seq !=3D clock_was_set_seq;
> =20
>=20

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

