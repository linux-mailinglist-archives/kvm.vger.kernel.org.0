Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C4F365DDE
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 18:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhDTQwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 12:52:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57706 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233225AbhDTQwK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 12:52:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618937498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tZGILbW5lYeHumeP6O6QqclV3GEtjDxhfENCYh0m+CM=;
        b=DkoqLN9Lgyg4FvlU1k5FqUNgVmHyg6HhFfu/+8TKYgqIeiCCH6eN5DzGn9lLZlbX3r5jKt
        hia4pdm/C8hkE20PrAOP+444x4U+GMJ71u8UakNykPUPOL72pwc2t3x1/yjaVt80NgB6ek
        cW4qrBraByL/NwPWF3OLYxjGY94E/C4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-WBvdjw8RNqW1wzeP1RcOjw-1; Tue, 20 Apr 2021 12:51:06 -0400
X-MC-Unique: WBvdjw8RNqW1wzeP1RcOjw-1
Received: by mail-ed1-f71.google.com with SMTP id h13-20020a05640250cdb02903790a9c55acso13432383edb.4
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 09:51:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tZGILbW5lYeHumeP6O6QqclV3GEtjDxhfENCYh0m+CM=;
        b=H0D1yR6zRPd15akt9CEZlReE4KH3nmwROX+bgR+jgdvATyTMCSkhKvipFv+AX27ZtF
         Hyk1r+Xn75kpMaVHkiHiH3rxFjk5RWZqwXPVq1iSGllfH4vvK8CcjVYayZ5Tg471qDRB
         /lbhxVTlP43+TEYd+UFDcRl3sfQlGLhG+ObZUeiRg/HJ9yzWU+iU3I63au82Qs8hgdL+
         PMMuX/EoWWnbnOY1JAUyExQz1abGg8BK57zwqu8V64zOnUL3309qgefUo3UfFrxVtSwY
         X/qukw2CnCWbqb/iVAwudGpX5lm4fuhv9KLieUwHGsAz+nwu40ziJqlgxGfvZG4bd9q0
         8zRw==
X-Gm-Message-State: AOAM530F9V9xtpB7WWF696FIASPvsOXs73pw/l6neBK9jVBcd8U8csbU
        SgKXM4qRptN1+xcNnChtcrW/sLpeZzdrDt897ipqxhx7kfAKUqlXOdJ9JR5NFEx1X+QgFO0bSJU
        HHcQAdO0tXj9U
X-Received: by 2002:a17:906:a20b:: with SMTP id r11mr8780441ejy.323.1618937464919;
        Tue, 20 Apr 2021 09:51:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwL5KA4qQaeXGknmm3Xp+nypJu8k1ETUJbyg+XCSOizIJi3da9UkAOcK2L3vpIXCljtynanEQ==
X-Received: by 2002:a17:906:a20b:: with SMTP id r11mr8780434ejy.323.1618937464762;
        Tue, 20 Apr 2021 09:51:04 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id i2sm13198678ejv.99.2021.04.20.09.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 09:51:04 -0700 (PDT)
Date:   Tue, 20 Apr 2021 18:51:01 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests RFC PATCH 0/1] configure: arm: Replace --vmm
 with --target
Message-ID: <20210420165101.irbx2upgqbazkvlt@gator.home>
References: <20210420161338.70914-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420161338.70914-1-alexandru.elisei@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On Tue, Apr 20, 2021 at 05:13:37PM +0100, Alexandru Elisei wrote:
> This is an RFC because it's not exactly clear to me that this is the best
> approach. I'm also open to using a different name for the new option, maybe
> something like --platform if it makes more sense.

I like 'target'.

> 
> I see two use cases for the patch:
> 
> 1. Using different files when compiling kvm-unit-tests to run as an EFI app
> as opposed to a KVM guest (described in the commit message).
> 
> 2. This is speculation on my part, but I can see extending
> arm/unittests.cfg with a "target" test option which can be used to decide
> which tests need to be run based on the configure --target value. For
> example, migration tests don't make much sense on kvmtool, which doesn't
> have migration support. Similarly, the micro-bench test doesn't make much
> sense (to me, at least) as an EFI app. Of course, this is only useful if
> there are automated scripts to run the tests under kvmtool or EFI, which
> doesn't look likely at the moment, so I left it out of the commit message.

Sounds like a good idea. unittests.cfg could get a new option 'targets'
where a list of targets is given. If targets is not present, then the
test assumes it's for all targets. Might be nice to also accept !<target>
syntax. E.g.

# builds/runs for all targets
[mytest]
file = mytest.flat

# builds/runs for given targets
[mytest2]
file = mytest2.flat
targets = qemu,kvmtool

# builds/runs for all targets except disabled targets
[mytest3]
file = mytest3.flat
targets = !kvmtool

And it wouldn't bother me to have special logic for kvmtool's lack of
migration put directly in scripts/runtime.bash

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 132389c7dd59..0d5cb51df4f4 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -132,7 +132,7 @@ function run()
     }
 
     cmdline=$(get_cmdline $kernel)
-    if grep -qw "migration" <<<$groups ; then
+    if grep -qw "migration" <<<$groups && [ "$TARGET" != "kvmtool" ]; then
         cmdline="MIGRATION=yes $cmdline"
     fi
     if [ "$verbose" = "yes" ]; then

> 
> Using --vmm will trigger a warning. I was thinking about removing it entirely in
> a about a year's time, but that's not set in stone. Note that qemu users
> (probably the vast majority of people) will not be affected by this change as
> long as they weren't setting --vmm explicitely to its default value of "qemu".
>

While we'd risk automated configure+build tools, like git{hub,lab} CI,
failing, I think the risk is pretty low right now that anybody is using
the option. Also, we might as well make them change sooner than later by
failing configure. IOW, I'd just do s/vmm/target/g to rename it now. If
we are concerned about the disruption, then I'd just make vmm an alias
for target and not bother deprecating it ever.

Thanks,
drew

