Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8673E518A
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 18:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404889AbfJYQsI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 12:48:08 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34071 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390972AbfJYQsI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 12:48:08 -0400
Received: by mail-io1-f67.google.com with SMTP id q1so3189262ion.1
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 09:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CFUDDKaFpcSfEv5bHLUnGieP3g9sV6ToGbRF8r26X/Q=;
        b=O3Sy/4FurlMwn1ds3dGLK+Lrt6W9ABvUmZSuelCAO7nvyjEvL7dfFvHibJxnCMcZVf
         486YU8TFjd8R1XlRKb3glWjVvSek8jUdUgmuhyzHyaGIs9HFY0odDVcbQIpl0eJytYup
         Tcoe+P09owb5/e6Rx0EBtkAvRWhTQnlghPmA0sVCI+u8SUUCSuOnNkFfLV5zm25KP0md
         Rk3BzZLTyhQQM64W0Kp1PCsA0a84+F/GS6FJKnnOKRehSFe2OMqo1zcSo6DyHal2STAK
         8gdyPeQ3VGiJLpcX8+f/pfe5mW/uoNaRyEG10ysVwFHHotFMGd0jC519hTSAVrA+iWSM
         gOMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CFUDDKaFpcSfEv5bHLUnGieP3g9sV6ToGbRF8r26X/Q=;
        b=mhN4/1mNAAPHXiij9wuW9bcTok0Sx7mAxNcj2rXOUih09hz/DC+kCoVTytlYiDv0zu
         wO3JlWxt60Yxh0Zf059wzwDMtZk+Adxw46UZxZMqcnmVM1BkKQHUVaGxmNXUcj5SMWC8
         2KgF+sgVpYjKkEz/VE82lzH8e6OLUakUVun0FbKfPGSN5dQ5fxtBYf7oTRHBwlY+jzLN
         qDv7j9AmaltKJEFQqOAiHyqz6bWIuJZ7K2mY6xCBNK2rdv578CFk0sjGQT//GD2o7aIS
         yId/mcTO7XdPDDZZMqPjwjuxYajDKodsP8Ee68B269H/VvIKCzx5MNYceb+uuEQo8JAD
         OMuw==
X-Gm-Message-State: APjAAAUzJ1mCpy4D0EpeJsp+X1TmfOYnsPrH4qBcRie78dcSe6G7MuSQ
        fqVwkbWlcOoujk9sUNA5l1jWQKb6oaOkgBWa7tG1Dw==
X-Google-Smtp-Source: APXvYqxxY+/BIu9/+JPTpgSOOtleemGhb3JXTddRj9IkVqTuJXYU6L6KROzcsTaQLS6J3HU9nZ2phl6M7dBx70xrtag=
X-Received: by 2002:a5d:8d8f:: with SMTP id b15mr4788472ioj.296.1572022087687;
 Fri, 25 Oct 2019 09:48:07 -0700 (PDT)
MIME-Version: 1.0
References: <20191024222725.160835-1-aaronlewis@google.com>
In-Reply-To: <20191024222725.160835-1-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 25 Oct 2019 16:47:56 +0000
Message-ID: <CALMp9eSacBm6=c8_5eAUOWeLVjkr1CH8yppXXE5E4gi5FfcYPw@mail.gmail.com>
Subject: Re: [PATCH] x86: Fix the register order to match struct regs
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 10:28 PM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Fix the order the registers show up in SAVE_GPR and SAVE_GPR_C to ensure
> the correct registers get the correct values.  Previously, the registers
> were being written to (and read from) the wrong fields.
>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>

Subject should have been [kvm-unit-tests PATCH] x86: Fix the register
order to match struct regs
