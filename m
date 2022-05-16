Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7540528928
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 17:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245443AbiEPPsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 11:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237736AbiEPPsi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 11:48:38 -0400
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889CD2B24C
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 08:48:37 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id e7so7725605vkh.2
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 08:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=diJg0wsVl1OWpdDgnDDlhxkTY3wZ6x6sG5tmUGIDOpg=;
        b=l7fydfyRhQbVlMeCGUoKObkVxljBUnQy/2rgTZ8OuH9oiOaxqNy0rz3Rg5lEb5+0t8
         +3ymsFsGSFOuPM7juBDSMG5ZJgOLIjTVRdTJCbIKRW9XLNIv81EjKAXJnMfRBGRf2pgz
         t3/xZRX5uHwMzj92nxSx1dkTJhnjvlDKWj+lDWbdG3HFT79r/QEXTBbmTFgmGJGIKMOm
         1u6MObI85lUp8IgZi/jAIVdL4VJ8p9KwjOlsARupyD+36EKM1MSX5B/d2VxUhd6lmfpe
         0J35HhwZq/rTQVuI1IJMgYHHHmowohkeUGO3STLHem/ndoeS0lMqR0TI1h0MvFWBo0I5
         /NuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=diJg0wsVl1OWpdDgnDDlhxkTY3wZ6x6sG5tmUGIDOpg=;
        b=t2yN326FP3i2yNw90ooGB2ab3A311NQ1WshbkIuat4PNtR1N9TUBYxDBRjbui78uOQ
         yNe7XB1KH+RWpBtGuZCXT68uzcB8pEXCQuCkf0pjMQqF3yoqHSsgO6P+aFZF3NbEvtdY
         EajvW31W90rEsRIw/DLo9UaeN8at1lI05QYp3ihAk1VF4aFOOeJ7/0HIzoAGN9KM6AnA
         5emr1oncY73ulw9OugErvoaOR7YL6kw57qBa+EFZ6TbFr/zg4cUjAbo0xYBkA/K/qtg0
         njguwbyzdcFe/Kuq+U0wfGlHa6DgikQv4rI3LSupsMnSgj1KuHzxCiRnzixniDxHEl/P
         ZXNg==
X-Gm-Message-State: AOAM533Nptthkb/cJQ3O+CbDY4ptJdRGsMSYdUYFNJASdXBgTqbgqj/u
        e5HADiq+i/WXCQwELR5gmLyErJHMR45FuomdQuc=
X-Google-Smtp-Source: ABdhPJzL/sxe9YBw9HkEJdYitTOAbzx2z0BCZs8BI+BRX05BcdD2E8VVIxGfE0wzoJbLXfE2X8yJgSbLzhYW5qglFxQ=
X-Received: by 2002:ac5:cc4e:0:b0:352:cbc0:5d0f with SMTP id
 l14-20020ac5cc4e000000b00352cbc05d0fmr6807855vkm.22.1652716116559; Mon, 16
 May 2022 08:48:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAJuRqcC0Z-wbAhb39ofKPstgbg+ZmsT8eFivWEr-hZY64_A1xA@mail.gmail.com>
 <4D910AFF-1C6A-4732-BAC6-16064B981949@redhat.com>
In-Reply-To: <4D910AFF-1C6A-4732-BAC6-16064B981949@redhat.com>
From:   Florent Carli <fcarli@gmail.com>
Date:   Mon, 16 May 2022 17:48:25 +0200
Message-ID: <CAJuRqcCR1dZryWxOOUtUwtpOJXZF5Ww6wfC3Q0Po_5wJD_+DBw@mail.gmail.com>
Subject: Re: Cyclictest with small interval in guest makes host cpu go very high
To:     Christophe de Dinechin <dinechin@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank you Christophe for your idea, it led me in the right direction.

I found that the root cause is actually the default value of
halt_pool_ns (200000ns --> 200us).

"The KVM halt polling system provides a feature within KVM whereby the
latency of a guest can, under some circumstances, be reduced by
polling in the host for some time period after the guest has elected
to no longer run by cedeing."

When the cyclictest interval is larger than halt_poll_ns, then the
polling does not help (it's never interrupted) and the
growing/shrinking algorithm makes the interval go to 0 ("In the event
that the total block time was greater than the global max polling
interval then the host will never poll for long enough (limited by the
global max) to wakeup during the polling interval so it may as well be
shrunk in order to avoid pointless polling.").

But when the cyclictest interval starts becoming smaller than
halt_poll_ns, then a wakeup source is received within polling...
"During polling if a wakeup source is received within the halt polling
interval, the interval is left unchanged.", and so polling continues
with the same value, again and again, which puts us is this known
situation:

"Care should be taken when setting the halt_poll_ns module parameter
as a large value has the potential to drive the cpu usage to 100% on a
machine which would be almost entirely idle otherwise. This is because
even if a guest has wakeups during which very little work is done and
which are quite far apart, if the period is shorter than the global
max polling interval (halt_poll_ns) then the host will always poll for
the entire block time and thus cpu utilisation will go to 100%."

It just to me a while to realize that halt_poll_ns = 200000ns = 200us
= my problematic cyclictest interval threshold...
if I set halt_poll_ns to 100000 (and restart the vm, that's
important), then the 200us cyclictest interval works fine...
