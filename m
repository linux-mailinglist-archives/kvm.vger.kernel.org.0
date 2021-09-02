Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2163FF362
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 20:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347093AbhIBSql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 14:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232702AbhIBSqd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 14:46:33 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D76C061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 11:45:34 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id bg1so1760471plb.13
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 11:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lEEBF6xsk552CPIOj83KaBFMxYBUwypZP23tt0KbWuE=;
        b=MMkeB4uF/9SyXIGPdUMJ4188M9t81k8XFZXeqM1W8DVBotd/lfWhgCdeFNsZeH906P
         wuKSW2r7A2DyLEU55XhqQqHFc7206wB4i+oI8ADQBJH35WLvMqsL/4Ua+j7UbxjHJpJT
         Ta1vZSuHk8/6yM3SWuxKn48VP0KkqFSCobHAKfIUWgNNTrTaRtAupyzuJfNS6j4QZgkw
         913ra7IK9kErf468irvQCCn9uH09NGLyP6fgWurMywf2kja/gg+Wl/RwwpvvHzjgKAwa
         bF2m+9EQDDIeuX3EN0/mlepn5bCk5mJjbOKj0vx8690xDGenJ9Os7DsEe+cnmwE9J9ZJ
         i2sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lEEBF6xsk552CPIOj83KaBFMxYBUwypZP23tt0KbWuE=;
        b=igQFJKZewaD1/S3YExPbbtnP218D7QPCAnEmwfzptd8yHQt/qWxeYXGDhTs1wfRHbY
         74JAeo2JjHdZUeVodjQxCx2bNAvXg1M49S7vn1fNSFfj8wwjRT1QTaVzsp7YUYbJqPtK
         XjKAGsuOmKukr94xqgERNic9cpQ8E7D9Xgsi0HsYJ0d8OEibpgHE434n5JdCybpbXkOQ
         47vRaiSbyZGHQZXmjuUZN8YsbG7JahOuS52zQzDl79v79DJW1N8RH9WQ17YKQI3ACh1R
         wLxRWUzdIEraySVBMlvdT/LvOzV27FQDDgjCAuOB6/oW6so9OUKKBUzGBnG4rv4+t9dk
         JYcQ==
X-Gm-Message-State: AOAM5301EQ2e7Bgdcv3IFOpL3LH6HJc2JnDyuj09UMt9YfySC0sLptIl
        5WoT9xNhiRTHOt3N2G3feiRSDg==
X-Google-Smtp-Source: ABdhPJweX/Q6K6niTmuFVwjKCtGf+3t5dvzBE3ok7XReoLyBE+IPOhticzWP0YTieDnrWJpPSDBq/A==
X-Received: by 2002:a17:90a:7087:: with SMTP id g7mr5441727pjk.156.1630608333662;
        Thu, 02 Sep 2021 11:45:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d13sm2941781pfn.114.2021.09.02.11.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 11:45:33 -0700 (PDT)
Date:   Thu, 2 Sep 2021 18:45:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH 0/2 V7] Add AMD SEV and SEV-ES intra host migration
 support
Message-ID: <YTEbyYilbrLL9JSV@google.com>
References: <20210902181751.252227-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902181751.252227-1-pgonda@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please Cc the cover letter to anyone that was Cc'd on one or more patches.  That's
especially helpful if some recipients aren't subscribed to KVM.  Oh, and Cc lkml
as well, otherwise I believe lore, patchwork, etc... won't have the cover letter.

On Thu, Sep 02, 2021, Peter Gonda wrote:
> Intra host migration provides a low-cost mechanism for userspace VMM
> upgrades.  It is an alternative to traditional (i.e., remote) live
> migration. Whereas remote migration handles moving a guest to a new host,
> intra host migration only handles moving a guest to a new userspace VMM
> within a host.  This can be used to update, rollback, change flags of the
> VMM, etc. The lower cost compared to live migration comes from the fact
> that the guest's memory does not need to be copied between processes. A
> handle to the guest memory simply gets passed to the new VMM, this could
> be done via /dev/shm with share=on or similar feature.
> 
> The guest state can be transferred from an old VMM to a new VMM as follows:
> 1. Export guest state from KVM to the old user-space VMM via a getter
> user-space/kernel API 2. Transfer guest state from old VMM to new VMM via
> IPC communication 3. Import guest state into KVM from the new user-space
> VMM via a setter user-space/kernel API VMMs by exporting from KVM using
> getters, sending that data to the new VMM, then setting it again in KVM.
> 
> In the common case for intra host migration, we can rely on the normal
> ioctls for passing data from one VMM to the next. SEV, SEV-ES, and other
> confidential compute environments make most of this information opaque, and
> render KVM ioctls such as "KVM_GET_REGS" irrelevant.  As a result, we need
> the ability to pass this opaque metadata from one VMM to the next. The
> easiest way to do this is to leave this data in the kernel, and transfer
> ownership of the metadata from one KVM VM (or vCPU) to the next. For
> example, we need to move the SEV enabled ASID, VMSAs, and GHCB metadata
> from one VMM to the next.  In general, we need to be able to hand off any
> data that would be unsafe/impossible for the kernel to hand directly to
> userspace (and cannot be reproduced using data that can be handed safely to
> userspace).
> 
> For the intra host operation the SEV required metadata, the source VM FD is
> sent to the target VMM. The target VMM calls the new cap ioctl with the
> source VM FD, KVM then moves all the SEV state to the target VM from the
> source VM.
