Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E36268B55
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 14:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgINMng (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 08:43:36 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40908 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726282AbgINMmy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Sep 2020 08:42:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600087372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T8zmsg/IzMXQyj8cUpKUiHl2M6KcAvulktd+iXwdmgU=;
        b=QZ9cLYTREcCBxCFLiK3aEyC19dIbTX0/LYhEJ6aTPr5Oc75tYis480yg+srlIg2vWi32Ak
        1U2SphkDWDwHjqnqQMSENn9APIoYEuwgm1UZMXAnVUybrrv4ife7eNcowl/gmy564uZUFp
        IvBtc+la+KF9CBkoprHD//7QxxL88Ow=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-fL3tJiDlNdaTllNEWhlf4g-1; Mon, 14 Sep 2020 08:42:50 -0400
X-MC-Unique: fL3tJiDlNdaTllNEWhlf4g-1
Received: by mail-wm1-f72.google.com with SMTP id 189so3198994wme.5
        for <kvm@vger.kernel.org>; Mon, 14 Sep 2020 05:42:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=T8zmsg/IzMXQyj8cUpKUiHl2M6KcAvulktd+iXwdmgU=;
        b=Ge5+NuCUewJgeJ9CA7GprZfIcera//BQQa9e53/JXAvyUplEQ4Fl42tWHu6uTh4lB5
         B/MkeLIVr8+xOM721UF7f1i6EwlBy7c2GlgBP/t/UXG8zB8GUe9vl3+EwjJ6Qb/kRNGj
         f2/fSpqkSdWf0UFKOSVtc5wz176jiRGnqZzLGCU4EV/8NQPWE4pE6MQ3ROpFj1dIzm1J
         7MSa2km58cqPryaeuf8mAfvVLsBxGdjUtkviEHF0wACsOXmtgdM+unVv9iAO2dWwzK+L
         1PFi1J+o7Zj1boVQN+holTsKB5SqkvyieUeO/Z+u5bNBSbiXnjUvj0Xd88CxkOjCr03+
         eM0Q==
X-Gm-Message-State: AOAM533rIBj0M4NbBOpHsbRuE2V4NDhJzxpmFZ+bCHKz3971JKMmll+5
        AUEavHtrEilXpb2rfwbkvdmufTbTxVsDFp5hGHNx/zv/PP5BHD/DznjDqZjiua3qBhkqdJ4K0/m
        OJdRVOUWl6FzS
X-Received: by 2002:a1c:7c17:: with SMTP id x23mr15434379wmc.165.1600087369059;
        Mon, 14 Sep 2020 05:42:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzM2KGE27VpiDVo0EKU6XP0gmV9o3FvYQekntQ/j/Jkrdv352DRtXPJ8l/IQ9rcW9PPt8/gmg==
X-Received: by 2002:a1c:7c17:: with SMTP id x23mr15434355wmc.165.1600087368808;
        Mon, 14 Sep 2020 05:42:48 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k6sm17725600wmi.1.2020.09.14.05.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 05:42:48 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Colin King <colin.king@canonical.com>
Subject: Re: [PATCH -tip] KVM: SVM: nested: Initialize on-stack pointers in svm_set_nested_state()
In-Reply-To: <20200914121304.GC4414@suse.de>
References: <20200914115129.10352-1-joro@8bytes.org> <87ft7klg38.fsf@vitty.brq.redhat.com> <20200914121304.GC4414@suse.de>
Date:   Mon, 14 Sep 2020 14:42:47 +0200
Message-ID: <87d02olebc.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Joerg Roedel <jroedel@suse.de> writes:

> Hi Vitaly,
>
> On Mon, Sep 14, 2020 at 02:04:27PM +0200, Vitaly Kuznetsov wrote:
>> this was previously reported by Colin:
>> https://lore.kernel.org/kvm/20200911110730.24238-1-colin.king@canonical.com/
>> 
>> the fix itself looks good, however, I had an alternative suggestion on how
>> to fix this:
>> https://lore.kernel.org/kvm/87o8mclei1.fsf@vitty.brq.redhat.com/
>
> This looks good to me, mind sending your diff as a patch with correct
> Fixes tag?
>

Sure, I was under the impression your "KVM: SVM: nested: Don't allocate
VMCB structures on stack" is not commited yet and it can be fixed but I
now see that it made it to 'tip' tree. Will send the patch out shortly.

-- 
Vitaly

