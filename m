Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583EB4E87CD
	for <lists+kvm@lfdr.de>; Sun, 27 Mar 2022 14:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbiC0Msg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 08:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbiC0Msf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 08:48:35 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBC2433BC
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 05:46:54 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id p10so14629449lfa.12
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 05:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+Po5H3u33NVDjq5XuznsSKSE8osOGQmkJBE/XbOGny4=;
        b=ZLxe0fFbPFwrNzDdBRqPD08ww3o8DqnadhJJwIV/N7Q1s0OkAuoPnw9aEK1VAOVTyh
         d6IGahbofmOUJLSPCzcqVmVdmjX3n7BHAFnRIZnJsY6ybiYtxCiLh08vs/hpXGHQOEAw
         2XYAZu+0hYCIdiO+jwRfksdAyfBNolpRtDxK2W+Puc65lzhdpCpogGPYxFL6f/NiQWPw
         1SA8eFXpBdy5X7sR/HL3SDueBL+ix0OpU40fcWg4Y7WUk7eiOSU52iiMKySgdXXlaGLA
         mWaK42xWj6gmR125P/RztZdo32tidMJ26rl84YN3jAMehbrIWHHvOYi2BtUStPe0x+uu
         eNTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+Po5H3u33NVDjq5XuznsSKSE8osOGQmkJBE/XbOGny4=;
        b=mZ2osKr2abhv0ldkapoMLSmDpiDWfa9KkM0QEiDVjX74vevTjYz+g0cshCH8DMkok8
         UOa2QW5Zvq+KIqc0qD29rYzXaFpDwp0WixDzlEIG17oH8R02BPle8PHDuytwTztldVAO
         Dhs+qp6KxwAbRq1Cweq2SKWUu/jvr/O0OHcLUOxAZ8D2nEGGRDwGlhXswjJlVv7Pzbkx
         VNTXysdKNfrKSTri30Z+PB+bExauhpnuSQrWUrJkuMSpsvulhwmlnQ/U/CpT5u674zei
         Khe2NrP/BHDbhiGRePQeB0q3g7f4joQExYR/+J/dpLdAR/tFeP+HjkA8sst+XPuTlixC
         Y7Ww==
X-Gm-Message-State: AOAM531Zk7p++YR3ZiM3vMoqVcwgpcMz/hpaP8MnarlrCIqOsOCNd0an
        d9osLT76VQM2411XqmHfpDiz/wJZZcgg9g==
X-Google-Smtp-Source: ABdhPJyxEkFp5oM1du/if9BeikzX9EtRKF+h0x/U/mh36CzyQYk3aNgMSMQr8onVMEct00nvJmOOWQ==
X-Received: by 2002:a05:6512:3c92:b0:448:5062:268 with SMTP id h18-20020a0565123c9200b0044850620268mr15956285lfv.84.1648385212967;
        Sun, 27 Mar 2022 05:46:52 -0700 (PDT)
Received: from sisu-ThinkPad-E14-Gen-2 (88-115-234-153.elisa-laajakaista.fi. [88.115.234.153])
        by smtp.gmail.com with ESMTPSA id bp3-20020a056512158300b0044318361eedsm1363422lfb.204.2022.03.27.05.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 05:46:52 -0700 (PDT)
Date:   Sun, 27 Mar 2022 15:46:51 +0300
From:   Martin Radev <martin.b.radev@gmail.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org,
        will@kernel.org, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH v2 kvmtool 0/5] Fix few small issues in virtio code
Message-ID: <YkBcuwMi7gPy9Wew@sisu-ThinkPad-E14-Gen-2>
References: <20220303231050.2146621-1-martin.b.radev@gmail.com>
 <YioRnsym4HmOSgjl@monolith.localdoman>
 <20220311112321.2f71b6bd@donnerap.cambridge.arm.com>
 <Yi926JwV50u86yRB@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yi926JwV50u86yRB@monolith.localdoman>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for the explanation and suggestion.
Is this better?

From 4ed0d9d3d3c39eb5b23b04227c3fee53b77d9aa5 Mon Sep 17 00:00:00 2001
From: Martin Radev <martin.b.radev@gmail.com>
Date: Fri, 25 Mar 2022 23:25:42 +0200
Subject: kvmtool: Have stack be not executable on x86

This patch fixes an issue of having the stack be executable
for x86 builds by ensuring that the two objects bios-rom.o
and entry.o have the section .note.GNU-stack.

Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
---
 x86/bios/bios-rom.S | 5 +++++
 x86/bios/entry.S    | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/x86/bios/bios-rom.S b/x86/bios/bios-rom.S
index 3269ce9..d1c8b25 100644
--- a/x86/bios/bios-rom.S
+++ b/x86/bios/bios-rom.S
@@ -10,3 +10,8 @@
 GLOBAL(bios_rom)
 	.incbin "x86/bios/bios.bin"
 END(bios_rom)
+
+/*
+ * Add this section to ensure final binary has a non-executable stack.
+ */
+.section .note.GNU-stack,"",@progbits
diff --git a/x86/bios/entry.S b/x86/bios/entry.S
index 85056e9..1b71f89 100644
--- a/x86/bios/entry.S
+++ b/x86/bios/entry.S
@@ -90,3 +90,8 @@ GLOBAL(__locals)
 #include "local.S"
 
 END(__locals)
+
+/*
+ * Add this section to ensure final binary has a non-executable stack.
+ */
+.section .note.GNU-stack,"",@progbits
-- 
2.25.1

On Mon, Mar 14, 2022 at 05:11:08PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Fri, Mar 11, 2022 at 11:23:21AM +0000, Andre Przywara wrote:
> > On Thu, 10 Mar 2022 14:56:30 +0000
> > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi,
> > 
> > > Hi Martin,
> > > 
> > > On Fri, Mar 04, 2022 at 01:10:45AM +0200, Martin Radev wrote:
> > > > Hello everyone,
> > > >   
> > > [..]
> > > > The Makefile change is kept in its original form because I didn't understand
> > > > if there is an issue with it on aarch64.  
> > > 
> > > I'll try to explain it better. According to this blogpost about executable
> > > stacks [1], gcc marks the stack as executable automatically for assembly
> > > (.S) files. C files have their stack mark as non-executable by default. If
> > > any of the object files have the stack executable, then the resulting
> > > binary also has the stack marked as executable (obviously).
> > > 
> > > To mark the stack as non-executable in assembly files, the empty section
> > > .note.GNU-stack must be present in the file. This is a marking to tell
> > > the linker that the final executable does not require an executable stack.
> > > When the linker finds this section, it will create a PT_GNU_STACK empty
> > > segment in the final executable. This segment tells Linux to mark the stack
> > > as non-executable when it loads the binary.
> > 
> > Ah, many thanks for the explanation, that makes sense.
> > 
> > > The only assembly files that kvmtool compiles into objects are the x86
> > > files x86/bios/entry.S and x86/bios/bios-rom.S; the other architectures are
> > > not affected by this. I haven't found any instances where these files (and
> > > the other files they are including) do a call/jmp to something on the
> > > stack, so I've added the .note.GNU-Stack section to the files:
> > 
> > Yes, looks that the same to me, actually the assembly looks more like
> > marshalling arguments than actual code, so we should be safe.
> > 
> > Alex, can you send this as a proper patch. It should be somewhat
> > independent of Martin's series, code-wise, so at least it should apply and
> > build.
> 
> Martin, would you like to pick up the diff and turn it into a proper patch? You
> don't need to credit me as the author, you can just add a Suggested-by:
> Alexandru Elisei <alexandru.elisei@arm.com> tag in the commit message. Or do you
> want me to turn this into a patch? If I do, I'll add a Reported-by: Martin Radev
> <martin.b.radev@gmail.com> tag to it.
> 
> I don't have a preference, I am asking because you were the first person who
> discovered and tried to fix this.
> 
> Thanks,
> Alex
> 
> > 
> > Cheers,
> > Andre
> > 
> > > 
> > > diff --git a/x86/bios/bios-rom.S b/x86/bios/bios-rom.S
> > > index 3269ce9793ae..571029fc157e 100644
> > > --- a/x86/bios/bios-rom.S
> > > +++ b/x86/bios/bios-rom.S
> > > @@ -10,3 +10,6 @@
> > >  GLOBAL(bios_rom)
> > >         .incbin "x86/bios/bios.bin"
> > >  END(bios_rom)
> > > +
> > > +# Mark the stack as non-executable.
> > > +.section .note.GNU-stack,"",@progbits
> > > diff --git a/x86/bios/entry.S b/x86/bios/entry.S
> > > index 85056e9816c4..4d5bb663a25d 100644
> > > --- a/x86/bios/entry.S
> > > +++ b/x86/bios/entry.S
> > > @@ -90,3 +90,6 @@ GLOBAL(__locals)
> > >  #include "local.S"
> > > 
> > >  END(__locals)
> > > +
> > > +# Mark the stack as non-executable.
> > > +.section .note.GNU-stack,"",@progbits
> > > 
> > > which makes the final executable have a non-executable stack. Did some very
> > > *light* testing by booting a guest, and everything looked right to me.
> > > 
> > > [1] https://www.airs.com/blog/archives/518
> > > 
> > > Thanks,
> > > Alex
> > > 
> > > > 
> > > > Martin Radev (5):
> > > >   kvmtool: Add WARN_ONCE macro
> > > >   virtio: Sanitize config accesses
> > > >   virtio: Check for overflows in QUEUE_NOTIFY and QUEUE_SEL
> > > >   Makefile: Mark stack as not executable
> > > >   mmio: Sanitize addr and len
> > > > 
> > > >  Makefile                |  7 +++--
> > > >  include/kvm/util.h      | 10 +++++++
> > > >  include/kvm/virtio-9p.h |  1 +
> > > >  include/kvm/virtio.h    |  3 ++-
> > > >  mmio.c                  |  4 +++
> > > >  virtio/9p.c             | 27 ++++++++++++++-----
> > > >  virtio/balloon.c        | 10 ++++++-
> > > >  virtio/blk.c            | 10 ++++++-
> > > >  virtio/console.c        | 10 ++++++-
> > > >  virtio/mmio.c           | 44 +++++++++++++++++++++++++-----
> > > >  virtio/net.c            | 12 +++++++--
> > > >  virtio/pci.c            | 59 ++++++++++++++++++++++++++++++++++++++---
> > > >  virtio/rng.c            |  8 +++++-
> > > >  virtio/scsi.c           | 10 ++++++-
> > > >  virtio/vsock.c          | 10 ++++++-
> > > >  15 files changed, 199 insertions(+), 26 deletions(-)
> > > > 
> > > > -- 
> > > > 2.25.1
> > > >   
> > 
