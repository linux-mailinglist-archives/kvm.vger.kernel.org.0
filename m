Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91730502C7D
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 17:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354970AbiDOPXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 11:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354959AbiDOPXl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 11:23:41 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4D75D1BF;
        Fri, 15 Apr 2022 08:21:13 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id r13so10990250wrr.9;
        Fri, 15 Apr 2022 08:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cGkDu2i2GdxYtNqqObyhG3QkfvcoNxTA99ftgz/Hirw=;
        b=TKAmKfwSPcxzDhqhY5jxlVKOgXT5Q/2pAUGVf90F3WbdAnAtdnD7lT1vN3T9iBjKAN
         /W+YbwTj8QkUz7L3NIzC3b6KxZa9l8VYL7QD7vfPQRsF3W6JlymoJ8iiQJg9uxO1L1YO
         Ra4zt0WhJJ7Mp8Ue7orM5ls9PDahXI70FqAsj+JdIMvwBf86hxJNstZ7qCb0rADrGUvJ
         n9WKxRHJP9L+y5nKfgW+bEiaizjOuJn+hOvcZlPRxQqdGe28KhjQijXOZyvReYZ7xU6h
         NevJ4Cw5JDr+jTV7eVwGai75OmvJOxSd1+ZOOmtKBYDPc6TXiapse/CDwpKGF9TaCeNN
         0fUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cGkDu2i2GdxYtNqqObyhG3QkfvcoNxTA99ftgz/Hirw=;
        b=wpjA1E9uySD4HTmIddM69RjU8ZKMb6dl80oNQN1AH6a0iMnmh9+hv5ad0/JL33JkEy
         wY36rhdb1mQBkA/f7c4WUiN6hjc71wUulJ47aOwaSJWkgR3n5n9xJG7lFrvxoa/xGpoX
         UoGVYvJY4ne0pL5Ns169elIHNY+E0nkIQL4LWm1EyYtgsS7PLFLSkTiMG7bTRidNMQQv
         SznDrOQBV6LWleiksKxPp8/Iz2y5KECCv+8s2/3jxA7Z2lighMPQrnLTuW8KDA3xph8z
         bSSWeU2cc32kxL42X/hjtr9uizwwlwTtY4GVLp2DlyCDZf4rUX5q2zlK/aUBGXwBV1tj
         aC8Q==
X-Gm-Message-State: AOAM531hUVCZhP25ZMHNyGeSwTU91Ar+evVM2l6pFoDfePckY+03LlWf
        gZ/hdN8oRG+qV3rqK2mySo9Xm9LDLPnFvw==
X-Google-Smtp-Source: ABdhPJzyRqa3FT/KLcNWej01rc5pgpcZYtYI+64/VsQnzCw14IDSWel/5ueHoNuYC1Kd2q2z3forgQ==
X-Received: by 2002:a05:6000:15c8:b0:207:b935:e918 with SMTP id y8-20020a05600015c800b00207b935e918mr6054717wry.551.1650036071741;
        Fri, 15 Apr 2022 08:21:11 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id r17-20020a0560001b9100b00207afaa8987sm5171744wru.27.2022.04.15.08.21.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 08:21:11 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <950d33c7-5e93-76ca-a2d8-9d69616fc98e@redhat.com>
Date:   Fri, 15 Apr 2022 17:21:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 053/104] KVM: x86/mmu: steal software usable bit
 for EPT to represent shared page
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <028675e255cb2a23186ebc7a94c06a47375c6883.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <028675e255cb2a23186ebc7a94c06a47375c6883.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> +/* Masks that used to track for shared GPA **/
> +#define SPTE_PRIVATE_PROHIBIT	BIT_ULL(62)
> +

Please rename this to SPTE_SHARED_MAPPING_MASK, or even just 
SPTE_SHARED_MASK.

Paolo
