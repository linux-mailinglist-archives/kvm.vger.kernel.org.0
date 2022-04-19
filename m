Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A57C5072B0
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 18:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354454AbiDSQNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 12:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354485AbiDSQMm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 12:12:42 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE474240BC;
        Tue, 19 Apr 2022 09:09:58 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id i20so23086492wrb.13;
        Tue, 19 Apr 2022 09:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Riv/wb0nWsjQNLZH9GYpKN0qAwQCp6Wcud3WrpG9KQM=;
        b=Avoiha5pzt5iXaV/qAwaZBlRbNzRg+oBgewVIskQueMBOYb/i02kFHy6FZnuD7c0dG
         D8Uth0VK6C5HjExR+lE/jDSvhAcpo5N7+4FMsZktsHSgK8SMry0aL/NQcW2SovhmVsjx
         HlXsvGQM2G7LpW+vh9q9a21F9NelezHdmhuIJhpuV3tdNZpoiYc+m0CYm87sGfPWcPnw
         YjgKvnm4WItW+mLcoEYYVt7F0QpdZQV9j3FRhhHkPO7acZEpDUPN1BJMl09rHuQlW/Hi
         MVW9wGMXQITcqUf36mnOU9k4t/8yN9H40B7IBMk3ZtjAKiqXtHmC3fNb51tqfHtaFJK7
         PZjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Riv/wb0nWsjQNLZH9GYpKN0qAwQCp6Wcud3WrpG9KQM=;
        b=YvePLD+LZkS4xF57CTYjKVaaCm3FHGw+OqAOrJ9IgUbVyX98qeRcP1W/IOj6SBwpB/
         xtDzGxbVlqaKBoDkNtA7HU4THv/+4uwsp1QSIQy6EMnxZa0/dWs8m6N00CEWCXy0KAvl
         0/suxZr4YDB9zchfvlM4Z0BhQq0kIz/QJKmAy48Tk9ZeoAhC2AGzY58sbhbCO3WgD/7i
         lcQ5JckBA/11ra28w1Vizx6eMn0UvMrAYPcFzeRhAZNrRrL/aW9FkoWydTAAg7uUAm0I
         WkNCN15CTRVcD8QuN8wc+4rJMQOJrXVXyBiMUHw9C424Hk18j8fIboW66FMRqWVq83o6
         LNyQ==
X-Gm-Message-State: AOAM532vvCqFwuhJP9p1te1SyWoGcS7VoLbq6ppZCglllLFxESwYlLoy
        MYtdpV/aMYGqOSqrpyQkF5FJrZiO2cXiDQ==
X-Google-Smtp-Source: ABdhPJzlbsAj3brTwnY7x/GJOsGXKnLbdLi7eA5aNKGCWTj8wtYbbK9bMFTK6V9BsGqo+pb/Y9Ps/A==
X-Received: by 2002:adf:9bd5:0:b0:207:a2a6:636a with SMTP id e21-20020adf9bd5000000b00207a2a6636amr11957576wrc.480.1650384597296;
        Tue, 19 Apr 2022 09:09:57 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id 185-20020a1c19c2000000b0038a1d06e862sm20539187wmz.14.2022.04.19.09.09.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 09:09:56 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <c222d971-b82e-ef54-5683-d5fd65829b21@redhat.com>
Date:   Tue, 19 Apr 2022 18:09:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: linux-next: build failure after merge of the kvm tree
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     KVM <kvm@vger.kernel.org>, Peter Gonda <pgonda@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20220419153423.644c0fa1@canb.auug.org.au>
 <Yl7c06VX5Pf4ZKsa@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yl7c06VX5Pf4ZKsa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/19/22 18:01, Sean Christopherson wrote:
>> In this commit, the uapi structure changes do not match the documentation
>> changes:-(   Does it matter that the ABI may be changed by this commit
>> (depending on the alignment of the structure members)?
> Yeah, it's a bit of mess.  I believe we have a way out, waiting on Paolo to weigh in.
> 
> https://lore.kernel.org/all/YlisiF4BU6Uxe+iU@google.com
> 

I'll get to it tomorrow morning.

Paolo
