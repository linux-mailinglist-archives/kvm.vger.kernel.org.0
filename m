Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1D0141914
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 20:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgARTSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 14:18:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30253 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726658AbgARTSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jan 2020 14:18:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579375121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PO53Nh/QDBexFAMxBK/qaVg7IyBqvhu5qSZP9QJ0NVU=;
        b=RygIeeXDr6lHe4nG+mQrb0DZ6QHR7CXNqlL+lZrWeVSqoQz/ld5IIMzpCxyNTiP62K7DeI
        85APsnzCtHU5Q5lo5uyQzLCI8fuGot7a1z3Ks7rpqKooLxzW2eKu047PlD2PcjjuVi0X4V
        Kx68eRdq9NCs4XG/xD2zs0bVMG97x7s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-9OaiS5daOCSzkZLWst0Jfw-1; Sat, 18 Jan 2020 14:18:39 -0500
X-MC-Unique: 9OaiS5daOCSzkZLWst0Jfw-1
Received: by mail-wr1-f70.google.com with SMTP id f15so12135266wrr.2
        for <kvm@vger.kernel.org>; Sat, 18 Jan 2020 11:18:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PO53Nh/QDBexFAMxBK/qaVg7IyBqvhu5qSZP9QJ0NVU=;
        b=RsGm6qk4iLi41PE1HSU9bY7g21zuCIow3xT+Xunefu33Dn12AFnHHJG/rF6m+BH6CO
         hva8MSlArAMIrA+0NWpVlbPKi0JZOp+0yfdgvUacwrtn28RSZd0HT/eMnXhBMptDEwz4
         41yShCec7r6i6YCJTbBcs/YxMuiydFysJv4qH6GEHp/4Ah7VnOKpM3k7HNjMySNkCRtL
         Q/lBovAGwF7G0Bz6HrfpW+3cug9cFE8DBAlwYx626ERAT7i3D/1wB2fDEH6RAoITZ/kn
         IFtWGDZ1oSDfJyY1M0F+YW8l8x4o6KcubNukMwSKaD0hYUgaX9ZDJPUcUvvsQm199oZt
         Qpuw==
X-Gm-Message-State: APjAAAXR6WU7TNTQGLFqDOWOQU7JfyQCybR4MokqSctclPPfjz0nqazx
        YWnW9yF+k6RTLUu0YinD8pvaEyPQgNu/x8JEwikDAzvuhby68Bq2lgKqdfUln52ejQWSEv+KTcU
        fPxcpbXZrUawT
X-Received: by 2002:a5d:6305:: with SMTP id i5mr9462247wru.119.1579375118505;
        Sat, 18 Jan 2020 11:18:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqz0eeGKG8TzqwdkZ1NU4s60/8TS2iOlSLDcaliOhiJzQLRFL+EclZIdeYSmcTUZ9zpBmIOVDg==
X-Received: by 2002:a5d:6305:: with SMTP id i5mr9462227wru.119.1579375118241;
        Sat, 18 Jan 2020 11:18:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e0d6:d2cd:810b:30a9? ([2001:b07:6468:f312:e0d6:d2cd:810b:30a9])
        by smtp.gmail.com with ESMTPSA id p26sm14642464wmc.24.2020.01.18.11.18.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 11:18:37 -0800 (PST)
Subject: Re: [PATCH] tools/kvm_stat: Fix kvm_exit filter name
To:     Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, drjones@redhat.com
References: <20191210044829.180122-1-gshan@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e02c2678-2b08-8af0-5847-6a2d81d58370@redhat.com>
Date:   Sat, 18 Jan 2020 20:18:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191210044829.180122-1-gshan@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/19 05:48, Gavin Shan wrote:
> The filter name is fixed to "exit_reason" for some kvm_exit events, no
> matter what architect we have. Actually, the filter name ("exit_reason")
> is only applicable to x86, meaning it's broken on other architects
> including aarch64.
> 
> This fixes the issue by providing various kvm_exit filter names, depending
> on architect we're on. Afterwards, the variable filter name is picked and
> applied through ioctl(fd, SET_FILTER).
> 
> Reported-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  tools/kvm/kvm_stat/kvm_stat | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
> index ad1b9e646c49..f9273614b7e3 100755
> --- a/tools/kvm/kvm_stat/kvm_stat
> +++ b/tools/kvm/kvm_stat/kvm_stat
> @@ -270,6 +270,7 @@ class ArchX86(Arch):
>      def __init__(self, exit_reasons):
>          self.sc_perf_evt_open = 298
>          self.ioctl_numbers = IOCTL_NUMBERS
> +        self.exit_field = 'exit_reason'
>          self.exit_reasons = exit_reasons
>  
>      def debugfs_is_child(self, field):
> @@ -289,6 +290,7 @@ class ArchPPC(Arch):
>          # numbers depend on the wordsize.
>          char_ptr_size = ctypes.sizeof(ctypes.c_char_p)
>          self.ioctl_numbers['SET_FILTER'] = 0x80002406 | char_ptr_size << 16
> +        self.exit_field = 'exit_nr'
>          self.exit_reasons = {}
>  
>      def debugfs_is_child(self, field):
> @@ -300,6 +302,7 @@ class ArchA64(Arch):
>      def __init__(self):
>          self.sc_perf_evt_open = 241
>          self.ioctl_numbers = IOCTL_NUMBERS
> +        self.exit_field = 'ret'
>          self.exit_reasons = AARCH64_EXIT_REASONS
>  
>      def debugfs_is_child(self, field):
> @@ -311,6 +314,7 @@ class ArchS390(Arch):
>      def __init__(self):
>          self.sc_perf_evt_open = 331
>          self.ioctl_numbers = IOCTL_NUMBERS
> +        self.exit_field = None
>          self.exit_reasons = None
>  
>      def debugfs_is_child(self, field):
> @@ -541,8 +545,8 @@ class TracepointProvider(Provider):
>          """
>          filters = {}
>          filters['kvm_userspace_exit'] = ('reason', USERSPACE_EXIT_REASONS)
> -        if ARCH.exit_reasons:
> -            filters['kvm_exit'] = ('exit_reason', ARCH.exit_reasons)
> +        if ARCH.exit_field and ARCH.exit_reasons:
> +            filters['kvm_exit'] = (ARCH.exit_field, ARCH.exit_reasons)
>          return filters
>  
>      def _get_available_fields(self):
> 

Queued, thanks.

Paolo

