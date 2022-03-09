Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A844D2D28
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 11:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiCIKfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 05:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiCIKfL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 05:35:11 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DDDE44BE;
        Wed,  9 Mar 2022 02:34:13 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id u10so2266660wra.9;
        Wed, 09 Mar 2022 02:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Dr1lE4tyQ/hl/XtFcan3CZdUBU9oU7rRqhzzfp6nEuQ=;
        b=IPvFQTKx1i3QLvzOgqUFdZZV+Cv1RyqMlXIFO+hHZJa4hFsfEc3oTiIE3dE/xo7mrm
         eYL8NC6f1TD3GxL51x+z0CFiU4dKr4QnHg3K7E6QXcL0Cs1HLx8uJ+4Mpn/dP7sL/lL1
         JOe0bWI8SIyr/qAlfPIVWf9844hUBWg0e38A5fjnsJtvUUFsKD8mes6/A9YRiKyXPFHX
         HF78OHgY+mEKablrzepAao0/R0KoCgLP1NJs9XqpzmFMWeMjn4nrtVy+xVsOY7zdCc6E
         QXgZpdJumkDJ+MI37tUokYtzTgom6199ifBG0i2Jh7IiF7vVqjq/JQn2XunrWbKD/LPN
         gnEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Dr1lE4tyQ/hl/XtFcan3CZdUBU9oU7rRqhzzfp6nEuQ=;
        b=n0mAygPnpGtDqArxAoAxPzRy6dgkQZLGS3eY3bx9YWmyCLUpWC+4lNVD8P2RxQUV5a
         xulgXIpHKo8MR8qYhltXQkGCEfstvorjXe3zBBE4JkZbDJDSI+0HJTkfe9/JMX7y7K0p
         2ftHHqaJejqfQdBMy3U5H7QinATn6W5hy5SA5Pg75F7GjJExl5vDV8f+Dfyv2ULPfh/Z
         cMX9oIP4l8gGML4iZE4kR7FoJGoMH5f6TLjp5FDT8cdkdRbR0uDf1BnkDYIkwYq4LSXn
         SnRU4611/bE6Nq02ft7cAtFv4NpXBx08hd6A24LVE1GRO9wlsTVUWzXtYVbOAsyo66B9
         C85A==
X-Gm-Message-State: AOAM532BAThWRjosHZqF3RyY0/65ig3BaquaW5T/1Ze+E+aEWv22hQYa
        XZrFXgeKsbjfhvwUPUzoHYk=
X-Google-Smtp-Source: ABdhPJyOU4VlBzK+DMvvkpdNHot0wM4wwu2nmapSl+oHDq/a9gJPnw8H/NtbUi4mZoLCWJRjHaYUQA==
X-Received: by 2002:a5d:5105:0:b0:1f1:d115:c9f with SMTP id s5-20020a5d5105000000b001f1d1150c9fmr16227494wrt.77.1646822052049;
        Wed, 09 Mar 2022 02:34:12 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id s17-20020adfdb11000000b001f02d5fea43sm1410343wri.98.2022.03.09.02.34.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 02:34:11 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <0d4cf6ad-a374-51ef-5879-967de1c09cc6@redhat.com>
Date:   Wed, 9 Mar 2022 11:34:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 24/25] KVM: x86/mmu: initialize constant-value fields
 just once
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-25-pbonzini@redhat.com> <YifDh5E63lAkJraV@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YifDh5E63lAkJraV@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/22 21:58, Sean Christopherson wrote:
> Using nested_ops is clever, but IMO unnecessary, especially since we can go even
> further by adding a nEPT specific hook to initialize its constant shadow paging
> stuff.
> 
> Here's what I had written spliced in with your code.  Compile tested only for
> this version.

I'll do something in between, keeping the nested_ops but with three 
functions to initialize the various kvm_mmu structs.

Paolo
