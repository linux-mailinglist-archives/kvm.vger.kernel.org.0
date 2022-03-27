Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162C04E8A22
	for <lists+kvm@lfdr.de>; Sun, 27 Mar 2022 23:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbiC0VCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 17:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiC0VCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 17:02:13 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B0D49258
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 14:00:33 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id b43so12218316ljr.10
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 14:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=chsnq/nujMy3vb6B1IKxnwB4dvw4Pqt1lxeQPWHEX5E=;
        b=J4XdYoMv5nf20ewqSMQ252okJsssGv7fZ2LYfpUYHxq8ilduAQwRBqrVApPXUYecsX
         /ukIQyj/eoApeh7FbB/3bxPBHgWeFTyEv5zz8KD6Gu8QVA1mwmqU1+8L7E41s2hng3SD
         x1CgLcPYIdPwrvXapGeUMkcwJEJr2qkYT5hy9B/+IFnw809HbzOc8/d+nKwe8ljYtwNn
         683wmd+ffoBj/LPypqvQoZa3IaqRhnEETwdNpEm5iSawIXHAbhK6o7NR25ifPBeL9u+4
         yfRBQ3mUwCee92FoI9sdQ7146grSSs7IOBCsUsdWk2rQyRTHJs8mReF58qjdGClFjKu8
         JYgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=chsnq/nujMy3vb6B1IKxnwB4dvw4Pqt1lxeQPWHEX5E=;
        b=CbtMO1b+jNXVP5W9b4Nqghl5gRbSvmiU0+xWxxEDKvTDtZ4Sm4ytAkwLqC0g2XoUoF
         cA5UPWDYlieBHOtTCZ4p2F1CSbHGPEnebyOSfjREdQEF8TQvYYIPy+XvJmRXnoX9gAFS
         iXDV8jQ3nzSKuzdIvWpGQcCiBDbqknkHTl78jr23DDC8QVWY72O/IpcDl1BD1vuJ04l/
         HJ6JOAxEH/2SUD2fSnoNfU8DModsicWhNr4tV3vjV4qpK4rkvCvjMI1a25OCJ/KQtgfI
         PUwy9U1Rn39+AsRbmivmHQKEZU08IpCyxlICO1xhDuzvOn702r0MSBwEA4LpR5A/BiTG
         fzzQ==
X-Gm-Message-State: AOAM533HAI/caz/7mCDiWH7NGK2rLsqV2kcEtZ8sWvTAHspXOk4NfJ5b
        oOZASHScz6vIwcDxqwpiFuU=
X-Google-Smtp-Source: ABdhPJwfjWKLu8B0dKVc8PLXzxHUPRMb7fW1Og5hXNYgmXg85iw/TvoKazVQk7yXljtfNh3FndH05A==
X-Received: by 2002:a05:651c:199f:b0:249:668c:e3b3 with SMTP id bx31-20020a05651c199f00b00249668ce3b3mr17572763ljb.119.1648414832406;
        Sun, 27 Mar 2022 14:00:32 -0700 (PDT)
Received: from sisu-ThinkPad-E14-Gen-2 (88-115-234-153.elisa-laajakaista.fi. [88.115.234.153])
        by smtp.gmail.com with ESMTPSA id bt23-20020a056512261700b0044400161095sm1450606lfb.168.2022.03.27.14.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 14:00:32 -0700 (PDT)
Date:   Mon, 28 Mar 2022 00:00:30 +0300
From:   Martin Radev <martin.b.radev@gmail.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com
Subject: Re: [PATCH kvmtool 5/5] mmio: Sanitize addr and len
Message-ID: <YkDQbtdFvZteTByI@sisu-ThinkPad-E14-Gen-2>
References: <20220303231050.2146621-1-martin.b.radev@gmail.com>
 <20220303231050.2146621-6-martin.b.radev@gmail.com>
 <YjIEyxwAPw2c2fdM@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjIEyxwAPw2c2fdM@monolith.localdoman>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks Alex.

I needed to make a small update to the patch as you recommented in one
of the other emails. I still kept the reviewed by line with your name.

From 090f373c0bc868cc4551620568d47b21b6ac044a Mon Sep 17 00:00:00 2001
From: Martin Radev <martin.b.radev@gmail.com>
Date: Mon, 17 Jan 2022 23:17:25 +0200
Subject: [PATCH kvmtool 2/6] mmio: Sanitize addr and len

This patch verifies that adding the addr and length arguments
from an MMIO op do not overflow. This is necessary because the
arguments are controlled by the VM. The length may be set to
an arbitrary value by using the rep prefix.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
---
 mmio.c        | 4 ++++
 virtio/mmio.c | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/mmio.c b/mmio.c
index a6dd3aa..5a114e9 100644
--- a/mmio.c
+++ b/mmio.c
@@ -32,6 +32,10 @@ static struct mmio_mapping *mmio_search(struct rb_root *root, u64 addr, u64 len)
 {
 	struct rb_int_node *node;
 
+	/* If len is zero or if there's an overflow, the MMIO op is invalid. */
+	if (addr + len <= addr)
+		return NULL;
+
 	node = rb_int_search_range(root, addr, addr + len);
 	if (node == NULL)
 		return NULL;
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 875a288..979fa8c 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -105,6 +105,12 @@ static void virtio_mmio_device_specific(struct kvm_cpu *vcpu,
 	struct virtio_mmio *vmmio = vdev->virtio;
 	u32 i;
 
+	/* Check for wrap-around and zero length. */
+	if (addr + len <= addr) {
+		WARN_ONCE(1, "addr (%llu) + length (%u) wraps-around.\n", addr, len);
+		return;
+	}
+
 	for (i = 0; i < len; i++) {
 		if (is_write)
 			vdev->ops->get_config(vmmio->kvm, vmmio->dev)[addr + i] =
-- 
2.25.1

On Wed, Mar 16, 2022 at 03:39:55PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Fri, Mar 04, 2022 at 01:10:50AM +0200, Martin Radev wrote:
> > This patch verifies that adding the addr and length arguments
> > from an MMIO op do not overflow. This is necessary because the
> > arguments are controlled by the VM. The length may be set to
> > an arbitrary value by using the rep prefix.
> > 
> > Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
> 
> The patch looks correct to me:
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> Thanks,
> Alex
> 
> > ---
> >  mmio.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/mmio.c b/mmio.c
> > index a6dd3aa..5a114e9 100644
> > --- a/mmio.c
> > +++ b/mmio.c
> > @@ -32,6 +32,10 @@ static struct mmio_mapping *mmio_search(struct rb_root *root, u64 addr, u64 len)
> >  {
> >  	struct rb_int_node *node;
> >  
> > +	/* If len is zero or if there's an overflow, the MMIO op is invalid. */
> > +	if (addr + len <= addr)
> > +		return NULL;
> > +
> >  	node = rb_int_search_range(root, addr, addr + len);
> >  	if (node == NULL)
> >  		return NULL;
> > -- 
> > 2.25.1
> > 
