Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6AA695429
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 23:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjBMWyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 17:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjBMWyQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 17:54:16 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F3AB45A
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 14:54:14 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id h4so7323328pll.9
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 14:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=522NNid6LgSf8RrS5VU4Hzm30KHabJK+kCnv1UqFDb0=;
        b=mtte59o9IYhPKzWfl/qT9tfiUcxy6kAiA6N3oEJ4/kDtAk6IHaeV8Ah3DKN7hi4djP
         roRG5azvNbUTt71U22BMRTRMmNjtGT0QUT/0tdhFIicPVCYnKF0k/w1B2pV25aPu+3Cc
         xUMDjVcRf+lrvAo0wJWWvjx12ohbRo9ajXkqJ2DACWfl3qX9m/8FuM8q0T22wHgnLcuW
         flpdu4daI+21oLgWczWmJyvsZ91Sg/s2YpEMpxHaSTqmc+fxgasIBV0DpnYorh76uUI+
         uHXUhMsFbSRTnOc6toBJlfTYRj0iYDIAecWaIu1T+ldiRGVlf+WPl2Z9DWIsOIoBLp94
         KRqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=522NNid6LgSf8RrS5VU4Hzm30KHabJK+kCnv1UqFDb0=;
        b=hYAq8wjbHXF21BkVCOyVgbvK6rs2k8VMgL1HXj6Lu9U8HmjPn/mGvx6AIM60Q8ErQl
         j9/jdzg0mTUd5gpVD+9Wf/k1CsIKI//65ZM5M160JSR/YlyBD+9/o/+yOSaOd/KLTfg3
         smiXPqXiUU+n8SYebnUClpO+PhUNwc43eQZBKQ40PvzEt3SEKAGkY/mF9tgAjMciPqEr
         svEs0bCsiMz5OkoQZ5F3gfoKwhHs3lmp3WRQWhobWhMogMEqDNrkOlagadAyt4sW+NOc
         48BI8OASA5tzwqbXwjSMmQMEME9NWNhHx5zAxQZcRdicxItS3Jr1o/NVP48skUGlMTF/
         sJ7w==
X-Gm-Message-State: AO0yUKWG8ZUcdem7gvqLrDPQElzW0lYGklqIjuOmlkpeGXQbhj9YRPbF
        6YZcx5XZOmMsuKKdJuSo7DBVdA==
X-Google-Smtp-Source: AK7set9pHsxVA/aZc7KMCzq2WCIjJ4lcMDk1bqdJg3wOOdIz4ZzT5DwjszXnvCGrpL0mXz+ckJW81w==
X-Received: by 2002:a17:903:230a:b0:196:6162:1a76 with SMTP id d10-20020a170903230a00b0019661621a76mr709034plh.0.1676328854376;
        Mon, 13 Feb 2023 14:54:14 -0800 (PST)
Received: from [192.168.50.116] (c-24-4-73-83.hsd1.ca.comcast.net. [24.4.73.83])
        by smtp.gmail.com with ESMTPSA id w12-20020a1709027b8c00b0019a73a45e60sm6614676pll.19.2023.02.13.14.54.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 14:54:14 -0800 (PST)
Message-ID: <82551518-7b7e-8ac9-7325-5d99d3be0406@rivosinc.com>
Date:   Mon, 13 Feb 2023 14:54:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH -next v13 10/19] riscv: Allocate user's vector context in
 the first-use trap
Content-Language: en-US
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Andy Chiu <andy.chiu@sifive.com>,
        linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     greentime.hu@sifive.com, guoren@linux.alibaba.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-11-andy.chiu@sifive.com>
 <875ycdy22c.fsf@all.your.base.are.belong.to.us>
From:   Vineet Gupta <vineetg@rivosinc.com>
In-Reply-To: <875ycdy22c.fsf@all.your.base.are.belong.to.us>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/7/23 06:36, Björn Töpel wrote:
>> +bool rvv_first_use_handler(struct pt_regs *regs)
>> +{
>> +	__user u32 *epc = (u32 *)regs->epc;
>> +	u32 tval = (u32)regs->badaddr;
>> +
>> +	/* If V has been enabled then it is not the first-use trap */
>> +	if (vstate_query(regs))
>> +		return false;
>> +	/* Get the instruction */
>> +	if (!tval) {
>> +		if (__get_user(tval, epc))
>> +			return false;
>> +	}
>> +	/* Filter out non-V instructions */
>> +	if (!insn_is_vector(tval))
>> +		return false;
>> +	/* Sanity check. datap should be null by the time of the first-use trap */
>> +	WARN_ON(current->thread.vstate.datap);
>> +	/*
>> +	 * Now we sure that this is a V instruction. And it executes in the
>> +	 * context where VS has been off. So, try to allocate the user's V
>> +	 * context and resume execution.
>> +	 */
>> +	if (rvv_thread_zalloc()) {
>> +		force_sig(SIGKILL);
>> +		return true;
>> +	}
> Should the altstack size be taken into consideration, like x86 does in
> validate_sigaltstack() (see __xstate_request_perm()).

For a preexisting alternate stack ? Otherwise there is no 
"configuration" like x86 to cross-check against and V fault implies 
large'ish signal stack.
See below as well.

> Related; Would it make sense to implement sigaltstack_size_valid() for
> riscv, analogous to x86?

Indeed we need to do that for the case where alt stack is being setup, 
*after* V fault-on-first use.
But how to handle an existing alt stack which might not be big enough to 
handle V state ?

-Vineet
