Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0CA3367FC8
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 13:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236049AbhDVLtE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 07:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhDVLtD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 07:49:03 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003A2C06174A;
        Thu, 22 Apr 2021 04:48:27 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id f12so33518934qtf.2;
        Thu, 22 Apr 2021 04:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fs+IGrXgfxo2+Fjwm8mRibDjnAoxHASw5K6L87Sg2Tk=;
        b=ex/oPVozkvjmlaiusTuTxGvDzAYNqQIY2iHgUq6nOfsP9QkZyS2An5wO/PFciX4evb
         HkHM7NxksbslKV3zCmmEfAd474x5uWrdIJlpJsBTq4i98JQWfZBHUUzX1Nk0wfYQ3mt0
         nxnk0M6HaiqVy1OUoF6UZ4DS5A051gAIEPqE7a+4t2kfNWqqC05YcP/xeosol+FqtWSV
         lvTh8EcyE0AafTFFoVDj14QdwTigVeaPtINgax+44goW3365p2kD1gWYtDeOTm/zzJOh
         DyqySXvQoPWaG777/YA/N6UM45fbNpzQSC7VGTb/M3vsN/quH8AOkTfR8cTVkbzTBDZd
         AMyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Fs+IGrXgfxo2+Fjwm8mRibDjnAoxHASw5K6L87Sg2Tk=;
        b=aTeITSNsBpYaSwvv6JCPgNSwoRbAcff27N9j9/umUxqlNp+A0F+1+1ebf2A+humld/
         mht2tK1Z+Mi+EdDxP6K+AbK83dsEbLzfHeMINSaUsH9bakDN4QfNvjuXs5AB/aEAhLxf
         ih1Yfg9FtsVuioeFvzbFwQG9bT+1v6v0gAS0G/E9ov0e6mwSXp5/zYsUg2kZd50vPE1A
         kA+UFnhknwR06wxC1Do4D0oPClqJB1I9lcG+kSWe0FlucO4mNRGhqjvBXI1BduBA4ojh
         1P9wfuwzC7sD6UPccrECzhPU4OzCDNrm/ug4FiAa4zBN8B8dt4gRMYBYWHC6H0TMHmaX
         uZ/A==
X-Gm-Message-State: AOAM530giTflkUqL4n0uPcLxFrKIGrOGxIhGt5wtZZ8eZBCGk6An92Wy
        XmT8K0857Mudm8Dk6GaAEEY=
X-Google-Smtp-Source: ABdhPJwIrb+ODxaRMS+tT6vDrRUQXf+hfllCX1OLskilzyuoMwASaZ3e3xAC6v4xFoQGuRloePyN4Q==
X-Received: by 2002:ac8:4796:: with SMTP id k22mr2852559qtq.118.1619092107045;
        Thu, 22 Apr 2021 04:48:27 -0700 (PDT)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [199.96.183.179])
        by smtp.gmail.com with ESMTPSA id e15sm1793199qkm.129.2021.04.22.04.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 04:48:26 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 22 Apr 2021 07:48:25 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>, KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: linux-next: manual merge of the cgroup tree with the kvm tree
Message-ID: <YIFiiYtgL7/uvzng@slm.duckdns.org>
References: <20210422155355.471c7751@canb.auug.org.au>
 <124cf94f-e7f5-d6f3-7e7a-2685e1e7517f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <124cf94f-e7f5-d6f3-7e7a-2685e1e7517f@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello, Paolo.

On Thu, Apr 22, 2021 at 08:34:15AM +0200, Paolo Bonzini wrote:
> Tejun, please don't commit patches to other tree without an Acked-by from
> the maintainer (which I wouldn't have provided, as the right way to go would
> have been a topic branch).

My apologies, for some reason, I was incorrectly assuming it was all dandy
on the kvm side.

> Fortunately these patches are at the bottom of your tree.  If it's okay,
> I'll just pull from there "as if" you had provided a topic branch all the
> time.

I'd be happy with however you wanna resolve it. Please let me know if
there's anything I can do to help.

Thanks.

-- 
tejun
