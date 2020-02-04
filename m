Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E71151E79
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 17:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgBDQop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 11:44:45 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39190 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbgBDQoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 11:44:44 -0500
Received: by mail-ot1-f67.google.com with SMTP id 77so17715649oty.6
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 08:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=txCJX4Ne8ohW4iJOJEvhQaXEi/CwoZWs9QB4Yj1b5nw=;
        b=E8BMVd2Oq2XNQz1eagY0Y+rTL0R1OArk+RNjkxQq4QR/Bf7gXbTtfxyrQDEykMnIHR
         ZIYTJAG4piDuOptEAgoIFgtwCU06/9y9sKaoiLmmkpV84rsQOEQ/NAg0IN93tOFX9QzO
         /PnPme6X6LhS85N6jcrz5EqfY+xiY2ggFBHaY+rtueU8D1S8u/NNple1nQKALIFSvNVW
         PaThBkXTx0caPjS/4ue/jNpLbD60+T30X9Gu1bSWJUt80x0TJ5ZoL0cTEE1238+Gvjew
         zoVvC54nNhjGAmzxiEtx5R533wm4iuWhq18ZyJKuk10dgIyMAXqY1KynN1wgW6/XdFhm
         R9jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=txCJX4Ne8ohW4iJOJEvhQaXEi/CwoZWs9QB4Yj1b5nw=;
        b=Z791D5Rjh+s52ay1VolhouDzmp0ugoV4XBA3mcYmju4h8edgxanhBIHSw9LjAvQ/GS
         MECqmFvoc4LYSRGCoEVMeS6GyexQRRB5ZYW1b2l4wTxFOHH3PydgDVKMZLxuFkQ+QQHG
         xQ6TzGX5wuIUJdFAtBG6DIxEx16J1+WlHy5u1Yac6Wgd5GrdR3Hy48Ggdy18WxP58oOd
         hK0AJIlQ7AhKGSFkQIKkyk5Kzd9dOErPXOoekrRQfyjgp78enWqUp3HoTOP7pSj9us6Q
         YD5UjlTJR4M5bdYReXSnXBx9doMLKKfyKbSQbTpBVQ+s4qrwYiPtxG8WQaZhi1gYDuWL
         17aw==
X-Gm-Message-State: APjAAAVD/Ct6nYQU7Jqc5gLlwUuqacJG+hVSEdf6cWlLaD8i6XokthbU
        ee0EAFKZVisnxVvGfS4V/ASw0yNajeVmpec34KsOVQ==
X-Google-Smtp-Source: APXvYqzgn5XWbVJRcw05AyZXj+WSrtxUuUc1VbpFIxK+pSeYmXs4lh9OAJSchu3D7rwCd4p8faMkZHZi8Bn21THy1dU=
X-Received: by 2002:a9d:7852:: with SMTP id c18mr21603447otm.247.1580834683627;
 Tue, 04 Feb 2020 08:44:43 -0800 (PST)
MIME-Version: 1.0
References: <20200110190313.17144-1-joao.m.martins@oracle.com>
 <20200110190313.17144-11-joao.m.martins@oracle.com> <e605fed8-46f5-6a07-11e6-2cc079a1159b@google.com>
In-Reply-To: <e605fed8-46f5-6a07-11e6-2cc079a1159b@google.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 4 Feb 2020 08:44:31 -0800
Message-ID: <CAPcyv4iiSsEOsfEwLQcV3bNDjBSxw1OgWoBdEWPQEymq6=xm-A@mail.gmail.com>
Subject: Re: [PATCH RFC 10/10] nvdimm/e820: add multiple namespaces support
To:     Barret Rhoden <brho@google.com>
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 4, 2020 at 7:30 AM Barret Rhoden <brho@google.com> wrote:
>
> Hi -
>
> On 1/10/20 2:03 PM, Joao Martins wrote:
> > User can define regions with 'memmap=size!offset' which in turn
> > creates PMEM legacy devices. But because it is a label-less
> > NVDIMM device we only have one namespace for the whole device.
> >
> > Add support for multiple namespaces by adding ndctl control
> > support, and exposing a minimal set of features:
> > (ND_CMD_GET_CONFIG_SIZE, ND_CMD_GET_CONFIG_DATA,
> > ND_CMD_SET_CONFIG_DATA) alongside NDD_ALIASING because we can
> > store labels.
>
> FWIW, I like this a lot.  If we move away from using memmap in favor of
> efi_fake_mem, ideally we'd have the same support for full-fledged
> pmem/dax regions and namespaces that this patch brings.

No, efi_fake_mem only supports creating dax-regions. What's the use
case that can't be satisfied by just specifying multiple memmap=
ranges?
