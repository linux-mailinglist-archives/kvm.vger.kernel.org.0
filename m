Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EBD261936
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 20:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732010AbgIHSKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 14:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731558AbgIHSJw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 14:09:52 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A783CC061573;
        Tue,  8 Sep 2020 11:09:45 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id x14so144895wrl.12;
        Tue, 08 Sep 2020 11:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6JZbDRelE0owW3x0j2stbMNrtJi1xeSDNJV+jIvcxok=;
        b=gHO+xrMHUUdsCeckLxc7OvhA19uO0YUuTyw14LQYZAw/Mok/Go5mPTZnGc0CmXEh/3
         LnXzLzY7AoE0qeBn3fuNt3eL0OkYisum5yLi37LrRewcoem9q1TePg13gK85R/LiyP2j
         KFGY1sjkJ1f8BpKj92K6nHz/xsMFUl3X6GWYs81X3XvdLyWFmXAi279Pesty+FDWEI+7
         sz0coyljwaKkOU3Ad0eBMOwaKXvkVEp97iUTZK3fTJ3TC3MT5ADLr/nzLqYzq5CrJU8f
         HRpLJ5jfYu4F7FgwThKMs318mWjTqnSJkmB82svhz6tNXKbdpiNwl8/h0RhD/qayKfkA
         z+1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=6JZbDRelE0owW3x0j2stbMNrtJi1xeSDNJV+jIvcxok=;
        b=MqSeRxhdAswLsBiIuMWunWvvlseTD5XNPI6RUnCL7ia7Jl67HsxVgz/jjjEzysiJCK
         hlyIAm2cJm3FDe32GbOPgfsq/5fxek4L/XmySvB/9I3961R6rlkHxYmwiNiUOp+8b50R
         geNZR8QZqY2z4Qjojte8uAfNa9OzyMoVvRcN6WbVV2kN68VYxatAS75yi+CghZ5ZiRyJ
         lqkEiyBbY7/gZkoiyZCYVAdoU7zV7wm3wXsL7R8AuormYorWGsaDnzqbl/4BlnCwCP62
         l1IIqjWlDLtiQ+H4tYg63xG6FYjXo+9cQXRg/t/N8z62HVDyg6xhjuLiBhJChASxt4E/
         t74Q==
X-Gm-Message-State: AOAM530srLg9xZ19ByRhfk40jwdfBD3WpC/ZWXRpByu0gD9426JG+KRV
        xyheWBfMmMql5879sNzqSEA=
X-Google-Smtp-Source: ABdhPJyLCwvd4PQUlYNiGnEtDob4p7ltJumxZc9gJTkfDrpGEziRnHnF5z4CtY63hBWnE0JkGbGzZA==
X-Received: by 2002:a05:6000:151:: with SMTP id r17mr798967wrx.311.1599588581741;
        Tue, 08 Sep 2020 11:09:41 -0700 (PDT)
Received: from gmail.com (54007801.dsl.pool.telekom.hu. [84.0.120.1])
        by smtp.gmail.com with ESMTPSA id f19sm196652wmh.44.2020.09.08.11.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 11:09:41 -0700 (PDT)
Date:   Tue, 8 Sep 2020 20:09:39 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 5.9
Message-ID: <20200908180939.GA2378263@gmail.com>
References: <20200805182606.12621-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805182606.12621-1-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


hi,

* Paolo Bonzini <pbonzini@redhat.com> wrote:

> Paolo Bonzini (11):
>       Merge branch 'kvm-async-pf-int' into HEAD

kvmtool broke in this merge window, hanging during bootup right after CPU bringup:

 [    1.289404]  #63
 [    0.012468] kvm-clock: cpu 63, msr 6ff69fc1, secondary cpu clock
 [    0.012468] [Firmware Bug]: CPU63: APIC id mismatch. Firmware: 3f APIC: 14
 [    1.302320] kvm-guest: KVM setup async PF for cpu 63
 [    1.302320] kvm-guest: stealtime: cpu 63, msr 1379d7600

Eventually trigger an RCU stall warning:

 [   22.302392] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
 [   22.302392] rcu: 	1-...!: (68 GPs behind) idle=00c/0/0x0 softirq=0/0 fqs=0  (false positive?)

I've bisected this down to the above merge commit. The individual commit:

   b1d405751cd5: ("KVM: x86: Switch KVM guest to using interrupts for page ready APF delivery")

appears to be working fine standalone.

I'm using x86-64 defconfig+kvmconfig on SVM. Can send more info on request.

The kvmtool.git commit I've tested is 90b2d3adadf2.

Thanks,

	Ingo
