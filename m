Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351F9606A71
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 23:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiJTVoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 17:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiJTVoS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 17:44:18 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A3B2248E1
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 14:44:17 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q10-20020a17090a304a00b0020b1d5f6975so992848pjl.0
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 14:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kuFCKI7axHmd2jRqicZMb9rEvO5yPn2nNaGoHy1dAXo=;
        b=abGoOiClb27M0TuotvHLVtgxNBZ9j/rOJAgECMDU5fEX/GbG9S4ii5itfex08l5C+B
         Ou+NbMnO0kjigVrYDo1P+nyS4JHPzTux2CVrGD4m7EWp4JHnFA5Y2SXpGfJgZ1RB43KK
         8wHCOXGgKrERSFDV2kvu+LdYWcwkk6mBwxHFAPX+/zo7yus9xFiDYF5R86myFeP212sU
         N3EMRdvq4kk1L15+kXesDAH53JBwAtHY0NA+RapCXVvHOoU0s01GywW5q/cZIyaCZzWn
         0eZm6+Asd22+dRRWZg6IwtoH9XwKeLj7owciILPyhLK9OI5uThciODq7My9/j0tLoE2A
         oQAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kuFCKI7axHmd2jRqicZMb9rEvO5yPn2nNaGoHy1dAXo=;
        b=rULHaz1HLGPxrw+Po5hvzc9yTFw4YSFtg/hiYAq8MiY8yO6p0n9FY6pcNXJAxX6/P8
         PB51hvsDVLXsGWeuSZ2+YApb7treBCiPy3yoKLsXQRyFt5jl6e29KU1gGfT/ASPbhyLY
         btyZ8HHmOjG0Q7YZ8TFzSYYecVgfJmlX2ZFM0P0aohDEXmNlxdCNlJIJ0uNmcLAo9sOG
         jtSVc137H6VjZEsqP6dl/7CKXxDIWNbeHREUwWfAVhL7HwK8dyW/kulm78jvBM4AR4lQ
         SxrfMiVMl27wMid7y7ZPauYxrg2HxqNMmPsbsCFU7YCWaOJ6ungQHdpkZQp6jEMopaZT
         L01w==
X-Gm-Message-State: ACrzQf1C1NkdZASLnYqvjKNmZIR5zA4kfhh/WdehYjVjktFQwbk6zrpR
        ROeDGVB2Vt7GzKqz97C+GFbC1g==
X-Google-Smtp-Source: AMsMyM69eKFLz3GwcTzgMPQwa8mbkiW7WDcQvtjO+Y08Y9GWNnRNFizF4CzUHPgF7abYOM+sscOvZA==
X-Received: by 2002:a17:902:a60d:b0:186:61f6:d7f4 with SMTP id u13-20020a170902a60d00b0018661f6d7f4mr5436012plq.75.1666302257026;
        Thu, 20 Oct 2022 14:44:17 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z88-20020a17090a6d6100b0020ada6ed6c7sm357157pjj.41.2022.10.20.14.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 14:44:16 -0700 (PDT)
Date:   Thu, 20 Oct 2022 21:44:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/5] KVM: selftests: Run dirty_log_perf_test on
 specific CPUs
Message-ID: <Y1HBLM7gZfGbFMwH@google.com>
References: <20221010220538.1154054-1-vipinsh@google.com>
 <20221010220538.1154054-6-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010220538.1154054-6-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Almost forgot, the shortlog should be something like:

  KVM: selftests: Allowing running dirty_log_perf_test on specific CPUs

since the test doesn't pin by default, i.e. "Run ... on specific CPUs" is a bit
of a lie.
