Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A4B6D5564
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 02:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjDDAIZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 20:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDDAIY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 20:08:24 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C6C3ABC
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 17:08:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f66-20020a255145000000b00b714602d43fso30727950ybb.10
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 17:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680566902;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W5K/I8dh64Blb5yqarPknay3Q+5JbSm0DRYBSIy4qmQ=;
        b=BRo3YUkjsSLi3rfzm+/Te0GMQ4KxInH3c6ldmeTiSqtQsQuXqYpsFOpn91YhgsGgS6
         xYdEgFIxZMrFW9OjogK5qiOZ3hsMHDLVbCv4LzYX/PKnG78Ouvai4zDDF2eWO0WBFF9o
         Qmk3s9ypQVlmOA0N4I189AbMQx2+pUwarwkBlp+znnsf5+lDo5siRC/nhSwUc8xE3d+E
         7ubG9yNsYuXmSUJDirfxOVAkX+tj1U3DV8gIF+LSJxJzyHVopQUzPg+KiwOUP8iaO39q
         qXA5lS8xFXNLIdNu0hIWnjvE3mm0Sx0NEU9BWZVp7OYA5eLB7VWLN1LVn90iRaGIexaq
         u89Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680566902;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W5K/I8dh64Blb5yqarPknay3Q+5JbSm0DRYBSIy4qmQ=;
        b=HIbQILma4aojsCl/lfHSowCKt3SZrK/FrBHTZLVZ4XbjfNKFfoHKkHNp8gj7H8cAB8
         6LsdYxQH55tNUUxxthh/9+pny3JcSorjhd7cibX1PkWJn72DQy/jO703XamHmRrmj78r
         FvPvzVLbdvbLuQ5ZPNnb1iXNvsHKbktLVMGCHT+43Su1gkfAoYx4Ss8rGZpMmCF6xbMV
         UYMW/ZY7aM+MRgZ+vv+Op+mvWW7D9VtGPPf+rq0qWFFrhIyjn9F0emknoOYpYidPpliX
         e6u9IXl/KeKo8V0r0wtDn9SMzYD31X89JOaGP+FdBf++oFmQm4IHejKWxvbRIaIuK19A
         1oXg==
X-Gm-Message-State: AAQBX9clppvDcGUZXGZlHV0VZR96nD5QeQ5TYNmmTFUrf1MkEPRJ1qtX
        n1sTLLe9S0oQxo9oRe+rM1PN/4PlAmc=
X-Google-Smtp-Source: AKy350b2CwvV7fFpDxDXW+FxLVsRQYRW5ja4kS6Qhb26U9DTSmx2rF2jIn8p3t4FENLx99Tfoobb2/QLAMI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:70e:b0:545:1d7f:acbf with SMTP id
 bs14-20020a05690c070e00b005451d7facbfmr379315ywb.10.1680566902497; Mon, 03
 Apr 2023 17:08:22 -0700 (PDT)
Date:   Mon, 3 Apr 2023 17:08:21 -0700
In-Reply-To: <4f77d3a6-ed17-051e-5aa3-17fc3ab6dc7f@grsecurity.net>
Mime-Version: 1.0
References: <20230403105618.41118-1-minipli@grsecurity.net>
 <20230403105618.41118-4-minipli@grsecurity.net> <dc285a74-9cce-2886-f8aa-f10e1a94f6f5@grsecurity.net>
 <ZCsjp0666b9DOj+n@google.com> <4f77d3a6-ed17-051e-5aa3-17fc3ab6dc7f@grsecurity.net>
Message-ID: <ZCtqdYRIeaCZOwT3@google.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/4] x86/access: Forced emulation support
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 03, 2023, Mathias Krause wrote:
> On 03.04.23 21:06, Sean Christopherson wrote:
> > Keeping KVM-Unit-Tests and KVM synchronized on the correct FEP value would be a
> > pain, but disconnects between KVM and KUT are nothing new.
> 
> Nah, that would be an ABI break, IMO a no-go. What I was suggesting was
> pretty much the patch: change selective users in KUT to make them
> objdump-friendly. The FEP as-is is ABI, IMO

I would be amazed if anything other that KVM's own tests utilizes the feature.
IMO, it really shouldn't be considered ABI.

Paolo?
