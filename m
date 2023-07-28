Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474647675CA
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbjG1SrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjG1SrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:47:18 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E33ECE;
        Fri, 28 Jul 2023 11:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1690570020; x=1691174820; i=deller@gmx.de;
 bh=TWdhuznP6svLtP2k0AYOc8UJXlgY851VcQeWvocX93E=;
 h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
 b=krow+iMR5z+8TjUZEv8RoCypmJBthFidne0f0Dr087co9p8ukFhHQqXGQvQSdOtPG5r5gZx
 IUtY0CLuZYzzfAgro1Oykyq0ZmZQ3IazP4weRKFewTD2m/FUM9/JWLVl24hMIqhoxNEy31cD+
 Swhuke8JihnXSNJECVgl9O4kL7ANE2nulDrfny5f5Krw6kRiNnA1xY3NYDmVjpojk+M2tha/Z
 9vKyu8OQwhVgDc3d/L1iof/zYX5pdjxJoVgiVBV3abgy9q6ieA5dxTI5rFJB1hFCsQeNwxqPR
 kNPbIhe5phT09iBc2+rVGgcpBBDFZ0lVzpuxw2Yx4trTu7oOSgRQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.159.73]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MHG8m-1qci1s0Q3E-00DDDM; Fri, 28
 Jul 2023 20:47:00 +0200
Message-ID: <c1a4b7c9-50f2-c43f-277d-c2af9ccc0b50@gmx.de>
Date:   Fri, 28 Jul 2023 20:46:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 00/47] fbdev: Use I/O helpers
To:     Thomas Zimmermann <tzimmermann@suse.de>, javierm@redhat.com,
        sam@ravnborg.org
Cc:     linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org
References: <20230728182234.10680-1-tzimmermann@suse.de>
Content-Language: en-US
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <20230728182234.10680-1-tzimmermann@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:mrdzwn1CSRSisnuhJOLPF6uj7/3M6meeGVkXi26o5IsUh8/KUJr
 fI9auGK009NoI2IebwA2FevOwmrdXHJWCtbqV25eeNHK5TScbrMOlDn8eOHihbluto+n/Px
 GK5oiYYdUtwzZ5CaxaVtbyW3Cijg0QluO2wEWEea3vq6BFqL7YUgT5OLU2Zn3PVlT6u8GJH
 uYA4d2+kh6KBNwj845fXg==
UI-OutboundReport: notjunk:1;M01:P0:Y7TGlYt57KE=;VjOBdZNiXYoebbD38ogCLzcHcmZ
 T/LRrNaK7ny5ilMErdZG7X22kX2/ZqAGmq3C6orIMb/nAKIje39DIonJ+B5uSWVF5t0DHE5F7
 pA5MMqbVHMLej5POT52GOB9toBiK4hCCA7S8jS2H/ZQXTUWgq3aePUvUXrz8TvzR8WrviCgoT
 rxmKmubR0ivh6C9WWoPytQDEd9OMD2bGVvKD230ix3xFnheBp0DNH/pYuFc2IDcHJ4dWz9cT+
 woDFW1QSht9QUE56FNC4xUV8k4sumi95pbYH54OOq1MOPbIG2w7YEifXM7W9UljmXHyY6G/Af
 oGHk4dK3WfJNjpfLB+M6QYrkRssRQ6aVSXKfzrpWwJPhIzsOj7AYTFSDGBBGtA3e8HnCzTKT5
 kNBBVKsIuTC1tOjrvZ78Vim0dt7flPhE9kGFHtCZPzMQ4N6j/cZPdiO7sGve6/nqoIZB+IFNU
 wVCk4aMjBnvLxthxkEzHUfIfoRZuS12ShDfuiRL+poxtOEit5HnT/9N7i0aCpEUjD1VyZxO22
 wN0DDidAU/jXhIW+4va+ODz0c9xCkxycPiUcoUCYEeM5G0JLay//34f2AAlPCc70I4+Jf5in+
 OfepmhEqSMh6sIO33HB5IbWQkLVJuKqODckhZA2OmvU5Uc+GkIcra9Jabb8tGFFPbKJjRBY91
 vNJZE1CcxW8RosSXBYFttZSX1BXSQNi/+FfpFbrO2bS9yuHRUQ3d5IDbevy6xEPt+why9Q+R5
 8V37Sq+QfQrO5ZLc+kMok0OV2bpeE6mY9M1IFN3Hm5RO9drKmdLpzIQUb//FJPgOVbqgibJp0
 VK21/ASBIOaLqnKrS9/Fknb7dnY5/HCBsJig9OnS6SYC1HQ4WPuHcIvSgJbz4n5tiyojiOMZG
 tX4h9ZagGGBcrekJKv9JK/qboKnxEC911j58ifgemfSbe91+7eJn0EYA6qx+NSqviE5CcgmhR
 bdxu+Q==
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/28/23 18:39, Thomas Zimmermann wrote:
> Most fbdev drivers operate on I/O memory.

Just nitpicking here:
What is I/O memory?
Isn't it either memory, or I/O ?
I mean, I would never think of the cfb* draw functions under I/O.

> And most of those use the
> default implementations for file I/O and console drawing. Convert all
> these low-hanging fruits to the fb_ops initializer macro and Kconfig
> token for fbdev I/O helpers.

I do see the motivation for your patch, but I think the
macro names are very misleading.

You have:
#define __FB_DEFAULT_IO_OPS_RDWR \
         .fb_read        =3D fb_io_read, \
         .fb_write       =3D fb_io_write

#define __FB_DEFAULT_IO_OPS_DRAW \
         .fb_fillrect    =3D cfb_fillrect, \
         .fb_copyarea    =3D cfb_copyarea, \
         .fb_imageblit   =3D cfb_imageblit

#define __FB_DEFAULT_IO_OPS_MMAP \
         .fb_mmap        =3D NULL /* default implementation */

#define FB_DEFAULT_IO_OPS \
         __FB_DEFAULT_IO_OPS_RDWR, \
         __FB_DEFAULT_IO_OPS_DRAW, \
         __FB_DEFAULT_IO_OPS_MMAP

I think FB_DEFAULT_IO_OPS is OK for read/write/mmap.
But I would suggest to split out __FB_DEFAULT_IO_OPS_DRAW.
Something like:
#define FB_DEFAULT_IO_OPS \
         __FB_DEFAULT_IO_OPS_RDWR, \
         __FB_DEFAULT_IO_OPS_MMAP
#define FB_DEFAULT_CFB_OPS \
         .fb_fillrect    =3D cfb_fillrect, \
         .fb_copyarea    =3D cfb_copyarea, \
         .fb_imageblit   =3D cfb_imageblit

and then add FB_DEFAULT_IO_OPS *and* FB_DEFAULT_CFB_OPS
to the various struct fb_ops in the drivers.

Helge
