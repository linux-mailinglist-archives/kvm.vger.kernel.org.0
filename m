Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1727EA0EEF
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 03:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfH2BdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 21:33:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52322 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbfH2BdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 21:33:04 -0400
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 844C05AFD9
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 01:33:04 +0000 (UTC)
Received: by mail-pf1-f198.google.com with SMTP id t14so1153535pfq.15
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 18:33:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aUCBBKPneUXXEuiCVmgIIBKl8aLO0JeDP2Yet2NAVck=;
        b=mGdbG+gwSqClXJCB3x2t3W7Va0L5uTbFoHAtDZWxsnUh23m7xBXiVFRp3M7P3Aqqwz
         yXARf2Cyr8RXiemQk8zcJsD/fafuNg7Soy0rydqR7Q6ioENYCfCmd8LMWHhgzpJoaCE/
         BzEg8zSnF4LTLAOtt1DmHP7OmPqjT4nV30ZjaZcfsa0Dc2qbl3oHPzU1ES+nm06OlZg9
         6dOb7NlYRLpzhm1p9BbJuWVZr6qRxpBNTpJU07yODrE+D89jAhgYqtdmRp27NKr8OIzm
         sXtjqk6vi1mPfFUuXnlC72hHqB/LD3nIE0XNbaZ/2My8BHuxmVKGSaGwxoFjf5ijInss
         FDNw==
X-Gm-Message-State: APjAAAVQDY02irx8bqQ+bNrXkQngfiz5SuOg3htCGuqZUJFvKaGURSKD
        vfpIwwUL4rkrTDYhNLJtkWFbTRT7aNI0P2GOo8h1Mq41ZcF+yFkrXOYSXmD/jckEK588w/q+Izm
        4jsTBuxxGvQkY
X-Received: by 2002:a17:902:d888:: with SMTP id b8mr7120265plz.115.1567042383972;
        Wed, 28 Aug 2019 18:33:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzXgHT3ZZzOrcgMNnrLHO3EmcsXzSWvv4Jv9HO8bcFJ2YpIj2kFGw8hf4IW9XwifUfnLSU+5Q==
X-Received: by 2002:a17:902:d888:: with SMTP id b8mr7120255plz.115.1567042383816;
        Wed, 28 Aug 2019 18:33:03 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k14sm394261pgi.20.2019.08.28.18.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 18:33:03 -0700 (PDT)
Date:   Thu, 29 Aug 2019 09:32:53 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 0/4] KVM: selftests: Introduce VM_MODE_PXXV48_4K
Message-ID: <20190829013253.GD8729@xz-x1>
References: <20190827131015.21691-1-peterx@redhat.com>
 <20190828115106.2j6n7qust7uceds5@kamzik.brq.redhat.com>
 <20190828115230.7rctfb2w3whkonp7@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190828115230.7rctfb2w3whkonp7@kamzik.brq.redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 01:52:30PM +0200, Andrew Jones wrote:
> On Wed, Aug 28, 2019 at 01:51:06PM +0200, Andrew Jones wrote:
> > On Tue, Aug 27, 2019 at 09:10:11PM +0800, Peter Xu wrote:
> > > The work is based on Thomas's s390 port for dirty_log_test.

[1]

> > > 
> > > This series originates from "[PATCH] KVM: selftests: Detect max PA
> > > width from cpuid" [1] and one of Drew's comments - instead of keeping
> > > the hackish line to overwrite guest_pa_bits all the time, this series
> > > introduced the new mode VM_MODE_PXXV48_4K for x86_64 platform.
> > > 
> > > The major issue is that even all the x86_64 kvm selftests are
> > > currently using the guest mode VM_MODE_P52V48_4K, many x86_64 hosts
> > > are not using 52 bits PA (and in most cases, far less).  If with luck
> > > we could be having 48 bits hosts, but it's more adhoc (I've observed 3
> > > x86_64 systems, they are having different PA width of 36, 39, 48).  I
> > > am not sure whether this is happening to the other archs as well, but
> > > it probably makes sense to bring the x86_64 tests to the real world on
> > > always using the correct PA bits.
> > > 
> > > A side effect of this series is that it will also fix the crash we've
> > > encountered on Xeon E3-1220 as mentioned [1] due to the
> > > differenciation of PA width.
> > > 
> > > With [1], we've observed AMD host issues when with NPT=off.  However a
> > > funny fact is that after I reworked into this series, the tests can
> > > instead pass on both NPT=on/off.  It could be that the series changes
> > > vm->pa_bits or other fields so something was affected.  I didn't dig
> > > more on that though, considering we should not lose anything.
> > > 
> > > Any kind of smoke test would be greatly welcomed (especially on s390
> > > or ARM).  Same to comments.  Thanks,
> > > 
> > 
> > The patches didn't apply cleanly for me on 9e8312f5e160, but once I got
> > them applied I was able to run the aarch64 tests.

Right, because I applied Thomas's s390x port as base [1], considering
that that one should reach kvm/queue earlier (should be in the
submaintainer's tree and waiting for a pull).  Maybe I should post
against the current kvm/queue next time?  After all this series does
not modify anything of the s390x work so the conflict should be
trivial.

> 
> Oh, and after fixing 2/4 (vm->pa_bits) to fix compilation on aarch64 as
> pointed out on that patch.

Thanks for verifying and reviews!  Yes I'll fix that up.

Regards,

-- 
Peter Xu
