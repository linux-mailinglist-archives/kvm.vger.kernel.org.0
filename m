Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E11289F65
	for <lists+kvm@lfdr.de>; Sat, 10 Oct 2020 10:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgJJIou (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Oct 2020 04:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgJJIna (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Oct 2020 04:43:30 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EE4C0613D8
        for <kvm@vger.kernel.org>; Sat, 10 Oct 2020 01:42:30 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 7so9250874pgm.11
        for <kvm@vger.kernel.org>; Sat, 10 Oct 2020 01:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=zw+ntGIK+4G6XVO6IheBenaFyAxg8/PgVbW1KLkzc+g=;
        b=kAtqE8rxqEFhx6RrWlcuYkfe6Bh0jHnKIrwKy2wmLEIl1Y11CymQMKtimhisiLX9Y1
         6rQrP4ewAKDtAMTQi2avVroyk1d5KznraeHD/bNI8FZ7y5go7owfkecVaiWTjS3c86eR
         N+PK6iBu5FdswX1z8HdMgiCDAf/oq6tXOe1t2mSKBqty+jS7obGfs2ehdpnB4p/FTkwQ
         g/KxAqt8lxf89zUWkrK+yHXyT+QTP+UhazOlTlTqpVtZVH+YobkvdCPa2aAJa9qWYQjO
         NWOmIjs3RfbzNuQgzaLLCBrOBDwQYh0jrBXapK5nAeD0u9hhQTClEpEvnja2vBk1qPbf
         vaaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=zw+ntGIK+4G6XVO6IheBenaFyAxg8/PgVbW1KLkzc+g=;
        b=Lv2KXin8Fyd6MBD1yXdHH9SKQu1qlMqXZ3QRcE64KwV2wprG/9cRHkCptnYv8MiLlV
         UV5zuwesmm3S7gwvZlbvPWZ8ic5orZbu6C6sek09KYyHA2oTRvfXHtVQHoIfUP45HlR3
         gb55Bc65eodQfOx1Rb9uIKj5rCFLC2AXuuQhlhijT224sRHEC7TbAI43prSigQqKI4YL
         YgKdRxGdgSaU9q8J3dPNMPdRwiwDMW9KcSWPJ6QmDxyDPIyjiSGwaBlC2KN+YRocqa4B
         PBSs+HcVzoH9QvwiscXUrmbbGhzv/p6TPpsfOsG99RdVJH9ABPi79taazc9jL4r7AbaW
         kNyQ==
X-Gm-Message-State: AOAM533/gNMpXbv4wZq6iQn08aDygPls2C3QysURstsI77d8Hxs+quAU
        xIFOOQv+OTuAE7u6O2hs4ck=
X-Google-Smtp-Source: ABdhPJxDcmRk8nc9rFqq+RJS2T+icQFjDpnSSl5t3qm+Cs7vhazdx88hVrv5WqBSDRdTjR5ln+S2aQ==
X-Received: by 2002:a63:165b:: with SMTP id 27mr6239261pgw.197.1602319348617;
        Sat, 10 Oct 2020 01:42:28 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:25eb:9460:8682:b3b5? ([2601:647:4700:9b2:25eb:9460:8682:b3b5])
        by smtp.gmail.com with ESMTPSA id b6sm14363017pjq.42.2020.10.10.01.42.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Oct 2020 01:42:28 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: Add a VMX-preemption timer
 expiration test
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20200508203938.88508-1-jmattson@google.com>
Date:   Sat, 10 Oct 2020 01:42:26 -0700
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D121A03E-6861-4736-8070-5D1E4FEE1D32@gmail.com>
References: <20200508203938.88508-1-jmattson@google.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>=20
> On May 8, 2020, at 1:39 PM, Jim Mattson <jmattson@google.com> wrote:
>=20
> When the VMX-preemption timer is activated, code executing in VMX
> non-root operation should never be able to record a TSC value beyond
> the deadline imposed by adding the scaled VMX-preemption timer value
> to the first TSC value observed by the guest after VM-entry.
>=20
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>

This test failed on my bare-metal machine (Broadwell):

Test suite: vmx_preemption_timer_expiry_test
FAIL: Last stored guest TSC (44435478250637180) < TSC deadline =
(44435478250419552)

Any hints why, perhaps based on the motivation for the test?


