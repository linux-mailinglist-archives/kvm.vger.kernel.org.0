Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B4C3DA8E3
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 18:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhG2QYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 12:24:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34346 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229963AbhG2QYA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 12:24:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627575836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8XlvRujXH8fG7I60x6Lze35EmuQmao4vXlcoc/uU2No=;
        b=fYIAmzqj4bXwTj/VEEIGtYhI/HUVIKam1YgBWmch9CXa25I0r3koOWTKi977uBQuVztHxp
        Vy71Qn3rMLfywr1h0ufTyf2p84j5tJoI5mMPRXjK8qlRCFo/VjniTN1WR/90zaIIK1Diz9
        E4Q4orpAqTNU4oERQUtpxk0IZNph+ek=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-5aMU5CGFO6-mvWqgfGC9Vw-1; Thu, 29 Jul 2021 12:22:30 -0400
X-MC-Unique: 5aMU5CGFO6-mvWqgfGC9Vw-1
Received: by mail-il1-f197.google.com with SMTP id g9-20020a92cda90000b029020cc3319a86so3515528ild.18
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 09:22:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8XlvRujXH8fG7I60x6Lze35EmuQmao4vXlcoc/uU2No=;
        b=Dyw4A1QUPOXhLW0fafpp2YWPgDZrpKf2MhWYLwULtMB5mtIK3nYLyvdjL3vK8JE5/S
         574UOP4S8Fs4cAPKXkE17tq4ORGqGnTfd5TeUDK4msW5igxHYQDhaUjaVMHbtKI7AQE5
         SbXDO3VDbrOkvArkwcGzYnVRh1hxK3DphDes8tF+p/vjLYqVSRuMgtd0FcYT1WkyhLjO
         CihMiG1vG8yaf1UobETewIEsRB9yEjMHnK2Smbe/h++GLTPvqgmL9SJf7bvOuCNLFmlw
         T47qdFFXE/BpQMOPuG2MucwylcReGPxtL8RwTZeJScvAONeMmYvQ1efj2+LsygY0a/WT
         otEw==
X-Gm-Message-State: AOAM531Ewcu0pey/+WS+UWrf6tVVlJ4YOX0Wip8Wf5OyqIh4T3rA91lW
        3ECE7FZLUM2BroyKyeiWcz7YL3NkZGL+/W7jE0HeCMNusn6OFFhhJlbFK6GgY5QLJY4M+R62q3/
        OzmDSIjLIxUFS
X-Received: by 2002:a92:d4c4:: with SMTP id o4mr4032649ilm.39.1627575749932;
        Thu, 29 Jul 2021 09:22:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4Fgu9rQ1o/mvPKtWpoTLqejJyf90dyQNVh+Lg+zjo1jBFHEmgfOa/z3eVTuadhwo9KRb6mQ==
X-Received: by 2002:a92:d4c4:: with SMTP id o4mr4032632ilm.39.1627575749732;
        Thu, 29 Jul 2021 09:22:29 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id p1sm1929221ilh.47.2021.07.29.09.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 09:22:29 -0700 (PDT)
Date:   Thu, 29 Jul 2021 18:22:26 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 06/13] selftests: KVM: Fix kvm device helper ioctl
 assertions
Message-ID: <20210729162226.a6csfjpzhhpdgv7o@gator>
References: <20210729001012.70394-1-oupton@google.com>
 <20210729001012.70394-7-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729001012.70394-7-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 29, 2021 at 12:10:05AM +0000, Oliver Upton wrote:
> The KVM_CREATE_DEVICE and KVM_{GET,SET}_DEVICE_ATTR ioctls are defined
> to return a value of zero on success. As such, tighten the assertions in
> the helper functions to only pass if the return code is zero.
> 
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 10a8ed691c66..0ffc2d39c80d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1984,7 +1984,7 @@ int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr)
>  {
>  	int ret = _kvm_device_check_attr(dev_fd, group, attr);
>  
> -	TEST_ASSERT(ret >= 0, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
> +	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
>  	return ret;
>  }
>  
> @@ -2008,7 +2008,7 @@ int kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test)
>  	ret = _kvm_create_device(vm, type, test, &fd);
>  
>  	if (!test) {
> -		TEST_ASSERT(ret >= 0,
> +		TEST_ASSERT(!ret,
>  			    "KVM_CREATE_DEVICE IOCTL failed, rc: %i errno: %i", ret, errno);
>  		return fd;
>  	}
> @@ -2036,7 +2036,7 @@ int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
>  {
>  	int ret = _kvm_device_access(dev_fd, group, attr, val, write);
>  
> -	TEST_ASSERT(ret >= 0, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
> +	TEST_ASSERT(!ret, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
>  	return ret;
>  }
>  
> -- 
> 2.32.0.432.gabb21c7263-goog
>
 
Reviewed-by: Andrew Jones <drjones@redhat.com>

