Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A038CD6C5D
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 02:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfJOAEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 20:04:36 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:45090 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbfJOAEg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 20:04:36 -0400
Received: by mail-vs1-f68.google.com with SMTP id d204so11937429vsc.12
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 17:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XH97f0i+ClRovzD/jo8yU0mLoiuoNdbkeCq7ouSUzdU=;
        b=i7vkiycL0AXDJKR6cQ/1qrbEPh0eJBmUQjQFS02feYZWEkYEVUYX1LhLRVNfxE7uBo
         g/uMVr4hV3DxD24PPjjztNMqEj0eYlxc8wDcr02ocDZzeYzlxXuE+1/8+14bMhFrPVe9
         CIs6CkWJftYneDD/cHDGgl5S5L0t/EVeV8sYaZ97xkoq0x9TKoO4XZwv/HbhBbK5sCqy
         0BK8LsYu1YT8N3wpp3/076LeFeE3S1pUJ56hpJF29aiD5FZD4Up0MWBIA03S8QaIqyN7
         +g8XT7DBsFFgtxp2b29SAENozom0QNgCDn6NZB0Qxu7EC3u8KNe5NOHoY2fjAgSG2k69
         Im/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XH97f0i+ClRovzD/jo8yU0mLoiuoNdbkeCq7ouSUzdU=;
        b=TH4f2Qk3+2dBF+7WkHypkHrWslI6eV2Bo2S/AxCcb7nziyzx3k56vaurILJyyUBmfM
         opNbbbsE6Ik7H6dzGnyhkvqKcEFGY39TQL1MBApPth7NzYblvZADeKHwPSe8LIwBUJUB
         vRkQ6njw4T+MIAoRTHefrCIFTObuL0iPf/1ZMTx99jfJTwVH3Zi1S2hI08n5Y4i/0Cjv
         fwWnqaRvEFILDOrUrKQ4rLIpK0+pwNb58d2Jxrz8xcfeSmjO4t04zDWHgYon6esJ1g5Q
         HxudIHeJ/xPkhHFF2ZigiNGkzIDsfkTdCqS/PZFi2AtNrsj7u1h00Tj5uD3fer9g6zjV
         EDow==
X-Gm-Message-State: APjAAAX2fjtZ53DMZQaahmUB6BnKYVabM/7RkvM1j0BuLeMY2w4VBwJw
        BwLxyRjIQUN7y8cEUqe5C5+bBWKhAUJQc+IA9wFb
X-Google-Smtp-Source: APXvYqyTPVS8cXekEbTOMU362Dy5xi8QcspnkVwCQ8bDbKUYHfWjBO5aOA7h+ZLAZzkyct0ygTjx3hZ+71Nq3cLbAZ0=
X-Received: by 2002:a05:6102:3117:: with SMTP id e23mr18668944vsh.189.1571097874490;
 Mon, 14 Oct 2019 17:04:34 -0700 (PDT)
MIME-Version: 1.0
References: <20191010183506.129921-1-morbo@google.com> <20191014192431.137719-1-morbo@google.com>
 <CAGG=3QVuCrD83TcfeaqJFCTgvx36V4gc-VuCoaMDOgB4EhH0EA@mail.gmail.com> <C82F208E-BE8C-4106-A9F2-37FCDE2E90E7@gmail.com>
In-Reply-To: <C82F208E-BE8C-4106-A9F2-37FCDE2E90E7@gmail.com>
From:   Bill Wendling <morbo@google.com>
Date:   Mon, 14 Oct 2019 17:04:22 -0700
Message-ID: <CAGG=3QWmkJ8Q7QmAjL=AOaaZP0eFYvdXqQQbpvf1SRtSCJVtqw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 0/4] Patches for clang compilation
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Done.

On Mon, Oct 14, 2019 at 4:56 PM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> On Oct 14, 2019, at 12:25 PM, Bill Wendling <morbo@google.com> wrote:
> >
> > Crap! I used what I thought were the correct command line arguments
> > for "git send-email", but it didn't add the "v2" bit. My apologies.
> > All of these patches should be v2 for the originals.
>
> I recommend that you send them again with v2 in the title to avoid
> confusion.
