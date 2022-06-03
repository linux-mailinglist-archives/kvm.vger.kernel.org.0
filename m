Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECDB053D324
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 23:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346482AbiFCVUU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 17:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiFCVUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 17:20:18 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C8F28734
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 14:20:17 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id g205so8015449pfb.11
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 14:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=aSL7ZHMXz3P5XlI8cikK9k/wBwL3m4ZnnGzl4LDbF5w=;
        b=yNAzb0ajq75+NUTWQ6F/Imkp+LkAOvWyjvIEZ9Ah9mLyIFvXVmZByYLwWgzXGPugJH
         MZUuBsPksKXivdKiY3wf5wMtR12nIaXA6IVFdxR7/USFhYToEqM8KTUL5jdj/vHXeGh1
         olb4yI9AOqG/8V8wmwUW2Z91bj9n5R+WM0//+OmgWylvnq0NhEYoGaqWJTLkAmL0QNAr
         60jA9p5eud68gO4TkVyG1Ac1+bCKirNYFckPPkX5eCbAhOZoOiMj2Vx3YgEZfVI03H/s
         agkeGuWvGhFYWY5Qbj+wNfabulM2TXDfn6iB7RnlIACHBFT6laOahv13Vh2nn13Z53gQ
         ZLBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=aSL7ZHMXz3P5XlI8cikK9k/wBwL3m4ZnnGzl4LDbF5w=;
        b=Oxqk1VEG96P1XKuF3zP5HLTTD5h469HM5T944YVz0bLIdB19MiVPk0PlxoKUh2FJdk
         fF5sNrvEh9BftNhc5dhpPHa0/PYsQOuZ/4nF588VVXcB1l523aNlxjXsFMMElMiEyYwq
         K4cPO8Afnzh7rulBKlu3RkbVyyIY1mAFbMTihSeeRnMf1ttkMLWhnlPYoTZHursRPFg+
         NshICnAa+spPDJ7QrzlLWxTPqVWSUGAznsPVORkw265D+dcMGvBPHuPmWMAgTG3R2Vm5
         uNdLxn65M50kCIyw/+KUjVrJEACZwnxlBEpdngm23VgtopaRR3YLA4FGXihlP/rVKWjJ
         FEVA==
X-Gm-Message-State: AOAM531f+DMRm+DTHL+aMny/mI+1y4GqNrQ7VJVT/cCNISdls/IhS5Li
        KzyZerC8tL/CAMhFTJe92QDbxw==
X-Google-Smtp-Source: ABdhPJy74UdT1UAYK7NS4BOTDuipUyhVJ4Wcq5kgiiy/hpj0AmjWPiOSYCycussqXvJh6aPittlOqQ==
X-Received: by 2002:a63:b57:0:b0:3fb:a948:6d96 with SMTP id a23-20020a630b57000000b003fba9486d96mr10378007pgl.596.1654291216494;
        Fri, 03 Jun 2022 14:20:16 -0700 (PDT)
Received: from localhost ([12.3.194.138])
        by smtp.gmail.com with ESMTPSA id t10-20020a17090a950a00b001e28e80a8d6sm5604411pjo.38.2022.06.03.14.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 14:20:15 -0700 (PDT)
Date:   Fri, 03 Jun 2022 14:20:15 -0700 (PDT)
X-Google-Original-Date: Fri, 03 Jun 2022 14:20:14 PDT (-0700)
Subject:     Re: (RISC-V KVM) Re: [PATCH] RISC-V: fix typos in comments
In-Reply-To: <CAAhSdy3+imWabbArUAg0Bki3qvD1PGVB-L-xY5CvNa_YBu80aA@mail.gmail.com>
CC:     Julia.Lawall@inria.fr, kernel-janitors@vger.kernel.org,
        atishp@atishpatra.org, Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     anup@brainfault.org
Message-ID: <mhng-90fa273a-b4b0-4078-887b-5e4f58986006@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 02 Jun 2022 21:33:00 PDT (-0700), anup@brainfault.org wrote:
> On Thu, Jun 2, 2022 at 9:56 AM Palmer Dabbelt <palmer@dabbelt.com> wrote:
>>
>> On Sat, 30 Apr 2022 12:11:20 PDT (-0700), Julia.Lawall@inria.fr wrote:
>> > Various spelling mistakes in comments.
>> > Detected with the help of Coccinelle.
>> >
>> > Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
>> >
>> > ---
>> >  arch/riscv/kvm/vmid.c |    2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
>> > index 2fa4f7b1813d..4a2178c60b5d 100644
>> > --- a/arch/riscv/kvm/vmid.c
>> > +++ b/arch/riscv/kvm/vmid.c
>> > @@ -92,7 +92,7 @@ void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu)
>> >                * We ran out of VMIDs so we increment vmid_version and
>> >                * start assigning VMIDs from 1.
>> >                *
>> > -              * This also means existing VMIDs assignement to all Guest
>> > +              * This also means existing VMIDs assignment to all Guest
>> >                * instances is invalid and we have force VMID re-assignement
>> >                * for all Guest instances. The Guest instances that were not
>> >                * running will automatically pick-up new VMIDs because will
>>
>> Anup: I'm guessing you didn't see this because it didn't have KVM in the
>> subject?
>>
>> Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
>> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
>>
>> if that helps any, I don't see in anywhere but not sure if I'm just
>> missing it.
>
> Thanks Palmer, I had already planned to pick this as a RC fix for 5.19
> but I forgot to reply here.

OK, no worries.  I was't going to do anything with it as it's 
arch/riscv/kvm, so no rush on my end.
