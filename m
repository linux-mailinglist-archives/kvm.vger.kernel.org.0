Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263E6307D91
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 19:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhA1SOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 13:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbhA1SH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 13:07:26 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBEFC061574
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 10:04:55 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id t29so4498208pfg.11
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 10:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l+c1w6fiiLX9kxCupjhibRajZzK8pqS48Kplrt4ilkA=;
        b=T3m9rl3PNu0va9eG4D3kmd7qcXfuWtB5669NgtCNk+n6h6gQt2JmZnPTA4O8551Qho
         uxSFmjeshjifkB0qCBN3OQyh4nyni1taYjzxvMVbZpVZag9E/lbT3dgwtJY27ooOeEXK
         yshp+XxJH/nqGrjxuT+1uF7RTeOLjotvJzUTNCUjB3XFmS8NVsx5K6VKE7o5YCPxZCJ1
         fWQnExyY8N/F/5INWDgZXRVtBWeGqUgST0zgxR8XrsFs3sp9gRLLQxe5kCwLzffH1fHC
         ggR/O4dsGCsjF16YlG7+mcvCh9hseMh6kwxyPNe/I3fZhe170acMeHwDvMU2tGGtb8jE
         LYdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l+c1w6fiiLX9kxCupjhibRajZzK8pqS48Kplrt4ilkA=;
        b=big1Zhan/qmpE1kji5S+Luwd6T/196bnE/dBcGpCNu58u8u4IrFQo0ovynaVzDG4TC
         sA5SfBNXgH9suvL35DcqblzIJf/BDB2WotZPoxRp26O0abVbIjA1i8s7CwHBd+C1ZHHL
         LTnjNGD035EpTXRBzzk+BoYxu3ccInD5V590YNBhy7XH7UdMELjnSpu5O+DCH/RvvlDZ
         N7dJuMkhQMjVbvH1Ghke6jFUJr/yElBouhJTN9AAntHMAAKrB+sPqsJEwjwjCZKAr6zk
         l3uofYVVW5YHPEJNf+9DDXpJ6FW02HKNbYOwJyd6ggAoDX30Cs9BdkmDGSInqReWD2CU
         lamg==
X-Gm-Message-State: AOAM530b8ddTV+Qp9mA6Ooyq/96HE7z1K7m+6/7zWKg/l21Z1lrNfQwM
        IQQeOX5jfo7lL4ouuuqLjG1FGR54nlJb0A==
X-Google-Smtp-Source: ABdhPJzgotNp2OoYBkNnmmQ6aWuLzyj9BkoBDCjhGVKIlPnXaes0QrP6iblBCQrSBBtvP0cxAs4q/Q==
X-Received: by 2002:a63:3e0c:: with SMTP id l12mr667543pga.165.1611857095234;
        Thu, 28 Jan 2021 10:04:55 -0800 (PST)
Received: from google.com ([2620:15c:f:10:91fd:c415:8a8b:ccc4])
        by smtp.gmail.com with ESMTPSA id fs21sm5558089pjb.30.2021.01.28.10.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 10:04:54 -0800 (PST)
Date:   Thu, 28 Jan 2021 10:04:48 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v14 00/13] Introduce support for guest CET feature
Message-ID: <YBL8wOsgzTtKWXgU@google.com>
References: <20201106011637.14289-1-weijiang.yang@intel.com>
 <c6e87502-6443-62f7-5df8-d7fcee0bca58@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6e87502-6443-62f7-5df8-d7fcee0bca58@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 28, 2021, Paolo Bonzini wrote:
> On 06/11/20 02:16, Yang Weijiang wrote:
> > Control-flow Enforcement Technology (CET) provides protection against
> > Return/Jump-Oriented Programming (ROP/JOP) attack. There're two CET
> > sub-features: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).
> > SHSTK is to prevent ROP programming and IBT is to prevent JOP programming.

...

> I reviewed the patch and it is mostly okay.  However, if I understand it
> correctly, it will not do anything until host support materializes, because
> otherwise XSS will be 0.

IIRC, it won't even compile due to the X86_FEATURE_SHSTK and X86_FEATURE_IBT
dependencies.

> If this is the case, I plan to apply locally v15 and hold on it until the
> host code is committed.
> 
> Paolo
> 
