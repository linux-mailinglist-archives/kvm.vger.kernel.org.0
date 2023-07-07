Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6DF974AC8C
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 10:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbjGGILQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 04:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjGGILO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 04:11:14 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C799519BD
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 01:11:13 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-51e00695e21so1937032a12.1
        for <kvm@vger.kernel.org>; Fri, 07 Jul 2023 01:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688717472; x=1691309472;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QaBZtVOgK6LuBIVuOGcFhwUlKUgTAK3ZZXYuQI2MdP0=;
        b=XJV5HDQBou3nJiD1b1IzA1GyTTQgLvbxrkVkArGngdd3ccyjY+uZ7Ci1ndx5FsJZNW
         Bpottu7T0uuEwSWq8eR/W7m/lrBd0BtTkRRnmXPd47C1yj2L8ZlK2WnE8Q1cNhAWZkb7
         mCBVKmRglSQUdsd67ZWuFvliJKpMYaE98tcp2vuKi5XqjcxLfbB/n+AebcprBbZCq+A8
         QuBEVfRuTcc9VwxVLL2puI7Txo1i8thtQ6PzZtbpM0YwgxEEgoiMy7C3cotaqtaTrqyR
         6roj5td0ZCBLF2OHj5RRARXrR8ZZqgpL+rwHLJn/hOTFy7b5Xgsv4mz8oL7xPYK6cVwI
         e5tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688717472; x=1691309472;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QaBZtVOgK6LuBIVuOGcFhwUlKUgTAK3ZZXYuQI2MdP0=;
        b=UVoJsIWL/cqd4DwUUfDpRqxfk8YdCbX/THQdHvnHkX+r+Xc9D9vtKrJlvzXOIZiyJw
         Chbvpte7q1NflUM7SEHsVWec7EEthyj2RXTmX4CqPHKs7u0WWArDOflZosErYV+MT9b4
         v8GYcn2VgwwijdyfUrSC68A6GfyC2/lKPfwOWo4w8MF6jTNAQGb9XuypBfnNF9VvMwBn
         LxuXFIFBh7AYKI+GIdQbNCqrMFg8AQTH+6HHPdQFJF8/VjPLh1le3Vdn8EhGU4FNVSg6
         9lRDgYP6tY2zUtjL5UbcqosfvliCeNlgMssOcJWg2wmxoE4t/5GSA63B/OwU/jONp4LI
         5ung==
X-Gm-Message-State: ABy/qLa1K2tBwP2FIHDXG4ykUMIeAhXL8WndcrZh1gJKXcckO4KGPl1i
        Dz4wUFasS35RJORF8RS4wH8Ozg==
X-Google-Smtp-Source: APBJJlGUGOCbVtkoltONT0bpPxb8qup4y0/GRNiLEWlxIj7LF72swZPkJPOj34EqTFCoMCpDL1JSvw==
X-Received: by 2002:a05:6402:890:b0:51d:d41b:26a5 with SMTP id e16-20020a056402089000b0051dd41b26a5mr3990890edy.14.1688717472211;
        Fri, 07 Jul 2023 01:11:12 -0700 (PDT)
Received: from [192.168.69.115] ([176.187.215.192])
        by smtp.gmail.com with ESMTPSA id ay1-20020a056402202100b0051bed498851sm1723824edb.54.2023.07.07.01.11.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jul 2023 01:11:11 -0700 (PDT)
Message-ID: <cdd729e8-6bf7-620f-186b-b816dc0545fe@linaro.org>
Date:   Fri, 7 Jul 2023 10:11:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH v3 0/6] target/ppc: Few cleanups in kvm_ppc.h
Content-Language: en-US
To:     Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>
References: <20230627115124.19632-1-philmd@linaro.org>
 <bf8cc98d-662b-c4ce-2837-a70c79b0e5e6@gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <bf8cc98d-662b-c4ce-2837-a70c79b0e5e6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/7/23 09:24, Daniel Henrique Barboza wrote:
> Phil,
> 
> I queued all patches to ppc-next. I fixed up patch 3 to not move the 
> cpu_list
> macro as Greg suggested. If you're strongly attached to it let me know and
> I'll remove it from the queue.

Sorry for missing that earlier, sure, no problem!

> Greg, feel free to send your R-b in patch 3 if patch 3 with this change 
> pleases
> you.
> 
> 
> Daniel

