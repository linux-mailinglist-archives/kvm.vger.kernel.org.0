Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD98262FCC6
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 19:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242822AbiKRSaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 13:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242762AbiKRS3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 13:29:30 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982B22495A
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 10:28:50 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id y16so10513873wrt.12
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 10:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4WBwOKgli7ksNpP8U2lhKas5gIvwRYcTwcTiGo2sTNQ=;
        b=R+gvKcDBoMwkE1jow4kxuLl/wCVu5SAMyCwsJ9a3QhteMWJ4JTwVOj8GOGLBuwXJSD
         UVRYDRq2T8nUEXIsljmR0dBtu8tdxqIoOZSUjtYnJ1mtV+OMHMdonDch0oTob33pz4NT
         VVM+JW1XBp6UDB+BPM7lmJXg+jAfyQHQpxy2XNs49HQrGROS7hv9IKTnuYcYLKaeD9yP
         A4H7i5/3iBEVVLfh14QkuliO76OV73CoZPRzSdfgDOxozc0fHQrOxbdx7J+fFemDGeuV
         AHMoOzoN69h3HQbpcMDO8fBiNvX+8diybqvufZBVJN5tqc9wEwpnhb8BV2/9D2TBKaM/
         Cv8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4WBwOKgli7ksNpP8U2lhKas5gIvwRYcTwcTiGo2sTNQ=;
        b=HVrn0LXybZ9l9mpma3xptFF5pIJstVjZRVw/VWqma5oaL/1uGAcP0hkY9k830dgmia
         nn5JxEZ1v+y/zUfTjTReMh9DDoLW8ltxcKyfpptqLBAeaYSEKdP/R+nBtK668afGYYXd
         44ej5fvyQIe0OnhH4kxu1uHNdMkDdL4khTbfIi38vPQkqIyKl5AAXzDUpJZv1ck6N/Ek
         /EjUUWeT80YjAv1fXX+e3BBfGO8/iVuAJusCGLr+klGO9id3CcLe2XWjoJwM/OJ6RkT6
         4pViC1cDFpnIlGkdgaJotAOvyCyzYnHj8nDW0fbfYJLPOZgLc74GZ8v9xolp3zf4GV4M
         C0Bw==
X-Gm-Message-State: ANoB5pl6x+5JtgChsxhYtsvnzoBfi0RmOVISVkzB6ydBB7HGzY88dw13
        b2zAii1glesRHk0GgQdy3tFhF809JBQM13KRcQ91jw==
X-Google-Smtp-Source: AA0mqf75vOuCtXRDQ351lDpcagmILy0ETKHwRwUgUgVleSEn9/n6NopTaB/ZapS7v67nfaj/OfnbzkywjalZS7tXePs=
X-Received: by 2002:adf:f9d0:0:b0:236:5967:eb9f with SMTP id
 w16-20020adff9d0000000b002365967eb9fmr5054089wrr.451.1668796129024; Fri, 18
 Nov 2022 10:28:49 -0800 (PST)
MIME-Version: 1.0
References: <89e2e3f9-ad89-3581-4460-f87f552d08a5@redhat.com>
In-Reply-To: <89e2e3f9-ad89-3581-4460-f87f552d08a5@redhat.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 18 Nov 2022 10:28:12 -0800
Message-ID: <CAHVum0cMOzWvG7-OyRbZDrd+Q_VQk44rf-88fee4TBPuwnx2eA@mail.gmail.com>
Subject: Re: KVM 6.2 state
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Fri, Nov 18, 2022 at 10:16 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>
> These are the patches that are still on my list:
>
> * https://patchew.org/linux/20221105045704.2315186-1-vipinsh@google.com/
> [PATCH 0/6] Add Hyper-v extended hypercall support in KVM
>

I will be sending a v2 for this series. I am waiting for Vitaly's
https://lore.kernel.org/kvm/20221101145426.251680-1-vkuznets@redhat.com/
to appear on KVM queue.
