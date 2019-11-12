Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D218DF9C3E
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 22:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfKLV0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 16:26:52 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41605 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbfKLV0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 16:26:51 -0500
Received: by mail-lj1-f196.google.com with SMTP id d22so69743lji.8
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2019 13:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c2kd7wElWMgzfhzil86lKOxClkhSX76vUlbnZXhNRBU=;
        b=GM8FaRiPEkdHS56FwdTLO7a5FOcLD2iJt2i7xIxdVDSTlqk5b3yhck5CRqTDoa7b4S
         mV9X20uS0gEUhdpGbx6MmjERR/XvnvHOT3oxhuDv5WC1p6fYAn9dWLCm/Uf2PH2onKq8
         uarbTWRJRqNL0DHM7NiJvYKUEDyyKfd1Fd1dM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c2kd7wElWMgzfhzil86lKOxClkhSX76vUlbnZXhNRBU=;
        b=q3xMHuEdt2ANRht1jIgsgKl0jlowlT4D7ECmWaymM+y7C7AK8CV4X2/MZUmX5pG81z
         9iJ/QK3dbTq943EP+AkxDFeXhp+gnWSVr9xQkFtHFBwDFgnhikzyu7d33etxuBBPwxLv
         5tCy2eBLrAoVHCSPZjri2vtiukS+lWWIEBmlX4gKv0kve25u4vhqi/4VhL8/oYuUJ4NL
         66wBPcbZEnZRdmY1/sC6teNOnlW6TKDufKxPFiMV2XmZVplm4F+6sd05fPYPrHNH1Cxn
         yx6lgw69cddP+YKfP5bUuZTvUz95rhPdG2Mr0xzK3fg3UEN2j6tLVZbhJ+37JZt2sxpj
         gS6A==
X-Gm-Message-State: APjAAAWXKxDgZwi0EsSonZ6P/A4rcUAO8w81KN92GX/G/pAFii2rrPma
        q8o6G+6jc/JUXCrGCx5AgsImMEeFpiU=
X-Google-Smtp-Source: APXvYqxrg5mVqpnfqPuyA++YAfyisEQo4QD/eZbl+H69sp6OTmqlxgFfrf8RRwNZ6RHH/XBcJkkiLQ==
X-Received: by 2002:a2e:8544:: with SMTP id u4mr5763750ljj.25.1573594007825;
        Tue, 12 Nov 2019 13:26:47 -0800 (PST)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id z17sm10685025ljz.30.2019.11.12.13.26.46
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2019 13:26:47 -0800 (PST)
Received: by mail-lj1-f169.google.com with SMTP id g3so53991ljl.11
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2019 13:26:46 -0800 (PST)
X-Received: by 2002:a2e:22c1:: with SMTP id i184mr21939869lji.1.1573594006740;
 Tue, 12 Nov 2019 13:26:46 -0800 (PST)
MIME-Version: 1.0
References: <1573593036-23271-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1573593036-23271-1-git-send-email-pbonzini@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 12 Nov 2019 13:26:30 -0800
X-Gmail-Original-Message-ID: <CAHk-=wibywR7ySaBD=H9Q0cc1d86+Z1Sg3OWUsDjUvj21dZAKQ@mail.gmail.com>
Message-ID: <CAHk-=wibywR7ySaBD=H9Q0cc1d86+Z1Sg3OWUsDjUvj21dZAKQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM patches for Linux 5.4-rc8
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 12, 2019 at 1:10 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> It's not a particularly hard conflict, but I'm including anyway a
> resolution at the end of this email.

Hmm. My resolution has a slightly different conflict diff, that shows
another earlier part (that git ended up sorting out itself - maybe you
edited it out for that reason).

I think I did the right conflict resolution, but the difference in
diffs makes me just slightly nervous. Mind checking it?

               Linus
