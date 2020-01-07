Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7F31328F7
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 15:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgAGOdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 09:33:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56003 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727894AbgAGOdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 09:33:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578407621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LIlISc+oFNSUFYsXBbt0s1bPhdRwU0QuyhBE/WUY0LY=;
        b=TdaKxiFmZJo2RG9DZRjEaRqxxutHE4X+rPoA2MLul8t0bKR+/U2AMvcyvwRrpTYULuSQqq
        TnBJTWwgzFlqkK7yVo7gxFRYbj7ePkHXYhjY59vAH9sVQgZejM+wvD3wZcoJnRSs4q4813
        jUTz0XZv1Qswz0sxK6s7UFOtBA2EqnY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-VZDlsuT8ML-pguSGoND8Tw-1; Tue, 07 Jan 2020 09:33:37 -0500
X-MC-Unique: VZDlsuT8ML-pguSGoND8Tw-1
Received: by mail-qt1-f199.google.com with SMTP id d9so32141928qtq.13
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2020 06:33:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LIlISc+oFNSUFYsXBbt0s1bPhdRwU0QuyhBE/WUY0LY=;
        b=GWGyvW+6bhfaBLd6Dg6c/SJ2zJIP1DWhnHFwDB/YkukJopgVBHtoRPzJgPFVbsHyOX
         rUMnHiaGxw93AkjA478GmADXZvtJSuQEvZiQuxsuKgbIuHMRiX3Hscv8hLQS6dTNCvS0
         sIkBzcjQiy1TVDtSMoJd2tJbNHOdCQLrbqi1nLALRck5bpO0Lx/iWiXadC3AuTWfW91c
         EHn4ZM9u+e3PAADxX0n5NqzNjq5reTP0Dn1AL3WevW/pK4wwNvkLWXqoHvdVZu8fOfSt
         esXrIHQqS+hZkt2uELA735AQr/LfnWCFwU2W7ykzbnxdTZGkNZ1ERalYmSr3awyv67t3
         gw2A==
X-Gm-Message-State: APjAAAXfRWt9OjW9mzkKj2cppQOMq6DDtZ58NyqeV6QtYRPmqMYKdjPV
        lYxGcKLUnuY8dZoC5ANaGdbd7ZMXJk//cWJz9sAnz+t6jUyYIDzYUhuroQrGgp2LfoEdDXli2tg
        odzU2CzyGWX9W
X-Received: by 2002:a05:620a:1663:: with SMTP id d3mr89412681qko.204.1578407617059;
        Tue, 07 Jan 2020 06:33:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqwIGMDr1WALhNYI3XjsUL6aYAw4TNtgyas8iR6yCDYV5GmJoDkDtGiffkZzxsW1v0I7msmFFA==
X-Received: by 2002:a05:620a:1663:: with SMTP id d3mr89412659qko.204.1578407616724;
        Tue, 07 Jan 2020 06:33:36 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id a19sm22455306qka.75.2020.01.07.06.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 06:33:35 -0800 (PST)
Date:   Tue, 7 Jan 2020 09:33:34 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cannon Matthews <cannonmatthews@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 1/8] KVM: selftests: Create a demand paging test
Message-ID: <20200107143334.GF219677@xz-x1>
References: <20191216213901.106941-1-bgardon@google.com>
 <20191216213901.106941-2-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191216213901.106941-2-bgardon@google.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 16, 2019 at 01:38:54PM -0800, Ben Gardon wrote:
> While userfaultfd, KVM's demand paging implementation, is not specific
> to KVM, having a benchmark for its performance will be useful for
> guiding performance improvements to KVM. As a first step towards creating
> a userfaultfd demand paging test, create a simple memory access test,
> based on dirty_log_test.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>

It's fine to start with x86-only for this test, but imho it would be
better to mention that in cover letter, or reply to reviewer comments
on that you removed aarch64 from previous post.

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

