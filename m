Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59DDF591943
	for <lists+kvm@lfdr.de>; Sat, 13 Aug 2022 09:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238155AbiHMHbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Aug 2022 03:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbiHMHbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Aug 2022 03:31:18 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C7381694;
        Sat, 13 Aug 2022 00:31:16 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 24so2534630pgr.7;
        Sat, 13 Aug 2022 00:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=D3wy9rQ7cVpBfdR+lwwp9TClhnX1lnTP3s5LxPW1Yu8=;
        b=fVkeznOkbaH9RNgock2tBYZXVMctqT5XvVUD0hz9bkDz+kT1421d5dJzqIFxKtXGqb
         wLdpC3igAwJus28SqqO64YgpdNt8uY7RgK1dF4tjRRFM3cDbSQYmKqYM5ghUcfom2Tt9
         Ai+RG5ryo2vTXcNKwTGGmymH8m8CjPY56Sb6WC3Q2v4cX1yd4vPdGd/DPgWUCkDsqvwj
         hKrggSHKLALs+ndQymUNMedE9y+m0HjwTpJDIeMA8v0Jg1lnZ7FQgico5SJAQBMAk/4B
         I2cw5ESo6GRFOmUnpjqc9roiC166S6o5FcoHzMQBrm6p6qhMwCBKB0FEAUHGydtrhX3n
         W5eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=D3wy9rQ7cVpBfdR+lwwp9TClhnX1lnTP3s5LxPW1Yu8=;
        b=4vZttjx4KGm04BIMN7tXJJe8wTseBUSYa2GCh7yZnF7kb+SYs5RfA3+vItzT+pqaIn
         FeEUhamSxrNvu6NIGspm0xA1Jp6T9oeHCuVEdggh15EUgw7Jhb8WPQSnqj9bGpqrULRM
         87ZIERoOl5NhBhwIt3bGVAzi1bmvxfyiPYN7UKrwmcsCyP0DXb7jsPVN1yQanaORTkju
         uxRYimd36k0Xb4XetFkuE+GLbE9cIDgAePHejoLl9fkSXYkGvS5jbAciGr8LWZFBp1Yv
         Rt1EzAGjVIN9DqHuJRMKcOJq6EHRazLqqbb9iDHCrseibbfwZh919o9Y0go/eYcfcTEn
         d7Jg==
X-Gm-Message-State: ACgBeo0/0bSPYcVqmXLVE8pXhCwZxmI0a0vtQf24Dwq0UyEkwBt7STKs
        Z1jAcJUZ6U751qURJM0seTTy0El+GfQ=
X-Google-Smtp-Source: AA6agR6brHizXhbnfNUznEA5ff0ffpS+SnQzhopJT/fnX3ibin+NJ1tOtwGZ3sb1wJJ0em862xx40g==
X-Received: by 2002:a05:6a00:2181:b0:51b:560b:dd30 with SMTP id h1-20020a056a00218100b0051b560bdd30mr7467073pfi.44.1660375876363;
        Sat, 13 Aug 2022 00:31:16 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-18.three.co.id. [180.214.233.18])
        by smtp.gmail.com with ESMTPSA id z7-20020a17090a170700b001f7613a9d0dsm939367pjd.52.2022.08.13.00.31.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Aug 2022 00:31:15 -0700 (PDT)
Message-ID: <d9931783-c70a-2ac5-5028-1ea0b79ea982@gmail.com>
Date:   Sat, 13 Aug 2022 14:31:09 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH next 0/2] Documentation: KVM:
 KVM_CAP_VM_DISABLE_NX_HUGE_PAGES documentation fixes
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        kvm@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220811063601.195105-1-pbonzini@redhat.com>
 <1db2a0cd-bef1-213c-a411-3d39d378743a@gmail.com>
 <d858ba66-422b-2bce-dafe-bc6586803e5f@redhat.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <d858ba66-422b-2bce-dafe-bc6586803e5f@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/12/22 14:40, Paolo Bonzini wrote:
>>
>> Thanks for picking this up. However, Stephen noted that the issue is
>> already showed up on mainline [1]. Maybe this series should be queued
>> for 6.0 release (as -rc fixes), right?
> 
> Yes, it's in Linus's tree already.  Thanks for replying to Stephen.
> 

Thanks.

-- 
An old man doll... just what I always wanted! - Clara
