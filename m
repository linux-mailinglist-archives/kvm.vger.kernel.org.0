Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8653364827
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhDSQZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhDSQZd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 12:25:33 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727C1C06174A
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 09:25:03 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id w4so30960240wrt.5
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 09:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=2IEVMMmjvSqcQfvawzed72ofqrNQJLYwE1FD7NLKTHQ=;
        b=qmxDCFcLnrEeeHQw+kvCEQrxx9mvbfmTEbqNhT/xKgKbl4jfZMhz9BM0lIO3qfepyk
         CXPa5+2ib2y9Dc8LrMc0hkwuptdqae7f+qIUMvFVeSYip5M+un/irGY4mj72qq399CoC
         UcadyqibEayJA0JUhVHGouQ191Eboj6bjBgn3mktGkJDZVP9tIruo7C3XdX+kP51bwWW
         8zJaazjsSAeQXCruwJwM5qNcjhPLoni3niGXs2BJWPLdk6Eo8HwglUSl/NY7NGHbZnQP
         ciYbGH/YbKmXdEOWRjRFosh2W0QS19i2Bg+7M2Gx3zvFIizSWxHCakJsxzI0kcgesRkP
         S2nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=2IEVMMmjvSqcQfvawzed72ofqrNQJLYwE1FD7NLKTHQ=;
        b=hGyVMTUWANYV9l3ZmAiL0+04SlwO2/6JBKgtRlT2c2lg/JTUMIazpdSbSbcSRCVd6+
         mJrQK/yH9jROomC91QqCzsBhAzd1NuDbTpKVuKZwEXHE69ClrVJ6W36FXcydrivg2c1q
         9p4SSEZeZnfsMb23g7TtAKTUgd0k4KX9TROXKerT6ULjjlNzisQZk6kBZLIKOv+MBAHp
         bxs4YeWq23JikVZymY7U4Z5r1M5LEzzv5Ne0SVS8qnKGLQ5mMBqm4XutNSE9Xd53jKbC
         qFqbAvC66I1o9ISzSWSnOFAdjMkCxO8fiS5AXEug/rnxRPh68BRwbKbVZZWxMxt0dLfu
         afKg==
X-Gm-Message-State: AOAM531aD/X17Vu2Bverbk5K1IneC3atIvL5BEqehp8LA9/GiVihY/hp
        /xistRI8H11BNamE/087hUchvmGmw30zvA==
X-Google-Smtp-Source: ABdhPJz6tlBO/C4r8ErWIld/G5DyDMOUqJFQRkL1k37aUmHea8oZVnaXMZrR50X+O/FqbT/BEDYduw==
X-Received: by 2002:a5d:4006:: with SMTP id n6mr15575576wrp.240.1618849501997;
        Mon, 19 Apr 2021 09:25:01 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id o12sm14363892wmq.21.2021.04.19.09.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 09:25:00 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 461AB1FF7E;
        Mon, 19 Apr 2021 17:25:00 +0100 (BST)
References: <20210401144152.1031282-1-mlevitsk@redhat.com>
 <20210401144152.1031282-2-mlevitsk@redhat.com>
User-agent: mu4e 1.5.11; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: Re: [PATCH 1/2] kvm: update kernel headers for
 KVM_GUESTDBG_BLOCKEVENTS
Date:   Mon, 19 Apr 2021 17:22:56 +0100
In-reply-to: <20210401144152.1031282-2-mlevitsk@redhat.com>
Message-ID: <874kg29r8j.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Maxim Levitsky <mlevitsk@redhat.com> writes:

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Generally it's a good idea to reference where these are coming from, is
it a current kernel patch in flight or from an release we haven't synced
up to yet?

Usually linux header updates are done with semi-regular runs on
./scripts/update-linux-headers.sh but obviously it's OK to include
standalone patches during the review process.

> ---
>  linux-headers/asm-x86/kvm.h | 2 ++
>  linux-headers/linux/kvm.h   | 1 +
>  2 files changed, 3 insertions(+)
>
> diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
> index 8e76d3701d..33878cdc34 100644
> --- a/linux-headers/asm-x86/kvm.h
> +++ b/linux-headers/asm-x86/kvm.h
> @@ -281,6 +281,8 @@ struct kvm_debug_exit_arch {
>  #define KVM_GUESTDBG_USE_HW_BP		0x00020000
>  #define KVM_GUESTDBG_INJECT_DB		0x00040000
>  #define KVM_GUESTDBG_INJECT_BP		0x00080000
> +#define KVM_GUESTDBG_BLOCKIRQ		0x00100000
> +
>=20=20
>  /* for KVM_SET_GUEST_DEBUG */
>  struct kvm_guest_debug_arch {
> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> index 020b62a619..2ded7a0630 100644
> --- a/linux-headers/linux/kvm.h
> +++ b/linux-headers/linux/kvm.h
> @@ -1056,6 +1056,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
>  #define KVM_CAP_SYS_HYPERV_CPUID 191
>  #define KVM_CAP_DIRTY_LOG_RING 192
> +#define KVM_CAP_SET_GUEST_DEBUG2 195
>=20=20
>  #ifdef KVM_CAP_IRQ_ROUTING


--=20
Alex Benn=C3=A9e
