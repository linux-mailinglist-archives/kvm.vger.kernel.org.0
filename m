Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4948E445D23
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 02:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhKEBDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 21:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhKEBDP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 21:03:15 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F18C061714
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 18:00:36 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id p8so5611185pgh.11
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 18:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5AsWWG+WUfnRqvVdyPwSZBhohM0u6yD1mbjUY07UvQQ=;
        b=Wj40ttb1/f0Ni3Dpwwh7PGzp2tLlAieYFhg2e0JliymKZdTTkMOcSEFRRoj+Ib0ovO
         53a8oGpagVSYUJ2EDzfDDMIP9dWw7v7B6SHv6tNJRlIK2c2wAsMmoveDumSYQQWtrm0y
         fINgTFun54Lvd9P5jVSwIoRUGiJb0PDOsFmY5eYpvPq+1A5s3xnewtCOeh602K0Ix6OY
         LCTuOpJR0j4R+24aoLXoAJkaZx76qgAUcjqhhIUgUk3vx4s8LYpJi/jc4v9cwC5PJ7Rx
         twcjNa8a3sVZtUSwK+fqkt9ljf5nSGpfX14uoZXp6nNjdc4ZEuLWQUeADLbXImDG0gPK
         1lcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5AsWWG+WUfnRqvVdyPwSZBhohM0u6yD1mbjUY07UvQQ=;
        b=yUgUYPsIQMhR6cGFzxP9VcQ6nEdWvuWcKdigK+UDCVo46tvFqeUrDpBQLw8lj76gNZ
         PI3Vx3eJhmU2ILpe16YxXXd4HU87JzvnPhDnsrI5MrwMR2x86XOx/Rst1OlYMdEoPYIO
         v/ceT7NFpELwpZ15RfYwLQT1xWcU0VM2iVwrRxjPI45BYoDmvof6xeuEWT5xWYLi5/M5
         fkUBBGOcdKa3gysXzxZAum/2qa1776D5fv1UvXHsSCt6aTf5OxU/xp/1uuw3Qk9uF+9l
         aNMEV40PS965XSf7lanOaUGN0Ml8a3+ldMTjl4uFyI4o0jXFWua1LhTERIEjw1Zh2RCp
         It/w==
X-Gm-Message-State: AOAM532QaOSy0EHrcf2OPJV2P3V67fWUUUKQmWxtYIZzhNC4SeyEu0/2
        8sJHa9g4sfqpXZ0Gf0tnnSEuHg==
X-Google-Smtp-Source: ABdhPJyExLrTk4AQNxZbAzjzFbNCCrY3MFN/MzFs3b2RpbUmtepP+C6fRZhxyvs07zJxE6TSksmFCg==
X-Received: by 2002:a63:1d53:: with SMTP id d19mr41014133pgm.85.1636074036255;
        Thu, 04 Nov 2021 18:00:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m10sm5124833pfk.152.2021.11.04.18.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 18:00:35 -0700 (PDT)
Date:   Fri, 5 Nov 2021 01:00:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] KVM: VMX: Introduce vmx_msr_bitmap_l01_changed()
 helper
Message-ID: <YYSCL2dum2be1rei@google.com>
References: <20211013142258.1738415-1-vkuznets@redhat.com>
 <20211013142258.1738415-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013142258.1738415-3-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021, Vitaly Kuznetsov wrote:
> In preparation to enabling 'Enlightened MSR Bitmap' feature for Hyper-V
> guests move MSR bitmap update tracking to a dedicated helper.
> 
> Note: vmx_msr_bitmap_l01_changed() is called when MSR bitmap might be
> updated. KVM doesn't check if the bit we're trying to set is already set
> (or the bit it's trying to clear is already cleared). Such situations
> should not be common and a few false positives should not be a problem.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
