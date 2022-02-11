Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 051854B1DED
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 06:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbiBKFc7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 00:32:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbiBKFc5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 00:32:57 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D6FFC2;
        Thu, 10 Feb 2022 21:32:57 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id c6so21820248ybk.3;
        Thu, 10 Feb 2022 21:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8U0RdmyBvYMlSjjVGSo29oUB6sKZ9Ib1qgyUq3axU1s=;
        b=mlq3/lPCpacSw9Wok7V4785+SFzOSp4VQmDDp0GXG+Xae5/dVQB0sDJ0AaEE6HHZl/
         n7AbDmgRrjIuNO4pDma68HPkiAfjkyYXhU0GNL0x0PbaUY0dSemFCgYysOoHhWnmeB8+
         hbjkC0t8dR3+BovBYT2EYsLN4W62EIQqKjjgIbnuu7t7X63wg1SlpbSelbe7ChQN/vAW
         G92VnQu7w/U8hd5rSCZEA3H1u+yIsOq32+YSAPX1ln1byP30TZPHtO2aEYSgZltcSLP2
         Gzq4TIEa2S3qJOAUVlRPsl7WGA3tOu00USgPV8e3kMkdkxaETz7L7r3xZ9Uo0miDffMH
         nBzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8U0RdmyBvYMlSjjVGSo29oUB6sKZ9Ib1qgyUq3axU1s=;
        b=xTHvYsfNpdpqZZYeGujDZRLTnDPOzSwljMYcA+rfEUQLOgAH8GP5YCnDl3gJ9VV44j
         ZpzfTF++ops2soZPI8sdUSjT3ufeJjdSM/wSmEbxH/mVtzNtDJnqVV5OhQLM7cEEA39E
         CpcZEMVa4B8xGBH1Wur3baOP9Zuxs14/loNE/LM0vkepclg+pKrHIUDqGPueIiURLDhv
         j1QsESavIgL/+go/58Q3NigJDkBtgwqyzL1+bIUIDtBK+SJsc3ti1jBI4yIc0+mMXfiz
         I6OrKKu+/I7ykFkC/01MKBkeWTSijWBAw65DMTMKh+y1mK4VsW+cG1rRh/bXfJOxPwhF
         Z6HA==
X-Gm-Message-State: AOAM531ztx81w+J4f47Y6pUcZTwiYHlXFiKiF8UPCdigD+f3h2/uu8NM
        9020r33Y8mo+TSYS4M/8wQkHXEOUpjuicARAFss=
X-Google-Smtp-Source: ABdhPJyzlJsDeZdZNy7m8oPjzrRKU1aUU6XC5vS3tQ5d7HSSYJ9EXJIJJVFi7Z+uamL2iPSi6pZqDqIJAi11VndkRyg=
X-Received: by 2002:a25:d088:: with SMTP id h130mr2847070ybg.691.1644557576709;
 Thu, 10 Feb 2022 21:32:56 -0800 (PST)
MIME-Version: 1.0
References: <20211216021938.11752-1-jiangshanlai@gmail.com> <7fc9348d-5bee-b5b6-4457-6bde1e749422@redhat.com>
In-Reply-To: <7fc9348d-5bee-b5b6-4457-6bde1e749422@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 11 Feb 2022 13:32:45 +0800
Message-ID: <CANRm+CyHfgOyxyk7KPzYR714dQaakPrVbwSf_cyvBMo+vQcmAw@mail.gmail.com>
Subject: Re: [PATCH 0/3] KVM: x86: Fixes for kvm/queue
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
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

On Tue, 21 Dec 2021 at 04:13, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/16/21 03:19, Lai Jiangshan wrote:
> > From: Lai Jiangshan <laijs@linux.alibaba.com>
> >
> > Patch 1 and patch 2 are updated version of the original patches with
> > the same title.  The original patches need to be dequeued.  (Paolo has
> > sent the reverting patches to the mail list and done the work, but I
> > haven't seen the original patches dequeued or reverted in the public
> > kvm tree.  I need to learn a bit more how patches are managed in kvm
> > tree.)
>
> This cycle has been a bit more disorganized than usual, due to me taking
> some time off and a very unusual amount of patches sent for -rc.
> Usually kvm/queue is updated about once a week and kvm/next once every
> 1-2 weeks.

Maybe the patch "Revert "KVM: VMX: Save HOST_CR3 in
vmx_prepare_switch_to_guest()"" is still missing in the latest
kvm/queue, I saw the same warning.

    Wanpeng
