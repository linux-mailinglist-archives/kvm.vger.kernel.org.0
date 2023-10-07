Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2570D7BC599
	for <lists+kvm@lfdr.de>; Sat,  7 Oct 2023 09:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343703AbjJGH3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Oct 2023 03:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343693AbjJGH3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Oct 2023 03:29:18 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264DDC2;
        Sat,  7 Oct 2023 00:29:17 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id 5614622812f47-3add37de892so1748674b6e.1;
        Sat, 07 Oct 2023 00:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696663756; x=1697268556; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I0E5WqiKCbwvtUXGi59LtABERDKd3FTGriNOl3rW0Fw=;
        b=inZ4Z3Rlx4JBYdSEwywZUaF7A+MC7brZWajmBlJncY0RFgCOQqrlwJE5mvvZZrQU8c
         gCbPQ1iAyoK4XT4eoysmJnwQHR8nZuMr7YmAKbnGqHo+/iTvh3eI3QLWZAYtFc5rGD5Q
         6Hww0epMAKEh669U71m/GESBqsIKrhL6HBDA7yT9V2puS5SB7ZqEl8Fnz3ZnNpTDBpsf
         OlZo1RcXxHT77WenGp12DZgUfIFe/sR5lKquxiwGph3JGHNSR4SABkFp+tG2H4p2g0uy
         9+hDyygow4FlbohsP308M4l5rkgCtfCMRCcj8ty+XIjXaYtW2ljDcrvIHYaM69RM/jss
         iAXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696663756; x=1697268556;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I0E5WqiKCbwvtUXGi59LtABERDKd3FTGriNOl3rW0Fw=;
        b=eIXPuV0KVU5L2DZWLvHq161Kr4y4k2R1KON1Uqvbk7n6qL6f61vhh5rgRwKSquJL4X
         S1Q7n5JmTzw6a/PCJkx46cx7Z7ypLWM5jCdesRMlW6BaoTwxdZDDoESornnx9nU7f3PO
         pPnuzMDkviaXyIl7MR4opk4J/UqNPnUYJskZLyPxjmbwaEw/TBiz86M2Td2V2DD4Hzod
         PzGhm1aDAIZGvWO5zW/Io/W7Y1+hDBxffPukB4TcLViL9NbaVQXlr9p39aCCGjWxzkTl
         NNg4IPEhHkZJ6dPI0xvFr3CV2tMdB+JgB9yxE8I8saR6BwshzzXOldU0wT98eoOdMbdu
         dJ4g==
X-Gm-Message-State: AOJu0YxtxNtLjeJoIQYrw2myegEan+L706fIxwtEztw14mS/Qwf2BAxU
        FL9quuTmVtZkN6arDAMlkJA=
X-Google-Smtp-Source: AGHT+IH8EMwfvtDeprjrziYjGIjybM59lOvWRcXViyK9u0Jtg8/FcZS+E/un+eRjHe7CtFNLQ37PoQ==
X-Received: by 2002:aca:1b15:0:b0:3ad:fe8d:dfae with SMTP id b21-20020aca1b15000000b003adfe8ddfaemr9534134oib.57.1696663756374;
        Sat, 07 Oct 2023 00:29:16 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id n20-20020a638f14000000b00563e1ef0491sm4562706pgd.8.2023.10.07.00.29.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Oct 2023 00:29:15 -0700 (PDT)
Message-ID: <9c5274f4-9c8a-2de8-46ed-b3a3268dd6ea@gmail.com>
Date:   Sat, 7 Oct 2023 15:29:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v6] KVM: x86/tsc: Don't sync user-written TSC against
 startup values
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20230913103729.51194-1-likexu@tencent.com>
 <5367c45df8e4730564ed7a55ed441a6a2d6ab0f9.camel@infradead.org>
 <2eaf612b-1ce3-0dfe-5d2e-2cf29bba7641@gmail.com>
 <ZQHLcs3VGyLUb6wW@google.com>
 <3912b026-7cd2-9981-27eb-e8e37be9bbad@gmail.com>
 <7c2e14e8d5759a59c2d69b057f21d3dca60394cc.camel@infradead.org>
 <fbcbbf94-2050-5243-664a-b65b9529070c@gmail.com>
 <b6661934-53d1-f7ca-d3d6-31b32a2ebb05@gmail.com>
 <4ACB424D-F9F4-4233-89A4-61CC5B4E5A77@infradead.org>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <4ACB424D-F9F4-4233-89A4-61CC5B4E5A77@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/9/2023 4:31 pm, David Woodhouse wrote:
> 
> 
> On 25 September 2023 09:36:47 CEST, Like Xu <like.xu.linux@gmail.com> wrote:
>> Ping for further comments and confirmation from Sean.
>> Could we trigger a new version for this issue ? Thanks.
> 
> I believe you just have a few tweaks to the comments; I'd resend that as v7.

OK, thanks.

Since I don't seem to have seen V7 yet on the list,
just let me know if anyone has any new thoughts on this issue.
