Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3633939C767
	for <lists+kvm@lfdr.de>; Sat,  5 Jun 2021 12:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhFEK2H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Jun 2021 06:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbhFEK2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Jun 2021 06:28:05 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBC7C061766
        for <kvm@vger.kernel.org>; Sat,  5 Jun 2021 03:26:16 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q15so9832431pgg.12
        for <kvm@vger.kernel.org>; Sat, 05 Jun 2021 03:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A7dQxJYaCXMIhpLLE5OL3sgALzOxVshV1s/+sLvv2mA=;
        b=OfAr6bXPncM5uCFphXI3MFVT/USlPReB4Lv8lg9guId8a5OyRnU3TmEG268l1svDiJ
         zUwbjqFmUagVzzvnEjoHMWg4peiz3tmUEy+NrpqiERcrK0cQPtfYOlfrvbho+hVfe590
         sBIU+3QRk0cfCwuQEx3Gz7m2viUmv5GHIO2Rg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A7dQxJYaCXMIhpLLE5OL3sgALzOxVshV1s/+sLvv2mA=;
        b=BxBFUMq/hmDYxteA5fjMGhOQLEW24ykOIhjPUHhUi11xGhq3+gV88L0ValyICCK4OG
         ggD2bNUTjc6OJVleIBuqgW2ZfjMo29mBqY0B7zwY0RbDMBcihzQrVweQK8Q4pp8bdcBm
         FMhrIgx533ivxmMGL93X/Onkt8Py9++wbrH1/Ef0z4xEwh6RgnsYPL/L9LK+SbeQ6S9w
         acUHAkqYB07KePMJI/hdIqyjGQuRL1J9LVhAoljLFi90yoYC4gvNFWQZRx6eoI88UW/r
         3NOaexLaPi4M+WfAB16xv/6zNOYF6Nim9t5EkML2+rD0kT+ug741U7sMEBQYIppRyE6q
         4NCQ==
X-Gm-Message-State: AOAM532fbe4ju9gYbI44/WHgcUcP7V5LXG8M/7CUpVgLremVI1vBOvZs
        WnGT2xB0+t0Q6SS00ho90PNVCg==
X-Google-Smtp-Source: ABdhPJyVnf1Sfj9IsodJVK9bc2KmHiVTZ1LFECsZ//Q95AMgY73GH+UrJw92aQL39XgpHtR6Pw2eYw==
X-Received: by 2002:a63:db17:: with SMTP id e23mr9327049pgg.274.1622888776525;
        Sat, 05 Jun 2021 03:26:16 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:5981:261e:350c:bb45])
        by smtp.gmail.com with ESMTPSA id j10sm6815520pjb.36.2021.06.05.03.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jun 2021 03:26:16 -0700 (PDT)
Date:   Sat, 5 Jun 2021 19:26:11 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Suleiman Souhlal <suleiman@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] kvm: x86: implement KVM PM-notifier
Message-ID: <YLtRQ/uYQoVbve0v@google.com>
References: <20210605023042.543341-1-senozhatsky@chromium.org>
 <20210605023042.543341-2-senozhatsky@chromium.org>
 <87k0n8u1nk.wl-maz@kernel.org>
 <YLtK09pY1EjOtllS@google.com>
 <YLtL/JPvGs2efZKO@google.com>
 <87im2sty5k.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87im2sty5k.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On (21/06/05 11:15), Marc Zyngier wrote:
> > For the time being kvm_set_guest_paused() errors out when
> > !vcpu->arch.pv_time_enabled, but this probably can change in the
> > future (who knows?).  So shall I check vcpu->arch.pv_time_enabled in
> > kvm_arch_suspend_notifier()?
> 
> That, or check for the -EINVAL return value.

I suppose this should do the trick then (hate to do `int ret = 0`,
but we can have no VCPUs with enabled pv_time)

---

+static int kvm_arch_suspend_notifier(struct kvm *kvm)
+{
+       struct kvm_vcpu *vcpu;
+       int i, ret = 0;
+
+       mutex_lock(&kvm->lock);
+       kvm_for_each_vcpu(i, vcpu, kvm) {
+               if (!vcpu->arch.pv_time_enabled)
+                       continue;
+
+               ret = kvm_set_guest_paused(vcpu);
+               if (ret) {
+                       pr_err("Failed to pause guest VCPU%d: %d\n",
+                              vcpu->vcpu_id, ret);
+                       break;
+               }
+       }
+       mutex_unlock(&kvm->lock);
+
+       return ret ? NOTIFY_BAD : NOTIFY_DONE;
+}
