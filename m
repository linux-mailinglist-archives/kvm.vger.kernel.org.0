Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9FF01762DF
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 19:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgCBSko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 13:40:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57929 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727514AbgCBSko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 13:40:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583174443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s/Od6bd1uZAYcj3IIa+YSzSqz+jcZdgE1dUcSgs94wk=;
        b=Uh3LSavYIY9KW3ZrSKwnfyfxYg4gMvD+cWfixXrFp4i83Rqq8VDJjag/5YhnEqDkZtm/Ds
        gh+B47Uk3G0mY5EKDd4Lepgu4udO7lGYN0NUnucTUu5bsm/xtpWeqNyTdSZ1nHixo44O3F
        cFh3/XuD6ucnaiYXznpuQn5kgLBAoTg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-i6e9zhoPPYeLEUeBTtR8_Q-1; Mon, 02 Mar 2020 13:40:42 -0500
X-MC-Unique: i6e9zhoPPYeLEUeBTtR8_Q-1
Received: by mail-wm1-f70.google.com with SMTP id p4so167230wmp.0
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 10:40:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=s/Od6bd1uZAYcj3IIa+YSzSqz+jcZdgE1dUcSgs94wk=;
        b=TSw87VCqSo/isNkntYC0/mr37aUbTJPSdnY9yK44XHTQbPjHqi52tMKitkBMHDmjlJ
         DwMMOU422atZ/uGJtOS/zdS9vyzTLXm+YTIM8IRts7lxZm2gtdpzIk1HqeBWQoPB6sWB
         0W7U71EUaEwFoFmNKXPyZNU3bWybU84vlF8QprsWPvDi/71Sy372H94Bvfzfohplkdgf
         5zSRVjbYeX3+k4rACgyTigSr7lNBJOQOx2g8vwzxeH4xOtTMIy1bPjqul8kz8kHGU0+W
         douygPb3E+L77OhEne8+AoNacjw5hDUpMmxYkWHhR5/11pWzoJpDvyZIW6oPuX+0n6bs
         aFYQ==
X-Gm-Message-State: ANhLgQ2H1tiZl9qAp9EgpZtGEaY0Cbl7gwJKOPEHAVET1BFW4ksXbGT2
        HPu8K41voszvZAD+JvVWX39+v32IXqpAusD7zMFPBIzZu9fKJ4wv+B956x0Kln+LOsgyXpLG7iM
        6SfmsYfro8yvj
X-Received: by 2002:adf:f052:: with SMTP id t18mr843741wro.192.1583174437796;
        Mon, 02 Mar 2020 10:40:37 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtSCmyJMl6nNhdF+/IiPnFSvzDLY5HhUSAjLCgUbNnWjPpkV9WfUZ8BhJ7H0sUd3owvA5Gz4Q==
X-Received: by 2002:adf:f052:: with SMTP id t18mr843730wro.192.1583174437573;
        Mon, 02 Mar 2020 10:40:37 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f195sm397757wmf.17.2020.03.02.10.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 10:40:36 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Oliver Upton <oupton@google.com>
Subject: Re: [GIT PULL] KVM changes for Linux 5.6-rc4
In-Reply-To: <1582570669-45822-1-git-send-email-pbonzini@redhat.com>
References: <1582570669-45822-1-git-send-email-pbonzini@redhat.com>
Date:   Mon, 02 Mar 2020 19:40:35 +0100
Message-ID: <87zhcyfvmk.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

>       KVM: nVMX: Don't emulate instructions in guest mode

I just discovered that this patch breaks Hyper-V on KVM completely;
Oliver's 86f7e90ce8 ("KVM: VMX: check descriptor table exits on
instruction emulation") doesn't fix it either. The breakage manifests
itself as

 qemu-system-x86-23579 [005] 22018.775584: kvm_exit:             reason EPT_VIOLATION rip 0xfffff802987d6169 info 181 0
 qemu-system-x86-23579 [005] 22018.775584: kvm_nested_vmexit:    rip fffff802987d6169 reason EPT_VIOLATION info1 181 info2 0 int_info 0 int_info_err 0
 qemu-system-x86-23579 [005] 22018.775585: kvm_page_fault:       address febd0000 error_code 181
 qemu-system-x86-23579 [005] 22018.775592: kvm_emulate_insn:     0:fffff802987d6169: f3 a5
 qemu-system-x86-23579 [005] 22018.775593: kvm_emulate_insn:     0:fffff802987d6169: f3 a5 FAIL
 qemu-system-x86-23579 [005] 22018.775596: kvm_inj_exception:    #UD (0x0)

We probably need to re-enable instruction emulation for something...

-- 
Vitaly

