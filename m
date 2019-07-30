Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFBF7A675
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 13:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbfG3LFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 07:05:11 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50994 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729999AbfG3LFL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 07:05:11 -0400
Received: by mail-wm1-f68.google.com with SMTP id v15so56748881wml.0
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 04:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dpNdRkCzqUyYffw/7lLTRM9HVMvkB3KarB7VEUzjUVQ=;
        b=HIgSlgxwKYg8e/J3SjxYaKZCVZh/e/MD2QdamQO42v9zxKGtnEu/HA0ntpZVF0zSv3
         5En9GIlM1eq9727UDqzefzKNiiJR4QyN0HxkFlk8u68kGAD0zT8f4Z7cDhNi5xT8niBr
         bCfIJUpo4Mr0i7SwnLjBwQHAguu1hnkWjiqcMgMzvCG+9fwk+XvN+eldY7vXr7ZrjKPK
         wivpb2Y0BFiu6WCcExmPqG113bMRW5MkuLn/arqPWmorJfY+wlqBvjTuzGSRIZvOhWBx
         6ZSN2uLXvKdxPD5MIHC9pC4ZEinP8IxAVwb7Kj2RpdTKkmZpnFTFDvKbjFb+hlihBE5t
         dicw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dpNdRkCzqUyYffw/7lLTRM9HVMvkB3KarB7VEUzjUVQ=;
        b=B35/Z9HHgAhHEbEye4/AROiNBqMSG+9+BJIP6cHAKZijn1dRJa4q8OtIJMiMC1xiQE
         4PmslCiZOpAtkTZw5Y2i9nf3X+bo5ROgG7QwsSmGgFy8fWT9GSXc441/mwDqvl16ip7F
         tlw6Jqiy5HytkdeuGlcsSeC3QNYEto6n2YhkahFwGAE2ARi0ICZO3Dvv1r2KIm6VR36Q
         G9hG1rLxtNKRjgZsoFjSCH+8uhlMrSTCJUcXOYwD2zuX6sM2HRreLHNje9yjGd2TUXCG
         egqQ+Ctl/bOM98ysahY4uMPQ/QqU5zaOkKjAEkbGKqEuglpmZyfgFsZcfXni06MmZkcW
         F/wA==
X-Gm-Message-State: APjAAAX/YUym4lcPoMroxSOWkv2gXP6cyMnaixB6RFImqF87/nDDw8t4
        XijyGUyMxK9CaXfuN6Yk5w0xWV+GiDBswfcjsYA=
X-Google-Smtp-Source: APXvYqzVGcu6yOiKZfaeofC+j2ZPARkP3m25uM7rRFZC05JiebgCN4lGL6Gxd7aUZzaBrterPRwnFMHxEEVBhXH47Xo=
X-Received: by 2002:a1c:be05:: with SMTP id o5mr106351335wmf.52.1564484709021;
 Tue, 30 Jul 2019 04:05:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190729115544.17895-1-anup.patel@wdc.com> <20190729115544.17895-4-anup.patel@wdc.com>
 <309b9fb3-9909-48d6-eabf-88356df4bb3b@redhat.com>
In-Reply-To: <309b9fb3-9909-48d6-eabf-88356df4bb3b@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 30 Jul 2019 16:34:57 +0530
Message-ID: <CAAhSdy1x-sWfqtqaBhFzHjgsv5p68UUg0LTyOCEZ7sOVcO=okw@mail.gmail.com>
Subject: Re: [RFC PATCH 03/16] RISC-V: Add initial skeletal KVM support
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 30, 2019 at 2:53 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 29/07/19 13:56, Anup Patel wrote:
> > +     case KVM_CAP_DEVICE_CTRL:
> > +     case KVM_CAP_USER_MEMORY:
> > +     case KVM_CAP_SYNC_MMU:
>
> Technically KVM_CAP_SYNC_MMU should only be added after you add MMU
> notifiers.

Sure, I will move this case to MMU notifier patch.

Regards,
Anup
