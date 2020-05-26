Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAAA11E2559
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 17:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgEZPWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 11:22:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38028 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729080AbgEZPWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 11:22:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590506526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R3+ppRcVa8JUx5xospoY4qvA4Dy/RVPkzAWBhYz6jMk=;
        b=Pol1PaBbQVQbvhEI0BY3hwJX/8QcbkfpFbe9LEacNJXLIVahE2tA/oPJUZg9ovhV8VTWlK
        +ajhFbQ8nBrwAYtw6NdNIec0AK0M01H3nqRP2TjpiNOFWoOwbx77KpWBrJZfTl9AXviOxj
        0v+zORrjnvgE8ms5hkmuzDd+pqwn0xs=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-lolV68xTPfWCbs7-foABTQ-1; Tue, 26 May 2020 11:21:56 -0400
X-MC-Unique: lolV68xTPfWCbs7-foABTQ-1
Received: by mail-qv1-f69.google.com with SMTP id i1so19834586qvo.21
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 08:21:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R3+ppRcVa8JUx5xospoY4qvA4Dy/RVPkzAWBhYz6jMk=;
        b=EC8/QbsU/2/Sz8LmMqmySKSj++FUFlpqJB6OaGZejdp00RotMIeg7lXBaVyaoS4vOW
         hynMxlN0n2JniQ+22I7IBrN797bzqcJbRdLUo1zS8uufMxcX9nS+N6GCiP7M1M+9SYr7
         Br5JQTJABbavEvLm3/luJ/a0e3yccPZfDcforL21btkunOneAQXMOuOuao78II7jYLoO
         jULEw77izu4zr0K4YlrkSeVCnQdZFiyuf5xkalTyTHS2kSIgKbmRN8V3xPdzH0BPHi+y
         bRG3Jx3q6lEps73vBos3qlVnwUZtKMdOIgdA0GmHmewtkMUMeMSsXqqblgxUfbVpnQ+D
         4WZA==
X-Gm-Message-State: AOAM532lAfHFH0rFVFJmM5uKquvw8LaAYZyQceZYGc83QRT9fDsWceB6
        kM1inaIryfV6K8yqN+SI3fKanIZqKv3eLZcyKpyOpbfIeNZuuz5FTvKg4Wv6U5CjJrQAb/E2nDL
        wijcWovqBXdI7
X-Received: by 2002:a37:8485:: with SMTP id g127mr1722248qkd.119.1590506515955;
        Tue, 26 May 2020 08:21:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6I359ATFqenFd4WKNpAxEarPbZQCXQ/leY7dTJyfr+l/Cwhca0PRwy+0p6X3ojbPmmxjSCQ==
X-Received: by 2002:a37:8485:: with SMTP id g127mr1722213qkd.119.1590506515664;
        Tue, 26 May 2020 08:21:55 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id w68sm7877836qkc.68.2020.05.26.08.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 08:21:54 -0700 (PDT)
Date:   Tue, 26 May 2020 11:21:52 -0400
From:   Peter Xu <peterx@redhat.com>
To:     kbuild test robot <lkp@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kbuild-all@lists.01.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v9 07/14] KVM: Don't allocate dirty bitmap if dirty ring
 is enabled
Message-ID: <20200526152152.GA1194141@xz-x1>
References: <20200523225659.1027044-8-peterx@redhat.com>
 <20200526150547.GC30967@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200526150547.GC30967@xsang-OptiPlex-9020>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 26, 2020 at 11:05:47PM +0800, kbuild test robot wrote:
> >> arch/x86/kvm/mmu/mmu.c:1280:3: warning: Returning an integer in a function with pointer return type is not portable. [CastIntegerToAddressAtReturn]
>      return false;
>      ^

A rebase accident for quite a few versions...  Fixed.

-- 
Peter Xu

