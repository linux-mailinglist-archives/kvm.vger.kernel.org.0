Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA916657780
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 15:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbiL1OHd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 09:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbiL1OH2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 09:07:28 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3276451
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 06:07:27 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id e6so7638061qkl.4
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 06:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IjYzbIVEorvmm2KU2QPmo8PUpVrTVTmlahAm1XCKAGA=;
        b=iQtJfow2wD6/7R1czNZ3JHLSP25ba+A7M7uCzN0Fd8yFsOnaOXihxya6BC9vo2m+Y0
         zDhS6/q9Fcf0ri/h3XXfPFxF0qu6kYiCc1j+8AIyc3SO5k3u4YH0N+rI1XfdW9zLQUud
         Ej0oG/mb03HFoYsP5Wj4gwcGxV6Ft9hYxfLyljrnuVw185iR7nohjPI6M0/FJvQHzSPk
         Hf7TDqS5X0NLPfIFKFqRTWvfoLKxMda1tNJN69BXKtBhaftH39xNEurApjJlN+WeCXyo
         FqMxTYxu3BELtExYlSXyZOmXq+cppOVAcrkOWAZ+usMzSPPmdXO/OddNispjmKf3qVwQ
         L7IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IjYzbIVEorvmm2KU2QPmo8PUpVrTVTmlahAm1XCKAGA=;
        b=2YWj71VyzToG44MwGvA5A8QAX2cxrBeG+QeF019hrunlMO1XAEIru1lXqPlTOdJ9Sl
         xPT5vaFenaq9cLa15M8zVF91NYdm52LkCZoiDHvqSzig2QPrlwDqXQP96k7I0hrQuYbw
         MDvC7TVrMwH1ROs4w2DoORgtPey4ziWhN6WtXv74awxDVhkVU6zYAtAL9Po/nv2Vhb6N
         Jj8g5jLq6hlb36zhMXYO/zocnrPqS1aRb71OSAPWdqx+GhiCZoTRUAhC3362FPkCujj7
         3lo1uvKK9AjZnHIc+tuzbQOi+F9MT5nRBVA5pprpjsbCYK5woN6xhezHSXROAtOoQh4S
         DOxQ==
X-Gm-Message-State: AFqh2kqFhes/SOLDaxThpGtftXf1ZPhyHqkSe4LR7pdDVxpf8lp62lD0
        NfpllVhl4ltVRIPe5VM/8GdpURLYWvoO8EuwNJFbDA==
X-Google-Smtp-Source: AMrXdXscONRei6ewKvw1rTSptydY9OHTuUsNjXnmZErLRBw4G9JuWK+m9EIln4JKV83H0JWDICmub2QgkN6n5LS7WFU=
X-Received: by 2002:a37:b93:0:b0:6ed:d040:c175 with SMTP id
 141-20020a370b93000000b006edd040c175mr1073627qkl.536.1672236446216; Wed, 28
 Dec 2022 06:07:26 -0800 (PST)
MIME-Version: 1.0
References: <20211027124531.57561-1-david@redhat.com> <20211027124531.57561-11-david@redhat.com>
 <8a2fb7aa-316d-b6bc-1e8d-da5678008825@linaro.org> <6a533ba5-5613-1f96-866a-974530fb10bc@redhat.com>
In-Reply-To: <6a533ba5-5613-1f96-866a-974530fb10bc@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Date:   Wed, 28 Dec 2022 15:07:15 +0100
Message-ID: <CAPMQPEJ1Nk_8TZgo2r9NtGeV92NbdUUyCszbBxwcYH-ZpFu1iQ@mail.gmail.com>
Subject: Re: [PATCH v1 10/12] virtio-mem: Fix typo in virito_mem_intersect_memory_section()
 function name
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Hui Zhu <teawater@gmail.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        kvm@vger.kernel.org, QEMU Trivial <qemu-trivial@nongnu.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Dec 2022 at 15:06, David Hildenbrand <david@redhat.com> wrote:
> On 28.12.22 15:05, Philippe Mathieu-Daud=C3=A9 wrote:
> > On 27/10/21 14:45, David Hildenbrand wrote:
> >> It's "virtio", not "virito".
> >>
> >> Signed-off-by: David Hildenbrand <david@redhat.com>
> >> ---
> >>    hw/virtio/virtio-mem.c | 12 ++++++------
> >>    1 file changed, 6 insertions(+), 6 deletions(-)
> >
> > Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>
> I already queued your patch :)

Thank you then! :)
