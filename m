Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8D5709161
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 10:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjESIKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 04:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjESIJx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 04:09:53 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1E7E4C
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 01:09:51 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1ae5dc9eac4so16860465ad.1
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 01:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684483791; x=1687075791;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MFfvDsP1Pp4ougCeQR0lxQyoOnnXgdmQJ0jpJVRq650=;
        b=mZKyEbd2FwrmrGjcDUlov5PgReXqA95wKg7WVMytdTw3x1Hm97Ozy7fDGGF5lOQW/B
         UHzk9z/eHgd59LpEHrCBOjiekcCjIqIkpEjN6Ld6LQv144n3zYAOLzPbtqf6Wfpwrze9
         U2YYhITOjtqwZFp+dnfjzWkUGRTJyywhrooERY4rTkmXk1BeRvy9EyFaCo+fVj89/mJE
         UKQYA/Be04N8FV0jtmzK7s1FhQ/h6epij9/WNacbNjM5Q39UhxgxOAJsevkvXgHtedWA
         Sn480P/3Md/iagXiFDA6LZNqJ7saTYabvlSfYUhOLIRKz3yutdK5WHbjp1/gxB5F35wM
         dK4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684483791; x=1687075791;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MFfvDsP1Pp4ougCeQR0lxQyoOnnXgdmQJ0jpJVRq650=;
        b=hcfZhC56SepvD2In0kUOD7uvg0RBarhBybE5JeDcU13IaIPeabgSlhO5+gYJo+W+EA
         i0rfkeOXJd9EV4yXVNnFXuYN3FZ0M6xtL67P7JntKajZD50ETo5GDL3qgYOtMmPQnMLj
         nes9jvsof7ckn9Qa383T0au4XL+eKrxhoxZ+HC92Jd+dFNcwL9RJd/SxIL5TcYqOKZU9
         ytlO+iz6a/OBxxw5aHI1wMZe/oqHrCwSTBppiTcSLCQa2RnJPqo5fM6Ax99Y/tWvim1S
         BIoSq9FB3M+AGMe12nyfBkJlb9by4P44+YGrxeea2NQZXFnoFcNOyYeN8qfrkyw6Fp1E
         SWjQ==
X-Gm-Message-State: AC+VfDwkBqGih3v6LuvzhS7ndcxMXZMxFFEj2pXv4jxbkL0B3AL08xxr
        8CdgzT9NtwebkR3/24jUAcA=
X-Google-Smtp-Source: ACHHUZ4nqCkVmeN4mA+zGKJoBbXRsxdBZKDRrLPkqszJ5QyaxylLhYNjgRgML55fKiz4ClX0CsiQyw==
X-Received: by 2002:a17:903:11c9:b0:1ac:63ac:10a7 with SMTP id q9-20020a17090311c900b001ac63ac10a7mr1994932plh.68.1684483790607;
        Fri, 19 May 2023 01:09:50 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-39.three.co.id. [116.206.28.39])
        by smtp.gmail.com with ESMTPSA id t21-20020a63d255000000b0053071b00c49sm2516483pgi.23.2023.05.19.01.09.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 01:09:50 -0700 (PDT)
Message-ID: <b66104cf-9e70-0d9b-ccc3-4f1897c84720@gmail.com>
Date:   Fri, 19 May 2023 15:09:43 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH -next v20 24/26] riscv: Add documentation for Vector
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Evan Green <evan@rivosinc.com>,
        Vincent Chen <vincent.chen@sifive.com>
References: <20230518161949.11203-1-andy.chiu@sifive.com>
 <20230518161949.11203-25-andy.chiu@sifive.com>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20230518161949.11203-25-andy.chiu@sifive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/18/23 23:19, Andy Chiu wrote:
> This patch add a brief documentation of the userspace interface in
> regard to the RISC-V Vector extension.
> 

"Add a brief documentation ..."

> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> Reviewed-by: Vincent Chen <vincent.chen@sifive.com>
> Co-developed-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
> Changelog v20:
>  - Drop bit-field repressentation and typos (Björn)
>  - Fix document styling (Bagas)

Anyway, thanks for applying my fixups!

-- 
An old man doll... just what I always wanted! - Clara

