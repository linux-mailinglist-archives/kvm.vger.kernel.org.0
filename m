Return-Path: <kvm+bounces-52431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C28DB05245
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 08:57:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9AEA3174FC0
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 06:57:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B02926CE17;
	Tue, 15 Jul 2025 06:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="BQLK6C9r"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB731D5ABA
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 06:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752562654; cv=none; b=EAt/aV+v+ce4C3PPcVuU9ivwGZN16mkVt6dmfWkWbSQtSwEMKF6MvAz6l+E80Kzng49PAzwPSB1AiXF8sTjDaGItKpR/TYlsPfgYtnJqtSaIiCv4j5RDEz1qvd5MnXap3XjJSC0QnZn9KjXaIGPzLhp2NZbaIkgZ38e5gPyapNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752562654; c=relaxed/simple;
	bh=g2L/c+xN1mSFLRm4kIwEVzemEkHJuL3gQ8ZT1hpsJkU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hYq+uksyZrC0vwVUYDNZaJGaaSHqQQ7Ull+DrEx5q7/KNn37gX8BUvJyjMQ4hpX+imzi+H7DbmVmdG1LaM/mNNhnvzY7ugsqwkciBN2lqihj6y2pkVTpMmZyCqTmrCYaig912w9oLZ+G2CrAgELr6T4qGTmru4kCtc9+lLuKsKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=BQLK6C9r reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from [10.105.8.218] ([192.51.222.130])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 56F6vTWF005302
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 15 Jul 2025 15:57:30 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=+bRDBcd027Jl6j1IgelOV9GiK3y3UJWJS2DK8YOHsAM=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250326; t=1752562650; v=1;
        b=BQLK6C9rsZpWo331xiT2pSN9EMbOuae58KK85aevbWlNWJrpeCajiaakguxSMhO8
         9++UckJbs4ZuGFwXk7r4FY5HjCmETFriM1hrltVfD4/lrK/7wh3Nzo9vYej9GO1j
         C06u7u5k4nTxAoKqFJYavfGI4QbPUis0YRh7L+KM/dF7jg31NtfMDammRE+/O+j0
         3JE6Kn6yAChPuS1i/3htsOq6wlHtYOx10eyngguYzokpERUkWA7C3bfptI+NpKPl
         N33IoWbRANMiSzwNeqR21Usa3HFVcWGhMiKSoeVvw3fXs3yfSiFijsD5iSN/rK/Q
         zvT+/p9aSn/o33xQ7oLWeA==
Message-ID: <45e600c7-90f4-4daa-a68b-8da90758b861@rsg.ci.i.u-tokyo.ac.jp>
Date: Tue, 15 Jul 2025 15:57:29 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 03/13] virtio: introduce extended features type
To: Paolo Abeni <pabeni@redhat.com>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Jason Wang
 <jasowang@redhat.com>,
        Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, Luigi Rizzo <lrizzo@google.com>,
        Giuseppe Lettieri
 <g.lettieri@iet.unipi.it>,
        Vincenzo Maffione <v.maffione@gmail.com>,
        Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
        kvm@vger.kernel.org
References: <cover.1752229731.git.pabeni@redhat.com>
 <8c179f9cd04d6cb5e6f822203c6a057704133386.1752229731.git.pabeni@redhat.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <8c179f9cd04d6cb5e6f822203c6a057704133386.1752229731.git.pabeni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/07/11 22:02, Paolo Abeni wrote:
> The virtio specifications allows for up to 128 bits for the
> device features. Soon we are going to use some of the 'extended'
> bits features (above 64) for the virtio net driver.
> 
> Represent the virtio features bitmask with a fixes size array, and
> introduce a few helpers to help manipulate them.
> 
> Most drivers will keep using only 64 bits features space: use union
> to allow them access the lower part of the extended space without any
> per driver change.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> v1 -> v2:
>    - use a fixed size array for features instead of uint128
>    - use union with u64 to reduce the needed code churn
> ---
>   include/hw/virtio/virtio-features.h | 124 ++++++++++++++++++++++++++++
>   include/hw/virtio/virtio.h          |   7 +-
>   2 files changed, 128 insertions(+), 3 deletions(-)
>   create mode 100644 include/hw/virtio/virtio-features.h
> 
> diff --git a/include/hw/virtio/virtio-features.h b/include/hw/virtio/virtio-features.h
> new file mode 100644
> index 0000000000..cc735f7f81
> --- /dev/null
> +++ b/include/hw/virtio/virtio-features.h
> @@ -0,0 +1,124 @@
> +/*
> + * Virtio features helpers
> + *
> + * Copyright 2025 Red Hat, Inc.
> + *
> + * SPDX-License-Identifier: GPL-2.0-or-later
> + */
> +
> +#ifndef _QEMU_VIRTIO_FEATURES_H
> +#define _QEMU_VIRTIO_FEATURES_H

An identifier prefixed with an underscore and a capital letter is 
reserved and better to avoid. Let's also keep consistent with QEMU_VIRTIO_H.

> +
> +#define VIRTIO_FEATURES_FMT        "%016"PRIx64"%016"PRIx64
> +#define VIRTIO_FEATURES_PR(f)      f[1], f[0]
> +
> +#define VIRTIO_FEATURES_MAX        128
> +#define VIRTIO_BIT(b)              (1ULL << (b & 0x3f))

Let's use BIT_ULL().

I also think (b % 64) is easier to understand than (b & 0x3f); you may 
refer to BIT_MASK() and BIT_WORD() as prior examples.

> +#define VIRTIO_DWORD(b)            ((b) >> 6)

VIRTIO_FEATURES_PR() and VIRTIO_BIT() should have parentheses around 
their parameters as VIRTIO_DWORD() does.

> +#define VIRTIO_FEATURES_WORDS     (VIRTIO_FEATURES_MAX >> 5)

This macro is misaligned; personally I prefer just use one whitespace to 
delimit the macro name and value to avoid the trouble of aligning them 
and polluting "git blame".

> +#define VIRTIO_FEATURES_DWORDS      (VIRTIO_FEATURES_WORDS >> 1)
> +
> +#define VIRTIO_DECLARE_FEATURES(name)                        \
> +    union {                                                  \
> +        uint64_t name;                                       \
> +        uint64_t name##_array[VIRTIO_FEATURES_DWORDS];       \
> +    }
> +
> +static inline void virtio_features_clear(uint64_t *features)
> +{
> +    memset(features, 0, sizeof(features[0]) * VIRTIO_FEATURES_DWORDS);
> +}
> +
> +static inline void virtio_features_from_u64(uint64_t *features, uint64_t from)
> +{
> +    virtio_features_clear(features);
> +    features[0] = from;
> +}
> +
> +static inline bool virtio_has_feature_ex(const uint64_t *features,
> +                                         unsigned int fbit)
> +{
> +    assert(fbit < VIRTIO_FEATURES_MAX);
> +    return features[VIRTIO_DWORD(fbit)] & VIRTIO_BIT(fbit);
> +}
> +
> +static inline void virtio_add_feature_ex(uint64_t *features,
> +                                         unsigned int fbit)
> +{
> +    assert(fbit < VIRTIO_FEATURES_MAX);
> +    features[VIRTIO_DWORD(fbit)] |= VIRTIO_BIT(fbit);
> +}
> +
> +static inline void virtio_clear_feature_ex(uint64_t *features,
> +                                           unsigned int fbit)
> +{
> +    assert(fbit < VIRTIO_FEATURES_MAX);
> +    features[VIRTIO_DWORD(fbit)] &= ~VIRTIO_BIT(fbit);
> +}
> +
> +static inline bool virtio_features_equal(const uint64_t *f1,
> +                                         const uint64_t *f2)
> +{
> +    uint64_t diff = 0;
> +    int i;
> +
> +    for (i = 0; i < VIRTIO_FEATURES_DWORDS; ++i) {
> +        diff |= f1[i] ^ f2[i];
> +    }
> +    return !!diff;

Let's use memcmp().

> +}
> +
> +static inline bool virtio_features_use_extended(const uint64_t *features)
> +{
> +    int i;
> +
> +    for (i = 1; i < VIRTIO_FEATURES_DWORDS; ++i) {
> +        if (features[i]) {
> +            return true;
> +        }
> +    }
> +    return false;
> +}
> +
> +static inline bool virtio_features_is_empty(const uint64_t *features)

Let's follow bitmap_empty() and omit "is".

> +{
> +    return !virtio_features_use_extended(features) && !features[0];
> +}
> +
> +static inline void virtio_features_copy(uint64_t *to, const uint64_t *from)
> +{
> +    memcpy(to, from, sizeof(to[0]) * VIRTIO_FEATURES_DWORDS);
> +}
> +
> +static inline void virtio_features_andnot(uint64_t *to, const uint64_t *f1,
> +                                           const uint64_t *f2)
> +{
> +    int i;
> +
> +    for (i = 0; i < VIRTIO_FEATURES_DWORDS; i++) {
> +        to[i] = f1[i] & ~f2[i];
> +    }
> +}
> +
> +static inline void virtio_features_and(uint64_t *to, const uint64_t *f1,
> +                                       const uint64_t *f2)
> +{
> +    int i;
> +
> +    for (i = 0; i < VIRTIO_FEATURES_DWORDS; i++) {
> +        to[i] = f1[i] & f2[i];
> +    }
> +}
> +
> +static inline void virtio_features_or(uint64_t *to, const uint64_t *f1,
> +                                       const uint64_t *f2)
> +{
> +    int i;
> +
> +    for (i = 0; i < VIRTIO_FEATURES_DWORDS; i++) {
> +        to[i] = f1[i] | f2[i];
> +    }
> +}
> +
> +#endif
> +
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index 214d4a77e9..0d1eb20489 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -16,6 +16,7 @@
>   
>   #include "system/memory.h"
>   #include "hw/qdev-core.h"
> +#include "hw/virtio/virtio-features.h"
>   #include "net/net.h"
>   #include "migration/vmstate.h"
>   #include "qemu/event_notifier.h"
> @@ -121,9 +122,9 @@ struct VirtIODevice
>        * backend (e.g. vhost) and could potentially be a subset of the
>        * total feature set offered by QEMU.
>        */
> -    uint64_t host_features;
> -    uint64_t guest_features;
> -    uint64_t backend_features;
> +    VIRTIO_DECLARE_FEATURES(host_features);
> +    VIRTIO_DECLARE_FEATURES(guest_features);
> +    VIRTIO_DECLARE_FEATURES(backend_features);
>   
>       size_t config_len;
>       void *config;


