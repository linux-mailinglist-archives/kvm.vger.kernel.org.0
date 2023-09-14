Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8456E7A06A1
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 15:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239273AbjINN6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 09:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbjINN6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 09:58:19 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4821BF8;
        Thu, 14 Sep 2023 06:58:15 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-401da71b83cso10950975e9.2;
        Thu, 14 Sep 2023 06:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694699893; x=1695304693; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4sqXZGJN5EPZ3lXIYLj/dvFu/O4PY9XiJEF12014kqw=;
        b=cqrhsMS2ssr4unqcMO3jESeXwGsImYUaEu9rb9Km1JW2RIUVpc0SsiYGnZMb2K3yaT
         +b3gt+3J1jOpr6z3ZYGQFXgNgi4J584QlxR4JUoGotSZPCtrjyUcQxmVBC4Q+0NsfHZ7
         qJnG1xG/s6cfkw3VprrarmvVNoE1K7Fr8pIkoxvtAy0XO+RD8ixq7eqwf49egvaV5JAn
         JuPhJBBcdWBKQYpSA0vnJjF9/guqU8PfX8YBrgWx7zmHFfkw3UKJY/r53eTpaqaYO8HS
         dypxx/hgzGfxvWl2zR8D15L1kWJDQtRsFdrBJTiy6mcuYg6q7U0n1pNok3uRVCPdNHY3
         bH8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694699893; x=1695304693;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4sqXZGJN5EPZ3lXIYLj/dvFu/O4PY9XiJEF12014kqw=;
        b=U+CbtQduQrHrvtNGA76dUzYQOdTkP0RELZT2iTe2WpnPBtyJXIfs3s2O0I2nge4Yx3
         al2vaeRRYhneXeWDXhxsR0hYdd4lxyTIbbICc6DYUoDvauyWpztamypBlp3aT/JndzRb
         iMWmhLsGes0qc2eVaMRHqhCeubSki8o5KhOeLo4HWNL+6Auq95wk9SUEL6lHUDNpSes6
         +OQjEQtl//uLDwVBGAehBHEsssbNuLMKAlsF7XYbLKRZTVdBuMd6lodjuEcF5EVFfp2L
         wYWAUMf4s6RGIa0H7h7UFXnm713SMn7wQ7o2jtOJ0lXvIyrvooI2fhk2N1e/IWJc/wNQ
         f1CQ==
X-Gm-Message-State: AOJu0YwYrNkGXqh5Cpmag+VSiE3tyUMvNtgU5NWZKW3AU5WAo9//rSB4
        eu5aCIcJJP/jaezwu8p1ihGTRAT4QanaBCvk
X-Google-Smtp-Source: AGHT+IHWvKNvIFxyn/BX9l3g1Iggu/xTIjWssH81WTHSmXnld49srwXs4bUZj/46pHzdzN7hwwlCdg==
X-Received: by 2002:a05:6000:4028:b0:31f:e5b8:4693 with SMTP id cp40-20020a056000402800b0031fe5b84693mr1434237wrb.25.1694699893369;
        Thu, 14 Sep 2023 06:58:13 -0700 (PDT)
Received: from [192.168.5.8] (54-240-197-235.amazon.com. [54.240.197.235])
        by smtp.gmail.com with ESMTPSA id e11-20020a056000120b00b003196b1bb528sm1865136wrx.64.2023.09.14.06.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 06:58:13 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <8419c105-205a-bd25-b84a-ed81a9447bd1@xen.org>
Date:   Thu, 14 Sep 2023 15:58:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Reply-To: paul@xen.org
Subject: Re: [PATCH 5/8] KVM: pfncache: allow a cache to be activated with a
 fixed (userspace) HVA
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230914084946.200043-1-paul@xen.org>
 <20230914084946.200043-6-paul@xen.org>
 <30eece756f273881b276f8069ab30692ded5af49.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <30eece756f273881b276f8069ab30692ded5af49.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/09/2023 14:51, David Woodhouse wrote:
> On Thu, 2023-09-14 at 08:49 +0000, Paul Durrant wrote:
>> --- a/include/linux/kvm_types.h
>> +++ b/include/linux/kvm_types.h
>> @@ -64,7 +64,8 @@ struct gfn_to_hva_cache {
>>   
>>   struct gfn_to_pfn_cache {
>>          u64 generation;
>> -       gpa_t gpa;
>> +       unsigned long addr;
> 
> On 32-bit hosts gpa_t is 64 bits and doesn't fit in an 'unsigned long'
> 

Damn. So used to the host only ever being 64-bit. A u64 it is then.

>> +       bool addr_is_gpa;
> 
> Don't put that there. There are already bools at the end of the struct
> which wouldn't leave 63 bits of padding.
> 

True. Will move.

   Paul


