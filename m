Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F1918224A
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 20:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbgCKT35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 15:29:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29127 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731136AbgCKT35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 15:29:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583954996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UpWdKtsYA3fHjHPlsL9HGZu1d8Px6uWFgZbDjJBywQA=;
        b=SoTx6PS79r5PRtBnO6cepESb7NzUPUGuKmQb6GJUNnNjiOqQR3U7LxuzIJii7KhxMhDLQV
        VpGhl+DqxCF5gEHVa//CUg8/jFx9Bkfje1z8lUUBb/rTyV1C7/ZkyDaO3RCUl7VWZ9Sugl
        vjLrg2tUZXhNjK4av65n2xKHyz9/bPs=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-yassmQpANlmumsQ7xA8Fcg-1; Wed, 11 Mar 2020 15:29:52 -0400
X-MC-Unique: yassmQpANlmumsQ7xA8Fcg-1
Received: by mail-qt1-f200.google.com with SMTP id z5so1926462qtd.4
        for <kvm@vger.kernel.org>; Wed, 11 Mar 2020 12:29:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UpWdKtsYA3fHjHPlsL9HGZu1d8Px6uWFgZbDjJBywQA=;
        b=jTH/lq2j41+bk1Deb6KhOWwbx3RukKwvkajWhaix1I1MyqdF/A8gAZbdCDw2e/HDju
         dxUicLGGGetB88oIn66H+Q3OUT/JOE1eg0k9EFKstYXKktyCggGHgU6Tbx3S4dPIqltx
         5uNvRbFfcZgylDk8DgykblYRFN55HDDx91KoQ5ztx2e7d2m5p6tw+RxsiNQCuuyk86Lk
         yp/iqe9zJA/rDnUgqCUn0xzAmuvbfxozE2wcuf74L9KoYKFsRRcq+x7GV8XgqlF5+mhM
         0nCeAjtiM8NEl4N1Sbb8iZ0NdMjrw8Q+91dgXM7Ps0P17Ob1lBCI6aEFyS2sYZo1Ogu+
         h7Wg==
X-Gm-Message-State: ANhLgQ2D13vTw3Y9nIXmqOV4ZrqP+T9gkLbe7bzka7mphzX0G7wmNnRo
        /PVT5sKHCqBoZawWXRjlvrM6wwcfeqEHacUfqVmSW5YCBbpW7bBoxR4i410sQ4gtlhm6O2UsTbI
        u4BKFcB0UoGMc
X-Received: by 2002:ac8:538e:: with SMTP id x14mr4193785qtp.301.1583954991940;
        Wed, 11 Mar 2020 12:29:51 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsYk0SYigJtkWNeb3g8ML5Mt4KU7uElB0H6+oIeciTZn3noE4ZqrFa56Oq8FGpjc3mHPtFcJw==
X-Received: by 2002:ac8:538e:: with SMTP id x14mr4193767qtp.301.1583954991589;
        Wed, 11 Mar 2020 12:29:51 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id j17sm26696883qth.27.2020.03.11.12.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 12:29:50 -0700 (PDT)
Date:   Wed, 11 Mar 2020 15:29:49 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        thuth@redhat.com
Subject: Re: [PATCH 0/4] KVM: selftests: Various cleanups and fixes
Message-ID: <20200311192949.GL479302@xz-x1>
References: <20200310091556.4701-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200310091556.4701-1-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 10:15:52AM +0100, Andrew Jones wrote:
> 
> Andrew Jones (4):
>   fixup! selftests: KVM: SVM: Add vmcall test
>   KVM: selftests: Share common API documentation
>   KVM: selftests: Enable printf format warnings for TEST_ASSERT
>   KVM: selftests: Use consistent message for test skipping

Reviewed-by: Peter Xu <peterx@redhat.com>

I'll rebase my further tests against this too.  Thanks!

-- 
Peter Xu

