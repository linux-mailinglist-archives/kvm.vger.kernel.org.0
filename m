Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607BD616652
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 16:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiKBPj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 11:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiKBPjZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 11:39:25 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6337A13D14
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 08:39:23 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id l6so16638105pjj.0
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 08:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wLzDceGAhJYUUv7ij93AITlgZbz7ZuZnjbQtBh4OPQE=;
        b=fNN5w2u5U/zO6eQZDwh32Y5mmO6nbENrhIkRcPOJrw6w0xyp8TCKdKoinElaRiyZSL
         ucFvIQMq16BWXYB9qJM6xFhIv/0fJuMedWJ1scen9e40F96GOXcysrgASjK/tgrrf7+p
         WvcKEkt1JZ6ifAkwqmxzJ3VpLVhVfcH0gHURzexRer5yFYcntJzm4xzriVj5LfeEvFAZ
         7h3bDl10oDbYYwpUFd/OTf7rqE8FL7PIfAGIwyuh/wCf8lFECJO/VTBSD+JHnFWU2vAJ
         5ntIk9av20oCsJRQELXUBhuOBZF01WZ1C58X4Nc0w8d0YwODdnYxBwQObEsrBvbNRX/7
         QfWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wLzDceGAhJYUUv7ij93AITlgZbz7ZuZnjbQtBh4OPQE=;
        b=tHoZpB7A9YrYvRDtuubzFmZBvNOcMuzr9k5DVEyLig1+OTYweq9+b6CYgmzETQEge+
         kYeytRK0CI7X1WN0gvaokgyRyCkZJ7ch7CJ9tf+AKNMZlBtI4SkGvPnzY4NW8+LoGKKi
         HE+XiCzTjWt9cjNmhZQJFeIHYbR6P++IdHsv4qArrR07nUMqIYoJ00jrAfmwYdCwtMr+
         ZmEr2AxYCUDAMt4prfo9pAm2fjjsJBK53zWiSBkPtyjIZRo0EsIUAhK0EnyKFFsAaeQH
         Hqk+2nNe0F7QbWRDnU7v+gM8UefjmQaFtGtuwl/uBywhysGPOsdiFdmK5W6EQl0Tpud9
         EDjQ==
X-Gm-Message-State: ACrzQf1fkZiNZrkIROf6IlDmRlr/WVr1u68M3uR6uP31rvp0Tj4JU2DU
        fjWoG2doe/n5g2a8YDHkwJEgGw==
X-Google-Smtp-Source: AMsMyM4mzfo37eCZ+2e6+LSRqO0T06TIxk83Xam6g7znq2DeOXVYw97H7I8hR9rPHms89/k34v4Irg==
X-Received: by 2002:a17:90b:4c48:b0:214:25cd:96e3 with SMTP id np8-20020a17090b4c4800b0021425cd96e3mr5826259pjb.188.1667403562726;
        Wed, 02 Nov 2022 08:39:22 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g28-20020aa796bc000000b0056cc99862f8sm8877673pfk.92.2022.11.02.08.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 08:39:22 -0700 (PDT)
Date:   Wed, 2 Nov 2022 15:39:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>, isaku.yamahata@gmail.com
Subject: Re: [PATCH 0/4] KVM: simplify hardware initialization
Message-ID: <Y2KPJjCZn0YKzSJl@google.com>
References: <cover.1667369456.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1667369456.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 01, 2022, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> This patch series include random simplifications of KVM hardware enable/disable.
> Although the past attempt [1] was turned out to be a bad idea, it has still
> useful patches.

I have a larger cleanup that includes all of these patches except "Remove a global
variable, hardware_enable_failed".  I was planning on posting the series last weeks,
but I've dealing with a comedy of errors.  With luck, I'll get it posted today.

I'll fold in the aforementioned patch as well, there are quite a few conflicts as
my series has a variety of bug fixes before it gets to these cleanups.
