Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D65868E2BA
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 22:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjBGVS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 16:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjBGVS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 16:18:56 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174F817175
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 13:18:55 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id r8so17082739pls.2
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 13:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l0gc5keUcXf5U42aZBPSOFCzzi7Lkby3WUvehhaBKbA=;
        b=VqOOoB7rkICaPhrTdeAoRHvNfIQCJ204MGU94d8Ggkr7EJAlzUjNF6kI/HBErZMhOp
         KGEISZNOzaMddz4lMLtnAVatyKPHy3CSqtNu16mmrONEYSTrN8Kwqg3qIRPRfklPS731
         3N/FY1m5zvleZ9i8gm1hNsQTd+u1BdBGVp43u3Ilnf7Yk5VLnGotDQ2JDMa09VAcm269
         sLGzQXo3ZmjltnUG+QjnS67iSMClmBlZ3PtTN5cVAh7WrjrXih9vJ4vZBqBvFtt7Dmll
         dkT20QzzfY3K0GCQukTcpcog5RDGqcuk3w8cYTDVTpds1IU7PpV4RaeykVv3m6oEg6vk
         2lRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l0gc5keUcXf5U42aZBPSOFCzzi7Lkby3WUvehhaBKbA=;
        b=PyAOESHDfR5eplEswZ/LjXbvSKJ6DBUX1lHoqgB4JK9kt0ce2n9UGpYwOp5NnNwPwG
         X/N82HQICWT5jRyzY75gjgTtETUjutxiDT0EDPjEnMub/x1wmeTtdWmiZ1z/p8oQUrFM
         5CDSxR0UK/3q70cNH1gf1Z+TcXCTWvye4AnlxG+z6twtgJJhT/+G0Sb2qkJYqOy82x16
         qLLZlptTVe5aBjCSFutmS/h2mnTPeRmNeyeHuOGgx61xL6nEh6S0tgnZ/eqt9+kzHh+a
         bWYzw+Ojrm8D0/aeDILKU7kTILyhvQbVRpcjb8IMo0OBCw+HY/q4y3NER6A5Vxzmlg/R
         e4xA==
X-Gm-Message-State: AO0yUKUUYnzKX3NNNpwBI8xgGM4xwhyWJGkjXC2rIrU2J6p6Xc6duEDC
        ZJgYBIzDZZdSazWcIdOAzGHdvA==
X-Google-Smtp-Source: AK7set/tcOAwjePvlCcDOHogBghvok/qBEaHnXi93rhmnMJDEPyGUHdl1epz2OQpc7DQKqLl1X7mQg==
X-Received: by 2002:a17:903:124f:b0:199:1a32:413c with SMTP id u15-20020a170903124f00b001991a32413cmr4865089plh.45.1675804734592;
        Tue, 07 Feb 2023 13:18:54 -0800 (PST)
Received: from [192.168.50.116] (c-24-4-73-83.hsd1.ca.comcast.net. [24.4.73.83])
        by smtp.gmail.com with ESMTPSA id p21-20020a170902ead500b001991fd2faabsm3875816pld.277.2023.02.07.13.18.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 13:18:54 -0800 (PST)
Message-ID: <91cd3bf5-9c68-df1e-32a8-55f2cfedd84a@rivosinc.com>
Date:   Tue, 7 Feb 2023 13:18:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH -next v13 10/19] riscv: Allocate user's vector context in
 the first-use trap
Content-Language: en-US
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
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
        Changbin Du <changbin.du@intel.com>,
        Richard Henderson <richard.henderson@linaro.org>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-11-andy.chiu@sifive.com>
From:   Vineet Gupta <vineetg@rivosinc.com>
In-Reply-To: <20230125142056.18356-11-andy.chiu@sifive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andy,

On 1/25/23 06:20, Andy Chiu wrote:
> +static bool insn_is_vector(u32 insn_buf)
> +{
> +	u32 opcode = insn_buf & __INSN_OPCODE_MASK;
> +	/*
> +	 * All V-related instructions, including CSR operations are 4-Byte. So,
> +	 * do not handle if the instruction length is not 4-Byte.
> +	 */
> +	if (unlikely(GET_INSN_LENGTH(insn_buf) != 4))
> +		return false;
> +	if (opcode == OPCODE_VECTOR) {
> +		return true;
> +	} else if (opcode == OPCODE_LOADFP || opcode == OPCODE_STOREFP) {
> +		u32 width = EXTRACT_LOAD_STORE_FP_WIDTH(insn_buf);
> +
> +		if (width == LSFP_WIDTH_RVV_8 || width == LSFP_WIDTH_RVV_16 ||
> +		    width == LSFP_WIDTH_RVV_32 || width == LSFP_WIDTH_RVV_64)
> +			return true;

What is the purpose of checking FP opcodes here ?

> +	} else if (opcode == RVG_OPCODE_SYSTEM) {
> +		u32 csr = EXTRACT_SYSTEM_CSR(insn_buf);
> +
> +		if ((csr >= CSR_VSTART && csr <= CSR_VCSR) ||
> +		    (csr >= CSR_VL && csr <= CSR_VLENB))
> +			return true;
> +	}
> +	return false;
> +}

