Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B000D11F714
	for <lists+kvm@lfdr.de>; Sun, 15 Dec 2019 10:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbfLOJ6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Dec 2019 04:58:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22422 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726050AbfLOJ6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Dec 2019 04:58:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576403916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uglnVCAjnaUsXT9ZTT7mKFQQrU34w0ggWLPMx7AnQTk=;
        b=Kj5ayt78dNRA/DuWbzLJYZ+h02SXHE/bx+3eG2Wguaep3rfgAxxs5GlzVyKPgMY8EVTGzd
        57jsz/13JAfmiGgxKIvM8cGJJrft81s5ZNDJPu6P/36P04xVt2UQ8no7EkMb7BI2fGfCX2
        9WhfTufr29PDjHxgLjglqTk6+o7gx8s=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-VzXia93MMZCivjjR49OQvA-1; Sun, 15 Dec 2019 04:58:34 -0500
X-MC-Unique: VzXia93MMZCivjjR49OQvA-1
Received: by mail-qt1-f200.google.com with SMTP id d18so2624770qtp.16
        for <kvm@vger.kernel.org>; Sun, 15 Dec 2019 01:58:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=uglnVCAjnaUsXT9ZTT7mKFQQrU34w0ggWLPMx7AnQTk=;
        b=BT5nzTZuRqutbnXzSGLwdS/Ncjhxth30qTf1GrwD5YJQvjiq3toOIOvSgFX+JaFZkF
         d3qSOIYRrfbjkkPr/DuJz7ygu17QQmZDhq9vXb8RnDd9hry/++5+8pkHOTCv1BJKDmsq
         sRLi9TCLysc/nu0JlPOr85Y6dNl22Ik8DNz0N4y2NWBOaOAMe8tSLZ0VmU5o7KoaBzX+
         WYKueuv4D6E4PLIPTFn5+bpktuTjKoOvvJXhZCRjxbvBe1sPuVqoQdi2RPhwhncMFZDt
         LSvp0ODY9AAaD2x+XcLDCjem+9CEBXefUqhxgpvIOtT4CuFzvE6zni0lGwH7269xy2g+
         ln8A==
X-Gm-Message-State: APjAAAUyv9b/dSxGbB4EHqh30FRpxV7HHu0pafPiuIz2DMYXusKzp5en
        ToADRWppA+LHVmpvdxLUEg0yXf7nGciwXQ5UNYF+peFARFnWS+WYqEczHLsDVR+McP7H6u/zBkm
        gQKPyTLgwD7aE
X-Received: by 2002:ac8:2bb9:: with SMTP id m54mr20346510qtm.150.1576403914505;
        Sun, 15 Dec 2019 01:58:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqxShGzMmQTP0GPg+U7XkjAABhRbEWqYV30OwRBbm04m47kjZ2QozlKgsELOkgUl7CsWCeS0Iw==
X-Received: by 2002:ac8:2bb9:: with SMTP id m54mr20346493qtm.150.1576403914297;
        Sun, 15 Dec 2019 01:58:34 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id 184sm4752304qke.73.2019.12.15.01.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 01:58:33 -0800 (PST)
Date:   Sun, 15 Dec 2019 04:58:27 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, John Snow <jsnow@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-block@nongnu.org, Richard Henderson <rth@twiddle.net>,
        xen-devel@lists.xenproject.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sergio Lopez <slp@redhat.com>
Subject: Re: [PATCH 12/12] hw/i386/pc: Move PC-machine specific declarations
 to 'pc_internal.h'
Message-ID: <20191215045812-mutt-send-email-mst@kernel.org>
References: <20191213161753.8051-1-philmd@redhat.com>
 <20191213161753.8051-13-philmd@redhat.com>
 <d9792ff4-bada-fbb9-301d-aeb19826235c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d9792ff4-bada-fbb9-301d-aeb19826235c@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 13, 2019 at 05:47:28PM +0100, Philippe Mathieu-Daudé wrote:
> On 12/13/19 5:17 PM, Philippe Mathieu-Daudé wrote:
> > Historically, QEMU started with only one X86 machine: the PC.
> > The 'hw/i386/pc.h' header was used to store all X86 and PC
> > declarations. Since we have now multiple machines based on the
> > X86 architecture, move the PC-specific declarations in a new
> > header.
> > We use 'internal' in the name to explicit this header is restricted
> > to the X86 architecture. Other architecture can not access it.
> > 
> > Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> > ---
> > Maybe name it 'pc_machine.h'?
> 
> I forgot to describe here (and in the cover), what's follow after this
> patch.
> 
> Patch #13 moves PCMachineClass to
> 
> If you ignore PCMachineState, "hw/i386/pc.h" now only contains 76 lines, and
> it is easier to see what is PC machine specific, what is X86 specific, and
> what is device generic (not X86 related at all):
> 
> - GSI is common to X86 (Paolo sent [3], [6])
> - IOAPIC is common to X86
> - i8259 is multiarch (Paolo [2])
> - PCI_HOST definitions and pc_pci_hole64_start() are X86
> - pc_machine_is_smm_enabled() is X86 (Paolo sent [5])
> - hpet
> - tsc (Paolo sent [3])
> - 3 more functions
> 
> So we can move half of this file to "pc_internal.h" and the other to
> 
> One problem is the Q35 MCH north bridge which directly sets the PCI
> PCMachineState->bus in q35_host_realize(). This seems a QOM violation and is
> probably easily fixable.
> 
> Maybe I can apply Paolo's patches instead of this #12, move X86-generic
> declarations to "hw/i386/x86.h", and directly git-move what's left of
> "hw/i386/pc.h" to "pc_internal.h".

Yea that sounds a bit better.

> [3] https://www.mail-archive.com/qemu-devel@nongnu.org/msg664627.html
> [2] https://www.mail-archive.com/qemu-devel@nongnu.org/msg664765.html
> [5] https://www.mail-archive.com/qemu-devel@nongnu.org/msg664754.html
> [6] https://www.mail-archive.com/qemu-devel@nongnu.org/msg664766.html
> 
> > ---
> >   hw/i386/pc_internal.h | 144 ++++++++++++++++++++++++++++++++++++++++++
> >   include/hw/i386/pc.h  | 128 -------------------------------------
> >   hw/i386/acpi-build.c  |   1 +
> >   hw/i386/pc.c          |   1 +
> >   hw/i386/pc_piix.c     |   1 +
> >   hw/i386/pc_q35.c      |   1 +
> >   hw/i386/pc_sysfw.c    |   1 +
> >   hw/i386/xen/xen-hvm.c |   1 +
> >   8 files changed, 150 insertions(+), 128 deletions(-)
> >   create mode 100644 hw/i386/pc_internal.h

