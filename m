Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4F15105E9
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 19:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiDZRyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 13:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353846AbiDZRwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 13:52:32 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DFA189282;
        Tue, 26 Apr 2022 10:49:23 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id m22-20020a05600c3b1600b00393ed50777aso2060804wms.3;
        Tue, 26 Apr 2022 10:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GRjbKlr19Mn5FxSswFnS14l/zAFp26BdYRhHkX31QzQ=;
        b=SwTUcIrS5vPJhHyu9bW1ZNIP4QBQ44Kyj4iNx6wCNlsTlrQSWgKqT9QFTUvYG/JdFc
         QSJO7F1tUpiBtEsf9hnDYJbjv/c84yq1TrQybx0CvMl0nHW8+TzLZyoEtRWBnhSTYXPZ
         tkXGhd8xjfk8+vxU3+PogE30P5sD1tkvdULQv1gf+Lkpgtoq5FMRaVGWHw9JurgL9Nsz
         tVRRJldonghoAKdgZPtg+axEMZIy5Rc1d2VFmihbNIY8L6v/8FS8SSI3Yv9ZdxB8mss7
         rOwYFnZZml+lgjly1B5yepYXvpCrRKJc+TwRJrQGuea6qt8N9CckYjN1/Io3qGRYoLLK
         9BQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GRjbKlr19Mn5FxSswFnS14l/zAFp26BdYRhHkX31QzQ=;
        b=BM2FBSRz8S3Iwcb5BJhIc0aTe3+S5i/JHcWP5EbPqHl44iGNXq6v23YM/WNiYFzmg9
         z6GJJMdyLgIWokpTBzM6+y1IxA9AMvCENraA/O7cFn1ambRXrO6nxYgMa9FWH6W6QWj7
         oPDciOBsJBwFmIKVgOb1VlssNVcLm43p7ek+VWRqfixthX6fXqY1mWut2CUv0DwKZNmc
         CqIqPBoYVJwLNuSS/BAM3JkeLrHojLq0c3ccafuwaM+uwiS6eChbny8mBu/BDy+uCYFt
         91IkcakRHo8rI2KJ+j59ftw4k8E8Bab1+v1SG0ct/BpU5eXlUu+7NELWlO9SVLPNvEL4
         3MFA==
X-Gm-Message-State: AOAM533hFNLSCct4bknq1QLZKA9DCQjVIF9wmKaZt+W2Y2TU3q8YHgBd
        F7pQSXNlGOZmECt5A45HZgHNM44XujXA/w==
X-Google-Smtp-Source: ABdhPJzieD9OQcSSZ9JZSvdRZZLQuU62MR3EqRdMG4NpbV7ThNL3nBL3PxZ9ZjCW4OkiAVvynRC5Yw==
X-Received: by 2002:a1c:545a:0:b0:38e:b1d6:9184 with SMTP id p26-20020a1c545a000000b0038eb1d69184mr22524419wmi.32.1650995361769;
        Tue, 26 Apr 2022 10:49:21 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id u19-20020a05600c19d300b00393f081d49fsm3809222wmq.2.2022.04.26.10.49.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 10:49:21 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <7597fe2c-ce04-0e21-bd6c-4051d7d5101d@redhat.com>
Date:   Tue, 26 Apr 2022 19:49:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] KVM: x86/mmu: add lockdep check before
 lookup_address_in_mm()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Mingwei Zhang <mizhang@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
References: <20220327205803.739336-1-mizhang@google.com>
 <YkHRYY6x1Ewez/g4@google.com>
 <CAL715WL7ejOBjzXy9vbS_M2LmvXcC-CxmNr+oQtCZW0kciozHA@mail.gmail.com>
 <YkH7KZbamhKpCidK@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YkH7KZbamhKpCidK@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/28/22 20:15, Sean Christopherson wrote:
>> lookup_address_in_mm() walks the host page table as if it is a
>> sequence of_static_  memory chunks. This is clearly dangerous.
> Yeah, it's broken.  The proper fix is do something like what perf uses, or maybe
> just genericize and reuse the code from commit 8af26be06272
> ("perf/core: Fix arch_perf_get_page_size()).
> 

Indeed, KVM could use perf_get_pgtable_size().  The conversion from the 
result of *_leaf_size() to level is basically (ctz(size) - 12) / 9.

Alternatively, there are the three difference between 
perf_get_page_size() and lookup_address_in_pgd():

* the *_offset_lockless() macros, which are unnecessary on x86

* READ_ONCE, which is important but in practice unlikely to make a 
difference

* local_irq_{save,restore} around the walk


The last is the important one and it should be added to 
lookup_address_in_pgd().

Paolo
