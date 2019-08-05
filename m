Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097D3818EE
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 14:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbfHEMNm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 08:13:42 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38053 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727553AbfHEMNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 08:13:41 -0400
Received: by mail-wm1-f65.google.com with SMTP id s15so51422837wmj.3
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 05:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0wxhgVqa1i5HebLBuhj43emhxcpL4j6myhHfva4riI0=;
        b=D9rI32DitY/CLc62d2LYXuif0Sbwy/BVZgEu6va3gBgeD8+1ddHIfdW7ic1Zh2gEhq
         W44Qc3nNnlpInYGMKMRkxAcobDCOl3hPWqCvlhgC7zWJKahoO7xyygJx7raDpU3RdEHL
         9vMB9ahaW6qDtb29DKRiWz5r+OL6qvF+gUoOahe7ndwA6mWCAzaAuzjivLCFSWILYRVF
         jvGOFLNavph0BxW02G76lSInbZ60CNfUihG89FP99cZxyY2eZNJ8132Qz2EzW3pgj9Mj
         esX4XUebXFy3HmJ4zOxgr5B5FJn+vD5Vv9WbihVVGNAGfERb5klJIdJL86Tfaz2mIzne
         Xwkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0wxhgVqa1i5HebLBuhj43emhxcpL4j6myhHfva4riI0=;
        b=JJLW5w/i4uRRvy0dqGYgVO6kPaVTUgoj3cos51Tv/rSHiCQSHF7cUcbf2nC1hwH5Xt
         4L2lBe72SXdAsTmKLfWjBZ+/fcHC+wbV39VI+RyR7E6gzgaN8Oxfz+uPjnwgD0VPFjHu
         Ml2v43m1W3ETpfPAnqA/Mk2B6QB2cXnTtlaHCoA317f5j+dzId2KlBY4DWqYdnz7Ll8W
         BshoS5k4ZAmHr+Gbtf6NTXYKrigklwrwANiHJwAZ4p1Zbabk51aJz60GIXrz7luR7w6C
         BoqQFdWBJ8GT+p03M91ZHdnW9bi2a5CcjffCtTGRLJVCFEZe2ZfIPM3vDXSdVzVaZHmq
         mFoA==
X-Gm-Message-State: APjAAAW8psBcNUDRHWZYdIw2FYYYgZjKGXo5ioOXsMrvASyRwdo94fkA
        rFCTvgtYE+bvY3jQP0oricqo4gs+/haCGB9WLEwSPw==
X-Google-Smtp-Source: APXvYqzTS/w3xceeGnXPkz2ziZ/qExTBJtgjboccYQd7cdW0Ah42GE9a/wIpMA5BQWIqpCVbIOmkP50fin5L4WuSmpo=
X-Received: by 2002:a05:600c:254b:: with SMTP id e11mr17300244wma.171.1565007219377;
 Mon, 05 Aug 2019 05:13:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190802074620.115029-1-anup.patel@wdc.com> <20190802074620.115029-8-anup.patel@wdc.com>
 <edbed85f-f7ad-a240-1bef-75729b527a69@de.ibm.com> <CAAhSdy2PDSpTy1JEEC2LCB4ESvZHBbkVEZ2wqz-D2b7SKD5VSg@mail.gmail.com>
 <09417197-36e8-718f-f106-29466ef406e3@redhat.com>
In-Reply-To: <09417197-36e8-718f-f106-29466ef406e3@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 5 Aug 2019 17:43:27 +0530
Message-ID: <CAAhSdy1tfL6uLeXANzuZLidg9E-YTUfDQU7zxhBz1_AH+BvZaA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 07/19] RISC-V: KVM: Implement KVM_GET_ONE_REG/KVM_SET_ONE_REG
 ioctls
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Anup Patel <Anup.Patel@wdc.com>,
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

On Mon, Aug 5, 2019 at 5:31 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 05/08/19 13:56, Anup Patel wrote:
> > We will certainly explore sync_regs interface. Reducing exits to user-space
> > will definitely help.
>
> sync_regs does not reduce exits to userspace, it reduces ioctls from
> userspace but there is a real benefit only if userspace actually makes
> many syscalls for each vmexit.

Thanks, got it.

Regards,
Anup
