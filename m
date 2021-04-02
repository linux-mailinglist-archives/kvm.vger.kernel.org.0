Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6815C352E8B
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 19:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbhDBRii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 13:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhDBRih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 13:38:37 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DFEC0613E6
        for <kvm@vger.kernel.org>; Fri,  2 Apr 2021 10:38:34 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gb6so3023929pjb.0
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 10:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fYfDl2QGW3vY+xNDySXOwLB7CXw0MXd8aq/OEuPIjAg=;
        b=df/YIFV1dTY4dQ0dVXeOYGPOCZZlAkMc2dm7/Q19M1gnYGNV7hA+4JX8qr8I2DLVg3
         ilGbPXwQM+MMe/D1vMsknvRloN9sC0+odiIDXFUIsTwANVq25Ol2GuFLoWh72TWHfQVT
         4yS5ng5BdBf1CX+C3vkXw6OeOpt6BI533oftHJanu/zVbjkrIiG9qH/IPPwkwTPV1HTL
         uRJofwHNJoSbkY337Wl9a39e/AH+/GhUlfnl9lwrDSdOn3E5vLznAdrORuG1SAkacOtU
         RdktmNZer+lrhazUmi/PzzlKhuM37hUsyEG5qQdSr8TIG/sfT/GWSqtyvT/JuI92eg6+
         q0kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fYfDl2QGW3vY+xNDySXOwLB7CXw0MXd8aq/OEuPIjAg=;
        b=Tygn3YU/74g++thXDOIbKyJwrOj4ysGvjuQKv1YObj7oIlb/gFfyBANpcawUiC9b44
         HrBkj1hLcsnBoxwUbhfeAvPPJGrLlxyVFpsGgTSeyZqCViU6PR7LhXt7uwANsDbS8R2g
         Ia3LJZIX/G1f4HwDhZGR14Kk96M5aPm98PfMyDat1/UoSzkg3hjH/r+fymaVoLxClHbb
         hAnlYDXJl3BimTtke73KmKUHz5JvBYrepvcv+jFbyaygSbSLPYi61eMcvzsqydjBgC2D
         ab3MhhTx+9sYd5fAYCeP8/2+JGvVNh7JMs4P3zptjkffT80lIgYyodkN1rR6bdCovcDb
         yCtA==
X-Gm-Message-State: AOAM532IFmR1kJAmGn/mHeJ20iSSz35RFkDWP/1URmNQ8AhiYeWvZEA4
        6taNsbxh0UqJZkq4dFntjBUWRBT1ugaGog==
X-Google-Smtp-Source: ABdhPJxkCa63bbLp8CJdgQVOfFUgLvKdi1QL/Sp++w5DNJgOkdIsv8ljcbSbk6NYyI4bkm0Tr/4Eig==
X-Received: by 2002:a17:90b:14f:: with SMTP id em15mr15607637pjb.20.1617385114353;
        Fri, 02 Apr 2021 10:38:34 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id d20sm8611403pfn.166.2021.04.02.10.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 10:38:33 -0700 (PDT)
Date:   Fri, 2 Apr 2021 17:38:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 0/5 v6] KVM: nSVM: Check addresses of MSR bitmap and IO
 bitmap tables on vmrun of nested guests
Message-ID: <YGdWlrrrG2vmDLdb@google.com>
References: <20210402004331.91658-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402004331.91658-1-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 01, 2021, Krish Sadhukhan wrote:
> v5 -> v6:
> 	Rebased all patches.

Please rebase to kvm/queue, not kvm/master.  All of the patches conflict, and
the conflicts in patches 02 and 03 are not trivial.

> [PATCH 1/5 v6] KVM: SVM: Define actual size of IOPM and MSRPM tables
> [PATCH 2/5 v6] nSVM: Check addresses of MSR and IO permission maps
> [PATCH 3/5 v6] KVM: nSVM: Cleanup in nested_svm_vmrun()
> [PATCH 4/5 v6] nSVM: Test addresses of MSR and IO permissions maps
> [PATCH 5/5 v6] SVM: Use ALIGN macro when aligning 'io_bitmap_area'
> 
>  arch/x86/kvm/svm/nested.c | 54 ++++++++++++++++++++++++++++++-----------------
>  arch/x86/kvm/svm/svm.c    | 20 +++++++++---------
>  arch/x86/kvm/svm/svm.h    |  3 +++
>  3 files changed, 48 insertions(+), 29 deletions(-)
> 
> Krish Sadhukhan (3):
>       KVM: SVM: Define actual size of IOPM and MSRPM tables
>       nSVM: Check addresses of MSR and IO permission maps
>       KVM: nSVM: Cleanup in nested_svm_vmrun()
> 
>  x86/svm.c       |  2 +-
>  x86/svm_tests.c | 42 +++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 42 insertions(+), 2 deletions(-)
> 
> Krish Sadhukhan (2):
>       nSVM: Test addresses of MSR and IO permissions maps
>       SVM: Use ALIGN macro when aligning 'io_bitmap_area'
> 
