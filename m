Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF886723D7
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 17:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjARQoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 11:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjARQnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 11:43:24 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24061CADF
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:43:16 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id c6so37468879pls.4
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qlTWKzULfhjtXahWuoTA4ujxvjliqjjZ1bpc3IHkSZ8=;
        b=FENLDq/hyeeeKR87GVmGsNNSFDuZCm+qj4mte1rbSs2B+zxXRE5HnlEVoKcCGyB2AP
         iE47bLGpZs2ImdnZgOypbU44j6Fs1SzSjN2aqtKuD/P1je1SFv8gfwXVfJPbIG0JFtoH
         2me/r6J8dcs0KPxBPgIeZql7xg6xkYr4moIaDkR4cL27WDbG0XwLvbd2C64zE7IJiQbT
         xYcOCWkxVKuICJ7Ym8Nxqp57KHgyilm60vJeE3mxBldcUaZvKpxLwX6UJ6HP+PLDF+lQ
         8114U+4ad6dsrgkPS7o1RxiaNj0BcwoFLeHRN2/f/qJxfTOMYMcbDZ8lMcC99Ulwy3cm
         kYzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qlTWKzULfhjtXahWuoTA4ujxvjliqjjZ1bpc3IHkSZ8=;
        b=FT1AvWC4vy7QiM6Sj7pe4E3GTA/66eQdDxOssMl5F9H2Ciz1Eh/bq+8PkjuupYTSRF
         xraWzq6rIQvZGYt7h4jzLkaoUVeYWjjqomzZy4LbnPuvFmamfFScr4muKg1nDyFOCrAX
         Y+jF3p1SnyyE+kkoUo+ykvyz7PVzU7r3q7GmG9DIvX7I/zEwd1xbJpA5ck4/tABlPDC4
         CutuUT3ZE2+f1uvuIK3mvWupiu01n7B+QAT01NhNpd/eBkln5GSKDKLl9Ee/QoNwzHMT
         bzPRYXzV4W1jWaD3nPoCh3/FiqfCNvfLVtT2LzfRK3p1cn7Osv+R7GkZjekvgsTMOiTc
         OI2A==
X-Gm-Message-State: AFqh2kq6FhvA/KWeO306bUop/bPKf3O96G4CyMmFxvemxY6pVpq3dQcO
        PExscKGTNORT2buUAaYOiRk0GA==
X-Google-Smtp-Source: AMrXdXtIG9XUyQ7v5KTfolvlPaJ6VBoAscVEgHJWDxYsZm719fOsb3yUqhUXyMFRbxeNIpUBbuUcYA==
X-Received: by 2002:a17:902:c409:b0:194:6d3c:38a5 with SMTP id k9-20020a170902c40900b001946d3c38a5mr1804553plk.1.1674060196314;
        Wed, 18 Jan 2023 08:43:16 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o9-20020a170903210900b0017fe9b038fdsm23444137ple.14.2023.01.18.08.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 08:43:13 -0800 (PST)
Date:   Wed, 18 Jan 2023 16:43:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, bgardon@google.com, oupton@google.com,
        ricarkol@google.com
Subject: Re: [PATCH 3/3] KVM: selftests: Print summary stats of memory
 latency distribution
Message-ID: <Y8ghnd58W8F8e1GK@google.com>
References: <20221115173258.2530923-1-coltonlewis@google.com>
 <20221115173258.2530923-4-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115173258.2530923-4-coltonlewis@google.com>
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

On Tue, Nov 15, 2022, Colton Lewis wrote:
> Print summary stats of the memory latency distribution in
> nanoseconds. For every iteration, this prints the minimum, the
> maximum, and the 50th, 90th, and 99th percentiles.
> 
> Stats are calculated by sorting the samples taken from all vcpus and
> picking from the index corresponding with each percentile.
> 
> The conversion to nanoseconds needs the frequency of the Intel
> timestamp counter, which is estimated by reading the counter before
> and after sleeping for 1 second. This is not a pretty trick, but it
> also exists in vmx_nested_tsc_scaling_test.c

This test shouldn't need to guesstimate the frequency, just use a VM-scoped
KVM_GET_TSC_KHZ, which will provide KVM's default TSC frequency, i.e. the host
frequency.  For hardware with a constant TSC, which is everything modern, that
will be as accurate as we can get.  For hardware without a constant TSC, well, buy
new hardware :-)

vmx_nested_tsc_scaling_test.c does the weird sleep() behavior because it's trying
to validate that the guest TSC counts at the correct rate, i.e. it is validating
KVM_GET_TSC_KHZ to some extent, and so obviously doesn't fully trust its result.
   
For tests that just want to measure time, there's no reason not to trust KVM.
