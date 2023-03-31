Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDF766D1976
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 10:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbjCaIKr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 04:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCaIKq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 04:10:46 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C20B269A
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 01:10:46 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-54184571389so401463787b3.4
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 01:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680250245;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PNRI+9UOHo4ApjZu/9+Q+v0qx9rcywYnvROqdYlOEko=;
        b=Awbjz97RucNICaJWawGA5XhfDI3hevh6Y17YriKvred44A8VOMcIVCAEnswBuC1dWT
         HHDqJwbjRQrgHmata1CGLvVEyKoW2mMS9x/TvzKhHtoxe1Qlb0QiGdLiFsrZh5Yr2jIT
         XppUDXaKg/xetjp6N/fNdKdoHrsrutTeNt07rdW+ylSGaOCVKQwZQU6n57yqNG/hgRov
         dZ/4mAwJmjBlI445MSGpLVJMzreMYt+lxjL9DFIRsal6zf5WmVF+JYFB27N6ifBm9Wzo
         fkdtU3CltzU/4dyDVJwsaVSfkCbK4nzWoS8GlUinJq3SgJ8jAYdg5WHC9kRivPEA7U8j
         lTUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680250245;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PNRI+9UOHo4ApjZu/9+Q+v0qx9rcywYnvROqdYlOEko=;
        b=3QwnHSa5I0XO7X8LmVBt9IjJymjaL536HOmXHt4s+hKO7LKwgN80nD41+RRVTXq/Tg
         zdpGMHU83EhBzrt2DNp56arOcYtypBDRtJ5TIdUDDyYQP5Bo4PtQauXfSZAnuUCFRJ/z
         FAdegYNyqqWtAtaMNQ7MmAS6vTE/Ro/sZ6nThY0N7IwxzHzge945HLqIJ6+xjHK/nDnn
         xZbpiFv41L9maR/bGPHY+emy5xUaw1V3kd9DRMreU6nHJ75OnQTa476xwZAZnfdAGB1O
         qeWQ47RMvmavkMj3GwCKHu9r56zEPE6djRpL313TberW85fYoqTuXSLZTnb6egNBUDsb
         OhKw==
X-Gm-Message-State: AAQBX9fVsvBzj3MkDIXtI7sp+zi0CVBJzFqTFKojsxdAfKvaZc3pU4oE
        SaqL/7Htpm4IxrTMQY6UyOBuRG0715wBb4RwhEZEPClgLQo+mg==
X-Google-Smtp-Source: AKy350bI8HwN1hy3noODJjccy7BnS8eLCBSqLy/SxXMAvbHo7AePuyQ/4uDZ0osFQpnP0anvc+gvIN2tKcohMgkWCF0=
X-Received: by 2002:a81:eb02:0:b0:545:883a:544d with SMTP id
 n2-20020a81eb02000000b00545883a544dmr13359801ywm.9.1680250244939; Fri, 31 Mar
 2023 01:10:44 -0700 (PDT)
MIME-Version: 1.0
From:   Jinliang Zheng <alexjlzheng@gmail.com>
Date:   Fri, 31 Mar 2023 16:10:33 +0800
Message-ID: <CAHwU0gBApwECvPt67rM7LXTN_mJCbDGKCNZJPLqPbxY2PN4aKA@mail.gmail.com>
Subject: Questions about pic simulation pic_poll_read in kvm
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, I am learning the relevant code of kvm interrupt simulation, I
found that when pic_get_irq returns -1, pic_poll_read returns 0x07;
when the return value of pic_get_irq is not -1, pic_poll_read directly
returns the corresponding irq number without set the Bit 7. But
according to the relevant description of the Poll Command section in
"8259A PROGRAMMABLE INTERRUPT CONTROLLER", the correct hardware
behavior should be The byte returned during the I/O read contains a 1
in Bit 7 if there is an interrupt, and the binary code of the highest
priority level in Bits 2:0.

The corresponding code is as follows:
static u32 pic_poll_read(struct kvm_kpic_state *s, u32 addr1)
{
        int ret;

        ret = pic_get_irq(s);
        if (ret >= 0) {
                if (addr1 >> 7) {
                        s->pics_state->pics[0].isr &= ~(1 << 2);
                        s->pics_state->pics[0].irr &= ~(1 << 2);
                }
                s->irr &= ~(1 << ret);
                pic_clear_isr(s, ret);
                if (addr1 >> 7 || ret != 2)
                        pic_update_irq(s->pics_state);
        } else {
                ret = 0x07;
                pic_update_irq(s->pics_state);
        }

        return ret;
}

In Qemu, I found the emulation code according to the hardware manual as follows:
static uint64_t pic_ioport_read(void *opaque, hwaddr addr,
                                unsigned size)
{
    PICCommonState *s = opaque;
    int ret;

    if (s->poll) {
        ret = pic_get_irq(s);
        if (ret >= 0) {
            pic_intack(s, ret);
            ret |= 0x80;                     // set the Bit 7
        } else {
            ret = 0;
        }
        s->poll = 0;
    } else {
        if (addr == 0) {
            if (s->read_reg_select) {
                ret = s->isr;
            } else {
                ret = s->irr;
            }
        } else {
            ret = s->imr;
        }
    }
    trace_pic_ioport_read(s->master, addr, ret);
    return ret;
}

I would like to ask, why is the simulation of pic_poll_read in kvm
inconsistent with the hardware manual? Is this correct?
What is the meaning of 0x07 returned by pic_poll_read when pic_get_irq
returns -1? Indicates a spurious interrupt? When the return value of
pic_get_irq is not -1, why is Bit 7 of the return value of
pic_poll_read not set?

Thanks. :-)
Jinliang Zheng
