Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077CD56524D
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 12:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbiGDK3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 06:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbiGDK3m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 06:29:42 -0400
Received: from smtp2.tsag.net (smtp2.tsag.net [208.118.68.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93C526EF;
        Mon,  4 Jul 2022 03:29:41 -0700 (PDT)
Received: from linuxfromscratch.org (rivendell.linuxfromscratch.org [208.118.68.85])
        (user=smtprelay@linuxfromscratch.org mech=PLAIN bits=0)
        by smtp2.tsag.net  with ESMTP id 264ATNkm015395-264ATNko015395
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 4 Jul 2022 04:29:23 -0600
Received: from [192.168.124.21] (unknown [113.140.29.6])
        by linuxfromscratch.org (Postfix) with ESMTPSA id 818531C337B;
        Mon,  4 Jul 2022 10:29:18 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfromscratch.org;
        s=cert4; t=1656930563;
        bh=7SlvoAQAjYIET8FUv/TvZB/zr4/2kz6Ntmih+ixegRU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References;
        b=Rs2RuGSRH+CHTLOWW5eDWDfS/3EN8u+a1+sbyEtoHwdTImGUqeS3N5SdZ1XVh9QkH
         nS8z6ia/k27GR5pTeFY2RzigZX0NZgtL+EMR1BKvf9wqN0G5jOgTy8gVR2MhONDCDj
         URBUO4UY/z8WWpCQwnHM7s3DOrmEqV9N9WoLGFqM9QiPrPUrVB0+zjolP5Uv/ObMZE
         7SML8FxBKkY7dqpCEbUrYOx8c6WKSY/TXAUgOc+VG0wr0dcKmS4TiE4H0Foh7/jw3m
         bGjmyvfZVx8NLiatbmx7CjueUftxyrgSrpOqhO6cWdEHi1+HBLcmjdL8TBKyLNODCa
         QXBAl5bxWhMQQ==
Message-ID: <61f2e4e2af40cb9d853504d0a6fe01829ff8ca60.camel@linuxfromscratch.org>
Subject: Re: [PATCH v6 3/5] fbdev: Disable sysfb device registration when
 removing conflicting FBs
From:   Xi Ruoyao <xry111@linuxfromscratch.org>
To:     Javier Martinez Canillas <javierm@redhat.com>,
        Zack Rusin <zackr@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "deller@gmx.de" <deller@gmx.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Linux-graphics-maintainer <Linux-graphics-maintainer@vmware.com>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "tzimmermann@suse.de" <tzimmermann@suse.de>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "lersek@redhat.com" <lersek@redhat.com>
Date:   Mon, 04 Jul 2022 18:29:00 +0800
In-Reply-To: <64c753c98488a64b470009e45769ceab29fd8130.camel@linuxfromscratch.org>
References: <20220607182338.344270-1-javierm@redhat.com>
         <20220607182338.344270-4-javierm@redhat.com>
         <de83ae8cb6de7ee7c88aa2121513e91bb0a74608.camel@vmware.com>
         <38473dcd-0666-67b9-28bd-afa2d0ce434a@redhat.com>
         <603e3613b9b8ff7815b63f294510d417b5b12937.camel@vmware.com>
         <a633d605-4cb3-2e04-1818-85892cf6f7b0@redhat.com>
         <97565fb5-cf7f-5991-6fb3-db96fe239ee8@redhat.com>
         <711c88299ef41afd8556132b7c1dcb75ee7e6117.camel@vmware.com>
         <aa144e20-a555-5c30-4796-09713c12ab0e@redhat.com>
         <64c753c98488a64b470009e45769ceab29fd8130.camel@linuxfromscratch.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 
MIME-Version: 1.0
X-FEAS-Auth-User: smtprelay@linuxfromscratch.org
X-FEAS-DKIM: Valid
Authentication-Results: smtp2.tsag.net;
        dkim=pass header.i=@linuxfromscratch.org;
        dmarc=pass header.from=linuxfromscratch.org
X-FE-Policy-ID: 0:14:3:linuxfromscratch.org
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-07-04 at 17:36 +0800, Xi Ruoyao wrote:

> > Yes, please do. Either with CONFIG_SYSFB_SIMPLEFB disabled and CONFIG_F=
B_EFI
> > enabled (so that "efi-framebuffer" is registered and efifb probed) or w=
ith
> > CONFIG_SYSFB_SIMPLEFB but CONFIG_FB_SIMPLE enabled (so "simple-framebuf=
fer
> > is used too but with simplefb instead of simpledrm).
> > =C2=A0
> > I'm not able to reproduce, it would be useful to have another data poin=
t.
>=20
> Also happening for me with CONFIG_SYSFB_SIMPLEFB, on a Intel Core i7-
> 1065G7 (with iGPU).
>=20
> Reverting this commit on top of 5.19-rc5 "fixes" the issue.

With CONFIG_SYSFB_SIMPLEFB and CONFIG_FB_SIMPLE enabled, there is no
issue.

I guess it's something going wrong on a "drm -> drm" pass over.  For now
I'll continue to use simpledrm with this commit reverted.
