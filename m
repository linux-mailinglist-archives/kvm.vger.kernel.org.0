Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9411C7C3F
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 23:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbgEFVTh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 17:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728621AbgEFVTh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 17:19:37 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BA3C061A0F
        for <kvm@vger.kernel.org>; Wed,  6 May 2020 14:19:37 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id q10so3241712ile.0
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 14:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UdGUebmYhj34sXXz4/gfkMRluMVMoxZCbr/Vo1r6b6c=;
        b=TJP7GIcQxDHhteVTcWcaKBaQRwSAgSvrCxtU2yu0ckEG4ewGHIaiIknnU3PqbsAqWl
         lp5q7nfOwefULix+L6wn6rw2f7LTrQpIr61M4H/tfQfUxCBx9eoCGI5yepmGRT8TvUxK
         ICxTwVAi9lvht2kvBxwbuaGCHWz/bLZ+YImAR6ak9lHVzmku09Ah7OKQ0LM7EefRFOVm
         Q97lBhUrD5rY6dVebVEA2SgjApbkJZxhmNRM0zoHanGRI/5h0M9Fj4+7+sH0iRNqRBCo
         DqQSIdRyC+i4BaxrCV9lPzc0cX4JzRXHztE7oprzUSHJguXMq/Mcy9qKSHj1YSzXubEK
         j2LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UdGUebmYhj34sXXz4/gfkMRluMVMoxZCbr/Vo1r6b6c=;
        b=naFXdsdfLkmeg5lapZwgNlqVUOLSYZWohQZ0jSvz9vtwKHZjUBD4VX1AywtFeX9bTy
         e57qsAegA3sZuJPU20EzKVv5WAUNa7dSxmuPT1CmY/L1/VsnVPypoOW36ESXFl1zWsAn
         oyxKNZX5CjtlW1g1E6DzBS7Gp0dTMBvhTI0/pjuCCWET7Ydce4Up8margxOLiaOsjo81
         fQMyMFS32CfUp/sOJRFje4vIR7QRCATrxK/NFqoJaETTAXpE7dhsejBRiZY0kQz8dd9j
         /l5sRybNCB3lWDqIvVwROOhDDte4Rl82la5CkRoe2QAJSpVD7yn76njAUBClKE1ZcOnt
         Oejg==
X-Gm-Message-State: AGi0PuYTTZJJmoi6LjuP6uEFzHC0JezioEhSVqwzVX5uKvHeUiK2aC0F
        hdgGdy/JntT+tfi0sosVHkcfomNZf5A5GBT2+Lx14Q==
X-Google-Smtp-Source: APiQypJwyeQORbeD/PvDFZY5unv3m+3b1J31pHftGy1dVo1BsJvrcLBXS6mbqchIrJMuAYFEH+SmaLP50wW049cWNGo=
X-Received: by 2002:a92:3d85:: with SMTP id k5mr11534107ilf.26.1588799976294;
 Wed, 06 May 2020 14:19:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200506204653.14683-1-sean.j.christopherson@intel.com>
In-Reply-To: <20200506204653.14683-1-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 6 May 2020 14:19:25 -0700
Message-ID: <CALMp9eSbB=Hwy+uGik4SSSwe1_pu82XY9_SmAWYz2KLY_Ek7=Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Remove unused 'ops' param from nested_vmx_hardware_setup()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 6, 2020 at 1:46 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Remove a 'struct kvm_x86_ops' param that got left behind when the nested
> ops were moved to their own struct.
>
> Fixes: 33b22172452f0 ("KVM: x86: move nested-related kvm_x86_ops to a separate struct")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
