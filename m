Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD72643564E
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 01:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhJTXOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 19:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhJTXOH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 19:14:07 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB8CC06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 16:11:52 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id h193so8470526pgc.1
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 16:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eGrv+CxXyYRvAs6KmTovHir34xOKh1cfsmwvnlS+YPA=;
        b=ZyGzazrKiKBIBaB6LY1znYanf7wW7e/va1RD+uQURf0sUYeUoAEUp/Jhjqr8EHo0r5
         +1EzU/Cihjq5POAXEdGpFS2Ou/kyfpO/nKKRkXgl0EF+6hd5+0woNlGbNJF5K0K7ok6S
         neu0PRSQ34K1mDkhj93nAFmbt2egR17JOmwrV73p6BOkKGvUuJPvksP83YrcpoukmIOQ
         z93jTQ55xuAwJeFGBIAinjNhcCirJIeoryTki9INOHpK1WX4eCfD2AcfoA8UjZoqLPr4
         umAIIcsa3CSEcFniT18lxpTaCcdkzyu4w0HghsXFYnuX3zxEy+7vEjS5eIBHXO4KF9hW
         TLTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eGrv+CxXyYRvAs6KmTovHir34xOKh1cfsmwvnlS+YPA=;
        b=7rbqbMPpupWDRyoeuHSrnUII9PplXptz2vXpNt5lAs46lajS85z2NoLEwrKsnmPkBZ
         HRxJ7RVhWHdCSb4lusFBEyg0idmUw1zo0kzRAzty2QU1Su6pSIsT3Um3z4HzQUOwf2/u
         oRaPGOGmCo6d9J4GsBWxxSGBj8rIcRsN5SK8sZdK8R0qJLwu1W5mYAtT1zMWjZ9b3jDb
         nrKHTUQ2FRvql5sh3EcT2i1HSziJGr8T4ZBre/G+9wVsf6BR+1bJqJNjzhXzQbGMdP2B
         pLwli3QDGaAj7e4UutEsnRmzOybVJufqYRyHCCzkpkzBKzJu21NLC+PnoRiePmKR2JY9
         Us0A==
X-Gm-Message-State: AOAM532w6uhNbKnkj4F0d1kelYnthAlMW5WMOteol48sYXjjSDHZNUAV
        Xm96E8XWpUosQEG9MLvfXAXe9w==
X-Google-Smtp-Source: ABdhPJwNRERW0ENkYdB0fchTa2Tapc3S8SdYVsoVnLrRyt3urhl+Wjfedr26NPBvaRjwKouC5nmnHA==
X-Received: by 2002:a63:bf45:: with SMTP id i5mr1612783pgo.161.1634771512106;
        Wed, 20 Oct 2021 16:11:52 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u74sm3647767pfc.87.2021.10.20.16.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 16:11:51 -0700 (PDT)
Date:   Wed, 20 Oct 2021 23:11:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Amy Parker <apark0006@student.cerritos.edu>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: Addition of a staging subdirectory to virt/ for in-development
 features
Message-ID: <YXCiM2iKZuiwnfjj@google.com>
References: <CAPOgqxEuo6VFAUWc5os6N1iPqh-mQrSg6d09Tj5vy82Gw=v-fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPOgqxEuo6VFAUWc5os6N1iPqh-mQrSg6d09Tj5vy82Gw=v-fg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021, Amy Parker wrote:
> Hello all.
> 
> Has the idea of having a staging subdirectory for KVM been proposed before?

Not that I know of.

> It could become a buffer place for KVM features currently in development/not
> production ready, but that should be able to be conditionally included into
> the kernel. With a staging directory, these features would be divorced from
> KVM mainline, but would be able to be rolled out promptly to users while they
> are being refined.

Can you give an example?

I'm struggling to envision a feature that is both large enough to warrant
"staging", yet isolated enough to actually be "divorced from KVM mainline".
One of the rules for staging/drivers is that the drivers are standalone and don't
require changes to the kernel proper outside of docs, firmware, and perhaps
exports.
