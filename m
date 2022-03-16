Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C674DBAC1
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 23:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiCPWvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 18:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiCPWvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 18:51:14 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E722648;
        Wed, 16 Mar 2022 15:49:59 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1647470996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oza3ORRMqARx7p/WoE9Fpi6ZhDSJmA0eJgSO1gtAE88=;
        b=3iFeBkw9QokPXm8E3kGLD2F8X8Z+kjB9SRn7jOeJdcbg6Qr+OZ8fCgdMfny34hBqjB9X3+
        GhV/5/iuZ7depwPX6q7Sg6Y2VfUG4FOnX7FO6j47xNZdGRqB3+6ASKs3xzfdNVrvXDg59k
        Y0y0QX8ltbRFhD69d4DmT4T5xPY3Iof3nALlhuTYhw55hMrsR0zqCS8a+HQwpLs9A94ULU
        C2EoPjPS3YrnyXfvJJS0ad9N5rHNMKUEi3mXQILyLxaKm+WK3zEqUg4hs/r6vMPR/nZrno
        D17ipAX3i9M6Bz0YBnL3RXT4EW5jA+pznrscAbL6o4DyuAlohzo1Yu10MCt2Vg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1647470996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oza3ORRMqARx7p/WoE9Fpi6ZhDSJmA0eJgSO1gtAE88=;
        b=5cuXzme2YWlbjHrd8D7xR0J4mzlfQCEuN8HXENUHFH4zk4yY58GpGX/7FAldN1XE9yX99X
        q2+QyxudUhM22EDw==
To:     Junaid Shahid <junaids@google.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, luto@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 00/47] Address Space Isolation for KVM
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
References: <20220223052223.1202152-1-junaids@google.com>
Date:   Wed, 16 Mar 2022 23:49:55 +0100
Message-ID: <87sfrh3430.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Junaid,

On Tue, Feb 22 2022 at 21:21, Junaid Shahid wrote:
>
> The patches apply on top of Linux v5.16.

Why are you posting patches against some randomly chosen release?

Documentation/process/ is pretty clear about how this works. It's not
optional.

> These patches are also available via 
> gerrit at https://linux-review.googlesource.com/q/topic:asi-rfc.

This is useful because?

If you want to provide patches in a usable form then please expose them
as git tree which can be pulled and not via the random tool of the day.

Thanks,

        tglx


