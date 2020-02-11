Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2B9B159C2D
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 23:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgBKW2U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 17:28:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:55718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727029AbgBKW2T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 17:28:19 -0500
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9DA420870
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 22:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581460099;
        bh=qr3w/Jk4E7ZCigNfuSnbve2ZaYJ6PJplvO36QBtgk3A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NbhIRNqjUWMveUgY7a+SRNavuBLMaEJ0S2oXpbC09sQj8F1OxfAaPXKrzuWU3TF2O
         Mw+vNvdw9fNIzYXnERaAnsTNo8ZHS1QCAPy5Nvu8ouh1ktsRBH8DIULlWinJRU+cW+
         hVMAIhu2xjN3VS9wPKN+Ai4P976oR8rTNBaTMTcQ=
Received: by mail-wr1-f52.google.com with SMTP id m16so14513325wrx.11
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 14:28:18 -0800 (PST)
X-Gm-Message-State: APjAAAX6QkzsiEUSnh7s+fcg6tGiCiUaKR/ung9QMaa2dMSvTA+cOu9C
        ffeFxq3wsB3Z1PCe7Ocu7ch34r5Ahn4TChf2gqs6Sg==
X-Google-Smtp-Source: APXvYqxuwxNAwq4kzXKENcWaHlU1Oo2EBlzHy1k0fYPvxMGCQYfMlvTgvb3+mfAmlPcL+PPn6IOa2/0gfWBtQFH5zR0=
X-Received: by 2002:adf:a354:: with SMTP id d20mr10781683wrb.257.1581460097315;
 Tue, 11 Feb 2020 14:28:17 -0800 (PST)
MIME-Version: 1.0
References: <20200211135256.24617-1-joro@8bytes.org> <20200211135256.24617-20-joro@8bytes.org>
In-Reply-To: <20200211135256.24617-20-joro@8bytes.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 11 Feb 2020 14:28:06 -0800
X-Gmail-Original-Message-ID: <CALCETrWecBK7cqgLTB72mMYRs10R1e+rkZh9mnzRNJc0N=XU2Q@mail.gmail.com>
Message-ID: <CALCETrWecBK7cqgLTB72mMYRs10R1e+rkZh9mnzRNJc0N=XU2Q@mail.gmail.com>
Subject: Re: [PATCH 19/62] x86/sev-es: Add support for handling IOIO exceptions
To:     Joerg Roedel <joro@8bytes.org>
Cc:     X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 5:53 AM Joerg Roedel <joro@8bytes.org> wrote:
>
> From: Tom Lendacky <thomas.lendacky@amd.com>
>
> Add support for decoding and handling #VC exceptions for IOIO events.
>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> [ jroedel@suse.de: Adapted code to #VC handling framework ]
> Co-developed-by: Joerg Roedel <jroedel@suse.de>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

It would be nice if this could reuse the existing in-kernel
instruction decoder.  Is there some reason it can't?

--Andy
