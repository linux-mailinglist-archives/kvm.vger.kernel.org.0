Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6092E85661
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 01:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbfHGXPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 19:15:55 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45318 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729938AbfHGXPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 19:15:55 -0400
Received: by mail-ot1-f68.google.com with SMTP id x21so17839165otq.12
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2019 16:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=y5EH+uVVZi4pQVkeOf2HQsE+Jig/HWZWR6VmtoAY/1Y=;
        b=FGcfSyAeEFjqXYP2MrFafKVs59mKd5RhDN781c4BKDO2f/tstYFQWAk7ef9lbMC+VX
         n4iCrqINcgklwLrmdjb2Cos54LCdLCcyb7QcM7kuc8FOxBB3fRXTx6Oywwp9h6VWvx1H
         gmRm/yoxs4FAtigFdXUo+yrEGTaUIp6IprhAyYiqEWxZT0n2ymRbF1OSRkd4X0bN1mKN
         Q8lLzK9JQR5AiUsmP3QEDgPcCBrvfMvbWslxDAR9f2LPqkx8z6WvrM0fJwwLD+66SBoo
         r0DkKXC5icFFRcmDxjgHcNqpTjePFGswpj/5G8T1q2ISUiq2aRrWHMGxmYmNFhmRVtu2
         FbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=y5EH+uVVZi4pQVkeOf2HQsE+Jig/HWZWR6VmtoAY/1Y=;
        b=nQqwYycfDnpQMbGLNbqv1tdeR/F07gRcLJGyI6w33eynm9uSVXEIl0H/2RpNuJHd4f
         I/Bdla5wF6WgJYjkGaLRX5rINdBySX/IsnJRAEkz1xsf+lM/EX0FOFbAAa5mw9qIcTV+
         8RdRbqNwEMRPvuNn1fevKmbfio/Jqjv3xVH7+pyyNWq4RtcLSmWLcNp5cgQOh93i5mW0
         N31avohF4maPWEFpRu6FNGhTCgluucOylmtiljCDnncwD51/3HHM0yXeQgruC379rn7g
         KcglpsWCd7EcgKYeKFGdXCedvVomS+p0vwMZcL79VkhhULhnv03h5AL37Wn7JWcKXtCo
         OI4g==
X-Gm-Message-State: APjAAAX/QZyC+FMyKLAV7iqcqXlGaIG4WgzQrU/tfD9L76lLIPdxNNbL
        p0bUA5i6vD1tUTVRrzca543Tqw==
X-Google-Smtp-Source: APXvYqybsW+ELbkjOgVjKbuZyZcQ6XTGYZ1w7r83yiScAbSQwX+IQI76DhcZQtcniQZcwYt7DLwiYg==
X-Received: by 2002:a5d:94d0:: with SMTP id y16mr10862099ior.123.1565219754480;
        Wed, 07 Aug 2019 16:15:54 -0700 (PDT)
Received: from localhost (c-73-95-159-87.hsd1.co.comcast.net. [73.95.159.87])
        by smtp.gmail.com with ESMTPSA id j23sm74215587ioo.6.2019.08.07.16.15.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 16:15:54 -0700 (PDT)
Date:   Wed, 7 Aug 2019 16:15:53 -0700 (PDT)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     Paolo Bonzini <pbonzini@redhat.com>
cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 00/20] KVM RISC-V Support
In-Reply-To: <4a991aa3-154a-40b2-a37d-9ee4a4c7a2ca@redhat.com>
Message-ID: <alpine.DEB.2.21.9999.1908071606560.13971@viisi.sifive.com>
References: <20190807122726.81544-1-anup.patel@wdc.com> <4a991aa3-154a-40b2-a37d-9ee4a4c7a2ca@redhat.com>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 7 Aug 2019, Paolo Bonzini wrote:

> On 07/08/19 14:27, Anup Patel wrote:
> > This series adds initial KVM RISC-V support. Currently, we are able to boot
> > RISC-V 64bit Linux Guests with multiple VCPUs.
> 
> Looks good to me!  Still need an Acked-by from arch/riscv folks if I
> have to merge it, otherwise they can take care of the initial merge.

Since almost all of the patches touch arch/riscv files, we'll plan to 
merge them through the RISC-V tree.  Care to ack patch one, and send tags 
for any other patches as you think might be appropriate?

At the moment we're focused on dealing with a TLB flush-related critical 
stability bug in RISC-V kernel land.  Once that gets cleared up, we'll 
start pulling stuff in for the merge window.

Thanks for the speedy review,


- Paul
