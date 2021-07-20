Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DB53CFB47
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 15:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239003AbhGTNNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 09:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239242AbhGTNKp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jul 2021 09:10:45 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33CAC0613E2
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 06:50:56 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id l7so26080389wrv.7
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 06:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=sI4lOFqRzupKkYq98Gmd5BUFkdbcZOoG/UvAcZHjLDY=;
        b=QBbwhpFEg138cFF13OlHokR7JOS4muXESJoP0GE8o7KEv35eNms/xuto9Ggx61MJnV
         pv5yMUhlTXtwC0gs7+LZigEVtzx6FeEYFBjFZISkgcMiS1iksMJxxE9AQ75qX/XxMULb
         sMeC2UURwOTw9xD6wYT2FjKji3DINZHhYE1LY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=sI4lOFqRzupKkYq98Gmd5BUFkdbcZOoG/UvAcZHjLDY=;
        b=OUrhfpqUvL4ROyXCNydK1AVjckdEr0w4IFF3XcWOLYkHRjIRBOQiNtclWqMaDKv0BA
         rgt2XdNH29+u70wBFWxEBDiV2fbm0o6qKybxMalSqmaseq9iMcbPKuFfI1DPPNaPCeki
         mu+BGKbepYvMZMxfa8MZxIyibhq4rUBiJ1e8ZHwZTPb2qXa3BsIxquBJjph5TwnAsAgL
         C3xAxT0Dp+z+RqiTH/y0i/k3N2SZ4nPoylpLqsK8EK9Qjz85V7ym3X7sUsWaiYJQQeXK
         8N4cwDpxTupuKEhKb+prXlY8QeDG8Rz6gD1oH5D/RY7E/s7KqyUQ80/rTjVrOcKzd1h7
         LOiw==
X-Gm-Message-State: AOAM530aKEE2fW/c2Rcy6zQe8xDozPbIcDLB1vbGNfZNcyCmKwvxNXJ7
        1vb5UFhEgs1afaoUGteqOJx5DQ==
X-Google-Smtp-Source: ABdhPJxQV3Ee2pwcwbIe/vS8ucyfghhnzHjKP4KrgLfr14bAgT3gr9xSuwjFXjaR+rGwh3KUvvzTOA==
X-Received: by 2002:adf:c803:: with SMTP id d3mr30463317wrh.345.1626789055598;
        Tue, 20 Jul 2021 06:50:55 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id f2sm23731613wrq.69.2021.07.20.06.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 06:50:54 -0700 (PDT)
Date:   Tue, 20 Jul 2021 15:50:52 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc:     Christoph Hellwig <hch@lst.de>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/7] vgaarb: remove VGA_DEFAULT_DEVICE
Message-ID: <YPbUvIYmu3WfyM2C@phenom.ffwll.local>
References: <20210716061634.2446357-1-hch@lst.de>
 <20210716061634.2446357-2-hch@lst.de>
 <f171831b-3281-5a5a-04d3-2d69cb77f1a2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f171831b-3281-5a5a-04d3-2d69cb77f1a2@amd.com>
X-Operating-System: Linux phenom 5.10.0-7-amd64 
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 16, 2021 at 09:14:02AM +0200, Christian König wrote:
> Am 16.07.21 um 08:16 schrieb Christoph Hellwig:
> > The define is entirely unused.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I'm not an expert for this particular code, but at least of hand everything
> you do here makes totally sense.
> 
> Whole series is Acked-by: Christian König <christian.koenig@amd.com>

Care to also push this into drm-misc-next since you looked already?
-Daniel

> 
> Regards,
> Christian.
> 
> > ---
> >   include/linux/vgaarb.h | 6 ------
> >   1 file changed, 6 deletions(-)
> > 
> > diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
> > index dc6ddce92066..26ec8a057d2a 100644
> > --- a/include/linux/vgaarb.h
> > +++ b/include/linux/vgaarb.h
> > @@ -42,12 +42,6 @@
> >   #define VGA_RSRC_NORMAL_IO     0x04
> >   #define VGA_RSRC_NORMAL_MEM    0x08
> > -/* Passing that instead of a pci_dev to use the system "default"
> > - * device, that is the one used by vgacon. Archs will probably
> > - * have to provide their own vga_default_device();
> > - */
> > -#define VGA_DEFAULT_DEVICE     (NULL)
> > -
> >   struct pci_dev;
> >   /* For use by clients */
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
