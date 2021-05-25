Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF51390680
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 18:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbhEYQWe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 12:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbhEYQWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 12:22:32 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38376C061574
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 09:21:01 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id e15so9985845plh.1
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 09:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XFC9iWJT/MQ8UEFztmuB49DTENqBYgd89Ij8J4hz14w=;
        b=bX5fLELA0/L/al7izHeFvwadEsP7L/qU8d3yun2fUzzW8+1Z7qpxKGvzfGm/2sky3H
         vwt/3hQ8/RBUy/fJFmqpnP+LYP2O5bOsA8RhtGjMp0TDQ+heuI8yfLb2j0+UaD8WIpq7
         TbvPoMMJUMtFcF7cPS6n75TDrTsKov7dQQaHeY9V2SIYjiZIe7ZflWyx9DcKTfJLAvPp
         gJcVDpwYsIT4QQxfJe70EfCfMCMA/C6WX9hC+EA47WABARytB+0krmDQMh1Uq7DHNYVz
         1GC1fC8cQfjPI2E1imroo2moXw8cM+2suiw6VQ09lkq7AStC+9qJjzBJEeMOf9FOX4IK
         r0Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XFC9iWJT/MQ8UEFztmuB49DTENqBYgd89Ij8J4hz14w=;
        b=GWVaSg3n7+YA0tz+1Sk1e+VdfEEjuKpILOx8ksQ9YJOem2RD4yWh6QKryOyodui2jQ
         WoRc/DnFXaY6dNoPbGzDa5Ngc/8Ps5U4jiLj3+dcW8iS/yf6E3HVYmi3uzqZAPEN3FVs
         qBOnkwJFB2sPj/WNPMP7ONaJzvuF045DVAzPME+4hStfyIJlo56pEh90bBy/FiyIKL/e
         RdlvH3U2WJDs4/68mWsqPwKPC+RxLBIO0uLHo8h+stE+LFAu5/gRd/LYICz8Ey9V1FIl
         +XaLTt7iR5P2jKUAcEmsUdMtA0wKQiiX9FnkC+dyOmdGFN8vIC5NzxLVASmRBBuDsrRV
         LSEQ==
X-Gm-Message-State: AOAM5335DcU1WFvMsvjg7dw8DAf2k8z0STA1a5nmaunZWeWupajC/cK7
        /UYUcnrqaM+ctxHr+Xu66jZXcw==
X-Google-Smtp-Source: ABdhPJz4EUTjaP4w7VQByc/KHY+qRzurLSemWKMMDKHGjZyqNhbJH+fDs0qdTtOturi+Xh3NixjSuA==
X-Received: by 2002:a17:90a:ec05:: with SMTP id l5mr5677044pjy.141.1621959660505;
        Tue, 25 May 2021 09:21:00 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id r28sm14388368pgm.53.2021.05.25.09.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 09:20:59 -0700 (PDT)
Date:   Tue, 25 May 2021 16:20:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     Stefano De Venuto <stefano.devenuto99@gmail.com>,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        rostedt@goodmis.org, y.karadz@gmail.com
Subject: Re: [PATCH] Move VMEnter and VMExit tracepoints closer to the actual
 event
Message-ID: <YK0j6MrOCFeQSHCa@google.com>
References: <20210519182303.2790-1-stefano.devenuto99@gmail.com>
 <YKaBEn6oUXaVAb0K@google.com>
 <5e6ad92a72e139877fa0e7a1d77682a075060d16.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e6ad92a72e139877fa0e7a1d77682a075060d16.camel@suse.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21, 2021, Dario Faggioli wrote:
> Hi Sean,
> 
> On Thu, 2021-05-20 at 15:32 +0000, Sean Christopherson wrote:
> > I 100% agree that the current behavior can be a bit confusing, but I wonder
> > if we'd be better off "solving" that problem through documentation.
> > 
> Indeed. So, do you happen to have in mind what could be the best place
> and the best way for documenting this?

I didn't have anything in mind, but my gut reaction is to add a new file dedicated
to tracing/tracepoints in KVM, e.g. 

  Documentation/virt/kvm/tracepoints.rst or Documentation/virt/kvm/tracing.rst

I'm sure there are all sorts of tips and tricks people have for using KVM's
tracepoints, it would be nice to provide a way to capture and disseminate them.
My only hesitation is that Documentation/virt/kvm/ might be too formal for what
would effectively be a wiki of sorts.
