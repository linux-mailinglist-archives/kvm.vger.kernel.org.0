Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90BD42F6BE7
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 21:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbhANUOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 15:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbhANUOK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 15:14:10 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08A3C0613C1
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 12:13:29 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id m6so4026417pfm.6
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 12:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NIpPOOtRRpl0PpqRX6GCsaQ17rovktomf8jeDFYIOIo=;
        b=O+hZ5XgIA5CksQ7nO9FjUQg/ot0tlxVgTW72BKSa2qCQ7COqL2XMWB8avkmHI63pYp
         dVVXd6RFaMHyFhok0qKYmyYrL6r+HD7fY5TGAwBQ9CGslnNJAxye/69SUhvnXgRfO/DA
         rxIr3T8na7UtD/Xl0icV6M32+DUZB2Ubmsex+arRO0yOKU3CElZjY38LsfSOmnsyEU80
         YhY2ferPsp/DyWvGeBj0T4edD15q8TByxK0ct3ISbg4+pvkX1o1SzDVeL3iLNTBRUyh8
         FKHfogvonuyKQqBPvW/rYMqsyjd1oPRR2M7JDkUspT1ejwBpYZfGCEzWHZJ5t6bNUXNB
         T3fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NIpPOOtRRpl0PpqRX6GCsaQ17rovktomf8jeDFYIOIo=;
        b=O55z3Ss/MlTsx2g9ADu24Ddgg+WVFZavSaQGADQhaeqmaJ4kO5lEhylgPYEcEAibAF
         j23YlkUbYYiAHkdyHuZdLt4dPWS7rr+VEYv8l04nYd7tb5XqtTuf4u61EzM86SkAXJ8u
         +OcgLST3I9ttiNelvkTzlYbPEKnTKLGLL0HEvhFHxhANaSRoULUeCV+AgeZOilZy7z1n
         Rinwc5FR3tQi/3YL/Ey0sLiQNbLtUxUkz+quuRsfXqH/zu7PsMQiNcpumeCdJrwNbA0o
         pnF7mgr258h8xPDH1UOjwISuSK8VCzw2E5MJQmbNdF8y4QTbPi6TYnw12bEpKA5icU4r
         KreQ==
X-Gm-Message-State: AOAM533HNY8e4ESFGlPVAXG5/LcntmmwwXWnIUb/bS7ricbwsOsAQUEY
        iVSnDHPYT4hbX30KnoWkmFI2TA==
X-Google-Smtp-Source: ABdhPJwLJvbUJOChNiQVDLGlnGm2oEbj8HV6ia0UvI++wfQ2u4IMaBDJNiiRK7AcXOKAKgBo3siDDg==
X-Received: by 2002:a63:752:: with SMTP id 79mr8994629pgh.272.1610655209190;
        Thu, 14 Jan 2021 12:13:29 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id z3sm6008921pfq.89.2021.01.14.12.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 12:13:28 -0800 (PST)
Date:   Thu, 14 Jan 2021 12:13:22 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, mlevitsk@redhat.com
Subject: Re: [RFC PATCH kvm-unit-tests 0/4] add generic stress test
Message-ID: <YACl4jtDc1IGcxiQ@google.com>
References: <20201223010850.111882-1-pbonzini@redhat.com>
 <X+pbZ061gTIbM2Ef@google.com>
 <d9a81441-9f15-45c2-69c5-6295f2891874@redhat.com>
 <X/4igkJA1ZY5rCk7@google.com>
 <e94c0b18-6067-a62b-44a2-c1eef9c7b3ff@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e94c0b18-6067-a62b-44a2-c1eef9c7b3ff@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 13, 2021, Paolo Bonzini wrote:
> On 12/01/21 23:28, Sean Christopherson wrote:
> > What's the biggest hurdle for doing this completely within the unit test
> > framework?  Is teaching the framework to migrate a unit test the biggest pain?
> 
> Yes, pretty much.  The shell script framework would show its limits.
> 
> That said, I've always treated run_tests.sh as a utility more than an
> integral part of kvm-unit-tests.  There's nothing that prevents a more
> capable framework from parsing unittests.cfg.

Heh, got anyone you can "volunteer" to create a new framework?  One-button
migration testing would be very nice to have.  I suspect I'm not the only
contributor that doesn't do migration testing as part of their standard workflow.
