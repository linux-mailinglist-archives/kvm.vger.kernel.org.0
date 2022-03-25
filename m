Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C834E758F
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 16:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359441AbiCYPCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 11:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346094AbiCYPCS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 11:02:18 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4D391AF4
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 08:00:44 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id f38so14541842ybi.3
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 08:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ai9I8keYy/A4At0Op3q/8F24bK4ZmjaCZuevio8SeL8=;
        b=yeoB3EDNY60o6uf+FkMzMfhYUb73F5pOpU6jkTzlHPFkcZ0RoEMmZjJUBSb4af6+NH
         ssJCKxTnU5y4EmMWekFC6O+zz+PY4GPxDixkek426vK6hpCPjRhvt47X9JOQIdYEHS2m
         rFm40LWM/780iDQQp/LE6DOhCyhszTtBQEBESI7IHl6wtXioP3lGSBSqJI2KRmk/AKx2
         1E+KEGGGhQQ4bIMCsnAGueCZ5/96cIDXpyojzPpYr+k3sEt8o4VIfQ8Jtp6XkFRp6EKn
         Bjnh1WDoENfnkuDZ8u6BfHw4/Oo1cjeMmEesfAF12wpfZ2MXmG/hs9aOYt53ycOHeecW
         RKjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ai9I8keYy/A4At0Op3q/8F24bK4ZmjaCZuevio8SeL8=;
        b=b0ewbgXRwAloYlh0NFVeCAenkJX2FE0WNrwknYHfoCOwVFWJywOypyMiRZ43o/pOKg
         oSkb0gca2cvxipP4wc3DwU0dxiVo5qM1anxP9VYvj3JghLJMJ1Ci/4eYufL2g1/VJ7/4
         RFm97kFU5OQCJaobVu4mNO6/sNfKYlRqv2k9dGL2BZzd+0M+Lju7Jwcfp2CQvYRxwnZo
         +BTtBg8vgeZGd1UmRZeELR6rARDVYZH5U+7/+JNkOL50AHl+o1vchNEkmPKwHwjiDm/E
         ZUqZWn0Qj1kng3xxJpOMDOJoBWpvA99NPaTRoOl9wA/DsLWq9cEyJEyBt45oDpHuUQTL
         ewfQ==
X-Gm-Message-State: AOAM532WwSCSlsS0AeYX3g8Rmsohog1lI5PyUVgZfdxlv5TA+H/q7Zlr
        zdxIPVf08BkgAs5EAZSGN3k2VDGfOGpPX+0lGc/x0A==
X-Google-Smtp-Source: ABdhPJynVxbhNMzeokBfdlFbxRoEgJ/Se1CUq6k3nOYu/HcSPFDF5J3ci+Th+mlFwDb4Ev+waanCkph46BcbjPkBPxg=
X-Received: by 2002:a25:d8c3:0:b0:633:c81f:737d with SMTP id
 p186-20020a25d8c3000000b00633c81f737dmr9846734ybg.193.1648220441833; Fri, 25
 Mar 2022 08:00:41 -0700 (PDT)
MIME-Version: 1.0
References: <mw2ty4ijin-mw2ty4ijio@nsmail6.0>
In-Reply-To: <mw2ty4ijin-mw2ty4ijio@nsmail6.0>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 25 Mar 2022 15:00:28 +0000
Message-ID: <CAFEAcA_xpi2kCdHK-K=T3-pbHjWS47xyCzG47wg3HBSKFo4z8w@mail.gmail.com>
Subject: Re: Re: [PATCH] kvm/arm64: Fix memory section did not set to kvm
To:     liucong2@kylinos.cn
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 25 Mar 2022 at 14:42, <liucong2@kylinos.cn> wrote:
> I found this issue on qmeu 4.2 with host linux 4.19, I want to
> use qxl on arm64. on arm64, default page size is 64k, and the
> qxl_rom_size is fixed 8192.

OK, so the fix to this is "use a newer QEMU".

> but when I read qxl_rom region in guest, guest os stopped and
> I can see error message "load/store instruction decodeing not
> implemented" in host side. it is because qxl rom bar memory
> region didn't commit to kvm.

> I only try qemu 6.0 rather than the latest version because
>
> I meet some compile issue. commit ce7015d9e8669e
>
> start v6.1.0-rc0, it will change the default qxl rom bar size
> to 64k on my platform. then my problem disappear. but when
> others create a memory region with the size less than one
> page. when it run into kvm_align_section, it return 0
> again.

This is correct behaviour. If the memory region is less than
a complete host page then it is not possible for KVM to
map it into the guest as directly accessible memory,
because that can only be done in host-page sized chunks,
and if the MR is a RAM region smaller than the page then
there simply is not enough backing RAM there to map without
incorrectly exposing to the guest whatever comes after the
contents of the MR.

For memory regions smaller than a page, KVM and QEMU will
fall back to "treat like MMIO device access". As long as the
guest is using simple load/store instructions to access the
memory region (ie loading or storing a single general
purpose register with no writeback, no acquire/release
semantics, no load-store exclusives) this will work fine.
KVM will drop out to QEMU, which will do the load or store
and return the data to KVM, which will simulate the instruction
execution and resume the guest.

If you see the message about "load/store instruction
decoding not implemented", that means the guest was trying
to access the region with something other than a simple
load/store. In this case you need to either:
 (1) change the device model to use a page-sized memory region
 (2) change the guest to use a simple load/store instruction
     to access it

Which of these is the right thing will depend on exactly
what the device and memory region is.

thanks
-- PMM
