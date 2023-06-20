Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6B7736BF6
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 14:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbjFTMc7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 08:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjFTMc6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 08:32:58 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5871410DD
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 05:32:57 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f9b258f3a2so20539305e9.0
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 05:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687264375; x=1689856375;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jrHa4OsJdnxBW1ca89/U843dn5OqvgkdWl6vjQ6tfT8=;
        b=q+3c9lZ/3bgaSbbcEIvishik9UGjZ3zs2LezT3mUX+0Qn0YAJv+45y/xaWI8EmdE/d
         yF/CNointApkE+CdRqZKON7AWXNloedBpFyBxSSPAg3VflsXkLsMwRrk8B0VRExOCtZe
         iHX4ntaQSMI6xwh5o47uB4hnbb+iyX7HDok5tnI+QEvU2ZqXyOhi/lm48bsgUSg4SwXQ
         jrRmVrkg1DF4wJ/fN6vIdAykFlH3kNE0oqBZZxV7VhEgQZjbQfzJTO5pYTOvt1pfc3Lr
         n5/aKAAWlvruFSlxi8a1AYCdQwzSMNaiNeeCByKQzKq4Pw/syz4Iq6R4rZ0LcXuuNDgx
         oR+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687264375; x=1689856375;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jrHa4OsJdnxBW1ca89/U843dn5OqvgkdWl6vjQ6tfT8=;
        b=LtstVyzCBkHvIIXifS2PoV/5KOSosQy3wsmWlW7A6W73cwBtH/CRzv1iyr6abU5NhN
         sjaKKhSYS69+D+V03DbGVePW9PaQg8/9gCvAkUL85XjkgezKX778Lej/fqTe15Vw36tJ
         Al68B7vPKWhxztmd9++gCG7T5lFZwimD++E2wEvQ8cXWam6jyqTKUTG8mvsrikCANfNT
         XJA6CDAnI/vJlG1ZqV9Lz8taCe8d3qOuG2yqsKu9iFYWcahgGP3o1pb3W18LzsVFB884
         MA1xrjv1Nijpn3jE9kTiaOKcVHV25k/w7IFAWo697SsTn1WjAGBf2Rb6qVeJTn16BEhG
         Xd3A==
X-Gm-Message-State: AC+VfDxLWbwoRWlLgQmpMLPIawZ0m0HHq2pTV0W0gMRpWsZ3u386rQIJ
        PE9764J43l86Rrsn5pXPpx4exA==
X-Google-Smtp-Source: ACHHUZ4c8lQnoO911aM3ax6+IG+oSlq4CBi9Sin4xENek7Zdd9XD9oHsMft6nsmKLVm3s/OlwQ5J1w==
X-Received: by 2002:a1c:f317:0:b0:3f8:fc96:6bfd with SMTP id q23-20020a1cf317000000b003f8fc966bfdmr11236958wmq.17.1687264375620;
        Tue, 20 Jun 2023 05:32:55 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id p3-20020a1c7403000000b003f8d80ecc5asm13350731wmc.12.2023.06.20.05.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 05:32:55 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 0B4391FFBB;
        Tue, 20 Jun 2023 13:32:55 +0100 (BST)
References: <20230620083228.88796-1-philmd@linaro.org>
 <20230620083228.88796-2-philmd@linaro.org>
User-agent: mu4e 1.11.6; emacs 29.0.92
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc:     qemu-devel@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH 1/2] hw/i386: Remove unuseful kvmclock_create() stub
Date:   Tue, 20 Jun 2023 13:32:50 +0100
In-reply-to: <20230620083228.88796-2-philmd@linaro.org>
Message-ID: <87jzvyiaa0.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> We shouldn't call kvmclock_create() when KVM is not available
> or disabled:
>  - check for kvm_enabled() before calling it
>  - assert KVM is enabled once called
> Since the call is elided when KVM is not available, we can
> remove the stub (it is never compiled).
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
