Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7553C56549A
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 14:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbiGDMMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 08:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234156AbiGDMMo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 08:12:44 -0400
Received: from smtp2.tsag.net (smtp2.tsag.net [208.118.68.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05DB11A17;
        Mon,  4 Jul 2022 05:12:34 -0700 (PDT)
Received: from linuxfromscratch.org (rivendell.linuxfromscratch.org [208.118.68.85])
        (user=smtprelay@linuxfromscratch.org mech=PLAIN bits=0)
        by smtp2.tsag.net  with ESMTP id 264CCEb3016295-264CCEb5016295
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 4 Jul 2022 06:12:15 -0600
Received: from [192.168.124.21] (unknown [113.140.29.6])
        by linuxfromscratch.org (Postfix) with ESMTPSA id 94E8B1C33A3;
        Mon,  4 Jul 2022 12:12:03 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfromscratch.org;
        s=cert4; t=1656936734;
        bh=GrL/vpguVZ9tP47CYdZCrW41xA+hiKUSJdUUeQWLGpE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References;
        b=cih1+QImaS5HdEMectcuxojxwRTLah2ZFL57ICfKWJvgQEpOF1/UT/N0n+LTwAB87
         zgVYrxsIEzMpjAoI+sLSjNhNYZ8S6EXNRpDplk52OHsliZA7wOwyUZNZadL820INJq
         eY3q1NXW20y6Bgmxv0notT4Xyhlr4pXswC7bF9zz9Ca3GrCRV3I5WKT+cPDDMzOLuQ
         HusFDkbVEZxP7LGcslMs6RjXhPWkeLuEpzszbqewJlkcgfeXlgwl4LK3OJNX1Aslqv
         4b8acQN+j70cUyQ9aKttzbeG2jT2wCtXZKfHp7yINnYUGq5vvPt6YoqF8rVdse9UNj
         GCNBwJzDPhkUQ==
Message-ID: <2ae767b0439133ca4e60885a1843ee72b69adfc5.camel@linuxfromscratch.org>
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
Date:   Mon, 04 Jul 2022 20:11:40 +0800
In-Reply-To: <fddf5ca6-77dc-88f9-c191-7de09717063c@redhat.com>
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
         <61f2e4e2af40cb9d853504d0a6fe01829ff8ca60.camel@linuxfromscratch.org>
         <fddf5ca6-77dc-88f9-c191-7de09717063c@redhat.com>
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

On Mon, 2022-07-04 at 13:04 +0200, Javier Martinez Canillas wrote:
> Hello Xi,
> >=20
> > With CONFIG_SYSFB_SIMPLEFB and CONFIG_FB_SIMPLE enabled, there is no
> > issue.
> >=20
> > I guess it's something going wrong on a "drm -> drm" pass over.=C2=A0 F=
or now
> > I'll continue to use simpledrm with this commit reverted.
> >=20
>=20
> Yes, we need to also cherry-pick b84efa28a48 ("drm/aperture: Run fbdev
> removal before internal helpers") now that the sysfb_disable() patches
> are in v5.19-rc5.

I confirm that cherry-picking b84efa28a48 fixes the issue for v5.19-rc5.
