Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED306605C4
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 18:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235303AbjAFRhU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 12:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjAFRhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 12:37:18 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DE97D9DB
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 09:37:17 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id b21-20020a5d8d95000000b006fa39fbb94eso1112959ioj.17
        for <kvm@vger.kernel.org>; Fri, 06 Jan 2023 09:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hBdWajpGgTVSFSM+SgsmRly6oW6Jqhbc8VPLCLHaxTk=;
        b=BLdbvIQn4bXEznMPq85NSoIfwhSJY9dT17IXX04NEEY28nrtMZdEL8oErq2J4CtXFw
         bQX0oXGd+ruPmpxQ+CsB/fy+l8KpE31Jl9kylzccoyj/kePBvX23Yth1phFheE5jMqu9
         eeaiz3iNNkZkNNeObL7qfVvpQkaCQEPGw19xO/QilblLxFJReeJIXoM/2NuIyYPq3f3/
         DLYswrKVsCiB9zZ7NQimtNNpxsOYW+vB57OyvvK5stxKs1NGN92oLFAE+Q8U4GsB+xRE
         5JWWjktSIoiJaKrbixDRJxYzTv+kW8GPav98/YwRC9u72GoQ/D+wjLEW0q9rEOeoqmnU
         Qdhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hBdWajpGgTVSFSM+SgsmRly6oW6Jqhbc8VPLCLHaxTk=;
        b=kyuhnbpXCWInBANdlS9AA45iQtYc0KE/TWjiRobPeg15rws7kbT/VH29irawxFgRxo
         N1hkfiApbRpFkJgmCP3dAb66F04kjOZlhVSVkzfOHyN0l5zoACAUvScu09e1nBI3VnGU
         LDTkQeJhKrIDDutKfdrVEfLTrwnr6Ipy2lMJZAf4Oh9Y/1klhk0EFuOlnIjeWr3zojfF
         lsNHcld9TEbSQT4sB750lq87iGH/gTUnP/B8JK+ZNvLI54uAqFrTz/4+Asa3G744v0Pq
         raVDDHtG8xDQI+dz4ohGX48SdWpCT04Xa/i9wnLPlPc+dTyeTrn6MxWd1bYpsbWnDQqM
         ZaHQ==
X-Gm-Message-State: AFqh2kpgJSr++R7F3lT1HfnvmtypdlEa242LakMM16SLktHOZESPjD89
        1Ks5ei3AuuAZM895/EO9Vjf/UWEkR1R6vRPJQA==
X-Google-Smtp-Source: AMrXdXvDZxrWBwEAYfcM7rW2ruUn7tl7QW7w8kY9EkKMU4RiAVZVquILKhc/6VIb2IHtlV9OdSqP3EmYJDTgsnJ4ww==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a92:2c04:0:b0:30b:fedc:9c72 with SMTP
 id t4-20020a922c04000000b0030bfedc9c72mr5009808ile.290.1673026636918; Fri, 06
 Jan 2023 09:37:16 -0800 (PST)
Date:   Fri, 06 Jan 2023 17:37:16 +0000
In-Reply-To: <20230106071124.ytv6cmkvmvxhzmoh@orel> (message from Andrew Jones
 on Fri, 6 Jan 2023 08:11:24 +0100)
Mime-Version: 1.0
Message-ID: <gsntwn5zr2cz.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [kvm-unit-tests PATCH] arm: Remove MAX_SMP probe loop
From:   Colton Lewis <coltonlewis@google.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     alexandru.elisei@arm.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        eric.auger@redhat.com, oliver.upton@linux.dev, reijiw@google.com,
        ricarkol@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andrew Jones <andrew.jones@linux.dev> writes:

>> We could cap at 8 for ACCEL=tcg. Even if no one cares, I'm tempted to do
>> it so no one hits the same little landmine as me in the future.

> TCG supports up to 255 CPUs. The only reason it'd have a max of 8 is if
> you were configuring a GICv2 instead of a GICv3.

That makes sense as it was the GICv2 tests failing that led me to this
rabbit hole. In that case, it should be completely safe to delete the
loop because all the GICv2 tests have ternary condition to cap at 8
already.

If we can't delete, the loop logic is still a suboptimal way to do
things as qemu reports the max cpus it can take. We could read MAX_SMP
from qemu error output.
