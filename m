Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B1C3921DA
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 23:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbhEZVSm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 17:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233536AbhEZVSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 17:18:37 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17627C061574
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 14:17:03 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id x188so1939185pfd.7
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 14:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k6mJe3ISeJnwgKzjO2ePdb3h4jxlFF2xvibZQHBvtTU=;
        b=aioJbj4TdMs8oefTrnLR/RoKtdmEYZ+pVc0W6RP1vQ1JmJM5awlKi2dp/cw6Fs0NsB
         Y5MJHOnxj9dalfPd5aQowX0ufZwk0Y/v8eYgEr6ZiFdBvknnYWtZbqTWEaiftUgK1xFd
         j6Qza8oh6mEh8D5AHSUZtHlJyAWd80LHSoAX46HIeJxlfXFufQyb60lGrunRAoiFiXJ6
         dfBZ6i8xsc1h1BibDsVcN+JCdhAqqqkmO07ncQv1qjjYBzLr6iwaGH0npX3TafSllbCt
         2/xaSiTFnIwUOJNpTqYIZGFa2SDC8gdWfi+XS523IOxo65GG1qEWbIrdtJTCZ0w1OtsO
         X/eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k6mJe3ISeJnwgKzjO2ePdb3h4jxlFF2xvibZQHBvtTU=;
        b=oMb1+xhbgudw7DJqH7IMqgh0l5dNBUg5iS8aFfIr87UmGg8N9qQHR+dbg7pSJ0qDPy
         vPwXeBgstCRdPJAGfQV7eSQdjwjtQ501JX45K7zCMKL56p6Yjm0EVAxAw3fvylWOQv2Z
         yfaNF3XNEiCKxjVhyTbeQ0sXbcnW59oz3lNdm8A2CxHF6+GUDlBKc681Dm684gJKTzsL
         60HevEluaJRYDlZTHQEKYXL3wCY0X0xtyWtYSMqjwIu5Ip5I97TJyJbM472UGm2lFfDY
         5BGCvm7flblawR4vp3G0gaqx00jfuYbLLovmX0PLzON9u/67ey1Y4B5+R0F9lwlcTFw5
         reLQ==
X-Gm-Message-State: AOAM5324Q6HbhPHgsOkysf6vIscz7uIV5K6CX70VAUb8/tu0fPJpMxGp
        Q8LgJmubTdZvfzy+LwU6FIT+Hg==
X-Google-Smtp-Source: ABdhPJym48czUmP/lanrXEC0yHDmgc7Ua1qA5PFNYQidngZyPGe+k+zNRRbvZVsNw5o2jDtj3K48gA==
X-Received: by 2002:a63:2307:: with SMTP id j7mr458220pgj.20.1622063822494;
        Wed, 26 May 2021 14:17:02 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id n21sm134181pfu.99.2021.05.26.14.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 14:17:02 -0700 (PDT)
Date:   Wed, 26 May 2021 21:16:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        Peter Xu <peterx@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: Writable module parameters in KVM
Message-ID: <YK66ymMQQawfgQUD@google.com>
References: <CANgfPd_Pq2MkRUZiJynh7zkNuKE5oFGRjKeCjmgYP4vwvfMc1g@mail.gmail.com>
 <35fe7a86-d808-00e9-a6aa-e77b731bd4bf@redhat.com>
 <2fd417c59f40bd10a3446f9ed4be434e17e9a64f.camel@redhat.com>
 <YK5s5SUQh69a19/F@google.com>
 <927cbe06-7183-1153-95ea-f97eb4ff12f6@redhat.com>
 <CANgfPd-wcyP_nNNSuXMcZ0S+fmkcOEpQaPTS_5EUmDsEVguSCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd-wcyP_nNNSuXMcZ0S+fmkcOEpQaPTS_5EUmDsEVguSCw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021, Ben Gardon wrote:
> I don't know if there's a great way to formally encode this distinction, but
> I see two major classes of writable params in terms of complexity:
>
> 1. parameters that are captured on VM creation and follow the life of
> the VM e.g. the TDP MMU
>
> 2. parameters which have an effect on all VMs on the system when
> changed e.g. internally we have sysctls to change NX reclaim
> parameters
> 
> I think class 1 is substantially easier to reason about from a code
> perspective, but might be more confusing to userspace, as the current
> value of the parameter has no bearing on the value captured by the VM.
> Class 2 will probably be more complex to implement, require
> synchronization, and need a better justification.

That assessement isn't universally true, e.g. 'npt' and 'ept' could be snapshotted
and put into (1), but as discussed, the fallout would be spectactular.  And on
the other side, the flush/sync on reuse flag is fully dynamic and falls into (2),
yet is trivial to implement.

That said, I don't think it matters because I don't think classifying params
will change anyone's behavior.  Each param would still need to be justified and
reviewed on a case-by-case basis.
