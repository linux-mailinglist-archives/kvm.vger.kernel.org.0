Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454ED2629F0
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 10:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgIIIQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 04:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgIIIQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 04:16:17 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C61C061573
        for <kvm@vger.kernel.org>; Wed,  9 Sep 2020 01:16:17 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j2so1903637wrx.7
        for <kvm@vger.kernel.org>; Wed, 09 Sep 2020 01:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TgRLP4q5OGn82juBkXRbqeOU9pLJPLAAlaD6tAhIZuo=;
        b=f/veN2q04gAM4BlXF9Lu2MfvC5lxzk+EgcOKFyfGVD1uKWl4grxtoHAh9JpUyI26Gh
         HgU7uel0zu2uAf0r5IVRASIz484fb4ylWVJrH9+qZbKjdsq4jhLe6OaIKPAryI/gCMza
         0OctU7r0x9pI8EaUD+aTUl6HwPEkNy4LDJasWBOmZtI5hDFzC7PY9OW35Www1WEBVqfR
         B9HJoHRUqH/hSetFglIBV3SUj2Bufl6bD6GmHJs683MqlFXORepuqa8JDUo8gMbFevCp
         texOZVrRAx6/Cl6E8bMDF+Xv8RSXZcIfoFXuYWzgLrgYlFyog+ll8tQN4IFSYrDmS5Bh
         5YvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=TgRLP4q5OGn82juBkXRbqeOU9pLJPLAAlaD6tAhIZuo=;
        b=DBZaI6JRdliklfa9wpUoNqPUc5wf8FE+CdZ+i9XQWzJkdSGspyu1yhxPS7EF16GfEd
         ImlpwQ+FviNroFyP1vdu80IuzgoJEx+MYWEKiXVebOi/M6rtF6B+iX38kUBi+8r1YsKa
         XDE0Ul4/ozLNMdArdohg3WdjI6BcLkdDS3lemlmpxcPOW5PmFjbAHeaJ0dBjwi4GwlAb
         67N0dqy+cOLYTwnF4hoPjUfrGb+TD4nhPWClU85glyw1IGMaNKbIaD3Una6FA7Fwpxxe
         VEQ1Wv6O72ohCvlziiSeUPDs/DEmd/ViB9omKQzPE2IvIQ0YVVXBbQ5MAEP0YocXBkr1
         R5Vw==
X-Gm-Message-State: AOAM5330DnRMvRqGMIP+ohJz5d5O6Z+IHXxTg/hszYmiqHDYkzlrgGi/
        hc+wojvOPO2wQDUP1rb4P24=
X-Google-Smtp-Source: ABdhPJynKwgxTDU21aA+T7PwUYuui0wPZ/RBZ6BdGK/DG3h0XEMd19JHZe2QToU91hZxi/vdYV1r0g==
X-Received: by 2002:adf:d0cb:: with SMTP id z11mr2621084wrh.192.1599639376272;
        Wed, 09 Sep 2020 01:16:16 -0700 (PDT)
Received: from gmail.com (54007801.dsl.pool.telekom.hu. [84.0.120.1])
        by smtp.gmail.com with ESMTPSA id c4sm3013426wrp.85.2020.09.09.01.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:16:15 -0700 (PDT)
Date:   Wed, 9 Sep 2020 10:16:13 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 2/2] x86/kvm: don't forget to ACK async PF IRQ
Message-ID: <20200909081613.GB2446260@gmail.com>
References: <20200908135350.355053-1-vkuznets@redhat.com>
 <20200908135350.355053-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908135350.355053-3-vkuznets@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


* Vitaly Kuznetsov <vkuznets@redhat.com> wrote:

> Merge commit 26d05b368a5c0 ("Merge branch 'kvm-async-pf-int' into HEAD")
> tried to adapt the new interrupt based async PF mechanism to the newly
> introduced IDTENTRY magic but unfortunately it missed the fact that
> DEFINE_IDTENTRY_SYSVEC() doesn't call ack_APIC_irq() on its own and
> all DEFINE_IDTENTRY_SYSVEC() users have to call it manually.
> 
> As the result all multi-CPU KVM guest hang on boot when
> KVM_FEATURE_ASYNC_PF_INT is present. The breakage went unnoticed because no
> KVM userspace (e.g. QEMU) currently set it (and thus async PF mechanism
> is currently disabled) but we're about to change that.
> 
> Fixes: 26d05b368a5c0 ("Merge branch 'kvm-async-pf-int' into HEAD")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

This also fixes a kvmtool regression, but interestingly it does not set 
KVM_FEATURE_ASYNC_PF_INT either AFAICS:

  kepler:~/kvmtool.git> git grep KVM_FEATURE_ASYNC_PF_INT
  kepler:~/kvmtool.git> 

  kepler:~/kvmtool.git> grep url .git/config
	url = https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git

So either I missed the flag-setting in the kvmtools.git source, or maybe 
there's some other way to trigger this bug?

Anyway, please handle this as a v5.9 regression:

	Tested-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
