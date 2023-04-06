Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127DF6D9029
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 09:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235826AbjDFHJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 03:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235325AbjDFHI4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 03:08:56 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651C093F3
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 00:08:38 -0700 (PDT)
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com [209.85.219.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 31B363F23D
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 07:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1680764883;
        bh=u92lfurfYYp1af2K26TOzdjWbKa5zPlLBBByPP70/Uw=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=YeZaN316tECObcQwvjqzXOjFwEj0RhaDiXYW0ZiPeZieE2S4dD9PkSfTpDS96jTKo
         LtviaAc8iJsWmo9ff29ef6EAzjTG80xFBVLn8CoMuDy7flJJkiTWhoNPf/ngIbwrub
         pTsujgariquIzWmvKGV/Ad4mQqo9DA1QKt4BSYrVK+XGQplVpJm+TOa2gTdkUBRpcR
         Os6Ejx/qUJU16sVAu99z7Bv9VHpsV0Jjf0+ZXJPCzvYAAnJVfg4/bXfaHhcvys8Xzk
         yauETqL44bCsUjpI4CLkdliHtzFiLkImXBRgF1LG8hdIS+gC/ZDD0LNruddQatBoSX
         gSuDlKJ1Ks15Q==
Received: by mail-yb1-f197.google.com with SMTP id k199-20020a2524d0000000b00b7f3a027e50so22878482ybk.4
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 00:08:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680764882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u92lfurfYYp1af2K26TOzdjWbKa5zPlLBBByPP70/Uw=;
        b=zhhWhpm6hPv0t31ezGqeziGNR554SZPgEbRLcBGLLLMZr2Wx7g/gWc36F5nlAGhObX
         hSQbkFSYpgRd9SDfQzt912PmVLcv2XZbT/rio5tkcv5buUcGBz8B68q9Zf1ry+MOYTeH
         rQvwmBVLuJ3dHg0rhQABA29EuCwktWWcC0Adio2AFUPZFtMljWVrDy2/uDHxGVcjQaWu
         /VMeGXTa0JORnMFdNVD3kZ4CdPmxyIs8GfPcwQ1TSX7xXH7m6zrjFvZoZrxT2De0dM/M
         PrQqXExNTgM8lwoaczONpkanLnC6lCEbqpoFj8IiSIttzLVSznl6Fl5+gbX7VED74r+b
         qwNQ==
X-Gm-Message-State: AAQBX9f0jlgmCPIFLRWMXkjJ4wHSfyXys4ZJ9iW5h1MuiVyqCdaW+gpK
        Pkqcv+PXIWNxvP5suXrHlqLBtsbN0G1VI+SYCs7u0ZuRSFEvQugIZsZwhok5/uFrLPYXJFPih07
        SWxjqas8bsNyemoSd6jMy2ChbeWqm6g1vOj9Jf7kaKBcwlQ==
X-Received: by 2002:a25:7689:0:b0:b75:9519:dbcd with SMTP id r131-20020a257689000000b00b759519dbcdmr1443373ybc.12.1680764882159;
        Thu, 06 Apr 2023 00:08:02 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZtraXMmp0doeDwepKZup22JQwNcOgfF6PwPn9eVvhfkn2nvHNZ94AW1UziM+HyXKGATsjraDmaHZuFqOLdC+Y=
X-Received: by 2002:a25:7689:0:b0:b75:9519:dbcd with SMTP id
 r131-20020a257689000000b00b759519dbcdmr1443367ybc.12.1680764881955; Thu, 06
 Apr 2023 00:08:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230404122652.275005-1-aleksandr.mikhalitsyn@canonical.com> <ZC49UDfayQ+XJRUt@google.com>
In-Reply-To: <ZC49UDfayQ+XJRUt@google.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Thu, 6 Apr 2023 09:07:51 +0200
Message-ID: <CAEivzxe9v9z8YcJaE9n7snd2eEEaKZeCZHDdfm+1bgJ0_2H7Mw@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: SVM: small tweaks for sev_hardware_setup
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 6, 2023 at 5:32=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Please tag patches with RESEND when re-sending the exact patches with dif=
ferent
> To/Cc fields.  Not a big deal, but I blinked a few times trying to figure=
 out
> if I really had two copies, or if it's just time for me to log off for th=
e night :-)

Hi Sean,

yep, I'm sorry about that. First time I've sent patches without proper
CC's by mistake.

Kind regards,
Alex
