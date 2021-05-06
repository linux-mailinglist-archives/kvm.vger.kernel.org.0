Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF33A375BA6
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 21:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbhEFTW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 15:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233504AbhEFTW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 15:22:28 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B214BC061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 12:21:29 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n84so3990286wma.0
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 12:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=Yg1I4glWqaS52CpGzVFLIbEPG9mJUqSU8zT79wfMSYY=;
        b=Rz3wmpXtVAdrQ1thoNAPQ/PPtRWrjCHNAGbI+HwCZ56fHeQKzIY2FXYiEYWbJYwLAP
         orathCPW15Fjg0pnVV4jtr2Sb0a2cdJ4glga6Khl3aMlPMMMixUff4KzSFn8oLY6IZsv
         jhpOHZi4+htCTw9xjJv09l4MofgBfJw/b4un11GqghXoEiAVG/bZuYTCsTqqsQJrJtQs
         rFGzICq9MlwNHRm1QiW6iaUqw/UKWNm0OAzn39VkJUof6O7XcAySQJdAoIGQ2C8W3iaQ
         HAV8cCTfqv04FNLeO4ErEHflQvAtsWtaFZK2NZA9BY4KTg0kP8ebbsIywZt3kfwSBenD
         /grA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=Yg1I4glWqaS52CpGzVFLIbEPG9mJUqSU8zT79wfMSYY=;
        b=PGzMImyVRM0jI3bZln8k1wFB39jJmgcb7zpO3w0TGBgI5AMBUjCN5hJxHMasq0L3UW
         3/uREJRZC5GRW/k0GH+bTyK6CfkQK+FNW1Q+VJ0jqK8CUDNNP28RQaOux4nzK43cB8jm
         OeAd2GnXcZ8mQOwdQKHmZqWqEF0I79Kmh9rxVxGpEHyD7tS8mjVcBhZEkhheMa0+iv6L
         VGbHrH70Lv1cMjI4LPERmPS/F2Byhd3nlBjx8W/juzfm8xVvgRMWQipaayg5G+IfBLtM
         wg2VpkivIh6itMC+QlQM+dn4NjqRfclRV53q7ibd7OkMK+Fktd4T4oCfqTJI1ClIYaUM
         tArg==
X-Gm-Message-State: AOAM531FJ9Z49mJQa0pS382ODlcKNuRajjv1rKSkzDqgDpaIzDKLikGA
        EQNvOOcM+A+ggr94amk8l0YAPw==
X-Google-Smtp-Source: ABdhPJwqY14O7WbIKOgN7nshCCu9J2bEWolzDXRzV0lrgqSAVLjIWEtC/lSVYcgKnDH/+C6AoPg57Q==
X-Received: by 2002:a05:600c:220e:: with SMTP id z14mr5858595wml.0.1620328888444;
        Thu, 06 May 2021 12:21:28 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id z6sm4285367wmf.9.2021.05.06.12.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 12:21:27 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 7349C1FF7E;
        Thu,  6 May 2021 20:21:26 +0100 (BST)
References: <20210506133758.1749233-1-philmd@redhat.com>
 <20210506133758.1749233-7-philmd@redhat.com>
User-agent: mu4e 1.5.13; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        qemu-arm@nongnu.org, Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 6/9] gdbstub: Only call cmd_parse_params() with
 non-NULL command schema
Date:   Thu, 06 May 2021 20:21:21 +0100
In-reply-to: <20210506133758.1749233-7-philmd@redhat.com>
Message-ID: <87y2crmzwp.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> writes:

> Move the NULL check on command schema buffer from the callee
> cmd_parse_params() to the single caller, process_string_cmd().
>
> This simplifies the process_string_cmd() logic.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
