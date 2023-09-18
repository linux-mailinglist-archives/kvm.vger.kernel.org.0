Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68EFB7A4DE9
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjIRQDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjIRQDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:03:45 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9DB1BF7;
        Mon, 18 Sep 2023 09:03:22 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2bffd6c1460so25506301fa.3;
        Mon, 18 Sep 2023 09:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695052885; x=1695657685; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TU39xba6Mf5d40trDmwMhXy8UK9IvNBAEpc/fRS5lwU=;
        b=KvBUO8O4pcIpu62x6rBzvjzeMjiFAIuyBL6gxUUmO8e+d5nGwMCHTP9HAaLByp58ZT
         EWXpODTpfCXyxqbns2zThfk2/FDjj2YsKZwCUZma6S80oFWBPjoDhvzwCg/UIHJtDRVh
         wsg1KcNLLbzeewBD9Xi4EzJHdqKglcVCOxl7ANQrYgdAAHBsmu+rZWFi4toYxPWbxdsf
         aWI5GPSQxJJ1xTu1zqmnqUmVN/JJUI1tJ0CWNWCbGBl3kG9HeBr4H+W6RwhHcGgadIuX
         Vu2b/5qbtmxD2xXT7Wy1v9lRi0FOYfvMzxP3O6UANrTIujklwww4xmMFYJxsYVkDKZL8
         Jp7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695052885; x=1695657685;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TU39xba6Mf5d40trDmwMhXy8UK9IvNBAEpc/fRS5lwU=;
        b=wmILkAKJU5rs369R5rYOf6jLdzj/pZZsnH0cwox35Z4/N6rEJKTQcs6FB46MaTFP8p
         17E6JiWaj46G2092Dw6BZIXQm66DfHReuNT0mG9vereq1zQQZSTtNIedTbJckyDx7UJT
         ivLrO84ArftoBrkPNJCixIU+dQiMSE+n8KQa1MxftpdNhKhC2AXlqKMzeKwy4FsZTvYi
         TPEx+93NjKt0cMeGrj2qG8BclDAQrS4vveOfFa8DWcY2YJ/ftsbA5xQYr8MVZAuvnATg
         SlTcbvS67fwZLqyew0QT8d9Iw4h/u1Rh7LyuN5ryyJnN/nKhcVA4f1R3CPrjww9UDwsg
         odvg==
X-Gm-Message-State: AOJu0YwB67x53JYwH0qKNLYTEcpYyJZk6BB8MTQz+mGXECFzq+cA4j8T
        2eVp3iFiRfS0Lyi2s90QGHI49DJTb5P7DuoZ
X-Google-Smtp-Source: AGHT+IHakujEQyfS0HR8ZcXYnOYlRKiG1/prvo8FsAtp2f4QZJhz5Zq2A1vtZwTyFMkSPvVn0T/pQg==
X-Received: by 2002:a05:6000:1370:b0:31f:bab8:a31a with SMTP id q16-20020a056000137000b0031fbab8a31amr7674777wrz.39.1695043597369;
        Mon, 18 Sep 2023 06:26:37 -0700 (PDT)
Received: from [192.168.7.59] (54-240-197-236.amazon.com. [54.240.197.236])
        by smtp.gmail.com with ESMTPSA id t3-20020a5d5343000000b00317ab75748bsm12658526wrv.49.2023.09.18.06.26.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 06:26:37 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <56dad458-8816-2de5-544e-a5e50c5ad2a2@xen.org>
Date:   Mon, 18 Sep 2023 14:26:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 11/12] KVM: selftests / xen: don't explicitly set the
 vcpu_info address
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230918112148.28855-1-paul@xen.org>
 <20230918112148.28855-12-paul@xen.org>
 <f649285c0973ec59180ed51c4ee10cdc51279505.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <f649285c0973ec59180ed51c4ee10cdc51279505.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/09/2023 14:21, David Woodhouse wrote:
> On Mon, 2023-09-18 at 11:21 +0000, Paul Durrant wrote:
>> From: Paul Durrant <pdurrant@amazon.com>
>>
>> If the vCPU id is set and the shared_info is mapped using HVA then we can
>> infer that KVM has the ability to use a default vcpu_info mapping. Hence
>> we can stop setting the address of the vcpu_info structure.
> 
> Again that means we're not *testing* it any more when the test is run
> on newer kernels. Can we perhaps set it explicitly, after *half* the
> tests are done? Maybe to a *different* address than the default which
> is derived from the Xen vcpu_id? And check that the memcpy works right
> when we do?
> 

Ok. The VMM is currently responsible for that memcpy. Are you suggesting 
we push that into KVM too?

   Paul

