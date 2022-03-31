Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15954ED386
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 07:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiCaFyl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 01:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiCaFyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 01:54:40 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C6921267
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 22:52:54 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id cm17so3061303pjb.2
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 22:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=IBamUaj9YrgQoUbRaPWrU7o5ZQ6M8T/P4ePIRI4QM34=;
        b=zJcpbuOej6gZTZJPWaEzzkrlN5H7zYi/tfZLPl5QcNA5MOpFxQ5bpfEpOWC19kkDIQ
         o95XAGxPbCJuut3OL93cgHLImqrj5tQw4RnXTAxrh46dZ0trQ2lQE68dCAV1VD52ChB4
         6j/+8K5dNuPIHOAJkt0HJCGsrMqbPmjjDRP6QCpg442u0HsCNmVYdzwXV5tmwY/md7gc
         g2YQvbRpQu3dbCqYg4UpMe5X6DQRTBlO/f+Em8Ju1z2XRC3npyuYaPaKGsA87r+yNUfH
         q2JhDEoe0d2ALVFSB31HCbqGy+3dAaol5DyNIvhbdvMFnUCijLm8a3WsXVccdmfXLAlw
         6N4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=IBamUaj9YrgQoUbRaPWrU7o5ZQ6M8T/P4ePIRI4QM34=;
        b=ftiBCtWhSWUvl8VAPPjCYoO0MtXfF+LEpEH41uhxEoquwGTacNZySPX10Gb2rdPXmZ
         sp64rDk3DCHXvtKwAsY1CEBXiEgHRSx5k1CkhyA530AVwUTmSeZVnHjHhqmw06M2NS1Q
         Fg9AttUBpUaSdEsVNh1EjlQI9fbaSUHw/33yhJee3O+gmbV2rnyuCsgCiipp+rp+TXlV
         WX/cF+V/9jInc0irlW3ilmOF53PbKeaZQlo/uh++iafqLMNdJdO5/27xyd/dTI7sULl5
         N57aVP1wwcy+FCO+x3KnCJ0mOUBskG3ybb7uURI/DSFYVPS8oQmmGfQBwA/YXowpcQs+
         rwNw==
X-Gm-Message-State: AOAM531clfAwVQDPAfTuM8WQ/NSRC0zuKwT2oAUFUlWy48U7c+b08/8p
        gQPwIKjhnBkt4y/hZKQ25lHDyQ==
X-Google-Smtp-Source: ABdhPJxatwbY0eiFFqqr4kfADTBSUPWRHFUvVXS1GEzij3x70XU/UukTdZF6PlEkpcpm6uH9deBUDw==
X-Received: by 2002:a17:902:82cc:b0:153:cc6e:fac1 with SMTP id u12-20020a17090282cc00b00153cc6efac1mr3414756plz.138.1648705973585;
        Wed, 30 Mar 2022 22:52:53 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id p10-20020a056a0026ca00b004fb44e0cb17sm15616555pfw.116.2022.03.30.22.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 22:52:52 -0700 (PDT)
Date:   Wed, 30 Mar 2022 22:52:52 -0700 (PDT)
X-Google-Original-Date: Wed, 30 Mar 2022 22:52:09 PDT (-0700)
Subject:     Re: question about arch/riscv/kvm/mmu.c
In-Reply-To: <alpine.DEB.2.22.394.2203162205550.3177@hadrien>
CC:     kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     julia.lawall@inria.fr, anup@brainfault.org,
        Atish Patra <atishp@rivosinc.com>
Message-ID: <mhng-9835bc56-8f99-4fd6-bccc-262b642a2ccb@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Mar 2022 14:10:06 PDT (-0700), julia.lawall@inria.fr wrote:
> Hello,
>
> The function kvm_riscv_stage2_map contains the code:
>
> mmu_seq = kvm->mmu_notifier_seq;
>
> I noticed that in every other place in the kernel where the
> mmu_notifier_seq field is read, there is a read barrier after it.  Is
> there some reason why it is not necessary here?

I guess that's a better question for Atish and Anup, but certainly 
nothing jumps out at me.  There's a pretty good comment in the arm64 
port about their barrier:

        mmu_seq = vcpu->kvm->mmu_notifier_seq;
        /*
         * Ensure the read of mmu_notifier_seq happens before we call
         * gfn_to_pfn_prot (which calls get_user_pages), so that we don't risk
         * the page we just got a reference to gets unmapped before we have a
         * chance to grab the mmu_lock, which ensure that if the page gets
         * unmapped afterwards, the call to kvm_unmap_gfn will take it away
         * from us again properly. This smp_rmb() interacts with the smp_wmb()
         * in kvm_mmu_notifier_invalidate_<page|range_end>.
         *
         * Besides, __gfn_to_pfn_memslot() instead of gfn_to_pfn_prot() is
         * used to avoid unnecessary overhead introduced to locate the memory
         * slot because it's always fixed even @gfn is adjusted for huge pages.
         */
        smp_rmb();

I don't see anything that would invalidate that reasoning for us.  My 
guess is that we should have a similar barrier (and coment, and maybe 
call __gfn_to_pfn_memslot() too).  There's a handful of other 
interesting-looking differences between the riscv and arm64 ports around 
here that might be worth looking into as well.

Might also be worth updating that comment to indicate that the actual 
wmb() is in kvm_dec_notifier_count()?  Also, to make it sound less like 
arm64 is calling gfn_to_pfn_prot()...
