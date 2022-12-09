Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B050D647CEE
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 05:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiLIEdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 23:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiLIEdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 23:33:12 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017011FCEC
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 20:33:11 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so6877087pjp.1
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 20:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8V2911JbsQ7q3MV8ByLBMvoup/1u6ZZgGLRpPzpF/E8=;
        b=tD9/OuaQk4Ny5ftlapIHalH7LY+UdxT5DNVq73qwQk5brpKADBpSV9VBVZOrdrU7xS
         jFYq052qCafhdRHVC/bdhkALtxcuHOOH4BEpTNI66zXOXYxyZbqg6kxKdhXeXo4nGBza
         5raDi1jiqsQ2OAWGNFkv8XlefPj1uC0aaWRqbqYnuABo/HjzH+yfNp/qVKmpqkN8Uk9L
         1jFrGeZRQQm3n+1vkzjJxQHzxx9nTNlMKkY0QL8t/OPY/2B3lTzZRNUV5HS+9OMTCEO9
         1bgrkOd/X4V6rKK8IF5TqW3xRVzi6tBpzp4i+FDIcjZDj/1mxWREQIOM5UTRTd2emXnf
         eEgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8V2911JbsQ7q3MV8ByLBMvoup/1u6ZZgGLRpPzpF/E8=;
        b=SjnrmbUwkNOZ6CFBS9a9M7op6SFz09VwUZDU/ZH6po4bF9Fv0Z7m47touK3dNXeAy3
         TNs8N5zBL9iCRt753SxR8Qe5yUKVU6IKVFqlrFFE2jeFzuHvHLpMcEj4FSfIZx9xfJWX
         RyjPM76aOEjIBWast8xtcbYQQWvDX3R4tmMXjwPZg67UGYYTyZXxCBoYNGAlSnQxItKh
         t6as01pdSR6/PtgaQ+4Dncg+UUxEwIolSOD3OUt8nkaa6WK7H6Mj266JlzpswEPf6CF7
         N57Q5A1WH+/ltDQV08ZeYVfYo4ugexPPCgwckr6kI5ak98E4M2WZwnwKiJeWofGHqqXW
         Rm7w==
X-Gm-Message-State: ANoB5pl/By0pzzlguzwzHCqLynxH7jM6ResHjbHAIrWt4g8J7h+iWJWs
        1N5rNa9c0zNxGdYC0TwOFV3mEw==
X-Google-Smtp-Source: AA0mqf53l7n1lwXWo6ELFRoXqPMMWNSKJ4uBBIpg0VM28LtzLEoabSx/gaDvmcRZcN05Lor9GtpL0A==
X-Received: by 2002:a05:6a20:e68f:b0:9d:efbf:48d7 with SMTP id mz15-20020a056a20e68f00b0009defbf48d7mr6076987pzb.27.1670560390227;
        Thu, 08 Dec 2022 20:33:10 -0800 (PST)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id g26-20020aa79f1a000000b0056bbeaa82b9sm296387pfr.113.2022.12.08.20.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 20:33:09 -0800 (PST)
Date:   Thu, 08 Dec 2022 20:33:09 -0800 (PST)
X-Google-Original-Date: Thu, 08 Dec 2022 20:32:57 PST (-0800)
Subject:     Re: [PATCH 6/9] RISC-V: Export sbi_get_mvendorid() and friends
In-Reply-To: <CAOnJCUJ6b5=e=k19q0Q51Gptgw_QSr_989cN8q0xoBN+yq=Mmw@mail.gmail.com>
CC:     apatel@ventanamicro.com, pbonzini@redhat.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        ajones@ventanamicro.com, anup@brainfault.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     atishp@atishpatra.org
Message-ID: <mhng-1fa7f552-95e4-4299-ab83-52001eab8b30@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Nov 2022 13:07:27 PST (-0800), atishp@atishpatra.org wrote:
> On Mon, Nov 28, 2022 at 8:14 AM Anup Patel <apatel@ventanamicro.com> wrote:
>>
>> The sbi_get_mvendorid(), sbi_get_marchid(), and sbi_get_mimpid()
>> can be used by KVM module so let us export these functions.
>>
>> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
>> ---
>>  arch/riscv/kernel/sbi.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
>> index 775d3322b422..5c87db8fdff2 100644
>> --- a/arch/riscv/kernel/sbi.c
>> +++ b/arch/riscv/kernel/sbi.c
>> @@ -627,16 +627,19 @@ long sbi_get_mvendorid(void)
>>  {
>>         return __sbi_base_ecall(SBI_EXT_BASE_GET_MVENDORID);
>>  }
>> +EXPORT_SYMBOL_GPL(sbi_get_mvendorid);
>>
>>  long sbi_get_marchid(void)
>>  {
>>         return __sbi_base_ecall(SBI_EXT_BASE_GET_MARCHID);
>>  }
>> +EXPORT_SYMBOL_GPL(sbi_get_marchid);
>>
>>  long sbi_get_mimpid(void)
>>  {
>>         return __sbi_base_ecall(SBI_EXT_BASE_GET_MIMPID);
>>  }
>> +EXPORT_SYMBOL_GPL(sbi_get_mimpid);
>>
>>  static void sbi_send_cpumask_ipi(const struct cpumask *target)
>>  {
>> --
>> 2.34.1
>>
>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>

Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
