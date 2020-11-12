Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40682B0CFA
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 19:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgKLSuN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 13:50:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33339 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbgKLSuM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Nov 2020 13:50:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605207011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ezfMrAap+fXa3t4i52A6nX+uMAjkOPipHJmEz0u1aI0=;
        b=h5P7+oJhcATBTEgdJ97xJvyjOKMFKvUCzlbMm9Hn20XNKVL5T8t5fDvTGRoXyejkoihedY
        MMYPVelmgv1umGr1ONBL0PqPwGbRbrIjmXx0Igt1HSl/b1u/obiRCUevhi+zLkvIkrfH9J
        hEGawSv0Ob0ee5hXPiEXff3DLBM/8Tc=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-i4LtBMwHNV60_7dODEKlKA-1; Thu, 12 Nov 2020 13:50:09 -0500
X-MC-Unique: i4LtBMwHNV60_7dODEKlKA-1
Received: by mail-qk1-f198.google.com with SMTP id x85so4937559qka.14
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 10:50:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ezfMrAap+fXa3t4i52A6nX+uMAjkOPipHJmEz0u1aI0=;
        b=UWLU9OdHGnHzInuSgkypCvXt3KbH8eL6mpuqmYiinaucDVc5wOSXDhX9N/fnFTCKP4
         uhlhMavVrnli3BjQRF3B5ay5lSOEj5873D/svyd3zDMLkzvXE54lylm+qtRljlmODJ6t
         Me0grHbgDrmH8jg/tCuccv9uFemOnYvmBD3o2bDkO+b5TYTS2NDV3XLriE11JNcs+yih
         hzWicRWzm7zI5t48SVJSicSvUfr6Pk2MnuIYzM6qgfJoknNIkTmrQCaxgbLP4xPmD99v
         bpAE693ltG0fXBl1I7jvLpqEAQ+nhb27Z8CNiYZSjtf6yq8Rwo5W+ieqC5YtOp3AY9W6
         HnRQ==
X-Gm-Message-State: AOAM530tUc7uiJAwfXEDiJCvQq5KGKaLPygZtCDVJPR1uo5qGLfFzqOB
        Od7lMJAC1juMJ2yWZhFFPnicfmq9NjFe5rY62KQlX6c48sY9qcVlS+yJPAPlwHa8CIeIVJlp5WK
        Wmc3kHM3VASPO
X-Received: by 2002:a0c:baa2:: with SMTP id x34mr1108166qvf.23.1605207009179;
        Thu, 12 Nov 2020 10:50:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw7ena7dno13U0Szo4oNrw8o6JHWRXae6n0shuxhdOGxJmvY8aA6aswTeivbOswWY/V+TRMZQ==
X-Received: by 2002:a0c:baa2:: with SMTP id x34mr1108147qvf.23.1605207008980;
        Thu, 12 Nov 2020 10:50:08 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id g70sm5038530qke.8.2020.11.12.10.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 10:50:08 -0800 (PST)
Date:   Thu, 12 Nov 2020 13:50:06 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v2 02/11] KVM: selftests: Remove deadcode
Message-ID: <20201112185006.GY26342@xz-x1>
References: <20201111122636.73346-1-drjones@redhat.com>
 <20201111122636.73346-3-drjones@redhat.com>
 <20201112181921.GS26342@xz-x1>
 <CANgfPd_R_Rjn+QT_yiUwpCUK3TUfmhSN6XpZ5=L17mhrtMi7Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANgfPd_R_Rjn+QT_yiUwpCUK3TUfmhSN6XpZ5=L17mhrtMi7Zw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 12, 2020 at 10:34:11AM -0800, Ben Gardon wrote:
> I didn't review this patch closely enough, and assumed the clear dirty
> log was still being done because of
> afdb19600719 KVM: selftests: Use a single binary for dirty/clear log test
> 
> Looking back now, I see that that is not the case.
> 
> I'd like to retract my endorsement in that case. I'd prefer to leave
> the dead code in and I'll send another series to actually use it once
> this series is merged. I've already written the code to use it and
> time the clearing, so it seems a pity to remove it now.
> 
> Alternatively I could just revert this commit in that future series,
> though I suspect not removing the dead code would reduce the chances
> of merge conflicts. Either way works.
> 
> I can extend the dirty log mode functions from dirty_log_test for
> dirty_log_perf_test in that series too.

Or... we can just remove all the "#ifdef" lines but assuming clear dirty log is
always there? :) Assuming that is still acceptable as long as the test is
matching latest kernel which definitely has the clear dirty log capability.

It's kind of weird to test get-dirty-log perf without clear dirty log, since
again if anyone really cares about the perf of that, then imho they should
first switch to a new kernel with clear dirty log, rather than measuring the
world without clear dirty log..

-- 
Peter Xu

