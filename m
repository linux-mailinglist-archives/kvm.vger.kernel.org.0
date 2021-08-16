Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A6C3ED108
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 11:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235321AbhHPJ1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 05:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235190AbhHPJ1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 05:27:21 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA66C061764
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 02:26:50 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gz13-20020a17090b0ecdb0290178c0e0ce8bso18572779pjb.1
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 02:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to;
        bh=fW30ACZNGZaQxHJRtjgGrm+kXcrdsqkaGpRKMF86Xzk=;
        b=FhRsIW8YZo4+VuY8KwfWRZB/NEvEUcQlc9WwuIZ5mmu5kV0BFuBD+ypChuNNDDEH/4
         JzOOdX7V33cYbvweS1p+CdxiomMoyXJUee5Lrwfk1XAZKrVm5XN+baFhq3ZFZn8PY6d/
         yMTkX7ZoUBo7cusVM3hH03HCtWDBVncYdlpkCjcMPyVIJwM9PsqFcfMXmCqD7pdI8fwC
         mpBE6kQ1JLTOoSY5xQPvHbFgAmHSZ2Ne409YmaG/USpMOXKbl6kVXNVyAwdS3A3hs1mX
         wTAwekcUAhPvAx6j4mcSU1iNYZZeX0AtwXauPb6wWlrhoENPFSCDyWYwFBIoEAr5e/yj
         gsYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to;
        bh=fW30ACZNGZaQxHJRtjgGrm+kXcrdsqkaGpRKMF86Xzk=;
        b=iMQtr1AvT742tK5f24sSragzXLFkRW0cAugBlawljvsxXycCwIxpdkpKzBVbhE+iZU
         ZDPw9kkEJBNfh/nv1NKwuNbM7+lrIO+Z+/uHp/lA/WcnqTq6np+lkgV7B7mjCaJrxoZ7
         OiOZg+ZUWK1vVIc+zJgRy/w7Jal0a5fhWVY1NKNozDdsF7S+SidiWQFPtlkR1Jue0T/+
         gPg/jiNXenL1WrfoUnHlzqnncE9UUJCbML+zTjcWdVdn7yr5ax9hE3z34XDj6gOYyFoB
         Q12wbooxdcAf2SC/i5tIJmlXER+7cqnuPKGgzW1ttQzhTe7jn+35+0bDyjLPVtolAlRA
         /eZA==
X-Gm-Message-State: AOAM5338xL7byXOfgUANtr8FTecz432Mjl8UdhpoNvchFEPmE13QiR15
        tEURTiZhAYm7rgcp72WxA1zxpnc+eDkpAcJcAIo=
X-Google-Smtp-Source: ABdhPJzi51OuTR/dMJ6qXFe8GNrzpReC+LP8qAO4Zu4Y2pIUX2drPxxpf1M3yB2KqmMvrOS0/xqZTDSndGFaD3pYyn4=
X-Received: by 2002:a05:6a00:1c65:b029:3cd:e06d:c0b5 with SMTP id
 s37-20020a056a001c65b02903cde06dc0b5mr15296463pfw.38.1629106010233; Mon, 16
 Aug 2021 02:26:50 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a20:3941:b029:51:5d73:f6db with HTTP; Mon, 16 Aug 2021
 02:26:49 -0700 (PDT)
Reply-To: j8108477@gmail.com
In-Reply-To: <CABAL+xkFcOsq6ysSMZecNkXUmevat-NyLDuL2XSS0LzbJMvdNQ@mail.gmail.com>
References: <CABAL+xkFcOsq6ysSMZecNkXUmevat-NyLDuL2XSS0LzbJMvdNQ@mail.gmail.com>
From:   MR NORAH JANE <adelasarah82@gmail.com>
Date:   Mon, 16 Aug 2021 11:26:49 +0200
Message-ID: <CABAL+xk01kagN-O7Pn-jQMufXueriKjzaossqt4HbrBP5x8PFA@mail.gmail.com>
Subject: Fwd:
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

---------- Forwarded message ----------
From: MR NORAH JANE <adelasarah82@gmail.com>
Date: Mon, 16 Aug 2021 11:24:51 +0200
Subject:
To: adelasarah82@gmail.com

HI, DID YOU RECEIVE MY MAIL?
