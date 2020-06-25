Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0DA209BF7
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 11:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390874AbgFYJeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 05:34:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42568 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390163AbgFYJeW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 05:34:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593077660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X3/CoGz/NWenAAMC8TdUU7tz4aPqJHOm/DKPIoXzmHs=;
        b=NMNPIkKGrfpz+NxoQnjW2qQ87jk0VDOpTejnPv/2q0EJC9L7u+/wlwCDMKK1ZNMHkTfJ0R
        66kRWYJ3T1+7uHYmybR+r0BvtokNty4xJES7v/JvV+jao+1BCTIqjBujPnfWpxSt8YLX1Z
        GdtiJPOKRAAQYclvz3e5r3luwdE15vI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-u2ypsmkfOOO4sqmYa4yhhg-1; Thu, 25 Jun 2020 05:34:18 -0400
X-MC-Unique: u2ypsmkfOOO4sqmYa4yhhg-1
Received: by mail-wr1-f70.google.com with SMTP id z3so6428794wrr.7
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 02:34:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=X3/CoGz/NWenAAMC8TdUU7tz4aPqJHOm/DKPIoXzmHs=;
        b=myk3NeOsfr/XlUj5NoPcTed+qi6lO5wPQM1iSj9FSQSGxRiw285d68HtoIrTrd5q6o
         KSGYYIbI1hELLbzGpojqR59bF9BU0yeD3WUr6zC+8utu0kdYCVj10jj52yfycbWf213H
         kwJs+DiRX0riemSwlKzpI+N9YtAqU5hZvdw7lfGRYgwwoCTUIDPd2yh8SCc8haDvNA9Y
         akjQfsQGy3jK919trolkyEgcpiGSMRD1ADDoATE0X79iIqQMW/K84v/Iuc5G4cA8aoxj
         OJAPdPQeuGp/bGNt8ED+EzUOXWa0irszAFk2EG7s8pUdKW3fWKhQa3ibT88JUUVjPNH9
         1B8g==
X-Gm-Message-State: AOAM530lc2TqusBDiYKVwyZScXQxfa92rlHC+tNCvnv16wy2ZvAIhDuI
        9GV/o2FTheoANeECfRkQDmWZ5s52BMczghAZgZcwA/nLVXJFxEvQPEVV0WviHPNYum9qJdHgo8U
        V1gcO/TOGRhEp
X-Received: by 2002:adf:e648:: with SMTP id b8mr36650753wrn.386.1593077657058;
        Thu, 25 Jun 2020 02:34:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxO9rxFO6NydlVlkFTYJOZIr4JNxTX3tcKMvj9G0tZ4+At9YfEzvpMMWp1NSAjw90OcVZBk8g==
X-Received: by 2002:adf:e648:: with SMTP id b8mr36650724wrn.386.1593077656790;
        Thu, 25 Jun 2020 02:34:16 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c66sm12336747wma.20.2020.06.25.02.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 02:34:16 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 0/4] KVM: SVM: Code move follow-up
In-Reply-To: <20200625080325.28439-1-joro@8bytes.org>
References: <20200625080325.28439-1-joro@8bytes.org>
Date:   Thu, 25 Jun 2020 11:34:14 +0200
Message-ID: <87r1u3cwvd.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Joerg Roedel <joro@8bytes.org> writes:

> From: Joerg Roedel <jroedel@suse.de>
>
> Hi,
>
> here is small series to follow-up on the review comments for moving
> the kvm-amd module code to its own sub-directory. The comments were
> only about renaming structs and symbols, so there are no functional
> changes in these patches.
>
> The comments addressed here are all from [1].
>
> Regards,
>
> 	Joerg
>
> [1] https://lore.kernel.org/lkml/87d0917ezq.fsf@vitty.brq.redhat.com/
>

Thank you for the follow-up!

> Joerg Roedel (4):
>   KVM: SVM: Rename struct nested_state to svm_nested_state
>   KVM: SVM: Add vmcb_ prefix to mark_*() functions
>   KVM: SVM: Add svm_ prefix to set/clr/is_intercept()
>   KVM: SVM: Rename svm_nested_virtualize_tpr() to
>     nested_svm_virtualize_tpr()
>
>  arch/x86/kvm/svm/avic.c   |   2 +-
>  arch/x86/kvm/svm/nested.c |   8 +--
>  arch/x86/kvm/svm/sev.c    |   2 +-
>  arch/x86/kvm/svm/svm.c    | 138 +++++++++++++++++++-------------------
>  arch/x86/kvm/svm/svm.h    |  20 +++---
>  5 files changed, 85 insertions(+), 85 deletions(-)

Series:
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

