Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7706C76D218
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 17:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbjHBPek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 11:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235230AbjHBPeN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 11:34:13 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59152D4B
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 08:34:07 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d3c37e7f998so1305180276.1
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 08:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690990447; x=1691595247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=47vDOuTOmJODDoHf0fxLE5q0pUVLmeIBs4RrnBhQarw=;
        b=tushyJeIL89dg+jXepENaNyG+dF/l1MxwZcJBdG+7wxGxsLN9bduWzn02ddwxLqblm
         BuSzzFSqQaQfpnmtfO3rwVhaF25VH9gazvQlpcBtMRgbI8ZOZL4bB7QCgbU91sCltTvD
         JHehLkrbr7mJzCArjIQc45EmYzQQpcy+CHj+nYUge354nDpoA999/ayHvZVvUgPurpai
         vR8ThVmfHX8T7xNDFUHWubq1LqI9vCDK7y4otiM0mly3s/djxhbU75kmF0UYRm+hJu0P
         AMjc/R7LVqVnY3zs+scjfTIKGUD9oXJvhHigXV8vZQbCKL0Uauij2snxHYJNHm9bJ9T9
         VjhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690990447; x=1691595247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=47vDOuTOmJODDoHf0fxLE5q0pUVLmeIBs4RrnBhQarw=;
        b=bBXO5L18UUws1SPdP/hMajKhQxcUjWfPhliD9QTOnKidPdq6NMPa8A+T24X8Z4Pvp3
         KwIRrv06X0rniydF7hMiGiA1/NxlmJbqik4E5WCr6TfHxH78/dyF2gYYLTZ0N4KQUy5e
         1+AllksrsQidBqMCvQTL/JA/1ppDNMV9+M85HEtYfzMwpD6AtFaK+dHfBykr6sRzeSVS
         /+d/87ddh2ik6fy09RbiVGtTC1iNvavOfncGuX1nVQg2YTVanfumFc1fpCm/ClY7I7xJ
         EE9PX6OAcK9r9U+OIGUNj0r55o2p0TXcJ3yuoD8okaeu+GLVReh+bFj1XkCgATcmOTSn
         GeqQ==
X-Gm-Message-State: ABy/qLbaBdHcvTtcDNmeyji0zkmklb9sYJW0j6nslB1NETXcuuVQCAn5
        6C58VBfcu5VE9iYvYu4T3cz/cgdjTkc=
X-Google-Smtp-Source: APBJJlGG2HpboFgUMWcWAi0VABvoT+IpvDRegZykcMjH6q8E+EQTsUL6kjM/4fH8ZCoLEe2Ia2QBdt+C3P8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:11cb:b0:d16:7ccc:b406 with SMTP id
 n11-20020a05690211cb00b00d167cccb406mr193848ybu.5.1690990447020; Wed, 02 Aug
 2023 08:34:07 -0700 (PDT)
Date:   Wed, 2 Aug 2023 08:34:05 -0700
In-Reply-To: <CAG+wEg3X1Tc_PW6E=pLHKFyAfJD0n2n25Fw2JYCuHrfDC_Ph0Q@mail.gmail.com>
Mime-Version: 1.0
References: <ZHZCEUzr9Ak7rkjG@google.com> <20230721143407.2654728-1-amaan.cheval@gmail.com>
 <ZLrCUkwot/yiVC8T@google.com> <CAG+wEg21f6PPEnP2N7oE=48PBSd_2bHOcRsTy_ZuBpa2=dGuiA@mail.gmail.com>
 <ZMAGuic1viMLtV7h@google.com> <CAG+wEg3X1Tc_PW6E=pLHKFyAfJD0n2n25Fw2JYCuHrfDC_Ph0Q@mail.gmail.com>
Message-ID: <ZMp3bR2YkK2QGIFH@google.com>
Subject: Re: Deadlock due to EPT_VIOLATION
From:   Sean Christopherson <seanjc@google.com>
To:     Amaan Cheval <amaan.cheval@gmail.com>
Cc:     brak@gameservers.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 02, 2023, Amaan Cheval wrote:
> > Yeesh.  There is a ridiculous amount of potentially problematic activity.  KSM is
> > active in that trace, it looks like NUMA balancing might be in play,
> 
> Sorry about the delayed response - it seems like the majority of locked up guest
> VMs stop throwing repeated EPT_VIOLATIONs as soon as we turn `numa_balancing`
> off.

LOL, NUMA autobalancing.  I have a longstanding hatred of that feature.  I'm sure
there are setups where it adds value, but from my perspective it's nothing but
pain and misery.

> They still remain locked up, but that might be because the original cause of the
> looping EPT_VIOLATIONs corrupted/crashed them in an unrecoverable way (are there
> any ways you can think of that that might happen)?

Define "remain locked up".  If the vCPUs are actively running in the guest and
making forward progress, i.e. not looping on VM-Exits on a single RIP, then they
aren't stuck from KVM's perspective.

But that doesn't mean the guest didn't take punitive action when a vCPU was
effectively stalled indefinitely by KVM, e.g. from the guest's perspective the
stuck vCPU will likely manifest as a soft lockup, and that could lead to a panic()
if the guest is a Linux kernel running with softlockup_panic=1.
