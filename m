Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE1B3D7A14
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 17:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236848AbhG0PqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 11:46:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54400 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229569AbhG0PqR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Jul 2021 11:46:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627400776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qyu2Y2TRrxflVv9Re1ddIxikd/FHNJ3gk/I5zZBEQ38=;
        b=I+HLilGqJ0edziQMxkDK0r7+lFWLygv/kgqIq5UhNf2HLo6bvTJu9EbUuzFKxD9PTCo8WK
        LKuFpwPxzHrFbhKCxZuH/nKj3Bs+L8sfX6N4tdbFt6IwtMJK1bVCEmuzsh2BH3PDphwYy4
        THozO+iCk6y/Ywi7uOr5QBrWKQ1yFyg=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-lnq_LN0uPrOevRmROBlhkA-1; Tue, 27 Jul 2021 11:46:15 -0400
X-MC-Unique: lnq_LN0uPrOevRmROBlhkA-1
Received: by mail-qv1-f69.google.com with SMTP id t18-20020a0cd4120000b02902fbda5d4988so10880074qvh.11
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 08:46:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qyu2Y2TRrxflVv9Re1ddIxikd/FHNJ3gk/I5zZBEQ38=;
        b=V4tbCj+nmd7b8hVdE6K0gBVb4ShxohCv8gNOWEOoAWfR49/FcBWjmWBcHSHtK+9x6j
         jutU8busKB5iYUP3O4r4bFst5ZvMlClREjRJPyxQSJETOc5b1vjuGFZ7m4mjZzvrrByj
         xPSwd+InqV5XBegxuYDuUg1jBFVZRxqemV+HvQLzo+YDZkdejm1wT44UYal4xYVdZx68
         umX0ke/G9+BeShSK8BRDCebWi+5ffpdaxOBFOh+p7apHJpsNzbb7Lv+/RYzeoCUoKBDQ
         gcvUp+3c8HXehjVDw8AScospcDVrLjaBt78/1weuZYUIYlvNtqRHbx1G1NXrHcoapOcK
         o8hQ==
X-Gm-Message-State: AOAM530MO+73YuzInwETfeE3GUfl9TDsxls6gNOTWXUHw14ZZxp6u/g+
        olZmuXAxUHQ4dAP+QqPD72K+bxTF0lb0LsZyYzlQ+xGvxtaLMRg5eFkG+PaNR0LuMiSsLskvl3t
        jcyBWUQHZJ16b
X-Received: by 2002:a05:620a:1137:: with SMTP id p23mr23880575qkk.490.1627400775130;
        Tue, 27 Jul 2021 08:46:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhTawW9W+VTgqHYhIOqH2k2b/KQYhF35BYDKPB7IDZDwwML1ltc1GzD2gc42Ak+yJCkznYwA==
X-Received: by 2002:a05:620a:1137:: with SMTP id p23mr23880554qkk.490.1627400774782;
        Tue, 27 Jul 2021 08:46:14 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id f3sm1570573qti.65.2021.07.27.08.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 08:46:13 -0700 (PDT)
Date:   Tue, 27 Jul 2021 11:46:12 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: add missing compat KVM_CLEAR_DIRTY_LOG
Message-ID: <YQAqRB7OPHHQNdJ+@t490s>
References: <20210727124901.1466039-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210727124901.1466039-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 27, 2021 at 08:49:01AM -0400, Paolo Bonzini wrote:
> The arguments to the KVM_CLEAR_DIRTY_LOG ioctl include a pointer,
> therefore it needs a compat ioctl implementation.  Otherwise,
> 32-bit userspace fails to invoke it on 64-bit kernels; for x86
> it might work fine by chance if the padding is zero, but not
> on big-endian architectures.
> 
> Reported-by: Thomas Sattler
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

