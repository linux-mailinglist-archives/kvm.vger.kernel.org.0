Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF42D3F179B
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 12:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238447AbhHSLA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 07:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236149AbhHSLA2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 07:00:28 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AD1C061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 03:59:52 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id x5so4157419qtq.13
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 03:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=EsugWTTDfUGR/iwV18ZP09B+tOdxnaU2oLj//CaHEhU=;
        b=Z+pNbXsmTW+9cgSrm4+xVjDEtowzIiiQtKbO/5K0NaqM2aBhPnzpgpFxqeEeH7pHo2
         Q6tVJmVQJewZJ3eRvKcbJYUVUuW/NgLiItLABUmpFZ8byJGXlfDK3wcFL2Z7JiWUozfP
         A8t3n8s4BGplNvF7HkCFb4+Ri0OtNCEnEW3JiNTFPMMX7op+WMF8BhYmoZJIl8iS+s6Z
         lY7v8/sXGz9GxgIDhI1/vIsjxPL4cp6gwUojR3689JuDtayJRx0AeECEd2yY72t7dgid
         k7QScGyZvVC61nAYnP5hw1zTBUj0zdjqBosY37UnEhhuH5EBq7Ps5MH1+HFUvUgwbW0G
         cXJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=EsugWTTDfUGR/iwV18ZP09B+tOdxnaU2oLj//CaHEhU=;
        b=VAzfUNIkDBtbgKyE7utcdIR67Rr9lMhDiDIlAIhQKHHSQMjbkRjHlCVdLSwBXzGRqY
         mhy8SRl12TXgO98ak7tHiLeft3LicymUPyp8H9lAdw0cBrX4w79qt+YMB4bbctqNthFp
         5poUTS4/lGNfqx+P97mKvb/W+ziqPXGxprNHj2POIlRfNzEQkqCb8P/iRV5dy9iMufLv
         5gXG1ytONY2aVCjr1zVy4kxiYDoiC5PVj12it1J2bgaQjfCIVjcmLwdWMmFP/kS9Nfu6
         MRLcN4JdsQJN8bvfG3vzVboY/yetEOcHY55bmYADJUp0iiNHeCeh+ILmZN9QgxrhmfV2
         6pfQ==
X-Gm-Message-State: AOAM532sZV/2FydFzVqWZinhEiYIEI8vdyJHZehAXdIiJW1B4gBgGhDi
        nBUxCBjPejxVko+MxlZ+Xa0g/obqdDSwHSesAes=
X-Google-Smtp-Source: ABdhPJxfDnfrTy5HQ1wNkz4W+4jE/J1lAUCr/rN46VjiVqEmHFniuI5NyxnylIrWTVNbwxa/2+t1QAoBIkippmG9qRw=
X-Received: by 2002:ac8:5417:: with SMTP id b23mr4616068qtq.140.1629370791536;
 Thu, 19 Aug 2021 03:59:51 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a0c:f0d4:0:0:0:0:0 with HTTP; Thu, 19 Aug 2021 03:59:51
 -0700 (PDT)
Reply-To: michellegoodman035@gmail.com
From:   Michelle Goodman <michellegoodman001@gmail.com>
Date:   Thu, 19 Aug 2021 11:59:51 +0100
Message-ID: <CA+jr58qEV5pdexqsnGvbnaYSkXJG07Drjhap-+Mu1dE-RaY8Rw@mail.gmail.com>
Subject: From Michelle
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

16nXnNeV150sINeQ16DXmSDXnten15XXldeUINep16fXmdeR15zXqiDXkNeqINeU15TXldeT16LX
lCDXqdec15kuDQrXkNeg15kg16bXqNeZ15og16rXkteV15HXldeqINee15TXmdeo15XXqg0K16jX
kQ0K16rXldeT15QuDQrXnteZ16nXnA0K
